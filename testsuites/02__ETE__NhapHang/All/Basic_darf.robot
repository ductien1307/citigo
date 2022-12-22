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
&{dict_pr1}       NDVT06=10    NHP002=9.6    NQD01=5    NS02=4
@{list_giamoi1}    none    54000.62    60000    120000.7
@{list_gg1}       15    15000.02    7000    12

*** Test Cases ***
Luu tam
    [Tags]    EN
    [Template]    en_draft
    [Documentation]   Tạo phiếu tạm nhập hàng có: nhà cung cấp, 3 loại sp (hàng thường, imei, đơn vị tính), giảm giá PN, tiền trả NCC > check tồn kho, giá vốn, công nợ NCC, sổ quỹ
    NCC0003    ${dict_pr1}    ${list_giamoi1}    ${list_gg1}    45    50000

*** Keywords ***
en_draft
    [Arguments]    ${input_supplier_code}    ${dict_pr_num}    ${list_newprice}    ${list_discount}    ${input_nh_discount}    ${input_tientrancc}
    ${list_pr}    Get Dictionary Keys    ${dict_pr_num}
    ${list_num}    Get Dictionary Values    ${dict_pr_num}
    ${import_code}    Generate code automatically    PNH
    # get dvcb cua sp
    ${list_pr_cb}    Get list code basic of product unit    ${list_pr}
    #
    ${list_result_thanhtien_af}    ${list_onhand}    ${list_cost}      ${list_dongia}   Get list of total - onhand - cost -lastest price incase receipt draft     ${list_pr_cb}    ${list_pr}    ${list_num}    ${list_newprice}    ${list_discount}
    ${result_tongtienhang}      ${result_discount_nh}      ${result_cantrancc}      ${actual_tientrancc}     Conputation total, discount and pay for supplier    ${list_result_thanhtien_af}     ${input_nh_discount}     ${input_tientrancc}
    ${result_no_ncc}     ${result_tongmua}     ${result_tongmua_tru_trahang}      Supplier debt calculation af reciept    ${input_supplier_code}    ${result_cantrancc}      ${actual_tientrancc}     Phiếu tạm
    #
    Log    Lập phiếu
    Set Selenium Speed    0.1
    Go to PNH
    Wait Until Keyword Succeeds    3x    2s    Input Text    ${textbox_nh_ma_phieunhap}    ${import_code}
    ${lastest_num}    ${list_imei_all}    Input products and fill values in NH form    ${list_pr}    ${list_num}    ${list_newprice}    ${list_discount}    ${list_dongia}
    Input discount PNH Invoice    ${input_nh_discount}    ${result_discount_nh}
    Input purchase infor    ${input_supplier_code}    ${result_cantrancc}    ${actual_tientrancc}
    Click Element    ${button_nh_luutam}
    Purchase receipt message success validation    ${import_code}
    #
    Log    validate af ex
    Assert values by purchase code until succeed    ${import_code}    ${input_supplier_code}    ${result_tongtienhang}    ${actual_tientrancc}    ${lastest_num}    ${result_cantrancc}    ${result_discount_nh}    Phiếu tạm
    Validate So quy info from API    ${import_code}    ${actual_tientrancc}    -${actual_tientrancc}      Phiếu chi
    Validate status in Tab No can tra NCC incase purchase order draft     ${import_code}    ${input_supplier_code}   ${actual_tientrancc}
    Assert ma phieu nhap is not avaliable in Tab No can tra NCC and Lich su nhap/tra hang    ${input_supplier_code}    ${import_code}
    Assert Cong no Nha cung cap    ${input_supplier_code}    ${result_no_ncc}    ${result_tongmua}
    Wait Until Keyword Succeeds    3 times    3s    Assert list of onhand, cost af receipt    ${list_pr_cb}    ${list_onhand}    ${list_cost}
    Delete purchase receipt code    ${import_code}
