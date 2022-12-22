*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}      ${headless_browser}

*** Variables ***
&{dict_product_num}     TRLDQD009=3.5    TRLODA007=1.5    TRSI003=2    TRSX003=2.5
&{dict_giamoi}    TRLDQD009=70000    TRLODA007=112000    TRSI003=85000.84    TRSX003=89000.63
&{dict_gg}    TRLDQD009=10000.25    TRLODA007=25000     TRSI003=15    TRSX003=0
&{dict_type}     TRLDQD009=null    TRLODA007=null     TRSI003=15    TRSX003=0
&{dict_nhaphang}     TRLDQD009=3.5    TRLODA007=3.5    TRSI003=1
&{dict_update}     TRLDQD009=2.5    TRLODA007=2.5    TRSI003=2    TRSX003=1

*** Test Cases ***
Tao DL mau
    [Tags]
    [Template]    Add du lieu
    imei          TRSI003         Điện thoại xiaomi    tracking2    70000    5000    15    none    none    none    none    none    none    none    none    none
    lodate        TRLODA007       DHC ADLAY EXTRA     tracking2    70000    5000    none    none    none    none    none    none    none    none    none    none
    lodate_unit    TRLODATE008    Lip Balm Himalaya    tracking2    75000    5000    none    none    none    none    none    Cai     TRLDQD009    140000    Hop    2
    hhsx          TRSX003       Sữa vinamilk pha nguyên kem     tracking2    150000    5000    10    TP231    1    TP232    2    none    none    none    none    none

Xoa hang hoa trong pdn gan voi phieu nhap
    [Tags]
    [Template]    Huy phieu nhap hang gan voi phieu DHN
    ${dict_product_num}    tracking2    TRNCC003    ${dict_giamoi}    ${dict_gg}    ${dict_type}    ${dict_nhaphang}

Delete du lieu tracking
    [Tags]    
    [Template]    Xoa DL 3
    ${dict_product_num}

*** Keywords ***
Add du lieu
    [Documentation]    tao DL
    [Arguments]    ${loai_hh}    ${ma_hh}    ${ten_sp}    ${nhom_hang}    ${gia_ban}    ${gia_von}    ${ton}     ${sp_1}   ${sl_1}   ${sp_2}   ${sl_2}    ${dvcb}    ${ma_hh_qd}    ${giaban2}    ${dvqd}    ${giatriqd}
    ${get_cat_id}    Get category ID    ${nhom_hang}
    Run Keyword If    '${get_cat_id}'=='0'    Add categories thr API    ${nhom_hang}    ELSE    Log    ignore
    Wait Until Keyword Succeeds    3x    15s    Delete product if product is visible thr API    ${ma_hh}
    Add product for tracking by product type thr API    ${loai_hh}    ${ma_hh}    ${ten_sp}    ${nhom_hang}    ${gia_ban}    ${gia_von}    ${ton}     ${sp_1}   ${sl_1}   ${sp_2}   ${sl_2}    ${dvcb}    ${ma_hh_qd}    ${giaban2}    ${dvqd}    ${giatriqd}

Xoa hang hoa o phieu dhn
    [Documentation]    xóa hàng hóa ở phiếu đhn có trạng thái là nhập 1 phần (hàng hóa bị xóa ko nằm trong phiếu nhập)
    [Arguments]
    #tạo nhà cung cấp
    ${get_supplier_id}    Add supplier by supplier code    ${input_supplier_code}
    #tạo phiếu đặt hàng nhập
    ${ma_phieu_dhn}    Add new purchase order Da xac nhan NCC no payment thr API    ${input_supplier_code}    ${dict_product_num}    ${dict_giamoi}    ${dict_gg}    ${dict_type}    20
    ${get_list_on_order_bf}    Get list on order frm API    ${list_prs}
    #get thông tin nợ NCC, thông tin hang hóa, phiếu đhn
    ${ma_phieu_dat}    Get first purchase order code frm API    ${ma_ncc}
    ${get_soluong}    ${get_tongtienhang}    ${get_giamga_vnd}    ${get_giamgia_%}    ${get_datrancc}    ${get_cantrancc}    Get purchase order summary thr api
    ...    ${ma_phieu_dat}
    ${get_no_ncc_hientai}    ${get_tong_mua}    ${get_tong_mua_tru_tra_hang}    Get Supplier Debt from API    ${ma_ncc}
    #tao phiếu Nhập

    #validate thông tin hàng hóa
    #xóa hàng hóa trong phiếu đặt Nhập
    # validate thông tin đhn sau khi xóa hàng hóa
