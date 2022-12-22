*** Settings ***
Resource          bc_kenh_ban_hang_list_page.robot
Resource          bc_list_page.robot
Library           SeleniumLibrary
Library           String Format
Library           DateTime

*** Keywords ***
Search kenh ban hang in BC kenh ban hang
    [Arguments]    ${kenh_bh}
    Wait Until Page Contains Element    ${button_nckbh_chon_kenh_ban}     1 min
    Click Element    ${button_nckbh_chon_kenh_ban}
    Wait Until Element Is Visible    ${textbox_bckbh_kenh_ban}
    Input Text    ${textbox_bckbh_kenh_ban}    ${kenh_bh}
    Sleep    3s
    Wait Until Page Contains Element    ${item_kbh_indropdownlist}    1 min
    Click Element    ${item_kbh_indropdownlist}

Click thoi gian in BC kenh ban hang
    ${date}    Get Current Date    result_format=%d/%m/%Y
    ${date}    Convert To String    ${date}
    ${locator_thoigian}    Format String    ${cell_bckbh_thoi_gian}    ${date}
    Wait Until Keyword Succeeds    3 times    1s    Click Element    ${locator_thoigian}
