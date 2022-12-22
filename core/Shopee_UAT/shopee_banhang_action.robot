*** Settings ***
Library           SeleniumLibrary
Resource          shopee_banhang_page.robot
Resource          ../share/constants.robot
Resource          ../share/computation.robot

*** Keywords ***
Login Shopee Ban Hang UAT
    [Arguments]     ${input_tk}     ${input_mk}
    Wait Until Page Contains Element    ${textbox_shopee_taikhoan_bh}     30s
    Input Text    ${textbox_shopee_taikhoan_bh}    ${input_tk}
    Input Text    ${textbox_shopee_matkhau_bh}    ${input_mk}
    Click Element    ${button_shopee_dangnhap}
    Wait Until Page Contains Element    ${button_quanly_donhang}    30s

Assert gia in Shopee
    [Arguments]     ${input_gia}
    Reload Page
    Wait Until Page Contains Element    ${cell_shopee_gia}    30s
    ${get_gia}    Get Text    ${cell_shopee_gia}
    ${get_gia}    Remove String    ${get_gia}    .    ₫
    Should Be Equal As Numbers    ${get_gia}    ${input_gia}

Assert kho hang in Shopee
    [Arguments]     ${input_khohang}
    Reload Page
    Wait Until Page Contains Element    ${cell_shopee_khohang}    30s
    ${get_kho_hang}   Get Text    ${cell_shopee_khohang}
    Should Be Equal As Numbers    ${input_khohang}    ${get_kho_hang}

Assert Gia ban, kho hang in Shopee UAT
    [Arguments]     ${shop_shopee}    ${mk_shopee}  ${ma_hh_shopee}   ${gia_ban}    ${ton}
    Go To    https://banhang.uat.shopee.vn/
    Login Shopee Ban Hang UAT    ${shop_shopee}    ${mk_shopee}
    Go To    https://banhang.uat.shopee.vn/portal/product/list/all?page=1&search=sku&keyword=${ma_hh_shopee}
    Wait Until Keyword Succeeds    5x    1 min    Assert gia in Shopee    ${gia_ban}
    Wait Until Keyword Succeeds    5x    1 min    Assert kho hang in Shopee      ${ton}
