*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}      ${headless_browser}
Test Setup        Before Test BC Ban Hang
Test Teardown     After Test
Library           SeleniumLibrary
Library           Collections
Resource          ../../../config/env_product/envi.robot
Resource          ../../../core/API/api_hoadon_banhang.robot    # \
Resource          ../../../core/Bao_cao/bc_ban_hang_list_action.robot
Resource          ../../../core/Bao_cao/bc_list_page.robot

*** Variables ***
&{list_prs_num}    RPT0001=5
&{list_prs_num1}    RPT0002=5.3

*** Test Cases ***    Mã KH         List products and nums    List giá mới           GGHD               Mã Combo    Khách thanh toán
Hoa don               [Tags]        CRP
                      [Template]    ebhln01
                      ${list_prs_num}         100000

Tra hang              [Tags]        CRP
                      [Template]    ebhln02
                      ${list_prs_num1}       20000

*** Keywords ***
ebhln01
    [Arguments]      ${dict_product_nums}     ${input_khtt}
    ${get_ma_hd}    Add new invoice without customer thr API    ${dict_product_nums}   ${input_khtt}
    Sleep    5s
    Reload Page
    Sleep    5s
    Click Element    ${checkbox_bao_cao}
    Sleep    5s
    Click Element    ${checkbox_bcbh_loinhuan}
    Sleep    15s
    Click thoi gian in BC ban hang
    Sleep    15s
    Wait Until Keyword Succeeds    3 times    10s    Element Should Contain    ${cell_du_lieu_bc}    ${get_ma_hd}
    Delete invoice by invoice code    ${get_ma_hd}

ebhln02
    [Arguments]      ${dict_product_nums}      ${input_khtt}
    ${get_ma_th}   Add new return without customer and imei frm API    ${dict_product_nums}   ${input_khtt}
    Sleep    5s
    Reload Page
    Sleep    5s
    Click Element    ${checkbox_bao_cao}
    Sleep    5s
    Click Element    ${checkbox_bcbh_loinhuan}
    Sleep    15s
    Click thoi gian in BC ban hang
    Sleep    15s
    Wait Until Keyword Succeeds    3 times    10s    Element Should Contain    ${cell_du_lieu_bc}    ${get_ma_th}
    Delete return thr API    ${get_ma_th}
