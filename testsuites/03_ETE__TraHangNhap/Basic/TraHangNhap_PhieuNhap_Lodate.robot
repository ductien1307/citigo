*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}      ${headless_browser}
Test Setup
Test Teardown     After Test
Resource          ../../../core/API/api_phieu_nhap_hang.robot
Resource          ../../../core/Giao_dich/tra_hang_nhap_list_page.robot
Resource          ../../../core/Giao_dich/tra_hang_nhap_list_action.robot
Resource          ../../../core/API/api_danhmuc_hanghoa.robot
Resource          ../../../core/API/api_nha_cung_cap.robot
Resource          ../../../core/API/api_tra_hang_nhap.robot
Resource          ../../../core/Giao_dich/nhaphang_getandcompute.robot
Resource          ../../../core/share/toast_message.robot
Resource          ../../../core/API/api_soquy.robot
Resource          ../../../core/API/api_dathangnhap.robot
Resource          ../../../core/share/lodate.robot

*** Variables ***
&{dict_pr}        LDQD019=15     LDQD020=6.8      LDQD021=3.25     TRLD022=4.5      TRLD023=7.5
&{dict_pr_return}    LDQD019=11.5      LDQD020=3.5     LDQD021=3.25     TRLD022=4.5      TRLD023=2.75
&{dict_cost}      LDQD019=40000    LDQD020=45000    LDQD021=50000    TRLD022=45000    TRLD023=48000
&{dict_discount_type_for_import}        LDQD019=VND     LDQD020=VND    LDQD021=%    TRLD022=VND    TRLD023=VND
&{dict_discount_value_for_import}       LDQD019=0    LDQD020=0    LDQD021=0    TRLD022=0   TRLD023=0
&{dict_discountvalue}      LDQD019=5000    LDQD020=0    LDQD021=10    TRLD022=34500    TRLD023=80000
&{dict_discounttype}       LDQD019=disvnd    LDQD020=none    LDQD021=dis    TRLD022=changedown    TRLD023=changeup
&{dict_type}       LDQD019=unit    LDQD020=unit    LDQD021=unit    TRLD022=loda    TRLD023=loda

*** Test Cases ***     Product Code and Quantity     Product Type       Product Cost       Discount type Import      Discount Value Import        Discount Value        Discount Type         Purchase return Discount         Payment       Supplier Code
Tao DL mau
    [Tags]          LTHNPN            ULODA
    [Template]    Add du lieu
    lodate_unit    TRLD019      DHC ADLAY EXTRA     trackingld    75000    5000    none    none    none    none    none    Cai     LDQD019    140000    Hop    2
    lodate_unit    TRLD020    son BBIA màu 01    trackingld    75000    5000    none    none    none    none    none    Cai     LDQD020    140000    Hop    3
    lodate_unit   TRLD021      Mứt xoài sấy      trackingld    75000    5000    none    none    none    none    none    Cai     LDQD021    140000    Hop    4
    lodate_unit    TRLD022    son BBIA màu 02    trackingld    75000    5000    none    none    none    none    none    Cai     LDQD022    140000    Hop    5
    lodate_unit   TRLD023      Mứt dâu tây sấy     trackingld    70000    5000    none    none    none    none    none    Cai     LDQD023    140000    Hop    2

Tra Hang Nhap tai Phieu Nhap Hang
    [Tags]          LTHNPN            ULODA
    [Template]      Tra Hang Nhap tai Phieu Nhap Hang
    ${dict_pr}    ${dict_pr_return}      ${dict_type}     ${dict_cost}      ${dict_discount_type_for_import}      ${dict_discount_value_for_import}       ${dict_discountvalue}      ${dict_discounttype}       0        500000         NCC0001

*** Keywords ***
Add du lieu
    [Documentation]    tao DL
    [Arguments]    ${loai_hh}    ${ma_hh}    ${ten_sp}    ${nhom_hang}    ${gia_ban}    ${gia_von}    ${ton}     ${sp_1}   ${sl_1}   ${sp_2}   ${sl_2}    ${dvcb}    ${ma_hh_qd}    ${giaban2}    ${dvqd}    ${giatriqd}
    Wait Until Keyword Succeeds    3x    1s    Delete product if product is visible thr API    ${ma_hh}
    Wait Until Keyword Succeeds    3x    1s    Add product for tracking by product type thr API    ${loai_hh}    ${ma_hh}    ${ten_sp}    ${nhom_hang}    ${gia_ban}    ${gia_von}    ${ton}     ${sp_1}   ${sl_1}   ${sp_2}   ${sl_2}    ${dvcb}    ${ma_hh_qd}    ${giaban2}    ${dvqd}    ${giatriqd}

Tra Hang Nhap tai Phieu Nhap Hang
    [Arguments]      ${dict_products}       ${dict_product_return}      ${dict_product_type}        ${dict_cost}        ${dict_discount_type_import}      ${dict_discount_value_import}       ${dict_discountvalue}      ${dict_discounttype}      ${return_discount}         ${input_paid_supplier}       ${supplier_code}
    ${list_products}    Get Dictionary Keys    ${dict_products}
    ${list_nums}    Get Dictionary Values    ${dict_products}
    ${list_nums_return}    Get Dictionary Values    ${dict_product_return}
    ${list_cost}    Get Dictionary Values    ${dict_cost}
    ${list_product_types}      Get Dictionary Values       ${dict_product_type}
    ${list_product_discount_types_import}      Get Dictionary Values       ${dict_discount_type_import}
    ${list_discount_values_import}      Get Dictionary Values       ${dict_discount_value_import}
    ${list_product_discount}      Get Dictionary Values       ${dict_discountvalue}
    ${list_product_discount_type}       Get Dictionary Values         ${dict_discounttype}
    ${list_unit}       Get list of keys from dictionary by value    ${dict_product_type}      unit
    ${purchase_return_code}      Generate code automatically       THNR
    ${list_all_lots}     Create lits lot for list products    ${list_products}    ${list_nums}
    #
    ${get_supplier_id}    Add supplier by supplier code    ${supplier_code}
    #
    ${list_cost_af_discount_imported}        ${purchase_code}       Import lodate product    ${list_products}    ${list_nums}    ${list_cost}     ${list_product_discount_types_import}      ${list_discount_values_import}      ${list_product_types}      ${list_all_lots}      ${supplier_code}
    ${list_product_for_validation}    ${list_product_quan_for_validation}    ${list_product_type_for_validation}    Remove combo and unit from validation lists    ${list_products}    ${list_nums_return}    ${list_product_types}
    ${list_product_for_validation}    ${list_product_quan_for_validation}    ${list_product_type_for_validation}    Extract combo and unit products for validation lists    ${list_products}    ${list_nums_return}    ${list_product_types}
    ...    ${list_product_for_validation}    ${list_product_quan_for_validation}    ${list_product_type_for_validation}
    ${list_lot_for_validation}     Change the position of lots in validation list    ${list_products}    ${list_nums_return}      ${list_product_types}     ${list_all_lots}
    Log       Get Data
    #tính list tồn sau khi trả hàng
    ${list_result_ton_af_ex}        Get list of result onhand incase changing product price    ${list_product_for_validation}    ${list_product_quan_for_validation}
    ${list_result_thanhtien}      ${list_result_newprice}    Get list of total purchase return - result new price incase having imported products     ${list_products}    ${list_cost}       ${list_nums_return}    ${list_product_discount}      ${list_product_discount_type}
    ${result_tongtienhang}      ${result_discount_vnd}      ${paid_supplier_value}      ${actual_supplier_payment}     Conputation total, discount and pay for supplier    ${list_result_thanhtien}     ${return_discount}     ${input_paid_supplier}
    Log    tính tổng nợ, tổng mua của nhà cung cấp af ex
    ${result_no_ncc}     ${result_tongmua}     ${result_tongmua_tru_trahang}    Supplier debt calculation af purchase return    ${supplier_code}    ${paid_supplier_value}      ${actual_supplier_payment}     Đã trả hàng
    #
    Before Test Import Product
    Wait Until Keyword Succeeds    3 times    3 s    Click Purchase Return button from Import Product Form      ${purchase_code}
    Log      Input data into BH form
    Add product and input value incase THN with PN lodate    ${list_products}    ${list_nums_return}    ${list_product_discount}    ${list_product_discount_type}    ${list_result_newprice}    ${list_all_lots}    ${list_product_types}
    Run Keyword If   '${return_discount}' != '0'   Wait Until Keyword Succeeds    3 times    3 s    Input VND Discount for Purchase Return and validate value from Purchase form       ${return_discount}        ELSE    Log    No Operation
    Run Keyword If    ${input_paid_supplier} != 0    Wait Until Keyword Succeeds     3 times   1s      Input paid for supplier and validate    ${input_paid_supplier}    ${paid_supplier_value}
    Input purchase return Code    ${purchase_return_code}
    Click Element    ${button_nh_hoanthanh}
    Purchase return message success validation    ${purchase_return_code}
    Log       assert values in Hoa don
    Assert values by purchaser return code until succeed    ${purchase_return_code}    ${result_tongtienhang}    ${paid_supplier_value}    ${actual_supplier_payment}    Hoàn thành
    Log        Assert values in product list and stock card
    Assert list of Onhand after execute in case having multi-product types      ${list_product_for_validation}    ${list_product_type_for_validation}       ${list_result_ton_af_ex}
    #chuyển từ số âm > dương và ngược lại (so sánh số lượng trong thẻ kho- thường là số âm) - số lượng trong thẻ kho
    ${list_num_instockcard}    Change negative number to positive number and vice versa in List    ${list_product_quan_for_validation}
    : FOR    ${item_product}    ${item_num_instockcard}    ${item_result_onhand}    ${item_lot}    IN ZIP    ${list_product_for_validation}     ${list_num_instockcard}
    ...    ${list_result_ton_af_ex}    ${list_lot_for_validation}
    \    Assert values in Stock Card    ${purchase_return_code}    ${item_product}    ${item_result_onhand}    ${item_num_instockcard}
    # $ actual_prs và item_prs thông thường có thể khác nhau nhưng trong trường hợp này đã đc extra và lấy gtri hàng cb nên nó giống nhau
    \    Assert values in Stock Card in tab Lo - HSD for basic and unit prs    ${purchase_return_code}    ${item_product}    ${item_product}    ${item_result_onhand}    ${item_num_instockcard}    ${item_lot}
    #
    Validate status in Tab No can tra NCC incase purchase return    ${supplier_code}    ${purchase_return_code}    ${actual_supplier_payment}
    Assert Cong no Nha cung cap    ${supplier_code}    ${result_no_ncc}    ${result_tongmua}
    Validate So quy info from API    ${purchase_return_code}    ${paid_supplier_value}    ${actual_supplier_payment}    Trả hàng nhập
    Delete supplier    ${get_supplier_id}
