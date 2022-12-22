*** Settings ***
Test Setup       Init Test Direct Page    ${env}    ${remote}
Library          SeleniumLibrary
Test Teardown     After Test
Resource         ../../config/env_product/envi.robot

*** Test Cases ***
Direct to fnb url                   [Tags]                 LID      GOLIVE2
                      [Template]          th1_direct
                      testfnbz16

Typing fnb url directly             [Tags]                 LID      GOLIVE2
                      [Template]          th2_direct
                      https://testfnbz16.kiotviet.vn

Direct to retailer url                   [Tags]                 LID     GOLIVE2
                      [Template]          th3_direct
                      auto1

*** Keywords ***
th1_direct
    [Arguments]        ${kv_name}
    Open Browser    https://kiotviet.vn       ${BROWSER}       remote_url=${REMOTE_URL}
    Maximize Browser Window
    Go to Access KV Account
    Access KV Account by typing KV Name        ${kv_name}
    ${cur_url1} =      Execute Javascript      return window.location.href
    ${cur_url2} =      Get Location
    Should Be Equal    https://fnb.kiotviet.vn/login?redirect=%2f#f=Unauthorized      ${cur_url2}

th2_direct
    [Arguments]        ${fnb_url}
    Open Browser      ${fnb_url}      ${BROWSER}       remote_url=${REMOTE_URL}
    Maximize Browser Window
    Sleep    10 s
    ${cur_url2} =      Get Location
    Should Be Equal    https://fnb.kiotviet.vn/login?redirect=%2f#f=Unauthorized      ${cur_url2}

th3_direct
    [Arguments]        ${kv_name}
    Open Browser    https://kiotviet.vn       ${BROWSER}       remote_url=${REMOTE_URL}
    Go to Access KV Account
    Access KV Account by typing KV Name        ${kv_name}
    ${cur_url1} =      Execute Javascript      return window.location.href
    ${cur_url2} =      Get Location
    Should Be Equal    https://auto1.kiotviet.vn/man/#/login     ${cur_url2}
