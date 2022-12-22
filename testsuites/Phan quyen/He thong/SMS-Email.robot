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
Resource          ../../../core/Thiet_lap/sms_email_list_action.robot

*** Variables ***

*** Test Cases ***
Xem DS
    [Documentation]     người dùng chỉ có quyền SMS/Email: Xem DS
    [Tags]      PQ1
    [Template]    pqsms1
    usersms1    123

Xem DS + Thêm mới
    [Documentation]     người dùng chỉ có quyền SMS/Email: Xem DS + Thêm mới
    [Tags]      PQ1
    [Template]    pqsms2
    usersms2    123       CMSN        Chúc mừng sinh nhật

Xem DS + Cập nhật
    [Documentation]     người dùng chỉ có quyền SMS/Email: Xem DS + Cập nhật
    [Tags]      PQ1
    [Template]    pqsms3
    usersms3    123     Khhyến mãi        KHuyến mãi giờ vàng     KHuyến mãi giờ vàng 18h

Xem DS + Xóa
    [Documentation]     người dùng chỉ có quyền SMS/Email: Xem DS + Xóa
    [Tags]      PQ1
    [Template]    pqsms4
    usersms4    123     abc         abcd

*** Keywords ***
pqsms1
    [Documentation]     người dùng chỉ có quyền SMS / Email: Xem DS
    [Arguments]    ${taikhoan}    ${matkhau}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"SmsEmailTemplate_Read":true,"Clocking_Copy":false}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
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
    Go to any thiet lap    ${button_quanly_mautin}
    Element Should Be Visible    ${textbox_search_mautin}     30s
    Element Should Not Be Visible    ${button_themmau}
    Delete user    ${get_user_id}

pqsms2
    [Documentation]     người dùng chỉ có quyền SMS / Email: Xem DS + Thêm mới
    [Arguments]    ${taikhoan}    ${matkhau}     ${input_tieude}    ${input_noidung}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"SmsEmailTemplate_Read":true,"Clocking_Copy":false,"SmsEmailTemplate_Create":true}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
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
    ${get_sms_id}     Get sms email template id frm api    ${input_tieude}
    Run Keyword If    ${get_sms_id}!=0      Delete sms email template    ${input_tieude}
    Go to any thiet lap    ${button_quanly_mautin}
    Element Should Be Visible    ${textbox_search_mautin}     30s
    Add new SMS/ZMS    ${input_tieude}    ${input_noidung}
    Wait Until Page Contains Element    ${toast_message}    2 min
    Element Should Contain    ${toast_message}    Lưu mẫu tin nhắn thành công
    Delete sms email template    ${input_tieude}
    Delete user    ${get_user_id}

pqsms3
    [Documentation]     người dùng chỉ có quyền SMS / Email: Xem DS + Cập nhật
    [Arguments]    ${taikhoan}    ${matkhau}     ${input_tieude}    ${input_noidung}       ${input_noidung_up}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"SmsEmailTemplate_Read":true,"SmsEmailTemplate_Create":false,"Clocking_Copy":false,"SmsEmailTemplate_Update":true}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
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
    ${get_sms_id}     Get sms email template id frm api    ${input_tieude}
    Run Keyword If    ${get_sms_id}!=0      Delete sms email template    ${input_tieude}
    Add sms email template thr API    ${input_tieude}    ${input_noidung}
    Go to any thiet lap    ${button_quanly_mautin}
    Element Should Be Visible    ${textbox_search_mautin}     30s
    Input data         ${textbox_search_mautin}   ${input_tieude}
    Element Should Not Be Visible       ${button_xoa_mautin}
    Wait Until Keyword Succeeds    3 times    1s    Access button update template Visible
    Input Text    ${textbox_noidung}    ${input_noidung_up}
    Click Element    ${button_luu_mau}
    Wait Until Page Contains Element    ${toast_message}    2 min
    Element Should Contain    ${toast_message}    Lưu mẫu tin nhắn thành công
    Delete sms email template    ${input_tieude}
    Delete user    ${get_user_id}

pqsms4
    [Documentation]     người dùng chỉ có quyền SMS / Email: Xem DS + Xóa
    [Arguments]    ${taikhoan}    ${matkhau}     ${input_tieude}    ${input_noidung}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"SmsEmailTemplate_Read":true,"SmsEmailTemplate_Create":false,"Clocking_Copy":false,"SmsEmailTemplate_Update":false,"SmsEmailTemplate_Delete":true}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
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
    ${get_sms_id}     Get sms email template id frm api    ${input_tieude}
    Run Keyword If    ${get_sms_id}!=0      Delete sms email template    ${input_tieude}
    Add sms email template thr API    ${input_tieude}    ${input_noidung}
    Go to any thiet lap    ${button_quanly_mautin}
    Element Should Be Visible    ${textbox_search_mautin}     30s
    Input data         ${textbox_search_mautin}   ${input_tieude}
    Element Should Not Be Visible       ${button_capnhat_mautin}
    Wait Until Keyword Succeeds    3 times    1s    Access button delete template Visible
    Click Element    ${button_dongy_xoa_mautin}
    Wait Until Page Contains Element    ${toast_message}    2 min
    Element Should Contain    ${toast_message}    Xóa mẫu tin thành công
    Delete user    ${get_user_id}

pqsms5
    [Documentation]     người dùng chỉ có quyền SMS / Email: Xem DS
    [Arguments]    ${taikhoan}    ${matkhau}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"SmsEmailTemplate_Read":true,"SmsEmailTemplate_Delete":false,"Clocking_Copy":false,"SmsEmailTemplate_SendSMS":true,"SmsEmailTemplate_SendEmail":true,"SmsEmailTemplate_SendZalo":true,"Customer_Read":false}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
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
    Go to any thiet lap    ${button_quanly_mautin}
    Element Should Be Visible    ${textbox_search_mautin}     30s
    Element Should Not Be Visible    ${button_themmau}
    Delete user    ${get_user_id}
