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

*** Test Cases ***    Customer Type    Tên kh       Sdt
Trung sdt kh          [Tags]            DTV
                      [Template]       khv03
                       Cá nhân         Thu          921223638
                       Công ty         Thảo         921223639

*** Keywords ***
khv03
    [Arguments]    ${input_customer_type}       ${input_customer_name}      ${input_customer_mobile}
    Go to Add new Customer
    Select Customer Type    ${input_customer_type}
    Wait Until Page Contains Element        ${textbox_customercode}        15s
    Set Focus to element       ${textbox_customercode}
    ${customer_code}      Generate Random String    4    [UPPER][NUMBERS]
    ${customer_code}      Catenate      SEPARATOR=      KH     ${customer_code}
    Input Text       ${textbox_customercode}       ${customer_code}
    Input Text       ${textbox_customername}       ${input_customer_name}
    Input Text       ${textbox_customermobile}       ${input_customer_mobile}
    Click Element        ${button_customer_luu}
    ${result_message}     Format String       Số điện thoại {0} đã tồn tại trong hệ thống.    ${input_customer_mobile}
    Wait Until Page Contains Element    ${toast_message}    20s
    Element Should Contain    ${toast_message}      ${result_message}
    Reload Page
