*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    ${headless_browser}
Test Teardown     After Test
Resource          ../../../../core/API/api_danhmuc_hanghoa.robot
Resource          ../../../../core/API/api_khachhang.robot
Resource          ../../../../core/API/api_mhbh.robot
Resource          ../../../../core/share/toast_message.robot
Resource          ../../../../core/API/api_soquy.robot
Resource          ../../../../core/share/javascript.robot
Resource          ../../../../core/Tra_hang/tra_hang_action.robot
Resource          ../../../../core/API/api_trahang.robot
Resource          ../../../../core/Tra_hang/tra_hang_page.robot
Resource          ../../../../core/Tra_hang/tra_hang_popup_page.robot
Resource          ../../../../core/Ban_Hang/banhang_action.robot
Resource          ../../../../core/Ban_Hang/banhang_page.robot

*** Variables ***
&{list_product1}    HH0081=3.75    SI063=2    QD149=1   DV087=1.5    Combo66=3    QDBTT12=3.7
&{list_product2}    HH0082=4.2    SI064=2    DVT83=2    DV088=2.5    Combo67=3
&{list_product3}    HH0083=5.1    SI065=1    QD151=3    DV089=1.75    Combo68=1
&{list_product4}    HH0084=5.1    SI066=1    QD152=3    DV090=1.75    Combo69=1
@{list_delete_product01}    SI063    DV087
@{list_delete_product02}    Combo67    SI064
@{list_discount}    15    0    330000.23    150000.45    5000
@{discount_type}    dis   none    changeup    changedown    disvnd

*** Test Cases ***    Mã KH         List products        List product del             List GGSP        List discount type    Phí trả hàng    GGHD     Khách thanh toán
Lay 1 phan            [Tags]        AETH       ET
                      [Template]    etha1
                      CTKH126       ${list_product1}    ${list_delete_product01}    ${list_discount}    ${discount_type}       50000           10000        all
                      CTKH127       ${list_product2}    ${list_delete_product02}    ${list_discount}    ${discount_type}       0              15        0

Lay all               [Tags]      AETH
                      [Template]    etha2
                      CTKH128       ${list_product3}    ${list_discount}    ${discount_type}       15              10          0            all
                      CTKH129       ${list_product4}    ${list_discount}    ${discount_type}       15000           20000      550000         50000

*** Keywords ***
etha1
    [Arguments]    ${input_ma_kh}    ${dict_product_nums}    ${list_products_delete}    ${list_ggsp}    ${list_discount_type}    ${input_phi_th}
    ...    ${input_gghd}    ${input_khtt}
    Set Selenium Speed    0.5s
    #create hoa don
    ${get_ma_hd}    Add new invoice with multi product    ${input_ma_kh}    ${dict_product_nums}    ${input_gghd}    ${input_khtt}
    #get data to validate
    Sleep   4s
    ${get_ma_kh_by_hd_bf_ex}    ${get_tong_tien_hang_bf_ex}    ${get_khach_tt_bf_ex}    ${get_giamgia_hd_bf_ex}    ${get_khachcantra_bf_ex}    ${get_trangthai_bf_ex}    Get invoice info incase discount by invoice code
    ...    ${get_ma_hd}
    ${get_list_giavon_delete}    ${get_list_ton_delete}    Get list cost - onhand frm API    ${list_products_delete}
    ${get_no_bf_execute}    ${get_tongban_bf_execute}    ${get_tongban_tru_trahang_bf_execute}    Get Customer Debt from API    ${input_ma_kh}
    ${get_list_hh_in_hd}    Get list product frm Invoice API    ${get_ma_hd}
    : FOR    ${item_product}    IN    @{list_products_delete}
    \    Remove Values From List    ${get_list_hh_in_hd}    ${item_product}
    Log    ${get_list_hh_in_hd}
    ${get_list_status_product}    Get list imei status thr API    ${get_list_hh_in_hd}
    ${get_list_ggsp}    ${get_list_sl_in_hd}    Get list discount and quantity frm invoice api    ${get_ma_hd}    ${get_list_hh_in_hd}
    ${get_list_imei_in_hd}    Get list imei by product code in invoice    ${get_ma_hd}    ${get_list_hh_in_hd}
    ${get_list_sl_in_hd}    Convert String to List    ${get_list_sl_in_hd}
    ${get_list_ggsp}    Convert String to List    ${get_list_ggsp}
    ${list_result_thanhtien}    ${list_giavon}    ${list_result_toncuoi}    ${list_result_newprice}    Get list total sale - endingstock - cost - newprice incase discount frm api    ${get_list_hh_in_hd}
    ...    ${get_list_sl_in_hd}    ${list_ggsp}    ${list_discount_type}
    #compute allocation discount
    ${result_gghd}    Run Keyword If    0 < ${input_gghd} < 100    Convert % discount to VND and round    ${get_tong_tien_hang_bf_ex}    ${input_gghd}
    ...    ELSE    Set Variable    ${input_gghd}
    ${list_result_gghd}    Create List
    : FOR    ${item_result_thanhtien}    IN    @{list_result_thanhtien}
    \    ${item_gghd}    Run Keyword If    ${input_gghd} > 0    Price after apllocate discount    ${result_gghd}    ${get_tong_tien_hang_bf_ex}
    \    ...    ${item_result_thanhtien}    ELSE    Set Variable    0
    \    Append To List    ${list_result_gghd}    ${item_gghd}
    Log    ${list_result_gghd}
    #compute value invoice and customer
    ${result_tongtienhangtra}    Sum values in list    ${list_result_thanhtien}
    ${result_allocate_gghd}    Sum values in list and round    ${list_result_gghd}
    ${result_phi_th}    Run Keyword If    0 < ${input_phi_th} < 100    Convert % discount to VND and round    ${result_tongtienhangtra}    ${input_phi_th}
    ...    ELSE    Set Variable    ${input_phi_th}
    ${result_cantrakhach}    Minusx3 and replace foating point    ${result_tongtienhangtra}    ${result_phi_th}    ${result_allocate_gghd}
    ${result_khtt}    Set Variable If    "${input_khtt}" == "all"    ${result_cantrakhach}    ${input_khtt}
    ${actual_khtt}    Set Variable If    "${input_khtt}" == "0"    0    ${result_khtt}
    #compute for cong no KH
    ${result_du_no_th_KH}    Minus    ${get_no_bf_execute}    ${result_cantrakhach}
    ${result_PTT_th_KH}    Sum and round 2    ${result_du_no_th_KH}    ${actual_khtt}
    ${result_tongban_tru_TH}    Minus    ${get_tongban_tru_trahang_bf_execute}    ${result_cantrakhach}
    #create return thr API
    ${return_code}    Add new return to invoice incase discount    ${get_ma_hd}    ${input_ma_kh}    ${get_list_hh_in_hd}    ${get_list_sl_in_hd}    ${list_ggsp}    ${list_discount_type}
    ...    ${result_allocate_gghd}    ${input_phi_th}    ${actual_khtt}
    Sleep    10s    wait for response to API
    #assert value product
    ${get_list_hh_in_th_af_execute}    Get list product frm Return API    ${return_code}
    ${list_soluong_in_hd}    ${list_giatriquydoi_in_hd}    Get list quantity and gia tri quy doi with return have multi product    ${get_list_hh_in_th_af_execute}    ${return_code}
    : FOR    ${item_ma_hh}    ${result_toncuoi}    ${item_giavon}    ${get_soluong_in_hd}    ${get_giatri_quydoi}    IN ZIP
    ...    ${get_list_hh_in_th_af_execute}    ${list_result_toncuoi}    ${list_giavon}    ${list_soluong_in_hd}    ${list_giatriquydoi_in_hd}
    \    Run Keyword If    '${get_giatri_quydoi}' == '1'    Validate onhand and cost frm API    ${return_code}    ${item_ma_hh}    ${result_toncuoi}
    \    ...    ${item_giavon}    ${get_soluong_in_hd}
    \    ...    ELSE    Validate onhand and cost frm unit product    ${return_code}    ${item_ma_hh}    ${result_toncuoi}
    \    ...    ${item_giavon}    ${get_soluong_in_hd}    ${get_giatri_quydoi}
    #assert value delete product
    ${get_list_giavon_delete_af_ex}    ${get_list_ton_delete_af_ex}    ${list_giatri_quydoi}    Get list gia von - ton kho - gia tri quy doi    ${list_products_delete}
    : FOR    ${item_ma_hh_delete}    ${giavon_delete_af_ex}    ${ton_delete_af_ex}    ${item_giavon_delete}    ${toncuoi_delete}    ${get_giatri_quydoi}
    ...    IN ZIP    ${list_products_delete}    ${get_list_giavon_delete_af_ex}    ${get_list_ton_delete_af_ex}    ${get_list_giavon_delete}    ${get_list_ton_delete}
    ...    ${list_giatri_quydoi}
    \    Run Keyword If    '${get_giatri_quydoi}' == '1'    Assert value cost and onhand in Stock Card    ${giavon_delete_af_ex}    ${ton_delete_af_ex}    ${item_giavon_delete}
    \    ...    ${toncuoi_delete}
    \    ...    ELSE    Assert value cost and onhand in unit Stock Card    ${item_ma_hh_delete}    ${item_giavon_delete}    ${toncuoi_delete}
    #assert value in invoice
    ${get_ma_kh_by_hd_af_ex}    ${get_tong_tien_hang_af_ex}    ${get_khach_tt_af_ex}    ${get_giamgia_hd_af_ex}    ${get_khachcantra_af_ex}    ${get_trangthai_af_ex}    Get invoice info incase discount by invoice code
    ...    ${get_ma_hd}
    Should Be Equal As Numbers    ${get_tong_tien_hang_af_ex}    ${get_tong_tien_hang_bf_ex}
    Should Be Equal As Numbers    ${get_khach_tt_af_ex}    ${get_khach_tt_bf_ex}
    Should Be Equal As Numbers    ${get_giamgia_hd_af_ex}    ${get_giamgia_hd_bf_ex}
    Should Be Equal As Numbers    ${get_khachcantra_af_ex}    ${get_khachcantra_bf_ex}
    Should Be Equal As Strings    ${get_ma_kh_by_hd_af_ex}    ${get_ma_kh_by_hd_bf_ex}
    Should Be Equal As Strings    ${get_trangthai_af_ex}    ${get_trangthai_bf_ex}
    #assert value in return
    ${get_tongtienhangtra_af_ex}    ${get_giamgiaphieutra}    ${get_phitrahang_af_ex}    ${get_cantrakhach_af_ex}    ${get_datrakhach_af_ex}    ${get_tongtien_hoadontra_af_ex}    Get return info incase discount by return code
    ...    ${return_code}
    Should Be Equal As Numbers    ${get_tongtienhangtra_af_ex}    ${result_tongtienhangtra}
    Should Be Equal As Numbers    ${get_giamgiaphieutra}    ${result_allocate_gghd}
    Should Be Equal As Numbers    ${get_phitrahang_af_ex}    ${result_phi_th}
    Should Be Equal As Numbers    ${get_tongtien_hoadontra_af_ex}    ${result_cantrakhach}
    Should Be Equal As Numbers    ${get_datrakhach_af_ex}    ${actual_khtt}
    Validate return history by invoice code    ${get_ma_hd}    ${return_code}    ${result_tongtienhangtra}
    #assert customer and so quy
    ${get_no_af_execute_kh}    ${get_tongban_af_execute_kh}    ${get_tongban_tru_trahang_af_execute_kh}    Get Customer Debt from API after purchase    ${input_ma_kh}    ${return_code}    ${actual_khtt}
    ${get_maphieu_soquy}    Get Ma Phieu Thu in So quy    ${return_code}
    Run Keyword If    '${input_khtt}' == '0'    Should Be Equal As Numbers    ${get_no_af_execute_kh}    ${result_du_no_th_KH}
    ...    ELSE    Should Be Equal As Numbers    ${get_no_af_execute_kh}    ${result_PTT_th_KH}
    Should Be Equal As Numbers    ${get_tongban_af_execute_kh}    ${get_tongban_bf_execute}
    Should Be Equal As Numbers    ${get_tongban_tru_trahang_af_execute_kh}    ${result_tongban_tru_TH}
    Run Keyword If    '${input_khtt}' == '0'    Validate customer history and debt if return is not paid    ${input_ma_kh}    ${return_code}    ${result_du_no_th_KH}
    ...    ELSE    Validate customer history and debt if return is paid    ${input_ma_kh}    ${return_code}    ${result_du_no_th_KH}    ${result_PTT_th_KH}
    Run Keyword If    '${input_khtt}' == '0'    Validate So quy info from Rest API if Invoice is not paid    ${get_maphieu_soquy}
    ...    ELSE    Validate So quy info from Rest API if Invoice is paid    ${get_maphieu_soquy}    ${actual_khtt}
    Delete return thr API    ${return_code}

etha2
    [Arguments]    ${input_ma_kh}    ${dict_product_nums}    ${list_ggsp}    ${list_discount_type}    ${input_phi_th}    ${input_gghd}    ${input_khtt_tocreate}     ${input_khtt}
    Set Selenium Speed    0.5s
    #create hoa don
    ${get_ma_hd}    Add new invoice incase discount - return code    ${input_ma_kh}    ${dict_product_nums}    ${list_ggsp}    ${list_discount_type}    ${input_gghd}    ${input_khtt_tocreate}
    #get data to validate
    Sleep   4s
    ${get_du_no_kh}    Get Du no cuoi KH from API    ${input_ma_kh}
    ${get_list_hh_in_hd}    ${get_list_sl_in_hd}    Get list product and quantity frm invoice API    ${get_ma_hd}
    ${get_list_status_product}    Get list imei status thr API    ${get_list_hh_in_hd}
    ${get_list_sl_in_hd}    Convert String to List    ${get_list_sl_in_hd}
    ${get_ma_kh_by_hd_bf_ex}    ${get_tong_tien_hang_bf_ex}    ${get_khach_tt_bf_ex}    ${get_giamgia_hd_bf_ex}    ${get_khachcantra_bf_ex}    ${get_trangthai_bf_ex}    Get invoice info incase discount by invoice code
    ...    ${get_ma_hd}
    ${list_result_thanhtien}    ${list_giavon}    ${list_result_toncuoi}    ${list_result_newprice}    Get list total sale - endingstock - cost - newprice incase discount frm api    ${get_list_hh_in_hd}
    ...    ${get_list_sl_in_hd}    ${list_ggsp}    ${list_discount_type}
    #compute allocation discount
    ${result_gghd}    Run Keyword If    0 < ${input_gghd} < 100    Convert % discount to VND and round    ${get_tong_tien_hang_bf_ex}    ${input_gghd}
    ...    ELSE    Set Variable    ${input_gghd}
    ${result_tongtienhangtra}    Sum values in list    ${list_result_thanhtien}
    ${result_phi_th}    Run Keyword If    0 < ${input_phi_th} < 100    Convert % discount to VND and round    ${result_tongtienhangtra}    ${input_phi_th}
    ...    ELSE    Set Variable    ${input_phi_th}
    ${result_cantrakhach}    Minusx3 and replace foating point    ${result_tongtienhangtra}    ${result_phi_th}    ${result_gghd}
    ${result_khtt}    Set Variable If    "${input_khtt}" == "all"    ${result_cantrakhach}    ${input_khtt}
    ${actual_khtt}    Set Variable If    "${input_khtt}" == "0"    0    ${result_khtt}
    #create return
    ${return_code}    Add new return to invoice thr API    ${get_ma_hd}    ${input_ma_kh}    ${get_list_hh_in_hd}    ${get_list_sl_in_hd}
    ...    ${input_gghd}    ${input_phi_th}    ${actual_khtt}
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
    ${get_ma_kh_by_hd_af_ex}    ${get_tong_tien_hang_af_ex}    ${get_khach_tt_af_ex}    ${get_giamgia_hd_af_ex}    ${get_khachcantra_af_ex}    ${get_trangthai_af_ex}    Get invoice info incase discount by invoice code
    ...    ${get_ma_hd}
    Should Be Equal As Numbers    ${get_tong_tien_hang_af_ex}    ${get_tong_tien_hang_bf_ex}
    Should Be Equal As Numbers    ${get_khach_tt_af_ex}    ${get_khach_tt_bf_ex}
    Should Be Equal As Numbers    ${get_giamgia_hd_af_ex}    ${get_giamgia_hd_bf_ex}
    Should Be Equal As Numbers    ${get_khachcantra_af_ex}    ${get_khachcantra_bf_ex}
    Should Be Equal As Strings    ${get_ma_kh_by_hd_af_ex}    ${get_ma_kh_by_hd_bf_ex}
    Should Be Equal As Strings    ${get_trangthai_af_ex}    ${get_trangthai_bf_ex}
    #assert value in return
    ${get_tongtienhangtra_af_ex}    ${get_giamgiaphieutra}    ${get_phitrahang_af_ex}    ${get_cantrakhach_af_ex}    ${get_datrakhach_af_ex}    ${get_tongtien_hoadontra_af_ex}    Get return info incase discount by return code
    ...    ${return_code}
    Should Be Equal As Numbers    ${get_tongtienhangtra_af_ex}    ${result_tongtienhangtra}
    Should Be Equal As Numbers    ${get_giamgiaphieutra}    ${result_gghd}
    Should Be Equal As Numbers    ${get_phitrahang_af_ex}    ${result_phi_th}
    Should Be Equal As Numbers    ${get_tongtien_hoadontra_af_ex}    ${result_cantrakhach}
    Should Be Equal As Numbers    ${get_datrakhach_af_ex}    ${actual_khtt}
    Validate return history by invoice code    ${get_ma_hd}    ${return_code}    ${result_tongtienhangtra}
    Delete return thr API    ${return_code}
