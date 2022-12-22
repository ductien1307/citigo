*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    ${headless_browser}
Test Teardown     After Test
Library           SeleniumLibrary
Resource         ../../../core/Thiet_lap/thiet_lap_nav.robot
Resource         ../../../core/Thiet_lap/nguoidung_list_page.robot
Resource         ../../../core/Thiet_lap/nguoidung_list_action.robot
Resource         ../../../core/API/api_thietlap.robot
Resource         ../../../core/API/api_access.robot
Resource         ../../../core/share/toast_message.robot
Resource         ../../../prepare/Hang_hoa/Sources/thietlap.robot
Resource         ../../../core/Thiet_lap/khuyenmai_list_page.robot
Resource         ../../../config/env_product/envi.robot
Resource         ../../../core/login/login_page.robot


*** Test Cases ***      Name         Password      Vai trò      Pass change
Change pass            [Tags]            OPT
                      [Template]    unactive_user
                      hong         123         Nhân viên kho    123456

*** Keywords ***
unactive_user
    [Arguments]    ${input_name}    ${input_pass}    ${input_role}    ${change_pass}
    Set Selenium Speed    1s
    ${get_user_id}    Get User ID by UserName    ${input_name}
    Run Keyword If    '${get_user_id}' == '0'    Log    Ignore     ELSE      Delete user    ${get_user_id}
    Create new user by role    ${input_name}    ${input_pass}    ${input_role}
    Sleep    2s
    ${get_user_id}    Get User ID by UserName    ${input_name}
    ${get_role_id}    Get role id by role name    ${input_role}
    ${get_retailer_id}    Get RetailerID
    ###
    Open Browser    ${URL}    ${BROWSER}    remote_url=${REMOTE_URL}
    Wait Until Keyword Succeeds    3 times    30 s    Access page    ${page_open}    Đăng nhập
    Maximize Browser Window
    Wait Until Keyword Succeeds    3 times    30 s    Login    ${input_name}    ${input_pass}
    ##
    ${data_str}    Format String     {{"User":{{"IdOld":0,"CompareGivenName":"Hương - Kế Toán","CompareIsLimitedByTrans":false,"CompareIsShowSumRow":true,"CompareUserName":"{5}","IsTimeSheetException":false,"Id":{0},"GivenName":"Hương - Kế Toán","CreatedDate":"","IsActive":true,"IsAdmin":false,"RetailerId":{1},"UserName":"{5}","Type":0,"CreatedBy":172395,"CanAccessAnySite":false,"UsedNativePrint":false,"InvalidLoginAttempts":0,"LocationName":"","WardName":"","IsShowSumRow":true,"IsLimitedByTrans":false,"isDeleted":false,"Permissions":[],"Apps":[],"Invoices":[],"Transfers1":[],"PriceBookUsers":[],"CashFlows":[],"Invoices1":[],"Orders":[],"Returns1":[],"Manufacturings":[],"DamageItems":[],"TokenApis":[],"SmsEmailTemplates":[],"BalanceAdjustments1":[],"PointAdjustments":[],"PointAdjustmentsCreatedBy":[],"NotificationSettings":[],"DamageItems1":[],"PurchaseOrders1":[],"PurchaseReturns1":[],"CostAdjustments":[],"Devices":[],"OrderSuppliers":[],"OrderSuppliers1":[],"UserDevices":[],"PayslipPayments":[],"PayslipPaymentAllocations":[],"IsActiveStatus":"Đang hoạt động","securedFunc":{{"":4,"Product":false,"StockTake":false,"WarrantyProduct":false,"uid":1,"parent":1,"init":1,"shouldSerialize":1,"forEach":1,"toJSON":1,"get":1,"set":1,"wrap":1,"constructor":"function Object() {{ [native code] }}1","bind":1,"one":1,"first":1,"trigger":1,"unbind":1,"Branch":false,"ExpensesOther":false,"PosParameter":false,"Surcharge":false,"PrintTemplate":false,"User":false,"SmsEmailTemplate":false,"AuditTrail":false,"DashBoard":false,"Manufacturing":false,"PriceBook":false,"DamageItem":false,"Invoice":false,"Order":false,"OrderSupplier":false,"Transfer":false,"PurchaseOrder":false,"PurchaseReturn":false,"Return":false,"WarrantyRepairingProduct":false,"WarrantyOrder":false,"Customer":false,"CustomerPointAdjustment":false,"CustomerAdjustment":false,"SupplierAdjustment":false,"DeliveryAdjustment":false,"Supplier":false,"PartnerDelivery":false,"PurchasePayment":true,"Payment":false,"FinancialReport":false,"UserReport":false,"SaleReport":false,"OrderReport":false,"EndOfDayReport":false,"SupplierReport":false,"SaleChannelReport":false,"ProductReport":false,"CustomerReport":false,"CashFlow":false,"Campaign":false,"VoucherCampaign":false,"Clocking":false,"Commission":false,"Employee":false,"FingerMachine":false,"FingerPrint":false,"FingerPrintLog":false,"PayRate":false,"Paysheet":false,"PayslipPayment":false,"Shift":false,"EmployeeAdjustment":false}},"privileges":{{"UserId":{0},"BranchId":{4},"Data":{{"Product_Read":true,"Product_Create":true,"Product_Update":true,"Product_Delete":true,"StockTake_Read":true,"StockTake_Create":true,"StockTake_Delete":false,"WarrantyProduct_Read":false,"WarrantyProduct_Update":false,"StockTake_Export":true,"StockTake_Inventory":true,"StockTake_Clone":false,"StockTake_Finish":false,"Product_PurchasePrice":false,"Product_Cost":true,"Product_Import":true,"Product_Export":false,"WarrantyProduct_Export":false,"Clocking_Copy":false,"PriceBook_Read":true,"PriceBook_Create":true,"PriceBook_Update":true,"PriceBook_Delete":true,"PriceBook_Import":false,"PriceBook_Export":false,"PurchaseOrder_Read":true,"PurchaseOrder_Create":true,"PurchaseOrder_Update":true,"PurchaseOrder_Delete":true,"PurchaseOrder_UpdatePurchaseOrder":false,"PurchaseOrder_Export":false,"PurchaseOrder_Clone":false,"PurchaseReturn_Read":true,"PurchaseReturn_Create":true,"PurchaseReturn_Update":true,"PurchaseReturn_Delete":true,"PurchaseReturn_Clone":false,"Transfer_Read":true,"Transfer_Create":true,"Transfer_Update":true,"Transfer_Delete":true,"Transfer_Export":false,"Transfer_Clone":false,"Transfer_Import":false,"Supplier_Read":true,"Supplier_Create":true,"Supplier_Update":true,"Supplier_Delete":true,"Supplier_MobilePhone":false,"Supplier_Import":false,"Supplier_Export":false,"SupplierAdjustment_Read":true,"SupplierAdjustment_Create":true,"SupplierAdjustment_Update":false,"SupplierAdjustment_Delete":false,"PurchasePayment_Create":true,"PurchasePayment_Delete":true,"PurchasePayment_Update":true}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","RoleId":{2},"userId":{0},"CompareGivenName":"Hương - Kế Toán","CompareUserName":"{5}"}},"TimeAccess":[{{"NumberOrder":0,"DayOfWeek":"Monday","Name":"Thứ hai","From":null,"To":null,"IsActive":false}},{{"NumberOrder":1,"DayOfWeek":"Tuesday","Name":"Thứ ba","From":null,"To":null,"IsActive":false}},{{"NumberOrder":2,"DayOfWeek":"Wednesday","Name":"Thứ tư","From":null,"To":null,"IsActive":false}},{{"NumberOrder":3,"DayOfWeek":"Thursday","Name":"Thứ năm","From":null,"To":null,"IsActive":false}},{{"NumberOrder":4,"DayOfWeek":"Friday","Name":"Thứ sáu","From":null,"To":null,"IsActive":false}},{{"NumberOrder":5,"DayOfWeek":"Saturday","Name":"Thứ bảy","From":null,"To":null,"IsActive":false}},{{"NumberOrder":6,"DayOfWeek":"Sunday","Name":"Chủ nhật","From":null,"To":null,"IsActive":false}}],"grey":{{"Product":true,"PriceBook":true,"StockTake":true,"PurchaseOrder":true,"PurchaseReturn":true,"Transfer":true,"Supplier":true,"SupplierAdjustment":true}},"locked":false,"temploc":"","tempw":"","PlainPassword":"{3}","RetypePassword":"{3}"}},"CompareUserName":"{5}","IncludeAllBranch":false}}    ${get_user_id}    ${get_retailer_id}    ${get_role_id}    ${change_pass}    ${BRANCH_ID}    ${input_name}
    log    ${data_str}
    ${headers1}=    Create Dictionary    Authorization=${bearertoken}    Content-Type=application/json;charset=utf-8
    Create Session    lolo    ${API_URL}    cookies=${resp.cookies}
    ${resp3}=    Post Request    lolo    /users    data=${data_str}    headers=${headers1}
    Log    ${resp3.request.body}
    Log    ${resp3.json()}
    log    ${resp3.status_code}
    Should Be Equal As Strings    ${resp3.status_code}    200
    Sleep    1s
    Reload Page
    Wait Until Element Is Visible    ${textbox_login_username}
    Delete user    ${get_user_id}
