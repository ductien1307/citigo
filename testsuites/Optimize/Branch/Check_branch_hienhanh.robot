*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    ${headless_browser}
Test Teardown     After Test
Resource         ../../../core/Thiet_lap/thiet_lap_nav.robot
Resource         ../../../core/Thiet_lap/branch_list_page.robot
Resource         ../../../core/Thiet_lap/branch_list_action.robot
Resource         ../../../core/API/api_thietlap.robot
Resource         ../../../core/API/api_access.robot
Resource         ../../../core/API/api_mhbh.robot
Resource         ../../../core/API/api_hoadon_banhang.robot
Resource         ../../../core/share/javascript.robot
Resource         ../../../core/share/toast_message.robot
Resource         ../../../core/Thiet_lap/thiet_lap_nav.robot
Resource         ../../../core/Thiet_lap/khuyenmai_list_page.robot
Resource         ../../../core/login/login_action.robot
Resource         ../../../core/Ban_Hang/banhang_page.robot

*** Test Cases ***      Branch name        Phone1         Address                Location             Ward
Branch hiện hành       [Tags]   OPT
                      [Template]    branch
                      Chi nhánh NO  0912411444       70 Nguyễn Khoái     Hà Nội - Quận Hoàn Kiếm      Phường Trần Hưng Đạo


*** Keywords ***
branch
    [Arguments]    ${input_name}   ${input_phone}  ${input_address}    ${input_location}    ${input_ward}
    Set Selenium Speed    1s
    ${get_branch_id}    Get BranchID by BranchName    ${input_name}
    Run Keyword If    '${get_branch_id}' == '0'    Log    Ignore delete     ELSE      Delete Branch    ${get_branch_id}
    Create new branch    ${input_name}    ${input_address}    ${input_location}    ${input_ward}   ${input_phone}
    Sleep    2s
    Before Test Ban Hang
    Switch branch in sale form    ${input_name}
    Sleep    5s
    Wait Until Element Is Visible    ${icon_select_branch_in_mhbh}
    Click Element JS    ${icon_select_branch_in_mhbh}
    Sleep   2s
    ${get_branch_id}    Get BranchID by BranchName    ${input_name}
    ${get_current_branch_name}    Get Text    ${label_branch_in_mhbh}
    Log out ban hang
    Wait Until Element Is Visible    ${textbox_login_username}
    Input Text    ${textbox_login_username}    ${USER_NAME}
    Input Text    ${textbox_login_password}    ${PASSWORD}
    Wait Until Page Contains Element    ${button_banhang_sale}    2 mins
    Click Element JS    ${button_banhang_sale}
    Should Be Equal As Strings    ${get_current_branch_name}    ${input_name}
    Delete Branch    ${get_branch_id}
