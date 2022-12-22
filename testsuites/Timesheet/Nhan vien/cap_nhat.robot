*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    ${headless_browser}
Test Setup        Before Test Nhan vien
Test Teardown     After Test
Library           String
Library           SeleniumLibrary
Library           Collections
Library           OperatingSystem
Resource          ../../../config/env_product/envi.robot
Resource          ../../../core/Nhan_vien/nhanvien_list_action.robot
Resource          ../../../core/share/discount.robot
Resource          ../../../core/share/toast_message.robot
Resource          ../../../core/Thiet_lap/nguoidung_list_action.robot
Resource          ../../../core/Thiet_lap/nguoidung_list_page.robot
Resource          ../../../core/API/api_nhanvien.robot
Resource          ../../../core/Thiet_lap/thiet_lap_nav.robot

*** Variables ***

*** Test Cases ***
Cap nhat
    [Tags]      NV    TS1
    [Template]    ecnnv1
    NV04    Đăng Hoa       NV05      Đăng Hoa      05111991    Nam       32563245      Phòng kế toán       Nhân viên     abc     an.nt        098659854     none       none        Hà Nội      Hà Nội - Quận Ba Đình     Phường Nguyễn Trung Trực

Cap nhat + Them moi
    [Tags]      NV    TS1
    [Template]    ecnnv2
    NV07    Pham Linh       NV08      Pham Linh      none    Nữ       32563245      Phòng kế toán       Nhân viên     abc      098659854     none       none        Hà Nội      none     none    Trần Quang Huy    huy.tq      123         Quản trị chi nhánh    Chi nhánh trung tâm     none   none      none

*** Keywords ***
ecnnv1
    [Arguments]     ${ma_nv_bf}    ${ten_nv_bf}   ${input_ma_nv}    ${input_ten_nv}     ${input_ngay_sinh}    ${input_gioitinh}   ${input_cmtnd}    ${input_phongban}     ${input_chucdanh}     ${input_ghichu}    ${input_nguoidung}      ${input_sdt}      ${input_email}    ${input_facebook}      ${input_diachi}      ${input_khuvuc}     ${input_phuongxa}
    Set Selenium Speed    0.1
    ${get_nv_bf_id}      Get employee id thr API    ${ma_nv_bf}
    ${get_nv_id}      Get employee id thr API    ${input_ma_nv}
    Run Keyword If    ${get_nv_bf_id}==0    Add employee thr API    ${ma_nv_bf}    ${ten_nv_bf}     Chi nhánh trung tâm       ELSE      Log    Ingore
    Run Keyword If    ${get_nv_id}==0    Log    Ignore        ELSE      Delete employee thr API    ${input_ma_nv}
    Reload Page
    Search employee and click update    ${ma_nv_bf}
    Input data in popup Them moi nhan vien     ${input_ma_nv}    ${input_ten_nv}     ${input_ngay_sinh}    ${input_gioitinh}   ${input_cmtnd}    ${input_phongban}     ${input_chucdanh}    ${input_ghichu}       ${input_sdt}      ${input_email}    ${input_facebook}      ${input_diachi}      ${input_khuvuc}     ${input_phuongxa}
    Run Keyword If    '${input_nguoidung}'!='none'    Select combobox any form and click element    ${cell_chonnguoidung}    ${item_nguoidung_in_dropdownist}       ${input_nguoidung}   ELSE    Log    Ignore
    Click Element    ${button_luu_nv}
    Update employee success validation
    Sleep    3s
    Get employee info and validate    ${input_ma_nv}    ${input_ten_nv}     ${input_ngay_sinh}    ${input_gioitinh}   ${input_cmtnd}    ${input_phongban}     ${input_chucdanh}     ${input_ghichu}    ${input_nguoidung}      ${input_sdt}      ${input_email}    ${input_facebook}      ${input_diachi}      ${input_khuvuc}     ${input_phuongxa}
    Delete employee thr API    ${input_ma_nv}

ecnnv2
    [Arguments]     ${ma_nv_bf}    ${ten_nv_bf}   ${input_ma_nv}    ${input_ten_nv}     ${input_ngay_sinh}    ${input_gioitinh}   ${input_cmtnd}    ${input_phongban}     ${input_chucdanh}     ${input_ghichu}       ${input_sdt}      ${input_email}    ${input_facebook}      ${input_diachi}      ${input_khuvuc}     ${input_phuongxa}
    ...   ${input_name}   ${input_username}    ${input_pass}   ${permission}    ${branch}    ${input_phone}    ${input_email}     ${input_note}
    Set Selenium Speed    0.1
    ${get_nv_bf_id}      Get employee id thr API    ${ma_nv_bf}
    ${get_nv_id}      Get employee id thr API    ${input_ma_nv}
    ${get_user_id}    Get User ID by UserName    ${input_username}
    Run Keyword If    '${get_user_id}' == '0'    Log    Ignore     ELSE      Delete user    ${get_user_id}
    Run Keyword If    ${get_nv_bf_id}==0    Add employee thr API    ${ma_nv_bf}    ${ten_nv_bf}   Chi nhánh trung tâm       ELSE     Log    ignore
    Run Keyword If    ${get_nv_id}==0    Log    Ignore      ELSE      Delete employee thr API    ${input_ma_nv}
    Reload Page
    Search employee and click update    ${ma_nv_bf}
    Wait Until Page Contains Element    ${button_them_nguoi_dung}   30s
    Click Element    ${button_them_nguoi_dung}
    Input data in popup Them moi nguoi dung    ${input_name}   ${input_username}    ${input_pass}   ${permission}    ${branch}    ${input_phone}    ${input_email}     ${input_note}
    Update data success validation
    Input data in popup Them moi nhan vien     ${input_ma_nv}    ${input_ten_nv}     ${input_ngay_sinh}    ${input_gioitinh}   ${input_cmtnd}    ${input_phongban}     ${input_chucdanh}    ${input_ghichu}       ${input_sdt}      ${input_email}    ${input_facebook}      ${input_diachi}      ${input_khuvuc}     ${input_phuongxa}
    Click Element    ${button_luu_nv}
    Update employee success validation
    Sleep    3s
    Get employee info and validate    ${input_ma_nv}    ${input_ten_nv}     ${input_ngay_sinh}    ${input_gioitinh}   ${input_cmtnd}    ${input_phongban}     ${input_chucdanh}     ${input_ghichu}    ${input_username}      ${input_sdt}      ${input_email}    ${input_facebook}      ${input_diachi}      ${input_khuvuc}     ${input_phuongxa}
    Delete employee thr API    ${input_ma_nv}
