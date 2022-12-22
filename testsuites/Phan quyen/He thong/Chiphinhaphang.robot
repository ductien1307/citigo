*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    ${headless_browser}
Test Setup
Test Teardown     After Test
Library           Collections
Library           SeleniumLibrary
Resource          ../../../config/env_product/envi.robot
Resource          ../../../core/hang_hoa/hang_hoa_navigation.robot
Resource          ../../../core/Giao_dich/giaodich_nav.robot
Resource          ../../../core/API/api_danhmuc_hanghoa.robot
Resource          ../../../core/API/api_thietlap.robot
Resource          ../../../core/Doi_Tac/doitac_navigation.robot
Resource          ../../../core/So_Quy/so_quy_navigation.robot
Resource          ../../../core/Bao_cao/bao_cao_navigation.robot
Resource          ../../../core/share/toast_message.robot
Resource          ../../../prepare/Hang_hoa/Sources/thietlap.robot
Resource          ../../../core/Nhan_vien/nhanvien_navigation.robot
Resource          ../../../core/Thiet_lap/thiet_lap_nav.robot
Resource          ../../../core/Thiet_lap/Chi_phi_nhap_hang_action.robot

*** Variables ***

*** Test Cases ***
Xem DS
    [Documentation]     người dùng chỉ có quyền CPNH: Xem DS
    [Tags]      PQ1
    [Template]    pqcpnh1
    usercp1    123     CPNH1

Xem DS + Thêm mới
    [Documentation]     người dùng chỉ có quyền CPNH: Xem DS + Thêm mới
    [Tags]      PQ1
    [Template]    pqcpnh2
    usercp2    123      CHNHPQ1          Chi phí phát sinh     100000       Chi phí nhập trả nhà cung cấp     Toàn hệ thống        false                  0

Xem DS + Cập nhật
    [Documentation]     người dùng chỉ có quyền CPNH: Xem DS + Cập nhật
    [Tags]      PQ1
    [Template]    pqcpnh3
    usercp3    123      CHNHPQ2          Chi phí phát sinh 1     200000       Chi phí nhập khác       Nhánh A            false                  true                   25            Chi phí nhập trả nhà cung cấp       Toàn hệ thống

Xem DS + Xóa
    [Documentation]     người dùng chỉ có quyền CPNH Xem DS + Xóa
    [Tags]      PQ1
    [Template]    pqcpnh4
    usercp4    123     CHNHPQ3          Chi phí phát sinh 2    150000       Chi phí nhập trả nhà cung cấp       Toàn hệ thống              false                  false

*** Keywords ***
pqcpnh1
    [Documentation]     người dùng chỉ có quyền CPNH: Xem DS
    [Arguments]    ${taikhoan}    ${matkhau}    ${input_cpnh}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"Surcharge_Read":false,"Surcharge_Update":false,"Clocking_Copy":false,"Surcharge_Delete":false,"SalesChannelIntegrate_Read":false,"SalesChannelIntegrate_Create":false,"SalesChannelIntegrate_Update":false,"SalesChannelIntegrate_Delete":false,"Surcharge_Create":false,"ExpensesOther_Read":true,"ExpensesOther_Create":false}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    Before Test Quan ly
    #
    Log    validate UI
    Element Should Not Be Visible    ${menu_giaodich}
    Element Should Not Be Visible    ${menu_hh}
    Element Should Not Be Visible    ${menu_doitac}
    Element Should Not Be Visible    ${menu_nhanvien}
    Element Should Not Be Visible    ${menu_soquy}
    Element Should Not Be Visible    ${domain_baocao}
    Element Should Not Be Visible    ${button_banhang_on_quanly}
    #
    Go to any thiet lap    ${button_chiphi_nhaphang}
    Wait Until Element Is Visible    ${textbox_search_expense}     10s
    Element Should Not Be Visible      ${button_themmoi_all_form}
    Input data    ${textbox_search_expense}    ${input_cpnh}
    Wait Until Element Is Visible    ${checkbox_trangthai_expense}
    Click Element    ${checkbox_trangthai_expense}
    Sleep   1s
    Element Should Not Be Visible    ${button_capnhat_expense}
    Element Should Not Be Visible    ${button_delete_expense}
    Element Should Not Be Visible    ${button_active_expense}
    Delete user    ${get_user_id}

pqcpnh2
    [Documentation]     người dùng chỉ có quyền CPNH: Xem DS + Thêm mới
    [Arguments]    ${taikhoan}    ${matkhau}    ${input_ma_cpnh}   ${input_ten}   ${input_giatri}    ${input_hinhthuc}  ${input_phamvi}    ${input_tudong_pn}    ${input_hoantra}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"Surcharge_Read":false,"Surcharge_Update":false,"Clocking_Copy":false,"Surcharge_Delete":false,"SalesChannelIntegrate_Read":false,"SalesChannelIntegrate_Create":false,"SalesChannelIntegrate_Update":false,"SalesChannelIntegrate_Delete":false,"Surcharge_Create":false,"ExpensesOther_Read":true,"ExpensesOther_Create":true}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    Before Test Quan ly
    #
    Log    validate UI
    Element Should Not Be Visible    ${menu_giaodich}
    Element Should Not Be Visible    ${menu_hh}
    Element Should Not Be Visible    ${menu_doitac}
    Element Should Not Be Visible    ${menu_nhanvien}
    Element Should Not Be Visible    ${menu_soquy}
    Element Should Not Be Visible    ${domain_baocao}
    Element Should Not Be Visible    ${button_banhang_on_quanly}
    #
    ${get_expense_id}   Get expenses id frm api    ${input_ma_cpnh}
    Run Keyword If    '${get_expense_id}' == '0'    Log    Ignore     ELSE      Delete expense other    ${get_expense_id}
    Go to any thiet lap    ${button_chiphi_nhaphang}
    Sleep    5s
    Wait Until Page Contains Element    ${button_themmoi_all_form}      10s
    Click Element JS   ${button_themmoi_all_form}
    Wait Until Page Contains Element       ${textbox_ma_cpnh}   20s
    Input data    ${textbox_ma_cpnh}   ${input_ma_cpnh}
    Input data     ${textbox_ten_cpnh}   ${input_ten}
    Run Keyword If   0 < ${input_giatri} < 100   Select value any form    ${icon_giatri_%_cpnh}     ${textbox_giatri_cpnh}   ${input_giatri}
    ...    ELSE       Input text     ${textbox_giatri_cpnh}   ${input_giatri}
    Run Keyword If    '${input_hinhthuc}' == 'Chi phí nhập trả nhà cung cấp'    Log     Ignore input      ELSE       Select hinh thuc CPNH    ${input_hinhthuc}
    Run Keyword If    '${input_phamvi}' == 'Toàn hệ thống'    Log     Ignore input      ELSE       Select branch in CPNH    ${input_phamvi}
    Run Keyword If    '${input_tudong_pn}' == 'true'    Log     Ignore input      ELSE       Click Element JS    ${checkbox_tudong_nhaphang}
    Run Keyword If    '${input_hoantra}' == '0' or '${input_hoantra}' == 'false'   Log     Ignore input      ELSE       Click Element JS    ${checkbox_hoanlai_trahangnhap}
    Click Element JS        ${button_luu_cpnh}
    Expenses other message success validation
    Sleep   5s
    ${get_expense_id}    Get expenses other info and validate       ${input_ma_cpnh}   ${input_ten}   ${input_giatri}    ${input_hinhthuc}
    ...  ${input_phamvi}    ${input_tudong_pn}    ${input_hoantra}
    Delete expense other    ${get_expense_id}
    Delete user    ${get_user_id}

pqcpnh3
    [Documentation]     người dùng chỉ có quyền CPNH: Xem DS + Cập nhật
    [Arguments]    ${taikhoan}    ${matkhau}    ${input_ma_cpnh}   ${input_ten}   ${input_giatri}    ${input_hinhthuc}  ${input_phamvi}    ${input_tudong_pn}    ${input_hoantra}
    ...    ${input_giatri_new}    ${input_hinhthuc_new}  ${input_phamvi_new}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"Surcharge_Read":false,"Surcharge_Update":false,"Clocking_Copy":false,"Surcharge_Delete":false,"SalesChannelIntegrate_Read":false,"SalesChannelIntegrate_Create":false,"SalesChannelIntegrate_Update":false,"SalesChannelIntegrate_Delete":false,"Surcharge_Create":false,"ExpensesOther_Read":true,"ExpensesOther_Create":false,"ExpensesOther_Update":true}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    Before Test Quan ly
    #
    Log    validate UI
    Element Should Not Be Visible    ${menu_giaodich}
    Element Should Not Be Visible    ${menu_hh}
    Element Should Not Be Visible    ${menu_doitac}
    Element Should Not Be Visible    ${menu_nhanvien}
    Element Should Not Be Visible    ${menu_soquy}
    Element Should Not Be Visible    ${domain_baocao}
    Element Should Not Be Visible    ${button_banhang_on_quanly}
    #
    ${get_expense_id}   Get expenses id frm api    ${input_ma_cpnh}
    Run Keyword If    '${get_expense_id}' == '0'    Log    Ignore     ELSE      Delete expense other    ${get_expense_id}
    Create new Supplier's charge by vnd    ${input_ma_cpnh}   ${input_ten}   ${input_giatri}   ${input_tudong_pn}    ${input_hoantra}
    #
    Go to any thiet lap    ${button_chiphi_nhaphang}
    Element Should Not Be Visible   ${button_themmoi_all_form}
    Go to update expense other form    ${input_ma_cpnh}
    Run Keyword If   0 < ${input_giatri_new} < 100   Select value any form    ${icon_giatri_%_cpnh}     ${textbox_giatri_cpnh}   ${input_giatri_new}
    ...    ELSE       Input text     ${textbox_giatri_cpnh}   ${input_giatri_new}
    Select hinh thuc CPNH    ${input_hinhthuc_new}
    Click Element JS    ${checkbox_toanhethong_cpnh}
    Click Element JS        ${button_luu_cpnh}
    Expenses other message success validation
    Sleep   5s
    ${get_expense_id}    Get expenses other info and validate       ${input_ma_cpnh}   ${input_ten}   ${input_giatri_new}    ${input_hinhthuc_new}
    ...    ${input_phamvi_new}    ${input_tudong_pn}    ${input_hoantra}
    Delete expense other    ${get_expense_id}
    Delete user    ${get_user_id}

pqcpnh4
    [Documentation]     người dùng chỉ có quyền CPNH: Xem DS + Xóa
    [Arguments]    ${taikhoan}    ${matkhau}    ${input_ma_cpnh}   ${input_ten}   ${input_giatri}    ${input_hinhthuc}  ${input_phamvi}    ${input_tudong_pn}    ${input_hoantra}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"Surcharge_Read":false,"Surcharge_Update":false,"Clocking_Copy":false,"Surcharge_Delete":false,"SalesChannelIntegrate_Read":false,"SalesChannelIntegrate_Create":false,"SalesChannelIntegrate_Update":false,"SalesChannelIntegrate_Delete":false,"Surcharge_Create":false,"ExpensesOther_Read":true,"ExpensesOther_Create":false,"ExpensesOther_Update":false,"ExpensesOther_Delete":true}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    Before Test Quan ly
    #
    Log    validate UI
    Element Should Not Be Visible    ${menu_giaodich}
    Element Should Not Be Visible    ${menu_hh}
    Element Should Not Be Visible    ${menu_doitac}
    Element Should Not Be Visible    ${menu_nhanvien}
    Element Should Not Be Visible    ${menu_soquy}
    Element Should Not Be Visible    ${domain_baocao}
    Element Should Not Be Visible    ${button_banhang_on_quanly}
    #
    ${get_expense_id}   Get expenses id frm api    ${input_ma_cpnh}
    Run Keyword If    '${get_expense_id}' == '0'    Log    Ignore     ELSE      Delete expense other    ${get_expense_id}
    Create new Supplier's charge by vnd    ${input_ma_cpnh}   ${input_ten}   ${input_giatri}   ${input_tudong_pn}    ${input_hoantra}
    #
    Go to any thiet lap    ${button_chiphi_nhaphang}
    Element Should Not Be Visible   ${button_themmoi_all_form}
    Go to any thiet lap    ${button_chiphi_nhaphang}
    Wait Until Element Is Visible    ${textbox_search_expense}
    Input data    ${textbox_search_expense}    ${input_ma_cpnh}
    Wait Until Element Is Visible    ${checkbox_trangthai_expense}
    Click Element JS    ${checkbox_trangthai_expense}
    Sleep    1s
    Wait Until Element Is Visible    ${button_delete_expense}
    Click Element JS    ${button_delete_expense}
    Wait Until Element Is Visible    ${button_dongy_del_promo}
    Click Element JS    ${button_dongy_del_promo}
    Delete data success validation
    Delete user    ${get_user_id}
