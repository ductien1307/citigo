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
&{list_product1}    PIB10018=5    PIB10019=2
&{dict_ggsp1}     PIB10018=20    PIB10019=1000
&{dict2_ggsp1}    PIB10018=0    PIB10019=1000
&{im_invoice1}    IM11=4
&{im_invoice2}    IM12=5
&{list_giveaway1}    DV031=1    DV032=1    DV033=1
&{list_giveaway3}    DV031=1    DV032=1
&{list_giveaway2}    DV031=1    DV032=0    DV033=0
&{dict_combo1}    Combo032=5    Combo033=3

*** Test Cases ***    Product and num list    Product Discount          Invoice Discount    Customer    Payment    Promotion Code
KM HD                 [Tags]                  AUPB1
                      [Template]              kmtd04
                      ${list_product1}        ${dict2_ggsp1}             10                   KH016       50000      KM02

KM hoa don giam gia SP
                      [Tags]                  AUPB1
                      [Template]              kmtd05
                      ${dict_combo1}          70000                      KH019               0       KM04      ${list_giveaway2}

KM hoa don tang hang_GOLIVE
                      [Documentation]         San pham KM la SP dich vu\Case khong validate ton kho cua SP KM
                      [Tags]                  AUPB1
                      [Template]              kmtd06
                      ${im_invoice1}          60000                     KH020               all         KM03      ${list_giveaway1}

*** Keywords ***
kmtd04
    [Arguments]    ${dict_product_num}    ${dict_product_discount}    ${input_bh_giamhd}    ${input_bh_ma_kh}    ${input_bh_khachtt}    ${input_khuyemmai}
    [Timeout]
    Turn on allow use auto promotion invoice in shop config
    Toggle status of promotion    ${input_khuyemmai}    1
    ${list_product}    Get Dictionary Keys    ${dict_product_num}
    ${list_nums}    Get Dictionary Values    ${dict_product_num}
    ${list_discount_product}    Get Dictionary Values    ${dict_product_discount}
    ${invoice_value}    ${discount}    ${discount_ratio}    ${name}    Get Invoice value - Discounts - Promotion Name from Promotion Code    ${input_khuyemmai}
    ${get_no_bf_execute}    ${get_tongban_bf_execute}    ${get_tongban_tru_trahang_bf_execute}    ${get_customer_name}    Get Customer Info from API    ${input_bh_ma_kh}
    #create lists
    Reload page
    # Input data into BH form
    ${list_result_thanhtien}    ${list_result_newprice}    ${list_result_onhand_af_ex}    Get list of total sale - result onhand - result new price after execute    ${list_product}    ${list_nums}    ${list_discount_product}
    ${lastest_num}    Set Variable    0
    : FOR    ${item_product}    ${item_num}    ${item_discount}    ${item_newprice}    IN ZIP    ${list_product}
    ...    ${list_nums}    ${list_discount_product}    ${list_result_newprice}
    \    ${lastest_num}       Input product-num in BH form    ${item_product}    ${item_num}      ${lastest_num}
    \    Run keyword if    0 < ${item_discount} < 100    Wait Until Keyword Succeeds    3 times    20 s    Input % discount for product    ${item_discount}    ${item_newprice}
    \    ...    ELSE IF    ${item_discount} > 100    Wait Until Keyword Succeeds    3 times    20 s    Input vnd discount for product    ${item_discount}    ${item_newprice}
    \    ...    ELSE        Log      ignore
    ${result_tongtienhang}    Sum values in list    ${list_result_thanhtien}
    ${result_af_invoice_discount}    Price after % discount invoice    ${result_tongtienhang}    ${input_bh_giamhd}
    ${result_discount_invoice_by_vnd}    Convert % discount to VND and round    ${result_tongtienhang}    ${input_bh_giamhd}
    ${result_discount_ratio_by_invoice_promo}    Convert % discount to VND and round    ${result_tongtienhang}    ${discount_ratio}
    ${actual_promo_value}    Set Variable If    ${discount} == 0    ${result_discount_ratio_by_invoice_promo}    ${discount}
    ${final_discount}=    Run Keyword If    ${result_tongtienhang} > ${invoice_value}    Sum    ${actual_promo_value}    ${result_discount_invoice_by_vnd}
    ...    ELSE    Set Variable    ${result_discount_invoice_by_vnd}
    ${result_khachcantra}    Minus    ${result_tongtienhang}    ${final_discount}
    ${actual_khachtt}    Set Variable If    '${input_bh_khachtt}' == 'all'    ${result_khachcantra}    ${input_bh_khachtt}
    ${result_no_hoadon}    Minus    ${result_khachcantra}    ${actual_khachtt}
    ${result_nohientai}    sum    ${result_no_hoadon}    ${get_no_bf_execute}
    ${result_tongban}    Sum    ${result_khachcantra}    ${get_tongban_bf_execute}
    Wait Until Keyword Succeeds    3 times    8 s    Input Customer and validate    ${input_bh_ma_kh}    ${get_customer_name}
    Wait Until Keyword Succeeds    3 times    8 s    Input % discount invoice    ${input_bh_giamhd}    ${final_discount}
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
    Should Be Equal As Numbers    ${result_khachcantra}    ${get_khachcantra}
    Should Be Equal As Numbers    ${get_khach_tt}    ${actual_khachtt}
    Should Be Equal As Strings    ${get_ma_kh_by_hd}    ${input_bh_ma_kh}
    Should Be Equal As Numbers    ${get_giamgia_hd}    ${final_discount}
    Should Be Equal As Strings    ${get_trangthai}    Hoàn thành
    #Assert values in product list and stock card
    Assert list of Onhand after execute    ${list_product}    ${list_result_onhand_af_ex}
    ${list_num_instockcard}    Change negative number to positive number and vice versa in List    ${list_nums}
    : FOR    ${item_product}    ${item_num_instockcard}    ${item_onhand}    IN ZIP    ${list_product}    ${list_num_instockcard}
    ...    ${list_result_onhand_af_ex}
    \    Assert values in Stock Card    ${invoice_code}    ${item_product}    ${item_onhand}    ${item_num_instockcard}
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
    Reload Page

kmtd05
    [Arguments]    ${dict_product_num}    ${input_discount_invoice}    ${input_bh_ma_kh}    ${input_bh_khachtt}    ${input_khuyemmai}    ${dict_promo_product}
    [Timeout]
    ## Get info ton cuoi, cong no khach hang
    Turn on allow use auto promotion invoice in shop config
    Toggle status of promotion    ${input_khuyemmai}    1
    ${invoice_value}    ${received_value}    ${discount}    ${discount_ratio}    ${name}    Get Invoice value - Received value - Discounts - Promotion Name from Promotion Code    ${input_khuyemmai}
    ${list_product}    Get Dictionary Keys    ${dict_product_num}
    ${list_nums}    Get Dictionary Values    ${dict_product_num}
    ${list_promo_product}    Get Dictionary Keys    ${dict_promo_product}
    ${list_promo_num}    Get Dictionary Values    ${dict_promo_product}
    ${get_no_bf_execute}    ${get_tongban_bf_execute}    ${get_tongban_tru_trahang_bf_execute}    ${get_customer_name}    Get Customer Info from API    ${input_bh_ma_kh}
    #create lists
    Reload Page
    ${list_material_num}    create list
    ${list_material_by_combo}    create list
    ${list_quantity_material_by_combo}    create list
    : FOR    ${item_product}    IN    @{list_product}
    \    ${list_material_product_code_by_combo}    ${list_material_quantity_by_combo}    Get material product code and quantity lists of combo    ${item_product}
    \    Append To List    ${list_material_by_combo}    ${list_material_product_code_by_combo}
    \    Append To List    ${list_quantity_material_by_combo}    ${list_material_quantity_by_combo}
    Log Many    ${list_material_by_combo}
    Log Many    ${list_quantity_material_by_combo}
    # Promo products
    ${list_result_totalsale_promo}    ${list_result_onhand_promo}    Run keyword if    ${discount} != 0    Get list of total sale - result onhand in case discount product    ${list_promo_product}    ${list_promo_num}
    ...    ${discount}
    ...    ELSE    Get list of total sale - result onhand in case discount product    ${list_promo_product}    ${list_promo_num}    ${discount_ratio}
    ${total_promo_sale}    Sum values in list    ${list_result_totalsale_promo}
    # Input data into BH form
    ${list_result_thanhtien}    ${list_result_onhand_af_ex}    ${list_material_num}    Get total sale and result onhand of material lists    ${list_product}    ${list_nums}    ${list_material_by_combo}
    ...    ${list_quantity_material_by_combo}
    ${lastest_num}    Set Variable    0
    : FOR    ${item_product}    ${item_num}    ${item_material}    ${item_quantity_material}    IN ZIP    ${list_product}
    ...    ${list_nums}    ${list_material_by_combo}    ${list_quantity_material_by_combo}
    \    ${lastest_num}    Input product-num in BH form    ${item_product}    ${item_num}    ${lastest_num}
    Log Many    ${list_result_thanhtien}
    Log Many    ${list_result_onhand_af_ex}
    Log Many    ${list_material_num}
    ##
    ${result_tongtienhang}    Sum values in list    ${list_result_thanhtien}
    ${result_tongtienhang_promo}    Sum    ${result_tongtienhang}    ${total_promo_sale}
    ${actual_tongtienhang}    Set Variable If    ${result_tongtienhang} > ${invoice_value}    ${result_tongtienhang_promo}    ${result_tongtienhang}
    ${result_khachcantra}    Minus    ${actual_tongtienhang}    ${input_discount_invoice}
    ${actual_khachtt}    Set Variable If    '${input_bh_khachtt}' == 'all'    ${result_khachcantra}    ${input_bh_khachtt}
    ${result_no_hoadon}    Minus    ${result_khachcantra}    ${actual_khachtt}
    ${result_nohientai}    sum    ${result_no_hoadon}    ${get_no_bf_execute}
    ${result_tongban}    Sum    ${result_khachcantra}    ${get_tongban_bf_execute}
    #
    Wait Until Keyword Succeeds    3 times    8 s    Input Customer and validate    ${input_bh_ma_kh}    ${get_customer_name}
    Run Keyword If    ${result_tongtienhang} > ${invoice_value}    Wait Until Keyword Succeeds    3 times    8 s    Select promotion and giveaway product by search product    ${name}
    ...    ${list_promo_product}    ${list_promo_num}
    ...    ELSE    Element Should Not Be Visible    ${icon_promo_sale}
    Wait Until Keyword Succeeds    3 times    8 s    Input VND discount invoice    ${input_discount_invoice}
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
    Should Be Equal As Numbers    ${get_tong_tien_hang}    ${actual_tongtienhang}
    Should Be Equal As Numbers    ${get_khachcantra}    ${result_khachcantra}
    Should Be Equal As Numbers    ${get_khach_tt}    ${actual_khachtt}
    Should Be Equal As Strings    ${get_ma_kh_by_hd}    ${input_bh_ma_kh}
    Should Be Equal As Numbers    ${get_giamgia_hd}    ${input_discount_invoice}
    Should Be Equal As Strings    ${get_trangthai}    Hoàn thành
    #Assert values in product list and stock card
    Assert list by list of Onhand after execute    ${list_material_by_combo}    ${list_result_onhand_af_ex}
    Toggle status of promotion    ${input_khuyemmai}    0

kmtd06
    [Arguments]    ${dict_product_imei}    ${input_bh_giamhd}    ${input_bh_ma_kh}    ${input_bh_khachtt}    ${input_khuyemmai}    ${list_giveaway}
    [Timeout]
    ## Get info ton cuoi, cong no khach hang
    Turn on allow use auto promotion invoice in shop config
    Toggle status of promotion    ${input_khuyemmai}    1
    ${invoice_value}    ${received_value}    ${discount}    ${discount_ratio}    ${name}    Get Invoice value - Received value - Discounts - Promotion Name from Promotion Code    ${input_khuyemmai}
    ${get_no_bf_execute}    ${get_tongban_bf_execute}    ${get_tongban_tru_trahang_bf_execute}    ${get_customer_name}    Get Customer Info from API    ${input_bh_ma_kh}
    #create lists
    ${list_prs}    Get Dictionary Keys    ${dict_product_imei}
    ${list_nums}    Get Dictionary Values    ${dict_product_imei}
    ${list_imeis_all}    Import Imeis for products by generating randomly    ${list_prs}    ${list_nums}
    ${list_giveaway_product}    Get Dictionary Keys    ${list_giveaway}
    ${list_giveaway_num}    Get Dictionary Values    ${list_giveaway}
    Reload Page
    # Input data into BH form
    ${list_result_thanhtien}      ${list_result_onhand_af_ex}     Get list of total sale and onhand results after execute    ${list_prs}    ${list_nums}
    : FOR    ${item_product}    ${item_list_imei}    IN ZIP    ${list_prs}    ${list_imeis_all}
    \    Input products and IMEIs to BH form    ${item_product}    ${item_list_imei}
    ${result_tongtienhang}     Sum values in list      ${list_result_thanhtien}
    ${result_khachcantra}    Minus    ${result_tongtienhang}    ${input_bh_giamhd}
    ${actual_khachtt}    Set Variable If    '${input_bh_khachtt}' == 'all'    ${result_khachcantra}    ${input_bh_khachtt}
    ${result_no_hoadon}    Minus    ${result_khachcantra}    ${actual_khachtt}
    ${result_nohientai}    sum    ${result_no_hoadon}    ${get_no_bf_execute}
    ${result_tongban}    Sum    ${result_khachcantra}    ${get_tongban_bf_execute}
    Wait Until Keyword Succeeds    3 times    8 s    Input Customer and validate    ${input_bh_ma_kh}    ${get_customer_name}
    Run Keyword If    ${result_tongtienhang} > ${invoice_value}    Wait Until Keyword Succeeds    3 times    8 s    Select promotion and giveaway product by search product    ${name}
    ...    ${list_giveaway_product}    ${list_giveaway_num}
    ...    ELSE    Element Should Not Be Visible    ${icon_promo_sale}
    Wait Until Keyword Succeeds    3 times    8 s    Input VND discount invoice    ${input_bh_giamhd}
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
    Should Be Equal As Numbers    ${get_giamgia_hd}    ${input_bh_giamhd}
    Should Be Equal As Strings    ${get_trangthai}    Hoàn thành
    #Assert values in product list and stock card
    Toggle status of promotion    ${input_khuyemmai}    0
    Reload Page
