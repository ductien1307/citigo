*** Settings ***
Library           SeleniumLibrary
Library           StringFormat
Library           String
Resource          ../share/computation.robot
Resource          ../share/javascript.robot
Resource          nhap_hang_add_action.robot
Resource          dat_hang_nhap_add_page.robot

*** Keywords ***
Click Bo qua if popup Mo ban nhap appear
    Wait Until Page Contains Element    ${textbox_nh_ncc}    1 min
    ${status}     Run Keyword And Return Status    Wait Until Page Contains Element    ${buttong_dhn_boqua_mobannhap}     10s
    Run Keyword If    '${status}'=='True'    Click Element JS    ${buttong_dhn_boqua_mobannhap}

Input purchase order infor
    [Arguments]    ${input_ma_ncc}    ${input_cantra_ncc}    ${input_tientra_ncc}
    Wait Until Page Contains Element    ${textbox_nh_ncc}    1 min
    Wait Until Keyword Succeeds    3 times    3 s    Input Supplier to Supplier textbox    ${input_ma_ncc}
    Click Element JS    ${cell_nhacungcap}
    Wait Until Keyword Succeeds    3 times    0.5s    Input pay for supplier and validate in DHN form    ${input_tientra_ncc}    ${input_cantra_ncc}

Input pay for supplier and validate in DHN form
    [Arguments]    ${input_tientra_ncc}    ${input_cantra_ncc}
    Wait Until Keyword Succeeds    3 times    0.5 s    Input data    ${textbox_nh_tien_tra_ncc}    ${input_tientra_ncc}
    ${cell_tinhvaocongno}    Get Change to customer from UI    ${cell_dhn_tinh_vao_cong_no}
    ${result_tinhvaocongno}    Minus    ${input_cantra_ncc}    ${input_tientra_ncc}
    Should Be Equal As Numbers    ${cell_tinhvaocongno}    ${result_tinhvaocongno}

Remove product frm DHN form and validate data
    [Arguments]    ${ma_sp}    ${lastest_num}    ${num}    ${total}    ${gt_del}
    ${xpath_xoa_sp}    Format String    ${button_dhn_xoa_sp}    ${ma_sp}
    Wait Until Page Contains Element    ${xpath_xoa_sp}    1 min
    Click Element    ${xpath_xoa_sp}
    ${lastest_num}    ${total}    Validate data in case remove product frm DHN form    ${lastest_num}    ${num}    ${total}    ${gt_del}
    Return From Keyword    ${lastest_num}    ${total}

Edit product infor in DHN form
    [Arguments]    ${code}    ${num}    ${newprice}    ${discount}
    ${xpath_soluong}    Format String    ${textbox_dhn_so_luong}    ${code}
    ${xpath_giamoi}    Format String    ${textbox_dhn_don_gia}    ${code}
    ${xpath_giamgia}    Format String    ${textbox_dhn_giam_gia_sp}
    Input data    ${xpath_soluong}    ${num}
    Input data    ${xpath_giamoi}    ${newprice}
    Click Element    ${xpath_giamgia}
    Run Keyword If    ${discount} > 100    Input VND discount for product    ${discount}    ${newprice}    Input % discount for product    ${discount}
    ...    ${newprice}

Input discount product VND in DHN form
    ${xpath_dongia}    Format String    ${textbox_dhn_giam_gia_sp}    ${code}
    Wait Until Page Contains Element    ${xpath_dongia}    1 min
    Run Keyword If    '${input_newprice}'=='none'    Log    Ignore newprice
    ...    ELSE    Wait Until Keyword Succeeds    3 times    0.5 s    Input new price of product in NH form    ${input_newprice}
    ${result_newprice}    Set Variable If    '${input_newprice}'=='none'    ${lastest_price}    ${input_newprice}
    Run Keyword If    ${input_giamgia_sp}!=0    Wait Until Keyword Succeeds    3 times    0.5s    Input % discount for product in NH form    ${input_giamgia_sp}
    ...    ${result_newprice}
    ...    ELSE    Log    Ignore input discount

Validate data in case remove product frm DHN form
    [Arguments]    ${lastest_num}    ${num}    ${total}    ${gt_del}
    ${lastest_num}    Minus    ${lastest_num}    ${num}
    ${lastest_num_ui}    Get New price from UI    ${cell_nh_lastest_number}
    Should Be Equal As Numbers    ${lastest_num}    ${lastest_num_ui}
    ${total}    Minus    ${total}    ${gt_del}
    ${total_ui}    Get New price from UI    ${cell_dhn_tong_tien_hang}
    Should Be Equal As Numbers    ${total}    ${total_ui}
    Return From Keyword    ${lastest_num}    ${total}

Input num - newprice - discount in DHN form
    [Arguments]    ${ma_sp}    ${input_newprice}    ${input_soluong}    ${lastest_num}    ${input_giamgia_sp}    ${result_newprice}
    ${xpath_soluong}    Format String    ${textbox_dhn_so_luong}    ${ma_sp}
    Wait Until Page Contains Element    ${xpath_soluong}    1 min
    ${lastest_num}    Input number and validate data    ${xpath_soluong}    ${input_soluong}    ${lastest_num}    ${cell_nh_lastest_number}
    Input newprice product in DHN form    ${ma_sp}    ${input_newprice}
    Run Keyword If    0<${input_giamgia_sp}<=100    Wait Until Keyword Succeeds    3 times    0.5s    Input % discount product in DHN form    ${ma_sp}
    ...    ${input_giamgia_sp}    ${result_newprice}
    ...    ELSE IF    ${input_giamgia_sp}>100    Input VND discount product in DHN form    ${ma_sp}    ${input_giamgia_sp}
    ...    ELSE    Log    Ignore discount product
    Return From Keyword    ${lastest_num}

Input newprice product in DHN form
    [Arguments]    ${ma_sp}    ${input_giamoi}
    ${xpath_gia_moi}    Format String    ${textbox_dhn_don_gia}    ${ma_sp}
    Wait Until Keyword Succeeds    3 times    1s    Input data    ${xpath_gia_moi}    ${input_giamoi}

Input % discount product in DHN form
    [Arguments]    ${ma_sp}    ${input_giamgia_%}    ${input_result_newprice_by_vnd}
    ${xpath_giamgia}    Format String    ${button_dhn_giam_gia_sp}    ${ma_sp}
    Click Element    ${xpath_giamgia}
    Wait Until Page Contains Element    ${button_nh_giamgiasp_vnd%}    1 min
    Click Element JS    ${button_nh_giamgiasp_vnd%}
    Wait Until Page Contains Element    ${textbox_nh_giamgia_sp}    3s
    Wait Until Keyword Succeeds    3 times    0 s    Input data    ${textbox_nh_giamgia_sp}    ${input_giamgia_%}
    ${discount_vnd}    Get New price from UI    ${xpath_giamgia}
    Should Be Equal As Numbers    ${discount_vnd}    ${input_result_newprice_by_vnd}

Input VND discount product in DHN form
    [Arguments]    ${ma_sp}    ${input_giamgia_vnd}
    ${xpath_giamgia}    Format String    ${button_dhn_giam_gia_sp}    ${ma_sp}
    Click Element    ${xpath_giamgia}
    Wait Until Page Contains Element    ${button_nh_giamgiasp_vnd}    30s
    Click Element    ${button_nh_giamgiasp_vnd}
    Wait Until Keyword Succeeds    3 times    0 s    Input data    ${textbox_nh_giamgia_sp}    ${input_giamgia_vnd}
    ${discount_vnd}    Get New price from UI    ${xpath_giamgia}
    Should Be Equal As Numbers    ${discount_vnd}    ${input_giamgia_vnd}

Input product in DHN form
    [Arguments]    ${input_ma_sp}
    Wait Until Page Contains Element    ${textbox_nh_search_hh}    2 mins
    Wait Until Keyword Succeeds    3 times    5 s    Input data in textbox and wait until it is visible    ${textbox_nh_search_hh}    ${input_ma_sp}    ${nh_item_indropdown_search}
    ...    ${nh_cell_first_product_code}

Input num in DHN form
    [Arguments]    ${ma_sp}    ${input_soluong}
    ${xpath_soluong}    Format String    ${textbox_dhn_so_luong}    ${ma_sp}
    Wait Until Page Contains Element    ${xpath_soluong}    1 min
    Input data    ${xpath_soluong}    ${input_soluong}

Remove product frm DHN from
    [Arguments]    ${ma_sp}
    ${xpath_xoa_sp}    Format String    ${button_dhn_xoa_sp}    ${ma_sp}
    Wait Until Page Contains Element    ${xpath_xoa_sp}    1 min
    Click Element    ${xpath_xoa_sp}

Select status Da xac nhan in DHN form
    Wait Until Page Contains Element    ${cell_dhn_trang_thai}    1 min
    Click Element    ${cell_dhn_trang_thai}
    ${item_dxn}    Format String    ${item_dhn_trang_thai_indropdow}    Đã xác nhận NCC
    Wait Until Page Contains Element    ${item_dxn}    1 min
    Click Element    ${item_dxn}

Select Trang thai phieu Dat hang Nhap
    [Arguments]     ${status}
    Run Keyword If    '${status}'=='Đã xác nhận NCC'    Select status Da xac nhan in DHN form

Open supplier's charge and validate value
    [Arguments]    ${total_supplier_charge_value}
    Wait Until Element Is Enabled    ${cell_supplier_charge_value}
    Press Key    ${cell_supplier_charge_value}    ${ENTER_KEY}
    Wait Until Page Contains Element    ${checkbox_all_expense}     10s
    Press Key    ${checkbox_all_expense}    ${ESC_KEY}
    Sleep    1s
    ${get_expense_value}    Get text and convert to number    ${cell_supplier_charge_value}
    Should Be Equal As Numbers    ${get_expense_value}    ${total_supplier_charge_value}

Open other charge and validate value
    [Arguments]    ${total_other_charge_value}
    Wait Until Element Is Enabled    ${cell_other_charge_value}
    Press Key    ${cell_other_charge_value}    ${ENTER_KEY}
    Wait Until Page Contains Element    ${checkbox_all_expense}     10s
    Press Key    ${checkbox_all_expense}    ${ESC_KEY}
    Sleep    1s
    ${get_expense_value}    Get text and convert to number    ${cell_other_charge_value}
    Should Be Equal As Numbers    ${get_expense_value}    ${total_other_charge_value}

Select supplier in popup De xuat DHN
    [Arguments]     ${ten_ncc}
    Wait Until Element Is Visible    ${input_dx_chon_ncc}
    Input Text    ${input_dx_chon_ncc}    ${ten_ncc}
    ${xp_ncc}     Format String    ${item_dx_ncc_in_drơpdown}    ${ten_ncc}
    Wait Until Page Contains Element    ${xp_ncc}     20s
    Click Element    ${xp_ncc}

Open popup De xuat DHN and select supplier - onhand
    [Arguments]     ${ten_ncc}
    Wait Until Page Contains Element    ${button_dexuat_dhn}    1 min
    Click Element JS    ${button_dexuat_dhn}
    Wait Until Page Contains Element    ${button_dx_chon_ncc}     30s
    Click Element    ${button_dx_chon_ncc}
    Select supplier in popup De xuat DHN    ${ten_ncc}
    Click Element    ${checkbox_dx_ko_xet_tonkho}

Open popup De xuat DHN and select list supplier - onhand
    [Arguments]     ${list_ncc}
    Wait Until Page Contains Element    ${button_dexuat_dhn}    1 min
    Click Element JS    ${button_dexuat_dhn}
    Wait Until Page Contains Element    ${button_dx_chon_ncc}     30s
    Click Element    ${button_dx_chon_ncc}
    :FOR      ${item_ncc}     IN ZIP      ${list_ncc}
    \         Select supplier in popup De xuat DHN    ${item_ncc}
    Click Element    ${checkbox_dx_ko_xet_tonkho}
    Click Element    ${button_dx_xong}

Input products and fill values in DNH form
    [Arguments]     ${list_pr}    ${list_num}    ${list_newprice}    ${list_discount}    ${list_dongia}
    ${lastest_num}    Set Variable    0
    : FOR    ${item_product}    ${item_num}    ${item_newprice}    ${item_discount_prd}    ${item_dongia}
    ...    IN ZIP    ${list_pr}    ${list_num}    ${list_newprice}    ${list_discount}    ${list_dongia}
    \    ${lastest_num}   Input product - num - new price - product discount in NH form   ${item_product}    ${item_num}
    \    ...    ${item_newprice}    ${item_dongia}    ${item_discount_prd}    ${lastest_num}
    Log    ${lastest_num}
    Return From Keyword    ${lastest_num}

Input purchase order supplier and payment
    [Arguments]    ${input_ma_ncc}    ${input_cantra_ncc}    ${input_tientra_ncc}
    Wait Until Page Contains Element    ${textbox_nh_ncc}    30s
    Run Keyword If    '${input_tientra_ncc}'=='0'    Input supplier    ${input_ma_ncc}
    ...    ELSE    Input purchase order infor    ${input_ma_ncc}    ${input_cantra_ncc}    ${input_tientra_ncc}

Edit product details in DNH form
    [Arguments]     ${list_pr_edit}    ${list_num_edit}    ${list_newprice_edit}    ${list_discount_edit}    ${list_dongia_edit}   ${list_result_discount_vnd_edit}  ${list_pr}
    : FOR    ${item_pr_edit}    ${item_num_edit}    ${item_newprice_edit}    ${item_discount_prd_edit}    ${item_dongia_edit}   ${item_result_gg}
    ...    IN ZIP    ${list_pr_edit}    ${list_num_edit}    ${list_newprice_edit}    ${list_discount_edit}    ${list_dongia_edit}   ${list_result_discount_vnd_edit}
    \    ${lastest_num}    Get New price from UI    ${cell_dhn_tong_tien_hang}
    \    ${status_add}      Run Keyword And Return Status    List Should Contain Value    ${list_pr}    ${item_pr_edit}
    \    Run Keyword If    '${status_add}'=='False'    Input product - num - new price - product discount in NH form   ${item_pr_edit}    ${item_num_edit}
    \    ...    ${item_newprice_edit}    ${item_dongia_edit}    ${item_discount_prd_edit}    ${lastest_num}
    \    Run Keyword If    '${status_add}'!='False' and '${item_num_edit}'!='0'     Input num - newprice - discount in DHN form      ${item_pr_edit}    ${item_newprice_edit}    ${item_num_edit}    ${lastest_num}
    \    ...    ${item_discount_prd_edit}    ${item_result_gg}    ELSE IF   '${item_num_edit}'=='0'  Remove product frm DHN from    ${item_pr_edit}   ELSE    Log    Ignore

Select list supplier's charge and input value in DHN form
    [Arguments]    ${list_supplier_charge}   ${list_auto}    ${list_supplier_charge_value}    ${tongtien_tru_gg}
    Wait Until Page Contains Element     ${cell_supplier_charge_value}      20s
    Press Key    ${cell_supplier_charge_value}    ${ENTER_KEY}
    Wait Until Page Contains Element    ${checkbox_all_expense}     20s
    :FOR     ${item_cpnh}     ${item_auto}     ${item_supplier_charge_value}     IN ZIP        ${list_supplier_charge}   ${list_auto}     ${list_supplier_charge_value}
    \       ${checkbox_cpnh}      Format String       ${checkbox_dhn_cpnh}      ${item_cpnh}
    \       Run Keyword If    '${item_auto}'=='false'      Wait Until Page Contains Element    ${checkbox_cpnh}     20s
    \       Run Keyword If    '${item_auto}'=='false'      Click Element    ${checkbox_cpnh}
    \       Run Keyword If    '${item_supplier_charge_value}'!='none'    Wait Until Keyword Succeeds    3x    1s   Input value in textbox Chi tren phieu nhap    ${item_cpnh}    ${item_supplier_charge_value}    ${tongtien_tru_gg}
    Sleep    1s
    Click Element    ${button_close_popup_cpnh}

Select list other charge and input value in DHN form
    [Arguments]    ${list_other_charge}   ${list_auto}     ${list_other_charge_value}   ${tongtien_tru_gg}
    Wait Until Page Contains Element     ${cell_other_charge_value}     20s
    Press Key    ${cell_other_charge_value}    ${ENTER_KEY}
    Wait Until Page Contains Element    ${checkbox_all_expense}     20s
    :FOR     ${item_cpnh}     ${item_auto}       ${item_other_charge_value}     IN ZIP        ${list_other_charge}   ${list_auto}    ${list_other_charge_value}
    \       ${checkbox_cpnh}      Format String       ${checkbox_dhn_cpnh}      ${item_cpnh}
    \       Run Keyword If    '${item_auto}'=='false'      Wait Until Page Contains Element    ${checkbox_cpnh}     20s
    \       Run Keyword If    '${item_auto}'=='false'      Click Element       ${checkbox_cpnh}
    \       Run Keyword If    '${item_other_charge_value}'!='none'    Wait Until Keyword Succeeds    3x    1s   Input value in textbox Chi tren phieu nhap    ${item_cpnh}    ${item_other_charge_value}    ${tongtien_tru_gg}
    Sleep    1s
    Click Element    ${button_close_popup_cpnh}
