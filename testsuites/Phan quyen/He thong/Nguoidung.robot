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
Resource          ../../../core/Thiet_lap/nguoidung_list_action.robot

*** Variables ***

*** Test Cases ***
Xem DS
    [Documentation]     người dùng chỉ có quyền Người dùng: Xem DS
    [Tags]      PQ1
    [Template]    pqnd1
    usernd1    123

Xem DS + Thêm mới
    [Documentation]     người dùng chỉ có quyền Người dùng: Xem DS + Thêm mới
    [Tags]      PQ1
    [Template]    pqnd2
    usernd2    123       abc   testabc      123         Nhân viên thu ngân    Chi nhánh trung tâm     none     none

Xem DS + Cập nhật
    [Documentation]     người dùng chỉ có quyền Người dùng: Xem DS + Cập nhật
    [Tags]      PQ1
    [Template]    pqnd3
    usernd3    123     le.dv

Xem DS + Xóa
    [Documentation]     người dùng chỉ có quyền Người dùng: Xem DS + Xóa
    [Tags]      #PQ1
    [Template]    pqnd4
    usernd4    123     thaopm     123         Nhân viên kho

Xem DS + Cập nhật + Xóa +Xuất file
    [Documentation]     người dùng chỉ có quyền Người dùng: Xem DS + Cập nhật + Xóa +Xuất file
    [Tags]      PQ1
    [Template]    pqnd5
    usernd5    123

*** Keywords ***
pqnd1
    [Documentation]     người dùng chỉ có quyền thiếp lập
    [Arguments]    ${taikhoan}    ${matkhau}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"PrintTemplate_Read":false,"PrintTemplate_Update":false,"Clocking_Copy":false,"User_Read":true,"User_Create":false,"User_Update":false,"User_Delete":false,"User_Export":false}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
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
    Go to any thiet lap    ${button_quanly_nguoidung}
    Wait Until Element Is Visible    ${textbox_search_user}
    Input data    ${textbox_search_user}    linh.ct
    Sleep    2s
    Element Should Not Be Visible    ${button_capnhat_user}
    Element Should Not Be Visible   ${button_nguoidung}
    Element Should Not Be Visible    ${button_delete_user}
    Element Should Not Be Visible    ${button_ngunghd_user}
    Delete user    ${get_user_id}

pqnd2
    [Documentation]     người dùng chỉ có quyền Người dùng: Xem DS + Thêm mới
    [Arguments]    ${taikhoan}    ${matkhau}    ${input_name}   ${input_username}    ${input_pass}   ${permission}    ${branch}    ${input_phone}    ${input_email}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"User_Read":true,"Clocking_Copy":false,"User_Create":true}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
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
    Go to any thiet lap    ${button_quanly_nguoidung}
    Wait Until Element Is Visible    ${textbox_search_user}
    Input data    ${textbox_search_user}    le.dv
    Wait Until Page Contains Element       ${button_saochep_user}   30s
    Element Should Not Be Visible    ${button_capnhat_user}
    Element Should Not Be Visible    ${button_ngunghd_user}
    Element Should Not Be Visible    ${button_delete_user}
    #
    Click Element JS   ${button_nguoidung}
    Input text    ${textbox_user_name}   ${input_name}
    Input text    ${textbox_user_username}   ${input_username}
    Input text    ${textbox_user_password}   ${input_pass}
    Input text    ${textbox_user_again_password}   ${input_pass}
    Select combobox any form    ${combobox_user_permission}   ${cell_user_item_permission}   ${permission}
    Select dropdown anyform    ${textbox_user_branch}    ${cell_user_item_branch}    ${branch}
    Run Keyword If    '${input_phone}' == 'none'    Log     Ignore input      ELSE       Input text     ${textbox_user_phone}   ${input_phone}
    Run Keyword If    '${input_email}' == 'none'    Log     Ignore input      ELSE       Input text     ${textbox_user_email}   ${input_email}
    Click Element        ${button_save_add_user}
    Update data success validation
    Sleep    5s
    ${get_user_id_1}    Get user info and validate    ${input_username}    ${input_phone}    ${permission}    ${input_email}    ${branch}
    Delete user    ${get_user_id_1}
    Delete user    ${get_user_id}

pqnd3
    [Documentation]    người dùng chỉ có quyền Người dùng: Xem DS + Cập nhật
    [Arguments]    ${taikhoan}    ${matkhau}    ${taikhoan_capnhat}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"User_Read":true,"Clocking_Copy":false,"User_Create":false,"User_Update":true}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
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
    Element Should Not Be Visible    ${button_nguoidung}
    #
    Go to any thiet lap    ${button_quanly_nguoidung}
    Wait Until Element Is Visible    ${textbox_search_user}
    Input data    ${textbox_search_user}    ${taikhoan_capnhat}
    Sleep    2s
    Element Should Not Be Visible    ${button_saochep_user}
    Element Should Be Visible    ${button_ngunghd_user}
    Element Should Not Be Visible    ${button_delete_user}
    #
    Click Element    ${button_capnhat_user}
    Wait Until Page Contains Element    ${button_save_add_user}     10s
    Click Element   ${button_save_add_user}
    Update data success validation
    Click Element    ${toast_message}
    #
    Click Element    ${tab_phanquyen}
    Wait Until Page Contains Element    ${button_capnhat_phanquyen}     20s
    Click Element    ${button_capnhat_phanquyen}
    Wait Until Page Contains Element    ${button_dongy_capnhat_phanquyen}     20s
    Click Element    ${button_dongy_capnhat_phanquyen}
    Wait Until Page Contains Element    ${toast_message}    1 min
    Element Should Contain    ${toast_message}      Cập nhật quyền hạn cho nhân viên
    Delete user    ${get_user_id}

pqnd4
    [Documentation]    người dùng chỉ có quyền Người dùng: Xem DS + Xóa
    [Arguments]    ${taikhoan}    ${matkhau}      ${input_name}    ${input_pass}       ${input_role}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"User_Read":true,"User_Update":false,"Clocking_Copy":false,"User_Delete":true}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
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
    ${get_user_id_del}    Get User ID by UserName    ${input_name}
    Run Keyword If    '${get_user_id_del}' == '0'    Log    Ignore     ELSE      Delete user    ${get_user_id_del}
    #Create new user    ${input_name}    ${input_name}    ${input_pass}   0985632145    ${input_role}
    Create new user by role        ${input_name}    ${input_pass}       ${input_role}
    Go to any thiet lap    ${button_quanly_nguoidung}
    Wait Until Element Is Visible    ${textbox_search_user}
    Input data    ${textbox_search_user}    ${input_name}
    Sleep    2s
    Element Should Not Be Visible    ${button_capnhat_user}
    Element Should Not Be Visible   ${button_nguoidung}
    Element Should Not Be Visible    ${button_saochep_user}
    Element Should Not Be Visible    ${button_ngunghd_user}
    Wait Until Element Is Visible    ${button_delete_user}      20s
    Click Element JS    ${button_delete_user}
    Wait Until Element Is Visible    ${button_dongy_del_promo}    20s
    Click Element JS    ${button_dongy_del_promo}
    Wait Until Page Contains Element    ${toast_message}    2 min
    ${text}    Format String        Xóa người dùng {0} thành công    ${input_name}
    Element Should Contain    ${toast_message}    ${text}
    Delete user    ${get_user_id}

pqnd5
    [Documentation]    người dùng chỉ có quyền Người dùng: Xem DS + Cập nhật + Xóa +Xuất file
    [Arguments]    ${taikhoan}    ${matkhau}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"User_Read":true,"User_Export":true,"Clocking_Copy":false,"User_Create":false,"User_Update":true,"User_Delete":true}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
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
    Element Should Not Be Visible    ${button_nguoidung}
    #
    Go to any thiet lap    ${button_quanly_nguoidung}
    Click Element    ${checkbox_all_nguoidung}
    Wait Until Page Contains Element    ${button_thaotac_nd}     20s
    Click Element    ${button_thaotac_nd}
    Wait Until Page Contains Element    ${button_xuatfile_user}     20s
    Click Element    ${button_xuatfile_user}
    Wait Until Keyword Succeeds    3 times    3s    Element Should Contain      //a[@ng-show="item.readyDownload"]      Nhấn vào đây để tải xuống
