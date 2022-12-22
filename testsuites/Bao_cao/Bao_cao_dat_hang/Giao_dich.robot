*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}      ${headless_browser}
Test Setup        Before Test BC Dat Hang
Test Teardown     After Test
Library           SeleniumLibrary
Library           Collections
Resource          ../../../config/env_product/envi.robot
Resource          ../../../core/API/api_mhbh_dathang.robot
Resource          ../../../core/Bao_cao/bc_dat_hang_list_action.robot
Resource          ../../../core/Bao_cao/bc_list_page.robot

*** Variables ***
&{list_prs_num}    RPT0006=5
&{list_prs_num1}    RPT0007=3

*** Test Cases ***    Mã KH         List products and nums    Khách thanh toán
Dat hang              [Tags]        CRP
                      [Template]    edh01
                      ${list_prs_num}           50000
                      ${list_prs_num1}          0

*** Keywords ***
edh01
    [Arguments]      ${dict_product_nums}    ${input_khtt}
    ${get_ma_dh}     Add new order with multi products no customer    ${dict_product_nums}   ${input_khtt}
    Sleep    5s
    Reload Page
    Sleep    5s
    Click Element    ${checkbox_bao_cao}
    Sleep    5s
    Click Element    ${checkbox_bcdh_giao_dich}
    Sleep    15s
    Wait Until Keyword Succeeds    3 times    10s    Element Should Contain    ${cell_du_lieu_bc}    ${get_ma_dh}
    Delete order frm Order code    ${get_ma_dh}
