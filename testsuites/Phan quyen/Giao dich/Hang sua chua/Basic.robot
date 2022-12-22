*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    ${headless_browser}
Test Setup
#Test Teardown     After Test
Library           Collections
Library           SeleniumLibrary
Resource          ../../../../config/env_product/envi.robot
Resource          ../../../../core/hang_hoa/hang_hoa_navigation.robot
Resource          ../../../../core/share/computation.robot
Resource          ../../../../core/Giao_dich/giaodich_nav.robot
Resource          ../../../../core/API/api_thietlap.robot
Resource          ../../../../core/Doi_Tac/doitac_navigation.robot
Resource          ../../../../core/So_Quy/so_quy_navigation.robot
Resource          ../../../../core/Bao_cao/bao_cao_navigation.robot
Resource          ../../../../core/share/toast_message.robot
Resource          ../../../../prepare/Hang_hoa/Sources/thietlap.robot
Resource          ../../../../core/Nhan_vien/nhanvien_navigation.robot
Resource          ../../../../core/Thiet_lap/thiet_lap_nav.robot
Resource          ../../../../core/Giao_dich/yeu_cau_sua_chua_list_action.robot
Resource          ../../../../core/API/api_yeucau_suachua.robot
Resource          ../../../../core/API/api_danhmuc_hanghoa.robot
Resource          ../../../../core/Ban_Hang/banhang_manager_navigation.robot
Resource          ../../../../core/API/api_access.robot

*** Variables ***

*** Test Cases ***
Xem DS
    [Documentation]     người dùng chỉ có quyền Hàng sửa chữa: Xem DS, Yêu cầu sửa chữa: Xem DS, Hàng hóa: Xem DS
    [Tags]      PQ2
    [Template]    pqhsc1
    userhsc1    123

Xem DS + Cập nhật
    [Documentation]     người dùng chỉ có quyền Hàng sửa chữa: Xem DS + Thêm mới + Cập nhật
    [Tags]       #PQ2
    [Template]    pqhsc2
    userhsc2   123         TPG14


*** Keywords ***
pqhsc1
    [Documentation]     người dùng chỉ có quyền Hàng sửa chữa: Xem DS, Yêu cầu sửa chữa: Xem DS, Hàng hóa: Xem DS
    [Arguments]    ${taikhoan}    ${matkhau}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"WarrantyOrder_Read":true,"WarrantyOrder_Create":false,"WarrantyOrder_Update":false,"WarrantyOrder_Delete":false,"WarrantyOrder_ViewPrice":false,"WarrantyOrder_UpdateExpire":false,"WarrantyOrder_CreateInvoice":false,"WarrantyOrder_Export":false,"WarrantyOrder_Print":false,"Clocking_Copy":false,"WarrantyRepairingProduct_Read":true,"WarrantyRepairingProduct_Update":false,"Product_Read":true}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    #
    Before Test Yeu Cau Sua Chua
    Wait Until Page Contains Element    ${tab_hanghoa}
    Element Should Not Be Visible    ${menu_doitac}
    Element Should Not Be Visible    ${domain_soquy}
    Element Should Not Be Visible    ${domain_baocao}
    Element Should Not Be Visible    ${menu_nhanvien}
    Element Should Not Be Visible    ${button_banhang_on_quanly}
    Click Element    ${tab_hanghoa}
    Delete user    ${get_user_id}

pqhsc2
    [Documentation]     người dùng chỉ có quyền Hàng sửa chữa: Xem DS + Cập nhật, Yêu cầu sửa chữa: Xem DS, Hàng hóa: Xem DS
    [Arguments]    ${taikhoan}    ${matkhau}    ${input_prouct}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"WarrantyOrder_Read":true,"WarrantyOrder_Create":false,"WarrantyOrder_Update":false,"WarrantyOrder_Delete":false,"WarrantyOrder_ViewPrice":false,"WarrantyOrder_UpdateExpire":false,"WarrantyOrder_CreateInvoice":false,"WarrantyOrder_Export":false,"WarrantyOrder_Print":false,"Clocking_Copy":false,"WarrantyRepairingProduct_Read":true,"WarrantyRepairingProduct_Update":true,"Product_Read":true}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    #
    ${get_ma_phieu}    Add new warranty order frm API    ${input_prouct}
    Before Test Yeu Cau Sua Chua
    Wait Until Page Contains Element    ${tab_hanghoa}    30s
    Element Should Not Be Visible    ${menu_doitac}
    Element Should Not Be Visible    ${domain_soquy}
    Element Should Not Be Visible    ${domain_baocao}
    Element Should Not Be Visible    ${menu_nhanvien}
    Element Should Not Be Visible    ${button_banhang_on_quanly}
    #
    Wait Until Keyword Succeeds    3 times    1s    Access button save product warranty succeed
    Delete user    ${get_user_id}
    Delete warranty order thr API       ${get_ma_phieu}
