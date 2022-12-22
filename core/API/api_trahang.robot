*** Settings ***
Resource          ../../config/env_product/envi.robot
Resource          api_khachhang.robot
Resource          api_danhmuc_hanghoa.robot
Resource          api_access.robot
Resource          api_mhbh.robot
Resource          ../Tra_hang/tra_hang_action.robot
Resource          ../Ban_Hang/banhang_getandcompute.robot

*** Variables ***
${endpoint_trahang}    /returns?format=json&Includes=Branch&Includes=Invoice&Includes=Customer&Includes=TotalReturn&Includes=TotalQuantity&Includes=TotalPayment&Includes=ReceivedBy&Includes=PaymentCode&Includes=PaymentId&Includes=Payments&Includes=User&Includes=InvoiceOrderSurcharges&Includes=TableAndRoom&ForSummaryRow=true&ForManage=True&Includes=SaleChannel&%24inlinecount=allpages&%24top=50&%24filter=(BranchId+eq+{0}+and+ReturnDate+eq+%27year%27+and+Status+eq+1)    #id Branch
${endpoint_return_detail}    /returns/{0}?Includes=TotalPayment&Includes=TotalReturn&Includes=return&Includes=Payments&Includes=Customer    #id tra hang
${endpoint_phieu_thanhtoan_th}    /payments/code?Code={0}&ExcluceSystem=1&ForDetail=1&Includes=User&Includes=Customer&Includes=OrderValue    #ma phieu thanh toan tra hang
${endpoint_tab_lichsu_trahang_in_invoice}    /returns?format=json&Includes=ReceivedBy&Includes=TotalReturn&InvoiceId={0}&%24inlinecount=allpages #id hóa đơn
${endpoint_hoadon_doihang}    /invoices/{0}?Includes=TotalQuantity&Includes=User&Includes=SoldBy&Includes=PaymentCode&Includes=InvoiceOrderSurcharges&Includes=Return&Includes=Payments&Includes=InvoiceWarranties    #id ma doi hang
${endpoint_delete_return}    /returns/{0}?CompareCode={1}&IsVoidPayment=true
${endpoint_phieu_thanhtoan_thnhanh}   /payments?ReturnId={0}&format=json&Includes=User&Includes=CustomerName&Includes=Return&GroupCode=true&%24inlinecount=allpages&%24top=15   #id trả hàng
${endpoint_trahang_currentdate}   /returns?format=json&%24filter=(BranchId+eq+{0}+and+(ReturnDate+ge+datetime%27{1}T00%3A00%3A00%27)+and+Status+eq+1)   #branchid - current date

*** Keywords ***
Get list product frm Return API
    [Arguments]    ${input_ma_th}
    [Timeout]    3 minute
    ${jsonpath_id_th}    Format String    $.Data[?(@.Code == '{0}')].Id    ${input_ma_th}
    ${endpoint_trahang_by_branch}    Format String    ${endpoint_trahang}    ${BRANCH_ID}
    ${get_id_th }    Get data from API    ${endpoint_trahang_by_branch}    ${jsonpath_id_th}
    ${endpoint_returndetail}    Format String    ${endpoint_return_detail}    ${get_id_th}
    ${get_list_hh_in_return}    Get raw data from API    ${endpoint_returndetail}    $.ReturnDetails..Code
    Return From Keyword    ${get_list_hh_in_return}

Get list quantity and gia tri quy doi with return have multi product
    [Arguments]    ${list_product}    ${input_ma_th}
    [Timeout]    5 minute
    ${list_soluong_in_hd}    Create List
    ${list_giatriquydoi_in_hd}    Create List
    ${jsonpath_id_th}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_th}
    ${endpoint_trahang_by_branch}    Format String    ${endpoint_trahang}    ${BRANCH_ID}
    ${get_id_th }    Get data from API    ${endpoint_trahang_by_branch}    ${jsonpath_id_th}
    ${endpoint_returndetail}    Format String    ${endpoint_return_detail}    ${get_id_th }
    ${get_resp}    Get Request and return body    ${endpoint_returndetail}
    : FOR    ${item_ma_hang}    IN    @{list_product}
    \    ${jsonpath_soluong}    Format String    $.ReturnDetails[?(@.Product.Code == '{0}')].Quantity    ${item_ma_hang}
    \    ${jsonpath_giatri_quydoi}    Format String    $.ReturnDetails[?(@.Product.Code == '{0}')]..ConversionValue    ${item_ma_hang}
    \    ${get_so_luong_in_hd}    Get data from response json    ${get_resp}    ${jsonpath_soluong}
    \    ${get_giatri_quydoi_in_hd}    Get data from response json    ${get_resp}    ${jsonpath_giatri_quydoi}
    \    Append To list    ${list_soluong_in_hd}    ${get_so_luong_in_hd}
    \    Append To list    ${list_giatriquydoi_in_hd}    ${get_giatri_quydoi_in_hd}
    Return From Keyword    ${list_soluong_in_hd}    ${list_giatriquydoi_in_hd}

Get return info by return code
    [Arguments]    ${input_ma_th}
    [Timeout]    5 minute
    ${endpoint_trahang}    Format String    ${endpoint_trahang}    ${BranchId}
    ${get_resp}    Get Request and return body    ${endpoint_trahang}
    ${jsonpath_tongtienhangtra}    Format String    $.Data[?(@.Code == '{0}')].TotalReturn    ${input_ma_th}
    ${jsonpath_phitrahang}    Format String    $.Data[?(@.Code == '{0}')].ReturnFee    ${input_ma_th}
    ${jsonpath_cantrakhach}    Format String    $.Data[?(@.Code == '{0}')].NewReturnTotal    ${input_ma_th}
    ${jsonpath_datrakhach}    Format String    $.Data[?(@.Code == '{0}')].TotalPayment    ${input_ma_th}
    ${jsonpath_tongtien_hoadontra}    Format String    $.Data[?(@.Code == '{0}')].ReturnTotal    ${input_ma_th}
    ${get_tongtienhangtra}    Get data from response json    ${get_resp}    ${jsonpath_tongtienhangtra}
    ${get_phitrahang}    Get data from response json    ${get_resp}    ${jsonpath_phitrahang}
    ${get_cantrakhach}    Get data from response json    ${get_resp}    ${jsonpath_cantrakhach}
    ${get_datrakhach}    Get data from response json    ${get_resp}    ${jsonpath_datrakhach}
    ${get_datrakhach}    Get data from response json    ${get_resp}    ${jsonpath_datrakhach}
    ${get_datrakhach}    Convert To String    ${get_datrakhach}
    ${get_datrakhach}    Replace String    ${get_datrakhach}    -    ${EMPTY}
    ${get_datrakhach}    Convert To Number    ${get_datrakhach}
    ${get_tongtien_hoadontra}    Get data from response json    ${get_resp}    ${jsonpath_tongtien_hoadontra}
    Return From Keyword    ${get_tongtienhangtra}    ${get_phitrahang}    ${get_cantrakhach}    ${get_datrakhach}    ${get_tongtien_hoadontra}

Get return info incase discount by return code
    [Arguments]    ${input_ma_th}
    [Timeout]    5 minute
    ${endpoint_trahang}    Format String    ${endpoint_trahang}    ${BranchId}
    ${get_resp}    Get Request and return body    ${endpoint_trahang}
    ${jsonpath_tongtienhangtra}    Format String    $.Data[?(@.Code == '{0}')].TotalReturn    ${input_ma_th}
    ${jsonpath_giamgiaphieutra}    Format String    $.Data[?(@.Code == '{0}')].ReturnDiscount    ${input_ma_th}
    ${jsonpath_phitrahang}    Format String    $.Data[?(@.Code == '{0}')].ReturnFee    ${input_ma_th}
    ${jsonpath_cantrakhach}    Format String    $.Data[?(@.Code == '{0}')].NewReturnTotal    ${input_ma_th}
    ${jsonpath_datrakhach}    Format String    $.Data[?(@.Code == '{0}')].TotalPayment    ${input_ma_th}
    ${jsonpath_tongtien_hoadontra}    Format String    $.Data[?(@.Code == '{0}')].ReturnTotal    ${input_ma_th}
    ${get_tongtienhangtra}    Get data from response json    ${get_resp}    ${jsonpath_tongtienhangtra}
    ${get_giamgiaphieutra}    Get data from response json    ${get_resp}    ${jsonpath_giamgiaphieutra}
    ${get_phitrahang}    Get data from response json    ${get_resp}    ${jsonpath_phitrahang}
    ${get_cantrakhach}    Get data from response json    ${get_resp}    ${jsonpath_cantrakhach}
    ${get_datrakhach}    Get data from response json    ${get_resp}    ${jsonpath_datrakhach}
    ${get_datrakhach}    Convert To String    ${get_datrakhach}
    ${get_datrakhach}    Replace String    ${get_datrakhach}    -    ${EMPTY}
    ${get_datrakhach}    Convert To Number    ${get_datrakhach}
    ${get_tongtien_hoadontra}    Get data from response json    ${get_resp}    ${jsonpath_tongtien_hoadontra}
    Return From Keyword    ${get_tongtienhangtra}    ${get_giamgiaphieutra}    ${get_phitrahang}    ${get_cantrakhach}    ${get_datrakhach}    ${get_tongtien_hoadontra}

Get status and payment to return
    [Arguments]    ${input_ma_th}
    [Timeout]    5 minute
    ${jsonpath_return_status}    Format String    $.Data[?(@.Code == '{0}')].Status    ${input_ma_th}
    ${jsonpath_return_payment}    Format String    $.Data[?(@.Code == '{0}')].ReturnTotal    ${input_ma_th}
    ${endpoint_trahang_by_branch}    Format String    ${endpoint_trahang}    ${BRANCH_ID}
    ${get_resp}    Get Request and return body    ${endpoint_trahang_by_branch}
    ${get_trangthai_th}    Get data from response json    ${get_resp}    ${jsonpath_return_status}
    ${get_can_tra_khach}    Get data from response json    ${get_resp}    ${jsonpath_return_payment}
    ${get_can_tra_khach}    Minus    0    ${get_can_tra_khach}
    Return From Keyword    ${get_trangthai_th}    ${get_can_tra_khach}

Get PTT info to return
    [Arguments]    ${input_ma_th}
    [Timeout]    5 minute
    ${jsonpath_ma_phieu_ttth}    Format String    $.Data[?(@.Code == '{0}')].PaymentCode    ${input_ma_th}
    ${endpoint_trahang_by_branch}    Format String    ${endpoint_trahang}    ${BRANCH_ID}
    ${get_ma_phieu_tt}    Get data from API    ${endpoint_trahang_by_branch}    ${jsonpath_ma_phieu_ttth}
    ${endpoint_phieu_ttdh}    Format String    ${endpoint_phieu_thanhtoan_th}    ${get_ma_phieu_tt}
    ${get_tienthu_tt}    Get data from API    ${endpoint_phieu_ttdh}    $.Data..Amount
    ${get_tienthu_tt}    Convert To String    ${get_tienthu_tt}
    ${get_tienthu_tt}    Replace String    ${get_tienthu_tt}    -    ${EMPTY}
    ${get_tienthu_tt}    Convert To Number    ${get_tienthu_tt}
    Return From Keyword    ${get_tienthu_tt}

Get return history by invoice code
    [Arguments]    ${input_ma_hd}
    [Timeout]    3 minute
    ${jsonpath_id_hd}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_hd}
    ${endpoint_hoadon}    Format String    ${endpoint_hoadon}    ${BRANCH_ID}
    ${get_id_hd}    Get data from API    ${endpoint_hoadon}    ${jsonpath_id_hd}
    ${endpoint_tab_lichsu_th}    Format String    ${endpoint_tab_lichsu_trahang_in_invoice}    ${get_id_hd}
    ${get_resp}    Get Request and return body    ${endpoint_tab_lichsu_th}
    ${get_ma_th}    Get data from response json    ${get_resp}    $.Data..Code
    ${get_giatri}    Get data from response json    ${get_resp}    $.Data..TotalReturn
    ${get_trangthai}    Get data from response json    ${get_resp}    $.Data..Status
    Return From Keyword    ${get_ma_th}    ${get_giatri}    ${get_trangthai}

Validate return history by invoice code
    [Arguments]    ${input_ma_hd}    ${input_ma_th}    ${get_tongcong}
    [Timeout]    3 minute
    ${get_ma_th}    ${get_giatri}    ${get_trangthai}    Get return history by invoice code    ${input_ma_hd}
    Should Be Equal As Strings    ${get_ma_th}    ${input_ma_th}
    Should Be Equal As Numbers    ${get_giatri}    ${get_tongcong}
    Should Be Equal As Numbers    ${get_trangthai}    1

Get additional invoice code by return code
    [Arguments]    ${input_ma_trahang}
    [Timeout]    3 minute
    ${endpoint_trahang}    Format String    ${endpoint_trahang}    ${BRANCH_ID}
    ${jsonpath_id_ma_dth}    Format String    $..Data[?(@.Code == '{0}')].NewInvoiceId    ${input_ma_trahang}
    ${get_id_ma_dth}    Get data from API    ${endpoint_trahang}    ${jsonpath_id_ma_dth}
    ${endpoint_hoadon_doihang}    Format String    ${endpoint_hoadon_doihang}    ${get_id_ma_dth}
    ${get_ma_hoadon_doihang}    Get data from API    ${endpoint_hoadon_doihang}    $.Code
    Return From Keyword    ${get_ma_hoadon_doihang}

Get list total sale - endingstock - cost incase newprice
    [Arguments]    ${list_product}    ${list_nums}    ${list_newprice}
    [Timeout]    5 minute
    ${list_result_thanhtien_newprice}    Create List
    ${list_result_toncuoi}    Create List
    ${get_list_giaban}    ${get_list_giavon}    ${get_list_ton}    ${list_giatri_quydoi}    Get list base price - cost - onhand - gia tri quy doi frm API    ${list_product}
    ${list_product_type}    ${list_tonkho_service}    Get list product type and ending stock of service frm API    ${list_product}
    : FOR    ${item_product}    ${item_nums}    ${item_newprice}    ${item_onhand}    ${get_giatri_quydoi}    ${get_product_type}
    ...    ${get_toncuoi_dv_execute}    IN ZIP    ${list_product}    ${list_nums}    ${list_newprice}    ${get_list_ton}
    ...    ${list_giatri_quydoi}    ${list_product_type}    ${list_tonkho_service}
    \    ${result_toncuoi}    Run Keyword If    '${get_giatri_quydoi}' == '1'    Computation endingstock frm API    ${item_nums}    ${item_onhand}
    \    ...    ${get_product_type}    ${get_toncuoi_dv_execute}
    \    ...    ELSE    Computation endingstock for unit product    ${item_product}    ${item_nums}    ${get_giatri_quydoi}
    \    ${result_thanhtien_newprice}    Multiplication and round    ${item_newprice}    ${item_nums}
    \    Append to list    ${list_result_thanhtien_newprice}    ${result_thanhtien_newprice}
    \    Append to list    ${list_result_toncuoi}    ${result_toncuoi}
    Return From Keyword    ${list_result_thanhtien_newprice}    ${get_list_giavon}    ${list_result_toncuoi}

Get list total sale - endingstock - cost incase discount
    [Arguments]    ${list_product}    ${list_nums}    ${list_ggsp}
    [Timeout]    5 minute
    ${list_result_thanhtien}    Create List
    ${list_result_toncuoi}    Create List
    ${get_list_giaban}    ${get_list_giavon}    ${get_list_ton}    ${list_giatri_quydoi}    Get list base price - cost - onhand - gia tri quy doi frm API    ${list_product}
    ${list_product_type}    ${list_tonkho_service}    Get list product type and ending stock of service frm API    ${list_product}
    : FOR    ${item_product}    ${item_nums}    ${item_onhand}    ${get_toncuoi_dv_execute}    ${get_giatri_quydoi}    ${get_product_type}
    ...    ${item_price}    ${input_ggsp}    IN ZIP    ${list_product}    ${list_nums}    ${get_list_ton}
    ...    ${list_tonkho_service}    ${list_giatri_quydoi}    ${list_product_type}    ${get_list_giaban}    ${list_ggsp}
    \    ${result_toncuoi}    Run Keyword If    '${get_giatri_quydoi}' == '1'    Computation endingstock frm API    ${item_nums}    ${item_onhand}
    \    ...    ${get_product_type}    ${get_toncuoi_dv_execute}
    \    ...    ELSE    Computation endingstock for unit product    ${item_product}    ${item_nums}    ${get_giatri_quydoi}
    \    ${result_new_price}    Run Keyword If    0 < ${input_ggsp} < 100    Price after % discount product    ${item_price}    ${input_ggsp}
    \    ...    ELSE    Minus    ${item_price}    ${input_ggsp}
    \    ${result_thanhtien}    Multiplication and round    ${result_new_price}    ${item_nums}
    \    Append to list    ${list_result_thanhtien}    ${result_thanhtien}
    \    Append to list    ${list_result_toncuoi}    ${result_toncuoi}
    Return From Keyword    ${list_result_thanhtien}    ${get_list_giavon}    ${list_result_toncuoi}

Get list total sale - endingstock - cost incase discount and return of invoice
    [Arguments]    ${list_product}    ${list_nums}    ${list_ggsp}
    [Timeout]    5 minute
    ${list_result_thanhtien}    Create List
    ${list_result_toncuoi}    Create List
    ${get_list_giaban}    ${get_list_giavon}    ${get_list_ton}    ${list_giatri_quydoi}    Get list base price - cost - onhand - gia tri quy doi frm API    ${list_product}
    ${list_product_type}    ${list_tonkho_service}    Get list product type and ending stock of service frm API    ${list_product}
    : FOR    ${item_product}    ${item_nums}    ${item_onhand}    ${get_toncuoi_dv_execute}    ${get_giatri_quydoi}    ${get_product_type}
    ...    ${item_price}    ${input_ggsp}    IN ZIP    ${list_product}    ${list_nums}    ${get_list_ton}
    ...    ${list_tonkho_service}    ${list_giatri_quydoi}    ${list_product_type}    ${get_list_giaban}    ${list_ggsp}
    \    ${result_toncuoi}    Run Keyword If    '${get_giatri_quydoi}' == '1'    Computation endingstock frm API    ${item_nums}    ${item_onhand}
    \    ...    ${get_product_type}    ${get_toncuoi_dv_execute}
    \    ...    ELSE    Computation endingstock for unit product    ${item_product}    ${item_nums}    ${get_giatri_quydoi}
    \    ${result_new_price}    Run Keyword If    0<${input_ggsp}<100    Price after % discount product    ${item_price}    ${input_ggsp}
    \    ...    ELSE    Minus    ${item_price}    ${input_ggsp}
    \    ${result_thanhtien}    Multiplication and round    ${result_new_price}    ${item_nums}
    \    Append to list    ${list_result_thanhtien}    ${result_thanhtien}
    \    Append to list    ${list_result_toncuoi}    ${result_toncuoi}
    Return From Keyword    ${list_result_thanhtien}    ${get_list_giavon}    ${list_result_toncuoi}

Get list endingstock - cost frm API
    [Arguments]    ${list_product}    ${list_nums}
    [Timeout]    5 minute
    ${list_result_toncuoi}    Create List
    ${get_list_giavon}    ${get_list_ton}    Get list cost - onhand - gia tri quy doi frm API    ${list_product}
    : FOR    ${item_product}    ${item_nums}    ${item_onhand}    IN ZIP    ${list_product}    ${list_nums}
    ...    ${get_list_ton}
    \    ${get_giatri_quydoi}    Get list gia tri quy doi frm product API    ${item_product}
    \    ${result_toncuoi}    Run Keyword If    '${get_giatri_quydoi}' == '1'    Computation and get endingstock frm API    ${item_product}    ${item_nums}
    \    ...    ${item_onhand}
    \    ...    ELSE    Computation and get endingstock for unit product    ${item_product}    ${item_nums}    ${get_giatri_quydoi}
    \    Append to list    ${list_result_toncuoi}    ${result_toncuoi}
    Return From Keyword    ${get_list_giavon}    ${list_result_toncuoi}

Post request to create return and get resp
    [Arguments]    ${request_payload}
    [Timeout]    3 minutes
    ${resp}    Post request thr API    /returns     ${request_payload}
    ${string}    Convert To String    ${resp}
    ${dict}    Set Variable    ${resp}
    ${return_code}    Get From Dictionary    ${dict}    Code
    Return From Keyword    ${return_code}

Get return id
    [Arguments]    ${input_ma_th}
    [Timeout]    3 minutes
    ${jsonpath_id_th}    Format String    $.Data[?(@.Code == '{0}')].Id    ${input_ma_th}
    ${endpoint_trahang_by_branch}    Format String    ${endpoint_trahang}    ${BRANCH_ID}
    ${get_id_th}    Get data from API    ${endpoint_trahang_by_branch}    ${jsonpath_id_th}
    Return From Keyword    ${get_id_th}

Delete return thr API
    [Arguments]    ${return_code}
    [Timeout]    3 minutes
    ${get_return_id}    Get return id    ${return_code}
    ${endpoint_delete_phieutra}    Format String    ${endpoint_delete_return}    ${get_return_id}    ${return_code}
    Delete request thr API    ${endpoint_delete_phieutra}

Add new return to invoice thr API
    [Arguments]    ${ma_hd}    ${input_ma_kh}    ${list_product}    ${list_num}    ${input_discount}    ${input_phi_trahang}
    ...    ${input_cantrakhach}
    [Timeout]    3 minutes
    ## Get info ton cuoi, cong no khach hang
    ${Uuid}      Generate Random String    4    [NUMBERS][NUMBERS]
    ${Uuid_code}      Catenate      SEPARATOR=      WA     ${Uuid}
    ${endpoint_danhmuc_hh_by_branch}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${resp_product_list}    Get Request and return body    ${endpoint_danhmuc_hh_by_branch}
    ${list_id_sp}    Get list product id thr API    ${list_product}
    ${list_baseprice}    Get list of Baseprice by Product Code    ${list_product}
    ${list_newprice}    Create List
    : FOR    ${item_pr}    IN ZIP    ${list_product}
    \    ${list_newprice}    Get list newprice by product code    ${ma_hd}    ${item_pr}    ${list_newprice}
    Log    ${list_newprice}
    ${list_result_thanhtien}    Get list of total sale in case of changing product price    ${list_product}    ${list_num}    ${list_newprice}
    ${result_tongtienhang}    Sum values in list    ${list_result_thanhtien}
    ${result_cantrakhach}    Run Keyword If    0 < ${input_discount} < 100    Price after % discount invoice    ${result_tongtienhang}    ${input_discount}
    ...    ELSE IF    ${input_discount} > 100    Minus    ${result_tongtienhang}    ${input_discount}
    ...    ELSE    Set Variable    ${result_tongtienhang}
    ${result_discount_invoice}    Run Keyword If    0 < ${input_discount} < 100    Convert % discount to VND and round    ${result_tongtienhang}    ${input_discount}
    ...    ELSE    Set Variable    ${input_discount}
    ${result_phitrahang}    Run Keyword If    0<${input_phi_trahang} <100    Convert % discount to VND and round    ${result_tongtienhang}    ${input_phi_trahang}
    ...    ELSE    Set Variable    ${input_phi_trahang}
    ${result_cantrakhach}    Minus    ${result_cantrakhach}    ${result_phitrahang}
    ${phitrahang_type}    Set Variable If    0<${input_phi_trahang} <100    ${input_phi_trahang}    null
    ${actual_cantrakhach}    Set Variable If    '${input_cantrakhach}' == 'all'    ${result_cantrakhach}    ${input_cantrakhach}
    ##
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${jsonpath_id_kh}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_kh}
    ${get_id_kh}    Get data from API    ${endpoint_khachhang}    ${jsonpath_id_kh}
    ${giamgia_hd}    Set Variable If    0 < ${input_discount} < 100    ${input_discount}    null
    ${result_gghd}    Run Keyword If    0 < ${input_discount} < 100    Convert % discount to VND    ${result_tongtienhang}    ${input_discount}
    ...    ELSE    Set Variable    ${input_discount}
    ${result_gghd}    Evaluate    round(${result_gghd},0)
    ${get_invoice_id}    Get invoice id    ${ma_hd}
    ${get_invoice_detail_id}    Get invoice detail id    ${ma_hd}
    # Post request BH
    ${liststring_prs_invoice_detail}    Set Variable    needdel
    Log    ${liststring_prs_invoice_detail}
    : FOR    ${item_product_id}    ${item_price}    ${item_num}    ${item_imei}    ${item_baseprice}    IN ZIP
    ...    ${list_id_sp}    ${list_newprice}    ${list_num}    ${imei_inlist}    ${list_baseprice}
    \    ${item_imei}    Convert list to string and return    ${item_imei}
    \    ${payload_each_product}    Format string    {{"BasePrice":{0},"IsLotSerialControl":true,"Note":"","Price":{1},"ProductId":{2},"Quantity":{3},"SerialNumbers":"{4}","SellPrice":{1},"ProductName":"Máy Xay Sinh Tố Philips HR2115 (600W)","CopiedPrice":{1},"InvoiceDetailId":{5},"IsMaster":true,"ProductBatchExpireId":null}}    ${item_baseprice}    ${item_price}    ${item_product_id}
    \    ...    ${item_num}    ${item_imei}    ${get_invoice_detail_id}
    \    ${liststring_prs_invoice_detail}    Catenate    SEPARATOR=,    ${liststring_prs_invoice_detail}    ${payload_each_product}
    Log    ${liststring_prs_invoice_detail}
    ${phi_trahang}    Set Variable If    0 < ${input_phi_trahang} < 100    ${input_phi_trahang}    null
    ${liststring_prs_invoice_detail}    Replace String    ${liststring_prs_invoice_detail}    needdel,    ${EMPTY}    count=1
    ${request_payload}    Format String    {{"Return":{{"BranchId":{0},"RetailerId":{1},"InvoiceId":{2},"CustomerId":{3},"ReceivedById":{4},"ReceivedBy":{{"CreatedBy":0,"CreatedDate":"2019-04-23T10:22:08.910Z","GivenName":"admin","Id":20447,"IsActive":true,"IsAdmin":true,"Type":0,"isDeleted":false,"Name":"admin"}},"SaleChannelId":0,"SaleChannel":null,"Code":"Trả hàng 1","ReturnDiscount":{5},"ReturnFee":{6},"ReturnFeeRatio":{7},"ReturnDetails":[{9}],"InvoiceDetails":[],"InvoiceOrderSurcharges":[],"Payments":[{{"Method":"Cash","MethodStr":"Tiền mặt","Amount":{8},"Id":-1}}],"Status":1,"Surcharge":0,"Type":3,"Uuid":"{10}","PayingAmount":{8},"TotalBeforeDiscount":0,"ProductDiscount":0,"TotalReturn":119990,"txtPay":"Tiền trả khách","addToAccount":"0","InvoiceComparePurchaseDate":"2019-08-10T16:18:47.1900000+07:00","ReturnSurcharges":[],"CreatedBy":20447}}}}    ${BRANCH_ID}    ${get_id_nguoitao}    ${get_invoice_id}    ${get_id_kh}
    ...    ${get_id_nguoiban}    ${result_gghd}    ${result_phitrahang}    ${phi_trahang}    ${actual_cantrakhach}    ${liststring_prs_invoice_detail}    ${Uuid_code}
    Log    ${request_payload}
    ${return_code}    Post request to create return and get resp    ${request_payload}
    Return From Keyword    ${return_code}

Add new return to invoice incase discount
    [Arguments]    ${ma_hd}    ${input_ma_kh}    ${list_product}    ${list_num}    ${list_ggsp}    ${list_discount_type}   ${input_discount}    ${input_phi_trahang}
    ...    ${input_cantrakhach}
    [Timeout]    3 minutes
    ## Get info ton cuoi, cong no khach hang
    ${Uuid}      Generate Random String    4    [NUMBERS][NUMBERS]
    ${Uuid_code}      Catenate      SEPARATOR=      WA     ${Uuid}
    ${endpoint_danhmuc_hh_by_branch}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${resp_product_list}    Get Request and return body    ${endpoint_danhmuc_hh_by_branch}
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${get_id_kh}    Get customer id thr API    ${input_ma_kh}
    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}    Get list jsonpath product frm list product    ${list_product}
    ${list_giaban}   ${list_result_ggsp}    ${list_id_sp}    ${list_thanhtien}    Get product info frm list jsonpath product incase discount product - return total sale    ${resp_product_list}
    ...    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}    ${list_ggsp}    ${list_discount_type}    ${list_num}
    ##compute
    ${result_tongtienhang}    Sum values in list    ${list_thanhtien}
    ${result_cantrakhach}    Run Keyword If    0 < ${input_discount} < 100    Price after % discount invoice    ${result_tongtienhang}    ${input_discount}
    ...    ELSE IF    ${input_discount} > 100    Minus    ${result_tongtienhang}    ${input_discount}
    ...    ELSE    Set Variable    ${result_tongtienhang}
    ${result_discount_invoice}    Run Keyword If    0 < ${input_discount} < 100    Convert % discount to VND and round    ${result_tongtienhang}    ${input_discount}
    ...    ELSE    Set Variable    ${input_discount}
    ${result_phitrahang}    Run Keyword If    0<${input_phi_trahang} <100    Convert % discount to VND and round    ${result_tongtienhang}    ${input_phi_trahang}
    ...    ELSE    Set Variable    ${input_phi_trahang}
    ${result_cantrakhach}    Minus    ${result_cantrakhach}    ${result_phitrahang}
    ${phitrahang_type}    Set Variable If    0<${input_phi_trahang} <100    ${input_phi_trahang}    null
    ${actual_cantrakhach}    Set Variable If    '${input_cantrakhach}' == 'all'    ${result_cantrakhach}    ${input_cantrakhach}
    ${giamgia_hd}    Set Variable If    0 < ${input_discount} < 100    ${input_discount}    null
    ${get_invoice_id}    Get invoice id    ${ma_hd}
    ${get_invoice_detail_id}    Get invoice detail id    ${ma_hd}
    # Post request BH
    ${liststring_prs_invoice_detail}    Set Variable    needdel
    Log    ${liststring_prs_invoice_detail}
    : FOR    ${item_product_id}   ${item_ggsp}   ${result_ggsp}    ${item_num}    ${item_imei}    ${item_baseprice}    ${discount_type}    IN ZIP    ${list_id_sp}
    ...    ${list_ggsp}   ${list_result_ggsp}    ${list_num}    ${imei_inlist}    ${list_giaban}    ${list_discount_type}
    \    ${result_new_price}    Run Keyword If    '${discount_type}' == 'dis'    Price after % discount product    ${item_baseprice}    ${item_ggsp}
    \    ...    ELSE IF    '${discount_type}' == 'disvnd'    Minus and round 2    ${item_baseprice}    ${item_ggsp}
    \    ...    ELSE IF    '${discount_type}' == 'changeup' or '${discount_type}' == 'changedown'   Set Variable      ${item_ggsp}     ELSE    Set Variable    ${item_baseprice}
    \    ${item_imei}    Convert list to string and return    ${item_imei}
    \    ${item_ggsp}   Set Variable If    0 < ${item_ggsp} < 100    ${item_ggsp}   0
    \    ${payload_each_product}    Format string    {{"BasePrice":{0},"IsLotSerialControl":true,"Note":"","Price":{1},"ProductId":{2},"Quantity":{3},"SerialNumbers":"{4}","SellPrice":{0},"ProductName":"Máy Xay Sinh Tố Philips HR2115 (600W)","Discount":{5},"DiscountRatio":{6},"CopiedPrice":{0},"InvoiceDetailId":{7},"IsMaster":true,"ProductBatchExpireId":null}}    ${item_baseprice}    ${result_new_price}    ${item_product_id}
    \    ...    ${item_num}   ${item_imei}   ${result_ggsp}    ${item_ggsp}    ${get_invoice_detail_id}
    \    ${liststring_prs_invoice_detail}    Catenate    SEPARATOR=,    ${liststring_prs_invoice_detail}    ${payload_each_product}
    Log    ${liststring_prs_invoice_detail}
    ${phi_trahang}    Set Variable If    0 < ${input_phi_trahang} < 100    ${input_phi_trahang}    null
    ${liststring_prs_invoice_detail}    Replace String    ${liststring_prs_invoice_detail}    needdel,    ${EMPTY}    count=1
    ${request_payload}    Format String    {{"Return":{{"BranchId":{0},"RetailerId":{1},"InvoiceId":{2},"CustomerId":{3},"ReceivedById":{4},"ReceivedBy":{{"CreatedBy":0,"CreatedDate":"2019-04-23T10:22:08.910Z","GivenName":"admin","Id":20447,"IsActive":true,"IsAdmin":true,"Type":0,"isDeleted":false,"Name":"admin"}},"SaleChannelId":0,"SaleChannel":null,"Code":"Trả hàng 1","ReturnDiscount":{5},"ReturnFee":{6},"ReturnFeeRatio":{7},"ReturnDetails":[{9}],"InvoiceDetails":[],"InvoiceOrderSurcharges":[],"Payments":[{{"Method":"Cash","MethodStr":"Tiền mặt","Amount":{8},"Id":-1}}],"Status":1,"Surcharge":0,"Type":3,"Uuid":"{10}","PayingAmount":{8},"TotalBeforeDiscount":0,"ProductDiscount":0,"TotalReturn":119990,"txtPay":"Tiền trả khách","addToAccount":"0","InvoiceComparePurchaseDate":"2019-08-10T16:18:47.1900000+07:00","ReturnSurcharges":[],"CreatedBy":20447}}}}    ${BRANCH_ID}    ${get_id_nguoitao}    ${get_invoice_id}    ${get_id_kh}
    ...    ${get_id_nguoiban}    ${result_discount_invoice}    ${result_phitrahang}    ${phi_trahang}    ${actual_cantrakhach}    ${liststring_prs_invoice_detail}    ${Uuid_code}
    Log    ${request_payload}
    ${return_code}    Post request to create return and get resp    ${request_payload}
    Return From Keyword    ${return_code}

Post request to create exchange and get return code
    [Arguments]    ${request_payload}
    [Timeout]    3 minutes
    ${resp}    Post request thr API    /returns/saveExchange    ${request_payload}
    ${dict}    Set Variable    ${resp}
    ${return_code}    Get data from response json    ${dict}    $.Refund.Code
    Return From Keyword     ${return_code}

Add new return thr API
    [Arguments]    ${input_ma_kh}    ${dict_product_nums}    ${list_imei}    ${list_newprice}    ${newprice_imei}    ${input_ggth}
    ...    ${input_phi_th}    ${input_khtt}
    [Timeout]    5 minutes
    ${Uuid}      Generate Random String    4    [NUMBERS][NUMBERS]
    ${Uuid_code}      Catenate      SEPARATOR=      WA     ${Uuid}
    ${get_list_status}    Get list imei status thr API    ${list_imei}
    Create invoice with imei product    ${input_ma_kh}    ${list_imei}    ${get_list_status}
    #get info tra hang
    ${input_imei_product}    Get Dictionary Keys    ${list_imei}
    ${input_imei_nums}    Get Dictionary Values    ${list_imei}
    ${input_product}    ${input_imei_nums}    Convert two list to string and return    ${input_imei_product}    ${input_imei_nums}
    ${list_products}    Get Dictionary Keys    ${dict_product_nums}
    ${list_nums}    Get Dictionary Values    ${dict_product_nums}
    #get data to validate
    Append To List    ${list_products}    ${input_product}
    Append to List    ${list_nums}    ${input_imei_nums}
    Append To List    ${list_newprice}    ${newprice_imei}
    #
    ${imei}    Convert list to string and return    ${imei_inlist}
    ${list_status}    Get list imei status thr API    ${list_products}
    ${imei_by_product_inlist}    Create List
    : FOR    ${item_product}    ${item_status}    IN ZIP    ${list_products}    ${list_status}
    \    ${imei_by_product}    Run Keyword If    ${item_status}==0    Set Variable    ${EMPTY}
    \    ...    ELSE    Set Variable    ${imei}
    \    Append To List    ${imei_by_product_inlist}    ${imei_by_product}
    Log many    ${imei_by_product_inlist}
    ${list_result_thanhtien_newprice}    ${list_giavon}    ${list_result_toncuoi}    Get list total sale - endingstock - cost incase newprice    ${list_products}    ${list_nums}    ${list_newprice}
    #
    ${endpoint_danhmuc_hh_by_branch}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${resp_product_list}    Get Request and return body    ${endpoint_danhmuc_hh_by_branch}
    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}    Get List Jsonpath Product Frm List Product    ${list_products}
    ${list_giaban}    ${list_result_ggsp}    ${list_id_sp}    Get product info and new price frm list product    ${resp_product_list}    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}
    ...    ${list_newprice}
    ${list_result_thanhtien}    Get list of total sale in case of changing product price    ${list_products}    ${list_nums}    ${list_newprice}
    #compute
    ${result_tongtienhangtra}    Sum values in list and round    ${list_result_thanhtien_newprice}
    ${result_ggth}    Run Keyword If    0 < ${input_ggth} < 100    Convert % discount to VND and round    ${result_tongtienhangtra}    ${input_ggth}
    ...    ELSE    Set Variable    ${input_ggth}
    ${result_phi_th}    Run Keyword If    0 < ${input_phi_th} < 100    Convert % discount to VND and round    ${result_tongtienhangtra}    ${input_phi_th}
    ...    ELSE    Set Variable    ${input_phi_th}
    ${result_cantrakhach}    Minusx3 and replace foating point    ${result_tongtienhangtra}    ${result_ggth}    ${result_phi_th}
    ${result_khtt}    Set Variable If    "${input_khtt}" == "all"    ${result_cantrakhach}    ${input_khtt}
    ${actual_khtt}    Set Variable If    "${input_khtt}" == "0"    0    ${result_khtt}
    ##
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${jsonpath_id_kh}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_kh}
    ${get_id_kh}    Get data from API    ${endpoint_khachhang}    ${jsonpath_id_kh}
    ${giamgia_th}    Set Variable If    0 < ${input_ggth} < 100    ${input_ggth}    null
    ${result_ggth}    Run Keyword If    0 < ${input_ggth} < 100    Convert % discount to VND    ${result_tongtienhangtra}    ${input_ggth}
    ...    ELSE    Set Variable    ${input_ggth}
    ${result_ggth}    Evaluate    round(${result_ggth},0)
    # Post request BH
    ${liststring_prs_invoice_detail}    Set Variable    needdel
    Log    ${liststring_prs_invoice_detail}
    : FOR    ${item_product_id}    ${item_price}    ${item_num}    ${item_result_discountproduct}    ${item_newprice}    ${item_imei}
    ...    IN ZIP    ${list_id_sp}    ${list_giaban}    ${list_nums}    ${list_result_ggsp}    ${list_newprice}
    ...    ${imei_by_product_inlist}
    \    ${imei}    Convert list to string and return    ${item_imei}
    \    ${payload_each_product}    Format string    {{"BasePrice":{0},"IsLotSerialControl":true,"Note":"","Price":{1},"ProductId":{2},"Quantity":{3},"SerialNumbers":"{4}","SellPrice":{0},"ProductName":"chuột quang hồng","Discount":{5},"DiscountRatio":null,"CopiedPrice":134216.23,"ProductBatchExpireId":null}}    ${item_price}    ${item_newprice}    ${item_product_id}
    \    ...    ${item_num}    ${imei}    ${item_result_discountproduct}
    \    ${liststring_prs_invoice_detail}    Catenate    SEPARATOR=,    ${liststring_prs_invoice_detail}    ${payload_each_product}
    Log    ${liststring_prs_invoice_detail}
    ${liststring_prs_invoice_detail}    Replace String    ${liststring_prs_invoice_detail}    needdel,    ${EMPTY}    count=1
    ${request_payload}    Format String    {{"Return":{{"BranchId":{0},"RetailerId":{1},"CustomerId":{2},"ReceivedById":{3},"ReceivedBy":{{"CreatedBy":0,"CreatedDate":"2019-04-23T10:22:08.910Z","Email":"","GivenName":"admin","Id":20447,"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false}},"SaleChannelId":0,"SaleChannel":null,"Code":"Trả hàng 1","ReturnDiscount":{4},"ReturnFee":{5},"ReturnFeeRatio":{6},"ReturnDetails":[{8}],"InvoiceDetails":[],"InvoiceOrderSurcharges":[],"Payments":[{{"Method":"Cash","MethodStr":"Tiền mặt","Amount":{7},"Id":-1}}],"Status":1,"Surcharge":0,"Type":3,"Uuid":"{9}","PayingAmount":{7},"TotalBeforeDiscount":0,"ProductDiscount":0,"TotalReturn":576000,"txtPay":"Tiền trả khách","addToAccount":"0","addToAccountSurplus":"0","addToAccountAllocation":"0","addToAccountPaymentAllocation":"0","ReturnSurcharges":[],"CreatedBy":20447}}}}    ${BRANCH_ID}    ${get_id_nguoitao}    ${get_id_kh}    ${get_id_nguoiban}
    ...    ${result_ggth}    ${result_phi_th}    ${input_phi_th}    ${actual_khtt}    ${liststring_prs_invoice_detail}    ${Uuid_code}
    Log    ${request_payload}
    ${return_code}    Post request to create return and get resp    ${request_payload}
    Return From Keyword    ${return_code}

Infuse value into multi row product
    [Arguments]    ${item_pr_id}    ${list_num}    ${item_giaban}    ${list_change}    ${list_change_type}    ${list_disvnd}
    [Timeout]    3 minutes
    ${liststring_prs}    Set Variable    needdel
    ${liststring_prs1}    Set Variable    needdel
    : FOR    ${item_num}    ${item_change}    ${item_change_type}    ${item_disvnd}    IN ZIP    ${list_num}
    ...    ${list_change}    ${list_change_type}    ${list_disvnd}
    \    ${item_dis%}    Set Variable If    0<${item_change}<100 and '${item_change_type}'=='dis'    ${item_change}    null
    \    ${payload_each_product}    Format String    {{"ProductId":{0},"ProductName":"Sản phẩm IMEI 9","ProductFullName":"Sản phẩm IMEI 9","ProductNameNoUnit":"Sản phẩm IMEI 9","ProductAttributeLabel":"","ProductSName":"Sản phẩm IMEI 9","ProductCode":"RPSI0009","ProductType":2,"ProductCategoryId":173814,"MasterProductId":{0},"OnHand":7,"OnOrder":0,"Reserved":0,"Price":{1},"OriginSalePrice":{1},"Unit":"","Note":"","PromotionReceiverQty":1,"Quantity":{2},"ProductSerials":[],"Serials":[],"IsLotSerialControl":true,"IsRewardPoint":false,"CurrentQuery":"RPSI0009","CategoryId":173814,"Promotions":[],"Discount":{3},"DiscountRatio":{4},"BasePrice":{1},"isDeleted":false,"ProductShelves":[],"AllowSale":true,"ProductWarranty":[],"Formulas":null,"CartType":3,"Units":[],"MaxQuantity":null,"IsMaster":false,"ChildNumber":1,"SerialNumbers":"","subBatchProducts":null,"BatchExpire":null,"Uuid":"","discountRatioPriceWoRound":{4},"discountPriceWoRound":{3}}}    ${item_pr_id}    ${item_giaban}    ${item_num}
    \    ...    ${item_disvnd}    ${item_dis%}
    \    ${payload_each_product1}    Format String    {{"BasePrice":{0},"IsLotSerialControl":true,"IsRewardPoint":false,"Note":"","Price":{0},"OriginPrice":{0},"ProductId":{1},"Quantity":{2},"SerialNumbers":"","Discount":{3},"DiscountRatio":{4},"ProductName":"Sản phẩm IMEI 9","ProductCode":"RPSI0009","ProductBatchExpireId":null,"Uuid":""}}    ${item_giaban}    ${item_pr_id}    ${item_num}
    \    ...    ${item_disvnd}    ${item_dis%}
    \    ${liststring_prs}    Catenate    SEPARATOR=,    ${liststring_prs}    ${payload_each_product}
    \    ${liststring_prs1}    Catenate    SEPARATOR=,    ${liststring_prs1}    ${payload_each_product1}
    ${liststring_prs}    Replace String    ${liststring_prs}    needdel,    ${EMPTY}    count=1
    ${liststring_prs1}    Replace String    ${liststring_prs1}    needdel,    ${EMPTY}    count=1
    Return From Keyword    ${liststring_prs}    ${liststring_prs1}

Infuse value into multi row product imei
    [Arguments]    ${item_pr_id}    ${list_num}    ${item_giaban}    ${list_change}    ${list_change_type}    ${list_disvnd}
    ...    ${list_imei}
    [Timeout]    3 minutes
    ${liststring_prs}    Set Variable    needdel
    ${liststring_prs1}    Set Variable    needdel
    : FOR    ${item_num}    ${item_change}    ${item_change_type}    ${item_disvnd}    ${item_imei}    IN ZIP
    ...    ${list_num}    ${list_change}    ${list_change_type}    ${list_disvnd}    ${list_imei}
    \    ${item_imei}    Replace sq blackets    ${item_imei}
    \    ${item_dis%}    Set Variable If    0<${item_change}<100 and '${item_change_type}'=='dis'    ${item_change}    null
    \    ${payload_each_product}    Format String    {{"ProductId":{0},"ProductName":"Sản phẩm IMEI 9","ProductFullName":"Sản phẩm IMEI 9","ProductNameNoUnit":"Sản phẩm IMEI 9","ProductAttributeLabel":"","ProductSName":"Sản phẩm IMEI 9","ProductCode":"RPSI0009","ProductType":2,"ProductCategoryId":173814,"MasterProductId":{0},"OnHand":7,"OnOrder":0,"Reserved":0,"Price":{1},"OriginSalePrice":{1},"Unit":"","Note":"","PromotionReceiverQty":1,"Quantity":{2},"ProductSerials":[],"Serials":[],"IsLotSerialControl":true,"IsRewardPoint":false,"CurrentQuery":"RPSI0009","CategoryId":173814,"Promotions":[],"Discount":{3},"DiscountRatio":{4},"BasePrice":{1},"isDeleted":false,"ProductShelves":[],"AllowSale":true,"ProductWarranty":[],"Formulas":null,"CartType":3,"Units":[],"MaxQuantity":null,"IsMaster":false,"ChildNumber":1,"SerialNumbers":"{5}","subBatchProducts":null,"BatchExpire":null,"Uuid":"","discountRatioPriceWoRound":{4},"discountPriceWoRound":{3}}}    ${item_pr_id}    ${item_giaban}    ${item_num}
    \    ...    ${item_disvnd}    ${item_dis%}    ${item_imei}
    \    ${payload_each_product1}    Format String    {{"BasePrice":{0},"IsLotSerialControl":true,"IsRewardPoint":false,"Note":"","Price":{0},"OriginPrice":{0},"ProductId":{1},"Quantity":{2},"SerialNumbers":"{3}","Discount":{4},"DiscountRatio":{5},"ProductName":"Sản phẩm IMEI 9","ProductCode":"RPSI0009","ProductBatchExpireId":null,"Uuid":""}}    ${item_giaban}    ${item_pr_id}    ${item_num}
    \    ...    ${item_imei}    ${item_disvnd}    ${item_dis%}
    \    ${liststring_prs}    Catenate    SEPARATOR=,    ${liststring_prs}    ${payload_each_product}
    \    ${liststring_prs1}    Catenate    SEPARATOR=,    ${liststring_prs1}    ${payload_each_product1}
    ${liststring_prs}    Replace String    ${liststring_prs}    needdel,    ${EMPTY}    count=1
    ${liststring_prs1}    Replace String    ${liststring_prs1}    needdel,    ${EMPTY}    count=1
    Return From Keyword    ${liststring_prs}    ${liststring_prs1}

Get payload product incase multi row product and additional invoice
    [Arguments]    ${item_pr_id}    ${item_nums}    ${item_giaban}    ${item_ggsp}    ${item_result_ggsp}   ${list_num_addrow}    ${list_ggsp_addrow}
    ...    ${list_result_ggsp_addrow}
    [Timeout]    3 minutes
    ${liststring_prs_addrow}    Set Variable    needdel
    : FOR    ${item_num_addrow}    ${item_ggsp_addrow}    ${result_ggsp_addrow}    IN ZIP    ${list_num_addrow}    ${list_ggsp_addrow}    ${list_result_ggsp_addrow}
    \     ${item_ggsp_addrow}    Set Variable If    0 < ${item_ggsp_addrow} < 100    ${item_ggsp_addrow}    0
    \    ${payload_duplicate_product}    Format String    {{"ProductId":{0},"ProductName":"chuột quang hồng","ProductFullName":"chuột quang hồng","ProductNameNoUnit":"chuột quang hồng","ProductAttributeLabel":"","ProductSName":"chuột quang hồng","ProductCode":"SI001","ProductType":2,"ProductCategoryId":794174,"MasterProductId":{0},"OnHand":20,"OnOrder":0,"Reserved":64,"Price":{1},"OriginSalePrice":{1},"Unit":"","Note":"","PromotionReceiverQty":1,"Quantity":{2},"ProductSerials":[],"IsLotSerialControl":true,"IsRewardPoint":false,"CurrentQuery":"SI001","CategoryId":794174,"Discount":{3},"DiscountRatio":{4},"BasePrice":{1},"isDeleted":false,"ProductShelves":[],"AllowSale":true,"ProductWarranty":[],"Formulas":null,"CartType":{2},"Units":[],"MaxQuantity":null,"SerialNumbers":"","IsMaster":false,"ChildNumber":0,"subBatchProducts":null,"BatchExpire":null,"Uuid":""}}
    \    ...    ${item_pr_id}    ${item_giaban}    ${item_num_addrow}    ${result_ggsp_addrow}    ${item_ggsp_addrow}
    \    ${liststring_prs_addrow}    Catenate    SEPARATOR=,    ${liststring_prs_addrow}    ${payload_duplicate_product}
    ${liststring_prs_addrow}    Replace String    ${liststring_prs_addrow}    needdel,    ${EMPTY}    count=1
    Log    ${liststring_prs_addrow}
    ${item_ggsp}    Set Variable If    0 < ${item_ggsp} < 100    ${item_ggsp}    0
    ${payload_product}    Format String    {{"ProductId":{0},"ProductName":"chuột quang hồng","ProductFullName":"chuột quang hồng","ProductNameNoUnit":"chuột quang hồng","ProductAttributeLabel":"","ProductSName":"chuột quang hồng","ProductCode":"SI001","ProductType":2,"ProductCategoryId":794174,"MasterProductId":{0},"OnHand":20,"OnOrder":0,"Reserved":64,"Price":{1},"OriginSalePrice":{1},"Unit":"","Note":"","PromotionReceiverQty":1,"Quantity":{2},"ProductSerials":[],"Serials":[],"IsLotSerialControl":true,"IsRewardPoint":false,"CurrentQuery":"SI001","CategoryId":794174,"Promotions":[],"BasePrice":{1},"DuplicationCartItems":[{3}],"isDeleted":false,"ProductShelves":[],"AllowSale":true,"ProductWarranty":[],"Formulas":null,"Uuid":"","CartType":3,"Units":[],"MaxQuantity":null,"SerialNumbers":"","discountPriceWoRound":{4},"discountRatioPriceWoRound":{5},"IsMaster":true}}
    ...    ${item_pr_id}    ${item_giaban}    ${item_nums}    ${liststring_prs_addrow}   ${item_result_ggsp}    ${item_ggsp}
    Return From Keyword    ${payload_product}

Get payload imei product incase multi row product and additional invoice
    [Arguments]    ${item_pr_id}    ${item_nums}    ${item_giaban}    ${item_ggsp}    ${item_result_ggsp}    ${list_imei}   ${list_num_addrow}    ${list_ggsp_addrow}
    ...    ${list_result_ggsp_addrow}     ${list_imei_addrow}
    [Timeout]    3 minutes
    ${liststring_prs_addrow}    Set Variable    needdel
    :FOR    ${item_num_addrow}    ${item_ggsp_addrow}    ${result_ggsp_addrow}   ${item_imei_addrow}    IN ZIP    ${list_num_addrow}    ${list_ggsp_addrow}    ${list_result_ggsp_addrow}    ${list_imei_addrow}
    \    ${item_imei_addrow}    Convert list to string and return    ${item_imei_addrow}
    \     ${item_ggsp_addrow}    Set Variable If    0 < ${item_ggsp_addrow} < 100    ${item_ggsp_addrow}    0
    \    ${payload_duplicate_product}    Format String    {{"ProductId":{0},"ProductName":"chuột quang hồng","ProductFullName":"chuột quang hồng","ProductNameNoUnit":"chuột quang hồng","ProductAttributeLabel":"","ProductSName":"chuột quang hồng","ProductCode":"SI001","ProductType":2,"ProductCategoryId":794174,"MasterProductId":{0},"OnHand":20,"OnOrder":0,"Reserved":64,"Price":{1},"OriginSalePrice":{1},"Unit":"","Note":"","PromotionReceiverQty":1,"Quantity":{2},"ProductSerials":[],"IsLotSerialControl":true,"IsRewardPoint":false,"CurrentQuery":"SI001","CategoryId":794174,"Discount":{3},"DiscountRatio":{4},"BasePrice":{1},"isDeleted":false,"ProductShelves":[],"AllowSale":true,"ProductWarranty":[],"Formulas":null,"CartType":{2},"Units":[],"MaxQuantity":null,"SerialNumbers":"{5}","IsMaster":false,"ChildNumber":0,"subBatchProducts":null,"BatchExpire":null,"Uuid":""}}
    \    ...    ${item_pr_id}    ${item_giaban}    ${item_num_addrow}    ${result_ggsp_addrow}    ${item_ggsp_addrow}    ${item_imei_addrow}
    \    ${liststring_prs_addrow}    Catenate    SEPARATOR=,    ${liststring_prs_addrow}    ${payload_duplicate_product}
    ${liststring_prs_addrow}    Replace String    ${liststring_prs_addrow}    needdel,    ${EMPTY}    count=1
    Log    ${liststring_prs_addrow}
    ${item_ggsp}    Set Variable If    0 < ${item_ggsp} < 100    ${item_ggsp}    0
    ${item_imei}    Convert list to string and return    ${list_imei}
    ${payload_product}    Format String    {{"ProductId":{0},"ProductName":"chuột quang hồng","ProductFullName":"chuột quang hồng","ProductNameNoUnit":"chuột quang hồng","ProductAttributeLabel":"","ProductSName":"chuột quang hồng","ProductCode":"SI001","ProductType":2,"ProductCategoryId":794174,"MasterProductId":{0},"OnHand":20,"OnOrder":0,"Reserved":64,"Price":{1},"OriginSalePrice":{1},"Unit":"","Note":"","PromotionReceiverQty":1,"Quantity":{2},"ProductSerials":[],"Serials":[],"IsLotSerialControl":true,"IsRewardPoint":false,"CurrentQuery":"SI001","CategoryId":794174,"Promotions":[],"BasePrice":{1},"DuplicationCartItems":[{3}],"isDeleted":false,"ProductShelves":[],"AllowSale":true,"ProductWarranty":[],"Formulas":null,"Uuid":"","CartType":3,"Units":[],"MaxQuantity":null,"SerialNumbers":"{4}","discountPriceWoRound":{5},"discountRatioPriceWoRound":{6},"IsMaster":true}}
    ...    ${item_pr_id}    ${item_giaban}    ${item_nums}    ${liststring_prs_addrow}   ${item_imei}    ${item_result_ggsp}    ${item_ggsp}
    Return From Keyword    ${payload_product}

Get payload product incase create additional invoice
    [Arguments]    ${item_pr_id}    ${list_num_addrow}    ${item_giaban}    ${list_ggsp_addrow}    ${list_discount_type_addrow}    ${list_result_ggsp_addrow}    ${liststring_prs_invoice_detail}
    [Timeout]    3 minutes
    : FOR    ${result_ggsp}    ${item_ggsp}    ${item_num}    ${item_discount_type}    IN ZIP    ${list_result_ggsp_addrow}    ${list_ggsp_addrow}    ${list_num_addrow}    ${list_discount_type_addrow}
    \     ${item_ggsp}    Set Variable If    0 < ${item_ggsp} < 100    ${item_ggsp}    0
    \    ${payload_each_product}    Format String    {{"BasePrice":{0},"IsLotSerialControl":true,"IsRewardPoint":false,"Note":"","Price":{0},"OriginPrice":{0},"ProductId":{1},"Quantity":{2},"SerialNumbers":"","Discount":{3},"DiscountRatio":{4},"ProductName":"Máy Làm Tỏi Đen Tiross TS906 - Màu Bạc","ProductCode":"DTS05","ProductBatchExpireId":null,"Uuid":""}}
    \    ...    ${item_giaban}    ${item_pr_id}    ${item_num}    ${result_ggsp}    ${item_ggsp}
    \    Append To List      ${liststring_prs_invoice_detail}    ${payload_each_product}
    Return From Keyword    ${liststring_prs_invoice_detail}

Get payload imei product incase create additional invoice
    [Arguments]    ${item_pr_id}    ${list_num_addrow}    ${item_giaban}    ${list_ggsp_addrow}    ${list_discount_type_addrow}    ${list_imei_inlist}    ${list_result_ggsp_addrow}    ${liststring_prs_invoice_detail}
    [Timeout]    3 minutes
    : FOR    ${result_ggsp}    ${item_ggsp}    ${item_num}    ${item_discount_type}   ${item_imei}    IN ZIP    ${list_result_ggsp_addrow}    ${list_ggsp_addrow}    ${list_num_addrow}
    ...    ${list_discount_type_addrow}    ${list_imei_inlist}
    \    ${item_imei}    Convert list to string and return    ${item_imei}
    \     ${item_ggsp}    Set Variable If    0 < ${item_ggsp} < 100    ${item_ggsp}    0
    \    ${payload_each_product}    Format String    {{"BasePrice":{0},"IsLotSerialControl":true,"IsRewardPoint":false,"Note":"","Price":{0},"OriginPrice":{0},"ProductId":{1},"Quantity":{2},"SerialNumbers":"{3}","Discount":{4},"DiscountRatio":{5},"ProductName":"Máy Làm Tỏi Đen Tiross TS906 - Màu Bạc","ProductCode":"DTS05","ProductBatchExpireId":null,"Uuid":""}}
    \    ...    ${item_giaban}    ${item_pr_id}    ${item_num}    ${item_imei}    ${result_ggsp}    ${item_ggsp}
    \    Append To List      ${liststring_prs_invoice_detail}    ${payload_each_product}
    Return From Keyword    ${liststring_prs_invoice_detail}

Get list total sale - endingstock - cost incase changing product price
    [Arguments]    ${list_product}    ${list_nums}    ${list_change}    ${list_change_type}
    [Timeout]    3 minutes
    ${list_result_thanhtien}    Create List
    ${list_result_toncuoi}    Create List
    ${get_list_giaban}    ${get_list_giavon}    ${get_list_ton}    ${list_giatri_quydoi}    Get list base price - cost - onhand - gia tri quy doi frm API    ${list_product}
    ${list_product_type}    ${list_tonkho_service}    Get list product type and ending stock of service frm API    ${list_product}
    : FOR    ${item_product}    ${item_nums}    ${item_onhand}    ${get_toncuoi_dv_execute}    ${get_giatri_quydoi}    ${get_product_type}
    ...    ${item_price}    ${item_change}    ${item_change_type}    IN ZIP    ${list_product}    ${list_nums}
    ...    ${get_list_ton}    ${list_tonkho_service}    ${list_giatri_quydoi}    ${list_product_type}    ${get_list_giaban}    ${list_change}
    ...    ${list_change_type}
    \    ${result_toncuoi}    Run Keyword If    '${get_giatri_quydoi}' == '1'    Computation endingstock frm API    ${item_nums}    ${item_onhand}
    \    ...    ${get_product_type}    ${get_toncuoi_dv_execute}
    \    ...    ELSE    Computation endingstock for unit product    ${item_product}    ${item_nums}    ${get_giatri_quydoi}
    \    ${result_new_price}    Run Keyword If    0 < ${item_change} < 100 and '${item_change_type}'=='dis'    Price after % discount product    ${item_price}    ${item_change}
    \    ...    ELSE IF    ${item_change} > 100 and '${item_change_type}'=='dis'    Minus    ${item_price}    ${item_change}
    \    ...    ELSE    Set Variable    ${item_change}
    \    ${result_thanhtien}    Multiplication and round    ${result_new_price}    ${item_nums}
    \    Append to list    ${list_result_thanhtien}    ${result_thanhtien}
    \    Append to list    ${list_result_toncuoi}    ${result_toncuoi}
    Return From Keyword    ${list_result_thanhtien}    ${get_list_giavon}    ${list_result_toncuoi}

Add new return without customer to invoice thr API
    [Arguments]    ${ma_hd}    ${list_product}    ${list_num}    ${input_discount}    ${input_phi_trahang}    ${input_cantrakhach}
    [Timeout]    3 minutes
    ## Get info ton cuoi, cong no khach hang
    ${Uuid}      Generate Random String    4    [NUMBERS][NUMBERS]
    ${Uuid_code}      Catenate      SEPARATOR=      WA     ${Uuid}
    ${endpoint_danhmuc_hh_by_branch}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${resp_product_list}    Get Request and return body    ${endpoint_danhmuc_hh_by_branch}
    ${list_id_sp}    Get list product id thr API    ${list_product}
    ${list_baseprice}    Get list of Baseprice by Product Code    ${list_product}
    ${list_newprice}    Create List
    : FOR    ${item_pr}    IN ZIP    ${list_product}
    \    ${list_newprice}    Get list newprice by product code    ${ma_hd}    ${item_pr}    ${list_newprice}
    Log    ${list_newprice}
    ${list_result_thanhtien}    Get list of total sale in case of changing product price    ${list_product}    ${list_num}    ${list_newprice}
    ${result_tongtienhang}    Sum values in list    ${list_result_thanhtien}
    ${result_cantrakhach}    Run Keyword If    0 < ${input_discount} < 100    Price after % discount invoice    ${result_tongtienhang}    ${input_discount}
    ...    ELSE IF    ${input_discount} > 100    Minus    ${result_tongtienhang}    ${input_discount}
    ...    ELSE    Set Variable    ${result_tongtienhang}
    ${result_discount_invoice}    Run Keyword If    0 < ${input_discount} < 100    Convert % discount to VND and round    ${result_tongtienhang}    ${input_discount}
    ...    ELSE    Set Variable    ${input_discount}
    ${result_phitrahang}    Run Keyword If    0<${input_phi_trahang} <100    Convert % discount to VND and round    ${result_tongtienhang}    ${input_phi_trahang}
    ...    ELSE    Set Variable    ${input_phi_trahang}
    ${result_cantrakhach}    Minus    ${result_cantrakhach}    ${result_phitrahang}
    ${phitrahang_type}    Set Variable If    0<${input_phi_trahang} <100    ${input_phi_trahang}    null
    ${actual_cantrakhach}    Set Variable If    '${input_cantrakhach}' == 'all'    ${result_cantrakhach}    ${input_cantrakhach}
    ##
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${giamgia_hd}    Set Variable If    0 < ${input_discount} < 100    ${input_discount}    null
    ${result_gghd}    Run Keyword If    0 < ${input_discount} < 100    Convert % discount to VND    ${result_tongtienhang}    ${input_discount}
    ...    ELSE    Set Variable    ${input_discount}
    ${result_gghd}    Evaluate    round(${result_gghd},0)
    ${get_invoice_id}    Get invoice id    ${ma_hd}
    ${get_invoice_detail_id}    Get invoice detail id    ${ma_hd}
    # Post request BH
    ${liststring_prs_invoice_detail}    Set Variable    needdel
    Log    ${liststring_prs_invoice_detail}
    : FOR    ${item_product_id}    ${item_price}    ${item_num}    ${item_imei}    ${item_baseprice}    IN ZIP
    ...    ${list_id_sp}    ${list_newprice}    ${list_num}    ${imei_inlist}    ${list_baseprice}
    \    ${item_imei}    Convert list to string and return    ${item_imei}
    \    ${payload_each_product}    Format string    {{"BasePrice":{0},"IsLotSerialControl":true,"Note":"","Price":{1},"ProductId":{2},"Quantity":{3},"SerialNumbers":"{4}","SellPrice":{1},"ProductName":"Máy Xay Sinh Tố Philips HR2115 (600W)","CopiedPrice":{1},"InvoiceDetailId":{5},"IsMaster":true,"ProductBatchExpireId":null}}    ${item_baseprice}    ${item_price}    ${item_product_id}
    \    ...    ${item_num}    ${item_imei}    ${get_invoice_detail_id}
    \    ${liststring_prs_invoice_detail}    Catenate    SEPARATOR=,    ${liststring_prs_invoice_detail}    ${payload_each_product}
    Log    ${liststring_prs_invoice_detail}
    ${phi_trahang}    Set Variable If    0 < ${input_phi_trahang} < 100    ${input_phi_trahang}    null
    ${liststring_prs_invoice_detail}    Replace String    ${liststring_prs_invoice_detail}    needdel,    ${EMPTY}    count=1
    ${request_payload}    Format String    {{"Return":{{"BranchId":{0},"RetailerId":{1},"InvoiceId":{2},"ReceivedById":{3},"ReceivedBy":{{"CreatedBy":0,"CreatedDate":"2019-04-23T10:22:08.910Z","GivenName":"admin","Id":20447,"IsActive":true,"IsAdmin":true,"Type":0,"isDeleted":false,"Name":"admin"}},"SaleChannelId":0,"SaleChannel":null,"Code":"Trả hàng 1","ReturnDiscount":{4},"ReturnFee":{5},"ReturnFeeRatio":{6},"ReturnDetails":[{8}],"InvoiceDetails":[],"InvoiceOrderSurcharges":[],"Payments":[{{"Method":"Cash","MethodStr":"Tiền mặt","Amount":{7},"Id":-1}}],"Status":1,"Surcharge":0,"Type":3,"Uuid":"{9}","PayingAmount":{7},"TotalBeforeDiscount":0,"ProductDiscount":0,"TotalReturn":119990,"txtPay":"Tiền trả khách","addToAccount":"0","InvoiceComparePurchaseDate":"2019-08-10T16:18:47.1900000+07:00","ReturnSurcharges":[],"CreatedBy":20447}}}}    ${BRANCH_ID}    ${get_id_nguoitao}    ${get_invoice_id}    ${get_id_nguoiban}
    ...    ${result_gghd}    ${result_phitrahang}    ${phi_trahang}    ${actual_cantrakhach}    ${liststring_prs_invoice_detail}    ${Uuid_code}
    Log    ${request_payload}
    ${return_code}    Post request to create return and get resp    ${request_payload}
    Return From Keyword    ${return_code}

Get list of result onhand incase return multi row product
    [Arguments]    ${input_list_product}    ${input_list_num_multi_row}
    [Timeout]    3 minutes
    ${list_result_onhand}    Create List
    ${get_list_onhand_bf}    Get list of Onhand by Product Code    ${input_list_product}
    : FOR    ${item_num}    ${item_onhand}    IN ZIP    ${input_list_product}
    \    ${result_onhand}    Minus    ${item_onhand}    ${item_num}
    \    Append To List    ${list_result_onhand}    ${result_onhand}
    Return From Keyword    ${list_result_onhand}

Get list total sale - result onhand - cost incase return multi row product
    [Arguments]    ${input_list_product}    ${input_list_product_type}    ${input_list_num_mul_row}    ${input_list_change_mul_lines}    ${input_list_change_type_mul_lines}
    [Timeout]    5 minutes
    ${list_result_onhand}    Create List
    ${get_list_baseprice}    ${get_list_giavon}    ${get_list_onhand_bf}    ${list_giatri_quydoi}    Get list base price - cost - onhand - gia tri quy doi frm API    ${input_list_product}
    ${list_total_num}    Create List
    ${list_result_totalsale}    Create List
    : FOR    ${item_list_num}    ${item_quydoi}    IN ZIP    ${input_list_num_mul_row}    ${list_giatri_quydoi}
    \    ${item_list_num}    Convert String to List    ${item_list_num}
    \    ${item_total_num}    Sum values in list    ${item_list_num}
    \    ${result_num_cb}    Multiplication for onhand    ${item_total_num}    ${item_quydoi}
    \    Append To List    ${list_total_num}    ${result_num_cb}
    Log    ${list_total_num}
    : FOR    ${item_num}    ${item_onhand}    ${item_pr_type}    IN ZIP    ${list_total_num}    ${get_list_onhand_bf}
    ...    ${input_list_product_type}
    \    ${result_onhand}    Sum    ${item_onhand}    ${item_num}
    \    ${result_onhand}    Set Variable If    '${item_pr_type}'=='com' or '${item_pr_type}'=='ser'    0    ${result_onhand}
    \    Append To List    ${list_result_onhand}    ${result_onhand}
    Log    ${list_result_onhand}
    : FOR    ${item_pr}    ${item_baseprice}    ${item_list_num}    ${item_list_change}    ${item_list_changetype}    IN ZIP
    ...    ${input_list_product}    ${get_list_baseprice}    ${input_list_num_mul_row}    ${input_list_change_mul_lines}    ${input_list_change_type_mul_lines}
    \    ${list_quan}    Convert String to List    ${item_list_num}
    \    ${list_change}    Convert String to List    ${item_list_change}
    \    ${list_changetype}    Convert String to List    ${item_list_changetype}
    \    ${list_totalsale_by_each_pr}    ${list_result_newprice_by_each_row_pr}    Compute total sale and result new price by single row in case multi-lines    ${item_baseprice}    ${list_quan}    ${list_change}
    \    ...    ${list_changetype}
    \    ${result_totalsale_by_each_pr}    Sum values in list    ${list_totalsale_by_each_pr}
    \    Append To List    ${list_result_totalsale}    ${result_totalsale_by_each_pr}
    Log    ${list_result_totalsale}
    Return From Keyword    ${list_result_totalsale}    ${list_result_onhand}    ${get_list_giavon}

Create json for each product in csse return multi row
    [Arguments]    ${prd_id}    ${prd_type}    ${list_nums}    ${item_baseprices}    ${list_newprices}    ${list_imeii_all}
    ...    ${invoice_detail_id}
    ${list_nums}    Convert String to List    ${list_nums}
    ${list_newprices}    Convert String to List    ${list_newprices}
    ${liststring_prs_return_detail}    Set Variable    needdel
    : FOR    ${item_num}    ${item_newprice}    ${item_list_imei}    IN ZIP    ${list_nums}    ${list_newprices}
    ...    ${list_imeii_all}
    \    ${item_list_imei}    Convert List to String    ${item_list_imei}
    \    ${item_list_imei}    Set Variable If    '${prd_type}'=='imei'    ${item_list_imei}    ${EMPTY}
    \    ${payload_each_prd}    Format String    {{"BasePrice":{0},"IsLotSerialControl":true,"Note":"","Price":{1},"ProductId":{2},"Quantity":{3},"UsePoint":false,"SerialNumbers":"{4}","SellPrice":{1},"ProductName":"chuột quang hồng","InvoiceDetailId":{5},"IsMaster":false,"ProductBatchExpireId":null}}    ${item_baseprices}    ${item_newprice}    ${prd_id}
    \    ...    ${item_num}    ${item_list_imei}    ${invoice_detail_id}
    \    ${payload_each_prd}    Set Variable If    '${item_num}'=='0'    ${EMPTY}    ${payload_each_prd}
    \    ${liststring_prs_return_detail}    Run Keyword If    '${item_num}'!='0'    Catenate    SEPARATOR=,    ${liststring_prs_return_detail}
    \    ...    ${payload_each_prd}
    \    ...    ELSE    Set Variable    ${liststring_prs_return_detail}
    ${liststring_prs_return_detail}    Replace String    ${liststring_prs_return_detail}    needdel,    ${EMPTY}    count=1
    Log    ${liststring_prs_return_detail}
    Return From Keyword    ${liststring_prs_return_detail}

Add new return - payment surplus frm API
    [Arguments]    ${input_ma_kh}    ${dict_product_nums}    ${input_khtt}
    ${Uuid}      Generate Random String    4    [NUMBERS][NUMBERS]
    ${Uuid_code}      Catenate      SEPARATOR=      WA     ${Uuid}
    ${list_product}    Get Dictionary Keys    ${dict_product_nums}
    ${list_nums}    Get Dictionary Values    ${dict_product_nums}
    Create list imei and other product    ${list_product}    ${list_nums}
    #get product info
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${jsonpath_id_kh}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_kh}
    ${get_id_kh}    Get data from API    ${endpoint_khachhang}    ${jsonpath_id_kh}
    ${endpoint_danhmuc_hh_co_dvt}    Format String    ${endpoint_list_hh_in_mhbh}    ${BRANCH_ID}    ${BRANCH_ID}
    ${get_resp_danhmuc_hh}    Get Request and return body    ${endpoint_danhmuc_hh_co_dvt}
    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}    Get list jsonpath product frm list product    ${list_product}
    ${list_giaban}    ${list_id_sp}    Get product info frm list jsonpath product    ${get_resp_danhmuc_hh}    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}
    ${list_thanhtien_hh}    Create List
    : FOR    ${giaban}    ${soluong}    IN ZIP    ${list_giaban}    ${list_nums}
    \    ${result_item_thanhtien}    Multiplication and round    ${giaban}    ${soluong}
    \    Append To List    ${list_thanhtien_hh}    ${result_item_thanhtien}
    Log    ${list_thanhtien_hh}
    ${result_tongtienhang}    Sum values in list    ${list_thanhtien_hh}
    ${actual_khtt}    Set Variable If    '${input_khtt}' == 'all'    ${result_tongtienhang}    ${input_khtt}
    #post request
    ${liststring_prs_return_detail}    Set Variable    needdel
    Log    ${liststring_prs_return_detail}
    : FOR    ${item_gia_ban}    ${item_id_sp}    ${item_soluong}    ${item_imei}    IN ZIP    ${list_giaban}    ${list_id_sp}    ${list_nums}    ${imei_inlist}
    \    ${item_imei}    Convert list to string and return    ${item_imei}
    \    ${payload_each_product}    Format string    {{"BasePrice":{0},"IsLotSerialControl":false,"Note":"","Price":{0},"ProductId":{1},"Quantity":{2},"SerialNumbers":"{3}","SellPrice":{0},"ProductName":"MHH01","CopiedPrice":{0},"ProductBatchExpireId":null}}    ${item_gia_ban}    ${item_id_sp}    ${item_soluong}   ${item_imei}
    \    ${liststring_prs_return_detail}    Catenate    SEPARATOR=,    ${liststring_prs_return_detail}    ${payload_each_product}
    ${liststring_prs_return_detail}    Replace String    ${liststring_prs_return_detail}    needdel,    ${EMPTY}    count=1
    ${request_payload}    Format String    {{"Return":{{"BranchId":{0},"RetailerId":{1},"CustomerId":{2},"ReceivedById":{3},"ReceivedBy":{{"CreatedBy":0,"CreatedDate":"2018-07-30T08:27:36.800Z","Email":"","GivenName":"anh.lv","Id":{3},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false}},"SaleChannelId":0,"SaleChannel":null,"Code":"Trả hàng 1","ReturnDiscount":0,"ReturnFee":0,"ReturnDetails":[{4}],"InvoiceDetails":[],"InvoiceOrderSurcharges":[],"Payments":[{{"Method":"Cash","MethodStr":"Tiền mặt","Amount":{5},"Id":-1}}],"PaymentSurplus":[],"Status":1,"Surcharge":0,"Type":3,"Uuid":"{7}","PayingAmount":{5},"TotalBeforeDiscount":0,"ProductDiscount":0,"TotalReturn":{6},"txtPay":"Tiền trả khách","addToAccount":"0","addToAccountSurplus":"1","addToAccountAllocation":"0","addToAccountPaymentAllocation":"1","ReturnSurcharges":[],"CreatedBy":201567}}}}    ${BRANCH_ID}    ${get_id_nguoitao}    ${get_id_kh}    ${get_id_nguoiban}
    ...    ${liststring_prs_return_detail}    ${actual_khtt}    ${result_tongtienhang}    ${Uuid_code}
    Log    ${request_payload}
    ${return_code}    Post request to create return and get resp    ${request_payload}
    Return From Keyword    ${invoice_code}

Get return info after allocate
    [Arguments]    ${input_ma_th}    ${input_phieuthanhtoan}
    [Timeout]    5 minute
    ${endpoint_trahang}    Format String    ${endpoint_trahang}    ${BranchId}
    ${get_resp}    Get Request and return body    ${endpoint_trahang}
    ${jsonpath_datrakhach}    Format String    $.Data[?(@.Code == '{0}')].TotalPayment    ${input_ma_th}
    ${get_datrakhach}    Get data from response json    ${get_resp}    ${jsonpath_datrakhach}
    ${get_datrakhach}    Convert To String    ${get_datrakhach}
    ${get_datrakhach}    Replace String    ${get_datrakhach}    -    ${EMPTY}
    ${get_datrakhach}    Convert To Number    ${get_datrakhach}
    ${get_return_id}    Get return id    ${input_ma_th}
    ${endpoint_ptt_by_id}   Format String    ${endpoint_phieu_thanhtoan_thnhanh}    ${get_return_id}
    ${jsonpath_ptt_pb}    Format String    $..Data[?(@.Code == "{0}")].PaidValue    ${input_phieuthanhtoan}
    ${get_ptt_pb}   Get data from API    ${endpoint_ptt_by_id}    ${jsonpath_ptt_pb}
    Return From Keyword    ${get_datrakhach}    ${get_ptt_pb}

##gôp discount and newprice
Get list total sale - endingstock - cost incase discount and newprice
    [Arguments]    ${list_product}    ${list_nums}    ${list_ggsp}    ${list_discount_type}
    [Timeout]    5 minute
    ${list_result_thanhtien}    Create List
    ${list_result_toncuoi}    Create List
    ${get_list_giaban}    ${get_list_giavon}    ${get_list_ton}    ${list_giatri_quydoi}    Get list base price - cost - onhand - gia tri quy doi frm API    ${list_product}
    ${list_product_type}    ${list_tonkho_service}    Get list product type and ending stock of service frm API    ${list_product}
    : FOR    ${item_product}    ${item_nums}    ${item_onhand}    ${get_toncuoi_dv_execute}    ${get_giatri_quydoi}    ${get_product_type}
    ...    ${item_price}    ${input_ggsp}   ${discount_type}    IN ZIP    ${list_product}    ${list_nums}    ${get_list_ton}
    ...    ${list_tonkho_service}    ${list_giatri_quydoi}    ${list_product_type}    ${get_list_giaban}    ${list_ggsp}    ${list_discount_type}
    \    ${result_toncuoi}    Run Keyword If    '${get_giatri_quydoi}' == '1'    Computation endingstock frm API    ${item_nums}    ${item_onhand}
    \    ...    ${get_product_type}    ${get_toncuoi_dv_execute}
    \    ...    ELSE    Computation endingstock for unit product    ${item_product}    ${item_nums}    ${get_giatri_quydoi}
    \    ${result_giamoi}    Run Keyword If    '${discount_type}' == 'dis'     Price after % discount product    ${input_price}    ${input_ggsp}
    \    ...    ELSE IF    '${discount_type}' == 'disvnd'    Minus and round 2        ${input_price}    ${input_ggsp}
    \    ...    ELSE IF    '${discount_type}' == 'changeup' or '${discount_type}' == 'changedown'  Set Variable   ${input_ggsp}    ELSE    Set Variable    ${input_price}
    \    ${result_thanhtien}    Multiplication and round    ${result_giamoi}    ${item_nums}
    \    Append to list    ${list_result_thanhtien}    ${result_thanhtien}
    \    Append to list    ${list_result_toncuoi}    ${result_toncuoi}
    Return From Keyword    ${list_result_thanhtien}    ${get_list_giavon}    ${list_result_toncuoi}

Get list total sale - endingstock - cost - newprice incase discount frm api
    [Arguments]    ${list_product}    ${list_nums}    ${list_ggsp}    ${list_discount_type}
    [Timeout]    5 minute
    ${list_result_thanhtien}    Create List
    ${list_result_toncuoi}    Create List
    ${list_result_giamoi}    Create List
    ${get_list_giaban}    ${get_list_giavon}    ${get_list_ton}    ${list_giatri_quydoi}    Get list base price - cost - onhand - gia tri quy doi frm API    ${list_product}
    ${list_product_type}    ${list_tonkho_service}    Get list product type and ending stock of service frm API    ${list_product}
    : FOR    ${item_product}    ${item_nums}    ${item_onhand}    ${get_toncuoi_dv_execute}    ${get_giatri_quydoi}    ${get_product_type}
    ...    ${item_price}    ${input_ggsp}    ${discount_type}    IN ZIP    ${list_product}    ${list_nums}    ${get_list_ton}
    ...    ${list_tonkho_service}    ${list_giatri_quydoi}    ${list_product_type}    ${get_list_giaban}    ${list_ggsp}    ${list_discount_type}
    \    ${result_toncuoi}    Run Keyword If    '${get_giatri_quydoi}' == '1'    Computation endingstock frm API    ${item_nums}    ${item_onhand}
    \    ...    ${get_product_type}    ${get_toncuoi_dv_execute}
    \    ...    ELSE    Computation endingstock for unit product    ${item_product}    ${item_nums}    ${get_giatri_quydoi}
    \    ${result_new_price}    Run Keyword If    '${discount_type}' == 'dis'    Price after % discount product    ${item_price}    ${input_ggsp}
    \    ...    ELSE IF    '${discount_type}' == 'disvnd'    Minus and round 2    ${item_price}    ${input_ggsp}
    \    ...    ELSE IF    '${discount_type}' == 'changeup' or '${discount_type}' == 'changedown'   Set Variable      ${input_ggsp}     ELSE    Set Variable    ${item_price}
    \    ${result_thanhtien}    Multiplication and round    ${result_new_price}    ${item_nums}
    \    Append to list    ${list_result_thanhtien}    ${result_thanhtien}
    \    Append to list    ${list_result_toncuoi}    ${result_toncuoi}
    \    Append to list    ${list_result_giamoi}    ${result_new_price}
    Return From Keyword    ${list_result_thanhtien}    ${get_list_giavon}    ${list_result_toncuoi}    ${list_result_giamoi}

Get list total sale - endingstock - cost frm api
    [Arguments]    ${list_product}    ${list_nums}
    [Timeout]    5 minute
    ${list_result_thanhtien}    Create List
    ${list_result_toncuoi}    Create List
    ${get_list_giaban}    ${get_list_giavon}    ${get_list_ton}    ${list_giatri_quydoi}    Get list base price - cost - onhand - gia tri quy doi frm API    ${list_product}
    ${list_product_type}    ${list_tonkho_service}    Get list product type and ending stock of service frm API    ${list_product}
    : FOR    ${item_product}    ${item_nums}    ${item_onhand}    ${get_toncuoi_dv_execute}    ${get_giatri_quydoi}    ${get_product_type}    ${item_price}    IN ZIP    ${list_product}
    ...    ${list_nums}    ${get_list_ton}    ${list_tonkho_service}    ${list_giatri_quydoi}    ${list_product_type}    ${get_list_giaban}
    \    ${result_toncuoi}    Run Keyword If    '${get_giatri_quydoi}' == '1'    Computation endingstock frm API    ${item_nums}    ${item_onhand}
    \    ...    ${get_product_type}    ${get_toncuoi_dv_execute}
    \    ...    ELSE    Computation endingstock for unit product    ${item_product}    ${item_nums}    ${get_giatri_quydoi}
    \    ${result_thanhtien}    Multiplication and round    ${item_price}    ${item_nums}
    \    Append to list    ${list_result_thanhtien}    ${result_thanhtien}
    \    Append to list    ${list_result_toncuoi}    ${result_toncuoi}
    Return From Keyword    ${list_result_thanhtien}    ${get_list_giavon}    ${list_result_toncuoi}

Get list of result onhand af return
    [Arguments]    ${input_list_product}    ${input_list_num}
    [Documentation]    Lấy dữ liệu qua API theo list tồn cuối trước khi bán, giá SP. Tính toán tổng tiền hàng, tồn cuối sau bán, giá mới trong các TH: thay đổi giá SP, giảm giá SP theo vnd,%, không giảm giá SP
    [Timeout]    5 minutes
    ${list_result_onhand}    Create list
    ${get_list_onhand_bf_purchase}    Get list of Onhand by Product Code    ${input_list_product}
    ${get_list_product_type}    ${get_list_imei_status}      Get list product type and imei status frm API   ${input_list_product}
    :FOR    ${item_pr}    ${item_pr_type}     ${item_imei_status}     ${item_onhand}   ${item_num}     IN ZIP    ${input_list_product}   ${get_list_product_type}   ${get_list_imei_status}    ${get_list_onhand_bf_purchase}   ${input_list_num}
    \    ${result_onhand}    Sum    ${item_onhand}    ${item_num}
    \    Run Keyword If    ${item_pr_type}==1 or ${item_pr_type}==3     Append To List    ${list_result_onhand}    0     ELSE         Append To List   ${list_result_onhand}    ${result_onhand}
    Return From Keyword    ${list_result_onhand}

Get price book in return detail
    [Arguments]    ${input_ma_th}
    [Timeout]    3 minute
    ${jsonpath_id_th}    Format String    $.Data[?(@.Code == '{0}')].Id    ${input_ma_th}
    ${endpoint_trahang_by_branch}    Format String    ${endpoint_trahang}    ${BRANCH_ID}
    ${get_id_th}    Get data from API    ${endpoint_trahang_by_branch}    ${jsonpath_id_th}
    ${endpoint_returndetail}    Format String    ${endpoint_return_detail}    ${get_id_th}
    ${get_ten_banggia}    Get data from API    ${endpoint_returndetail}    $.PriceBook..Name
    Return From Keyword    ${get_ten_banggia}

Get list return by current date
    [Timeout]    3 minute
    ${date_current}   Get Current Date      result_format=%Y-%m-%d
    ${endpoint_trahang}    Format String    ${endpoint_trahang_currentdate}    ${BRANCH_ID}    ${date_current}
    ${get_list_return}    Get raw data from API    ${endpoint_trahang}    $.Data..Code
    ${get_summary_retunr}   Get data from API    ${endpoint_trahang}    $.Total1Value
    Return From Keyword    ${get_list_return}    ${get_summary_retunr}

Add new return without customer
    [Arguments]    ${dict_product_nums}    ${input_khtt}
    [Timeout]    3 minutes
    ${Uuid}      Generate Random String    4    [NUMBERS][NUMBERS]
    ${Uuid_code}      Catenate      SEPARATOR=      WA     ${Uuid}
    #get info tra hang
    ${list_products}    Get Dictionary Keys    ${dict_product_nums}
    ${list_nums}    Get Dictionary Values    ${dict_product_nums}
    ${list_result_thanhtien}    ${list_giavon}    ${list_result_toncuoi}    Get list total sale - endingstock - cost frm api    ${list_products}    ${list_nums}
    #
    ${endpoint_danhmuc_hh_by_branch}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${resp_product_list}    Get Request and return body    ${endpoint_danhmuc_hh_by_branch}
    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}    Get List Jsonpath Product Frm List Product    ${list_products}
    ${list_giaban}    ${list_id_sp}    Get product info frm list jsonpath product    ${resp_product_list}    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}
    #compute
    ${result_tongtienhangtra}    Sum values in list and round    ${list_result_thanhtien}
    ${result_khtt}    Set Variable If    "${input_khtt}" == "all"    ${result_tongtienhangtra}    ${input_khtt}
    ${actual_khtt}    Set Variable If    "${input_khtt}" == "0"    0    ${result_khtt}
    ##
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    # Post request BH
    ${liststring_prs_invoice_detail}    Set Variable    needdel
    Log    ${liststring_prs_invoice_detail}
    : FOR    ${item_product_id}    ${item_price}    ${item_num}    IN ZIP    ${list_id_sp}   ${list_giaban}    ${list_nums}
    \    ${payload_each_product}    Format string    {{"BasePrice":{0},"IsLotSerialControl":true,"Note":"","Price":{0},"ProductId":{1},"Quantity":{2},"SellPrice":{0},"ProductName":"chuột quang hồng","Discount":0,"DiscountRatio":null,"CopiedPrice":134216.23,"ProductBatchExpireId":null}}    ${item_price}    ${item_product_id}
    \    ...    ${item_num}
    \    ${liststring_prs_invoice_detail}    Catenate    SEPARATOR=,    ${liststring_prs_invoice_detail}    ${payload_each_product}
    Log    ${liststring_prs_invoice_detail}
    ${liststring_prs_invoice_detail}    Replace String    ${liststring_prs_invoice_detail}    needdel,    ${EMPTY}    count=1
    ${request_payload}    Format String    {{"Return":{{"BranchId":{0},"RetailerId":{1},"ReceivedById":{2},"ReceivedBy":{{"CreatedBy":0,"CreatedDate":"2019-04-23T10:22:08.910Z","Email":"","GivenName":"admin","Id":20447,"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false}},"SaleChannelId":0,"SaleChannel":null,"Code":"Trả hàng 1","ReturnDiscount":0,"ReturnFee":0,"ReturnFeeRatio":0,"ReturnDetails":[{3}],"InvoiceDetails":[],"InvoiceOrderSurcharges":[],"Payments":[{{"Method":"Cash","MethodStr":"Tiền mặt","Amount":{4},"Id":-1}}],"Status":1,"Surcharge":0,"Type":3,"Uuid":"{5}","PayingAmount":{4},"TotalBeforeDiscount":0,"ProductDiscount":0,"TotalReturn":576000,"txtPay":"Tiền trả khách","addToAccount":"0","addToAccountSurplus":"0","addToAccountAllocation":"0","addToAccountPaymentAllocation":"0","ReturnSurcharges":[],"CreatedBy":20447}}}}    ${BRANCH_ID}    ${get_id_nguoitao}    ${get_id_nguoiban}
    ...    ${liststring_prs_invoice_detail}    ${actual_khtt}    ${Uuid_code}
    Log    ${request_payload}
    ${return_code}    Post request to create return and get resp    ${request_payload}
    Return From Keyword    ${return_code}

Add new return with customer
    [Arguments]    ${input_ma_kh}    ${dict_product_nums}    ${input_khtt}
    [Timeout]    3 minutes
    ${get_id_kh}    Get customer id thr API    ${input_ma_kh}
    ${Uuid}      Generate Random String    4    [NUMBERS][NUMBERS]
    ${Uuid_code}      Catenate      SEPARATOR=      WA     ${Uuid}
    #get info tra hang
    ${list_products}    Get Dictionary Keys    ${dict_product_nums}
    ${list_nums}    Get Dictionary Values    ${dict_product_nums}
    ${list_result_thanhtien}    ${list_giavon}    ${list_result_toncuoi}    Get list total sale - endingstock - cost frm api    ${list_products}    ${list_nums}
    #
    ${endpoint_danhmuc_hh_by_branch}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${resp_product_list}    Get Request and return body    ${endpoint_danhmuc_hh_by_branch}
    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}    Get List Jsonpath Product Frm List Product    ${list_products}
    ${list_giaban}    ${list_id_sp}    Get product info frm list jsonpath product    ${resp_product_list}    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}
    #compute
    ${result_tongtienhangtra}    Sum values in list and round    ${list_result_thanhtien}
    ${result_khtt}    Set Variable If    "${input_khtt}" == "all"    ${result_tongtienhangtra}    ${input_khtt}
    ${actual_khtt}    Set Variable If    "${input_khtt}" == "0"    0    ${result_khtt}
    ##
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    # Post request BH
    ${liststring_prs_invoice_detail}    Set Variable    needdel
    Log    ${liststring_prs_invoice_detail}
    : FOR    ${item_product_id}    ${item_price}    ${item_num}    IN ZIP    ${list_id_sp}   ${list_giaban}    ${list_nums}
    \    ${payload_each_product}    Format string    {{"BasePrice":{0},"IsLotSerialControl":true,"Note":"","Price":{0},"ProductId":{1},"Quantity":{2},"SellPrice":{0},"ProductName":"chuột quang hồng","Discount":0,"DiscountRatio":null,"CopiedPrice":134216.23,"ProductBatchExpireId":null}}    ${item_price}    ${item_product_id}
    \    ...    ${item_num}
    \    ${liststring_prs_invoice_detail}    Catenate    SEPARATOR=,    ${liststring_prs_invoice_detail}    ${payload_each_product}
    Log    ${liststring_prs_invoice_detail}
    ${liststring_prs_invoice_detail}    Replace String    ${liststring_prs_invoice_detail}    needdel,    ${EMPTY}    count=1
    ${request_payload}    Format String    {{"Return":{{"BranchId":{0},"RetailerId":{1},"CustomerId":{2},"ReceivedById":{3},"ReceivedBy":{{"CreatedBy":0,"CreatedDate":"2020-09-07T04:58:15.743Z","Email":"tthao@gmail.com","GivenName":"thao11","Id":{3},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false}},"SaleChannelId":0,"Code":"Trả hàng 1","ReturnDiscount":0,"ReturnFee":0,"ReturnDetails":[{4}],"InvoiceDetails":[],"InvoiceOrderSurcharges":[],"Payments":[{{"Method":"Cash","MethodStr":"Tiền mặt","Amount":{5},"Id":-1}}],"Status":1,"Surcharge":0,"Type":3,"Uuid":"{6}","PayingAmount":{5},"TotalBeforeDiscount":0,"ProductDiscount":0,"TotalReturn":{5},"txtPay":"Tiền trả khách","addToAccount":"0","addToAccountSurplus":"0","addToAccountAllocation":"0","addToAccountPaymentAllocation":"0","ReturnSurcharges":[],"CreatedBy":{3}}}}}    ${BRANCH_ID}    ${get_id_nguoitao}    ${get_id_kh}    ${get_id_nguoiban}
    ...    ${liststring_prs_invoice_detail}    ${actual_khtt}    ${Uuid_code}
    Log    ${request_payload}
    ${return_code}    Post request to create return and get resp    ${request_payload}
    Return From Keyword    ${return_code}

Assert return exist succeed
    [Arguments]    ${return_code}
    ${get_id_th}    Get return id     ${return_code}
    Should Not Be Equal As Numbers    ${get_id_th}     0
    Return From Keyword    ${get_id_th}

Assert values by return code
    [Arguments]       ${ma_th_kv}     ${input_tongtienhangtra}     ${input_gg_phieutra}     ${input_phi_trahang}      ${input_tongtien_hoadontra}     ${input_datrakhach}
    ${get_tongtienhangtra_af_ex}    ${get_giamgiaphieutra}    ${get_phitrahang_af_ex}    ${get_cantrakhach_af_ex}    ${get_datrakhach_af_ex}    ${get_tongtien_hoadontra_af_ex}    Get return info incase discount by return code    ${ma_th_kv}
    Should Be Equal As Numbers    ${get_tongtienhangtra_af_ex}    ${input_tongtienhangtra}
    Should Be Equal As Numbers    ${get_giamgiaphieutra}    ${input_gg_phieutra}
    Should Be Equal As Numbers    ${get_phitrahang_af_ex}    ${input_phi_trahang}
    Should Be Equal As Numbers    ${get_tongtien_hoadontra_af_ex}    ${input_tongtien_hoadontra}
    Should Be Equal As Numbers    ${get_datrakhach_af_ex}    ${input_datrakhach}

Assert values by return code until succeed
    [Arguments]       ${ma_th_kv}     ${input_tongtienhangtra}     ${input_gg_phieutra}     ${input_phi_trahang}      ${input_tongtien_hoadontra}     ${input_datrakhach}
    Wait Until Keyword Succeeds    5x    3s    Assert values by return code    ${ma_th_kv}     ${input_tongtienhangtra}     ${input_gg_phieutra}     ${input_phi_trahang}      ${input_tongtien_hoadontra}     ${input_datrakhach}

Assert list onhand and cost by return code
    [Arguments]    ${return_code}     ${list_result_toncuoi_th}    ${list_giavon_th}
    ${get_list_hh_in_th_af_execute}    Get list product frm Return API    ${return_code}
    ${get_list_hh_in_th_af_execute}    Reverse List one    ${get_list_hh_in_th_af_execute}
    ${list_soluong_in_th}    ${list_giatriquydoi_in_th}    Get list quantity and gia tri quy doi with return have multi product    ${get_list_hh_in_th_af_execute}    ${return_code}
    : FOR    ${item_ma_hh}    ${result_toncuoi}    ${item_giavon}    ${get_soluong_in_th}    ${get_giatri_quydoi_th}    IN ZIP
    ...    ${get_list_hh_in_th_af_execute}    ${list_result_toncuoi_th}    ${list_giavon_th}    ${list_soluong_in_th}    ${list_giatriquydoi_in_th}
    \    Run Keyword If    '${get_giatri_quydoi_th}' == '1'    Validate onhand and cost frm API    ${return_code}    ${item_ma_hh}    ${result_toncuoi}
    \    ...    ${item_giavon}    ${get_soluong_in_th}
    \    ...    ELSE    Validate onhand and cost frm unit product    ${return_code}    ${item_ma_hh}    ${result_toncuoi}
    \    ...    ${item_giavon}    ${get_soluong_in_th}    ${get_giatri_quydoi_th}

Get return summary infor by order code thr API
    [Arguments]     ${return_code}
    ${endpoint_trahang_by_branch}    Format String    ${endpoint_trahang}    ${BRANCH_ID}
    ${resp}     Get Request and return body    ${endpoint_trahang_by_branch}
    ${get_ma_kh}      Get data from response json    ${resp}    $.Data[?(@.Code=='${return_code}')].Customer.Code
    #${get_catrakhach}      Get data from response json    ${resp}    $.Data[?(@.Code=='${return_code}')].ReturnTotal
    ${get_datrakhach}      Get data from response json    ${resp}    $.Data[?(@.Code=='${return_code}')].TotalPayment
    ${input_trangthai_th}      Get data from response json    ${resp}    $.Data[?(@.Code=='${return_code}')].Status
    Return From Keyword    ${get_ma_kh}       ${get_datrakhach}      ${input_trangthai_th}

Assert return summary values after excute
    [Arguments]     ${return_code}      ${input_ma_kh}      ${input_datrakhach}   ${input_trangthai_th}
    ${get_ma_kh}        ${get_datrakhach}      ${input_trangthai_th}     Get return summary infor by order code thr API    ${return_code}
    Should Be Equal As Strings    ${input_ma_kh}    ${get_ma_kh}
    Should Be Equal As Numbers    ${input_datrakhach}    ${get_datrakhach}
    Should Be Equal As Strings    ${input_trangthai_th}    ${input_trangthai_th}

Assert return summary values until succeed
    [Arguments]    ${return_code}      ${input_ma_kh}       ${input_datrakhach}   ${input_trangthai_th}
    Wait Until Keyword Succeeds    3x    3x    Assert return summary values after excute    ${return_code}      ${input_ma_kh}       ${input_datrakhach}   ${input_trangthai_th}

Assert value in invoice at exchange invoice
    [Arguments]    ${get_ma_hd}    ${get_tong_tien_hang_bf_ex}    ${get_khach_tt_bf_ex}    ${get_ma_kh_by_hd_bf_ex}    ${get_trangthai_bf_ex}
    [Documentation]    assert thông tin hóa đơn trong đơn đổi trả hàng
    ${get_ma_kh_by_hd_af_ex}    ${get_tong_tien_hang_af_ex}    ${get_khach_tt_af_ex}    ${get_trangthai_af_ex}    Get invoice info by invoice code    ${get_ma_hd}
    Should Be Equal As Numbers    ${get_tong_tien_hang_af_ex}    ${get_tong_tien_hang_bf_ex}
    Should Be Equal As Numbers    ${get_khach_tt_af_ex}    ${get_khach_tt_bf_ex}
    Should Be Equal As Strings    ${get_ma_kh_by_hd_af_ex}    ${get_ma_kh_by_hd_bf_ex}
    Should Be Equal As Strings    ${get_trangthai_af_ex}    ${get_trangthai_bf_ex}

Assert value in return at exchange invoice
    [Arguments]    ${return_code}    ${result_tongtientra}    ${result_phi_th}    ${result_cantrakhach}    ${actual_khtt}    ${result_tongtientra_tru_phith}
    [Documentation]    assert thông tin hóa đơn trong đơn đổi trả hàng
    ${get_tongtienhangtra_af_ex}    ${get_phitrahang_af_ex}    ${get_cantrakhach_af_ex}    ${get_datrakhach_af_ex}    ${get_tongtien_hoadontra_af_ex}    Get return info by return code    ${return_code}
    Should Be Equal As Numbers    ${get_tongtienhangtra_af_ex}    ${result_tongtientra}
    Should Be Equal As Numbers    ${get_phitrahang_af_ex}    ${result_phi_th}
    Run Keyword If    ${result_cantrakhach}>0    Should Be Equal As Numbers    ${get_cantrakhach_af_ex}    ${result_cantrakhach}
    ...    ELSE    Should Be Equal As Numbers    ${get_cantrakhach_af_ex}    0
    Should Be Equal As Numbers    ${get_datrakhach_af_ex}    ${actual_khtt}
    Should Be Equal As Numbers    ${get_tongtien_hoadontra_af_ex}    ${result_tongtientra_tru_phith}

Calculating Invoice Amounts
    [Documentation]    tính toán thông tin lấy từ hóa đơn
    [Arguments]    ${get_ma_hd}
    ${get_ma_kh_by_hd_bf_ex}    ${get_tong_tien_hang_bf_ex}    ${get_khach_tt_bf_ex}    ${get_trangthai_bf_ex}    Get invoice info by invoice code    ${get_ma_hd}
    ${get_list_hh_in_hd}    ${get_list_sl_in_hd}    Get list product and quantity frm invoice API    ${get_ma_hd}
    ${get_list_sl_in_hd}    Convert String to List    ${get_list_sl_in_hd}
    ${list_result_thanhtien_th}    ${list_giavon_th}    ${list_result_toncuoi_th}    Get list total sale - endingstock - cost frm product api    ${get_list_hh_in_hd}    ${get_list_sl_in_hd}
    Return From Keyword    ${get_ma_kh_by_hd_bf_ex}    ${get_tong_tien_hang_bf_ex}    ${get_khach_tt_bf_ex}    ${get_trangthai_bf_ex}    ${list_result_thanhtien_th}    ${list_giavon_th}    ${list_result_toncuoi_th}

Compute Tra hang
    [Documentation]    tính toán thông tin lấy từ hóa đơn
    [Arguments]    ${list_result_thanhtien_th}    ${input_phi_th}
    ${result_tongtientra}    Sum values in list    ${list_result_thanhtien_th}
    ${result_phi_th}    Run Keyword If    0 < ${input_phi_th} < 100    Convert % discount to VND and round    ${result_tongtientra}    ${input_phi_th}
    ...    ELSE    Set Variable    ${input_phi_th}
    ${result_tongtientra_tru_phith}    Minus and round 2    ${result_tongtientra}    ${result_phi_th}
    Return From Keyword    ${result_tongtientra}    ${result_phi_th}    ${result_tongtientra_tru_phith}

Compute Mua Hang
    [Documentation]    tính toán thông tin mua hàng
    [Arguments]    ${list_result_thanhtien_dth}    ${input_ggdth}    ${result_tongtientra_tru_phith}    ${input_khtt}
    ${result_tongtienmua}    Sum values in list    ${list_result_thanhtien_dth}
    ${result_ggdth}    Run Keyword If    0 < ${input_ggdth} < 100    Convert % discount to VND and round    ${result_tongtienmua}    ${input_ggdth}
    ...    ELSE    Set Variable    ${input_ggdth}
    ${result_tongtienmua_tru_gg}    Minus and round 2    ${result_tongtienmua}    ${result_ggdth}
    ${result_khachthanhtoan}    Minus and round 2    ${result_tongtienmua_tru_gg}    ${result_tongtientra_tru_phith}
    ${result_cantrakhach}    Minus and round 2    ${result_tongtientra_tru_phith}    ${result_tongtienmua_tru_gg}
    ${result_kh_canthanhtoan}    Set Variable If    ${result_tongtienmua_tru_gg}<${result_tongtientra_tru_phith}    ${result_cantrakhach}    ${result_khachthanhtoan}
    ${result_khtt}    Set Variable If    "${input_khtt}" == "all"    ${result_kh_canthanhtoan}    ${input_khtt}
    ${actual_khtt}    Set Variable If    "${input_khtt}" == "0"    0    ${result_khtt}
    ${actuall_trahang}    Set Variable If    ${result_tongtienmua_tru_gg}<${result_tongtientra_tru_phith}    ${actual_khtt}    0
    ${gghd_type}    Set Variable If    ${input_ggdth}>100    null    ${input_ggdth}
    Return From Keyword    ${result_tongtienmua}    ${result_ggdth}    ${result_tongtienmua_tru_gg}    ${result_cantrakhach}    ${result_kh_canthanhtoan}    ${actual_khtt}

Compute customer debt
    [Documentation]    tính toán thông tin công nợ khách hàng trong case trả hàng
    [Arguments]    ${get_no_bf_execute}    ${result_tongtientra_tru_phith}    ${input_ggdth}   ${result_tongtienmua_tru_gg}    ${actual_khtt}    ${result_tongtienmua}    ${get_tongban_bf_execute}
    ${result_du_no_th_KH}    Minus    ${get_no_bf_execute}    ${result_tongtientra_tru_phith}
    ...
    ${result_PTT_th_KH}    Run Keyword If    ${result_tongtienmua_tru_gg}<${result_tongtientra_tru_phith}    Sum    ${result_du_no_th_KH}    ${actual_khtt}
    ...    ELSE    Set Variable    ${result_du_no_th_KH}
    ${result_du_no_KH}    Sum and replace floating point    ${result_PTT_th_KH}    ${result_tongtienmua}
    ${result_PTT_dth_KH}    Run Keyword If    ${result_tongtienmua_tru_gg}>${result_tongtientra_tru_phith}    Minus    ${result_du_no_KH}    ${actual_khtt}
    ...    ELSE    Set Variable    ${result_du_no_KH}
    ${result_tongban}    Sum and replace floating point    ${get_tongban_bf_execute}    ${result_tongtienmua_tru_gg}
    Return From Keyword    ${result_PTT_dth_KH}    ${result_tongban}

Assert value of product returned in exchange invoice
    [Documentation]    validate thông tin hàng trả trong hóa đơn đổi trả hàng
    [Arguments]    ${return_code}    ${list_result_toncuoi_dth}   ${list_giavon_dth}
    ${get_additional_invoice_code}    Get additional invoice code by return code    ${return_code}
    ${get_list_hh_in_dth_af_execute}    Get list product after create invoice    ${get_additional_invoice_code}
    ${list_soluong_in_dth}    ${list_giatriquydoi_in_dth}    Get list quantity and gia tri quy doi frm additional invoice code    ${get_list_hh_in_dth_af_execute}    ${get_additional_invoice_code}
    : FOR    ${item_ma_hh}    ${result_toncuoi}    ${item_giavon}    ${get_soluong_in_dth}    ${get_giatri_quydoi_dth}    IN ZIP
    ...    ${get_list_hh_in_dth_af_execute}    ${list_result_toncuoi_dth}    ${list_giavon_dth}    ${list_soluong_in_dth}    ${list_giatriquydoi_in_dth}
    \    Run Keyword If    '${get_giatri_quydoi_dth}' == '1'    Validate onhand and cost frm API    ${get_additional_invoice_code}    ${item_ma_hh}    ${result_toncuoi}
    \    ...    ${item_giavon}    ${get_soluong_in_dth}
    \    ...    ELSE    Validate onhand and cost frm unit product    ${get_additional_invoice_code}    ${item_ma_hh}    ${result_toncuoi}
    \    ...    ${item_giavon}    ${get_soluong_in_dth}    ${get_giatri_quydoi_dth}
    Return From Keyword    ${get_additional_invoice_code}

Validate payment information in exchange invoice
    [Documentation]    validate thông tin hóa đơn đổi trả
    [Arguments]    ${result_tongtienmua}    ${get_additional_invoice_code}    ${result_tongtienmua_tru_gg}    ${result_tongtientra_tru_phith}    ${result_kh_canthanhtoan}    ${result_ggdth}
    ...    ${actual_khtt}    ${input_ma_kh}
    ${get_ma_kh_by_hd_af_ex}    ${get_tong_tien_hang_af_ex}    ${get_khach_tt_af_ex}    ${get_giamgia_hd_af_ex}    ${get_khach_can_tra_af_ex}    ${get_trangthai_af_ex}    Get additional invoice info incase discount by additional invoice code
    ...    ${get_additional_invoice_code}
    Should Be Equal As Numbers    ${get_tong_tien_hang_af_ex}    ${result_tongtienmua}
    Run Keyword If    ${result_tongtienmua_tru_gg}<${result_tongtientra_tru_phith}    Should Be Equal As Numbers    ${get_khach_can_tra_af_ex}    0
    ...    ELSE    Should Be Equal As Numbers    ${get_khach_can_tra_af_ex}    ${result_kh_canthanhtoan}
    Should Be Equal As Numbers    ${get_giamgia_hd_af_ex}    ${result_ggdth}
    Run Keyword If    ${result_tongtienmua_tru_gg}<${result_tongtientra_tru_phith}    Should Be Equal As Numbers    ${get_khach_tt_af_ex}    0
    ...    ELSE    Should Be Equal As Numbers    ${get_khach_tt_af_ex}    ${actual_khtt}
    Should Be Equal As Strings    ${get_ma_kh_by_hd_af_ex}    ${input_ma_kh}
    Should Be Equal As Strings    ${get_trangthai_af_ex}    Hoàn thành

Assert customer and so quy incase return lodate product with invoice code
    [Documentation]    kieemr tra thông tin công nợ khách hàng và thông tin trong sổ quỹ sau khi trả hàng theo hóa đơn
    [Arguments]    ${input_ma_kh}    ${return_code}    ${input_khtt}    ${actual_khtt}    ${result_du_no_th_KH}     ${result_PTT_th_KH}   ${get_tongban_bf_execute}  ${result_tongban_tru_TH}
    ${get_no_af_execute_kh}    ${get_tongban_af_execute_kh}    ${get_tongban_tru_trahang_af_execute_kh}    Get Customer Debt from API after purchase    ${input_ma_kh}    ${return_code}    ${actual_khtt}
    ${get_maphieu_soquy}    Get Ma Phieu Thu in So quy    ${return_code}
    Run Keyword If    '${input_khtt}' == '0'    Should Be Equal As Numbers    ${get_no_af_execute_kh}    ${result_du_no_th_KH}
    ...    ELSE    Should Be Equal As Numbers    ${get_no_af_execute_kh}    ${result_PTT_th_KH}
    Should Be Equal As Numbers    ${get_tongban_af_execute_kh}    ${get_tongban_bf_execute}
    Should Be Equal As Numbers    ${get_tongban_tru_trahang_af_execute_kh}    ${result_tongban_tru_TH}
    Run Keyword If    '${input_khtt}' == '0'    Validate customer history and debt if return is not paid    ${input_ma_kh}    ${return_code}    ${result_du_no_th_KH}
    ...    ELSE    Validate customer history and debt if return is paid    ${input_ma_kh}    ${return_code}    ${result_du_no_th_KH}    ${result_PTT_th_KH}
    Run Keyword If    '${input_khtt}' == '0'    Validate So quy info from Rest API if Invoice is not paid    ${get_maphieu_soquy}
    ...    ELSE    Validate So quy info from Rest API if Invoice is paid    ${get_maphieu_soquy}    ${actual_khtt}
