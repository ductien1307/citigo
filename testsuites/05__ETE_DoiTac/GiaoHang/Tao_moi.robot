*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}      ${headless_browser}
Test Setup        Before Test Doi Tac Giao Hang
Test Teardown     After Test
Resource          ../../../config/env_product/envi.robot
Resource          ../../../core/Doi_Tac/doitac_navigation.robot
Resource          ../../../core/Doi_Tac/giaohang_list_action.robot
Resource          ../../../core/Doi_Tac/giaohang_list_page.robot
Resource          ../../../core/API/api_doi_tac_giaohang.robot
Resource          ../../../core/Share/discount.robot
Resource          ../../../core/Share/toast_message.robot

*** Test Cases ***    Mã ĐTGH    Type       Name      Mobile     Address      Location      Ward       Email       Group      Note
Create new deliverypartner        [Tags]                  CDG            GOLIVE2       DT
                      [Template]              Create new deliverypartner 01
                      DTGH01      Cá nhân       Thái       0973872123       1B yết kiêu        Hà Nội - Quận Đống Đa      Phường Nam Đồng         ha@gmail.com          none     Công ty Thád
                      DTGH02      Công ty       Hà         0978554457       none         none      none         none      none     Công ty Thád

*** Keywords ***
Create new deliverypartner 01
    [Arguments]    ${deliverypartner_code}    ${input_deliverypartner_type}       ${input_deliverypartner_name}    ${input_deliverypartner_mobile}    ${input_deliverypartner_address}      ${input_deliverypartner_location}       ${input_deliverypartner_ward}       ${input_deliverypartner_email}       ${input_deliverypartner_group}      ${input_deliverypartner_note}
    ${get_id_dtgh}    Get deliverypartner id frm api    ${deliverypartner_code}
    Run Keyword If    '${get_id_dtgh}' == '0'    Log    Ignore delete     ELSE      Delete DeliveryPartner    ${get_id_dtgh}
    Wait Until Keyword Succeeds    3 times    3 s    Go to Add new deliverypartner
    Select Delivery Partner Type    ${input_deliverypartner_type}
    Wait until Element is Enabled       ${textbox_deliverypartner_code}       10 s
    Set Focus to element       ${textbox_deliverypartner_code}
    Wait Until Keyword Succeeds    3 times    3 s     Input data       ${textbox_deliverypartner_code}       ${deliverypartner_code}
    Wait Until Keyword Succeeds    3 times    3 s     Input data       ${textbox_deliverypartner_name}       ${input_deliverypartner_name}
    Run Keyword If    '${input_deliverypartner_mobile}' == 'none'    Log     Ignore input      ELSE       Input data       ${textbox_deliverypartnermobile}       ${input_deliverypartner_mobile}
    Run Keyword If    '${input_deliverypartner_address}' == 'none'    Log     Ignore input      ELSE       Input data       ${textbox_deliverypartner_address}       ${input_deliverypartner_address}
    Run Keyword If    '${input_deliverypartner_location}' == 'none'    Log     Ignore input      ELSE       Input data      ${textbox_deliverypartner_location}     ${input_deliverypartner_location}
    Run Keyword If    '${input_deliverypartner_ward}' == 'none'    Log     Ignore input      ELSE       Input data    ${textbox_deliverypartner_ward}    ${input_deliverypartner_ward}
    Run Keyword If    '${input_deliverypartner_group}' == 'none'    Log     Ignore input      ELSE       Input data      ${textbox_deliverypartner_group}      ${input_deliverypartner_group}
    Run Keyword If    '${input_deliverypartner_email}' == 'none'    Log     Ignore input      ELSE       Input data    ${textbox_deliverypartner_email}      ${input_deliverypartner_email}
    Run Keyword If    '${input_deliverypartner_note}' == 'none'    Log     Ignore input      ELSE       Input data    ${textbox_deliverypartner_note}      ${input_deliverypartner_note}
    Wait Until Element Is Enabled        ${button_deliverypartner_luu}
    Click Element        ${button_deliverypartner_luu}
    Create delivery message success validation
    Sleep         5 s
    ${deliverypartner_id}      Get deliverypartner info and validate    ${deliverypartner_code}    ${input_deliverypartner_name}    ${input_deliverypartner_mobile}    ${input_deliverypartner_address}    ${input_deliverypartner_location}    ${input_deliverypartner_ward}    ${input_deliverypartner_email}      ${input_deliverypartner_note}
    Delete deliverypartner    ${deliverypartner_id}
