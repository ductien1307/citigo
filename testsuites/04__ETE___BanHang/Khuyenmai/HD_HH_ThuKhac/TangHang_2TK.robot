*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}      ${headless_browser}
Test Setup        Before Test Ban Hang
Test Teardown     After Test
Resource          ../../../../core/Ban_Hang/banhang_action.robot
Resource          ../../../../core/Ban_Hang/banhang_getandcompute.robot
Resource          ../../../../core/share/toast_message.robot
Resource          ../../../../core/Ban_Hang/banhang_navigation.robot
Resource          ../../../../core/API/api_danhmuc_hanghoa.robot
Resource          ../../../../core/API/api_khachhang.robot
Resource          ../../../../core/API/api_hoadon_banhang.robot
Resource          ../../../../core/API/api_soquy.robot
Resource          ../../../../core/So_Quy/so_quy_list_action.robot
Resource          ../../../../config/env_product/envi.robot
Resource          ../../../../core/share/list_dictionary.robot
Resource          ../../../../core/share/discount.robot
Resource          ../../../../core/API/api_thietlap.robot

*** Variables ***
&{invoice_1}      IM20=1
&{invoice_1_giveaway}      	PHH01=1
&{discount_1}      IM20=5000000
&{discount_type1}      IM20=changeup
&{invoice1_product_type}      IM20=imei

*** Test Cases ***    Product and num list    Product Discount                                                    Invoice Discount    Customer    Payment    Promotion Code          Dict Product Promo        Surcharge Code1      Surcharge Code2
KM HD_HH_Tang          [Tags]                   CONPROTK                                  UEB1
                      [Template]              km_inv_prod_14
                      ${invoice_1}            ${invoice1_product_type}          ${discount_1}         ${discount_type1}          5              KH036        all            KM014            ${invoice_1_giveaway}           TK003           TK007

*** Keywords ***
km_inv_prod_14
    [Arguments]    ${dict_product_num}    ${dict_product_type}      ${dict_discount}      ${dict_discount_type}      ${input_invoice_discount}    ${input_bh_ma_kh}    ${input_bh_khachtt}         ${input_khuyemmai}      ${dict_promo_product}          ${input_thukhac1}    ${input_thukhac2}
    Log         Thu khac
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
    Log         Promo
    Toggle status of promotion    ${input_khuyemmai}    1
    ${invoice_value}    ${received_value}    ${discount}    ${discount_ratio}    ${name}    Get Invoice value - Received value - Discounts - Promotion Name from Promotion Code    ${input_khuyemmai}
    ${list_products}    Get Dictionary Keys    ${dict_product_num}
    ${list_nums}    Get Dictionary Values    ${dict_product_num}
    ${list_product_type}    Get Dictionary Values    ${dict_product_type}
    ${list_discount_product}    Get Dictionary Values    ${dict_discount}
    ${list_discount_type}    Get Dictionary Values    ${dict_discount_type}
    ${list_promo_product}       Get Dictionary Keys        ${dict_promo_product}
    ${list_promo_num}      Get Dictionary Values       ${dict_promo_product}
    ${get_no_bf_execute}    ${get_tongban_bf_execute}    ${get_tongban_tru_trahang_bf_execute}    ${get_customer_name}    Get Customer Info from API    ${input_bh_ma_kh}
    Log      Create list imei for imei products
    ${list_imei_all}    create list
    : FOR    ${item_product}     ${item_num}    ${item_product_type}    IN ZIP    ${list_products}    ${list_nums}      ${list_product_type}
    \    ${list_imei_by_single_product}=      Run Keyword If    '${item_product_type}' == 'imei'      Import multi imei for product    ${item_product}    ${item_num}      ELSE      Set Variable    nonimei
    \    Append to List       ${list_imei_all}        ${list_imei_by_single_product}
    Log       ${list_imei_all}
    ${list_imei_for_validation}      Copy list      ${list_imei_all}
    Remove values From List      ${list_imei_for_validation}        nonimei
    ${list_product_for_validation}       ${list_product_quan_for_validation}     ${list_product_type_for_validation}       Remove combo and unit from validation lists    ${list_products}    ${list_nums}    ${list_product_type}
    ${list_product_for_validation}       ${list_product_quan_for_validation}     ${list_product_type_for_validation}       Extract combo and unit products for validation lists        ${list_products}    ${list_nums}    ${list_product_type}       ${list_product_for_validation}       ${list_product_quan_for_validation}     ${list_product_type_for_validation}
    ${list_result_ton_af_ex}        Get list of result onhand incase changing product price    ${list_product_for_validation}    ${list_product_quan_for_validation}
    ${list_result_thanhtien}      ${list_result_newprice}    Get list of total sale - result new price incase changing product price    ${list_products}    ${list_nums}    ${list_discount_product}      ${list_discount_type}
    Sleep     30 s
    Reload Page
    Log       Input data into BH form
    ${lastest_num}    Set Variable    0
    : FOR    ${item_product}     ${item_product_type}       ${item_num}        ${item_list_imei}    ${item_discount}      ${item_discount_type}     ${item_newprice}    IN ZIP    ${list_products}       ${list_product_type}
    ...    ${list_nums}    ${list_imei_all}       ${list_discount_product}    ${list_discount_type}      ${list_result_newprice}
    \    ${lastest_num}=        Run Keyword If    '${item_product_type}' == 'imei'    Input products - IMEIs and validate lastest number in BH form    ${item_product}    ${item_num}      ${item_list_imei}    ${lastest_num}     ELSE      Input product-num in BH form    ${item_product}    ${item_num}      ${lastest_num}
    \    Run keyword if    '${item_discount_type}' == 'dis'    Wait Until Keyword Succeeds    3 times    5 s    Input % discount for product    ${item_discount}    ${item_newprice}
    \    ...    ELSE IF    '${item_discount_type}' == 'disvnd'    Wait Until Keyword Succeeds    3 times    5 s    Input vnd discount for product    ${item_discount}    ${item_newprice}
    \    ...    ELSE IF     '${item_discount_type}' == 'changeup' or '${item_discount_type}' == 'changedown'  Wait Until Keyword Succeeds    3 times    5 s    Input new price of product    ${item_discount}        ELSE       Log        ignore
    ${result_tongtienhang}    Sum values in list    ${list_result_thanhtien}
    ${result_discount_invoice_by_vnd}=    Run Keyword If       0 < ${input_invoice_discount} < 100       Convert % discount to VND and round    ${result_tongtienhang}    ${input_invoice_discount}        ELSE        Set Variable    ${input_invoice_discount}
    ${result_totalinvoice_af_discount}       Minus       ${result_tongtienhang}        ${result_discount_invoice_by_vnd}
    ${total_surcharge}=    Run Keyword If    ${actual_surcharge1_value} > 100 and ${actual_surcharge2_value} > 100    Sum    ${actual_surcharge1_value}    ${actual_surcharge2_value}
    ...    ELSE IF    ${actual_surcharge1_value} > 100 and ${actual_surcharge2_value} < 100    VND and Percentage Surcharges sum    ${actual_surcharge2_value}    ${result_totalinvoice_af_discount}    ${actual_surcharge1_value}
    ...    ELSE IF    ${actual_surcharge1_value} < 100 and ${actual_surcharge2_value} < 100    Percentage and Percentage Surcharges sum    ${result_totalinvoice_af_discount}    ${actual_surcharge1_value}    ${actual_surcharge2_value}
    ...    ELSE IF    ${actual_surcharge1_value} < 100 and ${actual_surcharge2_value} > 100    VND and Percentage Surcharges sum    ${actual_surcharge1_value}    ${result_totalinvoice_af_discount}    ${actual_surcharge2_value}
    ...    ELSE       Log       Ignore
    ${result_total_invoice_incl_surcharge}       Sum        ${result_tongtienhang}      ${total_surcharge}
    ${result_khachcantra}    Sum    ${result_totalinvoice_af_discount}    ${total_surcharge}
    ${actual_khachtt}    Set Variable If    '${input_bh_khachtt}' == 'all'    ${result_khachcantra}    ${input_bh_khachtt}
    ${result_no_hoadon}    Minus    ${result_khachcantra}    ${actual_khachtt}
    ${result_nohientai}    sum    ${result_no_hoadon}    ${get_no_bf_execute}
    ${result_tongban}    Sum    ${result_khachcantra}    ${get_tongban_bf_execute}
    Wait Until Keyword Succeeds    3 times    8 s    Input Customer and validate    ${input_bh_ma_kh}    ${get_customer_name}
    Run Keyword If    ${result_tongtienhang} > ${invoice_value}    Wait Until Keyword Succeeds    3 times    8 s    Select promotion and giveaway product by search product    ${name}
    ...    ${list_promo_product}    ${list_promo_num}
    ...    ELSE    Element Should Not Be Visible    ${icon_promo_sale}
    Run Keyword If    0 < ${input_invoice_discount} < 100    Wait Until Keyword Succeeds    3 times    8 s    Input % discount invoice    ${input_invoice_discount}
    ...    ${result_discount_invoice_by_vnd}
    ...    ELSE IF    ${input_invoice_discount} > 100    Input VND discount invoice    ${input_invoice_discount}
    ...    ELSE    Log    Ignore discount
    Wait Until Keyword Succeeds    3 times    8 s    Select two surcharge by pressing Enter    ${input_thukhac1}    ${input_thukhac2}    ${total_surcharge}
    ...    ${cell_surcharge_value}
    Run Keyword If    '${input_bh_khachtt}' != 'all'    Input payment info    ${input_bh_khachtt}    ${result_khachcantra}
    ...    ELSE    Log    abc
    Click Element JS    ${button_bh_thanhtoan}
    Invoice message success validation
    ${invoice_code}    Get saved code after execute
    #get values
    Sleep    20 s    wait for response to API
    #assert values in Hoa don
    ${get_ma_kh_by_hd}    ${get_tong_tien_hang}    ${get_khach_tt}    ${get_giamgia_hd}    ${get_khachcantra}    ${get_trangthai}    Get invoice info incase discount by invoice code
    ...    ${invoice_code}
    Should Be Equal As Numbers    ${get_tong_tien_hang}    ${result_total_invoice_incl_surcharge}
    Should Be Equal As Numbers    ${get_khachcantra}    ${result_khachcantra}
    Should Be Equal As Numbers    ${get_khach_tt}    ${actual_khachtt}
    Should Be Equal As Strings    ${get_ma_kh_by_hd}    ${input_bh_ma_kh}
    Should Be Equal As Numbers    ${get_giamgia_hd}    ${result_discount_invoice_by_vnd}
    Should Be Equal As Strings    ${get_trangthai}    Hoàn thành
    #Assert values in product list and stock card
    Toggle status of promotion    ${input_khuyemmai}    0
    Reload Page
    Delete invoice by invoice code    ${invoice_code}
