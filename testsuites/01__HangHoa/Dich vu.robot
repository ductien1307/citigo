*** Settings ***
Suite Setup       Setup Test Suite    Before Test Hang Hoa
Suite Teardown     After Test
Resource          ../../core/hang_hoa/hang_hoa_add_action.robot
Resource          ../../core/hang_hoa/hang_hoa_add_page.robot
Resource          ../../core/share/toast_message.robot
Resource          ../../config/env_product/envi.robot
Resource          ../../prepare/Hang_hoa/Sources/hanghoa.robot
Resource          ../../core/hang_hoa/danh_muc_list_action.robot
Resource          ../../core/api/api_hanghoa.robot

*** Variables ***

*** Test Cases ***    Mã HH        Ten HH        Nhom Hang    Gia Ban     Gia Von    Ton Kho
Thêm mới              [Tags]        EP    EPT
                      [Template]    edv1
                      [Documentation]   Thêm mới hàng dịch vụ
                      EDVAT0001      GreenCross    Dịch vụ      80000.55    60000.5    2

Cập nhật              [Tags]        EP    EPT
                      [Template]    edv2
                      [Documentation]   Cập nhật hàng dịch vụ
                      EDVAT0002      GreenCross    Dịch vụ      70000.35    30000      DVAT0003      Gội đầu    Đồ ăn vặt    455555

Xóa                   [Tags]
                      [Template]    edv3
                      [Documentation]   Xóa hàng dịch vụ
                      EDVAT0004      Bàn           Dịch vụ      40000       30000

*** Keyword ***
edv1
    [Arguments]    ${ma_hh}     ${ten_hanghoa}    ${nhom_hang}    ${giaban}    ${giavon}    ${tonkho}
    Delete product if product is visible thr API      ${ma_hh}
    Reload Page
    Go to Them moi Dich vu
    Input data in Them dich vu form    ${ma_hh}    ${ten_hanghoa}    ${nhom_hang}    ${giaban}    ${giavon}
    Click Element    ${button_luu}
    Wait Until Page Contains Element        ${button_dongy_apdung_giavon}     20s
    Wait Until Keyword Succeeds    3 times    1s      Click Element   ${button_dongy_apdung_giavon}
    Product create success validation
    Wait Until Keyword Succeeds    3 times    3s    Assert data in case create product    ${ma_hh}    ${ten_hanghoa}    ${nhom_hang}
    ...    0    ${giavon}    ${giaban}
    Delete product thr API    ${ma_hh}

edv2
    [Arguments]     ${ma_hh}     ${ten_sp}    ${ten_nhom}    ${gia_ban}    ${gia_von}   ${mahh_up}    ${ten_hanghoa_up}    ${nhom_hang_up}
    ...    ${giaban_up}
    ${list_pr}      Create List    ${ma_hh}     ${mahh_up}
    Delete list product if list product is visible thr API    ${list_pr}
    Reload Page
    Add service    ${ma_hh}    ${ten_sp}    ${ten_nhom}    ${gia_ban}    ${gia_von}
    Search product code and click update product    ${ma_hh}
    Input data in Them hang hoa form without cost and onhand    ${mahh_up}    ${ten_hanghoa_up}    ${nhom_hang_up}    ${giaban_up}
    Click Element    ${button_luu}
    Update data success validation
    Wait Until Keyword Succeeds    3 times    3s    Assert data in case create product    ${mahh_up}    ${ten_hanghoa_up}    ${nhom_hang_up}    0    ${gia_von}    ${giaban_up}
    Delete product thr API    ${mahh_up}

edv3
    [Arguments]    ${ma_hh}   ${ten_sp}    ${ten_nhom}    ${gia_ban}    ${gia_von}
    Delete product if product is visible thr API    ${ma_hh}
    Reload Page
    Add service    ${ma_hh}    ${ten_sp}    ${ten_nhom}    ${gia_ban}    ${gia_von}
    Search product code and delete product    ${ma_hh}
    Delete product success validation    ${ma_hh}
    Wait Until Keyword Succeeds    3 times    3s    Assert product is not available thr API    ${ma_hh}
