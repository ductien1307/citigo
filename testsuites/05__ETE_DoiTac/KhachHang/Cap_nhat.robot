*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}      ${headless_browser}
Test Setup        Before Test Doi Tac Khach Hang
Test Teardown     After Test
Resource          ../../../config/env_product/envi.robot
Resource          ../../../core/Doi_Tac/doitac_navigation.robot
Resource          ../../../core/Doi_Tac/khachhang_list_action.robot
Resource          ../../../core/Doi_Tac/khachhang_list_page.robot
Resource          ../../../core/API/api_khachhang.robot
Resource          ../../../prepare/Hang_hoa/Sources/doitac.robot
Resource          ../../../core/Thiet_lap/khuyenmai_list_page.robot
Resource         ../../../core/share/toast_message.robot


*** Test Cases ***    Customer Code     Name      Mobile          Address       Customer Type    Birthday      Location                     Ward                  Group       Company              MST       Gender     Email        Facebook        Note
Update customer        [Tags]                  CC     DT
                      [Template]              update_custom
                       CKH003     Hồng    0945678111     15 Trương định    Cá nhân       02021994       Hà Nội - Quận Hoàng Mai     Phường Tân Mai         none          none               none       Nam       none         none       none

Delete custom        [Tags]                  CC
                      [Template]              del_custom
                       CKH004     Mai    0945678113     15 Trương định

Unactive custom        [Tags]                  CC
                     [Template]              active_custom
                      CKH005     Gấu    0945678115     15 Trương định

*** Keywords ***
update_custom
    [Arguments]    ${customer_code}    ${input_customer_name}    ${input_customer_mobile}    ${input_customer_address}    ${input_customer_type}    ${input_customer_birthday}    ${input_customer_location}
    ...    ${input_customer_ward}    ${input_customer_group}    ${input_customer_company}    ${input_customer_mst}    ${input_customer_gender}    ${input_customer_email}
    ...    ${input_customer_facebook}    ${input_customer_note}
    Set Selenium Speed      2s
    ${get_customer_id}    Get customer id thr API    ${customer_code}
    Run Keyword If    '${get_customer_id}' == '0'    Log    Ignore delete     ELSE      Delete customer    ${get_customer_id}
    Add customers    ${customer_code}    ${input_customer_name}    ${input_customer_mobile}    ${input_customer_address}
    Go to update customer    ${customer_code}
    Run Keyword If    '${input_customer_type}' == 'Cá nhân'    Log     Ignore input      ELSE       Select Customer Type    ${input_customer_type}
    Run Keyword If    '${input_customer_birthday}' == 'none'    Log     Ignore input      ELSE       Input Text       ${textbox_customer_birthdate}       ${input_customer_birthday}
    Run Keyword If    '${input_customer_location}' == 'none'    Log     Ignore input      ELSE     Input data       ${textbox_customer_khuvuc}    ${input_customer_location}
    Run Keyword If    '${input_customer_ward}' == 'none'    Log     Ignore input      ELSE           Input data       ${textbox_customer_phuongxa}    ${input_customer_ward}
    Run Keyword If    '${input_customer_company}' == 'none'    Log     Ignore input      ELSE       Input Text    ${textbox_customer_company}      ${input_customer_company}
    Run Keyword If    '${input_customer_gender}' == 'none'    Log     Ignore input      ELSE       Select Gender    ${input_customer_gender}
    Click Element        ${button_customer_luu}
    Reload page
    ${customer_id}      Get Customer info and validate    ${input_customer_type}    ${customer_code}    ${input_customer_name}    ${input_customer_mobile}
    ...    ${input_customer_address}    ${input_customer_location}    ${input_customer_ward}    ${input_customer_gender}    ${input_customer_email}      ${input_customer_company}
    Delete customer    ${customer_id}

del_custom
    [Arguments]    ${customer_code}    ${input_customer_name}    ${input_customer_mobile}    ${input_customer_address}
    Set Selenium Speed    2s
    ${get_customer_id}    Get customer id thr API    ${customer_code}
    Run Keyword If    '${get_customer_id}' == '0'    Log    Ignore delete     ELSE      Delete customer    ${get_customer_id}
    Add customers    ${customer_code}    ${input_customer_name}    ${input_customer_mobile}    ${input_customer_address}
    Wait Until Page Contains Element    ${textbox_search_customer}    2 mins
    Input data    ${textbox_search_customer}    ${customer_code}
    Wait Until Page Contains Element    ${button_delete_customer}    2 mins
    Click Element    ${button_delete_customer}
    Wait Until Page Contains Element    ${button_dongy_del_promo}    2 mins
    Click Element    ${button_dongy_del_promo}
    Wait Until Page Contains Element    ${toast_message}
    ${msg}    Format String    Xóa khách hàng {0} thành công    ${input_customer_name}
    Element Should Contain    ${toast_message}    ${msg}

active_custom
    [Arguments]    ${customer_code}    ${input_customer_name}    ${input_customer_mobile}    ${input_customer_address}
    Set Selenium Speed    2s
    ${get_customer_id}    Get customer id thr API    ${customer_code}
    Run Keyword If    '${get_customer_id}' == '0'    Log    Ignore delete     ELSE      Delete customer    ${get_customer_id}
    Add customers    ${customer_code}    ${input_customer_name}    ${input_customer_mobile}    ${input_customer_address}
    Wait Until Page Contains Element    ${textbox_search_customer}    2 mins
    Input data    ${textbox_search_customer}    ${customer_code}
    Wait Until Page Contains Element    ${button_active_customer}    2 mins
    Click Element    ${button_active_customer}
    Wait Until Page Contains Element    ${button_dongy_del_promo}    2 mins
    Click Element    ${button_dongy_del_promo}
    Sleep    3s
    ${resp}       Get Request and return body    ${endpoint_khachhang}
    ${jsonpath_status}    Format String    $.Data[?(@.Code== '{0}')].IsActive    ${customer_code}
    ${get_status}    Get data from response json and return false value    ${resp}    ${jsonpath_status}
    Should Be Equal As Strings    ${get_status}    False
    ${customer_id}      Get Customer info and validate    Cá nhân    ${customer_code}    ${input_customer_name}    ${input_customer_mobile}
    ...    ${input_customer_address}    0    0    0    0      0
    Delete customer    ${customer_id}
