*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    ${headless_browser}
Test Setup
Test Teardown     After Test
Resource          ../../../../../config/env_product/envi.robot
Resource          ../../../../../core/API/api_danhmuc_hanghoa.robot
Resource          ../../../../../core/API/api_dathang.robot
Resource          ../../../../../core/API/api_khachhang.robot
Resource          ../../../../../core/API/api_mhbh.robot
Resource          ../../../../../core/Dat_Hang/dat_hang_action.robot
Resource          ../../../../../core/Dat_Hang/dat_hang_navigation.robot
Resource          ../../../../../core/Dat_Hang/dat_hang_page.robot
Resource          ../../../../../core/share/toast_message.robot
Resource          ../../../../../core/API/api_soquy.robot
Resource          ../../../../../config/env_product/envi.robot
Resource          ../../../../../core/API/api_mhbh_dathang.robot
Library           Collections
Library           BuiltIn

*** Variables ***
&{dict_product_nums1}    HH0049=3.5    SI032=1    QD113=3.24    DV056=4    Combo33=2
&{dict_product_nums2}    HH0050=4.5    SI033=2    DVT53=2.3    DV057=4    Combo34=1
&{dict_product_nums3}    HH0051=4.5    SI034=2    QD116=3.2    DV058=4    Combo35=1
&{dict_product_nums4}    HH0052=4.5    SI035=2    QD119=1.5    DV059=4    Combo36=1
@{discount}       5    7000    190000    0    200000
@{discount_type}    dis    disvnd    changeup    none    changedown
@{list_product_delete1}    SI032    QD113
@{list_product_delete2}    HH0050    SI033
@{list_product_delete3}    SI034    DV058
@{list_product_delete4}    HH0052

*** Test Cases ***    Mã KH         Payment       List product delete        GGDH     List product             List GGSP      List discount type    Payment to order
Giam_gia            [Tags]        EDX1                     ED
                      [Template]    uetedh_create_inv1
                      CTKH093       100000       ${list_product_delete1}    0        ${dict_product_nums1}    ${discount}    ${discount_type}      6000000
                      CTKH094       all           ${list_product_delete2}    15000    ${dict_product_nums2}    ${discount}    ${discount_type}      0

Khong_Giam_gia              [Tags]        EDX1
                      [Template]    uetedh_create_inv2
                      CTKH095      0             ${list_product_delete3}   ${dict_product_nums3}    ${discount}    ${discount_type}   10          all
                      CTKH096      all           ${list_product_delete4}   ${dict_product_nums4}    ${discount}    ${discount_type}   25000       0

Phan_con_lai          [Tags]        EDX1         ED
                      [Setup]
                      [Template]    uetedh_create_inv3
                      CTKH094       50000

*** Keywords ***
uetedh_create_inv1
    [Arguments]    ${input_ma_kh}    ${input_khtt}    ${list_product_del}    ${input_ggdh}    ${dict_product_nums}    ${list_ggsp}
    ...    ${list_discount_type}    ${input_khtt_tocreate}
    Set Selenium Speed    0.5s
    #get info product, customer
    ${order_code}    Run Keyword If    '${input_khtt_tocreate}' == '0'    Add new order incase discount - no payment    ${input_ma_kh}    ${input_ggdh}    ${dict_product_nums}
    ...    ${list_ggsp}    ${list_discount_type}    ELSE    Add new order incase discount - payment    ${input_ma_kh}    ${input_ggdh}    ${dict_product_nums}
    ...    ${list_ggsp}    ${list_discount_type}    ${input_khtt_tocreate}
    ${order_code}    ${get_khachdatra_in_dh_bf_execute}    ${get_ggdh_in_dh_bf_execute}    ${get_tongtienhang_in_dh_bf_execute}    ${get_tongcong_in_dh_bf_execute}    Get order code - paid - discount value frm API    ${input_ma_kh}
    ${get_no_bf_execute}    ${get_tongban_bf_execute}    ${get_tongban_tru_trahang_bf_execute}    Get Customer Debt from API    ${input_ma_kh}
    ${get_list_hh_in_dh_bf_execute}    ${get_ghichu_bf_execute}    Get ghi chu and list product frm API    ${order_code}
    ${list_result_tongdh_delete}    Get list order summary frm product API    ${list_product_del}
    #get order summary and sub total of products
    : FOR    ${ma_hh}    IN    @{list_product_del}
    \    Remove Values From List    ${get_list_hh_in_dh_bf_execute}    ${ma_hh}
    Log    ${get_list_hh_in_dh_bf_execute}
    ${get_list_nums_in_dh}    Get list quantity by order code    ${order_code}    ${get_list_hh_in_dh_bf_execute}
    ${get_list_status_imei}    Get list imei status thr API    ${get_list_hh_in_dh_bf_execute}
    Create list imei and other product    ${get_list_hh_in_dh_bf_execute}    ${get_list_nums_in_dh}
    ${list_result_tongdh}    ${result_list_toncuoi}    ${result_list_thanhtien}    Get list order summary - total sale - ending stocks frm API    ${order_code}    ${get_list_hh_in_dh_bf_execute}
    #compute invoice info
    ${result_tongtienhang}    Sum values in list    ${result_list_thanhtien}
    ${result_khachcantra}    Run Keyword If    0 < ${get_ggdh_in_dh_bf_execute} < 100    Price after % discount invoice    ${result_tongtienhang}    ${get_ggdh_in_dh_bf_execute}
    ...    ELSE IF    ${get_ggdh_in_dh_bf_execute} > 100    Minus and replace floating point    ${result_tongtienhang}    ${get_ggdh_in_dh_bf_execute}
    ...    ELSE    Set Variable    ${result_tongtienhang}
    ${result_khachcantra_tru_ktt}    Minus and replace floating point    ${result_khachcantra}    ${get_khachdatra_in_dh_bf_execute}
    ${result_gghd}    Run Keyword If    0 < ${get_ggdh_in_dh_bf_execute} < 100    Convert % discount to VND and round    ${result_tongtienhang}    ${get_ggdh_in_dh_bf_execute}
    ...    ELSE    Set Variable    ${get_ggdh_in_dh_bf_execute}
    ${tamung}    Minus and replace floating point    ${get_khachdatra_in_dh_bf_execute}    ${result_khachcantra}
    ${khtt_all}    Set Variable If    ${get_khachdatra_in_dh_bf_execute} > ${result_khachcantra_tru_ktt}    ${tamung}    ${result_khachcantra_tru_ktt}
    ${result_khtt}    Set Variable If    '${input_khtt}' == 'all'    ${khtt_all}    ${input_khtt}
    ${result_khachdatra_in_dh}    Minus and replace floating point    ${get_khachdatra_in_dh_bf_execute}    ${result_khtt}
    ${result_du_no_hd_KH}    Sum    ${get_no_bf_execute}    ${result_khachcantra}
    ${result_PTT_hd_KH}    Run Keyword If    '${get_khachdatra_in_dh_bf_execute}' == '0'    Minus and replace floating point    ${result_du_no_hd_KH}    ${result_khtt}
    ...     ELSE    Sum    ${result_du_no_hd_KH}    ${result_khtt}
    ${result_tongban_KH}    Sum and replace floating point    ${result_khachcantra}    ${get_tongban_bf_execute}
    ##compute validation
    ${result_khachthanhtoan_in_order}    Set Variable If    '${get_khachdatra_in_dh_bf_execute}' == '0'    ${result_khtt}    ${result_khachdatra_in_dh}
    ${result_khachthanhtoan_in_invoice}   Run Keyword If    ${get_khachdatra_in_dh_bf_execute} > ${result_khachcantra}    Set Variable    ${result_khachcantra}
    ...    ELSE IF    '${get_khachdatra_in_dh_bf_execute}' == '0'      Set Variable    ${result_khtt}    ELSE      Set Variable    ${result_khachdatra_in_dh}
    #create invoice from order
    Wait Until Keyword Succeeds    3 times    5s    Before Test Ban Hang
    Wait Until Keyword Succeeds    3 times    5s    Go to xu ly dat hang    ${order_code}
    Wait Until Keyword Succeeds    3 times    5s    Go to BH frm process order    ${order_code}
    Wait Until Keyword Succeeds    3 times    5s    Delete list product into BH form    ${list_product_del}
    : FOR    ${item_product}    ${status_imei}    ${item_imei}    IN ZIP    ${get_list_hh_in_dh_bf_execute}    ${get_list_status_imei}    ${imei_inlist}
    \    Run Keyword If    '${status_imei}' == 'True'    Wait Until Keyword Succeeds    3 times    8 s    Input imei incase multi product to any form
    \    ...    ${item_product}    ${texbox_imei_search_multi_product}    ${item_serial_in_dropdown}    ${cell_imei_multi_product}    @{item_imei}
    \    ...    ELSE    Log    Ignore input
    Run Keyword If    '${input_khtt}' == 'all'    Click Element JS    ${button_bh_thanhtoan}
    ...    ELSE IF    ${get_khachdatra_in_dh_bf_execute} > ${result_khachcantra_tru_ktt}    Wait Until Keyword Succeeds    3 times    20 s    Input customer payment and deposit refund into BH form    ${result_khtt}
    ...    ELSE    Wait Until Keyword Succeeds    3 times    5s    Input customer payment into BH form    ${input_khtt}    ${result_khachcantra_tru_ktt}
    Wait Until Page Contains Element    ${button_cancel}    2 mins
    Wait Until Keyword Succeeds    3 times    5s    Click Element JS    ${button_cancel}    #tắt popup kết thúc đơn ĐH
    ${invoice_code}     Get saved code until success
    #assert value product
    Assert list of order summarry after execute    ${get_list_hh_in_dh_bf_execute}    ${list_result_tongdh}
    #assert value product del
    Assert list of order summarry after execute    ${list_product_del}    ${list_result_tongdh_delete}
    #assert value onhand
    Assert list of onhand after order process    ${invoice_code}    ${get_list_hh_in_dh_bf_execute}    ${get_list_nums_in_dh}    ${result_list_toncuoi}
    #assert value order
    Assert order info after execute    ${input_ma_kh}    2    ${get_tongtienhang_in_dh_bf_execute}    ${result_khachthanhtoan_in_order}    ${get_ggdh_in_dh_bf_execute}
    ...    ${get_tongcong_in_dh_bf_execute}     0    ${order_code}
    Validate invoice history frm Order    ${order_code}    ${invoice_code}    ${result_khachcantra}
    #assert value invoice
    Assert invoice info after execute    ${invoice_code}    ${input_ma_kh}    ${result_tongtienhang}    ${result_khachcantra}    ${result_khachthanhtoan_in_invoice}
    ...    ${result_gghd}
    #assert customer and so quy
    Assert customer debit amount and general ledger after invoice execute    ${invoice_code}    ${input_khtt}    ${input_ma_kh}    ${result_PTT_hd_KH}    ${result_tongban_KH}
    ...    ${result_khtt}
    Run Keyword If    '${input_ma_kh}' == 'CTKH094'    Log    ignore del    ELSE    Delete invoice by invoice code    ${invoice_code}
    Run Keyword If    '${input_ma_kh}' == 'CTKH094'    Log    ignore del    ELSE    Delete order frm Order code    ${order_code}

uetedh_create_inv2
    [Arguments]    ${input_ma_kh}    ${input_khtt}    ${list_product}    ${dict_product_nums_tocreate}    ${list_ggsp}    ${list_discount_type}    ${input_gghd}
    ...    ${input_khtt_tocreate}
    Set Selenium Speed    0.5s
    #get info product, customer
    ${order_code}   Run Keyword If    '${input_khtt_tocreate}' == '0'    Add new order with multi product and no payment - get order code    ${input_ma_kh}    ${dict_product_nums_tocreate}
    ...   ELSE     Add new order with multi products    ${input_ma_kh}    ${dict_product_nums_tocreate}    ${input_khtt_tocreate}
    ${get_khachdatra_in_dh_bf_execute}    ${get_tongtienhang_in_dh_bf_execute}    Get paid value frm API    ${order_code}
    ${get_list_hh_in_dh_bf_execute}    ${get_ghichu_bf_execute}    Get ghi chu and list product frm API    ${order_code}
    ${list_result_tongdh_delete}    Get list order summary frm product API    ${list_product}
    #get order summary and sub total of products
    : FOR    ${ma_hh}    IN    @{list_product}
    \    Remove Values From List    ${get_list_hh_in_dh_bf_execute}    ${ma_hh}
    Log    ${get_list_hh_in_dh_bf_execute}
    ${get_list_nums_in_dh}    Get list quantity by order code    ${order_code}    ${get_list_hh_in_dh_bf_execute}
    ${get_list_status_imei}   Get list imei status thr API    ${get_list_hh_in_dh_bf_execute}
    Create list imei and other product    ${get_list_hh_in_dh_bf_execute}    ${get_list_nums_in_dh}
    ${list_result_tongdh}    ${result_list_toncuoi}    ${result_list_thanhtien}    ${list_result_giamoi}    Get list order summary - total sale - ending stocks incase discount and newprice    ${order_code}    ${get_list_hh_in_dh_bf_execute}
    ...    ${list_ggsp}   ${list_discount_type}
    #compute TTH with product
    ${result_tongtienhang}    Sum values in list    ${result_list_thanhtien}
    ${result_khachcantra}    Run Keyword If    0 < ${input_gghd} < 100    Price after % discount invoice    ${result_tongtienhang}    ${input_gghd}
    ...    ELSE IF    ${input_gghd} > 100    Minus and replace floating point    ${result_tongtienhang}    ${input_gghd}
    ...    ELSE    Set Variable    ${result_tongtienhang}
    ${result_gghd}    Run Keyword If    0 < ${input_gghd} < 100    Convert % discount to VND and round    ${result_tongtienhang}    ${input_gghd}
    ...    ELSE    Set Variable    ${input_gghd}
    ${result_khachcantra_tru_ktt}   Minus and replace floating point    ${result_khachcantra}    ${get_khachdatra_in_dh_bf_execute}
    ${tamung}    Minus and replace floating point    ${get_khachdatra_in_dh_bf_execute}    ${result_khachcantra}
    ${khtt_all}    Set Variable If    ${get_khachdatra_in_dh_bf_execute} > ${result_khachcantra_tru_ktt}    ${tamung}    ${result_khachcantra_tru_ktt}
    ${result_khtt}    Set Variable If    '${input_khtt}' == 'all'   ${khtt_all}    ${input_khtt}
    ${result_khtt_in_dh}    Run Keyword If    ${get_khachdatra_in_dh_bf_execute} > ${result_khachcantra_tru_ktt}    Minus    ${get_khachdatra_in_dh_bf_execute}    ${result_khtt}
    ...     ELSE     Sum    ${result_khtt}    ${get_khachdatra_in_dh_bf_execute}
    ##compute validation
    ${result_khachthanhtoan_in_order}    Set Variable If    '${get_khachdatra_in_dh_bf_execute}' == '0'    ${result_khtt}    ${result_khtt_in_dh}
    ${result_khachthanhtoan_in_invoice}   Run Keyword If    ${get_khachdatra_in_dh_bf_execute} > ${result_khachcantra}    Set Variable    ${result_khachcantra}
    ...    ELSE IF    '${get_khachdatra_in_dh_bf_execute}' == '0'      Set Variable    ${result_khtt}    ELSE      Set Variable    ${result_khtt_in_dh}
    #create invoice from order
    Wait Until Keyword Succeeds    3 times    5s    Before Test Ban Hang
    Wait Until Keyword Succeeds    3 times    5s    Go to xu ly dat hang    ${order_code}
    Wait Until Keyword Succeeds    3 times    5s    Go to BH frm process order    ${order_code}
    Wait Until Keyword Succeeds    3 times    5s    Delete list product into BH form    ${list_product}
    : FOR    ${item_product}    ${item_status}    ${item_imei}    IN ZIP    ${get_list_hh_in_dh_bf_execute}    ${get_list_status_imei}    ${imei_inlist}
    \    Run Keyword If    '${item_status}' == 'True'    Wait Until Keyword Succeeds    3 times    8 s    Input imei incase multi product to any form    ${item_product}    ${texbox_imei_search_multi_product}
    \    ...    ${item_serial_in_dropdown}    ${cell_imei_multi_product}    @{item_imei}    ELSE      Log    Ignore input
    : FOR    ${item_product}    ${item_ggsp}    ${item_price}   ${item_discount_type}    IN ZIP    ${get_list_hh_in_dh_bf_execute}    ${list_ggsp}
    ...    ${list_result_giamoi}    ${list_discount_type}
    \    Run keyword if    '${item_discount_type}' == 'dis'     Wait Until Keyword Succeeds    3 times    5 s    Input % discount for multi product    ${item_product}    ${item_ggsp}
    \    ...    ${item_price}    ELSE IF    '${item_discount_type}' == 'disvnd'    Input VND discount for multi product    ${item_product}    ${item_ggsp}    ${item_price}
    \    ...     ELSE IF  '${item_discount_type}' == 'changeup' or '${item_discount_type}' == 'changedown'    Wait Until Keyword Succeeds    3 times    5 s    Input newprice for multi product    ${item_product}    ${item_ggsp}
    \    ...    ELSE    Log    Ignore input
    Wait Until Keyword Succeeds    3 times    20 s   Run Keyword If    0 < ${input_gghd} < 100    Input % discount invoice    ${input_gghd}    ${result_gghd}
    ...    ELSE    Input VND discount invoice    ${input_gghd}
    Run Keyword If    '${input_khtt}' == 'all'    Click Element JS    ${button_bh_thanhtoan}
    ...    ELSE IF    ${get_khachdatra_in_dh_bf_execute} > ${result_khachcantra_tru_ktt}    Wait Until Keyword Succeeds    3 times    20 s     Input customer payment and deposit refund into BH form    ${result_khtt}
    ...    ELSE   Wait Until Keyword Succeeds    3 times    20 s    Input customer payment into BH form    ${input_khtt}    ${result_khachcantra_tru_ktt}
    Wait Until Page Contains Element    ${button_cancel}    2 mins
    Wait Until Keyword Succeeds    3 times    20 s    Click Element JS    ${button_cancel}    #tắt popup kết thúc đơn ĐH
    ${invoice_code}     Get saved code until success
    #assert value product
    Assert list of order summarry after execute    ${get_list_hh_in_dh_bf_execute}    ${list_result_tongdh}
    #assert value product del
    Assert list of order summarry after execute    ${list_product}    ${list_result_tongdh_delete}
    #assert value onhand
    Assert list of onhand after order process    ${invoice_code}    ${get_list_hh_in_dh_bf_execute}    ${get_list_nums_in_dh}    ${result_list_toncuoi}
    #assert value order
    Assert order info after execute    ${input_ma_kh}    2    ${get_tongtienhang_in_dh_bf_execute}    ${result_khachthanhtoan_in_order}    0
    ...    ${get_tongtienhang_in_dh_bf_execute}   0    ${order_code}
    Validate invoice history frm Order    ${order_code}    ${invoice_code}    ${result_khachcantra}
    #assert value invoice
    Assert invoice info after execute    ${invoice_code}    ${input_ma_kh}    ${result_tongtienhang}    ${result_khachcantra}
    ...    ${result_khachthanhtoan_in_invoice}    ${result_gghd}
    Delete invoice by invoice code    ${invoice_code}
    Delete order frm Order code    ${order_code}

uetedh_create_inv3
    [Arguments]    ${input_ma_kh}    ${input_khtt}
    Set Selenium Speed    0.5s
    #get info product, customer
    ${order_code}    ${get_khachdatra_in_dh_bf_execute}    ${get_ggdh_in_dh_bf_execute}    ${get_tongtienhang_in_dh_bf_execute}    ${get_tongcong_in_dh_bf_execute}    Get order code - paid - discount value frm API    ${input_ma_kh}
    ${get_list_id_hd_bf_execute}    ${get_list_khachcantra_in_hd}    Get list invoice and total payment frm Order api    ${order_code}
    ${get_list_hh_in_dh_bf_execute}    ${get_ghichu_bf_execute}    Get ghi chu and list product frm API    ${order_code}
    #get product frm list invoice
    ${list_hh_in_hd_bf_execute}    Create List
    : FOR    ${id_hd}    IN    @{get_list_id_hd_bf_execute}
    \    ${list_hh_in_hd_bf_execute}    Get list product frm list invoice frm Order api    ${id_hd}    ${list_hh_in_hd_bf_execute}
    Log    ${list_hh_in_hd_bf_execute}
    #get order summary and sub total of products
    : FOR    ${ma_hh_in_hd}    IN    @{list_hh_in_hd_bf_execute}
    \    Remove Values From List    ${get_list_hh_in_dh_bf_execute}    ${ma_hh_in_hd}
    Log    ${get_list_hh_in_dh_bf_execute}
    ${get_list_nums_in_dh}    Get list quantity by order code    ${order_code}    ${get_list_hh_in_dh_bf_execute}
    ${get_list_status_imei}    Get list imei status thr API    ${get_list_hh_in_dh_bf_execute}
    Create list imei and other product    ${get_list_hh_in_dh_bf_execute}    ${get_list_nums_in_dh}
    ${list_result_tongdh}    ${result_list_toncuoi}    ${result_list_thanhtien}    Get list order summary - total sale - ending stocks frm API    ${order_code}    ${get_list_hh_in_dh_bf_execute}
    #compute for invoice, order
    ${result_tongtienhang}    Sum values in list    ${result_list_thanhtien}
    ${result_khtt}    Set Variable If    '${input_khtt}' == 'all'    ${result_tongtienhang}    ${input_khtt}
    ${result_khtt_in_dh}    Sum    ${result_khtt}    ${get_khachdatra_in_dh_bf_execute}
    #create invoice from order
    Wait Until Keyword Succeeds    3 times    5s    Before Test Ban Hang
    Wait Until Keyword Succeeds    3 times    5s    Go to xu ly dat hang    ${order_code}
    Wait Until Keyword Succeeds    3 times    5s    Go to BH frm process order    ${order_code}
    : FOR    ${item_product}    ${status_imei}    ${item_imei}    IN ZIP    ${get_list_hh_in_dh_bf_execute}    ${get_list_status_imei}
    ...    ${imei_inlist}
    \    Run Keyword If    '${status_imei}' == 'True'    Wait Until Keyword Succeeds    3 times    8 s    Input imei incase multi product to any form
    \    ...    ${item_product}    ${texbox_imei_search_multi_product}    ${item_serial_in_dropdown}    ${cell_imei_multi_product}    @{item_imei}
    \    ...    ELSE    Log    Ignore input
    Run Keyword If    '${input_khtt}' == 'all'    Click Element JS    ${button_bh_thanhtoan}
    ...    ELSE    Wait Until Keyword Succeeds    3 times    20 s    Input customer payment into BH form    ${input_khtt}    ${result_tongtienhang}
    ${invoice_code}     Get saved code until success
    #assert value product
    Assert list of order summarry after execute    ${get_list_hh_in_dh_bf_execute}    ${list_result_tongdh}
    #assert value onhand
    Assert list of onhand after order process    ${invoice_code}    ${get_list_hh_in_dh_bf_execute}    ${get_list_nums_in_dh}    ${result_list_toncuoi}
    #assert value order
    Assert order info after execute    ${input_ma_kh}    3    ${get_tongtienhang_in_dh_bf_execute}    ${result_khtt_in_dh}    ${get_ggdh_in_dh_bf_execute}
    ...    ${get_tongcong_in_dh_bf_execute}   0    ${order_code}
    Validate invoice history frm Order    ${order_code}    ${invoice_code}    ${result_tongtienhang}
    #assert value invoice
    Assert invoice info after execute    ${invoice_code}    ${input_ma_kh}    ${result_tongtienhang}    ${result_tongtienhang}    ${result_khtt}    0
    Delete list invoice by list code     ${order_code}
    Delete order frm Order code    ${order_code}
