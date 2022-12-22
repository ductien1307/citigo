*** Settings ***
Library           SeleniumLibrary
Resource          dat_hang_page.robot
Resource          ../share/constants.robot
Resource          ../share/javascript.robot
Resource          ../share/computation.robot
Resource          ../share/discount.robot
Resource          ../Ban_Hang/banhang_action.robot
Resource          ../API/api_dathang.robot
Resource          ../API/api_danhmuc_hanghoa.robot
Resource          ../Ban_Hang/banhang_page.robot
Resource          dat_hang_navigation.robot

*** Keywords ***
Get DH thanh tien value
    [Arguments]    ${row_thanhtien}
    ${get_dh_thanhtien_com}    Format String    ${cell_dh_thanhtien}    ${row_thanhtien}
    ${get_dh_thanhtien}    Get Text    ${get_dh_thanhtien_com}
    ${get_dh_thanhtien}    Convert Any To Number    ${get_dh_thanhtien}
    Return From Keyword    ${get_dh_thanhtien}

Get DH tong tien hang value
    Wait Until Element Is Visible    ${cell_dh_tongtienhang}
    ${get_dh_tongtienhang}=    Get Text    ${cell_dh_tongtienhang}
    ${get_dh_tongtienhang}    Convert Any To Number    ${get_dh_tongtienhang}
    Return From Keyword    ${get_dh_tongtienhang}

Input Order info
    [Arguments]    ${input_dh_khachhang}    ${input_dh_khachtt}    ${result_khachcantra}
    Wait Until Page Contains Element    ${textbox_dh_search_khachhang}    1 min
    Wait Until Keyword Succeeds    3 times    3s    Input data    ${textbox_dh_search_khachhang}    ${input_dh_khachhang}
    Input payment from customer    ${textbox_dh_khachtt}    ${input_dh_khachtt}    ${result_khachcantra}    ${cell_tinhvaocongno_order}

Get tong tien hang frm UI
    Wait Until Page Contains Element    ${cell_tongtienhang}    2 mins
    ${result_tongtienhang}    Get Text    ${cell_tongtienhang}
    Return From Keyword    ${result_tongtienhang}

Input text to Ghi chu field
    [Arguments]    ${input_ghichu}
    Wait Until Page Contains Element    ${text_ghichu}    2 mins
    Wait Until Keyword Succeeds    3 times    10 s    Input text    ${text_ghichu}    ${input_ghichu}

Update quantity into DH form
    [Arguments]    ${input_ma_hh}    ${input_soluong}    ${lastest_num}
    ${textbox_multi_soluong}    Format String    ${textbox_multi_soluong}    ${input_ma_hh}
    Wait Until Page Contains Element    ${textbox_multi_soluong}    2 mins
    ${lastest_number}    Input number and validate data    ${textbox_multi_soluong}    ${input_soluong}    ${lastest_num}    ${cell_tongsoluong_dh}
    Return From Keyword    ${lastest_number}

Go to xu ly dat hang
    [Arguments]    ${input_ma_dh}
    Set Selenium Speed    2s
    Wait Until Page Contains Element    ${button_xuly_dathang_in_mhbh}    2 mins
    Click Element JS    ${button_xuly_dathang_in_mhbh}
    Input data    ${textbox_search_order}    ${input_ma_dh}
    ${button_select_order}    Format String    ${button_chon_order}    ${input_ma_dh}
    Wait Until Page Contains Element    ${button_select_order}    2 mins
    Click Element JS    ${button_select_order}
    Wait Until Element Is Visible    ${button_dh_giamoi}    2 mins

Input order payment into BH
    [Arguments]    ${input_bh_khachtt}    ${result_khachcantra}
    Wait Until Page Contains Element    ${textbox_khtt_order}    2 mins
    Wait Until Keyword Succeeds    3 times    10s    Input payment from customer    ${textbox_khtt_order}    ${input_bh_khachtt}    ${result_khachcantra}    ${cell_tinhvaocongno_order}

Computation and get list ending stock
    [Arguments]    ${get_ton_bf_execute}    ${get_toncuoi_dv_execute}    ${get_soluong_in_dh}    ${get_product_type}
    ${result_toncuoi_hht}    Minus    ${get_ton_bf_execute}    ${get_soluong_in_dh}
    ${result_toncuoi_dv}    Minus    ${get_toncuoi_dv_execute}    ${get_soluong_in_dh}
    ${result_toncuoi_bf}    Set Variable If    '${get_product_type}' == '2'    ${result_toncuoi_hht}    ${result_toncuoi_dv}
    ${result_toncuoi}    Set Variable If    '${get_product_type}' == '1'    0    ${result_toncuoi_bf}
    Return From Keyword    ${result_toncuoi}

Computation and get list ending stock for unit product
    [Arguments]    ${input_product}    ${input_giatri_quydoi}    ${get_soluong_in_dh}
    ${get_ma_hh_cb}    Get basic product frm unit product    ${input_product}
    ${ton_cuoi_cb}    Get onhand frm API    ${get_ma_hh_cb}
    ${result_soluongban}    Multiplication with price round 2    ${get_soluong_in_dh}    ${input_giatri_quydoi}
    ${result_toncuoi}    Minus    ${ton_cuoi_cb}    ${result_soluongban}
    Return From Keyword    ${result_toncuoi}

Go to BH frm process order
    [Arguments]    ${input_ma_dh}
    Click Element JS    ${button_taohoadon}
    ${cell_order_code}    Format String    ${cell_order_code_in_BH_form}      ${input_ma_dh}
    Wait Until Element Is Visible    ${cell_order_code}

Select order promotion
    [Arguments]    ${promo_name}
    Wait Until Element Is Visible    ${button_promo_order}
    Click Element JS    ${button_promo_order}
    ${checkbox_promo_to_select}    Format String    ${checkbox_promo_by_promoname}    ${promo_name}
    Wait Until Element Is Visible    ${checkbox_promo_to_select}
    Click Element JS    ${checkbox_promo_to_select}
    Click Element JS    ${button_apply_promo}
    Wait Until Element Is Visible    ${icon_promo_sale_order}

Select order multi promotion
    [Arguments]    ${promo_name}
    Wait Until Element Is Visible    ${button_multi_promo_order_payment}
    Click Element JS    ${button_multi_promo_order_payment}
    ${checkbox_promo_to_select}    Format String    ${checkbox_promo_by_promoname}    ${promo_name}
    Wait Until Element Is Visible    ${checkbox_promo_to_select}
    Click Element JS    ${checkbox_promo_to_select}
    Click Element JS    ${button_apply_promo}
    Wait Until Element Is Visible    ${icon_promo_sale_order}

Select order promotion and giveaway product by search product
    [Arguments]    ${promo_name}    ${list_product_giveaway}    ${list_num_giveaway}
    Wait Until Element Is Visible    ${button_promo_order}
    Click Element JS    ${button_promo_order}
    ${checkbox_promo_to_select}    Format String    ${checkbox_promo_by_promoname}    ${promo_name}
    Wait Until Element Is Visible    ${checkbox_promo_to_select}
    Click Element JS    ${checkbox_promo_to_select}
    ##
    ${textbox_timhangtang}    Format String    ${textbox_timhangtang}    ${promo_name}
    Click Element JS    ${textbox_timhangtang}
    Wait Until Element Is Visible    ${button_apply_in_select_giveaway_list}
    : FOR    ${item_product_giveaway}    IN ZIP    ${list_product_giveaway}
    \    Wait Until Keyword Succeeds    3 times    8 s      Input data in textbox and click    ${textbox_timhangkhuyenmai}    ${item_product_giveaway}    ${item_giveaway_product_inlist}    ${cell_result_timhangkhuyenmai}
    Click Element JS    ${button_apply_in_select_giveaway_list}
    #input Number
    : FOR    ${item_product_giveaway}    ${item_num_giveaway}    IN ZIP    ${list_product_giveaway}    ${list_num_giveaway}
    \    ${xpath_textbox_number_giveaway}    Format String    ${cell_num_in_promo_screen}    ${item_product_giveaway}
    \    Input Text    ${xpath_textbox_number_giveaway}    ${item_num_giveaway}
    #
    Click Element JS    ${button_apply_promo}
    Wait Until Element Is Visible    ${icon_promo_sale_in_pro_compo}

Computation and get list ending stock incase multi row and unit product
    [Arguments]    ${input_giatri_quydoi}    ${get_soluong_in_dh}    ${ton_cuoi_cb}
    ${result_soluongban}    Multiplication with price round 2    ${get_soluong_in_dh}    ${input_giatri_quydoi}
    ${result_toncuoi}    Minus    ${ton_cuoi_cb}    ${result_soluongban}
    Return From Keyword    ${result_toncuoi}

Choose Tai khoan nhan in popup Khach thanh toan
    [Arguments]   ${phuong_thuc}      ${so_tai_khoan}
    ${tkn_indropdow}    Format String    ${item_dh_tk_nhan_in_dropdowlist}    ${so_tai_khoan}
    Click Element JS    ${cell_dh_tk_nhan}
    Wait Until Page Contains Element    ${tkn_indropdow}    20s
    Click Element JS       ${tkn_indropdow}

Open popup Khach thanh toan and choose payment method in DH Format
    [Arguments]     ${phuong_thuc}    ${input_khachtt}      ${so_tai_khoan}
    Wait Until Keyword Succeeds    3 times    3s    Click Element JS      ${button_dh_khachtt}
    Wait Until Element Is Visible    ${textbox_dh_sotien_khachtt}     10s
    #Input Text      ${textbox_dh_sotien_khachtt}    ${input_khachtt}
    Input data   ${textbox_dh_sotien_khachtt}    ${input_khachtt}
    ${button_pttt}    Format String    ${button_dh_phuongthuc_tt}    ${phuong_thuc}
    Click Element JS      ${button_pttt}
    Run Keyword If    '${phuong_thuc}'!='Tiền mặt'    Choose Tai khoan nhan in popup Khach thanh toan    ${phuong_thuc}    ${so_tai_khoan}   ELSE   Log    Ignore choose tkn
    Click Element JS      ${button_dh_pttt_xong}

Input payment method for customer
    [Arguments]      ${input_value_payment}   ${phuong_thuc}      ${so_tai_khoan}   ${result_khachcantra}    ${cell_tinhvaocongno}
    ${result_khtt}    Minus and round    ${input_value_payment}    ${result_khachcantra}
    Open popup Khach thanh toan and choose payment method in DH Format    ${phuong_thuc}    ${input_value_payment}    ${so_tai_khoan}
    Validate customer payment    ${result_khtt}    ${cell_tinhvaocongno}

Input product - nums - discount into DH form
    [Arguments]     ${list_product}    ${list_nums}    ${list_ggsp}    ${list_discount_type}    ${list_result_giamoi}
    ${laster_nums}    Set Variable    0
    : FOR    ${item_product}    ${item_nums}    ${item_ggsp}    ${item_price}   ${item_discount_type}    IN ZIP    ${list_product}    ${list_nums}    ${list_ggsp}    ${list_result_giamoi}    ${list_discount_type}
    \    ${laster_nums}    Input product-num in sale form    ${item_product}    ${item_nums}    ${laster_nums}    ${cell_tongsoluong_dh}
    \    Run keyword if    '${item_discount_type}' == 'dis'     Input % discount for multi product    ${item_product}    ${item_ggsp}
    \    ...    ${item_price}    ELSE IF    '${item_discount_type}' == 'disvnd'    Input VND discount for multi product    ${item_product}    ${item_ggsp}    ${item_price}
    \    ...     ELSE IF  '${item_discount_type}' == 'changeup' or '${item_discount_type}' == 'changedown'   Input newprice for multi product    ${item_product}    ${item_ggsp}    ELSE    Log    Ignore input

Input discount order into DH form
      [Arguments]     ${input_ggdh}    ${result_ggdh}
      Wait Until Keyword Succeeds    3 times    3s    Run keyword if    0 < ${input_ggdh} < 100    Input % discount order    ${input_ggdh}    ${result_ggdh}   ELSE    Input VND discount order    ${input_ggdh}

Input customer payment into DH form
      [Arguments]     ${input_khtt}    ${input_ma_kh}    ${result_tongtienhang}    ${input_tienkhachtra}
      Wait Until Keyword Succeeds    3 times    3s    Run Keyword If    '${input_khtt}' == '0'    Input Khach Hang    ${input_ma_kh}    ELSE    Input Order info    ${input_ma_kh}    ${input_tienkhachtra}    ${result_tongtienhang}
