*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}      ${headless_browser}
Test Setup        Before Test QLKV      admin@kiotviet.com      123456
Test Teardown     After Test
Resource          ../../../config/env_product/envi.robot
Resource          ../../../core/QLKV/qlkv_list_action.robot
Resource          ../../../core/share/Computation.robot
Resource          ../../../core/API/api_qlkv.robot
Resource          ../../../core/share/toast_message.robot
Resource          ../../../core/share/discount.robot

*** Variables ***

*** Test Cases ***
Check menu 1
    [Tags]      QLKV
    [Template]    eqldm3
    Services       Adayroi Application     myanh
    Services       Webhook     myanh
    Others         Audit Trail      Đăng nhập vào hệ thống
    Others         SMS Report       Không tìm thấy kết quả nào phù hợp
    Others         Notifications Campain     Đã gửi
    Others         Manage Account       Đang hoạt động

Check menu 2
    [Tags]      QLKV
    [Template]    eqldm4
    Others         System Config      Thời gian kết thúc
    Others         Log Config         Enable Write Request
    Others         Manage KvAA        Update date

Check menu 3
    [Tags]      QLKV
    [Template]    eqldm5
    Others         Log Printer       Tên chi nhánh

*** Keyword ***
eqldm3
    [Arguments]   ${menu}   ${domain}     ${text}
    Go to domain QLKV until succeed     ${menu}      ${domain}
    Wait Until Keyword Succeeds    5x    5s    Element Should Contain       //div[@class='k-grid-content k-auto-scrollable']    ${text}

eqldm4
    [Arguments]   ${menu}   ${domain}     ${text}
    Go to domain QLKV until succeed      ${menu}      ${domain}
    Wait Until Keyword Succeeds    5x    5s    Element Should Contain       //ul[@class='formBox ovh fr']    ${text}

eqldm5
    [Arguments]   ${menu}   ${domain}     ${text}
    Go to domain QLKV until succeed      ${menu}      ${domain}
    Wait Until Keyword Succeeds    5x    5s    Element Should Contain       //div[contains(@class,'k-grid-header-wrap k-auto-scrollable')]//table[contains(@role,'grid')]    ${text}
