*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}      ${headless_browser}
Test Setup        Before Test Import Product
Test Teardown     After Test
Library           Collections
Resource          ../../../core/hang_hoa/hang_hoa_navigation.robot
Resource          ../../../core/share/computation.robot
Resource          ../../../core/Giao_dich/nhap_hang_add_action.robot
Resource          ../../../core/Giao_dich/nhap_hang_add_page.robot
Resource          ../../../core/Giao_dich/nhap_hang_list_action.robot
Resource          ../../../core/Giao_dich/giaodich_nav.robot
Resource          ../../../core/API/api_danhmuc_hanghoa.robot
Resource          ../../../core/Doi_Tac/doitac_navigation.robot
Resource          ../../../core/Doi_Tac/ncc_list_action.robot
Resource          ../../../core/So_Quy/so_quy_list_action.robot
Resource          ../../../core/share/toast_message.robot
Resource          ../../../core/API/api_nha_cung_cap.robot
Resource          ../../../core/API/api_phieu_nhap_hang.robot
Resource          ../../../core/API/api_soquy.robot
Resource          ../../../core/Giao_dich/nhaphang_getandcompute.robot

*** Variables ***
&{dict_pr}        NDVT05=7.6    NHP001=11    NQD02=9    NS01=3
@{list_giamoi}    85000.84    89000    none    60000
@{list_gg}        15    0    2500.4    10
@{list_giamoi1}    none    54000.62    60000    120000.7


*** Test Cases ***
Hoan thanh
    [Tags]    EN
    [Template]    en_finished
    [Documentation]   Tạo phiếu nhập hàng có: nhà cung cấp, 3 loại sp (hàng thường, imei, đơn vị tính), giảm giá PN, tiền trả NCC > check tồn kho, giá vốn, công nợ NCC, sổ quỹ
    NCC0001    ${dict_pr}    ${list_giamoi}    ${list_gg}    25500    0
    #NCC0009    ${dict_pr}    ${list_giamoi1}    ${list_gg}    0    all

*** Keywords ***
en_finished
    [Arguments]    ${input_supplier_code}    ${dict_pr_num}    ${list_newprice}    ${list_discount}    ${input_nh_discount}    ${input_tientrancc}
    ${list_pr}    Get Dictionary Keys    ${dict_pr_num}
    ${list_num}    Get Dictionary Values    ${dict_pr_num}
    ${import_code}    Generate code automatically    PNH
    #
    Log    get dvcb của list sp
    ${list_pr_cb}    Get list code basic of product unit    ${list_pr}
    #
    Log    tính toán tổng tiền, tồn kho, giá vốn... af ex
    ${list_result_thanhtien_af}    ${list_result_newprice_af}    ${list_result_onhand_cb_af}    ${list_dongia}    ${list_result_onhand_actual_af}    ${list_actual_num_cb}    ${list_result_newprice_cb_af}     ${list_result_newprice_bf}    ${list_result_discount_vnd}
    ...    Get list of total purchase receipt - result onhand actual product in case of price change and have discount    ${list_pr_cb}    ${list_pr}    ${list_num}    ${list_newprice}    ${list_discount}
    ${result_tongtienhang}      ${result_discount_nh}      ${result_cantrancc}      ${actual_tientrancc}     Conputation total, discount and pay for supplier    ${list_result_thanhtien_af}     ${input_nh_discount}     ${input_tientrancc}
    ${list_cost_cb_af_ex}    Computation list of cost incase purchase order have discount and price change    ${list_pr_cb}    ${list_result_newprice_cb_af}    ${list_actual_num_cb}    ${result_discount_nh}    ${result_tongtienhang}
    #
    Log    tính tổng nợ, tổng mua của nhà cung cấp af ex
    ${result_no_ncc}     ${result_tongmua}     ${result_tongmua_tru_trahang}      Supplier debt calculation af reciept    ${input_supplier_code}    ${result_cantrancc}      ${actual_tientrancc}     Đã nhập hàng
    #
    Log    Lập phiếu
    Set Selenium Speed    0.1
    Go to PNH
    Wait Until Keyword Succeeds    3x    2s    Input Text    ${textbox_nh_ma_phieunhap}    ${import_code}
    ${lastest_num}    ${list_imei_all}    Input products and fill values in NH form    ${list_pr}    ${list_num}    ${list_newprice}    ${list_discount}    ${list_dongia}
    Input discount PNH Invoice    ${input_nh_discount}    ${result_discount_nh}
    Input purchase infor    ${input_supplier_code}    ${result_cantrancc}    ${actual_tientrancc}
    #Click Element    ${button_nh_hoanthanh}
    Press Key      //body     ${F9_KEY}
    Purchase receipt message success validation    ${import_code}
    #
    Log    validate thong tin tren phieu nhap
    Assert values by purchase code until succeed    ${import_code}    ${input_supplier_code}    ${result_tongtienhang}    ${actual_tientrancc}    ${lastest_num}    ${result_cantrancc}    ${result_discount_nh}    Đã nhập hàng
    Validate So quy info from API    ${import_code}    ${actual_tientrancc}    -${actual_tientrancc}      Phiếu chi
    Validate status in Tab No can tra NCC incase purchase order    ${input_supplier_code}    ${import_code}    ${actual_tientrancc}
    Assert ma phieu nhap is avaliable in Tab No can tra NCC and Lich su nhap/tra hang    ${input_supplier_code}    ${import_code}
    Assert Cong no Nha cung cap    ${input_supplier_code}    ${result_no_ncc}    ${result_tongmua}
    Wait Until Keyword Succeeds    3 times    3s    Assert list of onhand, cost af receipt    ${list_pr_cb}    ${list_result_onhand_cb_af}    ${list_cost_cb_af_ex}
    Delete purchase receipt code    ${import_code}
