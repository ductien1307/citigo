*** Settings ***
Library           SeleniumLibrary
Library           Collections
Resource          nhap_hang_add_page.robot
Resource          ../share/computation.robot
Resource          ../share/constants.robot
Resource          ../share/javascript.robot
Resource          ../share/discount.robot
Resource          ../API/api_danhmuc_hanghoa.robot

*** Keywords ***
Input supplier
    [Arguments]    ${input_ma_ncc}
    Wait Until Page Contains Element    ${textbox_nh_ncc}    30s
    Wait Until Keyword Succeeds    3 times    2s    Input Supplier to Supplier textbox    ${input_ma_ncc}
    Click Element JS    ${cell_nhacungcap}
    Sleep    1s

Input purchase infor
    [Arguments]    ${input_ma_ncc}    ${input_cantra_ncc}    ${input_tientra_ncc}
    Wait Until Page Contains Element    ${textbox_nh_ncc}    30s
    Wait Until Keyword Succeeds    3 times    2s    Input Supplier to Supplier textbox    ${input_ma_ncc}
    Click Element JS    ${cell_nhacungcap}
    Wait Until Page Contains Element    ${textbox_nh_ncc}    30s
    Run Keyword If    '${input_tientrancc}'!='0'    Wait Until Keyword Succeeds    3 times    0.5s    Input pay for supplier and validate    ${input_tientra_ncc}    ${input_cantra_ncc}

Input Supplier to Supplier textbox
    [Arguments]    ${input_ma_ncc}
    Input Text    ${textbox_nh_ncc}    ${input_ma_ncc}
    Wait Until Page Contains Element    ${cell_nhacungcap}    10s

Input pay for supplier and validate
    [Arguments]    ${input_tientra_ncc}    ${input_cantra_ncc}
    Wait Until Keyword Succeeds    3 times    1s    Input data    ${textbox_nh_tien_tra_ncc}    ${input_tientra_ncc}
    ${cell_tinhvaocongno}    Get Change to customer from UI    ${cell_nh_tinh_vao_cong_no}
    ${result_tinhvaocongno}    Minus    ${input_cantra_ncc}    ${input_tientra_ncc}
    Should Be Equal As Numbers    ${cell_tinhvaocongno}    ${result_tinhvaocongno}

Input % discount for product in NH form
    [Arguments]    ${input_giamgia_%}    ${input_result_newprice_by_vnd}
    Click Element    ${button_nh_giamgia_sp}
    Wait Until Page Contains Element    ${button_nh_giamgiasp_vnd%}
    Click Element JS    ${button_nh_giamgiasp_vnd%}
    Wait Until Page Contains Element    ${textbox_nh_giamgia_sp}    3s
    Wait Until Keyword Succeeds    3 times    0.5 s    Input data    ${textbox_nh_giamgia_sp}    ${input_giamgia_%}
    ${discount_vnd}    Get New price from UI    ${button_nh_giamgia_sp}
    ${result_discount_vnd}    Multiplication    ${input_result_newprice_by_vnd}    ${input_giamgia_%}
    ${result_discount_vnd}    Devision    ${result_discount_vnd}    100
    ${result_discount_vnd}    Evaluate    round(${result_discount_vnd}, 2)
    Should Be Equal As Numbers    ${discount_vnd}    ${result_discount_vnd}

Input vnd discount for product in NH form
    [Arguments]    ${input_giamgia_vnd}    ${new_price}
    Click Element    ${button_nh_giamgia_sp}
    Wait Until Page Contains Element    ${textbox_nh_giamgia_sp}    3s
    Wait Until Keyword Succeeds    3 times    0.5 s    Input data    ${textbox_nh_giamgia_sp}    ${input_giamgia_vnd}
    ${discount_vnd}    Get New price from UI    ${button_nh_giamgia_sp}
    Should Be Equal As Numbers    ${discount_vnd}    ${input_giamgia_vnd}

Input discount PNH Invoice %
    [Arguments]    ${input_giamgia_hd}    ${result_discount_by_vnd}
    Click Element    ${cell_nh_giamgia_hd}
    Click Element    ${button_nh_gg_hd_%}
    Wait Until Keyword Succeeds    3 times    0.5s    Input data    ${textbox_nh_gghd_%}    ${input_giamgia_hd}
    ${discount_vnd}    Get New price from UI    ${cell_nh_giamgia_hd}
    Should Be Equal As Numbers    ${discount_vnd}    ${result_discount_by_vnd}

Input discount PNH Invoice VND
    [Arguments]    ${input_giamgia_hd}
    Click Element    ${cell_nh_giamgia_hd}
    Click Element    ${button_nh_gg_hd__vnd}
    Wait Until Page Contains Element    ${textbox_nh_giamgia_hd}    1 min
    Wait Until Keyword Succeeds    3 times    0.5s    Input data    ${textbox_nh_giamgia_hd}    ${input_giamgia_hd}
    ${discount_vnd}    Get New price from UI    ${cell_nh_giamgia_hd}
    Should Be Equal As Numbers    ${discount_vnd}    ${input_giamgia_hd}

Input discount PNH Invoice
    [Arguments]     ${input_nh_discount}    ${result_discount_by_vnd}
    Run Keyword If    0 < ${input_nh_discount} < 100     Wait Until Keyword Succeeds    3 times    0.5 s    Input discount PNH Invoice %    ${input_nh_discount}
    ...    ${result_discount_by_vnd}    ELSE IF    ${input_nh_discount} > 100    Wait Until Keyword Succeeds    3 times    0.5 s    Input discount PNH Invoice VND    ${input_nh_discount}
    ...    ELSE    Log    Ignore discount

Input new price of product in NH form
    [Arguments]    ${input_giamoi}
    Click Element    ${textbox_nh_gia}
    Wait Until Keyword Succeeds    3 times    0.5s    Input data    ${textbox_nh_gia}    ${input_giamoi}
    #${newpỉce}    Get New price from UI    //td[contains(@class,'cell-total')]
    #Should Be Equal As Numbers    ${newpỉce}    ${input_giamoi}

Input product - num - new price - % product discount in NH form
    [Arguments]    ${input_ma_sp}    ${input_soluong}    ${input_newprice}    ${lastest_price}    ${input_giamgia_sp}    ${lastest_num}
    Wait Until Page Contains Element    ${textbox_nh_search_hh}    2 mins
    Wait Until Keyword Succeeds    3 times    5s    Input data in textbox and wait until it is visible    ${textbox_nh_search_hh}    ${input_ma_sp}    ${nh_item_indropdown_search}
    ...    ${nh_cell_first_product_code}
    Wait Until Page Contains Element    ${textbox_nh_soluong}    30s
    Run Keyword If    '${input_newprice}'=='none'    Log    Ignore newprice
    ...    ELSE    Wait Until Keyword Succeeds    3 times    0.5s    Input new price of product in NH form    ${input_newprice}
    ${result_newprice}    Set Variable If    '${input_newprice}'=='none'    ${lastest_price}    ${input_newprice}
    ${lastest_num}    Input number and validate data    ${textbox_nh_soluong}    ${input_soluong}    ${lastest_num}    ${cell_nh_lastest_number}
    Run Keyword If    ${input_giamgia_sp}!=0    Wait Until Keyword Succeeds    3 times    0.5s    Input % discount for product in NH form    ${input_giamgia_sp}
    ...    ${result_newprice}    ELSE    Log    Ignore input discount
    Return From Keyword    ${lastest_num}

Input product - num - new price - vnd product discount in NH form
    [Arguments]    ${input_ma_sp}    ${input_soluong}    ${input_newprice}    ${input_giamgia_sp}    ${lastest_num}
    Wait Until Page Contains Element    ${textbox_nh_search_hh}    30s
    Wait Until Keyword Succeeds    3 times    5s    Input data in textbox and wait until it is visible    ${textbox_nh_search_hh}    ${input_ma_sp}    ${nh_item_indropdown_search}
    ...    ${nh_cell_first_product_code}
    Wait Until Page Contains Element    ${textbox_nh_soluong}    30s
    Run Keyword If    '${input_newprice}'=='none'    Log    Ignore newprice
    ...    ELSE    Wait Until Keyword Succeeds    3 times    0.5 s    Input new price of product in NH form    ${input_newprice}
    ${lastest_num}    Input number and validate data    ${textbox_nh_soluong}    ${input_soluong}    ${lastest_num}    ${cell_nh_lastest_number}
    Run Keyword If    ${input_giamgia_sp}!=0    Wait Until Keyword Succeeds    3 times    0.5s    Input vnd discount for product in NH form    ${input_giamgia_sp}
    ...    ${input_newprice}       ELSE    Log    Ignore input discount
    Return From Keyword    ${lastest_num}

Input product - num - new price - product discount in NH form
    [Arguments]    ${input_ma_sp}    ${input_soluong}    ${input_newprice}    ${lastest_price}    ${input_giamgia_sp}    ${lastest_num}
    Wait Until Page Contains Element    ${textbox_nh_search_hh}    2 mins
    Wait Until Keyword Succeeds    3 times    5s    Input data in textbox and wait until it is visible    ${textbox_nh_search_hh}    ${input_ma_sp}    ${nh_item_indropdown_search}
    ...    ${nh_cell_first_product_code}
    Wait Until Page Contains Element    ${textbox_nh_soluong}    30s
    Run Keyword If    '${input_newprice}'=='none'    Log    Ignore newprice
    ...    ELSE    Wait Until Keyword Succeeds    3 times    1s    Input new price of product in NH form    ${input_newprice}
    ${result_newprice}    Set Variable If    '${input_newprice}'=='none'    ${lastest_price}    ${input_newprice}
    ${lastest_num}    Input number and validate data    ${textbox_nh_soluong}    ${input_soluong}    ${lastest_num}    ${cell_nh_lastest_number}
    Run Keyword If    0<${input_giamgia_sp}<=100    Wait Until Keyword Succeeds    3 times    0.5s    Input % discount for product in NH form    ${input_giamgia_sp}
    ...    ${result_newprice}    ELSE IF   ${input_giamgia_sp}>100     Wait Until Keyword Succeeds    3 times    0.5s    Input vnd discount for product in NH form    ${input_giamgia_sp}
    ...    ${input_newprice}       ELSE     Log    Ignore input discount
    Return From Keyword    ${lastest_num}

Input products and IMEIs to NH form
    [Arguments]    ${input_ma_sp}    ${list_imei}
    Wait Until Keyword Succeeds    3 times    5 s    Input data in textbox and wait until it is visible    ${textbox_nh_search_hh}    ${input_ma_sp}    ${nh_item_indropdown_search}
    ...    ${nh_cell_first_product_code}
    ${index_imei}    Set Variable    -1
    : FOR    ${imei}    IN    @{list_imei}
    \    ${index_imei}    Evaluate    ${index_imei} + 1
    \    ${item_imei}    Get From List    ${list_imei}    ${index_imei}
    \    Wait Until Keyword Succeeds    3 times    0.5 s    Input data    ${textbox_nhap_serial}    ${item_imei}

Input new price and % discount for product in NH form
    [Arguments]    ${input_newprice}    ${lastest_price}    ${input_giamgia_sp}
    Wait Until Page Contains Element    ${textbox_nh_gia}    2 mins
    Run Keyword If    '${input_newprice}'=='none'    Log    Ignore newprice
    ...    ELSE    Wait Until Keyword Succeeds    3 times    0.5 s    Input new price of product in NH form    ${input_newprice}
    ${result_newprice}    Set Variable If    '${input_newprice}'=='none'    ${lastest_price}    ${input_newprice}
    Run Keyword If    ${input_giamgia_sp}!=0    Wait Until Keyword Succeeds    3 times    0.5s    Input % discount for product in NH form    ${input_giamgia_sp}
    ...    ${result_newprice}
    ...    ELSE    Log    Ignore input discount

Input new price and vnd discount for product in NH form
    [Arguments]    ${input_newprice}    ${input_giamgia_sp}
    Wait Until Page Contains Element    ${textbox_nh_gia}    2 mins
    Run Keyword If    '${input_newprice}'=='none'    Log    Ignore newprice
    ...    ELSE    Wait Until Keyword Succeeds    3 times    0.5 s    Input new price of product in NH form    ${input_newprice}
    Wait Until Keyword Succeeds    3 times    0.5s    Input vnd discount for product in NH form    ${input_giamgia_sp}    ${input_newprice}

Input new price and discount for product in NH form
    [Arguments]    ${input_newprice}    ${lastest_price}    ${input_giamgia_sp}
    Wait Until Page Contains Element    ${textbox_nh_gia}    30s
    Run Keyword If    '${input_newprice}'=='none'    Log    Ignore newprice
    ...    ELSE    Wait Until Keyword Succeeds    3 times    0.5s    Input new price of product in NH form    ${input_newprice}
    ${result_newprice}    Set Variable If    '${input_newprice}'=='none'    ${lastest_price}    ${input_newprice}
    Run Keyword If    0<${input_giamgia_sp}<=100    Wait Until Keyword Succeeds    3 times    0.5s    Input % discount for product in NH form    ${input_giamgia_sp}
    ...    ${result_newprice}   ELSE      ${input_giamgia_sp}>100   ait Until Keyword Succeeds    3 times    0.5s    Input vnd discount for product in NH form    ${input_giamgia_sp}    ${input_newprice}
    ...    ELSE    Log    Ignore input discount

Input product - nums in NH form
    [Arguments]    ${input_ma_sp}    ${input_soluong}    ${lastest_num}
    Wait Until Page Contains Element    ${textbox_nh_search_hh}    2 mins
    Wait Until Keyword Succeeds    3 times    5 s    Input data in textbox and wait until it is visible    ${textbox_nh_search_hh}    ${input_ma_sp}    ${nh_item_indropdown_search}
    ...    ${nh_cell_first_product_code}
    Wait Until Page Contains Element    ${textbox_nh_soluong}    2 mins
    ${lastest_num}    Input number and validate data    ${textbox_nh_soluong}    ${input_soluong}    ${lastest_num}    ${cell_nh_lastest_number}
    Return From Keyword    ${lastest_num}

Input products and lot name to NH form
    [Arguments]    ${input_ma_sp}    ${list_lo}    ${input_num}
    Wait Until Keyword Succeeds    3 times    5s    Input data in textbox and wait until it is visible    ${textbox_nh_search_hh}    ${input_ma_sp}    ${nh_item_indropdown_search}
    ...    ${nh_cell_first_product_code}
    ${index_lo}    Set Variable    -1
    : FOR    ${item}    IN    ${list_lo}
    \    ${index_lo}    Evaluate    ${index_lo}+1
    \    ${item_lo}    Get From List    ${list_lo}    ${index_lo}
    \    Input Text    ${textbox_nh_nhap_lo}    ${item_lo}
    \    ${item_lo}    Replace sq blackets    ${item_lo}
    \    ${item_dropdownlist}    Format String    ${item_nh_lo_in_dropdown}    ${item_lo}
    \    Wait Until Element Is Visible    ${item_dropdownlist}    30 s
    \    Press Key    ${textbox_nh_nhap_lo}    ${ENTER_KEY}
    \    Wait Until Page Contains Element    ${textbox_nh_soluong_lo}    20s
    \    Input data    ${textbox_nh_soluong_lo}    ${input_num}

Input num for product to NH form
    [Arguments]    ${input_soluong}    ${lastest_num}
    Wait Until Page Contains Element    ${textbox_nh_soluong}    2 mins
    ${lastest_num}    Input number and validate data    ${textbox_nh_soluong}    ${input_soluong}    ${lastest_num}    ${cell_nh_lastest_number}
    Return From Keyword    ${lastest_num}

Input lot name and num to NH form
    [Arguments]    ${input_ma_sp}    ${list_lo}    ${input_num}
    ${index_lo}    Set Variable    -1
    : FOR    ${item_lo}     IN    ${list_lo}
    \    ${index_lo}    Evaluate    ${index_lo}+1
    \    ${item_lo}    Get From List    ${list_lo}    ${index_lo}
    \    Input Text    ${textbox_nh_nhap_lo}    ${item_lo}
    \    ${item_lo}    Replace sq blackets    ${item_lo}
    \    ${item_dropdownlist}    Format String    ${item_nh_lo_in_dropdown}    ${item_lo}
    \    Wait Until Element Is Visible    ${item_dropdownlist}    30 s
    \    Press Key    ${textbox_nh_nhap_lo}    ${ENTER_KEY}
    \    Wait Until Page Contains Element    ${textbox_nh_soluong_lo}    20s
    \    Input data    ${textbox_nh_soluong_lo}    ${input_num}

Input product - num and create Lot, expiry date by generating randomly
    [Arguments]    ${input_ma_sp}    ${input_num}    ${tenlo}
    Wait Until Keyword Succeeds    3 times    5s    Input data in textbox and wait until it is visible    ${textbox_nh_search_hh}    ${input_ma_sp}    ${nh_item_indropdown_search}
    ...    ${nh_cell_first_product_code}
    Wait Until Page Contains Element    ${textbox_nh_nhap_lo}    2 min
    Click Element    ${textbox_nh_nhap_lo}
    Wait Until Page Contains Element    ${button_nh_them_lo_hsd}    2 min
    Click Element    ${button_nh_them_lo_hsd}
    Wait Until Page Contains Element    ${textbox_nh_tenlo}    2 min
    Input Text       ${textbox_nh_tenlo}    ${tenlo}
    ${date}    Get Current Date
    ${hsd}    Add Time To Date    ${date}    30 days
    ${hsd}    Convert Date    ${hsd}    result_format=%d%m%Y
    ${hsd}    Convert To String    ${hsd}
    Input text    ${textbox_nh_soluong_lo}    ${input_num}
    Input data    ${textbox_nh_hansudung}    ${hsd}

Select supplier's charge
    [Arguments]    ${total_supplier_charge_value}
    Wait Until Element Is Enabled    ${cell_supplier_charge_value}
    Press Key    ${cell_supplier_charge_value}    ${ENTER_KEY}
    Wait Until Page Contains Element    ${checkbox_all_expense}     20s
    Wait Until Keyword Succeeds    3x    1s    Click Element    ${checkbox_all_expense}
    Wait Until Keyword Succeeds    3x    1s    Press Key      ${checkbox_all_expense}    ${ESC_KEY}
    :FOR    ${time}     IN RANGE      10
    \    ${get_expense_value}    Get text and convert to number    ${cell_supplier_charge_value}
    \    ${status}      Run Keyword And Return Status     Should Be Equal As Numbers    ${get_expense_value}    ${total_supplier_charge_value}
    \    Exit For Loop If    '${status}'=='True'

Select other charge
    [Arguments]    ${total_other_charge_value}
    Wait Until Element Is Enabled    ${cell_other_charge_value}
    Press Key    ${cell_other_charge_value}    ${ENTER_KEY}
    Wait Until Page Contains Element    ${checkbox_all_expense}     20s
    Wait Until Keyword Succeeds    3x    1s      Click Element    ${checkbox_all_expense}
    Wait Until Keyword Succeeds    3x    1s      Press Key    ${checkbox_all_expense}    ${ESC_KEY}
    :FOR    ${time}     IN RANGE      10
    \     ${get_expense_value}    Get text and convert to number    ${cell_other_charge_value}
    \     ${status}      Run Keyword And Return Status     Should Be Equal As Numbers    ${get_expense_value}    ${total_other_charge_value}
    \    Exit For Loop If    '${status}'=='True'

Select list supplier's charge and input value
    [Arguments]    ${list_supplier_charge}   ${list_auto}    ${list_supplier_charge_value}    ${tongtien_tru_gg}
    Wait Until Page Contains Element     ${cell_supplier_charge_value}      20s
    Press Key    ${cell_supplier_charge_value}    ${ENTER_KEY}
    Wait Until Page Contains Element    ${checkbox_all_expense}     20s
    :FOR     ${item_cpnh}     ${item_auto}     ${item_supplier_charge_value}     IN ZIP        ${list_supplier_charge}   ${list_auto}     ${list_supplier_charge_value}
    \       ${checkbox_cpnh}      Format String       ${checkbox_nh_cpnh}      ${item_cpnh}
    \       Run Keyword If    '${item_auto}'=='false'      KV Click Element    ${checkbox_cpnh}
    \       Run Keyword If    '${item_supplier_charge_value}'!='none'    Wait Until Keyword Succeeds    3x    1s   Input value in textbox Chi tren phieu nhap    ${item_cpnh}    ${item_supplier_charge_value}    ${tongtien_tru_gg}
    Sleep    1s
    Click Element    ${button_close_popup_cpnh}

Select list other charge and input value
    [Arguments]    ${list_other_charge}   ${list_auto}     ${list_other_charge_value}   ${tongtien_tru_gg}
    Wait Until Page Contains Element     ${cell_other_charge_value}     20s
    Press Key    ${cell_other_charge_value}    ${ENTER_KEY}
    Wait Until Page Contains Element    ${checkbox_all_expense}     20s
    :FOR     ${item_cpnh}     ${item_auto}       ${item_other_charge_value}     IN ZIP        ${list_other_charge}   ${list_auto}    ${list_other_charge_value}
    \       ${checkbox_cpnh}      Format String       ${checkbox_nh_cpnh}      ${item_cpnh}
    \       Run Keyword If    '${item_auto}'=='false'      Wait Until Page Contains Element    ${checkbox_cpnh}     20s
    \       Run Keyword If    '${item_auto}'=='false'      Click Element       ${checkbox_cpnh}
    \       Run Keyword If    '${item_other_charge_value}'!='none'    Wait Until Keyword Succeeds    3x    1s   Input value in textbox Chi tren phieu nhap    ${item_cpnh}    ${item_other_charge_value}    ${tongtien_tru_gg}
    Sleep    1s
    Click Element    ${button_close_popup_cpnh}

Input value in textbox Chi tren phieu nhap
    [Arguments]     ${ma_cpnh}      ${gia_tri}    ${tongtien_tru_gg}
    ${cell_nh_chi_phi_nhap}    Format String    ${cell_nh_chi_phi_nhap_theo_macp}    ${ma_cpnh}
    Click Element    ${cell_nh_chi_phi_nhap}
    Wait Until Page Contains Element    ${button_nh_cpnh_%}
    Run Keyword If    ${gia_tri}>100    Click Element    ${button_nh_cpnh_vnd}
    ...    ELSE    Click Element    ${button_nh_cpnh_%}
    Input data    ${textbox_nh_muc_chi_moi}    ${gia_tri}
    ${result_value}    Run Keyword If    ${gia_tri}>100    Set Variable    ${gia_tri}
    ...    ELSE    Convert % discount to VND and round    ${tongtien_tru_gg}    ${gia_tri}
    ${get_cpnh_value}    Get text and convert to number    ${cell_nh_chi_phi_nhap}
    Should Be Equal As Numbers    ${result_value}    ${get_cpnh_value}

Select supplier's charge and input value
    [Arguments]    ${list_expense}    ${list_value}    ${total}
    Set Selenium Speed    0.5s
    Wait Until Element Is Enabled    ${cell_supplier_charge_value}
    Press Key    ${cell_supplier_charge_value}    ${ENTER_KEY}
    Wait Until Page Contains Element    ${checkbox_all_expense}
    Sleep    3s
    ${total_expense_value}    Set Variable    0
    : FOR    ${item_ma_cpnh}    ${item_value}    IN ZIP    ${list_expense}    ${list_value}
    \    ${checkbox_cpnh}    Format String    ${checkbox_nh_cpnh}    ${item_ma_cpnh}
    \    Click Element    ${checkbox_cpnh}
    \    ${cell_nh_chi_phi_nhap}    Format String    ${cell_nh_chi_phi_nhap_theo_macp}    ${item_ma_cpnh}
    \    Click Element    ${cell_nh_chi_phi_nhap}
    \    Wait Until Page Contains Element    ${button_nh_cpnh_%}
    \    Run Keyword If    ${item_value}>100    Click Element    ${button_nh_cpnh_vnd}
    \    ...    ELSE    Click Element    ${button_nh_cpnh_%}
    \    Input data    ${textbox_nh_muc_chi_moi}    ${item_value}
    \    ${result_value}    Run Keyword If    ${item_value}>100    Set Variable    ${item_value}
    \    ...    ELSE    Convert % discount to VND and round    ${total}    ${item_value}
    \    ${get_cpnh_value}    Get text and convert to number    ${cell_nh_chi_phi_nhap}
    \    Should Be Equal As Numbers    ${result_value}    ${get_cpnh_value}
    \    ${total_expense_value}    Sum    ${total_expense_value}    ${result_value}
    \    Log    ${total_expense_value}
    Press Key    ${checkbox_all_expense}    ${ESC_KEY}
    Sleep    5s
    ${get_expense_value}    Get text and convert to number    ${cell_supplier_charge_value}
    Should Be Equal As Numbers    ${get_expense_value}    ${total_expense_value}
    Return From Keyword    ${total_expense_value}

Select other charge and input value
    [Arguments]    ${list_expense}    ${list_value}    ${total}
    Set Selenium Speed    0.5s
    Wait Until Element Is Enabled    ${cell_other_charge_value}
    Press Key    ${cell_other_charge_value}    ${ENTER_KEY}
    Wait Until Page Contains Element    ${checkbox_all_expense}
    Sleep    3s
    ${total_expense_value}    Set Variable    0
    : FOR    ${item_ma_cpnh}    ${item_value}    IN ZIP    ${list_expense}    ${list_value}
    \    ${checkbox_cpnh}    Format String    ${checkbox_nh_cpnh}    ${item_ma_cpnh}
    \    Click Element    ${checkbox_cpnh}
    \    ${cell_nh_chi_phi_nhap}    Format String    ${cell_nh_chi_phi_nhap_theo_macp}    ${item_ma_cpnh}
    \    Click Element    ${cell_nh_chi_phi_nhap}
    \    Wait Until Page Contains Element    ${button_nh_cpnh_%}
    \    Run Keyword If    ${item_value}>100    Click Element    ${button_nh_cpnh_vnd}
    \    ...    ELSE    Click Element    ${button_nh_cpnh_%}
    \    Input data    ${textbox_nh_muc_chi_moi}    ${item_value}
    \    ${result_value}    Run Keyword If    ${item_value}>100    Set Variable    ${item_value}
    \    ...    ELSE    Convert % discount to VND and round    ${total}    ${item_value}
    \    ${get_cpnhk_value}    Get text and convert to number    ${cell_nh_chi_phi_nhap}
    \    Should Be Equal As Numbers    ${result_value}    ${get_cpnhk_value}
    \    ${total_expense_value}    Sum    ${total_expense_value}    ${result_value}
    \    Log    ${total_expense_value}
    Press Key    ${checkbox_all_expense}    ${ESC_KEY}
    Sleep    5s
    ${get_expense_value}    Get text and convert to number    ${cell_other_charge_value}
    Should Be Equal As Numbers    ${get_expense_value}    ${total_expense_value}
    Return From Keyword    ${total_expense_value}

Input IMEIs in NH form
    [Arguments]    ${product}    ${list_imei}
    ${xpath_nhap_serial}    Format String    ${textbox_nh_nhap_serial}    ${product}
    ${index_imei}    Set Variable    -1
    : FOR    ${imei}    IN    @{list_imei}
    \    ${index_imei}    Evaluate    ${index_imei} + 1
    \    ${item_imei}    Get From List    ${list_imei}    ${index_imei}
    \    Wait Until Keyword Succeeds    3 times    0.5 s    Input data    ${xpath_nhap_serial}    ${item_imei}

Input list lot name and list num of product to NH form
    [Arguments]    ${input_ma_sp}    ${list_lo}    ${list_nums}
    ${list_result_lo}    Convert string to list    ${list_lo}
    ${list_result_nums}    Convert string to list    ${list_nums}
    : FOR    ${item_lo}    ${item_num}    IN ZIP    ${list_result_lo}    ${list_result_nums}
    \    Input Text    ${textbox_nhaplo}   ${item_lo}
    \    ${item_dropdownlist}    Format String    ${item_nh_lo_in_dropdown}    ${item_lo}
    \    Wait Until Element Is Visible    ${item_dropdownlist}    30 s
    \    Press Key    ${textbox_nhaplo}    ${ENTER_KEY}
    \    Wait Until Page Contains Element    ${textbox_nh_soluong_lo}    20s
    \    Input data    ${textbox_nh_soluong_lo}    ${item_num}

Create new lots - num by generating randomly and return list lots
    [Arguments]    ${list_num}
    ${date}    Get Current Date
    ${hsd}    Add Time To Date    ${date}    30 days
    ${hsd}    Convert Date    ${hsd}    result_format=%d%m%Y
    ${hsd}    Convert To String    ${hsd}
    ${list_num}    Convert string to list    ${list_num}
    ${list_tenlo}    Create List
    : FOR    ${item_num}    IN ZIP    ${list_num}
    \    ${tenlo}    Generate Random String    5    [UPPER][NUMBERS]
    \    Wait Until Page Contains Element    ${textbox_nh_nhap_lo}    2 min
    \    Click Element    ${textbox_nh_nhap_lo}
    \    Wait Until Page Contains Element    ${button_nh_them_lo_hsd}    2 min
    \    Click Element    ${button_nh_them_lo_hsd}
    \    Wait Until Page Contains Element    ${textbox_nh_tenlo}    2 min
    \    Input text    ${textbox_nh_tenlo}    ${tenlo}
    \    Input text    ${textbox_nh_soluong_lo}    ${item_num}
    \    Input data    ${textbox_nh_hansudung}    ${hsd}
    \    Append To List    ${list_tenlo}    ${tenlo}
    Return From Keyword    ${list_tenlo}

Input % discount for any product in NH form
    [Arguments]    ${button_ggsp}      ${input_giamgia_%}    ${input_result_newprice_by_vnd}
    Click Element    ${button_ggsp}
    Wait Until Page Contains Element    ${button_nh_giamgiasp_vnd%}
    Click Element JS    ${button_nh_giamgiasp_vnd%}
    Wait Until Page Contains Element    ${textbox_nh_giamgia_sp}    3s
    Wait Until Keyword Succeeds    3 times    20 s    Input data    ${textbox_nh_giamgia_sp}    ${input_giamgia_%}
    ${discount_vnd}    Get New price from UI    ${button_ggsp}
    ${result_discount_vnd}    Multiplication    ${input_result_newprice_by_vnd}    ${input_giamgia_%}
    ${result_discount_vnd}    Devision    ${result_discount_vnd}    100
    ${result_discount_vnd}    Evaluate    round(${result_discount_vnd}, 2)
    Should Be Equal As Numbers    ${discount_vnd}    ${result_discount_vnd}

Input vnd discount for any product in NH form
    [Arguments]      ${button_ggsp}      ${input_giamgia_vnd}
    Click Element    ${button_ggsp}
    Wait Until Page Contains Element    ${textbox_nh_giamgia_sp}    3s
    Wait Until Keyword Succeeds    3 times    0.5 s    Input data    ${textbox_nh_giamgia_sp}    ${input_giamgia_vnd}
    ${discount_vnd}    Get New price from UI    ${button_ggsp}
    Should Be Equal As Numbers    ${discount_vnd}    ${input_giamgia_vnd}

Input num for any product in NH form
    [Arguments]    ${input_product}    ${input_num}
    Input value for any product    ${input_product}    ${input_num}    ${textbox_nh_soluong_any_pr}

Input newprice - discount for any product in NH form
    [Arguments]    ${input_product}    ${input_newprice}    ${input_discount}
    Input value for any product    ${input_product}    ${input_newprice}    ${textbox_nh_dongia_any_pr}
    ${button_nh_giamgia_any_pr}    Format String    ${button_nh_giamgia_any_pr}    ${input_product}
    Run Keyword If    ${input_discount} > 100    Wait Until Keyword Succeeds    3 times    0.5s    Input vnd discount for any product in NH form      ${button_nh_giamgia_any_pr}        ${input_discount}
    ...    ELSE    Wait Until Keyword Succeeds    3 times    0.5s   Input % discount for any product in NH form      ${button_nh_giamgia_any_pr}     ${input_discount}     ${input_newprice}

Input new price for any product in NH form
    [Arguments]    ${textbox_location}    ${input_giamoi}
    Click Element    ${textbox_location}
    Wait Until Keyword Succeeds    3 times    3s    Input data    ${textbox_location}    ${input_giamoi}

Add row and input data for proudct in NH form
    [Arguments]     ${input_product}    ${list_num}      ${list_newprice}      ${list_discount}    ${lastest_num}
    Wait Until Page Contains Element    ${textbox_nh_search_hh}    2 mins
    Wait Until Keyword Succeeds    3 times    5s    Input data in textbox and wait until it is visible    ${textbox_nh_search_hh}    ${input_product}    ${nh_item_indropdown_search}
    ...    ${nh_cell_first_product_code}
    ${list_num}     Convert string to list      ${list_num}
    ${list_newprice}      Convert string to list      ${list_newprice}
    ${list_discount}      Convert string to list      ${list_discount}
    ${index}      Set Variable    -2
    ${index1}     Set Variable    -3
    :FOR      ${item_newprice}    ${item_num}      ${item_discount}      IN ZIP      ${list_newprice}     ${list_num}      ${list_discount}
    \     ${index}      Sum       ${index}      1
    \     ${index1}     Minus     ${index}      1
    \     ${index}      Replace floating point    ${index}
    \     ${index1}     Replace floating point    ${index1}
    \     ${button_them_dong}     Run Keyword If    '${index1}'=='-1'     Format String     ${button_nh_add_row_by_pr}      ${EMPTY}    ELSE      Format String     ${button_nh_add_row_by_pr}      ${index1}
    \     ${textbox_soluong}    Run Keyword If    '${index}'=='-1'    Format String     ${textbox_nh_soluong_pr_in_row}      ${EMPTY}      ELSE      Format String     ${textbox_nh_soluong_pr_in_row}      ${index}
    \     ${textbox_donggia}    Run Keyword If    '${index}'=='-1'    Format String     ${textbox_nh_dongia_pr_in_row}      ${EMPTY}      ELSE      Format String     ${textbox_nh_dongia_pr_in_row}      ${index}
    \     ${button_giamgia}    Run Keyword If    '${index}'=='-1'    Format String     ${button_nh_giamgia_pr_in_row}      ${EMPTY}      ELSE      Format String     ${button_nh_giamgia_pr_in_row}      ${index}
    \     Run Keyword If    '${index1}'=='-2'      Log     Ignore      ELSE      Click Element    ${button_them_dong}
    \     ${lastest_num}    Input number and validate data    ${textbox_soluong}    ${item_num}    ${lastest_num}    ${cell_nh_lastest_number}
    \     Run Keyword If    '${item_newprice}'=='none'    Log    Ignore newprice    ELSE    Wait Until Keyword Succeeds    3 times    3s    Input new price for any product in NH form       ${textbox_donggia}    ${item_newprice}
    \     Run Keyword If    0<${item_discount}<100    Input % discount for any product in NH form    ${button_giamgia}      ${item_discount}     ${item_newprice}    ELSE IF     ${item_discount}>100      Input vnd discount for any product in NH form    ${button_giamgia}     ${item_discount}
    Return From Keyword    ${lastest_num}

Add row and input data for imei proudct in NH form
    [Arguments]     ${input_product}    ${list_num}      ${list_newprice}      ${list_discount}   ${list_imei}    ${lastest_num}
    Wait Until Page Contains Element    ${textbox_nh_search_hh}    2 mins
    Wait Until Keyword Succeeds    3 times    5s    Input data in textbox and wait until it is visible    ${textbox_nh_search_hh}    ${input_product}    ${nh_item_indropdown_search}
    ...    ${nh_cell_first_product_code}
    ${list_num}     Convert string to list      ${list_num}
    ${list_newprice}      Convert string to list      ${list_newprice}
    ${list_discount}      Convert string to list      ${list_discount}
    ${index}      Set Variable    -2
    ${index1}     Set Variable    -3
    :FOR      ${item_newprice}    ${item_num}      ${item_discount}     ${item_imei}      IN ZIP      ${list_newprice}     ${list_num}      ${list_discount}      ${list_imei}
    \     ${index}      Sum       ${index}      1
    \     ${index1}     Minus     ${index}      1
    \     ${index}      Replace floating point    ${index}
    \     ${index1}     Replace floating point    ${index1}
    \     ${button_them_dong}     Run Keyword If    '${index1}'=='-1'     Format String     ${button_nh_add_row_by_pr}      ${EMPTY}    ELSE      Format String     ${button_nh_add_row_by_pr}      ${index1}
    \     ${textbox_nhap_imei}    Run Keyword If    '${index}'=='-1'    Format String     ${textbox_nh_nhapimei_in_row}      ${EMPTY}      ELSE      Format String     ${textbox_nh_nhapimei_in_row}      ${index}
    \     ${textbox_donggia}    Run Keyword If    '${index}'=='-1'    Format String     ${textbox_nh_dongia_pr_in_row}      ${EMPTY}      ELSE      Format String     ${textbox_nh_dongia_pr_in_row}      ${index}
    \     ${button_giamgia}    Run Keyword If    '${index}'=='-1'    Format String     ${button_nh_giamgia_pr_in_row}      ${EMPTY}      ELSE      Format String     ${button_nh_giamgia_pr_in_row}      ${index}
    \     Run Keyword If    '${index1}'=='-2'      Log     Ignore      ELSE      Click Element    ${button_them_dong}
    \     ${lastest_num}    SUm     ${lastest_num}    ${item_num}
    \     Input IMEIs for any proudct in NH form    ${textbox_nhap_imei}    ${item_imei}
    \     Run Keyword If    '${item_newprice}'=='none'    Log    Ignore newprice    ELSE    Wait Until Keyword Succeeds    3 times    3s    Input new price for any product in NH form       ${textbox_donggia}    ${item_newprice}
    \     Run Keyword If    0<${item_discount}<100    Input % discount for any product in NH form    ${button_giamgia}      ${item_discount}     ${item_newprice}    ELSE IF     ${item_discount}>100      Input vnd discount for any product in NH form    ${button_giamgia}     ${item_discount}
    Return From Keyword    ${lastest_num}

Input IMEIs for any proudct in NH form
    [Arguments]     ${location_nhap_serial}     ${list_imei}
    ${index_imei}    Set Variable    -1
    : FOR    ${imei}    IN    @{list_imei}
    \    ${index_imei}    Evaluate    ${index_imei} + 1
    \    ${item_imei}    Get From List    ${list_imei}    ${index_imei}
    \    Wait Until Keyword Succeeds    3 times    0.5 s    Input data    ${location_nhap_serial}    ${item_imei}

Input products and fill values in NH form
    [Arguments]     ${list_pr}    ${list_num}    ${list_newprice}    ${list_discount}    ${list_dongia}
    ${get_list_status}    Get list imei status thr API    ${list_pr}
    ${list_imei_all}    Create List
    ${lastest_num}    Set Variable    0
    : FOR    ${item_product}    ${item_num}    ${item_newprice}    ${item_discount_prd}    ${item_dongia}    ${item_status}
    ...    IN ZIP    ${list_pr}    ${list_num}    ${list_newprice}    ${list_discount}    ${list_dongia}
    ...    ${get_list_status}
    \    ${list_imei}    Run Keyword If    '${item_status}'=='True'    Create list imei by generating random    ${item_num}
    \    ...    ELSE    Set Variable    ${EMPTY}
    \    ${lastest_num}    Run Keyword If    ${item_status}==0    Input product - num - new price - product discount in NH form   ${item_product}    ${item_num}
    \    ...    ${item_newprice}    ${item_dongia}    ${item_discount_prd}    ${lastest_num}   ELSE    Set Variable    ${lastest_num}
    \    Run Keyword If    '${item_status}'=='True'    Input products and IMEIs to NH form    ${item_product}    ${list_imei}
    \    Run Keyword If    '${item_status}'=='True'    Input new price and discount for product in NH form    ${item_newprice}    ${item_dongia}    ${item_discount_prd}
    \    ${lastest_num}    Run Keyword If    '${item_status}'=='True'    Sum    ${lastest_num}    ${item_num}    ELSE    Set Variable    ${lastest_num}
    \    Append To List    ${list_imei_all}    ${list_imei}
    Log Many    ${lastest_num}    ${list_imei_all}
    Return From Keyword    ${lastest_num}    ${list_imei_all}

Add product multi row and fill values
    [Arguments]     ${list_product}    ${list_num}      ${list_newprice}    ${list_discount}
    ${get_list_imei_status}    Get list imei status thr API    ${list_product}
    ${list_imei}    create list
    : FOR    ${item_product}    ${item_num}    ${item_status}    IN ZIP    ${list_product}    ${list_num}
    ...    ${get_list_imei_status}
    \    ${item_num}    Split String    ${item_num}    ,
    \    ${imei_by_product}    Run Keyword If    '${item_status}'=='True'    Generate list imei by receipt multi row        ${item_num}
    \    ...    ELSE    Set Variable    ${EMPTY}
    \    Append To List    ${list_imei}    ${imei_by_product}
    Log    ${list_imei}
    ${lastest_num}    Set Variable    0
    : FOR    ${item_product}    ${item_num}    ${item_newprice}    ${item_discount_pr}      ${item_status}     ${item_imei}
    ...    IN ZIP    ${list_product}    ${list_num}    ${list_newprice}    ${list_discount}      ${get_list_imei_status}      ${list_imei}
    \      ${lastest_num}      Run Keyword If    '${item_status}'=='0'      Add row and input data for proudct in NH form      ${item_product}    ${item_num}    ${item_newprice}    ${item_discount_pr}     ${lastest_num}       ELSE      Add row and input data for imei proudct in NH form    ${item_product}    ${item_num}    ${item_newprice}    ${item_discount_pr}   ${item_imei}     ${lastest_num}
    Log Many    ${lastest_num}    ${list_imei}
    Return From Keyword    ${lastest_num}    ${list_imei}

Input num and remove product in NH form
    [Arguments]     ${list_product}   ${list_num}
    ${get_list_status}    Get list imei status thr API    ${list_product}
    ${list_imei_all}    Create List
    : FOR    ${item_pr}    ${item_num}    ${item_status}    IN ZIP    ${list_product}    ${list_num}    ${get_list_status}
    \    ${list_imei}    Run Keyword If    '${item_status}'=='True' and '${item_num}'!='0'    Create list imei by generating random    ${item_num}
    \    ...    ELSE    Log    Ignore
    \    Run Keyword If    '${item_status}'=='True' and '${item_num}'!='0'   Input IMEIs in NH form    ${item_pr}    ${list_imei}
    \    ...    ELSE IF    '${item_status}'!='True' and '${item_num}'!='0'     Input num in DHN form    ${item_pr}    ${item_num}
    \    ...    ELSE    Remove product frm DHN from    ${item_pr}
    \    Append To List    ${list_imei_all}    ${list_imei}
    Log    ${list_imei_all}
    Return From Keyword      ${list_imei_all}

Input imei in NH form
    [Arguments]     ${list_product}   ${list_num}
    ${get_list_status}    Get list imei status thr API    ${list_product}
    ${list_imei_all}    Create List
    : FOR    ${item_pr}    ${item_num}    ${item_status}    IN ZIP    ${list_product}    ${list_num}    ${get_list_status}
    \    ${list_imei}    Run Keyword If    '${item_status}'=='True'     Create list imei by generating random    ${item_num}
    \    ...    ELSE    Log    Ignore
    \    Run Keyword If    '${item_status}'=='True'   Input IMEIs in NH form    ${item_pr}    ${list_imei}
    \    Append To List    ${list_imei_all}    ${list_imei}
    Log    ${list_imei_all}
    Return From Keyword      ${list_imei_all}

Edit price, discount and num in NH form
    [Arguments]   ${list_pr}    ${list_num}    ${list_newprice}    ${list_discount}
    ${get_list_status}    Get list imei status thr API    ${list_pr}
    :FOR    ${item_product}    ${item_num}    ${item_newprice}    ${item_discount}    ${item_status}    IN ZIP
    ...    ${list_pr}    ${list_num}    ${list_newprice}    ${list_discount}    ${get_list_status}
    \    Run Keyword If    '${item_status}'=='True'    Log    ignore
    \    ...    ELSE    Wait Until Keyword Succeeds    3x    0.5s   Input num for any product in NH form    ${item_product}    ${item_num}
    \    Wait Until Keyword Succeeds    3x    0.5s    Input newprice - discount for any product in NH form    ${item_product}    ${item_newprice}    ${item_discount}

Edit supplier in NH form
    [Arguments]       ${supplier_code}      ${result_supplier_code}
    Run Keyword If    '${supplier_code}'!='none'       Click Element       ${button_nh_remove_ncc}
    Run Keyword If    '${supplier_code}'!='none'    Wait Until Keyword Succeeds    3x    1s      Input Supplier to Supplier textbox    ${result_supplier_code}
    Run Keyword If    '${supplier_code}'!='none'       Click Element JS    ${cell_nhacungcap}
