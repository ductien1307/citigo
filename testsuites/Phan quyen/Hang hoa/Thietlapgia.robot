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
Resource          ../../../core/Hang_hoa/thiet_lap_gia_list_action.robot
Resource          ../../../core/Ban_Hang/banhang_manager_navigation.robot

*** Variables ***
${file_imp}    ${EXECDIR}${/}testsuites${/}Phan quyen${/}Hang hoa${/}MauFileBangGia.xlsx

*** Test Cases ***
Xem DS
    [Documentation]     người dùng chỉ có quyền Thiết lập giá: Xem DS
    [Tags]      PQ2
    [Template]    pqtlg1
    usertlg1    123

Xem DS + Thêm mới
    [Documentation]     người dùng chỉ có quyền Thiết lập giá: Xem DS + Thêm mới
    [Tags]      PQ2
    [Template]    pqtlg2
    usertlg2    123       testpq1

Xem DS + Cập nhật
    [Documentation]     người dùng chỉ có quyền Thiết lập giá: Xem DS + Cập nhật
    [Tags]      PQ2
    [Template]    pqtlg3
    usertlg3    123    testpq2

Xem DS + Cập nhật + Xóa
    [Documentation]     người dùng chỉ có quyền Thiết lập giá: Xem DS + Cập nhật + Xóa
    [Tags]      PQ2
    [Template]    pqtlg4
    usertlg4    123    testpq2

Xem DS + Import
    [Documentation]     người dùng chỉ có quyền Thiết lập giá: Xem DS + Import
    [Tags]      PQ2
    [Template]    pqtlg5
    usertlg5    123    testpq4    ${file_imp}

Xem DS + Xuất file
    [Documentation]     người dùng chỉ có quyền Thiết lập giá: Xem DS + Xuất file
    [Tags]      PQ2
    [Template]    pqtlg6
    usertlg6   123


*** Keywords ***
pqtlg1
    [Documentation]     người dùng chỉ có quyền Thiết lập giá: Xem DS
    [Arguments]    ${taikhoan}    ${matkhau}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"SalesChannelIntegrate_Read":false,"SalesChannelIntegrate_Update":false,"SalesChannelIntegrate_Delete":false,"Clocking_Copy":false,"SalesChannelIntegrate_Create":false,"PriceBook_Read":true}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    #
    Before Test Thiet lap gia
    Element Should Not Be Visible    ${menu_giaodich}
    Element Should Not Be Visible    ${menu_doitac}
    Element Should Not Be Visible    ${domain_soquy}
    Element Should Not Be Visible    ${domain_baocao}
    Element Should Not Be Visible    ${button_banhang_on_quanly}
    Element Should Not Be Visible    ${button_them_banggia}
    Element Should Not Be Visible    ${button_chinhsua_banggia}
    Delete user    ${get_user_id}

pqtlg2
    [Documentation]     người dùng chỉ có quyền Thiết lập giá: Xem DS + Thêm mới
    [Arguments]    ${taikhoan}    ${matkhau}    ${input_banggia}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"SalesChannelIntegrate_Read":false,"SalesChannelIntegrate_Update":false,"SalesChannelIntegrate_Delete":false,"Clocking_Copy":false,"SalesChannelIntegrate_Create":false,"PriceBook_Read":true,"PriceBook_Create":true}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    #
    ${get_id_bg}      Get price book id     ${input_banggia}
    Run Keyword If    '${get_id_bg}'=='0'    Log    Ignore bg    ELSE      Delete price book thr API    ${input_banggia}
    Before Test Thiet lap gia
    Element Should Not Be Visible    ${menu_giaodich}
    Element Should Not Be Visible    ${menu_doitac}
    Element Should Not Be Visible    ${domain_soquy}
    Element Should Not Be Visible    ${domain_baocao}
    Element Should Not Be Visible    ${button_banhang_on_quanly}
    Element Should Not Be Visible    ${button_chinhsua_banggia}
    #
    Add new price book    ${input_banggia}
    Delete price book thr API    ${input_banggia}
    Delete user    ${get_user_id}

pqtlg3
    [Documentation]     người dùng chỉ có quyền Thiết lập giá: Xem DS + Cập nhật
    [Arguments]    ${taikhoan}    ${matkhau}    ${input_banggia}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"SalesChannelIntegrate_Read":false,"SalesChannelIntegrate_Update":false,"SalesChannelIntegrate_Delete":false,"Clocking_Copy":false,"SalesChannelIntegrate_Create":false,"PriceBook_Read":true,"PriceBook_Create":false,"PriceBook_Update":true}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    #
    ${get_id_bg}      Get price book id     ${input_banggia}
    Run Keyword If    '${get_id_bg}'=='0'    Log    Ignore bg    ELSE      Delete price book thr API    ${input_banggia}
    Add new price book and add all category - discount %    ${input_banggia}    15
    Before Test Thiet lap gia
    Element Should Not Be Visible    ${menu_giaodich}
    Element Should Not Be Visible    ${menu_doitac}
    Element Should Not Be Visible    ${domain_soquy}
    Element Should Not Be Visible    ${domain_baocao}
    Element Should Not Be Visible    ${button_banhang_on_quanly}
    #
    Select Bang gia for Bang gia    ${input_banggia}
    Wait Until Page Contains Element    ${button_chinhsua_banggia}    20s
    Click Element    ${button_chinhsua_banggia}
    Wait Until Page Contains Element    ${button_luu_banggia}    20s
    Click Element    ${button_luu_banggia}
    Update data success validation
    Delete price book thr API    ${input_banggia}
    Delete user    ${get_user_id}

pqtlg4
    [Documentation]     người dùng chỉ có quyền Thiết lập giá: Xem DS + Cập nhật + Xóa
    [Arguments]    ${taikhoan}    ${matkhau}    ${input_banggia}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"SalesChannelIntegrate_Read":false,"SalesChannelIntegrate_Update":false,"SalesChannelIntegrate_Delete":false,"Clocking_Copy":false,"SalesChannelIntegrate_Create":false,"PriceBook_Read":true,"PriceBook_Create":false,"PriceBook_Update":true,"PriceBook_Delete":true}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    #
    ${get_id_bg}      Get price book id     ${input_banggia}
    Run Keyword If    '${get_id_bg}'=='0'    Log    Ignore bg    ELSE      Delete price book thr API    ${input_banggia}
    Add new price book and add all category - discount %    ${input_banggia}    15
    Before Test Thiet lap gia
    Element Should Not Be Visible    ${menu_giaodich}
    Element Should Not Be Visible    ${menu_doitac}
    Element Should Not Be Visible    ${domain_soquy}
    Element Should Not Be Visible    ${domain_baocao}
    Element Should Not Be Visible    ${button_banhang_on_quanly}
    #
    Select Bang gia for Bang gia    ${input_banggia}
    Delete price book thr UI    ${input_banggia}
    Delete user    ${get_user_id}

pqtlg5
    [Documentation]     người dùng chỉ có quyền Thiết lập giá: Xem DS + CImport
    [Arguments]    ${taikhoan}    ${matkhau}    ${input_banggia}    ${input_excel_file}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"SalesChannelIntegrate_Read":false,"SalesChannelIntegrate_Update":false,"SalesChannelIntegrate_Delete":false,"Clocking_Copy":false,"SalesChannelIntegrate_Create":false,"PriceBook_Read":true,"PriceBook_Create":false,"PriceBook_Update":false,"PriceBook_Delete":false,"PriceBook_Import":true}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    #
    ${get_id_bg}      Get price book id     ${input_banggia}
    Run Keyword If    '${get_id_bg}'=='0'    Log    Ignore bg    ELSE      Delete price book thr API    ${input_banggia}
    Add new bang gia    ${input_banggia}
    Before Test Thiet lap gia
    Element Should Not Be Visible    ${menu_giaodich}
    Element Should Not Be Visible    ${menu_doitac}
    Element Should Not Be Visible    ${domain_soquy}
    Element Should Not Be Visible    ${domain_baocao}
    Element Should Not Be Visible    ${button_banhang_on_quanly}
    #
    Wait Until Page Contains Element    ${button_xoa_banggiachung}    1 min
    Click Element    ${button_xoa_banggiachung}
    Wait Until Keyword Succeeds    3 times    3s    Click Element JS      ${button_import}
    Choose File    ${button_chonfile}    ${input_excel_file}
    Wait Until Element Is Visible    ${button_uploadfile}
    Wait Until Keyword Succeeds    3 times    3s    Click Element      ${button_uploadfile}
    Wait Until Keyword Succeeds    3 times    4s     Wait Until Element Contains    ${toast_message_import}    Import thành công. Nhấn phím F5 để thấy dữ liệu mới nhất.    2 mins
    Delete price book thr API    ${input_banggia}
    Delete user    ${get_user_id}

pqtlg6
    [Documentation]     người dùng chỉ có quyền Thiết lập giá: Xem DS + Xuất file
    [Arguments]    ${taikhoan}    ${matkhau}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"PriceBook_Read":true,"PriceBook_Import":false,"Clocking_Copy":false,"PriceBook_Export":true}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    #
    Before Test Thiet lap gia
    Element Should Not Be Visible    ${menu_giaodich}
    Element Should Not Be Visible    ${menu_doitac}
    Element Should Not Be Visible    ${domain_soquy}
    Element Should Not Be Visible    ${domain_baocao}
    Element Should Not Be Visible    ${button_banhang_on_quanly}
    #
    Click Element       ${button_export}
    Wait Until Keyword Succeeds    3 times    3s    Element Should Contain    ${noti_export}    Nhấn vào đây để tải xuống
    Delete user    ${get_user_id}
