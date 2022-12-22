*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}      ${headless_browser}
Test Setup        Before Test Nha Cung Cap
Test Teardown     After Test
Resource          ../../../config/env_product/envi.robot
Resource          ../../../core/Doi_Tac/doitac_navigation.robot
Resource          ../../../core/Doi_Tac/ncc_list_action.robot
Resource          ../../../core/Doi_Tac/ncc_list_page.robot
Resource          ../../../core/API/api_nha_cung_cap.robot
Resource          ../../../core/Share/discount.robot
Resource          ../../../core/Share/toast_message.robot

*** Test Cases ***    Code    Name      Mobile    Address      Location      Ward       Email      Company       MST      Group       Note
Create new supplier        [Tags]                  CPL                 GOLIVE2            DT    TTS
                      [Template]              Create new supplier 01
                      CNCC001      Thái       0973872345       1B yết kiêu         Hà Nội - Quận Đống Đa      Phường Nam Đồng         ha@gmail.com          Công ty Thád      21213212       none         một thành viên

*** Keywords ***
Create new supplier 01
    [Arguments]       ${supplier_code}    ${input_supplier_name}    ${input_supplier_mobile}    ${input_supplier_address}      ${input_supplier_location}       ${input_supplier_ward}       ${input_supplier_email}       ${input_supplier_company}      ${input_supplier_mst}       ${input_supplier_group}      ${input_supplier_note}
    Wait Until Keyword Succeeds    3 times    3 s    Go to Add new supplier
    ${get_supplier_id}    Get Supplier Id    ${supplier_code}
    Run Keyword If    '${get_supplier_id}' == '0'    Log    Ignore delete     ELSE      Delete supplier    ${get_supplier_id}
    Wait until Element is Enabled       ${textbox_supplier_code}         10 s
    Set Focus to element       ${textbox_supplier_code}
    Wait Until Keyword Succeeds    3 times    3 s     Input data       ${textbox_supplier_code}       ${supplier_code}
    Wait Until Keyword Succeeds    3 times    3 s     Input data       ${textbox_supplier_name}       ${input_supplier_name}
    Run Keyword If    '${input_supplier_mobile}' == 'none'    Log     Ignore input      ELSE       Input data       ${textbox_suppliermobile}       ${input_supplier_mobile}
    Run Keyword If    '${input_supplier_address}' == 'none'    Log     Ignore input      ELSE       Input data       ${textbox_supplier_address}       ${input_supplier_address}
    Run Keyword If    '${input_supplier_location}' == 'none'    Log     Ignore input      ELSE       Input data    ${textbox_supplier_location}     ${input_supplier_location}
    Run Keyword If    '${input_supplier_ward}' == 'none'    Log     Ignore input      ELSE       Input data    ${textbox_supplier_ward}    ${input_supplier_ward}
    Run Keyword If    '${input_supplier_group}' == 'none'    Log     Ignore input      ELSE       Input data      ${textbox_supplier_group}      ${input_supplier_group}
    Run Keyword If    '${input_supplier_mst}' == 'none'    Log     Ignore input      ELSE       Input data    ${textbox_supplier_mst}      ${input_supplier_mst}
    Run Keyword If    '${input_supplier_company}' == 'none'    Log     Ignore input      ELSE       Input data    ${textbox_supplier_company}      ${input_supplier_company}
    Run Keyword If    '${input_supplier_email}' == 'none'    Log     Ignore input      ELSE       Input data    ${textbox_supplier_email}      ${input_supplier_email}
    Run Keyword If    '${input_supplier_note}' == 'none'    Log     Ignore input      ELSE       Input data    ${textbox_supplier_note}      ${input_supplier_note}
    Wait Until Element Is Enabled        ${button_supplier_luu}
    Click Element        ${button_supplier_luu}
    Create supplier message success validation
    Sleep          5 s
    ${supplier_id}      Get supplier info and validate    ${supplier_code}    ${input_supplier_name}    ${input_supplier_mobile}    ${input_supplier_address}    ${input_supplier_location}    ${input_supplier_ward}    ${input_supplier_email}      ${input_supplier_company}       ${input_supplier_note}
    Delete supplier    ${supplier_id}
