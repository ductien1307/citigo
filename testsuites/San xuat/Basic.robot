*** Settings ***
Suite Setup       Setup Test Suite   Before Test San xuat
#Test Setup        Before Test San xuat
Suite Teardown     After Test
Resource          ../../core/hang_hoa/sanxuat_list_action.robot
Resource          ../../core/hang_hoa/tao_phieu_sx_action.robot
Resource          ../../core/share/toast_message.robot
Resource          ../../config/env_product/envi.robot
Resource          ../../prepare/Hang_hoa/Sources/hanghoa.robot
Resource          ../../core/hang_hoa/danh_muc_list_action.robot
Resource          ../../core/API/api_hanghoa.robot
Resource          ../../core/API/api_sanxuat.robot
Resource          ../../core/Ban_Hang/banhang_getandcompute.robot

*** Variables ***

*** Test Cases ***    Mã HH        Số lượng     Ghi chú     Tự đồng trừ tp thứ cấp
Tạo phiếu 1           [Tags]     EP1
                      [Documentation]     Tạo phiếu sản xuất với hàng không có thành phần thứ cấp hoặc ko chọn tự động trừ TPTC
                      [Template]    esx1
                      SX0001        1          abc           true
                      SX0002        2          none           false
                      SX0003        3          có hàng thứ cấp           false

Tạo phiếu 2           [Tags]      EP1
                      [Template]    esx3
                      [Documentation]     Tạo phiếu sản xuất với hàng có thành phần thứ cấp và chọn tự động trừ TPTC
                      SX0003        3          có hàng thứ cấp           true

Cập nhật              [Tags]      EP1
                      [Template]    esx2
                      [Documentation]     Cập nhật phiếu sản xuất
                      SX0001        1          abc1

*** Keyword ***
esx1
    [Arguments]    ${input_product}    ${input_num}    ${input_ghichu}    ${is_auto}
    Log    tính tồn kho của hàng cha và hàng thành phần sau khi tạo phiếu
    ${get_onhand_af}    Get product onhand af manufacture   ${input_product}    ${input_num}
    ${list_mahh_tp_af_ex}     ${list_tonkho_tp_af_ex}    Computation list onhand of material after manufacture    ${input_product}    ${input_num}
    #s
    Log    step UI
    Reload Page
    Go to Tao phieu san xuat
    ${ma_phieu}     Generate code automatically    SX
    Input data in popup Tao phieu san xuat    ${ma_phieu}    ${input_product}    ${input_num}    ${input_ghichu}    ${is_auto}
    Click Element    ${button_hoanthanh}
    Update data success validation
    #
    Log    validate tồn kho hàng cha
    Wait Until Keyword Succeeds    3x    3s    Assert values in Stock Card    ${ma_phieu}    ${input_product}    ${get_onhand_af}    ${input_num}
    Log    validate tồn kho hàng thành phần
    Assert list onhand of material after manufacture    ${list_mahh_tp_af_ex}     ${list_tonkho_tp_af_ex}
    Delete manufacturing thr API    ${ma_phieu}

esx2
    [Arguments]    ${input_product}    ${input_num}    ${input_ghichu}
    ${ma_phieu}   Add manufacturing thr API    ${input_product}    ${input_num}
    Reload Page
    Search Ma san xuat and lick update    ${ma_phieu}
    Input Text     ${textbox_ghi_chu_sx}    ${input_ghichu}
    Click Element     ${button_luu_phieu_sx}
    Update data success validation
    Delete manufacturing thr API    ${ma_phieu}

esx3
    [Arguments]    ${input_product}    ${input_num}    ${input_ghichu}    ${is_auto}
    Log    tính tồn kho của hàng cha và hàng thành phần sau khi tạo phiếu
    ${get_onhand_af}    Get product onhand af manufacture   ${input_product}    ${input_num}
    ${list_code_included}     ${list_onhand_included_af}   Get list onhand by list included products af manufacture    ${input_product}    ${input_num}
    #s
    Log    step UI
    Reload Page
    Go to Tao phieu san xuat
    ${ma_phieu}     Generate code automatically    SX
    Input data in popup Tao phieu san xuat    ${ma_phieu}    ${input_product}    ${input_num}    ${input_ghichu}    ${is_auto}
    Click Element    ${button_hoanthanh}
    Update data success validation
    #
    Log    validate tồn kho hàng cha
    Wait Until Keyword Succeeds    3x    3s    Assert values in Stock Card    ${ma_phieu}    ${input_product}    ${get_onhand_af}    ${input_num}
    Log    validate tồn kho hàng thành phần thứ cấp
    Assert list onhand of included products after manufacture    ${list_code_included}     ${list_onhand_included_af}
    Delete manufacturing thr API    ${ma_phieu}
