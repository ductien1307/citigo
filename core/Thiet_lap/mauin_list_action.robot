*** Settings ***
Library           SeleniumLibrary
Library           StringFormat
Resource          mauin_list_page.robot
Resource          ../../share/constants.robot
Resource          ../../share/discount.robot

*** Keywords ***
Click edit print template and save
    Reload Page
    Wait Until Page Contains Element    ${button_chinhsua_mauin}    30s
    Click Element    ${button_chinhsua_mauin}
    Click Element    ${button_luu_mauin}
    Wait Until Page Contains Element    ${button_luu_mauin_co}   30s
    Click Element        ${button_luu_mauin_co}

Click add new print template and save
    Wait Until Page Contains Element    ${button_them_mauin}    30s
    Click Element    ${button_them_mauin}
    Wait Until Page Contains Element       ${button_luu_mauin}   30s
    Click Element    ${button_luu_mauin}
