*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}      ${headless_browser}
Test Teardown     After Test
Library           SeleniumLibrary
Resource          ../../config/env_product/envi.robot
Resource          ../../core/Bao_mat_khach_hang/Bao_mat_KH_nav.robot
Resource          ../../core/Bao_mat_khach_hang/Bao_mat_KH_page.robot
Resource          ../../core/share/javascript.robot
Resource          ../../core/login/login_page.robot
Resource          ../../core/login/login_action.robot
Resource          ../../core/share/toast_message.robot
Resource         ../../core/API/api_thietlap.robot
Resource         ../../prepare/Hang_hoa/Sources/thietlap.robot


*** Test Cases ***    Tên user     Email    Phone
Email null          [Tags]         BMKH1
                    [Template]              forgetpass1
                    admin

Email               [Tags]         BMKH1
                    [Template]              forgetpass2
                    admin         xyz@gmail.com

Email and Phone               [Tags]         BMKH1
                    [Template]              forgetpass3
                    admin         xyz@gmail.com       0981234567
*** Keywords ***
forgetpass1
    [Arguments]     ${input_ten_user}
    Open Browser    ${URL}    ${BROWSER}    remote_url=${REMOTE_URL}
    Wait Until Keyword Succeeds    3 times    30 s    Access page    ${page_open}    Đăng nhập
    Maximize Browser Window
    Sleep    2s
    Click Element    ${link_quenmatkhau}
    Input text      ${textbox_username_QMK}     ${input_ten_user}
    Click Element    ${button_laymatkhau_popup}
    Wait Until Element Is Visible     ${label_notifi_error}   2 min
    Page Should Contain        KiotViet không thể gửi email thiết lập lại mật khẩu do bạn chưa có thông tin email trong hệ thống.

forgetpass2
    [Arguments]    ${input_ten_user}     ${input_email}
    Update user info frm tai khoan popup    ${input_ten_user}    ${input_email}    ${EMPTY}
    Open Browser    ${URL}    ${BROWSER}    remote_url=${REMOTE_URL}
    Wait Until Keyword Succeeds    3 times    30 s    Access page    ${page_open}    Đăng nhập
    Maximize Browser Window
    Sleep    2s
    Click Element    ${link_quenmatkhau}
    Input text      ${textbox_username_QMK}     ${input_ten_user}
    Click Element    ${button_laymatkhau_popup}
    ${toast_message}    Format String    Chúng tôi vừa gửi cho bạn email hướng dẫn đặt lại mật khẩu vào địa chỉ {0}.     ${input_email}
    Wait Until Element Is Visible     ${label_notifi_error}   2 min
    Page Should Contain    ${toast_message}
    Update user info frm tai khoan popup    ${input_ten_user}    ${EMPTY}    ${EMPTY}

forgetpass3
    [Arguments]    ${input_ten_user}     ${input_email}   ${input_phone}
    Update user info frm tai khoan popup    ${input_ten_user}    ${input_email}    ${input_phone}
    Open Browser    ${URL}    ${BROWSER}    remote_url=${REMOTE_URL}
    Wait Until Keyword Succeeds    3 times    30 s    Access page    ${page_open}    Đăng nhập
    Maximize Browser Window
    Sleep    2s
    Click Element    ${link_quenmatkhau}
    Input text      ${textbox_username_QMK}     ${input_ten_user}
    Click Element    ${button_laymatkhau_popup}
    ${toast_message}    Format String    Chúng tôi vừa gửi cho bạn email hướng dẫn đặt lại mật khẩu vào địa chỉ {0}.     ${input_email}
    Wait Until Element Is Visible     ${label_notifi_error}   2 min
    Page Should Contain    ${toast_message}
    Update user info frm tai khoan popup    ${input_ten_user}    ${EMPTY}    ${EMPTY}
