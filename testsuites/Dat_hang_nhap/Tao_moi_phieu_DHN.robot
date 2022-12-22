*** Settings ***
Suite Setup       Setup Test Suite    Before Test Quan Ly
Suite Teardown     After Test
Library           Collections
Resource          ../../core/hang_hoa/hang_hoa_navigation.robot
Resource          ../../core/share/computation.robot
Resource          ../../core/Giao_dich/dat_hang_nhap_add_action.robot
Resource          ../../core/Giao_dich/dat_hang_nhap_list_action.robot
Resource          ../../core/Giao_dich/giaodich_nav.robot
Resource          ../../core/API/api_danhmuc_hanghoa.robot
Resource          ../../core/Doi_Tac/doitac_navigation.robot
Resource          ../../core/Doi_Tac/ncc_list_action.robot
Resource          ../../core/So_Quy/so_quy_list_action.robot
Resource          ../../core/share/toast_message.robot
Resource          ../../core/API/api_nha_cung_cap.robot
Resource          ../../core/API/api_dathangnhap.robot
Resource          ../../core/API/api_soquy.robot
Resource          ../../core/Giao_dich/nhaphang_getandcompute.robot
Resource          ../../core/Giao_dich/nhap_hang_add_action.robot

*** Variables ***
&{dict_pr}        DNQD002=5      DNS001=7.6     DNT001=11     DNT003=9
&{dict_giamoi}    DNQD002=none      DNS001=89000   DNT001=85000.8     DNT003=none
&{dict_gg}        DNQD002=10       DNS001=0   DNT001=15     DNT003=10000.25

*** Test Cases ***
Tạo phiếu DHN
    [Tags]    EDN3
    [Template]    dhn_phieutam
    [Documentation]   Tạo phiếu ĐHN > check tồn kho, giá vốn, công nợ NCC, sổ quỹ
    NCC0022    ${dict_pr}    ${dict_giamoi}    ${dict_gg}      20    all      Phiếu tạm
    NCC0022    ${dict_pr}    ${dict_giamoi}    ${dict_gg}       0    0         Phiếu tạm
    NCC0022    ${dict_pr}    ${dict_giamoi}    ${dict_gg}    50000    250000      Đã xác nhận NCC

*** Keywords ***
dhn_phieutam
    [Arguments]    ${input_supplier_code}    ${dict_prs}    ${dict_newprice}    ${dict_discount}    ${input_discount}    ${input_tientrancc}    ${input_trangthai}
    ${list_prs}    Get Dictionary Keys    ${dict_prs}
    ${list_nums}    Get Dictionary Values    ${dict_prs}
    ${list_newprice}    Get Dictionary Values    ${dict_newprice}
    ${list_discount}    Get Dictionary Values    ${dict_discount}
    ${ma_phieu}    Generate code automatically    PDN
    ${list_prs_cb}    Get list code basic of product unit    ${list_prs}
    #
    Log    Tính tổng tièn hàng, nợ cần trả sau khi ĐHN
    ${list_result_thanhtien_af}    ${list_result_newprice_af}    ${list_result_onhand_cb_af}    ${list_dongia}    ${list_result_onhand_actual_af}    ${list_actual_num_cb}    ${list_result_newprice_cb_af}     ${list_result_newprice_bf}    ${list_result_discount_vnd}
    ...    Get list of total purchase receipt - result onhand actual product in case of price change and have discount     ${list_prs_cb}     ${list_prs}    ${list_nums}    ${list_newprice}    ${list_discount}
    ${result_tongtienhang}      ${result_discount_nh}      ${result_cantrancc}      ${actual_tientrancc}     Conputation total, discount and pay for supplier    ${list_result_thanhtien_af}     ${input_discount}     ${input_tientrancc}
    Log    Tính toán giá vốn, tồn kho sau khi ĐHN
    ${list_cost_bf_ex}    ${list_onhand_bf_ex}    Get list cost - onhand frm API    ${list_prs_cb}
    ${get_list_on_order_af}     Computation list on order after purchase order    ${list_prs}    ${list_nums}     ${input_trangthai}
    Log    Get tổng nợ, tổng mua sau khi DHN
    ${result_no_ncc}     ${result_tongmua}     ${result_tongmua_tru_trahang}      Supplier debt calculation af reciept order    ${input_supplier_code}    ${result_cantrancc}      ${actual_tientrancc}
    #
    Log    Lap phieu
    Wait Until Keyword Succeeds    3 times    0 s    Go to Dat Hang Nhap
    Go to tao phieu DHN
    Click Bo qua if popup Mo ban nhap appear
    Select Trang thai phieu Dat hang Nhap    ${input_trangthai}
    input text    ${textbox_dhn_ma_phieu}    ${ma_phieu}
    ${lastest_num}     Input products and fill values in DNH form    ${list_prs}    ${list_nums}    ${list_newprice}    ${list_discount}    ${list_dongia}
    Input discount PNH Invoice    ${input_discount}    ${result_discount_nh}
    Input purchase order supplier and payment   ${input_supplier_code}    ${result_cantrancc}    ${actual_tientrancc}
    Press Key      //body     ${F9_KEY}
    Purchase order message success validation    ${ma_phieu}
    #
    Log    validate thong tin tren phieu nhap
    Assert values in purchase order code until succeed    ${ma_phieu}    ${input_supplier_code}    ${result_tongtienhang}    ${actual_tientrancc}     ${lastest_num}    ${result_cantrancc}    ${result_discount_nh}     ${input_trangthai}
    Validate So quy info from API    ${ma_phieu}    ${actual_tientrancc}    -${actual_tientrancc}      Phiếu thu
    Assert sumary in tab Lich su dat hang nhap     ${input_supplier_code}    ${ma_phieu}     ${result_cantrancc}    ${input_trangthai}
    Assert Cong no Nha cung cap    ${input_supplier_code}    ${result_no_ncc}    ${result_tongmua}
    Assert list of onhand, cost af execute   ${list_prs_cb}    ${list_onhand_bf_ex}    ${list_cost_bf_ex}
    Assert list on order af execute    ${list_prs}    ${get_list_on_order_af}
    Delete purchase order code    ${ma_phieu}
