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
&{invoice_1}      PIB10034=5.6    IM17=1
&{invoice_2}      PIB10034=5
&{discount_1}      PIB10034=5    IM17=4000
&{discount_2}      PIB10034=1150000
&{discount_type1}      PIB10034=dis    IM17=none
&{discount_type2}      PIB10034=changedown
&{product_type1}      PIB10034=pro    IM17=imei
&{product_type2}      PIB10034=pro

*** Test Cases ***    Product and num list    Product Discount                                                    Invoice Discount    Invoice Discount Type     Customer    Payment    Promotion Code
KM HD_HH_GiamgiaHD          [Tags]           ACBPPI
                      [Template]              akm_inv_prod_1213
                      ${invoice_1}            ${product_type1}          ${discount_1}         ${discount_type1}          5             5        KH031        0            KM012
                      ${invoice_2}            ${product_type2}          ${discount_2}         ${discount_type2}          10000           null          KH031        all            KM013

*** Keywords ***
akm_inv_prod_1213
    [Arguments]    ${dict_product_num}    ${dict_product_type}      ${dict_discount}      ${dict_discount_type}      ${input_invoice_discount}    ${input_invoice_discount_type}       ${input_bh_ma_kh}    ${input_bh_khachtt}     ${input_khuyemmai}
    Toggle status of promotion    ${input_khuyemmai}    1
    ${invoice_value}    ${discount}    ${discount_ratio}    ${name}     ${promotion_sale_id}       ${promotion_id}        Get Invoice value - Discounts - Promotion Name - Promotion Sale - Id from Promotion Code     ${input_khuyemmai}
    ${list_products}    Get Dictionary Keys    ${dict_product_num}
    ${list_nums}    Get Dictionary Values    ${dict_product_num}
    ${list_product_type}    Get Dictionary Values    ${dict_product_type}
    ${list_discount_product}    Get Dictionary Values    ${dict_discount}
    ${list_discount_type}    Get Dictionary Values    ${dict_discount_type}
    ${list_unit}       Get list of keys from dictionary by value    ${dict_product_type}      unit
    ${list_imei_product}       Get list of keys from dictionary by value    ${dict_product_type}      imei
    ${list_unit_quan}=       Get list of values from dictionary by list of keys    ${dict_product_num}    ${list_unit}
    ${get_no_bf_execute}    ${get_tongban_bf_execute}    ${get_tongban_tru_trahang_bf_execute}    ${get_customer_name}    Get Customer Info from API    ${input_bh_ma_kh}
    Log      Create list imei for imei products
    ${list_imei_all}    create list
    : FOR    ${item_product}     ${item_num}    ${item_product_type}    IN ZIP    ${list_products}    ${list_nums}      ${list_product_type}
    \    ${list_imei_by_single_product}      Run Keyword If    '${item_product_type}' == 'imei'      Import multi imei for product    ${item_product}    ${item_num}      ELSE      Set Variable    nonimei
    \    Append to List       ${list_imei_all}        ${list_imei_by_single_product}
    Log       ${list_imei_all}
    ${list_imei_for_validation}      Copy list      ${list_imei_all}
    Remove values From List      ${list_imei_for_validation}        nonimei
    ${list_product_for_validation}       ${list_product_quan_for_validation}     ${list_product_type_for_validation}       Remove combo and unit from validation lists    ${list_products}    ${list_nums}    ${list_product_type}
    ${list_product_for_validation}       ${list_product_quan_for_validation}     ${list_product_type_for_validation}       Extract combo and unit products for validation lists        ${list_products}    ${list_nums}    ${list_product_type}       ${list_product_for_validation}       ${list_product_quan_for_validation}     ${list_product_type_for_validation}
    ${list_result_ton_af_ex}        Get list of result onhand incase changing product price    ${list_product_for_validation}    ${list_product_quan_for_validation}
    ${list_result_thanhtien}      ${list_result_newprice}    Get list of total sale - result new price incase changing product price    ${list_products}    ${list_nums}    ${list_discount_product}      ${list_discount_type}
    ${list_product_id}      ${get_list_baseprice}       ${list_result_product_discount}     ${list_result_newprice}       ${list_result_totalsale}    Get list of product id - baseprice - result product discount - result new price - total sale incase changing product price    ${list_products}    ${list_nums}    ${list_discount_product}      ${list_discount_type}
    Sleep     20 s
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${jsonpath_id_kh}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_bh_ma_kh}
    ${get_id_kh}    Get data from API    ${endpoint_khachhang}    ${jsonpath_id_kh}
    ${giamgia_hd}    Set Variable If    0 < ${input_invoice_discount} < 100    ${input_invoice_discount}    null
    ${result_tongtienhang}    Sum values in list    ${list_result_thanhtien}
    ${result_discount_invoice_by_vnd}=    Run Keyword If    0 < ${input_invoice_discount} < 100    Convert % discount to VND and round    ${result_tongtienhang}    ${input_invoice_discount}
    ...    ELSE    Set Variable    ${input_invoice_discount}
    ${actual_promo_discount_value}=    Run Keyword If     ${discount_ratio} != 0      Convert % discount to VND and round    ${result_tongtienhang}    ${discount_ratio}      ELSE     Set Variable    ${discount}
    ${final_discount}=    Run Keyword If    ${result_tongtienhang} > ${invoice_value}    Sum    ${actual_promo_discount_value}    ${result_discount_invoice_by_vnd}
    ...    ELSE    Set Variable    ${result_discount_invoice_by_vnd}
    ${result_khachcantra}    Minus    ${result_tongtienhang}    ${final_discount}
    ${result_gghd}    Run Keyword If    0 < ${input_invoice_discount} < 100    Convert % discount to VND    ${result_tongtienhang}    ${input_invoice_discount}
    ...    ELSE    Set Variable    ${final_discount}
    ${result_af_invoice_discount}    Minus    ${result_tongtienhang}    ${result_discount_invoice_by_vnd}
    ${actual_khachtt}    Set Variable If    '${input_bh_khachtt}' == 'all'    ${result_khachcantra}    ${input_bh_khachtt}
    ${result_no_hoadon}    Minus    ${result_khachcantra}    ${actual_khachtt}
    ${result_nohientai}    sum    ${result_no_hoadon}    ${get_no_bf_execute}
    ${result_tongban}    Sum    ${result_khachcantra}    ${get_tongban_bf_execute}
    # Post request BH
    Log      ${list_product_id}
    Log       ${list_product_type}
    Log       ${get_list_baseprice}
    Log       ${list_nums}
    Log       ${list_result_product_discount}
    Log       ${list_discount_type}
    Log       ${list_discount_type}
    Log       ${list_imei_all}
    #
    ${text_total_invoice}        Convert from number to vnd discount text      ${invoice_value}        000000.0         ,000,000
    ${actual_text_discount}         Run Keyword If    ${discount_ratio} != 0       Convert from number to ratio discount text    ${discount_ratio}       ELSE      Convert from number to vnd discount text      ${discount}        000.0     ,000
    ${first_quan}       Get From Dictionary       ${dict_product_num}         PIB10034
    ${text_promo_info}        Format String      {0}: Tổng tiền hàng từ {3} và mua {1} PIB10034 - Máy ẩm không khí giảm giá {2} cho hóa đơn        ${name}      ${first_quan}        ${actual_text_discount}        ${text_total_invoice}
    # Cal
    ${liststring_prs_invoice_detail}     Create json for Invoice Details     ${list_product_id}       ${list_product_type}      ${get_list_baseprice}      ${list_nums}       ${list_discount_product}        ${list_result_product_discount}        ${list_discount_type}       ${list_imei_all}
    ${request_payload}    Format String    {{"Invoice":{{"BranchId":{0},"RetailerId":{1},"CustomerId":{2},"SoldById":{3},"SoldBy":{{"CreatedBy":0,"CreatedDate":"2018-12-10T10:42:37.447Z","Email":"","GivenName":"admin","Id":{3},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false}},"SaleChannelId":0,"Seller":{{"CreatedBy":0,"CreatedDate":"2018-12-10T10:42:37.447Z","Email":"","GivenName":"admin","Id":{3},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false}},"OrderCode":"","Code":"Hóa đơn 1","Discount":{4},"DiscountRatio":{5},"InvoiceDetails":[{6}],"InvoiceOrderSurcharges":[],"InvoicePromotions":[{{"Type":15,"TargetType":2,"SalePromotionId":{10},"PromotionId":{11},"Discount":200000,"PromotionInfo":"{9}","PrintPromotionInfo":"{9}"}}],"Payments":[{{"Method":"Cash","MethodStr":"Tiền mặt","Amount":{8},"Id":-1}}],"Status":1,"Total":{7},"Surcharge":0,"Type":1,"Uuid":"","addToAccount":"0","addToAccountSurplus":"0","PayingAmount":{8},"TotalBeforeDiscount":2170500,"ProductDiscount":1268000,"DebugUuid":"","InvoiceWarranties":[],"CreatedBy":196750}}}}    ${BRANCH_ID}    ${get_id_nguoitao}    ${get_id_kh}    ${get_id_nguoiban}     ${final_discount}    ${input_invoice_discount_type}      ${liststring_prs_invoice_detail}      ${result_khachcantra}      ${actual_khachtt}        ${text_promo_info}        ${promotion_sale_id}       ${promotion_id}
    Log    ${request_payload}
    ${invoice_code}    Post request to create invoice and get invoice code    ${request_payload}
    #get values
    Sleep    10 s    wait for response to API
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
    Assert list of Onhand after execute in case having multi-product types      ${list_product_for_validation}    ${list_product_type_for_validation}       ${list_result_ton_af_ex}
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
    Delete invoice by invoice code    ${invoice_code}
