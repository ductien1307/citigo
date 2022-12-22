*** Settings ***
Library           SeleniumLibrary
Library           StringFormat
Resource          sanxuat_list_page.robot

*** Keywords ***
Go to select export file manufacturing
    [Arguments]   ${button_export}
    Wait Until Page Contains Element    ${button_xuatfile_phieu_sx}    1 mins
    Click Element     ${button_xuatfile_phieu_sx}
    Wait Until Page Contains Element    ${button_export}    1 mins
    Click Element    ${button_export}

Go to Tao phieu san xuat
    KV Click Element       ${button_taophieu_sx}

Search Ma san xuat and lick update
    [Arguments]     ${input_ma_phieu}
    Input data      ${textbox_search_ma_sx}    ${input_ma_phieu}
    KV Click Element       ${button_capnhat_phieu_sx}
