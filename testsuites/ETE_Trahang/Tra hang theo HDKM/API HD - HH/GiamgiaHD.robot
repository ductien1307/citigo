*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    ${headless_browser}
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
&{invoice_1}      KLT0008=20    KLSI0006=4
&{discount_1}     KLT0008=10    KLSI0006=1200000
&{discount_type1}    KLT0008=dis    KLSI0006=changeup
&{product_type1}    KLT0008=pro    KLSI0006=imei
&{return_1}       KLT0008=3    KLSI0006=1

*** Test Cases ***    Product and num list    Product Type        Prouct Discount    Proudct Discount Type    Invoice Discount    Customer    Payment    Promotion Code    Product - num Return    Phi tra hang    Tien tra khach
KM HD_HH_GiamgiaHD    [Tags]                  ETPA
                      [Template]              ethkma1
                      ${invoice_1}            ${product_type1}    ${discount_1}      ${discount_type1}        20                   DHDPT005       1000000         KM012           ${return_1}             10              all

*** Keywords ***
ethkma1
    [Arguments]    ${dict_product_num}    ${dict_product_type}    ${dict_discount}    ${dict_discount_type}    ${input_invoice_discount}    ${input_bh_ma_kh}
    ...    ${input_bh_khachtt}    ${input_khuyemmai}    ${dict_return}    ${input_phi_th}    ${input_tien_tra_khach}
    Log    create hoa don
    ${get_ma_hd}    Add new invoice incase promotion invoice and product - invoice discount    ${dict_product_num}    ${dict_product_type}    ${dict_discount}    ${dict_discount_type}    ${input_invoice_discount}
    ...    ${input_bh_ma_kh}    ${input_bh_khachtt}    ${input_khuyemmai}
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
    Set Test Variable     ${imei_inlist}      ${list_imei_return}
    #
    #create return thr API
    ${return_code}    Add new return to invoice thr API    ${get_ma_hd}    ${input_bh_ma_kh}    ${list_prs}    ${list_nums}    ${result_allocate_gghd}
    ...    ${input_phi_th}    ${actual_tientrakhach}
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
