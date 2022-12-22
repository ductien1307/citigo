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
Resource          ../../../core/share/toast_message.robot
Resource          ../../../core/API/api_mhbh.robot
Resource          ../../../core/Giao_dich/hoa_don_list_action.robot

*** Variables ***
&{invoice_1}      TPD025=6

*** Test Cases ***
Cập nhật trong thời gian truy cập
    [Documentation]    Cập nhật trong thời gian truy cập > vẫn hd bình thường
    [Tags]      OPT1
    [Template]    cntg1
    [Timeout]     3 minutes
    an.nt    123     ${invoice_1}

Cập nhật ngoài thời gian truy cập
    [Documentation]    Cập nhật ngoài thời gian truy cập  > redirect đến trang báo ngoài giờ truy cập
    [Tags]      OPT1
    [Template]    cntg2
    [Timeout]     3 minutes
    an.nt    123     ${invoice_1}

Cập nhật trong thời gian truy câp thành ngoài thời gian truy cập
    [Documentation]    Cập nhật ngoài thời gian truy cập  > redirect đến trang báo ngoài giờ truy cập
    [Tags]      OPT1
    [Template]    cntg3
    [Timeout]     3 minutes
    an.nt    123     ${invoice_1}

Cập nhật ngoài thời gian truy câp thành trong thời gian truy cập
    [Documentation]   truy cập bt
    [Tags]      OPT1
    [Template]    cntg4
    [Timeout]     3 minutes
    an.nt    123

Cập nhật từ đang giới hạn thời gian truy cập -> ko giới han thời gian truy cập
    [Documentation]
    [Tags]    OPT1    
    [Template]    cntg5
    [Timeout]
    an.nt    123

*** Keywords ***
cntg1
    [Arguments]     ${taikhoan}    ${matkhau}    ${dict_product_num}
    Log    Cap nhat user co toan tg truy cap
    Update full time acesss thr API    ${taikhoan}
    #
    Log    Login MHBH với tk user và add sp
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    Before Test Ban Hang
    ${list_products}    Get Dictionary Keys    ${dict_product_num}
    ${list_nums}    Get Dictionary Values    ${dict_product_num}
    ${lastest_num}    Set Variable    0
    : FOR    ${item_product}     ${item_num}    IN ZIP    ${list_products}      ${list_nums}
    \    ${lastest_num}=    Input product-num in BH form    ${item_product}    ${item_num}      ${lastest_num}
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
    Log    thanh toan và check forge logout
    Click Element JS    ${button_bh_thanhtoan}
    Wait Until Keyword Succeeds    3 times    3s     Invoice message success validation

cntg2
    [Arguments]     ${taikhoan}    ${matkhau}    ${dict_product_num}
    Log    Cap nhat user co toan tg truy cap
    Update full time acesss thr API    ${taikhoan}
    #
    Log    Login MHBH với tk user và add sp
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    Before Test Ban Hang
    ${list_products}    Get Dictionary Keys    ${dict_product_num}
    ${list_nums}    Get Dictionary Values    ${dict_product_num}
    ${lastest_num}    Set Variable    0
    : FOR    ${item_product}     ${item_num}    IN ZIP    ${list_products}      ${list_nums}
    \    ${lastest_num}=    Input product-num in BH form    ${item_product}    ${item_num}      ${lastest_num}
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
    Log    thanh toan và check forge logout
    Click Element JS    ${button_bh_thanhtoan}
    Sleep    5s
    ${cur_url} =      Get Location
    ${exp_url}      Set Variable      ${URL}/sale/#/expire-time
    Should Be Equal    ${exp_url}     ${cur_url}

cntg3
    [Arguments]     ${taikhoan}    ${matkhau}     ${dict_product_num}
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
    Before Test Banhang By Sale URL
    ${list_products}    Get Dictionary Keys    ${dict_product_num}
    ${list_nums}    Get Dictionary Values    ${dict_product_num}
    ${lastest_num}    Set Variable    0
    : FOR    ${item_product}     ${item_num}    IN ZIP    ${list_products}      ${list_nums}
    \    ${lastest_num}=    Input product-num in BH form    ${item_product}    ${item_num}      ${lastest_num}
    #
    Log    Phan quyen ngoai thoi gian truy cap
    Update only accessible by time frame thr API    ${taikhoan}    ${get_day}    ${time_start_out_acc}    ${time_end_out_acc}
    #
    Click Element JS    ${button_bh_thanhtoan}
    Sleep    5s
    ${cur_url} =      Get Location
    ${exp_url}      Set Variable      ${URL}/sale/#/expire-time
    Should Be Equal    ${exp_url}     ${cur_url}

cntg4
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
    #
    Log    Login MHBH với tk user và add sp
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    ${SALE_URL}      Set Variable    ${URL}/sale/#/login
    Open Browser    ${SALE_URL}    ${BROWSER}    remote_url=${REMOTE_URL}
    Wait Until Keyword Succeeds    3 times    30 s    Access page    ${page_open}    Đăng nhập
    Maximize Browser Window
    Input Text    ${textbox_login_username}    ${USER_NAME}
    Input Text    ${textbox_login_password}    ${PASSWORD}
    Click Element JS    ${button_banhang_login}
    #
    Sleep    3s
    ${cur_url} =      Get Location
    ${exp_url}      Set Variable      ${URL}/limittime
    Should Be Equal    ${exp_url}     ${cur_url}
    #
    Log    Phan quyen trong thoi gian truy cap
    Update only accessible by time frame thr API    ${taikhoan}    ${get_day}    ${time_start_in_acc}    ${time_end_in_acc}
    #
    ${SALE_URL}     Set Variable     ${URL}/sale/#/
    Go To    ${SALE_URL}
    Wait Until Page Contains Element    ${textbox_bh_search_ma_sp}    50s

cntg5
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
    Log    Login MHBH với tk user và add sp
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    ${SALE_URL}      Set Variable    ${URL}/sale/#/login
    Open Browser    ${SALE_URL}    ${BROWSER}    remote_url=${REMOTE_URL}
    Wait Until Keyword Succeeds    3 times    30 s    Access page    ${page_open}    Đăng nhập
    Maximize Browser Window
    Input Text    ${textbox_login_username}    ${USER_NAME}
    Input Text    ${textbox_login_password}    ${PASSWORD}
    Click Element JS    ${button_banhang_login}
    #
    Sleep    3s
    ${cur_url} =      Get Location
    ${exp_url}      Set Variable      ${URL}/limittime
    Should Be Equal    ${exp_url}     ${cur_url}
    #
    Log    Phan quyen toan gioi gian truy cap
    Update full time acesss thr API    ${taikhoan}
    #
    ${SALE_URL}     Set Variable     ${URL}/sale/#/
    Go To    ${SALE_URL}
    Wait Until Page Contains Element    ${textbox_bh_search_ma_sp}    50s
