*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    ${headless_browser}
Test Setup
Test Teardown     After Test
Library           Collections
Library           SeleniumLibrary
Resource          ../../../config/env_product/envi.robot
Resource          ../../../core/hang_hoa/hang_hoa_navigation.robot
Resource          ../../../core/hang_hoa/hang_hoa_add_action.robot
Resource          ../../../core/hang_hoa/danh_muc_list_action.robot
Resource          ../../../core/share/computation.robot
Resource          ../../../core/Giao_dich/giaodich_nav.robot
Resource          ../../../core/API/api_danhmuc_hanghoa.robot
Resource          ../../../core/API/api_thietlap.robot
Resource          ../../../core/Doi_Tac/doitac_navigation.robot
Resource          ../../../core/Giao_dich/giaodich_nav.robot
Resource          ../../../core/So_Quy/so_quy_navigation.robot
Resource          ../../../core/Bao_cao/bao_cao_navigation.robot
Resource          ../../../core/share/toast_message.robot
Resource          ../../../core/Giao_dich/nhaphang_getandcompute.robot
Resource          ../../../prepare/Hang_hoa/Sources/thietlap.robot
Resource          ../../../core/Nhan_vien/nhanvien_navigation.robot
Resource          ../../../core/Thiet_lap/thiet_lap_nav.robot
Resource          ../../../core/Thiet_lap/thukhac_list_action.robot

*** Variables ***

*** Test Cases ***
Xem DS
    [Documentation]     ng ười dùng chỉ có quyền Tích hợp kênh bán: Xem DS
    [Tags]      PQ1
    [Template]    pqthkb1
    userthkb1    123

Xem DS + Thêm mới
    [Documentation]     người dùng chỉ có quyền Tích hợp kênh bán: Xem DS + Thêm mới
    [Tags]      PQ1
    [Template]    pqthkb2
    userthkb2    123

Xem DS + Cập nhật + Xóa
    [Documentation]     người dùng chỉ có quyền Tích hợp kênh bán: Xem DS + Cập nhật + Xóa
    [Tags]      PQ1
    [Template]    pqthkb3
    userthkb3    123

*** Keywords ***
pqthkb1
    [Documentation]     người dùng chỉ có quyền Tích hợp kênh bán: Xem DS
    [Arguments]    ${taikhoan}    ${matkhau}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"SalesChannelIntegrate_Read":true,"Clocking_Copy":false}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    Before Test Quan ly
    #
    Log    validate UI
    Element Should Not Be Visible    ${menu_giaodich}
    Element Should Not Be Visible    ${menu_hh}
    Element Should Not Be Visible    ${menu_doitac}
    Element Should Not Be Visible    ${menu_nhanvien}
    Element Should Not Be Visible    ${menu_soquy}
    Element Should Not Be Visible    ${domain_baocao}
    Element Should Not Be Visible    ${button_banhang_on_quanly}
    #
    Go to any thiet lap    ${button_thieplap_cuahang}
    Wait Until Element Is Visible   //span[text()='Tiki'][@ class="k-span"]     10s
    Element Should Not Be Visible      //button[@ng-click="addTiki()"]
    Delete user    ${get_user_id}

pqthkb2
    [Documentation]     người dùng chỉ có quyền Tích hợp kênh bán: Xem DS + Thêm mới
    [Arguments]    ${taikhoan}    ${matkhau}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"SalesChannelIntegrate_Read":true,"Clocking_Copy":false,"SalesChannelIntegrate_Create":true}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    Before Test Quan ly
    #
    Log    validate UI
    Element Should Not Be Visible    ${menu_giaodich}
    Element Should Not Be Visible    ${menu_hh}
    Element Should Not Be Visible    ${menu_doitac}
    Element Should Not Be Visible    ${menu_nhanvien}
    Element Should Not Be Visible    ${menu_soquy}
    Element Should Not Be Visible    ${domain_baocao}
    Element Should Not Be Visible    ${button_banhang_on_quanly}
    #
    Go to any thiet lap    ${button_thieplap_cuahang}
    Wait Until Element Is Visible   //span[normalize-space()='Web bán hàng']
    Delete user    ${get_user_id}

pqthkb3
    [Documentation]     người dùng chỉ có quyền Tích hợp kênh bán: Xem DS + Cập nhật + Xóa
    [Arguments]    ${taikhoan}    ${matkhau}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"SalesChannelIntegrate_Read":true,"Clocking_Copy":false,"SalesChannelIntegrate_Create":false,"SalesChannelIntegrate_Update":true,"SalesChannelIntegrate_Delete":true}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    Before Test Quan ly
    #
    Log    validate UI
    Element Should Not Be Visible    ${menu_giaodich}
    Element Should Not Be Visible    ${menu_hh}
    Element Should Not Be Visible    ${menu_doitac}
    Element Should Not Be Visible    ${menu_nhanvien}
    Element Should Not Be Visible    ${menu_soquy}
    Element Should Not Be Visible    ${domain_baocao}
    Element Should Not Be Visible    ${button_banhang_on_quanly}
    #
    Go to any thiet lap    ${button_thieplap_cuahang}
    Wait Until Element Is Visible   //span[text()='Tiki'][@ class="k-span"]     10s
    Element Should Not Be Visible      //button[@ng-click="addTiki()"]
    Delete user    ${get_user_id}
