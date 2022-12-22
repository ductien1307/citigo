*** Settings ***
Suite Setup       Setup Test Suite      Before Test Ban Hang deactivate print warranty
Suite Teardown     After Test
Resource          ../../../core/Ban_Hang/banhang_action.robot
Resource          ../../../core/Tra_hang/tra_hang_action.robot
Resource          ../../../core/Tra_hang/tra_hang_page.robot
Resource          ../../../core/API/api_soquy.robot
Resource          ../../../config/env_product/envi.robot
Resource          ../../../core/Ban_Hang/banhang_page.robot
Resource          ../../../core/Tra_hang/doi_tra_hang_action.robot
Resource          ../../../core/share/toast_message.robot

*** Variables ***
&{list_ma_hh}     TMHH00007=1   TMHH00008=1
@{list_group}     Mỹ phẩm     Dịch vụ
@{list_giavon}      25000.36       58000
@{list_giaban}      35000       68000.85
@{list_unit}      cái     none
@{list_onhand}      30.5    0
@{list_type}    pro    pro

*** Test Cases ***    Product and num list    Nhóm hàng hóa   Giá vốn      Giá bán             ĐVCB            Tồn kho        Product Type        Payment
Thêm hàng hóa và trả hàng nhanh
                      [Tags]      TMBH
                      [Template]              ethhh01
                      [Documentation]     Thêm hàng hóa trên MHBH và trả hàng nhanh
                      ${list_ma_hh}        ${list_group}    ${list_giavon}    ${list_giaban}    ${list_unit}      ${list_onhand}    ${list_type}      0

Thêm hàng imei trên form Trả hàng
                      [Tags]      TMBH
                      [Template]              ethhh02
                      [Documentation]   Thêm hàng hóa imei trên form Trả hàng
                      TMIM00003     Mỹ phẩm       68500.36    98500       none     3       imei


*** Keywords ***
ethhh01
    [Arguments]   ${dict_product_num}     ${list_nhomhang}    ${list_giavon}    ${list_giaban}    ${list_dvcb}   ${list_tonkho}    ${list_product_type}       ${input_khtt}
    ${list_products}   ${list_nums}    Get list from dictionary      ${dict_product_num}
    Delete list product if list product is visible thr API      ${list_products}
    Reload Page
    Sleep    10s
    Select Return without Invoice from BH page
    ${list_ten_hh}    Create list new product in MHBH and return list product name        ${list_products}     ${list_nhomhang}    ${list_giavon}     ${list_giaban}    ${list_dvcb}   ${list_tonkho}    ${list_product_type}
    ${result_tongtienhangtra}      Sum values in list and round    ${list_giaban}
    ${list_result_onhand}     Get list of result onhand af return    ${list_products}   ${list_nums}
    ${actual_khachtt}   Set Variable If    '${input_khtt}' == 'all'   ${result_tongtienhangtra}     ${input_khtt}
    Run Keyword If    "${input_khtt}" == "all"    Click Element JS    ${button_th}   ELSE    Input payment into any form    ${textbox_th_khachttTraHang}    ${actual_khachtt}    ${button_th}
    Return message success validation
    ${return_code}   Get saved code after execute
    #assert value order
    Assert list of onhand after order process    ${return_code}    ${list_products}    ${list_nums}    ${list_result_onhand}
    Assert values by return code until succeed    ${return_code}    ${result_tongtienhangtra}    0    0   ${result_tongtienhangtra}    ${actual_khachtt}
    Assert return summary values until succeed    ${return_code}    0    ${actual_khachtt}    1
    Delete return thr API        ${return_code}
    Delete list product if list product is visible thr API      ${list_products}

ethhh02
    [Arguments]   ${input_mahh}     ${input_nhomhang}     ${input_giavon}    ${input_giaban}    ${input_dvcb}   ${input_tonkho}    ${input_product_type}
    Delete product if product is visible thr API      ${input_mahh}
    Reload Page
    Sleep    5s
    Select Return without Invoice from BH page
    ${ten_hh}    Generate code automatically    MKJF
    Create new product in MHBH       ${input_mahh}   ${ten_hh}    ${input_nhomhang}   ${input_giavon}     ${input_giaban}    ${input_dvcb}   ${input_tonkho}   ${input_product_type}
    Import multi imei for product    ${input_mahh}    ${input_tonkho}
    Wait Until Keyword Succeeds    3x    3x    Assert data in case create product    ${input_mahh}    ${ten_hh}    ${input_nhomhang}   ${input_tonkho}    ${input_giavon}    ${input_giaban}
    Delete product thr API    ${input_mahh}
