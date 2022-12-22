*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}      ${headless_browser}
Test Setup        Before Test BH co giao hang
Test Teardown     After Test
Library           SeleniumLibrary
Library           Collections
Resource          ../../../core/API/api_khachhang.robot
Resource          ../../../core/Ban_Hang/banhang_getandcompute.robot
Resource          ../../../core/Ban_Hang/banhang_action.robot
Resource          ../../../core/share/toast_message.robot
Resource          ../../../core/Giao_Van/giao_hang_popup_action.robot
Resource          ../../../core/Giao_Van/giao_hang_nav.robot
Resource          ../../../core/API/api_soquy.robot

*** Variables ***
&{invoice_1}      GHT0001=5.6    GHIM01=4        GHU0001=2       GHC0001=1       GHDV001=3
&{discount_1}      GHT0001=5    GHIM01=4000     GHU0001=0       GHC0001=190000       GHDV001=20
&{discount_type1}      GHT0001=dis    GHIM01=disvnd   GHU0001=none       GHC0001=changedown       GHDV001=dis
&{product_type1}      GHT0001=pro    GHIM01=imei     GHU0001=unit       GHC0001=com       GHDV001=ser

*** Test Cases ***
Golive
    [Tags]         GOLIVE1_A    UEB    EBG
    [Template]              gh_5loaisp
    ${invoice_1}      ${product_type1}          ${discount_1}         ${discount_type1}          20          CTKH003       all    DT00003    20000    Chờ xử lý

*** Keywords ***
gh_5loaisp
    [Arguments]    ${dict_product_num}    ${dict_product_type}      ${dict_discount}      ${dict_discount_type}      ${input_invoice_discount}    ${input_bh_ma_kh}    ${input_bh_khachtt}    ${input_ma_dtgh}    ${input_phi_gh}    ${trangthaigh}
    ${list_products}    Get Dictionary Keys    ${dict_product_num}
    ${list_nums}    Get Dictionary Values    ${dict_product_num}
    ${list_product_type}    Get Dictionary Values    ${dict_product_type}
    ${list_discount_product}    Get Dictionary Values    ${dict_discount}
    ${list_discount_type}    Get Dictionary Values    ${dict_discount_type}
    ${list_unit}       Get list of keys from dictionary by value    ${dict_product_type}      unit
    ${list_imei_product}       Get list of keys from dictionary by value    ${dict_product_type}      imei
    ${list_unit_quan}=       Get list of values from dictionary by list of keys    ${dict_product_num}    ${list_unit}
    ${get_no_bf_execute}    ${get_tongban_bf_execute}    ${get_tongban_tru_trahang_bf_execute}    Get Customer Debt from API    ${input_bh_ma_kh}
    Log      Create list imei for imei products
    ${list_imei_all}    create list
    : FOR    ${item_product}     ${item_num}    ${item_product_type}    IN ZIP    ${list_products}    ${list_nums}      ${list_product_type}
    \    ${list_imei_by_single_product}=      Run Keyword If    '${item_product_type}' == 'imei'      Import multi imei for product    ${item_product}    ${item_num}      ELSE      Set Variable    nonimei
    \    Append to List       ${list_imei_all}        ${list_imei_by_single_product}
    Log       ${list_imei_all}
    ${list_imei_for_validation}      Copy list      ${list_imei_all}
    Remove values From List      ${list_imei_for_validation}        nonimei
    Log       Get Data
    ${list_product_for_validation}       ${list_product_quan_for_validation}     ${list_product_type_for_validation}       Remove combo and unit from validation lists    ${list_products}    ${list_nums}    ${list_product_type}
    ${list_product_for_validation}       ${list_product_quan_for_validation}     ${list_product_type_for_validation}       Extract combo and unit products for validation lists        ${list_products}    ${list_nums}    ${list_product_type}       ${list_product_for_validation}       ${list_product_quan_for_validation}     ${list_product_type_for_validation}
    ${list_result_ton_af_ex}        Get list of result onhand incase changing product price    ${list_product_for_validation}    ${list_product_quan_for_validation}
    ${list_result_thanhtien}      ${list_result_newprice}    Get list of total sale - result new price incase changing product price    ${list_products}    ${list_nums}    ${list_discount_product}      ${list_discount_type}
    #
    ${get_tong_hd_bf_purchase}    ${get_no_hientai_bf_purchase}    ${get_tong_phi_gh_bf_purchase}    Get cong no DTGH frm API    ${input_ma_dtgh}
    ${get_ten_kh_bf_execute}    ${get_dienthoai_kh_bf_execute}    ${get_diachi_kh_bf_execute}    ${get_khuvuc_kh_bf_execute}    ${get_phuongxa_kh_bf_execute}    Get info customer frm API    ${input_bh_ma_kh}
    #
    Reload Page
    Log      Input data into BH form
    ${lastest_num}    Set Variable    0
    : FOR    ${item_product}     ${item_product_type}       ${item_num}        ${item_list_imei}    ${item_discount}      ${item_discount_type}     ${item_newprice}    IN ZIP    ${list_products}       ${list_product_type}
    ...    ${list_nums}    ${list_imei_all}       ${list_discount_product}    ${list_discount_type}      ${list_result_newprice}
    \    ${lastest_num}=        Run Keyword If    '${item_product_type}' == 'imei'    Input products - IMEIs and validate lastest number in BH form    ${item_product}    ${item_num}      ${item_list_imei}    ${lastest_num}     ELSE      Input product-num in BH form    ${item_product}    ${item_num}      ${lastest_num}
    \    Run keyword if    '${item_discount_type}' == 'dis'    Wait Until Keyword Succeeds    3 times    5 s    Input % discount for product    ${item_discount}    ${item_newprice}
    \    ...    ELSE IF    '${item_discount_type}' == 'disvnd'    Wait Until Keyword Succeeds    3 times    5 s    Input vnd discount for product    ${item_discount}    ${item_newprice}
    \    ...    ELSE IF     '${item_discount_type}' == 'changeup' or '${item_discount_type}' == 'changedown'  Wait Until Keyword Succeeds    3 times    5 s    Input new price of product    ${item_discount}        ELSE       Log        ignore
    ${result_tongtienhang}    Sum values in list    ${list_result_thanhtien}
    Validate UI Total Invoice value    ${result_tongtienhang}
    ${result_khachcantra}=    Run Keyword If    0 < ${input_invoice_discount} < 100    Price after % discount invoice    ${result_tongtienhang}    ${input_invoice_discount}
    ...    ELSE IF    ${input_invoice_discount} > 100    Minus    ${result_tongtienhang}    ${input_invoice_discount}
    ...    ELSE    Set Variable    ${result_tongtienhang}
    ${result_discount_invoice}    Run Keyword If    0 < ${input_invoice_discount} < 100    Convert % discount to VND and round    ${result_tongtienhang}    ${input_invoice_discount}
    ...    ELSE    Set Variable    ${input_invoice_discount}
    ${actual_khachtt}    Set Variable If    '${input_bh_khachtt}' == 'all'    ${result_khachcantra}    ${input_bh_khachtt}
    ${actual_khachtt}    Replace floating point    ${actual_khachtt}
    ${result_no_hoadon}    Minus    ${result_khachcantra}    ${actual_khachtt}
    ${result_nohientai}    sum    ${result_no_hoadon}    ${get_no_bf_execute}
    ${result_tongban}    Sum    ${result_khachcantra}    ${get_tongban_bf_execute}
    Run Keyword If    0 < ${input_invoice_discount} < 100    Wait Until Keyword Succeeds    3 times    8 s    Input % discount invoice    ${input_invoice_discount}
    ...    ${result_discount_invoice}
    ...    ELSE IF    ${input_invoice_discount} > 100    Input VND discount invoice    ${input_invoice_discount}
    ...    ELSE    Log    Ignore discount
    ${result_tong_hd_DTGH}    ${resul_tong_phi_gh_DTGH}    ${resul_no_cantra_hientai_DTGH}    ${result_no_hientai_in_tab_congno_DTGH}    Computation Cong no DTGH    ${input_ma_dtgh}    ${input_phi_gh}
    #input infor delivery
    Input Khach Hang    ${input_bh_ma_kh}
    ${status}    Run Keyword And Return Status    Element Should Be Enabled    //label[@id='deliveryCheckbox']//input[contains(@class,'ng-empty')]
    Run Keyword If    '${status}'=='True'    Click Element JS    ${checkbox_delivery}
    ...    ELSE    Log    Ignore checkbox
    Input data in DTGH popup    ${input_ma_dtgh}    ${input_phi_gh}    ${trangthaigh}    ${result_khachcantra}
    Wait Until Keyword Succeeds    3 times    20 s    Input customer payment and validate    ${textbox_bh_khachtt}    ${actual_khachtt}    ${result_khachcantra}
    Click Element JS    ${button_bh_thanhtoan}
    #
    Invoice message success validation
    ${invoice_code}    Get saved code after execute
    Assert values by invoice code until succeed    ${invoice_code}    ${result_khachcantra}    ${result_tongtienhang}    ${input_bh_ma_kh}    ${actual_khachtt}    ${result_discount_invoice}     Đang xử lý
    Assert invoice summary values until succeed    ${invoice_code}     ${input_bh_ma_kh}     ${result_tongtienhang}    ${result_discount_invoice}    ${result_khachcantra}      ${actual_khachtt}    Đang xử lý
    #assert delivery invoice
    ${get_trangthai_gh_af_execute}    ${get_khachcantra_in_hd_af_execute}    Get delivery status frm Invoice    ${invoice_code}
    Assert delivery info not time in invoice    ${invoice_code}    ${get_ten_kh_bf_execute}    ${get_dienthoai_kh_bf_execute}    ${get_diachi_kh_bf_execute}    ${get_khuvuc_kh_bf_execute}    ${get_phuongxa_kh_bf_execute}
    ...    ${input_ma_dtgh}    500    ${input_phi_gh}
    #
    ${get_tong_hd_af_purchase}    ${get_no_hientai_af_purchase}    ${get_tong_phi_gh_af_purchase}    Get cong no DTGH frm API    ${input_ma_dtgh}
    Run Keyword If    '${get_trangthai_gh_af_execute}' == '1' or '${get_trangthai_gh_af_execute}' == '6'    Validate partnerdelivery if TTGH is Chua giao hang or Da huy    ${input_ma_dtgh}    ${invoice_code}    ${input_phi_gh}
    ...    ELSE    Validate partnerdelivery if TTGH is not Chua giao hang or Da huy    ${input_ma_dtgh}    ${invoice_code}    ${input_phi_gh}    ${result_no_hientai_in_tab_congno_DTGH}
    #assert công nợ ĐTGH
    Should Be Equal As Numbers    ${get_tong_hd_af_purchase}    ${result_tong_hd_DTGH}
    Should Be Equal As Numbers    ${get_tong_phi_gh_af_purchase}    ${resul_tong_phi_gh_DTGH}
    Run Keyword If    '${get_trangthai_gh_af_execute}' == '1'    Validate no can tra hien tai if phi giao hang bang 0    ${get_no_hientai_bf_purchase}    ${get_no_hientai_af_purchase}
    ...    ELSE    Validate no can tra hien tai if phi giao hang khac 0    ${get_no_hientai_bf_purchase}    ${get_no_hientai_af_purchase}    ${input_phi_gh}
    #
    Log       assert value in tab cong no khach hang
    ${get_maphieu_soquy}    Get Ma Phieu Thu in So quy    ${invoice_code}
    Run Keyword If    '${input_bh_khachtt}' == '0'    Validate status in Tab No can thu tu khach if Invoice is not paid until success    ${input_bh_ma_kh}    ${invoice_code}
    ...    ELSE    Validate status in Tab No can thu tu khach if Invoice is paid until success    ${input_bh_ma_kh}    ${get_maphieu_soquy}    ${invoice_code}
    Log        assert values in Khach hang and So quy
    ${get_no_af_purchase}    ${get_tongban_af_purchase}    ${get_tongban_tru_trahang_af_purchase}    Get Customer Debt from API after purchase    ${input_bh_ma_kh}    ${invoice_code}    ${actual_khachtt}
    Should Be Equal As Numbers    ${result_nohientai}    ${get_no_af_purchase}
    Should Be Equal As Numbers    ${result_tongban}    ${get_tongban_af_purchase}
    Run Keyword If    '${input_bh_khachtt}' == '0'    Validate So quy info from Rest API if Invoice is not paid until success    ${get_maphieu_soquy}
    ...    ELSE    Validate So quy info from Rest API if Invoice is paid until success    ${get_maphieu_soquy}    ${actual_khachtt}
    Delete invoice by invoice code    ${invoice_code}
