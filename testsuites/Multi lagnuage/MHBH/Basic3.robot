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
Check popup xem BC cuoi ngay KH in MHBH
    [Tags]        MLBH
    [Template]    Check multi MHBH
    nhanvien    KV check popup xem BC cuoi ngay in MHBH

Check popup lap phieu thu in MHBH
    [Tags]        MLBH
    [Template]    Check multi MHBH
    nhanvien    KV check popup lap phieu thu in MHBH

Check popup phat hanh voucher in MHBH
    [Tags]        MLBH
    [Template]    Check multi MHBH
    nhanvien    KV check popup phat hanh voucher in MHBH

Check popup tuy chon hien thi in MHBH
    [Tags]        MLBH
    [Template]    Check multi MHBH
    nhanvien    KV check popup tuy chon hien thi in MHBH

Check tab sua chua in MHBH
    [Tags]        MLBH
    [Template]    Check multi MHBH
    nhanvien    KV check tab sua chua in MHBH

*** Keywords ***
KV check popup xem BC cuoi ngay in MHBH
    [Arguments]    ${tai_khoan}     ${user_id}
    Maximize Browser Window
    Wait Until Keyword Succeeds    3 times    30 s    Login MHBH    ${tai_khoan}${user_id}    ${PASSWORD}
    Wait Until Page Contains Element    ${button_menubar}    1 mins
    Click Element JS    ${button_menubar}
    Wait Until Page Contains Element    ${cell_xem_bc_cuoingay}    1 mins
    Click Element JS    ${cell_xem_bc_cuoingay}

KV check popup lap phieu thu in MHBH
    [Arguments]    ${tai_khoan}     ${user_id}
    Maximize Browser Window
    Wait Until Keyword Succeeds    3 times    30 s    Login MHBH    ${tai_khoan}${user_id}    ${PASSWORD}
    Wait Until Page Contains Element    ${button_menubar}    1 mins
    Click Element JS    ${button_menubar}
    Wait Until Page Contains Element    ${cell_lapphieuthu}    1 mins
    Click Element JS    ${cell_lapphieuthu}

KV check popup phat hanh voucher in MHBH
    [Arguments]    ${tai_khoan}     ${user_id}
    Maximize Browser Window
    Wait Until Keyword Succeeds    3 times    30 s    Login MHBH    ${tai_khoan}${user_id}    ${PASSWORD}
    Wait Until Page Contains Element    ${button_menubar}    1 mins
    Click Element JS    ${button_menubar}
    Wait Until Page Contains Element    ${item_menu_release_voucher}    1 mins
    Click Element JS    ${item_menu_release_voucher}

KV check popup tuy chon hien thi in MHBH
    [Arguments]    ${tai_khoan}     ${user_id}
    Maximize Browser Window
    Wait Until Keyword Succeeds    3 times    30 s    Login MHBH    ${tai_khoan}${user_id}    ${PASSWORD}
    Wait Until Page Contains Element    ${button_menubar}    1 mins
    Click Element JS    ${button_menubar}
    Wait Until Page Contains Element    ${cell_tuychon_hienthi}    1 mins
    Click Element JS    ${cell_tuychon_hienthi}

KV check tab sua chua in MHBH
    [Arguments]    ${tai_khoan}     ${user_id}
    Maximize Browser Window
    Wait Until Keyword Succeeds    3 times    30 s    Login MHBH    ${tai_khoan}${user_id}    ${PASSWORD}
    Wait Until Page Contains Element    ${tab_suachua}    1 mins
    Click Element     ${tab_suachua}
    Wait Until Keyword Succeeds    3 times    10 s    Input data in textbox and wait until it is visible      ${textbox_bh_search_ma_sp}     SP01    ${cell_sanpham}
    ...    //div[@class='warranty-product-info']
