*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    ${headless_browser}
Test Setup        Before Test Ban Hang
Test Teardown     After Test
Resource          ../../../../../core/API/api_thietlap.robot
Resource          ../../../../../core/API/api_dathang.robot
Resource          ../../../../../core/Ban_Hang/banhang_getandcompute.robot
Resource          ../../../../../core/Ban_Hang/banhang_page.robot
Resource          ../../../../../core/share/toast_message.robot
Resource          ../../../../../core/API/api_mhbh_dathang.robot
Resource          ../../../../../core/API/api_soquy.robot
Resource          ../../../../../core/API/api_danhmuc_hanghoa.robot
Resource          ../../../../../config/env_product/envi.robot

*** Variables ***
&{list_product_nums1}    HTKM01=3   SIKM01=2
&{list_product_nums2}    DVKM01=11   SIKM01=1
@{list_del_product}    SIKM01
&{list_give1}    SIKM03=1
@{list_discount}    10000    15
@{discount_type}   disvnd     dis
*** Test Cases ***    Product and num list    Product Discount      List discount type      Order Discount    Customer    Payment    Promotion Code       Tên chi nhánh
KM DH va giam gia dh theo chi nhanh                 [Tags]                  EDPVKM
                      [Template]              kmpv1
                      ${list_product_nums1}        ${list_discount}      ${discount_type}           15             CTKH070     50000      KM018                Nhánh A                #giam gia HD %

KM HH va HD hinh thuc tang hang theo nhom KH
                      [Tags]                   EDPVKM
                      [Template]               kmpv2
                      ${list_product_nums2}    34000          CTKH072         300000      100000              KM020      ${list_give1}        ${list_del_product}   Nhóm khách VIP

*** Keywords ***
kmpv1
    [Arguments]    ${dict_product_num}    ${list_ggsp}     ${list_discount_type}   ${input_ggdh}    ${input_ma_kh}    ${input_bh_khachtt}
    ...    ${input_khuyenmai}    ${input_ten_branch}
    ## Get info ton cuoi, cong no khach hang
    Switch branch in sale form    ${input_ten_branch}
    Toggle status of promotion and not for all branch    ${input_khuyenmai}    1    ${input_ten_branch}
    ${list_product}    Get Dictionary Keys    ${dict_product_num}
    ${list_nums}    Get Dictionary Values    ${dict_product_num}
    ${invoice_value}    ${discount}    ${discount_ratio}    ${name}    Get Invoice value - Discounts - Promotion Name from Promotion Code    ${input_khuyenmai}
    ${get_no_bf_execute}    ${get_tongban_bf_execute}    ${get_tongban_tru_trahang_bf_execute}    Get Customer Debt from API    ${input_ma_kh}
    ${list_result_thanhtien}    Create List
    ${list_result_order_summary}    Create List
    ${list_result_giamoi}    Create List
    ${get_list_baseprice}    ${list_order_summary}    Get list of baseprice and order summary by product code and branch id    ${list_product}    ${input_ten_branch}
    : FOR    ${item_ma_hh}    ${nums}    ${input_ggsp}    ${get_tong_dh}    ${get_giaban_bf_execute}    ${discount_type}    IN ZIP    ${list_product}
    ...     ${list_nums}    ${list_ggsp}    ${list_order_summary}    ${get_list_baseprice}   ${list_discount_type}
    \    ${result_tongso_dh}    Sum    ${get_tong_dh}    ${nums}
    \    ${result_giamoi}    Run Keyword If    '${discount_type}' == 'dis'    Price after % discount product    ${get_giaban_bf_execute}    ${input_ggsp}
    \    ...    ELSE IF    '${discount_type}' == 'disvnd'    Minus and round 2    ${get_giaban_bf_execute}    ${input_ggsp}
    \    ...    ELSE IF    '${discount_type}' == 'changeup' or '${discount_type}' == 'changedown'   Set Variable   ${input_ggsp}
    \    ...    ELSE     Set Variable    ${get_giaban_bf_execute}
    \    ${result_thanhtien}    Multiplication and round    ${result_giamoi}    ${nums}
    \    Append To List    ${list_result_thanhtien}    ${result_thanhtien}
    \    Append To List    ${list_result_order_summary}    ${result_tongso_dh}
    \    Append To List    ${list_result_giamoi}    ${result_giamoi}
    # Input data into BH form
    Wait Until Keyword Succeeds    3 times    5 s    Click Element JS    ${tab_dathang}
    ${lastest_num}    Set Variable    0
    : FOR    ${item_product}    ${item_nums}    ${item_ggsp}    ${item_price}   ${item_discount_type}    IN ZIP    ${list_product}
    ...    ${list_nums}    ${list_ggsp}    ${list_result_giamoi}    ${list_discount_type}
    \    ${lastest_num}    Wait Until Keyword Succeeds    3 times    5 s    Input product-num in sale form    ${item_product}    ${item_nums}
    \    ...    ${lastest_num}    ${cell_tongsoluong_dh}
    \    Run keyword if    '${item_discount_type}' == 'dis'     Wait Until Keyword Succeeds    3 times    5 s    Input % discount for multi product    ${item_product}    ${item_ggsp}
    \    ...    ${item_price}    ELSE IF    '${item_discount_type}' == 'disvnd'    Input VND discount for multi product    ${item_product}    ${item_ggsp}    ${item_price}
    \    ...     ELSE IF  '${item_discount_type}' == 'changeup' or '${item_discount_type}' == 'changedown'    Wait Until Keyword Succeeds    3 times    5 s    Input newprice for multi product    ${item_product}    ${item_ggsp}
    \    ...    ELSE    Log    Ignore input
    #compute
    ${result_tongtienhang}    Sum values in list    ${list_result_thanhtien}
    ${result_af_invoice_discount}    Price after % discount invoice    ${result_tongtienhang}    ${input_ggdh}
    ${result_discount_invoice_by_vnd}    Convert % discount to VND and round    ${result_tongtienhang}    ${input_ggdh}
    ${result_discount_ratio_by_invoice_promo}    Convert % discount to VND and round    ${result_tongtienhang}    ${discount_ratio}
    ${actual_promo_value}    Set Variable If    ${discount} == 0    ${result_discount_ratio_by_invoice_promo}    ${discount}
    ${final_discount}=    Run Keyword If    ${result_tongtienhang} > ${invoice_value}    Sum    ${actual_promo_value}    ${result_discount_invoice_by_vnd}
    ...    ELSE    Set Variable    ${result_discount_invoice_by_vnd}
    ${result_khachcantra}    Minus    ${result_tongtienhang}    ${final_discount}
    ${result_khachcantra}    Replace floating point    ${result_khachcantra}
    ${actual_khachtt}    Set Variable If    '${input_bh_khachtt}' == 'all'    ${result_khachcantra}    ${input_bh_khachtt}
    ${result_nohientai}    Minus    ${get_no_bf_execute}    ${actual_khachtt}
    ${result_tongban}    Sum    ${result_khachcantra}    ${get_tongban_bf_execute}
    #create order
    Input Khach Hang    ${input_ma_kh}
    Run Keyword If    ${result_tongtienhang} > ${invoice_value}    Wait Until Keyword Succeeds    3 times    8 s    Select order promotion    ${name}
    ...    ELSE    Element Should Not Be Visible    ${icon_promo_sale}
    Wait Until Keyword Succeeds    3 times    8 s    Input % discount order    ${input_ggdh}    ${final_discount}
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
    Should Be Equal As Numbers    ${get_giamgia_in_dh_af_execute}    ${final_discount}
    Should Be Equal As Numbers    ${get_tongcong_in_dh_af_execute}    ${result_khachcantra}
    #assert value product
    ${list_order_summary_af_execute}    Get list of order summary by product code and branch id    ${list_product}    ${input_ten_branch}
    : FOR    ${result_tong_dh}    ${order_summary_af_execute}    IN ZIP    ${list_result_order_summary}    ${list_order_summary_af_execute}
    \    Should Be Equal As Numbers    ${order_summary_af_execute}    ${result_tong_dh}
    #assert value khach hang and so quy
    ${get_no_af_execute}    ${get_tongban_af_execute}    ${get_tongban_tru_trahang_af_execute}    Get Customer Debt from API    ${input_ma_kh}
    ${get_ma_phieutt_in_dh}    Get ma phieu thanh toan dat hang frm API    ${order_code}
    Should Be Equal As Numbers    ${get_no_af_execute}    ${result_nohientai}
    Should Be Equal As Numbers    ${get_tongban_af_execute}    ${get_tongban_bf_execute}
    Should Be Equal As Numbers    ${get_tongban_tru_trahang_af_execute}    ${get_tongban_tru_trahang_bf_execute}
    Run Keyword If    '${input_bh_khachtt}' == '0'    Validate history in customer if order is not paid    ${input_ma_kh}    ${order_code}
    ...    ELSE    Validate history and debt in customer if order is paid    ${input_ma_kh}    ${order_code}    ${actual_khachtt}    ${result_nohientai}
    ${get_id_branch}    Get BranchID by BranchName    ${input_ten_branch}
    ${get_endpoint_by_branch}    Format String    ${endpoint_tong_quy}    ${get_id_branch}
    ${jsonpath_giatri_hd}    Format String    $..Data[?(@.Code=="{0}")].Amount    ${get_ma_phieutt_in_dh}
    ${get_hd_giatri}    Get data from API    ${get_endpoint_by_branch}    ${jsonpath_giatri_hd}
    Should Be Equal As Numbers    ${get_hd_giatri}    ${actual_khachtt}
    Delete order frm Order code    ${order_code}
    Toggle status of promotion and not for all branch    ${input_khuyenmai}    0    ${input_ten_branch}

kmpv2
    [Arguments]    ${dict_product_num}    ${input_discount_inv}    ${input_ma_kh}    ${input_bh_khachtt}    ${input_khtt_create_order}    ${input_khuyenmai}
    ...   ${give}    ${list_product_del}    ${input_ten_nhom_kh}
    [Timeout]
    ## Get info ton cuoi, cong no khach hang
    Toggle status of promotion and not for all customer    ${input_khuyenmai}    1    ${input_ten_nhom_kh}    Dịch vụ     Bánh nhập KM
    ${list_product}    Get Dictionary Keys    ${dict_product_num}
    ${list_nums}    Get Dictionary Values    ${dict_product_num}
    ${list_give_product}    Get Dictionary Keys    ${give}
    ${list_give_nums}    Get Dictionary Values    ${give}
    ${order_code}     Add new order with multi products    ${input_ma_kh}    ${dict_product_num}    ${input_khtt_create_order}
    ${invoice_value}    ${received_value}    ${discount}    ${discount_ratio}    ${name}    Get Invoice value - Received value - Discounts - Promotion Name from Promotion Code    ${input_khuyenmai}
    Create list imei and other product    ${list_give_product}    ${list_give_nums}
    ${get_list_hh_in_dh_bf_execute}    ${get_ghichu_bf_execute}    Get ghi chu and list product frm API    ${order_code}
    ${list_result_tongdh_delete}    Get list order summary frm product API    ${list_product}
    ${get_no_bf_execute}    ${get_tongban_bf_execute}    ${get_tongban_tru_trahang_bf_execute}    Get Customer Debt from API    ${input_ma_kh}
    ${get_khachdatra_in_dh_bf_execute}    ${get_tongtienhang_in_dh_bf_execute}    Get paid value frm API    ${order_code}
    #get order summary and sub total of products
    : FOR    ${ma_hh}    IN    @{list_product_del}
    \    Remove Values From List    ${get_list_hh_in_dh_bf_execute}    ${ma_hh}
    Log    ${get_list_hh_in_dh_bf_execute}
    ${get_list_nums_in_dh}    Get list quantity by order code    ${order_code}    ${get_list_hh_in_dh_bf_execute}
    ${list_result_tongdh}    ${result_list_toncuoi}    ${result_list_thanhtien}    Get list order summary - total sale - ending stocks frm API    ${order_code}    ${get_list_hh_in_dh_bf_execute}
    #create lists
    Reload Page
    #Compute
    ${result_tongtienhang}    Sum values in list    ${result_list_thanhtien}
    ${result_khachcantra}    Minus and replace floating point    ${result_tongtienhang}    ${input_discount_inv}
    ${result_khachcanthanhtoan}    Minus and replace floating point    ${result_khachcantra}        ${get_khachdatra_in_dh_bf_execute}
    ${actual_khachtt}    Set Variable If    '${input_bh_khachtt}' == 'all'    ${result_khachcantra}    ${input_bh_khachtt}
    ${result_khachdatra}    Sum    ${get_khachdatra_in_dh_bf_execute}    ${actual_khachtt}
    ${get_list_status}    Get list imei status thr API    ${list_product}
    #create invoice
    Go to xu ly dat hang    ${order_code}
    Go to BH frm process order    ${order_code}
    Delete list product into BH form    ${list_product_del}
    Wait Until Keyword Succeeds    3 times    20 s    Input VND discount invoice    ${input_discount_inv}
    Run Keyword If    ${result_khachcantra} > ${invoice_value}    Wait Until Keyword Succeeds    3 times    8 s    Select promotion and giveaway product by search product    ${name}
    ...    ${list_give_product}    ${list_give_nums}    ELSE    Element Should Not Be Visible    ${icon_promo_sale}
    : FOR    ${item_product}    ${item_imei}    IN ZIP    ${list_give_product}    ${imei_inlist}
    \    Wait Until Keyword Succeeds    3 times    8 s    Input imei incase multi product to any form    ${item_product}    ${texbox_imei_search_multi_product}
    \    ...    ${item_serial_in_dropdown}    ${cell_imei_multi_product}    @{item_imei}
    Run Keyword If    "${input_bh_khachtt}" == "all"    Click Element JS    ${button_bh_thanhtoan}    ELSE    Input customer payment into BH form    ${input_bh_khachtt}    ${result_khachcanthanhtoan}
    Wait Until Page Contains Element    ${button_cancel}    2 mins
    Wait Until Keyword Succeeds    3 times    20 s    Click Element JS    ${button_cancel}    #tắt popup kết thúc đơn ĐH
    Sleep     2s
    ${invoice_code}    Get saved code after execute
    #get values
    Sleep    20 s    wait for response to API
    #assert value product in invoice
    ${get_list_hh_in_hd_af_execute}    Get list product frm Invoice API    ${invoice_code}
    ${list_soluong_in_hd}    ${list_giatri_quydoi_in_hd}    Get list quantity and gia tri quy doi by invoice code    ${get_list_hh_in_hd_af_execute}    ${invoice_code}
    : FOR    ${ma_hh}    ${result_toncuoi}    ${item_soluong}    ${get_giatri_quydoi}    IN ZIP    ${get_list_hh_in_hd_af_execute}
    ...    ${result_list_toncuoi}    ${list_soluong_in_hd}    ${list_giatri_quydoi_in_hd}
    \    Run Keyword If    '${get_giatri_quydoi}' == '1'    Validate product history frm API    ${invoice_code}    ${ma_hh}    ${result_toncuoi}
    \    ...    ${item_soluong}
    \    ...    ELSE    Validate unit product history frm API    ${invoice_code}    ${ma_hh}    ${result_toncuoi}
    \    ...    ${item_soluong}    ${get_giatri_quydoi}
    #assert value product
    ${list_order_summary_af_execute}    Get list order summary by order code    ${order_code}
    : FOR    ${result_tong_dh}    ${order_summary_af_execute}    IN ZIP    ${list_result_tongdh}    ${list_order_summary_af_execute}
    \    Should Be Equal As Numbers    ${order_summary_af_execute}    ${result_tong_dh}
    #assert value invoice
    ${get_ma_kh_by_hd}    ${get_tong_tien_hang}    ${get_khachtt_af_execute}    ${get_gghd_af_execute}    ${get_khachcantra}    ${get_trangthai}    ${get_ghichu_in_hd_af_execute}
    ...    Get invoice info have note incase discount by invoice code    ${invoice_code}
    Should Be Equal As Numbers    ${get_tong_tien_hang}    ${result_tongtienhang}
    Should Be Equal As Numbers    ${get_khachcantra}    ${result_khachcantra}
    Should Be Equal As Numbers    ${get_khachtt_af_execute}    ${result_khachdatra}
    Should Be Equal As Strings    ${get_ma_kh_by_hd}    ${input_ma_kh}
    Should Be Equal As Numbers    ${get_gghd_af_execute}    ${input_discount_inv}
    Should Be Equal As Strings    ${get_trangthai}    Hoàn thành
    #assert value order
    ${get_ma_kh_in_dh_af_execute}    ${get_TTDH_in_dh_af_execute}    ${get_tongtienhang_in_dh_af_exxecute}    ${get_khachdatra_in_dh_af_execute}    ${get_ghichu_af_execute}    Get order info have note by order code    ${order_code}
    Should Be Equal As Strings    ${get_ma_kh_in_dh_af_execute}    ${input_ma_kh}
    Should Be Equal As Strings    ${get_TTDH_in_dh_af_execute}    2    #trạng thái đang giao hàng
    Should Be Equal As Numbers    ${get_tongtienhang_in_dh_af_exxecute}    ${get_tongtienhang_in_dh_bf_execute}
    Should Be Equal As Numbers    ${get_khachdatra_in_dh_af_execute}    ${result_khachdatra}
    Should Be Equal As Strings    ${get_ghichu_af_execute}    ${get_ghichu_bf_execute}
    Validate invoice history frm Order    ${order_code}    ${invoice_code}    ${result_khachcantra}
    Delete invoice by invoice code    ${invoice_code}
    Delete order frm Order code    ${order_code}
    Toggle status of promotion and not for all customer    ${input_khuyenmai}    1    ${input_ten_nhom_kh}    Dịch vụ     Bánh nhập KM
