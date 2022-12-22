*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}      ${headless_browser}
Test Setup        Before Test Bang tinh luong and switch branch    Nhánh A
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
@{list_ca}      ca 1      ca 2
@{list_h_ve_som}      0           60
@{list_h_di_muon}     30          90

*** Test Cases ***
Lam 1 ca ngay nghi          [Tags]
                            [Template]              ebcc3
                            Nhánh A    NV0001          40000       70000      300    ca 1
                            Nhánh A    NV0002          55000       200        120000    ca 1


Lam 2 ca ngay nghi          [Tags]        BTL     TS1
                            [Template]              ebcc4
                            Nhánh A     NV0003          50000     75000      300    ${list_ca}
                            Nhánh A     NV0004          60000     75000      100000    ${list_ca}

Lam 2 ca ngay le            [Tags]        BTL     TS1
                            [Template]              ebcc5
                            20200430     Thursday    Nhánh A     NV0005          50000     70000      300     ${list_ca}
                            20200430     Thursday    Nhánh A     NV0006          45000     200      150000      ${list_ca}

Lam ngay nghi co OT         [Tags]         BTL    TS1
                            [Template]              ebcc11
                            Nhánh A    NV0007          40000      70000      150     ${list_ca}         ${list_h_ve_som}      ${list_h_di_muon}
                            Nhánh A    NV0008          40000      70000      80000     ${list_ca}       ${list_h_ve_som}      ${list_h_di_muon}

Lam ngay le co OT           [Tags]         BTL    TS1
                            [Template]              ebcc12
                            20200430     Thursday   Nhánh A    NV0009      40000     200     300      80000     ${list_ca}         ${list_h_ve_som}      ${list_h_di_muon}
                            20200430     Thursday   Nhánh A    NV0010      40000   50000   70000      80000     ${list_ca}         ${list_h_ve_som}      ${list_h_di_muon}

*** Keywords ***
ebcc3
    [Arguments]     ${input_branch}     ${input_ma_nv}    ${input_luong_theo_ca}    ${input_luong_ngaynghi}     ${input_luong_ngayle}    ${input_ten_ca}
    Set Selenium Speed    0.1
    ${get_day}      Get Current Date      result_format=%A
    ${get_branch_id}      Get BranchID by BranchName    ${input_branch}
    Update working day for branch    ${input_branch}    ${get_branch_id}    ${get_day}
    ${get_nv_id}      Get employee id thr API    ${input_ma_nv}
    Run Keyword If    ${get_nv_id}==0      Log    Ignore       ELSE      Delete employee thr API    ${input_ma_nv}
    Add employee and set salary by shift thr API       ${input_ma_nv}    Hoa    ${input_branch}     ${input_luong_theo_ca}      ${input_luong_ngaynghi}     ${input_luong_ngayle}
    ${get_clocking_id}   ${get_timesheet_id}    Add schedule work not repeat for one employee thr API    ${input_ten_ca}   ${input_branch}    ${input_ma_nv}
    Update not timekeeping to timekeeping thr API     ${input_branch}    ${input_ten_ca}    ${input_ma_nv}     ${get_clocking_id}   ${get_timesheet_id}
    Reload page
    ${get_cur_day}     Get Current Date
    Add new pay sheet and input pay period      ${get_cur_day}
    ${ma_bang_luong}      Generate code automatically    BL
    Input data        ${textbox_mabangluong}      ${ma_bang_luong}
    Click element     ${button_chotluong}
    Create pay sheet success validation    ${ma_bang_luong}
    Sleep    2s
    ${result_total_net}     Run Keyword If    ${input_luong_ngaynghi}<1000    Convert % discount to VND     ${input_luong_theo_ca}    ${input_luong_ngaynghi}    ELSE      Set Variable    ${input_luong_ngaynghi}
    ${get_ma_phieu_luong}     Get pay slip by employee thr API    ${input_ma_nv}
    ${get_total_payment}     ${get_total_need_pay}    Get total payment and total need pay by pay sheet code     ${ma_bang_luong}   ${get_ma_phieu_luong}   ${get_branch_id}
    Should Be Equal As Numbers    ${result_total_net}     ${get_total_need_pay}
    Should Be Equal As Numbers    ${get_total_payment}     0
    Delete pay sheet thr API    ${ma_bang_luong}    ${get_branch_id}
    Delete clocking thr API    ${get_clocking_id}    ${get_branch_id}
    Update working day for branch    ${input_branch}    ${get_branch_id}    none
    Delete employee thr API    ${input_ma_nv}

ebcc4
    [Arguments]     ${input_branch}     ${input_ma_nv}    ${input_luong_theo_ca}    ${input_luong_ngaynghi}    ${input_luong_ngayle}    ${list_ten_ca}
    Set Selenium Speed    0.1
    ${get_day}      Get Current Date      result_format=%A
    ${get_branch_id}      Get BranchID by BranchName    ${input_branch}
    Update working day for branch    ${input_branch}    ${get_branch_id}    ${get_day}
    ${get_nv_id}      Get employee id thr API    ${input_ma_nv}
    Run Keyword If    ${get_nv_id}==0      Log    Ignore       ELSE      Delete employee thr API    ${input_ma_nv}
    Add employee and set salary by shift thr API       ${input_ma_nv}    Hoa    ${input_branch}     ${input_luong_theo_ca}      ${input_luong_ngaynghi}     ${input_luong_ngayle}
    :FOR      ${item_ten_ca}          IN ZIP       ${list_ten_ca}
    \   ${get_clocking_id}   ${get_timesheet_id}    Add schedule work not repeat for one employee thr API    ${item_ten_ca}   ${input_branch}    ${input_ma_nv}
    \   Update not timekeeping to timekeeping thr API     ${input_branch}    ${item_ten_ca}     ${input_ma_nv}     ${get_clocking_id}   ${get_timesheet_id}
    Reload page
    ${get_cur_day}     Get Current Date
    Add new pay sheet and input pay period      ${get_cur_day}
    ${ma_bang_luong}      Generate code automatically    BL
    Input data        ${textbox_mabangluong}      ${ma_bang_luong}
    Click element     ${button_chotluong}
    Create pay sheet success validation    ${ma_bang_luong}
    Sleep    2s
    ${total_ca_lv}      Get Length    ${list_ten_ca}
    ${result_total_net}     Run Keyword If    ${input_luong_ngaynghi}<1000    Convert % discount to VND     ${input_luong_theo_ca}    ${input_luong_ngaynghi}    ELSE      Set Variable    ${input_luong_ngaynghi}
    ${result_total_net}     Multiplication and round    ${total_ca_lv}    ${result_total_net}
    ${get_ma_phieu_luong}     Get pay slip by employee thr API    ${input_ma_nv}
    ${get_total_payment}     ${get_total_need_pay}    Get total payment and total need pay by pay sheet code     ${ma_bang_luong}   ${get_ma_phieu_luong}   ${get_branch_id}
    Should Be Equal As Numbers    ${result_total_net}     ${get_total_need_pay}
    Should Be Equal As Numbers    ${get_total_payment}     0
    Delete pay sheet thr API    ${ma_bang_luong}    ${get_branch_id}
    Delete clocking thr API    ${get_clocking_id}    ${get_branch_id}
    Update working day for branch    ${input_branch}    ${get_branch_id}    none
    Delete employee thr API    ${input_ma_nv}

ebcc5
    [Arguments]    ${input_ngayle}    ${input_thu}   ${input_branch}     ${input_ma_nv}    ${input_luong_theo_ca}    ${input_luong_ngaynghi}    ${input_luong_ngayle}    ${list_ten_ca}
    Set Selenium Speed    0.1
    ${get_branch_id}      Get BranchID by BranchName    ${input_branch}
    Update working day for branch    ${input_branch}    ${get_branch_id}    ${input_thu}
    ${get_nv_id}      Get employee id thr API    ${input_ma_nv}
    Run Keyword If    ${get_nv_id}==0      Log    Ignore       ELSE      Delete employee thr API    ${input_ma_nv}
    Add employee and set salary by shift thr API       ${input_ma_nv}    Hoa    ${input_branch}     ${input_luong_theo_ca}      ${input_luong_ngaynghi}     ${input_luong_ngayle}
    :FOR      ${item_ten_ca}         IN ZIP       ${list_ten_ca}
    \   ${get_clocking_id}   ${get_timesheet_id}    Add schedule work not repeat for one employee by day thr API    ${input_ngayle}    ${item_ten_ca}   ${input_branch}    ${input_ma_nv}
    \   Update not timekeeping to timekeeping by day thr API        ${input_branch}   ${input_ngayle}    ${item_ten_ca}     ${input_ma_nv}      ${get_clocking_id}   ${get_timesheet_id}
    Reload page
    Add new pay sheet and input pay period      ${input_ngayle}
    ${ma_bang_luong}      Generate code automatically    BL
    Input data        ${textbox_mabangluong}      ${ma_bang_luong}
    Click element     ${button_chotluong}
    Create pay sheet success validation    ${ma_bang_luong}
    Sleep    2s
    ${total_ca_lv}      Get Length    ${list_ten_ca}
    ${result_total_net}     Run Keyword If    ${input_luong_ngayle}<1000    Convert % discount to VND     ${input_luong_theo_ca}    ${input_luong_ngayle}    ELSE      Set Variable    ${input_luong_ngayle}
    ${result_total_net}     Multiplication and round    ${total_ca_lv}    ${result_total_net}
    ${get_ma_phieu_luong}     Get pay slip by employee thr API    ${input_ma_nv}
    ${get_total_payment}     ${get_total_need_pay}    Get total payment and total need pay by pay sheet code     ${ma_bang_luong}   ${get_ma_phieu_luong}   ${get_branch_id}
    Should Be Equal As Numbers    ${result_total_net}     ${get_total_need_pay}
    Should Be Equal As Numbers    ${get_total_payment}     0
    Delete pay sheet thr API    ${ma_bang_luong}    ${get_branch_id}
    Delete clocking thr API    ${get_clocking_id}    ${get_branch_id}
    Update working day for branch    ${input_branch}    ${get_branch_id}    none
    Delete employee thr API    ${input_ma_nv}

ebcc11
    [Arguments]     ${input_branch}     ${input_ma_nv}    ${input_luong_theo_ca}    ${input_luong_ngaynghi}    ${input_luong_ot}    ${list_ten_ca}      ${list_di_som}      ${list_ve_muon}
    Set Selenium Speed    0.1
    ${get_branch_id}      Get BranchID by BranchName    ${input_branch}
    ${get_day}      Get Current Date      result_format=%A
    Update working day for branch    ${input_branch}    ${get_branch_id}    ${get_day}
    ${get_nv_id}      Get employee id thr API    ${input_ma_nv}
    Run Keyword If    ${get_nv_id}==0      Log    Ignore       ELSE      Delete employee thr API    ${input_ma_nv}
    Add employee and set salary by shift and over time thr API        ${input_ma_nv}    Hoa    ${input_branch}     ${input_luong_theo_ca}    ${input_luong_ngaynghi}     300       15000    ${input_luong_ot}    20000
    :FOR      ${item_ten_ca}      ${item_di_son}    ${item_ve_muon}      IN ZIP       ${list_ten_ca}       ${list_di_som}      ${list_ve_muon}
    \   ${get_clocking_id}   ${get_timesheet_id}    Add schedule work not repeat for one employee thr API    ${item_ten_ca}   ${input_branch}    ${input_ma_nv}
    \   Update not timekeeping to timekeeping and over time thr API        ${input_branch}    ${item_ten_ca}     ${input_ma_nv}     ${item_di_son}    ${item_ve_muon}    ${get_clocking_id}   ${get_timesheet_id}
    Reload page
    ${get_cur_day}     Get Current Date
    Add new pay sheet and input pay period      ${get_cur_day}
    ${ma_bang_luong}      Generate code automatically    BL
    Input data        ${textbox_mabangluong}      ${ma_bang_luong}
    Click element     ${button_chotluong}
    Create pay sheet success validation    ${ma_bang_luong}
    Sleep    2s
    ${total_ca_lv}      Get Length    ${list_ten_ca}
    ${result_luong_chinh}     Multiplication and round    ${total_ca_lv}    ${input_luong_ngaynghi}
    Log    tinh luong OT
    ${list_luong_ot_tren_gio}      Create List
    :FOR      ${item_ten_ca}      IN ZIP      ${list_ten_ca}
    \     ${input_gio_vao}    ${input_gio_ra}       Get shift infor thr API     ${item_ten_ca}    ${get_branch_id}
    \     ${total_gio_lv}     Subtract Time From Time     ${input_gio_ra}       ${input_gio_vao}
    \     ${total_gio_lv}     Devision    ${total_gio_lv}    60
    \     ${luong_tren_gio}     Devision    ${input_luong_theo_ca}    ${total_gio_lv}
    \     ${luong_tren_gio_ot}    Run Keyword If    ${input_luong_ot}>1000    Set Variable    ${input_luong_ot}    ELSE    Convert % discount to VND    ${luong_tren_gio}    ${input_luong_ot}
    \     Append To List      ${list_luong_ot_tren_gio}    ${luong_tren_gio_ot}
    Log    ${list_luong_ot_tren_gio}
    ${list_luong_ot}    Create List
    :FOR    ${item_di_som}      ${item_ve_muon}   ${item_luong_theo_gio}   IN ZIP      ${list_di_som}      ${list_ve_muon}    ${list_luong_ot_tren_gio}
    \     ${thoigian_ot}      Sum    ${item_di_som}      ${item_ve_muon}
    \     ${gio_ot}     Devision    ${thoigian_ot}    60
    \     ${luong_ot}     Multiplication and round    ${gio_ot}    ${item_luong_theo_gio}
    \     Append To List    ${list_luong_ot}    ${luong_ot}
    log     ${list_luong_ot}
    ${result_luong_ot}      Sum values in list    ${list_luong_ot}
    ${result_cantra}      Sum    ${result_luong_chinh}    ${result_luong_ot}
    #
    ${get_ma_phieu_luong}     Get pay slip by employee thr API    ${input_ma_nv}
    ${get_trangthai}   ${get_luongchinh}     ${get_hoahong}    ${get_lamthem}    ${get_phucap}   ${get_giamtru}    ${get_datra}    ${get_cantra}   ${get_thuong}   Get pay sheet infor by pay sheet code      ${ma_bang_luong}   ${get_ma_phieu_luong}   ${get_branch_id}
    Should Be Equal As Numbers    ${get_trangthai}     2
    Should Be Equal As Numbers    ${get_lamthem}     ${result_luong_ot}
    Should Be Equal As Numbers    ${get_luongchinh}     ${result_luong_chinh}
    Should Be Equal As Numbers    ${get_cantra}     ${result_cantra}
    Should Be Equal As Numbers    ${get_datra}     0
    #
    Delete pay sheet thr API    ${ma_bang_luong}    ${get_branch_id}
    Delete clocking thr API    ${get_clocking_id}    ${get_branch_id}
    Update working day for branch    ${input_branch}    ${get_branch_id}    none
    Delete employee thr API    ${input_ma_nv}

ebcc12
    [Arguments]      ${input_ngayle}    ${input_thu}    ${input_branch}     ${input_ma_nv}    ${input_luong_theo_ca}     ${input_luong_ngaynghi}    ${input_luong_ngayle}    ${input_luong_ot}    ${list_ten_ca}    ${list_di_som}      ${list_ve_muon}
    Set Selenium Speed    0.1
    ${get_branch_id}      Get BranchID by BranchName    ${input_branch}
    Update working day for branch    ${input_branch}    ${get_branch_id}    ${input_thu}
    ${get_nv_id}      Get employee id thr API    ${input_ma_nv}
    Run Keyword If    ${get_nv_id}==0      Log    Ignore       ELSE      Delete employee thr API    ${input_ma_nv}
    Add employee and set salary by shift and over time thr API        ${input_ma_nv}    Hoa    ${input_branch}     ${input_luong_theo_ca}   ${input_luong_ngaynghi}      ${input_luong_ngayle}     15000       60000    ${input_luong_ot}
    :FOR      ${item_ten_ca}      ${item_di_son}    ${item_ve_muon}      IN ZIP       ${list_ten_ca}      ${list_di_som}      ${list_ve_muon}
    \   ${get_clocking_id}   ${get_timesheet_id}    Add schedule work not repeat for one employee by day thr API    ${input_ngayle}    ${item_ten_ca}   ${input_branch}    ${input_ma_nv}
    \   Update not timekeeping to timekeeping and over time by day thr API      ${input_branch}   ${input_ngayle}   ${item_ten_ca}     ${input_ma_nv}     ${item_di_son}    ${item_ve_muon}    ${get_clocking_id}   ${get_timesheet_id}
    Reload page
    Add new pay sheet and input pay period      ${input_ngayle}
    ${ma_bang_luong}      Generate code automatically    BL
    Input data        ${textbox_mabangluong}      ${ma_bang_luong}
    Click element     ${button_chotluong}
    Create pay sheet success validation    ${ma_bang_luong}
    Sleep    2s
    ${total_ca_lv}      Get Length    ${list_ten_ca}
    ${result_luong_ngay_nghi}     Run Keyword If     ${input_luong_ngaynghi}>1000    Set Variable    ${input_luong_ngaynghi}    ELSE    Convert % discount to VND and round    ${input_luong_ngaynghi}    ${input_luong_theo_ca}
    ${result_luong_ngay_le}     Run Keyword If     ${input_luong_ngayle}>1000    Set Variable    ${input_luong_ngayle}    ELSE    Convert % discount to VND and round    ${input_luong_ngayle}    ${input_luong_theo_ca}
    ${result_luong_chinh}     Run Keyword If    ${result_luong_ngay_le}>${result_luong_ngay_nghi}   Multiplication and round    ${total_ca_lv}    ${result_luong_ngay_le}   ELSE    Multiplication and round    ${total_ca_lv}    ${result_luong_ngay_nghi}
    Log    tinh luong OT
    ${list_luong_ot_tren_gio}      Create List
    :FOR      ${item_ten_ca}      IN ZIP      ${list_ten_ca}
    \     ${input_gio_vao}    ${input_gio_ra}       Get shift infor thr API     ${item_ten_ca}    ${get_branch_id}
    \     ${total_gio_lv}     Subtract Time From Time     ${input_gio_ra}       ${input_gio_vao}
    \     ${total_gio_lv}     Devision    ${total_gio_lv}    60
    \     ${luong_tren_gio}     Devision    ${input_luong_theo_ca}    ${total_gio_lv}
    \     ${luong_tren_gio_ot}    Run Keyword If    ${input_luong_ot}>1000    Set Variable    ${input_luong_ot}    ELSE    Convert % discount to VND    ${luong_tren_gio}    ${input_luong_ot}
    \     Append To List      ${list_luong_ot_tren_gio}    ${luong_tren_gio_ot}
    Log    ${list_luong_ot_tren_gio}
    ${list_luong_ot}    Create List
    :FOR    ${item_di_som}      ${item_ve_muon}   ${item_luong_theo_gio}   IN ZIP      ${list_di_som}      ${list_ve_muon}    ${list_luong_ot_tren_gio}
    \     ${thoigian_ot}      Sum    ${item_di_som}      ${item_ve_muon}
    \     ${gio_ot}     Devision    ${thoigian_ot}    60
    \     ${luong_ot}     Multiplication and round    ${gio_ot}    ${item_luong_theo_gio}
    \     Append To List    ${list_luong_ot}    ${luong_ot}
    log     ${list_luong_ot}
    ${result_luong_ot}      Sum values in list    ${list_luong_ot}
    ${result_cantra}      Sum    ${result_luong_chinh}    ${result_luong_ot}
    #
    ${get_ma_phieu_luong}     Get pay slip by employee thr API    ${input_ma_nv}
    ${get_trangthai}   ${get_luongchinh}     ${get_hoahong}    ${get_lamthem}    ${get_phucap}   ${get_giamtru}    ${get_datra}    ${get_cantra}   ${get_thuong}   Get pay sheet infor by pay sheet code      ${ma_bang_luong}   ${get_ma_phieu_luong}   ${get_branch_id}
    Should Be Equal As Numbers    ${get_trangthai}     2
    Should Be Equal As Numbers    ${get_lamthem}     ${result_luong_ot}
    Should Be Equal As Numbers    ${get_luongchinh}     ${result_luong_chinh}
    Should Be Equal As Numbers    ${get_cantra}     ${result_cantra}
    Should Be Equal As Numbers    ${get_datra}     0
    #
    Delete pay sheet thr API    ${ma_bang_luong}    ${get_branch_id}
    Delete clocking thr API    ${get_clocking_id}    ${get_branch_id}
    Update working day for branch    ${input_branch}    ${get_branch_id}    none
    Delete employee thr API    ${input_ma_nv}
