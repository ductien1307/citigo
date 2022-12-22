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
Resource          ../../../../core/share/discount.robot
Resource          ../../../../core/API/api_thietlap.robot

*** Variables ***
&{invoice_1}      IM18=2   PIB10035=1     DVT0214=1            #DVT0214 sp promotion
&{invoice_2}      IM18=2    DVT0214=1            #DVT0214 sp promotion
&{invoice_1_giveaway}      	DVT0214=1
&{discount_1}      IM18=5    PIB10035=4000      DVT0214=50000
&{discount_2}      IM18=5    DVT0214=6
&{discount_type1}      IM18=dis   PIB10035=disvnd      DVT0214=disvnd
&{discount_type2}      IM18=dis   DVT0214=dis
&{invoice1_product_type}      IM18=imei   PIB10035=pro    DVT0214=pro
&{invoice2_product_type}      IM18=imei   DVT0214=pro
&{invoice1_promo}      IM18=promo   PIB10035=sale    DVT0214=getpromo
&{invoice2_promo}      IM18=promo   DVT0214=getpromo


*** Test Cases ***    Product and num list    Product Discount                                                    Invoice Discount    Invoice Discount Type        Customer    Payment    Promotion Code          Dict Product Promo
KM HD_HH_GiamgiaHD          [Tags]                ACBPPI
                      [Template]              akm_inv_prod_1516
                      ${invoice_1}            ${invoice1_product_type}          ${discount_1}         ${discount_type1}          5           5         KH032        all            KM015            ${invoice1_promo}
                      ${invoice_2}            ${invoice2_product_type}          ${discount_2}         ${discount_type2}          50000        null          KH032        0            KM016            ${invoice2_promo}

*** Keywords ***
akm_inv_prod_1516
    [Arguments]    ${dict_product_num}    ${dict_product_type}      ${dict_discount}      ${dict_discount_type}      ${input_invoice_discount}    ${input_invoice_discount_type}     ${input_bh_ma_kh}    ${input_bh_khachtt}         ${input_khuyemmai}      ${dict_promo_product}
    [Timeout]
    Toggle status of promotion    ${input_khuyemmai}    1
    ${invoice_value}    ${discount}    ${discount_ratio}    ${name}     ${promotion_sale_id}       ${promotion_id}        Get Invoice value - Product Discounts - Promotion Name - Promotion Id - Campaign Id from Promotion Code     ${input_khuyemmai}
    ${list_products}    Get Dictionary Keys    ${dict_product_num}
    ${list_nums}    Get Dictionary Values    ${dict_product_num}
    ${list_product_type}    Get Dictionary Values    ${dict_product_type}
    ${list_discount_product}    Get Dictionary Values    ${dict_discount}
    ${list_discount_type}    Get Dictionary Values    ${dict_discount_type}
    ${list_promo_product}       Get Dictionary Keys        ${dict_promo_product}
    ${list_promo_type}      Get Dictionary Values       ${dict_promo_product}
    ${get_no_bf_execute}    ${get_tongban_bf_execute}    ${get_tongban_tru_trahang_bf_execute}    ${get_customer_name}    Get Customer Info from API    ${input_bh_ma_kh}
    Log      Create list imei for imei products
    ${list_imei_all}    create list
    : FOR    ${item_product}     ${item_num}    ${item_product_type}    IN ZIP    ${list_products}    ${list_nums}      ${list_product_type}
    \    ${list_imei_by_single_product}=      Run Keyword If    '${item_product_type}' == 'imei'      Import multi imei for product    ${item_product}    ${item_num}      ELSE      Set Variable    nonimei
    \    Append to List       ${list_imei_all}        ${list_imei_by_single_product}
    Log       ${list_imei_all}
    ${list_imei_for_validation}      Copy list      ${list_imei_all}
    Remove values From List      ${list_imei_for_validation}        nonimei
    ${list_product_for_validation}       ${list_product_quan_for_validation}     ${list_product_type_for_validation}       Remove combo and unit from validation lists    ${list_products}    ${list_nums}    ${list_product_type}
    ${list_product_for_validation}       ${list_product_quan_for_validation}     ${list_product_type_for_validation}       Extract combo and unit products for validation lists        ${list_products}    ${list_nums}    ${list_product_type}       ${list_product_for_validation}       ${list_product_quan_for_validation}     ${list_product_type_for_validation}
    ${list_result_ton_af_ex}        Get list of result onhand incase changing product price    ${list_product_for_validation}    ${list_product_quan_for_validation}
    ${list_product_id}      ${get_list_baseprice}       ${list_result_product_discount}     ${list_result_newprice}       ${list_result_totalsale}    Get list of product id - baseprice - result product discount - result new price - total sale incase changing product price    ${list_products}    ${list_nums}    ${list_discount_product}      ${list_discount_type}
    Sleep     10 s
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${jsonpath_id_kh}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_bh_ma_kh}
    ${get_id_kh}    Get data from API    ${endpoint_khachhang}    ${jsonpath_id_kh}
    ${giamgia_hd}    Set Variable If    0 < ${input_invoice_discount} < 100    ${input_invoice_discount}    null
    ${product_promo_id}       Get product id thr API     IM18
    ${list_promo_id_value_payload}        Create List
    : FOR    ${item_promo_type}      IN ZIP     ${list_promo_type}
    \    ${item_promo_id_value}        Run Keyword If    '${item_promo_type}' == 'getpromo'    Set Variable      ${promotion_sale_id}       ELSE      Set Variable     null
    \    Append to list        ${list_promo_id_value_payload}      ${item_promo_id_value}
    ${result_tongtienhang}    Sum values in list    ${list_result_totalsale}
    ${result_discount_invoice_by_vnd}    Run Keyword If    0 < ${input_invoice_discount} < 100    Convert % discount to VND and round    ${result_tongtienhang}    ${input_invoice_discount}
    ...    ELSE    Set Variable    ${input_invoice_discount}
    ${result_khachcantra}    Minus    ${result_tongtienhang}    ${result_discount_invoice_by_vnd}
    ${actual_khachtt}    Set Variable If    '${input_bh_khachtt}' == 'all'    ${result_khachcantra}    ${input_bh_khachtt}
    ${result_no_hoadon}    Minus    ${result_khachcantra}    ${actual_khachtt}
    ${result_nohientai}    sum    ${result_no_hoadon}    ${get_no_bf_execute}
    ${result_tongban}    Sum    ${result_khachcantra}    ${get_tongban_bf_execute}
    ${text_total_invoice}        Convert from number to vnd discount text      ${invoice_value}        000000.0         ,000,000
    ${actual_text_discount}         Run Keyword If    ${discount_ratio} != 0       Convert from number to ratio discount text    ${discount_ratio}       ELSE      Convert from number to vnd discount text      ${discount}        000.0     ,000
    ${first_quan}       Get From Dictionary       ${dict_product_num}         IM18
    ${text_promo_info}        Format String      {0}: Tổng tiền hàng từ {3} và mua {1} IM18 - chuột quang xám giảm giá {2} cho 1 DVT0214 - Bánh Hura Hương Cốm Hộp Demi Bibica        ${name}      ${first_quan}        ${actual_text_discount}        ${text_total_invoice}
    ${liststring_prs_invoice_detail}     Create json in case promotion for Invoice Details     ${list_product_id}       ${list_product_type}      ${get_list_baseprice}      ${list_nums}       ${list_discount_product}        ${list_result_product_discount}        ${list_discount_type}       ${list_imei_all}       ${list_promo_id_value_payload}
    ${request_payload}    Format String    {{"Invoice":{{"BranchId":{0},"RetailerId":{1},"CustomerId":{2},"SoldById":{3},"SoldBy":{{"CreatedBy":0,"CreatedDate":"2018-12-10T10:42:37.447Z","Email":"","GivenName":"admin","Id":{3},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false}},"SaleChannelId":0,"Seller":{{"CreatedBy":0,"CreatedDate":"2018-12-10T10:42:37.447Z","Email":"","GivenName":"admin","Id":{3},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false}},"OrderCode":"","Code":"Hóa đơn 1","Discount":{4},"DiscountRatio":{5},"InvoiceDetails":[{6}],"InvoiceOrderSurcharges":[],"InvoicePromotions":[{{"Type":15,"TargetType":2,"SalePromotionId":{10},"PromotionId":{11},"ProductId": {12},"Discount":200000,"PromotionInfo":"{9}","PrintPromotionInfo":"{9}","ProductIds": "{12}"}}],"Payments":[{{"Method":"Cash","MethodStr":"Tiền mặt","Amount":{8},"Id":-1}}],"Status":1,"Total":{7},"Surcharge":0,"Type":1,"Uuid":"","addToAccount":"0","addToAccountSurplus":"0","PayingAmount":{8},"TotalBeforeDiscount":2170500,"ProductDiscount":1268000,"DebugUuid":"","InvoiceWarranties":[],"CreatedBy":196750}}}}    ${BRANCH_ID}    ${get_id_nguoitao}    ${get_id_kh}    ${get_id_nguoiban}     ${result_discount_invoice_by_vnd}    ${input_invoice_discount_type}      ${liststring_prs_invoice_detail}      ${result_khachcantra}      ${actual_khachtt}        ${text_promo_info}        ${promotion_sale_id}       ${promotion_id}        ${product_promo_id}
    Log    ${request_payload}
    ${invoice_code}    Post request to create invoice and get invoice code    ${request_payload}
    Sleep    20 s    wait for response to API
    #assert values in Hoa don
    ${get_ma_kh_by_hd}    ${get_tong_tien_hang}    ${get_khach_tt}    ${get_giamgia_hd}    ${get_khachcantra}    ${get_trangthai}    Get invoice info incase discount by invoice code
    ...    ${invoice_code}
    Should Be Equal As Numbers    ${get_tong_tien_hang}    ${result_tongtienhang}
    Should Be Equal As Numbers    ${get_khachcantra}    ${result_khachcantra}
    Should Be Equal As Numbers    ${get_khach_tt}    ${actual_khachtt}
    Should Be Equal As Strings    ${get_ma_kh_by_hd}    ${input_bh_ma_kh}
    Should Be Equal As Numbers    ${get_giamgia_hd}    ${result_discount_invoice_by_vnd}
    Should Be Equal As Strings    ${get_trangthai}    Hoàn thành
    #Assert values in product list and stock card
    Assert list of Onhand after execute in case having multi-product types      ${list_product_for_validation}    ${list_product_type_for_validation}       ${list_result_ton_af_ex}
    Toggle status of promotion    ${input_khuyemmai}    0
    #Delete invoice by invoice code    ${invoice_code}
