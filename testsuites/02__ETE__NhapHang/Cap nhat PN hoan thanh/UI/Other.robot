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
&{dict_pr1}        NHT01=4       NHDVT01=3     NHS01=1
&{dict_pr2}        NHT02=4       QDN002=3      NHS02=1
&{dict_pr3}        NHT03=4       NHDVT03=3     NHS03=1
&{dict_pr4}        NHT04=4       NHDVT04=3      NHS04=1
@{list_newprice1}    29000    119000.5    99000
@{list_num_change1}       5       1      4
@{list_num_change2}       1      3       2
@{list_newprice_change}      65000       45000.6       200000
@{list_discount_change}      10000       15        20

*** Test Cases ***   Dict SP-SL     List num eit      List gm edit                List gg edit             GGPN edit   Tien tra ncc
No Supplier - no payment
                    [Tags]    EN
                    [Template]    update_purhase_nopayment
                    [Documentation]    Cập nhật phiếu NH từ phiếu NH đã hoàn thành ko thanh toán - ko có NCC > check tồn kho, giá vốn, công nợ NCC, sổ quỹ
                    ${dict_pr1}     ${list_num_change1}    ${list_newprice_change}      ${list_discount_change}      20         300000
                    ${dict_pr2}     ${list_num_change2}    ${list_newprice_change}      ${list_discount_change}      10000         all

Supplier - payment
                    [Tags]    EN     
                    [Template]    update_purhase_payment
                    [Documentation]   Tạo phiếu NH có NCC, có thanh toán > Hủy phiếu phiếu thanh toán của PN > Cập nhật lại phiếu NH và thanh toán lại > check tồn kho, giá vốn, công nợ NCC, sổ quỹ
                    NCCN0001       ${dict_pr3}    ${list_newprice1}    30000      50000       ${list_num_change1}      ${list_newprice_change}      ${list_discount_change}      10000       100000
                    NCCN0002       ${dict_pr4}    ${list_newprice1}    10         100000      ${list_num_change1}      ${list_newprice_change}      ${list_discount_change}      20       all


*** Keywords ***
update_purhase_nopayment
    [Arguments]    ${dict_pr_num}     ${list_num_edit}    ${list_newprice_edit}    ${list_discount_edit}    ${input_nh_discount_edit}    ${input_tientrancc}
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
    Log    Tạo phiếu
    ${reciept_code}    Add new purchase receipt without supplier    ${dict_pr_num}
    #
    Log    Lập phiếu
    Set Selenium Speed    0.1
    Go To nhap Hang
    Reload Page
    Search purchase receipt code and click open    ${reciept_code}
    Edit price, discount and num in NH form   ${list_pr}    ${list_num_edit}    ${list_newprice_edit}    ${list_discount_edit}
    Input discount PNH Invoice    ${input_nh_discount_edit}    ${result_discount_nh}
    Wait Until Keyword Succeeds    3 times    1s    Input pay for supplier and validate    ${actual_tientrancc}    ${result_cantrancc}
    Press Key      //body     ${F9_KEY}
    KV Click Element      ${button_nh_dongy_capnhat}
    KV Click Element      ${button_nh_dongy_capnhat_info}
    Purchase receipt message success validation    ${reciept_code}
    #
    Log    validate thong tin tren phieu nhap
    Assert values by purchase code until succeed    ${reciept_code}    0    ${result_tongtienhang}    ${actual_tientrancc}    ${tong_so_luong}    ${result_cantrancc}    ${result_discount_nh}    Đã nhập hàng
    Validate So quy info from API    ${reciept_code}    ${actual_tientrancc}    -${actual_tientrancc}      Phiếu chi
    Wait Until Keyword Succeeds    3 times    3s    Assert list of onhand, cost af receipt    ${list_pr_cb}    ${list_result_onhand_cb_af}    ${list_cost_cb_af_ex}
    Delete purchase receipt code    ${reciept_code}

update_purhase_payment
    [Arguments]    ${input_supplier_code}    ${dict_pr_num}    ${list_newprice}     ${input_nh_discount}    ${input_datrancc}   ${list_num_edit}
    ...    ${list_newprice_edit}    ${list_discount_edit}    ${input_nh_discount_edit}    ${input_tientrancc}
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
    ${reciept_code}    Add new purchase receipt thr API    ${input_supplier_code}    ${dict_pr_num}    ${list_newprice}    ${input_nh_discount}    ${input_datrancc}
    Wait Until Keyword Succeeds    3 times    1s     Delete purchase payment frm API    ${reciept_code}
    #
    Log    Lập phiếu
    Set Selenium Speed    0.1
    Go To nhap Hang
    Reload Page
    Search purchase receipt code and click open    ${reciept_code}
    Edit price, discount and num in NH form   ${list_pr}    ${list_num_edit}    ${list_newprice_edit}    ${list_discount_edit}
    Input discount PNH Invoice    ${input_nh_discount_edit}    ${result_discount_nh}
    Wait Until Keyword Succeeds    3 times    1s    Input pay for supplier and validate    ${actual_tientrancc}    ${result_cantrancc}
    Press Key      //body     ${F9_KEY}
    KV Click Element     ${button_nh_dongy_capnhat}
    Purchase receipt message success validation    ${reciept_code}
    #
    Log    validate thong tin tren phieu nhap
    Assert values by purchase code until succeed    ${reciept_code}    ${input_supplier_code}    ${result_tongtienhang}    ${actual_tientrancc}    ${tong_so_luong}    ${result_cantrancc}    ${result_discount_nh}    Đã nhập hàng
    Run Keyword If    '${input_tientrancc}' == '0'    Validate So quy info from Rest API if Invoice is not paid    ${reciept_code}
    ...    ELSE    Validate So quy info from Rest API if Invoice is paid    PC${reciept_code}-1    -${actual_tientrancc}
    Validate status in Tab No can tra NCC incase purchase order    ${input_supplier_code}    ${reciept_code}    ${actual_tientrancc}
    Assert ma phieu nhap is avaliable in Tab No can tra NCC and Lich su nhap/tra hang    ${input_supplier_code}    ${reciept_code}
    Assert Cong no Nha cung cap    ${input_supplier_code}    ${result_no_ncc}    ${result_tongmua}
    Wait Until Keyword Succeeds    3 times    3s    Assert list of onhand, cost af receipt    ${list_pr_cb}    ${list_result_onhand_cb_af}    ${list_cost_cb_af_ex}
    Log    valdate phiếu nhập có còn trong Lịch sử đặt nhập của NCC cũ
    Delete purchase receipt code    ${reciept_code}
