*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    ${headless_browser}
Test Setup
Test Teardown     After Test
Library           Collections
Library           SeleniumLibrary
Resource          ../../../config/env_product/envi.robot
Resource          ../../../core/hang_hoa/hang_hoa_navigation.robot
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
Resource          ../../../core/Thiet_lap/mauin_list_action.robot

*** Variables ***

*** Test Cases ***
He thong
    [Documentation]     người dùng chỉ có quyền thiếp lập
    [Tags]      PQ1
    [Template]    pqht1
    usertl1    123

Mấu in: Xem DS
    [Documentation]     người dùng chỉ có quyền mẫu in: Xem DS
    [Tags]      PQ1
    [Template]    pqht2
    usertl2    123

Mấu in: Xem DS + Cập nhật
    [Documentation]     người dùng chỉ có quyền mẫu in: Xem DS, Cập nhật
    [Tags]      PQ1
    [Template]    pqht3
    usertl3    123

*** Keywords ***
pqht1
    [Documentation]     người dùng chỉ có quyền thiếp lập
    [Arguments]    ${taikhoan}    ${matkhau}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"Surcharge_Read":false,"Surcharge_Create":false,"Surcharge_Update":false,"Surcharge_Delete":false,"Clocking_Copy":false,"PosParameter_Update":true}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"user5"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    Before Test Quan ly
    #
    Log    validate UI
    Wait Until Page Contains Element    //a[@href="/#/DashBoard/"]    1 min
    Element Should Not Be Visible    ${menu_giaodich}
    Element Should Not Be Visible    ${menu_hh}
    Element Should Not Be Visible    ${menu_doitac}
    Element Should Not Be Visible    ${menu_nhanvien}
    Element Should Not Be Visible    ${menu_soquy}
    Element Should Not Be Visible    ${domain_baocao}
    Element Should Not Be Visible    ${button_banhang_on_quanly}
    Delete user    ${get_user_id}

pqht2
    [Documentation]     người dùng chỉ có quyền mẫu in: Xem DS
    [Arguments]    ${taikhoan}    ${matkhau}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"PosParameter_Update":false,"Clocking_Copy":false,"PrintTemplate_Read":true}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}      ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    Before Test Quan ly
    #
    Element Should Not Be Visible    ${menu_giaodich}
    Element Should Not Be Visible    ${menu_hh}
    Element Should Not Be Visible    ${menu_doitac}
    Element Should Not Be Visible    ${menu_nhanvien}
    Element Should Not Be Visible    ${menu_soquy}
    Element Should Not Be Visible    ${domain_baocao}
    Element Should Not Be Visible    ${button_banhang_on_quanly}
    #
    Go to any thiet lap    ${button_quanly_mauin}
    Wait Until Keyword Succeeds    3 times    3s    Click edit print template and save
    Wait Until Page Contains Element    ${toast_message}    1 min
    Wait Until Element Contains    ${toast_message}    Bạn không có quyền thực hiện chức năng này.
    #
    Reload Page
    Click add new print template and save
    Wait Until Page Contains Element    ${toast_message}    1 min
    Wait Until Element Contains    ${toast_message}    Bạn không có quyền thực hiện chức năng này.
    Delete user    ${get_user_id}

pqht3
    [Documentation]     người dùng chỉ có quyền mẫu in: Xem DS, Cập nhật
    [Arguments]    ${taikhoan}    ${matkhau}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"PrintTemplate_Read":true,"Clocking_Copy":false,"PrintTemplate_Update":true}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}     ${get_user_id}    ${BRANCH_ID}    ${get_role_id}      ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    Before Test Quan ly
    #
    Element Should Not Be Visible    ${menu_giaodich}
    Element Should Not Be Visible    ${menu_hh}
    Element Should Not Be Visible    ${menu_doitac}
    Element Should Not Be Visible    ${menu_nhanvien}
    Element Should Not Be Visible    ${menu_soquy}
    Element Should Not Be Visible    ${domain_baocao}
    Element Should Not Be Visible    ${button_banhang_on_quanly}
    #
    Go to any thiet lap    ${button_quanly_mauin}
    Wait Until Keyword Succeeds    3 times    3s    Click edit print template and save
    Wait Until Page Contains Element    ${toast_message}    1 min
    Wait Until Element Contains    ${toast_message}   Cập nhật mẫu in thành công
    #
    Reload Page
    Click add new print template and save
    Wait Until Page Contains Element    ${toast_message}    1 min
    Wait Until Element Contains    ${toast_message}    Tên mẫu in không được trùng nhau
    Delete user    ${get_user_id}
