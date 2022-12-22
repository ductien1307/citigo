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
&{list_productnums_DTH}    KLCB008=55    KLDV007=6.5    KLQD007=3    KLSI0008=2    KLT0007=6
&{list_productnums_TH}    KLDV008=3.5
@{list_discount}    10,21000.5    0,20000.5    120000,2000.5,0    5000,150000.5    5000.3,10
@{list_discount_type}    dis,change    none,change    change,dis,none    dis,change    dis,dis
@{list_num_dth}    5,4.5    3,8    3.5,3,6    2,3    2.5,3

*** Test Cases ***    List product trả hàng      List product đổi trả hàng    Phí trả hàng    List num trả hàng    List change         List change type         GGDTH    Khách thanh toán
Basic                 [Tags]                     DTKL
                      [Template]                 edthn_nn_04
                      ${list_product_nums_TH}    ${list_product_nums_DTH}     20000           ${list_num_dth}      ${list_discount}    ${list_discount_type}    50000    20                  50000

*** Keywords ***
edthn_nn_04
    [Arguments]    ${dic_product_nums_th}    ${list_product_dth}    ${input_phi_th}    ${list_num}    ${list_change}    ${list_change_type}
    ...    ${input_ggdth}    ${input_khtt}    ${input_khtt_hd}
    ${get_ma_hd}    Add new invoice without customer thr API    ${dic_product_nums_th}    ${input_khtt_hd}
    #tach sp imei khoi list
    ${get_list_baseprice}    Get list of Baseprice by Product Code    ${list_product_dth}
    ${get_list_imei_status}    Get list imei status thr API    ${list_product_dth}
    #tao list imei cho sp
    ${list_imei}    create list
    : FOR    ${item_product}    ${item_num}    ${item_status}    IN ZIP    ${list_product_dth}    ${list_num}
    ...    ${get_list_imei_status}
    \    ${item_num}    Split String    ${item_num}    ,
    \    ${imei_by_product}    Run Keyword If    '${item_status}'=='True'    Create list imei for multi row    ${item_product}    ${item_num}
    \    ...    ELSE    Set Variable    ${EMPTY}
    \    Append To List    ${list_imei}    ${imei_by_product}
    Log    ${list_imei}
    #get data frm Trả hàng
    Sleep    5s
    ${get_ma_kh_by_hd_bf_ex}    ${get_tong_tien_hang_bf_ex}    ${get_khach_tt_bf_ex}    ${get_trangthai_bf_ex}    Get invoice info by invoice code    ${get_ma_hd}
    ${get_list_hh_in_hd}    ${get_list_sl_in_hd}    Get list product and quantity frm invoice API    ${get_ma_hd}
    ${get_list_sl_in_hd}    Convert String to List    ${get_list_sl_in_hd}
    ${list_result_thanhtien_th}    ${list_giavon_th}    ${list_result_toncuoi_th}    Get list total sale - endingstock - cost frm product api    ${get_list_hh_in_hd}    ${get_list_sl_in_hd}
    ${get_list_baseprice}    Get list of Baseprice by Product Code    ${list_product_dth}
    #input product into DTH form
    Wait Until Keyword Succeeds    3 times    8 s    Before Test turning on display mode    ${toggle_item_themdong}
    Select Invoice from Ban Hang page    ${get_ma_hd}
    Log    input from tra hang
    ${lastest_num}    Set Variable    0
    : FOR    ${item_product}    ${item_nums}    IN ZIP    ${get_list_hh_in_hd}    ${get_list_sl_in_hd}
    \    ${laster_nums}    Wait Until Keyword Succeeds    3 times    5 s    Input product-num in sale form    ${item_product}
    \    ...    ${item_nums}    ${lastest_num}    ${cell_laster_numbers_return}
    Log    input form doi hang
    ${get_list_pr_dth_id}     Get list product id thr API      ${list_product_dth}
    ${lastest_num1}    Set Variable    0
    : FOR    ${item_product_dth}    ${item_nums_dth}    ${item_giaban}    ${item_change}    ${item_change_type}    ${item_status}
    ...    ${item_imei}    ${item_pr_id}    IN ZIP    ${list_product_dth}    ${list_num}    ${get_list_baseprice}    ${list_change}
    ...    ${list_change_type}    ${get_list_imei_status}    ${list_imei}     ${get_list_pr_dth_id}
    \    ${item_nums_dth}    Split String    ${item_nums_dth}    ,
    \    ${item_change}    Split String    ${item_change}    ,
    \    ${item_change_type}    Split String    ${item_change_type}    ,
    \    ${num_imei}    Run Keyword If    '${item_status}'=='True'    Sum values in list    ${item_nums_dth}
    \    ...    ELSE    Set Variable    none
    \    ${get_num_main}    Remove From List    ${item_nums_dth}    0
    \    ${get_change_main}    Remove From List    ${item_change}    0
    \    ${get_change_type_main}    Remove From List    ${item_change_type}    0
    \    ${get_imei_main}    Run Keyword If    '${item_status}'=='True'    Remove From List    ${item_imei}    0
    \    ...    ELSE    Set Variable    ${EMPTY}
    \    ${lastest_num1}    Run Keyword If    '${item_status}'=='True'    Sum    ${lastest_num1}    ${num_imei}
    \    ...    ELSE    Set Variable    ${lastest_num1}
    \    ${lastest_num1}    Run Keyword If    '${item_status}'!='True'    Wait Until Keyword Succeeds    3 times    5 s
    \    ...    Input product and nums into Doi tra hang form    ${item_product_dth}    ${get_num_main}    ${lastest_num1}
    \    ...    ELSE    Set Variable    ${lastest_num1}
    \    ${laster_nums2}    Run Keyword If    '${item_status}'=='True'    Wait Until Keyword Succeeds    3 times    8 s
    \    ...    Input product and imei incase multi product to any form    ${textbox_th_search_hangdoi}    ${item_product_dth}    ${cell_dth_sanpham}    ${textbox_dth_nhap_serial}
    \    ...    ${item_dth_imei_in_dropdown}    ${cell_dth_ma_sanpham}    ${cell_dth_imei_multi_product}    @{get_imei_main}
    \    ...    ELSE    Set Variable    ${EMPTY}
    \    ${newprice}    Run Keyword If    0<${get_change_main}<100 and '${get_change_type_main}'=='dis'    Price after % discount product    ${item_giaban}    ${get_change_main}
    \    ...    ELSE IF    ${get_change_main}>100 and '${get_change_type_main}'=='dis'    Minus    ${item_giaban}    ${get_change_main}
    \    ...    ELSE IF    '${get_change_type_main}'=='change'    Set Variable    ${get_change_main}
    \    ...    ELSE    Set Variable    ${item_giaban}
    \    Wait Until Keyword Succeeds    3 times    5 s    Run keyword if    0<${get_change_main}<100 and '${get_change_type_main}'=='dis'    Input % discount for multi product
    \    ...    ${item_product_dth}    ${get_change_main}    ${newprice}
    \    ...    ELSE IF    ${get_change_main}>100 and '${get_change_type_main}'=='dis'    Input VND discount for multi product    ${item_product_dth}    ${get_change_main}
    \    ...    ${newprice}
    \    ...    ELSE IF    '${get_change_type_main}'=='change'    Input newprice for multi product    ${item_product_dth}    ${get_change_main}
    \    ...    ELSE    Log    Ignore input change
    \    ${lastest_num1}    Run Keyword If    '${item_status}'!='True'    Add row and input data in Doi tra hang form     ${item_product_dth}   ${item_pr_id}    ${item_nums_dth}
    \    ...    ${lastest_num1}    ${item_giaban}    ${item_change}    ${item_change_type}
    \    ...    ELSE    Set Variable    ${lastest_num1}
    \    Run Keyword If    '${item_status}'=='True'    Add row and input imei in Doi tra hang form    ${item_product_dth}    ${item_pr_id}    ${item_imei}    ${item_giaban}
    \    ...    ${item_change}    ${item_change_type}
    \    ...    ELSE    Log    ignore input imei
    Log    tính thanh tien phieu doi
    ${list_result_thanhtien_dth}    ${list_giavon_dth}    ${list_result_toncuoi_dth}    Get list total sale - endingstock - cost incase changing product price with additional multi row invoice    ${list_product_dth}    ${list_num}    ${list_change}
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
    ${get_list_cost_af}    ${get_list_onhand_af}    Get list cost - onhand frm API    ${list_product_dth}
    : FOR    ${item_cost_actual}    ${item_onhand_actual}    ${item_cost}    ${item_onhand}    IN ZIP    ${get_list_cost_af}
    ...    ${get_list_onhand_af}    ${list_giavon_dth}    ${list_result_toncuoi_dth}
    \    Should Be Equal As Numbers    ${item_cost_actual}    ${item_cost}
    \    Should Be Equal As Numbers    ${item_onhand_actual}    ${item_onhand}
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
    Should Be Equal As Strings    ${get_ma_kh_by_hd_af_ex}    0
    Should Be Equal As Strings    ${get_trangthai_af_ex}    Hoàn thành
