*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    ${headless_browser}
Test Teardown
Resource          ../../../../core/API/api_danhmuc_hanghoa.robot
Resource          ../../../../core/API/api_khachhang.robot
Resource          ../../../../core/API/api_mhbh.robot
Resource          ../../../../core/share/toast_message.robot
Resource          ../../../../core/API/api_soquy.robot
Resource          ../../../../core/share/javascript.robot
Resource          ../../../../core/Tra_hang/tra_hang_action.robot
Resource          ../../../../core/API/api_trahang.robot
Resource          ../../../../core/Tra_hang/tra_hang_page.robot
Resource          ../../../../core/Tra_hang/tra_hang_popup_page.robot
Resource          ../../../../core/Ban_Hang/banhang_action.robot
Resource          ../../../../core/Ban_Hang/banhang_page.robot
Resource          ../../../../core/API/api_hoadon_banhang.robot
Resource          ../../../../core/share/list_dictionary.robot

*** Variables ***
&{invoice_1}      KLSI0007=2    KLT0019=25    KLQD008=1    #KLQD008 sp promotion
&{discount_1}     KLSI0007=1650000    KLT0019=4000    KLQD008=50000
&{discount_type1}    KLSI0007=changeup    KLT0019=disvnd    KLQD008=disvnd
&{invoice1_product_type}    KLSI0007=imei    KLT0019=pro    KLQD008=pro
&{invoice1_promo}    KLSI0007=promo    KLT0019=sale    KLQD008=getpromo
&{return_1}       KLSI0007=1    KLT0019=0.5    KLQD008=1

*** Test Cases ***    Product and num list    Product type                Product Discount    Product discount type      Invoice Discount        Customer     Payment         Promotion Code    Dict Product Promo      Product - num Return     Phi tra hang      Tien tra khach
KM HD_HH_GiamgiaHD    [Tags]                  ETP
                      [Template]              ethkm2
                      ${invoice_1}            ${invoice1_product_type}    ${discount_1}       ${discount_type1}          300000                   DHDPT006      all             KM015             ${invoice1_promo}      ${return_1}               120000                0

*** Keywords ***
ethkm2
    [Arguments]    ${dict_product_num}    ${dict_product_type}    ${dict_discount}    ${dict_discount_type}    ${input_invoice_discount}    ${input_bh_ma_kh}
    ...    ${input_bh_khachtt}    ${input_khuyemmai}    ${dict_promo_product}    ${dict_return}    ${input_phi_th}    ${input_tien_tra_khach}
    ${get_ma_hd}    Add new invoice incase promotion invoice and product - product discount    ${dict_product_num}    ${dict_product_type}    ${dict_discount}    ${dict_discount_type}    ${input_invoice_discount}
    ...    ${input_bh_ma_kh}    ${input_bh_khachtt}    ${input_khuyemmai}    ${dict_promo_product}
    #
    Log    get data to validate
    Sleep    5s
    ${list_prs}    Get Dictionary Keys    ${dict_return}
    ${list_nums}    Get Dictionary Values    ${dict_return}
    ${list_prs_type}    Get Dictionary Values    ${dict_product_type}
    ${get_ma_kh_by_hd_bf_ex}    ${get_tong_tien_hang_bf_ex}    ${get_khach_tt_bf_ex}    ${get_giamgia_hd_bf_ex}    ${get_khachcantra_bf_ex}    ${get_trangthai_bf_ex}    Get invoice info incase discount by invoice code
    ...    ${get_ma_hd}
    ${get_du_no_kh}    Get Du no cuoi KH from API    ${input_bh_ma_kh}
    ${get_list_ggsp}    Get list discount by product code    ${get_ma_hd}    ${list_prs}
    ${list_result_thanhtien}    ${list_giavon}    ${list_result_toncuoi}    Get list total sale - endingstock - cost incase discount    ${list_prs}    ${list_nums}    ${get_list_ggsp}
    #
    Log    compute value invoice and customer
    ${result_tongtienhangtra}    Sum values in list    ${list_result_thanhtien}
    ${result_allocate_gghd}    Price after apllocate discount    ${get_giamgia_hd_bf_ex}    ${get_tong_tien_hang_bf_ex}    ${result_tongtienhangtra}
    ${result_allocate_gghd}    Evaluate    round(${result_allocate_gghd},0)
    ${result_phi_th}    Run Keyword If    0 < ${input_phi_th} < 100    Convert % discount to VND and round    ${result_tongtienhangtra}    ${input_phi_th}
    ...    ELSE    Set Variable    ${input_phi_th}
    ${result_cantrakhach}    Minusx3 and replace foating point    ${result_tongtienhangtra}    ${result_phi_th}    ${result_allocate_gghd}
    ${actual_tientrakhach}    Set Variable If    '${input_tien_tra_khach}'=='all'    ${result_cantrakhach}    ${input_tien_tra_khach}
    #
    ${list_imei_return}    Create List
    : FOR    ${item_num_return}    ${item_list_imei}    ${item_product_type}    IN ZIP    ${list_nums}    ${list_imei_all}
    ...    ${list_prs_type}
    \    ${item_list_imei_return}    Run Keyword If    '${item_product_type}'=='imei'    Convert string to List    ${item_list_imei}
    \    ...    ELSE    Set Variable    ${EMPTY}
    \    ${item_list_imei_return}    Run Keyword If    '${item_product_type}'=='imei'    Get list imei by num    ${item_num_return}    ${item_list_imei_return}
    \    ...    ELSE    Set Variable    ${EMPTY}
    \    Append To List    ${list_imei_return}    ${item_list_imei_return}
    Log    ${list_imei_return}
    #
    Log    create return
    Wait Until Keyword Succeeds    3 times    8 s    Before Test Ban Hang deactivate print warranty
    Reload Page
    Select Invoice from Ban Hang page    ${get_ma_hd}
    ${lastest_number}    Set Variable    0
    : FOR    ${item_pr}    ${item_num}    ${item_imei}    ${item_pr_type}    IN ZIP    ${list_prs}
    ...    ${list_nums}    ${list_imei_return}    ${list_prs_type}
    \    Run Keyword If    "${item_pr_type}" == "imei"    Wait Until Keyword Succeeds    3 times    8 s    Input imei incase multi product to any form
    \    ...    ${item_pr}    ${texbox_imei_search_multi_product}    ${item_serial_in_dropdown}    ${cell_imei_multi_product}    @{item_imei}
    \    ...    ELSE    Log    ignore
    \    ${lastest_number}    Run Keyword If    "${item_pr_type}" == "imei"    Sum    ${lastest_number}    ${item_num}
    \    ...    ELSE    Set Variable    ${lastest_number}
    \    ${lastest_number}    Run Keyword If    "${item_pr_type}" != "imei"    Wait Until Keyword Succeeds    3 times    8 s
    \    ...    Input nums for multi product    ${item_pr}    ${item_num}    ${lastest_number}    ${cell_laster_numbers_return}
    \    ...    ELSE    Set Variable    ${lastest_number}
    Wait Until Keyword Succeeds    3 times    8 s    Run keyword if    0 < ${input_phi_th} < 100    Input % return free value    ${input_phi_th}
    ...    ${result_phi_th}
    ...    ELSE    Input VND return free value    ${input_phi_th}
    Wait Until Keyword Succeeds    3 times    8 s    Input payment into any form    ${textbox_th_khachttTraHang}    ${actual_tientrakhach}    ${button_th}
    Wait Until Keyword Succeeds    3 times    8 s    Run Keyword If    0 <=${get_khach_tt_bf_ex} < ${result_tongtienhangtra} and ${actual_tientrakhach} != 0 and ${get_du_no_kh} > 0    Close return popup
    ...    ELSE    Log    Ignore click
    Sleep    10s
    ${return_code}    Get saved code after execute
    Execute Javascript    location.reload();
    Sleep    5 s    wait for response to API
    #
    Log    assert value product
    ${get_list_hh_in_th_af_execute}    Get list product frm Return API    ${return_code}
    ${list_soluong_in_hd}    ${list_giatriquydoi_in_hd}    Get list quantity and gia tri quy doi with return have multi product    ${get_list_hh_in_th_af_execute}    ${return_code}
    : FOR    ${item_ma_hh}    ${result_toncuoi}    ${item_giavon}    ${get_soluong_in_hd}    ${get_giatri_quydoi}    IN ZIP
    ...    ${get_list_hh_in_th_af_execute}    ${list_result_toncuoi}    ${list_giavon}    ${list_soluong_in_hd}    ${list_giatriquydoi_in_hd}
    \    Run Keyword If    '${get_giatri_quydoi}' == '1'    Validate onhand and cost frm API    ${return_code}    ${item_ma_hh}    ${result_toncuoi}
    \    ...    ${item_giavon}    ${get_soluong_in_hd}
    \    ...    ELSE    Validate onhand and cost frm unit product    ${return_code}    ${item_ma_hh}    ${result_toncuoi}
    \    ...    ${item_giavon}    ${get_soluong_in_hd}    ${get_giatri_quydoi}
    #
    Log    assert value in invoice
    ${get_ma_kh_by_hd_af_ex}    ${get_tong_tien_hang_af_ex}    ${get_khach_tt_af_ex}    ${get_giamgia_hd_af_ex}    ${get_khachcantra_af_ex}    ${get_trangthai_af_ex}    Get invoice info incase discount by invoice code
    ...    ${get_ma_hd}
    Should Be Equal As Numbers    ${get_tong_tien_hang_af_ex}    ${get_tong_tien_hang_bf_ex}
    Should Be Equal As Numbers    ${get_khach_tt_af_ex}    ${get_khach_tt_bf_ex}
    Should Be Equal As Numbers    ${get_giamgia_hd_af_ex}    ${get_giamgia_hd_bf_ex}
    Should Be Equal As Numbers    ${get_khachcantra_af_ex}    ${get_khachcantra_bf_ex}
    Should Be Equal As Strings    ${get_ma_kh_by_hd_af_ex}    ${get_ma_kh_by_hd_bf_ex}
    Should Be Equal As Strings    ${get_trangthai_af_ex}    ${get_trangthai_bf_ex}
    #
    Log    assert value in return
    ${get_tongtienhangtra_af_ex}    ${get_giamgiaphieutra}    ${get_phitrahang_af_ex}    ${get_cantrakhach_af_ex}    ${get_datrakhach_af_ex}    ${get_tongtien_hoadontra_af_ex}    Get return info incase discount by return code
    ...    ${return_code}
    Should Be Equal As Numbers    ${get_tongtienhangtra_af_ex}    ${result_tongtienhangtra}
    Should Be Equal As Numbers    ${get_giamgiaphieutra}    ${result_allocate_gghd}
    Should Be Equal As Numbers    ${get_phitrahang_af_ex}    ${result_phi_th}
    Should Be Equal As Numbers    ${get_tongtien_hoadontra_af_ex}    ${result_cantrakhach}
    Should Be Equal As Numbers    ${get_datrakhach_af_ex}    ${actual_tientrakhach}
    Validate return history by invoice code    ${get_ma_hd}    ${return_code}    ${result_tongtienhangtra}
    Delete return thr API    ${return_code}
