*** Settings ***
Library           SeleniumLibrary
Library           StringFormat
Library           String
Resource          ../share/computation.robot
Resource          ../share/javascript.robot
Resource          xuat_huy_list_page.robot
Resource          ../API/api_xuathuy.robot

*** Keywords ***
Search damage code and click open
    [Arguments]    ${ma_phieu}
    Wait Until Page Contains Element    ${textbox_search_ma_xh}    30s
    Input data    ${textbox_search_ma_xh}    ${ma_phieu}
    Press Key    ${textbox_search_ma_xh}    ${ENTER_KEY}
    Sleep    5s
    Wait Until Page Contains Element    ${button_xh_mophieu}    20s
    Click Element JS    ${button_xh_mophieu}
    Sleep    5s

Search damage code
    [Arguments]    ${ma_phieu}
    Wait Until Page Contains Element    ${textbox_search_ma_xh}    30s
    Input data    ${textbox_search_ma_xh}    ${ma_phieu}
