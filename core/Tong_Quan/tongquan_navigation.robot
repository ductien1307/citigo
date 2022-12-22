*** Settings ***
Library           SeleniumLibrary

*** Variables ***
${menu_tongquan}    //a[contains(@ng-href, 'DashBoard')]

*** Keywords ***
Assert success text
    Wait Until Element Contains    ${menu_tongquan}    Tổng quan
