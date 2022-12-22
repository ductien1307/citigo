*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    ${headless_browser}
Test Setup        Before Test Ban Hang deactivate print warranty
Test Teardown     After Test
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
                      [Tags]        ETTK
                      [Template]    ettk3
                      CTKH070       ${list_product_tk01}    ${list_delete_product01}   ${list_create_imei1}    ${list_vnd_ggsp}    50000       15           all         TK003        Combo29

Khonghoantra_TH_2thukhac
                      [Tags]        ETTK
                      [Template]    ettk4
                      CTKH071       ${list_product_tk02}    ${list_delete_product02}    ${list_create_imei2}    ${list_%_ggsp}      30        0             100000         TK007       TK008    Combo30     50000

Hoantra_DH_1thukhac    [Tags]        ETTK
                      [Template]    ettka3
                      CTKH072       ${list_product_tk03}    ${list_create_imei3}    ${list_giamoi}      25000    0            all    TK005

Hoantra_DH_1thukhac    [Tags]        ETTK
                      [Template]    ettka3
                      CTKH073       ${list_product_tk03}    ${list_create_imei3}    ${list_giamoi}      25000    100000       0      TK002

Hoantra_DH_2thukhac    [Tags]        ETTK
                      [Template]    ettka4
                      CTKH074       ${list_product_tk03}    ${list_create_imei3}    ${list_giamoi}      10    10           0          TK005       TK002       100000

Hoantra_DH_2thukhac    [Tags]        ETTK2
                      [Template]    ettka4
                      CTKH076       ${list_product_tk03}    ${list_create_imei3}    ${list_giamoi}      5     21000       20000       TK001       TK002      150000

*** Keywords ***
ettk3
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
    Reload Page
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
    Select Invoice from Ban Hang page    ${get_ma_hd}
    ${laster_number}    Set Variable    0
    : FOR    ${item_hh}    ${item_soluong}    IN ZIP    ${get_list_hh_in_hd}    ${get_list_sl_in_hd}
    \    ${laster_number}    Input nums for multi product    ${item_hh}    ${item_soluong}    ${laster_number}    ${cell_laster_numbers_return}
    Wait Until Keyword Succeeds    3 times    8 s    Run keyword if    0 < ${input_phi_th} < 100    Input % return free value    ${input_phi_th}
    ...    ${result_phi_th}
    ...    ELSE    Input VND return free value    ${input_phi_th}
    Wait Until Keyword Succeeds    3 times    8 s    Input payment into any form    ${textbox_th_khachttTraHang}    ${result_khtt}    ${button_th}
    Wait Until Keyword Succeeds    3 times    8 s    Run Keyword If    0 <=${get_khach_tt_bf_ex} < ${result_tongtienhangtra} and ${input_khtt} != 0 and ${get_no_bf_execute} > 0    Close return popup
    ...    ELSE    Log    Ignore click
    Sleep    10s
    ${return_code}    Get saved code after execute
    Execute Javascript    location.reload();
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
    ${get_tongtienhangtra_af_ex}    ${get_giamgiaphieutra}    ${get_phitrahang_af_ex}    ${get_cantrakhach_af_ex}    ${get_datrakhach_af_ex}    ${get_tongtien_hoadontra_af_ex}    Get return info incase discount by return code    ${return_code}
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
    Delete return thr API        ${return_code}
    Run Keyword If    ${surcharge_%} == 0    Toggle surcharge VND    ${input_thukhac}    false
    ...    ELSE    Toggle surcharge percentage    ${input_thukhac}    false

ettk4
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
    Reload Page
    #get info product, customer
    ${list_product_imei}    Get Dictionary Keys    ${list_imei}
    ${list_nums_imei}    Get Dictionary Values    ${list_imei}
    ${get_ma_hd}    Add new invoice incase discount with multi product - get invoice code    ${input_ma_kh}    ${dict_product_nums}    ${list_ggsp}   ${input_gghd}
    ...    ${ma_hh_combo}    ${input_khtt_hd}
    ${input_product}    ${input_imei_nums}    Convert two list to string and return    ${list_product_imei}    ${list_nums_imei}
    #get data to validate
    Sleep   2s
    ${list_products_delete}    Get Dictionary Keys    ${dict_product_nums_delete}
    ${list_nums_delete}    Get Dictionary Values    ${dict_product_nums_delete}
    ${get_ma_kh_by_hd_bf_ex}    ${get_tong_tien_hang_bf_ex}    ${get_khach_tt_bf_ex}    ${get_giamgia_hd_bf_ex}    ${get_khachcantra_bf_ex}    ${get_trangthai_bf_ex}    Get invoice info incase discount by invoice code
    ...    ${get_ma_hd}
    ${get_du_no_kh}   Get Du no cuoi KH from API    ${input_ma_kh}
    ${get_list_hh_in_hd}    ${get_list_sl_in_hd}    Get list product and quantity frm invoice API    ${get_ma_hd}
    ${get_list_sl_in_hd}    Convert String to List    ${get_list_sl_in_hd}
    :FOR    ${item_product}    ${item_nums}    IN ZIP    ${list_products_delete}    ${list_nums_delete}
    \    Remove Values From List    ${get_list_hh_in_hd}    ${item_product}
    \    Remove Values From List    ${get_list_sl_in_hd}    ${item_nums}
    ${get_list_ggsp}    Get list discount by product code    ${get_ma_hd}    ${get_list_hh_in_hd}
    ${get_list_giavon_delete}    ${get_list_ton_delete}    Get list cost - onhand frm API    ${list_products_delete}
    ${list_result_thanhtien}    ${list_giavon}    ${list_result_toncuoi}    Get list total sale - endingstock - cost incase discount    ${get_list_hh_in_hd}    ${get_list_sl_in_hd}    ${get_list_ggsp}
    Remove Values From List    ${get_list_hh_in_hd}    ${input_product}
    Remove Values From List    ${get_list_sl_in_hd}    ${input_imei_nums}
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
    #create return
    Select Invoice from Ban Hang page    ${get_ma_hd}
    :FOR    ${item_imei}    IN    @{imei_inlist}
    \    Run Keyword If    "${item_imei}" == "${EMPTY}"      Log     Ignore    ELSE    Wait Until Keyword Succeeds    3 times    8 s    Input imei incase multi product to any form    ${input_product}    ${texbox_imei_search_multi_product}
    \    ...    ${item_serial_in_dropdown}    ${cell_imei_multi_product}    @{item_imei}
    ${laster_number}    Set Variable    0
    : FOR    ${item_hh}    ${item_soluong}    IN ZIP    ${get_list_hh_in_hd}    ${get_list_sl_in_hd}
    \    ${laster_number}    Wait Until Keyword Succeeds    3 times    8 s    Input nums for multi product    ${item_hh}    ${item_soluong}    ${laster_number}    ${cell_laster_numbers_return}
    Wait Until Keyword Succeeds    3 times    8 s    Run keyword if    0 < ${input_phi_th} < 100    Input % return free value    ${input_phi_th}
    ...    ${result_phi_th}
    ...    ELSE    Input VND return free value    ${input_phi_th}
    Wait Until Keyword Succeeds    3 times    8 s    Input payment into any form    ${textbox_th_khachttTraHang}    ${result_khtt}    ${button_th}
    Wait Until Keyword Succeeds    3 times    8 s    Run Keyword If    0 <=${get_khach_tt_bf_ex} < ${result_tongtienhangtra} and ${input_khtt} != 0 and ${get_du_no_kh} > 0    Close return popup
    ...    ELSE    Log    Ignore click
    Sleep    10s
    ${return_code}    Get saved code after execute
    Execute Javascript    location.reload();
    Sleep    5 s    wait for response to API
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
    ${get_tongtienhangtra_af_ex}    ${get_giamgiaphieutra}    ${get_phitrahang_af_ex}    ${get_cantrakhach_af_ex}    ${get_datrakhach_af_ex}    ${get_tongtien_hoadontra_af_ex}    Get return info incase discount by return code    ${return_code}
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

ettka3
    [Arguments]    ${input_ma_kh}    ${dict_product_nums}   ${list_imei}    ${list_newprice}    ${input_gghd}   ${input_phi_th}    ${input_khtt}    ${input_thukhac}
    #get info product, customer
    ${surcharge_vnd_value}    Get surcharge vnd value    ${input_thukhac}
    ${surcharge_%}    Get surcharge percentage value    ${input_thukhac}
    Run Keyword If    ${surcharge_%} == 0    Toggle surcharge VND    ${input_thukhac}    true
    ...    ELSE    Toggle surcharge percentage    ${input_thukhac}    true
    ${list_product}    Get Dictionary Keys    ${dict_product_nums}
    ${list_nums}    Get Dictionary Values    ${dict_product_nums}
    Reload page
    ${list_product_imei}    Get Dictionary Keys    ${list_imei}
    ${list_nums_imei}    Get Dictionary Values    ${list_imei}
    ${get_ma_hd}    Add new invoice incase newprice with multi product - no payment - surcharge - get invoice code    ${input_ma_kh}    ${dict_product_nums}    ${list_newprice}    ${input_gghd}    ${input_thukhac}   admin   Chi nhánh trung tâm
    ${input_product}    ${input_imei_nums}    Convert two list to string and return    ${list_product_imei}    ${list_nums_imei}
    Sleep    4s
    ${get_list_hh_in_hd}    ${get_list_sl_in_hd}    Get list product and quantity frm invoice API    ${get_ma_hd}
    ${get_list_sl_in_hd}    Convert String to List    ${get_list_sl_in_hd}
    ${get_du_no_kh}    Get Du no cuoi KH from API    ${input_ma_kh}
    ${get_ma_kh_by_hd_bf_ex}    ${get_tong_tien_hang_bf_ex}    ${get_khach_tt_bf_ex}    ${get_giamgia_hd_bf_ex}    ${get_khachcantra_bf_ex}    ${get_trangthai_bf_ex}    Get invoice info incase discount by invoice code
    ...    ${get_ma_hd}
    ${list_result_thanhtien}    ${list_giavon}    ${list_result_toncuoi}    Get list total sale - endingstock - cost incase newprice    ${get_list_hh_in_hd}    ${get_list_sl_in_hd}    ${list_newprice}
    Remove Values From List    ${get_list_hh_in_hd}    ${input_product}
    Remove Values From List    ${get_list_sl_in_hd}    ${input_imei_nums}
    #compute
    ${result_tongtienhangtra}    Sum values in list    ${list_result_thanhtien}
    ${result_gghd}    Run Keyword If    0 < ${input_gghd} < 100    Convert % discount to VND and round    ${get_tong_tien_hang_bf_ex}    ${input_gghd}
    ...    ELSE    Set Variable    ${input_gghd}
    ${result_phi_th}    Run Keyword If    0 < ${input_phi_th} < 100    Convert % discount to VND and round    ${result_tongtienhangtra}    ${input_phi_th}
    ...    ELSE    Set Variable    ${input_phi_th}
    ${result_af_invoice_discount}    Minus and replace floating point    ${result_tongtienhangtra}    ${result_gghd}
    ${actual_surcharge_type}    Set Variable If    ${surcharge_%} == 0    ${surcharge_vnd_value}    ${surcharge_%}
    ${result_per_surchare_by_invoice}    Convert % discount to VND and round    ${result_af_invoice_discount}    ${surcharge_%}
    ${actual_surcharge_value}    Set Variable If    ${surcharge_%} == 0    ${surcharge_vnd_value}    ${result_per_surchare_by_invoice}
    ${result_tientrakhach}    Minus and replace floating point    ${result_af_invoice_discount}    ${result_phi_th}
    ${result_khachcantra}    Sum and replace floating point    ${result_tientrakhach}    ${actual_surcharge_value}
    ${result_khtt}    Set Variable If    "${input_khtt}" == "all"    ${result_khachcantra}    ${input_khtt}
    ${actual_khtt}    Set Variable If    "${input_khtt}" == "0"    0    ${result_khtt}
    #input data into DH form
    Select Invoice from Ban Hang page    ${get_ma_hd}
    : FOR    ${item_imei}    IN    @{imei_inlist}
    \    Run Keyword If    "${item_imei}" == "${EMPTY}"      Log     Ignore    ELSE    Wait Until Keyword Succeeds    3 times    8 s    Input imei incase multi product to any form    ${input_product}    ${texbox_imei_search_multi_product}
    \    ...    ${item_serial_in_dropdown}    ${cell_imei_multi_product}    @{item_imei}
    ${lastest_number}    Set Variable    0
    : FOR    ${item_hh}    ${item_soluong}    IN ZIP    ${get_list_hh_in_hd}    ${get_list_sl_in_hd}
    \    ${lastest_number}    Wait Until Keyword Succeeds    3 times    8s    Input nums for multi product    ${item_hh}    ${item_soluong}    ${lastest_number}    ${cell_laster_numbers_return}
    Wait Until Keyword Succeeds    3 times    8 s    Run keyword if    0 < ${input_phi_th} < 100    Input % return free value    ${input_phi_th}
    ...    ${result_phi_th}    ELSE    Input VND return free value    ${input_phi_th}
    Wait Until Keyword Succeeds    3 times    8 s    Input payment into any form    ${textbox_th_khachttTraHang}    ${result_khtt}    ${button_th}
    Wait Until Keyword Succeeds    3 times    8 s    Run Keyword If    0 <=${get_khach_tt_bf_ex} < ${result_tongtienhangtra} and ${input_khtt} != 0 and ${get_du_no_kh} > 0    Close return popup
    ...    ELSE    Log    Ignore click
    Sleep   5s
    ${return_code}    Get saved code after execute
    Execute Javascript    location.reload();
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

ettka4
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
    Reload Page
    #get info product, customer
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
    Remove Values From List    ${get_list_hh_in_hd}    ${input_product}
    Remove Values From List    ${get_list_sl_in_hd}    ${input_imei_nums}
    #compute
    ${result_tongtienhangtra}    Sum values in list    ${list_result_thanhtien}
    ${result_gghd}    Run Keyword If    0 < ${input_gghd} < 100    Convert % discount to VND and round    ${result_tongtienhangtra}    ${input_gghd}
    ...    ELSE    Set Variable    ${input_gghd}
    ${result_phi_th}    Run Keyword If    0 < ${input_phi_th} < 100    Convert % discount to VND and round    ${result_tongtienhangtra}    ${input_phi_th}
    ...    ELSE    Set Variable    ${input_phi_th}
    ${result_af_invoice_discount}    Price after % discount invoice    ${result_tongtienhangtra}    ${input_gghd}
    ${total_surcharge}=    Run Keyword If    ${actual_surcharge1_value} > 100 and ${actual_surcharge2_value} > 100    Sum    ${actual_surcharge1_value}    ${actual_surcharge2_value}
    ...    ELSE IF    ${actual_surcharge1_value} > 100 and ${actual_surcharge2_value} < 100    VND and Percentage Surcharges sum    ${actual_surcharge2_value}    ${result_af_invoice_discount}    ${actual_surcharge1_value}
    ...    ELSE IF    ${actual_surcharge1_value} < 100 and ${actual_surcharge2_value} < 100    Percentage and Percentage Surcharges sum    ${result_af_invoice_discount}    ${actual_surcharge1_value}    ${actual_surcharge2_value}
    ...    ELSE    Log    abv
    ${result_cantrakhach}    Minusx3 and replace foating point    ${result_tongtienhangtra}    ${result_phi_th}    ${result_gghd}
    ${result_tientrakhach}   Sum and replace floating point    ${result_cantrakhach}    ${total_surcharge}
    ${result_khtt}    Set Variable If    "${input_khtt}" == "all"    ${result_tientrakhach}    ${input_khtt}
    ${actual_khtt}    Set Variable If    "${input_khtt}" == "0"    0    ${result_khtt}
    #input data into DH form
    Select Invoice from Ban Hang page    ${get_ma_hd}
    ${laster_number}    Set Variable    0
    : FOR    ${item_hh}    ${item_soluong}    IN ZIP    ${get_list_hh_in_hd}    ${get_list_sl_in_hd}
    \    ${laster_number}    Input nums for multi product    ${item_hh}    ${item_soluong}    ${laster_number}    ${cell_laster_numbers_return}
    : FOR    ${item_imei}    IN    @{imei_inlist}
    \    Run Keyword If    "${item_imei}" == "${EMPTY}"      Log     Ignore    ELSE    Wait Until Keyword Succeeds    3 times    8 s    Input imei incase multi product to any form    ${input_product}    ${texbox_imei_search_multi_product}
    \    ...    ${item_serial_in_dropdown}    ${cell_imei_multi_product}    @{item_imei}
    Wait Until Keyword Succeeds    3 times    8 s    Run keyword if    0 < ${input_phi_th} < 100    Input % return free value    ${input_phi_th}
    ...    ${result_phi_th}
    ...    ELSE    Input VND return free value    ${input_phi_th}
    Wait Until Keyword Succeeds    3 times    8 s    Input payment into any form    ${textbox_th_khachttTraHang}    ${actual_khtt}    ${button_th}
    Wait Until Keyword Succeeds    3 times    8 s    Run Keyword If    0 <=${get_khach_tt_bf_ex} < ${result_tongtienhangtra} and ${input_khtt} != 0 and ${get_du_no_kh} > 0    Close return popup
    ...    ELSE    Log    Ignore click
    Sleep    5s
    ${return_code}    Get saved code after execute
    Execute Javascript    location.reload();
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
