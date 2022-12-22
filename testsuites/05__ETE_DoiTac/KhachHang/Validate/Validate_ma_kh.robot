*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}      ${headless_browser}
Test Setup        Before Test Doi Tac Khach Hang
Test Teardown     After Test
Resource          ../../../../config/env_product/envi.robot
Resource          ../../../../core/Doi_Tac/doitac_navigation.robot
Resource          ../../../../core/Doi_Tac/khachhang_list_action.robot
Resource          ../../../../core/Doi_Tac/khachhang_list_page.robot
Resource          ../../../../core/API/api_khachhang.robot
Resource          ../../../../core/share/toast_message.robot

*** Test Cases ***    Customer Type   Mã KH           Tên kh
Trung ma kh            [Tags]            DTV
                       [Template]       khv02
                       Cá nhân        DHDPT009        Thu
                       Công ty        DHDPT008        Thảo

*** Keywords ***
khv02
    [Arguments]    ${input_customer_type}       ${customer_code}      ${input_customer_name}
    Go to Add new Customer
    Select Customer Type    ${input_customer_type}
    Wait Until Page Contains Element        ${textbox_customercode}        15s
    Set Focus to element       ${textbox_customercode}
    Input Text       ${textbox_customercode}       ${customer_code}
    Input Text       ${textbox_customername}       ${input_customer_name}
    Click Element        ${button_customer_luu}
    ${result_message}     Format String       Mã khách hàng {0} đã tồn tại trong hệ thống.    ${customer_code}
    Wait Until Page Contains Element    ${toast_message}    20s
    Element Should Contain    ${toast_message}      ${result_message}
    Reload Page
