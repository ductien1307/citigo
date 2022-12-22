*** Settings ***
Library           SeleniumLibrary
Resource          fnb_page.robot
Resource          ../share/constants.robot

*** Keywords ***
Input product in form Thu ngan
    [Arguments]    ${input_ten_sp}
    [Timeout]    5 minutes
    Wait Until Page Contains Element    ${textbox_bh_search_ma_sp}    2 mins
    Wait Until Keyword Succeeds    3 times    3 s    Input data in textbox and wait until it is visible    ${textbox_bh_search_ma_sp}    ${input_ten_sp}    ${cell_sanpham}
    ...    ${cell_tn_ten_sp}

Input num in form Thu ngan
    [Arguments]     ${input_soluong}
    Wait Until Page Contains Element    ${button_tn_so_luong}   2 mins
    Click Element        ${button_tn_so_luong}
    Wait Until Element Is Visible    ${textbox_tn_so_luong}
    Input data      ${textbox_tn_so_luong}     ${input_soluong}

Input newprcie in form Thu ngan
    [Arguments]     ${input_newprice}
    Wait Until Page Contains Element    ${button_tn_gia_ban}   2 mins
    Click Element JS        ${button_tn_gia_ban}
    Wait Until Element Is Visible    ${textbox_tn_gia_ban}
    Input Text      ${textbox_tn_gia_ban}     ${input_newprice}
    Click Element    //button[contains(text(),'Xong')]

Input discount VND in form Thu ngan
    [Arguments]     ${input_discount}
    Wait Until Page Contains Element    ${button_tn_giamgia}   2 mins
    Click Element JS        ${button_tn_giamgia}
    Wait Until Element Is Visible    ${textbox_tn_giamgia}
    Input data      ${textbox_tn_giamgia}     ${input_discount}

Add new customer in form Thu Ngan
    [Arguments]   ${input_ma_kh}      ${input_ten_kh}
    Wait Until Page Contains Element    ${button_tn_them_khachhang}     1 min
    Click Element    ${button_tn_them_khachhang}
    Input Text    ${textbox_tn_ma_kh}    ${input_ma_kh}
    Input Text    ${textbox_tn_ten_kh}    ${input_ten_kh}
    Click Element    ${button_tn_them_kh_luu}
