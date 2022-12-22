*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}      ${headless_browser}
Test Setup
Test Teardown     After Test
Library           Collections
Resource          ../../../../core/hang_hoa/hang_hoa_navigation.robot
Resource          ../../../../core/share/computation.robot
Resource          ../../../../core/Giao_dich/dat_hang_nhap_add_action.robot
Resource          ../../../../core/Giao_dich/dat_hang_nhap_list_action.robot
Resource          ../../../../core/Giao_dich/giaodich_nav.robot
Resource          ../../../../core/API/api_danhmuc_hanghoa.robot
Resource          ../../../../core/Doi_Tac/doitac_navigation.robot
Resource          ../../../../core/Doi_Tac/ncc_list_action.robot
Resource          ../../../../core/share/toast_message.robot
Resource          ../../../../core/API/api_nha_cung_cap.robot
Resource          ../../../../core/API/api_dathangnhap.robot
Resource          ../../../../core/Giao_dich/nhaphang_getandcompute.robot
Resource          ../../../../core/Giao_dich/nhap_hang_add_action.robot
Resource          ../../../../prepare/Hang_hoa/Sources/hanghoa.robot
Resource          ../../../../core/API/api_hanghoa.robot
Resource          ../../../../prepare/Hang_hoa/Sources/doitac.robot

*** Variables ***
&{dict_product_num}    TRLODA007=2.5      TRLDQD008=3.5      TRSI04=2.55     TRSX04=1.5
&{dict_dongia}         TRLODA007=45000    TRLDQD008=89000    TRSI04=85000    TRSX04=48000
&{dict_loaihh}         HTP07=pro     HTP08=pro    TRLODA007=lodate     TRLDQD008=lodate_unit    TRSI04=imei    TRSX04=hhsx
*** Test Cases ***
Tao DL mau
    [Tags]    TRNCC
    [Template]    Add du lieu
    pro           HTP07          Hàng thành phần 1    tracking2    70000    5000     50      none    none    none    none    none    none    none    none    none
    pro           HTP08          Hàng thành phần 2    tracking2    70000    5000     70      none    none    none    none    none    none    none    none    none
    imei          TRSI04         Điện thoại xiaomi    tracking2    70000    5000    15    none    none    none    none    none    none    none    none    none
    lodate        TRLODA007         DHC ADLAY EXTRA      tracking2    70000    5000    none    none    none    none    none    none    none    none    none    none
    lodate_unit    TRLODA008        Lip Balm Himalaya    tracking2    75000    5000    none    none    none    none    none    Cai     TRLDQD008    140000    Hop    2
    hhsx          TRSX04         Sữa vinamilk pha     tracking2    150000    5000    10    HTP07    1    HTP08    2    none    none    none    none    none

Phieu DXN hang hoa lodate
    [Tags]         TRNCC
    [Template]    dhn_hang_hoa_lodate
    ${dict_product_num}    tracking2    TRNCC003    ${dict_dongia}

Delete du lieu tracking
    [Tags]    TRNCC
    [Template]    Xoa DL 4
    ${dict_loaihh}

*** Keywords ***
Add du lieu
    [Documentation]    tao DL
    [Arguments]    ${loai_hh}    ${ma_hh}    ${ten_sp}    ${nhom_hang}    ${gia_ban}    ${gia_von}    ${ton}     ${sp_1}   ${sl_1}   ${sp_2}   ${sl_2}    ${dvcb}    ${ma_hh_qd}    ${giaban2}    ${dvqd}    ${giatriqd}
    ${get_cat_id}    Get category ID    ${nhom_hang}
    Run Keyword If    '${get_cat_id}'=='0'    Add categories thr API    ${nhom_hang}    ELSE    Log    ignore
    Wait Until Keyword Succeeds    3x    3s    Delete product if product is visible thr API    ${ma_hh}
    Wait Until Keyword Succeeds    3x    3s    Add product for tracking by product type thr API    ${loai_hh}    ${ma_hh}    ${ten_sp}    ${nhom_hang}    ${gia_ban}    ${gia_von}    ${ton}     ${sp_1}   ${sl_1}   ${sp_2}   ${sl_2}    ${dvcb}    ${ma_hh_qd}    ${giaban2}    ${dvqd}    ${giatriqd}

dhn_hang_hoa_lodate
    [Arguments]    ${dict_product_num}    ${tennhom}    ${input_supplier_code}    ${dict_dongia}
    [Documentation]    tạo phiếu đặt hàng nhập có hàng hóa lô date
    #tạo nhóm hàng
    ${cat_id}    Get category ID    ${tennhom}
    Run Keyword If    '${cat_id}'=='0'    Add categories thr API    ${tennhom}    ELSE    Log    ignore
    #tạo ncc
    ${supplier_id}    Get Supplier Id    ${input_supplier_code}
    Run Keyword If    '${supplier_id}'!='0'    Delete supplier    ${supplier_id}    ELSE    Log    ignore
    ${ten_ncc}    Generate code automatically    Nha cung cap
    ${mobile_number}    Generate Mobile number
    Add supplier    ${input_supplier_code}    ${ten_ncc}    ${mobile_number}
    #
    ${ma_phieu}    Generate code automatically    DHN
    #
    ${list_prs}    Get Dictionary Keys    ${dict_product_num}
    ${list_nums}    Get Dictionary Values    ${dict_product_num}
    ${list_dongia}    Get Dictionary Values    ${dict_dongia}
    ${get_list_on_order_bf}    Get list on order frm API    ${list_prs}
    Before Test Dat Hang Nhap
    Go to tao phieu DHN
    input text    ${textbox_dhn_ma_phieu}    ${ma_phieu}
    Input supplier    ${input_supplier_code}
    Select status Da xac nhan in DHN form
    ${lastest_num}    Set Variable    0
    : FOR    ${item_product}    ${item_num}    ${item_dongia}    IN ZIP    ${list_prs}    ${list_nums}    ${list_dongia}
    \    ${lastest_num}    Input product - nums in NH form    ${item_product}    ${item_num}    ${lastest_num}
    \    Input newprice product in DHN form    ${item_product}    ${item_dongia}
    Log    ${lastest_num}
    ####
    Click Element    ${button_dat_hang_nhap}
    Wait Until Keyword Succeeds    3 times    3 s    Purchase order message success validation    ${ma_phieu}
    #
    Sleep    3s
    Log    Validate số lượng đặt ncc, thẻ kho sau khi tạo phiếu DHN
    ${get_list_actual_on_order_af}    Get list on order frm API    ${list_prs}
    : FOR    ${item_on_order}    ${item_actual_on_order}    ${item_nums}    IN ZIP    ${get_list_on_order_bf}    ${get_list_actual_on_order_af}    ${list_nums}
    \    ${item_on_order_bf}    Sum    ${item_on_order}    ${item_nums}
    \    Should Be Equal As Numbers    ${item_on_order_bf}    ${item_actual_on_order}
    #kiểm tra số lượng trong thẻ tồn kho của hàng hóa
    :FOR    ${item_on_order}     ${item_product}    IN ZIP     ${get_list_actual_on_order_af}    ${list_prs}
    \    ${get_pr_id}    Get product ID    ${item_product}
    \    ${get_onhand}    Asssert value on order in Stock Card    ${get_pr_id}
    \    Should Be Equal As Numbers    ${get_onhand}    ${item_on_order}
    Delete purchase order code    ${ma_phieu}
    #xoas DL
    Delete suplier    ${input_supplier_code}

Xoa DL 4
    [Arguments]    ${dict_loaihh}
    ${list_prs}    Get Dictionary Keys    ${dict_loaihh}
    ${list_hh}     Copy List    ${list_prs}
    ${list_type}    Get Dictionary Values    ${dict_loaihh}
    ${hang_quy_doi}    Create List
    :FOR    ${item_hh}    ${item_type}    IN ZIP    ${list_prs}    ${list_type}
    \    Run Keyword If    '${item_type}' == 'hhsx'    Run Keywords     Remove values from list     ${list_hh}     ${item_hh}    AND    Delete product thr API    ${item_hh}
    \    Run Keyword If    '${item_type}' == 'lodate_unit'    Run Keywords    Remove values from list     ${list_hh}     ${item_hh}    AND    Append To List    ${hang_quy_doi}    ${item_hh}
    Log     ${list_hh}
    Log     ${hang_quy_doi}
    :FOR    ${item_hh}    IN ZIP    ${hang_quy_doi}
    \    ${basic}    Get basic product frm unit product    ${item_hh}
    \    Wait Until Keyword Succeeds    3x    10s    Delete product thr API    ${basic}
    :FOR    ${item_hh}    IN ZIP    ${list_hh}
    \    Wait Until Keyword Succeeds    3x    10s    Delete product thr API    ${item_hh}
