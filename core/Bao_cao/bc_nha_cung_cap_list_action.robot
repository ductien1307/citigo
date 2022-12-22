*** Settings ***
Resource          bc_nha_cung_cap_list_page.robot
Library           SeleniumLibrary
Library           BuiltIn
Library           String Format
Resource          bc_list_page.robot
Resource          ../share/discount.robot

*** Keywords ***
Search supplier in BC nha cung cap
    [Arguments]    ${ma_ncc}
    Wait Until Page Contains Element    ${textbox_bcncc_tk_ncc}    2 min
    Input data    ${textbox_bcncc_tk_ncc}    ${ma_ncc}
    Sleep    7s

Search supplier and click expand in BC nha cung cap
    [Arguments]    ${input_ncc}
    Search supplier in BC nha cung cap    ${input_ncc}
    Wait Until Page Contains Element    ${button_bc_expand}    2 mins
    Wait Until Keyword Succeeds    3 times    1s    Click Element    ${button_bc_expand}
