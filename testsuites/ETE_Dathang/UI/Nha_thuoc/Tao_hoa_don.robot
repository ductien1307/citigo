*** Settings ***
Suite Setup       Init Test Environment    NT    ${remote}    ${account}    ${headless_browser}
Test Setup
Test Teardown     After Test
Resource          ../../../../config/env_product/envi.robot
Resource          ../../../../core/API/api_danhmuc_hanghoa.robot
Resource          ../../../../core/API/api_dathang.robot
Resource          ../../../../core/API/api_khachhang.robot
Resource          ../../../../core/API/api_mhbh.robot
Resource          ../../../../core/Dat_Hang/dat_hang_action.robot
Resource          ../../../../core/Dat_Hang/dat_hang_navigation.robot
Resource          ../../../../core/Dat_Hang/dat_hang_page.robot
Resource          ../../../../core/share/toast_message.robot
Resource          ../../../../core/API/api_soquy.robot
Resource          ../../../../core/API/api_mhbh_dathang.robot
Resource          ../../../../core/share/computation.robot
Library           Collections
Library           BuiltIn

*** Variables ***
&{dict_product_nums1}    T00011=5     T00012=3
@{discount}       10        85000
@{discount_type}    dis     changeup
@{num_nhap}       7         3
@{num_edit}       3         3
@{num_edit1}       5         3

*** Test Cases ***    Mã KH         GGDH      Dict product - num       List GGSP      List discount type    Khach tt dh    List SL nhap    List SL lay      Khach tt
Basic                 [Tags]        EBNT
                      [Template]    edht2
                      #KH005         100000    ${dict_product_nums1}    ${discount}    ${discount_type}      0              ${num_nhap}     ${num_edit}       all
                      KH006         100000    ${dict_product_nums1}    ${discount}    ${discount_type}      50000           ${num_nhap}     ${num_edit1}      all

*** Keywords ***
edht2
    [Arguments]    ${input_ma_kh}    ${input_ggdh}    ${dict_product_nums}    ${list_ggsp}    ${list_discount_type}    ${input_khtt_tocreate}
    ...    ${list_slnhap}    ${list_num_edit}    ${input_khtt}
    #get info product, customer
    ${list_product}    Get Dictionary Keys    ${dict_product_nums}
    ${list_num}       Get Dictionary Values    ${dict_product_nums}
    ${list_ggsp_copy}     Set Variable    ${list_ggsp}
    ${order_code}    Run Keyword If    ${input_khtt_tocreate}==0    Add new order incase discount - no payment    ${input_ma_kh}    ${input_ggdh}    ${dict_product_nums}
    ...    ${list_ggsp}    ${list_discount_type}
    ...    ELSE    Add new order incase discount - payment    ${input_ma_kh}    ${input_ggdh}    ${dict_product_nums}    ${list_ggsp}
    ...    ${list_discount_type}    ${input_khtt_tocreate}
    ${list_tenlo_all}    Import lot name for products by generating randomly    ${list_product}    ${list_slnhap}
    ${order_code}    ${get_khachdatra_in_dh_bf_execute}    ${get_ggdh_in_dh_bf_execute}    ${get_tongtienhang_in_dh_bf_execute}    ${get_tongcong_in_dh_bf_execute}    Get order code - paid - discount value frm API    ${input_ma_kh}
    ${list_product}    Get Dictionary Keys    ${dict_product_nums}
    ${get_no_bf_execute}    ${get_tongban_bf_execute}    ${get_tongban_tru_trahang_bf_execute}    Get Customer Debt from API    ${input_ma_kh}
    ${get_list_hh_in_dh_bf_execute}    ${get_ghichu_bf_execute}    Get ghi chu and list product frm API    ${order_code}
    #
    ${list_tonlo}     Get list onhand lot from list product thr API     ${list_product}    ${list_tenlo_all}
    ${listl_onhand_lo_af_ex}    Create List
    : FOR    ${item_tonlo}    ${item_num}       IN ZIP    ${list_tonlo}    ${list_num_edit}
    \    ${item_tonlo_af_ex}    Minus    ${item_tonlo}    ${item_num}
    \    Append To List    ${listl_onhand_lo_af_ex}    ${item_tonlo_af_ex}
    Log Many    ${listl_onhand_lo_af_ex}
    #get order summary and sub total of products
    ${result_list_toncuoi}    Get list of result onhand incase changing product price    ${list_product}    ${list_num_edit}
    ${list_result_thanhtien}    ${list_result_newprice}    Get list of total sale - result new price incase changing product price    ${list_product}    ${list_num_edit}    ${list_ggsp_copy}    ${list_discount_type}
    ${list_order_summary}    Get list order summary frm product API    ${list_product}
    ${list_result_tongdh}    Create List
    : FOR    ${item_sl_dh}    ${item_num}    IN ZIP    ${list_result_tongdh}    ${list_num_edit}
    \    ${result_tongdh}    Minus    ${item_sl_dh}    ${item_num}
    \    Append To List    ${list_result_tongdh}    ${result_tongdh}
    #compute invoice info
    ${result_tongtienhang}    Sum values in list    ${list_result_thanhtien}
    ${result_khachcantra}    Run Keyword If    0 < ${get_ggdh_in_dh_bf_execute} < 100    Price after % discount invoice    ${result_tongtienhang}    ${get_ggdh_in_dh_bf_execute}
    ...    ELSE IF    ${get_ggdh_in_dh_bf_execute} > 100    Minus and replace floating point    ${result_tongtienhang}    ${get_ggdh_in_dh_bf_execute}
    ...    ELSE    Set Variable    ${result_tongtienhang}
    ${result_khachcantra_tru_ktt}    Minus and replace floating point    ${result_khachcantra}    ${get_khachdatra_in_dh_bf_execute}
    ${result_ggdh}    Run Keyword If    0 < ${get_ggdh_in_dh_bf_execute} < 100    Convert % discount to VND and round    ${result_tongtienhang}    ${get_ggdh_in_dh_bf_execute}
    ...    ELSE    Set Variable    ${get_ggdh_in_dh_bf_execute}
    ${tamung}    Minus and replace floating point    ${get_khachdatra_in_dh_bf_execute}    ${result_khachcantra}
    ${khtt_all}    Set Variable If    ${get_khachdatra_in_dh_bf_execute} > ${result_khachcantra_tru_ktt}    ${tamung}    ${result_khachcantra_tru_ktt}
    ${result_khtt}    Set Variable If    '${input_khtt}' == 'all'    ${khtt_all}    ${input_khtt}
    ${result_khachdatra_in_dh}    Sum and replace floating point    ${get_khachdatra_in_dh_bf_execute}    ${result_khtt}
    ${result_du_no_hd_KH}    Sum    ${get_no_bf_execute}    ${result_khachcantra}
    ${result_PTT_hd_KH}    Minus        ${result_du_no_hd_KH}    ${result_khtt}
    ${result_tongban_KH}    Sum and replace floating point    ${result_khachcantra}    ${get_tongban_bf_execute}
    #create invoice from order
    Wait Until Keyword Succeeds    3 times    2s    Before Test Ban Hang
    Go to xu ly dat hang    ${order_code}
    Go to BH frm process order    ${order_code}
    ${lastest_num}    Set Variable    0
    : FOR    ${item_product}    ${item_num}    ${item_lo}    IN ZIP    ${list_product}    ${list_num_edit}
    ...    ${list_tenlo_all}
    \    ${item_lo}     Replace sq blackets    ${item_lo}
    \    ${lastest_num}    Input nums for multi product    ${item_product}    ${item_num}    ${lastest_num}    ${cell_lastest_number}
    \    Wait Until Keyword Succeeds    3 times    3s    Close button lot and input lot name for any product    ${item_product}    ${item_lo}
    Run Keyword If    '${input_khtt}' == 'all'    Click Element JS    ${button_bh_thanhtoan}
    ...    ELSE IF    ${get_khachdatra_in_dh_bf_execute} > ${result_khachcantra_tru_ktt}    Wait Until Keyword Succeeds    3 times    20 s    Input customer payment and deposit refund into BH form
    ...    ${result_khtt}
    ...    ELSE    Wait Until Keyword Succeeds    3 times    2s    Input customer payment into BH form    ${input_khtt}
    ...    ${result_khachcantra_tru_ktt}
    ${status}       Run Keyword And Return Status    Should Be Equal    ${list_num}    ${list_num_edit}
    Run Keyword If    '${status}'=='False'    Wait Until Keyword Succeeds    3 times    2s    Click Element JS    ${button_cancel}    ELSE     Log     Ignore
    Invoice message success validation
    ${invoice_code}    Get saved code after execute
    #get value
    Sleep    15s    wait for response to API
    #assert value product in invoice
    ${get_list_hh_in_hd_af_execute}    Get list product frm Invoice API    ${invoice_code}
    ${list_soluong_in_hd}    ${list_giatri_quydoi_in_hd}    Get list quantity and gia tri quy doi by invoice code    ${get_list_hh_in_hd_af_execute}    ${invoice_code}
    : FOR    ${ma_hh}    ${result_toncuoi}    ${item_soluong}    ${get_giatri_quydoi}    IN ZIP    ${get_list_hh_in_hd_af_execute}
    ...    ${result_list_toncuoi}    ${list_soluong_in_hd}    ${list_giatri_quydoi_in_hd}
    \    Run Keyword If    '${get_giatri_quydoi}' == '1'    Validate product history frm API    ${invoice_code}    ${ma_hh}    ${result_toncuoi}
    \    ...    ${item_soluong}
    \    ...    ELSE    Validate unit product history frm API    ${invoice_code}    ${ma_hh}    ${result_toncuoi}
    \    ...    ${item_soluong}    ${get_giatri_quydoi}
    #validate product
    ${list_order_summary_af_execute}    Get list order summary frm product API    ${get_list_hh_in_dh_bf_execute}
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
    Run Keyword If    ${get_khachdatra_in_dh_bf_execute} > ${result_khachcantra_tru_ktt}    Should Be Equal As Numbers    ${get_khachtt_af_execute}    ${result_khachcantra}
    ...    ELSE    Should Be Equal As Numbers    ${get_khachtt_af_execute}    ${result_khachdatra_in_dh}
    Should Be Equal As Strings    ${get_ma_kh_by_hd}    ${input_ma_kh}
    Should Be Equal As Numbers    ${get_gghd_af_execute}    ${result_ggdh}
    Should Be Equal As Strings    ${get_trangthai}    Hoàn thành
    Should Be Equal As Strings    ${get_ghichu_in_hd_af_execute}    ${get_ghichu_bf_execute}
    #assert value order
    ${get_ma_kh_in_dh_af_execute}    ${get_TTDH_in_dh_af_execute}    ${get_tongtienhang_in_dh_af_exxecute}    ${get_khachdatra_in_dh_af_execute}    ${get_giamgia_in_dh_af_execute}    ${get_tongcong_in_dh_af_execute}    ${get_ghichu_in_dh_af_execute}
    ...    Get order info have note incase discount by order code    ${order_code}
    Should Be Equal As Strings    ${get_ma_kh_in_dh_af_execute}    ${input_ma_kh}
    Run Keyword If    '${status}'=='False'      Should Be Equal As Numbers    ${get_TTDH_in_dh_af_execute}    2    ELSE      Should Be Equal As Numbers     ${get_TTDH_in_dh_af_execute}    3
    Should Be Equal As Numbers    ${get_tongtienhang_in_dh_af_exxecute}    ${get_tongtienhang_in_dh_bf_execute}
    Should Be Equal As Numbers    ${get_khachdatra_in_dh_af_execute}    ${result_khachdatra_in_dh}
    Should Be Equal As Numbers    ${get_giamgia_in_dh_af_execute}    ${get_ggdh_in_dh_bf_execute}
    Should Be Equal As Numbers    ${get_tongcong_in_dh_af_execute}    ${get_tongcong_in_dh_bf_execute}
    Should Be Equal As Strings    ${get_ghichu_in_dh_af_execute}    ${get_ghichu_bf_execute}
    Validate invoice history frm Order    ${order_code}    ${invoice_code}    ${result_khachcantra}
    #assert customer and so quy
    ${get_no_af_execute_kh}    ${get_tongban_af_execute_kh}    ${get_tongban_tru_trahang_af_execute_kh}    Run Keyword If    ${input_khtt}!=0    Get Customer Debt from API after purchase    ${input_ma_kh}
    ...    ${invoice_code}    ${result_tongtienhang}
    ...    ELSE    Get Customer Debt from API    ${input_ma_kh}
    ${get_maphieu_soquy}    Get Ma Phieu Thu in So quy    ${invoice_code}
    Run Keyword If    '${input_khtt}' == '0'    Should Be Equal As Numbers    ${get_no_af_execute_kh}    ${result_du_no_hd_KH}
    ...    ELSE    Should Be Equal As Numbers    ${get_no_af_execute_kh}    ${result_PTT_hd_KH}
    Should Be Equal As Numbers    ${get_tongban_af_execute_kh}    ${result_tongban_KH}
    Run Keyword If    '${input_khtt}' == '0'    Validate customer history and debt if invoice is not paid frm order    ${input_ma_kh}    ${invoice_code}    ${result_du_no_hd_KH}
    ...    ELSE    Validate customer history and debt if invoice is paid deposit refund frm order    ${input_ma_kh}    ${invoice_code}    ${result_du_no_hd_KH}    ${result_PTT_hd_KH}
    Run Keyword If    '${result_tongtienhang}' == '0'    Validate history tab of customer frm Order    ${input_ma_kh}    ${invoice_code}
    Run Keyword If    '${input_khtt}' == '0'    Validate So quy info from Rest API if Invoice is not paid    ${get_maphieu_soquy}
    ...    ELSE    Validate So quy info from Rest API if Invoice is paid    ${get_maphieu_soquy}    ${result_khtt}
    #Assert onhand values in tab stock card lo
    ${list_num_instockard}    Change negative number to positive number and vice versa in List    ${list_num_edit}
    : FOR    ${item_product}    ${item_num}    ${item_onhand_lo}    ${item_list_lo}    ${item_actual_product}    IN ZIP
    ...    ${list_product}    ${list_num_instockard}    ${listl_onhand_lo_af_ex}    ${list_tenlo_all}    ${list_product}
    \    Assert values in Stock Card in tab Lo - HSD    ${invoice_code}    ${item_actual_product}    ${item_product}    ${item_onhand_lo}    ${item_num}
    \    ...    ${item_list_lo}
    #
    : FOR    ${item_product}    ${item_onhand_lo}    ${item_list_lo}    ${item_actual_product}    IN ZIP    ${list_product}
    ...    ${listl_onhand_lo_af_ex}    ${list_tenlo_all}    ${list_product}
    \    ${result_tonkho_lo}    Get Onhand Lot in tab Lo - HSD frm API    ${item_product}    ${item_list_lo}
    \    Should Be Equal As Numbers    ${item_onhand_lo}    ${result_tonkho_lo}
