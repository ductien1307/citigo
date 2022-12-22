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

*** Test Cases ***    Mã hh         Tên           Nhóm       Giá vốn    Giá bán    Tồn kho    DVCB     DV1    GTQD1    DV2       GTQD2    Thương hiệu
Them                  [Tags]      EP1
                      [Template]    epth3
                      [Documentation]   Thêm mới hàng dvt có mã vạch
                      DVTAT0001      DVTAT0011    DVTAT0012   GreenCross    Dịch vụ    80000      60000      20         chiếc    vỉ     4        lốc       5          Zara

Sua                   [Tags]     
                      [Template]    epth4
                      [Documentation]   Cập nhật hàng dvt có mã vạch
                      DVTAT0002     DVTAT0021   GreenCross    Dịch vụ    80000      250000     20         chiếc    vỉ     4        260000    none      Dầu gội    Dịch vụ    50000    80     Lyn

*** Keywords ***
epth3
    [Arguments]    ${ma_hh}   ${ma_hh_qd_1}   ${ma_hh_qd_2}    ${ten_hanghoa}    ${nhom_hang}    ${giavon}    ${giaban}    ${tonkho}    ${dvcb}
    ...    ${dv1}    ${gtqd1}    ${dv2}    ${gtqd2}     ${ten_thuong_hieu}
    Delete product if product is visible thr API        ${ma_hh}
    Reload Page
    Go to Them moi Hang Hoa
    ${ma_vach}      Generate code automatically     MVAT
    ${ma_vach_1}    Generate code automatically    MVAT
    ${ma_vach_2}    Generate code automatically    MVAT
    Input data in Them hang hoa form    ${ma_hh}    ${ten_hanghoa}    ${nhom_hang}    ${giaban}    ${giavon}    ${tonkho}
    input data      ${textbox_mavach}     ${ma_vach}
    Select thuong hieu    ${ten_thuong_hieu}
    Input 2 unit and barcode in Them hang hoa form   ${ma_hh_qd_1}    ${dvcb}    ${dv1}    ${gtqd1}   ${ma_vach_1}    ${ma_hh_qd_2}    ${dv2}
    ...    ${gtqd2}   ${ma_vach_2}
    Click Element    ${button_luu}
    KV Click Element   ${button_dongy_apdung_giavon}
    Product create success validation
    ${result_tenhh}    ${result_cost_qd_1}   ${result_price_qd_1}    ${tonkho_qd1}   ${result_cost_qd_2}   ${result_price_qd_2}    ${tonkho_qd2}    Computation list cost, price, onhand of product incl 2 unit    ${ten_hanghoa}     ${dvcb}    ${giavon}    ${giaban}    ${tonkho}    ${gtqd1}    ${gtqd2}
    Wait Until Keyword Succeeds    3 times    3s    Assert data in case create product    ${ma_hh}    ${result_tenhh}    ${nhom_hang}
    ...    ${tonkho}    ${giavon}    ${giaban}
    Assert data in case create product have trade mark name   ${ma_hh}    ${ma_vach}    ${result_tenhh}    ${nhom_hang}
    ...    ${tonkho}    ${giavon}    ${giaban}    ${ten_thuong_hieu}
    Assert data in case create product have trade mark name    ${ma_hh_qd_1}   ${ma_vach_1}   ${ten_hanghoa}    ${nhom_hang}
    ...    ${tonkho_qd1}    ${result_cost_qd_1}    ${result_price_qd_1}     ${ten_thuong_hieu}
    Assert data in case create product have trade mark name     ${ma_hh_qd_2}  ${ma_vach_2}    ${ten_hanghoa}    ${nhom_hang}
    ...    ${tonkho_qd2}    ${result_cost_qd_2}    ${result_price_qd_2}     ${ten_thuong_hieu}
    Delete product thr API    ${ma_hh}

epth4
    [Arguments]    ${ma_hh}     ${ma_qd}    ${ten_hanghoa}    ${nhom_hang}    ${giavon}    ${giaban}    ${ton}    ${dvcb}
    ...    ${dv1}    ${gtqd1}    ${giaban1}    ${mahh_up}   ${ten_hanghoa_up}    ${nhom_hang_up}    ${giaban_up}
    ...    ${tonkho_up}     ${ten_thuong_hieu}
    ${list_pr_del}    Create List    ${ma_hh}   ${mahh_up}
    Delete list product if list product is visible thr API    ${list_pr_del}
    Reload Page
    Add product incl 1 unit thrAPI    ${ma_hh}    ${ten_hanghoa}    ${nhom_hang}    ${giaban}    ${giavon}    ${ton}
    ...    ${dvcb}    ${dv1}    ${gtqd1}    ${giaban1}    ${ma_qd}
    Search product code and click update product    ${ma_hh}
    Input data in Them hang hoa form without cost    ${mahh_up}    ${ten_hanghoa_up}    ${nhom_hang_up}    none    ${tonkho_up}
    Input Text    ${textbox_hh_giaban}    ${giaban_up}
    KV Click Element JS    //button[contains(text(),'Đồng ý')]
    KV Click Element JS   //body/div[35]/div[2]/div[2]/button[1][1]/i[1]
    ${ma_vach}      Generate code automatically     MVAT
    input data      ${textbox_mavach}     ${ma_vach}
    Select thuong hieu    ${ten_thuong_hieu}
    Click Element    ${button_luu}
    Update data success validation
    ${mahh_up}    Set Variable If      '${mahh_up}'=='none'      ${ma_hh}      ${mahh_up}
    ${result_tenhh}    ${result_cost_qd_1}   ${giaban1_up}    ${tonkho_qd1}    Computation list cost, price, onhand of product incl 1 unit    ${ten_hanghoa_up}     ${dvcb}    ${giavon}    ${giaban_up}    ${tonkho_up}    ${gtqd1}
    Wait Until Keyword Succeeds    3 times    3s    Assert data in case create product have trade mark name   ${mahh_up}    ${ma_vach}    ${result_tenhh}    ${nhom_hang_up}
    ...    ${tonkho_up}    ${giavon}    ${giaban_up}    ${ten_thuong_hieu}
    Wait Until Keyword Succeeds    3 times    3s    Assert data in case create product have trade mark name    ${ma_qd}   0   ${ten_hanghoa_up}    ${nhom_hang_up}
    ...    ${tonkho_qd1}    ${result_cost_qd_1}    ${giaban1_up}     ${ten_thuong_hieu}
    Delete product thr API    ${mahh_up}
