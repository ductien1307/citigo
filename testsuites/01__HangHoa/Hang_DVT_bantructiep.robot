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
@{list_bantructiep1}      false   true
@{list_thutu_them_hangquydoi1}   0    1

*** Test Cases ***    Mã hh         Mã hhqd1       Mã hhqd2         Tên                   Nhóm         Giá vốn    Giá bán    Tồn kho    DVCB     Trực tiếp CB     DV1    GTQD1    DV2       GTQD2   List trực tiếp        List thứ tự thêm hàng QĐ
Thêm                  [Tags]        EP1
                      [Template]    ebtt1
                      [Documentation]   Thêm mới hàng đơn vị tính bán trực tiêp
                      HBTTDV0001    HBTTDV0011    HBTTDV0012    Hàng đơn vị tính 1     Hạt nhập khẩu    80000      60000      20         chiếc     true           vỉ     4        lốc       5       ${list_bantructiep1}    ${list_thutu_them_hangquydoi1}

Sửa                   [Tags]        EP1
                      [Template]    ebtt2
                      [Documentation]   Cập nhật hàng đơn vị tính bán trực tiếp
                      HBTTDV0002       HBTTDV0021                Hàng đơn vị tính 2     Hạt nhập khẩu    80000      250000     20         chiếc    false           vỉ     4        260000    Dầu gội    Dịch vụ    50000    80      true    0

*** Keywords ***
ebtt1
    [Arguments]    ${ma_hh}   ${ma_hh_qd_1}   ${ma_hh_qd_2}   ${ten_hanghoa}    ${nhom_hang}    ${giavon}    ${giaban}    ${tonkho}    ${dvcb}     ${input_tructiep_cb}
    ...    ${dv1}    ${gtqd1}    ${dv2}    ${gtqd2}   ${list_bantructiep}   ${list_thutu_hangquydoi}
    Delete product if product is visible thr API        ${ma_hh}
    Reload Page
    Go to Them moi Hang Hoa
    Input data in Them hang hoa form    ${ma_hh}    ${ten_hanghoa}    ${nhom_hang}    ${giaban}    ${giavon}    ${tonkho}
    Input 2 unit in Them hang hoa form    ${ma_hh_qd_1}    ${dvcb}    ${dv1}    ${gtqd1}    ${ma_hh_qd_2}    ${dv2}
    ...    ${gtqd2}
    Choose checkbok sell directly    ${input_tructiep_cb}    ${list_bantructiep}   ${list_thutu_hangquydoi}
    Click Element    ${button_luu}
    KV Click Element   ${button_dongy_apdung_giavon}
    Product create success validation
    ${result_tenhh}    ${result_cost_qd_1}   ${result_price_qd_1}    ${tonkho_qd1}   ${result_cost_qd_2}   ${result_price_qd_2}    ${tonkho_qd2}    Computation list cost, price, onhand of product incl 2 unit    ${ten_hanghoa}     ${dvcb}    ${giavon}    ${giaban}    ${tonkho}    ${gtqd1}    ${gtqd2}
    Wait Until Keyword Succeeds    3 times    3s    Assert data in case create unit product    ${ma_hh}    ${result_tenhh}    ${nhom_hang}
    ...    ${tonkho}    ${giavon}    ${giaban}
    Assert data in case create unit product    ${ma_hh_qd_1}    ${ten_hanghoa}    ${nhom_hang}   ${tonkho_qd1}    ${result_cost_qd_1}    ${result_price_qd_1}
    Assert data in case create unit product    ${ma_hh_qd_2}    ${ten_hanghoa}    ${nhom_hang}   ${tonkho_qd2}    ${result_cost_qd_2}    ${result_price_qd_2}
    ##validate allow sales
    ${list_product}   Create List    ${ma_hh_qd_1}    ${ma_hh_qd_2}
    Validate allow sale status by product code     ${ma_hh}    ${input_tructiep_cb}
    :FOR    ${item_product}   ${item_tructiep}    IN ZIP    ${list_product}    ${list_bantructiep}
    \    Validate allow sale status by product code     ${item_product}    ${item_tructiep}
    Delete product thr API    ${ma_hh}

ebtt2
    [Arguments]    ${ma_hh}   ${ma_qd}    ${ten_hanghoa}    ${nhom_hang}    ${giavon}    ${giaban}    ${ton}    ${dvcb}     ${input_tructiep_cb}
    ...    ${dv1}    ${gtqd1}    ${giaban1}    ${ten_hanghoa_up}    ${nhom_hang_up}    ${giaban_up}    ${tonkho_up}
    ...   ${input_bantructiep}   ${input_thutu_hangquydoi}
    Delete product if product is visible thr API       ${ma_hh}
    Reload Page
    Add product incl 1 unit thrAPI    ${ma_hh}    ${ten_hanghoa}    ${nhom_hang}    ${giaban}    ${giavon}    ${ton}
    ...    ${dvcb}    ${dv1}    ${gtqd1}    ${giaban1}    ${ma_qd}
    Search product code and click update product    ${ma_hh}
    Input data in Them hang hoa form without cost    none    ${ten_hanghoa_up}    ${nhom_hang_up}    none    ${tonkho_up}
    Input Text    ${textbox_hh_giaban}    ${giaban_up}
    KV Click Element JS    //button[contains(text(),'Đồng ý')]
    KV Click Element JS   //body/div[35]/div[2]/div[2]/button[1][1]/i[1]
    Run Keyword If    '${input_tructiep_cb}' == 'true'    Log      Ignore input      ELSE      Click Element JS      ${checkbox_bantructiep_coban}
    ${checkbox_bantructiep_quydoi}    Format String    ${checkbox_bantructiep_quydoi}   ${input_thutu_hangquydoi}
    Run Keyword If    '${input_bantructiep}' == 'true'    Log      Ignore input      ELSE      Click Element JS      ${checkbox_bantructiep_quydoi}
    Click Element    ${button_luu}
    Update data success validation
    ${result_tenhh}    ${result_cost_qd_1}   ${giaban1_up}    ${tonkho_qd1}    Computation list cost, price, onhand of product incl 1 unit    ${ten_hanghoa_up}     ${dvcb}    ${giavon}    ${giaban_up}    ${tonkho_up}    ${gtqd1}
    Wait Until Keyword Succeeds    3 times    3s    Assert data in case create unit product    ${ma_hh}    ${result_tenhh}    ${nhom_hang_up}
    ...    ${tonkho_up}    ${giavon}    ${giaban_up}
    Assert data in case create unit product    ${ma_qd}    ${ten_hanghoa_up}    ${nhom_hang_up}
    ...    ${tonkho_qd1}    ${result_cost_qd_1}    ${giaban1_up}
    ##validate allow sales
    Validate allow sale status by product code     ${ma_hh}    ${input_tructiep_cb}
    Validate allow sale status by product code     ${ma_qd}    ${input_bantructiep}
    Delete product thr API    ${ma_hh}
