*** Settings ***
Library           SeleniumLibrary
Library           StringFormat
Resource          Chi_phi_nhaphang_page.robot
Resource          khuyenmai_list_page.robot

*** Variables ***
${cell_recent_branch}    //span[@class='k-input ng-scope'][contains(text(),'{0}')]
${item_indropdown_branch_list}    //ul[@id='cbSelectBranch_listbox']//li[@class='k-item ng-scope'][contains(text(),'{0}')]
${cell_after_switch_br}    //span[@class='k-input ng-scope'][contains(text(),'{0}')]

*** Keywords ***
Select hinh thuc CPNH
    [Arguments]   ${input_hinhthuc}
    ${cell_item_dropdown}   Format String    ${cell_item_dropdown_cpnh}    ${input_hinhthuc}
    Wait Until Element Is Visible    ${dropdown_hinhthuc_cpnh}
    Click Element    ${dropdown_hinhthuc_cpnh}
    Wait Until Element Is Visible    ${cell_item_dropdown}
    Click Element    ${cell_item_dropdown}

Select branch in CPNH
    [Arguments]   ${input_chinhanh}
    ${cell_item_dropdown}   Format String    ${cell_item_dropdown_cpnh}    ${input_chinhanh}
    Wait Until Element Is Visible    ${checkbox_chinhanh_cpnh}
    Click Element    ${checkbox_chinhanh_cpnh}
    Wait Until Element Is Visible    ${textbox_chonchinhanh}
    Focus    ${textbox_chonchinhanh}
    Input Text    ${textbox_chonchinhanh}   ${input_chinhanh}
    Wait Until Element Is Visible    ${cell_item_dropdown}
    Click Element    ${cell_item_dropdown}

Go to update expense other form
      [Arguments]     ${input_ma_cpnh}
      Wait Until Element Is Visible    ${textbox_search_expense}
      Input data    ${textbox_search_expense}    ${input_ma_cpnh}
      Wait Until Element Is Visible    ${checkbox_trangthai_expense}
      Click Element JS    ${checkbox_trangthai_expense}
      Sleep   1s
      Wait Until Element Is Visible    ${button_capnhat_expense}
      Click Element JS    ${button_capnhat_expense}
