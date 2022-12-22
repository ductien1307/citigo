*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    ${headless_browser}
Test Setup        Before Test Cham cong
Test Teardown     After Test
Resource          ../../../config/env_product/envi.robot
Resource          ../../../core/Nhan_vien/nhanvien_list_action.robot
Resource          ../../../core/share/discount.robot
Resource          ../../../core/share/toast_message.robot
Resource          ../../../core/Thiet_lap/nguoidung_list_action.robot
Resource          ../../../core/Thiet_lap/nguoidung_list_page.robot
Resource          ../../../core/Nhan_vien/chamcong_list_action.robot
Resource          ../../../core/Nhan_vien/chamcong_list_page.robot
Resource          ../../../core/API/api_nhanvien.robot
Resource          ../../../core/API/api_chamcong.robot
Resource          ../../../core/Thiet_lap/thiet_lap_nav.robot
Resource          ../../../core/share/computation.robot
Library           String
Library           SeleniumLibrary
Library           Collections

*** Variables ***
@{list_calv1}      ca 1

*** Test Cases ***
Them ca
    [Tags]       TS2
    [Template]    ebcv1
    Chi nhánh trung tâm       NVT009      ca 1    ${list_calv1}

*** Keywords ***
ebcv1
    [Arguments]     ${input_branch}     ${input_ma_nv}    ${input_ten_ca}   ${list_ca_lv}
    Set Selenium Speed    0.1
    ${get_branch_id}      Get BranchID by BranchName    ${input_branch}
    ${get_nv_id}      Get employee id thr API    ${input_ma_nv}
    Run Keyword If    ${get_nv_id}==0      Log    Ignore       ELSE      Delete employee thr API    ${input_ma_nv}
    Add employee thr API     ${input_ma_nv}    Test validate   ${input_branch}
    ${get_clocking_id}   ${get_timesheet_id}    Add schedule work not repeat for one employee thr API    ${input_ten_ca}   ${input_branch}    ${input_ma_nv}
    Reload Page
    Wait Until Keyword Succeeds    3 times    1s    Click Element    ${button_datlich_lamviec}
    Input data in form Dat lich lam viec khong lap lai    ${list_ca_lv}    ${input_ma_nv}
    Click Element    ${button_luu_lich_lamviec}
    Wait Until Page Contains Element    ${toast_message}      20s
    Element Should Contain    ${toast_message}   Lịch làm việc bị trùng với lịch làm việc đã có khác của nhân viên
    Delete employee thr API    ${input_ma_nv}
