*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    ${headless_browser}
Test Teardown     After Test
Library           SeleniumLibrary
Resource         ../../../core/Thiet_lap/thiet_lap_nav.robot
Resource         ../../../core/Thiet_lap/nguoidung_list_page.robot
Resource         ../../../core/Thiet_lap/nguoidung_list_action.robot
Resource         ../../../core/API/api_thietlap.robot
Resource         ../../../core/API/api_access.robot
Resource         ../../../core/share/toast_message.robot
Resource         ../../../prepare/Hang_hoa/Sources/thietlap.robot
Resource         ../../../core/Thiet_lap/khuyenmai_list_page.robot
Resource         ../../../config/env_product/envi.robot
Resource         ../../../core/login/login_page.robot


*** Test Cases ***      Name         Password      Vai trò
Delete user            [Tags]            OPT
                      [Template]    del_user
                      ha         123         Nhân viên thu ngân

*** Keywords ***
del_user
    [Arguments]    ${input_name}    ${input_pass}    ${input_role}
    Set Selenium Speed    1s
    ${get_user_id}    Get User ID by UserName    ${input_name}
    Run Keyword If    '${get_user_id}' == '0'    Log    Ignore     ELSE      Delete user    ${get_user_id}
    Create new user by role    ${input_name}    ${input_pass}    ${input_role}
    Sleep    2s
    ${get_user_id}    Get User ID by UserName    ${input_name}
    Before Test Ban Hang with other user    ${input_name}    ${input_pass}
    Delete user    ${get_user_id}
    Sleep    2s
    Wait Until Element Is Visible    ${textbox_login_username}
