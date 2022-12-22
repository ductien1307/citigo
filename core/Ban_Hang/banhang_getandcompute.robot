*** Settings ***
Library           SeleniumLibrary
Resource          banhang_page.robot
Resource          ../share/constants.robot
Resource          ../share/javascript.robot
Resource          ../share/computation.robot
Resource          ../share/discount.robot
Resource          ../API/api_danhmuc_hanghoa.robot
Resource          ../share/imei.robot
Resource          ../API/api_phieu_nhap_hang.robot
Resource          ../API/api_dathang.robot
Resource          ../API/api_thietlapgia.robot

*** Keywords ***
Assert Thanh tien
    [Arguments]    ${input_soluong}    ${input_gia}
    [Timeout]    15 seconds
    ${result_thanhtien}    Multiplication    ${input_soluong}    ${input_gia}
    ${get_bh_thanhtien}    Format String    ${cell_bh_thanhtien}    1
    ${gettext_bh_thanhtien}    Get Text    ${get_bh_thanhtien}
    ${get_bh_thanhtien}    Convert Any To Number    ${gettext_bh_thanhtien}
    Should Be Equal As Numbers    ${get_bh_thanhtien}    ${result_thanhtien}
    Return From Keyword    ${result_thanhtien}

Assert Tong tien hang if changing product price
    [Arguments]    ${result_thanhtien}
    [Timeout]    15 seconds
    ${gettext_bh_thanhtien}    Get Text    ${cell_bh_tongtienhang}
    ${get_bh_tongtienhang}    Convert Any To Number    ${gettext_bh_thanhtien}
    Should Be Equal As Numbers    ${get_bh_tongtienhang}    ${result_thanhtien}
    Return From Keyword    ${get_bh_tongtienhang}

Assert Khach can tra if discounting invoice VND
    [Arguments]    ${tongtienhang}    ${input_giamgia}
    [Timeout]
    ${result_khachcantra}    Minus    ${tongtienhang}    ${input_giamgia}
    ${get_bh_khachcantra}    Get Text    ${cell_bh_khachcantra}
    ${get_bh_khachcantra}    Convert Any To Number    ${get_bh_khachcantra}
    Should Be Equal As Numbers    ${result_khachcantra}    ${get_bh_khachcantra}
    Return From Keyword    ${result_khachcantra}

Assert Tien thua tra khach if invoice is paid
    [Arguments]    ${khachcantra}    ${input_khach_tt}
    [Timeout]
    ${result_tienthua_trakhach}    Minus    ${khachcantra}    ${input_khach_tt}
    ${result_tienthua_trakhach}    Convert To String    ${result_tienthua_trakhach}
    ${result_tienthua_trakhach}    Catenate    SEPARATOR=    -    ${result_tienthua_trakhach}
    ${result_tienthua_trakhach}    Convert Any To Number    ${result_tienthua_trakhach}
    ${get_bh_tienthua_trakhach}    Get Text    ${cell_tienthua_trakhach}
    ${get_bh_tienthua_trakhach}    Convert Any To Number    ${get_bh_tienthua_trakhach}
    Should Be Equal    ${result_tienthua_trakhach}    ${get_bh_tienthua_trakhach}

Assert Tien thua tra khach if invoice is NOT paid
    [Arguments]    ${khachcantra}
    [Timeout]
    ${result_tienthua_trakhach}    Convert Any To Number    ${khachcantra}
    ${result_tienthua_trakhach}    Minus    0    ${result_tienthua_trakhach}
    ${get_bh_tienthua_trakhach}    Get Text    ${cell_tienthua_trakhach}
    ${get_bh_tienthua_trakhach}    Convert Any To Number    ${get_bh_tienthua_trakhach}
    Should Be Equal    ${result_tienthua_trakhach}    ${get_bh_tienthua_trakhach}

Assert Khach can tra if discounting invoice %
    [Arguments]    ${tongtienhang}    ${input_giamgia}
    [Timeout]
    ${result_khachcantra}    Price after % discount    ${tongtienhang}    ${input_giamgia}
    ${get_bh_khachcantra}    Get Text    ${cell_bh_khachcantra}
    ${get_bh_khachcantra}    Convert Any To Number    ${get_bh_khachcantra}
    Should Be Equal As Numbers    ${result_khachcantra}    ${get_bh_khachcantra}
    Return From Keyword    ${result_khachcantra}

Assert Thanh tien if discount product price VND
    [Arguments]    ${input_soluong}    ${input_giam}
    [Timeout]    15 seconds
    ${result_price_afterdiscount}    Price after % discount
    ${result_thanhtien}    Multiplication    ${input_soluong}    ${input_giam}
    ${get_bh_thanhtien}    Format String    ${cell_bh_thanhtien}    1
    ${gettext_bh_thanhtien}    Get Text    ${get_bh_thanhtien}
    ${get_bh_thanhtien}    Convert Any To Number    ${gettext_bh_thanhtien}
    Should Be Equal As Numbers    ${get_bh_thanhtien}    ${result_thanhtien}
    Return From Keyword    ${result_thanhtien}

Get quantity of serial
    [Timeout]    30 seconds
    ${get_number}    Get Text    ${textbox_bh_soluongban}
    ${get_number}    Convert Any To Number    ${get_number}
    Return From Keyword    ${get_number}

Get BH unit info
    ${get_bh_ma_sp}    Get Text    ${cell_bh_ma_sp}
    Return From Keyword    ${get_bh_ma_sp}

Get list of total sale and onhand results after execute
    [Arguments]    ${input_list_product}    ${input_list_num}
    [Timeout]    5 minutes
    ${list_result_totalsale}    Create list
    ${list_result_onhand_af_ex}    Create list
    ${get_list_onhand_bf_purchase}    ${get_list_baseprice_bf_purchase}    Get list of Onhand and Baseprice frm API    ${input_list_product}
    : FOR    ${item_onhand}    ${item_baseprice}    ${item_num}    IN ZIP    ${get_list_onhand_bf_purchase}    ${get_list_baseprice_bf_purchase}
    ...    ${input_list_num}
    \    ${result_onhand_af_ex}    Minus    ${item_onhand}    ${item_num}
    \    ${result_totalsale}    Multiplication and round    ${item_num}    ${item_baseprice}
    \    Append to list    ${list_result_totalsale}    ${result_totalsale}
    \    Append to list    ${list_result_onhand_af_ex}    ${result_onhand_af_ex}
    Return From Keyword    ${list_result_totalsale}    ${list_result_onhand_af_ex}

Get list of total sale-result new price after execute
    [Arguments]    ${input_list_product}    ${input_list_num}    ${input_list_discount}
    [Timeout]    5 minutes
    ${list_result_totalsale}    Create list
    ${list_result_newprice}    Create list
    ${get_list_baseprice_bf_purchase}    Get list of Baseprice by Product Code    ${input_list_product}
    : FOR    ${item_baseprice}    ${item_num}    ${item_discount}    IN ZIP    ${get_list_baseprice_bf_purchase}    ${input_list_num}
    ...    ${input_list_discount}
    \    ${result_newprice}    Run Keyword If    0 < ${item_discount} < 100    Price after % discount product    ${item_baseprice}    ${item_discount}
    \    ...    ELSE IF    ${item_discount} > 100    Minus    ${item_baseprice}    ${item_discount}
    \    ...    ELSE    Set Variable    ${item_baseprice}
    \    ${result_totalsale}    Multiplication and round    ${item_num}    ${result_newprice}
    \    Append to list    ${list_result_totalsale}    ${result_totalsale}
    \    Append to list    ${list_result_newprice}    ${result_newprice}
    Return From Keyword    ${list_result_totalsale}    ${list_result_newprice}

Get list of total sale - result onhand - result new price after execute
    [Arguments]    ${input_list_product}    ${input_list_num}    ${input_list_discount}
    [Documentation]    Lấy dữ liệu qua API theo list tồn cuối trước khi bán, giá SP. Tính toán tổng tiền hàng, tồn cuối sau bán, giá mới trong các TH giảm giá SP theo vnd,% và không giảm giá SP
    [Timeout]    5 minutes
    ${list_result_totalsale}    Create list
    ${list_result_newprice}    Create list
    ${list_result_onhand}    Create list
    ${get_list_onhand_bf_purchase}    ${get_list_baseprice_bf_purchase}    Get list of Onhand and Baseprice frm API    ${input_list_product}
    : FOR    ${item_baseprice}    ${item_num}    ${item_discount}    ${item_onhand}    IN ZIP    ${get_list_baseprice_bf_purchase}
    ...    ${input_list_num}    ${input_list_discount}    ${get_list_onhand_bf_purchase}
    \    ${result_newprice}    Run Keyword If    0 < ${item_discount} < 100    Price after % discount product    ${item_baseprice}    ${item_discount}
    \    ...    ELSE IF    ${item_discount} > 100    Minus    ${item_baseprice}    ${item_discount}
    \    ...    ELSE    Set Variable    ${item_baseprice}
    \    ${result_totalsale}    Multiplication and round    ${item_num}    ${result_newprice}
    \    ${result_onhand}    Minus    ${item_onhand}    ${item_num}
    \    Append to list    ${list_result_totalsale}    ${result_totalsale}
    \    Append to list    ${list_result_newprice}    ${result_newprice}
    \    Append to list    ${list_result_onhand}    ${result_onhand}
    Return From Keyword    ${list_result_totalsale}    ${list_result_newprice}    ${list_result_onhand}

Get list of total sale - result new price incase changing product price
    [Arguments]    ${input_list_product}    ${input_list_num}    ${input_list_discount}    ${input_list_discount_type}
    [Documentation]    Tính toán tổng tiền hàng, giá mới trong các TH: thay đổi giá SP, giảm giá SP theo vnd,%, không giảm giá SP
    [Timeout]    5 minutes
    ${list_result_totalsale}    Create list
    ${list_result_newprice}    Create list
    ${get_list_baseprice_bf_purchase}    Get list of Baseprice by Product Code    ${input_list_product}
    : FOR    ${item_baseprice}    ${item_num}    ${item_discount}    ${item_discount_type}    IN ZIP    ${get_list_baseprice_bf_purchase}
    ...    ${input_list_num}    ${input_list_discount}    ${input_list_discount_type}
    \    ${result_newprice}=    Run Keyword If    '${item_discount_type}' == 'dis'    Price after % discount product    ${item_baseprice}    ${item_discount}
    \    ...    ELSE IF    '${item_discount_type}' == 'disvnd'    Minus    ${item_baseprice}    ${item_discount}
    \    ...    ELSE IF    '${item_discount_type}' == 'changeup' or '${item_discount_type}' == 'changedown'    Set Variable    ${item_discount}
    \    ...    ELSE    Set Variable    ${item_baseprice}
    \    ${result_totalsale}    Multiplication and round    ${item_num}    ${result_newprice}
    \    Append to list    ${list_result_totalsale}    ${result_totalsale}
    \    Append to list    ${list_result_newprice}    ${result_newprice}
    Return From Keyword    ${list_result_totalsale}    ${list_result_newprice}

Get list of multi lines total sale - result new price incase changing product price
    [Arguments]    ${input_list_product}    ${input_list_num_mul_lines}    ${input_list_discount_mul_lines}    ${input_list_discount_type_mul_lines}
    [Documentation]    Tính toán tổng tiền hàng, giá mới trong các TH: thay đổi giá SP, giảm giá SP theo vnd,%, không giảm giá SP
    [Timeout]    5 minutes
    ${list_result_totalsale}    Create list
    ${list_result_newprice_by_list_product_line}    Create list
    ${get_list_baseprice_bf_purchase}    Get list of Baseprice by Product Code    ${input_list_product}
    : FOR    ${item_product_code}    ${item_baseprice}    ${item_list_quan_by_string}    ${item_list_discount_by_string}    ${list_discounttype_by_string}    IN ZIP
    ...    ${input_list_product}    ${get_list_baseprice_bf_purchase}    ${input_list_num_mul_lines}    ${input_list_discount_mul_lines}    ${input_list_discount_type_mul_lines}
    \    ${list_quan}    Convert String to List    ${item_list_quan_by_string}
    \    ${list_discount}    Convert String to List    ${item_list_discount_by_string}
    \    ${list_discounttype}    Convert String to List    ${list_discounttype_by_string}
    \    ${list_totalsale_by_each_product_code}    ${list_result_newprice_by_eachline_productcode}    Compute total sale and result new price by single row in case multi-lines    ${item_baseprice}    ${list_quan}    ${list_discount}
    \    ...    ${list_discounttype}
    \    ${result_totalsale_by_each_product_code}    Sum values in list    ${list_totalsale_by_each_product_code}
    \    Append to list    ${list_result_totalsale}    ${result_totalsale_by_each_product_code}
    \    Append to list    ${list_result_newprice_by_list_product_line}    ${list_result_newprice_by_eachline_productcode}
    Return From Keyword    ${list_result_totalsale}    ${list_result_newprice_by_list_product_line}

Compute total sale and result new price by single row in case multi-lines
    [Arguments]    ${baseprice}    ${list_quan}    ${list_discount}    ${list_discounttype}
    ${list_totalsale_by_each_product_code}    Create list
    ${list_result_newprice_by_eachline_productcode}    Create list
    : FOR    ${item_quan}    ${item_discount}    ${item_discount_type}    IN ZIP    ${list_quan}    ${list_discount}
    ...    ${list_discounttype}
    \    ${result_newprice_each_line}=    Run Keyword If    '${item_discount_type}' == 'dis'    Price after % discount product    ${baseprice}    ${item_discount}
    \    ...    ELSE IF    '${item_discount_type}' == 'disvnd'    Minus    ${baseprice}    ${item_discount}
    \    ...    ELSE IF    '${item_discount_type}' == 'changeup' or '${item_discount_type}' == 'changedown'    Set Variable    ${item_discount}
    \    ...    ELSE    Set Variable    ${baseprice}
    \    ${result_totalsale_each_row}    Multiplication and round    ${item_quan}    ${result_newprice_each_line}
    \    Append to List    ${list_totalsale_by_each_product_code}    ${result_totalsale_each_row}
    \    Append to List    ${list_result_newprice_by_eachline_productcode}    ${result_newprice_each_line}
    Return From Keyword    ${list_totalsale_by_each_product_code}    ${list_result_newprice_by_eachline_productcode}

Compute total sale - result discount - result new price by single row in case multi-lines
    [Arguments]    ${baseprice}    ${list_quan}    ${list_discount}    ${list_discounttype}
    ${list_totalsale_by_each_product_code}    Create list
    ${list_result_discount_by_each_product_code}    Create list
    ${list_result_newprice_by_eachline_productcode}    Create list
    : FOR    ${item_quan}    ${item_discount}    ${item_discount_type}    IN ZIP    ${list_quan}    ${list_discount}     ${list_discounttype}
    \    ${result_newprice_each_line}=    Run Keyword If    '${item_discount_type}' == 'dis'    Price after % discount product    ${baseprice}    ${item_discount}
    \    ...    ELSE IF    '${item_discount_type}' == 'disvnd'    Minus    ${baseprice}    ${item_discount}
    \    ...    ELSE IF    '${item_discount_type}' == 'changeup' or '${item_discount_type}' == 'changedown'    Set Variable    ${item_discount}
    \    ...    ELSE    Set Variable    ${baseprice}
    \    ${result_product_discount}=    Run Keyword If    '${item_discount_type}' == 'dis'    Convert % discount to VND    ${baseprice}    ${item_discount}
    \    ...    ELSE IF    '${item_discount_type}' == 'disvnd'    Set Variable    ${item_discount}
    \    ...    ELSE IF    '${item_discount_type}' == 'changeup'    Minus    ${baseprice}    ${item_discount}
    \    ...    ELSE IF    '${item_discount_type}' == 'changedown'    Minus    ${item_discount}    ${baseprice}
    \    ...    ELSE    Set Variable    null
    \    ${result_totalsale_each_row}    Multiplication and round    ${item_quan}    ${result_newprice_each_line}
    \    Append to List    ${list_totalsale_by_each_product_code}    ${result_totalsale_each_row}
    \    Append to List    ${list_result_newprice_by_eachline_productcode}    ${result_newprice_each_line}
    \    Append to List    ${list_result_discount_by_each_product_code}    ${result_product_discount}
    Return From Keyword    ${list_totalsale_by_each_product_code}    ${list_result_discount_by_each_product_code}     ${list_result_newprice_by_eachline_productcode}

Get list of product id - baseprice - result product discount - result new price - total sale incase changing product price
    [Arguments]    ${input_list_product}    ${input_list_num}    ${input_list_discount}    ${input_list_discount_type}
    [Documentation]    Lấy dữ liệu qua API theo list tồn cuối trước khi bán, giá SP. Tính toán tổng tiền hàng, tồn cuối sau bán, giá mới trong các TH: thay đổi giá SP, giảm giá SP theo vnd,%, không giảm giá SP
    [Timeout]    5 minutes
    ${list_result_totalsale}    Create list
    ${list_result_newprice}    Create list
    ${list_result_product_discount}    Create list
    ${get_list_baseprice_bf_purchase}    ${list_product_id}    Get list of Product Id and Baseprice by Product Code    ${input_list_product}
    : FOR    ${item_baseprice}    ${item_num}    ${item_discount}    ${item_discount_type}    IN ZIP    ${get_list_baseprice_bf_purchase}
    ...    ${input_list_num}    ${input_list_discount}    ${input_list_discount_type}
    \    ${result_newprice}=    Run Keyword If    '${item_discount_type}' == 'dis'    Price after % discount product    ${item_baseprice}    ${item_discount}
    \    ...    ELSE IF    '${item_discount_type}' == 'disvnd'    Minus    ${item_baseprice}    ${item_discount}
    \    ...    ELSE IF    '${item_discount_type}' == 'changeup' or '${item_discount_type}' == 'changedown'    Set Variable    ${item_discount}
    \    ...    ELSE    Set Variable    ${item_baseprice}
    \    ${result_product_discount}=    Run Keyword If    '${item_discount_type}' == 'dis'    Convert % discount to VND    ${item_baseprice}    ${item_discount}
    \    ...    ELSE IF    '${item_discount_type}' == 'disvnd'    Set Variable    ${item_discount}
    \    ...    ELSE IF    '${item_discount_type}' == 'changeup'    Minus    ${item_baseprice}    ${item_discount}
    \    ...    ELSE IF    '${item_discount_type}' == 'changedown'    Minus    ${item_discount}    ${item_baseprice}
    \    ...    ELSE    Set Variable    null
    \    ${result_totalsale}    Multiplication and round    ${item_num}    ${result_newprice}
    \    Append to list    ${list_result_totalsale}    ${result_totalsale}
    \    Append to list    ${list_result_newprice}    ${result_newprice}
    \    Append to list    ${list_result_product_discount}    ${result_product_discount}
    Return From Keyword    ${list_product_id}    ${get_list_baseprice_bf_purchase}    ${list_result_product_discount}    ${list_result_newprice}    ${list_result_totalsale}

Get list of product id - baseprice - list result product discount - list result new price - list total sale incase changing product price
    [Arguments]    ${list_product}     ${list_num_mul_lines}    ${list_discount_mul_lines}    ${list_discount_type_mul_lines}
    [Documentation]     Tính toán tổng tiền hàng, tồn cuối sau bán, giá mới trong các TH: thay đổi giá SP, giảm giá SP theo vnd,%, không giảm giá SP
    [Timeout]    5 minutes
    ${list_result_totalsale}    Create list
    ${list_result_newprice_by_list_product_line}    Create list
    ${list_result_product_discount_by_list_product_line}    Create list
    ${get_list_baseprice_bf_purchase}    ${list_product_id}    Get list of Product Id and Baseprice by Product Code    ${list_product}
    : FOR    ${item_product_code}    ${item_baseprice}    ${item_list_quan_by_string}    ${item_list_discount_by_string}    ${list_discounttype_by_string}    IN ZIP
    ...    ${list_product}    ${get_list_baseprice_bf_purchase}    ${list_num_mul_lines}    ${list_discount_mul_lines}    ${list_discount_type_mul_lines}
    \    ${list_quan}    Convert String to List    ${item_list_quan_by_string}
    \    ${list_discount}    Convert String to List    ${item_list_discount_by_string}
    \    ${list_discounttype}    Convert String to List    ${list_discounttype_by_string}
    \    ${list_totalsale_by_each_product_code}    ${list_result_discount_by_each_product_code}     ${list_result_newprice_by_eachline_productcode}      Compute total sale - result discount - result new price by single row in case multi-lines    ${item_baseprice}    ${list_quan}    ${list_discount}
    \    ...    ${list_discounttype}
    \    ${result_totalsale_by_each_product_code}    Sum values in list    ${list_totalsale_by_each_product_code}
    \    Append to list    ${list_result_totalsale}    ${result_totalsale_by_each_product_code}
    \    Append to list    ${list_result_newprice_by_list_product_line}    ${list_result_newprice_by_eachline_productcode}
    \    Append to list    ${list_result_product_discount_by_list_product_line}    ${list_result_discount_by_each_product_code}
    Return From Keyword    ${list_product_id}    ${get_list_baseprice_bf_purchase}    ${list_result_product_discount_by_list_product_line}    ${list_result_newprice_by_list_product_line}    ${list_result_totalsale}

Get list of result onhand incase changing product price
    [Arguments]    ${input_list_product}    ${input_list_num}
    [Documentation]    Lấy dữ liệu qua API theo list tồn cuối trước khi bán, giá SP. Tính toán tổng tiền hàng, tồn cuối sau bán, giá mới trong các TH: thay đổi giá SP, giảm giá SP theo vnd,%, không giảm giá SP
    [Timeout]    5 minutes
    ${list_result_onhand}    Create list
    ${get_list_onhand_bf_purchase}    Get list of Onhand by Product Code    ${input_list_product}
    ${get_list_product_type}    ${get_list_imei_status}      Get list product type and imei status frm API   ${input_list_product}
    :FOR    ${item_pr}    ${item_pr_type}     ${item_imei_status}     ${item_onhand}   ${item_num}     IN ZIP    ${input_list_product}   ${get_list_product_type}   ${get_list_imei_status}    ${get_list_onhand_bf_purchase}   ${input_list_num}
    \    ${result_onhand}    Minus    ${item_onhand}    ${item_num}
    \    Run Keyword If    ${item_pr_type}==1 or ${item_pr_type}==3     Append To List    ${list_result_onhand}    0     ELSE         Append To List   ${list_result_onhand}    ${result_onhand}
    Return From Keyword    ${list_result_onhand}

Get list of total sale in case of changing product price
    [Arguments]    ${input_list_product}    ${input_list_num}    ${input_list_newprice}
    [Timeout]    5 minutes
    ${list_result_totalsale}    Create list
    ${get_list_baseprice_bf_purchase}    Get list of Baseprice by Product Code    ${input_list_product}
    : FOR    ${item_baseprice}    ${item_num}    ${item_newprice}    IN ZIP    ${get_list_baseprice_bf_purchase}    ${input_list_num}
    ...    ${input_list_newprice}
    \    ${result_totalsale}    Run Keyword If    '${item_newprice}' == 'none'    Multiplication and round    ${item_num}    ${item_baseprice}
    \    ...    ELSE    Multiplication and round    ${item_num}    ${item_newprice}
    \    Append to list    ${list_result_totalsale}    ${result_totalsale}
    Return From Keyword    ${list_result_totalsale}

Get list of total sale - result onhand - result newprice in case vnd discount product
    [Arguments]    ${input_list_product_code}    ${input_list_num}    ${input_list_product_discount}
    [Timeout]    5 minutes
    ${get_list_onhand_bf_purchase}    ${get_list_baseprice_bf_purchase}    Get list of Onhand and Baseprice frm API    ${input_list_product_code}
    ${list_result_totalsale}    Create list
    ${list_result_onhand_af_ex}    Create list
    ${list_result_newprice}    Create list
    : FOR    ${item_onhand}    ${item_baseprice}    ${item_num}    ${item_discount_vnd}    IN ZIP    ${get_list_onhand_bf_purchase}
    ...    ${get_list_baseprice_bf_purchase}    ${input_list_num}    ${input_list_product_discount}
    \    Log many    ${list_result_onhand_af_ex}
    \    ${result_new_price}    Minus    ${item_baseprice}    ${item_discount_vnd}
    \    ${result_onhand_af_ex}    Minus    ${item_onhand}    ${item_num}
    \    ${result_totalsale}    Multiplication and round    ${item_num}    ${result_new_price}
    \    Append to list    ${list_result_newprice}    ${result_newprice}
    \    Append to list    ${list_result_totalsale}    ${result_totalsale}
    \    Append to list    ${list_result_onhand_af_ex}    ${result_onhand_af_ex}
    \    Log many    ${list_result_onhand_af_ex}
    Return From Keyword    ${list_result_totalsale}    ${list_result_onhand_af_ex}    ${list_result_newprice}

Get list of total sale - result onhand - result newprice in case % discount product
    [Arguments]    ${input_list_product_code}    ${input_list_num}    ${input_list_discount}
    [Timeout]    5 minutes
    ${get_list_onhand_bf_purchase}    ${get_list_baseprice_bf_purchase}    Get list of Onhand and Baseprice frm API    ${input_list_product_code}
    ${list_result_totalsale}    Create list
    ${list_result_onhand_af_ex}    Create list
    ${list_result_newprice}    Create list
    : FOR    ${item_onhand}    ${item_baseprice}    ${item_num}    ${item_discount_%}    IN ZIP    ${get_list_onhand_bf_purchase}
    ...    ${get_list_baseprice_bf_purchase}    ${input_list_num}    ${input_list_discount}
    \    Log many    ${list_result_onhand_af_ex}
    \    ${result_new_price}    Price after % discount product    ${item_baseprice}    ${item_discount_%}
    \    ${result_onhand_af_ex}    Minus    ${item_onhand}    ${item_num}
    \    ${result_totalsale}    Multiplication and round    ${item_num}    ${result_new_price}
    \    Append to list    ${list_result_newprice}    ${result_newprice}
    \    Append to list    ${list_result_totalsale}    ${result_totalsale}
    \    Append to list    ${list_result_onhand_af_ex}    ${result_onhand_af_ex}
    \    Log many    ${list_result_onhand_af_ex}
    Return From Keyword    ${list_result_totalsale}    ${list_result_onhand_af_ex}    ${list_result_newprice}

Get list of total sale - result onhand with one discount
    [Arguments]    ${input_list_product_code}    ${input_list_num}
    [Timeout]    5 minutes
    ${get_list_onhand_bf_purchase}    ${get_list_baseprice_bf_purchase}    Get list of Onhand and Baseprice frm API    ${input_list_product_code}
    ${list_result_totalsale}    Create list
    ${list_result_onhand_af_ex}    Create list
    ${list_result_newprice}    Create list
    : FOR    ${item_onhand}    ${item_baseprice}    ${item_num}    IN ZIP    ${get_list_onhand_bf_purchase}    ${get_list_baseprice_bf_purchase}
    ...    ${input_list_num}
    \    Log many    ${list_result_onhand_af_ex}
    \    ${result_onhand_af_ex}    Minus    ${item_onhand}    ${item_num}
    \    ${result_totalsale}    Multiplication and round    ${item_num}    ${item_baseprice}
    \    Append to list    ${list_result_totalsale}    ${result_totalsale}
    \    Append to list    ${list_result_onhand_af_ex}    ${result_onhand_af_ex}
    Return From Keyword    ${list_result_totalsale}    ${list_result_onhand_af_ex}

Get list of total sale - result onhand in case discount product
    [Arguments]    ${input_list_product_code}    ${input_list_num}    ${input_discount}
    [Timeout]    5 minutes
    ${get_list_onhand_bf_purchase}    ${get_list_baseprice_bf_purchase}    Get list of Onhand and Baseprice frm API    ${input_list_product_code}
    ${list_result_totalsale}    Create list
    ${list_result_onhand_af_ex}    Create list
    ${list_result_newprice}    Create list
    : FOR    ${item_onhand}    ${item_baseprice}    ${item_num}    IN ZIP    ${get_list_onhand_bf_purchase}    ${get_list_baseprice_bf_purchase}
    ...    ${input_list_num}
    \    Log many    ${list_result_onhand_af_ex}
    \    ${result_newprice_ratio}    Price after % discount product    ${item_baseprice}    ${input_discount}
    \    ${result_newprice_vnd}    Minus    ${item_baseprice}    ${input_discount}
    \    ${actual_newprice}    Set Variable If    ${input_discount} > 100    ${result_newprice_vnd}    ${result_newprice_ratio}
    \    ${result_onhand_af_ex}    Minus    ${item_onhand}    ${item_num}
    \    ${result_totalsale}    Multiplication and round    ${item_num}    ${actual_newprice}
    \    Append to list    ${list_result_totalsale}    ${result_totalsale}
    \    Append to list    ${list_result_onhand_af_ex}    ${result_onhand_af_ex}
    Return From Keyword    ${list_result_totalsale}    ${list_result_onhand_af_ex}

Get list of total sale - result onhand in case promotion
    [Arguments]    ${input_list_product_code}    ${input_list_num}    ${product_price_promo}    ${number_sale_if_get_promo}
    [Timeout]    5 minutes
    ${get_list_onhand_bf_purchase}    ${get_list_baseprice_bf_purchase}    Get list of Onhand and Baseprice frm API    ${input_list_product_code}
    ${list_result_totalsale}    Create list
    ${list_result_onhand_af_ex}    Create list
    ${list_result_newprice}    Create list
    : FOR    ${item_onhand}    ${item_baseprice}    ${item_num}    IN ZIP    ${get_list_onhand_bf_purchase}    ${get_list_baseprice_bf_purchase}
    ...    ${input_list_num}
    \    ${result_onhand_af_ex}    Minus    ${item_onhand}    ${item_num}
    \    ${result_totalsale}    Multiplication and round    ${product_price_promo}    ${item_num}
    \    Append to list    ${list_result_totalsale}    ${result_totalsale}
    \    Append to list    ${list_result_onhand_af_ex}    ${result_onhand_af_ex}
    Return From Keyword    ${list_result_totalsale}    ${list_result_onhand_af_ex}

Get list of total sale - result onhand in case of price change
    [Arguments]    ${input_list_product_code}    ${input_list_num}    ${input_list_newprice}
    [Timeout]    5 minutes
    ${list_result_totalsale}    Create list
    ${list_result_onhand_af_ex}    Create list
    ${get_list_onhand_bf_purchase}    ${get_list_baseprice_bf_purchase}    Get list of Onhand and Baseprice frm API    ${input_list_product_code}
    : FOR    ${item_onhand}    ${item_baseprice}    ${item_num}    ${item_newprice}    IN ZIP    ${get_list_onhand_bf_purchase}
    ...    ${get_list_baseprice_bf_purchase}    ${input_list_num}    ${input_list_newprice}
    \    ${result_onhand_af_ex}    Minus    ${item_onhand}    ${item_num}
    \    ${result_totalsale}=    Run keyword If    '${item_newprice}' == 'none'    Multiplication and round    ${item_num}    ${item_baseprice}
    \    ...    ELSE    Multiplication and round    ${item_num}    ${item_newprice}
    \    Append to list    ${list_result_totalsale}    ${result_totalsale}
    \    Append to list    ${list_result_onhand_af_ex}    ${result_onhand_af_ex}
    Return From Keyword    ${list_result_totalsale}    ${list_result_onhand_af_ex}

Get total sale and result onhand of material lists
    [Arguments]    ${input_list_product_code}    ${input_list_num}    ${list_material}    ${list_quanlity_material}
    [Timeout]    5 minutes
    ${list_result_thanhtien}    Create list
    ${get_list_onhand_bf_purchase}    ${get_list_baseprice_bf_purchase}    Get list of Onhand and Baseprice frm API    ${input_list_product_code}
    : FOR    ${item_num}    ${item_baseprice}    IN ZIP    ${input_list_num}    ${get_list_baseprice_bf_purchase}
    \    ${result_thanhtien}    Multiplication and round    ${item_num}    ${item_baseprice}
    \    Append To List    ${list_result_thanhtien}    ${result_thanhtien}
    ${list_result_onhand_all_material}    Create List
    ${list_actual_num_all_material}    Create List
    : FOR    ${list_item_material}    ${list_item_quantity}    ${item_num}    IN ZIP    ${list_material}    ${list_quanlity_material}
    ...    ${input_list_num}
    \    ${list_result_onhand_material}    ${list_num_material}    Get list result onhand and sale number of material    ${list_item_material}    ${list_item_quantity}    ${item_num}
    \    Append To List    ${list_result_onhand_all_material}    ${list_result_onhand_material}
    \    Append To List    ${list_actual_num_all_material}    ${list_num_material}
    Return From Keyword    ${list_result_thanhtien}    ${list_result_onhand_all_material}    ${list_actual_num_all_material}

Get list result onhand and sale number of material
    [Arguments]    ${list_material_by_combo}    ${list_quanlity_material_bycombo}    ${input_num}
    ${list_result_onhand_material}    Create list
    ${list_num_material}    Create list
    ${get_list_onhand_material_af_ex}    ${get_list_baseprice_material_bf_purchase}    Get list of Onhand and Baseprice frm API    ${list_material_by_combo}
    : FOR    ${item_material}    ${item_quantity}    ${item_onhand_bycombo}    IN ZIP    ${list_material_by_combo}    ${list_quanlity_material_bycombo}
    ...    ${get_list_onhand_material_af_ex}
    \    ${actual_num}    Multiplication for onhand    ${item_quantity}    ${input_num}
    \    ${result_onhand_af_ex}    Minus    ${item_onhand_bycombo}    ${actual_num}
    \    Append To List    ${list_result_onhand_material}    ${result_onhand_af_ex}
    \    Append To List    ${list_num_material}    ${actual_num}
    Return From Keyword    ${list_result_onhand_material}    ${list_num_material}

Get list of total sale - new price and result on hand of material in case discount product
    [Arguments]    ${input_list_product_code}    ${input_list_num}    ${input_list_discount}    ${list_material}    ${list_quanlity_material}
    [Timeout]    5 minutes
    ${list_result_thanhtien}    Create list
    ${list_result_newprice}    Create list
    ${get_list_onhand_bf_purchase}    ${get_list_baseprice_bf_purchase}    Get list of Onhand and Baseprice frm API    ${input_list_product_code}
    : FOR    ${item_num}    ${item_baseprice}    ${item_discount}    IN ZIP    ${input_list_num}    ${get_list_baseprice_bf_purchase}
    ...    ${input_list_discount}
    \    ${newprice}    Run Keyword If    ${item_discount} > 100    Minus    ${item_baseprice}    ${item_discount}
    \    ...    ELSE    Price after % discount product    ${item_baseprice}    ${item_discount}
    \    ${result_thanhtien}    Multiplication and round    ${item_num}    ${newprice}
    \    Append To List    ${list_result_thanhtien}    ${result_thanhtien}
    \    Append to List    ${list_result_newprice}    ${newprice}
    ${list_result_onhand_all_material}    Create List
    ${list_actual_num_all_material}    Create List
    : FOR    ${list_item_material}    ${list_item_quantity}    ${item_num}    IN ZIP    ${list_material}    ${list_quanlity_material}
    ...    ${input_list_num}
    \    ${list_result_onhand_material}    ${list_num_material}    Get list result onhand and sale number of material    ${list_item_material}    ${list_item_quantity}    ${item_num}
    \    Append To List    ${list_result_onhand_all_material}    ${list_result_onhand_material}
    \    Append To List    ${list_actual_num_all_material}    ${list_num_material}
    Return From Keyword    ${list_result_thanhtien}    ${list_result_newprice}    ${list_result_onhand_all_material}    ${list_actual_num_all_material}

Get list of total sale - new price and result on hand of material in case discount product by new API
    [Arguments]    ${input_list_product_code}    ${input_list_num}    ${input_list_discount}    ${list_material}    ${list_quanlity_material}
    [Timeout]    5 minutes
    ${list_result_thanhtien}    Create list
    ${list_result_newprice}    Create list
    ${get_list_product_id}    Get list of Id from API by Product Code    ${input_list_product_code}
    ${get_list_baseprice_bf_purchase}    Get list of Baseprice from API by Id    ${get_list_product_id}
    : FOR    ${item_num}    ${item_baseprice}    ${item_discount}    IN ZIP    ${input_list_num}    ${get_list_baseprice_bf_purchase}
    ...    ${input_list_discount}
    \    ${newprice}    Run Keyword If    ${item_discount} > 100    Minus    ${item_baseprice}    ${item_discount}
    \    ...    ELSE    Price after % discount product    ${item_baseprice}    ${item_discount}
    \    ${result_thanhtien}    Multiplication and round    ${item_num}    ${newprice}
    \    Append To List    ${list_result_thanhtien}    ${result_thanhtien}
    \    Append to List    ${list_result_newprice}    ${newprice}
    ${list_result_onhand_all_material}    Create List
    ${list_actual_num_all_material}    Create List
    : FOR    ${list_item_material}    ${list_item_quantity}    ${item_num}    IN ZIP    ${list_material}    ${list_quanlity_material}
    ...    ${input_list_num}
    \    ${list_result_onhand_material}    ${list_num_material}    Get list result onhand and sale number of material    ${list_item_material}    ${list_item_quantity}    ${item_num}
    \    Append To List    ${list_result_onhand_all_material}    ${list_result_onhand_material}
    \    Append To List    ${list_actual_num_all_material}    ${list_num_material}
    Return From Keyword    ${list_result_thanhtien}    ${list_result_newprice}    ${list_result_onhand_all_material}    ${list_actual_num_all_material}

Get list of total sale - result Onhand Actual product sale and Product Unit - actual number Unit - Newprice
    [Arguments]    ${list_products}    ${list_actualproduct_sale}    ${list_num}    ${list_discount}
    [Documentation]    Tính tổng tiền hàng của mỗi sản phẩm, tồn cuối của SP được bán và tồn cuối của sp cơ bản, số lượng sản phẩm được bán theo hh cơ bản, giá mới khi áp dụng giảm giá sản phẩm hoặc không.
    [Timeout]    5 minutes
    ${list_result_thanhtien}    Create list
    ${list_result_onhand_actual_product}    Create list
    ${list_result_onhand_cb}    Create list
    ${list_actual_num_cb}    Create list
    ${list_new_price_sale}    Create list
    ${list_onhand_cb}    ${list_baseprice_cb}    Get list of Onhand and Baseprice frm API    ${list_products}
    ${get_list_giaban_actual_sale}    ${get_list_ton_actual_sale_bf_ex}    ${list_dvqd}    Get list of Onhand and Base price - Conversation values by searching product API    ${list_actualproduct_sale}
    : FOR    ${item_baseprice_actual_sale}    ${item_onhand_actual_sale}    ${item_dvqd}    ${item_num}    ${item_discount}    ${item_onhand_cb}
    ...    IN ZIP    ${get_list_giaban_actual_sale}    ${get_list_ton_actual_sale_bf_ex}    ${list_dvqd}    ${list_num}    ${list_discount}
    ...    ${list_onhand_cb}
    \    ${actual_sale_cb}    Multiplication for onhand    ${item_dvqd}    ${item_num}
    \    ${result_onhand_cb}    Minus    ${item_onhand_cb}    ${actual_sale_cb}
    \    ${result_onhand_actual_sale}    Minus    ${item_onhand_actual_sale}    ${item_num}
    \    ${newprice}    Run Keyword If    0 < ${item_discount} < 100    Price after % discount product    ${item_baseprice_actual_sale}    ${item_discount}
    \    ...    ELSE IF    ${item_discount} > 100    Minus    ${item_baseprice_actual_sale}    ${item_discount}
    \    ...    ELSE    Set Variable    ${item_baseprice_actual_sale}
    \    ${total_sale}    Multiplication and round    ${item_num}    ${newprice}
    \    Append to list    ${list_result_thanhtien}    ${total_sale}
    \    Append to list    ${list_result_onhand_actual_product}    ${result_onhand_actual_sale}
    \    Append to list    ${list_result_onhand_cb}    ${result_onhand_cb}
    \    Append to list    ${list_actual_num_cb}    ${actual_sale_cb}
    \    Append to list    ${list_new_price_sale}    ${newprice}
    Return From Keyword    ${list_result_thanhtien}    ${list_result_onhand_actual_product}    ${list_result_onhand_cb}    ${list_actual_num_cb}    ${list_new_price_sale}

Get list of total sale - result Onhand Actual product sale and Product Unit - actual number Unit
    [Arguments]    ${list_products}    ${list_actualproduct_sale}    ${list_num}    ${list_newprice}
    [Documentation]    Trường hợp thay đổi giá SP_Tính tổng tiền hàng của mỗi sản phẩm, tồn cuối của SP được bán và tồn cuối của sp cơ bản, số lượng sản phẩm được bán theo hh cơ bản.
    [Timeout]    5 minutes
    ${list_result_thanhtien}    Create list
    ${list_result_onhand_actual_product}    Create list
    ${list_result_onhand_cb}    Create list
    ${list_actual_num_cb}    Create list
    ${list_onhand_cb}    ${list_baseprice_cb}    Get list of Onhand and Baseprice frm API    ${list_products}
    ${get_list_giaban_actual_sale}    ${get_list_ton_actual_sale_bf_ex}    ${list_dvqd}    Get list of Onhand and Base price - Conversation values by searching product API    ${list_actualproduct_sale}
    : FOR    ${item_baseprice_actual_sale}    ${item_onhand_actual_sale}    ${item_dvqd}    ${item_num}    ${item_newprice}    ${item_onhand_cb}
    ...    IN ZIP    ${get_list_giaban_actual_sale}    ${get_list_ton_actual_sale_bf_ex}    ${list_dvqd}    ${list_num}    ${list_newprice}
    ...    ${list_onhand_cb}
    \    ${actual_sale_cb}    Multiplication for onhand    ${item_dvqd}    ${item_num}
    \    ${result_onhand_cb}    Minus    ${item_onhand_cb}    ${actual_sale_cb}
    \    ${result_onhand_actual_sale}    Minus    ${item_onhand_actual_sale}    ${item_num}
    \    ${newprice}    Run Keyword If    '${item_newprice}' == 'none'    Set Variable    ${item_baseprice_actual_sale}
    \    ...    ELSE    Set Variable    ${item_newprice}
    \    ${total_sale}    Multiplication and round    ${item_num}    ${newprice}
    \    Append to list    ${list_result_thanhtien}    ${total_sale}
    \    Append to list    ${list_result_onhand_actual_product}    ${result_onhand_actual_sale}
    \    Append to list    ${list_result_onhand_cb}    ${result_onhand_cb}
    \    Append to list    ${list_actual_num_cb}    ${actual_sale_cb}
    Return From Keyword    ${list_result_thanhtien}    ${list_result_onhand_actual_product}    ${list_result_onhand_cb}    ${list_actual_num_cb}

Get list result newprice incase discount product
    [Arguments]    ${input_list_product_code}    ${input_list_product_discount}
    ${get_list_baseprice_bf_purchase}    Get list of Baseprice by Product Code    ${input_list_product_code}
    ${list_result_newprice}    Create list
    : FOR    ${item_baseprice}    ${item_discount}    IN ZIP    ${get_list_baseprice_bf_purchase}    ${input_list_product_discount}
    \    ${result_newprice}    Run Keyword If    0 < ${item_discount} < 100    Price after % discount product    ${item_baseprice}    ${item_discount}
    \    ...    ELSE IF    ${item_discount} > 100    Minus    ${item_baseprice}    ${item_discount}
    \    ...    ELSE    Set Variable    ${item_baseprice}
    \    Append to list    ${list_result_newprice}    ${result_newprice}
    Return From Keyword    ${list_result_newprice}

Computation list price and result discount incase discount by product code
    [Arguments]    ${list_pr}    ${list_ggsp}
    ${list_newprice}    Create List
    ${list_result_ggsp}    Create List
    : FOR    ${item_pr}    ${item_ggsp}    IN ZIP    ${list_pr}    ${list_ggsp}
    \    ${endpoint_pr}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    \    ${jsonpath_giaban}    Format String    $..Data[?(@.Code=="{0}")].BasePrice    ${item_pr}
    \    ${giaban}    Get data from API    ${endpoint_pr}    ${jsonpath_giaban}
    \    ${result_ggsp}    Run Keyword If    0 < ${item_ggsp} < 100    Convert % discount to VND    ${giaban}    ${item_ggsp}
    \    ...    ELSE    Set Variable    ${item_ggsp}
    \    ${newprice}    Minus and round 2    ${giaban}    ${item_ggsp}
    \    Append To List    ${list_newprice}    ${newprice}
    \    Append To List    ${list_result_ggsp}    ${result_ggsp}
    Return From Keyword    ${list_newprice}    ${list_result_ggsp}

Computation list price and result discount incase changing price by product code
    [Arguments]    ${list_pr}    ${list_change}    ${list_change_type}
    [Timeout]    3 minutes
    ${get_list_baseprice_dth}    Get list of Baseprice by Product Code    ${list_pr}
    ${list_newprice}    Create List
    ${list_result_ggsp}    Create List
    : FOR    ${item_pr}    ${item_change}    ${item_change_type}    ${item_baseprice}    IN ZIP    ${list_pr}
    ...    ${list_change}    ${list_change_type}    ${get_list_baseprice_dth}
    \    ${result_ggsp}    Run Keyword If    0 < ${item_change} < 100 and '${item_change_type}'=='dis'    Convert % discount to VND    ${item_baseprice}    ${item_change}
    \    ...    ELSE IF    ${item_change} > 100 and '${item_change_type}'=='dis'    Set Variable    ${item_change}
    \    ...    ELSE    Minus and round 2    ${item_baseprice}    ${item_change}
    \    ${newprice}    Run Keyword If    '${item_change_type}'=='dis'    Minus and round 2    ${item_baseprice}    ${result_ggsp}
    \    ...    ELSE    Set Variable    ${item_change}
    \    ${result_ggsp}    Convert To Number    ${result_ggsp}
    \    ${newprice}    Convert To Number    ${newprice}
    \    Append To List    ${list_newprice}    ${newprice}
    \    Append To List    ${list_result_ggsp}    ${result_ggsp}
    Return From Keyword    ${list_newprice}    ${list_result_ggsp}

Computation list price and result discount incase changing price - multi row
    [Arguments]    ${list_change}    ${list_change_type}    ${item_baseprice}
    ${list_newprice}    Create List
    ${list_result_ggsp}    Create List
    : FOR    ${item_change}    ${item_change_type}    IN ZIP    ${list_change}    ${list_change_type}
    \    ${result_ggsp}    Run Keyword If    0 < ${item_change} < 100 and '${item_change_type}'=='dis'    Convert % discount to VND    ${item_baseprice}    ${item_change}
    \    ...    ELSE IF    ${item_change} > 100 and '${item_change_type}'=='dis'    Set Variable    ${item_change}
    \    ...    ELSE IF    '${item_change_type}'=='change'    Minus and round 2    ${item_baseprice}    ${item_change}
    \    ...    ELSE    Set Variable    0
    \    ${newprice}    Run Keyword If    '${item_change_type}'=='dis'    Minus and round 2    ${item_baseprice}    ${result_ggsp}
    \    ...    ELSE IF    '${item_change_type}'=='change'    Set Variable    ${item_change}
    \    ...    ELSE    Set Variable    ${item_baseprice}
    \    ${result_ggsp}    Convert To Number    ${result_ggsp}
    \    ${newprice}    Convert To Number    ${newprice}
    \    Append To List    ${list_newprice}    ${newprice}
    \    Append To List    ${list_result_ggsp}    ${result_ggsp}
    Return From Keyword    ${list_newprice}    ${list_result_ggsp}

Get total sale incase choose price book
    [Arguments]      ${input_ten_bangia}    ${input_list_product}    ${input_list_num}
    [Timeout]    5 minutes
    ${list_result_totalsale}    Create list
    ${list_giaban_banggia}    Get list products price by price book thr API   ${input_ten_bangia}    ${input_list_product}
    : FOR    ${item_price}    ${item_num}      IN ZIP    ${list_giaban_banggia}    ${input_list_num}
    \    ${result_totalsale}    Multiplication and round    ${item_num}    ${item_price}
    \    Append to list    ${list_result_totalsale}    ${result_totalsale}
    ${result_tongtienhang}    Sum values in list    ${list_result_totalsale}
    Return From Keyword    ${result_tongtienhang}

Get list result onhand af excute
    [Arguments]    ${input_list_product_code}    ${input_list_num}
    [Timeout]    5 minutes
    ${list_result_onhand_af_ex}    Create list
    ${get_list_onhand_bf_purchase}    Get list onhand frm API    ${input_list_product_code}
    : FOR    ${item_onhand}      ${item_num}     IN ZIP    ${get_list_onhand_bf_purchase}    ${input_list_num}
    \    ${result_onhand_af_ex}    Minus    ${item_onhand}    ${item_num}
    \    Append to list    ${list_result_onhand_af_ex}    ${result_onhand_af_ex}
    Return From Keyword    ${list_result_onhand_af_ex}

Computation result customer paid - discount invoice incase changing price by product code
    [Arguments]   ${list_pr}     ${list_num}    ${list_change}    ${list_change_type}    ${input_gghd}     ${input_khtt}
    ${list_giaban}    ${list_result_ggsp}    Computation list price and result discount incase changing price by product code    ${list_pr}    ${list_change}    ${list_change_type}
    ${list_thanhtien_hh}    Create List
    : FOR    ${giaban}    ${soluong}    IN ZIP    ${list_giaban}    ${list_num}
    \    ${result_item_thanhtien}    Multiplication and round    ${giaban}    ${soluong}
    \    Append To List    ${list_thanhtien_hh}    ${result_item_thanhtien}
    Log    ${list_thanhtien_hh}
    ${result_tongtienhang}    Sum values in list    ${list_thanhtien_hh}
    ${result_gghd}    Run Keyword If    0 < ${input_gghd} < 100    Convert % discount to VND    ${result_tongtienhang}    ${input_gghd}
    ...    ELSE    Set Variable    ${input_gghd}
    ${result_gghd}      Evaluate    round(${result_gghd},0)
    ${result_khachcantra}    Minus    ${result_tongtienhang}    ${result_gghd}
    ${result_khtt}      Run Keyword If       '${input_khtt}'=='all'   Set Variable     ${result_khachcantra}    ELSE IF    '${input_khtt}'=='none'    Set Variable    0     ELSE    Set Variable    ${input_khtt}
    Return From Keyword   ${result_khtt}    ${result_gghd}
