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
    [Documentation]     người dùng chỉ có quyền Nhân viên: Xem DS
    [Tags]      PQ7
    [Template]    pqnv1
    usernv1    123

Xem DS + Thêm mới
    [Documentation]     người dùng chỉ có quyền Nhân viên: Xem DS + Thêm mới
    [Tags]      PQ7
    [Template]     pqnv2
    usernv2    123          PQNV1      Thùy Trâm     none    Nữ       none      Phòng hành chính       Trưởng phòng     none    none        none     none       none        Hà Nội      none     none

Xem DS + Cập nhật
    [Documentation]     người dùng chỉ có quyền Nhân viên: Xem DS + Cập nhật
    [Tags]      PQ7
    [Template]      pqnv3
    usernv3    123      PQNV2    Đăng Hoa       PQNV3      Đăng Hoa      none    Nam       none      Phòng kế toán       Nhân viên     abc     none        none     none       none        Hà Nội      none     none

Xem DS + Xóa
    [Documentation]     người dùng chỉ có quyền Nhân viên: Xem DS + Xóa
    [Tags]      PQ7
    [Template]      pqnv4
    usernv4    123        PQNV4    Đăng Hoa

*** Keywords ***
pqnv1
    [Documentation]     người dùng chỉ có quyền Nhân viên Xem DS
    [Arguments]    ${taikhoan}    ${matkhau}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"FinancialReport_SalePerformanceReport":false,"Clocking_Copy":false,"Employee_Read":true}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
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
    Delete user    ${get_user_id}

pqnv2
    [Documentation]     người dùng chỉ có quyền Nhân viên Xem DS + Thêm mới
    [Arguments]    ${taikhoan}    ${matkhau}     ${input_ma_nv}    ${input_ten_nv}     ${input_ngay_sinh}    ${input_gioitinh}   ${input_cmtnd}    ${input_phongban}     ${input_chucdanh}     ${input_ghichu}    ${input_nguoidung}      ${input_sdt}      ${input_email}    ${input_facebook}      ${input_diachi}      ${input_khuvuc}     ${input_phuongxa}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_nv_id}      Get employee id thr API    ${input_ma_nv}
    Run Keyword If    ${get_nv_id}==0    Log    Ignore        ELSE      Delete employee thr API    ${input_ma_nv}
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"Employee_Read":true,"Clocking_Copy":false,"Employee_Create":true}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    Before Test Nhan vien
    #
    Log    validate UI
    Wait Until Page Contains Element    ${button_them_nhan_vien}    30s
    Element Should Not Be Visible    ${menu_giaodich}
    Element Should Not Be Visible    ${menu_hh}
    Element Should Not Be Visible    ${menu_doitac}
    Element Should Not Be Visible    ${domain_baocao}
    Element Should Not Be Visible    ${menu_soquy}
    Element Should Not Be Visible    ${button_banhang_on_quanly}
    Click Element    ${button_them_nhan_vien}
    Input data in popup Them moi nhan vien     ${input_ma_nv}    ${input_ten_nv}     ${input_ngay_sinh}    ${input_gioitinh}   ${input_cmtnd}    ${input_phongban}     ${input_chucdanh}    ${input_ghichu}       ${input_sdt}      ${input_email}    ${input_facebook}      ${input_diachi}      ${input_khuvuc}     ${input_phuongxa}
    Run Keyword If    '${input_nguoidung}'!='none'    Select combobox any form and click element    ${cell_chonnguoidung}    ${item_nguoidung_in_dropdownist}       ${input_nguoidung}   ELSE    Log    Ignore
    Click Element    ${button_luu_nv}
    Create employee success validation
    Sleep    3s
    Get employee info and validate    ${input_ma_nv}    ${input_ten_nv}     ${input_ngay_sinh}    ${input_gioitinh}   ${input_cmtnd}    ${input_phongban}     ${input_chucdanh}     ${input_ghichu}    ${input_nguoidung}      ${input_sdt}      ${input_email}    ${input_facebook}      ${input_diachi}      ${input_khuvuc}     ${input_phuongxa}
    Wait Until Keyword Succeeds    3 times    3s    Delete employee thr API    ${input_ma_nv}
    Delete user    ${get_user_id}

pqnv3
    [Documentation]     người dùng chỉ có quyền Nhân viên Xem DS + Cập nhật
    [Arguments]    ${taikhoan}    ${matkhau}      ${ma_nv_bf}    ${ten_nv_bf}   ${input_ma_nv}    ${input_ten_nv}     ${input_ngay_sinh}    ${input_gioitinh}   ${input_cmtnd}    ${input_phongban}     ${input_chucdanh}     ${input_ghichu}    ${input_nguoidung}      ${input_sdt}      ${input_email}    ${input_facebook}      ${input_diachi}      ${input_khuvuc}     ${input_phuongxa}
    Set Selenium Speed    0.1
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_nv_bf_id}      Get employee id thr API    ${ma_nv_bf}
    ${get_nv_id}      Get employee id thr API    ${input_ma_nv}
    Run Keyword If    ${get_nv_bf_id}==0    Add employee thr API    ${ma_nv_bf}    ${ten_nv_bf}     Chi nhánh trung tâm       ELSE      Log    Ingore
    Run Keyword If    ${get_nv_id}==0    Log    Ignore        ELSE      Delete employee thr API    ${input_ma_nv}
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"Employee_Read":true,"Clocking_Copy":false,"Employee_Create":false,"Employee_Update":true}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    Before Test Nhan vien
    #
    Log    validate UI
    Wait Until Page Contains Element    ${button_them_nhan_vien}    30s
    Element Should Not Be Visible    ${menu_giaodich}
    Element Should Not Be Visible    ${menu_hh}
    Element Should Not Be Visible    ${menu_doitac}
    Element Should Not Be Visible    ${domain_baocao}
    Element Should Not Be Visible    ${menu_soquy}
    Element Should Not Be Visible    ${button_banhang_on_quanly}
    Element Should Not Be Visible    ${button_them_nhan_vien}
    Search employee and click update    ${ma_nv_bf}
    Input data in popup Them moi nhan vien     ${input_ma_nv}    ${input_ten_nv}     ${input_ngay_sinh}    ${input_gioitinh}   ${input_cmtnd}    ${input_phongban}     ${input_chucdanh}    ${input_ghichu}       ${input_sdt}      ${input_email}    ${input_facebook}      ${input_diachi}      ${input_khuvuc}     ${input_phuongxa}
    Run Keyword If    '${input_nguoidung}'!='none'    Select combobox any form and click element    ${cell_chonnguoidung}    ${item_nguoidung_in_dropdownist}       ${input_nguoidung}   ELSE    Log    Ignore
    Click Element    ${button_luu_nv}
    Update employee success validation
    Sleep    3s
    Get employee info and validate    ${input_ma_nv}    ${input_ten_nv}     ${input_ngay_sinh}    ${input_gioitinh}   ${input_cmtnd}    ${input_phongban}     ${input_chucdanh}     ${input_ghichu}    ${input_nguoidung}      ${input_sdt}      ${input_email}    ${input_facebook}      ${input_diachi}      ${input_khuvuc}     ${input_phuongxa}
    Delete employee thr API    ${input_ma_nv}
    Delete user    ${get_user_id}

pqnv4
    [Documentation]     người dùng chỉ có quyền Nhân viên Xem DS + Xóa
    [Arguments]    ${taikhoan}    ${matkhau}     ${input_ma_nv}    ${input_ten_nv}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_nv_id}      Get employee id thr API    ${input_ma_nv}
    Run Keyword If    ${get_nv_id}==0    Add employee thr API    ${input_ma_nv}    ${input_ten_nv}    Chi nhánh trung tâm      ELSE    Log    ignore
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"Employee_Read":true,"Clocking_Copy":false,"Employee_Create":false,"Employee_Update":false,"Employee_Delete":true}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    Before Test Nhan vien
    #
    Log    validate UI
    Wait Until Page Contains Element    ${button_them_nhan_vien}    30s
    Element Should Not Be Visible    ${menu_giaodich}
    Element Should Not Be Visible    ${menu_hh}
    Element Should Not Be Visible    ${menu_doitac}
    Element Should Not Be Visible    ${domain_baocao}
    Element Should Not Be Visible    ${menu_soquy}
    Element Should Not Be Visible    ${button_banhang_on_quanly}
    Element Should Not Be Visible    ${button_them_nhan_vien}
    Search employee and click delete    ${input_ma_nv}
    Click Element    ${button_dongy_xoa_nv}
    Delete employee success validation
    Delete user    ${get_user_id}
