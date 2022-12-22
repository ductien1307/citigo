*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}      ${headless_browser}
Test Setup        Before Test Ban Hang
Test Teardown     After Test
Resource          ../../../../core/Ban_Hang/banhang_action.robot
Resource          ../../../../core/Ban_Hang/banhang_getandcompute.robot
Resource          ../../../../core/share/toast_message.robot
Resource          ../../../../core/Ban_Hang/banhang_navigation.robot
Resource          ../../../../core/API/api_danhmuc_hanghoa.robot
Resource          ../../../../core/API/api_khachhang.robot
Resource          ../../../../core/API/api_hoadon_banhang.robot
Resource          ../../../../core/API/api_soquy.robot
Resource          ../../../../core/So_Quy/so_quy_list_action.robot
Resource          ../../../../config/env_product/envi.robot
Resource          ../../../../core/share/list_dictionary.robot
Resource          ../../../../core/share/discount.robot
Resource          ../../../../core/API/api_thietlap.robot

*** Variables ***
&{list_product1}    PIB10018=5    PIB10019=2    BTT02=3
&{dict_ggsp1}     PIB10018=20    PIB10019=1000  BTT02=5000
&{dict2_ggsp1}    PIB10018=0    PIB10019=1000  BTT02=5

*** Test Cases ***    Product and num list    Product Discount                                                    Invoice Discount    Customer    Payment    Promotion Code
KM HD_GOLIVE          [Tags]                               CBPI           UEB1
                      [Template]              ekm1
                      ${list_product1}        ${dict2_ggsp1}                                                      5                   KH016       50000      KM02                #giam gia HD %
                      ${list_product1}        ${dict_ggsp1}                                                       5                   KH017       0          KM01                #giam gia HD VND


*** Keywords ***
ekm1
    [Arguments]    ${dict_product_num}    ${dict_product_discount}    ${input_bh_giamhd}    ${input_bh_ma_kh}    ${input_bh_khachtt}    ${input_khuyemmai}
    [Timeout]
    Toggle status of promotion    ${input_khuyemmai}    1
    ${list_product}    Get Dictionary Keys    ${dict_product_num}
    ${list_nums}    Get Dictionary Values    ${dict_product_num}
    ${list_discount_product}    Get Dictionary Values    ${dict_product_discount}
    ${invoice_value}    ${discount}    ${discount_ratio}    ${name}    Get Invoice value - Discounts - Promotion Name from Promotion Code    ${input_khuyemmai}
    ${get_no_bf_execute}    ${get_tongban_bf_execute}    ${get_tongban_tru_trahang_bf_execute}    ${get_customer_name}    Get Customer Info from API    ${input_bh_ma_kh}
    #create lists
    Reload page
    # Input data into BH form
    ${list_result_thanhtien}    ${list_result_newprice}    ${list_result_onhand_af_ex}    Get list of total sale - result onhand - result new price after execute    ${list_product}    ${list_nums}    ${list_discount_product}
    ${lastest_num}    Set Variable    0
    : FOR    ${item_product}    ${item_num}    ${item_discount}    ${item_newprice}    IN ZIP    ${list_product}
    ...    ${list_nums}    ${list_discount_product}    ${list_result_newprice}
    \    ${lastest_num}       Input product-num in BH form    ${item_product}    ${item_num}      ${lastest_num}
    \    Run keyword if    0 < ${item_discount} < 100    Wait Until Keyword Succeeds    3 times    20 s    Input % discount for product    ${item_discount}    ${item_newprice}
    \    ...    ELSE IF    ${item_discount} > 100    Wait Until Keyword Succeeds    3 times    20 s    Input vnd discount for product    ${item_discount}    ${item_newprice}
    \    ...    ELSE        Log      ignore
    ${result_tongtienhang}    Sum values in list    ${list_result_thanhtien}
    ${result_af_invoice_discount}    Price after % discount invoice    ${result_tongtienhang}    ${input_bh_giamhd}
    ${result_discount_invoice_by_vnd}    Convert % discount to VND and round    ${result_tongtienhang}    ${input_bh_giamhd}
    ${result_discount_ratio_by_invoice_promo}    Convert % discount to VND and round    ${result_tongtienhang}    ${discount_ratio}
    ${actual_promo_value}    Set Variable If    ${discount} == 0    ${result_discount_ratio_by_invoice_promo}    ${discount}
    ${final_discount}=    Run Keyword If    ${result_tongtienhang} > ${invoice_value}    Sum    ${actual_promo_value}    ${result_discount_invoice_by_vnd}
    ...    ELSE    Set Variable    ${result_discount_invoice_by_vnd}
    ${result_khachcantra}    Minus    ${result_tongtienhang}    ${final_discount}
    ${actual_khachtt}    Set Variable If    '${input_bh_khachtt}' == 'all'    ${result_khachcantra}    ${input_bh_khachtt}
    ${result_no_hoadon}    Minus    ${result_khachcantra}    ${actual_khachtt}
    ${result_nohientai}    sum    ${result_no_hoadon}    ${get_no_bf_execute}
    ${result_tongban}    Sum    ${result_khachcantra}    ${get_tongban_bf_execute}
    Wait Until Keyword Succeeds    3 times    8 s    Input Customer and validate    ${input_bh_ma_kh}    ${get_customer_name}
    Run Keyword If    ${result_tongtienhang} > ${invoice_value}    Wait Until Keyword Succeeds    3 times    8 s    Select promotion    ${name}
    ...    ELSE    Element Should Not Be Visible    ${icon_promo_sale}
    Wait Until Keyword Succeeds    3 times    8 s    Input % discount invoice    ${input_bh_giamhd}    ${final_discount}
    Run Keyword If    '${input_bh_khachtt}' != 'all'    Input payment info    ${input_bh_khachtt}    ${result_khachcantra}
    ...    ELSE    Log    abc
    Click Element JS    ${button_bh_thanhtoan}
    Invoice message success validation
    ${invoice_code}    Get saved code after execute
    #get values
    Sleep    20 s    wait for response to API
    #assert values in Hoa don
    ${get_ma_kh_by_hd}    ${get_tong_tien_hang}    ${get_khach_tt}    ${get_giamgia_hd}    ${get_khachcantra}    ${get_trangthai}    Get invoice info incase discount by invoice code
    ...    ${invoice_code}
    Should Be Equal As Numbers    ${get_tong_tien_hang}    ${result_tongtienhang}
    Should Be Equal As Numbers    ${result_khachcantra}    ${get_khachcantra}
    Should Be Equal As Numbers    ${get_khach_tt}    ${actual_khachtt}
    Should Be Equal As Strings    ${get_ma_kh_by_hd}    ${input_bh_ma_kh}
    Should Be Equal As Numbers    ${get_giamgia_hd}    ${final_discount}
    Should Be Equal As Strings    ${get_trangthai}    Hoàn thành
    #Assert values in product list and stock card
    Assert list of Onhand after execute    ${list_product}    ${list_result_onhand_af_ex}
    ${list_num_instockcard}    Change negative number to positive number and vice versa in List    ${list_nums}
    : FOR    ${item_product}    ${item_num_instockcard}    ${item_onhand}    IN ZIP    ${list_product}    ${list_num_instockcard}
    ...    ${list_result_onhand_af_ex}
    \    Assert values in Stock Card    ${invoice_code}    ${item_product}    ${item_onhand}    ${item_num_instockcard}
    #assert value in tab cong no khach hang
    ${get_maphieu_soquy}    Get Ma Phieu Thu in So quy    ${invoice_code}
    Run Keyword If    '${input_bh_khachtt}' == '0'    Validate status in Tab No can thu tu khach if Invoice is not paid until success    ${input_bh_ma_kh}    ${invoice_code}
    ...    ELSE    Validate status in Tab No can thu tu khach if Invoice is paid until success    ${input_bh_ma_kh}    ${get_maphieu_soquy}    ${invoice_code}
    #assert values in Khach hang and So quy
    ${get_no_af_purchase}    ${get_tongban_af_purchase}    ${get_tongban_tru_trahang_af_purchase}    Get Customer Debt from API after purchase    ${input_bh_ma_kh}    ${invoice_code}    ${actual_khachtt}
    Should Be Equal As Numbers    ${result_nohientai}    ${get_no_af_purchase}
    Should Be Equal As Numbers    ${result_tongban}    ${get_tongban_af_purchase}
    Run Keyword If    '${input_bh_khachtt}' == '0'    Validate So quy info from Rest API if Invoice is not paid until success    ${get_maphieu_soquy}
    ...    ELSE    Validate So quy info from Rest API if Invoice is paid until success    ${get_maphieu_soquy}    ${actual_khachtt}
    Toggle status of promotion    ${input_khuyemmai}    0
    Reload Page
