*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    ${headless_browser}
Test Teardown     After Test
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

*** Variables ***
&{list_productnums_TH1}    DTH005=100
&{list_productnums_TH2}    DTH006=2
&{list_productnums_TH3}    DTH007=3
&{list_productnums_TH4}    DTH008=50
&{list_productnums_DTH01}    DTH001=3    DTU001=2.4    DTDV1=1.25    DTCombo01=2
&{list_productnums_DTH02}    DTH002=3    QDDT3=2.4    DTDV2=1.25    DTCombo02=2
&{list_productnums_DTH03}    DTH003=3    QDDT6=2.4    DTDV3=1.25    DTCombo03=2
&{list_productnums_DTH04}    DTH004=3    DTU004=2.4    DTDV4=1.25    DTCombo04=2
&{list_imei_dth1}    DTS01=1
&{list_imei_dth2}    DTS02=1
&{list_imei_dth3}    DTS03=1
&{list_imei_dth4}    DTS04=1
@{list_discount}    0    600000    3500    6100
@{list_discount_type}   none    changeup     disvnd    changedown
@{list_surcharge}    TK008      TK004
@{list_surcharge1}    TK001      TK005

*** Test Cases ***    Mã KH         List product trả hàng      List product đổi trả hàng    List imei            Phí trả hàng    List GGSP      List discount type           GGSP IMEI    Discount type imei        GGDTH    Khách thanh toán    KTT hóa đơn    Thu khác
Khongtudong_1thu khac              [Tags]        UETDS
                      [Template]    edts01
                      CTKH044       ${list_productnums_TH1}    ${list_productnums_DTH01}    ${list_imei_dth1}    15              ${list_discount}     ${list_discount_type}       0         none             0        0                   100000           TK008
                      CTKH044       ${list_productnums_TH1}    ${list_productnums_DTH01}    ${list_imei_dth1}    10000           ${list_discount}     ${list_discount_type}       14       dis          0        all                 100000           TK004

Khongtudong_2thukhac             [Tags]        UETDS
                      [Template]    edts02
                      CTKH045       ${list_productnums_TH2}    ${list_productnums_DTH02}    ${list_imei_dth2}    0              ${list_discount}     ${list_discount_type}      20000      disvnd          10000        100000         0         ${list_surcharge}

Tudong_1thukhac             [Tags]        UETDS
                      [Template]    edts03
                      CTKH046       ${list_productnums_TH3}    ${list_productnums_DTH03}    ${list_imei_dth3}    20000              ${list_discount}     ${list_discount_type}      20      dis          15        0         all         TK001

Tudong_2thukhac            [Tags]        UETDS
                      [Template]    edts04
                      CTKH047       ${list_productnums_TH4}    ${list_productnums_DTH04}    ${list_imei_dth4}    20              ${list_discount}     ${list_discount_type}      15000      disvnd          20000        300000         100000        ${list_surcharge1}

*** Keywords ***
edts01
    [Arguments]    ${input_ma_kh}    ${dic_productnums_th}    ${dic_productnums_dth}    ${list_imei_nums}    ${input_phi_th}    ${list_ggsp}    ${list_discounttype}
    ...    ${input_ggsp_imei}   ${discount_type_imei}    ${input_ggdth}    ${input_khtt}    ${input_khtt_hd}  ${input_thukhac}
    ${list_product_dth}    Get Dictionary Keys    ${dic_productnums_dth}
    ${list_nums_dth}    Get Dictionary Values    ${dic_productnums_dth}
    ${list_imei_product_dth}    Get Dictionary Keys    ${list_imei_nums}
    ${list_imei_nums_dth}    Get Dictionary Values    ${list_imei_nums}
    ${input_product_imei}    ${input_imei_nums}    Convert two list to string and return    ${list_imei_product_dth}    ${list_imei_nums_dth}
    Create list imei    ${list_imei_product_dth}    ${list_imei_nums_dth}
    ${get_ma_hd}    Add new invoice frm API    ${input_ma_kh}    ${dic_productnums_th}    ${input_khtt_hd}
    ${surcharge_vnd_value}    Get surcharge vnd value    ${input_thukhac}
    ${surcharge_%}    Get surcharge percentage value    ${input_thukhac}
    Run Keyword If    ${surcharge_%} == 0    Toggle surcharge VND    ${input_thukhac}    true
    ...    ELSE    Toggle surcharge percentage    ${input_thukhac}    true
    #get data frm Trả hàng
    Sleep    5s
    ${get_ma_kh_by_hd_bf_ex}    ${get_tong_tien_hang_bf_ex}    ${get_khach_tt_bf_ex}    ${get_trangthai_bf_ex}    Get invoice info by invoice code    ${get_ma_hd}
    ${get_list_hh_in_hd}    ${get_list_sl_in_hd}    Get list product and quantity frm invoice API    ${get_ma_hd}
    ${get_list_sl_in_hd}    Convert String to List    ${get_list_sl_in_hd}
    ${list_result_thanhtien_th}    ${list_giavon_th}    ${list_result_toncuoi_th}    Get list total sale - endingstock - cost frm product api    ${get_list_hh_in_hd}    ${get_list_sl_in_hd}
    ${get_list_baseprice}    Get list of Baseprice by Product Code    ${list_product_dth}
    #input product into DTH form
    Wait Until Keyword Succeeds    3 times    8 s    Before Test Ban Hang deactivate print warranty
    Select Invoice from Ban Hang page    ${get_ma_hd}
    ${laster_nums}    Set Variable    0
    : FOR    ${item_hh}    ${item_soluong}    IN ZIP    ${get_list_hh_in_hd}    ${get_list_sl_in_hd}
    \    ${laster_number}    Input nums for multi product    ${item_hh}    ${item_soluong}    ${laster_nums}    ${cell_laster_numbers_return}
    ${laster_nums1}    Set Variable    0
    : FOR    ${item_product_dth}    ${item_nums_dth}    ${item_giaban}    ${item_ggsp}    ${discount_type}    IN ZIP    ${list_product_dth}
    ...    ${list_nums_dth}    ${get_list_baseprice}    ${list_ggsp}    ${list_discounttype}
    \    ${laster_nums1}    Wait Until Keyword Succeeds    3 times    5 s    Input product and nums into Doi tra hang form    ${item_product_dth}    ${item_nums_dth}
    \    ...    ${laster_nums1}
    \    ${newprice}    Run Keyword If    '${discount_type}' == 'dis'     Price after % discount product    ${item_giaban}    ${item_ggsp}
    \    ...    ELSE IF    '${discount_type}' == 'disvnd'    Minus    ${item_giaban}    ${item_ggsp}
    \    ...    ELSE IF    '${discount_type}' == 'changeup' or '${discount_type}' == 'changedown'  Set Variable   ${item_ggsp}    ELSE    Set Variable    ${item_giaban}
    \    Run keyword if    '${discount_type}' == 'dis'     Wait Until Keyword Succeeds    3 times    5 s    Input % discount for multi product
    \    ...    ${item_product_dth}    ${item_ggsp}    ${newprice}    ELSE IF    '${discount_type}' == 'disvnd'   Wait Until Keyword Succeeds    3 times    5 s        Input VND discount for multi product    ${item_product_dth}
    \    ...    ${item_ggsp}    ${newprice}
    \    ...    ELSE IF    '${discount_type}' == 'changeup' or '${discount_type}' == 'changedown'  Wait Until Keyword Succeeds    3 times    5 s    Input newprice for multi product    ${item_product_dth}   ${item_ggsp}
    \    ...    ELSE    Log    Ignore input
    : FOR    ${item_product_imei}    ${item_imei}    IN ZIP    ${list_imei_product_dth}    ${imei_inlist}
    \    Wait Until Keyword Succeeds    3 times    8 s    Input product and imei incase multi product to any form    ${textbox_th_search_hangdoi}    ${item_product_imei}
    \    ...    ${cell_dth_sanpham}    ${textbox_dth_nhap_serial}    ${item_dth_imei_in_dropdown}    ${cell_dth_ma_sanpham}    ${cell_dth_imei_multi_product}
    \    ...    @{item_imei}
    ${newprice_imei}    Computation price incase discount by product code    ${input_product_imei}    ${input_ggsp_imei}
    Run keyword if    '${discount_type_imei}' == 'dis'    Wait Until Keyword Succeeds    3 times    5 s        Input % discount for multi product    ${input_product_imei}
    ...    ${input_ggsp_imei}    ${newprice_imei}
    ...    ELSE IF   '${discount_type_imei}' == 'disvnd'    Wait Until Keyword Succeeds    3 times    5 s    Input VND discount for multi product    ${input_product_imei}    ${input_ggsp_imei}    ${newprice_imei}
    ...    ELSE IF    '${discount_type_imei}' == 'changeup' or '${discount_type_imei}' == 'changedown'  Wait Until Keyword Succeeds    3 times    5 s    Input newprice for multi product    ${input_product_imei}    ${input_ggsp_imei}
    ...    ELSE    Log    Ignore input
    #get data frm Doi hang
    Append To List    ${list_product_dth}    ${input_product_imei}
    Append to List    ${list_nums_dth}    ${input_imei_nums}
    Append to List    ${list_ggsp}    ${input_ggsp_imei}
    Append to List    ${list_discounttype}    ${discount_type_imei}
    ${list_result_thanhtien_dth}    ${list_giavon_dth}    ${list_result_toncuoi_dth}    Get list total sale - endingstock - cost incase discount and newprice with additional invoice    ${list_product_dth}
    ...    ${list_nums_dth}    ${list_ggsp}    ${list_discounttype}
    #compute trả hàng
    ${result_tongtientra}    Sum values in list    ${list_result_thanhtien_th}
    ${result_phi_th}    Run Keyword If    0 < ${input_phi_th} < 100    Convert % discount to VND and round    ${result_tongtientra}    ${input_phi_th}
    ...    ELSE    Set Variable    ${input_phi_th}
    ${result_tongtientra_tru_phith}    Minus and round 2    ${result_tongtientra}    ${result_phi_th}
    #compute mua hàng
    ${result_tongtienmua}    Sum values in list    ${list_result_thanhtien_dth}
    ${result_ggdth}    Run Keyword If    0 < ${input_ggdth} < 100    Convert % discount to VND and round    ${result_tongtienmua}    ${input_ggdth}
    ...    ELSE    Set Variable    ${input_ggdth}
    ${result_tongtienmua_tru_gg}    Minus and round 2    ${result_tongtienmua}    ${result_ggdth}
    ${actual_surcharge_type}    Set Variable If    ${surcharge_%} == 0    ${surcharge_vnd_value}    ${surcharge_%}
    ${result_per_surchare_by_invoice}    Convert % discount to VND and round    ${result_tongtienmua_tru_gg}    ${surcharge_%}
    ${actual_surcharge_value}    Set Variable If    ${surcharge_%} == 0    ${surcharge_vnd_value}    ${result_per_surchare_by_invoice}
    ${result_tongtienmua_thukhac}    sum    ${result_tongtienmua_tru_gg}    ${actual_surcharge_value}
    ${result_khachthanhtoan}    Minus and round 2    ${result_tongtienmua_thukhac}    ${result_tongtientra_tru_phith}
    ${result_cantrakhach}    Minus and round 2    ${result_tongtientra_tru_phith}    ${result_tongtienmua_thukhac}
    ${result_kh_canthanhtoan}    Set Variable If    ${result_tongtienmua_thukhac}<${result_tongtientra_tru_phith}    ${result_cantrakhach}    ${result_khachthanhtoan}
    ${result_khtt}    Set Variable If    "${input_khtt}" == "all"    ${result_kh_canthanhtoan}    ${input_khtt}
    ${actual_khtt}    Set Variable If    "${input_khtt}" == "0"    0    ${result_khtt}
    ${actuall_trahang}    Set Variable If    ${result_tongtienmua_tru_gg}<${result_tongtientra_tru_phith}    ${actual_khtt}    0
    #create đổi trả hàng
    Wait Until Keyword Succeeds    3 times    5 s    Select one surcharge by pressing Enter    ${input_thukhac}    ${actual_surcharge_value}    ${cell_surcharge_doitra_value}
    ${button_thanhtoan}    Set Variable If    ${result_tongtienmua_thukhac}<${result_tongtientra_tru_phith}    ${textbox_dth_tientrakhach}    ${textbox_dth_khachthanhtoan}
    Wait Until Keyword Succeeds    3 times    5 s    Run keyword if    0 < ${input_phi_th} < 100    Input % return free value    ${input_phi_th}
    ...    ${result_phi_th}
    ...    ELSE    Input VND return free value    ${input_phi_th}
    Wait Until Keyword Succeeds    3 times    5 s    Run Keyword If    0 < ${input_ggdth} < 100    Input % discount additional invoice    ${input_ggdth}
    ...    ${result_ggdth}
    ...    ELSE    Input VND discount additional invoice    ${input_ggdth}
    ${button_thanhtoan}    Set Variable If    ${result_tongtienmua_tru_gg}<${result_tongtientra_tru_phith}    ${textbox_dth_tientrakhach}    ${textbox_dth_khachthanhtoan}
    Run Keyword If    "${input_khtt}" == "all"    Click Element JS    ${button_th}
    ...    ELSE    Input payment into any form    ${button_thanhtoan}    ${input_khtt}    ${button_th}
    Return message success validation
    ${return_code}    Wait Until Keyword Succeeds    3 times    5 s    Get saved code after execute
    Execute Javascript    location.reload();
    Sleep    20 s    wait for response to API
    #assert value product trả hàng
    ${get_list_hh_in_th_af_execute}    Get list product frm Return API    ${return_code}
    ${get_list_hh_in_th_af_execute}    Reverse List one    ${get_list_hh_in_th_af_execute}
    ${list_soluong_in_th}    ${list_giatriquydoi_in_th}    Get list quantity and gia tri quy doi with return have multi product    ${get_list_hh_in_th_af_execute}    ${return_code}
    : FOR    ${item_ma_hh}    ${result_toncuoi}    ${item_giavon}    ${get_soluong_in_th}    ${get_giatri_quydoi_th}    IN ZIP
    ...    ${get_list_hh_in_th_af_execute}    ${list_result_toncuoi_th}    ${list_giavon_th}    ${list_soluong_in_th}    ${list_giatriquydoi_in_th}
    \    Run Keyword If    '${get_giatri_quydoi_th}' == '1'    Validate onhand and cost frm API    ${return_code}    ${item_ma_hh}    ${result_toncuoi}
    \    ...    ${item_giavon}    ${get_soluong_in_th}
    \    ...    ELSE    Validate onhand and cost frm unit product    ${return_code}    ${item_ma_hh}    ${result_toncuoi}
    \    ...    ${item_giavon}    ${get_soluong_in_th}    ${get_giatri_quydoi_th}
    #assert value product đổi trả hàng
    ${get_additional_invoice_code}    Get additional invoice code by return code    ${return_code}
    ${get_list_hh_in_dth_af_execute}    Get list product after create invoice    ${get_additional_invoice_code}
    ${get_list_hh_in_dth_af_execute}    Reverse List one    ${get_list_hh_in_dth_af_execute}
    ${list_soluong_in_dth}    ${list_giatriquydoi_in_dth}    Get list quantity and gia tri quy doi frm additional invoice code    ${get_list_hh_in_dth_af_execute}    ${get_additional_invoice_code}
    : FOR    ${item_ma_hh}    ${result_toncuoi}    ${item_giavon}    ${get_soluong_in_dth}    ${get_giatri_quydoi_dth}    IN ZIP
    ...    ${get_list_hh_in_dth_af_execute}    ${list_result_toncuoi_dth}    ${list_giavon_dth}    ${list_soluong_in_dth}    ${list_giatriquydoi_in_dth}
    \    Run Keyword If    '${get_giatri_quydoi_dth}' == '1'    Validate onhand and cost frm API    ${get_additional_invoice_code}    ${item_ma_hh}    ${result_toncuoi}
    \    ...    ${item_giavon}    ${get_soluong_in_dth}
    \    ...    ELSE    Validate onhand and cost frm unit product    ${get_additional_invoice_code}    ${item_ma_hh}    ${result_toncuoi}
    \    ...    ${item_giavon}    ${get_soluong_in_dth}    ${get_giatri_quydoi_dth}
    #assert value in invoice
    ${get_ma_kh_by_hd_af_ex}    ${get_tong_tien_hang_af_ex}    ${get_khach_tt_af_ex}    ${get_trangthai_af_ex}    Get invoice info by invoice code    ${get_ma_hd}
    Should Be Equal As Numbers    ${get_tong_tien_hang_af_ex}    ${get_tong_tien_hang_bf_ex}
    Should Be Equal As Numbers    ${get_khach_tt_af_ex}    ${get_khach_tt_bf_ex}
    Should Be Equal As Strings    ${get_ma_kh_by_hd_af_ex}    ${get_ma_kh_by_hd_bf_ex}
    Should Be Equal As Strings    ${get_trangthai_af_ex}    ${get_trangthai_bf_ex}
    #assert value in return
    ${get_tongtienhangtra_af_ex}    ${get_phitrahang_af_ex}    ${get_cantrakhach_af_ex}    ${get_datrakhach_af_ex}    ${get_tongtien_hoadontra_af_ex}    Get return info by return code    ${return_code}
    Should Be Equal As Numbers    ${get_tongtienhangtra_af_ex}    ${result_tongtientra}
    Should Be Equal As Numbers    ${get_phitrahang_af_ex}    ${result_phi_th}
    Run Keyword If    ${result_cantrakhach}>0    Should Be Equal As Numbers    ${get_cantrakhach_af_ex}    ${result_cantrakhach}    ELSE   Should Be Equal As Numbers    ${get_cantrakhach_af_ex}    0
    Should Be Equal As Numbers    ${get_datrakhach_af_ex}    ${actuall_trahang}
    Should Be Equal As Numbers    ${get_tongtien_hoadontra_af_ex}    ${result_tongtientra_tru_phith}
    Validate return history by invoice code    ${get_ma_hd}    ${return_code}    ${result_tongtientra}
    #assert value in đổi hàng
    ${get_ma_kh_by_hd_af_ex}    ${get_tong_tien_hang_af_ex}    ${get_khach_tt_af_ex}    ${get_giamgia_hd_af_ex}    ${get_khach_can_tra_af_ex}    ${get_trangthai_af_ex}    Get additional invoice info incase discount by additional invoice code
    ...    ${get_additional_invoice_code}
    Should Be Equal As Numbers    ${get_tong_tien_hang_af_ex}    ${result_tongtienmua_thukhac}
    Run Keyword If    ${result_tongtienmua_thukhac}<${result_tongtientra_tru_phith}    Should Be Equal As Numbers    ${get_khach_can_tra_af_ex}    0
    ...    ELSE    Should Be Equal As Numbers    ${get_khach_can_tra_af_ex}    ${result_kh_canthanhtoan}
    Should Be Equal As Numbers    ${get_giamgia_hd_af_ex}    ${result_ggdth}
    Run Keyword If    ${result_tongtienmua_thukhac}<${result_tongtientra_tru_phith}    Should Be Equal As Numbers    ${get_khach_tt_af_ex}    0
    ...    ELSE    Should Be Equal As Numbers    ${get_khach_tt_af_ex}    ${actual_khtt}
    Should Be Equal As Strings    ${get_ma_kh_by_hd_af_ex}    ${input_ma_kh}
    Should Be Equal As Strings    ${get_trangthai_af_ex}    Hoàn thành
    Remove From List    ${list_ggsp}    -1
    Remove From List    ${list_product_dth}    -1
    Remove From List    ${list_nums_dth}    -1
    Remove From List    ${list_discounttype}    -1
    Delete return thr API    ${return_code}
    Delete invoice by invoice code    ${get_ma_hd}
    Run Keyword If    ${surcharge_%} == 0    Toggle surcharge VND    ${input_thukhac}    false
    ...    ELSE    Toggle surcharge percentage    ${input_thukhac}    false

edts02
    [Arguments]    ${input_ma_kh}    ${dic_productnums_th}    ${dic_productnums_dth}    ${list_imei_nums}    ${input_phi_th}    ${list_ggsp}    ${list_discounttype}
    ...    ${input_ggsp_imei}   ${discount_type_imei}    ${input_ggdth}    ${input_khtt}    ${input_khtt_hd}  ${list_thukhac}
    ${list_product_dth}    Get Dictionary Keys    ${dic_productnums_dth}
    ${list_nums_dth}    Get Dictionary Values    ${dic_productnums_dth}
    ${list_imei_product_dth}    Get Dictionary Keys    ${list_imei_nums}
    ${list_imei_nums_dth}    Get Dictionary Values    ${list_imei_nums}
    ${input_product_imei}    ${input_imei_nums}    Convert two list to string and return    ${list_imei_product_dth}    ${list_imei_nums_dth}
    Create list imei    ${list_imei_product_dth}    ${list_imei_nums_dth}
    ${get_ma_hd}    Add new invoice frm API    ${input_ma_kh}    ${dic_productnums_th}    ${input_khtt_hd}
    ${list_actual_surcharge_value}    Create List
    : FOR    ${item_thukhac}    IN ZIP    ${list_thukhac}
    \    ${surcharge_value_vnd}    Get surcharge vnd value    ${item_thukhac}
    \    ${surcharge_value_percentage}    Get surcharge percentage value    ${item_thukhac}
    \    ${actual_surcharge_value}    Set Variable If    ${surcharge_value_percentage} == 0    ${surcharge_value_vnd}    ${surcharge_value_percentage}
    \    Run Keyword If    ${actual_surcharge_value} > 100    Toggle surcharge VND    ${item_thukhac}    true
    \    ...    ELSE    Toggle surcharge percentage    ${item_thukhac}    true
    \    Append To List    ${list_actual_surcharge_value}    ${actual_surcharge_value}
    Log    ${list_actual_surcharge_value}
    #get data frm Trả hàng
    Sleep    5s
    ${get_ma_kh_by_hd_bf_ex}    ${get_tong_tien_hang_bf_ex}    ${get_khach_tt_bf_ex}    ${get_trangthai_bf_ex}    Get invoice info by invoice code    ${get_ma_hd}
    ${get_list_hh_in_hd}    ${get_list_sl_in_hd}    Get list product and quantity frm invoice API    ${get_ma_hd}
    ${get_list_sl_in_hd}    Convert String to List    ${get_list_sl_in_hd}
    ${list_result_thanhtien_th}    ${list_giavon_th}    ${list_result_toncuoi_th}    Get list total sale - endingstock - cost frm product api    ${get_list_hh_in_hd}    ${get_list_sl_in_hd}
    ${get_list_baseprice}    Get list of Baseprice by Product Code    ${list_product_dth}
    #input product into DTH form
    Wait Until Keyword Succeeds    3 times    8 s    Before Test Ban Hang deactivate print warranty
    Select Invoice from Ban Hang page    ${get_ma_hd}
    ${laster_nums}    Set Variable    0
    : FOR    ${item_hh}    ${item_soluong}    IN ZIP    ${get_list_hh_in_hd}    ${get_list_sl_in_hd}
    \    ${laster_number}    Input nums for multi product    ${item_hh}    ${item_soluong}    ${laster_nums}    ${cell_laster_numbers_return}
    ${laster_nums1}    Set Variable    0
    : FOR    ${item_product_dth}    ${item_nums_dth}    ${item_giaban}    ${item_ggsp}    ${discount_type}    IN ZIP    ${list_product_dth}
    ...    ${list_nums_dth}    ${get_list_baseprice}    ${list_ggsp}    ${list_discounttype}
    \    ${laster_nums1}    Wait Until Keyword Succeeds    3 times    5 s    Input product and nums into Doi tra hang form    ${item_product_dth}    ${item_nums_dth}
    \    ...    ${laster_nums1}
    \    ${newprice}    Run Keyword If    '${discount_type}' == 'dis'     Price after % discount product    ${item_giaban}    ${item_ggsp}
    \    ...    ELSE IF    '${discount_type}' == 'disvnd'    Minus    ${item_giaban}    ${item_ggsp}
    \    ...    ELSE IF    '${discount_type}' == 'changeup' or '${discount_type}' == 'changedown'  Set Variable   ${item_ggsp}    ELSE    Set Variable    ${item_giaban}
    \    Run keyword if    '${discount_type}' == 'dis'     Wait Until Keyword Succeeds    3 times    5 s    Input % discount for multi product
    \    ...    ${item_product_dth}    ${item_ggsp}    ${newprice}    ELSE IF    '${discount_type}' == 'disvnd'   Wait Until Keyword Succeeds    3 times    5 s        Input VND discount for multi product    ${item_product_dth}
    \    ...    ${item_ggsp}    ${newprice}
    \    ...    ELSE IF    '${discount_type}' == 'changeup' or '${discount_type}' == 'changedown'  Wait Until Keyword Succeeds    3 times    5 s    Input newprice for multi product    ${item_product_dth}   ${item_ggsp}
    \    ...    ELSE    Log    Ignore input
    : FOR    ${item_product_imei}    ${item_imei}    IN ZIP    ${list_imei_product_dth}    ${imei_inlist}
    \    Wait Until Keyword Succeeds    3 times    8 s    Input product and imei incase multi product to any form    ${textbox_th_search_hangdoi}    ${item_product_imei}
    \    ...    ${cell_dth_sanpham}    ${textbox_dth_nhap_serial}    ${item_dth_imei_in_dropdown}    ${cell_dth_ma_sanpham}    ${cell_dth_imei_multi_product}
    \    ...    @{item_imei}
    ${newprice_imei}    Computation price incase discount by product code    ${input_product_imei}    ${input_ggsp_imei}
    Run keyword if    '${discount_type_imei}' == 'dis'    Wait Until Keyword Succeeds    3 times    5 s        Input % discount for multi product    ${input_product_imei}
    ...    ${input_ggsp_imei}    ${newprice_imei}
    ...    ELSE IF   '${discount_type_imei}' == 'disvnd'    Wait Until Keyword Succeeds    3 times    5 s    Input VND discount for multi product    ${input_product_imei}    ${input_ggsp_imei}    ${newprice_imei}
    ...    ELSE IF    '${discount_type_imei}' == 'changeup' or '${discount_type_imei}' == 'changedown'  Wait Until Keyword Succeeds    3 times    5 s    Input newprice for multi product    ${input_product_imei}    ${input_ggsp_imei}
    ...    ELSE    Log    Ignore input
    #get data frm Doi hang
    Append To List    ${list_product_dth}    ${input_product_imei}
    Append to List    ${list_nums_dth}    ${input_imei_nums}
    Append to List    ${list_ggsp}    ${input_ggsp_imei}
    Append to List    ${list_discounttype}    ${discount_type_imei}
    ${list_result_thanhtien_dth}    ${list_giavon_dth}    ${list_result_toncuoi_dth}    Get list total sale - endingstock - cost incase discount and newprice with additional invoice    ${list_product_dth}
    ...    ${list_nums_dth}    ${list_ggsp}    ${list_discounttype}
    #compute trả hàng
    ${result_tongtientra}    Sum values in list    ${list_result_thanhtien_th}
    ${result_phi_th}    Run Keyword If    0 < ${input_phi_th} < 100    Convert % discount to VND and round    ${result_tongtientra}    ${input_phi_th}
    ...    ELSE    Set Variable    ${input_phi_th}
    ${result_tongtientra_tru_phith}    Minus and round 2    ${result_tongtientra}    ${result_phi_th}
    #compute mua hàng
    ${result_tongtienmua}    Sum values in list    ${list_result_thanhtien_dth}
    ${result_ggdth}    Run Keyword If    0 < ${input_ggdth} < 100    Convert % discount to VND and round    ${result_tongtienmua}    ${input_ggdth}
    ...    ELSE    Set Variable    ${input_ggdth}
    ${result_tongtienmua_tru_gg}    Minus and round 2    ${result_tongtienmua}    ${result_ggdth}
    ${list_result_thukhac}    Create List
    : FOR    ${item_value}    IN ZIP    ${list_actual_surcharge_value}
    \    ${result_thukhac}    Run Keyword If    ${item_value}>100    Set Variable    ${item_value}
    \    ...    ELSE    Convert % discount to VND and round    ${item_value}    ${result_tongtienmua_tru_gg}
    \    Append To List    ${list_result_thukhac}    ${result_thukhac}
    Log    ${list_result_thukhac}
    ${total_surcharge}    Sum values in list    ${list_result_thukhac}
    ${result_tongtienmua_thukhac}    sum    ${result_tongtienmua_tru_gg}    ${total_surcharge}
    ${result_khachthanhtoan}    Minus and round 2    ${result_tongtienmua_thukhac}    ${result_tongtientra_tru_phith}
    ${result_cantrakhach}    Minus and round 2    ${result_tongtientra_tru_phith}    ${result_tongtienmua_thukhac}
    ${result_kh_canthanhtoan}    Set Variable If    ${result_tongtienmua_thukhac}<${result_tongtientra_tru_phith}    ${result_cantrakhach}    ${result_khachthanhtoan}
    ${result_khtt}    Set Variable If    "${input_khtt}" == "all"    ${result_kh_canthanhtoan}    ${input_khtt}
    ${actual_khtt}    Set Variable If    "${input_khtt}" == "0"    0    ${result_khtt}
    ${actuall_trahang}    Set Variable If    ${result_tongtienmua_tru_gg}<${result_tongtientra_tru_phith}    ${actual_khtt}    0
    ${result_tongtienmua_tovalidate}    Sum    ${result_tongtienmua}    ${total_surcharge}
    #create đổi trả hàng
    Wait Until Keyword Succeeds    3 times    5 s    Run keyword if    0 < ${input_phi_th} < 100    Input % return free value    ${input_phi_th}
    ...    ${result_phi_th}    ELSE    Input VND return free value    ${input_phi_th}
    Wait Until Keyword Succeeds    3 times    5 s    Run Keyword If    0 < ${input_ggdth} < 100    Input % discount additional invoice    ${input_ggdth}
    ...    ${result_ggdth}    ELSE    Input VND discount additional invoice    ${input_ggdth}
    Wait Until Keyword Succeeds    3 times    5 s    Select list surcharge by pressing Enter    ${list_thukhac}    ${total_surcharge}    ${cell_surcharge_doitra_value}
    ${button_thanhtoan}    Set Variable If    ${result_tongtienmua_thukhac}<${result_tongtientra_tru_phith}    ${textbox_dth_tientrakhach}    ${textbox_dth_khachthanhtoan}
    ${button_thanhtoan}    Set Variable If    ${result_tongtienmua_thukhac}<${result_tongtientra_tru_phith}    ${textbox_dth_tientrakhach}    ${textbox_dth_khachthanhtoan}
    Run Keyword If    "${input_khtt}" == "all"    Click Element JS    ${button_th}
    ...    ELSE    Input payment into any form    ${button_thanhtoan}    ${input_khtt}    ${button_th}
    Return message success validation
    ${return_code}    Wait Until Keyword Succeeds    3 times    5 s    Get saved code after execute
    Execute Javascript    location.reload();
    Sleep    20 s    wait for response to API
    #assert value product trả hàng
    ${get_list_hh_in_th_af_execute}    Get list product frm Return API    ${return_code}
    ${get_list_hh_in_th_af_execute}    Reverse List one    ${get_list_hh_in_th_af_execute}
    ${list_soluong_in_th}    ${list_giatriquydoi_in_th}    Get list quantity and gia tri quy doi with return have multi product    ${get_list_hh_in_th_af_execute}    ${return_code}
    : FOR    ${item_ma_hh}    ${result_toncuoi}    ${item_giavon}    ${get_soluong_in_th}    ${get_giatri_quydoi_th}    IN ZIP
    ...    ${get_list_hh_in_th_af_execute}    ${list_result_toncuoi_th}    ${list_giavon_th}    ${list_soluong_in_th}    ${list_giatriquydoi_in_th}
    \    Run Keyword If    '${get_giatri_quydoi_th}' == '1'    Validate onhand and cost frm API    ${return_code}    ${item_ma_hh}    ${result_toncuoi}
    \    ...    ${item_giavon}    ${get_soluong_in_th}
    \    ...    ELSE    Validate onhand and cost frm unit product    ${return_code}    ${item_ma_hh}    ${result_toncuoi}
    \    ...    ${item_giavon}    ${get_soluong_in_th}    ${get_giatri_quydoi_th}
    #assert value product đổi trả hàng
    ${get_additional_invoice_code}    Get additional invoice code by return code    ${return_code}
    ${get_list_hh_in_dth_af_execute}    Get list product after create invoice    ${get_additional_invoice_code}
    ${get_list_hh_in_dth_af_execute}    Reverse List one    ${get_list_hh_in_dth_af_execute}
    ${list_soluong_in_dth}    ${list_giatriquydoi_in_dth}    Get list quantity and gia tri quy doi frm additional invoice code    ${get_list_hh_in_dth_af_execute}    ${get_additional_invoice_code}
    : FOR    ${item_ma_hh}    ${result_toncuoi}    ${item_giavon}    ${get_soluong_in_dth}    ${get_giatri_quydoi_dth}    IN ZIP
    ...    ${get_list_hh_in_dth_af_execute}    ${list_result_toncuoi_dth}    ${list_giavon_dth}    ${list_soluong_in_dth}    ${list_giatriquydoi_in_dth}
    \    Run Keyword If    '${get_giatri_quydoi_dth}' == '1'    Validate onhand and cost frm API    ${get_additional_invoice_code}    ${item_ma_hh}    ${result_toncuoi}
    \    ...    ${item_giavon}    ${get_soluong_in_dth}
    \    ...    ELSE    Validate onhand and cost frm unit product    ${get_additional_invoice_code}    ${item_ma_hh}    ${result_toncuoi}
    \    ...    ${item_giavon}    ${get_soluong_in_dth}    ${get_giatri_quydoi_dth}
    #assert value in invoice
    ${get_ma_kh_by_hd_af_ex}    ${get_tong_tien_hang_af_ex}    ${get_khach_tt_af_ex}    ${get_trangthai_af_ex}    Get invoice info by invoice code    ${get_ma_hd}
    Should Be Equal As Numbers    ${get_tong_tien_hang_af_ex}    ${get_tong_tien_hang_bf_ex}
    Should Be Equal As Numbers    ${get_khach_tt_af_ex}    ${get_khach_tt_bf_ex}
    Should Be Equal As Strings    ${get_ma_kh_by_hd_af_ex}    ${get_ma_kh_by_hd_bf_ex}
    Should Be Equal As Strings    ${get_trangthai_af_ex}    ${get_trangthai_bf_ex}
    #assert value in return
    ${get_tongtienhangtra_af_ex}    ${get_phitrahang_af_ex}    ${get_cantrakhach_af_ex}    ${get_datrakhach_af_ex}    ${get_tongtien_hoadontra_af_ex}    Get return info by return code    ${return_code}
    Should Be Equal As Numbers    ${get_tongtienhangtra_af_ex}    ${result_tongtientra}
    Should Be Equal As Numbers    ${get_phitrahang_af_ex}    ${result_phi_th}
    Run Keyword If    ${result_cantrakhach}>0    Should Be Equal As Numbers    ${get_cantrakhach_af_ex}    ${result_cantrakhach}    ELSE   Should Be Equal As Numbers    ${get_cantrakhach_af_ex}    0
    Should Be Equal As Numbers    ${get_datrakhach_af_ex}    ${actuall_trahang}
    Should Be Equal As Numbers    ${get_tongtien_hoadontra_af_ex}    ${result_tongtientra_tru_phith}
    Validate return history by invoice code    ${get_ma_hd}    ${return_code}    ${result_tongtientra}
    #assert value in đổi hàng
    ${get_ma_kh_by_hd_af_ex}    ${get_tong_tien_hang_af_ex}    ${get_khach_tt_af_ex}    ${get_giamgia_hd_af_ex}    ${get_khach_can_tra_af_ex}    ${get_trangthai_af_ex}    Get additional invoice info incase discount by additional invoice code
    ...    ${get_additional_invoice_code}
    Should Be Equal As Numbers    ${get_tong_tien_hang_af_ex}    ${result_tongtienmua_tovalidate}
    Run Keyword If    ${result_tongtienmua_thukhac}<${result_tongtientra_tru_phith}    Should Be Equal As Numbers    ${get_khach_can_tra_af_ex}    0
    ...    ELSE    Should Be Equal As Numbers    ${get_khach_can_tra_af_ex}    ${result_kh_canthanhtoan}
    Should Be Equal As Numbers    ${get_giamgia_hd_af_ex}    ${result_ggdth}
    Run Keyword If    ${result_tongtienmua_thukhac}<${result_tongtientra_tru_phith}    Should Be Equal As Numbers    ${get_khach_tt_af_ex}    0
    ...    ELSE    Should Be Equal As Numbers    ${get_khach_tt_af_ex}    ${actual_khtt}
    Should Be Equal As Strings    ${get_ma_kh_by_hd_af_ex}    ${input_ma_kh}
    Should Be Equal As Strings    ${get_trangthai_af_ex}    Hoàn thành
    Delete return thr API    ${return_code}
    Delete invoice by invoice code    ${get_ma_hd}
    : FOR    ${item_thukhac}    ${item_value}    IN ZIP    ${list_thukhac}    ${list_actual_surcharge_value}
    \    Run Keyword If    ${item_value} > 100    Toggle surcharge VND    ${item_thukhac}    false
    \    ...    ELSE    Toggle surcharge percentage    ${item_thukhac}    false

edts03
    [Arguments]    ${input_ma_kh}    ${dic_productnums_th}    ${dic_productnums_dth}    ${list_imei_nums}    ${input_phi_th}    ${list_ggsp}    ${list_discounttype}
    ...    ${input_ggsp_imei}   ${discount_type_imei}    ${input_ggdth}    ${input_khtt}    ${input_khtt_hd}  ${input_thukhac}
    ${list_product_dth}    Get Dictionary Keys    ${dic_productnums_dth}
    ${list_nums_dth}    Get Dictionary Values    ${dic_productnums_dth}
    ${list_imei_product_dth}    Get Dictionary Keys    ${list_imei_nums}
    ${list_imei_nums_dth}    Get Dictionary Values    ${list_imei_nums}
    ${input_product_imei}    ${input_imei_nums}    Convert two list to string and return    ${list_imei_product_dth}    ${list_imei_nums_dth}
    Create list imei    ${list_imei_product_dth}    ${list_imei_nums_dth}
    ${get_ma_hd}    Add new invoice frm API    ${input_ma_kh}    ${dic_productnums_th}    ${input_khtt_hd}
    ${surcharge_vnd_value}    Get surcharge vnd value    ${input_thukhac}
    ${surcharge_%}    Get surcharge percentage value    ${input_thukhac}
    Run Keyword If    ${surcharge_%} == 0    Toggle surcharge VND    ${input_thukhac}    true
    ...    ELSE    Toggle surcharge percentage    ${input_thukhac}    true
    #get data frm Trả hàng
    Sleep    5s
    ${get_ma_kh_by_hd_bf_ex}    ${get_tong_tien_hang_bf_ex}    ${get_khach_tt_bf_ex}    ${get_trangthai_bf_ex}    Get invoice info by invoice code    ${get_ma_hd}
    ${get_list_hh_in_hd}    ${get_list_sl_in_hd}    Get list product and quantity frm invoice API    ${get_ma_hd}
    ${get_list_sl_in_hd}    Convert String to List    ${get_list_sl_in_hd}
    ${list_result_thanhtien_th}    ${list_giavon_th}    ${list_result_toncuoi_th}    Get list total sale - endingstock - cost frm product api    ${get_list_hh_in_hd}    ${get_list_sl_in_hd}
    ${get_list_baseprice}    Get list of Baseprice by Product Code    ${list_product_dth}
    #input product into DTH form
    Wait Until Keyword Succeeds    3 times    8 s    Before Test Ban Hang deactivate print warranty
    Select Invoice from Ban Hang page    ${get_ma_hd}
    ${laster_nums}    Set Variable    0
    : FOR    ${item_hh}    ${item_soluong}    IN ZIP    ${get_list_hh_in_hd}    ${get_list_sl_in_hd}
    \    ${laster_number}    Input nums for multi product    ${item_hh}    ${item_soluong}    ${laster_nums}    ${cell_laster_numbers_return}
    ${laster_nums1}    Set Variable    0
    : FOR    ${item_product_dth}    ${item_nums_dth}    ${item_giaban}    ${item_ggsp}    ${discount_type}    IN ZIP    ${list_product_dth}
    ...    ${list_nums_dth}    ${get_list_baseprice}    ${list_ggsp}    ${list_discounttype}
    \    ${laster_nums1}    Wait Until Keyword Succeeds    3 times    5 s    Input product and nums into Doi tra hang form    ${item_product_dth}    ${item_nums_dth}
    \    ...    ${laster_nums1}
    \    ${newprice}    Run Keyword If    '${discount_type}' == 'dis'     Price after % discount product    ${item_giaban}    ${item_ggsp}
    \    ...    ELSE IF    '${discount_type}' == 'disvnd'    Minus    ${item_giaban}    ${item_ggsp}
    \    ...    ELSE IF    '${discount_type}' == 'changeup' or '${discount_type}' == 'changedown'  Set Variable   ${item_ggsp}    ELSE    Set Variable    ${item_giaban}
    \    Run keyword if    '${discount_type}' == 'dis'     Wait Until Keyword Succeeds    3 times    5 s    Input % discount for multi product
    \    ...    ${item_product_dth}    ${item_ggsp}    ${newprice}    ELSE IF    '${discount_type}' == 'disvnd'   Wait Until Keyword Succeeds    3 times    5 s        Input VND discount for multi product    ${item_product_dth}
    \    ...    ${item_ggsp}    ${newprice}
    \    ...    ELSE IF    '${discount_type}' == 'changeup' or '${discount_type}' == 'changedown'  Wait Until Keyword Succeeds    3 times    5 s    Input newprice for multi product    ${item_product_dth}   ${item_ggsp}
    \    ...    ELSE    Log    Ignore input
    : FOR    ${item_product_imei}    ${item_imei}    IN ZIP    ${list_imei_product_dth}    ${imei_inlist}
    \    Wait Until Keyword Succeeds    3 times    8 s    Input product and imei incase multi product to any form    ${textbox_th_search_hangdoi}    ${item_product_imei}
    \    ...    ${cell_dth_sanpham}    ${textbox_dth_nhap_serial}    ${item_dth_imei_in_dropdown}    ${cell_dth_ma_sanpham}    ${cell_dth_imei_multi_product}
    \    ...    @{item_imei}
    ${newprice_imei}    Computation price incase discount by product code    ${input_product_imei}    ${input_ggsp_imei}
    Run keyword if    '${discount_type_imei}' == 'dis'    Wait Until Keyword Succeeds    3 times    5 s        Input % discount for multi product    ${input_product_imei}
    ...    ${input_ggsp_imei}    ${newprice_imei}
    ...    ELSE IF   '${discount_type_imei}' == 'disvnd'    Wait Until Keyword Succeeds    3 times    5 s    Input VND discount for multi product    ${input_product_imei}    ${input_ggsp_imei}    ${newprice_imei}
    ...    ELSE IF    '${discount_type_imei}' == 'changeup' or '${discount_type_imei}' == 'changedown'  Wait Until Keyword Succeeds    3 times    5 s    Input newprice for multi product    ${input_product_imei}    ${input_ggsp_imei}
    ...    ELSE    Log    Ignore input
    #get data frm Doi hang
    Append To List    ${list_product_dth}    ${input_product_imei}
    Append to List    ${list_nums_dth}    ${input_imei_nums}
    Append to List    ${list_ggsp}    ${input_ggsp_imei}
    Append to List    ${list_discounttype}    ${discount_type_imei}
    ${list_result_thanhtien_dth}    ${list_giavon_dth}    ${list_result_toncuoi_dth}    Get list total sale - endingstock - cost incase discount and newprice with additional invoice    ${list_product_dth}
    ...    ${list_nums_dth}    ${list_ggsp}    ${list_discounttype}
    #compute trả hàng
    ${result_tongtientra}    Sum values in list    ${list_result_thanhtien_th}
    ${result_phi_th}    Run Keyword If    0 < ${input_phi_th} < 100    Convert % discount to VND and round    ${result_tongtientra}    ${input_phi_th}
    ...    ELSE    Set Variable    ${input_phi_th}
    ${result_tongtientra_tru_phith}    Minus and round 2    ${result_tongtientra}    ${result_phi_th}
    #compute mua hàng
    ${result_tongtienmua}    Sum values in list    ${list_result_thanhtien_dth}
    ${result_ggdth}    Run Keyword If    0 < ${input_ggdth} < 100    Convert % discount to VND and round    ${result_tongtienmua}    ${input_ggdth}
    ...    ELSE    Set Variable    ${input_ggdth}
    ${result_tongtienmua_tru_gg}    Minus and round 2    ${result_tongtienmua}    ${result_ggdth}
    ${actual_surcharge_type}    Set Variable If    ${surcharge_%} == 0    ${surcharge_vnd_value}    ${surcharge_%}
    ${result_per_surchare_by_invoice}    Convert % discount to VND and round    ${result_tongtienmua_tru_gg}    ${surcharge_%}
    ${actual_surcharge_value}    Set Variable If    ${surcharge_%} == 0    ${surcharge_vnd_value}    ${result_per_surchare_by_invoice}
    ${result_tongtienmua_thukhac}    sum    ${result_tongtienmua_tru_gg}    ${actual_surcharge_value}
    ${result_khachthanhtoan}    Minus and round 2    ${result_tongtienmua_thukhac}    ${result_tongtientra_tru_phith}
    ${result_cantrakhach}    Minus and round 2    ${result_tongtientra_tru_phith}    ${result_tongtienmua_thukhac}
    ${result_kh_canthanhtoan}    Set Variable If    ${result_tongtienmua_thukhac}<${result_tongtientra_tru_phith}    ${result_cantrakhach}    ${result_khachthanhtoan}
    ${result_khtt}    Set Variable If    "${input_khtt}" == "all"    ${result_kh_canthanhtoan}    ${input_khtt}
    ${actual_khtt}    Set Variable If    "${input_khtt}" == "0"    0    ${result_khtt}
    ${actuall_trahang}    Set Variable If    ${result_tongtienmua_tru_gg}<${result_tongtientra_tru_phith}    ${actual_khtt}    0
    ${result_tongtienhangmua_tovalidate}    Sum    ${result_tongtienmua}    ${actual_surcharge_value}
    #create đổi trả hàng
    ${button_thanhtoan}    Set Variable If    ${result_tongtienmua_thukhac}<${result_tongtientra_tru_phith}    ${textbox_dth_tientrakhach}    ${textbox_dth_khachthanhtoan}
    Wait Until Keyword Succeeds    3 times    5 s    Run keyword if    0 < ${input_phi_th} < 100    Input % return free value    ${input_phi_th}
    ...    ${result_phi_th}
    ...    ELSE    Input VND return free value    ${input_phi_th}
    Wait Until Keyword Succeeds    3 times    5 s    Run Keyword If    0 < ${input_ggdth} < 100    Input % discount additional invoice    ${input_ggdth}
    ...    ${result_ggdth}
    ...    ELSE    Input VND discount additional invoice    ${input_ggdth}
    ${button_thanhtoan}    Set Variable If    ${result_tongtienmua_tru_gg}<${result_tongtientra_tru_phith}    ${textbox_dth_tientrakhach}    ${textbox_dth_khachthanhtoan}
    Run Keyword If    "${input_khtt}" == "all"    Click Element JS    ${button_th}
    ...    ELSE    Input payment into any form    ${button_thanhtoan}    ${input_khtt}    ${button_th}
    Return message success validation
    ${return_code}    Wait Until Keyword Succeeds    3 times    5 s    Get saved code after execute
    Execute Javascript    location.reload();
    Sleep    20 s    wait for response to API
    #assert value product trả hàng
    ${get_list_hh_in_th_af_execute}    Get list product frm Return API    ${return_code}
    ${get_list_hh_in_th_af_execute}    Reverse List one    ${get_list_hh_in_th_af_execute}
    ${list_soluong_in_th}    ${list_giatriquydoi_in_th}    Get list quantity and gia tri quy doi with return have multi product    ${get_list_hh_in_th_af_execute}    ${return_code}
    : FOR    ${item_ma_hh}    ${result_toncuoi}    ${item_giavon}    ${get_soluong_in_th}    ${get_giatri_quydoi_th}    IN ZIP
    ...    ${get_list_hh_in_th_af_execute}    ${list_result_toncuoi_th}    ${list_giavon_th}    ${list_soluong_in_th}    ${list_giatriquydoi_in_th}
    \    Run Keyword If    '${get_giatri_quydoi_th}' == '1'    Validate onhand and cost frm API    ${return_code}    ${item_ma_hh}    ${result_toncuoi}
    \    ...    ${item_giavon}    ${get_soluong_in_th}
    \    ...    ELSE    Validate onhand and cost frm unit product    ${return_code}    ${item_ma_hh}    ${result_toncuoi}
    \    ...    ${item_giavon}    ${get_soluong_in_th}    ${get_giatri_quydoi_th}
    #assert value product đổi trả hàng
    ${get_additional_invoice_code}    Get additional invoice code by return code    ${return_code}
    ${get_list_hh_in_dth_af_execute}    Get list product after create invoice    ${get_additional_invoice_code}
    ${get_list_hh_in_dth_af_execute}    Reverse List one    ${get_list_hh_in_dth_af_execute}
    ${list_soluong_in_dth}    ${list_giatriquydoi_in_dth}    Get list quantity and gia tri quy doi frm additional invoice code    ${get_list_hh_in_dth_af_execute}    ${get_additional_invoice_code}
    : FOR    ${item_ma_hh}    ${result_toncuoi}    ${item_giavon}    ${get_soluong_in_dth}    ${get_giatri_quydoi_dth}    IN ZIP
    ...    ${get_list_hh_in_dth_af_execute}    ${list_result_toncuoi_dth}    ${list_giavon_dth}    ${list_soluong_in_dth}    ${list_giatriquydoi_in_dth}
    \    Run Keyword If    '${get_giatri_quydoi_dth}' == '1'    Validate onhand and cost frm API    ${get_additional_invoice_code}    ${item_ma_hh}    ${result_toncuoi}
    \    ...    ${item_giavon}    ${get_soluong_in_dth}
    \    ...    ELSE    Validate onhand and cost frm unit product    ${get_additional_invoice_code}    ${item_ma_hh}    ${result_toncuoi}
    \    ...    ${item_giavon}    ${get_soluong_in_dth}    ${get_giatri_quydoi_dth}
    #assert value in invoice
    ${get_ma_kh_by_hd_af_ex}    ${get_tong_tien_hang_af_ex}    ${get_khach_tt_af_ex}    ${get_trangthai_af_ex}    Get invoice info by invoice code    ${get_ma_hd}
    Should Be Equal As Numbers    ${get_tong_tien_hang_af_ex}    ${get_tong_tien_hang_bf_ex}
    Should Be Equal As Numbers    ${get_khach_tt_af_ex}    ${get_khach_tt_bf_ex}
    Should Be Equal As Strings    ${get_ma_kh_by_hd_af_ex}    ${get_ma_kh_by_hd_bf_ex}
    Should Be Equal As Strings    ${get_trangthai_af_ex}    ${get_trangthai_bf_ex}
    #assert value in return
    ${get_tongtienhangtra_af_ex}    ${get_phitrahang_af_ex}    ${get_cantrakhach_af_ex}    ${get_datrakhach_af_ex}    ${get_tongtien_hoadontra_af_ex}    Get return info by return code    ${return_code}
    Should Be Equal As Numbers    ${get_tongtienhangtra_af_ex}    ${result_tongtientra}
    Should Be Equal As Numbers    ${get_phitrahang_af_ex}    ${result_phi_th}
    Run Keyword If    ${result_cantrakhach}>0    Should Be Equal As Numbers    ${get_cantrakhach_af_ex}    ${result_cantrakhach}    ELSE   Should Be Equal As Numbers    ${get_cantrakhach_af_ex}    0
    Should Be Equal As Numbers    ${get_datrakhach_af_ex}    ${actuall_trahang}
    Should Be Equal As Numbers    ${get_tongtien_hoadontra_af_ex}    ${result_tongtientra_tru_phith}
    Validate return history by invoice code    ${get_ma_hd}    ${return_code}    ${result_tongtientra}
    #assert value in đổi hàng
    ${get_ma_kh_by_hd_af_ex}    ${get_tong_tien_hang_af_ex}    ${get_khach_tt_af_ex}    ${get_giamgia_hd_af_ex}    ${get_khach_can_tra_af_ex}    ${get_trangthai_af_ex}    Get additional invoice info incase discount by additional invoice code
    ...    ${get_additional_invoice_code}
    Should Be Equal As Numbers    ${get_tong_tien_hang_af_ex}    ${result_tongtienhangmua_tovalidate}
    Run Keyword If    ${result_tongtienmua_thukhac}<${result_tongtientra_tru_phith}    Should Be Equal As Numbers    ${get_khach_can_tra_af_ex}    0
    ...    ELSE    Should Be Equal As Numbers    ${get_khach_can_tra_af_ex}    ${result_kh_canthanhtoan}
    Should Be Equal As Numbers    ${get_giamgia_hd_af_ex}    ${result_ggdth}
    Run Keyword If    ${result_tongtienmua_thukhac}<${result_tongtientra_tru_phith}    Should Be Equal As Numbers    ${get_khach_tt_af_ex}    0
    ...    ELSE    Should Be Equal As Numbers    ${get_khach_tt_af_ex}    ${actual_khtt}
    Should Be Equal As Strings    ${get_ma_kh_by_hd_af_ex}    ${input_ma_kh}
    Should Be Equal As Strings    ${get_trangthai_af_ex}    Hoàn thành
    Delete return thr API    ${return_code}
    Delete invoice by invoice code    ${get_ma_hd}
    Run Keyword If    ${surcharge_%} == 0    Toggle surcharge VND    ${input_thukhac}    false
    ...    ELSE    Toggle surcharge percentage    ${input_thukhac}    false

edts04
    [Arguments]    ${input_ma_kh}    ${dic_productnums_th}    ${dic_productnums_dth}    ${list_imei_nums}    ${input_phi_th}    ${list_ggsp}    ${list_discounttype}
    ...    ${input_ggsp_imei}   ${discount_type_imei}    ${input_ggdth}    ${input_khtt}    ${input_khtt_hd}  ${list_thukhac}
    ${list_product_dth}    Get Dictionary Keys    ${dic_productnums_dth}
    ${list_nums_dth}    Get Dictionary Values    ${dic_productnums_dth}
    ${list_imei_product_dth}    Get Dictionary Keys    ${list_imei_nums}
    ${list_imei_nums_dth}    Get Dictionary Values    ${list_imei_nums}
    ${input_product_imei}    ${input_imei_nums}    Convert two list to string and return    ${list_imei_product_dth}    ${list_imei_nums_dth}
    Create list imei    ${list_imei_product_dth}    ${list_imei_nums_dth}
    ${get_ma_hd}    Add new invoice frm API    ${input_ma_kh}    ${dic_productnums_th}    ${input_khtt_hd}
    ${list_actual_surcharge_value}    Create List
    : FOR    ${item_thukhac}    IN ZIP    ${list_thukhac}
    \    ${surcharge_value_vnd}    Get surcharge vnd value    ${item_thukhac}
    \    ${surcharge_value_percentage}    Get surcharge percentage value    ${item_thukhac}
    \    ${actual_surcharge_value}    Set Variable If    ${surcharge_value_percentage} == 0    ${surcharge_value_vnd}    ${surcharge_value_percentage}
    \    Run Keyword If    ${actual_surcharge_value} > 100    Toggle surcharge VND    ${item_thukhac}    true
    \    ...    ELSE    Toggle surcharge percentage    ${item_thukhac}    true
    \    Append To List    ${list_actual_surcharge_value}    ${actual_surcharge_value}
    Log    ${list_actual_surcharge_value}
    #get data frm Trả hàng
    Sleep    5s
    ${get_ma_kh_by_hd_bf_ex}    ${get_tong_tien_hang_bf_ex}    ${get_khach_tt_bf_ex}    ${get_trangthai_bf_ex}    Get invoice info by invoice code    ${get_ma_hd}
    ${get_list_hh_in_hd}    ${get_list_sl_in_hd}    Get list product and quantity frm invoice API    ${get_ma_hd}
    ${get_list_sl_in_hd}    Convert String to List    ${get_list_sl_in_hd}
    ${list_result_thanhtien_th}    ${list_giavon_th}    ${list_result_toncuoi_th}    Get list total sale - endingstock - cost frm product api    ${get_list_hh_in_hd}    ${get_list_sl_in_hd}
    ${get_list_baseprice}    Get list of Baseprice by Product Code    ${list_product_dth}
    #input product into DTH form
    Wait Until Keyword Succeeds    3 times    8 s    Before Test Ban Hang deactivate print warranty
    Select Invoice from Ban Hang page    ${get_ma_hd}
    ${laster_nums}    Set Variable    0
    : FOR    ${item_hh}    ${item_soluong}    IN ZIP    ${get_list_hh_in_hd}    ${get_list_sl_in_hd}
    \    ${laster_number}    Input nums for multi product    ${item_hh}    ${item_soluong}    ${laster_nums}    ${cell_laster_numbers_return}
    ${laster_nums1}    Set Variable    0
    : FOR    ${item_product_dth}    ${item_nums_dth}    ${item_giaban}    ${item_ggsp}    ${discount_type}    IN ZIP    ${list_product_dth}
    ...    ${list_nums_dth}    ${get_list_baseprice}    ${list_ggsp}    ${list_discounttype}
    \    ${laster_nums1}    Wait Until Keyword Succeeds    3 times    5 s    Input product and nums into Doi tra hang form    ${item_product_dth}    ${item_nums_dth}
    \    ...    ${laster_nums1}
    \    ${newprice}    Run Keyword If    '${discount_type}' == 'dis'     Price after % discount product    ${item_giaban}    ${item_ggsp}
    \    ...    ELSE IF    '${discount_type}' == 'disvnd'    Minus    ${item_giaban}    ${item_ggsp}
    \    ...    ELSE IF    '${discount_type}' == 'changeup' or '${discount_type}' == 'changedown'  Set Variable   ${item_ggsp}    ELSE    Set Variable    ${item_giaban}
    \    Run keyword if    '${discount_type}' == 'dis'     Wait Until Keyword Succeeds    3 times    5 s    Input % discount for multi product
    \    ...    ${item_product_dth}    ${item_ggsp}    ${newprice}    ELSE IF    '${discount_type}' == 'disvnd'   Wait Until Keyword Succeeds    3 times    5 s        Input VND discount for multi product    ${item_product_dth}
    \    ...    ${item_ggsp}    ${newprice}
    \    ...    ELSE IF    '${discount_type}' == 'changeup' or '${discount_type}' == 'changedown'  Wait Until Keyword Succeeds    3 times    5 s    Input newprice for multi product    ${item_product_dth}   ${item_ggsp}
    \    ...    ELSE    Log    Ignore input
    : FOR    ${item_product_imei}    ${item_imei}    IN ZIP    ${list_imei_product_dth}    ${imei_inlist}
    \    Wait Until Keyword Succeeds    3 times    8 s    Input product and imei incase multi product to any form    ${textbox_th_search_hangdoi}    ${item_product_imei}
    \    ...    ${cell_dth_sanpham}    ${textbox_dth_nhap_serial}    ${item_dth_imei_in_dropdown}    ${cell_dth_ma_sanpham}    ${cell_dth_imei_multi_product}
    \    ...    @{item_imei}
    ${newprice_imei}    Computation price incase discount by product code    ${input_product_imei}    ${input_ggsp_imei}
    Run keyword if    '${discount_type_imei}' == 'dis'    Wait Until Keyword Succeeds    3 times    5 s        Input % discount for multi product    ${input_product_imei}
    ...    ${input_ggsp_imei}    ${newprice_imei}
    ...    ELSE IF   '${discount_type_imei}' == 'disvnd'    Wait Until Keyword Succeeds    3 times    5 s    Input VND discount for multi product    ${input_product_imei}    ${input_ggsp_imei}    ${newprice_imei}
    ...    ELSE IF    '${discount_type_imei}' == 'changeup' or '${discount_type_imei}' == 'changedown'  Wait Until Keyword Succeeds    3 times    5 s    Input newprice for multi product    ${input_product_imei}    ${input_ggsp_imei}
    ...    ELSE    Log    Ignore input
    #get data frm Doi hang
    Append To List    ${list_product_dth}    ${input_product_imei}
    Append to List    ${list_nums_dth}    ${input_imei_nums}
    Append to List    ${list_ggsp}    ${input_ggsp_imei}
    Append to List    ${list_discounttype}    ${discount_type_imei}
    ${list_result_thanhtien_dth}    ${list_giavon_dth}    ${list_result_toncuoi_dth}    Get list total sale - endingstock - cost incase discount and newprice with additional invoice    ${list_product_dth}
    ...    ${list_nums_dth}    ${list_ggsp}    ${list_discounttype}
    #compute trả hàng
    ${result_tongtientra}    Sum values in list    ${list_result_thanhtien_th}
    ${result_phi_th}    Run Keyword If    0 < ${input_phi_th} < 100    Convert % discount to VND and round    ${result_tongtientra}    ${input_phi_th}
    ...    ELSE    Set Variable    ${input_phi_th}
    ${result_tongtientra_tru_phith}    Minus and round 2    ${result_tongtientra}    ${result_phi_th}
    #compute mua hàng
    ${result_tongtienmua}    Sum values in list    ${list_result_thanhtien_dth}
    ${result_ggdth}    Run Keyword If    0 < ${input_ggdth} < 100    Convert % discount to VND and round    ${result_tongtienmua}    ${input_ggdth}
    ...    ELSE    Set Variable    ${input_ggdth}
    ${result_tongtienmua_tru_gg}    Minus and round 2    ${result_tongtienmua}    ${result_ggdth}
    ${list_result_thukhac}    Create List
    : FOR    ${item_value}    IN ZIP    ${list_actual_surcharge_value}
    \    ${result_thukhac}    Run Keyword If    ${item_value}>100    Set Variable    ${item_value}
    \    ...    ELSE    Convert % discount to VND and round    ${item_value}    ${result_tongtienmua_tru_gg}
    \    Append To List    ${list_result_thukhac}    ${result_thukhac}
    Log    ${list_result_thukhac}
    ${total_surcharge}    Sum values in list    ${list_result_thukhac}
    ${result_tongtienmua_thukhac}    sum    ${result_tongtienmua_tru_gg}    ${total_surcharge}
    ${result_khachthanhtoan}    Minus and round 2    ${result_tongtienmua_thukhac}    ${result_tongtientra_tru_phith}
    ${result_cantrakhach}    Minus and round 2    ${result_tongtientra_tru_phith}    ${result_tongtienmua_thukhac}
    ${result_kh_canthanhtoan}    Set Variable If    ${result_tongtienmua_thukhac}<${result_tongtientra_tru_phith}    ${result_cantrakhach}    ${result_khachthanhtoan}
    ${result_khtt}    Set Variable If    "${input_khtt}" == "all"    ${result_kh_canthanhtoan}    ${input_khtt}
    ${actual_khtt}    Set Variable If    "${input_khtt}" == "0"    0    ${result_khtt}
    ${actuall_trahang}    Set Variable If    ${result_tongtienmua_tru_gg}<${result_tongtientra_tru_phith}    ${actual_khtt}    0
    ${result_tongtienhangmua_tovalidate}    Sum    ${result_tongtienmua}    ${total_surcharge}
    #create đổi trả hàng
    ${button_thanhtoan}    Set Variable If    ${result_tongtienmua_thukhac}<${result_tongtientra_tru_phith}    ${textbox_dth_tientrakhach}    ${textbox_dth_khachthanhtoan}
    Wait Until Keyword Succeeds    3 times    5 s    Run keyword if    0 < ${input_phi_th} < 100    Input % return free value    ${input_phi_th}
    ...    ${result_phi_th}
    ...    ELSE    Input VND return free value    ${input_phi_th}
    Wait Until Keyword Succeeds    3 times    5 s    Run Keyword If    0 < ${input_ggdth} < 100    Input % discount additional invoice    ${input_ggdth}
    ...    ${result_ggdth}
    ...    ELSE    Input VND discount additional invoice    ${input_ggdth}
    ${button_thanhtoan}    Set Variable If    ${result_tongtienmua_tru_gg}<${result_tongtientra_tru_phith}    ${textbox_dth_tientrakhach}    ${textbox_dth_khachthanhtoan}
    Run Keyword If    "${input_khtt}" == "all"    Click Element JS    ${button_th}
    ...    ELSE    Input payment into any form    ${button_thanhtoan}    ${input_khtt}    ${button_th}
    Return message success validation
    ${return_code}    Wait Until Keyword Succeeds    3 times    5 s    Get saved code after execute
    Execute Javascript    location.reload();
    Sleep    20 s    wait for response to API
    #assert value product trả hàng
    ${get_list_hh_in_th_af_execute}    Get list product frm Return API    ${return_code}
    ${get_list_hh_in_th_af_execute}    Reverse List one    ${get_list_hh_in_th_af_execute}
    ${list_soluong_in_th}    ${list_giatriquydoi_in_th}    Get list quantity and gia tri quy doi with return have multi product    ${get_list_hh_in_th_af_execute}    ${return_code}
    : FOR    ${item_ma_hh}    ${result_toncuoi}    ${item_giavon}    ${get_soluong_in_th}    ${get_giatri_quydoi_th}    IN ZIP
    ...    ${get_list_hh_in_th_af_execute}    ${list_result_toncuoi_th}    ${list_giavon_th}    ${list_soluong_in_th}    ${list_giatriquydoi_in_th}
    \    Run Keyword If    '${get_giatri_quydoi_th}' == '1'    Validate onhand and cost frm API    ${return_code}    ${item_ma_hh}    ${result_toncuoi}
    \    ...    ${item_giavon}    ${get_soluong_in_th}
    \    ...    ELSE    Validate onhand and cost frm unit product    ${return_code}    ${item_ma_hh}    ${result_toncuoi}
    \    ...    ${item_giavon}    ${get_soluong_in_th}    ${get_giatri_quydoi_th}
    #assert value product đổi trả hàng
    ${get_additional_invoice_code}    Get additional invoice code by return code    ${return_code}
    ${get_list_hh_in_dth_af_execute}    Get list product after create invoice    ${get_additional_invoice_code}
    ${get_list_hh_in_dth_af_execute}    Reverse List one    ${get_list_hh_in_dth_af_execute}
    ${list_soluong_in_dth}    ${list_giatriquydoi_in_dth}    Get list quantity and gia tri quy doi frm additional invoice code    ${get_list_hh_in_dth_af_execute}    ${get_additional_invoice_code}
    : FOR    ${item_ma_hh}    ${result_toncuoi}    ${item_giavon}    ${get_soluong_in_dth}    ${get_giatri_quydoi_dth}    IN ZIP
    ...    ${get_list_hh_in_dth_af_execute}    ${list_result_toncuoi_dth}    ${list_giavon_dth}    ${list_soluong_in_dth}    ${list_giatriquydoi_in_dth}
    \    Run Keyword If    '${get_giatri_quydoi_dth}' == '1'    Validate onhand and cost frm API    ${get_additional_invoice_code}    ${item_ma_hh}    ${result_toncuoi}
    \    ...    ${item_giavon}    ${get_soluong_in_dth}
    \    ...    ELSE    Validate onhand and cost frm unit product    ${get_additional_invoice_code}    ${item_ma_hh}    ${result_toncuoi}
    \    ...    ${item_giavon}    ${get_soluong_in_dth}    ${get_giatri_quydoi_dth}
    #assert value in invoice
    ${get_ma_kh_by_hd_af_ex}    ${get_tong_tien_hang_af_ex}    ${get_khach_tt_af_ex}    ${get_trangthai_af_ex}    Get invoice info by invoice code    ${get_ma_hd}
    Should Be Equal As Numbers    ${get_tong_tien_hang_af_ex}    ${get_tong_tien_hang_bf_ex}
    Should Be Equal As Numbers    ${get_khach_tt_af_ex}    ${get_khach_tt_bf_ex}
    Should Be Equal As Strings    ${get_ma_kh_by_hd_af_ex}    ${get_ma_kh_by_hd_bf_ex}
    Should Be Equal As Strings    ${get_trangthai_af_ex}    ${get_trangthai_bf_ex}
    #assert value in return
    ${get_tongtienhangtra_af_ex}    ${get_phitrahang_af_ex}    ${get_cantrakhach_af_ex}    ${get_datrakhach_af_ex}    ${get_tongtien_hoadontra_af_ex}    Get return info by return code    ${return_code}
    Should Be Equal As Numbers    ${get_tongtienhangtra_af_ex}    ${result_tongtientra}
    Should Be Equal As Numbers    ${get_phitrahang_af_ex}    ${result_phi_th}
    Run Keyword If    ${result_cantrakhach}>0    Should Be Equal As Numbers    ${get_cantrakhach_af_ex}    ${result_cantrakhach}    ELSE   Should Be Equal As Numbers    ${get_cantrakhach_af_ex}    0
    Should Be Equal As Numbers    ${get_datrakhach_af_ex}    ${actuall_trahang}
    Should Be Equal As Numbers    ${get_tongtien_hoadontra_af_ex}    ${result_tongtientra_tru_phith}
    Validate return history by invoice code    ${get_ma_hd}    ${return_code}    ${result_tongtientra}
    #assert value in đổi hàng
    ${get_ma_kh_by_hd_af_ex}    ${get_tong_tien_hang_af_ex}    ${get_khach_tt_af_ex}    ${get_giamgia_hd_af_ex}    ${get_khach_can_tra_af_ex}    ${get_trangthai_af_ex}    Get additional invoice info incase discount by additional invoice code
    ...    ${get_additional_invoice_code}
    Should Be Equal As Numbers    ${get_tong_tien_hang_af_ex}    ${result_tongtienhangmua_tovalidate}
    Run Keyword If    ${result_tongtienmua_thukhac}<${result_tongtientra_tru_phith}    Should Be Equal As Numbers    ${get_khach_can_tra_af_ex}    0
    ...    ELSE    Should Be Equal As Numbers    ${get_khach_can_tra_af_ex}    ${result_kh_canthanhtoan}
    Should Be Equal As Numbers    ${get_giamgia_hd_af_ex}    ${result_ggdth}
    Run Keyword If    ${result_tongtienmua_thukhac}<${result_tongtientra_tru_phith}    Should Be Equal As Numbers    ${get_khach_tt_af_ex}    0
    ...    ELSE    Should Be Equal As Numbers    ${get_khach_tt_af_ex}    ${actual_khtt}
    Should Be Equal As Strings    ${get_ma_kh_by_hd_af_ex}    ${input_ma_kh}
    Should Be Equal As Strings    ${get_trangthai_af_ex}    Hoàn thành
    Delete return thr API    ${return_code}
    Delete invoice by invoice code    ${get_ma_hd}
    : FOR    ${item_thukhac}    ${item_value}    IN ZIP    ${list_thukhac}    ${list_actual_surcharge_value}
    \    Run Keyword If    ${item_value} > 100    Toggle surcharge VND    ${item_thukhac}    false
    \    ...    ELSE    Toggle surcharge percentage    ${item_thukhac}    false
