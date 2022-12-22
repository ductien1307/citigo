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

*** Variables ***
@{list_calv}      ca 1        ca 2

*** Test Cases ***
Xem DS
    [Documentation]     người dùng chỉ có quyền Lịch làm việc: Xem DS
    [Tags]      PQ7
    [Template]    pqllv1
    userllv1    123

Xem DS + Thêm mới
    [Documentation]     người dùng chỉ có quyền Lịch làm việc: Xem DS + Thêm mới, Nhân viên: Xem DS
    [Tags]      PQ7
    [Template]     pqllv2
    userllv2    123         PQNV01      Trung        ${list_calv}

Xem DS + Cập nhật
    [Documentation]     người dùng chỉ có quyền Lịch làm việc: Xem DS + Cập nhật
    [Tags]      PQ7
    [Template]      pqllv3
    userllv3    123      ca 3       Chi nhánh trung tâm       PQNV02        Dung

Xem DS + Xóa
    [Documentation]     người dùng chỉ có quyền Lịch làm việc: Xem DS + Xóa
    [Tags]      PQ7
    [Template]      pqllv4
    userllv4    123       ca 3       Chi nhánh trung tâm       PQNV03        Nhung

Xem DS + Thêm mới + Sao chép
    [Documentation]     người dùng chỉ có quyền Lịch làm việc Xem DS + Thêm mới + Sao chép
    [Tags]      PQ7
    [Template]      pqllv5
    userllv5    123        ca 3       Chi nhánh trung tâm       PQNV06        Phong

Xem DS + Xuất file
    [Documentation]     người dùng chỉ có quyền Lịch làm việc: Xem DS + Xuất file
    [Tags]      PQ7
    [Template]      pqllv6
    userllv6    123

Xem DS + Cập nhật + Cập nhật giờ chám công
    [Documentation]     người dùng chỉ có quyền Lịch làm việc: Xem DS +  Cập nhật + Cập nhật giờ chám công
    [Tags]      PQ7
    [Template]      pqllv7
    userllv7    123      ca 2       Chi nhánh trung tâm       PQNV07        Dung      1400

*** Keywords ***
pqllv1
    [Documentation]     người dùng chỉ có quyền Lịch làm việc Xem DS
    [Arguments]    ${taikhoan}    ${matkhau}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}       Nhân viên kho
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name      Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"Employee_Read":false,"Clocking_Copy":false,"Employee_Create":false,"Employee_Update":false,"Employee_Delete":false,"Clocking_Read":true,"Clocking_Create":false,"Clocking_Update":false,"Clocking_Delete":false,"Clocking_Export":false,"FingerPrint_Read":false,"FingerPrint_Update":false,"FingerPrint_Delete":false}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}      ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    Before Test Cham cong
    #
    Log    validate UI
    Element Should Not Be Visible    ${menu_giaodich}
    Element Should Not Be Visible    ${menu_hh}
    Element Should Not Be Visible    ${menu_doitac}
    Element Should Not Be Visible    ${domain_baocao}
    Element Should Not Be Visible    ${menu_soquy}
    Element Should Not Be Visible    ${button_banhang_on_quanly}
    Element Should Not Be Visible    ${button_datlich_lamviec}
    Delete user    ${get_user_id}

pqllv2
    [Documentation]     người dùng chỉ có quyền Lịch làm việc Xem DS + Thêm mới, Nhân viên: Xem DS
    [Arguments]    ${taikhoan}    ${matkhau}      ${input_ma_nv}    ${input_ten_nv}    ${list_ca_lv}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}       Nhân viên kho
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name      Nhân viên kho
    ${get_nv_id}      Get employee id thr API    ${input_ma_nv}
    Run Keyword If    ${get_nv_id}!=0      Delete employee thr API     ${input_ma_nv}     ELSE    Log    ignore
    Add employee thr API    ${input_ma_nv}    ${input_ten_nv}   Chi nhánh trung tâm
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String     {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"Clocking_Read":true,"Clocking_Create":true,"Employee_Read":true}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}      ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    Before Test Cham cong
    #
    Log    validate UI
    Element Should Not Be Visible    ${menu_giaodich}
    Element Should Not Be Visible    ${menu_hh}
    Element Should Not Be Visible    ${menu_doitac}
    Element Should Not Be Visible    ${domain_baocao}
    Element Should Not Be Visible    ${menu_soquy}
    Element Should Not Be Visible    ${button_banhang_on_quanly}
    Wait Until Keyword Succeeds    3 times    1s    Click Element    ${button_datlich_lamviec}
    Input data in form Dat lich lam viec khong lap lai    ${list_ca_lv}    ${input_ma_nv}
    Click Element    ${button_luu_lich_lamviec}
    Create time sheet success validation
    Wait Until Page Contains Element      ${button_dong_thongbao}     30s
    Click Element      ${button_dong_thongbao}
    Sleep    7s
    ${total_ca}     Get Length    ${list_ca_lv}
    ${get_nv_id}      Get employee id thr API    ${input_ma_nv}
    ${get_clocking_id}    ${get_clocking_status}      Get clocking id and status by employee thr API    ${BRANCH_ID}    ${get_nv_id}
    #
    Delete employee thr API    ${input_ma_nv}
    Delete user    ${get_user_id}

pqllv3
    [Documentation]     người dùng chỉ có quyền Lịch làm việc Xem DS + Cập nhật
    [Arguments]    ${taikhoan}    ${matkhau}      ${input_ten_ca}      ${input_branch}      ${input_ma_nv}       ${input_ten_nv}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_nv_id}      Get employee id thr API    ${input_ma_nv}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}       Nhân viên kho
    Run Keyword If    ${get_nv_id}!=0      Delete employee thr API     ${input_ma_nv}     ELSE    Log    ignore
    Add employee thr API    ${input_ma_nv}    ${input_ten_nv}       ${input_branch}
    ${get_clocking_id}   ${get_timesheet_id}      Add schedule work not repeat for one employee thr API    ${input_ten_ca}      ${input_branch}      ${input_ma_nv}
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name      Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"Employee_Read":false,"Clocking_Copy":false,"Employee_Create":false,"Employee_Update":false,"Employee_Delete":false,"Clocking_Read":true,"Clocking_Create":false,"Clocking_Update":true,"Clocking_Delete":false,"Clocking_Export":false,"FingerPrint_Read":false,"FingerPrint_Update":false,"FingerPrint_Delete":false,"UserReport_ByProfitReport":false,"UserReport_ByUserReport":false,"UserReport_BySaleReport":false,"FinancialReport_SalePerformanceReport":false}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}      ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    Before Test Cham cong
    #
    Log    validate UI
    Element Should Not Be Visible    ${menu_giaodich}
    Element Should Not Be Visible    ${menu_hh}
    Element Should Not Be Visible    ${menu_doitac}
    Element Should Not Be Visible    ${domain_baocao}
    Element Should Not Be Visible    ${menu_soquy}
    Element Should Not Be Visible    ${button_banhang_on_quanly}
    Element Should Not Be Visible    ${button_datlich_lamviec}
    ${locator_calv_detail}      Format String     ${button_chi_tiet_ca}      ${get_clocking_id}
    Click Element    ${locator_calv_detail}
    Wait Until Page Contains Element    ${locator_calv_detail}    20s
    Click Element    ${checkbox_vao}
    Click Element    ${checkbox_ra}
    Click Element    ${button_luu_chitiet_lamviec}
    Wait Until Keyword Succeeds    3 times    0.5s    Update clocking success validation
    Delete employee thr API    ${input_ma_nv}
    Delete clocking thr API    ${get_clocking_id}    ${BRANCH_ID}
    Delete user    ${get_user_id}

pqllv4
    [Documentation]     người dùng chỉ có quyền Lịch làm việc Xem DS + Xóa
    [Arguments]    ${taikhoan}    ${matkhau}      ${input_ten_ca}      ${input_branch}      ${input_ma_nv}       ${input_ten_nv}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_nv_id}      Get employee id thr API    ${input_ma_nv}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}       Nhân viên kho
    Run Keyword If    ${get_nv_id}!=0      Delete employee thr API     ${input_ma_nv}     ELSE    Log    ignore
    Add employee thr API    ${input_ma_nv}    ${input_ten_nv}       ${input_branch}
    ${get_clocking_id}   ${get_timesheet_id}      Add schedule work not repeat for one employee thr API    ${input_ten_ca}      ${input_branch}      ${input_ma_nv}
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name      Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"Employee_Read":false,"Clocking_Copy":false,"Employee_Create":false,"Employee_Update":false,"Employee_Delete":false,"Clocking_Read":true,"Clocking_Create":false,"Clocking_Update":false,"Clocking_Delete":true,"Clocking_Export":false,"FingerPrint_Read":false,"FingerPrint_Update":false,"FingerPrint_Delete":false,"UserReport_ByProfitReport":false,"UserReport_ByUserReport":false,"UserReport_BySaleReport":false,"FinancialReport_SalePerformanceReport":false}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}      ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    Before Test Cham cong
    #
    Log    validate UI
    Element Should Not Be Visible    ${menu_giaodich}
    Element Should Not Be Visible    ${menu_hh}
    Element Should Not Be Visible    ${menu_doitac}
    Element Should Not Be Visible    ${domain_baocao}
    Element Should Not Be Visible    ${menu_soquy}
    Element Should Not Be Visible    ${button_banhang_on_quanly}
    Element Should Not Be Visible    ${button_datlich_lamviec}
    ${locator_calv_detail}      Format String     ${button_chi_tiet_ca}      ${get_clocking_id}
    Click Element    ${locator_calv_detail}
    Wait Until Page Contains Element    ${locator_calv_detail}    20s
    Click Element    ${button_huy_cham_cong}
    Wait Until Page Contains Element    ${button_dongy_huy_chamcong}    20s
    Click Element    ${button_dongy_huy_chamcong}
    Wait Until Page Contains Element    ${toast_message}      50s
    Element Should Contain    ${toast_message}    Hủy chi tiết ca làm việc thành công
    Delete employee thr API    ${input_ma_nv}
    Delete user    ${get_user_id}

pqllv5
    [Documentation]     người dùng chỉ có quyền Lịch làm việc Xem DS + Thêm mới + Sao chép
    [Arguments]    ${taikhoan}    ${matkhau}      ${input_ten_ca}      ${input_branch}      ${input_ma_nv}       ${input_ten_nv}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_nv_id}      Get employee id thr API    ${input_ma_nv}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}       Nhân viên kho
    Run Keyword If    ${get_nv_id}!=0      Delete employee thr API     ${input_ma_nv}     ELSE    Log    ignore
    Add employee thr API    ${input_ma_nv}    ${input_ten_nv}       ${input_branch}
    ${get_clocking_id}   ${get_timesheet_id}      Add schedule work not repeat for one employee thr API    ${input_ten_ca}      ${input_branch}      ${input_ma_nv}
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name      Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"Clocking_Read":true,"Clocking_Create":true,"Clocking_Copy":true,"Employee_Read":true}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}      ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    Before Test Cham cong
    #
    Log    validate UI
    Element Should Not Be Visible    ${menu_giaodich}
    Element Should Not Be Visible    ${menu_hh}
    Element Should Not Be Visible    ${menu_doitac}
    Element Should Not Be Visible    ${domain_baocao}
    Element Should Not Be Visible    ${menu_soquy}
    Element Should Not Be Visible    ${button_banhang_on_quanly}
    Wait Until Page Contains Element      ${button_thao_tac_chamcong}      40s
    Click Element     ${button_thao_tac_chamcong}
    Wait Until Page Contains Element      ${button_saochep_lichlamviec}      10s
    Click Element     ${button_saochep_lichlamviec}
    ${get_cur_date}     Get Current Date
    ${date_copy}      Add Time To Date    ${get_cur_date}    1 day    result_format=%d%m%Y
    ${get_cur_date}     Convert Date    ${get_cur_date}       result_format=%d%m%Y
    Wait Until Page Contains Element    ${button_luu_saochep_lichlv}     30s
    Click Element    ${button_luu_saochep_lichlv}
    Wait Until Page Contains Element    ${toast_message}        40s
    Element Should Contain    ${toast_message}    lịch làm việc thành công.
    Delete employee thr API    ${input_ma_nv}
    Delete user    ${get_user_id}

pqllv6
    [Documentation]     người dùng chỉ có quyền Lịch làm việc Xem DS + Xuất file
    [Arguments]    ${taikhoan}    ${matkhau}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}       Nhân viên kho
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name      Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"Clocking_Read":true,"Clocking_Create":false,"Clocking_Copy":false,"Clocking_Export":true}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}      ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    Before Test Cham cong
    #
    Log    validate UI
    Element Should Not Be Visible    ${menu_giaodich}
    Element Should Not Be Visible    ${menu_hh}
    Element Should Not Be Visible    ${menu_doitac}
    Element Should Not Be Visible    ${domain_baocao}
    Element Should Not Be Visible    ${menu_soquy}
    Element Should Not Be Visible    ${button_banhang_on_quanly}
    Element Should Not Be Visible    ${button_datlich_lamviec}
    Wait Until Page Contains Element    ${button_xuatfile_lichlv}        30s
    Click Element    ${button_xuatfile_lichlv}
    Wait Until Page Contains Element    ${button_ex_chitiet_calamviec}        10s
    Click Element    ${button_ex_chitiet_calamviec}
    Wait Until Keyword Succeeds    3 times    3s    Element Should Contain    ${noti_export}   Nhấn vào đây để tải xuống
    Delete user    ${get_user_id}

pqllv7
    [Documentation]     người dùng chỉ có quyền Lịch làm việc Xem DS + Cập nhật + Cập nhật giờ chấm công
    [Arguments]    ${taikhoan}    ${matkhau}      ${input_ten_ca}      ${input_branch}      ${input_ma_nv}       ${input_ten_nv}      ${input_gio_vao}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_nv_id}      Get employee id thr API    ${input_ma_nv}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}       Nhân viên kho
    Run Keyword If    ${get_nv_id}!=0      Delete employee thr API     ${input_ma_nv}     ELSE    Log    ignore
    Add employee thr API    ${input_ma_nv}    ${input_ten_nv}       ${input_branch}
    ${get_clocking_id}   ${get_timesheet_id}      Add schedule work not repeat for one employee thr API    ${input_ten_ca}      ${input_branch}      ${input_ma_nv}
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name      Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"Clocking_Read":true,"Clocking_Create":false,"Clocking_Update":true,"Clocking_Delete":false,"Commission_Read":false,"Commission_Create":false,"Commission_Update":false,"Commission_Delete":false,"Employee_Read":false,"Employee_Create":false,"Employee_Update":false,"Employee_Delete":false,"EmployeeAdjustment_Read":false,"FingerMachine_Read":false,"FingerMachine_Create":false,"FingerMachine_Update":false,"FingerMachine_Delete":false,"FingerPrint_Read":false,"FingerPrint_Update":false,"FingerPrint_Delete":false,"FingerPrintLog_Read":false,"FingerPrintLog_Delete":false,"PayRate_Read":false,"PayRate_Update":false,"Paysheet_Read":false,"Paysheet_Create":false,"Paysheet_Update":false,"Paysheet_Delete":false,"PayslipPayment_Create":false,"PayslipPayment_Update":false,"PayslipPayment_Delete":false,"Shift_Read":false,"Shift_Create":false,"Shift_Update":false,"Shift_Delete":false,"Commission_Export":false,"Clocking_Copy":false,"Paysheet_Complete":false,"Paysheet_Export":false,"Clocking_Export":false,"Clocking_SetupTimekeeping":true}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}      ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    Before Test Cham cong
    #
    Log    validate UI
    Element Should Not Be Visible    ${menu_giaodich}
    Element Should Not Be Visible    ${menu_hh}
    Element Should Not Be Visible    ${menu_doitac}
    Element Should Not Be Visible    ${domain_baocao}
    Element Should Not Be Visible    ${menu_soquy}
    Element Should Not Be Visible    ${button_banhang_on_quanly}
    Element Should Not Be Visible    ${button_datlich_lamviec}
    ${locator_calv_detail}      Format String     ${button_chi_tiet_ca}      ${get_clocking_id}
    Click Element    ${locator_calv_detail}
    Wait Until Page Contains Element    ${locator_calv_detail}    20s
    Click Element    ${checkbox_vao}
    Click Element    ${checkbox_ra}
    Input data      ${textbox_gio_vao}     ${input_gio_vao}
    Click Element    ${button_luu_chitiet_lamviec}
    Wait Until Keyword Succeeds    3 times    0.5s    Update clocking success validation
    Delete employee thr API    ${input_ma_nv}
    Delete clocking thr API    ${get_clocking_id}    ${BRANCH_ID}
    Delete user    ${get_user_id}
