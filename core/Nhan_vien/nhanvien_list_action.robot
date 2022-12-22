*** Settings ***
Library           SeleniumLibrary
Resource          ../share/constants.robot
Resource          ../share/global.robot
Resource          ../share/toast_message.robot
Resource          nhanvien_list_page.robot
Resource          ../Thiet_lap/thiet_lap_nav.robot

*** Keywords ***
Search employee
    [Arguments]   ${input_ma_nv}
    Wait Until Page Contains Element    ${textbox_search_nv}    1 min
    Input data      ${textbox_search_nv}      ${input_ma_nv}
    Wait Until Page Contains Element    ${button_capnhat_nv}     30s

Search employee and click update
    [Arguments]   ${input_ma_nv}
    Search employee    ${input_ma_nv}
    Wait Until Page Contains Element    ${button_capnhat_nv}    30s
    Wait Until Keyword Succeeds    3 times    3s    Click Element    ${button_capnhat_nv}
    Wait Until Page Contains Element    ${textbox_ma_nhan_vien}     30s

Search employee and click delete
    [Arguments]   ${input_ma_nv}
    Search employee    ${input_ma_nv}
    Wait Until Page Contains Element    ${button_xoa_nv}    30s
    Wait Until Keyword Succeeds    3 times    3s    Click Element    ${button_xoa_nv}
    Wait Until Page Contains Element    ${button_dongy_xoa_nv}     30s

Choose gioi tinh
    [Arguments]     ${input_gioitinh}
    ${checkbox_gioitinh}      Format String    ${checkbox_gioitinh}    ${input_gioitinh}
    Click Element    ${checkbox_gioitinh}

Input data in popup Them moi nhan vien
    [Arguments]     ${input_ma_nv}    ${input_ten_nv}     ${input_ngay_sinh}    ${input_gioitinh}   ${input_cmtnd}    ${input_phongban}     ${input_chucdanh}    ${input_ghichu}       ${input_sdt}      ${input_email}    ${input_facebook}      ${input_diachi}      ${input_khuvuc}     ${input_phuongxa}
    Run Keyword If    '${input_ma_nv}'!='none'   Input Text Global   ${textbox_ma_nhan_vien}   ${input_ma_nv}   ELSE    Log    Ignore
    Run Keyword If    '${input_ten_nv}'!='none'   Input Text Global   ${textbox_ten_nhan_vien}   ${input_ten_nv}   ELSE   Log   Ignore
    # Run Keyword If    '${input_ngay_sinh}'!='none'   Press Keys    ${textbox_ngay_sinh_nv}   CTRL+A
    Run Keyword If    '${input_ngay_sinh}'!='none'   Wait Until Keyword Succeeds    10x   3s   Input ngày sinh nhân viên   ${input_ngay_sinh}
    # Run Keyword If    '${input_ngay_sinh}'!='none'   Input Text   ${textbox_ngay_sinh_nv}   ${input_ngay_sinh}   ELSE   Log    Ignore
    Run Keyword If    '${input_gioitinh}'!='none'   Choose gioi tinh   ${input_gioitinh}   ELSE   Log   Ignore
    Run Keyword If    '${input_cmtnd}'!='none'   Input Text Global   ${textbox_cmtnd_nv}   ${input_cmtnd}   ELSE   Log   Ignore
    Run Keyword If    '${input_phongban}'!='none'   Select combobox any form and click element   ${cell_chonphongban}    ${item_phongban_chucdanh_in_dropdownlist}   ${input_phongban}   ELSE   Log   Ignore
    Run Keyword If    '${input_chucdanh}'!='none'   Select combobox any form and click element   ${cell_chonchucdanh}    ${item_phongban_chucdanh_in_dropdownlist}   ${input_chucdanh}   ELSE   Log   Ignore
    Run Keyword If    '${input_ghichu}'!='none'   Input Text Global   ${textbox_ghichu_nv}   ${input_ghichu}   ELSE   Log   Ignore
    Run Keyword If    '${input_sdt}'!='none'   Input Text Global   ${textbox_sdt_nv}   ${input_sdt}   ELSE   Log   Ignore
    Run Keyword If    '${input_email}'!='none'   Input Text Global   ${textbox_email_nv}   ${input_email}   ELSE   Log   Ignore
    Run Keyword If    '${input_facebook}'!='none'   Input Text Global   ${textbox_facebook_nv}    ${input_facebook}   ELSE   Log   Ignore
    Run Keyword If    '${input_diachi}'!='none'   Input Text Global   ${textbox_diachi_nv}   ${input_diachi}   ELSE   Log   Ignore
    Run Keyword If    '${input_khuvuc}'!='none'   Select dropdown anyform and click element js   ${textbox_khuvuc_nv}    ${item_kv_px_indropdownlist}   ${input_khuvuc}   ELSE   Log   Ignore
    Run Keyword If    '${input_phuongxa}'!='none'   Select dropdown anyform and click element js   ${textbox_phuongxa_nv}    ${item_kv_px_indropdownlist}   ${input_phuongxa}   ELSE   Log   Ignore

Input ngày sinh nhân viên
    [Arguments]   ${ngaysinh}
    Wait Until Element Is Not Visible    ${toast_message}
    Press Keys    ${textbox_ngay_sinh_nv}   ${ngaysinh}
    Click Element    ${textbox_cmtnd_nv}
    Page Should Not Contain Element    ${toast_message}
