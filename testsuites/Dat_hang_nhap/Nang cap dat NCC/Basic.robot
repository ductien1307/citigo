*** Settings ***
Suite Setup       Setup Test Suite    Before Test Quan Ly
Suite Teardown     After Test
Library           Collections
Resource          ../../../core/hang_hoa/hang_hoa_navigation.robot
Resource          ../../../core/share/computation.robot
Resource          ../../../core/Giao_dich/dat_hang_nhap_add_action.robot
Resource          ../../../core/Giao_dich/dat_hang_nhap_list_action.robot
Resource          ../../../core/Giao_dich/giaodich_nav.robot
Resource          ../../../core/API/api_danhmuc_hanghoa.robot
Resource          ../../../core/share/toast_message.robot
Resource          ../../../core/API/api_nha_cung_cap.robot
Resource          ../../../core/API/api_phieu_nhap_hang.robot
Resource          ../../../core/API/api_dathangnhap.robot

*** Variables ***
@{list_supplier_code}      RPNCC003     RPNCC004
@{list_supplier_name}      NCC prenan Loong     NCC kimmy
&{dict_pr}      TP054=3
&{dict_pr}        TP051=5.2       TP050=3
&{dict_pr1}     TP052=2       TP053=6.1
@{list_newprice}    45000    89000

*** Test Cases ***
Suggest số lượng đặt hàng nhập
    [Documentation]   	Suggest số lượng đặt hàng nhập
    [Tags]      NCDN
    [Template]    ncdhn1
    ${dict_pr}

Đề xuat 1 ncc
    [Documentation]   	Đề xuất 1 NCC
    [Tags]      NCDN
    [Template]    ncdhn2
    RPNCC005      Công ty legal     ${dict_pr}       ${list_newprice}

Đề xuat n ncc
    [Documentation]   	Đề xuất > 1 NCC
    [Tags]      NCDN
    [Template]    ncdhn3
    ${list_supplier_code}    ${list_supplier_name}     ${dict_pr}     ${dict_pr1}       ${list_newprice}

Dã gán ncc trước khi đề xuất
    [Documentation]   	Đã gán ncc trước khi đề xuất
    [Tags]      NCDN
    [Template]    ncdhn4
    RPNCC005      Công ty legal     ${dict_pr}       ${list_newprice}

*** Keywords ***
ncdhn1
    [Arguments]     ${dict_product}
    ${purchase_code}   Add new purchase order no payment without supplier    ${dict_product}
    ${return_code}   Add new return without customer and imei frm API    ${dict_product}   0
    ${invoice_code}   Add new invoice without customer thr API    ${dict_product}     0
    ${list_pr}      Get Dictionary Keys    ${dict_product}
    Wait Until Keyword Succeeds    3 times    0 s    Go to Dat Hang Nhap
    Reload Page
    Go to tao phieu DHN
    Click Bo qua if popup Mo ban nhap appear
    ${endpoint_hh}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${resp}    Get Request and return body    ${endpoint_hh}
    :FOR      ${item_pr}    IN ZIP      ${list_pr}
    \     Wait Until Keyword Succeeds    3 times    2s    Input data in textbox and wait until it is visible    ${textbox_nh_search_hh}    ${item_pr}    ${nh_item_indropdown_search}
    \     ...    ${nh_cell_first_product_code}
    \     ${endpoint_on_order}    Format String    $..Data[?(@.Code=="{0}")].OnOrder    ${item_pr}
    \     ${endpoint_onhand}    Format String     $..Data[?(@.Code=="{0}")].OnHand    ${item_pr}
    \     ${endpoint_reserved}    Format String     $..Data[?(@.Code=="{0}")].Reserved    ${item_pr}
    \     ${get_ton}    Get data from response json    ${resp}    ${endpoint_onhand}
    \     ${get_dat_ncc}    Get data from response json    ${resp}    ${endpoint_on_order}
    \     ${get_kh_dat}    Get data from response json    ${resp}    ${endpoint_reserved}
    \     ${expect_text}      Format String     Tồn: {0} Đặt NCC: {1} KH đặt: {2}   ${get_ton}      ${get_dat_ncc}      ${get_kh_dat}
    \     Element Should Contain    ${popup_suggest_dhn}    ${expect_text}

ncdhn2
    [Arguments]     ${ma_ncc}   ${ten_ncc}      ${dict_pr_num}    ${list_newprice}
    ${receipt_code}    Add new purchase receipt thr API    ${ma_ncc}    ${dict_pr_num}    ${list_newprice}    10     10000
    ${list_pr}      Get Dictionary Keys    ${dict_pr_num}
    Wait Until Keyword Succeeds    3 times    0 s    Go to Dat Hang Nhap
    Reload Page
    Go to tao phieu DHN
    Click Bo qua if popup Mo ban nhap appear
    Open popup De xuat DHN and select supplier - onhand    ${ten_ncc}
    Click Element    ${button_dx_xong}
    Wait Until Keyword Succeeds    3 times    3s    Element Should Contain    ${textbox_dhn_ncc}    ${ten_ncc}
    :FOR      ${item_pr}      IN ZIP      ${list_pr}
    \      Wait Until Keyword Succeeds    3 times    3s     Element Should Contain    ${cell_sp_dhn}     ${item_pr}
    Delete purchase receipt code    ${receipt_code}

ncdhn3
    [Arguments]     ${list_ncc}     ${list_ten_ncc}    ${dict_pr_num}      ${dict_pr_num_1}   ${list_newprice}
    ${ncc_1}    Get From List    ${list_ncc}    0
    ${ncc_2}    Get From List    ${list_ncc}    1
    ${receipt_code}    Add new purchase receipt thr API    ${ncc_1}    ${dict_pr_num}    ${list_newprice}    10     10000
    ${receipt_code1}    Add new purchase receipt thr API    ${ncc_2}    ${dict_pr_num_1}    ${list_newprice}    10     0
    ${list_pr}      Get Dictionary Keys    ${dict_pr_num}
    ${list_pr1}     Get Dictionary Keys    ${dict_pr_num_1}
    Wait Until Keyword Succeeds    3 times    0 s    Go to Dat Hang Nhap
    Reload Page
    Go to tao phieu DHN
    Click Bo qua if popup Mo ban nhap appear
    Open popup De xuat DHN and select list supplier - onhand    ${list_ten_ncc}
    :FOR      ${item_ten_ncc}     IN ZIP      ${list_ten_ncc}
    \    Wait Until Keyword Succeeds    3 times    3s    Element Should Not Contain      ${textbox_dhn_ncc}    ${item_ten_ncc}
    :FOR      ${item_pr}      IN ZIP      ${list_pr}
    \     Wait Until Keyword Succeeds    3 times    3s    Element Should Contain    ${cell_sp_dhn}     ${item_pr}
    :FOR      ${item_pr}      IN ZIP      ${list_pr1}
    \     Element Should Contain    ${cell_sp_dhn}     ${item_pr}
    Delete purchase receipt code    ${receipt_code}
    Delete purchase receipt code    ${receipt_code1}

ncdhn4
    [Arguments]     ${ma_ncc}    ${ten_ncc}      ${dict_pr_num}    ${list_newprice}
    ${receipt_code}    Add new purchase receipt thr API    ${ma_ncc}    ${dict_pr_num}    ${list_newprice}    10     10000
    ${list_pr}      Get Dictionary Keys    ${dict_pr_num}
    Wait Until Keyword Succeeds    3 times    0 s    Go to Dat Hang Nhap
    Reload Page
    Go to tao phieu DHN
    Click Bo qua if popup Mo ban nhap appear
    Input supplier   NCC0001
    Open popup De xuat DHN and select supplier - onhand    ${ten_ncc}
    Click Element    ${button_dx_xong}
    Wait Until Keyword Succeeds    3 times    3s    Element Should Not Contain    ${textbox_dhn_ncc}    ${ten_ncc}
    :FOR      ${item_pr}      IN ZIP      ${list_pr}
    \     Wait Until Keyword Succeeds    3 times    3s    Element Should Contain    ${cell_sp_dhn}     ${item_pr}
    Delete purchase receipt code    ${receipt_code}
