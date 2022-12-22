*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}      ${headless_browser}
Test Setup        Before Test QLKV      admin@kiotviet.com      123456
Test Teardown     After Test
Resource          ../../config/env_product/envi.robot
Resource          ../../core/QLKV/qlkv_list_action.robot
Resource          ../../core/share/Computation.robot
Resource          ../../core/API/api_qlkv.robot
Resource          ../../core/share/toast_message.robot
Resource          ../../core/share/discount.robot

*** Variables ***

*** Test Cases ***
Check tab Feature Management
    [Tags]    QLKV
    [Template]    eqlkv2
    List Retailers     Feature Management      Cho phép sử dụng Token API

Check tab Branches
    [Tags]    QLKV
    [Template]    eqlkv3
    @{EMPTY}

Check tab Audit trail
    [Tags]    QLKV
    [Template]    eqlkv4
    List Retailers     Audit Trail       admin@kiotviet.com

*** Keyword ***
eqlkv2
    [Arguments]     ${domain}       ${tab}      ${text}
    Go to menu QLKV until succeed       ${domain}
    KV Click Element    ${cell_retail_first_row}
    KV Click Element By Code    ${button_form_retailer}   ${tab}
    Wait Until Keyword Succeeds    5x    5s    Element Should Contain      ${body_form_retailer}   ${text}

eqlkv3
    Go to menu QLKV until succeed    List Retailers
    KV Click Element    ${cell_retail_first_row}
    KV Click Element By Code    ${button_form_retailer}    Branches
    Click branch and wait button lock appear

eqlkv4
    [Arguments]     ${domain}       ${tab}      ${text}
    Go to menu QLKV until succeed       ${domain}
    KV Click Element    ${cell_retail_first_row}
    KV Click Element By Code    ${button_form_retailer}   ${tab}
    Wait Until Keyword Succeeds    5x    5s    Element Should Contain      //div[@id='grdLogRetailersCpanel']//table[@role='treegrid']//tbody   ${text}
