*** Settings ***
Library           JSONLibrary
Library           RequestsLibrary
Library           String
Library           StringFormat
Resource          ../share/computation.robot
Resource          ../../config/envi.robot
Library           BuiltIn

*** Variables ***
${endpoint_branch_list}    /branchs
${endpoint_currentsession_mobile}    /currentsession
${endpoint_nguoitao}    /retailers/currentsession
${endpoint_user}      /users

*** Keywords ***
Post request thr mobile API
    [Arguments]   ${END_POINT}    ${payload}
    ${headers1}=    Create Dictionary    Authorization=${bearertoken}    Content-Type=application/json;charset=utf-8    Retailer=${RETAILER_NAME}     Branchid=${BRANCH_ID}
    Create Session    lolo    ${MOBILE_API_URL}    cookies=${resp.cookies}
    ${resp2}     Post Request    lolo    ${END_POINT}    data=${payload}    headers=${headers1}
    Log    ${resp2.request.body}
    Log    ${resp2.json()}
    Should Be Equal As Strings    ${resp2.status_code}    200
    Return From Keyword    ${resp2.status_code}    ${resp2.json()}

Get data from mobile API
    [Arguments]    ${END_POINT}    ${json_path}
    [Timeout]    5 minutes
    : FOR    ${time}    IN RANGE    5
    \    ${resp1}    ${resp1.status_code}    Get mobile Request and validate status code    ${END_POINT}
    \    Exit For Loop If    '${resp1.status_code}'=='200'
    ${get_raw_data}    Get Value From Json    ${resp1.json()}    ${json_path}
    ${result} =    Evaluate    ${get_raw_data}[0] if ${get_raw_data} else 0
    ${result} =    Evaluate    $result or 0
    Return From Keyword    ${result}

Get mobile Request and return body
    [Arguments]    ${END_POINT}
    [Timeout]    5 minutes
    : FOR    ${time}    IN RANGE    5
    \    ${resp1}    ${resp1.status_code}    Get mobile Request and validate status code    ${END_POINT}
    \    Exit For Loop If    '${resp1.status_code}'=='200'
    Return From Keyword    ${resp1.json()}

Get Request and return Json
    [Arguments]    ${END_POINT}    ${json_path}
    [Timeout]    5 minutes
    : FOR    ${time}    IN RANGE    5
    \    ${resp1}    ${resp1.status_code}    Get mobile Request and validate status code    ${END_POINT}
    \    Exit For Loop If    '${resp1.status_code}'=='200'
    ${get_raw_data}    Get Value From Json    ${resp1.json()}    ${json_path}
    Return From Keyword    ${resp1.json()}

Get mobile data from response json
    [Arguments]    ${resp1.json}    ${json_path}
    [Timeout]    5 minutes
    ${get_raw_data}    Get Value From Json    ${resp1.json}    ${json_path}
    ${result} =    Evaluate    ${get_raw_data}[0] if ${get_raw_data} else 0
    ${result} =    Evaluate    $result or 0
    Return From Keyword    ${result}

Get mobile BearerToken from API
    [Timeout]    5 minutes
    # post to get bearer token
    ${credential}=    Create Dictionary    UserName=${USER_NAME}    Password=${PASSWORD}    UseTokenCookie=true     provider=credentials
    ${headers1}=    Create Dictionary    Content-Type=application/json    Retailer=${RETAILER_NAME}
    Create Session    ali    ${MOBILE_API_URL}    headers=${headers1}    verify=True
    ${resp}=    Post Request    ali    /auth/credentials    data=${credential}
    Should Be Equal As Strings    ${resp.status_code}    200
    Log    ${resp.json()}
    Log    ${resp.cookies}
    ${bearertoken_mobile}    Get Value From Json    ${resp.json()}    $..BearerToken
    Log    ${bearertoken_mobile}
    ${bearertoken_mobile}=    Evaluate    ${bearertoken_mobile}[0] if ${bearertoken_mobile} else 0    modules=random, sys
    ${bearertoken_mobile}=    Catenate    Bearer    ${bearertoken_mobile}
    Log    ${bearertoken_mobile}
    Return From Keyword    ${bearertoken_mobile}    ${resp.cookies}

Get data from mobile API until success
    [Arguments]    ${END_POINT}    ${json_path}
    [Timeout]    5 minutes
    Wait Until Keyword Succeeds    3 times    10 s    Get data from mobile API    ${END_POINT}    ${json_path}

Get raw mobile data from API
    [Arguments]    ${END_POINT}    ${json_path}
    [Timeout]    5 minutes
    # post to get bearer token
    ${header}    Create Dictionary    Authorization=${bearertoken_mobile}     Retailer=${RETAILER_NAME}
    ${params}    Create Dictionary    format=json
    Create Session    lolo    ${MOBILE_API_URL}    cookies=${resp.cookies}
    ${resp1}=    RequestsLibrary.Get Request    lolo    ${END_POINT}    params=${params}    headers=${header}
    #Log    ${resp1.request.body}
    #Log    ${resp1.json()}
    #log    ${resp1.status_code}
    Should Be Equal As Strings    ${resp1.status_code}    200
    Log to Console    ${resp1.json()}
    ${get_raw_data}    Get Value From Json    ${resp1.json()}    ${json_path}
    Return From Keyword    ${get_raw_data}

Get raw mobile data from response json
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
     Return From Keyword    ${resp1.json()}

 Get Request and return body from API by BranchID and UserID
      [Arguments]    ${branchid_bybranch}    ${END_POINT}   ${input_username}
      [Timeout]    5 minutes
      : FOR    ${time}    IN RANGE    5
      \    ${resp1}    ${resp1.status_code}    Get Request from API by BranchID and UserNameID    ${branchid_bybranch}    ${input_username}    ${END_POINT}
      \    Exit For Loop If    '${resp1.status_code}'=='200'
      Return From Keyword    ${resp1.json()}

Get raw data from API by BranchID
    [Arguments]    ${branchid_bybranch}    ${END_POINT}    ${json_path}
    [Timeout]    5 minutes
    : FOR    ${time}    IN RANGE    5
    \    ${resp1}    ${resp1.status_code}    Get Request from API by BranchID and validate status code    ${branchid_bybranch}    ${END_POINT}
    \    Exit For Loop If    '${resp1.status_code}'=='200'
    ${get_raw_data}    Get Value From Json    ${resp1.json()}    ${json_path}
    Return From Keyword    ${get_raw_data}

Get raw mobile data incase other user
    [Arguments]    ${END_POINT}   ${input_username}    ${input_pass}    ${json_path}
    [Timeout]    5 minutes
    : FOR    ${time}    IN RANGE    5
    \    ${resp1}    ${resp1.status_code}    Get Request and validate mobile status code incase other user    ${END_POINT}   ${input_username}    ${input_pass}
    \    Exit For Loop If    '${resp1.status_code}'=='200'
    ${get_raw_data}    Get Value From Json    ${resp1.json()}    ${json_path}
    Return From Keyword    ${get_raw_data}

Get mobile BearerToken with other user
    [Timeout]    5 minutes
    [Arguments]     ${input_username}     ${input_password}
    # post to get bearer token
    ${credential}=    Create Dictionary    UserName=${input_username}    Password=${input_password}    UseTokenCookie=true     provider=credentials
    ${headers1}=    Create Dictionary    Content-Type=application/json    Retailer=${RETAILER_NAME}
    Create Session    ali    ${MOBILE_API_URL}    headers=${headers1}    verify=True
    ${resp}=    Post Request    ali    /auth/credentials    data=${credential}
    Should Be Equal As Strings    ${resp.status_code}    200
    Log    ${resp.json()}
    Log    ${resp.cookies}
    ${bearertoken}    Get Value From Json    ${resp.json()}    $..BearerToken
    Log    ${bearertoken}
    ${bearertoken}=    Evaluate    ${bearertoken}[0] if ${bearertoken} else 0    modules=random, sys
    ${bearertoken}=    Catenate    Bearer    ${bearertoken}
    Log    ${bearertoken}
    Return From Keyword    ${bearertoken}    ${resp.cookies}

Get mobile Request and validate status code incase other user
    [Arguments]    ${END_POINT}   ${input_username}    ${input_pass}
    [Timeout]    5 minutes
    ${bearertoken_current}    ${resp.cookies1}    Get mobile BearerToken with other user    ${input_username}    ${input_pass}
    ${header}    Create Dictionary    Authorization=${bearertoken_current}
    ${params}    Create Dictionary    format=json
    Create Session    lolo    ${MOBILE_API_URL}    cookies=${resp.cookies1}
    ${resp1}=    RequestsLibrary.Get Request    lolo    ${END_POINT}    params=${params}    headers=${header}
    Log    ${resp1.request.body}
    Log    ${resp1.json()}
    log    ${resp1.status_code}
    Return From Keyword    ${resp1}    ${resp1.status_code}

Get list current branch name frm mobile api
    [Arguments]    ${input_username}    ${input_pass}
    [Timeout]    3 minutes
    ${get_list_current_branch}    Get raw data incase other user    ${endpoint_currentsession}    ${input_username}    ${input_pass}   $.Branches..Name
    Return From Keyword    ${get_list_current_branch}

Get current mobile branch name
    [Timeout]    3 minutes
    ${current_branch_name}    Get data from mobile API    ${endpoint_currentsession_mobile}    $.CurrentBranch..Name
    Return From Keyword    ${current_branch_name}

Get Retailer ID frm mobile api
    [Timeout]    3 minutes
    ${get_retailer_id}    Get data from mobile API    ${endpoint_currentsession_mobile}    Retailer..Id
    Return From Keyword    ${get_retailer_id}

Get User ID frm mobile api
    [Timeout]    3 minutes
    ${get_nguoitao}    Get data from mobile API    ${endpoint_currentsession_mobile}    $.CurrentUser..Id
    Return From Keyword    ${get_nguoitao}

Get nguoi tao frm API
    [Timeout]    3 minutes
    ${get_nguoitao}    Get data from mobile API    ${endpoint_nguoitao}    $.CurrentUser.GivenName
    Return From Keyword    ${get_nguoitao}

Get mobile request and validate status code
    [Arguments]    ${END_POINT}
    [Timeout]    5 minutes
    # post to get bearer token
    ${header}    Create Dictionary    Authorization=${bearertoken_mobile}    Retailer=${RETAILER_NAME}
    ${params}    Create Dictionary    Content-Type=application/json;charset=UTF-8
    Create Session    lolo    ${MOBILE_API_URL}    cookies=${resp.cookies_mobile}
    ${resp1}=    RequestsLibrary.Get Request    lolo    ${END_POINT}    params=${params}    headers=${header}
    Log    ${resp1.request.body}
    Log    ${resp1.json()}
    log    ${resp1.status_code}
    Should Be Equal As Strings    ${resp1.status_code}    200
    Return From Keyword    ${resp1}    ${resp1.status_code}

Get mobile request and validate status code By other url
    [Arguments]    ${API_SEC_URL}    ${END_POINT}
    [Timeout]    5 minutes
    # post to get bearer token
    ${header}    Create Dictionary    Authorization=${bearertoken}    Content-Type=application/json;charset=utf-8    Retailer=${RETAILER_NAME}    BranchId=${BRANCH_ID}
    ${params}    Create Dictionary    format=json
    Create Session    lala    ${API_SEC_URL}    cookies=${resp.cookies}
    ${resp1}=    RequestsLibrary.Get Request    lala    ${END_POINT}    params=${params}    headers=${header}
    Log    ${resp1.request.body}
    Log    ${resp1.json()}
    log    ${resp1.status_code}
    Return From Keyword    ${resp1}    ${resp1.status_code}

Get Request from API by BranchID and validate status code
    [Arguments]    ${branchid_bybranch}    ${END_POINT}
    [Timeout]    5 minutes
    ${header}    Create Dictionary    Authorization=${bearertoken_mobile}
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
    Create Session    lolo    ${API_URL}    cookies=${cookies_by_br}
    ${resp1}=    RequestsLibrary.Get Request    lolo    ${END_POINT}    params=${params}
    Log    ${resp1.request.body}
    Log    ${resp1.json()}
    log    ${resp1.status_code}
    Return From Keyword    ${resp1}    ${resp1.status_code}

Get mobile value from json and evaluate
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
    ${header}    Create Dictionary    Authorization=${bearertoken_mobile}    Content-Type=application/json;charset=utf-8    Retailer=Retailer=${RETAILER_NAME}    BranchId=${BRANCH_ID}
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
    ${header}    Create Dictionary    Authorization=${bearertoken_mobile}
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
    Return From Keyword    ${resp1.json()}

Get Request and validate status code - not cookies by other url
    [Arguments]    ${API_SEC_URL}    ${END_POINT}
    [Timeout]    5 minutes
    # post to get bearer token
    ${header}    Create Dictionary    Authorization=${bearertoken_mobile}    Content-Type=application/json;charset=utf-8
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
    Return From Keyword    ${resp1.json()}

Get BranchID by mobile BranchName
    [Arguments]    ${input_branch_name}
    [Timeout]    5 minutes
    ${jsonpath_product_id_byname}    Format String    $..Data[?(@.Name=="{0}")].Id    ${input_branch_name}
    ${get_branch_id}    Get data from mobile API    ${endpoint_branch_list}    ${jsonpath_product_id_byname}
    ${get_branch_id}    Convert To String    ${get_branch_id}
    Return From Keyword    ${get_branch_id}

Get User ID by mobile UserName
    [Arguments]     ${username}
    ${jsonpath_user_id}     Format String     $..Data[?(@.UserName=="{0}")].Id       ${username}
    ${get_user_id}    Get data from mobile API    ${endpoint_user}     ${jsonpath_user_id}
    Return From Keyword    ${get_user_id}
