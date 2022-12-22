*** Settings ***
Suite Setup       Setup Test Suite      Before Test Ban Hang deactivate print warranty
Suite Teardown     After Test
Resource          ../../../core/API/api_danhmuc_hanghoa.robot
Resource          ../../../core/API/api_mhbh.robot
Resource          ../../../core/share/toast_message.robot
Resource          ../../../core/API/api_soquy.robot
Resource          ../../../core/share/javascript.robot
Resource          ../../../core/Tra_hang/tra_hang_action.robot
Resource          ../../../core/API/api_trahang.robot
Resource          ../../../core/Tra_hang/tra_hang_page.robot
Resource          ../../../core/Tra_hang/tra_hang_popup_page.robot
Resource          ../../../core/Ban_Hang/banhang_action.robot
Resource          ../../../core/Ban_Hang/banhang_page.robot

*** Variables ***
&{list_ma_hh_th}     TMHH00007=1   TMHH00008=1
@{list_group_th}     Mỹ phẩm     Dịch vụ
@{list_giavon_th}      25000.22       55300
@{list_giaban_th}      35000       68000.85
@{list_unit_th}      cái     none
@{list_onhand_th}      30.5    0
@{list_type_th}    pro    pro
&{list_ma_hh_dth}     TMHH00009=1   TMHH00010=1
@{list_group_dth}     Mỹ phẩm     Dịch vụ
@{list_giavon_dth}      65000       110000.36
@{list_giaban_dth}      78000.6       95000
@{list_unit_dth}      none     hộp
@{list_onhand_dth}      0    33
@{list_type_dth}    pro    pro

*** Test Cases ***    Product and num list    Nhóm hàng hóa    Giá bán          ĐVCB             Tồn kho        Product Type        Payment
Thêm hàng hóa
                      [Tags]      TMBH
                      [Template]              edtthm01
                      [Documentation]     Thêm hàng hóa trên MHBH và đổi trả hàng
                      ${list_ma_hh_th}        ${list_group_th}    ${list_giavon_th}   ${list_giaban_th}    ${list_unit_th}      ${list_onhand_th}    ${list_type_th}     ${list_ma_hh_dth}        ${list_group_dth}    ${list_giavon_dth}    ${list_giaban_dth}    ${list_unit_dth}      ${list_onhand_dth}    ${list_type_dth}   all

Thêm hàng imei trên form Đổi trả hàng
                      [Tags]      TMBH
                      [Template]              edtthm02
                      [Documentation]   Thêm hàng hóa imei trên form Đổi trả hàng
                      TMIM00004     Mỹ phẩm    68000.32   98500       none     3       imei     TMIM00005     Dịch vụ     58000.36     965420.3       chiếc     3       imei


*** Keywords ***
edtthm01
    [Arguments]   ${dict_product_num_th}     ${list_nhomhang_th}   ${list_giavon_th}   ${list_giaban_th}    ${list_dvcb_th}   ${list_tonkho_th}    ${list_product_type_th}     ${dict_product_num_dth}     ${list_nhomhang_dth}      ${list_giavon_dth}    ${list_giaban_dth}    ${list_dvcb_dth}   ${list_tonkho_dth}    ${list_product_type_dth}      ${input_khtt}
    ${list_products_th}   ${list_nums_th}    Get list from dictionary      ${dict_product_num_th}
    ${list_products_dth}   ${list_nums_dth}    Get list from dictionary      ${dict_product_num_dth}
    Delete list product if list product is visible thr API      ${list_products_th}
    Delete list product if list product is visible thr API      ${list_products_dth}
    Reload Page
    Sleep    10s
    Select Return without Invoice from BH page
    ${list_ten_hh}    Create list new product in MHBH and return list product name         ${list_products_th}     ${list_nhomhang_th}     ${list_giavon_th}     ${list_giaban_th}    ${list_dvcb_th}   ${list_tonkho_th}    ${list_product_type_th}
    ${list_ten_hh_dth}    Create list new product in form Doi tra hang and return list product name       ${list_products_dth}     ${list_nhomhang_dth}     ${list_giavon_dth}    ${list_giaban_dth}    ${list_dvcb_dth}   ${list_tonkho_dth}    ${list_product_type_dth}
    ${result_tongtienhangtra}      Sum values in list and round    ${list_giaban_th}
    ${result_tongtienhangmua}      Sum values in list and round     ${list_giaban_dth}
    ${list_result_onhand_th}     Get list of result onhand af return    ${list_products_th}   ${list_nums_th}
    ${list_result_onhand_dth}     Get list of result onhand incase changing product price    ${list_products_dth}   ${list_nums_dth}
    ${result_khachthanhtoan}    Minus and round    ${result_tongtienhangmua}    ${result_tongtienhangtra}
    ${result_kh_canthanhtoan}    Set Variable If    ${result_tongtienhangmua}<${result_tongtienhangtra}    ${result_tongtienhangmua}    ${result_khachthanhtoan}
    ${result_khtt}    Set Variable If    "${input_khtt}" == "all"    ${result_kh_canthanhtoan}    ${input_khtt}
    ${actual_trahang}    Set Variable If    ${result_tongtienhangmua}<${result_tongtienhangtra}    ${result_khtt}    0
    Run Keyword If    "${input_khtt}" == "all"    Click Element JS    ${button_th}   ELSE    Input payment into any form    ${button_thanhtoan}    ${input_khtt}    ${button_th}
    Run Keyword If    "${input_khtt}" != "all"    Wait Until Keyword Succeeds    3 times    3s    Click Element JS    ${button_luudonkhachle_dongy}
    Return message success validation
    ${return_code}   Get saved code after execute
    #assert value order
    Assert values by return code until succeed    ${return_code}    ${result_tongtienhangtra}    0    0   ${result_tongtienhangtra}    ${actual_trahang}
    Assert return summary values until succeed    ${return_code}    0    ${actual_trahang}    1
    ${get_additional_invoice_code}    Get additional invoice code by return code    ${return_code}
    Assert Invoice until success    ${get_additional_invoice_code}       0     ${result_tongtienhangmua}     ${result_tongtienhangmua}      ${result_khtt}       0       0
    Assert invoice summary values until succeed    ${get_additional_invoice_code}     0     ${result_tongtienhangmua}    0    ${result_kh_canthanhtoan}      ${result_khtt}    Hoàn thành
    Assert list of onhand after order process    ${return_code}    ${list_products_th}    ${list_nums_th}    ${list_result_onhand_th}
    Assert list of onhand after order process    ${get_additional_invoice_code}    ${list_products_dth}    ${list_nums_dth}    ${list_result_onhand_dth}
    Delete invoice by invoice code    ${get_additional_invoice_code}
    Delete list product if list product is visible thr API      ${list_products_th}
    Delete list product if list product is visible thr API      ${list_products_dth}

edtthm02
    [Arguments]   ${input_mahh_th}     ${input_nhomhang_th}      ${input_giavon_th}   ${input_giaban_th}    ${input_dvcb_th}   ${input_tonkho_th}    ${input_product_type_th}      ${input_mahh_dth}     ${input_nhomhang_dth}      ${input_giavon_dth}      ${input_giaban_dth}    ${input_dvcb_dth}   ${input_tonkho_dth}    ${input_product_type_dth}
    ${list_product}   Create List    ${input_mahh_th}     ${input_mahh_dth}
    Delete list product if list product is visible thr API      ${list_product}
    Reload Page
    Sleep    5s
    Select Return without Invoice from BH page
    ${ten_hh_th}    Generate code automatically    MKJF
    ${ten_hh_dth}    Generate code automatically    MKJF
    Create new product in MHBH       ${input_mahh_th}   ${ten_hh_th}    ${input_nhomhang_th}     ${input_giavon_th}   ${input_giaban_th}    ${input_dvcb_th}   ${input_tonkho_th}   ${input_product_type_th}
    Create new product in form Doi tra hang     ${input_mahh_dth}   ${ten_hh_dth}    ${input_nhomhang_dth}      ${input_giavon_dth}     ${input_giaban_dth}    ${input_dvcb_dth}   ${input_tonkho_dth}    ${input_product_type_dth}
    Import multi imei for product    ${input_mahh_th}    ${input_tonkho_th}
    Import multi imei for product    ${input_mahh_dth}    ${input_tonkho_dth}
    Wait Until Keyword Succeeds    3x    3x    Assert data in case create product    ${input_mahh_th}    ${ten_hh_th}    ${input_nhomhang_th}   ${input_tonkho_th}    ${input_giavon_th}    ${input_giaban_th}
    Wait Until Keyword Succeeds    3x    3x    Assert data in case create product    ${input_mahh_dth}    ${ten_hh_dth}    ${input_nhomhang_dth}   ${input_tonkho_dth}    ${input_giavon_dth}   ${input_giaban_dth}
    Delete list product if list product is visible thr API      ${list_product}
