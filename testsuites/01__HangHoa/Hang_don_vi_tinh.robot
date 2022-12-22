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
@{list_tt_1}      xanh    đỏ    tím
@{list_tt_2}      m    l
@{prd}            NHP029    NHP030

*** Test Cases ***    Mã hh       Mã hhqd 1     Mã hhqd 2    Tên           Nhóm       Giá vốn    Giá bán    Tồn kho    DVCB     DV1    GTQD1    DV2       GTQD2
Thêm mới              [Tags]        EP
                      [Template]    edvt1
                      [Documentation]   Thêm mới hàng đơn vị tính
                      HDVAT0001    HDVQD0011   HDVQD0012    GreenCross    Dịch vụ    80000      60000      20         cái    vỉ     4        lốc       5

Cập nhật              [Tags]        EP
                      [Template]    edvt2
                      [Documentation]   Cập nhật hàng đơn vị tính
                      HDVAT0002    HDVQD0021   GreenCross    Dịch vụ    80000      250000     20         cái    vỉ     4        260000    HDVAT0003      Dầu gội    Dịch vụ    50000    80

Xóa                   [Tags]
                      [Template]    edvt3
                      [Documentation]   Xóa hàng đơn vị tính
                      HDVAT0004     HDVQD0041   GreenCross    Dịch vụ    80000      250000     20         cái    vỉ     4        260000

*** Keywords ***
edvt1
    [Arguments]    ${ma_hh}   ${ma_hh_qd_1}   ${ma_hh_qd_2}   ${ten_hanghoa}    ${nhom_hang}    ${giavon}    ${giaban}    ${tonkho}    ${dvcb}
    ...    ${dv1}    ${gtqd1}    ${dv2}    ${gtqd2}
    Delete product if product is visible thr API       ${ma_hh}
    Log    Step UI
    Reload Page
    Go to Them moi Hang Hoa
    Input data in Them hang hoa form    ${ma_hh}    ${ten_hanghoa}    ${nhom_hang}    ${giaban}    ${giavon}    ${tonkho}
    Input 2 unit in Them hang hoa form    ${ma_hh_qd_1}    ${dvcb}    ${dv1}    ${gtqd1}    ${ma_hh_qd_2}    ${dv2}
    ...    ${gtqd2}
    Click Element    ${button_luu}
    Wait Until Page Contains Element        ${button_dongy_apdung_giavon}     20s
    KV Click Element   ${button_dongy_apdung_giavon}
    Product create success validation
    Log    validate api
    ${result_tenhh}    ${result_cost_qd_1}   ${result_price_qd_1}    ${tonkho_qd1}   ${result_cost_qd_2}   ${result_price_qd_2}    ${tonkho_qd2}    Computation list cost, price, onhand of product incl 2 unit    ${ten_hanghoa}     ${dvcb}    ${giavon}    ${giaban}    ${tonkho}    ${gtqd1}    ${gtqd2}
    Wait Until Keyword Succeeds    3 times    3s    Assert data in case create product    ${ma_hh}    ${result_tenhh}    ${nhom_hang}
    ...    ${tonkho}    ${giavon}    ${giaban}
    Wait Until Keyword Succeeds    3 times    3s    Assert data in case create unit product    ${ma_hh}    ${result_tenhh}    ${nhom_hang}
    ...    ${tonkho}    ${giavon}    ${giaban}
    Assert data in case create unit product    ${ma_hh_qd_1}    ${ten_hanghoa}    ${nhom_hang}
    ...    ${tonkho_qd1}    ${result_cost_qd_1}    ${result_price_qd_1}
    Assert data in case create unit product    ${ma_hh_qd_2}    ${ten_hanghoa}    ${nhom_hang}
    ...    ${tonkho_qd2}    ${result_cost_qd_2}    ${result_price_qd_2}
    Delete product thr API    ${ma_hh}

edvt2
    [Arguments]    ${ma_hh}     ${ma_qd}    ${ten_hanghoa}    ${nhom_hang}    ${giavon}    ${giaban}    ${ton}    ${dvcb}
    ...    ${dv1}    ${gtqd1}    ${giaban1}    ${mahh_up}   ${ten_hanghoa_up}    ${nhom_hang_up}    ${giaban_up}
    ...    ${tonkho_up}
    ${list_pr}      Create List    ${ma_hh}     ${mahh_up}
    Delete list product if list product is visible thr API    ${list_pr}
    Reload Page
    Add product incl 1 unit thrAPI    ${ma_hh}    ${ten_hanghoa}    ${nhom_hang}    ${giaban}    ${giavon}    ${ton}
    ...    ${dvcb}    ${dv1}    ${gtqd1}    ${giaban1}    ${ma_qd}
    Search product code and click update product    ${ma_hh}
    Input data in Them hang hoa form without cost    ${mahh_up}    ${ten_hanghoa_up}    ${nhom_hang_up}    none    ${tonkho_up}
    Input Text    ${textbox_hh_giaban}    ${giaban_up}
    KV Click Element JS    //button[contains(text(),'Đồng ý')]
    KV Click Element JS   //body/div[35]/div[2]/div[2]/button[1][1]/i[1]
    Click Element    ${button_luu}
    Update data success validation
    ${result_tenhh}    ${result_cost_qd_1}   ${giaban1_up}    ${tonkho_qd1}    Computation list cost, price, onhand of product incl 1 unit    ${ten_hanghoa_up}     ${dvcb}    ${giavon}    ${giaban_up}    ${tonkho_up}    ${gtqd1}
    Wait Until Keyword Succeeds    3 times    3s    Assert data in case create unit product    ${mahh_up}    ${result_tenhh}    ${nhom_hang_up}
    ...    ${tonkho_up}    ${giavon}    ${giaban_up}
    Assert data in case create unit product    ${ma_qd}    ${ten_hanghoa_up}    ${nhom_hang_up}
    ...    ${tonkho_qd1}    ${result_cost_qd_1}    ${giaban1_up}
    Delete product thr API    ${mahh_up}

edvt3
    [Arguments]    ${ma_hh}  ${ma_qd}  ${ten_hanghoa}    ${nhom_hang}    ${giavon}    ${giaban}    ${ton}    ${dvcb}
    ...    ${dv1}    ${gtqd1}    ${giaban1}
    [Timeout]
    Delete product if product is visible thr API    ${ma_hh}
    Reload Page
    Add product incl 1 unit thrAPI    ${ma_hh}    ${ten_hanghoa}    ${nhom_hang}    ${giaban}    ${giavon}    ${ton}
    ...    ${dvcb}    ${dv1}    ${gtqd1}    ${giaban1}    ${ma_qd}
    Search product code and delete product    ${ma_hh}
    Delete product success validation    ${ma_hh}
    Wait Until Keyword Succeeds    3 times    3s    Assert product is not available thr API    ${ma_hh}
    Assert product is not available thr API    ${ma_qd}
