*** Settings ***
Library           SeleniumLibrary
Library           StringFormat
Resource          ./constants.robot

*** Variables ***
${dropdown_listbox}    //div[contains(@class, 'k-window')]//div[contains(@class, 'form-group') and ./label[text()='{0}']]//span[contains(@class, 'k-dropdown') and @role='listbox']    #the span khi da chon nhom hang"
${dropdown_attr}    aria-activedescendant
${dropdown_input}    //div[contains(@class, 'k-list-container')]//input[@aria-activedescendant='{0}']    # Text box de nhap nhóm hàng
${dropdown_item}    //div[contains(@class, 'k-list-container') and *//input[@aria-activedescendant='{0}']]//ul[@aria-hidden='false']/li[1]    # chon phan tu dau

*** Keywords ***
Select Item In DropDown
    [Arguments]    ${dropdown_label}    ${dropdown_value}
    ${dropdown_list}=    Format String    ${dropdown_listbox}    ${dropdown_label}
    ${dropdown_id}=    Get Element Attribute    ${dropdown_list}    ${dropdown_attr}
    ${dropdown_input_by_id}=    Format String    ${dropdown_input}    ${dropdown_id}
    ${dropdown_item_by_id}=    Format String    ${dropdown_item}    ${dropdown_id}
    Click Element    ${dropdown_list}
    sleep    2s
    Input Text    ${dropdown_input_by_id}    ${dropdown_value}
    sleep    1s
    Wait Until Element Is Visible    ${dropdown_item_by_id}
    Click Element    ${dropdown_item_by_id}
