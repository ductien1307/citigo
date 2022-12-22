*** Settings ***
Resource          api_access.robot
Resource          api_danhmuc_hanghoa.robot
Resource          ../share/computation.robot

*** Variables ***
${endpoint_hanghoa_trong_banghoahong}     /products/get-time-sheet-product-commission?OrderByDesc=CreatedDate&commissionIds={0}&includeInActive=true&includeSoftDelete=true&skip=0&take=1000
${endpoint_banghoahong}     /commission?OrderBy=id&OrderByDesc=id&keyword=
${endpoint_xoa_banghoahong}     /commission/{0}

*** Keywords ***
Add new commission thr API
    [Timeout]   2 mins
    [Arguments]    ${input_banghoahong}
    ${payload}    Format String   {{"commission":{{"id":0,"name":"{0}","isAllBranch":true,"branchIds":[],"isActive":true}}}}   ${input_banghoahong}
    Log    ${payload}
    ${headers}=    Create Dictionary    Authorization=${bearertoken}    Content-Type=application/json;charset=UTF-8    accept=application/json, text/plain, */*     branchid=${BRANCH_ID}     retailer=${RETAILER_NAME}
    Log     ${headers}
    Create Session    lolo    ${TIMESHEET_API}        cookies=${resp.cookies}    verify=True    debug=1
    ${resp1}=    Wait Until Keyword Succeeds    3x    0s     Post Request    lolo    /commission   data=${payload}    headers=${headers}
    log    ${resp1.status_code}
    Log    ${resp1.request.body}
    Log    ${resp1.json()}
    Should Be Equal As Strings    ${resp1.status_code}    200

Add new commission by branch thr API
    [Timeout]   2 mins
    [Arguments]    ${input_banghoahong}     ${input_branch}
    ${get_branch_id}    Get BranchID by BranchName    ${input_branch}
    ${payload}    Format String   {{"commission":{{"id":0,"name":"{0}","isAllBranch":false,"branchIds":[{1}],"isActive":true}}}}  ${input_banghoahong}      ${get_branch_id}
    Log    ${payload}
    ${headers}=    Create Dictionary    Authorization=${bearertoken}    Content-Type=application/json;charset=UTF-8    accept=application/json, text/plain, */*     branchid=${BRANCH_ID}     retailer=${RETAILER_NAME}
    Log     ${headers}
    Create Session    lolo    ${TIMESHEET_API}        cookies=${resp.cookies}    verify=True    debug=1
    ${resp1}=    Wait Until Keyword Succeeds    3x    0s     Post Request    lolo    /commission   data=${payload}    headers=${headers}
    log    ${resp1.status_code}
    Log    ${resp1.request.body}
    Log    ${resp1.json()}
    Should Be Equal As Strings    ${resp1.status_code}    200

Add category into commission thr API
    [Arguments]     ${input_banghoahong}      ${input_nhom_hang}
    ${get_bhh_id}     Get commission id    ${input_banghoahong}
    ${get_nh_id}    Run Keyword If   '${input_nhom_hang}'=='Tất cả'     Set Variable    0     ELSE     Get category Id     ${input_nhom_hang}
    ${get_nhom_hang}      Run Keyword If   '${input_nhom_hang}'=='Tất cả'     Set Variable    null     ELSE    Set Variable    ${input_nhom_hang}
    ${payload}    Format String   {{"commissionIds":[{0}],"productCategory":{{"id":{1},"name":"{2}"}}}}     ${get_bhh_id}   ${get_nh_id}      ${get_nhom_hang}
    Log    ${payload}
    ${headers}=    Create Dictionary    Authorization=${bearertoken}    Content-Type=application/json;charset=UTF-8    accept=application/json, text/plain, */*     branchid=${BRANCH_ID}     retailer=${RETAILER_NAME}
    Log     ${headers}
    Create Session    lolo    ${TIMESHEET_API}        cookies=${resp.cookies}    verify=True    debug=1
    ${resp1}=    Wait Until Keyword Succeeds    3x    0s     Post Request    lolo    /commission-details/create-by-category   data=${payload}    headers=${headers}
    log    ${resp1.status_code}
    Log    ${resp1.request.body}
    Log    ${resp1.json()}
    Should Be Equal As Strings    ${resp1.status_code}    200

Setting commission value for all product for commission thr API
    [Arguments]     ${input_banghoahong}      ${input_product}      ${input_value}      ${input_type}     ${update_for_all}
    ${get_bhh_id}     Get commission id    ${input_banghoahong}
    ${get_pr_id}      Get product id thr API       ${input_product}
    ${result_value}      Run Keyword If   '${input_type}'=='VND'     Set Variable    ${input_value}     ELSE    Set Variable    null
    ${result_value_ratio}      Run Keyword If   '${input_type}'!='VND'     Set Variable     ${input_value}     ELSE    Set Variable    null
    ${payload}    Format String   {{"product":{{"Id":{0},"Code":"HHD072","Name":"Kẹo dẻo nhiều vị","CommissionId":{1}}},"totalCommissionIds":[{1}],"value":{2},"valueRatio":{3},"isUpdateForAllCommission":{4},"categoryId":null}}     ${get_pr_id}   ${get_bhh_id}      ${result_value}      ${result_value_ratio}    ${update_for_all}
    Log    ${payload}
    ${headers}=    Create Dictionary    Authorization=${bearertoken}    Content-Type=application/json;charset=UTF-8    accept=application/json, text/plain, */*     branchid=${BRANCH_ID}     retailer=${RETAILER_NAME}
    Log     ${headers}
    Create Session    lolo    ${TIMESHEET_API}        cookies=${resp.cookies}    verify=True    debug=1
    ${resp1}=    Put Request    lolo    /commission-details/update-value   data=${payload}    headers=${headers}
    log    ${resp1.status_code}
    Log    ${resp1.request.body}
    Log    ${resp1.json()}
    Should Be Equal As Strings    ${resp1.status_code}    200

Get commission id
    [Timeout]    3 minute
    [Arguments]    ${input_banghoahong}
    ${jsonpath_bhh_id}    Format String    $..result.data[?(@.name=="{0}")].id    ${input_banghoahong}
    ${resp}  Get Request and return body by other url    ${TIMESHEET_API}    ${endpoint_banghoahong}
    ${get_bhh_id}    Get data from response json      ${resp}    ${jsonpath_bhh_id}
    Return From Keyword    ${get_bhh_id}

Delete commission thr API
    [Arguments]    ${input_banghoahong}
    [Timeout]    3 minute
    ${get_bhh_id}    Get commission id    ${input_banghoahong}
    ${endpoint_xoa_bhh}    Format String    ${endpoint_xoa_banghoahong}    ${get_bhh_id}
    ${headers}=    Create Dictionary    Authorization=${bearertoken}    accept=application/json, text/plain, */*      branchid=${BRANCH_ID}     retailer=${RETAILER_NAME}
    Create Session    lolo    ${TIMESHEET_API}    cookies=${resp.cookies}
    ${resp}=    Delete Request    lolo    ${endpoint_xoa_bhh}    headers=${headers}
    log    ${resp.status_code}
    Log    ${resp.json()}
    Should Be Equal As Strings    ${resp.status_code}    200

Get total product in commission thr API
    [Arguments]    ${input_ten_bhh}
    [Timeout]    3 minute
    ${get_bhh_id}    Get commission id      ${input_ten_bhh}
    ${endpoint_hh_trong_bhh}    Format String    ${endpoint_hanghoa_trong_banghoahong}    ${get_bhh_id}
    ${total}    Get data from API    ${endpoint_hh_trong_bhh}    $..Total
    Return From Keyword    ${total}

Get list commission value of list product by commission thr API
    [Arguments]    ${input_ten_bhh}     ${list_proudct}
    ${get_bhh_id}    Get commission id      ${input_ten_bhh}
    ${endpoint_hh_trong_bhh}    Format String    ${endpoint_hanghoa_trong_banghoahong}    ${get_bhh_id}
    ${resp}    Get Request and return body    ${endpoint_hh_trong_bhh}
    ${list_value}     Create List
    :FOR      ${item_product}     IN ZIP      ${list_proudct}
    \     ${jsonpath_value}     Format String     $..Data[?(@.Code=="{0}")].CommissionDetails..Value    ${item_product}
    \     ${jsonpath_value_ratio}     Format String     $..Data[?(@.Code=="{0}")].CommissionDetails..ValueRatio    ${item_product}
    \     ${get_value}    Get data from response json    ${resp}    ${jsonpath_value}
    \     ${get_value_ratio}    Get data from response json    ${resp}    ${jsonpath_value_ratio}
    \     ${result_value}   Set Variable If    ${get_value}==0      ${get_value_ratio}    ${get_value}
    \     Append to list    ${list_value}     ${result_value}
    Return From Keyword    ${list_value}
