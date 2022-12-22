*** Settings ***
Library           SeleniumLibrary
Library           StringFormat

*** Variables ***
${checkbox_trangthai}    //h3[text()='Trạng thái']/..//div[contains(@class, 'prettycheckbox')]//label[contains(text(), '{0}')]/..//a

*** Keywords ***
Select Trang thai
    [Arguments]    ${input_trangthai}
    ${trangthai}    Format String    ${checkbox_trangthai}    ${input_trangthai}
    Click Element    ${trangthai}
