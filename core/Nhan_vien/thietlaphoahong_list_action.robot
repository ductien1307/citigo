*** Settings ***
Library           SeleniumLibrary
Resource          ../share/constants.robot
Resource          thietlaphoahong_list_page.robot
Resource          ../Thiet_lap/thiet_lap_nav.robot
Resource          ../share/toast_message.robot

*** Keywords ***
Input data in popup Them moi bang hoa hong
    [Arguments]     ${input_banghoahong}
    Wait Until Page Contains Element    ${button_them_banghoahong}      20s
    Click Element    ${button_them_banghoahong}
    Wait Until Page Contains Element    ${textbox_ten_banghoahong}      20s
    Input data    ${textbox_ten_banghoahong}    ${input_banghoahong}
    Click Element    ${button_luu_banghoahong}
    Create commission success validation

Add category into commission
    [Arguments]     ${ten_nhom}
    ${cell_nhom}   Format String     //span[contains(text(),'{0}')]      ${ten_nhom}
    Wait Until Page Contains Element    ${cell_nhom}    20s
    Mouse Over    ${cell_nhom}
    ${cell_nhomhang}    Format String    ${cell_nhomhang_banghoahong}    ${ten_nhom}
    Wait Until Page Contains Element    ${cell_nhom}    20s
    Click Element     ${cell_nhomhang}
    Sleep    2s

Setting commission value in commission
    [Arguments]     ${input_value}      ${input_type}     ${input_apdung}
    Wait Until Page Contains Element    ${textbox_muc_hoa_hong_first_product}     20s
    Click Element    ${textbox_muc_hoa_hong_first_product}
    Wait Until Page Contains Element    ${textbox_muc_hoa_hong}   20s
    Run Keyword If    '${input_type}'=='VND'    Log    Ingore       ELSE    Click Element    ${button_doanhthu}
    Input Text    ${textbox_muc_hoa_hong}   ${input_value}
    Run Keyword If    '${input_apdung}'=='no'    Log    Ingore       ELSE    Click Element    ${checkbox_apdung}
    Click Element    ${button_dongy_muchoahong}
    Update data success validation

Select Bang hoa hong
    [Arguments]     ${input_banghoahong}
    Wait Until Page Contains Element    //div[@class='k-multiselect-wrap k-floatwrap']    20s
    Click Element    //div[@class='k-multiselect-wrap k-floatwrap']
    Wait Until Page Contains Element    ${textbox_chon_banghoahong}     20s
    Input Text    ${textbox_chon_banghoahong}    ${input_banghoahong}
    Sleep    1.5s
    Press Key      ${textbox_chon_banghoahong}      ${ENTER_KEY}
    Wait Until Page Contains Element    ${button_chinhsua_banghoahong}      10s
