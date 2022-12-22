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
&{dict_pr_thuong}    DNT011=11    DNT012=7.6    DNQD109=9    DNS010=3
&{dict_giamoi_thuong}    DNT011=85000.84    DNT012=89000.21    DNQD109=70000    DNS010=112000
&{dict_gg_thuong}    DNT011=15    DNT012=0    DNQD109=10000    DNS010=25000
&{dict_type}      DNT011=15    DNT012=0    DNQD109=null    DNS010=null

*** Test Cases ***
Tao PN tu Phieu tam
    [Tags]    EDN1
    [Template]    dhn_08
    [Documentation]   Tạo phiếu NH lấy tất cả hàng hóa từ phiếu DHN có thanh toán (Phiếu tạm, Đã xác nhận NCC) > check tồn kho, giá vốn, công nợ NCC, sổ quỹ
    NCC0039    ${dict_pr_thuong}    ${dict_giamoi_thuong}    ${dict_gg_thuong}    ${dict_type}    30    50000   Phiếu tạm    0
    NCC0042    ${dict_pr_thuong}    ${dict_giamoi_thuong}    ${dict_gg_thuong}    ${dict_type}    30000    250000     Đã xác nhận NCC     50000

*** Keywords ***
dhn_08
    [Arguments]    ${input_supplier_code}    ${dict_product_num}    ${dict_newprice}    ${dict_discount}    ${dict_discount_type}    ${input_discount}    ${input_tientracc_bf}    ${input_status}     ${input_tientrancc}
    Log    tạo phiếu DHN
    ${ma_phieu_dhn}   Run Keyword If    '${input_status}'=='Phiếu tạm'       Add new purchase order have payment thr API    ${input_supplier_code}    ${dict_product_num}    ${dict_newprice}    ${dict_discount}    ${dict_discount_type}    ${input_discount}     ${input_tientracc_bf}
    ...   ELSE    Add new purchase order Da xac nhan NCC have payment thr API    ${input_supplier_code}    ${dict_product_num}    ${dict_newprice}    ${dict_discount}    ${dict_discount_type}    ${input_discount}    ${input_tientracc_bf}
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
    ${result_cantrancc_bf}   Minus     ${result_cantrancc}     ${input_tientracc_bf}
    ${total_tongtientra_ncc}      Sum     ${input_tientracc_bf}     ${input_tientrancc}
    ${list_cost_cb_af_ex}    Computation list of cost incase purchase order have discount and price change    ${list_pr_cb}    ${list_result_newprice_cb_af}    ${list_actual_num_cb}    ${result_discount_nh}    ${result_tongtienhang}
    Log    tính tổng nợ, tổng mua của nhà cung cấp af ex
    ${result_no_ncc}     ${result_tongmua}     ${result_tongmua_tru_trahang}      Supplier debt calculation af reciept    ${input_supplier_code}    ${result_cantrancc}      ${input_tientrancc}     Đã nhập hàng
    ${get_list_on_order_af}   Comptation list on order after create purchase receipt   ${list_prs}   ${list_nums}    ${list_nums}    ${input_status}
    #
    Log    Lập phiếu
    Set Selenium Speed    0.1
    Go to Dat Hang Nhap
    Search purchase order code and cllick PO Receipt    ${ma_phieu_dhn}
    ${ma_phieu_nhap}    Generate code automatically    PN
    Input data    ${textbox_nh_ma_phieunhap}    ${ma_phieu_nhap}
    ${list_imei_all}    Input imei in NH form   ${list_prs}    ${list_nums}
    Wait Until Keyword Succeeds    3x    1s    Input pay for supplier and validate    ${actual_tientrancc}    ${result_cantrancc_bf}
    Press Key      //body     ${F9_KEY}
    Purchase receipt message success validation    ${ma_phieu_nhap}
    #
    Log    validate thong tin tren phieu nhap
    ${lastest_num}      Sum values in list      ${list_nums}
    Assert values by purchase code until succeed    ${ma_phieu_nhap}    ${input_supplier_code}    ${result_tongtienhang}    ${total_tongtientra_ncc}    ${lastest_num}    ${result_cantrancc}    ${result_discount_nh}    Đã nhập hàng
    Validate So quy info from API    ${ma_phieu_nhap}    ${actual_tientrancc}    -${actual_tientrancc}      Phiếu thu
    Validate status in Tab No can tra NCC incase purchase order    ${input_supplier_code}    ${ma_phieu_nhap}    ${actual_tientrancc}
    Assert ma phieu nhap is avaliable in Tab No can tra NCC and Lich su nhap/tra hang    ${input_supplier_code}    ${ma_phieu_nhap}
    Assert Cong no Nha cung cap    ${input_supplier_code}    ${result_no_ncc}    ${result_tongmua}
    Wait Until Keyword Succeeds    3 times    3s    Assert list of onhand, cost af receipt    ${list_pr_cb}    ${list_result_onhand_cb_af}    ${list_cost_cb_af_ex}
    Assert sumary in tab Lich su dat hang nhap     ${input_supplier_code}    ${ma_phieu_dhn}     ${result_tongcong_dhn}    Hoàn thành
    Assert list on order af execute    ${list_prs}    ${get_list_on_order_af}
    Delete purchase receipt code    ${ma_phieu_nhap}
    Delete purchase order code    ${ma_phieu_dhn}
