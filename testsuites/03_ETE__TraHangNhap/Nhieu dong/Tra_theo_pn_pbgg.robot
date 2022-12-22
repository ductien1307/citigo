*** Settings ***
Suite Setup       Setup Test Suite    Before Test Import Product
Suite Teardown     After Test
Resource          ../../../core/API/api_phieu_nhap_hang.robot
Resource          ../../../core/Giao_dich/tra_hang_nhap_list_page.robot
Resource          ../../../core/Giao_dich/tra_hang_nhap_list_action.robot
Resource          ../../../core/API/api_danhmuc_hanghoa.robot
Resource          ../../../core/API/api_nha_cung_cap.robot
Resource          ../../../core/API/api_tra_hang_nhap.robot
Resource          ../../../core/Giao_dich/nhaphang_getandcompute.robot
Resource          ../../../core/Giao_dich/nhap_hang_list_action.robot
Resource          ../../../core/share/toast_message.robot
Resource          ../../../core/API/api_soquy.robot
Resource          ../../../core/share/computation.robot
Resource          ../../../core/share/imei.robot

*** Variables ***
@{list_sp}        NHMQD004        NHMS004       NHMT004
@{list_sl}        3,4.5,2         2,3             2.5,3
@{list_gm}        100000.4,50000,70000     90000,58000        45000.66,55000
@{list_gg}        10000,7000.5,10    10,20          0,9000.6
@{list_sl_tra}    2.4,4,1       1,2       1,2

*** Test Cases ***
Phan bo gghd
    [Tags]      ETTHN     GOLIVE2
    [Template]    etnd3
    [Timeout]     15 minutes
    [Documentation]   Trả hàng nhập theo phiếu nhập nhiều dòng KHÔNG phân bổ giảm giá > check chi tiêt đơn, tồn kho, giá vốn, công nợ nhà cung câp
    NCC0014    ${list_sp}    ${list_sl}    ${list_gm}    ${list_gg}    50000    10000     ${list_sl_tra}     30000    all

*** Keywords ***
etnd3
    [Arguments]    ${input_supplier_code}    ${list_products}    ${list_num}    ${list_newprice}    ${list_discount}    ${input_discount_nh}
    ...    ${input_datrancc}    ${list_nums_return}   ${return_discount}    ${input_paid_supplier}
    Set Selenium Speed    0.1
    ${reciept_code}    Add new purchase receipt in case multi row thr API    ${input_supplier_code}    ${list_products}    ${list_num}    ${list_newprice}    ${list_discount}
    ...    ${input_discount_nh}    ${input_datrancc}
    Sleep    10s
    ${purchase_return_code}    Generate code automatically    THN
    ${list_pr_cb}    Get list code basic of product unit    ${list_products}

    Log    tính tổng tiền, giá vốn, cần trả nhà cung cấp... af ex
    ${list_gianhap_phanbo_cb}    ${list_actual_num_cb}   Computation list supply price of capital allocated incase purchase return multi row    ${list_products}    ${list_nh_result_newprice}    ${list_nums_return}   ${result_ggpn}    ${result_tongtienhang_nh}
    ${list_result_thanhtien_cb_af}     ${list_result_onhand_cb_af}    ${list_total_actual_num_cb}    Get list of total purchase return by receipt - result onhand actual product in case of multi row product    ${list_pr_cb}    ${list_pr_cb}
    ...    ${list_actual_num_cb}    ${list_gianhap_phanbo_cb}
    ${result_tongtienhang}      ${result_discount_thn}      ${result_ncc_cantra}      ${actual_tienncc_tra}     Conputation total, discount and pay for supplier    ${list_result_thanhtien_cb_af}     ${return_discount}     ${input_paid_supplier}
    ${list_cost_cb_af_ex}    Computation list of cost incase purchase return multi row    ${list_pr_cb}    ${list_pr_cb}    ${list_gianhap_phanbo_cb}    0    ${return_discount}
    ...    ${result_tongtienhang}    ${list_actual_num_cb}

    Log    tính tổng nợ, tổng mua của nhà cung cấp af ex
    ${result_no_ncc}     ${result_tongmua}     ${result_tongmua_tru_trahang}    Supplier debt calculation af purchase return    ${input_supplier_code}    ${result_ncc_cantra}      ${actual_tienncc_tra}    Đã trả hàng
    #
    Log    Lập phiếu
    Reload Page
    Click Purchase Return button from Import Product Form until succeed    ${reciept_code}
    Run Keyword If    ${input_discount_nh}>0    KV Click Element    ${button_dongy_phanbo_gianhap}
    Input purchase return Code    ${purchase_return_code}
    Fill product nmbers incase multi rows THN    ${list_products}    ${list_nums_return}    ${list_imei_all}
    Input new purchase return discount    ${return_discount}
    Run Keyword If    ${actual_tienncc_tra} != 0    Wait Until Keyword Succeeds     3 times   1s      Input paid for supplier and validate    ${actual_tienncc_tra}    ${result_ncc_cantra}
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
