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

*** Test Cases ***    Mã SP             Ten HH             Nhom Hang        Gia Ban       Gia Von
Thêm mới              [Tags]            EP
                      [Template]        eim1
                      [Documentation]   Thêm mới hàng imei
                      SAT00001          GreenCross         Smartphone       50000         400000

Cập nhật              [Tags]            EP
                      [Template]        eim2
                      [Documentation]   Cập nhật hàng imei
                      SAT00002          GreenCross         20000             SAT00003     Smartphone    Bàn phím    Dịch vụ    455555

Xpá                   [Tags]
                      [Template]        eim3
                      [Documentation]   Xóa hàng imi
                      SAT00004          GreenCross          23233            Smartphone

*** Keyword ***
eim1
    [Arguments]    ${ma_hh}     ${ten_hanghoa}    ${nhom_hang}    ${giaban}    ${giavon}
    Delete product if product is visible thr API    ${ma_hh}
    Reload Page
    Go to Them moi Hang Hoa
    Create serial imei product    ${ma_hh}    ${ten_hanghoa}    ${nhom_hang}    ${giaban}    ${giavon}
    Click Element    ${button_luu}
    Wait Until Page Contains Element        ${button_dongy_apdung_giavon}     20s
    KV Click Element   ${button_dongy_apdung_giavon}
    Product create success validation
    Wait Until Keyword Succeeds    3 times    3s    Assert data in case create product    ${ma_hh}    ${ten_hanghoa}    ${nhom_hang}
    ...    0    ${giavon}    ${giaban}
    Delete product thr API    ${ma_hh}

eim2
    [Arguments]    ${ma_hh}   ${ten_hanghoa}    ${giaban}       ${mahh_up}    ${nhom_hang}    ${ten_hanghoa_up}    ${nhom_hang_up}    ${giaban_up}
    ${list_pr}      Create List    ${ma_hh}     ${mahh_up}
    Delete list product if list product is visible thr API    ${list_pr}
    Reload Page
    Add imei product thr API    ${ma_hh}    ${ten_hanghoa}    ${nhom_hang}    ${giaban}
    Search product code and click update product    ${ma_hh}
    Input data in Them hang hoa form without cost and onhand    ${mahh_up}    ${ten_hanghoa_up}    ${nhom_hang_up}    ${giaban_up}
    Click Element    ${button_luu}
    Update data success validation
    Wait Until Keyword Succeeds    3 times    3s    Assert data in case create product    ${mahh_up}    ${ten_hanghoa_up}    ${nhom_hang_up}
    ...    0    0    ${giaban_up}
    Delete product thr API    ${mahh_up}

eim3
    [Arguments]     ${ma_hh}   ${ten_hanghoa}    ${giaban}    ${nhom_hang}
    Delete product if product is visible thr API        ${ma_hh}
    Reload Page
    Wait Until Keyword Succeeds    3 times    3s    Go To Danh Muc Hang Hoa
    Add imei product thr API    ${ma_hh}    ${ten_hanghoa}    ${nhom_hang}    ${giaban}
    Search product code and delete product    ${ma_hh}
    Delete product success validation    ${ma_hh}
    Wait Until Keyword Succeeds    3 times    3s    Assert product is not available thr API    ${ma_hh}
