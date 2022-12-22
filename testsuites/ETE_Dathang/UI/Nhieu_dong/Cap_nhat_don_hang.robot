*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    ${headless_browser}
Test Setup
Test Teardown     After Test
Library           SeleniumLibrary
Resource          ../../../../core/API/api_danhmuc_hanghoa.robot
Resource          ../../../../core/API/api_dathang.robot
Resource          ../../../../core/API/api_khachhang.robot
Resource          ../../../../core/API/api_mhbh.robot
Resource          ../../../../core/Dat_Hang/dat_hang_action.robot
Resource          ../../../../core/Dat_Hang/dat_hang_navigation.robot
Resource          ../../../../core/Dat_Hang/dat_hang_page.robot
Resource          ../../../../core/Ban_Hang/banhang_action.robot
Resource          ../../../../core/Ban_Hang/banhang_navigation.robot
Resource          ../../../../core/share/toast_message.robot
Resource          ../../../../core/API/api_soquy.robot
Resource          ../../../../core/share/javascript.robot
Resource          ../../../../core/share/discount.robot
Resource          ../../../../core/API/api_mhbh_dathang.robot
Resource          ../../../../core/share/list_dictionary.robot

*** Variables ***
#them 1 dong
&{list_product1}    HH0004=3    SI004=1    DVT04=2.1    DV004=2    Combo04=4
&{list_product2}    HH0006=3    SI005=1    QDKL008=1    DV005=1.3    Combo05=3
&{list_product3}    HH0007=2    SI006=1    DVT06=2    DV006=4.5    Combo06=3
&{list_product4}    DV007=5
&{list_product5}    Combo07=5.5
&{list_product_delete01}    HH0004=3    SI004=1
&{list_product_delete02}    QDKL008=1    DV005=1.3
&{list_product_delete03}    SI006=4.5    Combo06=3
&{list_productadd}    HH0008=3.8    SI007=2   QD025=2
@{list_soluong_update}    1     3.75      4.2
@{discount}     25000     0     2500
@{discount_type}   disvnd    none    changedown
@{list_soluong_addrow}   5,3.4     3.5,1,4.2     2
@{discount_addrow}     10,30000    380000.55,20000,none     0
@{discount_type_addrow}   dis,disvnd     changeup,changedown,none    none

*** Test Cases ***    Mã KH         List product&nums       GGSP        List quantity udpate       List type discount        List nums add row      GGSP add row       List type discount add row          List product delete       List product add    GGDH       Khách TT     Ghi chú                 Khách thanh toán to create
Cap_nhat_dh_golive              [Tags]     UEDUM
                      [Template]    etedh_inv_multirow13
                      CTKH015       ${list_product1}     ${discount}    ${list_soluong_update}    ${discount_type}   ${list_soluong_addrow}    ${discount_addrow}     ${discount_type_addrow}         ${list_product_delete01}    ${list_productadd}    0          all                 Thanh toán hết                500000
                      CTKH016       ${list_product2}     ${discount}    ${list_soluong_update}    ${discount_type}   ${list_soluong_addrow}    ${discount_addrow}     ${discount_type_addrow}          ${list_product_delete02}    ${list_productadd}   200000      500000            Đã đặt cọc                     0
                      CTKH017       ${list_product3}     ${discount}    ${list_soluong_update}    ${discount_type}   ${list_soluong_addrow}    ${discount_addrow}     ${discount_type_addrow}          ${list_product_delete03}    ${list_productadd}   15          0                 Thanh toán khi nhận hàng       all

Them_2_dong              [Tags]    UEDUM
                      [Template]    etedh_inv_multirow14
                      CTKH018       ${list_product4}     Bảng giá đặt hàng        150000          500000                 Đã đặt cọc

Them_50_dong              [Tags]
                      [Template]    etedh_inv_multirow15
                      CTKH019       CTKH011     25          0         Thanh toán khi nhận hàng      Combo07    5.5    ${list_product5}

*** Keywords ***
etedh_inv_multirow13
    [Arguments]    ${input_ma_kh}    ${dict_product_nums}   ${list_ggsp}    ${list_quantity_update}    ${list_discount_type}   ${list_nums_addrow}   ${list_discount_addrow}
    ...   ${list_type_discount_addrow}     ${list_product_delete}   ${list_product_addnew}      ${input_ggdh}    ${input_khtt}    ${input_ghichu}    ${input_khtt_create_order}
    #get info product, customer
    ${list_nums_addrow}   ${list_discount_addrow}    ${list_type_discount_addrow}   Convert three string list to composite list    ${list_nums_addrow}    ${list_discount_addrow}
    ...    ${list_type_discount_addrow}
    ${list_product_del}    Get Dictionary Keys    ${list_product_delete}
    ${list_nums_del}    Get Dictionary Values    ${list_product_delete}
    ${list_product_add}    Get Dictionary Keys    ${list_product_addnew}
    ${list_nums_add}    Get Dictionary Values    ${list_product_addnew}
    Set Selenium Speed    0.5s
    ${order_code}    Add new order with multi products    ${input_ma_kh}    ${dict_product_nums}    ${input_khtt_create_order}
    ${get_khachdatra_in_dh_bf_execute}    ${get_tongtienhang_in_dh_bf_execute}    Get paid value frm API    ${order_code}
    ${get_list_hh_in_dh_bf_execute}   ${get_list_sl_in_dh_bf_execute}    Get list product and quantity frm API    ${order_code}
    ${list_result_tongdh_delete}    Get list order summary incase delete product    ${order_code}    ${list_product_del}
    #get order summary and sub total of products
    : FOR    ${ma_hh}   ${number}    IN ZIP     ${list_product_delete}    ${list_nums_del}
    \    Remove Values From List    ${get_list_hh_in_dh_bf_execute}    ${ma_hh}
    \    Remove Values From List    ${get_list_sl_in_dh_bf_execute}    ${number}
    Log    ${get_list_hh_in_dh_bf_execute}
    Log    ${get_list_sl_in_dh_bf_execute}
    ${get_list_id_product}    Get list product id thr API    ${get_list_hh_in_dh_bf_execute}
    ${get_list_id_product_add}    Get list product id thr API    ${list_product_add}
    ${list_result_thanhtien}    ${list_result_tongdh}    ${list_result_tongdh_add}    ${list_result_giamoi}    ${list_result_giamoi_add}    Get list total sale - order summary incase update quantity and add product    ${order_code}    ${get_list_hh_in_dh_bf_execute}
    ...   ${list_quantity_update}   ${list_ggsp}    ${list_discount_type}    ${list_product_add}    ${list_nums_add}
    ${list_result_thanhtien_addrow}    ${list_result_giamoi_addrow}    ${list_result_order_summary}    Get list total sale - order summary - newprice incase add row product    ${get_list_hh_in_dh_bf_execute}    ${list_nums_addrow}
    ...    ${list_discount_addrow}    ${list_type_discount_addrow}    ${list_result_tongdh}
    ${list_result_thanhtien_addrow_add}    ${list_result_giamoi_addrow_add}    ${list_result_order_summary_add}    Get list total sale - order summary - newprice incase add row product    ${list_product_add}    ${list_nums_addrow}
    ...    ${list_discount_addrow}    ${list_type_discount_addrow}    ${list_result_tongdh_add}
    #compute
    ${result_tongsoluong}    Sum values in list and round    ${get_list_sl_in_dh_bf_execute}
    ${result_tongtienhang_update}    Sum values in list and round    ${list_result_thanhtien}
    ${result_tongtienhang_addrow}    Sum values in list and round    ${list_result_thanhtien_addrow}
    ${result_tongtienhang_addrow_add}    Sum values in list and round    ${list_result_thanhtien_addrow_add}
    ${result_tongtienhang}   Sum x 3    ${result_tongtienhang_update}     ${result_tongtienhang_addrow}    ${result_tongtienhang_addrow_add}
    ${result_ggdh}    Run Keyword If    0 < ${input_ggdh} < 100    Convert % discount to VND and round    ${result_tongtienhang}    ${input_ggdh}
    ...    ELSE    Set Variable    ${input_ggdh}
    ${result_tongcong_in_dh}    Run Keyword If    0 < ${input_ggdh} < 100    Price after % discount invoice    ${result_tongtienhang}    ${input_ggdh}
    ...    ELSE    Minus and replace floating point    ${result_tongtienhang}    ${input_ggdh}
    ${result_khachcantra}    Minus and replace floating point    ${result_tongcong_in_dh}    ${get_khachdatra_in_dh_bf_execute}
    ${actual_khtt_all}    Set Variable If    '${input_khtt}' == 'all'    ${result_khachcantra}    ${input_khtt}
    ${actual_khtt}    Set Variable If    '${input_khtt}' == '0'    0    ${actual_khtt_all}
    ${actual_khtt_paymented}    Sum and replace floating point    ${actual_khtt}    ${get_khachdatra_in_dh_bf_execute}
    #delete product into BH form
    Before Test turning on display mode      ${toggle_item_themdong}
    Go to xu ly dat hang    ${order_code}
    Delete list product into BH form    ${list_product_del}
    ${laster_nums}    Set Variable    ${result_tongsoluong}
    : FOR    ${item_ma_hh}    ${item_soluong}    ${input_ggsp}   ${discount_type}    ${result_giamoi}    ${item_nums_addrow}    ${discount_type_addrow}   ${item_ggsp_addrow}    ${result_giamoi_addrow}   ${product_id}    IN ZIP    ${get_list_hh_in_dh_bf_execute}
    ...    ${list_quantity_update}    ${list_ggsp}    ${list_discount_type}    ${list_result_giamoi}   ${list_nums_addrow}   ${list_type_discount_addrow}   ${list_discount_addrow}    ${list_result_giamoi_addrow}   ${get_list_id_product}
    \    ${laster_nums}    Update quantity into DH form    ${item_ma_hh}    ${item_soluong}    ${laster_nums}
    \    Run Keyword If    '${discount_type}' == 'dis'   Wait Until Keyword Succeeds    3 times    5 s   Input % discount for multi product    ${item_ma_hh}    ${input_ggsp}    ${result_giamoi}
    \    ...    ELSE IF    '${discount_type}' == 'disvnd'  Wait Until Keyword Succeeds    3 times    5 s    Input VND discount for multi product    ${item_ma_hh}    ${input_ggsp}    ${result_giamoi}
    \    ...    ELSE IF    '${discount_type}' == 'changeup' or '${discount_type}' == 'changedown'  Wait Until Keyword Succeeds    3 times    5 s    Input newprice for multi product    ${item_ma_hh}   ${input_ggsp}
    \    ...    ELSE    Log    Ignore input
    \    ${laster_nums}    Add row product incase multi product in MHBH    ${item_ma_hh}    ${item_nums_addrow}    ${item_ggsp_addrow}    ${result_giamoi_addrow}    ${discount_type_addrow}    ${product_id}   ${laster_nums}    ${cell_tongsoluong_dh}
    : FOR    ${item_product}    ${item_nums}    ${item_nums_addrow1}    ${item_ggsp}    ${item_ggsp_addrow1}    ${result_giamoi1}    ${result_giamoi_addrow1}
    ...   ${discount_type1}   ${discount_type_addrow1}    ${product_id_add}    IN ZIP    ${list_product_add}    ${list_nums_add}   ${list_nums_addrow}    ${list_ggsp}
    ...   ${list_discount_addrow}   ${list_result_giamoi_add}    ${list_result_giamoi_addrow_add}    ${list_discount_type}    ${list_type_discount_addrow}   ${get_list_id_product_add}
    \    ${laster_nums}    Wait Until Keyword Succeeds    3 times    5 s    Input product-num in sale form    ${item_product}    ${item_nums}    ${laster_nums}    ${cell_tongsoluong_dh}
    \    Run Keyword If    '${discount_type1}' == 'dis'   Wait Until Keyword Succeeds    3 times    5 s   Input % discount for multi product    ${item_product}    ${item_ggsp}    ${result_giamoi1}
    \    ...    ELSE IF    '${discount_type1}' == 'disvnd'  Wait Until Keyword Succeeds    3 times    5 s    Input VND discount for multi product    ${item_product}    ${item_ggsp}    ${result_giamoi1}
    \    ...    ELSE IF    '${discount_type1}' == 'changeup' or '${discount_type1}' == 'changedown'  Wait Until Keyword Succeeds    3 times    5 s    Input newprice for multi product    ${item_product}   ${item_ggsp}
    \    ...    ELSE    Log    Ignore input
    \    ${laster_nums}    Add row product incase multi product in MHBH    ${item_product}    ${item_nums_addrow1}    ${item_ggsp_addrow1}    ${result_giamoi_addrow1}     ${discount_type_addrow1}   ${product_id_add}    ${laster_nums}    ${cell_tongsoluong_dh}
    Run Keyword If    0 < ${input_ggdh} < 100    Wait Until Keyword Succeeds    3 times    5 s    Input % discount order    ${input_ggdh}    ${result_ggdh}
    ...    ELSE    Wait Until Keyword Succeeds    3 times    5 s    Input VND discount order    ${input_ggdh}
    Run Keyword If    ${input_khtt}!=0    Input order payment into BH    ${actual_khtt}    ${result_khachcantra}
    Input text to Ghi chu field    ${input_ghichu}
    Click Element JS    ${button_luu_order}
    Order message success validation
    ${get_ma_dh}    Get saved code after execute
    #get values
    Sleep    20 s    wait for response to API
    #validate deleted product
    ${list_order_summary_delete_af_execute}    Get list order summary frm product API    ${list_product_del}
    : FOR    ${result_tong_dh_delete}    ${order_summary_delete_af_execute}    IN ZIP    ${list_result_tongdh_delete}    ${list_order_summary_delete_af_execute}
    \    Should Be Equal As Numbers    ${result_tong_dh_delete}    ${order_summary_delete_af_execute}
    #validate product
    ${list_order_summary_af_execute}    Get list order summary frm product API    ${get_list_hh_in_dh_bf_execute}
    : FOR    ${result_tong_dh}    ${order_summary_af_execute}    IN ZIP    ${list_result_order_summary}    ${list_order_summary_af_execute}
    \    Should Be Equal As Numbers    ${order_summary_af_execute}    ${result_tong_dh}
    #validate product add
    ${list_order_summary_add_af_execute}    Get list order summary frm product API    ${list_product_add}
    : FOR    ${result_tong_dh}    ${order_summary_af_execute}    IN ZIP    ${list_result_order_summary_add}    ${list_order_summary_add_af_execute}
    \    Should Be Equal As Numbers    ${order_summary_af_execute}    ${result_tong_dh}
    ${get_ma_kh_in_dh_af_execute}    ${get_TTDH_in_dh_af_execute}    ${get_tongtienhang_in_dh_af_exxecute}    ${get_khachdatra_in_dh_af_execute}    ${get_giamgia_in_dh_af_execute}    ${get_tongcong_in_dh_af_execute}    ${get_ghichu_af_execute}    Get order info have note incase discount by order code    ${get_ma_dh}
    Should Be Equal As Strings    ${get_ma_kh_in_dh_af_execute}    ${input_ma_kh}
    Should Be Equal As Numbers    ${get_TTDH_in_dh_af_execute}    1    #1 : phiếu tạm
    Should Be Equal As Numbers    ${get_tongtienhang_in_dh_af_exxecute}    ${result_tongtienhang}
    Should Be Equal As Numbers    ${get_giamgia_in_dh_af_execute}    ${input_ggdh}
    Should Be Equal As Numbers    ${get_tongcong_in_dh_af_execute}    ${result_tongcong_in_dh}
    Should Be Equal As Numbers    ${get_khachdatra_in_dh_af_execute}    ${actual_khtt_paymented}
    Should Be Equal As Strings    ${get_ghichu_af_execute}    ${input_ghichu}
    Delete order frm Order code    ${get_ma_dh}
    After Test

etedh_inv_multirow14
    [Arguments]    ${input_ma_kh}     ${dict_product_nums}    ${input_ten_bangia}   ${input_ggdh}    ${input_khtt}    ${input_ghichu}
    #get info product, customer
    ${order_code}    Add new order with multi product and no payment - get order code    ${input_ma_kh}    ${dict_product_nums}
    ${get_khachdatra_in_dh_bf_execute}    ${get_tongtienhang_in_dh_bf_execute}    Get paid value frm API    ${order_code}
    ${get_list_hh_in_dh_bf_execute}   ${get_list_sl_in_dh_bf_execute}    Get list product and quantity frm API    ${order_code}
    ${list_tongdh_bf_execute}    Get list order summary frm product API    ${get_list_hh_in_dh_bf_execute}
    #get order summary and sub total of products
    ${get_id_banggia}    ${list_giaban_new}    Get list gia ban from PriceBook api    ${input_ten_bangia}    ${get_list_hh_in_dh_bf_execute}
    #compute
    ${list_result_thanhtien}    Create List
    ${list_result_tongdh}    Create List
    : FOR    ${soluong}    ${giaban}   ${get_tongdh}   IN ZIP   ${get_list_sl_in_dh_bf_execute}    ${list_giaban_new}  ${list_tongdh_bf_execute}
    \    ${result_thanhtien_addrow}    Multiplication and round    1    ${giaban}
    \    ${reuslt_thanhtien}   Multiplication and round    ${soluong}    ${giaban}
    \    ${result_tongdh}   Sum   ${get_tongdh}   2
    \    Append To List    ${list_result_thanhtien}    ${result_thanhtien_addrow}
    \    Append To List    ${list_result_thanhtien}    ${result_thanhtien_addrow}
    \    Append To List    ${list_result_thanhtien}    ${reuslt_thanhtien}
    \    Append To List    ${list_result_tongdh}    ${result_tongdh}
    ${result_tongtienhang}    Sum values in list and round    ${list_result_thanhtien}
    ${result_tongsoluong}    Sum values in list and round    ${get_list_sl_in_dh_bf_execute}
    ${result_ggdh}    Run Keyword If    0 < ${input_ggdh} < 100    Convert % discount to VND and round    ${result_tongtienhang}    ${input_ggdh}
    ...    ELSE    Set Variable    ${input_ggdh}
    ${result_tongcong_in_dh}    Minus and replace floating point    ${result_tongtienhang}    ${result_ggdh}
    ${result_khachcantra}    Minus and replace floating point    ${result_tongcong_in_dh}    ${get_khachdatra_in_dh_bf_execute}
    ${actual_khtt_all}    Set Variable If    '${input_khtt}' == 'all'    ${result_khachcantra}    ${input_khtt}
    ${actual_khtt}    Set Variable If    '${input_khtt}' == '0'    0    ${actual_khtt_all}
    ${actual_khtt_paymented}    Sum and replace floating point    ${actual_khtt}    ${get_khachdatra_in_dh_bf_execute}
    ${result_actual_khtt}    Set Variable If    '${input_khtt}' == 'all'    ${actual_khtt}    ${actual_khtt_paymented}
    #update BG into DH form
    Before Test turning on display mode      ${toggle_item_themdong}
    Go to xu ly dat hang    ${order_code}
    Select Bang gia    ${input_ten_bangia}
    :FOR    ${product}     IN     @{get_list_hh_in_dh_bf_execute}
    \   ${button_add_row_infirstline}    Format String     ${button_add_row_infirstline}   ${product}
     : FOR    ${item}    IN RANGE    2
     \   Wait Until Element Is Visible    ${button_add_row_infirstline}
     \   Click Element JS    ${button_add_row_infirstline}
    Run Keyword If    0 < ${input_ggdh} < 100    Wait Until Keyword Succeeds    3 times    5 s   Input % discount order    ${input_ggdh}    ${result_ggdh}    ELSE    Wait Until Keyword Succeeds    3 times    5 s   Input VND discount order    ${input_ggdh}
    Run Keyword If    ${input_khtt}!=0    Wait Until Keyword Succeeds    3 times    5 s   Input order payment into BH    ${actual_khtt}    ${result_khachcantra}
    Input text to Ghi chu field    ${input_ghichu}
    Click Element JS    ${button_luu_order}
    Order message success validation
    ${get_ma_dh}    Get saved code after execute
    #get values
    Sleep    20 s    wait for response to API
    #validate product
    ${list_order_summary_af_execute}    Get list order summary frm product API    ${get_list_hh_in_dh_bf_execute}
    : FOR    ${ma_hh}    ${giaban_new}    ${result_tong_dh}    ${order_summary_af_execute}    IN ZIP    ${get_list_hh_in_dh_bf_execute}    ${list_giaban_new}    ${list_result_tongdh}    ${list_order_summary_af_execute}
    \    Should Be Equal As Numbers    ${order_summary_af_execute}    ${result_tong_dh}
    \    Validate price when change pricebook    ${ma_hh}    ${get_ma_dh}    ${giaban_new}
    #assert value order
    ${get_ma_kh_in_dh_af_execute}    ${get_TTDH_in_dh_af_execute}    ${get_tongtienhang_in_dh_af_exxecute}    ${get_khachdatra_in_dh_af_execute}    ${get_giamgia_in_dh_af_execute}    ${get_tongcong_in_dh_af_execute}    ${get_ghichu_af_execute}    Get order info have note incase discount by order code    ${get_ma_dh}
    Should Be Equal As Strings    ${get_ma_kh_in_dh_af_execute}    ${input_ma_kh}
    Should Be Equal As Numbers    ${get_TTDH_in_dh_af_execute}    1    #1 : phiếu tạm
    Should Be Equal As Numbers    ${get_tongtienhang_in_dh_af_exxecute}    ${result_tongtienhang}
    Should Be Equal As Numbers    ${get_giamgia_in_dh_af_execute}    ${result_ggdh}
    Should Be Equal As Numbers    ${get_tongcong_in_dh_af_execute}    ${result_tongcong_in_dh}
    Should Be Equal As Numbers    ${get_khachdatra_in_dh_af_execute}    ${actual_khtt_paymented}
    Should Be Equal As Strings    ${get_ghichu_af_execute}    ${input_ghichu}
    Delete order frm Order code    ${get_ma_dh}
    After Test

etedh_inv_multirow15
    [Arguments]    ${input_ma_kh}    ${input_ma_kh_update}    ${input_ggdh}    ${input_khtt}    ${input_ghichu}    ${product}    ${nums}    ${dic_product_nums}
    #get info product, customer
    ${order_code}    Add new order with multi product and no payment - get order code    ${input_ma_kh}    ${dic_product_nums}
    ${get_khachdatra_in_dh_bf_execute}    ${get_tongtienhang_in_dh_bf_execute}    Get paid value frm API    ${order_code}
    ${get_no_bf_execute}    ${get_tongban_bf_execute}    ${get_tongban_tru_trahang_bf_execute}    Get Customer Debt from API    ${input_ma_kh}
    ${get_no_kh_update_bf_execute}    ${get_tongban_kh_update_bf_execute}    ${get_tongban_tru_trahang_kh_update_bf_execute}    Get Customer Debt from API    ${input_ma_kh_update}
    ${get_tenhang_af_purchase}    ${get_giaban_bf_purchase}    Get product name and price frm API    ${product}
    #compute
    ${get_order_summary}    Get order summary frm product API    ${product}
    ${result_tongso_dh}    Sum   ${get_order_summary}    50
    ${result_thanhtien}    Multiplication and round    ${get_giaban_bf_purchase}    ${nums}
    ${result_thanhtien_addrow}    Multiplication and round    ${get_giaban_bf_purchase}    50
    ${result_tongtienhang}    Sum and round     ${result_thanhtien}    ${result_thanhtien_addrow}
    ${result_ggdh}    Run Keyword If    0 < ${input_ggdh} < 100    Convert % discount to VND and round    ${result_tongtienhang}    ${input_ggdh}    ELSE    Set Variable    ${input_ggdh}
    ${result_tongcong_in_dh}    Minus and round     ${result_tongtienhang}    ${result_ggdh}
    ${actual_khtt_all}    Set Variable If    '${input_khtt}' == 'all'    ${result_tongcong_in_dh}    ${input_khtt}
    ${actual_khtt}    Set Variable If    '${input_khtt}' == '0'    0    ${actual_khtt_all}
    ${actual_khtt_paymented}    Sum and replace floating point    ${actual_khtt}    ${get_khachdatra_in_dh_bf_execute}
    ${result_actual_khtt}    Set Variable If    ${get_khachdatra_in_dh_bf_execute} > 0 and '${input_khtt}' == 'all'    ${actual_khtt}    ${actual_khtt_paymented}    #tính lại tổng cộng với đơn hàng đã đặt cọc khi thay đổi khách hàng
    #du no khach hang
    ${result_no_hientai_kh}    Minus and replace floating point    ${get_no_bf_execute}    ${get_khachdatra_in_dh_bf_execute}
    ${result_tongban_kh}    Minus and replace floating point    ${get_tongban_bf_execute}    ${get_khachdatra_in_dh_bf_execute}
    ${result_no_hientai_kh_update}    Minus and replace floating point    ${get_no_kh_update_bf_execute}    ${actual_khtt}
    #update data into order form
    Before Test turning on display mode      ${toggle_item_themdong}
    Go to xu ly dat hang    ${order_code}
    Update customer into BH form    ${input_ma_kh_update}
    ${button_add_row_infirstline}    Format String     ${button_add_row_infirstline}   ${product}
    Wait Until Element Is Visible    ${button_add_row_infirstline}
   : FOR    ${item}    IN RANGE    50
   \   Click Element JS    ${button_add_row_infirstline}
    Run Keyword If    0 < ${input_ggdh} < 100    Wait Until Keyword Succeeds    3 times    5 s   Input % discount order    ${input_ggdh}    ${result_ggdh}    ELSE    Wait Until Keyword Succeeds    3 times    5 s   Input VND discount order    ${input_ggdh}
    Run Keyword If    ${input_khtt}!=0    Input order payment into BH    ${actual_khtt}    ${result_tongcong_in_dh}
    Input text to Ghi chu field    ${input_ghichu}
    Click Element JS    ${button_luu_order}
    Sleep    0.5s
    Order message success validation
    ${get_ma_dh}    Get saved code after execute
    #get values
    Sleep    20 s    wait for response to API
    #assert value product
    ${order_summary_af_execute}    Get order summary by order code    ${get_ma_dh}
    Should Be Equal As Numbers    ${order_summary_af_execute}    ${result_tongso_dh}
    #assert value order
    ${get_ma_kh_in_dh_af_execute}    ${get_TTDH_in_dh_af_execute}    ${get_tongtienhang_in_dh_af_exxecute}    ${get_khachdatra_in_dh_af_execute}    ${get_giamgia_in_dh_af_execute}    ${get_tongcong_in_dh_af_execute}    ${get_ghichu_af_execute}    Get order info have note incase discount by order code    ${get_ma_dh}
    Should Be Equal As Strings    ${get_ma_kh_in_dh_af_execute}    ${input_ma_kh_update}
    Should Be Equal As Numbers    ${get_TTDH_in_dh_af_execute}    1    #1 : phiếu tạm
    Should Be Equal As Numbers    ${get_tongtienhang_in_dh_af_exxecute}    ${result_tongtienhang}
    Should Be Equal As Numbers    ${get_giamgia_in_dh_af_execute}    ${input_ggdh}
    Should Be Equal As Numbers    ${get_tongcong_in_dh_af_execute}    ${result_tongcong_in_dh}
    Should Be Equal As Numbers    ${get_khachdatra_in_dh_af_execute}    ${actual_khtt_paymented}
    Should Be Equal As Strings    ${get_ghichu_af_execute}    ${input_ghichu}
    #assert value khach hang after delete
    ${get_no_af_execute}    ${get_tongban_af_execute}    ${get_tongban_tru_trahang_af_execute}    Get Customer Debt from API    ${input_ma_kh}
    Should Be Equal As Numbers    ${get_no_af_execute}    ${result_no_hientai_kh}
    Should Be Equal As Numbers    ${get_tongban_af_execute}    ${result_tongban_kh}
    Delete order frm Order code    ${get_ma_dh}
    After Test
