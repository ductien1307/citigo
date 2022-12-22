*** Settings ***
Library           Collections
Library           RequestsLibrary
Library           SeleniumLibrary
Library           OperatingSystem
Library           String
Library           StringFormat
Library           JSONLibrary
Resource          ../share/computation.robot
Resource          api_access.robot
Resource          api_danhmuc_hanghoa.robot
Resource          api_thietlap.robot
Resource          api_khachhang.robot

*** Variables ***
${endpoint_yeucau_suachua}    /warranty-order?kvuniqueparam=2020
${endpoint_list_ycsc}     /warranty-order/transactions?kvuniqueparam=2020
${endpoint_delete_phieu_sc}    //warranty-order/{0}/cancel?kvuniqueparam=2020

*** Keywords ***
Add new warranty order frm API
    [Arguments]    ${input_product}
    ${get_product_id}     Get product id thr API    ${input_product}
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${Uuid}      Generate Random String    4    [NUMBERS][NUMBERS]
    ${Uuid_code}      Catenate      SEPARATOR=      WA     ${Uuid}
    ${payload}    Format string    {{"WarrantyOrder":{{"Code":null,"BranchId":{0},"RetailerId":{1},"CustomerCode":null,"SoldById":{2},"SaleChannelId":0,"UsingCod":0,"Payments":[],"TotalPayment":0,"Total":0,"Extra":"{{\\"Amount\\":0,\\"Method\\":{{\\"Id\\":\\"Cash\\",\\"Label\\":\\"Tiền mặt\\"}}}}","Surcharge":0,"Uuid":"","WarrantyReceptionPlace":1,"WarrantyOrderDetails":[{{"ProductId":{3},"ProductCode":"TPG01","Quantity":1,"WarrantyType":2,"DeliveredDate":"","Uuid":"{4}","Status":1,"Price":0}}],"InvoiceWarranties":[],"WarrantySurcharges":[],"CreatedBy":{2},"ModifiedBy":{3}}}}}     ${BRANCH_ID}    ${get_id_nguoitao}    ${get_id_nguoiban}   ${get_product_id}    ${Uuid_code}
    Log    ${payload}
    ${resp.json()}    Post request thr API    ${endpoint_yeucau_suachua}    ${payload}
    ${dict}    Set Variable    ${resp.json()}
    ${ma_phieu}    Get From Dictionary    ${dict}    Code
    Return From Keyword    ${ma_phieu}

Get warranty order id
    [Timeout]     3 minute
    [Arguments]    ${ma_phieu}
    ${endpoint_ds_phieu}    Format String    ${endpoint_list_ycsc}    ${BRANCH_ID}
    ${jsonpath_id_phieu}    Format String    $..Data[?(@.Code=="{0}")].Id    ${ma_phieu}
    ${get_phieu_id}    Get data from API by other url    ${WARRANTY_API}     ${endpoint_ds_phieu}    ${jsonpath_id_phieu}
    Return From Keyword    ${get_phieu_id}

Delete warranty order thr API
    [Timeout]     3 minute
    [Arguments]    ${ma_phieu}
    ${get_phieu_id}    Get warranty order id       ${ma_phieu}
    ${endpoint_delete_sc}    Format String    ${endpoint_delete_phieu_sc}      ${get_phieu_id}
    ${payload}    Format string   {{"orderId":{0},"IsVoidPayment":false,"CompareCode":"{1}"}}       ${get_phieu_id}    ${ma_phieu}
    Log    ${payload}
    ${headers}=    Create Dictionary    Authorization=${bearertoken}    Content-Type=application/json;charset=UTF-8    Retailer=${RETAILER_NAME}    BranchId=${BRANCH_ID}
    Create Session    lolo    ${WARRANTY_API}    verify=True    debug=1
    ${resp}=    Wait Until Keyword Succeeds    3x    0s     Post Request    lolo      ${endpoint_delete_sc}    data=${payload}    headers=${headers}
    Log    ${resp.request.body}
    Log    ${resp.json()}
    Log    ${resp.status_code}
    Should Be Equal As Strings    ${resp.status_code}    200

Add new warranty order have alternative product frm API
    [Arguments]    ${dict_sp}     ${dict_sp_thaythe}      ${input_ma_kh}      ${input_khtt}
    ${list_sp}      Get Dictionary Keys    ${dict_sp}
    ${list_num}     Get Dictionary Values    ${dict_sp}
    ${list_sp_thaythe}      Get Dictionary Keys    ${dict_sp_thaythe}
    ${list_num_thay_the}     Get Dictionary Values    ${dict_sp_thaythe}
    ${endpoint_pr}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${get_resp}    Get Request and return body    ${endpoint_pr}
    ${get_sp_id}    Get data from response json    ${get_resp}    $..Data[?(@.Code=="@{list_sp}[0]")].Id
    ${get_sp_thaythe_id}    Get data from response json    ${get_resp}    $..Data[?(@.Code=="@{list_sp_thaythe}[0]")].Id
    ${get_price_sp_thaythe}    Get data from response json    ${get_resp}    $..Data[?(@.Code=="@{list_sp_thaythe}[0]")].BasePrice
    ${total}      Multiplication and round    @{list_num_thay_the}[0]    ${get_price_sp_thaythe}
    ${get_price_sp_thaythe}     Replace floating point    ${get_price_sp_thaythe}
    ${total}     Replace floating point    ${total}
    ${result_khtt}      Set Variable If    '${input_khtt}'=='all'    ${total}     ${input_khtt}
    ${get_id_kh}      Get customer id thr API    ${input_ma_kh}
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${uuid}     Generate Random String      15      [NUMBERS]
    ${uuid_sp}       Generate Random String      15      [NUMBERS]
    ${uuid_sp_thaythe}       Generate Random String      15      [NUMBERS]
    ${payload}    Format string    {{"WarrantyOrder":{{"Code":null,"BranchId":{0},"RetailerId":{1},"CustomerId":{2},"Customer":{{"Id":{2},"Type":0,"Code":"KH000001","Name":"abc","Organization":"","RetailerId":{1},"CreatedDate":"","CreatedBy":{3},"LocationName":"","Uuid":"","IsActive":true,"BranchId":{0},"WardName":"","isDeleted":false,"Revision":"AAAAAB5McnY=","CustomerGroupDetails":[],"CustomerSocials":[],"PaymentAllocation":[],"IdOld":0,"CompareCode":"KH000001","CompareName":"abc","GenderName":"","MustUpdateDebt":false,"MustUpdatePoint":false,"InvoiceCount":0,"CusDiscountGroups":[]}},"CustomerCode":"KH000001","SoldById":{3},"SaleChannelId":0,"UsingCod":0,"Payments":[{{"Method":"Cash","MethodStr":"Tiền mặt","Amount":{4},"Id":-1}}],"TotalPayment":{4},"Total":{5},"Extra":"{{\\"Amount\\":{4},\\"Method\\":{{\\"Id\\":\\"Cash\\",\\"Label\\":\\"Tiền mặt\\"}}}}","Surcharge":0,"Uuid":"{11}","WarrantyReceptionPlace":1,"WarrantyOrderDetails":[{{"ProductId":{6},"ProductCode":"TPG01","Quantity":{7},"WarrantyType":2,"DeliveredDate":"","Uuid":"{12}","Status":1,"Price":{5}}},{{"ProductId":{8},"ProductCode":"TPG02","Quantity":{9},"Type":3,"ParentUuid":"{12}","Uuid":"{13}","Note":"","Price":{10}}}],"InvoiceWarranties":[],"WarrantySurcharges":[],"CreatedBy":{3},"ModifiedBy":{3}}}}}    ${BRANCH_ID}    ${get_id_nguoitao}    ${get_id_kh}   ${get_id_nguoiban}     ${result_khtt}     ${total}    ${get_sp_id}     @{list_num}[0]      ${get_sp_thaythe_id}     @{list_num_thay_the}[0]     ${get_price_sp_thaythe}      ${uuid}     ${uuid_sp}    ${uuid_sp_thaythe}
    Log    ${payload}
    ${headers}=    Create Dictionary    Authorization=${bearertoken}    Content-Type=application/json;charset=UTF-8    Retailer=${RETAILER_NAME}    BranchId=${BRANCH_ID}
    Create Session    lolo    ${WARRANTY_API}    verify=True    debug=1
    ${resp}=    Wait Until Keyword Succeeds    3x    0s     Post Request    lolo      ${endpoint_yeucau_suachua}    data=${payload}    headers=${headers}
    Log    ${resp.request.body}
    Log    ${resp.json()}
    Log    ${resp.status_code}
    Should Be Equal As Strings    ${resp.status_code}    200
    ${string}    Convert To String    ${resp.json()}
    ${dict}    Set Variable    ${resp.json()}
    ${ma_phieu}    Get From Dictionary    ${dict}    Code
    Return From Keyword    ${ma_phieu}

Add new warranty order with customer thr API
    [Arguments]    ${input_product}    ${input_ma_kh}
    ${get_product_id}     Get product id thr API    ${input_product}
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${get_id_kh}    Get customer id thr API    ${input_ma_kh}
    ${get_ten_kh}    ${get_dienthoai_kh}    ${get_diachi_kh}    ${get_khuvuc_kh}    ${get_phuongxa_kh}    Get info customer frm API    ${input_ma_kh}
    ${Uuid}      Generate Random String    4    [NUMBERS][NUMBERS]
    ${Uuid_code}      Catenate      SEPARATOR=      WA     ${Uuid}
    ${payload}    Format string    {{"WarrantyOrder":{{"Code":null,"BranchId":{0},"RetailerId":{1},"CustomerId":{2},"Customer":{{"Id":{2},"Type":0,"Code":"{3}","Name":"poi","Organization":"","RetailerId":{1},"Debt":1433335,"ModifiedDate":"2020-09-28T18:53:55.7800000+07:00","CreatedDate":"","CreatedBy":{4},"LocationName":"","Uuid":"","IsActive":true,"BranchId":{0},"WardName":"","LastTradingDate":"202","isDeleted":false,"Revision":"","CustomerGroupDetails":[],"CustomerSocials":[],"AddressBooks":[],"PaymentAllocation":[],"IdOld":0,"CompareCode":"{3}","CompareName":"poi","GenderName":"","MustUpdateDebt":false,"MustUpdatePoint":false,"InvoiceCount":0,"OldDebt":1433335,"CusDiscountGroups":[]}},"CustomerCode":"{3}","SoldById":{4},"SaleChannelId":0,"UsingCod":0,"Payments":[],"TotalPayment":0,"Total":0,"Extra":"{{\\"Amount\\":0,\\"Method\\":{{\\"Id\\":\\"Cash\\",\\"Label\\":\\"Tiền mặt\\"}}}}","Surcharge":0,"Uuid":"","WarrantyReceptionPlace":1,"WarrantyOrderDetails":[{{"ProductId":{5},"ProductCode":"{6}","Quantity":1,"WarrantyType":2,"DeliveredDate":"","Uuid":"{7}","Status":1,"Price":0}}],"InvoiceWarranties":[],"WarrantySurcharges":[],"CreatedBy":{4},"ModifiedBy":{4}}}}}
    ...    ${BRANCH_ID}    ${get_id_nguoitao}    ${get_id_kh}    ${input_ma_kh}    ${get_id_nguoiban}    ${get_product_id}    ${input_product}    ${Uuid_code}
    Log    ${payload}
    ${headers}=    Create Dictionary    Authorization=${bearertoken}    Content-Type=application/json;charset=UTF-8    Retailer=${RETAILER_NAME}    BranchId=${BRANCH_ID}
    Create Session    lolo    ${WARRANTY_API}    verify=True    debug=1
    ${resp}=    Wait Until Keyword Succeeds    3x    0s     Post Request    lolo      ${endpoint_yeucau_suachua}    data=${payload}    headers=${headers}
    Log    ${resp.request.body}
    Log    ${resp.json()}
    Log    ${resp.status_code}
    Should Be Equal As Strings    ${resp.status_code}    200
    ${string}    Convert To String    ${resp.json()}
    ${dict}    Set Variable    ${resp.json()}
    ${ma_phieu}    Get From Dictionary    ${dict}    Code
    Return From Keyword    ${ma_phieu}
