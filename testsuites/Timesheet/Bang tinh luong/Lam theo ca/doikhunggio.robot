*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}      ${headless_browser}
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
@{list_h_di_som}      0           0        0
@{list_h_ve_muon}     0           90        0

*** Test Cases ***          Mã nv         Chi nhánh              Lương ca    Lương ngày nghỉ    Lương ngày lễ     Lương OT ngày thương    Lương OT ngày nghỉ      Lương OT ngày lễ        Ca lv         Gip bd    Gio kt   Gio bd 1     Gio kt 1      Lặp lại     List đi sớm          List đi muộn       Đi sớm      Về muộn 1
Doi khung gio lam viec
                            [Tags]         TS3
                            [Template]              ebcc15
                            NVtest1        Chi nhánh trung tâm       40000       70000             300                 60000                   120000                    150                ca 3        08:00     11:00     08:00        12:00        2 days      ${list_h_di_som}      ${list_h_ve_muon}     0          60
                            NVtest2        Chi nhánh trung tâm       50000       150               300                 120                    110000                     150                ca 3         08:00     11:00     08:00        12:00         2 days      ${list_h_di_som}      ${list_h_ve_muon}     0           60

Gio lam theo giao giua 2 loai ngay
                            [Tags]          TS3
                            [Template]              ebcc16
                            NVtest3        Chi nhánh trung tâm       50000       70000             300                 60000                   120000                    150                ca 4       0     180
                            NVtest4        Chi nhánh trung tâm       50000       200               300                 150                      250                    150                ca 4       0     180

*** Keywords ***
ebcc15
    [Arguments]     ${input_ma_nv}    ${input_branch}     ${input_luong_theo_ca}   ${input_luong_ngaynghi}      ${input_luong_ngayle}   ${input_luong_ot_ngaythuong}       ${input_luong_ot_ngaynghi}    ${input_luong_ot_ngaynle}      ${input_ten_ca}    ${input_gio_bd}     ${input_gio_kt}   ${input_gio_bd_af}     ${input_gio_kt_af}      ${repeat_end_day}   ${list_di_som}    ${list_ve_muon}     ${input_di_som_af}    ${input_ve_muon_af}
    ${get_branch_id}      Get BranchID by BranchName    ${input_branch}
    Update shift thr API    ${input_ten_ca}     ${input_gio_bd}     ${input_gio_kt}      ${input_branch}
    ${get_nv_id}      Get employee id thr API    ${input_ma_nv}
    Run Keyword If    ${get_nv_id}==0      Log    Ignore       ELSE      Delete employee thr API    ${input_ma_nv}
    Add employee and set salary by shift and over time thr API        ${input_ma_nv}    Dung    ${input_branch}     ${input_luong_theo_ca}   ${input_luong_ngaynghi}      ${input_luong_ngayle}     ${input_luong_ot_ngaythuong}       ${input_luong_ot_ngaynghi}    ${input_luong_ot_ngaynle}
    #
    Log    cham cong truoc khi doi khung gio
    ${cur_date}    Get Current Date       result_format=%Y-%m-%d
    ${end_date}    Add Time To Date      ${cur_date}    ${repeat_end_day}       result_format=%Y-%m-%d
    #
    Log    Cap nhat ngay nghi CN
    ${start_date_af}    Add Time To Date      ${end_date}    1 day       result_format=%Y-%m-%d
    ${ngay_nghi}    Convert Date    ${start_date_af}    result_format=%A
    Update working day for branch    ${input_branch}    ${get_branch_id}    ${ngay_nghi}
    #
    ${get_clocking_id}   ${get_timesheet_id}    Add schedule work repeat for one employee thr API    ${input_ten_ca}      ${input_branch}      ${input_ma_nv}    ngày    1    ${cur_date}     ${end_date}
    ${result_clocking_id}    Replace sq blackets    ${get_clocking_id}
    ${result_clocking_id}     Replace sq blackets    ${result_clocking_id}
    ${result_clocking_id}    Split String    ${result_clocking_id}    ,
    ${num_day}    Set Variable    -1
    :FOR      ${item_get_clocking}    ${item_di_som}    ${item_ve_muon}     IN ZIP      ${result_clocking_id}      ${list_di_som}    ${list_ve_muon}
    \     ${get_cur_date}   Get Current Date
    \     ${num_day}      Sum    ${num_day}   1
    \     ${add_day}      Format String     {0} days       ${num_day}
    \     ${input_day}      Add Time To Date    ${get_cur_date}     ${add_day}
    \     Update not timekeeping to timekeeping by day thr API    ${input_branch}    ${input_day}     ${input_ten_ca}    ${input_ma_nv}    ${item_get_clocking}    ${get_timesheet_id}
    \     Update not timekeeping to timekeeping and over time by day thr API    ${input_branch}    ${input_day}     ${input_ten_ca}    ${input_ma_nv}   ${item_di_som}    ${item_ve_muon}   ${item_get_clocking}    ${get_timesheet_id}
    ##
    Log    doi khung gio va cham cong
    Update shift thr API    ${input_ten_ca}     ${input_gio_bd_af}     ${input_gio_kt_af}      ${input_branch}
    ${get_clocking_id_af}   ${get_timesheet_id_af}    Add schedule work not repeat for one employee by day thr API    ${start_date_af}    ${input_ten_ca}   ${input_branch}    ${input_ma_nv}
    Update not timekeeping to timekeeping and over time by day thr API      ${input_branch}   ${start_date_af}   ${input_ten_ca}     ${input_ma_nv}     ${input_di_som_af}    ${input_ve_muon_af}    ${get_clocking_id_af}   ${get_timesheet_id_af}
    #
    Log    Tao phieu luong
    Reload page
    ${get_cur_day}     Get Current Date
    Add new pay sheet and input pay period      ${get_cur_day}
    ${ma_bang_luong}      Generate code automatically    BL
    Input data        ${textbox_mabangluong}      ${ma_bang_luong}
    Click element     ${button_chotluong}
    Create pay sheet success validation    ${ma_bang_luong}
    Sleep    2s
    Log    tinh luong OT bf doi khung gio
    ${total_ca_lv}    Get Length    ${list_di_som}
    ${result_luong_chinh_bf}    Multiplication and round    ${total_ca_lv}    ${input_luong_theo_ca}
    ${total_gio_lv}     Subtract Time From Time     ${input_gio_kt}       ${input_gio_bd}
    ${total_gio_lv_af}     Subtract Time From Time     ${input_gio_kt_af}       ${input_gio_bd_af}
    ${total_gio_lv_tb}    Evaluate    (${total_gio_lv}*${total_ca_lv}+${total_gio_lv_af})/(${total_ca_lv}+1)
    ${total_gio_lv_tb}     Devision    ${total_gio_lv_tb}    60
    ${luong_tren_gio}     Devision    ${input_luong_theo_ca}    ${total_gio_lv_tb}
    ${thoigian_ot}      Sum    ${item_di_som}      ${item_ve_muon}
    ${luong_tren_gio_ot}    Run Keyword If    ${input_luong_ot_ngaythuong}>1000    Set Variable    ${input_luong_ot_ngaythuong}    ELSE    Convert % discount to VND    ${luong_tren_gio}    ${input_luong_ot_ngaythuong}
    Log    ${luong_tren_gio_ot}
    ${list_luong_ot}    Create List
    :FOR    ${item_di_som}      ${item_ve_muon}      IN ZIP      ${list_di_som}      ${list_ve_muon}
    \     ${thoigian_ot}      Sum    ${item_di_som}      ${item_ve_muon}
    \     ${gio_ot}     Devision    ${thoigian_ot}    60
    \     ${luong_ot}     Multiplication and round    ${gio_ot}    ${luong_tren_gio_ot}
    \     Append To List    ${list_luong_ot}    ${luong_ot}
    log     ${list_luong_ot}
    ${result_luong_ot_bf}      Sum values in list    ${list_luong_ot}
    #
    Log    tinh luong OT af doi khung gio
    ${result_luong_chinh_af}     Run Keyword If    ${input_luong_ngaynghi}<1000    Convert % discount to VND     ${input_luong_theo_ca}    ${input_luong_ngaynghi}    ELSE      Set Variable    ${input_luong_ngaynghi}
    ${total_gio_lv_af}     Devision    ${total_gio_lv_af}    60
    ${luong_tren_gio_af}     Devision    ${input_luong_theo_ca}    ${total_gio_lv}
    ${luong_tren_gio_ot_af}    Run Keyword If    ${input_luong_ot_ngaynghi}>1000    Set Variable    ${input_luong_ot_ngaynghi}    ELSE    Convert % discount to VND    ${luong_tren_gio_af}    ${input_luong_ot_ngaynghi}
    Log    ${luong_tren_gio_ot_af}
    ${thoigian_ot_af}      Sum    ${input_di_som_af}      ${input_ve_muon_af}
    ${gio_ot_af}     Devision    ${thoigian_ot_af}    60
    ${result_luong_ot_af}     Multiplication and round    ${gio_ot_af}    ${luong_tren_gio_ot_af}
    log     ${result_luong_ot_af}
    ${result_luong_chinh}     Sum    ${result_luong_chinh_bf}   ${result_luong_chinh_af}
    ${result_luong_ot}      Sum    ${result_luong_ot_bf}    ${result_luong_ot_af}
    ${result_cantra}    Sum     ${result_luong_chinh}     ${result_luong_ot}
    #
    ${get_ma_phieu_luong}     Get pay slip by employee thr API    ${input_ma_nv}
    ${get_trangthai}   ${get_luongchinh}     ${get_hoahong}    ${get_lamthem}    ${get_phucap}   ${get_giamtru}    ${get_datra}    ${get_cantra}   ${get_thuong}   Get pay sheet infor by pay sheet code      ${ma_bang_luong}   ${get_ma_phieu_luong}   ${get_branch_id}
    Should Be Equal As Numbers    ${get_trangthai}     2
    Should Be Equal As Numbers    ${get_lamthem}     ${result_luong_ot}
    Should Be Equal As Numbers    ${get_luongchinh}     ${result_luong_chinh}
    Should Be Equal As Numbers    ${get_cantra}     ${result_cantra}
    Should Be Equal As Numbers    ${get_datra}     0
    #
    Update working day for branch    ${input_branch}    ${get_branch_id}    none
    Delete pay sheet thr API    ${ma_bang_luong}    ${get_branch_id}
    Delete multi clocking thr API    ${get_clocking_id}    ${get_branch_id}
    Delete clocking thr API    ${get_clocking_id_af}    ${get_branch_id}
    Delete employee thr API    ${input_ma_nv}

ebcc16
    [Arguments]      ${input_ma_nv}     ${input_branch}       ${input_luong_theo_ca}    ${input_luong_ngaynghi}    ${input_luong_ngayle}    ${input_luong_ot_ngaythuong}       ${input_luong_ot_ngaynghi}    ${input_luong_ot_ngaynle}    ${input_ten_ca}   ${input_di_som}    ${input_ve_muon}
    Set Selenium Speed    0.1
    ${get_day}      Get Current Date
    ${ngaynghi}     Add Time To Date    ${get_day}    1 day     result_format=%A
    ${get_branch_id}      Get BranchID by BranchName    ${input_branch}
    Update working day for branch    ${input_branch}    ${get_branch_id}    ${ngaynghi}
    ${get_nv_id}      Get employee id thr API    ${input_ma_nv}
    Run Keyword If    ${get_nv_id}==0      Log    Ignore       ELSE      Delete employee thr API    ${input_ma_nv}
    Add employee and set salary by shift and over time thr API        ${input_ma_nv}    Hoa    ${input_branch}     ${input_luong_theo_ca}   ${input_luong_ngaynghi}      ${input_luong_ngayle}     ${input_luong_ot_ngaythuong}       ${input_luong_ot_ngaynghi}    ${input_luong_ot_ngaynle}
    ${get_clocking_id}   ${get_timesheet_id}    Add schedule work not repeat for one employee thr API    ${input_ten_ca}   ${input_branch}    ${input_ma_nv}
    Update not timekeeping to timekeeping and over time over night thr API      ${input_branch}     ${input_ten_ca}     ${input_ma_nv}     ${input_di_som}    ${input_ve_muon}    ${get_clocking_id}   ${get_timesheet_id}
    Reload page
    ${get_cur_day}     Get Current Date
    Add new pay sheet and input pay period      ${get_cur_day}
    ${ma_bang_luong}      Generate code automatically    BL
    Input data        ${textbox_mabangluong}      ${ma_bang_luong}
    Click element     ${button_chotluong}
    Create pay sheet success validation    ${ma_bang_luong}
    Sleep    2s
    #
    ${input_gio_vao}    ${input_gio_ra}       Get shift infor thr API     ${input_ten_ca}    ${get_branch_id}
    ${total_gio_lv}      Subtract Time From Time    ${input_gio_ra}   ${input_gio_vao}
    ${total_gio_lv}   Devision    ${total_gio_lv}    60
    ${luong_tren_gio}    Devision    ${input_luong_theo_ca}    ${total_gio_lv}
    ${luong_tren_gio_ot}    Run Keyword If    ${input_luong_ot_ngaythuong}>1000    Set Variable    ${input_luong_ot_ngaythuong}
    ...    ELSE    Convert % discount to VND    ${luong_tren_gio}    ${input_luong_ot_ngaythuong}
    Log    ${luong_tren_gio_ot}
    ${thoigian_ot}    Sum    ${input_di_som}    ${input_ve_muon}
    ${total_gio_ot}    Devision    ${thoigian_ot}    60
    ${luong_ot}    Multiplication and round    ${total_gio_ot}    ${luong_tren_gio_ot}
    log    ${luong_ot}
    ${result_cantra}    Sum    ${input_luong_theo_ca}    ${luong_ot}
    #
    ${get_ma_phieu_luong}    Get pay slip by employee thr API    ${input_ma_nv}
    ${get_trangthai}    ${get_luongchinh}    ${get_hoahong}    ${get_lamthem}    ${get_phucap}    ${get_giamtru}    ${get_datra}
    ...    ${get_cantra}    ${get_thuong}    Get pay sheet infor by pay sheet code    ${ma_bang_luong}    ${get_ma_phieu_luong}    ${get_branch_id}
    Should Be Equal As Numbers    ${get_trangthai}    2
    Should Be Equal As Numbers    ${get_lamthem}    ${luong_ot}
    Should Be Equal As Numbers    ${get_luongchinh}    ${input_luong_theo_ca}
    Should Be Equal As Numbers    ${get_cantra}    ${result_cantra}
    Should Be Equal As Numbers    ${get_datra}    0
    #
    Update working day for branch    ${input_branch}    ${get_branch_id}    none
    Delete pay sheet thr API    ${ma_bang_luong}    ${get_branch_id}
    Delete clocking thr API    ${get_clocking_id}    ${get_branch_id}
    Update working day for branch    ${input_branch}    ${get_branch_id}    none
    Delete employee thr API    ${input_ma_nv}
