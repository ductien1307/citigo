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
Resource          ../../../../core/Ban_Hang/banhang_page.robot
Resource          ../../../../core/Ban_Hang/banhang_navigation.robot
Resource          ../../../../core/share/toast_message.robot
Resource          ../../../../core/API/api_soquy.robot
Resource          ../../../../core/share/javascript.robot
Resource          ../../../../core/share/discount.robot
Resource          ../../../../core/API/api_mhbh_dathang.robot

*** Variables ***
&{dict_product_num_01}    HH0025=3.6     SIL005=1    DVT24=2.4    DVL005=2     CBKH005=3
&{dict_product_num_02}    HH0026=3.6     SIL006=1    QDKL025=2.4    DVL006=2     CBKH006=3
&{list_product_delete1}    SIL006=1
@{discount}           10   85000.22    0    5000      190000.45
@{discount_type}      dis   changedown    none     disvnd   changeup
@{list_soluong_addrow}   1,2   4   3.5,1.8,2     3     1,2
@{discount_addrow}   0,7000     5     3000,10000,0     89000     7,200000.56
@{discount_type_addrow}  none,disvnd    dis   disvnd,changedown,none   changeup  dis,changeup

*** Test Cases ***    List product&nums    List GGSP      List discount type    GGDH       Khách TT
Create order             [Tags]       UEDMNOCUS
                      [Template]    edhkl5
                      ${dict_product_num_01}     ${discount}     ${discount_type}     ${list_soluong_addrow}     ${discount_addrow}     ${discount_type_addrow}     15          0

Lay 1 phan don hang       [Tags]         UEDMNOCUS          GOLIVE1A
                      [Template]    edhkl6
                      ${list_product_delete1}   ${list_soluong_addrow}    ${discount_addrow}     ${discount_type_addrow}    100000      20000      ${dict_product_num_02}     ${discount}    ${discount_type}     4000000

*** Keywords ***
edhkl5
    [Arguments]    ${dict_product_nums}   ${list_ggsp}    ${list_discount_type}   ${list_nums_addrow}   ${list_discount_addrow}    ${list_type_discount_addrow}
    ...       ${input_ggdh}    ${input_khtt}
    #get info product, customer
    Set Selenium Speed    0.5s
    ${list_nums_addrow}   ${list_discount_addrow}    ${list_type_discount_addrow}   Convert three string list to composite list    ${list_nums_addrow}    ${list_discount_addrow}
    ...    ${list_type_discount_addrow}
    ${list_product}    Get Dictionary Keys    ${dict_product_nums}
    ${list_nums}    Get Dictionary Values    ${dict_product_nums}
    ${list_result_thanhtien}    ${list_result_ordersummary}    ${list_result_giamoi}    Get list total sale and order summary incase discount and newprice    ${list_product}    ${list_nums}    ${list_ggsp}    ${list_discount_type}
    ${list_result_thanhtien_addrow}    ${list_result_giamoi_addrow}    ${list_result_order_summary}    Get list total sale - order summary - newprice incase add row product    ${list_product}    ${list_nums_addrow}
    ...    ${list_discount_addrow}    ${list_type_discount_addrow}    ${list_result_ordersummary}
    ${get_list_id_product}    Get list product id thr API    ${list_product}
    #compute
    ${result_tongtienhang}    Sum values in list and round    ${list_result_thanhtien}
    ${result_tongtienhang_addrow}    Sum values in list and round    ${list_result_thanhtien_addrow}
    ${result_tongtienhang}    Sum and round     ${result_tongtienhang}    ${result_tongtienhang_addrow}
    ${result_tongcong}    Run Keyword If    0 < ${input_ggdh} < 100    Price after % discount invoice    ${result_tongtienhang}    ${input_ggdh}
    ...    ELSE IF    ${input_ggdh} > 100    Minus and replace floating point    ${result_tongtienhang}    ${input_ggdh}
    ...    ELSE    Set Variable    ${result_tongtienhang}
    ${result_ggdh}    Run Keyword If    0 < ${input_ggdh} < 100    Convert % discount to VND and round    ${result_tongtienhang}    ${input_ggdh}    ELSE    Set Variable    ${input_ggdh}
    ${result_tongcong}    Replace floating point    ${result_tongcong}
    ${actual_khtt_all}    Set Variable If    '${input_khtt}' == 'all'    ${result_tongcong}    ${input_khtt}
    ${actual_khtt}    Set Variable If    '${input_khtt}' == '0'    0    ${actual_khtt_all}
    #input data into DH form
    Before Test turning on display mode      ${toggle_item_themdong}
    Wait Until Keyword Succeeds    3 times    5 s    Click Element JS    ${tab_dathang}
    Reload Page
    ${laster_nums}    Set Variable    0
    : FOR    ${item_product}    ${item_nums}    ${item_ggsp}    ${result_giamoi}    ${discount_type}       ${nums_addrow}    ${item_ggsp_addrow}    ${result_giamoi_addrow}
    ...   ${discount_type_addrow}   ${product_id}    IN ZIP    ${list_product}    ${list_nums}   ${list_ggsp}  ${list_result_giamoi}   ${list_discount_type}
    ...   ${list_nums_addrow}    ${list_discount_addrow}   ${list_result_giamoi_addrow}   ${list_type_discount_addrow}    ${get_list_id_product}
    \    ${laster_nums}    Wait Until Keyword Succeeds    3 times    5 s    Input product-num in sale form    ${item_product}    ${item_nums}    ${laster_nums}    ${cell_tongsoluong_dh}
    \    Run Keyword If    '${discount_type}' == 'dis'   Wait Until Keyword Succeeds    3 times    5 s   Input % discount for multi product    ${item_product}    ${item_ggsp}    ${result_giamoi}
    \    ...    ELSE IF    '${discount_type}' == 'disvnd'  Wait Until Keyword Succeeds    3 times    5 s    Input VND discount for multi product    ${item_product}    ${item_ggsp}    ${result_giamoi}
    \    ...    ELSE IF    '${discount_type}' == 'changeup' or '${discount_type}' == 'changedown'  Wait Until Keyword Succeeds    3 times    5 s    Input newprice for multi product    ${item_product}   ${item_ggsp}
    \    ...    ELSE    Log    Ignore input
    \     ${laster_nums}    Add row product incase multi product in MHBH    ${item_product}   ${nums_addrow}    ${item_ggsp_addrow}
    \     ...   ${result_giamoi_addrow}   ${discount_type_addrow}   ${product_id}        ${laster_nums}    ${cell_tongsoluong_dh}
    Run keyword if    0 < ${input_ggdh} < 100    Wait Until Keyword Succeeds    3 times    5s    Input % discount order    ${input_ggdh}    ${result_ggdh}
    ...    ELSE    Wait Until Keyword Succeeds    3 times    5s    Input VND discount order    ${input_ggdh}
    Run Keyword If    '${input_khtt}' == '0'    Log      Ingore input    ELSE    Wait Until Keyword Succeeds    3 times    5 s    Input payment from customer
    ...    ${textbox_dh_khachtt}    ${actual_khtt}    ${result_tongcong}    ${cell_tinhvaocongno_order}
    Wait Until Keyword Succeeds    3 times    5 s    Click Element JS    ${button_bh_dathang}
    Wait Until Keyword Succeeds    3 times    5 s    Click Element JS    ${button_dongy_popup_nocustomer}
    Sleep   2s
    Order message success validation
    ${get_ma_dh}    Get saved code after execute
    #get values
    Sleep    20 s    wait for response to API
    #assert value product
    ${list_order_summary_af_execute}    Get list order summary frm product API    ${list_product}
    : FOR    ${result_tong_dh}    ${order_summary_af_execute}    IN ZIP    ${list_result_order_summary}    ${list_order_summary_af_execute}
    \    Should Be Equal As Numbers    ${order_summary_af_execute}    ${result_tong_dh}
    #assert value order
    ${get_ma_kh_in_dh_af_execute}    ${get_TTDH_in_dh_af_execute}    ${get_tongtienhang_in_dh_af_exxecute}    ${get_khachdatra_in_dh_af_execute}    ${get_giamgia_in_dh_af_execute}    ${get_tongcong_in_dh_af_execute}    ${get_ghichu_in_dh_af_execute}
    ...    Get order info incase discount by order code    ${get_ma_dh}
    Should Be Equal As Strings    ${get_ma_kh_in_dh_af_execute}    0
    Should Be Equal As Numbers    ${get_TTDH_in_dh_af_execute}    1    #1 : phiếu tạm
    Run Keyword If    ${input_ggdh} == 0    Should Be Equal As Numbers    ${get_tongcong_in_dh_af_execute}    ${result_tongtienhang}
    ...    ELSE    Should Be Equal As Numbers    ${get_tongtienhang_in_dh_af_exxecute}    ${result_tongtienhang}
    Run Keyword If    ${input_ggdh} == 0    Log    Ignore validate
    ...    ELSE    Should Be Equal As Numbers    ${get_tongtienhang_in_dh_af_exxecute}    ${result_tongtienhang}
    Should Be Equal As Numbers    ${get_khachdatra_in_dh_af_execute}    ${actual_khtt}
    Should Be Equal As Numbers    ${get_giamgia_in_dh_af_execute}    ${result_ggdh}
    Should Be Equal As Numbers    ${get_tongcong_in_dh_af_execute}    ${result_tongcong}
    Delete order frm Order code    ${get_ma_dh}

edhkl6
    [Arguments]    ${list_product_delete}   ${list_nums_addrow}   ${list_discount_addrow}   ${list_type_discount_addrow}    ${input_khtt}   ${input_ggdh_tocreate}
    ...   ${list_product_tocreate}   ${list_ggsp_tocreate}   ${list_discount_type_tocreate}   ${input_khtt_to_create}
    [Documentation]    1. Get thông tin của khách hàng và product (dòng 2 -7)
    ...    2. Lấy ra tổng đặt hàng và tồn kho của từng sản phẩm, tính toán
    Set Selenium Speed    0.5s
    #get info product, customer
    ${order_code}   Add new order incase discount - payment - nocus and return order code   ${input_ggdh_tocreate}   ${list_product_tocreate}   ${list_ggsp_tocreate}   ${list_discount_type_tocreate}   ${input_khtt_to_create}
    ${list_nums_addrow}   ${list_discount_addrow}    ${list_type_discount_addrow}   Convert three string list to composite list    ${list_nums_addrow}    ${list_discount_addrow}
    ...    ${list_type_discount_addrow}
    ${list_product_del}    Get Dictionary Keys    ${list_product_delete}
    ${list_nums_del}    Get Dictionary Values    ${list_product_delete}
    ${get_ma_kh}    ${get_TTDH}    ${get_tongtienhang_in_dh_bf_execute}    ${get_khachdatra_in_dh_bf_execute}    ${get_ggdh_in_dh_bf_execute}    ${get_tongcong_in_dh_bf_execute}    Get order info incase discount not note by order code    ${order_code}
    ${get_list_hh_in_dh_bf_execute}    ${get_ghichu_bf_execute}   Get ghi chu and list product frm API    ${order_code}
    ${get_list_nums_in_dh}    Get list quantity by order code    ${order_code}    ${get_list_hh_in_dh_bf_execute}
    ${list_result_tongdh_delete}    Get list order summary frm product API    ${list_product_delete}
    #get order summary and sub total of products
    : FOR    ${ma_hh}    ${item_nums}    IN ZIP    ${list_product_del}    ${list_nums_del}
    \    Remove Values From List    ${get_list_hh_in_dh_bf_execute}    ${ma_hh}
    \    Remove Values From List    ${get_list_nums_in_dh}    ${item_nums}
    Log    ${get_list_hh_in_dh_bf_execute}
    Log    ${get_list_nums_in_dh}
    ${get_list_id_product}    Get list product id thr API    ${get_list_hh_in_dh_bf_execute}
    ${get_list_status}    Get list imei status thr API    ${get_list_hh_in_dh_bf_execute}
    Create list imei and other product    ${get_list_hh_in_dh_bf_execute}    ${get_list_nums_in_dh}
    ${list_result_tongdh}    ${result_list_toncuoi}    ${result_list_thanhtien}    Get list order summary - total sale - ending stocks frm API    ${order_code}    ${get_list_hh_in_dh_bf_execute}
    ${list_imei_inlist}   Create list imei incase other product have multi row    ${get_list_hh_in_dh_bf_execute}    ${list_nums_addrow}    ${get_list_status}
    ${list_giatri_quydoi}    Get list gia tri quy doi frm product API    ${get_list_hh_in_dh_bf_execute}
    ${list_result_thanhtien_addrow}      ${list_result_newprice_addrow}   ${list_result_toncuoi}    ${list_result_soluong}   Get list total sale - ending stock - total quantity incase add row product    ${get_list_hh_in_dh_bf_execute}
    ...    ${list_nums_addrow}    ${list_discount_addrow}    ${list_type_discount_addrow}    ${result_list_toncuoi}    ${get_list_nums_in_dh}    ${list_giatri_quydoi}
    #compute invoice info
    ${result_tongtienhang}    Sum values in list    ${result_list_thanhtien}
    ${result_tongsoluong}    Sum values in list    ${get_list_nums_in_dh}
    ${result_tongtienhang_addrow}    Sum values in list and round    ${list_result_thanhtien_addrow}
    ${result_tongtienhang}    Sum    ${result_tongtienhang}    ${result_tongtienhang_addrow}
    ${result_TTH_tru_ggdh}    Run Keyword If    0 < ${get_ggdh_in_dh_bf_execute} < 100    Price after % discount invoice    ${result_tongtienhang}    ${get_ggdh_in_dh_bf_execute}
    ...    ELSE IF    ${get_ggdh_in_dh_bf_execute} > 100    Minus and replace floating point    ${result_tongtienhang}    ${get_ggdh_in_dh_bf_execute}
    ...    ELSE    Set Variable    ${result_tongtienhang}
    ${result_ggdh}    Run Keyword If    0 < ${get_ggdh_in_dh_bf_execute} < 100    Convert % discount to VND and round    ${result_tongtienhang}    ${get_ggdh_in_dh_bf_execute}
    ...    ELSE    Set Variable    ${get_ggdh_in_dh_bf_execute}
    ${tamung}    Minus and replace floating point    ${get_khachdatra_in_dh_bf_execute}    ${result_TTH_tru_ggdh}
    ${result_khtt}    Minus and replace floating point    ${result_TTH_tru_ggdh}    ${get_khachdatra_in_dh_bf_execute}
    ${result_khachcantra}   Set Variable If   ${get_khachdatra_in_dh_bf_execute}>${result_TTH_tru_ggdh}     ${tamung}    ${result_khtt}
    ${actual_khtt_all}    Set Variable If    '${input_khtt}' == 'all'    ${result_khachcantra}    ${input_khtt}
    ${actual_khtt}    Set Variable If    '${input_khtt}' == '0'    0    ${actual_khtt_all}
    #compute order info
    ${result_khachthanhtoan_in_dh}    Sum and replace floating point    ${actual_khtt}    ${get_khachdatra_in_dh_bf_execute}
    ${result_khachtamung_in_dh}    Minus    ${get_khachdatra_in_dh_bf_execute}    ${actual_khtt}
    ${actual_khtt_paymented}    Set Variable If   ${get_khachdatra_in_dh_bf_execute}>${result_TTH_tru_ggdh}    ${result_khachtamung_in_dh}    ${result_khachthanhtoan_in_dh}
    ${get_list_status}    Get list imei status thr API    ${get_list_hh_in_dh_bf_execute}
    #create invoice frm Order
    Wait Until Keyword Succeeds    3 times    5s    Before Test turning on display mode      ${toggle_item_themdong}
    Wait Until Keyword Succeeds    3 times    5s    Go to xu ly dat hang    ${order_code}
    Wait Until Keyword Succeeds    3 times    5s    Go to BH frm process order    ${order_code}
    Wait Until Keyword Succeeds    3 times    5s    Delete list product into BH form    ${list_product_delete}
    ${laster_nums}    Set Variable    ${result_tongsoluong}
    : FOR    ${item_ma_hh}   ${item_imei}   ${item_status_imei}    IN ZIP    ${get_list_hh_in_dh_bf_execute}    ${imei_inlist}    ${get_list_status}
    \    Run Keyword If    '${item_status_imei}' != '0'    Input imei incase multi product to any form    ${item_ma_hh}    ${texbox_imei_search_multi_product}    ${item_serial_in_dropdown}    ${cell_imei_multi_product}    @{item_imei}
    : FOR    ${item_product1}   ${nums_addrow}    ${item_ggsp_addrow}    ${result_giamoi_addrow}   ${discount_type_addrow}   ${product_id}   ${item_status_imei}    ${item_imei_inlist}    IN ZIP    ${get_list_hh_in_dh_bf_execute}
    ...   ${list_nums_addrow}    ${list_discount_addrow}   ${list_result_newprice_addrow}   ${list_type_discount_addrow}   ${get_list_id_product}       ${get_list_status}     ${list_imei_inlist}
    \     ${laster_nums}    Run Keyword If    '${item_status_imei}' == '0'    Add row product incase multi product in MHBH    ${item_product1}   ${nums_addrow}    ${item_ggsp_addrow}
    \     ...   ${result_giamoi_addrow}   ${discount_type_addrow}   ${product_id}    ${laster_nums}    ${cell_lastest_number}
    \    ...  ELSE      Add row product incase imei in MHBH    ${item_product1}    ${nums_addrow}    ${discount_type_addrow}    ${item_ggsp_addrow}    ${result_giamoi_addrow}    ${product_id}    ${laster_nums}    ${cell_lastest_number}    ${item_imei_inlist}
    Run Keyword If    "${input_khtt}" == "all"    Click Element JS    ${button_bh_thanhtoan}    ELSE IF   ${get_khachdatra_in_dh_bf_execute}>${result_TTH_tru_ggdh}
    ...   Wait Until Keyword Succeeds    3 times    5s         Input customer payment and deposit refund into BH form    ${input_khtt}
    ...     ELSE   Wait Until Keyword Succeeds    3 times    5s    Input customer payment into BH form    ${input_khtt}    ${result_khachcantra}
    Run Keyword If    "${input_khtt}" == "all"    Log     Ingore click      ELSE    Click Element JS    ${button_dongy_popup_nocustomer}
    Wait Until Page Contains Element    ${button_cancel}    2 mins
    Wait Until Keyword Succeeds    3 times    5s    Click Element JS    ${button_cancel}    #tắt popup kết thúc đơn ĐH
    ${invoice_code}    Get saved code after execute
    #assert value product
    Assert list of order summarry after execute    ${get_list_hh_in_dh_bf_execute}    ${list_result_tongdh}
    #assert value product
    Assert list of order summarry after execute    ${list_product_delete}    ${list_result_tongdh_delete}
    #assert value onhand
    Assert list of onhand after order process    ${invoice_code}    ${get_list_hh_in_dh_bf_execute}    ${get_list_nums_in_dh}    ${result_list_toncuoi}
    #assert value order
    Assert order info after execute    0    2    ${get_tongtienhang_in_dh_bf_execute}    ${actual_khtt_paymented}    ${get_ggdh_in_dh_bf_execute}
    ...    ${get_tongcong_in_dh_bf_execute}   ${get_ghichu_bf_execute}    ${order_code}
    Validate invoice history frm Order    ${order_code}    ${invoice_code}    ${result_TTH_tru_ggdh}
    #assert value invoice
    Assert invoice info after execute    ${invoice_code}    0    ${result_tongtienhang}    ${result_TTH_tru_ggdh}    ${actual_khtt_paymented}    ${result_ggdh}
    Delete invoice by invoice code    ${invoice_code}
    Delete order frm Order code    ${order_code}
