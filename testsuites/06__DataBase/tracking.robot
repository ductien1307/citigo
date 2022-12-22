*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}      ${headless_browser}
Library           DatabaseLibrary
Resource          ../../../../core/Ban_Hang/banhang_action.robot
Resource          ../../../../core/Ban_Hang/banhang_getandcompute.robot
Resource          ../../../../core/share/toast_message.robot
Resource          ../../../../core/Ban_Hang/banhang_navigation.robot
Resource          ../../../../core/API/api_danhmuc_hanghoa.robot
Resource          ../../../../core/API/api_mhbh.robot
Resource          ../../../../core/API/api_hoadon_banhang.robot
Resource          ../../../../core/API/api_soquy.robot
Resource          ../../../../core/So_Quy/so_quy_list_action.robot
Resource          ../../config/env_product/envi.robot
Resource          ../../../../core/share/list_dictionary.robot

*** Variables ***
&{invoice_1}      PIB10007=5.6    IM07=4    DVT0103=3    QD015=2       Combo029=1       DV027=3               # QD002: giá bán bằng 0
&{discount_1}      PIB10007=5    IM07=4000    DVT0103=59899.67    QD015=0       Combo029=190000       DV027=20
&{discount_type1}      PIB10007=dis    IM07=disvnd    DVT0103=changeup    QD015=none       Combo029=changedown       DV027=dis
&{product_type1}      PIB10007=pro    IM07=imei    DVT0103=pro    QD015=unit       Combo029=com       DV027=ser
# combo
*** Test Cases ***    Product and num list         Product Type       Product Discount      Discount Type        Invoice Discount    Customer    Payment
Tracking invoice       [Tags]                TRA
                      [Template]              tracking_invoice
                      ${invoice_1}            ${product_type1}          ${discount_1}         ${discount_type1}          KH006       0         5          5            # nếu giảm giá hóa đơn theo % thì giá trị của Invoice discount type là chính nó, nếu giảm giá theo VND hoặc không giảm giá thì giá trị là null

*** Keywords ***
tracking_invoice
      [Arguments]    ${dict_product_num}     ${dict_product_type}     ${dict_discount}      ${dict_discount_type}      ${input_bh_ma_kh}    ${input_bh_khachtt}      ${input_invoice_discount}       ${input_invoice_discount_type}
      ${list_products}    Get Dictionary Keys    ${dict_product_num}
      ${list_nums}    Get Dictionary Values    ${dict_product_num}
      ${list_product_type}    Get Dictionary Values    ${dict_product_type}
      ${list_discount_product}    Get Dictionary Values    ${dict_discount}
      ${list_discount_type}    Get Dictionary Values    ${dict_discount_type}
      ${list_unit}       Get list of keys from dictionary by value    ${dict_product_type}      unit
      ${list_imei_product}       Get list of keys from dictionary by value    ${dict_product_type}      imei
      ${list_unit_quan}       Get list of values from dictionary by list of keys    ${dict_product_num}    ${list_unit}
      Log      Create list imei for imei products
      ${list_imei_all}    create list
      : FOR    ${item_product}     ${item_num}    ${item_product_type}    IN ZIP    ${list_products}    ${list_nums}      ${list_product_type}
      \    ${list_imei_by_single_product}=      Run Keyword If    '${item_product_type}' == 'imei'      Import multi imei for product    ${item_product}    ${item_num}      ELSE      Set Variable    nonimei
      \    Append to List       ${list_imei_all}        ${list_imei_by_single_product}
      Log       ${list_imei_all}
      ${list_imei_for_validation}      Copy list      ${list_imei_all}
      Remove values From List      ${list_imei_for_validation}        nonimei
      Log       Remove combo and unit from validation list
      ${list_product_id}      ${get_list_baseprice}       ${list_result_product_discount}     ${list_result_newprice}       ${list_result_totalsale}    Get list of product id - baseprice - result product discount - result new price - total sale incase changing product price    ${list_products}    ${list_nums}    ${list_discount_product}      ${list_discount_type}
      ##
      ${get_id_nguoitao}    Get RetailerID
      ${get_id_nguoiban}    Get User ID
      ${jsonpath_id_kh}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_bh_ma_kh}
      ${get_id_kh}    Get data from API    ${endpoint_khachhang}    ${jsonpath_id_kh}
      ${giamgia_hd}    Set Variable If    0 < ${input_invoice_discount} < 100    ${input_invoice_discount}    null
      ${result_tongtienhang}    Sum values in list    ${list_result_totalsale}
      ${result_khachcantra}=    Run Keyword If    0 < ${input_invoice_discount} < 100    Price after % discount invoice    ${result_tongtienhang}    ${input_invoice_discount}
      ...    ELSE IF    ${input_invoice_discount} > 100    Minus    ${result_tongtienhang}    ${input_invoice_discount}
      ...    ELSE    Set Variable    ${result_tongtienhang}
      ${result_gghd}    Run Keyword If    0 < ${input_invoice_discount} < 100    Convert % discount to VND    ${result_tongtienhang}    ${input_invoice_discount}
      ...    ELSE    Set Variable    ${input_invoice_discount}
      ${result_discount_invoice}    Run Keyword If    0 < ${input_invoice_discount} < 100    Convert % discount to VND and round    ${result_tongtienhang}    ${input_invoice_discount}
      ...    ELSE    Set Variable    ${input_invoice_discount}
      ${actual_khachtt}    Set Variable If    '${input_bh_khachtt}' == 'all'    ${result_khachcantra}    ${input_bh_khachtt}
      ${result_no_hoadon}    Minus    ${result_khachcantra}    ${actual_khachtt}
      #${result_nohientai}    sum    ${result_no_hoadon}    ${get_no_bf_execute}
      #${result_tongban}    Sum    ${result_khachcantra}    ${get_tongban_bf_execute}
      Log      Post request BH
      ${liststring_prs_invoice_detail}     Create json for Invoice Details     ${list_product_id}       ${list_product_type}      ${get_list_baseprice}      ${list_nums}       ${list_discount_product}        ${list_result_product_discount}        ${list_discount_type}       ${list_imei_all}
      ${request_payload}    Format String    {{"Invoice":{{"BranchId":{0},"RetailerId":{1},"CustomerId":{2},"SoldById":{3},"SoldBy":{{"CreatedBy":0,"CreatedDate":"2018-12-10T10:42:37.447Z","Email":"","GivenName":"admin","Id":{3},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false}},"SaleChannelId":0,"Seller":{{"CreatedBy":0,"CreatedDate":"2018-12-10T10:42:37.447Z","Email":"","GivenName":"admin","Id":{3},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false}},"OrderCode":"","Code":"Hóa đơn 1","Discount":{4},"DiscountRatio":{5},"InvoiceDetails":[{6}],"InvoiceOrderSurcharges":[],"InvoicePromotions":[],"Payments":[{{"Method":"Cash","MethodStr":"Tiền mặt","Amount":{8},"Id":-1}}],"Status":1,"Total":{7},"Surcharge":0,"Type":1,"Uuid":"","addToAccount":"0","addToAccountSurplus":"0","PayingAmount":{8},"TotalBeforeDiscount":2170500,"ProductDiscount":1268000,"DebugUuid":"","InvoiceWarranties":[],"CreatedBy":196750}}}}    ${BRANCH_ID}    ${get_id_nguoitao}    ${get_id_kh}    ${get_id_nguoiban}     ${result_gghd}    ${input_invoice_discount_type}       ${liststring_prs_invoice_detail}      ${result_khachcantra}      ${actual_khachtt}
      Log    ${request_payload}
      ${get_curent_date_1}    Get Current Date
      ${invoice_code}    Post request to create invoice and get invoice code    ${request_payload}
      ${get_curent_date_2}    Get Current Date
      ${time}   Subtract Date From Date    ${get_curent_date_2}    ${get_curent_date_1}
      #connect db
      Sleep      5 s
      Connect To Database     pyodbc       KiotVietOps12   kiotvietdev   C1t1g000$6162   42.112.30.176  22102
      Table Must Exist    Retailer
      @{EventTracking}  Query       select EventIdComputed, DocumentType, DocumentCode, Status from EventTracking where RetailerId=${get_id_nguoitao} and DocumentCode like '%${invoice_code}%'
      Log Many    @{EventTracking}
      ${rowcount_eventracking}  Row Count    select * from EventTracking where RetailerId=${get_id_nguoitao} and DocumentCode like '%${invoice_code}%'
      Log      ${rowcount_eventracking}
      @{EventTrackingDetail}  Query        select * from EventTrackingDetail where RetailerId=${get_id_nguoitao} and DocumentCode like'%${invoice_code}%'
      Log Many    @{EventTrackingDetail}
      ${list_eventid_byrecords}      Get list from composite list by index    ${EventTracking}    0
      ${list_eventid}      Remove Duplicates       ${list_eventid_byrecords}
      Log Many    ${list_eventid}
      Delete invoice by invoice code    ${invoice_code}
