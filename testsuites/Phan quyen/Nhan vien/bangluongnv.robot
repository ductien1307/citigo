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
Xem DS
    [Documentation]     người dùng chỉ có quyền Bảng lương NV: Xem DS
    [Tags]      PQ7
    [Template]    pqbl1
    userbl1    123

Xem DS + Thêm mới
    [Documentation]     người dùng chỉ có quyền Bảng lương NV: Xem DS + Thêm mới, Nhân viên: Xem DS
    [Tags]      PQ7
    [Template]     pqbl2
    userbl2    123       Chi nhánh trung tâm    nvbl001         40000     ${list_phucap}    ${list_gtri_phucap}    ${list_apdg_phucap}   ${list_gt}    ${list_gt_gr}    ${list_apdung_gt}    ${list_ca}     ${list_gio_dimuon}      all

Xem DS + Cập nhật
    [Documentation]     người dùng chỉ có quyền Bảng lương NV: Xem DS + Thêm mới + Cập nhật, Nhân viên: Xem DS
    [Tags]      PQ7
    [Template]      pqbl3
    userbl3    123       Chi nhánh trung tâm    nvbl002        55000    ca 1

Xem DS + Xóa
    [Documentation]     người dùng chỉ có quyền Bảng lương NV: Xem DS + Thêm mới + Xóa, Nhân viên: Xem DS
    [Tags]      PQ7
    [Template]      pqbl4
    userbl4    123      Chi nhánh trung tâm    nvbl003        55000    ca 1

Xem DS + Thêm mới + Chốt lương
    [Documentation]     người dùng chỉ có quyền Nhân viên: Xem DS + Thêm mới + Chốt lương, Nhân viên: Xem DS
    [Tags]      PQ7
    [Template]      pqbl5
    userbl5    123       Chi nhánh trung tâm    nvbl004         40000     ${list_phucap}    ${list_gtri_phucap}    ${list_apdg_phucap}   ${list_gt}    ${list_gt_gr}    ${list_apdung_gt}    ${list_ca}     ${list_gio_dimuon}      all

Xem DS + Xuất file
    [Documentation]     người dùng chỉ có quyền Nhân viên: Xem DS + Xuất file, Nhân viên: Xem DS (đang có bug)
    [Tags]      PQ7
    [Template]      pqbl6
    userbl6    123

*** Keywords ***
pqbl1
    [Documentation]     người dùng chỉ có quyền Bảng lương NV: Xem DS
    [Arguments]    ${taikhoan}    ${matkhau}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}       Nhân viên kho
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name      Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"Commission_Read":false,"Product_Read":false,"Commission_Export":false,"Clocking_Copy":false,"Commission_Create":false,"Commission_Update":false,"Commission_Delete":false,"PayRate_Read":false,"PayRate_Update":false,"Product_Create":false,"Product_Update":false,"Product_Delete":false,"Product_PurchasePrice":false,"Product_Cost":false,"Product_Import":false,"Product_Export":false,"PayslipPayment_Create":false,"PayslipPayment_Update":false,"PayslipPayment_Delete":false,"Employee_Read":false,"Paysheet_Read":true,"Paysheet_Create":false,"Employee_Create":false,"Employee_Update":false,"Employee_Delete":false}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}      ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
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
    Element Should Not Be Visible    ${button_them_bang_luong}
    Delete user    ${get_user_id}

pqbl2
    [Documentation]     người dùng chỉ có quyền Bảng lương NV: Xem DS + Thêm mới, Nhân viên: Xem DS
    [Arguments]    ${taikhoan}    ${matkhau}      ${input_branch}     ${input_ma_nv}    ${input_luong_theo_gio}     ${list_ten_phu_cap}    ${list_giatri_phucap}    ${list_apdung_phucap}    ${list_ten_giam_tru}    ${list_giatri_giamtru}    ${list_apdung_giamtru}  ${list_ten_ca}   ${list_di_muon}     ${input_tientra_nv}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}       Nhân viên kho
    ${get_nv_id}      Get employee id thr API    ${input_ma_nv}
    Run Keyword If    ${get_nv_id}==0      Log    Ignore       ELSE      Delete employee thr API    ${input_ma_nv}
    Add employee and set salary by the working hour thr API      ${input_ma_nv}    Hằng    ${input_branch}     ${input_luong_theo_gio}    200     300      ${list_ten_phu_cap}    ${list_giatri_phucap}    ${list_apdung_phucap}    ${list_ten_giam_tru}    ${list_giatri_giamtru}    ${list_apdung_giamtru}
    :FOR      ${item_ten_ca}        ${item_di_muon}      IN ZIP       ${list_ten_ca}       ${list_di_muon}
    \    ${get_clocking_id}   ${get_timesheet_id}    Add schedule work not repeat for one employee thr API    ${item_ten_ca}   ${input_branch}    ${input_ma_nv}
    \    Update not timekeeping to late timekeeping thr API       ${input_branch}    ${item_ten_ca}     ${input_ma_nv}      ${item_di_muon}    ${get_clocking_id}   ${get_timesheet_id}
    #
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name      Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"Commission_Read":false,"Product_Read":false,"Commission_Export":false,"Clocking_Copy":false,"Commission_Create":false,"Commission_Update":false,"Commission_Delete":false,"PayRate_Read":false,"PayRate_Update":false,"Product_Create":false,"Product_Update":false,"Product_Delete":false,"Product_PurchasePrice":false,"Product_Cost":false,"Product_Import":false,"Product_Export":false,"PayslipPayment_Create":false,"PayslipPayment_Update":false,"PayslipPayment_Delete":false,"Employee_Read":true,"Paysheet_Read":true,"Paysheet_Create":true,"Employee_Create":false,"Employee_Update":false,"Employee_Delete":false,"Paysheet_Update":false,"Paysheet_Delete":false,"Paysheet_Complete":false,"Paysheet_Export":false}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}      ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
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
    #
    ${get_cur_day}     Get Current Date
    ${get_kyhan_bd}     Subtract Time From Date    ${get_cur_day}    3 days     result_format=%d/%m/%Y
    ${get_kyhan_kt}     Add Time To Date       ${get_cur_day}    3 days     result_format=%d/%m/%Y
    ${ten_bang_luong}     Format String     Bảng lương {0} - {1}      ${get_kyhan_bd}     ${get_kyhan_kt}
    Add new pay sheet and input pay period      ${get_cur_day}
    ${ma_bang_luong}      Generate code automatically    BL
    Input data        ${textbox_mabangluong}      ${ma_bang_luong}
    Click element     ${button_luutam_bangluong}
    Update pay sheet success validation    ${ten_bang_luong}
    Delete pay sheet thr API    ${ma_bang_luong}    ${BRANCH_ID}
    Delete clocking thr API    ${get_clocking_id}    ${BRANCH_ID}
    Delete employee thr API    ${input_ma_nv}
    Delete user    ${get_user_id}

pqbl3
    [Documentation]     người dùng chỉ có quyền Bảng lương NV: Xem DS + Thêm mới + Cập nhật, Nhân viên: Xem DS
    [Arguments]    ${taikhoan}    ${matkhau}      ${input_branch}    ${input_ma_nv}    ${input_luong_theo_ca}    ${input_ten_ca}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}       Nhân viên kho
    ${get_nv_id}    Get employee id thr API    ${input_ma_nv}
    Run Keyword If    ${get_nv_id}==0    Log    Ignore
    ...    ELSE    Delete employee thr API    ${input_ma_nv}
    Add employee and set salary by shift thr API    ${input_ma_nv}    Hoa    ${input_branch}    ${input_luong_theo_ca}    200    300
    ${get_clocking_id}    ${get_timesheet_id}    Add schedule work not repeat for one employee thr API    ${input_ten_ca}    ${input_branch}    ${input_ma_nv}
    Update not timekeeping to timekeeping thr API    ${input_branch}    ${input_ten_ca}    ${input_ma_nv}     ${get_clocking_id}
    ...    ${get_timesheet_id}
    #
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name      Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"Commission_Read":false,"Product_Read":false,"Commission_Export":false,"Clocking_Copy":false,"Commission_Create":false,"Commission_Update":false,"Commission_Delete":false,"PayRate_Read":false,"PayRate_Update":false,"Product_Create":false,"Product_Update":false,"Product_Delete":false,"Product_PurchasePrice":false,"Product_Cost":false,"Product_Import":false,"Product_Export":false,"PayslipPayment_Create":false,"PayslipPayment_Update":false,"PayslipPayment_Delete":false,"Employee_Read":true,"Paysheet_Read":true,"Paysheet_Create":true,"Employee_Create":false,"Employee_Update":false,"Employee_Delete":false,"Paysheet_Update":true,"Paysheet_Delete":false,"Paysheet_Complete":false,"Paysheet_Export":false}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}      ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
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
    #
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
    Search pay sheet and click button update    ${ma_bang_luong}
    Wait Until Page Contains Element    ${button_luutam_bangluong}   30s
    Click Element      ${button_luutam_bangluong}
    Wait Until Page Contains Element    ${toast_message}      30s
    Element Should Contain    ${toast_message}    Cập nhật bảng lương ${ten_bang_luong} thành công
    Delete pay sheet thr API    ${ma_bang_luong}    ${BRANCH_ID}
    Delete clocking thr API    ${get_clocking_id}    ${BRANCH_ID}
    Delete employee thr API    ${input_ma_nv}
    Delete user    ${get_user_id}

pqbl4
    [Documentation]     người dùng chỉ có quyền Bảng lương NV: Xem DS + Thêm mới + Xóa, Nhân viên: Xem DS
    [Arguments]    ${taikhoan}    ${matkhau}      ${input_branch}    ${input_ma_nv}    ${input_luong_theo_ca}    ${input_ten_ca}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}       Nhân viên kho
    ${get_nv_id}    Get employee id thr API    ${input_ma_nv}
    Run Keyword If    ${get_nv_id}==0    Log    Ignore
    ...    ELSE    Delete employee thr API    ${input_ma_nv}
    Add employee and set salary by shift thr API    ${input_ma_nv}    Hoa    ${input_branch}    ${input_luong_theo_ca}    200    300
    ${get_clocking_id}    ${get_timesheet_id}    Add schedule work not repeat for one employee thr API    ${input_ten_ca}    ${input_branch}    ${input_ma_nv}
    Update not timekeeping to timekeeping thr API    ${input_branch}    ${input_ten_ca}    ${input_ma_nv}     ${get_clocking_id}
    ...    ${get_timesheet_id}
    #
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name      Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"Commission_Read":false,"Product_Read":false,"Commission_Export":false,"Clocking_Copy":false,"Commission_Create":false,"Commission_Update":false,"Commission_Delete":false,"PayRate_Read":false,"PayRate_Update":false,"Product_Create":false,"Product_Update":false,"Product_Delete":false,"Product_PurchasePrice":false,"Product_Cost":false,"Product_Import":false,"Product_Export":false,"PayslipPayment_Create":false,"PayslipPayment_Update":false,"PayslipPayment_Delete":false,"Employee_Read":true,"Paysheet_Read":true,"Paysheet_Create":true,"Employee_Create":false,"Employee_Update":false,"Employee_Delete":false,"Paysheet_Update":false,"Paysheet_Delete":true,"Paysheet_Complete":false,"Paysheet_Export":false}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}      ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
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
    #
    ${get_cur_day}    Get Current Date
    ${get_kyhan_bd}     Subtract Time From Date    ${get_cur_day}    3 days     result_format=%d/%m/%Y
    ${get_kyhan_kt}     Add Time To Date       ${get_cur_day}    3 days     result_format=%d/%m/%Y
    ${ten_bang_luong}     Format String     Bảng lương {0} - {1}      ${get_kyhan_bd}     ${get_kyhan_kt}
    Add new pay sheet and input pay period    ${get_cur_day}
    ${ma_bang_luong}    Generate code automatically    BL
    Input data    ${textbox_mabangluong}    ${ma_bang_luong}
    Click element     ${button_luutam_bangluong}
    Wait Until Page Contains Element    ${toast_message}      30s
    Element Should Contain    ${toast_message}     thành công
    ${get_ma_phieu_luong}    Get pay slip by employee thr API    ${input_ma_nv}
    Reload Page
    Input data      ${textbox_tim_theo_ma_bangluong}    ${ma_bang_luong}
    Wait Until Page Contains Element    ${button_huy_bangluong}     30s
    Click Element JS    ${button_huy_bangluong}
    Wait Until Page Contains Element    ${button_dongy_huy_bangluong}     30s
    Click Element JS    ${button_dongy_huy_bangluong}
    Wait Until Page Contains Element    ${toast_message}      30s
    Element Should Contain    ${toast_message}    Hủy bảng lương ${ma_bang_luong} thành công
    Delete clocking thr API    ${get_clocking_id}     ${BRANCH_ID}
    Delete employee thr API    ${input_ma_nv}
    Delete user    ${get_user_id}

pqbl5
    [Documentation]     người dùng chỉ có quyền Bảng lương NV: Xem DS + Thêm mới + Chốt lương, Nhân viên: Xem DS
    [Arguments]    ${taikhoan}    ${matkhau}      ${input_branch}     ${input_ma_nv}    ${input_luong_theo_gio}     ${list_ten_phu_cap}    ${list_giatri_phucap}    ${list_apdung_phucap}    ${list_ten_giam_tru}    ${list_giatri_giamtru}    ${list_apdung_giamtru}  ${list_ten_ca}   ${list_di_muon}     ${input_tientra_nv}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}       Nhân viên kho
    ${get_nv_id}      Get employee id thr API    ${input_ma_nv}
    Run Keyword If    ${get_nv_id}==0      Log    Ignore       ELSE      Delete employee thr API    ${input_ma_nv}
    Add employee and set salary by the working hour thr API      ${input_ma_nv}    Hằng    ${input_branch}     ${input_luong_theo_gio}    200     300      ${list_ten_phu_cap}    ${list_giatri_phucap}    ${list_apdung_phucap}    ${list_ten_giam_tru}    ${list_giatri_giamtru}    ${list_apdung_giamtru}
    :FOR      ${item_ten_ca}        ${item_di_muon}      IN ZIP       ${list_ten_ca}       ${list_di_muon}
    \    ${get_clocking_id}   ${get_timesheet_id}    Add schedule work not repeat for one employee thr API    ${item_ten_ca}   ${input_branch}    ${input_ma_nv}
    \    Update not timekeeping to late timekeeping thr API       ${input_branch}    ${item_ten_ca}     ${input_ma_nv}      ${item_di_muon}    ${get_clocking_id}   ${get_timesheet_id}
    #
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name      Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"Commission_Read":false,"Product_Read":false,"Commission_Export":false,"Clocking_Copy":false,"Commission_Create":false,"Commission_Update":false,"Commission_Delete":false,"PayRate_Read":false,"PayRate_Update":false,"Product_Create":false,"Product_Update":false,"Product_Delete":false,"Product_PurchasePrice":false,"Product_Cost":false,"Product_Import":false,"Product_Export":false,"PayslipPayment_Create":false,"PayslipPayment_Update":false,"PayslipPayment_Delete":false,"Employee_Read":true,"Paysheet_Read":true,"Paysheet_Create":true,"Employee_Create":false,"Employee_Update":false,"Employee_Delete":false,"Paysheet_Update":false,"Paysheet_Delete":false,"Paysheet_Complete":true,"Paysheet_Export":false}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}      ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
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
    #
    ${get_cur_day}     Get Current Date
    Add new pay sheet and input pay period      ${get_cur_day}
    ${ma_bang_luong}      Generate code automatically    BL
    Input data        ${textbox_mabangluong}      ${ma_bang_luong}
    Click element     ${button_chotluong}
    Create pay sheet success validation    ${ma_bang_luong}
    Delete pay sheet thr API    ${ma_bang_luong}    ${BRANCH_ID}
    Delete clocking thr API    ${get_clocking_id}    ${BRANCH_ID}
    Delete employee thr API    ${input_ma_nv}
    Delete user    ${get_user_id}

pqbl6
    [Documentation]     người dùng chỉ có quyền Bảng lương NV: Xem DS + Xuất file, Nhân viên: Xem DS
    [Arguments]    ${taikhoan}    ${matkhau}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}       Nhân viên kho
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name      Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"Commission_Read":false,"Product_Read":false,"Commission_Export":false,"Clocking_Copy":false,"Commission_Create":false,"Commission_Update":false,"Commission_Delete":false,"PayRate_Read":false,"PayRate_Update":false,"Product_Create":false,"Product_Update":false,"Product_Delete":false,"Product_PurchasePrice":false,"Product_Cost":false,"Product_Import":false,"Product_Export":false,"PayslipPayment_Create":false,"PayslipPayment_Update":false,"PayslipPayment_Delete":false,"Employee_Read":true,"Paysheet_Read":true,"Paysheet_Create":false,"Employee_Create":false,"Employee_Update":false,"Employee_Delete":false,"Paysheet_Update":false,"Paysheet_Delete":false,"Paysheet_Complete":false,"Paysheet_Export":true}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}      ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
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
    Element Should Not Be Visible    ${button_them_bang_luong}
    Wait Until Keyword Succeeds    3 times    1s     Click Element       //a[contains(@class,'kv2BtnExport')]
    Wait Until Keyword Succeeds    3 times    5s       Element Should Contain    ${noti_export}    Nhấn vào đây để tải xuống
    Delete user    ${get_user_id}
