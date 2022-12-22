*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    ${headless_browser}
Test Setup
Test Teardown     After Test
Library           Collections
Resource          ../../../config/env_product/envi.robot
Resource          ../../../core/share/computation.robot
Resource          ../../../core/Giao_dich/giaodich_nav.robot
Resource          ../../../core/API/api_danhmuc_hanghoa.robot
Resource          ../../../core/API/api_thietlap.robot
Resource          ../../../core/share/toast_message.robot
Resource          ../../../core/API/api_mhbh.robot
Resource          ../../../core/Giao_dich/hoa_don_list_action.robot
Resource          ../../../prepare/Hang_hoa/Sources/thietlap.robot

*** Variables ***
&{invoice_1}      TPD023=6

*** Test Cases ***
Cập nhật quyền chức năng của user
    [Documentation]    Cập nhật người dùng có quyền Hóa đơn: Xem DS, Thêm mới, Thay đổi giá, Cập nhật gghd; Khách hàng: Xem DS
    [Tags]      OPT1
    [Template]    cnqbh1
    [Timeout]
    testopt    123     ${invoice_1}

Cập nhật quyền xem giao dịch của user khác
    [Documentation]
    [Tags]    OPT1
    [Template]    cnqbh2
    [Timeout]
    testopt    123     ${invoice_1}

Cập nhật quyền xem thông tin chung giao dịch
    [Documentation]
    [Tags]      OPT1
    [Template]    cnqbh3
    [Timeout]
    testopt    123     ${invoice_1}

*** Keywords ***
cnqbh1
    [Arguments]    ${taikhoan}    ${matkhau}    ${dict_product_num}
    Log    Login MHBH với tk user và add sp
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}       Nhân viên thu ngân
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    Before Test Ban Hang
    ${list_products}    Get Dictionary Keys    ${dict_product_num}
    ${list_nums}    Get Dictionary Values    ${dict_product_num}
    ${lastest_num}    Set Variable    0
    : FOR    ${item_product}     ${item_num}    IN ZIP    ${list_products}      ${list_nums}
    \    ${lastest_num}=    Input product-num in BH form    ${item_product}    ${item_num}      ${lastest_num}
    #
    Log    Cập nhật Người dùng có quyền Hóa đơn: Xem DS, Thêm mới, Thay đổi giá, Cập nhật gghd; Khách hàng: Xem DS
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Quản trị chi nhánh
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"Customer_Read":true,"Invoice_Create":true,"Order_Read":false,"Order_Create":false,"Order_Update":false,"TableAndRoom_Read":true,"TableAndRoom_Create":true,"TableAndRoom_Update":true,"TableAndRoom_Delete":true,"Invoice_ChangePrice":true,"Invoice_ChangeDiscount":true,"Order_MakeInvoice":false,"Clocking_Copy":false,"StockTake_Read":false,"StockTake_Create":false,"StockTake_Delete":false,"StockTake_Export":false,"StockTake_Inventory":false,"StockTake_Clone":false,"StockTake_Finish":false,"Order_Delete":false,"Order_RepeatPrint":false,"Order_Export":false,"Order_CopyOrder":false,"Order_UpdateWarranty":false,"Invoice_Read":true}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}      ${taikhoan}
    Log    ${payload}
    ${headers1}=    Create Dictionary    Authorization=${bearertoken}    Content-Type=application/json;charset=utf-8
    Create Session    lolo    ${API_URL}    cookies=${resp.cookies}
    ${resp3}=    Post Request    lolo    ${endpoint_update_quyen}    data=${payload}    headers=${headers1}
    Log    ${resp3.request.body}
    Log    ${resp3.json()}
    Log    ${resp3.status_code}
    Should Be Equal As Strings    ${resp3.status_code}    200
    #
    Log    thanh toan và check forge logout
    Click Element JS    ${button_bh_thanhtoan}
    Wait Until Page Contains Element    ${button_banhang_login}    20s
    Login MHBH     ${USER_NAME}    ${PASSWORD}

cnqbh2
    [Arguments]    ${taikhoan}    ${matkhau}    ${dict_product_num}
    Log    Login MHBH với tk user và add sp
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    Before Test Ban Hang
    ${list_products}    Get Dictionary Keys    ${dict_product_num}
    ${list_nums}    Get Dictionary Values    ${dict_product_num}
    ${lastest_num}    Set Variable    0
    : FOR    ${item_product}     ${item_num}    IN ZIP    ${list_products}      ${list_nums}
    \    ${lastest_num}=    Input product-num in BH form    ${item_product}    ${item_num}      ${lastest_num}
    #
    Log    Cập nhật quyền xem giao dịch của nv khác
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_nguoitao_id}     Get RetailerID
    ${get_nguoiban_id}     Get User ID
    ${payload}    Format String    {{"User":{{"IdOld":0,"CompareGivenName":"{0}","CompareIsLimitedByTrans":false,"CompareIsShowSumRow":true,"CompareUserName":"{0}","IsTimeSheetException":false,"Id":{1},"GivenName":"{0}","CreatedDate":"","IsActive":true,"IsAdmin":false,"RetailerId":{2},"UserName":"{0}","Type":0,"CreatedBy":{3},"CanAccessAnySite":false,"Language":"vi-VN","LocationName":"","WardName":"","IsShowSumRow":true,"isDeleted":false,"Permissions":[],"Apps":[],"Invoices":[],"Transfers1":[],"PriceBookUsers":[],"CashFlows":[],"Invoices1":[],"Orders":[],"Returns1":[],"Manufacturings":[],"DamageItems":[],"TokenApis":[],"SmsEmailTemplates":[],"BalanceAdjustments1":[],"PointAdjustments":[],"PointAdjustmentsCreatedBy":[],"NotificationSettings":[],"DamageItems1":[],"PurchaseOrders1":[],"PurchaseReturns1":[],"CostAdjustments":[],"Devices":[],"OrderSuppliers":[],"OrderSuppliers1":[],"UserDevices":[],"PayslipPayments":[],"PayslipPaymentAllocations":[],"IsActiveStatus":"Đang hoạt động","securedFunc":{{"Invoice":false,"Return":false,"TableAndRoom":4,"Branch":false,"ExpensesOther":false,"PosParameter":false,"Surcharge":false,"PrintTemplate":false,"User":false,"SmsEmailTemplate":false,"AuditTrail":false,"DashBoard":false,"Manufacturing":false,"Product":false,"PriceBook":false,"StockTake":false,"WarrantyProduct":false,"DamageItem":false,"Order":false,"OrderSupplier":false,"Transfer":false,"PurchaseOrder":false,"PurchaseReturn":false,"WarrantyRepairingProduct":false,"WarrantyOrder":false,"Customer":false,"CustomerPointAdjustment":false,"CustomerAdjustment":false,"SupplierAdjustment":false,"DeliveryAdjustment":false,"Supplier":false,"PartnerDelivery":false,"PurchasePayment":false,"Payment":false,"FinancialReport":false,"UserReport":false,"SaleReport":false,"OrderReport":false,"EndOfDayReport":false,"SupplierReport":false,"SaleChannelReport":false,"ProductReport":false,"CustomerReport":false,"CashFlow":false,"Campaign":false,"VoucherCampaign":false,"Clocking":false,"Commission":false,"Employee":false,"FingerMachine":false,"FingerPrint":false,"FingerPrintLog":false,"PayRate":false,"Paysheet":false,"PayslipPayment":false,"Shift":false,"EmployeeAdjustment":false}},"privileges":{{"UserId":{1},"BranchId":11352,"RoleId":33043,"Data":{{"Invoice_Read":true,"Return_Read":true,"Return_Create":true,"TableAndRoom_Read":true,"TableAndRoom_Create":true,"TableAndRoom_Update":true,"TableAndRoom_Delete":true,"Return_CopyReturn":true,"Clocking_Copy":false,"Invoice_Create":true}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{1},"CompareGivenName":"{0}","CompareUserName":"{0}"}},"grey":{{"Invoice":true,"Return":true}},"TimeAccess":[{{"NumberOrder":0,"DayOfWeek":"Monday","Name":"Thứ hai","From":null,"To":null,"IsActive":false}},{{"NumberOrder":1,"DayOfWeek":"Tuesday","Name":"Thứ ba","From":null,"To":null,"IsActive":false}},{{"NumberOrder":2,"DayOfWeek":"Wednesday","Name":"Thứ tư","From":null,"To":null,"IsActive":false}},{{"NumberOrder":3,"DayOfWeek":"Thursday","Name":"Thứ năm","From":null,"To":null,"IsActive":false}},{{"NumberOrder":4,"DayOfWeek":"Friday","Name":"Thứ sáu","From":null,"To":null,"IsActive":false}},{{"NumberOrder":5,"DayOfWeek":"Saturday","Name":"Thứ bảy","From":null,"To":null,"IsActive":false}},{{"NumberOrder":6,"DayOfWeek":"Sunday","Name":"Chủ nhật","From":null,"To":null,"IsActive":false}}],"locked":false,"temploc":"","tempw":"","IsLimitedByTrans":true,"PlainPassword":"","RetypePassword":""}},"CompareUserName":"{0}","IncludeAllBranch":false}}       ${taikhoan}   ${get_user_id}    ${get_nguoitao_id}      ${get_nguoiban_id}
    Log    ${payload}
    ${headers1}=    Create Dictionary    Authorization=${bearertoken}    Content-Type=application/json;charset=utf-8
    Create Session    lolo    ${API_URL}    cookies=${resp.cookies}
    ${resp3}=    Post Request    lolo    /users    data=${payload}    headers=${headers1}
    Log    ${resp3.request.body}
    Log    ${resp3.json()}
    Log    ${resp3.status_code}
    Should Be Equal As Strings    ${resp3.status_code}    200
    #
    Log    thanh toan và check forge logout
    Click Element JS    ${button_bh_thanhtoan}
    Wait Until Page Contains Element    ${button_banhang_login}    20s
    Login MHBH     ${USER_NAME}    ${PASSWORD}

cnqbh3
    [Arguments]    ${taikhoan}    ${matkhau}    ${dict_product_num}
    Log    Login MHBH với tk user và add sp
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    Before Test Ban Hang
    ${list_products}    Get Dictionary Keys    ${dict_product_num}
    ${list_nums}    Get Dictionary Values    ${dict_product_num}
    ${lastest_num}    Set Variable    0
    : FOR    ${item_product}     ${item_num}    IN ZIP    ${list_products}      ${list_nums}
    \    ${lastest_num}=    Input product-num in BH form    ${item_product}    ${item_num}      ${lastest_num}
    #
    Log    Cập nhật quyền xem thông tin chung gd
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_nguoitao_id}     Get RetailerID
    ${get_nguoiban_id}     Get User ID
    ${payload}    Format String    {{"User":{{"IdOld":0,"CompareGivenName":"{0}","CompareIsLimitedByTrans":false,"CompareIsShowSumRow":true,"CompareUserName":"{0}","IsTimeSheetException":false,"Id":{1},"GivenName":"{0}","CreatedDate":"","IsActive":true,"IsAdmin":false,"RetailerId":{2},"UserName":"{0}","Type":0,"CreatedBy":{3},"CanAccessAnySite":false,"Language":"vi-VN","LocationName":"","WardName":"","IsShowSumRow":false,"isDeleted":false,"Permissions":[],"Apps":[],"Invoices":[],"Transfers1":[],"PriceBookUsers":[],"CashFlows":[],"Invoices1":[],"Orders":[],"Returns1":[],"Manufacturings":[],"DamageItems":[],"TokenApis":[],"SmsEmailTemplates":[],"BalanceAdjustments1":[],"PointAdjustments":[],"PointAdjustmentsCreatedBy":[],"NotificationSettings":[],"DamageItems1":[],"PurchaseOrders1":[],"PurchaseReturns1":[],"CostAdjustments":[],"Devices":[],"OrderSuppliers":[],"OrderSuppliers1":[],"UserDevices":[],"PayslipPayments":[],"PayslipPaymentAllocations":[],"IsActiveStatus":"Đang hoạt động","securedFunc":{{"Invoice":false,"Return":false,"TableAndRoom":4,"Branch":false,"ExpensesOther":false,"PosParameter":false,"Surcharge":false,"PrintTemplate":false,"User":false,"SmsEmailTemplate":false,"AuditTrail":false,"DashBoard":false,"Manufacturing":false,"Product":false,"PriceBook":false,"StockTake":false,"WarrantyProduct":false,"DamageItem":false,"Order":false,"OrderSupplier":false,"Transfer":false,"PurchaseOrder":false,"PurchaseReturn":false,"WarrantyRepairingProduct":false,"WarrantyOrder":false,"Customer":false,"CustomerPointAdjustment":false,"CustomerAdjustment":false,"SupplierAdjustment":false,"DeliveryAdjustment":false,"Supplier":false,"PartnerDelivery":false,"PurchasePayment":false,"Payment":false,"FinancialReport":false,"UserReport":false,"SaleReport":false,"OrderReport":false,"EndOfDayReport":false,"SupplierReport":false,"SaleChannelReport":false,"ProductReport":false,"CustomerReport":false,"CashFlow":false,"Campaign":false,"VoucherCampaign":false,"Clocking":false,"Commission":false,"Employee":false,"FingerMachine":false,"FingerPrint":false,"FingerPrintLog":false,"PayRate":false,"Paysheet":false,"PayslipPayment":false,"Shift":false,"EmployeeAdjustment":false}},"privileges":{{"UserId":{1},"BranchId":11352,"RoleId":33043,"Data":{{"Invoice_Read":true,"Return_Read":true,"Return_Create":true,"TableAndRoom_Read":true,"TableAndRoom_Create":true,"TableAndRoom_Update":true,"TableAndRoom_Delete":true,"Return_CopyReturn":true,"Clocking_Copy":false,"Invoice_Create":true}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{1},"CompareGivenName":"{0}","CompareUserName":"{0}"}},"grey":{{"Invoice":true,"Return":true}},"TimeAccess":[{{"NumberOrder":0,"DayOfWeek":"Monday","Name":"Thứ hai","From":null,"To":null,"IsActive":false}},{{"NumberOrder":1,"DayOfWeek":"Tuesday","Name":"Thứ ba","From":null,"To":null,"IsActive":false}},{{"NumberOrder":2,"DayOfWeek":"Wednesday","Name":"Thứ tư","From":null,"To":null,"IsActive":false}},{{"NumberOrder":3,"DayOfWeek":"Thursday","Name":"Thứ năm","From":null,"To":null,"IsActive":false}},{{"NumberOrder":4,"DayOfWeek":"Friday","Name":"Thứ sáu","From":null,"To":null,"IsActive":false}},{{"NumberOrder":5,"DayOfWeek":"Saturday","Name":"Thứ bảy","From":null,"To":null,"IsActive":false}},{{"NumberOrder":6,"DayOfWeek":"Sunday","Name":"Chủ nhật","From":null,"To":null,"IsActive":false}}],"temploc":"","tempw":"","IsLimitedByTrans":true,"PlainPassword":"","RetypePassword":""}},"CompareUserName":"{0}","IncludeAllBranch":false}}       ${taikhoan}   ${get_user_id}   ${get_nguoitao_id}      ${get_nguoiban_id}
    Log    ${payload}
    ${headers1}=    Create Dictionary    Authorization=${bearertoken}    Content-Type=application/json;charset=utf-8
    Create Session    lolo    ${API_URL}    cookies=${resp.cookies}
    ${resp3}=    Post Request    lolo    /users    data=${payload}    headers=${headers1}
    Log    ${resp3.request.body}
    Log    ${resp3.json()}
    Log    ${resp3.status_code}
    Should Be Equal As Strings    ${resp3.status_code}    200
    #
    Log    thanh toan và check forge logout
    Click Element JS    ${button_bh_thanhtoan}
    Wait Until Page Contains Element    ${button_banhang_login}    20s
    Login MHBH     ${USER_NAME}    ${PASSWORD}
