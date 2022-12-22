*** Settings ***
Library           SeleniumLibrary
Resource          tra_hang_page.robot
Resource          ../share/constants.robot
Resource          ../share/javascript.robot
Resource          ../share/computation.robot
Resource          tra_hang_popup_page.robot
Resource          ../API/api_danhmuc_hanghoa.robot

*** Keywords ***
Computation incase discount and get total sale - endingstock - cost with additional invoice
    [Arguments]    ${input_product}    ${input_nums}    ${input_ggsp}    ${input_price}    ${input_onhand}    ${get_product_type}
    ...    ${get_toncuoi_dv_execute}
    ${result_giamoi}    Run Keyword If    0 < ${input_ggsp} < 100    Price after % discount product    ${input_price}    ${input_ggsp}
    ...    ELSE    Minus and round 2    ${input_price}    ${input_ggsp}
    ${result_thanhtien}    Multiplication and round    ${result_giamoi}    ${input_nums}
    ${result_toncuoi_hht}    Minus    ${input_onhand}    ${input_nums}
    ${result_toncuoi_dv}    Minus    ${get_toncuoi_dv_execute}    ${input_nums}
    ${result_toncuoi_cb}    Set Variable If    '${get_product_type}' == '1'    0
    ${result_toncuoi_bf}    Set Variable If    '${get_product_type}' == '2'    ${result_toncuoi_hht}    ${result_toncuoi_dv}
    ${result_toncuoi}    Set Variable If    '${get_product_type}' == '1'    ${result_toncuoi_cb}    ${result_toncuoi_bf}
    Return From Keyword    ${result_thanhtien}    ${result_toncuoi}

Computation incase discount and get total sale - endingstock - cost for unit product with additional invoice
    [Arguments]    ${input_product}    ${input_nums}    ${input_ggsp}    ${input_price}    ${get_giatri_quydoi}
    ${get_ma_hh_cb}    Get basic product frm unit product    ${input_product}
    ${ton_cuoi_cb}    Get onhand frm API    ${get_ma_hh_cb}
    ${result_soluongban}    Multiplication with price round 2    ${input_nums}    ${get_giatri_quydoi}
    ${result_toncuoi}    Minus    ${ton_cuoi_cb}    ${result_soluongban}
    ${result_giamoi}    Run Keyword If    0 < ${input_ggsp} < 100    Price after % discount product    ${input_price}    ${input_ggsp}
    ...    ELSE    Minus and round 2    ${input_price}    ${input_ggsp}
    ${result_thanhtien}    Multiplication and round    ${result_giamoi}    ${input_nums}
    Return From Keyword    ${result_thanhtien}    ${result_toncuoi}

Computation incase newprice and get total sale - endingstock - cost frm API with additional invoice
    [Arguments]    ${input_product}    ${input_nums}    ${input_newprice}    ${input_onhand}    ${get_product_type}    ${get_toncuoi_dv_execute}
    ${result_thanhtien_newprice}    Multiplication and round    ${input_newprice}    ${input_nums}
    ${result_toncuoi_hht}    Minus    ${input_onhand}    ${input_nums}
    ${result_toncuoi_dv}    Minus    ${get_toncuoi_dv_execute}    ${input_nums}
    ${result_toncuoi_cb}    Set Variable If    '${get_product_type}' == '1'    0
    ${result_toncuoi_bf}    Set Variable If    '${get_product_type}' == '2'    ${result_toncuoi_hht}    ${result_toncuoi_dv}
    ${result_toncuoi}    Set Variable If    '${get_product_type}' == '1'    ${result_toncuoi_cb}    ${result_toncuoi_bf}
    Return From Keyword    ${result_thanhtien_newprice}    ${result_toncuoi}

Computation incase newprice and get total sale - endingstock - cost for unit product with additional invoice
    [Arguments]    ${input_product}    ${input_nums}    ${input_newprice}    ${input_onhand}    ${get_giatri_quydoi}
    ${get_ma_hh_cb}    Get basic product frm unit product    ${input_product}
    ${ton_cuoi_cb}    Get onhand frm API    ${get_ma_hh_cb}
    ${result_soluongban}    Multiplication    ${input_nums}    ${get_giatri_quydoi}
    ${result_toncuoi}    Minus    ${ton_cuoi_cb}    ${result_soluongban}
    ${result_thanhtien_newprice}    Multiplication and round    ${input_newprice}    ${input_nums}
    Return From Keyword    ${result_thanhtien_newprice}    ${result_toncuoi}

Get list total sale - endingstock - cost incase newprice with additional invoice
    [Arguments]    ${list_product}    ${list_nums}    ${list_newprice}
    ${list_result_thanhtien_newprice}    Create List
    ${list_result_toncuoi}    Create List
    ${get_list_giaban}    ${get_list_giavon}    ${get_list_ton}    ${list_giatri_quydoi}    Get list base price - cost - onhand - gia tri quy doi frm API    ${list_product}
    ${list_product_type}    ${list_tonkho_service}    Get list product type and ending stock of service frm API    ${list_product}
    : FOR    ${item_product}    ${item_nums}    ${item_newprice}    ${item_onhand}    ${get_giatri_quydoi}    ${get_product_type}
    ...    ${get_toncuoi_dv_execute}    IN ZIP    ${list_product}    ${list_nums}    ${list_newprice}    ${get_list_ton}
    ...    ${list_giatri_quydoi}    ${list_product_type}    ${list_tonkho_service}
    \    ${result_thanhtien_newprice}    ${result_toncuoi}    Run Keyword If    '${get_giatri_quydoi}' == '1'    Computation incase newprice and get total sale - endingstock - cost frm API with additional invoice    ${item_product}
    \    ...    ${item_nums}    ${item_newprice}    ${item_onhand}    ${get_product_type}    ${get_toncuoi_dv_execute}
    \    ...    ELSE    Computation incase newprice and get total sale - endingstock - cost for unit product with additional invoice    ${item_product}    ${item_nums}    ${item_newprice}
    \    ...    ${item_onhand}    ${get_giatri_quydoi}
    \    Append to list    ${list_result_thanhtien_newprice}    ${result_thanhtien_newprice}
    \    Append to list    ${list_result_toncuoi}    ${result_toncuoi}
    Return From Keyword    ${list_result_thanhtien_newprice}    ${get_list_giavon}    ${list_result_toncuoi}

Get list total sale - endingstock - cost incase discount with additional invoice
    [Arguments]    ${list_product}    ${list_nums}    ${list_ggsp}
    ${list_result_thanhtien}    Create List
    ${list_result_toncuoi}    Create List
    ${get_list_giaban}    ${get_list_giavon}    ${get_list_ton}    ${list_giatri_quydoi}    Get list base price - cost - onhand - gia tri quy doi frm API    ${list_product}
    ${list_product_type}    ${list_tonkho_service}    Get list product type and ending stock of service frm API    ${list_product}
    : FOR    ${item_product}    ${item_nums}    ${item_ggsp}    ${item_price}    ${item_onhand}    ${get_giatri_quydoi}
    ...    ${get_product_type}    ${get_toncuoi_dv_execute}    IN ZIP    ${list_product}    ${list_nums}    ${list_ggsp}
    ...    ${get_list_giaban}    ${get_list_ton}    ${list_giatri_quydoi}    ${list_product_type}    ${list_tonkho_service}
    \    ${result_thanhtien}    ${result_toncuoi}    Run Keyword If    '${get_giatri_quydoi}' == '1'    Computation incase discount and get total sale - endingstock - cost with additional invoice    ${item_product}
    \    ...    ${item_nums}    ${item_ggsp}    ${item_price}    ${item_onhand}    ${get_product_type}
    \    ...    ${get_toncuoi_dv_execute}
    \    ...    ELSE    Computation incase discount and get total sale - endingstock - cost for unit product with additional invoice    ${item_product}    ${item_nums}    ${item_ggsp}
    \    ...    ${item_price}    ${get_giatri_quydoi}
    \    Append to list    ${list_result_thanhtien}    ${result_thanhtien}
    \    Append to list    ${list_result_toncuoi}    ${result_toncuoi}
    Return From Keyword    ${list_result_thanhtien}    ${get_list_giavon}    ${list_result_toncuoi}

Assert value cost and onhand in Stock Card additional invoice
    [Arguments]    ${item_cost_af_ex}    ${item_ton_af_ex}    ${item_cost}    ${item_ton}
    Should Be Equal As Numbers    ${item_cost_af_ex}    ${item_cost}
    Should Be Equal As Numbers    ${item_ton_af_ex}    ${item_ton}

Assert value cost and onhand in unit Stock Card additional invoice
    [Arguments]    ${input_ma_hh}    ${item_cost}    ${item_ton}
    ${get_ma_hh_cb}    Get basic product frm unit product    ${input_ma_hh}
    ${get_ton_af_ex}    ${get_cost_af_ex}    Get Cost and OnHand frm API    ${get_ma_hh_cb}
    Should Be Equal As Numbers    ${get_cost_af_ex}    ${item_cost}
    Should Be Equal As Numbers    ${get_ton_af_ex}    ${item_ton}

Get list total sale - endingstock - cost incase changing product price with additional invoice
    [Arguments]    ${list_product}    ${list_nums}    ${list_change}    ${list_change_type}
    ${list_result_thanhtien}    Create List
    ${list_result_toncuoi}    Create List
    ${get_list_giaban}    ${get_list_giavon}    ${get_list_ton}    ${list_giatri_quydoi}    Get list base price - cost - onhand - gia tri quy doi frm API    ${list_product}
    ${list_product_type}    ${list_tonkho_service}    Get list product type and ending stock of service frm API    ${list_product}
    : FOR    ${item_product}    ${item_nums}    ${item_change}    ${item_price}    ${item_onhand}    ${get_giatri_quydoi}
    ...    ${get_product_type}    ${get_toncuoi_dv_execute}    ${item_change_type}    IN ZIP    ${list_product}    ${list_nums}
    ...    ${list_change}    ${get_list_giaban}    ${get_list_ton}    ${list_giatri_quydoi}    ${list_product_type}    ${list_tonkho_service}
    ...    ${list_change_type}
    \    ${result_thanhtien}    ${result_toncuoi}    Run Keyword If    '${get_giatri_quydoi}' == '1' and '${item_change_type}' == 'dis'    Computation incase discount and get total sale - endingstock - cost with additional invoice    ${item_product}
    \    ...    ${item_nums}    ${item_change}    ${item_price}    ${item_onhand}    ${get_product_type}
    \    ...    ${get_toncuoi_dv_execute}
    \    ...    ELSE IF    '${get_giatri_quydoi}' != '1' and '${item_change_type}' == 'dis'    Computation incase discount and get total sale - endingstock - cost for unit product with additional invoice    ${item_product}    ${item_nums}
    \    ...    ${item_change}    ${item_price}    ${get_giatri_quydoi}
    \    ...    ELSE IF    '${get_giatri_quydoi}' == '1' and '${item_change_type}' == 'change'    Computation incase newprice and get total sale - endingstock - cost frm API with additional invoice    ${item_product}    ${item_nums}
    \    ...    ${item_change}    ${item_onhand}    ${get_product_type}    ${get_toncuoi_dv_execute}
    \    ...    ELSE    Computation incase newprice and get total sale - endingstock - cost for unit product with additional invoice    ${item_product}    ${item_nums}    ${item_change}
    \    ...    ${item_onhand}    ${get_giatri_quydoi}
    \    Append to list    ${list_result_thanhtien}    ${result_thanhtien}
    \    Append to list    ${list_result_toncuoi}    ${result_toncuoi}
    Return From Keyword    ${list_result_thanhtien}    ${get_list_giavon}    ${list_result_toncuoi}

Get list total sale - endingstock - cost incase changing product price with additional multi row invoice
    [Arguments]    ${list_product}    ${list_nums}    ${list_change}    ${list_change_type}
    ${list_result_thanhtien}    Create List
    ${list_result_toncuoi}    Create List
    ${get_list_giaban}    ${get_list_giavon}    ${get_list_ton}    ${list_giatri_quydoi}    Get list base price - cost - onhand - gia tri quy doi frm API    ${list_product}
    ${list_product_type}    ${list_tonkho_service}    Get list product type and ending stock of service frm API    ${list_product}
    : FOR    ${item_product}    ${item_nums}    ${item_change}    ${item_price}    ${item_onhand}    ${get_giatri_quydoi}
    ...    ${get_product_type}    ${get_toncuoi_dv_execute}    ${item_change_type}    IN ZIP    ${list_product}    ${list_nums}
    ...    ${list_change}    ${get_list_giaban}    ${get_list_ton}    ${list_giatri_quydoi}    ${list_product_type}    ${list_tonkho_service}
    ...    ${list_change_type}
    \    ${item_nums}    Convert To String    ${item_nums}
    \    ${item_change}    Convert To String    ${item_change}
    \    ${item_change_type}    Convert To String    ${item_change_type}
    \    ${item_nums}    Split String    ${item_nums}    ,
    \    ${item_change}    Split String    ${item_change}    ,
    \    ${item_change_type}    Split String    ${item_change_type}    ,
    \    ${result_thanhtien}    ${result_toncuoi}    Run Keyword If    '${get_giatri_quydoi}' == '1'    Computation incase changing and get total sale - endingstock - cost with additional multi row invoice    ${item_product}
    \    ...    ${item_nums}    ${item_change}    ${item_change_type}    ${item_price}    ${item_onhand}
    \    ...    ${get_product_type}    ${get_toncuoi_dv_execute}
    \    ...    ELSE    Computation incase changing and get total sale - endingstock - cost for unit product with additiona multi rowl invoice    ${item_product}    ${item_nums}    ${item_change}
    \    ...    ${item_change_type}    ${item_price}    ${get_giatri_quydoi}
    \    Append to list    ${list_result_thanhtien}    ${result_thanhtien}
    \    Append to list    ${list_result_toncuoi}    ${result_toncuoi}
    Return From Keyword    ${list_result_thanhtien}    ${get_list_giavon}    ${list_result_toncuoi}

Computation incase changing and get total sale - endingstock - cost with additional multi row invoice
    [Arguments]    ${input_product}    ${list_nums}    ${list_change}    ${list_change_type}    ${input_price}    ${input_onhand}
    ...    ${get_product_type}    ${get_toncuoi_dv_execute}
    ${list_giamoi}    Create List
    : FOR    ${item_change}    ${item_change_type}    IN ZIP    ${list_change}    ${list_change_type}
    \    ${result_giamoi}    Run Keyword If    0 < ${item_change} < 100 and '${item_change_type}'=='dis'    Price after % discount product    ${input_price}    ${item_change}
    \    ...    ELSE IF    ${item_change} > 100 and '${item_change_type}'=='dis'    Minus and replace floating point    ${input_price}    ${item_change}
    \    ...    ELSE IF    '${item_change_type}'=='change'    Set Variable    ${item_change}
    \    ...    ELSE    Set Variable    ${input_price}
    \    Append To List    ${list_giamoi}    ${result_giamoi}
    Log    ${list_giamoi}
    ${result_num}    Sum values in list    ${list_nums}
    ${result_toncuoi_hht}    Minus    ${input_onhand}    ${result_num}
    ${result_toncuoi_dv}    Minus    ${get_toncuoi_dv_execute}    ${result_num}
    ${result_toncuoi_bf}    Set Variable If    '${get_product_type}' == '2'    ${result_toncuoi_hht}    ${result_toncuoi_dv}
    ${result_toncuoi}    Set Variable If    '${get_product_type}' == '1' or '${get_product_type}' == '3'    0    ${result_toncuoi_bf}
    ${list_thanhtien}    Create List
    : FOR    ${item_num}    ${item_giamoi}    IN ZIP    ${list_nums}    ${list_giamoi}
    \    ${thanhtien}    Multiplication and round    ${item_num}    ${item_giamoi}
    \    Append To List    ${list_thanhtien}    ${thanhtien}
    ${result_thanhtien}    Sum values in list    ${list_thanhtien}
    Return From Keyword    ${result_thanhtien}    ${result_toncuoi}

Computation incase changing and get total sale - endingstock - cost for unit product with additiona multi rowl invoice
    [Arguments]    ${input_product}    ${list_num}    ${list_change}    ${list_change_type}    ${input_price}    ${get_giatri_quydoi}
    ${get_ma_hh_cb}    Get basic product frm unit product    ${input_product}
    ${ton_cuoi_cb}    Get onhand frm API    ${get_ma_hh_cb}
    ${result_num}    Sum values in list    ${list_num}
    ${result_soluongban}    Multiplication with price round 2    ${result_num}    ${get_giatri_quydoi}
    ${result_toncuoi}    Minus    ${ton_cuoi_cb}    ${result_soluongban}
    ${list_thanhtien}    Create List
    : FOR    ${item_num}    ${item_change}    ${item_change_type}    IN ZIP    ${list_num}    ${list_change}
    ...    ${list_change_type}
    \    ${result_giamoi}    Run Keyword If    0 < ${item_change} < 100 and '${item_change_type}'=='dis'    Price after % discount product    ${input_price}    ${item_change}
    \    ...    ELSE IF    ${item_change} > 100 and '${item_change_type}'=='dis'    Minus and replace floating point    ${input_price}    ${item_change}
    \    ...    ELSE IF    '${item_change_type}'=='change'    Set Variable    ${item_change}
    \    ...    ELSE    Set Variable    ${input_price}
    \    ${thanhtien}    Multiplication and round    ${result_giamoi}    ${item_num}
    \    Append To List    ${list_thanhtien}    ${thanhtien}
    Log    ${list_thanhtien}
    ${result_thanhtien}    Sum values in list    ${list_thanhtien}
    Return From Keyword    ${result_thanhtien}    ${result_toncuoi}

## gộp chung discount and newprice
Get total sale - endingstock - cost incase discount additional invoice
    [Arguments]    ${input_product}    ${input_nums}    ${input_ggsp}    ${input_price}    ${input_onhand}    ${get_product_type}
    ...    ${get_toncuoi_dv_execute}    ${discount_type}
    ${result_giamoi}    Run Keyword If    '${discount_type}' == 'dis'     Price after % discount product    ${input_price}    ${input_ggsp}
    ...    ELSE IF    '${discount_type}' == 'disvnd'    Minus and round 2        ${input_price}    ${input_ggsp}
    ...    ELSE IF    '${discount_type}' == 'changeup' or '${discount_type}' == 'changedown'  Set Variable   ${input_ggsp}    ELSE    Set Variable    ${input_price}
    ${result_thanhtien}    Multiplication and round    ${result_giamoi}    ${input_nums}
    ${result_toncuoi_hht}    Minus    ${input_onhand}    ${input_nums}
    ${result_toncuoi_dv}    Minus    ${get_toncuoi_dv_execute}    ${input_nums}
    ${result_toncuoi_cb}    Set Variable If    '${get_product_type}' == '1'    0
    ${result_toncuoi_bf}    Set Variable If    '${get_product_type}' == '2'    ${result_toncuoi_hht}    ${result_toncuoi_dv}
    ${result_toncuoi}    Set Variable If    '${get_product_type}' == '1'    ${result_toncuoi_cb}    ${result_toncuoi_bf}
    Return From Keyword    ${result_thanhtien}    ${result_toncuoi}

Get total sale - endingstock - cost incase unit and discount additional invoice
    [Arguments]    ${input_product}    ${input_nums}    ${input_ggsp}    ${input_price}    ${get_giatri_quydoi}    ${discount_type}
    ${get_ma_hh_cb}    Get basic product frm unit product    ${input_product}
    ${ton_cuoi_cb}    Get onhand frm API    ${get_ma_hh_cb}
    ${result_soluongban}    Multiplication with price round 2    ${input_nums}    ${get_giatri_quydoi}
    ${result_toncuoi}    Minus    ${ton_cuoi_cb}    ${result_soluongban}
    ${result_giamoi}    Run Keyword If    '${discount_type}' == 'dis'     Price after % discount product    ${input_price}    ${input_ggsp}
    ...    ELSE IF    '${discount_type}' == 'disvnd'    Minus and round 2        ${input_price}    ${input_ggsp}
    ...    ELSE IF    '${discount_type}' == 'changeup' or '${discount_type}' == 'changedown'  Set Variable   ${input_ggsp}    ELSE    Set Variable    ${input_price}
    ${result_thanhtien}    Multiplication and round    ${result_giamoi}    ${input_nums}
    Return From Keyword    ${result_thanhtien}    ${result_toncuoi}

Get list total sale - endingstock - cost incase discount and newprice with additional invoice
    [Arguments]    ${list_product}    ${list_nums}    ${list_ggsp}   ${list_discount_type}
    ${list_result_thanhtien}    Create List
    ${list_result_toncuoi}    Create List
    ${get_list_giaban}    ${get_list_giavon}    ${get_list_ton}    ${list_giatri_quydoi}    Get list base price - cost - onhand - gia tri quy doi frm API    ${list_product}
    ${list_product_type}    ${list_tonkho_service}    Get list product type and ending stock of service frm API    ${list_product}
    : FOR    ${item_product}    ${item_nums}    ${item_ggsp}    ${item_price}    ${item_onhand}    ${get_giatri_quydoi}
    ...    ${get_product_type}    ${get_toncuoi_dv_execute}   ${item_discount_type}    IN ZIP    ${list_product}    ${list_nums}    ${list_ggsp}
    ...    ${get_list_giaban}    ${get_list_ton}    ${list_giatri_quydoi}    ${list_product_type}    ${list_tonkho_service}   ${list_discount_type}
    \    ${result_thanhtien}    ${result_toncuoi}   Run Keyword If    '${get_giatri_quydoi}' == '1'    Get total sale - endingstock - cost incase discount additional invoice    ${item_product}
    \    ...    ${item_nums}    ${item_ggsp}    ${item_price}    ${item_onhand}    ${get_product_type}    ${get_toncuoi_dv_execute}   ${item_discount_type}
    \    ...    ELSE    Get total sale - endingstock - cost incase unit and discount additional invoice    ${item_product}    ${item_nums}    ${item_ggsp}
    \    ...    ${item_price}    ${get_giatri_quydoi}   ${item_discount_type}
    \    Append to list    ${list_result_thanhtien}    ${result_thanhtien}
    \    Append to list    ${list_result_toncuoi}    ${result_toncuoi}
    Return From Keyword    ${list_result_thanhtien}    ${get_list_giavon}    ${list_result_toncuoi}

Get list total sale - endingstock - cost - newprice with additional invoice
    [Arguments]    ${list_product}    ${list_nums}    ${list_ggsp}   ${list_discount_type}
    ${list_result_thanhtien}    Create List
    ${list_result_toncuoi}    Create List
    ${list_result_giamoi}    Create List
    ${get_list_giaban}    ${get_list_giavon}    ${get_list_ton}    ${list_giatri_quydoi}    Get list base price - cost - onhand - gia tri quy doi frm API    ${list_product}
    ${list_product_type}    ${list_tonkho_service}    Get list product type and ending stock of service frm API    ${list_product}
    : FOR    ${item_product}    ${item_nums}    ${item_ggsp}    ${item_price}    ${item_onhand}    ${get_giatri_quydoi}
    ...    ${get_product_type}    ${get_toncuoi_dv_execute}   ${discount_type}    IN ZIP    ${list_product}    ${list_nums}    ${list_ggsp}
    ...    ${get_list_giaban}    ${get_list_ton}    ${list_giatri_quydoi}    ${list_product_type}    ${list_tonkho_service}   ${list_discount_type}
    \    ${result_toncuoi}    Run Keyword If    '${get_giatri_quydoi}' == '1'    Computation and get list ending stock    ${item_onhand}    ${get_toncuoi_dv_execute}
    \    ...    ${item_nums}    ${get_product_type}    ELSE    Computation and get list ending stock for unit product    ${item_product}    ${get_giatri_quydoi}    ${item_nums}
    \    ${result_giamoi}    Run Keyword If    '${discount_type}' == 'dis'     Price after % discount product    ${item_price}    ${item_ggsp}
    \    ...    ELSE IF    '${discount_type}' == 'disvnd'    Minus and round 2        ${item_price}    ${item_ggsp}
    \    ...    ELSE IF    '${discount_type}' == 'changeup' or '${discount_type}' == 'changedown'  Set Variable   ${item_ggsp}    ELSE    Set Variable    ${item_price}
    \    ${result_thanhtien}    Multiplication and round    ${result_giamoi}    ${item_nums}
    \    Append to list    ${list_result_thanhtien}    ${result_thanhtien}
    \    Append to list    ${list_result_toncuoi}    ${result_toncuoi}
    \    Append to list    ${list_result_giamoi}    ${result_giamoi}
    Return From Keyword    ${list_result_thanhtien}    ${get_list_giavon}    ${list_result_toncuoi}    ${list_result_giamoi}
