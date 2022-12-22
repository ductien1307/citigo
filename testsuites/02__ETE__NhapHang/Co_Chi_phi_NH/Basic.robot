*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}      ${headless_browser}
Test Setup        Before Test Import Product
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
Resource          ../../../core/API/api_thietlap.robot
Resource          ../../../core/Giao_dich/nhaphang_getandcompute.robot

*** Variables ***
&{CPNH1}           CPNH4=none    CPNH5=none
&{CPNHK1}          CPNH10=none    CPNH16=none
&{CPNH2}          CPNH3=25    CPNH8=35000
&{CPNHK2}         CPNH11=30000    CPNH16=35
&{dict_imp}       NHP013=8.4    NHP014=9
&{dict_giamoi}    NHP013=none    NHP014=75000
&{dict_gg}        NHP013=25    NHP014=20000.66
&{dict_imp1}      NHP015=6    NHP016=5
&{dict_giamoi1}    NHP015=89000.8    NHP016=none
&{dict_gg1}       NHP015=30    NHP016=3000.6

*** Test Cases ***    Mã ncc        SP - SL         Giá mới            Giảm giá       Giảm giá pn    CPNH        CPNHK            Tiền trả ncc
CPNH_CPNHK
                      [Tags]        ENC
                      [Template]    etncp1
                      [Documentation]   Tạo phiếu nhập hàng có CPNH và CPNHK (tự động và ko tự động add vào phiếu) > check tồn kho, giá vốn, công nợ NCC, sổ quỹ
                      NCC0004       ${dict_imp}     ${dict_giamoi}     ${dict_gg}       25500          ${CPNH1}     ${CPNHK1}      50000

Thaydoi_CPNH_CPNHK    [Tags]        ENC     GOLIVE2
                      [Template]    etncp1
                      [Documentation]   Tạo phiếu nhập hàng có CPNH và CPNHK (thay đổi giá trị CPNH và CPNHK) > check tồn kho, giá vốn, công nợ NCC, sổ quỹ
                      NCC0010       ${dict_imp1}     ${dict_giamoi1}     ${dict_gg1}     25500          ${CPNH2}    ${CPNHK2}      50000

*** Keywords ***
etncp1
    [Arguments]    ${input_supplier_code}    ${dict_im}    ${dict_newprice}    ${dict_discount_prd}    ${input_nh_discount}    ${dict_cpnh}
    ...    ${dict_cpnhk}     ${input_tientrancc}
    #
    ${list_nums}    Get Dictionary Values    ${dict_im}
    ${list_prs}    Get Dictionary Keys    ${dict_im}
    ${list_newprice}    Get Dictionary Values    ${dict_newprice}
    ${list_discount_prd}    Get Dictionary Values    ${dict_discount_prd}
    ${list_cpnh}    Get Dictionary Keys    ${dict_cpnh}
    ${list_value_cpnh}    Get Dictionary Values    ${dict_cpnh}
    ${list_cpnhk}    Get Dictionary Keys    ${dict_cpnhk}
    ${list_value_cpnhk}    Get Dictionary Values    ${dict_cpnhk}
    ${import_code}    Generate code automatically    PNH
    #
    ${list_supplier_charge_defaul}      ${list_supplier_charge_auto}      ${list_other_charge_defaul}       ${list_other_charge_auto}      Get list supplier charge and other charge values thr API    ${list_cpnh}      ${list_cpnhk}
    #
    Log    tính toán tổng tiền, tồn kho, giá vốn... af ex
    ${list_result_thanhtien}    ${list_result_newprice}    ${list_result_ton_af_ex}    ${list_dongia}    Get list of total purchase receipt - result onhand in case of price change and have discount    ${list_prs}    ${list_nums}
    ...    ${list_newprice}    ${list_discount_prd}
    ${result_tongtienhang}      ${result_discount_nh}   ${result_tongtien_tru_gg}     ${result_cantrancc}     ${actual_tientrancc}     ${total_expense_value}   ${total_supplier_charge}    ${total_other_charge}     Conputation total, discount and pay for supplier in case have expense value    ${list_result_thanhtien}     ${input_nh_discount}     ${input_tientrancc}   ${list_supplier_charge_defaul}    ${list_other_charge_defaul}       ${list_value_cpnh}      ${list_value_cpnhk}
    ${list_cost_af_ex}    Computation list of cost incase purchase order have discount, price change and have expense    ${list_prs}    ${list_result_newprice}    ${list_nums}    ${result_discount_nh}    ${result_tongtienhang}
    ...    ${total_expense_value}
    #
    Log    tính tổng nợ, tổng mua của nhà cung cấp af ex
    ${result_no_ncc}     ${result_tongmua}     ${result_tongmua_tru_trahang}      Supplier debt calculation af reciept    ${input_supplier_code}    ${result_cantrancc}      ${actual_tientrancc}     Đã nhập hàng
    # lap phieu
    Log    Lập phiếu
    Set Selenium Speed    0.1
    Go To nhap Hang
    Reload Page
    Go to PNH
    Wait Until Keyword Succeeds    3x    2s    Input Text    ${textbox_nh_ma_phieunhap}    ${import_code}
    ${lastest_num}    ${list_imei_all}    Input products and fill values in NH form    ${list_prs}    ${list_nums}     ${list_newprice}    ${list_discount_prd}    ${list_dongia}
    Input discount PNH Invoice    ${input_nh_discount}    ${result_discount_nh}
    Select list supplier's charge and input value    ${list_cpnh}      ${list_supplier_charge_auto}     ${list_value_cpnh}   ${result_tongtien_tru_gg}
    Select list other charge and input value      ${list_cpnhk}       ${list_other_charge_auto}      ${list_value_cpnhk}      ${result_tongtien_tru_gg}
    Input purchase infor    ${input_supplier_code}    ${result_cantrancc}    ${actual_tientrancc}
    #Click Element    ${button_nh_hoanthanh}
    Press Key      //body     ${F9_KEY}
    Purchase receipt message success validation    ${import_code}
    #
    Log    tắt CPNH
    Toggle list supplier's charge    ${list_cpnh}    ${list_supplier_charge_defaul}
    Toggle list other charge    ${list_cpnhk}    ${list_other_charge_defaul}
    #
    Log    validate af ex
    Assert values by purchase code until succeed    ${import_code}    ${input_supplier_code}    ${result_tongtienhang}    ${actual_tientrancc}    ${lastest_num}    ${result_cantrancc}    ${result_discount_nh}    Đã nhập hàng
    Validate So quy info from API    ${import_code}    ${actual_tientrancc}    -${actual_tientrancc}      Phiếu chi
    Validate status in Tab No can tra NCC incase purchase order    ${input_supplier_code}    ${import_code}    ${actual_tientrancc}
    Assert ma phieu nhap is avaliable in Tab No can tra NCC and Lich su nhap/tra hang    ${input_supplier_code}    ${import_code}
    Assert Cong no Nha cung cap    ${input_supplier_code}    ${result_no_ncc}    ${result_tongmua}
    Wait Until Keyword Succeeds    3 times    3s    Assert list of onhand, cost, latestpurchaseprice af execute    ${list_prs}    ${list_result_ton_af_ex}    ${list_cost_af_ex}
    ...    ${list_dongia}
    #
    Delete purchase receipt code    ${import_code}
