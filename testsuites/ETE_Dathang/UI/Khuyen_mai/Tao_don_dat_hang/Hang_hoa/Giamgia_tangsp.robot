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
&{list_product_nums1}    PROMO5=1
&{dict_promo_nor1}    HKM001=2    HKM002=0
&{dict_promo_nor2}    HKM001=1    HKM002=1
@{list_no_discount}    0    0    0    0    0

*** Test Cases ***    List product nums        GGDH                                                                Mã KH      Khách thanh toán    Mã khuyến mãi    List product          List GGSP
KM HH hinh thuc mua hang GG hang va tang hang
                      [Tags]                   UKMDH
                      [Template]               edhkm5
                      ${list_product_nums1}    5000                                                               CTKH119    0                   KM07            ${dict_promo_nor1}    ${list_no_discount}    #mua hang gg hang %
                      ${list_product_nums1}    8000                                                               CTKH120    all                 KM08            ${dict_promo_nor2}    ${list_no_discount}    #mua hang gg hang tang hang
                      ${list_product_nums1}    10000                                                              CTKH121    10000               KM06            ${dict_promo_nor1}    ${list_no_discount}    #mua hang gg hang vnd

*** Keywords ***
edhkm5
    [Arguments]    ${dict_product_num}    ${input_discount_order}    ${input_ma_kh}    ${input_bh_khachtt}    ${input_khuyemmai}    ${dict_promo_product}
    ...    ${list_ggsp}
    [Timeout]
    Set Selenium Speed    0.5s
    ## Get info ton cuoi, cong no khach hang
    Toggle status of promotion    ${input_khuyemmai}    1
    ${num_sale_product}    ${num_promo_product}    ${product_price}    ${discount}    ${discount_ratio}    ${name}    Get Number of sale product - promo product - promo value and name
    ...    ${input_khuyemmai}
    ${list_product}    Get Dictionary Keys    ${dict_product_num}
    ${list_nums}    Get Dictionary Values    ${dict_product_num}
    ${list_promo_product}    Get Dictionary Keys    ${dict_promo_product}
    ${list_promo_num}    Get Dictionary Values    ${dict_promo_product}
    ${get_no_bf_execute}    ${get_tongban_bf_execute}    ${get_tongban_tru_trahang_bf_execute}    ${get_customer_name}    Get Customer Info from API    ${input_ma_kh}
    #create lists
    Reload Page
    ${list_material_by_combo}    create list
    ${list_quantity_material_by_combo}    create list
    : FOR    ${item_product}    IN    @{list_product}
    \    ${list_material_product_code_by_combo}    ${list_material_quantity_by_combo}    Get material product code and quantity lists of combo    ${item_product}
    \    Append To List    ${list_material_by_combo}    ${list_material_product_code_by_combo}
    \    Append To List    ${list_quantity_material_by_combo}    ${list_material_quantity_by_combo}
    Log Many    ${list_material_by_combo}
    Log Many    ${list_quantity_material_by_combo}
    # Promo products
    ${list_result_totalsale_promo}    ${list_result_onhand_promo}    Run keyword if    ${discount} != 0    Get list of total sale - result onhand in case discount product    ${list_promo_product}    ${list_promo_num}
    ...    ${discount}
    ...    ELSE    Get list of total sale - result onhand in case discount product    ${list_promo_product}    ${list_promo_num}    ${discount_ratio}
    ${total_promo_sale}    Sum values in list    ${list_result_totalsale_promo}
    # Input data into BH form
    Wait Until Keyword Succeeds    3 times    5 s    Click Element JS    ${tab_dathang}
    ${laster_nums}    Set Variable    0
    ${list_result_thanhtien}    ${list_result_order_summary}    ${list_result_giamoi}    Get list total sale and order summary incase discount    ${list_product}    ${list_nums}    ${list_ggsp}
    ${list_result_order_summary_promotion}    Get list result order summary frm product API    ${list_promo_product}    ${list_promo_num}
    : FOR    ${item_product}    ${item_num}    IN ZIP    ${list_product}    ${list_nums}
    \    ${laster_nums}    Input product-num in sale form    ${item_product}    ${item_num}    ${laster_nums}    ${cell_tongsoluong_dh}
    #Compute
    ${result_tongtienhang}    Sum values in list    ${list_result_thanhtien}
    ${result_tongtienhang_promo}    Sum    ${result_tongtienhang}    ${total_promo_sale}
    ${actual_tongtienhang}    Set Variable If    ${discount} == 0 and ${discount_ratio} == 0    ${result_tongtienhang}    ${result_tongtienhang_promo}
    ${result_khachcantra}    Minus    ${actual_tongtienhang}    ${input_discount_order}
    ${result_khachcantra}    Replace floating point    ${result_khachcantra}
    ${actual_khachtt}    Set Variable If    '${input_bh_khachtt}' == 'all'    ${result_khachcantra}    ${input_bh_khachtt}
    ${result_nohientai}    Minus    ${get_no_bf_execute}    ${actual_khachtt}
    #create invoice
    Input Khach Hang    ${input_ma_kh}
    Select promotion and giveaway product on the first row product    ${name}    ${list_promo_product}    ${list_promo_num}
    Wait Until Keyword Succeeds    3 times    8 s    Input VND discount order    ${input_discount_order}
    Run Keyword If    '${input_bh_khachtt}' != '0'    Input payment and validate into any form    ${textbox_dh_khachtt}    ${actual_khachtt}    ${button_bh_dathang}    ${result_khachcantra}
    ...    ${cell_tinhvaocongno_order}    ELSE    Click Element JS    ${button_bh_dathang}
    Sleep    2s
    Order message success validation
    ${order_code}    Get saved code after execute
    #get values
    Sleep    20 s    wait for response to API
    #assert values in order
    ${get_ma_kh_in_dh_af_execute}    ${get_TTDH_in_dh_af_execute}    ${get_tongtienhang_in_dh_af_exxecute}    ${get_khachdatra_in_dh_af_execute}    ${get_giamgia_in_dh_af_execute}    ${get_tongcong_in_dh_af_execute}    ${get_ghichu_in_dh_af_execute}
    ...    Get order info incase discount by order code    ${order_code}
    Should Be Equal As Strings    ${get_ma_kh_in_dh_af_execute}    ${get_ma_kh_in_dh_af_execute}
    Should Be Equal As Numbers    ${get_TTDH_in_dh_af_execute}    1    #1 : phiếu tạm
    Should Be Equal As Numbers    ${get_tongtienhang_in_dh_af_exxecute}    ${actual_tongtienhang}
    Should Be Equal As Numbers    ${get_khachdatra_in_dh_af_execute}    ${actual_khachtt}
    Should Be Equal As Numbers    ${get_giamgia_in_dh_af_execute}    ${input_discount_order}
    Should Be Equal As Numbers    ${get_tongcong_in_dh_af_execute}    ${result_khachcantra}
    #assert value product
    ${list_order_summary_af_execute}    Get list order summary frm product API    ${list_product}
    : FOR    ${result_tong_dh}    ${order_summary_af_execute}    IN ZIP    ${list_result_order_summary}    ${list_order_summary_af_execute}
    \    Should Be Equal As Numbers    ${order_summary_af_execute}    ${result_tong_dh}
    #assert value product promotion
    ${list_order_summary_af_execute_promotion}    Get list order summary frm product API    ${list_promo_product}
    : FOR    ${result_order_summary_pro}    ${order_summary_af_execute_pro}    IN ZIP    ${list_result_order_summary_promotion}    ${list_order_summary_af_execute_promotion}
    \    Should Be Equal As Numbers    ${order_summary_af_execute_pro}    ${result_order_summary_pro}
    #assert value khach hang and so quy
    ${get_no_af_execute}    ${get_tongban_af_execute}    ${get_tongban_tru_trahang_af_execute}    Get Customer Debt from API    ${input_ma_kh}
    ${get_ma_phieutt_in_dh}    Get ma phieu thanh toan dat hang frm API    ${order_code}
    Should Be Equal As Numbers    ${get_no_af_execute}    ${result_nohientai}
    Should Be Equal As Numbers    ${get_tongban_af_execute}    ${get_tongban_bf_execute}
    Should Be Equal As Numbers    ${get_tongban_tru_trahang_af_execute}    ${get_tongban_tru_trahang_bf_execute}
    Run Keyword If    '${input_bh_khachtt}' == '0'    Validate history in customer if order is not paid    ${input_ma_kh}    ${order_code}
    ...    ELSE    Validate history and debt in customer if order is paid    ${input_ma_kh}    ${order_code}    ${actual_khachtt}    ${result_nohientai}
    Run Keyword If    '${input_bh_khachtt}' == '0'    Validate So quy info if Order is not paid    ${order_code}
    ...    ELSE    Validate So quy info if Order is paid    ${get_ma_phieutt_in_dh}    ${actual_khachtt}
    Delete order frm Order code    ${order_code}
    Toggle status of promotion    ${input_khuyemmai}    0
