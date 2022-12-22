*** Settings ***
Suite Setup       Setup Test Suite    Before Test Ban Hang
Suite Teardown    After Test
Resource          ../../core/hang_hoa/hang_hoa_add_action.robot
Resource          ../../core/hang_hoa/hang_hoa_add_page.robot
Resource          ../../core/share/toast_message.robot
Resource          ../../config/env_product/envi.robot
Resource          ../../core/Ban_Hang/banhang_action.robot
Resource          ../../core/Ban_Hang/banhang_page.robot
Resource          ../../core/Dat_Hang/dat_hang_page.robot
Resource          ../../core/Dat_Hang/dat_hang_action.robot
Resource          ../../core/Tra_hang/tra_hang_page.robot
Resource          ../../core/Tra_hang/tra_hang_action.robot
Resource          ../../core/Tra_hang/doi_tra_hang_action.robot
Resource          ../../core/hang_hoa/hang_hoa_add_page.robot
Resource          ../../core/API/api_danhmuc_hanghoa.robot
Resource          ../../core/API/api_mhbh.robot


*** Variables ***
@{list_bantructiEP11}      false   true
@{list_thutu_hangquydoi}   1    2
&{list_product_nums}    HTKM03=2

*** Test Cases ***    Mã HH     Loại giao dịch      List thứ tự hàng quy đổi      Type product
Ban_hang_valid                  [Tags]        EP1
                      [Template]    search_valid
                      [Documentation]   Hàng đvt bán trực tiếp > kiểm tra hiển thị trên MHBH
                      QDBTT19     Hóa đơn         ${list_thutu_hangquydoi}        unit
                      BTT11       Đặt hàng        ${list_thutu_hangquydoi}        pro
                      BTT12       Trả hàng        ${list_thutu_hangquydoi}        unit

Ban_hang_invalid      [Tags]        EP1
                      [Template]    search_invalid
                      [Documentation]   Hàng đvt không bán trực tiếp > kiểm tra hiển thị trên MHBH
                      BTT10         Hóa đơn        pro
                      QDBTT22       Đặt hàng        unit
                      DBTT23        Trả hàng        unit

Doi_tra_hang_valid    [Tags]        EP1
                      [Template]    search_valid_dth
                      [Documentation]   Hàng đvt bán trực tiếp > kiểm tra hiển thị trên form Đổi trả hàng
                      QDBTT19     Đổi trả nhanh               ${list_thutu_hangquydoi}        unit        ${list_product_nums}
                      BTT11       Đổi trả theo hóa đơn        ${list_thutu_hangquydoi}       pro        ${list_product_nums}

Doi_tra_hang_invalid      [Tags]        EP1
                      [Template]    search_invalid_dth
                      [Documentation]   Hàng đvt ko bán trực tiếp > kiểm tra hiển thị trên form Đổi trả hàng
                      QDBTT23           Đổi trả nhanh            pro        ${list_product_nums}
                      QDBTT23        Đổi trả theo hóa đơn        unit       ${list_product_nums}


*** Keywords ***
search_valid
    [Arguments]    ${ma_hh}   ${loại_giaodich}    ${list_thutu}   ${input_type_product}
    ${get_ma_hh_cb}     Run Keyword If    '${input_type_product}' == 'unit'        Get basic product frm unit product    ${ma_hh}   ELSE     Set Variable    ${ma_hh}
    ${list_unit_product}    Get list of unit name have allow sale    ${get_ma_hh_cb}
    Run Keyword If    '${loại_giaodich}' == 'Hóa đơn'    Log    Ignore input    ELSE IF   '${loại_giaodich}' == 'Trả hàng'   Wait Until Keyword Succeeds    3 times    5 s     Select Return without Invoice from BH page
    ...     ELSE   Wait Until Keyword Succeeds    3 times    5 s   Click Element JS    ${tab_dathang}
    ${cell_lastest_nums}    Run Keyword If    '${loại_giaodich}' == 'Hóa đơn'     Set Variable    ${cell_lastest_number}    ELSE IF   '${loại_giaodich}' == 'Trả hàng'     Set Variable    ${cell_laster_numbers_return}
    ...   ELSE    Set Variable    ${cell_tongsoluong_dh}
    ${lastest_num}    Set Variable    0
    ${laster_nums}     Input product-num in sale form    ${ma_hh}    1
    ...     ${lastest_num}    ${cell_lastest_nums}
    Sleep    2s
    ${list_unit_name_in_mhbh}   Create List
    :FOR      ${item_thutu}   IN    @{list_thutu}
    \     ${text_unit}    Format String     ${text_unit_product}    ${item_thutu}
    \     ${unit_name_product}    Get Text     ${text_unit}
    \     Append To List    ${list_unit_name_in_mhbh}     ${unit_name_product}
    ##validate product
    :FOR     ${unit_name_api}     ${unit_name_mhbh}   IN ZIP    ${list_unit_product}    ${list_unit_name_in_mhbh}
    \     Should Be Equal As Strings    ${unit_name_api}     ${unit_name_mhbh}

search_invalid
    [Arguments]    ${ma_hh}   ${loại_giaodich}   ${input_type_product}
    ${get_ma_hh_cb}     Run Keyword If    '${input_type_product}' == 'unit'        Get basic product frm unit product    ${ma_hh}   ELSE     Set Variable    ${ma_hh}
    ${list_unit_product}    Get list of unit name have allow sale    ${get_ma_hh_cb}
    Run Keyword If    '${loại_giaodich}' == 'Hóa đơn'    Log    Ignore input    ELSE IF   '${loại_giaodich}' == 'Trả hàng'   Wait Until Keyword Succeeds    3 times    3s     Select Return without Invoice from BH page
    ...     ELSE   Wait Until Keyword Succeeds    3 times    3s   Click Element JS    ${tab_dathang}
    ${cell_lastest_nums}    Run Keyword If    '${loại_giaodich}' == 'Hóa đơn'     Set Variable    ${cell_lastest_number}    ELSE IF   '${loại_giaodich}' == 'Trả hàng'     Set Variable    ${cell_laster_numbers_return}
    ...   ELSE    Set Variable    ${cell_tongsoluong_dh}
    ${lastest_num}    Set Variable    0
    Wait Until Page Contains Element    ${textbox_bh_search_ma_sp}    1 min
    Input text    ${textbox_bh_search_ma_sp}    ${ma_hh}
    Press Key    ${textbox_bh_search_ma_sp}    ${ENTER_KEY}
    Element Should Contain    ${toast_message}    Không tìm thấy sản phẩm

search_valid_dth
    [Arguments]    ${ma_hh}   ${loại_giaodich}    ${list_thutu}   ${input_type_product}   ${dict_product_nums}
    ${invoice_code}   Run Keyword If    '${loại_giaodich}' == 'Đổi trả nhanh'    Log    Ignore input     ELSE     Add invoice without customer no payment thr API   ${dict_product_nums}
    ${list_product}    Get Dictionary Keys    ${dict_product_nums}
    ${list_nums}    Get Dictionary Values    ${dict_product_nums}
    ${get_ma_hh_cb}     Run Keyword If    '${input_type_product}' == 'unit'        Get basic product frm unit product    ${ma_hh}   ELSE     Set Variable    ${ma_hh}
    ${list_unit_product}    Get list of unit name have allow sale    ${get_ma_hh_cb}
    ##input product in BH form
    Run Keyword If    '${loại_giaodich}' == 'Đổi trả nhanh'    Select Return without Invoice from BH page
    ...     ELSE   Select Invoice from Ban Hang page    ${invoice_code}
    ${lastest_number}    Set Variable    0
    : FOR    ${item_hh}    ${item_soluong}    IN ZIP    ${list_product}    ${list_nums}
    \    ${lastest_number}    Run Keyword If    '${loại_giaodich}' == 'Đổi trả nhanh'     Input product-num in sale form    ${item_hh}    ${item_soluong}
    \    ...    ${lastest_number}    ${cell_laster_numbers_return}   ELSE        Wait Until Keyword Succeeds    3 times    3s  Input nums for multi product    ${item_hh}    ${item_soluong}
    \    ...    ${lastest_number}    ${cell_laster_numbers_return}
    ${lastest_number1}    Set Variable    0
    ${lastest_number1}    Input product and nums into Doi tra hang form    ${ma_hh}    1
    ...    ${lastest_number1}
    Sleep    2s
    ${count}    Get Matching Xpath Count     ${text_unit_product_dth}
    ${list_unit_name_in_mhbh}   Create List
    :FOR      ${item_thutu}   IN RANGE    1     ${count} + 1
    \     ${unit_name_product}    Get Text     xpath=(${text_unit})[${item_thutu}]
    \     Append To List    ${list_unit_name_in_mhbh}     ${unit_name_product}
    ##validate product
    :FOR     ${unit_name_api}     ${unit_name_mhbh}   IN ZIP    ${list_unit_product}    ${list_unit_name_in_mhbh}
    \     Should Be Equal As Strings    ${unit_name_api}     ${unit_name_mhbh}

search_invalid_dth
    [Arguments]    ${ma_hh}   ${loại_giaodich}   ${input_type_product}   ${dict_product_nums}
    ${invoice_code}   Run Keyword If    '${loại_giaodich}' == 'Đổi trả nhanh'    Log    Ignore input     ELSE     Add invoice without customer no payment thr API   ${dict_product_nums}
    ${list_product}    Get Dictionary Keys    ${dict_product_nums}
    ${list_nums}    Get Dictionary Values    ${dict_product_nums}
    ${get_ma_hh_cb}     Run Keyword If    '${input_type_product}' == 'unit'        Get basic product frm unit product    ${ma_hh}   ELSE     Set Variable    ${ma_hh}
    ${list_unit_product}    Get list of unit name have allow sale    ${get_ma_hh_cb}
    ##input product in BH form
    Run Keyword If    '${loại_giaodich}' == 'Đổi trả nhanh'    Wait Until Keyword Succeeds    3 times    3s     Select Return without Invoice from BH page
    ...     ELSE   Wait Until Keyword Succeeds    3 times    3s   Select Invoice from Ban Hang page    ${invoice_code}
    ${lastest_number}    Set Variable    0
    : FOR    ${item_hh}    ${item_soluong}    IN ZIP    ${list_product}    ${list_nums}
    \    ${lastest_number}    Run Keyword If    '${loại_giaodich}' == 'Đổi trả nhanh'    Input product-num in sale form    ${item_hh}    ${item_soluong}
    \    ...    ${lastest_number}    ${cell_laster_numbers_return}   ELSE    Wait Until Keyword Succeeds    3 times    3s  Input nums for multi product    ${item_hh}    ${item_soluong}
    \    ...    ${lastest_number}    ${cell_laster_numbers_return}
    ${lastest_number1}    Set Variable    0
    Wait Until Page Contains Element    ${textbox_th_search_hangdoi}    1 min
    Input text    ${textbox_th_search_hangdoi}    ${ma_hh}
    Press Key    ${textbox_th_search_hangdoi}    ${ENTER_KEY}
    Press Key    ${textbox_th_search_hangdoi}    ${ENTER_KEY}
    Element Should Contain    ${toast_message}    Không tìm thấy sản phẩm
