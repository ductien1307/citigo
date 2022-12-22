*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}      ${headless_browser}
Test Setup        Before Test Doi Tac Khach Hang
Test Teardown     After Test
Resource          ../../../config/env_product/envi.robot
Resource          ../../../core/Doi_Tac/doitac_navigation.robot
Resource          ../../../core/Doi_Tac/khachhang_list_action.robot
Resource          ../../../core/Doi_Tac/khachhang_list_page.robot
Resource          ../../../core/API/api_khachhang.robot
Resource          ../../../core/share/toast_message.robot
Resource          ../../../core/share/global.robot


*** Test Cases ***    Customer Code   Customer Type    Name      Mobile    Birthday    Address      Location      Ward       Group       Company       MST       Gender         Email        Facebook        Note
Create new customer   [Tags]       GOLIVE2    CTP   
                      [Documentation]   KYC - MHQL - THÊM MỚI KHÁCH HÀNG CÓ ĐỊA CHỈ SĐT NGÀY SINH GIỚI TÍNH KHU VỰC PHƯỜNG XÃ
                      [Template]   Create new customer 01
                      CKH001       Cá nhân        Thái       0945678232       01011982        1B yết kiêu         Đà Nẵng - Quận Cẩm Lệ       Phường Hòa Thọ Đông         none          none      none       Nam       none         none       none

Create new customer   [Tags]       CC         DT
                      [Template]   Create new customer 01
                      CKH001       Cá nhân        Thái       0945678232       01011982        1B yết kiêu         Đà Nẵng - Quận Cẩm Lệ       Phường Hòa Thọ Đông         none          none      none       Nam       none         none       none
                      CKH002           Công ty        Hằng       0321232232       none        23 TBT         none        none         none          Công ty An Nhi      none       Nữ       none         none       none

*** Keywords ***
Create new customer 01
    [Arguments]     ${customer_code}    ${input_customer_type}    ${input_customer_name}    ${input_customer_mobile}    ${input_customer_birthday}    ${input_customer_address}    ${input_customer_location}
    ...    ${input_customer_ward}    ${input_customer_group}    ${input_customer_company}    ${input_customer_mst}    ${input_customer_gender}    ${input_customer_email}
    ...    ${input_customer_facebook}    ${input_customer_note}
    Set Selenium Speed  0.5s
    ${get_customer_id}    Get customer id thr API    ${customer_code}
    Run Keyword If    '${get_customer_id}' == '0'    Log    Ignore delete     ELSE      Delete customer    ${get_customer_id}
    Go to Add new Customer
    Run Keyword If    '${input_customer_type}' == 'Cá nhân'    Log     Ignore input      ELSE       Select Customer Type    ${input_customer_type}
    Input Text Global        ${textbox_customercode}       ${customer_code}
    Input Text Global       ${textbox_customername}       ${input_customer_name}
    Run Keyword If    '${input_customer_mobile}' == 'none'    Log     Ignore input      ELSE       Input Text Global       ${textbox_customermobile}       ${input_customer_mobile}
    Run Keyword If    '${input_customer_birthday}' == 'none'    Log     Ignore input      ELSE       Input Text Global       ${textbox_customer_birthdate}       ${input_customer_birthday}
    Run Keyword If    '${input_customer_address}' == 'none'    Log     Ignore input      ELSE       Input Text Global       ${textbox_customer_address}       ${input_customer_address}
    Run Keyword If    '${input_customer_location}' == 'none'    Log     Ignore input      ELSE     Input Text Global    ${textbox_customer_khuvuc}    ${input_customer_location}
    Run Keyword If    '${input_customer_ward}' == 'none'    Log     Ignore input      ELSE         Input Text Global    ${textbox_customer_phuongxa}    ${input_customer_ward}
    Run Keyword If    '${input_customer_group}' == 'none'    Log     Ignore input      ELSE       Input Text Global    ${textbox_customer_group}      ${input_customer_group}
    Run Keyword If    '${input_customer_mst}' == 'none'    Log     Ignore input      ELSE       Input Text Global    ${textbox_customer_mst}      ${input_customer_mst}
    Run Keyword If    '${input_customer_company}' == 'none'    Log     Ignore input      ELSE       Input Text Global    ${textbox_customer_company}      ${input_customer_company}
    Run Keyword If    '${input_customer_gender}' == 'none'    Log     Ignore input      ELSE       Select Gender    ${input_customer_gender}
    Run Keyword If    '${input_customer_email}' == 'none'    Log     Ignore input      ELSE       Input Text Global    ${textbox_customer_email}      ${input_customer_email}
    Run Keyword If    '${input_customer_facebook}' == 'none'    Log     Ignore input      ELSE       Input Text Global    ${textbox_customer_facebook}      ${input_customer_facebook}
    Run Keyword If    '${input_customer_note}' == 'none'    Log     Ignore input      ELSE       Input Text Global    ${textbox_customer_note}      ${input_customer_note}
    Click Element JS        ${button_customer_luu}
    Create customer message success validation
    ${customer_id}   Wait Until Keyword Succeeds    3 times  30s   Get Customer info and validate    ${input_customer_type}    ${customer_code}    ${input_customer_name}    ${input_customer_mobile}    ${input_customer_address}    ${input_customer_location}    ${input_customer_ward}    ${input_customer_gender}    ${input_customer_email}      ${input_customer_company}
    Delete customer    ${customer_id}
