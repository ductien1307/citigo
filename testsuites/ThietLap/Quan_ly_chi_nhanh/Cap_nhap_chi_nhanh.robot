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
Resource         ../../../core/Thiet_lap/thiet_lap_nav.robot
Resource         ../../../core/Thiet_lap/khuyenmai_list_page.robot
Resource         ../../../core/API/api_access.robot

*** Variables ***
@{list_nlv}   T2    T4      CN

*** Test Cases ***      Branch Name     Phone1         Address                Location            Ward                   SĐT           Email             Ngày làm việc
Update branch            [Tags]                TL   BRANCH      TSR    TSF
                      [Template]    update_branch
                      0912451229   1B Yết Kiêu     Hà Nội - Quận Hoàn Kiếm       Phường Cửa Nam       0912450340      email@gmail.com     ${list_nlv}

Update branch_cancel           [Tags]
                      [Template]    update_branch_1
                      0912451759   1B Yết Kiêu     Hà Nội - Quận Hoàn Kiếm       Phường Cửa Nam       0912450340      email@gmail.com     ${list_nlv}

Del branch            [Tags]                TL   BRANCH
                      [Template]    del_branch
                      0912456349   1B Yết Kiêu     Hà Nội - Quận Hoàn Kiếm         Phường Cửa Nam

Ngung hoat dong       [Tags]   TL   BRANCH
                      [Template]    unactive_branch
                      0912451119   1B Yết Kiêu     Hà Nội - Quận Hoàn Kiếm         Phường Cửa Nam


*** Keywords ***
update_branch
    [Arguments]    ${input_phone}  ${input_address}    ${input_location}     ${input_ward}     ${input_phone2}    ${input_email}    ${list_ngaylamviec}
    Set Selenium Speed    0.5s
    ${get_branch_id}   Get BranchID by Contact number     ${input_phone}
    Run Keyword If    '${get_branch_id}'=='0'    Log    Ignore      ELSE      Delete Branch    ${get_branch_id}
    ${name}      Generate Random String    6    [UPPER][NUMBERS]
    ${input_name}      Catenate      SEPARATOR=      Chi nhánh     ${name}
    Create new branch    ${input_name}    ${input_address}    ${input_location}   ${input_ward}     ${input_phone}
    Go to any thiet lap    ${button_quanly_branch}
    Go to update branch form    ${input_name}
    Run Keyword If    '${input_phone2}' == 'none'    Log     Ignore input      ELSE       Input text     ${textbox_branch_phone2}   ${input_phone2}
    Run Keyword If    '${input_email}' == 'none'    Log     Ignore input      ELSE       Input text     ${textbox_branch_email}   ${input_email}
    Input text     ${textbox_branch_address}   ${input_address}
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
    ${get_branch_id}    Get branch info and validate    ${input_name}   ${input_phone}   ${input_phone2}    ${input_address}
    ...     ${input_location}    ${input_ward}    ${input_email}
    ${get_working_days}     Get timesheet branch setting ưorking days    ${input_name}
    :FOR      ${item_day}     ${item_working_days}      IN ZIP      ${list_day}   ${get_working_days}
    \     Should Be Equal As Strings    ${item_day}    ${item_working_days}
    Delete Branch    ${get_branch_id}

update_branch_1
    [Arguments]    ${input_phone}  ${input_address}    ${input_location}     ${input_ward}     ${input_phone2}    ${input_email}    ${list_ngaylamviec}
    Set Selenium Speed    0.5s
    ${get_branch_id}   Get BranchID by Contact number     ${input_phone}
    Run Keyword If    '${get_branch_id}'=='0'    Log    Ignore      ELSE      Delete Branch    ${get_branch_id}
    ${name}      Generate Random String    6    [UPPER][NUMBERS]
    ${input_name}      Catenate      SEPARATOR=      Chi nhánh     ${name}
    Create new branch    ${input_name}    ${input_address}    ${input_location}   ${input_ward}     ${input_phone}
    Go to any thiet lap    ${button_quanly_branch}
    Go to update branch form    ${input_name}
    Run Keyword If    '${input_phone2}' == 'none'    Log     Ignore input      ELSE       Input text     ${textbox_branch_phone2}   ${input_phone2}
    Run Keyword If    '${input_email}' == 'none'    Log     Ignore input      ELSE       Input text     ${textbox_branch_email}   ${input_email}
    Input text     ${textbox_branch_address}   ${input_address}
    Run Keyword If    '${input_email}' == 'none'    Log     Ignore input      ELSE       Input text     ${textbox_branch_email}   ${input_email}
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

del_branch
    [Arguments]    ${input_phone}  ${input_address}    ${input_location}     ${input_ward}
    Set Selenium Speed    0.5s
    ${get_branch_id}   Get BranchID by Contact number     ${input_phone}
    Run Keyword If    '${get_branch_id}'=='0'    Log    Ignore      ELSE      Delete Branch    ${get_branch_id}
    ${name}      Generate Random String    6    [UPPER][NUMBERS]
    ${input_name}      Catenate      SEPARATOR=      Chi nhánh     ${name}
    Create new branch    ${input_name}    ${input_address}    ${input_location}      ${input_ward}     ${input_phone}
    Go to any thiet lap    ${button_quanly_branch}
    Wait Until Element Is Visible    ${textbox_search_branch}
    Input data    ${textbox_search_branch}    ${input_name}
    Wait Until Element Is Visible    ${checkbox_filter_trangthai_tatca}
    Click Element JS    ${checkbox_filter_trangthai_tatca}
    Sleep    1s
    Wait Until Element Is Visible    ${button_delete_branch}
    Click Element JS    ${button_delete_branch}
    Wait Until Element Is Visible    ${button_dongy_del_promo}
    Click Element JS    ${button_dongy_del_promo}

unactive_branch
    [Arguments]    ${input_phone}  ${input_address}    ${input_location}       ${input_ward}
    Set Selenium Speed    1s
    ${get_branch_id}   Get BranchID by Contact number     ${input_phone}
    Run Keyword If    '${get_branch_id}'=='0'    Log    Ignore      ELSE      Delete Branch    ${get_branch_id}
    ${name}      Generate Random String    6    [UPPER][NUMBERS]
    ${input_name}      Catenate      SEPARATOR=      Chi nhánh     ${name}
    Create new branch    ${input_name}    ${input_address}    ${input_location}      ${input_ward}     ${input_phone}
    Go to any thiet lap    ${button_quanly_branch}
    Wait Until Element Is Visible    ${textbox_search_branch}
    Input data    ${textbox_search_branch}    ${input_name}
    Wait Until Element Is Visible    ${checkbox_filter_trangthai_tatca}
    Click Element JS    ${checkbox_filter_trangthai_tatca}
    Sleep    1s
    Wait Until Element Is Visible    ${button_active_branch}
    Click Element JS    ${button_active_branch}
    Wait Until Element Is Visible    ${button_dongy_del_promo}
    Click Element JS    ${button_dongy_del_promo}
    ${resp}       Get Request and return body    ${endpoint_branch_list}
    ${jsonpath_status}    Format String    $.Data[?(@.Name== '{0}')].LimitAccess    ${input_name}
    ${get_status}    Get data from response json    ${resp}    ${jsonpath_status}
    Should Be Equal As Strings    ${get_status}    True
    ${get_branch_id}    Get branch info and validate    ${input_name}   ${input_phone}   0    ${input_address}
    ...     ${input_location}     ${input_ward}     0
    Delete Branch    ${get_branch_id}
