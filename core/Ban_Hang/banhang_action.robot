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
Resource          ../API/api_dathang.robot
Resource          ../Tra_hang/doi_tra_hang_action.robot
Resource          ../share/lodate.robot
Resource          ../share/global.robot
Resource          ../Thiet_lap/thiet_lap_nav.robot

*** Keywords ***
Input Invoice info
    [Arguments]    ${input_bh_khachhang}    ${input_bh_khachtt}    ${input_khachcantra}
    Wait Until Page Contains Element    ${textbox_bh_search_khachhang}    1 min
    Wait Until Keyword Succeeds    3 times    10 s    Input Customer to Customer textbox    ${input_bh_khachhang}
    Click Element JS    ${cell_khachhang}
    Wait Until Page Contains Element    ${textbox_bh_khachtt}    1 min
    Wait Until Keyword Succeeds    3 times    20 s    Input customer payment and validate    ${textbox_bh_khachtt}    ${input_bh_khachtt}    ${input_khachcantra}

Input payment
    [Arguments]    ${input_bh_khachtt}    ${input_khachcantra}
    Wait Until Page Contains Element    ${textbox_bh_khachtt}    1 min
    Wait Until Keyword Succeeds    3 times    20 s    Input customer payment and validate    ${textbox_bh_khachtt}    ${input_bh_khachtt}    ${input_khachcantra}

Input payment into any form
    [Arguments]    ${textbox_khachtt}    ${input_bh_khachtt}    ${button_thanhtoan}
    Wait Until Page Contains Element    ${textbox_khachtt}    1 min
    Wait Until Keyword Succeeds    3 times    20 s    Input data    ${textbox_khachtt}    ${input_bh_khachtt}
    Wait Until Page Contains Element    ${button_thanhtoan}    2 mins
    Wait Until Keyword Succeeds    3 times    20 s    Click Element JS    ${button_thanhtoan}

Input payment and validate into any form
    [Arguments]    ${textbox_khachtt}    ${input_bh_khachtt}    ${button_thanhtoan}    ${input_khachcantra}    ${cell_tienthua_trakhach}
    ${result_change_to_customer}    Minus    ${input_khachcantra}    ${input_bh_khachtt}
    Wait Until Page Contains Element    ${textbox_khachtt}    1 min
    Wait Until Keyword Succeeds    3 times    20 s    Input data    ${textbox_khachtt}    ${input_bh_khachtt}
    ${cell_change_to_customer}    Get Change to customer from UI    ${cell_tienthua_trakhach}
    Should Be Equal As Numbers    ${result_change_to_customer}    ${cell_change_to_customer}
    Wait Until Page Contains Element    ${button_thanhtoan}    2 mins
    Wait Until Keyword Succeeds    3 times    20 s    Click Element JS    ${button_thanhtoan}

Input payment info
    [Arguments]    ${input_bh_khachtt}    ${input_khachcantra}
    Wait Until Page Contains Element    ${textbox_bh_khachtt}    1 min
    Wait Until Keyword Succeeds    3 times    20 s    Input customer payment and validate    ${textbox_bh_khachtt}    ${input_bh_khachtt}    ${input_khachcantra}

Input serial number by input to textbox Nhap serial
    [Arguments]    ${input_serial_num}
    Wait Until Page Contains Element    ${textbox_nhap_serial}    30s
    Wait Until Keyword Succeeds    3 times    20 s    Input data    ${textbox_nhap_serial}    ${input_serial_num}
    #Wait Until Page Contains Element    ${cell_serial_imei}    30s
    #${cell_serial_imei}    Format String    ${cell_serial_imei}    ${input_serial_num}
    #Wait Until Page Contains Element    ${cell_serial_imei}    30s
    #Wait Until Keyword Succeeds    3 times    20 s    Click Element JS    ${cell_serial_imei}
    #Press Key    ${textbox_nhap_serial}    ${ENTER_KEY}

Input Khach Hang
    [Arguments]    ${input_bh_khachhang}
    Wait Until Page Contains Element    ${textbox_bh_search_khachhang}    1 min
    Input Customer to Customer textbox    ${input_bh_khachhang}
    Click Element JS    ${cell_khachhang}

Input Customer and validate
    [Arguments]    ${input_bh_khachhang}    ${customer_name}
    Wait Until Page Contains Element    ${textbox_bh_search_khachhang}    1 min
    Wait Until Keyword Succeeds    3 times    3 s    Input Customer to Customer textbox    ${input_bh_khachhang}
    Click Element JS    ${cell_khachhang}
    ${xpath_customer_inplace_byname}    Format String    ${cell_auto_complete_customer}    ${customer_name}
    Wait Until Element Is Enabled    ${xpath_customer_inplace_byname}

Select to unit
    [Arguments]    ${ten_unit}
    Click Element JS    ${cell_bh_unit}
    ${item_unit}    Format String    ${item_unit_in_list}    ${ten_unit}
    log    ${item_unit}
    Wait Until Page Contains Element    ${item_unit}    1min
    Click Element JS    ${item_unit}
    Sleep    10s
    ${get_unit_name}    Get Text    ${cell_unit_name}
    Should Be Equal As Strings    ${get_unit_name}    ${ten_unit}

Input product and its imei to BH form
    [Arguments]    ${input_bh_ma_sp}    @{list_imei}
    [Timeout]
    Input text    ${textbox_bh_search_ma_sp}    ${input_bh_ma_sp}
    Wait Until Page Contains Element    ${cell_sanpham}    30s
    Click Element JS    ${cell_sanpham}
    Wait Until Page Contains Element    ${cell_bh_ma_sp}    30s
    : FOR    ${imei}    IN    @{list_imei}
    \    Input serial number by input to textbox Nhap serial    ${imei}
    Run Keyword If    '${imei}' == 'CONTINUE'    Continue For Loop

Input product to textbox search
    [Arguments]    ${input_ma_sp}
    [Timeout]
    Set Selenium Speed    0.3s
    Input text    ${textbox_bh_search_ma_sp}    ${input_ma_sp}
    Wait Until Page Contains Element    ${cell_sanpham}    2 min

Input Customer to Customer textbox
    [Arguments]    ${input_bh_khachhang}
    Input text    ${textbox_bh_search_khachhang}    ${input_bh_khachhang}
    Wait Until Page Contains Element    ${cell_khachhang}    3 s

Update customer into BH form
    [Arguments]    ${input_ma_kh}
    Wait Until Page Contains Element    ${button_delete_kh}    3 mins
    Click Element JS    ${button_delete_kh}
    Input Khach Hang    ${input_ma_kh}

Select Bang gia
    [Arguments]    ${input_ten_banggia}
    Wait Until Keyword Succeeds    3 times    5s    Input bang gia and wait bang gia is visible    ${input_ten_banggia}

Input bang gia and wait bang gia is visible
    [Arguments]    ${input_ten_banggia}
    KV Click Element JS    ${dropdownlist_banggia}
    KV Input Text    ${textbox_banggia}    ${input_ten_banggia}
    KV Click Element JS By Code      ${item_banggia_in_dropdow}    ${input_ten_banggia}

Input customer payment into BH form
    [Arguments]    ${input_bh_khachtt}    ${result_khachcantra}
    Wait Until Page Contains Element    ${textbox_bh_khachtt}    2 mins
    Wait Until Keyword Succeeds    3 times    5s    Input payment from customer    ${textbox_bh_khachtt}    ${input_bh_khachtt}    ${result_khachcantra}
    ...    ${cell_tinhvaocongno_invoice}
    Wait Until Page Contains Element    ${button_bh_thanhtoan}    2 mins
    Click Element JS    ${button_bh_thanhtoan}

Input product-num and get total sale - onhand lists in BH form
    [Arguments]    ${input_ma_sp}    ${input_soluong}    ${list_result_thanhtien}    ${list_result_ton_af_ex}    ${lastest_num}
    [Timeout]    5 minutes
    ${get_ton_bf_purchase}    ${get_giaban_bf_purchase}    Get Onhand and Baseprice frm API    ${input_ma_sp}
    Wait Until Page Contains Element    ${textbox_bh_search_ma_sp}    2 mins
    Wait Until Keyword Succeeds    3 times    10 s    Input data in textbox and wait until it is visible    ${textbox_bh_search_ma_sp}    ${input_ma_sp}    ${cell_sanpham}
    ...    ${cell_bh_ma_sp}
    Wait Until Page Contains Element    ${textbox_bh_soluongban}    2 mins
    ${lastest_num}    Input number and validate data    ${textbox_bh_soluongban}    ${input_soluong}    ${lastest_num}    ${cell_lastest_number}
    ${result_ton_af_ex}    Minus    ${get_ton_bf_purchase}    ${input_soluong}
    ${result_thanhtien}    Multiplication and round    ${input_soluong}    ${get_giaban_bf_purchase}
    Append to list    ${list_result_thanhtien}    ${result_thanhtien}
    Append to list    ${list_result_ton_af_ex}    ${result_ton_af_ex}
    Return From Keyword    ${list_result_thanhtien}    ${list_result_ton_af_ex}    ${lastest_num}

Input product-num in BH form
    [Arguments]    ${input_ma_sp}    ${input_soluong}    ${lastest_num}
    [Timeout]    5 minutes
    Set Selenium Speed    0.5
    Wait Until Page Contains Element    ${textbox_bh_search_ma_sp}    2 mins
    Wait Until Keyword Succeeds    3 times    10 s    Input data in textbox and wait until it is visible    ${textbox_bh_search_ma_sp}    ${input_ma_sp}    ${cell_sanpham}
    ...    ${cell_bh_ma_sp}
    Wait Until Page Contains Element    ${textbox_bh_soluongban}    2 mins
    ${lastest_num}    Input number and validate data    ${textbox_bh_soluongban}    ${input_soluong}    ${lastest_num}    ${cell_lastest_number}
    Return From Keyword    ${lastest_num}

Input first quantity
    [Arguments]    ${input_list_quantity}    ${lastest_num}
    [Timeout]    5 minutes
    Wait Until Page Contains Element    ${textbox_bh_soluongban}    2 mins
    ${item_quan}    Get from list    ${input_list_quantity}    0
    ${lastest_num}    Input number and validate data    ${textbox_bh_soluongban}    ${item_quan}    ${lastest_num}    ${cell_lastest_number}
    Return From Keyword    ${lastest_num}

Input imei in first row
    [Arguments]    ${list_imei}    ${lastest_num}
    [Timeout]    5 minutes
    Wait Until Page Contains Element    ${textbox_nhap_serial}    2 mins
    ${list_imei_first_row}    Get from list    ${list_imei}    0
    ${quantity}    Get Length    ${list_imei_first_row}
    ${lastest_num}    Input list imei and return lastest number    ${textbox_nhap_serial}    ${item_serial_in_dropdown}    ${tag_single_imei_mhbh}    ${quantity}    ${list_imei_first_row}
    ...    ${lastest_num}
    Return From Keyword    ${lastest_num}

Input product - its quantity mul-lines in BH form
    [Arguments]    ${input_line_quantity}    ${product_code}    ${productid}    ${input_list_number}    ${lastest_num}
    [Timeout]    5 minutes
    Set Selenium Speed    0.5
    Wait Until Page Contains Element    ${textbox_bh_search_ma_sp}    2 mins
    Wait Until Keyword Succeeds    3 times    10 s    Input data in textbox and wait until it is visible    ${textbox_bh_search_ma_sp}    ${product_code}    ${cell_sanpham}
    ...    ${cell_bh_ma_sp}
    Wait Until Page Contains Element    ${textbox_bh_soluongban}    2 mins
    ${lastest_num}    Run Keyword If    ${input_line_quantity}==1    Input first quantity    ${input_list_number}    ${lastest_num}
    ...    ELSE    Adding line and input quantity    ${product_code}    ${productid}    ${input_list_number}    ${lastest_num}
    ...    ${cell_lastest_number}
    Return From Keyword    ${lastest_num}

Input product - its imei mul-lines in BH form
    [Arguments]    ${input_line_quantity}    ${product_code}    ${productid}    ${list_quantity}    ${list_imei}    ${lastest_num}
    [Timeout]    5 minutes
    Set Selenium Speed    0.5
    Wait Until Page Contains Element    ${textbox_bh_search_ma_sp}    2 mins
    Wait Until Keyword Succeeds    3 times    10 s    Input data in textbox and wait until it is visible    ${textbox_bh_search_ma_sp}    ${product_code}    ${cell_sanpham}
    ...    ${cell_bh_ma_sp}
    Wait Until Page Contains Element    ${textbox_bh_soluongban}    2 mins
    ${lastest_num}    Run Keyword If    ${input_line_quantity}==1    Input imei in first row    ${list_imei}    ${lastest_num}
    ...    ELSE    Adding line and input imeis    ${product_code}    ${productid}    ${list_quantity}    ${list_imei}
    ...    ${lastest_num}    ${cell_lastest_number}
    Return From Keyword    ${lastest_num}

Adding line and input imeis
    [Arguments]    ${product_code}    ${productid}    ${list_quan}    ${list_imeis}    ${lastest_num}    ${cell_lastest_number}
    ${lastest_num}    Input imei in first row    ${list_imeis}    ${lastest_num}
    Log    ${list_quan}
    ${list_remain_quan}    Copy List    ${list_quan}
    ${list_remain_imeis}    Copy List    ${list_imeis}
    Remove From List    ${list_remain_quan}    0
    Remove From List    ${list_remain_imeis}    0
    ${adding_row_number}    Get Length    ${list_remain_quan}
    Click adding button in first row    ${product_code}    ${adding_row_number}
    ${index_line_imei}    Set Variable    -1
    : FOR    ${item_quan}    ${item_list_remain_imeis}    IN ZIP    ${list_remain_quan}    ${list_remain_imeis}
    \    ${index_line_imei}    Evaluate    ${index_line_imei} + 1
    \    ${textbox_input_imei_by_line_format}    Format String    ${textbox_input_imei_by_line}    ${productid}    ${index_line_imei}
    \    Set Focus To Element    ${textbox_input_imei_by_line_format}
    \    ${lastest_num}    Input list imei and return lastest number    ${textbox_input_imei_by_line_format}    ${item_serial_in_dropdown}    ${tag_single_imei_mhbh}    ${item_quan}
    \    ...    ${item_list_remain_imeis}    ${lastest_num}
    Return From Keyword    ${lastest_num}

Adding line and input quantity
    [Arguments]    ${product_code}    ${productid}    ${list_quan}    ${lastest_num}    ${cell_lastest_number}
    ${lastest_num}    Input first quantity    ${list_quan}    ${lastest_num}
    ${index_line}    Set Variable    -1
    ${list_remain_quan}    Copy List    ${list_quan}
    Remove From List    ${list_remain_quan}    0
    ${adding_row_number}    Get Length    ${list_remain_quan}
    Click adding button in first row    ${product_code}    ${adding_row_number}
    : FOR    ${item_num}    IN    @{list_remain_quan}
    \    ${index_line}    Evaluate    ${index_line} + 1
    \    ${textbox_input_quan_by_line}    Format String    ${textbox_quantity_by_line}    ${productid}    ${index_line}
    \    Input data    ${textbox_input_quan_by_line}    ${item_num}
    ${lastest_num}    sum    ${adding_row_number}    ${lastest_num}
    Return From Keyword    ${lastest_num}

Click adding button in first row
    [Arguments]    ${product_code}    ${adding_row_quantity}
    : FOR    ${item_row}    IN RANGE    ${adding_row_quantity}
    \    ${button_add_row_infirstline}    Format String    ${button_add_row_infirstline}    ${product_code}
    \    Click Element JS    ${button_add_row_infirstline}

Input product-num in sale form
    [Arguments]    ${input_ma_sp}    ${input_soluong}    ${lastest_num}    ${cell_laster_numbers}
    [Timeout]    5 minutes
    Set Selenium Speed    0.1
    Wait Until Page Contains Element    ${textbox_bh_search_ma_sp}    2 mins
    Wait Until Keyword Succeeds    3 times    5s    Input data in textbox and wait until it is visible    ${textbox_bh_search_ma_sp}    ${input_ma_sp}    ${cell_sanpham}
    ...    ${cell_bh_ma_sp}
    Wait Until Page Contains Element    ${textbox_bh_soluongban}    2 mins
    ${lastest_num}    Input number and validate data    ${textbox_bh_soluongban}    ${input_soluong}    ${lastest_num}    ${cell_laster_numbers}
    Return From Keyword    ${lastest_num}

Input product - nums - vnd product discount in BH form
    [Arguments]    ${input_ma_sp}    ${input_soluong}    ${input_giamgia_sp}    ${input_newprice}    ${lastest_num}
    [Timeout]    5 minutes
    Wait Until Page Contains Element    ${textbox_bh_search_ma_sp}    2 mins
    Wait Until Keyword Succeeds    3 times    10 s    Input data in textbox and wait until it is visible    ${textbox_bh_search_ma_sp}    ${input_ma_sp}    ${cell_sanpham}
    ...    ${cell_bh_ma_sp}
    Wait Until Page Contains Element    ${textbox_bh_soluongban}    2 mins
    Wait Until Keyword Succeeds    3 times    20 s    Input vnd discount for product    ${input_giamgia_sp}    ${input_newprice}
    ${lastest_num}    Input number and validate data    ${textbox_bh_soluongban}    ${input_soluong}    ${lastest_num}    ${cell_lastest_number}
    Return From Keyword    ${lastest_num}

Input product - nums - vnd product discount and get total sale - onhand lists in BH form
    [Arguments]    ${input_ma_sp}    ${input_soluong}    ${input_giamgia_sp}    ${list_result_thanhtien}    ${list_result_ton_af_ex}    ${lastest_num}
    [Timeout]    5 minutes
    ${get_ton_bf_purchase}    ${get_giaban_bf_purchase}    Get Onhand and Baseprice frm API    ${input_ma_sp}
    Wait Until Page Contains Element    ${textbox_bh_search_ma_sp}    2 mins
    Wait Until Keyword Succeeds    3 times    10 s    Input data in textbox and wait until it is visible    ${textbox_bh_search_ma_sp}    ${input_ma_sp}    ${cell_sanpham}
    ...    ${cell_bh_ma_sp}
    Wait Until Page Contains Element    ${textbox_bh_soluongban}    2 mins
    ${lastest_num}    Input number and validate data    ${textbox_bh_soluongban}    ${input_soluong}    ${lastest_num}    ${cell_lastest_number}
    ${result_new_price}    Minus    ${get_giaban_bf_purchase}    ${input_giamgia_sp}
    ${result_ton_af_ex}    Minus    ${get_ton_bf_purchase}    ${input_soluong}
    ${result_thanhtien}    Multiplication and round    ${input_soluong}    ${result_new_price}
    Wait Until Keyword Succeeds    3 times    20 s    Input vnd discount for product    ${input_giamgia_sp}    ${result_new_price}
    Append to list    ${list_result_thanhtien}    ${result_thanhtien}
    Append to list    ${list_result_ton_af_ex}    ${result_ton_af_ex}
    Return From Keyword    ${list_result_thanhtien}    ${list_result_ton_af_ex}    ${lastest_num}

Input product - nums - % product discount and get total sale - onhand lists in BH form
    [Arguments]    ${input_ma_sp}    ${input_soluong}    ${input_giamgia_sp}    ${list_result_thanhtien}    ${list_result_ton_af_ex}    ${lastest_num}
    [Timeout]    5 minutes
    ${get_ton_bf_purchase}    ${get_giaban_bf_purchase}    Get Onhand and Baseprice frm API    ${input_ma_sp}
    Wait Until Page Contains Element    ${textbox_bh_search_ma_sp}    2 mins
    Wait Until Keyword Succeeds    3 times    10 s    Input data in textbox and wait until it is visible    ${textbox_bh_search_ma_sp}    ${input_ma_sp}    ${cell_sanpham}
    ...    ${cell_bh_ma_sp}
    Wait Until Page Contains Element    ${textbox_bh_soluongban}    2 mins
    ${lastest_num}    Input number and validate data    ${textbox_bh_soluongban}    ${input_soluong}    ${lastest_num}    ${cell_lastest_number}
    ${result_new_price}    Price after % discount product    ${get_giaban_bf_purchase}    ${input_giamgia_sp}
    ${result_ton_af_ex}    Minus    ${get_ton_bf_purchase}    ${input_soluong}
    ${result_thanhtien}    Multiplication and round    ${input_soluong}    ${result_new_price}
    Wait Until Keyword Succeeds    3 times    20 s    Input % discount for product    ${input_giamgia_sp}    ${result_new_price}
    Append to list    ${list_result_thanhtien}    ${result_thanhtien}
    Append to list    ${list_result_ton_af_ex}    ${result_ton_af_ex}
    Return From Keyword    ${list_result_thanhtien}    ${list_result_ton_af_ex}    ${lastest_num}

Input product - nums - % product discount in BH form
    [Arguments]    ${input_ma_sp}    ${input_soluong}    ${input_giamgia_sp}    ${result_new_price}    ${lastest_num}
    [Timeout]    5 minutes
    Wait Until Page Contains Element    ${textbox_bh_search_ma_sp}    2 mins
    Wait Until Keyword Succeeds    3 times    10 s    Input data in textbox and wait until it is visible    ${textbox_bh_search_ma_sp}    ${input_ma_sp}    ${cell_sanpham}
    ...    ${cell_bh_ma_sp}
    Wait Until Page Contains Element    ${textbox_bh_soluongban}    2 mins
    ${lastest_num}    Input number and validate data    ${textbox_bh_soluongban}    ${input_soluong}    ${lastest_num}    ${cell_lastest_number}
    Wait Until Keyword Succeeds    3 times    20 s    Input % discount for product    ${input_giamgia_sp}    ${result_new_price}
    Return From Keyword    ${lastest_num}

Input product - new price and get total sale - onhand lists in BH form
    [Arguments]    ${input_ma_sp}    ${input_soluong}    ${input_newprice}    ${list_result_thanhtien}    ${list_result_ton_af_ex}    ${lastest_num}
    [Timeout]    5 minutes
    ${get_ton_bf_purchase}    ${get_giaban_bf_purchase}    Get Onhand and Baseprice frm API    ${input_ma_sp}
    Wait Until Page Contains Element    ${textbox_bh_search_ma_sp}    2 mins
    Wait Until Keyword Succeeds    3 times    10 s    Input data in textbox and wait until it is visible    ${textbox_bh_search_ma_sp}    ${input_ma_sp}    ${cell_sanpham}
    ...    ${cell_bh_ma_sp}
    Wait Until Page Contains Element    ${textbox_bh_soluongban}    2 mins
    ${lastest_num}    Input number and validate data    ${textbox_bh_soluongban}    ${input_soluong}    ${lastest_num}    ${cell_lastest_number}
    ${result_ton_af_ex}    Minus    ${get_ton_bf_purchase}    ${input_soluong}
    ${result_thanhtien}    Multiplication and round    ${input_soluong}    ${input_newprice}
    Wait Until Keyword Succeeds    3 times    20 s    Input new price of product    ${input_newprice}
    Append to list    ${list_result_thanhtien}    ${result_thanhtien}
    Append to list    ${list_result_ton_af_ex}    ${result_ton_af_ex}
    Return From Keyword    ${list_result_thanhtien}    ${list_result_ton_af_ex}    ${lastest_num}

Input product-num-new price in BH form
    [Arguments]    ${input_ma_sp}    ${input_soluong}    ${input_newprice}    ${lastest_num}
    [Timeout]    5 minutes
    Wait Until Page Contains Element    ${textbox_bh_search_ma_sp}    2 mins
    Wait Until Keyword Succeeds    3 times    3 s    Input data in textbox and wait until it is visible    ${textbox_bh_search_ma_sp}    ${input_ma_sp}    ${cell_sanpham}
    ...    ${cell_bh_ma_sp}
    Wait Until Page Contains Element    ${textbox_bh_soluongban}    2 mins
    ${lastest_num}    Input number and validate data    ${textbox_bh_soluongban}    ${input_soluong}    ${lastest_num}    ${cell_lastest_number}
    Run Keyword If    '${input_newprice}' == 'none'    Log    Ignore newprice
    ...    ELSE    Wait Until Keyword Succeeds    3 times    20 s    Input new price of product    ${input_newprice}
    Return From Keyword    ${lastest_num}

Input products and IMEIs to BH form
    [Arguments]    ${input_product}    ${input_list_imei}
    Input product and its imei to any form    ${textbox_bh_search_ma_sp}    ${input_product}    ${item_search_product_indropdow}    ${textbox_nhap_serial}    ${item_serial_in_dropdown}    ${cell_bh_ma_sp}
    ...    ${cell_item_input_imei}    @{input_list_imei}

Input products - IMEIs and validate lastest number in BH form
    [Arguments]    ${input_product}    ${input_imei_quantity}    ${input_list_imei}    ${lastest_num}
    ${lastest_num}    Input product and its imei to any form and return lastest number    ${textbox_bh_search_ma_sp}    ${input_product}    ${input_imei_quantity}    ${item_search_product_indropdow}    ${textbox_nhap_serial}
    ...    ${item_serial_in_dropdown}    ${cell_bh_ma_sp}    ${tag_single_imei_mhbh}    ${lastest_num}    @{input_list_imei}
    Return From Keyword    ${lastest_num}

Input products - IMEIs and validate lastest number in anyform
    [Arguments]    ${input_product}    ${input_imei_quantity}    ${input_list_imei}    ${lastest_num}
    ${lastest_num}    Input product and its imei to any form and return lastest number    ${textbox_bh_search_ma_sp}    ${input_product}    ${input_imei_quantity}    ${item_search_product_indropdow}    ${textbox_nhap_serial}
    ...    ${item_serial_in_dropdown}    ${cell_bh_ma_sp}    ${tag_single_imei_mhbh}    ${lastest_num}    @{input_list_imei}
    Return From Keyword    ${lastest_num}

Adding line and input imei
    [Arguments]    ${product_code}    ${productid}    ${input_list_quan}    ${lastest_num}    ${cell_lastest_number}
    ${lastest_num}    Input first quantity    ${input_list_quan}    ${lastest_num}
    ${index_line}    Set Variable    -1
    Log    ${input_list_quan}
    ${list_remain_quan}    Copy List    ${input_list_quan}
    Remove From List    ${list_remain_quan}    0
    ${adding_row_number}    Get Length    ${list_remain_quan}
    Click adding button in first row    ${product_code}    ${adding_row_number}
    : FOR    ${item_num}    IN    @{list_remain_quan}
    \    ${index_line}    Evaluate    ${index_line} + 1
    \    ${textbox_input_quan_by_line}    Format String    ${textbox_quantity_by_line}    ${productid}    ${index_line}
    \    ${lastest_num}    Input number and validate data    ${textbox_input_quan_by_line}    ${item_num}    ${lastest_num}    ${cell_lastest_number}
    Return From Keyword    ${lastest_num}

Input products and IMEIs - % product discount to BH form
    [Arguments]    ${input_product}    ${input_list_imei}    ${input_discount}    ${input_newprice}
    Wait Until Keyword Succeeds    3 times    5 s    Input product and its imei to any form    ${textbox_bh_search_ma_sp}    ${input_product}    ${item_search_product_indropdow}
    ...    ${textbox_nhap_serial}    ${item_serial_in_dropdown}    ${cell_bh_ma_sp}    ${cell_item_input_imei}    @{input_list_imei}
    Wait Until Keyword Succeeds    3 times    5 s    Input % discount for product    ${input_discount}    ${input_newprice}

Input products and IMEIs - vnd product discount to BH form
    [Arguments]    ${input_product}    ${input_list_imei}    ${input_discount}    ${input_newprice}
    Wait Until Keyword Succeeds    3 times    20 s    Input product and its imei to any form    ${textbox_bh_search_ma_sp}    ${item_product}    ${item_search_product_indropdow}
    ...    ${textbox_nhap_serial}    ${item_serial_in_dropdown}    ${cell_bh_ma_sp}    ${cell_item_input_imei}    @{input_list_imei}
    \    Wait Until Keyword Succeeds    3 times    20 s    Input VND discount for product    ${input_discount}    ${input_newprice}

Input products and IMEIs - new price to BH form
    [Arguments]    ${input_list_product}    ${input_list_imei}    ${input_list_newprice}
    : FOR    ${item_product}    ${item_ime_by_pr}    ${item_newprice}    IN ZIP    ${input_list_product}    ${input_list_imei}
    ...    ${input_list_newprice}
    \    Wait Until Keyword Succeeds    3 times    20 s    Input product and its imei to any form    ${textbox_bh_search_ma_sp}    ${item_product}
    \    ...    ${item_search_product_indropdow}    ${textbox_nhap_serial}    ${item_serial_in_dropdown}    ${cell_bh_ma_sp}    ${cell_item_input_imei}
    \    ...    @{item_ime_by_pr}
    \    Wait Until Keyword Succeeds    3 times    20 s    Input new price of product    ${item_newprice}

Input Combo and nums and get total sale list in BH form
    [Arguments]    ${input_ma_sp}    ${input_soluong}    ${list_material}    ${list_quanlity_material}    ${list_result_thanhtien}    ${list_result_onhand_af_ex}
    ...    ${list_actual_num}    ${lastest_num}
    [Timeout]    5 minutes
    ${get_ton_bf_purchase}    ${get_giaban_bf_purchase}    Get Onhand and Baseprice frm API    ${input_ma_sp}
    ${list_result_onhand_material_af_ex}    Create List    ${EMPTY}
    ${list_actual_num_material_af_ex}    Create List    ${EMPTY}
    : FOR    ${item_material}    ${item_quantity}    IN ZIP    ${list_material}    ${list_quanlity_material}
    \    ${get_onhand_af_ex}    ${get_baseprice_bf_purchase}    Get Onhand and Baseprice frm API    ${item_material}
    \    ${actual_num}    Multiplication for onhand    ${item_quantity}    ${input_soluong}
    \    ${result_onhand_af_ex}    Minus    ${get_onhand_af_ex}    ${actual_num}
    \    Append To List    ${list_result_onhand_material_af_ex}    ${result_onhand_af_ex}
    \    Append To List    ${list_actual_num_material_af_ex}    ${actual_num}
    Remove From List    ${list_result_onhand_material_af_ex}    0
    Remove From List    ${list_actual_num_material_af_ex}    0
    Append To List    ${list_result_onhand_af_ex}    ${list_result_onhand_material_af_ex}
    Append To List    ${list_actual_num}    ${list_actual_num_material_af_ex}
    Wait Until Page Contains Element    ${textbox_bh_search_ma_sp}    2 mins
    Wait Until Keyword Succeeds    3 times    10 s    Input data in textbox and wait until it is visible    ${textbox_bh_search_ma_sp}    ${input_ma_sp}    ${cell_sanpham}
    ...    ${cell_bh_ma_sp}
    Wait Until Page Contains Element    ${textbox_bh_soluongban}    2 mins
    ${lastest_num}    Input number and validate data    ${textbox_bh_soluongban}    ${input_soluong}    ${lastest_num}    ${cell_lastest_number}
    ${result_thanhtien}    Multiplication and round    ${input_soluong}    ${get_giaban_bf_purchase}
    Append to list    ${list_result_thanhtien}    ${result_thanhtien}
    Return From Keyword    ${list_result_thanhtien}    ${list_result_onhand_af_ex}    ${lastest_num}

Input Combo- nums- newprice and get total sale list in BH form
    [Arguments]    ${input_ma_sp}    ${input_soluong}    ${input_newprice}    ${list_material}    ${list_quanlity_material}    ${list_result_thanhtien}
    ...    ${list_result_onhand_af_ex}    ${list_actual_num}    ${lastest_num}
    [Timeout]    5 minutes
    ${list_result_onhand_material_af_ex}    Create List    ${EMPTY}
    ${list_actual_num_material_af_ex}    Create List    ${EMPTY}
    : FOR    ${item_material}    ${item_quantity}    IN ZIP    ${list_material}    ${list_quanlity_material}
    \    ${get_onhand_af_ex}    ${get_baseprice_bf_purchase}    Get Onhand and Baseprice frm API    ${item_material}
    \    ${actual_num}    Multiplication for onhand    ${item_quantity}    ${input_soluong}
    \    ${result_onhand_af_ex}    Minus    ${get_onhand_af_ex}    ${actual_num}
    \    Append To List    ${list_result_onhand_material_af_ex}    ${result_onhand_af_ex}
    \    Append To List    ${list_actual_num_material_af_ex}    ${actual_num}
    Remove From List    ${list_result_onhand_material_af_ex}    0
    Remove From List    ${list_actual_num_material_af_ex}    0
    Append To List    ${list_result_onhand_af_ex}    ${list_result_onhand_material_af_ex}
    Append To List    ${list_actual_num}    ${list_actual_num_material_af_ex}
    Wait Until Page Contains Element    ${textbox_bh_search_ma_sp}    2 mins
    Wait Until Keyword Succeeds    3 times    10 s    Input data in textbox and wait until it is visible    ${textbox_bh_search_ma_sp}    ${input_ma_sp}    ${cell_sanpham}
    ...    ${cell_bh_ma_sp}
    Wait Until Page Contains Element    ${textbox_bh_soluongban}    2 mins
    ${lastest_num}    Input number and validate data    ${textbox_bh_soluongban}    ${input_soluong}    ${lastest_num}    ${cell_lastest_number}
    Wait Until Keyword Succeeds    3 times    10 s    Input new price of product    ${input_newprice}
    ${result_thanhtien}    Multiplication and round    ${input_soluong}    ${input_newprice}
    Append to list    ${list_result_thanhtien}    ${result_thanhtien}
    Return From Keyword    ${list_result_thanhtien}    ${list_result_onhand_af_ex}    ${lastest_num}

Input Combo-nums-vnd discount product and get total sale in BH form
    [Arguments]    ${input_ma_sp}    ${input_soluong}    ${input_discount}    ${list_material}    ${list_quanlity_material}    ${list_result_thanhtien}
    ...    ${list_result_onhand_af_ex}    ${list_actual_num}    ${lastest_num}
    [Timeout]    5 minutes
    ${get_ton_bf_purchase}    ${get_giaban_bf_purchase}    Get Onhand and Baseprice frm API    ${input_ma_sp}
    ${list_result_onhand_material_af_ex}    Create List    ${EMPTY}
    ${list_actual_num_material_af_ex}    Create List    ${EMPTY}
    : FOR    ${item_material}    ${item_quantity}    IN ZIP    ${list_material}    ${list_quanlity_material}
    \    ${get_onhand_af_ex}    ${get_baseprice_bf_purchase}    Get Onhand and Baseprice frm API    ${item_material}
    \    ${actual_num}    Multiplication for onhand    ${item_quantity}    ${input_soluong}
    \    ${result_onhand_af_ex}    Minus    ${get_onhand_af_ex}    ${actual_num}
    \    Append To List    ${list_result_onhand_material_af_ex}    ${result_onhand_af_ex}
    \    Append To List    ${list_actual_num_material_af_ex}    ${actual_num}
    Remove From List    ${list_result_onhand_material_af_ex}    0
    Remove From List    ${list_actual_num_material_af_ex}    0
    Append To List    ${list_result_onhand_af_ex}    ${list_result_onhand_material_af_ex}
    Append To List    ${list_actual_num}    ${list_actual_num_material_af_ex}
    Wait Until Page Contains Element    ${textbox_bh_search_ma_sp}    2 mins
    Wait Until Keyword Succeeds    3 times    10 s    Input data in textbox and wait until it is visible    ${textbox_bh_search_ma_sp}    ${input_ma_sp}    ${cell_sanpham}
    ...    ${cell_bh_ma_sp}
    Wait Until Page Contains Element    ${textbox_bh_soluongban}    2 mins
    ${lastest_num}    Input number and validate data    ${textbox_bh_soluongban}    ${input_soluong}    ${lastest_num}    ${cell_lastest_number}
    ${result_newprice}    Minus    ${get_giaban_bf_purchase}    ${input_discount}
    Wait Until Keyword Succeeds    3 times    10 s    Input vnd discount for product    ${input_discount}    ${result_newprice}
    ${result_thanhtien}    Multiplication and round    ${input_soluong}    ${result_newprice}
    Append to list    ${list_result_thanhtien}    ${result_thanhtien}
    Return From Keyword    ${list_result_thanhtien}    ${list_result_onhand_af_ex}    ${lastest_num}

Input Combo-nums-% discount product and get total sale list in BH form
    [Arguments]    ${input_ma_sp}    ${input_soluong}    ${input_discount_%}    ${list_material}    ${list_quanlity_material}    ${list_result_thanhtien}
    ...    ${list_result_onhand_af_ex}    ${list_actual_num}    ${lastest_num}
    [Timeout]    5 minutes
    ${get_ton_bf_purchase}    ${get_giaban_bf_purchase}    Get Onhand and Baseprice frm API    ${input_ma_sp}
    ${list_result_onhand_material_af_ex}    Create List    ${EMPTY}
    ${list_actual_num_material_af_ex}    Create List    ${EMPTY}
    : FOR    ${item_material}    ${item_quantity}    IN ZIP    ${list_material}    ${list_quanlity_material}
    \    ${get_onhand_af_ex}    ${get_baseprice_bf_purchase}    Get Onhand and Baseprice frm API    ${item_material}
    \    ${actual_num}    Multiplication for onhand    ${item_quantity}    ${input_soluong}
    \    ${result_onhand_af_ex}    Minus    ${get_onhand_af_ex}    ${actual_num}
    \    Append To List    ${list_result_onhand_material_af_ex}    ${result_onhand_af_ex}
    \    Append To List    ${list_actual_num_material_af_ex}    ${actual_num}
    Remove From List    ${list_result_onhand_material_af_ex}    0
    Remove From List    ${list_actual_num_material_af_ex}    0
    Append To List    ${list_result_onhand_af_ex}    ${list_result_onhand_material_af_ex}
    Append To List    ${list_actual_num}    ${list_actual_num_material_af_ex}
    Wait Until Page Contains Element    ${textbox_bh_search_ma_sp}    2 mins
    Wait Until Keyword Succeeds    3 times    10 s    Input data in textbox and wait until it is visible    ${textbox_bh_search_ma_sp}    ${input_ma_sp}    ${cell_sanpham}
    ...    ${cell_bh_ma_sp}
    Wait Until Page Contains Element    ${textbox_bh_soluongban}    2 mins
    ${lastest_num}    Input number and validate data    ${textbox_bh_soluongban}    ${input_soluong}    ${lastest_num}    ${cell_lastest_number}
    ${result_newprice}    Price after % discount product    ${get_giaban_bf_purchase}    ${input_discount_%}
    Wait Until Keyword Succeeds    3 times    10 s    Input % discount for product    ${input_discount_%}    ${result_newprice}
    ${result_thanhtien}    Multiplication and round    ${input_soluong}    ${result_newprice}
    Append to list    ${list_result_thanhtien}    ${result_thanhtien}
    Return From Keyword    ${list_result_thanhtien}    ${list_result_onhand_af_ex}    ${lastest_num}

Input Unit - num in BH form
    [Arguments]    ${input_ma_sp}    ${input_soluong}    ${input_unit}    ${lastest_num}
    [Timeout]    5 minutes
    Wait Until Page Contains Element    ${textbox_bh_search_ma_sp}    2 mins
    Wait Until Keyword Succeeds    3 times    3 s    Input data in textbox and wait until it is visible    ${textbox_bh_search_ma_sp}    ${input_ma_sp}    ${cell_sanpham}
    ...    ${cell_bh_ma_sp}
    Wait Until Keyword Succeeds    3 times    3 s    Select to unit    ${input_unit}
    Wait Until Page Contains Element    ${textbox_bh_soluongban}    2 mins
    ${lastest_num}    Input number and validate data    ${textbox_bh_soluongban}    ${input_soluong}    ${lastest_num}    ${cell_lastest_number}
    Return From Keyword    ${lastest_num}

Input customer payment and deposit refund into BH form
    [Arguments]    ${input_hoantratamung}
    Wait Until Page Contains Element    ${textbox_hoantratamung}    2 mins
    Wait Until Keyword Succeeds    3 times    10 s    Input data    ${textbox_hoantratamung}    ${input_hoantratamung}
    Wait Until Page Contains Element    ${button_bh_thanhtoan}    2 mins
    Wait Until Keyword Succeeds    3 times    10 s    Click Element JS    ${button_bh_thanhtoan}

Select promotion
    [Arguments]    ${promo_name}
    Wait Until Element Is Visible    ${button_promo}
    Click Element JS    ${button_promo}
    ${checkbox_promo_to_select}    Format String    ${checkbox_promo_by_promoname}    ${promo_name}
    Wait Until Element Is Visible    ${checkbox_promo_to_select}
    Click Element JS    ${checkbox_promo_to_select}
    Click Element JS    ${button_apply_promo}
    Wait Until Element Is Visible    ${icon_promo_sale}

Select promotion on each product line
    [Arguments]    ${promo_name}
    Wait Until Element Is Visible    ${button_promo_icon_on_row_product}
    Click Element JS    ${button_promo_icon_on_row_product}
    ${checkbox_promo_to_select}    Format String    ${checkbox_promo_by_promoname}    ${promo_name}
    Wait Until Element Is Visible    ${checkbox_promo_to_select}
    Click Element JS    ${checkbox_promo_to_select}
    Click Element JS    ${button_apply_promo}
    Wait Until Element Is Visible    ${icon_activated_promo_on_row_product}

Select multi promotion on each product line
    [Arguments]    ${promo_name}
    Wait Until Element Is Visible    ${button_multi_promo_icon_on_row_product}
    Click Element JS    ${button_multi_promo_icon_on_row_product}
    ${checkbox_promo_to_select}    Format String    ${checkbox_promo_by_promoname}    ${promo_name}
    Wait Until Element Is Visible    ${checkbox_promo_to_select}
    Click Element JS    ${checkbox_promo_to_select}
    Click Element JS    ${button_apply_promo}
    Wait Until Element Is Visible    ${icon_activated_promo_on_row_product}

Select promotion and giveaway product
    [Arguments]    ${promo_name}    ${list_product_giveaway}    ${list_num_giveaway}
    Wait Until Element Is Visible    ${button_promo}
    Click Element JS    ${button_promo}
    ${checkbox_promo_to_select}    Format String    ${checkbox_promo_by_promoname}    ${promo_name}
    Wait Until Element Is Visible    ${checkbox_promo_to_select}
    Click Element JS    ${checkbox_promo_to_select}
    ##
    ${textbox_timhangtang_by_promoname}    Format String    ${textbox_timhangtang}    ${promo_name}
    Click Element JS    ${textbox_timhangtang_by_promoname}
    Wait Until Element Is Visible    ${button_apply_in_select_giveaway_list}
    : FOR    ${item_product_giveaway}    IN ZIP    ${list_product_giveaway}
    \    ${xpath_item_product}    Format String    ${item_giveaway_product_inlist}    ${item_product_giveaway}
    \    Wait Until Element Is Visible    ${xpath_item_product}
    \    Click Element JS    ${xpath_item_product}
    Click Element JS    ${button_apply_in_select_giveaway_list}
    #input Number
    : FOR    ${item_product_giveaway}    ${item_num_giveaway}    IN ZIP    ${list_product_giveaway}    ${list_num_giveaway}
    \    ${xpath_textbox_number_giveaway}    Format String    ${cell_num_in_promo_screen}    ${item_product_giveaway}
    \    Input Text    ${xpath_textbox_number_giveaway}    ${item_num_giveaway}
    #
    Click Element JS    ${button_apply_promo}
    Wait Until Element Is Visible    ${icon_promo_sale_in_pro_compo}

Select promotion and giveaway product by search product
    [Arguments]    ${promo_name}    ${list_product_giveaway}    ${list_num_giveaway}
    Wait Until Element Is Visible    ${button_promo}
    Click Element JS    ${button_promo}
    ${checkbox_promo_to_select}    Format String    ${checkbox_promo_by_promoname}    ${promo_name}
    Wait Until Element Is Visible    ${checkbox_promo_to_select}
    Click Element JS    ${checkbox_promo_to_select}
    ##
    ${textbox_timhangtang_by_promoname}    Format String    ${textbox_timhangtang}    ${promo_name}
    Click Element JS    ${textbox_timhangtang_by_promoname}
    Wait Until Element Is Visible    ${button_apply_in_select_giveaway_list}
    : FOR    ${item_product_giveaway}    IN ZIP    ${list_product_giveaway}
    \    Wait Until Keyword Succeeds    3 times    8 s    Input data in textbox and click    ${textbox_timhangkhuyenmai}    ${item_product_giveaway}
    \    ...    ${item_giveaway_product_inlist}    ${cell_result_timhangkhuyenmai}
    Click Element JS    ${button_apply_in_select_giveaway_list}
    #input Number
    : FOR    ${item_product_giveaway}    ${item_num_giveaway}    IN ZIP    ${list_product_giveaway}    ${list_num_giveaway}
    \    ${xpath_textbox_number_giveaway}    Format String    ${cell_num_in_promo_screen}    ${item_product_giveaway}
    \    Input Text    ${xpath_textbox_number_giveaway}    ${item_num_giveaway}
    #
    Click Element JS    ${button_apply_promo}
    Wait Until Element Is Visible    ${icon_promo_sale_in_pro_compo}

Select promotion and giveaway product on the first row product
    [Arguments]    ${promo_name}    ${list_product_giveaway}    ${list_num_giveaway}
    Wait Until Element Is Visible    ${button_promo_icon_on_row_product}
    Click Element JS    ${button_promo_icon_on_row_product}
    ${checkbox_promo_to_select}    Format String    ${checkbox_promo_by_promoname}    ${promo_name}
    Wait Until Element Is Visible    ${checkbox_promo_to_select}
    Click Element JS    ${checkbox_promo_to_select}
    ##
    ${textbox_timhangtang_by_promoname}    Format String    ${textbox_timhangtang}    ${promo_name}
    Click Element JS    ${textbox_timhangtang_by_promoname}
    Wait Until Element Is Visible    ${button_apply_in_select_giveaway_list}
    : FOR    ${item_product_giveaway}    IN ZIP    ${list_product_giveaway}
    \    Input Text    ${textbox_search_product_select_promoproduct}    ${item_product_giveaway}
    \    ${xpath_item_product}    Format String    ${item_giveaway_product_inlist}    ${item_product_giveaway}
    \    Wait Until Element Is Visible    ${xpath_item_product}
    \    Click Element JS    ${xpath_item_product}
    Click Element JS    ${button_apply_in_select_giveaway_list}
    #input Number
    : FOR    ${item_product_giveaway}    ${item_num_giveaway}    IN ZIP    ${list_product_giveaway}    ${list_num_giveaway}
    \    ${xpath_textbox_number_giveaway}    Format String    ${cell_num_in_promo_screen}    ${item_product_giveaway}
    \    Input Text    ${xpath_textbox_number_giveaway}    ${item_num_giveaway}
    #
    Click Element JS    ${button_apply_promo}
    Wait Until Element Is Visible    ${icon_activated_promo_on_row_product}

Delete product to any form
    [Arguments]    ${input_ma_hh}
    ${button_xoa_hh}    Format String    ${button_xoa_multi_hh}    ${input_ma_hh}
    Wait Until Page Contains Element    ${button_xoa_hh}    2 mins
    Wait Until Keyword Succeeds    3 times    10s    Click Element JS    ${button_xoa_hh}

Input nums for multi product
    [Arguments]    ${input_ma_sp}    ${input_soluong}    ${lastest_num}    ${cell_laster_numbers}
    [Timeout]    5 minutes
    ${textbox_multi_soluong}    Format String    ${textbox_multi_soluong}    ${input_ma_sp}
    Wait Until Page Contains Element    ${textbox_multi_soluong}    2 mins
    ${lastest_num}    Input number and validate data    ${textbox_multi_soluong}    ${input_soluong}    ${lastest_num}    ${cell_laster_numbers}
    Return From Keyword    ${lastest_num}

Input product and nums into Doi tra hang form
    [Arguments]    ${input_ma_sp}    ${input_soluong}    ${lastest_num}
    Set Selenium Speed    0.5
    Wait Until Page Contains Element    ${textbox_th_search_hangdoi}    2 mins
    Wait Until Keyword Succeeds    3 times    10 s    Input data in textbox and wait until it is visible    ${textbox_th_search_hangdoi}    ${input_ma_sp}    ${cell_dth_sanpham}
    ...    ${cell_dth_ma_sanpham}
    ${textbox_multi_soluong}    Format String    ${textbox_multi_soluong}    ${input_ma_sp}
    Wait Until Page Contains Element    ${textbox_multi_soluong}    2 mins
    ${lastest_num}    Input number and validate data    ${textbox_multi_soluong}    ${input_soluong}    ${lastest_num}    ${cell_tongsoluong_hangdoi}
    Return From Keyword    ${lastest_num}

Delete list product into BH form
    [Arguments]    ${list_product}
    : FOR    ${input_ma_hh}    IN    @{list_product}
    \    ${button_xoa_hh}    Format String    ${button_xoa_multi_hh}    ${input_ma_hh}
    \    Wait Until Page Contains Element    ${button_xoa_hh}    2 mins
    \    Click Element JS    ${button_xoa_hh}

input products and lot name to BH form
    [Arguments]    ${input_product}    ${input_listlo}
    Input products and lot name to any form auto fill lot    ${textbox_bh_search_ma_sp}    ${input_product}    ${item_search_product_indropdow}    ${textbox_nhap_lo}    ${item_lo_in_dropdown}    ${cell_bh_ma_sp}
    ...    ${cell_item_input_lo}    ${input_listlo}

input unit - nums and not input prd in BH form
    [Arguments]    ${input_soluong}    ${input_unit}    ${lastest_num}
    Wait Until Keyword Succeeds    3 times    3 s    Select to unit    ${input_unit}
    Wait Until Page Contains Element    ${textbox_bh_soluongban}    2 mins
    ${lastest_num}    Input number and validate data    ${textbox_bh_soluongban}    ${input_soluong}    ${lastest_num}    ${cell_lastest_number}
    Return From Keyword    ${lastest_num}

Assert price in price book vs price in MHBH
    [Arguments]    ${ten_bang_gia}    ${list_ma_sp}    ${list_gia}
    Select Bang gia    ${ten_bang_gia}
    Sleep    2s
    : FOR    ${item_hh}    ${item_price}    IN ZIP    ${list_ma_sp}    ${list_gia}
    \    Wait Until Keyword Succeeds    3 times    7 s    Input data in textbox and wait until it is visible    ${textbox_bh_search_ma_sp}    ${item_hh}
    \    ...    ${cell_sanpham}    ${cell_bh_ma_sp}
    \    ${price}    Get New price from UI    ${button_giamoi}
    \    Should Be Equal As Numbers    ${price}    ${item_price}

Validate UI Total Invoice value
    [Arguments]    ${result_tongtienhang}
    ${get_ui_totalvalue}    Get text    ${cell_bh_tongtienhang}
    ${get_ui_totalvalue}    Replace String    ${get_ui_totalvalue}    ,    ${EMPTY}
    ${get_ui_totalvalue}    Convert To Number    ${get_ui_totalvalue}
    Should Be Equal As Numbers    ${get_ui_totalvalue}    ${result_tongtienhang}

Input product and click button up quantity in MHBH
    [Arguments]    ${input_ma_sp}    ${input_soluong}    ${lastest_num}    ${value_validation_locator}
    Wait Until Page Contains Element    ${textbox_bh_search_ma_sp}    2 mins
    Wait Until Keyword Succeeds    3 times    10 s    Input data in textbox and wait until it is visible    ${textbox_bh_search_ma_sp}    ${input_ma_sp}    ${cell_sanpham}
    ...    ${cell_bh_ma_sp}
    Wait Until Page Contains Element    ${textbox_bh_soluongban}    2 mins
    Click button up quantity in MHBH    ${input_ma_sp}    ${button_tang_soluong}    ${input_soluong}    ${lastest_num}    ${value_validation_locator}
    Return From Keyword    ${input_soluong}

Input product - num and click button down quantity in MHBH
    [Arguments]    ${input_ma_sp}    ${input_soluong}    ${soluong_down}    ${lastest_num}    ${value_validation_locator}
    Wait Until Page Contains Element    ${textbox_bh_search_ma_sp}    2 mins
    Wait Until Keyword Succeeds    3 times    10 s    Input data in textbox and wait until it is visible    ${textbox_bh_search_ma_sp}    ${input_ma_sp}    ${cell_sanpham}
    ...    ${cell_bh_ma_sp}
    Wait Until Page Contains Element    ${textbox_bh_soluongban}    2 mins
    ${lastest_num}    Input number and validate data    ${textbox_bh_soluongban}    ${input_soluong}    ${lastest_num}    ${value_validation_locator}
    ${item_num_action}    Minus    ${input_soluong}    ${soluong_down}
    ${lastest_num_af}    Minus    ${lastest_num}    ${item_num_action}
    Click button down quantity in MHBH    ${input_ma_sp}    ${button_giam_soluong}    ${lastest_num_af}    ${lastest_num}    ${value_validation_locator}
    Return From Keyword    ${lastest_num_af}

Input product and click button up quantity in Doi tra hang form
    [Arguments]    ${input_ma_sp}    ${input_soluong}    ${lastest_num}    ${value_validation_locator}
    Wait Until Page Contains Element    ${textbox_th_search_hangdoi}    2 mins
    Wait Until Keyword Succeeds    3 times    10 s    Input data in textbox and wait until it is visible    ${textbox_th_search_hangdoi}    ${input_ma_sp}    ${cell_dth_sanpham}
    ...    ${cell_dth_ma_sanpham}
    Wait Until Page Contains Element    ${textbox_bh_soluongban}    2 mins
    Click button up quantity in MHBH    ${input_ma_sp}    ${button_tang_soluong}    ${input_soluong}    ${lastest_num}    ${value_validation_locator}
    Return From Keyword    ${input_soluong}

Input product - num and click button down quantity in Doi tra hang form
    [Arguments]    ${input_ma_sp}    ${input_soluong}    ${soluong_down}    ${lastest_num}    ${value_validation_locator}
    Wait Until Page Contains Element    ${textbox_th_search_hangdoi}    2 mins
    Wait Until Keyword Succeeds    3 times    10 s    Input data in textbox and wait until it is visible    ${textbox_th_search_hangdoi}    ${input_ma_sp}    ${cell_dth_sanpham}
    ...    ${cell_dth_ma_sanpham}
    Wait Until Page Contains Element    ${textbox_bh_soluongban}    2 mins
    ${lastest_num}    Input number and validate data    ${textbox_bh_soluongban}    ${input_soluong}    ${lastest_num}    ${value_validation_locator}
    ${item_num_action}    Minus    ${input_soluong}    ${soluong_down}
    ${lastest_num_af}    Minus    ${lastest_num}    ${item_num_action}
    Click button down quantity in MHBH    ${input_ma_sp}    ${button_giam_soluong}    ${lastest_num_af}    ${lastest_num}    ${value_validation_locator}
    Return From Keyword    ${lastest_num_af}

Get value in icon warning
    [Arguments]    ${ma_sp}
    ${xp_icon}    Format String    ${icon_warning}    ${ma_sp}
    Wait Until Element Is Visible    ${xp_icon}
    ${value}    Get Element Attribute    ${xp_icon}@uib-popover
    ${value}    Convert To String    ${value}
    Return From Keyword    ${value}

Add row product incase multi product in MHBH
  [Arguments]    ${input_ma_hh}   ${list_nums_addrow}    ${list_discount_addrow}   ${list_newprice_addrow}   ${list_type_discount_addrow}
  ...   ${product_id}   ${lastest_num}    ${cell_tongsoluong_mhbh}
  : FOR    ${nums_addrow}    ${input_ggsp}    ${result_giamoi_addrow}   ${discount_type_addrow}    IN ZIP   ${list_nums_addrow}
  ...    ${list_discount_addrow}   ${list_newprice_addrow}   ${list_type_discount_addrow}
  \     ${button_add_row_infirstline}    Format String     ${button_add_row_infirstline}   ${input_ma_hh}
  \     Wait Until Element Is Visible    ${button_add_row_infirstline}
  \     Click Element JS    ${button_add_row_infirstline}
  \     ${textbox_soluong_multirow}   Format String    ${textbox_soluong_multirow}    ${product_id}
  \     ${lastest_num}    Wait Until Keyword Succeeds    3 times    10 s    Input number and validate data    ${textbox_soluong_multirow}    ${nums_addrow}
  \     ...   ${lastest_num}    ${cell_tongsoluong_mhbh}
  \     ${button_giaban_multirow}   Format String    ${button_giaban_multi_productrow}    ${product_id}
  \     Run Keyword If    '${discount_type_addrow}' == 'dis'   Wait Until Keyword Succeeds    3 times    5 s  Input % discount for anyform    ${button_giaban_multirow}    ${button_giamgia_hd_%}   ${input_ggsp}    ${result_giamoi_addrow}
  \     ...    ELSE IF    '${discount_type_addrow}' == 'disvnd'  Wait Until Keyword Succeeds    3 times    5 s    Input VND discount for anyform    ${button_giaban_multirow}    ${textbox_giamgia_multirow}   ${input_ggsp}    ${result_giamoi_addrow}
  \     ...    ELSE IF    '${discount_type_addrow}' == 'changeup' or '${discount_type_addrow}' == 'changedown'  Wait Until Keyword Succeeds    3 times    5 s    Input newprice for anyform    ${button_giaban_multirow}    ${textbox_giamoi_multirow}    0    ${input_ggsp}
  \    ...    ELSE    Log    Ignore input
  Return From Keyword    ${lastest_num}

Add row product incase imei in MHBH
    [Arguments]   ${input_ma_hh}  ${input_nums}    ${list_discount_type}   ${list_ggsp}   ${list_result_newprice}    ${product_id}    ${lastest_num}    ${xpath_tongsoluong}     ${imei_by_product}
    ${button_add_row_infirstline}    Format String     ${button_add_row_infirstline}   ${input_ma_hh}
    ${textbox_search_imei_multirow}    Format String     ${textbox_search_imei_multirow}   1
    :FOR    ${imei}   ${input_ggsp}   ${discount_type}    ${result_newprice}   IN ZIP       ${imei_by_product}   ${list_ggsp}    ${list_discount_type}   ${list_result_newprice}
    \     Wait Until Element Is Visible    ${button_add_row_infirstline}
    \     Click Element JS    ${button_add_row_infirstline}
    \     Wait Until Keyword Succeeds    3 times    10 s    Input imei incase multi product to any form    ${input_ma_hh}    ${textbox_search_imei_multirow}    ${item_serial_in_dropdown}    ${cell_item_imei_multirow}    @{imei}
    \     ${button_giaban_multirow}   Format String    ${button_giaban_multi_productrow}    ${product_id}
    \     Run Keyword If    '${discount_type}' == 'dis'   Wait Until Keyword Succeeds    3 times    5 s  Input % discount for anyform    ${button_giaban_multirow}    ${button_giamgia_hd_%}   ${input_ggsp}    ${result_newprice}
    \     ...    ELSE IF    '${discount_type}' == 'disvnd'  Wait Until Keyword Succeeds    3 times    5 s    Input VND discount for anyform    ${button_giaban_multirow}    ${textbox_giamgia_multirow}   ${input_ggsp}    ${result_newprice}
    \     ...    ELSE IF    '${discount_type}' == 'changeup' or '${discount_type}' == 'changedown'  Wait Until Keyword Succeeds    3 times    5 s    Input newprice for anyform    ${button_giaban_multirow}    ${textbox_giamoi_multirow}    0    ${input_ggsp}
    \    ...    ELSE    Log    Ignore input
    ${lastest_num}    Get Text    ${xpath_tongsoluong}
    Return From Keyword    ${lastest_num}

Add row and input data in Doi tra hang form
    [Arguments]    ${ma_sp}   ${input_pr_id}    ${list_num}    ${lastest_num}    ${base_price}    ${list_change}    ${list_change_type}
    ${button_add_row_infirstline}    Format String    ${button_add_row_infirstline}    ${ma_sp}
    : FOR    ${item_num}    ${item_change}    ${item_change_type}    IN ZIP    ${list_num}    ${list_change}
    ...    ${list_change_type}
    \    Click Element JS    ${button_add_row_infirstline}
    \    ${xp_num}    Format String    ${textbox_quantity_by_line}    ${input_pr_id}    0
    \    ${lastest_num}    Input number and validate data    ${xp_num}    ${item_num}    ${lastest_num}    ${cell_tongsoluong_hangdoi}
    \    ${newprice}    Run Keyword If    0<${item_change}<100 and '${item_change_type}'=='dis'    Price after % discount product    ${base_price}    ${item_change}
    \    ...    ELSE IF    ${item_change}>100 and '${item_change_type}'=='dis'    Minus    ${base_price}    ${item_change}
    \    ...    ELSE IF    '${item_change_type}'=='change'    Set Variable    ${item_change}
    \    ...    ELSE    Set Variable    ${base_price}
    \    Wait Until Keyword Succeeds    3 times    5s    Run Keyword If    0<${item_change}<100 and '${item_change_type}'=='dis'    Input % discount for multi row product
    \    ...    ${input_pr_id}    ${item_change}    ${newprice}
    \    ...    ELSE IF    ${item_change}>100 and '${item_change_type}'=='dis'    Input VND discount for multi row product    ${input_pr_id}    ${item_change}
    \    ...    ${newprice}
    \    ...    ELSE IF    '${item_change_type}'=='change'    Input newprice for multi row product    ${input_pr_id}    ${item_change}
    \    ...    ELSE    Log    ingore input change
    Return From Keyword    ${lastest_num}

Add row and input data in additional invoice form
  [Arguments]    ${input_ma_hh}   ${list_nums_addrow}    ${list_discount_addrow}   ${list_newprice_addrow}   ${list_type_discount_addrow}
  ...   ${product_id}   ${lastest_num}    ${cell_tongsoluong_mhbh}
  : FOR    ${nums_addrow}    ${input_ggsp}    ${result_giamoi_addrow}   ${discount_type_addrow}    IN ZIP   ${list_nums_addrow}
  ...    ${list_discount_addrow}   ${list_newprice_addrow}   ${list_type_discount_addrow}
  \     ${button_add_row_infirstline}    Format String     ${button_add_row_infirstline}   ${input_ma_hh}
  \     Wait Until Element Is Visible    ${button_add_row_infirstline}
  \     Click Element JS    ${button_add_row_infirstline}
  \     ${textbox_soluong_multirow}   Format String    ${textbox_soluong_multirow}    ${product_id}
  \     ${lastest_num}    Wait Until Keyword Succeeds    3 times    10 s    Input number and validate data    ${textbox_soluong_multirow}    ${nums_addrow}
  \     ...   ${lastest_num}    ${cell_tongsoluong_mhbh}
  \     ${button_giaban_multirow}   Format String    ${button_giaban_multi_productrow}    ${product_id}
  \     Run Keyword If    '${discount_type_addrow}' == 'dis'   Wait Until Keyword Succeeds    3 times    5 s  Input % discount for anyform    ${button_giaban_multirow}    ${button_giamgia_hd_%}   ${input_ggsp}    ${result_giamoi_addrow}
  \     ...    ELSE IF    '${discount_type_addrow}' == 'disvnd'  Wait Until Keyword Succeeds    3 times    5 s    Input VND discount for anyform    ${button_giaban_multirow}    ${textbox_giamgia_sp}   ${input_ggsp}    ${result_giamoi_addrow}
  \     ...    ELSE IF    '${discount_type_addrow}' == 'changeup' or '${discount_type_addrow}' == 'changedown'  Wait Until Keyword Succeeds    3 times    5 s    Input newprice for anyform    ${button_giaban_multirow}    ${textbox_giaban}    0    ${input_ggsp}
  \    ...    ELSE    Log    Ignore input
  Return From Keyword    ${lastest_num}

Add row product incase imei in additional invoice form
    [Arguments]   ${input_ma_hh}  ${list_nums_addrow}    ${list_type_discount_addrow}   ${list_discount_addrow}   ${list_newprice_addrow}    ${product_id}    ${lastest_num}    ${xpath_tongsoluong}     ${imei_by_product}
    ${button_add_row_infirstline}    Format String     ${button_add_row_infirstline}   ${input_ma_hh}
    ${textbox_search_imei_multirow}    Format String     ${textbox_search_imei_multirow}   1
    :FOR    ${nums_addrow}    ${input_ggsp}    ${result_giamoi_addrow}   ${discount_type_addrow}    ${imei}    IN ZIP   ${list_nums_addrow}
    ...    ${list_discount_addrow}   ${list_newprice_addrow}   ${list_type_discount_addrow}   ${imei_by_product}
    \     Wait Until Element Is Visible    ${button_add_row_infirstline}
    \     Click Element JS    ${button_add_row_infirstline}
    \     Wait Until Keyword Succeeds    3 times    10 s    Input imei incase multi product to any form    ${input_ma_hh}    ${textbox_search_imei_multirow}
    \     ...    ${item_serial_in_dropdown}    ${cell_item_imei_multirow}    @{imei}
    \     ${button_giaban_multirow}   Format String    ${button_giaban_multi_productrow}    ${product_id}
    \     Run Keyword If    '${discount_type_addrow}' == 'dis'   Wait Until Keyword Succeeds    3 times    5 s  Input % discount for anyform    ${button_giaban_multirow}    ${button_giamgia_hd_%}   ${input_ggsp}    ${result_giamoi_addrow}
    \     ...    ELSE IF    '${discount_type_addrow}' == 'disvnd'  Wait Until Keyword Succeeds    3 times    5 s    Input VND discount for anyform    ${button_giaban_multirow}    ${textbox_giamgia_sp}   ${input_ggsp}    ${result_giamoi_addrow}
    \     ...    ELSE IF    '${discount_type_addrow}' == 'changeup' or '${discount_type_addrow}' == 'changedown'  Wait Until Keyword Succeeds    3 times    5 s    Input newprice for anyform    ${button_giaban_multirow}    ${textbox_giaban}    0    ${input_ggsp}
    \    ...    ELSE    Log    Ignore input
    ${lastest_num}    Get Text    ${xpath_tongsoluong}
    Return From Keyword    ${lastest_num}

Add row and input imei in Doi tra hang form
    [Arguments]    ${ma_sp}   ${input_pr_id}    ${list_imei}    ${base_price}    ${list_change}    ${list_change_type}
    ${button_add_row_infirstline}    Format String    ${button_add_row_infirstline}    ${ma_sp}
    ${xp_nhap_imei}    Format String    ${textbox_row_nhap_imei}    ${input_pr_id}
    : FOR    ${item_change}    ${item_change_type}    ${item_imei}    IN ZIP    ${list_change}    ${list_change_type}    ${list_imei}
    \    Click Element JS    ${button_add_row_infirstline}
    \    Wait Until Keyword Succeeds    3 times    8 s    Input imei incase multi row to any form    ${input_pr_id}    ${textbox_row_nhap_imei}
    \    ...    ${item_dth_imei_in_dropdown}    ${cell_imei_multirow}    ${item_imei}
    \    ${newprice_imei}    Run Keyword If    '${item_change_type}'=='dis'    Computation price incase discount by product code    ${ma_sp}    ${item_change}
    \    ...    ELSE IF    '${item_change_type}'=='chagne'    Set Variable    ${item_change}
    \    ...    ELSE    Set Variable    ${base_price}
    \    Wait Until Keyword Succeeds    3 times    5s    Run Keyword If    0<${item_change}<100 and '${item_change_type}'=='dis'    Input % discount for multi row product
    \    ...    ${input_pr_id}    ${item_change}    ${newprice_imei}
    \    ...    ELSE IF    ${item_change}>100 and '${item_change_type}'=='dis'    Input VND discount for multi row product    ${input_pr_id}    ${item_change}
    \    ...    ${newprice_imei}
    \    ...    ELSE IF    '${item_change_type}'=='change'    Input newprice for multi row product    ${input_pr_id}    ${item_change}
    \    ...    ELSE    Log    ingnore input data

Input product and validate price in suggestion bar MHBH
    [Arguments]    ${input_ma_sp}    ${input_price}
    Wait Until Keyword Succeeds    3 times    10 s    Input data in textbox and get price in suggestion bar    ${textbox_bh_search_ma_sp}    ${input_ma_sp}    ${cell_sanpham}
    ...    ${cell_bh_ma_sp}    ${cell_giaban_in_suggetion}    ${input_price}

Filter group product in MHBH
    [Arguments]    ${nhom_hang}
    Wait Until Page Contains Element    ${toggle_filter_product}    1 min
    Click Element JS    ${toggle_filter_product}
    Input data    ${textbox_bh_tknhomhang}    ${nhom_hang}
    ${xpath_checkbox_nh}    Format String    ${checkbox_bh_nhomhang}    ${nhom_hang}
    Wait Until Element Is Visible    ${xpath_checkbox_nh}    30s
    Click Element JS    ${xpath_checkbox_nh}
    Click Element JS    ${button_filter_xong}

Remove filter group product in MHBH
    Wait Until Page Contains Element    ${toggle_filter_product}    1 min
    Click Element    ${toggle_filter_product}
    Wait Until Element Is Visible    ${label_xoa_nhom_hang}    30s
    Click Element    ${label_xoa_nhom_hang}
    Click Element JS    ${button_filter_xong}

### màn hình quản lý
Go to invoice select export file
    [Arguments]    ${xpath_file_export}
    Wait Until Page Contains Element    ${button_export_invoice}    1 min
    Click Element JS    ${button_export_invoice}
    Wait Until Page Contains Element    ${xpath_file_export}    1 min
    Click Element JS    ${xpath_file_export}

Go to any menu
    [Arguments]    ${locator_menu}
    Wait Until Element Is Visible    ${button_menubar}    5s
    Click Element JS    ${button_menubar}
    Wait Until Element Is Visible    ${locator_menu}    10s
    Click Element JS    ${locator_menu}

Input data in form add customer
    [Arguments]    ${input_ma_kh}    ${input_ten_kh}    ${input_sdt}    ${input_diachi}    ${input_email}
    Input Text Global     ${textbox_ma_kh}    ${input_ma_kh}
    Input Text Global    ${textbox_ten_kh}    ${input_ten_kh}
    Input Text Global    ${textbox_sdt_kh}    ${input_sdt}
    Input Text Global    ${textbox_diachi_kh}    ${input_diachi}
    Input Text Global    ${textbox_email_popup_themmoiKH}    ${input_email}

Assert Ten bang gia in MHBH
    [Arguments]   ${input_bang_gia}
    ${get_ten_banggia}     KV Get Text         ${dropdownlist_banggia}
    Should Be Equal As Strings    ${get_ten_banggia}    ${input_bang_gia}

Add lodate product in MHBH
    [Documentation]    nhập sp, sl lô, đơn giá mới , giảm giá vào MHBH
    [Arguments]    ${list_products}    ${list_product_type}    ${list_nums}    ${list_all_lots}
    ...    ${list_discount_product}    ${list_discount_type}    ${list_result_newprice}
    ${lastest_num}    Set Variable    0
    : FOR    ${item_product}    ${item_product_type}    ${item_num}    ${item_lot}    ${item_discount}    ${item_discount_type}
    ...    ${item_newprice}    IN ZIP    ${list_products}    ${list_product_type}    ${list_nums}    ${list_all_lots}
    ...    ${list_discount_product}    ${list_discount_type}    ${list_result_newprice}
    \    input products and lot name to BH form    ${item_product}    ${item_lot}
    \    ${lastest_num}    Input nums for multi product    ${item_product}    ${item_num}    ${lastest_num}    ${cell_lastest_number}
    \    Run keyword if    '${item_discount_type}' == 'dis'    Wait Until Keyword Succeeds    3 times    5 s    Input % discount for product
    \    ...    ${item_discount}    ${item_newprice}
    \    ...    ELSE IF    '${item_discount_type}' == 'disvnd'    Wait Until Keyword Succeeds    3 times    5 s
    \    ...    Input vnd discount for product    ${item_discount}    ${item_newprice}
    \    ...    ELSE IF    '${item_discount_type}' == 'changeup' or '${item_discount_type}' == 'changedown'    Wait Until Keyword Succeeds    3 times    5 s
    \    ...    Input new price of product    ${item_discount}
    \    ...    ELSE    Log    ignore

Input invoice discount
    [Documentation]    nhập giảm giá hóa đơn
    [Arguments]       ${input_invoice_discount}    ${result_discount_invoice}
    Run Keyword If    0 < ${input_invoice_discount} < 100    Wait Until Keyword Succeeds    3 times    8 s    Input % discount invoice    ${input_invoice_discount}
    ...    ${result_discount_invoice}
    ...    ELSE IF    ${input_invoice_discount} > 100    Input VND discount invoice    ${input_invoice_discount}
    ...    ELSE    Log    Ignore discount

Computation total, discount and pay for customer incase lodate warranty invoice
    [Documentation]    tính thành tiền, giảm giá, tiền khách cần trả.. trong hóa đơn
    [Arguments]     ${input_bh_ma_kh}      ${list_result_thanhtien}      ${input_invoice_discount}      ${input_bh_khachtt}
    ${get_no_bf_execute}    ${get_tongban_bf_execute}    ${get_tongban_tru_trahang_bf_execute}    Get Customer Debt from API    ${input_bh_ma_kh}
    ${result_tongtienhang}    Sum values in list    ${list_result_thanhtien}
    Validate UI Total Invoice value    ${result_tongtienhang}
    ${result_khachcantra}=    Run Keyword If    0 < ${input_invoice_discount} < 100    Price after % discount invoice    ${result_tongtienhang}    ${input_invoice_discount}
    ...    ELSE IF    ${input_invoice_discount} > 100    Minus    ${result_tongtienhang}    ${input_invoice_discount}
    ...    ELSE    Set Variable    ${result_tongtienhang}
    ${result_discount_invoice}    Run Keyword If    0 < ${input_invoice_discount} < 100    Convert % discount to VND and round    ${result_tongtienhang}    ${input_invoice_discount}
    ...    ELSE    Set Variable    ${input_invoice_discount}
    ${actual_khachtt}    Set Variable If    '${input_bh_khachtt}' == 'all'    ${result_khachcantra}    ${input_bh_khachtt}
    ${result_no_hoadon}    Minus    ${result_khachcantra}    ${actual_khachtt}
    ${result_nohientai}    sum    ${result_no_hoadon}    ${get_no_bf_execute}
    ${result_tongban}    Sum    ${result_khachcantra}    ${get_tongban_bf_execute}
    Return From Keyword    ${result_tongtienhang}    ${result_khachcantra}    ${result_discount_invoice}     ${actual_khachtt}      ${result_nohientai}     ${result_tongban}

Input product and wait button Them hang hoa enabled
    [Arguments]        ${input_ten_hh}
    KV Input Text      ${textbox_bh_search_ma_sp}      ${input_ten_hh}
    KV Click Element JS        ${button_mhbh_themmoi_hh}

Create new product in MHBH
    [Arguments]       ${input_ma_hh}    ${input_ten_hh}   ${input_nhomhang}   ${input_giavon}   ${input_giaban}   ${input_dvcb}   ${input_tonkho}   ${input_status}
    Wait Until Keyword Succeeds    3x    0.5s    Input product and wait button Them hang hoa enabled      ${input_ten_hh}
    KV Input data   ${textbox_mhbh_mahang}    ${input_ma_hh}
    Wait Until Keyword Succeeds    3x    0.5s    Select combobox any form and click element JS    ${cell_mhbh_nhomhang}    ${item_mhbh_nhomhang_indropdow}    ${input_nhomhang}
    Run Keyword If    ${input_giavon}!=0    Input Text     ${textbox_mhbh_giavon}    ${input_giavon}
    Run Keyword If    ${input_giaban}!=0    Input Text     ${textbox_mhbh_giaban}    ${input_giaban}
    Run Keyword If    '${input_dvcb}'!='none'    Input Text     ${textbox_mhbh_dvcb}    ${input_dvcb}
    Run Keyword If    ${input_tonkho}!=0 and '${input_status}'!='imei'   Input Text     ${textbox_mhbh_tonkho}    ${input_tonkho}
    Run Keyword If    '${input_status}'=='imei'   Click Element JS    ${checkbox_mhbh_imei}
    Click Element JS    ${button_mhbh_luu_hh}
    Wait Until Element Contains    ${cell_bh_ma_sp}    ${input_ma_hh}     30s

Create list new product in MHBH and return list product name
    [Arguments]        ${list_ma_hh}   ${list_nhomhang}     ${list_giavon}    ${list_giaban}   ${list_dvcb}   ${list_tonkho}   ${list_status}
    ${list_ten_hh}     Create List
    :FOR    ${item_ma_hh}   ${item_nhom_hang}   ${item_giavon}     ${item_giaban}    ${item_list_dvcb}   ${item_list_tonkho}   ${item_list_status}   IN ZIP    ${list_ma_hh}   ${list_nhomhang}    ${list_giavon}    ${list_giaban}   ${list_dvcb}   ${list_tonkho}   ${list_status}
    \     ${item_ten_hh}    Generate code automatically    MKJF
    \     Create new product in MHBH       ${item_ma_hh}   ${item_ten_hh}    ${item_nhom_hang}     ${item_giavon}   ${item_giaban}    ${item_list_dvcb}   ${item_list_tonkho}   ${item_list_status}
    \     Append To List   ${list_ten_hh}   ${item_ten_hh}
    Return From Keyword    ${list_ten_hh}

Input product and wait button Them hang hoa in form Doi tra hang enabled
    [Arguments]        ${input_ten_hh}
    KV Input Text      ${textbox_th_search_hangdoi}      ${input_ten_hh}
    KV Click Element JS        ${button_mhbh_themmoi_hh_hangdoi}

Create new product in form Doi tra hang
    [Arguments]       ${input_ma_hh}    ${input_ten_hh}   ${input_nhomhang}    ${input_giavon}   ${input_giaban}   ${input_dvcb}   ${input_tonkho}   ${input_status}
    Wait Until Keyword Succeeds    3x    0.5s   Input product and wait button Them hang hoa in form Doi tra hang enabled     ${input_ten_hh}
    KV Input data   ${textbox_mhbh_mahang}    ${input_ma_hh}
    Wait Until Keyword Succeeds    3x    0.5s    Select combobox any form and click element JS    ${cell_mhbh_nhomhang}    ${item_mhbh_nhomhang_indropdow}    ${input_nhomhang}
    Run Keyword If    ${input_giavon}!=0    Input Text     ${textbox_mhbh_giavon}    ${input_giavon}
    Run Keyword If    ${input_giaban}!=0    Input Text     ${textbox_mhbh_giaban}    ${input_giaban}
    Run Keyword If    '${input_dvcb}'!='none'    Input Text     ${textbox_mhbh_dvcb}    ${input_dvcb}
    Run Keyword If    ${input_tonkho}!=0    Input Text     ${textbox_mhbh_tonkho}    ${input_tonkho}
    Run Keyword If    '${input_status}'=='imei'   Click Element JS    ${checkbox_mhbh_imei}
    Click Element JS    ${button_mhbh_luu_hh}
    Wait Until Element Contains    ${cell_dth_ma_sanpham}    ${input_ma_hh}     30s

Create list new product in form Doi tra hang and return list product name
    [Arguments]        ${list_ma_hh}   ${list_nhomhang}   ${list_giavon}     ${list_giaban}   ${list_dvcb}   ${list_tonkho}   ${list_status}
    ${list_ten_hh}     Create List
    :FOR    ${item_ma_hh}   ${item_nhom_hang}   ${item_giavon}     ${item_giaban}    ${item_list_dvcb}   ${item_list_tonkho}   ${item_list_status}   IN ZIP    ${list_ma_hh}   ${list_nhomhang}   ${list_giavon}      ${list_giaban}   ${list_dvcb}   ${list_tonkho}   ${list_status}
    \     ${item_ten_hh}    Generate code automatically    MKJF
    \     Create new product in form Doi tra hang      ${item_ma_hh}   ${item_ten_hh}    ${item_nhom_hang}    ${item_giavon}     ${item_giaban}    ${item_list_dvcb}   ${item_list_tonkho}   ${item_list_status}
    \     Append To List   ${list_ten_hh}   ${item_ten_hh}
    Return From Keyword    ${list_ten_hh}

Click To Close Form
    Click Element JS    ${button_close}
