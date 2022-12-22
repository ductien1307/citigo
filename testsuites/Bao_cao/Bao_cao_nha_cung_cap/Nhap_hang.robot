*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}      ${headless_browser}
Test Setup        Before Test BC Nha Cung Cap
Test Teardown     After Test
Library           SeleniumLibrary
Library           Collections
Resource          ../../../config/env_product/envi.robot
Resource          ../../../core/API/api_phieu_nhap_hang.robot
Resource          ../../../core/Bao_cao/bc_list_page.robot
Resource          ../../../core/API/api_mhbh.robot
Resource          ../../../core/Bao_cao/bc_nha_cung_cap_list_action.robot

*** Variables ***
&{list_prs_num}    RPT0013=3.5
@{list_giamoi}    35000  

*** Test Cases ***    Mã NCC        List products and nums    List giá mới      GGHD    TIềnn trả NCC
Nhap hang             [Tags]        CRP
                      [Template]    ebchh01
                      RPNCC001      ${list_prs_num}           ${list_giamoi}    20      20000
                      RPNCC002      ${list_prs_num}           ${list_giamoi}    10      0

*** Keywords ***
ebchh01
    [Arguments]    ${input_ma_ncc}    ${dict_product_nums}    ${list_newprice}    ${input_ggpn}    ${input_cantrancc}
    ${get_ma_pn}    Add new purchase receipt thr API    ${input_ma_ncc}    ${dict_product_nums}    ${list_newprice}    ${input_ggpn}    ${input_cantrancc}
    Sleep    5s
    Reload Page
    Sleep    5s
    Click Element    ${checkbox_bao_cao}
    Sleep    5s
    Search supplier and click expand in BC nha cung cap    ${input_ma_ncc}
    Wait Until Keyword Succeeds    3 times    10s    Element Should Contain    ${cell_du_lieu_bc}    ${get_ma_pn}
    Delete purchase receipt code    ${get_ma_pn}
