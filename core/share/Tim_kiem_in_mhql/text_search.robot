*** Settings ***
Library           SeleniumLibrary
Library           StringFormat

*** Variables ***
${text_search}    //article[contains(@class, 'boxLeft')]//input[contains(@placeholder, '{0}')]
${button_mo_rong}    //article[contains(@class, 'boxLeft')]//a[contains(text(), 'Mở rộng')]
${button_thugon}    //article[contains(@class, 'boxLeft')]//a[contains(text(), 'Thu gọn ')]

*** Keywords ***
Select and input data to textsearch
    [Arguments]    ${input_search_in}    ${input_textsearch}
    ${search_in_ma_sx}    Format String    ${text_search}    ${input_search_in}
    Input Text    ${search_in_ma_sx}    ${input_textsearch}
