*** Settings ***
Library           SeleniumLibrary
Library           StringFormat
Resource          ../../share/computation.robot

*** Variables ***
${textcell_ten_sp}    //ul//li//div[contains(@class, 'search-product-info')]//p[contains(@class, 'name-item') and (text()='{0} ')]
${textcell_ma_sp}    //ul//li//div[contains(@class, 'search-product-info')]//p[contains(text(), '{0}')]
${textcell_ton}    //ul//li//div[@class='search-product-info']//p[contains(@class, 'name-item') and (text()='{0} ')]/../span[contains(@class, 'onHandValue')]
${textcell_dat}    //ul//li//div[@class='search-product-info']//p[contains(@class, 'name-item') and (text()='{0} ')]/../span[contains(@class, 'reservedValue')]
${textcell_gia}    //ul//li//div[@class='search-product-info']//p[contains(@class, 'name-item') and (text()='{0} ')]/..//span[contains(@class, 'priceValue')]

*** Keywords ***
Get Gia Ban
    [Arguments]    ${input_ten_sp}
    ${input_textcell_gia}    Format String    ${textcell_gia}    ${input_ten_sp}
    ${get_textcell_gia}    Get Text    ${input_textcell_gia}
    ${get_textcell_gia}    Convert Any To Number    ${get_textcell_gia}
    Return From Keyword    ${get_textcell_gia}

Get Ton
    [Arguments]    ${input_ten_sp}
    ${input_textcell_ton}    Format String    ${textcell_ton}    ${input_ten_sp}
    ${get_textcell_ton}    Get Text    ${input_textcell_ton}
    ${get_textcell_ton}    Convert To Number    ${get_textcell_ton}
    Return From Keyword    ${get_textcell_ton}

Get Dat
    [Arguments]    ${input_ten_sp}
    ${input_textcell_dat}    Format String    ${textcell_dat}    ${input_ten_sp}
    ${get_textcell_dat}    Get Text    ${input_textcell_dat}
    ${get_textcell_dat}    Convert To Number    ${get_textcell_dat}
    Return From Keyword    ${get_textcell_dat}
