*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    ${headless_browser}
Test Setup
Test Teardown     After Test
Resource          ../../../../../core/API/api_mhbh_dathang.robot
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

*** Variables ***
&{dict_product_nums01}    HH0053=4.5    SI036=2    QD120=1.5    DV060=4    Combo37=1
&{dict_product_nums02}    HH0054=2.5    SI037=1    DVT57=2.5    DV061=3    Combo38=4
@{discount}    500000     7000.3   0     25   70000.55
@{discount_type}    changedown     disvnd    none    dis   changeup

*** Test Cases ***    Mã KH        GGDH           List product            List discount    List discount type     Khách thanh toán
Dat hang giam gia             [Tags]        EDX1      ED
                      [Template]    uetedh_create_inv4
                      CTKH097       10            ${dict_product_nums01}    ${discount}    ${discount_type}        all

Dat hang khong GG     [Tags]        EDX1       ED
                      [Template]    uetedh_create_inv5
                      CTKH098       ${discount}       ${discount_type}      20000   10000     ${dict_product_nums02}      500000
*** Keywords ***
uetedh_create_inv4
    [Arguments]    ${input_ma_kh}    ${input_ggdh_tocreate}   ${dict_product_nums}    ${list_discount}    ${list_discount_type}   ${input_khtt_tocreate}
    Set Selenium Speed    0.5s
    #get info product, customer
    ${order_code}   Add new order incase discount - payment    ${input_ma_kh}    ${input_ggdh_tocreate}    ${dict_product_nums}    ${list_discount}
    ...   ${list_discount_type}   ${input_khtt_tocreate}
    ${list_product}    Get Dictionary Keys    ${dict_product_nums}
    ${list_nums}    Get Dictionary Values    ${dict_product_nums}
    Create list imei and other product    ${list_product}    ${list_nums}
    ${order_code}    ${get_khachdatra_in_dh_bf_execute}    ${get_ggdh_in_dh_bf_execute}    ${get_tongtienhang_in_dh_bf_execute}    ${get_tongcong_in_dh_bf_execute}    Get order code - paid - discount value frm API    ${input_ma_kh}
    ${get_list_status_imei}   Get list imei status thr API    ${list_product}
    ${list_result_tongdh}    ${result_list_toncuoi}    ${result_list_thanhtien}    Get list order summary - total sale - ending stocks frm API    ${order_code}    ${list_product}
    #compute
    ${result_tongtienhang}    Sum values in list    ${result_list_thanhtien}
    ${result_TTH_tru_ggdh}    Run Keyword If    0 < ${get_ggdh_in_dh_bf_execute} < 100    Price after % discount invoice    ${result_tongtienhang}    ${get_ggdh_in_dh_bf_execute}
    ...    ELSE IF    ${get_ggdh_in_dh_bf_execute} > 100    Minus and replace floating point    ${result_tongtienhang}    ${get_ggdh_in_dh_bf_execute}
    ...    ELSE    Set Variable    ${result_tongtienhang}
    ${result_gghd}    Run Keyword If    0 < ${get_ggdh_in_dh_bf_execute} < 100    Convert % discount to VND and round    ${result_tongtienhang}    ${get_ggdh_in_dh_bf_execute}
    ...    ELSE    Set Variable    ${get_ggdh_in_dh_bf_execute}
    #create invoice from order
    Wait Until Keyword Succeeds    3 times    5s    Before Test Ban Hang
    Wait Until Keyword Succeeds    3 times    5s    Go to xu ly dat hang    ${order_code}
    Wait Until Keyword Succeeds    3 times    5s    Go to BH frm process order    ${order_code}
    : FOR    ${item_product}    ${status_imei}    ${item_imei}    IN ZIP    ${list_product}    ${get_list_status_imei}    ${imei_inlist}
    \    Run Keyword If    '${status_imei}' == 'True'    Wait Until Keyword Succeeds    3 times    8 s    Input imei incase multi product to any form    ${item_product}    ${texbox_imei_search_multi_product}
    \    ...    ${item_serial_in_dropdown}    ${cell_imei_multi_product}    @{item_imei}    ELSE      Log     Ignore input
    Wait Until Keyword Succeeds    3 times    20 s    Click Element JS    ${button_bh_thanhtoan}
    Sleep    3s
    ${invoice_code}   Get saved code after execute
    #assert value product
    Assert list of order summarry after execute    ${list_product}    ${list_result_tongdh}
    #assert value onhand
    Assert list of onhand after order process    ${invoice_code}    ${list_product}    ${list_nums}    ${result_list_toncuoi}
    #assert value order
    Assert order info after execute    ${input_ma_kh}    3    ${get_tongtienhang_in_dh_bf_execute}    ${result_TTH_tru_ggdh}    ${result_gghd}
    ...    ${get_tongcong_in_dh_bf_execute}   0    ${order_code}
    Validate invoice history frm Order    ${order_code}    ${invoice_code}    ${result_TTH_tru_ggdh}
    #assert value invoice
    Assert invoice info after execute    ${invoice_code}    ${input_ma_kh}    ${result_tongtienhang}    ${result_TTH_tru_ggdh}    ${result_TTH_tru_ggdh}
    ...    ${result_gghd}
    Delete invoice by invoice code    ${invoice_code}
    Delete order frm Order code    ${order_code}

uetedh_create_inv5
    [Arguments]    ${input_ma_kh}    ${list_ggsp}    ${list_discount_type}    ${input_gghd}    ${input_khtt}    ${dict_product_nums_tocreate}
    ...    ${input_khtt_tocreate}
    Set Selenium Speed    0.5s
    #get info product, customer
    ${order_code}    Add new order with multi products    ${input_ma_kh}    ${dict_product_nums_tocreate}    ${input_khtt_tocreate}
    ${get_no_bf_execute}    ${get_tongban_bf_execute}    ${get_tongban_tru_trahang_bf_execute}    Get Customer Debt from API    ${input_ma_kh}
    ${get_khachdatra_in_dh_bf_execute}    ${get_tongtienhang_in_dh_bf_execute}    Get paid value frm API    ${order_code}
    ${get_list_hh_in_dh_bf_execute}    ${get_ghichu_bf_execute}    Get ghi chu and list product frm API    ${order_code}
    ${get_list_nums_in_dh}    Get list quantity by order code    ${order_code}    ${get_list_hh_in_dh_bf_execute}
    #create imei
    Create list imei and other product    ${get_list_hh_in_dh_bf_execute}    ${get_list_nums_in_dh}
    ${get_list_status_imei}   Get list imei status thr API    ${get_list_hh_in_dh_bf_execute}
    ${list_result_tongdh}    ${result_list_toncuoi}    ${result_list_thanhtien}    ${list_result_giamoi}        Get list order summary - total sale - ending stocks incase discount and newprice    ${order_code}    ${get_list_hh_in_dh_bf_execute}
    ...    ${list_ggsp}   ${list_discount_type}
    #compute for invoice, order
    ${result_tongtienhang}    Sum values in list    ${result_list_thanhtien}
    ${result_TTH_tru_gghd}    Run Keyword If    0 < ${input_gghd} < 100    Price after % discount invoice    ${result_tongtienhang}    ${input_gghd}
    ...    ELSE IF    ${input_gghd} > 100    Minus and replace floating point    ${result_tongtienhang}    ${input_gghd}
    ...    ELSE    Set Variable    ${result_tongtienhang}
    ${result_gghd}    Run Keyword If    0 < ${input_gghd} < 100    Convert % discount to VND and round    ${result_tongtienhang}    ${input_gghd}
    ...    ELSE    Set Variable    ${input_gghd}
    ${result_khachcantra_in_hd}    Minus and replace floating point    ${result_TTH_tru_gghd}    ${get_khachdatra_in_dh_bf_execute}
    ${actual_khcantra_all}    Set Variable If    '${input_khtt}' == 'all'    ${result_khachcantra_in_hd}    ${input_khtt}
    ${actual_khachcantra}    Set Variable If    '${input_khtt}' == '0'    0    ${actual_khcantra_all}
    #compute invoice info to Quan ly
    ${result_khtt}    Run Keyword If    '${input_khtt}' != 'all'    Sum    ${input_khtt}    ${get_khachdatra_in_dh_bf_execute}
    ${actual_khtt_in_hd}    Set Variable If    '${input_khtt}' == 'all'    ${result_TTH_tru_gghd}    ${result_khtt}
    #compute for order
    ${result_khachthanhtoan_in_dh}    Sum and round 2    ${get_khachdatra_in_dh_bf_execute}    ${actual_khachcantra}
    #compute for cong no KH
    ${result_du_no_hd_KH}    Sum    ${get_no_bf_execute}    ${result_TTH_tru_gghd}
    ${result_PTT_hd_KH}    Minus    ${result_du_no_hd_KH}    ${actual_khachcantra}
    ${result_tongban_KH}    Sum    ${result_TTH_tru_gghd}    ${get_tongban_bf_execute}
    #create invoice from order
    Wait Until Keyword Succeeds    3 times    5s    Before Test Ban Hang
    Wait Until Keyword Succeeds    3 times    5s    Go to xu ly dat hang    ${order_code}
    Wait Until Keyword Succeeds    3 times    5s    Go to BH frm process order    ${order_code}
    : FOR    ${item_product}    ${status_imei}    ${item_imei}    IN ZIP    ${get_list_hh_in_dh_bf_execute}   ${get_list_status_imei}    ${imei_inlist}
    \    Run Keyword If    '${status_imei}' == 'True'    Wait Until Keyword Succeeds    3 times    8 s    Input imei incase multi product to any form    ${item_product}    ${texbox_imei_search_multi_product}
    \    ...    ${item_serial_in_dropdown}    ${cell_imei_multi_product}    @{item_imei}    ELSE      Log     Ignore input
    : FOR    ${item_product}    ${item_ggsp}    ${item_price}   ${item_discount_type}    IN ZIP    ${get_list_hh_in_dh_bf_execute}    ${list_ggsp}
    ...    ${list_result_giamoi}    ${list_discount_type}
    \    Run keyword if    '${item_discount_type}' == 'dis'     Wait Until Keyword Succeeds    3 times    5 s    Input % discount for multi product    ${item_product}    ${item_ggsp}
    \    ...    ${item_price}    ELSE IF    '${item_discount_type}' == 'disvnd'    Input VND discount for multi product    ${item_product}    ${item_ggsp}    ${item_price}
    \    ...     ELSE IF  '${item_discount_type}' == 'changeup' or '${item_discount_type}' == 'changedown'    Wait Until Keyword Succeeds    3 times    5 s    Input newprice for multi product    ${item_product}    ${item_ggsp}
    \    ...    ELSE    Log    Ignore input
    Run Keyword If    0 < ${input_gghd} < 100    Input % discount invoice    ${input_gghd}    ${result_gghd}    ELSE    Input VND discount invoice    ${input_gghd}
    Run Keyword If    "${input_khtt}" == "all"    Click Element JS    ${button_bh_thanhtoan}    ELSE    Input customer payment into BH form    ${input_khtt}    ${result_khachcantra_in_hd}
    Sleep    3s
    ${invoice_code}   Get saved code after execute
    #assert value product
    Assert list of order summarry after execute    ${get_list_hh_in_dh_bf_execute}    ${list_result_tongdh}
    #assert value onhand
    Assert list of onhand after order process    ${invoice_code}    ${get_list_hh_in_dh_bf_execute}    ${get_list_nums_in_dh}    ${result_list_toncuoi}
    #assert value order
    Assert order info after execute    ${input_ma_kh}    3    ${get_tongtienhang_in_dh_bf_execute}    ${result_khachthanhtoan_in_dh}    0
    ...    ${get_tongtienhang_in_dh_bf_execute}   0    ${order_code}
    Validate invoice history frm Order    ${order_code}    ${invoice_code}    ${result_TTH_tru_gghd}
    #assert value invoice
    Assert invoice info after execute    ${invoice_code}    ${input_ma_kh}    ${result_tongtienhang}    ${result_TTH_tru_gghd}    ${actual_khtt_in_hd}
    ...    ${result_gghd}
    #assert customer and so quy
    Assert customer debit amount and general ledger after invoice execute    ${invoice_code}    ${input_khtt}    ${input_ma_kh}    ${result_PTT_hd_KH}    ${result_tongban_KH}
    ...    ${actual_khachcantra}
    Delete invoice by invoice code    ${invoice_code}
    Delete order frm Order code    ${order_code}
