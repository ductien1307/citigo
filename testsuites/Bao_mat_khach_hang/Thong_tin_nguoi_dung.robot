*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}      ${headless_browser}
Test Teardown     After Test
Resource          ../../config/env_product/envi.robot
Resource          ../../core/Bao_mat_khach_hang/Bao_mat_KH_nav.robot
Resource          ../../core/Bao_mat_khach_hang/Bao_mat_KH_page.robot
Resource          ../../core/share/javascript.robot
Resource          ../../core/Ban_Hang/banhang_page.robot
Resource          ../../core/Ban_Hang/banhang_navigation.robot


*** Test Cases ***    Tên user
Sale login          [Tags]         BMKH3
                    [Template]              sale
                    admin

Manager login       [Tags]         BMKH3
                    [Template]              manager
                    admin

Manager login for user       [Tags]         BMKH3
                    [Template]              user
                    tester


*** Keywords ***
sale
    [Arguments]    ${user_name}
    [Timeout]
    Open Browser    ${URL}    ${BROWSER}    remote_url=${REMOTE_URL}
    Wait Until Keyword Succeeds    3 times    30 s    Access page    ${page_open}    Đăng nhập
    Maximize Browser Window
    Wait Until Keyword Succeeds    3 times    30 s    Login    ${USER_NAME}    ${PASSWORD}
    Wait Until Page Contains Element    ${button_banhang_on_quanly}    2 mins
    Click Element    ${button_banhang_on_quanly}
    Access page    //input[@placeholder='Tìm mặt hàng (F3)']    text
    Wait Until Page Contains Element    ${button_menubar}    2 mins
    Click Element JS    ${button_menubar}
    Wait Until Page Contains Element    ${cell_quanly}    2 mins
    Click Element JS    ${cell_quanly}
    Sleep    2s
    Go to Tai khoan popup    ${user_name}
    Sleep    1s
    ${get_device}   Get Text   ${label_device_info}
    Should Be Equal As Strings    ${get_device}    Máy tính Windows

manager
    [Arguments]    ${user_name}
    Open Browser    ${URL}    ${BROWSER}    remote_url=${REMOTE_URL}
    Wait Until Keyword Succeeds    3 times    30 s    Access page    ${page_open}    Đăng nhập
    Maximize Browser Window
    Wait Until Keyword Succeeds    3 times    30 s    Login    ${USER_NAME}    ${PASSWORD}
    Go to Tai khoan popup    ${user_name}
    Sleep    1s
    ${get_device}   Get Text   ${label_device_info}
    Should Be Equal As Strings    ${get_device}    Máy tính Windows

user
    [Arguments]    ${user_name}
    Open Browser    ${URL}    ${BROWSER}    remote_url=${REMOTE_URL}
    Wait Until Keyword Succeeds    3 times    30 s    Access page    ${page_open}    Đăng nhập
    Maximize Browser Window
    Wait Until Keyword Succeeds    3 times    30 s    Login    tester    123
    Sleep    2s
    Go to Tai khoan popup    ${user_name}
    Element Should Not Be Visible   ${label_device_info}   message=None
