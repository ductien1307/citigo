*** Settings ***
Resource          bc_ban_hang_list_page.robot
Library           DateTime
Library           StringFormat
Library           SeleniumLibrary

*** Keywords ***
Click thoi gian in BC ban hang
    ${date}    Get Current Date    result_format=%d/%m/%Y
    ${date}    Convert To String    ${date}
    ${locator_thoigian}    Format String    ${cell_bcbh_thoi_gian}    ${date}
    Wait Until Page Contains Element    ${locator_thoigian}   30s
    Wait Until Keyword Succeeds    3 times    1s    Click Element    ${locator_thoigian}
