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
Resource          ../../../core/Hang_hoa/sanxuat_list_action.robot
Resource          ../../../core/Hang_hoa/tao_phieu_sx_action.robot
Resource          ../../../core/Hang_hoa/phieu_bao_hanh_list_action.robot
Resource          ../../../prepare/Hang_hoa/Sources/hanghoa.robot
Resource          ../../../core/API/api_sanxuat.robot
Resource          ../../../core/Ban_Hang/banhang_manager_navigation.robot

*** Variables ***
${file_imp}    ${EXECDIR}${/}testsuites${/}Phan quyen${/}Hang hoa${/}MauFileBangGia.xlsx

*** Test Cases ***
Xem DS
    [Documentation]     người dùng chỉ có quyền Xản xuất: Xem DS
    [Tags]       PQ2
    [Template]    pqsx1
    usersx1    123

Xem DS + Thêm mới
    [Documentation]     người dùng chỉ có quyền  Xản xuất: Xem DS + Thêm mới, Hàng hóa: Xem DS
    [Tags]        PQ2
    [Template]    pqsx2
    usersx2    123       SPSX0001

Xem DS + Cập nhật
    [Documentation]     người dùng chỉ có quyền  Xản xuất: Xem DS + Cập nhật, Hàng hóa: Xem DS
    [Tags]        PQ2
    [Template]    pqsx3
    usersx3    123    SPSX0001

Xem DS + Cập nhật + Xóa
    [Documentation]     người dùng chỉ có quyền  Xản xuất: Xem DS + Cập nhật + Xóa, Hàng hóa: Xem DS
    [Tags]        PQ2
    [Template]    pqsx4
    usersx4    123    SPSX0001

Xem DS + Xuất file
    [Documentation]     người dùng chỉ có quyền  Xản xuất: Xem DS + Xuất file, Hàng hóa: Xem DS
    [Tags]         PQ2
    [Template]    pqsx5
    usersx5   123     SPSX0001


*** Keywords ***
pqsx1
    [Documentation]     người dùng chỉ có quyền  Xản xuất: Xem DS
    [Arguments]    ${taikhoan}    ${matkhau}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"Manufacturing_Read":true,"Clocking_Copy":false}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    #
    Before Test San xuat
    Element Should Not Be Visible    ${menu_giaodich}
    Element Should Not Be Visible    ${menu_doitac}
    Element Should Not Be Visible    ${domain_soquy}
    Element Should Not Be Visible    ${domain_baocao}
    Element Should Not Be Visible    ${button_banhang_on_quanly}
    Wait Until Page Contains Element    ${textbox_search_ma_sx}   30s
    Element Should Not Be Visible    ${button_taophieu_sx}
    Element Should Not Be Visible    ${button_xuatfile_phieu_sx}
    Delete user    ${get_user_id}

pqsx2
    [Documentation]     người dùng chỉ có quyền  Xản xuất: Xem DS + Thêm mới, Hàng hóa: Xem DS
    [Arguments]    ${taikhoan}    ${matkhau}      ${ma_sp}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_pr_id}    Get product ID    ${ma_sp}
    Run Keyword If    ${get_pr_id}==0        Add product manufacturing    ${ma_sp}    Hàng sản xuất    Đồ ăn vặt    50000   3   TPG18     2    TPG19     3
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"Manufacturing_Read":true,"Clocking_Copy":false,"Manufacturing_Create":true,"Product_Read":true}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    #
    Before Test San xuat
    Element Should Not Be Visible    ${menu_giaodich}
    Element Should Not Be Visible    ${menu_doitac}
    Element Should Not Be Visible    ${domain_soquy}
    Element Should Not Be Visible    ${domain_baocao}
    Element Should Not Be Visible    ${button_banhang_on_quanly}
    Wait Until Page Contains Element    ${textbox_search_ma_sx}   30s
    Element Should Not Be Visible    ${button_xuatfile_phieu_sx}
    Click Element       ${button_taophieu_sx}
    ${ma_phieu}     Generate code automatically    SX
    Input data to Thong tin Sx    ${ma_phieu}   ${ma_sp}
    Click Element    ${button_hoanthanh}
    Update data success validation
    Delete manufacturing thr API    ${ma_phieu}
    Delete user    ${get_user_id}

pqsx3
    [Documentation]     người dùng chỉ có quyền  Xản xuất: Xem DS + Cập nhật, Hàng hóa: Xem DS
    [Arguments]    ${taikhoan}    ${matkhau}      ${ma_sp}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_pr_id}    Get product ID    ${ma_sp}
    Run Keyword If    ${get_pr_id}==0        Add product manufacturing    ${ma_sp}    Hàng sản xuất    Đồ ăn vặt    50000   6    TPG18     2    TPG19     3
    ${get_ma_phieu}     Add manufacturing thr API    ${ma_sp}    1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"Manufacturing_Read":true,"Clocking_Copy":false,"Manufacturing_Create":false,"Product_Read":true,"Manufacturing_Update":true}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    #
    Before Test San xuat
    Sleep    40s
    Element Should Not Be Visible    ${menu_giaodich}
    Element Should Not Be Visible    ${menu_doitac}
    Element Should Not Be Visible    ${domain_soquy}
    Element Should Not Be Visible    ${domain_baocao}
    Element Should Not Be Visible    ${button_banhang_on_quanly}
    Wait Until Page Contains Element    ${textbox_search_ma_sx}   30s
    Element Should Not Be Visible    ${button_xuatfile_phieu_sx}
    Element Should Not Be Visible    ${button_taophieu_sx}
    Input data        ${textbox_search_ma_sx}       ${get_ma_phieu}
    Wait Until Page Contains Element    ${button_capnhat_phieu_sx}    20s
    Click Element    ${button_capnhat_phieu_sx}
    Wait Until Page Contains Element    ${button_luu_phieu_sx}    20s
    Click Element    ${button_luu_phieu_sx}
    Update data success validation
    Delete manufacturing thr API    ${get_ma_phieu}
    Delete user    ${get_user_id}

pqsx4
    [Documentation]     người dùng chỉ có quyền  Xản xuất: Xem DS + Cập nhật + Xóa, Hàng hóa: Xem DS
    [Arguments]    ${taikhoan}    ${matkhau}      ${ma_sp}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_pr_id}    Get product ID    ${ma_sp}
    Run Keyword If    ${get_pr_id}==0        Add product manufacturing    ${ma_sp}    Hàng sản xuất    Đồ ăn vặt    50000   3   TPG18     2    TPG19     3
    ${get_ma_phieu}     Add manufacturing thr API    ${ma_sp}    1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"Manufacturing_Read":true,"Clocking_Copy":false,"Manufacturing_Create":false,"Product_Read":true,"Manufacturing_Update":true,"Manufacturing_Delete":true,"Product_Delete":false}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    #
    Before Test San xuat
    Element Should Not Be Visible    ${menu_giaodich}
    Element Should Not Be Visible    ${menu_doitac}
    Element Should Not Be Visible    ${domain_soquy}
    Element Should Not Be Visible    ${domain_baocao}
    Element Should Not Be Visible    ${button_banhang_on_quanly}
    Wait Until Page Contains Element    ${textbox_search_ma_sx}   30s
    Element Should Not Be Visible    ${button_xuatfile_phieu_sx}
    Element Should Not Be Visible    ${button_taophieu_sx}
    Input data        ${textbox_search_ma_sx}       ${get_ma_phieu}
    Wait Until Page Contains Element    ${button_huybo_phieu_sx}      20s
    Element Should Be Visible    ${button_capnhat_phieu_sx}
    Click Element JS    ${button_huybo_phieu_sx}
    Wait Until Page Contains Element    ${button_dongy_huybo_phieu_sx}    20s
    Click Element    ${button_dongy_huybo_phieu_sx}
    Wait Until Page Contains Element    ${toast_message}    2 min
    Element Should Contain    ${toast_message}    Hủy phiếu sản xuất:: ${get_ma_phieu} thành công
    Delete user    ${get_user_id}

pqsx5
    [Documentation]     người dùng chỉ có quyền  Xản xuất: Xem DS + Xuất file, Hàng hóa: Xem DS
    [Arguments]    ${taikhoan}    ${matkhau}      ${ma_sp}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_pr_id}    Get product ID    ${ma_sp}
    Run Keyword If    ${get_pr_id}==0        Add product manufacturing    ${ma_sp}    Hàng sản xuất    Đồ ăn vặt    50000    3   TPG18     2    TPG19     3
    ${get_ma_phieu}     Add manufacturing thr API    ${ma_sp}    1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"Manufacturing_Read":true,"Clocking_Copy":false,"Manufacturing_Create":false,"Product_Read":true,"Manufacturing_Update":false,"Manufacturing_Delete":false,"Product_Delete":false,"Manufacturing_Export":true}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    #
    Before Test San xuat
    Element Should Not Be Visible    ${menu_giaodich}
    Element Should Not Be Visible    ${menu_doitac}
    Element Should Not Be Visible    ${domain_soquy}
    Element Should Not Be Visible    ${domain_baocao}
    Element Should Not Be Visible    ${button_banhang_on_quanly}
    Wait Until Page Contains Element    ${textbox_search_ma_sx}   30s
    Element Should Not Be Visible    ${button_taophieu_sx}
    Go to select export file manufacturing    ${button_xuatfile_tongquan_sx}
    Wait Until Keyword Succeeds    3 times    3s    Element Should Contain    ${noti_export}    Nhấn vào đây để tải xuống
    Delete manufacturing thr API    ${get_ma_phieu}
    Delete user    ${get_user_id}
