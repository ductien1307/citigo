*** Settings ***
Library           SeleniumLibrary
Library           StringFormat
Resource          tra_hang_list_page.robot
Resource          ../share/javascript.robot

*** Keywords ***
Search return code
    [Arguments]     ${ma_phieu}
    Wait Until Page Contains Element    ${textbox_theo_ma_phieu_tra}       1 min
    Input data    ${textbox_theo_ma_phieu_tra}    ${ma_phieu}

Search return by customer info
    [Arguments]     ${input_text}
    Wait Until Element Is Visible    ${btn_dropdown_search}    30s
    Click Element    ${btn_dropdown_search}
    ${count}    Set Variable    0
    ${count}    Get Matching Xpath Count    ${button_tim_kiem_mo_rong}
    Run Keyword If    ${count} > 0    Click Element    ${button_tim_kiem_mo_rong}    ELSE    Log    ignore
    Wait Until Element Is Visible    ${textbox_timkiem_theo_khach_hang}
    Clear Element Text    ${textbox_timkiem_theo_khach_hang}
    Input Text    ${textbox_timkiem_theo_khach_hang}    ${input_text}
    Click Element    ${button_search}
    Sleep    5s

Validate return by customer infor
    [Arguments]    ${return_code}    ${cus_code}    ${cus_name}
    ${str_ma_phieu}     Format String    ${ma_phieu}    ${return_code}
    ${str_khach_hang}     Format String    ${khach_hang}    ${cus_code}    ${cus_name}
    Wait Until Element Is Visible    ${str_ma_phieu}     5s
    Wait Until Element Is Visible    ${str_khach_hang}    5s
    Wait Until Element Is Visible    ${button_th_luu}    5s

Input list lot name and list num of product to BH form
    [Arguments]    ${input_ma_sp}    ${list_lo}    ${list_nums}
    ${list_result_lo}    Convert string to list    ${list_lo}
    ${list_result_nums}    Convert string to list    ${list_nums}
    : FOR    ${item_lo}    ${item_num}    IN ZIP    ${list_result_lo}    ${list_result_nums}
    \    Input Text    ${textbox_nh_nhap_lo}    ${item_lo}
    \    ${item_dropdownlist}    Format String    ${item_nh_lo_in_dropdown}    ${item_lo}
    \    Wait Until Element Is Visible    ${item_dropdownlist}    30 s
    \    Press Key    ${textbox_nh_nhap_lo}    ${ENTER_KEY}
    \    Wait Until Page Contains Element    ${textbox_nh_soluong_lo}    20s
    \    Input data    ${textbox_nh_soluong_lo}    ${item_num}
