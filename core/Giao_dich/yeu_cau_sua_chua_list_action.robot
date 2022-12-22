*** Settings ***
Library           SeleniumLibrary
Library           StringFormat
Library           String
Resource          ../share/computation.robot
Resource          ../share/javascript.robot
Resource          yeu_cau_sua_chua_list_page.robot

*** Keywords ***
Access button save product warranty
    Wait Until Page Contains Element    ${cell_sc_first_product}      30s
    Click Element    ${cell_sc_first_product}
    Element Should Be Visible    ${button_hhsc_luu}     20s

Access button save product warranty succeed
    Reload Page
    Click Element    ${tab_hanghoa}
    Wait Until Keyword Succeeds    3 times    1s    Access button save product warranty
    Click Element    ${button_hhsc_luu}
    Wait Until Page Contains Element    ${toast_message}    1 min
    Element Should Contain    ${toast_message}    Cập nhật thành công

Search warranty by customer infor
    [Arguments]     ${input_text}
    Wait Until Element Is Visible    ${btn_search_dropdown}    30s
    Click Element    ${btn_search_dropdown}
    Wait Until Element Is Visible    ${textbox_search_khach_hang}
    Clear Element Text    ${textbox_search_khach_hang}
    Input Text    ${textbox_search_khach_hang}    ${input_text}
    Click Element    ${button_search}
    Sleep    5s

Validate warranty by customer infor
    [Arguments]    ${warranty_code}    ${cus_code}    ${cus_name}
    ${str_ma_phieu}     Format String    ${ma_phieu}    ${warranty_code}
    ${str_khach_hang}     Format String    ${khach_hang}    ${cus_code}    ${cus_name}
    Wait Until Element Is Visible    ${str_ma_phieu}     5s
    Wait Until Element Is Visible    ${str_khach_hang}    5s
    Wait Until Element Is Visible    ${button_sc_xu_ly_yeu_cau}    5s
