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
&{dict_pr_num}    TRHHSX002=2.5      TRLDQD004=3.5    TRLODA003=1.5    TRSI002=2
&{dict_giamoi}    TRHHSX002=89000.63    TRLDQD004=70000    TRLODA003=112000    TRSI002=85000.84
&{dict_gg}     TRHHSX002=0    TRLDQD004=10000.25    TRLODA003=25000       TRSI002=15
&{dict_type}    TRHHSX002=0    TRLDQD004=null    TRLODA003=null      TRSI002=15
&{dict_nhaphang}    TRLODA003=1
&{dict_loaihh}    HTP03=pro     HTP04=pro    TRHHSX002=hhsx     TRLDQD004=lodate_unit     TRLODA003=lodate   TRSI002=imei

*** Test Cases ***
Tao DL mau
    [Tags]    TRNCC
    [Template]    Add du lieu
    pro           HTP03           Hàng thành phần 1    tracking    70000    5000     50      none    none    none    none    none    none    none    none    none
    pro           HTP04           Hàng thành phần 2    tracking    70000    5000     70      none    none    none    none    none    none    none    none    none
    imei          TRSI002         Điện thoại xiaomi    tracking    70000    5000    15    none    none    none    none    none    none    none    none    none
    lodate        TRLODA003       DHC ADLAY EXTRA     tracking    70000    5000    none    none    none    none    none    none    none    none    none    none
    lodate_unit    TRLODA004        Lip Balm Himalaya    tracking    75000    5000    none    none    none    none    none    Cai     TRLDQD004    140000    Hop    2
    hhsx          TRHHSX002       Sữa vinamilk pha     tracking    150000    5000    10    HTP03    1    HTP04    2    none    none    none    none    none

Sao chep phieu DXN
    [Tags]    TRNCC
    [Template]    Coppy phieu dat hang nhap DXN
    ${dict_pr_num}    NCCDHN001    tracking
    ...    ${dict_giamoi}    ${dict_gg}    ${dict_type}

Sao chep phieu o trang thai nhap 1 phan
    [Tags]    TRNCC
    [Template]    Sao chep phieu nhap 1 phan
    ${dict_pr_num}    NCCDHN001    tracking
    ...    ${dict_giamoi}    ${dict_gg}    ${dict_type}    ${dict_nhaphang}

Sao chep phieu o trang thai ket thuc
    [Tags]    TRNCC
    [Template]    Sao chep PDN o trang thai ket thuc
    ${dict_pr_num}    NCCDHN001    tracking
    ...    ${dict_giamoi}    ${dict_gg}    ${dict_type}    ${dict_nhaphang}

Delete du lieu tracking
    [Tags]    TRNCC
    [Template]    Xoa DL 2
    ${dict_pr_num}

*** Keywords ***
Add du lieu
    [Documentation]    tao DL
    [Arguments]    ${loai_hh}    ${ma_hh}    ${ten_sp}    ${nhom_hang}    ${gia_ban}    ${gia_von}    ${ton}     ${sp_1}   ${sl_1}   ${sp_2}   ${sl_2}    ${dvcb}    ${ma_hh_qd}    ${giaban2}    ${dvqd}    ${giatriqd}
    ${get_cat_id}    Get category ID    ${nhom_hang}
    Run Keyword If    '${get_cat_id}'=='0'    Add categories thr API    ${nhom_hang}    ELSE    Log    ignore
    Wait Until Keyword Succeeds    3x    3s    Delete product if product is visible thr API    ${ma_hh}
    Wait Until Keyword Succeeds    3x    3s    Add product for tracking by product type thr API    ${loai_hh}    ${ma_hh}    ${ten_sp}    ${nhom_hang}    ${gia_ban}    ${gia_von}    ${ton}     ${sp_1}   ${sl_1}   ${sp_2}   ${sl_2}    ${dvcb}    ${ma_hh_qd}    ${giaban2}    ${dvqd}    ${giatriqd}

Coppy phieu dat hang nhap DXN
    [Arguments]    ${dict_product_num}    ${input_supplier_code}    ${tennhom}
    ...    ${dict_giamoi}    ${dict_gg}    ${dict_type}
    [Documentation]     Sao chép PDN ở trạng thái ĐXN
    ${get_supplier_id}    Add supplier by supplier code    ${input_supplier_code}
    #tao phieu nhap
    ${ma_phieu_dhn}    Add new purchase order Da xac nhan NCC no payment thr API    ${input_supplier_code}    ${dict_product_num}    ${dict_giamoi}    ${dict_gg}    ${dict_type}    20
    ${list_prs}    Get Dictionary Keys    ${dict_product_num}
    ${list_nums}    Get Dictionary Values    ${dict_product_num}
    ${get_list_on_order_bf}    Get list on order frm API    ${list_prs}
    #
    Coppy order supplier frm existing order supplier    ${dict_product_num}    ${tennhom}    ${input_supplier_code}    ${ma_phieu_dhn}
    #
    Log    validate thong tin ton kho
    Asssert value on order in Stock Card incase increase    ${list_prs}    ${ma_phieu_dhn}    ${get_list_on_order_bf}    ${list_nums}
    ${ma_phieu_coppy}    Validate status of order supplier coppy    ${ma_phieu_dhn}     Đã xác nhận NCC
    Delete purchase order code    ${ma_phieu_dhn}
    Delete purchase order code    ${maphieu_coppy}

Sao chep phieu nhap 1 phan
    [Documentation]    sao chép phiếu đặt hàng nhập ở trạng thái nhập 1 phần => chọn trạng thái DXN
    [Arguments]    ${dict_product_num}    ${input_supplier_code}    ${tennhom}
    ...    ${dict_giamoi}    ${dict_gg}    ${dict_type}    ${dict_nhaphang}
    #
    ${get_supplier_id}    Add supplier by supplier code    ${input_supplier_code}
    #tao phieu dat hang nhap
    ${ma_phieu_dhn}    Add new purchase order Da xac nhan NCC no payment thr API    ${input_supplier_code}    ${dict_product_num}    ${dict_giamoi}    ${dict_gg}    ${dict_type}    20
    #
    ${list_prs_nhap}    Get Dictionary Keys    ${dict_nhaphang}
    ${list_nums_nhap}    Get Dictionary Values    ${dict_nhaphang}
    ${list_lot}    Import lot name for products by generating randomly    ${list_prs_nhap}    ${list_nums_nhap}
    #tao phieu nhap 1 phan
    ${phieu_nhap_hang}    Add new purchase order from order suppliers    ${ma_phieu_dhn}    ${dict_nhaphang}    ${input_supplier_code}    ${tennhom}
    ${list_prs}    Get Dictionary Keys    ${dict_product_num}
    ${list_nums}    Get Dictionary Values    ${dict_product_num}
    ${get_list_on_order_bf}    Get list on order frm API    ${list_prs}
    #
    Coppy order supplier frm existing order supplier    ${dict_product_num}    ${tennhom}    ${input_supplier_code}    ${ma_phieu_dhn}
    #
    Log    validate thong tin ton kho
    Asssert value on order in Stock Card incase increase    ${list_prs}    ${ma_phieu_dhn}    ${get_list_on_order_bf}    ${list_nums}
    ${maphieu_coppy}    Validate status of order supplier coppy    ${ma_phieu_dhn}     Đã xác nhận NCC
    Delete purchase receipt code    ${phieu_nhap_hang}
    Delete purchase order code    ${ma_phieu_dhn}
    Delete purchase order code    ${maphieu_coppy}

Sao chep PDN o trang thai ket thuc
    [Documentation]    Sao chép phiếu ở trạng thái đã kết thúc => chọn trạng thái DXN
    [Arguments]    ${dict_product_num}    ${input_supplier_code}    ${tennhom}
    ...    ${dict_giamoi}    ${dict_gg}    ${dict_type}    ${dict_nhaphang}
    #
    ${get_supplier_id}    Add supplier by supplier code    ${input_supplier_code}
    #tao phieu dat hang nhap
    ${ma_phieu_dhn}    Add new purchase order Da xac nhan NCC no payment thr API    ${input_supplier_code}    ${dict_product_num}    ${dict_giamoi}    ${dict_gg}    ${dict_type}    20
    #
    Execute finish purchase order    ${ma_phieu_dhn}
    ${list_prs}    Get Dictionary Keys    ${dict_product_num}
    ${list_nums}    Get Dictionary Values    ${dict_product_num}
    ${get_list_on_order_bf}    Get list on order frm API    ${list_prs}
    #
    Coppy order supplier frm existing order supplier    ${dict_product_num}    ${tennhom}    ${input_supplier_code}    ${ma_phieu_dhn}
    #
    Log    validate thong tin ton kho
    Asssert value on order in Stock Card incase increase    ${list_prs}    ${ma_phieu_dhn}    ${get_list_on_order_bf}    ${list_nums}
    ${maphieu_coppy}    Validate status of order supplier coppy    ${ma_phieu_dhn}     Đã xác nhận NCC
    Delete purchase order code    ${ma_phieu_dhn}
    Delete purchase order code    ${maphieu_coppy}

Xoa DL 2
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
