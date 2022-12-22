*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}      ${headless_browser}
Test Setup        Before Test Dat Hang Nhap
Test Teardown     After Test
Library           Collections
Resource          ../../../core/hang_hoa/hang_hoa_navigation.robot
Resource          ../../../core/share/computation.robot
Resource          ../../../core/Giao_dich/dat_hang_nhap_add_action.robot
Resource          ../../../core/Giao_dich/dat_hang_nhap_list_action.robot
Resource          ../../../core/Giao_dich/giaodich_nav.robot
Resource          ../../../core/API/api_danhmuc_hanghoa.robot
Resource          ../../../core/Doi_Tac/doitac_navigation.robot
Resource          ../../../core/Doi_Tac/ncc_list_action.robot
Resource          ../../../core/So_Quy/so_quy_list_action.robot
Resource          ../../../core/share/toast_message.robot
Resource          ../../../core/API/api_nha_cung_cap.robot
Resource          ../../../core/API/api_dathangnhap.robot
Resource          ../../../core/API/api_soquy.robot
Resource          ../../../core/Giao_dich/nhaphang_getandcompute.robot
Resource          ../../../core/Giao_dich/nhap_hang_add_action.robot

*** Variables ***
&{dict_pr}    DNQD007=5    DNS017=3    DNT017=11
&{dict_giamoi}    DNQD007=none    DNS017=89000    DNT017=85000.84
&{dict_gg}    DNQD007=10    DNS017=10000.25    DNT017=0
&{dict_pr1}    DNQD108=5    DNS018=2    DNT018=7.5
&{dict_giamoi1}    DNQD108=55000.5    DNS018=12000    DNT018=none
&{dict_gg1}    DNQD108=20    DNS018=10000.25    DNT018=0
&{CPNH1}           CPNH4=none    CPNH5=none
&{CPNHK1}          CPNH10=none    CPNH16=none
&{CPNH2}          CPNH3=25    CPNH8=35000
&{CPNHK2}         CPNH11=30000    CPNH16=35

*** Test Cases ***
Phiếu DHN có CPNH
    [Documentation]     Phiếu tạm
    [Tags]      EDNC1
    [Template]    dhnc01
    [Documentation]    Tạo mới phiếu DHN có CPNH > check tồn kho, giá vốn, công nợ NCC, sổ quỹ
    NCC0002    ${dict_pr}    ${dict_giamoi}    ${dict_gg}    20    all    Phiếu tạm   ${CPNH1}     ${CPNHK1}
    NCC0005    ${dict_pr1}    ${dict_giamoi1}    ${dict_gg1}    30000    80000   Đã xác nhận NCC    ${CPNH1}    ${CPNHK1}

*** Keywords ***
dhnc01
    [Arguments]    ${input_supplier_code}    ${dict_prs}    ${dict_newprice}    ${dict_discount}    ${input_discount}    ${input_tientrancc}    ${input_trangthai}    ${dict_cpnh}      ${dict_cpnhk}
    ${list_prs}    Get Dictionary Keys    ${dict_prs}
    ${list_nums}    Get Dictionary Values    ${dict_prs}
    ${list_newprice}    Get Dictionary Values    ${dict_newprice}
    ${list_discount}    Get Dictionary Values    ${dict_discount}
    ${list_cpnh}    Get Dictionary Keys    ${dict_cpnh}
    ${list_value_cpnh}    Get Dictionary Values    ${dict_cpnh}
    ${list_cpnhk}    Get Dictionary Keys    ${dict_cpnhk}
    ${list_value_cpnhk}    Get Dictionary Values    ${dict_cpnhk}
    ${ma_phieu}    Generate code automatically    PDN
    ${list_prs_cb}    Get list code basic of product unit    ${list_prs}
    #
    Log    tính CPNH
    ${list_supplier_charge_defaul}      ${list_supplier_charge_auto}      ${list_other_charge_defaul}       ${list_other_charge_auto}      Get list supplier charge and other charge values thr API    ${list_cpnh}      ${list_cpnhk}
    #
    Log    Tính tổng tièn hàng, nợ cần trả sau khi ĐHN
    ${list_result_thanhtien_af}    ${list_result_newprice_af}    ${list_result_onhand_cb_af}    ${list_dongia}    ${list_result_onhand_actual_af}    ${list_actual_num_cb}    ${list_result_newprice_cb_af}     ${list_result_newprice_bf}    ${list_result_discount_vnd}
    ...    Get list of total purchase receipt - result onhand actual product in case of price change and have discount     ${list_prs_cb}     ${list_prs}    ${list_nums}    ${list_newprice}    ${list_discount}
    ${result_tongtienhang}      ${result_discount_nh}   ${result_tongtien_tru_gg}     ${result_cantrancc}     ${actual_tientrancc}     ${total_expense_value}   ${total_supplier_charge}    ${total_other_charge}     Conputation total, discount and pay for supplier in case have expense value    ${list_result_thanhtien_af}     ${input_discount}     ${input_tientrancc}   ${list_supplier_charge_defaul}    ${list_other_charge_defaul}       ${list_value_cpnh}      ${list_value_cpnhk}
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
    Select list supplier's charge and input value in DHN form     ${list_cpnh}      ${list_supplier_charge_auto}     ${list_value_cpnh}   ${result_tongtien_tru_gg}
    Select list other charge and input value in DHN form       ${list_cpnhk}       ${list_other_charge_auto}      ${list_value_cpnhk}      ${result_tongtien_tru_gg}
    Input purchase order supplier and payment   ${input_supplier_code}    ${result_cantrancc}    ${actual_tientrancc}
    Press Key      //body     ${F9_KEY}
    Purchase order message success validation    ${ma_phieu}
    #
    Log    tắt CPNH
    Toggle list supplier's charge    ${list_cpnh}    ${list_supplier_charge_defaul}
    Toggle list other charge    ${list_cpnhk}    ${list_other_charge_defaul}
    #
    Log    validate thong tin tren phieu nhap
    Assert values in purchase order code until succeed    ${ma_phieu}    ${input_supplier_code}    ${result_tongtienhang}    ${actual_tientrancc}     ${lastest_num}    ${result_cantrancc}    ${result_discount_nh}     ${input_trangthai}
    Validate So quy info from API    ${ma_phieu}    ${actual_tientrancc}    -${actual_tientrancc}      Phiếu thu
    Assert sumary in tab Lich su dat hang nhap     ${input_supplier_code}    ${ma_phieu}     ${result_cantrancc}    ${input_trangthai}
    Assert Cong no Nha cung cap    ${input_supplier_code}    ${result_no_ncc}    ${result_tongmua}
    Assert list of onhand, cost af execute   ${list_prs_cb}    ${list_onhand_bf_ex}    ${list_cost_bf_ex}
    Assert list on order af execute    ${list_prs}    ${get_list_on_order_af}
    Delete purchase order code    ${ma_phieu}
