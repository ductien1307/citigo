*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    ${headless_browser}
Test Setup        Before Test Ban Hang
Test Teardown     After Test
Resource          ../../../config/env_product/envi.robot
Resource          ../../../core/share/computation.robot
Resource          ../../../core/Giao_dich/giaodich_nav.robot
Resource          ../../../core/API/api_danhmuc_hanghoa.robot
Resource          ../../../core/API/api_thietlap.robot
Resource          ../../../core/share/toast_message.robot
Resource          ../../../core/API/api_mhbh.robot
Resource          ../../../core/Giao_dich/hoa_don_list_action.robot
Resource          ../../../core/Giao_dich/banhang_action.robot
Resource          ../../../core/API/api_thietlapgia.robot

*** Variables ***
&{invoice_1}      TP003=1    TP004=2
@{discount_type_1}    dis    none
@{discount_1}     10      0


*** Test Cases ***     SP-SL           Discount         Discount type         GGHD    Mã kh       Khách tt      Bảng giá
Basic
                      [Tags]
                      [Template]    ebgdn1
                      ${invoice_1}    ${discount_1}    ${discount_type_1}    10      PVKH005        50000        Bảng giá kh2

*** Keywords ***
ebgdn1
    [Arguments]      ${dict_product_num}     ${input_bh_khachtt}      ${input_banggia}
    ## Get info ton cuoi, cong no khach hang
    ${list_product}    Get Dictionary Keys    ${dict_product_num}
    ${list_nums}    Get Dictionary Values    ${dict_product_num}
    # Input data into BH form
    ${get_id_banggia}    Get price book id   ${input_banggia}
    ${result_tongtienhang}    Get total sale incase choose price book        ${input_banggia}    ${list_product}    ${list_nums}
    ${result_banggia}       Get Text        ${dropdownlist_banggia}
    Should Be Equal As Strings    ${input_banggia}    ${result_banggia}
    #
    ${lastest_num}    Set Variable    0
    : FOR    ${item_product}    ${item_num}   ${item_newprice}    IN ZIP    ${list_product}    ${list_nums}      ${list_result_price}
    \    Input product-num in BH form    ${item_product}    ${item_num}    ${lastest_num}
    ${actual_khachtt}    Set Variable If    '${input_bh_khachtt}' == 'all'    ${result_tongtienhang}    ${input_bh_khachtt}
    Input Khach Hang    ${input_bh_ma_kh}
    Input customer payment and validate    ${textbox_bh_khachtt}    ${input_bh_khachtt}    ${result_khachcantra}
    Click Element JS    ${button_bh_thanhtoan}
    Invoice message success validation
    ${invoice_code}    Get saved code after execute
    #get values
    Assert values by invoice code until succeed    ${invoice_code}    ${result_tongtienhang}    ${result_tongtienhang}    ${input_bh_ma_kh}    ${actual_khachtt}    0     Hoàn thành
    Assert price book in invoice detail    ${invoice_code}    ${input_banggia}
    Delete invoice by invoice code    ${invoice_code}
