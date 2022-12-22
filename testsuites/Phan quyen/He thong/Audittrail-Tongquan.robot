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
Resource          ../../../core/Giao_dich/giaodich_nav.robot
Resource          ../../../core/So_Quy/so_quy_navigation.robot
Resource          ../../../core/Bao_cao/bao_cao_navigation.robot
Resource          ../../../core/share/toast_message.robot
Resource          ../../../prepare/Hang_hoa/Sources/thietlap.robot
Resource          ../../../core/Nhan_vien/nhanvien_navigation.robot
Resource          ../../../core/Thiet_lap/thiet_lap_nav.robot


*** Variables ***

*** Test Cases ***
Lich su thao tac
    [Documentation]     người dùng chỉ có quyền Lịch sử thao tác
    [Tags]      PQ1
    [Template]    pnat1
    usertq1    123

Tong quan
    [Documentation]     người dùng chỉ có quyền Tổng quan
    [Tags]
    [Template]    pntq1
    usertq2    123


*** Keywords ***
pnat1
    [Documentation]     người dùng chỉ có quyền Lịch sử thao tác
    [Arguments]    ${taikhoan}    ${matkhau}
    Set Selenium Speed    0.1
    Log    Cập nhật quyền thiết lập
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"ExpensesOther_Read":false,"ExpensesOther_Delete":false,"Clocking_Copy":false,"ExpensesOther_Create":false,"ExpensesOther_Update":false,"SalesChannelIntegrate_Read":false,"SalesChannelIntegrate_Create":false,"SalesChannelIntegrate_Update":false,"AuditTrail_Read":true}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
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
    Go to any thiet lap    ${button_quanly_lichsuthaotac}
    Wait Until Page Contains Element    //div[@class='k-grid-content k-auto-scrollable']//tr[1]//span[@ng-bind="dataItem.SubContent"]       20s
    ${sub_content}    Get Text    //div[@class='k-grid-content k-auto-scrollable']//tr[1]//span[@ng-bind="dataItem.SubContent"]
    Should Not Be Equal As Strings    ${sub_content}    ${EMPTY}
    Delete user    ${get_user_id}

pntq1
    [Documentation]     người dùng chỉ có quyền Tổng quan
    [Arguments]    ${taikhoan}    ${matkhau}
    Set Selenium Speed    0.1
    Log    Cập nhật quyền thiết lập
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"AuditTrail_Read":false,"Clocking_Copy":false,"DashBoard_Read":true}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
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
    Wait Until Page Contains Element    //span[@id='TotalValue7']      20s
    ${get_value}    Get Text    //span[@id='TotalValue7']
    Should Not Be Equal As Strings    ${get_value}    ${EMPTY}
    Should Not Be Equal As Strings    ${get_value}    0
    Delete user    ${get_user_id}
