*** Settings ***
Library           SeleniumLibrary
Library           DateTime
Resource          ../share/constants.robot
Resource          bangtinhluong_list_page.robot
Resource          ../Thiet_lap/thiet_lap_nav.robot
Resource          ../Share/toast_message.robot

*** Keywords ***
Add new pay sheet and input pay period
    [Arguments]       ${input_day}
    ${get_kyhan_bd}     Subtract Time From Date    ${input_day}    3 days     result_format=%d%m%Y
    ${get_kyhan_kt}     Add Time To Date       ${input_day}    3 days     result_format=%d%m%Y
    Wait Until Page Contains Element    ${button_them_bang_luong}   1 min
    Click Element    ${button_them_bang_luong}
    Wait Until Keyword Succeeds    3 times    0.5s    Click Tuy chon tra luong
    Input data      ${textbox_kyhan_bat_dau}      ${get_kyhan_bd}
    Input data      ${textbox__kyhan_ket_thuc}      ${get_kyhan_kt}
    Click Element      ${button_dongy_them_bangluong}
    #Wait Until Page Contains Element    ${textbox_mabangluong}   30s

Click Tuy chon tra luong
    Wait Until Page Contains Element    ${cell_kyhantraluong}     30s
    Click Element    ${cell_kyhantraluong}
    ${xpath_tuychon}    Format String    ${item_kyhan_in_dropdowlist}    Tùy chọn
    Wait Until Page Contains Element    ${xpath_tuychon}    30s
    Click Element    ${xpath_tuychon}

Search pay sheet and click button update
    [Arguments]       ${input_ma_bangluong}
    Input data      ${textbox_tim_theo_ma_bangluong}    ${input_ma_bangluong}
    Wait Until Page Contains Element    ${button_capnhat_bangluong}     30s
    Click Element JS    ${button_capnhat_bangluong}

Input data in popup payment and create payment
    [Arguments]       ${input_maphieu}      ${input_tientra_nv}
    Wait Until Page Contains Element    ${tab_phieuluong}     30s
    Click Element    ${tab_phieuluong}
    Wait Until Page Contains Element    ${button_thanhtoan_luong}     30s
    Click Element    ${button_thanhtoan_luong}
    ${textbox_giatri}     Format String       ${textbox_tientra_nv_theo_phieu}      ${input_maphieu}
    Wait Until Page Contains Element    ${textbox_giatri}     30s
    Run Keyword If    '${input_tientra_nv}'=='all'   Log    Ignore    ELSE    Input Text    ${textbox_giatri}     ${input_tientra_nv}
    Click Element    ${button_tao_phieu_chi}
    Create payment success validation
