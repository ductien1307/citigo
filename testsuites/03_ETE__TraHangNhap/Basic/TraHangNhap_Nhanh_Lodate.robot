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
&{dict_pr}        LDQD013=3.5      LDQD014=6.5      TRLD015=4
&{dict_pr1}        LDQD016=4.5      TRLD017=2.5      TRLD018=5
&{dict_cost}      LDQD013=40000    LDQD014=45000    TRLD015=50000
&{dict_cost1}      LDQD016=45000    TRLD017=48000    TRLD018=49500
&{dict_discount_type_for_import}        LDQD013=VND     LDQD014=VND    TRLD015=%
&{dict_discount_type_for_import1}        LDQD016=VND     TRLD017=VND    TRLD018=VND
&{dict_discount_value_for_import}       LDQD013=5000    LDQD014=0    TRLD015=5
&{dict_discount_value_for_import1}       LDQD016=15000   TRLD017=22500    TRLD018=0
&{dict_discountvalue}      LDQD013=5000    LDQD014=0    TRLD015=10
&{dict_discountvalue1}      LDQD016=35000    TRLD017=80000    TRLD018=0
&{dict_discounttype}       LDQD013=disvnd    LDQD014=none    TRLD015=dis
&{dict_discounttype1}       LDQD016=changedown    TRLD017=changeup    TRLD018=none
&{dict_type}       LDQD013=unit    LDQD014=unit    TRLD015=loda
&{dict_type_prs}       LDQD016=unit    TRLD017=loda    TRLD018=loda


*** Test Cases ***     Product Code and Quantity     Product Type       Product Cost       Discount type Import      Discount Value Import        Discount Value        Discount Type         Purchase return Discount         Payment       Supplier Code
Tao DL mau
    [Tags]          LTHNN1            ULODA
    [Template]    Add du lieu tra hang nhap theo hd
    lodate_unit    TRLD013      DHC ADLAY EXTRA     trackingld    75000    5000    none    none    none    none    none    Cai     LDQD013    140000    Hop    2
    lodate_unit    TRLD014      son BBIA màu #01    trackingld    75000    5000    none    none    none    none    none    Cai     LDQD014    140000    Hop    3
    lodate_unit    TRLD015      Mứt xoài sấy dẻo     trackingld    75000    5000    none    none    none    none    none    Cai     LDQD015    140000    Hop    4
    lodate_unit    TRLD016      son BBIA màu #02    trackingld    75000    5000    none    none    none    none    none    Cai     LDQD016    140000    Hop    5
    lodate_unit    TRLD017      Mứt dâu tây sấy     trackingld    70000    5000    none    none    none    none    none    Cai     LDQD017    140000    Hop    2
    lodate_unit    TRLD018      son BBIA màu #03     trackingld    70000    5000    none    none    none    none    none    Cai     LDQD018    140000    Hop    3

Tra Hang Nhap Nhanh khi da co PNH co thanh toan
    [Tags]          LTHNN            ULODA
    [Template]      Tra Hang Nhap Nhanh Lodate
    ${dict_pr}    ${dict_type}     ${dict_cost}      ${dict_discount_type_for_import}      ${dict_discount_value_for_import}       ${dict_discountvalue}      ${dict_discounttype}       0        500000         NCCN0001
    ${dict_pr1}    ${dict_type_prs}     ${dict_cost1}      ${dict_discount_type_for_import1}      ${dict_discount_value_for_import1}       ${dict_discountvalue1}      ${dict_discounttype1}       0        0              NCCN0001

Tra Hang Nhap Nhanh khi da co PNH co thanh toan
    [Tags]          gggg
    [Template]      Tra Hang Nhap Nhanh Lodate
    ${dict_pr}    ${dict_type}     ${dict_cost}      ${dict_discount_type_for_import}      ${dict_discount_value_for_import}       ${dict_discountvalue}      ${dict_discounttype}       0        500000         NCCN0001


*** Keywords ***
Add du lieu tra hang nhap theo hd
    [Documentation]    tao DL
    [Arguments]    ${loai_hh}    ${ma_hh}    ${ten_sp}    ${nhom_hang}    ${gia_ban}    ${gia_von}    ${ton}     ${sp_1}   ${sl_1}   ${sp_2}   ${sl_2}    ${dvcb}    ${ma_hh_qd}    ${giaban2}    ${dvqd}    ${giatriqd}
    Wait Until Keyword Succeeds    3x    1s    Delete product if product is visible thr API    ${ma_hh}
    Wait Until Keyword Succeeds    3x    1s    Add product for tracking by product type thr API    ${loai_hh}    ${ma_hh}    ${ten_sp}    ${nhom_hang}    ${gia_ban}    ${gia_von}    ${ton}     ${sp_1}   ${sl_1}   ${sp_2}   ${sl_2}    ${dvcb}    ${ma_hh_qd}    ${giaban2}    ${dvqd}    ${giatriqd}

Tra Hang Nhap Nhanh Lodate
    [Arguments]      ${dict_pr}       ${dict_product_type}        ${dict_cost}        ${dict_discount_type_import}      ${dict_discount_value_import}       ${dict_discountvalue}      ${dict_discounttype}      ${return_discount}         ${input_paid_supplier}       ${supplier_code}
    ${list_products}    Get Dictionary Keys    ${dict_pr}
    ${list_nums}    Get Dictionary Values    ${dict_pr}
    ${list_cost}    Get Dictionary Values    ${dict_cost}
    ${list_product_types}      Get Dictionary Values       ${dict_product_type}
    ${list_product_discount_types_import}      Get Dictionary Values       ${dict_discount_type_import}
    ${list_discount_values_import}      Get Dictionary Values       ${dict_discount_value_import}
    ${list_product_discount}      Get Dictionary Values       ${dict_discountvalue}
    ${list_product_discount_type}       Get Dictionary Values         ${dict_discounttype}
    ${purchase_return_code}      Generate code automatically       THNR
    Before Test Tra Hang Nhap
    #tạo mới NCC
    ${get_supplier_id}    Add supplier by supplier code    ${supplier_code}
    #tạo lô cho hàng hóa
    ${list_all_lo}     Create lits lot for list products    ${list_products}    ${list_nums}
    ##
    ${list_cost_af_discount_imported}        ${purchase_code}       Import lodate product    ${list_products}    ${list_nums}    ${list_cost}     ${list_product_discount_types_import}      ${list_discount_values_import}      ${list_product_types}      ${list_all_lo}      ${supplier_code}
    ${list_product_for_validation}    ${list_product_quan_for_validation}    ${list_product_type_for_validation}    Remove combo and unit from validation lists    ${list_products}    ${list_nums}    ${list_product_types}
    ${list_product_for_validation}    ${list_product_quan_for_validation}    ${list_product_type_for_validation}    Extract combo and unit products for validation lists    ${list_products}    ${list_nums}    ${list_product_types}
    ...    ${list_product_for_validation}    ${list_product_quan_for_validation}    ${list_product_type_for_validation}
    # đổi vị trí sắp xếp các lô do thay đổi vị trí hàng hóa
    ${list_lot_for_validation}     Change the position of lots in validation list    ${list_products}    ${list_nums}      ${list_product_types}     ${list_all_lo}
    Log    Get Data
    #tính list tồn sau khi trả hàng
    ${list_result_ton_af_ex}        Get list of result onhand incase changing product price    ${list_product_for_validation}    ${list_product_quan_for_validation}
    ${list_result_thanhtien}      ${list_result_newprice}    Get list of total purchase return - result new price incase having imported products     ${list_products}    ${list_cost}       ${list_nums}    ${list_product_discount}      ${list_product_discount_type}
    ${result_tongtienhang}      ${result_discount_vnd}      ${paid_supplier_value}      ${actual_supplier_payment}     Conputation total, discount and pay for supplier    ${list_result_thanhtien}     ${return_discount}     ${input_paid_supplier}
    Log    tính tổng nợ, tổng mua của nhà cung cấp af ex
    ${result_no_ncc}     ${result_tongmua}     ${result_tongmua_tru_trahang}    Supplier debt calculation af purchase return    ${supplier_code}    ${paid_supplier_value}      ${actual_supplier_payment}     Đã trả hàng
    #
    Reload Page
    Wait Until Keyword Succeeds    3x    0.5s    Add new Tra Hang Nhap
    Wait Until Keyword Succeeds    3x    0.5s    Input purchase return Code    ${purchase_return_code}
    Log      Input data
    Add product and input value incase THN nhanh lodate    ${list_products}    ${list_nums}    ${list_product_discount}    ${list_product_discount_type}    ${list_result_newprice}   ${list_all_lo}    ${list_product_types}
    Input purchase return infor      ${supplier_code}    ${input_paid_supplier}    ${paid_supplier_value}
    Input purchase return discount    ${return_discount}    ${result_discount_vnd}
    Click Element    ${button_finish_thn}
    ##
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
    #Reload Page
