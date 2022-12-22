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
Resource          ../../../../prepare/Hang_hoa/Sources/thietlap.robot
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
Thanh toan luong
                [Tags]       TS4
                [Template]               ettl1
                Chi nhánh trung tâm    NVtest20         40000     ${list_phucap}    ${list_gtri_phucap}    ${list_apdg_phucap}   ${list_gt}    ${list_gt_gr}    ${list_apdung_gt}    ${list_ca}     ${list_gio_dimuon}      all
                Chi nhánh trung tâm     NVtest21         50000     ${list_phucap}    ${list_gtri_phucap}    ${list_apdg_phucap}   ${list_gt}    ${list_gt_gr}    ${list_apdung_gt}    ${list_ca}     ${list_gio_dimuon}      20000

Tam ung
                [Tags]       TS4
                [Template]               ettl2
                Chi nhánh trung tâm    NVtest22    55000    ca 1      70000     all

Tam ung < can tra
                [Documentation]    Tạm ứng ở tab Nợ lương nhân viên, tạm ứng < cần trả
                [Tags]       TS4
                [Template]               ettl3
                Chi nhánh trung tâm      NVtest23    55000    ca 1      10000     5000
                Chi nhánh trung tâm     NVtest24    60000    ca 1      10000     all

Tam ung > can tra
                [Documentation]    Tạm ứng ở tab Nợ lương nhân viên, tạm ứng > cần trả
                [Tags]        TS4
                [Template]               ettl4
                Chi nhánh trung tâm      NVtest25    45000    ca 1      70000

*** Keywords ***
ettl1
    [Arguments]     ${input_branch}     ${input_ma_nv}    ${input_luong_theo_gio}     ${list_ten_phu_cap}    ${list_giatri_phucap}    ${list_apdung_phucap}    ${list_ten_giam_tru}    ${list_giatri_giamtru}    ${list_apdung_giamtru}  ${list_ten_ca}   ${list_di_muon}     ${input_tientra_nv}
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
    Click element       ${toast_message}
    Wait Until Page Does Not Contain Element    ${toast_message}    30s
    Input data in popup payment and create payment    ${get_ma_phieu_luong}    ${input_tientra_nv}
    ${result_datra}     Set Variable If    '${input_tientra_nv}'=='all'   ${result_cantra}      ${input_tientra_nv}
    ${result_conlai}      Minus      ${result_cantra}    ${result_datra}
    ${result_conlai_thucte}      Set Variable If    ${result_conlai}<0    0      ${result_conlai}
    #
    Sleep    3s
    ${get_trangthai}   ${get_luongchinh}     ${get_hoahong}    ${get_lamthem}    ${get_phucap}   ${get_giamtru}    ${get_datra}    ${get_cantra}   ${get_thuong}   Get pay sheet infor by pay sheet code      ${ma_bang_luong}   ${get_ma_phieu_luong}   ${get_branch_id}
    Should Be Equal As Numbers    ${get_trangthai}     2
    Should Be Equal As Numbers    ${get_phucap}     ${result_phu_cap}
    Should Be Equal As Numbers    ${get_giamtru}     ${result_giam_tru}
    Should Be Equal As Numbers    ${get_luongchinh}     ${result_luong_chinh}
    Should Be Equal As Numbers    ${get_cantra}     ${result_conlai_thucte}
    Should Be Equal As Numbers    ${get_datra}     ${result_datra}
    #
    ${get_maphieu_soquy}    Get Ma Phieu Chi in So quy    ${get_ma_phieu_luong}
    ${result_duno}    Minus    0     ${result_conlai}
    ${result_gtri_soquy}      Minus    0     ${result_datra}
    Log    validate tab No luong nhan vien
    ${result_cantra_nv}      Minus    0    ${result_cantra}
    Run Keyword If    '${input_tientra_nv}' == '0'    Validate status and value in Tab No luong nhan vien    ${input_ma_nv}     ${get_ma_phieu_luong}    14    ${result_cantra}     ${result_cantra_nv}
    ...    ELSE    Validate status and value in Tab No luong nhan vien    ${input_ma_nv}    ${get_maphieu_soquy}    0    ${result_datra}    ${result_duno}
    #
    Log        assert values So quy
    Run Keyword If    '${input_tientra_nv}' == '0'    Validate So quy info from Rest API if Invoice is not paid until success    ${get_maphieu_soquy}
    ...    ELSE    Validate So quy info from Rest API if Invoice is paid until success    ${get_maphieu_soquy}    ${result_gtri_soquy}
    Delete pay sheet thr API    ${ma_bang_luong}    ${get_branch_id}
    Delete clocking thr API    ${get_clocking_id}    ${get_branch_id}
    Delete employee thr API    ${input_ma_nv}

ettl2
    [Arguments]     ${input_branch}    ${input_ma_nv}    ${input_luong_theo_ca}    ${input_ten_ca}     ${input_tientra_nv}     ${input_tientra_nv_2}
    Set Selenium Speed    0.1
    ${get_branch_id}      Get BranchID by BranchName    ${input_branch}
    ${get_nv_id}      Get employee id thr API    ${input_ma_nv}
    Run Keyword If    ${get_nv_id}==0    Log    Ignore
    ...    ELSE    Delete employee thr API    ${input_ma_nv}
    Add employee and set salary by shift thr API    ${input_ma_nv}    Hoa    ${input_branch}    ${input_luong_theo_ca}    200    300
    ${get_clocking_id}    ${get_timesheet_id}    Add schedule work not repeat for one employee thr API    ${input_ten_ca}    ${input_branch}    ${input_ma_nv}
    Update not timekeeping to timekeeping thr API    ${input_branch}    ${input_ten_ca}    ${input_ma_nv}     ${get_clocking_id}
    ...    ${get_timesheet_id}
    Reload page
    ${get_cur_day}     Get Current Date
    Add new pay sheet and input pay period      ${get_cur_day}
    ${ma_bang_luong}      Generate code automatically    BL
    Input data        ${textbox_mabangluong}      ${ma_bang_luong}
    Click element     ${button_chotluong}
    Create pay sheet success validation    ${ma_bang_luong}
    Sleep    2s
    Log    tinh lương chính
    ${result_cantra}     Set Variable    ${input_luong_theo_ca}
    #
    ${get_ma_phieu_luong}     Get pay slip by employee thr API    ${input_ma_nv}
    Click element       ${toast_message}
    Wait Until Page Does Not Contain Element    ${toast_message}    30s
    Input data in popup payment and create payment    ${get_ma_phieu_luong}    ${input_tientra_nv}
    ${result_datra}     Set Variable If    '${input_tientra_nv}'=='all'   ${result_cantra}      ${input_tientra_nv}
    ${result_conlai}      Minus      ${result_cantra}    ${result_datra}
    ${result_conlai_thucte}      Set Variable If    ${result_conlai}<0    0      ${result_conlai}
    #
    Sleep    3s
    ${get_trangthai}   ${get_luongchinh}     ${get_hoahong}    ${get_lamthem}    ${get_phucap}   ${get_giamtru}    ${get_datra}    ${get_cantra}   ${get_thuong}   Get pay sheet infor by pay sheet code      ${ma_bang_luong}   ${get_ma_phieu_luong}   ${get_branch_id}
    Should Be Equal As Numbers    ${get_trangthai}     2
    Should Be Equal As Numbers    ${get_phucap}     0
    Should Be Equal As Numbers    ${get_giamtru}     0
    Should Be Equal As Numbers    ${get_luongchinh}     ${input_luong_theo_ca}
    Should Be Equal As Numbers    ${get_cantra}     0
    Should Be Equal As Numbers    ${get_datra}     ${result_datra}
    #
    ${start_date}    Add Time To Date      ${get_cur_day}    1 day       result_format=%Y-%m-%d
    ${get_clocking_id_2}   ${get_timesheet_id_2}    Add schedule work not repeat for one employee by day thr API    ${start_date}   ${input_ten_ca}   ${input_branch}    ${input_ma_nv}
    Update not timekeeping to timekeeping by day thr API       ${input_branch}    ${start_date}    ${input_ten_ca}    ${input_ma_nv}     ${get_clocking_id_2}   ${get_timesheet_id_2}
    Reload Page
    Add new pay sheet and input pay period      ${get_cur_day}
    ${ma_bang_luong_2}      Generate code automatically    BL
    Input data        ${textbox_mabangluong}      ${ma_bang_luong_2}
    Click element     ${button_chotluong}
    Create pay sheet success validation    ${ma_bang_luong_2}
    #
    Sleep    2s
    ${get_list_phieu}     Get all pay slip by employee thr API    ${input_ma_nv}
    ${get_ma_phieu_luong_2}   Remove Values From List    ${get_list_phieu}    ${input_ma_nv}    ${ma_bang_luong}    ${ma_bang_luong_2}    ${get_ma_phieu_luong}
    ${get_ma_phieu_luong_2}   Get From List      ${get_list_phieu}    0
    Click element       ${toast_message}
    Wait Until Page Does Not Contain Element    ${toast_message}    30s
    Input data in popup payment and create payment    ${get_ma_phieu_luong_2}    ${input_tientra_nv_2}
    ${result_datra_2}   Run Keyword If    '${input_tientra_nv_2}'!='all'    Minus    ${input_tientra_nv_2}    ${result_conlai}
    ${result_datra_2}     Set Variable If    '${input_tientra_nv_2}'=='all'   ${input_luong_theo_ca}      ${result_datra_2}
    ${result_conlai_2}      Minus      ${input_luong_theo_ca}    ${result_datra_2}
    ${result_conlai_thucte_2}      Set Variable If    ${result_conlai_2}<0    0      ${result_conlai_2}
    #
    Sleep    2s
    ${get_datra_2}    ${get_cantra_2}    Get total payment and total need pay by pay sheet code    ${ma_bang_luong_2}    ${get_ma_phieu_luong_2}    ${get_branch_id}
    Should Be Equal As Numbers    ${get_cantra_2}    ${result_conlai_2}
    Should Be Equal As Numbers    ${get_datra_2}     ${result_datra_2}
    #
    ${get_maphieu_soquy}    Get Ma Phieu Chi in So quy    ${get_ma_phieu_luong_2}
    ${sotiendu_lan1}      Minus    ${input_tientra_nv}    ${input_luong_theo_ca}
    ${result_thanhtoan}    Run Keyword If    '${input_tientra_nv_2}'=='all'    Minus    ${input_luong_theo_ca}      ${sotiendu_lan1}     ELSE      Set Variable    ${input_tientra_nv_2}
    ${result_duno}    Minus    0     ${result_conlai_2}
    ${result_gtri_soquy}      Minus    0     ${result_thanhtoan}
    Log    validate tab No luong nhan vien
    ${result_cantra_nv_2}      Minus    0    ${input_luong_theo_ca}
    Run Keyword If    '${input_tientra_nv_2}' == '0'    Validate status and value in Tab No luong nhan vien    ${input_ma_nv}     ${get_ma_phieu_luong_2}    14    ${result_cantra_2}     ${result_cantra_nv_2}
    ...    ELSE    Validate status and value in Tab No luong nhan vien    ${input_ma_nv}    ${get_maphieu_soquy}    0    ${result_thanhtoan}    ${result_duno}
    #
    Log        assert values So quy
    Validate So quy info from Rest API if Invoice is paid until success    ${get_maphieu_soquy}    ${result_gtri_soquy}
    Delete pay sheet thr API    ${ma_bang_luong}    ${get_branch_id}
    Delete clocking thr API    ${get_clocking_id}    ${get_branch_id}
    Delete pay sheet thr API    ${ma_bang_luong_2}    ${get_branch_id}
    Delete clocking thr API    ${get_clocking_id_2}    ${get_branch_id}
    Delete employee thr API    ${input_ma_nv}

ettl3
    [Arguments]     ${input_branch}    ${input_ma_nv}    ${input_luong_theo_ca}    ${input_ten_ca}     ${input_tamung}     ${input_tientra_nv}
    Set Selenium Speed    0.1
    ${get_branch_id}      Get BranchID by BranchName    ${input_branch}
    ${get_nv_id}      Get employee id thr API    ${input_ma_nv}
    Run Keyword If    ${get_nv_id}==0    Log    Ignore
    ...    ELSE    Delete employee thr API    ${input_ma_nv}
    Add employee and set salary by shift thr API    ${input_ma_nv}    Hoa    ${input_branch}    ${input_luong_theo_ca}    200    300
    ${get_ma_phieu_tamung}      Create payslip payment for employee and return code thr API     ${input_ma_nv}    ${input_tamung}    ${get_branch_id}
    ${get_clocking_id}    ${get_timesheet_id}    Add schedule work not repeat for one employee thr API    ${input_ten_ca}    ${input_branch}    ${input_ma_nv}
    Update not timekeeping to timekeeping thr API    ${input_branch}    ${input_ten_ca}    ${input_ma_nv}     ${get_clocking_id}
    ...    ${get_timesheet_id}
    Reload page
    ${get_cur_day}     Get Current Date
    Add new pay sheet and input pay period      ${get_cur_day}
    ${ma_bang_luong}      Generate code automatically    BL
    Input data        ${textbox_mabangluong}      ${ma_bang_luong}
    Click element     ${button_chotluong}
    Create pay sheet success validation    ${ma_bang_luong}
    Sleep    2s
    Log    tinh lương chính
    ${result_cantra}     Set Variable    ${input_luong_theo_ca}
    #
    ${get_ma_phieu_luong}     Get pay slip by employee thr API    ${input_ma_nv}
    Click element       ${toast_message}
    Wait Until Page Does Not Contain Element    ${toast_message}    30s
    Input data in popup payment and create payment    ${get_ma_phieu_luong}    ${input_tientra_nv}
    ${result_conthieu}    Run Keyword If    ${result_cantra}>${input_tamung}    Minus    ${result_cantra}    ${input_tamung}      ELSE      Set Variable    0
    ${result_thanhtoan}   Run Keyword If    '${input_tientra_nv}'=='all'    Set Variable    ${result_conthieu}    ELSE    Set Variable    ${input_tientra_nv}
    ${result_datra}     Run Keyword If    '${input_tientra_nv}'=='all'      Set Variable    ${input_luong_theo_ca}    ELSE     Sum    ${input_tamung}    ${input_tientra_nv}
    ${result_cantra}    Minus    ${result_cantra}    ${result_datra}
    #
    Sleep    3s
    ${get_datra}    ${get_cantra}    Get total payment and total need pay by pay sheet code    ${ma_bang_luong}    ${get_ma_phieu_luong}    ${get_branch_id}
    Should Be Equal As Numbers    ${get_cantra}    ${result_cantra}
    Should Be Equal As Numbers    ${get_datra}     ${result_datra}
    #
    ${get_maphieu_soquy}    Get Ma Phieu Chi in So quy    ${get_ma_phieu_luong}
    ${result_duno}    Minus    0     ${result_cantra}
    ${result_gtri_soquy}      Minus    0     ${result_thanhtoan}
    Log    validate tab No luong nhan vien
    ${result_cantra_nv_2}      Minus    0    ${input_luong_theo_ca}
    Validate status and value in Tab No luong nhan vien    ${input_ma_nv}    ${get_maphieu_soquy}    0    ${result_thanhtoan}    ${result_duno}
    #
    Log        assert values So quy
    Validate So quy info from Rest API if Invoice is paid until success    ${get_maphieu_soquy}    ${result_gtri_soquy}
    Delete pay sheet thr API    ${ma_bang_luong}    ${get_branch_id}
    Delete clocking thr API    ${get_clocking_id}    ${get_branch_id}
    Delete employee thr API    ${input_ma_nv}

ettl4
    [Arguments]     ${input_branch}    ${input_ma_nv}    ${input_luong_theo_ca}    ${input_ten_ca}     ${input_tamung}
    Set Selenium Speed    0.1
    ${get_branch_id}      Get BranchID by BranchName    ${input_branch}
    ${get_nv_id}      Get employee id thr API    ${input_ma_nv}
    Run Keyword If    ${get_nv_id}==0    Log    Ignore
    ...    ELSE    Delete employee thr API    ${input_ma_nv}
    Add employee and set salary by shift thr API    ${input_ma_nv}    Hoa    ${input_branch}    ${input_luong_theo_ca}    200    300
    ${get_ma_phieu_tamung}      Create payslip payment for employee and return code thr API     ${input_ma_nv}    ${input_tamung}    ${get_branch_id}
    ${get_clocking_id}    ${get_timesheet_id}    Add schedule work not repeat for one employee thr API    ${input_ten_ca}    ${input_branch}    ${input_ma_nv}
    Update not timekeeping to timekeeping thr API    ${input_branch}    ${input_ten_ca}    ${input_ma_nv}     ${get_clocking_id}
    ...    ${get_timesheet_id}
    Reload page
    ${get_cur_day}     Get Current Date
    Add new pay sheet and input pay period      ${get_cur_day}
    ${ma_bang_luong}      Generate code automatically    BL
    Input data        ${textbox_mabangluong}      ${ma_bang_luong}
    Click element     ${button_chotluong}
    Create pay sheet success validation    ${ma_bang_luong}
    Sleep    2s
    Log    tinh lương chính
    ${result_cantra}     Set Variable    ${input_luong_theo_ca}
    #
    ${get_ma_phieu_luong}     Get pay slip by employee thr API    ${input_ma_nv}
    #
    Sleep    3s
    ${get_datra}    ${get_cantra}    Get total payment and total need pay by pay sheet code    ${ma_bang_luong}    ${get_ma_phieu_luong}    ${get_branch_id}
    Should Be Equal As Numbers    ${get_cantra}    0
    Should Be Equal As Numbers    ${get_datra}     ${input_luong_theo_ca}
    #
    Delete pay sheet thr API    ${ma_bang_luong}    ${get_branch_id}
    Delete clocking thr API    ${get_clocking_id}    ${get_branch_id}
    Delete employee thr API    ${input_ma_nv}
