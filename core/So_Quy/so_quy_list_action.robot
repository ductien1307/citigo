*** Settings ***
Library           SeleniumLibrary
Resource          so_quy_list_page.robot
Resource          so_quy_navigation.robot
Resource          ../share/constants.robot
Resource          ../share/computation.robot
Resource          ../share/javascript.robot

*** Keywords ***
Go to So quy and get info
    [Arguments]    ${input_ma_HD}
    Click Element    ${menu_soquy}
    Wait Until Element Is Enabled    ${textbox_search_ma_phieu}
    Input Text    ${textbox_search_ma_phieu}    ${input_ma_HD}
    Press Key    ${textbox_search_ma_phieu}    ${ENTER_KEY}
    Wait Until Element Is Enabled    ${cell_loai_thuchi_soquy}
    ${get_loai_thuchi}    Get Text    ${cell_loai_thuchi_soquy}
    ${get_giatri}    Get Text    ${cell_giatri_soquy}
    ${get_giatri}    Convert Any To Number    ${get_giatri}
    Return From Keyword    ${get_loai_thuchi}    ${get_giatri}

Go to So quy and validate ma HD not visible
    [Arguments]    ${code}
    Click Element    ${menu_soquy}
    Wait Until Element Is Enabled    ${textbox_search_ma_phieu}
    Wait Until Page Does Not Contain    ${code}

Go to So quy and update transaction form
    [Arguments]    ${input_ma_HD}
    Click Element    ${menu_soquy}
    Wait Until Element Is Enabled    ${textbox_search_ma_phieu}
    Input Text    ${textbox_search_ma_phieu}    ${input_ma_HD}
    Press Key    ${textbox_search_ma_phieu}    ${ENTER_KEY}
    Wait Until Element Is Enabled    ${button_mophieu}
    Click Element    ${button_mophieu}

Select Customer option on form receiver/payer and search transaction by customer info
    [Arguments]    ${locator}    ${input_text}
    ${count}    Set Variable    0
    ${count}    Get Matching Xpath Count    ${combobox_da_chon_KH}
    Run Keyword If    ${count} > 0    Run Keywords    Clear Element Text    ${locator}    AND    Input Type Flex    ${locator}    ${input_text}    AND    Press Key    ${locator}    ${ENTER_KEY}    ELSE    Run Keywords    Clear Element Text    ${locator}    AND    Wait Until Element Is Visible    ${combobox_doi_tuong}    5s    AND    Click Element    ${combobox_doi_tuong}
    ...    AND    Wait Until Element Is Visible    ${option_doi_tuong_khach_hang}    5s    AND    Click Element    ${option_doi_tuong_khach_hang}
    ...    AND    Input Type Flex    ${locator}    ${input_text}    AND    Press Key    ${locator}    ${ENTER_KEY}
    Sleep    2s

Validate transaction by customer info
    [Arguments]    ${input_code}    ${cus_code}    ${cus_name}    ${cus_sdt}
    ${str_ma_phieu}     Format String    ${ma_phieu_thu}    ${input_code}
    ${str_kh_hang}    Format String    ${nguoi_nop}    ${cus_code}    ${cus_name}
    ${str_sdt}    Format String    ${sdt_nguoi_nop}    ${cus_sdt}
    Wait Until Element Is Visible    ${str_ma_phieu}    5s
    Wait Until Element Is Visible    ${str_kh_hang}    5s
    Wait Until Element Is Visible    ${button_mophieu}    5s
    Wait Until Element Is Visible    ${str_sdt}    5s
