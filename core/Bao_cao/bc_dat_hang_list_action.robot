*** Settings ***
Library           SeleniumLibrary
Resource          bc_dat_hang_list_page.robot

*** Keywords ***

Select report with transaction
    Wait Until Element Is Visible    ${radio_button_baocao}
    Click Element    ${radio_button_baocao}
    Wait Until Element Is Visible    ${radio_button_giaodich}
    Click Element    ${radio_button_giaodich}

Validate transaction table
    [Arguments]    ${input_ma_dh}
    [Documentation]    kieu hien thi: bao cao + giao dich
    ${str_ma_hd}    Format String    ${ma_dh}    ${input_ma_dh}
    Wait Until Page Contains Element    ${str_ma_hd}    5s

Validate product table
    [Arguments]    ${input_ma_dh}
    [Documentation]    kieu hien thi: bao cao + hang hoa
    ${str_ma_hd}    Format String    ${ma_dh}    ${input_ma_dh}
    Wait Until Element Is Visible    ${radio_button_hang_hoa}    5s
    Click Element    ${radio_button_hang_hoa}
    Sleep    5s
    Wait Until Page Contains Element    ${icon_expanse}    30s
    Click Element    ${icon_expanse}
    Wait Until Element Is Visible    ${str_ma_hd}
