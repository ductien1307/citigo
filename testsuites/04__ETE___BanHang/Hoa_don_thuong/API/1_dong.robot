*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}      ${headless_browser}
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

*** Variables ***

&{invoice_1}      PIB10003=5.6    IM03=4    DVT0101=3    QD002=2       Combo029=1       DV027=3               # QD002: giá bán bằng 0
&{discount_1}      PIB10003=5    IM03=4000    DVT0101=59899.67    QD002=0       Combo029=190000       DV027=20
&{discount_type1}      PIB10003=dis    IM03=disvnd    DVT0101=changedown    QD002=none       Combo029=changeup       DV027=dis
&{product_type1}      PIB10003=pro    IM03=imei    DVT0101=pro    QD002=unit       Combo029=com       DV027=ser
# combo
&{com_invoice1}    Combo025=5.5    Combo026=4    Combo027=2
&{com_discount1}     Combo025=2    Combo026=5000    Combo027=9000
&{com_discount1_type}    Combo025=dis    Combo026=disvnd    Combo027=changeup
&{com_product1_type}    Combo025=com    Combo026=com    Combo027=com
# Dich vu
&{ser_invoice_1}      DV025=5.6    DV026=4    DV027=5
&{ser_discount_1}     DV025=5000    DV026=10    DV027=0
&{ser_discount1_type}    DV025=disvnd    DV026=dis    DV027=none
&{ser_product1_type}    DV025=ser    DV026=ser    DV027=ser
# HH thường
&{nor_invoice_1}      PIB10001=5.6    PIB10002=4    PIB10003=5.2
&{nor_discount1}    PIB10001=5    PIB10002=8500    PIB10003=65400
&{nor_discount_type1}     PIB10001=dis    PIB10002=disvnd    PIB10003=changedown
&{nor_product1_type}     PIB10001=pro    PIB10002=pro    PIB10003=pro
## HH dvt
&{unit_invoice_1}      DVT0101=5.6    QD007=4    DVT0202=1
&{unit_discount1}      DVT0101=9    QD007=4000    DVT0202=47499.75
&{unit_discount_type1}    DVT0101=dis    QD007=disvnd    DVT0202=changedown
&{unit_product1_type}    DVT0101=pro    QD007=unit    DVT0202=pro    
## Serial
&{im_invoice1}    IM01=1    IM02=3    IM03=1
&{im_discount_1}     IM01=10000    IM02=30    IM03=395000.39
&{im_discount_type1}     IM01=disvnd    IM02=dis    IM03=changeup
&{im_product_type_1}     IM01=imei    IM02=imei    IM03=imei

*** Test Cases ***    Product and num list         Product Type       Product Discount      Discount Type          Customer         Payment       Invoice Discount      Invoice Discount Type
All                   [Tags]                  AEB
                      [Template]              eteall
                      ${invoice_1}            ${product_type1}          ${discount_1}         ${discount_type1}          KH006       0         5          5            # nếu giảm giá hóa đơn theo % thì giá trị của Invoice discount type là chính nó, nếu giảm giá theo VND hoặc không giảm giá thì giá trị là null
                      ${com_invoice1}            ${com_product1_type}          ${com_discount1}         ${com_discount1_type}          KH002       all         50000          null
                      ${ser_invoice_1}            ${ser_product1_type}          ${ser_discount_1}         ${ser_discount1_type}          KH003       60000          0          null
                      ${nor_invoice_1}            ${nor_product1_type}          ${nor_discount1}         ${nor_discount_type1}          KH004       90000          6          6
                      ${unit_invoice_1}            ${unit_product1_type}          ${unit_discount1}         ${unit_discount_type1}          KH005       90000          0          null
                      ${im_invoice1}            ${im_product_type_1}          ${im_discount_1}         ${im_discount_type1}          KH006       all          400000          null


*** Keywords ***
eteall
    [Arguments]    ${dict_product_num}     ${dict_product_type}     ${dict_discount}      ${dict_discount_type}      ${input_bh_ma_kh}    ${input_bh_khachtt}      ${input_invoice_discount}       ${input_invoice_discount_type}
    [Timeout]
    ## Get info ton cuoi, cong no khach hang
    Log      Get info ton cuoi, cong no khach hang
    ${list_products}    Get Dictionary Keys    ${dict_product_num}
    ${list_nums}    Get Dictionary Values    ${dict_product_num}
    ${list_product_type}    Get Dictionary Values    ${dict_product_type}
    ${list_discount_product}    Get Dictionary Values    ${dict_discount}
    ${list_discount_type}    Get Dictionary Values    ${dict_discount_type}
    ${list_unit}       Get list of keys from dictionary by value    ${dict_product_type}      unit
    ${list_imei_product}       Get list of keys from dictionary by value    ${dict_product_type}      imei
    ${list_unit_quan}       Get list of values from dictionary by list of keys    ${dict_product_num}    ${list_unit}
    ${get_no_bf_execute}    ${get_tongban_bf_execute}    ${get_tongban_tru_trahang_bf_execute}    Get Customer Debt from API    ${input_bh_ma_kh}
    Log      Create list imei for imei products
    ${list_imei_all}    create list
    : FOR    ${item_product}     ${item_num}    ${item_product_type}    IN ZIP    ${list_products}    ${list_nums}      ${list_product_type}
    \    ${list_imei_by_single_product}=      Run Keyword If    '${item_product_type}' == 'imei'      Import multi imei for product    ${item_product}    ${item_num}      ELSE      Set Variable    nonimei
    \    Append to List       ${list_imei_all}        ${list_imei_by_single_product}
    Log       ${list_imei_all}
    ${list_imei_for_validation}      Copy list      ${list_imei_all}
    Remove values From List      ${list_imei_for_validation}        nonimei
    Log       Remove combo and unit from validation list
    ${list_product_for_validation}       ${list_product_quan_for_validation}     ${list_product_type_for_validation}       Remove combo and unit from validation lists    ${list_products}    ${list_nums}    ${list_product_type}
    ${list_product_for_validation}       ${list_product_quan_for_validation}     ${list_product_type_for_validation}       Extract combo and unit products for validation lists        ${list_products}    ${list_nums}    ${list_product_type}       ${list_product_for_validation}       ${list_product_quan_for_validation}     ${list_product_type_for_validation}
    ${list_result_ton_af_ex}        Get list of result onhand incase changing product price    ${list_product_for_validation}    ${list_product_quan_for_validation}
    ${list_product_id}      ${get_list_baseprice}       ${list_result_product_discount}     ${list_result_newprice}       ${list_result_totalsale}    Get list of product id - baseprice - result product discount - result new price - total sale incase changing product price    ${list_products}    ${list_nums}    ${list_discount_product}      ${list_discount_type}
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
    Log      Post request BH
    ${liststring_prs_invoice_detail}     Create json for Invoice Details     ${list_product_id}       ${list_product_type}      ${get_list_baseprice}      ${list_nums}       ${list_discount_product}        ${list_result_product_discount}        ${list_discount_type}       ${list_imei_all}
    ${request_payload}    Format String    {{"Invoice":{{"BranchId":{0},"RetailerId":{1},"CustomerId":{2},"SoldById":{3},"SoldBy":{{"CreatedBy":0,"CreatedDate":"2018-12-10T10:42:37.447Z","Email":"","GivenName":"admin","Id":{3},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false}},"SaleChannelId":0,"Seller":{{"CreatedBy":0,"CreatedDate":"2018-12-10T10:42:37.447Z","Email":"","GivenName":"admin","Id":{3},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false}},"OrderCode":"","Code":"Hóa đơn 1","Discount":{4},"DiscountRatio":{5},"InvoiceDetails":[{6}],"InvoiceOrderSurcharges":[],"InvoicePromotions":[],"Payments":[{{"Method":"Cash","MethodStr":"Tiền mặt","Amount":{8},"Id":-1}}],"Status":1,"Total":{7},"Surcharge":0,"Type":1,"Uuid":"","addToAccount":"0","addToAccountSurplus":"0","PayingAmount":{8},"TotalBeforeDiscount":2170500,"ProductDiscount":1268000,"DebugUuid":"","InvoiceWarranties":[],"CreatedBy":196750}}}}    ${BRANCH_ID}    ${get_id_nguoitao}    ${get_id_kh}    ${get_id_nguoiban}     ${result_gghd}    ${input_invoice_discount_type}       ${liststring_prs_invoice_detail}      ${result_khachcantra}      ${actual_khachtt}
    Log    ${request_payload}
    ${get_curent_date_1}    Get Current Date
    ${invoice_code}    Post request to create invoice and get invoice code    ${request_payload}
    Sleep      5 s
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
    Delete invoice by invoice code    ${invoice_code}
