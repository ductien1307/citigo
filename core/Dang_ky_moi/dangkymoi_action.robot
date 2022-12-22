*** Settings ***
Library           SeleniumLibrary
Resource          dangkymoi_page.robot
Resource          ../share/constants.robot
Resource          ../share/javascript.robot
Resource          ../share/computation.robot
Resource          ../share/discount.robot
Library           Dialogs

*** Keywords ***
Select thanh pho
    [Arguments]    ${input_location}
    Click Element    ${cell_dky_thanh_pho}
    Wait Until Page Contains Element    ${textbox_dky_thanh_pho}    1 min
    Sleep    2s
    Input text        ${textbox_dky_thanh_pho}    ${input_location}
    ${xpath_dropdown_location}    Format String    ${item_thanhpho_in_dropdowlist}    ${input_location}
    Wait Until Element Is Enabled    ${xpath_dropdown_location}    1 min
    Click Element    ${xpath_dropdown_location}

Input informations in popup Tao tai khoan KiotViet
    [Arguments]    ${input_ho_ten}    ${input_sdt}    ${input_tencuahang}    ${input_ten_dangnhap}    ${input_matkhau}    ${input_thanhpho}
    ...    ${input_diachi}
    Wait Until Page Contains Element    ${textbox_dky_ho_ten}    1 min
    Input text    ${textbox_dky_ho_ten}    ${input_ho_ten}
    Input text    ${textbox_dky_dien_thoai}    ${input_sdt}
    Select thanh pho    ${input_thanhpho}
    Input text    ${textbox_dky_ten_cua_hang}    ${input_tencuahang}
    Input text    ${textbox_dky_ten_dang_nhap}    ${input_ten_dangnhap}
    Input text    ${textbox_dky_mat_khau}    ${input_matkhau}

Select nganh hang
    [Arguments]     ${input_nganh_hang}
    Wait Until Keyword Succeeds    3 times    3s    Click element     ${button_dky_dung_thu_mien_phi}
    ${button_nganh_hang}      Format String    ${button_nganh_hang}    ${input_nganh_hang}
    Wait Until Page Contains Element    ${button_nganh_hang}  30s
    Wait Until Keyword Succeeds    3 times   3s     Click element     ${button_nganh_hang}
