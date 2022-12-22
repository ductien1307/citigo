*** Settings ***
Library           SeleniumLibrary
Resource          tra_hang_page.robot
Resource          ../share/constants.robot
Resource          ../share/javascript.robot
Resource          ../share/computation.robot
Resource          tra_hang_popup_page.robot
Resource          tra_hang_action.robot
Resource          ../API/api_danhmuc_hanghoa.robot

*** Keywords ***
Select Return without Invoice from BH page
    Wait Until Page Contains Element    ${icon_select_th_hd}    2 mins
    Click Element JS    ${icon_select_th_hd}
    Wait Until Page Contains Element    ${button_th_tranhang_nhanh}    2 mins
    Click Element JS    ${button_th_tranhang_nhanh}

Select Invoice from Ban Hang page
    [Arguments]    ${input_th_ma_hd}
    Wait Until Page Contains Element    ${icon_select_th_hd}    2 mins
    Click Element JS    ${icon_select_th_hd}
    Wait Until Page Contains Element    ${textbox_th_search_ma_hd}    2 mins
    Input data    ${textbox_th_search_ma_hd}    ${input_th_ma_hd}
    ${button_th_chon_hd}    Format String    ${button_th_chon_hd}    ${input_th_ma_hd}
    Wait Until Page Contains Element    ${button_th_chon_hd}    2 mins
    Click Element JS    ${button_th_chon_hd}
    Wait Until Page Contains Element    ${cell_th_giamoi_hangtra}       1 min

Input data to Doi hang form
    [Arguments]    ${input_soluong_tra}    ${input_giamoi_tra}    ${input_search_hangdoi}    ${input_soluong_doi}    ${input_giamoi_doi}    ${input_khachtt}
    Input Text    ${texbox_th_soluong_tra}    ${input_soluong_tra}
    Input new price repurchase product    ${input_giamoi_tra}
    Input Text    ${textbox_th_search_hangdoi}    ${input_search_hangdoi}
    Press Key    ${textbox_th_search_hangdoi}    ${ENTER_KEY}
    Input Text    ${textbox_th_soluong_doi}    ${input_soluong_doi}
    Input new price purchase product    ${input_giamoi_doi}
    Input Text    ${textbox_th_khachttTraHang}    ${input_khachtt}

Input new price repurchase product
    [Arguments]    ${input_giamoi_tra}
    Click Element JS    ${cell_th_giamoi_hangtra}
    Input Text    ${textbox_th_giamoi}    ${input_giamoi_tra}
    Press Key    ${textbox_th_giamoi}    ${ESC_KEY}

Input new price purchase product
    [Arguments]    ${input_giamoi_doi}
    Click Element JS    ${cell_th_giamoi_hangdoi}
    Input Text    ${textbox_th_giamoi}    ${input_giamoi_doi}
    Press Key    ${textbox_th_giamoi}    ${ESC_KEY}

Get tong tien
    ${get_tongtientra}    Get Text    ${cell_tong_tien_tra}
    ${get_tongtientra}    Convert Any To Number    ${get_tongtientra}
    ${get_tongtienmua}    Get Text    ${cell_tong_tien_mua}
    ${get_tongtienmua}    Convert Any To Number    ${get_tongtienmua}
    ${get_khach_tt_avg}    Get Text    ${cell_khach_tt_avg}
    ${get_khach_tt_avg}    Convert Any To Number    ${get_khach_tt_avg}
    Return From Keyword    ${get_tongtientra}    ${get_tongtienmua}    ${get_khach_tt_avg}

Execute can tra khach
    [Arguments]    ${result_thanhtien_tra}    ${result_thanhtien_mua}
    ${get_tongtientra}    ${get_tongtienmua}    ${get_khach_tt_avg}    Get tong tien
    ${result_can_tra_khach}    Minus    ${result_thanhtien_tra}    ${result_thanhtien_mua}
    Should Be Equal As Numbers    ${get_khach_tt_avg}    ${result_can_tra_khach}
    Element Should Contain    ${cell_payment_status}    Cần trả khách
    Return From Keyword    ${result_can_tra_khach}

Execute khach can tra
    [Arguments]    ${result_thanhtien_mua}    ${result_thanhtien_tra}
    ${get_tongtientra}    ${get_tongtienmua}    ${get_khach_tt_avg}    Get tong tien
    ${result_khach_can_tra}    Minus    ${result_thanhtien_mua}    ${result_thanhtien_tra}
    Should Be Equal As Numbers    ${get_khach_tt_avg}    ${result_khach_can_tra}
    Element Should Contain    ${cell_payment_status}    Khách cần trả
    Return From Keyword    ${result_khach_can_tra}

Assert no can tra khach
    [Arguments]    ${no_before_repurchase}    ${tt_this_invoice}    ${get_no_after_repurchase}
    ${result_no_after_repurchase}    Minus    ${no_before_repurchase}    ${tt_this_invoice}
    Return From Keyword    ${result_no_after_repurchase}
    Should Be Equal As Numbers    ${result_no_after_repurchase}    ${get_no_after_repurchase}

Assert no khach can tra
    [Arguments]    ${no_before_repurchase}    ${tt_this_invoice}    ${get_no_after_repurchase}
    ${result_no_after_repurchase}=    sum    ${no_before_repurchase}    ${tt_this_invoice}
    Return From Keyword    ${result_no_after_repurchase}
    Should Be Equal As Numbers    ${result_no_after_repurchase}    ${get_no_after_repurchase}

Input VND return free value
    [Arguments]    ${input_phi_trahang}
    Wait Until Page Contains Element    ${button_phi_trahang}    3s
    Click Element JS    ${button_phi_trahang}
    Wait Until Keyword Succeeds    3 times    20 s    Input data    ${textbox_phi_th_giamgia}    ${input_phi_trahang}
    Sleep    5s
    ${return_free}    Wait Until Keyword Succeeds    3 times    20 s    Get New price from UI    ${button_phi_trahang}
    Should Be Equal As Numbers    ${return_free}    ${input_phi_trahang}

Input % return free value
    [Arguments]    ${input_phi_trahang%}    ${result_phi_th_%}
    [Timeout]    5 minutes
    Wait Until Page Contains Element    ${button_phi_trahang}    3s
    Click Element JS    ${button_phi_trahang}
    Wait Until Page Contains Element    ${button_th_giamgia%}    3s
    Click Element JS    ${button_th_giamgia%}
    Wait Until Keyword Succeeds    3 times    20 s    Input data    ${textbox_phi_th_giamgia%}    ${input_phi_trahang%}
    Sleep    5s
    ${return_free}    Wait Until Keyword Succeeds    3 times    20 s    Get New price from UI    ${button_phi_trahang}
    Should Be Equal As Numbers    ${return_free}    ${result_phi_th_%}

Computation endingstock frm API
    [Arguments]    ${input_nums}    ${input_onhand}    ${get_product_type}    ${get_toncuoi_dv_execute}
    ${result_toncuoi_hht}    Sum and round 3    ${input_onhand}    ${input_nums}
    ${result_toncuoi_dv}    Sum and round 3    ${get_toncuoi_dv_execute}    ${input_nums}
    ${result_toncuoi_cb}    Set Variable If    '${get_product_type}' == '1'    0
    ${result_toncuoi_bf}    Set Variable If    '${get_product_type}' == '2'    ${result_toncuoi_hht}    ${result_toncuoi_dv}
    ${result_toncuoi}    Set Variable If    '${get_product_type}' == '1'    ${result_toncuoi_cb}    ${result_toncuoi_bf}
    Return From Keyword    ${result_toncuoi}

Computation endingstock for unit product
    [Arguments]    ${input_product}    ${input_nums}    ${get_giatri_quydoi}
    ${get_ma_hh_cb}    Get basic product frm unit product    ${input_product}
    ${ton_cuoi_cb}    Get onhand frm API    ${get_ma_hh_cb}
    ${result_soluongban}    Multiplication with price round 2    ${input_nums}    ${get_giatri_quydoi}
    ${result_toncuoi}    Sum and round 3    ${ton_cuoi_cb}    ${result_soluongban}
    Return From Keyword    ${result_toncuoi}

Computation and get endingstock frm API
    [Arguments]    ${input_product}    ${input_nums}    ${input_onhand}    ${get_product_type}    ${get_toncuoi_bf_execute}
    ${result_toncuoi_hht}    Sum and round 3    ${input_onhand}    ${input_nums}
    ${result_toncuoi_dv}    Sum and round 3    ${get_toncuoi_bf_execute}    ${input_nums}
    ${result_toncuoi_cb}    Set Variable If    '${get_product_type}' == '1'    0
    ${result_toncuoi_bf}    Set Variable If    '${get_product_type}' == '2'    ${result_toncuoi_hht}    ${result_toncuoi_dv}
    ${result_toncuoi}    Set Variable If    '${get_product_type}' == '1'    ${result_toncuoi_cb}    ${result_toncuoi_bf}
    Return From Keyword    ${result_toncuoi}

Computation and get endingstock for unit product
    [Arguments]    ${input_product}    ${input_nums}    ${get_giatri_quydoi}
    ${get_ma_hh_cb}    Get basic product frm unit product    ${input_product}
    ${ton_cuoi_cb}    Get onhand frm API    ${get_ma_hh_cb}
    ${result_soluongban}    Multiplication with price round 2    ${input_nums}    ${get_giatri_quydoi}
    ${result_toncuoi}    Sum and round 3    ${ton_cuoi_cb}    ${result_soluongban}
    Return From Keyword    ${result_toncuoi}

Assert value cost and onhand in Stock Card
    [Arguments]    ${item_cost_af_ex}    ${item_ton_af_ex}    ${item_cost}    ${item_ton}
    Should Be Equal As Numbers    ${item_cost_af_ex}    ${item_cost}
    Should Be Equal As Numbers    ${item_ton_af_ex}    ${item_ton}

Assert value cost and onhand in unit Stock Card
    [Arguments]    ${input_ma_hh}    ${item_cost}    ${item_ton}
    ${get_ma_hh_cb}    Get basic product frm unit product    ${input_ma_hh}
    ${get_ton_af_ex}    ${get_cost_af_ex}    Get Cost and OnHand frm API    ${get_ma_hh_cb}
    Should Be Equal As Numbers    ${get_cost_af_ex}    ${item_cost}
    Should Be Equal As Numbers    ${get_ton_af_ex}    ${item_ton}

Close return popup
    Wait Until Page Contains Element    ${button_dongy}    2 mins
    Wait Until Keyword Succeeds    3 times    20 s    Click Element JS    ${button_dongy}    #tắt popup lưu trả hàng

Input first quantity in Tra hang form
    [Arguments]    ${product_code}    ${input_list_quantity}    ${lastest_num}
    Wait Until Page Contains Element    ${textbox_bh_soluongban}    2 mins
    ${input_list_quantity}    Split String    ${input_list_quantity}    ,
    ${item_quan}    Get from list    ${input_list_quantity}    0
    ${lastest_num}    Input nums for multi product    ${product_code}    ${item_quan}    ${lastest_num}    ${cell_laster_numbers_return}
    Return From Keyword    ${lastest_num}

Input num for multi row product in Tra hang form
    [Arguments]    ${item_line}    ${product_code}    ${productid}    ${list_quan}    ${lastest_num}
    ${lastest_num}    Input first quantity in Tra hang form    ${product_code}    ${list_quan}    ${lastest_num}
    ${lastest_num}    Run Keyword If    ${item_line}>1    Input num for adding product    ${product_code}    ${productid}    ${list_quan}
    ...    ${lastest_num}    ${cell_laster_numbers_return}
    ...    ELSE    Set Variable    ${lastest_num}
    Return From Keyword    ${lastest_num}

Input num for adding product
    [Arguments]    ${product_code}    ${productid}    ${list_quan}    ${lastest_num}    ${cell_lastest_number}
    ${index_line}    Set Variable    -1
    ${list_quan}    Split String    ${list_quan}    ,
    ${list_remain_quan}    Copy List    ${list_quan}
    Remove From List    ${list_remain_quan}    0
    ${adding_row_number}    Get Length    ${list_remain_quan}
    : FOR    ${item_num}    IN    @{list_remain_quan}
    \    ${index_line}    Evaluate    ${index_line} + 1
    \    ${textbox_input_quan_by_line}    Format String    ${textbox_quantity_by_line}    ${productid}    ${index_line}
    \    Run Keyword If    ${item_num}!=0    Input data    ${textbox_input_quan_by_line}    ${item_num}
    \    ...    ELSE    Log    Ignore input num
    ${lastest_num}    Sum    ${adding_row_number}    ${lastest_num}
    Return From Keyword    ${lastest_num}

Input imei for multi row product in Tra hang form
    [Arguments]    ${item_line}    ${product_code}    ${product_id}    ${list_imei}    ${list_num}    ${lastest_num}
    ${item_imei}    Run Keyword If    ${item_line}>1    Get From List    ${list_imei}    0
    ...    ELSE    Set Variable    ${list_imei}
    Input imei incase multi product to any form    ${product_code}    ${texbox_imei_search_multi_product}    ${item_serial_in_dropdown}    ${cell_imei_multi_product}    @{item_imei}
    ${list_num}    Run Keyword If    ${item_line}>1    Split String    ${list_num}    ,
    ...    ELSE    Set Variable    ${list_imei}
    Run Keyword If    ${item_line}>1    Remove From List    ${list_imei}    0
    ...    ELSE    Log    ignore
    ${total_num}    Sum values in list    ${list_num}
    ${lastest_num}    Sum    ${lastest_num}    ${total_num}
    : FOR    ${item_list_imei}    IN ZIP    ${list_imei}
    \    Run Keyword If    ${item_line}>1    Input imei incase multi product to any form    ${product_id}    ${textbox_row_nhap_imei}    ${item_serial_in_dropdown}
    \    ...    ${cell_imei_multirow}    @{item_list_imei}
    \    ...    ELSE    Log    Ignore
    Return From Keyword    ${lastest_num}

Computation allocation discount of return invoice
    [Arguments]    ${get_ma_hd}    ${input_gghd}    ${list_result_thanhtien}
    ${get_ma_kh_by_hd_bf_ex}    ${get_tong_tien_hang_bf_ex}    ${get_khach_tt_bf_ex}    ${get_giamgia_hd_bf_ex}    ${get_khachcantra_bf_ex}    ${get_trangthai_bf_ex}    Get invoice info incase discount by invoice code
    ...    ${get_ma_hd}
    ${result_gghd}    Run Keyword If    0 < ${input_gghd} < 100    Convert % discount to VND and round    ${get_tong_tien_hang_bf_ex}    ${input_gghd}
    ...    ELSE    Set Variable    ${input_gghd}
    ${list_result_gghd}    Create List
    : FOR    ${item_result_thanhtien}    IN    @{list_result_thanhtien}
    \    ${item_gghd}    Run Keyword If    ${input_gghd} > 0    Price after apllocate discount    ${result_gghd}    ${get_tong_tien_hang_bf_ex}
    \    ...    ${item_result_thanhtien}    ELSE    Set Variable    0
    \    Append To List    ${list_result_gghd}    ${item_gghd}
    Return From Keyword    ${result_gghd}    ${list_result_gghd}

Computation total - allocate and pay for customer in case return with invoice code
    [Documentation]    tinhs tổng tiền hàng, chiết khấu, thông tin thanh toán của khách hàng trong case trả hàng theo hóa đơn
    [Arguments]    ${list_result_thanhtien}    ${list_result_gghd}    ${input_phi_th}    ${input_khtt}
    ${result_tongtienhangtra}    Sum values in list    ${list_result_thanhtien}
    ${result_allocate_gghd}    Sum values in list and round    ${list_result_gghd}
    ${result_phi_th}    Run Keyword If    0 < ${input_phi_th} < 100    Convert % discount to VND and round    ${result_tongtienhangtra}    ${input_phi_th}
    ...    ELSE    Set Variable    ${input_phi_th}
    ${result_cantrakhach}    Minusx3 and replace foating point    ${result_tongtienhangtra}    ${result_phi_th}    ${result_allocate_gghd}
    ${result_khtt}    Set Variable If    "${input_khtt}" == "all"    ${result_cantrakhach}    ${input_khtt}
    ${actual_khtt}    Set Variable If    "${input_khtt}" == "0"    0    ${result_khtt}
    Return From Keyword    ${result_tongtienhangtra}    ${result_allocate_gghd}    ${result_phi_th}    ${result_cantrakhach}    ${result_khtt}    ${actual_khtt}

Input number - discount and new price in return invoice
    [Documentation]    nhập số lô, giảm giá, thay đổi giá trong case trả hàng lodate theo hóa đơn
    [Arguments]    ${get_list_hh_in_hd}    ${get_list_sl_in_hd}    ${list_ggsp}    ${list_discount_type}    ${list_result_newprice}
    ${lastest_number}     Set Variable    0
    : FOR    ${item_hh}    ${item_soluong}    ${item_discount}   ${item_discount_type}    ${item_newprice}    IN ZIP    ${get_list_hh_in_hd}    ${get_list_sl_in_hd}
    ...    ${list_ggsp}    ${list_discount_type}    ${list_result_newprice}
    \    ${lastest_number}     Input nums for multi product    ${item_hh}    ${item_soluong}    ${lastest_number}    ${cell_laster_numbers_return}
    \    Run keyword if    '${item_discount_type}' == 'dis'    Wait Until Keyword Succeeds    3 times    1 s    Input % discount for multi product    ${item_hh}    ${item_discount}    ${item_newprice}
    \    ...    ELSE IF    '${item_discount_type}' == 'disvnd'    Wait Until Keyword Succeeds    3 times    1 s    Input VND discount for multi product    ${item_hh}    ${item_discount}    ${item_newprice}
    \    ...    ELSE IF     '${item_discount_type}' == 'changeup' or '${item_discount_type}' == 'changedown'  Wait Until Keyword Succeeds    3 times    5 s    Input newprice for multi product    ${item_hh}
    \    ...    ${item_discount}        ELSE       Log        ignore

Input fee and payment of return
    [Documentation]    nhập thông tin phí trả hàng
    [Arguments]     ${input_phi_th}   ${result_phi_th}    ${result_khtt}
    Wait Until Keyword Succeeds    3 times    1s    Run keyword if    0 < ${input_phi_th} < 100    Input % return free value    ${input_phi_th}
    ...    ${result_phi_th}    ELSE    Input VND return free value    ${input_phi_th}
    Wait Until Keyword Succeeds    3 times    1s    Input payment into any form    ${textbox_th_khachttTraHang}    ${result_khtt}    ${button_th}
