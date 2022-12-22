*** Settings ***
Library           Collections
Library           RequestsLibrary
Library           SeleniumLibrary
Library           OperatingSystem
Library           String
Library           JSONLibrary
Library           StringFormat
Resource          ../../../core/API/api_access.robot

*** Keywords ***
Create receipt category
    [Arguments]    ${name}    ${hach_toan}
    ${data_str}    Format String    {{"Group":{{"FlowType":1,"UsedForFinancialReporting":{1},"Name":"{0}"}}}}    ${name}    ${hach_toan}
    Log    ${data_str}
    Post request thr API    /cashflow/groups    ${data_str}

Create payment category
    [Arguments]    ${name}    ${hach_toan}
    ${data_str}    Format String    {{"Group":{{"FlowType":2,"UsedForFinancialReporting":{1},"Name":"{0}"}}}}    ${name}    ${hach_toan}
    Log    ${data_str}
    Post request thr API    /cashflow/groups    ${data_str}

Create bank account
    [Arguments]    ${ten_tk}    ${so_tk}
    ${data_str}    Format String    {{"BankAcc":{{"Bank":"{0}","Account":"{1}","BankCode":"Vietcombank","BankName":"Ngân hàng TMCP Ngoại thương Việt Nam","Branch":"","AccountName":""}}}}    ${ten_tk}    ${so_tk}
    Log    ${data_str}
    Post request thr API    /bankaccount    ${data_str}

Add partner
    [Arguments]    ${ten}    ${sdt}
    ${data_str}    Format String    {{"Partner":{{"temploc":"","tempw":"","Name":"{0}","ContactNo":"{1}","LocationName":"","WardName":""}}}}    ${ten}    ${sdt}
    Log    ${data_str}
    Post request thr API    /partners    ${data_str}
