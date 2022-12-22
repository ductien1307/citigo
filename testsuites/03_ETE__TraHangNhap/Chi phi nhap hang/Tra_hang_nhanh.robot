*** Settings ***
Suite Setup       Setup Test Suite    Before Test Tra Hang Nhap
Suite Teardown     After Test
Resource          ../../../core/API/api_phieu_nhap_hang.robot
Resource          ../../../core/Giao_dich/tra_hang_nhap_list_page.robot
Resource          ../../../core/Giao_dich/tra_hang_nhap_list_action.robot
Resource          ../../../core/API/api_danhmuc_hanghoa.robot
Resource          ../../../core/API/api_nha_cung_cap.robot
Resource          ../../../core/API/api_tra_hang_nhap.robot
Resource          ../../../core/Giao_dich/nhaphang_getandcompute.robot
Resource          ../../../core/share/toast_message.robot
Resource          ../../../core/API/api_soquy.robot
Resource          ../../../core/share/computation.robot
Resource          ../../../core/share/imei.robot

*** Variables ***
&{dict_pr1}       DNT019=5    DNT022=11.2    NQD04=9    NS05=3
@{list_discountvalue1}    4000    14    0    25499.28
@{list_discounttype1}    dis    dis     none    change
&{CPNH}           CPNH2=none    CPNH4=25000

*** Test Cases ***    Product Code and Quantity    Discount Value            Discount Type            Purchase return Discount    Payment    Supplier Code      CPNH hoan lai
Tra Hang Nhap Nhanh
                      [Tags]                       ETNC
                      [Template]                   ethnc1
                      [Timeout]     15 minutes
                      [Documentation]     Trả hàng nhập nhanh với 3 loại hàng hóa (hàng thường, đơn vị tính, imei) có CPNH > check giá vốn, tồn kho, công nợ NCC
                      ${dict_pr1}                  ${list_discountvalue1}    ${list_discounttype1}    10                          all        NCC0001            ${CPNH}

*** Keywords ***
ethnc1
    [Arguments]    ${dict_pr}    ${list_change}     ${list_change_type}    ${return_discount}    ${input_paid_supplier}    ${input_supplier_code}    ${dict_cpnh}
    Set Selenium Speed    0.1
    ${purchase_return_code}    Generate code automatically    THN
    ${list_product}     Get Dictionary Keys   ${dict_pr}
    ${list_num}     Get Dictionary Values   ${dict_pr}
    ${list_cpnh}    Get Dictionary Keys    ${dict_cpnh}
    ${list_value_cpnh}    Get Dictionary Values    ${dict_cpnh}
    ${list_pr_cb}    Get list code basic of product unit    ${list_product}
    ${get_list_imei_status}    Get list imei status thr API    ${list_product}
    ${list_imei}     Import list imei for list product    ${list_product}    ${list_num}    ${get_list_imei_status}
    Sleep    10s
    #
    Log    tính tổng tiền, giá vốn, cần trả nhà cung cấp... af ex
    ${list_supplier_charge_defaul}      ${list_supplier_charge_auto}     Get list supplier charge values thr API    ${list_cpnh}

    ${list_result_thanhtien_af}    ${list_result_newprice_af}    ${list_result_onhand_cb_af}    ${list_result_onhand_actual_af}    ${list_actual_num_cb}    ${list_result_newprice_cb_af}       ${list_gianhap}     ${list_result_disvnd_by_pr}     Get list of total purchase return - result onhand actual product in case of price change
    ...    ${list_pr_cb}    ${list_product}    ${list_num}    ${list_change}    ${list_change_type}

    ${result_tongtienhang}      ${result_discount_vnd}   ${result_tongtien_tru_gg}     ${result_ncc_cantra}     ${actual_tienncc_tra}      ${total_supplier_charge}     Conputation total, discount and pay for supplier in case supplier charge value      ${list_result_thanhtien_af}     ${return_discount}     ${input_paid_supplier}   ${list_supplier_charge_defaul}     ${list_value_cpnh}
    ${list_cost_cb_af_ex}    Computation list of cost incase purchase return have discount, price change and have expense    ${list_pr_cb}    ${list_result_newprice_cb_af}    ${list_actual_num_cb}    ${result_discount_vnd}    ${result_tongtienhang}    ${total_supplier_charge}

    Log    tính tổng nợ, tổng mua của nhà cung cấp af ex
    ${result_no_ncc}     ${result_tongmua}     ${result_tongmua_tru_trahang}    Supplier debt calculation af purchase return    ${input_supplier_code}    ${result_ncc_cantra}      ${actual_tienncc_tra}     Đã trả hàng
    #
    Log    Lập phiếu
    Reload Page
    Wait Until Keyword Succeeds    3x    0.5s    Add new Tra Hang Nhap
    Wait Until Keyword Succeeds    3x    0.5s    Input purchase return Code    ${purchase_return_code}
    Add product and input value incase purchase return    ${list_product}    ${list_num}    ${list_change}     ${list_change_type}    ${list_result_newprice_af}   ${list_imei}     ${get_list_imei_status}
    Input purchase return discount    ${return_discount}    ${result_discount_vnd}
    Open popup Chi phi nhap hoan lai and select returned expenses    ${list_cpnh}    ${list_value_cpnh}      ${total_supplier_charge}
    Input purchase return infor    ${input_supplier_code}    ${actual_tienncc_tra}    ${result_ncc_cantra}
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
