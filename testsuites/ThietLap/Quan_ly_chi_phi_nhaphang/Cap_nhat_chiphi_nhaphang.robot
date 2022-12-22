*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    ${headless_browser}
Test Setup        Before Test Quan ly
Test Teardown     After Test
Resource         ../../../core/Thiet_lap/thiet_lap_nav.robot
Resource         ../../../core/Thiet_lap/Chi_phi_nhap_hang_action.robot
Resource         ../../../core/Thiet_lap/Chi_phi_nhaphang_page.robot
Resource         ../../../core/Thiet_lap/khuyenmai_list_page.robot
Resource         ../../../core/API/api_thietlap.robot
Resource         ../../../core/share/javascript.robot
Resource         ../../../core/share/toast_message.robot
Resource         ../../../prepare/Hang_hoa/Sources/thietlap.robot
Resource         ../../../core/API/api_access.robot

*** Test Cases ***      Mã chi phí      Tên chi phí          Giá trị     Hình thức              Phạm vi áp dụng     Tự động phiếu nhập     Hoàn trả hàng nhập     Giá trị new     Hình thức new                     Phạm Vi new
Update expenses other            [Tags]       TL    EXPENSE
                      [Template]    update_expenses
                      CHK003          Chi phí phát sinh 1     200000       Chi phí nhập khác       Nhánh A              false                  true                   25            Chi phí nhập trả nhà cung cấp       Toàn hệ thống

Delete expenses other            [Tags]        TL    EXPENSE
                      [Template]    del_expenses
                      CHNH004          Chi phí phát sinh 2    150000       Chi phí nhập trả nhà cung cấp       Toàn hệ thống              false                  false

Unactive expenses other            [Tags]   TL    EXPENSE
                      [Template]    active_expenses
                      CHNH005          Chi phí phát sinh 3     100000       Chi phí nhập trả nhà cung cấp       Toàn hệ thống              false                  true

*** Keywords ***
update_expenses
    [Arguments]    ${input_ma_cpnh}   ${input_ten}   ${input_giatri}    ${input_hinhthuc}  ${input_phamvi}    ${input_tudong_pn}    ${input_hoantra}
    ...    ${input_giatri_new}    ${input_hinhthuc_new}  ${input_phamvi_new}
    ${get_expense_id}   Get expenses id frm api    ${input_ma_cpnh}
    Run Keyword If    '${get_expense_id}' == '0'    Log    Ignore     ELSE      Delete expense other    ${get_expense_id}
    Set Selenium Speed    0.5s
    Create new Supplier's charge by vnd    ${input_ma_cpnh}   ${input_ten}   ${input_giatri}   ${input_tudong_pn}    ${input_hoantra}
    Go to any thiet lap    ${button_chiphi_nhaphang}
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

del_expenses
    [Arguments]    ${input_ma_cpnh}   ${input_ten}   ${input_giatri}    ${input_hinhthuc}  ${input_phamvi}    ${input_tudong_pn}    ${input_hoantra}
    Set Selenium Speed    0.5s
    ${get_expense_id}   Get expenses id frm api    ${input_ma_cpnh}
    Run Keyword If    '${get_expense_id}' == '0'    Log    Ignore     ELSE      Delete expense other    ${get_expense_id}
    Create new Supplier's charge by vnd    ${input_ma_cpnh}   ${input_ten}   ${input_giatri}   ${input_tudong_pn}    ${input_hoantra}
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

active_expenses
    [Arguments]    ${input_ma_cpnh}   ${input_ten}   ${input_giatri}    ${input_hinhthuc}  ${input_phamvi}    ${input_tudong_pn}    ${input_hoantra}
    Set Selenium Speed    0.5s
    ${get_expense_id}   Get expenses id frm api    ${input_ma_cpnh}
    Run Keyword If    '${get_expense_id}' == '0'    Log    Ignore     ELSE      Delete expense other    ${get_expense_id}
    Create new Supplier's charge by vnd    ${input_ma_cpnh}   ${input_ten}   ${input_giatri}   ${input_tudong_pn}    ${input_hoantra}
    Go to any thiet lap    ${button_chiphi_nhaphang}
    Wait Until Element Is Visible    ${textbox_search_expense}
    Input data    ${textbox_search_expense}    ${input_ma_cpnh}
    Wait Until Element Is Visible    ${checkbox_trangthai_expense}
    Sleep    1s
    Click Element JS    ${checkbox_trangthai_expense}
    Wait Until Element Is Visible    ${button_active_expense}
    Click Element JS    ${button_active_expense}
    Wait Until Element Is Visible    ${button_dongy_del_promo}
    Click Element JS    ${button_dongy_del_promo}
    Sleep    3s
    ${resp}       Get Request and return body    ${endpoint_list_chiphi_nhaphang}
    ${jsonpath_status}    Format String    $.Data[?(@.Code== '{0}')].isActive    ${input_ma_cpnh}
    ${get_status}   Get data from response json and return false value    ${resp}    ${jsonpath_status}
    Should Be Equal As Strings    ${get_status}    False
    ${jsonpath_name}    Format String    $..Data[?(@.Code=="{0}")].Name    ${input_ma_cpnh}
    ${jsonpath_giatri_vnd}    Format String    $..Data[?(@.Code=="{0}")].Value    ${input_ma_cpnh}
    ${jsonpath_giatri_%}    Format String    $..Data[?(@.Code=="{0}")].ValueRatio    ${input_ma_cpnh}
    ${jsonpath_hinhthuc}    Format String    $..Data[?(@.Code=="{0}")].Form    ${input_ma_cpnh}
    ${jsonpath_branch}    Format String    $..Data[?(@.Code=="{0}")].ForAllBranch    ${input_ma_cpnh}
    ${jsonpath_tudong_nhaphang}    Format String    $..Data[?(@.Code=="{0}")].isAuto    ${input_ma_cpnh}
    ${jsonpath_status}    Format String    $..Data[?(@.Code=="{0}")].isActive    ${input_ma_cpnh}
    ${jsonpath_hoantra_trahangnhap}    Format String    $..Data[?(@.Code=="{0}")].isReturnAuto    ${input_ma_cpnh}
    ${jsonpath_id_expense}    Format String    $..Data[?(@.Code=="{0}")].Id    ${input_ma_cpnh}
    ${get_expense_name}    Get data from response json    ${resp}    ${jsonpath_name}
    ${get_expense_giatri_vnd}    Get data from response json    ${resp}    ${jsonpath_giatri_vnd}
    ${get_expense_giatri_vnd}    Replace floating point    ${get_expense_giatri_vnd}
    ${get_expense_giatri_%}    Get data from response json    ${resp}    ${jsonpath_giatri_%}
    ${get_expense_giatri_%}    Replace floating point    ${get_expense_giatri_%}
    ${get_expense_giatri}   Set Variable If    0 < ${input_giatri} < 100    ${get_expense_giatri_%}    ${get_expense_giatri_vnd}
    ${get_expense_hinhthuc}    Get data from response json    ${resp}    ${jsonpath_hinhthuc}
    ${get_expense_branch}    Get data from response json and return false value    ${resp}    ${jsonpath_branch}
    ${get_expense_tudong}    Get data from response json and return false value    ${resp}    ${jsonpath_tudong_nhaphang}
    ${get_expense_hoantra}    Get data from response json and return false value    ${resp}    ${jsonpath_hoantra_trahangnhap}
    ${get_expense_id}    Get data from response json    ${resp}    ${jsonpath_id_expense}
    Should Be Equal As Strings    ${get_expense_name}    ${input_ten}
    Should Be Equal As Strings    ${get_expense_giatri}    ${input_giatri}
    Run Keyword If    '${input_hinhthuc}'=='Chi phí nhập trả nhà cung cấp'    Should Be Equal As Numbers    ${get_expense_hinhthuc}    0
    ...     ELSE    Should Be Equal As Numbers    ${get_expense_hinhthuc}    1
    Run Keyword If    '${input_phamvi}'=='Toàn hệ thống'    Should Be Equal As Strings    ${get_expense_branch}    True
    ...     ELSE    Should Be Equal As Strings    ${get_expense_branch}    False
    Run Keyword If    '${input_tudong_pn}'=='true'    Should Be Equal As Strings    ${get_expense_tudong}    True
    ...     ELSE    Should Be Equal As Strings    ${get_expense_tudong}    False
    Run Keyword If    '${input_hoantra}'=='true'    Should Be Equal As Strings    ${get_expense_hoantra}    True
    ...     ELSE    Should Be Equal As Strings    ${get_expense_hoantra}    False
    Delete expense other    ${get_expense_id}
