*** Settings ***
Library   RequestsLibrary
Library   JSONLibrary
Library   Collections

*** Variables ***
${ENDPOINT_LIST_CATEGORIES}   /categories?pagesize=100
@{LIST_COLOR}  Blue  Green  Yellow  Black  White  Red  Pink  Gray

*** Keywords ***
Get Value From Json KiotViet
    [Arguments]  ${json}  ${json_path}
    ${result}  Get Value From Json  ${json}  ${json_path}
    ${length}  Get Length    ${result}
    ${result}  Get From List    ${result}    0
    Run Keyword If     ${length} == 0   Return From Keyword    ${0}    ELSE    Return From Keyword    ${result}

Get All ID Categories
    ${getRespone}  Get Request KiotViet Return Json   ${PublicAPISession}    ${ENDPOINT_LIST_CATEGORIES}  200
    ${listAllIDCategories}  Get Value From Json   ${getRespone}    $.data[?(@.categoryId)].categoryId
    Return From Keyword    ${listAllIDCategories}

Random Number Automatically
    [Arguments]  ${numbers}
    ${random_numBer}      Generate Random String     ${numbers}     [NUMBERS]
    Return From Keyword     ${random_numBer}

Random Email Automatically
    ${random_String}      Generate Random String     10     [LETTERS]
    ${emailRandom}     Catenate   SEPARATOR=     ${random_String}    @gmail.com
    Return From Keyword    ${emailRandom}

Random Full Name Automatically
    ${random_String}      Generate Random String     10     [LETTERS]
    ${nameRandom}     Catenate      Auto     ${random_String}
    Return From Keyword      ${nameRandom}

Random One Value In List
    [Arguments]  ${list}
    ${value}   Evaluate    random.choice(${list})   random
    Return From Keyword    ${value}

Random Color
    ${color}  Random One Value In List  ${LIST_COLOR}
    Return From Keyword    ${color}

Verify Info Output And Input
    [Arguments]  ${listOutput}  ${listInput}
    :FOR  ${output}  ${input}  IN ZIP  ${listOutput}  ${listInput}
    \  Should Be Equal    ${output}    ${input}

Get Request KiotViet Return Json
    [Arguments]  ${session}  ${endpoint}  ${expected_status_code}
    Log     ${session}
    Log     ${endpoint}
    Log     ${expected_status_code}
    ${getRespone}   Get Request    ${session}    ${endpoint}    headers=${headers}
    Log  ${getRespone.json()}
    Log  ${getRespone.status_code}
    ${expected_status_code}   Convert To Integer    ${expected_status_code}
    Should Be Equal    ${getRespone.status_code}    ${expected_status_code}
    Return From Keyword    ${getRespone.json()}

Delete Request KiotViet
    [Arguments]  ${session}  ${endpoint}  ${expected_status_code}
    ${getRespone}   Delete Request    ${session}    ${endpoint}    headers=${headers_not_contenType}
    Log  ${getRespone.json()}
    Log  ${getRespone.status_code}
    ${expected_status_code}   Convert To Integer    ${expected_status_code}
    Should Be Equal    ${getRespone.status_code}    ${expected_status_code}
    Return From Keyword    ${getRespone.json()}

Post Request KiotViet Return Json
    [Arguments]  ${session}  ${endpoint}  ${expected_status_code}
    ${getRespone}   Post Request    ${session}    ${endpoint}    headers=${headers}
    Log  ${getRespone.json()}
    Log  ${getRespone.status_code}
    ${expected_status_code}   Convert To Integer    ${expected_status_code}
    Should Be Equal    ${getRespone.status_code}    ${expected_status_code}
    Return From Keyword    ${getRespone.json()}

Post Request KiotViet With Data And Return Json
    [Arguments]  ${session}  ${endpoint}  ${data}  ${expected_status_code}
    ${getRespone}   Post Request    ${session}    ${endpoint}    headers=${headers}   data=${data}
    Log  ${getRespone.json()}
    Log  ${getRespone.status_code}
    ${expected_status_code}   Convert To Integer    ${expected_status_code}
    Should Be Equal    ${getRespone.status_code}    ${expected_status_code}
    Return From Keyword    ${getRespone.json()}

Delete Request KiotViet And Return Json
    [Arguments]  ${session}  ${endpoint}  ${expected_status_code}
    ${getRespone}   Delete Request    ${session}    ${endpoint}    headers=${headers_not_contenType}
    Log  ${getRespone.json()}
    Log  ${getRespone.status_code}
    ${expected_status_code}   Convert To Integer    ${expected_status_code}
    Should Be Equal    ${getRespone.status_code}    ${expected_status_code}
    Return From Keyword    ${getRespone.json()}

Put Request KiotViet Return Json
    [Arguments]  ${session}  ${endpoint}  ${data}  ${expected_status_code}
    ${getRespone}   Put Request    ${session}    ${endpoint}    headers=${headers}   data=${data}
    Log  ${getRespone.json()}
    Log  ${getRespone.status_code}
    ${expected_status_code}   Convert To Integer    ${expected_status_code}
    Should Be Equal    ${getRespone.status_code}    ${expected_status_code}
    Return From Keyword    ${getRespone.json()}
