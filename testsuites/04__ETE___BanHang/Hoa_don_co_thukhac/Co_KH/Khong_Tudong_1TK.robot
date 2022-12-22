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
&{list_product6}    PIB10029=2
&{dict_1}         PIB10029=2599.89

*** Test Cases ***    Product and num list    Product Discount    Invoice Discount    Customer    Payment    Surcharge
Khongtudong_HD 1 thu khac_GOLIVE
                      [Tags]                  CBTK1                        UEB
                      [Template]              etetk1
                      #${list_product6}        ${dict_1}           6                   KH025       all        TK007
                      ${list_product6}        ${dict_1}           5                   KH025       0          TK003

*** Keywords ***
etetk1
    [Arguments]    ${dict_product_num}    ${dict_product_discount}    ${input_bh_giamhd}    ${input_bh_ma_kh}    ${input_bh_khachtt}    ${input_thukhac}
    [Timeout]
    ## Get info ton cuoi, cong no khach hang
    ${surcharge_vnd_value}    Get surcharge vnd value    ${input_thukhac}
    ${surcharge_%}    Get surcharge percentage value    ${input_thukhac}
    Run Keyword If    ${surcharge_%} == 0    Toggle surcharge VND    ${input_thukhac}    true
    ...    ELSE    Toggle surcharge percentage    ${input_thukhac}    true
    ${list_product}    Get Dictionary Keys    ${dict_product_num}
    ${list_nums}    Get Dictionary Values    ${dict_product_num}
    ${list_discount_product}    Get Dictionary Values    ${dict_product_discount}
    ${get_no_bf_execute}    ${get_tongban_bf_execute}    ${get_tongban_tru_trahang_bf_execute}    Get Customer Debt from API    ${input_bh_ma_kh}
    # Input data into BH form
    Reload Page
    ${list_result_thanhtien}    ${list_result_newprice}    ${list_result_ton_af_ex}    Get list of total sale - result onhand - result new price after execute    ${list_product}    ${list_nums}    ${list_discount_product}
    ${lastest_num}    Set Variable    0
    : FOR    ${item_product}    ${item_num}    ${item_discount}    ${item_newprice}    IN ZIP    ${list_product}
    ...    ${list_nums}    ${list_discount_product}    ${list_result_newprice}
    \    ${lastest_num}       Input product-num in BH form    ${item_product}    ${item_num}      ${lastest_num}
    \    Run keyword if    0 < ${item_discount} < 100    Wait Until Keyword Succeeds    3 times    20 s    Input % discount for product    ${item_discount}    ${item_newprice}
    \    ...    ELSE IF    ${item_discount} > 100    Wait Until Keyword Succeeds    3 times    20 s    Input vnd discount for product    ${item_discount}    ${item_newprice}
    \    ...    ELSE        Log      ignore
    ${result_tongtienhang}    Sum values in list    ${list_result_thanhtien}
    ${actual_surcharge_type}    Set Variable If    ${surcharge_%} == 0    ${surcharge_vnd_value}    ${surcharge_%}
    ${result_af_invoice_discount}    Price after % discount invoice    ${result_tongtienhang}    ${input_bh_giamhd}
    ${result_per_surchare_by_invoice}    Convert % discount to VND and round    ${result_af_invoice_discount}    ${surcharge_%}
    ${actual_surcharge_value}    Set Variable If    ${surcharge_%} == 0    ${surcharge_vnd_value}    ${result_per_surchare_by_invoice}
    ${result_tongtienhang_tovalidate}    Sum    ${result_tongtienhang}    ${actual_surcharge_value}
    ${result_khachcantra}    sum    ${result_af_invoice_discount}    ${actual_surcharge_value}
    ${result_discount_by_vnd}    Convert % discount to VND and round    ${result_tongtienhang}    ${input_bh_giamhd}
    ${actual_khachtt}    Set Variable If    '${input_bh_khachtt}' == 'all'    ${result_khachcantra}    ${input_bh_khachtt}
    ${result_no_hoadon}    Minus    ${result_khachcantra}    ${actual_khachtt}
    ${result_nohientai}    sum    ${result_no_hoadon}    ${get_no_bf_execute}
    ${result_tongban}    Sum    ${result_khachcantra}    ${get_tongban_bf_execute}
    Wait Until Keyword Succeeds    3 times    8 s    Input % discount invoice    ${input_bh_giamhd}    ${result_discount_by_vnd}
    Wait Until Keyword Succeeds    3 times    8 s    Select one surcharge by pressing Enter    ${input_thukhac}    ${actual_surcharge_value}    ${cell_surcharge_value}
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
    Run Keyword If    ${surcharge_%} == 0    Toggle surcharge VND    ${input_thukhac}    false
    ...    ELSE    Toggle surcharge percentage    ${input_thukhac}    false
    Reload page
