*** Settings ***
Documentation     A resource file with reusable keywords and variables.
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    ${headless_browser}
Test Teardown     After Test
Library           String
Library           SeleniumLibrary
Library           Collections
Library           OperatingSystem
Resource          ../../../config/env_product/envi.robot
Resource          ../../../core/hang_hoa/hang_hoa_add_action.robot
Resource          ../../../core/hang_hoa/danh_muc_list_action.robot
Resource          ../../../core/Share/discount.robot
Resource          ../../../core/Tra hang/tra_hang_action.robot
Resource          ../../../core/Dat hang/dat_hang_action.robot
Resource          ../../../core/Giao_Van/giao_hang_popup_action.robot
Resource          ../kw_multi_language.robot

*** Variables ***

*** Test Cases ***
Check popup them moi KH in MHBH
    [Tags]        MLBH
    [Template]    Check multi MHBH
    nhanvien    KV check popup them moi KH in MHBH

Check popup giao hang in MHBH
    [Tags]        MLBH
    [Template]    Check multi MHBH
    nhanvien    KV check popup giao hang in MHBH

Check popup thu khac in MHBH
    [Tags]        MLBH
    [Template]    Check multi MHBH
    nhanvien    KV check popup surchage in MHBH

Check popup KMHD in MHBH
    [Tags]        MLBH
    [Template]    Check multi MHBH
    nhanvien    KV check popup KMHD in MHBH

Check popup thu KMHH in MHBH
    [Tags]        MLBH
    [Template]    Check multi MHBH
    nhanvien    KV check popup KMHH in MHBH


*** Keywords ***
KV check popup them moi KH in MHBH
    [Arguments]    ${tai_khoan}     ${user_id}
    Maximize Browser Window
    Wait Until Keyword Succeeds    3 times    30 s    Login MHBH    ${tai_khoan}${user_id}    ${PASSWORD}
    Wait Until Page Contains Element    ${button_them_kh}     30s
    Click Element    ${button_them_kh}

KV check popup giao hang in MHBH
    [Arguments]    ${tai_khoan}     ${user_id}
    Maximize Browser Window
    Wait Until Keyword Succeeds    3 times    30 s    Login MHBH    ${tai_khoan}${user_id}    ${PASSWORD}
    Wait Until Page Contains Element    ${checkbox_delivery}    2 mins
    Click Element JS    ${checkbox_delivery}
    Open Giao Hang popup
    Wait Until Page Contains Element    ${button_them_dtgh}     30s
    Click Element    ${button_them_dtgh}

KV check popup surchage in MHBH
    [Arguments]    ${tai_khoan}     ${user_id}
    Maximize Browser Window
    Wait Until Keyword Succeeds    3 times    30 s    Login MHBH    ${tai_khoan}${user_id}    ${PASSWORD}
    Wait Until Element Is Enabled     ${cell_surcharge_value}
    Press Key     ${cell_surcharge_value}    ${ENTER_KEY}

KV check popup KMHD in MHBH
    [Arguments]    ${tai_khoan}     ${user_id}
    Maximize Browser Window
    Wait Until Keyword Succeeds    3 times    30 s    Login MHBH    ${tai_khoan}${user_id}    ${PASSWORD}
    Wait Until Keyword Succeeds    3 times    10 s    Input data in textbox and wait until it is visible      ${textbox_bh_search_ma_sp}     SP01    ${cell_sanpham}
    ...    ${cell_bh_ma_sp}
    Wait Until Element Is Visible    ${button_promo}
    Click Element JS    ${button_promo}

KV check popup KMHH in MHBH
    [Arguments]    ${tai_khoan}     ${user_id}
    Maximize Browser Window
    Wait Until Keyword Succeeds    3 times    30 s    Login MHBH    ${tai_khoan}${user_id}    ${PASSWORD}
    Wait Until Keyword Succeeds    3 times    10 s    Input data in textbox and wait until it is visible      ${textbox_bh_search_ma_sp}     SP01    ${cell_sanpham}
    ...    ${cell_bh_ma_sp}
    Wait Until Element Is Visible    //h4[@class='has-promotion-icon']//i[@class='fa fa-gift']
    Click Element JS    //h4[@class='has-promotion-icon']//i[@class='fa fa-gift']
