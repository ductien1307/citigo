*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}      ${headless_browser}
Test Teardown     After Test
Resource          ../../../../config/env_product/envi.robot
Resource          ../../../../core/Doi_Tac/doitac_navigation.robot
Resource          ../../../../core/Doi_Tac/khachhang_list_action.robot
Resource          ../../../../core/Doi_Tac/khachhang_list_page.robot
Resource          ../../../../core/API/api_khachhang.robot
Resource          ../../../../core/share/toast_message.robot
Resource          ../../../../core/share/discount.robot
Resource          ../../../../core/API/api_dathang.robot
Resource          ../../../../core/Ban_Hang/banhang_page.robot
Resource          ../../../../core/API/api_hoadon_banhang.robot
Resource          ../../../../core/API/api_danhmuc_hanghoa.robot
Resource          ../../../../core/API/api_mhbh.robot
Resource          ../../../../core/API/api_mhbh_dathang.robot
Resource          ../../../../core/API/api_soquy.robot
Resource          ../../../../core/share/imei.robot
Resource          ../../../../prepare/Hang_hoa/Sources/doitac.robot

*** Variables ***
&{list_prs_num_invoice1}    CNKHS01=1
&{list_prs_num_invoice2}    CNKHDV01=3
@{discount}    20000
@{discount_type}    disvnd


*** Test Cases ***    Mã KH        Tên KH         List products invoice 1     List products invoice 2      List discount      List discount type     Payment to invoice    Thanh toán dư
Thanh toan du         [Tags]      UPBKH
                      [Template]    uiphanbo2
                      KHPBCN2     Khách công nợ 2      ${list_prs_num_invoice1}      ${list_prs_num_invoice2}      ${discount}          ${discount_type}    500000                  100000

*** Keywords ***
uiphanbo2
    [Arguments]    ${input_ma_kh}    ${input_ten_kh}    ${list_product_invoice1}    ${list_product_invoice2}    ${list_ggsp}   ${list_discount_type}
    ...   ${input_khtt_tocreate_invoice}   ${input_thanhtoandu}
    Set Selenium Speed    0.5s
    ##delete customer
    ${get_customer_id}    Get customer id thr API    ${input_ma_kh}
    Run Keyword If    '${get_customer_id}' == '0'    Log    Ignore delete     ELSE      Delete customer    ${get_customer_id}
    Sleep    1s
    ## create customer
    ${date_current}   Get Current Date      result_format=%Y-%m-%d
    Add customer with birthday    ${input_ma_kh}    ${input_ten_kh}    ${date_current}
    Sleep    2s
    ${ma_hd}  Add new invoice - payment surplus frm API    ${input_ma_kh}    ${list_product_invoice1}    ${input_khtt_tocreate_invoice}
    ${get_no_bf_execute}    ${get_tongban_bf_execute}    ${get_tongban_tru_trahang_bf_execute}    ${get_customer_name}    Get Customer Info from API    ${input_ma_kh}
    ${list_product}   Get Dictionary Keys    ${list_product_invoice2}
    ${list_nums}   Get Dictionary Values    ${list_product_invoice2}
    #get order summary and sub total of products
    ${result_list_toncuoi}    ${result_list_thanhtien}    Get list total sale - endingstock incase discount by product list    ${list_product}    ${list_nums}    ${list_ggsp}
    ${get_list_baseprice}   Get list of Baseprice by Product Code    ${list_product}
    ##compute cong no khac hang
    ${result_tongtienhang}    Sum values in list    ${result_list_thanhtien}
    ${result_khtt}    Sum and replace floating point    ${result_tongtienhang}    ${input_thanhtoandu}
    ##phan bo hoa don
    ${result_khachdatra}   Sum    ${input_khtt_tocreate_invoice}       ${input_thanhtoandu}
    ##du no khach hang
    ${result_du_no_hd_KH}    Sum    ${get_no_bf_execute}    ${result_tongtienhang}
    ${result_PTT_hd_KH}    Minus and replace floating point    ${result_du_no_hd_KH}    ${result_khtt}
    ${result_tongban_KH}    Sum and replace floating point    ${result_tongtienhang}    ${get_tongban_bf_execute}
    #create invoice frm Order API
    Before Test Ban Hang
    Log      Input data into BH form
    ${lastest_num}    Set Variable    0
    : FOR    ${item_product}       ${item_num}    ${item_discount}      ${item_discount_type}     ${item_price}    IN ZIP    ${list_product}
    ...    ${list_nums}    ${list_ggsp}    ${list_discount_type}          ${get_list_baseprice}
    \    ${item_newprice}=    Run Keyword If    '${item_discount_type}' == 'dis'    Price after % discount product    ${item_price}    ${item_discount}
    \    ...    ELSE IF    '${item_discount_type}' == 'disvnd'    Minus    ${item_price}    ${item_discount}
    \    ...    ELSE IF    '${item_discount_type}' == 'changeup' or '${item_discount_type}' == 'changedown'    Set Variable    ${item_discount}
    \    ...    ELSE    Set Variable    ${item_price}
    \    ${lastest_num}=        Input product-num in BH form    ${item_product}    ${item_num}      ${lastest_num}
    \    Run keyword if    '${item_discount_type}' == 'dis'    Wait Until Keyword Succeeds    3 times    5 s    Input % discount for product    ${item_discount}    ${item_newprice}
    \    ...    ELSE IF    '${item_discount_type}' == 'disvnd'    Wait Until Keyword Succeeds    3 times    5 s    Input vnd discount for product    ${item_discount}    ${item_newprice}
    \    ...    ELSE IF     '${item_discount_type}' == 'changeup' or '${item_discount_type}' == 'changedown'  Wait Until Keyword Succeeds    3 times    5 s    Input new price of product    ${item_discount}        ELSE       Log        ignore
    Input Khach Hang    ${input_ma_kh}
    Wait Until Page Contains Element    ${textbox_bh_khachtt}    1 min
    Wait Until Keyword Succeeds    3 times    20 s    Input customer surplus payment and validate    ${textbox_bh_khachtt}    ${result_khtt}    ${input_thanhtoandu}
    Apply surplus payment    ${ma_hd}    ${input_thanhtoandu}
    Click Element JS    ${button_bh_thanhtoan}
    Invoice message success validation
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
    Should Be Equal As Numbers    ${get_khachtt_af_allocate}    ${result_khachdatra}
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
    ${get_customer_id}    Get Customer ID    ${input_ma_kh}
    Delete customer    ${get_customer_id}
