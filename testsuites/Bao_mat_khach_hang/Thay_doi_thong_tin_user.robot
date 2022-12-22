*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}      ${headless_browser}
Test Teardown     After Test
Resource          ../../config/env_product/envi.robot
Resource          ../../core/Bao_mat_khach_hang/Bao_mat_KH_nav.robot
Resource          ../../core/Bao_mat_khach_hang/Bao_mat_KH_page.robot
Resource          ../../core/share/javascript.robot
Resource          ../../core/Ban_Hang/banhang_page.robot
Resource          ../../core/Ban_Hang/banhang_navigation.robot
Resource          ../../core/share/toast_message.robot
Resource         ../../core/API/api_thietlap.robot
Resource         ../../core/API/api_access.robot
Resource         ../../prepare/Hang_hoa/Sources/thietlap.robot


*** Test Cases ***    Tên user    Pass        Role                Phone             Email
Force manager          [Tags]         BMKH2
                    Open Browser    ${URL}    ${BROWSER}    remote_url=${REMOTE_URL}
                    Wait Until Keyword Succeeds    3 times    30 s    Access page    ${page_open}    Đăng nhập
                    Maximize Browser Window
                    Wait Until Keyword Succeeds    3 times    30 s    Login    ${USER_NAME}    ${PASSWORD}
                    Go to Tai khoan popup    ${USER_NAME}
                    Delete device
                    Sleep    2s
                    Wait Until Element Is Visible    ${textbox_login_username}

Sale login          [Tags]         BMKH2
                    [Template]              sale
                    0987654321      abc@gmail.com

*** Keywords ***
sale
    [Arguments]    ${input_phone}    ${input_email}
    ${get_phone}    Get phone frm user api    ${USER_NAME}
    Run Keyword If    '${get_phone}' == '0'    Log      Ignore input    ELSE    Update user info frm tai khoan popup     ${USER_NAME}    ${EMPTY}    ${EMPTY}
    Open Browser    ${URL}    ${BROWSER}    remote_url=${REMOTE_URL}
    Wait Until Keyword Succeeds    3 times    30 s    Access page    ${page_open}    Đăng nhập
    Maximize Browser Window
    Wait Until Keyword Succeeds    3 times    30 s    Login    ${USER_NAME}    ${PASSWORD}
    Go to Tai khoan popup    ${user_name}
    Input data      ${textbox_dienthoai}    ${input_phone}
    Input data      ${textbox_email}    ${input_email}
    Click Element    ${button_luu_bmkh}
    Sleep    2s
    Update user info frm tai khoan popup     ${USER_NAME}    ${EMPTY}    ${EMPTY}
