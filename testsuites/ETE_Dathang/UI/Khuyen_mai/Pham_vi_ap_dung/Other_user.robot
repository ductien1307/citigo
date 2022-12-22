*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}   tester    ${headless_browser}
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
&{list_product_nums4}    DVTKM01=3
&{list_product_nums5}    DVTKM03=6
&{list_give1}    SIKM03=1
@{list_quantity}    5
&{list_give2}    HTKM03=1
@{list_discount}    1000000
@{discount_type}   changeup

*** Test Cases ***    Product and num list    Customer    Payment    Promotion Code       Payment to create   Quantity new      User name
KM HH giam gia SP theo user
                      [Tags]                   EDPVKM
                      [Template]               kmpv3
                      ${list_product_nums4}    CTKH071       all      KM019                20000             ${list_quantity}    tester

KM HH va HD hinh thuc giam gia SP khong all filter
                      [Tags]                   EDPVKM     
                      [Template]               kmpv4
                      ${list_product_nums5}    20                   CTKH072       0        KM021      ${list_give2}        ${list_discount}     ${discount_type}    200000    Nhánh A     tester       Nhóm khách VIP

*** Keywords ***
kmpv3
    [Arguments]    ${dict_product_num}    ${input_ma_kh}    ${input_bh_khachtt}    ${input_khuyemmai}    ${input_khtt_create_order}
    ...    ${list_quantity}    ${input_username}
    [Timeout]
    ## Get info ton cuoi, cong no khach hang
    Toggle status of promotion and not for all user   ${input_khuyemmai}    1    ${input_username}    KM hàng
    ${order_code}    Add new order with promotion buy every items at a fixed reduced price    ${input_ma_kh}    ${dict_product_num}    ${input_khuyemmai}    ${input_khtt_create_order}
    ${num_sale_product}    ${num_promo_product}    ${product_price}    ${discount}    ${discount_ratio}    ${name}    Get Number of sale product - promo product - promo value and name
    ...    ${input_khuyemmai}
    ${list_product}    Get Dictionary Keys    ${dict_product_num}
    ${list_nums}    Get Dictionary Values    ${dict_product_num}
    ${get_no_bf_execute}    ${get_tongban_bf_execute}    ${get_tongban_tru_trahang_bf_execute}    ${get_customer_name}    Get Customer Info from API    ${input_ma_kh}
    ${list_order_summary}     Get list order summary frm product API    ${list_product}
    ${get_khachdatra_in_dh_bf_execute}    ${get_tongtienhang_in_dh_bf_execute}    Get paid value frm API    ${order_code}
    ${get_list_hh_in_dh_bf_execute}    ${get_ghichu_bf_execute}    Get ghi chu and list product frm API    ${order_code}
    ${list_result_thanhtien}    Create List
    ${list_result_order_summary}    Create List
    : FOR    ${get_soluong_in_dh}    ${input_soluong}    ${get_tongso_dh_bf_execute}    IN ZIP    ${list_nums}    ${list_quantity}    ${list_order_summary}
    \    ${result_soluong_giam}    Minus    ${get_soluong_in_dh}    ${input_soluong}
    \    ${result_soluong_tang}    Minus    ${input_soluong}    ${get_soluong_in_dh}
    \    ${result_soluong}    Set Variable If    ${input_soluong}>${get_soluong_in_dh}    ${result_soluong_tang}    ${result_soluong_giam}
    \    ${result_tongdh_tang}    Sum    ${get_tongso_dh_bf_execute}    ${result_soluong}
    \    ${result_tongdh_giam}    Minus    ${get_tongso_dh_bf_execute}    ${result_soluong}
    \    ${result_tongdh}    Set Variable If    ${input_soluong}>${get_soluong_in_dh}    ${result_tongdh_tang}    ${result_tongdh_giam}
    \    ${result_thanhtien_ggsp}    Multiplication and round    ${product_price}    ${input_soluong}
    \    Append To List    ${list_result_thanhtien}    ${result_thanhtien_ggsp}
    \    Append To List    ${list_result_order_summary}    ${result_tongdh}
    Reload Page
    #Compute
    ${result_tongtienhang}    Sum values in list    ${list_result_thanhtien}
    ${result_khachcantra}   Minus And Replace Floating Point    ${result_tongtienhang}     ${get_khachdatra_in_dh_bf_execute}
    ${actual_khachtt}    Set Variable If    '${input_bh_khachtt}' == 'all'    ${result_khachcantra}    ${input_bh_khachtt}
    ${result_nohientai}    Minus    ${get_no_bf_execute}    ${actual_khachtt}
    #create invoice
    Go to xu ly dat hang    ${order_code}
    ${lastest_num}    Set Variable    0
    : FOR    ${item_ma_hh}    ${item_soluong}   IN ZIP    ${get_list_hh_in_dh_bf_execute}    ${list_quantity}
    \    ${lastest_num}    Update quantity into DH form    ${item_ma_hh}    ${item_soluong}    ${lastest_num}
    Wait Until Keyword Succeeds    3 times    8 s    Select promotion on each product line    ${name}
    Wait Until Keyword Succeeds    3 times    8 s    Input order payment into BH    ${actual_khachtt}    ${result_khachcantra}
    Click Element JS    ${button_luu_order}
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
    Should Be Equal As Numbers    ${get_khachdatra_in_dh_af_execute}    ${result_tongtienhang}
    Should Be Equal As Numbers    ${get_giamgia_in_dh_af_execute}    0
    Should Be Equal As Numbers    ${get_tongcong_in_dh_af_execute}    ${result_tongtienhang}
    #assert value product
    ${list_order_summary_af_execute}    Get list order summary by order code    ${order_code}
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
    Run Keyword If    '${input_bh_khachtt}' == '0'    Validate So quy info if Order is not paid    ${order_code}
    ...    ELSE    Validate So quy info if Order is paid    ${get_ma_phieutt_in_dh}    ${actual_khachtt}
    Delete order frm Order code    ${order_code}
    Toggle status of promotion and not for all user   ${input_khuyemmai}    0    ${input_username}    KM hàng

kmpv4
    [Arguments]    ${dict_product_nums_tocreate}  ${input_gghd}    ${input_ma_kh}    ${input_khtt}   ${input_khuyenmai}    ${list_promo_product}
    ...   ${list_ggsp}   ${list_discount_type}    ${input_khtt_tocreate}    ${input_ten_branch}    ${input_ten_user}    ${input_ten_group_kh}
    Set Selenium Speed    0.5s
    Toggle status of promotion and not for all filter   ${input_khuyenmai}    1    ${input_ten_branch}    ${input_ten_user}    ${input_ten_group_kh}    KM Hàng mua     KM Hàng tặng
    ${invoice_value}    ${received_value}    ${discount}    ${discount_ratio}    ${name}    Get Invoice value - Received value - Discounts - Promotion Name from Promotion Code    ${input_khuyenmai}
    ${order_code}    Add new order incase discount - payment with other branch    ${input_ma_kh}    0    ${dict_product_nums_tocreate}    ${list_ggsp}
    ...   ${list_discount_type}    ${input_khtt_tocreate}    ${input_ten_branch}
    #get info product, customer
    ${list_product_promo}    Get Dictionary Keys    ${list_promo_product}
    ${list_nums_promo}    Get Dictionary Values    ${list_promo_product}
    ${get_khachdatra_in_dh_bf_execute}    ${get_tongtienhang_in_dh_bf_execute}    Get paid value frm API    ${order_code}
    ${get_list_hh_in_dh_bf_execute}    ${get_list_nums_in_dh}    Get list product and quantity frm API    ${order_code}
    ##get value
    ${list_result_tongdh}    Create List
    ${result_list_toncuoi}    Create List
    ${result_list_thanhtien}    Create List
    ${list_giatri_quydoi}    Get list gia tri quy doi frm product API    ${get_list_hh_in_dh_bf_execute}
    ${get_list_product_type}    ${list_tonkho_service}    Get list product type and ending stock of service with other branch    ${get_list_hh_in_dh_bf_execute}    ${input_ten_branch}
    ${get_list_baseprice}    ${list_order_summary}    Get list of baseprice and order summary by product code and branch id    ${get_list_hh_in_dh_bf_execute}    ${input_ten_branch}
    ${list_onhand}    Get list onhand with other branch    ${get_list_hh_in_dh_bf_execute}    ${input_ten_branch}
    : FOR    ${item_product}    ${get_soluong_in_dh}    ${get_tongso_dh_bf_execute}    ${get_ton_bf_execute}    ${get_toncuoi_dv_execute}    ${giatri_quydoi}
    ...    ${get_product_type}    ${get_giaban_bf_execute}    ${input_ggsp}   ${discount_type}    IN ZIP    ${get_list_hh_in_dh_bf_execute}    ${get_list_nums_in_dh}
    ...    ${list_order_summary}    ${list_onhand}    ${list_tonkho_service}    ${list_giatri_quydoi}    ${get_list_product_type}    ${get_list_baseprice}    ${list_ggsp}    ${list_discount_type}
    \    ${result_tongdh}    Minus and round 2    ${get_tongso_dh_bf_execute}    ${get_soluong_in_dh}
    \    ${result_toncuoi}    Run Keyword If    '${giatri_quydoi}' == '1'    Computation and get list ending stock    ${get_ton_bf_execute}    ${get_toncuoi_dv_execute}
    \    ...    ${get_soluong_in_dh}    ${get_product_type}
    \    ...    ELSE    Computation and get list ending stock for unit product    ${item_product}    ${giatri_quydoi}    ${get_soluong_in_dh}
    \    ${ressult_giamoi}    Run Keyword If    '${discount_type}' == 'dis'    Price after % discount product    ${get_giaban_bf_execute}    ${input_ggsp}
    \    ...    ELSE IF    '${discount_type}' == 'disvnd'    Minus and round 2    ${get_giaban_bf_execute}    ${input_ggsp}
    \    ...    ELSE IF    '${discount_type}' == 'changeup' or '${discount_type}' == 'changedown'   Set Variable   ${input_ggsp}
    \    ...     ELSE    Set Variable    ${get_giaban_bf_execute}
    \    ${result_thanhtien}    Multiplication and round    ${ressult_giamoi}    ${get_soluong_in_dh}
    \    Append To List    ${list_result_tongdh}    ${result_tongdh}
    \    Append To List    ${result_list_toncuoi}    ${result_toncuoi}
    \    Append To List    ${result_list_thanhtien}    ${result_thanhtien}
    #compute product promo
    Switch branch in sale form    ${input_ten_branch}
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
    ${result_tongtienhang}    Sum values in list    ${result_list_thanhtien}
    ${result_tongtienhang_promo}    Sum values in list    ${result_thanhtien_promo}
    ${result_tongtienhang}    Sum    ${result_tongtienhang}    ${result_tongtienhang_promo}
    ${result_gghd}    Run Keyword If    0 < ${input_gghd} < 100    Convert % discount to VND and round    ${result_tongtienhang}    ${input_gghd}
    ...    ELSE    Set Variable    ${input_gghd}
    ${result_TTH_tru_gghd}    Run Keyword If    0 < ${input_gghd} < 100    Price after % discount invoice    ${result_tongtienhang}    ${input_gghd}
    ...    ELSE    Minus and replace floating point    ${result_tongtienhang}    ${input_gghd}
    ${result_khachcantra}    Minus and replace floating point    ${result_TTH_tru_gghd}    ${get_khachdatra_in_dh_bf_execute}
    ${actual_khtt}    Set Variable If    '${input_khtt}' == 'all'    ${result_khachcantra}    ${input_khtt}
    ${result_khachdatra_in_dh}    Sum    ${get_khachdatra_in_dh_bf_execute}    ${actual_khtt}
    #create invoice from order
    Go to xu ly dat hang    ${order_code}
    Go to BH frm process order    ${order_code}
    Run Keyword If    ${result_tongtienhang} > ${invoice_value}    Wait Until Keyword Succeeds    3 times    8 s    Select promotion and giveaway product by search product    ${name}
    ...    ${list_product_promo}    ${list_nums_promo}    ELSE    Element Should Not Be Visible    ${icon_promo_sale}
    Run Keyword If    0 < ${input_gghd} < 100    Wait Until Keyword Succeeds    3 times    5 s   Input % discount invoice    ${input_gghd}
    ...    ${result_gghd}    ELSE    Wait Until Keyword Succeeds    3 times    5 s   Input VND discount invoice    ${input_gghd}
    Run Keyword If    "${input_khtt}" == "all"    Click Element JS    ${button_bh_thanhtoan}    ELSE    Wait Until Keyword Succeeds    3 times    5 s   Input customer payment into BH form    ${input_khtt}
    ...    ${result_khachcantra}
    Invoice message success validation
    ${invoice_code}    Get saved code after execute
    #get value
    Sleep    20s    wait for response to API
    #assert value product in invoice
    : FOR    ${ma_hh}    ${result_toncuoi}    ${item_soluong}    IN ZIP    ${get_list_hh_in_dh_bf_execute}
    ...    ${result_list_toncuoi}    ${get_list_nums_in_dh}
    \     ${soluong_in_thekho}    ${toncuoi_in_thekho}    Get Stock Card info frm API by Branch and User    ${invoice_code}    ${ma_hh}    ${input_ten_branch}    ${input_ten_user}
    \     Should Be Equal As Numbers    ${toncuoi_in_thekho}    ${result_toncuoi}
    \     Should Be Equal As Numbers    ${soluong_in_thekho}    ${item_soluong}
    #assert value product promo in invoice
    : FOR    ${ma_hh_promo}    ${result_toncuoi_promo}    ${item_soluong_promo}    IN ZIP    ${list_product_promo}
    ...    ${list_result_toncuoi_promo}    ${list_nums_promo}
    \     ${soluong_in_thekho_promo}    ${toncuoi_in_thekho_promo}    Get Stock Card info frm API by Branch and User    ${invoice_code}    ${ma_hh_promo}    ${input_ten_branch}    ${input_ten_user}
    \     Should Be Equal As Numbers    ${toncuoi_in_thekho_promo}    ${result_toncuoi_promo}
    \     Should Be Equal As Numbers    ${soluong_in_thekho_promo}    ${item_soluong_promo}
    #validate product
    ${list_order_summary_af_execute}    Get list of order summary by product code and branch id    ${get_list_hh_in_dh_bf_execute}    ${input_ten_branch}
    : FOR    ${result_tong_dh}    ${order_summary_af_execute}    IN ZIP    ${list_result_tongdh}    ${list_order_summary_af_execute}
    \    Should Be Equal As Numbers    ${order_summary_af_execute}    ${result_tong_dh}
    #assert value invoice
    ${get_ma_kh_by_hd}    ${get_tong_tien_hang}    ${get_khach_tt}    ${get_giamgia_hd}    ${get_khachcantra}    ${get_trangthai}    Get invoice info with other branch and user    ${invoice_code}
    ...    ${input_ten_branch}    ${input_ten_user}
    Should Be Equal As Numbers    ${get_tong_tien_hang}    ${result_tongtienhang}
    Should Be Equal As Numbers    ${get_khachcantra}    ${result_TTH_tru_gghd}
    Should Be Equal As Numbers    ${get_khach_tt}    ${result_khachdatra_in_dh}
    Should Be Equal As Strings    ${get_ma_kh_by_hd}    ${input_ma_kh}
    Should Be Equal As Numbers    ${get_giamgia_hd}    ${result_gghd}
    Should Be Equal As Strings    ${get_trangthai}    Hoàn thành
    #assert value order
    ${get_ma_kh_in_dh_af_execute}    ${get_TTDH_in_dh_af_execute}    ${get_tongtienhang_in_dh_af_exxecute}    ${get_khachdatra_in_dh_af_execute}    ${get_ghichu_af_execute}    Get order info have note by order code    ${order_code}
    Should Be Equal As Strings    ${get_ma_kh_in_dh_af_execute}    ${input_ma_kh}
    Should Be Equal As Strings    ${get_TTDH_in_dh_af_execute}    3    #trạng thái hoan thanh
    Should Be Equal As Numbers    ${get_tongtienhang_in_dh_af_exxecute}    ${get_tongtienhang_in_dh_bf_execute}
    Should Be Equal As Numbers    ${get_khachdatra_in_dh_af_execute}    ${result_khachdatra_in_dh}
    Should Be Equal As Strings    ${get_ghichu_af_execute}    0
    Validate invoice history frm Order    ${order_code}    ${invoice_code}    ${result_TTH_tru_gghd}
    ## Deactivate surcharge
    Delete invoice by invoice code and other branch    ${invoice_code}   ${input_ten_branch}
    Delete order frm Order code    ${order_code}
    Toggle status of promotion and not for all filter   ${input_khuyenmai}    0    ${input_ten_branch}    ${input_ten_user}    ${input_ten_group_kh}    KM Hàng mua     KM Hàng tặng
