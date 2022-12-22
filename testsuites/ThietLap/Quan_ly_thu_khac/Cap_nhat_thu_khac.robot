*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    ${headless_browser}
Test Setup        Before Test Quan ly
Test Teardown     After Test
Resource         ../../../core/Thiet_lap/thiet_lap_nav.robot
Resource         ../../../core/Thiet_lap/thukhac_list_page.robot
Resource         ../../../core/Thiet_lap/thukhac_list_action.robot
Resource         ../../../core/Thiet_lap/khuyenmai_list_page.robot
Resource         ../../../core/API/api_thietlap.robot
Resource         ../../../core/share/javascript.robot
Resource         ../../../core/share/toast_message.robot
Resource         ../../../prepare/Hang_hoa/Sources/thietlap.robot


*** Test Cases ***      Mã thu khác      Loại thu     Giá trị       Thứ tự hiển thị     Tự động đưa vào hóa đơn     Hoàn trả trả hàng      Tự động hóa đơn new     Giá trị new    Chi nhánh
Update surcharge            [Tags]      TL    SURCHAGRE1
                      [Template]    update_thukhac
                      TK00B1           Phí new           20            9                        false                      true             true                  20000            true

Del surcharge         [Tags]      TL    SURCHAGRE
                      [Template]    del_thukhac
                      TK00B2           Phí new           20000            9                        true                  false

*** Keywords ***
update_thukhac
    [Arguments]    ${input_ma_tk}   ${input_loaithu}   ${input_giatri}      ${input_thutu_hienthi}    ${tudong_hoadon}    ${hoantra_trahang}
    ...     ${input_tudong_hd_new}    ${input_giatri_new}    ${surcharge_chinhanh}
    ${get_id_surcharge}    Get surcharge id frm API    ${input_ma_tk}
    Run Keyword If    '${get_id_surcharge}' == '0'    Log    Ignore     ELSE    Delete Surcharge    ${get_id_surcharge}
    Create new Surcharge by percentage    ${input_ma_tk}   ${input_loaithu}    ${input_giatri}    ${input_thutu_hienthi}    ${tudong_hoadon}
    ...    ${hoantra_trahang}
    Set Selenium Speed    1s
    Go to any thiet lap    ${button_quanly_thukhac}
    Go to update surcharge form    ${input_ma_tk}
    Run Keyword If   0 < ${input_giatri_new} < 100   Select value any form    ${icon_giatri_%}     ${textbox_surcharge_giatri}   ${input_giatri_new}
    ...    ELSE     Select value any form    ${icon_giatri_vnd}     ${textbox_surcharge_giatri}   ${input_giatri_new}
    Run Keyword If    '${tudong_hoadon}' == 'true'    Log     Ignore click    ELSE      Click Element JS    ${checkbox_surcharge_tudong_hoadon}
    Wait Until Element Is Visible    ${textbox_search_surcharge}    2 mins
    Click Element JS        ${button_surcharge_save}
    Sleep    2s
    Wait Until Element Is Visible    ${button_active_surcharge}    2 mins
    Click Element JS        ${button_active_surcharge}
    Wait Until Element Is Visible    ${button_save_change_surcharge}    2 mins
    Click Element JS        ${button_save_change_surcharge}
    Wait Until Keyword Succeeds    5 times    5s    Get surcharge info and validate    ${input_ma_tk}    ${input_loaithu}    ${input_giatri_new}    ${surcharge_chinhanh}
    ...    ${input_tudong_hd_new}    ${hoantra_trahang}
    ${get_id_surcharge}    Get surcharge id frm API    ${input_ma_tk}
    Delete surcharge    ${get_id_surcharge}

del_thukhac
    [Arguments]    ${input_ma_tk}   ${input_loaithu}   ${input_giatri}  ${input_thutu_hienthi}    ${tudong_hoadon}    ${hoantra_trahang}
    ${get_id_surcharge}    Get surcharge id frm API    ${input_ma_tk}
    Run Keyword If    '${get_id_surcharge}' == '0'    Log    Ignore     ELSE    Delete surcharge    ${get_id_surcharge}
    Create new Surcharge by percentage    ${input_ma_tk}   ${input_loaithu}    ${input_giatri}    ${input_thutu_hienthi}    ${tudong_hoadon}
    ...    ${hoantra_trahang}
    Set Selenium Speed    1s
    Go to any thiet lap    ${button_quanly_thukhac}
    Wait Until Element Is Visible    ${textbox_search_surcharge}
    Input data    ${textbox_search_surcharge}    ${input_ma_tk}
    Wait Until Element Is Visible    ${checkbox_filter_luachonhienthi_tatca}
    Click Element JS    ${checkbox_filter_luachonhienthi_tatca}
    Sleep    1s
    Wait Until Element Is Visible    ${button_delete_surcharge}
    Click Element JS    ${button_delete_surcharge}
    Wait Until Element Is Visible    ${button_dongy_del_promo}
    Click Element JS    ${button_dongy_del_promo}
    Delete data success validation
