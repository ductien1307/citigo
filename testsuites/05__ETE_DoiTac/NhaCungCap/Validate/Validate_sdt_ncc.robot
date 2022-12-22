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

*** Test Cases ***        Tên ncc               Sdt
Trung sdt nccv1           [Tags]                 DTV
                          [Template]              nccv3
                          NCC Thịnh Vượng       0977654892
                          NCC Sao Khuê          0977654891

*** Keywords ***
nccv3
    [Arguments]     ${input_supplier_name}      ${input_supplier_mobile}
    Wait Until Keyword Succeeds    3 times    3 s    Go to Add new supplier
    ${supplier_code}      Generate Random String    4    [UPPER][NUMBERS]
    ${supplier_code}      Catenate      SEPARATOR=      KH     ${supplier_code}
    Wait Until Page Contains Element       ${textbox_supplier_code}         15s
    Set Focus to element       ${textbox_supplier_code}
    Wait Until Keyword Succeeds    3 times    3 s     Input data       ${textbox_supplier_code}       ${supplier_code}
    Wait Until Keyword Succeeds    3 times    3 s     Input data       ${textbox_supplier_name}       ${input_supplier_name}
    Wait Until Keyword Succeeds    3 times    3 s     Input data       ${textbox_suppliermobile}       ${input_supplier_mobile}
    Click Element        ${button_supplier_luu}
    ${result_message}     Format String    Số điện thoại {0} đã tồn tại trong hệ thống      ${input_supplier_mobile}
    Wait Until Page Contains Element    ${toast_message}    20s
    Element Should Contain    ${toast_message}      ${result_message}
    Reload Page
