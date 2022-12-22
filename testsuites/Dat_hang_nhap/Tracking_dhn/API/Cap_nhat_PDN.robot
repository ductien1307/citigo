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

*** Variables ***
&{dict_pr_num}    TRLDQD002=3.5    TRLODA001=1.5    TRSI001=2    TRSX001=2.5
&{dict_giamoi}    TRLDQD002=70000    TRLODA001=112000    TRSI001=85000.84    TRSX001=89000.63
&{dict_gg}        TRLDQD002=10000.25    TRLODA001=25000    TRSI001=15    TRSX001=0
&{dict_type}      TRLDQD002=null    TRLODA001=null    TRSI001=15    TRSX001=0
&{dict_loaihh}    HTP01=pro     HTP02=pro     TRLDQD002=lodate_unit    TRLODA001=lodate    TRSI001=imei    TRSX001=hhsx

*** Test Cases ***
Tao DL mau
    [Tags]    TRNCC
    [Template]    Add du lieu 2
    pro           HTP01           Hàng thành phần 1    tracking1    70000    5000     50      none    none    none    none    none    none    none    none    none
    pro           HTP02           Hàng thành phần 2    tracking1    70000    5000     70      none    none    none    none    none    none    none    none    none
    imei          TRSI001         Điện thoại xiaomi    tracking1    70000    5000     15      none    none    none    none    none    none    none    none    none
    lodate        TRLODA001       DHC ADLAY EXTRA      tracking1    70000    5000     none    none    none    none    none    none    none    none    none    none
    lodate_unit    TRLODA002    Lip Balm Himalaya    tracking1    75000    5000     none    none    none    none    none    Cai      TRLDQD002    140000     Hop    2
    hhsx          TRSX001         Sữa vinamilk pha     tracking1    150000    5000    10      HTP01    1      HTP02    2    none    none    none    none     none

Thay doi trang thai tu Phieu Tam sang DXN
    [Tags]    TRNCC
    [Template]    Update sang trang thai DHN
    ${dict_pr_num}    NCCDHN002    tracking1

Thay doi trang thai tu DXN sang Phieu Tam
    [Tags]    TRNCC
    [Template]    Update ve trang thai Phieu Tam
    ${dict_pr_num}    NCCDHN002    tracking1
    ...    ${dict_giamoi}    ${dict_gg}    ${dict_type}

Huy phieu DXN
    [Tags]    TRNCC
    [Template]    Huy phieu dat hang nhap
    ${dict_pr_num}    NCCDHN002    tracking1
    ...    ${dict_giamoi}    ${dict_gg}    ${dict_type}

Hoan thanh Phieu DXN
    [Tags]    TRNCC
    [Template]   Hoan thanh phieu dat hang nhap
    ${dict_pr_num}    NCCDHN002    tracking1
    ...    ${dict_giamoi}    ${dict_gg}    ${dict_type}

Delete du lieu tracking
    [Tags]    TRNCC
    [Template]    Xoa DL
    ${dict_loaihh}

*** Keywords ***
Add du lieu 2
    [Documentation]    tao DL cho phần cập nhật PDN
    [Arguments]    ${loai_hh}    ${ma_hh}    ${ten_sp}    ${nhom_hang}    ${gia_ban}    ${gia_von}    ${ton}     ${sp_1}   ${sl_1}   ${sp_2}   ${sl_2}    ${dvcb}    ${ma_hh_qd}    ${giaban2}    ${dvqd}    ${giatriqd}
    ${get_cat_id}    Get category ID    ${nhom_hang}
    Run Keyword If    '${get_cat_id}'=='0'    Add categories thr API    ${nhom_hang}    ELSE    Log    ignore
    Wait Until Keyword Succeeds    3x    3s    Delete product if product is visible thr API    ${ma_hh}
    Wait Until Keyword Succeeds    3x    3s    Add product for tracking by product type thr API    ${loai_hh}    ${ma_hh}    ${ten_sp}    ${nhom_hang}    ${gia_ban}    ${gia_von}    ${ton}     ${sp_1}   ${sl_1}   ${sp_2}   ${sl_2}    ${dvcb}    ${ma_hh_qd}    ${giaban2}    ${dvqd}    ${giatriqd}

Update sang trang thai DHN
    [Arguments]    ${dict_product_num}    ${input_supplier_code}    ${tennhom}
    [Documentation]     chuyển trạng thái của đơn đặt hàng nhập từ phiếu tạm sang Đã Xác Nhận
    ${list_prs}    Get Dictionary Keys    ${dict_product_num}
    ${list_nums}    Get Dictionary Values    ${dict_product_num}
    Check id of list product    ${list_prs}
    #tạo mới NCC
    ${get_supplier_id}    Add supplier by supplier code    ${input_supplier_code}
    #tao phieu nhap
    ${ma_phieu_dhn}    Add new purchase order no payment with supplier    ${input_supplier_code}    ${dict_product_num}
    ${get_list_on_order_bf}    Get list on order frm API    ${list_prs}
    #update trạng thái phiếu: value status 0: Phiếu tạm, 1: đã xác nhận nhà cung cấp
    Update order supplier frm existing order supplier    ${dict_product_num}    ${tennhom}    ${input_supplier_code}    ${ma_phieu_dhn}    1
    Log    validate thong tin ton kho
    Asssert value on order in Stock Card incase increase    ${list_prs}    ${ma_phieu_dhn}    ${get_list_on_order_bf}    ${list_nums}
    ${get_status_pdn}    Get status of order supplier thr API    ${ma_phieu_dhn}
    Should Be Equal As Strings    ${get_status_pdn}    Đã xác nhận NCC
    Delete purchase order code    ${ma_phieu_dhn}

Update ve trang thai Phieu Tam
    [Arguments]    ${dict_product_num}    ${input_supplier_code}    ${tennhom}
    ...    ${dict_giamoi}    ${dict_gg}    ${dict_type}
    [Documentation]     chuyển trạng thái của đơn đặt hàng nhập từ  Đã Xác Nhận sang Phiếu Tạm
    ${list_prs}    Get Dictionary Keys    ${dict_product_num}
    ${list_nums}    Get Dictionary Values    ${dict_product_num}
    Check id of list product    ${list_prs}
    #tạo mới nhà cung cấp
    ${get_supplier_id}    Add supplier by supplier code    ${input_supplier_code}
    #tao phieu nhap
    ${ma_phieu_dhn}    Add new purchase order Da xac nhan NCC no payment thr API    ${input_supplier_code}    ${dict_product_num}    ${dict_giamoi}    ${dict_gg}    ${dict_type}    20
    ${get_list_on_order_bf}    Get list on order frm API    ${list_prs}
    #update trạng thái phiếu: value status 0: Phiếu tạm, 1: đã xác nhận nhà cung cấp
    Update order supplier frm existing order supplier    ${dict_product_num}    ${tennhom}    ${input_supplier_code}    ${ma_phieu_dhn}     0
    Log    validate thong tin ton kho
    Asssert value on order in Stock Card incase reduction    ${list_prs}    ${get_list_on_order_bf}    ${list_nums}
    ${get_status_pdn}    Get status of order supplier thr API    ${ma_phieu_dhn}
    Should Be Equal As Strings    ${get_status_pdn}    Phiếu tạm
    Delete purchase order code    ${ma_phieu_dhn}

Huy phieu dat hang nhap
    [Documentation]    hủy phiếu đặt hàng nhập có trạng thái đã xác nhận nhà cung cấp
    [Arguments]    ${dict_product_num}    ${input_supplier_code}    ${tennhom}
    ...    ${dict_giamoi}    ${dict_gg}    ${dict_type}
    ${list_prs}    Get Dictionary Keys    ${dict_product_num}
    ${list_nums}    Get Dictionary Values    ${dict_product_num}
    Check id of list product    ${list_prs}
    #tạo mới NCC
    ${get_supplier_id}    Add supplier by supplier code    ${input_supplier_code}
    #tao phieu da xac nhan ncc
    ${ma_phieu_dhn}    Add new purchase order Da xac nhan NCC no payment thr API    ${input_supplier_code}    ${dict_product_num}    ${dict_giamoi}    ${dict_gg}    ${dict_type}    20
    ${get_list_on_order_bf}    Get list on order frm API    ${list_prs}
    #Huy bo phieu
    Delete purchase order code    ${ma_phieu_dhn}
    ${get_status_pdn}    Get status of order supplier thr API    ${ma_phieu_dhn}
    Should Be Equal As Strings    ${get_status_pdn}    Đã hủy
    Log    validate thong tin ton kho
    Asssert value on order in Stock Card incase reduction    ${list_prs}    ${get_list_on_order_bf}    ${list_nums}

Hoan thanh phieu dat hang nhap
    [Documentation]    hoàn thành phiếu đặt hàng nhập có trạng thái đã xác nhận nhà cung cấp
    [Arguments]    ${dict_product_num}    ${input_supplier_code}    ${tennhom}
    ...    ${dict_giamoi}    ${dict_gg}    ${dict_type}
    ${get_supplier_id}    Add supplier by supplier code    ${input_supplier_code}
    #tao phieu
    ${ma_phieu_dhn}    Add new purchase order Da xac nhan NCC no payment thr API    ${input_supplier_code}    ${dict_product_num}    ${dict_giamoi}    ${dict_gg}    ${dict_type}    20
    ${list_prs}    Get Dictionary Keys    ${dict_product_num}
    ${list_nums}    Get Dictionary Values    ${dict_product_num}
    ${get_list_on_order_bf}    Get list on order frm API    ${list_prs}
    #
    Execute finish purchase order    ${ma_phieu_dhn}
    ${get_status_pdn}    Get status of order supplier thr API    ${ma_phieu_dhn}
    Should Be Equal As Strings    ${get_status_pdn}    Hoàn thành
    Log    validate thong tin ton kho
    Asssert value on order in Stock Card incase reduction    ${list_prs}    ${get_list_on_order_bf}    ${list_nums}
    Delete purchase order code    ${ma_phieu_dhn}

Xoa DL
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
