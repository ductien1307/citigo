*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}      ${headless_browser}
Test Setup        Before Test Doi Tac Giao Hang
Test Teardown     After Test
Resource          ../../../../config/env_product/envi.robot
Resource          ../../../../core/Doi_Tac/doitac_navigation.robot
Resource          ../../../../core/Doi_Tac/giaohang_list_action.robot
Resource          ../../../../core/Doi_Tac/giaohang_list_page.robot
Resource          ../../../../core/API/api_doi_tac_giaohang.robot
Resource          ../../../../core/Share/discount.robot
Resource          ../../../../core/share/toast_message.robot

*** Test Cases ***      Type             Mã dtgh         Tên dtgh
Trung ma dtghv3          [Tags]               DTV
                        [Template]           dtghv2
                        #Cá nhân          DT00001          GH siêu tốc
                        Công ty          DT00002          Grab

*** Keywords ***
dtghv2
    [Arguments]    ${input_deliverypartner_type}      ${input_deliverypartner_code}      ${input_deliverypartner_name}
    Wait Until Keyword Succeeds    3 times    3 s    Go to Add new deliverypartner
    Select Delivery Partner Type    ${input_deliverypartner_type}
    Wait Until Page Contains Element       ${textbox_deliverypartner_code}       15s
    Set Focus to element       ${textbox_deliverypartner_code}
    Wait Until Keyword Succeeds    3 times    3 s     Input data       ${textbox_deliverypartner_code}       ${input_deliverypartner_code}
    Wait Until Keyword Succeeds    3 times    3 s     Input data       ${textbox_deliverypartner_name}       ${input_deliverypartner_name}
    Wait Until Element Is Enabled        ${button_deliverypartner_luu}
    ${result_message}    Format String    Mã đối tác giao hàng {0} đã tồn tại trong hệ thống    ${input_deliverypartner_code}
    Click Element        ${button_deliverypartner_luu}
    Wait Until Page Contains Element    ${toast_message}    20s
    Element Should Contain    ${toast_message}      ${result_message}
    Reload Page
