*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    ${headless_browser}
Test Setup        Before Test Quan ly
Test Teardown     After Test
Resource         ../../../core/Thiet_lap/thiet_lap_nav.robot
Resource         ../../../core/Thiet_lap/Chi_phi_nhap_hang_action.robot
Resource         ../../../core/Thiet_lap/Chi_phi_nhaphang_page.robot
Resource         ../../../core/API/api_thietlap.robot
Resource         ../../../core/share/javascript.robot
Resource         ../../../core/share/toast_message.robot
Resource         ../../../core/Thiet_lap/thiet_lap_nav.robot

*** Test Cases ***      Mã chi phí      Tên chi phí          Giá trị     Hình thức                        Phạm vi áp dụng     Tự động phiếu nhập     Hoàn trả hàng nhập
Create expenses other_golive            [Tags]                TL       EXPENSE   
                      [Template]    create_expenses
                      CHNH03          Chi phí phát sinh     100000       Chi phí nhập trả nhà cung cấp     Toàn hệ thống        false                  0

Create expenses other            [Tags]                TL    EXPENSE
                      [Template]    create_expenses
                      CHK002          Chi phí nhập lại hàng     30       Chi phí nhập khác                 Nhánh A              true                  false

*** Keywords ***
create_expenses
    [Arguments]    ${input_ma_cpnh}   ${input_ten}   ${input_giatri}    ${input_hinhthuc}  ${input_phamvi}    ${input_tudong_pn}    ${input_hoantra}
    Set Selenium Speed    0.5s
    ${get_expense_id}   Get expenses id frm api    ${input_ma_cpnh}
    Run Keyword If    '${get_expense_id}' == '0'    Log    Ignore     ELSE      Delete expense other    ${get_expense_id}
    Go to any thiet lap    ${button_chiphi_nhaphang}
    Sleep    1s
    Click Element JS   ${button_themmoi_all_form}
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
