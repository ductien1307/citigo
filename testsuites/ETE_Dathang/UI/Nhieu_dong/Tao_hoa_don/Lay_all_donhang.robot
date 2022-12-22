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
&{dict_product6}    HH0014=5    SI014=1    DVT12=3    DV014=1.25    Combo13=2
&{dict_product7}    HH0015=5    SI015=1    QDKL013=3    DV015=1.25    Combo14=2
&{dict_product8}    HH0016=5    SI016=2    DVT14=3    DV016=1.25    Combo15=1
&{dict_product9}    HH0017=5    SI017=2    DVT15=1    DV017=1.25    Combo16=1
&{dict_product10}   HH0018=2
@{discount}           14         0     1000     5000    320000
@{discount_type}      dis     none     disvnd    changedown    changeup
@{list_soluong_addrow}   2      1       3.5,2.75     5,3,4        1,2
@{discount_addrow}   590000     3200000.55        15,5000      10,0,50000.1         0,350000
@{discount_type_addrow}  changedown    changeup     dis,disvnd   dis,none,changedown    none,changeup

*** Test Cases ***    Mã KH         List product&nums         List nums add row        List discount type          GGSP add row       List type discount add row      Khách TT
Giam gia              [Tags]    UEDXM
                      [Template]    etedh_inv_multirow4
                      CTKH025       ${list_soluong_addrow}    ${discount_addrow}     ${discount_type_addrow}     ${dict_product6}     ${discount}     ${discount_type}     all      0            0
                      CTKH026       ${list_soluong_addrow}    ${discount_addrow}     ${discount_type_addrow}     ${dict_product7}     ${discount}     ${discount_type}     500000   500000       20

Khong giam gia_GOLIVE              [Tags]    UEDXM    GOLIVE1
                      [Template]    etedh_inv_multirow5
                      CTKH027       ${dict_product8}    all     ${discount}    ${discount_type}    ${list_soluong_addrow}    ${discount_addrow}     ${discount_type_addrow}      30000       0

Khong giam gia              [Tags]    UEDXM
                      [Template]    etedh_inv_multirow5
                      CTKH028       ${dict_product9}    0     ${discount}    ${discount_type}    ${list_soluong_addrow}    ${discount_addrow}     ${discount_type_addrow}      10          1000000

Them_50_dong              [Tags]    UEDXM
                      [Template]    etedh_inv_multirow6
                      CTKH029        ${dict_product10}   all     50000     1000000

*** Keywords ***
etedh_inv_multirow4
    [Arguments]    ${input_ma_kh}    ${list_nums_addrow}   ${list_discount_addrow}   ${list_type_discount_addrow}    ${dict_product_nums}    ${list_ggsp}
    ...    ${list_discount_type}    ${input_khtt}    ${input_khtt_tocreate}    ${input_ggdh}
    [Documentation]    1. Get thông tin của khách hàng và product (dòng 2 -7)
    ...    2. Lấy ra tổng đặt hàng và tồn kho của từng sản phẩm, tính toán
    Set Selenium Speed    0.5s
    #get info product, customer
    ${order_code}    Run Keyword If    '${input_khtt_tocreate}' == '0'    Add new order incase discount - no payment    ${input_ma_kh}    ${input_ggdh}    ${dict_product_nums}
    ...    ${list_ggsp}    ${list_discount_type}    ELSE    Add new order incase discount - payment    ${input_ma_kh}    ${input_ggdh}    ${dict_product_nums}
    ...    ${list_ggsp}    ${list_discount_type}    ${input_khtt_tocreate}
    ${list_nums_addrow}   ${list_discount_addrow}    ${list_type_discount_addrow}   Convert three string list to composite list    ${list_nums_addrow}    ${list_discount_addrow}
    ...    ${list_type_discount_addrow}
    ${order_code}    ${get_khachdatra_in_dh_bf_execute}    ${get_ggdh_in_dh_bf_execute}    ${get_tongtienhang_in_dh_bf_execute}    ${get_tongcong_in_dh_bf_execute}    Get order code - paid - discount value frm API    ${input_ma_kh}
    ${get_list_hh_in_dh_bf_execute}    ${get_ghichu_bf_execute}   Get ghi chu and list product frm API    ${order_code}
    ${get_list_nums_in_dh}    Get list quantity by order code    ${order_code}    ${get_list_hh_in_dh_bf_execute}
    ${get_list_id_product}    ${get_list_status}    Get list imei status and id product thr API    ${get_list_hh_in_dh_bf_execute}
    Create list imei and other product    ${get_list_hh_in_dh_bf_execute}    ${get_list_nums_in_dh}
    ${list_imei_inlist}   Create list imei incase other product have multi row    ${get_list_hh_in_dh_bf_execute}    ${list_nums_addrow}    ${get_list_status}
    ${list_giatri_quydoi}    Get list gia tri quy doi frm product API    ${get_list_hh_in_dh_bf_execute}
    ${get_list_id_product}    ${get_list_status}    Get list imei status and id product thr API    ${get_list_hh_in_dh_bf_execute}
    ${list_result_tongdh}    ${result_list_toncuoi}    ${result_list_thanhtien}    Get list order summary - total sale - ending stocks frm API    ${order_code}    ${get_list_hh_in_dh_bf_execute}
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
    ${result_gghd}    Run Keyword If    0 < ${get_ggdh_in_dh_bf_execute} < 100    Convert % discount to VND and round    ${result_tongtienhang}    ${get_ggdh_in_dh_bf_execute}
    ...    ELSE    Set Variable    ${get_ggdh_in_dh_bf_execute}
    ${result_khachcantra}    Minus and replace floating point    ${result_TTH_tru_ggdh}    ${get_khachdatra_in_dh_bf_execute}
    ${actual_khtt_all}    Set Variable If    '${input_khtt}' == 'all'    ${result_khachcantra}    ${input_khtt}
    ${actual_khtt}    Set Variable If    '${input_khtt}' == '0'    0    ${actual_khtt_all}
    #compute order info
    ${actual_khtt_paymented}    Sum and replace floating point    ${actual_khtt}    ${get_khachdatra_in_dh_bf_execute}
    #create invoice frm Order
    Wait Until Keyword Succeeds    3 times    5s    Before Test turning on display mode      ${toggle_item_themdong}
    Wait Until Keyword Succeeds    3 times    5s    Go to xu ly dat hang    ${order_code}
    Wait Until Keyword Succeeds    3 times    5s    Go to BH frm process order    ${order_code}
    ${laster_nums}    Set Variable    ${result_tongsoluong}
    : FOR    ${item_ma_hh}   ${item_imei}   ${item_status_imei}    IN ZIP    ${get_list_hh_in_dh_bf_execute}    ${imei_inlist}    ${get_list_status}
    \    Run Keyword If    '${item_status_imei}' != '0'    Input imei incase multi product to any form    ${item_ma_hh}    ${texbox_imei_search_multi_product}    ${item_serial_in_dropdown}    ${cell_imei_multi_product}    @{item_imei}
    : FOR    ${item_product1}   ${nums_addrow}    ${item_ggsp_addrow}    ${result_giamoi_addrow}   ${discount_type_addrow}   ${product_id}   ${item_status_imei_addrow}   ${item_imei_addrow}    IN ZIP    ${get_list_hh_in_dh_bf_execute}
    ...   ${list_nums_addrow}    ${list_discount_addrow}   ${list_result_newprice_addrow}   ${list_type_discount_addrow}   ${get_list_id_product}    ${get_list_status}       ${list_imei_inlist}
    \     ${laster_nums}    Run Keyword If    '${item_status_imei_addrow}' == '0'    Add row product incase multi product in MHBH    ${item_product1}   ${nums_addrow}    ${item_ggsp_addrow}
    \     ...   ${result_giamoi_addrow}   ${discount_type_addrow}   ${product_id}    ${laster_nums}    ${cell_lastest_number}
    \    ...  ELSE      Add row product incase imei in MHBH    ${item_product1}    ${nums_addrow}    ${discount_type_addrow}    ${item_ggsp_addrow}
    \    ...    ${result_giamoi_addrow}    ${product_id}    ${laster_nums}    ${cell_lastest_number}   ${item_imei_addrow}
    Run Keyword If    "${input_khtt}" == "all"    Click Element JS    ${button_bh_thanhtoan}    ELSE   Wait Until Keyword Succeeds    3 times    5 s       Input customer payment into BH form    ${input_khtt}    ${result_khachcantra}
    Sleep     2s
    ${invoice_code}    Get saved code after execute
    #assert value onhand
    Assert list of onhand after order process    ${invoice_code}    ${get_list_hh_in_dh_bf_execute}    ${list_result_soluong}    ${list_result_toncuoi}
    #assert value product
    Assert list of order summarry after execute    ${get_list_hh_in_dh_bf_execute}    ${list_result_tongdh}
    #assert value order
    Assert order info after execute    ${input_ma_kh}    2    ${get_tongtienhang_in_dh_bf_execute}    ${actual_khtt_paymented}    ${get_ggdh_in_dh_bf_execute}
    ...    ${get_tongcong_in_dh_bf_execute}   ${get_ghichu_bf_execute}    ${order_code}
    Validate invoice history frm Order    ${order_code}    ${invoice_code}    ${result_TTH_tru_ggdh}
    #assert value invoice
    Assert invoice info after execute    ${invoice_code}    ${input_ma_kh}    ${result_tongtienhang}    ${result_TTH_tru_ggdh}    ${actual_khtt_paymented}    ${result_gghd}
    Delete invoice by invoice code    ${invoice_code}
    Delete order frm Order code    ${order_code}

etedh_inv_multirow5
    [Arguments]    ${input_ma_kh}   ${list_product_tocreate}    ${input_khtt_tocreate}    ${list_ggsp}   ${list_discount_type}    ${list_nums_addrow}
    ...   ${list_discount_addrow}   ${list_type_discount_addrow}    ${input_gghd}    ${input_khtt}
    Set Selenium Speed    0.5s
    #get info product, customer
    ${list_nums_addrow}   ${list_discount_addrow}    ${list_type_discount_addrow}   Convert three string list to composite list    ${list_nums_addrow}    ${list_discount_addrow}
    ...    ${list_type_discount_addrow}
    ${order_code}    Run Keyword If    '${input_khtt_tocreate}' == '0'    Add new order with multi product and no payment - get order code    ${input_ma_kh}    ${list_product_tocreate}
    ...     ELSE    Add new order with multi products    ${input_ma_kh}    ${list_product_tocreate}    ${input_khtt_tocreate}
    ${get_khachdatra_in_dh_bf_execute}    ${get_tongtienhang_in_dh_bf_execute}    Get paid value frm API    ${order_code}
    ${get_list_hh_in_dh_bf_execute}    ${get_ghichu_bf_execute}   Get ghi chu and list product frm API    ${order_code}
    ${get_list_nums_in_dh}    Get list quantity by order code    ${order_code}    ${get_list_hh_in_dh_bf_execute}
    ${get_list_id_product}    ${get_list_status}    Get list imei status and id product thr API    ${get_list_hh_in_dh_bf_execute}
    Create list imei and other product    ${get_list_hh_in_dh_bf_execute}    ${get_list_nums_in_dh}
    ${list_imei_inlist}   Create list imei incase other product have multi row    ${get_list_hh_in_dh_bf_execute}    ${list_nums_addrow}    ${get_list_status}
    ${get_no_bf_execute}    ${get_tongban_bf_execute}    ${get_tongban_tru_trahang_bf_execute}    Get Customer Debt from API    ${input_ma_kh}
    #get order summary and sub total of products
    ${list_result_tong_dh}    ${result_list_toncuoi}    ${result_list_thanhtien}    ${list_result_giamoi}    Get list order summary - total sale - ending stocks incase discount and newprice    ${order_code}    ${get_list_hh_in_dh_bf_execute}    ${list_ggsp}    ${list_discount_type}
    ${list_giatri_quydoi}    Get list gia tri quy doi frm product API    ${get_list_hh_in_dh_bf_execute}
    ${list_result_thanhtien_addrow}      ${list_result_newprice_addrow}   ${list_result_toncuoi}    ${list_result_soluong}   Get list total sale - ending stock - total quantity incase add row product    ${get_list_hh_in_dh_bf_execute}
    ...    ${list_nums_addrow}    ${list_discount_addrow}    ${list_type_discount_addrow}    ${result_list_toncuoi}    ${get_list_nums_in_dh}    ${list_giatri_quydoi}
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
    #create invoice frm Order
    Before Test turning on display mode      ${toggle_item_themdong}
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
    : FOR    ${item_product1}   ${nums_addrow}    ${item_ggsp_addrow}    ${result_giamoi_addrow}   ${discount_type_addrow}   ${product_id}   ${item_status_imei_addrow}   ${item_imei_addrow}    IN ZIP    ${get_list_hh_in_dh_bf_execute}
    ...   ${list_nums_addrow}    ${list_discount_addrow}   ${list_result_newprice_addrow}   ${list_type_discount_addrow}   ${get_list_id_product}    ${get_list_status}       ${list_imei_inlist}
    \     ${laster_nums}    Run Keyword If    '${item_status_imei_addrow}' == '0'    Add row product incase multi product in MHBH    ${item_product1}   ${nums_addrow}    ${item_ggsp_addrow}
    \     ...   ${result_giamoi_addrow}   ${discount_type_addrow}   ${product_id}    ${laster_nums}    ${cell_lastest_number}
    \    ...  ELSE      Add row product incase imei in MHBH    ${item_product1}    ${nums_addrow}    ${discount_type_addrow}    ${item_ggsp_addrow}
    \    ...    ${result_giamoi_addrow}    ${product_id}    ${laster_nums}    ${cell_lastest_number}   ${item_imei_addrow}
    Run Keyword If    0 < ${input_gghd} < 100    Wait Until Keyword Succeeds    3 times    5 s   Input % discount invoice    ${input_gghd}    ${result_gghd}    ELSE    Wait Until Keyword Succeeds    3 times    5 s   Input VND discount invoice    ${input_gghd}
    Run Keyword If    "${input_khtt}" == "all"    Click Element JS    ${button_bh_thanhtoan}    ELSE    Wait Until Keyword Succeeds    3 times    5 s   Input customer payment into BH form    ${input_khtt}    ${result_khachcantra_in_hd}
    Invoice message success validation
    ${invoice_code}    Get saved code after execute
    Sleep    20 s    wait for response to API
    #assert value product in invoice
    : FOR    ${ma_hh}    ${result_toncuoi}    ${item_soluong}    ${get_giatri_quydoi}    IN ZIP    ${get_list_hh_in_dh_bf_execute}    ${list_result_toncuoi}    ${list_result_soluong}    ${list_giatri_quydoi}
    \    Run Keyword If    '${get_giatri_quydoi}' == '1'    Validate product history frm API    ${invoice_code}    ${ma_hh}    ${result_toncuoi}    ${item_soluong}
    \    ...    ELSE    Validate unit product history frm API    ${invoice_code}    ${ma_hh}    ${result_toncuoi}   ${item_soluong}    ${get_giatri_quydoi}
    #validate product
    ${list_order_summary_af_execute}    Get list order summary frm product API    ${get_list_hh_in_dh_bf_execute}
    : FOR    ${result_tong_dh}    ${order_summary_af_execute}    IN ZIP    ${list_result_tongdh}    ${list_order_summary_af_execute}
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

etedh_inv_multirow6
    [Arguments]    ${input_ma_kh}   ${list_product_tocreate}    ${input_khtt_tocreate}    ${input_gghd}    ${input_khtt}
    Set Selenium Speed    0.1s
    #get info product, customer
    ${order_code}    Add new order with multi products    ${input_ma_kh}    ${list_product_tocreate}    ${input_khtt_tocreate}
    ${get_khachdatra_in_dh_bf_execute}    ${get_tongtienhang_in_dh_bf_execute}    Get paid value frm API    ${order_code}
    ${get_list_hh_in_dh_bf_execute}    ${get_ghichu_bf_execute}   Get ghi chu and list product frm API    ${order_code}
    ${get_list_nums_in_dh}    Get list quantity by order code    ${order_code}    ${get_list_hh_in_dh_bf_execute}
    ${get_no_bf_execute}    ${get_tongban_bf_execute}    ${get_tongban_tru_trahang_bf_execute}    Get Customer Debt from API    ${input_ma_kh}
    #get order summary and sub total of products
    ${list_result_thanhtien}    Create List
    ${list_result_tongso_dh}    Create List
    ${list_thanhtien_addrow}    Create List
    ${list_result_toncuoi}    Create List
    ${list_result_tongsoluong}    Create List
    ${get_list_baseprice}   ${get_list_order_summary}   Get list base price and order summary frm product API    ${get_list_hh_in_dh_bf_execute}
    ${get_list_product_type}    ${list_tonkho_service}    Get list product type and ending stock of service frm API    ${get_list_hh_in_dh_bf_execute}
    :FOR      ${item_soluong}   ${item_giaban}    ${item_tong_dh}   ${get_onhand}   IN ZIP    ${get_list_nums_in_dh}     ${get_list_baseprice}   ${get_list_order_summary}    ${list_tonkho_service}
    \   ${result_tongso_dh}    Minus   ${item_tong_dh}    ${item_soluong}
    \   ${result_thanhtien}    Multiplication and round    ${item_giaban}    ${item_soluong}
    \   ${result_thanhtien_addrow}    Multiplication and round    ${item_giaban}    50
    \   ${result_toncuoi}   Minusx3 and replace foating point   ${get_onhand}    ${item_soluong}    50
    \   ${result_tongsoluong}   Sum   ${item_soluong}    50
    \   Append To List    ${list_result_thanhtien}   ${result_thanhtien}
    \   Append To List    ${list_result_tongso_dh}   ${result_tongso_dh}
    \   Append To List    ${list_thanhtien_addrow}   ${result_thanhtien_addrow}
    \   Append To List    ${list_result_toncuoi}   ${result_toncuoi}
    \   Append To List    ${list_result_tongsoluong}   ${result_tongsoluong}
    ${list_giatri_quydoi}    Get list gia tri quy doi frm product API    ${get_list_hh_in_dh_bf_execute}
    #compute TTH with product
    ${result_tongtienhang}    Sum values in list    ${list_result_thanhtien}
    ${result_tongsoluong}    Sum values in list    ${get_list_nums_in_dh}
    ${result_tongtienhang_addrow}    Sum values in list    ${list_thanhtien_addrow}
    ${result_tongtienhang}    Sum and round    ${result_tongtienhang}       ${result_tongtienhang_addrow}
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
    #assert value product in invoice
    : FOR    ${ma_hh}    ${result_toncuoi}    ${item_soluong}    ${get_giatri_quydoi}    IN ZIP    ${get_list_hh_in_dh_bf_execute}    ${list_result_toncuoi}    ${list_result_tongsoluong}    ${list_giatri_quydoi}
    \    Run Keyword If    '${get_giatri_quydoi}' == '1'    Validate product history frm API    ${invoice_code}    ${ma_hh}    ${result_toncuoi}
    \    ...    ${item_soluong}    ELSE    Validate unit product history frm API    ${invoice_code}    ${ma_hh}    ${result_toncuoi}    ${item_soluong}    ${get_giatri_quydoi}
    #validate product
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
