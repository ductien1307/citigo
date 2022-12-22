*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    ${headless_browser}
Test Setup
Test Teardown     After Test
Library           Collections
Resource          ../../../config/env_product/envi.robot
Resource          ../../../core/hang_hoa/hang_hoa_navigation.robot
Resource          ../../../core/hang_hoa/hang_hoa_add_action.robot
Resource          ../../../core/hang_hoa/danh_muc_list_action.robot
Resource          ../../../core/share/computation.robot
Resource          ../../../core/Giao_dich/giaodich_nav.robot
Resource          ../../../core/API/api_danhmuc_hanghoa.robot
Resource          ../../../core/API/api_thietlap.robot
Resource          ../../../core/share/toast_message.robot

*** Variables ***


*** Test Cases ***
Cập nhật quyền chức năng của user
    [Documentation]
    [Tags]      OPT1
    [Template]    cnqql1
    [Timeout]
    hang.pt    123

Cập nhật quyền xem giao dịch của user khác
    [Documentation]
    [Tags]    OPT1
    [Template]    cnqql2
    [Timeout]
    hang.pt    123

Cập nhật quyền xem thông tin chung giao dịch
    [Documentation]
    [Tags]      OPT1
    [Template]    cnqql3
    [Timeout]
    hang.pt    123

*** Keywords ***
cnqql1
    [Arguments]    ${taikhoan}    ${matkhau}
    Log    Login MHQL với tk user và add sp
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    Before Test Hang Hoa
    #
    Log    Cập nhật quyền xem ds + thêm mới hh
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Quản trị chi nhánh
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"Branch_Read":false,"Customer_Read":false,"Customer_Create":false,"Customer_Update":false,"Customer_Delete":false,"CustomerAdjustment_Read":false,"CustomerAdjustment_Create":false,"CustomerPointAdjustment_Read":false,"CustomerPointAdjustment_Update":false,"DashBoard_Read":false,"Invoice_Read":false,"Invoice_Create":false,"Invoice_Update":false,"Invoice_Delete":false,"Order_Read":false,"Order_Create":false,"Order_Update":false,"Order_Delete":false,"Payment_Create":false,"Payment_Update":false,"Payment_Delete":false,"PriceBook_Read":false,"PriceBook_Create":false,"PriceBook_Update":false,"PriceBook_Delete":false,"Product_Read":true,"Product_Create":true,"Product_Update":false,"Product_Delete":false,"PurchaseOrder_Read":false,"PurchaseOrder_Create":false,"PurchaseOrder_Update":false,"PurchaseOrder_Delete":false,"PurchasePayment_Create":false,"PurchasePayment_Update":false,"PurchaseReturn_Read":false,"PurchaseReturn_Create":false,"PurchaseReturn_Update":false,"PurchaseReturn_Delete":false,"Return_Read":false,"Return_Create":false,"Return_Update":false,"Return_Delete":false,"StockTake_Read":false,"StockTake_Create":false,"StockTake_Delete":false,"Supplier_Read":false,"Supplier_Create":false,"Supplier_Update":false,"Supplier_Delete":false,"SupplierAdjustment_Read":false,"SupplierAdjustment_Create":false,"Transfer_Read":false,"Transfer_Create":false,"Transfer_Update":false,"Transfer_Delete":false,"User_Read":false,"User_Create":false,"User_Update":false,"User_Delete":false,"Product_Cost":false,"Product_Import":false,"Invoice_ReadOnHand":false,"Invoice_ChangeDiscount":false,"Customer_ViewPhone":false,"Customer_UpdateGroup":false,"EndOfDayReport_EndOfDaySynthetic":false,"EndOfDayReport_EndOfDayProduct":false,"EndOfDayReport_EndOfDayCashFlow":false,"EndOfDayReport_EndOfDayDocument":false,"OrderReport_ByDocReport":false,"OrderReport_ByProductReport":false,"SaleReport_SaleByUser":false,"SaleReport_SaleByTime":false,"SaleReport_BranchSaleReport":false,"ProductReport_ProducInOutStock":false,"ProductReport_ProducInOutStockDetail":false,"ProductReport_ProductByProfit":false,"ProductReport_ProductBySale":false,"CustomerReport_CustomerSale":false,"Transfer_Import":false,"StockTake_Inventory":false,"User_Export":false,"Clocking_Copy":false,"Branch_Create":false,"Branch_Update":false,"Branch_Delete":false,"Customer_Import":false,"Customer_Export":false,"CustomerAdjustment_Update":false,"CustomerAdjustment_Delete":false,"Supplier_MobilePhone":false,"Supplier_Import":false,"Supplier_Export":false,"SupplierAdjustment_Update":false,"SupplierAdjustment_Delete":false,"PurchasePayment_Delete":false,"CustomerReport_BigCustomerDebt":false,"CustomerReport_CustomerProduct":false,"CustomerReport_CustomerProfit":false,"ProductReport_ProducStockInOutStock":false,"ProductReport_ProductByBatchExpire":false,"ProductReport_ProductByCustomer":false,"ProductReport_ProductByDamageItem":false,"ProductReport_ProductBySupplier":false,"ProductReport_ProductByUser":false,"SaleReport_SaleProfitByInvoice":false,"SaleReport_SaleDiscountByInvoice":false,"SaleReport_SaleByRefund":false,"Transfer_Export":false,"Transfer_Clone":false,"PurchaseReturn_Clone":false,"PurchaseOrder_UpdatePurchaseOrder":false,"PurchaseOrder_Export":false,"PurchaseOrder_Clone":false,"Return_RepeatPrint":false,"Return_CopyReturn":false,"Return_Export":false,"Invoice_Export":false,"Invoice_ChangePrice":false,"Invoice_ModifySeller":false,"Invoice_UpdateCompleted":false,"Invoice_RepeatPrint":false,"Invoice_CopyInvoice":false,"Invoice_UpdateWarranty":false,"Order_RepeatPrint":false,"Order_Export":false,"Order_MakeInvoice":false,"Order_CopyOrder":false,"Order_UpdateWarranty":false,"StockTake_Export":false,"StockTake_Clone":false,"StockTake_Finish":false,"PriceBook_Import":false,"PriceBook_Export":false}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}   ${get_user_id}    ${BRANCH_ID}    ${get_role_id}     ${taikhoan}
    Log    ${payload}
    ${headers1}=    Create Dictionary    Authorization=${bearertoken}    Content-Type=application/json;charset=utf-8
    Create Session    lolo    ${API_URL}    cookies=${resp.cookies}
    ${resp3}=    Post Request    lolo    ${endpoint_update_quyen}    data=${payload}    headers=${headers1}
    Log    ${resp3.request.body}
    Log    ${resp3.json()}
    Log    ${resp3.status_code}
    Should Be Equal As Strings    ${resp3.status_code}    200
    #
    Log    check forge logout
    Click Element    ${button_them_moi}
    Wait Until Page Contains Element    ${button_them_hh}    10s
    Click Element       ${button_them_hh}
    Wait Until Page Contains Element    ${button_quanly}    20s
    Login       ${USER_NAME}      ${PASSWORD}

cnqql2
    [Arguments]    ${taikhoan}    ${matkhau}
    Log    Login MHQL với tk user và add sp
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    Before Test Hang Hoa
    #
    Log    Cập nhật xem giao dịch của nv khác
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_nguoitao_id}     Get RetailerID
    ${get_nguoiban_id}     Get User ID
    ${payload}    Format String    {{"User":{{"IdOld":0,"CompareGivenName":"{0}","CompareIsLimitedByTrans":true,"CompareIsShowSumRow":false,"CompareUserName":"{0}","IsTimeSheetException":false,"Id":{1},"GivenName":"{0}","CreatedDate":"","IsActive":true,"IsAdmin":false,"RetailerId":{2},"UserName":"{0}","Type":0,"CreatedBy":{3},"CanAccessAnySite":false,"Language":"vi-VN","LocationName":"","WardName":"","IsShowSumRow":true,"IsLimitedByTrans":true,"isDeleted":false,"Permissions":[],"Apps":[],"Invoices":[],"Transfers1":[],"PriceBookUsers":[],"CashFlows":[],"Invoices1":[],"Orders":[],"Returns1":[],"Manufacturings":[],"DamageItems":[],"TokenApis":[],"SmsEmailTemplates":[],"BalanceAdjustments1":[],"PointAdjustments":[],"PointAdjustmentsCreatedBy":[],"NotificationSettings":[],"DamageItems1":[],"PurchaseOrders1":[],"PurchaseReturns1":[],"CostAdjustments":[],"Devices":[],"OrderSuppliers":[],"OrderSuppliers1":[],"UserDevices":[],"PayslipPayments":[],"PayslipPaymentAllocations":[],"IsActiveStatus":"Đang hoạt động","securedFunc":{{"Product":false,"TableAndRoom":4,"Branch":false,"ExpensesOther":false,"PosParameter":false,"Surcharge":false,"PrintTemplate":false,"User":false,"SmsEmailTemplate":false,"AuditTrail":false,"DashBoard":false,"Manufacturing":false,"PriceBook":false,"StockTake":false,"WarrantyProduct":false,"DamageItem":false,"Invoice":false,"Order":false,"OrderSupplier":false,"Transfer":false,"PurchaseOrder":false,"PurchaseReturn":false,"Return":false,"WarrantyRepairingProduct":false,"WarrantyOrder":false,"Customer":false,"CustomerPointAdjustment":false,"CustomerAdjustment":false,"SupplierAdjustment":false,"DeliveryAdjustment":false,"Supplier":false,"PartnerDelivery":false,"PurchasePayment":false,"Payment":false,"FinancialReport":false,"UserReport":false,"SaleReport":false,"OrderReport":false,"EndOfDayReport":false,"SupplierReport":false,"SaleChannelReport":false,"ProductReport":false,"CustomerReport":false,"CashFlow":false,"Campaign":false,"VoucherCampaign":false,"Clocking":false,"Commission":false,"Employee":false,"FingerMachine":false,"FingerPrint":false,"FingerPrintLog":false,"PayRate":false,"Paysheet":false,"PayslipPayment":false,"Shift":false,"EmployeeAdjustment":false}},"privileges":{{"UserId":{1},"BranchId":11352,"RoleId":33043,"Data":{{"Product_Read":true,"Product_Create":true,"TableAndRoom_Read":true,"TableAndRoom_Create":true,"TableAndRoom_Update":true,"TableAndRoom_Delete":true,"Clocking_Copy":false}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm"}},"grey":{{"Product":true}},"TimeAccess":[{{"NumberOrder":0,"DayOfWeek":"Monday","Name":"Thứ hai","From":null,"To":null,"IsActive":false}},{{"NumberOrder":1,"DayOfWeek":"Tuesday","Name":"Thứ ba","From":null,"To":null,"IsActive":false}},{{"NumberOrder":2,"DayOfWeek":"Wednesday","Name":"Thứ tư","From":null,"To":null,"IsActive":false}},{{"NumberOrder":3,"DayOfWeek":"Thursday","Name":"Thứ năm","From":null,"To":null,"IsActive":false}},{{"NumberOrder":4,"DayOfWeek":"Friday","Name":"Thứ sáu","From":null,"To":null,"IsActive":false}},{{"NumberOrder":5,"DayOfWeek":"Saturday","Name":"Thứ bảy","From":null,"To":null,"IsActive":false}},{{"NumberOrder":6,"DayOfWeek":"Sunday","Name":"Chủ nhật","From":null,"To":null,"IsActive":false}}],"locked":false,"temploc":"","tempw":"","PlainPassword":"","RetypePassword":""}},"CompareUserName":"{0}","IncludeAllBranch":false}}      ${taikhoan}   ${get_user_id}    ${get_nguoitao_id}      ${get_nguoiban_id}
    Log    ${payload}
    ${headers1}=    Create Dictionary    Authorization=${bearertoken}    Content-Type=application/json;charset=utf-8
    Create Session    lolo    ${API_URL}    cookies=${resp.cookies}
    ${resp3}=    Post Request    lolo    /users    data=${payload}    headers=${headers1}
    Log    ${resp3.request.body}
    Log    ${resp3.json()}
    Log    ${resp3.status_code}
    Should Be Equal As Strings    ${resp3.status_code}    200
    #
    Log    check forge logout
    Click Element    ${button_them_moi}
    Wait Until Page Contains Element    ${button_them_hh}    10s
    Click Element       ${button_them_hh}
    Wait Until Page Contains Element    ${button_quanly}    20s
    Login       ${USER_NAME}      ${PASSWORD}

cnqql3
    [Arguments]    ${taikhoan}    ${matkhau}
    Log    Login MHQL với tk user và add sp
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    Before Test Hang Hoa
    #
    Log    Cập nhật quyền xem thông tin chung
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_nguoitao_id}     Get RetailerID
    ${get_nguoiban_id}     Get User ID
    ${payload}    Format String    {{"User":{{"IdOld":0,"CompareGivenName":"{0}","CompareIsLimitedByTrans":true,"CompareIsShowSumRow":true,"CompareUserName":"{0}","IsTimeSheetException":false,"Id":{1},"GivenName":"{0}","CreatedDate":"","IsActive":true,"IsAdmin":false,"RetailerId":{2},"UserName":"{0}","Type":0,"CreatedBy":{3},"CanAccessAnySite":false,"Language":"vi-VN","LocationName":"","WardName":"","IsShowSumRow":false,"IsLimitedByTrans":true,"isDeleted":false,"Permissions":[],"Apps":[],"Invoices":[],"Transfers1":[],"PriceBookUsers":[],"CashFlows":[],"Invoices1":[],"Orders":[],"Returns1":[],"Manufacturings":[],"DamageItems":[],"TokenApis":[],"SmsEmailTemplates":[],"BalanceAdjustments1":[],"PointAdjustments":[],"PointAdjustmentsCreatedBy":[],"NotificationSettings":[],"DamageItems1":[],"PurchaseOrders1":[],"PurchaseReturns1":[],"CostAdjustments":[],"Devices":[],"OrderSuppliers":[],"OrderSuppliers1":[],"UserDevices":[],"PayslipPayments":[],"PayslipPaymentAllocations":[],"IsActiveStatus":"Đang hoạt động","securedFunc":{{"Product":false,"TableAndRoom":4,"Branch":false,"ExpensesOther":false,"PosParameter":false,"Surcharge":false,"PrintTemplate":false,"User":false,"SmsEmailTemplate":false,"AuditTrail":false,"DashBoard":false,"Manufacturing":false,"PriceBook":false,"StockTake":false,"WarrantyProduct":false,"DamageItem":false,"Invoice":false,"Order":false,"OrderSupplier":false,"Transfer":false,"PurchaseOrder":false,"PurchaseReturn":false,"Return":false,"WarrantyRepairingProduct":false,"WarrantyOrder":false,"Customer":false,"CustomerPointAdjustment":false,"CustomerAdjustment":false,"SupplierAdjustment":false,"DeliveryAdjustment":false,"Supplier":false,"PartnerDelivery":false,"PurchasePayment":false,"Payment":false,"FinancialReport":false,"UserReport":false,"SaleReport":false,"OrderReport":false,"EndOfDayReport":false,"SupplierReport":false,"SaleChannelReport":false,"ProductReport":false,"CustomerReport":false,"CashFlow":false,"Campaign":false,"VoucherCampaign":false,"Clocking":false,"Commission":false,"Employee":false,"FingerMachine":false,"FingerPrint":false,"FingerPrintLog":false,"PayRate":false,"Paysheet":false,"PayslipPayment":false,"Shift":false,"EmployeeAdjustment":false}},"privileges":{{"UserId":{1},"BranchId":11352,"RoleId":33043,"Data":{{"Product_Read":true,"Product_Create":true,"TableAndRoom_Read":true,"TableAndRoom_Create":true,"TableAndRoom_Update":true,"TableAndRoom_Delete":true,"Clocking_Copy":false}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm"}},"grey":{{"Product":true}},"TimeAccess":[{{"NumberOrder":0,"DayOfWeek":"Monday","Name":"Thứ hai","From":null,"To":null,"IsActive":false}},{{"NumberOrder":1,"DayOfWeek":"Tuesday","Name":"Thứ ba","From":null,"To":null,"IsActive":false}},{{"NumberOrder":2,"DayOfWeek":"Wednesday","Name":"Thứ tư","From":null,"To":null,"IsActive":false}},{{"NumberOrder":3,"DayOfWeek":"Thursday","Name":"Thứ năm","From":null,"To":null,"IsActive":false}},{{"NumberOrder":4,"DayOfWeek":"Friday","Name":"Thứ sáu","From":null,"To":null,"IsActive":false}},{{"NumberOrder":5,"DayOfWeek":"Saturday","Name":"Thứ bảy","From":null,"To":null,"IsActive":false}},{{"NumberOrder":6,"DayOfWeek":"Sunday","Name":"Chủ nhật","From":null,"To":null,"IsActive":false}}],"temploc":"","tempw":"","PlainPassword":"","RetypePassword":""}},"CompareUserName":"{0}","IncludeAllBranch":false}}      ${taikhoan}   ${get_user_id}    ${get_nguoitao_id}      ${get_nguoiban_id}
    Log    ${payload}
    ${headers1}=    Create Dictionary    Authorization=${bearertoken}    Content-Type=application/json;charset=utf-8
    Create Session    lolo    ${API_URL}    cookies=${resp.cookies}
    ${resp3}=    Post Request    lolo    /users    data=${payload}    headers=${headers1}
    Log    ${resp3.request.body}
    Log    ${resp3.json()}
    Log    ${resp3.status_code}
    Should Be Equal As Strings    ${resp3.status_code}    200
    #
    Log    check forge logout
    Click Element    ${button_them_moi}
    Wait Until Page Contains Element    ${button_them_hh}    10s
    Click Element       ${button_them_hh}
    Wait Until Page Contains Element    ${button_quanly}    20s
    Login       ${USER_NAME}      ${PASSWORD}
