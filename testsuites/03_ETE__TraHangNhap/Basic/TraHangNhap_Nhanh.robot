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

*** Variables ***
&{dict_pr}        PIB10012=100    DVT0207=22    IM08=3      TPC011=45       QD033=1
@{dict_discountvalue}      4000    0    10      25499.28     11000
@{dict_discounttype}      dis    none    dis      change     change

*** Test Cases ***     Product Code and Quantity       Discount Value        Discount Type         Purchase return Discount         Payment       Supplier Code
etthn1
    [Tags]     ETTHN
    [Template]      etthn1
    [Timeout]     30 minutes
    [Documentation]     Trả hàng nhập nhanh với 3 loại hàng hóa (hàng thường, đơn vị tính, imei) > check giá vốn, tồn kho, công nợ NCC
    ${dict_pr}         ${dict_discountvalue}      ${dict_discounttype}       10        500000         NCC0043
    #${dict_pr}         ${dict_discountvalue}      ${dict_discounttype}       20000        0         NCC0043

Tra Hang Nhap Nhanh
    [Tags]     GOLIVE2
    [Template]      etthn1
    [Documentation]     Trả hàng nhập nhanh với 3 loại hàng hóa (hàng thường, đơn vị tính, imei) > check giá vốn, tồn kho, công nợ NCC
    ${dict_pr}        ${dict_discountvalue}          ${dict_discounttype}       0        500000         NCC0043

*** Keywords ***
etthn1
    [Arguments]    ${dict_pr}    ${list_change}     ${list_change_type}    ${return_discount}    ${input_paid_supplier}    ${input_supplier_code}
    Set Selenium Speed    0.1
    ${purchase_return_code}    Generate code automatically    THN
    ${list_product}     Get Dictionary Keys   ${dict_pr}
    ${list_num}     Get Dictionary Values   ${dict_pr}
    ${list_pr_cb}    Get list code basic of product unit    ${list_product}
    ${get_list_imei_status}    Get list imei status thr API    ${list_product}
    ${list_imei}     Import list imei for list product    ${list_product}    ${list_num}    ${get_list_imei_status}
    Sleep    10s
    #
    Log    tính tổng tiền, giá vốn, cần trả nhà cung cấp... af ex

    ${list_result_thanhtien_af}    ${list_result_newprice_af}    ${list_result_onhand_cb_af}    ${list_result_onhand_actual_af}    ${list_actual_num_cb}    ${list_result_newprice_cb_af}       ${list_gianhap}     ${list_result_disvnd_by_pr}     Get list of total purchase return - result onhand actual product in case of price change
    ...    ${list_pr_cb}    ${list_product}    ${list_num}    ${list_change}    ${list_change_type}
    ${result_tongtienhang}      ${result_discount_vnd}      ${result_ncc_cantra}      ${actual_tienncc_tra}     Conputation total, discount and pay for supplier    ${list_result_thanhtien_af}     ${return_discount}     ${input_paid_supplier}
    ${list_cost_cb_af_ex}    Computation list of cost incase purchase return have discount, price change and have expense    ${list_pr_cb}    ${list_result_newprice_cb_af}    ${list_actual_num_cb}    ${result_discount_vnd}    ${result_tongtienhang}     0

    Log    tính tổng nợ, tổng mua của nhà cung cấp af ex
    ${result_no_ncc}     ${result_tongmua}     ${result_tongmua_tru_trahang}    Supplier debt calculation af purchase return    ${input_supplier_code}    ${result_ncc_cantra}      ${actual_tienncc_tra}     Đã trả hàng
    #
    Log    Lập phiếu
    Reload Page
    Wait Until Keyword Succeeds    3x    0.5s    Add new Tra Hang Nhap
    Wait Until Keyword Succeeds    3x    0.5s    Input purchase return Code    ${purchase_return_code}
    Add product and input value incase purchase return    ${list_product}    ${list_num}    ${list_change}     ${list_change_type}    ${list_result_newprice_af}   ${list_imei}     ${get_list_imei_status}
    Input purchase return discount    ${return_discount}    ${result_discount_vnd}
    Input purchase return infor    ${input_supplier_code}    ${actual_tienncc_tra}    ${result_ncc_cantra}
    Click Element    ${button_nh_hoanthanh}
    Purchase return message success validation    ${purchase_return_code}
    #
    Log    validate af ex
    Assert values by purchaser return code until succeed    ${purchase_return_code}    ${result_tongtienhang}    ${result_ncc_cantra}    ${actual_tienncc_tra}    Hoàn thành
    Validate So quy info from API    ${purchase_return_code}    ${actual_tienncc_tra}    ${actual_tienncc_tra}    Trả hàng nhập
    Validate status in Tab No can tra NCC incase purchase return    ${input_supplier_code}    ${purchase_return_code}    ${actual_tienncc_tra}
    Assert ma phieu nhap is avaliable in Tab No can tra NCC and Lich su nhap/tra hang    ${input_supplier_code}    ${purchase_return_code}
    Assert Cong no Nha cung cap    ${input_supplier_code}    ${result_no_ncc}    ${result_tongmua}
    Assert list of onhand, cost af receipt    ${list_pr_cb}    ${list_result_onhand_cb_af}    ${list_cost_cb_af_ex}
    Delete purchase return code    ${purchase_return_code}
