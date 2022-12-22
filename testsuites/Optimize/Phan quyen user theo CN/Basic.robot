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
Resource          ../../../core/API/api_access.robot
Resource          ../../../core/Giao_dich/hoa_don_list_action.robot
Resource          ../../../core/Thiet_lap/branch_list_action.robot

*** Variables ***

*** Test Cases ***
Cập nhật user theo CN
    [Tags]      OPT1
    [Template]    cnqcn1
    [Timeout]
    le.dv    123     Nhánh A

*** Keywords ***
cnqcn1
    [Arguments]    ${taikhoan}    ${matkhau}      ${input_branchname}
    Log    Cập nhật Người dùng có quyền Hóa đơn: Xem DS, Thêm mới, Thay đổi giá, Cập nhật gghd; Khách hàng: Xem DS
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Quản trị chi nhánh
    ${get_branch_id}     Get BranchID by BranchName    ${input_branchname}
    ${get_retailer_id}      Get RetailerID
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"Branch_Read":true,"CashFlow_Read":true,"CashFlow_Create":true,"CashFlow_Update":true,"CashFlow_Delete":true,"Customer_Read":true,"Customer_Create":true,"Customer_Update":true,"Customer_Delete":true,"CustomerAdjustment_Read":true,"CustomerAdjustment_Create":true,"CustomerPointAdjustment_Read":true,"CustomerPointAdjustment_Update":true,"DashBoard_Read":true,"Invoice_Read":true,"Invoice_Create":true,"Invoice_Update":true,"Invoice_Delete":true,"Order_Read":true,"Order_Create":true,"Order_Update":true,"Order_Delete":true,"Payment_Create":true,"Payment_Update":true,"Payment_Delete":true,"PriceBook_Read":true,"PriceBook_Create":true,"PriceBook_Update":true,"PriceBook_Delete":true,"PrintTemplate_Read":true,"PrintTemplate_Update":true,"Product_Read":true,"Product_Create":true,"Product_Update":true,"Product_Delete":true,"PurchaseOrder_Read":true,"PurchaseOrder_Create":true,"PurchaseOrder_Update":true,"PurchaseOrder_Delete":true,"PurchasePayment_Create":true,"PurchasePayment_Update":true,"PurchaseReturn_Read":true,"PurchaseReturn_Create":true,"PurchaseReturn_Update":true,"PurchaseReturn_Delete":true,"Return_Read":true,"Return_Create":true,"Return_Update":true,"Return_Delete":true,"StockTake_Read":true,"StockTake_Create":true,"StockTake_Delete":true,"Supplier_Read":true,"Supplier_Create":true,"Supplier_Update":true,"Supplier_Delete":true,"SupplierAdjustment_Read":true,"SupplierAdjustment_Create":true,"Transfer_Read":true,"Transfer_Create":true,"Transfer_Update":true,"Transfer_Delete":true,"User_Read":true,"User_Create":true,"User_Update":true,"User_Delete":true,"ProductReport_ProductBySale":true,"ProductReport_ProducInOutStock":true,"ProductReport_ProducInOutStockDetail":true,"ProductReport_ProductByProfit":true,"ProductReport_ProductBySupplier":true,"EndOfDayReport_EndOfDaySynthetic":true,"SaleReport_SaleByTime":true,"SaleReport_SaleByUser":true,"Product_Cost":true,"Product_Import":true,"Invoice_ChangeDiscount":true,"StockTake_Finish":true,"Customer_ViewPhone":true,"Invoice_ReadOnHand":true,"Customer_UpdateGroup":true,"StockTake_Export":true,"Transfer_Import":true,"StockTake_Inventory":true,"User_Export":true,"Clocking_Copy":false}},"TimeAccess":[{{"IsChild":false,"Id":18927,"NumberOrder":0,"UserId":{0},"DayOfWeek":"Monday","Name":"Thứ hai","IsActive":false,"RetailerId":{3}}},{{"IsChild":false,"Id":18928,"NumberOrder":1,"UserId":{0},"DayOfWeek":"Tuesday","Name":"Thứ ba","IsActive":false,"RetailerId":{3}}},{{"IsChild":false,"Id":18929,"NumberOrder":2,"UserId":{0},"DayOfWeek":"Wednesday","Name":"Thứ tư","IsActive":false,"RetailerId":{3}}},{{"IsChild":false,"Id":18930,"NumberOrder":3,"UserId":{0},"DayOfWeek":"Thursday","Name":"Thứ năm","IsActive":false,"RetailerId":{3}}},{{"IsChild":false,"Id":18931,"NumberOrder":4,"UserId":{0},"DayOfWeek":"Friday","Name":"Thứ sáu","IsActive":false,"RetailerId":{3}}},{{"IsChild":false,"Id":18932,"NumberOrder":5,"UserId":{0},"DayOfWeek":"Saturday","Name":"Thứ bảy","IsActive":false,"RetailerId":{3}}},{{"IsChild":false,"Id":18933,"NumberOrder":6,"UserId":{0},"DayOfWeek":"Sunday","Name":"Chủ nhật","IsActive":false,"RetailerId":{3}}}],"BranchName":"Nhánh A","userId":{0},"CompareGivenName":"{4}","CompareUserName":"{4}"}}    ${get_user_id}     ${get_branch_id}   ${get_role_id}      ${get_retailer_id}      ${taikhoan}
    Log    ${payload}
    ${headers1}=    Create Dictionary    Authorization=${bearertoken}    Content-Type=application/json;charset=utf-8
    Create Session    lolo    ${API_URL}    cookies=${resp.cookies}
    ${resp3}=    Post Request    lolo    ${endpoint_update_quyen}    data=${payload}    headers=${headers1}
    Log    ${resp3.request.body}
    Log    ${resp3.json()}
    Log    ${resp3.status_code}
    Should Be Equal As Strings    ${resp3.status_code}    200
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    Before Test Hang Hoa
    #
    ${get_current_branch_name}    Get current branch name
    Wait Until Keyword Succeeds    3x    20 s    Switch Branch    ${get_current_branch_name}    ${input_branchname}
