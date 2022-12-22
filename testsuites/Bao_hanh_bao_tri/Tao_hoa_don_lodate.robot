*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}      ${headless_browser}
Test Teardown     After Test
Resource          ../../core/Ban_Hang/banhang_action.robot
Resource          ../../core/share/toast_message.robot
Resource          ../../core/Ban_Hang/banhang_getandcompute.robot
Resource          ../../core/share/imei.robot
Resource          ../../core/Ban_Hang/banhang_navigation.robot
Resource          ../../core/API/api_danhmuc_hanghoa.robot
Resource          ../../core/API/api_baohanh_baotri.robot
Resource          ../../core/API/api_khachhang.robot
Resource          ../../core/API/api_hoadon_banhang.robot
Resource          ../../core/API/api_soquy.robot
Resource          ../../core/So_Quy/so_quy_list_action.robot
Resource          ../../config/env_product/envi.robot
Resource          ../../core/share/list_dictionary.robot
Resource          ../../core/API/api_dathang.robot
Resource          ../../core/API/api_mhbh.robot
Resource          ../../core/API/api_mhbh_dathang.robot
Resource          ../../core/API/api_access.robot
Resource          ../../core/API/api_dathangnhap.robot
Resource          ../../core/share/lodate.robot
Resource          ../../core/API/api_tra_hang_nhap.robot

*** Variables ***
&{invoice_1}      LDQD024=15     LDQD025=6.8      LDQD026=3.25     TRLD027=4.5      TRLD028=7.5
&{discount_1}     LDQD024=5      LDQD025=10000    LDQD026=85000    TRLD027=0        TRLD028=22222
&{discount_type1}    LDQD024=dis  LDQD025=disvnd    LDQD026=changeup    TRLD027=none    TRLD028=changedown
&{product_type1}    LDQD024=unit    LDQD025=unit    LDQD026=unit        TRLD027=loda    TRLD028=loda

*** Test Cases ***    Mã hàng            Tên hàng                  Nhóm           giaban     dvcb      tendv1         gtqd1     giaban1      ma_hh1      time_bh     timetype_bh  time_bt   timetype_bt
Tao DL mau
                      [Tags]             LHDBH            ULODA
                      [Template]    Add du lieu bhbt
                      TRLD024            Hàng đvt bảo hành 01      trackingld    20000     cái      hộp tự gen       4        280000      LDQD024      50             2        3        2
                      TRLD025            Hàng đvt bảo hành 02      trackingld    25000     chiếc    hộp tự gen       3        180000      LDQD025      12             2        4        2
                      TRLD026            Hàng đvt bảo hành 03      trackingld    35000     chiếc    hộp tự gen       3        150000      LDQD026      2              2        1        2
                      TRLD027            Hàng đvt bảo hành 04      trackingld    40000     cái      hộp tự gen       4        280000      LDQD027      60             2        5        2
                      TRLD028            Hàng đvt bảo hành 05      trackingld    35000     chiếc    hộp tự gen       3        180000      LDQD028      24             2        2        2

Them moi hoa don      [Tags]          LHDBH            ULODA      
                      [Template]      bhbt_lodate
                      ${invoice_1}    ${product_type1}     ${discount_1}    ${discount_type1}    0     KHLD04     0

*** Keywords ***
Add du lieu bhbt
    [Documentation]    tao DL
    [Arguments]      ${ui_product_code}    ${ten}    ${ten_nhom}    ${giaban}    ${dvcb}    ${tendv1}    ${gtqd1}    ${giaban1}    ${ma_hh1}    ${time_bh}    ${timetype_bh}    ${time_bt}    ${timetype_bt}
    Wait Until Keyword Succeeds    3x    1s    Delete product if product is visible thr API    ${ui_product_code}
    Wait Until Keyword Succeeds    3x    1s    Create lodate product have genuine guarantees    ${ui_product_code}    ${ten}    ${ten_nhom}    ${giaban}    ${dvcb}    ${tendv1}    ${gtqd1}    ${giaban1}    ${ma_hh1}    ${time_bh}    ${timetype_bh}    ${time_bt}    ${timetype_bt}

bhbt_lodate
    [Arguments]    ${dict_product_num}    ${dict_product_type}    ${dict_discount}    ${dict_discount_type}    ${input_invoice_discount}    ${input_bh_ma_kh}
    ...    ${input_bh_khachtt}
    [Timeout]
    ${list_products}    Get Dictionary Keys    ${dict_product_num}
    ${list_nums}    Get Dictionary Values    ${dict_product_num}
    ${list_product_type}    Get Dictionary Values    ${dict_product_type}
    ${list_discount_product}    Get Dictionary Values    ${dict_discount}
    ${list_discount_type}    Get Dictionary Values    ${dict_discount_type}
    ${list_unit}    Get list of keys from dictionary by value    ${dict_product_type}    unit
    ${list_unit_quan}=    Get list of values from dictionary by list of keys    ${dict_product_num}    ${list_unit}
    ${get_id_kh}    ${get_ten_kh}    ${get_dienthoai_kh}    ${get_diachi_kh}    Create new customer and get info    ${input_bh_ma_kh}
    #
    ${list_all_lo}     Create lits lot for list products    ${list_products}    ${list_nums}
    #đổi vị trí sắp xếp các lô do thay đổi vị trí hàng hóa
    ${list_lots_for_validation}     Change the position of lots in validation list    ${list_products}    ${list_nums}      ${list_product_type}     ${list_all_lo}
    Log    Get Data
    ${list_product_for_validation}    ${list_product_quan_for_validation}    ${list_product_type_for_validation}    Remove combo and unit from validation lists    ${list_products}    ${list_nums}    ${list_product_type}
    ${list_product_for_validation}    ${list_product_quan_for_validation}    ${list_product_type_for_validation}    Extract combo and unit products for validation lists    ${list_products}    ${list_nums}    ${list_product_type}
    ...    ${list_product_for_validation}    ${list_product_quan_for_validation}    ${list_product_type_for_validation}
    ${list_result_thanhtien}    ${list_result_newprice}    Get list of total sale - result new price incase changing product price    ${list_products}    ${list_nums}    ${list_discount_product}    ${list_discount_type}
    ${list_result_ton_af_ex}    Get list of result onhand incase changing product price    ${list_product_for_validation}    ${list_product_quan_for_validation}
    Log    Input data into BH form
    Wait Until Keyword Succeeds    3 times     3s    Before Test Ban Hang deactivate print warranty
    Add lodate product in MHBH    ${list_products}    ${list_product_type}    ${list_nums}    ${list_all_lo}    ${list_discount_product}    ${list_discount_type}    ${list_result_newprice}
    ${result_tongtienhang}    ${result_khachcantra}    ${result_discount_invoice}     ${actual_khachtt}      ${result_nohientai}     ${result_tongban}    Computation total, discount and pay for customer incase lodate warranty invoice    ${input_bh_ma_kh}     ${list_result_thanhtien}    ${input_invoice_discount}    ${input_bh_khachtt}
    Input invoice discount    ${input_invoice_discount}    ${result_discount_invoice}
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
    Assert value warranty in invoice    ${invoice_code}    ${get_list_product_in_warranty}    ${list_product_type}
    Log    Assert values in product list and stock card and tab lot
    Assert list of Onhand after execute in case having multi-product types    ${list_product_for_validation}    ${list_product_type_for_validation}    ${list_result_ton_af_ex}
    ${list_num_instockcard}    Change negative number to positive number and vice versa in List    ${list_product_quan_for_validation}
    : FOR    ${item_product}    ${item_product_type}    ${item_num_instockcard}    ${item_result_onhand}    ${item_lot}    IN ZIP
    ...    ${list_product_for_validation}    ${list_product_type_for_validation}    ${list_num_instockcard}    ${list_result_ton_af_ex}    ${list_lots_for_validation}
    \    Assert values in Stock Card    ${invoice_code}    ${item_product}    ${item_result_onhand}    ${item_num_instockcard}
    \    Assert values in Stock Card in tab Lo - HSD for basic and unit prs    ${invoice_code}    ${item_product}    ${item_product}    ${item_result_onhand}    ${item_num_instockcard}    ${item_lot}
    Log    assert value in tab cong no khach hang
    Assert value in tab cong no khach hang    ${invoice_code}    ${input_bh_ma_kh}    ${result_nohientai}    ${result_tongban}    ${input_bh_khachtt}    ${actual_khachtt}
    Delete invoice by invoice code    ${invoice_code}
