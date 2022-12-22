*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    ${headless_browser}
Test Setup        Before Test Ban Hang
Test Teardown     After Test
Library           Collections
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
&{dict_product1}    HH0035=1    HH0036=1
&{dict_product_delete}  HH0036=1
&{dict_promo_nor1}    HKM001=2    HKM002=2
&{dict_promo_change}    HKM001=2
&{dict_promo_nor2}    HKM002=4
&{list_product2}    DVT34=3.5
@{list_no_discount}    0
*** Test Cases ***    List product nums    GGDH              Mã KH      KTT    Mã khuyến mãi    List product          List GGSP              Khách thanh toán to create order    List product add
KM HH hinh thuc mua hang GG hang
                      [Tags]               UKMDH4
                      [Template]           edxhh01
                      ${dict_product1}     1000             KHKM07    5000     KM06            ${dict_promo_nor1}    ${list_no_discount}    300000        ${dict_product_delete}         #mua hang gg hang vnd

KM HH hinh thuc mua hang tang hang
                      [Tags]               UKMDH4
                      [Template]           edxhh02
                      ${dict_product1}     0             KHKM08    0        KM08            ${dict_promo_nor2}    0      #mua hang gg hang tang hang

KM HH hinh thuc gia ban theo SL mua
                      [Documentation]      San pham KM la SP dich vu\nCase khong validate ton kho cua SP KM
                      [Tags]               UKMDH4
                      [Template]           edxhh03
                      ${list_product2}     10            KHKM09    0           KM11            10000                ${dict_product_delete}       ${list_no_discount}                 #giam gia san pham theo so luong mua %

*** Keywords ***
edxhh01
    [Arguments]    ${dict_product_num}    ${input_discount_inv}    ${input_ma_kh}    ${input_hoantratamung}    ${input_khuyemmai}    ${dict_promo_product}
    ...    ${list_ggsp}    ${input_khtt_create_order}    ${dict_product_del}
    [Timeout]
    ## Get info ton cuoi, cong no khach hang
    Toggle status of promotion    ${input_khuyemmai}    1
    ${order_code}    Add new order with promotion buy product and get other product discount    ${input_ma_kh}    ${dict_product_num}    ${input_khuyemmai}    ${dict_promo_product}    ${input_khtt_create_order}
    ${num_sale_product}    ${num_promo_product}    ${product_price}    ${discount}    ${discount_ratio}    ${name}    Get Number of sale product - promo product - promo value and name
    ...    ${input_khuyemmai}
    ${list_product_del}    Get Dictionary Keys    ${dict_product_del}
    ${list_nums_del}    Get Dictionary Values    ${dict_product_del}
    ${get_no_bf_execute}    ${get_tongban_bf_execute}    ${get_tongban_tru_trahang_bf_execute}    ${get_customer_name}    Get Customer Info from API    ${input_ma_kh}
    ${get_khachdatra_in_dh_bf_execute}    ${get_tongtienhang_in_dh_bf_execute}    Get paid value frm API    ${order_code}
    ${get_list_hh_in_dh_bf_execute}    ${get_ghichu_bf_execute}   Get ghi chu and list product frm API    ${order_code}
    ${get_list_nums_in_dh}    Get list quantity by order code    ${order_code}    ${get_list_hh_in_dh_bf_execute}
    ${list_order_summary_bf_execute}    Get list order summary by order code    ${order_code}
    ${list_result_order_summary_del}    Get list order summary frm product API    ${list_product_del}
    Remove From List    ${list_order_summary_bf_execute}   -1
    :FOR    ${item_product}     ${item_nums}    IN ZIP    ${list_product_del}    ${list_nums_del}
    \    Remove Values From List   ${get_list_hh_in_dh_bf_execute}    ${item_product}
    \    Remove Values From List    ${get_list_nums_in_dh}    ${item_nums}
    ${get_ma_dh_in_dh_bf_execute}    ${get_khachdatra_in_dh_bf_execute}    ${get_ggdh_in_dh_bf_execute}    ${get_tongtienhang_in_dh_bf_execute}    ${get_tongcong_in_dh_bf_execute}    Get order code - paid - discount value frm API    ${input_ma_kh}
    ${list_result_order_summary}    ${result_list_toncuoi}    ${result_list_thanhtien}    Get list order summary - total sale - ending stocks frm API    ${order_code}    ${get_list_hh_in_dh_bf_execute}
    #Compute
    ${result_tongtienhang}    Sum values in list    ${result_list_thanhtien}
    ${result_khachcantra}    Minus and replace floating point    ${result_tongtienhang}    ${input_discount_inv}
    ${tamung}    Minus and replace floating point    ${get_khachdatra_in_dh_bf_execute}    ${result_khachcantra}
    ${result_tamung}    Set Variable If    '${input_hoantratamung}' == 'all'    ${tamung}    ${input_hoantratamung}
    ${result_khachdatra_in_dh}    Minus and replace floating point    ${get_khachdatra_in_dh_bf_execute}    ${result_tamung}
    #compute Customer
    ${result_du_no_hd_KH}    Sum    ${get_no_bf_execute}    ${result_khachcantra}
    ${result_PTT_hd_KH}    Sum    ${result_du_no_hd_KH}    ${result_tamung}
    ${result_tongban_KH}    Sum and replace floating point    ${result_khachcantra}    ${get_tongban_bf_execute}
    #create invoice
    Go to xu ly dat hang    ${order_code}
    Go to BH frm process order    ${order_code}
    Delete list product into BH form    ${list_product_del}
    Wait Until Keyword Succeeds    3 times    8 s    Input VND discount invoice    ${input_discount_inv}
    Run Keyword If    '${input_hoantratamung}' == 'all'    Click Element JS    ${button_bh_thanhtoan}
    ...    ELSE    Input customer payment and deposit refund into BH form    ${result_tamung}
    Wait Until Page Contains Element    ${button_cancel}    2 mins
    Wait Until Keyword Succeeds    3 times    20 s    Click Element JS    ${button_cancel}    #tắt popup kết thúc đơn ĐH
    ${invoice_code}    Get saved code after execute
    #get values
    Sleep    20 s    wait for response to API
    #assert value product in invoice
    ${get_list_hh_in_hd_af_execute}    Get list product frm Invoice API    ${invoice_code}
    ${list_soluong_in_hd}    ${list_giatri_quydoi_in_hd}    Get list quantity and gia tri quy doi by invoice code    ${get_list_hh_in_hd_af_execute}    ${invoice_code}
    : FOR    ${ma_hh}    ${result_toncuoi}    ${item_soluong}    ${get_giatri_quydoi}    IN ZIP    ${get_list_hh_in_hd_af_execute}
    ...    ${result_list_toncuoi}    ${list_soluong_in_hd}    ${list_giatri_quydoi_in_hd}
    \    Run Keyword If    '${get_giatri_quydoi}' == '1'    Validate product history frm API    ${invoice_code}    ${ma_hh}    ${result_toncuoi}
    \    ...    ${item_soluong}
    \    ...    ELSE    Validate unit product history frm API    ${invoice_code}    ${ma_hh}    ${result_toncuoi}
    \    ...    ${item_soluong}    ${get_giatri_quydoi}
    #assert value product
    ${list_order_summary_af_execute}    Get list order summary frm product API    ${get_list_hh_in_dh_bf_execute}
    : FOR    ${result_tong_dh}    ${order_summary_af_execute}    IN ZIP    ${list_result_order_summary}    ${list_order_summary_af_execute}
    \    Should Be Equal As Numbers    ${order_summary_af_execute}    ${result_tong_dh}
    ${list_order_summary_del_af_execute}    Get list order summary frm product API    ${list_product_del}
    : FOR    ${result_tong_dh_del}    ${order_summary_af_execute_del}    IN ZIP    ${list_result_order_summary_del}    ${list_order_summary_del_af_execute}
    \    Should Be Equal As Numbers    ${order_summary_af_execute_del}    ${result_tong_dh_del}
    #assert value invoice
    ${get_ma_kh_by_hd}    ${get_tong_tien_hang}    ${get_khachtt_af_execute}    ${get_gghd_af_execute}    ${get_khachcantra}    ${get_trangthai}    ${get_ghichu_in_hd_af_execute}
    ...    Get invoice info have note incase discount by invoice code    ${invoice_code}
    Should Be Equal As Numbers    ${get_tong_tien_hang}    ${result_tongtienhang}
    Should Be Equal As Numbers    ${get_khachcantra}    ${result_khachcantra}
    Should Be Equal As Numbers    ${get_khachtt_af_execute}    ${result_khachcantra}
    Should Be Equal As Strings    ${get_ma_kh_by_hd}    ${input_ma_kh}
    Should Be Equal As Numbers    ${get_gghd_af_execute}    ${input_discount_inv}
    Should Be Equal As Strings    ${get_trangthai}    Hoàn thành
    #assert value order
    ${get_ma_kh_in_dh_af_execute}    ${get_TTDH_in_dh_af_execute}    ${get_tongtienhang_in_dh_af_exxecute}    ${get_khachdatra_in_dh_af_execute}    ${get_giamgia_in_dh_af_execute}    ${get_tongcong_in_dh_af_execute}    ${get_ghichu_in_dh_af_execute}
    ...    Get order info have note incase discount by order code    ${order_code}
    Should Be Equal As Strings    ${get_ma_kh_in_dh_af_execute}    ${input_ma_kh}
    Should Be Equal As Numbers    ${get_TTDH_in_dh_af_execute}    2    #trạng thái đang giao hàng
    Should Be Equal As Numbers    ${get_tongtienhang_in_dh_af_exxecute}    ${get_tongtienhang_in_dh_bf_execute}
    Should Be Equal As Numbers    ${get_khachdatra_in_dh_af_execute}    ${result_khachdatra_in_dh}
    Should Be Equal As Numbers    ${get_giamgia_in_dh_af_execute}    ${get_ggdh_in_dh_bf_execute}
    Should Be Equal As Numbers    ${get_tongcong_in_dh_af_execute}    ${get_tongcong_in_dh_bf_execute}
    Validate invoice history frm Order    ${order_code}    ${invoice_code}    ${result_khachcantra}
    #assert customer and so quy
    ${get_no_af_execute_kh}    ${get_tongban_af_execute_kh}    ${get_tongban_tru_trahang_af_execute_kh}    Run Keyword If    ${input_hoantratamung}<0    Get Customer Debt from API after purchase    ${input_ma_kh}
    ...    ${invoice_code}    ${result_tongtienhang}
    ...    ELSE    Get Customer Debt from API    ${input_ma_kh}
    ${get_maphieu_soquy}    Get Ma Phieu Thu in So quy    ${invoice_code}
    Run Keyword If    '${input_hoantratamung}' == '0'    Should Be Equal As Numbers    ${get_no_af_execute_kh}    ${result_du_no_hd_KH}
    ...    ELSE    Should Be Equal As Numbers    ${get_no_af_execute_kh}    ${result_PTT_hd_KH}
    Should Be Equal As Numbers    ${get_tongban_af_execute_kh}    ${result_tongban_KH}
    Run Keyword If    '${input_hoantratamung}' == '0'    Validate customer history and debt if invoice is not paid frm order    ${input_ma_kh}    ${invoice_code}    ${result_du_no_hd_KH}
    ...    ELSE    Validate customer history and debt if invoice is paid deposit refund frm order    ${input_ma_kh}    ${invoice_code}    ${result_du_no_hd_KH}    ${result_PTT_hd_KH}
    Run Keyword If    '${result_tongtienhang}' == '0'    Validate history tab of customer frm Order    ${input_ma_kh}    ${invoice_code}
    Run Keyword If    '${input_hoantratamung}' == '0'    Validate So quy info from Rest API if Invoice is not paid    ${get_maphieu_soquy}
    ...    ELSE    Validate So quy info from Rest API if Invoice is paid    ${get_maphieu_soquy}    ${result_tamung}
    Delete invoice by invoice code    ${invoice_code}
    Delete order frm Order code    ${order_code}
    Toggle status of promotion    ${input_khuyemmai}    0

edxhh02
    [Arguments]    ${dict_product_num}    ${input_discount_inv}    ${input_ma_kh}    ${input_bh_khachtt}    ${input_khuyemmai}    ${dict_promo_product}
    ...    ${input_khtt_create_order}
    [Timeout]
    ## Get info ton cuoi, cong no khach hang
    Toggle status of promotion    ${input_khuyemmai}    1
    ${order_code}    Add new order with promotion buy product and get other product free    ${input_ma_kh}    ${dict_product_num}    ${input_khuyemmai}    ${dict_promo_product}    ${input_khtt_create_order}
    ${num_sale_product}    ${num_promo_product}    ${product_price}    ${discount}    ${discount_ratio}    ${name}    Get Number of sale product - promo product - promo value and name
    ...    ${input_khuyemmai}
    ${get_ma_dh_in_dh_bf_execute}    ${get_khachdatra_in_dh_bf_execute}    ${get_ggdh_in_dh_bf_execute}    ${get_tongtienhang_in_dh_bf_execute}    ${get_tongcong_in_dh_bf_execute}    Get order code - paid - discount value frm API    ${input_ma_kh}
    ${get_list_hh_in_dh_bf_execute}    ${get_ghichu_bf_execute}    Get ghi chu and list product frm API    ${order_code}
    ${get_list_nums_in_dh}    Get list quantity by order code    ${order_code}    ${get_list_hh_in_dh_bf_execute}
    ${list_result_order_summary}    ${result_list_toncuoi}    ${result_list_thanhtien}    Get list order summary - total sale - ending stocks frm API    ${order_code}    ${get_list_hh_in_dh_bf_execute}
    #create lists
    Reload Page
    #Compute
    ${result_khachcantra}    Minus and replace floating point    ${get_tongtienhang_in_dh_bf_execute}    ${input_discount_inv}
    ${result_khachcanthanhtoan}    Minus and replace floating point    ${result_khachcantra}        ${get_khachdatra_in_dh_bf_execute}
    ${actual_khachtt}    Set Variable If    '${input_bh_khachtt}' == 'all'    ${result_khachcantra}    ${input_bh_khachtt}
    ${result_khachdatra}    Sum    ${get_khachdatra_in_dh_bf_execute}    ${actual_khachtt}
    #create invoice
    Go to xu ly dat hang    ${order_code}
    Go to BH frm process order    ${order_code}
    Wait Until Keyword Succeeds    3 times    8 s    Input VND discount invoice    ${input_discount_inv}
    Run Keyword If    "${input_bh_khachtt}" == "all"    Click Element JS    ${button_bh_thanhtoan}
    ...    ELSE    Input customer payment into BH form    ${input_bh_khachtt}    ${result_khachcanthanhtoan}
    Sleep     1s
    ${invoice_code}    Get saved code after execute
    #get values
    Sleep    20 s    wait for response to API
    #assert value product in invoice
    ${get_list_hh_in_hd_af_execute}    Get list product frm Invoice API    ${invoice_code}
    ${list_soluong_in_hd}    ${list_giatri_quydoi_in_hd}    Get list quantity and gia tri quy doi by invoice code    ${get_list_hh_in_hd_af_execute}    ${invoice_code}
    : FOR    ${ma_hh}    ${result_toncuoi}    ${item_soluong}    ${get_giatri_quydoi}    IN ZIP    ${get_list_hh_in_hd_af_execute}
    ...    ${result_list_toncuoi}    ${list_soluong_in_hd}    ${list_giatri_quydoi_in_hd}
    \    Run Keyword If    '${get_giatri_quydoi}' == '1'    Validate product history frm API    ${invoice_code}    ${ma_hh}    ${result_toncuoi}
    \    ...    ${item_soluong}
    \    ...    ELSE    Validate unit product history frm API    ${invoice_code}    ${ma_hh}    ${result_toncuoi}
    \    ...    ${item_soluong}    ${get_giatri_quydoi}
    #assert value product
    ${list_order_summary_af_execute}    Get list order summary by order code    ${order_code}
    : FOR    ${result_tong_dh}    ${order_summary_af_execute}    IN ZIP    ${list_result_order_summary}    ${list_order_summary_af_execute}
    \    Should Be Equal As Numbers    ${order_summary_af_execute}    ${result_tong_dh}
    #assert value invoice
    ${get_ma_kh_by_hd}    ${get_tong_tien_hang}    ${get_khachtt_af_execute}    ${get_gghd_af_execute}    ${get_khachcantra}    ${get_trangthai}    ${get_ghichu_in_hd_af_execute}
    ...    Get invoice info have note incase discount by invoice code    ${invoice_code}
    Should Be Equal As Numbers    ${get_tong_tien_hang}    ${get_tongtienhang_in_dh_bf_execute}
    Should Be Equal As Numbers    ${get_khachcantra}    ${result_khachcantra}
    Should Be Equal As Numbers    ${get_khachtt_af_execute}    ${result_khachdatra}
    Should Be Equal As Strings    ${get_ma_kh_by_hd}    ${input_ma_kh}
    Should Be Equal As Numbers    ${get_gghd_af_execute}    ${input_discount_inv}
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
    Delete invoice by invoice code    ${invoice_code}
    Delete order frm Order code    ${order_code}
    Toggle status of promotion    ${input_khuyemmai}    0

edxhh03
    [Arguments]    ${dict_product_num}    ${input_discount_inv}    ${input_ma_kh}    ${input_bh_khachtt}    ${input_khuyemmai}    ${input_khtt_create_order}
    ...    ${dict_product_add}    ${list_ggsp}
    ## Get info ton cuoi, cong no khach hang
    Toggle status of promotion    ${input_khuyemmai}    1
    ${order_code}    Add new order with promotion buy every items at a fixed reduced price    ${input_ma_kh}    ${dict_product_num}    ${input_khuyemmai}    ${input_khtt_create_order}
    ${num_sale_product}    ${num_promo_product}    ${product_price}    ${discount}    ${discount_ratio}    ${name}    Get Number of sale product - promo product - promo value and name
    ...    ${input_khuyemmai}
    ${list_product}    Get Dictionary Keys    ${dict_product_num}
    ${list_nums}    Get Dictionary Values    ${dict_product_num}
    ${list_product_add}    Get Dictionary Keys    ${dict_product_add}
    ${list_nums_add}    Get Dictionary Values    ${dict_product_add}
    ${get_ma_dh_in_dh_bf_execute}    ${get_khachdatra_in_dh_bf_execute}    ${get_ggdh_in_dh_bf_execute}    ${get_tongtienhang_in_dh_bf_execute}    ${get_tongcong_in_dh_bf_execute}    Get order code - paid - discount value frm API    ${input_ma_kh}
    ${get_list_product_type}    ${list_tonkho_service}    Get list product type and ending stock of service frm API    ${list_product}
    ${get_list_thanhtien_in_dh}    ${get_list_soluong_in_dh}    ${get_list_tongso_dh_bf_execute}    ${get_list_ton_bf_execute}    Get list quantity - sub total - order summary - ending stock frm API    ${order_code}    ${list_product}
    ${list_result_order_summary}    ${result_list_toncuoi}    ${result_list_thanhtien}    Get list order summary - total sale - ending stocks frm API    ${order_code}    ${list_product}
    ${list_thanhtien_Add}    Create List
    ${get_list_baseprice}    Get list of Baseprice by Product Code    ${list_product_add}
    ${list_onhand}    Get list onhand frm API    ${list_product_add}
    : FOR    ${input_soluong}    ${get_ton_bf_execute}    ${item_giaban}    IN ZIP    ${list_nums_add}    ${list_onhand}    ${get_list_baseprice}
    \    ${result_toncuoi}    Minus and replace floating point    ${get_ton_bf_execute}    ${input_soluong}
    \    ${result_thanhtien}    Multiplication and round    ${item_giaban}    ${input_soluong}
    \    Append To List    ${result_list_toncuoi}    ${result_toncuoi}
    \    Append To List    ${list_thanhtien_Add}    ${result_thanhtien}
    #create lists
    Reload Page
    #Compute
    ${result_tongtienhang_add}    Sum values in list    ${list_thanhtien_Add}
    ${result_tongtienhang}    Sum values in list    ${result_list_thanhtien}
    ${result_tongtienhang}    Sum and replace floating point    ${result_tongtienhang_add}     ${result_tongtienhang}
    ${result_tongsoluong}    Sum values in list    ${list_nums}
    ${result_gghd}    Convert % discount to VND and round    ${result_tongtienhang}    ${input_discount_inv}
    ${result_khachcantra}    Minus and replace floating point    ${result_tongtienhang}    ${result_gghd}
    ${result_khachcanthanhtoan}    Minus and replace floating point    ${result_khachcantra}        ${get_khachdatra_in_dh_bf_execute}
    ${actual_khachtt}    Set Variable If    '${input_bh_khachtt}' == 'all'    ${result_khachcanthanhtoan}    ${input_bh_khachtt}
    ${result_khachdatra}    Sum    ${get_khachdatra_in_dh_bf_execute}    ${actual_khachtt}
    ${result_tongcong}     Sum    ${result_khachcantra}    ${result_khachdatra}
    #create invoice
    Go to xu ly dat hang    ${order_code}
    Go to BH frm process order    ${order_code}
    ${lastest_num}    Set Variable    ${result_tongsoluong}
    :FOR    ${item_product_add}   ${item_nums_add}   IN ZIP    ${list_product_add}    ${list_nums_add}
    \    ${lastest_num}    Wait Until Keyword Succeeds    3 times    5 s    Input product-num in sale form    ${item_product_add}    ${item_nums_add}    ${lastest_num}    ${cell_lastest_number}
    Wait Until Keyword Succeeds    3 times    8 s    Input % discount invoice    ${input_discount_inv}    ${result_gghd}
    Run Keyword If    "${input_bh_khachtt}" == "all"    Click Element JS    ${button_bh_thanhtoan}
    ...    ELSE    Input customer payment into BH form    ${input_bh_khachtt}    ${result_khachcanthanhtoan}
    Invoice message success validation
    Sleep    2s
    ${invoice_code}    Get saved code after execute
    #get values
    Sleep    20 s    wait for response to API
    #assert value product in invoice
    ${get_list_hh_in_hd_af_execute}    Get list product frm Invoice API    ${invoice_code}
    Reverse List    ${get_list_hh_in_hd_af_execute}
    ${list_soluong_in_hd}    ${list_giatri_quydoi_in_hd}    Get list quantity and gia tri quy doi by invoice code    ${get_list_hh_in_hd_af_execute}    ${invoice_code}
    : FOR    ${ma_hh}    ${result_toncuoi}    ${item_soluong}    ${get_giatri_quydoi}    IN ZIP    ${get_list_hh_in_hd_af_execute}
    ...    ${result_list_toncuoi}    ${list_soluong_in_hd}    ${list_giatri_quydoi_in_hd}
    \    Run Keyword If    '${get_giatri_quydoi}' == '1'    Validate product history frm API    ${invoice_code}    ${ma_hh}    ${result_toncuoi}
    \    ...    ${item_soluong}
    \    ...    ELSE    Validate unit product history frm API    ${invoice_code}    ${ma_hh}    ${result_toncuoi}
    \    ...    ${item_soluong}    ${get_giatri_quydoi}
    #assert value product
    ${list_order_summary_af_execute}    Get list order summary by order code    ${order_code}
    : FOR    ${result_tong_dh}    ${order_summary_af_execute}    IN ZIP    ${list_result_order_summary}    ${list_order_summary_af_execute}
    \    Should Be Equal As Numbers    ${order_summary_af_execute}    ${result_tong_dh}
    #assert value invoice
    ${get_ma_kh_by_hd}    ${get_tong_tien_hang}    ${get_khachtt_af_execute}    ${get_gghd_af_execute}    ${get_khachcantra}    ${get_trangthai}    ${get_ghichu_in_hd_af_execute}
    ...    Get invoice info have note incase discount by invoice code    ${invoice_code}
    Should Be Equal As Numbers    ${get_tong_tien_hang}    ${result_tongtienhang}
    Should Be Equal As Numbers    ${get_khachcantra}    ${result_khachcantra}
    Should Be Equal As Numbers    ${get_khachtt_af_execute}    ${result_khachdatra}
    Should Be Equal As Strings    ${get_ma_kh_by_hd}    ${input_ma_kh}
    Should Be Equal As Numbers    ${get_gghd_af_execute}    ${result_gghd}
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
    #Delete invoice by invoice code    ${invoice_code}
    #Delete order frm Order code    ${order_code}
    Toggle status of promotion    ${input_khuyemmai}    0
