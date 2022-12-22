*** Settings ***
Suite Setup       Setup Test Suite    Before Test Quan Ly
Suite Teardown     After Test
Resource          ../../../../core/API/api_phieu_nhap_hang.robot
Resource          ../../../../core/Giao_dich/tra_hang_nhap_list_page.robot
Resource          ../../../../core/Giao_dich/tra_hang_nhap_list_action.robot
Resource          ../../../../core/API/api_danhmuc_hanghoa.robot
Resource          ../../../../core/API/api_nha_cung_cap.robot
Resource          ../../../../core/API/api_tra_hang_nhap.robot
Resource          ../../../../core/Giao_dich/nhaphang_getandcompute.robot
Resource          ../../../../core/share/toast_message.robot
Resource          ../../../../core/API/api_soquy.robot

*** Variables ***
&{dict_pr1}       DNT021=7.5      NQD06=6    NS06=3
@{list_newprice1}    45000      69000    90000
@{list_pr_return1}    6     6    2
@{list_discountvalue1}    10000      0    79000.64
@{list_discounttype1}    dis    none    change
&{CPNH}           CPNH6=35000    CPNH8=none

*** Test Cases ***    NCC              Dict sp - sl nhap    List gia nhap         GGPN             Tien tra ncc       Dict sp - sl tra       Discount Value            Discount Type             Purchase return Discount    Payment    CPNH hoan lai
Ko phan bo ggpn       [Tags]                       ETNC
                      [Template]                   ethnc2
                      [Timeout]     15 minutes
                      [Documentation]   Trả hàng nhập theo phiếu nhập KHÔNG phân bổ giảm giá - có CP hoàn trả > check chi tiêt đơn, tồn kho, giá vốn, công nợ nhà cung câp
                      NCC0002          ${dict_pr1}          ${list_newprice1}     30000            60000              ${list_pr_return1}    ${list_discountvalue1}    ${list_discounttype1}      all                      ${CPNH}

Phan bo ggpn          [Tags]                       ETNC
                      [Template]                   ethnc3
                      [Timeout]     15 minutes
                      [Documentation]   Trả hàng nhập theo phiếu nhập Có phân bổ giảm giá - có CP hoàn trả > check chi tiêt đơn, tồn kho, giá vốn, công nợ nhà cung câp
                      NCC0003          ${dict_pr1}           ${list_newprice1}     20              30000              ${list_pr_return1}    ${list_discountvalue1}    ${list_discounttype1}      20000                   ${CPNH}

*** Keywords ***
ethnc2
    [Arguments]    ${input_supplier_code}    ${dict_pr}      ${list_newprice}     ${input_discount_nh}    ${input_datrancc}    ${list_nums_return}    ${list_product_discount}    ${list_product_discount_type}    ${input_paid_supplier}   ${dict_cpnh}
    Set Selenium Speed    0.1
    ${list_products}    Get Dictionary Keys     ${dict_pr}
    ${list_num}    Get Dictionary Values     ${dict_pr}
    ${list_cpnh}    Get Dictionary Keys    ${dict_cpnh}
    ${list_value_cpnh}    Get Dictionary Values    ${dict_cpnh}
    ${reciept_code}    Add new purchase receipt thr API    ${input_supplier_code}    ${dict_pr}    ${list_newprice}    ${input_discount_nh}    ${input_datrancc}
    Sleep    10s
    ${purchase_return_code}    Generate code automatically    THN
    ${list_pr_cb}    Get list code basic of product unit    ${list_products}
    ${get_list_imei_status}    Get list imei status thr API    ${list_products}

    Log    tính tổng tiền, giá vốn, cần trả nhà cung cấp... af ex
    ${list_supplier_charge_defaul}      ${list_supplier_charge_auto}     Get list supplier charge values thr API    ${list_cpnh}
    ${list_result_thanhtien_af}    ${list_result_newprice_af}    ${list_result_onhand_cb_af}    ${list_result_onhand_actual_af}    ${list_actual_num_cb}    ${list_result_newprice_cb_af}       ${list_gianhap}     ${list_result_disvnd_by_pr}     Get list of total purchase return - result onhand actual product in case of price change
    ...    ${list_pr_cb}    ${list_products}    ${list_nums_return}    ${list_product_discount}    ${list_product_discount_type}
    ${result_tongtienhang}      ${result_discount_thn}   ${result_tongtien_tru_gg}     ${result_ncc_cantra}     ${actual_tienncc_tra}      ${total_supplier_charge}      Computation total, discount and pay for supplier incase return have supplier charge     ${list_result_thanhtien_af}     ${result_ggpn}     ${result_tongtienhang_nh}    ${input_paid_supplier}   ${list_supplier_charge_defaul}     ${list_value_cpnh}
    ${list_cost_cb_af_ex}    Computation list of cost incase purchase return have discount, price change and have expense    ${list_pr_cb}    ${list_result_newprice_cb_af}    ${list_actual_num_cb}    ${result_discount_thn}    ${result_tongtienhang}    ${total_supplier_charge}
    ${list_imei_return}    Get list imei to purchase return    ${list_nums_return}    ${list_imei_all}    ${get_list_imei_status}

    Log    tính tổng nợ, tổng mua của nhà cung cấp af ex
    ${result_no_ncc}     ${result_tongmua}     ${result_tongmua_tru_trahang}    Supplier debt calculation af purchase return    ${input_supplier_code}    ${result_ncc_cantra}      ${actual_tienncc_tra}    Đã trả hàng
    #
    Log    Lập phiếu
    Go To nhap Hang
    Click Purchase Return button from Import Product Form until succeed    ${reciept_code}
    Run Keyword If    ${input_discount_nh}>0    KV Click Element    ${button_ko_dongy_phanbo_gianhap}
    Input purchase return Code    ${purchase_return_code}
    Input product values in THN form    ${list_products}     ${list_nums_return}   ${get_list_imei_status}    ${list_imei_return}    ${list_product_discount}    ${list_product_discount_type}    ${list_result_newprice_af}
    Validate discount THN from UI   ${result_discount_thn}
    Open popup Chi phi nhap hoan lai and select returned expenses    ${list_cpnh}    ${list_value_cpnh}      ${total_supplier_charge}
    Run Keyword If    ${actual_tienncc_tra} != 0    Wait Until Keyword Succeeds     3 times   1s      Input paid for supplier and validate    ${actual_tienncc_tra}    ${result_ncc_cantra}
    Click Element    ${button_nh_hoanthanh}
    Purchase return message success validation    ${purchase_return_code}
    #
    Log    tắt CPNH
    Toggle list supplier's charge    ${list_cpnh}    ${list_supplier_charge_defaul}
    #
    Log    validate af ex
    Assert values by purchaser return code until succeed    ${purchase_return_code}    ${result_tongtienhang}    ${result_ncc_cantra}    ${actual_tienncc_tra}    Hoàn thành
    Validate So quy info from API    ${purchase_return_code}    ${actual_tienncc_tra}    ${actual_tienncc_tra}    Trả hàng nhập
    Validate status in Tab No can tra NCC incase purchase return    ${input_supplier_code}    ${purchase_return_code}    ${actual_tienncc_tra}
    Assert ma phieu nhap is avaliable in Tab No can tra NCC and Lich su nhap/tra hang    ${input_supplier_code}    ${purchase_return_code}
    Assert Cong no Nha cung cap    ${input_supplier_code}    ${result_no_ncc}    ${result_tongmua}
    Assert list of onhand, cost af receipt    ${list_pr_cb}    ${list_result_onhand_cb_af}    ${list_cost_cb_af_ex}
    Delete purchase return code    ${purchase_return_code}

ethnc3
    [Arguments]    ${input_supplier_code}    ${dict_pr}      ${list_newprice}     ${input_discount_nh}    ${input_datrancc}    ${list_nums_return}    ${list_product_discount}    ${list_product_discount_type}      ${input_paid_supplier}     ${dict_cpnh}
    Set Selenium Speed    0.1
    ${list_products}    Get Dictionary Keys     ${dict_pr}
    ${list_num}    Get Dictionary Values     ${dict_pr}
    ${list_cpnh}    Get Dictionary Keys    ${dict_cpnh}
    ${list_value_cpnh}    Get Dictionary Values    ${dict_cpnh}
    ${reciept_code}    Add new purchase receipt thr API    ${input_supplier_code}    ${dict_pr}    ${list_newprice}    ${input_discount_nh}    ${input_datrancc}
    Sleep    10s
    ${purchase_return_code}    Generate code automatically    THN
    ${list_pr_cb}    Get list code basic of product unit    ${list_products}
    ${get_list_imei_status}    Get list imei status thr API    ${list_products}

    Log    tính tổng tiền, giá vốn, cần trả nhà cung cấp... af ex
    ${list_supplier_charge_defaul}      ${list_supplier_charge_auto}     Get list supplier charge values thr API    ${list_cpnh}
    ${list_gianhap_phanbo_cb}    ${list_actual_num_cb}   Computation supply price of capital allocated incase purchase return by list product       ${list_products}     ${list_newprice}    ${list_nums_return}  ${result_ggpn}     ${result_tongtienhang_nh}
    ${list_result_thanhtien_af}    ${list_result_onhand_cb_af}      Get list of total purchase return - result onhand and total       ${list_pr_cb}      ${list_actual_num_cb}    ${list_gianhap_phanbo_cb}
    ${result_tongtienhang}      ${result_discount_thn}   ${result_tongtien_tru_gg}     ${result_ncc_cantra}     ${actual_tienncc_tra}      ${total_supplier_charge}      Computation total, discount and pay for supplier incase return have supplier charge     ${list_result_thanhtien_af}     0     ${result_tongtienhang_nh}    ${input_paid_supplier}   ${list_supplier_charge_defaul}     ${list_value_cpnh}
    ${list_cost_cb_af_ex}    Computation list of cost incase purchase return have discount, price change and have expense    ${list_pr_cb}    ${list_gianhap_phanbo_cb}    ${list_actual_num_cb}    ${result_discount_thn}    ${result_tongtienhang}    ${total_supplier_charge}
    ${list_imei_return}    Get list imei to purchase return    ${list_nums_return}    ${list_imei_all}    ${get_list_imei_status}

    Log    tính tổng nợ, tổng mua của nhà cung cấp af ex
    ${result_no_ncc}     ${result_tongmua}     ${result_tongmua_tru_trahang}    Supplier debt calculation af purchase return    ${input_supplier_code}    ${result_ncc_cantra}      ${actual_tienncc_tra}    Đã trả hàng
    #
    Log    Lập phiếu
    Go To nhap Hang
    Click Purchase Return button from Import Product Form until succeed    ${reciept_code}
    Run Keyword If    ${input_discount_nh}>0    KV Click Element    ${button_dongy_phanbo_gianhap}
    Input purchase return Code    ${purchase_return_code}
    Input product numbers in THN form    ${list_products}     ${list_nums_return}   ${get_list_imei_status}    ${list_imei_return}
    Open popup Chi phi nhap hoan lai and select returned expenses    ${list_cpnh}    ${list_value_cpnh}      ${total_supplier_charge}
    Run Keyword If    ${actual_tienncc_tra} != 0    Wait Until Keyword Succeeds     3 times   1s      Input paid for supplier and validate    ${actual_tienncc_tra}    ${result_ncc_cantra}
    Click Element    ${button_nh_hoanthanh}
    Purchase return message success validation    ${purchase_return_code}
    #
    Log    tắt CPNH
    Toggle list supplier's charge    ${list_cpnh}    ${list_supplier_charge_defaul}
    #
    Log    validate af ex
    Assert values by purchaser return code until succeed    ${purchase_return_code}    ${result_tongtienhang}    ${result_ncc_cantra}    ${actual_tienncc_tra}    Hoàn thành
    Validate So quy info from API    ${purchase_return_code}    ${actual_tienncc_tra}    ${actual_tienncc_tra}    Trả hàng nhập
    Validate status in Tab No can tra NCC incase purchase return    ${input_supplier_code}    ${purchase_return_code}    ${actual_tienncc_tra}
    Assert ma phieu nhap is avaliable in Tab No can tra NCC and Lich su nhap/tra hang    ${input_supplier_code}    ${purchase_return_code}
    Assert Cong no Nha cung cap    ${input_supplier_code}    ${result_no_ncc}    ${result_tongmua}
    Assert list of onhand, cost af receipt    ${list_pr_cb}    ${list_result_onhand_cb_af}    ${list_cost_cb_af_ex}
    Delete purchase return code    ${purchase_return_code}
