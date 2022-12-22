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

*** Test Cases ***    Customer Type
Ko nhap ten kh        [Tags]           DTV
                      [Template]       khv01
                       Cá nhân
                       Công ty

*** Keywords ***
khv01
    [Arguments]    ${input_customer_type}
    Go to Add new Customer
    Select Customer Type    ${input_customer_type}
    Wait Until Page Contains Element       ${textbox_customercode}        15s
    ${customer_code}      Generate Random String    4    [UPPER][NUMBERS]
    ${customer_code}      Catenate      SEPARATOR=      KH     ${customer_code}
    Set Focus to element       ${textbox_customercode}
    Input Text       ${textbox_customercode}       ${customer_code}
    Click Element        ${button_customer_luu}
    Wait Until Page Contains Element    ${toast_message}    20s
    Element Should Contain    ${toast_message}      Bạn chưa nhập Tên khách hàng
    Reload Page
