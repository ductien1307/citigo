*** Settings ***
Library           SeleniumLibrary
Resource          giaohang_list_page.robot
Resource          ../share/constants.robot
Resource          khachhang_list_page.robot

*** Keywords ***
Go to Add new deliverypartner
    Wait Until Page Contains Element    ${button_add_deliverypartner}    2 mins
    Click Element     ${button_add_deliverypartner}
    Wait Until Page Contains Element    ${textbox_deliverypartner_name}    2 mins

Search delivery partner
    [Arguments]       ${deliverypartner_code}
    Wait Until Page Contains Element    ${textbox_search_deliverypartner}    2 mins
    Input data    ${textbox_search_deliverypartner}    ${deliverypartner_code}
    Press Key    ${textbox_search_deliverypartner}    ${ENTER_KEY}
    Wait Until Page Contains Element    ${button_update_delivery}     1 min

Select Delivery Partner Type
    [Arguments]       ${delivery_type}
    ${xpath_radiobutton_bydelivery}        Format String       ${radiobutton_deliverypartner_type}        ${delivery_type}
    Click Element JS    ${xpath_radiobutton_bydelivery}

Select location
        [Arguments]       ${deliverypartner_location}
        Input data       ${textbox_deliverypartner_location}      ${deliverypartner_location}
        ${xpath_dropdown_location}       Format String    ${dropdown_deliverypartner_location}    ${deliverypartner_location}
        Wait Until Element Is Enabled    ${xpath_dropdown_location}
        Click Element JS    ${xpath_dropdown_location}
        Press Key    ${textbox_deliverypartner_location}    ${ENTER_KEY}

Select ward
        [Arguments]       ${deliverypartner_ward}
        Input text       ${textbox_deliverypartner_ward}      ${deliverypartner_ward}
        ${xpath_dropdown_ward}       Format String    ${dropdown_deliverypartner_location}    ${deliverypartner_ward}
        Wait Until Element Is Enabled    ${xpath_dropdown_ward}
        Click Element JS    ${xpath_dropdown_ward}
        Press Key    ${textbox_deliverypartner_ward}    ${ENTER_KEY}

Go to udpate delivery partner
        [Arguments]     ${input_dtgh}
        Search delivery partner    ${input_dtgh}
        Wait Until Page Contains Element    ${button_update_delivery}    2 mins
        Click Element JS    ${button_update_delivery}
