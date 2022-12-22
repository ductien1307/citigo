*** Settings ***
Library           SeleniumLibrary
Library           StringFormat

*** Variables ***
${selection_fromdate}    //div[@id='fromDate']//tr//td[a[text()='{0}']]
${selection_time_toanthoigian}    //aside[contains(@class, 'sortTimeHeight sortTimeList')]//li//a[text()='{0}']
${selection_todate}    //div[@id='toDate']//tr//td[a[text()='{0}']]
${button_change_toanthoigian}    //aside[@class='sortTime']//label[@id='reportsortDateTimeLbl']
${button_luachonkhac}    //label[@id='reportsortOtherLbl']
${button_timkiem_luachonkhac}    //div[contains(@class, 'boxBtn')]//a[text()='Tìm kiếm']

*** Keywords ***
Select Thoi gian
    [Arguments]    ${input_time}
    Click Element    ${button_change_toanthoigian}
    ${time_selection}    Format String    ${selection_time_toanthoigian}    ${input_time}
    Click Element    ${time_selection}

Select start-end date
    [Arguments]    ${input_startdate}    ${input_enddate}
    Click Element    ${button_luachonkhac}
    ${select_startdate}    Format String    ${selection_fromdate}    ${input_startdate}
    Click Element    ${select_startdate}
    ${select_enddate}    Format String    ${selection_todate}    ${input_enddate}
    Click Element    ${select_enddate}
    sleep    2s
    Click Element    ${button_timkiem_luachonkhac}
