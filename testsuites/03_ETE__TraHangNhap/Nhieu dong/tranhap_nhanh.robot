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
Resource          ../../../core/Giao_dich/nhap_hang_list_action.robot
Resource          ../../../core/share/toast_message.robot
Resource          ../../../core/API/api_soquy.robot
Resource          ../../../core/share/computation.robot
Resource          ../../../core/share/imei.robot

*** Variables ***
@{list_sp}         NHMQD005        NHMS005       NHMT005
@{list_sl}      3.2,5,4         3,2         4.1,3
@{list_gg}      10,5000,70000       0,3000       55000.3,12
@{list_gg_type}      dis,dis,change     dis,dis     change,dis

*** Test Cases ***
Trả nhanh
    [Tags]      ETTHN
    [Template]    etnd1
    [Timeout]     15 minutes
    [Documentation]   Trả hàng nhập nhanh nhiều dòng > check chi tiêt đơn, tồn kho, giá vốn, công nợ nhà cung câp
    NCC0015    ${list_sp}    ${list_sl}     ${list_gg}        ${list_gg_type}      50000    all

*** Keywords ***
etnd1
    [Arguments]    ${input_supplier_code}    ${list_product}    ${list_num}    ${list_change}     ${list_change_type}    ${input_nh_discount}    ${input_paid_supplier}
    Set Selenium Speed    0.1
    ${purchase_return_code}    Generate code automatically    THN
    ${list_pr_cb}    Get list code basic of product unit    ${list_product}
    ${get_list_imei_status}    Get list imei status thr API    ${list_product}
    ${list_imei}    Import list mutil row imei    ${list_product}    ${list_num}    ${get_list_imei_status}
    Sleep    10s
    #
    Log    tính tổng tiền, giá vốn, cần trả nhà cung cấp... af ex

    ${list_result_thanhtien_af}    ${list_result_newprice_af}    ${list_result_onhand_cb_af}     ${list_actual_num_cb}        Get list of total purchase return - result onhand actual product in case of multi row product    ${list_pr_cb}    ${list_product}    ${list_num}    ${list_change}    ${list_change_type}
    ${result_tongtienhang}      ${result_discount_nh}      ${result_ncc_cantra}      ${actual_tienncc_tra}     Conputation total, discount and pay for supplier    ${list_result_thanhtien_af}     ${input_nh_discount}     ${input_paid_supplier}
    ${list_cost_cb_af_ex}    Computation list of cost incase purchase return multi row    ${list_product}   ${list_pr_cb}    ${list_result_newprice_af}    0     ${result_discount_nh}    ${result_tongtienhang}    ${list_num}

    Log    tính tổng nợ, tổng mua của nhà cung cấp af ex
    ${result_no_ncc}     ${result_tongmua}     ${result_tongmua_tru_trahang}    Supplier debt calculation af purchase return    ${input_supplier_code}    ${result_ncc_cantra}      ${actual_tienncc_tra}     Đã trả hàng
    #
    Log    Lập phiếu
    Wait Until Keyword Succeeds    3 times    1s    Add new Tra Hang Nhap
    Toggle Adding Row option
    Wait Until Keyword Succeeds    3x    1s    Input purchase return Code    ${purchase_return_code}
    ${lastest_num}     Add product multi row and input value incase purchase return    ${list_product}    ${list_num}   ${list_change}     ${list_change_type}     ${list_result_newprice_af}    ${get_list_imei_status}    ${list_imei}
    Input purchase return discount    ${input_nh_discount}    ${result_discount_nh}
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
