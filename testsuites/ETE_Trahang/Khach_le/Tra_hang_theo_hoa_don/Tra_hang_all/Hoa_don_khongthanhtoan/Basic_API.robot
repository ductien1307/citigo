*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    ${headless_browser}
Test Setup
Test Teardown     After Test
Resource          ../../../../../../core/API/api_danhmuc_hanghoa.robot
Resource          ../../../../../../core/API/api_mhbh.robot
Resource          ../../../../../../core/share/toast_message.robot
Resource          ../../../../../../core/API/api_soquy.robot
Resource          ../../../../../../core/share/javascript.robot
Resource          ../../../../../../core/Tra_hang/tra_hang_action.robot
Resource          ../../../../../../core/API/api_trahang.robot
Resource          ../../../../../../core/Tra_hang/tra_hang_page.robot
Resource          ../../../../../../core/Tra_hang/tra_hang_popup_page.robot
Resource          ../../../../../../core/Ban_Hang/banhang_action.robot
Resource          ../../../../../../core/Ban_Hang/banhang_page.robot
Resource          ../../../../../../core/API/api_hoadon_banhang.robot
Resource          ../../../../../../core/share/list_dictionary.robot

*** Variables ***
&{list_productnums}    KLCB011=5    KLDV011=5.5    KLQD011=3    KLSI0011=2    KLT0011=6
&{list_create_imei}    KLSI0011=2
@{list_discount}    20    5000.5    2500    130000    40000.6
@{list_discount_type}    dis    dis    dis    change    change

*** Test Cases ***    Mã KH                  List products and nums    List IMEI    Phí trả hàng    Khách thanh toán    List change              List change type    GGHD    Mã HH combo
Basic                 [Tags]                 THKLA
                      [Template]             ethkl_inv_api_03
                      ${list_productnums}    ${list_create_imei}       10           300000          ${list_discount}    ${list_discount_type}    70000

*** Keywords ***
ethkl_inv_api_03
    [Arguments]    ${dict_product_nums}    ${list_imei}    ${input_phi_th}    ${input_khtt}    ${list_change}    ${list_change_type}
    ...    ${input_gghd}
    #create hoa don
    ${list_product_imei}    Get Dictionary Keys    ${list_imei}
    ${list_nums_imei}    Get Dictionary Values    ${list_imei}
    Create list imei    ${list_product_imei}    ${list_nums_imei}
    ${get_ma_hd}    Add new invoice incase changing price product without customer - no payment    ${dict_product_nums}    ${list_change}    ${list_change_type}    ${input_gghd}
    ${input_product}    ${input_imei_nums}    Convert two list to string and return    ${list_product_imei}    ${list_nums_imei}
    Sleep    20s
    #get data to validate
    ${get_list_hh_in_hd}    ${get_list_sl_in_hd}    Get list product and quantity frm invoice API    ${get_ma_hd}
    ${get_list_sl_in_hd}    Convert String to List    ${get_list_sl_in_hd}
    ${get_ma_kh_by_hd_bf_ex}    ${get_tong_tien_hang_bf_ex}    ${get_khach_tt_bf_ex}    ${get_giamgia_hd_bf_ex}    ${get_khachcantra_bf_ex}    ${get_trangthai_bf_ex}    Get invoice info incase discount by invoice code
    ...    ${get_ma_hd}
    ${get_list_ggsp}    Get list discount by product code    ${get_ma_hd}    ${get_list_hh_in_hd}
    ${list_result_thanhtien}    ${list_giavon}    ${list_result_toncuoi}    Get list total sale - endingstock - cost incase discount    ${get_list_hh_in_hd}    ${get_list_sl_in_hd}    ${get_list_ggsp}
    #compute allocation discount
    ${result_gghd}    Run Keyword If    0 < ${input_gghd} < 100    Convert % discount to VND and round    ${get_tong_tien_hang_bf_ex}    ${input_gghd}
    ...    ELSE    Set Variable    ${input_gghd}
    ${result_tongtienhangtra}    Sum values in list    ${list_result_thanhtien}
    ${result_phi_th}    Run Keyword If    0 < ${input_phi_th} < 100    Convert % discount to VND and round    ${result_tongtienhangtra}    ${input_phi_th}
    ...    ELSE    Set Variable    ${input_phi_th}
    ${result_cantrakhach}    Minusx3 and replace foating point    ${result_tongtienhangtra}    ${result_phi_th}    ${result_gghd}
    ${result_khtt}    Set Variable If    "${input_khtt}" == "all"    ${result_cantrakhach}    ${input_khtt}
    ${actual_khtt}    Set Variable If    "${input_khtt}" == "0"    0    ${result_khtt}
    #create return thr API
    ${return_code}    Add new return without customer to invoice thr API    ${get_ma_hd}    ${get_list_hh_in_hd}    ${get_list_sl_in_hd}    ${result_gghd}    ${input_phi_th}
    ...    ${actual_khtt}
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
