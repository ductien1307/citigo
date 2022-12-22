*** Settings ***
Library           SeleniumLibrary
Library           String
Library           Collections
Library           RequestsLibrary
Resource          ../../core/API_Public/share.robot

*** Variables ***
${API_GET_TOKEN}     https://id.kiotviet.vn
${ENDPOINT_GET_TOKEN}    /connect/token
${API_URL}     https://public.kiotapi.com

*** Keywords ***
Fill env
    [Arguments]    ${env}
    Log    ${env}
    #${DICT_RETAILER_NAME}    Create Dictionary    live4=autobot3
    ${DICT_RETAILER_NAME}    Create Dictionary    live4=testz43
    ${DICT_BRANCH_ID}    Create Dictionary    live4=32224
    #${DICT_CLIENT_ID}    Create Dictionary    live4=12650e60-7c6c-4bb7-8736-44db5deec308
    #${DICT_CLIENT_SECRET}    Create Dictionary    live4=A38B89DCC16E9FDF4A671147B577B7BDCEB1E9A2
    ${DICT_CLIENT_ID}    Create Dictionary    live4=44273fb8-5700-40bd-b800-bf92f3322e78
    ${DICT_CLIENT_SECRET}    Create Dictionary    live4=5111A7AB8F37C05B5CAE70D64D99D8484B06DDA8
    ###################################################################################################################
    ${BRANCH_ID}    Get From Dictionary    ${DICT_BRANCH_ID}    ${env}
    ${RETAILER_NAME}    Get From Dictionary    ${DICT_RETAILER_NAME}    ${env}
    ${CLIENT_ID}    Get From Dictionary    ${DICT_CLIENT_ID}    ${env}
    ${CLIENT_SECRET}    Get From Dictionary    ${DICT_CLIENT_SECRET}    ${env}
    ###################################################################################################################
    Set Global Variable    \${API_GET_TOKEN}    ${API_GET_TOKEN}
    Set Global Variable    \${ENDPOINT_GET_TOKEN}    ${ENDPOINT_GET_TOKEN}
    Set Global Variable    \${API_URL}    ${API_URL}
    Set Global Variable    \${BRANCH_ID}    ${BRANCH_ID}
    Set Global Variable    \${CLIENT_ID}    ${CLIENT_ID}
    Set Global Variable    \${CLIENT_SECRET}    ${CLIENT_SECRET}
    Set Global Variable    \${RETAILER_NAME}    ${RETAILER_NAME}

Init Test Environment
    [Arguments]    ${env}
    Fill env    ${env}
    ############################ Get Token ############################
    ${dataGetToken}  Create Dictionary    scopes=PublicApi.Access   grant_type=client_credentials   client_id=${CLIENT_ID}  client_secret=${CLIENT_SECRET}
    ${headerGetToken}  Create Dictionary  Content-Type=application/x-www-form-urlencoded
    Create Session    getTokenSession    ${API_GET_TOKEN}
    ${respone}    Post Request    getTokenSession    ${ENDPOINT_GET_TOKEN}  headers=${headerGetToken}  data=${dataGetToken}
    Should Be Equal As Strings       ${respone.status_code}   200
    ${bearerToken}   Get Value From Json KiotViet    ${respone.json()}    $.access_token
    ${bearerToken}  Catenate    Bearer  ${bearerToken}
    Log  ${bearerToken}
    Delete All Sessions
    ############################ Create Header For All Case ############################
    ${headers}    Create Dictionary   Authorization=${bearerToken}   Content-Type=application/json    retailer=${RETAILER_NAME}
    ${headers_not_contenType}    Create Dictionary   Authorization=${bearerToken}    retailer=${RETAILER_NAME}
    Set Global Variable    ${headers}    ${headers}
    Set Global Variable    ${headers_not_contenType}    ${headers_not_contenType}
    Log  ${headers}
    Create Session    PublicAPI    ${API_URL}
    Set Global Variable    ${PublicAPISession}    PublicAPI
