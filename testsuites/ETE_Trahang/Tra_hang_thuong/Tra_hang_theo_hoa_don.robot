*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    ${headless_browser}
Test Setup
Test Teardown     After Test
Resource          ../../../core/API/api_danhmuc_hanghoa.robot
Resource          ../../../core/API/api_khachhang.robot
Resource          ../../../core/API/api_mhbh.robot
Resource          ../../../core/share/toast_message.robot
Resource          ../../../core/API/api_soquy.robot
Resource          ../../../core/share/javascript.robot
Resource          ../../../core/share/list_dictionary.robot
Resource          ../../../core/share/imei.robot
Resource          ../../../core/share/discount.robot
Resource          ../../../core/Tra_hang/tra_hang_action.robot
Resource          ../../../core/API/api_trahang.robot
Resource          ../../../core/Tra_hang/tra_hang_page.robot
Resource          ../../../core/Tra_hang/tra_hang_popup_page.robot
Resource          ../../../core/Ban_Hang/banhang_action.robot
Resource          ../../../core/Ban_Hang/banhang_page.robot
Resource          ../../../core/API/api_hoadon_banhang.robot

*** Variables ***
&{dict_product1}    HH0081=3.75    SI063=2    QD149=1   DV087=1.5    Combo66=3    QDBTT12=3.7
&{dict_product2}    HH0082=4.2    SI064=2    DVT83=2    DV088=2.5    Combo67=3
&{dict_product3}    HH0083=5.1    SI065=1    QD151=3    DV089=1.75    Combo68=1
&{dict_product4}    HH0084=5.1    SI066=1    QD152=3    DV090=1.75    Combo69=1
&{dict_delete_product01}     SI063=2    DV087=1.5
&{dict_delete_product02}    Combo67=3    SI064=2
@{list_discount}    15    0    330000.23    150000.45    5000
@{discount_type}    dis   none    changeup    changedown    disvnd

*** Test Cases ***    Mã KH         List products        List product del             List GGSP        List discount type    Phí trả hàng    GGHD     Khách thanh toán
Lay 1 phan_golive            [Tags]        ETH       ET
                      [Template]    eth_invoice01
                      CTKH126       ${dict_product1}    ${dict_delete_product01}    ${list_discount}    ${discount_type}       50000           10000        all
                      CTKH127       ${dict_product2}    ${dict_delete_product02}    ${list_discount}    ${discount_type}       0              15        0

Lay all               [Tags]      ETH
                      [Template]    eth_invoice02
                      CTKH128       ${dict_product3}    ${list_discount}    ${discount_type}       15              10          0            all
                      CTKH129       ${dictproduct4}     ${list_discount}    ${discount_type}       15000           20000      550000         50000

*** Keywords ***
eth_invoice01
    [Arguments]    ${input_ma_kh}    ${dict_product_nums}    ${dict_products_delete}    ${list_ggsp}    ${list_discount_type}    ${input_phi_th}
    ...    ${input_gghd}    ${input_khtt}
    Set Selenium Speed    0.5s
    #create hoa don
    ${list_products_delete}    Get Dictionary Keys    ${dict_products_delete}
    ${list_nums_delete}    Get Dictionary Values    ${dict_products_delete}
    ${get_ma_hd}    Add new invoice with multi product    ${input_ma_kh}    ${dict_product_nums}    ${input_gghd}    ${input_khtt}
    #get data to validate
    Sleep   4s
    ${get_ma_kh_by_hd_bf_ex}    ${get_tong_tien_hang_bf_ex}    ${get_khach_tt_bf_ex}    ${get_giamgia_hd_bf_ex}    ${get_khachcantra_bf_ex}    ${get_trangthai_bf_ex}    Get invoice info incase discount by invoice code
    ...    ${get_ma_hd}
    ${get_list_giavon_delete}    ${get_list_ton_delete}    Get list cost - onhand frm API    ${list_products_delete}
    ${get_no_bf_execute}    ${get_tongban_bf_execute}    ${get_tongban_tru_trahang_bf_execute}    Get Customer Debt from API    ${input_ma_kh}
    ${get_list_hh_in_hd}    Get list product frm Invoice API    ${get_ma_hd}
    : FOR    ${item_product}    IN    @{list_products_delete}
    \    Remove Values From List    ${get_list_hh_in_hd}    ${item_product}
    Log    ${get_list_hh_in_hd}
    ${get_list_status_product}    Get list imei status thr API    ${get_list_hh_in_hd}
    ${get_list_ggsp}    ${get_list_sl_in_hd}    Get list discount and quantity frm invoice api    ${get_ma_hd}    ${get_list_hh_in_hd}
    ${get_list_imei_in_hd}    Get list imei by product code in invoice    ${get_ma_hd}    ${get_list_hh_in_hd}
    ${get_list_sl_in_hd}    Convert String to List    ${get_list_sl_in_hd}
    ${get_list_ggsp}    Convert String to List    ${get_list_ggsp}
    ${list_result_thanhtien}    ${list_giavon}    ${list_result_toncuoi}    ${list_result_newprice}    Get list total sale - endingstock - cost - newprice incase discount frm api    ${get_list_hh_in_hd}
    ...    ${get_list_sl_in_hd}    ${list_ggsp}    ${list_discount_type}
    #compute allocation discount
    ${result_gghd}    Run Keyword If    0 < ${input_gghd} < 100    Convert % discount to VND and round    ${get_tong_tien_hang_bf_ex}    ${input_gghd}
    ...    ELSE    Set Variable    ${input_gghd}
    ${list_result_gghd}    Create List
    : FOR    ${item_result_thanhtien}    IN    @{list_result_thanhtien}
    \    ${item_gghd}    Run Keyword If    ${input_gghd} > 0    Price after apllocate discount    ${result_gghd}    ${get_tong_tien_hang_bf_ex}
    \    ...    ${item_result_thanhtien}    ELSE    Set Variable    0
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
    ${result_PTT_th_KH}    Sum and round 2    ${result_du_no_th_KH}    ${actual_khtt}
    ${result_tongban_tru_TH}    Minus    ${get_tongban_tru_trahang_bf_execute}    ${result_cantrakhach}
    #create return
    Wait Until Keyword Succeeds    3 times    5s    Before Test Ban Hang deactivate print warranty
    Wait Until Keyword Succeeds    3 times    5s    Select Invoice from Ban Hang page    ${get_ma_hd}
    ${lastest_number}     Set Variable    0
    : FOR    ${item_hh}    ${item_soluong}    ${item_status}    ${item_imei}    ${item_discount}   ${item_discount_type}    ${item_newprice}    IN ZIP    ${get_list_hh_in_hd}    ${get_list_sl_in_hd}    ${get_list_status_product}
    ...    ${get_list_imei_in_hd}    ${list_ggsp}    ${list_discount_type}    ${list_result_newprice}
    \    ${lastest_number}    Run Keyword If    '${item_status}' == 'True'    Input imei incase multi product to any form - return lastest    ${item_hh}    ${item_soluong}
    \    ...    ${texbox_imei_search_multi_product}    ${item_serial_in_dropdown}    ${cell_imei_multi_product}    ${lastest_number}    @{item_imei}
    \    ...    ELSE     Input nums for multi product    ${item_hh}    ${item_soluong}    ${lastest_number}    ${cell_laster_numbers_return}
    \    Run keyword if    '${item_discount_type}' == 'dis'    Wait Until Keyword Succeeds    3 times    5 s    Input % discount for multi product    ${item_hh}    ${item_discount}    ${item_newprice}
    \    ...    ELSE IF    '${item_discount_type}' == 'disvnd'    Wait Until Keyword Succeeds    3 times    5 s    Input VND discount for multi product    ${item_hh}    ${item_discount}    ${item_newprice}
    \    ...    ELSE IF     '${item_discount_type}' == 'changeup' or '${item_discount_type}' == 'changedown'  Wait Until Keyword Succeeds    3 times    5 s    Input newprice for multi product    ${item_hh}
    \    ...    ${item_discount}        ELSE       Log        ignore
    Wait Until Keyword Succeeds    3 times    5s    Run keyword if    0 < ${input_phi_th} < 100    Input % return free value    ${input_phi_th}
    ...    ${result_phi_th}    ELSE    Input VND return free value    ${input_phi_th}
    Wait Until Keyword Succeeds    3 times    5s    Input payment into any form    ${textbox_th_khachttTraHang}    ${result_khtt}    ${button_th}
    Wait Until Keyword Succeeds    3 times    5s    Run Keyword If    0 <=${get_khach_tt_bf_ex} < ${result_tongtienhangtra} and ${input_khtt} != 0 and ${get_no_bf_execute} > 0    Close return popup
    ...    ELSE    Log    Ignore click
    Sleep    1s
    ${return_code}    Get saved code until success
    Execute Javascript    location.reload();
    #assert value product in invoice
    Assert list of onhand after order process    ${return_code}    ${get_list_hh_in_hd}    ${get_list_sl_in_hd}    ${list_result_toncuoi}
    #assert value product in invoice
    Assert list of onhand after order process    ${return_code}    ${list_products_delete}    ${list_nums_delete}    ${get_list_ton_delete}
    #assert value invoice
    Assert invoice info after execute    ${get_ma_hd}    ${get_ma_kh_by_hd_bf_ex}    ${get_tong_tien_hang_bf_ex}    ${get_khachcantra_bf_ex}    ${get_khach_tt_bf_ex}
    ...    ${result_gghd}
    #assert value in return
    Assert values by return code until succeed    ${return_code}    ${result_tongtienhangtra}    ${result_allocate_gghd}    ${result_phi_th}    ${result_cantrakhach}    ${actual_khtt}
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

eth_invoice02
    [Arguments]    ${input_ma_kh}    ${dict_product_nums}    ${list_ggsp}    ${list_discount_type}    ${input_phi_th}    ${input_gghd}    ${input_khtt_tocreate}     ${input_khtt}
    Set Selenium Speed    0.5s
    #create hoa don
    ${get_ma_hd}    Add new invoice incase discount - return code    ${input_ma_kh}    ${dict_product_nums}    ${list_ggsp}    ${list_discount_type}    ${input_gghd}    ${input_khtt_tocreate}
    #get data to validate
    Sleep   4s
    ${get_du_no_kh}    Get Du no cuoi KH from API    ${input_ma_kh}
    ${get_list_hh_in_hd}    ${get_list_sl_in_hd}    Get list product and quantity frm invoice API    ${get_ma_hd}
    ${get_list_status_product}    Get list imei status thr API    ${get_list_hh_in_hd}
    ${get_list_sl_in_hd}    Convert String to List    ${get_list_sl_in_hd}
    ${get_ma_kh_by_hd_bf_ex}    ${get_tong_tien_hang_bf_ex}    ${get_khach_tt_bf_ex}    ${get_giamgia_hd_bf_ex}    ${get_khachcantra_bf_ex}    ${get_trangthai_bf_ex}    Get invoice info incase discount by invoice code
    ...    ${get_ma_hd}
    ${list_result_thanhtien}    ${list_giavon}    ${list_result_toncuoi}    ${list_result_newprice}    Get list total sale - endingstock - cost - newprice incase discount frm api    ${get_list_hh_in_hd}
    ...    ${get_list_sl_in_hd}    ${list_ggsp}    ${list_discount_type}
    #compute allocation discount
    ${result_gghd}    Run Keyword If    0 < ${input_gghd} < 100    Convert % discount to VND and round    ${get_tong_tien_hang_bf_ex}    ${input_gghd}
    ...    ELSE    Set Variable    ${input_gghd}
    ${result_tongtienhangtra}    Sum values in list    ${list_result_thanhtien}
    ${result_phi_th}    Run Keyword If    0 < ${input_phi_th} < 100    Convert % discount to VND and round    ${result_tongtienhangtra}    ${input_phi_th}
    ...    ELSE    Set Variable    ${input_phi_th}
    ${result_cantrakhach}    Minusx3 and replace foating point    ${result_tongtienhangtra}    ${result_phi_th}    ${result_gghd}
    ${result_khtt}    Set Variable If    "${input_khtt}" == "all"    ${result_cantrakhach}    ${input_khtt}
    ${actual_khtt}    Set Variable If    "${input_khtt}" == "0"    0    ${result_khtt}
    #create return
    Wait Until Keyword Succeeds    3 times    8 s    Before Test Ban Hang deactivate print warranty
    Select Invoice from Ban Hang page    ${get_ma_hd}
    ${lastest_number}    Set Variable    0
    : FOR    ${item_hh}    ${item_soluong}    ${item_status}    ${item_imei}    IN ZIP    ${get_list_hh_in_hd}    ${get_list_sl_in_hd}    ${get_list_status_product}
    ...    ${imei_inlist}
    \    ${lastest_number}    Run Keyword If    '${item_status}' == 'True'    Input imei incase multi product to any form - return lastest    ${item_hh}    ${item_soluong}
    \    ...    ${texbox_imei_search_multi_product}    ${item_serial_in_dropdown}    ${cell_imei_multi_product}    ${lastest_number}    @{item_imei}
    \    ...    ELSE     Input nums for multi product    ${item_hh}    ${item_soluong}    ${lastest_number}    ${cell_laster_numbers_return}
    Wait Until Keyword Succeeds    3 times    8 s    Run keyword if    0 < ${input_phi_th} < 100    Input % return free value    ${input_phi_th}
    ...    ${result_phi_th}    ELSE    Input VND return free value    ${input_phi_th}
    Wait Until Keyword Succeeds    3 times    8 s    Input payment into any form    ${textbox_th_khachttTraHang}    ${result_khtt}    ${button_th}
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
    ${get_tongtienhangtra_af_ex}    ${get_giamgiaphieutra}    ${get_phitrahang_af_ex}    ${get_cantrakhach_af_ex}    ${get_datrakhach_af_ex}    ${get_tongtien_hoadontra_af_ex}    Get return info incase discount by return code
    ...    ${return_code}
    Should Be Equal As Numbers    ${get_tongtienhangtra_af_ex}    ${result_tongtienhangtra}
    Should Be Equal As Numbers    ${get_giamgiaphieutra}    ${result_gghd}
    Should Be Equal As Numbers    ${get_phitrahang_af_ex}    ${result_phi_th}
    Should Be Equal As Numbers    ${get_tongtien_hoadontra_af_ex}    ${result_cantrakhach}
    Should Be Equal As Numbers    ${get_datrakhach_af_ex}    ${actual_khtt}
    Validate return history by invoice code    ${get_ma_hd}    ${return_code}    ${result_tongtienhangtra}
    Delete return thr API    ${return_code}
