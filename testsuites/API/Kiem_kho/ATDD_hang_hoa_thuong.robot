*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}      ${headless_browser}
Test Setup        Import Data From Json     ${list_test_case}
Library           SeleniumLibrary
Library           Collections
Resource          ../../../config/env_product/envi.robot
Resource          ../../../core/common/import_data.robot
Resource          ../../../core/Kiem_kho/api_kiem_kho.robot
# Resource          ../../../data/kiem_kho/hang_hoa_thuong.json
# Test Template      Kiemkho

*** Variables ***
${list_test_case}    data/kiem_kho/hang_hoa_thuong.json
${CreateBy}    "%CreateBy"
${BranchId}    "%BranchId"

*** Test Cases ***    data_test    index
Test case 1           [Tags]        BDD
    Given Lấy dữ liệu test case thứ 1
    When Gửi request tạo phiếu kiểm kho
    Then Check message và status code
    And Check Onhand và Tracking hợp lệ

*** Keywords ***
Lấy dữ liệu test case thứ ${index}
    ${index}    Convert To Integer    ${index}
    log    ${DATA_JSON["Testcases"]}
    ${index} =    Set Variable    ${index - 1}
    ${tcs}    Get From List    ${DATA_JSON["Testcases"]}    ${index}
    ${tcs}    Set Global Variable    ${tcs}

Gửi request tạo phiếu kiểm kho
    log    ${tcs}
    ${isHappy}   Set Global Variable   ${tcs["IsHappy"]}
    ${expected_status_code}   Set Global Variable   ${tcs["Response"]["Status_code"]}
    ${expected_message}   Set Global Variable    ${tcs["Response"]["Message"]}
    ${data_payload}    Set Variable    ${tcs["Data"]}
    ${products}    Set Variable    ${tcs["Data"]["StockTakeDetail"]}
    log    ${products[0]}
    @{list_id}    Create List
    ${length}    Get Length    ${products}
    ${payload_Str}   Convert To String    ${data_payload}
    :FOR    ${i}    IN Range    ${length}
    \    ${code}    Set Variable    ${products[${i}]["ProductCode"]}
    \    ${product_id}   Get product ID   ${code}
    \    ${product_id}    Convert To String    ${product_id}
    \    ${payload_Str}    Replace String    ${payload_Str}    '$ProductId'    ${product_id}    1
    log    ${payload_Str}
    ${payload_Str}    Format String For Json Object    ${payload_Str}
    log    ${payload_Str}
    ${str1}    Format String    ${payload_Str}
    ${payload}    evaluate    json.loads('''${str1}''')    json
    ${resp}    ${status_code}    Post request KV API    /stocktakes?kvuniqueparam=2020    ${payload}
    ${resp}    Set Global Variable    ${resp}
    ${status_code}    Set Global Variable    ${status_code}

Check message và status code
    Should Be Equal As Integers    ${status_code}    ${expected_status_code}
    Run Keyword If    ${isHappy}==1   Should Be Equal As Strings    ${resp["Message"]}    ${expected_message}
    Run Keyword If    ${isHappy}==0   Should Be Equal As Strings    ${resp["ResponseStatus"]["Message"]}    ${expected_message}

Check Onhand và Tracking hợp lệ
    log    check tracking
    # Run Keyword If    ${isHappy}==1   Verify Create Inventory Success    ${length}     ${payload["StockTakeDetail"]}    ${resp}    ${tcs}
