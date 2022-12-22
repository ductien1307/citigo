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
Resource          ../../../core/Nhan_vien/thietlaphoahong_list_action.robot
Resource          ../../../core/API/api_thietlaphoahong.robot
Resource          ../../../core/Ban_Hang/banhang_manager_navigation.robot

*** Variables ***

*** Test Cases ***
Xem DS
    [Documentation]     người dùng chỉ có quyền Thiết lập hoa hồng: Xem DS
    [Tags]      PQ7
    [Template]    pqtlhhv1
    usertlhh1    123

Xem DS + Thêm mới
    [Documentation]     người dùng chỉ có quyền Thiết lập hoa hồng: Xem DS + Thêm mới, Danh mục SP: Xem DS
    [Tags]      PQ7
    [Template]     pqtlhhv2
    usertlhh2    123             TestPQ

Xem DS + Cập nhật
    [Documentation]     người dùng chỉ có quyền Thiết lập hoa hồng: Xem DS + Cập nhật, Danh mục SP: Xem DS
    [Tags]      PQ7
    [Template]      pqtlhhv3
    usertlhh3    123              TestPQ

Xem DS + Xóa
    [Documentation]     người dùng chỉ có quyền Thiết lập hoa hồng: Xem DS + Cập nhật + Xóa, Danh mục SP: Xem DS
    [Tags]      PQ7
    [Template]      pqtlhhv4
    usertlhh4    123        TestPQ1

Xem DS + Xuất file
    [Documentation]     người dùng chỉ có quyền Thiết lập hoa hồng: Xem DS + Xuất file Danh mục SP: Xem DS
    [Tags]      PQ7
    [Template]      pqtlhhv5
    usertlhh5    123        Hoa hồng

*** Keywords ***
pqtlhhv1
    [Documentation]     người dùng chỉ có quyền Thiết lập hoa hồng Xem DS
    [Arguments]    ${taikhoan}    ${matkhau}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"Commission_Read":true,"Clocking_Copy":false}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    Before Test Thiet lap hoa hong
    #
    Log    validate UI
    Element Should Not Be Visible    ${menu_giaodich}
    Element Should Not Be Visible    ${menu_hh}
    Element Should Not Be Visible    ${menu_doitac}
    Element Should Not Be Visible    ${domain_baocao}
    Element Should Not Be Visible    ${menu_soquy}
    Element Should Not Be Visible    ${button_banhang_on_quanly}
    Element Should Not Be Visible    ${button_them_banghoahong}
    Delete user    ${get_user_id}

pqtlhhv2
    [Documentation]     người dùng chỉ có quyền Thiết lập hoa hồng Xem DS + Thêm mới, Danh mục SP: Xem DS
    [Arguments]    ${taikhoan}    ${matkhau}      ${input_ten_bhh}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_bhh_id}     Get commission id     ${input_ten_bhh}
    Run Keyword If    ${get_bhh_id}==0      Log    Ignore       ELSE      Delete commission thr API    ${input_ten_bhh}
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"Commission_Read":true,"Clocking_Copy":false,"Commission_Create":true,"Commission_Update":false,"Commission_Delete":false,"Commission_Export":false,"Product_Read":true}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    Before Test Thiet lap hoa hong
    #
    Log    validate UI
    Element Should Not Be Visible    ${menu_giaodich}
    Element Should Not Be Visible    ${menu_doitac}
    Element Should Not Be Visible    ${domain_baocao}
    Element Should Not Be Visible    ${menu_soquy}
    Element Should Not Be Visible    ${button_banhang_on_quanly}
    #
    Wait Until Page Contains Element    ${button_them_banghoahong}      20s
    Click Element    ${button_them_banghoahong}
    Wait Until Page Contains Element    ${textbox_ten_banghoahong}      20s
    Input data    ${textbox_ten_banghoahong}    ${input_ten_bhh}
    Click Element    ${checkbox_chinhanh_banghoahong}
    Click Element    ${textbox_chonchinhanh_banghoahong}
    ${item_chinhanh_bhh_indropdown}       Format String     ${item_chinhanh_bhh_indropdown}     Chi nhánh trung tâm
    Wait Until Page Contains Element    ${item_chinhanh_bhh_indropdown}     10s
    Click Element     ${item_chinhanh_bhh_indropdown}
    Click Element    ${button_luu_banghoahong}
    Create commission success validation
    Wait Until Keyword Succeeds    3 times    3s    Delete commission thr API    ${input_ten_bhh}
    Delete user    ${get_user_id}

pqtlhhv3
    [Documentation]     người dùng chỉ có quyền Thiết lập hoa hồng Xem DS + Cập nhật, Danh mục SP: Xem DS
    [Arguments]    ${taikhoan}    ${matkhau}      ${input_ten_bhh}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_bhh_id}     Get commission id     ${input_ten_bhh}
    Run Keyword If    ${get_bhh_id}==0      Add new commission thr API      ${input_ten_bhh}
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"Commission_Read":true,"Clocking_Copy":false,"Commission_Create":false,"Commission_Update":true,"Commission_Delete":false,"Commission_Export":false,"Product_Read":true,"Product_Create":false,"Product_Update":false,"Product_Delete":false,"Product_PurchasePrice":false,"Product_Cost":false,"Product_Import":false,"Product_Export":false,"PriceBook_Read":false,"PriceBook_Create":false,"PriceBook_Update":false,"PriceBook_Delete":false,"PriceBook_Import":false,"PriceBook_Export":false}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    Before Test Thiet lap hoa hong
    #
    Log    validate UI
    Element Should Not Be Visible    ${menu_giaodich}
    Element Should Not Be Visible    ${menu_doitac}
    Element Should Not Be Visible    ${domain_baocao}
    Element Should Not Be Visible    ${menu_soquy}
    Element Should Not Be Visible    ${button_banhang_on_quanly}
    Element Should Not Be Visible    ${button_them_banghoahong}
    #
    Select Bang hoa hong      ${input_ten_bhh}
    Click Element    ${button_chinhsua_banghoahong}
    Wait Until Page Contains Element    ${button_luu_banghoahong}      20s
    Click Element    ${button_luu_banghoahong}
    Update commission success validation
    Wait Until Keyword Succeeds    3 times    3s    Delete commission thr API    ${input_ten_bhh}
    Delete user    ${get_user_id}

pqtlhhv4
    [Documentation]     người dùng chỉ có quyền Thiết lập hoa hồng Xem DS + Xóa, Danh mục SP: Xem DS
    [Arguments]    ${taikhoan}    ${matkhau}      ${input_ten_bhh}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_bhh_id}     Get commission id     ${input_ten_bhh}
    Run Keyword If    ${get_bhh_id}==0      Add new commission by branch thr API      ${input_ten_bhh}      Chi nhánh trung tâm
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"Commission_Read":true,"Clocking_Copy":false,"Commission_Create":false,"Commission_Update":true,"Commission_Delete":true,"Commission_Export":false,"Product_Read":true,"Product_Create":false,"Product_Update":false,"Product_Delete":false,"Product_PurchasePrice":false,"Product_Cost":false,"Product_Import":false,"Product_Export":false,"PriceBook_Read":false,"PriceBook_Create":false,"PriceBook_Update":false,"PriceBook_Delete":false,"PriceBook_Import":false,"PriceBook_Export":false}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    Before Test Thiet lap hoa hong
    #
    Log    validate UI
    Element Should Not Be Visible    ${menu_giaodich}
    Element Should Not Be Visible    ${menu_doitac}
    Element Should Not Be Visible    ${domain_baocao}
    Element Should Not Be Visible    ${menu_soquy}
    Element Should Not Be Visible    ${button_banhang_on_quanly}
    Element Should Not Be Visible    ${button_them_banghoahong}
    #
    Select Bang hoa hong      ${input_ten_bhh}
    Click Element    ${button_chinhsua_banghoahong}
    Wait Until Page Contains Element    ${button_xoa_banghoahong}      20s
    Click Element    ${button_xoa_banghoahong}
    Wait Until Page Contains Element    ${button_xoa_bhh_dongy}      20s
    Click Element    ${button_xoa_bhh_dongy}
    Delete commission success validation    ${input_ten_bhh}
    Delete user    ${get_user_id}

pqtlhhv5
    [Documentation]     người dùng chỉ có quyền Thiết lập hoa hồng Xem DS + Xuất file, Danh mục SP: Xem DS
    [Arguments]    ${taikhoan}    ${matkhau}      ${input_ten_bhh}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"Commission_Read":true,"Commission_Update":false,"Commission_Delete":false,"Product_Read":true,"Clocking_Copy":false,"Commission_Export":true}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    Before Test Thiet lap hoa hong
    #
    Log    validate UI
    Element Should Not Be Visible    ${menu_giaodich}
    Element Should Not Be Visible    ${menu_doitac}
    Element Should Not Be Visible    ${domain_baocao}
    Element Should Not Be Visible    ${menu_soquy}
    Element Should Not Be Visible    ${button_banhang_on_quanly}
    Element Should Not Be Visible    ${button_them_banghoahong}
    #
    Select Bang hoa hong      ${input_ten_bhh}
    Wait Until Keyword Succeeds    3 times    1s     Click Element       ${button_export_invoice}
    Wait Until Keyword Succeeds    3 times    3s       Element Should Contain    ${noti_export}    Nhấn vào đây để tải xuống
    Delete user    ${get_user_id}
