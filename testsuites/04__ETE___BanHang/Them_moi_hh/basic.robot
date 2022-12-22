*** Settings ***
Suite Setup       Setup Test Suite    Before Test Ban Hang
Suite Teardown     After Test
Resource          ../../../core/Ban_Hang/banhang_action.robot
Resource          ../../../core/Ban_Hang/banhang_getandcompute.robot
Resource          ../../../core/share/toast_message.robot
Resource          ../../../core/share/imei.robot
Resource          ../../../core/Ban_Hang/banhang_navigation.robot
Resource          ../../../core/API/api_danhmuc_hanghoa.robot
Resource          ../../../core/API/api_hanghoa.robot
Resource          ../../../core/API/api_khachhang.robot
Resource          ../../../core/API/api_hoadon_banhang.robot
Resource          ../../../core/API/api_soquy.robot
Resource          ../../../core/So_Quy/so_quy_list_action.robot
Resource          ../../../config/env_product/envi.robot
Resource          ../../../core/share/list_dictionary.robot

*** Variables ***
&{list_ma_hh}     TMHH00001=1   TMHH00002=1
@{list_group}     Mỹ phẩm     Dịch vụ
@{list_giavon}      22500     58900.36
@{list_giaban}      35000.24       68000
@{list_unit}      cái     none
@{list_onhand}      30.5    0
@{list_type}    pro    pro

*** Test Cases ***    Product and num list    Nhóm hàng hóa     Giá bán           ĐVCB            Tồn kho        Product Type        Payment
Thêm hàng hóa MHBH và bán hang
                      [Tags]      TMBH
                      [Template]              ethh01
                      [Documentation]   Thêm hàng hóa trên MHBH và bán hàng
                      ${list_ma_hh}        ${list_group}   ${list_giavon}    ${list_giaban}    ${list_unit}      ${list_onhand}    ${list_type}      all

Thêm hàng imei trên MHBH
                      [Tags]      TMBH    
                      [Template]              ethh02
                      [Documentation]   Thêm hàng hóa imei trên MHBH
                      TMIM00001     Mỹ phẩm      56000.96       99500.6       none     5       imei


*** Keywords ***
ethh01
    [Arguments]   ${dict_product_num}     ${list_nhomhang}   ${list_giavon}    ${list_giaban}    ${list_dvcb}   ${list_tonkho}    ${list_product_type}       ${input_bh_khachtt}
    ${list_products}   ${list_nums}    Get list from dictionary      ${dict_product_num}
    Delete list product if list product is visible thr API      ${list_products}
    Reload Page
    Sleep    10s
    ${list_ten_hh}    Create list new product in MHBH and return list product name         ${list_products}     ${list_nhomhang}    ${list_giavon}    ${list_giaban}    ${list_dvcb}   ${list_tonkho}    ${list_product_type}
    ${result_tongtienhang}      Sum values in list and round    ${list_giaban}
    ${actual_khachtt}   Set Variable If    '${input_bh_khachtt}' == 'all'   ${result_tongtienhang}     ${input_bh_khachtt}
    ${list_result_onhand}     Get list of result onhand incase changing product price    ${list_products}   ${list_nums}
    Run Keyword If    '${input_bh_khachtt}' != 'all'    Wait Until Keyword Succeeds    3 times    0.5s    Input payment    ${actual_khachtt}    ${result_tongtienhang}
    Run Keyword If    '${input_bh_khachtt}' == 'all'    Click Element JS    ${button_bh_thanhtoan}       ELSE     Click Save Invoice incase having confimation popup
    Invoice message success validation
    ${invoice_code}    Get saved code after execute
    Assert Invoice until success    ${invoice_code}       0     ${result_tongtienhang}     ${result_tongtienhang}      ${actual_khachtt}       0       0
    Assert invoice summary values until succeed    ${invoice_code}     0     ${result_tongtienhang}    0    ${result_tongtienhang}      ${actual_khachtt}    Hoàn thành
    Assert list of onhand, cost af execute    ${list_products}    ${list_result_onhand}    ${list_giavon}
    Delete invoice by invoice code    ${invoice_code}
    Delete list product if list product is visible thr API      ${list_products}

ethh02
    [Arguments]   ${input_mahh}     ${input_nhomhang}   ${input_giavon}     ${input_giaban}    ${input_dvcb}   ${input_tonkho}    ${input_product_type}
    Delete product if product is visible thr API      ${input_mahh}
    Reload Page
    Sleep    5s
    ${ten_hh}    Generate code automatically    MKJF
    Create new product in MHBH       ${input_mahh}   ${ten_hh}    ${input_nhomhang}   ${input_giavon}   ${input_giaban}    ${input_dvcb}   ${input_tonkho}   ${input_product_type}
    Import multi imei for product    ${input_mahh}    ${input_tonkho}
    Wait Until Keyword Succeeds    3x    3x    Assert data in case create product    ${input_mahh}    ${ten_hh}    ${input_nhomhang}   ${input_tonkho}    ${input_giavon}    ${input_giaban}
    Delete product thr API    ${input_mahh}
