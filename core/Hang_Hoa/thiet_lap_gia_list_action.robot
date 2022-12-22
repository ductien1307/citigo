*** Settings ***
Library           SeleniumLibrary
Resource          thiet_lap_gia_list_page.robot
Resource          ../share/constants.robot
Library           StringFormat
Resource          ../share/toast_message.robot
Resource          ../API/api_thietlapgia.robot
Resource          ../share/discount.robot
Resource          them_bang_gia_page.robot

*** Keywords ***
Select Bang gia for Bang gia
    [Arguments]    ${banggia_ten}
    ${item_banggia}    Format String    ${item_banggia_indropdown}    ${banggia_ten}
    KV Click Element    ${button_xoa_banggiachung}
    Wait Until Keyword Succeeds    3 times    3s    Input data in textbox and wait until it is visible    ${textbox_chon_bang_gia}    ${banggia_ten}    ${item_banggia}
    ...    ${cell_chon_bang_gia}

Add new price book
    [Arguments]    ${input_ten_bang_gia}
    KV Click Element    ${button_them_banggia}
    KV Input Text    ${textbox_nhap_ten_banggia}    ${input_ten_bang_gia}
    KV Click Element    ${button_luu_banggia}
    Update data success validation

Add category into price book
    [Arguments]    ${ten_bang_gia}    ${ten_nhom}
    ${add_nhom}    Format String    ${button_them_nhomhang_vao_banggia}    ${ten_nhom}
    KV Input Text    ${textbox_tlg_timkiem_nhomhang}    ${ten_nhom}
    ${cell_tlg_tennhom}    Format String    ${cell_tlg_tennhom}    ${ten_nhom}
    Mouse Over    ${cell_tlg_tennhom}
    KV Click Element JS    ${add_nhom}
    Update data success validation
    Sleep    3s
    ${total}    Get total product in price book thr API    ${ten_bang_gia}
    Return From Keyword    ${total}

Add list category into price book and validate data
    [Arguments]   ${ten_bang_gia}    ${list_ten_nhom}
    ${tongsl_hh}    Set Variable    0
      : FOR    ${item_tennhom}    IN ZIP    ${list_ten_nhom}
    \    ${total_in_banggia}    Add category into price book    ${ten_bang_gia}    ${item_tennhom}
    \    ${tongsl_hh}    Get total product in category thr API    ${item_tennhom}    ${tongsl_hh}
    Should Be Equal As Numbers    ${total_in_banggia}    ${tongsl_hh}

Add all category into price book
    Wait Until Element Is Visible    ${textbox_tlg_timkiem_nhomhang}
    Mouse Over    ${cell_tlg_tatca_nhomhang}
    Wait Until Element Is Visible    ${button_them_tatca_nhom}
    Click Element    ${button_them_tatca_nhom}
    Update data success validation

Delete price book thr UI
    [Arguments]    ${bang_gia}
    Click Element    ${button_chinhsua_banggia}
    Wait Until Page Contains Element    ${button_xoa_bang_gia}    30s
    Click Element    ${button_xoa_bang_gia}
    Wait Until Page Contains Element    ${button_dongy_xoa_bianggia}    30s
    Click Element    ${button_dongy_xoa_bianggia}
    Delete pricebook message success validation    ${bang_gia}

Assert cost, lastest purchase price, price in price book
    [Arguments]    ${mahh}    ${giavon}   ${gianhap}    ${giaban}
    ${xp_giavon}    Format String    ${cell_bg_giavon}    ${mahh}
    ${xp_lastestprice}    Format String    ${cell_bg_dongia_nhapcuoi}    ${mahh}
    ${xp_price}    Format String    ${cell_bg_giachung}    ${mahh}
    ${giavon_ui}    Get New price from UI    ${xp_giavon}
    ${gianhap_ui}    Get New price from UI    ${xp_lastestprice}
    ${giaban_ui}    Get New price from UI    ${xp_price}
    Should Be Equal As Numbers    ${giavon}    ${giavon_ui}
    Should Be Equal As Numbers    ${gianhap}    ${gianhap_ui}
    Should Be Equal As Numbers    ${giaban}    ${giaban_ui}

Add product into price book
    [Arguments]    ${mahh}
    Wait Until Element Is Enabled    ${textbox_themhh_vao_banggia}
    ${cell_sp}    Format String    ${cell_bg_mahh}    ${mahh}
    Wait Until Keyword Succeeds    3 times    7s    Input data in textbox and click element        ${textbox_themhh_vao_banggia}    ${mahh}    ${item_hh_in_dropdown}
    ...    ${cell_sp}

Add list product into price book and validate data
    [Arguments]    ${list_pr}
    ${list_giavon}    ${list_gianhap}    ${list_giaban}    Get list cost, lastest purchase price, baseprice thr API    ${list_pr}
    : FOR    ${item_hh}   ${item_giavon}    ${item_gianhap}   ${item_giaban}    IN ZIP    ${list_pr}   ${list_giavon}    ${list_gianhap}    ${list_giaban}
    \    Add product into price book    ${item_hh}
    \    Assert cost, lastest purchase price, price in price book    ${item_hh}    ${item_giavon}    ${item_gianhap}   ${item_giaban}

Add list product into price book and input new price
    [Arguments]    ${list_pr}    ${list_price}
    : FOR    ${item_hh}    ${item_price}     IN ZIP    ${list_pr}      ${list_price}
    \    Add product into price book    ${item_hh}
    \    Input new price for product in price book    ${item_hh}    ${item_price}

Add list product into price book and discount price
    [Arguments]    ${list_pr}    ${list_gg}     ${list_banggia}
    : FOR    ${item_hh}    ${item_gg}     ${item_banggia}   IN ZIP    ${list_pr}      ${list_gg}     ${list_banggia}
    \    Add product into price book    ${item_hh}
    \    Discount price for product in price book    ${item_hh}    ${item_banggia}    ${item_gg}

Add list product into price book and increase price
    [Arguments]    ${list_pr}    ${list_gg}     ${list_banggia}
    : FOR    ${item_hh}    ${item_gg}     ${item_banggia}   IN ZIP    ${list_pr}      ${list_gg}     ${list_banggia}
    \    Add product into price book    ${item_hh}
    \    Increase price for product in price book    ${item_hh}    ${item_banggia}    ${item_gg}

Discount price for all product in price book
    [Arguments]    ${ma_hh}    ${gia_ss}    ${giamgia}    ${confirm}
    Select price in price book    ${ma_hh}    ${gia_ss}
    Click Element JS    ${button_bg_tru}
    Run Keyword If    ${giamgia}>999    Input VND discount for all product in price book    ${giamgia}    ${gia_ss}    ${confirm}
    ...    ELSE    Input % discount for all product in price book    ${giamgia}    ${gia_ss}    ${confirm}

Change price for all product in price book
    [Arguments]     ${ma_hh}    ${gia_ss}    ${value}    ${tanggiam}    ${confirm}
    Run Keyword If    '${tanggiam}'=='giảm'    Discount price for all product in price book    ${ma_hh}    ${gia_ss}    ${value}    ${confirm}
    ...    ELSE    Increase price for all product in price book    ${ma_hh}     ${gia_ss}    ${value}    ${confirm}

Input new price for product in price book
    [Arguments]    ${mahh}    ${giamoi}
    ${xp_giamoi}    Format String    ${textbox_bg_giamoi}    ${mahh}
    Input data    ${xp_giamoi}    ${giamoi}
    Update data success validation

Discount price for product in price book
    [Arguments]    ${mahh}    ${gia_ss}    ${giamgia}
    Select price in price book    ${mahh}    ${gia_ss}
    Click Element JS    ${button_bg_tru}
    Run Keyword If    ${giamgia}>999    Input VND discount for product in price book    ${giamgia}
    ...    ELSE    Input % discount for product in price book    ${giamgia}

Input % discount for product in price book
    [Arguments]    ${giamgia}
    KV Click Element JS    ${button_bg_giamgia_%}
    KV Input Text    ${textbox_bg_nhap_gg}    ${giamgia}
    KV Click Element    ${button_dongy_giamoi}
    Update data success validation

Select price in price book
    [Arguments]    ${mahh}    ${gia_ss}
    ${xp_giamoi}    Format String    ${textbox_bg_giamoi}    ${mahh}
    Click Element    ${xp_giamoi}
    Wait Until Page Contains Element    ${dropdownlist_chon_bang_gia}    15s
    Click Element    ${dropdownlist_chon_bang_gia}
    ${cell_gia}    Format String    ${cell_bg_giia_ss}    ${gia_ss}
    Wait Until Keyword Succeeds    3 times    3s    Input data in textbox and wait until it is visible    ${textbox_nhap_bang_gia}    ${gia_ss}    ${cell_gia}
    ...    ${cell_banggia_duoc_chon}

Input VND discount for product in price book
    [Arguments]    ${giamgia}
    Click Element JS    ${button_bg_giamgia_VND}
    Input Text    ${textbox_bg_nhap_gg}    ${giamgia}
    KV Click Element    ${button_dongy_giamoi}
    Update data success validation

Increase price for product in price book
    [Arguments]    ${mahh}    ${gia_ss}    ${tanggia}
    Select price in price book    ${mahh}    ${gia_ss}
    Run Keyword If    ${tanggia}>999    Input VND discount for product in price book    ${tanggia}
    ...    ELSE    Input % discount for product in price book    ${tanggia}

Input VND discount for all product in price book
    [Arguments]    ${giamgia}    ${gia_ss}    ${confirm}
    KV Click Element JS    ${button_bg_giamgia_VND}
    KV Input Text    ${textbox_bg_nhap_gg}    ${giamgia}
    KV Click Element    ${checkbox_bg_apdungallsp}
    KV Click Element    ${button_dongy_giamoi}
    Run Keyword If    '${gia_ss}'!='Giá hiện tại' and '${confirm}'=='yes'    Click yes for popup confirm update the formula setting
    ...    ELSE IF    '${gia_ss}'!='Giá hiện tại' and '${confirm}'=='no'    Click no for popup confirm update the formula setting
    ...    ELSE    Log    ignore
    Update data success validation

Input % discount for all product in price book
    [Arguments]    ${giamgia}    ${gia_ss}    ${confirm}
    KV Click Element JS    ${button_bg_giamgia_%}
    KV Input Text    ${textbox_bg_nhap_gg}    ${giamgia}
    KV Click Element    ${checkbox_bg_apdungallsp}
    KV Click Element    ${button_dongy_giamoi}
    Run Keyword If    '${gia_ss}'!='Giá hiện tại' and '${confirm}'=='yes'    Click yes for popup confirm update the formula setting
    ...    ELSE IF    '${gia_ss}'!='Giá hiện tại' and '${confirm}'=='no'    Click no for popup confirm update the formula setting
    ...    ELSE    Log    ignore
    Update data success validation

Increase price for all product in price book
    [Arguments]    ${ma_hh}    ${gia_ss}    ${giamgia}    ${confirm}
    Select price in price book    ${ma_hh}    ${gia_ss}
    Run Keyword If    ${giamgia}>999    Input VND discount for all product in price book    ${giamgia}    ${gia_ss}    ${confirm}
    ...    ELSE    Input % discount for all product in price book    ${giamgia}    ${gia_ss}    ${confirm}

Edit price book
    Click Element JS    ${button_chinhsua_banggia}
    Click Element JS    ${button_xoa_banggia}
    Wait Until Element Is Visible    ${button_dongy_xoa_bianggia}
    Click Element JS    ${button_dongy_xoa_bianggia}
    Delete data success validation

Search and emove product from price book
    [Arguments]    ${mahh}
    Add product into price book    ${mahh}
    ${xpath_xoa}    Format String    ${button_xoa_sp_khoi_banggia}    ${mahh}
    Click Element JS    ${xpath_xoa}
    Wait Until Page Contains Element    ${button_dongy_xoa_bianggia}

Click yes for popup confirm update the formula setting
    Wait Until Page Contains Element    ${button_dongy_thietlap_gia}    15s
    Click Element JS    ${button_dongy_thietlap_gia}

Click no for popup confirm update the formula setting
    Wait Until Page Contains Element    ${button_boqua_thietlapgia}    15s
    Click Element JS    ${button_boqua_thietlapgia}

Add new price book have pricebook and value in tab Thiet lap nang cao
    [Arguments]    ${input_ten_bang_gia}    ${gia_ss}    ${tanggiam}    ${value}
    Wait Until Page Contains Element    ${button_them_banggia}    15s
    Click Element    ${button_them_banggia}
    Wait Until Element Is Visible    ${textbox_nhap_ten_banggia}
    Input data    ${textbox_nhap_ten_banggia}    ${input_ten_bang_gia}
    Click Element    ${button_tab_tihet_lap_nang_cao}
    Wait Until Element Is Visible    ${dropdownlist_popup_chon_bang_gia}    30
    ${item_bang_gia}    Format String    ${item_bang_gia_indropdown_popup}    ${gia_ss}
    Click Element    ${dropdownlist_popup_chon_bang_gia}
    Input data in textbox and wait until it is visible    ${textbox_popup_bang_gia}    ${gia_ss}    ${item_bang_gia}    ${cell_popup_bang_gia}
    Run Keyword If    ${value} > 999 and '${tanggiam}'=='tăng'    Input increase NVD in tab Thiet lap nang cao    ${value}
    ...    ELSE IF    ${value} <= 999 and '${tanggiam}'=='tăng'    Input increase % in tab Thiet lap nang cao    ${value}
    ...    ELSE IF    ${value} > 999 and '${tanggiam}'=='giảm'    Input discount VND in tab Thiet lap nang cao    ${value}
    ...    ELSE IF    ${value} <= 999 and '${tanggiam}'=='giảm'    Input discount % in tab Thiet lap nang cao    ${value}
    ...    ELSE    Log    Ignore
    Click Element    ${button_luu_banggia}
    Wait Until Keyword Succeeds    3 times    3s    Update data success validation

Input discount % in tab Thiet lap nang cao
    [Arguments]    ${value}
    KV Click Element JS    ${button_popup_tru}
    KV Click Element JS    ${button_popup_giamgia_%}
    KV Input data    ${textbox_popup_nhap_gia_tri}    ${value}

Input discount VND in tab Thiet lap nang cao
    [Arguments]    ${value}
    KV Click Element JS    ${button_popup_tru}
    KV Click Element JS    ${button_popup_giamgia_vnd}
    KV Input data    ${textbox_popup_nhap_gia_tri}    ${value}

Input increase % in tab Thiet lap nang cao
    [Arguments]    ${value}
    KV Click Element JS    ${button_popup_cong}
    KV Click Element JS    ${button_popup_giamgia_%}
    KV Input data    ${textbox_popup_nhap_gia_tri}    ${value}

Input increase NVD in tab Thiet lap nang cao
    [Arguments]    ${value}
    KV Click Element JS    ${button_popup_cong}
    KV Click Element JS    ${button_popup_giamgia_vnd}
    KV Input data    ${textbox_popup_nhap_gia_tri}    ${value}

Input discount price in tab Thiet lap nang cao
    [Arguments]    ${value}
    Run Keyword If    ${value}>999    Input discount VND in tab Thiet lap nang cao    ${value}
    ...    ELSE    Input discount % in tab Thiet lap nang cao    ${value}

Input increase price in tab Thiet lap nang cao
    [Arguments]    ${value}
    Run Keyword If    ${value}>999    Input increase NVD in tab Thiet lap nang cao    ${value}
    ...    ELSE    Input increase % in tab Thiet lap nang cao

Edit infor in tab Thiet lap nang cao
    [Arguments]    ${gia_ss}    ${tanggiam}    ${value}    ${confirm}
    KV Click Element    ${button_chinhsua_banggia}
    KV Click Element    ${button_tab_tihet_lap_nang_cao}
    ${item_bang_gia}    Format String    ${item_bang_gia_indropdown_popup}    ${gia_ss}
    KV Click Element    ${dropdownlist_popup_chon_bang_gia}
    Input data in textbox and wait until it is visible    ${textbox_popup_bang_gia}    ${gia_ss}    ${item_bang_gia}    ${cell_popup_bang_gia}
    Run Keyword If    ${value} > 999 and '${tanggiam}'=='tăng'    Input increase NVD in tab Thiet lap nang cao    ${value}
    ...    ELSE IF    ${value} <= 999 and '${tanggiam}'=='tăng'    Input increase % in tab Thiet lap nang cao    ${value}
    ...    ELSE IF    ${value} > 999 and '${tanggiam}'=='giảm'    Input discount VND in tab Thiet lap nang cao    ${value}
    ...    ELSE IF    ${value} <= 999 and '${tanggiam}'=='giảm'    Input discount % in tab Thiet lap nang cao    ${value}
    ...    ELSE    Log    Ignore
    Click Element    ${button_luu_banggia}
    Run Keyword If    '${confirm}'=='yes'    KV Click Element    ${button_popup_dongy_apdung}
    ...    ELSE    KV Click Element    ${button_popup_boqua_apdung}
    Update data success validation

Search product in pricebook
    [Arguments]     ${ma_sp}
    Wait Until Element Is Visible    ${textbox_tlg_tim_ma_hang}
    Input data    ${textbox_tlg_tim_ma_hang}    ${ma_sp}
    Sleep    1s
    Element Should Contain    ${cell_tlg_ma_sp}    ${ma_sp}
