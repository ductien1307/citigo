*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    ${headless_browser}
Test Setup        Before Test Ban Hang
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

*** Variables ***
&{list_product1}    HH0021=4.75    SIL001=1    DVT20=2.5    DVL001=1    CBKH001=1.5
&{list_product2}    HH0022=1       SIL002=2    DVT21=3      DVL002=1.5    CBKH002=2.5
&{list_product3}    HH0023=1       SIL003=2    DVT22=4      DVL003=1.5    CBKH003=1.8
&{list_product4}    HH0024=3.6     SIL004=1    DVT23=2.4    DVL004=2     CBKH004=3
&{list_product_delete}    CBKH002=2.5    DVT21=3
&{list_product_delete1}    SIL003=2
&{list_productadd}       DV013=1.25    Combo12=2
@{list_nums_update}   1     3.5
@{discount}           15   45000.22    0    5000      150000.45
@{discount_type}      dis   changedown    none     disvnd   changeup

*** Test Cases ***    List product&nums    List GGSP      List discount type    GGDH       Khách TT
Create order             [Tags]       UEDNOCUS
                      [Template]    edhkl1
                      ${list_product1}     ${discount}     ${discount_type}     0          all

Update order          [Tags]     UEDNOCUS
                      [Template]    edhkl2
                      ${list_product2}     ${discount}    ${list_nums_update}    ${discount_type}    ${list_product_delete}    ${list_productadd}   10000      100000     Đã đặt cọc     0

Lay 1 phan don hang       [Tags]         UEDNOCUS
                      [Template]    edhkl3
                      ${list_product_delete1}     150000      20        ${list_product3}           ${discount}           ${discount_type}

Lay all phan don hang       [Tags]       UEDNOCUS
                      [Template]    edhkl4
                      ${list_product4}     200000    ${discount}    ${discount_type}    20000        0

*** Keywords ***
edhkl1
    [Arguments]    ${dict_product_nums}   ${list_ggsp}    ${list_discount_type}   ${input_ggdh}    ${input_khtt}
    #get info product, customer
    Set Selenium Speed    0.5s
    ${list_product}    Get Dictionary Keys    ${dict_product_nums}
    ${list_nums}    Get Dictionary Values    ${dict_product_nums}
    ${list_result_thanhtien}    ${list_result_ordersummary}    ${list_result_giamoi}    Get list total sale and order summary incase discount and newprice    ${list_product}    ${list_nums}    ${list_ggsp}    ${list_discount_type}
    #compute
    ${result_tongtienhang}    Sum values in list and round    ${list_result_thanhtien}
    ${result_tongcong}    Run Keyword If    0 < ${input_ggdh} < 100    Price after % discount invoice    ${result_tongtienhang}    ${input_ggdh}
    ...    ELSE IF    ${input_ggdh} > 100    Minus and replace floating point    ${result_tongtienhang}    ${input_ggdh}
    ...    ELSE    Set Variable    ${result_tongtienhang}
    ${result_ggdh}    Run Keyword If    0 < ${input_ggdh} < 100    Convert % discount to VND and round    ${result_tongtienhang}    ${input_ggdh}    ELSE    Set Variable    ${input_ggdh}
    ${result_tongcong}    Replace floating point    ${result_tongcong}
    ${actual_khtt_all}    Set Variable If    '${input_khtt}' == 'all'    ${result_tongcong}    ${input_khtt}
    ${actual_khtt}    Set Variable If    '${input_khtt}' == '0'    0    ${actual_khtt_all}
    #input data into DH form
    Wait Until Keyword Succeeds    3 times    5 s    Click Element JS    ${tab_dathang}
    ${laster_nums}    Set Variable    0
    : FOR    ${item_product}    ${item_nums}    ${item_ggsp}    ${result_giamoi}    ${discount_type}   IN ZIP    ${list_product}    ${list_nums}   ${list_ggsp}  ${list_result_giamoi}   ${list_discount_type}
    \    ${laster_nums}    Wait Until Keyword Succeeds    3 times    5 s    Input product-num in sale form    ${item_product}    ${item_nums}    ${laster_nums}    ${cell_tongsoluong_dh}
    \    Run Keyword If    '${discount_type}' == 'dis'   Wait Until Keyword Succeeds    3 times    5 s   Input % discount for multi product    ${item_product}    ${item_ggsp}    ${result_giamoi}
    \    ...    ELSE IF    '${discount_type}' == 'disvnd'  Wait Until Keyword Succeeds    3 times    5 s    Input VND discount for multi product    ${item_product}    ${item_ggsp}    ${result_giamoi}
    \    ...    ELSE IF    '${discount_type}' == 'changeup' or '${discount_type}' == 'changedown'  Wait Until Keyword Succeeds    3 times    5 s    Input newprice for multi product    ${item_product}   ${item_ggsp}
    \    ...    ELSE    Log    Ignore input
    Wait Until Keyword Succeeds    3 times    5 s    Run keyword if    0 < ${input_ggdh} < 100    Wait Until Keyword Succeeds    3 times    5 s    Input % discount order    ${input_ggdh}    ${result_ggdh}
    ...    ELSE    Wait Until Keyword Succeeds    3 times    5 s    Input VND discount order    ${input_ggdh}
    Run Keyword If    '${input_khtt}' == '0'    Log      Ingore input    ELSE    Wait Until Keyword Succeeds    3 times    5 s    Input payment from customer    ${textbox_dh_khachtt}    ${actual_khtt}    ${result_tongcong}    ${cell_tinhvaocongno_order}
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

edhkl2
    [Arguments]    ${dict_product_nums}   ${list_ggsp}    ${list_quantity_update}    ${list_discount_type}    ${list_product_delete}   ${list_product_addnew}
    ...      ${input_ggdh}    ${input_khtt}    ${input_ghichu}    ${input_khtt_create_order}
    #get info product, customer
    ${list_product_del}    Get Dictionary Keys    ${list_product_delete}
    ${list_nums_del}    Get Dictionary Values    ${list_product_delete}
    ${list_product_add}    Get Dictionary Keys    ${list_product_addnew}
    ${list_nums_add}    Get Dictionary Values    ${list_product_addnew}
    Set Selenium Speed    0.5s
    ${order_code}    Add new order with multi products no customer    ${dict_product_nums}    ${input_khtt_create_order}
    ${get_khachdatra_in_dh_bf_execute}    ${get_tongtienhang_in_dh_bf_execute}    Get paid value frm API    ${order_code}
    ${get_list_hh_in_dh_bf_execute}   ${get_list_sl_in_dh_bf_execute}    Get list product and quantity frm API    ${order_code}
    ${list_result_tongdh_delete}    Get list order summary incase delete product    ${order_code}    ${list_product_del}
    #get order summary and sub total of products
    : FOR    ${ma_hh}   ${number}   IN ZIP     ${list_product_delete}    ${list_nums_del}
    \    Remove Values From List    ${get_list_hh_in_dh_bf_execute}    ${ma_hh}
    \    Remove Values From List    ${get_list_sl_in_dh_bf_execute}    ${number}
    Log    ${get_list_hh_in_dh_bf_execute}
    Log    ${get_list_sl_in_dh_bf_execute}
    ${list_result_thanhtien}    ${list_result_tongdh}    ${list_result_tongdh_add}    ${list_result_giamoi}    ${list_result_giamoi_add}    Get list total sale - order summary incase update quantity and add product    ${order_code}    ${get_list_hh_in_dh_bf_execute}
    ...   ${list_quantity_update}   ${list_ggsp}    ${list_discount_type}    ${list_product_add}    ${list_nums_add}
    #compute
    ${result_tongsoluong}    Sum values in list and round    ${get_list_sl_in_dh_bf_execute}
    ${result_tongtienhang}    Sum values in list and round    ${list_result_thanhtien}
    ${result_ggdh}    Run Keyword If    0 < ${input_ggdh} < 100    Convert % discount to VND and round    ${result_tongtienhang}    ${input_ggdh}
    ...    ELSE    Set Variable    ${input_ggdh}
    ${result_tongcong}    Run Keyword If    0 < ${input_ggdh} < 100    Price after % discount invoice    ${result_tongtienhang}    ${input_ggdh}
    ...    ELSE    Minus and replace floating point    ${result_tongtienhang}    ${input_ggdh}
    ${result_khachcantra}    Minus and replace floating point    ${result_tongcong}    ${get_khachdatra_in_dh_bf_execute}
    ${actual_khtt_all}    Set Variable If    '${input_khtt}' == 'all'    ${result_khachcantra}    ${input_khtt}
    ${actual_khtt}    Set Variable If    '${input_khtt}' == '0'    0    ${actual_khtt_all}
    ${actual_khtt_paymented}    Sum and replace floating point    ${actual_khtt}    ${get_khachdatra_in_dh_bf_execute}
    #delete product into BH form
    Go to xu ly dat hang    ${order_code}
    Delete list product into BH form    ${list_product_del}
    ${laster_nums}    Set Variable    ${result_tongsoluong}
    : FOR    ${item_ma_hh}    ${item_soluong}    ${input_ggsp}   ${discount_type}    ${result_giamoi}    IN ZIP    ${get_list_hh_in_dh_bf_execute}
    ...    ${list_quantity_update}    ${list_ggsp}    ${list_discount_type}    ${list_result_giamoi}
    \    ${laster_nums}    Update quantity into DH form    ${item_ma_hh}    ${item_soluong}    ${laster_nums}
    \    Run Keyword If    '${discount_type}' == 'dis'   Wait Until Keyword Succeeds    3 times    5 s   Input % discount for multi product    ${item_ma_hh}    ${input_ggsp}    ${result_giamoi}
    \    ...    ELSE IF    '${discount_type}' == 'disvnd'  Wait Until Keyword Succeeds    3 times    5 s    Input VND discount for multi product    ${item_ma_hh}    ${input_ggsp}    ${result_giamoi}
    \    ...    ELSE IF    '${discount_type}' == 'changeup' or '${discount_type}' == 'changedown'  Wait Until Keyword Succeeds    3 times    5 s    Input newprice for multi product    ${item_ma_hh}   ${input_ggsp}
    \    ...    ELSE    Log    Ignore input
    : FOR    ${item_product}    ${item_nums}   ${item_ggsp}   ${result_giamoi1}   ${discount_type1}    IN ZIP    ${list_product_add}    ${list_nums_add}   ${list_ggsp}
    ...   ${list_result_giamoi_add}    ${list_discount_type}
    \    ${laster_nums}    Wait Until Keyword Succeeds    3 times    5 s    Input product-num in sale form    ${item_product}    ${item_nums}    ${laster_nums}    ${cell_tongsoluong_dh}
    \    Run Keyword If    '${discount_type1}' == 'dis'   Wait Until Keyword Succeeds    3 times    5 s   Input % discount for multi product    ${item_product}    ${item_ggsp}    ${result_giamoi1}
    \    ...    ELSE IF    '${discount_type1}' == 'disvnd'  Wait Until Keyword Succeeds    3 times    5 s    Input VND discount for multi product    ${item_product}    ${item_ggsp}    ${result_giamoi1}
    \    ...    ELSE IF    '${discount_type1}' == 'changeup' or '${discount_type1}' == 'changedown'  Wait Until Keyword Succeeds    3 times    5 s    Input newprice for multi product    ${item_product}   ${item_ggsp}
    \    ...    ELSE    Log    Ignore input
    Run Keyword If    0 < ${input_ggdh} < 100    Wait Until Keyword Succeeds    3 times    5 s    Input % discount order    ${input_ggdh}    ${result_ggdh}
    ...    ELSE    Wait Until Keyword Succeeds    3 times    5 s    Input VND discount order    ${input_ggdh}
    Input text to Ghi chu field    ${input_ghichu}
    Run Keyword If    '${input_khtt}' == '0'    Log      Ingore input    ELSE    Wait Until Keyword Succeeds    3 times    5 s    Input payment from customer    ${textbox_dh_khachtt}    ${actual_khtt}    ${result_tongcong}    ${cell_tinhvaocongno_order}
    Wait Until Keyword Succeeds    3 times    5 s    Click Element JS    ${button_luu_order}
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
    : FOR    ${result_tong_dh}    ${order_summary_af_execute}    IN ZIP    ${list_result_tongdh}    ${list_order_summary_af_execute}
    \    Should Be Equal As Numbers    ${order_summary_af_execute}    ${result_tong_dh}
    #validate product add
    ${list_order_summary_add_af_execute}    Get list order summary frm product API    ${list_product_add}
    : FOR    ${result_tong_dh}    ${order_summary_af_execute}    IN ZIP    ${list_result_tongdh_add}    ${list_order_summary_add_af_execute}
    \    Should Be Equal As Numbers    ${order_summary_af_execute}    ${result_tong_dh}
    ${get_ma_kh_in_dh_af_execute}    ${get_TTDH_in_dh_af_execute}    ${get_tongtienhang_in_dh_af_exxecute}    ${get_khachdatra_in_dh_af_execute}    ${get_giamgia_in_dh_af_execute}    ${get_tongcong_in_dh_af_execute}    ${get_ghichu_af_execute}    Get order info have note incase discount by order code    ${get_ma_dh}
    Should Be Equal As Strings    ${get_ma_kh_in_dh_af_execute}    0
    Should Be Equal As Numbers    ${get_TTDH_in_dh_af_execute}    1    #1 : phiếu tạm
    Should Be Equal As Numbers    ${get_tongtienhang_in_dh_af_exxecute}    ${result_tongtienhang}
    Should Be Equal As Numbers    ${get_giamgia_in_dh_af_execute}    ${result_ggdh}
    Should Be Equal As Numbers    ${get_tongcong_in_dh_af_execute}    ${result_tongcong}
    Should Be Equal As Numbers    ${get_khachdatra_in_dh_af_execute}    ${actual_khtt_paymented}
    Should Be Equal As Strings    ${get_ghichu_af_execute}    ${input_ghichu}
    Delete order frm Order code    ${get_ma_dh}

edhkl3
    [Arguments]    ${list_product_delete}   ${input_khtt}   ${input_ggdh_tocreate}   ${list_product_tocreate}   ${list_ggsp_tocreate}   ${list_discount_type_tocreate}
    [Documentation]    1. Get thông tin của khách hàng và product (dòng 2 -7)
    ...    2. Lấy ra tổng đặt hàng và tồn kho của từng sản phẩm, tính toán
    Set Selenium Speed    0.5s
    #get info product, customer
    ${order_code}   Add new order incase discount - no payment - no customer   ${input_ggdh_tocreate}   ${list_product_tocreate}   ${list_ggsp_tocreate}   ${list_discount_type_tocreate}
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
    ${get_list_status}    Get list imei status thr API    ${get_list_hh_in_dh_bf_execute}
    Create list imei and other product    ${get_list_hh_in_dh_bf_execute}    ${get_list_nums_in_dh}
    ${list_result_tongdh}    ${result_list_toncuoi}    ${result_list_thanhtien}    Get list order summary - total sale - ending stocks frm API    ${order_code}    ${get_list_hh_in_dh_bf_execute}
    ${list_giatri_quydoi}    Get list gia tri quy doi frm product API    ${get_list_hh_in_dh_bf_execute}
    #compute invoice info
    ${result_tongtienhang}    Sum values in list    ${result_list_thanhtien}
    ${result_tongsoluong}    Sum values in list    ${get_list_nums_in_dh}
    ${result_TTH_tru_ggdh}    Run Keyword If    0 < ${get_ggdh_in_dh_bf_execute} < 100    Price after % discount invoice    ${result_tongtienhang}    ${get_ggdh_in_dh_bf_execute}
    ...    ELSE IF    ${get_ggdh_in_dh_bf_execute} > 100    Minus and replace floating point    ${result_tongtienhang}    ${get_ggdh_in_dh_bf_execute}
    ...    ELSE    Set Variable    ${result_tongtienhang}
    ${result_ggdh}    Run Keyword If    0 < ${get_ggdh_in_dh_bf_execute} < 100    Convert % discount to VND and round    ${result_tongtienhang}    ${get_ggdh_in_dh_bf_execute}
    ...    ELSE    Set Variable    ${get_ggdh_in_dh_bf_execute}
    ${result_khachcantra}    Minus and replace floating point    ${result_TTH_tru_ggdh}    ${get_khachdatra_in_dh_bf_execute}
    ${actual_khtt_all}    Set Variable If    '${input_khtt}' == 'all'    ${result_khachcantra}    ${input_khtt}
    ${actual_khtt}    Set Variable If    '${input_khtt}' == '0'    0    ${actual_khtt_all}
    #compute order info
    ${actual_khtt_paymented}    Sum and replace floating point    ${actual_khtt}    ${get_khachdatra_in_dh_bf_execute}
    #create invoice frm Order
    Go to xu ly dat hang    ${order_code}
    Go to BH frm process order    ${order_code}
    Delete list product into BH form    ${list_product_delete}
    ${laster_nums}    Set Variable    ${result_tongsoluong}
    : FOR    ${item_ma_hh}   ${item_imei}   ${item_status_imei}    IN ZIP    ${get_list_hh_in_dh_bf_execute}    ${imei_inlist}    ${get_list_status}
    \    Run Keyword If    '${item_status_imei}' != '0'    Input imei incase multi product to any form    ${item_ma_hh}    ${texbox_imei_search_multi_product}    ${item_serial_in_dropdown}    ${cell_imei_multi_product}    @{item_imei}
    \    ...    ELSE    Log     Ingore input
    Run Keyword If    "${input_khtt}" == "all"    Click Element JS    ${button_bh_thanhtoan}    ELSE    Input customer payment into BH form    ${input_khtt}    ${result_khachcantra}
    Wait Until Keyword Succeeds    3 times    5 s    Click Element JS    ${button_dongy_popup_nocustomer}
    Wait Until Page Contains Element    ${button_cancel}    2 mins
    Wait Until Keyword Succeeds    3 times    20 s    Click Element JS    ${button_cancel}    #tắt popup kết thúc đơn ĐH
    ${invoice_code}    Get saved code after execute
    Sleep    20 s    wait for response to API
    #assert value product in invoice
    ${get_list_hh_in_hd_af_execute}    Get list product frm Invoice API    ${invoice_code}
    ${list_soluong_in_hd}    ${list_giatri_quydoi_in_hd}    Get list quantity and gia tri quy doi by invoice code    ${get_list_hh_in_hd_af_execute}    ${invoice_code}
    : FOR    ${ma_hh}    ${result_toncuoi}    ${item_soluong}    ${get_giatri_quydoi}    IN ZIP    ${get_list_hh_in_hd_af_execute}    ${result_list_toncuoi}    ${list_soluong_in_hd}   ${list_giatri_quydoi}
    \    Run Keyword If    '${get_giatri_quydoi}' == '1'    Validate product history frm API    ${invoice_code}    ${ma_hh}    ${result_toncuoi}    ${item_soluong}
    \    ...    ELSE    Validate unit product history frm API    ${invoice_code}    ${ma_hh}    ${result_toncuoi}    ${item_soluong}    ${get_giatri_quydoi}
    #validate deleted product
    ${list_order_summary_delete_af_execute}    Get list order summary frm product API    ${list_product_delete}
    : FOR    ${result_tong_dh_delete}    ${order_summary_delete_af_execute}    IN ZIP    ${list_result_tongdh_delete}    ${list_order_summary_delete_af_execute}
    \    Should Be Equal As Numbers    ${result_tong_dh_delete}    ${order_summary_delete_af_execute}
    #validate product
    ${list_order_summary_af_execute}    Get list order summary frm product API    ${get_list_hh_in_hd_af_execute}
    : FOR    ${result_tong_dh}    ${order_summary_af_execute}    IN ZIP    ${list_result_tongdh}    ${list_order_summary_af_execute}
    \    Should Be Equal As Numbers    ${order_summary_af_execute}    ${result_tong_dh}
    #assert value invoice
    ${get_ma_kh_by_hd}    ${get_tong_tien_hang}    ${get_khachtt_af_execute}    ${get_gghd_af_execute}    ${get_khachcantra}    ${get_trangthai}    ${get_ghichu_in_hd_af_execute}
    ...    Get invoice info have note incase discount by invoice code    ${invoice_code}
    Run Keyword If    ${get_ggdh_in_dh_bf_execute} == 0    Should Be Equal As Numbers    ${get_khachcantra}    ${result_tongtienhang}
    ...    ELSE    Should Be Equal As Numbers    ${get_tong_tien_hang}    ${result_tongtienhang}
    Run Keyword If    ${get_ggdh_in_dh_bf_execute} == 0    Log    Ignore validate
    ...    ELSE    Should Be Equal As Numbers    ${get_tong_tien_hang}    ${result_tongtienhang}
    Should Be Equal As Numbers    ${get_khachcantra}    ${result_khachcantra}
    Should Be Equal As Numbers    ${get_khachtt_af_execute}    ${actual_khtt}
    Should Be Equal As Strings    ${get_ma_kh_by_hd}    0
    Should Be Equal As Numbers    ${get_gghd_af_execute}    ${result_ggdh}
    Should Be Equal As Strings    ${get_trangthai}    Hoàn thành
    Should Be Equal As Strings    ${get_ghichu_in_hd_af_execute}    ${get_ghichu_bf_execute}
    #assert value order
    ${get_ma_kh_in_dh_af_execute}    ${get_TTDH_in_dh_af_execute}    ${get_tongtienhang_in_dh_af_exxecute}    ${get_khachdatra_in_dh_af_execute}    ${get_giamgia_in_dh_af_execute}    ${get_tongcong_in_dh_af_execute}    ${get_ghichu_in_dh_af_execute}
    ...    Get order info have note incase discount by order code    ${order_code}
    Should Be Equal As Strings    ${get_ma_kh_in_dh_af_execute}    0
    Should Be Equal As Numbers    ${get_TTDH_in_dh_af_execute}    2    #trạng thái đang giao hàng
    Should Be Equal As Numbers    ${get_tongtienhang_in_dh_af_exxecute}    ${get_tongtienhang_in_dh_bf_execute}
    Should Be Equal As Numbers    ${get_khachdatra_in_dh_af_execute}    ${actual_khtt_paymented}
    Should Be Equal As Numbers    ${get_giamgia_in_dh_af_execute}    ${get_ggdh_in_dh_bf_execute}
    Should Be Equal As Numbers    ${get_tongcong_in_dh_af_execute}    ${get_tongcong_in_dh_bf_execute}
    Should Be Equal As Strings    ${get_ghichu_in_dh_af_execute}    ${get_ghichu_bf_execute}
    Validate invoice history frm Order    ${order_code}    ${invoice_code}    ${result_TTH_tru_ggdh}
    Delete invoice by invoice code    ${invoice_code}
    Delete order frm Order code    ${order_code}

edhkl4
    [Arguments]    ${list_product_tocreate}    ${input_khtt_tocreate}    ${list_ggsp}   ${list_discount_type}   ${input_gghd}    ${input_khtt}
    Set Selenium Speed    0.5s
    #get info product, customer
    ${order_code}    Add new order with multi products no customer    ${list_product_tocreate}    ${input_khtt_tocreate}
    ${get_khachdatra_in_dh_bf_execute}    ${get_tongtienhang_in_dh_bf_execute}    Get paid value frm API    ${order_code}
    ${get_list_hh_in_dh_bf_execute}    ${get_ghichu_bf_execute}   Get ghi chu and list product frm API    ${order_code}
    ${get_list_nums_in_dh}    Get list quantity by order code    ${order_code}    ${get_list_hh_in_dh_bf_execute}
    ${get_list_status}    Get list imei status thr API    ${get_list_hh_in_dh_bf_execute}
    Create list imei and other product    ${get_list_hh_in_dh_bf_execute}    ${get_list_nums_in_dh}
    ${list_result_tong_dh}    ${list_result_toncuoi}    ${result_list_thanhtien}    ${list_result_giamoi}    Get list order summary - total sale - ending stocks incase discount and newprice    ${order_code}    ${get_list_hh_in_dh_bf_execute}    ${list_ggsp}    ${list_discount_type}
    ${list_giatri_quydoi}    Get list gia tri quy doi frm product API    ${get_list_hh_in_dh_bf_execute}
    #compute TTH with product
    ${result_tongtienhang}    Sum values in list    ${result_list_thanhtien}
    ${result_tongsoluong}    Sum values in list    ${get_list_nums_in_dh}
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
    #create invoice frm Order
    Go to xu ly dat hang    ${order_code}
    Go to BH frm process order    ${order_code}
    ${laster_nums}    Set Variable    ${result_tongsoluong}
    : FOR    ${item_ma_hh}   ${item_imei}   ${item_status_imei}    ${item_ggsp}    ${result_giamoi}   ${discount_type}    IN ZIP    ${get_list_hh_in_dh_bf_execute}
    ...    ${imei_inlist}    ${get_list_status}    ${list_ggsp}    ${list_result_giamoi}   ${list_discount_type}
    \    Run Keyword If    '${item_status_imei}' != '0'    Input imei incase multi product to any form    ${item_ma_hh}    ${texbox_imei_search_multi_product}    ${item_serial_in_dropdown}    ${cell_imei_multi_product}    @{item_imei}
    \    Run Keyword If    '${discount_type}' == 'dis'   Wait Until Keyword Succeeds    3 times    5 s   Input % discount for multi product    ${item_ma_hh}    ${item_ggsp}    ${result_giamoi}
    \    ...    ELSE IF    '${discount_type}' == 'disvnd'  Wait Until Keyword Succeeds    3 times    5 s    Input VND discount for multi product    ${item_ma_hh}    ${item_ggsp}    ${result_giamoi}
    \    ...    ELSE IF    '${discount_type}' == 'changeup' or '${discount_type}' == 'changedown'  Wait Until Keyword Succeeds    3 times    5 s    Input newprice for multi product    ${item_ma_hh}   ${item_ggsp}
    \    ...    ELSE    Log    Ignore input
    Run Keyword If    0 < ${input_gghd} < 100    Wait Until Keyword Succeeds    3 times    5 s   Input % discount invoice    ${input_gghd}    ${result_gghd}    ELSE    Wait Until Keyword Succeeds    3 times    5 s   Input VND discount invoice    ${input_gghd}
    Run Keyword If    "${input_khtt}" == "all"    Click Element JS    ${button_bh_thanhtoan}    ELSE    Wait Until Keyword Succeeds    3 times    5 s   Input customer payment into BH form    ${input_khtt}    ${result_khachcantra_in_hd}
    Wait Until Keyword Succeeds    3 times    5 s    Click Element JS    ${button_dongy_popup_nocustomer}
    Sleep    2s
    ${invoice_code}    Get saved code after execute
    Sleep    20 s    wait for response to API
    #assert value product in invoice
    ${get_list_hh_in_hd_af_execute}    Get list product frm Invoice API    ${invoice_code}
    ${list_soluong_in_hd}    ${list_giatri_quydoi_in_hd}    Get list quantity and gia tri quy doi by invoice code    ${get_list_hh_in_hd_af_execute}    ${invoice_code}
    : FOR    ${ma_hh}    ${result_toncuoi}    ${item_soluong}    ${get_giatri_quydoi}    IN ZIP    ${get_list_hh_in_hd_af_execute}    ${list_result_toncuoi}    ${list_soluong_in_hd}    ${list_giatri_quydoi}
    \    Run Keyword If    '${get_giatri_quydoi}' == '1'    Validate product history frm API    ${invoice_code}    ${ma_hh}    ${result_toncuoi}    ${item_soluong}
    \    ...    ELSE    Validate unit product history frm API    ${invoice_code}    ${ma_hh}    ${result_toncuoi}   ${item_soluong}    ${get_giatri_quydoi}
    #validate product
    ${list_order_summary_af_execute}    Get list order summary frm product API    ${get_list_hh_in_hd_af_execute}
    : FOR    ${result_tong_dh}    ${order_summary_af_execute}    IN ZIP    ${list_result_tong_dh}    ${list_order_summary_af_execute}
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
    Should Be Equal As Strings    ${get_ma_kh_by_hd}    0
    Should Be Equal As Numbers    ${get_gghd_af_execute}    ${result_gghd}
    Should Be Equal As Strings    ${get_trangthai}    Hoàn thành
    Should Be Equal As Strings    ${get_ghichu_in_hd_af_execute}    ${get_ghichu_bf_execute}
    #assert value order
    ${get_ma_kh_in_dh_af_execute}    ${get_TTDH_in_dh_af_execute}    ${get_tongtienhang_in_dh_af_exxecute}    ${get_khachdatra_in_dh_af_execute}    ${get_ghichu_af_execute}    Get order info have note by order code    ${order_code}
    Should Be Equal As Strings    ${get_ma_kh_in_dh_af_execute}    0
    Should Be Equal As Strings    ${get_TTDH_in_dh_af_execute}    3    #trạng thái hoàn thành
    Should Be Equal As Numbers    ${get_tongtienhang_in_dh_af_exxecute}    ${get_tongtienhang_in_dh_bf_execute}
    Should Be Equal As Numbers    ${get_khachdatra_in_dh_af_execute}    ${result_khachthanhtoan_in_dh}
    Should Be Equal As Strings    ${get_ghichu_af_execute}    ${get_ghichu_bf_execute}
    Validate invoice history frm Order    ${order_code}    ${invoice_code}    ${result_TTH_tru_gghd}
    Delete invoice by invoice code    ${invoice_code}
    Delete order frm Order code    ${order_code}
