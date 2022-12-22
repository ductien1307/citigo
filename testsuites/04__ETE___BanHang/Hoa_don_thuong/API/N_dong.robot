*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}      ${headless_browser}
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
&{invoice_1}      PIB10031=5.6,1    IM14=2,1,1    DVT0211=3,2    QD004=2,5       Combo35=1       DV034=1,3,2
&{invoice_1_product_line_num}      PIB10031=2    IM14=3    DVT0211=2    QD004=2       Combo35=1       DV034=3
&{discount_1}      PIB10031=0,5    IM14=5,10000,0    DVT0211=99899.67,0    QD004=4,5       Combo35=0       DV034=150000,1000,0
&{discount_type1}      PIB10031=none,dis    IM14=dis,disvnd,none    DVT0211=changeup,none    QD004=dis,dis       Combo35=none       DV034=changedown,disvnd,none
&{product_type1}      PIB10031=pro    IM14=imei    DVT0211=pro    QD004=unit       Combo35=com       DV034=ser

*** Test Cases ***    Product and num list         Product Type       Product Line Number       Product Discount      Discount Type        Invoice Discount       Invoice Discount Type        Customer    Payment
UI_All       [Tags]               AEBM
                      [Template]              api_etebhm1
                      ${invoice_1}            ${product_type1}          ${invoice_1_product_line_num}        ${discount_1}         ${discount_type1}          50000       null       KH037       0

*** Keywords ***
api_etebhm1
    [Arguments]    ${dict_product_num}    ${dict_product_type}      ${dict_product_line_num}        ${dict_discount}      ${dict_discount_type}      ${input_invoice_discount}    ${input_invoice_discount_type}       ${input_bh_ma_kh}    ${input_bh_khachtt}
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
    ${get_no_bf_execute}    ${get_tongban_bf_execute}    ${get_tongban_tru_trahang_bf_execute}    ${get_customer_name}    Get Customer Info from API    ${input_bh_ma_kh}
    ${list_actual_quan}      Create List
    : FOR    ${item_product}     ${item_list_num}    IN ZIP    ${list_products}    ${list_nums}
    \    ${total_quan_by_product}       Sum values in list       ${item_list_num}
    \    Append to List       ${list_actual_quan}        ${total_quan_by_product}
    Log      ${list_actual_quan}
    Log      Create list imei for imei products
    ${list_imei_all}    create list
    : FOR    ${item_product}     ${item_num}    ${item_product_type}    IN ZIP    ${list_products}    ${list_nums}      ${list_product_type}
    \    ${list_num_by_product}       Convert String to List       ${item_num}
    \    ${list_imei_by_single_product}=      Run Keyword If    '${item_product_type}' == 'imei'      Import multi imei for mul-line product    ${item_product}    ${list_num_by_product}      ELSE      Create list by list Quantity   ${list_num_by_product}
    \    Append to List       ${list_imei_all}        ${list_imei_by_single_product}
    Log       ${list_imei_all}
    ${list_imei_for_validation}      Copy list      ${list_imei_all}
    Remove values From List      ${list_imei_for_validation}        nonimei
    ${list_product_for_validation}       ${list_product_quan_for_validation}     ${list_product_type_for_validation}       Remove combo and unit from validation lists    ${list_products}    ${list_actual_quan}    ${list_product_type}
    ${list_product_for_validation}       ${list_product_quan_for_validation}     ${list_product_type_for_validation}       Extract combo and unit products for validation lists        ${list_products}    ${list_actual_quan}    ${list_product_type}       ${list_product_for_validation}       ${list_product_quan_for_validation}     ${list_product_type_for_validation}
    Log       Get Data
    ${list_result_ton_af_ex}        Get list of result onhand incase changing product price    ${list_product_for_validation}    ${list_product_quan_for_validation}
    ${list_product_id}    ${get_list_baseprice}    ${list_result_product_discount_by_list_product_line}    ${list_result_newprice_by_list_product_line}    ${list_result_totalsale}    Get list of product id - baseprice - list result product discount - list result new price - list total sale incase changing product price      ${list_products}    ${list_nums}    ${list_discount_product}      ${list_discount_type}
    ${result_tongtienhang}    Sum values in list    ${list_result_totalsale}
    ${result_khachcantra}=    Run Keyword If    0 < ${input_invoice_discount} < 100    Price after % discount invoice    ${result_tongtienhang}    ${input_invoice_discount}
    ...    ELSE IF    ${input_invoice_discount} > 100    Minus    ${result_tongtienhang}    ${input_invoice_discount}
    ...    ELSE    Set Variable    ${result_tongtienhang}
    ${result_discount_invoice}    Run Keyword If    0 < ${input_invoice_discount} < 100    Convert % discount to VND and round    ${result_tongtienhang}    ${input_invoice_discount}
    ...    ELSE    Set Variable    ${input_invoice_discount}
    ${actual_khachtt}    Set Variable If    '${input_bh_khachtt}' == 'all'    ${result_khachcantra}    ${input_bh_khachtt}
    ${result_no_hoadon}    Minus    ${result_khachcantra}    ${actual_khachtt}
    ${result_nohientai}    sum    ${result_no_hoadon}    ${get_no_bf_execute}
    ${result_tongban}    Sum    ${result_khachcantra}    ${get_tongban_bf_execute}
    ##
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${jsonpath_id_kh}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_bh_ma_kh}
    ${get_id_kh}    Get data from API    ${endpoint_khachhang}    ${jsonpath_id_kh}
    ${giamgia_hd}    Set Variable If    0 < ${input_invoice_discount} < 100    ${input_invoice_discount}    null
    ${result_gghd}    Run Keyword If    0 < ${input_invoice_discount} < 100    Convert % discount to VND    ${result_tongtienhang}    ${input_invoice_discount}
    ...    ELSE    Set Variable    ${input_invoice_discount}
    # Post request BH
    Log      ${list_product_id}
    Log       ${list_product_type}
    Log       ${get_list_baseprice}
    Log       ${list_nums}
    Log       ${list_result_product_discount_by_list_product_line}
    Log       ${list_imei_all}
    ${liststring_prs_invoice_detail}       Create json for Invoice Details in case multi-lines    ${list_product_id}    ${list_product_type}    ${get_list_baseprice}    ${list_nums}    ${list_discount_product}        ${list_result_product_discount_by_list_product_line}       ${list_discount_type}       ${list_imei_all}
    ${request_payload}    Format String    {{"Invoice":{{"BranchId":{0},"RetailerId":{1},"CustomerId":{2},"SoldById":{3},"SoldBy":{{"CreatedBy":0,"CreatedDate":"2018-12-10T10:42:37.447Z","Email":"","GivenName":"admin","Id":{3},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false}},"SaleChannelId":0,"Seller":{{"CreatedBy":0,"CreatedDate":"2018-12-10T10:42:37.447Z","Email":"","GivenName":"admin","Id":{3},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false}},"OrderCode":"","Code":"Hóa đơn 1","Discount":{4},"DiscountRatio":{5},"InvoiceDetails":[{6}],"InvoiceOrderSurcharges":[],"InvoicePromotions":[],"Payments":[{{"Method":"Cash","MethodStr":"Tiền mặt","Amount":{8},"Id":-1}}],"Status":1,"Total":{7},"Surcharge":0,"Type":1,"Uuid":"","addToAccount":"0","addToAccountSurplus":"0","PayingAmount":{8},"TotalBeforeDiscount":2170500,"ProductDiscount":1268000,"DebugUuid":"","InvoiceWarranties":[],"CreatedBy":196750}}}}    ${BRANCH_ID}    ${get_id_nguoitao}    ${get_id_kh}    ${get_id_nguoiban}     ${result_gghd}    ${input_invoice_discount_type}       ${liststring_prs_invoice_detail}      ${result_khachcantra}      ${actual_khachtt}
    Log    ${request_payload}
    ${invoice_code}    Post request to create invoice and get invoice code    ${request_payload}
    Sleep      5 s      wait for response to API
    Log       assert values in Hoa don
    ${get_ma_kh_by_hd}    ${get_tong_tien_hang}    ${get_khach_tt}    ${get_giamgia_hd}    ${get_khachcantra}    ${get_trangthai}    Get invoice info incase discount by invoice code
    ...    ${invoice_code}
    Run Keyword If    ${input_invoice_discount} == 0    Should Be Equal As Numbers    ${get_khachcantra}    ${result_tongtienhang}
    ...    ELSE    Should Be Equal As Numbers    ${get_tong_tien_hang}    ${result_tongtienhang}
    Run Keyword If    ${input_invoice_discount} == 0    Log    Ignore validate
    ...    ELSE    Should Be Equal As Numbers    ${get_tong_tien_hang}    ${result_tongtienhang}
    Should Be Equal As Numbers    ${get_khachcantra}    ${result_khachcantra}
    Should Be Equal As Numbers    ${get_khach_tt}    ${actual_khachtt}
    Should Be Equal As Strings    ${get_ma_kh_by_hd}    ${input_bh_ma_kh}
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
    Run Keyword If    '${input_bh_khachtt}' == '0'    Validate status in Tab No can thu tu khach if Invoice is not paid until success    ${input_bh_ma_kh}    ${invoice_code}
    ...    ELSE    Validate status in Tab No can thu tu khach if Invoice is paid until success    ${input_bh_ma_kh}    ${get_maphieu_soquy}    ${invoice_code}
    Log        assert values in Khach hang and So quy
    ${get_no_af_purchase}    ${get_tongban_af_purchase}    ${get_tongban_tru_trahang_af_purchase}    Get Customer Debt from API after purchase    ${input_bh_ma_kh}    ${invoice_code}    ${actual_khachtt}
    Should Be Equal As Numbers    ${result_nohientai}    ${get_no_af_purchase}
    Should Be Equal As Numbers    ${result_tongban}    ${get_tongban_af_purchase}
    Run Keyword If    '${input_bh_khachtt}' == '0'    Validate So quy info from Rest API if Invoice is not paid until success    ${get_maphieu_soquy}
    ...    ELSE    Validate So quy info from Rest API if Invoice is paid until success    ${get_maphieu_soquy}    ${actual_khachtt}
    #Delete invoice by invoice code    ${invoice_code}
