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
&{dict_product1}      PROMO3=1    HH0034=1
&{dict_product_new}    DVL009=1
&{dict_promo_nor1}    HKM001=2    HKM002=2
&{dict_promo_nor2}    HKM001=4
&{dict_promo_update1}    HKM001=4    HKM002=2
&{dict_promo_update2}     HKM001=1    HKM002=3
&{list_product2}    DVL010=3
@{list_no_discount}    0    0    0    0    0
@{list_quantity}    5

*** Test Cases ***    List product nums    GGDH                                                                Mã KH      Khách thanh toán    Mã khuyến mãi    List product          List GGSP              KTT to create order    List product add
KM HH hinh thuc mua hang GG hang
                      [Tags]               UKMDH2
                      [Template]           eduhh01
                      ${dict_product1}     10000                                                               KHKM01    10000               KM06            ${dict_promo_nor1}    ${list_no_discount}    0       ${dict_product_new}    ${dict_promo_update1}   #mua hang gg hang vnd

KM HH hinh thuc mua hang tang hang
                      [Tags]               UKMDH2
                      [Template]           eduhh02
                      ${dict_product1}     2000                                                                KHKM02    all                 KM08            ${dict_promo_nor2}    5000      ${dict_promo_update2}    #mua hang gg hang tang hang

KM HH hinh thuc gia ban theo SL mua
                      [Documentation]      San pham KM la SP dich vu\nCase khong validate ton kho cua SP KM
                      [Tags]               UKMDH2
                      [Template]           eduhh03
                      ${list_product2}     10                                                                  KHKM03    0                   KM11            100000                ${list_quantity}       ${list_no_discount}                 #giam gia san pham theo so luong mua %

*** Keywords ***
eduhh01
    [Arguments]    ${dict_product_num}    ${input_discount_order}    ${input_ma_kh}    ${input_bh_khachtt}    ${input_khuyemmai}    ${dict_promo_product}
    ...    ${list_ggsp}    ${input_khtt_create_order}    ${dict_product_add}      ${dict_promo_product_add}
    [Timeout]
    ## Get info ton cuoi, cong no khach hang
    Toggle status of promotion    ${input_khuyemmai}    1
    ${order_code}    Add new order with promotion buy product and get other product discount    ${input_ma_kh}    ${dict_product_num}    ${input_khuyemmai}    ${dict_promo_product}    ${input_khtt_create_order}
    ${num_sale_product}    ${num_promo_product}    ${product_price}    ${discount}    ${discount_ratio}    ${name}    Get Number of sale product - promo product - promo value and name
    ...    ${input_khuyemmai}
    ${list_promo_product_add}    Get Dictionary Keys    ${dict_promo_product_add}
    ${list_promo_num_add}    Get Dictionary Values    ${dict_promo_product_add}
    ${list_product}    Get Dictionary Keys    ${dict_product_num}
    ${list_nums}    Get Dictionary Values    ${dict_product_num}
    ${list_promo_product}    Get Dictionary Keys    ${dict_promo_product}
    ${list_promo_num}    Get Dictionary Values    ${dict_promo_product}
    ${list_product_add}    Get Dictionary Keys    ${dict_product_add}
    ${list_nums_add}    Get Dictionary Values    ${dict_product_add}
    ${get_no_bf_execute}    ${get_tongban_bf_execute}    ${get_tongban_tru_trahang_bf_execute}    ${get_customer_name}    Get Customer Info from API    ${input_ma_kh}
    ${get_khachdatra_in_dh_bf_execute}    ${get_tongtienhang_in_dh_bf_execute}    Get paid value frm API    ${order_code}
    ${get_list_ordersummary_bf_execute}    Get list order summary frm product API    ${list_product}
    Reload Page
    ##get thanh tien promo
    ${get_list_baseprice}    Get list of Baseprice by Product Code    ${list_promo_product_add}
    ${list_order_summary}    Get list order summary frm product API    ${list_promo_product_add}
    ${list_result_order_summary_promo}    Create List
    ${list_result_thanhtien_promo}    Create List
    : FOR    ${order_summary_add}    ${promo_num}    ${promo_num_add}   ${item_giaban}    IN ZIP    ${list_order_summary}    ${list_promo_num}    ${list_promo_num_add}    ${get_list_baseprice}
    \     ${result_newprice}    Minus and round   ${item_giaban}    ${discount}
    \    ${result_thanhtien}    Multiplication and round    ${result_newprice}    ${promo_num_add}
    \    ${result_promo_num}    Run Keyword If    0 < ${promo_num_add} < ${promo_num}     Minus and replace floating point    ${promo_num}    ${promo_num_add}
    \    ...    ELSE IF    ${promo_num_add} > ${promo_num}    Minus and replace floating point    ${promo_num_add}    ${promo_num}    ELSE    Set Variable     ${promo_num_add}
    \    ${result_order_summary_promo}    Run Keyword If    0 < ${promo_num_add} < ${promo_num}     Minus and replace floating point    ${order_summary_add}    ${result_promo_num}
    \    ...    ELSE IF    ${promo_num_add} > ${promo_num}    Sum and replace floating point    ${order_summary_add}    ${result_promo_num}   ELSE    Set Variable     ${order_summary_add}
    \    Append to list    ${list_result_order_summary_promo}    ${result_order_summary_promo}
    \    Append to list    ${list_result_thanhtien_promo}    ${result_thanhtien}
    #Input data into BH form
    Go to xu ly dat hang    ${order_code}
    ${laster_nums}    Set Variable    2
    ${list_result_thanhtien_add}    ${list_result_order_summary_add}    ${list_result_giamoi_add}    Get list total sale and order summary incase discount    ${list_product_add}    ${list_nums_add}    ${list_ggsp}
    ${list_result_thanhtien}    ${list_result_order_summary}    ${list_result_giamoi}    Get list total sale and order summary incase discount    ${list_product}    ${list_nums}    ${list_ggsp}
    : FOR    ${item_product}    ${item_num}    IN ZIP    ${list_product_add}    ${list_nums_add}
    \    ${lastest_num}    Input product-num in sale form    ${item_product}    ${item_num}    ${laster_nums}    ${cell_tongsoluong_dh}
    #order summary
    ${list_ordersummary}    Create List
    : FOR    ${order_summary_promo_add}    IN    @{list_result_order_summary_promo}
    \    Append To List    ${list_result_order_summary_add}    ${order_summary_promo_add}
    : FOR    ${order_summary}    IN    @{get_list_ordersummary_bf_execute}
    \    Append To List    ${list_result_order_summary_add}    ${order_summary}
    ${list_result_order_summary_add}    Convert String to List    ${list_result_order_summary_add}
    Log    ${list_result_order_summary_add}
    #Compute
    ${result_tongtienhang}    Sum values in list    ${list_result_thanhtien}
    ${result_thanhtien_promo_add}     Sum values in list    ${list_result_thanhtien_promo}
    ${result_tongtienhang_add}    Sum values in list    ${list_result_thanhtien_add}
    ${result_tongtienhang}    Sum x 3     ${result_tongtienhang}    ${result_tongtienhang_add}    ${result_thanhtien_promo_add}
    ${result_khachcantra}    Minus    ${result_tongtienhang}    ${input_discount_order}
    ${result_khachcantra}    Replace floating point    ${result_khachcantra}
    ${actual_khachtt}    Set Variable If    '${input_bh_khachtt}' == 'all'    ${result_khachcantra}    ${input_bh_khachtt}
    ${result_nohientai}    Minus    ${get_no_bf_execute}    ${actual_khachtt}
    #create invoice
    Select promotion and giveaway product on the first row product    ${name}    ${list_promo_product_add}    ${list_promo_num_add}
    Wait Until Keyword Succeeds    3 times    8 s    Input VND discount order    ${input_discount_order}
    Run Keyword If    ${input_bh_khachtt}>0    Input order payment into BH    ${actual_khachtt}    ${result_khachcantra}
    ...    ELSE    Log    igrnore input
    Click Element JS    ${button_luu_order}
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
    Should Be Equal As Numbers    ${get_khachdatra_in_dh_af_execute}    ${actual_khachtt}
    Should Be Equal As Numbers    ${get_giamgia_in_dh_af_execute}    ${input_discount_order}
    Should Be Equal As Numbers    ${get_tongcong_in_dh_af_execute}    ${result_khachcantra}
    #assert value product
    ${list_order_summary_af_execute}    Get list order summary by order code    ${order_code}
    : FOR    ${result_tong_dh}    ${order_summary_af_execute}    IN ZIP    ${list_result_order_summary_add}    ${list_order_summary_af_execute}
    \    Should Be Equal As Numbers    ${order_summary_af_execute}    ${result_tong_dh}
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

eduhh02
    [Arguments]    ${dict_product_num}    ${input_discount_order}    ${input_ma_kh}    ${input_bh_khachtt}    ${input_khuyemmai}    ${dict_promo_product}
    ...    ${input_khtt_create_order}      ${dict_promo_product_add}
    [Timeout]
    ## Get info ton cuoi, cong no khach hang
    Toggle status of promotion    ${input_khuyemmai}    1
    ${order_code}    Add new order with promotion buy product and get other product free    ${input_ma_kh}    ${dict_product_num}    ${input_khuyemmai}    ${dict_promo_product}    ${input_khtt_create_order}
    ${num_sale_product}    ${num_promo_product}    ${product_price}    ${discount}    ${discount_ratio}    ${name}    Get Number of sale product - promo product - promo value and name
    ...    ${input_khuyemmai}
    ${list_promo_product_add}    Get Dictionary Keys    ${dict_promo_product_add}
    ${list_promo_num_add}    Get Dictionary Values    ${dict_promo_product_add}
    ${list_product}    Get Dictionary Keys    ${dict_product_num}
    ${list_nums}    Get Dictionary Values    ${dict_product_num}
    ${list_promo_product}    Get Dictionary Keys    ${dict_promo_product}
    ${list_promo_num}    Get Dictionary Values    ${dict_promo_product}
    Append To List    ${list_promo_num}     0
    ${get_khachdatra_in_dh_bf_execute}    ${get_tongtienhang_in_dh_bf_execute}    Get paid value frm API    ${order_code}
    ${get_list_ordersummary_bf_execute}    Get list order summary frm product API    ${list_product}
    ${get_list_ordersummary_bf_execute}    Convert String to List    ${get_list_ordersummary_bf_execute}
    ${get_list_ordersummary_bf_execute_promo_add}    Get list order summary frm product API    ${list_promo_product_add}
    :FOR    ${order_summary_add}    ${promo_num}    ${promo_num_add}    IN ZIP    ${get_list_ordersummary_bf_execute_promo_add}    ${list_promo_num}
    ...    ${list_promo_num_add}
    \    ${result_promo_num}    Run Keyword If    0 < ${promo_num_add} < ${promo_num}     Minus and replace floating point    ${promo_num}    ${promo_num_add}
    \    ...    ELSE IF    ${promo_num_add} > ${promo_num}    Minus and replace floating point    ${promo_num_add}    ${promo_num}    ELSE    Set Variable     ${promo_num_add}
    \    ${result_order_summary_promo}    Run Keyword If    0 < ${promo_num_add} < ${promo_num}     Minus and replace floating point    ${order_summary_add}    ${result_promo_num}
    \    ...    ELSE IF    ${promo_num_add} > ${promo_num}    Sum and replace floating point    ${order_summary_add}    ${result_promo_num}   ELSE    Set Variable     ${order_summary_add}
    \    Append to list    ${get_list_ordersummary_bf_execute}    ${result_order_summary_promo}
    Sort List    ${get_list_ordersummary_bf_execute}
    Log    ${get_list_ordersummary_bf_execute}
    #create lists
    Reload Page
    #Compute
    ${result_khachcantra}    Minusx3 and replace foating point    ${get_tongtienhang_in_dh_bf_execute}    ${input_discount_order}    ${get_khachdatra_in_dh_bf_execute}
    ${actual_khachtt}    Set Variable If    '${input_bh_khachtt}' == 'all'    ${result_khachcantra}    ${input_bh_khachtt}
    ${result_khachdatra}    Sum    ${get_khachdatra_in_dh_bf_execute}    ${actual_khachtt}
    #create invoice
    Go to xu ly dat hang    ${order_code}
    Click Element JS    ${icon_dongy_reset_promo}
    Select promotion and giveaway product on the first row product    ${name}    ${list_promo_product_add}    ${list_promo_num_add}
    Wait Until Keyword Succeeds    3 times    8 s    Input VND discount order    ${input_discount_order}
    Run Keyword If    ${input_bh_khachtt}!=0    Input order payment into BH    ${actual_khachtt}    ${result_khachcantra}
    ...    ELSE    Log    igrnore input
    Click Element JS    ${button_luu_order}
    Order message success validation
    ${order_code}    Get saved code after execute
    #get values
    Sleep    20 s    wait for response to API
    #assert values in order
    ${get_ma_kh_in_dh_af_execute}    ${get_TTDH_in_dh_af_execute}    ${get_tongtienhang_in_dh_af_exxecute}    ${get_khachdatra_in_dh_af_execute}    ${get_giamgia_in_dh_af_execute}    ${get_tongcong_in_dh_af_execute}    ${get_ghichu_in_dh_af_execute}
    ...    Get order info incase discount by order code    ${order_code}
    Should Be Equal As Strings    ${get_ma_kh_in_dh_af_execute}    ${get_ma_kh_in_dh_af_execute}
    Should Be Equal As Numbers    ${get_TTDH_in_dh_af_execute}    1    #1 : phiếu tạm
    Should Be Equal As Numbers    ${get_tongtienhang_in_dh_af_exxecute}    ${get_tongtienhang_in_dh_bf_execute}
    Should Be Equal As Numbers    ${get_khachdatra_in_dh_af_execute}    ${result_khachdatra}
    Should Be Equal As Numbers    ${get_giamgia_in_dh_af_execute}    ${input_discount_order}
    Should Be Equal As Numbers    ${get_tongcong_in_dh_af_execute}    ${result_khachdatra}
    #assert value product
    ${list_order_summary_af_execute}    Get list order summary by order code    ${order_code}
    ${list_order_summary_af_execute}    Convert String to List    ${list_order_summary_af_execute}
    Sort List    ${list_order_summary_af_execute}
    Log    ${list_order_summary_af_execute}
    : FOR    ${result_tong_dh}    ${order_summary_af_execute}    IN ZIP    ${get_list_ordersummary_bf_execute}    ${list_order_summary_af_execute}
    \    Should Be Equal As Numbers    ${order_summary_af_execute}    ${result_tong_dh}
    Delete order frm Order code    ${order_code}
    Toggle status of promotion    ${input_khuyemmai}    0

eduhh03
    [Arguments]    ${dict_product_num}    ${input_discount_order}    ${input_ma_kh}    ${input_bh_khachtt}    ${input_khuyemmai}    ${input_khtt_create_order}
    ...    ${list_soluong_new}    ${list_ggsp}
    ## Get info ton cuoi, cong no khach hang
    Toggle status of promotion    ${input_khuyemmai}    1
    ${order_code}    Add new order with promotion buy every items at a fixed reduced price    ${input_ma_kh}    ${dict_product_num}    ${input_khuyemmai}    ${input_khtt_create_order}
    ${num_sale_product}    ${num_promo_product}    ${product_price}    ${discount}    ${discount_ratio}    ${name}    Get Number of sale product - promo product - promo value and name
    ...    ${input_khuyemmai}
    ${list_product}    Get Dictionary Keys    ${dict_product_num}
    ${list_nums}    Get Dictionary Values    ${dict_product_num}
    ${get_khachdatra_in_dh_bf_execute}    ${get_tongtienhang_in_dh_bf_execute}    Get paid value frm API    ${order_code}
    ${get_list_ordersummary_bf_execute}    Get list order summary frm product API    ${list_product}
    ${total_sale_number}    Sum values in list    ${list_soluong_new}
    ${list_result_totalsale}    ${list_result_onhand_af_ex}    Run Keyword If    ${discount} != 0 and ${discount_ratio} ==0    Get list of total sale - result onhand in case discount product    ${list_product}    ${list_soluong_new}
    ...    ${discount}
    ...    ELSE IF    ${discount} == 0 and ${discount_ratio} != 0    Get list of total sale - result onhand in case discount product    ${list_product}    ${list_soluong_new}    ${discount_ratio}
    ...    ELSE IF    ${total_sale_number} < ${num_sale_product}    Get list of total sale - result onhand with one discount    ${list_product}    ${list_soluong_new}
    ...    ELSE    Get list of total sale - result onhand in case promotion    ${list_product}    ${list_soluong_new}    ${product_price}    ${num_sale_product}
    ${list_result_order_summary}      Create List
    : FOR    ${order_summary}    ${quantity}    ${quantity_add}    IN ZIP    ${get_list_ordersummary_bf_execute}    ${list_nums}
    ...    ${list_soluong_new}
    \    ${result_quantity}    Run Keyword If    0 < ${quantity_add} < ${quantity}    Minus and replace floating point    ${quantity}    ${quantity_add}
    \    ...    ELSE    Minus and replace floating point    ${quantity_add}    ${quantity}
    \    ${result_ordersummary}    Run Keyword If    0 < ${quantity_add} < ${quantity}    Minus and replace floating point    ${order_summary}    ${result_quantity}
    \    ...    ELSE    Sum and replace floating point    ${order_summary}    ${result_quantity}
    \    Append To List    ${list_result_order_summary}    ${result_ordersummary}
    Log    ${list_result_order_summary}
    #create lists
    Reload Page
    #Compute
    ${result_tongtienhang}    Sum values in list    ${list_result_totalsale}
    ${result_ggdh}    Convert % discount to VND and round    ${result_tongtienhang}    ${input_discount_order}
    ${result_khachcantra}    Minusx3 and replace foating point    ${result_tongtienhang}    ${result_ggdh}    ${get_khachdatra_in_dh_bf_execute}
    ${actual_khachtt}    Set Variable If    '${input_bh_khachtt}' == 'all'    ${result_khachcantra}    ${input_bh_khachtt}
    ${result_khachdatra}    Sum    ${get_khachdatra_in_dh_bf_execute}    ${actual_khachtt}
    ${result_tongcong}     Sum    ${result_khachcantra}    ${result_khachdatra}
    #create invoice
    Go to xu ly dat hang    ${order_code}
    ${lastest_nums}    Set Variable    0
    : FOR    ${input_product}    ${input_nums}    IN ZIP    ${list_product}    ${list_soluong_new}
    \    Update quantity into DH form    ${input_product}    ${input_nums}    ${lastest_nums}
    Select promotion on each product line    ${name}
    Wait Until Keyword Succeeds    3 times    8 s    Input % discount order    ${input_discount_order}    ${result_ggdh}
    Run Keyword If    ${input_bh_khachtt}>0    Input order payment into BH    ${actual_khachtt}    ${result_khachcantra}
    ...    ELSE    Log    igrnore input
    Click Element JS    ${button_luu_order}
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
    Should Be Equal As Numbers    ${get_giamgia_in_dh_af_execute}    ${result_ggdh}
    Should Be Equal As Numbers    ${get_tongcong_in_dh_af_execute}    ${result_tongcong}
    #assert value product
    ${list_order_summary_af_execute}    Get list order summary by order code    ${order_code}
    : FOR    ${result_tong_dh}    ${order_summary_af_execute}    IN ZIP    ${list_result_order_summary}    ${list_order_summary_af_execute}
    \    Should Be Equal As Numbers    ${order_summary_af_execute}    ${result_tong_dh}
    Delete order frm Order code    ${order_code}
    Toggle status of promotion    ${input_khuyemmai}    0
