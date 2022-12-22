*** Settings ***
Library           SeleniumLibrary
Library           StringFormat
Resource          sms_email_list_page.robot
Resource          ../../share/constants.robot
Resource          ../../share/discount.robot

*** Keywords ***
Add new SMS/ZMS
    [Arguments]     ${input_tieude}     ${input_noidung}
    Wait Until Page Contains Element    ${button_themmau}     30s
    Click Element    ${button_themmau}
    Wait Until Page Contains Element    ${button_sms_zms}     30s
    Click Element    ${button_sms_zms}
    Wait Until Page Contains Element    ${textbox_tieude}     30s
    Input Text    ${textbox_tieude}    ${input_tieude}
    Input Text    ${textbox_noidung}    ${input_noidung}
    Click Element    ${button_luu_mau}

Add new Email
    [Arguments]     ${input_tieude}     ${input_noidung}
    Wait Until Page Contains Element    ${button_themmau}     30s
    Click Element    ${button_themmau}
    Wait Until Page Contains Element    ${button_email}     30s
    Click Element    ${button_email}
    Wait Until Page Contains Element    ${textbox_tieude}     30s
    Input Text    ${textbox_tieude}    ${input_tieude}
    Input Text    ${textbox_noidung_email}    ${input_noidung}
    Click Element    ${button_luu_mau}

Access button update template Visible
    Element Should Be Visible    ${button_capnhat_mautin}     10s
    Click Element      ${button_capnhat_mautin}
    Wait Until Page Contains Element    ${textbox_tieude}     4s

Access button delete template Visible
    Element Should Be Visible    ${button_xoa_mautin}     10s
    Click Element      ${button_xoa_mautin}
    Wait Until Page Contains Element    ${button_dongy_xoa_mautin}     4s
