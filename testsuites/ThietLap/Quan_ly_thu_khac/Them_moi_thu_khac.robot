*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    ${headless_browser}
Test Setup        Before Test Quan ly
Test Teardown     After Test
Resource         ../../../core/Thiet_lap/thiet_lap_nav.robot
Resource         ../../../core/Thiet_lap/thukhac_list_page.robot
Resource         ../../../core/Thiet_lap/thukhac_list_action.robot
Resource         ../../../core/API/api_thietlap.robot
Resource         ../../../core/share/javascript.robot
Resource         ../../../core/share/toast_message.robot


*** Test Cases ***      Mã thu khác      Loại thu     Giá trị       Chi nhánh     Thứ tự hiển thị     Tự động đưa vào hóa đơn     Hoàn trả trả hàng
Create surcharge_GOLIVE            [Tags]       GOLIVE2      TL    SURCHAGRE
                      [Template]    create_thukhac
                      TK00T2           Phí VAT    15         Nhánh A           none              false                      false

Create surcharge            [Tags]         TL    SURCHAGRE
                      [Template]    create_thukhac
                      TK00T1           Phí VAT    200000         true           9                    true                      true

*** Keywords ***
create_thukhac
    [Arguments]    ${input_ma_tk}   ${input_loaithu}   ${input_giatri}    ${input_chinhanh}  ${input_thutu_hienthi}    ${tudong_hoadon}    ${hoantra_trahang}
    Set Selenium Speed    1s
    ${get_id_surcharge}    Get surcharge id frm API    ${input_ma_tk}
    Run Keyword If    '${get_id_surcharge}' == '0'    Log    Ignore     ELSE    Delete surcharge    ${get_id_surcharge}
    Go to any thiet lap    ${button_quanly_thukhac}
    Click Element JS   ${button_themmoi_all_form}
    Sleep    1s
    Input text    ${textbox_surcharge_mathukhac}   ${input_ma_tk}
    Input text     ${textbox_surcharge_loaithu}   ${input_loaithu}
    Run Keyword If   0 < ${input_giatri} < 100   Select value any form    ${icon_giatri_%}     ${textbox_surcharge_giatri}   ${input_giatri}    ELSE       Input text     ${textbox_surcharge_giatri}   ${input_giatri}
    Run Keyword If    '${input_chinhanh}' == 'true'    Log     Ignore click    ELSE      Select branch in add surcharge popup    ${input_chinhanh}
    Run Keyword If    '${input_thutu_hienthi}' == 'none'    Log     Ignore input    ELSE      Input text     ${textbox_surcharge_thutuhienthi}   ${input_thutu_hienthi}
    Run Keyword If    '${tudong_hoadon}' == 'true'    Log     Ignore click    ELSE      Click Element JS    ${checkbox_surcharge_tudong_hoadon}
    Run Keyword If    '${hoantra_trahang}' == 'false'    Log     Ignore click    ELSE      Click Element JS    ${checkbox_surcharge_hoanlai_trahang}
    Click Element JS        ${button_surcharge_save}
    Surcharge create success validation
    Wait Until Keyword Succeeds    3 times    5s    Get surcharge info and validate    ${input_ma_tk}    ${input_loaithu}    ${input_giatri}    ${input_chinhanh}    ${tudong_hoadon}    ${hoantra_trahang}
    ${get_surcharge_id}    Get surcharge id frm API    ${input_ma_tk}
    Delete surcharge    ${get_surcharge_id}
