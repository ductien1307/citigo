*** Settings ***
Suite Setup       Setup Test Suite    Before Test Quan Ly
Suite Teardown     After Test
Library           Collections
Resource          ../../../../core/hang_hoa/hang_hoa_navigation.robot
Resource          ../../../../core/share/computation.robot
Resource          ../../../../core/Giao_dich/dat_hang_nhap_add_action.robot
Resource          ../../../../core/Giao_dich/dat_hang_nhap_list_action.robot
Resource          ../../../../core/Giao_dich/giaodich_nav.robot
Resource          ../../../../core/API/api_danhmuc_hanghoa.robot
Resource          ../../../../core/Doi_Tac/doitac_navigation.robot
Resource          ../../../../core/Doi_Tac/ncc_list_action.robot
Resource          ../../../../core/So_Quy/so_quy_list_action.robot
Resource          ../../../../core/share/toast_message.robot
Resource          ../../../../core/API/api_nha_cung_cap.robot
Resource          ../../../../core/API/api_dathangnhap.robot
Resource          ../../../../core/API/api_soquy.robot
Resource          ../../../../core/Giao_dich/nhaphang_getandcompute.robot
Resource          ../../../../core/Giao_dich/nhap_hang_add_action.robot

*** Variables ***
&{dict_pr}        DNT019=11.4    DNT020=7.6    DNQD011=9    DNS002=3    DNS003=4
&{dict_giamoi}    DNT019=85000.84    DNT020=89000.63    DNQD011=70000    DNS002=112000    DNS003=55000
&{dict_gg}        DNT019=15    DNT020=0    DNQD011=10000.25    DNS002=25000    DNS003=5
&{dict_type}      DNT019=15    DNT020=0    DNQD011=null    DNS002=null    DNS003=5
&{dict_pr_edit}    DNT019=2    DNT020=0    DNQD011=5    DNS002=3    DNS003=0

&{dict_pr1}        DNQD108=5    DNS018=2    DNT018=7.5
&{dict_giamoi1}    DNQD108=75000.6    DNS018=95000.63    DNT018=70000
&{dict_gg1}        DNQD108=10    DNS018=15000.25    DNT018=0
&{dict_type1}      DNQD108=10    DNS018=null    DNT018=0
&{CPNH1}           CPNH4=none    CPNH5=none
&{CPNHK1}          CPNH10=none    CPNH16=none
&{CPNH2}          CPNH3=25    CPNH8=35000
&{CPNHK2}         CPNH11=30000    CPNH16=35

*** Test Cases ***
Lấy 1 phần đơn hàng
    [Documentation]    Phiếu ĐHN - ko thanh toán > Tạo phiếu NH lấy 1 phần đơn hàng và add thêm CPNH, CPNHK > check tồn kho, giá vốn, công nợ NCC, sổ quỹ
    [Tags]        EDNC2
    [Template]    dhnc03
    NCC0006    ${dict_pr}    ${dict_giamoi}    ${dict_gg}    ${dict_type}    20    Phiếu tạm    ${dict_pr_edit}    all          ${CPNH1}    ${CPNHK1}

Lấy all đơn hàng
    [Documentation]    Phiếu ĐHN từ phiếu dhn - có thanh toán > Tạo phiếu NH lấy all đơn hàng và add thêm CPNH, CPNHK > check tồn kho, giá vốn, công nợ NCC, sổ quỹ
    [Tags]        EDNC2
    [Template]    dhnc04
    NCC0007    ${dict_pr1}    ${dict_giamoi1}    ${dict_gg1}    ${dict_type1}   30000    250000    Đã xác nhận NCC     50000    ${CPNH2}    ${CPNHK2}

*** Keywords ***
dhnc03
    [Documentation]    Tạo PN từ phiếu dhn ko thanh toán - lấy 1 phần đơn hàng - CPNH ko tự động
    [Arguments]    ${input_supplier_code}    ${dict_product_num}    ${dict_newprice}    ${dict_discount}    ${dict_discount_type}    ${input_discount}    ${input_status}    ${dict_update}     ${input_tientrancc}   ${dict_cpnh}    ${dict_cpnhk}
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
    ${list_cpnh}    Get Dictionary Keys    ${dict_cpnh}
    ${list_value_cpnh}    Get Dictionary Values    ${dict_cpnh}
    ${list_cpnhk}    Get Dictionary Keys    ${dict_cpnhk}
    ${list_value_cpnhk}    Get Dictionary Values    ${dict_cpnhk}
    #
    Log    tính CPNH
    ${list_supplier_charge_defaul}      ${list_supplier_charge_auto}      ${list_other_charge_defaul}       ${list_other_charge_auto}      Get list supplier charge and other charge values thr API    ${list_cpnh}      ${list_cpnhk}
    Log    get dvcb của list sp
    ${list_pr_cb}    Get list code basic of product unit    ${list_prs_update}
    Log    tính toán tổng tiền, tồn kho, giá vốn... af ex
    ${list_result_thanhtien_af}    ${list_result_newprice_af}    ${list_result_onhand_cb_af}    ${list_dongia}    ${list_result_onhand_actual_af}    ${list_actual_num_cb}    ${list_result_newprice_cb_af}     ${list_result_newprice_bf}    ${list_result_discount_vnd}
    ...    Get list of total purchase receipt - result onhand actual product in case of price change and have discount    ${list_pr_cb}    ${list_prs_update}    ${list_nums_update}    ${list_newprice}    ${list_discount}
    ${result_tongtienhang}      ${result_discount_nh}   ${result_tongtien_tru_gg}     ${result_cantrancc}     ${actual_tientrancc}     ${total_expense_value}   ${total_supplier_charge}    ${total_other_charge}     Conputation total, discount and pay for supplier in case have expense value    ${list_result_thanhtien_af}     ${input_discount}     ${input_tientrancc}   ${list_supplier_charge_defaul}    ${list_other_charge_defaul}       ${list_value_cpnh}      ${list_value_cpnhk}
    ${list_cost_cb_af_ex}    Computation list of cost incase purchase order have discount, price change and have expense    ${list_pr_cb}    ${list_result_newprice_cb_af}    ${list_actual_num_cb}    ${result_discount_nh}    ${result_tongtienhang}
    ...    ${total_expense_value}
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
    Select list supplier's charge and input value     ${list_cpnh}      ${list_supplier_charge_auto}     ${list_value_cpnh}   ${result_tongtien_tru_gg}
    Select list other charge and input value       ${list_cpnhk}       ${list_other_charge_auto}      ${list_value_cpnhk}      ${result_tongtien_tru_gg}
    Wait Until Keyword Succeeds    3x    1s    Input pay for supplier and validate    ${actual_tientrancc}    ${result_cantrancc}
    Press Key      //body     ${F9_KEY}
    KV Click Element JS    ${button_nh_boqua_hoanthanh_dhn}
    Purchase receipt message success validation    ${ma_phieu_nhap}
    #
    Log    tắt CPNH
    Toggle list supplier's charge    ${list_cpnh}    ${list_supplier_charge_defaul}
    Toggle list other charge    ${list_cpnhk}    ${list_other_charge_defaul}
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

dhnc04
    [Documentation]    Tạo PN từ phiếu dhn tạm - có thanh toán - lấy all đơn hàng - CPNH tự động
    [Arguments]    ${input_supplier_code}    ${dict_product_num}    ${dict_newprice}    ${dict_discount}    ${dict_discount_type}    ${input_discount}    ${input_tientracc_bf}    ${input_status}     ${input_tientrancc}     ${dict_cpnh}    ${dict_cpnhk}
    Log    tạo phiếu DHN
    ${ma_phieu_dhn}   Run Keyword If    '${input_status}'=='Phiếu tạm'       Add new purchase order have payment thr API    ${input_supplier_code}    ${dict_product_num}    ${dict_newprice}    ${dict_discount}    ${dict_discount_type}    ${input_discount}     ${input_tientracc_bf}
    ...   ELSE    Add new purchase order Da xac nhan NCC have payment thr API    ${input_supplier_code}    ${dict_product_num}    ${dict_newprice}    ${dict_discount}    ${dict_discount_type}    ${input_discount}    ${input_tientracc_bf}
    #
    Log    tính toán
    ${list_prs}    Get Dictionary Keys    ${dict_product_num}
    ${list_nums}    Get Dictionary Values    ${dict_product_num}
    ${list_newprice}    Get Dictionary Values    ${dict_newprice}
    ${list_discount}    Get Dictionary Values    ${dict_discount}
    ${list_cpnh}    Get Dictionary Keys    ${dict_cpnh}
    ${list_value_cpnh}    Get Dictionary Values    ${dict_cpnh}
    ${list_cpnhk}    Get Dictionary Keys    ${dict_cpnhk}
    ${list_value_cpnhk}    Get Dictionary Values    ${dict_cpnhk}
    #
    Log    tính CPNH
    ${list_supplier_charge_defaul}      ${list_supplier_charge_auto}      ${list_other_charge_defaul}       ${list_other_charge_auto}      Get list supplier charge and other charge values thr API    ${list_cpnh}      ${list_cpnhk}
    Log    get dvcb của list sp
    ${list_pr_cb}    Get list code basic of product unit    ${list_prs}
    Log    tính toán tổng tiền, tồn kho, giá vốn... af ex
    ${list_result_thanhtien_af}    ${list_result_newprice_af}    ${list_result_onhand_cb_af}    ${list_dongia}    ${list_result_onhand_actual_af}    ${list_actual_num_cb}    ${list_result_newprice_cb_af}     ${list_result_newprice_bf}    ${list_result_discount_vnd}
    ...    Get list of total purchase receipt - result onhand actual product in case of price change and have discount    ${list_pr_cb}    ${list_prs}    ${list_nums}    ${list_newprice}    ${list_discount}
    ${result_tongtienhang}      ${result_discount_nh}   ${result_tongtien_tru_gg}     ${result_cantrancc}     ${actual_tientrancc}     ${total_expense_value}   ${total_supplier_charge}    ${total_other_charge}     Conputation total, discount and pay for supplier in case have expense value    ${list_result_thanhtien_af}     ${input_discount}     ${input_tientrancc}   ${list_supplier_charge_defaul}    ${list_other_charge_defaul}       ${list_value_cpnh}      ${list_value_cpnhk}
    ${result_cantrancc_bf}   Minus     ${result_cantrancc}     ${input_tientracc_bf}
    ${total_tongtientra_ncc}      Sum     ${input_tientracc_bf}     ${input_tientrancc}
    ${list_cost_cb_af_ex}    Computation list of cost incase purchase order have discount, price change and have expense    ${list_pr_cb}    ${list_result_newprice_cb_af}    ${list_actual_num_cb}    ${result_discount_nh}    ${result_tongtienhang}
    ...    ${total_expense_value}
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
    Select list supplier's charge and input value     ${list_cpnh}      ${list_supplier_charge_auto}     ${list_value_cpnh}   ${result_tongtien_tru_gg}
    Select list other charge and input value       ${list_cpnhk}       ${list_other_charge_auto}      ${list_value_cpnhk}      ${result_tongtien_tru_gg}
    Wait Until Keyword Succeeds    3x    1s    Input pay for supplier and validate    ${actual_tientrancc}    ${result_cantrancc_bf}
    Press Key      //body     ${F9_KEY}
    Purchase receipt message success validation    ${ma_phieu_nhap}
    #
    Log    tắt CPNH
    Toggle list supplier's charge    ${list_cpnh}    ${list_supplier_charge_defaul}
    Toggle list other charge    ${list_cpnhk}    ${list_other_charge_defaul}
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



abc
    [Arguments]    ${ma_ncc}    ${input_tientrancc}     ${list_cpnh}    ${list_cpnhk}
    Log    Bat cpnh va get list gia tri
    ${list_supplier_charge_value}    Create List
    : FOR    ${item_cpnh}    IN ZIP    ${list_cpnh}
    \    ${supplier_charge_vnd}    Get expense VND value    ${item_cpnh}
    \    ${supplier_charge_%}    Get expense percentage value    ${item_cpnh}
    \    ${supplier_charge_value}    Set Variable If    ${supplier_charge_%}==0    ${supplier_charge_vnd}    ${supplier_charge_%}
    \    Run Keyword If    ${supplier_charge_value}>100    Toggle supplier's charge VND    ${item_cpnh}    true
    \    ...    ELSE    Toggle supplier's charge %    ${item_cpnh}    true
    \    Append To List    ${list_supplier_charge_value}    ${supplier_charge_value}
    Log    ${list_supplier_charge_value}
    #
    ${list_other_charge_value}    Create List
    : FOR    ${item_cpnhk}    IN ZIP    ${list_cpnhk}
    \    ${other_charge_vnd}    Get expense VND value    ${item_cpnhk}
    \    ${other_charge_%}    Get expense percentage value    ${item_cpnhk}
    \    ${other_charge_value}    Set Variable If    ${other_charge_%}==0    ${other_charge_vnd}    ${other_charge_%}
    \    Run Keyword If    ${other_charge_value}>100    Toggle other charge VND    ${item_cpnhk}    true
    \    ...    ELSE    Toggle other charge %    ${item_cpnhk}    true
    \    Append To List    ${list_other_charge_value}    ${other_charge_value}
    Log    ${list_other_charge_value}
    #
    Log    Get thong tin phieu dat nhap
    ${ma_phieu_dat}    Get first purchase order code frm API    ${ma_ncc}
    ${get_soluong}    ${get_tongtienhang}    ${get_giamgia_vnd}    ${get_giamgia_%}    ${get_datrancc}    ${get_cantrancc}    Get purchase order summary thr api
    ...    ${ma_phieu_dat}
    ${get_list_prs}    Get list product in purchase order frm API    ${ma_phieu_dat}
    ${get_list_imei_status}    Get list imei status thr API    ${get_list_prs}
    ${list_price_af_discount}    ${list_num}    ${list_thanhtien}    Get list infor in purchase order detail frm API    ${ma_phieu_dat}    ${get_list_prs}
    ${get_no_ncc_hientai}    ${get_tong_mua}    ${get_tong_mua_tru_tra_hang}    Get Supplier Debt from API    ${ma_ncc}
    ${result_tongtien_tru_gg}       Minus    ${get_tongtienhang}    ${get_giamgia_vnd}
    #
    Log    Get list dvcb cua sp
    ${list_prs_cb}    Get list code basic of product unit    ${get_list_prs}
    ${list_price_cb}    ${list_num_cb}    Computation list price and num of basic product    ${get_list_prs}    ${list_price_af_discount}    ${list_num}
    #
    Log    tinh tong cpnh
    ${total_supplier_charge}    Set Variable    0
    : FOR    ${item_supplier_charge}    IN ZIP    ${list_supplier_charge_value}
    \    ${item_supplier_charge}=    Run Keyword If    ${item_supplier_charge}> 100    Set Variable    ${item_supplier_charge}
    \    ...    ELSE    Convert % discount to VND and round    ${item_supplier_charge}    ${result_tongtien_tru_gg}
    \    ${total_supplier_charge}    Sum    ${total_supplier_charge}    ${item_supplier_charge}
    \    Log    ${total_supplier_charge}
    ${total_other_charge}    Set Variable    0
    : FOR    ${item_other_charge}    IN ZIP    ${list_other_charge_value}
    \    ${item_other_charge}=    Run Keyword If    ${item_other_charge}>100    Set Variable    ${item_other_charge}
    \    ...    ELSE    Convert % discount to VND and round    ${item_other_charge}    ${result_tongtien_tru_gg}
    \    ${total_other_charge}    Sum    ${total_other_charge}    ${item_other_charge}
    \    Log    ${total_other_charge}
    ${total_expense_value}    Sum    ${total_supplier_charge}    ${total_other_charge}
    ${result_tongtienhang_gg_cpnh}      Sum    ${result_tongtien_tru_gg}    ${total_supplier_charge}
    ${result_cantrancc_af}    Minus    ${result_tongtienhang_gg_cpnh}    ${get_datrancc}
    #
    Log    tinh toan gia von
    ${list_cost_af}    Computation list of cost incase purchase order have discount, price change and have expense    ${list_prs_cb}    ${list_price_cb}    ${list_num_cb}    ${get_giamgia_vnd}    ${get_tongtienhang}    ${total_expense_value}
    ${list_onhand_af}    Get list onhand after purchase receipt    ${list_prs_cb}    ${list_num_cb}
    Log    tinh so luong dat ncc
    ${get_list_on_order_af}    Computation list on order after purchase receipt frm processing    ${get_list_prs}    ${list_num}
    #
    Log    Tao phieu
    Search purchase order code and cllick PO Receipt    ${ma_phieu_dat}
    ${ma_phieu_nhap}    Generate code automatically    PN
    Input data    ${textbox_nh_ma_phieunhap}    ${ma_phieu_nhap}
    ${list_imei_all}    Create List
    : FOR    ${item_pr}    ${item_num}    ${item_status}    IN ZIP    ${get_list_prs}    ${list_num}
    ...    ${get_list_imei_status}
    \    ${list_imei}    Run Keyword If    '${item_status}'=='True'    Create list imei by generating random    ${item_num}
    \    ...    ELSE    Log    Ignore
    \    Run Keyword If    '${item_status}'=='True'    Input IMEIs in NH form    ${item_pr}    ${list_imei}
    \    ...    ELSE    Log    Ignore input imei
    \    Append To List    ${list_imei_all}    ${list_imei}
    Log    ${list_imei_all}
    ${actual_tientrancc}    Set Variable If    '${input_tientrancc}'=='all'    ${result_cantrancc_af}    ${input_tientrancc}
    ${actual_tientrancc}    Run Keyword If    '${input_tientrancc}'=='all'    Replace floating point    ${actual_tientrancc}
    ...    ELSE    Set Variable    ${input_tientrancc}
    Wait Until Keyword Succeeds    3 times    10s    Assert expense value    0      ${cell_supplier_charge_value}
    Wait Until Keyword Succeeds    3 times    10s    Assert expense value    0      ${cell_other_charge_value}
    Wait Until Keyword Succeeds    3 times    3 s    Open supplier's charge and validate value        ${total_supplier_charge}
    Wait Until Keyword Succeeds    3 times    3 s    Open other charge and validate value           ${total_other_charge}
    #
    Run Keyword If    ${actual_tientrancc}==0    Log    Ignore input ncc
    ...    ELSE    Input pay for supplier and validate    ${actual_tientrancc}    ${result_cantrancc_af}
    ${sum_tientrancc}    Sum    ${get_datrancc}    ${actual_tientrancc}
    #
    ${result_no_phieunhap}    Minus    ${result_tongtienhang_gg_cpnh}    ${actual_tientrancc}
    ${result_no_ncc}    Sum    ${get_no_ncc_hientai}    ${result_no_phieunhap}
    ${result_tongmua}    Sum    ${result_tongtienhang_gg_cpnh}    ${get_tong_mua}
    ${result_tongmua_tru_trahang}    Sum    ${result_tongtienhang_gg_cpnh}    ${get_tong_mua_tru_tra_hang}
    #
    #Click Element     ${button_nh_hoanthanh}
    Press Key      //body     ${F9_KEY}
    #
    Sleep    30s    #wait for response to API
    Go to Dat Hang Nhap
    Log    tat cpnh
    : FOR    ${item_cpnh}    ${item_sp_charge_value}    IN ZIP    ${list_cpnh}    ${list_supplier_charge_value}
    \    Run Keyword If    ${item_sp_charge_value}>100    Toggle supplier's charge VND    ${item_cpnh}    false
    \    ...    ELSE    Toggle supplier's charge %    ${item_cpnh}    false
    : FOR    ${item_cpnhk}    ${item_other_charge_value}    IN ZIP    ${list_cpnhk}    ${list_other_charge_value}
    \    Run Keyword If    ${item_other_charge_value}>100    Toggle other charge VND    ${item_cpnhk}    false
    \    ...    ELSE    Toggle other charge %    ${item_cpnhk}    false
    Log    validate thong tin tren phieu dat nhap
    ${get_supplier_code_dh}    ${get_tongtienhang_dh}    ${get_tiendatra_ncc_dh}    ${get_giamgia_pn_dh}    ${get_tongcong_dh}    ${get_tongsoluong_dh}    ${get_trangthai_dh}
    ...    Get purchase order info by purchase order code    ${ma_phieu_dat}
    Should Be Equal As Strings    ${get_supplier_code_dh}    ${ma_ncc}
    Should Be Equal As Numbers    ${get_tongtienhang_dh}    ${get_tongtienhang}
    Should Be Equal As Numbers    ${get_tiendatra_ncc_dh}    ${sum_tientrancc}
    Should Be Equal As Numbers    ${get_tongsoluong_dh}    ${get_soluong}
    Should Be Equal As Numbers    ${get_tongcong_dh}    ${get_cantrancc}
    Should Be Equal As Numbers    ${get_giamgia_pn_dh}    ${get_giamgia_vnd}
    Should Be Equal As Strings    ${get_trangthai_dh}    Hoàn thành
    Log    validate in tab lich su dat hang nhap
    ${get_status}    ${get_total}    Get sumary in tab Lich su dat hang nhap    ${ma_ncc}    ${ma_phieu_dat}
    Should Be Equal As Numbers    ${get_status}    3
    Should Be Equal As Numbers    ${get_total}    ${get_cantrancc}
    Log    validate so lượng đã nhập
    ${get_list_order_qty}    Get list order quality in purchase order frm API    ${ma_phieu_dat}    ${get_list_prs}
    : FOR    ${item_num}    ${item_order_qty}    IN ZIP    ${list_num}    ${get_list_order_qty}
    \    Should Be Equal As Numbers    ${item_num}    ${item_order_qty}
    Log    validate the kho, so quy
    : FOR    ${item_product}    ${item_onhand_af_ex}    ${item_num}    IN ZIP    ${list_prs_cb}    ${list_onhand_af}
    ...    ${list_num_cb}
    \    Wait Until Keyword Succeeds    3 times    30s    Assert values in Stock Card    ${ma_phieu_nhap}    ${item_product}
    \    ...    ${item_onhand_af_ex}    ${item_num}
    #the kho imei
    : FOR    ${item_product}    ${item_num}    ${item_imei}    ${item_status}    IN ZIP    ${get_list_prs}
    ...    ${list_num}    ${list_imei_all}    ${get_list_imei_status}
    \    Run Keyword If    '${item_status}'=='[True]'    Assert imei avaiable in SerialImei tab    ${item_product}    ${item_imei}
    \    ...    ELSE    Log    Ignore validate imei
    #
    Log    validate so quy
    ${nav_tientra_ncc}=    Catenate    -    ${actual_tientrancc}
    ${get_ma_pn_soquy}    Get Ma Phieu Thu in So quy       ${ma_phieu_nhap}
    Run Keyword If    '${actual_tientrancc}' == '0'    Validate So quy info from Rest API if Invoice is not paid    ${ma_phieu_nhap}
    ...    ELSE    Validate So quy info from Rest API if Invoice is paid    ${get_ma_pn_soquy}    ${nav_tientra_ncc}
    #
    Log    validate in tab no can tra ncc
    Run Keyword If    '${actual_tientrancc}'=='0'    Validate status in Tab No can tra NCC if purchase order is not paid until success    ${ma_ncc}    ${ma_phieu_nhap}
    ...    ELSE    Validate status in Tab No can tra NCC if purchase order is paid until success    ${ma_ncc}    ${get_ma_pn_soquy}    ${ma_phieu_nhap}
    Assert ma phieu nhap is avaliable in Tab No can tra NCC and Lich su nhap/tra hang    ${ma_ncc}    ${ma_phieu_nhap}
    #
    Log    validate tổng nợ, tổng mua
    ${get_no_af_purchase}    ${get_tongmua_af_purchase}    ${get_tongmua_tru_trahang_af_purchase}    Get Supplier Debt from API    ${ma_ncc}
    Should Be Equal As Numbers    ${get_no_af_purchase}    ${result_no_ncc}
    Should Be Equal As Numbers    ${get_tongmua_af_purchase}    ${result_tongmua}
    Should Be Equal As Numbers    ${get_tongmua_tru_trahang_af_purchase}    ${result_tongmua_tru_trahang}
    #
    Log    validate gia von
    ${list_result_cost_af_ex}    ${list_result_onhand_af_ex}    Get list cost - onhand frm API    ${list_prs_cb}
    : FOR    ${item_pr}    ${item_cost}    ${item_result_cost}    IN ZIP    ${list_prs_cb}    ${list_cost_af}
    ...    ${list_result_cost_af_ex}
    \    ${item_cost_rd}    Evaluate    round(${item_cost},0)
    \    ${item_result_cost_rd}    Evaluate    round(${item_result_cost},0)
    \    Should Be Equal As Numbers    ${item_cost_rd}    ${item_result_cost_rd}
    #
    Log    validate sl dat ncc
    ${get_list_on_order_actual_af}    Get list on order frm API    ${get_list_prs}
    : FOR    ${item_on_order}    ${item_on_order_actual}    IN ZIP    ${get_list_on_order_af}    ${get_list_on_order_actual_af}
    \    Should Be Equal As Numbers    ${item_on_order}    ${item_on_order_actual}
    #
    Validate purchase receipt history frm purchase order    ${ma_phieu_dat}    ${ma_phieu_nhap}
    Log    validate thong tin tren phieu nhap
    ${get_supplier_code_nh}    ${get_tongtienhang_nh}    ${get_tiendatra_ncc_nh}    ${get_giamgia_pn_nh}    ${get_tongcong_nh}    ${get_tongsoluong_nh}    ${get_trangthai_mh}
    ...    Get purchase receipt info incase discount by purchase receipt code    ${ma_phieu_nhap}
    Should Be Equal As Strings    ${get_supplier_code_nh}    ${ma_ncc}
    Should Be Equal As Numbers    ${get_tongtienhang_nh}    ${get_tongtienhang}
    Should Be Equal As Numbers    ${get_tiendatra_ncc_nh}    ${sum_tientrancc}
    Should Be Equal As Numbers    ${get_tongsoluong_nh}    ${get_soluong}
    Should Be Equal As Numbers    ${get_tongcong_nh}    ${result_tongtienhang_gg_cpnh}
    Should Be Equal As Numbers    ${get_giamgia_pn_nh}    ${get_giamgia_vnd}
    Should Be Equal As Strings    ${get_trangthai_mh}    Đã nhập hàng
