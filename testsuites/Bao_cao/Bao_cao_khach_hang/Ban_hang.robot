*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}      ${headless_browser}
Test Setup        Before Test BC Khach Hang
Test Teardown     After Test
Library           SeleniumLibrary
Library           Collections
Resource          ../../../config/env_product/envi.robot
Resource          ../../../core/API/api_hoadon_banhang.robot
Resource          ../../../core/Bao_cao/bc_list_page.robot
Resource          ../../../core/API/api_mhbh.robot
Resource          ../../../core/Bao_cao/bc_khach_hang_list_action.robot

*** Variables ***
&{list_prs_num}    RPT0011=3.5
&{list_prs_num1}    RPT0012=7
&{list_create_imei}    RPSI0001=3
@{list_giamoi}    35000
@{list_giamoi1}    50000

*** Test Cases ***    Mã KH         List products and nums    List giá mới           GGHD               Mã Combo    Khách thanh toán
Hoa don               [Tags]        CRP
                      [Template]    ekh01
                      CRPKH011      ${list_prs_num}           ${list_giamoi}         20                 none     100000

Tra hang              [Tags]        CRP
                      [Template]    ekh02
                      CRPKH012      ${list_prs_num1}          ${list_create_imei}    ${list_giamoi1}    100000      15000               10    100000

*** Keywords ***
ekh01
    [Arguments]    ${input_ma_kh}    ${dict_product_nums}    ${list_newprice}    ${input_gghd}    ${ma_hh_combo}    ${input_khtt}
    ${get_ma_hd}    Add new invoice incase newprice with multi product - get invoice code    ${input_ma_kh}    ${dict_product_nums}    ${list_newprice}    ${input_gghd}    ${ma_hh_combo}
    ...    ${input_khtt}
    Sleep    5s
    Reload Page
    Sleep    5s
    Click Element    ${checkbox_bao_cao}
    Sleep    5s
    Search customer in BC khach hang    ${input_ma_kh}
    Wait Until Keyword Succeeds    3 times    10s    Element Should Contain    ${cell_du_lieu_bc}    ${input_ma_kh}
    Delete invoice by invoice code    ${get_ma_hd}

ekh02
    [Arguments]    ${input_ma_kh}    ${dict_product_nums}    ${list_imei}    ${list_newprice}    ${newprice_imei}    ${input_ggth}
    ...    ${input_phi_th}    ${input_khtt}
    ${get_ma_th}    Add new return thr API    ${input_ma_kh}    ${dict_product_nums}    ${list_imei}    ${list_newprice}    ${newprice_imei}
    ...    ${input_ggth}    ${input_phi_th}    ${input_khtt}
    Sleep    5s
    Reload Page
    Sleep    5s
    Click Element    ${checkbox_bao_cao}
    Sleep    5s
    Search customer in BC khach hang    ${input_ma_kh}
    Wait Until Keyword Succeeds    3 times    10s    Element Should Contain    ${cell_du_lieu_bc}    ${input_ma_kh}
    Delete return thr API    ${get_ma_th}
