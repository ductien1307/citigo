*** Settings ***
Library           SeleniumLibrary
Resource          thukhac_list_page.robot
Resource          ../share/constants.robot

*** Keywords ***
Select branch in add surcharge popup
    [Arguments]    ${input_chinhanh}
    Wait Until Element Is Visible    ${checkbox_surcharge_chinhanh}
    Click Element    ${checkbox_surcharge_chinhanh}
    Input text    ${textbox_surcharge_chinhanh}    ${input_chinhanh}
    ${cell_item_surcharge_chinhanh}    Format String    ${cell_item_surcharge_chinhanh}    ${input_chinhanh}
    Wait Until Element Is Enabled    ${cell_item_surcharge_chinhanh}
    Click Element    ${cell_item_surcharge_chinhanh}

Go to update surcharge form
    [Arguments]    ${input_thukhac}
    Wait Until Element Is Visible    ${textbox_search_surcharge}
    Input data    ${textbox_search_surcharge}    ${input_thukhac}
    Wait Until Element Is Visible    ${checkbox_filter_luachonhienthi_tatca}
    Click Element    ${checkbox_filter_luachonhienthi_tatca}
    Sleep    1s
    Wait Until Element Is Visible    ${button_capnhat_surcharge}
    Click Element    ${button_capnhat_surcharge}
