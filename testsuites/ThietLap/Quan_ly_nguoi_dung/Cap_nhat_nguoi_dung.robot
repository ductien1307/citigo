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
Update user            [Tags]              TL     USER
                      [Template]    update_user
                      Lynklee         123         Quản trị chi nhánh    0985615432      123456          123456

Delete user            [Tags]              TL     USER
                      [Template]    del_user
                      Lu         123         Nhân viên kho

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

del_user
    [Arguments]    ${input_name}    ${input_pass}    ${input_role}
    Set Selenium Speed    1s
    ${get_user_id}    Get User ID by UserName    ${input_name}
    Run Keyword If    '${get_user_id}' == '0'    Log    Ignore     ELSE      Delete user    ${get_user_id}
    Create new user by role    ${input_name}    ${input_pass}    ${input_role}
    Go to Quan ly nguoi dung
    Wait Until Element Is Visible    ${textbox_search_user}
    Input data    ${textbox_search_user}    ${input_name}
    Wait Until Element Is Visible    ${checkbox_filter_trangthai_tatca}
    Click Element JS    ${checkbox_filter_trangthai_tatca}
    Sleep    1s
    Wait Until Element Is Visible    ${button_delete_user}
    Click Element JS    ${button_delete_user}
    Wait Until Element Is Visible    ${button_dongy_del_promo}
    Click Element JS    ${button_dongy_del_promo}
    Wait Until Page Contains Element    ${toast_message}    2 min
    ${text}    Format String        Xóa người dùng {0} thành công    ${input_name}
    Element Should Contain    ${toast_message}    ${text}
