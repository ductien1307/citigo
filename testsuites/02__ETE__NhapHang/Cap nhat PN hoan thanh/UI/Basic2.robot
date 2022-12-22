*** Settings ***
Suite Setup       Setup Test Suite    Before Test Quan Ly
Suite Teardown     After Test
Library           Collections
Resource          ../../../../core/hang_hoa/hang_hoa_navigation.robot
Resource          ../../../../core/share/computation.robot
Resource          ../../../../core/Giao_dich/nhap_hang_add_action.robot
Resource          ../../../../core/Giao_dich/nhap_hang_add_page.robot
Resource          ../../../../core/Giao_dich/nhap_hang_list_action.robot
Resource          ../../../../core/Giao_dich/giaodich_nav.robot
Resource          ../../../../core/API/api_danhmuc_hanghoa.robot
Resource          ../../../../core/Doi_Tac/doitac_navigation.robot
Resource          ../../../../core/Doi_Tac/ncc_list_action.robot
Resource          ../../../../core/So_Quy/so_quy_list_action.robot
Resource          ../../../../core/share/toast_message.robot
Resource          ../../../../core/API/api_nha_cung_cap.robot
Resource          ../../../../core/API/api_phieu_nhap_hang.robot
Resource          ../../../../core/API/api_soquy.robot
Resource          ../../../../core/Giao_dich/nhaphang_getandcompute.robot
Resource          ../../../../core/share/javascript.robot

*** Variables ***
&{dict_pr1}        NHP004=6       NQD04=5.2     NS04=3
@{list_newprice1}    75000.4    89000    120000
@{list_num_edit1}     8.2       1       3
@{list_newprice_edit1}      45000       82000.6       95000
@{list_discount_edit1}      15       1000.5        20

*** Test Cases ***    Mã NCC      Dict SP-SL      List giá mới      GGPN      Tra ncc     List num eit           List gm edit                 List gg edit               GGPN edit
Co thanh toan
    [Tags]    EN
    [Template]    en02
    [Documentation]   Phiếu nhập đã hoàn thành - có NCC - có thanh toán > Cập nhật đổi thay đổi dữ liệu trong phiếu > check tồn kho, giá vốn, công nợ NCC, sổ quỹ
    NCC0006       ${dict_pr1}          ${list_newprice1}            30000      50000       ${list_num_edit1}      ${list_newprice_edit1}      ${list_discount_edit1}      20

*** Keywords ***
en02
    [Arguments]    ${input_supplier_code}    ${dict_pr_num}    ${list_newprice}     ${input_nh_discount}    ${input_tientrancc}     ${list_num_edit}
    ...    ${list_newprice_edit}    ${list_discount_edit}    ${input_nh_discount_edit}
    ${list_pr}    Get Dictionary Keys    ${dict_pr_num}
    ${list_num}    Get Dictionary Values    ${dict_pr_num}
    #
    Log    get dvcb của list sp
    ${list_pr_cb}    Get list code basic of product unit    ${list_pr}
    #
    Log    tính toán tổng tiền, tồn kho, giá vốn... af ex
    ${list_result_thanhtien_af}    ${list_result_newprice_af}    ${list_result_onhand_cb_af}    ${list_dongia}    ${list_result_onhand_actual_af}    ${list_actual_num_cb}    ${list_result_newprice_cb_af}     ${list_result_newprice_bf}    ${list_result_discount_vnd}
    ...    Get list of total purchase receipt - result onhand actual product in case of price change and have discount    ${list_pr_cb}    ${list_pr}    ${list_num_edit}    ${list_newprice_edit}    ${list_discount_edit}
    ${result_tongtienhang}      ${result_discount_nh}      ${result_cantrancc}      ${actual_tientrancc}     Conputation total, discount and pay for supplier    ${list_result_thanhtien_af}     ${input_nh_discount_edit}     ${input_tientrancc}
    ${list_cost_cb_af_ex}    Computation list of cost incase purchase order have discount and price change    ${list_pr_cb}    ${list_result_newprice_cb_af}    ${list_actual_num_cb}    ${result_discount_nh}    ${result_tongtienhang}
    ${tong_so_luong}    Sum values in list    ${list_num_edit}
    #
    Log    tính tổng nợ, tổng mua của nhà cung cấp af ex
    ${result_no_ncc}     ${result_tongmua}     ${result_tongmua_tru_trahang}      Supplier debt calculation af reciept    ${input_supplier_code}    ${result_cantrancc}      ${actual_tientrancc}     Đã nhập hàng
    #
    Log    Tạo phiếu
    ${reciept_code}    Add new purchase receipt thr API    ${input_supplier_code}    ${dict_pr_num}    ${list_newprice}    ${input_nh_discount}    ${input_tientrancc}
    #
    Log    Lập phiếu
    Set Selenium Speed    0.1
    Go To nhap Hang
    Search purchase receipt code and click open    ${reciept_code}
    Edit price, discount and num in NH form   ${list_pr}    ${list_num_edit}    ${list_newprice_edit}    ${list_discount_edit}
    Input discount PNH Invoice    ${input_nh_discount_edit}    ${result_discount_nh}
    Press Key      //body     ${F9_KEY}
    KV Click Element     ${button_nh_dongy_capnhat}
    Purchase receipt message success validation    ${reciept_code}
    #
    Log    validate thong tin tren phieu nhap
    Assert values by purchase code until succeed    ${reciept_code}    ${input_supplier_code}    ${result_tongtienhang}    ${actual_tientrancc}    ${tong_so_luong}    ${result_cantrancc}    ${result_discount_nh}    Đã nhập hàng
    Validate So quy info from API    ${reciept_code}    ${actual_tientrancc}    -${actual_tientrancc}      Phiếu chi
    Validate status in Tab No can tra NCC incase purchase order    ${input_supplier_code}    ${reciept_code}    ${actual_tientrancc}
    Assert ma phieu nhap is avaliable in Tab No can tra NCC and Lich su nhap/tra hang    ${input_supplier_code}    ${reciept_code}
    Assert Cong no Nha cung cap    ${input_supplier_code}    ${result_no_ncc}    ${result_tongmua}
    Wait Until Keyword Succeeds    3 times    3s    Assert list of onhand, cost af receipt    ${list_pr_cb}    ${list_result_onhand_cb_af}    ${list_cost_cb_af_ex}
    Delete purchase receipt code    ${reciept_code}
