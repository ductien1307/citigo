*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    ${headless_browser}
Test Teardown     After Test
Library           Collections
Library           BuiltIn
Resource          ../../../../../core/Ban_Hang/banhang_action.robot
Resource          ../../../../../core/Tra_hang/tra_hang_action.robot
Resource          ../../../../../core/Tra_hang/tra_hang_page.robot
Resource          ../../../../../core/API/api_soquy.robot
Resource          ../../../../../config/env_product/envi.robot
Resource          ../../../../../core/Ban_Hang/banhang_page.robot
Resource          ../../../../../core/Tra_hang/doi_tra_hang_action.robot
Resource          ../../../../../core/share/toast_message.robot

*** Variables ***
&{list_productnums_DTH}    KLCB002=5.5    KLDV003=8    KLQD002=6.5    KLT0002=7
&{list_productnums_TH}    KLCB003=4
&{list_imei_dth}    KLSI0002=3
@{list_discount}    15    30000    5000    115000
@{list_disoucnt_type}    dis    change    dis    change

*** Test Cases ***    List product trả hàng     List product đổi trả hàng    List imei           Phí trả hàng    List change         List change type         Change IMEI    Change type IMEI    GGDTH    Khách thanh toán
Basic                 [Tags]                    DTKL                         tt34
                      [Template]                edtkl_invoice01
                      ${list_productnums_TH}    ${list_productnums_DTH}      ${list_imei_dth}    15              ${list_discount}    ${list_disoucnt_type}    110000         change              20       20000

*** Keywords ***
edtkl_invoice01
    [Arguments]    ${dic_productnums_th}    ${dic_productnums_dth}    ${list_imei_nums}    ${input_phi_th}    ${list_change}    ${list_change_type}
    ...    ${input_change_imei}    ${input_change_imei_type}    ${input_ggdth}    ${input_khtt}
    ${list_product_dth}    Get Dictionary Keys    ${dic_productnums_dth}
    ${list_nums_dth}    Get Dictionary Values    ${dic_productnums_dth}
    ${list_imei_product_dth}    Get Dictionary Keys    ${list_imei_nums}
    ${list_imei_nums_dth}    Get Dictionary Values    ${list_imei_nums}
    ${input_product_imei}    ${input_imei_nums}    Convert two list to string and return    ${list_imei_product_dth}    ${list_imei_nums_dth}
    Create list imei    ${list_imei_product_dth}    ${list_imei_nums_dth}
    ${get_ma_hd}    Add invoice without customer no payment thr API    ${dic_productnums_th}
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
    Append To List    ${list_change_type}    ${input_change_imei_type}
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
    ${result_tongtienmua_tru_gg}    Minus and round 2    ${result_tongtienmua}    ${result_ggdth}
    ${result_khachthanhtoan}    Minus and round 2    ${result_tongtienmua_tru_gg}    ${result_tongtientra_tru_phith}
    ${result_cantrakhach}    Minus and round 2    ${result_tongtientra_tru_phith}    ${result_tongtienmua_tru_gg}
    ${result_kh_canthanhtoan}    Set Variable If    ${result_tongtienmua_tru_gg}<${result_tongtientra_tru_phith}    ${result_cantrakhach}    ${result_khachthanhtoan}
    ${result_khtt}    Set Variable If    "${input_khtt}" == "all"    ${result_kh_canthanhtoan}    ${input_khtt}
    ${actual_khtt}    Set Variable If    "${input_khtt}" == "0"    0    ${result_khtt}
    ${actuall_trahang}    Set Variable If    ${result_tongtienmua_tru_gg}<${result_tongtientra_tru_phith}    ${actual_khtt}    0
    #create đổi trả hàng
    Wait Until Keyword Succeeds    3 times    5 s    Run keyword if    0 < ${input_phi_th} < 100    Input % return free value    ${input_phi_th}
    ...    ${result_phi_th}
    ...    ELSE    Input VND return free value    ${input_phi_th}
    Wait Until Keyword Succeeds    3 times    5 s    Run Keyword If    0 < ${input_ggdth} < 100    Input % discount additional invoice    ${input_ggdth}
    ...    ${result_ggdth}
    ...    ELSE    Input VND discount additional invoice    ${input_ggdth}
    ${button_thanhtoan}    Set Variable If    ${result_tongtienmua_tru_gg}<${result_tongtientra_tru_phith}    ${textbox_dth_tientrakhach}    ${textbox_dth_khachthanhtoan}
    Run Keyword If    "${input_khtt}" == "all"    Click Element JS    ${button_th}
    ...    ELSE    Input payment into any form    ${button_thanhtoan}    ${input_khtt}    ${button_th}
    Run Keyword If    "${input_khtt}" != "all"    Wait Until Keyword Succeeds    3 times    3s    Click Element JS    ${button_luudonkhachle_dongy}
    ...    ELSE    Log    Ingore confirm
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
    Run Keyword If    ${result_cantrakhach}>0    Should Be Equal As Numbers    ${get_cantrakhach_af_ex}    ${result_cantrakhach}
    ...    ELSE    Should Be Equal As Numbers    ${get_cantrakhach_af_ex}    0
    Should Be Equal As Numbers    ${get_datrakhach_af_ex}    ${actuall_trahang}
    Should Be Equal As Numbers    ${get_tongtien_hoadontra_af_ex}    ${result_tongtientra_tru_phith}
    Validate return history by invoice code    ${get_ma_hd}    ${return_code}    ${result_tongtientra}
    #assert value in đổi hàng
    ${get_ma_kh_by_hd_af_ex}    ${get_tong_tien_hang_af_ex}    ${get_khach_tt_af_ex}    ${get_giamgia_hd_af_ex}    ${get_khach_can_tra_af_ex}    ${get_trangthai_af_ex}    Get additional invoice info incase discount by additional invoice code
    ...    ${get_additional_invoice_code}
    Should Be Equal As Numbers    ${get_tong_tien_hang_af_ex}    ${result_tongtienmua}
    Run Keyword If    ${result_tongtienmua_tru_gg}<${result_tongtientra_tru_phith}    Should Be Equal As Numbers    ${get_khach_can_tra_af_ex}    0
    ...    ELSE    Should Be Equal As Numbers    ${get_khach_can_tra_af_ex}    ${result_kh_canthanhtoan}
    Should Be Equal As Numbers    ${get_giamgia_hd_af_ex}    ${result_ggdth}
    Run Keyword If    ${result_tongtienmua_tru_gg}<${result_tongtientra_tru_phith}    Should Be Equal As Numbers    ${get_khach_tt_af_ex}    0
    ...    ELSE    Should Be Equal As Numbers    ${get_khach_tt_af_ex}    ${actual_khtt}
    Should Be Equal As Strings    ${get_ma_kh_by_hd_af_ex}    0
    Should Be Equal As Strings    ${get_trangthai_af_ex}    Hoàn thành
    #assert so quy
    ${code}    Set Variable If    ${result_tongtienmua_tru_gg}<${result_tongtientra_tru_phith}    ${return_code}    ${get_additional_invoice_code}
    ${get_maphieu_soquy}    Get Ma Phieu Thu in So quy    ${code}
    Run Keyword If    '${input_khtt}' == '0'    Validate So quy info from Rest API if Invoice is not paid    ${get_maphieu_soquy}
    ...    ELSE    Validate So quy info from Rest API if Invoice is paid    ${get_maphieu_soquy}    ${actual_khtt}
