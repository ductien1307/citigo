*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}      ${headless_browser}
Test Setup        Before Test Bang tinh luong and switch branch    Nhánh B
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
@{list_phucap}      Ăn trưa      Xăng xe      Độc hại
@{list_gtri_phucap}      30000     70000        10
@{list_apdg_phucap}      yes      no        no
@{list_ca1}      ca 1
@{list_gt}      Đi muộn     Không mặc đồng phục     Vi phạm kỷ luật
@{list_gt_gr}      3000      6000   5
@{list_apdung_gt}      yes    no    no
@{list_gio_dimuon}      15    20
@{list_absent}      yes      no

*** Test Cases ***
Lam 2 ca 1 ngày -phụ cấp      [Tags]      BTL     TS1
                              [Template]               ebcc7
                              Nhánh B     NV0014          40000     ${list_phucap}    ${list_gtri_phucap}    ${list_apdg_phucap}    ${list_ca}

Lam 2 ngày -phụ cấp           [Tags]      BTL     TS1
                              [Template]              ebcc8
                              Nhánh B     NV0015          40000     ${list_phucap}    ${list_gtri_phucap}    ${list_apdg_phucap}    ${list_ca1}

Lam 2 ca 1 ngày - giảm trừ    [Tags]     BTL      TS1
                              [Template]               ebcc9
                              Nhánh B     NV0016          40000     ${list_gt}    ${list_gt_gr}    ${list_apdung_gt}    ${list_ca}         ${list_gio_dimuon}

Nghi lam                      [Tags]      BTL     TS1
                              [Template]              ebcc6
                              Nhánh B     ${list_absent}    NV0003          45000     ${list_ca}


*** Keywords ***
ebcc7
    [Arguments]     ${input_branch}     ${input_ma_nv}    ${input_luong_theo_ca}     ${list_ten_phu_cap}    ${list_giatri_phucap}    ${list_apdung_phucap}    ${list_ten_ca}
    Set Selenium Speed    0.1
    ${get_branch_id}      Get BranchID by BranchName    ${input_branch}
    ${get_nv_id}      Get employee id thr API    ${input_ma_nv}
    Run Keyword If    ${get_nv_id}==0      Log    Ignore       ELSE      Delete employee thr API    ${input_ma_nv}
    Add employee and set salary by shift and allowance thr API      ${input_ma_nv}    Hằng    ${input_branch}     ${input_luong_theo_ca}    200     300      ${list_ten_phu_cap}    ${list_giatri_phucap}    ${list_apdung_phucap}
    :FOR      ${item_ten_ca}       IN ZIP       ${list_ten_ca}
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
    ${result_luong_chinh}     Multiplication and round    ${total_ca_lv}    ${input_luong_theo_ca}
    ${result_phu_cap}     Set Variable    0
    :FOR      ${item_giatri_phucap}        IN ZIP         ${list_gtri_phucap}
    \       ${phu_cap}     Run Keyword If    ${item_giatri_phucap}>1000    Set Variable    ${item_giatri_phucap}    ELSE    Convert % discount to VND    ${result_luong_chinh}    ${item_giatri_phucap}
    \       ${result_phu_cap}     Sum    ${result_phu_cap}    ${phu_cap}
    Log    ${result_phu_cap}
    ${result_cantra}    Sum    ${result_luong_chinh}    ${result_phu_cap}
    ${get_ma_phieu_luong}     Get pay slip by employee thr API    ${input_ma_nv}
    ${get_trangthai}   ${get_luongchinh}     ${get_hoahong}    ${get_lamthem}    ${get_phucap}   ${get_giamtru}    ${get_datra}    ${get_cantra}   ${get_thuong}   Get pay sheet infor by pay sheet code      ${ma_bang_luong}   ${get_ma_phieu_luong}   ${get_branch_id}
    Should Be Equal As Numbers    ${get_trangthai}     2
    Should Be Equal As Numbers    ${get_phucap}     ${result_phu_cap}
    Should Be Equal As Numbers    ${get_luongchinh}     ${result_luong_chinh}
    Should Be Equal As Numbers    ${get_cantra}     ${result_cantra}
    Should Be Equal As Numbers    ${get_datra}     0
    Delete pay sheet thr API    ${ma_bang_luong}    ${get_branch_id}
    Delete clocking thr API    ${get_clocking_id}    ${get_branch_id}
    Delete employee thr API    ${input_ma_nv}

ebcc8
    [Arguments]     ${input_branch}     ${input_ma_nv}    ${input_luong_theo_ca}     ${list_ten_phu_cap}    ${list_giatri_phucap}    ${list_apdung_phucap}    ${list_ten_ca}
    Set Selenium Speed    0.1
    ${get_branch_id}      Get BranchID by BranchName    ${input_branch}
    ${get_nv_id}      Get employee id thr API    ${input_ma_nv}
    Run Keyword If    ${get_nv_id}==0      Log    Ignore       ELSE      Delete employee thr API    ${input_ma_nv}
    Add employee and set salary by shift and allowance thr API      ${input_ma_nv}    Hằng    ${input_branch}     ${input_luong_theo_ca}    200     300      ${list_ten_phu_cap}    ${list_giatri_phucap}    ${list_apdung_phucap}
    :FOR        ${item_ten_ca}      IN ZIP       ${list_ten_ca}
    \   ${get_clocking_id}   ${get_timesheet_id}    Add schedule work not repeat for one employee thr API    ${item_ten_ca}   ${input_branch}    ${input_ma_nv}
    \   Update not timekeeping to timekeeping thr API     ${input_branch}    ${item_ten_ca}     ${input_ma_nv}      ${get_clocking_id}   ${get_timesheet_id}
    ${get_day}    Get Current Date
    ${get_day_bf}      Subtract Time From Date    ${get_day}    1 day    result_format=%Y-%m-%d
    :FOR      ${item_ten_ca}        IN ZIP       ${list_ten_ca}
    \   ${get_clocking_id}   ${get_timesheet_id}    Add schedule work not repeat for one employee by day thr API    ${get_day_bf}     ${item_ten_ca}   ${input_branch}    ${input_ma_nv}
    \   Update not timekeeping to timekeeping by day thr API        ${input_branch}  ${get_day_bf}    ${item_ten_ca}     ${input_ma_nv}       ${get_clocking_id}   ${get_timesheet_id}
    Reload page
    ${get_cur_day}     Get Current Date
    Add new pay sheet and input pay period      ${get_cur_day}
    ${ma_bang_luong}      Generate code automatically    BL
    Input data        ${textbox_mabangluong}      ${ma_bang_luong}
    Click element     ${button_chotluong}
    Create pay sheet success validation    ${ma_bang_luong}
    Sleep    2s
    ${total_ca_lv}      Get Length    ${list_ten_ca}
    ${total_ca_lv}    Multiplication    ${total_ca_lv}    2
    ${result_luong_chinh}     Multiplication and round    ${total_ca_lv}    ${input_luong_theo_ca}
    ${result_phu_cap}     Set Variable    0
    :FOR      ${item_giatri_phucap}     ${item_apdung_phucap}       IN ZIP         ${list_giatri_phucap}      ${list_apdung_phucap}
    \       ${phu_cap}     Run Keyword If    ${item_giatri_phucap}>1000 and '${item_apdung_phucap}'=='no'    Set Variable    ${item_giatri_phucap}      ELSE IF   ${item_giatri_phucap}>1000 and '${item_apdung_phucap}'=='yes'     Multiplication      ${item_giatri_phucap}    2   ELSE    Convert % discount to VND    ${result_luong_chinh}    ${item_giatri_phucap}
    \       ${result_phu_cap}     Sum    ${result_phu_cap}    ${phu_cap}
    Log    ${result_phu_cap}
    ${result_cantra}    Sum    ${result_luong_chinh}    ${result_phu_cap}
    ${get_ma_phieu_luong}     Get pay slip by employee thr API    ${input_ma_nv}
    ${get_trangthai}   ${get_luongchinh}     ${get_hoahong}    ${get_lamthem}    ${get_phucap}   ${get_giamtru}    ${get_datra}    ${get_cantra}   ${get_thuong}   Get pay sheet infor by pay sheet code      ${ma_bang_luong}   ${get_ma_phieu_luong}   ${get_branch_id}
    Should Be Equal As Numbers    ${get_trangthai}     2
    Should Be Equal As Numbers    ${get_phucap}     ${result_phu_cap}
    Should Be Equal As Numbers    ${get_luongchinh}     ${result_luong_chinh}
    Should Be Equal As Numbers    ${get_cantra}     ${result_cantra}
    Should Be Equal As Numbers    ${get_datra}     0
    Delete pay sheet thr API    ${ma_bang_luong}    ${get_branch_id}
    Delete clocking thr API    ${get_clocking_id}    ${get_branch_id}
    Delete employee thr API    ${input_ma_nv}

ebcc9
    [Arguments]     ${input_branch}     ${input_ma_nv}    ${input_luong_theo_ca}     ${list_ten_giam_tru}    ${list_giatri_giamtru}    ${list_apdung_giamtru}    ${list_ten_ca}      ${list_di_muon}
    Set Selenium Speed    0.1
    ${get_branch_id}      Get BranchID by BranchName    ${input_branch}
    ${get_nv_id}      Get employee id thr API    ${input_ma_nv}
    Run Keyword If    ${get_nv_id}==0      Log    Ignore       ELSE      Delete employee thr API    ${input_ma_nv}
    Add employee and set salary by shift and deduction thr API      ${input_ma_nv}    Hằng    ${input_branch}     ${input_luong_theo_ca}    200     300      ${list_ten_giam_tru}    ${list_giatri_giamtru}    ${list_apdung_giamtru}
    :FOR      ${item_ten_ca}        ${item_di_muon}      IN ZIP       ${list_ten_ca}       ${list_di_muon}
    \   ${get_clocking_id}   ${get_timesheet_id}    Add schedule work not repeat for one employee thr API    ${item_ten_ca}   ${input_branch}    ${input_ma_nv}
    \   Update not timekeeping to late timekeeping thr API       ${input_branch}    ${item_ten_ca}     ${input_ma_nv}      ${item_di_muon}    ${get_clocking_id}   ${get_timesheet_id}
    Reload page
    ${get_cur_day}     Get Current Date
    Add new pay sheet and input pay period      ${get_cur_day}
    ${ma_bang_luong}      Generate code automatically    BL
    Input data        ${textbox_mabangluong}      ${ma_bang_luong}
    Click element     ${button_chotluong}
    Create pay sheet success validation    ${ma_bang_luong}
    Sleep    2s
    ${total_ca_lv}      Get Length    ${list_ten_ca}
    ${result_luong_chinh}     Multiplication and round    ${total_ca_lv}    ${input_luong_theo_ca}
    ${result_giam_tru}     Set Variable    0
    :FOR      ${item_giatri_giamtru}    ${item_apdung_giamtru}       IN ZIP         ${list_giatri_giamtru}      ${list_apdung_giamtru}
    \       ${giam_tru}     Run Keyword If    ${item_giatri_giamtru}>100 and '${item_apdung_giamtru}'=='no'   Set Variable    ${item_giatri_giamtru}   ELSE IF   ${item_giatri_giamtru}>100 and '${item_apdung_giamtru}'=='yes'     Multiplication    ${item_giatri_giamtru}    ${total_ca_lv}    ELSE    Convert % discount to VND    ${result_luong_chinh}    ${item_giatri_giamtru}
    \       ${result_giam_tru}     Sum    ${result_giam_tru}    ${giam_tru}
    Log    ${result_giam_tru}
    ${result_cantra}    Minus      ${result_luong_chinh}    ${result_giam_tru}
    ${get_ma_phieu_luong}     Get pay slip by employee thr API    ${input_ma_nv}
    ${get_trangthai}   ${get_luongchinh}     ${get_hoahong}    ${get_lamthem}    ${get_phucap}   ${get_giamtru}    ${get_datra}    ${get_cantra}   ${get_thuong}   Get pay sheet infor by pay sheet code      ${ma_bang_luong}   ${get_ma_phieu_luong}   ${get_branch_id}
    Should Be Equal As Numbers    ${get_trangthai}     2
    Should Be Equal As Numbers    ${get_luongchinh}     ${result_luong_chinh}
    Should Be Equal As Numbers    ${get_giamtru}     ${result_giam_tru}
    Should Be Equal As Numbers    ${get_cantra}     ${result_cantra}
    Should Be Equal As Numbers    ${get_datra}     0
    Delete pay sheet thr API    ${ma_bang_luong}    ${get_branch_id}
    Delete clocking thr API    ${get_clocking_id}    ${get_branch_id}
    Delete employee thr API    ${input_ma_nv}

ebcc6
    [Arguments]      ${input_branch}   ${list_nghi_phep}       ${input_ma_nv}    ${input_luong_theo_ca}    ${list_ten_ca}
    Set Selenium Speed    0.1
    ${get_branch_id}      Get BranchID by BranchName    ${input_branch}
    ${get_nv_id}      Get employee id thr API    ${input_ma_nv}
    Run Keyword If    ${get_nv_id}==0      Log    Ignore       ELSE      Delete employee thr API    ${input_ma_nv}
    Add employee and set salary by shift thr API       ${input_ma_nv}    Minh    ${input_branch}     ${input_luong_theo_ca}    200     300
    :FOR      ${item_ten_ca}        ${item_nghi_phep}      IN ZIP       ${list_ten_ca}       ${list_nghi_phep}
    \   ${get_clocking_id}   ${get_timesheet_id}    Add schedule work not repeat for one employee thr API    ${item_ten_ca}   ${input_branch}    ${input_ma_nv}
    \   Update not timekeeping to absent thr API    ${item_nghi_phep}     ${input_branch}    ${item_ten_ca}     ${input_ma_nv}       ${get_clocking_id}   ${get_timesheet_id}
    Reload page
    ${get_cur_day}     Get Current Date
    Add new pay sheet and input pay period      ${get_cur_day}
    ${ma_bang_luong}      Generate code automatically    BL
    Input data        ${textbox_mabangluong}      ${ma_bang_luong}
    Click element     ${button_chotluong}
    Create pay sheet success validation    ${ma_bang_luong}
    Sleep    2s
    ${result_total_net}     Set Variable    0
    :FOR      ${item_nghi_phep}     IN ZIP      ${list_nghi_phep}
    \     ${luong_ca}     Run Keyword If    '${item_nghi_phep}'=='yes'    Set Variable    ${input_luong_theo_ca}      ELSE    Set Variable       0
    \     ${result_total_net}       Sum    ${result_total_net}    ${luong_ca}
    Log    ${result_total_net}
    ${get_ma_phieu_luong}     Get pay slip by employee thr API    ${input_ma_nv}
    ${get_total_payment}     ${get_total_need_pay}    Get total payment and total need pay by pay sheet code     ${ma_bang_luong}   ${get_ma_phieu_luong}   ${get_branch_id}
    Should Be Equal As Numbers    ${get_total_need_pay}     ${result_total_net}
    Should Be Equal As Numbers    ${get_total_payment}     0
    Delete pay sheet thr API    ${ma_bang_luong}    ${get_branch_id}
    Delete clocking thr API    ${get_clocking_id}    ${get_branch_id}
    Delete employee thr API    ${input_ma_nv}
