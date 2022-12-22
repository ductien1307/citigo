*** Settings ***
Library           Collections
Library           RequestsLibrary
Library           SeleniumLibrary
Library           OperatingSystem
Library           String
Library           JSONLibrary
Library           StringFormat
Library           DateTime
Resource          ../share/computation.robot
Resource          api_danhmuc_hanghoa.robot
Resource          api_doi_tac_giaohang.robot
Resource          api_hoadon_banhang.robot
Resource          api_khachhang.robot
Resource          api_thietlapgia.robot
Resource          ../share/imei.robot
Resource          api_access.robot
Resource          api_dathang.robot

*** Variables ***
${endpoint_delete_hd}    /invoices/{0}?CompareCode={1}&IsVoidPayment=true    #0: id hóa đơn - 1: mã hd
${endpoint_delete_dh}    /orders/{0}?CompareCode={1}&IsVoidPayment=false    #id dat hang, ma dat hang
${endpoint_phanbo_mhbh}    /customers/{0}/surplusallocation?24inlinecount=allpages&%24top=300    #id khách hàng

*** Keywords ***
Add new invoice no payment frm API
    [Arguments]    ${input_ma_kh}    ${dic_product_num}
    ${Uuid}      Generate Random String    4    [NUMBERS][NUMBERS]
    ${Uuid_code}      Catenate      SEPARATOR=      WA     ${Uuid}
    ${input_ma_hang}    Get Dictionary Keys    ${dic_product_num}
    ${input_soluong}    Get Dictionary Values    ${dic_product_num}
    ${input_ma_hang}    Convert list to string and return    ${input_ma_hang}
    ${input_soluong}    Convert list to string and return    ${input_soluong}
    ${jsonpath_id_kh}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_kh}
    ${jsonpath_id_sp}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_hang}
    ${jsonpath_gia_ban}    Format String    $..Data[?(@.Code == '{0}')].BasePrice    ${input_ma_hang}
    ${get_id_kh}    Get data from API by BranchID    ${BRANCH_ID}    ${endpoint_khachhang}    ${jsonpath_id_kh}
    ${endpoint_danhmuc_hh_co_dvt}    Format String    ${endpoint_list_hh_in_mhbh}    ${BRANCH_ID}    ${BRANCH_ID}
    ${get_resp_danhmuc_hh}    Get Request and return body    ${endpoint_danhmuc_hh_co_dvt}
    ${get_id_sp}    Get data from response json    ${get_resp_danhmuc_hh}    ${jsonpath_id_sp}
    ${get_gia_ban}    Get data from response json    ${get_resp_danhmuc_hh}    ${jsonpath_gia_ban}
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${request_payload}    Format String    {{"Invoice":{{"BranchId":{0},"RetailerId":{1},"CustomerId":{2},"SoldById":{3},"SoldBy":{{"CreatedBy":0,"CreatedDate":"2018-12-10T10:42:37.447Z","Email":"","GivenName":"admin","Id":{4},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false}},"SaleChannelId":0,"Seller":{{"CreatedBy":0,"CreatedDate":"2018-12-10T10:42:37.447Z","Email":"","GivenName":"admin","Id":{5},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false}},"OrderCode":"","Code":"Hóa đơn 1","InvoiceDetails":[{{"BasePrice":78000,"IsLotSerialControl":false,"IsRewardPoint":false,"Note":"","Price":{6},"ProductId":{7},"Quantity":{8},"ProductCode":"HH0123","ProductName":"Bánh trứng Belgi","SalePromotionId":null,"PriceByPromotion":null,"PromotionParentProductId":null,"ProductBatchExpireId":null,"CategoryId":795901,"MasterProductId":16094444,"Unit":"","Uuid":"","ProductWarranty":[]}}],"InvoiceOrderSurcharges":[],"InvoicePromotions":[],"Payments":[],"Status":1,"Total":15600000,"Surcharge":0,"Type":1,"Uuid":"{9}","addToAccount":"0","PayingAmount":0,"TotalBeforeDiscount":15600000,"ProductDiscount":0,"DebugUuid":"","InvoiceWarranties":[],"CreatedBy":196750}}}}    ${BRANCH_ID}    ${get_id_nguoitao}    ${get_id_kh}    ${get_id_nguoiban}
    ...    ${get_id_nguoiban}    ${get_id_nguoiban}    ${get_gia_ban}    ${get_id_sp}    ${input_soluong}    ${Uuid_code}
    Log    ${request_payload}
    ${invoice_code}    Post request to create invoice and get invoice code    ${request_payload}
    Return From Keyword    ${invoice_code}

Add new invoice frm API
    [Arguments]    ${input_ma_kh}    ${dic_product_num}    ${input_khtt}
    ${Uuid}      Generate Random String    4    [NUMBERS][NUMBERS]
    ${Uuid_code}      Catenate      SEPARATOR=      WA     ${Uuid}
    ${input_ma_hang}    Get Dictionary Keys    ${dic_product_num}
    ${input_soluong}    Get Dictionary Values    ${dic_product_num}
    ${input_ma_hang}    Convert list to string and return    ${input_ma_hang}
    ${input_soluong}    Convert list to string and return    ${input_soluong}
    ${jsonpath_id_kh}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_kh}
    ${jsonpath_id_sp}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_hang}
    ${jsonpath_gia_ban}    Format String    $..Data[?(@.Code == '{0}')].BasePrice    ${input_ma_hang}
    ${get_id_kh}    Get data from API     ${endpoint_khachhang}    ${jsonpath_id_kh}
    ${endpoint_danhmuc_hh_co_dvt}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${get_resp}     Get Request and return body    ${endpoint_danhmuc_hh_co_dvt}
    ${get_id_sp}    Get data from response json     ${get_resp}    ${jsonpath_id_sp}
    ${get_gia_ban}   Get data from response json     ${get_resp}    ${jsonpath_gia_ban}
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${result_thanhtien}    Multiplication and round    ${get_gia_ban}    ${input_soluong}
    ${resull_khtt_all}    Set Variable If    '${input_khtt}' == 'all'    ${result_thanhtien}    ${input_khtt}
    ${request_payload}    Format String    {{"Invoice":{{"BranchId":{0},"RetailerId":{1},"CustomerId":{2},"SoldById":{3},"SoldBy":{{"CreatedBy":0,"CreatedDate":"2018-07-30T08:27:36.800Z","Email":"","GivenName":"anh.lv","Id":{4},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false}},"SaleChannelId":0,"SaleChannel":null,"Seller":{{"CreatedBy":0,"CreatedDate":"2018-07-30T08:27:36.800Z","Email":"","GivenName":"anh.lv","Id":{5},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false}},"OrderCode":"","Code":"Hóa đơn 1","InvoiceDetails":[{{"BasePrice":200000,"IsLotSerialControl":false,"IsRewardPoint":false,"Note":"","Price":{6},"ProductId":{7},"Quantity":{8},"ProductCode":"Combo01","ProductName":"Set nước hoa Vial 01","SalePromotionId":null,"PriceByPromotion":null,"PromotionParentProductId":null,"ProductBatchExpireId":null,"CategoryId":680823,"MasterProductId":15128664,"Unit":"","Uuid":"","ProductWarranty":[]}}],"InvoiceOrderSurcharges":[],"InvoicePromotions":[],"Payments":[{{"Method":"Cash","MethodStr":"Tiền mặt","Amount":{9},"Id":-1}}],"Status":1,"Total":200000,"Surcharge":0,"Type":1,"Uuid":"{10}","addToAccount":"0","PayingAmount":0,"TotalBeforeDiscount":200000,"ProductDiscount":0,"DebugUuid":"","InvoiceWarranties":[],"CreatedBy":201567}}}}    ${BRANCH_ID}    ${get_id_nguoitao}    ${get_id_kh}    ${get_id_nguoiban}
    ...    ${get_id_nguoiban}    ${get_id_nguoiban}    ${get_gia_ban}    ${get_id_sp}    ${input_soluong}    ${resull_khtt_all}    ${Uuid_code}
    Log    ${request_payload}
    ${invoice_code}    Post request to create invoice and get invoice code    ${request_payload}
    Return From Keyword    ${invoice_code}

Create invoice incl one product frm API
    [Arguments]    ${list_product_code}    ${list_quantity}    ${customer_code}    ${cus_payment}
    ${Uuid}      Generate Random String    4    [NUMBERS][NUMBERS]
    ${Uuid_code}      Catenate      SEPARATOR=      WA     ${Uuid}
    ${product_code}    Get From List    ${list_product_code}    0
    ${quantity}    Get From List    ${list_quantity}    0
    ${jsonpath_id_kh}    Format String    $..Data[?(@.Code == '{0}')].Id    ${customer_code}
    ${jsonpath_id_sp}    Format String    $..Data[?(@.Code == '{0}')].Id    ${product_code}
    ${jsonpath_gia_ban}    Format String    $..Data[?(@.Code == '{0}')].BasePrice    ${product_code}
    ${get_id_kh}    Get data from API by BranchID    ${BRANCH_ID}    ${endpoint_khachhang}    ${jsonpath_id_kh}
    ${endpoint_danhmuc_hh_co_dvt}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${get_id_sp}    Get data from API by BranchID    ${BRANCH_ID}    ${endpoint_danhmuc_hh_co_dvt}    ${jsonpath_id_sp}
    ${get_gia_ban}    Get data from API by BranchID    ${BRANCH_ID}    ${endpoint_danhmuc_hh_co_dvt}    ${jsonpath_gia_ban}
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${result_thanhtien}    Multiplication and round    ${get_gia_ban}    ${quantity}
    ${resull_khtt_all}    Set Variable If    '${cus_payment}' == 'all'    ${result_thanhtien}    ${cus_payment}
    ${request_payload}    Format String    {{"Invoice":{{"BranchId":{0},"RetailerId":{1},"CustomerId":{2},"SoldById":{3},"SoldBy":{{"CreatedBy":0,"CreatedDate":"2018-07-30T08:27:36.800Z","Email":"","GivenName":"anh.lv","Id":{4},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false}},"SaleChannelId":0,"SaleChannel":null,"Seller":{{"CreatedBy":0,"CreatedDate":"2018-07-30T08:27:36.800Z","Email":"","GivenName":"anh.lv","Id":{5},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false}},"OrderCode":"","Code":"Hóa đơn 1","InvoiceDetails":[{{"BasePrice":200000,"IsLotSerialControl":false,"IsRewardPoint":false,"Note":"","Price":{6},"ProductId":{7},"Quantity":{8},"ProductCode":"Combo01","ProductName":"Set nước hoa Vial 01","SalePromotionId":null,"PriceByPromotion":null,"PromotionParentProductId":null,"ProductBatchExpireId":null,"CategoryId":680823,"MasterProductId":15128664,"Unit":"","Uuid":"","ProductWarranty":[]}}],"InvoiceOrderSurcharges":[],"InvoicePromotions":[],"Payments":[{{"Method":"Cash","MethodStr":"Tiền mặt","Amount":{9},"Id":-1}}],"Status":1,"Total":200000,"Surcharge":0,"Type":1,"Uuid":"{10}","addToAccount":"0","PayingAmount":0,"TotalBeforeDiscount":200000,"ProductDiscount":0,"DebugUuid":"","InvoiceWarranties":[],"CreatedBy":201567}}}}    ${BRANCH_ID}    ${get_id_nguoitao}    ${get_id_kh}    ${get_id_nguoiban}
    ...    ${get_id_nguoiban}    ${get_id_nguoiban}    ${get_gia_ban}    ${get_id_sp}    ${quantity}    ${resull_khtt_all}    ${Uuid_code}
    Log    ${request_payload}
    ${invoice_code}    Post request to create invoice and get invoice code    ${request_payload}
    Return From Keyword    ${invoice_code}

Add new invoice with imei product
    [Arguments]    ${input_ma_kh}    ${input_mahang}    ${input_nums}    ${input_imei}
    ${Uuid}      Generate Random String    4    [NUMBERS][NUMBERS]
    ${Uuid_code}      Catenate      SEPARATOR=      WA     ${Uuid}
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${get_id_kh}    Get customer id thr API    ${input_ma_kh}
    ${endpoint_danhmuc_hh_co_dvt}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${get_resp_danhmuc_hh}    Get Request and return body    ${endpoint_danhmuc_hh_co_dvt}
    ${get_ton}    ${get_gia_ban}    Get Onhand and Baseprice frm API    ${input_mahang}
    ${get_id_sp}    Get product id thr API    ${input_mahang}
    ${result_thanhtien}    Multiplication and round    ${get_gia_ban}    ${input_nums}
    ${input_imei}    Convert list to string and return    ${input_imei}
    ${request_payload}    Format String    {{"Invoice":{{"BranchId":{0},"RetailerId":{1},"CustomerId":{2},"SoldById":{3},"SoldBy":{{"CreatedBy":0,"CreatedDate":"2018-12-06T09:32:16.537Z","Email":"","GivenName":"mimi","Id":{3},"IsActive":true,"IsAdmin":true,"Type":0,"UserName":"admin","isDeleted":false}},"SaleChannelId":0,"Seller":{{"CreatedBy":0,"CreatedDate":"2018-12-06T09:32:16.537Z","Email":"","GivenName":"mimi","Id":{3},"IsActive":true,"IsAdmin":true,"Type":0,"UserName":"admin","isDeleted":false}},"OrderCode":"","Code":"Hóa đơn 1","InvoiceDetails":[{{"BasePrice":299000,"IsLotSerialControl":true,"IsRewardPoint":false,"Note":"","Price":{4},"ProductId":{5},"Quantity":{6},"ProductCode":"SI027","SerialNumbers":"{7}","ProductName":"Bàn Ủi Khô Philips HD1172","PriceByPromotion":null,"PromotionParentProductId":null,"ProductBatchExpireId":null,"CategoryId":13598,"MasterProductId":{5},"Unit":"","Uuid":"","ProductWarranty":[]}}],"InvoiceOrderSurcharges":[],"InvoicePromotions":[],"Payments":[],"Status":1,"Total":{8},"Surcharge":0,"Type":1,"Uuid":"{9}","addToAccount":"0","addToAccountSurplus":"0","addToAccountAllocation":"0","addToAccountPaymentAllocation":"0","PayingAmount":0,"TotalBeforeDiscount":299000,"ProductDiscount":0,"DebugUuid":"","InvoiceWarranties":[],"CreatedBy":1784}}}}    ${BRANCH_ID}    ${get_id_nguoitao}    ${get_id_kh}    ${get_id_nguoiban}
    ...    ${get_gia_ban}    ${get_id_sp}    ${input_nums}    ${input_imei}    ${result_thanhtien}    ${Uuid_code}
    Log    ${request_payload}
    ${invoice_code}    Post request to create invoice and get invoice code    ${request_payload}
    Return From Keyword    ${invoice_code}

Add new invoice incase discount with multi product - no payment - get invoice code
    [Arguments]    ${input_ma_kh}    ${dict_product_nums}    ${list_ggsp}    ${input_gghd}    ${ma_hh_combo}
    ${Uuid}      Generate Random String    4    [NUMBERS][NUMBERS]
    ${Uuid_code}      Catenate      SEPARATOR=      WA     ${Uuid}
    ${list_product_bf}    Get Dictionary Keys    ${dict_product_nums}
    ${list_nums_bf}    Get Dictionary Values    ${dict_product_nums}
    ${list_product}    ${list_nums}    Reverse two lists    ${list_product_bf}    ${list_nums_bf}
    Create list imei and other product    ${list_product}    ${list_nums}
    Sleep    5s
    #get product info
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${jsonpath_id_kh}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_kh}
    ${get_id_kh}    Get data from API    ${endpoint_khachhang}    ${jsonpath_id_kh}
    ${endpoint_danhmuc_hh_co_dvt}    Format String    ${endpoint_list_hh_in_mhbh}    ${BRANCH_ID}    ${BRANCH_ID}
    ${get_resp_danhmuc_hh}    Get Request and return body    ${endpoint_danhmuc_hh_co_dvt}
    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}    Get list jsonpath product frm list product    ${list_product}
    Log    ${list_ggsp}
    ${list_giaban}    ${list_result_ggsp}    ${list_id_sp}    Get product info frm list jsonpath product have discount product    ${get_resp_danhmuc_hh}    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}
    ...    ${list_ggsp}
    ${list_thanhtien_hh}    Create List
    : FOR    ${giaban}    ${soluong}    ${item_ggsp}    IN ZIP    ${list_giaban}    ${list_nums}
    ...    ${list_ggsp}
    \    ${result_giaban_af_discount}    Run Keyword If    0 < ${item_ggsp} < 100    Price after % discount product    ${giaban}    ${item_ggsp}
    \    ...    ELSE IF    ${item_ggsp} > 100    Minus    ${giaban}    ${item_ggsp}
    \    ...    ELSE    Set Variable    ${giaban}
    \    ${result_item_thanhtien}    Multiplication and round    ${result_giaban_af_discount}    ${soluong}
    \    Append To List    ${list_thanhtien_hh}    ${result_item_thanhtien}
    Log    ${list_thanhtien_hh}
    ${result_tongtienhang}    Sum values in list    ${list_thanhtien_hh}
    ${giamgia_hd}    Set Variable If    0 < ${input_gghd} < 100    ${input_gghd}    null
    ${result_gghd}    Run Keyword If    0 < ${input_gghd} < 100    Convert % discount to VND    ${result_tongtienhang}    ${input_gghd}
    ...    ELSE    Set Variable    ${input_gghd}
    ${list_ggsp_bf}    ${list_thanhtien_hh_bf}    Reverse two lists    ${list_result_ggsp}    ${list_thanhtien_hh}
    Set Test Variable    \${list_ggsp_bf}    ${list_ggsp_bf}
    Set Test Variable    \${list_thanhtien_hh_bf}    ${list_thanhtien_hh_bf}
    #post request
    ${liststring_prs_invoice_detail}    Set Variable    needdel
    Log    ${liststring_prs_invoice_detail}
    : FOR    ${item_gia_ban}    ${item_id_sp}    ${item_soluong}    ${item_imei}    ${item_result_ggsp}    ${item_ggsp}
    ...    ${item_pr}    IN ZIP    ${list_giaban}    ${list_id_sp}    ${list_nums}    ${imei_inlist}
    ...    ${list_result_ggsp}    ${list_ggsp}    ${list_product}
    \    ${item_imei}    Convert list to string and return    ${item_imei}
    \    ${item_ggsp}    Set Variable If    0 < ${item_ggsp} < 100    ${item_ggsp}    0
    \    ${payload_each_product}    Format string    {{"BasePrice":1000000,"IsLotSerialControl":true,"IsRewardPoint":true,"Price":{0},"ProductId":{1},"Quantity":{2},"ProductCode":"{6}","SerialNumbers":"{3}","Weight":0,"Discount":{4},"DiscountRatio":{5},"ProductName":"Điện thoại A","SalePromotionId":null,"PriceByPromotion":null,"PromotionParentProductId":null,"ProductBatchExpireId":null,"CategoryId":439203,"MasterProductId":{1},"Unit":"","Uuid":"","ProductWarranty":[]}}    ${item_gia_ban}    ${item_id_sp}    ${item_soluong}
    \    ...    ${item_imei}    ${item_result_ggsp}    ${item_ggsp}    ${item_pr}
    \    ${liststring_prs_invoice_detail}    Catenate    SEPARATOR=,    ${liststring_prs_invoice_detail}    ${payload_each_product}
    ${liststring_prs_invoice_detail}    Replace String    ${liststring_prs_invoice_detail}    needdel,    ${EMPTY}    count=1
    ${request_payload}    Format String    {{"Invoice":{{"BranchId":{0},"RetailerId":{1},"CustomerId":{2},"SoldById":{3},"SoldBy":{{"CreatedBy":0,"CreatedDate":"2017-04-24T11:33:52.877Z","Email":"ngokanh610@gmail.com","GivenName":"TestShard53","Id":{3},"IsActive":true,"IsAdmin":true,"Type":0,"UserName":"admin"}},"SaleChannelId":0,"Seller":{{"CreatedBy":0,"CreatedDate":"2017-04-24T11:33:52.877Z","Email":"ngokanh610@gmail.com","GivenName":"TestShard53","Id":{3},"IsActive":true,"IsAdmin":true,"Type":0,"UserName":"admin"}},"OrderCode":"","Code":"Hóa đơn 1","Discount":{4},"DiscountRatio":{5},"InvoiceDetails":[{6}],"InvoiceOrderSurcharges":[],"InvoicePromotions":[],"Payments":[],"Status":1,"Total":2129584,"Surcharge":0,"Type":1,"Uuid":"{7}","addToAccount":"0","PayingAmount":2129584,"TotalBeforeDiscount":3513115,"ProductDiscount":747422,"DebugUuid":"","InvoiceWarranties":[],"CreatedBy":2}}}}    ${BRANCH_ID}    ${get_id_nguoitao}    ${get_id_kh}    ${get_id_nguoiban}
    ...    ${result_gghd}    ${giamgia_hd}    ${liststring_prs_invoice_detail}    ${Uuid_code}
    Log    ${request_payload}
    ${invoice_code}    Post request to create invoice and get invoice code    ${request_payload}
    Return From Keyword    ${invoice_code}

Add new invoice incase newprice with multi product - get invoice code
    [Arguments]    ${input_ma_kh}    ${dict_product_nums}    ${list_newprice}    ${input_gghd}    ${ma_hh_combo}    ${input_khtt}
    ${Uuid}      Generate Random String    4    [NUMBERS][NUMBERS]
    ${Uuid_code}      Catenate      SEPARATOR=      WA     ${Uuid}
    ${list_product}    Get Dictionary Keys    ${dict_product_nums}
    ${list_nums}    Get Dictionary Values    ${dict_product_nums}
    Create list imei and other product    ${list_product}    ${list_nums}
    Sleep    5s
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${jsonpath_id_kh}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_kh}
    ${get_id_kh}    Get data from API    ${endpoint_khachhang}    ${jsonpath_id_kh}
    ${endpoint_danhmuc_hh_co_dvt}    Format String    ${endpoint_list_hh_in_mhbh}    ${BRANCH_ID}    ${BRANCH_ID}
    ${get_resp_danhmuc_hh}    Get Request and return body    ${endpoint_danhmuc_hh_co_dvt}
    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}    Get list jsonpath product frm list product    ${list_product}
    ${list_giaban}    ${list_result_ggsp}    ${list_id_sp}    Get product info and new price frm list product    ${get_resp_danhmuc_hh}    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}
    ...    ${list_newprice}
    ${list_thanhtien_hh}    Create List
    : FOR    ${giaban}    ${soluong}    IN ZIP    ${list_newprice}    ${list_nums}
    \    ${result_item_thanhtien}    Multiplication and round    ${giaban}    ${soluong}
    \    Append To List    ${list_thanhtien_hh}    ${result_item_thanhtien}
    Log    ${list_thanhtien_hh}
    ${result_tongtienhang}    Sum values in list    ${list_thanhtien_hh}
    ${giamgia_hd}    Set Variable If    0 < ${input_gghd} < 100    ${input_gghd}    null
    ${result_gghd}    Run Keyword If    0 < ${input_gghd} < 100    Convert % discount to VND    ${result_tongtienhang}    ${input_gghd}
    ...    ELSE    Set Variable    ${input_gghd}
    ${result_khtt}    Minus    ${result_tongtienhang}    ${result_gghd}
    ${actual_khtt}    Set Variable If    '${input_khtt}' == 'all'    ${result_khtt}    ${input_khtt}
    #post request
    ${liststring_prs_invoice_detail}    Set Variable    needdel
    Log    ${liststring_prs_invoice_detail}
    : FOR    ${item_gia_ban}    ${item_id_sp}    ${item_soluong}    ${item_imei}    ${item_result_ggsp}    IN ZIP
    ...    ${list_giaban}    ${list_id_sp}    ${list_nums}    ${imei_inlist}    ${list_result_ggsp}
    \    ${item_imei}    Convert list to string and return    ${item_imei}
    \    ${payload_each_product}    Format string    {{"BasePrice":1000000,"IsLotSerialControl":true,"IsRewardPoint":true,"Price":{0},"ProductId":{1},"Quantity":{2},"ProductCode":"SP000447","SerialNumbers":"{3}","Weight":0,"Discount":{4},"ProductName":"Điện thoại A","SalePromotionId":null,"PriceByPromotion":null,"PromotionParentProductId":null,"ProductBatchExpireId":null,"CategoryId":439203,"MasterProductId":{1},"Unit":"","Uuid":"","ProductWarranty":[]}}    ${item_gia_ban}    ${item_id_sp}    ${item_soluong}
    \    ...    ${item_imei}    ${item_result_ggsp}
    \    ${liststring_prs_invoice_detail}    Catenate    SEPARATOR=,    ${liststring_prs_invoice_detail}    ${payload_each_product}
    ${liststring_prs_invoice_detail}    Replace String    ${liststring_prs_invoice_detail}    needdel,    ${EMPTY}    count=1
    ${request_payload}    Format String    {{"Invoice":{{"BranchId":{0},"RetailerId":{1},"CustomerId":{2},"SoldById":{3},"SoldBy":{{"CreatedBy":0,"CreatedDate":"2018-12-10T08:33:32.447Z","Email":"","GivenName":"admin","Id":{3},"IsActive":true,"IsAdmin":true,"Type":0,"UserName":"admin","isDeleted":false}},"SaleChannelId":0,"Seller":{{"CreatedBy":0,"CreatedDate":"2018-12-10T08:33:32.447Z","Email":"","GivenName":"admin","Id":{3},"IsActive":true,"IsAdmin":true,"Type":0,"UserName":"admin","isDeleted":false}},"OrderCode":"","Code":"Hóa đơn 1","Discount":{4},"DiscountRatio":{5},"InvoiceDetails":[{6}],"InvoiceOrderSurcharges":[],"InvoicePromotions":[],"Payments":[{{"Method":"Cash","MethodStr":"Tiền mặt","Amount":{7},"Id":-1}}],"Status":1,"Total":{8},"Surcharge":0,"Type":1,"Uuid":"{9}","addToAccount":"0","addToAccountSurplus":"0","PayingAmount":0,"TotalBeforeDiscount":1025000,"ProductDiscount":110000,"DebugUuid":"","InvoiceWarranties":[],"CreatedBy":441968}}}}    ${BRANCH_ID}    ${get_id_nguoitao}    ${get_id_kh}    ${get_id_nguoiban}
    ...    ${result_gghd}    ${giamgia_hd}    ${liststring_prs_invoice_detail}    ${actual_khtt}    ${result_khtt}    ${Uuid_code}
    Log    ${request_payload}
    ${invoice_code}    Post request to create invoice and get invoice code    ${request_payload}
    Return From Keyword    ${invoice_code}

Add new invoice incase discount with multi product - get invoice code
    [Arguments]    ${input_ma_kh}    ${dict_product_nums}    ${list_ggsp}    ${input_gghd}    ${ma_hh_combo}    ${input_khtt}
    ${Uuid}      Generate Random String    4    [NUMBERS][NUMBERS]
    ${Uuid_code}      Catenate      SEPARATOR=      WA     ${Uuid}
    ${list_product}    Get Dictionary Keys    ${dict_product_nums}
    ${list_nums}    Get Dictionary Values    ${dict_product_nums}
    Create list imei and other product    ${list_product}    ${list_nums}
    Sleep    60s
    #get product info
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${jsonpath_id_kh}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_kh}
    ${get_id_kh}    Get data from API    ${endpoint_khachhang}    ${jsonpath_id_kh}
    ${endpoint_danhmuc_hh_co_dvt}    Format String    ${endpoint_list_hh_in_mhbh}    ${BRANCH_ID}    ${BRANCH_ID}
    ${get_resp_danhmuc_hh}    Get Request and return body    ${endpoint_danhmuc_hh_co_dvt}
    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}    Get list jsonpath product frm list product    ${list_product}
    ${list_giaban}    ${list_result_ggsp}    ${list_id_sp}    Get product info frm list jsonpath product have discount product    ${get_resp_danhmuc_hh}    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}
    ...    ${list_ggsp}
    ${list_thanhtien_hh}    Create List
    : FOR    ${giaban}    ${soluong}    ${item_ggsp}    IN ZIP    ${list_giaban}    ${list_nums}
    ...    ${list_ggsp}
    \    ${result_giaban_af_discount}    Run Keyword If    0 < ${item_ggsp} < 100    Price after % discount product    ${giaban}    ${item_ggsp}
    \    ...    ELSE IF    ${item_ggsp} > 100    Minus    ${giaban}    ${item_ggsp}
    \    ...    ELSE    Set Variable    ${giaban}
    \    ${result_item_thanhtien}    Multiplication and round    ${result_giaban_af_discount}    ${soluong}
    \    Append To List    ${list_thanhtien_hh}    ${result_item_thanhtien}
    Log    ${list_thanhtien_hh}
    ${result_tongtienhang}    Sum values in list    ${list_thanhtien_hh}
    ${giamgia_hd}    Set Variable If    0 < ${input_gghd} < 100    ${input_gghd}    null
    ${result_gghd}    Run Keyword If    0 < ${input_gghd} < 100    Convert % discount to VND    ${result_tongtienhang}    ${input_gghd}
    ...    ELSE    Set Variable    ${input_gghd}
    ${result_khtt}    Minus    ${result_tongtienhang}    ${result_gghd}
    ${actual_khtt}    Set Variable If    '${input_khtt}' == 'all'    ${result_khtt}    ${input_khtt}
    #post request
    ${liststring_prs_invoice_detail}    Set Variable    needdel
    Log    ${liststring_prs_invoice_detail}
    : FOR    ${item_gia_ban}    ${item_id_sp}    ${item_soluong}    ${item_imei}    ${item_result_ggsp}    ${item_ggsp}
    ...    IN ZIP    ${list_giaban}    ${list_id_sp}    ${list_nums}    ${imei_inlist}    ${list_result_ggsp}
    ...    ${list_ggsp}
    \    ${item_imei}    Convert list to string and return    ${item_imei}
    \    ${item_ggsp}    Set Variable If    0 < ${item_ggsp} < 100    ${item_ggsp}    0
    \    ${payload_each_product}    Format string    {{"BasePrice":1000000,"IsLotSerialControl":true,"IsRewardPoint":true,"Price":{0},"ProductId":{1},"Quantity":{2},"ProductCode":"SP000447","SerialNumbers":"{3}","Weight":0,"Discount":{4},"DiscountRatio":{5},"ProductName":"Điện thoại A","SalePromotionId":null,"PriceByPromotion":null,"PromotionParentProductId":null,"ProductBatchExpireId":null,"CategoryId":439203,"MasterProductId":{1},"Unit":"","Uuid":"","ProductWarranty":[]}}    ${item_gia_ban}    ${item_id_sp}    ${item_soluong}
    \    ...    ${item_imei}    ${item_result_ggsp}    ${item_ggsp}
    \    ${liststring_prs_invoice_detail}    Catenate    SEPARATOR=,    ${liststring_prs_invoice_detail}    ${payload_each_product}
    ${liststring_prs_invoice_detail}    Replace String    ${liststring_prs_invoice_detail}    needdel,    ${EMPTY}    count=1
    ${request_payload}    Format String    {{"Invoice":{{"BranchId":{0},"RetailerId":{1},"CustomerId":{2},"SoldById":{3},"SoldBy":{{"CreatedBy":0,"CreatedDate":"2017-04-24T11:33:52.877Z","Email":"ngokanh610@gmail.com","GivenName":"TestShard53","Id":{3},"IsActive":true,"IsAdmin":true,"Type":0,"UserName":"admin"}},"SaleChannelId":0,"Seller":{{"CreatedBy":0,"CreatedDate":"2017-04-24T11:33:52.877Z","Email":"ngokanh610@gmail.com","GivenName":"TestShard53","Id":{3},"IsActive":true,"IsAdmin":true,"Type":0,"UserName":"admin"}},"OrderCode":"","Code":"Hóa đơn 1","Discount":{4},"DiscountRatio":{5},"InvoiceDetails":[{6}],"InvoiceOrderSurcharges":[],"InvoicePromotions":[],"Payments":[{{"Method":"Cash","MethodStr":"Tiền mặt","Amount":{7},"Id":-1}}],"Status":1,"Total":2129584,"Surcharge":0,"Type":1,"Uuid":"{8}","addToAccount":"0","PayingAmount":2129584,"TotalBeforeDiscount":3513115,"ProductDiscount":747422,"DebugUuid":"","InvoiceWarranties":[],"CreatedBy":2}}}}    ${BRANCH_ID}    ${get_id_nguoitao}    ${get_id_kh}    ${get_id_nguoiban}
    ...    ${result_gghd}    ${giamgia_hd}    ${liststring_prs_invoice_detail}    ${actual_khtt}    ${Uuid_code}
    Log    ${request_payload}
    ${invoice_code}    Post request to create invoice and get invoice code    ${request_payload}
    Return From Keyword    ${invoice_code}

Add new invoice incase newprice with multi product - no payment - surcharge - get invoice code
    [Arguments]    ${input_ma_kh}    ${dict_product_nums}    ${list_newprice}    ${input_gghd}    ${input_thukhac}    ${input_ten_nv}     ${input_chi_nhanh}
    ${Uuid}      Generate Random String    4    [NUMBERS][NUMBERS]
    ${Uuid_code}      Catenate      SEPARATOR=      WA     ${Uuid}
    ${list_product}    Get Dictionary Keys    ${dict_product_nums}
    ${list_nums}    Get Dictionary Values    ${dict_product_nums}
    Create list imei and other product    ${list_product}    ${list_nums}
    ${surcharge_vnd_value}    Get surcharge vnd value    ${input_thukhac}
    ${surcharge_%}    Get surcharge percentage value    ${input_thukhac}
    Run Keyword If    ${surcharge_%} == 0    Toggle surcharge VND    ${input_thukhac}    true
    ...    ELSE    Toggle surcharge percentage    ${input_thukhac}    true
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Run Keyword If    '${input_ten_nv}'=='admin'    Get User ID     ELSE       Get User ID by UserName    ${input_ten_nv}
    ${get_branch_id}      Get BranchID by BranchName    ${input_chi_nhanh}
    ${jsonpath_id_kh}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_kh}
    ${get_id_kh}    Get data from API    ${endpoint_khachhang}    ${jsonpath_id_kh}
    ${endpoint_danhmuc_hh_co_dvt}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${get_branch_id}
    ${get_resp_danhmuc_hh}    Get Request and return body    ${endpoint_danhmuc_hh_co_dvt}
    ${get_id_thukhac}    ${get_thutu_thukhac}    Get Id and order surchage    ${input_thukhac}
    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}    Get list jsonpath product frm list product    ${list_product}
    ${list_giaban}    ${list_result_ggsp}    ${list_id_sp}    Get product info and new price frm list product    ${get_resp_danhmuc_hh}    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}
    ...    ${list_newprice}
    ${list_thanhtien_hh}    Create List
    : FOR    ${giaban}    ${soluong}    IN ZIP    ${list_newprice}    ${list_nums}
    \    ${result_item_thanhtien}    Multiplication and round    ${giaban}    ${soluong}
    \    Append To List    ${list_thanhtien_hh}    ${result_item_thanhtien}
    Log    ${list_thanhtien_hh}
    ${result_tongtienhang}    Sum values in list    ${list_thanhtien_hh}
    ${giamgia_hd}    Set Variable If    0 < ${input_gghd} < 100    ${input_gghd}    null
    ${result_gghd}    Run Keyword If    0 < ${input_gghd} < 100    Convert % discount to VND    ${result_tongtienhang}    ${input_gghd}
    ...    ELSE    Set Variable    ${input_gghd}
    ${result_khtt}    Minus    ${result_tongtienhang}    ${result_gghd}
    Set Global Variable    \${result_tongtienhang}    ${result_tongtienhang}
    Set Global Variable    \${result_gghd}    ${result_gghd}
    Set Global Variable    \${list_thanhtien_hh}    ${list_thanhtien_hh}
    ${result_surcharge}    Run Keyword If    0 < ${surcharge_%} < 100    Convert % discount to VND and round    ${result_khtt}    ${surcharge_%}
    ...    ELSE    Set Variable    ${surcharge_vnd_value}
    ${result_key_surcharge}    Set Variable If    0 < ${surcharge_%} < 100    SurValueRatio    SurValue
    ${result_value_surcharge}    Set Variable If    0 < ${surcharge_%} < 100    ${surcharge_%}    ${surcharge_vnd_value}
    ${result_key}    Set Variable If    0 < ${surcharge_%} < 100    ValueRatio    Value
    #post request
    ${liststring_prs_invoice_detail}    Set Variable    needdel
    Log    ${liststring_prs_invoice_detail}
    : FOR    ${item_gia_ban}    ${item_id_sp}    ${item_soluong}    ${item_imei}    ${item_result_ggsp}    IN ZIP
    ...    ${list_giaban}    ${list_id_sp}    ${list_nums}    ${imei_inlist}    ${list_result_ggsp}
    \    ${item_imei}    Convert list to string and return    ${item_imei}
    \    ${payload_each_product}    Format string    {{"BasePrice":299000,"IsLotSerialControl":true,"IsRewardPoint":false,"Note":"","Price":{0},"ProductId":{1},"Quantity":{2},"ProductCode":"SI030","SerialNumbers":"{3}","Discount":{4},"DiscountRatio":null,"ProductName":"Máy Hút Bụi Electrolux ZLUX1811 - Tím","PriceByPromotion":null,"PromotionParentProductId":null,"ProductBatchExpireId":null,"CategoryId":794174,"MasterProductId":{1},"Unit":"","Uuid":"","ProductWarranty":[]}}    ${item_gia_ban}    ${item_id_sp}    ${item_soluong}
    \    ...    ${item_imei}    ${item_result_ggsp}
    \    ${liststring_prs_invoice_detail}    Catenate    SEPARATOR=,    ${liststring_prs_invoice_detail}    ${payload_each_product}
    ${liststring_prs_invoice_detail}    Replace String    ${liststring_prs_invoice_detail}    needdel,    ${EMPTY}    count=1
    ${request_payload}    Format String    {{"Invoice":{{"BranchId":{0},"RetailerId":{1},"UpdateInvoiceId":0,"UpdateReturnId":0,"CustomerId":{2},"SoldById":{3},"SoldBy":{{"CreatedBy":0,"CreatedDate":"2018-07-30T08:27:36.800Z","Email":"","GivenName":"anh.lv","Id":{3},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false}},"SaleChannelId":0,"Seller":{{"CreatedBy":0,"CreatedDate":"2018-07-30T08:27:36.800Z","Email":"","GivenName":"anh.lv","Id":{3},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false}},"OrderCode":"","Code":"Hóa đơn 1","Discount":{4},"DiscountRatio":{5},"InvoiceDetails":[{6}],"InvoiceOrderSurcharges":[{{"Code":"TK005","Name":"Phí giao hàng1","Order":{7},"RetailerId":{1},"{8}":{9},"SurchargeId":{10},"{12}":{9},"isAuto":true,"isReturnAuto":true,"UsageFlag":true,"Price":{11}}}],"InvoicePromotions":[],"Payments":[],"Status":1,"Total":866004,"Surcharge":{11},"Type":1,"Uuid":"{13}","addToAccount":"0","addToAccountSurplus":"0","addToAccountAllocation":"0","addToAccountPaymentAllocation":"0","PayingAmount":866004,"TotalBeforeDiscount":824250,"ProductDiscount":-46754,"DebugUuid":"","InvoiceWarranties":[],"CreatedBy":201567}}}}    ${get_branch_id}    ${get_id_nguoitao}    ${get_id_kh}    ${get_id_nguoiban}
    ...    ${result_gghd}    ${giamgia_hd}    ${liststring_prs_invoice_detail}    ${get_thutu_thukhac}    ${result_key_surcharge}    ${result_value_surcharge}
    ...    ${get_id_thukhac}    ${result_surcharge}    ${result_key}    ${Uuid_code}
    Log    ${request_payload}
    ${invoice_code}    Post request to create invoice and get invoice code    ${request_payload}
    Return From Keyword    ${invoice_code}

Add new invoice incase newprice with multi product - multi surcharge - get invoice code
    [Arguments]    ${input_ma_kh}    ${dict_product_nums}    ${list_newprice}    ${input_gghd}    ${input_thukhac1}    ${input_thukhac2}
    ...    ${input_khtt}
    ${Uuid}      Generate Random String    4    [NUMBERS][NUMBERS]
    ${Uuid_code}      Catenate      SEPARATOR=      WA     ${Uuid}
    ${list_product}    Get Dictionary Keys    ${dict_product_nums}
    ${list_nums}    Get Dictionary Values    ${dict_product_nums}
    Create list imei and other product    ${list_product}    ${list_nums}
    ${surcharge_value_1_vnd}    Get surcharge vnd value    ${input_thukhac1}
    ${surcharge_value_1_percentage}    Get surcharge percentage value    ${input_thukhac1}
    ${surcharge_value_2_vnd}    Get surcharge vnd value    ${input_thukhac2}
    ${surcharge_value_2_percentage}    Get surcharge percentage value    ${input_thukhac2}
    ${actual_surcharge1_value}    Set Variable If    ${surcharge_value_1_percentage} == 0    ${surcharge_value_1_vnd}    ${surcharge_value_1_percentage}
    ${actual_surcharge2_value}    Set Variable If    ${surcharge_value_2_percentage} == 0    ${surcharge_value_2_vnd}    ${surcharge_value_2_percentage}
    Run Keyword If    ${actual_surcharge1_value} > 100    Toggle surcharge VND    ${input_thukhac1}    true
    ...    ELSE    Toggle surcharge percentage    ${input_thukhac1}    true
    Run Keyword If    ${actual_surcharge2_value} > 100    Toggle surcharge VND    ${input_thukhac2}    true
    ...    ELSE    Toggle surcharge percentage    ${input_thukhac2}    true
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${jsonpath_id_kh}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_kh}
    ${get_id_kh}    Get data from API    ${endpoint_khachhang}    ${jsonpath_id_kh}
    ${endpoint_danhmuc_hh_co_dvt}    Format String    ${endpoint_list_hh_in_mhbh}    ${BRANCH_ID}    ${BRANCH_ID}
    ${get_resp_danhmuc_hh}    Get Request and return body    ${endpoint_danhmuc_hh_co_dvt}
    ${get_id_thukhac1}    ${get_thutu_thukhac1}    Get Id and order surchage    ${input_thukhac1}
    ${get_id_thukhac2}    ${get_thutu_thukhac2}    Get Id and order surchage    ${input_thukhac2}
    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}    Get list jsonpath product frm list product    ${list_product}
    ${list_giaban}    ${list_result_ggsp}    ${list_id_sp}    Get product info and new price frm list product    ${get_resp_danhmuc_hh}    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}
    ...    ${list_newprice}
    ${list_thanhtien_hh}    Create List
    : FOR    ${giaban}    ${soluong}    IN ZIP    ${list_newprice}    ${list_nums}
    \    ${result_item_thanhtien}    Multiplication and round    ${giaban}    ${soluong}
    \    Append To List    ${list_thanhtien_hh}    ${result_item_thanhtien}
    Log    ${list_thanhtien_hh}
    ${result_tongtienhang}    Sum values in list    ${list_thanhtien_hh}
    ${giamgia_hd}    Set Variable If    0 < ${input_gghd} < 100    ${input_gghd}    null
    ${result_gghd}    Run Keyword If    0 < ${input_gghd} < 100    Convert % discount to VND    ${result_tongtienhang}    ${input_gghd}
    ...    ELSE    Set Variable    ${input_gghd}
    ${result_khtt}    Minus    ${result_tongtienhang}    ${result_gghd}
    ${actual_khtt}    Set Variable If    '${input_khtt}' == 'all'    ${result_khtt}    ${input_khtt}
    ${result_surcharge1}    Run Keyword If    0 < ${actual_surcharge1_value} < 100    Convert % discount to VND and round    ${result_khtt}    ${actual_surcharge1_value}
    ...    ELSE    Set Variable    ${actual_surcharge1_value}
    ${result_surcharge2}    Run Keyword If    0 < ${actual_surcharge2_value} < 100    Convert % discount to VND and round    ${result_khtt}    ${actual_surcharge2_value}
    ...    ELSE    Set Variable    ${actual_surcharge2_value}
    ${total_surcharge}    Sum and replace floating point    ${result_surcharge1}    ${result_surcharge2}
    ${result_khtt}    Minus    ${result_tongtienhang}    ${result_gghd}
    ${result_ktt_httu}    Sum and replace floating point    ${result_khtt}    ${total_surcharge}
    ${actual_khtt}    Set Variable If    '${input_khtt}' == 'all'    ${result_ktt_httu}    ${input_khtt}
    #post request
    ${liststring_prs_invoice_detail}    Set Variable    needdel
    Log    ${liststring_prs_invoice_detail}
    : FOR    ${item_gia_ban}    ${item_id_sp}    ${item_soluong}    ${item_imei}    ${item_result_ggsp}    IN ZIP
    ...    ${list_giaban}    ${list_id_sp}    ${list_nums}    ${imei_inlist}    ${list_result_ggsp}
    \    ${item_imei}    Convert list to string and return    ${item_imei}
    \    ${payload_each_product}    Format string    {{"BasePrice":299000,"IsLotSerialControl":true,"IsRewardPoint":false,"Note":"","Price":{0},"ProductId":{1},"Quantity":{2},"ProductCode":"SI030","SerialNumbers":"{3}","Discount":{4},"DiscountRatio":null,"ProductName":"Máy Hút Bụi Electrolux ZLUX1811 - Tím","PriceByPromotion":null,"PromotionParentProductId":null,"ProductBatchExpireId":null,"CategoryId":794174,"MasterProductId":{1},"Unit":"","Uuid":"","ProductWarranty":[]}}    ${item_gia_ban}    ${item_id_sp}    ${item_soluong}
    \    ...    ${item_imei}    ${item_result_ggsp}
    \    ${liststring_prs_invoice_detail}    Catenate    SEPARATOR=,    ${liststring_prs_invoice_detail}    ${payload_each_product}
    ${liststring_prs_invoice_detail}    Replace String    ${liststring_prs_invoice_detail}    needdel,    ${EMPTY}    count=1
    ${request_payload}    Format String    {{"Invoice":{{"BranchId":{0},"RetailerId":{1},"UpdateInvoiceId":0,"UpdateReturnId":0,"CustomerId":{2},"SoldById":{3},"SoldBy":{{"CreatedBy":0,"CreatedDate":"2018-07-30T08:27:36.800Z","Email":"","GivenName":"anh.lv","Id":{3},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false}},"SaleChannelId":0,"Seller":{{"CreatedBy":0,"CreatedDate":"2018-07-30T08:27:36.800Z","Email":"","GivenName":"anh.lv","Id":{3},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false}},"OrderCode":"","Code":"Hóa đơn 1","Discount":{4},"DiscountRatio":{5},"InvoiceDetails":[{6}],"InvoiceOrderSurcharges":[{{"Code":"TK005","Name":"Phí giao hàng1","Order":{7},"RetailerId":{1},"SurValue":{8},"SurchargeId":{9},"Value":{8},"isAuto":true,"isReturnAuto":true,"UsageFlag":true,"Price":{8}}},{{"Code":"TK001","Name":"Phí VAT1","Order":{10},"Price":{11},"RetailerId":{1},"SurValueRatio":{12},"SurchargeId":{13},"UsageFlag":true,"ValueRatio":{12},"isAuto":true,"isReturnAuto":true}}],"InvoicePromotions":[],"Payments":[{{"Method":"Cash","MethodStr":"Tiền mặt","Amount":{14},"Id":-1}}],"Status":1,"Total":682530,"Surcharge":{15},"Type":1,"Uuid":"{16}","addToAccount":"0","addToAccountSurplus":"0","addToAccountAllocation":"0","addToAccountPaymentAllocation":"0","PayingAmount":682530,"TotalBeforeDiscount":494000,"ProductDiscount":-140000,"DebugUuid":"","InvoiceWarranties":[],"CreatedBy":201567}}}}    ${BRANCH_ID}    ${get_id_nguoitao}    ${get_id_kh}    ${get_id_nguoiban}
    ...    ${result_gghd}    ${giamgia_hd}    ${liststring_prs_invoice_detail}    ${get_thutu_thukhac1}    ${actual_surcharge1_value}    ${get_id_thukhac1}
    ...    ${get_thutu_thukhac2}    ${result_surcharge2}    ${actual_surcharge2_value}    ${get_id_thukhac2}    ${actual_khtt}    ${total_surcharge}    ${Uuid_code}
    Log    ${request_payload}
    ${invoice_code}    Post request to create invoice and get invoice code    ${request_payload}
    Return From Keyword    ${invoice_code}

Post request to create invoice
    [Arguments]    ${request_payload}
    ${resp.json()}    Post request thr API     /invoices/save    ${request_payload}
    Return From Keyword    ${resp.json()}

Post request to create invoice and get invoice code
    [Arguments]    ${request_payload}
    ${resp}    Post request by other URL API    ${SALE_API_URL}    /invoices/save    ${request_payload}
    ${string}    Convert To String    ${resp}
    ${dict}    Set Variable    ${resp}
    ${invoice_code}    Get From Dictionary    ${dict}    Code
    Return From Keyword    ${invoice_code}

Create invoice with imei product
    [Arguments]    ${input_ma_kh}    ${dict_product_nums}   ${list_status_product}
    ${list_prs}    Get Dictionary Keys    ${dict_product_nums}
    ${list_nums}    Get Dictionary Values    ${dict_product_nums}
    Create list imei and other product    ${list_prs}    ${list_nums}
    Sleep    10s
    :FOR   ${imei}   ${input_product}   ${input_nums}   ${status}  IN ZIP    ${imei_inlist}    ${list_prs}    ${list_nums}   ${list_status_product}
    \     Run Keyword If    '${status}' == 'True'   Add new invoice with imei product    ${input_ma_kh}   ${input_product}   ${input_nums}    ${imei}
    \     ...   ELSE    Log    Igore input

Add new invoice incase newprice with multi prouduct - payment by user
    [Arguments]    ${input_ma_kh}    ${ten_nv}    ${dict_product_nums}    ${list_newprice}    ${input_gghd}    ${ma_hh_combo}
    ...    ${input_khtt}
    ${Uuid}      Generate Random String    4    [NUMBERS][NUMBERS]
    ${Uuid_code}      Catenate      SEPARATOR=      WA     ${Uuid}
    ${list_product}    Get Dictionary Keys    ${dict_product_nums}
    ${list_nums}    Get Dictionary Values    ${dict_product_nums}
    Create list imei and other product    ${list_product}    ${list_nums}
    Sleep    20s
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID by UserName    ${ten_nv}
    ${jsonpath_id_kh}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_kh}
    ${get_id_kh}    Get data from API    ${endpoint_khachhang}    ${jsonpath_id_kh}
    ${endpoint_danhmuc_hh_co_dvt}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${get_resp_danhmuc_hh}    Get Request and return body    ${endpoint_danhmuc_hh_co_dvt}
    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}    Get list jsonpath product frm list product    ${list_product}
    ${list_giaban}    ${list_result_ggsp}    ${list_id_sp}    Get product info and new price frm list product    ${get_resp_danhmuc_hh}    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}
    ...    ${list_newprice}
    ${list_thanhtien_hh}    Create List
    : FOR    ${giaban}    ${soluong}    IN ZIP    ${list_newprice}    ${list_nums}
    \    ${result_item_thanhtien}    Multiplication and round    ${giaban}    ${soluong}
    \    Append To List    ${list_thanhtien_hh}    ${result_item_thanhtien}
    Log    ${list_thanhtien_hh}
    ${result_tongtienhang}    Sum values in list    ${list_thanhtien_hh}
    ${giamgia_hd}    Set Variable If    0 < ${input_gghd} < 100    ${input_gghd}    null
    ${result_gghd}    Run Keyword If    0 < ${input_gghd} < 100    Convert % discount to VND    ${result_tongtienhang}    ${input_gghd}
    ...    ELSE    Set Variable    ${input_gghd}
    ${result_khtt}    Minus    ${result_tongtienhang}    ${result_gghd}
    ${actual_khtt}    Set Variable If    '${input_khtt}' == 'all'    ${result_khtt}    ${input_khtt}
    Set Test Variable    ${result_tongtienhang}    ${result_tongtienhang}
    Set Test Variable    ${result_gghd}    ${result_gghd}
    Set Test Variable    ${list_thanhtien_hh}    ${list_thanhtien_hh}
    #post request
    ${liststring_prs_invoice_detail}    Set Variable    needdel
    Log    ${liststring_prs_invoice_detail}
    : FOR    ${item_gia_ban}    ${item_id_sp}    ${item_soluong}    ${item_imei}    ${item_result_ggsp}    IN ZIP
    ...    ${list_giaban}    ${list_id_sp}    ${list_nums}    ${imei_inlist}    ${list_result_ggsp}
    \    ${item_imei}    Convert list to string and return    ${item_imei}
    \    ${payload_each_product}    Format string    {{"BasePrice":1000000,"IsLotSerialControl":true,"IsRewardPoint":true,"Price":{0},"ProductId":{1},"Quantity":{2},"ProductCode":"SP000447","SerialNumbers":"{3}","Weight":0,"Discount":{4},"ProductName":"Điện thoại A","SalePromotionId":null,"PriceByPromotion":null,"PromotionParentProductId":null,"ProductBatchExpireId":null,"CategoryId":439203,"MasterProductId":{1},"Unit":"","Uuid":"","ProductWarranty":[]}}    ${item_gia_ban}    ${item_id_sp}    ${item_soluong}
    \    ...    ${item_imei}    ${item_result_ggsp}
    \    ${liststring_prs_invoice_detail}    Catenate    SEPARATOR=,    ${liststring_prs_invoice_detail}    ${payload_each_product}
    ${liststring_prs_invoice_detail}    Replace String    ${liststring_prs_invoice_detail}    needdel,    ${EMPTY}    count=1
    ${request_payload}    Format String    {{"Invoice":{{"BranchId":{0},"RetailerId":{1},"CustomerId":{2},"SoldById":{3},"SoldBy":{{"CreatedBy":0,"CreatedDate":"2018-12-10T08:33:32.447Z","Email":"","GivenName":"admin","Id":{3},"IsActive":true,"IsAdmin":true,"Type":0,"UserName":"admin","isDeleted":false}},"SaleChannelId":0,"Seller":{{"CreatedBy":0,"CreatedDate":"2018-12-10T08:33:32.447Z","Email":"","GivenName":"admin","Id":{3},"IsActive":true,"IsAdmin":true,"Type":0,"UserName":"admin","isDeleted":false}},"OrderCode":"","Code":"Hóa đơn 1","Discount":{4},"DiscountRatio":{5},"InvoiceDetails":[{6}],"InvoiceOrderSurcharges":[],"InvoicePromotions":[],"Payments":[{{"Method":"Cash","MethodStr":"Tiền mặt","Amount":{7},"Id":-1}}],"Status":1,"Total":914985,"Surcharge":0,"Type":1,"Uuid":"{8}","addToAccount":"0","addToAccountSurplus":"0","PayingAmount":0,"TotalBeforeDiscount":1025000,"ProductDiscount":110000,"DebugUuid":"","InvoiceWarranties":[],"CreatedBy":441968}}}}    ${BRANCH_ID}    ${get_id_nguoitao}    ${get_id_kh}    ${get_id_nguoiban}
    ...    ${result_gghd}    ${giamgia_hd}    ${liststring_prs_invoice_detail}    ${actual_khtt}    ${Uuid_code}
    Log    ${request_payload}
    ${invoice_code}    Post request to create invoice and get invoice code    ${request_payload}
    Return From Keyword    ${invoice_code}

Add new invoice incase newprice with multi prouduct - payment - sale channel
    [Arguments]    ${input_ma_kh}    ${kenh_bh}    ${dict_product_nums}    ${list_newprice}    ${input_gghd}    ${input_khtt}
    ${Uuid}      Generate Random String    4    [NUMBERS][NUMBERS]
    ${Uuid_code}      Catenate      SEPARATOR=      WA     ${Uuid}
    ${list_product}    Get Dictionary Keys    ${dict_product_nums}
    ${list_nums}    Get Dictionary Values    ${dict_product_nums}
    Create list imei and other product    ${list_product}    ${list_nums}
    Sleep    60s
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${get_kbh_id}    Get sale channel id thr API    ${kenh_bh}
    ${jsonpath_id_kh}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_kh}
    ${get_id_kh}    Get data from API    ${endpoint_khachhang}    ${jsonpath_id_kh}
    ${endpoint_danhmuc_hh_co_dvt}    Format String    ${endpoint_list_hh_in_mhbh}    ${BRANCH_ID}    ${BRANCH_ID}
    ${get_resp_danhmuc_hh}    Get Request and return body    ${endpoint_danhmuc_hh_co_dvt}
    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}    Get list jsonpath product frm list product    ${list_product}
    ${list_giaban}    ${list_result_ggsp}    ${list_id_sp}    Get product info and new price frm list product    ${get_resp_danhmuc_hh}    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}
    ...    ${list_newprice}
    ${list_thanhtien_hh}    Create List
    : FOR    ${giaban}    ${soluong}    IN ZIP    ${list_newprice}    ${list_nums}
    \    ${result_item_thanhtien}    Multiplication and round    ${giaban}    ${soluong}
    \    Append To List    ${list_thanhtien_hh}    ${result_item_thanhtien}
    Log    ${list_thanhtien_hh}
    ${result_tongtienhang}    Sum values in list    ${list_thanhtien_hh}
    ${giamgia_hd}    Set Variable If    0 < ${input_gghd} < 100    ${input_gghd}    null
    ${result_gghd}    Run Keyword If    0 < ${input_gghd} < 100    Convert % discount to VND    ${result_tongtienhang}    ${input_gghd}
    ...    ELSE    Set Variable    ${input_gghd}
    ${result_khtt}    Minus    ${result_tongtienhang}    ${result_gghd}
    ${actual_khtt}    Set Variable If    '${input_khtt}' == 'all'    ${result_khtt}    ${input_khtt}
    #post request
    ${liststring_prs_invoice_detail}    Set Variable    needdel
    Log    ${liststring_prs_invoice_detail}
    : FOR    ${item_gia_ban}    ${item_id_sp}    ${item_soluong}    ${item_imei}    ${item_result_ggsp}    IN ZIP
    ...    ${list_giaban}    ${list_id_sp}    ${list_nums}    ${imei_inlist}    ${list_result_ggsp}
    \    ${item_imei}    Convert list to string and return    ${item_imei}
    \    ${payload_each_product}    Format string    {{"BasePrice":1000000,"IsLotSerialControl":true,"IsRewardPoint":true,"Price":{0},"ProductId":{1},"Quantity":{2},"ProductCode":"SP000447","SerialNumbers":"{3}","Weight":0,"Discount":{4},"ProductName":"Điện thoại A","SalePromotionId":null,"PriceByPromotion":null,"PromotionParentProductId":null,"ProductBatchExpireId":null,"CategoryId":439203,"MasterProductId":{1},"Unit":"","Uuid":"","ProductWarranty":[]}}    ${item_gia_ban}    ${item_id_sp}    ${item_soluong}
    \    ...    ${item_imei}    ${item_result_ggsp}
    \    ${liststring_prs_invoice_detail}    Catenate    SEPARATOR=,    ${liststring_prs_invoice_detail}    ${payload_each_product}
    ${liststring_prs_invoice_detail}    Replace String    ${liststring_prs_invoice_detail}    needdel,    ${EMPTY}    count=1
    ${request_payload}    Format String    {{"Invoice":{{"BranchId":{0},"RetailerId":{1},"UpdateInvoiceId":0,"UpdateReturnId":0,"CustomerId":{2},"SoldById":{3},"SoldBy":{{"CreatedBy":0,"CreatedDate":"2019-04-23T10:22:08.910Z","Email":"","GivenName":"admin","Id":{3},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false}},"SaleChannelId":{4},"SaleChannel":{{"Id":{4},"CreatedDate":"2019-09-14T09:51:34.1402021+07:00","CreatedBy":{3},"Name":"{5}","Description":"","IsActive":true,"Position":20,"RetailerId":{1},"Img":"fas fa-shopping-cart","Orders":[],"Invoices":[],"Returns":[]}},"Seller":{{"CreatedBy":0,"CreatedDate":"2019-04-23T10:22:08.910Z","Email":"","GivenName":"admin","Id":{3},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false}},"OrderCode":"","Code":"Hóa đơn 1","Discount":{6},"DiscountRatio":{7},"InvoiceDetails":[{8}],"InvoiceOrderSurcharges":[],"InvoicePromotions":[],"Payments":[{{"Method":"Cash","MethodStr":"Tiền mặt","Amount":{9},"Id":-1}}],"Status":1,"Total":960000,"Surcharge":0,"Type":1,"Uuid":"W15684295512033","addToAccount":"0","addToAccountSurplus":"0","addToAccountAllocation":"0","addToAccountPaymentAllocation":"0","PayingAmount":{9},"TotalBeforeDiscount":718200,"ProductDiscount":-481800,"DebugUuid":"156842955107723","InvoiceWarranties":[],"CreatedBy":{3}}}}}    ${BRANCH_ID}    ${get_id_nguoitao}    ${get_id_kh}    ${get_id_nguoiban}
    ...    ${get_kbh_id}    ${kenh_bh}    ${result_gghd}    ${giamgia_hd}    ${liststring_prs_invoice_detail}    ${actual_khtt}
    Log    ${request_payload}
    ${invoice_code}    Post request to create invoice and get invoice code    ${request_payload}
    Return From Keyword    ${invoice_code}

Add invoice without customer no payment thr API
    [Arguments]    ${dic_product_num}
    ${Uuid}      Generate Random String    4    [NUMBERS][NUMBERS]
    ${Uuid_code}      Catenate      SEPARATOR=      WA     ${Uuid}
    ${input_ma_hang}    Get Dictionary Keys    ${dic_product_num}
    ${input_soluong}    Get Dictionary Values    ${dic_product_num}
    ${input_ma_hang}    Convert list to string and return    ${input_ma_hang}
    ${input_soluong}    Convert list to string and return    ${input_soluong}
    ${jsonpath_id_sp}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_hang}
    ${jsonpath_gia_ban}    Format String    $..Data[?(@.Code == '{0}')].BasePrice    ${input_ma_hang}
    ${endpoint_danhmuc_hh_co_dvt}    Format String    ${endpoint_list_hh_in_mhbh}    ${BRANCH_ID}    ${BRANCH_ID}
    ${get_resp_danhmuc_hh}    Get Request and return body    ${endpoint_danhmuc_hh_co_dvt}
    ${get_id_sp}    Get data from response json    ${get_resp_danhmuc_hh}    ${jsonpath_id_sp}
    ${get_gia_ban}    Get data from response json    ${get_resp_danhmuc_hh}    ${jsonpath_gia_ban}
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${request_payload}    Format String    {{"Invoice":{{"BranchId":{0},"RetailerId":{1},"SoldById":{2},"SoldBy":{{"CreatedBy":0,"CreatedDate":"2018-12-10T10:42:37.447Z","Email":"","GivenName":"admin","Id":{3},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false}},"SaleChannelId":0,"Seller":{{"CreatedBy":0,"CreatedDate":"2018-12-10T10:42:37.447Z","Email":"","GivenName":"admin","Id":{4},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false}},"OrderCode":"","Code":"Hóa đơn 1","InvoiceDetails":[{{"BasePrice":78000,"IsLotSerialControl":false,"IsRewardPoint":false,"Note":"","Price":{5},"ProductId":{6},"Quantity":{7},"ProductCode":"HH0123","ProductName":"Bánh trứng Belgi","SalePromotionId":null,"PriceByPromotion":null,"PromotionParentProductId":null,"ProductBatchExpireId":null,"CategoryId":795901,"MasterProductId":16094444,"Unit":"","Uuid":"{8}","ProductWarranty":[]}}],"InvoiceOrderSurcharges":[],"InvoicePromotions":[],"Payments":[],"Status":1,"Total":15600000,"Surcharge":0,"Type":1,"Uuid":"","addToAccount":"0","PayingAmount":0,"TotalBeforeDiscount":15600000,"ProductDiscount":0,"DebugUuid":"","InvoiceWarranties":[],"CreatedBy":196750}}}}    ${BRANCH_ID}    ${get_id_nguoitao}    ${get_id_nguoiban}    ${get_id_nguoiban}
    ...    ${get_id_nguoiban}    ${get_gia_ban}    ${get_id_sp}    ${input_soluong}    ${Uuid_code}
    Log    ${request_payload}
    ${invoice_code}    Post request to create invoice and get invoice code    ${request_payload}
    Return From Keyword    ${invoice_code}

Add new invoice without customer thr API
    [Arguments]    ${dic_product_num}    ${input_khtt}
    ${Uuid}      Generate Random String    4    [NUMBERS][NUMBERS]
    ${Uuid_code}      Catenate      SEPARATOR=      WA     ${Uuid}
    ${input_ma_hang}    Get Dictionary Keys    ${dic_product_num}
    ${input_soluong}    Get Dictionary Values    ${dic_product_num}
    ${input_ma_hang}    Convert list to string and return    ${input_ma_hang}
    ${input_soluong}    Convert list to string and return    ${input_soluong}
    ${jsonpath_id_sp}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_hang}
    ${jsonpath_gia_ban}    Format String    $..Data[?(@.Code == '{0}')].BasePrice    ${input_ma_hang}
    ${endpoint_danhmuc_hh_co_dvt}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${get_resp}   Get Request and return body    ${endpoint_danhmuc_hh_co_dvt}
    ${get_id_sp}    Get data from response json     ${get_resp}    ${jsonpath_id_sp}
    ${get_gia_ban}   Get data from response json   ${get_resp}    ${jsonpath_gia_ban}
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${result_thanhtien}    Multiplication and round    ${get_gia_ban}    ${input_soluong}
    ${resull_khtt_all}    Set Variable If    '${input_khtt}' == 'all'    ${result_thanhtien}    ${input_khtt}
    ${request_payload}    Format String    {{"Invoice":{{"BranchId":{0},"RetailerId":{1},"SoldById":{2},"SoldBy":{{"CreatedBy":0,"CreatedDate":"2018-07-30T08:27:36.800Z","Email":"","GivenName":"anh.lv","Id":{3},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false}},"SaleChannelId":0,"SaleChannel":null,"Seller":{{"CreatedBy":0,"CreatedDate":"2018-07-30T08:27:36.800Z","Email":"","GivenName":"anh.lv","Id":{4},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false}},"OrderCode":"","Code":"Hóa đơn 1","InvoiceDetails":[{{"BasePrice":200000,"IsLotSerialControl":false,"IsRewardPoint":false,"Note":"","Price":{5},"ProductId":{6},"Quantity":{7},"ProductCode":"Combo01","ProductName":"Set nước hoa Vial 01","SalePromotionId":null,"PriceByPromotion":null,"PromotionParentProductId":null,"ProductBatchExpireId":null,"CategoryId":680823,"MasterProductId":15128664,"Unit":"","Uuid":"","ProductWarranty":[]}}],"InvoiceOrderSurcharges":[],"InvoicePromotions":[],"Payments":[{{"Method":"Cash","MethodStr":"Tiền mặt","Amount":{8},"Id":-1}}],"Status":1,"Total":200000,"Surcharge":0,"Type":1,"Uuid":"{9}","addToAccount":"0","PayingAmount":0,"TotalBeforeDiscount":200000,"ProductDiscount":0,"DebugUuid":"","InvoiceWarranties":[],"CreatedBy":201567}}}}    ${BRANCH_ID}    ${get_id_nguoitao}    ${get_id_nguoiban}    ${get_id_nguoiban}
    ...    ${get_id_nguoiban}    ${get_gia_ban}    ${get_id_sp}    ${input_soluong}    ${resull_khtt_all}    ${Uuid_code}
    Log    ${request_payload}
    ${invoice_code}    Post request to create invoice and get invoice code    ${request_payload}
    Return From Keyword    ${invoice_code}

Add new invoice incase changing price product without customer - no payment
    [Arguments]    ${dict_product_nums}    ${list_change}    ${list_change_type}    ${input_gghd}
    ${Uuid}      Generate Random String    4    [NUMBERS][NUMBERS]
    ${Uuid_code}      Catenate      SEPARATOR=      WA     ${Uuid}
    ${list_product_bf}    Get Dictionary Keys    ${dict_product_nums}
    ${list_nums_bf}    Get Dictionary Values    ${dict_product_nums}
    ${list_product}    ${list_nums}    Reverse two lists    ${list_product_bf}    ${list_nums_bf}
    Create list imei and other product    ${list_product}    ${list_nums}
    Sleep    5s
    #get product info
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${list_id_sp}    Get list product id thr API    ${list_product}
    ${list_giaban}    ${list_result_ggsp}    Computation list price and result discount incase changing price by product code    ${list_product}    ${list_change}    ${list_change_type}
    ${list_thanhtien_hh}    Create List
    : FOR    ${giaban}    ${soluong}    IN ZIP    ${list_giaban}    ${list_nums}
    \    ${result_item_thanhtien}    Multiplication and round    ${giaban}    ${soluong}
    \    Append To List    ${list_thanhtien_hh}    ${result_item_thanhtien}
    Log    ${list_thanhtien_hh}
    ${result_tongtienhang}    Sum values in list    ${list_thanhtien_hh}
    ${giamgia_hd}    Set Variable If    0 < ${input_gghd} < 100    ${input_gghd}    null
    ${result_gghd}    Run Keyword If    0 < ${input_gghd} < 100    Convert % discount to VND    ${result_tongtienhang}    ${input_gghd}
    ...    ELSE    Set Variable    ${input_gghd}
    ${get_list_baseprice}    Get list of Baseprice by Product Code    ${list_product}
    #post request
    ${liststring_prs_invoice_detail}    Set Variable    needdel
    Log    ${liststring_prs_invoice_detail}
    : FOR    ${item_gia_ban}    ${item_id_sp}    ${item_soluong}    ${item_imei}    ${item_result_ggsp}    ${item_change}
    ...    ${item_change_type}    ${item_pr}    IN ZIP    ${get_list_baseprice}    ${list_id_sp}    ${list_nums}
    ...    ${imei_inlist}    ${list_result_ggsp}    ${list_change}    ${list_change_type}    ${list_product}
    \    ${item_imei}    Convert list to string and return    ${item_imei}
    \    ${item_ggsp}    Set Variable If    0 < ${item_change} < 100 and '${item_change_type}'=='dis'    ${item_change}    null
    \    ${payload_each_product}    Format string    {{"BasePrice":{0},"IsLotSerialControl":true,"IsRewardPoint":true,"Price":{0},"ProductId":{1},"Quantity":{2},"ProductCode":"{6}","SerialNumbers":"{3}","Weight":0,"Discount":{4},"DiscountRatio":{5},"ProductName":"Điện thoại A","SalePromotionId":null,"PriceByPromotion":null,"PromotionParentProductId":null,"ProductBatchExpireId":null,"CategoryId":439203,"MasterProductId":{1},"Unit":"","Uuid":"","ProductWarranty":[]}}    ${item_gia_ban}    ${item_id_sp}    ${item_soluong}
    \    ...    ${item_imei}    ${item_result_ggsp}    ${item_ggsp}    ${item_pr}
    \    ${liststring_prs_invoice_detail}    Catenate    SEPARATOR=,    ${liststring_prs_invoice_detail}    ${payload_each_product}
    ${liststring_prs_invoice_detail}    Replace String    ${liststring_prs_invoice_detail}    needdel,    ${EMPTY}    count=1
    ${request_payload}    Format String    {{"Invoice":{{"BranchId":{0},"RetailerId":{1},"SoldById":{2},"SoldBy":{{"CreatedBy":0,"CreatedDate":"2017-04-24T11:33:52.877Z","Email":"ngokanh610@gmail.com","GivenName":"TestShard53","Id":{2},"IsActive":true,"IsAdmin":true,"Type":0,"UserName":"admin"}},"SaleChannelId":0,"Seller":{{"CreatedBy":0,"CreatedDate":"2017-04-24T11:33:52.877Z","Email":"ngokanh610@gmail.com","GivenName":"TestShard53","Id":{2},"IsActive":true,"IsAdmin":true,"Type":0,"UserName":"admin"}},"OrderCode":"","Code":"Hóa đơn 1","Discount":{3},"DiscountRatio":{4},"InvoiceDetails":[{5}],"InvoiceOrderSurcharges":[],"InvoicePromotions":[],"Payments":[],"Status":1,"Total":2129584,"Surcharge":0,"Type":1,"Uuid":"{6}","addToAccount":"0","PayingAmount":2129584,"TotalBeforeDiscount":3513115,"ProductDiscount":747422,"DebugUuid":"","InvoiceWarranties":[],"CreatedBy":2}}}}    ${BRANCH_ID}    ${get_id_nguoitao}    ${get_id_nguoiban}    ${result_gghd}
    ...    ${giamgia_hd}    ${liststring_prs_invoice_detail}    ${Uuid_code}
    Log    ${request_payload}
    ${invoice_code}    Post request to create invoice and get invoice code    ${request_payload}
    Return From Keyword    ${invoice_code}

Add new invoice incase changing price product without customer
    [Arguments]    ${dict_product_nums}    ${list_change}    ${list_change_type}    ${input_gghd}    ${input_khtt}
    ${Uuid}      Generate Random String    4    [NUMBERS][NUMBERS]
    ${Uuid_code}      Catenate      SEPARATOR=      WA     ${Uuid}
    ${list_product_bf}    Get Dictionary Keys    ${dict_product_nums}
    ${list_nums_bf}    Get Dictionary Values    ${dict_product_nums}
    ${list_product}    ${list_nums}    Reverse two lists    ${list_product_bf}    ${list_nums_bf}
    Create list imei and other product    ${list_product}    ${list_nums}
    Sleep    5s
    #get product info
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${list_id_sp}    Get list product id thr API    ${list_product}
    ${list_giaban}    ${list_result_ggsp}    Computation list price and result discount incase changing price by product code    ${list_product}    ${list_change}    ${list_change_type}
    ${list_thanhtien_hh}    Create List
    : FOR    ${giaban}    ${soluong}    IN ZIP    ${list_giaban}    ${list_nums}
    \    ${result_item_thanhtien}    Multiplication and round    ${giaban}    ${soluong}
    \    Append To List    ${list_thanhtien_hh}    ${result_item_thanhtien}
    Log    ${list_thanhtien_hh}
    ${result_tongtienhang}    Sum values in list    ${list_thanhtien_hh}
    ${giamgia_hd}    Set Variable If    0 < ${input_gghd} < 100    ${input_gghd}    null
    ${result_gghd}    Run Keyword If    0 < ${input_gghd} < 100    Convert % discount to VND    ${result_tongtienhang}    ${input_gghd}
    ...    ELSE    Set Variable    ${input_gghd}
    ${get_list_baseprice}    Get list of Baseprice by Product Code    ${list_product}
    ${result_khtt}    Minus    ${result_tongtienhang}    ${result_gghd}
    ${actual_khtt}    Set Variable If    '${input_khtt}' == 'all'    ${result_khtt}    ${input_khtt}
    #post request
    ${liststring_prs_invoice_detail}    Set Variable    needdel
    Log    ${liststring_prs_invoice_detail}
    : FOR    ${item_gia_ban}    ${item_id_sp}    ${item_soluong}    ${item_imei}    ${item_result_ggsp}    ${item_change}
    ...    ${item_change_type}    ${item_pr}    IN ZIP    ${get_list_baseprice}    ${list_id_sp}    ${list_nums}
    ...    ${imei_inlist}    ${list_result_ggsp}    ${list_change}    ${list_change_type}    ${list_product}
    \    ${item_imei}    Convert list to string and return    ${item_imei}
    \    ${item_ggsp}    Set Variable If    0 < ${item_change} < 100 and '${item_change_type}'=='dis'    ${item_change}    null
    \    ${payload_each_product}    Format string    {{"BasePrice":{0},"IsLotSerialControl":true,"IsRewardPoint":true,"Price":{0},"ProductId":{1},"Quantity":{2},"ProductCode":"{6}","SerialNumbers":"{3}","Weight":0,"Discount":{4},"DiscountRatio":{5},"ProductName":"Điện thoại A","SalePromotionId":null,"PriceByPromotion":null,"PromotionParentProductId":null,"ProductBatchExpireId":null,"CategoryId":439203,"MasterProductId":{1},"Unit":"","Uuid":"","ProductWarranty":[]}}    ${item_gia_ban}    ${item_id_sp}    ${item_soluong}
    \    ...    ${item_imei}    ${item_result_ggsp}    ${item_ggsp}    ${item_pr}
    \    ${liststring_prs_invoice_detail}    Catenate    SEPARATOR=,    ${liststring_prs_invoice_detail}    ${payload_each_product}
    ${liststring_prs_invoice_detail}    Replace String    ${liststring_prs_invoice_detail}    needdel,    ${EMPTY}    count=1
    ${request_payload}    Format String    {{"Invoice":{{"BranchId":{0},"RetailerId":{1},"SoldById":{2},"SoldBy":{{"CreatedBy":0,"CreatedDate":"2017-04-24T11:33:52.877Z","Email":"ngokanh610@gmail.com","GivenName":"TestShard53","Id":{2},"IsActive":true,"IsAdmin":true,"Type":0,"UserName":"admin"}},"SaleChannelId":0,"Seller":{{"CreatedBy":0,"CreatedDate":"2017-04-24T11:33:52.877Z","Email":"ngokanh610@gmail.com","GivenName":"TestShard53","Id":{2},"IsActive":true,"IsAdmin":true,"Type":0,"UserName":"admin"}},"OrderCode":"","Code":"Hóa đơn 1","Discount":{3},"DiscountRatio":{4},"InvoiceDetails":[{5}],"InvoiceOrderSurcharges":[],"InvoicePromotions":[],"Payments":[{{"Method":"Cash","MethodStr":"Tiền mặt","Amount":{6},"Id":-1}}],"Status":1,"Total":2129584,"Surcharge":0,"Type":1,"Uuid":"{7}","addToAccount":"0","PayingAmount":2129584,"TotalBeforeDiscount":3513115,"ProductDiscount":747422,"DebugUuid":"","InvoiceWarranties":[],"CreatedBy":2}}}}    ${BRANCH_ID}    ${get_id_nguoitao}    ${get_id_nguoiban}    ${result_gghd}
    ...    ${giamgia_hd}    ${liststring_prs_invoice_detail}    ${actual_khtt}    ${Uuid_code}
    Log    ${request_payload}
    ${invoice_code}    Post request to create invoice and get invoice code    ${request_payload}
    Return From Keyword    ${invoice_code}

Add new invoice with multi row product thr API
    [Arguments]    ${dict_product_num}    ${dict_product_type}    ${dict_product_line_num}    ${dict_discount}    ${dict_discount_type}    ${input_invoice_discount}
    ...    ${input_invoice_discount_type}    ${input_bh_ma_kh}    ${input_bh_khachtt}
    [Timeout]
    ${Uuid}      Generate Random String    4    [NUMBERS][NUMBERS]
    ${Uuid_code}      Catenate      SEPARATOR=      WA     ${Uuid}
    ${list_products}    Get Dictionary Keys    ${dict_product_num}
    ${list_nums}    Get Dictionary Values    ${dict_product_num}
    ${list_product_type}    Get Dictionary Values    ${dict_product_type}
    ${list_discount_product}    Get Dictionary Values    ${dict_discount}
    ${list_discount_type}    Get Dictionary Values    ${dict_discount_type}
    ${list_product_line_num}    Get Dictionary Values    ${dict_product_line_num}
    ${list_unit}    Get list of keys from dictionary by value    ${dict_product_type}    unit
    ${list_imei_product}    Get list of keys from dictionary by value    ${dict_product_type}    imei
    ${list_unit_quan}    Get list of values from dictionary by list of keys    ${dict_product_num}    ${list_unit}
    ${list_productid}    Get list product id thr API    ${list_products}
    Log    Convert Lists
    ${list_nums}    Convert string list to composite list    ${list_nums}
    ${list_discount_type}    Convert string list to composite list    ${list_discount_type}
    ${list_discount_product}    Convert string list to composite list    ${list_discount_product}
    ${get_no_bf_execute}    ${get_tongban_bf_execute}    ${get_tongban_tru_trahang_bf_execute}    ${get_customer_name}    Get Customer Info from API    ${input_bh_ma_kh}
    ${list_actual_quan}    Create List
    : FOR    ${item_product}    ${item_list_num}    IN ZIP    ${list_products}    ${list_nums}
    \    ${total_quan_by_product}    Sum values in list    ${item_list_num}
    \    Append to List    ${list_actual_quan}    ${total_quan_by_product}
    Log    ${list_actual_quan}
    Log    Create list imei for imei products
    ${list_imei_all}    create list
    : FOR    ${item_product}    ${item_num}    ${item_product_type}    IN ZIP    ${list_products}    ${list_nums}
    ...    ${list_product_type}
    \    ${list_num_by_product}    Convert String to List    ${item_num}
    \    ${list_imei_by_single_product}=    Run Keyword If    '${item_product_type}' == 'imei'    Import multi imei for mul-line product    ${item_product}    ${list_num_by_product}
    \    ...    ELSE    Create list by list Quantity    ${list_num_by_product}
    \    Append to List    ${list_imei_all}    ${list_imei_by_single_product}
    Log    ${list_imei_all}
    ${list_imei_for_validation}    Copy list    ${list_imei_all}
    Set Global Variable    \${list_imei_all}    ${list_imei_all}
    Set Global Variable    \${list_imei_for_validation}    ${list_imei_for_validation}
    Remove values From List    ${list_imei_for_validation}    nonimei
    ${list_product_for_validation}    ${list_product_quan_for_validation}    ${list_product_type_for_validation}    Remove combo and unit from validation lists    ${list_products}    ${list_actual_quan}    ${list_product_type}
    ${list_product_for_validation}    ${list_product_quan_for_validation}    ${list_product_type_for_validation}    Extract combo and unit products for validation lists    ${list_products}    ${list_actual_quan}    ${list_product_type}
    ...    ${list_product_for_validation}    ${list_product_quan_for_validation}    ${list_product_type_for_validation}
    Log    Get Data
    ${list_result_ton_af_ex}    Get list of result onhand incase changing product price    ${list_product_for_validation}    ${list_product_quan_for_validation}
    ${list_product_id}    ${get_list_baseprice}    ${list_result_product_discount_by_list_product_line}    ${list_result_newprice_by_list_product_line}    ${list_result_totalsale}    Get list of product id - baseprice - list result product discount - list result new price - list total sale incase changing product price    ${list_products}
    ...    ${list_nums}    ${list_discount_product}    ${list_discount_type}
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
    Log    ${list_product_id}
    Log    ${list_product_type}
    Log    ${get_list_baseprice}
    Log    ${list_nums}
    Log    ${list_result_product_discount_by_list_product_line}
    Log    ${list_imei_all}
    ${liststring_prs_invoice_detail}    Create json for Invoice Details in case multi-lines    ${list_product_id}    ${list_product_type}    ${get_list_baseprice}    ${list_nums}    ${list_discount_product}
    ...    ${list_result_product_discount_by_list_product_line}    ${list_discount_type}    ${list_imei_all}
    ${request_payload}    Format String    {{"Invoice":{{"BranchId":{0},"RetailerId":{1},"CustomerId":{2},"SoldById":{3},"SoldBy":{{"CreatedBy":0,"CreatedDate":"2018-12-10T10:42:37.447Z","Email":"","GivenName":"admin","Id":{3},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false}},"SaleChannelId":0,"Seller":{{"CreatedBy":0,"CreatedDate":"2018-12-10T10:42:37.447Z","Email":"","GivenName":"admin","Id":{3},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false}},"OrderCode":"","Code":"Hóa đơn 1","Discount":{4},"DiscountRatio":{5},"InvoiceDetails":[{6}],"InvoiceOrderSurcharges":[],"InvoicePromotions":[],"Payments":[{{"Method":"Cash","MethodStr":"Tiền mặt","Amount":{8},"Id":-1}}],"Status":1,"Total":{7},"Surcharge":0,"Type":1,"Uuid":"{9}","addToAccount":"0","addToAccountSurplus":"0","PayingAmount":{8},"TotalBeforeDiscount":2170500,"ProductDiscount":1268000,"DebugUuid":"","InvoiceWarranties":[],"CreatedBy":196750}}}}    ${BRANCH_ID}    ${get_id_nguoitao}    ${get_id_kh}    ${get_id_nguoiban}
    ...    ${result_gghd}    ${input_invoice_discount_type}    ${liststring_prs_invoice_detail}    ${result_khachcantra}    ${actual_khachtt}    ${Uuid_code}
    Log    ${request_payload}
    ${invoice_code}    Post request to create invoice and get invoice code    ${request_payload}
    Return From Keyword    ${invoice_code}

Add new invoice incase promotion invoice and product - invoice discount
    [Arguments]    ${dict_product_num}    ${dict_product_type}    ${dict_discount}    ${dict_discount_type}    ${input_invoice_discount}    ${input_bh_ma_kh}
    ...    ${input_bh_khachtt}    ${input_khuyemmai}
    [Timeout]    5 mins
    ${Uuid}      Generate Random String    4    [NUMBERS][NUMBERS]
    ${Uuid_code}      Catenate      SEPARATOR=      WA     ${Uuid}
    Toggle status of promotion    ${input_khuyemmai}    1
    ${invoice_value}    ${discount}    ${discount_ratio}    ${name}    ${promotion_sale_id}    ${promotion_id}    Get Invoice value - Discounts - Promotion Name - Promotion Sale - Id from Promotion Code
    ...    ${input_khuyemmai}
    ${list_products}    Get Dictionary Keys    ${dict_product_num}
    ${list_nums}    Get Dictionary Values    ${dict_product_num}
    ${list_product_type}    Get Dictionary Values    ${dict_product_type}
    ${list_discount_product}    Get Dictionary Values    ${dict_discount}
    ${list_discount_type}    Get Dictionary Values    ${dict_discount_type}
    Log    Create list imei for imei products
    ${list_imei_all}    create list
    : FOR    ${item_product}    ${item_num}    ${item_product_type}    IN ZIP    ${list_products}    ${list_nums}
    ...    ${list_product_type}
    \    ${list_imei_by_single_product}    Run Keyword If    '${item_product_type}' == 'imei'    Import multi imei for product    ${item_product}    ${item_num}
    \    ...    ELSE    Set Variable    nonimei
    \    Append to List    ${list_imei_all}    ${list_imei_by_single_product}
    Log    ${list_imei_all}
    Set Test Variable    \${list_imei_all}    ${list_imei_all}
    ${list_result_thanhtien}    ${list_result_newprice}    Get list of total sale - result new price incase changing product price    ${list_products}    ${list_nums}    ${list_discount_product}    ${list_discount_type}
    ${list_product_id}    ${get_list_baseprice}    ${list_result_product_discount}    ${list_result_newprice}    ${list_result_totalsale}    Get list of product id - baseprice - result product discount - result new price - total sale incase changing product price    ${list_products}
    ...    ${list_nums}    ${list_discount_product}    ${list_discount_type}
    Sleep    10s
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${jsonpath_id_kh}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_bh_ma_kh}
    ${get_id_kh}    Get data from API    ${endpoint_khachhang}    ${jsonpath_id_kh}
    ${giamgia_hd}    Set Variable If    0 < ${input_invoice_discount} < 100    ${input_invoice_discount}    null
    ${result_tongtienhang}    Sum values in list    ${list_result_thanhtien}
    ${result_discount_invoice_by_vnd}=    Run Keyword If    0 < ${input_invoice_discount} < 100    Convert % discount to VND and round    ${result_tongtienhang}    ${input_invoice_discount}
    ...    ELSE    Set Variable    ${input_invoice_discount}
    ${actual_promo_discount_value}=    Run Keyword If    ${discount_ratio} != 0    Convert % discount to VND and round    ${result_tongtienhang}    ${discount_ratio}
    ...    ELSE    Set Variable    ${discount}
    ${final_discount}=    Run Keyword If    ${result_tongtienhang} > ${invoice_value}    Sum    ${actual_promo_discount_value}    ${result_discount_invoice_by_vnd}
    ...    ELSE    Set Variable    ${result_discount_invoice_by_vnd}
    ${result_khachcantra}    Minus    ${result_tongtienhang}    ${final_discount}
    ${result_gghd}    Run Keyword If    0 < ${input_invoice_discount} < 100    Convert % discount to VND    ${result_tongtienhang}    ${input_invoice_discount}
    ...    ELSE    Set Variable    ${final_discount}
    ${result_af_invoice_discount}    Minus    ${result_tongtienhang}    ${result_discount_invoice_by_vnd}
    ${actual_khachtt}    Set Variable If    '${input_bh_khachtt}' == 'all'    ${result_khachcantra}    ${input_bh_khachtt}
    # Post request BH
    Log    ${list_product_id}
    Log    ${list_product_type}
    Log    ${get_list_baseprice}
    Log    ${list_nums}
    Log    ${list_result_product_discount}
    Log    ${list_discount_type}
    Log    ${list_discount_type}
    Log    ${list_imei_all}
    #
    ${list_prs_name}    Get list product name thr API    ${list_products}
    ${text_total_invoice}    Convert from number to vnd discount text    ${invoice_value}    000000.0    ,000,000
    ${actual_text_discount}    Run Keyword If    ${discount_ratio} != 0    Convert from number to ratio discount text    ${discount_ratio}
    ...    ELSE    Convert from number to vnd discount text    ${discount}    000.0    ,000
    ${text_promo_info}    Format String    {0}: Tổng tiền hàng từ {1} và mua    ${name}    ${text_total_invoice}
    : FOR    ${item_num}    ${item_pr}    ${item_name}    IN ZIP    ${list_nums}    ${list_products}
    ...    ${list_prs_name}
    \    ${text_prs_info}    Format String    {0} {1} - {2}    ${item_num}    ${item_pr}    ${item_name}
    \    ${text_promo_info}    Catenate    SEPARATOR=,*    ${text_promo_info}    ${text_prs_info}
    Log    ${text_promo_info}
    ${text_promo_info}    Replace String    ${text_promo_info}    mua,    mua
    ${text_promo_info}    Evaluate    "${text_promo_info}".replace("*", " ")
    ${text_gg_info}    Format String    giảm giá {0} cho hóa đơn    ${actual_text_discount}
    ${text_promo_info}    Catenate    ${text_promo_info}    ${text_gg_info}
    Log    ${text_promo_info}
    ${invoice_discount_type}    Set Variable If    ${input_invoice_discount}>100    null    ${input_invoice_discount}
    # Cal
    ${liststring_prs_invoice_detail}    Create json for Invoice Details    ${list_product_id}    ${list_product_type}    ${get_list_baseprice}    ${list_nums}    ${list_discount_product}
    ...    ${list_result_product_discount}    ${list_discount_type}    ${list_imei_all}
    ${request_payload}    Format String    {{"Invoice":{{"BranchId":{0},"RetailerId":{1},"CustomerId":{2},"SoldById":{3},"SoldBy":{{"CreatedBy":0,"CreatedDate":"2018-12-10T10:42:37.447Z","Email":"","GivenName":"admin","Id":{3},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false}},"SaleChannelId":0,"Seller":{{"CreatedBy":0,"CreatedDate":"2018-12-10T10:42:37.447Z","Email":"","GivenName":"admin","Id":{3},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false}},"OrderCode":"","Code":"Hóa đơn 1","Discount":{4},"DiscountRatio":{5},"InvoiceDetails":[{6}],"InvoiceOrderSurcharges":[],"InvoicePromotions":[{{"Type":15,"TargetType":2,"SalePromotionId":{10},"PromotionId":{11},"Discount":200000,"PromotionInfo":"{9}","PrintPromotionInfo":"{9}"}}],"Payments":[{{"Method":"Cash","MethodStr":"Tiền mặt","Amount":{8},"Id":-1}}],"Status":1,"Total":{7},"Surcharge":0,"Type":1,"Uuid":"{12}","addToAccount":"0","addToAccountSurplus":"0","PayingAmount":{8},"TotalBeforeDiscount":2170500,"ProductDiscount":1268000,"DebugUuid":"","InvoiceWarranties":[],"CreatedBy":196750}}}}    ${BRANCH_ID}    ${get_id_nguoitao}    ${get_id_kh}    ${get_id_nguoiban}
    ...    ${final_discount}    ${invoice_discount_type}    ${liststring_prs_invoice_detail}    ${result_khachcantra}    ${actual_khachtt}    ${text_promo_info}
    ...    ${promotion_sale_id}    ${promotion_id}    ${Uuid_code}
    Log    ${request_payload}
    ${invoice_code}    Post request to create invoice and get invoice code    ${request_payload}
    Toggle status of promotion    ${input_khuyemmai}    0
    Return From Keyword    ${invoice_code}

Add new invoice incase promotion invoice and product - product discount
    [Arguments]    ${dict_product_num}    ${dict_product_type}    ${dict_discount}    ${dict_discount_type}    ${input_invoice_discount}    ${input_bh_ma_kh}
    ...    ${input_bh_khachtt}    ${input_khuyemmai}    ${dict_promo_product}
    [Timeout]    5 mins
    ${Uuid}      Generate Random String    4    [NUMBERS][NUMBERS]
    ${Uuid_code}      Catenate      SEPARATOR=      WA     ${Uuid}
    Toggle status of promotion    ${input_khuyemmai}    1
    ${invoice_value}    ${discount}    ${discount_ratio}    ${name}    ${promotion_sale_id}    ${promotion_id}    Get Invoice value - Product Discounts - Promotion Name - Promotion Id - Campaign Id from Promotion Code
    ...    ${input_khuyemmai}
    ${list_products}    Get Dictionary Keys    ${dict_product_num}
    ${list_nums}    Get Dictionary Values    ${dict_product_num}
    ${list_product_type}    Get Dictionary Values    ${dict_product_type}
    ${list_discount_product}    Get Dictionary Values    ${dict_discount}
    ${list_discount_type}    Get Dictionary Values    ${dict_discount_type}
    ${list_promo_product}    Get Dictionary Keys    ${dict_promo_product}
    ${list_promo_type}    Get Dictionary Values    ${dict_promo_product}
    Log    Create list imei for imei products
    ${get_list_imei_status}    Get list imei status thr API    ${list_products}
    ${list_imei_all}    create list
    : FOR    ${item_product}    ${item_num}    ${item_product_type}    IN ZIP    ${list_products}    ${list_nums}
    ...    ${list_product_type}
    \    ${list_imei_by_single_product}=    Run Keyword If    '${item_product_type}' == 'imei'    Import multi imei for product    ${item_product}    ${item_num}
    \    ...    ELSE    Set Variable    nonimei
    \    Append to List    ${list_imei_all}    ${list_imei_by_single_product}
    Log    ${list_imei_all}
    Set Test Variable    \${list_imei_all}    ${list_imei_all}
    ${list_product_id}    ${get_list_baseprice}    ${list_result_product_discount}    ${list_result_newprice}    ${list_result_totalsale}    Get list of product id - baseprice - result product discount - result new price - total sale incase changing product price    ${list_products}
    ...    ${list_nums}    ${list_discount_product}    ${list_discount_type}
    Sleep    10s
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${jsonpath_id_kh}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_bh_ma_kh}
    ${get_id_kh}    Get data from API    ${endpoint_khachhang}    ${jsonpath_id_kh}
    ${giamgia_hd}    Set Variable If    0 < ${input_invoice_discount} < 100    ${input_invoice_discount}    null
    ${list_product_promo_id}    Create List
    : FOR    ${item_pr_id}    ${item_promo_type}    ${item_pr}    IN ZIP    ${list_product_id}    ${list_promo_type}
    ...    ${list_products}
    \    ${pr_promo_id}    Run Keyword If    '${item_promo_type}' == 'getpromo'    Set Variable    ${item_pr_id}
    \    ...    ELSE    Log    Ingore
    \    Run Keyword If    '${item_promo_type}' == 'getpromo'    Append To List    ${list_product_promo_id}    ${pr_promo_id}
    \    ...    ELSE    Log    Ignore
    Log    ${list_product_promo_id}
    ${product_promo_id}    Get From List    ${list_product_promo_id}    0
    ${list_promo_id_value_payload}    Create List
    : FOR    ${item_promo_type}    IN ZIP    ${list_promo_type}
    \    ${item_promo_id_value}    Run Keyword If    '${item_promo_type}' == 'getpromo'    Set Variable    ${promotion_sale_id}
    \    ...    ELSE    Set Variable    null
    \    Append to list    ${list_promo_id_value_payload}    ${item_promo_id_value}
    ${result_tongtienhang}    Sum values in list    ${list_result_totalsale}
    ${result_discount_invoice_by_vnd}    Run Keyword If    0 < ${input_invoice_discount} < 100    Convert % discount to VND and round    ${result_tongtienhang}    ${input_invoice_discount}
    ...    ELSE    Set Variable    ${input_invoice_discount}
    ${result_khachcantra}    Minus    ${result_tongtienhang}    ${result_discount_invoice_by_vnd}
    ${actual_khachtt}    Set Variable If    '${input_bh_khachtt}' == 'all'    ${result_khachcantra}    ${input_bh_khachtt}
    ${invoice_discount_type}    Set Variable If    ${input_invoice_discount}>100    null    ${input_invoice_discount}
    #
    ${list_promo_discount}    Create List
    : FOR    ${item_discount}    ${item_promo_type}    IN ZIP    ${list_discount_product}    ${list_promo_type}
    \    Run Keyword If    '${item_promo_type}' == 'getpromo'    Append To List    ${list_promo_discount}    ${item_discount}
    \    ...    ELSE    Log    ignore
    Log    ${list_promo_discount}
    ${get_promo_discount}    Get From List    ${list_promo_discount}    0
    ${actual_text_dis}    Run Keyword If    ${get_promo_discount}<100    Convert from number to ratio discount text    ${get_promo_discount}
    ...    ELSE    Convert from number to vnd discount text    ${get_promo_discount}    000    ,000
    #
    ${list_prs_name}    Get list product name thr API    ${list_products}
    ${text_total_invoice}    Convert from number to vnd discount text    ${invoice_value}    000000.0    ,000,000
    ${text_promo_info}    Format String    {0}: Tổng tiền hàng từ {1} và mua    ${name}    ${text_total_invoice}
    : FOR    ${item_num}    ${item_pr}    ${item_name}    IN ZIP    ${list_nums}    ${list_products}
    ...    ${list_prs_name}
    \    ${text_prs_info}    Format String    {0} {1} - {2}    ${item_num}    ${item_pr}    ${item_name}
    \    ${text_promo_info}    Catenate    SEPARATOR=,*    ${text_promo_info}    ${text_prs_info}
    Log    ${text_promo_info}
    ${text_promo_dis}    Format String    giảm giá {0} cho    ${actual_text_dis}
    ${text_promo_info}    Catenate    ${text_promo_info}    ${text_promo_dis}
    : FOR    ${item_num}    ${item_pr}    ${item_name}    ${item_promo_type}    IN ZIP    ${list_nums}
    ...    ${list_products}    ${list_prs_name}    ${list_promo_type}
    \    ${text_km_info}    Run Keyword If    '${item_promo_type}' == 'getpromo'    Format String    {0} {1} - {2}    ${item_num}
    \    ...    ${item_pr}    ${item_name}
    \    ...    ELSE    Log    Ignore
    \    ${text_promo_info}    Run Keyword If    '${item_promo_type}' == 'getpromo'    Catenate    SEPARATOR=,*    ${text_promo_info}
    \    ...    ${text_prs_info}
    \    ...    ELSE    Set Variable    ${text_promo_info}
    ${text_promo_info}    Replace String    ${text_promo_info}    mua,    mua
    ${text_promo_info}    Replace String    ${text_promo_info}    cho,    cho
    ${text_promo_info}    Evaluate    "${text_promo_info}".replace("*", " ")
    Log    ${text_promo_info}
    ${liststring_prs_invoice_detail}    Create json in case promotion for Invoice Details    ${list_product_id}    ${list_product_type}    ${get_list_baseprice}    ${list_nums}    ${list_discount_product}
    ...    ${list_result_product_discount}    ${list_discount_type}    ${list_imei_all}    ${list_promo_id_value_payload}
    ${request_payload}    Format String    {{"Invoice":{{"BranchId":{0},"RetailerId":{1},"CustomerId":{2},"SoldById":{3},"SoldBy":{{"CreatedBy":0,"CreatedDate":"2018-12-10T10:42:37.447Z","Email":"","GivenName":"admin","Id":{3},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false}},"SaleChannelId":0,"Seller":{{"CreatedBy":0,"CreatedDate":"2018-12-10T10:42:37.447Z","Email":"","GivenName":"admin","Id":{3},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false}},"OrderCode":"","Code":"Hóa đơn 1","Discount":{4},"DiscountRatio":{5},"InvoiceDetails":[{6}],"InvoiceOrderSurcharges":[],"InvoicePromotions":[{{"Type":15,"TargetType":2,"SalePromotionId":{10},"PromotionId":{11},"ProductId": {12},"Discount":200000,"PromotionInfo":"{9}","PrintPromotionInfo":"{9}","ProductIds": "{12}"}}],"Payments":[{{"Method":"Cash","MethodStr":"Tiền mặt","Amount":{8},"Id":-1}}],"Status":1,"Total":{7},"Surcharge":0,"Type":1,"Uuid":"{13}","addToAccount":"0","addToAccountSurplus":"0","PayingAmount":{8},"TotalBeforeDiscount":2170500,"ProductDiscount":1268000,"DebugUuid":"","InvoiceWarranties":[],"CreatedBy":196750}}}}    ${BRANCH_ID}    ${get_id_nguoitao}    ${get_id_kh}    ${get_id_nguoiban}
    ...    ${result_discount_invoice_by_vnd}    ${invoice_discount_type}    ${liststring_prs_invoice_detail}    ${result_khachcantra}    ${actual_khachtt}    ${text_promo_info}
    ...    ${promotion_sale_id}    ${promotion_id}    ${product_promo_id}    ${Uuid_code}
    Log    ${request_payload}
    ${invoice_code}    Post request to create invoice and get invoice code    ${request_payload}
    Toggle status of promotion    ${input_khuyemmai}    0
    Return From Keyword    ${invoice_code}

Add new invoice incase promotion invoice and product - offering free items
    [Arguments]    ${dict_product_num}    ${dict_product_type}    ${dict_discount}    ${dict_discount_type}    ${input_invoice_discount}    ${input_bh_ma_kh}
    ...    ${input_bh_khachtt}    ${input_khuyemmai}    ${dict_promo_product}
    ${Uuid}      Generate Random String    4    [NUMBERS][NUMBERS]
    ${Uuid_code}      Catenate      SEPARATOR=      WA     ${Uuid}
    Toggle status of promotion    ${input_khuyemmai}    1
    ${invoice_value}    ${received_value}    ${discount}    ${discount_ratio}    ${name}    ${promotion_sale_id}    ${promotion_id}
    ...    Get Invoice value - Received value - Discounts - Promotion Name - Promotion Id - Promotion Sale Id from Promotion Code    ${input_khuyemmai}
    ${list_products}    Get Dictionary Keys    ${dict_product_num}
    ${list_nums}    Get Dictionary Values    ${dict_product_num}
    ${list_product_type}    Get Dictionary Values    ${dict_product_type}
    ${list_discount_product}    Get Dictionary Values    ${dict_discount}
    ${list_discount_type}    Get Dictionary Values    ${dict_discount_type}
    ${list_promo_product}    Get Dictionary Keys    ${dict_promo_product}
    ${list_promo_type}    Get Dictionary Values    ${dict_promo_product}
    Log    Create list imei for imei products
    ${list_imei_all}    create list
    : FOR    ${item_product}    ${item_num}    ${item_product_type}    IN ZIP    ${list_products}    ${list_nums}
    ...    ${list_product_type}
    \    ${list_imei_by_single_product}=    Run Keyword If    '${item_product_type}' == 'imei'    Import multi imei for product    ${item_product}    ${item_num}
    \    ...    ELSE    Set Variable    nonimei
    \    Append to List    ${list_imei_all}    ${list_imei_by_single_product}
    Log    ${list_imei_all}
    Set Test Variable    \${list_imei_all}    ${list_imei_all}
    #
    ${list_product_id}    ${get_list_baseprice}    ${list_result_product_discount}    ${list_result_newprice}    ${list_result_totalsale}    Get list of product id - baseprice - result product discount - result new price - total sale incase changing product price    ${list_products}
    ...    ${list_nums}    ${list_discount_product}    ${list_discount_type}
    Sleep    10 s
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${jsonpath_id_kh}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_bh_ma_kh}
    ${get_id_kh}    Get data from API    ${endpoint_khachhang}    ${jsonpath_id_kh}
    ${giamgia_hd}    Set Variable If    0 < ${input_invoice_discount} < 100    ${input_invoice_discount}    null
    ${product_promo_id}    Get product id thr API    DVT0215
    ${list_promo_id_value_payload}    Create List
    : FOR    ${item_promo_type}    IN ZIP    ${list_promo_type}
    \    ${item_promo_id_value}    Run Keyword If    '${item_promo_type}' == 'getpromo'    Set Variable    ${promotion_sale_id}
    \    ...    ELSE    Set Variable    null
    \    Append to list    ${list_promo_id_value_payload}    ${item_promo_id_value}
    ${result_tongtienhang}    Sum values in list    ${list_result_totalsale}
    ${result_discount_invoice_by_vnd}    Run Keyword If    0 < ${input_invoice_discount} < 100    Convert % discount to VND and round    ${result_tongtienhang}    ${input_invoice_discount}
    ...    ELSE    Set Variable    ${input_invoice_discount}
    ${result_khachcantra}    Minus    ${result_tongtienhang}    ${result_discount_invoice_by_vnd}
    ${actual_khachtt}    Set Variable If    '${input_bh_khachtt}' == 'all'    ${result_khachcantra}    ${input_bh_khachtt}
    ${invoice_discount_type}    Set Variable If    ${input_invoice_discount}>100    null    ${input_invoice_discount}
    #
    ${list_prs_name}    Get list product name thr API    ${list_products}
    ${text_total_invoice}    Convert from number to vnd discount text    ${invoice_value}    000000.0    ,000,000
    ${text_promo_info}    Format String    {0}: Tổng tiền hàng từ {1} và mua    ${name}    ${text_total_invoice}
    : FOR    ${item_num}    ${item_pr}    ${item_name}    IN ZIP    ${list_nums}    ${list_products}
    ...    ${list_prs_name}
    \    ${text_prs_info}    Format String    {0} {1} - {2}    ${item_num}    ${item_pr}    ${item_name}
    \    ${text_promo_info}    Catenate    SEPARATOR=,*    ${text_promo_info}    ${text_prs_info}
    Log    ${text_promo_info}
    ${text_promo_info}    Catenate    ${text_promo_info}    tặng
    : FOR    ${item_num}    ${item_pr}    ${item_name}    ${item_promo_type}    IN ZIP    ${list_nums}
    ...    ${list_products}    ${list_prs_name}    ${list_promo_type}
    \    ${text_km_info}    Run Keyword If    '${item_promo_type}' == 'getpromo'    Format String    {0} {1} - {2}    ${item_num}
    \    ...    ${item_pr}    ${item_name}
    \    ...    ELSE    Log    Ignore
    \    ${text_promo_info}    Run Keyword If    '${item_promo_type}' == 'getpromo'    Catenate    SEPARATOR=,*    ${text_promo_info}
    \    ...    ${text_prs_info}
    \    ...    ELSE    Set Variable    ${text_promo_info}
    ${text_promo_info}    Replace String    ${text_promo_info}    mua,    mua
    ${text_promo_info}    Evaluate    "${text_promo_info}".replace("*", " ")
    #
    ${liststring_prs_invoice_detail}    Create json in case promotion for Invoice Details    ${list_product_id}    ${list_product_type}    ${get_list_baseprice}    ${list_nums}    ${list_discount_product}
    ...    ${list_result_product_discount}    ${list_discount_type}    ${list_imei_all}    ${list_promo_id_value_payload}
    ${request_payload}    Format String    {{"Invoice":{{"BranchId":{0},"RetailerId":{1},"CustomerId":{2},"SoldById":{3},"SoldBy":{{"CreatedBy":0,"CreatedDate":"2018-12-10T10:42:37.447Z","Email":"","GivenName":"admin","Id":{3},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false}},"SaleChannelId":0,"Seller":{{"CreatedBy":0,"CreatedDate":"2018-12-10T10:42:37.447Z","Email":"","GivenName":"admin","Id":{3},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false}},"OrderCode":"","Code":"Hóa đơn 1","Discount":{4},"DiscountRatio":{5},"InvoiceDetails":[{6}],"InvoiceOrderSurcharges":[],"InvoicePromotions":[{{"Type":15,"TargetType":2,"SalePromotionId":{10},"PromotionId":{11},"ProductId": {12},"Discount":200000,"PromotionInfo":"{9}","PrintPromotionInfo":"{9}","ProductIds": "{12}"}}],"Payments":[{{"Method":"Cash","MethodStr":"Tiền mặt","Amount":{8},"Id":-1}}],"Status":1,"Total":{7},"Surcharge":0,"Type":1,"Uuid":"{13}","addToAccount":"0","addToAccountSurplus":"0","PayingAmount":{8},"TotalBeforeDiscount":2170500,"ProductDiscount":1268000,"DebugUuid":"","InvoiceWarranties":[],"CreatedBy":196750}}}}    ${BRANCH_ID}    ${get_id_nguoitao}    ${get_id_kh}    ${get_id_nguoiban}
    ...    ${result_discount_invoice_by_vnd}    ${invoice_discount_type}    ${liststring_prs_invoice_detail}    ${result_khachcantra}    ${actual_khachtt}    ${text_promo_info}
    ...    ${promotion_sale_id}    ${promotion_id}    ${product_promo_id}    ${Uuid_code}
    Log    ${request_payload}
    ${invoice_code}    Post request to create invoice and get invoice code    ${request_payload}
    Toggle status of promotion    ${input_khuyemmai}    0
    Return From Keyword    ${invoice_code}

Add new invoice - payment surplus frm API
    [Arguments]    ${input_ma_kh}    ${dict_product_nums}    ${input_khtt}
    ${Uuid}      Generate Random String    4    [NUMBERS][NUMBERS]
    ${Uuid_code}      Catenate      SEPARATOR=      WA     ${Uuid}
    ${list_product}    Get Dictionary Keys    ${dict_product_nums}
    ${list_nums}    Get Dictionary Values    ${dict_product_nums}
    Create list imei and other product    ${list_product}    ${list_nums}
    #get product info
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${jsonpath_id_kh}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_kh}
    ${get_id_kh}    Get data from API    ${endpoint_khachhang}    ${jsonpath_id_kh}
    ${endpoint_danhmuc_hh_co_dvt}    Format String    ${endpoint_list_hh_in_mhbh}    ${BRANCH_ID}    ${BRANCH_ID}
    ${get_resp_danhmuc_hh}    Get Request and return body    ${endpoint_danhmuc_hh_co_dvt}
    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}    Get list jsonpath product frm list product    ${list_product}
    ${list_giaban}    ${list_id_sp}    Get product info frm list jsonpath product    ${get_resp_danhmuc_hh}    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}
    ${list_thanhtien_hh}    Create List
    : FOR    ${giaban}    ${soluong}    IN ZIP    ${list_giaban}    ${list_nums}
    \    ${result_item_thanhtien}    Multiplication and round    ${giaban}    ${soluong}
    \    Append To List    ${list_thanhtien_hh}    ${result_item_thanhtien}
    Log    ${list_thanhtien_hh}
    ${result_tongtienhang}    Sum values in list    ${list_thanhtien_hh}
    ${actual_khtt}    Set Variable If    '${input_khtt}' == 'all'    ${result_tongtienhang}    ${input_khtt}
    #post request
    ${liststring_prs_invoice_detail}    Set Variable    needdel
    Log    ${liststring_prs_invoice_detail}
    : FOR    ${item_gia_ban}    ${item_id_sp}    ${item_soluong}    ${item_imei}    IN ZIP    ${list_giaban}
    ...    ${list_id_sp}    ${list_nums}    ${imei_inlist}
    \    ${item_imei}    Convert list to string and return    ${item_imei}
    \    ${payload_each_product}    Format string    {{"BasePrice":{0},"IsLotSerialControl":true,"IsRewardPoint":true,"Price":{0},"ProductId":{1},"Quantity":{2},"ProductCode":"SP000447","SerialNumbers":"{3}","Weight":0,"Discount":0,"DiscountRatio":0,"ProductName":"Điện thoại A","SalePromotionId":null,"PriceByPromotion":null,"PromotionParentProductId":null,"ProductBatchExpireId":null,"CategoryId":439203,"MasterProductId":{1},"Unit":"","Uuid":"","ProductWarranty":[]}}    ${item_gia_ban}    ${item_id_sp}    ${item_soluong}
    \    ...    ${item_imei}
    \    ${liststring_prs_invoice_detail}    Catenate    SEPARATOR=,    ${liststring_prs_invoice_detail}    ${payload_each_product}
    ${liststring_prs_invoice_detail}    Replace String    ${liststring_prs_invoice_detail}    needdel,    ${EMPTY}    count=1
    ${request_payload}    Format String    {{"Invoice":{{"BranchId":{0},"RetailerId":{1},"UpdateInvoiceId":0,"UpdateReturnId":0,"CustomerId":{2},"SoldById":{3},"SoldBy":{{"CreatedBy":0,"CreatedDate":"2018-07-30T08:27:36.800Z","Email":"","GivenName":"anh.lv","Id":{3},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false}},"SaleChannelId":0,"Seller":{{"CreatedBy":0,"CreatedDate":"2018-07-30T08:27:36.800Z","Email":"","GivenName":"anh.lv","Id":{3},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false}},"OrderCode":"","Code":"Hóa đơn 1","InvoiceDetails":[{4}],"InvoiceOrderSurcharges":[],"InvoicePromotions":[],"Payments":[{{"Method":"Cash","MethodStr":"Tiền mặt","Amount":{5},"Id":-1}}],"PaymentSurplus":[],"Status":1,"Total":{6},"Surcharge":0,"Type":1,"Uuid":"{7}","addToAccount":"0","addToAccountSurplus":"1","addToAccountAllocation":"0","addToAccountPaymentAllocation":"1","PayingAmount":{5},"TotalBeforeDiscount":{6},"ProductDiscount":0,"DebugUuid":"","InvoiceWarranties":[],"CreatedBy":201567}}}}    ${BRANCH_ID}    ${get_id_nguoitao}    ${get_id_kh}    ${get_id_nguoiban}
    ...    ${liststring_prs_invoice_detail}    ${actual_khtt}    ${result_tongtienhang}    ${Uuid_code}
    Log    ${request_payload}
    ${invoice_code}    Post request to create invoice and get invoice code    ${request_payload}
    Return From Keyword    ${invoice_code}

Add new invoice - payment allocation frm API
    [Arguments]    ${input_ma_kh}    ${dict_product_nums}    ${input_khtt}
    ${Uuid}      Generate Random String    4    [NUMBERS][NUMBERS]
    ${Uuid_code}      Catenate      SEPARATOR=      WA     ${Uuid}
    ${list_product}    Get Dictionary Keys    ${dict_product_nums}
    ${list_nums}    Get Dictionary Values    ${dict_product_nums}
    Create list imei and other product    ${list_product}    ${list_nums}
    #get product info
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${jsonpath_id_kh}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_kh}
    ${get_id_kh}    Get data from API    ${endpoint_khachhang}    ${jsonpath_id_kh}
    ${endpoint_danhmuc_hh_co_dvt}    Format String    ${endpoint_list_hh_in_mhbh}    ${BRANCH_ID}    ${BRANCH_ID}
    ${get_resp_danhmuc_hh}    Get Request and return body    ${endpoint_danhmuc_hh_co_dvt}
    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}    Get list jsonpath product frm list product    ${list_product}
    ${list_giaban}    ${list_id_sp}    Get product info frm list jsonpath product    ${get_resp_danhmuc_hh}    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}
    ${list_thanhtien_hh}    Create List
    : FOR    ${giaban}    ${soluong}    IN ZIP    ${list_giaban}    ${list_nums}
    \    ${result_item_thanhtien}    Multiplication and round    ${giaban}    ${soluong}
    \    Append To List    ${list_thanhtien_hh}    ${result_item_thanhtien}
    Log    ${list_thanhtien_hh}
    ${result_tongtienhang}    Sum values in list    ${list_thanhtien_hh}
    ${actual_khtt}    Set Variable If    '${input_khtt}' == 'all'    ${result_tongtienhang}    ${input_khtt}
    #post request
    ${liststring_prs_invoice_detail}    Set Variable    needdel
    Log    ${liststring_prs_invoice_detail}
    : FOR    ${item_gia_ban}    ${item_id_sp}    ${item_soluong}    ${item_imei}    IN ZIP    ${list_giaban}
    ...    ${list_id_sp}    ${list_nums}    ${imei_inlist}
    \    ${item_imei}    Convert list to string and return    ${item_imei}
    \    ${payload_each_product}    Format string    {{"BasePrice":{0},"IsLotSerialControl":true,"IsRewardPoint":true,"Price":{0},"ProductId":{1},"Quantity":{2},"ProductCode":"SP000447","SerialNumbers":"{3}","Weight":0,"Discount":0,"DiscountRatio":0,"ProductName":"Điện thoại A","SalePromotionId":null,"PriceByPromotion":null,"PromotionParentProductId":null,"ProductBatchExpireId":null,"CategoryId":439203,"MasterProductId":{1},"Unit":"","Uuid":"","ProductWarranty":[]}}    ${item_gia_ban}    ${item_id_sp}    ${item_soluong}
    \    ...    ${item_imei}
    \    ${liststring_prs_invoice_detail}    Catenate    SEPARATOR=,    ${liststring_prs_invoice_detail}    ${payload_each_product}
    ${liststring_prs_invoice_detail}    Replace String    ${liststring_prs_invoice_detail}    needdel,    ${EMPTY}    count=1
    ${request_payload}    Format String    {{"Invoice":{{"BranchId":{0},"RetailerId":{1},"UpdateInvoiceId":0,"UpdateReturnId":0,"CustomerId":{2},"SoldById":{3},"SoldBy":{{"CreatedBy":0,"CreatedDate":"2018-07-30T08:27:36.800Z","Email":"","GivenName":"anh.lv","Id":{3},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false}},"SaleChannelId":0,"SaleChannel":null,"Seller":{{"CreatedBy":0,"CreatedDate":"2018-07-30T08:27:36.800Z","Email":"","GivenName":"anh.lv","Id":{3},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false}},"OrderCode":"","Code":"Hóa đơn 1","InvoiceDetails":[{4}],"InvoiceOrderSurcharges":[],"InvoicePromotions":[],"Payments":[{{"Method":"Cash","MethodStr":"Tiền mặt","Amount":{5},"Id":-1}}],"PaymentsAllocations":[],"Status":1,"Total":{6},"Surcharge":0,"Type":1,"Uuid":"{7}","addToAccount":"1","addToAccountSurplus":"0","addToAccountAllocation":"1","addToAccountPaymentAllocation":"0","PayingAmount":{5},"TotalBeforeDiscount":{6},"ProductDiscount":0,"DebugUuid":"","InvoiceWarranties":[],"CreatedBy":201567}}}}    ${BRANCH_ID}    ${get_id_nguoitao}    ${get_id_kh}    ${get_id_nguoiban}
    ...    ${liststring_prs_invoice_detail}    ${actual_khtt}    ${result_tongtienhang}    ${Uuid_code}
    Log    ${request_payload}
    ${invoice_code}    Post request to create invoice and get invoice code    ${request_payload}
    Return From Keyword    ${invoice_code}

Get allocation id frm sale api
    [Arguments]    ${input_ma_kh}    ${input_ma_ptt}
    ${get_id_kh}    Get customer id thr API    ${input_ma_kh}
    ${endpoint_phanbo}    Format String    ${endpoint_phanbo_mhbh}    ${get_id_kh}
    ${jsonpath_id_allocate}    Format String    $.Data[?(@.Code == "{0}")].Id    ${input_ma_ptt}
    ${get_id_allocate}    Get data from API by other url    ${SALE_API_URL}    ${endpoint_phanbo}    ${jsonpath_id_allocate}
    Return From Keyword    ${get_id_allocate}

Add new invoice with product
    [Arguments]    ${input_ma_kh}    ${input_product}    ${input_soluong}    ${input_khtt}
    ${Uuid}      Generate Random String    4    [NUMBERS][NUMBERS]
    ${Uuid_code}      Catenate      SEPARATOR=      WA     ${Uuid}
    ${jsonpath_id_kh}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_kh}
    ${jsonpath_id_sp}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_product}
    ${jsonpath_gia_ban}    Format String    $..Data[?(@.Code == '{0}')].BasePrice    ${input_product}
    ${get_id_kh}    Get data from API    ${endpoint_khachhang}    ${jsonpath_id_kh}
    ${endpoint_danhmuc_hh_co_dvt}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${get_id_sp}    Get data from API     ${endpoint_danhmuc_hh_co_dvt}    ${jsonpath_id_sp}
    ${get_gia_ban}    Get data from API     ${endpoint_danhmuc_hh_co_dvt}    ${jsonpath_gia_ban}
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${result_thanhtien}    Multiplication and round    ${get_gia_ban}    ${input_soluong}
    ${resull_khtt_all}    Set Variable If    '${input_khtt}' == 'all'    ${result_thanhtien}    ${input_khtt}
    ${request_payload}    Format String    {{"Invoice":{{"BranchId":{0},"RetailerId":{1},"CustomerId":{2},"SoldById":{3},"SoldBy":{{"CreatedBy":0,"CreatedDate":"2018-07-30T08:27:36.800Z","Email":"","GivenName":"anh.lv","Id":{4},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false}},"SaleChannelId":0,"SaleChannel":null,"Seller":{{"CreatedBy":0,"CreatedDate":"2018-07-30T08:27:36.800Z","Email":"","GivenName":"anh.lv","Id":{5},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false}},"OrderCode":"","Code":"Hóa đơn 1","InvoiceDetails":[{{"BasePrice":200000,"IsLotSerialControl":false,"IsRewardPoint":false,"Note":"","Price":{6},"ProductId":{7},"Quantity":{8},"ProductCode":"Combo01","ProductName":"Set nước hoa Vial 01","SalePromotionId":null,"PriceByPromotion":null,"PromotionParentProductId":null,"ProductBatchExpireId":null,"CategoryId":680823,"MasterProductId":15128664,"Unit":"","Uuid":"","ProductWarranty":[]}}],"InvoiceOrderSurcharges":[],"InvoicePromotions":[],"Payments":[{{"Method":"Cash","MethodStr":"Tiền mặt","Amount":{9},"Id":-1}}],"Status":1,"Total":{9},"Surcharge":0,"Type":1,"Uuid":"","addToAccount":"0","PayingAmount":0,"TotalBeforeDiscount":{9},"ProductDiscount":0,"DebugUuid":"","InvoiceWarranties":[],"CreatedBy":201567}}}}    ${BRANCH_ID}    ${get_id_nguoitao}    ${get_id_kh}    ${get_id_nguoiban}
    ...    ${get_id_nguoiban}    ${get_id_nguoiban}    ${get_gia_ban}    ${get_id_sp}    ${input_soluong}    ${resull_khtt_all}
    Log    ${request_payload}
    ${invoice_code}    Post request to create invoice and get invoice code    ${request_payload}
    Return From Keyword    ${invoice_code}

##gop discount and newprice
Add new invoice incase discount - no payment and return code
    [Arguments]    ${input_ma_kh}    ${dict_product_nums}    ${list_ggsp}    ${list_discount_type}    ${input_gghd}    ${list_imei_all}
    ${Uuid}      Generate Random String    4    [NUMBERS][NUMBERS]
    ${Uuid_code}      Catenate      SEPARATOR=      WA     ${Uuid}
    ${list_product_bf}    Get Dictionary Keys    ${dict_product_nums}
    ${list_nums_bf}    Get Dictionary Values    ${dict_product_nums}
    #get product info
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${jsonpath_id_kh}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_kh}
    ${get_id_kh}    Get data from API    ${endpoint_khachhang}    ${jsonpath_id_kh}
    ${endpoint_danhmuc_hh_co_dvt}    Format String    ${endpoint_list_hh_in_mhbh}    ${BRANCH_ID}    ${BRANCH_ID}
    ${get_resp_danhmuc_hh}    Get Request and return body    ${endpoint_danhmuc_hh_co_dvt}
    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}    Get list jsonpath product frm list product    ${list_product_bf}
    ${list_giaban}    ${list_result_ggsp}    ${list_id_sp}    ${list_thanhtien}    Get product info frm list jsonpath product incase discount product - return total sale    ${get_resp_danhmuc_hh}    ${list_jsonpath_id_sp}
    ...    ${list_jsonpath_giaban}    ${list_ggsp}    ${list_discount_type}    ${list_nums_bf}
    ${result_tongtienhang}    Sum values in list    ${list_thanhtien}
    ${giamgia_hd}    Set Variable If    0 < ${input_gghd} < 100    ${input_gghd}    null
    ${result_gghd}    Run Keyword If    0 < ${input_gghd} < 100    Convert % discount to VND    ${result_tongtienhang}    ${input_gghd}
    ...    ELSE    Set Variable    ${input_gghd}
    #post request
    ${liststring_prs_invoice_detail}    Set Variable    needdel
    Log    ${liststring_prs_invoice_detail}
    : FOR    ${item_gia_ban}    ${item_id_sp}    ${item_soluong}    ${item_imei}    ${item_result_ggsp}    ${item_ggsp}
    ...    ${item_pr}    IN ZIP    ${list_giaban}    ${list_id_sp}    ${list_nums_bf}    ${list_imei_all}
    ...    ${list_result_ggsp}    ${list_ggsp}    ${list_product_bf}
    \    ${item_imei}    Convert list to string and return    ${item_imei}
    \    ${item_ggsp}    Set Variable If    0 < ${item_ggsp} < 100    ${item_ggsp}    0
    \    ${payload_each_product}    Format string    {{"BasePrice":{0},"IsLotSerialControl":true,"IsRewardPoint":true,"Price":{0},"ProductId":{1},"Quantity":{2},"ProductCode":"{6}","SerialNumbers":"{3}","Weight":0,"Discount":{4},"DiscountRatio":{5},"ProductName":"Điện thoại A","SalePromotionId":null,"PriceByPromotion":null,"PromotionParentProductId":null,"ProductBatchExpireId":null,"CategoryId":439203,"MasterProductId":{1},"Unit":"","Uuid":"","ProductWarranty":[]}}    ${item_gia_ban}    ${item_id_sp}    ${item_soluong}
    \    ...    ${item_imei}    ${item_result_ggsp}    ${item_ggsp}    ${item_pr}
    \    ${liststring_prs_invoice_detail}    Catenate    SEPARATOR=,    ${liststring_prs_invoice_detail}    ${payload_each_product}
    ${liststring_prs_invoice_detail}    Replace String    ${liststring_prs_invoice_detail}    needdel,    ${EMPTY}    count=1
    ${request_payload}    Format String    {{"Invoice":{{"BranchId":{0},"RetailerId":{1},"CustomerId":{2},"SoldById":{3},"SoldBy":{{"CreatedBy":0,"CreatedDate":"2017-04-24T11:33:52.877Z","Email":"ngokanh610@gmail.com","GivenName":"TestShard53","Id":{3},"IsActive":true,"IsAdmin":true,"Type":0,"UserName":"admin"}},"SaleChannelId":0,"Seller":{{"CreatedBy":0,"CreatedDate":"2017-04-24T11:33:52.877Z","Email":"ngokanh610@gmail.com","GivenName":"TestShard53","Id":{3},"IsActive":true,"IsAdmin":true,"Type":0,"UserName":"admin"}},"OrderCode":"","Code":"Hóa đơn 1","Discount":{4},"DiscountRatio":{5},"InvoiceDetails":[{6}],"InvoiceOrderSurcharges":[],"InvoicePromotions":[],"Payments":[],"Status":1,"Total":2129584,"Surcharge":0,"Type":1,"Uuid":"{7}","addToAccount":"0","PayingAmount":2129584,"TotalBeforeDiscount":3513115,"ProductDiscount":747422,"DebugUuid":"","InvoiceWarranties":[],"CreatedBy":2}}}}    ${BRANCH_ID}    ${get_id_nguoitao}    ${get_id_kh}    ${get_id_nguoiban}
    ...    ${result_gghd}    ${giamgia_hd}    ${liststring_prs_invoice_detail}    ${Uuid_code}
    Log    ${request_payload}
    ${invoice_code}    Post request to create invoice and get invoice code    ${request_payload}
    Return From Keyword    ${invoice_code}

Add new invoice incase discount - return code
    [Arguments]    ${input_ma_kh}    ${dict_product_nums}    ${list_ggsp}    ${list_discount_type}    ${input_gghd}    ${input_khtt}
    ${Uuid}      Generate Random String    4    [NUMBERS][NUMBERS]
    ${Uuid_code}      Catenate      SEPARATOR=      WA     ${Uuid}
    ${list_product}    Get Dictionary Keys    ${dict_product_nums}
    ${list_nums}    Get Dictionary Values    ${dict_product_nums}
    Create list imei and other product    ${list_product}    ${list_nums}
    Sleep    50s
    #get product info
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${jsonpath_id_kh}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_kh}
    ${get_id_kh}    Get data from API    ${endpoint_khachhang}    ${jsonpath_id_kh}
    ${endpoint_danhmuc_hh_co_dvt}    Format String    ${endpoint_list_hh_in_mhbh}    ${BRANCH_ID}    ${BRANCH_ID}
    ${get_resp_danhmuc_hh}    Get Request and return body    ${endpoint_danhmuc_hh_co_dvt}
    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}    Get list jsonpath product frm list product    ${list_product}
    ${list_giaban}    ${list_result_ggsp}    ${list_id_sp}    ${list_thanhtien}    Get product info frm list jsonpath product incase discount product - return total sale    ${get_resp_danhmuc_hh}    ${list_jsonpath_id_sp}
    ...    ${list_jsonpath_giaban}    ${list_ggsp}    ${list_discount_type}    ${list_nums}
    ${result_tongtienhang}    Sum values in list    ${list_thanhtien}
    ${giamgia_hd}    Set Variable If    0 < ${input_gghd} < 100    ${input_gghd}    null
    ${result_gghd}    Run Keyword If    0 < ${input_gghd} < 100    Convert % discount to VND    ${result_tongtienhang}    ${input_gghd}
    ...    ELSE    Set Variable    ${input_gghd}
    ${result_khtt}    Minus    ${result_tongtienhang}    ${result_gghd}
    ${actual_khtt}    Set Variable If    '${input_khtt}' == 'all'    ${result_khtt}    ${input_khtt}
    #post request
    ${liststring_prs_invoice_detail}    Set Variable    needdel
    Log    ${liststring_prs_invoice_detail}
    : FOR    ${item_gia_ban}    ${item_id_sp}    ${item_soluong}    ${item_imei}    ${item_result_ggsp}    ${item_ggsp}    IN ZIP    ${list_giaban}
    ...    ${list_id_sp}    ${list_nums}    ${imei_inlist}    ${list_result_ggsp}    ${list_ggsp}
    \    ${item_imei}    Convert list to string and return    ${item_imei}
    \    ${item_ggsp}    Set Variable If    0 < ${item_ggsp} < 100    ${item_ggsp}    0
    \    ${payload_each_product}    Format string    {{"BasePrice":{0},"IsLotSerialControl":true,"IsRewardPoint":true,"Price":{0},"ProductId":{1},"Quantity":{2},"ProductCode":"Combo66","SerialNumbers":"{3}","Weight":0,"Discount":{4},"DiscountRatio":{5},"ProductName":"Điện thoại A","SalePromotionId":null,"PriceByPromotion":null,"PromotionParentProductId":null,"ProductBatchExpireId":null,"CategoryId":439203,"MasterProductId":{1},"Unit":"","Uuid":"","ProductWarranty":[]}}    ${item_gia_ban}        ${item_id_sp}    ${item_soluong}    ${item_imei}    ${item_result_ggsp}    ${item_ggsp}
    \    ${liststring_prs_invoice_detail}    Catenate    SEPARATOR=,    ${liststring_prs_invoice_detail}    ${payload_each_product}
    ${liststring_prs_invoice_detail}    Replace String    ${liststring_prs_invoice_detail}    needdel,    ${EMPTY}    count=1
    ${request_payload}    Format String    {{"Invoice":{{"BranchId":{0},"RetailerId":{1},"CustomerId":{2},"SoldById":{3},"SoldBy":{{"CreatedBy":0,"CreatedDate":"2017-04-24T11:33:52.877Z","Email":"ngokanh610@gmail.com","GivenName":"TestShard53","Id":{3},"IsActive":true,"IsAdmin":true,"Type":0,"UserName":"admin"}},"SaleChannelId":0,"Seller":{{"CreatedBy":0,"CreatedDate":"2017-04-24T11:33:52.877Z","Email":"ngokanh610@gmail.com","GivenName":"TestShard53","Id":{3},"IsActive":true,"IsAdmin":true,"Type":0,"UserName":"admin"}},"OrderCode":"","Code":"Hóa đơn 1","Discount":{4},"DiscountRatio":{5},"InvoiceDetails":[{6}],"InvoiceOrderSurcharges":[],"InvoicePromotions":[],"Payments":[{{"Method":"Cash","MethodStr":"Tiền mặt","Amount":{7},"Id":-1}}],"Status":1,"Total":2129584,"Surcharge":0,"Type":1,"Uuid":"{8}","addToAccount":"0","PayingAmount":2129584,"TotalBeforeDiscount":3513115,"ProductDiscount":747422,"DebugUuid":"","InvoiceWarranties":[],"CreatedBy":2}}}}    ${BRANCH_ID}    ${get_id_nguoitao}    ${get_id_kh}    ${get_id_nguoiban}
    ...    ${result_gghd}    ${giamgia_hd}    ${liststring_prs_invoice_detail}    ${actual_khtt}    ${Uuid_code}
    Log    ${request_payload}
    ${invoice_code}    Post request to create invoice and get invoice code    ${request_payload}
    Return From Keyword    ${invoice_code}

Add new invoice with multi product
    [Arguments]    ${input_ma_kh}    ${dict_product_nums}   ${input_gghd}    ${input_khtt}
    ${Uuid}      Generate Random String    4    [NUMBERS][NUMBERS]
    ${Uuid_code}      Catenate      SEPARATOR=      WA     ${Uuid}
    ${list_product}    Get Dictionary Keys    ${dict_product_nums}
    ${list_nums}    Get Dictionary Values    ${dict_product_nums}
    Create list imei and other product    ${list_product}    ${list_nums}
    Sleep    50s
    #get product info
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${jsonpath_id_kh}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_kh}
    ${get_id_kh}    Get data from API    ${endpoint_khachhang}    ${jsonpath_id_kh}
    ${endpoint_danhmuc_hh_co_dvt}    Format String    ${endpoint_list_hh_in_mhbh}    ${BRANCH_ID}    ${BRANCH_ID}
    ${get_resp_danhmuc_hh}    Get Request and return body    ${endpoint_danhmuc_hh_co_dvt}
    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}    Get list jsonpath product frm list product    ${list_product}
    ${list_giaban}    ${list_id_sp}    Get product info frm list jsonpath product    ${get_resp_danhmuc_hh}    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}
    ${list_result_thanhtien}    Create List
    : FOR    ${item_giaban}    ${item_nums}    IN ZIP    ${list_giaban}    ${list_nums}
    \    ${result_thanhtien}    Multiplication with price round 2    ${item_giaban}    ${item_nums}
    \    Append To List    ${list_result_thanhtien}    ${result_thanhtien}
    ${result_tongtienhang}    Sum values in list    ${list_result_thanhtien}
    ${giamgia_hd}    Set Variable If    0 < ${input_gghd} < 100    ${input_gghd}    null
    ${result_gghd}    Run Keyword If    0 < ${input_gghd} < 100    Convert % discount to VND    ${result_tongtienhang}    ${input_gghd}    ELSE    Set Variable    ${input_gghd}
    ${result_khtt}    Minus    ${result_tongtienhang}    ${result_gghd}
    ${actual_khtt}    Set Variable If    '${input_khtt}' == 'all'    ${result_khtt}    ${input_khtt}
    #post request
    ${liststring_prs_invoice_detail}    Set Variable    needdel
    Log    ${liststring_prs_invoice_detail}
    : FOR    ${item_gia_ban}    ${item_id_sp}    ${item_soluong}    ${item_imei}    IN ZIP    ${list_giaban}    ${list_id_sp}    ${list_nums}    ${imei_inlist}
    \    ${item_imei}    Convert list to string and return    ${item_imei}
    \    ${payload_each_product}    Format string    {{"BasePrice":{0},"IsLotSerialControl":true,"IsRewardPoint":true,"Price":{0},"ProductId":{1},"Quantity":{2},"ProductCode":"Combo66","SerialNumbers":"{3}","Weight":0,"Discount":0,"DiscountRatio":0,"ProductName":"Điện thoại A","SalePromotionId":null,"PriceByPromotion":null,"PromotionParentProductId":null,"ProductBatchExpireId":null,"CategoryId":439203,"MasterProductId":{1},"Unit":"","Uuid":"","ProductWarranty":[]}}    ${item_gia_ban}        ${item_id_sp}    ${item_soluong}    ${item_imei}
    \    ${liststring_prs_invoice_detail}    Catenate    SEPARATOR=,    ${liststring_prs_invoice_detail}    ${payload_each_product}
    ${liststring_prs_invoice_detail}    Replace String    ${liststring_prs_invoice_detail}    needdel,    ${EMPTY}    count=1
    ${request_payload}    Format String    {{"Invoice":{{"BranchId":{0},"RetailerId":{1},"CustomerId":{2},"SoldById":{3},"SoldBy":{{"CreatedBy":0,"CreatedDate":"2017-04-24T11:33:52.877Z","Email":"ngokanh610@gmail.com","GivenName":"TestShard53","Id":{3},"IsActive":true,"IsAdmin":true,"Type":0,"UserName":"admin"}},"SaleChannelId":0,"Seller":{{"CreatedBy":0,"CreatedDate":"2017-04-24T11:33:52.877Z","Email":"ngokanh610@gmail.com","GivenName":"TestShard53","Id":{3},"IsActive":true,"IsAdmin":true,"Type":0,"UserName":"admin"}},"OrderCode":"","Code":"Hóa đơn 1","Discount":{4},"DiscountRatio":{5},"InvoiceDetails":[{6}],"InvoiceOrderSurcharges":[],"InvoicePromotions":[],"Payments":[{{"Method":"Cash","MethodStr":"Tiền mặt","Amount":{7},"Id":-1}}],"Status":1,"Total":2129584,"Surcharge":0,"Type":1,"Uuid":"{8}","addToAccount":"0","PayingAmount":2129584,"TotalBeforeDiscount":3513115,"ProductDiscount":747422,"DebugUuid":"","InvoiceWarranties":[],"CreatedBy":2}}}}    ${BRANCH_ID}    ${get_id_nguoitao}    ${get_id_kh}    ${get_id_nguoiban}
    ...    ${result_gghd}    ${giamgia_hd}    ${liststring_prs_invoice_detail}    ${actual_khtt}    ${Uuid_code}
    Log    ${request_payload}
    ${invoice_code}    Post request to create invoice and get invoice code    ${request_payload}
    Return From Keyword    ${invoice_code}

Add new invoice with price book frm API
    [Arguments]    ${input_ma_kh}   ${input_banggia}    ${input_product}    ${input_soluong}    ${input_khtt}
    ${jsonpath_id_kh}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_kh}
    ${jsonpath_id_sp}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_product}
    ${jsonpath_gia_ban}    Format String    $..Data[?(@.Code == '{0}')].BasePrice    ${input_product}
    ${get_id_kh}    Get data from API by BranchID    ${BRANCH_ID}    ${endpoint_khachhang}    ${jsonpath_id_kh}
    ${endpoint_danhmuc_hh_co_dvt}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${get_id_sp}    Get data from API by BranchID    ${BRANCH_ID}    ${endpoint_danhmuc_hh_co_dvt}    ${jsonpath_id_sp}
    ${get_gia_ban}    Get price of product in price book thr API    ${input_banggia}    ${input_product}
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${get_pb_id}      Get price book id      ${input_banggia}
    ${Uuid}      Generate Random String    4    [NUMBERS][NUMBERS]
    ${Uuid_code}      Catenate      SEPARATOR=      WA     ${Uuid}
    ${result_thanhtien}    Multiplication and round    ${get_gia_ban}    ${input_soluong}
    ${resull_khtt_all}    Set Variable If    '${input_khtt}' == 'all'    ${result_thanhtien}    ${input_khtt}
    ${request_payload}    Format String    {{"Invoice":{{"BranchId":{0},"RetailerId":{1},"UpdateInvoiceId":0,"UpdateReturnId":0,"CustomerId":{2},"SoldById":{3},"SoldBy":{{"CreatedBy":0,"CreatedDate":"2019-04-23T10:22:08.910Z","Email":"","GivenName":"admin","Id":{3},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false}},"SaleChannelId":0,"SaleChannel":null,"Seller":{{"CreatedBy":0,"CreatedDate":"2019-04-23T10:22:08.910Z","Email":"","GivenName":"admin","Id":{3},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false}},"PriceBookId":{4},"OrderCode":"","Code":"Hóa đơn 1","InvoiceDetails":[{{"BasePrice":{5},"IsLotSerialControl":false,"IsRewardPoint":false,"Note":"","Price":{5},"ProductId":{6},"Quantity":{7},"ProductCode":"HH0040","ProductName":"Kẹo Mút Chupa Chups Hương Trái Cây","OriginPrice":{5},"ProductBatchExpireId":null,"CategoryId":173809,"MasterProductId":{6},"Unit":"","Uuid":"{8}","ProductWarranty":[]}}],"InvoiceOrderSurcharges":[],"InvoicePromotions":[],"Payments":[{{"Method":"Cash","MethodStr":"Tiền mặt","Amount":10000,"Id":-1}}],"Status":1,"Total":39900,"Surcharge":0,"Type":1,"Uuid":"{8}","addToAccount":"0","addToAccountSurplus":"0","addToAccountAllocation":"0","addToAccountPaymentAllocation":"0","PayingAmount":{9},"TotalBeforeDiscount":39900,"ProductDiscount":0,"DebugUuid":"158348468640430","InvoiceWarranties":[],"CreatedBy":{3}}}}}      ${BRANCH_ID}    ${get_id_nguoitao}      ${get_id_kh}       ${get_id_nguoiban}   ${get_pb_id}   ${get_gia_ban}    ${get_id_sp}    ${input_soluong}    ${Uuid_code}    ${resull_khtt_all}
    Log    ${request_payload}
    ${invoice_code}    Post request to create invoice and get invoice code    ${request_payload}
    Return From Keyword    ${invoice_code}

Add new exchange with price book
    [Arguments]     ${input_banggia}    ${input_ma_kh}    ${dic_product_nums_th}    ${dic_product_nums_dth}    ${list_newprice}
    ...    ${input_phi_th}    ${input_ggdth}    ${input_khtt}
    ${Uuid}      Generate Random String    4    [NUMBERS][NUMBERS]
    ${Uuid_code}      Catenate      SEPARATOR=      WA     ${Uuid}
    ${list_product_dth}    Get Dictionary Keys    ${dic_product_nums_dth}
    ${list_nums_dth}    Get Dictionary Values    ${dic_product_nums_dth}
    #get data frm Trả hàng
    ${list_product_th}    Get Dictionary Keys    ${dic_product_nums_th}
    ${list_nums_th}    Get Dictionary Values    ${dic_product_nums_th}
    ${list_result_thanhtien_th}    ${list_giavon_th}    ${list_result_toncuoi_th}    Get list total sale - endingstock - cost frm product api    ${list_product_th}    ${list_nums_th}
    ${get_list_baseprice_th}    Get list of Baseprice by Product Code    ${list_product_th}
    ${get_list_pr_th_id}    Get list product id thr API    ${list_product_th}
    #get data frm Doi hang
    ${list_result_thanhtien_dth}    ${list_giavon_dth}    ${list_result_toncuoi_dth}    Get list total sale - endingstock - cost incase newprice with additional invoice    ${list_product_dth}    ${list_nums_dth}    ${list_newprice}
    ${get_list_pr_dth_id}    Get list product id thr API    ${list_product_dth}
    ${get_list_baseprice_dth}    Get list of Baseprice by Product Code    ${list_product_dth}
    ${list_result_ggsp}    Create List
    : FOR    ${item_baseprice}    ${item_newprice}    IN ZIP    ${get_list_baseprice_dth}    ${list_newprice}
    \    ${item_ggsp}    Minus and round 2    ${item_baseprice}    ${item_newprice}
    \    Append To List    ${list_result_ggsp}    ${item_ggsp}
    Log    ${list_result_ggsp}
    #compute trả hàng
    ${result_tongtientra}    Sum values in list    ${list_result_thanhtien_th}
    ${result_phi_th}    Run Keyword If    0 < ${input_phi_th} < 100    Convert % discount to VND and round    ${result_tongtientra}    ${input_phi_th}
    ...    ELSE    Set Variable    ${input_phi_th}
    ${result_tongtientra_tru_phith}    Minus and round 2    ${result_tongtientra}    ${result_phi_th}
    #compute mua hàng
    ${result_tongtienmua}    Sum values in list    ${list_result_thanhtien_dth}
    ${result_ggdth}    Run Keyword If    0 < ${input_ggdth} < 100    Convert % discount to VND and round    ${result_tongtienmua}    ${input_ggdth}
    ...    ELSE    Set Variable    ${input_ggdth}
    ${result_tongtienmua_tru_gg}    Minus    ${result_tongtienmua}    ${result_ggdth}
    ${result_khachthanhtoan}    Minus and round 2    ${result_tongtienmua_tru_gg}    ${result_tongtientra_tru_phith}
    ${result_cantrakhach}    Minus and round 2    ${result_tongtientra_tru_phith}    ${result_tongtienmua_tru_gg}
    ${result_kh_canthanhtoan}    Set Variable If    ${result_tongtienmua_tru_gg}<${result_tongtientra_tru_phith}    ${result_cantrakhach}    ${result_khachthanhtoan}
    ${result_khtt}    Set Variable If    "${input_khtt}" == "all"    ${result_kh_canthanhtoan}    ${input_khtt}
    ${actual_khtt}    Set Variable If    "${input_khtt}" == "0"    0    ${result_khtt}
    ${actuall_trahang}    Set Variable If    ${result_tongtienmua_tru_gg}<${result_tongtientra_tru_phith}    ${actual_khtt}    0
    # Post request BH
    #return
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${get_id_kh}    Get customer id thr API    ${input_ma_kh}
    ${get_pb_id}      Get price book id       ${input_banggia}
    ${liststring_prs_return_detail}    Set Variable    needdel
    : FOR    ${item_product_id}    ${item_price}    ${item_num}    IN ZIP    ${get_list_pr_th_id}    ${get_list_baseprice_th}
    ...    ${list_nums_th}
    \    ${payload_each_product}    Format string    {{"BasePrice":{0},"IsLotSerialControl":false,"Note":"","Price":{0},"ProductId":{1},"Quantity":{2},"SellPrice":{0},"ProductName":"Son Lì Maybelline Intimatte Nude (3.9g)","CopiedPrice":{0},"ProductBatchExpireId":null}}    ${item_price}    ${item_product_id}    ${item_num}
    \    ${liststring_prs_return_detail}    Catenate    SEPARATOR=,    ${liststring_prs_return_detail}    ${payload_each_product}
    Log    ${liststring_prs_return_detail}
    ${liststring_prs_return_detail}    Replace String    ${liststring_prs_return_detail}    needdel,    ${EMPTY}    count=1
    #invoice
    ${liststring_prs_invoice_detail}    Set Variable    needdel
    ${liststring_prs_invoice_detail1}    Set Variable    needdel
    : FOR    ${item_product_id}    ${item_price}    ${item_num}    ${item_result_discountproduct}    ${item_newprice}
    ...    ${item_pr}    IN ZIP    ${get_list_pr_dth_id}    ${get_list_baseprice_dth}    ${list_nums_dth}    ${list_result_ggsp}
    ...    ${list_newprice}      ${list_product_dth}
    \    ${payload_each_product}    Format string    {{"ProductId":{0},"ProductName":"chuột quang hồng","ProductFullName":"chuột quang hồng","ProductNameNoUnit":"chuột quang hồng","ProductAttributeLabel":"","ProductSName":"chuột quang hồng","ProductCode":"{1}","ProductType":2,"ProductCategoryId":1147670,"MasterProductId":22601297,"OnHand":84,"OnOrder":0,"Reserved":0,"Price":{2},"Unit":"","Note":"","PromotionReceiverQty":1,"Quantity":{3},"ProductSerials":[],"Serials":[],"IsLotSerialControl":true,"IsRewardPoint":false,"CurrentQuery":"sim","CategoryId":1147670,"Promotions":[],"Discount":{4},"DiscountRatio":null,"BasePrice":{3},"DuplicationCartItems":[],"isDeleted":false,"ProductShelves":[],"AllowSale":true,"ProductWarranty":[],"Formulas":null,"Uuid":"W156698364593830","CartType":3,"Units":[],"MaxQuantity":null,"SerialNumbers":"{5}","discountPriceWoRound":{6},"discountRatioPriceWoRound":null}}    ${item_product_id}    ${item_pr}    ${item_price}
    \    ...    ${item_num}    ${item_result_discountproduct}    ${EMPTY}    ${item_newprice}
    \    ${payload_each_product_1}    Format string    {{"BasePrice":{0},"IsLotSerialControl":true,"IsRewardPoint":false,"Note":"","Price":{0},"ProductId":{1},"Quantity":{2},"SerialNumbers":"{3}","Discount":{4},"DiscountRatio":null,"ProductName":"chuột quang hồng","ProductCode":"{5}","ProductBatchExpireId":null,"Uuid":"W156698364593830"}}    ${item_price}    ${item_product_id}    ${item_num}
    \    ...    ${EMPTY}    ${item_result_discountproduct}    ${item_pr}
    \    ${liststring_prs_invoice_detail}    Catenate    SEPARATOR=,    ${liststring_prs_invoice_detail}    ${payload_each_product}
    \    ${liststring_prs_invoice_detail1}    Catenate    SEPARATOR=,    ${liststring_prs_invoice_detail1}    ${payload_each_product_1}
    Log    ${liststring_prs_invoice_detail}
    Log    ${liststring_prs_invoice_detail1}
    ${liststring_prs_invoice_detail}    Replace String    ${liststring_prs_invoice_detail}    needdel,    ${EMPTY}    count=1
    ${liststring_prs_invoice_detail1}    Replace String    ${liststring_prs_invoice_detail1}    needdel,    ${EMPTY}    count=1
    ${request_payload}    Format String    {{"Return":{{"BranchId":{0},"RetailerId":{1},"CustomerId":{2},"ReceivedById":{3},"ReceivedBy":{{"CreatedBy":0,"CreatedDate":"2018-12-10T08:33:32.447Z","Email":"","GivenName":"admin","Id":{3},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false}},"SaleChannelId":0,"SaleChannel":null,"Code":"Trả hàng 1","ReturnDiscount":0,"ReturnFee":{4},"ReturnFeeRatio":{5},"ReturnDetails":[{6}],"InvoiceDetails":[{7}],"InvoiceOrderSurcharges":[],"Status":1,"Surcharge":0,"Type":3,"Uuid":"W15670471588182","PayingAmount":{8},"SumTotal":{9},"TotalBeforeDiscount":1050000,"ProductDiscount":210000,"PriceBookId":{14},"TotalInvoice":{10},"TotalReturn":260000,"txtPay":"Tiền khách trả","addToAccount":"0","addToAccountSurplus":"0","addToAccountAllocation":"0","addToAccountPaymentAllocation":"0","ReturnSurcharges":[],"CreatedBy":{3}}},"Invoice":{{"BranchId":{0},"RetailerId":{1},"UpdateInvoiceId":0,"UpdateReturnId":0,"CustomerId":{2},"SoldById":{3},"SoldBy":{{"CreatedBy":0,"CreatedDate":"2018-12-10T08:33:32.447Z","Email":"","GivenName":"admin","Id":441968,"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false}},"SaleChannelId":0,"SaleChannel":null,"Seller":{{"CreatedBy":0,"CreatedDate":"2018-12-10T08:33:32.447Z","Email":"","GivenName":"admin","Id":441968,"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false}},"PriceBookId":{14},"OrderCode":"","Discount":{11},"DiscountRatio":{12},"InvoiceDetails":[{13}],"InvoiceOrderSurcharges":[],"Payments":[{{"Method":"Cash","MethodStr":"Tiền mặt","Amount":{8},"Id":-1}}],"Status":1,"Total":{10},"Surcharge":0,"Type":1,"Uuid":"{15}","addToAccount":"0","addToAccountSurplus":"0","addToAccountAllocation":"0","addToAccountPaymentAllocation":"0","PayingAmount":{8},"TotalBeforeDiscount":1050000,"ProductDiscount":210000,"DebugUuid":"156704715869740","InvoiceWarranties":[],"CreatedBy":441968}}}}    ${BRANCH_ID}    ${get_id_nguoitao}    ${get_id_kh}    ${get_id_nguoiban}
    ...    ${result_phi_th}    ${input_phi_th}    ${liststring_prs_return_detail}    ${liststring_prs_invoice_detail}    ${actual_khtt}    ${result_kh_canthanhtoan}
    ...    ${result_tongtienmua_tru_gg}    ${result_ggdth}    ${input_ggdth}    ${liststring_prs_invoice_detail1}     ${get_pb_id}    ${Uuid_code}
    Log    ${request_payload}
    ${return_code}    Post request to create exchange and get return code    ${request_payload}
    Return From Keyword       ${return_code}

Add new return without customer and imei frm API
    [Arguments]    ${dict_product_nums}    ${input_khtt}
    ${list_products}    Get Dictionary Keys    ${dict_product_nums}
    ${list_nums}    Get Dictionary Values    ${dict_product_nums}
    #get data to validate
    ${Uuid}      Generate Random String    4    [NUMBERS][NUMBERS]
    ${Uuid_code}      Catenate      SEPARATOR=      WA     ${Uuid}
    ${list_productid}    Get list product id thr API    ${list_products}
    ${list_giaban}    Get list of Baseprice by Product Code    ${list_products}
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    # Post request BH
    ${liststring_prs_invoice_detail}    Set Variable    needdel
    Log    ${liststring_prs_invoice_detail}
    : FOR    ${item_product_id}    ${item_price}    ${item_num}    IN ZIP    ${list_productid}    ${list_giaban}    ${list_nums}
    \    ${payload_each_product}    Format string    {{"BasePrice":{0},"IsLotSerialControl":false,"Note":"","Price":{0},"ProductId":{1},"Quantity":{2},"SellPrice":{0},"ProductName":"Nước Hoa Jo Malone Sakura Cherry Blossom Limited Edition Cologne vial","CopiedPrice":{0},"ProductBatchExpireId":null}}    ${item_price}    ${item_product_id}
    \    ...    ${item_num}
    \    ${liststring_prs_invoice_detail}    Catenate    SEPARATOR=,    ${liststring_prs_invoice_detail}    ${payload_each_product}
    Log    ${liststring_prs_invoice_detail}
    ${liststring_prs_invoice_detail}    Replace String    ${liststring_prs_invoice_detail}    needdel,    ${EMPTY}    count=1
    ${request_payload}    Format String    {{"Return":{{"BranchId":{0},"RetailerId":{1},"ReceivedById":{2},"ReceivedBy":{{"CreatedBy":0,"CreatedDate":"2018-12-10T08:33:32.447Z","Email":"","GivenName":"anh.lv","Id":{2},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","MobilePhone":"","Type":0,"UserName":"admin","isDeleted":false}},"SaleChannelId":0,"SaleChannel":null,"Code":"Trả hàng 1","ReturnDiscount":0,"ReturnFee":0,"ReturnDetails":[{3}],"InvoiceDetails":[],"InvoiceOrderSurcharges":[],"Payments":[{{"Method":"Cash","MethodStr":"Tiền mặt","Amount":{4},"Id":-1}}],"Status":1,"Surcharge":0,"Type":3,"Uuid":"{5}","PayingAmount":{4},"TotalBeforeDiscount":0,"ProductDiscount":0,"TotalReturn":150000,"txtPay":"Tiền trả khách","addToAccount":"0","ReturnSurcharges":[],"CreatedBy":441968}}}}    ${BRANCH_ID}    ${get_id_nguoitao}    ${get_id_nguoiban}    ${liststring_prs_invoice_detail}    ${input_khtt}    ${Uuid_code}
    Log    ${request_payload}
    ${return_code}    Post request to create return and get resp    ${request_payload}
    Return From Keyword    ${return_code}

Add new invoice without customer have warranty thr API
    [Arguments]    ${dic_product_num}    ${input_khtt}
    ${Uuid}      Generate Random String    4    [NUMBERS][NUMBERS]
    ${Uuid1}      Generate Random String    4    [NUMBERS][NUMBERS]
    ${Uuid_code}      Catenate      SEPARATOR=      WA     ${Uuid}
    ${Uuid_code1}      Set Variable         WA${Uuid1}w
    ${input_ma_hang}    Get Dictionary Keys    ${dic_product_num}
    ${input_soluong}    Get Dictionary Values    ${dic_product_num}
    ${input_ma_hang}    Convert list to string and return    ${input_ma_hang}
    ${input_soluong}    Convert list to string and return    ${input_soluong}
    ${jsonpath_id_sp}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_hang}
    ${jsonpath_gia_ban}    Format String    $..Data[?(@.Code == '{0}')].BasePrice    ${input_ma_hang}
    ${endpoint_danhmuc_hh_co_dvt}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${get_resp}   Get Request and return body    ${endpoint_danhmuc_hh_co_dvt}
    ${get_id_sp}    Get data from response json     ${get_resp}    ${jsonpath_id_sp}
    ${get_gia_ban}   Get data from response json   ${get_resp}    ${jsonpath_gia_ban}
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${result_thanhtien}    Multiplication and round    ${get_gia_ban}    ${input_soluong}
    ${resull_khtt_all}    Set Variable If    '${input_khtt}' == 'all'    ${result_thanhtien}    ${input_khtt}
    ${get_currente_date}      Get Current Date
    ${expire_date}      Add Time To Date    ${get_currente_date}    31 days       result_format=%Y-%m-%d
    ${request_payload}    Format String    {{"Invoice":{{"BranchId":{0},"RetailerId":{1},"UpdateInvoiceId":0,"UpdateReturnId":0,"SoldById":{2},"SoldBy":{{"CreatedBy":0,"CreatedDate":"","Email":"","GivenName":"admin","Id":{2},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false}},"SaleChannelId":0,"Seller":{{"CreatedBy":0,"CreatedDate":"","Email":"","GivenName":"admin","Id":{2},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false}},"OrderCode":"","Code":"Hóa đơn 1","InvoiceDetails":[{{"BasePrice":{3},"IsLotSerialControl":false,"IsRewardPoint":true,"Note":"","Price":{3},"ProductId":{4},"Quantity":{5},"ProductCode":"HHBH","ProductName":"abc","OriginPrice":30000,"PriceByPromotion":null,"PromotionParentProductId":null,"ProductBatchExpireId":null,"CategoryId":531934,"MasterProductId":{4},"Unit":"","Uuid":"{9}","UseWarranty":true,"ProductWarranty":[{{"Description":"Toàn bộ sản phẩm","NumberTime":1,"TimeType":2,"WarrantyType":1,"ProductId":{4},"RetailerId":{1},"CreatedBy":{2},"CreatedDate":"","ExpireDate":"{8}","Status":3,"InvoiceDetailUuid":"{9}","Uuid":"{7}","IsDisabled":false}}],"Formulas":null}}],"InvoiceOrderSurcharges":[],"InvoicePromotions":[],"Payments":[{{"Method":"Cash","MethodStr":"Tiền mặt","Amount":{6},"Id":-1}}],"Status":1,"Total":60000,"Surcharge":0,"Type":1,"Uuid":"","addToAccount":"0","PayingAmount":{6},"TotalBeforeDiscount":60000,"ProductDiscount":0,"DebugUuid":"","InvoiceWarranties":[{{"Description":"Toàn bộ sản phẩm","NumberTime":1,"TimeType":2,"WarrantyType":1,"ProductId":{4},"RetailerId":{1},"CreatedBy":{2},"CreatedDate":"","ExpireDate":"{8}","Status":3,"InvoiceDetailUuid":"{9}","Uuid":"{7}","IsDisabled":false,"$$hashKey":"object:783"}}],"CreatedBy":{2}}}}}   ${BRANCH_ID}    ${get_id_nguoitao}    ${get_id_nguoiban}
    ...    ${get_gia_ban}    ${get_id_sp}    ${input_soluong}    ${resull_khtt_all}    ${Uuid_code}     ${expire_date}      ${Uuid_code1}
    Log    ${request_payload}
    ${invoice_code}    Post request to create invoice and get invoice code    ${request_payload}
    Return From Keyword    ${invoice_code}

Add new delivery invoice - no payment
    [Arguments]    ${input_ma_kh}     ${input_ma_dtgh}     ${dict_product_nums}    ${list_change}    ${list_change_type}    ${input_gghd}
    ${Uuid}      Generate Random String    4    [NUMBERS][NUMBERS]
    ${Uuid_code}      Catenate      SEPARATOR=      WA     ${Uuid}
    ${list_product}    Get Dictionary Keys    ${dict_product_nums}
    ${list_nums}    Get Dictionary Values    ${dict_product_nums}
    Create list imei and other product    ${list_product}    ${list_nums}
    Sleep    5s
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${get_id_kh}    Get customer id thr API    ${input_ma_kh}
    ${get_id_dtgh}    Get deliverypartner id frm api    ${input_ma_dtgh}
    ${list_id_sp}    Get list product id thr API    ${list_product}
    ${list_giaban}    ${list_result_ggsp}    Computation list price and result discount incase changing price by product code    ${list_product}    ${list_change}    ${list_change_type}
    ${list_thanhtien_hh}    Create List
    : FOR    ${giaban}    ${soluong}    IN ZIP    ${list_giaban}    ${list_nums}
    \    ${result_item_thanhtien}    Multiplication and round    ${giaban}    ${soluong}
    \    Append To List    ${list_thanhtien_hh}    ${result_item_thanhtien}
    Log    ${list_thanhtien_hh}
    ${result_tongtienhang}    Sum values in list    ${list_thanhtien_hh}
    ${giamgia_hd}    Set Variable If    0 < ${input_gghd} < 100    ${input_gghd}    null
    ${result_gghd}    Run Keyword If    0 < ${input_gghd} < 100    Convert % discount to VND    ${result_tongtienhang}    ${input_gghd}
    ...    ELSE    Set Variable    ${input_gghd}
    ${get_list_baseprice}    Get list of Baseprice by Product Code    ${list_product}
    ${result_tongtienhang}    Evaluate    round(${result_tongtienhang},0)
    ${result_gghd}    Evaluate    round(${result_gghd},0)
    ${result_khachcantra}    Minus    ${result_tongtienhang}    ${result_gghd}
    #post request
    ${liststring_prs_invoice_detail}    Set Variable    needdel
    Log    ${liststring_prs_invoice_detail}
    : FOR    ${item_gia_ban}    ${item_id_sp}    ${item_soluong}    ${item_imei}    ${item_result_ggsp}    ${item_change}
    ...    ${item_change_type}    ${item_pr}    IN ZIP    ${get_list_baseprice}    ${list_id_sp}    ${list_nums}
    ...    ${imei_inlist}    ${list_result_ggsp}    ${list_change}    ${list_change_type}    ${list_product}
    \    ${item_imei}    Convert list to string and return    ${item_imei}
    \    ${item_ggsp}    Set Variable If    0 < ${item_change} < 100 and '${item_change_type}'=='dis'    ${item_change}    null
    \    ${payload_each_product}    Format string    {{"BasePrice":{0},"IsLotSerialControl":true,"IsRewardPoint":true,"Price":{0},"ProductId":{1},"Quantity":{2},"ProductCode":"{6}","SerialNumbers":"{3}","Weight":0,"Discount":{4},"DiscountRatio":{5},"ProductName":"Điện thoại A","SalePromotionId":null,"PriceByPromotion":null,"PromotionParentProductId":null,"ProductBatchExpireId":null,"CategoryId":439203,"MasterProductId":{1},"Unit":"","Uuid":"","ProductWarranty":[]}}    ${item_gia_ban}    ${item_id_sp}    ${item_soluong}
    \    ...    ${item_imei}    ${item_result_ggsp}    ${item_ggsp}    ${item_pr}
    \    ${liststring_prs_invoice_detail}    Catenate    SEPARATOR=,    ${liststring_prs_invoice_detail}    ${payload_each_product}
    ${liststring_prs_invoice_detail}    Replace String    ${liststring_prs_invoice_detail}    needdel,    ${EMPTY}    count=1
    ${request_payload}    Format String    {{"Invoice":{{"BranchId":{0},"RetailerId":{1},"UpdateInvoiceId":0,"UpdateReturnId":0,"IsChangeNormalToShippingDelivery":false,"CustomerId":{2},"SoldById":{3},"SoldBy":{{"CreatedBy":0,"CreatedDate":"","Email":"","GivenName":"admin","Id":{3},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false}},"SaleChannelId":0,"Seller":{{"CreatedBy":0,"CreatedDate":"","Email":"","GivenName":"admin","Id":{3},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false}},"OrderCode":"","Code":"Hóa đơn 1","Discount":{4},"DiscountRatio":{5},"InvoiceDetails":[{10}],"InvoiceOrderSurcharges":[],"InvoicePromotions":[],"DeliveryDetail":{{"Type":0,"TypeName":"","Status":1,"Receiver":"abc","DeliveryBy":{6},"LocationName":"","WardName":"","CustomerId":{2},"CustomerCode":"CTKH082","BranchTakingAddressId":null,"BranchTakingAddressStr":"Hà Nội, Phường Điện Biên, Quận Ba Đình, Hà Nội - 0987545635","UsingPriceCod":1,"LastLocation":"","LastWard":"","Width":1,"Height":1,"Length":1,"Weight":500,"UsingOfBilling":false,"Paymenter":0,"PackageType":0,"UseDefaultPartner":false,"ServiceCode":"0","TotalProductPrice":{7},"ServiceAdd":null,"Price":null,"DeliveryCode":null,"DeliveryStatus":null,"ExpectedDelivery":null,"PartnerCode":"DT00008","PartnerDelivery":{{"Type":0,"Code":"DT00008","ContactNumber":"01689346789","CreatedDate":"","Id":{6},"LocationName":"","Name":"Bùi Thị Hồng","PartnerDeliveryGroupDetails":[],"RetailerId":{1},"SearchNumber":"01689346789","WardName":"","isActive":true,"isDeleted":false}},"WeightEdited":true,"PartnerName":"","ExpectedDeliveryText":""}},"UsingCod":1,"Payments":[],"Status":3,"Total":{8},"Surcharge":0,"Type":1,"Uuid":"{9}","addToAccount":"0","addToAccountSurplus":"0","addToAccountAllocation":"0","addToAccountPaymentAllocation":"0","PayingAmount":0,"TotalBeforeDiscount":{7},"ProductDiscount":0,"DebugUuid":"","InvoiceWarranties":[],"CreatedBy":{3}}}}}    ${BRANCH_ID}    ${get_id_nguoitao}     ${get_id_kh}    ${get_id_nguoiban}    ${result_gghd}
    ...    ${giamgia_hd}    ${get_id_dtgh}    ${result_tongtienhang}     ${result_khachcantra}     ${Uuid_code}     ${liststring_prs_invoice_detail}
    Log    ${request_payload}
    ${invoice_code}    Post request to create invoice and get invoice code    ${request_payload}
    Return From Keyword    ${invoice_code}

Add new delivery invoice - payment
    [Arguments]    ${input_ma_kh}     ${input_ma_dtgh}     ${dict_product_nums}    ${list_change}    ${list_change_type}    ${input_gghd}     ${input_khtt}
    ${Uuid}      Generate Random String    4    [NUMBERS][NUMBERS]
    ${Uuid_code}      Catenate      SEPARATOR=      WA     ${Uuid}
    ${list_product}    Get Dictionary Keys    ${dict_product_nums}
    ${list_nums}    Get Dictionary Values    ${dict_product_nums}
    Create list imei and other product    ${list_product}    ${list_nums}
    Sleep    5s
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${get_id_kh}    Get customer id thr API    ${input_ma_kh}
    ${get_id_dtgh}    Get deliverypartner id frm api    ${input_ma_dtgh}
    ${list_id_sp}    Get list product id thr API    ${list_product}
    ${list_giaban}    ${list_result_ggsp}    Computation list price and result discount incase changing price by product code    ${list_product}    ${list_change}    ${list_change_type}
    ${list_thanhtien_hh}    Create List
    : FOR    ${giaban}    ${soluong}    IN ZIP    ${list_giaban}    ${list_nums}
    \    ${result_item_thanhtien}    Multiplication and round    ${giaban}    ${soluong}
    \    Append To List    ${list_thanhtien_hh}    ${result_item_thanhtien}
    Log    ${list_thanhtien_hh}
    ${result_tongtienhang}    Sum values in list    ${list_thanhtien_hh}
    ${giamgia_hd}    Set Variable If    0 < ${input_gghd} < 100    ${input_gghd}    null
    ${result_gghd}    Run Keyword If    0 < ${input_gghd} < 100    Convert % discount to VND    ${result_tongtienhang}    ${input_gghd}
    ...    ELSE    Set Variable    ${input_gghd}
    ${get_list_baseprice}    Get list of Baseprice by Product Code    ${list_product}
    ${result_tongtienhang}    Evaluate    round(${result_tongtienhang},0)
    ${result_gghd}    Evaluate    round(${result_gghd},0)
    ${result_khachcantra}    Minus    ${result_tongtienhang}    ${result_gghd}
    ${result_khtt}      Set Variable If    '${input_khtt}'=='all'    ${result_khachcantra}      ${input_khtt}
    #post request
    ${liststring_prs_invoice_detail}    Set Variable    needdel
    Log    ${liststring_prs_invoice_detail}
    : FOR    ${item_gia_ban}    ${item_id_sp}    ${item_soluong}    ${item_imei}    ${item_result_ggsp}    ${item_change}
    ...    ${item_change_type}    ${item_pr}    IN ZIP    ${get_list_baseprice}    ${list_id_sp}    ${list_nums}
    ...    ${imei_inlist}    ${list_result_ggsp}    ${list_change}    ${list_change_type}    ${list_product}
    \    ${item_imei}    Convert list to string and return    ${item_imei}
    \    ${item_ggsp}    Set Variable If    0 < ${item_change} < 100 and '${item_change_type}'=='dis'    ${item_change}    null
    \    ${payload_each_product}    Format string    {{"BasePrice":{0},"IsLotSerialControl":true,"IsRewardPoint":true,"Price":{0},"ProductId":{1},"Quantity":{2},"ProductCode":"{6}","SerialNumbers":"{3}","Weight":0,"Discount":{4},"DiscountRatio":{5},"ProductName":"Điện thoại A","SalePromotionId":null,"PriceByPromotion":null,"PromotionParentProductId":null,"ProductBatchExpireId":null,"CategoryId":439203,"MasterProductId":{1},"Unit":"","Uuid":"","ProductWarranty":[]}}    ${item_gia_ban}    ${item_id_sp}    ${item_soluong}
    \    ...    ${item_imei}    ${item_result_ggsp}    ${item_ggsp}    ${item_pr}
    \    ${liststring_prs_invoice_detail}    Catenate    SEPARATOR=,    ${liststring_prs_invoice_detail}    ${payload_each_product}
    ${liststring_prs_invoice_detail}    Replace String    ${liststring_prs_invoice_detail}    needdel,    ${EMPTY}    count=1
    ${request_payload}    Format String    {{"Invoice":{{"BranchId":{0},"RetailerId":{1},"UpdateInvoiceId":0,"UpdateReturnId":0,"IsChangeNormalToShippingDelivery":false,"CustomerId":{2},"SoldById":{3},"SoldBy":{{"CreatedBy":0,"CreatedDate":"","Email":"","GivenName":"admin","Id":{3},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false}},"SaleChannelId":0,"Seller":{{"CreatedBy":0,"CreatedDate":"","Email":"","GivenName":"admin","Id":{3},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false}},"OrderCode":"","Code":"Hóa đơn 1","Discount":{4},"DiscountRatio":{5},"InvoiceDetails":[{10}],"InvoiceOrderSurcharges":[],"InvoicePromotions":[],"DeliveryDetail":{{"Type":0,"TypeName":"","Status":1,"Receiver":"abc","DeliveryBy":{6},"LocationName":"","WardName":"","CustomerId":{2},"CustomerCode":"CTKH082","BranchTakingAddressId":null,"BranchTakingAddressStr":"Hà Nội, Phường Điện Biên, Quận Ba Đình, Hà Nội - 0987545635","UsingPriceCod":1,"LastLocation":"","LastWard":"","Width":1,"Height":1,"Length":1,"Weight":500,"UsingOfBilling":false,"Paymenter":0,"PackageType":0,"UseDefaultPartner":false,"ServiceCode":"0","TotalProductPrice":{7},"ServiceAdd":null,"Price":null,"DeliveryCode":null,"DeliveryStatus":null,"ExpectedDelivery":null,"PartnerCode":"DT00008","PartnerDelivery":{{"Type":0,"Code":"DT00008","ContactNumber":"01689346789","CreatedDate":"","Id":{6},"LocationName":"","Name":"Bùi Thị Hồng","PartnerDeliveryGroupDetails":[],"RetailerId":{1},"SearchNumber":"01689346789","WardName":"","isActive":true,"isDeleted":false}},"WeightEdited":true,"PartnerName":"","ExpectedDeliveryText":""}},"UsingCod":1,"Payments":[{{"Method":"Cash","MethodStr":"Tiền mặt","Amount":{11},"Id":-1}}],"Status":3,"Total":{8},"Surcharge":0,"Type":1,"Uuid":"{9}","addToAccount":"0","addToAccountSurplus":"0","addToAccountAllocation":"0","addToAccountPaymentAllocation":"{11}","PayingAmount":0,"TotalBeforeDiscount":{7},"ProductDiscount":0,"DebugUuid":"","InvoiceWarranties":[],"CreatedBy":{3}}}}}    ${BRANCH_ID}    ${get_id_nguoitao}     ${get_id_kh}    ${get_id_nguoiban}    ${result_gghd}
    ...    ${giamgia_hd}    ${get_id_dtgh}    ${result_tongtienhang}     ${result_khachcantra}     ${Uuid_code}     ${liststring_prs_invoice_detail}      ${result_khtt}
    ${invoice_code}    Post request to create invoice and get invoice code    ${request_payload}
    Return From Keyword    ${invoice_code}

Add new invoice incase delivery and promotion invoice discount - no payment
    [Arguments]    ${input_ma_kh}     ${input_ma_dtgh}     ${dict_product_nums}    ${list_change}    ${list_change_type}     ${input_khuyemmai}
    [Timeout]    5 mins
    ${Uuid}      Generate Random String    4    [NUMBERS][NUMBERS]
    ${Uuid_code}      Catenate      SEPARATOR=      WA     ${Uuid}
    Toggle status of promotion    ${input_khuyemmai}    1
    ${invoice_value}    ${discount}    ${discount_ratio}    ${name}    ${promotion_sale_id}    ${promotion_id}    Get Invoice value - Discounts - Promotion Name - Promotion Sale - Id from Promotion Code
    ...    ${input_khuyemmai}
    ${list_products}    Get Dictionary Keys    ${dict_product_nums}
    ${list_nums}    Get Dictionary Values    ${dict_product_nums}
    Create list imei and other product    ${list_products}    ${list_nums}
    Sleep    5s
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${get_id_kh}    Get customer id thr API    ${input_ma_kh}
    ${get_id_dtgh}    Get deliverypartner id frm api    ${input_ma_dtgh}
    ${list_id_sp}    Get list product id thr API    ${list_products}
    ${list_giaban}    ${list_result_ggsp}    Computation list price and result discount incase changing price by product code    ${list_products}    ${list_change}    ${list_change_type}
    ${list_thanhtien_hh}    Create List
    : FOR    ${giaban}    ${soluong}    IN ZIP    ${list_giaban}    ${list_nums}
    \    ${result_item_thanhtien}    Multiplication and round    ${giaban}    ${soluong}
    \    Append To List    ${list_thanhtien_hh}    ${result_item_thanhtien}
    Log    ${list_thanhtien_hh}
    ${result_tongtienhang}    Sum values in list    ${list_thanhtien_hh}
    ${actual_promo_discount_value}=    Run Keyword If    ${discount_ratio} != 0    Convert % discount to VND and round    ${result_tongtienhang}    ${discount_ratio}
    ...    ELSE    Set Variable    ${discount}
    ${final_discount}=    Run Keyword If    ${result_tongtienhang} > ${invoice_value}    Set Variable    ${actual_promo_discount_value}
    ...    ELSE    Set Variable    0
    ${get_list_baseprice}    Get list of Baseprice by Product Code    ${list_products}
    ${result_tongtienhang}    Evaluate    round(${result_tongtienhang},0)
    ${result_khachcantra}    Minus    ${result_tongtienhang}    ${final_discount}
    #thong tin km
    ${text_total_invoice}    Convert from number to vnd discount text    ${invoice_value}    000000.0    ,000,000
    ${actual_text_discount}    Run Keyword If    ${discount_ratio} != 0    Convert from number to ratio discount text    ${discount_ratio}
    ...    ELSE    Convert from number to vnd discount text    ${discount}    000.0    ,000
    ${text_promo_info}    Format String    {0}: Tổng tiền hàng từ {1} giảm giá {2} cho hóa đơn   ${name}    ${text_total_invoice}   ${actual_text_discount}
    Log    ${text_promo_info}
    #post request
    ${liststring_prs_invoice_detail}    Set Variable    needdel
    Log    ${liststring_prs_invoice_detail}
    : FOR    ${item_gia_ban}    ${item_id_sp}    ${item_soluong}    ${item_imei}    ${item_result_ggsp}    ${item_change}
    ...    ${item_change_type}    ${item_pr}    IN ZIP    ${get_list_baseprice}    ${list_id_sp}    ${list_nums}
    ...    ${imei_inlist}    ${list_result_ggsp}    ${list_change}    ${list_change_type}    ${list_products}
    \    ${item_imei}    Convert list to string and return    ${item_imei}
    \    ${item_ggsp}    Set Variable If    0 < ${item_change} < 100 and '${item_change_type}'=='dis'    ${item_change}    null
    \    ${payload_each_product}    Format string    {{"BasePrice":{0},"IsLotSerialControl":true,"IsRewardPoint":true,"Price":{0},"ProductId":{1},"Quantity":{2},"ProductCode":"{6}","SerialNumbers":"{3}","Weight":0,"Discount":{4},"DiscountRatio":{5},"ProductName":"Điện thoại A","SalePromotionId":null,"PriceByPromotion":null,"PromotionParentProductId":null,"ProductBatchExpireId":null,"CategoryId":439203,"MasterProductId":{1},"Unit":"","Uuid":"","ProductWarranty":[]}}    ${item_gia_ban}    ${item_id_sp}    ${item_soluong}
    \    ...    ${item_imei}    ${item_result_ggsp}    ${item_ggsp}    ${item_pr}
    \    ${liststring_prs_invoice_detail}    Catenate    SEPARATOR=,    ${liststring_prs_invoice_detail}    ${payload_each_product}
    ${liststring_prs_invoice_detail}    Replace String    ${liststring_prs_invoice_detail}    needdel,    ${EMPTY}    count=1
    ${request_payload}    Format String    {{"Invoice":{{"BranchId":{0},"RetailerId":{1},"UpdateInvoiceId":0,"UpdateReturnId":0,"IsChangeNormalToShippingDelivery":false,"CustomerId":{2},"SoldById":{3},"SoldBy":{{"CreatedBy":0,"CreatedDate":"","Email":"","GivenName":"admin","Id":{3},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false}},"SaleChannelId":0,"Seller":{{"CreatedBy":0,"CreatedDate":"","Email":"","GivenName":"admin","Id":{3},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false}},"OrderCode":"","Code":"Hóa đơn 1","Discount":{4},"InvoiceDetails":[{5}],"InvoiceOrderSurcharges":[],"InvoicePromotions":[{{"Type":1,"TargetType":0,"SalePromotionId":{6},"PromotionId":{7},"Discount":{4},"PromotionInfo":"{8}","PrintPromotionInfo":"{8}"}}],"DeliveryDetail":{{"Type":0,"TypeName":"","Status":1,"Address":"số 11 ngõ 123 Trần Đại nghĩa","ContactNumber":"0912754690","Receiver":"Nguyễn Thị Mai Anh","DeliveryBy":{9},"LocationId":244,"LocationName":"Hà Nội - Quận Hoàng Mai","WardName":"Phường Hoàng Liệt","CustomerId":{2},"CustomerCode":"CTKH001","BranchTakingAddressId":null,"BranchTakingAddressStr":"Hà Nội, Phường Điện Biên, Quận Ba Đình, Hà Nội - 0987545635","WardId":116,"UsingPriceCod":1,"LastLocation":"Hà Nội - Quận Hoàng Mai","LastWard":"Phường Hoàng Liệt","Width":1,"Height":1,"Length":1,"Weight":500,"UsingOfBilling":false,"Paymenter":0,"PackageType":0,"UseDefaultPartner":false,"ServiceCode":"0","TotalProductPrice":{10},"ServiceAdd":null,"Price":null,"DeliveryCode":null,"DeliveryStatus":null,"ExpectedDelivery":null,"PartnerCode":"DT00006","PartnerDelivery":{{"Type":0,"Code":"DT00006","ContactNumber":"01689346787","CreatedDate":"","Id":{9},"LocationName":"","Name":"Nguyễn Văn Nam","PartnerDeliveryGroupDetails":[],"RetailerId":{1},"SearchNumber":"01689346787","WardName":"","isActive":true,"isDeleted":false}},"WeightEdited":true,"PartnerName":"","ExpectedDeliveryText":""}},"UsingCod":1,"Payments":[],"Status":3,"Total":{11},"Surcharge":0,"Type":1,"Uuid":"{12}","addToAccount":"0","addToAccountSurplus":"0","addToAccountAllocation":"0","addToAccountPaymentAllocation":"0","PayingAmount":0,"TotalBeforeDiscount":{10},"ProductDiscount":0,"DebugUuid":"","InvoiceWarranties":[],"DiscountByPromotion":{4},"DiscountByPromotionValue":{4},"DiscountByPromotionRatio":0,"CreatedBy":{3}}}}}    ${BRANCH_ID}    ${get_id_nguoitao}     ${get_id_kh}    ${get_id_nguoiban}    ${final_discount}
    ...     ${liststring_prs_invoice_detail}    ${promotion_sale_id}    ${promotion_id}   ${text_promo_info}    ${get_id_dtgh}    ${result_tongtienhang}     ${result_khachcantra}     ${Uuid_code}
    Log    ${request_payload}
    ${invoice_code}    Post request to create invoice and get invoice code    ${request_payload}
    Toggle status of promotion    ${input_khuyemmai}    0
    Return From Keyword    ${invoice_code}

Add new invoice incase delivery and promotion invoice - offering free items - no payment
    [Arguments]    ${input_ma_kh}     ${input_ma_dtgh}     ${dict_product_nums}    ${list_change}    ${list_change_type}        ${list_promo_type}     ${input_khuyemmai}
    [Timeout]    5 mins
    ${Uuid}      Generate Random String    4    [NUMBERS][NUMBERS]
    ${Uuid_code}      Catenate      SEPARATOR=      WA     ${Uuid}
    Toggle status of promotion    ${input_khuyemmai}    1
    ${invoice_value}    ${discount}    ${discount_ratio}    ${name}    ${promotion_sale_id}    ${promotion_id}    Get Invoice value - Discounts - Promotion Name - Promotion Sale - Id from Promotion Code
    ...    ${input_khuyemmai}
    ${list_products}    Get Dictionary Keys    ${dict_product_nums}
    ${list_nums}    Get Dictionary Values    ${dict_product_nums}
    Create list imei and other product    ${list_products}    ${list_nums}
    Sleep    5s
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${get_id_kh}    Get customer id thr API    ${input_ma_kh}
    ${get_id_dtgh}    Get deliverypartner id frm api    ${input_ma_dtgh}
    ${list_id_sp}    Get list product id thr API    ${list_products}
    ${list_giaban}    ${list_result_ggsp}    Computation list price and result discount incase changing price by product code    ${list_products}    ${list_change}    ${list_change_type}
    ${list_thanhtien_hh}    Create List
    : FOR    ${giaban}    ${soluong}    IN ZIP    ${list_giaban}    ${list_nums}
    \    ${result_item_thanhtien}    Multiplication and round    ${giaban}    ${soluong}
    \    Append To List    ${list_thanhtien_hh}    ${result_item_thanhtien}
    Log    ${list_thanhtien_hh}
    ${result_tongtienhang}    Sum values in list    ${list_thanhtien_hh}
    ${result_tongtienhang}    Evaluate    round(${result_tongtienhang},0)
    ${get_list_baseprice}    Get list of Baseprice by Product Code    ${list_products}
    #thong tin km
    ${list_prs_name}    Get list product name thr API    ${list_products}
    ${text_total_invoice}    Convert from number to vnd discount text    ${invoice_value}    000000.0    ,000,000
    ${text_promo_info}    Format String    {0}: Tổng tiền hàng từ {1} tặng    ${name}    ${text_total_invoice}
    : FOR    ${item_num}    ${item_pr}    ${item_name}    ${item_promo_type}    IN ZIP    ${list_nums}
    ...    ${list_products}    ${list_prs_name}    ${list_promo_type}
    \    ${text_km_info}    Run Keyword If    '${item_promo_type}' == 'getpromo'    Format String    {0} {1} - {2}    ${item_num}
    \    ...    ${item_pr}    ${item_name}    ELSE    Log    Ignore
    \    ${text_promo_info}    Run Keyword If    '${item_promo_type}' == 'getpromo'    Catenate    SEPARATOR=,*    ${text_promo_info}
    \    ...    ${text_km_info}    ELSE    Set Variable    ${text_promo_info}
    ${text_promo_info}    Evaluate    "${text_promo_info}".replace("*", " ")
    #
    ${list_promo_id_value_payload}    Create List
    : FOR    ${item_promo_type}    IN ZIP    ${list_promo_type}
    \    ${item_promo_id_value}    Run Keyword If    '${item_promo_type}' == 'getpromo'    Set Variable    ${promotion_sale_id}
    \    ...    ELSE    Set Variable    null
    \    Append to list    ${list_promo_id_value_payload}    ${item_promo_id_value}
    #
    ${get_index_promo}      Get Index From List    ${list_promo_type}    getpromo
    ${product_promo_id}     Get From List    ${list_id_sp}    ${get_index_promo}
    ${product_promo_num}     Get From List    ${list_nums}    ${get_index_promo}
    #post request
    ${liststring_prs_invoice_detail}    Set Variable    needdel
    Log    ${liststring_prs_invoice_detail}
    : FOR    ${item_gia_ban}    ${item_id_sp}    ${item_soluong}    ${item_imei}    ${item_result_ggsp}    ${item_change}
    ...    ${item_change_type}    ${item_pr}      ${item_promo_id}      IN ZIP    ${get_list_baseprice}    ${list_id_sp}    ${list_nums}
    ...    ${imei_inlist}    ${list_result_ggsp}    ${list_change}    ${list_change_type}    ${list_products}     ${list_promo_id_value_payload}
    \    ${item_imei}    Convert list to string and return    ${item_imei}
    \    ${item_ggsp}    Set Variable If    0 < ${item_change} < 100 and '${item_change_type}'=='dis'    ${item_change}    null
    \    ${payload_each_product}    Format string    {{"BasePrice":{0},"IsLotSerialControl":true,"IsRewardPoint":true,"Price":{0},"ProductId":{1},"Quantity":{2},"ProductCode":"{6}","SerialNumbers":"{3}","Weight":0,"Discount":{4},"DiscountRatio":{5},"ProductName":"Điện thoại A","SalePromotionId":{7},"PriceByPromotion":null,"PromotionParentProductId":null,"ProductBatchExpireId":null,"CategoryId":439203,"MasterProductId":{1},"Unit":"","Uuid":"","ProductWarranty":[]}}    ${item_gia_ban}    ${item_id_sp}    ${item_soluong}
    \    ...    ${item_imei}    ${item_result_ggsp}    ${item_ggsp}    ${item_pr}   ${item_promo_id}
    \    ${liststring_prs_invoice_detail}    Catenate    SEPARATOR=,    ${liststring_prs_invoice_detail}    ${payload_each_product}
    ${liststring_prs_invoice_detail}    Replace String    ${liststring_prs_invoice_detail}    needdel,    ${EMPTY}    count=1
    ${request_payload}    Format String    {{"Invoice":{{"BranchId":{0},"RetailerId":{1},"UpdateInvoiceId":0,"UpdateReturnId":0,"IsChangeNormalToShippingDelivery":false,"CustomerId":{2},"SoldById":{3},"SoldBy":{{"CreatedBy":0,"CreatedDate":"","Email":"","GivenName":"admin","Id":{3},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false}},"SaleChannelId":0,"Seller":{{"CreatedBy":0,"CreatedDate":"","Email":"","GivenName":"admin","Id":{3},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false}},"OrderCode":"","Code":"Hóa đơn 1","InvoiceDetails":[{4}],"InvoiceOrderSurcharges":[],"InvoicePromotions":[{{"Type":2,"TargetType":0,"SalePromotionId":{5},"PromotionId":{6},"ProductId":{7},"ProductQty":{8},"PromotionInfo":"{9}","PrintPromotionInfo":"{9}","ProductIds":"{7}","BackupSelectedSerials":{{}}}}],"DeliveryDetail":{{"Type":0,"TypeName":"","Status":1,"Address":"số 11 ngõ 123 Trần Đại nghĩa","ContactNumber":"0912754690","Receiver":"Nguyễn Thị Mai Anh","DeliveryBy":{10},"LocationId":244,"LocationName":"Hà Nội - Quận Hoàng Mai","WardName":"Phường Hoàng Liệt","CustomerId":{2},"CustomerCode":"CTKH001","BranchTakingAddressId":null,"BranchTakingAddressStr":"Hà Nội, Phường Điện Biên, Quận Ba Đình, Hà Nội - 0987545635","WardId":116,"LastLocation":"Hà Nội - Quận Hoàng Mai","LastWard":"Phường Hoàng Liệt","UsingPriceCod":1,"Width":1,"Height":1,"Length":1,"Weight":500,"UsingOfBilling":false,"Paymenter":0,"PackageType":0,"UseDefaultPartner":false,"ServiceCode":"0","TotalProductPrice":{11},"ServiceAdd":null,"Price":null,"DeliveryCode":null,"DeliveryStatus":null,"ExpectedDelivery":null,"PartnerCode":"DT00006","PartnerDelivery":{{"Type":0,"Code":"DT00006","ContactNumber":"01689346787","CreatedDate":"","Id":{10},"LocationName":"","Name":"Nguyễn Văn Nam","PartnerDeliveryGroupDetails":[],"RetailerId":{1},"SearchNumber":"01689346787","WardName":"","isActive":true,"isDeleted":false}},"WeightEdited":true,"PartnerName":"","ExpectedDeliveryText":""}},"UsingCod":1,"Payments":[],"Status":3,"Total":{11},"Surcharge":0,"Type":1,"Uuid":"{12}","addToAccount":"0","addToAccountSurplus":"0","addToAccountAllocation":"0","addToAccountPaymentAllocation":"0","PayingAmount":0,"TotalBeforeDiscount":5230000,"ProductDiscount":-130000,"DebugUuid":"","InvoiceWarranties":[],"CreatedBy":{3}}}}}    ${BRANCH_ID}    ${get_id_nguoitao}     ${get_id_kh}    ${get_id_nguoiban}
    ...     ${liststring_prs_invoice_detail}    ${promotion_sale_id}    ${promotion_id}     ${product_promo_id}   ${product_promo_num}  ${text_promo_info}    ${get_id_dtgh}    ${result_tongtienhang}     ${Uuid_code}
    Log    ${request_payload}
    ${invoice_code}    Post request to create invoice and get invoice code    ${request_payload}
    Toggle status of promotion    ${input_khuyemmai}    0
    Return From Keyword    ${invoice_code}

Add new delivery invoice from order code thr API
      [Arguments]     ${input_ma_dh}    ${input_ma_kh}    ${input_ma_hang}    ${input_soluong}
      ${Uuid}      Generate Random String    4    [NUMBERS][NUMBERS]
      ${Uuid_code}      Catenate      SEPARATOR=      WA     ${Uuid}
      ${get_id_kh}    Get customer id thr API    ${input_ma_kh}
      ${jsonpath_id_sp}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_hang}
      ${jsonpath_gia_ban}    Format String    $..Data[?(@.Code == '{0}')].BasePrice    ${input_ma_hang}
      ${endpoint_danhmuc_hh_co_dvt}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
      ${get_resp}     Get Request and return body    ${endpoint_danhmuc_hh_co_dvt}
      ${get_id_sp}    Get data from response json     ${get_resp}    ${jsonpath_id_sp}
      ${get_gia_ban}   Get data from response json     ${get_resp}    ${jsonpath_gia_ban}
      ${get_id_nguoitao}    Get RetailerID
      ${get_id_nguoiban}    Get User ID
      ${get_order_id}   ${get_order_detail_id}     Get order id and order detail id thr API    ${input_ma_dh}
      ${result_thanhtien}    Multiplication and round    ${get_gia_ban}    ${input_soluong}
      ${result_thanhtien}    Evaluate    round(${result_thanhtien},0)
      ${invoice_detail}     Format String     {{"BasePrice":{0},"IsLotSerialControl":false,"IsRewardPoint":false,"Note":"","Price":{0},"ProductId":{1},"Quantity":{2},"ProductCode":"GHT0002","Discount":0,"DiscountRatio":0,"ProductName":"Ô mai chanh đào Hồng Lam","OriginPrice":{0},"PriceByPromotion":null,"IsMaster":true,"PromotionParentProductId":null,"ProductBatchExpireId":null,"CategoryId":531914,"MasterProductId":14622898,"Unit":"","Uuid":"","OrderDetailId":{3},"ProductWarranty":[],"Formulas":null}}       ${get_gia_ban}   ${get_id_sp}    ${input_soluong}     ${get_order_detail_id}
      #
      ${request_payload}    Format String    {{"Invoice":{{"BranchId":{0},"RetailerId":{1},"OrderId":{2},"UpdateInvoiceId":0,"UpdateReturnId":0,"CustomerId":{3},"SoldById":{4},"SoldBy":{{"CreatedBy":0,"CreatedDate":"","GivenName":"admin","Id":{4},"IsActive":true,"IsAdmin":true,"Type":0,"isDeleted":false,"Name":"admin"}},"SaleChannelId":0,"Seller":{{"CreatedBy":0,"CreatedDate":"","GivenName":"admin","Id":{4},"IsActive":true,"IsAdmin":true,"Type":0,"isDeleted":false,"Name":"admin"}},"PriceBookId":0,"OrderCode":"{5}","Code":"Hóa đơn 2","Discount":0,"InvoiceDetails":[{6}],"InvoiceOrderSurcharges":[],"InvoicePromotions":[],"DeliveryDetail":{{"Type":0,"TypeName":"","Status":1,"Address":"","ContactNumber":"","Receiver":"","DeliveryBy":null,"LocationId":null,"LocationName":"","WardName":"","CustomerId":{3},"CustomerCode":"","BranchTakingAddressId":null,"BranchTakingAddressStr":"","UsingPriceCod":1,"LastLocation":"","LastWard":"","Weight":null}},"UsingCod":1,"Payments":[],"Status":3,"Total":{7},"Surcharge":0,"Type":1,"Uuid":"{8}","addToAccount":"0","PayingAmount":0,"OrderPaidAmount":0,"DepositReturn":0,"TotalBeforeDiscount":{7},"ProductDiscount":0,"PaidAmount":0,"DebugUuid":"","InvoiceWarranties":[],"CreatedBy":{4}}}}}    ${BRANCH_ID}    ${get_id_nguoitao}    ${get_order_id}      ${get_id_kh}     ${get_id_nguoiban}
      ...    ${input_ma_dh}    ${invoice_detail}     ${result_thanhtien}     ${Uuid_code}
      Log    ${request_payload}
      ${invoice_code}    Post request to create invoice and get invoice code    ${request_payload}
      Return From Keyword    ${invoice_code}

Add new invoice incase discount with multi product - payment with point
    [Arguments]    ${input_ma_kh}    ${dict_product_nums}    ${list_ggsp}    ${input_gghd}    ${input_diem}
    ${Uuid}      Generate Random String    4    [NUMBERS][NUMBERS]
    ${Uuid_code}      Catenate      SEPARATOR=      WA     ${Uuid}
    ${list_product_bf}    Get Dictionary Keys    ${dict_product_nums}
    ${list_nums_bf}    Get Dictionary Values    ${dict_product_nums}
    ${list_product}    ${list_nums}    Reverse two lists    ${list_product_bf}    ${list_nums_bf}
    Create list imei and other product    ${list_product}    ${list_nums}
    Sleep    5s
    #tính điểm
    ${get_money_to_point}    ${get_point_to_money}   ${get_invoice_count}     Get point to money and money to point thr API
    ${result_khtt}      Price after apllocate discount      ${input_diem}      ${get_money_to_point}    ${get_point_to_money}
    #get product info
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${jsonpath_id_kh}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_kh}
    ${get_id_kh}    Get data from API    ${endpoint_khachhang}    ${jsonpath_id_kh}
    ${endpoint_danhmuc_hh_co_dvt}    Format String    ${endpoint_list_hh_in_mhbh}    ${BRANCH_ID}    ${BRANCH_ID}
    ${get_resp_danhmuc_hh}    Get Request and return body    ${endpoint_danhmuc_hh_co_dvt}
    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}    Get list jsonpath product frm list product    ${list_product}
    Log    ${list_ggsp}
    ${list_giaban}    ${list_result_ggsp}    ${list_id_sp}    Get product info frm list jsonpath product have discount product    ${get_resp_danhmuc_hh}    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}
    ...    ${list_ggsp}
    ${list_thanhtien_hh}    Create List
    : FOR    ${giaban}    ${soluong}    ${item_ggsp}    IN ZIP    ${list_giaban}    ${list_nums}
    ...    ${list_ggsp}
    \    ${result_giaban_af_discount}    Run Keyword If    0 < ${item_ggsp} < 100    Price after % discount product    ${giaban}    ${item_ggsp}
    \    ...    ELSE IF    ${item_ggsp} > 100    Minus    ${giaban}    ${item_ggsp}
    \    ...    ELSE    Set Variable    ${giaban}
    \    ${result_item_thanhtien}    Multiplication and round    ${result_giaban_af_discount}    ${soluong}
    \    Append To List    ${list_thanhtien_hh}    ${result_item_thanhtien}
    Log    ${list_thanhtien_hh}
    ${result_tongtienhang}    Sum values in list    ${list_thanhtien_hh}
    ${giamgia_hd}    Set Variable If    0 < ${input_gghd} < 100    ${input_gghd}    null
    ${result_gghd}    Run Keyword If    0 < ${input_gghd} < 100    Convert % discount to VND    ${result_tongtienhang}    ${input_gghd}
    ...    ELSE    Set Variable    ${input_gghd}
    ${list_ggsp_bf}    ${list_thanhtien_hh_bf}    Reverse two lists    ${list_result_ggsp}    ${list_thanhtien_hh}
    Set Test Variable    \${list_ggsp_bf}    ${list_ggsp_bf}
    Set Test Variable    \${list_thanhtien_hh_bf}    ${list_thanhtien_hh_bf}
    #post request
    ${liststring_prs_invoice_detail}    Set Variable    needdel
    Log    ${liststring_prs_invoice_detail}
    : FOR    ${item_gia_ban}    ${item_id_sp}    ${item_soluong}    ${item_imei}    ${item_result_ggsp}    ${item_ggsp}
    ...    ${item_pr}    IN ZIP    ${list_giaban}    ${list_id_sp}    ${list_nums}    ${imei_inlist}
    ...    ${list_result_ggsp}    ${list_ggsp}    ${list_product}
    \    ${item_imei}    Convert list to string and return    ${item_imei}
    \    ${item_ggsp}    Set Variable If    0 < ${item_ggsp} < 100    ${item_ggsp}    0
    \    ${payload_each_product}    Format string    {{"BasePrice":1000000,"IsLotSerialControl":true,"IsRewardPoint":true,"Price":{0},"ProductId":{1},"Quantity":{2},"ProductCode":"{6}","SerialNumbers":"{3}","Weight":0,"Discount":{4},"DiscountRatio":{5},"ProductName":"Điện thoại A","SalePromotionId":null,"PriceByPromotion":null,"PromotionParentProductId":null,"ProductBatchExpireId":null,"CategoryId":439203,"MasterProductId":{1},"Unit":"","Uuid":"","ProductWarranty":[]}}    ${item_gia_ban}    ${item_id_sp}    ${item_soluong}
    \    ...    ${item_imei}    ${item_result_ggsp}    ${item_ggsp}    ${item_pr}
    \    ${liststring_prs_invoice_detail}    Catenate    SEPARATOR=,    ${liststring_prs_invoice_detail}    ${payload_each_product}
    ${liststring_prs_invoice_detail}    Replace String    ${liststring_prs_invoice_detail}    needdel,    ${EMPTY}    count=1
    ${request_payload}    Format String    {{"Invoice":{{"BranchId":{0},"RetailerId":{1},"CustomerId":{2},"SoldById":{3},"SoldBy":{{"CreatedBy":0,"CreatedDate":"2017-04-24T11:33:52.877Z","Email":"ngokanh610@gmail.com","GivenName":"TestShard53","Id":{3},"IsActive":true,"IsAdmin":true,"Type":0,"UserName":"admin"}},"SaleChannelId":0,"Seller":{{"CreatedBy":0,"CreatedDate":"2017-04-24T11:33:52.877Z","Email":"ngokanh610@gmail.com","GivenName":"TestShard53","Id":{3},"IsActive":true,"IsAdmin":true,"Type":0,"UserName":"admin"}},"OrderCode":"","Code":"Hóa đơn 1","Discount":{4},"DiscountRatio":{5},"InvoiceDetails":[{6}],"InvoiceOrderSurcharges":[],"InvoicePromotions":[],"Payments":[{{"Method":"Point","MethodStr":"Điểm","Amount":{8},"Id":-1,"AccountId":null,"UsePoint":{9}}}],"Status":1,"Total":2129584,"Surcharge":0,"Type":1,"Uuid":"{7}","addToAccount":"0","PayingAmount":2129584,"TotalBeforeDiscount":3513115,"ProductDiscount":747422,"DebugUuid":"","InvoiceWarranties":[],"CreatedBy":2}}}}    ${BRANCH_ID}    ${get_id_nguoitao}    ${get_id_kh}    ${get_id_nguoiban}
    ...    ${result_gghd}    ${giamgia_hd}    ${liststring_prs_invoice_detail}    ${Uuid_code}    ${result_khtt}    ${input_diem}
    Log    ${request_payload}
    ${invoice_code}    Post request to create invoice and get invoice code    ${request_payload}
    Return From Keyword    ${invoice_code}

Add new invoice incase discount with multi product - payment with voucher
    [Arguments]    ${input_ma_kh}    ${dict_product_nums}    ${list_ggsp}    ${input_gghd}    ${input_voucher_issue}    ${voucher_pub_value}
    ${Uuid}      Generate Random String    4    [NUMBERS][NUMBERS]
    ${Uuid_code}      Catenate      SEPARATOR=      WA     ${Uuid}
    ${list_product_bf}    Get Dictionary Keys    ${dict_product_nums}
    ${list_nums_bf}    Get Dictionary Values    ${dict_product_nums}
    ${list_product}    ${list_nums}    Reverse two lists    ${list_product_bf}    ${list_nums_bf}
    Create list imei and other product    ${list_product}    ${list_nums}
    Add new voucher code    ${input_voucher_issue}     1
    Sleep    5s
    #tính điểm
    ${item_voucher_toapply}        ${voucher_value}      ${voucher_minimum_invoicetotal}      Add new voucher and publish by API    ${input_voucher_issue}    1    ${voucher_pub_value}     1
    ${get_voucher_campaign_id}    Get voucher campaign id    ${input_voucher_issue}
    ${get_voucherId}    Get voucher id    ${get_voucher_campaign_id}    ${item_voucher_toapply}
    #get product info
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${jsonpath_id_kh}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_kh}
    ${get_id_kh}    Get data from API    ${endpoint_khachhang}    ${jsonpath_id_kh}
    ${endpoint_danhmuc_hh_co_dvt}    Format String    ${endpoint_list_hh_in_mhbh}    ${BRANCH_ID}    ${BRANCH_ID}
    ${get_resp_danhmuc_hh}    Get Request and return body    ${endpoint_danhmuc_hh_co_dvt}
    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}    Get list jsonpath product frm list product    ${list_product}
    Log    ${list_ggsp}
    ${list_giaban}    ${list_result_ggsp}    ${list_id_sp}    Get product info frm list jsonpath product have discount product    ${get_resp_danhmuc_hh}    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}
    ...    ${list_ggsp}
    ${list_thanhtien_hh}    Create List
    : FOR    ${giaban}    ${soluong}    ${item_ggsp}    IN ZIP    ${list_giaban}    ${list_nums}
    ...    ${list_ggsp}
    \    ${result_giaban_af_discount}    Run Keyword If    0 < ${item_ggsp} < 100    Price after % discount product    ${giaban}    ${item_ggsp}
    \    ...    ELSE IF    ${item_ggsp} > 100    Minus    ${giaban}    ${item_ggsp}
    \    ...    ELSE    Set Variable    ${giaban}
    \    ${result_item_thanhtien}    Multiplication and round    ${result_giaban_af_discount}    ${soluong}
    \    Append To List    ${list_thanhtien_hh}    ${result_item_thanhtien}
    Log    ${list_thanhtien_hh}
    ${result_tongtienhang}    Sum values in list    ${list_thanhtien_hh}
    ${giamgia_hd}    Set Variable If    0 < ${input_gghd} < 100    ${input_gghd}    null
    ${result_gghd}    Run Keyword If    0 < ${input_gghd} < 100    Convert % discount to VND    ${result_tongtienhang}    ${input_gghd}
    ...    ELSE    Set Variable    ${input_gghd}
    ${list_ggsp_bf}    ${list_thanhtien_hh_bf}    Reverse two lists    ${list_result_ggsp}    ${list_thanhtien_hh}
    Set Test Variable    \${list_ggsp_bf}    ${list_ggsp_bf}
    Set Test Variable    \${list_thanhtien_hh_bf}    ${list_thanhtien_hh_bf}
    #post request
    ${liststring_prs_invoice_detail}    Set Variable    needdel
    Log    ${liststring_prs_invoice_detail}
    : FOR    ${item_gia_ban}    ${item_id_sp}    ${item_soluong}    ${item_imei}    ${item_result_ggsp}    ${item_ggsp}
    ...    ${item_pr}    IN ZIP    ${list_giaban}    ${list_id_sp}    ${list_nums}    ${imei_inlist}
    ...    ${list_result_ggsp}    ${list_ggsp}    ${list_product}
    \    ${item_imei}    Convert list to string and return    ${item_imei}
    \    ${item_ggsp}    Set Variable If    0 < ${item_ggsp} < 100    ${item_ggsp}    0
    \    ${payload_each_product}    Format string    {{"BasePrice":1000000,"IsLotSerialControl":true,"IsRewardPoint":true,"Price":{0},"ProductId":{1},"Quantity":{2},"ProductCode":"{6}","SerialNumbers":"{3}","Weight":0,"Discount":{4},"DiscountRatio":{5},"ProductName":"Điện thoại A","SalePromotionId":null,"PriceByPromotion":null,"PromotionParentProductId":null,"ProductBatchExpireId":null,"CategoryId":439203,"MasterProductId":{1},"Unit":"","Uuid":"","ProductWarranty":[]}}    ${item_gia_ban}    ${item_id_sp}    ${item_soluong}
    \    ...    ${item_imei}    ${item_result_ggsp}    ${item_ggsp}    ${item_pr}
    \    ${liststring_prs_invoice_detail}    Catenate    SEPARATOR=,    ${liststring_prs_invoice_detail}    ${payload_each_product}
    ${liststring_prs_invoice_detail}    Replace String    ${liststring_prs_invoice_detail}    needdel,    ${EMPTY}    count=1
    ${request_payload}    Format String    {{"Invoice":{{"BranchId":{0},"RetailerId":{1},"CustomerId":{2},"SoldById":{3},"SoldBy":{{"CreatedBy":0,"CreatedDate":"2017-04-24T11:33:52.877Z","Email":"ngokanh610@gmail.com","GivenName":"TestShard53","Id":{3},"IsActive":true,"IsAdmin":true,"Type":0,"UserName":"admin"}},"SaleChannelId":0,"Seller":{{"CreatedBy":0,"CreatedDate":"2017-04-24T11:33:52.877Z","Email":"ngokanh610@gmail.com","GivenName":"TestShard53","Id":{3},"IsActive":true,"IsAdmin":true,"Type":0,"UserName":"admin"}},"OrderCode":"","Code":"Hóa đơn 1","Discount":{4},"DiscountRatio":{5},"InvoiceDetails":[{6}],"InvoiceOrderSurcharges":[],"InvoicePromotions":[],"Payments":[{{"Method":"Voucher","MethodStr":"Voucher","Amount":{9},"Id":-1,"AccountId":null,"UsePoint":null,"Voucher":{{"Code":"abc","Id":{11},"VoucherCampaignId":{10},"Price":{9},"CompareVoucherCampaign":{{"IdOld":0,"HasVoucherUsed":false,"CampaignScopeProduct":"","Id":{10},"CreatedDate":"2021-03-05T14:31:18.4630000+07:00","CreatedBy":{3},"ModifiedDate":"2021-03-05T14:31:43.6630000+07:00","ModifiedBy":{3},"RetailerId":{1},"Code":"PHVC000001","Name":"test","Quantity":1,"Price":{9},"IsActive":true,"StartDate":"2021-03-05T14:30:53.0000000+07:00","EndDate":"2021-09-05T14:30:53.0000000+07:00","ExpireTimeType":1,"ApplyTimeType":1,"IsGlobal":true,"ForAllUser":true,"ForAllCusGroup":true,"PrereqPrice":200000,"PrereqProductIds":"","PrereqCategoryIds":"0","VoucherBranchs":[],"VoucherUsers":[],"VoucherCustomerGroups":[],"Vouchers":[]}},"Status":1,"ReleaseDate":"2021-03-05T00:00:00.0000000+07:00","ExpireDate":"2021-09-05T14:30:53.0000000+07:00"}},"VoucherId":{11},"VoucherCampaignId":{10}}}],"Status":1,"Total":2129584,"Surcharge":0,"Type":1,"Uuid":"{7}","addToAccount":"0","PayingAmount":2129584,"TotalBeforeDiscount":3513115,"ProductDiscount":747422,"DebugUuid":"","InvoiceWarranties":[],"CreatedBy":2}}}}    ${BRANCH_ID}    ${get_id_nguoitao}    ${get_id_kh}    ${get_id_nguoiban}
    ...    ${result_gghd}    ${giamgia_hd}    ${liststring_prs_invoice_detail}    ${Uuid_code}    ${voucher_value}      ${voucher_value}     ${get_voucher_campaign_id}   ${get_voucherId}
    Log    ${request_payload}
    ${invoice_code}    Post request to create invoice and get invoice code    ${request_payload}
    Return From Keyword    ${invoice_code}
