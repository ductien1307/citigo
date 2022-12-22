*** Settings ***
Library           StringFormat
Library           SeleniumLibrary

*** Variables ***
${folder}         H:${/}Exported Files${/}

*** Keywords ***
Read file from
    [Arguments]    ${file_name}
    ${get_filename}    Catenate    SEPARATOR=    ${folder}    ${file_name}
    Return From Keyword    ${get_filename}
