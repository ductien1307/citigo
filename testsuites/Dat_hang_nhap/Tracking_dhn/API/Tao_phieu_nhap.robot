*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}      ${headless_browser}
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
Resource          ../../../../core/API/api_phieu_nhap_hang.robot

*** Variables ***
&{dict_product_num}     TRLDQD006=4.5    TRLODA005=1.5    TRSI003=2    TRSX003=2.5
&{dict_giamoi}    TRLDQD006=70000    TRLODA005=112000    TRSI003=85000.84    TRSX003=89000.63
&{dict_gg}    TRLDQD006=10000.25    TRLODA005=25000     TRSI003=15    TRSX003=0
&{dict_type}     TRLDQD006=null    TRLODA005=null     TRSI003=15    TRSX003=0
&{dict_nhaphang}     TRLDQD006=3.5    TRLODA005=3.5    TRSI003=1
&{dict_update}     TRLDQD006=2.5    TRLODA005=2.5    TRSI003=2    TRSX003=1
&{dict_loaihh}    HTP05=pro     HTP06=pro    TRLODA005=lodate     TRLDQD006=lodate_unit    TRSI003=imei    TRSX003=hhsx
&{dict_update2}     TRLDQD006=3.5    TRLODA005=3.5    TRSI003=3    TRSX003=2.5

*** Test Cases ***
Tao DL mau
    [Tags]    TRNCC
    [Template]    Add du lieu
    pro           HTP05           Hàng thành phần 1    tracking2    70000    5000     50      none    none    none    none    none    none    none    none    none
    pro           HTP06           Hàng thành phần 2    tracking2    70000    5000     70      none    none    none    none    none    none    none    none    none
    imei          TRSI003         Điện thoại xiaomi    tracking2    70000    5000    15    none    none    none    none    none    none    none    none    none
    lodate        TRLODA005       DHC ADLAY EXTRA     tracking2    70000    5000    none    none    none    none    none    none    none    none    none    none
    lodate_unit    TRLODA006    Lip Balm Himalaya    tracking2    75000    5000    none    none    none    none    none    Cai     TRLDQD006    140000    Hop    2
    hhsx          TRSX003       Sữa vinamilk pha nguyên kem     tracking2    150000    5000    10    HTP05    1    HTP06    2    none    none    none    none    none

Tao phieu nhap all PDN
    [Tags]    TRNCC
    [Template]    Tao PN lay all tu phieu DHN
    ${dict_product_num}    tracking2    TRNCC003    ${dict_giamoi}    ${dict_gg}    ${dict_type}

Tao phieu nhap thay doi so luong
    [Tags]    TRNCC
    [Template]    Tao PN thay doi so luong tu phieu DHN
    ${dict_product_num}    tracking2    TRNCC003    ${dict_giamoi}    ${dict_gg}    ${dict_type}    ${dict_nhaphang}

Update so luong cho phieu nhap hang
    [Tags]    TRNCC
    [Template]    Update so luong phieu nhap hang
    ${dict_product_num}    tracking2    TRNCC003    ${dict_giamoi}    ${dict_gg}    ${dict_type}    ${dict_nhaphang}    ${dict_update}

Xoa phieu nhap gan voi phieu DHN 1 phan
    [Tags]    TRNCC
    [Template]    Huy phieu nhap hang gan voi phieu DHN
    ${dict_product_num}    tracking2    TRNCC003    ${dict_giamoi}    ${dict_gg}    ${dict_type}    ${dict_nhaphang}

Xoa phieu nhap gan voi phieu DHN Hoan thanh
    [Tags]    TRNCC
    [Template]    Huy phieu nhap hang gan voi phieu DHN hoan thanh
    ${dict_product_num}    tracking2    TRNCC003    ${dict_giamoi}    ${dict_gg}    ${dict_type}    ${dict_nhaphang}

Update so luong phieu dat hang nhap gan voi phieu nhap hang
    [Tags]    TRNCC
    [Template]    Update so luong trong phieu dat hang
    ${dict_product_num}    tracking2    TRNCC003    ${dict_giamoi}    ${dict_gg}    ${dict_type}    ${dict_nhaphang}    ${dict_update2}

Delete du lieu tracking
    [Tags]    TRNCC
    [Template]    Xoa DL 3
    ${dict_loaihh}

*** Keywords ***
Add du lieu
    [Documentation]    tao DL
    [Arguments]    ${loai_hh}    ${ma_hh}    ${ten_sp}    ${nhom_hang}    ${gia_ban}    ${gia_von}    ${ton}     ${sp_1}   ${sl_1}   ${sp_2}   ${sl_2}    ${dvcb}    ${ma_hh_qd}    ${giaban2}    ${dvqd}    ${giatriqd}
    ${get_cat_id}    Get category ID    ${nhom_hang}
    Run Keyword If    '${get_cat_id}'=='0'    Add categories thr API    ${nhom_hang}    ELSE    Log    ignore
    Wait Until Keyword Succeeds    3x    3s    Delete product if product is visible thr API    ${ma_hh}
    Wait Until Keyword Succeeds    3x    3s    Add product for tracking by product type thr API    ${loai_hh}    ${ma_hh}    ${ten_sp}    ${nhom_hang}    ${gia_ban}    ${gia_von}    ${ton}     ${sp_1}   ${sl_1}   ${sp_2}   ${sl_2}    ${dvcb}    ${ma_hh_qd}    ${giaban2}    ${dvqd}    ${giatriqd}

Tao PN lay all tu phieu DHN
    [Documentation]    Lấy all hàng hóa từ phiếu đặt hàng nhập
    [Arguments]        ${dict_product_num}    ${tennhom}    ${input_supplier_code}    ${dict_giamoi}    ${dict_gg}    ${dict_type}
    ${list_prs}    Get Dictionary Keys    ${dict_product_num}
    ${list_nums}    Get Dictionary Values    ${dict_product_num}
    Check id of list product    ${list_prs}
    #thêm mới nhà cung cấp
    ${get_supplier_id}    Add supplier by supplier code    ${input_supplier_code}
    #tạo phiếu đặt hàng nhập
    ${ma_phieu_dhn}    Add new purchase order Da xac nhan NCC no payment thr API    ${input_supplier_code}    ${dict_product_num}    ${dict_giamoi}    ${dict_gg}    ${dict_type}    20
    #tạo phiếu nhập từ pdn
    ${get_list_on_order_bf}    Get list on order frm API    ${list_prs}
    ${ma_phieu_nhap}    Create purchase order from order supplier    ${dict_product_num}    ${list_nums}    ${tennhom}    ${input_supplier_code}    ${ma_phieu_dhn}
    ${get_status_pdn}    Get status of order supplier thr API    ${ma_phieu_dhn}
    Should Be Equal As Strings    ${get_status_pdn}    Hoàn thành
    #validate sau khi tạo phiếu nhập
    Asssert value on order in Stock Card incase reduction    ${list_prs}    ${get_list_on_order_bf}    ${list_nums}
    Delete purchase receipt code    ${ma_phieu_nhap}
    Delete purchase order code    ${ma_phieu_dhn}

Tao PN thay doi so luong tu phieu DHN
    [Documentation]    tạo phiếu nhập hàng từ phiếu đặt hàng nhập, ko all phiếu đhn
    [Arguments]    ${dict_product_num}    ${tennhom}    ${input_supplier_code}    ${dict_giamoi}    ${dict_gg}    ${dict_type}    ${dict_nhaphang}
    ${list_prs}    Get Dictionary Keys    ${dict_product_num}
    ${list_nums}    Get Dictionary Values    ${dict_product_num}
    Check id of list product    ${list_prs}
    ${get_list_on_order_bf}    Get list on order frm API    ${list_prs}
    #thêm mới nhà cung cấp
    ${get_supplier_id}    Add supplier by supplier code    ${input_supplier_code}
    #tạo phiếu đặt hàng nhập
    ${ma_phieu_dhn}    Add new purchase order Da xac nhan NCC no payment thr API    ${input_supplier_code}    ${dict_product_num}    ${dict_giamoi}    ${dict_gg}    ${dict_type}    20
    #
    ${ma_phieu_nhap}    Create purchase order from order supplier    ${dict_nhaphang}    ${list_nums}    ${tennhom}    ${input_supplier_code}    ${ma_phieu_dhn}
    ${get_status_pdn}    Get status of order supplier thr API    ${ma_phieu_dhn}
    Should Be Equal As Strings    ${get_status_pdn}    Nhập một phần
    #validate số lượng tồn kho sau khi tạo phiếu nhập
    Asssert value on order in Stock Card incase change quantity    ${get_list_on_order_bf}    ${dict_product_num}    ${dict_nhaphang}
    Delete purchase receipt code    ${ma_phieu_nhap}
    Delete purchase order code    ${ma_phieu_dhn}

Update so luong phieu nhap hang
    [Documentation]    update số lượng của phiếu nhập hàng (phiếu nhập hàng đc tạo từ 1 phiếu đặt hàng nhập cho trước)
    [Arguments]    ${dict_product_num}    ${tennhom}    ${input_supplier_code}    ${dict_giamoi}    ${dict_gg}    ${dict_type}    ${dict_nhaphang}    ${dict_update}
    ${list_prs}    Get Dictionary Keys    ${dict_product_num}
    ${list_nums}    Get Dictionary Values    ${dict_product_num}
    Check id of list product    ${list_prs}
    ${get_list_on_order_bf}    Get list on order frm API    ${list_prs}
    ${get_supplier_id}    Add supplier by supplier code    ${input_supplier_code}
    ${get_list_on_order_chua_dhn}    Get list on order frm API    ${list_prs}
    ${ma_phieu_dhn}    Add new purchase order Da xac nhan NCC no payment thr API    ${input_supplier_code}    ${dict_product_num}    ${dict_giamoi}    ${dict_gg}    ${dict_type}    20
    #tạo phiếu nhập hàng
    ${ma_phieu_nhap}    Create purchase order from order supplier    ${dict_nhaphang}    ${list_nums}    ${tennhom}    ${input_supplier_code}    ${ma_phieu_dhn}
    #update phiếu nhập hàng
    Update purchase order created from order supplier    ${dict_update}    ${list_nums}    ${tennhom}    ${input_supplier_code}    ${ma_phieu_dhn}    ${ma_phieu_nhap}
    Asssert value on order in Stock Card incase change quantity    ${get_list_on_order_bf}    ${dict_product_num}    ${dict_update}
    Delete purchase receipt code    ${ma_phieu_nhap}
    Delete purchase order code    ${ma_phieu_dhn}

Huy phieu nhap hang gan voi phieu DHN
    [Documentation]     hủy phiếu nhập hàng gắn với phiếu đặt hàng nhập (trạng thái nhập 1 phần)
    [Arguments]     ${dict_product_num}    ${tennhom}    ${input_supplier_code}    ${dict_giamoi}    ${dict_gg}    ${dict_type}    ${dict_nhaphang}
    ${list_prs}    Get Dictionary Keys    ${dict_product_num}
    ${list_nums}    Get Dictionary Values    ${dict_product_num}
    Check id of list product    ${list_prs}
    ${get_supplier_id}    Add supplier by supplier code    ${input_supplier_code}
    ${ma_phieu_dhn}    Add new purchase order Da xac nhan NCC no payment thr API    ${input_supplier_code}    ${dict_product_num}    ${dict_giamoi}    ${dict_gg}    ${dict_type}    20
    ${get_list_on_order_bf}    Get list on order frm API    ${list_prs}
    #tạo phiếu nhập hàng
    ${ma_phieu_nhap}    Create purchase order from order supplier    ${dict_nhaphang}    ${list_nums}    ${tennhom}    ${input_supplier_code}    ${ma_phieu_dhn}
    Delete purchase receipt code    ${ma_phieu_nhap}
    #
    Log    validate thong tin ton kho
    ${get_list_actual_on_order_af}    Get list on order frm API    ${list_prs}
    : FOR    ${item_on_order}    ${item_actual_on_order}    IN ZIP    ${get_list_on_order_bf}    ${get_list_actual_on_order_af}
    \    Should Be Equal As Numbers    ${item_on_order}    ${item_actual_on_order}
    #Delete purchase order code    ${ma_phieu_dhn}

Huy phieu nhap hang gan voi phieu DHN hoan thanh
    [Documentation]     hủy phiếu nhập hàng gắn với phiếu đặt hàng nhập (trạng thái Hoàn thành)
    [Arguments]     ${dict_product_num}    ${tennhom}    ${input_supplier_code}    ${dict_giamoi}    ${dict_gg}    ${dict_type}    ${dict_nhaphang}
    ${list_prs}    Get Dictionary Keys    ${dict_product_num}
    ${list_nums}    Get Dictionary Values    ${dict_product_num}
    Check id of list product    ${list_prs}
    ${get_supplier_id}    Add supplier by supplier code    ${input_supplier_code}
    ${get_list_on_order_bf}    Get list on order frm API    ${list_prs}
    ${ma_phieu_dhn}    Add new purchase order Da xac nhan NCC no payment thr API    ${input_supplier_code}    ${dict_product_num}    ${dict_giamoi}    ${dict_gg}    ${dict_type}    20
    #tạo phiếu nhập hàng
    ${ma_phieu_nhap}    Create purchase order from order supplier    ${dict_nhaphang}    ${list_nums}    ${tennhom}    ${input_supplier_code}    ${ma_phieu_dhn}
    Execute finish purchase order    ${ma_phieu_dhn}
    Delete purchase receipt code    ${ma_phieu_nhap}
    #
    Log    validate thong tin ton kho
    ${get_list_actual_on_order_af}    Get list on order frm API    ${list_prs}
    : FOR    ${item_on_order}    ${item_actual_on_order}    IN ZIP    ${get_list_on_order_bf}    ${get_list_actual_on_order_af}
    \    Should Be Equal As Numbers    ${item_on_order}    ${item_actual_on_order}
    #Delete purchase order code    ${ma_phieu_dhn}

Update so luong trong phieu dat hang
    [Documentation]    update số lượng của phiếu đặt hàng nhập đã tạo phiếu nhập hàng
    [Arguments]    ${dict_product_num}    ${tennhom}    ${input_supplier_code}    ${dict_giamoi}    ${dict_gg}    ${dict_type}    ${dict_nhaphang}    ${dict_update_pdn}
    ${list_prs}    Get Dictionary Keys    ${dict_product_num}
    ${list_nums}    Get Dictionary Values    ${dict_product_num}
    Check id of list product    ${list_prs}
    ${get_list_on_order_bf}    Get list on order frm API    ${list_prs}
    ${get_supplier_id}    Add supplier by supplier code    ${input_supplier_code}
    ${ma_phieu_dhn}    Add new purchase order Da xac nhan NCC no payment thr API    ${input_supplier_code}    ${dict_product_num}    ${dict_giamoi}    ${dict_gg}    ${dict_type}    20
    #tạo phiếu nhập hàng
    ${ma_phieu_nhap}    Create purchase order from order supplier    ${dict_nhaphang}    ${list_nums}    ${tennhom}    ${input_supplier_code}    ${ma_phieu_dhn}
    #update phiếu nhập hàng
    Update number in order supplier    ${dict_update_pdn}    ${list_nums}    ${tennhom}    ${input_supplier_code}    ${ma_phieu_dhn}
    Asssert value on order in Stock Card incase change quantity of order supplier    ${get_list_on_order_bf}    ${dict_product_num}    ${dict_nhaphang}    ${dict_update_pdn}
    Delete purchase receipt code    ${ma_phieu_nhap}
    #Delete purchase order code    ${ma_phieu_dhn}
Xoa DL 3
    [Documentation]    Xóa dữ liệu sau khi sử dụng
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
