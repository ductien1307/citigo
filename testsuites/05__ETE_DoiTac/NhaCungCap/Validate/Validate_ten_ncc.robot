*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}      ${headless_browser}
Test Setup        Before Test Nha Cung Cap
Test Teardown     After Test
Resource          ../../../../config/env_product/envi.robot
Resource          ../../../../core/Doi_Tac/doitac_navigation.robot
Resource          ../../../../core/Doi_Tac/ncc_list_action.robot
Resource          ../../../../core/Doi_Tac/ncc_list_page.robot
Resource          ../../../../core/API/api_nha_cung_cap.robot
Resource          ../../../../core/Share/discount.robot
Resource          ../../../../core/share/toast_message.robot

*** Test Cases ***
Ko nhap ten ncc           [Tags]                 DTV
                          [Template]              nccv1
                          1
                          2

*** Keywords ***
nccv1
    [Arguments]    ${index}
    Wait Until Keyword Succeeds    3 times    3 s    Go to Add new supplier
    ${supplier_code}      Generate Random String    4    [UPPER][NUMBERS]
    ${supplier_code}      Catenate      SEPARATOR=      KH     ${supplier_code}
    Wait Until Page Contains Element       ${textbox_supplier_code}         15s
    Set Focus to element       ${textbox_supplier_code}
    Wait Until Keyword Succeeds    3 times    3 s     Input data       ${textbox_supplier_code}       ${supplier_code}
    Wait Until Element Is Enabled        ${button_supplier_luu}
    Click Element        ${button_supplier_luu}
    Wait Until Page Contains Element    ${toast_message}    20s
    Element Should Contain    ${toast_message}    Bạn chưa nhập Tên nhà cung cấp
    Reload Page
