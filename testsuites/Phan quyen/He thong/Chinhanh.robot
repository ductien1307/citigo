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
Resource          ../../../core/Thiet_lap/branch_list_action.robot

*** Variables ***

*** Test Cases ***
Xem DS
    [Documentation]     người dùng chỉ có quyền Chi nhánh: Xem DS
    [Tags]      PQ1
    [Template]    pncn1
    usercn1    123     Nhánh A

Xem DS + Thêm mới
    [Documentation]     người dùng chỉ có quyền Chi nhánh: Xem DS + Thêm mới
    [Tags]      PQ1
    [Template]    pncn2
    usercn2    123        0912402589     none   abcd@gmail.com     1B Yết Kiêu     Hà Nội - Quận Hoàn Kiếm     Phường Trần Hưng Đạo

Xem DS + Cập nhật
    [Documentation]     người dùng chỉ có quyền Chi nhánh: Xem DS + Cập nhật
    [Tags]      PQ1
    [Template]    pncn3
    usercn3    123    Nhánh A

Xem DS + Xóa
    [Documentation]     người dùng chỉ có quyền  Chi nhánh Xem DS + Xóa
    [Tags]      PQ1
    [Template]    pncn4
    usercn4    123     0912432119   1B Yết Kiêu     Hà Nội - Quận Hoàn Kiếm         Phường Cửa Nam

*** Keywords ***
pncn1
    [Documentation]     người dùng chỉ có quyền Chi nhánh: Xem DS
    [Arguments]    ${taikhoan}    ${matkhau}    ${input_tenchinhanh}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"User_Read":false,"User_Export":false,"Clocking_Copy":false,"User_Create":false,"User_Update":false,"User_Delete":false,"Branch_Read":true}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
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
    Go to any thiet lap    ${button_quanly_branch}
    Wait Until Element Is Visible    ${textbox_search_branch}     10s
    Element Should Not Be Visible      ${button_themmoi_all_form}
    Input data    ${textbox_search_branch}    ${input_tenchinhanh}
    Wait Until Element Is Visible    ${checkbox_filter_trangthai_tatca}
    Click Element    ${checkbox_filter_trangthai_tatca}
    Sleep   1s
    Element Should Not Be Visible    ${button_capnhat_branch}
    Delete user    ${get_user_id}

pncn2
    [Documentation]     người dùng chỉ có quyền Chi nhánh: Xem DS + Thêm mới
    [Arguments]    ${taikhoan}    ${matkhau}    ${input_phone1}   ${input_phone2}    ${input_email}  ${input_address}    ${input_location}    ${input_ward}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"User_Read":false,"User_Export":false,"Clocking_Copy":false,"User_Create":false,"User_Update":false,"User_Delete":false,"Branch_Read":true,"Branch_Create":true}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    #
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
    ${get_branch_id}   Get BranchID by Contact number     ${input_phone1}
    Run Keyword If    '${get_branch_id}'=='0'    Log    Ignore      ELSE      Delete Branch    ${get_branch_id}
    ${name}      Generate Random String    6    [UPPER][NUMBERS]
    ${input_name}      Catenate      SEPARATOR=      Chi nhánh     ${name}
    Go to any thiet lap    ${button_quanly_branch}
    Sleep    5s
    Click Element    ${button_themmoi_all_form}
    Wait Until Page Contains Element    ${textbox_branch_name}      20s
    Input text    ${textbox_branch_name}   ${input_name}
    Input text     ${textbox_branch_phone1}   ${input_phone1}
    Run Keyword If    '${input_phone2}' == 'none'    Log     Ignore input      ELSE       Input text     ${textbox_branch_phone2}   ${input_phone2}
    Run Keyword If    '${input_email}' == 'none'    Log     Ignore input      ELSE       Input text     ${textbox_branch_email}   ${input_email}
    Input text     ${textbox_branch_address}   ${input_address}
    Select dropdown anyform    ${textbox_branch_location}    ${cell_branch_item_location}    ${input_location}
    Select dropdown anyform    ${textbox_branch_ward}    ${cell_branch_item_location}    ${input_ward}
    Click Element JS        ${button_branch_save}
    ${get_branch_id}    Wait Until Keyword Succeeds    3x    3s    Assert get branch id succeed    ${input_name}
    #
    Input data    ${textbox_search_branch}    ${input_name}
    Sleep    2s
    Element Should Not Be Visible    ${button_capnhat_branch}
    #
    Delete Branch    ${get_branch_id}
    Delete user    ${get_user_id}

pncn3
    [Documentation]     người dùng chỉ có quyền Chi nhánh: Xem DS + cập nhật
    [Arguments]    ${taikhoan}    ${matkhau}   ${input_chinhanh}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"User_Read":false,"User_Export":false,"Clocking_Copy":false,"User_Create":false,"User_Update":false,"User_Delete":false,"Branch_Read":true,"Branch_Create":false,"Branch_Update":true}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    #
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
    Element Should Not Be Visible    ${button_themmoi_all_form}
    #
    Go to any thiet lap    ${button_quanly_branch}
    Go to update branch form    ${input_chinhanh}
    Click Element JS        ${button_branch_save}
    Element Should Not Be Visible    ${toast_message}
    #
    Delete user    ${get_user_id}

pncn4
    [Documentation]     người dùng chỉ có quyền Chi nhánh: Xem DS + Xóa
    [Arguments]    ${taikhoan}    ${matkhau}     ${input_phone}  ${input_address}    ${input_location}     ${input_ward}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"Branch_Read":true,"Branch_Update":false,"Clocking_Copy":false,"Branch_Delete":true}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    #
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
    Element Should Not Be Visible    ${button_themmoi_all_form}
    #
    ${name}      Generate Random String    4    [UPPER][NUMBERS]
    ${input_name}      Catenate      SEPARATOR=      Chi nhánh     ${name}
    Create new branch    ${input_name}    ${input_address}    ${input_location}      ${input_ward}     ${input_phone}
    Go to any thiet lap    ${button_quanly_branch}
    Wait Until Element Is Visible    ${textbox_search_branch}
    Input data    ${textbox_search_branch}    ${input_name}
    Wait Until Element Is Visible    ${checkbox_filter_trangthai_tatca}
    Click Element JS    ${checkbox_filter_trangthai_tatca}
    Sleep    1s
    Wait Until Page Contains Element       ${button_delete_branch}    20s
    Element Should Not Be Visible    ${button_capnhat_branch}
    Click Element JS    ${button_delete_branch}
    Wait Until Element Is Visible    ${button_dongy_del_promo}
    Click Element JS    ${button_dongy_del_promo}
    #
    Delete user    ${get_user_id}
