*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    ${headless_browser}
Test Setup        Before Test Bang tinh luong
Test Teardown     After Test
Resource          ../../../../config/env_product/envi.robot
Resource          ../../../../core/Nhan_vien/nhanvien_navigation.robot
Resource          ../../../../core/Nhan_vien/nhanvien_list_action.robot
Resource          ../../../../core/Nhan_vien/bangtinhluong_list_action.robot
Resource          ../../../../core/API/api_bangtinhluong.robot
Resource          ../../../../core/API/api_nhanvien.robot
Resource          ../../../../core/API/api_chamcong.robot
Resource          ../../../../core/API/api_access.robot
Resource          ../../../../core/API/api_thietlap.robot
Resource          ../../../../core/Share/discount.robot
Resource          ../../../../core/Share/computation.robot
Resource          ../../../../core/Share/toast_message.robot
Resource          ../../../../core/Thiet_lap/branch_list_action.robot
Library           Collections
Library           DateTime

*** Variables ***
@{list_ca}        ca 1    ca 2
@{list_tong_gio_lv}    3    4
@{list_h_ve_som}    0    60
@{list_h_di_muon}    30    90
&{list_prs_num}    GHDV003=3    GHDV004=2
@{list_giamoi}    35000    60000

*** Test Cases ***
Lam 1 ca ngay thuong
    [Documentation]     1. Tạo BL1 >> Chốt lương  2. Tạo BL2      Ex: Dữ liệu đã chốt lương không vào bảng lương 2
    [Tags]    BTL    TS1
    [Template]    ebcc1
    Chi nhánh trung tâm    NV0011    55000    ca 1

Lam 2 ca ngay thuong
    [Tags]    BTL    TS1
    [Template]    ebcc2
    Chi nhánh trung tâm    NV0012    60000    ${list_ca}

OT
    [Tags]    BTL    TS1    GOLIVE3    TS05
    [Template]    ebcc10
    Chi nhánh trung tâm    NV0013    40000    150    ${list_ca}
    ...    ${list_tong_gio_lv}    ${list_h_ve_som}    ${list_h_di_muon}

*** Keywords ***
ebcc1
    [Arguments]    ${input_branch}    ${input_ma_nv}    ${input_luong_theo_ca}    ${input_ten_ca}
    Set Selenium Speed    0.1
    ${get_branch_id}    Get BranchID by BranchName    ${input_branch}
    ${get_nv_id}    Get employee id thr API    ${input_ma_nv}
    Run Keyword If    ${get_nv_id}==0    Log    Ignore
    ...    ELSE    Delete employee thr API    ${input_ma_nv}
    Add employee and set salary by shift thr API    ${input_ma_nv}    Hoa    ${input_branch}    ${input_luong_theo_ca}    200    300
    ${get_clocking_id}    ${get_timesheet_id}    Add schedule work not repeat for one employee thr API    ${input_ten_ca}    ${input_branch}    ${input_ma_nv}
    Update not timekeeping to timekeeping thr API    ${input_branch}    ${input_ten_ca}    ${input_ma_nv}     ${get_clocking_id}
    ...    ${get_timesheet_id}
    Reload page
    ${get_cur_day}    Get Current Date
    Add new pay sheet and input pay period    ${get_cur_day}
    ${ma_bang_luong}    Generate code automatically    BL
    Input data    ${textbox_mabangluong}    ${ma_bang_luong}
    Click element    ${button_chotluong}
    Create pay sheet success validation    ${ma_bang_luong}
    #
    ${get_ma_phieu_luong}     Get pay slip by employee thr API    ${input_ma_nv}
    ${get_datra}    ${get_cantra}    Get total payment and total need pay by pay sheet code    ${ma_bang_luong}    ${get_ma_phieu_luong}    ${get_branch_id}
    Should Be Equal As Numbers    ${get_cantra}     ${input_luong_theo_ca}
    Should Be Equal As Numbers    ${get_datra}     0
    #
    Reload Page
    Add new pay sheet and input pay period    ${get_cur_day}
    ${ma_bang_luong_2}    Generate code automatically    BL2
    Input data    ${textbox_mabangluong}    ${ma_bang_luong_2}
    Click element    ${button_chotluong}
    Create pay sheet success validation    ${ma_bang_luong_2}
    #
    ${get_ma_phieu_luong_2}    Get pay slip by employee thr API    ${input_ma_nv}
    ${get_total_payment}    ${get_total_need_pay}    Get total payment and total need pay by pay sheet code    ${ma_bang_luong_2}    ${get_ma_phieu_luong_2}    ${get_branch_id}
    Should Be Equal As Numbers    ${get_total_need_pay}    0
    Should Be Equal As Numbers    ${get_total_payment}    0
    Delete pay sheet thr API    ${ma_bang_luong}    ${get_branch_id}
    Delete clocking thr API    ${get_clocking_id}    ${get_branch_id}
    Delete employee thr API    ${input_ma_nv}

ebcc2
    [Arguments]    ${input_branch}    ${input_ma_nv}    ${input_luong_theo_ca}    ${list_ten_ca}
    Set Selenium Speed    0.1
    ${get_branch_id}    Get BranchID by BranchName    ${input_branch}
    ${get_nv_id}    Get employee id thr API    ${input_ma_nv}
    Run Keyword If    ${get_nv_id}==0    Log    Ignore
    ...    ELSE    Delete employee thr API    ${input_ma_nv}
    Add employee and set salary by shift thr API    ${input_ma_nv}    Hoa    ${input_branch}    ${input_luong_theo_ca}    200    300
    : FOR    ${item_ten_ca}      IN ZIP    ${list_ten_ca}
    \    ${get_clocking_id}    ${get_timesheet_id}    Add schedule work not repeat for one employee thr API    ${item_ten_ca}    ${input_branch}    ${input_ma_nv}
    \    Update not timekeeping to timekeeping thr API    ${input_branch}    ${item_ten_ca}    ${input_ma_nv}     ${get_clocking_id}    ${get_timesheet_id}
    Reload page
    ${get_cur_day}    Get Current Date
    Add new pay sheet and input pay period    ${get_cur_day}
    ${ma_bang_luong}    Generate code automatically    BL
    Input data    ${textbox_mabangluong}    ${ma_bang_luong}
    Click element    ${button_chotluong}
    Create pay sheet success validation    ${ma_bang_luong}
    Sleep    2s
    ${total_ca_lv}    Get Length    ${list_ten_ca}
    ${result_total_net}    Multiplication and round    ${total_ca_lv}    ${input_luong_theo_ca}
    ${get_ma_phieu_luong}    Get pay slip by employee thr API    ${input_ma_nv}
    ${get_total_payment}    ${get_total_need_pay}    Get total payment and total need pay by pay sheet code    ${ma_bang_luong}    ${get_ma_phieu_luong}    ${get_branch_id}
    Should Be Equal As Numbers    ${result_total_net}    ${get_total_need_pay}
    Should Be Equal As Numbers    ${get_total_payment}    0
    Delete pay sheet thr API    ${ma_bang_luong}    ${get_branch_id}
    Delete clocking thr API    ${get_clocking_id}    ${get_branch_id}
    Delete employee thr API    ${input_ma_nv}

ebcc10
    [Arguments]    ${input_branch}    ${input_ma_nv}    ${input_luong_theo_ca}    ${input_luong_ot}    ${list_ten_ca}
    ...    ${list_gio_lv}    ${list_di_som}    ${list_ve_muon}
    Set Selenium Speed    0.1
    ${get_branch_id}    Get BranchID by BranchName    ${input_branch}
    ${get_nv_id}    Get employee id thr API    ${input_ma_nv}
    Run Keyword If    ${get_nv_id}==0    Log    Ignore
    ...    ELSE    Delete employee thr API    ${input_ma_nv}
    Add employee and set salary by shift and over time thr API    ${input_ma_nv}    Hoa    ${input_branch}    ${input_luong_theo_ca}    200    300
    ...    ${input_luong_ot}    15000    20000
    : FOR    ${item_ten_ca}        ${item_di_son}    ${item_ve_muon}    IN ZIP
    ...    ${list_ten_ca}     ${list_di_som}    ${list_ve_muon}
    \    ${get_clocking_id}    ${get_timesheet_id}    Add schedule work not repeat for one employee thr API    ${item_ten_ca}    ${input_branch}    ${input_ma_nv}
    \    Update not timekeeping to timekeeping and over time thr API    ${input_branch}    ${item_ten_ca}    ${input_ma_nv}
    \    ...    ${item_di_son}    ${item_ve_muon}    ${get_clocking_id}    ${get_timesheet_id}
    Reload page
    ${get_cur_day}    Get Current Date
    Add new pay sheet and input pay period    ${get_cur_day}
    Delete employee thr API    ${input_ma_nv}
