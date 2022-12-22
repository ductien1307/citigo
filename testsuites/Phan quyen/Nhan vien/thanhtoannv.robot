*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    ${headless_browser}
Test Setup
Test Teardown     After Test
Library           Collections
Library           SeleniumLibrary
Library           DateTime
Resource          ../../../config/env_product/envi.robot
Resource          ../../../core/hang_hoa/hang_hoa_navigation.robot
Resource          ../../../core/share/computation.robot
Resource          ../../../core/Giao_dich/giaodich_nav.robot
Resource          ../../../core/API/api_thietlap.robot
Resource          ../../../core/Doi_Tac/doitac_navigation.robot
Resource          ../../../core/So_Quy/so_quy_navigation.robot
Resource          ../../../core/Bao_cao/bao_cao_navigation.robot
Resource          ../../../core/share/toast_message.robot
Resource          ../../../prepare/Hang_hoa/Sources/thietlap.robot
Resource          ../../../core/Nhan_vien/nhanvien_navigation.robot
Resource          ../../../core/Thiet_lap/thiet_lap_nav.robot
Resource          ../../../core/Nhan_vien/chamcong_list_action.robot
Resource          ../../../core/API/api_chamcong.robot
Resource          ../../../core/Ban_Hang/banhang_manager_navigation.robot
Resource          ../../../core/Nhan_vien/bangtinhluong_list_action.robot
Resource          ../../../core/API/api_bangtinhluong.robot

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
Thêm mới
    [Documentation]     người dùng chỉ có quyền Thanh toán NV: Thêm mới, Nhân viên: Xem DS, Bảng lương NV: Xem DS, Thêm mới, Chốt lương
    [Tags]      PQ7
    [Template]     pqttnv1
    userttnv1    123         Chi nhánh trung tâm    PQNVL01         40000     ${list_phucap}    ${list_gtri_phucap}    ${list_apdg_phucap}   ${list_gt}    ${list_gt_gr}    ${list_apdung_gt}    ${list_ca}     ${list_gio_dimuon}      all

Cập nhật + Xóa
    [Documentation]     người dùng chỉ có quyền Thanh toán NV: Thêm mới + Cập nhật + Xóa, Nhân viên: Xem DS, Bảng lương NV: Xem DS, Thêm mới, Chốt lương
    [Tags]       PQ7
    [Template]      pqttnv2
    userttnv2    123     Chi nhánh trung tâm    PQNVL02         40000     ${list_phucap}    ${list_gtri_phucap}    ${list_apdg_phucap}   ${list_gt}    ${list_gt_gr}    ${list_apdung_gt}    ${list_ca}     ${list_gio_dimuon}      all

*** Keywords ***
pqttnv1
    [Documentation]     người dùng chỉ có quyền Thanh toán NV: Thêm mới, Nhân viên: Xem DS, Bảng lương NV: Xem DS, Thêm mới, Chốt lương
    [Arguments]    ${taikhoan}    ${matkhau}     ${input_branch}     ${input_ma_nv}    ${input_luong_theo_gio}     ${list_ten_phu_cap}    ${list_giatri_phucap}    ${list_apdung_phucap}    ${list_ten_giam_tru}    ${list_giatri_giamtru}    ${list_apdung_giamtru}  ${list_ten_ca}   ${list_di_muon}     ${input_tientra_nv}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}       Nhân viên kho
    ${get_nv_id}      Get employee id thr API    ${input_ma_nv}
    Run Keyword If    ${get_nv_id}==0      Log    Ignore       ELSE      Delete employee thr API    ${input_ma_nv}
    Add employee and set salary by the working hour thr API      ${input_ma_nv}    Hằng    ${input_branch}     ${input_luong_theo_gio}    200     300      ${list_ten_phu_cap}    ${list_giatri_phucap}    ${list_apdung_phucap}    ${list_ten_giam_tru}    ${list_giatri_giamtru}    ${list_apdung_giamtru}
    :FOR      ${item_ten_ca}        ${item_di_muon}      IN ZIP       ${list_ten_ca}       ${list_di_muon}
    \    ${get_clocking_id}   ${get_timesheet_id}    Add schedule work not repeat for one employee thr API    ${item_ten_ca}   ${input_branch}    ${input_ma_nv}
    \    Update not timekeeping to late timekeeping thr API       ${input_branch}    ${item_ten_ca}     ${input_ma_nv}      ${item_di_muon}    ${get_clocking_id}   ${get_timesheet_id}
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name      Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"Employee_Read":true,"Paysheet_Read":true,"PayslipPayment_Create":true,"Clocking_Copy":false,"FingerMachine_Read":false,"FingerMachine_Create":false,"FingerMachine_Update":false,"FingerMachine_Delete":false,"Paysheet_Create":true,"Paysheet_Complete":true}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}      ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    Before Test Bang tinh luong
    #
    Log    validate UI
    Element Should Not Be Visible    ${menu_giaodich}
    Element Should Not Be Visible    ${menu_hh}
    Element Should Not Be Visible    ${menu_doitac}
    Element Should Not Be Visible    ${domain_baocao}
    Element Should Not Be Visible    ${menu_soquy}
    Element Should Not Be Visible    ${button_banhang_on_quanly}
    Element Should Not Be Visible    ${button_datlich_lamviec}
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
    \     ${input_gio_vao}    ${input_gio_ra}       Get shift infor thr API     ${item_ten_ca}    ${BRANCH_ID}
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
    ${get_trangthai}   ${get_luongchinh}     ${get_hoahong}    ${get_lamthem}    ${get_phucap}   ${get_giamtru}    ${get_datra}    ${get_cantra}   ${get_thuong}   Get pay sheet infor by pay sheet code      ${ma_bang_luong}   ${get_ma_phieu_luong}   ${BRANCH_ID}
    Should Be Equal As Numbers    ${get_trangthai}     2
    Should Be Equal As Numbers    ${get_phucap}     ${result_phu_cap}
    Should Be Equal As Numbers    ${get_giamtru}     ${result_giam_tru}
    Should Be Equal As Numbers    ${get_luongchinh}     ${result_luong_chinh}
    Should Be Equal As Numbers    ${get_cantra}     ${result_conlai_thucte}
    Should Be Equal As Numbers    ${get_datra}     ${result_datra}
    #
    Delete pay sheet thr API    ${ma_bang_luong}    ${BRANCH_ID}
    Delete clocking thr API    ${get_clocking_id}    ${BRANCH_ID}
    Delete employee thr API    ${input_ma_nv}

    Delete user    ${get_user_id}

pqttnv2
    [Documentation]     người dùng chỉ có quyền Thanh toán NV: Thêm mới + Cập nhật + Xóa, Nhân viên: Xem DS, Bảng lương NV: Xem DS, Thêm mới, Chốt lương
    [Arguments]    ${taikhoan}    ${matkhau}     ${input_branch}     ${input_ma_nv}    ${input_luong_theo_gio}     ${list_ten_phu_cap}    ${list_giatri_phucap}    ${list_apdung_phucap}    ${list_ten_giam_tru}    ${list_giatri_giamtru}    ${list_apdung_giamtru}  ${list_ten_ca}   ${list_di_muon}     ${input_tientra_nv}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}       Nhân viên kho
    ${get_nv_id}      Get employee id thr API    ${input_ma_nv}
    Run Keyword If    ${get_nv_id}==0      Log    Ignore       ELSE      Delete employee thr API    ${input_ma_nv}
    Add employee and set salary by the working hour thr API      ${input_ma_nv}    Hằng    ${input_branch}     ${input_luong_theo_gio}    200     300      ${list_ten_phu_cap}    ${list_giatri_phucap}    ${list_apdung_phucap}    ${list_ten_giam_tru}    ${list_giatri_giamtru}    ${list_apdung_giamtru}
    :FOR      ${item_ten_ca}        ${item_di_muon}      IN ZIP       ${list_ten_ca}       ${list_di_muon}
    \    ${get_clocking_id}   ${get_timesheet_id}    Add schedule work not repeat for one employee thr API    ${item_ten_ca}   ${input_branch}    ${input_ma_nv}
    \    Update not timekeeping to late timekeeping thr API       ${input_branch}    ${item_ten_ca}     ${input_ma_nv}      ${item_di_muon}    ${get_clocking_id}   ${get_timesheet_id}
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name      Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"Employee_Read":true,"Paysheet_Read":true,"PayslipPayment_Create":true,"Clocking_Copy":false,"FingerMachine_Read":false,"FingerMachine_Create":false,"FingerMachine_Update":false,"FingerMachine_Delete":false,"Paysheet_Create":true,"Paysheet_Complete":true,"PayslipPayment_Update":true,"Paysheet_Update":false,"Paysheet_Delete":false,"Paysheet_Export":false,"PayslipPayment_Delete":true}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}      ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    Before Test Bang tinh luong
    #
    Log    validate UI
    Element Should Not Be Visible    ${menu_giaodich}
    Element Should Not Be Visible    ${menu_hh}
    Element Should Not Be Visible    ${menu_doitac}
    Element Should Not Be Visible    ${domain_baocao}
    Element Should Not Be Visible    ${menu_soquy}
    Element Should Not Be Visible    ${button_banhang_on_quanly}
    Element Should Not Be Visible    ${button_datlich_lamviec}
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
    \     ${input_gio_vao}    ${input_gio_ra}       Get shift infor thr API     ${item_ten_ca}    ${BRANCH_ID}
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
    Log    tạo phiếu thanh toán
    Input data in popup payment and create payment    ${get_ma_phieu_luong}    ${input_tientra_nv}
    Wait Until Page Does Not Contain Element    ${toast_message}    30s
    Log    cập nhật phiếu thanh toán
    ${ma_phieu_tt}      Set Variable    PC${get_ma_phieu_luong}
    Wait Until Keyword Succeeds    5 times    1s    Click Element    ${tab_lichsu_thanhtoan}
    ${cell_ma_phieutt}      Format String     ${cell_ma_phieutt}      ${ma_phieu_tt}
    Wait Until Page Contains Element    ${cell_ma_phieutt}      30s
    Wait Until Keyword Succeeds    5 times    1s    Click Element    ${cell_ma_phieutt}
    Wait Until Page Contains Element    ${button_capnhat_phieutt}      30s
    Click Element    ${button_capnhat_phieutt}
    Wait Until Page Contains Element    ${toast_message}      30s
    Element Should Contain    ${toast_message}    Phiếu chi ${ma_phieu_tt} được cập nhật thành công
    Wait Until Page Does Not Contain Element    ${toast_message}      30s
    Log    hủy phiếu thanh toán
    Wait Until Keyword Succeeds    5 times    1s    Click Element    ${tab_lichsu_thanhtoan}
    Wait Until Keyword Succeeds    5 times    1s    Click Element    ${cell_ma_phieutt}
    Wait Until Page Contains Element    ${button_huybo_phieutt}      30s
    Click Element    ${button_huybo_phieutt}
    Wait Until Page Contains Element    ${button_dongy_huy_phieutt}      30s
    Click Element    ${button_dongy_huy_phieutt}
    Wait Until Page Contains Element    ${toast_message}      30s
    Element Should Contain    ${toast_message}    Phiếu chi ${ma_phieu_tt} đã được hủy
    #
    Delete pay sheet thr API    ${ma_bang_luong}    ${BRANCH_ID}
    Delete clocking thr API    ${get_clocking_id}    ${BRANCH_ID}
    Delete employee thr API    ${input_ma_nv}
    Delete user    ${get_user_id}
