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
&{dict_product_nums2}   PROMO2=3

*** Test Cases ***    List product nums        GGDH                                                                Mã KH      Khách thanh toán    Mã khuyến mãi
KM HH hinh thuc gia ban theo SL mua
                      [Documentation]          San pham KM la SP dich vu\nCase khong validate ton kho cua SP KM
                      [Tags]                   UKMDH
                      [Template]               edhkm4
                      ${dict_product_nums2}    5                                                                   CTKH116    0                   KM09
                      ${dict_product_nums2}    10                                                                  CTKH117    20000              KM11
                      ${dict_product_nums2}    0                                                                   CTKH118    all                 KM10

*** Keywords ***
edhkm4
    [Arguments]    ${dict_product_num}    ${input_bh_giamdh}    ${input_bh_ma_kh}    ${input_bh_khachtt}    ${input_khuyemmai}
    [Timeout]
    ## Get info ton cuoi, cong no khach hang
    Toggle status of promotion    ${input_khuyemmai}    1
    ${list_product}    Get Dictionary Keys    ${dict_product_num}
    ${list_nums}    Get Dictionary Values    ${dict_product_num}
    ${num_sale_product}    ${num_promo_product}    ${product_price}    ${discount}    ${discount_ratio}    ${name}    Get Number of sale product - promo product - promo value and name
    ...    ${input_khuyemmai}
    ${get_no_bf_execute}    ${get_tongban_bf_execute}    ${get_tongban_tru_trahang_bf_execute}    ${get_customer_name}    Get Customer Info from API    ${input_bh_ma_kh}
    #create lists
    Reload page
    # Input data into BH form
    ${total_sale_number}    Sum values in list    ${list_nums}
    ${list_result_totalsale}    ${list_result_onhand_af_ex}    Run Keyword If    ${discount} != 0 and ${discount_ratio} ==0    Get list of total sale - result onhand in case discount product    ${list_product}    ${list_nums}
    ...    ${discount}
    ...    ELSE IF    ${discount} == 0 and ${discount_ratio} != 0    Get list of total sale - result onhand in case discount product    ${list_product}    ${list_nums}    ${discount_ratio}
    ...    ELSE IF    ${total_sale_number} < ${num_sale_product}    Get list of total sale - result onhand with one discount    ${list_product}    ${list_nums}
    ...    ELSE    Get list of total sale - result onhand in case promotion    ${list_product}    ${list_nums}    ${product_price}    ${num_sale_product}
    ${list_result_order_summary}    Get list result order summary frm product API    ${list_product}    ${list_nums}
    Wait Until Keyword Succeeds    3 times    5 s    Click Element JS    ${tab_dathang}
    Wait Until Keyword Succeeds    3 times    8 s    Input Customer and validate    ${input_bh_ma_kh}    ${get_customer_name}
    ${lastest_num}    Set Variable    0
    : FOR    ${item_product}    ${item_num}    IN ZIP    ${list_product}    ${list_nums}
    \    ${lastest_num}    Input product-num in sale form    ${item_product}    ${item_num}    ${lastest_num}    ${cell_tongsoluong_dh}
    \    Run Keyword If    ${total_sale_number} >= ${num_sale_product}    Wait Until Keyword Succeeds    3 times    8 s    Select promotion on each product line
    \    ...    ${name}    ELSE    Log    kmk
    ${result_tongtienhang}    Sum values in list    ${list_result_totalsale}
    ${result_khachcantra}    Price after % discount invoice    ${result_tongtienhang}    ${input_bh_giamdh}
    ${result_khachcantra}    Replace floating point    ${result_khachcantra}
    ${result_discount_by_vnd}    Convert % discount to VND and round    ${result_tongtienhang}    ${input_bh_giamdh}
    ${actual_khachtt}    Set Variable If    '${input_bh_khachtt}' == 'all'    ${result_khachcantra}    ${input_bh_khachtt}
    ${result_no_hoadon}    Minus    ${result_khachcantra}    ${actual_khachtt}
    ${result_nohientai}    sum    ${result_no_hoadon}    ${get_no_bf_execute}
    ${result_tongban}    Sum    ${result_khachcantra}    ${get_tongban_bf_execute}
    Wait Until Keyword Succeeds    3 times    8 s    Input % discount order    ${input_bh_giamdh}    ${result_discount_by_vnd}
    Wait Until Keyword Succeeds    3 times    8 s    Run Keyword If    '${input_bh_khachtt}' != '0'    Input payment and validate into any form    ${textbox_dh_khachtt}
    ...    ${actual_khachtt}    ${button_bh_dathang}    ${result_khachcantra}    ${cell_tinhvaocongno_order}
    ...    ELSE    Click Element JS    ${button_bh_dathang}
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
    Should Be Equal As Numbers    ${get_giamgia_in_dh_af_execute}    ${result_discount_by_vnd}
    Should Be Equal As Numbers    ${get_tongcong_in_dh_af_execute}    ${result_khachcantra}
    #assert value product
    ${list_order_summary_af_execute}    Get list order summary frm product API    ${list_product}
    : FOR    ${result_tong_dh}    ${order_summary_af_execute}    IN ZIP    ${list_result_order_summary}    ${list_order_summary_af_execute}
    \    Should Be Equal As Numbers    ${order_summary_af_execute}    ${result_tong_dh}
    Delete order frm Order code    ${order_code}
    Toggle status of promotion    ${input_khuyemmai}    0
