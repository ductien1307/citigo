*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    ${headless_browser}
Library           Collections
Library           BuiltIn
Resource          ../../../../core/API/api_khachhang.robot
Resource          ../../../../core/Ban_Hang/banhang_action.robot
Resource          ../../../../core/Tra_hang/tra_hang_action.robot
Resource          ../../../../core/Tra_hang/tra_hang_page.robot
Resource          ../../../../core/API/api_soquy.robot
Resource          ../../../../config/env_product/envi.robot
Resource          ../../../../core/Ban_Hang/banhang_page.robot
Resource          ../../../../core/Tra_hang/doi_tra_hang_action.robot
Resource          ../../../../core/share/toast_message.robot
Resource          ../../../../core/API/lodate.robot
Resource          ../../../../core/API/api_dathangnhap.robot
Resource          ../../../core/API/api_trahang.robot
Resource          ../../../core/API/api_mhbh.robot


*** Variables ***
&{list_productnums_TH1}    TRLD029=7.5
&{list_productnums_TH2}    TRLD030=5
&{list_productnums_DTH01}    LDQD031=5   LDQD032=1    LDQD033=3    TRLD034=1.25    TRLD035=2
&{list_productnums_DTH02}    LDQD031=5   LDQD032=1    LDQD033=3    TRLD034=1.25    TRLD035=2
@{list_discount}    25    0    45000    1500.87   88000.34
@{discount_type}    dis    none    changedown     disvnd    changeup
&{dict_loaihh}    TRLD029=lodate    TRLD030=lodate    TRLD031=lodate    TRLD032=lodate    TRLD033=lodate    TRLD034=lodate    TRLD035=lodate

*** Test Cases ***
Tao DL mau
    [Tags]        DTLD            ULODA
    [Template]    Add du lieu
    lodate_unit    TRLD029    Sữa chua xoài đác     Mỹ phẩm    4475000    5000   none      none    none    none    none    Tuýp     LDQD029    140000    Thùng    4
    lodate_unit    TRLD030    Trà sữa sen vàng      Mỹ phẩm    70000    5000     none      none    none    none    none    Tuýp     LDQD030    140000    Thùng    2
    lodate_unit    TRLD031    Son merzy màu 01      Mỹ phẩm    40000    5000    none    none    none    none    none    Chiếc     LDQD031    140000    Thùng    7
    lodate_unit    TRLD032    son BBIA màu 05       Mỹ phẩm    20000    5000    none    none    none    none    none     Tuýp     LDQD032    140000    Thùng    6
    lodate_unit    TRLD033     Son merzy màu 02     Mỹ phẩm    12000    5000    none    none    none    none    none    Chiếc     LDQD033    140000    Thùng    5
    lodate_unit    TRLD034    son BBIA màu 06       Mỹ phẩm    50000    5000    none    none    none    none    none    Miếng     LDQD034    140000    Thùng    3
    lodate_unit    TRLD035    son BBIA màu 07       Mỹ phẩm    75000    5000    none    none    none    none    none    Miếng     LDQD035    140000    Thùng    8

Can tra khach
    #Mã KH         List product trả hàng      List product đổi trả hàng    Phí trả hàng    List GGSP              List discount type     GGDTH    Khách thanh toán    Kháchthanhtoánhóađơn    giảm giá hóa đơn
    [Tags]                DTLD            ULODA
    [Template]    Doi_tra_hang_lodate_hd
    KH22157       ${list_productnums_TH1}    ${list_productnums_DTH01}     0               ${list_discount}       ${discount_type}       20000         222222         0                       0

Khach can tra
    [Tags]
    [Template]
    CTKH134       ${list_productnums_TH2}    ${list_productnums_DTH02}    10000           ${list_discount}       ${discount_type}       20          all                 100000


*** Keywords ***
Add du lieu
    [Documentation]    tao DL
    [Arguments]    ${loai_hh}    ${ma_hh}    ${ten_sp}    ${nhom_hang}    ${gia_ban}    ${gia_von}    ${ton}     ${sp_1}   ${sl_1}   ${sp_2}   ${sl_2}    ${dvcb}    ${ma_hh_qd}    ${giaban2}    ${dvqd}    ${giatriqd}
    Wait Until Keyword Succeeds    3x    1s    Delete product if product is visible thr API    ${ma_hh}
    Wait Until Keyword Succeeds    3x    1s    Add product for tracking by product type thr API    ${loai_hh}    ${ma_hh}    ${ten_sp}    ${nhom_hang}    ${gia_ban}    ${gia_von}    ${ton}     ${sp_1}   ${sl_1}   ${sp_2}   ${sl_2}    ${dvcb}    ${ma_hh_qd}    ${giaban2}    ${dvqd}    ${giatriqd}

Doi_tra_hang_lodate_hd
    [Documentation]    trả hàng theo hóa đơn trường hợp giá trị của hóa đơn mua < giá trị của hóa đơn trả
    [Arguments]    ${input_ma_kh}    ${dic_productnums_th}    ${dic_productnums_dth}    ${input_phi_th}    ${list_ggsp}    ${list_discount_type}
    ...    ${input_ggdth}    ${input_khtt}    ${input_khtt_hd}    ${input_gghd}
    ${get_id_kh}    ${get_ten_kh}    ${get_dienthoai_kh}    ${get_diachi_kh}    Create new customer and get info    ${input_ma_kh}
    ${list_product_dth}    Get Dictionary Keys    ${dic_productnums_dth}
    ${list_nums_dth}    Get Dictionary Values    ${dic_productnums_dth}
    ${list_lots}    Create lits lot for list products    ${list_product_dth}    ${list_nums_dth}
    ${get_ma_hd}    Add new invoice with lodate product    ${input_ma_kh}    ${dic_productnums_th}    ${input_gghd}    ${input_khtt_hd}
    #get data frm Trả hàng
    ${get_ma_kh_by_hd_bf_ex}    ${get_tong_tien_hang_bf_ex}    ${get_khach_tt_bf_ex}    ${get_trangthai_bf_ex}    ${list_result_thanhtien_th}    ${list_giavon_th}    ${list_result_toncuoi_th}    Calculating Invoice Amounts    ${get_ma_hd}
    ${list_result_thanhtien_dth}    ${list_giavon_dth}    ${list_result_toncuoi_dth}    ${list_result_newprice}    Get list total sale - endingstock - cost - newprice with additional invoice    ${list_product_dth}
    ...    ${list_nums_dth}    ${list_ggsp}    ${list_discount_type}
    ${get_no_bf_execute}    ${get_tongban_bf_execute}    ${get_tongban_tru_trahang_bf_execute}    Get Customer Debt from API    ${input_ma_kh}
    #compute trả hàng
    ${result_tongtientra}    ${result_phi_th}    ${result_tongtientra_tru_phith}    Compute Tra hang    ${list_result_thanhtien_th}    ${input_phi_th}
    #compute mua hàng
    ${result_tongtienmua}    ${result_ggdth}    ${result_tongtienmua_tru_gg}    ${result_cantrakhach}    ${result_kh_canthanhtoan}    ${actual_khtt}
    ...   Compute Mua Hang    ${list_result_thanhtien_dth}    ${input_ggdth}    ${result_tongtientra_tru_phith}    ${input_khtt}
    #compute KH
    ${result_PTT_dth_KH}    ${result_tongban}   Compute customer debt    ${get_no_bf_execute}    ${result_tongtientra_tru_phith}    ${input_ggdth}   ${result_tongtienmua_tru_gg}    ${actual_khtt}    ${result_tongtienmua}    ${get_tongban_bf_execute}
    #return
    ${return_code}    Create return - exchange invoice with lodate products    ${get_ma_hd}    ${input_ma_kh}    ${dic_productnums_th}
    ...    ${dic_productnums_dth}    ${list_ggsp}    ${list_discount_type}    ${input_phi_th}    ${input_ggdth}    ${input_khtt}
    #assert value product trả hàng
    Assert list onhand and cost by return code    ${return_code}    ${list_result_toncuoi_th}    ${list_giavon_th}
    #assert value product đổi trả hàng
    ${get_additional_invoice_code}    Assert value of product returned in exchange invoice    ${return_code}    ${list_result_toncuoi_dth}   ${list_giavon_dth}
    #assert value in invoice
    Assert value in invoice at exchange invoice    ${get_ma_hd}    ${get_tong_tien_hang_bf_ex}    ${get_khach_tt_bf_ex}    ${get_ma_kh_by_hd_bf_ex}    ${get_trangthai_bf_ex}
    #assert value in return
    Assert value in return at exchange invoice    ${return_code}    ${result_tongtientra}    ${result_phi_th}    ${result_cantrakhach}    ${actual_khtt}    ${result_tongtientra_tru_phith}
    Validate return history by invoice code    ${get_ma_hd}    ${return_code}    ${result_tongtientra}
    #assert value in đổi hàng
    Validate payment information in exchange invoice    ${result_tongtienmua}    ${get_additional_invoice_code}    ${result_tongtienmua_tru_gg}    ${result_tongtientra_tru_phith}    ${result_kh_canthanhtoan}    ${result_ggdth}    ${actual_khtt}    ${input_ma_kh}
    #assert customer and so quy
    ${get_no_af_execute_kh}    ${get_tongban_af_execute_kh}    ${get_tongban_tru_trahang_af_execute_kh}    Run Keyword If    ${result_tongtienmua_tru_gg}<${result_tongtientra_tru_phith}    Get Customer Debt from API    ${input_ma_kh}
    ...    ELSE    Get Customer Debt from API after purchase    ${input_ma_kh}    ${get_additional_invoice_code}    ${actual_khtt}
    ${code}    Set Variable If    ${result_tongtienmua_tru_gg}<${result_tongtientra_tru_phith}    ${return_code}    ${get_additional_invoice_code}
    ${get_maphieu_soquy}    Get Ma Phieu Thu in So quy    ${code}
    Should Be Equal As Numbers    ${get_no_af_execute_kh}    ${result_PTT_dth_KH}
    Should Be Equal As Numbers    ${get_tongban_af_execute_kh}    ${result_tongban}
    Run Keyword If    '${input_khtt}' == '0'    Validate So quy info from Rest API if Invoice is not paid    ${get_maphieu_soquy}
    ...    ELSE    Validate So quy info from Rest API if Invoice is paid    ${get_maphieu_soquy}    ${actual_khtt}
    Delete return thr API    ${return_code}
    Delete data of tracking lodate    ${dict_loaihh}
