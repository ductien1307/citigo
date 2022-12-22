*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    ${headless_browser}
Test Setup        Before Test Shopee    ${tai_khoan}     ${mat_khau}
Test Teardown     After Test
Resource         ../../../../core/Thiet_lap/thiet_lap_nav.robot
Resource         ../../../../core/Thiet_lap/thiet_lap_cuahang_list_action.robot
Resource         ../../../../core/API/api_thietlap.robot
Resource         ../../../../core/API/api_shopee.robot
Resource         ../../../../core/API/api_mhbh_dathang.robot
Resource         ../../../../core/API/api_hoadon_banhang.robot
Resource         ../../../../core/API/api_dathang.robot
Resource         ../../../../core/API/api_trahang.robot
Resource         ../../../../core/API/api_hanghoa.robot
Resource         ../../../../core/API/api_danhmuc_hanghoa.robot
Resource         ../../../../share/constants.robot
Resource         ../../../../prepare/Hang_hoa/Sources/hanghoa.robot
Resource         ../../../../core/Shopee_UAT/shopee_list_action.robot

*** Variables ***
${tai_khoan}    apibuyer
${mat_khau}     Shopee123
@{list_tensp}     test sp shopee      Cáp sạc samsung
@{list_sl}     3    2
&{list_prs_num}        TPC001=3
&{list_prs_num1}        TPC002=2

*** Test Cases ***      Tên shop
Sync order                 [Tags]
                        [Template]    uat1
                        thanhptk      ${list_tensp}     ${list_sl}

*** Keywords ***
uat1
    [Arguments]   ${input_shop_shopee}      ${list_tensp}   ${list_num}
    Go To     https://uat.shopee.vn/${input_shop_shopee}
    Wait Until Page Contains Element    ${tab_tatca_sanpham}    40s
    Click Element       ${tab_tatca_sanpham}
    ${list_giaban_sp}   Create List
    :FOR      ${item_tensp}     IN ZIP      ${list_tensp}
    \     ${get_giaban_sap}     Choose product - add to card and return price    ${item_tensp}
    \     Append To List      ${list_giaban_sp}     ${get_giaban_sap}
    Go To   https://uat.shopee.vn/cart/
    Wait Until Page Contains Element    ${button_checkout_muahang}    40s
    Choose product and input number in cart    ${list_tensp}    ${list_num}
    Click Element   ${button_checkout_muahang}
