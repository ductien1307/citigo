*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}      ${headless_browser}
Test Setup        Before Test Doi Tac Khach Hang
Test Teardown     After Test
Resource          ../../../config/env_product/envi.robot
Resource          ../../../core/Doi_Tac/doitac_navigation.robot
Resource          ../../../core/Doi_Tac/khachhang_list_action.robot
Resource          ../../../core/Doi_Tac/khachhang_list_page.robot
Resource          ../../../core/API/api_khachhang.robot
Resource          ../../../core/share/toast_message.robot
Resource          ../../../core/share/computation.robot

*** Test Cases ***
Dieu chinh
    [Tags]    CNKH
    [Template]    Dieu chinh cong no
    CTKH009    95000    abc
    CTKH009    120000    none

*** Keywords ***
Dieu chinh cong no
    [Arguments]    ${input_ma_kh}    ${input_giatri}    ${mo_ta}
    ${get_no_cuoi_af_ex}    Get Du no cuoi KH from API    ${input_ma_kh}
    ${result_giatri}    Minus    ${input_giatri}    ${get_no_cuoi_af_ex}
    Search customer and go to tab No can thu tu khach    ${input_ma_kh}
    Wait Until Page Contains Element    ${button_dieuchinh_congno}
    Click Element JS    ${button_dieuchinh_congno}
    Input data in popup Dieu chinh    ${input_giatri}    ${mo_ta}
    Wait Until Keyword Succeeds    3 times    3s    Update data success validation
    Sleep    5s
    ${get_ma_phieu}     ${get_giatri}     ${get_du_no}      Get ma phieu, gia tri, du no in tab No can thu tu khach    ${input_ma_kh}
    Should Be Equal As Numbers    ${input_giatri}    ${get_du_no}
    Run Keyword If    '${result_giatri}'=='0.0'    Log    Ignore Validate     ELSE     Should Be Equal As Numbers    ${result_giatri}    ${get_giatri}
    Run Keyword If    '${result_giatri}'=='0.0'    Log    Ignore delete phieu     ELSE        Delete balance adjustment thr API    ${input_ma_kh}    ${get_ma_phieu}
    Reload Page
