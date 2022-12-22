*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    ${headless_browser}
Resource          ../../../../core/API/api_danhmuc_hanghoa.robot
Resource          ../../../../core/API/api_dathang.robot
Resource          ../../../../core/API/api_khachhang.robot
Resource          ../../../../core/API/api_mhbh.robot
Resource          ../../../../core/Dat_Hang/dat_hang_action.robot
Resource          ../../../../core/Dat_Hang/dat_hang_navigation.robot
Resource          ../../../../core/Dat_Hang/dat_hang_page.robot
Resource          ../../../../core/share/toast_message.robot
Resource          ../../../../core/API/api_soquy.robot
Resource          ../../../../core/share/javascript.robot
Resource          ../../../../core/share/discount.robot
Resource          ../../../../core/API/api_thietlap.robot
Resource          ../../../../core/API/api_mhbh_dathang.robot

*** Variables ***
&{list_product_tk01}    HH0058=2.5    SI041=2    DVT61=2.8    DV065=3    Combo42=1
&{list_product_tk02}    HH0059=5    SI042=2    DVT62=2.8    DV066=3    Combo43=1
@{discount}    20000    5    15000    30000.78      0
@{discount_type}    disvnd     dis    changedown      changeup    none

*** Test Cases ***    Mã KH         List product&nums       GGSP            List type                GGDH     Khách TT    Thu khac
Khongtudong_DH_1thukhac_GOLIVE
                      [Tags]        AEDTK
                      [Template]    edtk1_api
                      CTKH102       ${list_product_tk01}    ${discount}    ${discount_type}    50000    all         TK003
                      CTKH102       ${list_product_tk01}    ${discount}    ${discount_type}    50000    0           TK007

Khongtudong_DH_2thukhac
                      [Tags]        AEDTK
                      [Template]    edtk2_api
                      CTKH103       ${list_product_tk01}    ${discount}    ${discount_type}      30       all         TK007       TK008
                      CTKH103       ${list_product_tk01}    ${discount}    ${discount_type}      30       0           TK003       TK004
                      CTKH103       ${list_product_tk01}    ${discount}    ${discount_type}      30       50000       TK007       TK003

Tudong_DH_1thukhac    [Tags]        AEDTKA1
                      [Template]    edtka1_api
                      CTKH104       ${list_product_tk02}    ${discount}    ${discount_type}      15000    0           TK005
                      CTKH104       ${list_product_tk02}    ${discount}    ${discount_type}      15000    100000      TK001

Tudong_DH_2thukhac    [Tags]        AEDTKA
                      [Template]    edtka2_api
                      CTKH105       ${list_product_tk02}    ${discount}    ${discount_type}      15       all         TK001       TK002
                      CTKH105       ${list_product_tk02}    ${discount}    ${discount_type}      10       0           TK005       TK006
                      CTKH105       ${list_product_tk02}    ${discount}    ${discount_type}      5        20000       TK005       TK001

*** Keywords ***
edtk1_api
    [Arguments]    ${input_ma_kh}    ${dict_product_nums}    ${list_ggsp}    ${list_discount_type}    ${input_ggdh}    ${input_khtt}    ${input_thukhac}
    ##Activate surcharge
    ${surcharge_vnd_value}    Get surcharge vnd value    ${input_thukhac}
    ${surcharge_%}    Get surcharge percentage value    ${input_thukhac}
    Run Keyword If    ${surcharge_%} == 0    Toggle surcharge VND    ${input_thukhac}    true
    ...    ELSE    Toggle surcharge percentage    ${input_thukhac}    true
    #get info product, customer
    ${list_product}    Get Dictionary Keys    ${dict_product_nums}
    ${list_nums}    Get Dictionary Values    ${dict_product_nums}
    ${list_result_thanhtien}    ${list_result_order_summary}    ${list_result_giamoi}    Get list total sale - order summary - newprice incase discount and newprice    ${list_product}
    ...    ${list_nums}    ${list_ggsp}    ${list_discount_type}
    ${get_list_baseprice}    Get list of Baseprice by Product Code    ${list_product}
    #compute
    ${result_tongtienhang}    Sum values in list    ${list_result_thanhtien}
    ${actual_surcharge_type}    Set Variable If    ${surcharge_%} == 0    ${surcharge_vnd_value}    ${surcharge_%}
    ${result_af_invoice_discount}    Minus and replace floating point    ${result_tongtienhang}    ${input_ggdh}
    ${result_per_surchare_by_invoice}    Convert % discount to VND and round    ${result_af_invoice_discount}    ${surcharge_%}
    ${actual_surcharge_value}    Set Variable If    ${surcharge_%} == 0    ${surcharge_vnd_value}    ${result_per_surchare_by_invoice}
    ${result_khachcantra}    sum    ${result_af_invoice_discount}    ${actual_surcharge_value}
    ${result_khachcantra}    Replace floating point    ${result_khachcantra}
    ${actual_khtt_all}    Set Variable If    '${input_khtt}' == 'all'    ${result_khachcantra}    ${input_khtt}
    ${actual_khtt}    Set Variable If    '${input_khtt}' == '0'    0    ${actual_khtt_all}
    #create order by post api
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${get_id_thukhac}   ${get_thutu_thukhac}    Get Id and order surchage    ${input_thukhac}
    ${jsonpath_id_kh}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_kh}
    ${get_id_kh}    Get data from API    ${endpoint_khachhang}    ${jsonpath_id_kh}
    ${endpoint_danhmuc_hh_co_dvt}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${get_resp}    Get Request and return body    ${endpoint_danhmuc_hh_co_dvt}
    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}    Get list jsonpath product frm list product    ${list_product}
    ${list_giaban}    ${list_id_sp}    Get product info frm list jsonpath product    ${get_resp}    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}
    ${liststring_prs_order_detail}     Set Variable      needdel
    Log        ${liststring_prs_order_detail}
    : FOR    ${result_giamoi}    ${item_ggsp}    ${item_gia_ban}   ${item_id_sp}   ${item_soluong}      IN ZIP    ${list_result_giamoi}       ${list_ggsp}       ${list_giaban}        ${list_id_sp}    ${list_nums}
    \    ${item_ggsp}   Set Variable If    0 < ${item_ggsp} < 100    ${item_ggsp}   0
    \    ${payload_each_product}        Format string       {{"BasePrice":150000,"Discount":{0},"DiscountRatio":{1},"IsLotSerialControl":false,"IsRewardPoint":false,"Note":"","Price":{2},"ProductCode":"TP049","ProductId":{3},"ProductName":"Nước Hoa Jo Malone Sakura Cherry Blossom Limited Edition Cologne vial","Quantity":{4},"Uuid":"","ProductBatchExpireId":null}}    ${result_giamoi}    ${item_ggsp}     ${item_gia_ban}   ${item_id_sp}   ${item_soluong}
    \    ${liststring_prs_order_detail}       Catenate      SEPARATOR=,      ${liststring_prs_order_detail}      ${payload_each_product}
    ${liststring_prs_order_detail}       Replace String      ${liststring_prs_order_detail}       needdel,       ${EMPTY}      count=1
    ${request_payload}    Format String    {{"Order":{{"BranchId":{0},"RetailerId":{1},"CustomerId":{2},"SoldById":{3},"SoldBy":{{"CreatedBy":0,"CreatedDate":"2018-07-30T08:27:36.800Z","Email":"","GivenName":"anh.lv","Id":{3},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false}},"SaleChannelId":0,"Seller":{{"CreatedBy":0,"CreatedDate":"2018-07-30T08:27:36.800Z","Email":"","GivenName":"anh.lv","Id":{3},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false}},"Code":"Đặt hàng 1","Discount":{4},"OrderDetails":[{5}],"InvoiceOrderSurcharges":[{{"Code":"THK000001","Name":"Phí VAT","Price":{6},"RetailerId":{1},"SurValueRatio":{7},"SurchargeId":{8},"UsageFlag":true,"ValueRatio":5,"isAuto":true}}],"Payments":[{{"Method":"Cash","MethodStr":"Tiền mặt","Amount":{9},"Id":-1}}],"UsingCod":0,"Status":1,"Total":757500,"Extra":"{{\\"Amount\\":60000,\\"Method\\":{{\\"Id\\":\\"Cash\\",\\"Label\\":\\"Tiền mặt\\"}}}}","Surcharge":34900,"Type":2,"Uuid":"","addToAccount":"0","PayingAmount":0,"TotalBeforeDiscount":757500,"ProductDiscount":0}}}}      ${BRANCH_ID}    ${get_id_nguoitao}    ${get_id_kh}    ${get_id_nguoiban}
    ...   ${input_ggdh}    ${liststring_prs_order_detail}        ${actual_surcharge_value}    ${surcharge_%}    ${get_id_thukhac}    ${actual_khtt}
    Log    ${request_payload}
    ${order_code}    Post request to create order and return code    ${request_payload}
    #get values
    Sleep    20 s    wait for response to API
    #assert value product
    ${get_list_hh_in_dh_af_execute}    Get list product frm API    ${order_code}
    ${list_order_summary_af_execute}    Get list order summary frm product API    ${get_list_hh_in_dh_af_execute}
    : FOR    ${result_tong_dh}    ${order_summary_af_execute}    IN ZIP    ${list_result_order_summary}    ${list_order_summary_af_execute}
    \    Should Be Equal As Numbers    ${order_summary_af_execute}    ${result_tong_dh}
    #assert value order
    ${get_ma_kh_in_dh_af_execute}    ${get_TTDH_in_dh_af_execute}    ${get_tongtienhang_in_dh_af_execute}    ${get_khachdatra_in_dh_af_execute}    ${get_giamgia_in_dh_af_execute}    ${get_tongcong_in_dh_af_execute}    ${get_ghichu_in_dh_af_execute}    Get order info incase discount by order code
    ...    ${order_code}
    Should Be Equal As Strings    ${get_ma_kh_in_dh_af_execute}    ${input_ma_kh}
    Should Be Equal As Numbers    ${get_TTDH_in_dh_af_execute}    1    #1 : phiếu tạm
    Should Be Equal As Numbers    ${get_tongtienhang_in_dh_af_execute}    ${result_tongtienhang}
    Should Be Equal As Numbers    ${get_khachdatra_in_dh_af_execute}    ${actual_khtt}
    Should Be Equal As Numbers    ${get_giamgia_in_dh_af_execute}    ${input_ggdh}
    Should Be Equal As Numbers    ${get_tongcong_in_dh_af_execute}    ${result_khachcantra}
    Run Keyword If    ${surcharge_%} == 0    Toggle surcharge VND    ${input_thukhac}    false    ELSE    Toggle surcharge percentage    ${input_thukhac}    false
    Delete order frm Order code    ${order_code}

edtk2_api
    [Arguments]    ${input_ma_kh}    ${dict_product_nums}    ${list_ggsp}    ${list_discount_type}    ${input_ggdh}    ${input_khtt}    ${input_thukhac1}
    ...    ${input_thukhac2}
    #activate surcharge
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
    #get info product, customer
    ${list_product}    Get Dictionary Keys    ${dict_product_nums}
    ${list_nums}    Get Dictionary Values    ${dict_product_nums}
    ${list_result_thanhtien}    ${list_result_order_summary}    ${list_result_giamoi}    Get list total sale - order summary - newprice incase discount and newprice    ${list_product}
    ...    ${list_nums}    ${list_ggsp}    ${list_discount_type}
    ${get_list_baseprice}    Get list of Baseprice by Product Code    ${list_product}
    #compute
    ${result_tongtienhang}    Sum values in list    ${list_result_thanhtien}
    ${result_ggdh}    Convert % discount to VND and round    ${result_tongtienhang}    ${input_ggdh}
    ${result_af_invoice_discount}    Price after % discount invoice    ${result_tongtienhang}    ${input_ggdh}
    ${total_surcharge}=    Run Keyword If    ${actual_surcharge1_value} > 100 and ${actual_surcharge2_value} > 100    Sum    ${actual_surcharge1_value}    ${actual_surcharge2_value}
    ...    ELSE IF    ${actual_surcharge1_value} > 100 and ${actual_surcharge2_value} < 100    VND and Percentage Surcharges sum    ${actual_surcharge2_value}    ${result_af_invoice_discount}    ${actual_surcharge1_value}
    ...    ELSE IF    ${actual_surcharge1_value} < 100 and ${actual_surcharge2_value} < 100    Percentage and Percentage Surcharges sum    ${result_af_invoice_discount}    ${actual_surcharge1_value}    ${actual_surcharge2_value}
    ...    ELSE    Log    abv
    ${result_khachcantra}    Sum    ${result_af_invoice_discount}    ${total_surcharge}
    ${result_khachcantra}    Replace floating point    ${result_khachcantra}
    ${actual_khtt_all}    Set Variable If    '${input_khtt}' == 'all'    ${result_khachcantra}    ${input_khtt}
    ${actual_khtt}    Set Variable If    '${input_khtt}' == '0'    0    ${actual_khtt_all}
    #create data by post request
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${get_id_thukhac1}    ${get_thutu_thukhac1}    Get Id and order surchage    ${input_thukhac1}
    ${get_id_thukhac2}    ${get_thutu_thukhac2}    Get Id and order surchage    ${input_thukhac2}
    ${jsonpath_id_kh}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_kh}
    ${get_id_kh}    Get data from API    ${endpoint_khachhang}    ${jsonpath_id_kh}
    ${endpoint_danhmuc_hh_co_dvt}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${get_resp}    Get Request and return body    ${endpoint_danhmuc_hh_co_dvt}
    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}    Get list jsonpath product frm list product    ${list_product}
    ${list_giaban}    ${list_id_sp}    Get product info frm list jsonpath product    ${get_resp}    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}
    #post request
    ${liststring_prs_order_detail}     Set Variable      needdel
    Log        ${liststring_prs_order_detail}
    : FOR    ${item_result_ggsp}   ${item_ggsp}  ${item_gia_ban}   ${item_id_sp}   ${item_soluong}      IN ZIP    ${list_result_giamoi}   ${list_ggsp}   ${list_giaban}    ${list_id_sp}  ${list_nums}
    \    ${item_ggsp}   Set Variable If    0 < ${item_ggsp} < 100    ${item_ggsp}   0
    \    ${payload_each_product}        Format string       {{"BasePrice":150000,"Discount":{0},"DiscountRatio":{1},"IsLotSerialControl":false,"IsRewardPoint":false,"Note":"","Price":{2},"ProductCode":"TP049","ProductId":{3},"ProductName":"Nước Hoa Jo Malone Sakura Cherry Blossom Limited Edition Cologne vial","Quantity":{4},"Uuid":"","ProductBatchExpireId":null}}    ${item_result_ggsp}         ${item_ggsp}     ${item_gia_ban}   ${item_id_sp}   ${item_soluong}
    \    ${liststring_prs_order_detail}       Catenate      SEPARATOR=,      ${liststring_prs_order_detail}      ${payload_each_product}
    ${liststring_prs_order_detail}       Replace String      ${liststring_prs_order_detail}       needdel,       ${EMPTY}      count=1
    ${giamgia_dh}    Set Variable If    0 < ${input_ggdh} < 100    ${input_ggdh}    0
    ${actual_key_surcharge1}    Set Variable If   ${actual_surcharge1_value} > 100    SurValue    SurValueRatio
    ${actual_key_surcharge2}    Set Variable If   ${actual_surcharge2_value} > 100    SurValue    SurValueRatio
    ${actual_value_surcharge1}  Run Keyword If    0 < ${actual_surcharge1_value} < 100   Convert % discount to VND and round    ${result_af_invoice_discount}    ${actual_surcharge1_value}    ELSE   Set Variable    ${actual_surcharge1_value}
    ${actual_value_surcharge2}  Run Keyword If    0 < ${actual_surcharge2_value} < 100   Convert % discount to VND and round    ${result_af_invoice_discount}    ${actual_surcharge2_value}    ELSE   Set Variable    ${actual_surcharge1_value}
    ${request_payload}    Format String     {{"Order":{{"BranchId":{0},"RetailerId":{1},"CustomerId":{2},"SoldById":{3},"SoldBy":{{"CreatedBy":0,"CreatedDate":"2018-07-30T08:27:36.800Z","Email":"","GivenName":"anh.lv","Id":{3},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false}},"SaleChannelId":0,"Seller":{{"CreatedBy":0,"CreatedDate":"2018-07-30T08:27:36.800Z","Email":"","GivenName":"anh.lv","Id":{3},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false}},"Code":"Đặt hàng 1","Discount":{4},"DiscountRatio":{5},"OrderDetails":[{6}],"InvoiceOrderSurcharges":[{{"Code":"THK000001","Name":"Phí VAT","Price":{7},"RetailerId":{1},"{8}":{9},"SurchargeId":{10},"UsageFlag":true,"ValueRatio":5,"isAuto":true}},{{"Code":"THK000001","Name":"Phí VAT","Price":{11},"RetailerId":{1},"{12}":{13},"SurchargeId":{14},"UsageFlag":true,"ValueRatio":5,"isAuto":true}}],"Payments":[{{"Method":"Cash","MethodStr":"Tiền mặt","Amount":{15},"Id":-1}}],"UsingCod":0,"Status":1,"Total":757500,"Extra":"{{\\"Amount\\":60000,\\"Method\\":{{\\"Id\\":\\"Cash\\",\\"Label\\":\\"Tiền mặt\\"}}}}","Surcharge":34900,"Type":2,"Uuid":"","addToAccount":"0","PayingAmount":0,"TotalBeforeDiscount":757500,"ProductDiscount":0}}}}    ${BRANCH_ID}    ${get_id_nguoitao}    ${get_id_kh}    ${get_id_nguoiban}
    ...    ${result_ggdh}    ${giamgia_dh}    ${liststring_prs_order_detail}    ${actual_value_surcharge1}    ${actual_key_surcharge1}    ${actual_surcharge1_value}    ${get_id_thukhac1}
    ...    ${actual_value_surcharge2}    ${actual_key_surcharge2}    ${actual_surcharge2_value}    ${get_id_thukhac2}    ${input_khtt}
    Log    ${request_payload}
    ${order_code}    Post request to create order and return code    ${request_payload}
    #get values
    Sleep    20 s    wait for response to API
    #assert value product
    ${get_list_hh_in_dh_af_execute}    Get list product frm API    ${order_code}
    ${list_order_summary_af_execute}    Get list order summary frm product API    ${get_list_hh_in_dh_af_execute}
    : FOR    ${result_tong_dh}    ${order_summary_af_execute}    IN ZIP    ${list_result_order_summary}    ${list_order_summary_af_execute}
    \    Should Be Equal As Numbers    ${order_summary_af_execute}    ${result_tong_dh}
    #assert value order
    ${get_ma_kh_in_dh_af_execute}    ${get_TTDH_in_dh_af_execute}    ${get_tongtienhang_in_dh_af_execute}    ${get_khachdatra_in_dh_af_execute}    ${get_giamgia_in_dh_af_execute}    ${get_tongcong_in_dh_af_execute}    ${get_ghichu_in_dh_af_execute}    Get order info incase discount by order code
    ...    ${order_code}
    Should Be Equal As Strings    ${get_ma_kh_in_dh_af_execute}    ${input_ma_kh}
    Should Be Equal As Numbers    ${get_TTDH_in_dh_af_execute}    1    #1 : phiếu tạm
    Should Be Equal As Numbers    ${get_tongtienhang_in_dh_af_execute}    ${result_tongtienhang}
    Should Be Equal As Numbers    ${get_khachdatra_in_dh_af_execute}    ${actual_khtt}
    Should Be Equal As Numbers    ${get_giamgia_in_dh_af_execute}    ${result_ggdh}
    Should Be Equal As Numbers    ${get_tongcong_in_dh_af_execute}    ${result_khachcantra}
    ## Deactivate surcharge
    Run Keyword If    ${actual_surcharge1_value} > 100    Toggle surcharge VND    ${input_thukhac1}    false
    ...    ELSE    Toggle surcharge percentage    ${input_thukhac1}    false
    Run Keyword If    ${actual_surcharge2_value} > 100    Toggle surcharge VND    ${input_thukhac2}    false
    ...    ELSE    Toggle surcharge percentage    ${input_thukhac2}    false
    Delete order frm Order code    ${order_code}

edtka1_api
    [Arguments]    ${input_ma_kh}    ${dict_product_nums}    ${list_ggsp}    ${list_discount_type}    ${input_ggdh}    ${input_khtt}    ${input_thukhac}
    #get info product, customer
    ${surcharge_vnd_value}    Get surcharge vnd value    ${input_thukhac}
    ${surcharge_%}    Get surcharge percentage value    ${input_thukhac}
    Run Keyword If    ${surcharge_%} == 0    Toggle surcharge VND    ${input_thukhac}    true
    ...    ELSE    Toggle surcharge percentage    ${input_thukhac}    true
    ${list_product}    Get Dictionary Keys    ${dict_product_nums}
    ${list_nums}    Get Dictionary Values    ${dict_product_nums}
    ${list_result_thanhtien}    ${list_result_order_summary}    ${list_result_giamoi}    Get list total sale - order summary - newprice incase discount and newprice    ${list_product}
    ...    ${list_nums}    ${list_ggsp}    ${list_discount_type}
    #compute
    ${result_tongtienhang}    Sum values in list    ${list_result_thanhtien}
    ${actual_surcharge_type}    Set Variable If    ${surcharge_%} == 0    ${surcharge_vnd_value}    ${surcharge_%}
    ${result_af_invoice_discount}    Minus and replace floating point    ${result_tongtienhang}    ${input_ggdh}
    ${result_per_surchare_by_invoice}    Convert % discount to VND and round    ${result_af_invoice_discount}    ${surcharge_%}
    ${actual_surcharge_value}    Set Variable If    ${surcharge_%} == 0    ${surcharge_vnd_value}    ${result_per_surchare_by_invoice}
    ${result_khachcantra}    sum    ${result_af_invoice_discount}    ${actual_surcharge_value}
    ${result_khachcantra}    Replace floating point    ${result_khachcantra}
    ${actual_khtt_all}    Set Variable If    '${input_khtt}' == 'all'    ${result_khachcantra}    ${input_khtt}
    ${actual_khtt}    Set Variable If    '${input_khtt}' == '0'    0    ${actual_khtt_all}
    #create order by post api
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${get_id_thukhac}   ${get_thutu_thukhac}    Get Id and order surchage    ${input_thukhac}
    ${jsonpath_id_kh}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_kh}
    ${get_id_kh}    Get data from API    ${endpoint_khachhang}    ${jsonpath_id_kh}
    ${endpoint_danhmuc_hh_co_dvt}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${get_resp_danhmuc_hh}    Get Request and return body    ${endpoint_danhmuc_hh_co_dvt}
    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}    Get list jsonpath product frm list product    ${list_product}
    ${list_giaban}    ${list_id_sp}    Get product info frm list jsonpath product    ${get_resp}    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}
    ${surcharge}    Set Variable If    '${surcharge_%}' != '0'    ${surcharge_%}    ${surcharge_vnd_value}
    #post request
    ${liststring_prs_order_detail}     Set Variable      needdel
    Log        ${liststring_prs_order_detail}
    : FOR   ${result_giamoi}    ${item_ggsp}    ${item_gia_ban}   ${item_id_sp}   ${item_soluong}      IN ZIP   ${list_result_giamoi}    ${list_ggsp}   ${list_giaban}
    ...        ${list_id_sp}    ${list_nums}
    \    ${item_ggsp}   Set Variable If    0 < ${item_ggsp} < 100    ${item_ggsp}   0
    \    ${payload_each_product}        Format string       {{"BasePrice":150000,"Discount":{0},"DiscountRatio":{1},"IsLotSerialControl":false,"IsRewardPoint":false,"Note":"","Price":{2},"ProductCode":"TP049","ProductId":{3},"ProductName":"Nước Hoa Jo Malone Sakura Cherry Blossom Limited Edition Cologne vial","Quantity":{4},"Uuid":"","ProductBatchExpireId":null}}   ${result_giamoi}    ${item_ggsp}     ${item_gia_ban}   ${item_id_sp}   ${item_soluong}
    \    ${liststring_prs_order_detail}       Catenate      SEPARATOR=,      ${liststring_prs_order_detail}      ${payload_each_product}
    ${liststring_prs_order_detail}       Replace String      ${liststring_prs_order_detail}       needdel,       ${EMPTY}      count=1
    ${request_payload}    Format String    {{"Order":{{"BranchId":{0},"RetailerId":{1},"CustomerId":{2},"SoldById":{3},"SoldBy":{{"CreatedBy":0,"CreatedDate":"2018-07-30T08:27:36.800Z","Email":"","GivenName":"anh.lv","Id":{3},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false}},"SaleChannelId":0,"Seller":{{"CreatedBy":0,"CreatedDate":"2018-07-30T08:27:36.800Z","Email":"","GivenName":"anh.lv","Id":{3},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false}},"Code":"Đặt hàng 1","Discount":{4},"OrderDetails":[{5}],"InvoiceOrderSurcharges":[{{"Code":"THK000001","Name":"Phí VAT","Price":{6},"RetailerId":{1},"SurValueRatio":{7},"SurchargeId":{8},"UsageFlag":true,"ValueRatio":5,"isAuto":true}}],"Payments":[{{"Method":"Cash","MethodStr":"Tiền mặt","Amount":{9},"Id":-1}}],"UsingCod":0,"Status":1,"Total":757500,"Extra":"{{\\"Amount\\":60000,\\"Method\\":{{\\"Id\\":\\"Cash\\",\\"Label\\":\\"Tiền mặt\\"}}}}","Surcharge":34900,"Type":2,"Uuid":"","addToAccount":"0","PayingAmount":0,"TotalBeforeDiscount":757500,"ProductDiscount":0}}}}      ${BRANCH_ID}    ${get_id_nguoitao}    ${get_id_kh}    ${get_id_nguoiban}
    ...   ${input_ggdh}    ${liststring_prs_order_detail}        ${actual_surcharge_value}    ${surcharge}    ${get_id_thukhac}    ${actual_khtt}
    Log    ${request_payload}
    ${order_code}    Post request to create order and return code    ${request_payload}
    #get values
    Sleep    20 s    wait for response to API
    #assert value product
    ${get_list_hh_in_dh_af_execute}    Get list product frm API    ${order_code}
    ${list_order_summary_af_execute}    Get list order summary frm product API    ${get_list_hh_in_dh_af_execute}
    : FOR    ${result_tong_dh}    ${order_summary_af_execute}    IN ZIP    ${list_result_order_summary}    ${list_order_summary_af_execute}
    \    Should Be Equal As Numbers    ${order_summary_af_execute}    ${result_tong_dh}
    #assert value order
    ${get_ma_kh_in_dh_af_execute}    ${get_TTDH_in_dh_af_execute}    ${get_tongtienhang_in_dh_af_execute}    ${get_khachdatra_in_dh_af_execute}    ${get_giamgia_in_dh_af_execute}    ${get_tongcong_in_dh_af_execute}    ${get_ghichu_in_dh_af_execute}    Get order info incase discount by order code
    ...    ${order_code}
    Should Be Equal As Strings    ${get_ma_kh_in_dh_af_execute}    ${input_ma_kh}
    Should Be Equal As Numbers    ${get_TTDH_in_dh_af_execute}    1    #1 : phiếu tạm
    Should Be Equal As Numbers    ${get_tongtienhang_in_dh_af_execute}    ${result_tongtienhang}
    Should Be Equal As Numbers    ${get_khachdatra_in_dh_af_execute}    ${actual_khtt}
    Should Be Equal As Numbers    ${get_giamgia_in_dh_af_execute}    ${input_ggdh}
    Should Be Equal As Numbers    ${get_tongcong_in_dh_af_execute}    ${result_khachcantra}
    Run Keyword If    ${surcharge_%} == 0    Toggle surcharge VND    ${input_thukhac}    false
    ...    ELSE    Toggle surcharge percentage    ${input_thukhac}    false
    Delete order frm Order code    ${order_code}

edtka2_api
    [Arguments]    ${input_ma_kh}    ${dict_product_nums}    ${list_ggsp}    ${list_discount_type}    ${input_ggdh}    ${input_khtt}    ${input_thukhac1}
    ...    ${input_thukhac2}
    #activate surcharge
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
    #get info product, customer
    ${list_product}    Get Dictionary Keys    ${dict_product_nums}
    ${list_nums}    Get Dictionary Values    ${dict_product_nums}
    ${list_result_thanhtien}    ${list_result_order_summary}    ${list_result_giamoi}    Get list total sale - order summary - newprice incase discount and newprice    ${list_product}
    ...    ${list_nums}    ${list_ggsp}    ${list_discount_type}
    #compute
    ${result_tongtienhang}    Sum values in list    ${list_result_thanhtien}
    ${result_ggdh}    Convert % discount to VND and round    ${result_tongtienhang}    ${input_ggdh}
    ${result_af_invoice_discount}    Price after % discount invoice    ${result_tongtienhang}    ${input_ggdh}
    ${total_surcharge}=    Run Keyword If    ${actual_surcharge1_value} > 100 and ${actual_surcharge2_value} > 100    Sum    ${actual_surcharge1_value}    ${actual_surcharge2_value}
    ...    ELSE IF    ${actual_surcharge1_value} > 100 and ${actual_surcharge2_value} < 100    VND and Percentage Surcharges sum    ${actual_surcharge2_value}    ${result_af_invoice_discount}    ${actual_surcharge1_value}
    ...    ELSE IF    ${actual_surcharge1_value} < 100 and ${actual_surcharge2_value} < 100    Percentage and Percentage Surcharges sum    ${result_af_invoice_discount}    ${actual_surcharge1_value}    ${actual_surcharge2_value}
    ...    ELSE    Log    abv
    ${result_khachcantra}    Sum    ${result_af_invoice_discount}    ${total_surcharge}
    ${result_khachcantra}    Replace floating point    ${result_khachcantra}
    ${actual_khtt_all}    Set Variable If    '${input_khtt}' == 'all'    ${result_khachcantra}    ${input_khtt}
    ${actual_khtt}    Set Variable If    '${input_khtt}' == '0'    0    ${actual_khtt_all}
    #create data by post request
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${get_id_thukhac1}    ${get_thutu_thukhac1}    Get Id and order surchage    ${input_thukhac1}
    ${get_id_thukhac2}    ${get_thutu_thukhac2}    Get Id and order surchage    ${input_thukhac2}
    ${jsonpath_id_kh}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_kh}
    ${get_id_kh}    Get data from API    ${endpoint_khachhang}    ${jsonpath_id_kh}
    ${endpoint_danhmuc_hh_co_dvt}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${get_resp_danhmuc_hh}    Get Request and return body    ${endpoint_danhmuc_hh_co_dvt}
    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}    Get list jsonpath product frm list product    ${list_product}
    ${list_giaban}    ${list_id_sp}    Get product info frm list jsonpath product    ${get_resp}    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}
    #post request
    ${liststring_prs_order_detail}     Set Variable      needdel
    Log        ${liststring_prs_order_detail}
    :FOR   ${result_giamoi}    ${item_ggsp}    ${item_gia_ban}   ${item_id_sp}   ${item_soluong}      IN ZIP   ${list_result_giamoi}    ${list_ggsp}   ${list_giaban}    ${list_id_sp}  ${list_nums}
    \    ${item_ggsp}   Set Variable If    0 < ${item_ggsp} < 100    ${item_ggsp}   0
    \    ${payload_each_product}        Format string       {{"BasePrice":150000,"Discount":{0},"DiscountRatio":{1},"IsLotSerialControl":false,"IsRewardPoint":false,"Note":"","Price":{2},"ProductCode":"TP049","ProductId":{3},"ProductName":"Nước Hoa Jo Malone Sakura Cherry Blossom Limited Edition Cologne vial","Quantity":{4},"Uuid":"","ProductBatchExpireId":null}}   ${result_giamoi}    ${item_ggsp}     ${item_gia_ban}   ${item_id_sp}   ${item_soluong}
    \    ${liststring_prs_order_detail}       Catenate      SEPARATOR=,      ${liststring_prs_order_detail}      ${payload_each_product}
    ${liststring_prs_order_detail}       Replace String      ${liststring_prs_order_detail}       needdel,       ${EMPTY}      count=1
    ${giamgia_dh}    Set Variable If    0 < ${input_ggdh} < 100    ${input_ggdh}    0
    ${actual_key_surcharge1}    Set Variable If   ${actual_surcharge1_value} > 100    SurValue    SurValueRatio
    ${actual_key_surcharge2}    Set Variable If   ${actual_surcharge2_value} > 100    SurValue    SurValueRatio
    ${actual_value_surcharge1}  Run Keyword If    0 < ${actual_surcharge1_value} < 100   Convert % discount to VND and round    ${result_af_invoice_discount}    ${actual_surcharge1_value}    ELSE   Set Variable    ${actual_surcharge1_value}
    ${actual_value_surcharge2}  Run Keyword If    0 < ${actual_surcharge2_value} < 100   Convert % discount to VND and round    ${result_af_invoice_discount}    ${actual_surcharge2_value}    ELSE   Set Variable    ${actual_surcharge1_value}
    ${request_payload}    Format String     {{"Order":{{"BranchId":{0},"RetailerId":{1},"CustomerId":{2},"SoldById":{3},"SoldBy":{{"CreatedBy":0,"CreatedDate":"2018-07-30T08:27:36.800Z","Email":"","GivenName":"anh.lv","Id":{3},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false}},"SaleChannelId":0,"Seller":{{"CreatedBy":0,"CreatedDate":"2018-07-30T08:27:36.800Z","Email":"","GivenName":"anh.lv","Id":{3},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false}},"Code":"Đặt hàng 1","Discount":{4},"DiscountRatio":{5},"OrderDetails":[{6}],"InvoiceOrderSurcharges":[{{"Code":"THK000001","Name":"Phí VAT","Price":{7},"RetailerId":{1},"{8}":{9},"SurchargeId":{10},"UsageFlag":true,"ValueRatio":5,"isAuto":true}},{{"Code":"THK000001","Name":"Phí VAT","Price":{11},"RetailerId":{1},"{12}":{13},"SurchargeId":{14},"UsageFlag":true,"ValueRatio":5,"isAuto":true}}],"Payments":[{{"Method":"Cash","MethodStr":"Tiền mặt","Amount":{15},"Id":-1}}],"UsingCod":0,"Status":1,"Total":757500,"Extra":"{{\\"Amount\\":60000,\\"Method\\":{{\\"Id\\":\\"Cash\\",\\"Label\\":\\"Tiền mặt\\"}}}}","Surcharge":34900,"Type":2,"Uuid":"","addToAccount":"0","PayingAmount":0,"TotalBeforeDiscount":757500,"ProductDiscount":0}}}}    ${BRANCH_ID}    ${get_id_nguoitao}    ${get_id_kh}    ${get_id_nguoiban}
    ...    ${result_ggdh}    ${giamgia_dh}    ${liststring_prs_order_detail}    ${actual_value_surcharge1}    ${actual_key_surcharge1}    ${actual_surcharge1_value}    ${get_id_thukhac1}
    ...    ${actual_value_surcharge2}    ${actual_key_surcharge2}    ${actual_surcharge2_value}    ${get_id_thukhac2}    ${actual_khtt}
    Log    ${request_payload}
    ${order_code}    Post request to create order and return code    ${request_payload}
    #get values
    Sleep    20 s    wait for response to API
    #assert value product
    ${get_list_hh_in_dh_af_execute}    Get list product frm API    ${order_code}
    ${list_order_summary_af_execute}    Get list order summary frm product API    ${get_list_hh_in_dh_af_execute}
    : FOR    ${result_tong_dh}    ${order_summary_af_execute}    IN ZIP    ${list_result_order_summary}    ${list_order_summary_af_execute}
    \    Should Be Equal As Numbers    ${order_summary_af_execute}    ${result_tong_dh}
    #assert value order
    ${get_ma_kh_in_dh_af_execute}    ${get_TTDH_in_dh_af_execute}    ${get_tongtienhang_in_dh_af_execute}    ${get_khachdatra_in_dh_af_execute}    ${get_giamgia_in_dh_af_execute}    ${get_tongcong_in_dh_af_execute}    ${get_ghichu_in_dh_af_execute}    Get order info incase discount by order code
    ...    ${order_code}
    Should Be Equal As Strings    ${get_ma_kh_in_dh_af_execute}    ${input_ma_kh}
    Should Be Equal As Numbers    ${get_TTDH_in_dh_af_execute}    1    #1 : phiếu tạm
    Should Be Equal As Numbers    ${get_tongtienhang_in_dh_af_execute}    ${result_tongtienhang}
    Should Be Equal As Numbers    ${get_khachdatra_in_dh_af_execute}    ${actual_khtt}
    Should Be Equal As Numbers    ${get_giamgia_in_dh_af_execute}    ${result_ggdh}
    Should Be Equal As Numbers    ${get_tongcong_in_dh_af_execute}    ${result_khachcantra}
    ## Deactivate surcharge
    Run Keyword If    ${actual_surcharge1_value} > 100    Toggle surcharge VND    ${input_thukhac1}    false
    ...    ELSE    Toggle surcharge percentage    ${input_thukhac1}    false
    Run Keyword If    ${actual_surcharge2_value} > 100    Toggle surcharge VND    ${input_thukhac2}    false
    ...    ELSE    Toggle surcharge percentage    ${input_thukhac2}    false
