*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    ${headless_browser}
Test Setup
Test Teardown     After Test
Library           Collections
Library           DateTime
Resource          ../../../config/env_product/envi.robot
Resource          ../../../core/share/computation.robot
Resource          ../../../core/Giao_dich/giaodich_nav.robot
Resource          ../../../core/API/api_thietlap.robot
Resource          ../../../core/hang_hoa/hang_hoa_navigation.robot
Resource          ../../../core/hang_hoa/hang_hoa_add_action.robot
Resource          ../../../core/hang_hoa/danh_muc_list_action.robot

*** Variables ***

*** Test Cases ***
Cập nhật trong thời gian truy cập
    [Documentation]    Cập nhật trong thời gian truy cập > vẫn hd bình thường
    [Tags]      OPT1
    [Template]    cntgql1
    [Timeout]
    son.dx    123

Cập nhật ngoài thời gian truy cập
    [Documentation]    Cập nhật ngoài thời gian truy cập  > redirect đến trang báo ngoài giờ truy cập
    [Tags]      OPT1
    [Template]    cntgql2
    [Timeout]
    son.dx    123

Cập nhật trong thời gian truy câp thành ngoài thời gian truy cập
    [Documentation]    Cập nhật ngoài thời gian truy cập  > redirect đến trang báo ngoài giờ truy cập
    [Tags]      OPT1
    [Template]    cntgql3
    [Timeout]
    son.dx    123

Cập nhật ngoài thời gian truy câp thành trong thời gian truy cập
    [Documentation]   truy cập bt
    [Tags]
    [Template]    cntgql4
    [Timeout]
    son.dx    123

Cập nhật từ đang giới hạn thời gian truy cập -> ko giới han thời gian truy cập
    [Documentation]
    [Tags]
    [Template]    cntgql5
    [Timeout]
    son.dx    123

*** Keywords ***
cntgql1
    [Arguments]     ${taikhoan}    ${matkhau}
    Log    Cap nhat user co toan tg truy cap
    Update full time acesss thr API    ${taikhoan}
    #
    Log    Login MHBH với tk user và add sp
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    Before Test Hang Hoa
    #
    ${get_day}       Get Current Date      result_format=%A
    ${time_start}     Get Current Date
    ${time_end}     Add Time To Date    ${time_start}    1 hour
    ${time_start}     Convert Date    ${time_start}   result_format=%H:%M
    ${time_end}     Convert Date      ${time_end}     result_format=%H:%M
    #
    Log    Phan quyen trong thoi gian truy cap
    Update only accessible by time frame thr API    ${taikhoan}    ${get_day}    ${time_start}    ${time_end}
    #
    Log     check forge logout
    Click Element    ${button_them_moi}
    Wait Until Page Contains Element    ${button_them_hh}    10s
    Click Element       ${button_them_hh}
    Sleep    10s
    Element Should Not Be Visible        ${textbox_login_username}

cntgql2
    [Arguments]     ${taikhoan}    ${matkhau}
    Log    Cap nhat user co toan tg truy cap
    Update full time acesss thr API    ${taikhoan}
    #
    Log    Login MHBH với tk user và add sp
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    Before Test Hang Hoa
    #
    ${get_day}       Get Current Date      result_format=%A
    ${cur_time}     Get Current Date
    ${time_start}     Add Time To Date    ${cur_time}    1 hour
    ${time_end}     Add Time To Date    ${cur_time}    2 hour
    ${time_start}     Convert Date    ${time_start}   result_format=%H:%M
    ${time_end}     Convert Date      ${time_end}     result_format=%H:%M
    #
    Log    Phan quyen trong thoi gian truy cap
    Update only accessible by time frame thr API    ${taikhoan}    ${get_day}    ${time_start}    ${time_end}
    #
    Log    check forge logout
    Click Element    ${button_them_moi}
    Wait Until Page Contains Element    ${button_them_hh}    10s
    Click Element       ${button_them_hh}
    Sleep    5s
    ${cur_url} =      Get Location
    ${exp_url}      Set Variable      ${URL}/limittime
    Should Be Equal    ${exp_url}     ${cur_url}

cntgql3
    [Arguments]     ${taikhoan}    ${matkhau}
    ${get_day}       Get Current Date      result_format=%A
    ${cur_time}     Get Current Date
    ${time_end_in_acc}     Add Time To Date    ${cur_time}    1 hour
    ${time_start_in_acc}     Convert Date    ${cur_time}   result_format=%H:%M
    ${time_end_in_acc}     Convert Date      ${time_end_in_acc}     result_format=%H:%M
    ${time_start_out_acc}     Add Time To Date    ${cur_time}    2 hour
    ${time_end_out_acc}     Add Time To Date    ${cur_time}    3 hour
    ${time_start_out_acc}     Convert Date    ${time_start_out_acc}   result_format=%H:%M
    ${time_end_out_acc}     Convert Date      ${time_end_out_acc}     result_format=%H:%M
    #
    Log    Cap nhat trong thời gian truy cap
    Update only accessible by time frame thr API    ${taikhoan}    ${get_day}    ${time_start_in_acc}    ${time_end_in_acc}
    #
    Log    Login MHBH với tk user và add sp
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    Before Test Hang Hoa
    #
    Log    Phan quyen ngoai thoi gian truy cap
    Update only accessible by time frame thr API    ${taikhoan}    ${get_day}    ${time_start_out_acc}    ${time_end_out_acc}
    #
    Click Element    ${button_them_moi}
    Wait Until Page Contains Element    ${button_them_hh}    10s
    Click Element       ${button_them_hh}
    Sleep    5s
    ${cur_url} =      Get Location
    ${exp_url}      Set Variable      ${URL}/limittime
    Should Be Equal    ${exp_url}     ${cur_url}

cntgql4
    [Arguments]     ${taikhoan}    ${matkhau}
    ${get_day}       Get Current Date      result_format=%A
    ${cur_time}     Get Current Date
    ${time_end_in_acc}     Add Time To Date    ${cur_time}    1 hour
    ${time_start_in_acc}     Convert Date    ${cur_time}   result_format=%H:%M
    ${time_end_in_acc}     Convert Date      ${time_end_in_acc}     result_format=%H:%M
    ${time_start_out_acc}     Add Time To Date    ${cur_time}    2 hour
    ${time_end_out_acc}     Add Time To Date    ${cur_time}    3 hour
    ${time_start_out_acc}     Convert Date    ${time_start_out_acc}   result_format=%H:%M
    ${time_end_out_acc}     Convert Date      ${time_end_out_acc}     result_format=%H:%M
    #
    Log    Cap nhat ngoài thời gian truy cap
    Update only accessible by time frame thr API    ${taikhoan}    ${get_day}    ${time_start_out_acc}    ${time_end_out_acc}
    Sleep    5s
    #
    Log    Login MHBH với tk user và add sp
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    Open Browser    ${URL}    ${BROWSER}    remote_url=${REMOTE_URL}
    Wait Until Keyword Succeeds    3 times    30 s    Access page    ${page_open}    Đăng nhập
    Maximize Browser Window
    Input Text    ${textbox_login_username}    ${USER_NAME}
    Input Text    ${textbox_login_password}    ${PASSWORD}
    Click Button    ${button_quanly}
    #
    Sleep    5s
    ${cur_url} =      Get Location
    ${exp_url}      Set Variable      ${URL}/login
    Should Be Equal    ${exp_url}     ${cur_url}
    #
    Log    Phan quyen trong thoi gian truy cap
    Update only accessible by time frame thr API    ${taikhoan}    ${get_day}    ${time_start_in_acc}    ${time_end_in_acc}
    #
    Reload Page
    Wait Until Page Contains Element    ${menu_tongquan}    30s

cntgql5
    [Arguments]     ${taikhoan}    ${matkhau}
    ${get_day}       Get Current Date      result_format=%A
    ${cur_time}     Get Current Date
    ${time_start_out_acc}     Add Time To Date    ${cur_time}    2 hour
    ${time_end_out_acc}     Add Time To Date    ${cur_time}    3 hour
    ${time_start_out_acc}     Convert Date    ${time_start_out_acc}   result_format=%H:%M
    ${time_end_out_acc}     Convert Date      ${time_end_out_acc}     result_format=%H:%M
    #
    Log    Cap nhat ngoài thời gian truy cap
    Update only accessible by time frame thr API    ${taikhoan}    ${get_day}    ${time_start_out_acc}    ${time_end_out_acc}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    Open Browser    ${URL}    ${BROWSER}    remote_url=${REMOTE_URL}
    Wait Until Keyword Succeeds    3 times    30 s    Access page    ${page_open}    Đăng nhập
    Maximize Browser Window
    Input Text    ${textbox_login_username}    ${USER_NAME}
    Input Text    ${textbox_login_password}    ${PASSWORD}
    Click Button    ${button_quanly}
    #
    Sleep    5s
    ${cur_url} =      Get Location
    ${exp_url}      Set Variable      ${URL}/login
    Should Be Equal    ${exp_url}     ${cur_url}
    #
    Log    Phan quyen toan gioi gian truy cap
    Update full time acesss thr API    ${taikhoan}
    #
    Reload Page
    Wait Until Page Contains Element    ${menu_tongquan}    30s
