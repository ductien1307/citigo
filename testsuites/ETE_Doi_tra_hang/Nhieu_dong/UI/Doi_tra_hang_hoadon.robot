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
&{list_productnums_TH1}    DTDV7=90
&{list_productnums_TH2}    DTH009=5
&{list_productnums_DTH01}    DTH011=3.2    DTU006=2.4    DTDV8=3    DTCombo08=2    DTS06=1
@{discount}           14         0     10000     105000    220000
@{discount_type}      dis     none     disvnd    changedown    changeup
@{list_soluong_addrow}   2      1       3.5,2.75     5,3,4        1,2
@{discount_addrow}   59000     700000.55        15,5000      10,0,135000.47         0,250000
@{discount_type_addrow}  changedown    changeup     dis,disvnd   dis,none,changedown    none,changeup

*** Test Cases ***    Mã KH         List product trả hàng      List product đổi trả hàng    Phí trả hàng    List GGSP      List discount type           GGDTH    Khách thanh toán    KTT hóa đơn
Them dong              [Tags]        UETDM
                      [Template]    edtm03
                      CTKH050       ${list_productnums_TH1}    ${list_productnums_DTH01}    15000              ${discount}     ${discount_type}              20000        all                 ${list_soluong_addrow}    ${discount_addrow}           ${discount_type_addrow}

Them 50 dong             [Tags]        UETDM
                      [Template]    edtm04
                      CTKH051       ${list_productnums_TH2}    DTCombo05    1    20              15        2000000         200000

*** Keywords ***
edtm03
    [Arguments]    ${input_ma_kh}    ${dic_productnums_th}    ${dic_productnums_dth}    ${input_phi_th}    ${list_ggsp}    ${list_discounttype}
    ...    ${input_ggdth}    ${input_khtt}    ${list_nums_addrow}   ${list_discount_addrow}    ${list_discount_type_addrow}
    ${list_nums_addrow}   ${list_discount_addrow}    ${list_discount_type_addrow}   Convert three string list to composite list    ${list_nums_addrow}    ${list_discount_addrow}
    ...    ${list_discount_type_addrow}
    ${get_ma_hd}    Add new invoice no payment frm API    ${input_ma_kh}    ${dic_productnums_th}
    ${list_product_dth}    Get Dictionary Keys    ${dic_product_nums_dth}
    ${list_nums_dth}    Get Dictionary Values    ${dic_product_nums_dth}
    Create list imei and other product   ${list_product_dth}    ${list_nums_dth}
    #get data frm Trả hàng
    ${get_no_bf_execute}    Get Du no cuoi KH from API    ${input_ma_kh}
    ${list_product_th}    Get Dictionary Keys    ${dic_product_nums_th}
    ${list_nums_th}    Get Dictionary Values    ${dic_product_nums_th}
    ${list_giatri_quydoi}    Get list gia tri quy doi frm product API    ${list_product_dth}
    ${get_list_id_product}    ${get_list_status}    Get list imei status and id product thr API    ${list_product_dth}
    ${list_imei_inlist}   Create list imei incase other product have multi row    ${list_product_dth}    ${list_nums_addrow}    ${get_list_status}
    ${get_list_hh_in_hd}    ${get_list_sl_in_hd}    Get list product and quantity frm invoice API    ${get_ma_hd}
    ${get_list_sl_in_hd}    Convert String to List    ${get_list_sl_in_hd}
    ${list_result_thanhtien_th}    ${list_giavon_th}    ${list_result_toncuoi_th}    Get list total sale - endingstock - cost frm product api    ${get_list_hh_in_hd}    ${get_list_sl_in_hd}
    ${list_result_tongtienmua_tru_gg}    ${list_giavon_dth}    ${list_result_toncuoi_dth}    Get list total sale - endingstock - cost incase discount and newprice with additional invoice    ${list_product_dth}
    ...    ${list_nums_dth}    ${list_ggsp}   ${list_discounttype}
    ${list_result_thanhtien_addrow}      ${list_result_newprice_addrow}   ${list_result_toncuoi}    ${list_result_soluong}   Get list total sale - ending stock - total quantity incase add row product    ${list_product_dth}
    ...    ${list_nums_addrow}    ${list_discount_addrow}    ${list_discount_type_addrow}    ${list_result_toncuoi_dth}    ${list_nums_dth}    ${list_giatri_quydoi}
    ${get_list_baseprice}    Get list of Baseprice by Product Code    ${list_product_dth}
    #compute trả hàng
    ${result_tongtientra}    Sum values in list    ${list_result_thanhtien_th}
    ${result_phi_th}    Run Keyword If    0 < ${input_phi_th} < 100    Convert % discount to VND and round    ${result_tongtientra}    ${input_phi_th}
    ...    ELSE    Set Variable    ${input_phi_th}
    ${result_tongtientra_tru_phith}    Minus and round 2    ${result_tongtientra}    ${result_phi_th}
    #compute mua hàng
    ${result_tongtien_mua}    Sum values in list    ${list_result_tongtienmua_tru_gg}
    ${result_tongtienmua_addrow}    Sum values in list    ${list_result_thanhtien_addrow}
    ${result_tongtienmua}   Sum and replace floating point    ${result_tongtien_mua}    ${result_tongtienmua_addrow}
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
    Wait Until Keyword Succeeds    3 times    8 s    Before Test turning on display mode      ${toggle_item_themdong}
    Select Invoice from Ban Hang page    ${get_ma_hd}
    ${lastest_nums}    Set Variable    0
    : FOR    ${item_hh}    ${item_soluong}    IN ZIP    ${get_list_hh_in_hd}    ${get_list_sl_in_hd}
    \    ${laster_number}    Input nums for multi product    ${item_hh}    ${item_soluong}    ${lastest_nums}    ${cell_laster_numbers_return}
    Log     Input doi tra hang
    ${lastest_num1}    Set Variable    0
    : FOR    ${item_product_dth}    ${item_nums_dth}    ${item_giaban}    ${item_ggsp}    ${discount_type}    ${status_imei}    ${item_imei}
    ...   ${nums_addrow}    ${item_ggsp_addrow}    ${result_giamoi_addrow}    ${discount_type_addrow}   ${product_id}   ${item_status}   ${item_imei_addrow}        IN ZIP    ${list_product_dth}
    ...    ${list_nums_dth}    ${get_list_baseprice}    ${list_ggsp}    ${list_discounttype}    ${get_list_status}    ${imei_inlist}   ${list_nums_addrow}    ${list_discount_addrow}   ${list_result_newprice_addrow}
    ...   ${list_discount_type_addrow}   ${get_list_id_product}    ${get_list_status}       ${list_imei_inlist}
    \    ${lastest_num1}    Run Keyword If    '${status_imei}' == '0'    Wait Until Keyword Succeeds    3 times    5 s    Input product and nums into Doi tra hang form    ${item_product_dth}    ${item_nums_dth}
    \    ...    ${lastest_num1}   ELSE    Wait Until Keyword Succeeds    3 times    5 s    Input product and its imei to any form and return lastest number    ${textbox_th_search_hangdoi}
    \    ...    ${item_product_dth}    ${item_nums_dth}    ${cell_dth_sanpham}    ${textbox_dth_nhap_serial}    ${item_dth_imei_in_dropdown}    ${cell_dth_ma_sanpham}    ${tag_single_imei_mhbh}     ${lastest_num1}    @{item_imei}
    \    ${newprice}    Run Keyword If    '${discount_type}' == 'dis'     Price after % discount product    ${item_giaban}    ${item_ggsp}
    \    ...    ELSE IF    '${discount_type}' == 'disvnd'    Minus    ${item_giaban}    ${item_ggsp}
    \    ...    ELSE IF    '${discount_type}' == 'changeup' or '${discount_type}' == 'changedown'  Set Variable   ${item_ggsp}    ELSE    Set Variable    ${item_giaban}
    \    Run keyword if    '${discount_type}' == 'dis'     Wait Until Keyword Succeeds    3 times    5 s    Input % discount for multi product
    \    ...    ${item_product_dth}    ${item_ggsp}    ${newprice}    ELSE IF    '${discount_type}' == 'disvnd'   Wait Until Keyword Succeeds    3 times    5 s        Input VND discount for multi product    ${item_product_dth}
    \    ...    ${item_ggsp}    ${newprice}
    \    ...    ELSE IF    '${discount_type}' == 'changeup' or '${discount_type}' == 'changedown'  Wait Until Keyword Succeeds    3 times    5 s    Input newprice for multi product    ${item_product_dth}   ${item_ggsp}
    \    ...    ELSE    Log    Ignore input
    \    ${lastest_num1}    Run Keyword If    '${status_imei}' == '0'     Add row and input data in additional invoice form    ${item_product_dth}
    \    ...    ${nums_addrow}    ${item_ggsp_addrow}    ${result_giamoi_addrow}    ${discount_type_addrow}    ${product_id}    ${lastest_num1}    ${cell_tongsoluong_hangdoi}
    \    ...    ELSE     Add row product incase imei in additional invoice form    ${item_product_dth}    ${nums_addrow}    ${discount_type_addrow}    ${item_ggsp_addrow}    ${result_giamoi_addrow}
    \    ...    ${product_id}    ${lastest_num1}    ${cell_tongsoluong_hangdoi}    ${item_imei_addrow}
    Wait Until Keyword Succeeds    3 times    5 s    Run keyword if    0 < ${input_phi_th} < 100    Input % return free value    ${input_phi_th}
    ...    ${result_phi_th}   ELSE    Input VND return free value    ${input_phi_th}
    Wait Until Keyword Succeeds    3 times    5 s    Run Keyword If    0 < ${input_ggdth} < 100    Input % discount additional invoice    ${input_ggdth}
    ...    ${result_ggdth}    ELSE    Input VND discount additional invoice    ${input_ggdth}
    ${button_thanhtoan}    Set Variable If    ${result_tongtienmua_tru_gg}<${result_tongtientra_tru_phith}    ${textbox_dth_tientrakhach}    ${textbox_dth_khachthanhtoan}
    Wait Until Keyword Succeeds    3 times    5 s    Run Keyword If    "${input_khtt}" == "all"    Click Element JS    ${button_th}
    ...    ELSE    Input payment into any form    ${button_thanhtoan}    ${input_khtt}    ${button_th}
    Return message success validation
    ${return_code}    Get saved code after execute
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
    : FOR    ${item_ma_hh}    ${result_toncuoi}    ${item_giavon}    ${get_soluong_in_dth}    ${get_giatri_quydoi_dth}    IN ZIP
    ...    ${list_product_dth}    ${list_result_toncuoi}    ${list_giavon_dth}    ${list_result_soluong}    ${list_giatri_quydoi}
    \    Run Keyword If    '${get_giatri_quydoi_dth}' == '1'    Validate onhand and cost frm API    ${get_additional_invoice_code}    ${item_ma_hh}    ${result_toncuoi}
    \    ...    ${item_giavon}    ${get_soluong_in_dth}
    \    ...    ELSE    Validate onhand and cost frm unit product    ${get_additional_invoice_code}    ${item_ma_hh}    ${result_toncuoi}
    \    ...    ${item_giavon}    ${get_soluong_in_dth}    ${get_giatri_quydoi_dth}
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

edtm04
    [Arguments]    ${input_ma_kh}    ${dic_productnums_th}    ${input_product_dth}    ${input_nums_dth}    ${input_phi_th}    ${input_ggdth}    ${input_khtt}    ${input_khtt_hd}
    ${get_ma_hd}    Add new invoice frm API    ${input_ma_kh}    ${dic_productnums_th}    ${input_khtt_hd}
    #get data frm Trả hàng
    ${get_no_bf_execute}    Get Du no cuoi KH from API    ${input_ma_kh}
    ${list_product_th}    Get Dictionary Keys    ${dic_product_nums_th}
    ${list_nums_th}    Get Dictionary Values    ${dic_product_nums_th}
    ${list_result_thanhtien_th}    ${list_giavon_th}    ${list_result_toncuoi_th}    Get list total sale - endingstock - cost frm product api    ${list_product_th}    ${list_nums_th}
    ${get_onhand_dth}    ${get_baseprice}   Get Onhand and Baseprice frm API    ${input_product_dth}
    ${result_thanhtien_dth}     Multiplication with price round 2    ${get_baseprice}   51
    #compute trả hàng
    ${result_tongtientra}    Sum values in list    ${list_result_thanhtien_th}
    ${result_phi_th}    Run Keyword If    0 < ${input_phi_th} < 100    Convert % discount to VND and round    ${result_tongtientra}    ${input_phi_th}
    ...    ELSE    Set Variable    ${input_phi_th}
    ${result_tongtientra_tru_phith}    Minus and round 2    ${result_tongtientra}    ${result_phi_th}
    #compute mua hàng
    ${result_ggdth}    Run Keyword If    0 < ${input_ggdth} < 100    Convert % discount to VND and round    ${result_thanhtien_dth}    ${input_ggdth}
    ...    ELSE    Set Variable    ${input_ggdth}
    ${result_tongtienmua_tru_gg}    Minus and round 2       ${result_thanhtien_dth}     ${result_ggdth}
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
    ${result_du_no_dth_KH}    Sum and replace floating point    ${result_PTT_th_KH}    ${result_tongtienmua_tru_gg}
    ${result_PTT_dth_KH}    Run Keyword If    ${result_tongtienmua_tru_gg}>${result_tongtientra_tru_phith}    Minus    ${result_du_no_dth_KH}    ${actual_khtt}
    ...    ELSE    Set Variable    ${result_du_no_dth_KH}
    #create đổi trả hàng
    Wait Until Keyword Succeeds    3 times    8 s    Before Test turning on display mode      ${toggle_item_themdong}
    Select Invoice from Ban Hang page    ${get_ma_hd}
    ${lastest_num}    Set Variable    0
    : FOR    ${item_product}    ${item_nums}    IN ZIP    ${list_product_th}    ${list_nums_th}
    \    ${laster_nums}    Wait Until Keyword Succeeds    3 times    5 s    Input product-num in sale form    ${item_product}
    \    ...    ${item_nums}    ${lastest_num}    ${cell_laster_numbers_return}
    Log     Input doi tra hang
    ${lastest_num1}    Set Variable    0
    ${lastest_num1}    Input product and nums into Doi tra hang form    ${input_product_dth}    ${input_nums_dth}    ${lastest_num1}
    ${button_add_row_infirstline}    Format String     ${button_add_row_infirstline}   ${input_product_dth}
     : FOR    ${item}    IN RANGE    50
     \   Wait Until Element Is Visible    ${button_add_row_infirstline}
     \   Click Element JS    ${button_add_row_infirstline}
    Wait Until Keyword Succeeds    3 times    5 s    Run keyword if    0 < ${input_phi_th} < 100    Input % return free value    ${input_phi_th}
    ...    ${result_phi_th}   ELSE    Input VND return free value    ${input_phi_th}
    Wait Until Keyword Succeeds    3 times    5 s    Run Keyword If    0 < ${input_ggdth} < 100    Input % discount additional invoice    ${input_ggdth}
    ...    ${result_ggdth}    ELSE    Input VND discount additional invoice    ${input_ggdth}
    ${button_thanhtoan}    Set Variable If    ${result_tongtienmua_tru_gg}<${result_tongtientra_tru_phith}    ${textbox_dth_tientrakhach}    ${textbox_dth_khachthanhtoan}
    Wait Until Keyword Succeeds    3 times    5 s    Run Keyword If    "${input_khtt}" == "all"    Click Element JS    ${button_th}
    ...    ELSE    Input payment into any form    ${button_thanhtoan}    ${input_khtt}    ${button_th}
    Return message success validation
    ${return_code}    Get saved code after execute
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
    ${num_soluong_in_chungtu}    ${cost_in_chungtu}    ${toncuoi_in_chungtu}    Get Cost - onhand - quantity frm API after purchase    ${get_additional_invoice_code}    ${input_product_dth}
    Should Be Equal As Numbers    ${num_soluong_in_chungtu}    51
    Should Be Equal As Numbers    ${toncuoi_in_chungtu}    0
    #assert value in return
    ${get_tongtienhangtra_af_ex}    ${get_phitrahang_af_ex}    ${get_cantrakhach_af_ex}    ${get_datrakhach_af_ex}    ${get_tongtien_hoadontra_af_ex}    Get return info by return code    ${return_code}
    Should Be Equal As Numbers    ${get_tongtienhangtra_af_ex}    ${result_tongtientra}
    Should Be Equal As Numbers    ${get_phitrahang_af_ex}    ${result_phi_th}
    Should Be Equal As Numbers    ${get_datrakhach_af_ex}    ${actuall_trahang}
    Should Be Equal As Numbers    ${get_tongtien_hoadontra_af_ex}    ${result_tongtientra_tru_phith}
    #assert value in đổi hàng
    ${get_ma_kh_by_hd_af_ex}    ${get_tong_tien_hang_af_ex}    ${get_khach_tt_af_ex}    ${get_giamgia_hd_af_ex}    ${get_khach_can_tra_af_ex}    ${get_trangthai_af_ex}    Get additional invoice info incase discount by additional invoice code
    ...    ${get_additional_invoice_code}
    Should Be Equal As Numbers    ${get_tong_tien_hang_af_ex}    ${result_thanhtien_dth}
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
