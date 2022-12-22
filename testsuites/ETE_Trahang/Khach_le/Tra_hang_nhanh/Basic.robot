*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    ${headless_browser}
Test Teardown     After Test
Resource          ../../../../core/API/api_danhmuc_hanghoa.robot
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
&{list_create_imei}    KLSI0009=2
&{list_product}    KLCB009=5.6    KLDV009=6.5    KLQD009=3    KLT0009=6
@{list_discount}    6000.5    10    12000    150000.6
@{list_discount_type}    dis    dis    change    change

*** Test Cases ***    Mã KH         List products and nums    List IMEI              List GGSP1          GGSP imei                GGTH    Phí trả hàng    Khách thanh toán
Basic                 [Tags]        THKL
                      [Template]    ethkl01
                      CTKH241       ${list_product}           ${list_create_imei}    ${list_discount}    ${list_discount_type}    12      dis             5000                10    all

*** Keywords ***
ethkl01
    [Arguments]    ${input_ma_kh}    ${dict_product_nums}    ${list_imei}    ${list_change}    ${list_change_type}    ${input_change_imei}
    ...    ${input_change_type_imei}    ${input_ggth}    ${input_phi_th}    ${input_khtt}
    Set Selenium Speed    0.5s
    ${get_list_status}    Get list imei status thr API    ${list_imei}
    Create invoice with imei product    ${input_ma_kh}    ${list_imei}    ${get_list_status}
    #get info tra hang
    ${input_imei_product}    Get Dictionary Keys    ${list_imei}
    ${input_imei_nums}    Get Dictionary Values    ${list_imei}
    ${input_product}    ${input_imei_nums}    Convert two list to string and return    ${input_imei_product}    ${input_imei_nums}
    ${list_products}    Get Dictionary Keys    ${dict_product_nums}
    ${list_nums}    Get Dictionary Values    ${dict_product_nums}
    #get data to validate
    ${get_list_baseprice}    Get list of Baseprice by Product Code    ${list_products}
    Wait Until Keyword Succeeds    3 times    8 s    Before Test Ban Hang deactivate print warranty
    Select Return without Invoice from BH page
    ${laster_nums}    Set Variable    0
    : FOR    ${item_product}    ${item_nums}    ${item_change}    ${item_giaban}    ${item_change_type}    IN ZIP
    ...    ${list_products}    ${list_nums}    ${list_change}    ${get_list_baseprice}    ${list_change_type}
    \    ${laster_nums}    Wait Until Keyword Succeeds    3 times    20 s    Input product-num in sale form    ${item_product}
    \    ...    ${item_nums}    ${laster_nums}    ${cell_laster_numbers_return}
    \    ${newprice}    Run Keyword If    0<${item_change}<100 and '${item_change_type}'=='dis'    Price after % discount product    ${item_giaban}    ${item_change}
    \    ...    ELSE IF    ${item_change}>100 and '${item_change_type}'=='dis'    Minus    ${item_giaban}    ${item_change}
    \    ...    ELSE    Log    Ignore newprice
    \    Wait Until Keyword Succeeds    3 times    5 s    Run keyword if    0<${item_change}<100 and '${item_change_type}'=='dis'    Input % discount for multi product
    \    ...    ${item_product}    ${item_change}    ${newprice}
    \    ...    ELSE IF    ${item_change}>100 and '${item_change_type}'=='dis'    Input VND discount for multi product    ${item_product}    ${item_change}
    \    ...    ${newprice}
    \    ...    ELSE    Input newprice for multi product    ${item_product}    ${item_change}
    : FOR    ${item_imei}    IN    @{imei_inlist}
    \    Wait Until Keyword Succeeds    3 times    5 s    Input product and imei incase multi product to any form    ${textbox_bh_search_ma_sp}    ${input_product}
    \    ...    ${item_search_product_indropdow}    ${textbox_nhap_serial}    ${item_serial_in_dropdown}    ${cell_bh_ma_sp}    ${cell_item_input_imei}
    \    ...    @{item_imei}
    ${newprice_imei}    Run Keyword If    '${input_change_type_imei}'=='dis'    Computation price incase discount by product code    ${input_product}    ${input_change_imei}
    ...    ELSE    Set Variable    ${input_change_imei}
    Wait Until Keyword Succeeds    3 times    5 s    Run keyword if    0 < ${input_change_imei} < 100 and '${input_change_type_imei}'=='dis'    Input % discount for multi product    ${input_product}
    ...    ${input_change_imei}    ${newprice_imei}
    ...    ELSE IF    ${input_change_imei} > 100 and '${input_change_type_imei}'=='dis'    Input VND discount for multi product    ${input_product}    ${input_change_imei}    ${newprice_imei}
    ...    ELSE    Input newprice for multi product    ${input_product}    ${input_change_imei}
    Append To List    ${list_products}    ${input_product}
    Append to List    ${list_nums}    ${input_imei_nums}
    Append To List    ${list_change}    ${input_change_imei}
    Append To List    ${list_change_type}    ${input_change_type_imei}
    ${list_result_thanhtien}    ${list_giavon}    ${list_result_toncuoi}    Get list total sale - endingstock - cost incase changing product price    ${list_products}    ${list_nums}    ${list_change}
    ...    ${list_change_type}
    #compute
    ${result_tongtienhangtra}    Sum values in list and round    ${list_result_thanhtien}
    ${result_ggth}    Run Keyword If    0 < ${input_ggth} < 100    Convert % discount to VND and round    ${result_tongtienhangtra}    ${input_ggth}
    ...    ELSE    Set Variable    ${input_ggth}
    ${result_phi_th}    Run Keyword If    0 < ${input_phi_th} < 100    Convert % discount to VND and round    ${result_tongtienhangtra}    ${input_phi_th}
    ...    ELSE    Set Variable    ${input_phi_th}
    ${result_cantrakhach}    Minusx3 and replace foating point    ${result_tongtienhangtra}    ${result_ggth}    ${result_phi_th}
    ${result_khtt}    Set Variable If    "${input_khtt}" == "all"    ${result_cantrakhach}    ${input_khtt}
    ${actual_khtt}    Set Variable If    "${input_khtt}" == "0"    0    ${result_khtt}
    #create return in BH
    Wait Until Keyword Succeeds    3 times    5 s    Run keyword if    0 < ${input_ggth} < 100    Input % discount return    ${input_ggth}
    ...    ${result_ggth}
    ...    ELSE    Input VND discount return    ${input_ggth}
    Wait Until Keyword Succeeds    3 times    5 s    Run keyword if    0 < ${input_phi_th} < 100    Input % return free value    ${input_phi_th}
    ...    ${result_phi_th}
    ...    ELSE    Input VND return free value    ${input_phi_th}
    Wait Until Keyword Succeeds    3 times    5 s    Run Keyword If    "${input_khtt}" == "all"    Click Element JS    ${button_th}
    ...    ELSE    Input payment into any form    ${textbox_th_khachttTraHang}    ${input_khtt}    ${button_th}
    Sleep    1s
    Return message success validation
    ${return_code}    Wait Until Keyword Succeeds    3 times    5 s    Get saved code after execute
    Execute Javascript    location.reload();
    Sleep    20 s    wait for response to API
    #assert value product in invoice
    ${get_list_hh_in_th_af_execute}    Get list product frm Return API    ${return_code}
    ${get_list_hh_in_th_af_execute}    Reverse List one    ${get_list_hh_in_th_af_execute}
    ${list_soluong_in_hd}    ${list_giatriquydoi_in_hd}    Get list quantity and gia tri quy doi with return have multi product    ${get_list_hh_in_th_af_execute}    ${return_code}
    : FOR    ${item_ma_hh}    ${result_toncuoi}    ${item_giavon}    ${get_soluong_in_hd}    ${get_giatri_quydoi}    IN ZIP
    ...    ${get_list_hh_in_th_af_execute}    ${list_result_toncuoi}    ${list_giavon}    ${list_soluong_in_hd}    ${list_giatriquydoi_in_hd}
    \    Run Keyword If    '${get_giatri_quydoi}' == '1'    Validate onhand and cost frm API    ${return_code}    ${item_ma_hh}    ${result_toncuoi}
    \    ...    ${item_giavon}    ${get_soluong_in_hd}
    \    ...    ELSE    Validate onhand and cost frm unit product    ${return_code}    ${item_ma_hh}    ${result_toncuoi}
    \    ...    ${item_giavon}    ${get_soluong_in_hd}    ${get_giatri_quydoi}
    #assert value in return
    ${get_tongtienhangtra_af_ex}    ${get_giamgiaphieutra}    ${get_phitrahang_af_ex}    ${get_cantrakhach_af_ex}    ${get_datrakhach_af_ex}    ${get_tongtien_hoadontra_af_ex}    Get return info incase discount by return code
    ...    ${return_code}
    Should Be Equal As Numbers    ${get_tongtienhangtra_af_ex}    ${result_tongtienhangtra}
    Should Be Equal As Numbers    ${get_giamgiaphieutra}    ${result_ggth}
    Should Be Equal As Numbers    ${get_phitrahang_af_ex}    ${result_phi_th}
    Should Be Equal As Numbers    ${get_datrakhach_af_ex}    ${actual_khtt}
    Should Be Equal As Numbers    ${get_tongtien_hoadontra_af_ex}    ${result_cantrakhach}
    Delete return thr API    ${return_code}
