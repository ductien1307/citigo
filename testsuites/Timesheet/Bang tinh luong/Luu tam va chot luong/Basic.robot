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
Basic 1
      [Documentation]     1. Tạo BL1 >> Chốt lương  2. Chấm công thêm cho nhân viên   3. Tạo BL2      Ex: Dữ liệu đã chốt lương ở BL1 không vào BL2
      [Tags]    TS3
      [Template]               ebcc20
      Nhánh A      NVtest8       55000    ca 1

Basic 2
      [Documentation]     1. Tạo BL1 >> Lưu tạm   2. Tạo BL2 >> Lưu tạm   3. Chốt BL1   4. Mở cập nhật BL2     Ex: Có popup dữ liệu tính lương thay đổi >> dữ liệu đã chốt lương ở BL1 không vào BL2
      [Tags]    TS3
      [Template]               ebcc21
      Nhánh A      NVtest9        55000    ca 1

Basic 3
      [Documentation]     1. Tạo BL1, BL2 cùng kỳ làm việc    2. Chốt BL1   3. Chấm công thêm  cho nhân viên    4. Mở cập nhật BL2     Ex: - BL 2 có popup dữ liệu tính lương thay đổi>> dữ liệu tính lương ở bảng lương 2 không bao gồm dữ liệu tính lương đã chốt.ở BL1
      [Tags]    TS3
      [Template]               ebcc22
      Nhánh A      NVtest10       55000    ca 1

*** Keywords ***
ebcc20
    [Arguments]    ${input_branch}    ${input_ma_nv}    ${input_luong_theo_ca}    ${input_ten_ca}
    Set Selenium Speed    0.1
    ${get_branch_id}    Get BranchID by BranchName    ${input_branch}
    ${get_nv_id}    Get employee id thr API    ${input_ma_nv}
    Run Keyword If    ${get_nv_id}==0    Log    Ignore
    ...    ELSE    Delete employee thr API    ${input_ma_nv}
    Add employee and set salary by shift thr API    ${input_ma_nv}    Hoa    ${input_branch}    ${input_luong_theo_ca}    200    300
    Log    cham cong va tao bang luong
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
    Log    cham cong them va chot luong tiep
    ${start_date_af}    Add Time To Date      ${get_cur_day}    1 day       result_format=%Y-%m-%d
    ${get_clocking_id_af}    ${get_timesheet_id_Af}    Add schedule work not repeat for one employee by day thr API    ${start_date_af}    ${input_ten_ca}    ${input_branch}    ${input_ma_nv}
    Update not timekeeping to timekeeping by day thr API      ${input_branch}      ${start_date_af}     ${input_ten_ca}    ${input_ma_nv}     ${get_clocking_id_af}
    ...    ${get_timesheet_id_Af}
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
    Should Be Equal As Numbers    ${get_total_need_pay}    ${input_luong_theo_ca}
    Should Be Equal As Numbers    ${get_total_payment}    0
    Delete pay sheet thr API    ${ma_bang_luong}    ${get_branch_id}
    Delete clocking thr API    ${get_clocking_id}    ${get_branch_id}
    Delete pay sheet thr API    ${ma_bang_luong_2}    ${get_branch_id}
    Delete clocking thr API    ${get_clocking_id_af}    ${get_branch_id}
    Delete employee thr API    ${input_ma_nv}


ebcc21
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
    ${get_kyhan_bd}     Subtract Time From Date    ${get_cur_day}    3 days     result_format=%d/%m/%Y
    ${get_kyhan_kt}     Add Time To Date       ${get_cur_day}    3 days     result_format=%d/%m/%Y
    ${ten_bang_luong}     Format String     Bảng lương {0} - {1}      ${get_kyhan_bd}     ${get_kyhan_kt}
    Add new pay sheet and input pay period    ${get_cur_day}
    ${ma_bang_luong}    Generate code automatically    BL
    Input data    ${textbox_mabangluong}    ${ma_bang_luong}
    Click element     ${button_luutam_bangluong}
    Update pay sheet success validation    ${ten_bang_luong}
    ${get_ma_phieu_luong}    Get pay slip by employee thr API    ${input_ma_nv}
    #
    Reload Page
    Add new pay sheet and input pay period    ${get_cur_day}
    ${ma_bang_luong_2}    Generate code automatically    BL2
    Input data    ${textbox_mabangluong}    ${ma_bang_luong_2}
    Click element    ${button_luutam_bangluong}
    Update pay sheet success validation    ${ten_bang_luong}
    ${get_ma_phieu_luong_2}    Get pay slip by employee thr API    ${input_ma_nv}
    #
    Reload Page
    Search pay sheet and click button update    ${ma_bang_luong}
    Wait Until Page Contains Element    ${button_chotluong}   20s
    Click element    ${button_chotluong}
    Create pay sheet success validation    ${ma_bang_luong}
    ${get_total_payment}    ${get_total_need_pay}    Get total payment and total need pay by pay sheet code    ${ma_bang_luong}    ${get_ma_phieu_luong}    ${get_branch_id}
    Should Be Equal As Numbers    ${get_total_need_pay}    ${input_luong_theo_ca}
    Should Be Equal As Numbers    ${get_total_payment}     0
    #
    Reload Page
    Search pay sheet and click button update    ${ma_bang_luong_2}
    Wait Until Page Contains Element    ${button_dongy_thaydoi_bangluong}   30s
    Click Element      ${button_dongy_thaydoi_bangluong}
    Click element    ${button_chotluong}
    Create pay sheet success validation    ${ma_bang_luong_2}
    ${get_total_payment}    ${get_total_need_pay}    Get total payment and total need pay by pay sheet code    ${ma_bang_luong_2}    ${get_ma_phieu_luong_2}    ${get_branch_id}
    Should Be Equal As Numbers    ${get_total_need_pay}    0
    Should Be Equal As Numbers    ${get_total_payment}    0
    Delete pay sheet thr API    ${ma_bang_luong}    ${get_branch_id}
    Delete clocking thr API    ${get_clocking_id}    ${get_branch_id}
    Delete pay sheet thr API    ${ma_bang_luong_2}    ${get_branch_id}
    Delete employee thr API    ${input_ma_nv}

ebcc22
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
    ${get_kyhan_bd}     Subtract Time From Date    ${get_cur_day}    3 days     result_format=%d/%m/%Y
    ${get_kyhan_kt}     Add Time To Date       ${get_cur_day}    3 days     result_format=%d/%m/%Y
    ${ten_bang_luong}     Format String     Bảng lương {0} - {1}      ${get_kyhan_bd}     ${get_kyhan_kt}
    Add new pay sheet and input pay period    ${get_cur_day}
    ${ma_bang_luong}    Generate code automatically    BL
    Input data    ${textbox_mabangluong}    ${ma_bang_luong}
    Click element     ${button_luutam_bangluong}
    Update pay sheet success validation    ${ten_bang_luong}
    ${get_ma_phieu_luong}    Get pay slip by employee thr API    ${input_ma_nv}
    #
    Reload Page
    Add new pay sheet and input pay period    ${get_cur_day}
    ${ma_bang_luong_2}    Generate code automatically    BL2
    Input data    ${textbox_mabangluong}    ${ma_bang_luong_2}
    Click element    ${button_luutam_bangluong}
    Update pay sheet success validation    ${ten_bang_luong}
    ${get_ma_phieu_luong_2}    Get pay slip by employee thr API    ${input_ma_nv}
    #
    Reload Page
    Search pay sheet and click button update    ${ma_bang_luong}
    Wait Until Page Contains Element    ${button_chotluong}   20s
    Click element    ${button_chotluong}
    Create pay sheet success validation    ${ma_bang_luong}
    ${get_total_payment}    ${get_total_need_pay}    Get total payment and total need pay by pay sheet code    ${ma_bang_luong}    ${get_ma_phieu_luong}    ${get_branch_id}
    Should Be Equal As Numbers    ${get_total_need_pay}    ${input_luong_theo_ca}
    Should Be Equal As Numbers    ${get_total_payment}     0
    #
    Log    cham cong them va chot luong tiep
    ${start_date_af}    Add Time To Date      ${get_cur_day}    1 day       result_format=%Y-%m-%d
    ${get_clocking_id_af}    ${get_timesheet_id_Af}    Add schedule work not repeat for one employee by day thr API    ${start_date_af}    ${input_ten_ca}    ${input_branch}    ${input_ma_nv}
    Update not timekeeping to timekeeping by day thr API      ${input_branch}      ${start_date_af}     ${input_ten_ca}    ${input_ma_nv}     ${get_clocking_id_af}
    ...    ${get_timesheet_id_Af}
    Reload Page
    Search pay sheet and click button update    ${ma_bang_luong_2}
    Wait Until Page Contains Element    ${button_dongy_thaydoi_bangluong}   30s
    Click Element      ${button_dongy_thaydoi_bangluong}
    Click element    ${button_chotluong}
    Create pay sheet success validation    ${ma_bang_luong_2}
    ${get_total_payment}    ${get_total_need_pay}    Get total payment and total need pay by pay sheet code    ${ma_bang_luong_2}    ${get_ma_phieu_luong_2}    ${get_branch_id}
    Should Be Equal As Numbers    ${get_total_need_pay}    ${input_luong_theo_ca}
    Should Be Equal As Numbers    ${get_total_payment}    0
    Delete pay sheet thr API    ${ma_bang_luong}    ${get_branch_id}
    Delete clocking thr API    ${get_clocking_id}    ${get_branch_id}
    Delete pay sheet thr API    ${ma_bang_luong_2}    ${get_branch_id}
    Delete clocking thr API    ${get_clocking_id_af}    ${get_branch_id}
    Delete employee thr API    ${input_ma_nv}
