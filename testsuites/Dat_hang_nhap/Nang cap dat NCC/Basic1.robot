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
Resource          ../../../core/API/api_mhbh.robot
Resource          ../../../core/API/api_hanghoa.robot
Resource          ../../../prepare/Hang_hoa/Sources/hanghoa.robot
Resource          ../../../prepare/Hang_hoa/Sources/doitac.robot

*** Variables ***
&{dict_pr}        TP064=5.2
&{dict_pr1}       TP064=5.2
@{list_newprice}    45000

*** Test Cases ***
Tồn ít nhất
    [Documentation]    Đề xuất DNH theo Tồn ít nhất - Tồn hiện tại
    [Tags]      NCDN
    [Template]    ncdhn5
    SPDN0001    10    20    100    NCCDN001    NCC test ncdn 1    5
    ...    ${list_newprice}

Tồn nhiều nhất
    [Documentation]    Đề xuất DNH theo Tồn nhiều nhất - Tồn hiện tại
    [Tags]      NCDN
    [Template]    ncdhn6
    SPDN0002    10    20    100    NCCDN002    NCC test ncdn 2     15
    ...    ${list_newprice}

Số lượng bán trong 30 ngày
    [Documentation]    Đề xuất DNH theo Số lượng bán trong 30 ngày
    [Tags]      NCDN
    [Template]    ncdhn7
    SPDN0003      NCCDN003    NCC test dhn 3    15     6
    ...    ${list_newprice}

Đặt hàng nhập lần cuối
    [Documentation]    Đặt hàng nhập lần cuối
    [Tags]      NCDN
    [Template]    ncdhn8
    SPDN0004      NCCDN005    NCC test dhn 4    12     16
    ...    ${list_newprice}

*** Keywords ***
ncdhn5
    [Arguments]    ${ma_sp}    ${ton}    ${ton_min}    ${ton_max}    ${ma_ncc}    ${ten_ncc}
    ...    ${num}    ${list_newprice}
    Delete product if product is visible thr API    ${ma_sp}
    Delete supplier if supplier exist    ${ma_ncc}
    Add supplier    ${ma_ncc}    ${ten_ncc}    0986598965
    Add product have min quantity and max quantity thr API    ${ma_sp}    test dhn    Đồ ăn vặt   50000    40000    ${ton}
    ...    ${ton_min}    ${ton_max}
    &{dict_pr_num}    Create Dictionary    ${ma_sp}=${num}
    ${receipt_code}    Add new purchase receipt thr API    ${ma_ncc}    ${dict_pr_num}    ${list_newprice}    10    10000
    ${list_pr}    Get Dictionary Keys    ${dict_pr_num}
    Wait Until Keyword Succeeds    3 times    0 s    Go to Dat Hang Nhap
    Reload Page
    Go to tao phieu DHN
    Click Bo qua if popup Mo ban nhap appear
    Open popup De xuat DHN and select supplier - onhand    ${ten_ncc}
    Click Element    ${checkbox_dx_ton_it_nhat}
    Click Element    ${button_dx_xong}
    Wait Until Keyword Succeeds    3 times    3s    Element Should Contain    ${textbox_dhn_ncc}    ${ten_ncc}
    ${endpoint_pr}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${get_resp}    Get Request and return body    ${endpoint_pr}
    ${jsonpath_tonmin}    Format String    $..Data[?(@.Code=="{0}")].MinQuantity    ${ma_sp}
    ${jsonpath_tonkho}    Format String    $..Data[?(@.Code=="{0}")].OnHand    ${ma_sp}
    ${get_tonmin}    Get data from response json    ${get_resp}    ${jsonpath_tonmin}
    ${get_tonkho}    Get data from response json    ${get_resp}    ${jsonpath_tonkho}
    ${result_sl_dat}    Minus    ${get_tonmin}    ${get_tonkho}
    ${result_sl_dat}    Set Variable If    ${result_sl_dat}<0    0    ${result_sl_dat}
    ${result_num}    Get Text    ${cell_nh_lastest_number}
    Should Be Equal As Numbers    ${result_num}    ${result_sl_dat}
    Delete product thr API    ${ma_sp}
    Delete suplier    ${ma_ncc}

ncdhn6
    [Arguments]    ${ma_sp}    ${ton}    ${ton_min}    ${ton_max}    ${ma_ncc}    ${ten_ncc}
    ...    ${num}    ${list_newprice}
    Delete product if product is visible thr API    ${ma_sp}
    Delete supplier if supplier exist    ${ma_ncc}
    Add product have min quantity and max quantity thr API    ${ma_sp}    test dhn    Đồ ăn vặt    50000    40000    ${ton}
    ...    ${ton_min}    ${ton_max}
    Add supplier    ${ma_ncc}    ${ten_ncc}    0986598796
    &{dict_pr_num}    Create Dictionary    ${ma_sp}=${num}
    ${receipt_code}    Add new purchase receipt thr API    ${ma_ncc}    ${dict_pr_num}    ${list_newprice}    10    10000
    ${list_pr}    Get Dictionary Keys    ${dict_pr_num}
    Wait Until Keyword Succeeds    3 times    0 s    Go to Dat Hang Nhap
    Reload Page
    Go to tao phieu DHN
    Click Bo qua if popup Mo ban nhap appear
    Open popup De xuat DHN and select supplier - onhand    ${ten_ncc}
    Click Element    ${checkbox_dx_ton_nhieu_nhat}
    Click Element    ${button_dx_xong}
    Wait Until Keyword Succeeds    3 times    3s    Element Should Contain    ${textbox_dhn_ncc}    ${ten_ncc}
    ${endpoint_pr}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${get_resp}    Get Request and return body    ${endpoint_pr}
    ${jsonpath_tonmax}    Format String    $..Data[?(@.Code=="{0}")].MaxQuantity    ${ma_sp}
    ${jsonpath_tonkho}    Format String    $..Data[?(@.Code=="{0}")].OnHand    ${ma_sp}
    ${get_tonmax}    Get data from response json    ${get_resp}    ${jsonpath_tonmax}
    ${get_tonkho}    Get data from response json    ${get_resp}    ${jsonpath_tonkho}
    ${result_sl_dat}    Minus    ${get_tonmax}    ${get_tonkho}
    ${result_sl_dat}    Set Variable If    ${result_sl_dat}<0    0    ${result_sl_dat}
    ${result_num}    Get Text    ${cell_nh_lastest_number}
    Should Be Equal As Numbers    ${result_num}    ${result_sl_dat}
    Delete product thr API    ${ma_sp}
    Delete suplier    ${ma_ncc}

ncdhn7
    [Arguments]    ${ma_sp}     ${ma_ncc}    ${ten_ncc}
    ...    ${num_nhap}    ${num_ban}    ${list_newprice}
    Delete product if product is visible thr API    ${ma_sp}
    Delete supplier if supplier exist    ${ma_ncc}
    Add product thr API    ${ma_sp}    test dhn    Đồ ăn vặt     50000    40000    20
    Add supplier    ${ma_ncc}    ${ten_ncc}    092589542
    &{dict_pr_nhap}    Create Dictionary    ${ma_sp}=${num_nhap}
    &{dict_pr_ban}     Create Dictionary    ${ma_sp}=${num_ban}
    ${receipt_code}    Add new purchase receipt thr API    ${ma_ncc}    ${dict_pr_nhap}    ${list_newprice}    10    10000
    ${invoice_code}    Add new invoice without customer thr API    ${dict_pr_ban}    0
    Wait Until Keyword Succeeds    3 times    0 s    Go to Dat Hang Nhap
    Reload Page
    Go to tao phieu DHN
    Click Bo qua if popup Mo ban nhap appear
    Open popup De xuat DHN and select supplier - onhand    ${ten_ncc}
    Click Element    ${checkbox_dx_dhn_sl_ban}
    Click Element    ${button_dx_xong}
    Wait Until Keyword Succeeds    3 times    3s    Element Should Contain    ${textbox_dhn_ncc}    ${ten_ncc}
    ${result_num}    Get Text    ${cell_nh_lastest_number}
    Should Be Equal As Numbers    ${num_ban}    ${result_num}
    Delete product thr API    ${ma_sp}
    Delete suplier    ${ma_ncc}

ncdhn8
    [Arguments]    ${ma_sp}      ${ma_ncc}    ${ten_ncc}
    ...    ${num_nhap}    ${num_dat}    ${list_newprice}
    Delete product if product is visible thr API    ${ma_sp}
    Delete supplier if supplier exist    ${ma_ncc}
    Add product thr API    ${ma_sp}    test dhn    Đồ ăn vặt     50000    40000    25
    Add supplier    ${ma_ncc}    ${ten_ncc}    096589542
    &{dict_pr_nhap}    Create Dictionary    ${ma_sp}=${num_nhap}
    &{dict_pr_dat}     Create Dictionary    ${ma_sp}=${num_dat}
    ${receipt_code}    Add new purchase receipt thr API    ${ma_ncc}    ${dict_pr_nhap}    ${list_newprice}    10    10000
    ${order_code}       Add new purchase order no payment with supplier    ${ma_ncc}    ${dict_pr_dat}
    Wait Until Keyword Succeeds    3 times    3s    Execute finish purchase order    ${order_code}
    Wait Until Keyword Succeeds    3 times    0 s    Go to Dat Hang Nhap
    Reload Page
    Go to tao phieu DHN
    Click Bo qua if popup Mo ban nhap appear
    Open popup De xuat DHN and select supplier - onhand    ${ten_ncc}
    Click Element    ${checkbox_dx_dhn_lan_cuoi}
    Click Element    ${button_dx_xong}
    Wait Until Keyword Succeeds    3 times    3s    Element Should Contain    ${textbox_dhn_ncc}    ${ten_ncc}
    ${result_num}    Get Text    ${cell_nh_lastest_number}
    Should Be Equal As Numbers    ${num_dat}    ${result_num}
    Delete product thr API    ${ma_sp}
    Delete suplier    ${ma_ncc}
