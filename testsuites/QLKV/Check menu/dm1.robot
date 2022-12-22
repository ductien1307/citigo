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
Check menu
    [Tags]       QLKV
    [Template]    eqldm1
    Applications    Website
    Clients         true
    Renew List      Gói nâng cao
    Delivery        Giao hàng nhanh
    Feature configuration      Giá vốn trung bình

Check menu Contracts
    [Tags]      QLKV
    [Template]    eqldm2
    @{EMPTY}

Check menu Google Business
    [Tags]      QLKV
    [Template]    eqldm3
    @{EMPTY}

*** Keyword ***
eqldm1
    [Arguments]   ${menu}   ${text}
    Go to menu QLKV until succeed   ${menu}
    Wait Until Keyword Succeeds    5x    5s    Element Should Contain       ${body_form_retailer}   ${text}

eqldm2
    Go to menu QLKV until succeed    Contracts
    Wait Until Keyword Succeeds    5x    5s    Element Should Contain     //div[@class='k-grid-content k-auto-scrollable']      Không tìm thấy dữ liệu

eqldm3
    Go to menu QLKV until succeed    Google Business
    Wait Until Keyword Succeeds    5x    5s    Element Should Contain     //article[@class='boxForm uln ovh mb10']    Auth with kiotviet.gmb@gmail.com
    Wait Until Keyword Succeeds    2x    5s    Element Should Contain     //article[@class='boxForm uln ovh mb10']    Auth with kiotviet.gmb.operation@gmail.com
