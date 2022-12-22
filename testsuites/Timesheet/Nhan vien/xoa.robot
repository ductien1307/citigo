*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    ${headless_browser}
Test Setup        Before Test Nhan vien
Test Teardown     After Test
Library           String
Library           SeleniumLibrary
Library           Collections
Library           OperatingSystem
Resource          ../../../config/env_product/envi.robot
Resource          ../../../core/Nhan_vien/nhanvien_list_action.robot
Resource          ../../../core/share/discount.robot
Resource          ../../../core/share/toast_message.robot
Resource          ../../../core/Thiet_lap/nguoidung_list_action.robot
Resource          ../../../core/Thiet_lap/nguoidung_list_page.robot
Resource          ../../../core/API/api_nhanvien.robot
Resource          ../../../core/Thiet_lap/thiet_lap_nav.robot

*** Variables ***

*** Test Cases ***
Xoa nv
    [Tags]      NV    TS1
    [Template]    exnv1
    NV009      Linh      Đồng ý
    #NV09      Hoa       Bỏ qua

*** Keywords ***
exnv1
    [Arguments]     ${input_ma_nv}    ${input_ten_nv}    ${confirm}
    ${get_nv_id}      Get employee id thr API    ${input_ma_nv}
    Run Keyword If    ${get_nv_id}==0    Add employee thr API    ${input_ma_nv}    ${input_ten_nv}    Chi nhánh trung tâm      ELSE    Log    ignore
    Reload Page
    Search employee and click delete    ${input_ma_nv}
    Run Keyword If    '${confirm}'=='Đồng ý'    Click Element    ${button_dongy_xoa_nv}   ELSE      Click Element    ${button_boqua_xoa_nv}
    Run Keyword If    '${confirm}'=='Đồng ý'    Delete employee success validation      ELSE    Log     Ignore
    ${get_nv_id_af}      Get employee id thr API    ${input_ma_nv}
    Run Keyword If    '${confirm}'=='Đồng ý'    Should Be Equal As Numbers    ${get_nv_id_af}     0     ELSE    Should Not Be Equal    ${get_nv_id_af}     0
    Run Keyword If    ${get_nv_id_af}!=0     Delete employee thr API    ${input_ma_nv}     ELSE    Log     Ignore
