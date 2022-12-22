*** Settings ***
Library           Collections
Library           RequestsLibrary
Library           SeleniumLibrary
Library           OperatingSystem
Library           String
Library           JSONLibrary
Library           StringFormat
Resource          ../share/computation.robot
Resource          api_danhmuc_hanghoa.robot
Resource          api_doi_tac_giaohang.robot
Resource          api_hoadon_banhang.robot
Resource          api_khachhang.robot
Resource          api_access.robot
Resource          api_thietlap.robot
Resource          api_dathang.robot
Resource          api_soquy.robot

*** Variables ***
${endpoint_delete_dh}    /orders/{0}?CompareCode={1}&IsVoidPayment=false    #id dat hang, ma dat hang

*** Keywords ***
Add new order frm API
    [Arguments]    ${input_ma_kh}    ${input_ma_hang}    ${input_soluong}    ${input_khtt}
    ${Uuid}      Generate Random String    4    [NUMBERS][NUMBERS]
    ${Uuid_code}      Catenate      SEPARATOR=      WA     ${Uuid}
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${jsonpath_id_kh}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_kh}
    ${jsonpath_id_sp}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_hang}
    ${jsonpath_gia_ban}    Format String    $..Data[?(@.Code == '{0}')].BasePrice    ${input_ma_hang}
    ${get_id_kh}    Get data from API    ${endpoint_khachhang}    ${jsonpath_id_kh}
    ${endpoint_danhmuc_hh_co_dvt}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${get_resp_danhmuc_hh}    Get Request and return body    ${endpoint_danhmuc_hh_co_dvt}
    ${get_id_sp}    Get data from response json    ${get_resp_danhmuc_hh}    ${jsonpath_id_sp}
    ${get_gia_ban}    Get data from response json    ${get_resp_danhmuc_hh}    ${jsonpath_gia_ban}
    ${result_khtt}    Multiplication with price round 2    ${get_gia_ban}    ${input_soluong}
    ${actual_khtt}    Set Variable If    '${input_khtt}' == 'all'    ${result_khtt}    ${input_khtt}
    ${jsonpath_tong_dh}    Format String    $..Data[?(@.Code=="{0}")].Reserved    ${input_ma_hang}
    ${get_tong_dh_string}    Get data from response json    ${get_resp_danhmuc_hh}    ${jsonpath_tong_dh}
    ${get_ordersummary}   Convert To Number    ${get_tong_dh_string}
    ${result_ordersummary}    Sum    ${get_ordersummary}    ${input_soluong}
    #Post request
    ${request_payload}    Format String    {{"Order":{{"BranchId":{0},"RetailerId":{1},"CustomerId":{2},"SoldById":{3},"SoldBy":{{"CreatedBy":0,"CreatedDate":"2018-07-30T08:27:36.800Z","Email":"","GivenName":"anh.lv","Id":{4},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false}},"SaleChannelId":0,"Seller":{{"CreatedBy":0,"CreatedDate":"2018-07-30T08:27:36.800Z","Email":"","GivenName":"anh.lv","Id":{5},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false}},"Code":"Đặt hàng 1","OrderDetails":[{{"BasePrice":70000,"IsLotSerialControl":false,"IsRewardPoint":false,"Note":"","Price":{6},"ProductId":{7},"Quantity":{8},"ProductCode":"HH0005"}}],"InvoiceOrderSurcharges":[],"Payments":[{{"Method":"Cash","MethodStr":"Tiền mặt","Amount":{9},"Id":-1}}],"UsingCod":0,"Status":1,"Total":70000,"Extra":"{{\\"Amount\\":60000,\\"Method\\":{{\\"Id\\":\\"Cash\\",\\"Label\\":\\"Tiền mặt\\"}}}}","Surcharge":0,"Type":2,"Uuid":"{10}","addToAccount":"0","PayingAmount":0,"TotalBeforeDiscount":70000,"ProductDiscount":0}}}}    ${BRANCH_ID}    ${get_id_nguoitao}    ${get_id_kh}    ${get_id_nguoiban}
    ...    ${get_id_nguoiban}    ${get_id_nguoiban}    ${get_gia_ban}    ${get_id_sp}    ${input_soluong}    ${actual_khtt}    ${Uuid_code}
    Log    ${request_payload}
    ${order_code}    Post request to create order and return code    ${request_payload}
    #Sleep    5s
    #${get_tongso_dh_bf_execute}    Get order summary by order code    ${order_code}
    #Should Be Equal As Numbers    ${get_tongso_dh_bf_execute}    ${result_ordersummary}
    Return From Keyword    ${order_code}

Add new order with multi products
    [Arguments]    ${input_ma_kh}    ${dict_product_nums}    ${input_khtt}
    ${Uuid}      Generate Random String    4    [NUMBERS][NUMBERS]
    ${Uuid_code}      Catenate      SEPARATOR=      WA     ${Uuid}
    ${list_product}    Get Dictionary Keys    ${dict_product_nums}
    ${list_nums}    Get Dictionary Values    ${dict_product_nums}
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${jsonpath_id_kh}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_kh}
    ${get_id_kh}    Get data from API    ${endpoint_khachhang}    ${jsonpath_id_kh}
    ${list_result_order_summary}    Get list result order summary frm product API    ${list_product}    ${list_nums}
    ${endpoint_danhmuc_hh_co_dvt}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${get_resp_danhmuc_hh}    Get Request and return body    ${endpoint_danhmuc_hh_co_dvt}
    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}    Get list jsonpath product frm list product    ${list_product}
    ${list_giaban}    ${list_id_sp}    Get product info frm list jsonpath product    ${get_resp_danhmuc_hh}    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}
    ${liststring_prs_order_detail}     Set Variable      needdel
    Log        ${liststring_prs_order_detail}
    : FOR    ${item_gia_ban}   ${item_id_sp}   ${item_soluong}    IN ZIP      ${list_giaban}        ${list_id_sp}    ${list_nums}
    \    ${payload_each_product}        Format string       {{"BasePrice":{0},"Discount":0,"DiscountRatio":0,"IsLotSerialControl":false,"IsMaster":false,"IsRewardPoint":false,"Note":"","Price":{0},"ProductCode":"GHQD0001","ProductId":{1},"ProductName":"Bánh xu kem Nhật - (hộp nhỏ)","Quantity":{2},"SerialNumbers":"","Uuid":"","OriginPrice":{0},"ProductBatchExpireId":null,"Formulas":null}}     ${item_gia_ban}   ${item_id_sp}   ${item_soluong}
    \    ${liststring_prs_order_detail}       Catenate      SEPARATOR=,      ${liststring_prs_order_detail}      ${payload_each_product}
    ${liststring_prs_order_detail}       Replace String      ${liststring_prs_order_detail}       needdel,       ${EMPTY}      count=1
    #compute
    ${list_result_thanhtien}    Create List
    : FOR    ${item_giaban}    ${item_nums}    IN ZIP    ${list_giaban}    ${list_nums}
    \    ${result_thanhtien}    Multiplication with price round 2    ${item_giaban}    ${item_nums}
    \    Append To List    ${list_result_thanhtien}    ${result_thanhtien}
    ${result_tongtienhang}    Sum values in list    ${list_result_thanhtien}
    ${actuall_khtt}    Set Variable If    '${input_khtt}' == 'all'    ${result_tongtienhang}    ${input_khtt}
    ${request_payload}    Format String    {{"Order":{{"BranchId":{0},"RetailerId":{1},"CustomerId":{2},"SoldById":{3},"SoldBy":{{"CreatedBy":0,"CreatedDate":"2018-07-30T08:27:36.800Z","Email":"","GivenName":"anh.lv","Id":{3},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false}},"SaleChannelId":0,"Seller":{{"CreatedBy":0,"CreatedDate":"2018-07-30T08:27:36.800Z","Email":"","GivenName":"anh.lv","Id":{3},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false}},"Code":"Đặt hàng 1","OrderDetails":[{4}],"InvoiceOrderSurcharges":[],"Payments":[{{"Method":"Cash","MethodStr":"Tiền mặt","Amount":{5},"Id":-1}}],"UsingCod":0,"Status":1,"Total":757500,"Extra":"{{\\"Amount\\":60000,\\"Method\\":{{\\"Id\\":\\"Cash\\",\\"Label\\":\\"Tiền mặt\\"}}}}","Surcharge":0,"Type":2,"Uuid":"{6}","addToAccount":"0","PayingAmount":0,"TotalBeforeDiscount":757500,"ProductDiscount":0}}}}    ${BRANCH_ID}    ${get_id_nguoitao}    ${get_id_kh}    ${get_id_nguoiban}   ${liststring_prs_order_detail}    ${actuall_khtt}    ${Uuid_code}
    Log    ${request_payload}
    ${order_code}    Post request to create order and return code    ${request_payload}
    Return From Keyword    ${order_code}

Add new order with multi product and no payment - get order code
    [Arguments]    ${input_ma_kh}    ${dict_product_nums}
    ${Uuid}      Generate Random String    4    [NUMBERS][NUMBERS]
    ${Uuid_code}      Catenate      SEPARATOR=      WA     ${Uuid}
    ${list_product}    Get Dictionary Keys    ${dict_product_nums}
    ${list_nums}    Get Dictionary Values    ${dict_product_nums}
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${jsonpath_id_kh}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_kh}
    ${get_id_kh}    Get data from API    ${endpoint_khachhang}    ${jsonpath_id_kh}
    ${endpoint_danhmuc_hh_co_dvt}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${get_resp_danhmuc_hh}    Get Request and return body    ${endpoint_danhmuc_hh_co_dvt}
    ${list_result_order_summary}   Get list result order summary frm product API    ${list_product}    ${list_nums}
    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}    Get list jsonpath product frm list product    ${list_product}
    ${list_giaban}    ${list_id_sp}    Get product info frm list jsonpath product    ${get_resp_danhmuc_hh}    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}
    ${liststring_prs_order_detail}     Set Variable      needdel
    Log        ${liststring_prs_order_detail}
    : FOR    ${item_gia_ban}   ${item_id_sp}   ${item_soluong}    IN ZIP      ${list_giaban}        ${list_id_sp}    ${list_nums}
    \    ${payload_each_product}        Format string       {{"BasePrice":200000,"IsLotSerialControl":false,"IsRewardPoint":false,"Note":"","Price":{0},"ProductId":{1},"Quantity":{2},"ProductCode":"Combo05"}}     ${item_gia_ban}   ${item_id_sp}   ${item_soluong}
    \    ${liststring_prs_order_detail}       Catenate      SEPARATOR=,      ${liststring_prs_order_detail}      ${payload_each_product}
    ${liststring_prs_order_detail}       Replace String      ${liststring_prs_order_detail}       needdel,       ${EMPTY}      count=1
    ${request_payload}    Format String    {{"Order":{{"BranchId":{0},"RetailerId":{1},"CustomerId":{2},"SoldById":{3},"SoldBy":{{"CreatedBy":0,"CreatedDate":"2018-07-30T08:27:36.800Z","Email":"","GivenName":"anh.lv","Id":{3},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false}},"SaleChannelId":0,"Seller":{{"CreatedBy":0,"CreatedDate":"2018-07-30T08:27:36.800Z","Email":"","GivenName":"anh.lv","Id":{3},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false}},"Code":"Đặt hàng 1","OrderDetails":[{4}],"InvoiceOrderSurcharges":[],"Payments":[],"UsingCod":0,"Status":1,"Total":757500,"Surcharge":0,"Type":2,"Uuid":"{5}","addToAccount":"0","PayingAmount":0,"TotalBeforeDiscount":757500,"ProductDiscount":0}}}}    ${BRANCH_ID}    ${get_id_nguoitao}    ${get_id_kh}    ${get_id_nguoiban}
    ...       ${liststring_prs_order_detail}    ${Uuid_code}
    Log    ${request_payload}
    ${order_code}    Post request to create order and return code    ${request_payload}
    #Sleep    10s
    #${list_order_summary_af_execute}    Get list order summary frm product API    ${list_product}
    #: FOR    ${result_tong_dh}    ${order_summary_af_execute}    IN ZIP    ${list_result_order_summary}    ${list_order_summary_af_execute}
    #\    Should Be Equal As Numbers    ${order_summary_af_execute}    ${result_tong_dh}
    Return From Keyword    ${order_code}

Add new order have surcharge
    [Arguments]    ${input_ma_kh}    ${dict_product_nums}    ${input_ma_thukhac}    ${input_khtt}
    ##Activate surcharge
    ${Uuid}      Generate Random String    4    [NUMBERS][NUMBERS]
    ${Uuid_code}      Catenate      SEPARATOR=      WA     ${Uuid}
    ${surcharge_vnd_value}    Get surcharge vnd value    ${input_ma_thukhac}
    ${surcharge_%}    Get surcharge percentage value    ${input_ma_thukhac}
    Run Keyword If    ${surcharge_%} == 0    Toggle surcharge VND    ${input_ma_thukhac}    true
    ...    ELSE    Toggle surcharge percentage    ${input_ma_thukhac}    true
    ${list_product}    Get Dictionary Keys    ${dict_product_nums}
    ${list_nums}    Get Dictionary Values    ${dict_product_nums}
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${get_id_thukhac}   ${get_thutu_thukhac}    Get Id and order surchage    ${input_ma_thukhac}
    ${jsonpath_id_kh}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_kh}
    ${get_id_kh}    Get data from API    ${endpoint_khachhang}    ${jsonpath_id_kh}
    ${endpoint_danhmuc_hh_co_dvt}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${get_resp}    Get Request and return body    ${endpoint_danhmuc_hh_co_dvt}
    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}    Get list jsonpath product frm list product    ${list_product}
    ${list_giaban}    ${list_id_sp}    Get product info frm list jsonpath product    ${get_resp}    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}
    #compute
    ${list_thanhtien_hh}    Create List
    : FOR    ${giaban}    ${soluong}    IN ZIP    ${list_giaban}    ${list_nums}
    \    ${result_item_thanhtien}    Multiplication and round    ${giaban}    ${soluong}
    \    Append To List    ${list_thanhtien_hh}    ${result_item_thanhtien}
    Log    ${list_thanhtien_hh}
    ${result_tongtienhang}    Sum values in list    ${list_thanhtien_hh}
    ${result_surcharge}    Convert % discount to VND and round    ${result_tongtienhang}    ${surcharge_%}
    ${actuall_khtt}    Set Variable If    '${input_khtt}' == 'all'    ${result_tongtienhang}    ${input_khtt}
    #post request
    ${liststring_prs_order_detail}     Set Variable      needdel
    Log        ${liststring_prs_order_detail}
    : FOR    ${item_gia_ban}   ${item_id_sp}   ${item_soluong}    IN ZIP      ${list_giaban}        ${list_id_sp}    ${list_nums}
    \    ${payload_each_product}        Format string       {{"BasePrice":200000,"IsLotSerialControl":false,"IsRewardPoint":false,"Note":"","Price":{0},"ProductId":{1},"Quantity":{2},"ProductCode":"Combo05"}}     ${item_gia_ban}   ${item_id_sp}   ${item_soluong}
    \    ${liststring_prs_order_detail}       Catenate      SEPARATOR=,      ${liststring_prs_order_detail}      ${payload_each_product}
    ${liststring_prs_order_detail}       Replace String      ${liststring_prs_order_detail}       needdel,       ${EMPTY}      count=1
    ${request_payload}    Format String    {{"Order":{{"BranchId":{0},"RetailerId":{1},"CustomerId":{2},"SoldById":{3},"SoldBy":{{"CreatedBy":0,"CreatedDate":"2018-07-30T08:27:36.800Z","Email":"","GivenName":"anh.lv","Id":{3},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false}},"SaleChannelId":0,"Seller":{{"CreatedBy":0,"CreatedDate":"2018-07-30T08:27:36.800Z","Email":"","GivenName":"anh.lv","Id":{3},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false}},"Code":"Đặt hàng 1","OrderDetails":[{4}],"InvoiceOrderSurcharges":[{{"Code":"THK000001","Name":"Phí VAT","Price":{5},"RetailerId":{1},"SurValueRatio":{6},"SurchargeId":{7},"UsageFlag":true,"ValueRatio":5,"isAuto":true}}],"Payments":[{{"Method":"Cash","MethodStr":"Tiền mặt","Amount":{8},"Id":-1}}],"UsingCod":0,"Status":1,"Total":757500,"Extra":"{{\\"Amount\\":60000,\\"Method\\":{{\\"Id\\":\\"Cash\\",\\"Label\\":\\"Tiền mặt\\"}}}}","Surcharge":34900,"Type":2,"Uuid":"{9}","addToAccount":"0","PayingAmount":0,"TotalBeforeDiscount":757500,"ProductDiscount":0}}}}      ${BRANCH_ID}    ${get_id_nguoitao}    ${get_id_kh}    ${get_id_nguoiban}
    ...    ${liststring_prs_order_detail}        ${result_surcharge}    ${surcharge_%}    ${get_id_thukhac}    ${actuall_khtt}    ${Uuid_code}
    Log    ${request_payload}
    ${order_code}    Post request to create order and return code    ${request_payload}
    Return From Keyword    ${order_code}

Add new order have multi surcharge
    [Arguments]    ${input_ma_kh}    ${dict_product_nums}    ${input_ma_thukhac1}    ${input_ma_thukhac2}    ${input_khtt}
    ##Activate surcharge
    ${Uuid}      Generate Random String    4    [NUMBERS][NUMBERS]
    ${Uuid_code}      Catenate      SEPARATOR=      WA     ${Uuid}
    ${surcharge_value_1_vnd}    Get surcharge vnd value    ${input_ma_thukhac1}
    ${surcharge_value_1_percentage}    Get surcharge percentage value    ${input_ma_thukhac1}
    ${surcharge_value_2_vnd}    Get surcharge vnd value    ${input_ma_thukhac2}
    ${surcharge_value_2_percentage}    Get surcharge percentage value    ${input_ma_thukhac2}
    ${actual_surcharge1_value}    Set Variable If    ${surcharge_value_1_percentage} == 0    ${surcharge_value_1_vnd}    ${surcharge_value_1_percentage}
    ${actual_surcharge2_value}    Set Variable If    ${surcharge_value_2_percentage} == 0    ${surcharge_value_2_vnd}    ${surcharge_value_2_percentage}
    Run Keyword If    ${actual_surcharge1_value} > 100    Toggle surcharge VND    ${input_ma_thukhac1}    true
    ...    ELSE    Toggle surcharge percentage    ${input_ma_thukhac1}    true
    Run Keyword If    ${actual_surcharge2_value} > 100    Toggle surcharge VND    ${input_ma_thukhac2}    true
    ...    ELSE    Toggle surcharge percentage    ${input_ma_thukhac2}    true
    ${list_product}    Get Dictionary Keys    ${dict_product_nums}
    ${list_nums}    Get Dictionary Values    ${dict_product_nums}
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${get_id_thukhac1}    ${get_thutu_thukhac1}    Get Id and order surchage    ${input_ma_thukhac1}
    ${get_id_thukhac2}    ${get_thutu_thukhac2}    Get Id and order surchage    ${input_ma_thukhac2}
    ${jsonpath_id_kh}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_kh}
    ${get_id_kh}    Get data from API    ${endpoint_khachhang}    ${jsonpath_id_kh}
    ${endpoint_danhmuc_hh_co_dvt}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${get_resp}    Get Request and return body    ${endpoint_danhmuc_hh_co_dvt}
    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}    Get list jsonpath product frm list product    ${list_product}
    ${list_giaban}    ${list_id_sp}    Get product info frm list jsonpath product    ${get_resp}    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}
    ${list_thanhtien_hh}    Create List
    : FOR    ${giaban}    ${soluong}    IN ZIP    ${list_giaban}    ${list_nums}
    \    ${result_item_thanhtien}    Multiplication and round    ${giaban}    ${soluong}
    \    Append To List    ${list_thanhtien_hh}    ${result_item_thanhtien}
    Log    ${list_thanhtien_hh}
    ${result_tongtienhang}    Sum values in list    ${list_thanhtien_hh}
    ${result_surcharge1}    Run Keyword If    0 < ${actual_surcharge1_value} < 100    Convert % discount to VND and round    ${result_tongtienhang}    ${actual_surcharge1_value}
    ...    ELSE    Set Variable    ${actual_surcharge1_value}
    ${result_surcharge2}    Run Keyword If    0 < ${actual_surcharge2_value} < 100    Convert % discount to VND and round    ${result_tongtienhang}    ${actual_surcharge2_value}
    ...    ELSE    Set Variable    ${actual_surcharge2_value}
    ${result_khachcantra}   Sum x 3    ${result_tongtienhang}    ${result_surcharge1}    ${result_surcharge2}
    ${actual_ktt}   Set Variable If    '${input_khtt}' == 'all'    ${result_khachcantra}    ${input_khtt}
    #post request
    ${liststring_prs_order_detail}     Set Variable      needdel
    Log        ${liststring_prs_order_detail}
    : FOR    ${item_gia_ban}   ${item_id_sp}   ${item_soluong}    IN ZIP      ${list_giaban}        ${list_id_sp}    ${list_nums}
    \    ${payload_each_product}        Format string       {{"BasePrice":37000,"IsLotSerialControl":false,"IsRewardPoint":false,"Note":"","Price":{0},"ProductCode":"DV061","ProductId":{1},"ProductName":"Nails 13","Quantity":{2},"Uuid":"","ProductBatchExpireId":null}}     ${item_gia_ban}   ${item_id_sp}   ${item_soluong}
    \    ${liststring_prs_order_detail}       Catenate      SEPARATOR=,      ${liststring_prs_order_detail}      ${payload_each_product}
    ${liststring_prs_order_detail}       Replace String      ${liststring_prs_order_detail}       needdel,       ${EMPTY}      count=1
    ${request_payload}    Format String    {{"Order":{{"BranchId":{0},"RetailerId":{1},"CustomerId":{2},"SoldById":{3},"SoldBy":{{"CreatedBy":0,"CreatedDate":"2018-12-10T10:43:27.420Z","Email":"","GivenName":"admin","Id":{3},"IsActive":true,"IsAdmin":true,"Type":0,"UserName":"admin","isDeleted":false}},"SaleChannelId":0,"SaleChannel":null,"Seller":{{"CreatedBy":0,"CreatedDate":"2018-12-10T10:43:27.420Z","Email":"","GivenName":"admin","Id":{3},"IsActive":true,"IsAdmin":true,"Type":0,"UserName":"admin","isDeleted":false}},"Code":"Đặt hàng 1","OrderDetails":[{4}],"InvoiceOrderSurcharges":[{{"Code":"TK002","Name":"Phí VAT2","Order":{5},"Price":{6},"RetailerId":{1},"SurValueRatio":{7},"SurchargeId":{8},"UsageFlag":true,"ValueRatio":5,"isAuto":true,"isReturnAuto":true}},{{"Code":"TK006","Name":"Phí giao hàng2","Order":{9},"Price":{10},"RetailerId":{1},"SurValue":{10},"SurchargeId":{11},"UsageFlag":true,"Value":20000,"isAuto":true,"isReturnAuto":true}}],"Payments":[{{"Method":"Cash","MethodStr":"Tiền mặt","Amount":{12},"Id":-1}}],"UsingCod":0,"Status":1,"Total":3599765,"Extra":"{{\\"Amount\\":0,\\"Method\\":{{\\"Id\\":\\"Cash\\",\\"Label\\":\\"Tiền mặt\\"}},\\"ResetPromotion\\":false}}","Surcharge":190465,"Type":2,"Uuid":"{13}","addToAccount":"0","PayingAmount":0,"TotalBeforeDiscount":3409300,"ProductDiscount":0,"CreatedBy":386013,"InvoiceWarranties":[]}}}}    ${BRANCH_ID}    ${get_id_nguoitao}    ${get_id_kh}    ${get_id_nguoiban}
    ...    ${liststring_prs_order_detail}    ${get_thutu_thukhac1}    ${result_surcharge1}    ${actual_surcharge1_value}    ${get_id_thukhac1}
    ...    ${get_thutu_thukhac2}    ${result_surcharge2}    ${get_id_thukhac2}    ${actual_ktt}    ${Uuid_code}
    Log    ${request_payload}
    ${order_code}    Post request to create order and return code    ${request_payload}
    Return From Keyword    ${order_code}

Add new order with promotion buy product and get other product discount
    [Arguments]    ${input_ma_kh}    ${dict_product_nums}    ${input_promotion}    ${dict_product_promo}    ${input_khtt}
    ${Uuid}      Generate Random String    4    [NUMBERS][NUMBERS]
    ${Uuid_code}      Catenate      SEPARATOR=      WA     ${Uuid}
    ${list_product}    Get Dictionary Keys    ${dict_product_nums}
    ${list_nums}    Get Dictionary Values    ${dict_product_nums}
    ${list_product_promo}    Get Dictionary Keys    ${dict_product_promo}
    ${list_nums_promo}    Get Dictionary Values    ${dict_product_promo}
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${jsonpath_id_kh}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_kh}
    ${get_id_kh}    Get data from API    ${endpoint_khachhang}    ${jsonpath_id_kh}
    ${endpoint_danhmuc_hh_co_dvt}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${get_resp_danhmuc_hh}    Get Request and return body    ${endpoint_danhmuc_hh_co_dvt}
    ${get_id_sale_promo}    ${get_id_promotion}    ${get_promo_discount}    Get promotion info    ${input_promotion}
    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}    Get list jsonpath product frm list product    ${list_product}
    ${list_giaban}    ${list_id_sp}    Get product info frm list jsonpath product    ${get_resp_danhmuc_hh}    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}
    ${list_jsonpath_id_sp_promo}    ${list_jsonpath_giaban_promo}    Get list jsonpath product frm list product    ${list_product_promo}
    ${list_giaban_promo}    ${list_id_sp_promo}    Get product info frm list jsonpath product    ${get_resp_danhmuc_hh}    ${list_jsonpath_id_sp_promo}    ${list_jsonpath_giaban_promo}
    ${ma_hh}    Get From List    ${list_product}    1
    ${get_id_sp1}    Get From List    ${list_id_sp}    0
    ${get_id_sp2}    Get From List    ${list_id_sp}    1
    ${get_gia_ban1}    Get From List    ${list_giaban}    0
    ${get_gia_ban2}    Get From List    ${list_giaban}    1
    ${input_soluong1}    Get From List    ${list_nums}    0
    ${input_soluong2}    Get From List    ${list_nums}    1
    ${get_id_sp_promo1}    Get From List    ${list_id_sp_promo}    0
    ${get_id_sp_promo2}    Get From List    ${list_id_sp_promo}    1
    ${get_gia_ban_promo1}    Get From List    ${list_giaban_promo}    0
    ${get_gia_ban_promo2}    Get From List    ${list_giaban_promo}    1
    ${input_soluong_promo1}    Get From List    ${list_nums_promo}    0
    ${input_soluong_promo2}    Get From List    ${list_nums_promo}    1
    ${discount1}    Set Variable If    ${get_gia_ban_promo1}>=${get_promo_discount}    ${get_promo_discount}     ${get_gia_ban_promo1}
    ${discount2}    Set Variable If    ${get_gia_ban_promo2}>=${get_promo_discount}    ${get_promo_discount}     ${get_gia_ban_promo2}
    ${text_promo_info}    Set Variable If    '${ma_hh}' == 'PROMO3'    KM theo HH hình thức mua hàng GG hàng vnd: Khi mua 1 PROMO3 - Bánh Trứng Tik-Tok Bơ Sữa (120g), 1 HH0034 - Gói 3 Trà sữa Royal tea mix Myanma giảm giá 30,000 cho 2 HKM001 - Gói 6 Thanh Bánh Socola KitKat 2F 17g, 2 HKM002 - Kẹo Hồng Sâm Vitamin Daegoung Food 2     KM theo HH hình thức mua hàng GG hàng vnd: Khi mua 1 HH0035 - Kem Hàn Quốc trà xanh XXXD, 1 HH0036 - Kem whipping cream Anchor giảm giá 30,000 cho 2 HKM001 - Gói 6 Thanh Bánh Socola KitKat 2F 17g, 2 HKM002 - Kẹo Hồng Sâm Vitamin Daegoung Food 2
    ${text_print_promo}    Set Variable If    '${ma_hh}' == 'PROMO3'   Mua 1 Bánh Trứng Tik-Tok Bơ Sữa (120g), 1 Gói 3 Trà sữa Royal tea mix Myanma giảm giá 30,000 cho 2 Gói 6 Thanh Bánh Socola KitKat 2F 17g, 2 Kẹo Hồng Sâm Vitamin Daegoung Food 2    Mua 1 Kem Hàn Quốc trà xanh XXXD, 1 Kem whipping cream Anchor giảm giá 30,000 cho 2 Gói 6 Thanh Bánh Socola KitKat 2F 17g, 2 Kẹo Hồng Sâm Vitamin Daegoung Food 2
    #post request
    ${request_payload}    Format String    {{"Order":{{"BranchId":{0},"RetailerId":{1},"CustomerId":{2},"SoldById":{3},"SoldBy":{{"CreatedBy":0,"CreatedDate":"2018-12-10T08:33:32.447Z","Email":"","GivenName":"admin","Id":{3},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false}},"SaleChannelId":0,"SaleChannel":null,"Seller":{{"CreatedBy":0,"CreatedDate":"2018-12-10T08:33:32.447Z","Email":"","GivenName":"admin","Id":{3},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false}},"Code":"Đặt hàng 1","OrderDetails":[{{"BasePrice":5000.25,"IsLotSerialControl":false,"IsRewardPoint":false,"Note":"","Price":{4},"ProductCode":"HDEC001","ProductId":{5},"ProductName":"Hàng hóa thường 1","Quantity":{6},"Uuid":"W156238292270571","ProductBatchExpireId":null}},{{"BasePrice":125000,"Discount":{7},"IsLotSerialControl":false,"IsRewardPoint":false,"Note":"","Price":{8},"ProductCode":"NK001","ProductId":{9},"ProductName":"Hạt tặng 1","PromotionParentProductId":{5},"PromotionParentType":1,"Quantity":{10},"SalePromotionId":{11},"Uuid":"","ProductBatchExpireId":null}},{{"BasePrice":145000,"Discount":{12},"IsLotSerialControl":false,"IsRewardPoint":false,"Note":"","Price":{13},"ProductCode":"NK002","ProductId":{14},"ProductName":"Hạt tặng 2","PromotionParentProductId":{5},"PromotionParentType":1,"Quantity":{15},"SalePromotionId":{11},"Uuid":"","ProductBatchExpireId":null}},{{"BasePrice":19000,"IsLotSerialControl":false,"IsRewardPoint":false,"Note":"","Price":{16},"ProductCode":"HH0042","ProductId":{17},"ProductName":"Bánh Trứng Tik-Tok Bơ Sữa (120g)","Quantity":{18},"Uuid":"","ProductBatchExpireId":null}}],"InvoiceOrderSurcharges":[],"OrderPromotions":[{{"SalePromotionId":{11},"Type":5,"TargetType":1,"TargetProductId":{5},"PromotionId":{19},"ProductId":null,"RelatedProductId":{5},"Discount":30000,"RelatedProductQty":1,"ProductQty":2,"PromotionInfo":"{20}","PrintPromotionInfo":"{21}","ProductIds":"{9},{14}","RelatedProductIds":"{9},{14}","RelatedCategoryIds":"1147662"}}],"Payments":[{{"Method":"Cash","MethodStr":"Tiền mặt","Amount":{22},"Id":-1}}],"UsingCod":0,"Status":1,"Total":464000,"Extra":"{{\\"Amount\\":100000,\\"Method\\":{{\\"Id\\":\\"Cash\\",\\"Label\\":\\"Tiền mặt\\"}},\\"ResetPromotion\\":false}}","Surcharge":0,"Type":2,"Uuid":"{23}","addToAccount":"0","PayingAmount":100000,"TotalBeforeDiscount":584000,"ProductDiscount":120000,"CreatedBy":441968,"InvoiceWarranties":[]}}}}    ${BRANCH_ID}    ${get_id_nguoitao}    ${get_id_kh}    ${get_id_nguoiban}
    ...    ${get_gia_ban1}    ${get_id_sp1}    ${input_soluong1}    ${discount1}    ${get_gia_ban_promo1}
    ...    ${get_id_sp_promo1}    ${input_soluong_promo1}    ${get_id_sale_promo}    ${discount2}    ${get_gia_ban_promo2}    ${get_id_sp_promo2}    ${input_soluong_promo2}
    ...    ${get_gia_ban2}    ${get_id_sp2}    ${input_soluong2}    ${get_id_promotion}
    ...    ${text_promo_info}    ${text_print_promo}    ${input_khtt}    ${Uuid_code}
    Log    ${request_payload}
    ${order_code}    Post request to create order and return code    ${request_payload}
    Return From Keyword    ${order_code}

Add new order with promotion buy product and get other product free
    [Arguments]    ${input_ma_kh}    ${dict_product_nums}    ${input_promotion}    ${dict_product_promo}    ${input_khtt}
    ${Uuid}      Generate Random String    4    [NUMBERS][NUMBERS]
    ${Uuid_code}      Catenate      SEPARATOR=      WA     ${Uuid}
    ${list_product}    Get Dictionary Keys    ${dict_product_nums}
    ${list_nums}    Get Dictionary Values    ${dict_product_nums}
    ${list_promo_product}    Get Dictionary Keys    ${dict_product_promo}
    ${list_promo_num}    Get Dictionary Values    ${dict_product_promo}
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${jsonpath_id_kh}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_kh}
    ${get_id_kh}    Get data from API    ${endpoint_khachhang}    ${jsonpath_id_kh}
    ${endpoint_danhmuc_hh_co_dvt}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${get_resp_danhmuc_hh}    Get Request and return body    ${endpoint_danhmuc_hh_co_dvt}
    ${get_id_sale_promo}    ${get_id_promotion}    ${get_promo_discount}    Get promotion info    ${input_promotion}
    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}    Get list jsonpath product frm list product    ${list_product}
    ${list_giaban}    ${list_id_sp}    Get product info frm list jsonpath product    ${get_resp_danhmuc_hh}    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}
    ${list_jsonpath_id_sp_promo}    ${list_jsonpath_giaban_promo}    Get list jsonpath product frm list product    ${list_promo_product}
    ${list_giaban_promo}    ${list_id_sp_promo}    Get product info frm list jsonpath product    ${get_resp_danhmuc_hh}    ${list_jsonpath_id_sp_promo}    ${list_jsonpath_giaban_promo}
    ${ma_hh}    Get From List    ${list_product}    0
    ${get_id_sp1}    Get From List    ${list_id_sp}    0
    ${get_id_sp2}    Get From List    ${list_id_sp}    1
    ${get_gia_ban1}    Get From List    ${list_giaban}    0
    ${get_gia_ban2}    Get From List    ${list_giaban}    1
    ${input_soluong1}    Get From List    ${list_nums}    0
    ${input_soluong2}    Get From List    ${list_nums}    1
    ${text_promo_info}    Set Variable If    '${ma_hh}' == 'HH0034'    Khi mua 1 HH0034 - Gói 3 Trà sữa Royal tea mix Myanma, 1 PROMO3 - Bánh Trứng Tik-Tok Bơ Sữa (120g) tặng 4 HKM001 - Gói 6 Thanh Bánh Socola KitKat 2F 17g     KM theo HH hinh thuc mua hang tặng hàng: Khi mua 1 HH0035 - Kem Hàn Quốc trà xanh XXXD, 1 HH0036 - Kem whipping cream Anchor tặng 4 HKM002 - Kẹo Hồng Sâm Vitamin Daegoung Food 2
    ${text_print_promo}    Set Variable If    '${ma_hh}' == 'HH0034'   Mua 1 Gói 3 Trà sữa Royal tea mix Myanma, 1 Bánh Trứng Tik-Tok Bơ Sữa (120g) tặng 4 Gói 6 Thanh Bánh Socola KitKat 2F 17g      Mua 1 Kem Hàn Quốc trà xanh XXXD, 1 Kem whipping cream Anchor tặng 4 Kẹo Hồng Sâm Vitamin Daegoung Food 2
    #post request
    ${liststring_prs_order_detail}     Set Variable      needdel
    Log        ${liststring_prs_order_detail}
    : FOR   ${item_gia_ban}   ${item_id_sp}   ${item_soluong}      IN ZIP   ${list_giaban_promo}        ${list_id_sp_promo}    ${list_promo_num}
    \    ${payload_each_product}        Format string       {{"BasePrice":82000,"Discount":{0},"IsLotSerialControl":false,"IsRewardPoint":false,"Note":"","Price":{0},"ProductCode":"NK001","ProductId":{1},"ProductName":"Hạt tặng 1","PromotionParentProductId":{1},"PromotionParentType":1,"Quantity":{2},"SalePromotionId":{3},"Uuid":"","ProductBatchExpireId":null}}   ${item_gia_ban}   ${item_id_sp}   ${item_soluong}   ${get_id_sale_promo}
    \    ${liststring_prs_order_detail}       Catenate      SEPARATOR=,      ${liststring_prs_order_detail}      ${payload_each_product}
    ${liststring_prs_order_detail}       Replace String      ${liststring_prs_order_detail}       needdel,       ${EMPTY}      count=1
    ${list_id_sp_promo}   Convert list to string and return     ${list_id_sp_promo}
    ${list_id_sp}   Convert list to string and return     ${list_id_sp}
    ${request_payload}    Format String    {{"Order":{{"BranchId":{0},"RetailerId":{1},"CustomerId":{2},"SoldById":{3},"SoldBy":{{"CreatedBy":0,"CreatedDate":"2018-12-10T08:33:32.447Z","Email":"","GivenName":"admin","Id":{3},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false}},"SaleChannelId":0,"SaleChannel":null,"Seller":{{"CreatedBy":0,"CreatedDate":"2018-12-10T08:33:32.447Z","Email":"","GivenName":"admin","Id":{3},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false}},"Code":"Đặt hàng 1","OrderDetails":[{{"BasePrice":5000.25,"IsLotSerialControl":false,"IsRewardPoint":false,"Note":"","Price":{4},"ProductCode":"HDEC001","ProductId":{5},"ProductName":"Hàng hóa thường 1","Quantity":{6},"Uuid":"","ProductBatchExpireId":null}},{7},{{"BasePrice":19000,"IsLotSerialControl":false,"IsRewardPoint":false,"Note":"","Price":{8},"ProductCode":"HH0042","ProductId":{9},"ProductName":"Bánh Trứng Tik-Tok Bơ Sữa (120g)","Quantity":{10},"Uuid":"","ProductBatchExpireId":null}}],"InvoiceOrderSurcharges":[],"OrderPromotions":[{{"SalePromotionId":{11},"Type":5,"TargetType":1,"TargetProductId":{5},"PromotionId":{12},"ProductId":null,"RelatedProductId":{5},"Discount":30000,"RelatedProductQty":1,"ProductQty":2,"PromotionInfo":"{13}","PrintPromotionInfo":"{14}","ProductIds":"{15}","RelatedProductIds":"{16}","RelatedCategoryIds":"1147662"}}],"Payments":[{{"Method":"Cash","MethodStr":"Tiền mặt","Amount":{17},"Id":-1}}],"UsingCod":0,"Status":1,"Total":464000,"Extra":"{{\\"Amount\\":100000,\\"Method\\":{{\\"Id\\":\\"Cash\\",\\"Label\\":\\"Tiền mặt\\"}},\\"ResetPromotion\\":false}}","Surcharge":0,"Type":2,"Uuid":"{18}","addToAccount":"0","PayingAmount":100000,"TotalBeforeDiscount":584000,"ProductDiscount":120000,"CreatedBy":441968,"InvoiceWarranties":[]}}}}    ${BRANCH_ID}    ${get_id_nguoitao}    ${get_id_kh}    ${get_id_nguoiban}
    ...    ${get_gia_ban1}    ${get_id_sp1}    ${input_soluong1}    ${liststring_prs_order_detail}
    ...    ${get_gia_ban2}    ${get_id_sp2}    ${input_soluong2}   ${get_id_sale_promo}    ${get_id_promotion}    ${text_promo_info}
    ...    ${text_print_promo}    ${list_id_sp_promo}    ${list_id_sp}    ${input_khtt}    ${Uuid_code}
    Log    ${request_payload}
    ${order_code}    Post request to create order and return code    ${request_payload}
    Return From Keyword    ${order_code}

Add new order with promotion buy every items at a fixed reduced price
    [Arguments]    ${input_ma_kh}    ${dict_product_nums}    ${input_promotion}    ${input_khtt}
    ${Uuid}      Generate Random String    4    [NUMBERS][NUMBERS]
    ${Uuid_code}      Catenate      SEPARATOR=      WA     ${Uuid}
    ${list_product}    Get Dictionary Keys    ${dict_product_nums}
    ${list_nums}    Get Dictionary Values    ${dict_product_nums}
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${get_id_sale_promo}    ${get_id_promotion}    ${get_promo_discount}    Get promotion info    ${input_promotion}
    ${jsonpath_id_kh}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_kh}
    ${get_id_kh}    Get data from API    ${endpoint_khachhang}    ${jsonpath_id_kh}
    ${endpoint_danhmuc_hh_co_dvt}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${get_resp_danhmuc_hh}    Get Request and return body    ${endpoint_danhmuc_hh_co_dvt}
    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}    Get list jsonpath product frm list product    ${list_product}
    ${list_giaban}    ${list_id_sp}    Get product info frm list jsonpath product    ${get_resp_danhmuc_hh}    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}
    #post request
    ${liststring_prs_order_detail}     Set Variable      needdel
    Log        ${liststring_prs_order_detail}
    : FOR   ${item_gia_ban}   ${item_id_sp}   ${item_soluong}      IN ZIP   ${list_giaban}        ${list_id_sp}    ${list_nums}
    \    ${result_ggsp}   Convert % discount to VND and round    ${item_gia_ban}    ${get_promo_discount}
    \    ${payload_each_product}        Format string       {{"BasePrice":250000.5,"Discount":{0},"DiscountRatio":{1},"IsLotSerialControl":true,"IsRewardPoint":false,"Note":"","Price":{2},"ProductCode":"SIDEC001","ProductId":{3},"ProductName":"Điện thoại 1","PromotionParentProductId":{3},"PromotionParentType":1,"Quantity":{4},"SalePromotionId":{5},"Uuid":"","ProductBatchExpireId":null}}    ${result_ggsp}   ${get_promo_discount}   ${item_gia_ban}   ${item_id_sp}   ${item_soluong}   ${get_id_sale_promo}
    \    ${liststring_prs_order_detail}       Catenate      SEPARATOR=,      ${liststring_prs_order_detail}      ${payload_each_product}
    ${liststring_prs_order_detail}       Replace String      ${liststring_prs_order_detail}       needdel,       ${EMPTY}      count=1
    ${ma_hh}   Get From List    ${list_product}     0
    ${text_promo_info}    Set Variable If    '${ma_hh}' == 'DVL010'    KM theo HH hinh thuc gia ban theo SL mua GG %: Khi mua 3 DVL010 - Dịch vụ 10 giảm giá 20%     KM theo HH hình thức giá bán theo SL mua GG %: Khi mua 3 DVT34 Kẹo Hồng Sâm Vitamin Daegoung Food (chiếc) giảm giá 20%
    ${text_print_promo}    Set Variable If    '${ma_hh}' == 'DVL010'   Mua 3 Dịch vụ 10 được giảm giá 20.00% mỗi sản phẩm    Mua 3 Kẹo Hồng Sâm Vitamin Daegoung Food (chiếc) giảm giá 20%
    ${id_sp}   Get From List    ${list_id_sp}     0
    ${list_id_sp}   Convert list to string and return     ${list_id_sp}
    ${request_payload}    Format String    {{"Order":{{"BranchId":{0},"RetailerId":{1},"CustomerId":{2},"SoldById":{3},"SoldBy":{{"CreatedBy":0,"CreatedDate":"2018-07-30T08:27:36.800Z","Email":"","GivenName":"anh.lv","Id":{3},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false}},"SaleChannelId":0,"SaleChannel":null,"Seller":{{"CreatedBy":0,"CreatedDate":"2018-07-30T08:27:36.800Z","Email":"","GivenName":"anh.lv","Id":{3},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false}},"Code":"Đặt hàng 1","OrderDetails":[{4}],"InvoiceOrderSurcharges":[],"OrderPromotions":[{{"Type":8,"TargetType":1,"SalePromotionId":{5},"PromotionId":{6},"ProductId":{7},"ProductPrice":20,"ProductQty":2,"RelatedProductId":{7},"PromotionInfo":"{8}","PrintPromotionInfo":"{9}","RelatedProductIds":"{10}","RelatedCategoryIds":"680827","PromotionApplicationType":"%"}}],"Payments":[{{"Method":"Cash","MethodStr":"Tiền mặt","Amount":{11},"Id":-1}}],"UsingCod":0,"Status":1,"Total":200000,"Extra":"{{\\"Amount\\":100000,\\"Method\\":{{\\"Id\\":\\"Cash\\",\\"Label\\":\\"Tiền mặt\\"}},\\"ResetPromotion\\":false}}","Surcharge":0,"Type":2,"Uuid":"{12}","addToAccount":"0","PayingAmount":100000,"TotalBeforeDiscount":250001,"ProductDiscount":50000,"CreatedBy":201567,"InvoiceWarranties":[]}}}}    ${BRANCH_ID}    ${get_id_nguoitao}    ${get_id_kh}    ${get_id_nguoiban}
    ...    ${liststring_prs_order_detail}   ${get_id_sale_promo}    ${get_id_promotion}    ${id_sp}
    ...    ${text_promo_info}    ${text_print_promo}    ${list_id_sp}   ${input_khtt}    ${Uuid_code}
    Log    ${request_payload}
    ${order_code}    Post request to create order and return code    ${request_payload}
    Return From Keyword    ${order_code}

Add new order with order - order discount promotion
    [Arguments]    ${input_ma_kh}    ${dict_product_nums}    ${input_promotion}    ${input_khtt}
    ${Uuid}      Generate Random String    4    [NUMBERS][NUMBERS]
    ${Uuid_code}      Catenate      SEPARATOR=      WA     ${Uuid}
    ${list_product}    Get Dictionary Keys    ${dict_product_nums}
    ${list_nums}    Get Dictionary Values    ${dict_product_nums}
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${get_id_sale_promo}    ${get_id_promotion}    ${get_promo_discount}    Get promotion info    ${input_promotion}
    ${jsonpath_id_kh}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_kh}
    ${get_id_kh}    Get data from API    ${endpoint_khachhang}    ${jsonpath_id_kh}
    ${endpoint_danhmuc_hh_co_dvt}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${get_resp_danhmuc_hh}    Get Request and return body    ${endpoint_danhmuc_hh_co_dvt}
    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}    Get list jsonpath product frm list product    ${list_product}
    ${list_giaban}    ${list_id_sp}    Get product info frm list jsonpath product    ${get_resp_danhmuc_hh}    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}
    ${text_promo_info}    Set Variable If    0 < ${get_promo_discount} < 100    Khuyến mại giảm giá Hóa đơn %: Tổng tiền hàng từ 4,000,000 giảm giá 5% cho hóa đơn     Khuyến mại giảm giá Hóa đơn VNĐ: Tổng tiền hàng từ 5,000,000 giảm giá 20,000 cho hóa đơn
    #post request
    ${list_thanhtien}   Create List
    ${liststring_prs_order_detail}     Set Variable      needdel
    Log        ${liststring_prs_order_detail}
    : FOR   ${item_gia_ban}   ${item_id_sp}   ${item_soluong}      IN ZIP   ${list_giaban}        ${list_id_sp}    ${list_nums}
    \    ${result_thanhtien}    Multiplication with price round 2    ${item_gia_ban}    ${item_soluong}
    \    Append To List    ${list_thanhtien}    ${result_thanhtien}
    \    ${payload_each_product}        Format string       {{"BasePrice":105000.02,"Discount":0,"DiscountRatio":0,"IsLotSerialControl":false,"IsRewardPoint":false,"Note":"","Price":{0},"ProductCode":"HH0052","ProductId":{1},"ProductName":"Bánh Pía Sầu Riêng Truly Vietnam Có Trứng","Quantity":{2},"Uuid":"","ProductBatchExpireId":null}}   ${item_gia_ban}   ${item_id_sp}   ${item_soluong}
    \    ${liststring_prs_order_detail}       Catenate      SEPARATOR=,      ${liststring_prs_order_detail}      ${payload_each_product}
    ${liststring_prs_order_detail}       Replace String      ${liststring_prs_order_detail}       needdel,       ${EMPTY}      count=1
    ${giamgia}    Set Variable If    0 < ${get_promo_discount} < 100    ${get_promo_discount}    0
    ${result_tongtienhang}    Sum values in list    ${list_thanhtien}
    ${giamgia_dh}    Run Keyword If   0 < ${get_promo_discount} < 100    Convert % discount to VND    ${result_tongtienhang}    ${get_promo_discount}    ELSE     Set Variable    ${get_promo_discount}
    ${result_tongtienhang_ggdh}    Minus and round    ${result_tongtienhang}    ${giamgia_dh}
    ${actual_khtt}    Set Variable If    '${input_khtt}' == 'all'    ${result_tongtienhang_ggdh}     ${input_khtt}
    ${request_payload}    Format String    {{"Order":{{"BranchId":{0},"RetailerId":{1},"CustomerId":{2},"SoldById":{3},"SoldBy":{{"CreatedBy":0,"CreatedDate":"2018-07-30T08:27:36.800Z","Email":"","GivenName":"anh.lv","Id":{3},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false}},"SaleChannelId":0,"SaleChannel":null,"Seller":{{"CreatedBy":0,"CreatedDate":"2018-07-30T08:27:36.800Z","Email":"","GivenName":"anh.lv","Id":{3},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false}},"Code":"Đặt hàng 1","Discount":{4},"DiscountRatio":{5},"OrderDetails":[{6}],"InvoiceOrderSurcharges":[],"OrderPromotions":[{{"Type":1,"TargetType":0,"SalePromotionId":{7},"PromotionId":{8},"Discount":20000,"PromotionInfo":"{9}","PrintPromotionInfo":"{9}"}}],"Payments":[{{"Method":"Cash","MethodStr":"Tiền mặt","Amount":{10},"Id":-1}}],"UsingCod":0,"Status":1,"Total":995000,"Extra":"{{\\"Amount\\":195000,\\"Method\\":{{\\"Id\\":\\"Cash\\",\\"Label\\":\\"Tiền mặt\\"}},\\"ResetPromotion\\":false}}","Surcharge":0,"Type":2,"Uuid":"{11}","addToAccount":"0","PayingAmount":195000,"TotalBeforeDiscount":1015000,"ProductDiscount":0,"CreatedBy":201567,"InvoiceWarranties":[],"DiscountByPromotion":20000,"DiscountByPromotionValue":20000,"DiscountByPromotionRatio":0}}}}    ${BRANCH_ID}    ${get_id_nguoitao}    ${get_id_kh}    ${get_id_nguoiban}   ${giamgia_dh}    ${giamgia}    ${liststring_prs_order_detail}    ${get_id_sale_promo}    ${get_id_promotion}    ${text_promo_info}    ${actual_khtt}    ${Uuid_code}
    Log    ${request_payload}
    Set Test Variable    \${tongtienhang}    ${result_tongtienhang}
    Set Test Variable    \${tongcong}    ${result_tongtienhang_ggdh}
    Set Test Variable    \${actual_khtt}    ${actual_khtt}
    Set Test Variable    \${list_giabansp}    ${list_giaban}
    ${order_code}    Post request to create order and return code    ${request_payload}
    Return From Keyword    ${order_code}

Add new order with order - Offering free items Promotion
    [Arguments]    ${input_ma_kh}    ${dict_product_nums}    ${input_promotion}    ${dict_product_promo}    ${input_khtt}
    ${Uuid}      Generate Random String    4    [NUMBERS][NUMBERS]
    ${Uuid_code}      Catenate      SEPARATOR=      WA     ${Uuid}
    ${list_product}    Get Dictionary Keys    ${dict_product_nums}
    ${list_nums}    Get Dictionary Values    ${dict_product_nums}
    ${list_product_promo}    Get Dictionary Keys    ${dict_product_promo}
    ${list_nums_promo}    Get Dictionary Values    ${dict_product_promo}
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${jsonpath_id_kh}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_kh}
    ${get_id_kh}    Get data from API    ${endpoint_khachhang}    ${jsonpath_id_kh}
    ${endpoint_danhmuc_hh_co_dvt}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${get_resp_danhmuc_hh}    Get Request and return body    ${endpoint_danhmuc_hh_co_dvt}
    ${get_id_sale_promo}    ${get_id_promotion}    ${get_promo_discount}    Get promotion info    ${input_promotion}
    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}    Get list jsonpath product frm list product    ${list_product}
    ${list_giaban}    ${list_id_sp}    Get product info frm list jsonpath product    ${get_resp_danhmuc_hh}    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}
    ${list_jsonpath_id_sp_promo}    ${list_jsonpath_giaban_promo}    Get list jsonpath product frm list product    ${list_product_promo}
    ${list_giaban_promo}    ${list_id_sp_promo}    Get product info frm list jsonpath product    ${get_resp_danhmuc_hh}    ${list_jsonpath_id_sp_promo}    ${list_jsonpath_giaban_promo}
    ${id_sp_promo1}     Get From List    ${list_id_sp_promo}    0
    #get list payload of product
    ${liststring_prs_order_detail}     Set Variable      needdel
    Log        ${liststring_prs_order_detail}
    : FOR    ${item_gia_ban}   ${item_id_sp}   ${item_soluong}      IN ZIP   ${list_giaban}        ${list_id_sp}    ${list_nums}
    \    ${payload_each_product}        Format string       {{"BasePrice":850000,"IsLotSerialControl":true,"IsRewardPoint":false,"Note":"","Price":{0},"ProductCode":"SI046","ProductId":{1},"ProductName":"Bàn Ủi Khô Philips GC160","Quantity":{2},"Uuid":"","ProductBatchExpireId":null}}   ${item_gia_ban}   ${item_id_sp}   ${item_soluong}
    \    ${liststring_prs_order_detail}       Catenate      SEPARATOR=,      ${liststring_prs_order_detail}      ${payload_each_product}
    ${liststring_prs_order_detail}       Replace String      ${liststring_prs_order_detail}       needdel,       ${EMPTY}      count=1
    #get list payload of product promotion
    ${liststring_prs_order_detail_promo}     Set Variable      needdel
    Log        ${liststring_prs_order_detail_promo}
    : FOR    ${item_gia_ban_promo}   ${item_id_sp_promo}   ${item_soluong_promo}      IN ZIP   ${list_giaban_promo}        ${list_id_sp_promo}    ${list_nums_promo}
    \    ${payload_each_product_promo}        Format string       {{"BasePrice":40000,"Discount":{0},"IsLotSerialControl":false,"IsRewardPoint":false,"Note":"","Price":{0},"ProductCode":"DV032","ProductId":{1},"ProductName":"Nhuộm tóc - Loreal","PromotionParentType":0,"Quantity":{2},"SalePromotionId":{3},"Uuid":"","ProductBatchExpireId":null}}   ${item_gia_ban_promo}   ${item_id_sp_promo}   ${item_soluong_promo}    ${get_id_sale_promo}
    \    ${liststring_prs_order_detail_promo}       Catenate      SEPARATOR=,      ${liststring_prs_order_detail_promo}      ${payload_each_product_promo}
    ${liststring_prs_order_detail_promo}       Replace String      ${liststring_prs_order_detail_promo}       needdel,       ${EMPTY}      count=1
    ${list_id_sp_promo}   Convert list to string and return     ${list_id_sp_promo}
    #post request
    ${request_payload}    Format String    {{"Order":{{"BranchId":{0},"RetailerId":{1},"CustomerId":{2},"SoldById":{3},"SoldBy":{{"CreatedBy":0,"CreatedDate":"2018-07-30T08:27:36.800Z","Email":"","GivenName":"anh.lv","Id":{3},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false}},"SaleChannelId":0,"SaleChannel":null,"Seller":{{"CreatedBy":0,"CreatedDate":"2018-07-30T08:27:36.800Z","Email":"","GivenName":"anh.lv","Id":{3},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false}},"Code":"Đặt hàng 1","Discount":{4},"OrderDetails":[{5},{6}],"InvoiceOrderSurcharges":[],"OrderPromotions":[{{"Type":2,"TargetType":0,"SalePromotionId":{7},"PromotionId":{8},"ProductId":{9},"ProductQty":3,"PromotionInfo":"Khuyến mại hóa đơn tặng hàng: Tổng tiền hàng từ 5,000,000 tặng 1 DV031 - Dập phồng tóc - Loreal, 1 DV032 - Nhuộm tóc - Loreal, 1 DV033 - Hấp phục hồi Loreal cho hóa đơn","PrintPromotionInfo":"Tổng tiền hàng từ 5,000,000 tặng 1 Dập phồng tóc - Loreal, 1 Nhuộm tóc - Loreal, 1 Hấp phục hồi Loreal cho hóa đơn","ProductIds":"{10}"}}],"Payments":[{{"Method":"Cash","MethodStr":"Tiền mặt","Amount":{11},"Id":-1}}],"UsingCod":0,"Status":1,"Total":1074800,"Extra":"{{\\"Amount\\":500000,\\"Method\\":{{\\"Id\\":\\"Cash\\",\\"Label\\":\\"Tiền mặt\\"}},\\"ResetPromotion\\":false}}","Surcharge":0,"Type":2,"Uuid":"{12}","addToAccount":"0","PayingAmount":500000,"TotalBeforeDiscount":1194800,"ProductDiscount":90000,"CreatedBy":201567,"InvoiceWarranties":[]}}}}    ${BRANCH_ID}    ${get_id_nguoitao}    ${get_id_kh}    ${get_id_nguoiban}
    ...    0      ${liststring_prs_order_detail}     ${liststring_prs_order_detail_promo}
    ...    ${get_id_sale_promo}    ${get_id_promotion}    ${id_sp_promo1}        ${list_id_sp_promo}    ${input_khtt}    ${Uuid_code}
    Log    ${request_payload}
    ${order_code}    Post request to create order and return code    ${request_payload}
    Return From Keyword    ${order_code}

Add new order with order - offering discount pricing promotion
    [Arguments]    ${input_ma_kh}    ${dict_product_nums}    ${input_promotion}    ${dict_product_promo}    ${input_khtt}
    ${Uuid}      Generate Random String    4    [NUMBERS][NUMBERS]
    ${Uuid_code}      Catenate      SEPARATOR=      WA     ${Uuid}
    ${list_product}    Get Dictionary Keys    ${dict_product_nums}
    ${list_nums}    Get Dictionary Values    ${dict_product_nums}
    ${list_product_promo}    Get Dictionary Keys    ${dict_product_promo}
    ${list_nums_promo}    Get Dictionary Values    ${dict_product_promo}
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${jsonpath_id_kh}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_kh}
    ${get_id_kh}    Get data from API    ${endpoint_khachhang}    ${jsonpath_id_kh}
    ${endpoint_danhmuc_hh_co_dvt}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${get_id_sale_promo}    ${get_id_promotion}    ${get_promo_discount}    Get promotion info    ${input_promotion}
    ${get_resp_danhmuc_hh}    Get Request and return body    ${endpoint_danhmuc_hh_co_dvt}
    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}    Get list jsonpath product frm list product    ${list_product}
    ${list_giaban}    ${list_id_sp}    Get product info frm list jsonpath product    ${get_resp_danhmuc_hh}    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}
    ${list_jsonpath_id_sp_promo}    ${list_jsonpath_giaban_promo}    Get list jsonpath product frm list product    ${list_product_promo}
    ${list_giaban_promo}    ${list_id_sp_promo}    Get product info frm list jsonpath product    ${get_resp_danhmuc_hh}    ${list_jsonpath_id_sp_promo}    ${list_jsonpath_giaban_promo}
    ${get_id_sp1}    Get From List    ${list_id_sp}    0
    ${get_id_sp2}    Get From List    ${list_id_sp}    1
    ${get_gia_ban1}    Get From List    ${list_giaban}    0
    ${get_gia_ban2}    Get From List    ${list_giaban}    1
    ${get_gia_ban1}    Replace floating point    ${get_gia_ban1}
    ${get_gia_ban2}    Replace floating point    ${get_gia_ban2}
    ${input_soluong1}    Get From List    ${list_nums}    0
    ${input_soluong2}    Get From List    ${list_nums}    1
    ${get_id_sp_promo1}    Get From List    ${list_id_sp_promo}    0
    ${get_gia_ban_promo1}    Get From List    ${list_giaban_promo}   0
    ${get_gia_ban_promo1}    Replace floating point    ${get_gia_ban_promo1}
    ${input_soluong_promo1}    Get From List    ${list_nums_promo}    0
    ${result_ggsp}    Convert % discount to VND and round    ${get_gia_ban_promo1}    ${get_promo_discount}
    #post request
    ${request_payload}    Format String    {{"Order":{{"BranchId":{0},"RetailerId":{1},"CustomerId":{2},"SoldById":{3},"SoldBy":{{"CreatedBy":0,"CreatedDate":"2018-12-10T08:33:32.447Z","Email":"","GivenName":"admin","Id":{3},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false}},"SaleChannelId":0,"SaleChannel":null,"Seller":{{"CreatedBy":0,"CreatedDate":"2018-12-10T08:33:32.447Z","Email":"","GivenName":"admin","Id":{3},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false}},"Code":"Đặt hàng 1","OrderDetails":[{{"BasePrice":380000,"IsLotSerialControl":false,"IsRewardPoint":false,"Note":"","Price":{4},"ProductCode":"DV125","ProductId":{5},"ProductName":"Uốn tóc 47","Quantity":{6},"Uuid":"","ProductBatchExpireId":null}},{{"BasePrice":385000,"IsLotSerialControl":false,"IsRewardPoint":false,"Note":"","Price":{7},"ProductCode":"QD173","ProductId":{8},"ProductName":"Hạnh Nhân vị Gà Cay Sunnuts 30g Spicy - (hộp thập phân)","Quantity":{9},"Uuid":"","ProductBatchExpireId":null}},{{"BasePrice":300000,"Discount":{10},"DiscountRatio":{11},"IsBatchExpireControl":false,"IsLotSerialControl":false,"IsRewardPoint":false,"Note":"","Price":{12},"ProductCode":"DV031","ProductId":{13},"ProductName":"Dập phồng tóc - Loreal","PromotionParentType":0,"Quantity":{14},"SalePromotionId":{15},"Uuid":"","ProductBatchExpireId":null}}],"InvoiceOrderSurcharges":[],"OrderPromotions":[{{"Type":3,"TargetType":0,"SalePromotionId":{15},"PromotionId":{16},"ProductId":{13},"ProductQty":2,"PromotionInfo":"Khuyến mại hóa đơn giảm giá SP %: Tổng tiền hàng từ 5,000,000 giảm giá 10% cho 2 DV031 - Dập phồng tóc - Loreal","PrintPromotionInfo":"Tổng tiền hàng từ 5,000,000 giảm giá 10% cho 2 Dập phồng tóc - Loreal","ProductIds":"{13}"}}],"Payments":[{{"Method":"Cash","MethodStr":"Tiền mặt","Amount":{17},"Id":-1}}],"UsingCod":0,"Status":1,"Total":3595000,"Extra":"{{\\"Amount\\":595000,\\"Method\\":{{\\"Id\\":\\"Cash\\",\\"Label\\":\\"Tiền mặt\\"}},\\"ResetPromotion\\":false}}","Surcharge":0,"Type":2,"Uuid":"{18}","addToAccount":"0","PayingAmount":595000,"TotalBeforeDiscount":3655000,"ProductDiscount":60000,"CreatedBy":441968,"InvoiceWarranties":[]}}}}    ${BRANCH_ID}    ${get_id_nguoitao}    ${get_id_kh}    ${get_id_nguoiban}   ${get_gia_ban1}    ${get_id_sp1}    ${input_soluong1}    ${get_gia_ban2}    ${get_id_sp2}    ${input_soluong2}
    ...    ${result_ggsp}    ${get_promo_discount}    ${get_gia_ban_promo1}    ${get_id_sp_promo1}    ${input_soluong_promo1}    ${get_id_sale_promo}
    ...    ${get_id_promotion}    ${input_khtt}    ${Uuid_code}
    Log    ${request_payload}
    ${order_code}    Post request to create order and return code    ${request_payload}
    Return From Keyword    ${order_code}

Delete order frm Order code
    [Arguments]    ${input_ma_dh}
    ${jsonpath_id_dh}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_dh}
    ${get_id_dh}    Get data from API    ${endpoint_order}    ${jsonpath_id_dh}
    ${endpoint_delete_dh}    Format String    ${endpoint_delete_dh}    ${get_id_dh}    ${input_ma_dh}
    Delete request thr API    ${endpoint_delete_dh}

Post request to create order and return code
    [Arguments]    ${request_payload}
    ${resp}    Post request thr API      /orders    ${request_payload}
    ${string}    Convert To String    ${resp}
    ${dict}    Set Variable    ${resp}
    ${order_code}    Get From Dictionary    ${dict}    Code
    Return From Keyword    ${order_code}

Post request to create order with other branch
    [Arguments]    ${request_payload}   ${input_ten_branch}
    ${get_id_branch}    Get BranchID by BranchName    ${input_ten_branch}
    ${get_id_branch}    Convert To String    ${get_id_branch}
    ${headers}=    Create Dictionary    Authorization=${bearertoken}    Content-Type=application/json;charset=UTF-8    Retailer=${RETAILER_NAME}    BranchId=${get_id_branch}
    Log    ${headers}
    Create Session    lolo    ${SALE_API_URL}    verify=True    debug=1
    ${resp}=    Wait Until Keyword Succeeds    3x    0s     Post Request    lolo    /orders    data=${request_payload}    headers=${headers}
    Log    ${resp.request.body}
    Log    ${resp.json()}
    Log    ${resp.status_code}
    Should Be Equal As Strings    ${resp.status_code}    200
    Return From Keyword    ${resp.status_code}    ${resp.json()}

Post request to create order
    [Arguments]    ${request_payload}
    Post request thr API    /orders    ${request_payload}

Add new order incase discount - no payment
    [Arguments]    ${input_ma_kh}    ${input_ggdh}    ${dict_product_nums}    ${list_ggsp}    ${list_discount_type}
    #get product info
    ${Uuid}      Generate Random String    4    [NUMBERS][NUMBERS]
    ${Uuid_code}      Catenate      SEPARATOR=      WA     ${Uuid}
    ${list_product}   Get Dictionary Keys    ${dict_product_nums}
    ${list_soluong_sp}    Get Dictionary Values    ${dict_product_nums}
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${jsonpath_id_kh}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_kh}
    ${get_id_kh}    Get data from API    ${endpoint_khachhang}    ${jsonpath_id_kh}
    ${endpoint_danhmuc_hh_co_dvt}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${get_resp}    Get Request and return body    ${endpoint_danhmuc_hh_co_dvt}
    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}    Get list jsonpath product frm list product    ${list_product}
    ${list_giaban}    ${list_result_ggsp}    ${list_id_sp}      ${list_thanhtien}    Get product info frm list jsonpath product incase discount product - return total sale    ${get_resp}    ${list_jsonpath_id_sp}
    ...   ${list_jsonpath_giaban}    ${list_ggsp}    ${list_discount_type}    ${list_soluong_sp}
    #compute
    ${result_tongtienhang}    Sum values in list    ${list_thanhtien}
    ${giamgia_dh}    Set Variable If    0 < ${input_ggdh} < 100    ${input_ggdh}    0
    ${result_ggdh}    Run Keyword If    0 < ${input_ggdh} < 100    Convert % discount to VND    ${result_tongtienhang}    ${input_ggdh}    ELSE    Set Variable    ${input_ggdh}
    ${result_khtt}    Minus    ${result_tongtienhang}    ${result_ggdh}
    #post request
    ${liststring_prs_order_detail}     Set Variable      needdel
    Log        ${liststring_prs_order_detail}
    : FOR    ${item_gia_ban}   ${item_id_sp}   ${item_soluong}    ${item_result_ggsp}   ${item_ggsp}      IN ZIP       ${list_giaban}        ${list_id_sp}    ${list_soluong_sp}       ${list_result_ggsp}       ${list_ggsp}
    \    ${item_ggsp}   Set Variable If    0 < ${item_ggsp} < 100    ${item_ggsp}   0
    \    ${payload_each_product}        Format string           {{"BasePrice":200000,"IsLotSerialControl":false,"IsRewardPoint":false,"Note":"","Price":{0},"ProductId":{1},"Quantity":{2},"Discount":{3},"DiscountRatio":{4},"ProductCode":"Combo05"}}    ${item_gia_ban}   ${item_id_sp}   ${item_soluong}    ${item_result_ggsp}   ${item_ggsp}
    \    ${liststring_prs_order_detail}       Catenate      SEPARATOR=,      ${liststring_prs_order_detail}      ${payload_each_product}
    ${liststring_prs_order_detail}       Replace String      ${liststring_prs_order_detail}       needdel,       ${EMPTY}      count=1
    ${request_payload}    Format String    {{"Order":{{"BranchId":{0},"RetailerId":{1},"CustomerId":{2},"SoldById":{3},"SoldBy":{{"CreatedBy":0,"CreatedDate":"2018-07-30T08:27:36.800Z","Email":"","GivenName":"anh.lv","Id":{3},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false}},"SaleChannelId":0,"Seller":{{"CreatedBy":0,"CreatedDate":"2018-07-30T08:27:36.800Z","Email":"","GivenName":"anh.lv","Id":{3},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false}},"Code":"Đặt hàng 1","Discount":{4},"DiscountRatio":{5},"OrderDetails":[{6}],"InvoiceOrderSurcharges":[],"Payments":[],"UsingCod":0,"Status":1,"Total":757500,"Extra":"{{\\"Amount\\":0,\\"Method\\":{{\\"Id\\":\\"Cash\\",\\"Label\\":\\"Tiền mặt\\"}}}}","Surcharge":0,"Type":2,"Uuid":"{7}","addToAccount":"0","PayingAmount":0,"TotalBeforeDiscount":757500,"ProductDiscount":0}}}}    ${BRANCH_ID}    ${get_id_nguoitao}    ${get_id_kh}    ${get_id_nguoiban}    ${result_ggdh}    ${giamgia_dh}    ${liststring_prs_order_detail}    ${Uuid_code}
    Log    ${request_payload}
    Set Test Variable    \${tongtienhang}    ${result_tongtienhang}
    Set Test Variable    \${ggdh}     ${result_ggdh}
    Set Test Variable    \${tongcong}    ${result_khtt}
    Set Test Variable    \${list_giabansp}    ${list_giaban}
    Set Test Variable    \${list_ggsp}    ${list_result_ggsp}
    ${order_code}    Post request to create order and return code    ${request_payload}
    Return From Keyword    ${order_code}

Add new order incase discount - payment
    [Arguments]    ${input_ma_kh}    ${input_ggdh}    ${dict_product_nums}    ${list_ggsp}    ${list_discount_type}    ${input_khtt}
    [Timeout]          5 mins
    #get product info
    ${Uuid}      Generate Random String    4    [NUMBERS][NUMBERS]
    ${Uuid_code}      Catenate      SEPARATOR=      WA     ${Uuid}
    ${list_product}   Get Dictionary Keys    ${dict_product_nums}
    ${list_soluong_sp}      Get Dictionary Values    ${dict_product_nums}
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${jsonpath_id_kh}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_kh}
    ${get_id_kh}    Get data from API    ${endpoint_khachhang}    ${jsonpath_id_kh}
    ${endpoint_danhmuc_hh_co_dvt}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${get_resp_danhmuc_hh}    Get Request and return body    ${endpoint_danhmuc_hh_co_dvt}
    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}    Get list jsonpath product frm list product    ${list_product}
    ${list_giaban}    ${list_result_ggsp}    ${list_id_sp}      ${list_thanhtien}    Get product info frm list jsonpath product incase discount product - return total sale    ${get_resp_danhmuc_hh}    ${list_jsonpath_id_sp}
    ...   ${list_jsonpath_giaban}    ${list_ggsp}    ${list_discount_type}    ${list_soluong_sp}
    #compute
    ${result_tongtienhang}    Sum values in list    ${list_thanhtien}
    ${giamgia_dh}    Set Variable If    0 < ${input_ggdh} < 100    ${input_ggdh}    0
    ${result_ggdh}    Run Keyword If    0 < ${input_ggdh} < 100    Convert % discount to VND    ${result_tongtienhang}    ${input_ggdh}    ELSE    Set Variable    ${input_ggdh}
    ${result_khtt}    Minus and round    ${result_tongtienhang}    ${result_ggdh}
    ${actual_khtt}    Set Variable If    '${input_khtt}' == 'all'    ${result_khtt}    ${input_khtt}
    #post request
    ${liststring_prs_order_detail}     Set Variable      needdel
    Log        ${liststring_prs_order_detail}
    : FOR    ${item_gia_ban}   ${item_id_sp}   ${item_soluong}    ${item_result_ggsp}   ${item_ggsp}      IN ZIP       ${list_giaban}        ${list_id_sp}    ${list_soluong_sp}       ${list_result_ggsp}       ${list_ggsp}
    \    ${item_ggsp}   Set Variable If    0 < ${item_ggsp} < 100    ${item_ggsp}   0
    \    ${payload_each_product}        Format string           {{"BasePrice":200000,"IsLotSerialControl":false,"IsRewardPoint":false,"Note":"","Price":{0},"ProductId":{1},"Quantity":{2},"Discount":{3},"DiscountRatio":{4},"ProductCode":"Combo05"}}    ${item_gia_ban}   ${item_id_sp}   ${item_soluong}    ${item_result_ggsp}   ${item_ggsp}
    \    ${liststring_prs_order_detail}       Catenate      SEPARATOR=,      ${liststring_prs_order_detail}      ${payload_each_product}
    ${liststring_prs_order_detail}       Replace String      ${liststring_prs_order_detail}       needdel,       ${EMPTY}      count=1
    ${request_payload}    Format String    {{"Order":{{"BranchId":{0},"RetailerId":{1},"CustomerId":{2},"SoldById":{3},"SoldBy":{{"CreatedBy":0,"CreatedDate":"2018-07-30T08:27:36.800Z","Email":"","GivenName":"anh.lv","Id":{3},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false}},"SaleChannelId":0,"Seller":{{"CreatedBy":0,"CreatedDate":"2018-07-30T08:27:36.800Z","Email":"","GivenName":"anh.lv","Id":{3},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false}},"Code":"Đặt hàng 1","Discount":{4},"DiscountRatio":{5},"OrderDetails":[{6}],"InvoiceOrderSurcharges":[],"Payments":[{{"Method":"Cash","MethodStr":"Tiền mặt","Amount":{7},"Id":-1}}],"UsingCod":0,"Status":1,"Total":757500,"Extra":"{{\\"Amount\\":0,\\"Method\\":{{\\"Id\\":\\"Cash\\",\\"Label\\":\\"Tiền mặt\\"}}}}","Surcharge":0,"Type":2,"Uuid":"{8}","addToAccount":"0","PayingAmount":0,"TotalBeforeDiscount":757500,"ProductDiscount":0}}}}    ${BRANCH_ID}    ${get_id_nguoitao}    ${get_id_kh}    ${get_id_nguoiban}
    ...    ${result_ggdh}    ${giamgia_dh}    ${liststring_prs_order_detail}    ${actual_khtt}    ${Uuid_code}
    Log    ${request_payload}
    Set Test Variable    \${tongtienhang}    ${result_tongtienhang}
    Set Test Variable    \${ggdh}     ${result_ggdh}
    Set Test Variable    \${tongcong}    ${result_khtt}
    Set Test Variable    \${list_giabansp}    ${list_giaban}
    Set Test Variable    \${list_ggsp}    ${list_result_ggsp}
    Set Test Variable    \${actual_khtt}    ${actual_khtt}
    ${order_code}    Post request to create order and return code    ${request_payload}
    Return From Keyword    ${order_code}

Add new order incase discount - payment with other branch
    [Arguments]    ${input_ma_kh}    ${input_ggdh}    ${dict_product_nums}    ${list_ggsp}    ${list_discount_type}    ${input_khtt}    ${input_ten_branch}
    [Timeout]          5 mins
    #get product info
    ${Uuid}      Generate Random String    4    [NUMBERS][NUMBERS]
    ${Uuid_code}      Catenate      SEPARATOR=      WA     ${Uuid}
    ${list_product}   Get Dictionary Keys    ${dict_product_nums}
    ${list_soluong_sp}      Get Dictionary Values    ${dict_product_nums}
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${jsonpath_id_kh}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_kh}
    ${get_id_kh}    Get data from API    ${endpoint_khachhang}    ${jsonpath_id_kh}
    ${endpoint_danhmuc_hh_co_dvt}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${get_resp_danhmuc_hh}    Get Request and return body    ${endpoint_danhmuc_hh_co_dvt}
    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}    Get list jsonpath product frm list product    ${list_product}
    ${list_giaban}    ${list_result_ggsp}    ${list_id_sp}      ${list_thanhtien}    Get product info frm list jsonpath product incase discount product - return total sale    ${get_resp_danhmuc_hh}    ${list_jsonpath_id_sp}
    ...   ${list_jsonpath_giaban}    ${list_ggsp}    ${list_discount_type}    ${list_soluong_sp}
    ${get_id_branch}    Get BranchID by BranchName    ${input_ten_branch}
    #compute
    ${result_tongtienhang}    Sum values in list    ${list_thanhtien}
    ${giamgia_dh}    Set Variable If    0 < ${input_ggdh} < 100    ${input_ggdh}    0
    ${result_ggdh}    Run Keyword If    0 < ${input_ggdh} < 100    Convert % discount to VND    ${result_tongtienhang}    ${input_ggdh}    ELSE    Set Variable    ${input_ggdh}
    ${result_khtt}    Minus    ${result_tongtienhang}    ${result_ggdh}
    ${actual_khtt}    Set Variable If    '${input_khtt}' == 'all'    ${result_khtt}    ${input_khtt}
    #post request
    ${liststring_prs_order_detail}     Set Variable      needdel
    Log        ${liststring_prs_order_detail}
    : FOR    ${item_gia_ban}   ${item_id_sp}   ${item_soluong}    ${item_result_ggsp}   ${item_ggsp}      IN ZIP       ${list_giaban}        ${list_id_sp}    ${list_soluong_sp}       ${list_result_ggsp}       ${list_ggsp}
    \    ${item_ggsp}   Set Variable If    0 < ${item_ggsp} < 100    ${item_ggsp}   0
    \    ${payload_each_product}        Format string           {{"BasePrice":200000,"IsLotSerialControl":false,"IsRewardPoint":false,"Note":"","Price":{0},"ProductId":{1},"Quantity":{2},"Discount":{3},"DiscountRatio":{4},"ProductCode":"Combo05"}}    ${item_gia_ban}   ${item_id_sp}   ${item_soluong}    ${item_result_ggsp}   ${item_ggsp}
    \    ${liststring_prs_order_detail}       Catenate      SEPARATOR=,      ${liststring_prs_order_detail}      ${payload_each_product}
    ${liststring_prs_order_detail}       Replace String      ${liststring_prs_order_detail}       needdel,       ${EMPTY}      count=1
    ${request_payload}    Format String    {{"Order":{{"BranchId":{0},"RetailerId":{1},"CustomerId":{2},"SoldById":{3},"SoldBy":{{"CreatedBy":0,"CreatedDate":"2018-07-30T08:27:36.800Z","Email":"","GivenName":"anh.lv","Id":{3},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false}},"SaleChannelId":0,"Seller":{{"CreatedBy":0,"CreatedDate":"2018-07-30T08:27:36.800Z","Email":"","GivenName":"anh.lv","Id":{3},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false}},"Code":"Đặt hàng 1","Discount":{4},"DiscountRatio":{5},"OrderDetails":[{6}],"InvoiceOrderSurcharges":[],"Payments":[{{"Method":"Cash","MethodStr":"Tiền mặt","Amount":{7},"Id":-1}}],"UsingCod":0,"Status":1,"Total":757500,"Extra":"{{\\"Amount\\":0,\\"Method\\":{{\\"Id\\":\\"Cash\\",\\"Label\\":\\"Tiền mặt\\"}}}}","Surcharge":0,"Type":2,"Uuid":"{8}","addToAccount":"0","PayingAmount":0,"TotalBeforeDiscount":757500,"ProductDiscount":0}}}}    ${get_id_branch}    ${get_id_nguoitao}    ${get_id_kh}    ${get_id_nguoiban}
    ...    ${result_ggdh}    ${giamgia_dh}    ${liststring_prs_order_detail}    ${actual_khtt}    ${Uuid_code}
    Log    ${request_payload}
    ${resp.status_code}    ${resp.json()}    Post request to create order with other branch    ${request_payload}    ${input_ten_branch}
    ${string}    Convert To String    ${resp.json()}
    ${dict}    Set Variable    ${resp.json()}
    ${order_code}    Get From Dictionary    ${dict}    Code
    Return From Keyword    ${order_code}

## no customer
Add new order incase discount - no payment - no customer
    [Arguments]    ${input_ggdh}    ${dict_product_nums}    ${list_ggsp}    ${list_discount_type}
    #get product info
    ${Uuid}      Generate Random String    4    [NUMBERS][NUMBERS]
    ${Uuid_code}      Catenate      SEPARATOR=      WA     ${Uuid}
    ${list_product}   Get Dictionary Keys    ${dict_product_nums}
    ${list_soluong_sp}    Get Dictionary Values    ${dict_product_nums}
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${endpoint_danhmuc_hh_co_dvt}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${get_resp}    Get Request and return body    ${endpoint_danhmuc_hh_co_dvt}
    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}    Get list jsonpath product frm list product    ${list_product}
    ${list_giaban}    ${list_result_ggsp}    ${list_id_sp}      ${list_thanhtien}    Get product info frm list jsonpath product incase discount product - return total sale    ${get_resp}    ${list_jsonpath_id_sp}
    ...   ${list_jsonpath_giaban}    ${list_ggsp}    ${list_discount_type}    ${list_soluong_sp}
    #compute
    ${result_tongtienhang}    Sum values in list    ${list_thanhtien}
    ${giamgia_dh}    Set Variable If    0 < ${input_ggdh} < 100    ${input_ggdh}    0
    ${result_ggdh}    Run Keyword If    0 < ${input_ggdh} < 100    Convert % discount to VND    ${result_tongtienhang}    ${input_ggdh}    ELSE    Set Variable    ${input_ggdh}
    #post request
    ${liststring_prs_order_detail}     Set Variable      needdel
    Log        ${liststring_prs_order_detail}
    : FOR    ${item_gia_ban}   ${item_id_sp}   ${item_soluong}    ${item_result_ggsp}   ${item_ggsp}      IN ZIP       ${list_giaban}        ${list_id_sp}    ${list_soluong_sp}       ${list_result_ggsp}       ${list_ggsp}
    \    ${item_ggsp}   Set Variable If    0 < ${item_ggsp} < 100    ${item_ggsp}   0
    \    ${payload_each_product}        Format string           {{"BasePrice":200000,"IsLotSerialControl":false,"IsRewardPoint":false,"Note":"","Price":{0},"ProductId":{1},"Quantity":{2},"Discount":{3},"DiscountRatio":{4},"ProductCode":"Combo05"}}    ${item_gia_ban}   ${item_id_sp}   ${item_soluong}    ${item_result_ggsp}   ${item_ggsp}
    \    ${liststring_prs_order_detail}       Catenate      SEPARATOR=,      ${liststring_prs_order_detail}      ${payload_each_product}
    ${liststring_prs_order_detail}       Replace String      ${liststring_prs_order_detail}       needdel,       ${EMPTY}      count=1
    ${request_payload}    Format String    {{"Order":{{"BranchId":{0},"RetailerId":{1},"SoldById":{2},"SoldBy":{{"CreatedBy":0,"CreatedDate":"2018-07-30T08:27:36.800Z","Email":"","GivenName":"anh.lv","Id":{2},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false}},"SaleChannelId":0,"Seller":{{"CreatedBy":0,"CreatedDate":"2018-07-30T08:27:36.800Z","Email":"","GivenName":"anh.lv","Id":{2},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false}},"Code":"Đặt hàng 1","Discount":{3},"DiscountRatio":{4},"OrderDetails":[{5}],"InvoiceOrderSurcharges":[],"Payments":[],"UsingCod":0,"Status":1,"Total":757500,"Extra":"{{\\"Amount\\":0,\\"Method\\":{{\\"Id\\":\\"Cash\\",\\"Label\\":\\"Tiền mặt\\"}}}}","Surcharge":0,"Type":2,"Uuid":"{6}","addToAccount":"0","PayingAmount":0,"TotalBeforeDiscount":757500,"ProductDiscount":0}}}}    ${BRANCH_ID}    ${get_id_nguoitao}    ${get_id_nguoiban}    ${result_ggdh}    ${giamgia_dh}   ${liststring_prs_order_detail}    ${Uuid_code}
    Log    ${request_payload}
    ${order_code}    Post request to create order and return code    ${request_payload}
    Return From Keyword    ${order_code}

Add new order with multi products no customer
    [Arguments]    ${dict_product_nums}    ${input_khtt}
    ${Uuid}      Generate Random String    4    [NUMBERS][NUMBERS]
    ${Uuid_code}      Catenate      SEPARATOR=      WA     ${Uuid}
    ${list_product}    Get Dictionary Keys    ${dict_product_nums}
    ${list_nums}    Get Dictionary Values    ${dict_product_nums}
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${list_result_order_summary}    Get list result order summary frm product API    ${list_product}    ${list_nums}
    ${endpoint_danhmuc_hh_co_dvt}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${get_resp_danhmuc_hh}    Get Request and return body    ${endpoint_danhmuc_hh_co_dvt}
    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}    Get list jsonpath product frm list product    ${list_product}
    ${list_giaban}    ${list_id_sp}    Get product info frm list jsonpath product    ${get_resp_danhmuc_hh}    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}
    ${liststring_prs_order_detail}     Set Variable      needdel
    Log        ${liststring_prs_order_detail}
    : FOR    ${item_gia_ban}   ${item_id_sp}   ${item_soluong}    IN ZIP      ${list_giaban}        ${list_id_sp}    ${list_nums}
    \    ${payload_each_product}        Format string       {{"BasePrice":200000,"IsLotSerialControl":false,"IsRewardPoint":false,"Note":"","Price":{0},"ProductId":{1},"Quantity":{2},"ProductCode":"Combo05"}}     ${item_gia_ban}   ${item_id_sp}   ${item_soluong}
    \    ${liststring_prs_order_detail}       Catenate      SEPARATOR=,      ${liststring_prs_order_detail}      ${payload_each_product}
    ${liststring_prs_order_detail}       Replace String      ${liststring_prs_order_detail}       needdel,       ${EMPTY}      count=1
    #compute
    ${list_result_thanhtien}    Create List
    : FOR    ${item_giaban}    ${item_nums}    IN ZIP    ${list_giaban}    ${list_nums}
    \    ${result_thanhtien}    Multiplication with price round 2    ${item_giaban}    ${item_nums}
    \    Append To List    ${list_result_thanhtien}    ${result_thanhtien}
    ${result_tongtienhang}    Sum values in list    ${list_result_thanhtien}
    ${actuall_khtt}    Set Variable If    '${input_khtt}' == 'all'    ${result_tongtienhang}    ${input_khtt}
    ${request_payload}    Format String    {{"Order":{{"BranchId":{0},"RetailerId":{1},"SoldById":{2},"SoldBy":{{"CreatedBy":0,"CreatedDate":"2018-07-30T08:27:36.800Z","Email":"","GivenName":"anh.lv","Id":{2},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false}},"SaleChannelId":0,"Seller":{{"CreatedBy":0,"CreatedDate":"2018-07-30T08:27:36.800Z","Email":"","GivenName":"anh.lv","Id":{2},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false}},"Code":"Đặt hàng 1","OrderDetails":[{3}],"InvoiceOrderSurcharges":[],"Payments":[{{"Method":"Cash","MethodStr":"Tiền mặt","Amount":{4},"Id":-1}}],"UsingCod":0,"Status":1,"Total":757500,"Extra":"{{\\"Amount\\":60000,\\"Method\\":{{\\"Id\\":\\"Cash\\",\\"Label\\":\\"Tiền mặt\\"}}}}","Surcharge":0,"Type":2,"Uuid":"{5}","addToAccount":"0","PayingAmount":0,"TotalBeforeDiscount":757500,"ProductDiscount":0}}}}    ${BRANCH_ID}    ${get_id_nguoitao}    ${get_id_nguoiban}   ${liststring_prs_order_detail}    ${actuall_khtt}    ${Uuid_code}
    Log    ${request_payload}
    ${order_code}    Post request to create order and return code    ${request_payload}
    Assert list order summary in order api    ${list_product}    ${list_result_order_summary}
    Return From Keyword    ${order_code}

Add new order incase discount - payment - nocus and return order code
    [Arguments]    ${input_ggdh}    ${dict_product_nums}    ${list_ggsp}    ${list_discount_type}    ${input_khtt}
    #get product info
    ${Uuid}      Generate Random String    4    [NUMBERS][NUMBERS]
    ${Uuid_code}      Catenate      SEPARATOR=      WA     ${Uuid}
    ${list_product}     Get Dictionary Keys    ${dict_product_nums}
    ${list_soluong_sp}    Get Dictionary Values    ${dict_product_nums}
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${endpoint_danhmuc_hh_co_dvt}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${get_resp_danhmuc_hh}    Get Request and return body    ${endpoint_danhmuc_hh_co_dvt}
    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}    Get list jsonpath product frm list product    ${list_product}
    ${list_giaban}    ${list_result_ggsp}    ${list_id_sp}      ${list_thanhtien}    Get product info frm list jsonpath product incase discount product - return total sale    ${get_resp_danhmuc_hh}    ${list_jsonpath_id_sp}
    ...   ${list_jsonpath_giaban}    ${list_ggsp}    ${list_discount_type}    ${list_soluong_sp}
    #compute
    ${list_result_order_summary}    Get list result order summary frm product API    ${list_product}    ${list_soluong_sp}
    ${result_tongtienhang}    Sum values in list    ${list_thanhtien}
    ${giamgia_dh}    Set Variable If    0 < ${input_ggdh} < 100    ${input_ggdh}    0
    ${result_ggdh}    Run Keyword If    0 < ${input_ggdh} < 100    Convert % discount to VND    ${result_tongtienhang}    ${input_ggdh}
    ...    ELSE    Set Variable    ${input_ggdh}
    ${result_khtt}    Minus    ${result_tongtienhang}    ${result_ggdh}
    ${actual_khtt}    Set Variable If    '${input_khtt}' == 'all'    ${result_khtt}    ${input_khtt}
    #post request
    ${liststring_prs_order_detail}     Set Variable      needdel
    Log        ${liststring_prs_order_detail}
    : FOR    ${item_gia_ban}   ${item_id_sp}   ${item_soluong}    ${item_result_ggsp}   ${item_ggsp}      IN ZIP       ${list_giaban}        ${list_id_sp}    ${list_soluong_sp}       ${list_result_ggsp}       ${list_ggsp}
    \    ${item_ggsp}   Set Variable If    0 < ${item_ggsp} < 100    ${item_ggsp}   0
    \    ${payload_each_product}        Format string           {{"BasePrice":200000,"IsLotSerialControl":false,"IsRewardPoint":false,"Note":"","Price":{0},"ProductId":{1},"Quantity":{2},"Discount":{3},"DiscountRatio":{4},"ProductCode":"Combo05"}}    ${item_gia_ban}   ${item_id_sp}   ${item_soluong}    ${item_result_ggsp}   ${item_ggsp}
    \    ${liststring_prs_order_detail}       Catenate      SEPARATOR=,      ${liststring_prs_order_detail}      ${payload_each_product}
    ${liststring_prs_order_detail}       Replace String      ${liststring_prs_order_detail}       needdel,       ${EMPTY}      count=1
    ${request_payload}    Format String    {{"Order":{{"BranchId":{0},"RetailerId":{1},"SoldById":{2},"SoldBy":{{"CreatedBy":0,"CreatedDate":"2018-07-30T08:27:36.800Z","Email":"","GivenName":"anh.lv","Id":{2},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false}},"SaleChannelId":0,"Seller":{{"CreatedBy":0,"CreatedDate":"2018-07-30T08:27:36.800Z","Email":"","GivenName":"anh.lv","Id":{2},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false}},"Code":"Đặt hàng 1","Discount":{3},"DiscountRatio":{4},"OrderDetails":[{5}],"InvoiceOrderSurcharges":[],"Payments":[{{"Method":"Cash","MethodStr":"Tiền mặt","Amount":{6},"Id":-1}}],"UsingCod":0,"Status":1,"Total":757500,"Extra":"{{\\"Amount\\":0,\\"Method\\":{{\\"Id\\":\\"Cash\\",\\"Label\\":\\"Tiền mặt\\"}}}}","Surcharge":0,"Type":2,"Uuid":"{7}","addToAccount":"0","PayingAmount":0,"TotalBeforeDiscount":757500,"ProductDiscount":0}}}}    ${BRANCH_ID}    ${get_id_nguoitao}    ${get_id_nguoiban}    ${result_ggdh}    ${giamgia_dh}    ${liststring_prs_order_detail}    ${actual_khtt}    ${Uuid_code}
    Log    ${request_payload}
    ${order_code}    Post request to create order and return code    ${request_payload}
    ${list_order_summary_af_execute}    Get list order summary frm product API    ${list_product}
    : FOR    ${result_tong_dh}    ${order_summary_af_execute}    IN ZIP    ${list_result_order_summary}    ${list_order_summary_af_execute}
    \    Should Be Equal As Numbers    ${order_summary_af_execute}    ${result_tong_dh}
    Return From Keyword    ${order_code}

Add new order incase discount - method payment and return order code
    [Arguments]    ${input_ma_kh}    ${input_ggdh}    ${dict_product_nums}    ${list_ggsp}    ${input_khtt}   ${phuong_thuc}      ${so_tai_khoan}
    #get product info
    ${Uuid}      Generate Random String    4    [NUMBERS][NUMBERS]
    ${Uuid_code}      Catenate      SEPARATOR=      WA     ${Uuid}
    ${list_product}     Get Dictionary Keys    ${dict_product_nums}
    ${list_soluong_sp}    Get Dictionary Values    ${dict_product_nums}
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${get_id_kh}   Get customer id thr API    ${input_ma_kh}
    ${get_bank_acc_id}      Get bank account id    ${so_tai_khoan}
    ${get_method}     Run Keyword If    '${phuong_thuc}'=='Thẻ'     Set Variable      Card      ELSE IF    '${phuong_thuc}'=='Chuyển khoản'    Set Variable     Transfer     ELSE      Set Variable    Cash
    ${endpoint_danhmuc_hh_co_dvt}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${get_resp_danhmuc_hh}    Get Request and return body    ${endpoint_danhmuc_hh_co_dvt}
    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}    Get list jsonpath product frm list product    ${list_product}
    ${list_giaban}    ${list_result_ggsp}    ${list_id_sp}    Get product info frm list jsonpath product have discount product    ${get_resp_danhmuc_hh}    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}
    ...    ${list_ggsp}
    #compute
    ${list_result_order_summary}    Get list result order summary frm product API    ${list_product}    ${list_soluong_sp}
    ${list_thanhtien_hh}    Create List
    : FOR    ${giaban}    ${soluong}    ${item_ggsp}    IN ZIP    ${list_giaban}    ${list_soluong_sp}
    ...    ${list_ggsp}
    \    ${result_giaban_af_discount}    Run Keyword If    0 < ${item_ggsp} < 100    Price after % discount product    ${giaban}    ${item_ggsp}
    \    ...    ELSE IF    ${item_ggsp} > 100    Minus and round 2    ${giaban}    ${item_ggsp}
    \    ...    ELSE    Set Variable    ${giaban}
    \    ${result_item_thanhtien}    Multiplication and round    ${result_giaban_af_discount}    ${soluong}
    \    Append To List    ${list_thanhtien_hh}    ${result_item_thanhtien}
    Log    ${list_thanhtien_hh}
    ${result_tongtienhang}    Sum values in list    ${list_thanhtien_hh}
    ${giamgia_dh}    Set Variable If    0 < ${input_ggdh} < 100    ${input_ggdh}    0
    ${result_ggdh}    Run Keyword If    0 < ${input_ggdh} < 100    Convert % discount to VND    ${result_tongtienhang}    ${input_ggdh}
    ...    ELSE    Set Variable    ${input_ggdh}
    ${result_khtt}    Minus    ${result_tongtienhang}    ${result_ggdh}
    ${actual_khtt}    Set Variable If    '${input_khtt}' == 'all'    ${result_khtt}    ${input_khtt}
    #post request
    ${liststring_prs_order_detail}     Set Variable      needdel
    Log        ${liststring_prs_order_detail}
    : FOR    ${item_gia_ban}   ${item_id_sp}   ${item_soluong}    ${item_result_ggsp}   ${item_ggsp}      IN ZIP       ${list_giaban}        ${list_id_sp}    ${list_soluong_sp}       ${list_result_ggsp}       ${list_ggsp}
    \    ${item_ggsp}   Set Variable If    0 < ${item_ggsp} < 100    ${item_ggsp}   0
    \    ${payload_each_product}        Format string           {{"BasePrice":200000,"IsLotSerialControl":false,"IsRewardPoint":false,"Note":"","Price":{0},"ProductId":{1},"Quantity":{2},"Discount":{3},"DiscountRatio":{4},"ProductCode":"Combo05"}}    ${item_gia_ban}   ${item_id_sp}   ${item_soluong}    ${item_result_ggsp}   ${item_ggsp}
    \    ${liststring_prs_order_detail}       Catenate      SEPARATOR=,      ${liststring_prs_order_detail}      ${payload_each_product}
    ${liststring_prs_order_detail}       Replace String      ${liststring_prs_order_detail}       needdel,       ${EMPTY}      count=1
    ${request_payload}    Format String    {{"Order":{{"BranchId":{0},"RetailerId":{1},"CustomerId":{2},"SoldById":{3},"SoldBy":{{"CreatedBy":0,"CreatedDate":"2019-04-23T10:22:08.910Z","Email":"","GivenName":"admin","Id":{3},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false}},"SaleChannelId":0,"SaleChannel":null,"Seller":{{"CreatedBy":0,"CreatedDate":"2019-04-23T10:22:08.910Z","Email":"","GivenName":"admin","Id":{3},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false}},"Code":"Đặt hàng 1","Discount":{4},"DiscountRatio":{5},"OrderDetails":[{6}],"InvoiceOrderSurcharges":[],"Payments":[{{"Method":"{7}","MethodStr":"{8}","Amount":{9},"Id":-1,"AccountId":{10},"UsePoint":null}}],"UsingCod":0,"Status":1,"Total":215460,"Extra":"{{\\"Amount\\":{9},\\"Method\\":{{\\"Id\\":\\"Cash\\",\\"Label\\":\\"Tiền mặt\\"}},\\"ResetPromotion\\":false}}","Surcharge":0,"Type":2,"Uuid":"{11}","addToAccount":"0","PayingAmount":{9},"TotalBeforeDiscount":239400,"ProductDiscount":0,"CreatedBy":20447,"InvoiceWarranties":[]}}}}    ${BRANCH_ID}    ${get_id_nguoitao}    ${get_id_kh}    ${get_id_nguoiban}
    ...    ${result_ggdh}    ${giamgia_dh}    ${liststring_prs_order_detail}      ${get_method}     ${phuong_thuc}     ${actual_khtt}       ${get_bank_acc_id}    ${Uuid_code}
    Log    ${request_payload}
    ${order_code}    Post request to create order and return code    ${request_payload}
    Return From Keyword    ${order_code}

Add new order incase changing price - no payment
    [Arguments]   ${input_ma_kh}     ${input_ggdh}    ${dict_product_nums}    ${list_ggsp}    ${list_discount_type}
    #get product info
    ${Uuid}      Generate Random String    4    [NUMBERS][NUMBERS]
    ${Uuid_code}      Catenate      SEPARATOR=      WA     ${Uuid}
    ${list_product}   Get Dictionary Keys    ${dict_product_nums}
    ${list_soluong_sp}    Get Dictionary Values    ${dict_product_nums}
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${get_id_kh}     Get customer id thr API    ${input_ma_kh}
    ${endpoint_danhmuc_hh_co_dvt}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${get_resp}    Get Request and return body    ${endpoint_danhmuc_hh_co_dvt}
    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}    Get list jsonpath product frm list product    ${list_product}
    ${list_giaban}    ${list_result_ggsp}    ${list_id_sp}      ${list_thanhtien}    Get product info frm list jsonpath product incase discount product - return total sale    ${get_resp}    ${list_jsonpath_id_sp}
    ...   ${list_jsonpath_giaban}    ${list_ggsp}    ${list_discount_type}    ${list_soluong_sp}
    #compute
    ${result_tongtienhang}    Sum values in list    ${list_thanhtien}
    ${giamgia_dh}    Set Variable If    0 < ${input_ggdh} < 100    ${input_ggdh}    0
    ${result_ggdh}    Run Keyword If    0 < ${input_ggdh} < 100    Convert % discount to VND    ${result_tongtienhang}    ${input_ggdh}    ELSE    Set Variable    ${input_ggdh}
    #post request
    ${liststring_prs_order_detail}     Set Variable      needdel
    Log        ${liststring_prs_order_detail}
    : FOR    ${item_gia_ban}   ${item_id_sp}   ${item_soluong}    ${item_result_ggsp}   ${item_ggsp}      IN ZIP       ${list_giaban}        ${list_id_sp}    ${list_soluong_sp}       ${list_result_ggsp}       ${list_ggsp}
    \    ${item_ggsp}   Set Variable If    0 < ${item_ggsp} < 100    ${item_ggsp}   0
    \    ${payload_each_product}        Format string           {{"BasePrice":200000,"IsLotSerialControl":false,"IsRewardPoint":false,"Note":"","Price":{0},"ProductId":{1},"Quantity":{2},"Discount":{3},"DiscountRatio":{4},"ProductCode":"Combo05"}}    ${item_gia_ban}   ${item_id_sp}   ${item_soluong}    ${item_result_ggsp}   ${item_ggsp}
    \    ${liststring_prs_order_detail}       Catenate      SEPARATOR=,      ${liststring_prs_order_detail}      ${payload_each_product}
    ${liststring_prs_order_detail}       Replace String      ${liststring_prs_order_detail}       needdel,       ${EMPTY}      count=1
    ${request_payload}    Format String    {{"Order":{{"BranchId":{0},"RetailerId":{1},"CustomerId":{6},"SoldById":{2},"SoldBy":{{"CreatedBy":0,"CreatedDate":"2018-07-30T08:27:36.800Z","Email":"","GivenName":"anh.lv","Id":{2},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false}},"SaleChannelId":0,"Seller":{{"CreatedBy":0,"CreatedDate":"2018-07-30T08:27:36.800Z","Email":"","GivenName":"anh.lv","Id":{2},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false}},"Code":"Đặt hàng 1","Discount":{3},"DiscountRatio":{4},"OrderDetails":[{5}],"InvoiceOrderSurcharges":[],"Payments":[],"UsingCod":0,"Status":1,"Total":757500,"Extra":"{{\\"Amount\\":0,\\"Method\\":{{\\"Id\\":\\"Cash\\",\\"Label\\":\\"Tiền mặt\\"}}}}","Surcharge":0,"Type":2,"Uuid":"{7}","addToAccount":"0","PayingAmount":0,"TotalBeforeDiscount":757500,"ProductDiscount":0}}}}     ${BRANCH_ID}    ${get_id_nguoitao}    ${get_id_nguoiban}    ${result_ggdh}    ${giamgia_dh}  ${liststring_prs_order_detail}      ${get_id_kh}    ${Uuid_code}
    Log    ${request_payload}
    ${order_code}    Post request to create order and return code    ${request_payload}
    Return From Keyword    ${order_code}

Add new order with promotion buy every items at a fixed reduced price and not for all user
    [Arguments]    ${input_ma_kh}    ${dict_product_nums}    ${input_promotion}    ${input_khtt}    ${input_username}
    ${Uuid}      Generate Random String    4    [NUMBERS][NUMBERS]
    ${Uuid_code}      Catenate      SEPARATOR=      WA     ${Uuid}
    ${list_product}    Get Dictionary Keys    ${dict_product_nums}
    ${list_nums}    Get Dictionary Values    ${dict_product_nums}
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID by UserName    ${input_username}
    ${get_id_sale_promo}    ${get_id_promotion}    ${get_promo_discount}    Get promotion info    ${input_promotion}
    ${jsonpath_id_kh}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_kh}
    ${get_id_kh}    Get data from API    ${endpoint_khachhang}    ${jsonpath_id_kh}
    ${endpoint_danhmuc_hh_co_dvt}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${get_resp_danhmuc_hh}    Get Request and return body    ${endpoint_danhmuc_hh_co_dvt}
    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}    Get list jsonpath product frm list product    ${list_product}
    ${list_giaban}    ${list_id_sp}    Get product info frm list jsonpath product    ${get_resp_danhmuc_hh}    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}
    #post request
    ${liststring_prs_order_detail}     Set Variable      needdel
    Log        ${liststring_prs_order_detail}
    : FOR   ${item_gia_ban}   ${item_id_sp}   ${item_soluong}      IN ZIP   ${list_giaban}        ${list_id_sp}    ${list_nums}
    \    ${result_ggsp}   Convert % discount to VND and round    ${item_gia_ban}    ${get_promo_discount}
    \    ${payload_each_product}        Format string       {{"BasePrice":250000.5,"Discount":{0},"DiscountRatio":{1},"IsLotSerialControl":true,"IsRewardPoint":false,"Note":"","Price":{2},"ProductCode":"SIDEC001","ProductId":{3},"ProductName":"Điện thoại 1","PromotionParentProductId":{3},"PromotionParentType":1,"Quantity":{4},"SalePromotionId":{5},"Uuid":"","ProductBatchExpireId":null}}    ${result_ggsp}   ${get_promo_discount}   ${item_gia_ban}   ${item_id_sp}   ${item_soluong}   ${get_id_sale_promo}
    \    ${liststring_prs_order_detail}       Catenate      SEPARATOR=,      ${liststring_prs_order_detail}      ${payload_each_product}
    ${liststring_prs_order_detail}       Replace String      ${liststring_prs_order_detail}       needdel,       ${EMPTY}      count=1
    ${ma_hh}   Get From List    ${list_product}     0
    ${text_promo_info}    Set Variable If    '${ma_hh}' == 'DVL010'    KM theo HH hinh thuc gia ban theo SL mua GG %: Khi mua 3 DVL010 - Dịch vụ 10 giảm giá 20%     KM theo HH hình thức giá bán theo SL mua GG %: Khi mua 3 DVT34 Kẹo Hồng Sâm Vitamin Daegoung Food (chiếc) giảm giá 20%
    ${text_print_promo}    Set Variable If    '${ma_hh}' == 'DVL010'   Mua 3 Dịch vụ 10 được giảm giá 20.00% mỗi sản phẩm    Mua 3 Kẹo Hồng Sâm Vitamin Daegoung Food (chiếc) giảm giá 20%
    ${id_sp}   Get From List    ${list_id_sp}     0
    ${list_id_sp}   Convert list to string and return     ${list_id_sp}
    ${request_payload}    Format String    {{"Order":{{"BranchId":{0},"RetailerId":{1},"CustomerId":{2},"SoldById":{3},"SoldBy":{{"CreatedBy":0,"CreatedDate":"2018-07-30T08:27:36.800Z","Email":"","GivenName":"anh.lv","Id":{3},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false}},"SaleChannelId":0,"SaleChannel":null,"Seller":{{"CreatedBy":0,"CreatedDate":"2018-07-30T08:27:36.800Z","Email":"","GivenName":"anh.lv","Id":{3},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false}},"Code":"Đặt hàng 1","OrderDetails":[{4}],"InvoiceOrderSurcharges":[],"OrderPromotions":[{{"Type":8,"TargetType":1,"SalePromotionId":{5},"PromotionId":{6},"ProductId":{7},"ProductPrice":20,"ProductQty":2,"RelatedProductId":{7},"PromotionInfo":"{8}","PrintPromotionInfo":"{9}","RelatedProductIds":"{10}","RelatedCategoryIds":"680827","PromotionApplicationType":"%"}}],"Payments":[{{"Method":"Cash","MethodStr":"Tiền mặt","Amount":{11},"Id":-1}}],"UsingCod":0,"Status":1,"Total":200000,"Extra":"{{\\"Amount\\":100000,\\"Method\\":{{\\"Id\\":\\"Cash\\",\\"Label\\":\\"Tiền mặt\\"}},\\"ResetPromotion\\":false}}","Surcharge":0,"Type":2,"Uuid":"{12}","addToAccount":"0","PayingAmount":100000,"TotalBeforeDiscount":250001,"ProductDiscount":50000,"CreatedBy":201567,"InvoiceWarranties":[]}}}}    ${BRANCH_ID}    ${get_id_nguoitao}    ${get_id_kh}    ${get_id_nguoiban}
    ...    ${liststring_prs_order_detail}   ${get_id_sale_promo}    ${get_id_promotion}    ${id_sp}    ${text_promo_info}    ${text_print_promo}
    ...    ${list_id_sp}   ${input_khtt}    ${Uuid_code}
    Log    ${request_payload}
    ${order_code}    Post request to create order and return code    ${request_payload}
    Return From Keyword    ${order_code}

Add new order with price book frm API
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
    ${request_payload}    Format String   {{"Order":{{"BranchId":{0},"RetailerId":{1},"CustomerId":{2},"SoldById":{3},"SoldBy":{{"CreatedBy":0,"CreatedDate":"","Email":"","GivenName":"admin","Id":{3},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false}},"SaleChannelId":0,"SaleChannel":null,"Seller":{{"CreatedBy":0,"CreatedDate":"","Email":"","GivenName":"admin","Id":{3},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false}},"PricebookId":{4},"Code":"Đặt hàng 1","OrderDetails":[{{"BasePrice":112000,"IsLotSerialControl":false,"IsRewardPoint":false,"Note":"","Price":{5},"ProductCode":"TPC009","ProductId":{6},"ProductName":"Nước hoa Donna Bulgari","Quantity":{7},"Uuid":"{8}","OriginPrice":112000,"ProductBatchExpireId":null}}],"InvoiceOrderSurcharges":[],"Payments":[],"UsingCod":0,"Status":1,"Total":246400,"Extra":"{{\\"Amount\\":{9},\\"Method\\":{{\\"Id\\":\\"Cash\\",\\"Label\\":\\"Tiền mặt\\"}},\\"PriceBookId\\":{{\\"CommodityDisplayType\\":1,\\"CreatedBy\\":{3},\\"CreatedDate\\":\\"2020-03-09T10:16:33.283Z\\",\\"EndDate\\":\\"2021-03-09T10:16:10.710Z\\",\\"ForAllCusGroup\\":true,\\"Id\\":{4},\\"IsActive\\":true,\\"IsGlobal\\":true,\\"Name\\":\\"123\\",\\"PriceBookCustomerGroups\\":[],\\"RetailerId\\":{1},\\"StartDate\\":\\"2020-03-09T10:16:10.710Z\\",\\"isDeleted\\":false}},\\"ResetPromotion\\":false}}","Surcharge":0,"Type":2,"Uuid":"W158374902005875","addToAccount":"0","PayingAmount":{9},"TotalBeforeDiscount":224000,"ProductDiscount":0,"CreatedBy":{3},"InvoiceWarranties":[]}}}}     ${BRANCH_ID}    ${get_id_nguoitao}      ${get_id_kh}       ${get_id_nguoiban}   ${get_pb_id}   ${get_gia_ban}    ${get_id_sp}    ${input_soluong}    ${Uuid_code}    ${resull_khtt_all}
    Log    ${request_payload}
    ${order_code}    Post request to create order and return code    ${request_payload}
    Return From Keyword    ${order_code}

Add new order with discount order
    [Arguments]    ${input_ma_kh}   ${input_ggdh}    ${dict_product_nums}    ${input_khtt}
    ${Uuid}      Generate Random String    4    [NUMBERS][NUMBERS]
    ${Uuid_code}      Catenate      SEPARATOR=      WA     ${Uuid}
    ${list_product}    Get Dictionary Keys    ${dict_product_nums}
    ${list_nums}    Get Dictionary Values    ${dict_product_nums}
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${jsonpath_id_kh}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_kh}
    ${get_id_kh}    Get data from API    ${endpoint_khachhang}    ${jsonpath_id_kh}
    ${list_result_order_summary}    Get list result order summary frm product API    ${list_product}    ${list_nums}
    ${endpoint_danhmuc_hh_co_dvt}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${get_resp_danhmuc_hh}    Get Request and return body    ${endpoint_danhmuc_hh_co_dvt}
    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}    Get list jsonpath product frm list product    ${list_product}
    ${list_giaban}    ${list_id_sp}    Get product info frm list jsonpath product    ${get_resp_danhmuc_hh}    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}
    ${liststring_prs_order_detail}     Set Variable      needdel
    Log        ${liststring_prs_order_detail}
    : FOR    ${item_gia_ban}   ${item_id_sp}   ${item_soluong}    IN ZIP      ${list_giaban}        ${list_id_sp}    ${list_nums}
    \    ${payload_each_product}        Format string       {{"BasePrice":200000,"IsLotSerialControl":false,"IsRewardPoint":false,"Note":"","Price":{0},"ProductId":{1},"Quantity":{2},"ProductCode":"Combo05"}}     ${item_gia_ban}   ${item_id_sp}   ${item_soluong}
    \    ${liststring_prs_order_detail}       Catenate      SEPARATOR=,      ${liststring_prs_order_detail}      ${payload_each_product}
    ${liststring_prs_order_detail}       Replace String      ${liststring_prs_order_detail}       needdel,       ${EMPTY}      count=1
    #compute
    ${list_result_thanhtien}    Create List
    : FOR    ${item_giaban}    ${item_nums}    IN ZIP    ${list_giaban}    ${list_nums}
    \    ${result_thanhtien}    Multiplication with price round 2    ${item_giaban}    ${item_nums}
    \    Append To List    ${list_result_thanhtien}    ${result_thanhtien}
    ${result_tongtienhang}    Sum values in list    ${list_result_thanhtien}
    ${giamgia_dh}    Set Variable If    0 < ${input_ggdh} < 100    ${input_ggdh}    0
    ${result_ggdh}    Run Keyword If    0 < ${input_ggdh} < 100    Convert % discount to VND    ${result_tongtienhang}    ${input_ggdh}
    ...    ELSE    Set Variable    ${input_ggdh}
    ${result_khtt}    Minus    ${result_tongtienhang}    ${result_ggdh}
    ${actual_khtt}    Set Variable If    '${input_khtt}' == 'all'    ${result_khtt}    ${input_khtt}
    ${request_payload}    Format String    {{"Order":{{"BranchId":{0},"RetailerId":{1},"CustomerId":{2},"SoldById":{3},"SoldBy":{{"CreatedBy":0,"CreatedDate":"2018-07-30T08:27:36.800Z","Email":"","GivenName":"anh.lv","Id":{3},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false}},"SaleChannelId":0,"Seller":{{"CreatedBy":0,"CreatedDate":"2018-07-30T08:27:36.800Z","Email":"","GivenName":"anh.lv","Id":{3},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false}},"Code":"Đặt hàng 1","Discount":{4},"DiscountRatio":{5},"OrderDetails":[{6}],"InvoiceOrderSurcharges":[],"Payments":[{{"Method":"Cash","MethodStr":"Tiền mặt","Amount":{7},"Id":-1}}],"UsingCod":0,"Status":1,"Total":757500,"Extra":"{{\\"Amount\\":60000,\\"Method\\":{{\\"Id\\":\\"Cash\\",\\"Label\\":\\"Tiền mặt\\"}}}}","Surcharge":0,"Type":2,"Uuid":"{8}","addToAccount":"0","PayingAmount":0,"TotalBeforeDiscount":757500,"ProductDiscount":0}}}}    ${BRANCH_ID}    ${get_id_nguoitao}    ${get_id_kh}    ${get_id_nguoiban}
    ...    ${result_ggdh}    ${giamgia_dh}   ${liststring_prs_order_detail}    ${actual_khtt}    ${Uuid_code}
    Log    ${request_payload}
    ${order_code}    Post request to create order and return code    ${request_payload}
    Return From Keyword    ${order_code}
