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
Library           DateTime

*** Variables ***
@{list_calv}      ca 1        ca 2
@{list_calv1}      ca 1

*** Test Cases ***
Dat lich ko lap lai
    [Tags]         TS2
    [Template]    ecc3
    NVT003      Dương        ${list_calv}

Dat lich lap lai
    [Tags]          TS2     GOLIVE3       TS05
    [Template]    ecc4
    NVT004      Quỳnh        ${list_calv1}     1       ngày

*** Keywords ***
ecc3
    [Arguments]     ${input_ma_nv}    ${input_ten_nv}    ${list_ca_lv}
    Set Selenium Speed    0.1
    ${get_nv_id}      Get employee id thr API    ${input_ma_nv}
    Run Keyword If    ${get_nv_id}!=0      Delete employee thr API     ${input_ma_nv}     ELSE    Log    ignore
    Add employee thr API    ${input_ma_nv}    ${input_ten_nv}   Chi nhánh trung tâm
    Reload Page
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
    ${result_total_ca}      Get Length    ${get_clocking_status}
    Should Be Equal As Numbers    ${total_ca}    ${result_total_ca}
    :FOR      ${item_clocking_status}     IN ZIP       ${get_clocking_status}
    \     Should Be Equal As Numbers    ${item_clocking_status}    1
    :FOR      ${item_clocking_id}     IN ZIP      ${get_clocking_id}
    \     ${locator_calv_detail}      Format String     ${button_chi_tiet_ca}      ${item_clocking_id}
    \     Click Element    ${locator_calv_detail}
    \     Wait Until Page Contains Element    ${locator_calv_detail}    20s
    \     Click Element    ${checkbox_vao}
    \     Click Element    ${checkbox_ra}
    \     Click Element    ${button_luu_chitiet_lamviec}
    \     Wait Until Keyword Succeeds    3 times    0.5s    Update clocking success validation
    Sleep    5s
    ${get_clocking_id_af}    ${get_clocking_status_af}      Get clocking id and status by employee thr API    ${BRANCH_ID}    ${get_nv_id}
    :FOR      ${item_clocking_status}     IN ZIP       ${get_clocking_status_af}
    \     Should Be Equal As Numbers    ${item_clocking_status}    3
    #
    Delete employee thr API    ${input_ma_nv}
    Delete multi clocking thr API    ${get_clocking_id}    ${BRANCH_ID}

ecc4
    [Arguments]     ${input_ma_nv}    ${input_ten_nv}    ${list_ca_lv}     ${input_songaylap}    ${input_ngaylap}
    Set Selenium Speed    0.1
    ${get_nv_id}      Get employee id thr API    ${input_ma_nv}
    Run Keyword If    ${get_nv_id}!=0      Delete employee thr API     ${input_ma_nv}     ELSE    Log    ignore
    Add employee thr API    ${input_ma_nv}    ${input_ten_nv}   Chi nhánh trung tâm
    Reload Page
    Wait Until Keyword Succeeds    3 times    1s    Click Element    ${button_datlich_lamviec}
    ${get_cur_day}    Get Current Date
    ${get_ngaykethuc}     Add Time To Date       ${get_cur_day}     2 day     result_format=%d%m%Y
    ${get_ngaybatdau}   Convert Date    ${get_cur_day}      result_format=%d%m%Y
    Input data in form Dat lich lam viec lap lai    ${list_ca_lv}    ${input_ma_nv}   ${get_ngaybatdau}   ${get_ngaykethuc}     ${input_songaylap}    ${input_ngaylap}
    Click Element    ${button_luu_lich_lamviec}
    Create time sheet success validation
    Wait Until Page Contains Element      ${button_dong_thongbao}     30s
    Wait Until Keyword Succeeds    5x    1s    Click Element      ${button_dong_thongbao}
    Sleep    7s
    ${total_ca}     Get Length    ${list_ca_lv}
    ${total_ca}     Multiplication    ${total_ca}    3
    ${get_nv_id}      Get employee id thr API    ${input_ma_nv}
    ${get_clocking_id}    ${get_clocking_status}      Get clocking id and status by employee thr API    ${BRANCH_ID}    ${get_nv_id}
    ${result_total_ca}      Get Length    ${get_clocking_status}
    Should Be Equal As Numbers    ${total_ca}    ${result_total_ca}
    :FOR      ${item_clocking_status}     IN ZIP       ${get_clocking_status}
    \     Should Be Equal As Numbers    ${item_clocking_status}    1
    #
    ${total_ca}     Replace floating point    ${total_ca}
    Click Element    ${toggle_chon_chi_tiet_ca_lv}
    :FOR      ${item_clocking_id}     IN ZIP      ${get_clocking_id}
    \     ${locator_calv_detail}      Format String     ${button_chi_tiet_ca}      ${item_clocking_id}
    \     Click Element    ${locator_calv_detail}
    Go to Cham cong thu cong and choose check in, check out
    Update multi clocking success validation      ${total_ca}
    Sleep    5s
    ${get_clocking_id_af}    ${get_clocking_status_af}      Get clocking id and status by employee thr API    ${BRANCH_ID}    ${get_nv_id}
    :FOR      ${item_clocking_status}     IN ZIP       ${get_clocking_status_af}
    \     Should Be Equal As Numbers    ${item_clocking_status}    3
    #
    Delete employee thr API    ${input_ma_nv}
    Delete multi clocking thr API    ${get_clocking_id}    ${BRANCH_ID}
