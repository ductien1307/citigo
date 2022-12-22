*** Settings ***
Suite Setup       Setup Test Suite    Before Test Ban Hang
Suite Teardown     After Test
Resource          ../../../../core/API/api_danhmuc_hanghoa.robot
Resource          ../../../../core/API/api_dathang.robot
Resource          ../../../../core/API/api_khachhang.robot
Resource          ../../../../core/API/api_mhbh.robot
Resource          ../../../../core/Dat_Hang/dat_hang_action.robot
Resource          ../../../../core/Dat_Hang/dat_hang_navigation.robot
Resource          ../../../../core/Dat_Hang/dat_hang_page.robot
Resource          ../../../../core/share/toast_message.robot
Resource          ../../../../core/API/api_soquy.robot
Resource          ../../../../core/share/javascript.robot
Resource          ../../../../core/share/imei.robot
Resource          ../../../../core/API/api_mhbh_dathang.robot

*** Variables ***
&{list_ma_hh}     TMHH00003=1   TMHH00004=1
@{list_group}     Mỹ phẩm     Dịch vụ
@{list_giavon}      23000.69      52000
@{list_giaban}      35000       68000.66
@{list_unit}      cái     none
@{list_onhand}      30.5    0
@{list_type}    pro    pro

*** Test Cases ***    Product and num list    Nhóm hàng hóa    Giá bán            ĐVCB            Tồn kho        Product Type        Payment
Thêm hàng hóa và đặt hàng
                      [Tags]      TMBH
                      [Template]              etohh01
                      [Documentation]   Thêm hàng hóa trên MHBH và trả hàng
                      ${list_ma_hh}        ${list_group}    ${list_giavon}    ${list_giaban}    ${list_unit}      ${list_onhand}    ${list_type}      0

Thêm hàng imei trên form Đặt hàng
                      [Tags]      TMBH
                      [Template]              etohh02
                      [Documentation]   Thêm hàng hóa imei trên form Đặt hàng
                      TMIM00002     Mỹ phẩm       59000.52    98500       none     3       imei

*** Keywords ***
etohh01
    [Arguments]   ${dict_product_num}     ${list_nhomhang}      ${list_giavon}      ${list_giaban}    ${list_dvcb}   ${list_tonkho}    ${list_product_type}       ${input_bh_khachtt}
    ${list_products}   ${list_nums}    Get list from dictionary      ${dict_product_num}
    Delete list product if list product is visible thr API      ${list_products}
    Reload Page
    Sleep    10s
    Click Element JS    ${tab_dathang}
    ${list_ten_hh}    Create list new product in MHBH and return list product name       ${list_products}     ${list_nhomhang}     ${list_giavon}   ${list_giaban}    ${list_dvcb}   ${list_tonkho}    ${list_product_type}
    ${result_tongtienhang}       Sum values in list and round    ${list_giaban}
    ${actual_khachtt}   Set Variable If    '${input_bh_khachtt}' == 'all'   ${result_tongtienhang}     ${input_bh_khachtt}
    Run Keyword If    '${input_bh_khachtt}' == '0'    Log      Ingore input    ELSE    Wait Until Keyword Succeeds    3 times    0.5 s    Input payment from customer    ${textbox_dh_khachtt}    ${actual_khachtt}    ${result_tongtienhang}    ${cell_tinhvaocongno_order}
    Click Element JS    ${button_bh_dathang}
    Wait Until Keyword Succeeds    3 times    0.5 s    Click Element JS    ${button_dongy_popup_nocustomer}
    Order message success validation
    ${get_ma_dh}    Get saved code after execute
    #assert value order
    Assert order info after execute    0    1    ${result_tongtienhang}    ${actual_khachtt}   0    ${result_tongtienhang}    0    ${get_ma_dh}
    Assert order summary values until succeed    ${get_ma_dh}    0    ${result_tongtienhang}    ${actual_khachtt}    Phiếu tạm
    Assert list of order summarry after execute    ${list_products}    ${list_nums}
    Assert list of onhand, cost af execute    ${list_products}    ${list_tonkho}    ${list_giavon}
    Delete order frm Order code    ${get_ma_dh}
    Delete list product if list product is visible thr API      ${list_products}

etohh02
    [Arguments]   ${input_mahh}     ${input_nhomhang}     ${input_giavon}    ${input_giaban}    ${input_dvcb}   ${input_tonkho}    ${input_product_type}
    Delete product if product is visible thr API      ${input_mahh}
    Reload Page
    Sleep    5s
    Click Element JS    ${tab_dathang}
    ${ten_hh}    Generate code automatically    MKJF
    Create new product in MHBH       ${input_mahh}   ${ten_hh}    ${input_nhomhang}   ${input_giavon}   ${input_giaban}    ${input_dvcb}   ${input_tonkho}   ${input_product_type}
    Import multi imei for product    ${input_mahh}    ${input_tonkho}
    Wait Until Keyword Succeeds    3x    3x    Assert data in case create product    ${input_mahh}    ${ten_hh}    ${input_nhomhang}   ${input_tonkho}    ${input_giavon}    ${input_giaban}
    Delete product thr API    ${input_mahh}
