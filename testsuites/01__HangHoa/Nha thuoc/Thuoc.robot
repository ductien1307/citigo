*** Settings ***
Suite Setup       Init Test Environment    NT    ${remote}    ${account}      ${headless_browser}
Test Setup        Before Test Hang Hoa
Test Teardown     After Test
Resource          ../../../core/hang_hoa/hang_hoa_add_action.robot
Resource          ../../../core/hang_hoa/hang_hoa_add_page.robot
Resource          ../../../core/share/toast_message.robot
Resource          ../../../config/env_product/envi.robot
Resource          ../../../core/hang_hoa/danh_muc_list_action.robot
Resource          ../../../prepare/Hang_hoa/Sources/hanghoa.robot
Resource          ../../../core/API/api_danhmuc_thuoc.robot

*** Variables ***

*** Test Cases ***    Mã hh          Tên                Nhóm         Giá vốn    Giá bán      Đương dùng
Them                  [Tags]        EPT        EBNT
                      [Template]    ept1
                      TAT0001      Thevapop            Thuốc nội        80000      60000        Nhỏ mắt

Sua                   [Tags]        EPT        EBNT
                      [Template]    ept2
                      TA0002       Thevapop            Thuốc nội        80000      60000        Uống        STAMICIS

Xoa                   [Tags]         EPT       EBNT
                      [Template]    ept3
                      TA0003       Thevapop            Thuốc nội        80000      60000        Uống

*** Keywords ***
ept1
    [Arguments]      ${ma_hh}    ${ten_thuoc}    ${nhom_hang}     ${giaban}    ${giavon}     ${duong_dung}
    ${get_pr_id}    Get product ID    ${ma_hh}
    Run Keyword If    '${get_pr_id}'=='0'    Log    Ignore pr    ELSE       Delete product thr API    ${ma_hh}
    Reload Page
    Go to Them Thuoc
    Input data in Them thuoc form    ${ma_hh}    ${ten_thuoc}    ${nhom_hang}   ${duong_dung}    ${giaban}    ${giavon}
    Click Element    ${button_luu}
    Wait Until Keyword Succeeds    3 times    3s    Medicine create success validation
    Wait Until Keyword Succeeds    3 times    3s    Assert data in case create medicine      ${ma_hh}    ${ten_thuoc}    ${nhom_hang}   0    ${giavon}    ${giaban}    ${duong_dung}
    Delete product thr API    ${ma_hh}
    Reload Page

ept2
    [Arguments]      ${ma_hh}    ${ten_thuoc}    ${nhom_hang}     ${giaban}    ${giavon}     ${duong_dung}      ${ten_thuoc_up}
    ${get_pr_id}    Get product ID    ${ma_hh}
    Run Keyword If    '${get_pr_id}'=='0'    Log    Ignore pr    ELSE       Delete product thr API    ${ma_hh}
    Add medicine thr API      ${ma_hh}    ${ten_thuoc}    ${nhom_hang}     ${giaban}    ${giavon}     ${duong_dung}
    Search product code and click update product    ${ma_hh}
    Wait Until Page Contains Element    ${button_xoa_ten_thuoc}   30s
    Click Element     ${button_xoa_ten_thuoc}
    Search ten thuoc     ${ten_thuoc_up}
    Click Element    ${button_luu}
    Update data success validation
    Wait Until Keyword Succeeds    3 times    3s    Assert data in case create medicine      ${ma_hh}    ${ten_thuoc_up}    ${nhom_hang}   0    ${giavon}    ${giaban}    ${duong_dung}
    Delete product thr API    ${ma_hh}
    Reload Page

ept3
    [Arguments]      ${ma_hh}    ${ten_thuoc}    ${nhom_hang}     ${giaban}    ${giavon}     ${duong_dung}
    ${get_pr_id}    Get product ID    ${ma_hh}
    Run Keyword If    '${get_pr_id}'=='0'    Log    Ignore pr    ELSE       Delete product thr API    ${ma_hh}
    Add medicine thr API      ${ma_hh}    ${ten_thuoc}    ${nhom_hang}     ${giaban}    ${giavon}     ${duong_dung}
    Search product code and delete product    ${ma_hh}
    Wait Until Keyword Succeeds    3 times    3s     Delete medicine success validation    ${ma_hh}
    Wait Until Keyword Succeeds    3 times    3s     Assert product is not available thr API    ${ma_hh}
    Reload Page
