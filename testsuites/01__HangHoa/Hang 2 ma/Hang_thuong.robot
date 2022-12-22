*** Settings ***
Suite Setup       Setup Test Suite    Before Test Hang Hoa
Suite Teardown    After Test
Resource          ../../../core/hang_hoa/hang_hoa_add_action.robot
Resource          ../../../core/hang_hoa/hang_hoa_add_page.robot
Resource          ../../../core/share/toast_message.robot
Resource          ../../../config/env_product/envi.robot
Resource          ../../../prepare/Hang_hoa/Sources/hanghoa.robot
Resource          ../../../core/hang_hoa/danh_muc_list_action.robot
Resource          ../../../core/api/api_hanghoa.robot

*** Variables ***

*** Test Cases ***    Ten HH            Mã vạch        Tên sp      Nhom Hang      Gia Ban     Gia Von    Ton Kho      Thương hiệu
Them moi              [Tags]        EP1
                      [Template]       epth1
                      [Documentation]   Thêm mới hàng thường có mã vạch
                      HTHAT0001       MVAT00001       GreenCross       Dịch vụ      80000.6     60000       2            Mac

Cap nhat              [Tags]        EP1
                      [Template]       epth2
                      [Documentation]   Cập nhật hàng thường có mã vạch
                      HTHAT0003     Hàng test        Kẹo bánh             60000.65    50000      13.5        MVAT00002        Hàng test update    Mỹ phẩm    90000    6      Lyn

*** Keyword ***
epth1
    [Arguments]      ${ma_hh}     ${ma_vach}     ${ten_hanghoa}    ${nhom_hang}    ${giaban}    ${giavon}    ${tonkho}      ${ten_thuong_hieu}
    Delete product if product is visible thr API    ${ma_hh}
    Reload Page
    Go to Them moi Hang Hoa
    Input data in Them hang hoa form    ${ma_hh}    ${ten_hanghoa}    ${nhom_hang}    ${giaban}    ${giavon}    ${tonkho}
    input data      ${textbox_mavach}     ${ma_vach}
    Select thuong hieu    ${ten_thuong_hieu}
    Click Element    ${button_luu}
    KV Click Element   ${button_dongy_apdung_giavon}
    Product create success validation
    Wait Until Keyword Succeeds    3 times    3s    Assert data in case create product have trade mark name   ${ma_hh}    ${ma_vach}    ${ten_hanghoa}    ${nhom_hang}
    ...    ${tonkho}    ${giavon}    ${giaban}    ${ten_thuong_hieu}
    Delete product thr API    ${ma_hh}

epth2
    [Arguments]    ${ma_hh}     ${ten_sp}    ${ten_nhom}    ${gia_ban}    ${gia_von}    ${ton}      ${ma_vach}    ${ten_hanghoa_up}
    ...    ${nhom_hang_up}    ${giaban_up}    ${tonkho_up}    ${ten_thuong_hieu}
    Delete product if product is visible thr API    ${ma_hh}
    Reload Page
    Add product thr API    ${ma_hh}    ${ten_sp}    ${ten_nhom}    ${gia_ban}    ${gia_von}    ${ton}
    Search product code and click update product    ${ma_hh}
    Input data in Them hang hoa form without cost    none    ${ten_hanghoa_up}    ${nhom_hang_up}    ${giaban_up}    ${tonkho_up}
    input data      ${textbox_mavach}     ${ma_vach}
    Select thuong hieu    ${ten_thuong_hieu}
    Click Element    ${button_luu}
    Update data success validation
    Wait Until Keyword Succeeds    3 times    3s    Assert data in case create product have trade mark name    ${ma_hh}   ${ma_vach}   ${ten_hanghoa_up}    ${nhom_hang_up}
    ...    ${tonkho_up}    ${gia_von}    ${giaban_up}   ${ten_thuong_hieu}
    Delete product thr API    ${ma_hh}
