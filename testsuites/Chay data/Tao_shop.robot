*** Settings ***
#Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}
Library           Collections
Resource          ../../config/env_product/envi.robot

*** Variables ***

*** Test Cases ***
Them moi shop
    [Tags]
    [Template]    Add new shop basic
    cctv1

Them n shop
    [Tags]
    [Template]    Add multi shop
    1

Gia han shop
    [Tags]    iiio
    [Template]    Update shop 59925

*** Keyword ***
Add multi shop
    [Arguments]       ${time}
    ${list_shop}   Create List
    :FOR    ${item}     IN RANGE      1000
     \    ${ma}      Generate Random String    4    [UPPER][NUMBERS]
     \    ${shop}      Catenate      SEPARATOR=      autokvsalenew     ${ma}
     \    Append To List    ${list_shop}    ${shop}
     Log    ${list_shop}
    :FOR      ${item_shop}    IN      @{list_shop}
     \    Add new shop basic    ${item_shop}

Add new shop basic
    [Arguments]    ${ten_shop}
    ${data_str}    Format String    {{"Retailer":{{"CompanyName":"Test","CompanyAddress":"hn","LocationName":"Hà Nội - Quận Hai Bà Trưng","temploc":"Hà Nội - Quận Hai Bà Trưng","WardName":"Phường Ngô Thì Nhậm","tempw":"Phường Ngô Thì Nhậm","LocationId":242,"Code":"{0}","ContractType":1,"IndustryId":7,"ContractDate":"2020-04-16T17:00:00.000Z","ExpiryDate":"2020-04-29T17:00:00.000Z"}},"User":{{"GivenName":"admin","UserName":"admin","PlainPassword":"123"}},"Branch":{{"Name":"CNTT"}}}}   ${ten_shop}
    log    ${data_str}
    ${headers1}=    Create Dictionary     Content-Type=application/json;charset=utf-8          Authority=qlkv.kvpos.com:59925     cookie=_ga=GA1.2.1624587678.1586230242; __zlcmid=xbj2e8IPFvwuYt; _gid=GA1.2.1867528830.1587032521; ss-opt=temp; ss-id=u4nBchARiwgKeWgoewkp; ss-pid=hapefiUs8lz11UOUcR0T; ss-tok=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiIsImtpZCI6IjJYViJ9.eyJpc3MiOiJrdnNzand0Iiwic3ViIjoxLCJpYXQiOjE1ODcxMTAzMjIsImV4cCI6MTU4NzE5NjcyMiwicHJlZmVycmVkX3VzZXJuYW1lIjoiYWRtaW5Aa2lvdHZpZXQuY29tIiwicm9sZXMiOlsiVXNlciIsIkJhY2tFbmQiLCJBcHAiLCJTdXBwb3J0IiwiUmVuZXciLCJTdXBwb3J0VGVjaCIsIlJlbW90ZUFjY291bnQiLCJTdXBwb3J0TGVhZGVyIiwiRXh0ZW5kIiwiR2xvYmFsIl0sImt2c2VzIjoiZmIwZGJhNWQ4N2I2NGJmYThjNDJmNWUyM2NkYmI3OTUiLCJrdnVpZCI6MSwia3Z1dHlwZSI6NCwia3Z1YWRtaW4iOiJUcnVlIiwia3Z1YWN0IjoiVHJ1ZSIsImt2dWVtYWlsIjoiIiwicGVybXMiOiIifQ.P-ti6Uc5IDBLKHZ43XNIyOlf5PNjj9hPh68a3mE9zpo; G_ENABLED_IDPS=google
    Create Session    lolo    https://qlkv.kvpos.com:59918/api
    ${resp3}=    Post Request    lolo    /retailers    data=${data_str}    headers=${headers1}
    Log    ${resp3.request.body}
    Log    ${resp3.json()}
    log    ${resp3.status_code}
    Should Be Equal As Strings    ${resp3.status_code}    200

Update shop 59925
    [Arguments]    ${retailer_id}   ${ten_shop}
    ${data_str}    Format String    {{"Retailer":{{"Id":{0},"Code":"{1}","CompanyAddress":"hn","LocationName":"Hà Nội - Quận Bắc Từ Liêm","WardName":"Phường Quán Thánh","CompanyName":"Test","TotalProducts":0,"TotalRevenue":0,"TotalBranchs":1,"CreatedDate":"2020-04-17T11:56:20.9030000","ExpiryDate":"2021-05-01T17:00:00.000Z","SignUpType":"Web Site","IndustryId":7,"GroupId":1,"MaximumBranchs":1,"MaximumProducts":0,"MaximumFanpages":0,"LimitKiotMailInMonth":0,"ContractType":1,"ContractDate":"2020-03-17T00:00:00.0000000","CompareCompanyName":"Test","CompareCompanyAddress":"hn","CompareCode":"testship1915","CompareExpiryDate":"2020-05-02T04:55:20.837Z","CompareIndustryId":7,"CompareMaximumProducts":0,"CompareMaximumBranchs":1,"temploc":"Hà Nội - Quận Bắc Từ Liêm","tempw":"Phường Quán Thánh"}}}}      ${retailer_id}   ${ten_shop}
    log    ${data_str}
    ${headers1}=    Create Dictionary     Content-Type=application/json;charset=utf-8          Authority=qlkv.kvpos.com:59925    cookie=_ga=GA1.2.1832967081.1581651326; __zlcmid=wkiuagwTN2o5PJ; ss-opt=temp; G_ENABLED_IDPS=google; _gid=GA1.2.135694495.1588738965; ss-id=dJtFoy2Hjv6a4nxxdR7b; ss-pid=yhfFyYpvnXuZLqMou5TY; ss-tok=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiIsImtpZCI6IjJYViJ9.eyJpc3MiOiJrdnNzand0Iiwic3ViIjoxLCJpYXQiOjE1ODg4NDY3OTAsImV4cCI6MTU4ODkzMzE5MCwicHJlZmVycmVkX3VzZXJuYW1lIjoiYWRtaW5Aa2lvdHZpZXQuY29tIiwicm9sZXMiOlsiVXNlciIsIkJhY2tFbmQiLCJBcHAiLCJTdXBwb3J0IiwiUmVuZXciLCJTdXBwb3J0VGVjaCIsIlJlbW90ZUFjY291bnQiLCJTdXBwb3J0TGVhZGVyIiwiRXh0ZW5kIiwiR2xvYmFsIl0sImt2c2VzIjoiYmRlYzZhYWM1NTJjNGE5ODk2ZmZhNzVhNjE5NDYzMWQiLCJrdnVpZCI6MSwia3Z1dHlwZSI6NCwia3Z1YWRtaW4iOiJUcnVlIiwia3Z1YWN0IjoiVHJ1ZSIsImt2dWVtYWlsIjoiIiwicGVybXMiOiIifQ.UuVDlmRmrnbU7JE6t2L1hSsaXUZW1kHKiDY-VreA9VY
    Create Session    lolo    https://qlkv.kvpos.com:59925/api
    ${resp3}=    Post Request    lolo    /retailers    data=${data_str}    headers=${headers1}
    Log    ${resp3.request.body}
    Log    ${resp3.json()}
    log    ${resp3.status_code}
    Should Be Equal As Strings    ${resp3.status_code}    200

Update shop 59909
    [Arguments]    ${retailer_id}   ${ten_shop}
    ${data_str}    Format String    {{"Retailer":{{"Id":{0},"Code":"{1}","CompanyAddress":"******","LocationName":"******","WardName":"Phường Quán Thánh","CompanyName":"Test","TotalProducts":25,"TotalRevenue":7163648000,"TotalBranchs":1,"Phone":"******","CreatedDate":"2020-03-18T12:13:12.8430000","ExpiryDate":"2022-04-01T17:00:00.000Z","SignUpType":"Web Site","IndustryId":7,"GroupId":1,"MaximumBranchs":1,"MaximumProducts":0,"MaximumFanpages":0,"LimitKiotMailInMonth":0,"ContractType":1,"ContractDate":"2020-03-17T00:00:00.0000000","CompareCompanyName":"Test","CompareCompanyAddress":"******","ComparePhone":"******","CompareCode":"autokvaa001000","CompareExpiryDate":"2020-04-02T05:12:12.737Z","CompareIndustryId":7,"CompareMaximumProducts":0,"CompareMaximumBranchs":1,"temploc":"******","tempw":"Phường Quán Thánh"}}}}      ${retailer_id}   ${ten_shop}
    log    ${data_str}
    ${headers1}=    Create Dictionary     Content-Type=application/json;charset=utf-8          Authority=qlkv.kvpos.com:59909     cookie=_ga=GA1.2.1832967081.1581651326; __zlcmid=wkiuagwTN2o5PJ; ss-opt=temp; G_ENABLED_IDPS=google; _gid=GA1.2.1899820043.1586846946; ss-tok=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiIsImtpZCI6IjJYViJ9.eyJpc3MiOiJrdnNzand0Iiwic3ViIjoxMjM2NCwiaWF0IjoxNTg3MDI5Mzc0LCJleHAiOjE1ODcxMTU3NzQsInByZWZlcnJlZF91c2VybmFtZSI6ImFkbWluQGtpb3R2aWV0LmNvbSIsInJvbGVzIjpbIlVzZXIiLCJCYWNrRW5kIiwiQXBwIiwiU3VwcG9ydCIsIlJlbmV3IiwiU3VwcG9ydFRlY2giLCJSZW1vdGVBY2NvdW50IiwiU3VwcG9ydExlYWRlciIsIkV4dGVuZCIsIkdsb2JhbCJdLCJrdnNlcyI6IjVjYWIxZmZlMTIyNTRmYmNiM2I4ODRjNTQ4MzU5YzI0Iiwia3Z1aWQiOjEyMzY0LCJrdnV0eXBlIjo0LCJrdnVhZG1pbiI6IlRydWUiLCJrdnVhY3QiOiJUcnVlIiwia3Z1ZW1haWwiOiIiLCJwZXJtcyI6IiJ9.rexzJPU9Hg8pbb-r4KgzGpvpvXcXvP1TKZGYk-TN0Uc; ss-pid=OtYC0fst6cIEbQbCIujq; ss-id=BQnujBF2miTwHcOf7Iei
    Create Session    lolo    https://qlkv.kvpos.com:59909/api
    ${resp3}=    Post Request    lolo    /retailers    data=${data_str}    headers=${headers1}
    Log    ${resp3.request.body}
    Log    ${resp3.json()}
    log    ${resp3.status_code}
    Should Be Equal As Strings    ${resp3.status_code}    200
