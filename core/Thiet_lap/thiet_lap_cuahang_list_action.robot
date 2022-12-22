*** Settings ***
Library           SeleniumLibrary
Resource          nguoidung_list_page.robot
Resource          ../share/constants.robot
Resource          ../share/global.robot
Resource          ../share/javascript.robot
Resource          thiet_lap_cuahang_list_page.robot

*** Keywords ***
Go to Thiet lap SMS - Email
    Wait Until Page Contains Element    ${domain_doitac}    30s
    Click Element    ${domain_doitac}
    Wait Until Page Contains Element    ${button_sms_email_chi_tiet}    30s
    Click Element    ${button_sms_email_chi_tiet}

Go to tab Tin nhan Zalo
    Go to Thiet lap SMS - Email
    Wait Until Page Contains Element    ${tab_tin_nhan_zalo}    30s
    Click Element    ${tab_tin_nhan_zalo}

Input data in popup ZOA offcial
    [Arguments]    ${zalo_acc}    ${zalo_pass}
    Wait Until Page Contains Element    ${textbox_sdt_zalo}    30s
    Input Text    ${textbox_sdt_zalo}    ${zalo_acc}
    Input Text    ${textbox_mk_zalo}    ${zalo_pass}
    Click Element    ${button_dangnhap_voi_mk}
    Wait Until Page Contains Element    ${checkbox_dong_y_ql_ZOA}    1 min
    Click Element    ${checkbox_dong_y_ql_ZOA}
    Click Element    ${button_cho_phep}

Go to Tiki integration
    Go to any thiet lap    ${button_thieplap_cuahang}
    Wait Until Page Contains Element    ${button_tiki}    30s
    Click Element    ${button_tiki}

Open popup Lien ket hang hoa Tiki
    Wait Until Page Contains Element    ${button_mo_popup_lienket_hh_tiki}    30s
    Wait Until Keyword Succeeds    5x    1s     Click Element    ${button_mo_popup_lienket_hh_tiki}

Mapping product with Tiki
    [Arguments]     ${input_ma_hh}    ${input_ma_hh_tiki}
    Wait Until Page Contains Element    ${textbox_timtheo_mahh_tiki}    30s
    Input data      ${textbox_timtheo_mahh_tiki}    ${input_ma_hh_tiki}
    Sleep    2s
    Wait Until Page Contains Element    ${button_chonhang_lienket}    30s
    Wait Until Keyword Succeeds    3 times    2s   Click Element    ${button_chonhang_lienket}
    Input data      ${textbox_chonhang_lienket_kv}      ${input_ma_hh}

Delete mapping product with Tiki
    [Arguments]       ${input_ma_hh_tiki}
    Wait Until Page Contains Element    ${textbox_timtheo_mahh_tiki}    30s
    Input data      ${textbox_timtheo_mahh_tiki}    ${input_ma_hh_tiki}
    Sleep    1s
    Wait Until Page Contains Element    ${button_huy_lienket_hh_tiki}    30s
    Wait Until Keyword Succeeds    3 times    2s    Click Element    ${button_huy_lienket_hh_tiki}

Go to Shopee integration
    Go to any thiet lap    ${button_thieplap_cuahang}
    Wait Until Page Contains Element    ${button_shopee}    30s
    Click Element    ${button_shopee}

Open popup Lien ket hang hoa Shopee
    Wait Until Page Contains Element    ${button_mo_popup_lienket_hh_shopee}    30s
    Wait Until Keyword Succeeds    5x    1s    Click Element    ${button_mo_popup_lienket_hh_shopee}

Mapping product with Shopee
    [Arguments]     ${input_ma_hh}    ${input_ma_hh_shopee}
    Wait Until Page Contains Element    ${textbox_timtheo_mahh_shopee_lzd}    30s
    Input data      ${textbox_timtheo_mahh_shopee_lzd}    ${input_ma_hh_shopee}
    Sleep    2s
    Wait Until Page Contains Element    ${button_chonhang_lienket}    30s
    Wait Until Keyword Succeeds    3 times    2s   Click Element    ${button_chonhang_lienket}
    Input data      ${textbox_chonhang_lienket_kv}      ${input_ma_hh}

Delete mapping product with Shopee or Lazada
    [Arguments]       ${input_ma_hh_shopee}
    Wait Until Page Contains Element    ${textbox_timtheo_mahh_shopee_lzd}    30s
    Click Element    ${textbox_timtheo_mahh_shopee_lzd}
    Wait Until Page Contains Element    ${textbox_timtheo_mahh_shopee_lzd}    30s
    Input data      ${textbox_timtheo_mahh_shopee_lzd}    ${input_ma_hh_shopee}
    Sleep    1s
    Wait Until Page Contains Element    ${button_huy_lienket_hh_tiki}    30s
    Wait Until Keyword Succeeds    3 times    2s    Click Element    ${button_huy_lienket_hh_tiki}

Go to Lazada integration
    Go to any thiet lap    ${button_thieplap_cuahang}
    Wait Until Page Contains Element    ${button_lazada}    30s
    Click Element    ${button_lazada}
    #Wait Until Page Contains Element    ${button_ok_thongbao_lazada}      15s

Open popup Lien ket hang hoa Lazada
    [Arguments]     ${shop_lazada}
    #Wait Until Keyword Succeeds    5x    1s     Click Element    ${button_ok_thongbao_lazada}
    ${button_mo_popup_lienket_hh_lazada}      Format String    ${button_mo_popup_lienket_hh_lazada}     ${shop_lazada}
    Wait Until Page Contains Element    ${button_mo_popup_lienket_hh_lazada}    30s
    Wait Until Keyword Succeeds    5x    1s     Click Element    ${button_mo_popup_lienket_hh_lazada}

Go to Sendo integration
    Go to any thiet lap    ${button_thieplap_cuahang}
    Wait Until Page Contains Element    ${button_sendo}    30s
    Wait Until Keyword Succeeds    5x    1s     Click Element    ${button_sendo}

Open popup Lien ket hang hoa Sendo
    Wait Until Page Contains Element    ${button_mo_popup_lienket_hh_sendo}    30s
    Wait Until Keyword Succeeds    5x    1s     Click Element    ${button_mo_popup_lienket_hh_sendo}

Go to Web ban hang
    Wait Until Keyword Succeeds    3x    3s    Go to any thiet lap    ${button_thieplap_cuahang}
    Wait To Loading Icon Invisible
    Click Element Global    ${button_web_banhang}
    Wait Until Element Is Visible    ${iframe_webbanhang}
    Select Frame    ${iframe_webbanhang}
    Click Element JS     ${button_vaotrang_quantri}
