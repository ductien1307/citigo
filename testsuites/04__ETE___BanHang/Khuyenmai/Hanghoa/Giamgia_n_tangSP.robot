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
&{dict_nor1}      PIB10028=3
&{dict_promo_nor1}    NK001=2    NK002=4
&{dict_promo_nor2}    NK001=3    NK002=3

*** Test Cases ***    Product and num list    Product Discount                                                    Invoice Discount    Customer    Payment    Promotion Code
KM HH hinh thuc mua hang GG hang va tang hang
                      [Tags]                  CBPP                                                                          UEB1
                      [Template]              ekmhh01
                      ${dict_nor1}            50000                                                               KH023               0           KM06      ${dict_promo_nor1}    #mua hang gg hang vnd
                      ${dict_nor1}            80000                                                               KH024               all         KM08      ${dict_promo_nor2}    # mua hang tang hang
                      ${dict_nor1}            100000                                                              KH023               50000         KM07      ${dict_promo_nor2}    # mua hang gg hang %

*** Keywords ***
ekmhh01
    [Arguments]    ${dict_product_num}    ${input_discount_invoice}    ${input_bh_ma_kh}    ${input_bh_khachtt}    ${input_khuyemmai}    ${dict_promo_product}
    [Timeout]
    ## Get info ton cuoi, cong no khach hang
    Toggle status of promotion    ${input_khuyemmai}    1
    ${num_sale_product}    ${num_promo_product}    ${product_price}    ${discount}    ${discount_ratio}    ${name}    Get Number of sale product - promo product - promo value and name
    ...    ${input_khuyemmai}
    ${list_product}    Get Dictionary Keys    ${dict_product_num}
    ${list_nums}    Get Dictionary Values    ${dict_product_num}
    ${list_promo_product}    Get Dictionary Keys    ${dict_promo_product}
    ${list_promo_num}    Get Dictionary Values    ${dict_promo_product}
    ${get_no_bf_execute}    ${get_tongban_bf_execute}    ${get_tongban_tru_trahang_bf_execute}    ${get_customer_name}    Get Customer Info from API    ${input_bh_ma_kh}
    #create lists
    Reload Page
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
    ${list_result_thanhtien}    ${list_result_onhand_all_material}    ${list_actual_num_all_material}    Get total sale and result onhand of material lists    ${list_product}    ${list_nums}    ${list_material_by_combo}
    ...    ${list_quantity_material_by_combo}
    ${lastest_num}    Set Variable    0
    : FOR    ${item_product}    ${item_num}    ${item_material}    ${item_quantity_material}    IN ZIP    ${list_product}
    ...    ${list_nums}    ${list_material_by_combo}    ${list_quantity_material_by_combo}
    \    ${lastest_num}    Input product-num in BH form    ${item_product}    ${item_num}    ${lastest_num}
    ##
    ${result_tongtienhang}    Sum values in list    ${list_result_thanhtien}
    ${result_tongtienhang_promo}    Sum    ${result_tongtienhang}    ${total_promo_sale}
    ${actual_tongtienhang}    Set Variable If    ${discount} == 0 and ${discount_ratio} == 0    ${result_tongtienhang}    ${result_tongtienhang_promo}
    ${result_khachcantra}    Minus    ${actual_tongtienhang}    ${input_discount_invoice}
    ${actual_khachtt}    Set Variable If    '${input_bh_khachtt}' == 'all'    ${result_khachcantra}    ${input_bh_khachtt}
    ${result_no_hoadon}    Minus    ${result_khachcantra}    ${actual_khachtt}
    ${result_nohientai}    sum    ${result_no_hoadon}    ${get_no_bf_execute}
    ${result_tongban}    Sum    ${result_khachcantra}    ${get_tongban_bf_execute}
    #
    Wait Until Keyword Succeeds    3 times    3 s    Input Customer and validate    ${input_bh_ma_kh}    ${get_customer_name}
    Wait Until Keyword Succeeds    3 times    3 s    Select promotion and giveaway product on the first row product    ${name}    ${list_promo_product}    ${list_promo_num}
    Wait Until Keyword Succeeds    3 times    3 s    Input VND discount invoice    ${input_discount_invoice}
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
    Should Be Equal As Numbers    ${get_tong_tien_hang}    ${actual_tongtienhang}
    Should Be Equal As Numbers    ${get_khachcantra}    ${result_khachcantra}
    Should Be Equal As Numbers    ${get_khach_tt}    ${actual_khachtt}
    Should Be Equal As Strings    ${get_ma_kh_by_hd}    ${input_bh_ma_kh}
    Should Be Equal As Numbers    ${get_giamgia_hd}    ${input_discount_invoice}
    Should Be Equal As Strings    ${get_trangthai}    Hoàn thành
    #Assert values in product list and stock card
    Assert list by list of Onhand after execute    ${list_material_by_combo}    ${list_result_onhand_all_material}
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
    Delete invoice by invoice code    ${invoice_code}
    Toggle status of promotion    ${input_khuyemmai}    0
