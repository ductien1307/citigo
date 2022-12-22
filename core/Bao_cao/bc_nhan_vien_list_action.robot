*** Settings ***
Resource          bc_nhan_vien_list_page.robot
Resource          bc_list_page.robot
Library           SeleniumLibrary
Library           String Format
Library           BuiltIn
Library           DateTime

*** Keywords ***
Search nguoi ban in BC nhan vien
    [Arguments]    ${ten_nv}
    ${item_nguoiban}    Format String    ${item_nguoiban_indropdownlist}    ${ten_nv}
    Wait Until Keyword Succeeds    3 times    15s    Input nguoi ban in BC nhan vien    ${ten_nv}
    Wait Until Keyword Succeeds    3 times    1s    Click Element    ${item_nguoiban}

Input nguoi ban in BC nhan vien
    [Arguments]    ${ten_nv}
    Wait Until Page Contains Element    ${textbox_bnvn_chon_nguoi_ban}
    ${item_nguoiban}    Format String    ${item_nguoiban_indropdownlist}    ${ten_nv}
    Input Text    ${textbox_bnvn_chon_nguoi_ban}    ${ten_nv}
    Element Should Be Visible    ${item_nguoiban}    1 min

Click thoi gian in BC nhan vien
    ${date}    Get Current Date    result_format=%d/%m/%Y
    ${date}    Convert To String    ${date}
    ${locator_thoigian}    Format String    ${cell_bcnv_thoigian}    ${date}
    Wait Until Page Does Not Contain    ${locator_thoigian}       30s
    Wait Until Keyword Succeeds    3 times    1s    Click Element    ${locator_thoigian}
