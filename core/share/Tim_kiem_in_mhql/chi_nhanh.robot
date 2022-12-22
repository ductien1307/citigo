*** Settings ***
Library           SeleniumLibrary
Library           StringFormat

*** Variables ***
${box_chi_nhanh}    //h3[text()='Chi nhánh ']/..//div[@class='k-multiselect-wrap k-floatwrap']
${item_in_chinhanh}    //ul[@id='sortBranch_listbox']//li[text()='{0}']
${button_delete_any_chinnhanh}    //h3[text()='Chi nhánh ']/..//div[@class='k-multiselect-wrap k-floatwrap']//span[contains(text(),'delete')]

*** Keywords ***
Select Branch
    [Arguments]    ${input_chinhanh}
    Click Element    ${box_chi_nhanh}
    ${select_chinhanh}    Format String    ${item_in_chinhanh}    ${input_chinhanh}
    Click Element    ${select_chinhanh}

Delete recent branch and select another
    [Arguments]    ${input_chinhanh}
    Click Element    ${button_delete_any_chinnhanh}
    Click Element    ${box_chi_nhanh}
    ${chinhanh_selected}    Format String    ${item_in_chinhanh}    ${input_chinhanh}
    Click Element    ${chinhanh_selected}
