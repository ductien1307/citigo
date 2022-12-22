*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    ${headless_browser}
Test Setup        Before Test Quan ly
Test Timeout      5 minutes
Test Teardown     After Test
Resource         ../../../core/Thiet_lap/thiet_lap_nav.robot
Resource         ../../../core/Thiet_lap/khuyenmai_list_page.robot
Resource         ../../../core/Thiet_lap/khuyenmai_list_action.robot
Resource         ../../../core/API/api_thietlap.robot
Resource         ../../../core/share/javascript.robot
Resource         ../../../core/share/global.robot
Resource         ../../../core/share/toast_message.robot
Resource         ../../../config/env_product/envi.robot
Library          SeleniumLibrary


*** Test Cases ***       Mã promo   Promo name   Status   Khuyen mai theo   Hinh thuc   Tong tien hang   Promo value
Hoa_don                  [Tags]          TL       PROMO
                         [Template]      create_promotion1
                         PRO001   Khuyến mại hóa đơn   False   Hóa đơn   Giảm giá hóa đơn   100000   15

Hang_hoa                 [Tags]            TL   PROMO   GOLIVE2   CTP
                         [Template]        create_promotion2
                         [Documentation]   MHQL - THÊM MỚI KHUYẾN MẠI THEO HÀNG HÓA
                         PRO002   Khuyến mại hàng hóa   True   Hàng hóa   Mua hàng tặng hàng   3   Đồ ăn vặt   2   KM hàng

Hoa don and hang hoa     [Tags]            TL   PROMO
                         [Template]        create_promotion3
                         PRO003   Khuyến mại hàng hóa   True   Hóa đơn và hàng hóa   Giảm giá hàng   1000000   5   Dịch vụ   30   1   Mỹ phẩm

*** Keywords ***
create_promotion1
    [Arguments]    ${input_ma_promo}   ${input_promo_name}   ${input_status}    ${input_KMtheo}  ${input_hinhthuc}    ${input_tongtienhang}    ${input_promo_value}
    ${get_id_promo}    Get Id promotion    ${input_ma_promo}
    Run Keyword If    '${get_id_promo}' == '0'    Log    Ignore     ELSE    Delete promo    ${get_id_promo}
    Go to any thiet lap    ${button_quanly_khuyenmai}
    Click Element JS   ${button_themmoi_all_form}
    Input Text Global    ${textbox_promotion_code}   ${input_ma_promo}
    Input Text Global     ${textbox_promotion_name}   ${input_promo_name}
    Run Keyword If    '${input_status}' == 'False'     Click Element JS    ${checkbox_promotion_chuaapdung}    ELSE    Log     Ignore click
    Run Keyword If    '${input_KMtheo}' == 'Hóa đơn'    Log     Ignore input    ELSE      Select combobox any form    ${dropdown_khuyenmaitheo}    ${cell_item_dropdown}    ${input_KMtheo}
    Run Keyword If    '${input_KMtheo}' == 'Giảm giá hóa đơn'    Log     Ignore input    ELSE      Select combobox any form    ${dropdown_hinhthuc}    ${cell_item_dropdown}    ${input_hinhthuc}
    Input Text Global    ${textbox_tongtienhang}   ${input_tongtienhang}
    Run Keyword If   0 < ${input_promo_value} < 100   Select value any form    ${button_giamgia_%}     ${textbox_giatriKM}   ${input_promo_value}    ELSE       Input Text Global     ${textbox_giatriKM}   ${input_promo_value}
    Wait Until Element Is Visible    ${button_promotion_save}
    Click Element JS        ${button_promotion_save}
    Promotion create message success validation
    Sleep   5s
    ${get_promo_id}    Get promo info and invoice validate    ${input_ma_promo}   ${input_promo_name}   ${input_status}    ${input_tongtienhang}    ${input_promo_value}
    Delete promo    ${get_promo_id}

create_promotion2
    [Arguments]    ${input_ma_promo}   ${input_promo_name}   ${input_status}    ${input_KMtheo}  ${input_hinhthuc}    ${input_sl_mua}    ${input_nhomhang_mua}
    ...    ${input_sl_giamgia}    ${input_nhomhang_giamgia}
    ${get_id_promo}    Get Id promotion    ${input_ma_promo}
    Run Keyword If    '${get_id_promo}' == '0'    Log    Ignore     ELSE    Delete promo    ${get_id_promo}
    Set Selenium Speed    1s
    Go to any thiet lap    ${button_quanly_khuyenmai}
    Click Element JS   ${button_themmoi_all_form}
    Input Text Global    ${textbox_promotion_code}   ${input_ma_promo}
    Input Text Global     ${textbox_promotion_name}   ${input_promo_name}
    Run Keyword If    '${input_status}' == 'False'     Click Element JS    ${checkbox_promotion_chuaapdung}    ELSE    Log     Ignore click
    Run Keyword If    '${input_KMtheo}' == 'Hoá đơn'    Log     Ignore input    ELSE      Select combobox any form    ${dropdown_khuyenmaitheo}    ${cell_item_dropdown}    ${input_KMtheo}
    Run Keyword If    '${input_hinhthuc}' == 'Mua hàng giảm giá hàng'    Log     Ignore input    ELSE      Select combobox any form    ${dropdown_hinhthuc}    ${cell_item_dropdown}    ${input_hinhthuc}
    Input Text Global    ${textbox_hang_mua}   ${input_sl_mua}
    Select category from Chon nhom hang popup    ${button_menu_mua_hangtang}    ${input_nhomhang_mua}
    Input Text Global    ${textbox_hang_giamgia}   ${input_sl_giamgia}
    Select category from Chon nhom hang popup    ${button_menu_hangtang_gg}    ${input_nhomhang_giamgia}
    Wait Until Element Is Visible    ${button_promotion_save}
    Click Element JS        ${button_promotion_save}
    Promotion create message success validation
    Sleep   5s
    ${get_promo_id}    Get promo info and product validate     ${input_ma_promo}   ${input_promo_name}   ${input_status}    ${input_sl_mua}    ${input_nhomhang_mua}    ${input_sl_giamgia}    ${input_nhomhang_giamgia}
    Delete promo    ${get_promo_id}

create_promotion3
    [Arguments]    ${input_ma_promo}   ${input_promo_name}   ${input_status}    ${input_KMtheo}  ${input_hinhthuc}    ${input_tongtienhang}    ${input_sl_mua}    ${input_nhomhang_mua}
    ...   ${input_giatrikm}    ${input_sl_giamgia}    ${input_nhomhang_giamgia}
    Set Selenium Speed    1s
    ${get_id_promo}    Get Id promotion    ${input_ma_promo}
    Run Keyword If    '${get_id_promo}' == '0'    Log    Ignore     ELSE    Delete promo    ${get_id_promo}
    Go to any thiet lap    ${button_quanly_khuyenmai}
    Click Element JS   ${button_themmoi_all_form}
    Sleep    1s
    Input Text Global    ${textbox_promotion_code}   ${input_ma_promo}
    Input Text Global     ${textbox_promotion_name}   ${input_promo_name}
    Run Keyword If    '${input_status}' == 'False'     Click Element JS    ${checkbox_promotion_chuaapdung}    ELSE    Log     Ignore click
    Run Keyword If    '${input_KMtheo}' == 'Hoá đơn'    Log     Ignore input    ELSE      Select combobox any form    ${dropdown_khuyenmaitheo}    ${cell_item_dropdown}    ${input_KMtheo}
    Run Keyword If    '${input_hinhthuc}' == 'Giảm giá hóa đơn'    Log     Ignore input    ELSE      Select combobox any form    ${dropdown_hinhthuc}    ${cell_item_dropdown}    ${input_hinhthuc}
    Input Text Global    ${textbox_tongtienhang}   ${input_tongtienhang}
    Input Text Global    ${textbox_hang_mua}   ${input_sl_mua}
    Select category from Chon nhom hang popup    ${button_menu_mua_hangtang}    ${input_nhomhang_mua}
    Run Keyword If   0 < ${input_giatrikm} < 100   Select value any form    ${button_giamgia_%}     ${textbox_giatriKM}   ${input_giatrikm}    ELSE       Input Text Global     ${textbox_giatriKM}   ${input_giatrikm}
    Input Text Global    ${textbox_hang_giamgia}   ${input_sl_giamgia}
    Select category from Chon nhom hang popup    ${button_menu_hangtang_gg}    ${input_nhomhang_giamgia}
    Wait Until Element Is Visible    ${button_promotion_save}
    Click Element JS        ${button_promotion_save}
    Promotion create message success validation
    Sleep   5s
    ${get_promo_id}    Get promo info and invoice - product validate     ${input_ma_promo}   ${input_promo_name}   ${input_status}    ${input_sl_mua}    ${input_nhomhang_mua}
    ...    ${input_sl_giamgia}    ${input_nhomhang_giamgia}    ${input_tongtienhang}   ${input_giatrikm}
    Delete promo    ${get_promo_id}
