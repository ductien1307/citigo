*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}      ${headless_browser}
Test Setup        Before Test BC Kenh Ban Hang
Test Teardown     After Test
Library           SeleniumLibrary
Library           Collections
Resource          ../../../config/env_product/envi.robot
Resource          ../../../core/API/api_hoadon_banhang.robot
Resource          ../../../core/Bao_cao/bc_kenh_ban_hang_list_action.robot
Resource          ../../../core/Bao_cao/bc_list_page.robot

*** Variables ***
&{list_prs_num}    RPT0010=3.5
@{list_giamoi}    20000.5   

*** Test Cases ***    Mã KH         Kênh bh          List products and nums    List giá mới      GGHD    Khách thanh toán
Hoa don               [Tags]        CRP
                      [Template]    ekbh01
                      CRPKH010      Kênh 1           ${list_prs_num}           ${list_giamoi}    0       0
                      CRPKH010      Bán trực tiếp    ${list_prs_num}           ${list_giamoi}    0       100000

*** Keywords ***
ekbh01
    [Arguments]    ${input_ma_kh}    ${kenh_bh}    ${dict_product_nums}    ${list_newprice}    ${input_gghd}
    ...    ${input_khtt}
    ${get_ma_hd}    Add new invoice incase newprice with multi prouduct - payment - sale channel    ${input_ma_kh}    ${kenh_bh}    ${dict_product_nums}    ${list_newprice}    ${input_gghd}
    ...    ${input_khtt}
    Sleep    5s
    Reload Page
    Search kenh ban hang in BC kenh ban hang    ${kenh_bh}
    Click Element    ${checkbox_bao_cao}
    Sleep    15s
    Click Element    ${button_bc_expand}
    Sleep    7s
    Click thoi gian in BC kenh ban hang
    Sleep    5s
    Wait Until Keyword Succeeds    3 times    10s    Element Should Contain    ${cell_du_lieu_bc}    ${get_ma_hd}
    Delete invoice by invoice code    ${get_ma_hd}
