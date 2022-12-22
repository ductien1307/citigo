*** Settings ***
Library           Collections
Library           RequestsLibrary
Library           SeleniumLibrary
Library           OperatingSystem
Library           String
Library           StringFormat
Library           JSONLibrary
Library           DateTime
Resource          ../share/computation.robot
Resource          api_access.robot

*** Variables ***

*** Keywords ***
Get BearerToken from QLKV
    [Timeout]    5 minutes
    [Arguments]     ${input_username}     ${input_password}
    # post to get bearer token
    ${credential}=    Create Dictionary    UserName=${input_username}    Password=${input_password}
    Create Session    ali    https://qlkv.kvpos.com:${env}
    ${resp}=    Wait Until Keyword Succeeds    3x    0s     Post Request     ali    /api/auth/login    data=${credential}
    Log    ${resp.json()}
    Should Be Equal As Strings    ${resp.status_code}    200
    Log    ${resp.cookies}
    ${bearertoken}    Get Value From Json    ${resp.json()}    $..BearerToken
    Log    ${bearertoken}
    ${bearertoken}=    Evaluate    ${bearertoken}[0] if ${bearertoken} else 0    modules=random, sys
    ${bearertoken}=    Catenate    Bearer    ${bearertoken}
    Log    ${bearertoken}
    Set Global Variable    \${bearertoken}    ${token_value}
    Set Global Variable    \${resp.cookies}    ${resp.cookies}
    Return From Keyword    ${bearertoken}    ${resp.cookies}

Add new shop in QLKV thr API
    [Arguments]    ${ten_shop}
    ${data_str}    Format String    {{"Retailer":{{"CompanyName":"Test","CompanyAddress":"hn","LocationName":"Hà Nội - Quận Hai Bà Trưng","temploc":"Hà Nội - Quận Hai Bà Trưng","WardName":"Phường Ngô Thì Nhậm","tempw":"Phường Ngô Thì Nhậm","LocationId":242,"Code":"{0}","ContractType":1,"IndustryId":7,"ContractDate":"2020-04-16T17:00:00.000Z","ExpiryDate":"2020-04-29T17:00:00.000Z"}},"User":{{"GivenName":"admin","UserName":"admin","PlainPassword":"123"}},"Branch":{{"Name":"CNTT"}}}}   ${ten_shop}
    log    ${data_str}
    ${headers1}=    Create Dictionary     Content-Type=application/json;charset=utf-8          Authority=qlkv.kvpos.com:${env}     cookies=${resp.cookies}
    Create Session    lolo    https://qlkv.kvpos.com:59918/api
    ${resp3}=    Wait Until Keyword Succeeds    3x    0s     Post Request       lolo    /retailers    data=${data_str}    headers=${headers1}
    Log    ${resp3.request.body}
    Log    ${resp3.json()}
    log    ${resp3.status_code}
    Should Be Equal As Strings    ${resp3.status_code}    200
