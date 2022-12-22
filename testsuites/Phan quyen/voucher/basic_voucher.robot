*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    ${headless_browser}
Test Teardown     After Test
Library           SeleniumLibrary
Resource         ../../../core/Thiet_lap/thiet_lap_nav.robot
Resource         ../../../core/Thiet_lap/voucher_list_page.robot
Resource         ../../../core/Thiet_lap/voucher_list_action.robot
Resource         ../../../core/API/api_thietlap.robot
Resource         ../../../core/API/api_danhmuc_hanghoa.robot
Resource         ../../../core/share/javascript.robot
Resource         ../../../core/share/toast_message.robot
Resource         ../../../prepare/Hang_hoa/Sources/thietlap.robot


*** Test Cases ***
Xem DS
    [Documentation]     người dùng chỉ có quyền Voucher: Xem DS
    [Timeout]    2 mins
    [Tags]      PQ6
    [Template]    pqvoucher1
    voucher    123    VOUCHER003

Them moi
    [Documentation]    người dùng có quyền Voucher: Xem DS + Thêm mới
    [Timeout]    2 mins
    [Tags]    PQ6
    [Template]    pqvoucher2
    voucher    123    PHVC01    Phat hanh voucher1    25000    True    Bánh nhập KM    50000    True

Chinh Sua
    [Documentation]    người dùng có quyền Voucher: Xem DS + Cập nhật, quyền DMSP: xem DS
    [Timeout]    2 mins
    [Tags]    PQ6
    [Template]    pqvoucher3
    voucher    123    PHVC02    campain02    10000    50000    25000

Xoa
    [Documentation]    người dùng có quyền Voucher: Xem DS + Xóa
    [Timeout]    2 mins
    [Tags]    PQ6
    [Template]    pqvoucher4
    voucher    123    PHVC03    campain03    10000    50000

Phat hanh
    [Documentation]    người dùng có quyền Voucher: Xem DS + Cập nhật + Phát hành
    [Timeout]    2 mins
    [Tags]    PQ6
    [Template]    pqvoucher5
    voucher    123    PHVC07    campain03    10000    50000

*** Keywords ***
pqvoucher1
    [Documentation]     người dùng chỉ có quyền: xem DS
    [Arguments]    ${taikhoan}    ${matkhau}    ${input_voucher_code}
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role    ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"Campaign_Read":false,"Campaign_Update":false,"Campaign_Delete":false,"Invoice_Read":false,"Invoice_Create":false,"Invoice_Update":false,"Invoice_Delete":false,"Product_Read":false,"Product_Create":false,"Product_Update":false,"Product_Delete":false,"Product_PurchasePrice":false,"Product_Cost":false,"Product_Import":false,"Product_Export":false,"Invoice_Export":false,"Invoice_ReadOnHand":false,"Invoice_ChangePrice":false,"Invoice_ChangeDiscount":false,"Invoice_ModifySeller":false,"Invoice_UpdateCompleted":false,"Invoice_RepeatPrint":false,"Invoice_CopyInvoice":false,"Invoice_UpdateWarranty":false,"Invoice_Import":false,"Clocking_Copy":false,"Campaign_Create":false,"VoucherCampaign_Read":true}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    #
    Set Selenium Speed    0.2
    Before Test Quan ly
    Go to any thiet lap    ${button_quanly_voucher}
    Go to search voucher form    ${input_voucher_code}
    Wait Until Element Is Visible    ${checkbox_filter_trangthai_tatca}
    Click Element JS    ${checkbox_filter_trangthai_tatca}
    Sleep    2s
    Element Should Not Be Visible    ${menu_giaodich}
    Element Should Not Be Visible    ${menu_doitac}
    Element Should Not Be Visible    ${domain_soquy}
    Element Should Not Be Visible    ${domain_baocao}
    Element Should Not Be Visible    ${button_banhang_on_quanly}
    Element Should Not Be Visible    ${button_themmoi_all_form}
    Element Should Not Be Visible    ${button_capnhat_voucher}
    Element Should Not Be Visible    ${button_delete_voucher}
    Delete user    ${get_user_id}

pqvoucher2
    [Documentation]     người dùng  có quyền voucher: xem DS + thêm mới, va quyền DMSP: xem DS
    [Arguments]    ${taikhoan}    ${matkhau}    ${input_voucher_code}    ${input_voucher_name}    ${input_value}    ${input_status}   ${input_nhomhang}    ${input_totalsale}    ${input_status_gop_voucher}
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role    ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"PriceBook_Read":false,"PriceBook_Create":false,"PriceBook_Update":false,"PriceBook_Delete":false,"Product_Read":true,"Product_Create":false,"Product_Update":false,"Product_Delete":false,"PurchaseOrder_Read":false,"PurchaseOrder_Create":false,"PurchaseOrder_Update":false,"PurchaseOrder_Delete":false,"PurchasePayment_Create":false,"PurchasePayment_Update":false,"PurchasePayment_Delete":false,"PurchaseReturn_Read":false,"PurchaseReturn_Create":false,"PurchaseReturn_Update":false,"PurchaseReturn_Delete":false,"StockTake_Read":false,"StockTake_Create":false,"Supplier_Read":false,"Supplier_Create":false,"Supplier_Update":false,"Supplier_Delete":false,"SupplierAdjustment_Read":false,"SupplierAdjustment_Create":false,"Transfer_Read":false,"Transfer_Create":false,"Transfer_Update":false,"Transfer_Delete":false,"Product_Cost":false,"Product_Import":false,"StockTake_Finish":false,"StockTake_Export":false,"StockTake_Inventory":false,"Clocking_Copy":false,"Supplier_MobilePhone":false,"Supplier_Import":false,"Supplier_Export":false,"SupplierAdjustment_Update":false,"SupplierAdjustment_Delete":false,"Transfer_Export":false,"Transfer_Clone":false,"Transfer_Import":false,"PurchaseReturn_Clone":false,"PurchaseOrder_UpdatePurchaseOrder":false,"PurchaseOrder_Export":false,"PurchaseOrder_Clone":false,"StockTake_Delete":false,"StockTake_Clone":false,"PriceBook_Import":false,"PriceBook_Export":false,"Product_PurchasePrice":false,"Product_Export":false,"VoucherCampaign_Read":true,"VoucherCampaign_Create":true}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    #toi form them moi
    ${get_id_voucher}    Get voucher campaign id    ${input_voucher_code}
    Log    ${get_id_voucher}
    Run Keyword If    '${get_id_voucher}' == '0'    Log    Ignore     ELSE    Delete voucher campaign    ${input_voucher_code}
    Set Selenium Speed    0.2
    Before Test Quan ly
    Go to any thiet lap    ${button_quanly_voucher}
    Click Element JS   ${button_themmoi_all_form}
    Input text    ${textbox_voucher_code}   ${input_voucher_code}
    Input text     ${textbox_voucher_name}   ${input_voucher_name}
    Input text    ${textbox_voucher_menhgia}   ${input_value}
    Run Keyword If    '${input_status}' == 'False'     Click Element JS    ${checkbox_voucher_chuaapdung}    ELSE    Log     Ignore click
    Select category from Chon nhom hang popup    ${button_chonnhomhang}    ${input_nhomhang}
    Input text    ${textbox_tongtienhang}   ${input_totalsale}
    Run Keyword If    '${input_status_gop_voucher}' == 'True'     Click Element JS    ${checkbox_voucher_gop_voucher}    ELSE    Log     Ignore click
    Wait Until Element Is Visible    ${button_voucher_save}
    Click Element JS        ${button_voucher_save}
    #kiểm tra thêm mới thành công
    Voucher message success validation
    ${get_voucher_id}    Get voucher campaign info and validate    ${input_voucher_code}   ${input_voucher_name}    ${input_totalsale}    ${input_value}
    Delete voucher campaign    ${input_voucher_code}
    Delete user    ${get_user_id}

pqvoucher3
    [Documentation]     người dùng  có quyền voucher: xem DS, chỉnh sửa
    [Arguments]    ${taikhoan}    ${matkhau}    ${input_voucher_code}    ${input_voucher_name}    ${input_value}    ${input_totalsale}    ${input_value_new}
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role    ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"PriceBook_Read":false,"PriceBook_Create":false,"PriceBook_Update":false,"PriceBook_Delete":false,"Product_Read":false,"Product_Create":false,"Product_Update":false,"Product_Delete":false,"PurchaseOrder_Read":false,"PurchaseOrder_Create":false,"PurchaseOrder_Update":false,"PurchaseOrder_Delete":false,"PurchasePayment_Create":false,"PurchasePayment_Update":false,"PurchasePayment_Delete":false,"PurchaseReturn_Read":false,"PurchaseReturn_Create":false,"PurchaseReturn_Update":false,"PurchaseReturn_Delete":false,"StockTake_Read":false,"StockTake_Create":false,"Supplier_Read":false,"Supplier_Create":false,"Supplier_Update":false,"Supplier_Delete":false,"SupplierAdjustment_Read":false,"SupplierAdjustment_Create":false,"Transfer_Read":false,"Transfer_Create":false,"Transfer_Update":false,"Transfer_Delete":false,"Product_Cost":false,"Product_Import":false,"StockTake_Finish":false,"StockTake_Export":false,"StockTake_Inventory":false,"Clocking_Copy":false,"Supplier_MobilePhone":false,"Supplier_Import":false,"Supplier_Export":false,"SupplierAdjustment_Update":false,"SupplierAdjustment_Delete":false,"Transfer_Export":false,"Transfer_Clone":false,"Transfer_Import":false,"PurchaseReturn_Clone":false,"PurchaseOrder_UpdatePurchaseOrder":false,"PurchaseOrder_Export":false,"PurchaseOrder_Clone":false,"StockTake_Delete":false,"StockTake_Clone":false,"PriceBook_Import":false,"PriceBook_Export":false,"Product_PurchasePrice":false,"Product_Export":false,"VoucherCampaign_Read":true,"VoucherCampaign_Create":false,"VoucherCampaign_Update":true}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    #toi form chinh sua
    ${get_id_voucher}    Get voucher campaign id    ${input_voucher_code}
    Log    ${get_id_voucher}
    Run Keyword If    '${get_id_voucher}' == '0'    Log    Ignore     ELSE    Delete voucher campaign    ${input_voucher_code}
    Create voucher issue    ${input_voucher_code}    ${input_voucher_name}    ${input_value}    ${input_totalsale}
    Set Selenium Speed    0.2
    Before Test Quan ly
    Go to any thiet lap    ${button_quanly_voucher}
    Go to update voucher form    ${input_voucher_code}
    Input data    ${textbox_voucher_menhgia}   ${input_value_new}
    Wait Until Element Is Visible    ${button_voucher_save}
    Click Element JS        ${button_voucher_save}
    Voucher message success validation
    ${get_voucher_id}    Get voucher campaign info and validate    ${input_voucher_code}   ${input_voucher_name}    ${input_totalsale}    ${input_value_new}
    Delete voucher campaign    ${input_voucher_code}
    Delete user    ${get_user_id}

pqvoucher4
    [Documentation]     người dùng  có quyền voucher: xem DS, xóa
    [Arguments]    ${taikhoan}    ${matkhau}    ${input_voucher_code}    ${input_voucher_name}    ${input_value}    ${input_totalsale}
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role    ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"PriceBook_Read":false,"PriceBook_Create":false,"PriceBook_Update":false,"PriceBook_Delete":false,"Product_Read":false,"Product_Create":false,"Product_Update":false,"Product_Delete":false,"PurchaseOrder_Read":false,"PurchaseOrder_Create":false,"PurchaseOrder_Update":false,"PurchaseOrder_Delete":false,"PurchasePayment_Create":false,"PurchasePayment_Update":false,"PurchasePayment_Delete":false,"PurchaseReturn_Read":false,"PurchaseReturn_Create":false,"PurchaseReturn_Update":false,"PurchaseReturn_Delete":false,"StockTake_Read":false,"StockTake_Create":false,"Supplier_Read":false,"Supplier_Create":false,"Supplier_Update":false,"Supplier_Delete":false,"SupplierAdjustment_Read":false,"SupplierAdjustment_Create":false,"Transfer_Read":false,"Transfer_Create":false,"Transfer_Update":false,"Transfer_Delete":false,"Product_Cost":false,"Product_Import":false,"StockTake_Finish":false,"StockTake_Export":false,"StockTake_Inventory":false,"Clocking_Copy":false,"Supplier_MobilePhone":false,"Supplier_Import":false,"Supplier_Export":false,"SupplierAdjustment_Update":false,"SupplierAdjustment_Delete":false,"Transfer_Export":false,"Transfer_Clone":false,"Transfer_Import":false,"PurchaseReturn_Clone":false,"PurchaseOrder_UpdatePurchaseOrder":false,"PurchaseOrder_Export":false,"PurchaseOrder_Clone":false,"StockTake_Delete":false,"StockTake_Clone":false,"PriceBook_Import":false,"PriceBook_Export":false,"Product_PurchasePrice":false,"Product_Export":false,"VoucherCampaign_Read":true,"VoucherCampaign_Create":false,"VoucherCampaign_Update":false,"VoucherCampaign_Delete":true}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    #
    ${get_id_voucher}    Get voucher campaign id    ${input_voucher_code}
    Log    ${get_id_voucher}
    Run Keyword If    '${get_id_voucher}' == '0'    Log    Ignore     ELSE    Delete voucher campaign    ${input_voucher_code}
    Create voucher issue    ${input_voucher_code}    ${input_voucher_name}    ${input_value}    ${input_totalsale}
    Set Selenium Speed    0.2
    Before Test Quan ly
    Go to any thiet lap    ${button_quanly_voucher}
    Go to search voucher form    ${input_voucher_code}
    Wait Until Element Is Visible    ${button_delete_voucher}
    Click Element JS        ${button_delete_voucher}
    Wait Until Element Is Visible    ${button_dongy_del_voucher}
    Click Element JS        ${button_dongy_del_voucher}
    Message delete voucher success validation
    Delete user    ${get_user_id}

pqvoucher5
    [Documentation]     người dùng  có quyền voucher: Xem DS, cập nhật, phát hành
    [Arguments]    ${taikhoan}    ${matkhau}    ${input_voucher_code}    ${input_voucher_name}    ${input_value}    ${input_totalsale}
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role    ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"PriceBook_Read":false,"PriceBook_Create":false,"PriceBook_Update":false,"PriceBook_Delete":false,"Product_Read":false,"Product_Create":false,"Product_Update":false,"Product_Delete":false,"PurchaseOrder_Read":false,"PurchaseOrder_Create":false,"PurchaseOrder_Update":false,"PurchaseOrder_Delete":false,"PurchasePayment_Create":false,"PurchasePayment_Update":false,"PurchasePayment_Delete":false,"PurchaseReturn_Read":false,"PurchaseReturn_Create":false,"PurchaseReturn_Update":false,"PurchaseReturn_Delete":false,"StockTake_Read":false,"StockTake_Create":false,"Supplier_Read":false,"Supplier_Create":false,"Supplier_Update":false,"Supplier_Delete":false,"SupplierAdjustment_Read":false,"SupplierAdjustment_Create":false,"Transfer_Read":false,"Transfer_Create":false,"Transfer_Update":false,"Transfer_Delete":false,"Product_Cost":false,"Product_Import":false,"StockTake_Finish":false,"StockTake_Export":false,"StockTake_Inventory":false,"Clocking_Copy":false,"Supplier_MobilePhone":false,"Supplier_Import":false,"Supplier_Export":false,"SupplierAdjustment_Update":false,"SupplierAdjustment_Delete":false,"Transfer_Export":false,"Transfer_Clone":false,"Transfer_Import":false,"PurchaseReturn_Clone":false,"PurchaseOrder_UpdatePurchaseOrder":false,"PurchaseOrder_Export":false,"PurchaseOrder_Clone":false,"StockTake_Delete":false,"StockTake_Clone":false,"PriceBook_Import":false,"PriceBook_Export":false,"Product_PurchasePrice":false,"Product_Export":false,"VoucherCampaign_Read":true,"VoucherCampaign_Create":false,"VoucherCampaign_Update":true,"VoucherCampaign_Delete":false,"VoucherCampaign_Release":true}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    #
    ${get_id_voucher}    Get voucher campaign id    ${input_voucher_code}
    Log    ${get_id_voucher}
    Run Keyword If    '${get_id_voucher}' == '0'    Log    Ignore     ELSE    Delete voucher campaign    ${input_voucher_code}
    Create voucher issue    ${input_voucher_code}    ${input_voucher_name}    ${input_value}    ${input_totalsale}
    ${voucher_code}=    Add new voucher code    ${input_voucher_code}    1
    Set Selenium Speed    0.2
    Before Test Quan ly
    Go to any thiet lap    ${button_quanly_voucher}
    Go to publish voucher    ${input_voucher_code}    ${voucher_code}    ${input_value}
    Message publish voucher code success validation
    Click Element    ${button_close_popup}
    Return voucher code by API    ${input_voucher_code}    ${voucher_code}
    Delete voucher campaign    ${input_voucher_code}
    Delete user    ${get_user_id}
