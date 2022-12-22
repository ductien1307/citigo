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
&{list_product1}    SIL011=1    Combo169=4
&{list_product_imei01}    SIL011=1
&{list_product2}    Combo168=2    Combo170=3
&{list_giveaway1}    DV031=1    DV032=1    DV033=1
&{list_giveaway2}    DV031=2
@{list_ggsp}      2000    10
@{list_giamoi}    1500000   120000
@{list_no_discount}  0      0
*** Test Cases ***    Product and num list    List imei                    Product Discount        Order Discount    Customer    Payment    Promotion Code       Khách thanh toán to create order
KM DH                 [Tags]                  UKMDH5
                      [Template]              edxkm1
                      ${list_product1}      ${list_product_imei01}    ${list_ggsp}      10          KHKM10     all          KM01          all        #giam gia HD VND

KM dat hang tang hang
                      [Documentation]         San pham KM la SP dich vu\nCase khong validate ton kho cua SP KM
                      [Tags]                  UKMDH5
                      [Template]              edxkm2
                      ${list_product2}      50000     KHKM11           250000      KM03      ${list_giveaway1}    ${list_giamoi}     0

KM dat hang giam gia SP
                      [Tags]                  UKMDH5
                      [Template]              edxkm3
                      ${list_product1}      ${list_product_imei01}         15          KHKM12           all         KM05      ${list_giveaway2}    100000

*** Keywords ***
edxkm1
    [Arguments]    ${dict_product_num}    ${dict_product_imei}    ${list_discount_product}    ${input_discount_inv}    ${input_ma_kh}    ${input_tamung}    ${input_khuyemmai}    ${input_khtt_create_order}
    ## Get info ton cuoi, cong no khach hang
    Toggle status of promotion    ${input_khuyemmai}    1
    ${order_code}     Add new order with order - order discount promotion    ${input_ma_kh}    ${dict_product_num}    ${input_khuyemmai}    ${input_khtt_create_order}
    ${list_product}    Get Dictionary Keys    ${dict_product_num}
    ${list_nums}    Get Dictionary Values    ${dict_product_num}
    ${list_product_imei}    Get Dictionary Keys    ${dict_product_imei}
    ${list_nums_imei}    Get Dictionary Values    ${dict_product_imei}
    ${invoice_value}    ${discount}    ${discount_ratio}    ${name}    Get Invoice value - Discounts - Promotion Name from Promotion Code    ${input_khuyemmai}
    Create list imei    ${list_product_imei}    ${list_nums_imei}
    ${get_ma_dh_in_dh_bf_execute}    ${get_khachdatra_in_dh_bf_execute}    ${get_ggdh_in_dh_bf_execute}    ${get_tongtienhang_in_dh_bf_execute}    ${get_tongcong_in_dh_bf_execute}    Get order code - paid - discount value frm API    ${input_ma_kh}
    ${get_no_bf_execute}    ${get_tongban_bf_execute}    ${get_tongban_tru_trahang_bf_execute}    Get Customer Debt from API    ${input_ma_kh}
    ${get_list_ordersummary_bf_execute}    Get list order summary by order code    ${order_code}
    ${list_result_order_summary}    Get list order summary after create invoice    ${get_list_ordersummary_bf_execute}    ${list_nums}
    #create lists
    ${list_result_thanhtien}    ${list_order_summary}    ${list_result_giamoi}    Get list total sale and order summary incase discount    ${list_product}    ${list_nums}    ${list_ggsp}
    Reload page
    # Input data into BH form
    Go to xu ly dat hang    ${order_code}
    Go to BH frm process order    ${order_code}
    : FOR    ${item_product}    ${item_imei}    IN ZIP    ${list_prs}    ${imei_inlist}
    \    Wait Until Keyword Succeeds    3 times    8 s    Input imei incase multi product to any form    ${item_product}    ${texbox_imei_search_multi_product}
    \    ...    ${item_serial_in_dropdown}    ${cell_imei_multi_product}    @{item_imei}
    : FOR    ${item_product}    ${item_ggsp}    ${item_price}    IN ZIP    ${list_product}    ${list_discount_product}    ${list_result_giamoi}
    \    Wait Until Keyword Succeeds    3 times    5 s    Run keyword if    0 < ${item_ggsp} < 100    Input % discount for multi product
    \    ...    ${item_product}    ${item_ggsp}    ${item_price}
    \    ...    ELSE IF    ${item_ggsp} > 100    Input VND discount for multi product    ${item_product}    ${item_ggsp}    ${item_price}
    \    ...    ELSE    Log    Ignore input
    #compute
    ${result_tongtienhang}    Sum values in list    ${list_result_thanhtien}
    ${result_af_invoice_discount}    Price after % discount invoice    ${result_tongtienhang}    ${input_discount_inv}
    ${result_discount_invoice_by_vnd}    Convert % discount to VND and round    ${result_tongtienhang}    ${input_discount_inv}
    ${result_discount_ratio_by_invoice_promo}    Convert % discount to VND and round    ${result_tongtienhang}    ${discount_ratio}
    ${actual_promo_value}    Set Variable If    ${discount} == 0    ${result_discount_ratio_by_invoice_promo}    ${discount}
    ${final_discount}=    Run Keyword If    ${result_tongtienhang} > ${invoice_value}    Sum    ${actual_promo_value}    ${result_discount_invoice_by_vnd}
    ...    ELSE    Set Variable    ${result_discount_invoice_by_vnd}
    ${result_khachcantra}    Minus    ${result_tongtienhang}    ${final_discount}
    ${result_tamung}  Run Keyword If    ${result_khachcantra}>${get_khachdatra_in_dh_bf_execute}    Minus and replace floating point        ${result_khachcantra}   ${get_khachdatra_in_dh_bf_execute}
    ...   ELSE    Minus and replace floating point    ${get_khachdatra_in_dh_bf_execute}    ${result_khachcantra}
    ${actual_tamung}    Set Variable If    '${input_tamung}' == 'all'    ${result_tamung}    ${input_tamung}
    ${result_nohientai}    Sum    ${get_no_bf_execute}    ${result_khachcantra}
    ${result_PTT_hd_KH}    Sum    ${result_nohientai}    ${actual_tamung}
    ${result_tongban}    Sum    ${result_khachcantra}    ${get_tongban_bf_execute}
    #create order
    Wait Until Keyword Succeeds    3 times    8 s    Input % discount invoice    ${input_discount_inv}    ${final_discount}
    Run Keyword If    '${input_tamung}' == 'all'    Click Element JS    ${button_bh_thanhtoan}
    ...    ELSE    Input customer payment and deposit refund into BH form    ${actual_tamung}
    SLeep    5s
    ${invoice_code}    Get saved code after execute
    #get values
    Sleep    20 s    wait for response to API
    #assert value invoice
    ${get_ma_kh_by_hd}    ${get_tong_tien_hang}    ${get_khachtt_af_execute}    ${get_gghd_af_execute}    ${get_khachcantra}    ${get_trangthai}    ${get_ghichu_in_hd_af_execute}
    ...    Get invoice info have note incase discount by invoice code    ${invoice_code}
    Should Be Equal As Numbers    ${get_tong_tien_hang}    ${result_tongtienhang}
    Should Be Equal As Numbers    ${get_khachcantra}    ${result_khachcantra}
    Should Be Equal As Numbers    ${get_khachtt_af_execute}    ${result_khachcantra}
    Should Be Equal As Strings    ${get_ma_kh_by_hd}    ${input_ma_kh}
    Should Be Equal As Numbers    ${get_gghd_af_execute}    ${final_discount}
    Should Be Equal As Strings    ${get_trangthai}    Hoàn thành
    ${get_ma_kh_in_dh_af_execute}    ${get_TTDH_in_dh_af_execute}    ${get_tongtienhang_in_dh_af_exxecute}    ${get_khachdatra_in_dh_af_execute}    ${get_giamgia_in_dh_af_execute}    ${get_tongcong_in_dh_af_execute}    ${get_ghichu_in_dh_af_execute}
    ...    Get order info have note incase discount by order code    ${order_code}
    Should Be Equal As Strings    ${get_ma_kh_in_dh_af_execute}    ${input_ma_kh}
    Should Be Equal As Numbers    ${get_TTDH_in_dh_af_execute}    3    #trạng thái hoàn thành
    Should Be Equal As Numbers    ${get_tongtienhang_in_dh_af_exxecute}    ${get_tongtienhang_in_dh_bf_execute}
    Should Be Equal As Numbers    ${get_khachdatra_in_dh_af_execute}    ${result_khachcantra}
    Should Be Equal As Numbers    ${get_giamgia_in_dh_af_execute}    ${get_ggdh_in_dh_bf_execute}
    Should Be Equal As Numbers    ${get_tongcong_in_dh_af_execute}    ${get_tongcong_in_dh_bf_execute}
    Validate invoice history frm Order    ${order_code}    ${invoice_code}    ${result_khachcantra}
    #assert value product
    ${get_list_ordersummary_af_execute}    Get list order summary by order code    ${order_code}
    : FOR    ${result_order_summary}    ${order_summary_af_execute}    IN ZIP    ${list_result_order_summary}    ${get_list_ordersummary_af_execute}
    \    Should Be Equal As Numbers    ${order_summary_af_execute}    ${result_order_summary}
    #assert customer and so quy
    ${get_no_af_execute_kh}    ${get_tongban_af_execute_kh}    ${get_tongban_tru_trahang_af_execute_kh}    Run Keyword If    ${input_tamung}!=0    Get Customer Debt from API after purchase    ${input_ma_kh}
    ...    ${invoice_code}    ${result_tongtienhang}
    ...    ELSE    Get Customer Debt from API    ${input_ma_kh}
    ${get_maphieu_soquy}    Get Ma Phieu Thu in So quy    ${invoice_code}
    Run Keyword If    '${input_tamung}' == '0'    Should Be Equal As Numbers    ${get_no_af_execute_kh}    ${result_nohientai}
    ...    ELSE    Should Be Equal As Numbers    ${get_no_af_execute_kh}    ${result_PTT_hd_KH}
    Should Be Equal As Numbers    ${get_tongban_af_execute_kh}    ${result_tongban}
    Run Keyword If    '${input_tamung}' == '0'    Validate customer history and debt if invoice is not paid frm order    ${input_ma_kh}    ${invoice_code}    ${result_nohientai}
    ...    ELSE    Validate customer history and debt if invoice is paid deposit refund frm order    ${input_ma_kh}    ${invoice_code}    ${result_nohientai}    ${result_PTT_hd_KH}
    Run Keyword If    '${result_tongtienhang}' == '0'    Validate history tab of customer frm Order    ${input_ma_kh}    ${invoice_code}
    Run Keyword If    '${input_tamung}' == '0'    Validate So quy info from Rest API if Invoice is not paid    ${get_maphieu_soquy}
    ...    ELSE    Validate So quy info from Rest API if Invoice is paid    ${get_maphieu_soquy}    ${result_tamung}
    Delete invoice by invoice code    ${invoice_code}
    Delete order frm Order code    ${order_code}
    Toggle status of promotion    ${input_khuyemmai}    0

edxkm2
    [Arguments]    ${dict_product_nums}    ${input_gghd}    ${input_ma_kh}    ${input_bh_khachtt}    ${input_khuyemmai}    ${list_giveaway}
    ...    ${list_newprice}   ${input_khach_tt_to_create}
    [Timeout]
    ## Get info ton cuoi, cong no khach hang
    Toggle status of promotion    ${input_khuyemmai}    1
    ${order_code}     Add new order with order - Offering free items Promotion    ${input_ma_kh}    ${dict_product_nums}    ${input_khuyemmai}    ${list_giveaway}       ${input_khach_tt_to_create}
    ${invoice_value}    ${received_value}    ${discount}    ${discount_ratio}    ${name}    Get Invoice value - Received value - Discounts - Promotion Name from Promotion Code    ${input_khuyemmai}
    #create lists
    ${list_product}    Get Dictionary Keys    ${dict_product_nums}
    ${list_nums}    Get Dictionary Values    ${dict_product_nums}
    ${get_ma_dh_in_dh_bf_execute}    ${get_khachdatra_in_dh_bf_execute}    ${get_ggdh_in_dh_bf_execute}    ${get_tongtienhang_in_dh_bf_execute}    ${get_tongcong_in_dh_bf_execute}    Get order code - paid - discount value frm API    ${input_ma_kh}
    ${get_list_hh_in_dh_bf_execute}    ${get_ghichu_bf_execute}    Get ghi chu and list product frm API    ${order_code}
    ${get_list_nums}   ${get_list_ordersummary_bf_execute}    Get list quantity - order summary frm API    ${order_code}    ${get_list_hh_in_dh_bf_execute}
    ${list_result_order_summary}    Get list order summary after create invoice    ${get_list_ordersummary_bf_execute}    ${get_list_nums}
    ${result_list_thanhtien}    Create List
    :FOR    ${item_giaban}    ${item_soluong}   IN ZIP    ${list_newprice}    ${list_nums}
    \     ${result_thanhtien}    Multiplication and round    ${item_giaban}    ${item_soluong}
    \     Append to list    ${result_list_thanhtien}     ${result_thanhtien}
    Reload Page
    # Input data into BH form
    Go to xu ly dat hang    ${order_code}
    Go to BH frm process order    ${order_code}
    : FOR    ${item_ma_hh}    ${item_giamoi}    IN ZIP    ${list_product}    ${list_newprice}
    \    Wait Until Keyword Succeeds    3 times    5 s    Input newprice for multi product    ${item_ma_hh}    ${item_giamoi}
    #compute
    ${result_tongtienhang}    Sum values in list    ${result_list_thanhtien}
    ${result_khachcantra}    Minus    ${result_tongtienhang}    ${input_gghd}
    ${actual_khachtt}    Set Variable If    '${input_bh_khachtt}' == 'all'    ${result_khachcantra}    ${input_bh_khachtt}
    ${result_khachdatra}      Sum     ${get_khachdatra_in_dh_bf_execute}    ${actual_khachtt}
    #create order
    Wait Until Keyword Succeeds    3 times    8 s    Input VND discount invoice    ${input_gghd}
    Run Keyword If    "${input_bh_khachtt}" == "all"    Click Element JS    ${button_bh_thanhtoan}
    ...    ELSE    Input customer payment into BH form    ${input_bh_khachtt}    ${result_khachcantra}
    SLeep    5s
    ${invoice_code}    Get saved code after execute
    #get values
    Sleep    20 s    wait for response to API
    #assert value invoice
    ${get_ma_kh_by_hd}    ${get_tong_tien_hang}    ${get_khachtt_af_execute}    ${get_gghd_af_execute}    ${get_khachcantra}    ${get_trangthai}    ${get_ghichu_in_hd_af_execute}
    ...    Get invoice info have note incase discount by invoice code    ${invoice_code}
    Should Be Equal As Numbers    ${get_tong_tien_hang}    ${result_tongtienhang}
    Should Be Equal As Numbers    ${get_khachcantra}    ${result_khachcantra}
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
    Validate invoice history frm Order    ${order_code}    ${invoice_code}    ${result_khachcantra}
    #assert value product
    ${list_order_summary_af_execute}    Get list order summary by order code    ${order_code}
    : FOR    ${result_tong_dh}    ${order_summary_af_execute}    IN ZIP    ${list_result_order_summary}    ${list_order_summary_af_execute}
    \    Should Be Equal As Numbers    ${order_summary_af_execute}    ${result_tong_dh}
    Delete invoice by invoice code    ${invoice_code}
    Delete order frm Order code    ${order_code}
    Toggle status of promotion    ${input_khuyemmai}    0

edxkm3
    [Arguments]    ${dict_product_num}    ${dict_product_imei}    ${input_gghd}    ${input_ma_kh}    ${input_bh_khachtt}    ${input_khuyemmai}    ${dict_promo_product}
    ...   ${input_khtt_create_order}
    [Timeout]
    ## Get info ton cuoi, cong no khach hang
    Toggle status of promotion    ${input_khuyemmai}    1
    ${order_code}     Add new order with order - offering discount pricing promotion    ${input_ma_kh}    ${dict_product_num}    ${input_khuyemmai}    ${dict_promo_product}   ${input_khtt_create_order}
    ${list_product_imei}    Get Dictionary Keys    ${dict_product_imei}
    ${list_nums_imei}    Get Dictionary Values    ${dict_product_imei}
    ${invoice_value}    ${discount}    ${discount_ratio}    ${name}    Get Invoice value - Discounts - Promotion Name from Promotion Code    ${input_khuyemmai}
    Create list imei    ${list_product_imei}    ${list_nums_imei}
    ${list_product}    Get Dictionary Keys    ${dict_product_num}
    ${list_nums}    Get Dictionary Values    ${dict_product_num}
    ${list_promo_product}    Get Dictionary Keys    ${dict_promo_product}
    ${list_promo_num}    Get Dictionary Values    ${dict_promo_product}
    ${get_ma_dh_in_dh_bf_execute}    ${get_khachdatra_in_dh_bf_execute}    ${get_ggdh_in_dh_bf_execute}    ${get_tongtienhang_in_dh_bf_execute}    ${get_tongcong_in_dh_bf_execute}    Get order code - paid - discount value frm API    ${input_ma_kh}
    ${get_list_hh_in_dh_bf_execute}    ${get_ghichu_bf_execute}    Get ghi chu and list product frm API    ${order_code}
    ${get_list_nums}   ${get_list_ordersummary_bf_execute}    Get list quantity - order summary frm API    ${order_code}    ${get_list_hh_in_dh_bf_execute}
    ${list_result_order_summary}    Get list order summary after create invoice    ${get_list_ordersummary_bf_execute}    ${get_list_nums}
    #create lists
    Reload Page
    #order summary
    ${result_ggdh}    Convert % discount to VND and round    ${get_tongtienhang_in_dh_bf_execute}    ${input_gghd}
    ${result_khachcantra}    Minus    ${get_tongtienhang_in_dh_bf_execute}    ${result_ggdh}
    ${actual_khachtt}    Set Variable If    '${input_bh_khachtt}' == 'all'    ${result_khachcantra}    ${input_bh_khachtt}
    #create order
    Go to xu ly dat hang    ${order_code}
    Go to BH frm process order    ${order_code}
    : FOR    ${item_product}    ${item_imei}    IN ZIP    ${list_prs}    ${imei_inlist}
    \    Wait Until Keyword Succeeds    3 times    8 s    Input imei incase multi product to any form    ${item_product}    ${texbox_imei_search_multi_product}
    \    ...    ${item_serial_in_dropdown}    ${cell_imei_multi_product}    @{item_imei}
    Wait Until Keyword Succeeds    3 times    8 s    Input % discount invoice    ${input_gghd}    ${result_ggdh}
    Run Keyword If    "${input_bh_khachtt}" == "all"    Click Element JS    ${button_bh_thanhtoan}
    ...    ELSE    Input customer payment into BH form    ${input_bh_khachtt}    ${result_khachcantra}
    Sleep  5s
    ${invoice_code}    Get saved code after execute
    #get values
    Sleep    20 s    wait for response to API
    #assert value invoice
    ${get_ma_kh_by_hd}    ${get_tong_tien_hang}    ${get_khachtt_af_execute}    ${get_gghd_af_execute}    ${get_khachcantra}    ${get_trangthai}    ${get_ghichu_in_hd_af_execute}
    ...    Get invoice info have note incase discount by invoice code    ${invoice_code}
    Should Be Equal As Numbers    ${get_tong_tien_hang}    ${get_tongtienhang_in_dh_bf_execute}
    Should Be Equal As Numbers    ${get_khachcantra}    ${result_khachcantra}
    Should Be Equal As Numbers    ${get_khachtt_af_execute}    ${result_khachcantra}
    Should Be Equal As Strings    ${get_ma_kh_by_hd}    ${input_ma_kh}
    Should Be Equal As Numbers    ${get_gghd_af_execute}    ${result_ggdh}
    Should Be Equal As Strings    ${get_trangthai}    Hoàn thành
    #assert value order
    ${get_ma_kh_in_dh_af_execute}    ${get_TTDH_in_dh_af_execute}    ${get_tongtienhang_in_dh_af_exxecute}    ${get_khachdatra_in_dh_af_execute}    ${get_giamgia_in_dh_af_execute}    ${get_tongcong_in_dh_af_execute}    ${get_ghichu_in_dh_af_execute}
    ...    Get order info have note incase discount by order code    ${order_code}
    Should Be Equal As Strings    ${get_ma_kh_in_dh_af_execute}    ${input_ma_kh}
    Should Be Equal As Numbers    ${get_TTDH_in_dh_af_execute}    3    #trạng thái hoàn thành
    Should Be Equal As Numbers    ${get_tongtienhang_in_dh_af_exxecute}    ${get_tongtienhang_in_dh_bf_execute}
    Should Be Equal As Numbers    ${get_khachdatra_in_dh_af_execute}    ${result_khachcantra}
    Should Be Equal As Numbers    ${get_giamgia_in_dh_af_execute}    ${get_ggdh_in_dh_bf_execute}
    Should Be Equal As Numbers    ${get_tongcong_in_dh_af_execute}    ${get_tongcong_in_dh_bf_execute}
    Validate invoice history frm Order    ${order_code}    ${invoice_code}    ${result_khachcantra}
    #assert value product
    ${list_order_summary_af_execute}    Get list order summary by order code    ${order_code}
    : FOR    ${result_tong_dh}    ${order_summary_af_execute}    IN ZIP    ${list_result_order_summary}    ${list_order_summary_af_execute}
    \    Should Be Equal As Numbers    ${order_summary_af_execute}    ${result_tong_dh}
    Delete invoice by invoice code    ${invoice_code}
    Delete order frm Order code    ${order_code}
    Toggle status of promotion    ${input_khuyemmai}    0
