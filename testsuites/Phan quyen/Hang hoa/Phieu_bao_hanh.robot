*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    ${headless_browser}
Test Setup
Test Teardown     After Test
Library           Collections
Library           SeleniumLibrary
Resource          ../../../config/env_product/envi.robot
Resource          ../../../core/hang_hoa/hang_hoa_navigation.robot
Resource          ../../../core/share/computation.robot
Resource          ../../../core/Giao_dich/giaodich_nav.robot
Resource          ../../../core/API/api_thietlap.robot
Resource          ../../../core/Doi_Tac/doitac_navigation.robot
Resource          ../../../core/So_Quy/so_quy_navigation.robot
Resource          ../../../core/Bao_cao/bao_cao_navigation.robot
Resource          ../../../core/share/toast_message.robot
Resource          ../../../prepare/Hang_hoa/Sources/thietlap.robot
Resource          ../../../core/Nhan_vien/nhanvien_navigation.robot
Resource          ../../../core/Thiet_lap/thiet_lap_nav.robot
Resource          ../../../core/Hang_hoa/phieu_bao_hanh_list_action.robot
Resource          ../../../core/API/api_mhbh.robot
Resource          ../../../core/Ban_Hang/banhang_manager_navigation.robot

*** Variables ***
&{dict_bh}    TPBH009=1

*** Test Cases ***
Xem DS
    [Documentation]     người dùng chỉ có quyền Phiếu bảo hành: Xem DS
    [Tags]      PQ2
    [Template]    pqpbh1
    userpbh1    123

Xem DS + Cập nhật
    [Documentation]     người dùng chỉ có quyền Phiếu bảo hành: Xem DS + Cập nhật, Hóa đơn: Xem DS + Thêm mới + Cập nhật
    [Tags]      PQ2
    [Template]    pqpbh2
    userpbh2     123    ${dict_bh}

Xem DS + Xuất file 1
    [Documentation]     người dùng chỉ có quyền Phiếu bảo hành: Xem DS + Xuất file, Hóa đơn: Xem DS
    [Tags]      PQ2
    [Template]    pqpbh3
    userpbh3   123      ${dict_bh}

Xem DS + Xuất file 2
    [Documentation]     người dùng chỉ có quyền Phiếu bảo hành: Xem DS + Xuất file, Hóa đơn: Xem DS + Thêm mới
    [Tags]      PQ2
    [Template]    pqpbh4
    userpbh3   123    ${dict_bh}

*** Keywords ***
pqpbh1
    [Documentation]     người dùng chỉ có quyền Phiếu bảo hành: Xem DS
    [Arguments]    ${taikhoan}    ${matkhau}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"StockTake_Read":false,"StockTake_Create":false,"StockTake_Finish":false,"Clocking_Copy":false,"StockTake_Delete":false,"StockTake_Export":false,"StockTake_Inventory":false,"StockTake_Clone":false,"WarrantyProduct_Read":true,"WarrantyProduct_Update":false,"WarrantyProduct_Export":false}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    #
    Before Test PHieu bao hanh
    Element Should Not Be Visible    ${menu_giaodich}
    Element Should Not Be Visible    ${menu_doitac}
    Element Should Not Be Visible    ${domain_soquy}
    Element Should Not Be Visible    ${menu_nhanvien}
    Element Should Not Be Visible    ${domain_baocao}
    Element Should Not Be Visible    ${button_banhang_on_quanly}
    Element Should Not Be Visible    ${button_xuatile_ds_pbh}
    Delete user    ${get_user_id}

pqpbh2
    [Documentation]     người dùng chỉ có quyền Phiếu bảo hành: Xem DS + Cập nhật, Hóa đơn: Xem DS + Thêm mới + Cập nhật
    [Arguments]    ${taikhoan}    ${matkhau}    ${dict_product_num}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"Invoice_Read":true,"WarrantyProduct_Read":true,"WarrantyProduct_Update":true,"Clocking_Copy":false,"Product_Update":false,"Product_Read":false,"Invoice_Update":true,"Invoice_Create":true,"Invoice_Delete":false,"Invoice_Export":false,"Invoice_ReadOnHand":false,"Invoice_ChangePrice":false,"Invoice_ChangeDiscount":false,"Invoice_ModifySeller":false,"Invoice_UpdateCompleted":false,"Invoice_RepeatPrint":false,"Invoice_CopyInvoice":false,"Invoice_UpdateWarranty":true,"Invoice_Import":false,"Product_Create":false,"Product_Delete":false,"Product_PurchasePrice":false,"Product_Cost":false,"Product_Import":false,"Product_Export":false}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    #
    ${invoice_code}   Add new invoice without customer have warranty thr API    ${dict_product_num}   0
    Before Test PHieu bao hanh
    Element Should Be Visible    ${menu_giaodich}
    Element Should Not Be Visible    ${menu_doitac}
    Element Should Not Be Visible    ${domain_soquy}
    Element Should Not Be Visible    ${menu_nhanvien}
    Element Should Not Be Visible    ${domain_baocao}
    Element Should Be Visible    ${button_banhang_on_quanly}
    Element Should Not Be Visible    ${button_xuatile_ds_pbh}
    Wait Until Page Contains Element    ${textbox_search_mahang}    30s
    Input data    ${textbox_search_mahang}      @{dict_product_num}[0]
    ${status}     Run Keyword And Return Status    Element Should Be Visible    ${button_capnhat_pbh}     20s
    Run Keyword If    '${status}'!='True'   Wait Until Keyword Succeeds     3 times    1s    Access button update warranty
    Wait Until Keyword Succeeds    3 times    1s    Click Element    ${button_capnhat_pbh}
    Wait Until Page Contains Element    ${button_luu_capnhat}    30s
    Click Element    ${button_luu_capnhat}
    Update data success validation
    Delete invoice by invoice code      ${invoice_code}
    Delete user    ${get_user_id}

pqpbh3
    [Documentation]     người dùng chỉ có quyền Phiếu bảo hành: Xem DS + Xuất file, Hóa đơn: Xem DS
    [Arguments]    ${taikhoan}    ${matkhau}    ${dict_product_num}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"Invoice_Read":true,"WarrantyProduct_Read":true,"WarrantyProduct_Update":false,"Clocking_Copy":false,"Product_Update":false,"Product_Read":false,"Invoice_Update":false,"Invoice_Create":false,"Invoice_Delete":false,"Invoice_Export":false,"Invoice_ReadOnHand":false,"Invoice_ChangePrice":false,"Invoice_ChangeDiscount":false,"Invoice_ModifySeller":false,"Invoice_UpdateCompleted":false,"Invoice_RepeatPrint":false,"Invoice_CopyInvoice":false,"Invoice_UpdateWarranty":false,"Invoice_Import":false,"Product_Create":false,"Product_Delete":false,"Product_PurchasePrice":false,"Product_Cost":false,"Product_Import":false,"Product_Export":false,"WarrantyProduct_Export":true}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    #
    ${invoice_code}   Add new invoice without customer have warranty thr API    ${dict_product_num}   0
    Before Test PHieu bao hanh
    Wait Until Page Contains Element    ${button_xuatile_ds_pbh}    30s
    Element Should Be Visible    ${menu_giaodich}
    Element Should Not Be Visible    ${menu_doitac}
    Element Should Not Be Visible    ${domain_soquy}
    Element Should Not Be Visible    ${menu_nhanvien}
    Element Should Not Be Visible    ${domain_baocao}
    Element Should Not Be Visible    ${button_banhang_on_quanly}
    Go to select export file warranty    ${button_xuatfile_tongquan_pbh}
    Wait Until Keyword Succeeds    3 times    3s    Element Should Contain      //span[@class='ng-binding txtRed']    Xuất file lỗi: Không có quyền truy cập bản ghi với người dùng ${taikhoan}
    Delete invoice by invoice code      ${invoice_code}
    Delete user    ${get_user_id}

pqpbh4
    [Documentation]     người dùng chỉ có quyền Phiếu bảo hành: Xem DS + Xuất file, Hóa đơn: Xem DS + Thêm mới
    [Arguments]    ${taikhoan}    ${matkhau}    ${dict_product_num}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"Invoice_Read":true,"WarrantyProduct_Read":true,"WarrantyProduct_Update":false,"Clocking_Copy":false,"Product_Update":false,"Product_Read":false,"Invoice_Update":false,"Invoice_Create":true,"Invoice_Delete":false,"Invoice_Export":false,"Invoice_ReadOnHand":false,"Invoice_ChangePrice":false,"Invoice_ChangeDiscount":false,"Invoice_ModifySeller":false,"Invoice_UpdateCompleted":false,"Invoice_RepeatPrint":false,"Invoice_CopyInvoice":false,"Invoice_UpdateWarranty":false,"Invoice_Import":false,"Product_Create":false,"Product_Delete":false,"Product_PurchasePrice":false,"Product_Cost":false,"Product_Import":false,"Product_Export":false,"WarrantyProduct_Export":true}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    #
    ${invoice_code}   Add new invoice without customer have warranty thr API    ${dict_product_num}   0
    Before Test PHieu bao hanh
    Wait Until Page Contains Element    ${button_xuatile_ds_pbh}    30s
    Element Should Be Visible    ${menu_giaodich}
    Element Should Not Be Visible    ${menu_doitac}
    Element Should Not Be Visible    ${domain_soquy}
    Element Should Not Be Visible    ${menu_nhanvien}
    Element Should Not Be Visible    ${domain_baocao}
    Element Should Be Visible    ${button_banhang_on_quanly}
    Go to select export file warranty    ${button_xuatfile_tongquan_pbh}
    Wait Until Keyword Succeeds    3 times    3s    Element Should Contain    ${noti_export}    Nhấn vào đây để tải xuống
    Delete invoice by invoice code      ${invoice_code}
    Delete user    ${get_user_id}
