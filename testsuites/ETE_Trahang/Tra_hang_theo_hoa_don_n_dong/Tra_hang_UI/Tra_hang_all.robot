*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    ${headless_browser}
Test Teardown     After Test
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

*** Variables ***
&{invoice_1}      KLCB015=7,6.3    KLT0015=1,6    KLQD015=3,1,4    KLDV015=3    KLSI0015=2,3
&{invoice_1_product_line_num}    KLCB015=2    KLT0015=2    KLQD015=3    KLDV015=1    KLSI0015=2
&{discount_1}     KLCB015=15,0    KLT0015=0,4000    KLQD015=5,10000,0    KLDV015=99899.67    KLSI0015=130000,10
&{discount_type1}    KLCB015=dis,none    KLT0015=none,disvnd    KLQD015=dis,disvnd,none    KLDV015=changeup    KLSI0015=changeup,dis
&{product_type1}    KLCB015=com    KLT0015=pro    KLQD015=unit    KLDV015=ser    KLSI0015=imei

*** Test Cases ***    Product and num list    Product Type        Product Line Number              Product Discount    Discount Type        Invoice Discount    Invoice Discount Type    Customer    Payment    Dict sp - sl tra    Phi tra hang    Can tra khach
Tra all               [Tags]                  THND
                      [Template]              ethnd01
                      ${invoice_1}            ${product_type1}    ${invoice_1_product_line_num}    ${discount_1}       ${discount_type1}    50000               null                     CRPKH016    0          20                  50000

*** Keywords ***
ethnd01
    [Arguments]    ${dict_product_num}    ${dict_product_type}    ${dict_product_line_num}    ${dict_discount}    ${dict_discount_type}    ${input_invoice_discount}
    ...    ${input_invoice_discount_type}    ${input_ma_kh}    ${input_bh_khachtt}    ${input_phi_th}    ${input_khtt}
    ${list_products}    Get Dictionary Keys    ${dict_product_num}
    ${list_nums}    Get Dictionary Values    ${dict_product_num}
    ${list_product_type}    Get Dictionary Values    ${dict_product_type}
    ${list_discount_product}    Get Dictionary Values    ${dict_discount}
    ${list_discount_type}    Get Dictionary Values    ${dict_discount_type}
    ${list_product_line_num}    Get Dictionary Values    ${dict_product_line_num}
    ${get_ma_hd}    Add new invoice with multi row product thr API    ${dict_product_num}    ${dict_product_type}    ${dict_product_line_num}    ${dict_discount}    ${dict_discount_type}
    ...    ${input_invoice_discount}    ${input_invoice_discount_type}    ${input_ma_kh}    ${input_bh_khachtt}
    Sleep    2s
    ${get_ma_kh_by_hd_bf_ex}    ${get_tong_tien_hang_bf_ex}    ${get_khach_tt_bf_ex}    ${get_giamgia_hd_bf_ex}    ${get_khachcantra_bf_ex}    ${get_trangthai_bf_ex}    Get invoice info incase discount by invoice code
    ...    ${get_ma_hd}
    ${get_du_no_kh}    Get Du no cuoi KH from API    ${input_ma_kh}
    ${get_ma_kh_by_hd_bf_ex}    ${get_tong_tien_hang_bf_ex}    ${get_khach_tt_bf_ex}    ${get_giamgia_hd_bf_ex}    ${get_khachcantra_bf_ex}    ${get_trangthai_bf_ex}    Get invoice info incase discount by invoice code
    ...    ${get_ma_hd}
    ${get_du_no_kh}    Get Du no cuoi KH from API    ${input_ma_kh}
    ${list_productid}    Get list product id thr API    ${list_products}
    #compute value invoice and customer
    ${list_result_thanhtien}    ${list_result_toncuoi}    ${list_giavon}    Get list total sale - result onhand - cost incase return multi row product    ${list_products}    ${list_product_type}    ${list_nums}
    ...    ${list_discount_product}    ${list_discount_type}
    ${result_gghd}    Run Keyword If    0 < ${input_invoice_discount} < 100    Convert % discount to VND and round    ${get_tong_tien_hang_bf_ex}    ${input_invoice_discount}
    ...    ELSE    Set Variable    ${input_invoice_discount}
    ${result_tongtienhangtra}    Sum values in list    ${list_result_thanhtien}
    ${result_phi_th}    Run Keyword If    0 < ${input_phi_th} < 100    Convert % discount to VND and round    ${result_tongtienhangtra}    ${input_phi_th}
    ...    ELSE    Set Variable    ${input_phi_th}
    ${result_cantrakhach}    Minusx3 and replace foating point    ${result_tongtienhangtra}    ${result_phi_th}    ${result_gghd}
    ${result_khtt}    Set Variable If    "${input_khtt}" == "all"    ${result_cantrakhach}    ${input_khtt}
    ${actual_khtt}    Set Variable If    "${input_khtt}" == "0"    0    ${result_khtt}
    #create return
    Wait Until Keyword Succeeds    3 times    8 s    Before Test Ban Hang deactivate print warranty
    Select Invoice from Ban Hang page    ${get_ma_hd}
    ${lastest_num}    Set Variable    0
    : FOR    ${item_product}    ${item_product_id}    ${item_product_type}    ${item_line}    ${item_list_num}    ${item_list_imei}
    ...    IN ZIP    ${list_products}    ${list_productid}    ${list_product_type}    ${list_product_line_num}    ${list_nums}
    ...    ${list_imei_all}
    \    ${lastest_num}    Run Keyword If    '${item_product_type}' == 'imei'    Input imei for multi row product in Tra hang form    ${item_line}    ${item_product}
    \    ...    ${item_product_id}    ${item_list_imei}    ${item_list_num}    ${lastest_num}
    \    ...    ELSE    Input num for multi row product in Tra hang form    ${item_line}    ${item_product}    ${item_product_id}
    \    ...    ${item_list_num}    ${lastest_num}
    #
    Wait Until Keyword Succeeds    3 times    8 s    Run keyword if    0 < ${input_phi_th} < 100    Input % return free value    ${input_phi_th}
    ...    ${result_phi_th}
    ...    ELSE    Input VND return free value    ${input_phi_th}
    Wait Until Keyword Succeeds    3 times    8 s    Input payment into any form    ${textbox_th_khachttTraHang}    ${actual_khtt}    ${button_th}
    Wait Until Keyword Succeeds    3 times    8 s    Run Keyword If    0 <=${get_khach_tt_bf_ex} < ${result_tongtienhangtra} and ${input_khtt} != 0 and ${get_du_no_kh} > 0    Close return popup
    ...    ELSE    Log    Ignore click
    Sleep    10s
    ${return_code}    Get saved code after execute
    Execute Javascript    location.reload();
    Sleep    15s    wait for response to API
    #assert value product
    ${get_list_cost_af}    ${get_list_onhand_af}    Get list cost - onhand frm API    ${list_products}
    : FOR    ${item_cost_actual}    ${item_onhand_actual}    ${item_cost}    ${item_onhand}    IN ZIP    ${get_list_cost_af}
    ...    ${get_list_onhand_af}    ${list_giavon}    ${list_result_toncuoi}
    \    Should Be Equal As Numbers    ${item_cost_actual}    ${item_cost}
    \    Should Be Equal As Numbers    ${item_onhand_actual}    ${item_onhand}
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
