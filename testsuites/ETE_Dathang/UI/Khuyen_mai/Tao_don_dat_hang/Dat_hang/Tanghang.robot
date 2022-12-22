*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    ${headless_browser}
Test Setup        Before Test Ban Hang
Test Teardown     After Test
Resource          ../../../../../../core/API/api_thietlap.robot
Resource          ../../../../../../core/API/api_dathang.robot
Resource          ../../../../../../core/Ban_Hang/banhang_getandcompute.robot
Resource          ../../../../../../core/share/toast_message.robot
Resource          ../../../../../../core/API/api_mhbh_dathang.robot
Resource          ../../../../../../core/API/api_soquy.robot
Resource          ../../../../../../core/API/api_danhmuc_hanghoa.robot

*** Variables ***
&{list_product2}    PROMO5=5.3
&{list_giveaway1}    DV031=1    DV032=1    DV033=1
@{list_no_discount}    0

*** Test Cases ***    Product and num list    GGDH            Khách hàng    Khách thanh toán    Khuyến mại    Hàng Tặng             GGSP
KM dat hang tang hang
                      [Documentation]         San pham KM la SP dich vu\nCase khong validate ton kho cua SP KM
                      [Tags]                  UKMDH1
                      [Template]              edhkm2
                      ${list_product2}        30000           CTKH115           0               KM03            ${list_giveaway1}    ${list_no_discount}
                      ${list_product2}        50000           CTKH116           all             KM03            ${list_giveaway1}    ${list_no_discount}

*** Keywords ***
edhkm2
    [Arguments]    ${dict_product_nums}    ${input_ggdh}    ${input_ma_kh}    ${input_bh_khachtt}    ${input_khuyemmai}    ${list_giveaway}
    ...    ${list_discount}
    [Timeout]
    ## Get info ton cuoi, cong no khach hang
    Toggle status of promotion    ${input_khuyemmai}    1
    ${invoice_value}    ${received_value}    ${discount}    ${discount_ratio}    ${name}    Get Invoice value - Received value - Discounts - Promotion Name from Promotion Code    ${input_khuyemmai}
    #create lists
    ${list_prs}    Get Dictionary Keys    ${dict_product_nums}
    ${list_nums}    Get Dictionary Values    ${dict_product_nums}
    ${list_giveaway_product}    Get Dictionary Keys    ${list_giveaway}
    ${list_giveaway_num}    Get Dictionary Values    ${list_giveaway}
    Reload Page
    # Input data into BH form
    Wait Until Keyword Succeeds    3 times    5 s    Click Element JS    ${tab_dathang}
    ${list_result_thanhtien}    ${list_result_order_summary}    ${list_result_newprice}    Get list total sale and order summary incase discount    ${list_prs}    ${list_nums}    ${list_discount}
    ${list_result_order_summary_promotion}    Get list result order summary frm product API    ${list_giveaway_product}    ${list_giveaway_num}
    ${lastest_num}    Set Variable    0
    : FOR    ${item_product}    ${item_nums}    IN ZIP    ${list_prs}    ${list_nums}
    \    ${lastest_num}    Wait Until Keyword Succeeds    3 times    5 s    Input product-num in sale form    ${item_product}    ${item_nums}
    \    ...    ${lastest_num}    ${cell_tongsoluong_dh}
    #compute
    ${result_tongtienhang}    Sum values in list    ${list_result_thanhtien}
    ${result_khachcantra}    Minus and replace floating point    ${result_tongtienhang}    ${input_ggdh}
    ${actual_khachtt}    Set Variable If    '${input_bh_khachtt}' == 'all'    ${result_khachcantra}    ${input_bh_khachtt}
    #create order
    Input Khach Hang    ${input_ma_kh}
    Run Keyword If    ${result_tongtienhang} > ${invoice_value}    Wait Until Keyword Succeeds    3 times    8 s    Select order promotion and giveaway product by search product    ${name}
    ...    ${list_giveaway_product}    ${list_giveaway_num}
    ...    ELSE    Element Should Not Be Visible    ${icon_promo_sale}
    Wait Until Keyword Succeeds    3 times    8 s    Input VND discount order    ${input_ggdh}
    Run Keyword If    '${input_bh_khachtt}' != '0'    Input payment and validate into any form    ${textbox_dh_khachtt}    ${actual_khachtt}    ${button_bh_dathang}    ${result_khachcantra}
    ...    ${cell_tinhvaocongno_order}
    ...    ELSE    Click Element JS    ${button_bh_dathang}
    SLeep    2s
    Order message success validation
    ${order_code}    Get saved code after execute
    #get values
    Sleep    20 s    wait for response to API
    #assert values in order
    ${get_ma_kh_in_dh_af_execute}    ${get_TTDH_in_dh_af_execute}    ${get_tongtienhang_in_dh_af_exxecute}    ${get_khachdatra_in_dh_af_execute}    ${get_giamgia_in_dh_af_execute}    ${get_tongcong_in_dh_af_execute}    ${get_ghichu_in_dh_af_execute}
    ...    Get order info incase discount by order code    ${order_code}
    Should Be Equal As Strings    ${get_ma_kh_in_dh_af_execute}    ${get_ma_kh_in_dh_af_execute}
    Should Be Equal As Numbers    ${get_TTDH_in_dh_af_execute}    1    #1 : phiếu tạm
    Should Be Equal As Numbers    ${get_tongtienhang_in_dh_af_exxecute}    ${result_tongtienhang}
    Should Be Equal As Numbers    ${get_khachdatra_in_dh_af_execute}    ${actual_khachtt}
    Should Be Equal As Numbers    ${get_giamgia_in_dh_af_execute}    ${input_ggdh}
    Should Be Equal As Numbers    ${get_tongcong_in_dh_af_execute}    ${result_khachcantra}
    #assert value product
    ${list_order_summary_af_execute}    Get list order summary frm product API    ${list_prs}
    : FOR    ${result_tong_dh}    ${order_summary_af_execute}    IN ZIP    ${list_result_order_summary}    ${list_order_summary_af_execute}
    \    Should Be Equal As Numbers    ${order_summary_af_execute}    ${result_tong_dh}
    #assert value product promotion
    ${list_order_summary_af_execute_promotion}    Get list order summary frm product API    ${list_giveaway_product}
    : FOR    ${result_order_summary_pro}    ${order_summary_af_execute_pro}    IN ZIP    ${list_result_order_summary_promotion}    ${list_order_summary_af_execute_promotion}
    \    Should Be Equal As Numbers    ${order_summary_af_execute_pro}    ${result_order_summary_pro}
    Delete order frm Order code    ${order_code}
    Toggle status of promotion    ${input_khuyemmai}    0
    Reload Page
