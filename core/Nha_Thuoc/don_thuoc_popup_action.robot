*** Settings ***
Library           SeleniumLibrary
Library           StringFormat
Resource          giao_hang_popup_page.robot
Resource          ../share/computation.robot
Resource          ../share/constants.robot
Resource          ../share/javascript.robot
Resource          ../share/discount.robot
Resource          don_thuoc_popup_page.robot

*** Keywords ***
Click Ban thuoc theo don and open popup
    Sleep    2s
    Wait Until Page Contains Element   ${checkbox_banthuoc_theodon}     30s
    Click Element JS        ${checkbox_banthuoc_theodon}
    Click Element JS    ${link_banthuoc_theodon}

Input data in popup Ban thuoc theo don
    [Arguments]       ${input_madonthuoc}      ${input_bskd}    ${input_cskb}     ${input_tenbn}      ${input_tuoibn}     ${input_gioitinh}     ${input_cannang}      ${input_cmt}      ${input_the_bhyt}     ${input_diachi}    ${input_nguoigiamho}    ${input_sdt}     ${input_chandoan}
    Wait Until Page Contains Element    ${textbox_ma_don_thuoc}     30s
    Input Text      ${textbox_ma_don_thuoc}     ${input_madonthuoc}
    Click Element JS    ${cell_bs_kedon}
    ${item_Bs}      Format String    ${item_bs_indropdown}    ${input_bskd}
    Wait Until Page Contains Element    ${item_Bs}     30s
    Click Element JS    ${item_Bs}
    Click Element JS   ${cell_cskb}
    ${item_cskb}      Format String    ${item_bs_indropdown}    ${input_cskb}
    Wait Until Page Contains Element    ${item_cskb}     30s
    Click Element JS    ${item_cskb}
    Input Text    ${textbox_ten_bn}     ${input_tenbn}
    Input Text    ${textbox_tuoi_bn}     ${input_tuoibn}
    ${ckb_gioitinh}      Format String    ${checkbox_gioitinh_bn}    ${input_gioitinh}
    Click Element JS    ${ckb_gioitinh}
    Input Text    ${textbox_cannang_bn}     ${input_cannang}
    Input Text    ${textbox_nhap_cmt}     ${input_cmt}
    Input Text    ${textbox_the_bhyt}     ${input_the_bhyt}
    Input Text    ${textbox_diachi_bn}     ${input_diachi}
    Input Text    ${textbox_nguoi_giamho}     ${input_nguoigiamho}
    Input Text    ${textbox_dienthoai_bn}     ${input_sdt}
    Input Text    ${textbox_chandoan}     ${input_chandoan}
    Click Element JS     ${button_donthuoc_xong}
