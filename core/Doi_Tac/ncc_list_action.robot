*** Settings ***
Library           SeleniumLibrary
Resource          ncc_list_page.robot
Resource          giaohang_list_page.robot
Resource          ../share/constants.robot

*** Keywords ***
Search ncc for gettting no hien tai
    [Arguments]    ${ncc}
    Wait Until Element Is Visible    ${textbox_search_matensdt}
    Input Text    ${textbox_search_matensdt}    ${ncc}
    sleep    1s
    Press Key    ${textbox_search_matensdt}    ${ENTER_KEY}
    Wait Until Element Is Visible    ${cell_no_cantra_hientai_onrow}
    ${get_no_ncc_hientai}    Get Text    ${cell_no_cantra_hientai_onrow}
    ${get_no_ncc_hientai}    Convert Any To Number    ${get_no_ncc_hientai}
    Return From Keyword    ${get_no_ncc_hientai}

Search ncc to get info in No can tra ncc tab
    [Arguments]    ${row}    ${ncc}
    Wait Until Element Is Visible    ${textbox_search_matensdt}
    Input Text    ${textbox_search_matensdt}    ${ncc}
    Press Key    ${textbox_search_matensdt}    ${ENTER_KEY}
    Sleep    2s
    Wait Until Element Is Visible    ${tab_nocantra_ncc}
    Click Element JS    ${tab_nocantra_ncc}
    ${cell_nocantra_ncc}    Format String    ${cell_nocantra_ncc}    ${row}
    ${cell_giatri_addedrow}    Format String    ${cell_giatri}    ${row}
    ${get_nocantra_ncc}    Get Text    ${cell_nocantra_ncc}
    ${get_giatri}    Get Text    ${cell_giatri_addedrow}
    ${get_nocantra_ncc}    Convert Any To Number    ${get_nocantra_ncc}
    ${get_giatri}    Convert Any To Number    ${get_giatri}
    Return From Keyword    ${get_nocantra_ncc}    ${get_giatri}

Go to Add new Supplier
    Wait Until Page Contains Element    ${button_add_new_supplier}    2 mins
    Click Element     ${button_add_new_supplier}
    Wait Until Page Contains Element    ${textbox_supplier_name}    2 mins

Select location
        [Arguments]       ${sup_location}
        Input text       ${textbox_supplier_location}      ${sup_location}
        ${xpath_dropdown_location}       Format String    ${dropdown_supplier_location}    ${sup_location}
        Wait Until Element Is Enabled    ${xpath_dropdown_location}
        Click Element JS    ${xpath_dropdown_location}
        Press Key    ${textbox_supplier_location}    ${ENTER_KEY}

Select ward
        [Arguments]       ${sup_ward}
        Input text       ${textbox_supplier_ward}      ${sup_ward}
        ${xpath_dropdown_ward}       Format String    ${dropdown_supplier_location}    ${sup_ward}
        Wait Until Element Is Enabled    ${xpath_dropdown_ward}
        Click Element JS    ${xpath_dropdown_ward}
        Press Key    ${textbox_supplier_ward}    ${ENTER_KEY}

Go to update supplier
      [Arguments]     ${input_ma_ncc}
      Search supplier     ${input_ma_ncc}
      Wait Until Page Contains Element    ${button_update_supplier}    2 mins
      Click Element JS    ${button_update_supplier}

Search supplier
      [Arguments]     ${input_ma_ncc}
      Wait Until Page Contains Element    ${textbox_search_deliverypartner}    2 mins
      Input data    ${textbox_search_deliverypartner}    ${input_ma_ncc}
      Press Key    ${textbox_search_deliverypartner}    ${ENTER_KEY}
      Wait Until Page Contains Element    ${button_update_supplier}       40s
