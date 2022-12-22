*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    ${headless_browser}
Test Setup        Before Test Ban Hang
Test Teardown     After Test
Resource          ../../../../core/API/api_thietlap.robot
Resource          ../../../../core/API/api_dathang.robot
Resource          ../../../../core/Ban_Hang/banhang_getandcompute.robot
Resource          ../../../../core/share/toast_message.robot
Resource          ../../../../core/API/api_mhbh_dathang.robot
Resource          ../../../../core/API/api_soquy.robot
Resource          ../../../../core/API/api_danhmuc_hanghoa.robot
Resource          ../../../../config/env_product/envi.robot

*** Variables ***
&{list_product_nums1}    HKM004=4
&{list_product_nums2}    DVT37=7
&{list_product_nums3}    DVT38=3    HKM008=3
&{list_give1}    HKM006=1
&{list_give2}    HKM007=1
&{list_product_del}    HKM008=3
@{list_discount}    10
@{list_nodiscount}    0
@{list_giamoi}    800000

*** Test Cases ***    List product nums        GGHD          Mã KH      Khách TT    Mã khuyến mãi     Khuyến mãi add thêm
Khuyen mai gop
                      [Tags]                   UEDKMG
                      [Template]               edg1
                      ${list_product_nums1}    15            CTKH041       all                KM11            KM013

KM HH va HD hinh thuc tang hang - 1TK
                      [Tags]                   UEDKMG
                      [Template]               edg2
                      ${list_product_nums2}    0           CTKH042       0      KM015      ${list_give1}     ${list_giamoi}      200000    TK004

KM HH va HD hinh thuc giam gia hang - 2TK
                      [Tags]                   UEDKMG
                      [Template]               edg3
                      ${list_product_nums3}    0               CTKH043       20000      KM016      ${list_give2}        ${list_discount}      all     ${list_product_del}     TK008       TK003

*** Keywords ***
edg1
    [Arguments]    ${dict_product_num}    ${input_ggdh}    ${input_ma_kh}    ${input_khtt}    ${input_khuyemmai}    ${input_khuyemmai_add}
    ## Get info ton cuoi, cong no khach hang'
    Turn on allow use promotion combine in shop config
    Toggle status of promotion    ${input_khuyemmai_add}    1
    Toggle status of promotion    ${input_khuyemmai}    1
    ${list_product}    Get Dictionary Keys    ${dict_product_num}
    ${list_nums}    Get Dictionary Values    ${dict_product_num}
    ${num_sale_product}    ${num_promo_product}    ${product_price}    ${discount}    ${discount_ratio}    ${name}    Get Number of sale product - promo product - promo value and name
    ...    ${input_khuyemmai}
    ${invoice_value}    ${discount_add}    ${discount_ratio_add}    ${name_add}    Get Invoice value - Discounts - Promotion Name from Promotion Code    ${input_khuyemmai_add}
    ${get_no_bf_execute}    ${get_tongban_bf_execute}    ${get_tongban_tru_trahang_bf_execute}    ${get_customer_name}    Get Customer Info from API    ${input_ma_kh}
    #create lists
    Reload page
    # Input data into BH form
    ${total_sale_number}    Sum values in list    ${list_nums}
    ${list_result_totalsale}    ${list_result_onhand_af_ex}    Run Keyword If    ${discount} != 0 and ${discount_ratio} ==0    Get list of total sale - result onhand in case discount product    ${list_product}    ${list_nums}
    ...    ${discount}
    ...    ELSE IF    ${discount} == 0 and ${discount_ratio} != 0    Get list of total sale - result onhand in case discount product    ${list_product}    ${list_nums}    ${discount_ratio}
    ...    ELSE IF    ${total_sale_number} < ${num_sale_product}    Get list of total sale - result onhand with one discount    ${list_product}    ${list_nums}
    ...    ELSE    Get list of total sale - result onhand in case promotion    ${list_product}    ${list_nums}    ${product_price}    ${num_sale_product}
    ${list_result_order_summary}    Get list result order summary frm product API    ${list_product}    ${list_nums}
    Wait Until Keyword Succeeds    3 times    5 s    Click Element JS    ${tab_dathang}
    Wait Until Keyword Succeeds    3 times    8 s    Input Customer and validate    ${input_ma_kh}    ${get_customer_name}
    ${lastest_num}    Set Variable    0
    : FOR    ${item_product}    ${item_num}    IN ZIP    ${list_product}    ${list_nums}
    \    ${lastest_num}    Input product-num in sale form    ${item_product}    ${item_num}    ${lastest_num}    ${cell_tongsoluong_dh}
    \    Run Keyword If    ${total_sale_number} >= ${num_sale_product}    Wait Until Keyword Succeeds    3 times    8 s    Select multi promotion on each product line
    \    ...    ${name}    ELSE    Log    kmk
    #compute
    ${result_tongtienhang}    Sum values in list    ${list_result_totalsale}
    ${result_discount_invoice_by_vnd}   Convert % discount to VND and round    ${result_tongtienhang}    ${input_ggdh}
    ${result_discount_ratio_by_invoice_promo}    Convert % discount to VND and round    ${result_tongtienhang}    ${discount_ratio_add}
    ${actual_promo_value}    Set Variable If    ${discount_add} == 0    ${result_discount_ratio_by_invoice_promo}    ${discount_add}
    ${final_discount}=    Run Keyword If    ${result_tongtienhang} > ${invoice_value}    Sum    ${actual_promo_value}    ${result_discount_invoice_by_vnd}
    ...    ELSE    Set Variable    ${result_discount_invoice_by_vnd}
    ${result_khachcantra}    Minus and replace floating point    ${result_tongtienhang}    ${final_discount}
    ${actual_khachtt}    Set Variable If    '${input_khtt}' == 'all'    ${result_khachcantra}    ${input_khtt}
    ${result_no_hoadon}    Minus    ${result_khachcantra}    ${actual_khachtt}
    ${result_nohientai}    sum    ${result_no_hoadon}    ${get_no_bf_execute}
    ${result_tongban}    Sum    ${result_khachcantra}    ${get_tongban_bf_execute}
    ##create order
    Run Keyword If    ${result_tongtienhang} > ${invoice_value}    Wait Until Keyword Succeeds    3 times    8 s    Select order multi promotion    ${name_add}
    ...    ELSE    Element Should Not Be Visible    ${icon_promo_sale}
    Wait Until Keyword Succeeds    3 times    8 s    Input % discount order    ${input_ggdh}    ${final_discount}
    Wait Until Keyword Succeeds    3 times    8 s    Run Keyword If    '${input_khtt}' != '0'    Input payment and validate into any form    ${textbox_dh_khachtt}
    ...    ${actual_khachtt}    ${button_bh_dathang}    ${result_khachcantra}    ${cell_tinhvaocongno_order}
    ...    ELSE    Click Element JS    ${button_bh_dathang}
    Order message success validation
    ${order_code}    Get saved code after execute
    #get values
    Sleep    20 s    wait for response to API
    #assert value product
    ${list_order_summary_af_execute}    Get list order summary frm product API    ${list_product}
    : FOR    ${result_tong_dh}    ${order_summary_af_execute}    IN ZIP    ${list_result_order_summary}    ${list_order_summary_af_execute}
    \    Should Be Equal As Numbers    ${order_summary_af_execute}    ${result_tong_dh}
    #assert values in order
    ${get_ma_kh_in_dh_af_execute}    ${get_TTDH_in_dh_af_execute}    ${get_tongtienhang_in_dh_af_exxecute}    ${get_khachdatra_in_dh_af_execute}    ${get_giamgia_in_dh_af_execute}    ${get_tongcong_in_dh_af_execute}    ${get_ghichu_in_dh_af_execute}
    ...    Get order info incase discount by order code    ${order_code}
    Should Be Equal As Strings    ${get_ma_kh_in_dh_af_execute}    ${get_ma_kh_in_dh_af_execute}
    Should Be Equal As Numbers    ${get_TTDH_in_dh_af_execute}    1    #1 : phiếu tạm
    Should Be Equal As Numbers    ${get_tongtienhang_in_dh_af_exxecute}    ${result_tongtienhang}
    Should Be Equal As Numbers    ${get_khachdatra_in_dh_af_execute}    ${actual_khachtt}
    Should Be Equal As Numbers    ${get_giamgia_in_dh_af_execute}    ${final_discount}
    Should Be Equal As Numbers    ${get_tongcong_in_dh_af_execute}    ${result_khachcantra}
    Delete order frm Order code    ${order_code}
    Toggle status of promotion    ${input_khuyemmai}    0
    Toggle status of promotion    ${input_khuyemmai_add}    0
    Turn off allow use promotion combine in shop config

edg2
    [Arguments]    ${dict_product_nums}    ${input_gghd}    ${input_ma_kh}    ${input_bh_khachtt}    ${input_khuyemmai}    ${list_giveaway}
    ...    ${list_newprice}   ${input_khach_tt_to_create}   ${input_ma_thukhac}
    [Timeout]
    ## Get info ton cuoi, cong no khach hang
    ${surcharge_vnd_value}    Get surcharge vnd value    ${input_ma_thukhac}
    ${surcharge_%}    Get surcharge percentage value    ${input_ma_thukhac}
    Run Keyword If    ${surcharge_%} == 0    Toggle surcharge VND    ${input_ma_thukhac}    true
    ...    ELSE    Toggle surcharge percentage    ${input_ma_thukhac}    true
    Toggle status of promotion    ${input_khuyemmai}    1
    ${order_code}     Add new order with multi products    ${input_ma_kh}    ${dict_product_nums}    ${input_khach_tt_to_create}
    ${invoice_value}    ${received_value}    ${discount}    ${discount_ratio}    ${name}    Get Invoice value - Received value - Discounts - Promotion Name from Promotion Code    ${input_khuyemmai}
    #compute product
    ${list_product}    Get Dictionary Keys    ${dict_product_nums}
    ${list_nums}    Get Dictionary Values    ${dict_product_nums}
    ${list_product_promo}    Get Dictionary Keys    ${list_giveaway}
    ${list_nums_promo}    Get Dictionary Values    ${list_giveaway}
    ${get_ma_dh_in_dh_bf_execute}    ${get_khachdatra_in_dh_bf_execute}    ${get_ggdh_in_dh_bf_execute}    ${get_tongtienhang_in_dh_bf_execute}    ${get_tongcong_in_dh_bf_execute}    Get order code - paid - discount value frm API    ${input_ma_kh}
    ${get_list_hh_in_dh_bf_execute}    ${get_ghichu_bf_execute}    Get ghi chu and list product frm API    ${order_code}
    ${get_list_nums}   ${get_list_ordersummary_bf_execute}    Get list quantity - order summary frm API    ${order_code}    ${get_list_hh_in_dh_bf_execute}
    ${list_result_tongdh}    ${result_list_toncuoi}    ${result_list_thanhtien}    Get list order summary - total sale - ending stocks incase newprice    ${order_code}    ${get_list_hh_in_dh_bf_execute}    ${list_newprice}
    Reload Page
    #compute product promo
    ${get_list_baseprice}   Get list of Baseprice by Product Code    ${list_product_promo}
    ${get_list_onhand}   Get list of Onhand by Product Code    ${list_product_promo}
    ${result_thanhtien_promo}   Create List
    ${list_result_toncuoi_promo}   Create List
    :FOR    ${item_giaban}    ${item_nums}   ${item_onhand}   IN ZIP    ${get_list_baseprice}    ${list_nums_promo}    ${get_list_onhand}
    \     ${giaban}   Minus     ${item_giaban}    ${discount}
    \     ${thanhtien}    Multiplication and round     ${giaban}    ${item_nums}
    \     ${result_tonkho}    Minus   ${item_onhand}    ${item_nums}
    \     Append To List     ${result_thanhtien_promo}     ${thanhtien}
    \     Append To List     ${list_result_toncuoi_promo}     ${result_tonkho}
    # Input data into BH form
    Go to xu ly dat hang    ${order_code}
    Go to BH frm process order    ${order_code}
    : FOR    ${item_ma_hh}    ${item_giamoi}    IN ZIP    ${list_product}    ${list_newprice}
    \    Wait Until Keyword Succeeds    3 times    5 s    Input newprice for multi product    ${item_ma_hh}    ${item_giamoi}
    #compute
    ${result_tongtienhang}    Sum values in list    ${result_list_thanhtien}
    ${result_tongtienhang_promo}    Sum values in list    ${result_thanhtien_promo}
    ${result_tongtienhang}    Sum    ${result_tongtienhang}    ${result_tongtienhang_promo}
    ${result_tongtienhang_tru_gghd}    Minus and replace floating point    ${result_tongtienhang}    ${input_gghd}
    ${actual_surcharge_type}    Set Variable If    ${surcharge_%} == 0    ${surcharge_vnd_value}    ${surcharge_%}
    ${result_per_surchare_by_invoice}    Convert % discount to VND and round    ${result_tongtienhang_tru_gghd}    ${surcharge_%}
    ${actual_surcharge_value}    Set Variable If    ${surcharge_%} == 0    ${surcharge_vnd_value}    ${result_per_surchare_by_invoice}
    ${result_tongtienhang_tovalidate}    Sum    ${result_tongtienhang}    ${actual_surcharge_value}
    ${result_khachcantra}    Sum and replace floating point    ${result_tongtienhang_tru_gghd}    ${actual_surcharge_value}
    ${result_khachcantra}    Minus and replace floating point    ${result_khachcantra}    ${get_khachdatra_in_dh_bf_execute}
    ${actual_khachtt}    Set Variable If    '${input_bh_khachtt}' == 'all'    ${result_khachcantra}    ${input_bh_khachtt}
    ${result_khachdatra}      Sum     ${get_khachdatra_in_dh_bf_execute}    ${actual_khachtt}
    #create order
    Run Keyword If    ${result_tongtienhang} > ${invoice_value}    Wait Until Keyword Succeeds    3 times    8 s    Select promotion and giveaway product by search product    ${name}
    ...    ${list_product_promo}    ${list_nums_promo}    ELSE    Element Should Not Be Visible    ${icon_promo_sale}
    Wait Until Keyword Succeeds    3 times    8 s    Select one surcharge and get value frm xpath invoice    ${input_ma_thukhac}    ${actual_surcharge_value}    ${cell_surcharge_order}
    ...    ${cell_surcharge_value}
    Wait Until Keyword Succeeds    3 times    8 s    Input VND discount invoice    ${input_gghd}
    Run Keyword If    "${input_bh_khachtt}" == "all"    Click Element JS    ${button_bh_thanhtoan}
    ...    ELSE    Input customer payment into BH form    ${input_bh_khachtt}    ${result_khachcantra}
    SLeep    5s
    ${invoice_code}    Get saved code after execute
    #get values
    Sleep    20 s    wait for response to API
    #assert value product in invoice
    ${list_soluong_in_hd}    ${list_giatri_quydoi_in_hd}    Get list quantity and gia tri quy doi by invoice code    ${get_list_hh_in_dh_bf_execute}    ${invoice_code}
    : FOR    ${ma_hh}    ${result_toncuoi}    ${item_soluong}    ${get_giatri_quydoi}    IN ZIP    ${get_list_hh_in_dh_bf_execute}
    ...    ${result_list_toncuoi}    ${list_soluong_in_hd}    ${list_giatri_quydoi_in_hd}
    \    Run Keyword If    '${get_giatri_quydoi}' == '1'    Validate product history frm API    ${invoice_code}    ${ma_hh}    ${result_toncuoi}    ${item_soluong}
    \    ...    ELSE    Validate unit product history frm API    ${invoice_code}    ${ma_hh}    ${result_toncuoi}    ${item_soluong}    ${get_giatri_quydoi}
    #assert value product promo in invoice
    ${list_soluong_in_hd_promo}    ${list_giatri_quydoi_in_hd_promo}    Get list quantity and gia tri quy doi by invoice code    ${list_product_promo}    ${invoice_code}
    : FOR    ${ma_hh_promo}    ${result_toncuoi_promo}    ${item_soluong_promo}    ${get_giatri_quydoi_promo}    IN ZIP    ${list_product_promo}
    ...    ${list_result_toncuoi_promo}    ${list_soluong_in_hd_promo}    ${list_giatri_quydoi_in_hd_promo}
    \    Run Keyword If    '${get_giatri_quydoi}' == '1'    Validate product history frm API    ${invoice_code}    ${ma_hh_promo}    ${result_toncuoi_promo}    ${item_soluong_promo}
    \    ...    ELSE    Validate unit product history frm API    ${invoice_code}    ${ma_hh_promo}    ${result_toncuoi_promo}    ${item_soluong_promo}    ${get_giatri_quydoi_promo}
    #assert value product
    ${list_order_summary_af_execute}    Get list order summary by order code    ${order_code}
    : FOR    ${result_tong_dh}    ${order_summary_af_execute}    IN ZIP    ${list_result_tongdh}    ${list_order_summary_af_execute}
    \    Should Be Equal As Numbers    ${order_summary_af_execute}    ${result_tong_dh}
    #assert value invoice
    ${get_ma_kh_by_hd}    ${get_tong_tien_hang}    ${get_khachtt_af_execute}    ${get_gghd_af_execute}    ${get_khachcantra}    ${get_trangthai}    ${get_ghichu_in_hd_af_execute}
    ...    Get invoice info have note incase discount by invoice code    ${invoice_code}
    Should Be Equal As Numbers    ${get_tong_tien_hang}    ${result_tongtienhang_tovalidate}
    Should Be Equal As Numbers    ${get_khachcantra}    ${result_tongtienhang_tovalidate}
    Should Be Equal As Numbers    ${get_khachtt_af_execute}    ${result_khachdatra}
    Should Be Equal As Strings    ${get_ma_kh_by_hd}    ${input_ma_kh}
    Should Be Equal As Numbers    ${get_gghd_af_execute}    ${input_gghd}
    Should Be Equal As Strings    ${get_trangthai}    Hoàn thành
    #assert value order
    ${get_ma_kh_in_dh_af_execute}    ${get_TTDH_in_dh_af_execute}    ${get_tongtienhang_in_dh_af_exxecute}    ${get_khachdatra_in_dh_af_execute}    ${get_giamgia_in_dh_af_execute}    ${get_tongcong_in_dh_af_execute}    ${get_ghichu_in_dh_af_execute}
    ...    Get order info have note incase discount by order code    ${order_code}
    Should Be Equal As Strings    ${get_ma_kh_in_dh_af_execute}    ${input_ma_kh}
    Should Be Equal As Numbers    ${get_TTDH_in_dh_af_execute}    3    #trạng thái hoàn thành
    Should Be Equal As Numbers    ${get_tongtienhang_in_dh_af_exxecute}    ${get_tongtienhang_in_dh_bf_execute}
    Should Be Equal As Numbers    ${get_khachdatra_in_dh_af_execute}    ${result_khachdatra}
    Should Be Equal As Numbers    ${get_giamgia_in_dh_af_execute}    ${get_ggdh_in_dh_bf_execute}
    Should Be Equal As Numbers    ${get_tongcong_in_dh_af_execute}    ${get_tongcong_in_dh_bf_execute}
    Validate invoice history frm Order    ${order_code}    ${invoice_code}    ${result_tongtienhang_tovalidate}
    Delete invoice by invoice code    ${invoice_code}
    Delete order frm Order code    ${order_code}
    Run Keyword If    ${surcharge_%} == 0    Toggle surcharge VND    ${input_ma_thukhac}    false    ELSE    Toggle surcharge percentage    ${input_ma_thukhac}    false
    Toggle status of promotion    ${input_khuyemmai}    0

edg3
    [Arguments]    ${dict_product_nums_tocreate}  ${input_gghd}    ${input_ma_kh}    ${input_hoantratamung}   ${input_khuyenmai}    ${list_promo_product}
    ...   ${list_ggsp}    ${input_khtt_tocreate}    ${list_product_del}    ${input_thukhac1}    ${input_thukhac2}
    Set Selenium Speed    0.5s
    ${order_code}    Add new order have multi surcharge    ${input_ma_kh}    ${dict_product_nums_tocreate}    ${input_thukhac2}    ${input_thukhac1}    ${input_khtt_tocreate}
    #activate surcharge
    ${surcharge_value_1_vnd}    Get surcharge vnd value    ${input_thukhac1}
    ${surcharge_value_1_percentage}    Get surcharge percentage value    ${input_thukhac1}
    ${surcharge_value_2_vnd}    Get surcharge vnd value    ${input_thukhac2}
    ${surcharge_value_2_percentage}    Get surcharge percentage value    ${input_thukhac2}
    ${actual_surcharge1_value}    Set Variable If    ${surcharge_value_1_percentage} == 0    ${surcharge_value_1_vnd}    ${surcharge_value_1_percentage}
    ${actual_surcharge2_value}    Set Variable If    ${surcharge_value_2_percentage} == 0    ${surcharge_value_2_vnd}    ${surcharge_value_2_percentage}
    Run Keyword If    ${actual_surcharge1_value} > 100    Toggle surcharge VND    ${input_thukhac1}    true
    ...    ELSE    Toggle surcharge percentage    ${input_thukhac1}    true
    Run Keyword If    ${actual_surcharge2_value} > 100    Toggle surcharge VND    ${input_thukhac2}    true
    ...    ELSE    Toggle surcharge percentage    ${input_thukhac2}    true
    Toggle status of promotion    ${input_khuyenmai}    1
    ${invoice_value}    ${received_value}    ${discount}    ${discount_ratio}    ${name}    Get Invoice value - Received value - Discounts - Promotion Name from Promotion Code    ${input_khuyenmai}
    #get info product, customer
    ${list_product_promo}    Get Dictionary Keys    ${list_promo_product}
    ${list_nums_promo}    Get Dictionary Values    ${list_promo_product}
    ${list_produc}    Get Dictionary Keys    ${list_product_del}
    ${list_nums_del}    Get Dictionary Values    ${list_product_del}
    ${get_khachdatra_in_dh_bf_execute}    ${get_tongtienhang_in_dh_bf_execute}    Get paid value frm API    ${order_code}
    ${get_list_hh_in_dh_bf_execute}    ${get_list_nums_in_dh}    Get list product and quantity frm API    ${order_code}
    ${list_result_tongdh_delete}    Get list order summary frm product API    ${list_product_del}
    #get order summary and sub total of products
    : FOR    ${ma_hh}   ${item_nums}    IN ZIP    ${list_product_del}    ${list_nums_del}
    \    Remove Values From List    ${get_list_hh_in_dh_bf_execute}    ${ma_hh}
    \    Remove Values From List    ${get_list_nums_in_dh}    ${item_nums}
    Log    ${get_list_hh_in_dh_bf_execute}
    ${list_result_tongdh}    ${result_list_toncuoi}    ${result_list_thanhtien}    ${list_result_giamoi}    Get list order summary - total sale - ending stocks incase discount    ${order_code}    ${get_list_hh_in_dh_bf_execute}
    ...    ${list_ggsp}
    #compute product promo
    ${get_list_baseprice}   Get list of Baseprice by Product Code    ${list_product_promo}
    ${get_list_product_type}    ${list_tonkho_service}    Get list product type and ending stock of service frm API    ${list_product_promo}
    ${result_thanhtien_promo}   Create List
    ${list_result_toncuoi_promo}   Create List
    :FOR    ${item_giaban}    ${item_nums}   ${item_onhand}   IN ZIP    ${get_list_baseprice}    ${list_nums_promo}    ${list_tonkho_service}
    \     ${giaban}   Price after % discount product     ${item_giaban}    ${discount_ratio}
    \     ${thanhtien}    Multiplication and round     ${giaban}    ${item_nums}
    \     ${result_tonkho}    Minus   ${item_onhand}    ${item_nums}
    \     Append To List     ${result_thanhtien_promo}     ${thanhtien}
    \     Append To List     ${list_result_toncuoi_promo}     ${result_tonkho}
    #compute TTH with product
    ${result_tongtienhang}    Sum values in list    ${result_list_thanhtien}
    ${result_tongtienhang_promo}    Sum values in list    ${result_thanhtien_promo}
    ${result_tongtienhang}    Sum    ${result_tongtienhang}    ${result_tongtienhang_promo}
    ${result_TTH_tru_gghd}  Minus and replace floating point    ${result_tongtienhang}    ${input_gghd}
    ${result_khachdatra}    Minus and replace floating point    ${result_tongtienhang}    ${get_khachdatra_in_dh_bf_execute}
    ${total_surcharge}=    Run Keyword If    ${actual_surcharge1_value} > 100 and ${actual_surcharge2_value} > 100    Sum    ${actual_surcharge1_value}    ${actual_surcharge2_value}
    ...    ELSE IF    ${actual_surcharge1_value} > 100 and ${actual_surcharge2_value} < 100    VND and Percentage Surcharges sum    ${actual_surcharge2_value}    ${result_tongtienhang}    ${actual_surcharge1_value}
    ...    ELSE IF    ${actual_surcharge1_value} < 100 and ${actual_surcharge2_value} < 100    Percentage and Percentage Surcharges sum    ${result_tongtienhang}    ${actual_surcharge1_value}    ${actual_surcharge2_value}
    ...    ELSE    Log    abv
    ${result_tongtienhang_tovalidate}    Sum    ${result_TTH_tru_gghd}    ${total_surcharge}
    ${tamung}    Minus and replace floating point    ${get_khachdatra_in_dh_bf_execute}    ${result_tongtienhang}
    ${result_tamung}    Set Variable If    '${input_hoantratamung}' == 'all'    ${tamung}    ${input_hoantratamung}
    ${result_khachdatra_in_dh}    Minus    ${get_khachdatra_in_dh_bf_execute}    ${result_tamung}
    #create invoice from order
    Go to xu ly dat hang    ${order_code}
    Go to BH frm process order    ${order_code}
    Reload page
    Delete list product into BH form    ${list_product_del}
    : FOR    ${item_product}    ${item_ggsp}    ${newprice}    IN ZIP    ${get_list_hh_in_dh_bf_execute}    ${list_ggsp}    ${list_result_giamoi}
    \    Wait Until Keyword Succeeds    3 times    20 s    Input % discount for multi product    ${item_product}    ${item_ggsp}    ${newprice}
    Run Keyword If    ${result_tongtienhang} > ${invoice_value}    Wait Until Keyword Succeeds    3 times    8 s    Select promotion and giveaway product by search product    ${name}
    ...    ${list_product_promo}    ${list_nums_promo}    ELSE    Element Should Not Be Visible    ${icon_promo_sale}
    Wait Until Keyword Succeeds    3 times    20 s    Input VND discount invoice    ${input_gghd}
    Wait Until Keyword Succeeds    3 times    20 s    Input customer payment and deposit refund into BH form    ${input_hoantratamung}
    Wait Until Page Contains Element    ${button_cancel}    2 mins
    Wait Until Keyword Succeeds    3 times    20 s    Click Element JS    ${button_cancel}    #tắt popup kết thúc đơn ĐH
    Invoice message success validation
    ${invoice_code}    Get saved code after execute
    #get value
    Sleep    20s    wait for response to API
    #assert value product in invoice
    ${list_soluong_in_hd}    ${list_giatri_quydoi_in_hd}    Get list quantity and gia tri quy doi by invoice code    ${get_list_hh_in_dh_bf_execute}    ${invoice_code}
    : FOR    ${ma_hh}    ${result_toncuoi}    ${item_soluong}    ${get_giatri_quydoi}    IN ZIP    ${get_list_hh_in_dh_bf_execute}
    ...    ${result_list_toncuoi}    ${list_soluong_in_hd}    ${list_giatri_quydoi_in_hd}
    \    Run Keyword If    '${get_giatri_quydoi}' == '1'    Validate product history frm API    ${invoice_code}    ${ma_hh}    ${result_toncuoi}    ${item_soluong}
    \    ...    ELSE    Validate unit product history frm API    ${invoice_code}    ${ma_hh}    ${result_toncuoi}
    \    ...    ${item_soluong}    ${get_giatri_quydoi}
    #assert value product promo in invoice
    ${list_soluong_in_hd_promo}    ${list_giatri_quydoi_in_hd_promo}    Get list quantity and gia tri quy doi by invoice code    ${list_product_promo}    ${invoice_code}
    : FOR    ${ma_hh_promo}    ${result_toncuoi_promo}    ${item_soluong_promo}    ${get_giatri_quydoi_promo}    IN ZIP    ${list_product_promo}
    ...    ${list_result_toncuoi_promo}    ${list_soluong_in_hd_promo}    ${list_giatri_quydoi_in_hd_promo}
    \    Run Keyword If    '${get_giatri_quydoi}' == '1'    Validate product history frm API    ${invoice_code}    ${ma_hh_promo}    ${result_toncuoi_promo}    ${item_soluong_promo}
    \    ...    ELSE    Validate unit product history frm API    ${invoice_code}    ${ma_hh_promo}    ${result_toncuoi_promo}    ${item_soluong_promo}    ${get_giatri_quydoi_promo}
    #validate deleted product
    ${list_order_summary_delete_af_execute}    Get list order summary frm product API    ${list_product_del}
    : FOR    ${result_tong_dh_delete}    ${order_summary_delete_af_execute}    IN ZIP    ${list_result_tongdh_delete}    ${list_order_summary_delete_af_execute}
    \    Should Be Equal As Numbers    ${result_tong_dh_delete}    ${order_summary_delete_af_execute}
    #validate product
    ${list_order_summary_af_execute}    Get list order summary frm product API    ${get_list_hh_in_dh_bf_execute}
    : FOR    ${result_tong_dh}    ${order_summary_af_execute}    IN ZIP    ${list_result_tongdh}    ${list_order_summary_af_execute}
    \    Should Be Equal As Numbers    ${order_summary_af_execute}    ${result_tong_dh}
    #assert value invoice
    ${get_ma_kh_by_hd}    ${get_tong_tien_hang}    ${get_khach_tt}    ${get_trangthai}    ${get_ghichu_in_hd_af_execute}    Get invoice info have note by invoice code    ${invoice_code}
    Should Be Equal As Numbers    ${get_tong_tien_hang}    ${result_tongtienhang_tovalidate}
    Should Be Equal As Numbers    ${get_khach_tt}    ${result_tongtienhang_tovalidate}
    Should Be Equal As Strings    ${get_ma_kh_by_hd}    ${input_ma_kh}
    Should Be Equal As Strings    ${get_trangthai}    Hoàn thành
    Should Be Equal As Strings    ${get_ghichu_in_hd_af_execute}    0
    #assert value order
    ${get_ma_kh_in_dh_af_execute}    ${get_TTDH_in_dh_af_execute}    ${get_tongtienhang_in_dh_af_exxecute}    ${get_khachdatra_in_dh_af_execute}    ${get_ghichu_af_execute}    Get order info have note by order code    ${order_code}
    Should Be Equal As Strings    ${get_ma_kh_in_dh_af_execute}    ${input_ma_kh}
    Should Be Equal As Strings    ${get_TTDH_in_dh_af_execute}    2    #trạng thái đang giao hàng
    Should Be Equal As Numbers    ${get_tongtienhang_in_dh_af_exxecute}    ${get_tongtienhang_in_dh_bf_execute}
    Should Be Equal As Numbers    ${get_khachdatra_in_dh_af_execute}    ${result_khachdatra_in_dh}
    Should Be Equal As Strings    ${get_ghichu_af_execute}    0
    Validate invoice history frm Order    ${order_code}    ${invoice_code}    ${result_tongtienhang_tovalidate}
    ## Deactivate surcharge
    Delete invoice by invoice code    ${invoice_code}
    Delete order frm Order code    ${order_code}
    Run Keyword If    ${actual_surcharge1_value} > 100    Toggle surcharge VND    ${input_thukhac1}    false
    ...    ELSE    Toggle surcharge percentage    ${input_thukhac1}    false
    Run Keyword If    ${actual_surcharge2_value} > 100    Toggle surcharge VND    ${input_thukhac2}    false
    ...    ELSE    Toggle surcharge percentage    ${input_thukhac2}    false
    Toggle status of promotion    ${input_khuyenmai}    0
