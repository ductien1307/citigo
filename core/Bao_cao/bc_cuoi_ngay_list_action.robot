*** Settings ***
Library           SeleniumLibrary
Library           String
Resource          bc_cuoi_ngay_list_page.robot
Resource          ../share/discount.robot
Resource          bc_list_page.robot

*** Keywords ***
Search customer and expand invoice in BC cuoi ngay
    [Arguments]    ${ma_kh}
    Wait Until Keyword Succeeds    3 times    1s      Search customer and wait element is visible in BC cuoi ngay   ${ma_kh}   ${button_bc_expand}
    Wait Until Keyword Succeeds    3 times    1s    Click Element    ${button_bc_expand}

Search customer and expand return in BC cuoi ngay
    [Arguments]    ${ma_kh}
    Wait Until Keyword Succeeds    3 times    1s     Search customer and wait element is visible in BC cuoi ngay    ${ma_kh}     ${button_bc_expand2}
    Wait Until Keyword Succeeds    3 times    1s    Click Element    ${button_bc_expand2}

Search customer and wait element is visible in BC cuoi ngay
    [Arguments]    ${ma_kh}     ${element}
    Element Should Be Visible    ${textbox_bccn_khachhang}    1 min
    Input data    ${textbox_bccn_khachhang}    ${ma_kh}
    Sleep    15s
    Wait Until Page Contains Element    ${element}    1 min

Validate Sales info by customer info
    [Arguments]    ${input_ma_hd}
    ${str_ma_hd}    Format String    ${ma_hd}    ${input_ma_hd}
    Wait Until Element Is Visible    ${icon_expanse}    5s
    Sleep    5s
    Click Element    ${icon_expanse}
    Wait Until Element Is Visible    ${str_ma_hd}

Validate Receipt/Payment info
    [Arguments]    ${input_ma_hd}    ${input_khtt}
    ${str_ma_hd}    Format String    ${ma_hd}    ${input_ma_hd}
    ${khtt}    Convert To String    ${input_khtt}
    ${khtt}    Replace String    ${khtt}    000    ,000
    ${str_kh_tt}    Format String    ${tt_khach_tt}    ${khtt}
    Wait Until Element Is Visible    ${str_ma_hd}    5s
    Wait Until Element Is Visible    ${str_kh_tt}    5s
