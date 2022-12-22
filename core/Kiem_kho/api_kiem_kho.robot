*** Settings ***
Library           ../../lib/number.py
Resource          ../common/format_string.robot

*** Variables ***
${stocktake_detail}    stocktakes/{0}/detailsupdate?Includes=UserCreate%2CBranch&isShowPopup=true&kvuniqueparam=2020
${product_detail_url}    products/{0}/history?format=json&%24inlinecount=allpages&%24top=10&%24filter=BranchId+eq+{1}
${master_product}     branchs/{0}/masterproducts?format=json&Includes=ProductAttributes&ForSummaryRow=true&CategoryId
...                   =0&AttributeFilter=%5B%5D&ProductKey={1}&ProductTypes=&IsImei=2&IsFormulas=2&AllowSale=&IsBatchExpir
...                   eControl=2&ShelvesIds=&TrademarkIds=&StockoutDate=alltime&supplierIds=&take=15&skip=0&page=1&pageSize
...                   =15&filter%5Blogic%5D=and
${imei_detail}    products/{0}/serials?format=json&%24inlinecount=allpages&%24top=10&%24filter=Status+eq+1
${bath_detail_url}    products/{0}/1/1/batchexpire?format=json&%24inlinecount=allpages&%24top=10

*** Keyword ***
Post data list kiem kho
    [Arguments]    ${data}    ${index}
    ${index}    Convert To Integer    ${index}
    log    ${data["Testcases"]}
    ${index} =    Set Variable    ${index - 1}
    ${tcs}    Get From List    ${data["Testcases"]}    ${index}
    ${isHappy}   Set Variable   ${tcs["IsHappy"]}
    ${expected_status_code}   Set Variable   ${tcs["Response"]["Status_code"]}
    ${expected_message}   Set Variable   ${tcs["Response"]["Message"]}
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
    Should Be Equal As Integers    ${status_code}    ${expected_status_code}
    Run Keyword If    ${isHappy}==1   Should Be Equal As Strings    ${resp["Message"]}    ${expected_message}
    Run Keyword If    ${isHappy}==0   Should Be Equal As Strings    ${resp["ResponseStatus"]["Message"]}    ${expected_message}
    Run Keyword If    ${isHappy}==1   Verify Create Inventory Success    ${length}     ${payload["StockTakeDetail"]}    ${resp}    ${tcs}

Verify Create Inventory Success
    [Arguments]    ${length}     ${products}    ${resp}    ${tcs}
    ${inventory_id}    Set Variable    ${resp["Data"]["Id"]}
    Log    ${inventory_id}
    ${resp1_url}    Format String    ${stocktake_detail}        ${inventory_id}
    # /stocktakes/{0}/detailsupdate
    ${resp1}    Get Request and return body    ${resp1_url}
    :FOR    ${i}    IN Range    ${length}
    \    Log     ${products[${i}]}
    \    Log     ${resp1["StockTakeItems"][${i}]["ActualCount"]}
    \    ${count}    Set Variable        ${products[${i}]["ActualCount"]}
    \    ${count}    Run Keyword If   "${count}"==""     Set Variable  0    ELSE    Set Variable     ${count}
    \    Should Be Equal As Integers    ${count}    ${resp1["StockTakeItems"][${i}]["ActualCount"]}
    Log    ${tcs["Data"]["IsAdjust"]}
    Run Keyword If    ${tcs["Data"]["IsAdjust"]}==1    Check create product tracking    ${length}     ${products}    ${resp}    ${tcs}
    Run Keyword If    ${tcs["Data"]["IsAdjust"]}==1    Check Onhand master product    ${length}     ${products}    ${resp}    ${tcs}

Check create product tracking
    [Arguments]    ${length}     ${products}    ${resp}    ${tcs}
    :FOR    ${i}    IN Range    ${length}
    \    Log     ${products[${i}]}
    \    ${resp2_url}    Format String    ${product_detail_url}    ${products[${i}]["ProductId"]}    ${BRANCH_ID}
    \    ${resp2}    Get Request and return body    ${resp2_url}
    \    Log    ${resp2["Data"][0]["EndingStocks"]}
    \    ${ending_stock}    Set Variable    ${resp2["Data"][0]["EndingStocks"]}
    \    ${count}    Set Variable        ${products[${i}]["ActualCount"]}
    \    Should Be Equal As Integers    ${ending_stock}    ${count}

Check Onhand master product
    [Arguments]    ${length}     ${products}    ${resp}    ${tcs}
    :FOR    ${i}    IN Range    ${length}
    \    Log     ${products[${i}]}
    \    ${resp3_url}    Format String    ${master_product}    ${BRANCH_ID}    ${products[${i}]["ProductCode"]}
    \    Log    ${resp3_url}
    \    ${resp3}    Get Request and return body    ${resp3_url}
    \    ${on_hand}  Set Variable   ${resp3["Data"][0]["OnHand"]}
    \    ${count}    Set Variable        ${products[${i}]["ActualCount"]}
    \    Should Be Equal As Integers    ${on_hand}    ${count}

Post data list kiem kho hang imei
    [Arguments]    ${data}    ${index}
    ${index}    Convert To Integer    ${index}
    log    ${data["Testcases"]}
    ${index} =    Set Variable    ${index - 1}
    ${tcs}    Get From List    ${data["Testcases"]}    ${index}
    ${isHappy}   Set Variable   ${tcs["IsHappy"]}
    ${expected_status_code}   Set Variable   ${tcs["Response"]["Status_code"]}
    ${expected_message}   Set Variable   ${tcs["Response"]["Message"]}
    ${data_payload}    Set Variable    ${tcs["Data"]}
    ${products}    Set Variable    ${tcs["Data"]["StockTakeDetail"]}
    ${serial}    Set Variable
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
    Should Be Equal As Integers    ${status_code}    ${expected_status_code}
    Run Keyword If    ${isHappy}==1   Should Be Equal As Strings    ${resp["Message"]}    ${expected_message}
    Run Keyword If    ${tcs["Data"]["IsAdjust"]}==1    Check product serial    ${length}     ${payload["StockTakeDetail"]}    ${resp}    ${tcs}

Check product serial
    [Arguments]    ${length}     ${products}    ${resp}    ${tcs}
    :FOR    ${i}    IN RANGE    ${length}
    \    Log     ${products[${i}]}
    \    Log     ${products[${i}]["SerialNumbers"]}
    \    ${list_serial}    Split String    ${products[${i}]["SerialNumbers"]}    ,
    \    Log    ${list_serial}
    \    ${resp2_url}    Format String    ${imei_detail}    ${products[${i}]["ProductId"]}
    \    Sleep    1s
    \    ${resp2}    Get Request and return body    ${resp2_url}
    \    Check serial mapped    ${list_serial}    ${resp2}

Check serial mapped
    [Arguments]    ${list_serial}    ${resp2}
    :FOR    ${item}    IN      @{list_serial}
    \    Log     ${item}
    \    ${response}    Convert To Lower Case    """${resp2}"""
    \    ${serial}    Convert To Lower Case     "'SerialNumber': '${item}'"
    \    Should Be True   ${serial} in ${response}

Kiem kho hang lo date
    [Arguments]    ${data}    ${index}
    ${index}    Convert To Integer    ${index}
    log    ${data["Testcases"]}
    ${index} =    Set Variable    ${index - 1}
    ${tcs}    Get From List    ${data["Testcases"]}    ${index}
    ${isHappy}   Set Variable   ${tcs["IsHappy"]}
    log    ${tcs}
    ${expected_status_code}   Set Variable   ${tcs["Response"]["Status_code"]}
    ${expected_message}   Set Variable   ${tcs["Response"]["Message"]}
    ${data_payload}    Set Variable    ${tcs["Data"]}
    ${products}    Set Variable    ${tcs["Data"]["StockTakeDetail"]}
    ${serial}    Set Variable
    log    ${products[0]}
    @{list_id}    Create List
    ${length}    Get Length    ${products}
    ${payload_Str}   Convert To String    ${data_payload}
    :FOR    ${i}    IN Range    ${length}
    \    ${code}    Set Variable    ${products[${i}]["ProductCode"]}
    \    ${batch_length}  Run Keyword If    'ProductBatchExpireActualList' in """${payload_Str}"""  Get Length    ${products[${i}]["ProductBatchExpireActualList"]}    ELSE    Set Variable    0
    \    ${payload_Str}    Run Keyword If   ${batch_length}!=0   Get product batch detail    ${products[${i}]["ProductBatchExpireActualList"]}    ${payload_Str}    ELSE   Set Variable    ${payload_Str}
    \    ${product_id}   Get product ID   ${code}
    \    ${product_id}    Convert To String    ${product_id}
    \    ${payload_Str}    Replace String    ${payload_Str}    '$ProductId'    ${product_id}    1
    log    ${payload_Str}
    ${payload_Str}    Format String For Json Object    ${payload_Str}
    log    ${payload_Str}
    ${str1}    Format String    ${payload_Str}
    ${payload}    evaluate    json.loads('''${str1}''')    json
    ${resp}    ${status_code}    Post request KV API    /stocktakes?kvuniqueparam=2020    ${payload}
    # ${expected_message}    Run Keyword If    "%ExpireDate" in """${expected_message}"""    Replace String   ${expected_message}    %ExpireDate    ${date}    1    ELSE    Set Variable    ${expected_message}
    Should Be Equal As Integers    ${status_code}    ${expected_status_code}
    Run Keyword If    ${isHappy}==1   Should Be Equal As Strings    ${resp["Message"]}    ${expected_message}
    # Run Keyword If    ${isHappy}==0   Should Be Equal As Strings    ${resp["ResponseStatus"]["Message"]}    ${expected_message}
    Run Keyword If    ${isHappy}==1 and ${tcs["Data"]["IsAdjust"]}==1 and ${batch_length}!=0    Check product lo date    ${length}     ${payload["StockTakeDetail"]}    ${resp}    ${tcs}

Check product lo date
    [Arguments]    ${length}     ${products}    ${resp}    ${tcs}
    :FOR    ${i}    IN Range    ${length}
    \    Log     ${products[${i}]}
    \    ${resp2_url}    Format String    ${bath_detail_url}    ${products[${i}]["ProductId"]}
    \    ${resp2}    Get Request and return body    ${resp2_url}
    \    Log    ${tcs["Data"]["StockTakeDetail"][${i}]["ProductBatchExpireActualList"]}
     # ${resp2["Data"][${i}]["BatchName"]}
    \    Log    ${resp2["Data"][${i}]["OnHand"]}
    \    Check product batch mapped    ${tcs["Data"]["StockTakeDetail"][${i}]}    ${resp2}

Check product batch mapped
    [Arguments]    ${details}    ${resp2}
    log    ${details}
    log    ${resp2}
    ${length}    Get Length    ${details["ProductBatchExpireActualList"]}
    ${payload}   Convert To String    ${resp2}
    # Validate length
    :FOR    ${i}    IN RANGE    ${length}
    \    ${actual_count}    Set Variable    ${details["ProductBatchExpireActualList"][${i}]["ActualCount"]}
    \    ${batch_name}    Set Variable    ${details["ProductBatchExpireActualList"][${i}]["BatchName"]}
    \    ${on_hand}    Convert To Lower Case    "'OnHand': ${actual_count}"
    \    ${payload_set}    Convert To Lower Case    """${payload}"""
    \    ${batch}    Convert To Lower Case    "'BatchName': '${batch_name}'"
    \    Should Be True    ${on_hand} in ${payload_set}
    \    Should Be True    ${batch} in ${payload_set}

Get product batch detail
    [Arguments]    ${batch_list}    ${payload_Str}
    ${length}    Get Length    ${batch_list}
    :FOR    ${i}    IN Range    ${length}
    \    log   ${batch_list[${i}]}
    \    ${expiredDate}    Set Variable    ${batch_list[${i}]["ExpireDate"]}
    \    Log    ${expiredDate}
    \    ${calculate_date}    Run Keyword If    '+' in """${expiredDate}"""   Split String    ${expiredDate}    +    ELSE    Split String    ${expiredDate}    -
    \    log    ${calculate_date[1]}
    \    ${today}    Get Current Date
    \    log    ${today}
    \    ${final_date}    Run Keyword If    '+' in """${expiredDate}"""    Add Time To Date    ${today}    ${calculate_date[1]} days    ELSE    Add Time To Date    ${today}    -${calculate_date[1]} days
    \    ${split_date}    Split String    ${final_date}    ${SPACE}
    \    ${format_date}    Convert Date   ${split_date[0]}     result_format=%d/%m/%Y    date_format=%Y-%m-%d
    \    ${payload_Str}    Replace String    ${payload_Str}    %ExpireDate    ${format_date}    1
    \    ${payload_Str}    Replace String    ${payload_Str}    ${expiredDate}    ${final_date}    1
    \    log    ${payload_Str}
    \    log    ${format_date}
    Return From Keyword    ${payload_Str}

Kiem kho hang quy doi
    [Arguments]    ${data}    ${index}
    ${index}    Convert To Integer    ${index}
    log    ${data["Testcases"]}
    ${index} =    Set Variable    ${index - 1}
    ${tcs}    Get From List    ${data["Testcases"]}    ${index}
    ${isHappy}   Set Variable   ${tcs["IsHappy"]}
    ${expected_status_code}   Set Variable   ${tcs["Response"]["Status_code"]}
    ${expected_message}   Set Variable   ${tcs["Response"]["Message"]}
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
    Should Be Equal As Integers    ${status_code}    ${expected_status_code}
    Run Keyword If    ${isHappy}==1   Should Be Equal As Strings    ${resp["Message"]}    ${expected_message}
    Run Keyword If    ${isHappy}==0   Should Be Equal As Strings    ${resp["ResponseStatus"]["Message"]}    ${expected_message}
    # Run Keyword If    ${tcs["Data"]["IsAdjust"]}==1    Check Valid Onhand    ${length}     ${payload["StockTakeDetail"]}    ${resp}    ${tcs}

Check Valid Onhand
    [Arguments]    ${length}     ${products}    ${resp}    ${tcs}
    ${total}    Set Variable    0
    :FOR    ${i}    IN Range    ${length}
    \    Log     ${products[${i}]}
    \    ${total}    Evaluate     ${total} + ${products[${i}]["ActualCount"]}*${products[${i}]["ConversionValue"]}
    log    ${total}
    # ${products[1]["ProductId"]}
