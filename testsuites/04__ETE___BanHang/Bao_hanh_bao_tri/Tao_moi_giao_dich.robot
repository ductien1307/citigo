*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}      ${headless_browser}
Test Teardown     After Test
Resource          ../../../core/Ban_Hang/banhang_action.robot
Resource          ../../../core/share/toast_message.robot
Resource          ../../../core/Ban_Hang/banhang_getandcompute.robot
Resource          ../../../core/share/imei.robot
Resource          ../../../core/Ban_Hang/banhang_navigation.robot
Resource          ../../../core/API/api_danhmuc_hanghoa.robot
Resource          ../../../core/API/api_baohanh_baotri.robot
Resource          ../../../core/API/api_khachhang.robot
Resource          ../../../core/API/api_hoadon_banhang.robot
Resource          ../../../core/API/api_soquy.robot
Resource          ../../../core/So_Quy/so_quy_list_action.robot
Resource          ../../../config/env_product/envi.robot
Resource          ../../../core/share/list_dictionary.robot
Resource          ../../../core/API/api_dathang.robot
Resource          ../../../core/API/api_mhbh.robot
Resource          ../../../core/API/api_mhbh_dathang.robot
Resource          ../../../core/API/api_access.robot

*** Variables ***
&{invoice_1}      HBH02=5    SIBH02=2    DVTBH01=3    CBBH01=1    DVBH02=3
&{discount_1}     HBH02=5    SIBH02=40000    DVTBH01=150000    CBBH01=0    DVBH02=180000
&{discount_type1}    HBH02=dis    SIBH02=disvnd    DVTBH01=changeup    CBBH01=none    DVBH02=changedown
&{product_type1}    HBH02=pro    SIBH02=imei    DVTBH01=pro    CBBH01=com    DVBH02=ser
&{imei}           SIBH02=2

*** Test Cases ***    Product and num list    Product Type        Product Discount    Discount Type        Invoice Discount    Customer    Payment
Them moi hoa don      [Tags]                  EBW         GOLIVE1_A     CTP  BHBT
                      [Template]              bhbt01
                      [Documentation]   MHBH - BÁN HÀNG BẢO HÀNH BẢO TRÌ
                      ${invoice_1}            ${product_type1}    ${discount_1}       ${discount_type1}    0                   CTKH075     0          ${imei}

*** Keywords ***
bhbt01
    [Arguments]    ${dict_product_num}    ${dict_product_type}    ${dict_discount}    ${dict_discount_type}    ${input_invoice_discount}    ${input_bh_ma_kh}
    ...    ${input_bh_khachtt}    ${list_imei}
    [Timeout]
    ${list_products}    Get Dictionary Keys    ${dict_product_num}
    ${list_nums}    Get Dictionary Values    ${dict_product_num}
    ${list_product_type}    Get Dictionary Values    ${dict_product_type}
    ${list_discount_product}    Get Dictionary Values    ${dict_discount}
    ${list_discount_type}    Get Dictionary Values    ${dict_discount_type}
    ${list_unit}    Get list of keys from dictionary by value    ${dict_product_type}    unit
    ${list_imei_product}    Get list of keys from dictionary by value    ${dict_product_type}    imei
    ${list_unit_quan}=    Get list of values from dictionary by list of keys    ${dict_product_num}    ${list_unit}
    ${get_no_bf_execute}    ${get_tongban_bf_execute}    ${get_tongban_tru_trahang_bf_execute}    Get Customer Debt from API    ${input_bh_ma_kh}
    Log    Create list imei for imei products
    ${list_imei_all}    create list
    : FOR    ${item_product}    ${item_num}    ${item_product_type}    IN ZIP    ${list_products}    ${list_nums}
    ...    ${list_product_type}
    \    ${list_imei_by_single_product}=    Run Keyword If    '${item_product_type}' == 'imei'    Import multi imei for product    ${item_product}    ${item_num}
    \    ...    ELSE    Set Variable    nonimei
    \    Append to List    ${list_imei_all}    ${list_imei_by_single_product}
    Log    ${list_imei_all}
    ${list_imei_for_validation}    Copy list    ${list_imei_all}
    Remove values From List    ${list_imei_for_validation}    nonimei
    Log    Get Data
    ${list_product_for_validation}    ${list_product_quan_for_validation}    ${list_product_type_for_validation}    Remove combo and unit from validation lists    ${list_products}    ${list_nums}    ${list_product_type}
    ${list_product_for_validation}    ${list_product_quan_for_validation}    ${list_product_type_for_validation}    Extract combo and unit products for validation lists    ${list_products}    ${list_nums}    ${list_product_type}
    ...    ${list_product_for_validation}    ${list_product_quan_for_validation}    ${list_product_type_for_validation}
    ${list_result_thanhtien}    ${list_result_newprice}    Get list of total sale - result new price incase changing product price    ${list_products}    ${list_nums}    ${list_discount_product}    ${list_discount_type}
    ${list_result_ton_af_ex}    Get list of result onhand incase changing product price    ${list_product_for_validation}    ${list_product_quan_for_validation}
    Log    Input data into BH form
    Wait Until Keyword Succeeds    5 times     3s    Before Test Ban Hang deactivate print warranty
    ${lastest_num}    Set Variable    0
    : FOR    ${item_product}    ${item_product_type}    ${item_num}    ${item_list_imei}    ${item_discount}    ${item_discount_type}
    ...    ${item_newprice}    IN ZIP    ${list_products}    ${list_product_type}    ${list_nums}    ${list_imei_all}
    ...    ${list_discount_product}    ${list_discount_type}    ${list_result_newprice}
    \    ${lastest_num}=    Run Keyword If    '${item_product_type}' == 'imei'    Input products - IMEIs and validate lastest number in BH form    ${item_product}    ${item_num}
    \    ...    ${item_list_imei}    ${lastest_num}    ELSE    Input product-num in BH form    ${item_product}    ${item_num}    ${lastest_num}
    \    Run keyword if    '${item_discount_type}' == 'dis'    Wait Until Keyword Succeeds    3 times    5 s    Input % discount for product
    \    ...    ${item_discount}    ${item_newprice}
    \    ...    ELSE IF    '${item_discount_type}' == 'disvnd'    Wait Until Keyword Succeeds    3 times    5 s
    \    ...    Input vnd discount for product    ${item_discount}    ${item_newprice}
    \    ...    ELSE IF    '${item_discount_type}' == 'changeup' or '${item_discount_type}' == 'changedown'    Wait Until Keyword Succeeds    3 times    5 s
    \    ...    Input new price of product    ${item_discount}
    \    ...    ELSE    Log    ignore
    ${result_tongtienhang}    Sum values in list    ${list_result_thanhtien}
    Validate UI Total Invoice value    ${result_tongtienhang}
    ${result_khachcantra}=    Run Keyword If    0 < ${input_invoice_discount} < 100    Price after % discount invoice    ${result_tongtienhang}    ${input_invoice_discount}
    ...    ELSE IF    ${input_invoice_discount} > 100    Minus    ${result_tongtienhang}    ${input_invoice_discount}
    ...    ELSE    Set Variable    ${result_tongtienhang}
    ${result_discount_invoice}    Run Keyword If    0 < ${input_invoice_discount} < 100    Convert % discount to VND and round    ${result_tongtienhang}    ${input_invoice_discount}
    ...    ELSE    Set Variable    ${input_invoice_discount}
    ${actual_khachtt}    Set Variable If    '${input_bh_khachtt}' == 'all'    ${result_khachcantra}    ${input_bh_khachtt}
    ${result_no_hoadon}    Minus    ${result_khachcantra}    ${actual_khachtt}
    ${result_nohientai}    sum    ${result_no_hoadon}    ${get_no_bf_execute}
    ${result_tongban}    Sum    ${result_khachcantra}    ${get_tongban_bf_execute}
    Run Keyword If    0 < ${input_invoice_discount} < 100    Wait Until Keyword Succeeds    3 times    8 s    Input % discount invoice    ${input_invoice_discount}
    ...    ${result_discount_invoice}
    ...    ELSE IF    ${input_invoice_discount} > 100    Input VND discount invoice    ${input_invoice_discount}
    ...    ELSE    Log    Ignore discount
    Run Keyword If    '${input_bh_khachtt}' == 'all'    Input Khach Hang    ${input_bh_ma_kh}
    ...    ELSE    Input Invoice info    ${input_bh_ma_kh}    ${input_bh_khachtt}    ${result_khachcantra}
    Click Element JS    ${button_bh_thanhtoan}
    Invoice message success validation
    ${invoice_code}    Get saved code after execute
    Log    assert values in Hoa don
    Assert Invoice until success    ${invoice_code}       ${input_invoice_discount}     ${result_tongtienhang}     ${result_khachcantra}      ${actual_khachtt}
    ...       ${input_bh_ma_kh}       ${result_discount_invoice}
    Log    Assert value in Warranty
    ${get_list_product_in_warranty}    ${list_nums_in_warranty}    Get list product and nums for warranty    ${list_products}    ${list_nums}    ${list_product_type}
    ${get_list_time_bh_in_pro}    ${get_list_timetype_bh_in_pro}    ${get_list_time_bt_in_pro}    ${get_list_timetype_bt_in_pro}    Get list warranty from product API    ${get_list_product_in_warranty}
    Assert value in Warranty    ${get_list_product_in_warranty}    ${input_bh_ma_kh}    ${invoice_code}    ${list_nums_in_warranty}    ${get_list_time_bh_in_pro}    ${get_list_timetype_bh_in_pro}
    ...    ${get_list_time_bt_in_pro}    ${get_list_timetype_bt_in_pro}
    Log    Assert value warranty in invoice
    ${list_time_bh_in_inv}    ${list_timetype_bh_inv}    ${list_time_bt_in_inv}    ${list_timetype_bt_in_inv}    Get list guarranty info frm invoice API    ${invoice_code}    ${get_list_product_in_warranty}
    : FOR    ${get_time_bh_inv}    ${get_timetype_bh_inv}    ${get_time_bt_in_inv}    ${get_timetype_bt_in_inv}    ${get_time_bh_in_pro}    ${get_timetype_bh_in_pro}
    ...    ${get_time_bt_in_pro}    ${get_timetype_bt_in_pro}    ${product_type}    IN ZIP    ${list_time_bh_in_inv}    ${list_timetype_bh_inv}
    ...    ${list_time_bt_in_inv}    ${list_timetype_bt_in_inv}    ${get_list_time_bh_in_pro}    ${get_list_timetype_bh_in_pro}    ${get_list_time_bt_in_pro}    ${ get_list_timetype_bt_in_pro}
    ...    ${list_product_type}
    \    Assert multi value in guarantee    ${get_time_bh_inv}    ${get_timetype_bh_inv}    ${get_time_bh_in_pro}    ${get_timetype_bh_in_pro}
    \    Should Be Equal As Numbers    ${get_time_bt_in_inv}    ${get_time_bt_in_pro}
    \    Should Be Equal As Numbers    ${get_timetype_bt_in_inv}    ${get_timetype_bt_in_pro}
    Log    Assert values in product list and stock card
    Assert list of Onhand after execute in case having multi-product types    ${list_product_for_validation}    ${list_product_type_for_validation}    ${list_result_ton_af_ex}
    ${list_num_instockcard}    Change negative number to positive number and vice versa in List    ${list_product_quan_for_validation}
    : FOR    ${item_product}    ${item_product_type}    ${item_num_instockcard}    ${item_result_onhand}    ${item_imei_by_pr}    IN ZIP
    ...    ${list_product_for_validation}    ${list_product_type_for_validation}    ${list_num_instockcard}    ${list_result_ton_af_ex}    ${list_imei_all}
    \    Run Keyword If    '${item_product_type}' == 'ser'    Assert values in Stock Card incase service product    ${invoice_code}    ${item_product}    ${item_num_instockcard}
    \    ...    ELSE    Assert values in Stock Card    ${invoice_code}    ${item_product}    ${item_result_onhand}
    \    ...    ${item_num_instockcard}
    Log    assert imei
    : FOR    ${item_product}    ${item_imei_by_pr}    IN ZIP    ${list_imei_product}    ${list_imei_for_validation}
    \    Assert imei not avaiable in SerialImei tab    ${item_product}    @{item_imei_by_pr}
    Log    assert value in tab cong no khach hang
    ${get_maphieu_soquy}    Get Ma Phieu Thu in So quy    ${invoice_code}
    Run Keyword If    '${input_bh_khachtt}' == '0'    Validate status in Tab No can thu tu khach if Invoice is not paid until success    ${input_bh_ma_kh}    ${invoice_code}
    ...    ELSE    Validate status in Tab No can thu tu khach if Invoice is paid until success    ${input_bh_ma_kh}    ${get_maphieu_soquy}    ${invoice_code}
    Log    assert values in Khach hang and So quy
    ${get_no_af_purchase}    ${get_tongban_af_purchase}    ${get_tongban_tru_trahang_af_purchase}    Get Customer Debt from API after purchase    ${input_bh_ma_kh}    ${invoice_code}    ${actual_khachtt}
    Should Be Equal As Numbers    ${result_nohientai}    ${get_no_af_purchase}
    # Should Be Equal As Numbers    ${result_tongban}    ${get_tongban_af_purchase}
    Run Keyword If    '${input_bh_khachtt}' == '0'    Validate So quy info from Rest API if Invoice is not paid until success    ${get_maphieu_soquy}
    ...    ELSE    Validate So quy info from Rest API if Invoice is paid until success    ${get_maphieu_soquy}    ${actual_khachtt}
    Delete invoice by invoice code    ${invoice_code}
