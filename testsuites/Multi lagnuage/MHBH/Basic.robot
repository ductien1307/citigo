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
Resource          ../kw_multi_language.robot

*** Variables ***

*** Test Cases ***
MHBH
    [Tags]          IDM
    [Template]    Check multi MHBH
    nhanvien      Demo BH

Check gia moi in MHBH
    [Tags]        MLBH
    [Template]    Check multi MHBH
    nhanvien    KV check price in MHBH

Check popup tra hang in MHBH
    [Tags]        MLBH
    [Template]    Check multi MHBH
    nhanvien    KV check popup return

Check popup dat hang in MHBH
    [Tags]        MLBH
    [Template]    Check multi MHBH
    nhanvien    KV check popup order

Check popup print in MHBH
    [Tags]        MLBH
    [Template]    Check multi MHBH
    nhanvien    KV check popup print

Check popup sync data in MHBH
    [Tags]        MLBH
    [Template]    Check multi MHBH
    nhanvien    KV check popup sync data

*** Keywords ***
Demo BH
    [Arguments]    ${tai_khoan}     ${user_id}
    Maximize Browser Window
    Wait Until Keyword Succeeds    3 times    30 s    Login MHBH    ${tai_khoan}${user_id}    ${PASSWORD}

KV check price in MHBH
    [Arguments]    ${tai_khoan}     ${user_id}
    Maximize Browser Window
    Wait Until Keyword Succeeds    3 times    30 s    Login MHBH    ${tai_khoan}${user_id}    ${PASSWORD}
    Wait Until Keyword Succeeds    3 times    10 s    Input data in textbox and wait until it is visible      ${textbox_bh_search_ma_sp}     SP01    ${cell_sanpham}
    ...    ${cell_bh_ma_sp}
    Wait Until Page Contains Element    ${button_giamoi}    20s
    Click Element JS    ${button_giamoi}

KV check popup return
    [Arguments]    ${tai_khoan}     ${user_id}
    Maximize Browser Window
    Wait Until Keyword Succeeds    3 times    30 s    Login MHBH    ${tai_khoan}${user_id}    ${PASSWORD}
    Wait Until Page Contains Element    ${icon_select_th_hd}    1 min
    Click Element JS    ${icon_select_th_hd}

KV check popup order
    [Arguments]    ${tai_khoan}     ${user_id}
    Maximize Browser Window
    Wait Until Keyword Succeeds    3 times    30 s    Login MHBH    ${tai_khoan}${user_id}    ${PASSWORD}
    Wait Until Page Contains Element    ${button_menubar}    1 min
    Click Element JS    ${button_menubar}
    Wait Until Page Contains Element    ${cell_xuly_dathang}    1 min
    Click Element JS    ${cell_xuly_dathang}

KV check popup print
    [Arguments]    ${tai_khoan}     ${user_id}
    Maximize Browser Window
    Wait Until Keyword Succeeds    3 times    30 s    Login MHBH    ${tai_khoan}${user_id}    ${PASSWORD}
    Wait Until Page Contains Element    ${button_print}    30s
    Wait Until Page Contains Element    ${checkbox_delivery}    30s
    Click Element JS    ${checkbox_delivery}
    Click Element JS    ${button_print}

KV check popup sync data
    [Arguments]    ${tai_khoan}       ${user_id}
    Maximize Browser Window
    Wait Until Keyword Succeeds    3 times    30 s    Login MHBH    ${tai_khoan}${user_id}    ${PASSWORD}
    Wait Until Page Contains Element    ${button_dong_bo}    30s
    Click Element JS    ${button_dong_bo}
