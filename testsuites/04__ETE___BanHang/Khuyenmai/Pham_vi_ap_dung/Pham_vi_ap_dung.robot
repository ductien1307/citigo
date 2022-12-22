*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}      ${headless_browser}
Test Setup
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
&{list_product1}    HTKM02=12
&{list_product2}    DVKM02=10
&{list_give1}    SIKM04=1
@{list_discount}    5
@{discount_type}     dis
*** Test Cases ***    Product and num list    Lisst Product Discount      List discount type     Discount    Customer    Payment    Promotion Code       Tên chi nhánh
KM HD va giam gia HD theo chi nhanh                 [Tags]                  EBPVKM
                      [Template]              ebkmpv1
                      ${list_product1}    ${list_discount}      ${discount_type}             10          CTKH073     50000      KM018                Nhánh A                #giam gia HD %

KM HH va HD hinh thuc tang hang theo nhom KH
                      [Tags]                   EBPVKM
                      [Template]               ebkmpv2
                      ${list_product2}    50000          CTKH076         500000        KM020      ${list_give1}   Nhóm khách VIP

*** Keywords ***
ebkmpv1
    [Arguments]    ${dict_product_num}    ${list_ggsp}     ${list_discount_type}   ${input_invoice_discount}    ${input_ma_kh}    ${input_bh_khachtt}
    ...    ${input_khuyenmai}    ${input_ten_branch}
    ## Get info ton cuoi, cong no khach hang
    Toggle status of promotion and not for all branch    ${input_khuyenmai}    1    ${input_ten_branch}
    ${list_product}    Get Dictionary Keys    ${dict_product_num}
    ${list_nums}    Get Dictionary Values    ${dict_product_num}
    ${invoice_value}    ${discount}    ${discount_ratio}    ${name}    Get Invoice value - Discounts - Promotion Name from Promotion Code    ${input_khuyenmai}
    ${get_no_bf_execute}    ${get_tongban_bf_execute}    ${get_tongban_tru_trahang_bf_execute}    Get Customer Debt from API    ${input_ma_kh}
    ${list_result_thanhtien}    Create List
    ${list_result_giamoi}    Create List
    ${list_result_onhand_af_ex}    Create List
    ${get_list_baseprice}    ${list_order_summary}    Get list of baseprice and order summary by product code and branch id    ${list_product}    ${input_ten_branch}
    ${get_list_onhand_bf_purchase}    Get list onhand with other branch    ${list_product}    ${input_ten_branch}
    : FOR    ${item_ma_hh}    ${nums}    ${input_ggsp}    ${get_toncuoi}    ${get_giaban_bf_execute}    ${discount_type}    IN ZIP    ${list_product}
    ...     ${list_nums}    ${list_ggsp}    ${get_list_onhand_bf_purchase}    ${get_list_baseprice}   ${list_discount_type}
    \    ${result_toncuoi}    Minus    ${get_toncuoi}    ${nums}
    \    ${result_giamoi}    Run Keyword If    '${discount_type}' == 'dis'    Price after % discount product    ${get_giaban_bf_execute}    ${input_ggsp}
    \    ...    ELSE IF    '${discount_type}' == 'disvnd'    Minus and round 2    ${get_giaban_bf_execute}    ${input_ggsp}
    \    ...    ELSE IF    '${discount_type}' == 'changeup' or '${discount_type}' == 'changedown'   Set Variable   ${input_ggsp}
    \    ...    ELSE     Set Variable    ${get_giaban_bf_execute}
    \    ${result_thanhtien}    Multiplication and round    ${result_giamoi}    ${nums}
    \    Append To List    ${list_result_thanhtien}    ${result_thanhtien}
    \    Append To List    ${list_result_onhand_af_ex}    ${result_toncuoi}
    \    Append To List    ${list_result_giamoi}    ${result_giamoi}
    #compute
    ${result_tongtienhang}    Sum values in list    ${list_result_thanhtien}
    ${result_discount_invoice}    Run Keyword If    0 < ${input_invoice_discount} < 100    Convert % discount to VND and round    ${result_tongtienhang}    ${input_invoice_discount}
    ...    ELSE    Set Variable    ${input_invoice_discount}
    ${result_discount_invoice_by_vnd}    Convert % discount to VND and round    ${result_tongtienhang}    ${input_invoice_discount}
    ${result_discount_ratio_by_invoice_promo}    Convert % discount to VND and round    ${result_tongtienhang}    ${discount_ratio}
    ${actual_promo_value}    Set Variable If    ${discount} == 0    ${result_discount_ratio_by_invoice_promo}    ${discount}
    ${final_discount}=    Run Keyword If    ${result_tongtienhang} > ${invoice_value}    Sum    ${actual_promo_value}    ${result_discount_invoice_by_vnd}
    ...    ELSE    Set Variable    ${result_discount_invoice_by_vnd}
    ${result_khachcantra}    Minus and replace floating point    ${result_tongtienhang}    ${final_discount}
    ${actual_khachtt}    Set Variable If    '${input_bh_khachtt}' == 'all'    ${result_khachcantra}    ${input_bh_khachtt}
    ${result_no_hoadon}    Minus    ${result_khachcantra}    ${actual_khachtt}
    ${result_nohientai}    sum    ${result_no_hoadon}    ${get_no_bf_execute}
    ${result_tongban}    Sum    ${result_khachcantra}    ${get_tongban_bf_execute}
    #create order
    Log      Input data into BH form
    Wait Until Keyword Succeeds    3 times    5 s    Before Test Ban Hang
    Switch branch in sale form    ${input_ten_branch}
    ${lastest_num}    Set Variable    0
    : FOR    ${item_product}    ${item_nums}    ${item_ggsp}    ${item_newprice}   ${item_discount_type}    IN ZIP    ${list_product}
    ...    ${list_nums}    ${list_ggsp}    ${list_result_giamoi}    ${list_discount_type}
    \    ${lastest_num}    Input product-num in BH form    ${item_product}    ${item_nums}      ${lastest_num}
    \    Run keyword if    '${item_discount_type}' == 'dis'    Wait Until Keyword Succeeds    3 times    5 s    Input % discount for product    ${item_ggsp}    ${item_newprice}
    \    ...    ELSE IF    '${item_discount_type}' == 'disvnd'    Wait Until Keyword Succeeds    3 times    5 s    Input vnd discount for product    ${item_ggsp}    ${item_newprice}
    \    ...    ELSE IF     '${item_discount_type}' == 'changeup' or '${item_discount_type}' == 'changedown'  Wait Until Keyword Succeeds    3 times    5 s    Input new price of product    ${item_ggsp}
    \    ...    ELSE       Log        ignore
    Wait Until Keyword Succeeds    3 times    8 s    Input Khach Hang    ${input_ma_kh}
    Run Keyword If    ${result_tongtienhang} > ${invoice_value}    Wait Until Keyword Succeeds    3 times    8 s    Select promotion    ${name}
    ...    ELSE    Element Should Not Be Visible    ${icon_promo_sale}
    Run Keyword If    0 < ${input_invoice_discount} < 100    Wait Until Keyword Succeeds    3 times    8 s    Input % discount invoice    ${input_invoice_discount}
    ...    ${final_discount}    ELSE IF    ${input_invoice_discount} > 100    Input VND discount invoice    ${input_invoice_discount}
    ...    ELSE    Log    Ignore discount
    Run Keyword If    '${input_bh_khachtt}' != 'all'    Input payment info    ${input_bh_khachtt}    ${result_khachcantra}
    ...    ELSE    Log    abc
    Click Element JS    ${button_bh_thanhtoan}
    Invoice message success validation
    ${invoice_code}    Get saved code after execute
    #get values
    Sleep    20 s    wait for response to API
    #assert values in Hoa don
    ${get_ma_kh_by_hd}    ${get_tong_tien_hang}    ${get_khach_tt}    ${get_giamgia_hd}    ${get_khachcantra}    ${get_trangthai}    Get invoice info with other branch and user    ${invoice_code}
    ...    ${input_ten_branch}    ${USER_NAME}
    Should Be Equal As Numbers    ${get_tong_tien_hang}    ${result_tongtienhang}
    Should Be Equal As Numbers    ${get_khachcantra}    ${result_khachcantra}
    Should Be Equal As Numbers    ${get_khach_tt}    ${actual_khachtt}
    Should Be Equal As Strings    ${get_ma_kh_by_hd}    ${input_ma_kh}
    Should Be Equal As Numbers    ${get_giamgia_hd}    ${final_discount}
    Should Be Equal As Strings    ${get_trangthai}    Hoàn thành
    #Assert values in product list and stock card
    : FOR    ${ma_hh}    ${result_toncuoi}    ${item_soluong}    IN ZIP    ${list_product}
    ...    ${list_result_onhand_af_ex}    ${list_nums}
    \     ${soluong_in_thekho}    ${toncuoi_in_thekho}    Get Stock Card info frm API by Branch and User    ${invoice_code}    ${ma_hh}    ${input_ten_branch}    ${USER_NAME}
    \     Should Be Equal As Numbers    ${toncuoi_in_thekho}    ${result_toncuoi}
    \     Should Be Equal As Numbers    ${soluong_in_thekho}    ${item_soluong}
    #assert value in tab cong no khach hang
    ${get_maphieu_soquy}    Get Ma Phieu Thu in So quy    ${invoice_code}
    Run Keyword If    '${input_bh_khachtt}' == '0'    Validate status in Tab No can thu tu khach if Invoice is not paid until success    ${input_ma_kh}    ${invoice_code}
    ...    ELSE    Validate status in Tab No can thu tu khach if Invoice is paid until success    ${input_ma_kh}    ${get_maphieu_soquy}    ${invoice_code}
    #assert values in Khach hang and So quy
    ${get_no_af_purchase}    ${get_tongban_af_purchase}    ${get_tongban_tru_trahang_af_purchase}    Get Customer Debt from API after purchase    ${input_ma_kh}    ${invoice_code}    ${actual_khachtt}
    Should Be Equal As Numbers    ${result_nohientai}    ${get_no_af_purchase}
    Should Be Equal As Numbers    ${result_tongban}    ${get_tongban_af_purchase}
    ${get_id_branch}    Get BranchID by BranchName    ${input_ten_branch}
    ${get_endpoint_by_branch}    Format String    ${endpoint_tong_quy}    ${get_id_branch}
    ${get_resp}    Get Request and return body    ${get_endpoint_by_branch}
    ${jsonpath_giatri_hd}    Format String    $..Data[?(@.Code=="{0}")].Amount    ${get_maphieu_soquy}
    ${jsonpath_loaithuchi}    Format String    $..Data[?(@.Code=="{0}")].CashGroup     ${get_maphieu_soquy}
    ${get_hd_giatri}    Get data from API    ${get_endpoint_by_branch}    ${jsonpath_giatri_hd}
    ${get_loaithutien}    Get data from response json    ${get_resp}    ${jsonpath_loaithuchi}
    ${get_khachtt}    Minus    0    ${actual_khachtt}
    ${result_khtt}    Set Variable If    '${get_loaithutien}' == 'Tiền trả khách'    ${get_khachtt}    ${actual_khachtt}
    Should Be Equal As Numbers    ${get_hd_giatri}    ${result_khtt}
    Delete invoice by invoice code and other branch    ${invoice_code}   ${input_ten_branch}
    Toggle status of promotion and not for all branch    ${input_khuyenmai}    0    ${input_ten_branch}

ebkmpv2
    [Arguments]    ${dict_product_num}    ${input_invoice_discount}    ${input_ma_kh}    ${input_bh_khachtt}    ${input_khuyenmai}   ${give}
    ...    ${input_ten_nhom_kh}
    [Timeout]
    ## Get info ton cuoi, cong no khach hang
    Toggle status of promotion and not for all customer    ${input_khuyenmai}    1    ${input_ten_nhom_kh}    Dịch vụ     Bánh nhập KM
    ${list_product}    Get Dictionary Keys    ${dict_product_num}
    ${list_nums}    Get Dictionary Values    ${dict_product_num}
    ${list_give_product}    Get Dictionary Keys    ${give}
    ${list_give_nums}    Get Dictionary Values    ${give}
    ${invoice_value}    ${received_value}    ${discount}    ${discount_ratio}    ${name}    Get Invoice value - Received value - Discounts - Promotion Name from Promotion Code    ${input_khuyenmai}
    Create list imei and other product    ${list_give_product}    ${list_give_nums}
    ${get_no_bf_execute}    ${get_tongban_bf_execute}    ${get_tongban_tru_trahang_bf_execute}    Get Customer Debt from API    ${input_ma_kh}
    ${list_result_ton_af_ex}        Get list of result onhand incase changing product price    ${list_product}    ${list_nums}
    ${list_result_ton_af_ex_give}        Get list of result onhand incase changing product price    ${list_give_product}    ${list_give_nums}
    ${list_result_totalsale}    Create list
    ${get_list_baseprice_bf_purchase}    Get list of Baseprice by Product Code    ${list_product}
    : FOR    ${item_baseprice}    ${item_num}    IN ZIP    ${get_list_baseprice_bf_purchase}    ${list_nums}
    \    ${result_totalsale}    Multiplication and round    ${item_num}    ${item_baseprice}
    \    Append to list    ${list_result_totalsale}    ${result_totalsale}
    #Compute
    ${result_tongtienhang}    Sum values in list    ${list_result_totalsale}
    ${result_khachcantra}    Minus and replace floating point    ${result_tongtienhang}    ${input_invoice_discount}
    ${actual_khachtt}    Set Variable If    '${input_bh_khachtt}' == 'all'    ${result_khachcantra}    ${input_bh_khachtt}
    #create invoice
    Log      Input data into BH form
    Wait Until Keyword Succeeds    3 times    5 s    Before Test Ban Hang
    ${lastest_num}    Set Variable    0
    : FOR    ${item_product}    ${item_nums}    IN ZIP    ${list_product}    ${list_nums}
    \    ${lastest_num}    Input product-num in BH form    ${item_product}    ${item_nums}      ${lastest_num}
    Wait Until Keyword Succeeds    3 times    8 s    Input Khach Hang    ${input_ma_kh}
    Run Keyword If    ${result_khachcantra} > ${invoice_value}    Wait Until Keyword Succeeds    3 times    8 s    Select promotion and giveaway product by search product    ${name}
    ...    ${list_give_product}    ${list_give_nums}    ELSE    Element Should Not Be Visible    ${icon_promo_sale}
    : FOR    ${item_product_give}    ${item_imei}    IN ZIP    ${list_give_product}    ${imei_inlist}
    \    Wait Until Keyword Succeeds    3 times    8 s    Input imei incase multi product to any form    ${item_product_give}    ${texbox_imei_search_multi_product}
    \    ...    ${item_serial_in_dropdown}    ${cell_imei_multi_product}    @{item_imei}
    Run Keyword If    0 < ${input_invoice_discount} < 100    Wait Until Keyword Succeeds    3 times    8 s    Input % discount invoice    ${input_invoice_discount}
    ...    ${final_discount}    ELSE IF    ${input_invoice_discount} > 100    Input VND discount invoice    ${input_invoice_discount}
    ...    ELSE    Log    Ignore discount
    Run Keyword If    '${input_bh_khachtt}' != 'all'    Input payment info    ${input_bh_khachtt}    ${result_khachcantra}    ELSE    Log    abc
    Click Element JS    ${button_bh_thanhtoan}
    Invoice message success validation
    ${invoice_code}    Get saved code after execute
    #get values
    Sleep    20 s    wait for response to API
    #assert values in Hoa don
    ${get_ma_kh_by_hd}    ${get_tong_tien_hang}    ${get_khachtt_af_execute}    ${get_gghd_af_execute}    ${get_khachcantra}    ${get_trangthai}    ${get_ghichu_in_hd_af_execute}
    ...    Get invoice info have note incase discount by invoice code    ${invoice_code}
    Should Be Equal As Numbers    ${get_tong_tien_hang}    ${result_tongtienhang}
    Should Be Equal As Numbers    ${get_khachcantra}    ${result_khachcantra}
    Should Be Equal As Numbers    ${get_khachtt_af_execute}    ${actual_khachtt}
    Should Be Equal As Strings    ${get_ma_kh_by_hd}    ${input_ma_kh}
    Should Be Equal As Numbers    ${get_gghd_af_execute}    ${input_invoice_discount}
    Should Be Equal As Strings    ${get_trangthai}    Hoàn thành
    #Assert values in product list and stock card
    #assert value product in invoice
    ${list_num_instockcard}    Change negative number to positive number and vice versa in List    ${list_nums}
    : FOR    ${ma_hh}    ${item_soluong}    IN ZIP    ${list_product}    ${list_num_instockcard}
    \     Assert values in Stock Card incase service product    ${invoice_code}    ${ma_hh}     ${item_soluong}
    #Assert values in product give
    Assert list of Onhand after execute    ${list_give_product}     ${list_result_ton_af_ex_give}
    #assert value in tab cong no khach hang
    ${get_maphieu_soquy}    Get Ma Phieu Thu in So quy    ${invoice_code}
    Run Keyword If    '${input_bh_khachtt}' == '0'    Validate status in Tab No can thu tu khach if Invoice is not paid until success    ${input_ma_kh}    ${invoice_code}
    ...    ELSE    Validate status in Tab No can thu tu khach if Invoice is paid until success    ${input_ma_kh}    ${get_maphieu_soquy}    ${invoice_code}
    Delete invoice by invoice code    ${invoice_code}
    Toggle status of promotion and not for all customer    ${input_khuyenmai}    1    ${input_ten_nhom_kh}    Dịch vụ     Bánh nhập KM
