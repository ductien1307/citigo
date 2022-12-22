*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    ${headless_browser}
Test Setup        Before Test Thiet lap hoa hong
Test Teardown     After Test
Resource          ../../../config/env_product/envi.robot
Resource          ../../../core/Nhan_vien/nhanvien_list_action.robot
Resource          ../../../core/share/discount.robot
Resource          ../../../core/share/toast_message.robot
Resource          ../../../core/Thiet_lap/nguoidung_list_action.robot
Resource          ../../../core/Nhan_vien/chamcong_list_action.robot
Resource          ../../../core/Nhan_vien/thietlaphoahong_list_action.robot
Resource          ../../../core/API/api_nhanvien.robot
Resource          ../../../core/API/api_chamcong.robot
Resource          ../../../core/API/api_thietlaphoahong.robot
Resource          ../../../core/Thiet_lap/thiet_lap_nav.robot
Resource          ../../../core/share/computation.robot
Library           String
Library           SeleniumLibrary
Library           Collections
Library           DateTime

*** Variables ***

*** Test Cases ***
Thêm mới
    [Tags]      TS2     BHH
    [Template]    ebhh01
    BHH1     Dịch vụ     5000      VND          no
    BHH2     Dịch vụ     15      % Doanh thu     yes

Cập nhật
    [Tags]      TS2     BHH
    [Template]    ebhh02
    BHH3    BHH3up      Dồ ăn vặt

Xóa
    [Tags]      TS2     BHH
    [Template]    ebhh03
    BHH4   Dịch vụ

Add sp vao bhh
    [Tags]      TS2     BHH
    [Template]    ebhh04
    Hoa hồng   BHH5    15      % Doanh thu     yes

Thêm mới GOLIVE
    [Tags]      GOLIVE3     TS05
    [Template]    ebhh01
    BHH1     Kẹo bánh     5000      VND     yes

*** Keywords ***
ebhh01
    [Arguments]     ${input_ten_bhh}      ${input_nhom_hang}     ${input_value}      ${input_type}     ${input_apdung}
    Set Selenium Speed    0.1
    ${get_bhh_id}     Get commission id     ${input_ten_bhh}
    Run Keyword If    ${get_bhh_id}==0      Log    Ignore       ELSE      Delete commission thr API    ${input_ten_bhh}
    Reload Page
    Input data in popup Them moi bang hoa hong    ${input_ten_bhh}
    Wait Until Page Does Not Contain Element    ${toast_message}    20s
    Add category into commission    ${input_nhom_hang}
    ${tongsl_hh}    Get total product in category thr API    ${input_nhom_hang}    0
    ${tóngl_hh_bhh}    Get total product in commission thr API      ${input_ten_bhh}
    Should Be Equal As Numbers    ${tóngl_hh_bhh}    ${tongsl_hh}
    Setting commission value in commission     ${input_value}      ${input_type}     ${input_apdung}
    Wait Until Keyword Succeeds    3 times    3s    Delete commission thr API    ${input_ten_bhh}

ebhh02
    [Arguments]     ${input_ten_bh_bf}     ${input_ten_bh_af}     ${input_nhom_hang}
    Set Selenium Speed    0.1
    ${get_bhh_id_bf}     Get commission id     ${input_ten_bh_bf}
    Run Keyword If    ${get_bhh_id_bf}==0      Log    Ignore       ELSE      Delete commission thr API    ${input_ten_bh_bf}
    ${get_bhh_id_af}     Get commission id     ${input_ten_bh_af}
    Run Keyword If    ${get_bhh_id_af}==0      Log    Ignore       ELSE      Delete commission thr API    ${input_ten_bh_af}
    Add new commission thr API    ${input_ten_bh_bf}
    Add category into commission thr API    ${input_ten_bh_bf}     ${input_nhom_hang}
    Reload Page
    Wait Until Keyword Succeeds    3x    1s    Select Bang hoa hong      ${input_ten_bh_bf}
    Click Element    ${button_chinhsua_banghoahong}
    Wait Until Page Contains Element    ${textbox_ten_banghoahong}      20s
    Input data    ${textbox_ten_banghoahong}    ${input_ten_bh_af}
    Click Element    ${button_luu_banghoahong}
    Update commission success validation
    Wait Until Keyword Succeeds    3 times    3s    Delete commission thr API    ${input_ten_bh_af}

ebhh03
    [Arguments]     ${input_ten_bhh}    ${input_nhom_hang}
    Set Selenium Speed    0.1
    ${get_bhh_id}     Get commission id     ${input_ten_bhh}
    Run Keyword If    ${get_bhh_id}==0      Log    Ignore       ELSE      Delete commission thr API    ${input_ten_bhh}
    Add new commission thr API    ${input_ten_bhh}
    Add category into commission thr API    ${input_ten_bhh}     ${input_nhom_hang}
    Reload Page
    Select Bang hoa hong      ${input_ten_bhh}
    Click Element    ${button_chinhsua_banghoahong}
    Wait Until Page Contains Element    ${button_xoa_banghoahong}      20s
    Click Element    ${button_xoa_banghoahong}
    Wait Until Page Contains Element    ${button_xoa_bhh_dongy}      20s
    Click Element    ${button_xoa_bhh_dongy}
    Delete commission success validation    ${input_ten_bhh}
    ${get_bhh_id_af}     Get commission id     ${input_ten_bhh}
    Should Be Equal As Numbers    ${get_bhh_id_af}    0

ebhh04
    [Arguments]     ${input_ten_bhh1}    ${input_ten_bhh2}   ${input_value}      ${input_type}     ${input_apdung}
    Set Selenium Speed    0.1
    ${get_bhh_id}     Get commission id     ${input_ten_bhh2}
    Run Keyword If    ${get_bhh_id}==0      Log    Ignore       ELSE      Delete commission thr API    ${input_ten_bhh2}
    Select Bang hoa hong      ${input_ten_bhh1}
    Input data in popup Them moi bang hoa hong    ${input_ten_bhh2}
    Wait Until Page Does Not Contain Element       ${toast_message}    1 min
    Click Element    ${button_themvao_banghoahong_first_product}
    Wait Until Page Contains Element    ${textbox_muc_hoa_hong}   20s
    Run Keyword If    '${input_type}'=='VND'    Log    Ingore       ELSE    Click Element    ${button_doanhthu}
    Input Text    ${textbox_muc_hoa_hong}   ${input_value}
    Run Keyword If    '${input_apdung}'=='no'    Log    Ingore      ELSE    Click Element    ${checkbox_apdung}
    Click Element    ${button_dongy_muchoahong}
    Update data success validation
