*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}      ${headless_browser}
Test Setup        Before Test BC Nhan Vien
Test Teardown     After Test
Library           SeleniumLibrary
Library           Collections
Resource          ../../../config/env_product/envi.robot
Resource          ../../../core/API/api_hoadon_banhang.robot
Resource          ../../../core/Bao_cao/bc_list_page.robot
Resource          ../../../core/API/api_mhbh.robot
Resource          ../../../core/Bao_cao/bc_nhan_vien_list_action.robot

*** Variables ***
&{list_prs_num}    RPT0014=3.5
@{list_giamoi}    35000

*** Test Cases ***    Mã KH         List products and nums    List giá mới       GGHD              Mã Combo    Khách thanh toán
Hoa don - nv          [Tags]        CRP
                      [Template]    ebchh01
                      CRPKH014      an.nt      Nguyễn Thị An             ${list_prs_num}    ${list_giamoi}    0           none             100000

Hoa don - admin       [Tags]        CRP
                      [Template]    ebchh02
                      ${list_prs_num}      10000

*** Keywords ***
ebchh01
    [Arguments]    ${input_ma_kh}     ${ten_dn}    ${ten_nv}    ${dict_product_nums}    ${list_newprice}    ${input_gghd}    ${ma_hh_combo}
    ...    ${input_khtt}
    ${get_ma_hd}    Add new invoice incase newprice with multi prouduct - payment by user    ${input_ma_kh}    ${ten_dn}    ${dict_product_nums}    ${list_newprice}    ${input_gghd}
    ...    ${ma_hh_combo}    ${input_khtt}
    Sleep    5s
    Reload Page
    Search nguoi ban in BC nhan vien    ${ten_nv}
    Click Element    ${checkbox_bao_cao}
    Sleep    15
    Wait Until Page Contains Element    ${button_bc_expand}     20s
    Click Element    ${button_bc_expand}
    Click thoi gian in BC nhan vien
    Sleep    5s
    Wait Until Keyword Succeeds    3 times    10s    Element Should Contain    ${cell_du_lieu_bc}    ${get_ma_hd}
    Delete invoice by invoice code    ${get_ma_hd}

ebchh02
    [Arguments]     ${dict_product_nums}     ${input_khtt}
    ${get_ma_hd}    Add new invoice without customer thr API    ${dict_product_nums}   ${input_khtt}
    Sleep    5s
    Reload Page
    Sleep    5s
    Click Element    ${checkbox_bao_cao}
    Sleep    5s
    Search nguoi ban in BC nhan vien    admin
    Click Element    ${checkbox_bao_cao}
    Sleep    15
    Wait Until Page Contains Element    ${button_bc_expand}     20s
    Click Element    ${button_bc_expand}
    Click thoi gian in BC nhan vien
    Sleep    5s
    Wait Until Keyword Succeeds    3 times    10s    Element Should Contain    ${cell_du_lieu_bc}    ${get_ma_hd}
    Delete invoice by invoice code    ${get_ma_hd}
