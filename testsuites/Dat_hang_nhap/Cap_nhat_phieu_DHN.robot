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
&{dict_pr_thuong}    DNT004=11    DNS002=7.6    DNQD005=9
&{dict_giamoi_thuong}    DNT004=85000.84    DNS002=89000    DNQD005=70000
&{dict_gg_thuong}    DNT004=15    DNS002=0    DNQD005=10000
&{dict_type}      DNT004=15    DNS002=0    DNQD005=null
&{dict_pr_edit1}         DNQD005=9.6    DNS002=0    DNT004=15    DNT005=9
&{dict_giamoi_edit1}     DNQD005=65000     DNS002=0    DNT004=115000.96    DNT005=95000.63
&{dict_gg_edit1}      DNQD005=10    DNS002=0     DNT004=20000    DNT005=10000.7

*** Test Cases ***
Cap nhat - co tt
    [Tags]    EDN3    
    [Template]    dhn_edit_tt
    [Documentation]   Cập nhật phiếu ĐHN từ phiếu ĐHN có thanh toán - có NCC > check tồn kho, giá vốn, công nợ NCC, sổ quỹ
    NCC0024    ${dict_pr_thuong}    ${dict_giamoi_thuong}    ${dict_gg_thuong}    ${dict_type}    30    20000
    ...    Phiếu tạm   ${dict_pr_edit1}    ${dict_giamoi_edit1}    ${dict_gg_edit1}       200000    70000

Cap nhat - ko tt
    [Tags]    EDN3
    [Template]    dhn_edit_ko_tt
    [Documentation]   Cập nhật phiếu ĐHN từ phiếu ĐHN không thanh toán - có NCC > check tồn kho, giá vốn, công nợ NCC, sổ quỹ
    NCC0023    ${dict_pr_thuong}    ${dict_giamoi_thuong}    ${dict_gg_thuong}    ${dict_type}    50000
    ...   Phiếu tạm   ${dict_pr_edit1}    ${dict_giamoi_edit1}    ${dict_gg_edit1}   30    500000

*** Keywords ***
dhn_edit_tt
    [Arguments]    ${input_supplier_code}    ${dict_prs_num}    ${dict_newprice}    ${dict_discount}    ${dict_discount_type}    ${input_discount}
    ...    ${input_tientrancc}     ${input_trangthai}     ${dict_prs_edit}    ${dict_newprice_edit}    ${dict_discount_edit}    ${input_discount_af}    ${input_tientrancc_af}
    ${list_prs}   Get Dictionary Keys    ${dict_prs_num}
    ${list_prs_edit}    Get Dictionary Keys    ${dict_prs_edit}
    ${list_nums_edit}    Get Dictionary Values    ${dict_prs_edit}
    ${list_newprice_edit}    Get Dictionary Values    ${dict_newprice_edit}
    ${list_discount_edit}    Get Dictionary Values    ${dict_discount_edit}
    #
    ${list_prs_cb_edit}    Get list code basic of product unit    ${list_prs_edit}
    Log    Tính tổng tièn hàng, nợ cần trả sau khi ĐHN
    ${list_result_thanhtien_af}    ${list_result_newprice_af}    ${list_result_onhand_cb_af}    ${list_dongia}    ${list_result_onhand_actual_af}    ${list_actual_num_cb}    ${list_result_newprice_cb_af}     ${list_result_newprice_bf}    ${list_result_discount_vnd}
    ...    Get list of total purchase receipt - result onhand actual product in case of price change and have discount     ${list_prs_cb_edit}     ${list_prs_edit}    ${list_nums_edit}    ${list_newprice_edit}    ${list_discount_edit}
    ${result_tongtienhang}      ${result_discount_nh}      ${result_cantrancc}      ${actual_tientrancc}     Conputation total, discount and pay for supplier    ${list_result_thanhtien_af}     ${input_discount_af}     ${input_tientrancc_af}
    ${result_cantrancc_in_form}    Minus    ${result_cantrancc}    ${input_tientrancc}
    ${total_tongtientra_ncc}    Sum    ${input_tientrancc}    ${input_tientrancc_af}
    Log    Tính toán giá vốn, tồn kho sau khi ĐHN
    ${list_cost_bf_ex}    ${list_onhand_bf_ex}    Get list cost - onhand frm API    ${list_prs_cb_edit}
    ${get_list_on_order_af}     Computation list on order after purchase order    ${list_prs_edit}    ${list_nums_edit}     ${input_trangthai}
    ${lastest_num}   Sum values in list    ${list_nums_edit}
    Log    Get tổng nợ, tổng mua sau khi DHN
    ${result_no_ncc}     ${result_tongmua}     ${result_tongmua_tru_trahang}      Supplier debt calculation af reciept order    ${input_supplier_code}    ${result_cantrancc}      ${total_tongtientra_ncc}
    #
    Log    tạo phiếu DNH
    ${ma_phieu_dhn}   Run Keyword If    '${input_trangthai}'=='Phiếu tạm'       Add new purchase order have payment thr API    ${input_supplier_code}    ${dict_prs_num}    ${dict_newprice}    ${dict_discount}    ${dict_discount_type}    ${input_discount}     ${input_tientrancc}
    ...   ELSE    Add new purchase order Da xac nhan NCC have payment thr API    ${input_supplier_code}    ${dict_prs_num}    ${dict_newprice}    ${dict_discount}    ${dict_discount_type}    ${input_discount}    ${input_tientrancc}
    #
    Log    Cập nhập phiếu DHN
    Wait Until Keyword Succeeds    3 times    0 s    Go to Dat Hang Nhap
    Search purchase order code and click open    ${ma_phieu_dhn}
    Edit product details in DNH form        ${list_prs_edit}    ${list_nums_edit}    ${list_newprice_edit}    ${list_discount_edit}    ${list_dongia}     ${list_result_discount_vnd}   ${list_prs}
    Input discount PNH Invoice    ${input_discount_af}    ${result_discount_nh}
    Wait Until Keyword Succeeds    3 times    0 s   Input pay for supplier and validate in DHN form   ${input_tientrancc_af}   ${result_cantrancc_in_form}
    Press Key      //body     ${F9_KEY}
    Purchase order message success validation    ${ma_phieu_dhn}
    #
    Log    validate thong tin tren phieu nhap

    Assert values in purchase order code until succeed    ${ma_phieu_dhn}    ${input_supplier_code}    ${result_tongtienhang}    ${total_tongtientra_ncc}     ${lastest_num}    ${result_cantrancc}    ${result_discount_nh}     ${input_trangthai}
    Validate So quy info from API    ${ma_phieu_dhn}    ${input_tientrancc}    -${input_tientrancc}      Phiếu thu
    Assert sumary in tab Lich su dat hang nhap     ${input_supplier_code}    ${ma_phieu_dhn}     ${result_cantrancc}    ${input_trangthai}
    Assert Cong no Nha cung cap    ${input_supplier_code}    ${result_no_ncc}    ${result_tongmua}
    Assert list of onhand, cost af execute   ${list_prs_cb_edit}    ${list_onhand_bf_ex}    ${list_cost_bf_ex}
    Assert list on order af execute    ${list_prs_edit}    ${get_list_on_order_af}
    Delete purchase order code    ${ma_phieu_dhn}


dhn_edit_ko_tt
    [Arguments]    ${input_supplier_code}    ${dict_prs_num}    ${dict_newprice}    ${dict_discount}    ${dict_discount_type}    ${input_discount}
    ...       ${input_trangthai}     ${dict_prs_edit}    ${dict_newprice_edit}    ${dict_discount_edit}    ${input_discount_af}    ${input_tientrancc_af}
    ${list_prs}   Get Dictionary Keys    ${dict_prs_num}
    ${list_prs_edit}    Get Dictionary Keys    ${dict_prs_edit}
    ${list_nums_edit}    Get Dictionary Values    ${dict_prs_edit}
    ${list_newprice_edit}    Get Dictionary Values    ${dict_newprice_edit}
    ${list_discount_edit}    Get Dictionary Values    ${dict_discount_edit}
    #
    ${list_prs_cb_edit}    Get list code basic of product unit    ${list_prs_edit}
    Log    Tính tổng tièn hàng, nợ cần trả sau khi ĐHN
    ${list_result_thanhtien_af}    ${list_result_newprice_af}    ${list_result_onhand_cb_af}    ${list_dongia}    ${list_result_onhand_actual_af}    ${list_actual_num_cb}    ${list_result_newprice_cb_af}     ${list_result_newprice_bf}    ${list_result_discount_vnd}
    ...    Get list of total purchase receipt - result onhand actual product in case of price change and have discount     ${list_prs_cb_edit}     ${list_prs_edit}    ${list_nums_edit}    ${list_newprice_edit}    ${list_discount_edit}
    ${result_tongtienhang}      ${result_discount_nh}      ${result_cantrancc}      ${actual_tientrancc}     Conputation total, discount and pay for supplier    ${list_result_thanhtien_af}     ${input_discount_af}     ${input_tientrancc_af}
    Log    Tính toán giá vốn, tồn kho sau khi ĐHN
    ${list_cost_bf_ex}    ${list_onhand_bf_ex}    Get list cost - onhand frm API    ${list_prs_cb_edit}
    ${get_list_on_order_af}     Computation list on order after purchase order    ${list_prs_edit}    ${list_nums_edit}     ${input_trangthai}
    ${lastest_num}   Sum values in list    ${list_nums_edit}
    Log    Get tổng nợ, tổng mua sau khi DHN
    ${result_no_ncc}     ${result_tongmua}     ${result_tongmua_tru_trahang}      Supplier debt calculation af reciept order    ${input_supplier_code}    ${result_cantrancc}      ${actual_tientrancc}
    #
    Log    tạo phiếu DNH
    ${ma_phieu_dhn}   Run Keyword If    '${input_trangthai}'=='Phiếu tạm'       Add new purchase order no payment thr API    ${input_supplier_code}    ${dict_prs_num}    ${dict_newprice}    ${dict_discount}    ${dict_discount_type}    ${input_discount}
    ...   ELSE    Add new purchase order Da xac nhan NCC no payment thr API    ${input_supplier_code}    ${dict_prs_num}    ${dict_newprice}    ${dict_discount}    ${dict_discount_type}    ${input_discount}
    #
    Log    Cập nhập phiếu DHN
    Wait Until Keyword Succeeds    3 times    0 s    Go to Dat Hang Nhap
    Search purchase order code and click open    ${ma_phieu_dhn}
    Edit product details in DNH form        ${list_prs_edit}    ${list_nums_edit}    ${list_newprice_edit}    ${list_discount_edit}    ${list_dongia}     ${list_result_discount_vnd}   ${list_prs}
    Input discount PNH Invoice    ${input_discount_af}    ${result_discount_nh}
    Wait Until Keyword Succeeds    3 times    0 s   Input pay for supplier and validate in DHN form   ${input_tientrancc_af}   ${result_cantrancc}
    Press Key      //body     ${F9_KEY}
    Purchase order message success validation    ${ma_phieu_dhn}
    #
    Log    validate thong tin tren phieu nhap

    Assert values in purchase order code until succeed    ${ma_phieu_dhn}    ${input_supplier_code}    ${result_tongtienhang}    ${input_tientrancc_af}     ${lastest_num}    ${result_cantrancc}    ${result_discount_nh}     ${input_trangthai}
    Validate So quy info from API    ${ma_phieu_dhn}    ${input_tientrancc_af}    -${input_tientrancc_af}      Phiếu thu
    Assert sumary in tab Lich su dat hang nhap     ${input_supplier_code}    ${ma_phieu_dhn}     ${result_cantrancc}    ${input_trangthai}
    Assert Cong no Nha cung cap    ${input_supplier_code}    ${result_no_ncc}    ${result_tongmua}
    Assert list of onhand, cost af execute   ${list_prs_cb_edit}    ${list_onhand_bf_ex}    ${list_cost_bf_ex}
    Assert list on order af execute    ${list_prs_edit}    ${get_list_on_order_af}
    Delete purchase order code    ${ma_phieu_dhn}
