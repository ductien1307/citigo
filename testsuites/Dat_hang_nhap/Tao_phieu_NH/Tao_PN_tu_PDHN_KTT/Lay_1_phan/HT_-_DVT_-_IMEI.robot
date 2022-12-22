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
&{dict_pr}        DNT013=11.4    DNT014=7.6    DNQD110=9    DNS011=3    DNS012=4
&{dict_giamoi}    DNT013=85000.84    DNT014=89000.63    DNQD110=70000    DNS011=112000    DNS012=55000
&{dict_gg}        DNT013=15    DNT014=0    DNQD110=10000.25    DNS011=25000    DNS012=5
&{dict_type}      DNT013=15    DNT014=0    DNQD110=null    DNS011=null    DNS012=5
&{dict_pr_edit}    DNT013=3    DNT014=0    DNQD110=6.2    DNS011=0    DNS012=2

*** Test Cases ***
Tao PN tu Phieu DHN khong thanh toan
    [Tags]    EDN2
    [Template]    dhn_01
    [Documentation]   Tạo phiếu NH lấy 1 phần hàng hóa từ phiếu DHN ko thanh toán (Phiếu tạm, Đã xác nhận NCC) > check tồn kho, giá vốn, công nợ NCC, sổ quỹ
    NCC0025    ${dict_pr}    ${dict_giamoi}    ${dict_gg}    ${dict_type}    20     Phiếu tạm       ${dict_pr_edit}    all
    NCC0028    ${dict_pr}    ${dict_giamoi}    ${dict_gg}    ${dict_type}    20     Đã xác nhận NCC     ${dict_pr_edit}    150000

*** Keywords ***
dhn_01
    [Arguments]    ${input_supplier_code}    ${dict_product_num}    ${dict_newprice}    ${dict_discount}    ${dict_discount_type}    ${input_discount}    ${input_status}    ${dict_update}     ${input_tientrancc}
    Log    tạo phiếu DHN
    ${ma_phieu_dhn}   Run Keyword If    '${input_status}'=='Phiếu tạm'       Add new purchase order no payment thr API    ${input_supplier_code}    ${dict_product_num}    ${dict_newprice}    ${dict_discount}    ${dict_discount_type}    ${input_discount}
    ...   ELSE    Add new purchase order Da xac nhan NCC no payment thr API    ${input_supplier_code}    ${dict_product_num}    ${dict_newprice}    ${dict_discount}    ${dict_discount_type}    ${input_discount}
    #
    Log    tính toán
    ${list_prs_update}    Get Dictionary Keys    ${dict_update}
    ${list_nums_update}    Get Dictionary Values    ${dict_update}
    ${list_nums}     Get Dictionary Values    ${dict_product_num}
    ${list_newprice}    Get Dictionary Values    ${dict_newprice}
    ${list_discount}    Get Dictionary Values    ${dict_discount}
    Log    get dvcb của list sp
    ${list_pr_cb}    Get list code basic of product unit    ${list_prs_update}
    Log    tính toán tổng tiền, tồn kho, giá vốn... af ex
    ${list_result_thanhtien_af}    ${list_result_newprice_af}    ${list_result_onhand_cb_af}    ${list_dongia}    ${list_result_onhand_actual_af}    ${list_actual_num_cb}    ${list_result_newprice_cb_af}     ${list_result_newprice_bf}    ${list_result_discount_vnd}
    ...    Get list of total purchase receipt - result onhand actual product in case of price change and have discount    ${list_pr_cb}    ${list_prs_update}    ${list_nums_update}    ${list_newprice}    ${list_discount}
    ${result_tongtienhang}      ${result_discount_nh}      ${result_cantrancc}      ${actual_tientrancc}     Conputation total, discount and pay for supplier    ${list_result_thanhtien_af}     ${input_discount}     ${input_tientrancc}
    ${list_cost_cb_af_ex}    Computation list of cost incase purchase order have discount and price change    ${list_pr_cb}    ${list_result_newprice_cb_af}    ${list_actual_num_cb}    ${result_discount_nh}    ${result_tongtienhang}
    Log    tính tổng nợ, tổng mua của nhà cung cấp af ex
    ${result_no_ncc}     ${result_tongmua}     ${result_tongmua_tru_trahang}      Supplier debt calculation af reciept    ${input_supplier_code}    ${result_cantrancc}      ${actual_tientrancc}     Đã nhập hàng
    ${get_list_on_order_af}   Comptation list on order after create purchase receipt   ${list_prs_update}   ${list_nums}    ${list_nums_update}    ${input_status}
    #
    Log    Lập phiếu
    Set Selenium Speed    0.1
    Go to Dat Hang Nhap
    Search purchase order code and cllick PO Receipt    ${ma_phieu_dhn}
    ${ma_phieu_nhap}    Generate code automatically    PN
    Input data    ${textbox_nh_ma_phieunhap}    ${ma_phieu_nhap}
    ${list_imei_all}    Input num and remove product in NH form   ${list_prs_update}    ${list_nums_update}
    Wait Until Keyword Succeeds    3x    1s    Input pay for supplier and validate    ${actual_tientrancc}    ${result_cantrancc}
    Press Key      //body     ${F9_KEY}
    KV Click Element JS    ${button_nh_boqua_hoanthanh_dhn}
    Purchase receipt message success validation    ${ma_phieu_nhap}
    #
    Log    validate thong tin tren phieu nhap
    ${lastest_num}      Sum values in list      ${list_nums_update}
    Assert values by purchase code until succeed    ${ma_phieu_nhap}    ${input_supplier_code}    ${result_tongtienhang}    ${actual_tientrancc}    ${lastest_num}    ${result_cantrancc}    ${result_discount_nh}    Đã nhập hàng
    Validate So quy info from API    ${ma_phieu_nhap}    ${actual_tientrancc}    -${actual_tientrancc}      Phiếu chi
    Validate status in Tab No can tra NCC incase purchase order    ${input_supplier_code}    ${ma_phieu_nhap}    ${actual_tientrancc}
    Assert ma phieu nhap is avaliable in Tab No can tra NCC and Lich su nhap/tra hang    ${input_supplier_code}    ${ma_phieu_nhap}
    Assert Cong no Nha cung cap    ${input_supplier_code}    ${result_no_ncc}    ${result_tongmua}
    Wait Until Keyword Succeeds    3 times    3s    Assert list of onhand, cost af receipt    ${list_pr_cb}    ${list_result_onhand_cb_af}    ${list_cost_cb_af_ex}
    Assert sumary in tab Lich su dat hang nhap     ${input_supplier_code}    ${ma_phieu_dhn}     ${result_tongcong_dhn}    Nhập một phần
    Assert list on order af execute    ${list_prs_update}    ${get_list_on_order_af}
    Delete purchase receipt code    ${ma_phieu_nhap}
    Delete purchase order code    ${ma_phieu_dhn}
