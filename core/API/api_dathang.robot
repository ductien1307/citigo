*** Settings ***
Resource          ../../config/env_product/envi.robot
Library           Collections
Resource          api_khachhang.robot
Resource          api_access.robot
Resource          api_mhbh.robot
Resource          api_danhmuc_hanghoa.robot
Resource          ../share/computation.robot
Resource          ../Dat_Hang/dat_hang_action.robot

*** Variables ***
${endpoint_order}    /Orders?format=json&%24top=150
${endpoint_order_detail}    /orders/{0}?Includes=TotalQuantity&Includes=Seller&Includes=Cashier&Includes=User&Includes=Customer&Includes=Invoices    #id order
${endpoint_phieu_thanhtoan_dh}    /payments/?OrderId={0}&format=json&Includes=User&Includes=CustomerName&Includes=Order&GroupCode=true&%24inlinecount=allpages&%24top=100    # id order
${endpoint_order_payment}    /payments/?OrderId={0}&format=json&Includes=User&Includes=CustomerName&Includes=Order&GroupCode=true&%24inlinecount=allpages&%24top=100    # id order
${endpoint_pricebook}    /pricebook/getall?includeAll=true&Includes=PriceBookBranches&Includes=PriceBookCustomerGroups&Includes=PriceBookUsers&%24inlinecount=allpages&%24top=100
${endpoint_pricebook_detail}    /pricebook/getlistitems?PriceBookIds={0}&%24inlinecount=allpages   # id pricebook
${endpoint_invoice_history}    /invoices/?OrderId={0}&format=json&Includes=SoldBy&Include=TotalQuantity&Includes=PaymentCode&Includes=PaymentId&Includes=StatusValue&%24inlinecount=allpages&%24top=100    # id order
${endpoint_warranty_detail_in_order}   /invoice-warranty/list-by-product?OrderId={0}&ProductId={1}
${endpoint_order_history_by_customerid}    /orders?format=json&Includes=Seller&Includes=Branch&Includes=Customer&%24inlinecount=allpages&%24top=10&%24filter=(CustomerId+eq+{0}+and+PurchaseDate+eq+%27alltime%27+and+Status+ne+0+and+Status+ne+4)    #id customer
${endpoint_order_by_ordercode}    /Orders?format=json&Includes=Branch&Includes=Customer&Includes=Payments&Includes=Seller&Includes=User&Includes=InvoiceOrderSurcharges&Includes=DeliveryInfoes&Includes=DeliveryPackages&ForSummaryRow=true&ForManageScreen=true&Includes=SaleChannel&Includes=Invoices&Includes=OrderPromotions&Includes=InvoiceWarranties&%24inlinecount=allpages&CodeKey={0}&DescriptionKey=&DescriptionProductKey=&ProductCodeKey=&ProductNameKey=&CustomerKey=&UserNameKey=&UserNameCreatedKey=&InvoiceCode=&DeliveryCode=&ExpectedDeliveryFilterType=alltime

*** Keywords ***
Get order info
    [Arguments]    ${input_ma_dh}
    [Timeout]    5 minutes
    ${jsonpath_id_order}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_dh}
    ${get_id_order}    Get data from API    ${endpoint_order}    ${jsonpath_id_order}
    ${endpoint_order_detail}    Format String    ${endpoint_order_detail}    ${get_id_order}
    ${get_ma_kh_in_order}    Get data from API    ${endpoint_order_detail}    $.Customer.Code
    ${get_trangthai_in_order}    Get data from API    ${endpoint_order_detail}    $.StatusValue
    ${get_chinhanh_in_order}    Get data from API    ${endpoint_order_detail}    $.BranchId
    ${get_nguoinhandat_in_order}    Get data from API    ${endpoint_order_detail}    $.Seller.GivenName
    ${get_nguoitao_in_order}    Get data from API    ${endpoint_order_detail}    $.User.GivenName
    ${get_ten_kenh_bh}    Get data from API    ${endpoint_kenhbanhang}    $..Data..Name
    Return From Keyword    ${get_ma_kh_in_order}    ${get_trangthai_in_order}    ${get_chinhanh_in_order}    ${get_nguoinhandat_in_order}    ${get_nguoitao_in_order}    ${get_ten_kenh_bh}

Get list order summary by order code
    [Arguments]    ${input_ma_dh}
    [Timeout]    3 minutes
    ${jsonpath_id_order}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_dh}
    ${get_id_order}    Get data from API    ${endpoint_order}    ${jsonpath_id_order}
    ${endpoint_order_detail}    Format String    ${endpoint_order_detail}    ${get_id_order}
    ${get_list_ma_hh_in_order}    Get raw data from API    ${endpoint_order_detail}    $.OrderDetails..Code
    ${endpoint_pr}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${get_resp}    Get Request and return body    ${endpoint_pr}
    ${list_tong_dh}    Create List
    : FOR    ${ma_hh}    IN    @{get_list_ma_hh_in_order}
    \    ${jsonpath_tong_dh}    Format String    $..Data[?(@.Code == '{0}')].Reserved    ${ma_hh}
    \    ${get_tong_dh}    Get data from response json    ${get_resp}    ${jsonpath_tong_dh}
    \    ${get_ordersummary}    Convert To Number    ${get_tong_dh}
    \    Append To List    ${list_tong_dh}    ${get_ordersummary}
    Return From Keyword    ${list_tong_dh}

Get order summary by order code
    [Arguments]    ${input_ma_dh}
    [Timeout]    3 minutes
    ${jsonpath_id_order}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_dh}
    ${get_id_order}    Get data from API    ${endpoint_order}    ${jsonpath_id_order}
    ${endpoint_order_detail}    Format String    ${endpoint_order_detail}    ${get_id_order}
    ${ma_hh}    Get data from API    ${endpoint_order_detail}    $.OrderDetails..Code
    ${endpoint_pr}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${jsonpath_tong_dh}    Format String    $..Data[?(@.Code == '{0}')].Reserved    ${ma_hh}
    ${get_tong_dh}    Get data from API    ${endpoint_pr}    ${jsonpath_tong_dh}
    ${get_ordersummary}    Convert To Number    ${get_tong_dh}
    Return From Keyword    ${get_ordersummary}

Get result list total sale incase discount
    [Arguments]    ${list_product}    ${list_nums}    ${list_ggsp}    ${list_discount_type}
    [Timeout]    3 minutes
    ${result_list_thanhtien}    Create List
    ${get_list_giaban}    Get list of Baseprice by Product Code    ${list_product}
    : FOR    ${item_giaban}    ${item_soluong}    ${item_ggsp}    ${discount_type}    IN ZIP    ${get_list_giaban}    ${list_nums}
    ...    ${list_ggsp}    ${list_discount_type}
    \    ${result_giamoi}    Run Keyword If    '${discount_type}' == 'dis'    Price after % discount product    ${item_giaban}    ${item_ggsp}
    \    ...    ELSE IF    '${discount_type}' == 'disvnd'    Minus and round 2    ${item_giaban}    ${item_ggsp}
    \    ...    ELSE IF    '${discount_type}' == 'changeup' or '${discount_type}' == 'changedown'   Set Variable   ${item_ggsp}
    \    ...    ELSE     Set Variable    ${item_giaban}
    \    ${result_thanhtien}    Multiplication and round    ${result_giamoi}    ${item_soluong}
    \    Append to list    ${result_list_thanhtien}    ${result_thanhtien}
    Return From Keyword    ${result_list_thanhtien}

Get list order summary after create invoice
    [Arguments]    ${list_order_summary_bf_execute}    ${list_nums}
    [Timeout]    3 minutes
    ${list_result_order_summary}    Create List
    : FOR    ${item_order_summary}    ${item_soluong}    IN ZIP    ${list_order_summary_bf_execute}    ${list_nums}
    \    ${result_ordersummary_string}    Minus    ${item_order_summary}    ${item_soluong}
    \    ${result_ordersummary}    Convert To Number    ${result_ordersummary_string}
    \    ${result_ordersummary}    Set Variable If    ${result_ordersummary}>0    ${result_ordersummary}    0
    \    Append to list    ${list_result_order_summary}    ${result_ordersummary}
    Return From Keyword    ${list_result_order_summary}

Get order detail info with multi products
    [Arguments]    ${input_ma_dh}    ${input_ma_sp}
    [Timeout]    5 minutes
    ${jsonpath_id_order}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_dh}
    ${get_id_order}    Get data from API    ${endpoint_order}    ${jsonpath_id_order}
    ${endpoint_order_detail}    Format String    ${endpoint_order_detail}    ${get_id_order}
    ${jsonpath_ten_hh}    Format String    $.OrderDetails[?(@.Product.Code == '{0}')]..Name    ${input_ma_sp}
    ${jsonpath_soluong_hh}    Format String    $.OrderDetails[?(@.Product.Code == '{0}')]..Quantity    ${input_ma_sp}
    ${jsonpath_discount_hh}    Format String    $.OrderDetails[?(@.Product.Code == '{0}')]..Discount    ${input_ma_sp}
    ${jsonpath_giaban_hh}    Format String    $.OrderDetails[?(@.Product.Code == '{0}')]..Price    ${input_ma_sp}
    ${jsonpath_thanhtien_hh}    Format String    $.OrderDetails[?(@.Product.Code == '{0}')]..SubTotal    ${input_ma_sp}
    ${get_ten_hh_in_order}    Get data from API    ${endpoint_order_detail}    ${jsonpath_ten_hh}
    ${get_soluong_in_order}    Get data from API    ${endpoint_order_detail}    ${jsonpath_soluong_hh}
    ${get_discount_hh}    Get data from API    ${endpoint_order_detail}    ${jsonpath_discount_hh}
    ${get_giaban_in_order}    Get data from API    ${endpoint_order_detail}    ${jsonpath_giaban_hh}
    ${get_thanhtien_in_order}    Get data from API    ${endpoint_order_detail}    ${jsonpath_thanhtien_hh}
    Return From Keyword    ${get_ten_hh_in_order}    ${get_soluong_in_order}    ${get_discount_hh}    ${get_giaban_in_order}    ${get_thanhtien_in_order}

Get order info incase discount by order code
    [Arguments]    ${input_ma_dh}
    [Timeout]    3 minutes
    ${jsonpath_ghichu}    Format String    $..Data[?(@.Code == '{0}')].Description    ${input_ma_dh}
    ${jsonpath_id_dh}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_dh}
    ${get_id_dh}    Get data from API    ${endpoint_order}    ${jsonpath_id_dh}
    ${endpoint_orderdetail}    Format String    ${endpoint_order_detail}    ${get_id_dh}
    ${get_resp}    Get Request and return body    ${endpoint_orderdetail}
    ${get_ma_kh}    Get data from response json    ${get_resp}    $.Customer.Code
    ${get_TTDH}    Get data from response json    ${get_resp}    $.Status
    ${get_tongtienhang}    Get data from response json    ${get_resp}    $.SubTotal
    ${get_khachdatra}    Get data from response json    ${get_resp}    $.TotalPayment
    ${get_giamgia_dh}    Get data from response json    ${get_resp}    $.Discount
    ${get_tongcong}    Get data from response json    ${get_resp}    $.Total
    ${get_ghichu}    Get data from API    ${endpoint_order}    ${jsonpath_ghichu}
    ${get_ghichu}    Convert To String    ${get_ghichu}
    Return From Keyword    ${get_ma_kh}    ${get_TTDH}    ${get_tongtienhang}    ${get_khachdatra}    ${get_giamgia_dh}    ${get_tongcong}
    ...    ${get_ghichu}

Get order info incase discount not note by order code
    [Arguments]    ${input_ma_dh}
    [Timeout]    3 minutes
    ${jsonpath_id_dh}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_dh}
    ${get_id_dh}    Get data from API    ${endpoint_order}    ${jsonpath_id_dh}
    ${endpoint_orderdetail}    Format String    ${endpoint_order_detail}    ${get_id_dh}
    ${get_resp}    Get Request and return body    ${endpoint_orderdetail}
    ${get_ma_kh}    Get data from response json    ${get_resp}    $.Customer.Code
    ${get_TTDH}    Get data from response json    ${get_resp}    $.Status
    ${get_tongtienhang}    Get data from response json    ${get_resp}    $.SubTotal
    ${get_khachdatra}    Get data from response json    ${get_resp}    $.TotalPayment
    ${get_giamgia_dh_vnd}    Get data from response json    ${get_resp}    $.Discount
    ${get_giamgia_dh_%}    Get data from response json    ${get_resp}    $.DiscountRatio
    ${get_giamgia_dh}    Set Variable If    0 < ${get_giamgia_dh_%} < 100    ${get_giamgia_dh_%}    ${get_giamgia_dh_vnd}
    ${get_tongcong}    Get data from response json    ${get_resp}    $.Total
    Return From Keyword    ${get_ma_kh}    ${get_TTDH}    ${get_tongtienhang}    ${get_khachdatra}    ${get_giamgia_dh}    ${get_tongcong}

Get ma phieu thanh toan dat hang frm API
    [Arguments]    ${input_ma_dh}
    [Timeout]    3 minutes
    ${jsonpath_id_dh}    Format String    $..Data[?(@.Code == "{0}")].Id    ${input_ma_dh}
    ${get_id_dh}    Get data from API    ${endpoint_order}    ${jsonpath_id_dh}
    ${endpoint_order_payment}    Format String    ${endpoint_order_payment}    ${get_id_dh}
    ${get_ma_phieutt}    Get data from API    ${endpoint_order_payment}    $..Code
    Return From Keyword    ${get_ma_phieutt}

Get list product frm API
    [Arguments]    ${input_ma_dh}
    [Timeout]    3 minutes
    ${jsonpath_id_order}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_dh}
    ${get_id_order }    Get data from API    ${endpoint_order}    ${jsonpath_id_order}
    ${endpoint_orderdetail}    Format String    ${endpoint_order_detail}    ${get_id_order }
    ${get_list_hh_in_order}    Get raw data from API    ${endpoint_orderdetail}    $.OrderDetails..Code
    Return From Keyword    ${get_list_hh_in_order}

Get list product and quantity frm API
    [Arguments]    ${input_ma_dh}
    [Timeout]    3 minutes
    ${jsonpath_id_order}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_dh}
    ${get_id_order }    Get data from API    ${endpoint_order}    ${jsonpath_id_order}
    ${endpoint_orderdetail}    Format String    ${endpoint_order_detail}    ${get_id_order }
    ${get_list_hh_in_order}    Get raw data from API    ${endpoint_orderdetail}    $.OrderDetails..Code
    ${get_list_sl_in_order}    Get raw data from API    ${endpoint_orderdetail}    $.OrderDetails..Quantity
    ${get_list_sl_in_order}    Convert String to List    ${get_list_sl_in_order}
    Return From Keyword    ${get_list_hh_in_order}    ${get_list_sl_in_order}

Get list quantity - sub total - order summary - ending stock frm API
    [Arguments]    ${input_ma_dh}    ${list_product}
    [Timeout]    5 minutes
    ${list_thanhtien}    Create List
    ${list_soluong_in_dh}    Create List
    ${list_order_summary}    Create List
    ${list_onhand}    Create List
    ${jsonpath_id_order}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_dh}
    ${get_id_order}   Get data from API    ${endpoint_order}    ${jsonpath_id_order}
    ${endpoint_order_detail}    Format String    ${endpoint_order_detail}    ${get_id_order}
    ${endpoint_danhmuc_hh_co_dvt}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${get_resp_orderdetail}    Get Request and return body    ${endpoint_order_detail}
    ${get_resp_danhmuc_hh}    Get Request and return body    ${endpoint_danhmuc_hh_co_dvt}
    : FOR    ${input_ma_hh}    IN    @{list_product}
    \    ${jsonpath_sub_total}    Format String    $.OrderDetails[?(@.Product.Code == '{0}')].SubTotal    ${input_ma_hh}
    \    ${jsonpath_quantity}    Format String    $.OrderDetails[?(@.Product.Code == '{0}')].Quantity    ${input_ma_hh}
    \    ${jsonpath_tong_dh}    Format String    $..Data[?(@.Code=="{0}")].Reserved    ${input_ma_hh}
    \    ${jsonpath_ton}    Format String    $..Data[?(@.Code=="{0}")].OnHand    ${input_ma_hh}
    \    ${get_thanhtien_in_dh}    Get data from response json    ${get_resp_orderdetail}    ${jsonpath_sub_total}
    \    ${get_soluong_in_dh}    Get data from response json    ${get_resp_orderdetail}    ${jsonpath_quantity}
    \    ${get_tong_dh}    Get data from response json    ${get_resp_danhmuc_hh}    ${jsonpath_tong_dh}
    \    ${ton}    Get data from response json    ${get_resp_danhmuc_hh}    ${jsonpath_ton}
    \    ${ton}    Convert To Number    ${ton}
    \    ${ton}    Evaluate    round(${ton}, 3)
    \    Append To List    ${list_thanhtien}    ${get_thanhtien_in_dh}
    \    Append To List    ${list_soluong_in_dh}    ${get_soluong_in_dh}
    \    Append To List    ${list_order_summary}    ${get_tong_dh}
    \    Append to list    ${list_onhand}    ${ton}
    Return From Keyword    ${list_thanhtien}    ${list_soluong_in_dh}    ${list_order_summary}    ${list_onhand}

Get list quantity - price - order summary - ending stock frm API
    [Arguments]    ${input_ma_dh}    ${list_product}
    [Timeout]    3 minutes
    ${list_soluong_in_dh}    Create List
    ${list_baseprice}    Create List
    ${list_order_summary}    Create List
    ${list_onhand}    Create List
    ${jsonpath_id_order}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_dh}
    ${get_id_order}    Get data from API    ${endpoint_order}    ${jsonpath_id_order}
    ${endpoint_order_detail}    Format String    ${endpoint_order_detail}    ${get_id_order}
    ${endpoint_pr}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${get_resp_orderdetail}    Get Request and return body    ${endpoint_order_detail}
    ${get_resp_product}    Get Request and return body    ${endpoint_pr}
    : FOR    ${item_product}    IN    @{list_product}
    \    ${jsonpath_quantity}    Format String    $.OrderDetails[?(@.Product.Code == '{0}')].Quantity    ${item_product}
    \    ${jsonpath_giaban}    Format String    $..Data[?(@.Code=="{0}")].BasePrice    ${item_product}
    \    ${jsonpath_tong_dh}    Format String    $..Data[?(@.Code == '{0}')].Reserved    ${item_product}
    \    ${jsonpath_ton}    Format String    $..Data[?(@.Code=="{0}")].OnHand    ${item_product}
    \    ${get_soluong_in_dh}    Get data from response json    ${get_resp_orderdetail}    ${jsonpath_quantity}
    \    ${giaban}    Get data from response json    ${get_resp_product}    ${jsonpath_giaban}
    \    ${get_tong_dh}    Get data from response json    ${get_resp_product}    ${jsonpath_tong_dh}
    \    ${ton}    Get data from response json    ${get_resp_product}    ${jsonpath_ton}
    \    ${ton}    Convert To Number    ${ton}
    \    ${ton}    Evaluate    round(${ton}, 3)
    \    Append To List    ${list_soluong_in_dh}    ${get_soluong_in_dh}
    \    Append To List    ${list_baseprice}    ${giaban}
    \    Append To List    ${list_order_summary}    ${get_tong_dh}
    \    Append To List    ${list_onhand}    ${ton}
    Return From Keyword    ${list_soluong_in_dh}    ${list_baseprice}    ${list_order_summary}    ${list_onhand}

Get quantity frm API
    [Arguments]    ${input_ma_dh}    ${input_ma_hh}
    [Timeout]    3 minutes
    ${jsonpath_quantity}    Format String    $.OrderDetails[?(@.Product.Code == '{0}')].Quantity    ${input_ma_hh}
    ${jsonpath_id_order}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_dh}
    ${get_id_order}    Get data from API    ${endpoint_order}    ${jsonpath_id_order}
    ${endpoint_order_detail}    Format String    ${endpoint_order_detail}    ${get_id_order}
    ${get_resp_orderdetail}    Get Request and return body    ${endpoint_order_detail}
    ${get_soluong_in_dh}    Get data from response json    ${get_resp_orderdetail}    ${jsonpath_quantity}
    Return From Keyword    ${get_soluong_in_dh}

Get ghi chu and list product frm API
    [Arguments]    ${input_ma_dh}
    [Timeout]    3 minutes
    ${jsonpath_ghichu}    Format String    $..Data[?(@.Code == '{0}')].Description    ${input_ma_dh}
    ${jsonpath_id_order}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_dh}
    ${get_id_order }    Get data from API    ${endpoint_order}    ${jsonpath_id_order}
    ${endpoint_orderdetail}    Format String    ${endpoint_order_detail}    ${get_id_order }
    ${get_list_hh_in_order}    Get raw data from API    ${endpoint_orderdetail}    $.OrderDetails..Code
    ${get_ghichu}    Get data from API    ${endpoint_order}    ${jsonpath_ghichu}
    Return From Keyword    ${get_list_hh_in_order}    ${get_ghichu}

Get ghi chu - list product - list quantity by order code
    [Arguments]    ${input_ma_dh}   ${list_hh}
    [Timeout]    3 minutes
    ${list_sl_in_dh}    Create List
    ${jsonpath_ghichu}    Format String    $..Data[?(@.Code == '{0}')].Description    ${input_ma_dh}
    ${jsonpath_id_order}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_dh}
    ${get_id_order }    Get data from API    ${endpoint_order}    ${jsonpath_id_order}
    ${endpoint_orderdetail}    Format String    ${endpoint_order_detail}    ${get_id_order }
    ${get_resp}    Get Request and return body    ${endpoint_order_detail}
    ${get_list_hh_in_order}    Get raw data from response json    ${get_resp}    $.OrderDetails..Code
    ${get_ghichu}    Get data from response json    ${get_resp}    ${jsonpath_ghichu}
    : FOR    ${input_ma_hh}    IN    @{list_hh}
    \    ${jsonpath_quantity}    Format String    $.OrderDetails[?(@.Product.Code == '{0}')].Quantity    ${input_ma_hh}
    \    ${get_soluong_in_dh}    Get data from response json    ${get_resp}    ${jsonpath_quantity}
    \    ${get_soluong_in_dh}    Convert To Number    ${get_soluong_in_dh}
    \    ${get_soluong_in_dh}    Replace floating point    ${get_soluong_in_dh}
    \    Append To List    ${list_sl_in_dh}    ${get_soluong_in_dh}
    ${list_sl_in_dh}    Convert String to List    ${list_sl_in_dh}
    Return From Keyword    ${get_list_hh_in_order}    ${get_ghichu}    ${list_sl_in_dh}

Get order info have note by order code
    [Arguments]    ${input_ma_dh}
    [Timeout]    3 minutes
    ${jsonpath_ghichu}    Format String    $..Data[?(@.Code == '{0}')].Description    ${input_ma_dh}
    ${jsonpath_id_dh}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_dh}
    ${get_id_dh}    Get data from API    ${endpoint_order}    ${jsonpath_id_dh}
    ${endpoint_order_detail}    Format String    ${endpoint_order_detail}    ${get_id_dh}
    ${get_resp_orderdetail}    Get Request and return body    ${endpoint_order_detail}
    ${get_ma_kh}    Get data from response json    ${get_resp_orderdetail}    $.Customer.Code
    ${get_TTDH}    Get data from response json    ${get_resp_orderdetail}    $.Status
    ${get_tongtienhang}    Get data from response json    ${get_resp_orderdetail}    $.Total
    ${get_khachdatra}    Get data from response json    ${get_resp_orderdetail}    $.TotalPayment
    ${get_ghichu}    Get data from API    ${endpoint_order}    ${jsonpath_ghichu}
    Return From Keyword    ${get_ma_kh}    ${get_TTDH}    ${get_tongtienhang}    ${get_khachdatra}    ${get_ghichu}

Get order info have note incase discount by order code
    [Arguments]    ${input_ma_dh}
    [Timeout]    3 minutes
    ${jsonpath_ghichu}    Format String    $..Data[?(@.Code == '{0}')].Description    ${input_ma_dh}
    ${jsonpath_id_dh}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_dh}
    ${get_id_dh}    Get data from API    ${endpoint_order}    ${jsonpath_id_dh}
    ${endpoint_orderdetail}    Format String    ${endpoint_order_detail}    ${get_id_dh}
    ${get_resp_orderdetail}    Get Request and return body    ${endpoint_orderdetail}
    ${get_ma_kh}    Get data from response json    ${get_resp_orderdetail}    $.Customer.Code
    ${get_TTDH}    Get data from response json    ${get_resp_orderdetail}    $.Status
    ${get_tongtienhang}    Get data from response json    ${get_resp_orderdetail}    $.SubTotal
    ${get_khachdatra}    Get data from response json    ${get_resp_orderdetail}    $.TotalPayment
    ${get_giamgia_dh_vnd}    Get data from response json    ${get_resp_orderdetail}    $.Discount
    ${get_giamgia_dh_%}    Get data from response json    ${get_resp_orderdetail}    $.DiscountRatio
    ${get_giamgia_dh}    Set Variable If    0 < ${get_giamgia_dh_%} < 100    ${get_giamgia_dh_%}    ${get_giamgia_dh_vnd}
    ${get_tongcong}    Get data from response json    ${get_resp_orderdetail}    $.Total
    ${get_ghichu}    Get data from API    ${endpoint_order}    ${jsonpath_ghichu}
    Return From Keyword    ${get_ma_kh}    ${get_TTDH}    ${get_tongtienhang}    ${get_khachdatra}    ${get_giamgia_dh}    ${get_tongcong}    ${get_ghichu}

Get list gia ban from PriceBook api
    [Arguments]    ${input_ten_banggia}    ${list_product}
    [Timeout]    3 minutes
    ${list_newprice}    Create List
    ${jsonpath_id_banggia}    Format String    $..Data[?(@.Name == '{0}')].Id    ${input_ten_banggia}
    ${get_id_banggia}    Get data from API    ${endpoint_pricebook}    ${jsonpath_id_banggia}
    ${enpoint_pricebook}    Format String    ${endpoint_pricebook_detail}    ${get_id_banggia}
    ${endpont_product}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BranchID}
    ${get_resp_pr}    Get Request and return body    ${endpont_product}
    ${get_resp}    Get Request and return body    ${enpoint_pricebook}
    : FOR    ${input_ma_hh}    IN    @{list_product}
    \    ${jsonpath_giaban}    Format String    $..Data[?(@.Code == '{0}')].Pb1    ${input_ma_hh}
    \    ${jsonpath_baseprice}    Format String    $..Data[?(@.Code=="{0}")].BasePrice    ${input_ma_hh}
    \    ${get_giaban}    Get data from response json    ${get_resp}    ${jsonpath_giaban}
    \    ${get_giaban}    Run Keyword If    "${get_giaban}" == "0"    Get data from response json    ${get_resp_pr}    ${jsonpath_baseprice}
    \    ...    ELSE    Set Variable    ${get_giaban}
    \    Append To List    ${list_newprice}    ${get_giaban}
    Return From Keyword    ${get_id_banggia}    ${list_newprice}

Get TTH with change pricebook
    [Arguments]    ${input_ma_dh}    ${input_ma_hh}    ${input_giaban}    ${list_result_thanhtien}
    [Timeout]    3 minutes
    ${get_soluong_in_dh}    Get quantity frm API    ${input_ma_dh}    ${input_ma_hh}
    ${result_thanhtien}    Multiplication and round    ${input_giaban}    ${get_soluong_in_dh}
    Append To List    ${list_result_thanhtien}    ${result_thanhtien}
    Return From Keyword    ${list_result_thanhtien}

Validate price when change pricebook
    [Arguments]    ${input_ma_hh}    ${input_ma_dh}    ${giaban_new}
    [Timeout]    3 minutes
    ${get_giaban_after_execute}    Get new price after change pricebook    ${input_ma_hh}    ${input_ma_dh}
    Should Be Equal As Numbers    ${get_giaban_after_execute}    ${giaban_new}

Get new price after change pricebook
    [Arguments]    ${input_ma_hh}    ${input_ma_dh}
    [Timeout]    3 minutes
    ${jsonpath_id_hh}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_hh}
    ${jsonpath_id_dh}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_dh}
    ${endpoint_danhmuc_hh_co_dvt}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${get_id_hh}    Get data from API    ${endpoint_danhmuc_hh_co_dvt}    ${jsonpath_id_hh}
    ${get_id_dh}    Get data from API    ${endpoint_order}    ${jsonpath_id_dh}
    ${result_endpoint_order_detail}    Format String    ${endpoint_order_detail}    ${get_id_dh}
    ${jsonpath_giaban}    Format String    $..OrderDetails[?(@.ProductId == {0})].Price    ${get_id_hh}
    ${get_giaban}    Get data from API    ${result_endpoint_order_detail}    ${jsonpath_giaban}
    ${get_giaban}    Replace floating point    ${get_giaban}
    Return From Keyword    ${get_giaban}

Get invoice history frm Order
    [Arguments]    ${input_ma_dh}    ${input_ma_hd}
    [Timeout]    3 minutes
    ${jsonpath_id_order}    Format String    $.Data[?(@.Code == '{0}')].Id    ${input_ma_dh}
    ${jsonpath_giatri}    Format String    $.Data[?(@.Code == "{0}")].Total    ${input_ma_hd}
    ${jsonpath_trangthai}    Format String    $.Data[?(@.Code == "{0}")].Status    ${input_ma_hd}
    ${get_id_order}    Get data from API    ${endpoint_order}    ${jsonpath_id_order}
    ${endpoint_invoice_history}    Format String    ${endpoint_invoice_history}    ${get_id_order}
    ${get_resp}    Get Request and return body    ${endpoint_invoice_history}
    ${get_giatri}    Get data from response json    ${get_resp}    ${jsonpath_giatri}
    ${get_trangthai}    Get data from response json    ${get_resp}    ${jsonpath_trangthai}
    Return From Keyword    ${get_giatri}    ${get_trangthai}

Validate invoice history frm Order
    [Arguments]    ${input_ma_dh}    ${input_ma_hd}    ${get_tongcong}
    [Timeout]    3 minutes
    ${get_giatri_af_execute}    ${get_trangthai_af_execute}    Get invoice history frm Order    ${input_ma_dh}    ${input_ma_hd}
    Should Be Equal As Numbers    ${get_giatri_af_execute}    ${get_tongcong}
    Should Be Equal As Numbers    ${get_trangthai_af_execute}    1

Get list product and quantity of invoice frm Order API
    [Arguments]    ${input_ma_dh}
    [Timeout]    3 minutes
    ${jsonpath_id_order}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_dh}
    ${get_id_order }    Get data from API    ${endpoint_order}    ${jsonpath_id_order}
    ${endpoint_orderdetail}    Format String    ${endpoint_order_detail}    ${get_id_order }
    ${get_id_hd}    Get data from API    ${endpoint_orderdetail}    $.Invoices..Id
    ${endpoint_invoice_detail}    Format String    ${endpoint_invoice_detail}    ${get_id_hd}
    ${get_list_hh_in_invoice}    Get raw data from API    ${endpoint_invoice_detail}    $.InvoiceDetails..Code
    ${get_list_sl_in_invoice}    Get raw data from API    ${endpoint_invoice_detail}    $.InvoiceDetails..Quantity
    Return From Keyword    ${get_list_hh_in_invoice}    ${get_list_sl_in_invoice}

Get list order summary - total sale - ending stocks frm API
    [Arguments]    ${input_ma_dh}    ${list_product}
    [Timeout]    5 minutes
    ${list_tongdh}    Create List
    ${list_tonkho}    Create List
    ${list_giatri_quydoi}    Get list gia tri quy doi frm product API    ${list_product}
    ${get_list_product_type}    ${list_tonkho_service}    Get list product type and ending stock of service frm API    ${list_product}
    ${get_list_thanhtien_in_dh}    ${get_list_soluong_in_dh}    ${get_list_tongso_dh_bf_execute}    ${get_list_ton_bf_execute}    Get list quantity - sub total - order summary - ending stock frm API    ${input_ma_dh}    ${list_product}
    : FOR    ${item_product}    ${get_soluong_in_dh}    ${get_tongso_dh_bf_execute}    ${get_ton_bf_execute}    ${get_toncuoi_dv_execute}    ${giatri_quydoi}
    ...    ${get_product_type}    IN ZIP    ${list_product}    ${get_list_soluong_in_dh}    ${get_list_tongso_dh_bf_execute}    ${get_list_ton_bf_execute}
    ...    ${list_tonkho_service}    ${list_giatri_quydoi}    ${get_list_product_type}
    \    ${result_tongdh}    Minus    ${get_tongso_dh_bf_execute}    ${get_soluong_in_dh}
    \    ${result_toncuoi}    Run Keyword If    '${giatri_quydoi}' == '1'    Computation and get list ending stock    ${get_ton_bf_execute}    ${get_toncuoi_dv_execute}
    \    ...    ${get_soluong_in_dh}    ${get_product_type}
    \    ...    ELSE    Computation and get list ending stock for unit product    ${item_product}    ${giatri_quydoi}    ${get_soluong_in_dh}
    \    Append To List    ${list_tongdh}    ${result_tongdh}
    \    Append To List    ${list_tonkho}    ${result_toncuoi}
    Return From Keyword    ${list_tongdh}    ${list_tonkho}    ${get_list_thanhtien_in_dh}

Get list order summary - total sale - ending stocks incase discount
    [Arguments]    ${input_ma_dh}    ${list_product}    ${list_ggsp}
    [Timeout]    5 minutes
    ${list_tongdh}    Create List
    ${list_tonkho}    Create List
    ${list_thanhtien}    Create List
    ${list_result_giamoi}    Create List
    ${list_giatri_quydoi}    Get list gia tri quy doi frm product API    ${list_product}
    ${get_list_product_type}    ${list_tonkho_service}    Get list product type and ending stock of service frm API    ${list_product}
    ${list_soluong_in_dh}    ${list_baseprice}    ${list_order_summary}    ${list_onhand}    Get list quantity - price - order summary - ending stock frm API    ${input_ma_dh}    ${list_product}
    : FOR    ${item_product}    ${get_soluong_in_dh}    ${get_tongso_dh_bf_execute}    ${get_ton_bf_execute}    ${get_toncuoi_dv_execute}    ${giatri_quydoi}
    ...    ${get_product_type}    ${get_giaban_bf_execute}    ${input_ggsp}    IN ZIP    ${list_product}    ${list_soluong_in_dh}
    ...    ${list_order_summary}    ${list_onhand}    ${list_tonkho_service}    ${list_giatri_quydoi}    ${get_list_product_type}    ${list_baseprice}    ${list_ggsp}
    \    ${result_tongdh}    Minus and round 2    ${get_tongso_dh_bf_execute}    ${get_soluong_in_dh}
    \    ${result_toncuoi}    Run Keyword If    '${giatri_quydoi}' == '1'    Computation and get list ending stock    ${get_ton_bf_execute}    ${get_toncuoi_dv_execute}
    \    ...    ${get_soluong_in_dh}    ${get_product_type}
    \    ...    ELSE    Computation and get list ending stock for unit product    ${item_product}    ${giatri_quydoi}    ${get_soluong_in_dh}
    \    ${ressult_giamoi}    Run Keyword If    0 < ${input_ggsp} < 100    Price after % discount product    ${get_giaban_bf_execute}    ${input_ggsp}
    \    ...    ELSE IF    ${input_ggsp} > 100    Minus and round 2    ${get_giaban_bf_execute}    ${input_ggsp}    ELSE    Set Variable    ${get_giaban_bf_execute}
    \    ${result_thanhtien}    Multiplication and round    ${ressult_giamoi}    ${get_soluong_in_dh}
    \    Append To List    ${list_tongdh}    ${result_tongdh}
    \    Append To List    ${list_tonkho}    ${result_toncuoi}
    \    Append To List    ${list_thanhtien}    ${result_thanhtien}
    \    Append To List    ${list_result_giamoi}    ${ressult_giamoi}
    Return From Keyword    ${list_tongdh}    ${list_tonkho}    ${list_thanhtien}    ${list_result_giamoi}

Get list order summary - total sale - ending stocks incase newprice
    [Arguments]    ${input_ma_dh}    ${list_product}    ${list_newprice}
    [Timeout]    3 minutes
    ${list_tongdh}    Create List
    ${list_tonkho}    Create List
    ${list_thanhtien}    Create List
    ${list_giatri_quydoi}    Get list gia tri quy doi frm product API    ${list_product}
    ${get_list_product_type}    ${list_tonkho_service}    Get list product type and ending stock of service frm API    ${list_product}
    ${list_soluong_in_dh}    ${list_baseprice}    ${list_order_summary}    ${list_onhand}    Get list quantity - price - order summary - ending stock frm API    ${input_ma_dh}    ${list_product}
    : FOR    ${item_product}    ${input_newprice}    ${get_soluong_in_dh}    ${get_giaban_bf_execute}    ${get_tongso_dh_bf_execute}    ${get_ton_bf_execute}
    ...    ${get_toncuoi_dv_execute}    ${giatri_quydoi}    ${get_product_type}    IN ZIP    ${list_product}    ${list_newprice}
    ...    ${list_soluong_in_dh}    ${list_baseprice}    ${list_order_summary}    ${list_onhand}    ${list_tonkho_service}    ${list_giatri_quydoi}
    ...    ${get_list_product_type}
    \    ${result_tongdh}    Minus    ${get_tongso_dh_bf_execute}    ${get_soluong_in_dh}
    \    ${result_toncuoi}    Run Keyword If    '${giatri_quydoi}' == '1'    Computation and get list ending stock    ${get_ton_bf_execute}    ${get_toncuoi_dv_execute}
    \    ...    ${get_soluong_in_dh}    ${get_product_type}
    \    ...    ELSE    Computation and get list ending stock for unit product    ${item_product}    ${giatri_quydoi}    ${get_soluong_in_dh}
    \    ${result_thanhtien}    Multiplication and round    ${input_newprice}    ${get_soluong_in_dh}
    \    Append To List    ${list_tongdh}    ${result_tongdh}
    \    Append To List    ${list_tonkho}    ${result_toncuoi}
    \    Append To List    ${list_thanhtien}    ${result_thanhtien}
    Return From Keyword    ${list_tongdh}    ${list_tonkho}    ${list_thanhtien}

Get list order summary - total sale - ending stocks incase discount and newprice
    [Arguments]    ${input_ma_dh}    ${list_product}    ${list_ggsp}    ${list_discount_type}
    [Timeout]    5 minutes
    ${list_tongdh}    Create List
    ${list_tonkho}    Create List
    ${list_thanhtien}    Create List
    ${list_result_giamoi}    Create List
    ${list_giatri_quydoi}    Get list gia tri quy doi frm product API    ${list_product}
    ${get_list_product_type}    ${list_tonkho_service}    Get list product type and ending stock of service frm API    ${list_product}
    ${list_soluong_in_dh}    ${list_baseprice}    ${list_order_summary}    ${list_onhand}    Get list quantity - price - order summary - ending stock frm API    ${input_ma_dh}    ${list_product}
    : FOR    ${item_product}    ${get_soluong_in_dh}    ${get_tongso_dh_bf_execute}    ${get_ton_bf_execute}    ${get_toncuoi_dv_execute}    ${giatri_quydoi}
    ...    ${get_product_type}    ${get_giaban_bf_execute}    ${input_ggsp}   ${discount_type}    IN ZIP    ${list_product}    ${list_soluong_in_dh}
    ...    ${list_order_summary}    ${list_onhand}    ${list_tonkho_service}    ${list_giatri_quydoi}    ${get_list_product_type}    ${list_baseprice}    ${list_ggsp}    ${list_discount_type}
    \    ${result_tongdh}    Minus and round 2    ${get_tongso_dh_bf_execute}    ${get_soluong_in_dh}
    \    ${result_toncuoi}    Run Keyword If    '${giatri_quydoi}' == '1'    Computation and get list ending stock    ${get_ton_bf_execute}    ${get_toncuoi_dv_execute}
    \    ...    ${get_soluong_in_dh}    ${get_product_type}
    \    ...    ELSE    Computation and get list ending stock for unit product    ${item_product}    ${giatri_quydoi}    ${get_soluong_in_dh}
    \    ${ressult_giamoi}    Run Keyword If    '${discount_type}' == 'dis'    Price after % discount product    ${get_giaban_bf_execute}    ${input_ggsp}
    \    ...    ELSE IF    '${discount_type}' == 'disvnd'    Minus and round 2    ${get_giaban_bf_execute}    ${input_ggsp}
    \    ...    ELSE IF    '${discount_type}' == 'changeup' or '${discount_type}' == 'changedown'   Set Variable   ${input_ggsp}
    \    ...     ELSE    Set Variable    ${get_giaban_bf_execute}
    \    ${result_thanhtien}    Multiplication and round    ${ressult_giamoi}    ${get_soluong_in_dh}
    \    Append To List    ${list_tongdh}    ${result_tongdh}
    \    Append To List    ${list_tonkho}    ${result_toncuoi}
    \    Append To List    ${list_thanhtien}    ${result_thanhtien}
    \    Append To List    ${list_result_giamoi}    ${ressult_giamoi}
    Return From Keyword    ${list_tongdh}    ${list_tonkho}    ${list_thanhtien}    ${list_result_giamoi}

Get list invoice and total payment frm Order api
    [Arguments]    ${input_ma_dh}
    [Timeout]    3 minutes
    ${jsonpath_id_order}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_dh}
    ${get_id_order }    Get data from API    ${endpoint_order}    ${jsonpath_id_order}
    ${endpoint_orderdetail}    Format String    ${endpoint_order_detail}    ${get_id_order }
    ${get_resp}    Get Request and return body    ${endpoint_orderdetail}
    ${get_list_id_hd}    Get raw data from response json    ${get_resp}    $.Invoices..Id
    ${get_list_khachdatra_in_hd}    Get raw data from response json    ${get_resp}    $.Invoices..TotalPayment
    Return From Keyword    ${get_list_id_hd}    ${get_list_khachdatra_in_hd}

Get list invoice code frm Order api
    [Arguments]    ${input_ma_dh}
    [Timeout]    3 minutes
    ${jsonpath_id_order}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_dh}
    ${get_id_order }    Get data from API    ${endpoint_order}    ${jsonpath_id_order}
    ${endpoint_orderdetail}    Format String    ${endpoint_order_detail}    ${get_id_order }
    ${get_resp}    Get Request and return body    ${endpoint_orderdetail}
    ${get_list_id_hd}    Get raw data from response json    ${get_resp}    $.Invoices..Code
    Return From Keyword    ${get_list_id_hd}


Get list product frm list invoice frm Order api
    [Arguments]    ${get_id_hd}    ${list_hh_in_hd}
    [Timeout]    3 minutes
    ${endpoint_invoice_detail}    Format String    ${endpoint_invoice_detail}    ${get_id_hd}
    ${get_resp}    Get Request and return body    ${endpoint_invoice_detail}
    ${get_list_hh_in_invoice}    Get raw data from response json    ${get_resp}    $.InvoiceDetails..Code
    ${get_list_hh_in_hd}    Combine Lists    ${get_list_hh_in_invoice}    ${list_hh_in_hd}
    Return From Keyword    ${get_list_hh_in_hd}

Get order code frm API
    [Arguments]    ${input_ma_kh}
    [Timeout]    3 minutes
    ${jsonpath_id_kh}    Format String    $.Data[?(@.Code == '{0}')].Id    ${input_ma_kh}
    ${get_id_kh}    Get data from API    ${endpoint_khachhang}    ${jsonpath_id_kh}
    ${endpoint_tab_lichsu_dathang}    Format String    ${endpoint_tab_lichsu_dathang}    ${get_id_kh}
    ${get_ma_dh}    Get data from API    ${endpoint_tab_lichsu_dathang}    $.Data[0].Code
    Return From Keyword    ${get_ma_dh}

Get list thanh tien frm Order API
    [Arguments]    ${input_ma_dh}
    [Timeout]    3 minutes
    ${jsonpath_id_dh}    Format String    $.Data[?(@.Code == '{0}')].Id    ${input_ma_dh}
    ${get_id_dh}    Get data from API    ${endpoint_order}    ${jsonpath_id_dh}
    ${endpoint_order_detail}    Format String    ${endpoint_order_detail}    ${get_id_dh}
    ${get_list_thanhtien}    Get raw data from API    ${endpoint_order_detail}    $.OrderDetails..SubTotal
    Return From Keyword    ${get_list_thanhtien}

Validate info product
    [Arguments]    ${ma_sp_bf_execute}    ${ma_sp_af_execute}    ${ten_hh}    ${input_ma_dh}    ${thanhtien_af_execute}
    [Timeout]    3 minutes
    Should Be Equal As Strings    ${ma_sp_af_execute}    ${ma_sp_bf_execute}
    ${get_ten_hh_in_order}    ${get_soluong_in_order}    ${get_discount_hh}    ${get_giaban_in_order}    ${get_thanhtien_in_order}    Get order detail info with multi products    ${input_ma_dh}
    ...    ${ma_sp_bf_execute}
    ${get_tenhang_af_purchase}    ${get_giaban_bf_purchase}    Get product name and price frm API    ${ma_sp_bf_execute}
    Should Be Equal As Strings    ${get_tenhang_af_purchase}    ${ten_hh}
    Should Be Equal As Numbers    ${get_discount_hh}    0
    Should Be Equal As Numbers    ${get_giaban_in_order}    ${get_giaban_bf_purchase}
    Should Be Equal As Numbers    ${get_thanhtien_in_order}    ${thanhtien_af_execute}

Validate info product with newprice
    [Arguments]    ${ma_sp_bf_execute}    ${ma_sp_af_execute}    ${ten_hh}    ${input_gia_moi}    ${input_ma_dh}    ${thanhtien_af_execute}
    [Timeout]    3 minutes
    Should Be Equal As Strings    ${ma_sp_af_execute}    ${ma_sp_bf_execute}
    ${get_ten_hh_in_order}    ${get_soluong_in_order}    ${get_discount_hh}    ${get_giaban_in_order}    ${get_thanhtien_in_order}    Get order detail info with multi products    ${input_ma_dh}
    ...    ${ma_sp_bf_execute}
    ${get_tenhang_af_purchase}    ${get_giaban_bf_purchase}    Get product name and price frm API    ${ma_sp_bf_execute}
    ${result_ggsp}    Minus and replace floating point    ${get_giaban_bf_purchase}    ${input_gia_moi}
    Should Be Equal As Strings    ${get_tenhang_af_purchase}    ${ten_hh}
    Should Be Equal As Numbers    ${get_discount_hh}    ${result_ggsp}
    Should Be Equal As Numbers    ${get_giaban_in_order}    ${get_giaban_bf_purchase}
    Should Be Equal As Numbers    ${get_thanhtien_in_order}    ${thanhtien_af_execute}

Validate info product with VND discount
    [Arguments]    ${ma_Gsp_bf_execute}    ${ma_sp_af_execute}    ${ten_hh}    ${input_ggsp}    ${input_ma_dh}    ${thanhtien_af_execute}
    [Timeout]    3 minutes
    Should Be Equal As Strings    ${ma_sp_af_execute}    ${ma_sp_bf_execute}
    ${get_ten_hh_in_order}    ${get_soluong_in_order}    ${get_discount_hh}    ${get_giaban_in_order}    ${get_thanhtien_in_order}    Get order detail info with multi products    ${input_ma_dh}
    ...    ${ma_sp_bf_execute}
    ${get_tenhang_af_purchase}    ${get_giaban_bf_purchase}    Get product name and price frm API    ${ma_sp_bf_execute}
    Should Be Equal As Strings    ${get_tenhang_af_purchase}    ${ten_hh}
    Should Be Equal As Numbers    ${get_discount_hh}    ${input_ggsp}
    Should Be Equal As Numbers    ${get_giaban_in_order}    ${get_giaban_bf_purchase}
    Should Be Equal As Numbers    ${get_thanhtien_in_order}    ${thanhtien_af_execute}

Validate info product with % discount
    [Arguments]    ${ma_sp_bf_execute}    ${ma_sp_af_execute}    ${ten_hh}    ${input_ggsp}    ${input_ma_dh}    ${thanhtien_af_execute}
    [Timeout]    3 minutes
    Should Be Equal As Strings    ${ma_sp_af_execute}    ${ma_sp_bf_execute}
    ${get_ten_hh_in_order}    ${get_soluong_in_order}    ${get_discount_hh}    ${get_giaban_in_order}    ${get_thanhtien_in_order}    Get order detail info with multi products    ${input_ma_dh}
    ...    ${ma_sp_bf_execute}
    ${get_tenhang_af_purchase}    ${get_giaban_bf_purchase}    Get product name and price frm API    ${ma_sp_bf_execute}
    ${result_ggsp}    Convert % discount to VND and round    ${get_giaban_bf_purchase}    ${input_ggsp}
    Should Be Equal As Strings    ${get_tenhang_af_purchase}    ${ten_hh}
    Should Be Equal As Numbers    ${get_discount_hh}    ${result_ggsp}
    Should Be Equal As Numbers    ${get_giaban_in_order}    ${get_giaban_bf_purchase}
    Should Be Equal As Numbers    ${get_thanhtien_in_order}    ${thanhtien_af_execute}

Get total payment and status by order code
    [Arguments]    ${input_ma_dh}
    [Timeout]    3 minutes
    ${jsonpath_id_dh}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_dh}
    ${get_id_dh}    Get data from API    ${endpoint_order}    ${jsonpath_id_dh}
    ${endpoint_orderdetail}    Format String    ${endpoint_order_detail}    ${get_id_dh}
    ${get_resp}    Get Request and return body    ${endpoint_orderdetail}
    ${get_tongcong}    Get data from response json    ${get_resp}    $.Total
    ${get_TTDH}    Get data from response json    ${get_resp}    $.Status
    Return From Keyword    ${get_tongcong}    ${get_TTDH}

Get paid value frm API
    [Arguments]    ${input_ma_dh}
    [Timeout]    3 minutes
    ${jsonpath_id_dh}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_dh}
    ${get_id_dh}    Get data from API    ${endpoint_order}    ${jsonpath_id_dh}
    ${endpoint_orderdetail}    Format String    ${endpoint_order_detail}    ${get_id_dh}
    ${get_resp}    Get Request and return body    ${endpoint_orderdetail}
    ${get_khachdatra}    Get data from response json    ${get_resp}    $.TotalPayment
    ${get_tongtienhang}    Get data from response json    ${get_resp}    $.Total
    Return From Keyword    ${get_khachdatra}    ${get_tongtienhang}

Get order code and paid value frm API
    [Arguments]    ${input_ma_kh}
    [Timeout]    3 minutes
    ${jsonpath_id_kh}    Format String    $.Data[?(@.Code == '{0}')].Id    ${input_ma_kh}
    ${get_id_kh}    Get data from API    ${endpoint_khachhang}    ${jsonpath_id_kh}
    ${endpoint_tab_lichsu_dathang}    Format String    ${endpoint_tab_lichsu_dathang}    ${get_id_kh}
    ${get_ma_dh}    Get data from API    ${endpoint_tab_lichsu_dathang}    $.Data[0].Code
    ${jsonpath_id_dh}    Format String    $..Data[?(@.Code == '{0}')].Id    ${get_ma_dh}
    ${get_id_dh}    Get data from API    ${endpoint_order}    ${jsonpath_id_dh}
    ${endpoint_orderdetail}    Format String    ${endpoint_order_detail}    ${get_id_dh}
    ${get_resp}    Get Request and return body    ${endpoint_orderdetail}
    ${get_khachdatra}    Get data from response json    ${get_resp}    $.TotalPayment
    ${get_tongtienhang}    Get data from response json    ${get_resp}    $.Total
    Return From Keyword    ${get_ma_dh}    ${get_khachdatra}    ${get_tongtienhang}

Get order code - paid - discount value frm API
    [Arguments]    ${input_ma_kh}
    [Timeout]    3 minutes
    ${jsonpath_id_kh}    Format String    $.Data[?(@.Code == '{0}')].Id    ${input_ma_kh}
    ${get_id_kh}    Get data from API    ${endpoint_khachhang}    ${jsonpath_id_kh}
    ${endpoint_tab_lichsu_dathang}    Format String    ${endpoint_tab_lichsu_dathang}    ${get_id_kh}
    ${get_ma_dh}    Get data from API    ${endpoint_tab_lichsu_dathang}    $.Data[0].Code
    ${jsonpath_id_dh}    Format String    $..Data[?(@.Code == '{0}')].Id    ${get_ma_dh}
    ${get_id_dh}    Get data from API    ${endpoint_order}    ${jsonpath_id_dh}
    ${endpoint_orderdetail}    Format String    ${endpoint_order_detail}    ${get_id_dh}
    ${get_resp}    Get Request and return body    ${endpoint_orderdetail}
    ${get_khachdatra}    Get data from response json    ${get_resp}    $.TotalPayment
    ${get_giamgia_vnd_hd}    Get data from response json    ${get_resp}    $.Discount
    ${get_giamgia_%_hd}    Get data from response json    ${get_resp}    $.DiscountRatio
    ${get_giamgia_hd}    Set Variable If    0 < ${get_giamgia_%_hd} < 100    ${get_giamgia_%_hd}    ${get_giamgia_vnd_hd}
    ${get_tongtienhang}    Get data from response json    ${get_resp}    $.SubTotal
    ${get_tongcong}    Get data from response json    ${get_resp}    $.Total
    Return From Keyword    ${get_ma_dh}    ${get_khachdatra}    ${get_giamgia_hd}    ${get_tongtienhang}    ${get_tongcong}

Get list quantity and discount by order code
    [Arguments]    ${input_ma_dh}    ${list_hh}
    [Timeout]    3 minutes
    ${list_discount_product_in_dh}    Create List
    ${list_sl_in_dh}    Create List
    ${jsonpath_id_order}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_dh}
    ${get_id_order}    Get data from API    ${endpoint_order}    ${jsonpath_id_order}
    ${endpoint_order_detail}    Format String    ${endpoint_order_detail}    ${get_id_order}
    ${get_resp}    Get Request and return body    ${endpoint_order_detail}
    : FOR    ${input_ma_hh}    IN    @{list_hh}
    \    ${jsonpath_quantity}    Format String    $.OrderDetails[?(@.Product.Code == '{0}')].Quantity    ${input_ma_hh}
    \    ${jsonpath_discount}    Format String    $.OrderDetails[?(@.Product.Code == '{0}')].Discount    ${input_ma_hh}
    \    ${jsonpath_discount_%}    Format String    $.OrderDetails[?(@.Product.Code == '{0}')].DiscountRatio    ${input_ma_hh}
    \    ${get_soluong_in_dh}    Get data from response json    ${get_resp}    ${jsonpath_quantity}
    \    ${get_soluong_in_dh}    Convert To Number    ${get_soluong_in_dh}
    \    ${get_discount_in_dh}    Get data from response json    ${get_resp}    ${jsonpath_discount}
    \    ${get_discount_ratio_in_dh}    Get data from response json    ${get_resp}    ${jsonpath_discount_%}
    \    ${get_discount_in_dh}    Convert To Number    ${get_discount_in_dh}
    \    ${get_discount_ratio_in_dh}    Convert To Number    ${get_discount_ratio_in_dh}
    \    ${get_discount}    Set Variable If    0 < ${get_discount_ratio_in_dh} < 100    ${get_discount_ratio_in_dh}    ${get_discount_in_dh}
    \    Append To List    ${list_sl_in_dh}    ${get_soluong_in_dh}
    \    Append To List    ${list_discount_product_in_dh}    ${get_discount}
    ${list_sl_in_dh}    Convert String to List    ${list_sl_in_dh}
    ${list_discount_product_in_dh}    Convert String to List    ${list_discount_product_in_dh}
    Return From Keyword    ${list_sl_in_dh}    ${list_discount_product_in_dh}

Get list quantity by order code
    [Arguments]    ${input_ma_dh}    ${list_hh}
    [Timeout]    3 minutes
    ${list_sl_in_dh}    Create List
    ${jsonpath_id_order}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_dh}
    ${get_id_order}    Get data from API    ${endpoint_order}    ${jsonpath_id_order}
    ${endpoint_order_detail}    Format String    ${endpoint_order_detail}    ${get_id_order}
    ${get_resp}    Get Request and return body    ${endpoint_order_detail}
    : FOR    ${input_ma_hh}    IN    @{list_hh}
    \    ${jsonpath_quantity}    Format String    $.OrderDetails[?(@.Product.Code == '{0}')].Quantity    ${input_ma_hh}
    \    ${get_soluong_in_dh}    Get data from response json    ${get_resp}    ${jsonpath_quantity}
    \    ${get_soluong_in_dh}    Convert To Number    ${get_soluong_in_dh}
    \    ${get_soluong_in_dh}    Replace floating point    ${get_soluong_in_dh}
    \    Append To List    ${list_sl_in_dh}    ${get_soluong_in_dh}
    ${list_sl_in_dh}    Convert String to List    ${list_sl_in_dh}
    Return From Keyword    ${list_sl_in_dh}

Get list quantity - order summary frm API
    [Arguments]    ${input_ma_dh}    ${list_hh}
    [Timeout]    3 minutes
    ${list_sl_in_dh}    Create List
    ${list_tong_dh}    Create List
    ${jsonpath_id_order}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_dh}
    ${get_id_order}    Get data from API    ${endpoint_order}    ${jsonpath_id_order}
    ${endpoint_order_detail}    Format String    ${endpoint_order_detail}    ${get_id_order}
    ${get_resp}    Get Request and return body    ${endpoint_order_detail}
    ${endpoint_danhmuc_hh_co_dvt}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${get_resp_danhmuc_hh}    Get Request and return body    ${endpoint_danhmuc_hh_co_dvt}
    : FOR    ${input_ma_hh}    IN    @{list_hh}
    \    ${jsonpath_quantity}    Format String    $.OrderDetails[?(@.Product.Code == '{0}')].Quantity    ${input_ma_hh}
    \    ${jsonpath_tong_dh}    Format String    $..Data[?(@.Code == '{0}')].Reserved    ${input_ma_hh}
    \    ${get_tong_dh}    Get data from response json    ${get_resp_danhmuc_hh}    ${jsonpath_tong_dh}
    \    ${get_ordersummary}    Convert To Number    ${get_tong_dh}
    \    ${get_soluong_in_dh}    Get data from response json    ${get_resp}    ${jsonpath_quantity}
    \    ${get_soluong_in_dh}    Convert To Number    ${get_soluong_in_dh}
    \    ${get_soluong_in_dh}    Replace floating point    ${get_soluong_in_dh}
    \    Append To List    ${list_tong_dh}    ${get_ordersummary}
    \    Append To List    ${list_sl_in_dh}    ${get_soluong_in_dh}
    ${list_sl_in_dh}    Convert String to List    ${list_sl_in_dh}
    Return From Keyword    ${list_sl_in_dh}    ${list_tong_dh}

Get list total sale product frm API
    [Arguments]    ${input_ma_dh}    ${list_hh}
    [Timeout]    3 minutes
    ${list_thanhtien}    Create List
    ${jsonpath_id_order}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_dh}
    ${get_id_order}    Get data from API    ${endpoint_order}    ${jsonpath_id_order}
    ${endpoint_order_detail}    Format String    ${endpoint_order_detail}    ${get_id_order}
    ${get_resp}    Get Request and return body    ${endpoint_order_detail}
    : FOR    ${input_ma_hh}    IN    @{list_hh}
    \    ${jsonpath_total_sale}    Format String    $.OrderDetails[?(@.Product.Code == '{0}')].SubTotal    ${input_ma_hh}
    \    ${get_thanhtien_in_dh}    Get data from response json    ${get_resp}    ${jsonpath_total_sale}
    \    ${get_thanhtien_in_dh}    Convert To Number    ${get_thanhtien_in_dh}
    \    Append To List    ${list_thanhtien}    ${get_thanhtien_in_dh}
    ${list_thanhtien}    Convert String to List    ${list_thanhtien}
    Return From Keyword    ${list_thanhtien}

Change pricebook and get list order summary and ending stocks frm API
    [Arguments]    ${input_ma_dh}    ${list_product}    ${input_ten_banggia}
    [Timeout]    3 minutes
    ${list_tongdh}    Create List
    ${list_tonkho}    Create List
    ${list_thanhtien}    Create List
    ${list_giatri_quydoi}    Get list gia tri quy doi frm product API    ${list_product}
    ${get_list_product_type}    ${list_tonkho_service}    Get list product type and ending stock of service frm API    ${list_product}
    ${get_list_thanhtien_in_dh}    ${get_list_soluong_in_dh}    ${get_list_tongso_dh_bf_execute}    ${get_list_ton_bf_execute}    Get list quantity - sub total - order summary - ending stock frm API    ${input_ma_dh}    ${list_product}
    ${get_id_bangia}    ${list_giaban_in_banggia}    Get list gia ban from PriceBook api    ${input_ten_banggia}    ${list_product}
    : FOR    ${get_giaban_in_banggia}    ${get_soluong_in_dh}    ${get_tongso_dh_bf_execute}    ${get_ton_bf_execute}    ${get_ton_dv_bf_execute}    ${get_product_type}
    ...    ${giatri_quydoi}    ${item_product}    IN ZIP    ${list_giaban_in_banggia}    ${get_list_soluong_in_dh}    ${get_list_tongso_dh_bf_execute}    ${get_list_ton_bf_execute}    ${list_tonkho_service}
    ...    ${get_list_product_type}    ${list_giatri_quydoi}    ${list_product}
    \    ${result_thanhtien}    Multiplication and round    ${get_giaban_in_banggia}    ${get_soluong_in_dh}
    \    ${result_tongdh}    Minus    ${get_tongso_dh_bf_execute}    ${get_soluong_in_dh}
    \    ${result_toncuoi}    Run Keyword If    '${giatri_quydoi}' == '1'    Computation and get list ending stock    ${get_ton_bf_execute}    ${get_ton_dv_bf_execute}
    \    ...    ${get_soluong_in_dh}    ${get_product_type}    ELSE    Computation and get list ending stock for unit product    ${item_product}
    \    ...    ${giatri_quydoi}    ${get_soluong_in_dh}
    \    Append To List    ${list_tongdh}    ${result_tongdh}
    \    Append To List    ${list_tonkho}    ${result_toncuoi}
    \    Append To List    ${list_thanhtien}    ${result_thanhtien}
    Return From Keyword    ${list_tongdh}    ${list_tonkho}    ${list_thanhtien}    ${list_giaban_in_banggia}

Get list total sale and order summary incase discount
    [Arguments]    ${list_product}    ${list_soluong}    ${list_ggsp}
    [Timeout]    3 minutes
    ${list_result_thanhtien}    Create List
    ${list_result_order_summary}    Create List
    ${list_newprice}    Create List
    ${get_list_baseprice}    Get list of Baseprice by Product Code    ${list_product}
    ${list_order_summary}    Get list order summary frm product API    ${list_product}
    : FOR    ${item_ma_hh}    ${nums}    ${input_ggsp}    ${get_tong_dh}    ${get_giaban_bf_execute}    IN ZIP    ${list_product}    ${list_soluong}    ${list_ggsp}    ${list_order_summary}    ${get_list_baseprice}
    \    ${result_tongso_dh}    Sum    ${get_tong_dh}    ${nums}
    \    ${result_giamoi}    Run Keyword If    0 < ${input_ggsp} < 100    Price after % discount product    ${get_giaban_bf_execute}    ${input_ggsp}
    \    ...    ELSE IF    ${input_ggsp} > 100    Minus and round 2    ${get_giaban_bf_execute}    ${input_ggsp}    ELSE    Set Variable    ${get_giaban_bf_execute}
    \    ${result_thanhtien}    Multiplication and round    ${result_giamoi}    ${nums}
    \    Append To List    ${list_result_thanhtien}    ${result_thanhtien}
    \    Append To List    ${list_result_order_summary}    ${result_tongso_dh}
    \    Append To List    ${list_newprice}    ${result_giamoi}
    Return From Keyword    ${list_result_thanhtien}    ${list_result_order_summary}    ${list_newprice}

Get list total sale - order summary - newprice incase discount
    [Arguments]    ${list_product}    ${list_soluong}    ${list_ggsp}
    [Timeout]    3 minutes
    ${list_result_thanhtien}    Create List
    ${list_result_order_summary}    Create List
    ${list_newprice}    Create List
    ${list_baseprice}    ${list_order_summary}    Get list base price and order summary frm product API    ${list_product}
    : FOR    ${item_ma_hh}    ${nums}    ${item_ggsp}    ${giaban}    ${get_tong_dh}    IN ZIP
    ...    ${list_product}    ${list_soluong}    ${list_ggsp}    ${list_baseprice}    ${list_order_summary}
    \    ${result_tongso_dh}    Sum    ${get_tong_dh}    ${nums}
    \    ${result_new_price}    Run Keyword If    0 < ${item_ggsp} < 100    Price after % discount product    ${giaban}    ${item_ggsp}
    \    ...    ELSE IF    ${item_ggsp} > 100    Minus    ${giaban}    ${item_ggsp}
    \    ...    ELSE    Set Variable    ${giaban}
    \    ${result_thanhtien}    Multiplication and round    ${result_new_price}    ${nums}
    \    Append To List    ${list_result_thanhtien}    ${result_thanhtien}
    \    Append To List    ${list_result_order_summary}    ${result_tongso_dh}
    \    Append To List    ${list_newprice}    ${result_new_price}
    Return From Keyword    ${list_result_thanhtien}    ${list_result_order_summary}    ${list_newprice}

Get list total sale and order summary incase newprice
    [Arguments]    ${list_product}    ${list_soluong}    ${list_newprice}
    [Timeout]    3 minutes
    ${list_result_thanhtien}    Create List
    ${list_result_order_summary}    Create List
    ${list_order_summary}    Get list order summary frm product API    ${list_product}
    : FOR    ${item_ma_hh}    ${nums}    ${newprice}    ${get_tong_dh}    IN ZIP    ${list_product}
    ...    ${list_soluong}    ${list_newprice}    ${list_order_summary}
    \    ${result_tongso_dh}    Sum    ${get_tong_dh}    ${nums}
    \    ${result_thanhtien}    Multiplication and round    ${newprice}    ${nums}
    \    Append To List    ${list_result_thanhtien}    ${result_thanhtien}
    \    Append To List    ${list_result_order_summary}    ${result_tongso_dh}
    Return From Keyword    ${list_result_thanhtien}    ${list_result_order_summary}

Get list total sale - order summary - newprice incase discount and newprice
    [Arguments]    ${list_product}    ${list_soluong}    ${list_ggsp}   ${list_discount_type}
    [Timeout]    3 minutes
    ${list_result_thanhtien}    Create List
    ${list_result_order_summary}    Create List
    ${list_newprice}    Create List
    ${list_baseprice}    ${list_order_summary}    Get list base price and order summary frm product API    ${list_product}
    : FOR    ${item_ma_hh}    ${nums}    ${item_ggsp}    ${get_baseprice}    ${get_tong_dh}    ${discount_type}    IN ZIP
    ...    ${list_product}    ${list_soluong}    ${list_ggsp}    ${list_baseprice}    ${list_order_summary}   ${list_discount_type}
    \    ${result_tongso_dh}    Sum    ${get_tong_dh}    ${nums}
    \    ${result_new_price}    Run Keyword If    0 < ${item_ggsp} < 100    Price after % discount product    ${get_baseprice}    ${item_ggsp}
    \    ...    ELSE IF    ${item_ggsp} > 100    Minus    ${get_baseprice}    ${item_ggsp}
    \    ...    ELSE    Set Variable    ${get_baseprice}
    \    ${result_new_price}    Run Keyword If    '${discount_type}' == 'dis'    Price after % discount product    ${get_baseprice}    ${item_ggsp}
    \    ...    ELSE IF    '${discount_type}' == 'disvnd'    Minus and round 2    ${get_baseprice}    ${item_ggsp}
    \    ...    ELSE IF    '${discount_type}' == 'changeup' or '${discount_type}' == 'changedown'   Set Variable   ${item_ggsp}     ELSE    Set Variable    ${get_baseprice}
    \    ${result_thanhtien}    Multiplication and round    ${result_new_price}    ${nums}
    \    Append To List    ${list_result_thanhtien}    ${result_thanhtien}
    \    Append To List    ${list_result_order_summary}    ${result_tongso_dh}
    \    Append To List    ${list_newprice}    ${result_new_price}
    Return From Keyword    ${list_result_thanhtien}    ${list_result_order_summary}    ${list_newprice}

Get list total sale - order summary - newprice incase discount and update quantity
    [Arguments]    ${input_ma_dh}    ${list_product}    ${list_soluong}    ${list_ggsp}   ${list_discount_type}
    [Timeout]    3 minutes
    ${list_result_thanhtien}    Create List
    ${list_result_order_summary}    Create List
    ${list_result_giamoi}    Create List
    ${get_list_baseprice}    Get list of Baseprice by Product Code    ${list_product}
    ${list_thanhtien}    ${list_soluong_in_dh}    ${list_order_summary}    ${list_onhand}    Get list quantity - sub total - order summary - ending stock frm API    ${input_ma_dh}    ${list_product}
    : FOR    ${get_soluong_in_dh}    ${input_soluong}    ${get_tongso_dh_bf_execute}    ${get_giaban_bf_execute}    ${input_ggsp}   ${discount_type}    IN ZIP
    ...    ${list_soluong_in_dh}    ${list_soluong}    ${list_order_summary}    ${get_list_baseprice}    ${list_ggsp}   ${list_discount_type}
    \    ${result_soluong_giam}    Minus    ${get_soluong_in_dh}    ${input_soluong}
    \    ${result_soluong_tang}    Minus    ${input_soluong}    ${get_soluong_in_dh}
    \    ${result_soluong}    Set Variable If    ${input_soluong}>${get_soluong_in_dh}    ${result_soluong_tang}    ${result_soluong_giam}
    \    ${result_tongdh_tang}    Sum    ${get_tongso_dh_bf_execute}    ${result_soluong}
    \    ${result_tongdh_giam}    Minus    ${get_tongso_dh_bf_execute}    ${result_soluong}
    \    ${result_tongdh}    Set Variable If    ${input_soluong}>${get_soluong_in_dh}    ${result_tongdh_tang}    ${result_tongdh_giam}
    \    ${result_giamoi}    Run Keyword If    '${discount_type}' == 'dis'    Price after % discount product    ${get_giaban_bf_execute}    ${input_ggsp}
    \    ...    ELSE IF    '${discount_type}' == 'disvnd'    Minus and round 2    ${get_giaban_bf_execute}    ${input_ggsp}
    \    ...    ELSE IF    '${discount_type}' == 'changeup' or '${discount_type}' == 'changedown'   Set Variable   ${input_ggsp}
    \    ...    ELSE     Set Variable    ${get_giaban_bf_execute}
    \    ${result_thanhtien_ggsp}    Multiplication and round    ${result_giamoi}    ${input_soluong}
    \    Append To List    ${list_result_thanhtien}    ${result_thanhtien_ggsp}
    \    Append To List    ${list_result_order_summary}    ${result_tongdh}
    \    Append To List    ${list_result_giamoi}    ${result_giamoi}
    Return From Keyword    ${list_result_thanhtien}    ${list_result_order_summary}    ${list_result_giamoi}

Get list total sale - order summary incase newprice discount and update quantity
    [Arguments]    ${input_ma_dh}    ${list_product}    ${list_soluong}    ${list_newprice}
    [Timeout]    3 minutes
    ${list_result_thanhtien}    Create List
    ${list_result_order_summary}    Create List
    ${list_thanhtien}    ${list_soluong_in_dh}    ${list_order_summary}    ${list_onhand}    Get list quantity - sub total - order summary - ending stock frm API    ${input_ma_dh}    ${list_product}
    : FOR    ${get_soluong_in_dh}    ${input_soluong}    ${get_tongso_dh_bf_execute}    ${input_newprice}    IN ZIP    ${list_soluong_in_dh}
    ...    ${list_soluong}    ${list_order_summary}    ${list_newprice}
    \    ${result_soluong_giam}    Minus    ${get_soluong_in_dh}    ${input_soluong}
    \    ${result_soluong_tang}    Minus    ${input_soluong}    ${get_soluong_in_dh}
    \    ${result_soluong}    Set Variable If    ${input_soluong}>${get_soluong_in_dh}    ${result_soluong_tang}    ${result_soluong_giam}
    \    ${result_tongdh_tang}    Sum    ${get_tongso_dh_bf_execute}    ${result_soluong}
    \    ${result_tongdh_giam}    Minus    ${get_tongso_dh_bf_execute}    ${result_soluong}
    \    ${result_tongdh}    Set Variable If    ${input_soluong}>${get_soluong_in_dh}    ${result_tongdh_tang}    ${result_tongdh_giam}
    \    ${result_thanhtien_ggsp}    Multiplication and round    ${input_newprice}    ${input_soluong}
    \    Append To List    ${list_result_thanhtien}    ${result_thanhtien_ggsp}
    \    Append To List    ${list_result_order_summary}    ${result_tongdh}
    Return From Keyword    ${list_result_thanhtien}    ${list_result_order_summary}

Get order - payment frm order api
    [Arguments]    ${input_ma_dh}
    [Timeout]    3 minutes
    ${jsonpath_id_order}    Format String    $.Data[?(@.Code == '{0}' )].Id    ${input_ma_dh}
    ${get_id_order}    Get data from API    ${endpoint_order}    ${jsonpath_id_order}
    ${endpoint_order_payment}    Format String    ${endpoint_order_payment}    ${get_id_order}
    ${endpoint_orderdetail}    Format String    ${endpoint_order_detail}    ${get_id_order}
    ${get_id_phieu_thanhtoan}    Get data from API    ${endpoint_order_payment}    $.Data..Id
    Return From Keyword    ${get_id_order}    ${get_id_phieu_thanhtoan}

Get orderdetail id frm order api
    [Arguments]    ${input_ma_dh}    ${input_product}
    [Timeout]    3 minutes
    ${jsonpath_id_order}    Format String    $.Data[?(@.Code == '{0}' )].Id    ${input_ma_dh}
    ${get_id_order}    Get data from API    ${endpoint_order}    ${jsonpath_id_order}
    ${endpoint_orderdetail}    Format String    ${endpoint_order_detail}    ${get_id_order}
    ${get_resp}    Get Request and return body    ${endpoint_orderdetail}
    ${jsonpath_id_orderdetail}    Format String    $.OrderDetails[?(@.Product.Code == '{0}')].Id    ${input_product}
    ${get_id_orderdetail}    Get data from response json    ${get_resp}    ${jsonpath_id_orderdetail}
    Return From Keyword    ${get_id_orderdetail}

Get list orderdetail id frm order api
    [Arguments]    ${input_ma_dh}    ${list_product}
    [Timeout]    3 minutes
    ${jsonpath_id_order}    Format String    $.Data[?(@.Code == '{0}' )].Id    ${input_ma_dh}
    ${get_id_order}    Get data from API    ${endpoint_order}    ${jsonpath_id_order}
    ${endpoint_orderdetail}    Format String    ${endpoint_order_detail}    ${get_id_order}
    ${get_resp}    Get Request and return body    ${endpoint_orderdetail}
    ${list_order_detail_id}    Create List
    : FOR    ${item_product}    IN    @{list_product}
    \    ${jsonpath_id_orderdetail}    Format String    $.OrderDetails[?(@.Product.Code == '{0}')].Id    ${item_product}
    \    ${get_id_orderdetail}    Get data from response json    ${get_resp}    ${jsonpath_id_orderdetail}
    \    Append to list    ${list_order_detail_id}    ${get_id_orderdetail}
    Return From Keyword    ${list_order_detail_id}

#nhieu dong
Get list total sale - order summary incase update quantity and add product
    [Arguments]    ${input_ma_dh}    ${list_product}    ${list_soluong_change}    ${list_ggsp}   ${list_discount_type}   ${list_product_add}    ${list_soluong_add}
    [Timeout]    3 minutes
    ${list_result_thanhtien}    Create List
    ${list_result_order_summary}    Create List
    ${list_result_order_summary_add}    Create List
    ${list_result_giamoi}    Create List
    ${list_result_giamoi_add}    Create List
    ${get_list_baseprice}    Get list of Baseprice by Product Code    ${list_product}
    ${list_soluong_in_dh}   ${list_order_summary}    Get list quantity - order summary frm API    ${input_ma_dh}    ${list_product}
    ${get_list_baseprice_add}    Get list of Baseprice by Product Code    ${list_product_add}
    ${list_order_summary_add}    Get list order summary frm product API    ${list_product_add}
    : FOR    ${get_soluong_in_dh}    ${input_soluong}   ${input_ggsp}    ${get_tongso_dh_bf_execute}    ${get_giaban_bf_execute}    ${discount_type}    IN ZIP    ${list_soluong_in_dh}    ${list_soluong_change}
    ...    ${list_ggsp}    ${list_order_summary}    ${get_list_baseprice}   ${list_discount_type}
    \    ${result_soluong_giam}    Minus    ${get_soluong_in_dh}    ${input_soluong}
    \    ${result_soluong_tang}    Minus    ${input_soluong}    ${get_soluong_in_dh}
    \    ${result_soluong}    Set Variable If    ${input_soluong}>${get_soluong_in_dh}    ${result_soluong_tang}    ${result_soluong_giam}
    \    ${result_tongdh_tang}    Sum    ${get_tongso_dh_bf_execute}    ${result_soluong}
    \    ${result_tongdh_giam}    Minus    ${get_tongso_dh_bf_execute}    ${result_soluong}
    \    ${result_tongdh}    Set Variable If    ${input_soluong}>${get_soluong_in_dh}    ${result_tongdh_tang}    ${result_tongdh_giam}
    \    ${result_giamoi}    Run Keyword If    '${discount_type}' == 'dis'    Price after % discount product    ${get_giaban_bf_execute}    ${input_ggsp}
    \    ...    ELSE IF    '${discount_type}' == 'disvnd'    Minus and round 2    ${get_giaban_bf_execute}    ${input_ggsp}
    \    ...    ELSE IF    '${discount_type}' == 'changeup' or '${discount_type}' == 'changedown'   Set Variable      ${input_ggsp}     ELSE    Set Variable    ${get_giaban_bf_execute}
    \    ${result_thanhtien}    Multiplication and round    ${result_giamoi}    ${input_soluong}
    \    Append To List    ${list_result_thanhtien}    ${result_thanhtien}
    \    Append To List    ${list_result_order_summary}    ${result_tongdh}
    \    Append To List    ${list_result_giamoi}    ${result_giamoi}
    : FOR    ${input_soluong_add}   ${input_discount}    ${get_tongso_dh_add}    ${get_giaban_add}    ${discount_type1}    IN ZIP    ${list_soluong_add}
    ...   ${list_ggsp}    ${list_order_summary_add}    ${get_list_baseprice_add}   ${list_discount_type}
    \    ${result_tongso_dh_add}    Sum    ${get_tongso_dh_add}    ${input_soluong_add}
    \    ${result_giamoi_add}    Run Keyword If    '${discount_type1}' == 'dis'    Price after % discount product    ${get_giaban_add}    ${input_discount}
    \    ...    ELSE IF    '${discount_type1}' == 'disvnd'    Minus and round 2    ${get_giaban_add}    ${input_discount}
    \    ...    ELSE IF    '${discount_type1}' == 'changeup' or '${discount_type1}' == 'changedown'   Set Variable      ${input_discount}     ELSE    Set Variable    ${get_giaban_add}
    \    ${result_thanhtien_add}    Multiplication and round    ${result_giamoi_add}    ${input_soluong_add}
    \    Append To List    ${list_result_thanhtien}    ${result_thanhtien_add}
    \    Append To List    ${list_result_order_summary_add}    ${result_tongso_dh_add}
    \    Append To List    ${list_result_giamoi_add}    ${result_giamoi_add}
    Return From Keyword    ${list_result_thanhtien}    ${list_result_order_summary}    ${list_result_order_summary_add}    ${list_result_giamoi}    ${list_result_giamoi_add}

Get list total sale incase add row product
    [Arguments]    ${get_baseprice}    ${list_soluong_addrow}    ${list_ggsp_addrow}   ${list_discount_type_addrow}
    [Timeout]    3 minutes
    ${list_result_thanhtien}    Create List
    ${list_newprice_addrow}    Create List
    : FOR    ${nums_addrow}    ${input_ggsp_addrow}   ${discount_type_addrow}    IN ZIP     ${list_soluong_addrow}    ${list_ggsp_addrow}    ${list_discount_type_addrow}
    \    ${result_giamoi_addrow}    Run Keyword If    '${discount_type_addrow}' == 'dis'    Price after % discount product    ${get_baseprice}    ${input_ggsp_addrow}
    \    ...    ELSE IF    '${discount_type_addrow}' == 'disvnd'    Minus and round 2    ${get_baseprice}    ${input_ggsp_addrow}
    \    ...    ELSE IF    '${discount_type_addrow}' == 'changeup' or '${discount_type_addrow}' == 'changedown'   Set Variable   ${input_ggsp_addrow}     ELSE    Set Variable    ${get_baseprice}
    \    ${result_giamoi_addrow}    Replace floating point    ${result_giamoi_addrow}
    \    ${result_thanhtien_addrow}    Multiplication and round    ${result_giamoi_addrow}    ${nums_addrow}
    \    Append To List    ${list_result_thanhtien}    ${result_thanhtien_addrow}
    \    Append To List    ${list_newprice_addrow}    ${result_giamoi_addrow}
    ${list_newprice_addrow}    Convert String to List    ${list_newprice_addrow}
    Return From Keyword    ${list_result_thanhtien}    ${list_newprice_addrow}

Get list resutl ending stock and quantity incase add row product
    [Arguments]    ${list_product}    ${list_toncuoi}      ${list_nums_addrow}    ${get_list_soluong_in_dh}    ${list_giatri_quydoi_in_hd}    ${get_list_product_type}    ${get_list_ton_dv_bf_execute}
    ${list_result_toncuoi}   Create List
    ${list_result_soluong}   Create List
    :FOR    ${item_product}    ${item_toncuoi}     ${item_nums_addrow}     ${item_nums}    ${giatri_quydoi}   ${get_ton_dv_bf_execute}    ${get_product_type}    IN ZIP    ${list_product}    ${list_toncuoi}
    ...      ${list_nums_addrow}    ${get_list_soluong_in_dh}    ${list_giatri_quydoi_in_hd}    ${get_list_ton_dv_bf_execute}    ${get_list_product_type}
    \    ${result_soluong_addrow}   Sum values in list    ${item_nums_addrow}
    \    ${result_ton_dv}   Minus   ${get_ton_dv_bf_execute}     ${item_nums}
    \    ${result_toncuoi}    Run Keyword If    '${giatri_quydoi}' == '1'    Computation and get list ending stock    ${item_toncuoi}    ${result_ton_dv}
    \    ...    ${result_soluong_addrow}    ${get_product_type}    ELSE    Computation and get list ending stock incase multi row and unit product    ${giatri_quydoi}    ${result_soluong_addrow}    ${item_toncuoi}
    \     ${result_soluong}   Sum     ${result_soluong_addrow}     ${item_nums}
    \     Append To List    ${list_result_toncuoi}    ${result_toncuoi}
    \     Append To List    ${list_result_soluong}    ${result_soluong}
    Return From Keyword    ${list_result_toncuoi}    ${list_result_soluong}

Get list total sale - ending stock - total quantity incase add row product
    [Arguments]    ${list_product}    ${list_nums_addrow}   ${list_discount_addrow}    ${list_type_discount_addrow}    ${list_toncuoi}    ${get_list_soluong_in_dh}    ${list_giatri_quydoi}
    ${list_result_newprice_addrow}    Create List
    ${list_result_thanhtien}    Create List
    ${get_list_baseprice}    Get list of Baseprice by Product Code    ${list_product}
    ${get_list_product_type}    ${list_tonkho_service}    Get list product type and ending stock of service frm API    ${list_product}
    ${list_result_toncuoi}    ${list_result_soluong}    Get list resutl ending stock and quantity incase add row product    ${list_product}    ${list_toncuoi}    ${list_nums_addrow}    ${get_list_soluong_in_dh}    ${list_giatri_quydoi}   ${get_list_product_type}    ${list_tonkho_service}
    :FOR  ${item_giaban}      ${item_quantity_addrow}    ${item_gg_sp_addrow}    ${type_discount_addrow}   IN ZIP    ${get_list_baseprice}   ${list_nums_addrow}   ${list_discount_addrow}    ${list_type_discount_addrow}
    \   ${list_result_thanhtien_addrow}    ${list_newprice_addrow}    Get list total sale incase add row product    ${item_giaban}   ${item_quantity_addrow}    ${item_gg_sp_addrow}    ${type_discount_addrow}
    \   Append to List     ${list_result_newprice_addrow}    ${list_newprice_addrow}
    \   Append to List     ${list_result_thanhtien}    ${list_result_thanhtien_addrow}
    ${list_result_thanhtien}    Convert String to List    ${list_result_thanhtien}
    Return From Keyword    ${list_result_thanhtien}      ${list_result_newprice_addrow}   ${list_result_toncuoi}    ${list_result_soluong}

Get list total sale - order summary - newprice incase add row product
    [Arguments]    ${list_product}    ${list_nums_addrow}   ${list_discount_addrow}    ${list_type_discount_addrow}    ${list_tong_dh}
    ${list_result_newprice_addrow}    Create List
    ${list_result_thanhtien}    Create List
    ${list_result_tongdh}    Create List
    ${get_list_baseprice}    Get list of Baseprice by Product Code    ${list_product}
    :FOR  ${item_giaban}      ${item_quantity_addrow}    ${item_gg_sp_addrow}    ${type_discount_addrow}  ${item_tong_dh}  IN ZIP    ${get_list_baseprice}   ${list_nums_addrow}
    ...   ${list_discount_addrow}    ${list_type_discount_addrow}    ${list_tong_dh}
    \   ${list_result_thanhtien_addrow}    ${list_newprice_addrow}    Get list total sale incase add row product    ${item_giaban}   ${item_quantity_addrow}    ${item_gg_sp_addrow}    ${type_discount_addrow}
    \   ${result_soluong}   Sum values in list    ${item_quantity_addrow}
    \   ${get_order_summary}     Sum    ${item_tong_dh}    ${result_soluong}
    \   Append to List     ${list_result_newprice_addrow}    ${list_newprice_addrow}
    \   Append to List     ${list_result_thanhtien}    ${list_result_thanhtien_addrow}
    \   Append to List     ${list_result_tongdh}    ${get_order_summary}
    ${list_result_thanhtien}    Convert String to List    ${list_result_thanhtien}
    Return From Keyword    ${list_result_thanhtien}      ${list_result_newprice_addrow}   ${list_result_tongdh}

Create list imei incase other product have multi row
    [Arguments]    ${list_product}    ${list_nums}   ${get_list_status_imei}
    ${list_imei_all}    Create List
    : FOR    ${item_product}     ${item_num}    ${item_status_imei}    IN ZIP    ${list_product}    ${list_nums}      ${get_list_status_imei}
    \    ${list_num_by_product}       Convert String to List       ${item_num}
    \    ${list_imei_by_single_product}=      Run Keyword If    '${item_status_imei}' != '0'      Import multi imei for mul-line product    ${item_product}    ${list_num_by_product}      ELSE      Set Variable    0
    \    Append to List       ${list_imei_all}        ${list_imei_by_single_product}
    Return From Keyword       ${list_imei_all}

Get list total sale - ending stock - total quantity incase catenate value all product
    [Arguments]    ${list_product}    ${list_nums}    ${list_giatri_quydoi_in_hd}    ${list_discount_addrow}   ${list_type_discount_addrow}
    ${list_result_toncuoi}   Create List
    ${list_result_soluong}   Create List
    ${list_result_thanhtien}    Create List
    ${get_list_baseprice}    Get list of Baseprice by Product Code    ${list_product}
    ${list_toncuoi}    Get list onhand frm API    ${list_product}
    ${get_list_product_type}    ${list_tonkho_service}    Get list product type and ending stock of service frm API    ${list_product}
    :FOR    ${item_product}    ${item_toncuoi}     ${item_nums_addrow}     ${giatri_quydoi}   ${get_ton_dv_bf_execute}    ${get_product_type}    IN ZIP    ${list_product}    ${list_toncuoi}
    ...      ${list_nums}    ${list_giatri_quydoi_in_hd}    ${list_tonkho_service}    ${get_list_product_type}
    \    ${result_soluong}   Sum values in list    ${item_nums_addrow}
    \    ${result_toncuoi}    Run Keyword If    '${giatri_quydoi}' == '1'    Computation and get list ending stock    ${item_toncuoi}    ${get_ton_dv_bf_execute}
    \    ...    ${result_soluong}    ${get_product_type}    ELSE    Computation and get list ending stock for unit product    ${item_product}    ${giatri_quydoi}    ${result_soluong}
    \     Append To List    ${list_result_toncuoi}    ${result_toncuoi}
    \     Append To List    ${list_result_soluong}    ${result_soluong}
    :FOR  ${item_giaban}      ${item_quantity_addrow}    ${item_gg_sp_addrow}    ${type_discount_addrow}   IN ZIP    ${get_list_baseprice}   ${list_nums}   ${list_discount_addrow}    ${list_type_discount_addrow}
    \   ${list_result_thanhtien_addrow}    ${list_newprice_addrow}    Get list total sale incase add row product    ${item_giaban}   ${item_quantity_addrow}    ${item_gg_sp_addrow}    ${type_discount_addrow}
    \   Append to List     ${list_result_thanhtien}    ${list_result_thanhtien_addrow}
    ${list_result_thanhtien}    Convert String to List    ${list_result_thanhtien}
    Return From Keyword    ${list_result_thanhtien}    ${list_result_toncuoi}    ${list_result_soluong}

#### gop discount and newprice
Get list total sale and order summary incase discount and newprice
    [Arguments]    ${list_product}    ${list_soluong}    ${list_ggsp}   ${list_discount_type}
    [Timeout]    3 minutes
    ${list_result_thanhtien}    Create List
    ${list_result_order_summary}    Create List
    ${list_newprice}    Create List
    ${get_list_baseprice}    Get list of Baseprice by Product Code    ${list_product}
    ${list_order_summary}    Get list order summary frm product API    ${list_product}
    : FOR    ${item_ma_hh}    ${nums}    ${input_ggsp}    ${get_tong_dh}    ${get_giaban_bf_execute}    ${discount_type}    IN ZIP    ${list_product}
    ...     ${list_soluong}    ${list_ggsp}    ${list_order_summary}    ${get_list_baseprice}   ${list_discount_type}
    \    ${result_tongso_dh}    Sum and round 2    ${get_tong_dh}    ${nums}
    \    ${result_giamoi}    Run Keyword If    '${discount_type}' == 'dis'    Price after % discount product    ${get_giaban_bf_execute}    ${input_ggsp}
    \    ...    ELSE IF    '${discount_type}' == 'disvnd'    Minus and round 2    ${get_giaban_bf_execute}    ${input_ggsp}
    \    ...    ELSE IF    '${discount_type}' == 'changeup' or '${discount_type}' == 'changedown'   Set Variable   ${input_ggsp}
    \    ...    ELSE     Set Variable    ${get_giaban_bf_execute}
    \    ${result_thanhtien}    Multiplication and round    ${result_giamoi}    ${nums}
    \    Append To List    ${list_result_thanhtien}    ${result_thanhtien}
    \    Append To List    ${list_result_order_summary}    ${result_tongso_dh}
    \    Append To List    ${list_newprice}    ${result_giamoi}
    Return From Keyword    ${list_result_thanhtien}    ${list_result_order_summary}    ${list_newprice}

Get list total sale and order summary frm order api
    [Arguments]    ${list_product}    ${list_soluong}    ${list_ggsp}   ${list_discount_type}
    [Timeout]    3 minutes
    ${list_result_thanhtien}    Create List
    ${list_result_order_summary}    Create List
    ${get_list_baseprice}    Get list of Baseprice by Product Code    ${list_product}
    ${list_order_summary}    Get list order summary frm product API    ${list_product}
    : FOR    ${item_ma_hh}    ${nums}    ${input_ggsp}    ${get_tong_dh}    ${get_giaban_bf_execute}    ${discount_type}    IN ZIP    ${list_product}
    ...     ${list_soluong}    ${list_ggsp}    ${list_order_summary}    ${get_list_baseprice}   ${list_discount_type}
    \    ${result_tongso_dh}    Sum and round 2    ${get_tong_dh}    ${nums}
    \    ${result_giamoi}    Run Keyword If    '${discount_type}' == 'dis'    Price after % discount product    ${get_giaban_bf_execute}    ${input_ggsp}
    \    ...    ELSE IF    '${discount_type}' == 'disvnd'    Minus and round 2    ${get_giaban_bf_execute}    ${input_ggsp}
    \    ...    ELSE IF    '${discount_type}' == 'changeup' or '${discount_type}' == 'changedown'   Set Variable   ${input_ggsp}
    \    ...    ELSE     Set Variable    ${get_giaban_bf_execute}
    \    ${result_thanhtien}    Multiplication and round    ${result_giamoi}    ${nums}
    \    Append To List    ${list_result_thanhtien}    ${result_thanhtien}
    \    Append To List    ${list_result_order_summary}    ${result_tongso_dh}
    Return From Keyword    ${list_result_thanhtien}    ${list_result_order_summary}

Get list result newprice and total payment frm order api
    [Arguments]    ${list_product}    ${list_soluong}    ${list_ggsp}   ${list_discount_type}    ${input_discount_order}    ${input_khtt}
    [Timeout]    3 minutes
    ${list_result_thanhtien}    Create List
    ${list_result_newprice}    Create List
    ${get_list_baseprice}    Get list of Baseprice by Product Code    ${list_product}
    : FOR    ${item_ma_hh}    ${nums}    ${input_ggsp}    ${get_giaban_bf_execute}    ${discount_type}    IN ZIP    ${list_product}    ${list_soluong}    ${list_ggsp}    ${get_list_baseprice}   ${list_discount_type}
    \    ${result_newprice}    Run Keyword If    '${discount_type}' == 'dis'    Price after % discount product    ${get_giaban_bf_execute}    ${input_ggsp}
    \    ...    ELSE IF    '${discount_type}' == 'disvnd'    Minus and round 2    ${get_giaban_bf_execute}    ${input_ggsp}
    \    ...    ELSE IF    '${discount_type}' == 'changeup' or '${discount_type}' == 'changedown'   Set Variable   ${input_ggsp}    ELSE     Set Variable    ${get_giaban_bf_execute}
    \    ${result_thanhtien}    Multiplication and round    ${result_newprice}    ${nums}
    \    Append To List    ${list_result_newprice}    ${result_newprice}
    \    Append To List    ${list_result_thanhtien}    ${result_thanhtien}
    ${result_tongtienhang}    Sum values in list    ${list_result_thanhtien}
    ${result_tongcong}    Run Keyword If    0 < ${input_discount_order} < 100    Price after % discount invoice    ${result_tongtienhang}    ${input_discount_order}
    ...    ELSE IF    ${input_discount_order} > 100    Minus and replace floating point    ${result_tongtienhang}    ${input_discount_order}    ELSE    Set Variable    ${result_tongtienhang}
    ${result_discount_order}    Run Keyword If    0 < ${input_discount_order} < 100    Convert % discount to VND and round    ${result_tongtienhang}    ${input_discount_order}    ELSE    Set Variable    ${input_discount_order}
    ${result_tongcong}    Replace floating point    ${result_tongcong}
    ${actual_khtt_all}    Set Variable If    '${input_khtt}' == 'all'    ${result_tongcong}    ${input_khtt}
    ${actual_khtt}    Set Variable If    '${input_khtt}' == '0'    0    ${actual_khtt_all}
    Return From Keyword    ${list_result_newprice}    ${result_tongcong}    ${result_discount_order}    ${actual_khtt}

Get receipt number - method - amount in tab Lich su thanh toan dat hang thr API
    [Arguments]    ${input_ma_dh}
    [Timeout]    5 mins
    ${jsonpath_id_order}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_dh}
    ${get_id_order}    Get data from API    ${endpoint_order}    ${jsonpath_id_order}
    ${endpoint_phieu_tt_hd}    Format String    ${endpoint_phieu_thanhtoan_dh}    ${get_id_order}
    ${get_resp}    Get Request and return body    ${endpoint_phieu_tt_hd}
    ${get_ma_phieu_tt}    Get raw data from response json        ${get_resp}    $..Code
    ${get_phuongthuc_tt}    Get raw data from response json    ${get_resp}    $..Method
    ${get_tienthu_tt}    Get raw data from response json    ${get_resp}    $..Amount
    Return From Keyword    ${get_ma_phieu_tt}    ${get_phuongthuc_tt}    ${get_tienthu_tt}

Get payload product incase create order
    [Arguments]    ${item_gia_ban}    ${item_id_sp}   ${list_soluong}    ${list_result_ggsp}   ${list_ggsp}      ${liststring_prs_order_detail}
    : FOR    ${item_soluong}    ${item_result_ggsp}   ${item_ggsp}      IN ZIP       ${list_soluong}   ${list_result_ggsp}    ${list_ggsp}
    \    ${item_ggsp}   Set Variable If    0 < ${item_ggsp} < 100    ${item_ggsp}   0
    \    ${payload_each_product}        Format string           {{"BasePrice":25000.06,"Discount":{0},"DiscountRatio":{1},"IsLotSerialControl":false,"IsMaster":false,"IsRewardPoint":false,"Note":"","Price":{2},"ProductCode":"DV049","ProductId":{3},"ProductName":"Nails 1","Quantity":{4},"SerialNumbers":"","Uuid":"","OriginPrice":{2},"ProductBatchExpireId":null}}    ${item_result_ggsp}   ${item_ggsp}    ${item_gia_ban}   ${item_id_sp}   ${item_soluong}
    \    Append To List      ${liststring_prs_order_detail}    ${payload_each_product}
    Return From Keyword    ${liststring_prs_order_detail}

Get payload product incase update order
    [Arguments]    ${item_gia_ban}   ${orderdetail_id}    ${item_id_sp}   ${list_soluong}    ${list_result_ggsp}   ${list_ggsp}      ${liststring_prs_order_detail}
    : FOR    ${item_soluong}    ${item_result_ggsp}   ${item_ggsp}      IN ZIP       ${list_soluong}   ${list_result_ggsp}    ${list_ggsp}
    \    ${item_ggsp}   Set Variable If    0 < ${item_ggsp} < 100    ${item_ggsp}   0
    \    ${payload_each_product}        Format string           {{"BasePrice":{0},"Discount":{1},"DiscountRatio":{2},"Id":{3},"IsBatchExpireControl":false,"IsLotSerialControl":false,"IsMaster":false,"IsRewardPoint":false,"MaxQuantity":0,"Note":"","Price":{0},"ProductCode":"HH0040","ProductId":{4},"ProductName":"Kẹo Mút Chupa Chups Hương Trái Cây","Quantity":{5},"SerialNumbers":"","Uuid":"","OriginPrice":{0},"ProductBatchExpireId":null}}    ${item_gia_ban}    ${item_result_ggsp}   ${item_ggsp}       ${orderdetail_id}   ${item_id_sp}   ${item_soluong}
    \    Append To List      ${liststring_prs_order_detail}    ${payload_each_product}
    Return From Keyword    ${liststring_prs_order_detail}

Get payload product incase process order
    [Arguments]    ${item_gia_ban}   ${item_id_sp}   ${list_soluong}    ${list_result_ggsp}   ${list_ggsp}   ${item_orderdetail_id}     ${liststring_prs_order_detail}
    : FOR    ${item_soluong}    ${item_result_ggsp}   ${item_ggsp}    IN ZIP       ${list_soluong}   ${list_result_ggsp}    ${list_ggsp}
    \    ${item_ggsp}   Set Variable If    0 < ${item_ggsp} < 100    ${item_ggsp}   0
    \    ${payload_each_product}        Format string           {{"BasePrice":{0},"IsLotSerialControl":false,"IsRewardPoint":false,"Note":"","Price":{0},"ProductId":{1},"Quantity":{2},"ProductCode":"DV008","Discount":{3},"DiscountRatio":{4},"ProductName":"Nhuộm tóc - Loreal","OriginPrice":{0},"PriceByPromotion":null,"IsMaster":true,"PromotionParentProductId":null,"ProductBatchExpireId":null,"CategoryId":794172,"MasterProductId":{1},"Unit":"","Uuid":"","OrderDetailId":{5},"ProductWarranty":[]}}    ${item_gia_ban}   ${item_id_sp}   ${item_soluong}    ${item_result_ggsp}   ${item_ggsp}   ${item_orderdetail_id}
    \    Append To List      ${liststring_prs_order_detail}    ${payload_each_product}
    Return From Keyword    ${liststring_prs_order_detail}

Get payload product incase process order have imei
    [Arguments]    ${item_gia_ban}   ${item_id_sp}   ${list_soluong}    ${list_result_ggsp}   ${list_ggsp}   ${item_orderdetail_id}     ${list_serialnumber}    ${imei_status}    ${liststring_prs_order_detail}
    : FOR    ${item_soluong}    ${item_result_ggsp}   ${item_ggsp}    ${item_imei}      IN ZIP       ${list_soluong}   ${list_result_ggsp}    ${list_ggsp}     ${list_serialnumber}
    \    ${item_ggsp}   Set Variable If    0 < ${item_ggsp} < 100    ${item_ggsp}   0
    \    ${item_imei}    Run Keyword If    ${imei_status} !=0     Convert list to string and return    ${item_imei}   ELSE    Set Variable    ${EMPTY}
    \    ${payload_each_product}        Format string           {{"BasePrice":{0},"IsLotSerialControl":true,"IsRewardPoint":false,"Note":"","Price":{0},"ProductId":{1},"Quantity":{2},"ProductCode":"SI008","SerialNumbers":"{3}","Discount":{4},"DiscountRatio":{5},"ProductName":"Bàn phím cơ ducky","OriginPrice":{0},"PriceByPromotion":null,"IsMaster":true,"PromotionParentProductId":null,"ProductBatchExpireId":null,"CategoryId":794174,"MasterProductId":{1},"Unit":"","Uuid":"","OrderDetailId":{6},"ProductWarranty":[]}}    ${item_gia_ban}   ${item_id_sp}   ${item_soluong}     ${item_imei}
    \    ...    ${item_result_ggsp}   ${item_ggsp}   ${item_orderdetail_id}
    \    Append To List      ${liststring_prs_order_detail}    ${payload_each_product}
    Return From Keyword    ${liststring_prs_order_detail}

Get guarranty info frm order API
    [Arguments]    ${input_order_id}    ${input_product_id}
    ${endpoint_warranty_detail}    Format String     ${endpoint_warranty_detail_in_order}    ${input_order_id}    ${input_product_id}
    ${resp}   Get Request and return body    ${endpoint_warranty_detail}
    ${get_time_bh_in_order}    Get raw data from response json    ${resp}    $..Data[?(@.WarrantyType==1)].NumberTime
    ${get_timetype_bh_in_order}    Get raw data from response json    ${resp}    $..Data[?(@.WarrantyType==1)].TimeType
    ${get_time_bt_in_order}    Get data from response json    ${resp}    $..Data[?(@.WarrantyType==3)].NumberTime
    ${get_timetype_bt_in_order}    Get data from response json    ${resp}    $..Data[?(@.WarrantyType==3)].TimeType
    Return From Keyword    ${get_time_bh_in_order}    ${get_timetype_bh_in_order}    ${get_time_bt_in_order}    ${get_timetype_bt_in_order}

Get list guarranty info frm order API
    [Arguments]    ${input_ordercode}    ${list_product}
    ${list_time_bh_in_order}   Create List
    ${list_timetype_bh_order}   Create List
    ${list_time_bt_in_order}   Create List
    ${list_timetype_bt_in_order}   Create List
    ${jsonpath_id_order}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ordercode}
    ${get_id_order}    Get data from API    ${endpoint_order}    ${jsonpath_id_order}
    ${get_list_product_id}    Get list product id thr API    ${list_product}
    :FOR    ${product_id}   IN      @{get_list_product_id}
    \    ${get_time_bh_in_order}    ${get_timetype_bh_in_order}    ${get_time_bt_in_order}    ${get_timetype_bt_in_order}   Get guarranty info frm order API
    \    ...    ${get_id_order}    ${product_id}
    \    Append To List     ${list_time_bh_in_order}    ${get_time_bh_in_order}
    \    Append To List     ${list_timetype_bh_order}    ${get_timetype_bh_in_order}
    \    Append To List     ${list_time_bt_in_order}    ${get_time_bt_in_order}
    \    Append To List     ${list_timetype_bt_in_order}    ${get_timetype_bt_in_order}
    Return From Keyword     ${list_time_bh_in_order}     ${list_timetype_bh_order}     ${list_time_bt_in_order}     ${list_timetype_bt_in_order}

Assert stock Cart in order api
    [Arguments]    ${invoice_code}    ${list_product}   ${result_list_toncuoi}
    ${list_soluong_in_hd}    ${list_giatri_quydoi_in_hd}    Get list quantity and gia tri quy doi by invoice code    ${list_product}    ${invoice_code}
    : FOR    ${ma_hh}    ${result_toncuoi}    ${item_soluong}    ${get_giatri_quydoi}    IN ZIP    ${list_product}
    ...    ${result_list_toncuoi}    ${list_soluong_in_hd}    ${list_giatri_quydoi_in_hd}
    \    Run Keyword If    '${get_giatri_quydoi}' == '1'    Validate product history frm API    ${invoice_code}    ${ma_hh}    ${result_toncuoi}
    \    ...    ${item_soluong}
    \    ...    ELSE    Validate unit product history frm API    ${invoice_code}    ${ma_hh}    ${result_toncuoi}
    \    ...    ${item_soluong}    ${get_giatri_quydoi}

Assert order summary in order api
    [Arguments]       ${input_ma_hh}      ${result_tong_dh}
    : FOR    ${time}    IN RANGE    10
    \     ${order_summary_af_execute}   Get order summary frm product API       ${input_ma_hh}
    \     Run Keyword If    '${order_summary_af_execute}'=='${result_tong_dh}'    Should Be Equal As Numbers    ${order_summary_af_execute}    ${result_tong_dh}
    \     Exit For Loop If    '${order_summary_af_execute}'=='${result_tong_dh}'

Assert list order summary in order api
    [Arguments]    ${list_product}    ${list_result_order_summary}
    :FOR      ${item_product}   ${result_tong_dh}   IN ZIP    ${list_product}    ${list_result_order_summary}
    \     Assert order summary in order api    ${item_product}   ${result_tong_dh}

Get order id and order detail id thr API
    [Arguments]    ${input_ma_dh}
    [Timeout]    5 mins
    ${jsonpath_id_order}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_dh}
    ${get_id_order}    Get data from API    ${endpoint_order}    ${jsonpath_id_order}
    ${endpoint_order_detail}    Format String    ${endpoint_order_detail}    ${get_id_order}
    ${get_id_orderdetail}    Get data from API    ${endpoint_order_detail}    $.OrderDetails..Id
    Return From Keyword    ${get_id_order}     ${get_id_orderdetail}

Get price book in order detail
    [Arguments]    ${input_ma_hd}
    [Timeout]    3 minutes
    ${get_id_hd}      Get order id
    ${endpoint_invoice_detail}    Format String    ${endpoint_invoice_detail}    ${get_id_hd}
    ${get_resp}     Get Request and return body    ${endpoint_invoice_detail}
    ${get_ten_banggia}    Get data from response json       ${get_resp}    $.PriceBook..Name
    Return From Keyword    ${get_ten_banggia}

Get discount product in orders
    [Arguments]    ${input_ma_dh}    ${input_product}
    [Timeout]    3 minutes
    ${get_id_hh}    Get product id thr API    ${input_product}
    ${jsonpath_id_order}    Format String    $..Data[?(@.Code =='{0}')].Id    ${input_ma_dh}
    ${get_id_order}    Get data from API    ${endpoint_order}    ${jsonpath_id_order}
    ${endpoint_orderdetail}    Format String    ${endpoint_order_detail}    ${get_id_order}
    ${get_resp}    Get Request and return body    ${endpoint_orderdetail}
    ${jsonpath_discount}    Format String    $..OrderDetails[?(@.ProductId=={0})].Discount    ${get_id_hh}
    ${get_discount}    Get data from response json    ${get_resp}    ${jsonpath_discount}
    Return From Keyword    ${get_discount}

Get order status value
    [Arguments]    ${input_ma_dh}
    [Timeout]    2 minutes
    ${jsonpath_id_order}    Format String    $..Data[?(@.Code =={0})].Id    ${input_ma_dh}
    ${get_id_order}    Get data from API    ${endpoint_order}    ${jsonpath_id_order}
    ${endpoint_orderdetail}    Format String    ${endpoint_order_detail}    ${get_id_order}
    ${get_resp}    Get Request and return body    ${endpoint_orderdetail}
    ${get_status}    Get data from response json    ${get_resp}    $..StatusValue
    Return From Keyword    ${get_status}

Get promo id and discount value of order
    [Arguments]    ${input_ma_dh}
    [Timeout]    2 minutes
    ${jsonpath_id_order}    Format String    $..Data[?(@.Code =={0})].Id    ${input_ma_dh}
    ${get_id_order}    Get data from API    ${endpoint_order}    ${jsonpath_id_order}
    ${endpoint_orderdetail}    Format String    ${endpoint_order_detail}    ${get_id_order}
    ${get_resp}    Get Request and return body    ${endpoint_orderdetail}
    ${get_discount}    Get data from response json    ${get_resp}    $..CompareDiscount
    ${get_promo_id}    Get data from response json    ${get_resp}    $..OrderPromotions..PromotionId
    Return From Keyword    ${get_promo_id}    ${get_discount}

# lấy ra giá trị giảm giá của list hàng hóa có chứa hàng hóa giống nhau nhưng khác giảm giá
Get discounts of product in order
    [Arguments]    ${input_ma_dh}    ${input_product}    ${index}
    [Timeout]    3 minutes
    ${get_list_discount}    Create List
    ${get_id_hh}    Get product id thr API    ${input_product}
    ${jsonpath_id_order}    Format String    $..Data[?(@.Code =='{0}')].Id    ${input_ma_dh}
    ${get_id_order}    Get data from API    ${endpoint_order}    ${jsonpath_id_order}
    ${endpoint_orderdetail}    Format String    ${endpoint_order_detail}    ${get_id_order}
    ${get_resp}    Get Request and return body    ${endpoint_orderdetail}
    ${jsonpath_discount}    Format String    $..OrderDetails[?(@.ProductId=={0})].Discount    ${get_id_hh}
    ${get_list_discount}    Get raw data from response json    ${get_resp}    ${jsonpath_discount}
    ${get_discount}    Get From List    ${get_list_discount}    ${index}
    Return From Keyword    ${get_discount}

Get values in combine order
    [Arguments]    ${input_ma_dh}
    [Timeout]    2 minutes
    ${jsonpath_id_order}    Format String    $..Data[?(@.Code =={0})].Id    ${input_ma_dh}
    ${get_id_order}    Get data from API    ${endpoint_order}    ${jsonpath_id_order}
    ${endpoint_orderdetail}    Format String    ${endpoint_order_detail}    ${get_id_order}
    ${get_resp}    Get Request and return body    ${endpoint_orderdetail}
    ${get_soluong}    Get data from response json    ${get_resp}    $.TotalQuantity
    ${get_comparetotal}    Get data from response json    ${get_resp}    $.CompareTotal
    ${get_subtotal}    Get data from response json    ${get_resp}    $.SubTotal
    ${get_discount}    Get data from response json    ${get_resp}    $.Discount
    ${get_payment}    Get data from response json    ${get_resp}    $.TotalPayment
    Return From Keyword    ${get_soluong}    ${get_subtotal}    ${get_comparetotal}    ${get_discount}    ${get_payment}

Get info order have discount product after created
    ${tongtienhang}    Set Variable    ${tongtienhang}
    ${get_ggdh}    Set Variable    ${ggdh}
    ${get_tongcong}    Set Variable    ${tongcong}
    ${list_giaban}    Set Variable    ${list_giabansp}
    ${list_discount}    Set Variable    ${list_ggsp}
    Return From Keyword    ${tongtienhang}    ${get_tongcong}     ${get_ggdh}    ${list_giaban}    ${list_discount}

Get info order after created
    ${tongtienhang}    Set Variable    ${tongtienhang}
    ${get_tongcong}    Set Variable    ${tongcong}
    ${khach_tt}    Set Variable    ${actual_khtt}
    ${list_giaban}    Set Variable    ${list_giabansp}
    Return From Keyword    ${tongtienhang}    ${get_tongcong}    ${khach_tt}    ${list_giaban}

Validate products and combine list before combine order
    [Arguments]    ${list_product1}    ${list_product2}    ${list_giaban1}    ${list_giaban2}    ${list_discount1}    ${list_discount2}    ${list_nums1}    ${list_nums2}    ${discount_type1}    ${discount_type2}
    ...    ${list_dh1}    ${list_dh2}    ${get_tongtienhang1}    ${get_tongcong1}    ${get_ggdh1}    ${get_tongtienhang2}    ${get_tongcong2}    ${get_ggdh2}
    ${list_ggsp1}    Create List
    ${list_ggsp2}    Create List
    ${list_tong_dh1}    Create List
    ${list_tong_dh2}    Create List
    ${list_sl1_expected}    Create List
    #validate
    : FOR    ${item_hh1}    ${item_hh2}    ${item_giaban1}    ${item_giaban2}    ${item_discount1}    ${item_discount2}    ${item_sl1}    ${item_sl2}
    ...    ${item_discount_type1}    ${item_discount_type2}    ${item_dh1}    ${item_dh2}
    ...    IN ZIP    ${list_product1}    ${list_product2}    ${list_giaban1}    ${list_giaban2}    ${list_discount1}    ${list_discount2}    ${list_nums1}
    ...    ${list_nums2}    ${discount_type1}    ${discount_type2}    ${list_dh1}    ${list_dh2}
    \    ${index}=    Run Keyword If    '${item_hh1}'=='${item_hh2}' and ${item_giaban1}==${item_giaban2} and ${item_discount1}==${item_discount2}    Get Index From List    ${list_product2}    ${item_hh2}
    \    ${sl1}=    Run Keyword If    '${index}'!='None'    Sum    ${item_sl1}    ${item_sl2}    ELSE    Set Variable    ${item_sl1}
    \    ${item_ggsp1}=    Run Keyword If    '${item_discount_type1}'!='dis' and '${item_discount_type1}'!='disvnd'   Set Variable    0    ELSE    Set Variable    ${item_discount1}
    \    ${item_ggsp2}=    Run Keyword If    '${item_discount_type2}'!='dis' and '${item_discount_type2}'!='disvnd'   Set Variable    0    ELSE    Set Variable    ${item_discount2}
    \    ${sum_sl}=    Run Keyword If    '${item_hh1}'=='${item_hh2}'    Sum    ${item_sl1}    ${item_sl2}
    \    ${item_dh1}=    Run Keyword If    '${item_hh1}'=='${item_hh2}'    Sum    ${item_dh1}    ${sum_sl}    ELSE    Sum    ${item_dh1}    ${item_sl1}
    \    ${item_dh2}=    Run Keyword If    '${item_hh1}'=='${item_hh2}'    Set Variable    ${item_dh1}    ELSE    Sum    ${item_dh2}    ${item_sl2}
    \    Append To List    ${list_tong_dh1}    ${item_dh1}
    \    Append To List    ${list_tong_dh2}    ${item_dh2}
    \    Append To List    ${list_ggsp1}    ${item_ggsp1}
    \    Append To List    ${list_ggsp2}    ${item_ggsp2}
    \    Append To List    ${list_sl1_expected}    ${sl1}
    \    Run Keyword If    '${index}'!='None'    Run Keywords    Remove From List    ${list_product2}    ${index}
    \    ...    AND    Remove From List    ${list_nums2}    ${index}    AND    Remove From List    ${list_tong_dh2}    ${index}
    \    ...    AND    Remove From List    ${list_giaban2}    ${index}    AND    Remove From List    ${list_ggsp2}    ${index}
    #combine list
    ${list_product_af_combine}    Combine Lists    ${list_product1}    ${list_product2}
    ${list_nums_af_combine}    Combine Lists   ${list_sl1_expected}    ${list_nums2}
    ${tong_so_luong}    Sum values in list    ${list_nums_af_combine}
    ${list_tong_dh_expeted}    Combine Lists    ${list_tong_dh1}    ${list_tong_dh2}
    ${tong_tien_hang}    Sum    ${get_tongtienhang1}    ${get_tongtienhang2}
    ${giam_gia_phieu_dat}    Sum    ${get_ggdh1}    ${get_ggdh2}
    ${tong_cong}    Sum    ${get_tongcong1}    ${get_tongcong2}
    Return From Keyword    ${list_product_af_combine}    ${tong_so_luong}    ${list_tong_dh_expeted}    ${tong_tien_hang}    ${giam_gia_phieu_dat}    ${tong_cong}

Validate products and combine list before combine - orders have promotion
    [Arguments]    ${list_product1}    ${list_product2}    ${list_giaban1}    ${list_giaban2}    ${list_nums1}    ${list_nums2}
    ...    ${list_dh1}    ${list_dh2}    ${get_tongtienhang1}    ${get_tongcong1}    ${get_tongtienhang2}    ${get_tongcong2}
    ${list_ggsp1}    Create List
    ${list_ggsp2}    Create List
    ${list_tong_dh1}    Create List
    ${list_tong_dh2}    Create List
    ${list_sl1_expected}    Create List
    #validate
    : FOR    ${item_hh1}    ${item_hh2}    ${item_giaban1}    ${item_giaban2}    ${item_sl1}    ${item_sl2}    ${item_dh1}    ${item_dh2}
    ...    IN ZIP    ${list_product1}    ${list_product2}    ${list_giaban1}    ${list_giaban2}    ${list_nums1}    ${list_nums2}    ${list_dh1}    ${list_dh2}
    \    ${index}=    Run Keyword If    '${item_hh1}'=='${item_hh2}' and ${item_giaban1}==${item_giaban2}    Get Index From List    ${list_product2}    ${item_hh2}
    \    ${sl1}=    Run Keyword If    '${index}'!='None'    Sum    ${item_sl1}    ${item_sl2}    ELSE    Set Variable    ${item_sl1}
    \    ${sum_sl}=    Run Keyword If    '${item_hh1}'=='${item_hh2}'    Sum    ${item_sl1}    ${item_sl2}
    \    ${item_dh1}=    Run Keyword If    '${item_hh1}'=='${item_hh2}'    Sum    ${item_dh1}    ${sum_sl}    ELSE    Sum    ${item_dh1}    ${item_sl1}
    \    ${item_dh2}=    Run Keyword If    '${item_hh1}'=='${item_hh2}'    Set Variable    ${item_dh1}    ELSE    Sum    ${item_dh2}    ${item_sl2}
    \    Append To List    ${list_tong_dh1}    ${item_dh1}
    \    Append To List    ${list_tong_dh2}    ${item_dh2}
    \    Append To List    ${list_sl1_expected}    ${sl1}
    \    Run Keyword If    '${index}'!='None'    Run Keywords    Remove From List    ${list_product2}    ${index}
    \    ...    AND    Remove From List    ${list_nums2}    ${index}    AND    Remove From List    ${list_tong_dh2}    ${index}
    \    ...    AND    Remove From List    ${list_giaban2}    ${index}
    #combine list
    ${list_product_af_combine}    Combine Lists    ${list_product1}    ${list_product2}
    ${list_nums_af_combine}    Combine Lists   ${list_sl1_expected}    ${list_nums2}
    ${tong_so_luong}    Sum values in list    ${list_nums_af_combine}
    ${list_tong_dh_expeted}    Combine Lists    ${list_tong_dh1}    ${list_tong_dh2}
    ${tong_tien_hang}    Sum    ${get_tongtienhang1}    ${get_tongtienhang2}
    ${tong_cong}    Sum    ${get_tongcong1}    ${get_tongcong2}
    Return From Keyword    ${list_product_af_combine}    ${tong_so_luong}    ${list_tong_dh_expeted}    ${tong_tien_hang}   ${tong_cong}

Get info and validate order after combine
    [Arguments]    ${Get_combine_code}    ${list_product_af_combine}    ${list_tong_dh_expeted}    ${tong_so_luong}    ${tong_tien_hang}    ${giam_gia_phieu_dat}    ${tong_cong}
    ...    ${input_khtt}    ${order_code1}    ${order_code2}
    ${khach_tt}    Run Keyword If    ${input_khtt} != 0    Set Variable    ${actual_khtt}    ELSE    Set Variable    0
    ${list_order_summary}    Get list order summary by order code    ${Get_combine_code}
    ${promo_id}    ${discount_dh}    Get promo id and discount value of order    ${Get_combine_code}
    ${get_list_hh_in_order}    ${get_list_sl_in_order}    Get list product and quantity frm API    ${Get_combine_code}
    ${get_soluong}    ${get_subtotal}    ${get_comparetotal}    ${get_discount}    ${get_payment}    Get values in combine order    ${Get_combine_code}
    #so sánh kqua gop
    :FOR      ${item_product_af_combine}    ${item_hh_in_order}    ${item_dh}    ${item_order_summary}
    ...    IN ZIP    ${list_product_af_combine}    ${get_list_hh_in_order}    ${list_tong_dh_expeted}    ${list_order_summary}
    \    Should Be Equal As Strings    ${item_product_af_combine}    ${item_hh_in_order}
    \    Should Be Equal As Numbers    ${item_dh}    ${item_order_summary}    #KH dat
    Should Be Equal As Numbers    ${get_soluong}    ${tong_so_luong}     #giam gia sp
    Should Be Equal As Numbers    ${get_subtotal}    ${tong_tien_hang}     #tong tien chua giam gia
    Should Be Equal As Numbers    ${get_discount}    ${giam_gia_phieu_dat}     #gg phieu dat hang
    Should Be Equal As Numbers    ${get_comparetotal}    ${tong_cong}     #tongcong
    Should Be Equal As Numbers    ${get_payment}    ${khach_tt}     #khach tt
    ${status1}    Get order status value    ${order_code1}
    Should Be Equal As Strings    ${status1}    Đã hủy
    ${status2}    Get order status value    ${order_code2}
    Should Be Equal As Strings    ${status2}    Đã hủy

Get info and validate order combine - orders have promotion
    [Arguments]    ${Get_combine_code}    ${list_product_af_combine}    ${tong_so_luong}    ${tong_tien_hang}    ${tong_cong}
    ...    ${list_tong_dh_expeted}    ${order_code1}    ${order_code2}    ${khach_tt1}    ${khach_tt2}
    ${khach_tt}    Sum    ${khach_tt1}    ${khach_tt2}
    ${list_order_summary}    Get list order summary by order code    ${Get_combine_code}
    ${promo_id}    ${discount_dh}    Get promo id and discount value of order    ${Get_combine_code}
    ${get_list_hh_in_order}    ${get_list_sl_in_order}    Get list product and quantity frm API    ${Get_combine_code}
    ${get_soluong}    ${get_subtotal}    ${get_comparetotal}    ${get_discount}    ${get_payment}    Get values in combine order    ${Get_combine_code}
    #so sánh list
    :FOR      ${item_product_af_combine}    ${item_hh_in_order}    ${item_dh}    ${item_order_summary}    IN ZIP    ${list_product_af_combine}    ${get_list_hh_in_order}
    ...    ${list_tong_dh_expeted}    ${list_order_summary}
    \    Should Be Equal As Strings    ${item_product_af_combine}    ${item_hh_in_order}
    \    Should Be Equal As Numbers    ${item_dh}    ${item_order_summary}
    Should Be Equal As Numbers    ${promo_id}    0    #không gộp ctrinh KM (bỏ)
    Should Be Equal As Numbers    ${get_soluong}    ${tong_so_luong}     #giam gia sp
    Should Be Equal As Numbers    ${get_subtotal}    ${tong_tien_hang}     #tong tien chua giam gia
    Should Be Equal As Numbers    ${get_discount}    0     #gg phieu dat hang
    Should Be Equal As Numbers    ${get_comparetotal}    ${tong_cong}     #tongcong
    Should Be Equal As Numbers    ${get_payment}    ${khach_tt}     #khach tt
    ${status1}    Get order status value    ${order_code1}
    Should Be Equal As Strings    ${status1}    Đã hủy
    ${status2}    Get order status value    ${order_code2}
    Should Be Equal As Strings    ${status2}    Đã hủy

Assert order exist succeed
    [Arguments]    ${input_ma_dh}
    ${jsonpath_id_order}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_dh}
    ${get_id_order}    Get data from API    ${endpoint_order}    ${jsonpath_id_order}
    Should Not Be Equal As Numbers    ${get_id_order}     0

Get delivery order info thr API
    [Arguments]    ${input_ma_dh}
    [Timeout]    3 minutes
    ${jsonpath_id_dh}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_dh}
    ${get_id_dh}    Get data from API    ${endpoint_order}    ${jsonpath_id_dh}
    ${endpoint_orderdetail}    Format String    ${endpoint_order_detail}    ${get_id_dh}
    ${get_resp}    Get Request and return body    ${endpoint_orderdetail}
    ${get_diachi}    Get data from response json    ${get_resp}    $.DeliveryDetail.Address
    ${get_khuvuc}    Get data from response json    ${get_resp}    $.DeliveryDetail.LocationName
    ${get_phuongxa}    Get data from response json    ${get_resp}    $.DeliveryDetail.WardName
    ${get_nguoinhan}    Get data from response json    ${get_resp}    $.DeliveryDetail.Receiver
    ${get_nguoigiao}    Get data from response json    ${get_resp}    $.DeliveryDetail.PartnerName
    Return From Keyword    ${get_nguoigiao}    ${get_nguoinhan}     ${get_diachi}    ${get_khuvuc}    ${get_phuongxa}

Assert values by order code
    [Arguments]     ${ma_dh_kv}     ${input_ma_kh}      ${input_trangthai_dathang}      ${input_tongtienhang}     ${input_khachdatra}     ${input_ggdh}
    ${get_ma_kh_in_dh_af_execute}    ${get_TTDH_in_dh_af_execute}    ${get_tongtienhang_in_dh_af_exxecute}    ${get_khachdatra_in_dh_af_execute}    ${get_giamgia_in_dh_af_execute}    ${get_tongcong_in_dh_af_execute}    ${get_ghichu_in_dh_af_execute}
    ...    Get order info incase discount by order code    ${ma_dh_kv}
    Should Be Equal As Strings    ${get_ma_kh_in_dh_af_execute}    ${input_ma_kh}
    Should Be Equal As Numbers    ${get_TTDH_in_dh_af_execute}    ${input_trangthai_dathang}         #1 : Phiếu tạm, 2: Đang giao hàng, 3: Hoàn thành, 4: Đã hủy
    Should Be Equal As Numbers    ${get_tongcong_in_dh_af_execute}    ${input_tongtienhang}
    Should Be Equal As Numbers    ${get_khachdatra_in_dh_af_execute}    ${input_khachdatra}
    Should Be Equal As Numbers    ${get_giamgia_in_dh_af_execute}    ${input_ggdh}

Assert values by order code until succeed
    [Arguments]     ${ma_dh_kv}     ${input_ma_kh}      ${input_trangthai_dathang}      ${input_tongtienhang}     ${input_khachdatra}     ${input_ggdh}
    Wait Until Keyword Succeeds    5x    3s    Assert values by order code    ${ma_dh_kv}     ${input_ma_kh}      ${input_trangthai_dathang}      ${input_tongtienhang}     ${input_khachdatra}     ${input_ggdh}

Assert delivery info by order code
    [Arguments]     ${ma_dh_kv}     ${input_dtgh}     ${input_ten_kh}   ${input_diachi}   ${input_khuvuc}   ${input_phuongxa}
    ${get_nguoigiao}    ${get_nguoinhan}     ${get_diachi}    ${get_khuvuc}    ${get_phuongxa}    Get delivery order info thr API    ${ma_dh_kv}
    Should Be Equal As Strings    ${get_nguoigiao}    ${input_dtgh}
    Should Be Equal As Strings    ${get_nguoinhan}    ${input_ten_kh}
    Should Be Equal As Strings    ${get_diachi}    ${input_diachi}
    Should Be Equal As Strings    ${get_khuvuc}    ${input_khuvuc}
    Should Be Equal As Strings    ${get_phuongxa}    ${input_phuongxa}

Assert delivery info by order code until succeed
    [Arguments]     ${ma_dh_kv}     ${input_dtgh}     ${input_ten_kh}   ${input_diachi}   ${input_khuvuc}   ${input_phuongxa}
    Wait Until Keyword Succeeds    5x    3s     Assert delivery info by order code    ${ma_dh_kv}     ${input_dtgh}     ${input_ten_kh}   ${input_diachi}   ${input_khuvuc}   ${input_phuongxa}

Assert order summarry after execute
    [Arguments]    ${result_tong_dh}    ${item_product}
    :FOR    ${time}     IN RANGE    10
    \    ${get_ordersummary}     Get order summary frm product API    ${item_product}
    \    Run Keyword If    '${get_ordersummary}'=='${result_tong_dh}'    Should Be Equal As Numbers    ${result_tong_dh}    ${get_ordersummary}
    \    ...    Log   Ignore input
    \   Exit For Loop If    '${get_ordersummary}'=='${result_tong_dh}'

Assert list of order summarry after execute
    [Arguments]    ${list_product}    ${get_list_result_ordersummary_excute}
    :FOR    ${item_product}    ${result_tong_dh}        IN ZIP    ${list_product}    ${get_list_result_ordersummary_excute}
    \    Assert order summarry after execute    ${result_tong_dh}    ${item_product}

Assert order info after execute
    [Arguments]    ${input_ma_kh}   ${status_order}    ${result_tongtienhang}    ${actual_khtt}    ${result_ggdh}    ${result_tongcong}    ${input_ghichu}    ${order_code}
    ${get_ma_kh_af_execute}    ${get_TTDH_af_execute}    ${get_tongtienhang_af_exxecute}    ${get_khachdatra_af_execute}    ${get_giamgia_af_execute}
    ...    ${get_tongcong_af_execute}    ${get_ghichu_af_execute}    Get order info incase discount by order code    ${order_code}
    Should Be Equal As Strings    ${get_ma_kh_af_execute}    ${input_ma_kh}
    Should Be Equal As Numbers    ${get_TTDH_af_execute}   ${status_order}
    Should Be Equal As Numbers    ${get_tongtienhang_af_exxecute}    ${result_tongtienhang}
    Should Be Equal As Numbers    ${get_khachdatra_af_execute}    ${actual_khtt}
    Should Be Equal As Numbers    ${get_giamgia_af_execute}    ${result_ggdh}
    Should Be Equal As Numbers    ${get_tongcong_af_execute}    ${result_tongcong}
    Should Be Equal As Strings    ${get_ghichu_af_execute}    ${input_ghichu}

Assert customer debit amount and general ledger after execute
    [Arguments]    ${input_ma_kh}    ${order_code}    ${input_khtt}    ${actual_khtt}    ${result_no_hientai_kh}    ${get_tongban_bf_execute}   ${get_tongban_tru_trahang_bf_execute}
    ${get_no_af_execute}    ${get_tongban_af_execute}    ${get_tongban_tru_trahang_af_execute}    Get Customer Debt from API    ${input_ma_kh}
    ${get_ma_phieutt}    Get ma phieu thanh toan dat hang frm API    ${order_code}
    Should Be Equal As Numbers    ${get_no_af_execute}    ${result_no_hientai_kh}
    Should Be Equal As Numbers    ${get_tongban_af_execute}    ${get_tongban_bf_execute}
    Should Be Equal As Numbers    ${get_tongban_tru_trahang_af_execute}    ${get_tongban_tru_trahang_bf_execute}
    Run Keyword If    '${input_khtt}' == '0'    Validate history in customer if order is not paid    ${input_ma_kh}    ${order_code}
    ...    ELSE    Validate history and debt in customer if order is paid    ${input_ma_kh}    ${order_code}    ${actual_khtt}    ${result_no_hientai_kh}
    Run Keyword If    '${input_khtt}' == '0'    Validate So quy info from Rest API if Invoice is not paid    ${order_code}
    ...    ELSE    Validate So quy info from Rest API if Invoice is paid    ${get_ma_phieutt}    ${actual_khtt}

Get order summary infor by order code thr API
    [Arguments]     ${order_code}
    ${endpoint_order_by_ordercode}      Format String     ${endpoint_order_by_ordercode}      ${order_code}
    ${resp}     Get Request and return body    ${endpoint_order_by_ordercode}
    ${get_ma_kh}      Get data from response json    ${resp}    $.Data[?(@.Code=='${order_code}')].Customer.Code
    ${get_khachcantra}      Get data from response json    ${resp}    $.Data[?(@.Code=='${order_code}')].Total
    ${get_khachdatra}      Get data from response json    ${resp}    $.Data[?(@.Code=='${order_code}')].TotalPayment
    ${input_trangthai_dh}      Get data from response json    ${resp}    $.Data[?(@.Code=='${order_code}')].StatusValue
    Return From Keyword    ${get_ma_kh}     ${get_khachcantra}    ${get_khachdatra}      ${input_trangthai_dh}

Assert order summary values after excute
    [Arguments]     ${order_code}      ${input_ma_kh}       ${input_khachcantra}    ${input_khachdatra}   ${input_trangthai_dh}
    ${get_ma_kh}    ${get_khachcantra}    ${get_khachdatra}      ${get_trangthai_hd}     Get order summary infor by order code thr API    ${order_code}
    Should Be Equal As Strings    ${input_ma_kh}    ${get_ma_kh}
    Should Be Equal As Numbers    ${input_khachcantra}    ${get_khachcantra}
    Should Be Equal As Numbers    ${input_khachdatra}    ${get_khachdatra}
    Should Be Equal As Strings    ${input_trangthai_dh}    ${get_trangthai_hd}

Assert order summary values until succeed
    [Arguments]     ${order_code}      ${input_ma_kh}     ${input_khachcantra}    ${input_khachdatra}   ${input_trangthai_dh}
    Wait Until Keyword Succeeds    3x    3x    Assert order summary values after excute    ${order_code}      ${input_ma_kh}       ${input_khachcantra}    ${input_khachdatra}   ${input_trangthai_dh}

Computation total, discount and pay for customer incase order
    [Arguments]    ${input_bh_ma_kh}    ${list_result_thanhtien}    ${input_ggdh}    ${input_khtt}
    ${get_no_bf_execute}    ${get_tongban_bf_execute}    ${get_tongban_tru_trahang_bf_execute}    Get Customer Debt from API    ${input_bh_ma_kh}
    ${result_tongtienhang}    Sum values in list    ${list_result_thanhtien}
    ${result_tongtienhang}    Replace floating point    ${result_tongtienhang}
    ${result_tongcong}    Run Keyword If    0 < ${input_ggdh} < 100    Price after % discount invoice    ${result_tongtienhang}    ${input_ggdh}
    ...    ELSE IF    ${input_ggdh} > 100    Minus and replace floating point    ${result_tongtienhang}    ${input_ggdh}
    ...    ELSE    Set Variable    ${result_tongtienhang}
    ${result_ggdh}    Run Keyword If    0 < ${input_ggdh} < 100    Convert % discount to VND and round    ${result_tongtienhang}    ${input_ggdh}
    ...    ELSE    Set Variable    ${input_ggdh}
    ${result_tongcong}    Replace floating point    ${result_tongcong}
    ${actual_khtt_all}    Set Variable If    '${input_khtt}' == 'all'    ${result_tongcong}    ${input_khtt}
    ${actual_khtt}    Set Variable If    '${input_khtt}' == '0'    0    ${actual_khtt_all}
    ${result_no_hientai_kh}    Minus    ${get_no_bf_execute}    ${actual_khtt}    #Do đặt hàng không ghi nhận phiếu đặt, mà phiếu thanh toán ghi nhận là số âm nên khi tính công nợ sẽ là trừ
    Return From Keyword    ${result_tongtienhang}    ${result_tongcong}    ${result_ggdh}    ${actual_khtt}    ${result_no_hientai_kh}
