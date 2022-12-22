*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}      ${headless_browser}
Test Setup        Before Test turning on display mode       ${toggle_item_themdong}
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
&{invoice_1}      PIB10032=5.6,1    IM15=2,1,1    DVT0212=3,2    QD005=2,5       Combo36=1       DV035=1,3,2
&{invoice_1_product_line_num}      PIB10032=2    IM15=3    DVT0212=2    QD005=2       Combo36=1       DV035=3
&{discount_1}      PIB10032=0,5    IM15=5,10000,0    DVT0212=99899.67,0    QD005=4,5       Combo36=0       DV035=150000,1000,0
&{discount_type1}      PIB10032=none,dis    IM15=dis,disvnd,none    DVT0212=changeup,none    QD005=dis,dis       Combo36=none       DV035=changedown,disvnd,none
&{product_type1}      PIB10032=pro    IM15=imei    DVT0212=pro    QD005=unit       Combo36=com       DV035=ser

*** Test Cases ***    Product and num list         Product Type       Product Line Number       Product Discount      Discount Type        Invoice Discount    Payment
UI_All       [Tags]               UEB                   NOCUS           EBT
                      [Template]              etebhm_nocus
                      ${invoice_1}            ${product_type1}          ${invoice_1_product_line_num}        ${discount_1}         ${discount_type1}          0                400000

*** Keywords ***
etebhm_nocus
    [Arguments]    ${dict_product_num}    ${dict_product_type}      ${dict_product_line_num}        ${dict_discount}      ${dict_discount_type}      ${input_invoice_discount}     ${input_bh_khachtt}
    [Timeout]
    ${list_products}    Get Dictionary Keys    ${dict_product_num}
    ${list_nums}    Get Dictionary Values    ${dict_product_num}
    ${list_product_type}    Get Dictionary Values    ${dict_product_type}
    ${list_discount_product}    Get Dictionary Values    ${dict_discount}
    ${list_discount_type}    Get Dictionary Values    ${dict_discount_type}
    ${list_product_line_num}       Get Dictionary Values       ${dict_product_line_num}
    ${list_unit}       Get list of keys from dictionary by value    ${dict_product_type}      unit
    ${list_imei_product}       Get list of keys from dictionary by value    ${dict_product_type}      imei
    ${list_unit_quan}       Get list of values from dictionary by list of keys    ${dict_product_num}    ${list_unit}
    ${list_productid}       Get list product id thr API    ${list_products}
    Log          Convert Lists
    ${list_nums}    Convert string list to composite list    ${list_nums}
    ${list_discount_type}    Convert string list to composite list    ${list_discount_type}
    ${list_discount_product}    Convert string list to composite list    ${list_discount_product}
    ${list_actual_quan}      Create List
    : FOR    ${item_product}     ${item_list_num}    IN ZIP    ${list_products}    ${list_nums}
    \    ${total_quan_by_product}       Sum values in list       ${item_list_num}
    \    Append to List       ${list_actual_quan}        ${total_quan_by_product}
    Log      ${list_actual_quan}
    Log      Create list imei for imei products
    ${list_imei_all}    create list
    : FOR    ${item_product}     ${item_num}    ${item_product_type}    IN ZIP    ${list_products}    ${list_nums}      ${list_product_type}
    \    ${list_num_by_product}       Convert String to List       ${item_num}
    \    ${list_imei_by_single_product}=      Run Keyword If    '${item_product_type}' == 'imei'      Import multi imei for mul-line product    ${item_product}    ${list_num_by_product}      ELSE      Set Variable    nonimei
    \    Append to List       ${list_imei_all}        ${list_imei_by_single_product}
    Log       ${list_imei_all}
    ${list_imei_for_validation}      Copy list      ${list_imei_all}
    Remove values From List      ${list_imei_for_validation}        nonimei
    ${list_product_for_validation}       ${list_product_quan_for_validation}     ${list_product_type_for_validation}       Remove combo and unit from validation lists    ${list_products}    ${list_actual_quan}    ${list_product_type}
    ${list_product_for_validation}       ${list_product_quan_for_validation}     ${list_product_type_for_validation}       Extract combo and unit products for validation lists        ${list_products}    ${list_actual_quan}    ${list_product_type}       ${list_product_for_validation}       ${list_product_quan_for_validation}     ${list_product_type_for_validation}
    Log       Get Data
    ${list_result_ton_af_ex}        Get list of result onhand incase changing product price    ${list_product_for_validation}    ${list_product_quan_for_validation}
    ${list_result_thanhtien}      ${list_result_newprice_by_list_product_line}    Get list of multi lines total sale - result new price incase changing product price    ${list_products}    ${list_nums}    ${list_discount_product}      ${list_discount_type}
    Log    ${list_result_thanhtien}
    Log    ${list_result_newprice_by_list_product_line}
    Sleep     30 s
    Reload Page
    Log      Input data into BH form
    ${lastest_num}    Set Variable    0
    : FOR    ${item_product}    ${item_product_id}      ${item_product_type}       ${item_line}     ${item_list_num}        ${item_list_imei}    ${item_list_discount}      ${item_list_discount_type}     ${item_list_newprice}    IN ZIP    ${list_products}       ${list_productid}      ${list_product_type}        ${list_product_line_num}
    ...    ${list_nums}    ${list_imei_all}       ${list_discount_product}    ${list_discount_type}      ${list_result_newprice_by_list_product_line}
    \    ${lastest_num}=        Run Keyword If    '${item_product_type}' == 'imei'    Input product - its imei mul-lines in BH form    ${item_line}     ${item_product}    ${item_product_id}    ${item_list_num}      ${item_list_imei}    ${lastest_num}     ELSE     Input product - its quantity mul-lines in BH form    ${item_line}    ${item_product}    ${item_product_id}    ${item_list_num}    ${lastest_num}
    \    Input discount or change price for product in case apply multi-rows       ${item_product_id}      ${item_line}    ${item_list_num}      ${item_list_discount_type}         ${item_list_discount}        ${item_list_newprice}
    ${result_tongtienhang}    Sum values in list    ${list_result_thanhtien}
    Validate UI Total Invoice value    ${result_tongtienhang}
    ${result_khachcantra}=    Run Keyword If    0 < ${input_invoice_discount} < 100    Price after % discount invoice    ${result_tongtienhang}    ${input_invoice_discount}
    ...    ELSE IF    ${input_invoice_discount} > 100    Minus    ${result_tongtienhang}    ${input_invoice_discount}
    ...    ELSE    Set Variable    ${result_tongtienhang}
    ${result_discount_invoice}    Run Keyword If    0 < ${input_invoice_discount} < 100    Convert % discount to VND and round    ${result_tongtienhang}    ${input_invoice_discount}
    ...    ELSE    Set Variable    ${input_invoice_discount}
    ${actual_khachtt}    Set Variable If    '${input_bh_khachtt}' == 'all'    ${result_khachcantra}    ${input_bh_khachtt}
    ${result_no_hoadon}    Minus    ${result_khachcantra}    ${actual_khachtt}
    Run Keyword If    0 < ${input_invoice_discount} < 100    Wait Until Keyword Succeeds    3 times    3 s    Input % discount invoice    ${input_invoice_discount}
    ...    ${result_discount_invoice}
    ...    ELSE IF    ${input_invoice_discount} > 100    Input VND discount invoice    ${input_invoice_discount}
    ...    ELSE    Log    Ignore discount
    Run Keyword If    '${input_bh_khachtt}' != 'all'     Wait Until Keyword Succeeds    3 times    3 s    Input payment    ${actual_khachtt}    ${result_khachcantra}    ELSE    Log        Ignore input
    Run Keyword If    '${input_bh_khachtt}' == 'all'     Click Element JS    ${button_bh_thanhtoan}        ELSE      Click Save Invoice incase having confimation popup
    Invoice message success validation
    ${invoice_code}    Get saved code after execute
    Sleep    20 s    wait for response to API
    Log       assert values in Hoa don
    ${get_ma_kh_by_hd}    ${get_tong_tien_hang}    ${get_khach_tt}    ${get_giamgia_hd}    ${get_khachcantra}    ${get_trangthai}    Get invoice info incase discount by invoice code
    ...    ${invoice_code}
    Run Keyword If    ${input_invoice_discount} == 0    Should Be Equal As Numbers    ${get_khachcantra}    ${result_tongtienhang}
    ...    ELSE    Should Be Equal As Numbers    ${get_tong_tien_hang}    ${result_tongtienhang}
    Run Keyword If    ${input_invoice_discount} == 0    Log    Ignore validate
    ...    ELSE    Should Be Equal As Numbers    ${get_tong_tien_hang}    ${result_tongtienhang}
    Should Be Equal As Numbers    ${get_khachcantra}    ${result_khachcantra}
    Should Be Equal As Numbers    ${get_khach_tt}    ${actual_khachtt}
    Should Be Equal As Numbers    ${get_giamgia_hd}    ${result_discount_invoice}
    Should Be Equal As Strings    ${get_trangthai}    Hoàn thành
    Log        Assert values in product list and stock card
    Assert list of Onhand after execute in case having multi-product types      ${list_product_for_validation}    ${list_product_type_for_validation}       ${list_result_ton_af_ex}
    ${list_num_instockcard}    Change negative number to positive number and vice versa in List    ${list_product_quan_for_validation}
    : FOR    ${item_product}    ${item_product_type}      ${item_num_instockcard}    ${item_result_onhand}     ${item_imei_by_pr}      IN ZIP    ${list_product_for_validation}    ${list_product_type_for_validation}     ${list_num_instockcard}
    ...    ${list_result_ton_af_ex}        ${list_imei_all}
    \    Run Keyword If    '${item_product_type}' == 'ser'    Assert values in Stock Card incase service product    ${invoice_code}    ${item_product}     ${item_num_instockcard}      ELSE     Assert values in Stock Card    ${invoice_code}    ${item_product}    ${item_result_onhand}    ${item_num_instockcard}
    Log      assert imei
    : FOR    ${item_product}     ${item_imei_by_pr}      IN ZIP    ${list_imei_product}    ${list_imei_for_validation}
    \    Assert imei not avaiable in SerialImei tab    ${item_product}    @{item_imei_by_pr}
    Log       assert value in tab cong no khach hang
    ${get_maphieu_soquy}    Get Ma Phieu Thu in So quy    ${invoice_code}
    Run Keyword If    '${input_bh_khachtt}' == '0'    Validate So quy info from Rest API if Invoice is not paid until success    ${get_maphieu_soquy}
    ...    ELSE    Validate So quy info from Rest API if Invoice is paid until success    ${get_maphieu_soquy}    ${actual_khachtt}
    Delete invoice by invoice code    ${invoice_code}
