*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}      ${headless_browser}
Test Setup        Before Test Import Product
Test Teardown     After Test
Library           Collections
Resource          ../../../core/hang_hoa/hang_hoa_navigation.robot
Resource          ../../../core/share/computation.robot
Resource          ../../../core/Giao_dich/nhap_hang_add_action.robot
Resource          ../../../core/Giao_dich/nhap_hang_add_page.robot
Resource          ../../../core/Giao_dich/nhap_hang_list_action.robot
Resource          ../../../core/Giao_dich/giaodich_nav.robot
Resource          ../../../core/API/api_danhmuc_hanghoa.robot
Resource          ../../../core/Doi_Tac/doitac_navigation.robot
Resource          ../../../core/Doi_Tac/ncc_list_action.robot
Resource          ../../../core/So_Quy/so_quy_list_action.robot
Resource          ../../../core/share/toast_message.robot
Resource          ../../../core/API/api_nha_cung_cap.robot
Resource          ../../../core/API/api_phieu_nhap_hang.robot
Resource          ../../../core/API/api_soquy.robot
Resource          ../../../core/Giao_dich/nhaphang_getandcompute.robot
Resource          ../../../core/share/imei.robot

*** Variables ***
@{list_sp}        NHMQD002    NHMS002   NHMT002
@{list_sl}      3,4,2       2,3        5,4.2
@{list_giamoi}      26000,45000,70000       95000,65000     45000.5,60000
@{list_gg}      10,15,10000     10000,0         0,5000

*** Test Cases ***
Hoàn thành
    [Tags]      EN
    [Template]    ennd1
    [Documentation]   Tạo phiếu nhập hàng nhiều dòng có: nhà cung cấp, 3 loại sp (hàng thường, imei, đơn vị tính), giảm giá PN, tiền trả NCC > check tồn kho, giá vốn, công nợ NCC, sổ quỹ
    NCC0012    ${list_sp}    ${list_sl}     ${list_giamoi}    ${list_gg}      25500     all

*** Keywords ***
ennd1
    [Arguments]    ${input_supplier_code}    ${list_product}    ${list_num}    ${list_newprice}    ${list_discount}    ${input_nh_discount}    ${input_tientrancc}
    Set Selenium Speed    0.1
    ${import_code}    Generate code automatically    PNH
    ${list_pr_cb}    Get list code basic of product unit    ${list_product}
    #
    Log    tính tổng tiền, giá vốn, cần trả nhà cung cấp... af ex
    ${list_result_thanhtien_af}    ${list_result_newprice_af}    ${list_result_onhand_cb_af}     ${list_actual_num_cb}    ${list_result_giamgia}      ${list_result_thanh_tien}        Get list of total purchase receipt - result onhand actual product in case of multi row product    ${list_pr_cb}    ${list_product}    ${list_num}    ${list_newprice}    ${list_discount}
    ${result_tongtienhang}      ${result_discount_nh}      ${result_cantrancc}      ${actual_tientrancc}     Conputation total, discount and pay for supplier    ${list_result_thanhtien_af}     ${input_nh_discount}     ${input_tientrancc}
    ${list_cost_cb_af_ex}     Computation list of cost incase purchase receipt multi row    ${list_product}   ${list_pr_cb}    ${list_result_newprice_af}    0    ${result_discount_nh}    ${result_tongtienhang}    ${list_num}
    Log    tính tổng nợ, tổng mua của nhà cung cấp af ex
    ${result_no_ncc}     ${result_tongmua}     ${result_tongmua_tru_trahang}      Supplier debt calculation af reciept    ${input_supplier_code}    ${result_cantrancc}      ${actual_tientrancc}     Đã nhập hàng
    #
    Log    Lập phiếu
    Go to PNH
    Toggle Adding Row option
    Wait Until Keyword Succeeds    3x    1s    Input Text    ${textbox_nh_ma_phieunhap}    ${import_code}
    ${lastest_num}    ${list_imei}    Add product multi row and fill values     ${list_product}    ${list_num}      ${list_newprice}    ${list_discount}
    Input discount PNH Invoice    ${input_nh_discount}    ${result_discount_nh}
    Input purchase infor    ${input_supplier_code}    ${result_cantrancc}    ${actual_tientrancc}
    #Click Element    ${button_nh_hoanthanh}
    Press Key      //body     ${F9_KEY}
    #
    Log    validate af ex
    Purchase receipt message success validation    ${import_code}
    Assert values by purchase code until succeed    ${import_code}    ${input_supplier_code}    ${result_tongtienhang}    ${actual_tientrancc}    ${lastest_num}    ${result_cantrancc}    ${result_discount_nh}    Đã nhập hàng
    Validate So quy info from API    ${import_code}    ${actual_tientrancc}    -${actual_tientrancc}    Phiếu chi
    Validate status in Tab No can tra NCC incase purchase order    ${input_supplier_code}    ${import_code}    ${actual_tientrancc}
    Assert ma phieu nhap is avaliable in Tab No can tra NCC and Lich su nhap/tra hang    ${input_supplier_code}    ${import_code}
    Assert Cong no Nha cung cap    ${input_supplier_code}    ${result_no_ncc}    ${result_tongmua}
    Wait Until Keyword Succeeds    3 times    3s    Assert list of onhand, cost af receipt    ${list_pr_cb}    ${list_result_onhand_cb_af}    ${list_cost_cb_af_ex}
    Delete purchase receipt code    ${import_code}
