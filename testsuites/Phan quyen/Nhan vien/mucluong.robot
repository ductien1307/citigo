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
Resource          ../../../core/Nhan_vien/nhanvien_list_action.robot
Resource          ../../../core/API/api_nhanvien.robot

*** Variables ***

*** Test Cases ***
Xem DS
    [Documentation]     người dùng chỉ có quyền Mức lương: Xem DS, Nhân viên: Xem DS
    [Tags]      PQ7
    [Template]    pqml1
    userml1    123      PQML001

Xem DS + Cập nhật
    [Documentation]     người dùng chỉ có quyền Mức lương: Xem DS + Cập nhật, Nhân viên: Xem DS
    [Tags]       PQ7
    [Template]    pqml2
    userml2    123      PQML002

*** Keywords ***
pqml1
    [Documentation]     người dùng chỉ có quyền Mức lương: Xem DS, Nhân viên: Xem DS
    [Arguments]    ${taikhoan}    ${matkhau}      ${input_ma_nv}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_nv_id}      Get employee id thr API    ${input_ma_nv}
    Run Keyword If    ${get_nv_id}==0      Add employee thr API    ${input_ma_nv}    abc    Chi nhánh trung tâm
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"Employee_Read":true,"Paysheet_Read":false,"PayslipPayment_Create":false,"Clocking_Copy":false,"FingerMachine_Read":false,"FingerMachine_Create":false,"FingerMachine_Update":false,"FingerMachine_Delete":false,"Paysheet_Create":false,"Paysheet_Complete":false,"PayslipPayment_Update":false,"Paysheet_Update":false,"Paysheet_Delete":false,"Paysheet_Export":false,"PayslipPayment_Delete":false,"EmployeeAdjustment_Read":false,"PayRate_Read":true,"PayRate_Update":false,"Employee_Create":false,"Employee_Update":false,"Employee_Delete":false}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    Before Test Nhan vien
    #
    Log    validate UI
    Element Should Not Be Visible    ${menu_giaodich}
    Element Should Not Be Visible    ${menu_hh}
    Element Should Not Be Visible    ${menu_doitac}
    Element Should Not Be Visible    ${domain_baocao}
    Element Should Not Be Visible    ${menu_soquy}
    Element Should Not Be Visible    ${button_banhang_on_quanly}
    Element Should Not Be Visible    ${button_them_nhan_vien}
    Search employee    ${input_ma_nv}
    Wait Until Page Contains Element    ${tab_thietlapluong}     30s
    Delete user    ${get_user_id}

pqml2
    [Documentation]     người dùng chỉ có quyền Mức lương: Xem DS + Cập nhật, Nhân viên: Xem DS
    [Arguments]    ${taikhoan}    ${matkhau}      ${input_ma_nv}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_nv_id}      Get employee id thr API    ${input_ma_nv}
    Run Keyword If    ${get_nv_id}==0      Add employee thr API    ${input_ma_nv}    abc    Chi nhánh trung tâm
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"Employee_Read":true,"Paysheet_Read":false,"PayslipPayment_Create":false,"Clocking_Copy":false,"FingerMachine_Read":false,"FingerMachine_Create":false,"FingerMachine_Update":false,"FingerMachine_Delete":false,"Paysheet_Create":false,"Paysheet_Complete":false,"PayslipPayment_Update":false,"Paysheet_Update":false,"Paysheet_Delete":false,"Paysheet_Export":false,"PayslipPayment_Delete":false,"EmployeeAdjustment_Read":false,"PayRate_Read":true,"PayRate_Update":true,"Employee_Create":false,"Employee_Update":true,"Employee_Delete":false}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    Before Test Nhan vien
    #
    Log    validate UI
    Element Should Not Be Visible    ${menu_giaodich}
    Element Should Not Be Visible    ${menu_hh}
    Element Should Not Be Visible    ${menu_doitac}
    Element Should Not Be Visible    ${domain_baocao}
    Element Should Not Be Visible    ${menu_soquy}
    Element Should Not Be Visible    ${button_banhang_on_quanly}
    Element Should Not Be Visible    ${button_them_nhan_vien}
    Search employee    ${input_ma_nv}
    Wait Until Page Contains Element    ${tab_thietlapluong}     30s
    Click Element    ${tab_thietlapluong}
    Wait Until Page Contains Element    ${button_capnhat_thietlapluong}   30s
    Click Element    ${button_capnhat_thietlapluong}
    Wait Until Page Contains Element    ${button_luu_thietlapluong}   30s
    Click Element    ${button_luu_thietlapluong}
    Wait Until Page Contains Element    ${toast_message}      30s
    Element Should Contain    ${toast_message}    Cập nhật nhân viên thành công
    Delete user    ${get_user_id}
