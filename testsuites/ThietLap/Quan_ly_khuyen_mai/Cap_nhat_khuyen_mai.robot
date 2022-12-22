*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    ${headless_browser}
Test Setup        Before Test Quan ly
Test Teardown     After Test
Resource         ../../../core/Thiet_lap/thiet_lap_nav.robot
Resource         ../../../core/Thiet_lap/khuyenmai_list_page.robot
Resource         ../../../core/Thiet_lap/khuyenmai_list_action.robot
Resource         ../../../core/API/api_thietlap.robot
Resource         ../../../core/API/api_danhmuc_hanghoa.robot
Resource         ../../../core/share/javascript.robot
Resource         ../../../core/share/toast_message.robot
Resource         ../../../core/share/discount.robot
Library           SeleniumLibrary
Resource         ../../../prepare/Hang_hoa/Sources/thietlap.robot

*** Test Cases ***      Mã promo      Promo name            Tong tien hang    Quantity    Category    Promo value    VND    %       Category new        Quantity new    Promovalue new      Status
Cap nhat                [Tags]    TL     PROMO
                      [Template]    update
                      UDPRO01          Khuyến mại hóa đơn    1000000         10             Kẹo bánh    50000       null    %       Hạt nhập khẩu KM      5             50000               False

Xoa                [Tags]     TL     PROMO
                      [Template]    delete
                      UDPRO02          Khuyến mại hàng hóa    300000         3             Dịch vụ      20000     null

*** Keywords ***
update
    [Arguments]    ${input_ma_promo}   ${input_promo_name}    ${input_tongtienhang}    ${input_quantity}    ${input_category_name}
    ...    ${discount_product}    ${discount_product_ratio}    ${discount_type}   ${input_cat_name_new}   ${input_quantity_new}   ${input_discount_product_new}
    ...     ${input_status_new}
    Set Selenium Speed    2s
    ${get_id_promo}    Get Id promotion    ${input_ma_promo}
    Run Keyword If    '${get_id_promo}' == '0'    Log    Ignore     ELSE          Delete promo    ${get_id_promo}
    Create promotion by invoice with product discount    ${input_ma_promo}    ${input_promo_name}    ${input_tongtienhang}    ${input_quantity}
    ...    ${input_category_name}    ${discount_product}    ${discount_product_ratio}    ${discount_type}
    Go to any thiet lap    ${button_quanly_khuyenmai}
    Go to update promotion form    ${input_ma_promo}
    Run Keyword If   0 < ${input_discount_product_new} < 100   Input data    ${textbox_giatriKM}   ${input_discount_product_new}
    ...    ELSE   Select value any form    ${button_giamgia_vnd}     ${textbox_giatriKM}   ${input_discount_product_new}
    Input data    ${textbox_hang_giamgia}   ${input_quantity_new}
    Click Element    ${icon_clear_category}
    Select category from Chon nhom hang popup    ${button_menu_hangtang}    ${input_cat_name_new}
    Wait Until Element Is Visible    ${button_promotion_save}
    Click Element JS        ${button_promotion_save}
    Sleep   10s
    ${cat_id}    Get category ID    ${input_cat_name_new}
    ${get_id_promo}    Get Id promotion    ${input_ma_promo}
    ${endpoint_promo_detail}    Format String    ${endpoint_cam_detail}    ${get_id_promo}
    ${response_promo_info}    Get response from API by other url    ${PROMO_API}    ${endpoint_promo_detail}
    ${get_promo_name}    Get data from response json    ${response_promo_info}    $.Name
    ${get_promo_trangthai}    Get data from response json and return false value    ${response_promo_info}    $.IsActive
    ${get_promo_type}    Get data from response json    ${response_promo_info}    $.PromotionType
    ${get_promo_invoicevalue}    Get data from response json    ${response_promo_info}    $.SalePromotions..InvoiceValue
    ${get_promo_value}    Get data from response json    ${response_promo_info}    $.SalePromotions..ProductDiscount
    ${get_category_id}    Get data from response json    ${response_promo_info}    $.SalePromotions..ReceivedCategoryId
    Should Be Equal As Strings    ${get_promo_name}    ${input_promo_name}
    Should Be Equal As Numbers    ${get_promo_value}    ${input_discount_product_new}
    Should Be Equal As Strings    ${get_promo_trangthai}    ${input_status_new}
    Should Be Equal As Numbers    ${get_promo_invoicevalue}    ${input_tongtienhang}
    Should Be Equal As Numbers    ${get_category_id}    ${cat_id}
    Should Be Equal As Numbers    ${get_promo_type}    3
    Delete promo    ${get_id_promo}

delete
    [Arguments]    ${input_ma_promo}   ${input_promo_name}    ${input_price}    ${input_quantity}    ${input_category_name}
    ...    ${discount_product}    ${discount_product_ratio}
    Set Selenium Speed    2s
    ${get_id_promo}    Get Id promotion    ${input_ma_promo}
    Run Keyword If    '${get_id_promo}' == '0'    Log    Ignore     ELSE          Delete promo    ${get_id_promo}
    Create promotion by product with baseprice based on quantity    ${input_ma_promo}   ${input_promo_name}    ${input_category_name}    ${input_quantity}
    ...    ${input_price}    ${discount_product}    ${discount_product_ratio}
    Go to any thiet lap    ${button_quanly_khuyenmai}
    Wait Until Element Is Visible    ${textbox_search_promo}
    Input data    ${textbox_search_promo}    ${input_ma_promo}
    Wait Until Element Is Visible    ${checkbox_filter_trangthai_tatca}
    Click Element JS    ${checkbox_filter_trangthai_tatca}
    Sleep    2s
    Wait Until Element Is Visible    ${button_delete_promo}
    Click Element JS    ${button_delete_promo}
    Sleep    2s
    Wait Until Element Is Visible    ${button_dongy_del_promo}
    Click Element JS    ${button_dongy_del_promo}
    Sleep   1s
    Delete promotion message succest validation    ${input_ma_promo}
