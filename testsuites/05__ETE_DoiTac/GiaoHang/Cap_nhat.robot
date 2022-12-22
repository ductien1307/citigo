*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}      ${headless_browser}
Test Setup
Test Teardown     After Test
Resource          ../../../config/env_product/envi.robot
Resource          ../../../core/Doi_Tac/doitac_navigation.robot
Resource          ../../../core/Doi_Tac/giaohang_list_action.robot
Resource          ../../../core/Doi_Tac/giaohang_list_page.robot
Resource          ../../../core/API/api_doi_tac_giaohang.robot
Resource          ../../../core/Share/discount.robot
Resource          ../../../prepare/Hang_hoa/Sources/doitac.robot
Resource          ../../../core/Thiet_lap/khuyenmai_list_page.robot
Resource         ../../../core/share/toast_message.robot


*** Test Cases ***    Code    Name      Mobile          Type            Address             Location                Ward                      Email                Group      Note
Update deliverypartner        [Tags]                  CDG             DT
                      [Template]              update_deli
                       DTGH02      Hào       0973873456     Công ty       1B yết kiêu        Hà Nội - Quận Đống Đa      Phường Nam Đồng         ha@gmail.com          none     Công ty Cosmetics

Delete deliverypartner        [Tags]                  CDG              DT
                      [Template]              del_deli
                       DTGH03      Huy       0988765787

Unactive deliverypartner        [Tags]                  CDG              DT
                     [Template]              active_deli
                      DTGH04      Hạnh       0912367890

*** Keywords ***
update_deli
    [Arguments]    ${deliverypartner_code}    ${input_deliverypartner_name}    ${input_deliverypartner_mobile}    ${input_deliverypartner_type}    ${input_deliverypartner_address}
    ...      ${input_deliverypartner_location}       ${input_deliverypartner_ward}       ${input_deliverypartner_email}       ${input_deliverypartner_group}      ${input_deliverypartner_note}
    ${get_id_dtgh}    Get deliverypartner id frm api    ${deliverypartner_code}
    Run Keyword If    '${get_id_dtgh}' == '0'    Log    Ignore delete     ELSE      Delete DeliveryPartner    ${get_id_dtgh}
    Add partner delivery    ${deliverypartner_code}    ${input_deliverypartner_name}    ${input_deliverypartner_mobile}
    Wait Until Keyword Succeeds    3 times    3 s    Before Test Doi Tac Giao Hang
    Wait Until Keyword Succeeds    3 times    3 s    Go to udpate delivery partner    ${deliverypartner_code}
    Select Delivery Partner Type    ${input_deliverypartner_type}
    Run Keyword If    '${input_deliverypartner_address}' == 'none'    Log     Ignore input      ELSE       Input data       ${textbox_deliverypartner_address}       ${input_deliverypartner_address}
    Run Keyword If    '${input_deliverypartner_location}' == 'none'    Log     Ignore input      ELSE       Input data      ${textbox_deliverypartner_location}     ${input_deliverypartner_location}
    Run Keyword If    '${input_deliverypartner_ward}' == 'none'    Log     Ignore input      ELSE       Input data    ${textbox_deliverypartner_ward}    ${input_deliverypartner_ward}
    Run Keyword If    '${input_deliverypartner_group}' == 'none'    Log     Ignore input      ELSE       Input data      ${textbox_deliverypartner_group}      ${input_deliverypartner_group}
    Run Keyword If    '${input_deliverypartner_email}' == 'none'    Log     Ignore input      ELSE       Input data    ${textbox_deliverypartner_email}      ${input_deliverypartner_email}
    Run Keyword If    '${input_deliverypartner_note}' == 'none'    Log     Ignore input      ELSE       Input data    ${textbox_deliverypartner_note}      ${input_deliverypartner_note}
    Wait Until Element Is Enabled        ${button_deliverypartner_luu}
    Click Element        ${button_deliverypartner_luu}
    Sleep          20 s
    ${deliverypartner_id}      Get deliverypartner info and validate    ${deliverypartner_code}    ${input_deliverypartner_name}    ${input_deliverypartner_mobile}    ${input_deliverypartner_address}    ${input_deliverypartner_location}    ${input_deliverypartner_ward}    ${input_deliverypartner_email}      ${input_deliverypartner_note}
    Delete deliverypartner    ${deliverypartner_id}

del_deli
    [Arguments]    ${deliverypartner_code}       ${input_deliverypartner_name}    ${input_deliverypartner_mobile}
    ${get_id_dtgh}    Get deliverypartner id frm api    ${deliverypartner_code}
    Run Keyword If    '${get_id_dtgh}' == '0'    Log    Ignore delete     ELSE      Delete DeliveryPartner    ${get_id_dtgh}
    Add partner delivery    ${deliverypartner_code}    ${input_deliverypartner_name}    ${input_deliverypartner_mobile}
    Wait Until Keyword Succeeds    3 times    3 s    Before Test Doi Tac Giao Hang
    Wait Until Keyword Succeeds    3 times    3 s    Search delivery partner    ${deliverypartner_code}
    Sleep    3s
    Wait Until Page Contains Element    ${button_delete_delivery}    2 mins
    Click Element JS    ${button_delete_delivery}
    Wait Until Page Contains Element    ${button_dongy_del_promo}    2 mins
    Click Element JS    ${button_dongy_del_promo}
    Wait Until Page Contains Element    ${toast_message}
    ${msg}    Format String    Xóa đối tác giao hàng {0} thành công    ${input_deliverypartner_name}
    Element Should Contain    ${toast_message}    ${msg}

active_deli
    [Arguments]    ${deliverypartner_code}       ${input_deliverypartner_name}    ${input_deliverypartner_mobile}
    ${get_id_dtgh}    Get deliverypartner id frm api    ${deliverypartner_code}
    Run Keyword If    '${get_id_dtgh}' == '0'    Log    Ignore delete     ELSE      Delete DeliveryPartner    ${get_id_dtgh}
    Add partner delivery    ${deliverypartner_code}    ${input_deliverypartner_name}    ${input_deliverypartner_mobile}
    Wait Until Keyword Succeeds    3 times    3 s    Before Test Doi Tac Giao Hang
    Wait Until Keyword Succeeds    3 times    3 s    Search delivery partner    ${deliverypartner_code}
    Sleep    3s
    Wait Until Page Contains Element    ${button_active_delivery}    2 mins
    Click Element JS    ${button_active_delivery}
    Wait Until Page Contains Element    ${button_dongy_del_promo}    2 mins
    Click Element JS    ${button_dongy_del_promo}
    Sleep    3s
    ${resp}       Get Request and return body    ${endpoint_dtgh}
    ${jsonpath_status}    Format String    $.Data[?(@.Code== '{0}')].isActive    ${deliverypartner_code}
    ${get_status}    Get data from response json and return false value    ${resp}    ${jsonpath_status}
    Should Be Equal As Strings    ${get_status}    False
    ${jsonpath_deliveryname}    Format String    $..Data[?(@.Code=="{0}")].Name    ${deliverypartner_code}
    ${jsonpath_mobile}    Format String    $..Data[?(@.Code=="{0}")].ContactNumber    ${deliverypartner_code}
    ${jsonpath_deli_id}    Format String    $..Data[?(@.Code=="{0}")].Id    ${deliverypartner_code}
    ${get_delivery_name}    Get data from response json    ${resp}    ${jsonpath_deliveryname}
    ${get_delivery_mobile}    Get data from response json    ${resp}    ${jsonpath_mobile}
    ${get_delivery_id}    Get data from response json    ${resp}    ${jsonpath_deli_id}
    Should Be Equal As Strings    ${input_deliverypartner_name}    ${get_delivery_name}
    Run Keyword If    '${input_deliverypartner_mobile}'=='none'      Should Be Equal As Numbers    ${get_delivery_mobile}      0     ELSE
    ...     Should Be Equal As Strings    ${input_deliverypartner_mobile}    ${get_delivery_mobile}
    Delete deliverypartner    ${get_delivery_id}
