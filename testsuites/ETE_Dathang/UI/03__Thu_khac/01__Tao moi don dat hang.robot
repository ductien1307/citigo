*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    ${headless_browser}
Test Setup        Before Test Ban Hang
Test Teardown     After Test
Resource          ../../../../core/API/api_danhmuc_hanghoa.robot
Resource          ../../../../core/API/api_dathang.robot
Resource          ../../../../core/API/api_khachhang.robot
Resource          ../../../../core/API/api_mhbh.robot
Resource          ../../../../core/Dat_Hang/dat_hang_action.robot
Resource          ../../../../core/Dat_Hang/dat_hang_navigation.robot
Resource          ../../../../core/Dat_Hang/dat_hang_page.robot
Resource          ../../../../core/share/toast_message.robot
Resource          ../../../../core/API/api_soquy.robot
Resource          ../../../../core/API/api_mhbh_dathang.robot
Resource          ../../../../core/share/javascript.robot
Resource          ../../../../core/share/discount.robot
Resource          ../../../../core/API/api_thietlap.robot

*** Variables ***
&{list_product_tk01}    HH0058=2.5    SI041=2    DVT61=2.8    DV065=3    Combo42=1
&{list_product_tk02}    HH0059=5    SI042=2    DVT62=2.8    DV066=3    Combo43=1
@{discount}    20000    5    15000    30000.78      0
@{discount_type}    disvnd     dis    changedown      changeup    none

*** Test Cases ***    Mã KH         List product&nums       GGSP            List type                GGDH     Khách TT    Thu khac
Khongtudong_DH_1thukhac_GOLIVE
                      [Tags]        EDTK
                      [Template]    uedtk1
                      CTKH102       ${list_product_tk01}    ${discount}    ${discount_type}    50000    all         TK003
                      CTKH102       ${list_product_tk01}    ${discount}    ${discount_type}    50000    0           TK007

Khongtudong_DH_2thukhac
                      [Tags]        EDTK
                      [Template]    uedtk2
                      CTKH103       ${list_product_tk01}    ${discount}    ${discount_type}      30       all         TK007       TK008
                      CTKH103       ${list_product_tk01}    ${discount}    ${discount_type}      30       0           TK003       TK004
                      CTKH103       ${list_product_tk01}    ${discount}    ${discount_type}      30       50000       TK007       TK003

Tudong_DH_1thukhac    [Tags]        EDTKA1
                      [Template]    uedtka1
                      CTKH104       ${list_product_tk02}    ${discount}    ${discount_type}      15000    0           TK005
                      CTKH104       ${list_product_tk02}    ${discount}    ${discount_type}      15000    100000      TK001

Tudong_DH_2thukhac    [Tags]        EDTKA
                      [Template]    uedtka2
                      CTKH105       ${list_product_tk02}    ${discount}    ${discount_type}      15       all         TK001       TK002
                      CTKH105       ${list_product_tk02}    ${discount}    ${discount_type}      10       0           TK005       TK006
                      CTKH105       ${list_product_tk02}    ${discount}    ${discount_type}      5        20000       TK005       TK001

*** Keywords ***
uedtk1
    [Arguments]    ${input_ma_kh}    ${dict_product_nums}    ${list_ggsp}    ${list_discount_type}    ${input_ggdh}    ${input_khtt}    ${input_thukhac}
    ##Activate surcharge
    ${surcharge_vnd_value}    Get surcharge vnd value    ${input_thukhac}
    ${surcharge_%}    Get surcharge percentage value    ${input_thukhac}
    Run Keyword If    ${surcharge_%} == 0    Toggle surcharge VND    ${input_thukhac}    true    ELSE    Toggle surcharge percentage    ${input_thukhac}    true
    Reload Page
    #get info product, customer
    ${list_product}    Get Dictionary Keys    ${dict_product_nums}
    ${list_nums}    Get Dictionary Values    ${dict_product_nums}
    ${list_result_thanhtien}    ${list_result_order_summary}    ${list_result_giamoi}    Get list total sale - order summary - newprice incase discount and newprice    ${list_product}
    ...    ${list_nums}    ${list_ggsp}    ${list_discount_type}
    ${get_list_baseprice}    Get list of Baseprice by Product Code    ${list_product}
    #compute
    ${result_tongtienhang}    Sum values in list    ${list_result_thanhtien}
    ${actual_surcharge_type}    Set Variable If    ${surcharge_%} == 0    ${surcharge_vnd_value}    ${surcharge_%}
    ${result_af_invoice_discount}    Minus and replace floating point    ${result_tongtienhang}    ${input_ggdh}
    ${result_per_surchare_by_invoice}    Convert % discount to VND and round    ${result_af_invoice_discount}    ${surcharge_%}
    ${actual_surcharge_value}    Set Variable If    ${surcharge_%} == 0    ${surcharge_vnd_value}    ${result_per_surchare_by_invoice}
    ${result_khachcantra}    sum    ${result_af_invoice_discount}    ${actual_surcharge_value}
    ${result_khachcantra}    Replace floating point    ${result_khachcantra}
    ${actual_khtt_all}    Set Variable If    '${input_khtt}' == 'all'    ${result_khachcantra}    ${input_khtt}
    ${actual_khtt}    Set Variable If    '${input_khtt}' == '0'    0    ${actual_khtt_all}
    #input data into DH form
    Click Element JS    ${tab_dathang}
    ${laster_nums}    Set Variable    0
    : FOR    ${item_product}    ${item_nums}    ${item_ggsp}    ${item_price}   ${item_discount_type}    IN ZIP    ${list_product}
    ...    ${list_nums}    ${list_ggsp}    ${list_result_giamoi}    ${list_discount_type}
    \    ${laster_nums}    Wait Until Keyword Succeeds    3 times    5 s    Input product-num in sale form    ${item_product}    ${item_nums}
    \    ...    ${laster_nums}    ${cell_tongsoluong_dh}
    \    Run keyword if    '${item_discount_type}' == 'dis'     Wait Until Keyword Succeeds    3 times    5 s    Input % discount for multi product    ${item_product}    ${item_ggsp}
    \    ...    ${item_price}    ELSE IF    '${item_discount_type}' == 'disvnd'    Input VND discount for multi product    ${item_product}    ${item_ggsp}    ${item_price}
    \    ...     ELSE IF  '${item_discount_type}' == 'changeup' or '${item_discount_type}' == 'changedown'    Wait Until Keyword Succeeds    3 times    5 s    Input newprice for multi product    ${item_product}    ${item_ggsp}
    \    ...    ELSE    Log    Ignore input
    Wait Until Keyword Succeeds    3 times    20 s    Input VND discount order    ${input_ggdh}
    Wait Until Keyword Succeeds    3 times    8 s    Select one surcharge    ${input_thukhac}    ${actual_surcharge_value}    ${cell_surcharge_order}
    Run Keyword If    '${input_khtt}' == '0'    Input Khach Hang    ${input_ma_kh}
    ...    ELSE    Input Order info    ${input_ma_kh}    ${actual_khtt}    ${result_khachcantra}
    Click Element JS    ${button_bh_dathang}
    Order message success validation
    ${get_ma_dh}    Get saved code after execute
    #get values
    Sleep    20 s    wait for response to API
    #assert value product
    ${get_list_hh_in_dh_af_execute}    Get list product frm API    ${get_ma_dh}
    ${get_list_hh_in_dh_af_execute}    Reverse List one    ${get_list_hh_in_dh_af_execute}
    ${list_order_summary_af_execute}    Get list order summary frm product API    ${get_list_hh_in_dh_af_execute}
    : FOR    ${result_tong_dh}    ${order_summary_af_execute}    IN ZIP    ${list_result_order_summary}    ${list_order_summary_af_execute}
    \    Should Be Equal As Numbers    ${order_summary_af_execute}    ${result_tong_dh}
    #assert value order
    ${get_ma_kh_in_dh_af_execute}    ${get_TTDH_in_dh_af_execute}    ${get_tongtienhang_in_dh_af_execute}    ${get_khachdatra_in_dh_af_execute}    ${get_giamgia_in_dh_af_execute}    ${get_tongcong_in_dh_af_execute}    ${get_ghichu_in_dh_af_execute}    Get order info incase discount by order code
    ...    ${get_ma_dh}
    Should Be Equal As Strings    ${get_ma_kh_in_dh_af_execute}    ${input_ma_kh}
    Should Be Equal As Numbers    ${get_TTDH_in_dh_af_execute}    1    #1 : phiếu tạm
    Should Be Equal As Numbers    ${get_tongtienhang_in_dh_af_execute}    ${result_tongtienhang}
    Should Be Equal As Numbers    ${get_khachdatra_in_dh_af_execute}    ${actual_khtt}
    Should Be Equal As Numbers    ${get_giamgia_in_dh_af_execute}    ${input_ggdh}
    Should Be Equal As Numbers    ${get_tongcong_in_dh_af_execute}    ${result_khachcantra}
    Delete order frm Order code    ${get_ma_dh}
    Run Keyword If    ${surcharge_%} == 0    Toggle surcharge VND    ${input_thukhac}    false    ELSE    Toggle surcharge percentage    ${input_thukhac}    false

uedtk2
    [Arguments]    ${input_ma_kh}    ${dict_product_nums}    ${list_ggsp}    ${list_discount_type}    ${input_ggdh}    ${input_khtt}    ${input_thukhac1}
    ...    ${input_thukhac2}
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
    Reload Page
    #get info product, customer
    ${list_product}    Get Dictionary Keys    ${dict_product_nums}
    ${list_nums}    Get Dictionary Values    ${dict_product_nums}
    ${list_result_thanhtien}    ${list_result_order_summary}    ${list_result_giamoi}    Get list total sale - order summary - newprice incase discount and newprice    ${list_product}
    ...    ${list_nums}    ${list_ggsp}    ${list_discount_type}
    ${get_list_baseprice}    Get list of Baseprice by Product Code    ${list_product}
    #compute
    ${result_tongtienhang}    Sum values in list    ${list_result_thanhtien}
    ${result_ggdh}    Convert % discount to VND and round    ${result_tongtienhang}    ${input_ggdh}
    ${result_af_invoice_discount}    Price after % discount invoice    ${result_tongtienhang}    ${input_ggdh}
    ${total_surcharge}=    Run Keyword If    ${actual_surcharge1_value} > 100 and ${actual_surcharge2_value} > 100    Sum    ${actual_surcharge1_value}    ${actual_surcharge2_value}
    ...    ELSE IF    ${actual_surcharge1_value} > 100 and ${actual_surcharge2_value} < 100    VND and Percentage Surcharges sum    ${actual_surcharge2_value}    ${result_af_invoice_discount}    ${actual_surcharge1_value}
    ...    ELSE IF    ${actual_surcharge1_value} < 100 and ${actual_surcharge2_value} < 100    Percentage and Percentage Surcharges sum    ${result_af_invoice_discount}    ${actual_surcharge1_value}    ${actual_surcharge2_value}
    ...    ELSE    Log    abv
    ${result_khachcantra}    Sum    ${result_af_invoice_discount}    ${total_surcharge}
    ${result_khachcantra}    Replace floating point    ${result_khachcantra}
    ${actual_khtt_all}    Set Variable If    '${input_khtt}' == 'all'    ${result_khachcantra}    ${input_khtt}
    ${actual_khtt}    Set Variable If    '${input_khtt}' == '0'    0    ${actual_khtt_all}
    #input data into DH form
    Click Element JS    ${tab_dathang}
    ${laster_nums}    Set Variable    0
    : FOR    ${item_product}    ${item_nums}    ${item_ggsp}    ${item_price}   ${item_discount_type}    IN ZIP    ${list_product}
    ...    ${list_nums}    ${list_ggsp}    ${list_result_giamoi}    ${list_discount_type}
    \    ${laster_nums}    Wait Until Keyword Succeeds    3 times    5 s    Input product-num in sale form    ${item_product}    ${item_nums}
    \    ...    ${laster_nums}    ${cell_tongsoluong_dh}
    \    Run keyword if    '${item_discount_type}' == 'dis'     Wait Until Keyword Succeeds    3 times    5 s    Input % discount for multi product    ${item_product}    ${item_ggsp}
    \    ...    ${item_price}    ELSE IF    '${item_discount_type}' == 'disvnd'    Input VND discount for multi product    ${item_product}    ${item_ggsp}    ${item_price}
    \    ...     ELSE IF  '${item_discount_type}' == 'changeup' or '${item_discount_type}' == 'changedown'    Wait Until Keyword Succeeds    3 times    5 s    Input newprice for multi product    ${item_product}    ${item_ggsp}
    \    ...    ELSE    Log    Ignore input
    Wait Until Keyword Succeeds    3 times    20 s    Input % discount order    ${input_ggdh}    ${result_ggdh}
    Wait Until Keyword Succeeds    3 times    8 s    Select two surcharge    ${input_thukhac1}    ${input_thukhac2}    ${total_surcharge}
    ...    ${cell_surcharge_order}
    Run Keyword If    '${input_khtt}' == '0'    Input Khach Hang    ${input_ma_kh}
    ...    ELSE    Input Order info    ${input_ma_kh}    ${actual_khtt}    ${result_khachcantra}
    Click Element JS    ${button_bh_dathang}
    Order message success validation
    ${get_ma_dh}    Get saved code after execute
    #get values
    Sleep    20 s    wait for response to API
    #assert value product
    ${get_list_hh_in_dh_af_execute}    Get list product frm API    ${get_ma_dh}
    ${get_list_hh_in_dh_af_execute}    Reverse List one    ${get_list_hh_in_dh_af_execute}
    ${list_order_summary_af_execute}    Get list order summary frm product API    ${get_list_hh_in_dh_af_execute}
    : FOR    ${result_tong_dh}    ${order_summary_af_execute}    IN ZIP    ${list_result_order_summary}    ${list_order_summary_af_execute}
    \    Should Be Equal As Numbers    ${order_summary_af_execute}    ${result_tong_dh}
    #assert value order
    ${get_ma_kh_in_dh_af_execute}    ${get_TTDH_in_dh_af_execute}    ${get_tongtienhang_in_dh_af_execute}    ${get_khachdatra_in_dh_af_execute}    ${get_giamgia_in_dh_af_execute}    ${get_tongcong_in_dh_af_execute}    ${get_ghichu_in_dh_af_execute}    Get order info incase discount by order code
    ...    ${get_ma_dh}
    Should Be Equal As Strings    ${get_ma_kh_in_dh_af_execute}    ${input_ma_kh}
    Should Be Equal As Numbers    ${get_TTDH_in_dh_af_execute}    1    #1 : phiếu tạm
    Should Be Equal As Numbers    ${get_tongtienhang_in_dh_af_execute}    ${result_tongtienhang}
    Should Be Equal As Numbers    ${get_khachdatra_in_dh_af_execute}    ${actual_khtt}
    Should Be Equal As Numbers    ${get_giamgia_in_dh_af_execute}    ${result_ggdh}
    Should Be Equal As Numbers    ${get_tongcong_in_dh_af_execute}    ${result_khachcantra}
    Delete order frm Order code    ${get_ma_dh}
    ## Deactivate surcharge
    Run Keyword If    ${actual_surcharge1_value} > 100    Toggle surcharge VND    ${input_thukhac1}    false
    ...    ELSE    Toggle surcharge percentage    ${input_thukhac1}    false
    Run Keyword If    ${actual_surcharge2_value} > 100    Toggle surcharge VND    ${input_thukhac2}    false
    ...    ELSE    Toggle surcharge percentage    ${input_thukhac2}    false

uedtka1
    [Arguments]    ${input_ma_kh}    ${dict_product_nums}    ${list_ggsp}    ${list_discount_type}    ${input_ggdh}    ${input_khtt}    ${input_thukhac}
    #get info product, customer
    ${surcharge_vnd_value}    Get surcharge vnd value    ${input_thukhac}
    ${surcharge_%}    Get surcharge percentage value    ${input_thukhac}
    Run Keyword If    ${surcharge_%} == 0    Toggle surcharge VND    ${input_thukhac}    true    ELSE    Toggle surcharge percentage    ${input_thukhac}    true
    ${list_product}    Get Dictionary Keys    ${dict_product_nums}
    ${list_nums}    Get Dictionary Values    ${dict_product_nums}
    ${list_result_thanhtien}    ${list_result_order_summary}    ${list_result_giamoi}    Get list total sale - order summary - newprice incase discount and newprice    ${list_product}
    ...    ${list_nums}    ${list_ggsp}    ${list_discount_type}
    Reload page
    #compute
    ${result_tongtienhang}    Sum values in list    ${list_result_thanhtien}
    ${actual_surcharge_type}    Set Variable If    ${surcharge_%} == 0    ${surcharge_vnd_value}    ${surcharge_%}
    ${result_af_invoice_discount}    Minus and replace floating point    ${result_tongtienhang}    ${input_ggdh}
    ${result_per_surchare_by_invoice}    Convert % discount to VND and round    ${result_af_invoice_discount}    ${surcharge_%}
    ${actual_surcharge_value}    Set Variable If    ${surcharge_%} == 0    ${surcharge_vnd_value}    ${result_per_surchare_by_invoice}
    ${result_khachcantra}    Sum and replace floating point    ${result_af_invoice_discount}    ${actual_surcharge_value}
    ${actual_khtt_all}    Set Variable If    '${input_khtt}' == 'all'    ${result_khachcantra}    ${input_khtt}
    ${actual_khtt}    Set Variable If    '${input_khtt}' == '0'    0    ${actual_khtt_all}
    #input data into DH form
    Click Element JS    ${tab_dathang}
    ${laster_nums}    Set Variable    0
    : FOR    ${item_product}    ${item_nums}    ${item_ggsp}    ${item_price}   ${item_discount_type}    IN ZIP    ${list_product}
    ...    ${list_nums}    ${list_ggsp}    ${list_result_giamoi}    ${list_discount_type}
    \    ${laster_nums}    Wait Until Keyword Succeeds    3 times    5 s    Input product-num in sale form    ${item_product}    ${item_nums}
    \    ...    ${laster_nums}    ${cell_tongsoluong_dh}
    \    Run keyword if    '${item_discount_type}' == 'dis'     Wait Until Keyword Succeeds    3 times    5 s    Input % discount for multi product    ${item_product}    ${item_ggsp}
    \    ...    ${item_price}    ELSE IF    '${item_discount_type}' == 'disvnd'    Input VND discount for multi product    ${item_product}    ${item_ggsp}    ${item_price}
    \    ...     ELSE IF  '${item_discount_type}' == 'changeup' or '${item_discount_type}' == 'changedown'    Wait Until Keyword Succeeds    3 times    5 s    Input newprice for multi product    ${item_product}    ${item_ggsp}
    \    ...    ELSE    Log    Ignore input
    Wait Until Keyword Succeeds    3 times    20 s    Input VND discount order    ${input_ggdh}
    Run Keyword If    '${input_khtt}' == '0'    Input Khach Hang    ${input_ma_kh}
    ...    ELSE    Input Order info    ${input_ma_kh}    ${actual_khtt}    ${result_khachcantra}
    Click Element JS    ${button_bh_dathang}
    Order message success validation
    ${get_ma_dh}    Get saved code after execute
    #get values
    Sleep    20 s    wait for response to API
    #assert value product
    ${get_list_hh_in_dh_af_execute}    Get list product frm API    ${get_ma_dh}
    ${get_list_hh_in_dh_af_execute}    Reverse List one    ${get_list_hh_in_dh_af_execute}
    ${list_order_summary_af_execute}    Get list order summary frm product API    ${get_list_hh_in_dh_af_execute}
    : FOR    ${result_tong_dh}    ${order_summary_af_execute}    IN ZIP    ${list_result_order_summary}    ${list_order_summary_af_execute}
    \    Should Be Equal As Numbers    ${order_summary_af_execute}    ${result_tong_dh}
    #assert value order
    ${get_ma_kh_in_dh_af_execute}    ${get_TTDH_in_dh_af_execute}    ${get_tongtienhang_in_dh_af_execute}    ${get_khachdatra_in_dh_af_execute}    ${get_giamgia_in_dh_af_execute}    ${get_tongcong_in_dh_af_execute}    ${get_ghichu_in_dh_af_execute}    Get order info incase discount by order code
    ...    ${get_ma_dh}
    Should Be Equal As Strings    ${get_ma_kh_in_dh_af_execute}    ${input_ma_kh}
    Should Be Equal As Numbers    ${get_TTDH_in_dh_af_execute}    1    #1 : phiếu tạm
    Should Be Equal As Numbers    ${get_tongtienhang_in_dh_af_execute}    ${result_tongtienhang}
    Should Be Equal As Numbers    ${get_khachdatra_in_dh_af_execute}    ${actual_khtt}
    Should Be Equal As Numbers    ${get_giamgia_in_dh_af_execute}    ${input_ggdh}
    Should Be Equal As Numbers    ${get_tongcong_in_dh_af_execute}    ${result_khachcantra}
    Delete order frm Order code    ${get_ma_dh}
    Run Keyword If    ${surcharge_%} == 0    Toggle surcharge VND    ${input_thukhac}    false    ELSE    Toggle surcharge percentage    ${input_thukhac}    false

uedtka2
    [Arguments]    ${input_ma_kh}    ${dict_product_nums}    ${list_ggsp}    ${list_discount_type}    ${input_ggdh}    ${input_khtt}    ${input_thukhac1}
    ...    ${input_thukhac2}
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
    #get info product, customer
    ${list_product}    Get Dictionary Keys    ${dict_product_nums}
    ${list_nums}    Get Dictionary Values    ${dict_product_nums}
    ${list_result_thanhtien}    ${list_result_order_summary}    ${list_result_giamoi}    Get list total sale - order summary - newprice incase discount and newprice    ${list_product}
    ...    ${list_nums}    ${list_ggsp}    ${list_discount_type}
    Reload Page
    #compute
    ${result_tongtienhang}    Sum values in list    ${list_result_thanhtien}
    ${result_ggdh}    Convert % discount to VND and round    ${result_tongtienhang}    ${input_ggdh}
    ${result_af_invoice_discount}    Price after % discount invoice    ${result_tongtienhang}    ${input_ggdh}
    ${total_surcharge}=    Run Keyword If    ${actual_surcharge1_value} > 100 and ${actual_surcharge2_value} > 100    Sum    ${actual_surcharge1_value}    ${actual_surcharge2_value}
    ...    ELSE IF    ${actual_surcharge1_value} > 100 and ${actual_surcharge2_value} < 100    VND and Percentage Surcharges sum    ${actual_surcharge2_value}    ${result_af_invoice_discount}    ${actual_surcharge1_value}
    ...    ELSE IF    ${actual_surcharge1_value} < 100 and ${actual_surcharge2_value} < 100    Percentage and Percentage Surcharges sum    ${result_af_invoice_discount}    ${actual_surcharge1_value}    ${actual_surcharge2_value}
    ...    ELSE    Log    abv
    ${result_khachcantra}    Sum    ${result_af_invoice_discount}    ${total_surcharge}
    ${result_khachcantra}    Replace floating point    ${result_khachcantra}
    ${actual_khtt_all}    Set Variable If    '${input_khtt}' == 'all'    ${result_khachcantra}    ${input_khtt}
    ${actual_khtt}    Set Variable If    '${input_khtt}' == '0'    0    ${actual_khtt_all}
    #input data into DH form
    Click Element JS    ${tab_dathang}
    ${laster_nums}    Set Variable    0
    : FOR    ${item_product}    ${item_nums}    ${item_ggsp}    ${item_price}   ${item_discount_type}    IN ZIP    ${list_product}
    ...    ${list_nums}    ${list_ggsp}    ${list_result_giamoi}    ${list_discount_type}
    \    ${laster_nums}    Wait Until Keyword Succeeds    3 times    5 s    Input product-num in sale form    ${item_product}    ${item_nums}
    \    ...    ${laster_nums}    ${cell_tongsoluong_dh}
    \    Run keyword if    '${item_discount_type}' == 'dis'     Wait Until Keyword Succeeds    3 times    5 s    Input % discount for multi product    ${item_product}    ${item_ggsp}
    \    ...    ${item_price}    ELSE IF    '${item_discount_type}' == 'disvnd'    Input VND discount for multi product    ${item_product}    ${item_ggsp}    ${item_price}
    \    ...     ELSE IF  '${item_discount_type}' == 'changeup' or '${item_discount_type}' == 'changedown'    Wait Until Keyword Succeeds    3 times    5 s    Input newprice for multi product    ${item_product}    ${item_ggsp}
    \    ...    ELSE    Log    Ignore input
    Wait Until Keyword Succeeds    3 times    20 s    Input % discount order    ${input_ggdh}    ${result_ggdh}
    Run Keyword If    '${input_khtt}' == '0'    Input Khach Hang    ${input_ma_kh}
    ...    ELSE    Input Order info    ${input_ma_kh}    ${actual_khtt}    ${result_khachcantra}
    Click Element JS    ${button_bh_dathang}
    Order message success validation
    ${get_ma_dh}    Get saved code after execute
    #get values
    Sleep    20 s    wait for response to API
    #assert value product
    ${get_list_hh_in_dh_af_execute}    Get list product frm API    ${get_ma_dh}
    ${get_list_hh_in_dh_af_execute}    Reverse List one    ${get_list_hh_in_dh_af_execute}
    ${list_order_summary_af_execute}    Get list order summary frm product API    ${get_list_hh_in_dh_af_execute}
    : FOR    ${result_tong_dh}    ${order_summary_af_execute}    IN ZIP    ${list_result_order_summary}    ${list_order_summary_af_execute}
    \    Should Be Equal As Numbers    ${order_summary_af_execute}    ${result_tong_dh}
    #assert value order
    ${get_ma_kh_in_dh_af_execute}    ${get_TTDH_in_dh_af_execute}    ${get_tongtienhang_in_dh_af_execute}    ${get_khachdatra_in_dh_af_execute}    ${get_giamgia_in_dh_af_execute}    ${get_tongcong_in_dh_af_execute}    ${get_ghichu_in_dh_af_execute}    Get order info incase discount by order code
    ...    ${get_ma_dh}
    Should Be Equal As Strings    ${get_ma_kh_in_dh_af_execute}    ${input_ma_kh}
    Should Be Equal As Numbers    ${get_TTDH_in_dh_af_execute}    1    #1 : phiếu tạm
    Should Be Equal As Numbers    ${get_tongtienhang_in_dh_af_execute}    ${result_tongtienhang}
    Should Be Equal As Numbers    ${get_khachdatra_in_dh_af_execute}    ${actual_khtt}
    Should Be Equal As Numbers    ${get_giamgia_in_dh_af_execute}    ${result_ggdh}
    Should Be Equal As Numbers    ${get_tongcong_in_dh_af_execute}    ${result_khachcantra}
    ## Deactivate surcharge
    Delete order frm Order code    ${get_ma_dh}
    Run Keyword If    ${actual_surcharge1_value} > 100    Toggle surcharge VND    ${input_thukhac1}    false
    ...    ELSE    Toggle surcharge percentage    ${input_thukhac1}    false
    Run Keyword If    ${actual_surcharge2_value} > 100    Toggle surcharge VND    ${input_thukhac2}    false
    ...    ELSE    Toggle surcharge percentage    ${input_thukhac2}    false
