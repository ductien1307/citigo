*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}      ${headless_browser}
Resource          ../../../../core/Ban_Hang/banhang_action.robot
Resource          ../../../../core/Ban_Hang/banhang_getandcompute.robot
Resource          ../../../../core/share/toast_message.robot
Resource          ../../../../core/Ban_Hang/banhang_navigation.robot
Resource          ../../../../core/API/api_danhmuc_hanghoa.robot
Resource          ../../../../core/API/api_khachhang.robot
Resource          ../../../../core/API/api_hoadon_banhang.robot
Resource          ../../../../core/API/api_soquy.robot
Resource          ../../../../core/So_Quy/so_quy_list_action.robot
Resource          ../../../../config/env_product/envi.robot
Resource          ../../../../core/share/list_dictionary.robot
Resource          ../../../../core/API/api_mhbh.robot
Resource          ../../../../core/API/api_access.robot
Resource          ../../../../core/API/api_dathang.robot

*** Variables ***
&{invoice_1}      KLU04=5.6      KLT0004=5.6      KLSI0002=1      DVL002=3      Combo168=2      KLQD019=5.6      RPT0011=5.6      SIL009=2      DV141=4      RPCB001=1
&{invoice_2}      KLU04=5.6      KLT0004=5.6      KLQD019=5.6       DVL002=3      Combo168=2
&{invoice_3}      KLSI0016=1000
&{invoice_4}      SI001=100      SI002=100      SI003=100      SI004=100      SI005=100
&{invoice_1}      PIB10034=5.6    IM17=1
&{discount_1}      PIB10034=5    IM17=4000
&{discount_type1}      PIB10034=dis    IM17=none
&{product_type1}      PIB10034=pro    IM17=imei

*** Test Cases ***    Product and num list         Customer        Product Discount
10 product                   [Tags]      RUN1
                      [Template]              create
                      ${invoice_1}      KH003       100000

500 product                   [Tags]      RUN2
                      [Template]              create2
                      KH003       100000

250 imei                  [Tags]     RUNTEST1
                      [Template]              create3
                      KH004

1000 Imei                  [Tags]                  RUNTEST2
                      [Template]              create4
                      KH004      ${invoice_3}       500000

100 Imei                  [Tags]                  RUNTEST3
                      [Template]              create4
                      KH004      ${invoice_4}       500000

Khuyen mai          [Tags]           RUNTEST4
                      [Template]              akm_inv_prod_1213
                      ${invoice_1}            ${product_type1}          ${discount_1}         ${discount_type1}          5             5        KH031        0            KM012

Multi row                   [Tags]    RUN3
                      [Template]              nhieudong
                      KH003      ${invoice_2}       100000

*** Keywords ***
create
    [Arguments]    ${dict_product_num}    ${input_ma_kh}    ${input_khtt}
    [Timeout]
    ## Get info ton cuoi, cong no khach hang
    ${Uuid}      Generate Random String    4    [NUMBERS][NUMBERS]
    ${Uuid_code}      Catenate      SEPARATOR=      WA     ${Uuid}
    ${Uuid}      Generate Random String    4    [NUMBERS][NUMBERS]
    ${Uuid_code}      Catenate      SEPARATOR=      WA     ${Uuid}
    ${list_product}    Get Dictionary Keys    ${dict_product_num}
    ${list_nums}    Get Dictionary Values    ${dict_product_num}
    Create list imei and other product    ${list_product}    ${list_nums}
    Sleep    60s
    ${jsonpath_id_kh}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_kh}
    ${get_id_kh}    Get data from API    ${endpoint_khachhang}    ${jsonpath_id_kh}
    ${endpoint_danhmuc_hh_co_dvt}    Format String    ${endpoint_list_hh_in_mhbh}    ${BRANCH_ID}    ${BRANCH_ID}
    ${get_resp_danhmuc_hh}    Get Request and return body    ${endpoint_danhmuc_hh_co_dvt}
    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}    Get list jsonpath product frm list product    ${list_product}
    ${list_giaban}    ${list_id_sp}    Get product info frm list jsonpath product    ${get_resp_danhmuc_hh}    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}
    #post request
    ${liststring_prs_invoice_detail}    Set Variable    needdel
    Log    ${liststring_prs_invoice_detail}
    : FOR    ${item_gia_ban}    ${item_id_sp}    ${item_soluong}    ${item_imei}    IN ZIP    ${list_giaban}    ${list_id_sp}    ${list_nums}    ${imei_inlist}
    \    ${item_imei}    Convert list to string and return    ${item_imei}
    \    ${payload_each_product}    Format string    {{"BasePrice":{0},"IsLotSerialControl":true,"IsRewardPoint":true,"Price":{0},"ProductId":{1},"Quantity":{2},"ProductCode":"SP000447","SerialNumbers":"{3}","Weight":0,"Discount":null,"ProductName":"Điện thoại A","SalePromotionId":null,"PriceByPromotion":null,"PromotionParentProductId":null,"ProductBatchExpireId":null,"CategoryId":439203,"MasterProductId":{1},"Unit":"","Uuid":"","ProductWarranty":[]}}    ${item_gia_ban}    ${item_id_sp}    ${item_soluong}    ${item_imei}
    \    ${liststring_prs_invoice_detail}    Catenate    SEPARATOR=,    ${liststring_prs_invoice_detail}    ${payload_each_product}
    ${liststring_prs_invoice_detail}    Replace String    ${liststring_prs_invoice_detail}    needdel,    ${EMPTY}    count=1
    ${request_payload}    Format String    {{"Invoice":{{"BranchId":35,"RetailerId":19,"UpdateInvoiceId":0,"UpdateReturnId":0,"CustomerId":{0},"SoldById":47,"SoldBy":{{"CreatedBy":0,"CreatedDate":"2020-02-18T11:08:58.933Z","Email":"","GivenName":"anh.lv","Id":47,"IsActive":true,"IsAdmin":true,"Language":"vi-VN","MobilePhone":"","Type":0,"UserName":"admin","isDeleted":false}},"SaleChannelId":0,"Seller":{{"CreatedBy":0,"CreatedDate":"2020-02-18T11:08:58.933Z","Email":"","GivenName":"anh.lv","Id":47,"IsActive":true,"IsAdmin":true,"Language":"vi-VN","MobilePhone":"","Type":0,"UserName":"admin","isDeleted":false}},"OrderCode":"","Code":"Hóa đơn 1","InvoiceDetails":[{1}],"InvoiceOrderSurcharges":[],"InvoicePromotions":[],"Payments":[{{"Method":"Cash","MethodStr":"Tiền mặt","Amount":{2},"Id":-1}}],"Status":1,"Total":190000,"Surcharge":0,"Type":1,"Uuid":"{3}","addToAccount":"0","addToAccountSurplus":"0","addToAccountAllocation":"0","addToAccountPaymentAllocation":"0","PayingAmount":{2},"TotalBeforeDiscount":190000,"ProductDiscount":0,"DebugUuid":"","InvoiceWarranties":[],"CreatedBy":47}}}}
    ...    ${get_id_kh}    ${liststring_prs_invoice_detail}    ${input_khtt}   ${Uuid_code}
    Log    ${request_payload}
    : FOR    ${time}    IN RANGE    5
    \    ${get_current_time}    Get Current Date
    \    ${headers}=    Create Dictionary    Authorization=${bearertoken}    Content-Type=application/json;charset=UTF-8    Retailer=${RETAILER_NAME}    BranchId=${BRANCH_ID}    Zone=${env}
    \    Create Session    kiotvietapi    ${SALE_API_URL}    cookies=${resp.cookies}    verify=True    debug=1
    \    ${resp}=    Post Request    kiotvietapi    /invoices/save    data=${request_payload}    headers=${headers}
    \    Log    ${resp.request.body}
    \    Log    ${resp.json()}
    \    Log    ${resp.status_code}
    \    Should Be Equal As Strings    ${resp.status_code}    200
    \    ${get_current_time1}    Get Current Date
    \    Exit For Loop If    '${resp.status_code}'=='200'
    ${time_payment}   Subtract Date From Date    ${get_current_time1}    ${get_current_time}

create2
    [Arguments]    ${input_ma_kh}    ${input_khtt}
    ${Uuid}      Generate Random String    4    [NUMBERS][NUMBERS]
    ${Uuid_code}      Catenate      SEPARATOR=      WA     ${Uuid}
    ${endpoint_product}     Set Variable    /branchs/35/masterproducts?format=json&Includes=ProductAttributes&ForSummaryRow=true&CategoryId=0&AttributeFilter=%5B%5D&ProductTypes=&IsImei=2&IsFormulas=2&IsActive=true&AllowSale=&IsBatchExpireControl=2&ShelvesIds=&TrademarkIds=&take=500&skip=0&page=1&pageSize=500&filter%5Blogic%5D=and
    ${get_list_product}   Get raw data from API    ${endpoint_product}    $.Data..Code
    ${imei_by_product_inlist}    create list
    ${resp}    Get Request and return body    ${endpoint_product}
    ${list_imei_status}    Create List
    : FOR    ${item_pr}    IN ZIP    ${get_list_product}
    \    ${jsonpath_imei_status}    Format String    $..Data[?(@.Code=="{0}")].IsLotSerialControl    ${item_pr}
    \    ${get_imei_status}    Get data from response json    ${resp}    ${jsonpath_imei_status}
    \    Append To List    ${list_imei_status}    ${get_imei_status}
    Log    ${list_imei_status}
    : FOR    ${item_product}    ${item_status}    IN ZIP    ${get_list_product}    ${list_imei_status}
    \    ${imei_by_product}    Run Keyword If    '${item_status}' == '0'    Set Variable    ${EMPTY}
    \    ...    ELSE    Import multi imei for product    ${item_product}    1
    \    Append To List    ${imei_by_product_inlist}    ${imei_by_product}
    Log many    ${imei_by_product_inlist}
    Set Test Variable    \${imei_inlist}    ${imei_by_product_inlist}
    Set Test Variable    \${get_list_product}    ${get_list_product}
    Sleep    60s
    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}    Get list jsonpath product frm list product    ${get_list_product}
    ${list_giaban}    ${list_id_sp}    Get product info frm list jsonpath product    ${resp}    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}
    #post request
    ${liststring_prs_invoice_detail}    Set Variable    needdel
    Log    ${liststring_prs_invoice_detail}
    : FOR    ${item_gia_ban}    ${item_id_sp}    ${item_imei}    IN ZIP    ${list_giaban}    ${list_id_sp}    ${imei_inlist}
    \    ${item_imei}    Convert list to string and return    ${item_imei}
    \    ${payload_each_product}    Format string    {{"BasePrice":{0},"IsLotSerialControl":false,"IsRewardPoint":false,"Note":"","Price":{0},"ProductId":{1},"Quantity":1,"ProductCode":"CNKH01","SerialNumbers":"{2}","ProductName":"Chổi lau nhà tự động 3","OriginPrice":{0},"PriceByPromotion":null,"PromotionParentProductId":null,"ProductBatchExpireId":null,"CategoryId":50,"MasterProductId":{1},"Unit":"","Uuid":"","ProductWarranty":[]}}    ${item_gia_ban}    ${item_id_sp}    ${item_imei}
    \    ${liststring_prs_invoice_detail}    Catenate    SEPARATOR=,    ${liststring_prs_invoice_detail}    ${payload_each_product}
    ${liststring_prs_invoice_detail}    Replace String    ${liststring_prs_invoice_detail}    needdel,    ${EMPTY}    count=1
    ${request_payload}    Format String    {{"Invoice":{{"BranchId":35,"RetailerId":19,"UpdateInvoiceId":0,"UpdateReturnId":0,"CustomerId":{0},"SoldById":47,"SoldBy":{{"CreatedBy":0,"CreatedDate":"2020-02-18T11:08:58.933Z","Email":"","GivenName":"anh.lv","Id":47,"IsActive":true,"IsAdmin":true,"Language":"vi-VN","MobilePhone":"","Type":0,"UserName":"admin","isDeleted":false}},"SaleChannelId":0,"SaleChannel":null,"Seller":{{"CreatedBy":0,"CreatedDate":"2020-02-18T11:08:58.933Z","Email":"","GivenName":"anh.lv","Id":47,"IsActive":true,"IsAdmin":true,"Language":"vi-VN","MobilePhone":"","Type":0,"UserName":"admin","isDeleted":false}},"OrderCode":"","Code":"Hóa đơn 1","InvoiceDetails":[{1}],"InvoiceOrderSurcharges":[],"InvoicePromotions":[],"Payments":[{{"Method":"Cash","MethodStr":"Tiền mặt","Amount":190000,"Id":-1}}],"Status":1,"Total":190000,"Surcharge":0,"Type":1,"Uuid":"{2}","addToAccount":"0","PayingAmount":190000,"TotalBeforeDiscount":190000,"ProductDiscount":0,"DebugUuid":"158311754425976","InvoiceWarranties":[],"CreatedBy":47}}}}
    ...    87    ${liststring_prs_invoice_detail}    ${Uuid_code}
    Log    ${request_payload}
    : FOR    ${time}    IN RANGE    5
    \    ${get_current_time}    Get Current Date
    \    ${headers}=    Create Dictionary    Authorization=${bearertoken}    Content-Type=application/json;charset=UTF-8    Retailer=${RETAILER_NAME}    BranchId=${BRANCH_ID}    Zone=${env}
    \    Create Session    kiotvietapi    ${SALE_API_URL}    cookies=${resp.cookies}    verify=True    debug=1
    \    ${resp}=    Post Request    kiotvietapi    /invoices/save    data=${request_payload}    headers=${headers}
    \    Log    ${resp.request.body}
    \    Log    ${resp.json()}
    \    Log    ${resp.status_code}
    \    Should Be Equal As Strings    ${resp.status_code}    200
    \    ${get_current_time1}    Get Current Date
    \    Exit For Loop If    '${resp.status_code}'=='200'
    ${time_payment}   Subtract Date From Date    ${get_current_time1}    ${get_current_time}
    Return From Keyword    ${time_payment}

create3
    [Arguments]    ${input_ma_kh}
    ${Uuid}      Generate Random String    4    [NUMBERS][NUMBERS]
    ${Uuid_code}      Catenate      SEPARATOR=      WA     ${Uuid}
    ${endpoint_product}     Set Variable    /branchs/35/masterproducts?format=json&Includes=ProductAttributes&ForSummaryRow=true&CategoryId=0&AttributeFilter=%5B%5D&ProductKey=SI&ProductTypes=&IsImei=2&IsFormulas=2&IsActive=true&AllowSale=&IsBatchExpireControl=2&ShelvesIds=&TrademarkIds=&take=100&skip=0&page=1&pageSize=100&filter%5Blogic%5D=and
    ${get_list_product}   Get raw data from API    ${endpoint_product}    $.Data..Code
    ${imei_by_product_inlist}    create list
    ${get_list_status}    Get list imei status thr API    ${get_list_product}
    : FOR    ${item_product}    ${item_status}    IN ZIP    ${get_list_product}    ${get_list_status}
    \    ${imei_by_product}    Run Keyword If    '${item_status}' == '0'    Set Variable    ${EMPTY}
    \    ...    ELSE    Import multi imei for product    ${item_product}    1
    \    Append To List    ${imei_by_product_inlist}    ${imei_by_product}
    Log many    ${imei_by_product_inlist}
    Set Test Variable    \${imei_inlist}    ${imei_by_product_inlist}
    Set Test Variable    \${get_list_product}    ${get_list_product}
    Sleep    60s
    ${get_resp_danhmuc_hh}    Get Request and return body    ${endpoint_product}
    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}    Get list jsonpath product frm list product    ${get_list_product}
    ${list_giaban}    ${list_id_sp}    Get product info frm list jsonpath product    ${get_resp_danhmuc_hh}    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}
    #post request
    ${liststring_prs_invoice_detail}    Set Variable    needdel
    Log    ${liststring_prs_invoice_detail}
    : FOR    ${item_gia_ban}    ${item_id_sp}    ${item_imei}    IN ZIP    ${list_giaban}    ${list_id_sp}    ${imei_inlist}
    \    ${item_imei}    Convert list to string and return    ${item_imei}
    \    ${payload_each_product}    Format string    {{"BasePrice":{0},"IsLotSerialControl":false,"IsRewardPoint":false,"Note":"","Price":{0},"ProductId":{1},"Quantity":1,"ProductCode":"CNKH01","SerialNumbers":"{2}","ProductName":"Chổi lau nhà tự động 3","OriginPrice":{0},"PriceByPromotion":null,"PromotionParentProductId":null,"ProductBatchExpireId":null,"CategoryId":50,"MasterProductId":{1},"Unit":"","Uuid":"","ProductWarranty":[]}}    ${item_gia_ban}    ${item_id_sp}    ${item_imei}
    \    ${liststring_prs_invoice_detail}    Catenate    SEPARATOR=,    ${liststring_prs_invoice_detail}    ${payload_each_product}
    ${liststring_prs_invoice_detail}    Replace String    ${liststring_prs_invoice_detail}    needdel,    ${EMPTY}    count=1
    ${request_payload}    Format String    {{"Invoice":{{"BranchId":35,"RetailerId":19,"UpdateInvoiceId":0,"UpdateReturnId":0,"CustomerId":{0},"SoldById":47,"SoldBy":{{"CreatedBy":0,"CreatedDate":"2020-02-18T11:08:58.933Z","Email":"","GivenName":"anh.lv","Id":47,"IsActive":true,"IsAdmin":true,"Language":"vi-VN","MobilePhone":"","Type":0,"UserName":"admin","isDeleted":false}},"SaleChannelId":0,"SaleChannel":null,"Seller":{{"CreatedBy":0,"CreatedDate":"2020-02-18T11:08:58.933Z","Email":"","GivenName":"anh.lv","Id":47,"IsActive":true,"IsAdmin":true,"Language":"vi-VN","MobilePhone":"","Type":0,"UserName":"admin","isDeleted":false}},"OrderCode":"","Code":"Hóa đơn 1","InvoiceDetails":[{1}],"InvoiceOrderSurcharges":[],"InvoicePromotions":[],"Payments":[{{"Method":"Cash","MethodStr":"Tiền mặt","Amount":190000,"Id":-1}}],"Status":1,"Total":190000,"Surcharge":0,"Type":1,"Uuid":"{2}","addToAccount":"0","PayingAmount":190000,"TotalBeforeDiscount":190000,"ProductDiscount":0,"DebugUuid":"","InvoiceWarranties":[],"CreatedBy":47}}}}
    ...    88    ${liststring_prs_invoice_detail}    ${Uuid_code}
    Log    ${request_payload}
    : FOR    ${time}    IN RANGE    5
    \    ${get_current_time}    Get Current Date
    \    ${headers}=    Create Dictionary    Authorization=${bearertoken}    Content-Type=application/json;charset=UTF-8    Retailer=${RETAILER_NAME}    BranchId=${BRANCH_ID}    Zone=${env}
    \    Create Session    kiotvietapi    ${SALE_API_URL}    cookies=${resp.cookies}    verify=True    debug=1
    \    ${resp}=    Post Request    kiotvietapi    /invoices/save    data=${request_payload}    headers=${headers}
    \    Log    ${resp.request.body}
    \    Log    ${resp.json()}
    \    Log    ${resp.status_code}
    \    Should Be Equal As Strings    ${resp.status_code}    200
    \    ${get_current_time1}    Get Current Date
    \    Exit For Loop If    '${resp.status_code}'=='200'
    ${time_payment}   Subtract Date From Date    ${get_current_time1}    ${get_current_time}
    Return From Keyword    ${time_payment}

create4
    [Arguments]    ${input_ma_kh}    ${dict_product_nums}    ${input_khtt}
    ${Uuid}      Generate Random String    4    [NUMBERS][NUMBERS]
    ${Uuid_code}      Catenate      SEPARATOR=      WA     ${Uuid}
    ${list_product}    Get Dictionary Keys    ${dict_product_nums}
    ${list_nums}    Get Dictionary Values    ${dict_product_nums}
    Create list imei and other product    ${list_product}    ${list_nums}
    Sleep    60s
    ${endpoint_danhmuc_hh_co_dvt}    Format String    ${endpoint_list_hh_in_mhbh}    ${BRANCH_ID}    ${BRANCH_ID}
    ${get_resp_danhmuc_hh}    Get Request and return body    ${endpoint_danhmuc_hh_co_dvt}
    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}    Get list jsonpath product frm list product    ${list_product}
    ${list_giaban}    ${list_id_sp}    Get product info frm list jsonpath product    ${get_resp_danhmuc_hh}    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}
    #post request
    ${liststring_prs_invoice_detail}    Set Variable    needdel
    Log    ${liststring_prs_invoice_detail}
    : FOR    ${item_gia_ban}    ${item_id_sp}    ${item_soluong}    ${item_imei}    IN ZIP    ${list_giaban}    ${list_id_sp}    ${list_nums}    ${imei_inlist}
    \    ${item_imei}    Convert list to string and return    ${item_imei}
    \    ${payload_each_product}    Format string    {{"BasePrice":{0},"IsLotSerialControl":true,"IsRewardPoint":true,"Price":{0},"ProductId":{1},"Quantity":{2},"ProductCode":"SP000447","SerialNumbers":"{3}","Weight":0,"Discount":null,"ProductName":"Điện thoại A","SalePromotionId":null,"PriceByPromotion":null,"PromotionParentProductId":null,"ProductBatchExpireId":null,"CategoryId":439203,"MasterProductId":{1},"Unit":"","Uuid":"","ProductWarranty":[]}}    ${item_gia_ban}    ${item_id_sp}    ${item_soluong}    ${item_imei}
    \    ${liststring_prs_invoice_detail}    Catenate    SEPARATOR=,    ${liststring_prs_invoice_detail}    ${payload_each_product}
    ${liststring_prs_invoice_detail}    Replace String    ${liststring_prs_invoice_detail}    needdel,    ${EMPTY}    count=1
    ${request_payload}    Format String    {{"Invoice":{{"BranchId":35,"RetailerId":19,"UpdateInvoiceId":0,"UpdateReturnId":0,"CustomerId":{0},"SoldById":47,"SoldBy":{{"CreatedBy":0,"CreatedDate":"2020-02-18T11:08:58.933Z","Email":"","GivenName":"anh.lv","Id":47,"IsActive":true,"IsAdmin":true,"Language":"vi-VN","MobilePhone":"","Type":0,"UserName":"admin","isDeleted":false}},"SaleChannelId":0,"Seller":{{"CreatedBy":0,"CreatedDate":"2020-02-18T11:08:58.933Z","Email":"","GivenName":"anh.lv","Id":47,"IsActive":true,"IsAdmin":true,"Language":"vi-VN","MobilePhone":"","Type":0,"UserName":"admin","isDeleted":false}},"OrderCode":"","Code":"Hóa đơn 1","InvoiceDetails":[{1}],"InvoiceOrderSurcharges":[],"InvoicePromotions":[],"Payments":[{{"Method":"Cash","MethodStr":"Tiền mặt","Amount":{2},"Id":-1}}],"Status":1,"Total":190000,"Surcharge":0,"Type":1,"Uuid":"{3}","addToAccount":"0","addToAccountSurplus":"0","addToAccountAllocation":"0","addToAccountPaymentAllocation":"0","PayingAmount":{2},"TotalBeforeDiscount":190000,"ProductDiscount":0,"DebugUuid":"","InvoiceWarranties":[],"CreatedBy":47}}}}
    ...    88    ${liststring_prs_invoice_detail}    ${input_khtt}   ${Uuid_code}
    Log    ${request_payload}
    : FOR    ${time}    IN RANGE    5
    \    ${get_current_time}    Get Current Date
    \    ${headers}=    Create Dictionary    Authorization=${bearertoken}    Content-Type=application/json;charset=UTF-8    Retailer=${RETAILER_NAME}    BranchId=${BRANCH_ID}    Zone=${env}
    \    Create Session    kiotvietapi    ${SALE_API_URL}    cookies=${resp.cookies}    verify=True    debug=1
    \    ${resp}=    Post Request    kiotvietapi    /invoices/save    data=${request_payload}    headers=${headers}
    \    Log    ${resp.request.body}
    \    Log    ${resp.json()}
    \    Log    ${resp.status_code}
    \    Should Be Equal As Strings    ${resp.status_code}    200
    \    ${get_current_time1}    Get Current Date
    \    Exit For Loop If    '${resp.status_code}'=='200'
    ${time_payment}   Subtract Date From Date    ${get_current_time1}    ${get_current_time}

akm_inv_prod_1213
    [Arguments]    ${dict_product_num}    ${dict_product_type}      ${dict_discount}      ${dict_discount_type}      ${input_invoice_discount}    ${input_invoice_discount_type}       ${input_bh_ma_kh}    ${input_bh_khachtt}     ${input_khuyemmai}
    Toggle status of promotion    ${input_khuyemmai}    1
    ${Uuid}      Generate Random String    4    [NUMBERS][NUMBERS]
    ${Uuid_code}      Catenate      SEPARATOR=      WA     ${Uuid}
    ${invoice_value}    ${discount}    ${discount_ratio}    ${name}     ${promotion_sale_id}       ${promotion_id}        Get Invoice value - Discounts - Promotion Name - Promotion Sale - Id from Promotion Code     ${input_khuyemmai}
    ${list_products}    Get Dictionary Keys    ${dict_product_num}
    ${list_nums}    Get Dictionary Values    ${dict_product_num}
    ${list_product_type}    Get Dictionary Values    ${dict_product_type}
    ${list_discount_product}    Get Dictionary Values    ${dict_discount}
    ${list_discount_type}    Get Dictionary Values    ${dict_discount_type}
    ${list_unit}       Get list of keys from dictionary by value    ${dict_product_type}      unit
    ${list_imei_product}       Get list of keys from dictionary by value    ${dict_product_type}      imei
    ${list_unit_quan}=       Get list of values from dictionary by list of keys    ${dict_product_num}    ${list_unit}
    Log      Create list imei for imei products
    ${list_imei_all}    create list
    : FOR    ${item_product}     ${item_num}    ${item_product_type}    IN ZIP    ${list_products}    ${list_nums}      ${list_product_type}
    \    ${list_imei_by_single_product}      Run Keyword If    '${item_product_type}' == 'imei'      Import multi imei for product    ${item_product}    ${item_num}      ELSE      Set Variable    nonimei
    \    Append to List       ${list_imei_all}        ${list_imei_by_single_product}
    Log       ${list_imei_all}
    ${list_imei_for_validation}      Copy list      ${list_imei_all}
    Remove values From List      ${list_imei_for_validation}        nonimei
    ${list_product_for_validation}       ${list_product_quan_for_validation}     ${list_product_type_for_validation}       Remove combo and unit from validation lists    ${list_products}    ${list_nums}    ${list_product_type}
    ${list_product_for_validation}       ${list_product_quan_for_validation}     ${list_product_type_for_validation}       Extract combo and unit products for validation lists        ${list_products}    ${list_nums}    ${list_product_type}       ${list_product_for_validation}       ${list_product_quan_for_validation}     ${list_product_type_for_validation}
    ${list_result_thanhtien}      ${list_result_newprice}    Get list of total sale - result new price incase changing product price    ${list_products}    ${list_nums}    ${list_discount_product}      ${list_discount_type}
    ${list_product_id}      ${get_list_baseprice}       ${list_result_product_discount}     ${list_result_newprice}       ${list_result_totalsale}    Get list of product id - baseprice - result product discount - result new price - total sale incase changing product price    ${list_products}    ${list_nums}    ${list_discount_product}      ${list_discount_type}
    Sleep     20 s
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${jsonpath_id_kh}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_bh_ma_kh}
    ${get_id_kh}    Get data from API    ${endpoint_khachhang}    ${jsonpath_id_kh}
    ${giamgia_hd}    Set Variable If    0 < ${input_invoice_discount} < 100    ${input_invoice_discount}    null
    ${result_tongtienhang}    Sum values in list    ${list_result_thanhtien}
    ${result_discount_invoice_by_vnd}=    Run Keyword If    0 < ${input_invoice_discount} < 100    Convert % discount to VND and round    ${result_tongtienhang}    ${input_invoice_discount}
    ...    ELSE    Set Variable    ${input_invoice_discount}
    ${actual_promo_discount_value}=    Run Keyword If     ${discount_ratio} != 0      Convert % discount to VND and round    ${result_tongtienhang}    ${discount_ratio}      ELSE     Set Variable    ${discount}
    ${final_discount}=    Run Keyword If    ${result_tongtienhang} > ${invoice_value}    Sum    ${actual_promo_discount_value}    ${result_discount_invoice_by_vnd}
    ...    ELSE    Set Variable    ${result_discount_invoice_by_vnd}
    ${result_khachcantra}    Minus    ${result_tongtienhang}    ${final_discount}
    ${result_gghd}    Run Keyword If    0 < ${input_invoice_discount} < 100    Convert % discount to VND    ${result_tongtienhang}    ${input_invoice_discount}
    ...    ELSE    Set Variable    ${final_discount}
    ${result_af_invoice_discount}    Minus    ${result_tongtienhang}    ${result_discount_invoice_by_vnd}
    ${actual_khachtt}    Set Variable If    '${input_bh_khachtt}' == 'all'    ${result_khachcantra}    ${input_bh_khachtt}
    # Post request BH
    ${text_total_invoice}        Convert from number to vnd discount text      ${invoice_value}        000000.0         ,000,000
    ${actual_text_discount}         Run Keyword If    ${discount_ratio} != 0       Convert from number to ratio discount text    ${discount_ratio}       ELSE      Convert from number to vnd discount text      ${discount}        000.0     ,000
    ${text_promo_info}        Format String      {0}: Tổng tiền hàng từ {3} và mua {1} PIB10034 - Máy ẩm không khí giảm giá {2} cho hóa đơn        ${name}      1        ${actual_text_discount}        ${text_total_invoice}
    # Cal
    ${liststring_prs_invoice_detail}     Create json for Invoice Details     ${list_product_id}       ${list_product_type}      ${get_list_baseprice}      ${list_nums}       ${list_discount_product}        ${list_result_product_discount}        ${list_discount_type}       ${list_imei_all}
    ${request_payload}    Format String    {{"Invoice":{{"BranchId":{0},"RetailerId":{1},"CustomerId":{2},"SoldById":{3},"SoldBy":{{"CreatedBy":0,"CreatedDate":"2018-12-10T10:42:37.447Z","Email":"","GivenName":"admin","Id":{3},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false}},"SaleChannelId":0,"Seller":{{"CreatedBy":0,"CreatedDate":"2018-12-10T10:42:37.447Z","Email":"","GivenName":"admin","Id":{3},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false}},"OrderCode":"","Code":"Hóa đơn 1","Discount":{4},"DiscountRatio":{5},"InvoiceDetails":[{6}],"InvoiceOrderSurcharges":[],"InvoicePromotions":[{{"Type":15,"TargetType":2,"SalePromotionId":{10},"PromotionId":{11},"Discount":200000,"PromotionInfo":"{9}","PrintPromotionInfo":"{9}"}}],"Payments":[{{"Method":"Cash","MethodStr":"Tiền mặt","Amount":{8},"Id":-1}}],"Status":1,"Total":{7},"Surcharge":0,"Type":1,"Uuid":"{12}","addToAccount":"0","addToAccountSurplus":"0","PayingAmount":{8},"TotalBeforeDiscount":2170500,"ProductDiscount":1268000,"DebugUuid":"","InvoiceWarranties":[],"CreatedBy":196750}}}}    ${BRANCH_ID}    ${get_id_nguoitao}    ${get_id_kh}    ${get_id_nguoiban}     ${final_discount}    ${input_invoice_discount_type}      ${liststring_prs_invoice_detail}      ${result_khachcantra}      ${actual_khachtt}        ${text_promo_info}        ${promotion_sale_id}       ${promotion_id}    ${Uuid_code}
    Log    ${request_payload}
    : FOR    ${time}    IN RANGE    5
    \    ${get_current_time}    Get Current Date
    \    ${headers}=    Create Dictionary    Authorization=${bearertoken}    Content-Type=application/json;charset=UTF-8    Retailer=${RETAILER_NAME}    BranchId=${BRANCH_ID}    Zone=${env}
    \    Create Session    kiotvietapi    ${SALE_API_URL}    cookies=${resp.cookies}    verify=True    debug=1
    \    ${resp}=    Post Request    kiotvietapi    /invoices/save    data=${request_payload}    headers=${headers}
    \    Log    ${resp.request.body}
    \    Log    ${resp.json()}
    \    Log    ${resp.status_code}
    \    Should Be Equal As Strings    ${resp.status_code}    200
    \    ${get_current_time1}    Get Current Date
    \    Exit For Loop If    '${resp.status_code}'=='200'
    ${time_payment}   Subtract Date From Date    ${get_current_time1}    ${get_current_time}

###
create multi row
    [Arguments]    ${item_gia_ban}    ${item_id_sp}    ${liststring_prs_order_detail}
    : FOR    ${item}      IN RANGE     50
    \    ${payload_each_product}        Format string     {{"BasePrice":{0},"IsLotSerialControl":false,"IsRewardPoint":false,"Note":"","Price":{0},"ProductId":{1},"Quantity":1,"ProductCode":"CNKH01","ProductName":"Chổi lau nhà tự động 3","OriginPrice":{0},"PriceByPromotion":null,"PromotionParentProductId":null,"ProductBatchExpireId":null,"CategoryId":50,"MasterProductId":{1},"Unit":"","Uuid":"","ProductWarranty":[]}}    ${item_gia_ban}    ${item_id_sp}
    \    Append To List      ${liststring_prs_order_detail}    ${payload_each_product}
    Return From Keyword    ${liststring_prs_order_detail}

create imei row
    [Arguments]    ${input_ma_sp}
    ${list_imei_by_each_product}    Create list
    : FOR    ${item}      IN RANGE      51
    \    ${list_imei_each_row}    Import multi imei for product    ${input_ma_sp}    1
    \    Append To List    ${list_imei_by_each_product}    ${list_imei_each_row}
    Return From Keyword    ${list_imei_by_each_product}

nhieudong
    [Arguments]    ${input_ma_kh}    ${dict_product_nums}    ${input_khtt}
    ${Uuid}      Generate Random String    4    [NUMBERS][NUMBERS]
    ${Uuid_code}      Catenate      SEPARATOR=      WA     ${Uuid}
    ${list_product}    Get Dictionary Keys    ${dict_product_nums}
    ${list_nums}    Get Dictionary Values    ${dict_product_nums}
    ${endpoint_danhmuc_hh_co_dvt}    Format String    ${endpoint_list_hh_in_mhbh}    ${BRANCH_ID}    ${BRANCH_ID}
    ${get_resp_danhmuc_hh}    Get Request and return body    ${endpoint_danhmuc_hh_co_dvt}
    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}    Get list jsonpath product frm list product    ${list_product}
    ${list_giaban}    ${list_id_sp}    Get product info frm list jsonpath product    ${get_resp_danhmuc_hh}    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}
    #post request
    ${liststring_prs_invoice_detail}     Create List
    : FOR    ${item_gia_ban}    ${item_id_sp}    IN ZIP    ${list_giaban}    ${list_id_sp}
    \    ${liststring_prs_invoice_detail}     create multi row       ${item_gia_ban}    ${item_id_sp}    ${liststring_prs_invoice_detail}
    ${liststring_prs_invoice_detail}    Convert List to String    ${liststring_prs_invoice_detail}
    Log     ${liststring_prs_invoice_detail}
    ${request_payload}    Format String    {{"Invoice":{{"BranchId":35,"RetailerId":19,"UpdateInvoiceId":0,"UpdateReturnId":0,"CustomerId":{0},"SoldById":47,"SoldBy":{{"CreatedBy":0,"CreatedDate":"2020-02-18T11:08:58.933Z","Email":"","GivenName":"anh.lv","Id":47,"IsActive":true,"IsAdmin":true,"Language":"vi-VN","MobilePhone":"","Type":0,"UserName":"admin","isDeleted":false}},"SaleChannelId":0,"Seller":{{"CreatedBy":0,"CreatedDate":"2020-02-18T11:08:58.933Z","Email":"","GivenName":"anh.lv","Id":47,"IsActive":true,"IsAdmin":true,"Language":"vi-VN","MobilePhone":"","Type":0,"UserName":"admin","isDeleted":false}},"OrderCode":"","Code":"Hóa đơn 1","InvoiceDetails":[{1}],"InvoiceOrderSurcharges":[],"InvoicePromotions":[],"Payments":[{{"Method":"Cash","MethodStr":"Tiền mặt","Amount":{2},"Id":-1}}],"Status":1,"Total":190000,"Surcharge":0,"Type":1,"Uuid":"{3}","addToAccount":"0","addToAccountSurplus":"0","addToAccountAllocation":"0","addToAccountPaymentAllocation":"0","PayingAmount":{2},"TotalBeforeDiscount":190000,"ProductDiscount":0,"DebugUuid":"","InvoiceWarranties":[],"CreatedBy":47}}}}
    ...    87    ${liststring_prs_invoice_detail}    ${input_khtt}    ${Uuid_code}
    Log    ${request_payload}
    : FOR    ${time}    IN RANGE    5
    \    ${get_current_time}    Get Current Date
    \    ${headers}=    Create Dictionary    Authorization=${bearertoken}    Content-Type=application/json;charset=UTF-8    Retailer=${RETAILER_NAME}    BranchId=${BRANCH_ID}    Zone=${env}
    \    Create Session    kiotvietapi    ${SALE_API_URL}    cookies=${resp.cookies}    verify=True    debug=1
    \    ${resp}=    Post Request    kiotvietapi    /invoices/save    data=${request_payload}    headers=${headers}
    \    Log    ${resp.request.body}
    \    Log    ${resp.json()}
    \    Log    ${resp.status_code}
    \    Should Be Equal As Strings    ${resp.status_code}    200
    \    ${get_current_time1}    Get Current Date
    \    Exit For Loop If    '${resp.status_code}'=='200'
    ${time_payment}   Subtract Date From Date    ${get_current_time1}    ${get_current_time}
    Return From Keyword    ${time_payment}
