*** Settings ***
Library           Collections
Library           RequestsLibrary
Library           SeleniumLibrary
Library           OperatingSystem
Library           String
Library           StringFormat
Library           JSONLibrary
Resource          ../share/computation.robot
Resource          ../share/imei.robot
Resource          api_access.robot
Resource          api_danhmuc_hanghoa.robot
Resource          api_nha_cung_cap.robot
Resource          ../share/list_dictionary.robot
Resource          ../../prepare/Hang_hoa/Sources/hanghoa.robot
Resource          ../../prepare/Hang_hoa/Sources/giaodich.robot
Resource          ../Giao_dich/nhaphang_getandcompute.robot

*** Variables ***
${endpoint_phieu_nhap_hang}    /purchaseOrders?format=json&Includes=Branch&Includes=Total&Includes=PaidAmount&Includes=TotalQuantity&Includes=TotalProductType&Includes=SubTotal&Includes=Supplier&Includes=User&Includes=OrderSupplier&ForSummaryRow=true&Includes=User1&%24inlinecount=allpages&%24top=15&%24filter=(BranchId+eq+{0}+and+(Status+eq+1+or+Status+eq+3)+and+PurchaseDate+eq+%27thisweek%27)
${key_tongtienhang_pnh}    SubTotal
${key_trangthai_pnh}    StatusValue
${key_ma_ncc_pnh}    Supplier.CompareCode
${endpoint_chitiet_phieunhap}    /purchaseOrders/{0}?Includes=Supplier&Includes=PurchaseOrderExpensesOthers    #id phieu nhap hang
${endpoint_user}    /users?format=json&ExcludeMe=true&Includes=Permissions&%24inlinecount=allpages
${endpoint_nh_timkiem_theo_sp}    /purchaseOrders?format=json&Includes=Branch&Includes=Total&Includes=PaidAmount&Includes=TotalQuantity&Includes=TotalProductType&Includes=SubTotal&Includes=Supplier&Includes=User&Includes=OrderSupplier&ForSummaryRow=true&Includes=User1&%24inlinecount=allpages&ProductKey={0}&%24top=10&%24filter=(BranchId+eq+{1}+and+Status+eq+3+and+PurchaseDate+eq+%27alltime%27)    #1: mã sp, 2: branchID
${endpoint_delete_pnh}    /purchaseOrders?CompareStatus=3&Id={0}&IsVoidPayment=true    #0: id phieu nhap
${endpoint_list_purchasepayment}  /purchasepayments/?OrderId={0}&format=json&Includes=User&Includes=OrderValue&Includes=PaidValue&Includes=SupplierName&Includes=PurchaseOrder&Includes=CreatedName&%24inlinecount=allpages&%24orderby=TransDate+desc   #purchase id
*** Keywords ***
Import imei for product
    [Arguments]    ${sp_id}    ${gia_nhap}    ${serialnums}    ${sum_soluong}    ${user_id}
    [Timeout]    5 mins
    ${data_str}    Format String    {{"PurchaseOrder":{{"PurchaseOrderDetails":[{{"ProductId":{0},"Product":{{"Name":"chuột quang hồng","Code":"IP064","IsLotSerialControl":true}},"ProductName":"chuột quang hồng","ProductCode":"IP064","Description":"","Price":{1},"priceAfterDiscount":120000,"Quantity":{3},"ShowUnit":false,"ListProductUnit":[{{"Id":10844794,"Unit":"","Code":"IP064"}}],"Units":[{{"Id":10844794,"Unit":"","Code":"IP064"}}],"Unit":"","SelectedUnit":10844794,"Allocation":"0.0000","AllocationSuppliers":"0.0000","AllocationThirdParty":"0.0000","TotalValue":120000,"ViewIndex":1,"RowNumber":2,"sortValue":0,"productGroupCount":1,"isSerialProduct":true,"rowNumber":0,"Id":0,"SerialNumbers":"{2}"}}],"UserId":{5},"CompareUserId":{5},"User":{{"id":{5},"username":"123456","givenName":"ha","Id":{5},"UserName":"123456","GivenName":"ha","IsAdmin":true,"IsLimitedByTrans":false,"IsShowSumRow":true,"Theme":""}},"Description":"","CompareSupplierId":0,"SubTotal":240000,"Branch":{{"id":{4},"name":"Chi nhánh trung tâm","Id":{4},"Name":"Chi nhánh trung tâm","Address":"","LocationName":"","WardName":"","ContactNumber":""}},"Status":1,"StatusValue":"Phiếu tạm","CompareStatusValue":"Phiếu tạm","Discount":0,"CompareDiscount":0,"DiscountRatio":0,"Id":0,"Account":{{}},"Total":240000,"TotalQuantity":2,"ExpensesOthersTitle":"","ExpensesOthersRtpTitle":"","PurchaseOrderExpensesOthers":[],"PurchaseOrderExpensesOthersRs":[],"PurchaseOrderExpensesOthersRtp":[],"ExReturnSuppliers":0,"ExReturnThirdParty":0,"PaidAmount":0,"PayingAmount":0,"ChangeAmount":-240000,"paymentMethod":"","BalanceDue":240000,"OriginTotal":240000,"PricebookDetail":[],"paymentMethodObj":null,"BranchId":{4}}},"Complete":true,"CopyFrom":0,"PricebookDetail":[]}}    ${sp_id}    ${gia_nhap}    ${serialnums}    ${sum_soluong}
    ...    ${BRANCH_ID}    ${user_id}
    log    ${data_str}
    Post request thr API    /purchaseOrders    ${data_str}

Create imei list by generating random imei code
    [Arguments]    ${list_imei}
    [Timeout]    5 mins
    ${imei}    Generate Imei code automatically
    Append To List    ${list_imei}    ${imei}
    Return From Keyword    ${list_imei}

Import multi imei for product
    [Arguments]    ${input_ma_sp}    ${input_soluong}
    [Timeout]    5 mins
    ${endpoint_danhmuc_hh_co_dvt}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${get_resp}    Get Request and return body    ${endpoint_danhmuc_hh_co_dvt}
    ${jsonpath_id_sp}    Format String    $.Data[?(@.Code == '{0}')].Id    ${input_ma_sp}
    ${jsonpath_giavon}    Format String    $.Data[?(@.Code == '{0}')].Cost    ${input_ma_sp}
    ${get_id_sp}    Get data from response json    ${get_resp}    ${jsonpath_id_sp}
    ${get_giavon}    Get data from response json    ${get_resp}    ${jsonpath_giavon}
    ${list_imei}    Create List
    : FOR    ${item}    IN RANGE    ${input_soluong}
    \    ${list_imei}    Create imei list by generating random imei code    ${list_imei}
    Log    ${list_imei}
    ${string_imei}    Convert list to string    ${list_imei}
    ${get_user_id}    Get User ID
    Wait Until Keyword Succeeds    3 times    10 s    Import imei for product    ${get_id_sp}    ${get_giavon}    ${string_imei}
    ...    ${input_soluong}    ${get_user_id}
    Return From Keyword    ${list_imei}

Import multi imei for mul-line product
    [Arguments]    ${input_ma_sp}    ${input_list_quan}
    [Timeout]    5 mins
    ${list_imei_by_each_product}    Create list
    : FOR    ${num}    IN ZIP    ${input_list_quan}
    \    ${list_imei_each_row}    Import multi imei for product    ${input_ma_sp}    ${num}
    \    Append To List    ${list_imei_by_each_product}    ${list_imei_each_row}
    Return From Keyword    ${list_imei_by_each_product}

Import Imeis for products by generating randomly
    [Arguments]    ${list_prs}    ${list_num}
    [Timeout]    5 mins
    ${imei_by_product_inlist}    create list
    : FOR    ${item_product}    ${item_num}    IN ZIP    ${list_prs}    ${list_num}
    \    ${imei_by_product}    Import multi imei for product    ${item_product}    ${item_num}
    \    Append To List    ${imei_by_product_inlist}    ${imei_by_product}
    Return From Keyword    ${imei_by_product_inlist}

Create lot name list by generatin random
    [Arguments]    ${list_tenlo}
    [Documentation]    Tạo tên lô tự động
    [Timeout]    5 mins
    ${tenlo}    Generate Random String    5    [UPPER][NUMBERS]
    Append To List    ${list_tenlo}    ${tenlo}
    Return From Keyword    ${list_tenlo}

Get lot name list and import lot for product
    [Arguments]    ${input_ma_sp}    ${input_soluong}
    [Timeout]    5 mins
    ${endpoint_danhmuc_hh_co_dvt}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${jsonpath_id_sp}    Format String    $.Data[?(@.Code == '{0}')].Id    ${input_ma_sp}
    ${jsonpath_giavon}    Format String    $.Data[?(@.Code == '{0}')].Cost    ${input_ma_sp}
    ${get_id_sp}    Get data from API by BranchID    ${BRANCH_ID}    ${endpoint_danhmuc_hh_co_dvt}    ${jsonpath_id_sp}
    ${get_giavon}    Get data from API by BranchID    ${BRANCH_ID}    ${endpoint_danhmuc_hh_co_dvt}    ${jsonpath_giavon}
    ${list_tenlo}    Create List
    : FOR    ${item}    IN RANGE    1
    \    ${list_tenlo}    Create lot name list by generatin random    ${list_tenlo}
    Log    ${list_tenlo}
    ${string_tenlo}    Convert List to String    ${list_tenlo}
    ${get_user_id}    Get User ID
    ${get_current_date}    Get Current Date
    ${hsd}=    Add Time To Date    ${get_current_date}    30 days
    Wait Until Keyword Succeeds    3 times    10s    import Lot for prd    ${get_id_sp}    ${input_soluong}    ${string_tenlo}
    ...    ${hsd}    ${get_giavon}    ${get_user_id}
    Return From Keyword    ${list_tenlo}

Import lot name for products by generating randomly
    [Arguments]    ${list_prs}    ${list_num}
    [Documentation]    import lô cho sp lô date với tên lô được tạo random
    [Timeout]    5 mins
    ${tenlo_by_product_inlist}    Create List
    : FOR    ${item_product}    ${item_num}    IN ZIP    ${list_prs}    ${list_num}
    \    ${tenlo_by_product}    Get lot name list and import lot for product    ${item_product}    ${item_num}
    \    Append To List    ${tenlo_by_product_inlist}    ${tenlo_by_product}
    Return From Keyword    ${tenlo_by_product_inlist}

Import lot name for products by list all type product
    [Arguments]    ${list_prs}    ${list_num}   ${list_lodate_status}
    [Documentation]    import lô cho sp lô date với tên lô được tạo random
    [Timeout]    5 mins
    ${tenlo_by_product_inlist}    Create List
    : FOR    ${item_product}    ${item_num}    ${item_lodate_status}    IN ZIP    ${list_prs}    ${list_num}    ${list_lodate_status}
    \    ${tenlo_by_product}    Run Keyword If    '${item_lodate_status}'=='True'   Get lot name list and import lot for product    ${item_product}    ${item_num}
    \    Append To List    ${tenlo_by_product_inlist}    ${tenlo_by_product}
    Return From Keyword    ${tenlo_by_product_inlist}

Get purchase receipt info incase discount by purchase receipt code
    [Arguments]    ${input_ma_phieunhap}
    [Timeout]    5 mins
    ${jsonpath_tiendatra_ncc}    Format String    $.Data[?(@.Code== '{0}')].PaidAmount    ${input_ma_phieunhap}
    ${jsonpath_tongtienhang}    Format String    $.Data[?(@.Code== '{0}')].SubTotal    ${input_ma_phieunhap}
    ${jsonpath_discount}    Format String    $.Data[?(@.Code== '{0}')].Discount    ${input_ma_phieunhap}
    ${jsonpath_tongcong}    Format String    $.Data[?(@.Code== '{0}')].Total    ${input_ma_phieunhap}
    ${jsonpath_tongsoluong}    Format String    $.Data[?(@.Code== '{0}')].TotalQuantity    ${input_ma_phieunhap}
    ${jsonpath_trangthai}    Format String    $.Data[?(@.Code== '{0}')].StatusValue    ${input_ma_phieunhap}
    ${jsonpath_ma_ncc}    Format String    $.Data[?(@.Code== '{0}')].Supplier.Code    ${input_ma_phieunhap}
    ${endpoint_phieu_nhap_hang}    Format String    ${endpoint_phieu_nhap_hang}    ${BRANCH_ID}
    ${resp.pnh}    Get Request and return body    ${endpoint_phieu_nhap_hang}
    ${get_supplier_code}    Get data from response json    ${resp.pnh}    ${jsonpath_ma_ncc}
    ${get_tongtienhang}    Get data from response json    ${resp.pnh}    ${jsonpath_tongtienhang}
    ${get_tiendatra_ncc}    Get data from response json    ${resp.pnh}    ${jsonpath_tiendatra_ncc}
    ${get_giamgia_pn}    Get data from response json    ${resp.pnh}    ${jsonpath_discount}
    ${get_tongcong}    Get data from response json    ${resp.pnh}    ${jsonpath_tongcong}
    ${get_tongsoluong}    Get data from response json    ${resp.pnh}    ${jsonpath_tongsoluong}
    ${get_trangthai}    Get data from response json    ${resp.pnh}    ${jsonpath_trangthai}
    Return From Keyword    ${get_supplier_code}    ${get_tongtienhang}    ${get_tiendatra_ncc}    ${get_giamgia_pn}    ${get_tongcong}    ${get_tongsoluong}
    ...    ${get_trangthai}

Delete purchase receipt code
    [Arguments]    ${input_pur_oder_code}
    [Timeout]    5 mins
    ${jsonpath_pur_order_id}    Format String    $..Data[?(@.Code=="{0}")].Id    ${input_pur_oder_code}
    ${endpoint_phieu_nhap_hang}    Format String    ${endpoint_phieu_nhap_hang}    ${BRANCH_ID}
    ${get_pur_oder_id}    Get data from API    ${endpoint_phieu_nhap_hang}    ${jsonpath_pur_order_id}
    ${endpoint_delete_pnh_by_id}    Format String    ${endpoint_delete_pnh}    ${get_pur_oder_id}
    Delete request thr API    ${endpoint_delete_pnh_by_id}

Import multi products
    [Arguments]    ${list_product_codes}    ${list_nums}    ${list_cost}    ${list_discount_type}    ${list_discount_value}    ${list_producttype}
    ...    ${list_all_imeis}    ${suppplier_code}
    [Documentation]    Nhập hàng với các loại hàng hóa khác nhau
    [Timeout]    5 mins
    ${list_product_ids}    Get list product id thr API    ${list_product_codes}
    ${list_imei}    Create List
    ${get_user_id}    Get User ID
    ${supplier_id}    Get Supplier Id    ${suppplier_code}
    ${liststring_prs_importproducts_detail}    Set Variable    needdel
    Log    ${liststring_prs_importproducts_detail}
    ${list_cost_af_discount}    Create list
    : FOR    ${item_product_code}    ${item_product_id}    ${item_num}    ${item_product_type}    ${item_cost}    ${item_discount_type}
    ...    ${item_discount_value}    ${item_imei}    IN ZIP    ${list_product_codes}    ${list_product_ids}    ${list_nums}
    ...    ${list_producttype}    ${list_cost}    ${list_discount_type}    ${list_discount_value}    ${list_all_imeis}
    \    ${item_cost_af_discount}=    Run Keyword If    ${item_discount_value} > 101    Minus    ${item_cost}    ${item_discount_value}
    \    ...    ELSE IF    0 < ${item_discount_value} < 100    Price after % discount product    ${item_cost}    ${item_discount_value}
    \    ...    ELSE    Set Variable    ${item_cost}
    \    ${item_discount}=    Run Keyword If    '${item_discount_type}' == 'VND'    Set Variable    ${item_discount_value}
    \    ...    ELSE    Convert % discount to VND and round    ${item_cost}    ${item_discount_value}
    \    ${discount_ratio}=    Run Keyword If    '${item_discount_type}' == 'VND'    Set Variable    null
    \    ...    ELSE    Set variable    ${item_discount_value}
    \    ${string_imei}=    Run Keyword If    '${item_imei}' == 'noneimei'    Set Variable    ${EMPTY}
    \    ...    ELSE    Set Variable    ${item_imei}
    \    ${payload_each_product}    Format string    {{"ProductId":{0},"ConversionValue":1,"Product":{{"Name":"chuột quang hồng","Code":"SIM001","IsLotSerialControl":true,"IsBatchExpireControl":false,"ProductShelvesStr":"","OnHand":212,"Reserved":0}},"ProductName":"chuột quang hồng","ProductCode":"SIM001","Description":"","Price":{3},"priceAfterDiscount":{5},"Quantity":{1},"ShowUnit":false,"ListProductUnit":[{{"Id":{0},"Unit":"","Code":"SIM001","Conversion":0,"MasterUnitId":0}}],"Units":[{{"Id":{0},"Unit":"","Code":"SIM001","Conversion":0,"MasterUnitId":0}}],"Unit":"","SelectedUnit":{0},"OnOrder":0,"ProductBatchExpires":[],"tabIndex":100,"ViewIndex":2,"TotalValue":800000,"Discount":{4},"tags":[{{"text":"AAAA"}},{{"text":"BBBB"}}],"SerialNumbers":"{2}","DiscountValue":0,"DiscountType":"{6}","DiscountRatio":{7},"Allocation":0,"AllocationSuppliers":0,"AllocationThirdParty":0,"OrderByNumber":1}}    ${item_product_id}    ${item_num}    ${string_imei}
    \    ...    ${item_cost}    ${item_discount}    ${item_cost_af_discount}    ${item_discount_type}    ${discount_ratio}
    \    Log    ${payload_each_product}
    \    ${liststring_prs_importproducts_detail}    Catenate    SEPARATOR=,    ${liststring_prs_importproducts_detail}    ${payload_each_product}
    \    Append To List    ${list_cost_af_discount}    ${item_cost_af_discount}
    ${liststring_prs_importproducts_detail}    Replace String    ${liststring_prs_importproducts_detail}    needdel,    ${EMPTY}    count=1
    ${data_str}    Format String    {{"PurchaseOrder":{{"PurchaseOrderDetails":[{0}],"UserId":{1},"CompareUserId":{1},"User":{{"id":{1},"username":"admin","givenName":"admin","Id":{1},"UserName":"admin","GivenName":"admin","IsAdmin":true,"IsLimitedByTrans":false,"IsShowSumRow":true,"Theme":""}},"Description":"","Supplier":{{"TotalInvoiced":0,"CompareCode":"NCC0043","CompareName":"NCC TH true milk","ComparePhone":"2321632514","Id":{2},"Name":"NCC TH true milk","Phone":"2321632514","RetailerId":294113,"Code":"NCC0043","CreatedDate":"2019-08-10T15:59:58.9600000+07:00","CreatedBy":{1},"LocationName":"","WardName":"","BranchId":{3},"isDeleted":false,"isActive":true,"SearchNumber":"2321632514","PurchaseOrders":[],"PurchaseReturns":[],"PurchasePayments":[],"SupplierGroupDetails":[],"OrderSuppliers":[]}},"SupplierId":{2},"CompareSupplierId":0,"SubTotal":995000,"Branch":{{"id":{3},"name":"Chi nhánh trung tâm","Id":{3},"Name":"Chi nhánh trung tâm","Address":"Shop test - 1B yết Kiêu","LocationName":"Hà Nội - Quận Hoàn Kiếm","WardName":"","ContactNumber":"","SubContactNumber":""}},"Status":1,"StatusValue":"Phiếu tạm","CompareStatusValue":"Phiếu tạm","Discount":0,"CompareDiscount":0,"DiscountRatio":0,"Id":0,"Account":{{}},"Total":995000,"TotalQuantity":6,"ExpensesOthersTitle":"","ExpensesOthersRtpTitle":"","PurchaseOrderExpensesOthers":[],"PurchaseOrderExpensesOthersRs":[],"PurchaseOrderExpensesOthersRtp":[],"ExReturnSuppliers":0,"ExReturnThirdParty":0,"PaidAmount":0,"PayingAmount":0,"ChangeAmount":-995000,"paymentMethod":"","BalanceDue":995000,"DepositReturn":995000,"OriginTotal":995000,"PricebookDetail":[],"paymentMethodObj":null,"paymentReturnType":0,"BranchId":{3}}},"PurchaseOrderLargeData":null,"Complete":true,"CopyFrom":0,"PricebookDetail":[],"IsFinalizedOS":false}}    ${liststring_prs_importproducts_detail}    ${get_user_id}    ${supplier_id}    ${BRANCH_ID}
    log    ${data_str}
    ${resp3.json()}   Post request thr API    /purchaseOrders    ${data_str}
    ${dict}    Set Variable    ${resp3.json()}
    ${purchase_code}    Get From Dictionary    ${dict}    Code
    Return From Keyword    ${list_cost_af_discount}    ${purchase_code}

Computation supply price allocation in purchase order
    [Arguments]    ${list_gianhap}    ${result_discount_vnd}    ${result_tongtienhang}
    ${list_price_allocate}    Create List
    ${list_discount_allocate}    Create List
    : FOR    ${item_price}    IN ZIP    ${list_gianhap}
    \    ${result_discount_allocate}    Price after apllocate discount    ${item_price}    ${result_tongtienhang}    ${result_discount_vnd}
    \    ${result_price_allocate}    Minus    ${item_price}    ${result_discount_allocate}
    \    ${result_price_allocate}    Evaluate    round(${result_price_allocate}, 2)
    \    Append To List    ${list_price_allocate}    ${result_price_allocate}
    \    Append To List    ${list_discount_allocate}    ${result_discount_allocate}
    Return From Keyword    ${list_price_allocate}    ${list_discount_allocate}

Add new purchase receipt thr API
    [Arguments]    ${input_supplier_code}    ${dict_product_num}    ${list_newprice}    ${input_discount}    ${input_cantrancc}
    ## Get info ton cuoi, cong no khach hang
    ${list_product}    Get Dictionary Keys    ${dict_product_num}
    ${list_nums}    Get Dictionary Values    ${dict_product_num}
    #create lists
    ${list_result_thanhtien}    create list
    ${list_result_onhand_af_ex}    create list
    #
    ${endpoint_danhmuc_hh_by_branch}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${get_list_prd_id}    Get list product id thr API    ${list_product}
    ${list_thanhtien}    Create List
    : FOR    ${item_newprice}    ${item_num}    IN ZIP    ${list_newprice}    ${list_nums}
    \    ${result_thanhtien}    Multiplication and round    ${item_newprice}    ${item_num}
    \    Append To List    ${list_thanhtien}    ${result_thanhtien}
    Log    ${list_thanhtien}
    #
    ${result_tongtienhang}    Sum values in list    ${list_thanhtien}
    ${result_discount_invoice}    Run Keyword If    0 <= ${input_discount} <= 100    Convert % discount to VND and round    ${result_tongtienhang}    ${input_discount}
    ...    ELSE    Set Variable    ${input_discount}
    ${result_cantrancc}    Minus    ${result_tongtienhang}    ${result_discount_invoice}
    ${actual_cantrancc}    Set Variable If    '${input_cantrancc}' == 'all'    ${result_cantrancc}    ${input_cantrancc}
    ## Tinh phan bo giam gia
    ${list_price_allocate}    ${list_discount_allocate}    Computation supply price allocation in purchase order    ${list_newprice}    ${result_discount_invoice}    ${result_tongtienhang}
    #
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${get_id_ncc}    Get Supplier Id    ${input_supplier_code}
    ${giamgia_hd}    Set Variable If    0 <= ${input_discount} <= 100    ${input_discount}    null
    ${result_gghd}    Run Keyword If    0 <= ${input_discount} <= 100    Convert % discount to VND    ${result_tongtienhang}    ${input_discount}
    ...    ELSE    Set Variable    ${input_discount}
    Set Test Variable    \${result_ggpn}     ${result_gghd}
    Set Test Variable    \${result_tongtienhang_nh}    ${result_tongtienhang}
    #
    ${list_status_imei}    Get list imei status thr API    ${list_product}
    # Post request BH
    ${ma_phieu}    Generate code automatically    PN
    ${liststring_prs_purchase_detail}    Set Variable    needdel
    Log    ${liststring_prs_purchase_detail}
    ${list_imei_all}    Create List
    : FOR    ${item_product_id}    ${item_num}    ${item_thanhtien}    ${item_newprice}    ${item_pr}    ${item_imei_status}    ${item_gg_pb}    IN ZIP    ${get_list_prd_id}    ${list_nums}    ${list_thanhtien}    ${list_newprice}
    ...    ${list_product}    ${list_status_imei}    ${list_discount_allocate}
    \    ${list_imei}    Run Keyword If    '${item_imei_status}'=='True'    Create list imei by generating random    ${item_num}
    \    ...    ELSE    Set Variable    ${EMPTY}
    \    ${list_imei}    Convert list to string and return    ${list_imei}
    \    ${payload_each_product}    Format string    {{"ProductId":{0},"ConversionValue":1,"Product":{{"Name":"Sản phẩm IMEI 2","Code":"{1}","IsLotSerialControl":true,"IsBatchExpireControl":false,"ProductShelvesStr":"","OnHand":1,"Reserved":0}},"ProductName":"Sản phẩm IMEI 2","ProductCode":"{1}","Description":"","Price":{2},"priceAfterDiscount":{2},"Quantity":{3},"ShowUnit":false,"ListProductUnit":[{{"Id":{0},"Unit":"","Code":"{1}","Conversion":0,"MasterUnitId":0}}],"Units":[{{"Id":{0},"Unit":"","Code":"{1}","Conversion":0,"MasterUnitId":0}}],"Unit":"","SelectedUnit":{0},"OnOrder":0,"ProductBatchExpires":[],"tabIndex":100,"ViewIndex":1,"TotalValue":{4},"Discount":0,"tags":[],"SerialNumbers":"{5}","DiscountValue":0,"DiscountType":"VND","DiscountRatio":null,"adjustedPrice":{2},"Allocation":{6},"AllocationSuppliers":0,"AllocationThirdParty":0,"OrderByNumber":0}}    ${item_product_id}    ${item_pr}    ${item_newprice}
    \    ...    ${item_num}    ${item_thanhtien}    ${list_imei}    ${item_gg_pb}
    \    Append To List    ${list_imei_all}    ${list_imei}
    \    ${liststring_prs_purchase_detail}    Catenate    SEPARATOR=,    ${liststring_prs_purchase_detail}    ${payload_each_product}
    ${liststring_prs_purchase_detail}    Replace String    ${liststring_prs_purchase_detail}    needdel,    ${EMPTY}    count=1
    ${request_payload}    Format String    {{"PurchaseOrder":{{"Code":"{0}","PurchaseOrderDetails":[{1}],"UserId":{2},"CompareUserId":{2},"User":{{"id":{2},"username":"admin","givenName":"admin","Id":{2},"UserName":"admin","GivenName":"admin","IsAdmin":true,"IsLimitedByTrans":false,"IsShowSumRow":true,"Theme":""}},"Description":"","Supplier":{{"TotalInvoiced":0,"CompareCode":"{3}","CompareName":"Hoa quả sạch tiki","ComparePhone":"0977654891","Id":{4},"Name":"Hoa quả sạch tiki","Phone":"0977654891","RetailerId":{11},"Code":"{3}","CreatedDate":"2019-05-25T15:49:07.3600000+07:00","CreatedBy":{2},"Debt":-3033563,"LocationName":"","WardName":"","BranchId":{5},"isDeleted":false,"isActive":true,"SearchNumber":"0977654891","PurchaseOrders":[],"PurchaseReturns":[],"PurchasePayments":[],"SupplierGroupDetails":[],"OrderSuppliers":[]}},"SupplierId":{4},"CompareSupplierId":0,"SubTotal":{6},"Branch":{{"id":{5},"name":"Chi nhánh trung tâm","Id":{5},"Name":"Chi nhánh trung tâm","Address":"abc","LocationName":"Hà Nội - Quận Cầu Giấy","WardName":"","ContactNumber":"","SubContactNumber":""}},"Status":1,"StatusValue":"Phiếu tạm","CompareStatusValue":"Phiếu tạm","Discount":{7},"CompareDiscount":0,"DiscountRatio":{8},"Id":0,"Account":{{}},"Total":{9},"TotalQuantity":2,"ExpensesOthersTitle":"","ExpensesOthersRtpTitle":"","PurchaseOrderExpensesOthers":[],"PurchaseOrderExpensesOthersRs":[],"PurchaseOrderExpensesOthersRtp":[],"ExReturnSuppliers":0,"ExReturnThirdParty":0,"PaidAmount":0,"PayingAmount":{10},"ChangeAmount":-50000,"paymentMethod":"","BalanceDue":80000,"DepositReturn":80000,"OriginTotal":80000,"PricebookDetail":[],"paymentMethodObj":null,"paymentReturnType":0,"DiscountRatioWoRound":{8},"DiscountWoRound":{7},"PurchasePayments":[{{"Amount":{10},"Method":"Cash"}}],"BranchId":{5}}},"PurchaseOrderLargeData":null,"Complete":true,"CopyFrom":0,"PricebookDetail":[],"IsFinalizedOS":false}}    ${ma_phieu}    ${liststring_prs_purchase_detail}    ${get_id_nguoiban}    ${input_supplier_code}
    ...    ${get_id_ncc}    ${BRANCH_ID}    ${result_tongtienhang}    ${result_gghd}    ${giamgia_hd}    ${result_cantrancc}
    ...    ${actual_cantrancc}    ${get_id_nguoitao}
    Log    ${request_payload}
    Post request thr API    /purchaseOrders    ${request_payload}
    Set Test Variable    \${list_imei_all}    ${list_imei_all}
    Return From Keyword    ${ma_phieu}

Add new purchase receipt no payment thr API
    [Arguments]    ${input_supplier_code}    ${dict_product_num}    ${list_newprice}    ${input_discount}
    ## Get info ton cuoi, cong no khach hang
    ${list_product}    Get Dictionary Keys    ${dict_product_num}
    ${list_nums}    Get Dictionary Values    ${dict_product_num}
    #create lists
    ${list_result_thanhtien}    create list
    ${list_result_onhand_af_ex}    create list
    #
    ${endpoint_danhmuc_hh_by_branch}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${get_list_prd_id}    Get list product id thr API    ${list_product}
    ${list_thanhtien}    Create List
    : FOR    ${item_newprice}    ${item_num}    IN ZIP    ${list_newprice}    ${list_nums}
    \    ${result_thanhtien}    Multiplication and round    ${item_newprice}    ${item_num}
    \    Append To List    ${list_thanhtien}    ${result_thanhtien}
    Log    ${list_thanhtien}
    #
    ${result_tongtienhang}    Sum values in list    ${list_thanhtien}
    ${result_discount_invoice}    Run Keyword If    0 <= ${input_discount} <= 100    Convert % discount to VND and round    ${result_tongtienhang}    ${input_discount}
    ...    ELSE    Set Variable    ${input_discount}
    ${result_cantrancc}    Minus    ${result_tongtienhang}    ${result_discount_invoice}
    ${actual_cantrancc}    Set Variable     0
    ## Tinh phan bo giam gia
    ${list_price_allocate}    ${list_discount_allocate}    Computation supply price allocation in purchase order    ${list_newprice}    ${result_discount_invoice}    ${result_tongtienhang}
    #
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${get_id_ncc}    Get Supplier Id    ${input_supplier_code}
    ${giamgia_hd}    Set Variable If    0 <= ${input_discount} <= 100    ${input_discount}    null
    ${result_gghd}    Run Keyword If    0 <= ${input_discount} <= 100    Convert % discount to VND    ${result_tongtienhang}    ${input_discount}
    ...    ELSE    Set Variable    ${input_discount}
    #
    ${list_status_imei}    Get list imei status thr API    ${list_product}
    # Post request BH
    ${ma_phieu}    Generate code automatically    PN
    ${liststring_prs_purchase_detail}    Set Variable    needdel
    Log    ${liststring_prs_purchase_detail}
    ${list_imei_all}    Create List
    : FOR    ${item_product_id}    ${item_num}    ${item_thanhtien}    ${item_newprice}    ${item_pr}    ${item_imei_status}
    ...    ${item_gg_pb}    IN ZIP    ${get_list_prd_id}    ${list_nums}    ${list_thanhtien}    ${list_newprice}
    ...    ${list_product}    ${list_status_imei}    ${list_discount_allocate}
    \    ${list_imei}    Run Keyword If    '${item_imei_status}'=='True'    Create list imei by generating random    ${item_num}
    \    ...    ELSE    Set Variable    ${EMPTY}
    \    ${list_imei}    Convert list to string and return    ${list_imei}
    \    ${payload_each_product}    Format string    {{"ProductId":{0},"ConversionValue":1,"Product":{{"Name":"Sản phẩm IMEI 2","Code":"{1}","IsLotSerialControl":true,"IsBatchExpireControl":false,"ProductShelvesStr":"","OnHand":1,"Reserved":0}},"ProductName":"Sản phẩm IMEI 2","ProductCode":"{1}","Description":"","Price":{2},"priceAfterDiscount":{2},"Quantity":{3},"ShowUnit":false,"ListProductUnit":[{{"Id":{0},"Unit":"","Code":"{1}","Conversion":0,"MasterUnitId":0}}],"Units":[{{"Id":{0},"Unit":"","Code":"{1}","Conversion":0,"MasterUnitId":0}}],"Unit":"","SelectedUnit":{0},"OnOrder":0,"ProductBatchExpires":[],"tabIndex":100,"ViewIndex":1,"TotalValue":{4},"Discount":0,"tags":[],"SerialNumbers":"{5}","DiscountValue":0,"DiscountType":"VND","DiscountRatio":null,"adjustedPrice":{2},"Allocation":{6},"AllocationSuppliers":0,"AllocationThirdParty":0,"OrderByNumber":0}}    ${item_product_id}    ${item_pr}    ${item_newprice}
    \    ...    ${item_num}    ${item_thanhtien}    ${list_imei}    ${item_gg_pb}
    \    Append To List    ${list_imei_all}    ${list_imei}
    \    ${liststring_prs_purchase_detail}    Catenate    SEPARATOR=,    ${liststring_prs_purchase_detail}    ${payload_each_product}
    ${liststring_prs_purchase_detail}    Replace String    ${liststring_prs_purchase_detail}    needdel,    ${EMPTY}    count=1
    ${request_payload}    Format String    {{"PurchaseOrder":{{"Code":"{0}","PurchaseOrderDetails":[{1}],"UserId":{2},"CompareUserId":{2},"User":{{"id":{2},"username":"admin","givenName":"admin","Id":{2},"UserName":"admin","GivenName":"admin","IsAdmin":true,"IsLimitedByTrans":false,"IsShowSumRow":true,"Theme":""}},"Description":"","Supplier":{{"TotalInvoiced":0,"CompareCode":"{3}","CompareName":"Hoa quả sạch tiki","ComparePhone":"0977654891","Id":{4},"Name":"Hoa quả sạch tiki","Phone":"0977654891","RetailerId":{11},"Code":"{3}","CreatedDate":"2019-05-25T15:49:07.3600000+07:00","CreatedBy":{2},"Debt":-3033563,"LocationName":"","WardName":"","BranchId":{5},"isDeleted":false,"isActive":true,"SearchNumber":"0977654891","PurchaseOrders":[],"PurchaseReturns":[],"PurchasePayments":[],"SupplierGroupDetails":[],"OrderSuppliers":[]}},"SupplierId":{4},"CompareSupplierId":0,"SubTotal":{6},"Branch":{{"id":{5},"name":"Chi nhánh trung tâm","Id":{5},"Name":"Chi nhánh trung tâm","Address":"abc","LocationName":"Hà Nội - Quận Cầu Giấy","WardName":"","ContactNumber":"","SubContactNumber":""}},"Status":1,"StatusValue":"Phiếu tạm","CompareStatusValue":"Phiếu tạm","Discount":{7},"CompareDiscount":0,"DiscountRatio":{8},"Id":0,"Account":{{}},"Total":{9},"TotalQuantity":2,"ExpensesOthersTitle":"","ExpensesOthersRtpTitle":"","PurchaseOrderExpensesOthers":[],"PurchaseOrderExpensesOthersRs":[],"PurchaseOrderExpensesOthersRtp":[],"ExReturnSuppliers":0,"ExReturnThirdParty":0,"PaidAmount":0,"PayingAmount":{10},"ChangeAmount":-50000,"paymentMethod":"","BalanceDue":80000,"DepositReturn":80000,"OriginTotal":80000,"PricebookDetail":[],"paymentMethodObj":null,"paymentReturnType":0,"DiscountRatioWoRound":{8},"DiscountWoRound":{7},"BranchId":{5}}},"PurchaseOrderLargeData":null,"Complete":true,"CopyFrom":0,"PricebookDetail":[],"IsFinalizedOS":false}}    ${ma_phieu}    ${liststring_prs_purchase_detail}    ${get_id_nguoiban}    ${input_supplier_code}
    ...    ${get_id_ncc}    ${BRANCH_ID}    ${result_tongtienhang}    ${result_gghd}    ${giamgia_hd}    ${result_cantrancc}
    ...    ${actual_cantrancc}    ${get_id_nguoitao}
    Log    ${request_payload}
    Post request thr API    /purchaseOrders    ${request_payload}
    Set Test Variable    \${list_imei_all}    ${list_imei_all}
    Return From Keyword    ${ma_phieu}

Get sub total - discount purchase receipt by purchase receipt code
    [Arguments]    ${input_ma_phieunhap}
    [Timeout]    5 mins
    ${jsonpath_tongtienhang}    Format String    $.Data[?(@.Code== '{0}')].SubTotal    ${input_ma_phieunhap}
    ${jsonpath_discount}    Format String    $.Data[?(@.Code== '{0}')].Discount    ${input_ma_phieunhap}
    ${endpoint_phieu_nhap_hang}    Format String    ${endpoint_phieu_nhap_hang}    ${BRANCH_ID}
    ${resp.pnh}    Get Request and return body    ${endpoint_phieu_nhap_hang}
    ${get_tongtienhang}    Get data from response json    ${resp.pnh}    ${jsonpath_tongtienhang}
    ${get_ggpn}    Get data from response json    ${resp.pnh}    ${jsonpath_discount}
    Return From Keyword    ${get_tongtienhang}    ${get_ggpn}

Get purchase receipt id thr API
    [Arguments]    ${ma_pn}
    [Timeout]    3 mins
    ${jsonpath_ma_pn_id}    Format String    $..Data[?(@.Code=="{0}")].Id    ${ma_pn}
    ${endpoint_phieu_nhap_hang}    Format String    ${endpoint_phieu_nhap_hang}    ${BRANCH_ID}
    ${get_ma_pn_id}    Get data from API    ${endpoint_phieu_nhap_hang}    ${jsonpath_ma_pn_id}
    Return From Keyword    ${get_ma_pn_id}

Get list supply price of product by purchase reciept code
    [Arguments]    ${receipt_code}    ${list_prs}
    [Timeout]    3 mins
    ${get_id_pn}    Get purchase receipt id thr API    ${receipt_code}
    ${endpoint_chitietpn}    Format String    ${endpoint_chitiet_phieunhap}    ${get_id_pn}
    ${resp}    Get Request and return body    ${endpoint_chitietpn}
    ${list_price_af_discount}    Create List
    : FOR    ${item_pr}    IN ZIP    ${list_prs}
    \    ${jsonpath_gianhap}    Format String    $..PurchaseOrderDetails[?(@.ProductCode=="{0}")].Price    ${item_pr}
    \    ${jsonpath_gg}    Format String    $..PurchaseOrderDetails[?(@.ProductCode=="{0}")].Discount    ${item_pr}
    \    ${get_gianhap}    Get data from response json    ${resp}    ${jsonpath_gianhap}
    \    ${get_giamgia}    Get data from response json    ${resp}    ${jsonpath_gg}
    \    ${result_price_af_discount}    Minus and round 2    ${get_gianhap}    ${get_giamgia}
    \    Append To List    ${list_price_af_discount}    ${result_price_af_discount}
    Return From Keyword    ${list_price_af_discount}

Get list product order detail id in purchase receipt thr API
    [Arguments]    ${list_prs}    ${ma_pn}
    ${get_pur_oder_id}    Get purchase receipt id thr API    ${ma_pn}
    ${endpoint_chitiet_pn}    Format String    ${endpoint_chitiet_phieunhap}    ${get_pur_oder_id}
    ${resp}    Get Request and return body    ${endpoint_chitiet_pn}
    ${list_id_sp_order}    Create List
    : FOR    ${item_pr}    IN ZIP    ${list_prs}
    \    ${jsonpath_id_sp}    Format String    $..PurchaseOrderDetails[?(@.ProductCode=="{0}")].Id    ${item_pr}
    \    ${get_id_sp_order}    Get data from response json    ${resp}    ${jsonpath_id_sp}
    \    Append To List    ${list_id_sp_order}    ${get_id_sp_order}
    Return From Keyword    ${list_id_sp_order}

Import multi lot for product
    [Arguments]    ${product_id}    ${list_nums}    ${list_tenlo}    ${gianhap}    ${user_id}
    ${liststring_lodate}    Set Variable    needdel
    ${get_current_date}    Get Current Date
    ${hsd}    Add Time To Date    ${get_current_date}    30 days
    ${id_lo}    Set Variable    -2
    : FOR    ${item_num}    ${item_tenlo}    IN ZIP    ${list_nums}    ${list_tenlo}
    \    ${id_lo}    Sum    ${id_lo}    1
    \    ${id_lo}    Replace floating point    ${id_lo}
    \    ${payload_lo}    Format String    {{"Id":{0},"BatchName":"{1}","FullNameVirgule":"","ExpireDate":"{2}","DisplayType":1,"Status":2,"IsUpdate":1,"OnHand":{3},"SystemCount":0}}    ${id_lo}    ${item_tenlo}    ${hsd}
    \    ...    ${item_num}
    \    ${liststring_lodate}    Catenate    SEPARATOR=,    ${liststring_lodate}    ${payload_lo}
    ${liststring_lodate}    Replace String    ${liststring_lodate}    needdel,    ${EMPTY}    count=1
    ${data_str}    Format String    {{"PurchaseOrder":{{"PurchaseOrderDetails":[{{"ProductId":{0},"ConversionValue":1,"Product":{{"Name":"abc","Code":"SP000027","IsLotSerialControl":false,"IsBatchExpireControl":true,"ProductShelvesStr":"","OnHand":18.9,"Reserved":0}},"ProductName":"abc","ProductCode":"SP000027","Description":"","Price":{1},"priceAfterDiscount":0,"Quantity":4,"ShowUnit":false,"ListProductUnit":[{{"Id":{0},"Unit":"","Code":"SP000027","Conversion":0,"MasterUnitId":0}}],"Units":[{{"Id":{0},"Unit":"","Code":"SP000027","Conversion":0,"MasterUnitId":0}}],"Unit":"","SelectedUnit":{0},"OnOrder":0,"ProductBatchExpires":[],"ListProductSerialHavingTrans":[],"ListProductBatchExpireHavingTrans":[],"tabIndex":100,"ViewIndex":1,"TotalValue":0,"Discount":0,"Allocation":0,"AllocationSuppliers":0,"AllocationThirdParty":0,"ProductBatchExpireList":[{2}],"DiscountValue":0,"DiscountType":"VND","DiscountRatio":null,"adjustedPrice":0,"OrderByNumber":0}}],"UserId":{3},"CompareUserId":{3},"User":{{"id":{3},"username":"admin","givenName":"admin","Id":{3},"UserName":"admin","GivenName":"admin","IsAdmin":true,"IsLimitedByTrans":false,"IsShowSumRow":true,"Theme":""}},"Description":"","CompareSupplierId":0,"SubTotal":0,"Branch":{{"id":{4},"name":"Chi nhánh trung tâm","Id":{4},"Name":"Chi nhánh trung tâm","Address":"hà nội","LocationName":"Hà Nội - Quận Ba Đình","WardName":"","ContactNumber":"","SubContactNumber":""}},"Status":1,"StatusValue":"Phiếu tạm","CompareStatusValue":"Phiếu tạm","Discount":0,"CompareDiscount":0,"DiscountRatio":0,"Id":0,"UpdatePurchaseId":0,"Account":{{}},"Total":0,"TotalQuantity":4,"ExpensesOthersTitle":"","ExpensesOthersRtpTitle":"","PurchaseOrderExpensesOthers":[],"PurchaseOrderExpensesOthersRs":[],"PurchaseOrderExpensesOthersRtp":[],"ExReturnSuppliers":0,"ExReturnThirdParty":0,"PaidAmount":0,"PayingAmount":0,"ChangeAmount":0,"paymentMethod":"","BalanceDue":0,"DepositReturn":0,"OriginTotal":0,"PricebookDetail":[],"paymentMethodObj":null,"paymentReturnType":0,"BranchId":{4}}},"PurchaseOrderLargeData":null,"Complete":true,"CopyFrom":0,"PricebookDetail":[],"IsFinalizedOS":false}}    ${product_id}    ${gianhap}    ${liststring_lodate}    ${user_id}
    ...    ${BRANCH_ID}
    Log    ${data_str}
    Post request thr API    /purchaseOrders    ${data_str}

Import multi lot for product and get list lots
    [Arguments]    ${input_ma_sp}    ${list_nums}
    [Timeout]    5 mins
    ${endpoint_danhmuc_hh_co_dvt}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${resp}    Get Request and return body    ${endpoint_danhmuc_hh_co_dvt}
    ${jsonpath_id_sp}    Format String    $.Data[?(@.Code == '{0}')].Id    ${input_ma_sp}
    ${jsonpath_giavon}    Format String    $.Data[?(@.Code == '{0}')].Cost    ${input_ma_sp}
    ${get_id_sp}    Get data from response json    ${resp}    ${jsonpath_id_sp}
    ${get_giavon}    Get data from response json    ${resp}    ${jsonpath_giavon}
    ${list_tenlo}    Create List
    : FOR    ${item_num}    IN ZIP    ${list_nums}
    \    ${list_tenlo}    Create lot name list by generatin random    ${list_tenlo}
    Log    ${list_tenlo}
    ${get_user_id}    Get User ID
    Wait Until Keyword Succeeds    3 times    10s    Import multi lot for product    ${get_id_sp}    ${list_nums}    ${list_tenlo}
    ...    ${get_giavon}    ${get_user_id}
    Return From Keyword    ${list_tenlo}

Create json for product batch expire list
    [Arguments]    ${list_nums}    ${list_tenlo}
    ${liststring_lodate}    Set Variable    needdel
    ${get_current_date}    Get Current Date
    ${hsd}    Add Time To Date    ${get_current_date}    30 days
    ${list_nums}    Convert string to list    ${list_nums}
    ${list_tenlo}    Convert String to List    ${list_tenlo}
    ${id_lo}    Set Variable    -2
    : FOR    ${item_num}    ${item_tenlo}    IN ZIP    ${list_nums}    ${list_tenlo}
    \    ${id_lo}    Sum    ${id_lo}    1
    \    ${id_lo}    Replace floating point    ${id_lo}
    \    ${payload_lo}    Format String    {{"Id":{0},"BatchName":"{1}","FullNameVirgule":"","ExpireDate":"{2}","DisplayType":1,"Status":2,"IsUpdate":1,"OnHand":{3},"SystemCount":0}}    ${id_lo}    ${item_tenlo}    ${hsd}
    \    ...    ${item_num}
    \    ${liststring_lodate}    Catenate    SEPARATOR=,    ${liststring_lodate}    ${payload_lo}
    ${liststring_lodate}    Replace String    ${liststring_lodate}    needdel,    ${EMPTY}    count=1
    Return From Keyword    ${liststring_lodate}

Add new purchase receipt without supplier
    [Arguments]    ${dict_product_num}
    ## Get info ton cuoi, cong no khach hang
    ${list_product}    Get Dictionary Keys    ${dict_product_num}
    ${list_nums}    Get Dictionary Values    ${dict_product_num}
    ${endpoint_danhmuc_hh_by_branch}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${get_list_prd_id}    Get list product id thr API    ${list_product}
    ${get_list_baseprice}    Get list of Baseprice by Product Code    ${list_product}
    #create lists
    ${list_result_thanhtien}    create list
    ${list_thanhtien}    Create List
    : FOR    ${item_giaban}    ${item_num}    IN ZIP    ${get_list_baseprice}    ${list_nums}
    \    ${result_thanhtien}    Multiplication and round    ${item_giaban}    ${item_num}
    \    Append To List    ${list_thanhtien}    ${result_thanhtien}
    Log    ${list_thanhtien}
    ${result_tongtienhang}    Sum values in list    ${list_thanhtien}
    #
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${list_status_imei}    Get list imei status thr API    ${list_product}
    # Post request BH
    ${ma_phieu}    Generate code automatically    PN
    ${liststring_prs_purchase_detail}    Set Variable    needdel
    Log    ${liststring_prs_purchase_detail}
    ${list_imei_all}    Create List
    : FOR    ${item_product_id}    ${item_num}    ${item_thanhtien}    ${item_newprice}    ${item_pr}    ${item_imei_status}
    ...    IN ZIP    ${get_list_prd_id}    ${list_nums}    ${list_thanhtien}    ${get_list_baseprice}    ${list_product}
    ...    ${list_status_imei}
    \    ${list_imei}    Run Keyword If    '${item_imei_status}'=='True'    Create list imei by generating random    ${item_num}
    \    ...    ELSE    Set Variable    ${EMPTY}
    \    ${list_imei}    Convert list to string and return    ${list_imei}
    \    ${payload_each_product}    Format string    {{"ProductId":{0},"ConversionValue":1,"Product":{{"Name":"Sản phẩm IMEI 2","Code":"{1}","IsLotSerialControl":true,"IsBatchExpireControl":false,"ProductShelvesStr":"","OnHand":1,"Reserved":0}},"ProductName":"Sản phẩm IMEI 2","ProductCode":"{1}","Description":"","Price":{2},"priceAfterDiscount":{2},"Quantity":{3},"ShowUnit":false,"ListProductUnit":[{{"Id":{0},"Unit":"","Code":"{1}","Conversion":0,"MasterUnitId":0}}],"Units":[{{"Id":{0},"Unit":"","Code":"{1}","Conversion":0,"MasterUnitId":0}}],"Unit":"","SelectedUnit":{0},"OnOrder":0,"ProductBatchExpires":[],"tabIndex":100,"ViewIndex":1,"TotalValue":{4},"Discount":0,"tags":[],"SerialNumbers":"{5}","DiscountValue":0,"DiscountType":"VND","DiscountRatio":null,"adjustedPrice":{2},"Allocation":0,"AllocationSuppliers":0,"AllocationThirdParty":0,"OrderByNumber":0}}    ${item_product_id}    ${item_pr}    ${item_newprice}
    \    ...    ${item_num}    ${item_thanhtien}    ${list_imei}
    \    Append To List    ${list_imei_all}    ${list_imei}
    \    ${liststring_prs_purchase_detail}    Catenate    SEPARATOR=,    ${liststring_prs_purchase_detail}    ${payload_each_product}
    ${liststring_prs_purchase_detail}    Replace String    ${liststring_prs_purchase_detail}    needdel,    ${EMPTY}    count=1
    ${request_payload}    Format String    {{"PurchaseOrder":{{"Code":"{0}","PurchaseOrderDetails":[{1}],"UserId":{2},"CompareUserId":{2},"User":{{"id":{2},"username":"admin","givenName":"anh.lv","Id":{2},"UserName":"admin","GivenName":"anh.lv","IsAdmin":true,"IsLimitedByTrans":false,"IsShowSumRow":true,"Theme":""}},"Description":"","CompareSupplierId":0,"SubTotal":{3},"Branch":{{"id":{4},"name":"Chi nhánh trung tâm","Id":{4},"Name":"Chi nhánh trung tâm","Address":"1B Yết Kiêu","LocationName":"Hà Nội - Quận Hoàn Kiếm","WardName":"","ContactNumber":"","SubContactNumber":""}},"Status":1,"StatusValue":"Phiếu tạm","CompareStatusValue":"Phiếu tạm","Discount":0,"CompareDiscount":0,"DiscountRatio":0,"Id":0,"UpdatePurchaseId":0,"Account":{{}},"Total":{3},"TotalQuantity":10,"ExpensesOthersTitle":"","ExpensesOthersRtpTitle":"","PurchaseOrderExpensesOthers":[],"PurchaseOrderExpensesOthersRs":[],"PurchaseOrderExpensesOthersRtp":[],"ExReturnSuppliers":0,"ExReturnThirdParty":0,"PaidAmount":0,"PayingAmount":0,"ChangeAmount":-900000,"paymentMethod":"","BalanceDue":900000,"DepositReturn":900000,"OriginTotal":900000,"PricebookDetail":[],"paymentMethodObj":null,"paymentReturnType":0,"BranchId":{4}}},"PurchaseOrderLargeData":null,"Complete":true,"CopyFrom":0,"PricebookDetail":[],"IsFinalizedOS":false}}    ${ma_phieu}    ${liststring_prs_purchase_detail}    ${get_id_nguoiban}    ${result_tongtienhang}
    ...    ${BRANCH_ID}
    Log    ${request_payload}
    Post request thr API    /purchaseOrders    ${request_payload}
    Set Test Variable    \${list_imei_all}    ${list_imei_all}
    Return From Keyword    ${ma_phieu}

Create json for sub item product imei
    [Arguments]    ${input_pr_id}    ${list_num}    ${list_newprice}    ${list_discount}     ${list_imei}
    ...    ${list_result_giamgia}    ${list_result_thanh_tien}    ${list_result_newprice_af}    ${result_gg_pn}    ${result_tongtienhang}
    ${liststring_prs}    Set Variable    needdel
    Log    ${liststring_prs}
    : FOR    ${item_num}    ${item_newprice}    ${item_discount}     ${item_imei}
    ...     ${item_result_giamgia}    ${item_result_thanhtien}    ${item_result_giamoi}    IN ZIP    ${list_num}
    ...    ${list_newprice}    ${list_discount}      ${list_imei}      ${list_result_giamgia}
    ...    ${list_result_thanh_tien}    ${list_result_newprice_af}
    \    ${item_imei}   Replace sq blackets    ${item_imei}
    \    ${item_discount_type}    Set Variable If    ${item_discount}>100    null    ${item_discount}
    \    ${item_giamgia_pb}    Price after apllocate discount    ${item_result_giamoi}    ${result_tongtienhang}    ${result_gg_pn}
    \    ${payload_each_product}    Format String    {{"ProductId":{0},"ConversionValue":1,"Product":{{"Name":"Bàn phím cơ fuhlen","Code":"GHIM03","IsLotSerialControl":true,"IsBatchExpireControl":false,"OnHand":1,"Reserved":0}},"Description":"","Price":{1},"priceAfterDiscount":{2},"Quantity":{3},"MasterProductId":{0},"Id":1,"ProductBatchExpires":[],"ShowUnit":false,"ListProductUnit":[],"Units":[],"Unit":"","SelectedUnit":{0},"OnOrder":0,"ListProductSerialHavingTrans":[],"ListProductBatchExpireHavingTrans":[],"subIndex":0,"tabIndex":100,"ViewIndex":2,"tags":[],"SerialNumbers":"{4}","Discount":{5},"DiscountRatio":{6},"OriginPrice":{1},"TotalValue":{7},"Allocation":{8},"AllocationSuppliers":0,"AllocationThirdParty":0}}    ${input_pr_id}    ${item_newprice}    ${item_result_giamoi}
    \    ...    ${item_num}    ${item_imei}    ${item_result_giamgia}    ${item_discount_type}    ${item_result_thanhtien}
    \    ...    ${item_giamgia_pb}
    \    ${liststring_prs}    Catenate    SEPARATOR=,    ${liststring_prs}    ${payload_each_product}
    ${liststring_prs}    Replace String    ${liststring_prs}    needdel,    ${EMPTY}    count=1
    Return From Keyword    ${liststring_prs}

Create json for sub item product
    [Arguments]    ${input_pr_id}    ${list_num}    ${list_newprice}    ${list_discount}
    ...    ${list_result_giamgia}    ${list_result_thanh_tien}    ${list_result_newprice_af}    ${result_gg_pn}    ${result_tongtienhang}
    ${liststring_prs}    Set Variable    needdel
    Log    ${liststring_prs}
    : FOR    ${item_num}    ${item_newprice}    ${item_discount}
    ...     ${item_result_giamgia}    ${item_result_thanhtien}    ${item_result_giamoi}    IN ZIP    ${list_num}
    ...    ${list_newprice}    ${list_discount}       ${list_result_giamgia}
    ...    ${list_result_thanh_tien}    ${list_result_newprice_af}
    \    ${item_discount_type}    Set Variable If    ${item_discount}>100    null    ${item_discount}
    \    ${item_giamgia_pb}    Price after apllocate discount    ${item_result_giamoi}    ${result_tongtienhang}    ${result_gg_pn}
    \    ${payload_each_product}    Format String    {{"ProductId":{0},"ConversionValue":1,"Product":{{"Name":"Bàn phím cơ fuhlen","Code":"GHIM03","IsLotSerialControl":true,"IsBatchExpireControl":false,"OnHand":1,"Reserved":0}},"Description":"","Price":{1},"priceAfterDiscount":{2},"Quantity":{3},"MasterProductId":{0},"Id":1,"ProductBatchExpires":[],"ShowUnit":false,"ListProductUnit":[],"Units":[],"Unit":"","SelectedUnit":{0},"OnOrder":0,"ListProductSerialHavingTrans":[],"ListProductBatchExpireHavingTrans":[],"subIndex":0,"tabIndex":100,"ViewIndex":2,"tags":[],"SerialNumbers":"{4}","Discount":{5},"DiscountRatio":{6},"OriginPrice":{1},"TotalValue":{7},"Allocation":{8},"AllocationSuppliers":0,"AllocationThirdParty":0}}    ${input_pr_id}    ${item_newprice}    ${item_result_giamoi}
    \    ...    ${item_num}    ${EMPTY}    ${item_result_giamgia}    ${item_discount_type}    ${item_result_thanhtien}
    \    ...    ${item_giamgia_pb}
    \    ${liststring_prs}    Catenate    SEPARATOR=,    ${liststring_prs}    ${payload_each_product}
    ${liststring_prs}    Replace String    ${liststring_prs}    needdel,    ${EMPTY}    count=1
    Return From Keyword    ${liststring_prs}

Add new purchase receipt in case multi row thr API
    [Arguments]    ${input_supplier_code}    ${list_product}    ${list_num}    ${list_newprice}    ${list_discount}    ${input_nh_discount}
    ...    ${input_tientrancc}
    Set Selenium Speed    0.1
    ${import_code}    Generate code automatically    PNH
    # get dvcb cua sp
    ${list_pr_cb}    Get list code basic of product unit    ${list_product}
    #
    ${list_result_thanhtien_af}    ${list_result_newprice_af}    ${list_result_onhand_cb_af}    ${list_actual_num_cb}    ${list_result_giamgia}    ${list_result_thanh_tien}    Get list of total purchase receipt - result onhand actual product in case of multi row product
    ...    ${list_pr_cb}    ${list_product}    ${list_num}    ${list_newprice}    ${list_discount}
    ${result_tongtienhang}    Sum values in list    ${list_result_thanhtien_af}
    ${get_list_imei_status}    Get list imei status thr API    ${list_product}
    #
    ${list_imei}    create list
    : FOR    ${item_product}    ${item_num}    ${item_status}    IN ZIP    ${list_product}    ${list_num}
    ...    ${get_list_imei_status}
    \    ${item_num}    Split String    ${item_num}    ,
    \    ${imei_by_product}    Run Keyword If    '${item_status}'=='True'    Generate list imei by receipt multi row    ${item_num}
    \    ...    ELSE    Set Variable    ${EMPTY}
    \    Append To List    ${list_imei}    ${imei_by_product}
    Log    ${list_imei}
    Set Test Variable    \${list_imei_all}    ${list_imei}
    Set Test Variable    \${list_nh_result_newprice}    ${list_result_newprice_af}
    Set Test Variable    \${result_tongtienhang_nh}    ${result_tongtienhang}
    #
    ${result_discount_nh}    Run Keyword If    0 < ${input_nh_discount} < 100    Convert % discount to VND and round    ${result_tongtienhang}    ${input_nh_discount}
    ...    ELSE    Set Variable    ${input_nh_discount}
    ${discount_type}    Set Variable If    0 <= ${input_nh_discount} <= 100    ${input_nh_discount}    null
    ${result_cantrancc}    Minus    ${result_tongtienhang}    ${result_discount_nh}
    Set Test Variable    \${result_ggpn}    ${result_discount_nh}
    # tinh toan gia von sau khi nhap hang
    ${actual_tientrancc}    Set Variable If    '${input_tientrancc}'=='all'    ${result_cantrancc}    ${input_tientrancc}
    ${actual_tientrancc}    Run Keyword If    '${input_tientrancc}'=='all'    Replace floating point    ${actual_tientrancc}
    ...    ELSE    Set Variable    ${input_tientrancc}
    #
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${get_id_ncc}    Get Supplier Id    ${input_supplier_code}
    ${get_list_pr_id}    Get list product id thr API    ${list_product}
    #
    ${liststring_prs_purchase_detail}    Set Variable    needdel
    Log    ${liststring_prs_purchase_detail}
    : FOR    ${item_product}    ${item_num}    ${item_newprice}    ${item_discount}    ${item_status}    ${item_list_imei}
    ...    ${item_pr_id}     ${item_result_giamgia}    ${item_result_thanhtien}    ${item_result_giamoi}    IN ZIP
    ...    ${list_product}    ${list_num}    ${list_newprice}    ${list_discount}    ${get_list_imei_status}    ${list_imei}
    ...    ${get_list_pr_id}    ${list_result_giamgia}    ${list_result_thanh_tien}    ${list_result_newprice_af}
    \    ${item_num}    Convert String to List    ${item_num}
    \    ${item_newprice}    Convert String to List    ${item_newprice}
    \    ${item_discount}    Convert String to List    ${item_discount}
    \    ${item_num_first}    Remove From List    ${item_num}    0
    \    ${item_newprice_first}    Remove From List    ${item_newprice}    0
    \    ${item_discount_first}    Remove From List    ${item_discount}    0
    \    ${item_result_giamoi_copy}    Copy List    ${item_result_giamoi}
    \    ${item_result_giamoi_first}    Remove From List    ${item_result_giamoi_copy}    0
    \    ${item_result_thanhtien_first}    Remove From List    ${item_result_thanhtien}    0
    \    ${item_result_giamgia_first}    Remove From List    ${item_result_giamgia}    0
    \    ${item_discount_first_type}    Set Variable If    ${item_discount_first}>100    null    ${item_discount_first}
    \    ${item_list_imei_copy}    Copy List    ${item_list_imei}
    \    ${item_imei_first}   Run Keyword If      ${item_status}==0     Set Variable    ${EMPTY}    ELSE    Remove From List    ${item_list_imei_copy}    0
    \    ${item_imei_first}   Run Keyword If      ${item_status}==0     Set Variable    ${EMPTY}    ELSE    Replace sq blackets    ${item_imei_first}
    \    ${item_giamgia_pb_first}    Price after apllocate discount    ${item_result_giamoi_first}    ${result_tongtienhang}    ${result_discount_nh}
    \    ${payload_sub_item}    Run Keyword If      ${item_status}==0    Create json for sub item product    ${item_pr_id}    ${item_num}    ${item_newprice}    ${item_discount}
    \    ...      ${item_result_giamgia}    ${item_result_thanhtien}    ${item_result_giamoi_copy}
    \    ...    ${result_discount_nh}    ${result_tongtienhang}     ELSE    Create json for sub item product imei    ${item_pr_id}    ${item_num}    ${item_newprice}    ${item_discount}
    \    ...    ${item_list_imei_copy}    ${item_result_giamgia}    ${item_result_thanhtien}    ${item_result_giamoi_copy}
    \    ...    ${result_discount_nh}    ${result_tongtienhang}
    \    ${payload_each_product}    Format String    {{"ProductId":{0},"ConversionValue":1,"Product":{{"Name":"chuột quang xám","Code":"DNS008","IsLotSerialControl":true,"IsBatchExpireControl":false,"OnHand":470,"Reserved":0}},"ProductName":"chuột quang xám","ProductCode":"DNS008","Description":"","Price":{1},"priceAfterDiscount":{2},"Quantity":{3},"ShowUnit":false,"ListProductUnit":[{{"Id":{0},"Unit":"","Code":"DNS008","Conversion":0,"MasterUnitId":0,"PriceChanged":{1}}}],"Units":[{{"Id":{0},"Unit":"","Code":"DNS008","Conversion":0,"MasterUnitId":0}}],"Unit":"","SelectedUnit":{0},"OnOrder":77,"ProductBatchExpires":[],"ListProductSerialHavingTrans":[],"ListProductBatchExpireHavingTrans":[],"tabIndex":100,"ViewIndex":2,"TotalValue":{4},"Discount":{5},"SerialNumbers":"{6}","allSuggestSerial":[],"subItems":[{9}],"tags":[],"DiscountValue":0,"DiscountType":"VND","DiscountRatio":{7},"adjustedPrice":{1},"OriginPrice":{1},"Allocation":{8},"AllocationSuppliers":0,"AllocationThirdParty":0,"OrderByNumber":1}}    ${item_pr_id}    ${item_newprice_first}    ${item_result_giamoi_first}
    \    ...    ${item_num_first}    ${item_result_thanhtien_first}    ${item_result_giamgia_first}    ${item_imei_first}    ${item_discount_first_type}
    \    ...    ${item_giamgia_pb_first}    ${payload_sub_item}
    \    ${liststring_prs_purchase_detail}    Catenate    SEPARATOR=,    ${liststring_prs_purchase_detail}    ${payload_each_product}
    ${liststring_prs_purchase_detail}    Replace String    ${liststring_prs_purchase_detail}    needdel,    ${EMPTY}    count=1
    #
    ${request_payload}    Format String    {{"PurchaseOrder":{{"Code":"{0}","PurchaseOrderDetails":[{1}],"UserId":{2},"CompareUserId":{2},"User":{{"id":{2},"username":"admin","givenName":"anh.lv","Id":{2},"UserName":"admin","GivenName":"anh.lv","IsAdmin":true,"IsLimitedByTrans":false,"IsShowSumRow":true,"Theme":""}},"Description":"","Supplier":{{"IdOld":0,"TotalInvoiced":0,"CompareCode":"NCC0001","CompareName":"Rau sạch vietgab","ComparePhone":"0977654890","Id":{3},"Name":"Rau sạch vietgab","Phone":"0977654890","RetailerId":{4},"Code":"NCC0001","CreatedDate":"","CreatedBy":{2},"Debt":2452101,"LocationName":"","WardName":"","BranchId":{5},"isDeleted":false,"isActive":true,"SearchNumber":"0977654890","PurchaseOrders":[],"PurchaseReturns":[],"PurchasePayments":[],"SupplierGroupDetails":[],"OrderSuppliers":[]}},"SupplierId":{3},"CompareSupplierId":0,"SubTotal":{6},"Branch":{{"id":{5},"name":"Chi nhánh trung tâm","Id":{5},"Name":"Chi nhánh trung tâm","Address":"Hòa An","LocationName":"Đà Nẵng - Quận Cẩm Lệ","WardName":"","ContactNumber":"","SubContactNumber":""}},"Status":1,"StatusValue":"Phiếu tạm","CompareStatusValue":"Phiếu tạm","Discount":{7},"CompareDiscount":0,"DiscountRatio":{8},"Id":0,"UpdatePurchaseId":0,"Account":{{}},"Total":{9},"TotalQuantity":11,"ExpensesOthersTitle":"","ExpensesOthersRtpTitle":"","PurchaseOrderExpensesOthers":[],"PurchaseOrderExpensesOthersRs":[],"PurchaseOrderExpensesOthersRtp":[],"ExReturnSuppliers":0,"ExReturnThirdParty":0,"PaidAmount":0,"PayingAmount":{10},"ChangeAmount":-339096,"paymentMethod":"","BalanceDue":389096,"DepositReturn":389096,"OriginTotal":389096,"PricebookDetail":[],"paymentMethodObj":null,"paymentReturnType":0,"DiscountRatioWoRound":20,"DiscountWoRound":97274,"PurchasePayments":[{{"Amount":{10},"Method":"Cash"}}],"BranchId":{5}}},"PurchaseOrderLargeData":null,"Complete":true,"CopyFrom":0,"PricebookDetail":[],"IsFinalizedOS":false}}    ${import_code}    ${liststring_prs_purchase_detail}    ${get_id_nguoiban}    ${get_id_ncc}
    ...    ${get_id_nguoitao}    ${BRANCH_ID}    ${result_tongtienhang}    ${result_discount_nh}    ${discount_type}
    ...    ${result_cantrancc}    ${actual_tientrancc}
    Log    ${request_payload}
    Post request thr API    /purchaseOrders    ${request_payload}
    Return From Keyword    ${import_code}

Get payment code by purchase code
    [Arguments]     ${input_ma_phieunhap}
    ${get_id_phieunhap}     Get purchase receipt id thr API    ${input_ma_phieunhap}
    ${jsonpath_paymentcode}   Format String        $.Data[?(@.TargetCode =="{0}")].Code    ${input_ma_phieunhap}
    ${endpoint_payment_code}    Format String    ${endpoint_list_purchasepayment}    ${get_id_phieunhap}
    ${get_payment_code}   Get data from API    ${endpoint_payment_code}    ${jsonpath_paymentcode}
    Return From Keyword    ${get_payment_code}

Assert values by purchase code
    [Arguments]     ${import_code}    ${input_supplier_code}    ${input_tongtienhang}    ${input_tientrancc}     ${input_tongsoluong}   ${input_cantrancc}     ${input_ggpn}      ${input_trangthai}
    ${get_supplier_code}    ${get_tongtienhang}    ${get_tiendatra_ncc}    ${get_giamgia_pn}    ${get_tongcong}    ${get_tongsoluong}    ${get_trangthai}
    ...    Get purchase receipt info incase discount by purchase receipt code    ${import_code}
    Should Be Equal As Strings    ${get_supplier_code}    ${input_supplier_code}
    Should Be Equal As Numbers    ${get_tongtienhang}    ${input_tongtienhang}
    Should Be Equal As Numbers    ${get_tiendatra_ncc}    ${input_tientrancc}
    Should Be Equal As Numbers    ${get_tongsoluong}    ${input_tongsoluong}
    Should Be Equal As Numbers    ${get_tongcong}    ${input_cantrancc}
    Should Be Equal As Numbers    ${get_giamgia_pn}    ${input_ggpn}
    Should Be Equal As Strings    ${get_trangthai}    ${input_trangthai}

Assert values by purchase code until succeed
    [Arguments]     ${import_code}    ${input_supplier_code}    ${input_tongtienhang}    ${input_tientrancc}     ${input_tongsoluong}   ${input_cantrancc}     ${input_ggpn}      ${input_trangthai}
    Wait Until Keyword Succeeds    5x    3x    Assert values by purchase code    ${import_code}    ${input_supplier_code}    ${input_tongtienhang}    ${input_tientrancc}     ${input_tongsoluong}   ${input_cantrancc}     ${input_ggpn}      ${input_trangthai}

Import lodate product
    [Arguments]    ${list_product_codes}    ${list_nums}    ${list_cost}    ${list_discount_type}    ${list_discount_value}    ${list_producttype}
    ...    ${list_all_lo}    ${suppplier_code}
    [Documentation]    Nhập hàng với hàng hóa lô date
    [Timeout]    5 mins
    #${list_id_lo}    Get list batch expire id thr api    ${list_product_codes}    ${list_all_lo}
    ${list_product_ids}    Get list product id thr API    ${list_product_codes}
    ${get_user_id}    Get User ID
    ${supplier_id}    Get Supplier Id    ${suppplier_code}
    ${get_retailer_id}     Get RetailerID
    ${liststring_prs_importproducts_detail}    Set Variable    needdel
    Log    ${liststring_prs_importproducts_detail}
    ${list_cost_af_discount}    Create list
    ${list_id_lo}    ${list_batch_name}    ${list_expire_date}    ${list_fullnamevirgule}    Get list batch expire info thr api    ${list_product_codes}    ${list_all_lo}
    #tính toán giảm giá, điền vào api
    : FOR    ${item_product_code}    ${item_product_id}    ${item_num}    ${item_product_type}    ${item_cost}    ${item_discount_type}
    ...    ${item_discount_value}    ${item_lo}    ${item_id_lo}    ${item_batch_name}    ${item_expire_date}    ${item_fullnamevirgule}
    ...    IN ZIP    ${list_product_codes}    ${list_product_ids}    ${list_nums}    ${list_producttype}    ${list_cost}    ${list_discount_type}
    ...    ${list_discount_value}    ${list_all_lo}    ${list_id_lo}    ${list_batch_name}    ${list_expire_date}    ${list_fullnamevirgule}
    \    ${conversion_value}    Get DVQD by product code frm API    ${item_product_code}
    \    ${item_cost_af_discount}=    Run Keyword If    ${item_discount_value} > 101    Minus    ${item_cost}    ${item_discount_value}
    \    ...    ELSE IF    0 < ${item_discount_value} < 100    Price after % discount product    ${item_cost}    ${item_discount_value}
    \    ...    ELSE    Set Variable    ${item_cost}
    \    ${item_discount}=    Run Keyword If    '${item_discount_type}' == 'VND'    Set Variable    ${item_discount_value}
    \    ...    ELSE    Convert % discount to VND and round    ${item_cost}    ${item_discount_value}
    \    ${discount_ratio}=    Run Keyword If    '${item_discount_type}' == 'VND'    Set Variable    null
    \    ...    ELSE    Set variable    ${item_discount_value}
    \    ${payload_each_product}    Format string    {{"ProductId":{0},"ConversionValue":{1},"Product":{{"Name":"Kẹo Hồng Sâm Vitamin Daegoung Food","Code":"LD04","IsLotSerialControl":false,"IsBatchExpireControl":true,"OnHand":1202.22,"Reserved":0,"ActualReserved":0}},"ProductName":"Kẹo Hồng Sâm Vitamin Daegoung Food","ProductCode":"LD04","Description":"","Price":{7},"priceAfterDiscount":{8},"Quantity":{2},"ShowUnit":false,"ListProductUnit":[{{"Id":{0},"Unit":"","Code":"LD04","Conversion":0,"MasterUnitId":0}}],"Units":[{{"Id":{0},"Unit":"","Code":"LD04","Conversion":0,"MasterUnitId":0}}],"Unit":"","SelectedUnit":{0},"OnOrder":0,"ProductBatchExpires":[{{"Id":{3},"FullNameVirgule":"{9}","BatchName":"{10}","ExpireDate":"{11}","ProductId":{0},"IsBatchExpireControl":true,"OnHand":1202.22,"Status":1,"BranchId":{4},"IsExpire":false,"IsAboutToExpire":true}}],"ListProductSerialHavingTrans":[],"ListProductBatchExpireHavingTrans":[],"tabIndex":100,"ViewIndex":1,"TotalValue":47175,"Discount":{5},"ProductBatchExpireList":[{{"Id":{3},"BatchName":"{10}","FullNameVirgule":"{9}","ExpireDate":"{11}","DisplayType":1,"Status":1,"IsUpdate":1,"OnHand":{2},"SystemCount":1202.22}}],"OriginPrice":{7},"DiscountRatio":{6},"Allocation":0,"AllocationSuppliers":0,"AllocationThirdParty":0,"OrderByNumber":0}}
    \    ...    ${item_product_id}    ${conversion_value}    ${item_num}    ${item_id_lo}    ${BRANCH_ID}    ${item_discount}    ${discount_ratio}    ${item_cost}    ${item_cost_af_discount}    ${item_fullnamevirgule}    ${item_batch_name}    ${item_expire_date}
    \    Log    ${payload_each_product}
    \    ${liststring_prs_importproducts_detail}    Catenate    SEPARATOR=,    ${liststring_prs_importproducts_detail}    ${payload_each_product}
    \    Append To List    ${list_cost_af_discount}    ${item_cost_af_discount}
    ${liststring_prs_importproducts_detail}    Replace String    ${liststring_prs_importproducts_detail}    needdel,    ${EMPTY}    count=1
    ${data_str}    Format String    {{"PurchaseOrder":{{"PurchaseOrderDetails":[{4}],"UserId":{0},"CompareUserId":{0},"User":{{"id":{0},"username":"admin","givenName":"thao11","Id":{0},"UserName":"admin","GivenName":"thao11","IsAdmin":true,"IsLimitedByTrans":false,"IsShowSumRow":true,"Theme":"","Language":"vi-VN"}},"Description":"","Supplier":{{"IdOld":0,"TotalInvoiced":0,"CompareCode":"NCC000001","CompareName":"gao ồ","ComparePhone":"0123123123","IsCusSupCombine":false,"Id":{1},"Name":"gao ồ","Phone":"0123123123","RetailerId":{2},"Code":"NCC000001","CreatedDate":"2020-10-28T15:08:07.7630000+07:00","CreatedBy":{0},"Debt":3703407,"LocationName":"","WardName":"","BranchId":{3},"isDeleted":false,"isActive":true,"SearchNumber":"0123123123","PurchaseOrders":[],"PurchaseReturns":[],"PurchasePayments":[],"SupplierGroupDetails":[],"OrderSuppliers":[],"CustomerSupplierCombines":[]}},"SupplierId":{1},"CompareSupplierId":0,"SubTotal":0,"Branch":{{"id":{3},"name":"Chi nhánh trung tâm","Id":{3},"Name":"Chi nhánh trung tâm","Address":"1b Yết kiêu","LocationName":"Hà Nội - Quận Hoàn Kiếm","WardName":"Phường Trần Hưng Đạo","ContactNumber":"0379089988","SubContactNumber":"","GmbStatus":1}},"Status":1,"StatusValue":"Phiếu tạm","CompareStatusValue":"Phiếu tạm","Discount":0,"CompareDiscount":0,"DiscountRatio":0,"Id":0,"UpdatePurchaseId":0,"Account":{{}},"Total":0,"TotalQuantity":2,"ExpensesOthersTitle":"","ExpensesOthersRtpTitle":"","PurchaseOrderExpensesOthers":[],"PurchaseOrderExpensesOthersRs":[],"PurchaseOrderExpensesOthersRtp":[],"PurchasePayments":[],"ExReturnSuppliers":0,"ExReturnThirdParty":0,"PaidAmount":0,"PayingAmount":0,"ChangeAmount":0,"paymentMethod":"","BalanceDue":0,"DepositReturn":0,"OriginTotal":0,"PricebookDetail":[],"paymentMethodObj":null,"paymentReturnType":0,"Uuid":"","BranchId":{3}}},"PurchaseOrderLargeData":null,"Complete":true,"CopyFrom":0,"PricebookDetail":[],"IsFinalizedOS":false}}
    ...    ${get_user_id}    ${supplier_id}    ${get_retailer_id}    ${BRANCH_ID}    ${liststring_prs_importproducts_detail}
    log    ${data_str}
    ${headers1}=    Create Dictionary    Authorization=${bearertoken}    Content-Type=application/json;charset=utf-8
    Create Session    lolo    ${API_URL}    cookies=${resp.cookies}
    ${resp3}=    Post Request    lolo    /purchaseOrders    data=${data_str}    headers=${headers1}
    Log    ${resp3.request.body}
    Log    ${resp3.json()}
    log    ${resp3.status_code}
    Should Be Equal As Strings    ${resp3.status_code}    200
    ${dict}    Set Variable    ${resp3.json()}
    ${purchase_code}    Get From Dictionary    ${dict}    Code
    Return From Keyword    ${list_cost_af_discount}    ${purchase_code}
