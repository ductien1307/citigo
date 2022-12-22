*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    ${headless_browser}
Test Setup        Before Test Quan ly
Test Teardown     After Test
Library           SeleniumLibrary
Resource         ../../../core/Thiet_lap/thiet_lap_nav.robot
Resource         ../../../core/Thiet_lap/nguoidung_list_page.robot
Resource         ../../../core/Thiet_lap/nguoidung_list_action.robot
Resource         ../../../core/API/api_thietlap.robot
Resource         ../../../core/share/toast_message.robot
Resource         ../../../core/API/api_access.robot



*** Test Cases ***      Name            User name     Password      Permission    Branch    Phone     Email    Note
Create user            [Tags]              TL     USER
                      [Template]    create_user
                      Mai Thị Hồng Ngọc   mai.hn      123         Quản trị chi nhánh    Chi nhánh trung tâm     0954895748   abc@gmail.com    none
                      Nguyễn Thu Linh   linh.nt1      123         Nhân viên thu ngân    Nhánh A     none     none    none

*** Keywords ***
create_user
    [Arguments]    ${input_name}   ${input_username}    ${input_pass}   ${permission}    ${branch}    ${input_phone}    ${input_email}    ${input_note}
    Set Selenium Speed    0.7s
    ${get_user_id}    Get User ID by UserName    ${input_username}
    Run Keyword If    '${get_user_id}' == '0'    Log    Ignore     ELSE      Delete user    ${get_user_id}
    Go to Quan ly nguoi dung
    Sleep    2s
    Click Element JS   ${button_nguoidung}
    Input text    ${textbox_user_name}   ${input_name}
    Input text    ${textbox_user_username}   ${input_username}
    Input text    ${textbox_user_password}   ${input_pass}
    Input text    ${textbox_user_again_password}   ${input_pass}
    Select combobox any form    ${combobox_user_permission}   ${cell_user_item_permission}   ${permission}
    Select dropdown anyform    ${textbox_user_branch}    ${cell_user_item_branch}    ${branch}
    Run Keyword If    '${input_phone}' == 'none'    Log     Ignore input      ELSE       Input text     ${textbox_user_phone}   ${input_phone}
    Run Keyword If    '${input_email}' == 'none'    Log     Ignore input      ELSE       Input text     ${textbox_user_email}   ${input_email}
    Click Element        ${button_save_add_user}
    Update data success validation
    Sleep    5s
    ${get_user_id}    Get user info and validate    ${input_username}    ${input_phone}    ${permission}    ${input_email}    ${branch}
    Check display of Thoi gian truy cap   ${input_username}
    Delete user    ${get_user_id}
