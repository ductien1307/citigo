*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}      ${headless_browser}
Test Setup        Before Test Import Product
Test Teardown     After Test
Library           Collections
Resource          ../../../../core/hang_hoa/hang_hoa_navigation.robot
Resource          ../../../../core/share/computation.robot
Resource          ../../../../core/Giao_dich/nhap_hang_add_action.robot
Resource          ../../../../core/Giao_dich/nhap_hang_add_page.robot
Resource          ../../../../core/API/api_phieu_nhap_hang.robot
Resource          ../../../../core/Giao_dich/giaodich_nav.robot
Resource          ../../../../core/API/api_danhmuc_hanghoa.robot
Resource          ../../../../core/Doi_Tac/doitac_navigation.robot
Resource          ../../../../core/Doi_Tac/ncc_list_action.robot
Resource          ../../../../core/So_Quy/so_quy_list_action.robot
Resource          ../../../../core/share/toast_message.robot
Resource          ../../../../core/API/api_nha_cung_cap.robot
Resource          ../../../../core/API/api_soquy.robot
Resource          ../../../../core/Giao_dich/nhaphang_getandcompute.robot
Resource          ../../../../core/Giao_dich/nhap_hang_list_action.robot
Resource          ../../../../core/share/lodate.robot

*** Variables ***
&{dict_imp1}      LD13=5.2    LD14=8    QD22=5
&{dict_giamoi1}    LD13=none    LD14=98000.6    QD22=none
&{dict_gg1}       LD13=5000.2    LD14=30    QD22=10

*** Test Cases ***    Mã NCC        Mã SP - SL              Giá mới            GGSP           GGPN     Tiền trả NCC
Tao moi - finished
                      [Tags]        ENL
                      [Template]    etnl_taomoi_finished
                      NCC0012       ${dict_imp1}            ${dict_giamoi1}    ${dict_gg1}    20        all

*** Keywords ***
etnl_taomoi_finished
    [Arguments]    ${input_supplier_code}    ${dict_im}    ${dict_newprice}    ${dict_discount_prd}    ${input_nh_discount}    ${input_tientrancc}
    ${list_nums}    Get Dictionary Values    ${dict_im}
    ${list_prs}    Get Dictionary Keys    ${dict_im}
    ${list_newprice}    Get Dictionary Values    ${dict_newprice}
    ${list_discount_prd}    Get Dictionary Values    ${dict_discount_prd}
    ${import_code}    Generate code automatically    PNH
    # get dvcb cua sp
    ${list_pr_cb}    Get list code basic of product unit    ${list_prs}
    #get tong no, tong mua cua nha cung cap truoc khi nhap hang
    ${get_no_ncc_hientai}    ${get_tong_mua}    ${get_tong_mua_tru_tra_hang}    Get Supplier Debt from API    ${input_supplier_code}
    #
    ${list_result_thanhtien_af}    ${list_result_newprice_af}    ${list_result_onhand_cb_af}    ${list_dongia}    ${list_result_onhand_actual_af}    ${list_actual_num_cb}    ${list_result_newprice_cb_af}
    ...    ${list_result_newprice_bf}    ${list_result_discount_vnd}    Get list of total purchase receipt - result onhand actual product in case of price change and have discount    ${list_pr_cb}    ${list_prs}    ${list_nums}
    ...    ${list_newprice}    ${list_discount_prd}
    ${result_tongtienhang}    Sum values in list    ${list_result_thanhtien_af}
    # lap phieu
    Set Selenium Speed    0.5
    Go to PNH
    Sleep    5s
    Input Text    ${textbox_nh_ma_phieunhap}    ${import_code}
    ${list_tenlo}    Create List
    : FOR    ${item_product}    ${item_num}    ${item_newprice}    ${item_discount_prd}    ${item_lastestprice}    IN ZIP
    ...    ${list_prs}    ${list_nums}    ${list_newprice}    ${list_discount_prd}    ${list_dongia}
    \    ${tenlo}    Generate code automatically    LO
    \    Input product - num and create Lot, expiry date by generating randomly      ${item_product}    ${item_num}      ${tenlo}
    \    Run Keyword If    0<=${item_discount_prd}<=100    Input new price and % discount for product in NH form    ${item_newprice}    ${item_lastestprice}    ${item_discount_prd}
    \    ...    ELSE    Input new price and vnd discount for product in NH form    ${item_newprice}    ${item_discount_prd}
    \    Append To List    ${list_tenlo}    ${tenlo}
    Log Many    ${list_tenlo}
    ${result_cantrancc}=    Run Keyword If    0 < ${input_nh_discount} < 100    Price after % discount invoice    ${result_tongtienhang}    ${input_nh_discount}
    ...    ELSE IF    ${input_nh_discount} > 100    Minus    ${result_tongtienhang}    ${input_nh_discount}
    ...    ELSE    Set Variable    ${result_tongtienhang}
    ${result_discount_nh}    Run Keyword If    0 < ${input_nh_discount} < 100    Convert % discount to VND and round    ${result_tongtienhang}    ${input_nh_discount}
    ...    ELSE    Set Variable    ${input_nh_discount}
    # tinh toan gia von sau khi nhap hang
    ${list_cost_af_ex}    Computation list of cost incase purchase order have discount and price change    ${list_pr_cb}    ${list_result_newprice_cb_af}    ${list_actual_num_cb}    ${result_discount_nh}    ${result_tongtienhang}
    #
    ${actual_tientrancc}    Set Variable If    '${input_tientrancc}'=='all'    ${result_cantrancc}    ${input_tientrancc}
    ${actual_tientrancc}    Run Keyword If    '${input_tientrancc}'=='all'    Replace floating point    ${actual_tientrancc}
    ...    ELSE    Set Variable    ${input_tientrancc}
    ${result_no_phieunhap}    Minus    ${result_cantrancc}    ${actual_tientrancc}
    ${result_no_ncc}    sum    ${get_no_ncc_hientai}    ${result_no_phieunhap}
    ${result_no_ncc}    Minus    0    ${result_no_ncc}
    ${result_tongmua}    sum    ${result_cantrancc}    ${get_tong_mua}
    ${result_tongmua_tru_tranghag}    sum    ${result_cantrancc}    ${get_tong_mua_tru_tra_hang}
    Run Keyword If    0 < ${input_nh_discount} < 100    Wait Until Keyword Succeeds    3 times    3s    Input discount PNH Invoice %    ${input_nh_discount}
    ...    ${result_discount_nh}
    ...    ELSE IF    ${input_nh_discount} > 100    Input discount PNH Invoice VND    ${input_nh_discount}
    ...    ELSE    Log    Ignore discount
    Run Keyword If    '${input_tientrancc}'=='0'    Input supplier    ${input_supplier_code}
    ...    ELSE    Input purchase infor    ${input_supplier_code}    ${result_cantrancc}    ${actual_tientrancc}
    Click Element     ${button_nh_hoanthanh}
    Wait Until Keyword Succeeds    3 times    3 s    Purchase receipt message success validation    ${import_code}
    Sleep    30s    #wait for response to API
    #validate thong tin tren phieu nhap
    ${result_tongsoluong}    Sum values in list    ${list_nums}
    ${get_supplier_code}    ${get_tongtienhang}    ${get_tiendatra_ncc}    ${get_giamgia_pn}    ${get_tongcong}    ${get_tongsoluong}    ${get_trangthai}
    ...    Get purchase receipt info incase discount by purchase receipt code    ${import_code}
    Should Be Equal As Strings    ${get_supplier_code}    ${input_supplier_code}
    Should Be Equal As Numbers    ${get_tongtienhang}    ${result_tongtienhang}
    Should Be Equal As Numbers    ${get_tiendatra_ncc}    ${actual_tientrancc}
    Should Be Equal As Numbers    ${get_tongsoluong}    ${result_tongsoluong}
    Should Be Equal As Numbers    ${get_tongcong}    ${result_cantrancc}
    Should Be Equal As Numbers    ${get_giamgia_pn}    ${result_discount_nh}
    Should Be Equal As Strings    ${get_trangthai}    Đã nhập hàng
    #validate the kho, so quy
    : FOR    ${item_product}    ${item_onhand_af_ex}    ${item_num_cb}    IN ZIP    ${list_pr_cb}    ${list_result_onhand_cb_af}
    ...    ${list_actual_num_cb}
    \    Wait Until Keyword Succeeds    3 times    30s    Assert values in Stock Card    ${import_code}    ${item_product}
    \    ...    ${item_onhand_af_ex}    ${item_num_cb}
    : FOR    ${item_pr_cb}    ${item_num}    ${item_list_lo}    ${item_pr}    IN ZIP    ${list_pr_cb}    ${list_nums}    ${list_tenlo}    ${list_prs}
    \    Wait Until Keyword Succeeds    3 times    30s    Assert values in Stock Card in tab Lo - HSD    ${import_code}    ${item_pr}
    \    ...    ${item_pr_cb}    ${item_num}    ${item_num}    ${item_list_lo}
    ${nav_tientra_ncc}=    Catenate    -    ${actual_tientrancc}
    ${get_ma_pn_soquy}    Get Ma Phieu Chi in So quy    ${import_code}
    Run Keyword If    '${actual_tientrancc}' == '0'    Validate So quy info from Rest API if Invoice is not paid    ${import_code}
    ...    ELSE    Validate So quy info from Rest API if Invoice is paid    ${get_ma_pn_soquy}    ${nav_tientra_ncc}
    #validate in tab no can tra ncc
    Run Keyword If    '${actual_tientrancc}'=='0'    Validate status in Tab No can tra NCC if purchase order is not paid until success    ${input_supplier_code}    ${import_code}
    ...    ELSE    Validate status in Tab No can tra NCC if purchase order is paid until success    ${input_supplier_code}    ${get_ma_pn_soquy}    ${import_code}
    #validate tổng nợ, tổng mua
    ${get_no_af_purchase}    ${get_tongmua_af_purchase}    ${get_tongmua_tru_trahang_af_purchase}    Get Supplier Debt from API after purchase    ${input_supplier_code}    ${import_code}    ${actual_tientrancc}
    Should Be Equal As Numbers    ${get_no_af_purchase}    ${result_no_ncc}
    Should Be Equal As Numbers    ${get_tongmua_af_purchase}    ${result_tongmua}
    Should Be Equal As Numbers    ${get_tongmua_tru_trahang_af_purchase}    ${result_tongmua_tru_tranghag}
    #validate gia von
    ${list_result_cost_af_ex}    ${list_result_onhand_af_ex}    Get list cost - onhand frm API    ${list_pr_cb}
    : FOR    ${item_pr}    ${item_cost}    ${item_result_cost}    IN ZIP    ${list_pr_cb}    ${list_cost_af_ex}
    ...    ${list_result_cost_af_ex}
    \    ${item_cost_rd}    Evaluate    round(${item_cost}, 0)
    \    ${item_result_cost_rd}    Evaluate    round(${item_result_cost}, 0)
    \    Should Be Equal As Numbers    ${item_cost_rd}    ${item_result_cost_rd}
