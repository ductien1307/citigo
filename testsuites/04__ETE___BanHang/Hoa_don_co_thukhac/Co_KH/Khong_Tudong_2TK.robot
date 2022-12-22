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
&{list_product6}    PIB10030=2
&{dict_1}         PIB10030=2599.89
&{dict_2}         PIB10030=15

*** Test Cases ***    Product and num list    Product Discount    Invoice Discount    Customer    Payment    Surcharge
Khongtudong_HD 2 thu khac_GOLIVE
                      [Tags]                  CBTK                          UEB
                      [Template]              etetk2
                      ${list_product6}        ${dict_1}           5                   KH026       0          TK003        TK004    #%+%
                      ${list_product6}        ${dict_1}           6                   KH026       all        TK007        TK008    #VND+vnd
                      ${list_product6}        ${dict_1}           6                   KH026       50000      TK007        TK003    #VND+%

*** Keywords ***
etetk2
    [Arguments]    ${dict_product_num}    ${dict_product_discount}    ${input_bh_giamhd}    ${input_bh_ma_kh}    ${input_bh_khachtt}    ${input_thukhac1}
    ...    ${input_thukhac2}
    [Timeout]           15 mins
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
    ${list_product}    Get Dictionary Keys    ${dict_product_num}
    ${list_nums}    Get Dictionary Values    ${dict_product_num}
    ${list_discount_product}    Get Dictionary Values    ${dict_product_discount}
    ${get_no_bf_execute}    ${get_tongban_bf_execute}    ${get_tongban_tru_trahang_bf_execute}    Get Customer Debt from API    ${input_bh_ma_kh}
    Reload Page
    # Input data into BH form
    ${list_result_thanhtien}    ${list_result_newprice}    ${list_result_ton_af_ex}    Get list of total sale - result onhand - result new price after execute    ${list_product}    ${list_nums}    ${list_discount_product}
    ${lastest_num}    Set Variable    0
    : FOR    ${item_product}    ${item_num}    ${item_discount}    ${item_newprice}    IN ZIP    ${list_product}
    ...    ${list_nums}    ${list_discount_product}    ${list_result_newprice}
    \    ${lastest_num}       Input product-num in BH form    ${item_product}    ${item_num}      ${lastest_num}
    \    Run keyword if    0 < ${item_discount} < 100    Wait Until Keyword Succeeds    3 times    20 s    Input % discount for product    ${item_discount}    ${item_newprice}
    \    ...    ELSE IF    ${item_discount} > 100    Wait Until Keyword Succeeds    3 times    20 s    Input vnd discount for product    ${item_discount}    ${item_newprice}
    \    ...    ELSE        Log      ignore
    ${result_tongtienhang}    Sum values in list    ${list_result_thanhtien}
    ${result_af_invoice_discount}    Price after % discount invoice    ${result_tongtienhang}    ${input_bh_giamhd}
    ${total_surcharge}=    Run Keyword If    ${actual_surcharge1_value} > 100 and ${actual_surcharge2_value} > 100    Sum    ${actual_surcharge1_value}    ${actual_surcharge2_value}
    ...    ELSE IF    ${actual_surcharge1_value} > 100 and ${actual_surcharge2_value} < 100    VND and Percentage Surcharges sum    ${actual_surcharge2_value}    ${result_af_invoice_discount}    ${actual_surcharge1_value}
    ...    ELSE IF    ${actual_surcharge1_value} < 100 and ${actual_surcharge2_value} < 100    Percentage and Percentage Surcharges sum    ${result_af_invoice_discount}    ${actual_surcharge1_value}    ${actual_surcharge2_value}
    ...    ELSE    Log    abv
    ${result_tongtienhang_tovalidate}    Sum    ${result_tongtienhang}    ${total_surcharge}
    ###
    ${result_khachcantra}    sum    ${result_af_invoice_discount}    ${total_surcharge}
    ${result_discount_by_vnd}    Convert % discount to VND and round    ${result_tongtienhang}    ${input_bh_giamhd}
    ${actual_khachtt}    Set Variable If    '${input_bh_khachtt}' == 'all'    ${result_khachcantra}    ${input_bh_khachtt}
    ${result_no_hoadon}    Minus    ${result_khachcantra}    ${actual_khachtt}
    ${result_nohientai}    sum    ${result_no_hoadon}    ${get_no_bf_execute}
    ${result_tongban}    Sum    ${result_khachcantra}    ${get_tongban_bf_execute}
    Wait Until Keyword Succeeds    3 times    8 s    Input % discount invoice    ${input_bh_giamhd}    ${result_discount_by_vnd}
    Wait Until Keyword Succeeds    3 times    8 s    Select two surcharge by pressing Enter    ${input_thukhac1}    ${input_thukhac2}    ${total_surcharge}
    ...    ${cell_surcharge_value}
    Run Keyword If    '${input_bh_khachtt}' == 'all'    Input Khach Hang    ${input_bh_ma_kh}
    ...    ELSE    Input Invoice info    ${input_bh_ma_kh}    ${input_bh_khachtt}    ${result_khachcantra}
    Click Element JS    ${button_bh_thanhtoan}
    Invoice message success validation
    ${invoice_code}    Get saved code after execute
    #get values
    Sleep    20 s    wait for response to API
    #assert values in Hoa don
    ${get_ma_kh_by_hd}    ${get_tong_tien_hang}    ${get_khach_tt}    ${get_giamgia_hd}    ${get_khachcantra}    ${get_trangthai}    Get invoice info incase discount by invoice code
    ...    ${invoice_code}
    Should Be Equal As Numbers    ${get_tong_tien_hang}    ${result_tongtienhang_tovalidate}
    Should Be Equal As Numbers    ${get_khachcantra}    ${result_khachcantra}
    Should Be Equal As Numbers    ${get_khach_tt}    ${actual_khachtt}
    Should Be Equal As Strings    ${get_ma_kh_by_hd}    ${input_bh_ma_kh}
    Should Be Equal As Numbers    ${get_giamgia_hd}    ${result_discount_by_vnd}
    Should Be Equal As Strings    ${get_trangthai}    Hoàn thành
    Run Keyword If    ${actual_surcharge1_value} > 100    Toggle surcharge VND    ${input_thukhac1}    false
    ...    ELSE    Toggle surcharge percentage    ${input_thukhac1}    false
    Run Keyword If    ${actual_surcharge2_value} > 100    Toggle surcharge VND    ${input_thukhac2}    false
    ...    ELSE    Toggle surcharge percentage    ${input_thukhac2}    false
    Reload page
