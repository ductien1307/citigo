*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}      ${headless_browser}
Test Teardown     After Test
Resource          ../../../../config/env_product/envi.robot
Resource          ../../../../core/Doi_Tac/doitac_navigation.robot
Resource          ../../../../core/Doi_Tac/khachhang_list_action.robot
Resource          ../../../../core/Doi_Tac/khachhang_list_page.robot
Resource          ../../../../core/API/api_khachhang.robot
Resource          ../../../../core/share/toast_message.robot
Resource          ../../../../core/API/api_dathang.robot
Resource          ../../../../core/API/api_hoadon_banhang.robot
Resource          ../../../../core/API/api_danhmuc_hanghoa.robot
Resource          ../../../../core/API/api_mhbh.robot
Resource          ../../../../core/API/api_mhbh_dathang.robot
Resource          ../../../../core/API/api_soquy.robot
Resource          ../../../../core/share/discount.robot
Resource          ../../../../prepare/Hang_hoa/Sources/doitac.robot

*** Variables ***
&{list_prs_num_invoice}    CNKH01=1
&{list_prs_num_order}    CNKHCB01=1    QDCNKH02=2
@{list_prs_order_del}    QDCNKH02
@{discount}    5     50000
@{discount_type}    dis     changeup


*** Test Cases ***    Mã KH       Tên KH            List products invoice      List product order       List prodcut del             List discount      List discount type     Discount invoice         Payment to invoice    Thanh toán dư
Dat hang               [Tags]      UPBKH
                      [Template]    uiphanbo1
                      KHPBCN1     Khách công nợ 1     ${list_prs_num_invoice}      ${list_prs_num_order}    ${list_prs_order_del}       ${discount}     ${discount_type}          10000                  200000                  50000

*** Keywords ***
uiphanbo1
    [Arguments]    ${input_ma_kh}    ${input_ten_kh}    ${list_product_invoice}    ${list_product_order}   ${list_product_delete}    ${list_ggsp}   ${list_discount_type}
    ...   ${input_ggdh}   ${input_khtt_tocreate_invoice}   ${input_thanhtoandu}
    ##delete customer
    ${get_customer_id}    Get customer id thr API    ${input_ma_kh}
    Run Keyword If    '${get_customer_id}' == '0'    Log    Ignore delete     ELSE      Delete customer    ${get_customer_id}
    Sleep    1s
    ## create customer
    ${date_current}   Get Current Date      result_format=%Y-%m-%d
    Add customer with birthday    ${input_ma_kh}    ${input_ten_kh}    ${date_current}
    Sleep    2s
    ${ma_hd}  Add new invoice - payment surplus frm API    ${input_ma_kh}    ${list_product_invoice}    ${input_khtt_tocreate_invoice}
    ${order_code}   Add new order incase discount - no payment    ${input_ma_kh}    ${input_ggdh}    ${list_product_order}    ${list_ggsp}    ${list_discount_type}
    ${get_no_bf_execute}    ${get_tongban_bf_execute}    ${get_tongban_tru_trahang_bf_execute}    ${get_customer_name}    Get Customer Info from API    ${input_ma_kh}
    ${get_list_hh_in_dh_bf_execute}    ${get_ghichu_bf_execute}    Get ghi chu and list product frm API    ${order_code}
    #get order summary and sub total of products
    : FOR    ${ma_hh}   IN    @{list_product_delete}
    \    Remove Values From List    ${get_list_hh_in_dh_bf_execute}    ${ma_hh}
    Log    ${get_list_hh_in_dh_bf_execute}
    ${get_list_quantity_in_dh_bf_ex}    ${get_list_discount_in_dh_bf_ex}   Get list quantity and discount by order code    ${order_code}    ${get_list_hh_in_dh_bf_execute}
    ${list_result_tongdh}    ${result_list_toncuoi}    ${result_list_thanhtien}   ${list_result_giamoi}    Get list order summary - total sale - ending stocks incase discount    ${order_code}    ${get_list_hh_in_dh_bf_execute}    ${get_list_discount_in_dh_bf_ex}
    ##compute cong no khac hang
    ${result_tongtienhang}    Sum values in list    ${result_list_thanhtien}
    ${result_TTH_tru_gghd}   Minus and replace floating point    ${result_tongtienhang}   ${input_ggdh}
    ${result_khtt}    Sum and replace floating point     ${result_TTH_tru_gghd}    ${input_thanhtoandu}
    ##phan bo hoa don
    ${result_phanbo_hoadon}   Sum    ${input_khtt_tocreate_invoice}       ${input_thanhtoandu}
    ##du no khach hang
    ${result_du_no_hd_KH}    Sum    ${get_no_bf_execute}    ${result_TTH_tru_gghd}
    ${result_PTT_hd_KH}    Minus and replace floating point    ${result_du_no_hd_KH}    ${result_khtt}
    ${result_tongban_KH}    Sum and replace floating point    ${result_TTH_tru_gghd}    ${get_tongban_bf_execute}
    #create invoice frm Order API
    Wait Until Keyword Succeeds    3 times    20 s    Before Test Ban Hang
    Go to xu ly dat hang    ${order_code}
    Go to BH frm process order    ${order_code}
    Delete list product into BH form    ${list_product_delete}
    Wait Until Keyword Succeeds    3 times    20 s    Input customer surplus payment and validate    ${textbox_bh_khachtt}    ${result_khtt}    ${input_thanhtoandu}
    Apply surplus payment    ${ma_hd}    ${input_thanhtoandu}
    Click Element JS    ${button_bh_thanhtoan}
    Wait Until Page Contains Element    ${button_cancel}    2 mins
    Wait Until Keyword Succeeds    3 times    20 s    Click Element JS    ${button_cancel}    #tắt popup kết thúc đơn ĐH
    ${invoice_code}    Get saved code after execute
    Sleep    20 s    wait for response to API
    #assert value product in invoice
    ${get_list_hh_in_hd_af_execute}    Get list product frm Invoice API    ${invoice_code}
    ${list_soluong_in_hd}    ${list_giatri_quydoi_in_hd}    Get list quantity and gia tri quy doi by invoice code    ${get_list_hh_in_hd_af_execute}    ${invoice_code}
    : FOR    ${ma_hh}    ${result_toncuoi}    ${item_soluong}    ${get_giatri_quydoi}    IN ZIP    ${get_list_hh_in_hd_af_execute}
    ...    ${result_list_toncuoi}    ${list_soluong_in_hd}    ${list_giatri_quydoi_in_hd}
    \    Run Keyword If    '${get_giatri_quydoi}' == '1'    Validate product history frm API    ${invoice_code}    ${ma_hh}    ${result_toncuoi}
    \    ...    ${item_soluong}
    \    ...    ELSE    Validate unit product history frm API    ${invoice_code}    ${ma_hh}    ${result_toncuoi}   ${item_soluong}    ${get_giatri_quydoi}
    ##validate invoice allocate
    ${get_maphieu_soquy}    Get Ma Phieu Thu in So quy    ${invoice_code}
    ${get_khachtt_af_allocate}    ${get_ptt_af_allocate}    Get invoice info after allocate     ${ma_hd}    ${get_maphieu_soquy}
    Should Be Equal As Numbers    ${get_khachtt_af_allocate}    ${result_phanbo_hoadon}
    Should Be Equal As Numbers    ${get_ptt_af_allocate}    ${input_thanhtoandu}
    #assert customer and so quy
    ${get_no_af_execute_kh}    ${get_tongban_af_execute_kh}    ${get_tongban_tru_trahang_af_execute_kh}    Get Customer Debt from API after purchase    ${input_ma_kh}    ${invoice_code}    ${result_khtt}
    Should Be Equal As Numbers    ${get_no_af_execute_kh}    ${result_PTT_hd_KH}
    Should Be Equal As Numbers    ${get_tongban_af_execute_kh}    ${result_tongban_KH}
    Run Keyword If    '${result_tongtienhang}' == '0'    Validate history tab of customer frm Order    ${input_ma_kh}    ${invoice_code}
    Validate customer history and debt if invoice is paid frm order    ${input_ma_kh}    ${invoice_code}    ${result_du_no_hd_KH}    ${result_PTT_hd_KH}
    Validate So quy info from Rest API if Invoice is paid    ${get_maphieu_soquy}    ${result_khtt}
    Delete invoice by invoice code    ${ma_hd}
    Delete invoice by invoice code    ${invoice_code}
    Delete order frm Order code       ${order_code}
    ${get_customer_id}    Get Customer ID    ${input_ma_kh}
    Delete customer    ${get_customer_id}
