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
Resource          ../../../prepare/Hang_hoa/Sources/doitac.robot
Resource          ../../../config/env_product/envi.robot
Resource          ../../../core/API/api_mhbh.robot



*** Test Cases ***    Customer Code    Customer Type    Name      Mobile    Birthday    Address      Location      Ward       Group       Company       MST       Gender         Email        Facebook        Note
Create new customer        [Tags]              MER
                      [Template]              Merge customer with same mobile number
                      0945678232        +84 945678232         null       null
                      0945678232        +84 945678232         ASSSSSS       50000000


*** Keywords ***
Merge customer with same mobile number
    [Arguments]     ${cus1_mobilenumber}           ${cus2_mobilenumber}           ${node1}        ${node2}
  #  ${customer1_code}   ${customer1_name}     ${customer1_address}     ${cus1_note}        Create new Customer with Mobile Number     ${cus1_mobilenumber}
  #  ${customer2_code}   ${customer2_name}     ${customer2_address}     ${cus2_note}       Create new Customer with Mobile Number     ${cus2_mobilenumber}
    ${result_name}     Concatenate        ${customer1_name}     ${customer2_name}
    Go to Khach Hang
    Select checkbox of customer by customer Code    ${customer1_code}
    Select checkbox of customer by customer Code    ${customer2_code}
    Click element      ${button_merge_customer}
    ##
    Wait Until Element Is Enabled      ${text_merge_popup}
    Assert info on Merge confirmation popup      ${customer1_name}     ${customer1_address}      ${customer2_code}   ${customer2_address}
    Click element            ${button_merge_confirmation_popup}
    Assert info of Customer thr API by mobile number        ${cus1_mobilenumber}        ${result_name}

Select one customer
    [Arguments]        ${customer_code}
    Go to Khach Hang
    Select checkbox of customer by customer Code    ${customer_code}
    Click element      ${button_merge_customer}
    Toast message validation       System only support to merge from 2 customers
