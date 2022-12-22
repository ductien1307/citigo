*** Settings ***
Library           SeleniumLibrary
Resource          mykiot_list_page.robot
Resource          ../share/discount.robot

*** Keywords ***
Search product in MyKiot
    [Arguments]   ${input_ma_hh}
    Input data    ${textbox_mykiot_nhap_mahang}    ${input_ma_hh}
    ${cell_mykiot_ma_hanghoa}   Format String   ${cell_mykiot_ma_hanghoa}     ${input_ma_hh}
    Wait Until Page Contains Element    ${cell_mykiot_ma_hanghoa}   15s

Go to Hang hoa MyKiot
    KV Click Element    ${button_mykiot_hanghoa}
    Wait until page contains Element    ${textbox_mykiot_nhap_mahang}   15s

Add product to cart and pay
    [Arguments]   ${input_nguoinhan}    ${input_sdt}
    KV Click Element    ${button_mykiot_muangay}
    #KV Click Element    ${checkbox_mykiot_diachi_nhanhang_first}
    Input data    ${textbox_mykiot_ten_nguoinhan}     ${input_nguoinhan}
    Input data    ${textbox_mykiot_sdt}    ${input_sdt}
    Click Element    ${button_mykiot_dathang}
    KV Click Element JS    ${button_mykiot_tieptuc_muahang}

Assert Ton kho, gia ban in MyKiot
    [Arguments]     ${input_ma_hh}    ${input_tonkho}     ${input_giaban}
    ${cell_mykiot_tonkho}   Format String    ${cell_mykiot_tonkho}    ${input_ma_hh}
    ${cell_mykiot_giaban}   Format String    ${cell_mykiot_giaban}    ${input_ma_hh}
    ${get_tonkho}     Get Text    ${cell_mykiot_tonkho}
    ${get_giaban}     Get Text    ${cell_mykiot_giaban}
    ${get_giaban}     Remove String   ${get_giaban}   ,   đ
    Should Be Equal As Numbers    ${get_tonkho}    ${input_tonkho}
    Should Be Equal As Numbers    ${get_giaban}    ${input_giaban}

Wait Loading Icon Mykiot Invisible
    Wait Until Element Is Not Visible    ${icon_loading}   2 minutes
    Sleep    1s
