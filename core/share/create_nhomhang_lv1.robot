*** Settings ***
Library           SeleniumLibrary
Library           StringFormat
Resource          ./constants.robot

*** Variables ***
${button_add_nhomhang}    //a[@ng-if="includeAdd"]//i[@class='far fa-plus']
${input_tennhom}    //div[contains(@class,'k-window-categoryProduct')]//input
${button_luu_nhomhang}    //div[contains(@class,'k-window-categoryProduct')]//a[@ng-enter="saveCategory()"]//i

*** Keywords ***
Create nhomhang level1
    [Arguments]    ${tennhom}
    Click Element    ${button_add_nhomhang}
    Input Text    ${input_tennhom}    ${tennhom}
    Click Element    ${button_luu_nhomhang}
    Set Selenium Speed    0.7s
