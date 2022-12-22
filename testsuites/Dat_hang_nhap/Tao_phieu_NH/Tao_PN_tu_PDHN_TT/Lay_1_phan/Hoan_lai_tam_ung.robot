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
&{dict_pr}        DNT007=11.7    DNT008=7.6    DNQD006=9    DNS005=3    DNS006=4
&{dict_giamoi}    DNT007=85000.84    DNT008=89000.23    DNQD006=70000    DNS005=112000    DNS006=55000.74
&{dict_gg}        DNT007=15    DNT008=0    DNQD006=10000    DNS005=25000.65    DNS006=5
&{dict_type}      DNT007=15    DNT008=0    DNQD006=null    DNS005=null    DNS006=5
&{dict_pr_edit}    DNT007=11.7    DNT008=0    DNQD006=9    DNS005=0    DNS006=2

*** Test Cases ***
Tao phieu PN co hoan tra tam ung
    [Tags]    EDN1
    [Template]    dhn_05
    [Documentation]   Tạo phiếu NH lấy 1 phần hàng hóa có hoàn trả tạm ứng (Phiếu tạm, Đã xác nhận NCC) > check tồn kho, giá vốn, công nợ NCC, sổ quỹ
    NCC0034    ${dict_pr}    ${dict_giamoi}    ${dict_gg}    ${dict_type}    50000    all   Phiếu tạm  ${dict_pr_edit}    60000
    NCC0034    ${dict_pr}    ${dict_giamoi}    ${dict_gg}    ${dict_type}    50000    all   Đã xác nhận NCC  ${dict_pr_edit}    all

*** Keywords ***
dhn_05
    [Arguments]    ${input_supplier_code}    ${dict_product_num}    ${dict_newprice}    ${dict_discount}    ${dict_discount_type}    ${input_discount}    ${input_tientracc_bf}    ${input_status}    ${dict_update}     ${input_hoanlaitamung}
    Log    tạo phiếu DHN
    ${ma_phieu_dhn}   Run Keyword If    '${input_status}'=='Phiếu tạm'       Add new purchase order have payment thr API    ${input_supplier_code}    ${dict_product_num}    ${dict_newprice}    ${dict_discount}    ${dict_discount_type}    ${input_discount}     ${input_tientracc_bf}
    ...   ELSE    Add new purchase order Da xac nhan NCC have payment thr API    ${input_supplier_code}    ${dict_product_num}    ${dict_newprice}    ${dict_discount}    ${dict_discount_type}    ${input_discount}    ${input_tientracc_bf}
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
    ${result_tongtienhang}      ${result_discount_nh}      ${result_cantrancc}      ${actual_tientrancc}     Conputation total, discount and pay for supplier    ${list_result_thanhtien_af}     ${input_discount}     ${result_tongcong_dhn}
    ${result_cantrancc_bf}   Minus     ${result_cantrancc}     ${result_tongcong_dhn}
    ${list_cost_cb_af_ex}    Computation list of cost incase purchase order have discount and price change    ${list_pr_cb}    ${list_result_newprice_cb_af}    ${list_actual_num_cb}    ${result_discount_nh}    ${result_tongtienhang}
    #
    ${result_hoanlaitamung_all}    Minus and replace floating point    ${result_tongcong_dhn}    ${result_cantrancc}
    ${result_hoanlaitamung}    Set Variable If    '${input_hoanlaitamung}'=='all'    ${result_hoanlaitamung_all}    ${input_hoanlaitamung}
    #${actual_tientrancc}    Minus    ${get_datrancc}    ${result_hoanlaitamung}
    Log    tính tổng nợ, tổng mua của nhà cung cấp af ex
    ${result_no_ncc}     ${result_tongmua}     ${result_tongmua_tru_trahang}      Supplier debt calculation af reciept    ${input_supplier_code}    ${result_cantrancc}      0     Đã nhập hàng
    ${result_no_ncc}    Sum    ${result_no_ncc}   ${result_hoanlaitamung}
    #
    Log    Lập phiếu
    Set Selenium Speed    0.1
    Go to Dat Hang Nhap
    Search purchase order code and cllick PO Receipt    ${ma_phieu_dhn}
    ${ma_phieu_nhap}    Generate code automatically    PN
    Input data    ${textbox_nh_ma_phieunhap}    ${ma_phieu_nhap}
    ${list_imei_all}    Input num and remove product in NH form   ${list_prs_update}    ${list_nums_update}
    Run Keyword If    '${input_hoanlaitamung}'!='all'    Input data    ${textbox_hoan_lai_tam_ung}    ${result_hoanlaitamung}
    ...    ELSE    Log    Ignore input hoan lai tam ung
    Press Key      //body     ${F9_KEY}
    KV Click Element JS    ${button_nh_boqua_hoanthanh_dhn}
    Purchase receipt message success validation    ${ma_phieu_nhap}
    #
    Log    validate thong tin tren phieu nhap
    ${lastest_num}      Sum values in list      ${list_nums_update}
    Assert values by purchase code until succeed    ${ma_phieu_nhap}    ${input_supplier_code}    ${result_tongtienhang}    ${result_cantrancc}    ${lastest_num}    ${result_cantrancc}    ${result_discount_nh}    Đã nhập hàng
    Validate So quy info from API    ${ma_phieu_nhap}    ${result_hoanlaitamung}    ${result_hoanlaitamung}      Phiếu thu
    Validate status in Tab No can tra NCC incase purchase order    ${input_supplier_code}    ${ma_phieu_nhap}    ${actual_tientrancc}
    Assert ma phieu nhap is avaliable in Tab No can tra NCC and Lich su nhap/tra hang    ${input_supplier_code}    ${ma_phieu_nhap}
    Assert Cong no Nha cung cap    ${input_supplier_code}    ${result_no_ncc}    ${result_tongmua}
    Wait Until Keyword Succeeds    3 times    3s    Assert list of onhand, cost af receipt    ${list_pr_cb}    ${list_result_onhand_cb_af}    ${list_cost_cb_af_ex}
    Assert sumary in tab Lich su dat hang nhap     ${input_supplier_code}    ${ma_phieu_dhn}     ${result_tongcong_dhn}    Nhập một phần
    Delete purchase receipt code    ${ma_phieu_nhap}
    Delete purchase order code    ${ma_phieu_dhn}
