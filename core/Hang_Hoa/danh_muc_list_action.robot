*** Settings ***
Library           SeleniumLibrary
Resource          danh_muc_list_page.robot
Resource          ../share/computation.robot
Resource          hang_hoa_add_page.robot
Resource          ../share/popup.robot
Resource          ../share/toast_message.robot
Resource          ../share/javascript.robot
Resource          ../share/constants.robot
Resource          ../share/discount.robot
Resource          ../share/global.robot

*** Keywords ***
Search product ID and go to Thanh phan
    [Arguments]    ${ma_hh_sx}
    Input Text    ${textbox_search_maten}    ${ma_hh_sx}
    Press Key    ${textbox_search_maten}    ${ENTER_KEY}
    Wait Until Element Is Visible    ${tab_thanhphan}
    Click Element    ${tab_thanhphan}
    Wait Until Element Is Visible    ${button_capnhat_in_thanhphantab}
    Click Element    ${button_capnhat_in_thanhphantab}
    Wait Until Element Is Visible    ${tab_thanhphan_in_add_hh_page}
    Click Element    ${tab_thanhphan_in_add_hh_page}

Set Ngung Kinh Doanh all branch
    [Arguments]
    Wait Until Element Is Visible    ${button_ngungkinhdoanh}
    Click Element    ${button_ngungkinhdoanh}
    Wait Until Element Is Visible    ${button_dongy_ngung_kd}
    Click Element    ${button_dongy_ngung_kd}
    Update data success validation

Search product code and delete product
    [Arguments]    ${ma_hh}
    Search product code    ${ma_hh}
    Wait Until Page Contains Element    ${button_xoa_hh}    1 min
    Click Element JS    ${button_xoa_hh}
    Wait Until Page Contains Element    ${button_dongy_xoahh}    1 min
    Click Element JS    ${button_dongy_xoahh}

Search product code and click update product
    [Arguments]    ${ma_hh}
    Search product code    ${ma_hh}
    Wait Until Keyword Succeeds    3 times    2 s    Access update product popup

Access update product popup
   Wait Until Page Contains Element    ${button_capnhat_hh}    1 min
   Click Element JS    ${button_capnhat_hh}
   Wait Until Element Is Visible    ${textbox_ma_hh}

Search product code
    [Arguments]    ${ma_hh}
    Input Text Global    ${textbox_search_maten}    ${ma_hh}
    Press Key    ${textbox_search_maten}    ${ENTER_KEY}
    Wait To Loading Icon Invisible

Set Ngung Kinh Doanh by Branch
    [Arguments]     ${input_branch}
    KV Click Element    ${button_ngungkinhdoanh}
    KV Click Element    ${checkbox_ngungkd_theo_cn}
    KV Click Element   ${button_delete_cn_popup_ngungkd}
    Click Element    ${button_chon_cn_apdung}
    KV Click Element By Code    ${dropdownlist_chinhanh}    ${input_branch}
    Click Element JS    ${button_dongy_ngung_kd}
    Update data success validation

Click button xem ban in
    [Arguments]   ${kho_giay}
    Wait Until Page Contains Element    ${button_in_tem_ma}     30s
    Click Element    ${button_in_tem_ma}
    ${locator_intem}      Format String    ${button_xembanin_theo_kho_giay}   ${kho_giay}
    Wait Until Page Contains Element    ${locator_intem}     30s
    Wait Until Keyword Succeeds   3 times     4s    Click Element    ${locator_intem}

Add new category thr UI
    [Arguments]   ${input_nhomhang}
    Wait Until Page Contains Element    ${button_them_nhomhang}     30s
    Click Element    ${button_them_nhomhang}
    Wait Until Page Contains Element    ${textbox_tennhom}     30s
    Input Text    ${textbox_tennhom}    ${input_nhomhang}
    Click Element    ${button_luu_tennhom}

Go to tab Lien ket kenh ban and click update
    Wait Until Page Contains Element    ${tab_lienket_kenhban}     30s
    Click Element    ${tab_lienket_kenhban}
    Wait Until Page Contains Element    ${button_capnhat_kenhban}     30s
    Wait Until Keyword Succeeds    5x    2s    Click Element    ${button_capnhat_kenhban}

Select channel Tiki
    [Arguments]     ${ten_kenh}
    ${checkbox_kenhban_tiki}      Format String     ${checkbox_kenhban_tiki}    ${ten_kenh}
    Wait Until Page Contains Element    ${checkbox_kenhban_tiki}     30s
    Click Element    ${checkbox_kenhban_tiki}

Select channel Lazada
    [Arguments]     ${ten_kenh}
    ${checkbox_kenhban_lazada}      Format String     ${checkbox_kenhban_lazada}    ${ten_kenh}
    Wait Until Page Contains Element    ${checkbox_kenhban_lazada}     30s
    Click Element    ${checkbox_kenhban_lazada}

Select channel Shopee
    [Arguments]     ${ten_kenh}
    ${checkbox_kenhban_shopee}      Format String     ${checkbox_kenhban_shopee}    ${ten_kenh}
    Wait Until Page Contains Element    ${checkbox_kenhban_shopee}     30s
    Click Element    ${checkbox_kenhban_shopee}

Choose the associated product
    [Arguments]     ${channel_id}     ${ma_sp}      ${sku}
    ${cell_chonhang_lienket}     Format String     ${cell_chonhang_lienket}        ${ma_sp}      ${channel_id}
    ${textbox_chonhang_lienket}     Format String     ${textbox_chonhang_lienket}        ${ma_sp}      ${channel_id}
    Wait Until Page Contains Element    ${cell_chonhang_lienket}     30s
    Click Element    ${cell_chonhang_lienket}
    Input Text        ${textbox_chonhang_lienket}       ${sku}
    Wait Until Page Contains Element    ${item_hang_lienket_in_dropdown}     30s
    Click Element        ${item_hang_lienket_in_dropdown}

Search and select product
    [Arguments]     ${ma_sp}
    Search product code    ${ma_sp}
    ${checkbox_hanghoa}     Format String     ${checkbox_hanghoa}     ${ma_sp}
    Wait Until Page Contains Element    ${checkbox_hanghoa}     20s
    Wait Until Keyword Succeeds    3x    1s    Click Element    ${checkbox_hanghoa}

Select channel Sendo
    [Arguments]     ${ten_kenh}
    ${checkbox_kenhban_sendo}      Format String     ${checkbox_kenhban_sendo}    ${ten_kenh}
    Wait Until Page Contains Element    ${checkbox_kenhban_sendo}     30s
    Click Element    ${checkbox_kenhban_sendo}

Get text UI and validate
    [Arguments]     ${locator}   ${input_text}
    ${get_text_af}    Get Text      ${locator}
    Should Not Be Equal As Strings    ${get_text_af}    ${input_text}
