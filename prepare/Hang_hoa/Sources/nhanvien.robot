*** Settings ***
Library           Collections
Library           RequestsLibrary
Library           SeleniumLibrary
Library           OperatingSystem
Library           String
Library           JSONLibrary
Library           StringFormat
Resource          ../../../core/API/api_thietlaphoahong.robot

*** Keywords ***
Create department
    [Arguments]     ${input_phong_ban}
    ${payload}    Format String    {{"department":{{"id":0,"name":"{0}","description":"","isActive":true}}}}    ${input_phong_ban}
    Log    ${payload}
    ${headers}=    Create Dictionary    Authorization=${bearertoken}    content-type=application/json;charset=UTF-8    accept=application/json, text/plain, */*      branchid=${BRANCH_ID}     retailer=${RETAILER_NAME}
    Create Session    lolo    ${TIMESHEET_API}        cookies=${resp.cookies}    verify=True    debug=1
    #${resp1}=    Post Request    lolo    /employees/department   data=${payload}    headers=${headers}
    ${resp1}=    Post Request    lolo    /employees/department   data=${payload}    headers=${headers}
    log    ${resp1.status_code}
    Log    ${resp1.request.body}
    Log    ${resp1.json()}
    Should Be Equal As Strings    ${resp1.status_code}    200

Create job title
    [Arguments]     ${input_chuc_vu}
    ${payload}    Format String    {{"jobTitle":{{"id":0,"name":"{0}","description":"","isActive":true}}}}    ${input_chuc_vu}
    Log    ${payload}
    ${headers}=    Create Dictionary    Authorization=${bearertoken}    content-type=application/json;charset=UTF-8    accept=application/json, text/plain, */*      branchid=${BRANCH_ID}     retailer=${RETAILER_NAME}
    Create Session    lolo    ${TIMESHEET_API}        cookies=${resp.cookies}    verify=True    debug=1
    ${resp1}=    Post Request    lolo    /employees/job-title   data=${payload}    headers=${headers}
    log    ${resp1.status_code}
    Log    ${resp1.request.body}
    Log    ${resp1.json()}
    Should Be Equal As Strings    ${resp1.status_code}    200

Create allowance
    [Arguments]     ${input_phu_cap}
    ${payload}    Format String    {{"allowance":{{"id":0,"name":"{0}"}}}}    ${input_phu_cap}
    Log    ${payload}
    ${headers}=    Create Dictionary    Authorization=${bearertoken}    content-type=application/json;charset=UTF-8    accept=application/json, text/plain, */*      branchid=${BRANCH_ID}     retailer=${RETAILER_NAME}
    Create Session    lolo    ${TIMESHEET_API}        cookies=${resp.cookies}    verify=True    debug=1
    ${resp1}=    Post Request    lolo    /allowance   data=${payload}    headers=${headers}
    log    ${resp1.status_code}
    Log    ${resp1.request.body}
    Log    ${resp1.json()}
    Should Be Equal As Strings    ${resp1.status_code}    200

Create deduction
    [Arguments]     ${input_giam_tru}
    ${payload}    Format String    {{"deduction":{{"id":0,"name":"{0}"}}}}    ${input_giam_tru}
    Log    ${payload}
    ${headers}=    Create Dictionary    Authorization=${bearertoken}    content-type=application/json;charset=UTF-8    accept=application/json, text/plain, */*      branchid=${BRANCH_ID}     retailer=${RETAILER_NAME}
    Create Session    lolo    ${TIMESHEET_API}        cookies=${resp.cookies}    verify=True    debug=1
    ${resp1}=    Post Request    lolo    /deduction   data=${payload}    headers=${headers}
    log    ${resp1.status_code}
    Log    ${resp1.request.body}
    Log    ${resp1.json()}
    Should Be Equal As Strings    ${resp1.status_code}    200

Create commission
    [Arguments]       ${input_banghoahong}      ${nhom_hang}      ${input_product_for_all}    ${input_value_for_all}      ${input_type_for_all}     ${input_product}    ${input_value}      ${input_type}
    Add new commission thr API       ${input_banghoahong}
    Add category into commission thr API     ${input_banghoahong}      ${nhom_hang}
    Setting commission value for all product for commission thr API      ${input_banghoahong}       ${input_product_for_all}    ${input_value_for_all}      ${input_type_for_all}    true
    Setting commission value for all product for commission thr API      ${input_banghoahong}      ${input_product}      ${input_value}      ${input_type}    false
