*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}      ${headless_browser}
Test Setup        Before Test Ban Hang
Test Teardown     After Test
Resource          ../../../../../core/Ban_Hang/banhang_action.robot
Resource          ../../../../../core/Ban_Hang/banhang_getandcompute.robot
Resource          ../../../../../core/share/toast_message.robot
Resource          ../../../../../core/Ban_Hang/banhang_navigation.robot
Resource          ../../../../../core/API/api_danhmuc_hanghoa.robot
Resource          ../../../../../core/API/api_khachhang.robot
Resource          ../../../../../core/API/api_hoadon_banhang.robot
Resource          ../../../../../core/API/api_soquy.robot
Resource          ../../../../../core/So_Quy/so_quy_list_action.robot
Resource          ../../../../../config/env_product/envi.robot
Resource          ../../../../../core/share/list_dictionary.robot
Resource          ../../../../../core/share/discount.robot
Resource          ../../../../../core/API/api_thietlap.robot

*** Variables ***
&{invoice_1}      PIB10034=6.5    IM17=2
&{discount_1}      PIB10034=10    IM17=0
&{discount_type1}      PIB10034=dis    IM17=none
&{product_type1}      PIB10034=pro    IM17=imei
&{invoice_3}      IM18=2   PIB10035=1
&{invoice_1_giveaway}      	DVT0215=1
&{discount_3}      IM18=7    PIB10035=6000
&{discount_type3}      IM18=dis   PIB10035=disvnd
&{invoice1_product_type}      IM18=imei   PIB10035=pro
&{invoice_2}      DV037=12
&{invoice_2_giveaway}      	DVT0215=1
&{discount_2}      DV037=55000.6
&{discount_type2}      DV037=disvnd
&{invoice2_product_type}      DV037=ser

*** Test Cases ***    Product and num list    Product Discount                                                    Invoice Discount    Customer    Payment    Promotion Code
KM HD_HH_GiamgiaHD          [Tags]        AUPB
                      [Template]              kmtd01
                      ${invoice_1}            ${product_type1}          ${discount_1}         ${discount_type1}          5                   KH031        0            KM012

KM HD_HH_GiamgiaSP          [Tags]        AUPB
                      [Template]              kmtd02
                      ${invoice_3}            ${invoice1_product_type}          ${discount_3}         ${discount_type3}          10              KH032        all            KM015            ${invoice_1_giveaway}

KM HD_HH_Tang          [Tags]             AUPB
                      [Template]              kmtd03
                      ${invoice_2}            ${invoice2_product_type}          ${discount_2}         ${discount_type2}          100000              KH033        200000            KM014            ${invoice_2_giveaway}


*** Keywords ***
kmtd01
    [Arguments]    ${dict_product_num}    ${dict_product_type}      ${dict_discount}      ${dict_discount_type}      ${input_invoice_discount}    ${input_bh_ma_kh}    ${input_bh_khachtt}     ${input_khuyemmai}
    Turn on allow use auto promotion invoice in shop config
    Toggle status of promotion    ${input_khuyemmai}    1
    ${invoice_value}    ${discount}    ${discount_ratio}    ${name}    Get Invoice value - Discounts - Promotion Name from Promotion Code    ${input_khuyemmai}
    ${list_products}    Get Dictionary Keys    ${dict_product_num}
    ${list_nums}    Get Dictionary Values    ${dict_product_num}
    ${list_product_type}    Get Dictionary Values    ${dict_product_type}
    ${list_discount_product}    Get Dictionary Values    ${dict_discount}
    ${list_discount_type}    Get Dictionary Values    ${dict_discount_type}
    ${list_unit}       Get list of keys from dictionary by value    ${dict_product_type}      unit
    ${list_imei_product}       Get list of keys from dictionary by value    ${dict_product_type}      imei
    ${list_unit_quan}=       Get list of values from dictionary by list of keys    ${dict_product_num}    ${list_unit}
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
    Validate UI Total Invoice value    ${result_tongtienhang}
    ${result_discount_invoice_by_vnd}    Run Keyword If    0 < ${input_invoice_discount} < 100    Convert % discount to VND and round    ${result_tongtienhang}    ${input_invoice_discount}
    ...    ELSE    Set Variable    ${input_invoice_discount}
    ${result_af_invoice_discount}    Minus    ${result_tongtienhang}    ${result_discount_invoice_by_vnd}
    ${actual_promo_discount_value}=    Run Keyword If     ${discount_ratio} != 0      Convert % discount to VND and round    ${result_tongtienhang}    ${discount_ratio}      ELSE     Set Variable    ${discount}
    ${final_discount}=    Run Keyword If    ${result_tongtienhang} > ${invoice_value}    Sum    ${actual_promo_discount_value}    ${result_discount_invoice_by_vnd}
    ...    ELSE    Set Variable    ${result_discount_invoice_by_vnd}
    ${result_khachcantra}    Minus    ${result_tongtienhang}    ${final_discount}
    ${actual_khachtt}    Set Variable If    '${input_bh_khachtt}' == 'all'    ${result_khachcantra}    ${input_bh_khachtt}
    ${result_no_hoadon}    Minus    ${result_khachcantra}    ${actual_khachtt}
    ${result_nohientai}    sum    ${result_no_hoadon}    ${get_no_bf_execute}
    ${result_tongban}    Sum    ${result_khachcantra}    ${get_tongban_bf_execute}
    Wait Until Keyword Succeeds    3 times    8 s    Input Customer and validate    ${input_bh_ma_kh}    ${get_customer_name}
    Run Keyword If    0 < ${input_invoice_discount} < 100    Wait Until Keyword Succeeds    3 times    8 s    Input % discount invoice    ${input_invoice_discount}
    ...    ${final_discount}
    ...    ELSE IF    ${input_invoice_discount} > 100    Input VND discount invoice incase promotion discount    ${input_invoice_discount}       ${final_discount}
    ...    ELSE    Log    Ignore discount
    Run Keyword If    '${input_bh_khachtt}' != 'all'    Input payment info    ${input_bh_khachtt}    ${result_no_hoadon}
    ...    ELSE    Log    abc
    Click Element JS    ${button_bh_thanhtoan}
    Invoice message success validation
    ${invoice_code}    Get saved code after execute
    #get values
    Sleep    20 s    wait for response to API
    Turn off allow use auto promotion invoice in shop config
    #assert values in Hoa don
    ${get_ma_kh_by_hd}    ${get_tong_tien_hang}    ${get_khach_tt}    ${get_giamgia_hd}    ${get_khachcantra}    ${get_trangthai}    Get invoice info incase discount by invoice code
    ...    ${invoice_code}
    Should Be Equal As Numbers    ${get_tong_tien_hang}    ${result_tongtienhang}
    Should Be Equal As Numbers    ${result_khachcantra}    ${get_khachcantra}
    Should Be Equal As Numbers    ${get_khach_tt}    ${actual_khachtt}
    Should Be Equal As Strings    ${get_ma_kh_by_hd}    ${input_bh_ma_kh}
    Should Be Equal As Numbers    ${get_giamgia_hd}    ${final_discount}
    Should Be Equal As Strings    ${get_trangthai}    Hoàn thành
    #Assert values in product list and stock card
    Assert list of Onhand after execute in case having multi-product types      ${list_product_for_validation}    ${list_product_type_for_validation}       ${list_result_ton_af_ex}
    #assert value in tab cong no khach hang
    ${get_maphieu_soquy}    Get Ma Phieu Thu in So quy    ${invoice_code}
    Run Keyword If    '${input_bh_khachtt}' == '0'    Validate status in Tab No can thu tu khach if Invoice is not paid until success    ${input_bh_ma_kh}    ${invoice_code}
    ...    ELSE    Validate status in Tab No can thu tu khach if Invoice is paid until success    ${input_bh_ma_kh}    ${get_maphieu_soquy}    ${invoice_code}
    #assert values in Khach hang and So quy
    ${get_no_af_purchase}    ${get_tongban_af_purchase}    ${get_tongban_tru_trahang_af_purchase}    Get Customer Debt from API after purchase    ${input_bh_ma_kh}    ${invoice_code}    ${actual_khachtt}
    Should Be Equal As Numbers    ${result_nohientai}    ${get_no_af_purchase}
    Should Be Equal As Numbers    ${result_tongban}    ${get_tongban_af_purchase}
    Run Keyword If    '${input_bh_khachtt}' == '0'    Validate So quy info from Rest API if Invoice is not paid until success    ${get_maphieu_soquy}
    ...    ELSE    Validate So quy info from Rest API if Invoice is paid until success    ${get_maphieu_soquy}    ${actual_khachtt}
    Toggle status of promotion    ${input_khuyemmai}    0
    #Delete invoice by invoice code    ${invoice_code}
    Reload Page

kmtd02
    [Arguments]    ${dict_product_num}    ${dict_product_type}      ${dict_discount}      ${dict_discount_type}      ${input_invoice_discount}    ${input_bh_ma_kh}    ${input_bh_khachtt}         ${input_khuyemmai}      ${dict_promo_product}
    Turn on allow use auto promotion invoice in shop config
    Toggle status of promotion    ${input_khuyemmai}    1
    ${invoice_value}    ${discount}    ${discount_ratio}    ${name}    Get Invoice value - Product Discounts - Promotion Name from Promotion Code      ${input_khuyemmai}
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
    Turn off allow use promotion combine in shop config
    Reload Page
    # Promo products
    ${list_result_totalsale_promo}    ${list_result_onhand_promo}    Run keyword if    ${discount} != 0    Get list of total sale - result onhand in case discount product    ${list_promo_product}    ${list_promo_num}
    ...    ${discount}
    ...    ELSE    Get list of total sale - result onhand in case discount product    ${list_promo_product}    ${list_promo_num}    ${discount_ratio}
    ${total_promo_sale}    Sum values in list    ${list_result_totalsale_promo}
    Log       Input data into BH form
    ${lastest_num}    Set Variable    0
    : FOR    ${item_product}     ${item_product_type}       ${item_num}        ${item_list_imei}    ${item_discount}      ${item_discount_type}     ${item_newprice}    IN ZIP    ${list_products}       ${list_product_type}
    ...    ${list_nums}    ${list_imei_all}       ${list_discount_product}    ${list_discount_type}      ${list_result_newprice}
    \    ${lastest_num}=        Run Keyword If    '${item_product_type}' == 'imei'    Input products - IMEIs and validate lastest number in BH form    ${item_product}    ${item_num}      ${item_list_imei}    ${lastest_num}     ELSE      Input product-num in BH form    ${item_product}    ${item_num}      ${lastest_num}
    \    Run keyword if    '${item_discount_type}' == 'dis'    Wait Until Keyword Succeeds    3 times    5 s    Input % discount for product    ${item_discount}    ${item_newprice}
    \    ...    ELSE IF    '${item_discount_type}' == 'disvnd'    Wait Until Keyword Succeeds    3 times    5 s    Input vnd discount for product    ${item_discount}    ${item_newprice}
    \    ...    ELSE IF     '${item_discount_type}' == 'changeup' or '${item_discount_type}' == 'changedown'  Wait Until Keyword Succeeds    3 times    5 s    Input new price of product    ${item_discount}        ELSE       Log        ignore
    ${result_tongtienhang}    Sum values in list    ${list_result_thanhtien}
    Validate UI Total Invoice value    ${result_tongtienhang}
    ${actual_tongtienhang_incl_promo}    Run Keyword If    ${result_tongtienhang} > ${invoice_value}    Sum    ${result_tongtienhang}    ${total_promo_sale}      ELSE     Set Variable     ${result_tongtienhang}
    ${result_discount_invoice_by_vnd}    Run Keyword If    0 < ${input_invoice_discount} < 100    Convert % discount to VND and round    ${actual_tongtienhang_incl_promo}    ${input_invoice_discount}
    ...    ELSE    Set Variable    ${input_invoice_discount}
    ${result_af_invoice_discount}    Minus    ${actual_tongtienhang_incl_promo}    ${result_discount_invoice_by_vnd}
    ${actual_khachtt}    Run Keyword If    '${input_bh_khachtt}' == 'all'    Set Variable    ${result_af_invoice_discount}    ELSE       Set Variable     ${input_bh_khachtt}
    ${result_khachcantra}    Minus    ${actual_tongtienhang_incl_promo}    ${result_discount_invoice_by_vnd}
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
    Run Keyword If    '${input_bh_khachtt}' != 'all'    Input payment info    ${input_bh_khachtt}    ${result_khachcantra}
    ...    ELSE    Log    abc
    Click Element JS    ${button_bh_thanhtoan}
    Invoice message success validation
    ${invoice_code}    Get saved code after execute
    #get values
    Sleep    20 s    wait for response to API
    Turn off allow use auto promotion invoice in shop config
    #assert values in Hoa don
    ${get_ma_kh_by_hd}    ${get_tong_tien_hang}    ${get_khach_tt}    ${get_giamgia_hd}    ${get_khachcantra}    ${get_trangthai}    Get invoice info incase discount by invoice code
    ...    ${invoice_code}
    Should Be Equal As Numbers    ${get_tong_tien_hang}    ${actual_tongtienhang_incl_promo}
    Should Be Equal As Numbers    ${get_khachcantra}    ${result_khachcantra}
    Should Be Equal As Numbers    ${get_khach_tt}    ${actual_khachtt}
    Should Be Equal As Strings    ${get_ma_kh_by_hd}    ${input_bh_ma_kh}
    Should Be Equal As Numbers    ${get_giamgia_hd}    ${result_discount_invoice_by_vnd}
    Should Be Equal As Strings    ${get_trangthai}    Hoàn thành
    #Assert values in product list and stock card
    Assert list of Onhand after execute in case having multi-product types      ${list_product_for_validation}    ${list_product_type_for_validation}       ${list_result_ton_af_ex}
    Toggle status of promotion    ${input_khuyemmai}    0
    Delete invoice by invoice code    ${invoice_code}

kmtd03
    [Arguments]    ${dict_product_num}    ${dict_product_type}      ${dict_discount}      ${dict_discount_type}      ${input_invoice_discount}    ${input_bh_ma_kh}    ${input_bh_khachtt}         ${input_khuyemmai}      ${dict_promo_product}
    Turn on allow use auto promotion invoice in shop config
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
    ${result_discount_invoice_by_vnd}    Run Keyword If    0 < ${input_invoice_discount} < 100    Convert % discount to VND and round    ${result_tongtienhang}    ${input_invoice_discount}
    ...    ELSE    Set Variable    ${input_invoice_discount}
    ${result_khachcantra}    Minus    ${result_tongtienhang}    ${result_discount_invoice_by_vnd}
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
    Run Keyword If    '${input_bh_khachtt}' != 'all'    Input payment info    ${input_bh_khachtt}    ${result_khachcantra}
    ...    ELSE    Log    abc
    Click Element JS    ${button_bh_thanhtoan}
    Invoice message success validation
    ${invoice_code}    Get saved code after execute
    #get values
    Sleep    20 s    wait for response to API
    Turn off allow use auto promotion invoice in shop config
    #assert values in Hoa don
    ${get_ma_kh_by_hd}    ${get_tong_tien_hang}    ${get_khach_tt}    ${get_giamgia_hd}    ${get_khachcantra}    ${get_trangthai}    Get invoice info incase discount by invoice code
    ...    ${invoice_code}
    Should Be Equal As Numbers    ${get_tong_tien_hang}    ${result_tongtienhang}
    Should Be Equal As Numbers    ${get_khachcantra}    ${result_khachcantra}
    Should Be Equal As Numbers    ${get_khach_tt}    ${actual_khachtt}
    Should Be Equal As Strings    ${get_ma_kh_by_hd}    ${input_bh_ma_kh}
    Should Be Equal As Numbers    ${get_giamgia_hd}    ${result_discount_invoice_by_vnd}
    Should Be Equal As Strings    ${get_trangthai}    Hoàn thành
    #Assert values in product list and stock card
    Toggle status of promotion    ${input_khuyemmai}    0
    Reload Page
    Delete invoice by invoice code    ${invoice_code}
