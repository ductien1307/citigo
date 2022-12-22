*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    ${headless_browser}
Test Setup        Before Test Quan ly
Test Teardown     After Test
Resource         ../../../../core/Thiet_lap/thiet_lap_nav.robot
Resource         ../../../../core/Thiet_lap/branch_list_page.robot
Resource         ../../../../core/Thiet_lap/branch_list_action.robot
Resource         ../../../../core/API/api_thietlap.robot
Resource         ../../../../core/share/javascript.robot
Resource         ../../../../core/share/toast_message.robot

*** Variables ***
@{list_nlv}   T2    T4      CN

*** Test Cases ***      Phone1         Address                Location            Ward                  Email             Ngày làm việc
Update branch                [Tags]       TSF
                      [Template]    etcn2
                      0912451229   1B Yết Kiêu     Hà Nội - Quận Hoàn Kiếm       Phường Cửa Nam       email@gmail.com     ${list_nlv}

Update branch _ cancel          [Tags]    TSF
                      [Template]    etcn3
                      0912451759   1B Yết Kiêu     Hà Nội - Quận Hoàn Kiếm       Phường Cửa Nam        email@gmail.com     ${list_nlv}


*** Keywords ***
etcn2
    [Arguments]    ${input_phone}  ${input_address}    ${input_location}     ${input_ward}       ${input_email}    ${list_ngaylamviec}
    Set Selenium Speed    0.5s
    ${name}      Generate Random String    4    [UPPER][NUMBERS]
    ${input_name}      Catenate      SEPARATOR=      Chi nhánh     ${name}
    Create new branch    ${input_name}    ${input_address}    ${input_location}   ${input_ward}     ${input_phone}
    Go to any thiet lap    ${button_quanly_branch}
    Go to update branch form    ${input_name}
    Run Keyword If    '${input_email}' == 'none'    Log     Ignore input      ELSE       Input text     ${textbox_branch_email}   ${input_email}
    Input text     ${textbox_branch_address_fnb}   ${input_address}
    Run Keyword If    '${input_email}' == 'none'    Log     Ignore input      ELSE       Input text     ${textbox_branch_email}   ${input_email}
    :FOR      ${item_ngaylamviec}       IN ZIP      ${list_ngaylamviec}
    \     ${button_nlv}     Format String    ${button_ngaylamviec_theothu}    ${item_ngaylamviec}
    \     Click Element       ${button_nlv}
    Click Element JS        ${button_branch_save}
    Sleep   10s
    ${list_day}      Create List    T2    T3    T4    T5    T6    T7    CN
    :FOR      ${item_ngaynghi}      IN ZIP      ${list_ngaylamviec}
    \     Remove Values From List     ${list_day}    ${item_ngaynghi}
    #
    ${get_branch_id}    Get branch info and validate    ${input_name}   ${input_phone}   0    ${input_address}
    ...     ${input_location}    ${input_ward}    ${input_email}
    ${get_working_days}     Get timesheet branch setting ưorking days    ${input_name}
    :FOR      ${item_day}     ${item_working_days}      IN ZIP      ${list_day}   ${get_working_days}
    \     Should Be Equal As Strings    ${item_day}    ${item_working_days}
    Delete Branch    ${get_branch_id}

etcn3
    [Arguments]    ${input_phone}  ${input_address}    ${input_location}     ${input_ward}        ${input_email}    ${list_ngaylamviec}
    Set Selenium Speed    0.5s
    ${name}      Generate Random String    4    [UPPER][NUMBERS]
    ${input_name}      Catenate      SEPARATOR=      Chi nhánh     ${name}
    Create new branch    ${input_name}    ${input_address}    ${input_location}   ${input_ward}     ${input_phone}
    Go to any thiet lap    ${button_quanly_branch}
    Go to update branch form    ${input_name}
    Run Keyword If    '${input_email}' == 'none'    Log     Ignore input      ELSE       Input text     ${textbox_branch_address_fnb}   ${input_email}
    :FOR      ${item_ngaylamviec}       IN ZIP      ${list_ngaylamviec}
    \     ${button_nlv}     Format String    ${button_ngaylamviec_theothu}    ${item_ngaylamviec}
    \     Click Element       ${button_nlv}
    Click Element JS        ${button_branch_cancel}
    Sleep   5s
    ${list_day}      Create List    T2    T3    T4    T5    T6    T7    CN
    #
    ${get_branch_id}    Get branch info and validate    ${input_name}   ${input_phone}   0    ${input_address}
    ...     ${input_location}    ${input_ward}    0
    ${get_working_days}     Get timesheet branch setting ưorking days    ${input_name}
    :FOR      ${item_day}     ${item_working_days}      IN ZIP      ${list_day}   ${get_working_days}
    \     Should Be Equal As Strings    ${item_day}    ${item_working_days}
    Delete Branch    ${get_branch_id}
