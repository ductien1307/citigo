*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    ${headless_browser}
Test Setup
Test Teardown     After Test
Resource          ../../../../../core/API/api_danhmuc_hanghoa.robot
Resource          ../../../../../core/API/api_dathang.robot
Resource          ../../../../../core/API/api_khachhang.robot
Resource          ../../../../../core/API/api_mhbh_dathang.robot
Resource          ../../../../../core/Dat_Hang/dat_hang_action.robot
Resource          ../../../../../core/Ban_Hang/banhang_action.robot
Resource          ../../../../../core/Dat_Hang/dat_hang_navigation.robot
Resource          ../../../../../core/Dat_Hang/dat_hang_page.robot
Resource          ../../../../../core/share/toast_message.robot
Resource          ../../../../../core/API/api_soquy.robot
Resource          ../../../../../config/env_product/envi.robot
Library           BuiltIn

*** Variables ***
&{dict_product02}    HH0056=2.5    SI039=2    QD126=4    DV063=1.5    Combo40=3
&{dict_product03}    HH0057=2.5    SI040=2    DVT60=1.8    DV064=2    Combo41=3.4
@{list_hh_delete1}    SI039
&{list_hh}        Combo42=2    HH0058=4.5
@{discount}    300000     90000  0     25   5000
@{discount_type}    changedown     changeup    none    dis    disvnd

*** Test Cases ***    Mã KH         List ggsp            List discount type    Hoàn trả tạm ứng    List product delete    List product - nums add    List product to create   Khách thanh toán
Lay 1 phan don hang
                      [Tags]        EDX1       ED
                      [Template]    uetedh_create_inv8
                      CTKH100       ${discount}        ${discount_type}    50000               ${list_hh_delete1}     ${list_hh}             ${dict_product02}            2500000

Lay het don hang      [Tags]        EDX1       ED
                      [Template]    uetedh_create_inv9
                      CTKH101       ${discount}        ${discount_type}    all                 ${list_hh}             ${dict_product03}

*** Keywords ***
uetedh_create_inv8
    [Arguments]    ${input_ma_kh}    ${list_ggsp}    ${list_discount_type}    ${input_hoantratamung}    ${list_product_delete}    ${dict_list_product}
    ...    ${dict_product_nums_tocreate}    ${input_khtt_tocreate}
    Set Selenium Speed    0.5s
    ${order_code}    Add new order with multi products    ${input_ma_kh}    ${dict_product_nums_tocreate}    ${input_khtt_tocreate}
    ${list_product_new}    Get Dictionary Keys    ${dict_list_product}
    ${list_nums_new}    Get Dictionary Values    ${dict_list_product}
    ${get_khachdatra_in_dh_bf_execute}    ${get_tongtienhang_in_dh_bf_execute}    Get paid value frm API    ${order_code}
    ${get_list_hh_in_dh_bf_execute}    ${get_ghichu_bf_execute}    Get ghi chu and list product frm API    ${order_code}
    #create imei
    ${list_result_tongdh_delete}    Get list order summary frm product API    ${list_product_delete}
    #get order summary and sub total of products
    : FOR    ${ma_hh_delete}    IN    @{list_product_delete}
    \    Remove Values From List    ${get_list_hh_in_dh_bf_execute}    ${ma_hh_delete}
    Log    ${get_list_hh_in_dh_bf_execute}
    ${get_list_sl_in_dh}    Get list quantity by order code    ${order_code}     ${get_list_hh_in_dh_bf_execute}
    ${list_result_tongdh}    ${result_list_toncuoi}    ${result_list_thanhtien}    ${list_result_giamoi}   Get list order summary - total sale - ending stocks incase discount and newprice    ${order_code}    ${get_list_hh_in_dh_bf_execute}
    ...    ${list_ggsp}   ${list_discount_type}
    ${list_result_tongdh_new}    ${result_list_toncuoi_new}    ${result_list_thanhtien_new}    ${list_result_giamoi_new}    Get list order summary - total sale - onhand incase discount by product list    ${list_product_new}    ${list_nums_new}
    ...    ${list_ggsp}   ${list_discount_type}
    ${list_result_tongdh_new}    ${result_list_toncuoi_new}    Reverse two lists    ${list_result_tongdh_new}    ${result_list_toncuoi_new}
    : FOR    ${result_tongdh}    ${result_toncuoi}    ${result_thanhtien}    IN ZIP    ${list_result_tongdh}    ${result_list_toncuoi}
    ...    ${result_list_thanhtien}
    \    Append To List    ${list_result_tongdh_new}    ${result_tongdh}
    \    Append To List    ${result_list_toncuoi_new}    ${result_toncuoi}
    \    Append To List    ${result_list_thanhtien_new}    ${result_thanhtien}
    Log    ${list_result_tongdh_new}
    Log    ${result_list_toncuoi_new}
    #compute TTH with product
    ${result_tongsoluong}    Sum values in list    ${get_list_sl_in_dh}
    ${result_tongtienhang}    Sum values in list    ${result_list_thanhtien_new}
    ${tamung}    Minus and replace floating point    ${get_khachdatra_in_dh_bf_execute}    ${result_tongtienhang}
    ${result_tamung}    Set Variable If    '${input_hoantratamung}' == 'all'    ${tamung}    ${input_hoantratamung}
    ${result_khachdatra_in_dh}    Minus    ${get_khachdatra_in_dh_bf_execute}    ${result_tamung}
    #create invoice from order
    Wait Until Keyword Succeeds    3 times    20 s    Wait Until Keyword Succeeds    3 times    20 s    Before Test Ban Hang
    Go to xu ly dat hang    ${order_code}
    Go to BH frm process order    ${order_code}
    Delete list product into BH form    ${list_product_delete}
    ${lastest_num}    Set Variable    ${result_tongsoluong}
    : FOR    ${item_ma_hh}    ${input_ggsp}    ${newprice}    ${item_discount_type}    IN ZIP    ${get_list_hh_in_dh_bf_execute}    ${list_ggsp}
    ...    ${list_result_giamoi}    ${list_discount_type}
    \    Run keyword if    '${item_discount_type}' == 'dis'     Wait Until Keyword Succeeds    3 times    5 s    Input % discount for multi product    ${item_ma_hh}    ${input_ggsp}
    \    ...    ${newprice}    ELSE IF    '${item_discount_type}' == 'disvnd'     Wait Until Keyword Succeeds    3 times    5s    Input VND discount for multi product    ${item_ma_hh}    ${input_ggsp}    ${newprice}
    \    ...     ELSE IF  '${item_discount_type}' == 'changeup' or '${item_discount_type}' == 'changedown'    Wait Until Keyword Succeeds    3 times    5 s    Input newprice for multi product    ${item_ma_hh}    ${input_ggsp}
    \    ...    ELSE    Log    Ignore input
    : FOR    ${item_product}    ${item_nums}    ${item_ggsp}    ${item_price}    ${item_discount_type}   IN ZIP    ${list_product_new}
    ...    ${list_nums_new}    ${list_ggsp}    ${list_result_giamoi_new}    ${list_discount_type}
    \    ${lastest_num}    Wait Until Keyword Succeeds    3 times    5 s    Input product-num in sale form    ${item_product}    ${item_nums}
    \    ...    ${lastest_num}    ${cell_lastest_number}
    \    Run keyword if    '${item_discount_type}' == 'dis'     Wait Until Keyword Succeeds    3 times    5 s    Input % discount for multi product    ${item_product}    ${item_ggsp}
    \    ...    ${item_price}    ELSE IF    '${item_discount_type}' == 'disvnd'     Wait Until Keyword Succeeds    3 times    5 s    Input VND discount for multi product    ${item_product}    ${item_ggsp}    ${item_price}
    \    ...     ELSE IF  '${item_discount_type}' == 'changeup' or '${item_discount_type}' == 'changedown'    Wait Until Keyword Succeeds    3 times    5 s    Input newprice for multi product    ${item_product}    ${item_ggsp}
    \    ...    ELSE    Log    Ignore input
    Input customer payment and deposit refund into BH form    ${input_hoantratamung}
    Wait Until Page Contains Element    ${button_cancel}    2 mins
    Wait Until Keyword Succeeds    3 times    20 s    Click Element JS    ${button_cancel}    #tắt popup kết thúc đơn ĐH
    Sleep     2s
    ${invoice_code}    Wait Until Keyword Succeeds    3 times    8 s    Get saved code after execute
    #get value
    Sleep    20s    wait for response to API
    #assert value product in invoice
    ${get_list_hh_in_hd_af_execute}    Get list product frm Invoice API    ${invoice_code}
    ${list_soluong_in_hd}    ${list_giatri_quydoi_in_hd}    Get list quantity and gia tri quy doi by invoice code    ${get_list_hh_in_hd_af_execute}    ${invoice_code}
    : FOR    ${ma_hh}    ${result_toncuoi}    ${item_soluong}    ${get_giatri_quydoi}    IN ZIP    ${get_list_hh_in_hd_af_execute}
    ...    ${result_list_toncuoi_new}    ${list_soluong_in_hd}    ${list_giatri_quydoi_in_hd}
    \    Run Keyword If    '${get_giatri_quydoi}' == '1'    Validate product history frm API    ${invoice_code}    ${ma_hh}    ${result_toncuoi}
    \    ...    ${item_soluong}
    \    ...    ELSE    Validate unit product history frm API    ${invoice_code}    ${ma_hh}    ${result_toncuoi}
    \    ...    ${item_soluong}    ${get_giatri_quydoi}
    #validate deleted product
    ${list_order_summary_delete_af_execute}    Get list order summary frm product API    ${list_product_delete}
    : FOR    ${result_tong_dh_delete}    ${order_summary_delete_af_execute}    IN ZIP    ${list_result_tongdh_delete}    ${list_order_summary_delete_af_execute}
    \    Should Be Equal As Numbers    ${result_tong_dh_delete}    ${order_summary_delete_af_execute}
    #validate product
    ${list_order_summary_af_execute}    Get list order summary frm product API    ${get_list_hh_in_hd_af_execute}
    : FOR    ${result_tong_dh}    ${order_summary_af_execute}    IN ZIP    ${list_result_tongdh_new}    ${list_order_summary_af_execute}
    \    Should Be Equal As Numbers    ${order_summary_af_execute}    ${result_tong_dh}
    #assert value invoice
    ${get_ma_kh_by_hd}    ${get_tong_tien_hang}    ${get_khach_tt}    ${get_trangthai}    ${get_ghichu_in_hd_af_execute}    Get invoice info have note by invoice code    ${invoice_code}
    Should Be Equal As Numbers    ${get_tong_tien_hang}    ${result_tongtienhang}
    Should Be Equal As Numbers    ${get_khach_tt}    ${result_tongtienhang}
    Should Be Equal As Strings    ${get_ma_kh_by_hd}    ${input_ma_kh}
    Should Be Equal As Strings    ${get_trangthai}    Hoàn thành
    Should Be Equal As Strings    ${get_ghichu_in_hd_af_execute}    ${get_ghichu_bf_execute}
    #assert value order
    ${get_ma_kh_in_dh_af_execute}    ${get_TTDH_in_dh_af_execute}    ${get_tongtienhang_in_dh_af_exxecute}    ${get_khachdatra_in_dh_af_execute}    ${get_ghichu_af_execute}    Get order info have note by order code    ${order_code}
    Should Be Equal As Strings    ${get_ma_kh_in_dh_af_execute}    ${input_ma_kh}
    Should Be Equal As Strings    ${get_TTDH_in_dh_af_execute}    2    #trạng thái đang giao hàng
    Should Be Equal As Numbers    ${get_tongtienhang_in_dh_af_exxecute}    ${get_tongtienhang_in_dh_bf_execute}
    Should Be Equal As Numbers    ${get_khachdatra_in_dh_af_execute}    ${result_khachdatra_in_dh}
    Should Be Equal As Strings    ${get_ghichu_af_execute}    ${get_ghichu_bf_execute}
    Validate invoice history frm Order    ${order_code}    ${invoice_code}    ${result_tongtienhang}
    Delete invoice by invoice code    ${invoice_code}
    Delete order frm Order code    ${order_code}

uetedh_create_inv9
    [Arguments]    ${input_ma_kh}    ${list_ggsp}    ${list_discount_type}    ${input_khtt}    ${dict_list_product_new}    ${dict_product_nums_create}
    Set Selenium Speed    0.5s
    ${order_code}    Add new order with multi product and no payment - get order code    ${input_ma_kh}    ${dict_product_nums_create}
    ${list_product_new}    Get Dictionary Keys    ${dict_list_product_new}
    ${list_nums_new}    Get Dictionary Values    ${dict_list_product_new}
    ${get_khachdatra_in_dh_bf_execute}    ${get_tongtienhang_in_dh_bf_execute}    Get paid value frm API    ${order_code}
    ${get_list_hh_in_dh_bf_execute}    ${get_ghichu_bf_execute}    Get ghi chu and list product frm API    ${order_code}
    ${get_list_nums_in_dh}    Get list quantity by order code    ${order_code}    ${get_list_hh_in_dh_bf_execute}
    #create imei
    Create list imei and other product    ${get_list_hh_in_dh_bf_execute}    ${get_list_nums_in_dh}
    ${get_list_status_imei}   Get list imei status thr API    ${get_list_hh_in_dh_bf_execute}
    #get order summary and sub total of products new
    ${list_result_tongdh}    ${result_list_toncuoi}    ${result_list_thanhtien}    ${list_result_giamoi}   Get list order summary - total sale - ending stocks incase discount and newprice    ${order_code}    ${get_list_hh_in_dh_bf_execute}
    ...    ${list_ggsp}   ${list_discount_type}
    ${list_result_tongdh_new}    ${result_list_toncuoi_new}    ${result_list_thanhtien_new}    ${list_result_giamoi_new}    Get list order summary - total sale - onhand incase discount by product list    ${list_product_new}    ${list_nums_new}
    ...    ${list_ggsp}   ${list_discount_type}
    ${list_result_tongdh_new}    ${result_list_toncuoi_new}    Reverse two lists    ${list_result_tongdh_new}    ${result_list_toncuoi_new}
    : FOR    ${result_tongdh}    ${result_toncuoi}    ${result_thanhtien}    IN ZIP    ${list_result_tongdh}    ${result_list_toncuoi}
    ...    ${result_list_thanhtien}
    \    Append To List    ${list_result_tongdh_new}    ${result_tongdh}
    \    Append To List    ${result_list_toncuoi_new}    ${result_toncuoi}
    \    Append To List    ${result_list_thanhtien_new}    ${result_thanhtien}
    Log    ${list_result_tongdh_new}
    Log    ${result_list_toncuoi_new}
    #compute for invoice, order
    ${result_tongsoluong}    Sum values in list    ${get_list_nums_in_dh}
    ${result_tongtienhang}    Sum values in list    ${result_list_thanhtien_new}
    ${result_khachcantra_in_hd}    Minus and replace floating point    ${result_tongtienhang}    ${get_khachdatra_in_dh_bf_execute}
    ${result_khdatra_in_hd}    Sum and replace floating point    ${result_khachcantra_in_hd}    ${get_khachdatra_in_dh_bf_execute}
    ${actual_khtt_all}    Set Variable If    '${input_khtt}' == 'all'    ${result_khachcantra_in_hd}    ${input_khtt}
    ${actual_khtt}    Set Variable If    '${input_khtt}' == '0'    0    ${actual_khtt_all}
    #compute for order
    ${result_khachthanhtoan_in_dh}    Sum and replace floating point    ${get_khachdatra_in_dh_bf_execute}    ${actual_khtt}
    #create invoice from order
    Wait Until Keyword Succeeds    3 times    20 s    Before Test Ban Hang
    Go to xu ly dat hang    ${order_code}
    Go to BH frm process order    ${order_code}
    : FOR    ${item_product}    ${status_imei}    ${item_imei}    ${item_ggsp}    ${item_price}   ${item_discount_type}    IN ZIP    ${get_list_hh_in_dh_bf_execute}   ${get_list_status_imei}    ${imei_inlist}
    ...         ${list_ggsp}    ${list_result_giamoi}    ${list_discount_type}
    \    Run Keyword If    '${status_imei}' == 'True'    Wait Until Keyword Succeeds    3 times    8 s    Input imei incase multi product to any form    ${item_product}    ${texbox_imei_search_multi_product}
    \    ...    ${item_serial_in_dropdown}    ${cell_imei_multi_product}    @{item_imei}    ELSE      Log     Ignore input
    \    Run keyword if    '${item_discount_type}' == 'dis'     Wait Until Keyword Succeeds    3 times    5 s    Input % discount for multi product    ${item_product}    ${item_ggsp}
    \    ...    ${item_price}    ELSE IF    '${item_discount_type}' == 'disvnd'    Input VND discount for multi product    ${item_product}    ${item_ggsp}    ${item_price}
    \    ...     ELSE IF  '${item_discount_type}' == 'changeup' or '${item_discount_type}' == 'changedown'    Wait Until Keyword Succeeds    3 times    5 s    Input newprice for multi product    ${item_product}    ${item_ggsp}
    \    ...    ELSE    Log    Ignore input
    ${lastest_num}    Set Variable    ${result_tongsoluong}
    : FOR    ${item_product_new}    ${item_nums}    ${input_ggsp}    ${newprice}    ${input_discount_type}   IN ZIP    ${list_product_new}
    ...    ${list_nums_new}    ${list_ggsp}    ${list_result_giamoi_new}    ${list_discount_type}
    \    ${lastest_num}    Wait Until Keyword Succeeds    3 times    5 s    Input product-num in sale form    ${item_product_new}    ${item_nums}
    \    ...    ${lastest_num}    ${cell_lastest_number}
    \    Run keyword if    '${input_discount_type}' == 'dis'     Wait Until Keyword Succeeds    3 times    5 s    Input % discount for multi product    ${item_product_new}    ${input_ggsp}
    \    ...    ${newprice}    ELSE IF    '${input_discount_type}' == 'disvnd'    Input VND discount for multi product    ${item_product_new}    ${input_ggsp}    ${newprice}
    \    ...     ELSE IF  '${input_discount_type}' == 'changeup' or '${input_discount_type}' == 'changedown'    Wait Until Keyword Succeeds    3 times    5 s    Input newprice for multi product    ${item_product_new}    ${input_ggsp}
    \    ...    ELSE    Log    Ignore input
    Wait Until Keyword Succeeds    3 times    20 s    Click Element JS    ${button_bh_thanhtoan}
    Sleep     2s
    ${invoice_code}    Wait Until Keyword Succeeds    3 times    8 s    Get saved code after execute
    #get value
    Sleep    20s    wait for response to API
    #assert value product in invoice
    ${get_list_hh_in_hd_af_execute}    Get list product frm Invoice API    ${invoice_code}
    ${list_soluong_in_hd}    ${list_giatri_quydoi_in_hd}    Get list quantity and gia tri quy doi by invoice code    ${get_list_hh_in_hd_af_execute}    ${invoice_code}
    : FOR    ${ma_hh}    ${result_toncuoi}    ${item_soluong}    ${get_giatri_quydoi}    IN ZIP    ${get_list_hh_in_hd_af_execute}
    ...    ${result_list_toncuoi_new}    ${list_soluong_in_hd}    ${list_giatri_quydoi_in_hd}
    \    Run Keyword If    '${get_giatri_quydoi}' == '1'    Validate product history frm API    ${invoice_code}    ${ma_hh}    ${result_toncuoi}
    \    ...    ${item_soluong}
    \    ...    ELSE    Validate unit product history frm API    ${invoice_code}    ${ma_hh}    ${result_toncuoi}
    \    ...    ${item_soluong}    ${get_giatri_quydoi}
    #validate product
    ${list_order_summary_af_execute}    Get list order summary frm product API    ${get_list_hh_in_hd_af_execute}
    : FOR    ${result_tong_dh}    ${order_summary_af_execute}    IN ZIP    ${list_result_tongdh_new}    ${list_order_summary_af_execute}
    \    Should Be Equal As Numbers    ${order_summary_af_execute}    ${result_tong_dh}
    #assert value invoice
    ${get_ma_kh_by_hd}    ${get_tong_tien_hang}    ${get_khach_tt}    ${get_trangthai}    ${get_ghichu_in_hd_af_execute}    Get invoice info have note by invoice code    ${invoice_code}
    Should Be Equal As Numbers    ${get_tong_tien_hang}    ${result_tongtienhang}
    Should Be Equal As Numbers    ${get_khach_tt}    ${actual_khtt}
    Should Be Equal As Strings    ${get_ma_kh_by_hd}    ${input_ma_kh}
    Should Be Equal As Strings    ${get_trangthai}    Hoàn thành
    Should Be Equal As Strings    ${get_ghichu_in_hd_af_execute}    ${get_ghichu_bf_execute}
    #assert value order
    ${get_ma_kh_in_dh_af_execute}    ${get_TTDH_in_dh_af_execute}    ${get_tongtienhang_in_dh_af_exxecute}    ${get_khachdatra_in_dh_af_execute}    ${get_ghichu_af_execute}    Get order info have note by order code    ${order_code}
    Should Be Equal As Strings    ${get_ma_kh_in_dh_af_execute}    ${input_ma_kh}
    Should Be Equal As Strings    ${get_TTDH_in_dh_af_execute}    3    #trạng thái hoàn thành
    Should Be Equal As Numbers    ${get_tongtienhang_in_dh_af_exxecute}    ${get_tongtienhang_in_dh_bf_execute}
    Should Be Equal As Numbers    ${get_khachdatra_in_dh_af_execute}    ${result_khachthanhtoan_in_dh}
    Should Be Equal As Strings    ${get_ghichu_af_execute}    ${get_ghichu_bf_execute}
    Validate invoice history frm Order    ${order_code}    ${invoice_code}    ${result_tongtienhang}
    Delete invoice by invoice code    ${invoice_code}
    Delete order frm Order code    ${order_code}
