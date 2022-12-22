*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    ${headless_browser}
Resource          ../../../core/API/api_danhmuc_hanghoa.robot
Resource          ../../../core/API/api_dathang.robot
Resource          ../../../core/API/api_khachhang.robot
Resource          ../../../core/API/api_mhbh.robot
Resource          ../../../core/Dat_Hang/dat_hang_action.robot
Resource          ../../../core/Dat_Hang/dat_hang_navigation.robot
Resource          ../../../core/Dat_Hang/dat_hang_page.robot
Resource          ../../../core/share/toast_message.robot
Resource          ../../../core/API/api_soquy.robot
Resource          ../../../core/share/javascript.robot
Resource          ../../../core/share/discount.robot
Resource          ../../../core/API/api_thietlap.robot

*** Variables ***
&{list_create_imei1}    SI028=1
&{list_create_imei2}    SI029=2
&{list_create_imei3}    SI030=1
&{list_product_tk01}    HH0045=2.2    SI028=1    DVT48=3.5    DV052=4    Combo29=5
&{list_product_tk02}    HH0046=1    SI029=2    QD107=3    DV053=1.5    Combo30=2.75
&{list_product_tk03}    HH0047=2    SI030=1    DVT50=1.75    DV054=2.7    Combo31=1.8
&{list_delete_product01}    SI028=1
&{list_delete_product02}    Combo30=2.75    DV053=1.5
@{list_vnd_ggsp}    2000    3000    4000    2500    3000
@{list_%_ggsp}    5    10    15    17   20
@{list_giamoi}    100000    50000.78    300000    7000.88    125000

*** Test Cases ***    Mã KH         List product&nums         List product delete       List imei              GGSP                GGHD    Phí trả hàng      Khách TT    Thu khac    Mã HH combo
Khonghoantra_TH_1thukhac
                      [Tags]        AETTK1
                      [Template]    aettk1
                      CTKH281       ${list_product_tk01}    ${list_delete_product01}   ${list_create_imei1}    ${list_vnd_ggsp}    50000       15           all         TK003        Combo29

Khonghoantra_TH_2thukhac
                      [Tags]        AETTK1
                      [Template]    aettk2
                      CTKH282       ${list_product_tk02}    ${list_delete_product02}    ${list_create_imei2}    ${list_%_ggsp}      30        0             100000         TK007       TK008    Combo30     50000

Hoantra_DH_1thukhac    [Tags]        AETTK1
                      [Template]    aettka1
                      CTKH283       ${list_product_tk03}    ${list_create_imei3}    ${list_giamoi}      25000    0            all    TK005
                      CTKH283       ${list_product_tk03}    ${list_create_imei3}    ${list_giamoi}      25000    100000       0      TK002

Hoantra_DH_2thukhac    [Tags]        AETTK1
                      [Template]    aettka2
                      CTKH284       ${list_product_tk03}    ${list_create_imei3}    ${list_giamoi}      10         10           0          TK005       TK002       all
                      CTKH284       ${list_product_tk03}    ${list_create_imei3}    ${list_giamoi}      5          21000       500000      TK006       TK001      150000

*** Keywords ***
aettk1
    [Arguments]    ${input_ma_kh}    ${dict_product_nums}    ${dict_product_nums_delete}    ${list_imei}    ${list_ggsp}    ${input_gghd}    ${input_phi_th}    ${input_khtt}    ${input_thukhac}
    ...     ${ma_hh_combo}
    #create hoa don
    ${list_product_imei}    Get Dictionary Keys    ${list_imei}
    ${list_nums_imei}    Get Dictionary Values    ${list_imei}
    ${get_ma_hd}    Add new invoice incase discount with multi product - no payment - get invoice code    ${input_ma_kh}    ${dict_product_nums}    ${list_ggsp}    ${input_gghd}    ${ma_hh_combo}
    ${input_product}    ${input_imei_nums}    Convert two list to string and return    ${list_product_imei}    ${list_nums_imei}
    ##Activate surcharge
    ${surcharge_vnd_value}    Get surcharge vnd value    ${input_thukhac}
    ${surcharge_%}    Get surcharge percentage value    ${input_thukhac}
    Run Keyword If    ${surcharge_%} == 0    Toggle surcharge VND    ${input_thukhac}    true
    ...    ELSE    Toggle surcharge percentage    ${input_thukhac}    true
    #get info product, customer
    ${list_products_delete}    Get Dictionary Keys    ${dict_product_nums_delete}
    ${list_nums_delete}    Get Dictionary Values    ${dict_product_nums_delete}
    ${get_ma_kh_by_hd_bf_ex}    ${get_tong_tien_hang_bf_ex}    ${get_khach_tt_bf_ex}    ${get_giamgia_hd_bf_ex}    ${get_khachcantra_bf_ex}    ${get_trangthai_bf_ex}    Get invoice info incase discount by invoice code
    ...    ${get_ma_hd}
    ${get_no_bf_execute}    ${get_tongban_bf_execute}    ${get_tongban_tru_trahang_bf_execute}    Get Customer Debt from API    ${input_ma_kh}
    ${get_list_hh_in_hd}    ${get_list_sl_in_hd}    Get list product and quantity frm invoice API    ${get_ma_hd}
    ${get_list_sl_in_hd}    Convert String to List    ${get_list_sl_in_hd}
    ${get_list_giavon_delete}    ${get_list_ton_delete}    Get list cost - onhand frm API    ${list_products_delete}
    : FOR    ${item_product}    ${item_nums}    IN ZIP    ${list_products_delete}    ${list_nums_delete}
    \    Remove Values From List    ${get_list_hh_in_hd}    ${item_product}
    \    Remove Values From List    ${get_list_sl_in_hd}    ${item_nums}
    Log    ${get_list_hh_in_hd}
    Log    ${get_list_sl_in_hd}
    ${get_list_ggsp}    Get list discount by product code    ${get_ma_hd}    ${get_list_hh_in_hd}
    ${list_result_thanhtien}    ${list_giavon}    ${list_result_toncuoi}    Get list total sale - endingstock - cost incase discount and return of invoice    ${get_list_hh_in_hd}    ${get_list_sl_in_hd}    ${get_list_ggsp}
    Remove Values From List    ${get_list_hh_in_hd}    ${input_product}
    Remove Values From List    ${get_list_sl_in_hd}    ${input_imei_nums}
    #compute allocation discount
    ${result_gghd}    Run Keyword If    0 < ${input_gghd} < 100    Convert % discount to VND and round    ${get_tong_tien_hang_bf_ex}    ${input_gghd}
    ...    ELSE    Set Variable    ${input_gghd}
    ${list_result_gghd}    Create List
    : FOR    ${item_result_thanhtien}    IN    @{list_result_thanhtien}
    \    ${item_gghd}    Run Keyword If    ${input_gghd} > 0    Price after apllocate discount    ${result_gghd}    ${get_tong_tien_hang_bf_ex}
    \    ...    ${item_result_thanhtien}
    \    ...    ELSE    Set Variable    0
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
    ${result_PTT_th_KH}    Sum and replace floating point    ${result_du_no_th_KH}    ${actual_khtt}
    ${result_tongban_tru_TH}    Minus and replace floating point    ${get_tongban_tru_trahang_bf_execute}    ${result_cantrakhach}
    #create return
    ${list_imei}    Get list imei by product code in invoice    ${get_ma_hd}    ${get_list_hh_in_hd}
    Set Test Variable    \${imei_inlist}    ${list_imei}
    #create return thr API
    ${return_code}    Add new return to invoice thr API    ${get_ma_hd}    ${input_ma_kh}    ${get_list_hh_in_hd}    ${get_list_sl_in_hd}    ${result_allocate_gghd}
    ...    ${input_phi_th}    ${actual_khtt}
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
    Run Keyword If    ${surcharge_%} == 0    Toggle surcharge VND    ${input_thukhac}    false
    ...    ELSE    Toggle surcharge percentage    ${input_thukhac}    false

aettk2
    [Arguments]    ${input_ma_kh}    ${dict_product_nums}    ${dict_product_nums_delete}    ${list_imei}    ${list_ggsp}    ${input_gghd}   ${input_phi_th}    ${input_khtt}    ${input_thukhac1}
    ...    ${input_thukhac2}    ${ma_hh_combo}    ${input_khtt_hd}
    #activate surcharge
    ${surcharge_value_1_vnd}    Get surcharge vnd value    ${input_thukhac1}
    ${surcharge_value_1_percentage}    Get surcharge percentage value    ${input_thukhac1}
    ${surcharge_value_2_vnd}    Get surcharge vnd value    ${input_thukhac2}
    ${surcharge_value_2_percentage}    Get surcharge percentage value    ${input_thukhac2}
    ${actual_surcharge1_value}    Set Variable If    ${surcharge_value_1_percentage} == 0    ${surcharge_value_1_vnd}    ${surcharge_value_1_percentage}
    ${actual_surcharge2_value}    Set Variable If    ${surcharge_value_2_percentage} == 0    ${surcharge_value_2_vnd}    ${surcharge_value_2_percentage}
    Run Keyword If    ${actual_surcharge1_value} > 100    Toggle surcharge VND    ${input_thukhac1}    true
    ...    ELSE    Toggle surcharge percentage    ${input_thukhac1}    true
    Run Keyword If    ${actual_surcharge2_value} > 100    Toggle surcharge VND    ${input_thukhac2}    true
    ...    ELSE    Toggle surcharge percentage    ${input_thukhac2}    true
    #get info product, customer
    #create hoa don
    ${list_product_imei}    Get Dictionary Keys    ${list_imei}
    ${list_nums_imei}    Get Dictionary Values    ${list_imei}
    ${get_ma_hd}    Add new invoice incase discount with multi product - get invoice code    ${input_ma_kh}    ${dict_product_nums}    ${list_ggsp}    ${input_gghd}    ${ma_hh_combo}
    ...    ${input_khtt_hd}
    ${input_product}    ${input_imei_nums}    Convert two list to string and return    ${list_product_imei}    ${list_nums_imei}
    #get data to validate
    Sleep    20s
    ${list_products_delete}    Get Dictionary Keys    ${dict_product_nums_delete}
    ${list_nums_delete}    Get Dictionary Values    ${dict_product_nums_delete}
    ${get_ma_kh_by_hd_bf_ex}    ${get_tong_tien_hang_bf_ex}    ${get_khach_tt_bf_ex}    ${get_giamgia_hd_bf_ex}    ${get_khachcantra_bf_ex}    ${get_trangthai_bf_ex}    Get invoice info incase discount by invoice code
    ...    ${get_ma_hd}
    ${get_du_no_kh}    Get Du no cuoi KH from API    ${input_ma_kh}
    ${get_list_hh_in_hd}    ${get_list_sl_in_hd}    Get list product and quantity frm invoice API    ${get_ma_hd}
    ${get_list_sl_in_hd}    Convert String to List    ${get_list_sl_in_hd}
    : FOR    ${item_product}    ${item_nums}    IN ZIP    ${list_products_delete}    ${list_nums_delete}
    \    Remove Values From List    ${get_list_hh_in_hd}    ${item_product}
    \    Remove Values From List    ${get_list_sl_in_hd}    ${item_nums}
    Log    ${get_list_hh_in_hd}
    Log    ${get_list_sl_in_hd}
    ${get_list_ggsp}    Get list discount by product code    ${get_ma_hd}    ${get_list_hh_in_hd}
    ${get_list_giavon_delete}    ${get_list_ton_delete}    Get list cost - onhand frm API    ${list_products_delete}
    ${list_result_thanhtien}    ${list_giavon}    ${list_result_toncuoi}    Get list total sale - endingstock - cost incase discount    ${get_list_hh_in_hd}    ${get_list_sl_in_hd}    ${get_list_ggsp}
    #compute allocation discount
    ${result_gghd}    Run Keyword If    0 < ${input_gghd} < 100    Convert % discount to VND and round    ${get_tong_tien_hang_bf_ex}    ${input_gghd}
    ...    ELSE    Set Variable    ${input_gghd}
    ${list_result_gghd}    Create List
    : FOR    ${item_result_thanhtien}    IN    @{list_result_thanhtien}
    \    ${item_gghd}    Price after apllocate discount    ${result_gghd}    ${get_tong_tien_hang_bf_ex}    ${item_result_thanhtien}
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
    #
    ${list_imei}    Get list imei by product code in invoice    ${get_ma_hd}    ${get_list_hh_in_hd}
    Set Test Variable    \${imei_inlist}    ${list_imei}
    #create return
    ${return_code}    Add new return to invoice thr API    ${get_ma_hd}    ${input_ma_kh}    ${get_list_hh_in_hd}    ${get_list_sl_in_hd}    ${result_allocate_gghd}
    ...    ${input_phi_th}    ${actual_khtt}
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
    #Delete return thr API        ${return_code}
    ## Deactivate surcharge
    Run Keyword If    ${actual_surcharge1_value} > 100    Toggle surcharge VND    ${input_thukhac1}    false
    ...    ELSE    Toggle surcharge percentage    ${input_thukhac1}    false
    Run Keyword If    ${actual_surcharge2_value} > 100    Toggle surcharge VND    ${input_thukhac2}    false
    ...    ELSE    Toggle surcharge percentage    ${input_thukhac2}    false

aettka1
    [Arguments]    ${input_ma_kh}    ${dict_product_nums}   ${list_imei}    ${list_newprice}    ${input_gghd}   ${input_phi_th}    ${input_khtt}    ${input_thukhac}
    #get info product, customer
    ${surcharge_vnd_value}    Get surcharge vnd value    ${input_thukhac}
    ${surcharge_%}    Get surcharge percentage value    ${input_thukhac}
    Run Keyword If    ${surcharge_%} == 0    Toggle surcharge VND    ${input_thukhac}    true
    ...    ELSE    Toggle surcharge percentage    ${input_thukhac}    true
    ${list_product}    Get Dictionary Keys    ${dict_product_nums}
    ${list_nums}    Get Dictionary Values    ${dict_product_nums}
    ${list_product_imei}    Get Dictionary Keys    ${list_imei}
    ${list_nums_imei}    Get Dictionary Values    ${list_imei}
    ${get_ma_hd}    Add new invoice incase newprice with multi product - no payment - surcharge - get invoice code    ${input_ma_kh}    ${dict_product_nums}    ${list_newprice}    ${input_gghd}    ${input_thukhac}   admin     Chi nhánh trung tâm
    ${input_product}    ${input_imei_nums}    Convert two list to string and return    ${list_product_imei}    ${list_nums_imei}
    Sleep    4s
    ${get_list_hh_in_hd}    ${get_list_sl_in_hd}    Get list product and quantity frm invoice API    ${get_ma_hd}
    ${get_list_sl_in_hd}    Convert String to List    ${get_list_sl_in_hd}
    ${get_du_no_kh}    Get Du no cuoi KH from API    ${input_ma_kh}
    ${get_ma_kh_by_hd_bf_ex}    ${get_tong_tien_hang_bf_ex}    ${get_khach_tt_bf_ex}    ${get_giamgia_hd_bf_ex}    ${get_khachcantra_bf_ex}    ${get_trangthai_bf_ex}    Get invoice info incase discount by invoice code
    ...    ${get_ma_hd}
    ${list_result_thanhtien}    ${list_giavon}    ${list_result_toncuoi}    Get list total sale - endingstock - cost incase newprice    ${get_list_hh_in_hd}    ${get_list_sl_in_hd}    ${list_newprice}
    #compute
    ${result_tongtienhangtra}    Sum values in list    ${list_result_thanhtien}
    ${result_gghd}    Run Keyword If    0 < ${input_gghd} < 100    Convert % discount to VND and round    ${get_tong_tien_hang_bf_ex}    ${input_gghd}
    ...    ELSE    Set Variable    ${input_gghd}
    ${result_phi_th}    Run Keyword If    0 < ${input_phi_th} < 100    Convert % discount to VND and round    ${result_tongtienhangtra}    ${input_phi_th}
    ...    ELSE    Set Variable    ${input_phi_th}
    ${result_af_invoice_discount}    Minus and replace floating point    ${result_tongtienhangtra}    ${result_gghd}
    ${actual_surcharge_type}    Set Variable If    ${surcharge_%} == 0    ${surcharge_vnd_value}    ${surcharge_%}
    ${result_per_surchare_by_invoice}   Convert % discount to VND and round    ${result_af_invoice_discount}    ${surcharge_%}
    ${actual_surcharge_value}    Set Variable If    ${surcharge_%} == 0    ${surcharge_vnd_value}    ${result_per_surchare_by_invoice}
    ${result_tientrakhach}    Minus and replace floating point    ${result_af_invoice_discount}    ${result_phi_th}
    ${result_khachcantra}    Sum and replace floating point    ${result_tientrakhach}    ${actual_surcharge_value}
    ${result_khtt}    Set Variable If    "${input_khtt}" == "all"    ${result_khachcantra}    ${input_khtt}
    ${actual_khtt}    Set Variable If    "${input_khtt}" == "0"    0    ${result_khtt}
    #input data into DH form
    ${list_imei}    Get list imei by product code in invoice    ${get_ma_hd}    ${get_list_hh_in_hd}
    Set Test Variable    \${imei_inlist}    ${list_imei}
    #create return
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${get_invoice_id}    Get invoice id    ${get_ma_hd}
    ${jsonpath_id_kh}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_kh}
    ${get_id_kh}    Get data from API    ${endpoint_khachhang}    ${jsonpath_id_kh}
    ${endpoint_danhmuc_hh_co_dvt}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${get_resp_danhmuc_hh}    Get Request and return body    ${endpoint_danhmuc_hh_co_dvt}
    ${get_list_id_invoice_detail}    Get list invoicedetail id frm invoice api    ${get_ma_hd}    ${list_product}
    ${get_id_thukhac}   ${get_thutu_thukhac}    Get Id and order surchage    ${input_thukhac}
    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}    Get list jsonpath product frm list product    ${list_product}
    ${list_giaban}    ${list_result_ggsp}    ${list_id_sp}    Get product info and new price frm list product    ${get_resp_danhmuc_hh}    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}   ${list_newprice}
    #compute surcharge
    ${result_key_surcharge}   Set Variable If   0 < ${surcharge_%} < 100    SurValueRatio     SurValue
    ${result_value_surcharge}   Set Variable If   0 < ${surcharge_%} < 100    ${surcharge_%}     ${surcharge_vnd_value}
    ${result_key}   Set Variable If   0 < ${surcharge_%} < 100    InvoiceSurValueRatio     InvoiceSurValue
    ${phi_trahang}    Set Variable If    0 < ${input_phi_th} < 100    ${input_phi_th}   null
    # Post request BH
    ${liststring_prs_return_detail}    Set Variable    needdel
    Log    ${liststring_prs_return_detail}
    : FOR    ${item_giaban}    ${item_newprice}    ${item_product_id}    ${item_num}    ${item_imei}    ${get_id_invoice_detail}    IN ZIP    ${list_giaban}    ${list_newprice}    ${list_id_sp}    ${list_num}    ${imei_inlist}    ${get_list_id_invoice_detail}
    \    ${item_imei}    Convert list to string and return    ${item_imei}
    \    ${payload_each_product}    Format string    {{"BasePrice":{0},"IsLotSerialControl":true,"Note":"","Price":{1},"ProductId":{2},"Quantity":{3},"SerialNumbers":"{4}","SellPrice":{1},"ProductName":"Máy Hút Bụi Electrolux ZLUX1811 - Tím","CopiedPrice":125000,"InvoiceDetailId":{5},"IsMaster":true,"ProductBatchExpireId":null}}    ${item_giaban}    ${item_newprice}    ${item_product_id}
    \    ...    ${item_num}    ${item_imei}    ${get_id_invoice_detail}
    \    ${liststring_prs_return_detail}    Catenate    SEPARATOR=,    ${liststring_prs_return_detail}    ${payload_each_product}
    ${liststring_prs_return_detail}       Replace String      ${liststring_prs_return_detail}       needdel,       ${EMPTY}      count=1
    ${request_payload}    Format String    {{"Return":{{"BranchId":{0},"RetailerId":{1},"InvoiceId":{2},"CustomerId":{3},"ReceivedById":{4},"ReceivedBy":{{"CreatedBy":0,"CreatedDate":"2018-07-30T08:27:36.800Z","GivenName":"anh.lv","Id":{4},"IsActive":true,"IsAdmin":true,"Type":0,"isDeleted":false,"Name":"anh.lv"}},"SaleChannelId":0,"SaleChannel":null,"Code":"Trả hàng 1","ReturnDiscount":{5},"ReturnFee":{6},"ReturnFeeRatio":{7},"ReturnDetails":[{8}],"InvoiceDetails":[],"InvoiceOrderSurcharges":[{{"SurchargeId":{9},"Price":{10},"Code":"TK005","Name":"Phí giao hàng1","{11}":{12},"{13}":{10}}}],"Payments":[{{"Method":"Cash","MethodStr":"Tiền mặt","Amount":{14},"Id":-1}}],"Status":1,"Surcharge":{10},"Type":3,"Uuid":"","PayingAmount":788904,"TotalBeforeDiscount":0,"ProductDiscount":0,"TotalReturn":871004,"txtPay":"Tiền trả khách","addToAccount":"0","InvoiceComparePurchaseDate":"","ReturnSurcharges":[{{"SurchargeId":{9},"Price":{10},"Code":"TK005","Name":"Phí giao hàng1","{11}":{12},"{13}":{12}}}],"CreatedBy":201567}}}}    ${BRANCH_ID}    ${get_id_nguoitao}    ${get_invoice_id}    ${get_id_kh}
    ...    ${get_id_nguoiban}    ${result_gghd}    ${result_phi_th}    ${phi_trahang}    ${liststring_prs_return_detail}
    ...     ${get_id_thukhac}    ${actual_surcharge_value}    ${result_key_surcharge}    ${result_value_surcharge}    ${result_key}
    ...    ${actual_khtt}
    Log    ${request_payload}
    ${return_code}    Post request to create return and get resp    ${request_payload}
    #get values
    Sleep    20 s    wait for response to API
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
    ${get_tongtienhangtra_af_ex}    ${get_giamgiaphieutra}    ${get_phitrahang_af_ex}    ${get_cantrakhach_af_ex}    ${get_datrakhach_af_ex}    ${get_tongtien_hoadontra_af_ex}    Get return info incase discount by return code    ${return_code}
    Should Be Equal As Numbers    ${get_tongtienhangtra_af_ex}    ${result_tongtienhangtra}
    Should Be Equal As Numbers    ${get_giamgiaphieutra}    ${result_gghd}
    Should Be Equal As Numbers    ${get_phitrahang_af_ex}    ${result_phi_th}
    Should Be Equal As Numbers    ${get_tongtien_hoadontra_af_ex}    ${result_khachcantra}
    Should Be Equal As Numbers    ${get_datrakhach_af_ex}    ${actual_khtt}
    Validate return history by invoice code    ${get_ma_hd}    ${return_code}    ${result_tongtienhangtra}
    Delete return thr API        ${return_code}
    Run Keyword If    ${surcharge_%} == 0    Toggle surcharge VND    ${input_thukhac}    false
    ...    ELSE    Toggle surcharge percentage    ${input_thukhac}    false

aettka2
    [Arguments]    ${input_ma_kh}    ${dict_product_nums}    ${list_imei}    ${list_newprice}    ${input_gghd}    ${input_phi_th}    ${input_khtt}    ${input_thukhac1}
    ...    ${input_thukhac2}    ${input_khtt_hd}
    #activate surcharge
    ${surcharge_value_1_vnd}    Get surcharge vnd value    ${input_thukhac1}
    ${surcharge_value_1_percentage}    Get surcharge percentage value    ${input_thukhac1}
    ${surcharge_value_2_vnd}    Get surcharge vnd value    ${input_thukhac2}
    ${surcharge_value_2_percentage}    Get surcharge percentage value    ${input_thukhac2}
    ${actual_surcharge1_value}    Set Variable If    ${surcharge_value_1_percentage} == 0    ${surcharge_value_1_vnd}    ${surcharge_value_1_percentage}
    ${actual_surcharge2_value}    Set Variable If    ${surcharge_value_2_percentage} == 0    ${surcharge_value_2_vnd}    ${surcharge_value_2_percentage}
    Run Keyword If    ${actual_surcharge1_value} > 100    Toggle surcharge VND    ${input_thukhac1}    true
    ...    ELSE    Toggle surcharge percentage    ${input_thukhac1}    true
    Run Keyword If    ${actual_surcharge2_value} > 100    Toggle surcharge VND    ${input_thukhac2}    true
    ...    ELSE    Toggle surcharge percentage    ${input_thukhac2}    true
    #get info product, customer
    ${list_product}    Get Dictionary Keys    ${dict_product_nums}
    ${list_nums}    Get Dictionary Values    ${dict_product_nums}
    ${list_product_imei}    Get Dictionary Keys    ${list_imei}
    ${list_nums_imei}    Get Dictionary Values    ${list_imei}
    ${get_ma_hd}    Add new invoice incase newprice with multi product - multi surcharge - get invoice code   ${input_ma_kh}    ${dict_product_nums}    ${list_newprice}    ${input_gghd}
    ...    ${input_thukhac1}    ${input_thukhac2}    ${input_khtt_hd}
    ${input_product}    ${input_imei_nums}    Convert two list to string and return    ${list_product_imei}    ${list_nums_imei}
    #get data to validate
    Sleep   5s
    ${get_list_hh_in_hd}    ${get_list_sl_in_hd}    Get list product and quantity frm invoice API    ${get_ma_hd}
    ${get_list_sl_in_hd}    Convert String to List    ${get_list_sl_in_hd}
    ${get_ma_kh_by_hd_bf_ex}    ${get_tong_tien_hang_bf_ex}    ${get_khach_tt_bf_ex}    ${get_giamgia_hd_bf_ex}    ${get_khachcantra_bf_ex}    ${get_trangthai_bf_ex}    Get invoice info incase discount by invoice code
    ...    ${get_ma_hd}
    ${get_du_no_kh}    Get Du no cuoi KH from API    ${input_ma_kh}
    ${list_result_thanhtien}    ${list_giavon}    ${list_result_toncuoi}    Get list total sale - endingstock - cost incase newprice    ${get_list_hh_in_hd}    ${get_list_sl_in_hd}    ${list_newprice}
    #compute
    ${result_tongtienhangtra}    Sum values in list    ${list_result_thanhtien}
    ${result_gghd}    Run Keyword If    0 < ${input_gghd} < 100    Convert % discount to VND and round    ${result_tongtienhangtra}    ${input_gghd}
    ...    ELSE    Set Variable    ${input_gghd}
    ${result_phi_th}    Run Keyword If    0 < ${input_phi_th} < 100    Convert % discount to VND and round    ${result_tongtienhangtra}    ${input_phi_th}
    ...    ELSE    Set Variable    ${input_phi_th}
    ${total_surcharge}=    Run Keyword If    ${actual_surcharge1_value} > 100 and ${actual_surcharge2_value} > 100    Sum    ${actual_surcharge1_value}    ${actual_surcharge2_value}
    ...    ELSE IF    ${actual_surcharge1_value} > 100 and ${actual_surcharge2_value} < 100    VND and Percentage Surcharges sum    ${actual_surcharge2_value}    ${result_tongtienhangtra}    ${actual_surcharge1_value}
    ...    ELSE IF    ${actual_surcharge1_value} < 100 and ${actual_surcharge2_value} < 100    Percentage and Percentage Surcharges sum    ${result_tongtienhangtra}    ${actual_surcharge1_value}    ${actual_surcharge2_value}
    ...    ELSE    Log    abv
    ${result_cantrakhach}    Minusx3 and replace foating point    ${result_tongtienhangtra}    ${result_phi_th}    ${result_gghd}
    ${result_tientrakhach}   Sum and replace floating point    ${result_cantrakhach}    ${total_surcharge}
    ${result_khtt}    Set Variable If    "${input_khtt}" == "all"    ${result_tientrakhach}    ${input_khtt}
    ${actual_khtt}    Set Variable If    "${input_khtt}" == "0"    0    ${result_khtt}
    #create return
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${get_invoice_id}    Get invoice id    ${get_ma_hd}
    ${jsonpath_id_kh}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_kh}
    ${get_id_kh}    Get data from API    ${endpoint_khachhang}    ${jsonpath_id_kh}
    ${endpoint_danhmuc_hh_co_dvt}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${get_resp_danhmuc_hh}    Get Request and return body    ${endpoint_danhmuc_hh_co_dvt}
    ${get_list_id_invoice_detail}    Get list invoicedetail id frm invoice api    ${get_ma_hd}    ${list_product}
    ${get_id_thukhac1}   ${get_thutu_thukhac1}    Get Id and order surchage    ${input_thukhac1}
    ${get_id_thukhac2}   ${get_thutu_thukhac2}    Get Id and order surchage    ${input_thukhac2}
    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}    Get list jsonpath product frm list product    ${list_product}
    ${list_giaban}    ${list_result_ggsp}    ${list_id_sp}    Get product info and new price frm list product    ${get_resp_danhmuc_hh}    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}   ${list_newprice}
    #compute surcharge
    ${result_surcharge1}   Run Keyword If    0 < ${actual_surcharge1_value} < 100       Convert % discount to VND and round    ${result_tongtienhangtra}    ${actual_surcharge1_value}      ELSE    Set Variable    ${actual_surcharge1_value}
    ${result_surcharge2}   Run Keyword If    0 < ${actual_surcharge2_value} < 100       Convert % discount to VND and round    ${result_tongtienhangtra}    ${actual_surcharge2_value}      ELSE    Set Variable    ${actual_surcharge2_value}
    ${result_key_surcharge1}   Set Variable If   0 < ${actual_surcharge1_value} < 100    SurValueRatio     SurValue
    ${result_key1}   Set Variable If   0 < ${actual_surcharge1_value} < 100    InvoiceSurValueRatio     InvoiceSurValue
    ${result_key_surcharge2}   Set Variable If   0 < ${actual_surcharge2_value} < 100    SurValueRatio     SurValue
    ${result_key2}   Set Variable If   0 < ${actual_surcharge2_value} < 100    InvoiceSurValueRatio     InvoiceSurValue
    ${phi_trahang}    Set Variable If    0 < ${input_phi_th} < 100    ${input_phi_th}   null
    # Post request BH
    ${liststring_prs_return_detail}    Set Variable    needdel
    Log    ${liststring_prs_return_detail}
    : FOR    ${item_giaban}    ${item_newprice}    ${item_product_id}    ${item_num}    ${item_imei}    ${get_id_invoice_detail}    IN ZIP    ${list_giaban}    ${list_newprice}    ${list_id_sp}    ${list_num}    ${imei_inlist}    ${get_list_id_invoice_detail}
    \    ${item_imei}    Convert list to string and return    ${item_imei}
    \    ${payload_each_product}    Format string    {{"BasePrice":{0},"IsLotSerialControl":true,"Note":"","Price":{1},"ProductId":{2},"Quantity":{3},"SerialNumbers":"{4}","SellPrice":{1},"ProductName":"Máy Hút Bụi Electrolux ZLUX1811 - Tím","CopiedPrice":125000,"InvoiceDetailId":{5},"IsMaster":true,"ProductBatchExpireId":null}}    ${item_giaban}    ${item_newprice}    ${item_product_id}
    \    ...    ${item_num}    ${item_imei}    ${get_id_invoice_detail}
    \    ${liststring_prs_return_detail}    Catenate    SEPARATOR=,    ${liststring_prs_return_detail}    ${payload_each_product}
    ${liststring_prs_return_detail}       Replace String      ${liststring_prs_return_detail}       needdel,       ${EMPTY}      count=1
    ${request_payload}    Format String    {{"Return":{{"BranchId":{0},"RetailerId":{1},"InvoiceId":{2},"CustomerId":{3},"ReceivedById":{4},"ReceivedBy":{{"CreatedBy":0,"CreatedDate":"2018-07-30T08:27:36.800Z","GivenName":"anh.lv","Id":{4},"IsActive":true,"IsAdmin":true,"Type":0,"isDeleted":false,"Name":"anh.lv"}},"SaleChannelId":0,"SaleChannel":null,"Code":"Trả hàng 1","ReturnDiscount":{5},"ReturnFee":{6},"ReturnFeeRatio":{7},"ReturnDetails":[{8}],"InvoiceDetails":[],"InvoiceOrderSurcharges":[{{"SurchargeId":{9},"Price":{10},"Code":"TK005","Name":"Phí giao hàng1","{11}":{12},"{13}":{12}}},{{"SurchargeId":{14},"Price":{15},"Code":"TK002","Name":"Phí VAT2","{16}":{17},"{18}":{15}}}],"Payments":[{{"Method":"Cash","MethodStr":"Tiền mặt","Amount":{19},"Id":-1}}],"Status":1,"Surcharge":{20},"Type":3,"Uuid":"","PayingAmount":843099,"TotalBeforeDiscount":0,"ProductDiscount":0,"TotalReturn":871004,"txtPay":"Tiền trả khách","addToAccount":"0","InvoiceComparePurchaseDate":"","ReturnSurcharges":[{{"SurchargeId":{9},"Price":{10},"Code":"TK005","Name":"Phí giao hàng1","{11}":{12},"{13}":{12}}},{{"SurchargeId":{14},"Price":{15},"Code":"TK002","Name":"Phí VAT2","{16}":{17},"{18}":{15}}}],"CreatedBy":201567}}}}    ${BRANCH_ID}    ${get_id_nguoitao}    ${get_invoice_id}    ${get_id_kh}   ${get_id_nguoiban}    ${result_gghd}    ${result_phi_th}    ${phi_trahang}    ${liststring_prs_return_detail}
    ...     ${get_id_thukhac1}    ${result_surcharge1}    ${result_key_surcharge1}    ${actual_surcharge1_value}    ${result_key1}
    ...     ${get_id_thukhac2}    ${result_surcharge2}    ${result_key_surcharge2}    ${actual_surcharge2_value}    ${result_key2}
    ...    ${actual_khtt}   ${total_surcharge}
    Log    ${request_payload}
    ${return_code}    Post request to create return and get resp    ${request_payload}
    Sleep    20s    wait for response to API
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
    ${get_tongtienhangtra_af_ex}    ${get_giamgiaphieutra}    ${get_phitrahang_af_ex}    ${get_cantrakhach_af_ex}    ${get_datrakhach_af_ex}    ${get_tongtien_hoadontra_af_ex}    Get return info incase discount by return code    ${return_code}
    Should Be Equal As Numbers    ${get_tongtienhangtra_af_ex}    ${result_tongtienhangtra}
    Should Be Equal As Numbers    ${get_giamgiaphieutra}    ${result_gghd}
    Should Be Equal As Numbers    ${get_phitrahang_af_ex}    ${result_phi_th}
    Should Be Equal As Numbers    ${get_tongtien_hoadontra_af_ex}    ${result_tientrakhach}
    Should Be Equal As Numbers    ${get_datrakhach_af_ex}    ${actual_khtt}
    Validate return history by invoice code    ${get_ma_hd}    ${return_code}    ${result_tongtienhangtra}
    #Delete return thr API        ${return_code}
    ## Deactivate surcharge
    Run Keyword If    ${actual_surcharge1_value} > 100    Toggle surcharge VND    ${input_thukhac1}    false
    ...    ELSE    Toggle surcharge percentage    ${input_thukhac1}    false
    Run Keyword If    ${actual_surcharge2_value} > 100    Toggle surcharge VND    ${input_thukhac2}    false
    ...    ELSE    Toggle surcharge percentage    ${input_thukhac2}    false
