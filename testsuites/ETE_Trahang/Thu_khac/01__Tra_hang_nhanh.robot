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
&{list_create_imei1}    SI024=2
&{list_create_imei2}    SI026=2
&{list_create_imei3}    SI025=1
&{list_product_tk01}    HH0040=4    DVT44=1.5    DV049=5    Combo25=2.4
&{list_product_tk02}    HH0042=1    QD101=4    DV051=1.5    Combo27=1.8
&{list_product_tk03}    HH0041=2.2    QD098=3.5    DV050=1    Combo26=5
@{list_vnd_ggsp}    2000    3000    4000    2500
@{list_%_ggsp}    5    10    15    17
@{list_giamoi}    190000.78    50000    500000    20000

*** Test Cases ***    Mã KH         List product&nums       List imei                 GGSP              GGSP IMEI     GGTH    Phí trả hàng     Khách TT    Thu khac
Khonghoantra_TH_1thukhac
                      [Tags]        ETTK
                      [Template]    ettk1
                      CTKH040       ${list_product_tk01}    ${list_create_imei1}    ${list_vnd_ggsp}    10000         50000     10000         all         TK003

Khonghoantra_TH_2thukhac
                      [Tags]        ETTK
                      [Template]    ettk2
                      CTKH041       ${list_product_tk02}    ${list_create_imei2}    ${list_%_ggsp}      20            30       16             0         TK007       TK008

Hoantra_TH_1thukhac    [Tags]        ETTK1
                      [Template]    ettka1
                      CTKH042       ${list_product_tk03}    ${list_create_imei3}    ${list_giamoi}      30000      15000      0                0           TK005

Hoantra_TH_1thukhac    [Tags]        ETTK1
                      [Template]    ettka1
                      CTKH043       ${list_product_tk03}    ${list_create_imei3}    ${list_giamoi}      10000      15         10000            100000      TK002

Hoantra_TH_2thukhac    [Tags]        ETTK1
                      [Template]    ettka2
                      CTKH044       ${list_product_tk03}    ${list_create_imei3}    ${list_giamoi}      50000      15         10000       all         TK001       TK002

Hoantra_TH_2thukhac    [Tags]        ETTK1
                      [Template]    ettka2
                      CTKH045       ${list_product_tk03}    ${list_create_imei3}    ${list_giamoi}      10000      10000      25          0           TK005       TK006

Hoantra_TH_2thukhac    [Tags]        ETTK1
                      [Template]    ettka2
                      CTKH046       ${list_product_tk03}    ${list_create_imei3}    ${list_giamoi}      100000     50000      0          20000       TK005       TK001

*** Keywords ***
ettk1
    [Arguments]    ${input_ma_kh}    ${dict_product_nums}    ${list_imei}    ${list_ggsp}    ${input_ggsp_imei}    ${input_ggth}    ${input_phi_th}
    ...     ${input_khtt}    ${input_thukhac}
    ##Activate surcharge
    ${surcharge_vnd_value}    Get surcharge vnd value    ${input_thukhac}
    ${surcharge_%}    Get surcharge percentage value    ${input_thukhac}
    Run Keyword If    ${surcharge_%} == 0    Toggle surcharge VND    ${input_thukhac}    true
    ...    ELSE    Toggle surcharge percentage    ${input_thukhac}    true
    ${get_list_status}    Get list imei status thr API    ${list_imei}
    Create invoice with imei product    ${input_ma_kh}    ${list_imei}    ${get_list_status}
    Reload Page
    ${input_imei_product}    Get Dictionary Keys    ${list_imei}
    ${input_imei_nums}    Get Dictionary Values    ${list_imei}
    ${input_product}    ${input_imei_nums}    Convert two list to string and return    ${input_imei_product}    ${input_imei_nums}
    ${list_products}    Get Dictionary Keys    ${dict_product_nums}
    ${list_nums}    Get Dictionary Values    ${dict_product_nums}
    #get data to validate
    ${get_list_baseprice}    Get list of Baseprice by Product Code    ${list_products}
    Select Return without Invoice from BH page
    ${laster_nums}    Set Variable    0
    : FOR    ${item_product}    ${item_nums}    ${item_ggsp}    ${item_giaban}    IN ZIP    ${list_products}    ${list_nums}    ${list_ggsp}    ${get_list_baseprice}
    \    ${newprice}    Wait Until Keyword Succeeds    3 times    20 s    Run keyword if    0 < ${item_ggsp} < 100
    \    ...    Price after % discount product    ${item_giaban}    ${item_ggsp}
    \    ...    ELSE IF    ${item_ggsp} > 100    Minus and round 2    ${item_giaban}    ${item_ggsp}    ELSE    Set Variable    ${item_giaban}
    \    ${laster_nums}    Wait Until Keyword Succeeds    3 times    20 s    Input product-num in sale form    ${item_product}
    \    ...    ${item_nums}    ${laster_nums}    ${cell_laster_numbers_return}
    \    Wait Until Keyword Succeeds    3 times    5 s    Run keyword if    0 < ${item_ggsp} < 100    Input % discount for multi product    ${item_product}    ${item_ggsp}    ${newprice}
    \    ...    ELSE IF    ${item_ggsp} > 100    Input VND discount for multi product    ${item_product}    ${item_ggsp}
    \    ...    ${newprice}    ELSE    Log    Ignore input
    : FOR    ${item_imei}    IN    @{imei_inlist}
    \    Wait Until Keyword Succeeds    3 times    5 s    Input product and imei incase multi product to any form    ${textbox_bh_search_ma_sp}    ${input_product}
    \    ...    ${item_search_product_indropdow}    ${textbox_nhap_serial}    ${item_serial_in_dropdown}    ${cell_bh_ma_sp}    ${cell_item_input_imei}
    \    ...    @{item_imei}
    ${newprice_imei}    Computation price incase discount by product code    ${input_product}    ${input_ggsp_imei}
    Wait Until Keyword Succeeds    3 times    5 s    Run keyword if    0 < ${input_ggsp_imei} < 100    Input % discount for multi product    ${input_product}
    ...    ${input_ggsp_imei}    ${newprice_imei}
    ...    ELSE IF    ${input_ggsp_imei} > 100    Input VND discount for multi product    ${input_product}    ${input_ggsp_imei}    ${newprice_imei}
    ...    ELSE    Log    Ignore input
    Append To List    ${list_products}    ${input_product}
    Append to List    ${list_nums}    ${input_imei_nums}
    Append To List    ${list_ggsp}    ${input_ggsp_imei}
    ${list_result_thanhtien}    ${list_giavon}    ${list_result_toncuoi}    Get list total sale - endingstock - cost incase discount    ${list_products}    ${list_nums}    ${list_ggsp}
    #compute
    ${result_tongtienhangtra}    Sum values in list and round    ${list_result_thanhtien}
    ${result_ggth}    Run Keyword If    0 < ${input_ggth} < 100    Convert % discount to VND and round    ${result_tongtienhangtra}    ${input_ggth}
    ...    ELSE    Set Variable    ${input_ggth}
    ${result_phi_th}    Run Keyword If    0 < ${input_phi_th} < 100    Convert % discount to VND and round    ${result_tongtienhangtra}    ${input_phi_th}
    ...    ELSE    Set Variable    ${input_phi_th}
    ${result_cantrakhach}    Minusx3 and replace foating point    ${result_tongtienhangtra}    ${result_ggth}    ${result_phi_th}
    ${result_khtt}    Set Variable If    "${input_khtt}" == "all"    ${result_cantrakhach}    ${input_khtt}
    ${actual_khtt}    Set Variable If    "${input_khtt}" == "0"    0    ${result_khtt}
    #create return in BH
    Wait Until Keyword Succeeds    3 times    5 s    Input Khach Hang    ${input_ma_kh}
    Wait Until Keyword Succeeds    3 times    5 s    Run keyword if    0 < ${input_ggth} < 100    Input % discount return    ${input_ggth}
    ...    ${result_ggth}
    ...    ELSE    Input VND discount return    ${input_ggth}
    Wait Until Keyword Succeeds    3 times    5 s    Run keyword if    0 < ${input_phi_th} < 100    Input % return free value    ${input_phi_th}
    ...    ${result_phi_th}
    ...    ELSE    Input VND return free value    ${input_phi_th}
    Wait Until Keyword Succeeds    3 times    5 s    Run Keyword If    "${input_khtt}" == "all"    Click Element JS    ${button_th}
    ...    ELSE    Input payment into any form    ${textbox_th_khachttTraHang}    ${input_khtt}    ${button_th}
    Sleep    1s
    Return message success validation
    ${return_code}    Wait Until Keyword Succeeds    3 times    5 s    Get saved code after execute
    Execute Javascript    location.reload();
    Sleep    20 s    wait for response to API
    #assert value product in invoice
    ${get_list_hh_in_th_af_execute}    Get list product frm Return API    ${return_code}
    ${get_list_hh_in_th_af_execute}    Reverse List one    ${get_list_hh_in_th_af_execute}
    ${list_soluong_in_hd}    ${list_giatriquydoi_in_hd}    Get list quantity and gia tri quy doi with return have multi product    ${get_list_hh_in_th_af_execute}    ${return_code}
    : FOR    ${item_ma_hh}    ${result_toncuoi}    ${item_giavon}    ${get_soluong_in_hd}    ${get_giatri_quydoi}    IN ZIP
    ...    ${get_list_hh_in_th_af_execute}    ${list_result_toncuoi}    ${list_giavon}    ${list_soluong_in_hd}    ${list_giatriquydoi_in_hd}
    \    Run Keyword If    '${get_giatri_quydoi}' == '1'    Validate onhand and cost frm API    ${return_code}    ${item_ma_hh}    ${result_toncuoi}
    \    ...    ${item_giavon}    ${get_soluong_in_hd}
    \    ...    ELSE    Validate onhand and cost frm unit product    ${return_code}    ${item_ma_hh}    ${result_toncuoi}
    \    ...    ${item_giavon}    ${get_soluong_in_hd}    ${get_giatri_quydoi}
    #assert value in return
    ${get_tongtienhangtra_af_ex}    ${get_giamgiaphieutra}    ${get_phitrahang_af_ex}    ${get_cantrakhach_af_ex}    ${get_datrakhach_af_ex}    ${get_tongtien_hoadontra_af_ex}    Get return info incase discount by return code    ${return_code}
    Should Be Equal As Numbers    ${get_tongtienhangtra_af_ex}    ${result_tongtienhangtra}
    Should Be Equal As Numbers    ${get_giamgiaphieutra}    ${result_ggth}
    Should Be Equal As Numbers    ${get_phitrahang_af_ex}    ${result_phi_th}
    Should Be Equal As Numbers    ${get_datrakhach_af_ex}    ${actual_khtt}
    Should Be Equal As Numbers    ${get_tongtien_hoadontra_af_ex}    ${result_cantrakhach}
    Remove From List    ${list_ggsp}    -1
    Log    ${list_ggsp}
    Delete return thr API        ${return_code}
    Run Keyword If    ${surcharge_%} == 0    Toggle surcharge VND    ${input_thukhac}    false
    ...    ELSE    Toggle surcharge percentage    ${input_thukhac}    false

ettk2
    [Arguments]   ${input_ma_kh}    ${dict_product_nums}    ${list_imei}    ${list_ggsp}    ${input_ggsp_imei}    ${input_ggth}
    ...    ${input_phi_th}     ${input_khtt}    ${input_thukhac1}   ${input_thukhac2}
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
    ${get_list_status}    Get list imei status thr API    ${list_imei}
    Create invoice with imei product    ${input_ma_kh}    ${list_imei}    ${get_list_status}
    Reload Page
    ${input_imei_product}    Get Dictionary Keys    ${list_imei}
    ${input_imei_nums}    Get Dictionary Values    ${list_imei}
    ${input_product}    ${input_imei_nums}    Convert two list to string and return    ${input_imei_product}    ${input_imei_nums}
    ${list_products}    Get Dictionary Keys    ${dict_product_nums}
    ${list_nums}    Get Dictionary Values    ${dict_product_nums}
    #get data to validate
    ${get_list_baseprice}    Get list of Baseprice by Product Code    ${list_products}
    Select Return without Invoice from BH page
    ${laster_nums}    Set Variable    0
    : FOR    ${item_product}    ${item_nums}    ${item_ggsp}    ${item_giaban}    IN ZIP    ${list_products}    ${list_nums}    ${list_ggsp}    ${get_list_baseprice}
    \    ${newprice}    Wait Until Keyword Succeeds    3 times    20 s    Run keyword if    0 < ${item_ggsp} < 100
    \    ...    Price after % discount product    ${item_giaban}    ${item_ggsp}
    \    ...    ELSE IF    ${item_ggsp} > 100    Minus and round 2    ${item_giaban}    ${item_ggsp}    ELSE    Set Variable    ${item_giaban}
    \    ${laster_nums}    Wait Until Keyword Succeeds    3 times    20 s    Input product-num in sale form    ${item_product}
    \    ...    ${item_nums}    ${laster_nums}    ${cell_laster_numbers_return}
    \    Wait Until Keyword Succeeds    3 times    5 s    Run keyword if    0 < ${item_ggsp} < 100    Input % discount for multi product    ${item_product}    ${item_ggsp}    ${newprice}
    \    ...    ELSE IF    ${item_ggsp} > 100    Input VND discount for multi product    ${item_product}    ${item_ggsp}
    \    ...    ${newprice}    ELSE    Log    Ignore input
    : FOR    ${item_imei}    IN    @{imei_inlist}
    \    Wait Until Keyword Succeeds    3 times    5 s    Input product and imei incase multi product to any form    ${textbox_bh_search_ma_sp}    ${input_product}
    \    ...    ${item_search_product_indropdow}    ${textbox_nhap_serial}    ${item_serial_in_dropdown}    ${cell_bh_ma_sp}    ${cell_item_input_imei}
    \    ...    @{item_imei}
    ${newprice_imei}    Computation price incase discount by product code    ${input_product}    ${input_ggsp_imei}
    Wait Until Keyword Succeeds    3 times    5 s    Run keyword if    0 < ${input_ggsp_imei} < 100    Input % discount for multi product    ${input_product}
    ...    ${input_ggsp_imei}    ${newprice_imei}
    ...    ELSE IF    ${input_ggsp_imei} > 100    Input VND discount for multi product    ${input_product}    ${input_ggsp_imei}    ${newprice_imei}
    ...    ELSE    Log    Ignore input
    Append To List    ${list_products}    ${input_product}
    Append to List    ${list_nums}    ${input_imei_nums}
    Append To List    ${list_ggsp}    ${input_ggsp_imei}
    ${list_result_thanhtien}    ${list_giavon}    ${list_result_toncuoi}    Get list total sale - endingstock - cost incase discount    ${list_products}    ${list_nums}    ${list_ggsp}
    #compute
    ${result_tongtienhangtra}    Sum values in list and round    ${list_result_thanhtien}
    ${result_ggth}    Run Keyword If    0 < ${input_ggth} < 100    Convert % discount to VND and round    ${result_tongtienhangtra}    ${input_ggth}
    ...    ELSE    Set Variable    ${input_ggth}
    ${result_phi_th}    Run Keyword If    0 < ${input_phi_th} < 100    Convert % discount to VND and round    ${result_tongtienhangtra}    ${input_phi_th}
    ...    ELSE    Set Variable    ${input_phi_th}
    ${result_cantrakhach}    Minusx3 and replace foating point    ${result_tongtienhangtra}    ${result_ggth}    ${result_phi_th}
    ${result_khtt}    Set Variable If    "${input_khtt}" == "all"    ${result_cantrakhach}    ${input_khtt}
    ${actual_khtt}    Set Variable If    "${input_khtt}" == "0"    0    ${result_khtt}
    #create return in BH
    Wait Until Keyword Succeeds    3 times    5 s    Input Khach Hang    ${input_ma_kh}
    Wait Until Keyword Succeeds    3 times    5 s    Run keyword if    0 < ${input_ggth} < 100    Input % discount return    ${input_ggth}
    ...    ${result_ggth}
    ...    ELSE    Input VND discount return    ${input_ggth}
    Wait Until Keyword Succeeds    3 times    5 s    Run keyword if    0 < ${input_phi_th} < 100    Input % return free value    ${input_phi_th}
    ...    ${result_phi_th}
    ...    ELSE    Input VND return free value    ${input_phi_th}
    Wait Until Keyword Succeeds    3 times    5 s    Run Keyword If    "${input_khtt}" == "all"    Click Element JS    ${button_th}
    ...    ELSE    Input payment into any form    ${textbox_th_khachttTraHang}    ${input_khtt}    ${button_th}
    Sleep    1s
    Return message success validation
    ${return_code}    Wait Until Keyword Succeeds    3 times    5 s    Get saved code after execute
    Execute Javascript    location.reload();
    Sleep    20 s    wait for response to API
    #assert value product in invoice
    ${get_list_hh_in_th_af_execute}    Get list product frm Return API    ${return_code}
    ${get_list_hh_in_th_af_execute}    Reverse List one    ${get_list_hh_in_th_af_execute}
    ${list_soluong_in_hd}    ${list_giatriquydoi_in_hd}    Get list quantity and gia tri quy doi with return have multi product    ${get_list_hh_in_th_af_execute}    ${return_code}
    : FOR    ${item_ma_hh}    ${result_toncuoi}    ${item_giavon}    ${get_soluong_in_hd}    ${get_giatri_quydoi}    IN ZIP
    ...    ${get_list_hh_in_th_af_execute}    ${list_result_toncuoi}    ${list_giavon}    ${list_soluong_in_hd}    ${list_giatriquydoi_in_hd}
    \    Run Keyword If    '${get_giatri_quydoi}' == '1'    Validate onhand and cost frm API    ${return_code}    ${item_ma_hh}    ${result_toncuoi}
    \    ...    ${item_giavon}    ${get_soluong_in_hd}
    \    ...    ELSE    Validate onhand and cost frm unit product    ${return_code}    ${item_ma_hh}    ${result_toncuoi}
    \    ...    ${item_giavon}    ${get_soluong_in_hd}    ${get_giatri_quydoi}
    #assert value in return
    ${get_tongtienhangtra_af_ex}    ${get_giamgiaphieutra}    ${get_phitrahang_af_ex}    ${get_cantrakhach_af_ex}    ${get_datrakhach_af_ex}    ${get_tongtien_hoadontra_af_ex}    Get return info incase discount by return code    ${return_code}
    Should Be Equal As Numbers    ${get_tongtienhangtra_af_ex}    ${result_tongtienhangtra}
    Should Be Equal As Numbers    ${get_giamgiaphieutra}    ${result_ggth}
    Should Be Equal As Numbers    ${get_phitrahang_af_ex}    ${result_phi_th}
    Should Be Equal As Numbers    ${get_datrakhach_af_ex}    ${actual_khtt}
    Should Be Equal As Numbers    ${get_tongtien_hoadontra_af_ex}    ${result_cantrakhach}
    Remove From List    ${list_ggsp}    -1
    Log    ${list_ggsp}
    ## Deactivate surcharge
    Run Keyword If    ${actual_surcharge1_value} > 100    Toggle surcharge VND    ${input_thukhac1}    false
    ...    ELSE    Toggle surcharge percentage    ${input_thukhac1}    false
    Run Keyword If    ${actual_surcharge2_value} > 100    Toggle surcharge VND    ${input_thukhac2}    false
    ...    ELSE    Toggle surcharge percentage    ${input_thukhac2}    false
    Delete return thr API        ${return_code}

ettka1
    [Arguments]    ${input_ma_kh}    ${dict_product_nums}    ${list_imei}    ${list_newprice}    ${input_newprice_imei}    ${input_ggth}
    ...    ${input_phi_th}    ${input_khtt}    ${input_thukhac}
    #get info product, customer
    ${get_list_status}    Get list imei status thr API    ${list_imei}
    Create invoice with imei product    ${input_ma_kh}    ${list_imei}    ${get_list_status}
    ${surcharge_vnd_value}    Get surcharge vnd value    ${input_thukhac}
    ${surcharge_%}    Get surcharge percentage value    ${input_thukhac}
    Run Keyword If    ${surcharge_%} == 0    Toggle surcharge VND    ${input_thukhac}    true
    ...    ELSE    Toggle surcharge percentage    ${input_thukhac}    true
    ${list_product}    Get Dictionary Keys    ${dict_product_nums}
    ${list_nums}    Get Dictionary Values    ${dict_product_nums}
    Reload page
    #get info tra hang
    ${input_imei_product}    Get Dictionary Keys    ${list_imei}
    ${input_imei_nums}    Get Dictionary Values    ${list_imei}
    ${input_product}    ${input_imei_nums}    Convert two list to string and return    ${input_imei_product}    ${input_imei_nums}
    ${list_products}    Get Dictionary Keys    ${dict_product_nums}
    ${list_nums}    Get Dictionary Values    ${dict_product_nums}
    #get data to validate
    Select Return without Invoice from BH page
    ${laster_nums}    Set Variable    0
    :FOR    ${item_product}    ${item_nums}    ${item_newprice}    IN ZIP    ${list_products}    ${list_nums}
    ...    ${list_newprice}
    \    ${laster_nums}    Wait Until Keyword Succeeds    3 times    8 s    Input product-num in sale form    ${item_product}    ${item_nums}    ${laster_nums}    ${cell_laster_numbers_return}
    \    Wait Until Keyword Succeeds    3 times    8 s     Input newprice for multi product    ${item_product}    ${item_newprice}
    : FOR    ${item_imei}    IN    @{imei_inlist}
    \    Wait Until Keyword Succeeds    3 times    5 s    Input product and imei incase multi product to any form    ${textbox_bh_search_ma_sp}    ${input_product}
    \    ...    ${item_search_product_indropdow}    ${textbox_nhap_serial}    ${item_serial_in_dropdown}    ${cell_bh_ma_sp}    ${cell_item_input_imei}
    \    ...    @{item_imei}
    Input newprice for multi product    ${input_product}    ${input_newprice_imei}
    Append To List    ${list_products}    ${input_product}
    Append to List    ${list_nums}    ${input_imei_nums}
    Append To List    ${list_newprice}    ${input_newprice_imei}
    ${list_result_thanhtien_newprice}    ${list_giavon}    ${list_result_toncuoi}    Get list total sale - endingstock - cost incase newprice    ${list_products}    ${list_nums}    ${list_newprice}
    #compute
    ${result_tongtienhangtra}    Sum values in list    ${list_result_thanhtien_newprice}
    ${result_ggth}    Run Keyword If    0 < ${input_ggth} < 100    Convert % discount to VND and round    ${result_tongtienhangtra}    ${input_ggth}
    ...    ELSE    Set Variable    ${input_ggth}
    ${result_phi_th}    Run Keyword If    0 < ${input_phi_th} < 100    Convert % discount to VND and round    ${result_tongtienhangtra}    ${input_phi_th}
    ...    ELSE    Set Variable    ${input_phi_th}
    ${actual_surcharge_type}    Set Variable If    ${surcharge_%} == 0    ${surcharge_vnd_value}    ${surcharge_%}
    ${result_per_surchare_by_invoice}    Convert % discount to VND and round    ${result_tongtienhangtra}    ${surcharge_%}
    ${actual_surcharge_value}    Set Variable If    ${surcharge_%} == 0    ${surcharge_vnd_value}    ${result_per_surchare_by_invoice}
    ${result_khachcantra}   Minusx3 and replace foating point    ${result_tongtienhangtra}    ${result_ggth}    ${result_phi_th}
    ${result_tientrakhach}    Sum and replace floating point    ${result_khachcantra}    ${actual_surcharge_value}
    ${actual_khtt_all}    Set Variable If    '${input_khtt}' == 'all'    ${result_khachcantra}    ${input_khtt}
    ${actual_khtt}    Set Variable If    '${input_khtt}' == '0'    0    ${actual_khtt_all}
    #create return in BH
    Wait Until Keyword Succeeds    3 times    5 s    Input Khach Hang    ${input_ma_kh}
    Wait Until Keyword Succeeds    3 times    8 s    Run keyword if    0 < ${input_ggth} < 100    Input % discount return    ${input_ggth}    ${result_ggth}
    ...    ELSE    Input VND discount return    ${input_ggth}
    Wait Until Keyword Succeeds    3 times    8 s     Run keyword if    0 < ${input_phi_th} < 100    Input % return free value    ${input_phi_th}    ${result_phi_th}
    ...    ELSE    Input VND return free value    ${input_phi_th}
    Wait Until Keyword Succeeds    3 times    8 s    Select one surcharge by pressing Enter    ${input_thukhac}    ${actual_surcharge_value}    ${cell_surcharge_return}
    Wait Until Keyword Succeeds    3 times    8 s     Run Keyword If    "${input_khtt}" == "all"    Click Element JS    ${button_th}
    ...    ELSE    Input payment into any form    ${textbox_th_khachttTraHang}    ${input_khtt}    ${button_th}
    Sleep    1s
    Return message success validation
    ${return_code}    Get saved code after execute
    Execute Javascript    location.reload();
    #get values
    Sleep    20 s    wait for response to API
    #assert value product in invoice
    ${get_list_hh_in_th_af_execute}    Get list product frm Return API    ${return_code}
    ${get_list_hh_in_th_af_execute}    Reverse List one    ${get_list_hh_in_th_af_execute}
    ${list_soluong_in_hd}    ${list_giatriquydoi_in_hd}    Get list quantity and gia tri quy doi with return have multi product    ${get_list_hh_in_th_af_execute}    ${return_code}
    : FOR    ${item_ma_hh}    ${result_toncuoi}    ${item_giavon}    ${get_soluong_in_hd}    ${get_giatri_quydoi}    IN ZIP
    ...    ${get_list_hh_in_th_af_execute}    ${list_result_toncuoi}    ${list_giavon}    ${list_soluong_in_hd}    ${list_giatriquydoi_in_hd}
    \    Run Keyword If    '${get_giatri_quydoi}' == '1'    Validate onhand and cost frm API    ${return_code}    ${item_ma_hh}    ${result_toncuoi}
    \    ...    ${item_giavon}    ${get_soluong_in_hd}
    \    ...    ELSE    Validate onhand and cost frm unit product    ${return_code}    ${item_ma_hh}    ${result_toncuoi}
    \    ...    ${item_giavon}    ${get_soluong_in_hd}    ${get_giatri_quydoi}
    #assert value in return
    ${get_tongtienhangtra_af_ex}    ${get_giamgiaphieutra}    ${get_phitrahang_af_ex}    ${get_cantrakhach_af_ex}    ${get_datrakhach_af_ex}    ${get_tongtien_hoadontra_af_ex}    Get return info incase discount by return code    ${return_code}
    Should Be Equal As Numbers    ${get_tongtienhangtra_af_ex}    ${result_tongtienhangtra}
    Should Be Equal As Numbers    ${get_giamgiaphieutra}    ${result_ggth}
    Should Be Equal As Numbers    ${get_phitrahang_af_ex}    ${result_phi_th}
    Should Be Equal As Numbers    ${get_datrakhach_af_ex}    ${actual_khtt}
    Should Be Equal As Numbers    ${get_tongtien_hoadontra_af_ex}    ${result_tientrakhach}
    Remove From List    ${list_newprice}    -1
    Delete return thr API        ${return_code}
    Run Keyword If    ${surcharge_%} == 0    Toggle surcharge VND    ${input_thukhac}    false
    ...    ELSE    Toggle surcharge percentage    ${input_thukhac}    false

ettka2
    [Arguments]     ${input_ma_kh}    ${dict_product_nums}    ${list_imei}    ${list_newprice}    ${input_newprice_imei}    ${input_ggth}
    ...    ${input_phi_th}    ${input_khtt}    ${input_thukhac1}    ${input_thukhac2}
    #activate surcharge
    ${get_list_status}    Get list imei status thr API    ${list_imei}
    Create invoice with imei product    ${input_ma_kh}    ${list_imei}    ${get_list_status}
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
    ${list_products}    Get Dictionary Keys    ${dict_product_nums}
    ${list_nums}    Get Dictionary Values    ${dict_product_nums}
    ${input_imei_product}    Get Dictionary Keys    ${list_imei}
    ${input_imei_nums}    Get Dictionary Values    ${list_imei}
    ${input_product}    ${input_imei_nums}    Convert two list to string and return    ${input_imei_product}    ${input_imei_nums}
    Select Return without Invoice from BH page
    ${laster_nums}    Set Variable    0
    :FOR    ${item_product}    ${item_nums}    ${item_newprice}    IN ZIP    ${list_products}    ${list_nums}
    ...    ${list_newprice}
    \    ${laster_nums}    Wait Until Keyword Succeeds    3 times    8 s    Input product-num in sale form    ${item_product}    ${item_nums}    ${laster_nums}    ${cell_laster_numbers_return}
    \    Wait Until Keyword Succeeds    3 times    8 s     Input newprice for multi product    ${item_product}    ${item_newprice}
    : FOR    ${item_imei}    IN    @{imei_inlist}
    \    Wait Until Keyword Succeeds    3 times    5 s    Input product and imei incase multi product to any form    ${textbox_bh_search_ma_sp}    ${input_product}
    \    ...    ${item_search_product_indropdow}    ${textbox_nhap_serial}    ${item_serial_in_dropdown}    ${cell_bh_ma_sp}    ${cell_item_input_imei}
    \    ...    @{item_imei}
    Input newprice for multi product    ${input_product}    ${input_newprice_imei}
    Append To List    ${list_products}    ${input_product}
    Append to List    ${list_nums}    ${input_imei_nums}
    Append To List    ${list_newprice}    ${input_newprice_imei}
    ${list_result_thanhtien_newprice}    ${list_giavon}    ${list_result_toncuoi}    Get list total sale - endingstock - cost incase newprice    ${list_products}    ${list_nums}    ${list_newprice}
    #compute
    ${result_tongtienhangtra}    Sum values in list    ${list_result_thanhtien_newprice}
    ${result_ggth}    Run Keyword If    0 < ${input_ggth} < 100    Convert % discount to VND and round    ${result_tongtienhangtra}    ${input_ggth}
    ...    ELSE    Set Variable    ${input_ggth}
    ${result_phi_th}    Run Keyword If    0 < ${input_phi_th} < 100    Convert % discount to VND and round    ${result_tongtienhangtra}    ${input_phi_th}
    ...    ELSE    Set Variable    ${input_phi_th}
    ${total_surcharge}=    Run Keyword If    ${actual_surcharge1_value} > 100 and ${actual_surcharge2_value} > 100    Sum    ${actual_surcharge1_value}    ${actual_surcharge2_value}
    ...    ELSE IF    ${actual_surcharge1_value} > 100 and ${actual_surcharge2_value} < 100    VND and Percentage Surcharges sum    ${actual_surcharge2_value}    ${result_tongtienhangtra}    ${actual_surcharge1_value}
    ...    ELSE IF    ${actual_surcharge1_value} < 100 and ${actual_surcharge2_value} < 100    Percentage and Percentage Surcharges sum    ${result_tongtienhangtra}    ${actual_surcharge1_value}    ${actual_surcharge2_value}
    ...    ELSE    Log    abv
    ${result_khachcantra}   Minusx3 and replace foating point    ${result_tongtienhangtra}    ${result_ggth}    ${result_phi_th}
    ${result_tientrakhach}    Sum and replace floating point    ${result_khachcantra}    ${total_surcharge}
    ${actual_khtt_all}    Set Variable If    '${input_khtt}' == 'all'    ${result_tientrakhach}    ${input_khtt}
    ${actual_khtt}    Set Variable If    '${input_khtt}' == '0'    0    ${actual_khtt_all}
    #input data into DH form
    Wait Until Keyword Succeeds    3 times    5 s    Input Khach Hang    ${input_ma_kh}
    Wait Until Keyword Succeeds    3 times    8 s    Run keyword if    0 < ${input_ggth} < 100    Input % discount return    ${input_ggth}    ${result_ggth}
    ...    ELSE    Input VND discount return    ${input_ggth}
    Wait Until Keyword Succeeds    3 times    8 s     Run keyword if    0 < ${input_phi_th} < 100    Input % return free value    ${input_phi_th}    ${result_phi_th}
    ...    ELSE    Input VND return free value    ${input_phi_th}
    Wait Until Keyword Succeeds    3 times    8 s    Select two surcharge by pressing Enter    ${input_thukhac1}    ${input_thukhac2}    ${total_surcharge}    ${cell_surcharge_return}
    Wait Until Keyword Succeeds    3 times    8 s     Run Keyword If    "${input_khtt}" == "all"    Click Element JS    ${button_th}
    ...    ELSE    Input payment into any form    ${textbox_th_khachttTraHang}    ${input_khtt}    ${button_th}
    Sleep    1s
    Return message success validation
    ${return_code}    Get saved code after execute
    #get values
    Sleep    20 s    wait for response to API
    #assert value product in invoice
    ${get_list_hh_in_th_af_execute}    Get list product frm Return API    ${return_code}
    ${get_list_hh_in_th_af_execute}    Reverse List one    ${get_list_hh_in_th_af_execute}
    ${list_soluong_in_hd}    ${list_giatriquydoi_in_hd}    Get list quantity and gia tri quy doi with return have multi product    ${get_list_hh_in_th_af_execute}    ${return_code}
    : FOR    ${item_ma_hh}    ${result_toncuoi}    ${item_giavon}    ${get_soluong_in_hd}    ${get_giatri_quydoi}    IN ZIP
    ...    ${get_list_hh_in_th_af_execute}    ${list_result_toncuoi}    ${list_giavon}    ${list_soluong_in_hd}    ${list_giatriquydoi_in_hd}
    \    Run Keyword If    '${get_giatri_quydoi}' == '1'    Validate onhand and cost frm API    ${return_code}    ${item_ma_hh}    ${result_toncuoi}
    \    ...    ${item_giavon}    ${get_soluong_in_hd}
    \    ...    ELSE    Validate onhand and cost frm unit product    ${return_code}    ${item_ma_hh}    ${result_toncuoi}
    \    ...    ${item_giavon}    ${get_soluong_in_hd}    ${get_giatri_quydoi}
    #assert value in return
    ${get_tongtienhangtra_af_ex}    ${get_giamgiaphieutra}    ${get_phitrahang_af_ex}    ${get_cantrakhach_af_ex}    ${get_datrakhach_af_ex}    ${get_tongtien_hoadontra_af_ex}    Get return info incase discount by return code    ${return_code}
    Should Be Equal As Numbers    ${get_tongtienhangtra_af_ex}    ${result_tongtienhangtra}
    Should Be Equal As Numbers    ${get_giamgiaphieutra}    ${result_ggth}
    Should Be Equal As Numbers    ${get_phitrahang_af_ex}    ${result_phi_th}
    Should Be Equal As Numbers    ${get_datrakhach_af_ex}    ${actual_khtt}
    Should Be Equal As Numbers    ${get_tongtien_hoadontra_af_ex}    ${result_tientrakhach}
    Remove From List    ${list_newprice}    -1
    #Delete return thr API        ${return_code}
    #Deactivate surcharge
    Run Keyword If    ${actual_surcharge1_value} > 100    Toggle surcharge VND    ${input_thukhac1}    false
    ...    ELSE    Toggle surcharge percentage    ${input_thukhac1}    false
    Run Keyword If    ${actual_surcharge2_value} > 100    Toggle surcharge VND    ${input_thukhac2}    false
    ...    ELSE    Toggle surcharge percentage    ${input_thukhac2}    false
