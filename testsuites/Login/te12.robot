*** Settings ***
Library          pabot.PabotLib
Resource          ../../core/API/api_access.robot

*** Test Cases ***
Input data login
    [Arguments]        ${url}       ${user}    ${password}
    ${valuesetname}=    Acquire Value Set  admin-server
    ${url}        Get Value From Set    url
    ${user}        Get Value From Set    username
    ${password}        Get Value From Set    password
    Access page by auth credentials login    ${url}       ${user}    ${password}
