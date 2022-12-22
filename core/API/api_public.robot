*** Settings ***
Resource          ../share/computation.robot
Library           JSONLibrary
Library           String
Resource          api_access.robot
Resource          api_thietlap.robot
Resource          api_danhmuc_hanghoa.robot

*** Variables ***
${API_PUBLIC}     https://public.kiotapi.com
${API_WEBHOOK_SITE}   https://webhook.site
${endpoint_public_login}   /connect/token
${endpoint_public_danhsach_hanghoa}    /products?orderDirection=desc&orderBy=id&includeInventory=true
${endpoint_public_hanghoa}      /products
${endpoint_webhook}     /webhooks

*** Keywords ***
Get Authen OAuth API
    [Timeout]    2 minutes
    ${client_id}    ${client_secret}    Get client id and cliend secret thr API
    ${credential}=    Create Dictionary    client_id=${client_id}    client_secret=${client_secret}   scopes=PublicApi.Access    grant_type=client_credentials
    ${headers1}=    Create Dictionary       Content-Type=application/x-www-form-urlencoded
    Create Session    pub    https://id.kiotviet.vn    headers=${headers1}
    ${resp}=    Wait Until Keyword Succeeds    3x    0s   Post Request    pub    /connect/token    data=${credential}
    Log    ${resp.json()}
    Log    ${resp.cookies}
    Should Be Equal As Strings    ${resp.status_code}    200
    ${authen}    Get Value From Json    ${resp.json()}    $..access_token
    Log    ${authen}
    ${authen}=    Evaluate    ${authen}[0] if ${authen} else 0    modules=random, sys
    ${authen}=    Catenate    Bearer    ${authen}
    Log    ${authen}
    Set Global Variable    \${authen_public_api}     ${authen}
    Set Global Variable    \${cookies_public_api}     ${resp.cookies}

Get Request from Public API and return response
    [Arguments]   ${END_POINT}
    ${header}    Create Dictionary    Authorization=${authen_public_api}    Retailer=${RETAILER_NAME}
    ${params}    Create Dictionary    format=json
    Create Session    lolo    ${API_PUBLIC}    cookies=${cookies_public_api}
    ${resp}   Wait Until Keyword Succeeds    3x    0s     Get Request    lolo    ${END_POINT}     params=${params}    headers=${header}
    Log    ${resp.request.body}
    Log    ${resp.json()}
    log    ${resp.status_code}
    Should Be Equal As Strings      ${resp.status_code}    200
    Return From Keyword    ${resp.json()}

Post Request from Public API and return response
    [Arguments]   ${END_POINT}    ${payload}
    ${headers}=    Create Dictionary    Authorization=${authen_public_api}    Content-Type=application/json    Retailer=${RETAILER_NAME}
    Create Session    lolo    ${API_PUBLIC}    cookies=${cookies_public_api}
    ${resp}     Wait Until Keyword Succeeds    3x    0s      Post Request    lolo    ${END_POINT}    data=${payload}    headers=${headers}
    Log    ${resp.request.body}
    Log    ${resp.json()}
    Should Be Equal As Strings    ${resp.status_code}    200
    Return From Keyword    ${resp.json()}

Delete request from Public API
    [Arguments]   ${END_POINT}
    ${headers}=    Create Dictionary    Authorization=${authen_public_api}     Retailer=${RETAILER_NAME}
    Create Session    lolo    ${API_PUBLIC}    cookies=${cookies_public_api}
    ${resp}    Wait Until Keyword Succeeds    3x    0s    Delete Request    lolo    ${END_POINT}    headers=${headers}
    Log    ${resp.request.body}
    Log    ${resp.json()}
    log    ${resp.status_code}
    Should Be Equal As Strings    ${resp.status_code}    200

Get list product from Public API
    [Timeout]    5 minutes
    ${resp}   Get Request from Public API and return response    ${endpoint_public_danhsach_hanghoa}

Add new product from Public API
    [Timeout]    3 minutes
    [Arguments]         ${input_tenhh}    ${input_nhomhang}
    ${get_cat_id}    Get Category ID    ${input_nhomhang}
    ${payload}    Set Variable    {"name":"${input_tenhh}","categoryId":${get_cat_id},"allowsSale":true,"description":"Hoa test2","hasVariants":true,"isActive":true,"IsRewardPoint":true,"attributes":[{"attributeName":"MÀU","attributeValue":"Trắng"}],"unit":"bông","branchId":${BRANCH_ID},"inventories":[{"branchId":${BRANCH_ID},"onHand":34,"reserved":2}],"basePrice":1000.6,"weight":5}
    log    ${payload}
    ${resp}     Post Request from Public API and return response    ${endpoint_public_hanghoa}    ${payload}
    ${get_ma_sp}    Get data from response json    ${resp}     $..code
    Return From Keyword    ${get_ma_sp}

Get id type Webhook
    [Timeout]    3 minutes
    [Arguments]   ${input_type}
    ${resp}   Get Request from Public API and return response    ${endpoint_webhook}
    ${get_type_id}    Get data from response json    ${resp}    $..data[?(@.type=="${input_type}")].id
    Return From Keyword    ${get_type_id}

Register Wehook
    [Timeout]    3 minutes
    [Arguments]     ${input_type}
    ${get_uuid}   Create Webhook token
    ${payload}    Set Variable    {"Webhook":{"Type":"${input_type}","Url":"https://webhook.site/${get_uuid}","IsActive":true,"Description":"đăng kí webhook với event ${input_type}"}}
    ${resp}   Post Request from Public API and return response    ${endpoint_webhook}    ${payload}
    Return From Keyword    ${get_uuid}

Delete type Webhook
    [Timeout]    3 minutes
    [Arguments]     ${input_type}
    ${get_type_id}    Get id type Webhook     ${input_type}
    Run Keyword If    ${get_type_id}!=0    Delete request from Public API      /webhooks/${get_type_id}

Create Webhook token
    ${headers}=    Create Dictionary      Content-Type=application/json;charset=UTF-8
    Create Session    lolo    ${API_WEBHOOK_SITE}
    ${resp}    Post Request    lolo    /token    data={"timeout":"0"}    headers=${headers}
    Log    ${resp.request.body}
    Log    ${resp.json()}
    Should Be Equal As Strings    ${resp.status_code}    201
    ${get_uuid}    Get data from response json    ${resp.json()}     $..uuid
    Return From Keyword    ${get_uuid}

Get data from Webhook site
    [Arguments]     ${input_uuid}
    ${headers}=    Create Dictionary      Content-Type=application/json
    Create Session    lolo    ${API_WEBHOOK_SITE}
    ${resp}    Get Request    lolo    /token/${input_uuid}/requests?page=1&password=&sorting=newest       headers=${headers}
    Log    ${resp.json()}
    Should Be Equal As Strings    ${resp.status_code}    200
    Return From Keyword    ${resp.json()}

Assert data Webhook
    [Arguments]   ${input_uuid}   ${input_code}  ${name_Update}
    ${resp}     Get data from Webhook site    ${input_uuid}
    ${status1}    Evaluate    "${input_code}" in """${resp}"""
    Should Be True    ${status1}
    ${status2}    Evaluate    "${name_Update}" in """${resp}"""
    Should Be True    ${status2}
