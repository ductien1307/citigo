*** Settings ***
Suite Setup       Setup Test Suite    Before Test Quan Ly
Suite Teardown     After Test
Resource          ../../../../../core/API/api_dathangnhap.robot
Resource          ../../../../../core/Giao_dich/dat_hang_nhap_add_action.robot
Resource          ../../../../../core/Giao_dich/dat_hang_nhap_list_action.robot
Resource          ../../../../../core/API/api_danhmuc_hanghoa.robot
Resource          ../../../../../core/API/api_nha_cung_cap.robot
Resource          ../../../../../core/Giao_dich/nhaphang_getandcompute.robot
Resource          ../../../../../core/share/toast_message.robot
Resource          ../../../../../core/API/api_soquy.robot

*** Variables ***
&{dict_pr_thuong}    DNT015=11    DNT016=7.8    NQD06=9    DNS013=3
&{dict_giamoi_thuong}    DNT015=85000.25    DNT016=89000    NQD06=70000    DNS013=112000
&{dict_gg_thuong}    DNT015=15    DNT016=0    NQD06=10000.35    DNS013=25000
&{dict_type}      DNT015=15    DNT016=0    NQD06=null    DNS013=null

*** Test Cases ***
Tao PN tu Phieu tam
    [Tags]    EDN2
    [Template]    dhn_03
    [Documentation]   Tạo phiếu NH lấy tất cả hàng hóa từ phiếu DHN ko thanh toán (Phiếu tạm, Đã xác nhận NCC) > check tồn kho, giá vốn, công nợ NCC, sổ quỹ
    NCC0030    ${dict_pr_thuong}    ${dict_giamoi_thuong}    ${dict_gg_thuong}    ${dict_type}    50000     Phiếu tạm      200000
    NCC0031    ${dict_pr_thuong}    ${dict_giamoi_thuong}    ${dict_gg_thuong}    ${dict_type}    30    Đã xác nhận NCC     all

*** Keywords ***
dhn_03
    [Arguments]    ${input_supplier_code}    ${dict_product_num}    ${dict_newprice}    ${dict_discount}    ${dict_discount_type}    ${input_discount}    ${input_status}     ${input_tientrancc}
    Log    tạo phiếu DHN
    ${ma_phieu_dhn}   Run Keyword If    '${input_status}'=='Phiếu tạm'       Add new purchase order no payment thr API    ${input_supplier_code}    ${dict_product_num}    ${dict_newprice}    ${dict_discount}    ${dict_discount_type}    ${input_discount}
    ...   ELSE    Add new purchase order Da xac nhan NCC no payment thr API    ${input_supplier_code}    ${dict_product_num}    ${dict_newprice}    ${dict_discount}    ${dict_discount_type}    ${input_discount}
    #
    Log    tính toán
    ${list_prs}    Get Dictionary Keys    ${dict_product_num}
    ${list_nums}    Get Dictionary Values    ${dict_product_num}
    ${list_newprice}    Get Dictionary Values    ${dict_newprice}
    ${list_discount}    Get Dictionary Values    ${dict_discount}
    Log    get dvcb của list sp
    ${list_pr_cb}    Get list code basic of product unit    ${list_prs}
    Log    tính toán tổng tiền, tồn kho, giá vốn... af ex
    ${list_result_thanhtien_af}    ${list_result_newprice_af}    ${list_result_onhand_cb_af}    ${list_dongia}    ${list_result_onhand_actual_af}    ${list_actual_num_cb}    ${list_result_newprice_cb_af}     ${list_result_newprice_bf}    ${list_result_discount_vnd}
    ...    Get list of total purchase receipt - result onhand actual product in case of price change and have discount    ${list_pr_cb}    ${list_prs}    ${list_nums}    ${list_newprice}    ${list_discount}
    ${result_tongtienhang}      ${result_discount_nh}      ${result_cantrancc}      ${actual_tientrancc}     Conputation total, discount and pay for supplier    ${list_result_thanhtien_af}     ${input_discount}     ${input_tientrancc}
    ${list_cost_cb_af_ex}    Computation list of cost incase purchase order have discount and price change    ${list_pr_cb}    ${list_result_newprice_cb_af}    ${list_actual_num_cb}    ${result_discount_nh}    ${result_tongtienhang}
    Log    tính tổng nợ, tổng mua của nhà cung cấp af ex
    ${result_no_ncc}     ${result_tongmua}     ${result_tongmua_tru_trahang}      Supplier debt calculation af reciept    ${input_supplier_code}    ${result_cantrancc}      ${actual_tientrancc}     Đã nhập hàng
    ${get_list_on_order_af}   Comptation list on order after create purchase receipt   ${list_prs}   ${list_nums}    ${list_nums}    ${input_status}
    #
    Log    Lập phiếu
    Set Selenium Speed    0.1
    Go to Dat Hang Nhap
    Search purchase order code and cllick PO Receipt    ${ma_phieu_dhn}
    ${ma_phieu_nhap}    Generate code automatically    PN
    Input data    ${textbox_nh_ma_phieunhap}    ${ma_phieu_nhap}
    ${list_imei_all}    Input imei in NH form   ${list_prs}   ${list_nums}
    Wait Until Keyword Succeeds    3x    1s    Input pay for supplier and validate    ${actual_tientrancc}    ${result_cantrancc}
    Press Key      //body     ${F9_KEY}
    Purchase receipt message success validation    ${ma_phieu_nhap}
    #
    Log    validate thong tin tren phieu nhap
    ${lastest_num}      Sum values in list      ${list_nums}
    Assert values by purchase code until succeed    ${ma_phieu_nhap}    ${input_supplier_code}    ${result_tongtienhang}    ${actual_tientrancc}    ${lastest_num}    ${result_cantrancc}    ${result_discount_nh}    Đã nhập hàng
    Validate So quy info from API    ${ma_phieu_nhap}    ${actual_tientrancc}    -${actual_tientrancc}      Phiếu chi
    Validate status in Tab No can tra NCC incase purchase order    ${input_supplier_code}    ${ma_phieu_nhap}    ${actual_tientrancc}
    Assert ma phieu nhap is avaliable in Tab No can tra NCC and Lich su nhap/tra hang    ${input_supplier_code}    ${ma_phieu_nhap}
    Assert Cong no Nha cung cap    ${input_supplier_code}    ${result_no_ncc}    ${result_tongmua}
    Wait Until Keyword Succeeds    3 times    3s    Assert list of onhand, cost af receipt    ${list_pr_cb}    ${list_result_onhand_cb_af}    ${list_cost_cb_af_ex}
    Assert sumary in tab Lich su dat hang nhap     ${input_supplier_code}    ${ma_phieu_dhn}     ${result_tongcong_dhn}    Hoàn thành
    Assert list on order af execute    ${list_prs}    ${get_list_on_order_af}
    Delete purchase receipt code    ${ma_phieu_nhap}
    Delete purchase order code    ${ma_phieu_dhn}
