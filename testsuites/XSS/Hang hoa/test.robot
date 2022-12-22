*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}      ${headless_browser}
Test Setup        Before Test Hang Hoa
Test Teardown     After Test
Resource          ../../../core/hang_hoa/hang_hoa_add_action.robot
Resource          ../../../core/hang_hoa/hang_hoa_add_page.robot
Resource          ../../../core/share/toast_message.robot
Resource          ../../../config/env_product/envi.robot
Resource          ../../../core/hang_hoa/danh_muc_list_action.robot
Resource          ../../../prepare/Hang_hoa/Sources/hanghoa.robot

*** Variables ***

*** Test Cases ***
Them moi NH            [Tags]
                      [Template]       xss1
                      <script>alert(2)</script>

Them moi HH            [Tags]        xss
                      [Template]       xss2
                      <script>alert(2)</script>     <script>alert(2)</script>     Dịch vụ

*** Keyword ***
xss1
    [Arguments]    ${nhom_hang}
    ${get_id_nh}    Get category ID      ${nhom_hang}
    Run Keyword If    '${get_id_nh}'=='0'    Log    Ignore cat    ELSE       Delete category thr API    ${nhom_hang}
    Reload Page
    Add new category thr UI    ${nhom_hang}
    ${status}     Run Keyword And Return Status      Alert Should Not Be Present
    Run Keyword If    '${status}'=='False'    Handle Alert   action=ACCEPT
    Delete category thr API    ${nhom_hang}
    Should Be Equal As Strings    ${status}    True
    Reload Page

xss2
    [Arguments]      ${ma_hh}    ${ten_hanghoa}    ${nhom_hang}
    ${get_pr_id}    Get product ID    ${ma_hh}
    Run Keyword If    '${get_pr_id}'=='0'    Log    Ignore pr    ELSE       Delete product thr API    ${ma_hh}
    Reload Page
    Go to Them moi Hang Hoa
    Input data in Them hang hoa form    ${ma_hh}    ${ten_hanghoa}    ${nhom_hang}    0     0       0
    Click Element    ${button_luu}
    Wait Until Page Contains Element    //button[@class='btn-confirm btn btn-success']      30s
    Click Element     //button[@class='btn-confirm btn btn-success']
    ${status}     Run Keyword And Return Status      Alert Should Not Be Present
    Run Keyword If    '${status}'=='False'    Handle Alert   action=ACCEPT
    Delete product thr API    ${ma_hh}
    Should Be Equal As Strings    ${status}    True
    Reload Page
