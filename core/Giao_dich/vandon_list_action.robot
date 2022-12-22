*** Settings ***
Library           SeleniumLibrary
Library           StringFormat
Resource          vandon_list_page.robot
Resource          ../share/javascript.robot

*** Keywords ***
Search shipping by customer infor
    [Arguments]     ${input_text}
    Wait Until Element Is Visible    ${btn_dropdown}    30s
    Click Element    ${btn_dropdown}
    Wait Until Element Is Visible    ${textbox_search_theo_khach_hang}
    Clear Element Text    ${textbox_search_theo_khach_hang}
    Input Text    ${textbox_search_theo_khach_hang}    ${input_text}
    Click Element    ${button_search}
    Sleep    5s

Validate shipping by customer infor
    [Arguments]    ${shipping_code}    ${cus_name}
    ${str_ma_phieu}     Format String    ${thongtin_hoadon}    ${shipping_code}
    ${str_khach_hang}     Format String    ${thongtin_hoadon}    ${cus_name}
    Wait Until Element Is Visible    ${str_ma_phieu}     5s
    Wait Until Element Is Visible    ${str_khach_hang}    5s
    Wait Until Element Is Visible    ${button_thanh_toan_van_don}    5s
