*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}      ${headless_browser}
Test Setup        Get Authen OAuth API
Test Teardown     Run Keyword If Test Failed    Fail    Hãy check lại Public API!
Resource          ../../config/env_product/envi.robot
Resource          ../../core/API/api_public.robot


*** Variables ***

*** Test Cases ***  Tên sp   Nhóm hàng
Thêm mới hàng hóa qua Public API
    [Tags]            CTP
    [Template]        pub1
    [Documentation]   PUBLIC API - MHQL - THÊM MỚI HÀNG HÓA
    Test Public API   Mỹ phẩm

*** Keyword ***
pub1
    [Arguments]   ${input_tenhh}      ${input_nhomhh}
    Get list product from Public API
    ${get_ma_sp}    Add new product from Public API    ${input_tenhh}      ${input_nhomhh}
    Delete product thr API    ${get_ma_sp}
