*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}      ${headless_browser}
Test Setup        Get Authen OAuth API
Test Teardown     Run Keyword If Test Failed    Fail    Hãy check lại Webhook API!
Resource          ../../config/env_product/envi.robot
Resource          ../../core/API/api_public.robot
Resource          ../../core/API/api_khachhang.robot
Resource          ../../prepare/Hang_hoa/Sources/doitac.robot


*** Variables ***

*** Test Cases ***    Type      Mã KH     Tên update
Check Webhook
    [Tags]    CTP
    [Template]    webhk1
    [Documentation]   WEBHOOK - PUBLIC API - CHECK NOTIFICATIONS CUSTOMER.UPDATE
    customer.update     KHWH00001    AutoOlalaahahUpdate

*** Keyword ***
webhk1
    [Arguments]   ${input_type}   ${input_ma_kh}   ${name_update}
    Delete type Webhook     ${input_type}
    ${get_uuid}   Register Wehook     ${input_type}
    Delete customer if it exists    ${input_ma_kh}
    Add customers without contact number    ${input_ma_kh}    AutoOlalaahah
    Sleep  30s
    Update info customer    ${input_ma_kh}    ${name_update}
    Wait Until Keyword Succeeds    20x    30s     Assert data Webhook    ${get_uuid}    ${input_ma_kh}   ${name_update}
    Delete customer by Customer Code    ${input_ma_kh}
    Delete type Webhook     ${input_type}
