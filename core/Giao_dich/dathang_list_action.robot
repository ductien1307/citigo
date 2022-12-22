*** Settings ***
Library           SeleniumLibrary
Library           StringFormat
Library           String
Resource          ../share/computation.robot
Resource          ../share/javascript.robot
Resource          ../share/discount.robot
Resource          dathang_list_page.robot

*** Keywords ***
Search order code
    [Arguments]     ${ma_phieu}
    Wait Until Page Contains Element    ${textbox_ma_phieu_dat}     1 min
    Input data    ${textbox_ma_phieu_dat}    ${ma_phieu}

Search and choose order by order code
    [Arguments]     ${ma_phieu}
    Wait Until Page Contains Element    ${textbox_ma_phieu_dat}     1 min
    ${checkbox_chon_don_dathang}    Format String    ${checkbox_chon_don_dathang}    ${ma_phieu}
    Input data    ${textbox_ma_phieu_dat}    ${ma_phieu}
    Wait Until Page Contains Element    ${checkbox_chon_don_dathang}      30s
    Wait Until Keyword Succeeds    3x    5s     Click Element     ${checkbox_chon_don_dathang}
    Clear Element Text    ${textbox_ma_phieu_dat}

Combine 2 order by order code
    Wait Until Element Is Visible    ${button_xacnhan_chonphieugop}    2mins
    Click Element    ${button_xacnhan_chonphieugop}
    ${count}    Set Variable    0
    ${count}    Get Matching Xpath Count    ${button_xacnhan_huyCTKM}
    Run Keyword If    ${count} > 0    Click Element JS    ${button_xacnhan_huyCTKM}    ELSE    Log    ignore
    Log    ${count}
    Wait Until Element Is Visible    ${button_xacnhan_hanghoa}
    Click Element     ${button_xacnhan_hanghoa}
    Wait Until Element Is Visible    ${button_xacnhan_gop_phieuthanhtoan}
    Click Element     ${button_xacnhan_gop_phieuthanhtoan}

Change status of order to confirmed
    Wait Until Element Is Visible    ${combobox_trangthai}    2mins
    Wait Until Keyword Succeeds    3 times    3    Click Element JS     ${combobox_trangthai}
    Wait Until Element Is Visible    ${status_dh_daxacnhan}
    Click Element    ${status_dh_daxacnhan}
    Wait Until Element Is Visible    ${button_dh_luu}
    Click Element     ${button_dh_luu}

Select multiple branches
    [Arguments]    ${input_chinhanh}
    Wait Until Element Is Visible    ${droplist_chinhanh}
    Click Element     ${droplist_chinhanh}
    ${chinhanh}    Format String    ${item_chinhanh}    ${input_chinhanh}
    Wait Until Element Is Visible    ${chinhanh}
    Click Element     ${chinhanh}

Choose order by order code on popup
    [Arguments]    ${ma_dh1}    ${ma_dh2}    ${ma_kh}
    ${order1}    Format String    ${checkbox_chonphieugop_popup}    ${ma_dh1}
    ${order2}    Format String    ${checkbox_chonphieugop_popup}    ${ma_dh2}
    Wait Until Element Is Visible    ${order1}    30s
    Click Element    ${order1}
    Wait Until Element Is Visible    ${order2}    30s
    Click Element    ${order2}
    ${button_gopdon}    Format String    ${button_gopdon_popup}    ${ma_kh}
    Wait Until Element Is Visible    ${button_gopdon}
    Click Element    ${button_gopdon}

Search order by customer info
    [Arguments]     ${input_text}
    Wait Until Element Is Visible    ${button_expanse_search}
    Click Element    ${button_expanse_search}
    Wait Until Element Is Visible    ${textbox_search_theo_ma_sdt_khachhang}    30s
    Clear Element Text    ${textbox_search_theo_ma_sdt_khachhang}
    Input Text    ${textbox_search_theo_ma_sdt_khachhang}    ${input_text}
    Click Element    ${button_search}
    Sleep    5s

Validate order by customer infor
    [Arguments]    ${order_code}    ${cus_code}    ${cus_name}
    ${str_ma_phieu}     Format String    ${ma_phieu}    ${order_code}
    ${str_khach_hang}     Format String    ${khach_hang}    ${cus_code}    ${cus_name}
    Wait Until Element Is Visible    ${str_ma_phieu}
    Wait Until Element Is Visible    ${str_khach_hang}
    Wait Until Element Is Visible    ${button_dh_ket_thuc}
