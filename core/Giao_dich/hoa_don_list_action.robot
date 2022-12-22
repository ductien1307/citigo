*** Settings ***
Library           SeleniumLibrary
Library           StringFormat
Resource          hoa_don_list_page.robot
Resource          ../share/javascript.robot
Resource          ../API/api_danhmuc_hanghoa.robot
Resource          ../API/api_hoadon_banhang.robot

*** Keywords ***
Get the first hoa don info
    ${get_ma_hd}    Get Text    ${cell_first_ma_hd}
    Click Element    ${cell_first_ma_hd}
    ${cell_product_01}    Format String    ${cell_ma_sp_hd}    1
    ${get_ma_sp_tra}    Get Text    ${cell_product_01}
    ${get_khachhang_ten}    Get Text    ${cell_khachhang_name}
    Return From Keyword    ${get_ma_hd}    ${get_ma_sp_tra}    ${get_khachhang_ten}

Search invoice code
    [Arguments]     ${ma_hd}
    Wait Until Page Contains Element    ${textbox_theo_ma_hd}       1 min
    Input data    ${textbox_theo_ma_hd}    ${ma_hd}

Search invoice code and click copy
    [Arguments]     ${ma_hd}
    Search invoice code    ${ma_hd}
    ${get_id_hd}    Get invoice id    ${ma_hd}
    Wait Until Page Contains Element    ${button_hd_sao_chep}     1 min
    Click Element    ${button_hd_sao_chep}
    ${url_bh}       Set Variable        ${URL}/sale/#/?invoice=${get_id_hd}
    Wait Until Keyword Succeeds    3 times    2s    Select Window   url=${url_bh}

Select sale channel
    [Arguments]    ${kenh_bh}
    Wait Until Page Contains Element    ${button_hd_kenhban}      1 min
    Click Element JS    ${button_hd_kenhban}
    Wait Until Page Contains Element    ${textbox_hd_kenhban}   15s
    Input Text    ${textbox_hd_kenhban}    ${kenh_bh}
    ${xp_kenhban}   Format String    ${item_hd_kenhban_in_dropdown}    ${kenh_bh}
    Wait Until Page Contains Element   ${xp_kenhban}     15s
    Click Element    ${xp_kenhban}

Select nguoi ban in MHBH
    [Arguments]       ${ten_nguoiban}
    Wait Until Page Contains Element    ${cell_nguoiban}      1 mins
    Wait Until Keyword Succeeds    3x    5s    Click Element JS    ${cell_nguoiban}
    Wait Until Page Contains Element    ${textbox_nguoiban}   20s
    Input Text    ${textbox_nguoiban}    ${ten_nguoiban}
    ${xp_nguoiban}      Format String    ${item_nguoiban_in_dropdownlist}    ${ten_nguoiban}
    Wait Until Page Contains Element    ${xp_nguoiban}
    Click Element JS    ${xp_nguoiban}

Search invoice code and select invoice
    [Arguments]       ${ma_hd}
    Search invoice code    ${ma_hd}
    Wait Until Page Contains Element    ${checkbox_hoa_don}    50s
    Wait Until Keyword Succeeds    5 times    2s    Click Element    ${checkbox_hoa_don}

Combine invoice
    Click Element     ${button_gop_hoa_don}
    Wait Until Page Contains Element    ${button_dongy_gop_hd}     30s
    Click Element     ${button_dongy_gop_hd}
    Wait Until Page Contains Element    ${button_gop_don}     30s
    Click Element     ${button_gop_don}
    Wait Until Page Contains Element    ${button_dongy_tieptuc_gop_hd}     30s
    Click Element     ${button_dongy_tieptuc_gop_hd}

Access popup Gop hoa don
    [Arguments]   ${input_ma_kh}
    Reload Page
    Wait Until Page Contains Element    ${button_gop_hoa_don}       50s
    Click Element     ${button_gop_hoa_don}
    ${button_gop_don_theo_kh}    Format String    ${button_gop_don_theo_kh}    ${input_ma_kh}
    Wait Until Page Contains Element    ${button_gop_don_theo_kh}     50s

Combine invoice and select invoice
    [Arguments]   ${input_ma_kh}    ${invoice_code}     ${invoice_code_1}
    Wait Until Keyword Succeeds    3x    1s    Access popup Gop hoa don    ${input_ma_kh}
    ${chk_invoice}    Format String    ${checkbox_hoa_don_gop}    ${invoice_code}
    ${chk_invoice_1}    Format String    ${checkbox_hoa_don_gop}    ${invoice_code_1}
    ${button_gop_don_theo_kh}    Format String    ${button_gop_don_theo_kh}    ${input_ma_kh}
    Click Element    ${chk_invoice}
    Click Element    ${chk_invoice_1}
    Click Element    ${button_gop_don_theo_kh}
    Wait Until Page Contains Element    //a[contains(text(),'Đồng ý')]     30s
    Click Element      //a[contains(text(),'Đồng ý')]
    Wait Until Page Contains Element    //div[@class='kv-group-btn']//a[@class='btn btn-success ng-binding'][contains(text(),'Gộp đơn')]     30s
    Click Element      //div[@class='kv-group-btn']//a[@class='btn btn-success ng-binding'][contains(text(),'Gộp đơn')]
    Wait Until Page Contains Element    ${button_dongy_tieptuc_gop_hd}     30s
    Click Element     ${button_dongy_tieptuc_gop_hd}

Update delivery status by invoice code
    [Arguments]     ${input_ma_hd}    ${input_trangthaigiao}
    Search invoice code    ${input_ma_hd}
    Wait Until Page Contains Element    ${cell_trangthaigiao}     40s
    Click Element    ${cell_trangthaigiao}
    Wait Until Page Contains Element    ${textbox_trangthaigiao}     10s
    Input Text    ${textbox_trangthaigiao}    ${input_trangthaigiao}
    ${item_trangthaigiao}   Format String    ${item_trangthaigiao}    ${input_trangthaigiao}
    Wait Until Page Contains Element    ${item_trangthaigiao}     10s
    Click Element    ${item_trangthaigiao}
    Click Element    ${button_hd_luu}
    Wait Until Page Contains Element    ${toast_message}      50s
    Element Should Contain    ${toast_message}    Hóa đơn ${input_ma_hd} được cập nhật thành công

Access button save combine invoice
    Wait Until Keyword Succeeds    3x    1s   Click Element        ${button_luu_tao_vandon_khac}
    Wait Until Page Contains Element    ${button_close_luu_y}     20s

Search invoice by customer info
    [Arguments]     ${input_text}
    Wait Until Element Is Visible    ${button_dropdown_search}    30s
    Click Element    ${button_dropdown_search}
    ${count}    Set Variable    0
    ${count}    Get Matching Xpath Count    ${button_morong_timkiem}
    Run Keyword If    ${count}== 1    Run Keywords    Wait Until Page Contains Element    ${button_morong_timkiem}    30s    AND    Click Element JS    ${button_morong_timkiem}    ELSE    Log    ignore
    Wait Until Element Is Visible    ${textbox_tim_kiem_ma_ten_sdt_kh}    30s
    Clear Element Text    ${textbox_tim_kiem_ma_ten_sdt_kh}
    Input Text    ${textbox_tim_kiem_ma_ten_sdt_kh}    ${input_text}
    Click Element    ${button_search}

Validate invoice by customer infor
    [Arguments]    ${invoice_code}    ${cus_code}    ${cus_name}
    ${str_ma_phieu}     Format String    ${text_ma_hoa_don}    ${invoice_code}
    ${str_khach_hang}     Format String    ${khach_hang}    ${cus_code}    ${cus_name}
    Wait Until Element Is Visible    ${str_ma_phieu}
    Wait Until Element Is Visible    ${str_khach_hang}
    Wait Until Element Is Visible    ${button_hd_mo_phieu}

Open popup Sync Tiki, Lazada, Shopee and search invoice code
    [Arguments]   ${invoice_code}
    Wait Until Page Contains Element    ${button_omni_dongbo}     30s
    Click Element    ${button_omni_dongbo}
    Wait Until Page Contains Element    ${textbox_omni_search_theo_mahd}     30s
    Input data    ${textbox_omni_search_theo_mahd}    ${invoice_code}
    Sleep    2s
    Wait Until Element Contains    ${label_omni_ma_hd}    ${invoice_code}     30s

Choose multi imei for product
    [Arguments]    ${list_imei}
    Wait Until Page Contains Element    ${button_omni_tim_imei}     20s
    :FOR      ${item_imei}    IN ZIP    ${list_imei}
    \     ${xp_imei}     Format String    ${button_omni_imei}    ${item_imei}
    \     Click Element    ${xp_imei}
    Click Element    ${button_omni_chon_imei_xong}

Choose imei in popup Sync Tiki, Lazada, Shopee
    [Arguments]     ${list_product}      ${list_imei}
    ${get_pr_id}      Get list product id thr API    ${list_product}
    :FOR      ${item_pr_id}     ${item_list_imei}     IN ZIP      ${get_pr_id}    ${list_imei}
    \     ${xp_chon_imei}   Format String    ${button_omni_chon_imei}    ${item_pr_id}
    \     Wait Until Page Contains Element    ${xp_chon_imei}   20s
    \     Click Element    ${xp_chon_imei}
    \     Choose multi imei for product    ${item_list_imei}

Choose lo in popup Sync Tiki, Lazada, Shopee
    [Arguments]      ${input_lo}
    Wait Until Page Contains Element    ${button_omni_chon_lo}   20s
    Click Element    ${button_omni_chon_lo}
    Wait Until Page Contains Element    ${textbox_omni_tim_lo}   20s
    Input Text   ${textbox_omni_tim_lo}     ${input_lo}
    ${xp_chon_lo}   Format String    ${label_omni_chon_lo}    ${input_lo}
    Wait Until Page Contains Element    ${xp_chon_lo}   20s
    Click Element    ${xp_chon_lo}
    Click Element    ${button_omni_chon_lo_xong}
