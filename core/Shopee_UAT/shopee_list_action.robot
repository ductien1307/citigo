*** Settings ***
Library           SeleniumLibrary
Resource          shopee_list_page.robot
Resource          ../share/constants.robot
Resource          ../share/computation.robot

*** Keywords ***
Login Shopee
    [Documentation]      Login shopee
    [Arguments]     ${input_taikhoan}     ${input_matkhau}
    Wait Until Page Contains Element    ${textbox_input_taikhoan_shopee}      30s
    Input Text    ${textbox_input_taikhoan_shopee}    ${input_taikhoan}
    Input Text    ${textbox_input_matkhau_shopee}    ${input_matkhau}
    Click Element    ${button_login_shopee}
    Wait Until Page Contains Element    ${button_close_popup_shopee}   1 min

Search product and add to cart in shop Shopee
    [Arguments]     ${input_ten_sp}
    Wait Until Page Contains Element    ${textbox_search_timtrongshopnay}     30s
    Input data    ${textbox_search_timtrongshopnay}     ${input_ten_sp}
    ${xp_item_sp}     Format String     ${item_sanpham_shopee}    ${input_ten_sp}
    Wait Until Page Contains Element    ${xp_item_sp}     30s
    Click Element    ${xp_item_sp}
    Wait Until Page Contains Element    ${button_add_themvao_giohang}     30s
    Click Element    ${button_add_themvao_giohang}

Choose product - add to card and return price
    [Documentation]      Chọn sản phẩm và add vào giỏ hàng
    [Arguments]     ${input_ten_sp}
    ${xp_item_sp}     Format String     ${item_sanpham_shopee}   ${input_ten_sp}
    Wait Until Page Contains Element    ${xp_item_sp}     40s
    Click Element    ${xp_item_sp}
    Wait Until Page Contains Element     ${button_add_themvao_giohang}    30s
    ${get_giaban}   Get Text    ${label_giaban_sanpham}
    ${get_giaban}     Replace String    ${get_giaban}   ₫     .
    Click Element   ${button_add_themvao_giohang}
    Wait Until Page Contains Element      ${button_add_themvao_giohang}   30s
    Go Back
    Return From Keyword    ${get_giaban}

Choose product and input number in cart
    [Documentation]      Chọn sản phẩm và điền giá bán trong giỏ hàng
    [Arguments]     ${list_tensp}     ${list_num}
    :FOR    ${item_tensp}     ${item_num}     IN ZIP      ${list_tensp}     ${list_num}
    \   ${xp_hanghoa}     Format String   ${checkbok_chon_hanghoa}    ${item_tensp}
    \   ${xp_soluong}     Format String   ${textbox_input_soluong}     ${item_tensp}
    \   Click Element    ${xp_hanghoa}
    \   Input Text      ${xp_soluong}     ${item_num}

Login to Authorize Shopee Openplatform
    [Arguments]   ${taikhoan}     ${matkhau}
    Wait Until Page Contains Element    ${textbox_acc_seller_shopee}    20s
    Click Element     ${box_quocgia}
    Click Element    ${item_quocgia_vietnam}
    Input Text    ${textbox_acc_seller_shopee}    ${taikhoan}
    Input Text    ${textbox_password_seller_shopee}    ${matkhau}
    Click Element    ${button_login_seller_shopee}

Login to Authorize Shopee Openplatform APP
    [Arguments]   ${taikhoan}     ${matkhau}
    Wait Until Page Contains Element    ${textbox_app_tk_shopee}    20s
    Click Element     ${box_app_quocgia}
    Click Element    ${item_app_quocgia_vietnam}
    Input Text    ${textbox_app_tk_shopee}    ${taikhoan}
    Input Text    ${textbox_app_mk_shopee}    ${matkhau}
    Click Element    ${button_app_login_shopee}
