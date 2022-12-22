*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}      ${headless_browser}
Test Setup
Test Teardown     After Test
Resource          ../../../config/env_product/envi.robot
Resource          ../../../core/Doi_Tac/doitac_navigation.robot
Resource          ../../../core/Doi_Tac/ncc_list_action.robot
Resource          ../../../core/Doi_Tac/giaohang_list_page.robot
Resource          ../../../core/Doi_Tac/ncc_list_page.robot
Resource          ../../../core/API/api_nha_cung_cap.robot
Resource          ../../../core/Share/discount.robot
Resource          ../../../prepare/Hang_hoa/Sources/doitac.robot
Resource          ../../../core/Thiet_lap/khuyenmai_list_page.robot
Resource         ../../../core/share/toast_message.robot
Resource          ../../../core/Doi_Tac/khachhang_list_page.robot


*** Test Cases ***    Code      Name      Mobile        Address                 Location                  Ward                      Email               Company             MST          Group       Note
Update supplier        [Tags]                  CPL                 DT
                      [Template]              update_sup
                      CNCC002   Hoàng    0973345623     92 Trần Hưng Đạo      Hà Nội - Quận Đống Đa      Phường Nam Đồng         adt@gmail.com          Công ty Escape      123456754       none     none

Delete supplier        [Tags]                  CPL                 DT
                      [Template]              del_sup
                      CNCC003   Thanh    0941345962

Unactive supplier        [Tags]                  CPL                 DT
                      [Template]              active_sup
                      CNCC004   Ngọc    0932456789


*** Keywords ***
update_sup
    [Arguments]    ${supplier_code}    ${input_supplier_name}    ${input_supplier_mobile}    ${input_supplier_address}      ${input_supplier_location}       ${input_supplier_ward}
    ...       ${input_supplier_email}       ${input_supplier_company}      ${input_supplier_mst}       ${input_supplier_group}      ${input_supplier_note}
    ${get_supplier_id}    Get Supplier Id    ${supplier_code}
    Run Keyword If    '${get_supplier_id}' == '0'    Log    Ignore delete     ELSE      Delete supplier    ${get_supplier_id}
    Add supplier    ${supplier_code}    ${input_supplier_name}    ${input_supplier_mobile}
    Wait Until Keyword Succeeds    3 times    3 s    Before Test Nha Cung Cap
    Wait Until Keyword Succeeds    3 times    3 s    Go to update supplier    ${supplier_code}
    Run Keyword If    '${input_supplier_mobile}' == 'none'    Log     Ignore input      ELSE       Input data       ${textbox_suppliermobile}       ${input_supplier_mobile}
    Run Keyword If    '${input_supplier_address}' == 'none'    Log     Ignore input      ELSE       Input data       ${textbox_supplier_address}       ${input_supplier_address}
    Run Keyword If    '${input_supplier_location}' == 'none'    Log     Ignore input      ELSE       Input data    ${textbox_supplier_location}     ${input_supplier_location}
    Run Keyword If    '${input_supplier_ward}' == 'none'    Log     Ignore input      ELSE       Input data    ${textbox_supplier_ward}    ${input_supplier_ward}
    Run Keyword If    '${input_supplier_mst}' == 'none'    Log     Ignore input      ELSE       Input data    ${textbox_supplier_mst}      ${input_supplier_mst}
    Run Keyword If    '${input_supplier_company}' == 'none'    Log     Ignore input      ELSE       Input data    ${textbox_supplier_company}      ${input_supplier_company}
    Run Keyword If    '${input_supplier_email}' == 'none'    Log     Ignore input      ELSE       Input data    ${textbox_supplier_email}      ${input_supplier_email}
    Wait Until Element Is Enabled        ${button_supplier_luu}
    Click Element        ${button_supplier_luu}
    Sleep          20 s
    ${supplier_id}      Get supplier info and validate    ${supplier_code}    ${input_supplier_name}    ${input_supplier_mobile}    ${input_supplier_address}
    ...    ${input_supplier_location}    ${input_supplier_ward}    ${input_supplier_email}      ${input_supplier_company}       ${input_supplier_note}
    Delete supplier    ${supplier_id}

del_sup
    [Arguments]    ${supplier_code}       ${input_supplier_name}    ${input_supplier_mobile}
    ${get_supplier_id}    Get Supplier Id    ${supplier_code}
    Run Keyword If    '${get_supplier_id}' == '0'    Log    Ignore delete     ELSE      Delete supplier    ${get_supplier_id}
    Add supplier    ${supplier_code}    ${input_supplier_name}    ${input_supplier_mobile}
    Wait Until Keyword Succeeds    3 times    3 s    Before Test Nha Cung Cap
    Wait Until Keyword Succeeds    3 times    3 s    Search supplier    ${supplier_code}
    Sleep    3s
    Wait Until Page Contains Element    ${button_delete_supplier}    2 mins
    Click Element JS    ${button_delete_supplier}
    Wait Until Page Contains Element    ${button_dongy_del_promo}    2 mins
    Click Element JS    ${button_dongy_del_promo}
    Wait Until Page Contains Element    ${toast_message}
    ${msg}    Format String    Xóa nhà cung cấp {0} thành công    ${input_supplier_name}
    Element Should Contain    ${toast_message}    ${msg}

active_sup
    [Arguments]    ${supplier_code}   ${input_supplier_name}    ${input_supplier_mobile}
    ${get_supplier_id}    Get Supplier Id    ${supplier_code}
    Run Keyword If    '${get_supplier_id}' == '0'    Log    Ignore delete     ELSE      Delete supplier    ${get_supplier_id}
    Add supplier    ${supplier_code}    ${input_supplier_name}    ${input_supplier_mobile}
    Wait Until Keyword Succeeds    3 times    3 s    Before Test Nha Cung Cap
    Wait Until Keyword Succeeds    3 times    3 s    Search supplier    ${supplier_code}
    Sleep    3s
    Wait Until Page Contains Element    ${button_active_supplier}    2 mins
    Click Element JS    ${button_active_supplier}
    Wait Until Page Contains Element    ${button_dongy_del_promo}    2 mins
    Click Element JS    ${button_dongy_del_promo}
    Sleep    3s
    ${resp}       Get Request and return body    ${endpoint_ncc}
    ${jsonpath_status}    Format String    $.Data[?(@.Code== '{0}')].isActive    ${supplier_code}
    ${get_status}    Get data from response json and return false value    ${resp}    ${jsonpath_status}
    Should Be Equal As Strings    ${get_status}    False
    ${jsonpath_suppliername}    Format String    $..Data[?(@.Code=="{0}")].Name    ${supplier_code}
    ${jsonpath_mobile}    Format String    $..Data[?(@.Code=="{0}")].Phone    ${supplier_code}
    ${jsonpath_cus_id}    Format String    $..Data[?(@.Code=="{0}")].Id    ${supplier_code}
    ${get_supplier_name}    Get data from response json    ${resp}    ${jsonpath_suppliername}
    ${get_supplier_mobile}    Get data from response json    ${resp}    ${jsonpath_mobile}
    ${get_supplier_id}    Get data from response json    ${resp}    ${jsonpath_cus_id}
    Should Be Equal As Strings    ${input_supplier_name}    ${get_supplier_name}
    Run Keyword If    '${input_supplier_mobile}'=='none'      Should Be Equal As Numbers    ${get_supplier_mobile}      0
    ...   ELSE     Should Be Equal As Strings    ${input_supplier_mobile}    ${get_supplier_mobile}
    Delete supplier    ${get_supplier_id}
