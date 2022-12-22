*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    ${headless_browser}
Test Setup        Before Test Ban Hang with other user    tester    123
Test Teardown     After Test
Resource          ../../../../core/Ban_Hang/banhang_action.robot
Resource          ../../../../core/Ban_Hang/banhang_getandcompute.robot
Resource          ../../../../core/share/toast_message.robot
Resource          ../../../../core/share/imei.robot
Resource          ../../../../core/Ban_Hang/banhang_navigation.robot
Resource          ../../../../core/API/api_danhmuc_hanghoa.robot
Resource          ../../../../core/API/api_khachhang.robot
Resource          ../../../../core/API/api_hoadon_banhang.robot
Resource          ../../../../core/API/api_soquy.robot
Resource          ../../../../core/So_Quy/so_quy_list_action.robot
Resource          ../../../../config/env_product/envi.robot
Resource          ../../../../core/share/list_dictionary.robot

*** Variables ***
&{list_product3}    QDKM01=3
&{list_product4}    DVTKM04=3
&{list_give2}    HTKM04=1
@{list_discount}    2000000
@{discount_type}   changeup

*** Test Cases ***    Product and num list    Customer    Payment    Promotion Code       User name
KM HH giam gia SP theo user
                      [Tags]                   EBPVKM
                      [Template]               ebkmpv3
                      ${list_product3}        CTKH074       all      KM019                tester

KM HH va HD hinh thuc giam gia SP khong all filter
                      [Tags]                   EBPVKM
                      [Template]               ebkmpv4
                      ${list_product4}    10                   CTKH076       0        KM021      ${list_give2}        ${list_discount}     ${discount_type}    Nhánh A     tester       Nhóm khách VIP

*** Keywords ***
ebkmpv3
    [Arguments]    ${dict_product_num}    ${input_ma_kh}    ${input_bh_khachtt}    ${input_khuyenmai}    ${input_username}
    [Timeout]
    ## Get info ton cuoi, cong no khach hang
    Toggle status of promotion and not for all user   ${input_khuyenmai}    1    ${input_username}    KM hàng
    ${num_sale_product}    ${num_promo_product}    ${product_price}    ${discount}    ${discount_ratio}    ${name}    Get Number of sale product - promo product - promo value and name
    ...    ${input_khuyenmai}
    ${list_product}    Get Dictionary Keys    ${dict_product_num}
    ${list_nums}    Get Dictionary Values    ${dict_product_num}
    ${get_no_bf_execute}    ${get_tongban_bf_execute}    ${get_tongban_tru_trahang_bf_execute}    ${get_customer_name}    Get Customer Info from API    ${input_ma_kh}
    ${total_sale_number}    Sum values in list    ${list_nums}
    ${list_result_totalsale}    ${list_result_onhand_af_ex}    Run Keyword If    ${discount} != 0 and ${discount_ratio} ==0    Get list of total sale - result onhand in case discount product    ${list_product}    ${list_nums}
    ...    ${discount}
    ...    ELSE IF    ${discount} == 0 and ${discount_ratio} != 0    Get list of total sale - result onhand in case discount product    ${list_product}    ${list_nums}    ${discount_ratio}
    ...    ELSE IF    ${total_sale_number} < ${num_sale_product}    Get list of total sale - result onhand with one discount    ${list_product}    ${list_nums}
    ...    ELSE    Get list of total sale - result onhand in case promotion    ${list_product}    ${list_nums}    ${product_price}    ${num_sale_product}
    Reload Page
    #Compute
    ${result_tongtienhang}    Sum values in list    ${list_result_totalsale}
    ${actual_khachtt}    Set Variable If    '${input_bh_khachtt}' == 'all'    ${result_tongtienhang}    ${input_bh_khachtt}
    #create invoice
    ${lastest_num}    Set Variable    0
    Wait Until Keyword Succeeds    3 times    8 s    Input Khach Hang    ${input_ma_kh}
    : FOR    ${item_product}    ${item_num}    IN ZIP    ${list_product}    ${list_nums}
    \    ${lastest_num}    Input product-num in BH form    ${item_product}    ${item_num}    ${lastest_num}
    Run Keyword If    ${total_sale_number} >= ${num_sale_product}    Wait Until Keyword Succeeds    3 times    8 s    Select promotion on each product line    ${name}
    ...    ELSE    Log    kmk
    Run Keyword If    '${input_bh_khachtt}' != 'all'    Input payment info    ${input_bh_khachtt}    ${result_tongtienhang}    ELSE    Log    abc
    Click Element JS    ${button_bh_thanhtoan}
    Invoice message success validation
    ${invoice_code}    Get saved code after execute
    #get values
    Sleep    20 s    wait for response to API
    #assert values in Hoa don
    ${get_ma_kh_by_hd}    ${get_tong_tien_hang}    ${get_khachtt_af_execute}    ${get_trangthai}    ${get_ghichu_in_hd_af_execute}
    ...    Get invoice info have note by invoice code    ${invoice_code}
    Should Be Equal As Numbers    ${get_tong_tien_hang}    ${result_tongtienhang}
    Should Be Equal As Numbers    ${get_khachtt_af_execute}    ${actual_khachtt}
    Should Be Equal As Strings    ${get_ma_kh_by_hd}    ${input_ma_kh}
    Should Be Equal As Strings    ${get_trangthai}    Hoàn thành
    #assert value product in invoice
    Assert list of Onhand after execute    ${list_product}     ${list_result_onhand_af_ex}
    #Assert values in product give
    Delete invoice by invoice code    ${invoice_code}
    Toggle status of promotion and not for all user   ${input_khuyenmai}    0    ${input_username}    KM hàng

ebkmpv4
    [Arguments]    ${dict_product_nums}  ${input_gghd}    ${input_ma_kh}    ${input_khtt}   ${input_khuyenmai}    ${list_promo_product}
    ...   ${list_ggsp}   ${list_discount_type}    ${input_ten_branch}    ${input_ten_user}    ${input_ten_group_kh}
    Set Selenium Speed    0.5s
    Toggle status of promotion and not for all filter   ${input_khuyenmai}    1    ${input_ten_branch}    ${input_ten_user}    ${input_ten_group_kh}    KM Hàng mua     KM Hàng tặng
    ${invoice_value}    ${received_value}    ${discount}    ${discount_ratio}    ${name}    Get Invoice value - Received value - Discounts - Promotion Name from Promotion Code    ${input_khuyenmai}
    #get info product, customer
    ${list_product}    Get Dictionary Keys    ${dict_product_nums}
    ${list_nums}    Get Dictionary Values    ${dict_product_nums}
    ${list_product_promo}    Get Dictionary Keys    ${list_promo_product}
    ${list_nums_promo}    Get Dictionary Values    ${list_promo_product}
    ##get value
    ${result_list_toncuoi}    Create List
    ${result_list_thanhtien}    Create List
    ${result_list_newprice}    Create List
    ${list_giatri_quydoi}    Get list gia tri quy doi frm product API    ${list_product}
    ${get_list_product_type}    ${list_tonkho_service}    Get list product type and ending stock of service with other branch    ${list_product}    ${input_ten_branch}
    ${get_list_baseprice}    ${list_order_summary}    Get list of baseprice and order summary by product code and branch id    ${list_product}    ${input_ten_branch}
    ${list_onhand}    Get list onhand with other branch    ${list_product}    ${input_ten_branch}
    : FOR    ${item_product}    ${get_soluong_in_dh}    ${get_ton_bf_execute}    ${get_toncuoi_dv_execute}    ${giatri_quydoi}
    ...    ${get_product_type}    ${get_giaban_bf_execute}    ${input_ggsp}   ${discount_type}    IN ZIP    ${list_product}    ${list_nums}
    ...    ${list_onhand}    ${list_tonkho_service}    ${list_giatri_quydoi}    ${get_list_product_type}    ${get_list_baseprice}    ${list_ggsp}    ${list_discount_type}
    \    ${result_toncuoi}    Run Keyword If    '${giatri_quydoi}' == '1'    Computation and get list ending stock    ${get_ton_bf_execute}    ${get_toncuoi_dv_execute}
    \    ...    ${get_soluong_in_dh}    ${get_product_type}
    \    ...    ELSE    Computation and get list ending stock for unit product    ${item_product}    ${giatri_quydoi}    ${get_soluong_in_dh}
    \    ${ressult_giamoi}    Run Keyword If    '${discount_type}' == 'dis'    Price after % discount product    ${get_giaban_bf_execute}    ${input_ggsp}
    \    ...    ELSE IF    '${discount_type}' == 'disvnd'    Minus and round 2    ${get_giaban_bf_execute}    ${input_ggsp}
    \    ...    ELSE IF    '${discount_type}' == 'changeup' or '${discount_type}' == 'changedown'   Set Variable   ${input_ggsp}
    \    ...     ELSE    Set Variable    ${get_giaban_bf_execute}
    \    ${result_thanhtien}    Multiplication and round    ${ressult_giamoi}    ${get_soluong_in_dh}
    \    Append To List    ${result_list_toncuoi}    ${result_toncuoi}
    \    Append To List    ${result_list_thanhtien}    ${result_thanhtien}
    \    Append To List    ${result_list_newprice}    ${ressult_giamoi}
    #compute product promo
    ${get_list_baseprice_promo}   Get list of Baseprice by Product Code    ${list_product_promo}
    ${list_onhand_promo}    Get list onhand with other branch    ${list_product_promo}    ${input_ten_branch}
    ${result_thanhtien_promo}   Create List
    ${list_result_toncuoi_promo}   Create List
    :FOR    ${item_giaban}    ${item_nums}   ${item_onhand}   IN ZIP    ${get_list_baseprice_promo}    ${list_nums_promo}    ${list_onhand_promo}
    \     ${giaban}   Minus     ${item_giaban}    ${discount}
    \     ${thanhtien}    Multiplication and round     ${giaban}    ${item_nums}
    \     ${result_tonkho}    Minus   ${item_onhand}    ${item_nums}
    \     Append To List     ${result_thanhtien_promo}     ${thanhtien}
    \     Append To List     ${list_result_toncuoi_promo}     ${result_tonkho}
    #compute TTH with product
    Switch branch in sale form    ${input_ten_branch}
    ${result_tongtienhang}    Sum values in list    ${result_list_thanhtien}
    ${result_tongtienhang_promo}    Sum values in list    ${result_thanhtien_promo}
    ${result_tongtienhang}    Sum    ${result_tongtienhang}    ${result_tongtienhang_promo}
    ${result_gghd}    Run Keyword If    0 < ${input_gghd} < 100    Convert % discount to VND and round    ${result_tongtienhang}    ${input_gghd}
    ...    ELSE    Set Variable    ${input_gghd}
    ${result_TTH_tru_gghd}    Run Keyword If    0 < ${input_gghd} < 100    Price after % discount invoice    ${result_tongtienhang}    ${input_gghd}
    ...    ELSE    Minus and replace floating point    ${result_tongtienhang}    ${input_gghd}
    ${actual_khtt}    Set Variable If    '${input_khtt}' == 'all'    ${result_TTH_tru_gghd}    ${input_khtt}
    #create invoice from order
    Log      Input data into BH form
    ${lastest_num}    Set Variable    0
    : FOR    ${item_product}    ${item_nums}    ${item_ggsp}    ${item_newprice}   ${item_discount_type}    IN ZIP    ${list_product}
    ...    ${list_nums}    ${list_ggsp}    ${result_list_newprice}    ${list_discount_type}
    \    ${lastest_num}    Input product-num in BH form    ${item_product}    ${item_nums}      ${lastest_num}
    \    Run keyword if    '${item_discount_type}' == 'dis'    Wait Until Keyword Succeeds    3 times    5 s    Input % discount for product    ${item_ggsp}    ${item_newprice}
    \    ...    ELSE IF    '${item_discount_type}' == 'disvnd'    Wait Until Keyword Succeeds    3 times    5 s    Input vnd discount for product    ${item_ggsp}    ${item_newprice}
    \    ...    ELSE IF     '${item_discount_type}' == 'changeup' or '${item_discount_type}' == 'changedown'  Wait Until Keyword Succeeds    3 times    5 s    Input new price of product    ${item_ggsp}
    \    ...    ELSE       Log        ignore
    Wait Until Keyword Succeeds    3 times    8 s    Input Khach Hang    ${input_ma_kh}
    Run Keyword If    ${result_tongtienhang} > ${invoice_value}    Wait Until Keyword Succeeds    3 times    8 s    Select promotion and giveaway product by search product    ${name}
    ...    ${list_product_promo}    ${list_nums_promo}    ELSE    Element Should Not Be Visible    ${icon_promo_sale}
    Run Keyword If    0 < ${input_gghd} < 100    Wait Until Keyword Succeeds    3 times    8 s    Input % discount invoice    ${input_gghd}
    ...    ${result_gghd}    ELSE IF    ${input_gghd} > 100    Input VND discount invoice    ${input_gghd}
    ...    ELSE    Log    Ignore discount
    Run Keyword If    '${input_khtt}' != 'all'    Input payment info    ${input_khtt}    ${result_TTH_tru_gghd}    ELSE    Log    abc
    Click Element JS    ${button_bh_thanhtoan}
    Invoice message success validation
    ${invoice_code}    Get saved code after execute
    #get value
    Sleep    20s    wait for response to API
    #assert value product in invoice
    : FOR    ${ma_hh}    ${result_toncuoi}    ${item_soluong}    IN ZIP    ${list_product}
    ...    ${result_list_toncuoi}    ${list_nums}
    \     ${soluong_in_thekho}    ${toncuoi_in_thekho}    Get Stock Card info frm API by Branch and User    ${invoice_code}    ${ma_hh}    ${input_ten_branch}    ${input_ten_user}
    \     Should Be Equal As Numbers    ${toncuoi_in_thekho}    ${result_toncuoi}
    \     Should Be Equal As Numbers    ${soluong_in_thekho}    ${item_soluong}
    #assert value product promo in invoice
    : FOR    ${ma_hh_promo}    ${result_toncuoi_promo}    ${item_soluong_promo}    IN ZIP    ${list_product_promo}
    ...    ${list_result_toncuoi_promo}    ${list_nums_promo}
    \     ${soluong_in_thekho_promo}    ${toncuoi_in_thekho_promo}    Get Stock Card info frm API by Branch and User    ${invoice_code}    ${ma_hh_promo}    ${input_ten_branch}    ${input_ten_user}
    \     Should Be Equal As Numbers    ${toncuoi_in_thekho_promo}    ${result_toncuoi_promo}
    \     Should Be Equal As Numbers    ${soluong_in_thekho_promo}    ${item_soluong_promo}
    #assert value invoice
    ${get_ma_kh_by_hd}    ${get_tong_tien_hang}    ${get_khach_tt}    ${get_giamgia_hd}    ${get_khachcantra}    ${get_trangthai}    Get invoice info with other branch and user    ${invoice_code}
    ...    ${input_ten_branch}    ${input_ten_user}
    Should Be Equal As Numbers    ${get_tong_tien_hang}    ${result_tongtienhang}
    Should Be Equal As Numbers    ${get_khachcantra}    ${result_TTH_tru_gghd}
    Should Be Equal As Numbers    ${get_khach_tt}    ${actual_khtt}
    Should Be Equal As Strings    ${get_ma_kh_by_hd}    ${input_ma_kh}
    Should Be Equal As Numbers    ${get_giamgia_hd}    ${result_gghd}
    Should Be Equal As Strings    ${get_trangthai}    Hoàn thành
    ##deactive promo
    Delete invoice by invoice code and other branch    ${invoice_code}   ${input_ten_branch}
    Toggle status of promotion and not for all filter   ${input_khuyenmai}    0    ${input_ten_branch}    ${input_ten_user}    ${input_ten_group_kh}    KM Hàng mua     KM Hàng tặng
