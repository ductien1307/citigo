*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}      ${headless_browser}
Test Setup        Before Test BC Cuoi Ngay
Test Teardown     After Test
Library           SeleniumLibrary
Library           Collections
Resource          ../../../config/env_product/envi.robot
Resource          ../../../core/Bao_cao/bc_cuoi_ngay_list_action.robot
Resource          ../../../core/API/api_hoadon_banhang.robot
Resource          ../../../core/API/api_mhbh_dathang.robot
Resource          ../../../core/API/api_trahang.robot
Resource          ../../../core/Bao_cao/bc_list_page.robot

*** Variables ***
&{list_prs_num}    RPT0003=5
&{list_prs_num1}    RPT0004=7
&{list_prs_num2}    RPT0005=4
&{list_create_imei}    RPSI0005=2
@{list_giamoi}    35000
@{list_giamoi1}    50000

*** Test Cases ***    Mã KH   List products and nums   List giá mới   GGHD   Mã Combo   Khách thanh toán
Hoa don               [Tags]              CRP   GOLIVE2   CTP
                      [Template]          ecn01
                      [Documentation]     MHQL - CHECK HIỂN THỊ BÁO CÁO CUỐI NGÀY THEO HÓA ĐƠN
                      CRPKH003   ${list_prs_num}   ${list_giamoi}   20000   none   100000

Dat hang              [Tags]        CRP
                      [Template]    ecn02
                      CRPKH004      ${list_prs_num1}          50000

Tra hang              [Tags]        CRP
                      [Template]    ecn03
                      CRPKH005      ${list_prs_num2}          ${list_create_imei}    ${list_giamoi1}    100000      15000               10    100000

*** Keywords ***
ecn01
    [Arguments]    ${input_ma_kh}    ${dict_product_nums}    ${list_newprice}    ${input_gghd}    ${ma_hh_combo}    ${input_khtt}
    ${get_ma_hd}    Add new invoice incase newprice with multi product - get invoice code    ${input_ma_kh}    ${dict_product_nums}    ${list_newprice}    ${input_gghd}    ${ma_hh_combo}
    ...    ${input_khtt}
    Sleep    10s
    Reload Page
    Sleep    10s
    Search customer and expand invoice in BC cuoi ngay    ${input_ma_kh}
    Sleep    15s
    Wait Until Keyword Succeeds    3 times    10s    Element Should Contain    ${cell_du_lieu_bc}    ${get_ma_hd}
    Delete invoice by invoice code    ${get_ma_hd}

ecn02
    [Arguments]    ${input_ma_kh}    ${dict_product_nums}    ${input_khtt}
    ${get_ma_hd}    Add new order with multi products    ${input_ma_kh}    ${dict_product_nums}    ${input_khtt}
    Sleep    10s
    Reload Page
    Sleep    10s
    Search customer and expand invoice in BC cuoi ngay    ${input_ma_kh}
    Sleep    15s
    Wait Until Keyword Succeeds    3 times    10s    Element Should Contain    ${cell_du_lieu_bc}    ${get_ma_hd}
    Delete order frm Order code    ${get_ma_hd}

ecn03
    [Arguments]    ${input_ma_kh}    ${dict_product_nums}    ${list_imei}    ${list_newprice}    ${newprice_imei}    ${input_ggth}
    ...    ${input_phi_th}    ${input_khtt}
    ${get_ma_th}    Add new return thr API    ${input_ma_kh}    ${dict_product_nums}    ${list_imei}    ${list_newprice}    ${newprice_imei}
    ...    ${input_ggth}    ${input_phi_th}    ${input_khtt}
    Sleep    10s
    Reload Page
    Sleep    10s
    Search customer and expand return in BC cuoi ngay    ${input_ma_kh}
    Sleep    15s
    Wait Until Keyword Succeeds    3 times    10s    Element Should Contain    ${cell_du_lieu_bc}    ${get_ma_th}
    Delete return thr API    ${get_ma_th}
