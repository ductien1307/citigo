*** Settings ***
Suite Setup       Init Test Environment Before Test Ban Hang Co API   ${env}    ${remote}    ${account}    ${headless_browser}
Test Teardown     Close Browser
Library           SeleniumLibrary
Resource          ../../../config/env_product/envi.robot
Resource          ../../../core/share/javascript.robot
Resource          ../../../core/Giao_Van/giao_hang_popup_action.robot
Resource          ../../../core/share/util_giaovan.robot
Resource          ../../../core/API/api_khachhang.robot
Resource          ../../../core/Ban_Hang/banhang_action.robot

*** Test Cases ***
Tim kiem tra widget
    [Documentation]     MHBH - KIỂM TRA HIỂN THỊ WIDGET SHIPPING
    [Tags]              GOLIVE3   UEB   CTP
    [Template]          Kiem tra hien thi widget shipping
    WGSHIP01

*** Keywords ***
Kiem tra hien thi widget shipping
    [Arguments]    ${customer_code}
    ${get_id_kh}    ${get_ten_kh}    ${get_dienthoai_kh}    ${get_diachi_kh}    Create new customer and get info    ${customer_code}
    Wait Until Keyword Succeeds    3x    5s    Input Khach Hang    ${customer_code}
    Click Element JS    ${checkbox_giaohang}
    Click Element JS    ${button_giaohang}
    : FOR    ${time}    IN RANGE    10
    \    Sleep    1s
    \    ${count}    Get Element Count     ${item_HVC}
    \    Exit For Loop If    '${count}'!='0'
    Run Keyword If    '${count}'=='0'    Run Keywords    Capture Page Screenshot    AND    Fail    Widget giao hàng không hoạt động. Hãy check lại shipping
    Delete customer    ${get_id_kh}
