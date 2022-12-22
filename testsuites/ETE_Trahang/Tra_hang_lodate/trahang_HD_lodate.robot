*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    ${headless_browser}
Test Setup
Test Teardown     After Test
Resource          ../../../core/API/api_danhmuc_hanghoa.robot
Resource          ../../../core/API/api_khachhang.robot
Resource          ../../../core/API/api_mhbh.robot
Resource          ../../../core/share/toast_message.robot
Resource          ../../../core/API/api_soquy.robot
Resource          ../../../core/share/javascript.robot
Resource          ../../../core/share/list_dictionary.robot
Resource          ../../../core/share/discount.robot
Resource          ../../../core/Tra_hang/tra_hang_action.robot
Resource          ../../../core/API/api_trahang.robot
Resource          ../../../core/Tra_hang/tra_hang_page.robot
Resource          ../../../core/Tra_hang/tra_hang_popup_page.robot
Resource          ../../../core/Ban_Hang/banhang_action.robot
Resource          ../../../core/Ban_Hang/banhang_page.robot
Resource          ../../../core/API/api_hoadon_banhang.robot
Resource          ../../../core/API/api_dathangnhap.robot
Resource          ../../../core/share/lodate.robot

*** Variables ***
&{dict_product1}    LDQD07=2.25     TRLD08=3.75    TRLD09=4
&{dict_product2}    LDQD010=2     TRLD011=3.8    TRLD012=3
&{dict_product3}    LDQD07=1.5     TRLD08=2.64    TRLD09=4.2
&{dict_product4}    LDQD010=3.5     TRLD011=4.25    TRLD012=4.2
&{dict_delete_product01}     TRLD08=3.75
&{dict_delete_product02}     TRLD011=3.8
@{list_discount}    5    0    15000
@{discount_type}    dis   none    disvnd
&{dict_loaihh}      TRLD07=lodate      TRLD08=lodate     TRLD09=lodate    TRLD010=lodate      TRLD011=lodate      TRLD012=lodate

*** Test Cases ***
Tao DL mau
    [Tags]        LTHHD                        LTH            ULODA
    [Template]    Add du lieu
    lodate_unit    TRLD07      DHC ADLAY EXTRA      trackingld    70000    5000    none    none    none    none    none    Chiếc     LDQD07    140000    Thùng    4
    lodate_unit    TRLD08    son BBIA màu 04        trackingld    75000    5000    none    none    none    none    none    Quyển     LDQD08    140000    Thùng    2
    lodate_unit    TRLD09     Son merzy màu 01      trackingld    70000    5000    none    none    none    none    none    Chiếc     LDQD09    140000    Thùng    7
    lodate_unit    TRLD010    son BBIA màu 05       trackingld    75000    5000    none    none    none    none    none    Tuýp     LDQD010    140000    Thùng    6
    lodate_unit    TRLD011     Son merzy màu 02     trackingld    70000    5000    none    none    none    none    none    Chiếc     LDQD011    140000    Thùng    5
    lodate_unit    TRLD012    son BBIA màu 06       trackingld    75000    5000    none    none    none    none    none    Miếng     LDQD012    140000    Thùng    3
    #Mã KH         List products        List product del             List GGSP        List discount type    Phí trả hàng    GGHD     Khách thanh toán
Trả 1 phần
    [Tags]        LTHHD                        LTH            ULODA
    [Template]    thhd_lodate_01
    CTKH007       ${dict_product1}    ${dict_delete_product01}    ${list_discount}    ${discount_type}     50000           10000        all
    CTKH007       ${dict_product2}    ${dict_delete_product02}    ${list_discount}    ${discount_type}       0              15           0

Trả all
    [Tags]        LTHHD                         LTH            ULODA
    [Template]    thhd_lodate_02
    CTKH007       ${dict_product3}    ${list_discount}    ${discount_type}       0              10            all
    CTKH007       ${dict_product4}     ${list_discount}    ${discount_type}       15000           20000         50000

*** Keyword ***
Add du lieu
    [Documentation]    tao DL
    [Arguments]    ${loai_hh}    ${ma_hh}    ${ten_sp}    ${nhom_hang}    ${gia_ban}    ${gia_von}    ${ton}     ${sp_1}   ${sl_1}   ${sp_2}   ${sl_2}    ${dvcb}    ${ma_hh_qd}    ${giaban2}    ${dvqd}    ${giatriqd}
    Wait Until Keyword Succeeds    3x    1s    Delete product if product is visible thr API    ${ma_hh}
    Wait Until Keyword Succeeds    3x    1s    Add product for tracking by product type thr API    ${loai_hh}    ${ma_hh}    ${ten_sp}    ${nhom_hang}    ${gia_ban}    ${gia_von}    ${ton}     ${sp_1}   ${sl_1}   ${sp_2}   ${sl_2}    ${dvcb}    ${ma_hh_qd}    ${giaban2}    ${dvqd}    ${giatriqd}

thhd_lodate_01
    [Arguments]    ${input_ma_kh}    ${dict_product_nums}    ${dict_products_delete}    ${list_ggsp}    ${list_discount_type}    ${input_phi_th}
    ...    ${input_gghd}    ${input_khtt}
    Set Selenium Speed    0.5s
    ${get_id_kh}    ${get_ten_kh}    ${get_dienthoai_kh}    ${get_diachi_kh}    Create new customer and get info    ${input_ma_kh}
    #create hoa don
    ${list_products_delete}    Get Dictionary Keys    ${dict_products_delete}
    ${list_nums_delete}    Get Dictionary Values    ${dict_products_delete}
    ${get_ma_hd}    Add new invoice with lodate product    ${input_ma_kh}    ${dict_product_nums}    ${input_gghd}    ${input_khtt}
    #get data to validate
    ${get_ma_kh_by_hd_bf_ex}    ${get_tong_tien_hang_bf_ex}    ${get_khach_tt_bf_ex}    ${get_giamgia_hd_bf_ex}    ${get_khachcantra_bf_ex}    ${get_trangthai_bf_ex}    Get invoice info incase discount by invoice code
    ...    ${get_ma_hd}
    ${get_list_giavon_delete}    ${get_list_ton_delete}    Get list cost - onhand frm API    ${list_products_delete}
    ${get_no_bf_execute}    ${get_tongban_bf_execute}    ${get_tongban_tru_trahang_bf_execute}    Get Customer Debt from API    ${input_ma_kh}
    #lấy list hàng hóa trong hóa đơn
    ${get_list_hh_in_hd}    Get list product frm Invoice API    ${get_ma_hd}
    #lấy hàng hóa trong đơn trả hàng
    : FOR    ${item_product}    IN    @{list_products_delete}
    \    Remove Values From List    ${get_list_hh_in_hd}    ${item_product}
    Log    ${get_list_hh_in_hd}
    # list ggsp và số lượng hàng hóa trong hóa đơn sau khi remove sản phẩm
    ${get_list_ggsp}    ${get_list_sl_in_hd}    Get list discount and quantity frm invoice api    ${get_ma_hd}    ${get_list_hh_in_hd}
    # Sl hàng hóa /ggsp  > string
    ${get_list_sl_in_hd}    Convert String to List    ${get_list_sl_in_hd}
    ${get_list_ggsp}    Convert String to List    ${get_list_ggsp}
    #thông tin hàng hóa
    ${list_result_thanhtien}    ${list_giavon}    ${list_result_toncuoi}    ${list_result_newprice}    Get list total sale - endingstock - cost - newprice incase discount frm api    ${get_list_hh_in_hd}
    ...    ${get_list_sl_in_hd}    ${list_ggsp}    ${list_discount_type}
    #compute allocation discount (tính chiết khấu phân bổ)
    ${result_gghd}    ${list_result_gghd}    Computation allocation discount of return invoice    ${get_ma_hd}    ${input_gghd}    ${list_result_thanhtien}
    #compute value invoice and customer
    ${result_tongtienhangtra}    ${result_allocate_gghd}    ${result_phi_th}    ${result_cantrakhach}    ${result_khtt}    ${actual_khtt}    Computation total - allocate and pay for customer in case return with invoice code    ${list_result_thanhtien}    ${list_result_gghd}    ${input_phi_th}    ${input_khtt}
    #compute for cong no KH
    ${result_du_no_th_KH}    Minus    ${get_no_bf_execute}    ${result_cantrakhach}
    ${result_PTT_th_KH}    Sum and round 2    ${result_du_no_th_KH}    ${actual_khtt}
    ${result_tongban_tru_TH}    Minus    ${get_tongban_tru_trahang_bf_execute}    ${result_cantrakhach}
    #create return
    Wait Until Keyword Succeeds    3 times    1s    Before Test Ban Hang deactivate print warranty
    Wait Until Keyword Succeeds    3 times    1s    Select Invoice from Ban Hang page    ${get_ma_hd}
    Input number - discount and new price in return invoice    ${get_list_hh_in_hd}    ${get_list_sl_in_hd}    ${list_ggsp}    ${list_discount_type}    ${list_result_newprice}
    Input fee and payment of return     ${input_phi_th}   ${result_phi_th}    ${result_khtt}
    Wait Until Keyword Succeeds    3 times    1s    Run Keyword If    0 <=${get_khach_tt_bf_ex} < ${result_tongtienhangtra} and ${input_khtt} != 0    Close return popup
    ...    ELSE    Log    Ignore click
    Return message success validation
    ${return_code}    Get saved code until success
    Execute Javascript    location.reload();
    #assert value product trong hóa đơn
    Assert list of onhand after order process    ${return_code}    ${get_list_hh_in_hd}    ${get_list_sl_in_hd}    ${list_result_toncuoi}
    #assert value product bị xóa khỏi háo đơn
    Assert list of onhand after order process    ${return_code}    ${list_products_delete}    ${list_nums_delete}    ${get_list_ton_delete}
    #assert value invoice
    Assert invoice info after execute    ${get_ma_hd}    ${get_ma_kh_by_hd_bf_ex}    ${get_tong_tien_hang_bf_ex}    ${get_khachcantra_bf_ex}    ${get_khach_tt_bf_ex}
    ...    ${result_gghd}
    #assert value in return
    Assert values by return code until succeed    ${return_code}    ${result_tongtienhangtra}    ${result_allocate_gghd}    ${result_phi_th}    ${result_cantrakhach}    ${actual_khtt}
    Validate return history by invoice code    ${get_ma_hd}    ${return_code}    ${result_tongtienhangtra}
    #assert customer and so quy
    Assert customer and so quy incase return lodate product with invoice code    ${input_ma_kh}    ${return_code}    ${input_khtt}    ${actual_khtt}    ${result_du_no_th_KH}    ${result_PTT_th_KH}    ${get_tongban_bf_execute}    ${result_tongban_tru_TH}
    Delete return thr API        ${return_code}
    Delete customer    ${get_id_kh}

thhd_lodate_02
    [Arguments]    ${input_ma_kh}    ${dict_product_nums}    ${list_ggsp}    ${list_discount_type}    ${input_phi_th}    ${input_gghd}     ${input_khtt}
    Set Selenium Speed    0.5s
    ${get_id_kh}    ${get_ten_kh}    ${get_dienthoai_kh}    ${get_diachi_kh}    Create new customer and get info    ${input_ma_kh}
    #create hoa don
    ${get_ma_hd}    Add new invoice with lodate product    ${input_ma_kh}    ${dict_product_nums}    ${input_gghd}    ${input_khtt}
    #get data to validate
    ${get_du_no_kh}    Get Du no cuoi KH from API    ${input_ma_kh}
    ${get_list_hh_in_hd}    ${get_list_sl_in_hd}    Get list product and quantity frm invoice API    ${get_ma_hd}
    ${get_list_status_product}    Get list imei status thr API    ${get_list_hh_in_hd}
    ${get_list_sl_in_hd}    Convert String to List    ${get_list_sl_in_hd}
    ${get_ma_kh_by_hd_bf_ex}    ${get_tong_tien_hang_bf_ex}    ${get_khach_tt_bf_ex}    ${get_giamgia_hd_bf_ex}    ${get_khachcantra_bf_ex}    ${get_trangthai_bf_ex}    Get invoice info incase discount by invoice code
    ...    ${get_ma_hd}
    ${list_result_thanhtien}    ${list_giavon}    ${list_result_toncuoi}    ${list_result_newprice}    Get list total sale - endingstock - cost - newprice incase discount frm api    ${get_list_hh_in_hd}
    ...    ${get_list_sl_in_hd}    ${list_ggsp}    ${list_discount_type}
    #compute allocation discount (tính chiết khấu phân bổ)
    ${result_gghd}    ${list_result_gghd}    Computation allocation discount of return invoice    ${get_ma_hd}    ${input_gghd}    ${list_result_thanhtien}
    #compute value invoice and customer
    ${result_tongtienhangtra}    ${result_allocate_gghd}    ${result_phi_th}    ${result_cantrakhach}    ${result_khtt}    ${actual_khtt}    Computation total - allocate and pay for customer in case return with invoice code    ${list_result_thanhtien}    ${list_result_gghd}    ${input_phi_th}    ${input_khtt}
    #create return
    Wait Until Keyword Succeeds    3 times    8 s    Before Test Ban Hang deactivate print warranty
    Select Invoice from Ban Hang page    ${get_ma_hd}
    Input number - discount and new price in return invoice    ${get_list_hh_in_hd}    ${get_list_sl_in_hd}    ${list_ggsp}    ${list_discount_type}     ${list_result_newprice}
    ${lastest_number}    Set Variable    0
    : FOR    ${item_hh}    ${item_soluong}    IN ZIP    ${get_list_hh_in_hd}    ${get_list_sl_in_hd}
    \    ${lastest_number}     Input nums for multi product    ${item_hh}    ${item_soluong}    ${lastest_number}    ${cell_laster_numbers_return}
    Input fee and payment of return     ${input_phi_th}   ${result_phi_th}    ${result_khtt}
    Wait Until Keyword Succeeds    3 times    1s    Run Keyword If    0 <=${get_khach_tt_bf_ex} < ${result_tongtienhangtra} and ${input_khtt} != 0 and ${get_du_no_kh} > 0    Close return popup
    ...    ELSE    Log    Ignore click
    Return message success validation
    ${return_code}    Get saved code after execute
    Execute Javascript    location.reload();
    #assert value product
    ${get_list_hh_in_th_af_execute}    Get list product frm Return API    ${return_code}
    ${list_soluong_in_hd}    ${list_giatriquydoi_in_hd}    Get list quantity and gia tri quy doi with return have multi product    ${get_list_hh_in_th_af_execute}    ${return_code}
    : FOR    ${item_ma_hh}    ${result_toncuoi}    ${item_giavon}    ${get_soluong_in_hd}    ${get_giatri_quydoi}    IN ZIP
    ...    ${get_list_hh_in_th_af_execute}    ${list_result_toncuoi}    ${list_giavon}    ${list_soluong_in_hd}    ${list_giatriquydoi_in_hd}
    \    Run Keyword If    '${get_giatri_quydoi}' == '1'    Validate onhand and cost frm API    ${return_code}    ${item_ma_hh}    ${result_toncuoi}
    \    ...    ${item_giavon}    ${get_soluong_in_hd}
    \    ...    ELSE    Validate onhand and cost frm unit product    ${return_code}    ${item_ma_hh}    ${result_toncuoi}
    \    ...    ${item_giavon}    ${get_soluong_in_hd}    ${get_giatri_quydoi}
    #assert value in invoice
    Assert invoice info after execute    ${get_ma_hd}    ${get_ma_kh_by_hd_bf_ex}    ${get_tong_tien_hang_bf_ex}    ${get_khachcantra_bf_ex}    ${get_khach_tt_bf_ex}
    ...    ${get_giamgia_hd_bf_ex}
    #assert value in return
    #Assert values by return code until succeed    ma_th_kv    input_tongtienhangtra    input_gg_phieutra    input_phi_trahang    input_tongtien_hoadontra    input_datrakhach
    Assert values by return code until succeed    ${return_code}    ${result_tongtienhangtra}    ${result_allocate_gghd}    ${input_phi_th}    ${result_cantrakhach}    ${actual_khtt}
    #Assert values by return code until succeed    ${return_code}    ${result_tongtienhangtra}    ${result_allocate_gghd}    ${result_phi_th}    ${result_cantrakhach}    ${actual_khtt}
    Validate return history by invoice code    ${get_ma_hd}    ${return_code}    ${result_tongtienhangtra}
    Delete return thr API    ${return_code}
    Delete customer    ${get_id_kh}
