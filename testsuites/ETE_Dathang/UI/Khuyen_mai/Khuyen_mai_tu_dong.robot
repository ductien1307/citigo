*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    ${headless_browser}
Test Teardown     After Test
Resource          ../../../../core/API/api_thietlap.robot
Resource          ../../../../core/API/api_dathang.robot
Resource          ../../../../core/Ban_Hang/banhang_getandcompute.robot
Resource          ../../../../core/share/toast_message.robot
Resource          ../../../../core/API/api_mhbh_dathang.robot
Resource          ../../../../core/API/api_soquy.robot
Resource          ../../../../core/API/api_danhmuc_hanghoa.robot
Resource          ../../../../config/env_product/envi.robot

*** Variables ***
&{list_product_nums1}    Combo171=4   HKM003=1
&{list_product_nums2}    DVT36=3
&{list_give1}    DVT36=1
@{list_discount}    10000    15
@{discount_type}    disvnd    dis

*** Test Cases ***    List product nums        GGHD         Mã KH      Khách thanh toán    KTT to create    Mã khuyến mãi    List GGSP             List discount type
KM HH va HD hinh thuc Giam gia hoa don
                      [Tags]                   UEDKMA
                      [Template]               edat1
                      ${list_product_nums1}    15          CTKH038       all                 0                  KM012        ${list_discount}      ${discount_type}          #mua hang gg hang VND

KM HH va HD hinh thuc giam gia hang
                      [Tags]                   UEDKMA1
                      [Template]               edat2
                      ${list_product_nums2}    20          CTKH040       0                    200000              KM017      ${list_give1}

*** Keywords ***
edat1
    [Arguments]    ${dict_product_num}    ${input_discount_inv}    ${input_ma_kh}    ${input_khtt}    ${input_khtt_create_order}    ${input_khuyemmai}    ${list_discount_product}    ${list_discount_type}
    ## Get info ton cuoi, cong no khach hang
    Turn on allow use auto promotion invoice in shop config
    Toggle status of promotion    ${input_khuyemmai}    1
    ${order_code}     Add new order incase discount - payment    ${input_ma_kh}   0    ${dict_product_num}    ${list_discount_product}    ${list_discount_type}        ${input_khtt_create_order}
    ${list_product}    Get Dictionary Keys    ${dict_product_num}
    ${list_nums}    Get Dictionary Values    ${dict_product_num}
    ${invoice_value}    ${discount}    ${discount_ratio}    ${name}    Get Invoice value - Discounts - Promotion Name from Promotion Code    ${input_khuyemmai}
    ${get_ma_dh_in_dh_bf_execute}    ${get_khachdatra_in_dh_bf_execute}    ${get_ggdh_in_dh_bf_execute}    ${get_tongtienhang_in_dh_bf_execute}    ${get_tongcong_in_dh_bf_execute}    Get order code - paid - discount value frm API    ${input_ma_kh}
    ${get_no_bf_execute}    ${get_tongban_bf_execute}    ${get_tongban_tru_trahang_bf_execute}    Get Customer Debt from API    ${input_ma_kh}
    ${get_list_ordersummary_bf_execute}    Get list order summary by order code    ${order_code}
    ${list_result_order_summary}    Get list order summary after create invoice    ${get_list_ordersummary_bf_execute}    ${list_nums}
    ${list_result_thanhtien}    ${list_order_summary}    ${list_result_giamoi}    Get list total sale - order summary - newprice incase discount and newprice    ${list_product}    ${list_nums}    ${list_discount_product}    ${list_discount_type}
    #compute
    ${result_tongtienhang}    Sum values in list    ${list_result_thanhtien}
    ${result_discount_invoice_by_vnd}   Convert % discount to VND and round    ${result_tongtienhang}    ${input_discount_inv}
    ${result_discount_ratio_by_invoice_promo}    Convert % discount to VND and round    ${result_tongtienhang}    ${discount_ratio}
    ${actual_promo_value}    Set Variable If    ${discount} == 0    ${result_discount_ratio_by_invoice_promo}    ${discount}
    ${final_discount}=    Run Keyword If    ${result_tongtienhang} > ${invoice_value}    Sum    ${actual_promo_value}    ${result_discount_invoice_by_vnd}
    ...    ELSE    Set Variable    ${result_discount_invoice_by_vnd}
    ${result_khachcantra}    Minus    ${result_tongtienhang}    ${final_discount}
    ${actual_ktt}    Set Variable If    '${input_khtt}' == 'all'    ${result_khachcantra}    ${input_khtt}
    ${result_nohientai}    Sum    ${get_no_bf_execute}    ${result_khachcantra}
    ${result_PTT_hd_KH}    Minus    ${result_nohientai}    ${actual_ktt}
    ${result_tongban}    Sum    ${result_khachcantra}    ${get_tongban_bf_execute}
    #create order
    Before Test Ban Hang
    Go to xu ly dat hang    ${order_code}
    Go to BH frm process order    ${order_code}
    Wait Until Keyword Succeeds    3 times    8 s    Input % discount invoice    ${input_discount_inv}    ${final_discount}
    Run Keyword If    '${input_khtt}' == 'all'    Click Element JS    ${button_bh_thanhtoan}
    ...    ELSE    Input customer payment and deposit refund into BH form    ${actual_ktt}
    SLeep    5s
    ${invoice_code}    Get saved code after execute
    #get values
    Sleep    20 s    wait for response to API
    #assert value invoice
    ${get_ma_kh_by_hd}    ${get_tong_tien_hang}    ${get_khachtt_af_execute}    ${get_gghd_af_execute}    ${get_khachcantra}    ${get_trangthai}    ${get_ghichu_in_hd_af_execute}
    ...    Get invoice info have note incase discount by invoice code    ${invoice_code}
    Should Be Equal As Numbers    ${get_tong_tien_hang}    ${result_tongtienhang}
    Should Be Equal As Numbers    ${get_khachcantra}    ${result_khachcantra}
    Should Be Equal As Numbers    ${get_khachtt_af_execute}    ${result_khachcantra}
    Should Be Equal As Strings    ${get_ma_kh_by_hd}    ${input_ma_kh}
    Should Be Equal As Numbers    ${get_gghd_af_execute}    ${final_discount}
    Should Be Equal As Strings    ${get_trangthai}    Hoàn thành
    ${get_ma_kh_in_dh_af_execute}    ${get_TTDH_in_dh_af_execute}    ${get_tongtienhang_in_dh_af_exxecute}    ${get_khachdatra_in_dh_af_execute}    ${get_giamgia_in_dh_af_execute}    ${get_tongcong_in_dh_af_execute}    ${get_ghichu_in_dh_af_execute}
    ...    Get order info have note incase discount by order code    ${order_code}
    Should Be Equal As Strings    ${get_ma_kh_in_dh_af_execute}    ${input_ma_kh}
    Should Be Equal As Numbers    ${get_TTDH_in_dh_af_execute}    3    #trạng thái hoàn thành
    Should Be Equal As Numbers    ${get_tongtienhang_in_dh_af_exxecute}    ${get_tongtienhang_in_dh_bf_execute}
    Should Be Equal As Numbers    ${get_khachdatra_in_dh_af_execute}    ${result_khachcantra}
    Should Be Equal As Numbers    ${get_giamgia_in_dh_af_execute}    ${get_ggdh_in_dh_bf_execute}
    Should Be Equal As Numbers    ${get_tongcong_in_dh_af_execute}    ${get_tongcong_in_dh_bf_execute}
    Validate invoice history frm Order    ${order_code}    ${invoice_code}    ${result_khachcantra}
    #assert value product
    ${get_list_ordersummary_af_execute}    Get list order summary by order code    ${order_code}
    : FOR    ${result_order_summary}    ${order_summary_af_execute}    IN ZIP    ${list_result_order_summary}    ${get_list_ordersummary_af_execute}
    \    Should Be Equal As Numbers    ${order_summary_af_execute}    ${result_order_summary}
    #assert customer and so quy
    ${get_no_af_execute_kh}    ${get_tongban_af_execute_kh}    ${get_tongban_tru_trahang_af_execute_kh}    Run Keyword If    ${input_khtt}!=0    Get Customer Debt from API after purchase    ${input_ma_kh}
    ...    ${invoice_code}    ${result_tongtienhang}
    ...    ELSE    Get Customer Debt from API    ${input_ma_kh}
    ${get_maphieu_soquy}    Get Ma Phieu Thu in So quy    ${invoice_code}
    Run Keyword If    '${input_khtt}' == '0'    Should Be Equal As Numbers    ${get_no_af_execute_kh}    ${result_nohientai}
    ...    ELSE    Should Be Equal As Numbers    ${get_no_af_execute_kh}    ${result_PTT_hd_KH}
    Should Be Equal As Numbers    ${get_tongban_af_execute_kh}    ${result_tongban}
    Run Keyword If    '${input_khtt}' == '0'    Validate customer history and debt if invoice is not paid frm order    ${input_ma_kh}    ${invoice_code}    ${result_nohientai}
    ...    ELSE    Validate customer history and debt if invoice is paid deposit refund frm order    ${input_ma_kh}    ${invoice_code}    ${result_nohientai}    ${result_PTT_hd_KH}
    Run Keyword If    '${result_tongtienhang}' == '0'    Validate history tab of customer frm Order    ${input_ma_kh}    ${invoice_code}
    Run Keyword If    '${input_khtt}' == '0'    Validate So quy info from Rest API if Invoice is not paid    ${get_maphieu_soquy}
    ...    ELSE    Validate So quy info from Rest API if Invoice is paid    ${get_maphieu_soquy}    ${actual_ktt}
    Delete invoice by invoice code    ${invoice_code}
    Delete order frm Order code    ${order_code}
    Toggle status of promotion    ${input_khuyemmai}    0
    Turn off allow use auto promotion invoice in shop config

edat2
    [Arguments]    ${dict_product_num}   ${input_ggdh}    ${input_ma_kh}    ${input_bh_khachtt}    ${input_khtt_create_order}    ${input_khuyemmai}    ${dict_promo_product}
    [Timeout]
    ## Get info ton cuoi, cong no khach hang
    Turn on allow use auto promotion invoice in shop config
    Toggle status of promotion    ${input_khuyemmai}    1
    ${list_product}    Get Dictionary Keys    ${dict_product_num}
    ${list_nums}    Get Dictionary Values    ${dict_product_num}
    ${list_product_promo}    Get Dictionary Keys    ${dict_promo_product}
    ${list_nums_promo}    Get Dictionary Values    ${dict_promo_product}
    ${order_code}     Add new order with discount order    ${input_ma_kh}   ${input_ggdh}    ${dict_product_num}    ${input_khtt_create_order}
    ${num_sale_product}    ${num_promo_product}    ${product_price}    ${discount}    ${discount_ratio}    ${name}    Get Number of sale product - promo product - promo value and name
    ...    ${input_khuyemmai}
    ${get_ma_dh_in_dh_bf_execute}    ${get_khachdatra_in_dh_bf_execute}    ${get_ggdh_in_dh_bf_execute}    ${get_tongtienhang_in_dh_bf_execute}    ${get_tongcong_in_dh_bf_execute}    Get order code - paid - discount value frm API    ${input_ma_kh}
    ${get_list_hh_in_dh_bf_execute}    ${get_ghichu_bf_execute}    Get ghi chu and list product frm API    ${order_code}
    ${get_list_nums_in_dh}    Get list quantity by order code    ${order_code}    ${get_list_hh_in_dh_bf_execute}
    ${list_result_tongdh}    ${result_list_toncuoi}    ${result_list_thanhtien}    Get list order summary - total sale - ending stocks frm API    ${order_code}    ${get_list_hh_in_dh_bf_execute}
    ${get_list_baseprice}    Get list of Baseprice by Product Code    ${list_product_promo}
    ${result_thanhtien_promo}   Create List
    ${list_result_toncuoi}   Create List
    ${list_result_soluong}   Create List
    :FOR    ${item_giaban}    ${item_nums}   ${item_onhand}   ${item_nums1}    IN ZIP    ${get_list_baseprice}    ${list_nums_promo}    ${result_list_toncuoi}    ${get_list_nums_in_dh}
    \     ${giaban}   Price after % discount product    ${item_giaban}    ${discount_ratio}
    \     ${thanhtien}    Multiplication and round     ${giaban}    ${item_nums}
    \     ${result_tonkho}    Minus   ${item_onhand}    ${item_nums}
    \     ${result_nums}  Sum    ${item_nums}   ${item_nums1}
    \     Append To List     ${result_thanhtien_promo}     ${thanhtien}
    \     Append To List     ${list_result_toncuoi}     ${result_tonkho}
    \     Append To List    ${list_result_soluong}     ${result_nums}
    #Compute
    ${result_tongtienhang_promo}    Sum values in list    ${result_thanhtien_promo}
    ${result_tongtienhang}   Sum and replace floating point    ${result_tongtienhang_promo}    ${get_tongtienhang_in_dh_bf_execute}
    ${result_gghd}    Convert % discount to vnd and round    ${result_tongtienhang}    ${get_ggdh_in_dh_bf_execute}
    ${result_khachcantra}    Minus and replace floating point    ${result_tongtienhang}    ${result_gghd}
    ${result_khachcanthanhtoan}    Minus and replace floating point    ${result_khachcantra}        ${get_khachdatra_in_dh_bf_execute}
    ${actual_khachtt}    Set Variable If    '${input_bh_khachtt}' == 'all'    ${result_khachcantra}    ${input_bh_khachtt}
    ${result_khachdatra}    Sum    ${get_khachdatra_in_dh_bf_execute}    ${actual_khachtt}
    #create invoice
    Before Test Ban Hang
    Go to xu ly dat hang    ${order_code}
    Go to BH frm process order    ${order_code}
    Run Keyword If    "${input_bh_khachtt}" == "all"    Click Element JS    ${button_bh_thanhtoan}    ELSE    Input customer payment into BH form    ${input_bh_khachtt}    ${result_khachcanthanhtoan}
    Sleep     1s
    ${invoice_code}    Get saved code after execute
    #get values
    Sleep    20 s    wait for response to API
    #assert value product in invoice
    ${list_soluong_in_hd}    ${list_giatri_quydoi_in_hd}    Get list quantity and gia tri quy doi by invoice code    ${list_product}    ${invoice_code}
    : FOR    ${ma_hh}    ${result_toncuoi}    ${item_soluong}    ${get_giatri_quydoi}    IN ZIP    ${list_product}
    ...    ${list_result_toncuoi}    ${list_result_soluong}    ${list_giatri_quydoi_in_hd}
    \    Run Keyword If    '${get_giatri_quydoi}' == '1'    Validate product history frm API    ${invoice_code}    ${ma_hh}    ${result_toncuoi}
    \    ...    ${item_soluong}
    \    ...    ELSE    Validate unit product history frm API    ${invoice_code}    ${ma_hh}    ${result_toncuoi}
    \    ...    ${item_soluong}    ${get_giatri_quydoi}
    #assert value product
    ${list_order_summary_af_execute}    Get list order summary by order code    ${order_code}
    : FOR    ${result_tong_dh}    ${order_summary_af_execute}    IN ZIP    ${list_result_tongdh}    ${list_order_summary_af_execute}
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
    Delete invoice by invoice code    ${invoice_code}
    Delete order frm Order code    ${order_code}
    Toggle status of promotion    ${input_khuyemmai}    0
    Turn off allow use auto promotion invoice in shop config
