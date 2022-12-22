*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    ${headless_browser}
Test Teardown     After Test
Library           Collections
Library           BuiltIn
Resource          ../../../../core/Ban_Hang/banhang_action.robot
Resource          ../../../../core/Tra_hang/tra_hang_action.robot
Resource          ../../../../core/Tra_hang/tra_hang_page.robot
Resource          ../../../../core/API/api_soquy.robot
Resource          ../../../../core/API/api_trahang.robot
Resource          ../../../../config/env_product/envi.robot
Resource          ../../../../core/Ban_Hang/banhang_page.robot
Resource          ../../../../core/Tra_hang/doi_tra_hang_action.robot
Resource          ../../../../core/share/toast_message.robot
Resource          ../../../../core/share/discount.robot
Resource          ../../../../core/share/computation.robot

*** Variables ***
&{list_product_nums_TH}    KLDV001=6.3
&{list_imei_dth}    KLSI0001=2
&{list_product_nums_DTH}    KLT0001=5.2    KLQD001=3    KLDV002=4    KLCB001=2.6
@{list_discount}    1200    15    11000    160000
@{list_discount_type}    dis    dis    change    change
@{list_discount1}    7000    75000    10    80000.6
@{list_discount_type1}    dis    change    dis    change
@{list_surcharge}    TK003    TK007
@{list_surcharge1}    TK001    TK006

*** Test Cases ***    Mã KH         List thu khác         List product trả hàng      List product đổi trả hàng    List imei           Phí trả hàng    List change          List change type          Change imei    Change type imei    GGDTH    Khách thanh toán
Ko tu dong            [Tags]        EDTTK
                      [Template]    edtntk01
                      CTKH001       ${list_surcharge}     ${list_product_nums_TH}    ${list_product_nums_DTH}     ${list_imei_dth}    15              ${list_discount}     ${list_discount_type}     15             dis                 50000    all

Tu dong               [Tags]        EDTTK
                      [Template]    edtntk02
                      CTKH002       ${list_surcharge1}    ${list_product_nums_TH}    ${list_product_nums_DTH}     ${list_imei_dth}    20000           ${list_discount1}    ${list_discount_type1}    115000         change              20       75000

*** Keywords ***
edtntk01
    [Arguments]    ${input_ma_kh}    ${list_thukhac}    ${dic_product_nums_th}    ${dic_product_nums_dth}    ${list_imei_nums}    ${input_phi_th}
    ...    ${list_change}    ${list_change_type}    ${input_change_imei}    ${input_change_imei_type}    ${input_ggdth}    ${input_khtt}
    ${list_product_dth}    Get Dictionary Keys    ${dic_product_nums_dth}
    ${list_nums_dth}    Get Dictionary Values    ${dic_product_nums_dth}
    ${list_imei_product_dth}    Get Dictionary Keys    ${list_imei_nums}
    ${list_imei_nums_dth}    Get Dictionary Values    ${list_imei_nums}
    ${input_product_imei}    ${input_imei_nums}    Convert two list to string and return    ${list_imei_product_dth}    ${list_imei_nums_dth}
    Create list imei    ${list_imei_product_dth}    ${list_imei_nums_dth}
    ${get_no_bf_execute}    Get Du no cuoi KH from API    ${input_ma_kh}
    #get data frm Trả hàng
    ${list_product_th}    Get Dictionary Keys    ${dic_product_nums_th}
    ${list_nums_th}    Get Dictionary Values    ${dic_product_nums_th}
    ${list_result_thanhtien_th}    ${list_giavon_th}    ${list_result_toncuoi_th}    Get list total sale - endingstock - cost frm product api    ${list_product_th}    ${list_nums_th}
    ${get_list_baseprice}    Get list of Baseprice by Product Code    ${list_product_dth}
    #thu khac
    ${list_actual_surcharge_value}    Create List
    : FOR    ${item_thukhac}    IN ZIP    ${list_thukhac}
    \    ${surcharge_value_vnd}    Get surcharge vnd value    ${item_thukhac}
    \    ${surcharge_value_percentage}    Get surcharge percentage value    ${item_thukhac}
    \    ${actual_surcharge_value}    Set Variable If    ${surcharge_value_percentage} == 0    ${surcharge_value_vnd}    ${surcharge_value_percentage}
    \    Run Keyword If    ${actual_surcharge_value} > 100    Toggle surcharge VND    ${item_thukhac}    true
    \    ...    ELSE    Toggle surcharge percentage    ${item_thukhac}    true
    \    Append To List    ${list_actual_surcharge_value}    ${actual_surcharge_value}
    Log    ${list_actual_surcharge_value}
    #input product into DTH form
    Wait Until Keyword Succeeds    3 times    8 s    Before Test Ban Hang deactivate print warranty
    Select Return without Invoice from BH page
    ${laster_nums}    Set Variable    0
    : FOR    ${item_product}    ${item_nums}    IN ZIP    ${list_product_th}    ${list_nums_th}
    \    ${laster_nums}    Wait Until Keyword Succeeds    3 times    5 s    Input product-num in sale form    ${item_product}
    \    ...    ${item_nums}    ${laster_nums}    ${cell_laster_numbers_return}
    ${laster_nums1}    Set Variable    0
    : FOR    ${item_product_dth}    ${item_nums_dth}    ${item_giaban}    ${item_change}    ${item_change_type}    IN ZIP
    ...    ${list_product_dth}    ${list_nums_dth}    ${get_list_baseprice}    ${list_change}    ${list_change_type}
    \    ${laster_nums1}    Wait Until Keyword Succeeds    3 times    5 s    Input product and nums into Doi tra hang form    ${item_product_dth}
    \    ...    ${item_nums_dth}    ${laster_nums1}
    \    ${newprice}    Run Keyword If    0<${item_change}<100 and '${item_change_type}'=='dis'    Price after % discount product    ${item_giaban}    ${item_change}
    \    ...    ELSE IF    ${item_change}>100 and '${item_change_type}'=='dis'    Minus    ${item_giaban}    ${item_change}
    \    ...    ELSE    Log    Ignore newprice
    \    Wait Until Keyword Succeeds    3 times    5 s    Run keyword if    0<${item_change}<100 and '${item_change_type}'=='dis'    Input % discount for multi product
    \    ...    ${item_product_dth}    ${item_change}    ${newprice}
    \    ...    ELSE IF    ${item_change}>100 and '${item_change_type}'=='dis'    Input VND discount for multi product    ${item_product_dth}    ${item_change}
    \    ...    ${newprice}
    \    ...    ELSE    Input newprice for multi product    ${item_product_dth}    ${item_change}
    ${laster_nums2}    Set Variable    0
    : FOR    ${item_product_imei}    ${item_imei}    IN ZIP    ${list_imei_product_dth}    ${imei_inlist}
    \    ${laster_nums2}    Wait Until Keyword Succeeds    3 times    8 s    Input product and imei incase multi product to any form    ${textbox_th_search_hangdoi}
    \    ...    ${item_product_imei}    ${cell_dth_sanpham}    ${textbox_dth_nhap_serial}    ${item_dth_imei_in_dropdown}    ${cell_dth_ma_sanpham}
    \    ...    ${cell_dth_imei_multi_product}    @{item_imei}
    ${newprice_imei}    Run Keyword If    '${input_change_imei_type}'=='dis'    Computation price incase discount by product code    ${input_product_imei}    ${input_change_imei}
    ...    ELSE    Set Variable    ${input_change_imei}
    Wait Until Keyword Succeeds    3 times    5 s    Run keyword if    0 < ${input_change_imei} < 100 and '${input_change_imei_type}'=='dis'    Input % discount for multi product    ${input_product_imei}
    ...    ${input_change_imei}    ${newprice_imei}
    ...    ELSE IF    ${input_change_imei} > 100 and '${input_change_imei_type}'=='dis'    Input VND discount for multi product    ${input_product_imei}    ${input_change_imei}    ${newprice_imei}
    ...    ELSE    Input newprice for multi product    ${input_product_imei}    ${input_change_imei}
    #get data frm Doi hang
    Append To List    ${list_product_dth}    ${input_product_imei}
    Append to List    ${list_nums_dth}    ${input_imei_nums}
    Append to List    ${list_change}    ${input_change_imei}
    Append to List    ${list_change_type}    ${input_change_imei_type}
    ${list_result_thanhtien_dth}    ${list_giavon_dth}    ${list_result_toncuoi_dth}    Get list total sale - endingstock - cost incase changing product price with additional invoice    ${list_product_dth}    ${list_nums_dth}    ${list_change}
    ...    ${list_change_type}
    #compute trả hàng
    ${result_tongtientra}    Sum values in list    ${list_result_thanhtien_th}
    ${result_phi_th}    Run Keyword If    0 < ${input_phi_th} < 100    Convert % discount to VND and round    ${result_tongtientra}    ${input_phi_th}
    ...    ELSE    Set Variable    ${input_phi_th}
    ${result_tongtientra_tru_phith}    Minus and round 2    ${result_tongtientra}    ${result_phi_th}
    #compute mua hàng
    ${result_tongtienmua}    Sum values in list    ${list_result_thanhtien_dth}
    ${result_ggdth}    Run Keyword If    0 < ${input_ggdth} < 100    Convert % discount to VND and round    ${result_tongtienmua}    ${input_ggdth}
    ...    ELSE    Set Variable    ${input_ggdth}
    ${result_tongtienmua_tru_gg}    Minus    ${result_tongtienmua}    ${result_ggdth}
    #tinh tong thu khac
    ${list_result_thukhac}    Create List
    : FOR    ${item_value}    IN ZIP    ${list_actual_surcharge_value}
    \    ${result_thukhac}    Run Keyword If    ${item_value}>100    Set Variable    ${item_value}
    \    ...    ELSE    Convert % discount to VND and round    ${item_value}    ${result_tongtienmua_tru_gg}
    \    Append To List    ${list_result_thukhac}    ${result_thukhac}
    Log    ${list_result_thukhac}
    ${total_thukhac}    Sum values in list    ${list_result_thukhac}
    #
    ${result_tongtienmua_cong_thukhac}    Sum    ${result_tongtienmua}    ${total_thukhac}
    ${result_tongtienmua_gom_gg_thukhac}    Sum    ${result_tongtienmua_tru_gg}    ${total_thukhac}
    ${result_khachthanhtoan}    Minus and round 2    ${result_tongtienmua_gom_gg_thukhac}    ${result_tongtientra_tru_phith}
    ${result_cantrakhach}    Minus and round 2    ${result_tongtientra_tru_phith}    ${result_tongtienmua_gom_gg_thukhac}
    ${result_kh_canthanhtoan}    Set Variable If    ${result_tongtienmua_gom_gg_thukhac}<${result_tongtientra_tru_phith}    ${result_cantrakhach}    ${result_khachthanhtoan}
    ${result_khtt}    Set Variable If    "${input_khtt}" == "all"    ${result_kh_canthanhtoan}    ${input_khtt}
    ${actual_khtt}    Set Variable If    "${input_khtt}" == "0"    0    ${result_khtt}
    ${actuall_trahang}    Set Variable If    ${result_tongtienmua_gom_gg_thukhac}<${result_tongtientra_tru_phith}    ${actual_khtt}    0
    #compute KH
    ${result_du_no_th_KH}    Minus    ${get_no_bf_execute}    ${result_tongtientra_tru_phith}
    ${result_PTT_th_KH}    Run Keyword If    ${result_tongtienmua_gom_gg_thukhac}<${result_tongtientra_tru_phith}    Sum    ${result_du_no_th_KH}    ${actual_khtt}
    ...    ELSE    Set Variable    ${result_du_no_th_KH}
    ${result_du_no_KH}    Sum and replace floating point    ${result_PTT_th_KH}    ${result_tongtienmua_gom_gg_thukhac}
    ${result_PTT_dth_KH}    Run Keyword If    ${result_tongtienmua_gom_gg_thukhac}>${result_tongtientra_tru_phith}    Minus    ${result_du_no_KH}    ${actual_khtt}
    ...    ELSE    Set Variable    ${result_du_no_KH}
    #create đổi trả hàng
    Wait Until Keyword Succeeds    3 times    5 s    Input Khach Hang    ${input_ma_kh}
    Wait Until Keyword Succeeds    3 times    5 s    Run keyword if    0 < ${input_phi_th} < 100    Input % return free value    ${input_phi_th}
    ...    ${result_phi_th}
    ...    ELSE    Input VND return free value    ${input_phi_th}
    Wait Until Keyword Succeeds    3 times    5 s    Run Keyword If    0 < ${input_ggdth} < 100    Input % discount additional invoice    ${input_ggdth}
    ...    ${result_ggdth}
    ...    ELSE    Input VND discount additional invoice    ${input_ggdth}
    #Chon thu khac
    Wait Until Keyword Succeeds    3 times    5 s    Select list surcharge by pressing Enter    ${list_thukhac}    ${total_thukhac}    ${cell_surcharge_doitra_value}
    ${button_thanhtoan}    Set Variable If    ${result_tongtienmua_gom_gg_thukhac}<${result_tongtientra_tru_phith}    ${textbox_dth_tientrakhach}    ${textbox_dth_khachthanhtoan}
    Wait Until Keyword Succeeds    3 times    5 s    Run Keyword If    "${input_khtt}" == "all"    Click Element JS    ${button_th}
    ...    ELSE    Input payment into any form    ${button_thanhtoan}    ${input_khtt}    ${button_th}
    Return message success validation
    ${return_code}    Wait Until Keyword Succeeds    3 times    5 s    Get saved code after execute
    Execute Javascript    location.reload();
    Sleep    20 s    wait for response to API
    #tat thu khac
    : FOR    ${item_thukhac}    ${item_value}    IN ZIP    ${list_thukhac}    ${list_actual_surcharge_value}
    \    Run Keyword If    ${item_value} > 100    Toggle surcharge VND    ${item_thukhac}    false
    \    ...    ELSE    Toggle surcharge percentage    ${item_thukhac}    false
    #
    #assert value in return
    ${get_tongtienhangtra_af_ex}    ${get_phitrahang_af_ex}    ${get_cantrakhach_af_ex}    ${get_datrakhach_af_ex}    ${get_tongtien_hoadontra_af_ex}    Get return info by return code    ${return_code}
    Should Be Equal As Numbers    ${get_tongtienhangtra_af_ex}    ${result_tongtientra}
    Should Be Equal As Numbers    ${get_phitrahang_af_ex}    ${result_phi_th}
    Should Be Equal As Numbers    ${get_datrakhach_af_ex}    ${actuall_trahang}
    Should Be Equal As Numbers    ${get_tongtien_hoadontra_af_ex}    ${result_tongtientra_tru_phith}
    #assert value in đổi hàng
    ${get_additional_invoice_code}    Get additional invoice code by return code    ${return_code}
    ${get_ma_kh_by_hd_af_ex}    ${get_tong_tien_hang_af_ex}    ${get_khach_tt_af_ex}    ${get_giamgia_hd_af_ex}    ${get_khach_can_tra_af_ex}    ${get_trangthai_af_ex}    Get additional invoice info incase discount by additional invoice code
    ...    ${get_additional_invoice_code}
    Should Be Equal As Numbers    ${get_tong_tien_hang_af_ex}    ${result_tongtienmua_cong_thukhac}
    Run Keyword If    ${result_tongtienmua_gom_gg_thukhac}<${result_tongtientra_tru_phith}    Should Be Equal As Numbers    ${get_khach_can_tra_af_ex}    0
    ...    ELSE    Should Be Equal As Numbers    ${get_khach_can_tra_af_ex}    ${result_kh_canthanhtoan}
    Should Be Equal As Numbers    ${get_giamgia_hd_af_ex}    ${result_ggdth}
    Run Keyword If    ${result_tongtienmua_gom_gg_thukhac}<${result_tongtientra_tru_phith}    Should Be Equal As Numbers    ${get_khach_tt_af_ex}    0
    ...    ELSE    Should Be Equal As Numbers    ${get_khach_tt_af_ex}    ${actual_khtt}
    Should Be Equal As Strings    ${get_ma_kh_by_hd_af_ex}    ${input_ma_kh}
    Should Be Equal As Strings    ${get_trangthai_af_ex}    Hoàn thành
    #assert customer and so quy
    ${get_no_af_execute_kh}    Get Du no cuoi KH from API    ${input_ma_kh}
    Should Be Equal As Numbers    ${get_no_af_execute_kh}    ${result_PTT_dth_KH}

edtntk02
    [Arguments]    ${input_ma_kh}    ${list_thukhac}    ${dic_product_nums_th}    ${dic_product_nums_dth}    ${list_imei_nums}    ${input_phi_th}
    ...    ${list_change}    ${list_change_type}    ${input_change_imei}    ${input_change_imei_type}    ${input_ggdth}    ${input_khtt}
    ${list_product_dth}    Get Dictionary Keys    ${dic_product_nums_dth}
    ${list_nums_dth}    Get Dictionary Values    ${dic_product_nums_dth}
    ${list_imei_product_dth}    Get Dictionary Keys    ${list_imei_nums}
    ${list_imei_nums_dth}    Get Dictionary Values    ${list_imei_nums}
    ${input_product_imei}    ${input_imei_nums}    Convert two list to string and return    ${list_imei_product_dth}    ${list_imei_nums_dth}
    Create list imei    ${list_imei_product_dth}    ${list_imei_nums_dth}
    ${get_no_bf_execute}    Get Du no cuoi KH from API    ${input_ma_kh}
    #get data frm Trả hàng
    ${list_product_th}    Get Dictionary Keys    ${dic_product_nums_th}
    ${list_nums_th}    Get Dictionary Values    ${dic_product_nums_th}
    ${list_result_thanhtien_th}    ${list_giavon_th}    ${list_result_toncuoi_th}    Get list total sale - endingstock - cost frm product api    ${list_product_th}    ${list_nums_th}
    ${get_list_baseprice}    Get list of Baseprice by Product Code    ${list_product_dth}
    #thu khac
    ${list_actual_surcharge_value}    Create List
    : FOR    ${item_thukhac}    IN ZIP    ${list_thukhac}
    \    ${surcharge_value_vnd}    Get surcharge vnd value    ${item_thukhac}
    \    ${surcharge_value_percentage}    Get surcharge percentage value    ${item_thukhac}
    \    ${actual_surcharge_value}    Set Variable If    ${surcharge_value_percentage} == 0    ${surcharge_value_vnd}    ${surcharge_value_percentage}
    \    Run Keyword If    ${actual_surcharge_value} > 100    Toggle surcharge VND    ${item_thukhac}    true
    \    ...    ELSE    Toggle surcharge percentage    ${item_thukhac}    true
    \    Append To List    ${list_actual_surcharge_value}    ${actual_surcharge_value}
    Log    ${list_actual_surcharge_value}
    #input product into DTH form
    Wait Until Keyword Succeeds    3 times    8 s    Before Test Ban Hang deactivate print warranty
    Select Return without Invoice from BH page
    ${laster_nums}    Set Variable    0
    : FOR    ${item_product}    ${item_nums}    IN ZIP    ${list_product_th}    ${list_nums_th}
    \    ${laster_nums}    Wait Until Keyword Succeeds    3 times    5 s    Input product-num in sale form    ${item_product}
    \    ...    ${item_nums}    ${laster_nums}    ${cell_laster_numbers_return}
    ${laster_nums1}    Set Variable    0
    : FOR    ${item_product_dth}    ${item_nums_dth}    ${item_giaban}    ${item_change}    ${item_change_type}    IN ZIP
    ...    ${list_product_dth}    ${list_nums_dth}    ${get_list_baseprice}    ${list_change}    ${list_change_type}
    \    ${laster_nums1}    Wait Until Keyword Succeeds    3 times    5 s    Input product and nums into Doi tra hang form    ${item_product_dth}
    \    ...    ${item_nums_dth}    ${laster_nums1}
    \    ${newprice}    Run Keyword If    0<${item_change}<100 and '${item_change_type}'=='dis'    Price after % discount product    ${item_giaban}    ${item_change}
    \    ...    ELSE IF    ${item_change}>100 and '${item_change_type}'=='dis'    Minus    ${item_giaban}    ${item_change}
    \    ...    ELSE    Log    Ignore newprice
    \    Wait Until Keyword Succeeds    3 times    5 s    Run keyword if    0<${item_change}<100 and '${item_change_type}'=='dis'    Input % discount for multi product
    \    ...    ${item_product_dth}    ${item_change}    ${newprice}
    \    ...    ELSE IF    ${item_change}>100 and '${item_change_type}'=='dis'    Input VND discount for multi product    ${item_product_dth}    ${item_change}
    \    ...    ${newprice}
    \    ...    ELSE    Input newprice for multi product    ${item_product_dth}    ${item_change}
    ${laster_nums2}    Set Variable    0
    : FOR    ${item_product_imei}    ${item_imei}    IN ZIP    ${list_imei_product_dth}    ${imei_inlist}
    \    ${laster_nums2}    Wait Until Keyword Succeeds    3 times    8 s    Input product and imei incase multi product to any form    ${textbox_th_search_hangdoi}
    \    ...    ${item_product_imei}    ${cell_dth_sanpham}    ${textbox_dth_nhap_serial}    ${item_dth_imei_in_dropdown}    ${cell_dth_ma_sanpham}
    \    ...    ${cell_dth_imei_multi_product}    @{item_imei}
    ${newprice_imei}    Run Keyword If    '${input_change_imei_type}'=='dis'    Computation price incase discount by product code    ${input_product_imei}    ${input_change_imei}
    ...    ELSE    Set Variable    ${input_change_imei}
    Wait Until Keyword Succeeds    3 times    5 s    Run keyword if    0 < ${input_change_imei} < 100 and '${input_change_imei_type}'=='dis'    Input % discount for multi product    ${input_product_imei}
    ...    ${input_change_imei}    ${newprice_imei}
    ...    ELSE IF    ${input_change_imei} > 100 and '${input_change_imei_type}'=='dis'    Input VND discount for multi product    ${input_product_imei}    ${input_change_imei}    ${newprice_imei}
    ...    ELSE    Input newprice for multi product    ${input_product_imei}    ${input_change_imei}
    #get data frm Doi hang
    Append To List    ${list_product_dth}    ${input_product_imei}
    Append to List    ${list_nums_dth}    ${input_imei_nums}
    Append to List    ${list_change}    ${input_change_imei}
    Append to List    ${list_change_type}    ${input_change_imei_type}
    Log    ${list_product_dth}
    Log    ${list_nums_dth}
    Log    ${list_change}
    Log    ${list_change_type}
    ${list_result_thanhtien_dth}    ${list_giavon_dth}    ${list_result_toncuoi_dth}    Get list total sale - endingstock - cost incase changing product price with additional invoice    ${list_product_dth}    ${list_nums_dth}    ${list_change}
    ...    ${list_change_type}
    #compute trả hàng
    ${result_tongtientra}    Sum values in list    ${list_result_thanhtien_th}
    ${result_phi_th}    Run Keyword If    0 < ${input_phi_th} < 100    Convert % discount to VND and round    ${result_tongtientra}    ${input_phi_th}
    ...    ELSE    Set Variable    ${input_phi_th}
    ${result_tongtientra_tru_phith}    Minus and round 2    ${result_tongtientra}    ${result_phi_th}
    #compute mua hàng
    ${result_tongtienmua}    Sum values in list    ${list_result_thanhtien_dth}
    ${result_ggdth}    Run Keyword If    0 < ${input_ggdth} < 100    Convert % discount to VND and round    ${result_tongtienmua}    ${input_ggdth}
    ...    ELSE    Set Variable    ${input_ggdth}
    ${result_tongtienmua_tru_gg}    Minus    ${result_tongtienmua}    ${result_ggdth}
    #tinh tong thu khac
    ${list_result_thukhac}    Create List
    : FOR    ${item_value}    IN ZIP    ${list_actual_surcharge_value}
    \    ${result_thukhac}    Run Keyword If    ${item_value}>100    Set Variable    ${item_value}
    \    ...    ELSE    Convert % discount to VND and round    ${item_value}    ${result_tongtienmua_tru_gg}
    \    Append To List    ${list_result_thukhac}    ${result_thukhac}
    Log    ${list_result_thukhac}
    ${total_thukhac}    Sum values in list    ${list_result_thukhac}
    #
    ${result_tongtienmua_cong_thukhac}    Sum    ${result_tongtienmua}    ${total_thukhac}
    ${result_tongtienmua_gom_gg_thukhac}    Sum    ${result_tongtienmua_tru_gg}    ${total_thukhac}
    ${result_khachthanhtoan}    Minus and round 2    ${result_tongtienmua_gom_gg_thukhac}    ${result_tongtientra_tru_phith}
    ${result_cantrakhach}    Minus and round 2    ${result_tongtientra_tru_phith}    ${result_tongtienmua_gom_gg_thukhac}
    ${result_kh_canthanhtoan}    Set Variable If    ${result_tongtienmua_gom_gg_thukhac}<${result_tongtientra_tru_phith}    ${result_cantrakhach}    ${result_khachthanhtoan}
    ${result_khtt}    Set Variable If    "${input_khtt}" == "all"    ${result_kh_canthanhtoan}    ${input_khtt}
    ${actual_khtt}    Set Variable If    "${input_khtt}" == "0"    0    ${result_khtt}
    ${actuall_trahang}    Set Variable If    ${result_tongtienmua_gom_gg_thukhac}<${result_tongtientra_tru_phith}    ${actual_khtt}    0
    #compute KH
    ${result_du_no_th_KH}    Minus    ${get_no_bf_execute}    ${result_tongtientra_tru_phith}
    ${result_PTT_th_KH}    Run Keyword If    ${result_tongtienmua_gom_gg_thukhac}<${result_tongtientra_tru_phith}    Sum    ${result_du_no_th_KH}    ${actual_khtt}
    ...    ELSE    Set Variable    ${result_du_no_th_KH}
    ${result_du_no_KH}    Sum and replace floating point    ${result_PTT_th_KH}    ${result_tongtienmua_gom_gg_thukhac}
    ${result_PTT_dth_KH}    Run Keyword If    ${result_tongtienmua_gom_gg_thukhac}>${result_tongtientra_tru_phith}    Minus    ${result_du_no_KH}    ${actual_khtt}
    ...    ELSE    Set Variable    ${result_du_no_KH}
    #create đổi trả hàng
    Wait Until Keyword Succeeds    3 times    5 s    Input Khach Hang    ${input_ma_kh}
    Wait Until Keyword Succeeds    3 times    5 s    Run keyword if    0 < ${input_phi_th} < 100    Input % return free value    ${input_phi_th}
    ...    ${result_phi_th}
    ...    ELSE    Input VND return free value    ${input_phi_th}
    Wait Until Keyword Succeeds    3 times    5 s    Run Keyword If    0 < ${input_ggdth} < 100    Input % discount additional invoice    ${input_ggdth}
    ...    ${result_ggdth}
    ...    ELSE    Input VND discount additional invoice    ${input_ggdth}
    #Chon thu khac
    ${get_total_thukhac}    Get New price from UI    ${cell_surcharge_doitra_value}
    Should Be Equal As Numbers    ${get_total_thukhac}    ${total_thukhac}
    ${button_thanhtoan}    Set Variable If    ${result_tongtienmua_gom_gg_thukhac}<${result_tongtientra_tru_phith}    ${textbox_dth_tientrakhach}    ${textbox_dth_khachthanhtoan}
    Wait Until Keyword Succeeds    3 times    5 s    Run Keyword If    "${input_khtt}" == "all"    Click Element JS    ${button_th}
    ...    ELSE    Input payment into any form    ${button_thanhtoan}    ${input_khtt}    ${button_th}
    Return message success validation
    ${return_code}    Wait Until Keyword Succeeds    3 times    5 s    Get saved code after execute
    Execute Javascript    location.reload();
    Sleep    20 s    wait for response to API
    #tat thu khac
    : FOR    ${item_thukhac}    ${item_value}    IN ZIP    ${list_thukhac}    ${list_actual_surcharge_value}
    \    Run Keyword If    ${item_value} > 100    Toggle surcharge VND    ${item_thukhac}    false
    \    ...    ELSE    Toggle surcharge percentage    ${item_thukhac}    false
    #
    #assert value in return
    ${get_tongtienhangtra_af_ex}    ${get_phitrahang_af_ex}    ${get_cantrakhach_af_ex}    ${get_datrakhach_af_ex}    ${get_tongtien_hoadontra_af_ex}    Get return info by return code    ${return_code}
    Should Be Equal As Numbers    ${get_tongtienhangtra_af_ex}    ${result_tongtientra}
    Should Be Equal As Numbers    ${get_phitrahang_af_ex}    ${result_phi_th}
    Should Be Equal As Numbers    ${get_datrakhach_af_ex}    ${actuall_trahang}
    Should Be Equal As Numbers    ${get_tongtien_hoadontra_af_ex}    ${result_tongtientra_tru_phith}
    #assert value in đổi hàng
    ${get_additional_invoice_code}    Get additional invoice code by return code    ${return_code}
    ${get_ma_kh_by_hd_af_ex}    ${get_tong_tien_hang_af_ex}    ${get_khach_tt_af_ex}    ${get_giamgia_hd_af_ex}    ${get_khach_can_tra_af_ex}    ${get_trangthai_af_ex}    Get additional invoice info incase discount by additional invoice code
    ...    ${get_additional_invoice_code}
    Should Be Equal As Numbers    ${get_tong_tien_hang_af_ex}    ${result_tongtienmua_cong_thukhac}
    Run Keyword If    ${result_tongtienmua_gom_gg_thukhac}<${result_tongtientra_tru_phith}    Should Be Equal As Numbers    ${get_khach_can_tra_af_ex}    0
    ...    ELSE    Should Be Equal As Numbers    ${get_khach_can_tra_af_ex}    ${result_kh_canthanhtoan}
    Should Be Equal As Numbers    ${get_giamgia_hd_af_ex}    ${result_ggdth}
    Run Keyword If    ${result_tongtienmua_gom_gg_thukhac}<${result_tongtientra_tru_phith}    Should Be Equal As Numbers    ${get_khach_tt_af_ex}    0
    ...    ELSE    Should Be Equal As Numbers    ${get_khach_tt_af_ex}    ${actual_khtt}
    Should Be Equal As Strings    ${get_ma_kh_by_hd_af_ex}    ${input_ma_kh}
    Should Be Equal As Strings    ${get_trangthai_af_ex}    Hoàn thành
    #assert customer and so quy
    ${get_no_af_execute_kh}    Get Du no cuoi KH from API    ${input_ma_kh}
    Should Be Equal As Numbers    ${get_no_af_execute_kh}    ${result_PTT_dth_KH}
    #tat thu khac
    : FOR    ${item_thukhac}    ${item_value}    IN ZIP    ${list_thukhac}    ${list_actual_surcharge_value}
    \    Run Keyword If    ${item_value} > 100    Toggle surcharge VND    ${item_thukhac}    false
    \    ...    ELSE    Toggle surcharge percentage    ${item_thukhac}    false
