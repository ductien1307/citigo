*** Setting ***
Library           SeleniumLibrary
Library           StringFormat
Resource          constants.robot
Resource          javascript.robot

*** Variables ***
${button_prev_calendar}    //div[contains(@class, 'k-widget k-calendar')]//div[contains(@class, 'k-header')]//a[contains(@class, 'k-link k-nav-prev')]
${button_date_calendar}    //label[contains(@class,'calendar-static')]//span[contains(@aria-controls, 'PurchaseDateCart_dateview')]
${button_time_calendar}    //label[contains(@class,'calendar-static')]//span[contains(@aria-controls, 'PurchaseDateCart_timeview')]
${cell_date}      //div[contains(@class, 'k-widget k-calendar')]//table//tr/td//a[@data-value='{2}/{0}/{1}']
${cell_time}      //ul[@id='PurchaseDateCart_timeview']/li[contains(@unselectable, 'on') and text()='{0}:{1}']

*** Keywords ***
Change date
    [Arguments]    ${month}    ${date}    ${year}
    Click Element JS    ${button_date_calendar}
    ${changed_date}=    Format String    ${cell_date}    ${month}    ${date}    ${year}
    Click Element JS    ${changed_date}

Change time
    [Arguments]    ${hour}    ${mins}
    Click Element JS    ${button_time_calendar}
    ${changed_time}=    Format String    ${cell_time}    ${hour}    ${mins}
    Click Element JS    ${changed_time}

Convert minute to hour
    [Arguments]     ${input_phut}
    ${get_gio}    Convert Time    ${input_phut}    timer
    ${get_gio}    Remove String    ${get_gio}   00:
    ${get_gio}    Remove String    ${get_gio}   .000
    Return From Keyword    ${get_gio}
