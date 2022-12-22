*** Settings ***
Library           SeleniumLibrary
Library           StringFormat

*** Variables ***
${pop_up}         xpath://div[contains(@class, 'k-window-poup') and contains(concat(' ',normalize-space(@style),' '),' display: block; ')]
${footer_button}    xpath://div[contains(@class, 'kv-window-footer')]//button[text()='{0}']

*** Keywords ***
Check Popup If Visible Then Close
    ${has_popup}=    Run Keyword And Return Status    Wait Until Element Is Visible    ${pop_up}    30s
    Run Keyword If    ${has_popup}    Click Popup Button    Bỏ qua

Click Popup Button
    [Arguments]    ${label}
    ${button}=    Format String    ${pop_up}    ${label}
    Click Element    ${button}
