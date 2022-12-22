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
Theo gio        [Tags]      TS3
                [Template]               ebcc17
                Nhánh B     NVtest5          40000     ${list_phucap}    ${list_gtri_phucap}    ${list_apdg_phucap}   ${list_gt}    ${list_gt_gr}    ${list_apdung_gt}    ${list_ca}     ${list_gio_dimuon}

Co dinh         [Tags]      TS3
                [Template]               ebcc18
                Nhánh B     NVtest6          40000     ${list_phucap}    ${list_gtri_phucap}    ${list_apdg_phucap}   ${list_gt}    ${list_gt_gr}    ${list_apdung_gt}    ${list_ca}     ${list_gio_dimuon}

Ngay cong       [Tags]      TS3
                [Template]               ebcc19
                Nhánh B     NVtest7          200000     150     200   300     ${list_phucap}    ${list_gtri_phucap}    ${list_apdg_phucap}   ${list_gt}    ${list_gt_gr}    ${list_apdung_gt}    ca 1     30    60        20         90

*** Keywords ***
ebcc17
    [Arguments]     ${input_branch}     ${input_ma_nv}    ${input_luong_theo_gio}     ${list_ten_phu_cap}    ${list_giatri_phucap}    ${list_apdung_phucap}    ${list_ten_giam_tru}    ${list_giatri_giamtru}    ${list_apdung_giamtru}  ${list_ten_ca}   ${list_di_muon}
    Set Selenium Speed    0.1
    ${get_branch_id}      Get BranchID by BranchName    ${input_branch}
    ${get_nv_id}      Get employee id thr API    ${input_ma_nv}
    Run Keyword If    ${get_nv_id}==0      Log    Ignore       ELSE      Delete employee thr API    ${input_ma_nv}
    Add employee and set salary by the working hour thr API      ${input_ma_nv}    Hằng    ${input_branch}     ${input_luong_theo_gio}    200     300      ${list_ten_phu_cap}    ${list_giatri_phucap}    ${list_apdung_phucap}    ${list_ten_giam_tru}    ${list_giatri_giamtru}    ${list_apdung_giamtru}
    :FOR      ${item_ten_ca}        ${item_di_muon}      IN ZIP       ${list_ten_ca}       ${list_di_muon}
    \    ${get_clocking_id}   ${get_timesheet_id}    Add schedule work not repeat for one employee thr API    ${item_ten_ca}   ${input_branch}    ${input_ma_nv}
    \    Update not timekeeping to late timekeeping thr API       ${input_branch}    ${item_ten_ca}     ${input_ma_nv}      ${item_di_muon}    ${get_clocking_id}   ${get_timesheet_id}
    Reload page
    ${get_cur_day}     Get Current Date
    Add new pay sheet and input pay period      ${get_cur_day}
    ${ma_bang_luong}      Generate code automatically    BL
    Input data        ${textbox_mabangluong}      ${ma_bang_luong}
    Click element     ${button_chotluong}
    Create pay sheet success validation    ${ma_bang_luong}
    Sleep    2s
    Log    tinh lương chính
    ${total_ca_lv}    Get Length    ${list_ten_ca}
    ${list_gio_lv}    Create List
    :FOR      ${item_ten_ca}     ${item_di_muon}     IN ZIP      ${list_ten_ca}     ${list_di_muon}
    \     ${input_gio_vao}    ${input_gio_ra}       Get shift infor thr API     ${item_ten_ca}    ${get_branch_id}
    \     ${total_gio_lv}      Subtract Time From Time    ${input_gio_ra}   ${input_gio_vao}
    \     ${total_gio_lv_thuc_te}   Minus    ${total_gio_lv}    ${item_di_muon}
    \     ${total_gio_lv_thuc_te}   Devision    ${total_gio_lv_thuc_te}    60
    \     ${total_gio_lv_thuc_te}     Evaluate    round(${total_gio_lv_thuc_te},2)
    \     Append To List    ${list_gio_lv}    ${total_gio_lv_thuc_te}
    ${result_gio_lv_thuc_te}     Sum values in list    ${list_gio_lv}
    ${result_luong_chinh}     Multiplication and round    ${result_gio_lv_thuc_te}    ${input_luong_theo_gio}
    #
    Log    tính phụ cấp
    ${result_phu_cap}     Set Variable    0
    :FOR      ${item_giatri_phucap}        IN ZIP         ${list_gtri_phucap}
    \       ${phu_cap}     Run Keyword If    ${item_giatri_phucap}>1000    Set Variable    ${item_giatri_phucap}    ELSE    Convert % discount to VND    ${result_luong_chinh}    ${item_giatri_phucap}
    \       ${result_phu_cap}     Sum    ${result_phu_cap}    ${phu_cap}
    \       ${result_phu_cap}     Evaluate    round(${result_phu_cap},0)
    Log    ${result_phu_cap}
    ${result_thu_nhap}    Sum    ${result_luong_chinh}    ${result_phu_cap}
    #
    Log    tính giảm trừ
    ${result_giam_tru}     Set Variable    0
    :FOR      ${item_giatri_giamtru}    ${item_apdung_giamtru}       IN ZIP         ${list_giatri_giamtru}      ${list_apdung_giamtru}
    \       ${giam_tru}     Run Keyword If    ${item_giatri_giamtru}>100 and '${item_apdung_giamtru}'=='no'   Set Variable    ${item_giatri_giamtru}   ELSE IF   ${item_giatri_giamtru}>100 and '${item_apdung_giamtru}'=='yes'     Multiplication    ${item_giatri_giamtru}    ${total_ca_lv}    ELSE    Convert % discount to VND    ${result_thu_nhap}    ${item_giatri_giamtru}
    \       ${result_giam_tru}     Sum    ${result_giam_tru}    ${giam_tru}
    \       ${result_giam_tru}     Evaluate    round(${result_giam_tru},0)
    Log    ${result_giam_tru}
    #
    Log    tính cần trả
    ${result_cantra}    Minus    ${result_thu_nhap}    ${result_giam_tru}
    Log    validate
    #
    ${get_ma_phieu_luong}     Get pay slip by employee thr API    ${input_ma_nv}
    ${get_trangthai}   ${get_luongchinh}     ${get_hoahong}    ${get_lamthem}    ${get_phucap}   ${get_giamtru}    ${get_datra}    ${get_cantra}   ${get_thuong}   Get pay sheet infor by pay sheet code      ${ma_bang_luong}   ${get_ma_phieu_luong}   ${get_branch_id}
    Should Be Equal As Numbers    ${get_trangthai}     2
    Should Be Equal As Numbers    ${get_phucap}     ${result_phu_cap}
    Should Be Equal As Numbers    ${get_giamtru}     ${result_giam_tru}
    Should Be Equal As Numbers    ${get_luongchinh}     ${result_luong_chinh}
    Should Be Equal As Numbers    ${get_cantra}     ${result_cantra}
    Should Be Equal As Numbers    ${get_datra}     0
    #
    Delete pay sheet thr API    ${ma_bang_luong}    ${get_branch_id}
    Delete clocking thr API    ${get_clocking_id}    ${get_branch_id}
    Delete employee thr API    ${input_ma_nv}

ebcc18
    [Arguments]     ${input_branch}     ${input_ma_nv}    ${input_luong_codinh}     ${list_ten_phu_cap}    ${list_giatri_phucap}    ${list_apdung_phucap}    ${list_ten_giam_tru}    ${list_giatri_giamtru}    ${list_apdung_giamtru}  ${list_ten_ca}   ${list_di_muon}
    Set Selenium Speed    0.1
    ${get_branch_id}      Get BranchID by BranchName    ${input_branch}
    ${get_nv_id}      Get employee id thr API    ${input_ma_nv}
    Run Keyword If    ${get_nv_id}==0      Log    Ignore       ELSE      Delete employee thr API    ${input_ma_nv}
    Add employee and set salary fixed by the working hour thr API      ${input_ma_nv}    Hằng    ${input_branch}     ${input_luong_codinh}       ${list_ten_phu_cap}    ${list_giatri_phucap}    ${list_apdung_phucap}    ${list_ten_giam_tru}    ${list_giatri_giamtru}    ${list_apdung_giamtru}
    :FOR      ${item_ten_ca}        ${item_di_muon}      IN ZIP       ${list_ten_ca}       ${list_di_muon}
    \    ${get_clocking_id}   ${get_timesheet_id}    Add schedule work not repeat for one employee thr API    ${item_ten_ca}   ${input_branch}    ${input_ma_nv}
    \    Update not timekeeping to late timekeeping thr API       ${input_branch}    ${item_ten_ca}     ${input_ma_nv}      ${item_di_muon}    ${get_clocking_id}   ${get_timesheet_id}
    Reload page
    ${get_cur_day}     Get Current Date
    Add new pay sheet and input pay period      ${get_cur_day}
    ${ma_bang_luong}      Generate code automatically    BL
    Input data        ${textbox_mabangluong}      ${ma_bang_luong}
    Click element     ${button_chotluong}
    Create pay sheet success validation    ${ma_bang_luong}
    Sleep    2s
    Log    tinh lương chính
    ${total_ca_lv}    Get Length    ${list_ten_ca}
    ${result_luong_chinh}     Set Variable    ${input_luong_codinh}
    #
    Log    tính phụ cấp
    ${result_phu_cap}     Set Variable    0
    :FOR      ${item_giatri_phucap}        IN ZIP         ${list_gtri_phucap}
    \       ${phu_cap}     Run Keyword If    ${item_giatri_phucap}>1000    Set Variable    ${item_giatri_phucap}    ELSE    Convert % discount to VND    ${result_luong_chinh}    ${item_giatri_phucap}
    \       ${result_phu_cap}     Sum    ${result_phu_cap}    ${phu_cap}
    \       ${result_phu_cap}     Evaluate    round(${result_phu_cap},0)
    Log    ${result_phu_cap}
    ${result_thu_nhap}    Sum    ${result_luong_chinh}    ${result_phu_cap}
    #
    Log    tính giảm trừ
    ${result_giam_tru}     Set Variable    0
    :FOR      ${item_giatri_giamtru}    ${item_apdung_giamtru}       IN ZIP         ${list_giatri_giamtru}      ${list_apdung_giamtru}
    \       ${giam_tru}     Run Keyword If    ${item_giatri_giamtru}>100 and '${item_apdung_giamtru}'=='no'   Set Variable    ${item_giatri_giamtru}   ELSE IF   ${item_giatri_giamtru}>100 and '${item_apdung_giamtru}'=='yes'     Multiplication    ${item_giatri_giamtru}    ${total_ca_lv}    ELSE    Convert % discount to VND    ${result_thu_nhap}    ${item_giatri_giamtru}
    \       ${result_giam_tru}     Sum    ${result_giam_tru}    ${giam_tru}
    \       ${result_giam_tru}     Evaluate    round(${result_giam_tru},0)
    Log    ${result_giam_tru}
    #
    Log    tính cần trả
    ${result_cantra}    Minus    ${result_thu_nhap}    ${result_giam_tru}
    Log    validate
    #
    ${get_ma_phieu_luong}     Get pay slip by employee thr API    ${input_ma_nv}
    ${get_trangthai}   ${get_luongchinh}     ${get_hoahong}    ${get_lamthem}    ${get_phucap}   ${get_giamtru}    ${get_datra}    ${get_cantra}   ${get_thuong}   Get pay sheet infor by pay sheet code      ${ma_bang_luong}   ${get_ma_phieu_luong}   ${get_branch_id}
    Should Be Equal As Numbers    ${get_trangthai}     2
    Should Be Equal As Numbers    ${get_phucap}     ${result_phu_cap}
    Should Be Equal As Numbers    ${get_giamtru}     ${result_giam_tru}
    Should Be Equal As Numbers    ${get_luongchinh}     ${result_luong_chinh}
    Should Be Equal As Numbers    ${get_cantra}     ${result_cantra}
    Should Be Equal As Numbers    ${get_datra}     0
    #
    Delete pay sheet thr API    ${ma_bang_luong}    ${get_branch_id}
    Delete clocking thr API    ${get_clocking_id}    ${get_branch_id}
    Delete employee thr API    ${input_ma_nv}

ebcc19
    [Arguments]     ${input_branch}     ${input_ma_nv}    ${input_mucluong_theoky}    ${input_luong_ot_ngaythuong}   ${input_luong_ot_ngaynghi}     ${input_luong_ot_ngayle}       ${list_ten_phu_cap}    ${list_giatri_phucap}    ${list_apdung_phucap}    ${list_ten_giam_tru}    ${list_giatri_giamtru}    ${list_apdung_giamtru}  ${input_ten_ca}   ${input_di_muon}    ${input_ve_muon}    ${input_di_muon1}    ${input_ve_muon1}
    Set Selenium Speed    0.1
    ${get_branch_id}      Get BranchID by BranchName    ${input_branch}
    ${get_nv_id}      Get employee id thr API    ${input_ma_nv}
    Run Keyword If    ${get_nv_id}==0      Log    Ignore       ELSE      Delete employee thr API    ${input_ma_nv}
    Add employee and set salary by standard day thr API     ${input_ma_nv}    Hằng    ${input_branch}     ${input_mucluong_theoky}    ${input_luong_ot_ngaythuong}   ${input_luong_ot_ngaynghi}     ${input_luong_ot_ngayle}       ${list_ten_phu_cap}    ${list_giatri_phucap}    ${list_apdung_phucap}    ${list_ten_giam_tru}    ${list_giatri_giamtru}    ${list_apdung_giamtru}
    #ngay 1
    ${get_day}    Get Current Date    result_format=%Y-%m-%d
    ${get_clocking_id}   ${get_timesheet_id}    Add schedule work not repeat for one employee thr API    ${input_ten_ca}   ${input_branch}    ${input_ma_nv}
    Update not timekeeping to late timekeeping and over time by day thr API    ${input_branch}    ${get_day}    ${input_ten_ca}    ${input_ma_nv}    ${input_di_muon}     ${input_ve_muon}    ${get_clocking_id}   ${get_timesheet_id}
    #ngay 2
    ${get_day_bf}      Subtract Time From Date    ${get_day}    1 day    result_format=%Y-%m-%d
    ${get_clocking_id1}   ${get_timesheet_id1}    Add schedule work not repeat for one employee by day thr API    ${get_day_bf}     ${input_ten_ca}   ${input_branch}    ${input_ma_nv}
    Update not timekeeping to late timekeeping and over time by day thr API    ${input_branch}    ${get_day_bf}    ${input_ten_ca}    ${input_ma_nv}    ${input_di_muon1}     ${input_ve_muon1}    ${get_clocking_id1}   ${get_timesheet_id1}
    #
    Reload page
    Add new pay sheet and input pay period      ${get_day}
    ${ma_bang_luong}      Generate code automatically    BL
    Input data        ${textbox_mabangluong}      ${ma_bang_luong}
    Click element     ${button_chotluong}
    Create pay sheet success validation    ${ma_bang_luong}
    Sleep    2s
    ${luong_1_ngaycong}     Devision      ${input_mucluong_theoky}      7
    ${result_luong_chinh}   Multiplication and round       ${luong_1_ngaycong}    2
    #
    Log    tinh luong OT
    ${luong_tren_gio}    Devision    ${luong_1_ngaycong}    8
    ${luong_tren_gio}    Evaluate    round(${luong_tren_gio},2)
    ${thoigian_ot}    Sum    ${input_ve_muon}    ${input_ve_muon1}
    ${gio_ot}    Devision    ${thoigian_ot}    60
    ${result_luong_ot_trengio}    Run Keyword If    ${input_luong_ot_ngaythuong}>1000     Set Variable    ${input_luong_ot_ngaythuong}    ELSE    Convert % discount to VND and round      ${input_luong_ot_ngaythuong}    ${luong_tren_gio}
    ${result_luong_ot}    Multiplication and round    ${result_luong_ot_trengio}     ${gio_ot}
    #
    Log    tinh phu cap
    ${result_phu_cap}     Set Variable    0
    :FOR      ${item_giatri_phucap}     ${item_apdung_phucap}       IN ZIP         ${list_giatri_phucap}      ${list_apdung_phucap}
    \       ${phu_cap}     Run Keyword If    ${item_giatri_phucap}>1000 and '${item_apdung_phucap}'=='no'    Set Variable    ${item_giatri_phucap}      ELSE IF   ${item_giatri_phucap}>1000 and '${item_apdung_phucap}'=='yes'     Multiplication      ${item_giatri_phucap}    2   ELSE    Convert % discount to VND    ${result_luong_chinh}    ${item_giatri_phucap}
    \       ${result_phu_cap}     Sum    ${result_phu_cap}    ${phu_cap}
    ${result_phu_cap}     Evaluate          round(${result_phu_cap},0)
    Log    ${result_phu_cap}
    #
    ${result_thu_nhap}    Sum x 3   ${result_luong_chinh}    ${result_phu_cap}    ${result_luong_ot}
    #
    Log    tính giảm trừ
    ${result_giam_tru}     Set Variable    0
    :FOR      ${item_giatri_giamtru}    ${item_apdung_giamtru}       IN ZIP         ${list_giatri_giamtru}      ${list_apdung_giamtru}
    \       ${giam_tru}     Run Keyword If    ${item_giatri_giamtru}>100 and '${item_apdung_giamtru}'=='no'   Set Variable    ${item_giatri_giamtru}   ELSE IF   ${item_giatri_giamtru}>100 and '${item_apdung_giamtru}'=='yes'     Multiplication    ${item_giatri_giamtru}    2    ELSE    Convert % discount to VND    ${result_thu_nhap}    ${item_giatri_giamtru}
    \       ${result_giam_tru}     Sum    ${result_giam_tru}    ${giam_tru}
    \       ${result_giam_tru}     Evaluate    round(${result_giam_tru},0)
    ${result_giam_tru}     Evaluate          round(${result_giam_tru},0)
    Log    ${result_giam_tru}
    #
    Log    tính cần trả
    ${result_cantra}    Minus    ${result_thu_nhap}    ${result_giam_tru}
    Log    validate
    #
    ${get_ma_phieu_luong}     Get pay slip by employee thr API    ${input_ma_nv}
    ${get_trangthai}   ${get_luongchinh}     ${get_hoahong}    ${get_lamthem}    ${get_phucap}   ${get_giamtru}    ${get_datra}    ${get_cantra}   ${get_thuong}   Get pay sheet infor by pay sheet code      ${ma_bang_luong}   ${get_ma_phieu_luong}   ${get_branch_id}
    Should Be Equal As Numbers    ${get_trangthai}     2
    Should Be Equal As Numbers    ${get_phucap}     ${result_phu_cap}
    Should Be Equal As Numbers    ${get_giamtru}     ${result_giam_tru}
    Should Be Equal As Numbers    ${get_luongchinh}     ${result_luong_chinh}
    Should Be Equal As Numbers    ${get_lamthem}     ${result_luong_ot}
    Should Be Equal As Numbers    ${get_cantra}     ${result_cantra}
    Should Be Equal As Numbers    ${get_datra}     0
    #
    Delete pay sheet thr API    ${ma_bang_luong}    ${get_branch_id}
    Delete clocking thr API    ${get_clocking_id}    ${get_branch_id}
    Delete clocking thr API    ${get_clocking_id1}    ${get_branch_id}
    Delete employee thr API    ${input_ma_nv}
