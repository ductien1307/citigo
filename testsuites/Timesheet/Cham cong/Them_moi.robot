*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    ${headless_browser}
Test Setup        Before Test Cham cong
Test Teardown     After Test
Resource          ../../../config/env_product/envi.robot
Resource          ../../../core/Nhan_vien/nhanvien_list_action.robot
Resource          ../../../core/share/discount.robot
Resource          ../../../core/share/toast_message.robot
Resource          ../../../core/Thiet_lap/nguoidung_list_action.robot
Resource          ../../../core/Thiet_lap/nguoidung_list_page.robot
Resource          ../../../core/Nhan_vien/chamcong_list_action.robot
Resource          ../../../core/Nhan_vien/chamcong_list_page.robot
Resource          ../../../core/API/api_nhanvien.robot
Resource          ../../../core/API/api_chamcong.robot
Resource          ../../../core/Thiet_lap/thiet_lap_nav.robot
Resource          ../../../core/share/computation.robot
Library           String
Library           SeleniumLibrary
Library           Collections

*** Variables ***

*** Test Cases ***
Them ca
    [Tags]       TS2
    [Template]    ecc1
    Ca test       08:00         14:00

Them nhan vien
    [Tags]       TS2
    [Template]    ecc2
    NVT001      Nguyễn Văn Trung      05111991    Nam       32563245      Phòng kế toán       Nhân viên     abc     son.dx        098659854     trung.nv@gmail.com       none        Hà Nội      Hà Nội - Quận Ba Đình     Phường Nguyễn Trung Trực
    NVT002      Đặng Thu Thảo     none    Nữ       6542352      Phòng hành chính       Trưởng phòng     none    none        none     none       none        Hà Nội      none     none


*** Keywords ***
ecc1
    [Arguments]     ${input_ten_ca}     ${input_gio_bd}      ${input_gio_kt}
    Set Selenium Speed    0.1
    ${get_calv_id}    Get shift id by branch thr API    ${input_ten_ca}     Chi nhánh trung tâm
    Run Keyword If    ${get_calv_id}!=0     Delete shift thr API    ${input_ten_ca}     Chi nhánh trung tâm     ELSE    Log    Ingore
    Wait Until Page Contains Element    ${button_them_ca_lv}      30s
    Click Element    ${button_them_ca_lv}
    Wait Until Page Contains Element    ${textbox_ten_ca}      30s
    Input data    ${textbox_ten_ca}     ${input_ten_ca}
    Input data    ${textbox_giolam_batdau}     ${input_gio_bd}
    Input data    ${textbox_giolam_kethuc}     ${input_gio_kt}
    Click Element    ${button_luu_ca_lv}
    Create shift success validation
    #${input_gio_bd}     Convert time      ${input_gio_bd}
    #${input_gio_kt}     Convert time      ${input_gio_kt}
    #${input_gio_bd}     Replace floating point      ${input_gio_bd}
    #${input_gio_kt}     Replace floating point      ${input_gio_kt}
    ${get_gio_bd}      ${get_gio_kt}   Get shift infor thr API   ${input_ten_ca}    ${BRANCH_ID}
    Should Be Equal As Strings     ${input_gio_bd}    ${get_gio_bd}
    Should Be Equal As Strings     ${input_gio_kt}    ${get_gio_kt}
    Delete shift thr API    ${input_ten_ca}     Chi nhánh trung tâm

ecc2
    [Arguments]     ${input_ma_nv}    ${input_ten_nv}     ${input_ngay_sinh}    ${input_gioitinh}   ${input_cmtnd}    ${input_phongban}     ${input_chucdanh}     ${input_ghichu}    ${input_nguoidung}      ${input_sdt}      ${input_email}    ${input_facebook}      ${input_diachi}      ${input_khuvuc}     ${input_phuongxa}
    Set Selenium Speed    0.1
    ${get_nv_id}      Get employee id thr API    ${input_ma_nv}
    Run Keyword If    ${get_nv_id}==0    Log    Ignore        ELSE      Delete employee thr API    ${input_ma_nv}
    Reload Page
    Wait Until Page Contains Element    ${button_lichlamviec_thang}     20s
    Click Element    ${button_lichlamviec_thang}
    Wait Until Page Contains Element    ${button_them_nv}     20s
    Click Element    ${button_them_nv}
    Input data in popup Them moi nhan vien     ${input_ma_nv}    ${input_ten_nv}     ${input_ngay_sinh}    ${input_gioitinh}   ${input_cmtnd}    ${input_phongban}     ${input_chucdanh}    ${input_ghichu}       ${input_sdt}      ${input_email}    ${input_facebook}      ${input_diachi}      ${input_khuvuc}     ${input_phuongxa}
    Run Keyword If    '${input_nguoidung}'!='none'    Select combobox any form and click element    ${cell_chonnguoidung}    ${item_nguoidung_in_dropdownist}       ${input_nguoidung}   ELSE    Log    Ignore
    Click Element    ${button_luu_nv}
    Create employee success validation
    Sleep    5s
    Get employee info and validate    ${input_ma_nv}    ${input_ten_nv}     ${input_ngay_sinh}    ${input_gioitinh}   ${input_cmtnd}    ${input_phongban}     ${input_chucdanh}     ${input_ghichu}    ${input_nguoidung}      ${input_sdt}      ${input_email}    ${input_facebook}      ${input_diachi}      ${input_khuvuc}     ${input_phuongxa}
    Delete employee thr API    ${input_ma_nv}
