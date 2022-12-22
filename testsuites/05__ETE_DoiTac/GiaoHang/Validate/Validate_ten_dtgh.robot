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

*** Test Cases ***      Type
Ko nhap ten dtgh        [Tags]               DTV
                        [Template]            dtghv1
                        Cá nhân
                        #Công ty

*** Keywords ***
dtghv1
    [Arguments]    ${input_deliverypartner_type}
    Wait Until Keyword Succeeds    3 times    3 s    Go to Add new deliverypartner
    ${deliverypartner_code}      Generate Random String    4    [UPPER][NUMBERS]
    ${deliverypartner_code}      Catenate      SEPARATOR=      DTGH     ${deliverypartner_code}
    Select Delivery Partner Type    ${input_deliverypartner_type}
    Wait Until Page Contains Element        ${textbox_deliverypartner_code}       15s
    Set Focus to element       ${textbox_deliverypartner_code}
    Wait Until Keyword Succeeds    3 times    3 s     Input data       ${textbox_deliverypartner_code}       ${deliverypartner_code}
    Wait Until Element Is Enabled        ${button_deliverypartner_luu}
    Click Element        ${button_deliverypartner_luu}
    Wait Until Page Contains Element    ${toast_message}    20s
    Element Should Contain    ${toast_message}      Tên đối tác giao hàng không được để trống
    Reload Page
