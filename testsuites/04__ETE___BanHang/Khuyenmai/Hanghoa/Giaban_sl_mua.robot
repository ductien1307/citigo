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
&{dict_promo_nor1}    NK001=2    NK002=4
&{dict_promo_nor2}    NK001=3    NK002=3
&{dict_nor2}      PIB10010=3    PIB10011=2

*** Test Cases ***    Product and num list    Product Discount                                                    Invoice Discount    Customer    Payment    Promotion Code
KM HH hinh thuc gia ban theo SL mua_GOLIVE
                      [Documentation]         San pham KM la SP dich vu\nCase khong validate ton kho cua SP KM
                      [Tags]                  CBPP                                                                            UEB1
                      [Template]              ekmhh02
                      ${dict_nor2}            5                                                                   KH021               50000         KM09
                      ${dict_nor2}            0                                                                   KH022               all         KM10
                      ${dict_nor2}            10                                                                  KH021               0           KM11

*** Keywords ***
ekmhh02
    [Arguments]    ${dict_product_num}    ${input_bh_giamhd}    ${input_bh_ma_kh}    ${input_bh_khachtt}    ${input_khuyemmai}
    [Timeout]
    ## Get info ton cuoi, cong no khach hang
    Toggle status of promotion    ${input_khuyemmai}    1
    ${list_product}    Get Dictionary Keys    ${dict_product_num}
    ${list_nums}    Get Dictionary Values    ${dict_product_num}
    ${num_sale_product}    ${num_promo_product}    ${product_price}    ${discount}    ${discount_ratio}    ${name}    Get Number of sale product - promo product - promo value and name
    ...    ${input_khuyemmai}
    ${get_no_bf_execute}    ${get_tongban_bf_execute}    ${get_tongban_tru_trahang_bf_execute}    ${get_customer_name}    Get Customer Info from API    ${input_bh_ma_kh}
    #create lists
    Reload page
    # Input data into BH form
    ${lastest_num}    Set Variable    0
    ${total_sale_number}    Sum values in list    ${list_nums}
    ${list_result_totalsale}    ${list_result_onhand_af_ex}    Run Keyword If    ${discount} != 0 and ${discount_ratio} ==0    Get list of total sale - result onhand in case discount product    ${list_product}    ${list_nums}
    ...    ${discount}
    ...    ELSE IF    ${discount} == 0 and ${discount_ratio} != 0    Get list of total sale - result onhand in case discount product    ${list_product}    ${list_nums}    ${discount_ratio}
    ...    ELSE IF    ${total_sale_number} < ${num_sale_product}    Get list of total sale - result onhand with one discount    ${list_product}    ${list_nums}
    ...    ELSE    Get list of total sale - result onhand in case promotion    ${list_product}    ${list_nums}    ${product_price}    ${num_sale_product}
    ${list_result_totalsale_without_promo}    ${list_result_onhand_without_promo}    Get list of total sale - result onhand with one discount    ${list_product}    ${list_nums}
    #${actual_list_result_totalsale}    Set Variable If    ${total_sale_number} < ${num_sale_product}    ${list_result_totalsale_without_promo}    ${list_result_totalsale}
    Wait Until Keyword Succeeds    3 times    8 s    Input Customer and validate    ${input_bh_ma_kh}    ${get_customer_name}
    : FOR    ${item_product}    ${item_num}    IN ZIP    ${list_product}    ${list_nums}
    \    ${lastest_num}    Input product-num in BH form    ${item_product}    ${item_num}    ${lastest_num}
    Run Keyword If    ${total_sale_number} >= ${num_sale_product}    Wait Until Keyword Succeeds    3 times    8 s    Select promotion on each product line    ${name}
    ...    ELSE    Log    kmk
    ${result_tongtienhang}    Sum values in list    ${list_result_totalsale}
    ${result_khachcantra}    Price after % discount invoice    ${result_tongtienhang}    ${input_bh_giamhd}
    ${result_discount_by_vnd}    Convert % discount to VND and round    ${result_tongtienhang}    ${input_bh_giamhd}
    ${actual_khachtt}    Set Variable If    '${input_bh_khachtt}' == 'all'    ${result_khachcantra}    ${input_bh_khachtt}
    ${result_no_hoadon}    Minus    ${result_khachcantra}    ${actual_khachtt}
    ${result_nohientai}    sum    ${result_no_hoadon}    ${get_no_bf_execute}
    ${result_tongban}    Sum    ${result_khachcantra}    ${get_tongban_bf_execute}
    Wait Until Keyword Succeeds    3 times    8 s    Input % discount invoice    ${input_bh_giamhd}    ${result_discount_by_vnd}
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
    Should Be Equal As Numbers    ${get_tong_tien_hang}    ${result_tongtienhang}
    Should Be Equal As Numbers    ${result_khachcantra}    ${get_khachcantra}
    Should Be Equal As Numbers    ${get_khach_tt}    ${actual_khachtt}
    Should Be Equal As Strings    ${get_ma_kh_by_hd}    ${input_bh_ma_kh}
    Should Be Equal As Numbers    ${get_giamgia_hd}    ${result_discount_by_vnd}
    Should Be Equal As Strings    ${get_trangthai}    Hoàn thành
    #Assert values in product list and stock card
    Assert list of Onhand after execute    ${list_product}    ${list_result_onhand_af_ex}
    ${list_num_instockcard}    Change negative number to positive number and vice versa in List    ${list_nums}
    : FOR    ${item_product}    ${item_num_instockcard}    ${item_onhand}    IN ZIP    ${list_product}    ${list_num_instockcard}
    ...    ${list_result_onhand_af_ex}
    \    Assert values in Stock Card    ${invoice_code}    ${item_product}    ${item_onhand}    ${item_num_instockcard}
    #assert value in tab cong no khach hang
    Toggle status of promotion    ${input_khuyemmai}    0
    Reload Page
