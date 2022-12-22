*** Settings ***
Resource          bc_list_page.robot
Resource          bc_hang_hoa_list_page.robot
Library           SeleniumLibrary
Library           String Format
Resource          ../share/discount.robot

*** Keywords ***
Search product in BC hang hoa
    [Arguments]    ${prd}
    Input Text    ${textbox_bchh_hanghoa}    ${prd}
    Press Key    ${textbox_bchh_hanghoa}    ${ENTER_KEY}
    Sleep    7s

Go to product report filter month
    Wait Until Element Is Visible    ${label_filter_thoigian}   2 mins
    Click Element    ${label_filter_thoigian}
    Wait Until Element Is Visible    ${link_filter_thangnay}   2 mins
    Click Element    ${link_filter_thangnay}
    Sleep    2s
    Wait Until Page Contains Element    ${label_soluong_mathang}
