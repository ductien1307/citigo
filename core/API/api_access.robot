*** Settings ***
Library           JSONLibrary
Library           RequestsLibrary
Library           String
Library           StringFormat
Resource          ../share/computation.robot
Resource          ../../config/env_product/envi.robot
Library           BuiltIn

*** Variables ***
${endpoint_branch_list}    /branchs?format=json
${endpoint_currentsession}    /retailers/currentsession
${endpoint_nguoitao}    /retailers/currentsession
${endpoint_user}      /users

*** Keywords ***
Post request thr API
    [Arguments]   ${END_POINT}    ${payload}
    ${headers1}=    Create Dictionary    Authorization=${bearertoken}    Content-Type=application/json;charset=utf-8    Retailer=${RETAILER_NAME}     Branchid=${BRANCH_ID}
    Create Session    lolo    ${API_URL}    cookies=${resp.cookies}
    ${resp2}     Wait Until Keyword Succeeds    3x    0s      Post Request    lolo    ${END_POINT}    data=${payload}    headers=${headers1}
    Log    ${resp2.request.body}
    Log    ${resp2.json()}
    Should Be Equal As Strings    ${resp2.status_code}    200
    Return From Keyword    ${resp2.json()}

Post request KV API
    [Arguments]   ${END_POINT}    ${payload}
    ${headers1}=    Create Dictionary    Authorization=${bearertoken}    Content-Type=application/json;charset=utf-8    Retailer=${RETAILER_NAME}     Branchid=${BRANCH_ID}
    Create Session    lolo    ${API_URL}    cookies=${resp.cookies}
    ${resp2}     Wait Until Keyword Succeeds    3x    0s      Post Request    lolo    ${END_POINT}    data=${payload}    headers=${headers1}
    log    ${resp2.status_code}
    Log    ${resp2.request.body}
    Log    ${resp2.json()}
    Return From Keyword    ${resp2.json()}    ${resp2.status_code}

Post request data form thr API
    [Arguments]   ${END_POINT}    ${payload}
    ${headers1}=    Create Dictionary    Authorization=${bearertoken}     Retailer=${RETAILER_NAME}     Branchid=${BRANCH_ID}
    Create Session    lolo    ${API_URL}    cookies=${resp.cookies}   verify=True    debug=1
    ${resp2}    Wait Until Keyword Succeeds    3x    0s     Post Request    lolo    ${END_POINT}    files=${payload}    headers=${headers1}
    Log    ${resp2.request.body}
    Log    ${resp2.json()}
    Should Be Equal As Strings    ${resp2.status_code}    200
    Return From Keyword    ${resp2.json()}

Post request by other URL API
    [Arguments]   ${OTHER_API}    ${END_POINT}    ${payload}
    ${headers1}=    Create Dictionary    Authorization=${bearertoken}    Content-Type=application/json;charset=utf-8    Retailer=${RETAILER_NAME}     Branchid=${BRANCH_ID}
    Create Session    lolo    ${OTHER_API}    cookies=${resp.cookies}
    ${resp2}    Wait Until Keyword Succeeds    3x    0s    Post Request    lolo    ${END_POINT}    data=${payload}    headers=${headers1}
    Log    ${resp2.request.body}
    Log    ${resp2.json()}
    Should Be Equal As Strings    ${resp2.status_code}    200
    Return From Keyword    ${resp2.json()}

Delete request thr API
    [Arguments]   ${END_POINT}
    ${headers}=    Create Dictionary    Authorization=${bearertoken}    Content-Type=application/x-www-form-urlencoded     Retailer=${RETAILER_NAME}     Branchid=${BRANCH_ID}
    Create Session    lolo    ${API_URL}    cookies=${resp.cookies}
    ${resp}    Wait Until Keyword Succeeds    3x    0s    Delete Request    lolo    ${END_POINT}    headers=${headers}
    Log    ${resp.request.body}
    Log    ${resp.json()}
    log    ${resp.status_code}
    Should Be Equal As Strings    ${resp.status_code}    200

Delete request by other URL API
    [Arguments]   ${OTHER_API}    ${END_POINT}
    ${headers}=    Create Dictionary    Authorization=${bearertoken}    Content-Type=application/x-www-form-urlencoded     Retailer=${RETAILER_NAME}     Branchid=${BRANCH_ID}
    Create Session    lolo    ${OTHER_API}    cookies=${resp.cookies}
    ${resp}    Wait Until Keyword Succeeds    3x    0s    Delete Request    lolo    ${END_POINT}    headers=${headers}
    Log    ${resp.request.body}
    Log    ${resp.json()}
    log    ${resp.status_code}
    Should Be Equal As Strings    ${resp.status_code}    200

Get data from API
    [Arguments]    ${END_POINT}    ${json_path}
    [Timeout]    5 minutes
    : FOR    ${time}    IN RANGE    5
    \    ${resp1}    ${resp1.status_code}    Get Request and validate status code    ${END_POINT}
    \    Exit For Loop If    '${resp1.status_code}'=='200'
    Should Be Equal As Strings   ${resp1.status_code}    200
    ${get_raw_data}    Get Value From Json    ${resp1.json()}    ${json_path}
    ${result} =    Evaluate    ${get_raw_data}[0] if ${get_raw_data} else 0
    ${result} =    Evaluate    $result or 0
    Return From Keyword    ${result}

Get data from API by other url
    [Arguments]    ${API_SEC_URL}    ${END_POINT}    ${json_path}
    [Timeout]    5 minutes
    : FOR    ${time}    IN RANGE    5
    \    ${resp1}    ${resp1.status_code}    Get Request and validate status code By other url    ${API_SEC_URL}    ${END_POINT}
    \    Exit For Loop If    '${resp1.status_code}'=='200'
    Should Be Equal As Strings    ${resp1.status_code}    200
    ${get_raw_data}    Get Value From Json    ${resp1.json()}    ${json_path}
    ${result} =    Evaluate    ${get_raw_data}[0] if ${get_raw_data} else 0
    ${result} =    Evaluate    $result or 0
    Return From Keyword    ${result}

Get response from API by other url
    [Arguments]    ${API_SEC_URL}    ${END_POINT}
    [Timeout]    5 minutes
    : FOR    ${time}    IN RANGE    5
    \    ${resp1}    ${resp1.status_code}    Get Request and validate status code By other url    ${API_SEC_URL}    ${END_POINT}
    \    Exit For Loop If    '${resp1.status_code}'=='200'
    Should Be Equal As Strings    ${resp1.status_code}    200
    Return From Keyword    ${resp1.json()}

Get Request and return body
    [Arguments]    ${END_POINT}
    [Timeout]    5 minutes
    : FOR    ${time}    IN RANGE    5
    \    ${resp1}    ${resp1.status_code}    Get Request and validate status code    ${END_POINT}
    \    Log    ${resp1.json()}
    \    Exit For Loop If    '${resp1.status_code}'=='200'
    Should Be Equal As Strings    ${resp1.status_code}    200
    Log    ${resp1.json()}
    Return From Keyword    ${resp1.json()}

Get Request and return Json
    [Arguments]    ${END_POINT}    ${json_path}
    [Timeout]    5 minutes
    : FOR    ${time}    IN RANGE    5
    \    ${resp1}    ${resp1.status_code}    Get Request and validate status code    ${END_POINT}
    \    Exit For Loop If    '${resp1.status_code}'=='200'
    Should Be Equal As Strings    ${resp1.status_code}    200
    ${get_raw_data}    Get Value From Json    ${resp1.json()}    ${json_path}
    Return From Keyword    ${resp1.json()}

Get data from response json
    [Arguments]    ${resp1.json}    ${json_path}
    [Timeout]    5 minutes
    ${get_raw_data}    Get Value From Json    ${resp1.json}    ${json_path}
    ${result} =    Evaluate    ${get_raw_data}[0] if ${get_raw_data} else 0
    ${result} =    Evaluate    $result or 0
    Return From Keyword    ${result}

Get data from response json and return false value
    [Arguments]    ${resp1.json}    ${json_path}
    [Timeout]    5 minutes
    ${get_raw_data}    Get Value From Json    ${resp1.json}    ${json_path}
    ${result} =    Evaluate    ${get_raw_data}[0] if ${get_raw_data} else 0
    Return From Keyword    ${result}

Get boolean value from API
    [Arguments]    ${END_POINT}    ${json_path}
    [Timeout]    5 minutes
    : FOR    ${time}    IN RANGE    5
    \    ${resp1}    ${resp1.status_code}    Get Request and validate status code    ${END_POINT}
    \    Exit For Loop If    '${resp1.status_code}'=='200'
    Should Be Equal As Strings    ${resp1.status_code}    200
    ${get_raw_data}    Get Value From Json    ${resp1.json()}    ${json_path}
    ${result} =    Evaluate    ${get_raw_data}[0] if ${get_raw_data} else 0
    ${result} =    Evaluate    "${result}".lower()
    Return From Keyword    ${result}

Get and validate data from API
    [Arguments]    ${endpoint}    ${value_to_compare}    ${json_path}
    [Timeout]    5 minutes
    ${get_ma_hd_in_history_tab}    Get data from API    ${endpoint}    ${json_path}
    Should Be Equal    ${get_ma_hd_in_history_tab}    ${value_to_compare}

Get BearerToken from API
    [Timeout]    5 minutes
    # post to get bearer token
    ${credential}=    Create Dictionary    UserName=${USER_NAME}    Password=${PASSWORD}
    ${headers1}=    Create Dictionary    Content-Type=application/json    Retailer=${RETAILER_NAME}   Retailer=${RETAILER_NAME}     Branchid=${BRANCH_ID}
    Create Session    ali    ${API_URL}    headers=${headers1}    verify=True
    ${resp}=    Wait Until Keyword Succeeds    3x    0s   Post Request    ali    /auth/salelogin    data=${credential}
    Log    ${resp.json()}
    Should Be Equal As Strings    ${resp.status_code}    200
    Log    ${resp.cookies}
    ${bearertoken}    Get Value From Json    ${resp.json()}    $..BearerToken
    Log    ${bearertoken}
    ${bearertoken}=    Evaluate    ${bearertoken}[0] if ${bearertoken} else 0    modules=random, sys
    ${bearertoken}=    Catenate    Bearer    ${bearertoken}
    Log    ${bearertoken}
    Return From Keyword    ${bearertoken}    ${resp.cookies}

Get BearerToken by URL and account from API
    [Timeout]    5 minutes
    [Arguments]     ${input_tengianhang}    ${input_url}    ${input_username}     ${input_password}
    # post to get bearer token
    ${credential}=    Create Dictionary    UserName=${input_username}    Password=${input_password}
    ${headers1}=    Create Dictionary    Content-Type=application/json        Retailer=${input_tengianhang}
    Create Session    ali    ${input_url}    headers=${headers1}    verify=True
    ${resp1}=    Wait Until Keyword Succeeds    3x    0s    Post Request    ali    /api/auth/salelogin    data=${credential}
    Should Be Equal As Strings    ${resp1.status_code}    200
    Log    ${resp1.json()}
    Log    ${resp1.cookies}
    ${bearertoken}    Get Value From Json    ${resp1.json()}    $..BearerToken
    ${branchid}    Run Keyword If   '${input_url}'=='https://fnb.kiotviet.vn'   Get Value From Json    ${resp1.json()}    $..BranchId   ELSE      Get Value From Json    ${resp1.json()}    $..CurrentBranchId
    ${branchid}      Replace sq blackets    ${branchid}
    Log    ${bearertoken}
    ${bearertoken}=    Evaluate    ${bearertoken}[0] if ${bearertoken} else 0    modules=random, sys
    ${bearertoken}=    Catenate    Bearer    ${bearertoken}
    Log    ${bearertoken}
    Return From Keyword    ${bearertoken}    ${resp1.cookies}    ${branchid}

Get BearerToken by Admin from API
    [Timeout]    5 minutes
    # post to get bearer token
    ${credential}=    Create Dictionary    UserName=${USER_ADMIN}    Password=${PASSWORD}
    ${headers1}=    Create Dictionary    Content-Type=application/json    Retailer=${RETAILER_NAME}     Branchid=${BRANCH_ID}
    Create Session    ali    ${URL}    headers=${headers1}    verify=True
    ${resp}=    Post Request    ali    /api/auth/salelogin    data=${credential}
    Should Be Equal As Strings    ${resp.status_code}    200
    Log    ${resp.json()}
    Log    ${resp.cookies}
    ${bearertoken}    Get Value From Json    ${resp.json()}    $..BearerToken
    Log    ${bearertoken}
    ${bearertoken}=    Evaluate    ${bearertoken}[0] if ${bearertoken} else 0    modules=random, sys
    ${bearertoken}=    Catenate    Bearer    ${bearertoken}
    Log    ${bearertoken}
    Return From Keyword    ${bearertoken}    ${resp.cookies}

Get BearerToken with other user
    [Timeout]    5 minutes
    # post to get bearer token
    [Arguments]     ${input_username}     ${input_password}
    ${credential}=    Create Dictionary    UserName=${input_username}    Password=${input_password}
    ${headers1}=    Create Dictionary    Content-Type=application/json    Retailer=${RETAILER_NAME}     Branchid=${BRANCH_ID}
    Create Session    ali    ${URL}    headers=${headers1}    verify=True
    ${resp}=    Post Request    ali    /api/auth/salelogin    data=${credential}
    Should Be Equal As Strings    ${resp.status_code}    200
    Log    ${resp.json()}
    Log    ${resp.cookies}
    ${bearertoken}    Get Value From Json    ${resp.json()}    $..BearerToken
    Log    ${bearertoken}
    ${bearertoken}=    Evaluate    ${bearertoken}[0] if ${bearertoken} else 0    modules=random, sys
    ${bearertoken}=    Catenate    Bearer    ${bearertoken}
    Log    ${bearertoken}
    Return From Keyword    ${bearertoken}    ${resp.cookies}

Access page by auth credentials login
        [Timeout]    5 minutes
        [Arguments]        ${URL}      ${USER_NAME}       ${PASSWORD}
        ${credential}=    Create Dictionary    UserName=${USER_NAME}    Password=${PASSWORD}
        ${headers1}=    Create Dictionary    Content-Type=application/json    Retailer=${RETAILER_NAME}     Branchid=${BRANCH_ID}
        Create Session    ali    ${URL}    headers=${headers1}    verify=True
        ${resp}=    Post Request    ali    /api/auth/credentials    data=${credential}
        Should Be Equal As Strings    ${resp.status_code}    200
        Log    ${resp.json()}

Get data from API until success
    [Arguments]    ${END_POINT}    ${json_path}
    [Timeout]    5 minutes
    Wait Until Keyword Succeeds    3 times    5 s    Get data from API    ${END_POINT}    ${json_path}

Get raw data from API
    [Arguments]    ${END_POINT}    ${json_path}
    [Timeout]    5 minutes
    # post to get bearer token
    ${header}    Create Dictionary    Authorization=${bearertoken}    Retailer=${RETAILER_NAME}     Branchid=${BRANCH_ID}
    ${params}    Create Dictionary    format=json
    Create Session    lolo    ${API_URL}    cookies=${resp.cookies}
    ${resp1}=    Wait Until Keyword Succeeds    3x    0s    Get Request    lolo    ${END_POINT}    params=${params}    headers=${header}
    #Log    ${resp1.request.body}
    #Log    ${resp1.json()}
    #log    ${resp1.status_code}
    Should Be Equal As Strings    ${resp1.status_code}    200
    Log to Console    ${resp1.json()}
    ${get_raw_data}    Get Value From Json    ${resp1.json()}    ${json_path}
    Return From Keyword    ${get_raw_data}

Get raw data from response json
    [Arguments]    ${resp1.json}    ${json_path}
    [Timeout]    5 minutes
    ${get_raw_data}    Get Value From Json    ${resp1.json}    ${json_path}
    Return From Keyword    ${get_raw_data}

Get data from API by BranchID
    [Arguments]    ${branchid_bybranch}    ${END_POINT}    ${json_path}
    [Timeout]    5 minutes
    : FOR    ${time}    IN RANGE    5
    \    ${resp1}    ${resp1.status_code}    Get Request from API by BranchID and validate status code    ${branchid_bybranch}    ${END_POINT}
    \    Exit For Loop If    '${resp1.status_code}'=='200'
    Should Be Equal As Strings    ${resp1.status_code}    200
    ${get_raw_data}    Get Value From Json    ${resp1.json()}    ${json_path}
    ${result} =    Evaluate    ${get_raw_data}[0] if ${get_raw_data} else 0
    ${result} =    Evaluate    $result or 0
    Return From Keyword    ${result}


Get Request and return body from API by BranchID
     [Arguments]    ${branchid_bybranch}    ${END_POINT}
     [Timeout]    5 minutes
     : FOR    ${time}    IN RANGE    5
     \    ${resp1}    ${resp1.status_code}    Get Request from API by BranchID and validate status code    ${branchid_bybranch}    ${END_POINT}
     \    Exit For Loop If    '${resp1.status_code}'=='200'
     Should Be Equal As Strings    ${resp1.status_code}    200
     Return From Keyword    ${resp1.json()}

 Get Request and return body from API by BranchID and UserID
      [Arguments]    ${branchid_bybranch}    ${END_POINT}   ${input_username}
      [Timeout]    5 minutes
      : FOR    ${time}    IN RANGE    5
      \    ${resp1}    ${resp1.status_code}    Get Request from API by BranchID and UserNameID    ${branchid_bybranch}    ${input_username}    ${END_POINT}
      \    Exit For Loop If    '${resp1.status_code}'=='200'
      Should Be Equal As Strings    ${resp1.status_code}    200
      Return From Keyword    ${resp1.json()}

Get raw data from API by BranchID
    [Arguments]    ${branchid_bybranch}    ${END_POINT}    ${json_path}
    [Timeout]    5 minutes
    : FOR    ${time}    IN RANGE    5
    \    ${resp1}    ${resp1.status_code}    Get Request from API by BranchID and validate status code    ${branchid_bybranch}    ${END_POINT}
    \    Exit For Loop If    '${resp1.status_code}'=='200'
    Should Be Equal As Strings   ${resp1.status_code}    200
    ${get_raw_data}    Get Value From Json    ${resp1.json()}    ${json_path}
    Return From Keyword    ${get_raw_data}

Get current branch name
    [Timeout]    5 minutes
    ${current_branch_name}    Get data from API    ${endpoint_currentsession}    $.CurrentBranch.Name
    Return From Keyword    ${current_branch_name}

Get RetailerID
    [Timeout]    5 minutes
    ${get_retailer_id}    Get data from API    ${endpoint_currentsession}    $..Retailer.Id
    Return From Keyword    ${get_retailer_id}

Get User ID
    [Timeout]    5 minutes
    ${get_nguoitao}    Get data from API    ${endpoint_nguoitao}    $..UserId
    Return From Keyword    ${get_nguoitao}

Get ID nguoi tao frm API
    [Timeout]    5 minutes
    ${get_nguoitao}    Get data from API    ${endpoint_nguoitao}    $.CurrentUser.Id
    Return From Keyword    ${get_nguoitao}

Get nguoi tao frm API
    [Timeout]    5 minutes
    ${get_nguoitao}    Get data from API    ${endpoint_nguoitao}    $.CurrentUser.GivenName
    Return From Keyword    ${get_nguoitao}

Get nguoi ban frm BH page
    [Timeout]    5 minutes
    ${get_ten_nguoiban}    Get Text    ${cell_nguoiban}
    Return From Keyword    ${get_ten_nguoiban}

Get Retailer name
    [Timeout]    5 minutes
    ${get_url_bf}    Convert To String    ${URL}
    ${get_ten_gianhang}    Replace String    ${get_url_bf}    .kiotviet.vn    ${EMPTY}
    ${get_url_bf}    Convert To String    ${get_ten_gianhang}
    ${get_ten_gianhang}    Replace String    ${get_url_bf}    https://    ${EMPTY}
    Return From Keyword    ${get_ten_gianhang}

Get Request and validate status code
    [Arguments]    ${END_POINT}
    [Timeout]    5 minutes
    # post to get bearer token
    ${header}    Create Dictionary    Authorization=${bearertoken}     Content-Type=application/json;charset=utf-8    Retailer=${RETAILER_NAME}    Branchid=${BRANCH_ID}
    ${params}    Create Dictionary    format=json
    Create Session    lolo    ${API_URL}    cookies=${resp.cookies}   verify=True
    ${resp1}   Wait Until Keyword Succeeds    3x    0s     RequestsLibrary.Get Request    lolo    ${END_POINT}    params=${params}    headers=${header}
    Log    ${resp1.request.body}
    Log    ${resp1.json()}
    log    ${resp1.status_code}
    Return From Keyword    ${resp1}    ${resp1.status_code}

Get Request and validate status code By other url
    [Arguments]    ${API_SEC_URL}    ${END_POINT}
    [Timeout]    5 minutes
    # post to get bearer token
    ${header}    Create Dictionary    Authorization=${bearertoken}    Content-Type=application/json;charset=utf-8    Retailer=${RETAILER_NAME}    BranchId=${BRANCH_ID}
    ${params}    Create Dictionary    format=json
    Create Session    lala    ${API_SEC_URL}    cookies=${resp.cookies}
    ${resp1}    Wait Until Keyword Succeeds    3x    0s    RequestsLibrary.Get Request    lala    ${END_POINT}    params=${params}    headers=${header}
    Log    ${resp1.request.body}
    Log    ${resp1.json()}
    log    ${resp1.status_code}
    Return From Keyword    ${resp1}    ${resp1.status_code}

Get Request from API by BranchID and validate status code
    [Arguments]    ${branchid_bybranch}    ${END_POINT}
    [Timeout]    5 minutes
    ${header}    Create Dictionary    Authorization=${bearertoken}
    ${params}    Create Dictionary    format=json
    ${ss-tok-r}    Get From Dictionary    ${resp.cookies}    ss-tok
    ${ss-tok}    Catenate    ${ss-tok-r}
    ${ss-id-r}    Get From Dictionary    ${resp.cookies}    ss-id
    ${ss-id}    Catenate    ${ss-id-r}
    #${ss-opt-r}    Get From Dictionary    ${resp.cookies}    ss-opt
    #${ss-opt}    Catenate    ${ss-opt-r}
    ${ss-pid-r}    Get From Dictionary    ${resp.cookies}    ss-pid
    ${ss-pid}    Catenate    ${ss-pid-r}
    ${branchid_bybranch}    Catenate    ${branchid_bybranch}
    ${get_user_id}    Get User ID by UserName    ${USER_NAME}
    ${get_retailer_id}    Get RetailerID
    ${result_lastestbranch}     Format String        LatestBranch_{0}_{1}     ${get_retailer_id}      ${get_user_id}
    ${cookies_by_br}    Create Dictionary    ss-id=${ss-id}    ss-pid=${ss-pid}    ss-tok=${ss-tok}     ${result_lastestbranch}=${branchid_bybranch}    #ss-opt=${ss-opt}
    log    ${cookies_by_br}
    ${header}    Create Dictionary    Authorization=${bearertoken}    Content-Type=application/json;charset=utf-8    Retailer=${RETAILER_NAME}    BranchId=${branchid_bybranch}
    Create Session    lolo    ${API_URL}    cookies=${cookies_by_br}
    ${resp1}=    RequestsLibrary.Get Request    lolo    ${END_POINT}    params=${params}    headers=${header}
    Log    ${resp1.request.body}
    Log    ${resp1.json()}
    log    ${resp1.status_code}
    Return From Keyword    ${resp1}    ${resp1.status_code}

Get value from json and evaluate
    [Arguments]    ${json}    ${json_path}
    [Timeout]    5 minutes
    ${get_raw_data}    Get Value From Json    ${json}    ${json_path}
    ${result} =    Evaluate    ${get_raw_data}[0] if ${get_raw_data} else 0
    ${result} =    Evaluate    $result or 0
    Return From Keyword    ${result}

Get Request and validate status code By other url and branchid
    [Arguments]    ${API_SEC_URL}    ${END_POINT}
    [Timeout]    5 minutes
    # post to get bearer token
    ${header}    Create Dictionary    Authorization=${bearertoken}    Content-Type=application/json;charset=utf-8    Retailer=Retailer=${RETAILER_NAME}    BranchId=${BRANCH_ID}
    ${params}    Create Dictionary    format=json
    Create Session    lala    ${API_SEC_URL}    cookies=${resp.cookies}
    ${resp1}=    RequestsLibrary.Get Request    lala    ${END_POINT}    params=${params}    headers=${header}
    Log    ${resp1.request.body}
    Log    ${resp1.json()}
    log    ${resp1.status_code}
    Return From Keyword    ${resp1}    ${resp1.status_code}

Get Request from API by BranchID and UserNameID
    [Arguments]    ${branchid_bybranch}   ${input_username}    ${END_POINT}
    [Timeout]    5 minutes
    ${header}    Create Dictionary    Authorization=${bearertoken}
    ${params}    Create Dictionary    format=json
    ${ss-tok-r}    Get From Dictionary    ${resp.cookies}    ss-tok
    ${ss-tok}    Catenate    ${ss-tok-r}
    ${ss-id-r}    Get From Dictionary    ${resp.cookies}    ss-id
    ${ss-id}    Catenate    ${ss-id-r}
    ${ss-opt-r}    Get From Dictionary    ${resp.cookies}    ss-opt
    ${ss-opt}    Catenate    ${ss-opt-r}
    ${ss-pid-r}    Get From Dictionary    ${resp.cookies}    ss-pid
    ${ss-pid}    Catenate    ${ss-pid-r}
    ${branchid_bybranch}    Catenate    ${branchid_bybranch}
    ${get_user_id}    Get User ID by UserName    ${input_username}
    ${get_retailer_id}    Get RetailerID
    ${result_lastestbranch}     Format String        LatestBranch_{0}_{1}     ${get_retailer_id}      ${get_user_id}
    ${cookies_by_br}    Create Dictionary    ss-id=${ss-id}    ss-opt=${ss-opt}    ss-pid=${ss-pid}    ss-tok=${ss-tok}     ${result_lastestbranch}=${branchid_bybranch}
    log    ${cookies_by_br}
    Create Session    lolo    ${API_URL}    cookies=${cookies_by_br}
    ${resp1}=    RequestsLibrary.Get Request    lolo    ${END_POINT}    params=${params}
    Log    ${resp1.request.body}
    Log    ${resp1.json()}
    log    ${resp1.status_code}
    Return From Keyword    ${resp1}    ${resp1.status_code}

Get Request and return body by other url and branchid
    [Arguments]    ${API_SEC_URL}    ${END_POINT}
    [Timeout]    5 minutes
    : FOR    ${time}    IN RANGE    5
    \    ${resp1}    ${resp1.status_code}    Get Request and validate status code By other url and branchid    ${API_SEC_URL}    ${END_POINT}
    \    Exit For Loop If    '${resp1.status_code}'=='200'
    Should Be Equal As Strings    ${resp1.status_code}    200
    Return From Keyword    ${resp1.json()}

Get Request and validate status code - not cookies by other url
    [Arguments]    ${API_SEC_URL}    ${END_POINT}
    [Timeout]    5 minutes
    # post to get bearer token
    ${header}    Create Dictionary    Authorization=${bearertoken}    Content-Type=application/json;charset=utf-8     branchid=${BRANCH_ID}     retailer=${RETAILER_NAME}
    ${params}    Create Dictionary    format=json
    Create Session    lala    ${API_SEC_URL}
    ${resp1}=    RequestsLibrary.Get Request    lala    ${END_POINT}    params=${params}    headers=${header}
    Log    ${resp1.request.body}
    Log    ${resp1.json()}
    log    ${resp1.status_code}
    Return From Keyword    ${resp1}    ${resp1.status_code}

Get Request and return body by other url
    [Arguments]    ${API_SEC_URL}    ${END_POINT}
    [Timeout]    5 minutes
    : FOR    ${time}    IN RANGE    5
    \    ${resp1}    ${resp1.status_code}    Get Request and validate status code - not cookies by other url    ${API_SEC_URL}    ${END_POINT}
    \    Exit For Loop If    '${resp1.status_code}'=='200'
    Should Be Equal As Strings    ${resp1.status_code}    200
    Return From Keyword    ${resp1.json()}

Get BranchID by BranchName
        [Arguments]    ${input_branch_name}
        [Timeout]    1 minute
        ${jsonpath_product_id_byname}    Format String    $..Data[?(@.Name=="{0}")].Id    ${input_branch_name}
        ${get_branch_id}    Get data from API    ${endpoint_branch_list}    ${jsonpath_product_id_byname}
        ${get_branch_id}    Convert To String    ${get_branch_id}
        Return From Keyword    ${get_branch_id}

Get BranchID by Contact number
    [Arguments]    ${input_contactnumber}
    [Timeout]    5 minute
    ${jsonpath_product_id_byname}    Format String    $..Data[?(@.ContactNumber=="{0}")].Id    ${input_contactnumber}
    ${get_branch_id}    Get data from API    ${endpoint_branch_list}    ${jsonpath_product_id_byname}
    ${get_branch_id}    Convert To String    ${get_branch_id}
    Return From Keyword    ${get_branch_id}

Get User ID by UserName
    [Arguments]     ${username}
    ${jsonpath_user_id}     Format String     $..Data[?(@.UserName=="{0}")].Id       ${username}
    ${get_user_id}    Get data from API    ${endpoint_user}     ${jsonpath_user_id}
    Return From Keyword    ${get_user_id}

Post request and return body frm shipping api
    [Arguments]    ${END_POINT}   ${ma_vandon}   ${ma_dtgh}
    [Timeout]    5 minutes
    : FOR    ${time}    IN RANGE    1
    \       ${params}    Create Dictionary    ORDER_NUMBER=${ma_vandon}    client_code=${ma_dtgh}
    \       Create Session    lolo    https://shipping.kiotapi.com/api
    \       ${resp1}=    Post    lolo    ${END_POINT}
    \       Log    ${resp1.request.body}
    \       Log    ${resp1.json()}
    \       log    ${resp1.status_code}
    \    Exit For Loop If    '${resp1.status_code}'=='202'
    ${get_resp}    Convert To String    ${resp1.json()}
    ${get_resp}    Replace String    ${get_resp}    \    ${EMPTY}
    ${get_resp}    Replace String    ${get_resp}    '    "
    ${get_resp}    Replace String    ${get_resp}    "[    [
    ${get_resp}    Replace String    ${get_resp}    ]"    ]
    ${get_resp}    Replace String    ${get_resp}    None    null
    ${cam_json}    Evaluate    json.loads('''${cam}''')    json
    Log    ${cam}
    Return From Keyword    ${get_resp}
