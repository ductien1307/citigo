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
&{dict_pr1}        NHP003=5.2       NQD03=3     NS03=2
@{list_newprice1}    45000    89000.5    69000
@{list_num_edit1}     5       6.3       2
@{list_newprice_edit1}      65000       45000.6       70000
@{list_discount_edit1}      10000       15        20

*** Test Cases ***    Mã NCC      Dict SP-SL      List giá mới      GGPN      Tra ncc     List num eit      List gm edit      List gg edit        GGPN edit   Tien tra ncc      NCC eidt
Ko thanh toan
    [Tags]    EN
    [Template]    en01
    [Documentation]   Phiếu nhập đã hoàn thành - không có thanh toán > Cập nhật đổi NCC và thay đổi dữ liệu trong phiếu > check tồn kho, giá vốn, công nợ NCC, sổ quỹ
    NCC0004    ${dict_pr1}    ${list_newprice1}    30000      ${list_num_edit1}      ${list_newprice_edit1}      ${list_discount_edit1}      20         300000            NCC0008

*** Keywords ***
en01
    [Arguments]    ${input_supplier_code}    ${dict_pr_num}    ${list_newprice}     ${input_nh_discount}    ${list_num_edit}
    ...    ${list_newprice_edit}    ${list_discount_edit}    ${input_nh_discount_edit}    ${input_tientrancc}       ${supplier_code_edit}
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
    ${result_supplier_code}     Set Variable If    '${supplier_code_edit}'=='none'    ${input_supplier_code}        ${supplier_code_edit}
    ${result_no_ncc}     ${result_tongmua}     ${result_tongmua_tru_trahang}      Supplier debt calculation af reciept    ${result_supplier_code}    ${result_cantrancc}      ${actual_tientrancc}     Đã nhập hàng
    #
    Log    Tạo phiếu
    ${reciept_code}    Add new purchase receipt no payment thr API    ${input_supplier_code}    ${dict_pr_num}    ${list_newprice}    ${input_nh_discount}
    #
    Log    Lập phiếu
    Set Selenium Speed    0.1
    Go To nhap Hang
    Search purchase receipt code and click open    ${reciept_code}
    Edit price, discount and num in NH form   ${list_pr}    ${list_num_edit}    ${list_newprice_edit}    ${list_discount_edit}
    Input discount PNH Invoice    ${input_nh_discount_edit}    ${result_discount_nh}
    Edit supplier in NH form    ${supplier_code_edit}    ${result_supplier_code}
    Wait Until Keyword Succeeds    3 times    1s    Input pay for supplier and validate    ${actual_tientrancc}    ${result_cantrancc}
    Press Key      //body     ${F9_KEY}
    KV Click Element     ${button_nh_dongy_capnhat}
    Purchase receipt message success validation    ${reciept_code}
    #
    Log    validate thong tin tren phieu nhap
    Assert values by purchase code until succeed    ${reciept_code}    ${result_supplier_code}    ${result_tongtienhang}    ${actual_tientrancc}    ${tong_so_luong}    ${result_cantrancc}    ${result_discount_nh}    Đã nhập hàng
    Validate So quy info from API    ${reciept_code}    ${actual_tientrancc}    -${actual_tientrancc}      Phiếu chi
    Validate status in Tab No can tra NCC incase purchase order    ${result_supplier_code}    ${reciept_code}    ${actual_tientrancc}
    Assert ma phieu nhap is avaliable in Tab No can tra NCC and Lich su nhap/tra hang    ${result_supplier_code}    ${reciept_code}
    Assert Cong no Nha cung cap    ${result_supplier_code}    ${result_no_ncc}    ${result_tongmua}
    Wait Until Keyword Succeeds    3 times    3s    Assert list of onhand, cost af receipt    ${list_pr_cb}    ${list_result_onhand_cb_af}    ${list_cost_cb_af_ex}
    Log    valdate phiếu nhập có còn trong Lịch sử đặt nhập của NCC cũ
    Run Keyword If    '${supplier_code_edit}'=='none'    Log    Ignore ncc     ELSE       Assert ma phieu nhap is not avaliable in Tab No can tra NCC and Lich su nhap/tra hang    ${input_supplier_code}    ${reciept_code}
    Delete purchase receipt code    ${reciept_code}
