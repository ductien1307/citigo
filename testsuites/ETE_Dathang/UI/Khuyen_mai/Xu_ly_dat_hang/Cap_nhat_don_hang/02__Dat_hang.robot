*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    ${headless_browser}
Test Setup        Before Test Ban Hang
Test Teardown     After Test
Resource          ../../../../../../core/API/api_thietlap.robot
Resource          ../../../../../../core/API/api_dathang.robot
Resource          ../../../../../../core/Ban_Hang/banhang_getandcompute.robot
Resource          ../../../../../../core/share/toast_message.robot
Resource          ../../../../../../core/API/api_mhbh_dathang.robot
Resource          ../../../../../../core/API/api_soquy.robot
Resource          ../../../../../../core/API/api_danhmuc_hanghoa.robot
Resource          ../../../../../../core/Dat_Hang/dat_hang_action.robot
Resource          ../../../../../../core/Dat_Hang/dat_hang_page.robot

*** Variables ***
&{list_product1}    Combo166=3.5    DVL011=1
&{list_product2}    Combo167=4
&{list_giveaway1}    DV031=1    DV032=1    DV033=1
&{list_giveaway2}    DV031=2
&{list_giveaway_add}    DV031=1    DV032=1
@{list_ggsp}      2000    10
@{list_giamoi}    1500000
${list_no_discount}  0      0

*** Test Cases ***    Product and num list    Product Discount                                                    Order Discount    Customer    Payment    Promotion Code       Khách thanh toán to create order
KM DH                 [Tags]                  UKMDH3
                      [Template]              edukm1
                      ${list_product1}        ${list_ggsp}                                                        10                 KHKM04     0          KM01          500000        #giam gia HD VND

KM dat hang tang hang
                      [Documentation]         San pham KM la SP dich vu\nCase khong validate ton kho cua SP KM
                      [Tags]                  UKMDH3
                      [Template]              edukm2
                      ${list_product2}        50000                                                               KHKM05           all      KM03      ${list_giveaway1}    ${list_giamoi}     0

KM dat hang giam gia SP
                      [Tags]                  UKMDH3
                      [Template]              edukm3
                      ${list_product1}         15                                                               KHKM06           all         KM05      ${list_giveaway2}    ${list_no_discount}      100000      ${list_giveaway_add}

*** Keywords ***
edukm1
    [Arguments]    ${dict_product_num}    ${list_discount_product}    ${input_ggdh}    ${input_ma_kh}    ${input_bh_khachtt}    ${input_khuyemmai}    ${input_khtt_create_order}
    ## Get info ton cuoi, cong no khach hang
    Toggle status of promotion    ${input_khuyemmai}    1
    ${order_code}     Add new order with order - order discount promotion    ${input_ma_kh}    ${dict_product_num}    ${input_khuyemmai}    ${input_khtt_create_order}
    ${list_product}    Get Dictionary Keys    ${dict_product_num}
    ${list_nums}    Get Dictionary Values    ${dict_product_num}
    ${invoice_value}    ${discount}    ${discount_ratio}    ${name}    Get Invoice value - Discounts - Promotion Name from Promotion Code    ${input_khuyemmai}
    ${get_no_bf_execute}    ${get_tongban_bf_execute}    ${get_tongban_tru_trahang_bf_execute}    Get Customer Debt from API    ${input_ma_kh}
    ${get_khachdatra_in_dh_bf_execute}    ${get_tongtienhang_in_dh_bf_execute}    Get paid value frm API    ${order_code}
    ${get_list_ordersummary_bf_execute}    Get list order summary by order code    ${order_code}
    #create lists
    ${list_result_thanhtien}    ${list_result_order_summary}    ${list_result_giamoi}    Get list total sale and order summary incase discount    ${list_product}    ${list_nums}    ${list_ggsp}
    Reload page
    # Input data into BH form
    Go to xu ly dat hang    ${order_code}
    : FOR    ${item_product}    ${item_ggsp}    ${item_price}    IN ZIP    ${list_product}    ${list_discount_product}    ${list_result_giamoi}
    \    Wait Until Keyword Succeeds    3 times    5 s    Run keyword if    0 < ${item_ggsp} < 100    Input % discount for multi product
    \    ...    ${item_product}    ${item_ggsp}    ${item_price}
    \    ...    ELSE IF    ${item_ggsp} > 100    Input VND discount for multi product    ${item_product}    ${item_ggsp}    ${item_price}
    \    ...    ELSE    Log    Ignore input
    #compute
    ${result_tongtienhang}    Sum values in list    ${list_result_thanhtien}
    ${result_af_invoice_discount}    Price after % discount invoice    ${result_tongtienhang}    ${input_ggdh}
    ${result_discount_invoice_by_vnd}    Convert % discount to VND and round    ${result_tongtienhang}    ${input_ggdh}
    ${result_discount_ratio_by_invoice_promo}    Convert % discount to VND and round    ${result_tongtienhang}    ${discount_ratio}
    ${actual_promo_value}    Set Variable If    ${discount} == 0    ${result_discount_ratio_by_invoice_promo}    ${discount}
    ${final_discount}=    Run Keyword If    ${result_tongtienhang} > ${invoice_value}    Sum    ${actual_promo_value}    ${result_discount_invoice_by_vnd}
    ...    ELSE    Set Variable    ${result_discount_invoice_by_vnd}
    ${result_khachcantra}    Minus    ${result_tongtienhang}    ${final_discount}
    ${result_khachcantra}    Replace floating point    ${result_khachcantra}
    ${actual_khachtt}    Set Variable If    '${input_bh_khachtt}' == 'all'    ${result_khachcantra}    ${input_bh_khachtt}
    ${result_khachdatra}    Sum    ${get_khachdatra_in_dh_bf_execute}    ${actual_khachtt}
    ${result_nohientai}    Minus    ${get_no_bf_execute}    ${actual_khachtt}
    ${result_tongban}    Sum    ${result_khachcantra}    ${get_tongban_bf_execute}
    #create order
    Wait Until Keyword Succeeds    3 times    8 s    Input % discount order    ${input_ggdh}    ${final_discount}
    Run Keyword If    ${input_bh_khachtt}>0    Input order payment into BH    ${actual_khachtt}    ${result_khachcantra}    ELSE    Log    igrnore input
    Click Element JS    ${button_luu_order}
    SLeep    0.5s
    Order message success validation
    ${order_code}    Get saved code after execute
    #get values
    Sleep    20 s    wait for response to API
    #assert values in order
    ${get_ma_kh_in_dh_af_execute}    ${get_TTDH_in_dh_af_execute}    ${get_tongtienhang_in_dh_af_exxecute}    ${get_khachdatra_in_dh_af_execute}    ${get_giamgia_in_dh_af_execute}    ${get_tongcong_in_dh_af_execute}    ${get_ghichu_in_dh_af_execute}
    ...    Get order info incase discount by order code    ${order_code}
    Should Be Equal As Strings    ${get_ma_kh_in_dh_af_execute}    ${get_ma_kh_in_dh_af_execute}
    Should Be Equal As Numbers    ${get_TTDH_in_dh_af_execute}    1    #1 : phiếu tạm
    Should Be Equal As Numbers    ${get_tongtienhang_in_dh_af_exxecute}    ${result_tongtienhang}
    Should Be Equal As Numbers    ${get_khachdatra_in_dh_af_execute}    ${result_khachdatra}
    Should Be Equal As Numbers    ${get_giamgia_in_dh_af_execute}    ${final_discount}
    Should Be Equal As Numbers    ${get_tongcong_in_dh_af_execute}    ${result_khachcantra}
    #assert value product
    ${get_list_ordersummary_af_execute}    Get list order summary by order code    ${order_code}
    : FOR    ${get_order_summary_bf_execute}    ${order_summary_af_execute}    IN ZIP    ${get_list_ordersummary_bf_execute}    ${get_list_ordersummary_af_execute}
    \    Should Be Equal As Numbers    ${order_summary_af_execute}    ${get_order_summary_bf_execute}
    #assert value khach hang and so quy
    ${get_no_af_execute}    ${get_tongban_af_execute}    ${get_tongban_tru_trahang_af_execute}    Get Customer Debt from API    ${input_ma_kh}
    ${get_ma_phieutt_in_dh}    Get ma phieu thanh toan dat hang frm API    ${order_code}
    Should Be Equal As Numbers    ${get_no_af_execute}    ${result_nohientai}
    Should Be Equal As Numbers    ${get_tongban_af_execute}    ${get_tongban_bf_execute}
    Should Be Equal As Numbers    ${get_tongban_tru_trahang_af_execute}    ${get_tongban_tru_trahang_bf_execute}
    Run Keyword If    '${input_bh_khachtt}' == '0'    Validate history in customer if order is not paid    ${input_ma_kh}    ${order_code}
    ...    ELSE    Validate history and debt in customer if order is paid    ${input_ma_kh}    ${order_code}    ${actual_khachtt}    ${result_nohientai}
    Run Keyword If    '${input_bh_khachtt}' == '0'    Validate So quy info if Order is not paid    ${order_code}
    ...    ELSE    Validate So quy info if Order is paid    ${get_ma_phieutt_in_dh}    ${actual_khachtt}
    Delete order frm Order code    ${order_code}
    Toggle status of promotion    ${input_khuyemmai}    0

edukm2
    [Arguments]    ${dict_product_nums}    ${input_ggdh}    ${input_ma_kh}    ${input_bh_khachtt}    ${input_khuyemmai}    ${list_giveaway}
    ...    ${list_newprice}   ${input_khach_tt_to_create}
    [Timeout]
    ## Get info ton cuoi, cong no khach hang
    Toggle status of promotion    ${input_khuyemmai}    1
    ${order_code}     Add new order with order - Offering free items Promotion    ${input_ma_kh}    ${dict_product_nums}    ${input_khuyemmai}    ${list_giveaway}       ${input_khach_tt_to_create}
    ${invoice_value}    ${received_value}    ${discount}    ${discount_ratio}    ${name}    Get Invoice value - Received value - Discounts - Promotion Name from Promotion Code    ${input_khuyemmai}
    #create lists
    ${list_prs}    Get Dictionary Keys    ${dict_product_nums}
    ${list_nums}    Get Dictionary Values    ${dict_product_nums}
    ${list_giveaway_product}    Get Dictionary Keys    ${list_giveaway}
    ${list_giveaway_num}    Get Dictionary Values    ${list_giveaway}
    ${get_khachdatra_in_dh_bf_execute}    ${get_tongtienhang_in_dh_bf_execute}    Get paid value frm API    ${order_code}
    ${get_list_ordersummary_bf_execute}    Get list order summary by order code    ${order_code}
    Reload Page
    # Input data into BH form
    Go to xu ly dat hang    ${order_code}
    ${list_result_thanhtien}    ${list_result_order_summary}    Get list total sale and order summary incase newprice    ${list_prs}    ${list_nums}    ${list_newprice}
    : FOR    ${item_ma_hh}    ${item_giamoi}    IN ZIP    ${list_prs}    ${list_newprice}
    \    Wait Until Keyword Succeeds    3 times    5 s    Input newprice for multi product    ${item_ma_hh}    ${item_giamoi}
    #compute
    ${result_tongtienhang}    Sum values in list    ${list_result_thanhtien}
    ${result_khachcantra}    Minus and replace floating point    ${result_tongtienhang}    ${input_ggdh}
    ${actual_khachtt}    Set Variable If    '${input_bh_khachtt}' == 'all'    ${result_khachcantra}    ${input_bh_khachtt}
    ${result_khachdatra}      Sum     ${get_khachdatra_in_dh_bf_execute}    ${actual_khachtt}
    #create order
    Wait Until Keyword Succeeds    3 times    8 s    Input VND discount order    ${input_ggdh}
    Run Keyword If    ${input_bh_khachtt}!=0    Input order payment into BH    ${actual_khachtt}    ${result_khachcantra}    ELSE    Log    igrnore input
    Click Element JS    ${button_luu_order}
    SLeep    0.5s
    Order message success validation
    ${order_code}    Get saved code after execute
    #get values
    Sleep    20 s    wait for response to API
    #assert values in order
    ${get_ma_kh_in_dh_af_execute}    ${get_TTDH_in_dh_af_execute}    ${get_tongtienhang_in_dh_af_exxecute}    ${get_khachdatra_in_dh_af_execute}    ${get_giamgia_in_dh_af_execute}    ${get_tongcong_in_dh_af_execute}    ${get_ghichu_in_dh_af_execute}
    ...    Get order info incase discount by order code    ${order_code}
    Should Be Equal As Strings    ${get_ma_kh_in_dh_af_execute}    ${get_ma_kh_in_dh_af_execute}
    Should Be Equal As Numbers    ${get_TTDH_in_dh_af_execute}    1    #1 : phiếu tạm
    Should Be Equal As Numbers    ${get_tongtienhang_in_dh_af_exxecute}    ${result_tongtienhang}
    Should Be Equal As Numbers    ${get_khachdatra_in_dh_af_execute}    ${result_khachdatra}
    Should Be Equal As Numbers    ${get_giamgia_in_dh_af_execute}    ${input_ggdh}
    Should Be Equal As Numbers    ${get_tongcong_in_dh_af_execute}    ${result_khachcantra}
    #assert value product
    ${list_order_summary_af_execute}    Get list order summary by order code    ${order_code}
    : FOR    ${result_tong_dh}    ${order_summary_af_execute}    IN ZIP    ${get_list_ordersummary_bf_execute}    ${list_order_summary_af_execute}
    \    Should Be Equal As Numbers    ${order_summary_af_execute}    ${result_tong_dh}
    Delete order frm Order code    ${order_code}
    Toggle status of promotion    ${input_khuyemmai}    0
    Reload Page

edukm3
    [Arguments]    ${dict_product_num}    ${input_ggdh}    ${input_bh_ma_kh}    ${input_bh_khachtt}    ${input_khuyemmai}    ${dict_promo_product}
    ...    ${list_ggsp}   ${input_khtt_create_order}    ${dict_promo_product_add}
    [Timeout]
    ## Get info ton cuoi, cong no khach hang
    Toggle status of promotion    ${input_khuyemmai}    1
    ${order_code}     Add new order with order - offering discount pricing promotion    ${input_bh_ma_kh}    ${dict_product_num}    ${input_khuyemmai}    ${dict_promo_product}   ${input_khtt_create_order}
    ${invoice_value}    ${received_value}    ${discount}    ${discount_ratio}    ${name}    Get Invoice value - Received value - Discounts - Promotion Name from Promotion Code    ${input_khuyemmai}
    ${list_product}    Get Dictionary Keys    ${dict_product_num}
    ${list_nums}    Get Dictionary Values    ${dict_product_num}
    ${list_promo_product}    Get Dictionary Keys    ${dict_promo_product}
    ${list_promo_num}    Get Dictionary Values    ${dict_promo_product}
    ${list_promo_product_add}    Get Dictionary Keys    ${dict_promo_product_add}
    ${list_promo_num_add}    Get Dictionary Values    ${dict_promo_product_add}
    ${get_khachdatra_in_dh_bf_execute}    ${get_tongtienhang_in_dh_bf_execute}    Get paid value frm API    ${order_code}
    Reload Page
    #get data
    ${result_list_thanhtien}  Create List
    ${get_list_giaban}  Get list of Baseprice by Product Code    ${list_product}
    :FOR    ${item_giaban}    ${item_soluong}   IN ZIP    ${get_list_giaban}    ${list_nums}
    \     ${result_thanhtien}    Multiplication and round    ${item_giaban}    ${item_soluong}
    \     Append to list    ${result_list_thanhtien}     ${result_thanhtien}
    # Promo products
    ${list_result_totalsale_promo}    ${list_result_onhand_promo}    Run keyword if    ${discount} != 0    Get list of total sale - result onhand in case discount product    ${list_promo_product_add}    ${list_promo_num_add}
    ...    ${discount}
    ...    ELSE    Get list of total sale - result onhand in case discount product    ${list_promo_product_add}    ${list_promo_num_add}    ${discount_ratio}
    ${total_promo_sale}    Sum values in list    ${list_result_totalsale_promo}
    ${get_list_ordersummary_bf_execute}   Get list order summary by order code    ${order_code}
    ${list_result_order_summary_add}    Get list result order summary frm product API    ${list_promo_product_add}    ${list_promo_num_add}
    : FOR    ${order_summary}    IN    @{list_result_order_summary_add}
    \    Append To List    ${get_list_ordersummary_bf_execute}    ${order_summary}
    Log    ${get_list_ordersummary_bf_execute}
    #computation
    ${result_tongtienhang}    Sum values in list    ${result_list_thanhtien}
    ${result_tongtienhang_promo}    Sum    ${result_tongtienhang}    ${total_promo_sale}
    ${actual_tongtienhang}    Set Variable If    ${result_tongtienhang} > ${invoice_value}    ${result_tongtienhang_promo}    ${result_tongtienhang}
    ${result_ggdh}    Convert % discount to VND and round    ${actual_tongtienhang}    ${input_ggdh}
    ${result_khachcantra}   Minusx3 and replace foating point    ${actual_tongtienhang}   ${get_khachdatra_in_dh_bf_execute}    ${result_ggdh}
    ${actual_khachtt}    Set Variable If    '${input_bh_khachtt}' == 'all'    ${result_khachcantra}    ${input_bh_khachtt}
    ${result_khachdatra}      Sum     ${get_khachdatra_in_dh_bf_execute}    ${actual_khachtt}
    #create order
    Go to xu ly dat hang    ${order_code}
    Click Element JS    ${icon_dongy_reset_promo}
    Run Keyword If    ${result_tongtienhang} > ${invoice_value}    Wait Until Keyword Succeeds    3 times    8 s    Select order promotion and giveaway product by search product    ${name}
    ...    ${list_promo_product_add}    ${list_promo_num_add}    ELSE    Log    Ignore input
    Wait Until Keyword Succeeds    3 times    8 s    Input % discount order    ${input_ggdh}    ${result_ggdh}
    Run Keyword If    ${input_bh_khachtt}!=0    Input order payment into BH    ${actual_khachtt}    ${result_khachcantra}    ELSE    Log    igrnore input
    Click Element JS    ${button_luu_order}
    Sleep   0.5s
    Order message success validation
    ${order_code}    Get saved code after execute
    #get values
    Sleep    20 s    wait for response to API
    #assert values in order
    ${get_ma_kh_in_dh_af_execute}    ${get_TTDH_in_dh_af_execute}    ${get_tongtienhang_in_dh_af_exxecute}    ${get_khachdatra_in_dh_af_execute}    ${get_giamgia_in_dh_af_execute}    ${get_tongcong_in_dh_af_execute}    ${get_ghichu_in_dh_af_execute}
    ...    Get order info incase discount by order code    ${order_code}
    Should Be Equal As Strings    ${get_ma_kh_in_dh_af_execute}    ${get_ma_kh_in_dh_af_execute}
    Should Be Equal As Numbers    ${get_TTDH_in_dh_af_execute}    1    #1 : phiếu tạm
    Should Be Equal As Numbers    ${get_tongtienhang_in_dh_af_exxecute}    ${actual_tongtienhang}
    Should Be Equal As Numbers    ${get_khachdatra_in_dh_af_execute}    ${result_khachdatra}
    Should Be Equal As Numbers    ${get_giamgia_in_dh_af_execute}    ${result_ggdh}
    Should Be Equal As Numbers    ${get_tongcong_in_dh_af_execute}    ${result_khachdatra}
    #assert value product
    ${list_order_summary_af_execute}    Get list order summary frm product API    ${list_product}
    : FOR    ${result_tong_dh}    ${order_summary_af_execute}    IN ZIP    ${get_list_ordersummary_bf_execute}    ${list_order_summary_af_execute}
    \    Should Be Equal As Numbers    ${order_summary_af_execute}    ${result_tong_dh}
    Delete order frm Order code    ${order_code}
    Toggle status of promotion    ${input_khuyemmai}    0
