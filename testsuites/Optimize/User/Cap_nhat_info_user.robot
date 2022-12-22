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
Resource         ../../../prepare/Hang_hoa/Sources/thietlap.robot
Resource         ../../../core/Thiet_lap/khuyenmai_list_page.robot


*** Test Cases ***      Name         Password      Vai trò              Phone new     Password new     Gõ lại mật khẩu
Update user            [Tags]            OPT
                      [Template]    update_user
                      hai         123         Nhân viên kho    0985616751      123456          123456

*** Keywords ***
update_user
    [Arguments]    ${input_name}    ${input_pass}    ${input_role}    ${input_phone_new}  ${input_pass_new}    ${input_golai_pass}
    Set Selenium Speed    1s
    ${get_user_id}    Get User ID by UserName    ${input_name}
    Run Keyword If    '${get_user_id}' == '0'    Log    Ignore     ELSE      Delete user    ${get_user_id}
    Create new user by role    ${input_name}    ${input_pass}    ${input_role}
    Go to Quan ly nguoi dung
    Go to update user form    ${input_name}
    Sleep    2s
    Input data    ${textbox_user_password}   ${input_pass_new}
    Input data    ${textbox_user_again_password}   ${input_pass_new}
    Run Keyword If    '${input_phone_new}' == 'none'    Log     Ignore input      ELSE       Input data     ${textbox_user_phone}   ${input_phone_new}
    Click Element   ${button_save_add_user}
    Update data success validation
    Sleep    10s
    ${response_user_info}    Get Request and return body    ${endpoint_user}
    ${res_permission}    Get Request and return body    ${endpoint_detail_role}
    ${jsonpath_name}    Format String    $..Data[?(@.CompareUserName=="{0}")].UserName    ${input_name}
    ${jsonpath_mobile}    Format String    $..Data[?(@.CompareUserName=="{0}")].MobilePhone    ${input_name}
    ${jsonpath_user_type}    Format String    $..Data[?(@.CompareUserName=="{0}")].Type    ${input_name}
    ${jsonpath_user_id}    Format String    $..Data[?(@.CompareUserName=="{0}")].Id    ${input_name}
    ${get_name}    Get data from response json    ${response_user_info}    ${jsonpath_name}
    ${get_user_mobile}    Get data from response json    ${response_user_info}    ${jsonpath_mobile}
    ${get_user_type}    Get data from response json    ${response_user_info}    ${jsonpath_user_type}
    ${get_user_id}    Get data from response json    ${response_user_info}    ${jsonpath_user_id}
    Should Be Equal As Strings    ${get_user_type}    0
    Should Be Equal As Strings    ${input_name}    ${get_name}
    Run Keyword If    '${input_phone_new}'=='none'    Should Be Equal As Numbers    ${get_user_mobile}    0
    ...    ELSE    Should Be Equal As Strings    ${input_phone_new}    ${get_user_mobile}
    Check display of Thoi gian truy cap   ${input_name}
    Delete user    ${get_user_id}
