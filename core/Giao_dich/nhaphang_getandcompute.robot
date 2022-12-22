*** Settings ***
Library           SeleniumLibrary
Library           StringFormat
Library           String
Resource          nhap_hang_list_page.robot
Resource          ../share/computation.robot
Resource          ../share/javascript.robot
Resource          ../API/api_danhmuc_hanghoa.robot
Resource          ../API/api_phieu_nhap_hang.robot
Resource          ../Giao_dich/nhaphang_getandcompute.robot

*** Keywords ***
Get list of total purchase receipt - result onhand in case of price change and have discount
    [Arguments]    ${input_list_product}    ${input_list_num}    ${input_list_newprice}    ${input_list_discount}
    ${list_result_totalsale}    Create list
    ${list_result_newprice}    Create list
    ${list_result_onhand}    Create list
    ${list_result_lastestprice_af}    Create List
    ${get_list_onhand_bf_purchase}    ${get_list_lastprice_bf_purchase}    ${get_list_cost_bf_purchase}    Get list of Onhand, LatestPurchasePrice and Cost frm API    ${input_list_product}
    ${get_list_slphieunhap}    Get list of total import product frm API    ${input_list_product}
    : FOR    ${item_lastprice}    ${item_num}    ${item_discount}    ${item_onhand}    ${item_slphieunhap}    ${item_giavon}
    ...    ${item_newprice}    IN ZIP    ${get_list_lastprice_bf_purchase}    ${input_list_num}    ${input_list_discount}    ${get_list_onhand_bf_purchase}
    ...    ${get_list_slphieunhap}    ${get_list_cost_bf_purchase}    ${input_list_newprice}
    \    ${item_gianhap}    Set Variable If    ${item_slphieunhap} == 0    ${item_giavon}    ${item_lastprice}
    \    ${item_newprice}    Set Variable If    '${item_newprice}'=='none'    ${item_gianhap}    ${item_newprice}
    \    ${result_newprice}    Run Keyword If    0 < ${item_discount} < 100    Price after % discount product    ${item_newprice}    ${item_discount}
    \    ...    ELSE IF    ${item_discount} > 100    Minus    ${item_newprice}    ${item_discount}
    \    ...    ELSE    Set Variable    ${item_newprice}
    \    ${result_totalsale}    Multiplication and round    ${item_num}    ${result_newprice}
    \    ${result_onhand}    Sum    ${item_onhand}    ${item_num}
    \    Append to list    ${list_result_totalsale}    ${result_totalsale}
    \    Append to list    ${list_result_newprice}    ${result_newprice}
    \    Append to list    ${list_result_onhand}    ${result_onhand}
    \    Append to list    ${list_result_lastestprice_af}    ${item_newprice}
    Return From Keyword    ${list_result_totalsale}    ${list_result_newprice}    ${list_result_onhand}    ${list_result_lastestprice_af}

Get list of total purchase receipt - result onhand actual product in case of price change and have discount
    [Arguments]    ${input_list_product}    ${input_list_actualproduct}    ${input_list_num}    ${input_list_newprice}    ${input_list_discount}
    ${list_result_thanhtien_af}    Create list
    ${list_result_newprice_af}    Create list
    ${list_result_onhand_actual_af}    Create list
    ${list_result_onhand_cb_af}    Create list
    ${list_result_lastestprice_af}    Create List
    ${list_actual_num_cb}    Create List
    ${list_result_newprice_cb_af}    Create list
    ${list_result_newprice_bf}    Create List
    ${list_result_discount_vnd}    Create List
    ${get_list_onhand_cb_bf_purchase}    ${get_list_lastprice_cb_bf_purchase}    ${get_list_cost_cb_bf_purchase}    Get list of Onhand, LatestPurchasePrice and Cost frm API    ${input_list_product}
    ${get_list_onhand_actual_bf_purchase}    ${get_list_lastprice_actual_bf_purchase}    ${get_list_cost_actual_bf_purchase}    ${get_list_dvqd}    Get list of Onhand, LastestPurchasePrice and Cost - Conversation values by searching product API    ${input_list_actualproduct}
    ${get_list_slphieunhap_cb}    Get list of total import product frm API    ${input_list_product}
    : FOR   ${item_pr}   ${item_lastprice_cb}    ${item_num_actual}    ${item_discount}    ${item_onhand_cb}    ${item_slphieunhap_cb}    ${item_cost_cb}
    ...    ${item_newprice}    ${item_onhand_actual_bf}    ${item_lastprice_actual_bf}    ${item_dvqd}    IN ZIP    ${input_list_product}   ${get_list_lastprice_cb_bf_purchase}
    ...    ${input_list_num}    ${input_list_discount}    ${get_list_onhand_cb_bf_purchase}    ${get_list_slphieunhap_cb}    ${get_list_cost_cb_bf_purchase}    ${input_list_newprice}
    ...    ${get_list_onhand_actual_bf_purchase}    ${get_list_lastprice_actual_bf_purchase}    ${get_list_dvqd}
    \    ${item_cost_actual}    Multiplication with price round 2    ${item_cost_cb}    ${item_dvqd}
    \    ${item_gianhap}    Run Keyword If    ${item_slphieunhap_cb} == 0    Set Variable    ${item_cost_actual}
    \    ...    ELSE    Set Variable    ${item_lastprice_actual_bf}
    \    ${item_newprice}    Set Variable If    '${item_newprice}'=='none'    ${item_gianhap}    ${item_newprice}
    \    ${result_dis_vnd}    Run Keyword If    0 < ${item_discount} < 100    Convert % discount to VND    ${item_newprice}    ${item_discount}
    \    ...    ELSE    Set Variable    ${item_discount}
    \    ${result_dis_vnd}    Evaluate    round(${result_dis_vnd},2)
    \    ${result_newprice}    Minus and round 2      ${item_newprice}    ${result_dis_vnd}
    \    ${result_newprice_cb}    Devision    ${result_newprice}    ${item_dvqd}
    \    ${result_newprice_cb}    Evaluate    round(${result_newprice_cb}, 2)
    \    ${result_thanhtien}    Multiplication and round    ${item_num_actual}    ${result_newprice}
    \    ${acutal_import_cb}    Multiplication for onhand    ${item_dvqd}    ${item_num_actual}
    \    ${result_onhand_cb}    Sum and round 3   ${acutal_import_cb}    ${item_onhand_cb}
    \    ${result_onhand_actual}    Sum and round 3    ${item_onhand_actual_bf}    ${item_num_actual}
    \    Append to list    ${list_result_thanhtien_af}    ${result_thanhtien}
    \    Append to list    ${list_result_newprice_af}    ${result_newprice}
    \    Append to list    ${list_result_onhand_cb_af}    ${result_onhand_cb}
    \    Append to list    ${list_result_lastestprice_af}    ${item_newprice}
    \    Append to list    ${list_result_onhand_actual_af}    ${result_onhand_actual}
    \    Append To List    ${list_actual_num_cb}    ${acutal_import_cb}
    \    Append To List    ${list_result_newprice_cb_af}    ${result_newprice_cb}
    \    Append To List    ${list_result_newprice_bf}    ${item_newprice}
    \    Append To List    ${list_result_discount_vnd}    ${result_dis_vnd}
    Return From Keyword    ${list_result_thanhtien_af}    ${list_result_newprice_af}    ${list_result_onhand_cb_af}    ${list_result_lastestprice_af}    ${list_result_onhand_actual_af}    ${list_actual_num_cb}
    ...    ${list_result_newprice_cb_af}    ${list_result_newprice_bf}    ${list_result_discount_vnd}

Get list of total - onhand - cost -lastest price incase receipt draft
    [Arguments]    ${input_list_product}    ${input_list_actualproduct}    ${input_list_num}    ${input_list_newprice}    ${input_list_discount}
    ${list_result_thanhtien_af}    Create list
    ${list_result_lastestprice_af}    Create List
    ${get_list_onhand_cb_bf_purchase}    ${get_list_lastprice_cb_bf_purchase}    ${get_list_cost_cb_bf_purchase}    Get list of Onhand, LatestPurchasePrice and Cost frm API    ${input_list_product}
    ${get_list_onhand_actual_bf_purchase}    ${get_list_lastprice_actual_bf_purchase}    ${get_list_cost_actual_bf_purchase}    ${get_list_dvqd}    Get list of Onhand, LastestPurchasePrice and Cost - Conversation values by searching product API    ${input_list_actualproduct}
    ${get_list_slphieunhap_cb}    Get list of total import product frm API    ${input_list_product}
    : FOR        ${item_num_actual}    ${item_discount}        ${item_slphieunhap_cb}    ${item_cost_cb}
    ...    ${item_newprice}        ${item_lastprice_actual_bf}    ${item_dvqd}    IN ZIP
    ...    ${input_list_num}    ${input_list_discount}       ${get_list_slphieunhap_cb}    ${get_list_cost_cb_bf_purchase}    ${input_list_newprice}
    ...    ${get_list_lastprice_actual_bf_purchase}    ${get_list_dvqd}
    \    ${item_cost_actual}    Multiplication with price round 2    ${item_cost_cb}    ${item_dvqd}
    \    ${item_gianhap}    Run Keyword If    ${item_slphieunhap_cb} == 0    Set Variable    ${item_cost_actual}
    \    ...    ELSE    Set Variable    ${item_lastprice_actual_bf}
    \    ${item_newprice}    Set Variable If    '${item_newprice}'=='none'    ${item_gianhap}    ${item_newprice}
    \    ${result_dis_vnd}    Run Keyword If    0 < ${item_discount} < 100    Convert % discount to VND    ${item_newprice}    ${item_discount}
    \    ...    ELSE    Set Variable    ${item_discount}
    \    ${result_dis_vnd}    Evaluate    round(${result_dis_vnd},2)
    \    ${result_newprice}    Minus    ${item_newprice}    ${result_dis_vnd}
    \    ${result_newprice_cb}    Devision    ${result_newprice}    ${item_dvqd}
    \    ${result_newprice_cb}    Evaluate    round(${result_newprice_cb}, 2)
    \    ${result_thanhtien}    Multiplication and round    ${item_num_actual}    ${result_newprice}
    \    Append to list    ${list_result_thanhtien_af}    ${result_thanhtien}
    \    Append to list    ${list_result_lastestprice_af}    ${item_newprice}
    Return From Keyword    ${list_result_thanhtien_af}      ${get_list_onhand_cb_bf_purchase}    ${get_list_cost_cb_bf_purchase}      ${list_result_lastestprice_af}

Get product infor incase purchase
    [Arguments]    ${get_list_newprice}    ${input_list_discount}    ${input_list_num}
    ${list_result_total}    Create list
    ${list_result_newprice}    Create list
    ${list_result_ggsp}    Create List
    : FOR    ${item_num}    ${item_discount}    ${item_newprice}    IN ZIP    ${input_list_num}    ${input_list_discount}
    ...    ${get_list_newprice}
    \    ${result_ggsp}    Run Keyword If    0 <= ${item_discount} <= 100    Convert % discount to VND    ${item_newprice}    ${item_discount}
    \    ...    ELSE    Set Variable    ${item_discount}
    \    ${result_ggsp}    Evaluate    round(${result_ggsp}, 2)
    \    ${result_newprice}    Minus    ${item_newprice}    ${result_ggsp}
    \    ${result_total}    Multiplication and round    ${item_num}    ${result_newprice}
    \    Append to list    ${list_result_total}    ${result_total}
    \    Append to list    ${list_result_newprice}    ${result_newprice}
    \    Append to list    ${list_result_ggsp}    ${result_ggsp}
    Return From Keyword    ${list_result_total}    ${list_result_newprice}    ${list_result_ggsp}

Computation list of cost incase purchase order have discount and price change
    [Arguments]    ${input_list_pr}    ${list_cost}    ${list_onhand}    ${discount}    ${total}
    ${list_cost_new}    Create List
    ${list_cost_prev}    ${list_onhand_prev}    Get list cost - onhand frm API    ${input_list_pr}
    ${get_list_onhand_bf_purchase}    ${get_list_lastestprice_bf_purchase}    ${get_list_cos_bf_purchase}    Get list of Onhand, LatestPurchasePrice and Cost frm API    ${input_list_pr}
    ${list_giatri_quydoi}    Get list gia tri quy doi frm product API    ${input_list_pr}
    ${get_list_slphieunhap}    Get list of total import product frm API    ${input_list_pr}
    : FOR    ${item_pr}     ${item_cost}    ${item_onhand}    ${item_cost_prev}    ${item_ohhand_prev}    ${item_slphieunhap}    ${item_cost_bf}
    ...    ${item_lastestprice}    ${item_dvqd}    IN ZIP    ${input_list_pr}     ${list_cost}    ${list_onhand}    ${list_cost_prev}
    ...    ${list_onhand_prev}    ${get_list_slphieunhap}    ${get_list_cos_bf_purchase}    ${get_list_lastestprice_bf_purchase}    ${list_giatri_quydoi}
    \    ${item_gianhap}    Set Variable If    '${item_slphieunhap}' == '0'    ${item_cost_bf}    ${item_lastestprice}
    \    ${giavon_moi}    Run Keyword If    '${item_cost}'=='none'    Average cost of capital af purchase order have discount    ${item_gianhap}    ${item_onhand}
    \    ...    ${item_cost_prev}    ${item_ohhand_prev}    ${discount}    ${total}   ELSE IF   ${item_onhand}==0   Set Variable     ${item_cost_prev}
    \    ...    ELSE    Average cost of capital af purchase order have discount    ${item_cost}    ${item_onhand}    ${item_cost_prev}
    \    ...    ${item_ohhand_prev}    ${discount}    ${total}
    \    Append To List    ${list_cost_new}    ${giavon_moi}
    Return From Keyword    ${list_cost_new}

Computation list of cost incase purchase order have discount, price change and have expense
    [Arguments]    ${input_list_pr}    ${list_cost}    ${list_onhand}    ${discount}    ${total}    ${expense_value}
    ${list_cost_new}    Create List
    ${list_cost_prev}    ${list_onhand_prev}    Get list cost - onhand frm API    ${input_list_pr}
    ${get_list_onhand_bf_purchase}    ${get_list_lastestprice_bf_purchase}    ${get_list_cos_bf_purchase}    Get list of Onhand, LatestPurchasePrice and Cost frm API    ${input_list_pr}
    ${get_list_slphieunhap}    Get list of total import product frm API    ${input_list_pr}
    : FOR    ${item_pr}   ${item_cost}    ${item_onhand}    ${item_cost_prev}    ${item_ohhand_prev}    ${item_slphieunhap}    ${item_cost_bf}
    ...    ${item_lastestprice}        IN ZIP     ${input_list_pr}     ${list_cost}    ${list_onhand}    ${list_cost_prev}
    ...    ${list_onhand_prev}    ${get_list_slphieunhap}    ${get_list_cos_bf_purchase}    ${get_list_lastestprice_bf_purchase}
    \    ${item_gianhap}    Set Variable If    '${item_slphieunhap}' == '0'    ${item_cost_bf}    ${item_lastestprice}
    \    ${giavon_moi}    Run Keyword If    '${item_cost}'=='none'    Average cost of capital af purchase order have discount and expenses    ${item_gianhap}    ${item_onhand}
    \    ...    ${item_cost_prev}    ${item_ohhand_prev}    ${discount}    ${total}    ${expense_value}   ELSE IF   ${item_onhand}==0   Set Variable     ${item_cost_prev}
    \    ...    ELSE    Average cost of capital af purchase order have discount and expenses    ${item_cost}    ${item_onhand}    ${item_cost_prev}
    \    ...    ${item_ohhand_prev}    ${discount}    ${total}    ${expense_value}
    \    Append To List    ${list_cost_new}    ${giavon_moi}
    Return From Keyword    ${list_cost_new}

Get list onhand after purchase receipt
    [Arguments]    ${input_list_product}    ${so_luong_nhap}
    ${list_result_onhand}    Create list
    ${get_list_onhand_bf_purchase}    Get list onhand frm API    ${input_list_product}
    : FOR    ${item_onhand}    ${item_num}    IN ZIP    ${get_list_onhand_bf_purchase}    ${so_luong_nhap}
    \    ${result_onhand}    Sum    ${item_onhand}    ${item_num}
    \    Append to list    ${list_result_onhand}    ${result_onhand}
    Return From Keyword    ${list_result_onhand}

Computation list price and num of basic product
    [Arguments]    ${get_list_prs}    ${list_price_af_discount}    ${list_num}
    ${get_list_dvqd}    Get list dvqd by list products    ${get_list_prs}
    ${list_price_cb}    Create List
    ${list_num_cb}    Create List
    : FOR    ${item_price}    ${item_num}    ${item_dvqd}    IN ZIP    ${list_price_af_discount}    ${list_num}
    ...    ${get_list_dvqd}
    \    ${price_cb}    Devision    ${item_price}    ${item_dvqd}
    \    ${num_cb}    Multiplication    ${item_num}    ${item_dvqd}
    \    ${price_cb}    Evaluate    round(${price_cb}, 2)
    \    ${num_cb}    Evaluate    round(${num_cb}, 3)
    \    Append To List    ${list_price_cb}    ${price_cb}
    \    Append To List    ${list_num_cb}    ${num_cb}
    Return From Keyword    ${list_price_cb}    ${list_num_cb}

Computation list of cost incase purchase return have discount, price change and have expense
    [Arguments]    ${input_list_pr}    ${list_cost}    ${list_onhand}    ${discount}    ${total}    ${expense_value}
    ${list_cost_new}    Create List
    ${list_cost_prev}    ${list_onhand_prev}    Get list cost - onhand frm API    ${input_list_pr}
    ${get_list_onhand_bf_purchase}    ${get_list_lastestprice_bf_purchase}    ${get_list_cos_bf_purchase}    Get list of Onhand, LatestPurchasePrice and Cost frm API    ${input_list_pr}
    ${get_list_slphieunhap}    Get list of total import product frm API    ${input_list_pr}
    : FOR    ${item_product}    ${item_cost}    ${item_onhand}    ${item_cost_prev}    ${item_ohhand_prev}    ${item_slphieunhap}    ${item_cost_bf}
    ...    ${item_lastestprice}      IN ZIP    ${input_list_pr}   ${list_cost}    ${list_onhand}    ${list_cost_prev}
    ...    ${list_onhand_prev}    ${get_list_slphieunhap}    ${get_list_cos_bf_purchase}    ${get_list_lastestprice_bf_purchase}
    \    ${item_gianhap}    Set Variable If    '${item_slphieunhap}' == '0'    ${item_cost_bf}    ${item_lastestprice}
    \    ${giavon_moi}    Run Keyword If    '${item_cost}'=='none'     Average cost of capital af purchase return    ${item_gianhap}    ${item_onhand}
    \    ...    ${item_cost_prev}    ${item_ohhand_prev}    ${discount}    ${total}    ${expense_value}
    \    ...    ELSE IF   ${item_ohhand_prev}<=0 or ${item_cost_prev}<=0    Set Variable    ${item_cost_bf}     ELSE    Average cost of capital af purchase return    ${item_cost}    ${item_onhand}    ${item_cost_prev}
    \    ...    ${item_ohhand_prev}    ${discount}    ${total}    ${expense_value}
    \    Append To List    ${list_cost_new}    ${giavon_moi}
    Return From Keyword    ${list_cost_new}

Computation list lots onhand of product af receipt
    [Arguments]    ${input_product}    ${input_product_cb}    ${list_tenlo}    ${list_nums}
    ${list_ton_lo_bf}    Get list lots onhand by unit in tab Lo - HSD frm API    ${input_product}    ${list_tenlo}    ${input_product_cb}
    ${list_tonlo_af_ex}    Create List
    : FOR    ${item_num}    ${item_ton_lo_bf}    IN ZIP    ${list_nums}    ${list_ton_lo_bf}
    \    ${result_ton_lo_af_ex}    Sum    ${item_num}    ${item_ton_lo_bf}
    \    Append to list    ${list_tonlo_af_ex}    ${result_ton_lo_af_ex}
    Return From Keyword    ${list_tonlo_af_ex}

Get list of total purchase receipt - result onhand actual product in case of multi row product
    [Arguments]    ${input_list_product}    ${input_list_actualproduct}    ${input_list_num}    ${input_list_newprice}    ${input_list_discount}
    ${list_result_thanhtien_af}    Create list
    ${list_result_newprice_af}    Create list
    ${list_result_onhand_cb_af}    Create list
    ${list_actual_num_cb}    Create List
    ${list_result_giamgia}      Create List
    ${list_result_thanh_tien}    Create list
    ${list_actual_num_cb}    Create List
    ${get_list_onhand_cb_bf_purchase}    Get list onhand frm API    ${input_list_product}
    ${get_list_onhand_actual_bf_purchase}    ${get_list_lastprice_actual_bf_purchase}    ${get_list_cost_actual_bf_purchase}    ${get_list_dvqd}    Get list of Onhand, LastestPurchasePrice and Cost - Conversation values by searching product API    ${input_list_actualproduct}
    ${get_list_slphieunhap_cb}    Get list of total import product frm API    ${input_list_product}
    : FOR    ${item_num_actual}    ${item_discount}    ${item_onhand_cb}    ${item_newprice}    ${item_onhand_actual_bf}    ${item_dvqd}
    ...    IN ZIP    ${input_list_num}    ${input_list_discount}    ${get_list_onhand_cb_bf_purchase}    ${input_list_newprice}    ${get_list_onhand_actual_bf_purchase}
    ...    ${get_list_dvqd}
    \    ${item_newprice}    Convert string to list    ${item_newprice}
    \    ${item_discount}    Convert string to list    ${item_discount}
    \    ${item_num_actual}    Convert string to list    ${item_num_actual}
    \    ${list_giamoi}    ${result_thanhtien}    ${list_giamgia}     ${list_thanhtien}   Computation list result price - total value in case receipt multi row    ${item_num_actual}    ${item_newprice}    ${item_discount}
    \    ${result_num}    Sum values in list    ${item_num_actual}
    \    ${result_num_cb}    Multiplication for onhand    ${item_dvqd}    ${result_num}
    \    ${result_toncuoi_cb}    Sum    ${item_onhand_cb}    ${result_num_cb}
    \    Append to list    ${list_result_thanhtien_af}    ${result_thanhtien}
    \    Append to list    ${list_result_newprice_af}    ${list_giamoi}
    \    Append to list    ${list_result_onhand_cb_af}    ${result_toncuoi_cb}
    \    Append to list    ${list_actual_num_cb}    ${result_num_cb}
    \    Append to list    ${list_result_giamgia}      ${list_giamgia}
    \    Append to list    ${list_result_thanh_tien}      ${list_thanhtien}
    Return From Keyword    ${list_result_thanhtien_af}    ${list_result_newprice_af}    ${list_result_onhand_cb_af}    ${list_actual_num_cb}      ${list_result_giamgia}      ${list_result_thanh_tien}

Get list of total - onhand - cost in case of receipt draft multi row product
    [Arguments]    ${input_list_product}    ${input_list_actualproduct}    ${input_list_num}    ${input_list_newprice}    ${input_list_discount}
    ${list_result_thanhtien_af}    Create list
    ${get_list_cost_cb_bf_purchase}    ${get_list_onhand_cb_bf_purchase}    Get list cost - onhand frm API    ${input_list_product}
    ${get_list_onhand_actual_bf_purchase}    ${get_list_lastprice_actual_bf_purchase}    ${get_list_cost_actual_bf_purchase}    ${get_list_dvqd}    Get list of Onhand, LastestPurchasePrice and Cost - Conversation values by searching product API    ${input_list_actualproduct}
    ${get_list_slphieunhap_cb}    Get list of total import product frm API    ${input_list_product}
    : FOR    ${item_num_actual}    ${item_discount}      ${item_newprice}      ${item_dvqd}
    ...    IN ZIP    ${input_list_num}    ${input_list_discount}     ${input_list_newprice}     ${get_list_dvqd}
    \    ${item_newprice}    Convert string to list    ${item_newprice}
    \    ${item_discount}    Convert string to list    ${item_discount}
    \    ${item_num_actual}    Convert string to list    ${item_num_actual}
    \    ${list_giamoi}    ${result_thanhtien}    ${list_giamgia}     ${list_thanhtien}   Computation list result price - total value in case receipt multi row    ${item_num_actual}    ${item_newprice}    ${item_discount}
    \    Append to list    ${list_result_thanhtien_af}    ${result_thanhtien}
    Return From Keyword    ${list_result_thanhtien_af}    ${get_list_onhand_cb_bf_purchase}    ${get_list_cost_cb_bf_purchase}

Computation list result price - total value in case receipt multi row
    [Arguments]    ${list_nums}    ${list_newprice}    ${list_discount}
    ${list_giamoi}    Create List
    ${list_giamgia}     Create List
    : FOR    ${item_newprice}    ${item_discount}    IN ZIP    ${list_newprice}    ${list_discount}
    \    ${result_giamgia}    Run Keyword If    0 < ${item_discount} < 100    Convert % discount to VND and round       ${item_newprice}    ${item_discount}    ELSE      Set Variable    ${item_discount}
    \    ${result_giamoi}    Minus and replace floating point    ${item_newprice}    ${result_giamgia}
    \    Append To List    ${list_giamgia}    ${result_giamgia}
    \    Append To List    ${list_giamoi}    ${result_giamoi}
    Log    ${list_giamoi}
    ${list_thanhtien}    Create List
    : FOR    ${item_num}    ${item_giamoi}    IN ZIP    ${list_nums}    ${list_giamoi}
    \    ${thanhtien}    Multiplication and round    ${item_num}    ${item_giamoi}
    \    Append To List    ${list_thanhtien}    ${thanhtien}
    Log       ${list_giamoi}
    ${result_thanhtien}    Sum values in list    ${list_thanhtien}
    Return From Keyword        ${list_giamoi}    ${result_thanhtien}      ${list_giamgia}     ${list_thanhtien}

Computation list of cost incase purchase receipt multi row
    [Arguments]    ${input_list_pr}     ${input_list_pr_cb}    ${list_dongia}    ${input_tong_cpnh}    ${input_ggpn}    ${input_tongtienhang}    ${list_num}
    ${list_cost_new}    Create List
    ${list_cost_prev}    ${list_onhand_prev}    Get list cost - onhand frm API    ${input_list_pr_cb}
    ${list_giatri_quydoi}    Get list gia tri quy doi frm product API    ${input_list_pr}
    : FOR    ${item_cost_prev}    ${item_ohhand_prev}    ${item_dvqd}    ${item_dongia}    ${item_num}    IN ZIP
    ...    ${list_cost_prev}    ${list_onhand_prev}    ${list_giatri_quydoi}    ${list_dongia}    ${list_num}
    \    ${item_num}    Convert string to list    ${item_num}
    \    ${giavon_pb}    Computation cost of capital allocated incase purchase receipt multi row    ${item_dongia}    ${input_tong_cpnh}    ${input_ggpn}    ${input_tongtienhang}
    \    ...    ${item_num}
    \    ${giavon_pb_cb}    Devision    ${giavon_pb}    ${item_dvqd}
    \    ${result_num}    Sum values in list    ${item_num}
    \    ${result_num_cb}    Multiplication    ${result_num}    ${item_dvqd}
    \    ${result_cost}    Average Cost Of Capital    ${giavon_pb_cb}    ${result_num_cb}    ${item_cost_prev}    ${item_ohhand_prev}
    \    ...    2
    \    Append To List    ${list_cost_new}    ${result_cost}
    Return From Keyword    ${list_cost_new}

Computation cost of capital allocated incase purchase receipt multi row
    [Arguments]    ${list_dongia}    ${input_tong_cpnh}    ${input_ggpn}    ${input_tongtienhang}    ${list_num}
    ${list_gianhap_phanbo_by_row}    Create List
    :FOR    ${item_dongia}    IN ZIP    ${list_dongia}
    \    ${item_gianhap}    Average cost of capital allocated after purchase receipt    ${item_dongia}    ${input_tong_cpnh}    ${input_ggpn}    ${input_tongtienhang}
    \    Append to list    ${list_gianhap_phanbo_by_row}    ${item_gianhap}
    Log    ${list_gianhap_phanbo_by_row}
    ${list_gianhap_pb}    Create List
    :FOR     ${item_gn_pb}    ${item_num}    IN ZIP    ${list_gianhap_phanbo_by_row}    ${list_num}
    \    ${item_gianhap_pb}    Multiplication    ${item_gn_pb}    ${item_num}
    \    Append to list    ${list_gianhap_pb}    ${item_gianhap_pb}
    Log    ${list_gianhap_pb}
    ${gianhap_pb}    Sum values in list    ${list_gianhap_pb}
    ${total_num}    Sum values in list    ${list_num}
    ${gianhap_pb}    Devision    ${gianhap_pb}    ${total_num}
    ${gianhap_pb}    Evaluate    round(${gianhap_pb},2)
    Return From Keyword    ${gianhap_pb}

Computation list of cost incase purchase return multi row
    [Arguments]    ${input_list_pr}     ${input_list_pr_cb}    ${list_dongia}    ${input_tong_cpnh}    ${input_ggpn}    ${input_tongtienhang}    ${list_num}
    ${list_cost_new}    Create List
    ${list_cost_prev}    ${list_onhand_prev}    Get list cost - onhand frm API    ${input_list_pr_cb}
    ${list_giatri_quydoi}    Get list gia tri quy doi frm product API    ${input_list_pr}
    : FOR    ${item_pr_cb}    ${item_cost_prev}    ${item_ohhand_prev}    ${item_dvqd}    ${item_dongia}    ${item_num}    IN ZIP
    ...    ${input_list_pr_cb}    ${list_cost_prev}    ${list_onhand_prev}    ${list_giatri_quydoi}    ${list_dongia}    ${list_num}
    \    ${item_num}    Convert string to list    ${item_num}
    \    ${giavon_pb}    Computation cost of capital allocated incase purchase receipt multi row    ${item_dongia}    ${input_tong_cpnh}    ${input_ggpn}    ${input_tongtienhang}
    \    ...    ${item_num}
    \    ${giavon_pb_cb}    Devision    ${giavon_pb}    ${item_dvqd}
    \    ${result_num}    Sum values in list    ${item_num}
    \    ${result_num_cb}    Multiplication    ${result_num}    ${item_dvqd}
    \    ${result_cost}    Average Cost Of Capital Minus     ${giavon_pb_cb}    ${result_num_cb}    ${item_cost_prev}    ${item_ohhand_prev}
    \    ...    2
    \    ${result_cost}     Set Variable If    ${item_ohhand_prev}<0    ${item_cost_prev}   ${result_cost}
    \    Append To List    ${list_cost_new}    ${result_cost}
    Return From Keyword    ${list_cost_new}

Conputation total, discount and pay for supplier
    [Arguments]   ${list_result_thanhtien}      ${input_nh_discount}      ${input_tientrancc}
    ${result_tongtienhang}    Sum values in list    ${list_result_thanhtien}
    ${result_discount_nh}    Run Keyword If    0 < ${input_nh_discount} < 100    Convert % discount to VND and round    ${result_tongtienhang}    ${input_nh_discount}
    ...    ELSE    Set Variable    ${input_nh_discount}
    ${result_cantrancc}    Minus    ${result_tongtienhang}      ${result_discount_nh}
    ${actual_tientrancc}    Set Variable If    '${input_tientrancc}'=='all'    ${result_cantrancc}    ${input_tientrancc}
    ${actual_tientrancc}    Run Keyword If    '${input_tientrancc}'=='all'    Replace floating point    ${actual_tientrancc}
    ...    ELSE    Set Variable    ${input_tientrancc}
    Return From Keyword    ${result_tongtienhang}      ${result_discount_nh}      ${result_cantrancc}     ${actual_tientrancc}

Conputation total, discount and pay for supplier in case have expense value
    [Arguments]   ${list_result_thanhtien}      ${input_nh_discount}      ${input_tientrancc}   ${list_supplier_charge_defaul}     ${list_other_charge_defaul}    ${list_supplier_charge_value}     ${list_other_charge_value}
    ${result_tongtienhang}    Sum values in list    ${list_result_thanhtien}
    ${result_discount_nh}    Run Keyword If    0 < ${input_nh_discount} < 100    Convert % discount to VND and round    ${result_tongtienhang}    ${input_nh_discount}
    ...    ELSE    Set Variable    ${input_nh_discount}
    ${result_tongtien_tru_gg}       Minus     ${result_tongtienhang}      ${result_discount_nh}
    ${total_expense_value}   ${total_supplier_charge}    ${total_other_charge}    Computation total expense charge   ${list_supplier_charge_defaul}      ${list_other_charge_defaul}     ${list_supplier_charge_value}    ${list_other_charge_value}  ${result_tongtien_tru_gg}
    ${result_cantrancc}    Sum      ${result_tongtien_tru_gg}       ${total_supplier_charge}
    ${actual_tientrancc}    Set Variable If    '${input_tientrancc}'=='all'    ${result_cantrancc}    ${input_tientrancc}
    ${actual_tientrancc}    Run Keyword If    '${input_tientrancc}'=='all'    Replace floating point    ${actual_tientrancc}
    ...    ELSE    Set Variable    ${input_tientrancc}
    Return From Keyword    ${result_tongtienhang}      ${result_discount_nh}   ${result_tongtien_tru_gg}     ${result_cantrancc}     ${actual_tientrancc}     ${total_expense_value}   ${total_supplier_charge}    ${total_other_charge}

Computation total, discount and pay for supplier incase return no apllocate discount
    [Arguments]   ${list_result_thanhtien}      ${input_nh_discount}      ${input_tongtienhang_nh}   ${input_tienncc_tra}
    ${result_tongtienhang}    Sum values in list and round       ${list_result_thanhtien}
    ${result_discount_thn}   Price after apllocate discount and round       ${input_nh_discount}    ${input_tongtienhang_nh}    ${result_tongtienhang}
    ${result_ncc_cantra}    Minus    ${result_tongtienhang}      ${result_discount_thn}
    ${actual_tienncc_tra}    Set Variable If    '${input_tienncc_tra}'=='all'    ${result_ncc_cantra}    ${input_tienncc_tra}
    ${actual_tienncc_tra}    Run Keyword If    '${input_tienncc_tra}'=='all'    Replace floating point    ${actual_tienncc_tra}
    ...    ELSE    Set Variable    ${input_tienncc_tra}
    Return From Keyword    ${result_tongtienhang}      ${result_discount_thn}      ${result_ncc_cantra}     ${actual_tienncc_tra}

Computation total, discount and pay for supplier incase return have supplier charge
    [Arguments]   ${list_result_thanhtien}      ${input_nh_discount}      ${input_tongtienhang_nh}   ${input_tienncc_tra}   ${list_supplier_charge_defaul}     ${list_supplier_charge_value}
    ${result_tongtienhang}    Sum values in list and round       ${list_result_thanhtien}
    ${result_discount_thn}   Price after apllocate discount and round       ${input_nh_discount}    ${input_tongtienhang_nh}    ${result_tongtienhang}
    ${result_tongtien_tru_gg}    Minus    ${result_tongtienhang}      ${result_discount_thn}
    ${total_supplier_charge}    Computation total supplier charge   ${list_supplier_charge_defaul}    ${list_supplier_charge_value}   ${result_tongtien_tru_gg}
    ${result_ncc_cantra}    Sum      ${result_tongtien_tru_gg}       ${total_supplier_charge}
    ${actual_tienncc_tra}    Set Variable If    '${input_tienncc_tra}'=='all'    ${result_ncc_cantra}    ${input_tienncc_tra}
    ${actual_tienncc_tra}    Run Keyword If    '${input_tienncc_tra}'=='all'    Replace floating point    ${actual_tienncc_tra}
    ...    ELSE    Set Variable    ${input_tienncc_tra}
    Return From Keyword    ${result_tongtienhang}      ${result_discount_thn}    ${result_tongtien_tru_gg}    ${result_ncc_cantra}     ${actual_tienncc_tra}    ${total_supplier_charge}

Conputation total, discount and pay for supplier in case supplier charge value
    [Arguments]   ${list_result_thanhtien}      ${input_nh_discount}      ${input_tientrancc}   ${list_supplier_charge_defaul}     ${list_supplier_charge_value}
    ${result_tongtienhang}    Sum values in list    ${list_result_thanhtien}
    ${result_discount_nh}    Run Keyword If    0 < ${input_nh_discount} < 100    Convert % discount to VND and round    ${result_tongtienhang}    ${input_nh_discount}
    ...    ELSE    Set Variable    ${input_nh_discount}
    ${result_tongtien_tru_gg}       Minus     ${result_tongtienhang}      ${result_discount_nh}
    ${total_supplier_charge}    Computation total supplier charge   ${list_supplier_charge_defaul}    ${list_supplier_charge_value}   ${result_tongtien_tru_gg}
    ${result_cantrancc}    Sum      ${result_tongtien_tru_gg}       ${total_supplier_charge}
    ${actual_tientrancc}    Set Variable If    '${input_tientrancc}'=='all'    ${result_cantrancc}    ${input_tientrancc}
    ${actual_tientrancc}    Run Keyword If    '${input_tientrancc}'=='all'    Replace floating point    ${actual_tientrancc}
    ...    ELSE    Set Variable    ${input_tientrancc}
    Return From Keyword    ${result_tongtienhang}      ${result_discount_nh}   ${result_tongtien_tru_gg}     ${result_cantrancc}     ${actual_tientrancc}     ${total_supplier_charge}
