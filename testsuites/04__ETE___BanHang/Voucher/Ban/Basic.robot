*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}      ${headless_browser}
Test Setup        Before Test Ban Hang
Test Teardown     After Test
Resource          ../../../../core/Ban_Hang/banhang_action.robot
Resource          ../../../../core/Ban_Hang/banhang_getandcompute.robot
Resource          ../../../../core/Ban_Hang/banhang_page.robot
Resource          ../../../../core/share/toast_message.robot
Resource          ../../../../core/Ban_Hang/banhang_navigation.robot
Resource          ../../../../core/API/api_danhmuc_hanghoa.robot
Resource          ../../../../core/API/api_khachhang.robot
Resource          ../../../../core/API/api_hoadon_banhang.robot
Resource          ../../../../core/API/api_soquy.robot
Resource          ../../../../core/So_Quy/so_quy_list_action.robot
Resource          ../../../../config/env_product/envi.robot
Resource          ../../../../core/share/list_dictionary.robot
Resource          ../../../../core/share/discount.robot
Resource          ../../../../core/API/api_thietlap.robot

*** Variables ***
&{dict_nor1}      PIB10014=2    PIB10015=1
&{dict_discount_nor1}      PIB10014=200000    PIB10015=400000
&{dict_discount1_nor1}      PIB10014=none    PIB10015=none
&{dict_nor2}      PIB10014=3    PIB10015=2

*** Test Cases ***    Product and num list    Product Discount                                                Invoice Discount    Customer    Payment    Voucher Issue         Voucher code value
Vocher Ban
                      [Tags]                  CBVB                VOB           UEB
                      [Template]              ebvs01
                      ${dict_nor1}            ${dict_discount_nor1}                                               50000            KH013               0           VOUCHER003        350000
                      ${dict_nor1}            ${dict_discount_nor1}                                               5            KH014               all           VOUCHER003         400000
                      ${dict_nor1}            ${dict_discount_nor1}                                               50000            KH015               50000           VOUCHER003      450000


*** Keywords ***
ebvs01
    [Arguments]    ${dict_product_num}    ${dict_newprice}    ${input_invoice_discount}    ${input_bh_ma_kh}    ${input_bh_khachtt}    ${input_voucher_issue}      ${voucher_pub_value}
    [Timeout]
    ## Get info ton cuoi, cong no khach hang
    Add new voucher code    ${input_voucher_issue}     1
    ${list_product}    Get Dictionary Keys    ${dict_product_num}
    ${list_nums}    Get Dictionary Values    ${dict_product_num}
    ${list_newprice}    Get Dictionary Values    ${dict_newprice}
    ${get_no_bf_execute}    ${get_tongban_bf_execute}    ${get_tongban_tru_trahang_bf_execute}    Get Customer Debt from API    ${input_bh_ma_kh}
    #create voucher list
    ${item_voucher_toapply}        ${voucher_value}      ${voucher_minimum_invoicetotal}      Add new voucher and publish by API    ${input_voucher_issue}    1       ${voucher_pub_value}       1
    Reload page
    ${list_result_thanhtien}    ${list_result_onhand_af_ex}    Get list of total sale - result onhand in case of price change    ${list_product}    ${list_nums}    ${list_newprice}
    ${lastest_num}    Set Variable    0
    : FOR    ${item_product}    ${item_num}    ${item_newprice}    IN ZIP    ${list_product}    ${list_nums}
    ...    ${list_newprice}
    \    Input product-num-new price in BH form    ${item_product}    ${item_num}    ${item_newprice}    ${lastest_num}
    ${result_tongtienhang}    Sum values in list    ${list_result_thanhtien}
    ${result_khachcantra}=    Run Keyword If    0 < ${input_invoice_discount} < 100    Price after % discount invoice    ${result_tongtienhang}    ${input_invoice_discount}
    ...    ELSE IF    ${input_invoice_discount} > 100    Minus    ${result_tongtienhang}    ${input_invoice_discount}
    ...    ELSE    Set Variable    ${result_tongtienhang}
    ${result_discount_invoice}    Run Keyword If    0 < ${input_invoice_discount} < 100    Convert % discount to VND and round    ${result_tongtienhang}    ${input_invoice_discount}
    ...    ELSE    Set Variable    ${input_invoice_discount}
    ${result_khachcantra_af_apply_voucher}        Minus        ${result_khachcantra}      ${voucher_value}
    ${actual_khachtt}    Set Variable If    '${input_bh_khachtt}' == 'all'    ${result_khachcantra_af_apply_voucher}    ${input_bh_khachtt}
    ${result_ktt_incl_voucher}      Sum      ${voucher_value}      ${actual_khachtt}
    ${result_no_hoadon}    Minus    ${result_khachcantra}    ${actual_khachtt}
    ${result_no_hoadon}    Minus    ${result_no_hoadon}     ${voucher_value}
    ${result_nohientai}    sum    ${result_no_hoadon}    ${get_no_bf_execute}
    ${result_tongban}    Sum    ${result_khachcantra}    ${get_tongban_bf_execute}
    Input Khach Hang    ${input_bh_ma_kh}
    Run Keyword If    0 < ${input_invoice_discount} < 100    Wait Until Keyword Succeeds    3 times    8 s    Input % discount invoice    ${input_invoice_discount}
    ...    ${result_discount_invoice}
    ...    ELSE IF    ${input_invoice_discount} > 100    Input VND discount invoice    ${input_invoice_discount}
    ...    ELSE    Log    Ignore invoice discount
    Go to popup for other payment methods
    Wait Until Keyword Succeeds    3 times    3 s     Apply voucher    ${item_voucher_toapply}
    ${khachtt_forinput}       Convert To String    ${actual_khachtt}
    Apply Cash    ${khachtt_forinput}
    Wait Until Page Contains Element    ${button_finish_otherpaymentmethod_popup}
    Click Element JS    ${button_finish_otherpaymentmethod_popup}
    Click Element JS    ${button_bh_thanhtoan}
    Invoice message success validation
    ${invoice_code}    Get saved code after execute
    #get values
    Sleep    20 s    wait for response to API
    #assert values in Hoa don
    ${get_ma_kh_by_hd}    ${get_tong_tien_hang}    ${get_khach_tt}    ${get_giamgia_hd}    ${get_khachcantra}    ${get_trangthai}    Get invoice info incase discount by invoice code
    ...    ${invoice_code}
    Should Be Equal As Numbers    ${get_tong_tien_hang}    ${result_tongtienhang}
    Should Be Equal As Numbers    ${result_khachcantra}    ${get_khachcantra}
    Should Be Equal As Numbers    ${get_khach_tt}    ${result_ktt_incl_voucher}
    Should Be Equal As Strings    ${get_ma_kh_by_hd}    ${input_bh_ma_kh}
    Should Be Equal As Numbers    ${get_giamgia_hd}    ${result_discount_invoice}
    Should Be Equal As Strings    ${get_trangthai}    Hoàn thành
    #Assert values in product list and stock card
    Assert list of Onhand after execute    ${list_product}    ${list_result_onhand_af_ex}
    #assert value in tab cong no khach hang
    ${get_maphieu_soquy}    Get Ma Phieu Thu in So quy    ${invoice_code}
    Run Keyword If    '${input_bh_khachtt}' == '0'    Validate status in Tab No can thu tu khach if Invoice is not paid until success    ${input_bh_ma_kh}    ${invoice_code}
    ...    ELSE    Validate status in Tab No can thu tu khach if Invoice is paid until success    ${input_bh_ma_kh}    ${get_maphieu_soquy}    ${invoice_code}
    #assert values in Khach hang and So quy
    ${get_no_af_purchase}    ${get_tongban_af_purchase}    ${get_tongban_tru_trahang_af_purchase}    Get Customer Debt from API in case apply Voucher after execute     ${input_bh_ma_kh}    ${invoice_code}    ${actual_khachtt}
    Should Be Equal As Numbers    ${result_nohientai}    ${get_no_af_purchase}
    Should Be Equal As Numbers    ${result_tongban}    ${get_tongban_af_purchase}
    Run Keyword If    '${input_bh_khachtt}' == '0'    Validate So quy info from Rest API if Invoice is not paid until success    ${get_maphieu_soquy}
    ...    ELSE    Validate So quy info from Rest API if Invoice is paid until success    ${get_maphieu_soquy}    ${actual_khachtt}
    Reload Page
