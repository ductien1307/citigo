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
Resource          ../../../core/share/global.robot
Resource          ../../../core/share/toast_message.robot
Resource          ../../../core/Thiet_lap/nguoidung_list_action.robot
Resource          ../../../core/Thiet_lap/nguoidung_list_page.robot
Resource          ../../../core/API/api_nhanvien.robot
Resource          ../../../core/Thiet_lap/thiet_lap_nav.robot

*** Variables ***

*** Test Cases ***
Them moi
    [Tags]    NV    TS1
    [Template]    etnv1
    NV01      Nguyễn Văn Trung      05111991    Nam       32563245      Phòng kế toán       Nhân viên     abc     son.dx        098659854     trung.nv@gmail.com       none        Hà Nội      Hà Nội - Quận Ba Đình     Phường Nguyễn Trung Trực
    NV02      Đặng Thu Thảo     none    Nữ       6542352      Phòng hành chính       Trưởng phòng     none    none        none     none       none        Hà Nội      none     none

Them moi + Tao moi user
    [Tags]      NV    TS1
    [Template]    etnv2
    NV03      Nguyễn Đăng Quang     none    Nam       32563245      Phòng hành chính       Nhân viên     abc        098659854     none      none        Hà Nội      Hà Nội - Quận Ba Đình     Phường Nguyễn Trung Trực        Mai Thùy Linh   linh.mt      123         Quản trị chi nhánh    Chi nhánh trung tâm     none   none      none

Them moi GOLIVE
    [Tags]             GOLIVE3   CTP   TS05
    [Documentation]    MHQL - THÊM MỚI NHÂN VIÊN
    [Template]         etnv1
    NV01   Nguyễn Văn Trung   05111991   Nam   32563245   Phòng kế toán   Nhân viên   abc   son.dx   098659854   trung.nv@gmail.com   none        Hà Nội   Hà Nội - Quận Ba Đình   Phường Nguyễn Trung Trực

*** Keywords ***
etnv1
    [Arguments]   ${input_ma_nv}   ${input_ten_nv}   ${input_ngay_sinh}   ${input_gioitinh}   ${input_cmtnd}   ${input_phongban}     ${input_chucdanh}   ${input_ghichu}   ${input_nguoidung}   ${input_sdt}   ${input_email}   ${input_facebook}   ${input_diachi}   ${input_khuvuc}   ${input_phuongxa}
    ${get_nv_id}   Get employee id thr API   ${input_ma_nv}
    Run Keyword If   ${get_nv_id}==0   Log   Ignore   ELSE   Delete employee thr API   ${input_ma_nv}
    Reload Page
    Click Element Global   ${button_them_nhan_vien}
    Input data in popup Them moi nhan vien   ${input_ma_nv}   ${input_ten_nv}   ${input_ngay_sinh}   ${input_gioitinh}   ${input_cmtnd}    ${input_phongban}   ${input_chucdanh}   ${input_ghichu}   ${input_sdt}   ${input_email}   ${input_facebook}   ${input_diachi}      ${input_khuvuc}   ${input_phuongxa}
    Run Keyword If   '${input_nguoidung}'!='none'   Select combobox any form and click element   ${cell_chonnguoidung}    ${item_nguoidung_in_dropdownist}   ${input_nguoidung}   ELSE   Log   Ignore
    Click Element Global   ${button_luu_nv}
    Create employee success validation
    Wait Until Keyword Succeeds   3x   3s   Get employee info and validate   ${input_ma_nv}   ${input_ten_nv}   ${input_ngay_sinh}    ${input_gioitinh}   ${input_cmtnd}   ${input_phongban}   ${input_chucdanh}   ${input_ghichu}   ${input_nguoidung}   ${input_sdt}      ${input_email}   ${input_facebook}   ${input_diachi}   ${input_khuvuc}   ${input_phuongxa}
    Wait Until Keyword Succeeds   3 times   3s   Delete employee thr API   ${input_ma_nv}

etnv2
    [Arguments]     ${input_ma_nv}    ${input_ten_nv}     ${input_ngay_sinh}    ${input_gioitinh}   ${input_cmtnd}    ${input_phongban}     ${input_chucdanh}     ${input_ghichu}     ${input_sdt}      ${input_email}    ${input_facebook}      ${input_diachi}      ${input_khuvuc}     ${input_phuongxa}
    ...   ${input_name}   ${input_username}    ${input_pass}   ${permission}    ${branch}    ${input_phone}    ${input_email}     ${input_note}
    ${get_user_id}    Get User ID by UserName    ${input_username}
    Run Keyword If    '${get_user_id}' == '0'    Log    Ignore     ELSE      Delete user    ${get_user_id}
    ${get_nv_id}      Get employee id thr API    ${input_ma_nv}
    Run Keyword If    ${get_nv_id}==0    Log    Ignore        ELSE      Delete employee thr API    ${input_ma_nv}
    Reload Page
    Click Element Global    ${button_them_nhan_vien}
    Click Element Global    ${button_them_nguoi_dung}
    Input data in popup Them moi nguoi dung    ${input_name}   ${input_username}    ${input_pass}   ${permission}    ${branch}    ${input_phone}    ${input_email}     ${input_note}
    Update data success validation
    Input data in popup Them moi nhan vien     ${input_ma_nv}    ${input_ten_nv}     ${input_ngay_sinh}    ${input_gioitinh}   ${input_cmtnd}    ${input_phongban}     ${input_chucdanh}    ${input_ghichu}       ${input_sdt}      ${input_email}    ${input_facebook}      ${input_diachi}      ${input_khuvuc}     ${input_phuongxa}
    Click Element Global    ${button_luu_nv}
    Create employee success validation
    Sleep    3s
    Get employee info and validate    ${input_ma_nv}    ${input_ten_nv}     ${input_ngay_sinh}    ${input_gioitinh}   ${input_cmtnd}    ${input_phongban}     ${input_chucdanh}     ${input_ghichu}    ${input_username}      ${input_sdt}      ${input_email}    ${input_facebook}      ${input_diachi}      ${input_khuvuc}     ${input_phuongxa}
    ${get_user_id}    Get user info and validate    ${input_username}    ${input_phone}      ${permission}    ${input_email}    ${branch}
    Delete user    ${get_user_id}
    Wait Until Keyword Succeeds    3 times    3s    Delete employee thr API    ${input_ma_nv}
