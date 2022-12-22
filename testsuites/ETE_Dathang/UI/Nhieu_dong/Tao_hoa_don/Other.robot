*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    ${headless_browser}
Test Setup
Test Teardown     After Test
Library           SeleniumLibrary
Resource          ../../../../../core/API/api_danhmuc_hanghoa.robot
Resource          ../../../../../core/API/api_dathang.robot
Resource          ../../../../../core/API/api_khachhang.robot
Resource          ../../../../../core/API/api_mhbh.robot
Resource          ../../../../../core/Dat_Hang/dat_hang_action.robot
Resource          ../../../../../core/Dat_Hang/dat_hang_navigation.robot
Resource          ../../../../../core/Dat_Hang/dat_hang_page.robot
Resource          ../../../../../core/Ban_Hang/banhang_action.robot
Resource          ../../../../../core/Ban_Hang/banhang_page.robot
Resource          ../../../../../core/Ban_Hang/banhang_navigation.robot
Resource          ../../../../../core/share/toast_message.robot
Resource          ../../../../../core/API/api_soquy.robot
Resource          ../../../../../core/share/javascript.robot
Resource          ../../../../../core/share/list_dictionary.robot
Resource          ../../../../../core/share/discount.robot
Resource          ../../../../../core/API/api_mhbh_dathang.robot
Resource          ../../../../../core/API/api_hoadon_banhang.robot
Resource          ../../../../../core/share/imei.robot

*** Variables ***
&{list_product11}    HH0019=4.75    DVT16=2.5    DV019=1    Combo19=1.5    SI019=1
&{list_product12}    HH0020=4.75    QDKL017=2.5    DV020=1    Combo20=1.5    SI020=1
&{list_product13}    DV012=5
@{list_product_delete}    SI020
&{list_product_add}    Combo12=2    QDKL018=3.2
@{discount}           20    0    5000    200000   220000
@{discount_type}      dis    none    disvnd    changeup       changedown
@{discount_new}   500000.55        50000
@{discount_type_new}  changedown     changeup
@{list_soluong_addrow}   2      1       3.5,2.75     1,0.5,4        1,2
@{discount_addrow}   590000     0        15,1000      10,0,5000.1         0,350000
@{discount_type_addrow}  changedown    none     dis,disvnd   dis,none,disvnd    none,changeup

*** Test Cases ***    Mã KH         List product&nums           Bảng giá    List nums add row             GGSP add row       List type discount add row      Khách TT
Thay_doi_bang_gia      [Tags]    UEDXM
                      [Template]    etedh_inv_multirow10
                      CTKH030       ${list_product11}           Bảng giá hóa đơn     ${list_soluong_addrow}    ${discount_addrow}     ${discount_type_addrow}      15          0

Add_product_order_1phan     [Tags]    UEDXM
                      [Template]    etedh_inv_multirow11
                      CTKH031   ${list_product12}    5000000     ${discount}   ${discount_type}    ${list_product_delete}    ${list_soluong_addrow}    ${discount_addrow}     ${discount_type_addrow}    10    200000     ${list_product_add}     ${discount_new}   ${discount_type_new}

Add_product_all_order              [Tags]    UEDXM
                      [Template]    etedh_inv_multirow12
                      CTKH032        ${list_product13}   100000   ${list_product_add}     50000     all

*** Keywords ***
etedh_inv_multirow10
    [Arguments]    ${input_ma_kh}   ${list_product_tocreate}    ${input_ten_bangia}    ${list_nums_addrow}   ${list_discount_addrow}
    ...   ${list_type_discount_addrow}    ${input_gghd}    ${input_khtt}
    Set Selenium Speed    0.5s
    #get info product, customer
    ${list_nums_addrow}   ${list_discount_addrow}    ${list_type_discount_addrow}   Convert three string list to composite list    ${list_nums_addrow}    ${list_discount_addrow}
    ...    ${list_type_discount_addrow}
    ${order_code}    Add new order with multi product and no payment - get order code    ${input_ma_kh}    ${list_product_tocreate}
    ${get_khachdatra_in_dh_bf_execute}    ${get_tongtienhang_in_dh_bf_execute}    Get paid value frm API    ${order_code}
    ${get_list_hh_in_dh_bf_execute}    ${get_ghichu_bf_execute}   Get ghi chu and list product frm API    ${order_code}
    ${get_list_nums_in_dh}    Get list quantity by order code    ${order_code}    ${get_list_hh_in_dh_bf_execute}
    ${get_list_id_product}    ${get_list_status}    Get list imei status and id product thr API    ${get_list_hh_in_dh_bf_execute}
    Create list imei and other product    ${get_list_hh_in_dh_bf_execute}    ${get_list_nums_in_dh}
    ${list_imei_inlist}   Create list imei incase other product have multi row    ${get_list_hh_in_dh_bf_execute}    ${list_nums_addrow}    ${get_list_status}
    ${get_no_bf_execute}    ${get_tongban_bf_execute}    ${get_tongban_tru_trahang_bf_execute}    Get Customer Debt from API    ${input_ma_kh}
    #get order summary and sub total of products
    ${list_result_tongdh}    ${result_list_toncuoi}    ${result_list_thanhtien}    ${list_giaban_new}    Change pricebook and get list order summary and ending stocks frm API    ${order_code}    ${get_list_hh_in_dh_bf_execute}    ${input_ten_bangia}
    ${list_giatri_quydoi}    Get list gia tri quy doi frm product API    ${get_list_hh_in_dh_bf_execute}
    ${get_list_product_type}    ${list_tonkho_service}    Get list product type and ending stock of service frm API    ${get_list_hh_in_dh_bf_execute}
    ${list_result_toncuoi}    ${list_result_soluong}    Get list resutl ending stock and quantity incase add row product    ${get_list_hh_in_dh_bf_execute}    ${result_list_toncuoi}    ${list_nums_addrow}    ${get_list_nums_in_dh}    ${list_giatri_quydoi}   ${get_list_product_type}    ${list_tonkho_service}
    ${list_result_newprice_addrow}    Create List
    ${list_result_thanhtien_addrow}    Create List
    :FOR  ${item_giaban}      ${item_quantity_addrow}    ${item_gg_sp_addrow}    ${type_discount_addrow}   IN ZIP    ${list_giaban_new}   ${list_nums_addrow}   ${list_discount_addrow}    ${list_type_discount_addrow}
    \   ${list_thanhtien_addrow}    ${list_newprice_addrow}    Get list total sale incase add row product    ${item_giaban}   ${item_quantity_addrow}    ${item_gg_sp_addrow}    ${type_discount_addrow}
    \   Append to List     ${list_result_newprice_addrow}    ${list_newprice_addrow}
    \   Append to List     ${list_result_thanhtien_addrow}    ${list_thanhtien_addrow}
    ${list_result_thanhtien_addrow}    Convert String to List    ${list_result_thanhtien_addrow}
    #compute TTH with product
    ${result_tongtienhang}    Sum values in list    ${result_list_thanhtien}
    ${result_tongsoluong}    Sum values in list    ${get_list_nums_in_dh}
    ${result_tongtienhang_addrow}    Sum values in list and round    ${list_result_thanhtien_addrow}
    ${result_tongtienhang}    Sum    ${result_tongtienhang}    ${result_tongtienhang_addrow}
    ${result_TTH_tru_gghd}    Run Keyword If    0 < ${input_gghd} < 100    Price after % discount invoice    ${result_tongtienhang}    ${input_gghd}
    ...    ELSE IF    ${input_gghd} > 100    Minus and replace floating point    ${result_tongtienhang}    ${input_gghd}
    ...    ELSE    Set Variable    ${result_tongtienhang}
    ${result_gghd}    Run Keyword If    0 < ${input_gghd} < 100    Convert % discount to VND and round    ${result_tongtienhang}    ${input_gghd}
    ...    ELSE    Set Variable    ${input_gghd}
    ${result_khachcantra}    Minus and replace floating point    ${result_TTH_tru_gghd}    ${get_khachdatra_in_dh_bf_execute}
    ${actual_khtt_all}    Set Variable If    '${input_khtt}' == 'all'    ${result_khachcantra}    ${input_khtt}
    ${actual_khtt}    Set Variable If    '${input_khtt}' == '0'    0    ${actual_khtt_all}
    ${actual_khtt_paymented}    Sum and replace floating point    ${actual_khtt}    ${get_khachdatra_in_dh_bf_execute}
    #compute cong no KH
    ${result_du_no_hd_KH}    Sum    ${get_no_bf_execute}    ${result_TTH_tru_gghd}
    ${result_PTT_hd_KH}    Minus and replace floating point    ${result_du_no_hd_KH}    ${actual_khtt}
    ${result_tongban_KH}    Sum and replace floating point    ${result_TTH_tru_gghd}    ${get_tongban_bf_execute}
    #create invoice frm Order
    Before Test turning on display mode      ${toggle_item_themdong}
    Go to xu ly dat hang    ${order_code}
    Go to BH frm process order    ${order_code}
    Select Bang gia    ${input_ten_bangia}
    ${laster_nums}    Set Variable    ${result_tongsoluong}
    : FOR    ${item_ma_hh}   ${item_imei}   ${item_status_imei}    IN ZIP    ${get_list_hh_in_dh_bf_execute}    ${imei_inlist}    ${get_list_status}
    \    Run Keyword If    '${item_status_imei}' != '0'    Input imei incase multi product to any form    ${item_ma_hh}    ${texbox_imei_search_multi_product}    ${item_serial_in_dropdown}    ${cell_imei_multi_product}    @{item_imei}
    : FOR    ${item_product1}   ${nums_addrow}    ${item_ggsp_addrow}    ${result_giamoi_addrow}   ${discount_type_addrow}   ${product_id}   ${item_status_imei_addrow}   ${item_imei_addrow}    IN ZIP    ${get_list_hh_in_dh_bf_execute}
    ...   ${list_nums_addrow}    ${list_discount_addrow}   ${list_result_newprice_addrow}   ${list_type_discount_addrow}   ${get_list_id_product}    ${get_list_status}       ${list_imei_inlist}
    \     ${laster_nums}    Run Keyword If    '${item_status_imei_addrow}' == '0'    Add row product incase multi product in MHBH    ${item_product1}   ${nums_addrow}    ${item_ggsp_addrow}
    \     ...   ${result_giamoi_addrow}   ${discount_type_addrow}   ${product_id}    ${laster_nums}    ${cell_lastest_number}
    \    ...  ELSE      Add row product incase imei in MHBH    ${item_product1}    ${nums_addrow}    ${discount_type_addrow}    ${item_ggsp_addrow}
    \    ...    ${result_giamoi_addrow}    ${product_id}    ${laster_nums}    ${cell_lastest_number}   ${item_imei_addrow}
    Run Keyword If    0 < ${input_gghd} < 100    Wait Until Keyword Succeeds    3 times    5 s   Input % discount invoice    ${input_gghd}    ${result_gghd}    ELSE    Wait Until Keyword Succeeds    3 times    5 s   Input VND discount invoice    ${input_gghd}
    Run Keyword If    "${input_khtt}" == "all"    Click Element JS    ${button_bh_thanhtoan}    ELSE    Wait Until Keyword Succeeds    3 times    5 s   Input customer payment into BH form    ${input_khtt}    ${result_khachcantra}
    Sleep     2s
    ${invoice_code}    Get saved code after execute
    Sleep    20 s    wait for response to API
    #assert value product in invoice
    : FOR    ${ma_hh}    ${result_toncuoi}    ${item_soluong}    ${get_giatri_quydoi}    IN ZIP    ${get_list_hh_in_dh_bf_execute}    ${list_result_toncuoi}    ${list_result_soluong}    ${list_giatri_quydoi}
    \    Run Keyword If    '${get_giatri_quydoi}' == '1'    Validate product history frm API    ${invoice_code}    ${ma_hh}    ${result_toncuoi}    ${item_soluong}
    \    ...    ELSE    Validate unit product history frm API    ${invoice_code}    ${ma_hh}    ${result_toncuoi}   ${item_soluong}    ${get_giatri_quydoi}
    #validate product
    ${list_order_summary_af_execute}    Get list order summary frm product API    ${get_list_hh_in_dh_bf_execute}
    ${list_giaban_in_hd}    Get list price after change pricebook frm invoice API    ${get_list_hh_in_dh_bf_execute}    ${invoice_code}
    : FOR    ${result_tong_dh}    ${order_summary_af_execute}    ${get_giaban_in_hd}    ${giaban_new}    IN ZIP    ${list_result_tongdh}
    ...    ${list_order_summary_af_execute}    ${list_giaban_in_hd}    ${list_giaban_new}
    \    Should Be Equal As Numbers    ${order_summary_af_execute}    ${result_tong_dh}
    \    Should Be Equal As Numbers    ${get_giaban_in_hd}    ${giaban_new}
    #assert value invoice
    ${get_ma_kh_by_hd}    ${get_tong_tien_hang}    ${get_khachtt_af_execute}    ${get_gghd_af_execute}    ${get_khachcantra}    ${get_trangthai}    ${get_ghichu_in_hd_af_execute}
    ...    Get invoice info have note incase discount by invoice code    ${invoice_code}
    Run Keyword If    ${input_gghd} == 0    Should Be Equal As Numbers    ${get_khachcantra}    ${result_tongtienhang}
    ...    ELSE    Should Be Equal As Numbers    ${get_tong_tien_hang}    ${result_tongtienhang}
    Run Keyword If    ${input_gghd} == 0    Log    Ignore validate
    ...    ELSE    Should Be Equal As Numbers    ${get_tong_tien_hang}    ${result_tongtienhang}
    Should Be Equal As Numbers    ${get_khachcantra}    ${result_TTH_tru_gghd}
    Should Be Equal As Numbers    ${get_khachtt_af_execute}    ${actual_khtt_paymented}
    Should Be Equal As Strings    ${get_ma_kh_by_hd}    ${input_ma_kh}
    Should Be Equal As Numbers    ${get_gghd_af_execute}    ${result_gghd}
    Should Be Equal As Strings    ${get_trangthai}    Hoàn thành
    Should Be Equal As Strings    ${get_ghichu_in_hd_af_execute}    ${get_ghichu_bf_execute}
    #assert value order
    ${get_ma_kh_in_dh_af_execute}    ${get_TTDH_in_dh_af_execute}    ${get_tongtienhang_in_dh_af_exxecute}    ${get_khachdatra_in_dh_af_execute}    ${get_ghichu_af_execute}    Get order info have note by order code    ${order_code}
    Should Be Equal As Strings    ${get_ma_kh_in_dh_af_execute}    ${input_ma_kh}
    Should Be Equal As Strings    ${get_TTDH_in_dh_af_execute}    3    #trạng thái hoàn thành
    Should Be Equal As Numbers    ${get_tongtienhang_in_dh_af_exxecute}    ${get_tongtienhang_in_dh_bf_execute}
    Should Be Equal As Numbers    ${get_khachdatra_in_dh_af_execute}    ${actual_khtt_paymented}
    Should Be Equal As Strings    ${get_ghichu_af_execute}    ${get_ghichu_bf_execute}
    Validate invoice history frm Order    ${order_code}    ${invoice_code}    ${result_TTH_tru_gghd}
    #assert Customer
    ${get_no_af_execute_kh}    ${get_tongban_af_execute_kh}    ${get_tongban_tru_trahang_af_execute_kh}    Get Customer Debt from API after purchase    ${input_ma_kh}    ${invoice_code}    ${actual_khtt}
    Run Keyword If    '${input_khtt}' == '0'    Should Be Equal As Numbers    ${get_no_af_execute_kh}    ${result_du_no_hd_KH}
    ...    ELSE    Should Be Equal As Numbers    ${get_no_af_execute_kh}    ${result_PTT_hd_KH}
    Delete invoice by invoice code    ${invoice_code}
    Delete order frm Order code    ${order_code}

etedh_inv_multirow11
    [Arguments]    ${input_ma_kh}   ${list_product_tocreate}    ${input_khtt_tocreate}    ${list_ggsp}   ${list_discount_type}    ${list_product_del}    ${list_nums_addrow}
    ...   ${list_discount_addrow}   ${list_type_discount_addrow}    ${input_gghd}    ${input_khtt}   ${dict_product_new}    ${list_ggsp_new}    ${list_discount_type_new}
    Set Selenium Speed    0.5s
    #get info product, customer
    ${list_product_new}    Get Dictionary Keys    ${dict_product_new}
    ${list_nums_new}    Get Dictionary Values    ${dict_product_new}
    ${list_nums_addrow}   ${list_discount_addrow}    ${list_type_discount_addrow}   Convert three string list to composite list    ${list_nums_addrow}    ${list_discount_addrow}
    ...    ${list_type_discount_addrow}
    ${order_code}    Add new order with multi products    ${input_ma_kh}    ${list_product_tocreate}    ${input_khtt_tocreate}
    ${get_khachdatra_in_dh_bf_execute}    ${get_tongtienhang_in_dh_bf_execute}    Get paid value frm API    ${order_code}
    ${get_list_hh_in_dh_bf_execute}    ${get_ghichu_bf_execute}   Get ghi chu and list product frm API    ${order_code}
    ${get_list_nums_in_dh}    Get list quantity by order code    ${order_code}    ${get_list_hh_in_dh_bf_execute}
    ${list_result_tongdh_delete}    Get list order summary frm product API    ${list_product_del}
    ${get_no_bf_execute}    ${get_tongban_bf_execute}    ${get_tongban_tru_trahang_bf_execute}    Get Customer Debt from API    ${input_ma_kh}
    #get order summary and sub total of products
    : FOR    ${ma_hh}    IN ZIP    ${list_product_del}
    \    Remove Values From List    ${get_list_hh_in_dh_bf_execute}    ${ma_hh}
    Log    ${get_list_hh_in_dh_bf_execute}
    ${get_list_nums_in_dh}    Get list quantity by order code    ${order_code}    ${get_list_hh_in_dh_bf_execute}
    ${get_list_id_product}    Get list product id thr API    ${get_list_hh_in_dh_bf_execute}
    ${list_result_tong_dh}    ${result_list_toncuoi}    ${result_list_thanhtien}    ${list_result_giamoi}    Get list order summary - total sale - ending stocks incase discount and newprice    ${order_code}    ${get_list_hh_in_dh_bf_execute}    ${list_ggsp}    ${list_discount_type}
    ${list_result_thanhtien_new}    ${list_result_order_summary_new}    ${list_newprice_new}    Get list total sale - order summary - newprice incase discount and newprice    ${list_product_new}    ${list_nums_new}    ${list_ggsp_new}    ${list_discount_type_new}
    ${list_giatri_quydoi}    Get list gia tri quy doi frm product API    ${get_list_hh_in_dh_bf_execute}
    ${list_giatri_quydoi_new}    Get list gia tri quy doi frm product API    ${list_product_new}
    ${list_result_thanhtien_addrow}      ${list_result_newprice_addrow}   ${list_result_toncuoi}    ${list_result_soluong}   Get list total sale - ending stock - total quantity incase add row product    ${get_list_hh_in_dh_bf_execute}
    ...    ${list_nums_addrow}    ${list_discount_addrow}    ${list_type_discount_addrow}    ${result_list_toncuoi}    ${get_list_nums_in_dh}    ${list_giatri_quydoi}
    ${list_tonkho_new}    Create List
    ${get_list_product_type}    ${list_tonkho_service}    Get list product type and ending stock of service frm API    ${list_product_new}
    ${get_list_toncuoi}   Get list onhand frm API    ${list_product_new}
    : FOR    ${item_product}    ${item_nums}    ${get_ton_bf_execute}    ${get_toncuoi_dv_execute}    ${giatri_quydoi}    ${get_product_type}    IN ZIP    ${list_product_new}    ${list_nums_new}
    ...    ${get_list_toncuoi}    ${list_tonkho_service}    ${list_giatri_quydoi_new}    ${get_list_product_type}
    \    ${result_toncuoi}    Run Keyword If    '${giatri_quydoi}' == '1'    Computation and get list ending stock    ${get_ton_bf_execute}    ${get_toncuoi_dv_execute}
    \    ...    ${item_nums}    ${get_product_type}
    \    ...    ELSE    Computation and get list ending stock for unit product    ${item_product}    ${giatri_quydoi}    ${item_nums}
    \    Append To List    ${list_tonkho_new}    ${result_toncuoi}
    #compute TTH with product
    ${result_tongtienhang}    Sum values in list    ${result_list_thanhtien}
    ${result_tongsoluong}    Sum values in list    ${get_list_nums_in_dh}
    ${result_tongtienhang_new}    Sum values in list    ${list_result_thanhtien_new}
    ${result_tongtienhang_addrow}    Sum values in list    ${list_result_thanhtien_addrow}
    ${result_tongtienhang}    Sum x 3    ${result_tongtienhang}       ${result_tongtienhang_addrow}    ${result_tongtienhang_new}
    ${result_TTH_tru_ggdh}    Run Keyword If    0 < ${input_gghd} < 100    Price after % discount invoice    ${result_tongtienhang}    ${input_gghd}
    ...    ELSE IF    ${input_gghd} > 100    Minus and replace floating point    ${result_tongtienhang}    ${input_gghd}
    ...    ELSE    Set Variable    ${result_tongtienhang}
    ${result_ggdh}    Run Keyword If    0 < ${input_gghd} < 100    Convert % discount to VND and round    ${result_tongtienhang}    ${input_gghd}
    ...    ELSE    Set Variable    ${input_gghd}
    ${tamung}    Minus and replace floating point    ${get_khachdatra_in_dh_bf_execute}    ${result_TTH_tru_ggdh}
    ${result_khtt}    Minus and replace floating point    ${result_TTH_tru_ggdh}    ${get_khachdatra_in_dh_bf_execute}
    ${result_khachcantra}   Set Variable If   ${get_khachdatra_in_dh_bf_execute}>${result_TTH_tru_ggdh}     ${tamung}    ${result_khtt}
    ${actual_khtt_all}    Set Variable If    '${input_khtt}' == 'all'    ${result_khachcantra}    ${input_khtt}
    ${actual_khtt}    Set Variable If    '${input_khtt}' == '0'    0    ${actual_khtt_all}
    ${result_khachthanhtoan_in_dh}    Sum and replace floating point    ${actual_khtt}    ${get_khachdatra_in_dh_bf_execute}
    ${result_khachtamung_in_dh}    Minus    ${get_khachdatra_in_dh_bf_execute}    ${actual_khtt}
    ${actual_khtt_paymented}    Set Variable If   ${get_khachdatra_in_dh_bf_execute}>${result_TTH_tru_ggdh}    ${result_khachtamung_in_dh}    ${result_khachthanhtoan_in_dh}
    ${result_du_no_hd_KH}    Sum    ${get_no_bf_execute}    ${result_TTH_tru_ggdh}
    ${result_PTT_hd_KH1}    Minus and replace floating point    ${result_du_no_hd_KH}    ${actual_khtt}
    ${result_PTT_hd_KH2}    Sum    ${result_du_no_hd_KH}    ${actual_khtt}
    ${result_PTT_hd_KH}   Set Variable If    ${get_khachdatra_in_dh_bf_execute}>${result_TTH_tru_ggdh}    ${result_PTT_hd_KH2}    ${result_PTT_hd_KH1}
    #create invoice from order
    Before Test turning on display mode      ${toggle_item_themdong}
    Go to xu ly dat hang    ${order_code}
    Click Element JS    ${button_taohoadon}
    Delete list product into BH form    ${list_product_del}
    ${laster_nums}    Set Variable    ${result_tongsoluong}
    : FOR    ${item_product}    ${item_ggsp}    ${result_giamoi}   ${discount_type}    IN ZIP    ${get_list_hh_in_dh_bf_execute}    ${list_ggsp}    ${list_result_giamoi}   ${list_discount_type}
    \    Run Keyword If    '${discount_type}' == 'dis'   Wait Until Keyword Succeeds    3 times    5 s   Input % discount for multi product    ${item_product}    ${item_ggsp}    ${result_giamoi}
    \    ...    ELSE IF    '${discount_type}' == 'disvnd'  Wait Until Keyword Succeeds    3 times    5 s    Input VND discount for multi product    ${item_product}    ${item_ggsp}    ${result_giamoi}
    \    ...    ELSE IF    '${discount_type}' == 'changeup' or '${discount_type}' == 'changedown'  Wait Until Keyword Succeeds    3 times    5 s    Input newprice for multi product    ${item_product}   ${item_ggsp}
    \    ...    ELSE    Log    Ignore input
    : FOR    ${item_product_add}    ${item_nums_add}    ${item_ggsp_add}    ${result_giamoi_add}   ${discount_type_add}    IN ZIP    ${list_product_new}    ${list_nums_new}    ${list_ggsp_new}
    ...   ${list_newprice_new}    ${list_discount_type_new}
    \    ${laster_nums}    Wait Until Keyword Succeeds    3 times    5 s    Input product-num in sale form    ${item_product_add}    ${item_nums_add}    ${laster_nums}    ${cell_lastest_number}
    \    Run Keyword If    '${discount_type_add}' == 'dis'   Wait Until Keyword Succeeds    3 times    5 s   Input % discount for multi product    ${item_product_add}    ${item_ggsp_add}    ${result_giamoi_add}
    \    ...    ELSE IF    '${discount_type_add}' == 'disvnd'  Wait Until Keyword Succeeds    3 times    5 s    Input VND discount for multi product    ${item_product_add}    ${item_ggsp_add}    ${result_giamoi_add}
    \    ...    ELSE IF    '${discount_type_add}' == 'changeup' or '${discount_type_add}' == 'changedown'  Wait Until Keyword Succeeds    3 times    5 s    Input newprice for multi product    ${item_product_add}   ${item_ggsp_add}
    \    ...    ELSE    Log    Ignore input
    : FOR    ${item_product1}   ${nums_addrow}    ${item_ggsp_addrow}    ${result_giamoi_addrow}   ${discount_type_addrow}   ${product_id}    IN ZIP    ${get_list_hh_in_dh_bf_execute}
    ...   ${list_nums_addrow}    ${list_discount_addrow}   ${list_result_newprice_addrow}   ${list_type_discount_addrow}   ${get_list_id_product}
    \     ${laster_nums}    Add row product incase multi product in MHBH    ${item_product1}   ${nums_addrow}    ${item_ggsp_addrow}
    \     ...   ${result_giamoi_addrow}   ${discount_type_addrow}   ${product_id}    ${laster_nums}    ${cell_lastest_number}
    Run Keyword If    0 < ${input_gghd} < 100    Input % discount invoice    ${input_gghd}    ${result_ggdh}
    ...    ELSE    Input VND discount invoice    ${input_gghd}
    Run Keyword If    "${input_khtt}" == "all"    Click Element JS    ${button_bh_thanhtoan}    ELSE IF   ${get_khachdatra_in_dh_bf_execute}>${result_TTH_tru_ggdh}
    ...     Input customer payment and deposit refund into BH form    ${input_khtt}     ELSE   Input customer payment into BH form    ${input_khtt}    ${result_khachcantra}
    Wait Until Page Contains Element    ${button_cancel}    2 mins
    Wait Until Keyword Succeeds    3 times    20 s    Click Element JS    ${button_cancel}    #tắt popup kết thúc đơn ĐH\
    Sleep     2s
    ${invoice_code}    Get saved code after execute
    #get value
    Sleep    20s    wait for response to API
    #assert value product in invoice
    : FOR    ${ma_hh}    ${result_toncuoi}    ${item_soluong}    ${get_giatri_quydoi}    IN ZIP    ${get_list_hh_in_dh_bf_execute}    ${list_result_toncuoi}    ${list_result_soluong}    ${list_giatri_quydoi}
    \    Run Keyword If    '${get_giatri_quydoi}' == '1'    Validate product history frm API    ${invoice_code}    ${ma_hh}    ${result_toncuoi}    ${item_soluong}
    \    ...    ELSE    Validate unit product history frm API    ${invoice_code}    ${ma_hh}    ${result_toncuoi}   ${item_soluong}    ${get_giatri_quydoi}
    : FOR    ${ma_hh_new}    ${result_toncuoi_new}    ${item_soluong_new}    ${get_giatri_quydoi_new}    IN ZIP    ${list_product_new}    ${list_tonkho_new}    ${list_nums_new}    ${list_giatri_quydoi}
    \    Run Keyword If    '${get_giatri_quydoi_new}' == '1'    Validate product history frm API    ${invoice_code}    ${ma_hh_new}    ${result_toncuoi_new}    ${item_soluong_new}
    \    ...    ELSE    Validate unit product history frm API    ${invoice_code}    ${ma_hh_new}    ${result_toncuoi_new}    ${item_soluong_new}    ${get_giatri_quydoi_new}
    #validate deleted product
    ${list_order_summary_delete_af_execute}    Get list order summary frm product API    ${list_product_del}
    : FOR    ${result_tong_dh_delete}    ${order_summary_delete_af_execute}    IN ZIP    ${list_result_tongdh_delete}    ${list_order_summary_delete_af_execute}
    \    Should Be Equal As Numbers    ${result_tong_dh_delete}    ${order_summary_delete_af_execute}
    #validate product
    ${list_order_summary_af_execute}    Get list order summary frm product API    ${get_list_hh_in_dh_bf_execute}
    : FOR    ${result_tong_dh}    ${order_summary_af_execute}    IN ZIP    ${list_result_tong_dh}    ${list_order_summary_af_execute}
    \    Should Be Equal As Numbers    ${order_summary_af_execute}    ${result_tong_dh}
    #assert value invoice
    ${get_ma_kh_by_hd}    ${get_tong_tien_hang}    ${get_khachtt_af_execute}    ${get_gghd_af_execute}    ${get_khachcantra}    ${get_trangthai}    ${get_ghichu_in_hd_af_execute}
    ...    Get invoice info have note incase discount by invoice code    ${invoice_code}
    Run Keyword If    ${input_gghd} == 0    Should Be Equal As Numbers    ${get_khachcantra}    ${result_tongtienhang}
    ...    ELSE    Should Be Equal As Numbers    ${get_tong_tien_hang}    ${result_tongtienhang}
    Should Be Equal As Numbers    ${get_khachcantra}    ${result_TTH_tru_ggdh}
    Should Be Equal As Numbers    ${get_khachtt_af_execute}    ${actual_khtt_paymented}
    Should Be Equal As Strings    ${get_ma_kh_by_hd}    ${input_ma_kh}
    Should Be Equal As Numbers    ${get_gghd_af_execute}    ${result_ggdh}
    Should Be Equal As Strings    ${get_trangthai}    Hoàn thành
    Should Be Equal As Strings    ${get_ghichu_in_hd_af_execute}    ${get_ghichu_bf_execute}
    #assert value order
    ${get_ma_kh_in_dh_af_execute}    ${get_TTDH_in_dh_af_execute}    ${get_tongtienhang_in_dh_af_exxecute}    ${get_khachdatra_in_dh_af_execute}    ${get_ghichu_af_execute}    Get order info have note by order code    ${order_code}
    Should Be Equal As Strings    ${get_ma_kh_in_dh_af_execute}    ${input_ma_kh}
    Should Be Equal As Strings    ${get_TTDH_in_dh_af_execute}    2    #trạng thái đang giao hàng
    Should Be Equal As Numbers    ${get_tongtienhang_in_dh_af_exxecute}    ${get_tongtienhang_in_dh_bf_execute}
    Should Be Equal As Numbers    ${get_khachdatra_in_dh_af_execute}    ${actual_khtt_paymented}
    Should Be Equal As Strings    ${get_ghichu_af_execute}    ${get_ghichu_bf_execute}
    Validate invoice history frm Order    ${order_code}    ${invoice_code}    ${result_TTH_tru_ggdh}
    #assert Customer
    ${get_no_af_execute_kh}    ${get_tongban_af_execute_kh}    ${get_tongban_tru_trahang_af_execute_kh}    Get Customer Debt from API after purchase    ${input_ma_kh}    ${invoice_code}    ${actual_khtt}
    Run Keyword If    '${input_khtt}' == '0'    Should Be Equal As Numbers    ${get_no_af_execute_kh}    ${result_du_no_hd_KH}
    ...    ELSE    Should Be Equal As Numbers    ${get_no_af_execute_kh}    ${result_PTT_hd_KH}
    Delete invoice by invoice code    ${invoice_code}
    Delete order frm Order code    ${order_code}

etedh_inv_multirow12
    [Arguments]    ${input_ma_kh}   ${list_product_tocreate}    ${input_khtt_tocreate}   ${dict_product_new}    ${input_gghd}    ${input_khtt}
    Set Selenium Speed    0.5s
    #get info product, customer
    ${list_product_new}    Get Dictionary Keys    ${dict_product_new}
    ${list_nums_new}    Get Dictionary Values    ${dict_product_new}
    ${order_code}    Add new order with multi products    ${input_ma_kh}    ${list_product_tocreate}    ${input_khtt_tocreate}
    ${get_khachdatra_in_dh_bf_execute}    ${get_tongtienhang_in_dh_bf_execute}    Get paid value frm API    ${order_code}
    ${get_list_hh_in_dh_bf_execute}    ${get_ghichu_bf_execute}   Get ghi chu and list product frm API    ${order_code}
    ${get_list_nums_in_dh}    Get list quantity by order code    ${order_code}    ${get_list_hh_in_dh_bf_execute}
    ${get_no_bf_execute}    ${get_tongban_bf_execute}    ${get_tongban_tru_trahang_bf_execute}    Get Customer Debt from API    ${input_ma_kh}
    #get order summary and sub total of products
    ${list_giatri_quydoi_new}    Get list gia tri quy doi frm product API    ${list_product_new}
    ${list_result_thanhtien_new}    Create List
    ${list_result_order_summary_new}    Create List
    ${list_tonkho_new}    Create List
    ${get_list_product_type}    ${list_tonkho_service}    Get list product type and ending stock of service frm API    ${list_product_new}
    ${get_list_toncuoi}   Get list onhand frm API    ${list_product_new}
    ${list_baseprice}    ${list_order_summary}    Get list base price and order summary frm product API    ${list_product_new}
    : FOR    ${item_ma_hh}    ${nums}    ${get_baseprice}    ${get_tong_dh}    ${get_ton_bf_execute}    ${get_toncuoi_dv_execute}    ${giatri_quydoi}    ${get_product_type}    IN ZIP
    ...    ${list_product_new}    ${list_nums_new}    ${list_baseprice}    ${list_order_summary}   ${get_list_toncuoi}    ${list_tonkho_service}    ${list_giatri_quydoi_new}    ${get_list_product_type}
    \    ${result_tongso_dh}    Sum    ${get_tong_dh}    ${nums}
    \    ${result_thanhtien}    Multiplication and round    ${get_baseprice}    ${nums}
    \    ${result_toncuoi}    Run Keyword If    '${giatri_quydoi}' == '1'    Computation and get list ending stock    ${get_ton_bf_execute}    ${get_toncuoi_dv_execute}
    \    ...    ${nums}    ${get_product_type}
    \    ...    ELSE    Computation and get list ending stock for unit product    ${item_ma_hh}    ${giatri_quydoi}    ${nums}
    \    Append To List    ${list_tonkho_new}    ${result_toncuoi}
    \    Append To List    ${list_result_thanhtien_new}    ${result_thanhtien}
    \    Append To List    ${list_result_order_summary_new}    ${result_tongso_dh}
    #####
    ${list_result_thanhtien_addrow}    Create List
    ${list_result_tongso_dh}    Create List
    ${list_result_thanhtien}    Create List
    ${list_result_toncuoi}    Create List
    ${list_result_tongsoluong}    Create List
    ${list_giatri_quydoi}    Get list gia tri quy doi frm product API    ${get_list_hh_in_dh_bf_execute}
    ${get_list_baseprice_addrow}   ${get_list_order_summary_addrow}   Get list base price and order summary frm product API    ${get_list_hh_in_dh_bf_execute}
    ${get_list_product_type_addrow}    ${list_tonkho_service_addrow}    Get list product type and ending stock of service frm API    ${get_list_hh_in_dh_bf_execute}
    :FOR      ${item_soluong}   ${item_giaban}    ${item_tong_dh}   ${get_onhand}   IN ZIP    ${get_list_nums_in_dh}     ${get_list_baseprice_addrow}   ${get_list_order_summary_addrow}    ${list_tonkho_service_addrow}
    \   ${result_tongso_dh}    Minus   ${item_tong_dh}    ${item_soluong}
    \   ${result_thanhtien}    Multiplication and round    ${item_giaban}    ${item_soluong}
    \   ${result_thanhtien_addrow}    Multiplication and round    ${item_giaban}    50
    \   ${result_toncuoi}   Minusx3 and replace foating point   ${get_onhand}    ${item_soluong}    50
    \   ${result_tongsoluong}   Sum   ${item_soluong}    50
    \   Append To List    ${list_result_thanhtien}   ${result_thanhtien}
    \   Append To List    ${list_result_tongso_dh}   ${result_tongso_dh}
    \   Append To List    ${list_result_thanhtien_addrow}   ${result_thanhtien_addrow}
    \   Append To List    ${list_result_toncuoi}   ${result_toncuoi}
    \   Append To List    ${list_result_tongsoluong}   ${result_tongsoluong}
    #compute TTH with product
    ${result_tongtienhang}    Sum values in list    ${list_result_thanhtien}
    ${result_tongsoluong}    Sum values in list    ${get_list_nums_in_dh}
    ${result_tongtienhang_new}    Sum values in list    ${list_result_thanhtien_new}
    ${result_tongtienhang_addrow}    Sum values in list    ${list_result_thanhtien_addrow}
    ${result_tongtienhang}    Sum x 3    ${result_tongtienhang}       ${result_tongtienhang_addrow}    ${result_tongtienhang_new}
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
    ${result_PTT_hd_KH}    Minus and replace floating point    ${result_du_no_hd_KH}    ${actual_khachcantra}
    ${result_tongban_KH}    Sum and replace floating point    ${result_TTH_tru_gghd}    ${get_tongban_bf_execute}
    #create invoice from order
    Before Test turning on display mode      ${toggle_item_themdong}
    Go to xu ly dat hang    ${order_code}
    Click Element JS    ${button_taohoadon}
    ${laster_nums}    Set Variable    ${result_tongsoluong}
    : FOR    ${item_product_add}    ${item_nums_add}    IN ZIP    ${list_product_new}    ${list_nums_new}
    \    ${laster_nums}    Wait Until Keyword Succeeds    3 times    5 s    Input product-num in sale form    ${item_product_add}    ${item_nums_add}    ${laster_nums}    ${cell_lastest_number}
    :FOR    ${product}     IN     @{get_list_hh_in_dh_bf_execute}
    \   ${button_add_row_infirstline}    Format String     ${button_add_row_infirstline}   ${product}
     : FOR    ${item}    IN RANGE    50
     \   Wait Until Element Is Visible    ${button_add_row_infirstline}
     \   Click Element JS    ${button_add_row_infirstline}
     Run Keyword If    0 < ${input_gghd} < 100    Wait Until Keyword Succeeds    3 times    5 s   Input % discount invoice    ${input_gghd}
     ...    ${result_ggdh}    ELSE    Wait Until Keyword Succeeds    3 times    5 s   Input VND discount invoice    ${input_gghd}
    Run Keyword If    "${input_khtt}" == "all"    Click Element JS    ${button_bh_thanhtoan}    ELSE   Input customer payment into BH form    ${input_khtt}    ${result_khachcantra_in_hd}
    Sleep     2s
    ${invoice_code}    Get saved code after execute
    #get value
    Sleep    20s    wait for response to API
    #assert ending stock of product
    : FOR    ${ma_hh}    ${result_toncuoi}    ${item_soluong}    ${get_giatri_quydoi}    IN ZIP    ${get_list_hh_in_dh_bf_execute}    ${list_result_toncuoi}    ${list_result_tongsoluong}    ${list_giatri_quydoi}
    \    Run Keyword If    '${get_giatri_quydoi}' == '1'    Validate product history frm API    ${invoice_code}    ${ma_hh}    ${result_toncuoi}    ${item_soluong}
    \    ...    ELSE    Validate unit product history frm API    ${invoice_code}    ${ma_hh}    ${result_toncuoi}   ${item_soluong}    ${get_giatri_quydoi}
    : FOR    ${ma_hh_new}    ${result_toncuoi_new}    ${item_soluong_new}    ${get_giatri_quydoi_new}    IN ZIP    ${list_product_new}    ${list_tonkho_new}    ${list_nums_new}    ${list_giatri_quydoi_new}
    \    Run Keyword If    '${get_giatri_quydoi_new}' == '1'    Validate product history frm API    ${invoice_code}    ${ma_hh_new}    ${result_toncuoi_new}    ${item_soluong_new}
    \    ...    ELSE    Validate unit product history frm API    ${invoice_code}    ${ma_hh_new}    ${result_toncuoi_new}    ${item_soluong_new}    ${get_giatri_quydoi_new}
    #validate ordersummary of product
    ${list_order_summary_af_execute}    Get list order summary frm product API    ${get_list_hh_in_dh_bf_execute}
    : FOR    ${result_tong_dh}    ${order_summary_af_execute}    IN ZIP    ${list_result_tongso_dh}    ${list_order_summary_af_execute}
    \    Should Be Equal As Numbers    ${order_summary_af_execute}    ${result_tong_dh}
    #assert value invoice
    ${get_ma_kh_by_hd}    ${get_tong_tien_hang}    ${get_khachtt_af_execute}    ${get_gghd_af_execute}    ${get_khachcantra}    ${get_trangthai}    ${get_ghichu_in_hd_af_execute}
    ...    Get invoice info have note incase discount by invoice code    ${invoice_code}
    Run Keyword If    ${input_gghd} == 0    Should Be Equal As Numbers    ${get_khachcantra}    ${result_tongtienhang}
    ...    ELSE    Should Be Equal As Numbers    ${get_tong_tien_hang}    ${result_tongtienhang}
    Run Keyword If    ${input_gghd} == 0    Log    Ignore validate
    ...    ELSE    Should Be Equal As Numbers    ${get_tong_tien_hang}    ${result_tongtienhang}
    Should Be Equal As Numbers    ${get_khachcantra}    ${result_TTH_tru_gghd}
    Should Be Equal As Numbers    ${get_khachtt_af_execute}    ${actual_khtt_in_hd}
    Should Be Equal As Strings    ${get_ma_kh_by_hd}    ${input_ma_kh}
    Should Be Equal As Numbers    ${get_gghd_af_execute}    ${result_gghd}
    Should Be Equal As Strings    ${get_trangthai}    Hoàn thành
    Should Be Equal As Strings    ${get_ghichu_in_hd_af_execute}    ${get_ghichu_bf_execute}
    #assert value order
    ${get_ma_kh_in_dh_af_execute}    ${get_TTDH_in_dh_af_execute}    ${get_tongtienhang_in_dh_af_exxecute}    ${get_khachdatra_in_dh_af_execute}    ${get_ghichu_af_execute}    Get order info have note by order code    ${order_code}
    Should Be Equal As Strings    ${get_ma_kh_in_dh_af_execute}    ${input_ma_kh}
    Should Be Equal As Strings    ${get_TTDH_in_dh_af_execute}    3    #trạng thái hoàn thành
    Should Be Equal As Numbers    ${get_tongtienhang_in_dh_af_exxecute}    ${get_tongtienhang_in_dh_bf_execute}
    Should Be Equal As Numbers    ${get_khachdatra_in_dh_af_execute}    ${result_khachthanhtoan_in_dh}
    Should Be Equal As Strings    ${get_ghichu_af_execute}    ${get_ghichu_bf_execute}
    Validate invoice history frm Order    ${order_code}    ${invoice_code}    ${result_TTH_tru_gghd}
    #assert Customer
    ${get_no_af_execute_kh}    ${get_tongban_af_execute_kh}    ${get_tongban_tru_trahang_af_execute_kh}    Get Customer Debt from API after purchase    ${input_ma_kh}    ${invoice_code}    ${actual_khachcantra}
    Run Keyword If    '${input_khtt}' == '0'    Should Be Equal As Numbers    ${get_no_af_execute_kh}    ${result_du_no_hd_KH}
    ...    ELSE    Should Be Equal As Numbers    ${get_no_af_execute_kh}    ${result_PTT_hd_KH}
    Delete invoice by invoice code    ${invoice_code}
    Delete order frm Order code    ${order_code}
