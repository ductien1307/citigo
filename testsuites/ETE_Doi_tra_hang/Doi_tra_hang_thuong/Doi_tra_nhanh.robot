*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    ${headless_browser}
Test Teardown     After Test
Library           Collections
Library           BuiltIn
Resource          ../../../core/API/api_khachhang.robot
Resource          ../../../core/API/api_danhmuc_hanghoa.robot
Resource          ../../../core/Ban_Hang/banhang_action.robot
Resource          ../../../core/Tra_hang/tra_hang_action.robot
Resource          ../../../core/Tra_hang/tra_hang_page.robot
Resource          ../../../core/API/api_soquy.robot
Resource          ../../../config/env_product/envi.robot
Resource          ../../../core/Ban_Hang/banhang_page.robot
Resource          ../../../core/Tra_hang/doi_tra_hang_action.robot
Resource          ../../../core/share/toast_message.robot
Resource          ../../../core/share/imei.robot

*** Variables ***
&{list_product_nums_TH01}    DV093=4.2
&{list_product_nums_TH02}    DVT86=25
&{list_product_nums_TH03}    HH0086=3.5
&{list_product_nums_DTH01}    HH0085=5    SI067=1    DVT86=3.5    DV091=1    Combo70=1.75
&{list_product_nums_DTH02}    HH0086=3    SI068=1    QD154=2.5    DV092=1    Combo71=3.2
&{list_product_nums_DTH03}    HH0087=4    SI069=1    DVT88=3.5    DV093=1    Combo72=2
@{list_discount}    20    10000    170000.56   150000     0
@{discount_type}    dis     disvnd    changeup    changedown    none

*** Test Cases ***    Mã KH         List product trả hàng        List product đổi trả hàng     Phí trả hàng    List GGSP            List discount type    GGDTH    Khách thanh toán
Doi tra nhanh         [Tags]    ETDN
                      [Template]    edthn01
                      CTKH130       ${list_product_nums_TH01}    ${list_product_nums_DTH01}   15              ${list_discount}    ${discount_type}       10000        200000
                      CTKH131      ${list_product_nums_TH02}    ${list_product_nums_DTH02}    15000           ${list_discount}    ${discount_type}       0            all
                      CTKH132      ${list_product_nums_TH03}    ${list_product_nums_DTH03}    0           ${list_discount}    ${discount_type}       15           0

*** Keywords ***
edthn01
    [Arguments]    ${input_ma_kh}    ${dic_product_nums_th}    ${dic_product_nums_dth}    ${input_phi_th}    ${list_ggsp}    ${list_discount_type}
    ...    ${input_ggdth}    ${input_khtt}
    ${list_product_dth}    Get Dictionary Keys    ${dic_product_nums_dth}
    ${list_nums_dth}    Get Dictionary Values    ${dic_product_nums_dth}
    Create list imei and other product    ${list_product_dth}    ${list_nums_dth}
    #get data frm Trả hàng
    ${get_no_bf_execute}    Get Du no cuoi KH from API    ${input_ma_kh}
    ${list_product_th}    Get Dictionary Keys    ${dic_product_nums_th}
    ${list_nums_th}    Get Dictionary Values    ${dic_product_nums_th}
    ${list_result_thanhtien_th}    ${list_giavon_th}    ${list_result_toncuoi_th}    Get list total sale - endingstock - cost frm product api    ${list_product_th}    ${list_nums_th}
    ${list_result_thanhtien_dth}    ${list_giavon_dth}    ${list_result_toncuoi_dth}    ${list_result_newprice}    Get list total sale - endingstock - cost - newprice with additional invoice    ${list_product_dth}
    ...    ${list_nums_dth}    ${list_ggsp}    ${list_discount_type}
    ${get_list_status_product}    Get list imei status thr API    ${list_product_dth}
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
    ${result_khachthanhtoan}    Minus and round 2    ${result_tongtienmua_tru_gg}    ${result_tongtientra_tru_phith}
    ${result_cantrakhach}    Minus and round 2    ${result_tongtientra_tru_phith}    ${result_tongtienmua_tru_gg}
    ${result_kh_canthanhtoan}    Set Variable If    ${result_tongtienmua_tru_gg}<${result_tongtientra_tru_phith}    ${result_cantrakhach}    ${result_khachthanhtoan}
    ${result_khtt}    Set Variable If    "${input_khtt}" == "all"    ${result_kh_canthanhtoan}    ${input_khtt}
    ${actual_khtt}    Set Variable If    "${input_khtt}" == "0"    0    ${result_khtt}
    ${actuall_trahang}    Set Variable If    ${result_tongtienmua_tru_gg}<${result_tongtientra_tru_phith}    ${actual_khtt}    0
    #compute KH
    ${result_du_no_th_KH}    Minus    ${get_no_bf_execute}    ${result_tongtientra_tru_phith}
    ${result_PTT_th_KH}    Run Keyword If    ${result_tongtienmua_tru_gg}<${result_tongtientra_tru_phith}    Sum    ${result_du_no_th_KH}    ${actual_khtt}
    ...    ELSE    Set Variable    ${result_du_no_th_KH}
    ${result_du_no_KH}    Sum and replace floating point    ${result_PTT_th_KH}    ${result_tongtienmua_tru_gg}
    ${result_PTT_dth_KH}    Run Keyword If    ${result_tongtienmua_tru_gg}>${result_tongtientra_tru_phith}    Minus    ${result_du_no_KH}    ${actual_khtt}
    ...    ELSE    Set Variable    ${result_du_no_KH}
    #create đổi trả hàng
    Wait Until Keyword Succeeds    3 times    8 s    Before Test Ban Hang deactivate print warranty
    Select Return without Invoice from BH page
    ${lastest_nums}    Set Variable    0
    : FOR    ${item_product}    ${item_nums}    IN ZIP    ${list_product_th}    ${list_nums_th}
    \    ${lastest_nums}    Wait Until Keyword Succeeds    3 times    5 s    Input product-num in sale form    ${item_product}    ${item_nums}
    \    ...    ${lastest_nums}    ${cell_laster_numbers_return}
    ${lastest_nums1}    Set Variable    0
    : FOR    ${item_product}     ${item_status}       ${item_num}        ${item_imei}    ${item_discount}      ${item_discount_type}    ${result_newprice}    IN ZIP    ${list_product_dth}       ${get_list_status_product}
    ...    ${list_nums_dth}    ${imei_inlist}       ${list_ggsp}    ${list_discount_type}    ${list_result_newprice}
    \    ${lastest_nums1}=        Run Keyword If    '${item_status}' == 'True'    Input product and its imei to any form and return lastest number    ${textbox_th_search_hangdoi}
    \    ...    ${item_product}    ${item_num}    ${cell_dth_sanpham}    ${textbox_dth_nhap_serial}    ${item_dth_imei_in_dropdown}    ${cell_dth_ma_sanpham}    ${tag_single_imei_mhbh}
    \    ...     ${lastest_nums1}    @{item_imei}
    \    ...       ELSE      Input product and nums into Doi tra hang form    ${item_product}    ${item_num}    ${lastest_nums1}
    \    Run keyword if    '${item_discount_type}' == 'dis'    Wait Until Keyword Succeeds    3 times    5 s    Input % discount for multi product    ${item_product}    ${item_discount}    ${result_newprice}
    \    ...    ELSE IF    '${item_discount_type}' == 'disvnd'    Wait Until Keyword Succeeds    3 times    5 s    Input VND discount for multi product    ${item_product}    ${item_discount}    ${result_newprice}
    \    ...    ELSE IF     '${item_discount_type}' == 'changeup' or '${item_discount_type}' == 'changedown'  Wait Until Keyword Succeeds    3 times    5 s    Input newprice for multi product    ${item_product}    ${item_discount}        ELSE       Log        ignore
    Wait Until Keyword Succeeds    3 times    5 s    Input Khach Hang    ${input_ma_kh}
    Wait Until Keyword Succeeds    3 times    5 s    Run keyword if    0 < ${input_phi_th} < 100    Input % return free value    ${input_phi_th}
    ...    ${result_phi_th}    ELSE    Input VND return free value    ${input_phi_th}
    Wait Until Keyword Succeeds    3 times    5 s    Run Keyword If    0 < ${input_ggdth} < 100    Input % discount additional invoice    ${input_ggdth}
    ...    ${result_ggdth}    ELSE    Input VND discount additional invoice    ${input_ggdth}
    ${button_thanhtoan}    Set Variable If    ${result_tongtienmua_tru_gg}<${result_tongtientra_tru_phith}    ${textbox_dth_tientrakhach}    ${textbox_dth_khachthanhtoan}
    Wait Until Keyword Succeeds    3 times    5 s    Run Keyword If    "${input_khtt}" == "all"    Click Element JS    ${button_th}
    ...    ELSE    Input payment into any form    ${button_thanhtoan}    ${input_khtt}    ${button_th}
    Return message success validation
    ${return_code}    Wait Until Keyword Succeeds    3 times    5 s    Get saved code after execute
    Execute Javascript    location.reload();
    Remove From List    ${list_ggsp}    -1
    Sleep    20 s    wait for response to API
    #assert value product trả hàng
    ${get_list_hh_in_th_af_execute}    Get list product frm Return API    ${return_code}
    #${get_list_hh_in_th_af_execute}    Reverse List one    ${get_list_hh_in_th_af_execute}
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
    \    ...    ${item_giavon}    ${get_soluong_in_dth}    ELSE    Validate onhand and cost frm unit product    ${get_additional_invoice_code}
    \    ...    ${item_ma_hh}    ${result_toncuoi}    ${item_giavon}    ${get_soluong_in_dth}    ${get_giatri_quydoi_dth}
    #assert value in return
    ${get_tongtienhangtra_af_ex}    ${get_phitrahang_af_ex}    ${get_cantrakhach_af_ex}    ${get_datrakhach_af_ex}    ${get_tongtien_hoadontra_af_ex}    Get return info by return code    ${return_code}
    Should Be Equal As Numbers    ${get_tongtienhangtra_af_ex}    ${result_tongtientra}
    Should Be Equal As Numbers    ${get_phitrahang_af_ex}    ${result_phi_th}
    Should Be Equal As Numbers    ${get_datrakhach_af_ex}    ${actuall_trahang}
    Should Be Equal As Numbers    ${get_tongtien_hoadontra_af_ex}    ${result_tongtientra_tru_phith}
    #assert value in đổi hàng
    ${get_ma_kh_by_hd_af_ex}    ${get_tong_tien_hang_af_ex}    ${get_khach_tt_af_ex}    ${get_giamgia_hd_af_ex}    ${get_khach_can_tra_af_ex}    ${get_trangthai_af_ex}    Get additional invoice info incase discount by additional invoice code
    ...    ${get_additional_invoice_code}
    Should Be Equal As Numbers    ${get_tong_tien_hang_af_ex}    ${result_tongtienmua}
    Run Keyword If    ${result_tongtienmua_tru_gg}<${result_tongtientra_tru_phith}    Should Be Equal As Numbers    ${get_khach_can_tra_af_ex}    0
    ...    ELSE    Should Be Equal As Numbers    ${get_khach_can_tra_af_ex}    ${result_kh_canthanhtoan}
    Should Be Equal As Numbers    ${get_giamgia_hd_af_ex}    ${result_ggdth}
    Run Keyword If    ${result_tongtienmua_tru_gg}<${result_tongtientra_tru_phith}    Should Be Equal As Numbers    ${get_khach_tt_af_ex}    0
    ...    ELSE    Should Be Equal As Numbers    ${get_khach_tt_af_ex}    ${actual_khtt}
    Should Be Equal As Strings    ${get_ma_kh_by_hd_af_ex}    ${input_ma_kh}
    Should Be Equal As Strings    ${get_trangthai_af_ex}    Hoàn thành
    #assert customer and so quy
    ${get_no_af_execute_kh}    Get Du no cuoi KH from API    ${input_ma_kh}
    Should Be Equal As Numbers    ${get_no_af_execute_kh}    ${result_PTT_dth_KH}
    Delete return thr API    ${return_code}
