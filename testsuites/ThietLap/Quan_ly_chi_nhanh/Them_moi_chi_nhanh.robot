*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    ${headless_browser}
Test Setup        Before Test Quan ly
Test Teardown     After Test
Resource         ../../../core/Thiet_lap/thiet_lap_nav.robot
Resource         ../../../core/Thiet_lap/branch_list_page.robot
Resource         ../../../core/Thiet_lap/branch_list_action.robot
Resource         ../../../core/API/api_thietlap.robot
Resource         ../../../core/share/javascript.robot
Resource         ../../../core/share/toast_message.robot

*** Variables ***
@{list_nlv}   T3    T5      T6

*** Test Cases ***     Phone1     Phone2    Email     Address     Location     Ward      Ngày làm việc
Create branch            [Tags]                TL   BRANCH    TSR      TSF
                      [Template]    create01
                      0912456789     0987543221   email@gmail.com     1B Yết Kiêu     Hà Nội - Quận Hoàn Kiếm     Phường Trần Hưng Đạo    ${list_nlv}

Create branch            [Tags]      TL   BRANCH       TSR      TSF
                      [Template]    create01
                      0912450000     none   none     35 Kim Đồng     Hà Nội - Quận Hoàng Mai     Phường Tân Mai     ${list_nlv}

*** Keywords ***
create01
    [Arguments]    ${input_phone1}   ${input_phone2}    ${input_email}  ${input_address}    ${input_location}    ${input_ward}      ${list_ngaylamviec}
    Set Selenium Speed    0.5s
    ${get_branch_id}   Get BranchID by Contact number     ${input_phone1}
    Run Keyword If    '${get_branch_id}'=='0'    Log    Ignore      ELSE      Delete Branch    ${get_branch_id}
    ${name}      Generate Random String    6    [UPPER][NUMBERS]
    ${input_name}      Catenate      SEPARATOR=      Chi nhánh     ${name}
    Go to any thiet lap    ${button_quanly_branch}
    Click Element JS   ${button_themmoi_all_form}
    Input text    ${textbox_branch_name}   ${input_name}
    Input text     ${textbox_branch_phone1}   ${input_phone1}
    Run Keyword If    '${input_phone2}' == 'none'    Log     Ignore input      ELSE       Input text     ${textbox_branch_phone2}   ${input_phone2}
    Run Keyword If    '${input_email}' == 'none'    Log     Ignore input      ELSE       Input text     ${textbox_branch_email}   ${input_email}
    Input text     ${textbox_branch_address}   ${input_address}
    Select dropdown anyform    ${textbox_branch_location}    ${cell_branch_item_location}    ${input_location}
    Select dropdown anyform    ${textbox_branch_ward}    ${cell_branch_item_location}    ${input_ward}
    :FOR      ${item_ngaylamviec}       IN ZIP      ${list_ngaylamviec}
    \     ${button_nlv}     Format String    ${button_ngaylamviec_theothu}    ${item_ngaylamviec}
    \     Click Element       ${button_nlv}
    Click Element JS        ${button_branch_save}
    Sleep   10s
    ${list_day}      Create List    T2    T3    T4    T5    T6    T7    CN
    :FOR      ${item_ngaynghi}      IN ZIP      ${list_ngaylamviec}
    \     Remove Values From List     ${list_day}    ${item_ngaynghi}
    #
    ${get_branch_id}    Get branch info and validate    ${input_name}   ${input_phone1}   ${input_phone2}    ${input_address}
    ...     ${input_location}    ${input_ward}    ${input_email}
    ${get_working_days}     Get timesheet branch setting ưorking days    ${input_name}
    :FOR      ${item_day}     ${item_working_days}      IN ZIP      ${list_day}   ${get_working_days}
    \     Should Be Equal As Strings    ${item_day}    ${item_working_days}
    #
    ${text_day}   Set Variable    needdel
    : FOR    ${item_day}    IN ZIP      ${list_day}
    \    ${text_day}    Catenate    SEPARATOR=,    ${text_day}    ${item_day}
    ${text_day}    Replace String    ${text_day}    needdel,    ${EMPTY}    count=1
    ${text_day}    Evaluate      "${text_day}".replace(",", ", ")
    Wait Until Element Is Visible    ${textbox_search_branch}
    Input data    ${textbox_search_branch}    ${input_name}
    Wait Until Page Contains Element    ${cell_ngaylamviec}     30s
    ${get_text_ngaylamviec}     Get Text    ${cell_ngaylamviec}
    Should Be Equal As Strings    ${text_day}    ${get_text_ngaylamviec}
    Delete Branch    ${get_branch_id}
