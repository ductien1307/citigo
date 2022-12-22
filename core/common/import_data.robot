*** Settings ***
Library           SeleniumLibrary

*** Keywords ***
Import Data From Json
    [Arguments]    ${path}
    ${temp}    Get File    ${path}
    ${data}   evaluate    json.loads("""${temp}""")    json
    log    ${data}
    Set Global Variable    \${JSON_DOCUMENTATION}    ${data}
    Set Global Variable    \${DATA_JSON}    ${data}
