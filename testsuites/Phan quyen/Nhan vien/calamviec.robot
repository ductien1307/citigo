*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    ${headless_browser}
Test Setup
Test Teardown     After Test
Library           Collections
Library           SeleniumLibrary
Library           DateTime
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
Resource          ../../../core/Nhan_vien/chamcong_list_action.robot
Resource          ../../../core/API/api_chamcong.robot
Resource          ../../../core/Ban_Hang/banhang_manager_navigation.robot

*** Variables ***
@{list_calv}      ca 1        ca 2

*** Test Cases ***
Xem DS + Thêm mới
    [Documentation]     người dùng chỉ có quyền Ca làm việcc Xem DS + Thêm mới, Lịch làm việc: Xem DS
    [Tags]      PQ7
    [Template]     pqclv1
    userclv1    123             Ca test pq      15:00         16:00

Xem DS + Cập nhật
    [Documentation]     người dùng chỉ có quyền Ca làm việcc Xem DS + Cập nhật, Lịch làm việc: Xem DS
    [Tags]      PQ7
    [Template]      pqclv2
    userclv2    123      Ca test pq      15:00         16:00

Xem DS + Xóa
    [Documentation]     người dùng chỉ có quyền Ca làm việcc: Xem DS + Xóa
    [Tags]      PQ7
    [Template]      pqclv3
    userclv3    123       Ca test pq      15:00         16:00

*** Keywords ***
pqclv1
    [Documentation]     người dùng chỉ có quyền Ca làm việcc Xem DS + Thêm mới, Lịch làm việc: Xem DS
    [Arguments]    ${taikhoan}    ${matkhau}       ${input_ten_ca}     ${input_gio_bd}      ${input_gio_kt}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}       Nhân viên kho
    ${get_calv_id}    Get shift id by branch thr API    ${input_ten_ca}     Chi nhánh trung tâm
    Run Keyword If    ${get_calv_id}!=0     Delete shift thr API    ${input_ten_ca}     Chi nhánh trung tâm     ELSE    Log    Ingore
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name      Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"Clocking_Read":true,"Shift_Read":true,"Shift_Update":false,"Shift_Delete":false,"Clocking_Copy":false,"Shift_Create":true}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}      ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    Before Test Cham cong
    #
    Log    validate UI
    Element Should Not Be Visible    ${menu_giaodich}
    Element Should Not Be Visible    ${menu_hh}
    Element Should Not Be Visible    ${menu_doitac}
    Element Should Not Be Visible    ${domain_baocao}
    Element Should Not Be Visible    ${menu_soquy}
    Element Should Not Be Visible    ${button_banhang_on_quanly}
    Element Should Not Be Visible    ${button_datlich_lamviec}
    Wait Until Page Contains Element    ${button_them_ca_lv}      30s
    Click Element    ${button_them_ca_lv}
    Wait Until Page Contains Element    ${textbox_ten_ca}      30s
    Input data    ${textbox_ten_ca}     ${input_ten_ca}
    Input data    ${textbox_giolam_batdau}     ${input_gio_bd}
    Input data    ${textbox_giolam_kethuc}     ${input_gio_kt}
    Click Element    ${button_luu_ca_lv}
    Create shift success validation
    ${get_gio_bd}      ${get_gio_kt}   Get shift infor thr API   ${input_ten_ca}    ${BRANCH_ID}
    Should Be Equal As Strings     ${input_gio_bd}    ${get_gio_bd}
    Should Be Equal As Strings     ${input_gio_kt}    ${get_gio_kt}
    Delete shift thr API    ${input_ten_ca}     Chi nhánh trung tâm
    Delete user    ${get_user_id}

pqclv2
    [Documentation]     người dùng chỉ có quyền Ca làm việcc Xem DS + Cập nhật, Lịch làm việc: Xem DS
    [Arguments]    ${taikhoan}    ${matkhau}       ${input_ten_ca}     ${input_gio_bd}      ${input_gio_kt}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}       Nhân viên kho
    ${get_calv_id}    Get shift id by branch thr API    ${input_ten_ca}     Chi nhánh trung tâm
    Run Keyword If    ${get_calv_id}==0     Add new shift     ${input_ten_ca}     ${input_gio_bd}      ${input_gio_kt}    Chi nhánh trung tâm
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name      Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"Clocking_Read":true,"Shift_Read":true,"Shift_Create":false,"Clocking_Copy":false,"Shift_Update":true}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}      ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    Before Test Cham cong
    #
    Log    validate UI
    Element Should Not Be Visible    ${menu_giaodich}
    Element Should Not Be Visible    ${menu_hh}
    Element Should Not Be Visible    ${menu_doitac}
    Element Should Not Be Visible    ${domain_baocao}
    Element Should Not Be Visible    ${menu_soquy}
    Element Should Not Be Visible    ${button_banhang_on_quanly}
    Element Should Not Be Visible    ${button_datlich_lamviec}
    ${button_edit_ca_lv}      Format String     ${button_edit_ca_lv}      ${input_ten_ca}
    ${label_tenca}      Format String     ${label_tenca}      ${input_ten_ca}
    Wait Until Page Contains Element    ${label_tenca}      30s
    Mouse Over   ${label_tenca}
    Wait Until Page Contains Element    ${button_edit_ca_lv}      10s
    Click Element    ${button_edit_ca_lv}
    Wait Until Page Contains Element    ${button_luu_ca_lv}      30s
    Click Element    ${button_luu_ca_lv}
    Wait Until Page Contains Element    ${toast_message}        40s
    Element Should Contain    ${toast_message}    Cập nhật ca làm việc thành công
    Delete shift thr API    ${input_ten_ca}     Chi nhánh trung tâm
    Delete user    ${get_user_id}

pqclv3
    [Documentation]     người dùng chỉ có quyền Ca làm việcc Xem DS + Xóa, Lịch làm việc: Xem DS
    [Arguments]    ${taikhoan}    ${matkhau}       ${input_ten_ca}     ${input_gio_bd}      ${input_gio_kt}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}       Nhân viên kho
    ${get_calv_id}    Get shift id by branch thr API    ${input_ten_ca}     Chi nhánh trung tâm
    Run Keyword If    ${get_calv_id}==0     Add new shift     ${input_ten_ca}     ${input_gio_bd}      ${input_gio_kt}    Chi nhánh trung tâm
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name      Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"Clocking_Read":true,"Shift_Read":true,"Shift_Update":true,"Clocking_Copy":false,"Shift_Delete":true}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}      ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    Before Test Cham cong
    #
    Log    validate UI
    Element Should Not Be Visible    ${menu_giaodich}
    Element Should Not Be Visible    ${menu_hh}
    Element Should Not Be Visible    ${menu_doitac}
    Element Should Not Be Visible    ${domain_baocao}
    Element Should Not Be Visible    ${menu_soquy}
    Element Should Not Be Visible    ${button_banhang_on_quanly}
    Element Should Not Be Visible    ${button_datlich_lamviec}
    ${button_edit_ca_lv}      Format String     ${button_edit_ca_lv}      ${input_ten_ca}
    ${label_tenca}      Format String     ${label_tenca}      ${input_ten_ca}
    Wait Until Page Contains Element    ${label_tenca}      30s
    Mouse Over   ${label_tenca}
    Wait Until Page Contains Element    ${button_edit_ca_lv}      10s
    Click Element    ${button_edit_ca_lv}
    Wait Until Page Contains Element    ${button_xoa_ca_lv}      30s
    Click Element    ${button_xoa_ca_lv}
    Wait Until Page Contains Element    ${button_dongy_xoa_calv}      30s
    Click Element    ${button_dongy_xoa_calv}
    Wait Until Page Contains Element    ${toast_message}        40s
    Element Should Contain    ${toast_message}    Xóa ca làm việc  ${input_ten_ca} thành công
    Delete user    ${get_user_id}
