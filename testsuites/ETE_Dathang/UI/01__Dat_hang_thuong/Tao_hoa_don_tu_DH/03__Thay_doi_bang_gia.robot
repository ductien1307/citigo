*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    ${headless_browser}
Test Setup
Test Teardown     After Test
Library           Collections
Library           BuiltIn
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

*** Variables ***
&{dict_product01}    HH0055=2.5    SI038=2    QD124=3    DV062=2.5    Combo39=1

*** Test Cases ***    Mã KH         Tên Bảng giá         GGDH     Khách thanh toán    List product
Thay doi bang gia     [Tags]        EDX1       ED
                      [Template]    uetedh_create_inv7
                      CTKH099       Bảng giá hóa đơn     20000    500000              ${dict_product01}

*** Keywords ***
uetedh_create_inv7
    [Arguments]    ${input_ma_kh}    ${input_ten_bangia}    ${input_gghd}    ${input_khtt}    ${dict_product_nums_create}
    Set Selenium Speed    0.5s
    #get info product, customer
    ${order_code}    Add new order with multi product and no payment - get order code    ${input_ma_kh}    ${dict_product_nums_create}
    ${get_khachdatra_in_dh_bf_execute}    ${get_tongtienhang_in_dh_bf_execute}    Get paid value frm API    ${order_code}
    ${get_list_hh_in_dh_bf_execute}    ${get_ghichu_bf_execute}    Get ghi chu and list product frm API    ${order_code}
    ${get_list_nums_in_dh}    Get list quantity by order code    ${order_code}    ${get_list_hh_in_dh_bf_execute}
    ${list_result_tongdh}    ${result_list_toncuoi}    ${result_list_thanhtien}    ${list_giaban_new}    Change pricebook and get list order summary and ending stocks frm API    ${order_code}    ${get_list_hh_in_dh_bf_execute}
    ...    ${input_ten_bangia}
    #create imei
    Create list imei and other product    ${get_list_hh_in_dh_bf_execute}    ${get_list_nums_in_dh}
    ${get_list_status_imei}   Get list imei status thr API    ${get_list_hh_in_dh_bf_execute}
    #compute invoice info
    ${result_tongtienhang}    Sum values in list    ${result_list_thanhtien}
    ${result_TTH_tru_gghd}    Minus and replace floating point    ${result_tongtienhang}    ${input_gghd}
    ${result_khachcantra}    Minus and replace floating point    ${result_TTH_tru_gghd}    ${get_khachdatra_in_dh_bf_execute}
    ${actual_khtt_all}    Set Variable If    '${input_khtt}' == 'all'    ${result_khachcantra}    ${input_khtt}
    ${actual_khtt}    Set Variable If    '${input_khtt}' == '0'    0    ${actual_khtt_all}
    #compute order info
    ${actual_khtt_paymented}    Sum and replace floating point    ${actual_khtt}    ${get_khachdatra_in_dh_bf_execute}
    #create invoice
    Wait Until Keyword Succeeds    3 times    20 s    Wait Until Keyword Succeeds    3 times    20 s    Before Test Ban Hang
    Go to xu ly dat hang    ${order_code}
    Go to BH frm process order    ${order_code}
    : FOR    ${item_product}    ${status_imei}    ${item_imei}    IN ZIP    ${get_list_hh_in_dh_bf_execute}   ${get_list_status_imei}    ${imei_inlist}
    \    Run Keyword If    '${status_imei}' == 'True'    Wait Until Keyword Succeeds    3 times    8 s    Input imei incase multi product to any form    ${item_product}    ${texbox_imei_search_multi_product}
    \    ...    ${item_serial_in_dropdown}    ${cell_imei_multi_product}    @{item_imei}    ELSE      Log     Ignore input
    Select Bang gia    ${input_ten_bangia}
    Wait Until Keyword Succeeds    3 times    20 s    Input VND discount invoice    ${input_gghd}
    Run Keyword If    "${input_khtt}" == "all"    Click Element JS    ${button_bh_thanhtoan}
    ...    ELSE    Input customer payment into BH form    ${input_khtt}    ${result_khachcantra}
    Sleep     2s
    Invoice message success validation
    ${invoice_code}    Wait Until Keyword Succeeds    3 times    8 s    Get saved code after execute
    #get value
    Sleep    20s    wait for response to API
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
    Should Be Equal As Numbers    ${get_tong_tien_hang}    ${result_tongtienhang}
    Should Be Equal As Numbers    ${get_khachcantra}    ${result_TTH_tru_gghd}
    Should Be Equal As Numbers    ${get_khachtt_af_execute}    ${actual_khtt}
    Should Be Equal As Strings    ${get_ma_kh_by_hd}    ${input_ma_kh}
    Should Be Equal As Numbers    ${get_gghd_af_execute}    ${input_gghd}
    Should Be Equal As Strings    ${get_trangthai}    Hoàn thành
    Should Be Equal As Strings    ${get_ghichu_in_hd_af_execute}    ${get_ghichu_bf_execute}
    #assert value order
    ${get_ma_kh_in_dh_af_execute}    ${get_TTDH_in_dh_af_execute}    ${get_tongtienhang_in_dh_af_exxecute}    ${get_khachdatra_in_dh_af_execute}    ${get_ghichu_af_execute}    Get order info have note by order code    ${order_code}
    Should Be Equal As Strings    ${get_ma_kh_in_dh_af_execute}    ${input_ma_kh}
    Should Be Equal As Strings    ${get_TTDH_in_dh_af_execute}    3    #trạng thái hoàn thành
    Should Be Equal As Numbers    ${get_tongtienhang_in_dh_af_exxecute}    ${get_tongtienhang_in_dh_bf_execute}
    Should Be Equal As Numbers    ${get_khachdatra_in_dh_af_execute}    ${actual_khtt}
    Should Be Equal As Strings    ${get_ghichu_af_execute}    ${get_ghichu_bf_execute}
    Validate invoice history frm Order    ${order_code}    ${invoice_code}    ${result_TTH_tru_gghd}
    Delete invoice by invoice code    ${invoice_code}
    Delete order frm Order code    ${order_code}
