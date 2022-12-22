*** Settings ***
Suite Setup       Setup Test Suite    Before Test Hang Hoa
Suite Teardown    After Test
Resource          ../../core/hang_hoa/hang_hoa_add_action.robot
Resource          ../../core/hang_hoa/hang_hoa_add_page.robot
Resource          ../../core/share/toast_message.robot
Resource          ../../config/env_product/envi.robot
Resource          ../../prepare/Hang_hoa/Sources/hanghoa.robot
Resource          ../../core/hang_hoa/danh_muc_list_action.robot
Resource          ../../core/api/api_hanghoa.robot

*** Variables ***
@{list_vt}        Vị trí 1    Vị trí 2

*** Test Cases ***    Ten HH           Nhom Hang                          Gia Ban     Gia Von    Ton Kho
Thêm mới + Tạo mới NH
                      [Tags]          EP     EPT
                      [Template]      ehh2
                      [Documentation]   TThêm mới hàng thường + Tạo mới nhóm hàng ở form Thêm mới
                      HTAT0001      Handmade cake       GRAT001    4000                2000        3

Thêm mới              [Tags]          EP
                      [Template]      ehh1
                      [Documentation]   Thêm mới hàng thường
                      HTAT0002       GreenCross       Dịch vụ            80000.6     60000      2          ${list_vt}

Xóa                   [Tags]           GOLIVE2        EP
                      [Template]       ehh3
                      [Documentation]    Xóa hàng thường
                      HTAT0003        Hàng test        Đồ ăn vặt                         50000       30000      3.5

Cap nhat              [Tags]           GOLIVE2        EP
                      [Template]       ehh4
                      [Documentation]   Cập nhật hàng thường
                      HTAT0004     Hàng test        Kẹo bánh             60000.65    50000      6      HTAT0005      Hàng test update    Mỹ phẩm    90000    14.68

*** Keyword ***
ehh1
    [Arguments]      ${ma_hh}    ${ten_hanghoa}    ${nhom_hang}    ${giaban}    ${giavon}    ${tonkho}    ${vitri}
    Delete product if product is visible thr API       ${ma_hh}
    Reload Page
    Go to Them moi Hang Hoa
    Input data in Them hang hoa form    ${ma_hh}    ${ten_hanghoa}    ${nhom_hang}    ${giaban}    ${giavon}    ${tonkho}
    Select shelve    ${vitri}
    Click Element    ${button_luu}
    Wait Until Page Contains Element        ${button_dongy_apdung_giavon}     20s
    Wait Until Keyword Succeeds    3 times    1s      Click Element   ${button_dongy_apdung_giavon}
    Product create success validation
    Wait Until Keyword Succeeds    3 times    3s    Assert data in case create product    ${ma_hh}    ${ten_hanghoa}    ${nhom_hang}
    ...    ${tonkho}    ${giavon}    ${giaban}
    Delete product thr API    ${ma_hh}

ehh2
    [Arguments]    ${ma_hh}     ${ten_hanghoa}    ${nhom_hang}    ${giaban}    ${giavon}    ${tonkho}
    Delete product if product is visible thr API    ${ma_hh}
    Delete category if category is exist thr API    ${nhom_hang}
    Reload Page
    Go to Them moi Hang Hoa
    Create products with new group    ${ma_hh}    ${ten_hanghoa}    ${nhom_hang}    ${giaban}    ${giavon}    ${tonkho}
    Update data success validation
    Click Element    ${button_luu}
    KV Click Element   ${button_dongy_apdung_giavon}
    Product create success validation
    Wait Until Keyword Succeeds    3 times    3s    Assert data in case create product    ${ma_hh}    ${ten_hanghoa}    ${nhom_hang}
    ...    ${tonkho}    ${giavon}    ${giaban}
    Delete product thr API    ${ma_hh}
    Delete category thr API    ${nhom_hang}

ehh3
    [Arguments]     ${ma_hh}    ${ten_sp}    ${ten_nhom}    ${gia_ban}    ${gia_von}    ${ton}
    Delete product if product is visible thr API    ${ma_hh}
    Reload Page
    Add product thr API    ${ma_hh}    ${ten_sp}    ${ten_nhom}    ${gia_ban}    ${gia_von}    ${ton}
    Search product code and delete product    ${ma_hh}
    Delete product success validation    ${ma_hh}
    Wait Until Keyword Succeeds    3 times    3s    Assert product is not available thr API    ${ma_hh}

ehh4
    [Arguments]    ${ma_hh}     ${ten_sp}    ${ten_nhom}    ${gia_ban}    ${gia_von}    ${ton}    ${mahh_up}    ${ten_hanghoa_up}
    ...    ${nhom_hang_up}    ${giaban_up}    ${tonkho_up}
    Delete product if product is visible thr API   ${ma_hh}
    Reload Page
    Add product thr API    ${ma_hh}    ${ten_sp}    ${ten_nhom}    ${gia_ban}    ${gia_von}    ${ton}
    Search product code and click update product    ${ma_hh}
    Input data in Them hang hoa form without cost    none    ${ten_hanghoa_up}    ${nhom_hang_up}    ${giaban_up}    ${tonkho_up}
    Click Element    ${button_luu}
    Update data success validation
    Wait Until Keyword Succeeds    3 times    3s    Assert data in case create product    ${ma_hh}    ${ten_hanghoa_up}    ${nhom_hang_up}
    ...    ${tonkho_up}    ${gia_von}    ${giaban_up}
    Delete product thr API    ${ma_hh}
