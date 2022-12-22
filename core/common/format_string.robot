*** Settings ***
Library           SeleniumLibrary

*** Keywords ***
Format String For Json Object
    [Arguments]    ${payload_Str}
    ${payload_Str}    Replace String    ${payload_Str}    '    "
    ${payload_Str}    Replace String    ${payload_Str}    {    {{
    ${payload_Str}    Replace String    ${payload_Str}    }    }}
    ${payload_Str}    Replace String    ${payload_Str}    True    true
    ${payload_Str}    Replace String    ${payload_Str}    False    false
    Return From Keyword    ${payload_Str}
