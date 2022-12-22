*** Settings ***
Library           SeleniumLibrary
Resource          tao_phieu_sx_add_page.robot
Resource          ../share/javascript.robot
Resource          ../share/constants.robot

*** Keywords ***
Input data to Thong tin Sx
    [Arguments]     ${input_ma_phieu}    ${product_code}
    Wait Until Element Is Visible    ${texbox_search_sx_mathang}    20s
    Input Text    ${textbox_ma_phieu_sx}     ${input_ma_phieu}
    Input Text    ${texbox_search_sx_mathang}    ${product_code}
    Wait Until Page Contains Element    ${item_hang_sx_in_dropdownlist}     20s
    Press Key    ${texbox_search_sx_mathang}    ${ENTER_KEY}
    sleep    1s

Input data in popup Tao phieu san xuat
    [Arguments]     ${input_ma_phieu}    ${input_product}      ${input_num}     ${input_ghichu}    ${is_auto}
    Wait Until Element Is Visible    ${texbox_search_sx_mathang}    20s
    Input Text    ${textbox_ma_phieu_sx}     ${input_ma_phieu}
    Input Text    ${texbox_search_sx_mathang}    ${input_product}
    Wait Until Page Contains Element    ${item_hang_sx_in_dropdownlist}     20s
    Press Key    ${texbox_search_sx_mathang}    ${ENTER_KEY}
    Sleep    1s
    Run Keyword If    '${input_num}'!='1'    Input Text    ${textbox_soluong_sx}    ${input_num}
    Run Keyword If    '${input_ghichu}'!='none'    Input Text    ${textbox_ghi_chu_sx}    ${input_ghichu}
    Run Keyword If    '${is_auto}'=='true'      Click Element    ${checkbox_tudong_tru_tp}
