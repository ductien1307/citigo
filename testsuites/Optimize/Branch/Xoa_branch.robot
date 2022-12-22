*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    ${headless_browser}
Test Teardown     After Test
Resource         ../../../core/Thiet_lap/thiet_lap_nav.robot
Resource         ../../../core/Thiet_lap/branch_list_page.robot
Resource         ../../../core/Thiet_lap/branch_list_action.robot
Resource         ../../../core/API/api_thietlap.robot
Resource         ../../../core/API/api_access.robot
Resource         ../../../core/share/javascript.robot
Resource         ../../../core/share/toast_message.robot
Resource         ../../../core/Thiet_lap/thiet_lap_nav.robot
Resource         ../../../core/Thiet_lap/khuyenmai_list_page.robot

*** Test Cases ***      Branch name        Phone1         Address                Location             Ward
Xoa branch       [Tags]   OPT
                      [Template]    del_branch
                      Chi nhánh mới  0912411222       10 Hàn Thuyên     Hà Nội - Quận Hoàn Kiếm     Phường Cửa Nam


*** Keywords ***
del_branch
    [Arguments]    ${input_name}   ${input_phone}  ${input_address}    ${input_location}       ${input_ward}
    Set Selenium Speed    1s
    ${get_branch_id}    Get BranchID by BranchName    ${input_name}
    Run Keyword If    '${get_branch_id}' == '0'    Log    Ignore delete     ELSE      Delete Branch    ${get_branch_id}
    Create new branch    ${input_name}    ${input_address}    ${input_location}      ${input_ward}     ${input_phone}
    ${get_current_branch_name}    Get current branch name
    ${get_branch_id}    Get BranchID by BranchName    ${input_name}
    Sleep    2s
    Before Test Quan ly
    Switch Branch    ${get_current_branch_name}    ${input_name}
    Delete Branch    ${get_branch_id}
    Reload page
    Wait Until Element Is Visible    ${textbox_login_username}
