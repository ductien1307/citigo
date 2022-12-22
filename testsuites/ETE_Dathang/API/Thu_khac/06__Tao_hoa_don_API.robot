*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    ${headless_browser}
Test Setup
Test Teardown     After Test
Resource          ../../../../core/API/api_mhbh_dathang.robot
Resource          ../../../../core/API/api_mhbh.robot
Resource          ../../../../core/Dat_Hang/dat_hang_action.robot
Resource          ../../../../core/API/api_soquy.robot
Library           BuiltIn
Resource          ../../../../core/share/toast_message.robot

*** Variables ***
&{list_product_tk04}    HH0061=5    SI044=2    DVT64=3.5    DV068=1    Combo45=2.5    QDBTT07=3
&{list_product_tk05}    HH0062=5    SI045=1    DVT65=3.5    DV069=2    Combo46=1.8
&{list_product_tk06}    HH0063=5    SI046=2    DVT66=3.5    DV070=1    Combo48=3
&{list_product_tk07}    HH0064=5.6    SI047=1    DVT67=1.75    DV071=2    Combo49=3
@{list_product_delete_01}    HH0061    SI044    DVT64
@{list_product_delete02}    SI045    DV069    DVT65
@{list_product_delete03}    SI046    HH0063    Combo48
&{serial}       SI047=2
@{list_giamoi04}    30000    100000    50000    200000    180000
@{list_%_ggsp1}    5    10
@{list_vnd_ggsp}    1000    2000    3000

*** Test Cases ***    Mã KH              GGDH                 Mã thu khác    Khách thanh toán            List product
Khongtudong_BH_1thukhac
                      [Documentation]    1. Xử lý đặt hàng > Tạo hóa đơn cho đơn hàng được tạo qua API có giảm giá đặt hàng \n2. Thu khác không đc tự động đưa vào hóa đơn và đơn hàng có 1 thu khác \n3. Validate hàng hóa, công nợ khách hàng, sổ quỹ\n
                      [Tags]             AEDTK
                      [Setup]
                      [Template]         etedh_tk1_api
                      CTKH107            50000            TK004          0       ${list_product_delete_01}    ${list_product_tk04}

Khongtudong_BH_2thukhac
                      [Documentation]    1. Xử lý đặt hàng > Tạo hóa đơn cho đơn hàng được tạo qua API có giảm giá sản phẩm và không hoàn trả tạm ứng\n2. Thu khác không đc tự động đưa vào hóa đơn và đơn hàng có 2 thu khác \n3. Validate hàng hóa, công nợ khách hàng, sổ quỹ\n
                      [Tags]             AEDTK
                      [Setup]
                      [Template]         etedh_tk2_api
                      CTKH108            ${list_%_ggsp1}        0              ${list_product_delete02}       TK007                        TK003                      ${list_product_tk05}    3000000

Tudong_BH_1thukhac    [Documentation]    1. Xử lý đặt hàng > Tạo hóa đơn cho đơn hàng được tạo qua API có giảm giá hóa đơn và hoàn trả tạm ứng\n2. Thu khác tự động đưa vào hóa đơn và đơn hàng có 1 thu khác \n3. Validate hàng hóa, công nợ khách hàng, sổ quỹ\n
                      [Tags]             AEDTKA
                      [Setup]
                      [Template]         etedh_tk3_api
                      CTKH109            200000      TK005       ${list_product_delete03}    ${list_vnd_ggsp}     25      ${list_product_tk06}     1000000

Tudong_BH_2thukhac    [Documentation]    1. Đang check do có lỗi trên hệ thống
                      [Tags]             AEDTKA
                      [Setup]
                      [Template]         etedh_tk4_api
                      CTKH110            ${list_giamoi04}           ${serial}    45000      all     TK002    TK006       ${list_product_tk07}    100000

*** Keywords ***
etedh_tk1_api
    [Arguments]    ${input_ma_kh}    ${input_gghd}    ${input_ma_thukhac}    ${input_khtt}    ${list_product}    ${dict_product_nums_to_create}
    Set Selenium Speed    0.5s
    ${order_code}    Add new order with multi product and no payment - get order code    ${input_ma_kh}    ${dict_product_nums_to_create}
    ##Activate surcharge
    ${surcharge_vnd_value}    Get surcharge vnd value    ${input_ma_thukhac}
    ${surcharge_%}    Get surcharge percentage value    ${input_ma_thukhac}
    Run Keyword If    ${surcharge_%} == 0    Toggle surcharge VND    ${input_ma_thukhac}    true
    ...    ELSE    Toggle surcharge percentage    ${input_ma_thukhac}    true
    #get info product, customer
    ${get_khachdatra_in_dh_bf_execute}    ${get_tongtienhang_in_dh_bf_execute}    Get paid value frm API    ${order_code}
    ${get_list_hh_in_dh_bf_execute}    ${get_ghichu_bf_execute}    Get ghi chu and list product frm API    ${order_code}
    ${list_result_tongdh_delete}    Get list order summary frm product API    ${list_product}
    #get order summary and sub total of products
    : FOR    ${ma_hh}    IN    @{list_product}
    \    Remove Values From List    ${get_list_hh_in_dh_bf_execute}    ${ma_hh}
    Log    ${get_list_hh_in_dh_bf_execute}
    ${get_list_quantity_in_dh_bf_ex}    Get list quantity by order code    ${order_code}    ${get_list_hh_in_dh_bf_execute}
    ${list_result_tongdh}    ${result_list_toncuoi}    ${result_list_thanhtien}    Get list order summary - total sale - ending stocks frm API    ${order_code}    ${get_list_hh_in_dh_bf_execute}
    #compute TTH with product
    ${result_tongtienhang}    Sum values in list    ${result_list_thanhtien}
    ${result_tongtienhang_tru_gghd}    Minus and replace floating point    ${result_tongtienhang}    ${input_gghd}
    ${actual_surcharge_type}    Set Variable If    ${surcharge_%} == 0    ${surcharge_vnd_value}    ${surcharge_%}
    ${result_per_surchare_by_invoice}    Convert % discount to VND and round    ${result_tongtienhang_tru_gghd}    ${surcharge_%}
    ${actual_surcharge_value}    Set Variable If    ${surcharge_%} == 0    ${surcharge_vnd_value}    ${result_per_surchare_by_invoice}
    ${result_tongtienhang_tovalidate}    Sum    ${result_tongtienhang}    ${actual_surcharge_value}
    ${result_khachcantra}    sum    ${result_tongtienhang_tru_gghd}    ${actual_surcharge_value}
    ${actual_khtt_all}    Set Variable If    '${input_khtt}' == 'all'    ${result_khachcantra}    ${input_khtt}
    ${actual_khtt}    Set Variable If    '${input_khtt}' == '0'    0    ${actual_khtt_all}
    ${actual_khtt_paymented}    Sum and replace floating point    ${actual_khtt}    ${get_khachdatra_in_dh_bf_execute}
    #create invoice from order
    ${get_order_id}   ${get_payment_id}   Get order - payment frm order api    ${order_code}
    ${get_list_order_detail_id}   Get list orderdetail id frm order api    ${order_code}    ${get_list_hh_in_dh_bf_execute}
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${get_id_thukhac}   ${get_thutu_thukhac}    Get Id and order surchage    ${input_ma_thukhac}
    ${jsonpath_id_kh}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_kh}
    ${get_id_kh}    Get data from API    ${endpoint_khachhang}    ${jsonpath_id_kh}
    ${endpoint_danhmuc_hh_co_dvt}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${get_resp_danhmuc_hh}    Get Request and return body    ${endpoint_danhmuc_hh_co_dvt}
    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}    Get list jsonpath product frm list product    ${get_list_hh_in_dh_bf_execute}
    ${list_giaban}    ${list_id_sp}    Get product info frm list jsonpath product    ${get_resp_danhmuc_hh}    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}
    ${liststring_prs_order_detail}     Set Variable      needdel
    Log        ${liststring_prs_order_detail}
    : FOR    ${item_gia_ban}   ${item_id_sp}   ${item_soluong}    ${item_orderdetail_id}      IN ZIP        ${list_giaban}        ${list_id_sp}    ${get_list_quantity_in_dh_bf_ex}      ${get_list_order_detail_id}
    \    ${payload_each_product}        Format string       {{"BasePrice":1000000,"IsLotSerialControl":false,"IsRewardPoint":false,"Note":"","Price":{0},"ProductId":{1},"Quantity":{2},"ProductCode":"Combo35","Discount":0,"DiscountRatio":0,"ProductName":"Bộ mỹ phẩm 29","PriceByPromotion":null,"IsMaster":true,"PromotionParentProductId":null,"ProductBatchExpireId":null,"CategoryId":794170,"MasterProductId":{1},"Unit":"","Uuid":"","OrderDetailId":{3},"ProductWarranty":[]}}   ${item_gia_ban}   ${item_id_sp}   ${item_soluong}     ${item_orderdetail_id}
    \    ${liststring_prs_order_detail}       Catenate      SEPARATOR=,      ${liststring_prs_order_detail}      ${payload_each_product}
    ${liststring_prs_order_detail}       Replace String      ${liststring_prs_order_detail}       needdel,       ${EMPTY}      count=1
    ${request_payload}    Format String    {{"Invoice":{{"BranchId":{0},"RetailerId":{1},"OrderId":{2},"UpdateInvoiceId":0,"UpdateReturnId":0,"CustomerId":{3},"SoldById":{4},"SoldBy":{{"CreatedBy":0,"CreatedDate":"2018-07-30T08:27:36.800Z","GivenName":"anh.lv","Id":{4},"IsActive":true,"IsAdmin":true,"Name":"anh.lv","Type":0,"isDeleted":false}},"SaleChannelId":0,"Seller":{{"CreatedBy":0,"CreatedDate":"2018-07-30T08:27:36.800Z","GivenName":"anh.lv","Id":{4},"IsActive":true,"IsAdmin":true,"Name":"anh.lv","Type":0,"isDeleted":false}},"PriceBookId":0,"OrderCode":"{5}","Code":"Hóa đơn 2","Discount":{6},"InvoiceDetails":[{7}],"InvoiceOrderSurcharges":[{{"Code":"TK004","Name":"Phí VAT4","Order":{8},"RetailerId":{1},"SurValueRatio":{9},"SurchargeId":{10},"ValueRatio":5,"isAuto":false,"isReturnAuto":false,"TextValue":"5.00 %","Price":{11},"UsageFlag":true}}],"InvoicePromotions":[],"Payments":[],"Status":1,"Total":3817800,"Surcharge":181800,"Type":1,"Uuid":"","addToAccount":"0","PayingAmount":0,"OrderPaidAmount":0,"TotalBeforeDiscount":3636000,"ProductDiscount":0,"PaidAmount":0,"DebugUuid":"156525322562445","InvoiceWarranties":[],"CreatedBy":201567}}}}    ${BRANCH_ID}    ${get_id_nguoitao}    ${get_order_id}    ${get_id_kh}    ${get_id_nguoiban}
    ...    ${order_code}    ${input_gghd}   ${liststring_prs_order_detail}   ${get_thutu_thukhac}    ${surcharge_%}    ${get_id_thukhac}    ${actual_surcharge_value}
    Log    ${request_payload}
    ${invoice_code}    Post request to create invoice and get invoice code    ${request_payload}
    #get value
    Sleep    20s    wait for response to API
    #assert value product in invoice
    ${get_list_hh_in_hd_af_execute}    Get list product frm Invoice API    ${invoice_code}
    ${list_soluong_in_hd}    ${list_giatri_quydoi_in_hd}    Get list quantity and gia tri quy doi by invoice code    ${get_list_hh_in_hd_af_execute}    ${invoice_code}
    : FOR    ${ma_hh}    ${result_toncuoi}    ${item_soluong}    ${get_giatri_quydoi}    IN ZIP    ${get_list_hh_in_hd_af_execute}
    ...    ${result_list_toncuoi}    ${list_soluong_in_hd}    ${list_giatri_quydoi_in_hd}
    \    Run Keyword If    '${get_giatri_quydoi}' == '1'    Validate product history frm API    ${invoice_code}    ${ma_hh}    ${result_toncuoi}
    \    ...    ${item_soluong}
    \    ...    ELSE    Validate unit product history frm API    ${invoice_code}    ${ma_hh}    ${result_toncuoi}
    \    ...    ${item_soluong}    ${get_giatri_quydoi}
    #validate deleted product
    ${list_order_summary_delete_af_execute}    Get list order summary frm product API    ${list_product}
    : FOR    ${result_tong_dh_delete}    ${order_summary_delete_af_execute}    IN ZIP    ${list_result_tongdh_delete}    ${list_order_summary_delete_af_execute}
    \    Should Be Equal As Numbers    ${result_tong_dh_delete}    ${order_summary_delete_af_execute}
    #validate product
    ${list_order_summary_af_execute}    Get list order summary frm product API    ${get_list_hh_in_dh_bf_execute}
    : FOR    ${result_tong_dh}    ${order_summary_af_execute}    IN ZIP    ${list_result_tongdh}    ${list_order_summary_af_execute}
    \    Should Be Equal As Numbers    ${order_summary_af_execute}    ${result_tong_dh}
    #assert value invoice
    ${get_ma_kh_by_hd}    ${get_tong_tien_hang}    ${get_khachtt_af_execute}    ${get_gghd_af_execute}    ${get_khachcantra}    ${get_trangthai}    ${get_ghichu_in_hd_af_execute}
    ...    Get invoice info have note incase discount by invoice code    ${invoice_code}
    Should Be Equal As Numbers    ${get_tong_tien_hang}    ${result_tongtienhang_tovalidate}
    Should Be Equal As Numbers    ${get_khachcantra}    ${result_khachcantra}
    Should Be Equal As Numbers    ${get_khachtt_af_execute}    ${actual_khtt}
    Should Be Equal As Strings    ${get_ma_kh_by_hd}    ${input_ma_kh}
    Should Be Equal As Numbers    ${get_gghd_af_execute}    ${input_gghd}
    Should Be Equal As Strings    ${get_trangthai}    Hoàn thành
    Should Be Equal As Strings    ${get_ghichu_in_hd_af_execute}    ${get_ghichu_bf_execute}
    #assert value order
    ${get_ma_kh_in_dh_af_execute}    ${get_TTDH_in_dh_af_execute}    ${get_tongtienhang_in_dh_af_exxecute}    ${get_khachdatra_in_dh_af_execute}    ${get_ghichu_af_execute}    Get order info have note by order code    ${order_code}
    Should Be Equal As Strings    ${get_ma_kh_in_dh_af_execute}    ${input_ma_kh}
    Should Be Equal As Strings    ${get_TTDH_in_dh_af_execute}    2    #trạng thái đang giao hàng
    Should Be Equal As Numbers    ${get_tongtienhang_in_dh_af_exxecute}    ${get_tongtienhang_in_dh_bf_execute}
    Should Be Equal As Numbers    ${get_khachdatra_in_dh_af_execute}    ${actual_khtt_paymented}
    Should Be Equal As Strings    ${get_ghichu_af_execute}    ${get_ghichu_bf_execute}
    Validate invoice history frm Order    ${order_code}    ${invoice_code}    ${result_khachcantra}
    Run Keyword If    ${surcharge_%} == 0    Toggle surcharge VND    ${input_ma_thukhac}    false
    ...    ELSE    Toggle surcharge percentage    ${input_ma_thukhac}    false

etedh_tk2_api
    [Arguments]    ${input_ma_kh}    ${list_ggsp}    ${input_hoantratamung}    ${list_product}    ${input_thukhac1}    ${input_thukhac2}
    ...    ${dict_product_nums_tocreate}    ${input_khtt_tocreate}
    Set Selenium Speed    0.5s
    ${order_code}    Add new order with multi products    ${input_ma_kh}    ${dict_product_nums_tocreate}    ${input_khtt_tocreate}
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
    ${get_khachdatra_in_dh_bf_execute}    ${get_tongtienhang_in_dh_bf_execute}    Get paid value frm API    ${order_code}
    ${get_list_hh_in_dh_bf_execute}    ${get_ghichu_bf_execute}    Get ghi chu and list product frm API    ${order_code}
    ${list_result_tongdh_delete}    Get list order summary frm product API    ${list_product}
    #get order summary and sub total of products
    : FOR    ${ma_hh}    IN    @{list_product}
    \    Remove Values From List    ${get_list_hh_in_dh_bf_execute}    ${ma_hh}
    Log    ${get_list_hh_in_dh_bf_execute}
    ${get_list_quantity_in_dh_bf_ex}    Get list quantity by order code    ${order_code}    ${get_list_hh_in_dh_bf_execute}
    ${list_result_tongdh}    ${result_list_toncuoi}    ${result_list_thanhtien}    ${list_result_giamoi}    Get list order summary - total sale - ending stocks incase discount    ${order_code}    ${get_list_hh_in_dh_bf_execute}
    ...    ${list_ggsp}
    #compute TTH with product
    ${result_tongtienhang}    Sum values in list    ${result_list_thanhtien}
    ${result_khachdatra}    Minus and replace floating point    ${result_tongtienhang}    ${get_khachdatra_in_dh_bf_execute}
    ${total_surcharge}=    Run Keyword If    ${actual_surcharge1_value} > 100 and ${actual_surcharge2_value} > 100    Sum    ${actual_surcharge1_value}    ${actual_surcharge2_value}
    ...    ELSE IF    ${actual_surcharge1_value} > 100 and ${actual_surcharge2_value} < 100    VND and Percentage Surcharges sum    ${actual_surcharge2_value}    ${result_tongtienhang}    ${actual_surcharge1_value}
    ...    ELSE IF    ${actual_surcharge1_value} < 100 and ${actual_surcharge2_value} < 100    Percentage and Percentage Surcharges sum    ${result_tongtienhang}    ${actual_surcharge1_value}    ${actual_surcharge2_value}
    ...    ELSE    Log    abv
    ${result_tongtienhang_tovalidate}    Sum    ${result_tongtienhang}    ${total_surcharge}
    ${result_tamung}    Minus and replace floating point    ${get_khachdatra_in_dh_bf_execute}    ${result_tongtienhang}
    #create invoice from order
    ${get_order_id}   ${get_payment_id}   Get order - payment frm order api    ${order_code}
    ${get_list_order_detail_id}   Get list orderdetail id frm order api    ${order_code}    ${get_list_hh_in_dh_bf_execute}
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${get_id_thukhac1}   ${get_thutu_thukhac1}    Get Id and order surchage    ${input_thukhac1}
    ${get_id_thukhac2}   ${get_thutu_thukhac2}    Get Id and order surchage    ${input_thukhac2}
    ${jsonpath_id_kh}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_kh}
    ${get_id_kh}    Get data from API    ${endpoint_khachhang}    ${jsonpath_id_kh}
    ${endpoint_danhmuc_hh_co_dvt}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${get_resp_danhmuc_hh}    Get Request and return body    ${endpoint_danhmuc_hh_co_dvt}
    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}    Get list jsonpath product frm list product    ${get_list_hh_in_dh_bf_execute}
    ${list_giaban}    ${list_result_ggsp}    ${list_id_sp}    Get product info frm list jsonpath product have discount product    ${get_resp_danhmuc_hh}    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}       ${list_ggsp}
    ${liststring_prs_order_detail}     Set Variable      needdel
    Log        ${liststring_prs_order_detail}
    : FOR    ${item_gia_ban}   ${item_id_sp}   ${item_soluong}    ${list_result_ggsp}   ${item_ggsp}    ${item_orderdetail_id}      IN ZIP        ${list_giaban}        ${list_id_sp}    ${get_list_quantity_in_dh_bf_ex}    ${list_result_ggsp}       ${list_ggsp}      ${get_list_order_detail_id}
    \     ${item_ggsp}    Set Variable If    0 < ${item_ggsp} < 100    ${item_ggsp}   0
    \    ${payload_each_product}        Format string       {{"BasePrice":1000000,"IsLotSerialControl":false,"IsRewardPoint":false,"Note":"","Price":{0},"ProductId":{1},"Quantity":{2},"ProductCode":"Combo35","Discount":{3},"DiscountRatio":{4},"ProductName":"Bộ mỹ phẩm 29","PriceByPromotion":null,"IsMaster":true,"PromotionParentProductId":null,"ProductBatchExpireId":null,"CategoryId":794170,"MasterProductId":{1},"Unit":"","Uuid":"","OrderDetailId":{5},"ProductWarranty":[]}}   ${item_gia_ban}   ${item_id_sp}   ${item_soluong}    ${list_result_ggsp}   ${item_ggsp}     ${item_orderdetail_id}
    \    ${liststring_prs_order_detail}       Catenate      SEPARATOR=,      ${liststring_prs_order_detail}      ${payload_each_product}
    ${liststring_prs_order_detail}       Replace String      ${liststring_prs_order_detail}       needdel,       ${EMPTY}      count=1
    ${actual_value_surcharge1}  Run Keyword If    0 < ${actual_surcharge1_value} < 100   Convert % discount to VND and round    ${result_tongtienhang}    ${actual_surcharge1_value}    ELSE   Set Variable    ${actual_surcharge1_value}
    ${actual_value_surcharge2}  Run Keyword If    0 < ${actual_surcharge2_value} < 100   Convert % discount to VND and round    ${result_tongtienhang}    ${actual_surcharge2_value}    ELSE   Set Variable    ${actual_surcharge1_value}
    ${request_payload}    Format String    {{"Invoice":{{"BranchId":{0},"RetailerId":{1},"OrderId":{2},"UpdateInvoiceId":0,"UpdateReturnId":0,"CustomerId":{3},"SoldById":{4},"SoldBy":{{"CreatedBy":0,"CreatedDate":"2018-07-30T08:27:36.800Z","GivenName":"anh.lv","Id":{4},"IsActive":true,"IsAdmin":true,"Type":0,"isDeleted":false,"Name":"anh.lv"}},"SaleChannelId":0,"Seller":{{"CreatedBy":0,"CreatedDate":"2018-07-30T08:27:36.800Z","GivenName":"anh.lv","Id":{4},"IsActive":true,"IsAdmin":true,"Type":0,"isDeleted":false,"Name":"anh.lv"}},"PriceBookId":0,"OrderCode":"{5}","Code":"Hóa đơn 2","Discount":0,"InvoiceDetails":[{6}],"InvoiceOrderSurcharges":[{{"Code":"TK003","Name":"Phí VAT3","Order":{7},"RetailerId":{1},"SurValueRatio":{8},"SurchargeId":{9},"ValueRatio":10,"isAuto":false,"isReturnAuto":false,"TextValue":"10.00 %","Price":{10},"UsageFlag":true}},{{"Code":"TK007","Name":"Phí giao hàng3","Order":{11},"RetailerId":{1},"SurValue":{12},"SurchargeId":{13},"Value":20000,"isAuto":false,"isReturnAuto":false,"TextValue":"20,000","Price":{14},"UsageFlag":true}}],"InvoicePromotions":[],"Payments":[],"Status":1,"Total":{15},"Surcharge":{16},"Type":1,"Uuid":"","addToAccount":"0","PayingAmount":0,"OrderPaidAmount":{17},"DepositReturn":{18},"TotalBeforeDiscount":{19},"ProductDiscount":152500,"PaidAmount":3000000,"DebugUuid":"","InvoiceWarranties":[],"CreatedBy":201567}}}}    ${BRANCH_ID}    ${get_id_nguoitao}    ${get_order_id}    ${get_id_kh}    ${get_id_nguoiban}
    ...    ${order_code}    ${liststring_prs_order_detail}   ${get_thutu_thukhac1}    ${actual_surcharge1_value}    ${get_id_thukhac1}    ${actual_value_surcharge1}
    ...    ${get_thutu_thukhac2}    ${actual_surcharge2_value}    ${get_id_thukhac2}    ${actual_value_surcharge2}    ${result_tongtienhang_tovalidate}
    ...    ${total_surcharge}    ${get_khachdatra_in_dh_bf_execute}     ${input_hoantratamung}    ${result_tongtienhang}
    Log    ${request_payload}
    ${invoice_code}    Post request to create invoice and get invoice code    ${request_payload}
    #get value
    Sleep    20s    wait for response to API
    #assert value product in invoice
    ${get_list_hh_in_hd_af_execute}    Get list product frm Invoice API    ${invoice_code}
    ${list_soluong_in_hd}    ${list_giatri_quydoi_in_hd}    Get list quantity and gia tri quy doi by invoice code    ${get_list_hh_in_hd_af_execute}    ${invoice_code}
    : FOR    ${ma_hh}    ${result_toncuoi}    ${item_soluong}    ${get_giatri_quydoi}    IN ZIP    ${get_list_hh_in_hd_af_execute}
    ...    ${result_list_toncuoi}    ${list_soluong_in_hd}    ${list_giatri_quydoi_in_hd}
    \    Run Keyword If    '${get_giatri_quydoi}' == '1'    Validate product history frm API    ${invoice_code}    ${ma_hh}    ${result_toncuoi}
    \    ...    ${item_soluong}
    \    ...    ELSE    Validate unit product history frm API    ${invoice_code}    ${ma_hh}    ${result_toncuoi}
    \    ...    ${item_soluong}    ${get_giatri_quydoi}
    #validate deleted product
    ${list_order_summary_delete_af_execute}    Get list order summary frm product API    ${list_product}
    : FOR    ${result_tong_dh_delete}    ${order_summary_delete_af_execute}    IN ZIP    ${list_result_tongdh_delete}    ${list_order_summary_delete_af_execute}
    \    Should Be Equal As Numbers    ${result_tong_dh_delete}    ${order_summary_delete_af_execute}
    #validate product
    ${list_order_summary_af_execute}    Get list order summary frm product API    ${get_list_hh_in_dh_bf_execute}
    : FOR    ${result_tong_dh}    ${order_summary_af_execute}    IN ZIP    ${list_result_tongdh}    ${list_order_summary_af_execute}
    \    Should Be Equal As Numbers    ${order_summary_af_execute}    ${result_tong_dh}
    #assert value invoice
    ${get_ma_kh_by_hd}    ${get_tong_tien_hang}    ${get_khach_tt}    ${get_trangthai}    ${get_ghichu_in_hd_af_execute}    Get invoice info have note by invoice code    ${invoice_code}
    Should Be Equal As Numbers    ${get_tong_tien_hang}    ${result_tongtienhang_tovalidate}
    Should Be Equal As Numbers    ${get_khach_tt}    ${result_tongtienhang_tovalidate}
    Should Be Equal As Strings    ${get_ma_kh_by_hd}    ${input_ma_kh}
    Should Be Equal As Strings    ${get_trangthai}    Hoàn thành
    Should Be Equal As Strings    ${get_ghichu_in_hd_af_execute}    ${get_ghichu_bf_execute}
    #assert value order
    ${get_ma_kh_in_dh_af_execute}    ${get_TTDH_in_dh_af_execute}    ${get_tongtienhang_in_dh_af_exxecute}    ${get_khachdatra_in_dh_af_execute}    ${get_ghichu_af_execute}    Get order info have note by order code    ${order_code}
    Should Be Equal As Strings    ${get_ma_kh_in_dh_af_execute}    ${input_ma_kh}
    Should Be Equal As Strings    ${get_TTDH_in_dh_af_execute}    2    #trạng thái đang giao hàng
    Should Be Equal As Numbers    ${get_tongtienhang_in_dh_af_exxecute}    ${get_tongtienhang_in_dh_bf_execute}
    Should Be Equal As Numbers    ${get_khachdatra_in_dh_af_execute}    ${get_khachdatra_in_dh_bf_execute}
    Should Be Equal As Strings    ${get_ghichu_af_execute}    ${get_ghichu_bf_execute}
    Validate invoice history frm Order    ${order_code}    ${invoice_code}    ${result_tongtienhang_tovalidate}
    ## Deactivate surcharge
    Run Keyword If    ${actual_surcharge1_value} > 100    Toggle surcharge VND    ${input_thukhac1}    false
    ...    ELSE    Toggle surcharge percentage    ${input_thukhac1}    false
    Run Keyword If    ${actual_surcharge2_value} > 100    Toggle surcharge VND    ${input_thukhac2}    false
    ...    ELSE    Toggle surcharge percentage    ${input_thukhac2}    false

etedh_tk3_api
    [Arguments]    ${input_ma_kh}    ${input_hoantratamung}    ${input_ma_thukhac}    ${list_product}    ${list_ggsp}    ${input_gghd}
    ...    ${dict_product_nums_tocreate}    ${input_khtt_tocreate}
    Set Selenium Speed    0.5s
    ${order_code}    Add new order have surcharge    ${input_ma_kh}    ${dict_product_nums_tocreate}    ${input_ma_thukhac}    ${input_khtt_tocreate}
    ${get_khachdatra_in_dh_bf_execute}    ${get_tongtienhang_in_dh_bf_execute}    Get paid value frm API    ${order_code}
    ${get_list_hh_in_dh_bf_execute}    ${get_ghichu_bf_execute}    Get ghi chu and list product frm API    ${order_code}
    ${list_result_tongdh_delete}    Get list order summary frm product API    ${list_product}
    ${get_no_bf_execute}    ${get_tongban_bf_execute}    ${get_tongban_tru_trahang_bf_execute}    Get Customer Debt from API    ${input_ma_kh}
    #get order summary and sub total of products
    : FOR    ${ma_hh}    IN    @{list_product}
    \    Remove Values From List    ${get_list_hh_in_dh_bf_execute}    ${ma_hh}
    Log    ${get_list_hh_in_dh_bf_execute}
    ${get_list_quantity_in_dh_bf_ex}    Get list quantity by order code    ${order_code}    ${get_list_hh_in_dh_bf_execute}
    ${list_result_tongdh}    ${result_list_toncuoi}    ${result_list_thanhtien}    ${list_result_giamoi}    Get list order summary - total sale - ending stocks incase discount    ${order_code}    ${get_list_hh_in_dh_bf_execute}
    ...    ${list_ggsp}
    ${surcharge_vnd_value}    Get surcharge vnd value    ${input_ma_thukhac}
    ${surcharge_%}    Get surcharge percentage value    ${input_ma_thukhac}
    Run Keyword If    ${surcharge_%} == 0    Toggle surcharge VND    ${input_ma_thukhac}    true
    ...    ELSE    Toggle surcharge percentage    ${input_ma_thukhac}    true
    #compute TTH with product
    ${result_tongtienhang}    Sum values in list    ${result_list_thanhtien}
    ${result_gghd}    Convert % discount to VND and round    ${result_tongtienhang}    ${input_gghd}
    ${result_tongtienhang_tru_gghd}    Minus    ${result_tongtienhang}    ${result_gghd}
    ${actual_surcharge_type}    Set Variable If    ${surcharge_%} == 0    ${surcharge_vnd_value}    ${surcharge_%}
    ${result_per_surchare_by_invoice}    Convert % discount to VND and round    ${result_tongtienhang_tru_gghd}    ${surcharge_%}
    ${actual_surcharge_value}    Set Variable If    ${surcharge_%} == 0    ${surcharge_vnd_value}    ${result_per_surchare_by_invoice}
    ${result_khachcantra}    sum    ${result_tongtienhang_tru_gghd}    ${actual_surcharge_value}
    ${tamung}    Minus and replace floating point    ${get_khachdatra_in_dh_bf_execute}    ${result_khachcantra}
    ${result_tamung}    Set Variable If    '${input_hoantratamung}' == 'all'    ${tamung}    ${input_hoantratamung}
    ${result_du_no_hd_KH}    Sum    ${get_no_bf_execute}    ${result_khachcantra}
    ${result_PTT_hd_KH}    Sum    ${result_du_no_hd_KH}    ${result_tamung}
    ${result_tongban_KH}    Sum and replace floating point    ${result_khachcantra}    ${get_tongban_bf_execute}
    ${result_khachdatra_in_dh}    Minus    ${get_khachdatra_in_dh_bf_execute}    ${result_tamung}
    ${result_tongtienhang_tovalidate}    Sum    ${result_tongtienhang}    ${actual_surcharge_value}
    #create invoice from order
    ${get_order_id}   ${get_payment_id}   Get order - payment frm order api    ${order_code}
    ${get_list_order_detail_id}   Get list orderdetail id frm order api    ${order_code}    ${get_list_hh_in_dh_bf_execute}
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${get_id_thukhac}   ${get_thutu_thukhac}    Get Id and order surchage    ${input_ma_thukhac}
    ${jsonpath_id_kh}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_kh}
    ${get_id_kh}    Get data from API    ${endpoint_khachhang}    ${jsonpath_id_kh}
    ${endpoint_danhmuc_hh_co_dvt}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${get_resp_danhmuc_hh}    Get Request and return body    ${endpoint_danhmuc_hh_co_dvt}
    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}    Get list jsonpath product frm list product    ${get_list_hh_in_dh_bf_execute}
    ${list_giaban}    ${list_result_ggsp}    ${list_id_sp}    Get product info frm list jsonpath product have discount product    ${get_resp_danhmuc_hh}    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}       ${list_ggsp}
    ${liststring_prs_order_detail}     Set Variable      needdel
    Log        ${liststring_prs_order_detail}
    : FOR    ${item_gia_ban}   ${item_id_sp}   ${item_soluong}    ${list_result_ggsp}   ${item_ggsp}    ${item_orderdetail_id}      IN ZIP        ${list_giaban}        ${list_id_sp}    ${get_list_quantity_in_dh_bf_ex}    ${list_result_ggsp}       ${list_ggsp}      ${get_list_order_detail_id}
    \     ${item_ggsp}    Set Variable If    0 < ${item_ggsp} < 100    ${item_ggsp}   0
    \    ${payload_each_product}        Format string       {{"BasePrice":1000000,"IsLotSerialControl":false,"IsRewardPoint":false,"Note":"","Price":{0},"ProductId":{1},"Quantity":{2},"ProductCode":"Combo35","Discount":{3},"DiscountRatio":{4},"ProductName":"Bộ mỹ phẩm 29","PriceByPromotion":null,"IsMaster":true,"PromotionParentProductId":null,"ProductBatchExpireId":null,"CategoryId":794170,"MasterProductId":{1},"Unit":"","Uuid":"","OrderDetailId":{5},"ProductWarranty":[]}}   ${item_gia_ban}   ${item_id_sp}   ${item_soluong}    ${list_result_ggsp}   ${item_ggsp}     ${item_orderdetail_id}
    \    ${liststring_prs_order_detail}       Catenate      SEPARATOR=,      ${liststring_prs_order_detail}      ${payload_each_product}
    ${liststring_prs_order_detail}       Replace String      ${liststring_prs_order_detail}       needdel,       ${EMPTY}      count=1
    ${giamgia}    Set Variable If   0 < ${input_gghd} < 100    ${input_gghd}    0
    ${tam_ung}    Minus     0     ${result_tamung}
    ${request_payload}    Format String    {{"Invoice":{{"BranchId":{0},"RetailerId":{1},"OrderId":{2},"UpdateInvoiceId":0,"UpdateReturnId":0,"CustomerId":{3},"SoldById":{4},"SoldBy":{{"CreatedBy":0,"CreatedDate":"2018-07-30T08:27:36.800Z","GivenName":"anh.lv","Id":{4},"IsActive":true,"IsAdmin":true,"Type":0,"isDeleted":false,"Name":"anh.lv"}},"SaleChannelId":0,"Seller":{{"CreatedBy":0,"CreatedDate":"2018-07-30T08:27:36.800Z","GivenName":"anh.lv","Id":{4},"IsActive":true,"IsAdmin":true,"Type":0,"isDeleted":false,"Name":"anh.lv"}},"PriceBookId":0,"OrderCode":"{5}","Code":"Hóa đơn 2","Discount":{6},"DiscountRatio":{7},"InvoiceDetails":[{8}],"InvoiceOrderSurcharges":[{{"Code":"TK003","Name":"Phí VAT3","Order":{9},"RetailerId":{1},"SurValueRatio":{10},"SurchargeId":{11},"ValueRatio":10,"isAuto":false,"isReturnAuto":false,"TextValue":"10.00 %","Price":{12},"UsageFlag":true}}],"InvoicePromotions":[],"Payments":[{{"Method":"Cash","MethodStr":"Tiền mặt","Amount":{13},"Id":-1}}],"Status":1,"Total":{14},"Surcharge":{15},"Type":1,"Uuid":"","addToAccount":"0","PayingAmount":0,"OrderPaidAmount":{16},"DepositReturn":{17},"TotalBeforeDiscount":{18},"ProductDiscount":152500,"PaidAmount":3000000,"DebugUuid":"","InvoiceWarranties":[],"CreatedBy":201567}}}}    ${BRANCH_ID}    ${get_id_nguoitao}    ${get_order_id}    ${get_id_kh}    ${get_id_nguoiban}    ${order_code}    ${result_gghd}    ${giamgia}    ${liststring_prs_order_detail}   ${get_thutu_thukhac}    ${surcharge_%}    ${get_id_thukhac}    ${actual_surcharge_value}
    ...        ${tam_ung}    ${result_khachcantra}    ${actual_surcharge_value}    ${get_khachdatra_in_dh_bf_execute}     ${result_tamung}    ${result_tongtienhang}
    Log    ${request_payload}
    ${invoice_code}    Post request to create invoice and get invoice code    ${request_payload}
    #get value
    Sleep    20s    wait for response to API
    #assert value product in invoice
    ${get_list_hh_in_hd_af_execute}    Get list product frm Invoice API    ${invoice_code}
    ${list_soluong_in_hd}    ${list_giatri_quydoi_in_hd}    Get list quantity and gia tri quy doi by invoice code    ${get_list_hh_in_hd_af_execute}    ${invoice_code}
    : FOR    ${ma_hh}    ${result_toncuoi}    ${item_soluong}    ${get_giatri_quydoi}    IN ZIP    ${get_list_hh_in_hd_af_execute}
    ...    ${result_list_toncuoi}    ${list_soluong_in_hd}    ${list_giatri_quydoi_in_hd}
    \    Run Keyword If    '${get_giatri_quydoi}' == '1'    Validate product history frm API    ${invoice_code}    ${ma_hh}    ${result_toncuoi}
    \    ...    ${item_soluong}
    \    ...    ELSE    Validate unit product history frm API    ${invoice_code}    ${ma_hh}    ${result_toncuoi}
    \    ...    ${item_soluong}    ${get_giatri_quydoi}
    #validate deleted product
    ${list_order_summary_delete_af_execute}    Get list order summary frm product API    ${list_product}
    : FOR    ${result_tong_dh_delete}    ${order_summary_delete_af_execute}    IN ZIP    ${list_result_tongdh_delete}    ${list_order_summary_delete_af_execute}
    \    Should Be Equal As Numbers    ${result_tong_dh_delete}    ${order_summary_delete_af_execute}
    #validate product
    ${list_order_summary_af_execute}    Get list order summary frm product API    ${get_list_hh_in_dh_bf_execute}
    : FOR    ${result_tong_dh}    ${order_summary_af_execute}    IN ZIP    ${list_result_tongdh}    ${list_order_summary_af_execute}
    \    Should Be Equal As Numbers    ${order_summary_af_execute}    ${result_tong_dh}
    #assert value invoice
    ${get_ma_kh_by_hd}    ${get_tong_tien_hang}    ${get_khachtt_af_execute}    ${get_gghd_af_execute}    ${get_khachcantra}    ${get_trangthai}    ${get_ghichu_in_hd_af_execute}
    ...    Get invoice info have note incase discount by invoice code    ${invoice_code}
    Should Be Equal As Numbers    ${get_tong_tien_hang}    ${result_tongtienhang_tovalidate}
    Should Be Equal As Numbers    ${get_khachcantra}    ${result_khachcantra}
    Should Be Equal As Numbers    ${get_khachtt_af_execute}    ${result_khachcantra}
    Should Be Equal As Strings    ${get_ma_kh_by_hd}    ${input_ma_kh}
    Should Be Equal As Numbers    ${get_gghd_af_execute}    ${result_gghd}
    Should Be Equal As Strings    ${get_trangthai}    Hoàn thành
    Should Be Equal As Strings    ${get_ghichu_in_hd_af_execute}    ${get_ghichu_bf_execute}
    #assert value order
    ${get_ma_kh_in_dh_af_execute}    ${get_TTDH_in_dh_af_execute}    ${get_tongtienhang_in_dh_af_exxecute}    ${get_khachdatra_in_dh_af_execute}    ${get_ghichu_af_execute}    Get order info have note by order code    ${order_code}
    Should Be Equal As Strings    ${get_ma_kh_in_dh_af_execute}    ${input_ma_kh}
    Should Be Equal As Strings    ${get_TTDH_in_dh_af_execute}    2    #trạng thái đang giao hàng
    Should Be Equal As Numbers    ${get_tongtienhang_in_dh_af_exxecute}    ${get_tongtienhang_in_dh_bf_execute}
    Should Be Equal As Numbers    ${get_khachdatra_in_dh_af_execute}    ${result_khachdatra_in_dh}
    Should Be Equal As Strings    ${get_ghichu_af_execute}    ${get_ghichu_bf_execute}
    Validate invoice history frm Order    ${order_code}    ${invoice_code}    ${result_khachcantra}
    #assert customer and so quy
    ${get_no_af_execute_kh}    ${get_tongban_af_execute_kh}    ${get_tongban_tru_trahang_af_execute_kh}    Get Customer Debt from API after purchase    ${input_ma_kh}    ${invoice_code}    ${result_tongtienhang}
    ${get_maphieu_soquy}    Get Ma Phieu Thu in So quy    ${invoice_code}
    Run Keyword If    '${input_hoantratamung}' == '0'    Should Be Equal As Numbers    ${get_no_af_execute_kh}    ${result_du_no_hd_KH}
    ...    ELSE    Should Be Equal As Numbers    ${get_no_af_execute_kh}    ${result_PTT_hd_KH}
    Should Be Equal As Numbers    ${get_tongban_af_execute_kh}    ${result_tongban_KH}
    Run Keyword If    '${input_hoantratamung}' == '0'    Validate customer history and debt if invoice is not paid frm order    ${input_ma_kh}    ${invoice_code}    ${result_du_no_hd_KH}
    ...    ELSE    Validate customer history and debt if invoice is paid deposit refund frm order    ${input_ma_kh}    ${invoice_code}    ${result_du_no_hd_KH}    ${result_PTT_hd_KH}
    Run Keyword If    '${result_tongtienhang}' == '0'    Validate history tab of customer frm Order    ${input_ma_kh}    ${invoice_code}
    Run Keyword If    '${input_hoantratamung}' == '0'    Validate So quy info from Rest API if Invoice is not paid    ${get_maphieu_soquy}
    ...    ELSE    Validate So quy info from Rest API if Invoice is paid    ${get_maphieu_soquy}    ${result_tamung}
    Run Keyword If    ${surcharge_%} == 0    Toggle surcharge VND    ${input_ma_thukhac}    false
    ...    ELSE    Toggle surcharge percentage    ${input_ma_thukhac}    false

etedh_tk4_api
    [Arguments]    ${input_ma_kh}    ${list_newprice}    ${input_gghd}    ${input_khtt}    ${input_thukhac1}
    ...    ${input_thukhac2}    ${dict_product_nums_tocreate}    ${input_khtt_tocreate}
    Set Selenium Speed    0.5s
    ${order_code}    Add new order have multi surcharge    ${input_ma_kh}    ${dict_product_nums_tocreate}    ${input_thukhac1}    ${input_thukhac2}    ${input_khtt_tocreate}
    #get info product, customer
    ${list_product}   Get Dictionary Keys    ${dict_product_nums_tocreate}
    ${list_nums}    Get Dictionary Values    ${dict_product_nums_tocreate}
    Create list imei and other product    ${list_product}    ${list_nums}
    ${get_khachdatra_in_dh_bf_execute}    ${get_tongtienhang_in_dh_bf_execute}    Get paid value frm API    ${order_code}
    ${get_list_hh_in_dh_bf_execute}    ${get_ghichu_bf_execute}    Get ghi chu and list product frm API    ${order_code}
    #get order summary and sub total of products
    ${list_result_tongdh}    ${result_list_toncuoi}    ${result_list_thanhtien}    Get list order summary - total sale - ending stocks incase newprice    ${order_code}    ${get_list_hh_in_dh_bf_execute}    ${list_newprice}
    ${get_list_quantity_in_dh_bf_ex}    Get list quantity by order code    ${order_code}    ${get_list_hh_in_dh_bf_execute}
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
    #compute for invoice, order
    ${result_tongtienhang}    Sum values in list    ${result_list_thanhtien}
    ${result_TTH_tru_gghd}    Minus    ${result_tongtienhang}    ${input_gghd}
    ${total_surcharge}=    Run Keyword If    ${actual_surcharge1_value} > 100 and ${actual_surcharge2_value} > 100    Sum    ${actual_surcharge1_value}    ${actual_surcharge2_value}
    ...    ELSE IF    ${actual_surcharge2_value} > 100 and ${actual_surcharge1_value} < 100    VND and Percentage Surcharges sum    ${actual_surcharge1_value}    ${result_TTH_tru_gghd}    ${actual_surcharge2_value}
    ...    ELSE IF    ${actual_surcharge1_value} < 100 and ${actual_surcharge2_value} < 100    Percentage and Percentage Surcharges sum    ${result_TTH_tru_gghd}    ${actual_surcharge1_value}    ${actual_surcharge2_value}
    ...    ELSE    Log    abv
    ${result_khachcantra}    Sum    ${result_TTH_tru_gghd}    ${total_surcharge}
    ${result_khachcantra_in_hd}    Minus and replace floating point    ${result_khachcantra}    ${get_khachdatra_in_dh_bf_execute}
    ${result_khdatra_in_hd}    Sum and replace floating point    ${result_khachcantra_in_hd}    ${get_khachdatra_in_dh_bf_execute}
    ${actual_khcantra_all}    Set Variable If    '${input_khtt}' == 'all'    ${result_khachcantra_in_hd}    ${input_khtt}
    ${actual_khachcantra}    Set Variable If    '${input_khtt}' == '0'    0    ${actual_khcantra_all}
    ${result_tongtienhang_tovalidate}    Sum    ${result_tongtienhang}    ${total_surcharge}
    #compute for order
    ${result_khachthanhtoan_in_dh}    Sum and replace floating point    ${get_khachdatra_in_dh_bf_execute}    ${actual_khachcantra}
    #create invoice from order
    ${get_order_id}   ${get_payment_id}   Get order - payment frm order api    ${order_code}
    ${get_list_order_detail_id}   Get list orderdetail id frm order api    ${order_code}    ${get_list_hh_in_dh_bf_execute}
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${get_id_thukhac1}   ${get_thutu_thukhac1}    Get Id and order surchage    ${input_thukhac1}
    ${get_id_thukhac2}   ${get_thutu_thukhac2}    Get Id and order surchage    ${input_thukhac2}
    ${jsonpath_id_kh}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_kh}
    ${get_id_kh}    Get data from API    ${endpoint_khachhang}    ${jsonpath_id_kh}
    ${endpoint_danhmuc_hh_co_dvt}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${get_resp_danhmuc_hh}    Get Request and return body    ${endpoint_danhmuc_hh_co_dvt}
    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}    Get list jsonpath product frm list product    ${get_list_hh_in_dh_bf_execute}
    ${list_giaban}    ${list_result_ggsp}    ${list_id_sp}    Get product info and new price frm list product    ${get_resp_danhmuc_hh}    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}    ${list_newprice}
    ${liststring_prs_order_detail}     Set Variable      needdel
    Log        ${liststring_prs_order_detail}
    : FOR    ${item_gia_ban}   ${item_id_sp}   ${item_soluong}    ${item_imei}    ${item_result_ggsp}   ${item_orderdetail_id}      IN ZIP      ${list_giaban}        ${list_id_sp}    ${get_list_quantity_in_dh_bf_ex}    ${imei_inlist}    ${list_result_ggsp}       ${get_list_order_detail_id}
    \    ${item_imei}    Convert list to string and return    ${item_imei}
    \    ${payload_each_product}        Format string       {{"BasePrice":175000,"IsLotSerialControl":true,"IsRewardPoint":false,"Note":"","Price":{0},"ProductId":{1},"Quantity":{2},"ProductCode":"SI059","SerialNumbers":"{3}","Discount":{4},"DiscountRatio":0,"ProductName":"Tủ Lạnh Inverter Panasonic NR-BL267VSV1","PriceByPromotion":null,"IsMaster":true,"PromotionParentProductId":null,"ProductBatchExpireId":null,"CategoryId":543560,"MasterProductId":{1},"Unit":"","Uuid":"","OrderDetailId":{5},"ProductWarranty":[]}}    ${item_gia_ban}   ${item_id_sp}   ${item_soluong}       ${item_imei}    ${item_result_ggsp}   ${item_orderdetail_id}
    \    ${liststring_prs_order_detail}       Catenate      SEPARATOR=,      ${liststring_prs_order_detail}      ${payload_each_product}
    ${liststring_prs_order_detail}       Replace String      ${liststring_prs_order_detail}       needdel,       ${EMPTY}      count=1
    ${actual_value_surcharge1}  Run Keyword If    0 < ${actual_surcharge1_value} < 100   Convert % discount to VND and round    ${result_TTH_tru_gghd}    ${actual_surcharge1_value}    ELSE   Set Variable    ${actual_surcharge1_value}
    ${actual_value_surcharge2}  Run Keyword If    0 < ${actual_surcharge2_value} < 100   Convert % discount to VND and round    ${result_TTH_tru_gghd}    ${actual_surcharge2_value}    ELSE   Set Variable    ${actual_surcharge2_value}
    ${request_payload}    Format String    {{"Invoice":{{"BranchId":{0},"RetailerId":{1},"OrderId":{2},"UpdateInvoiceId":0,"UpdateReturnId":0,"CustomerId":{3},"SoldById":{4},"SoldBy":{{"CreatedBy":0,"CreatedDate":"2018-07-30T08:27:36.800Z","GivenName":"anh.lv","Id":{4},"IsActive":true,"IsAdmin":true,"Type":0,"isDeleted":false,"Name":"anh.lv"}},"SaleChannelId":0,"Seller":{{"CreatedBy":0,"CreatedDate":"2018-07-30T08:27:36.800Z","GivenName":"anh.lv","Id":{4},"IsActive":true,"IsAdmin":true,"Type":0,"isDeleted":false,"Name":"anh.lv"}},"PriceBookId":0,"OrderCode":"{5}","Code":"Hóa đơn 2","Discount":{6},"DiscountRatio":0,"InvoiceDetails":[{7}],"InvoiceOrderSurcharges":[{{"Code":"TK003","Name":"Phí VAT3","Order":{8},"RetailerId":{1},"SurValueRatio":{9},"SurchargeId":{10},"ValueRatio":10,"isAuto":false,"isReturnAuto":false,"TextValue":"10.00 %","Price":{11},"UsageFlag":true}},{{"Code":"TK007","Name":"Phí giao hàng3","Order":{12},"RetailerId":{1},"SurValue":{13},"SurchargeId":{14},"Value":20000,"isAuto":false,"isReturnAuto":false,"TextValue":"20,000","Price":{15},"UsageFlag":true}}],"InvoicePromotions":[],"Payments":[{{"Method":"Cash","MethodStr":"Tiền mặt","Amount":{16},"Id":-1}}],"Status":1,"Total":{17},"Surcharge":{18},"Type":1,"Uuid":"","addToAccount":"0","PayingAmount":{16},"OrderPaidAmount":{19},"DepositReturn":0,"TotalBeforeDiscount":{20},"ProductDiscount":152500,"PaidAmount":3000000,"DebugUuid":"","InvoiceWarranties":[],"CreatedBy":201567}}}}    ${BRANCH_ID}    ${get_id_nguoitao}    ${get_order_id}    ${get_id_kh}    ${get_id_nguoiban}
    ...    ${order_code}    ${input_gghd}   ${liststring_prs_order_detail}   ${get_thutu_thukhac1}    ${actual_surcharge1_value}    ${get_id_thukhac1}    ${actual_value_surcharge1}
    ...    ${get_thutu_thukhac2}    ${actual_surcharge2_value}    ${get_id_thukhac2}    ${actual_value_surcharge2}        ${actual_khachcantra}    ${result_khachcantra}
    ...    ${total_surcharge}    ${get_khachdatra_in_dh_bf_execute}    ${result_tongtienhang}
    Log    ${request_payload}
    ${invoice_code}    Post request to create invoice and get invoice code    ${request_payload}
    #get value
    Sleep    20s    wait for response to API
    #assert value product in invoice
    ${get_list_hh_in_hd_af_execute}    Get list product frm Invoice API    ${invoice_code}
    ${list_soluong_in_hd}    ${list_giatri_quydoi_in_hd}    Get list quantity and gia tri quy doi by invoice code    ${get_list_hh_in_hd_af_execute}    ${invoice_code}
    : FOR    ${ma_hh}    ${result_toncuoi}    ${item_soluong}    ${get_giatri_quydoi}    IN ZIP    ${get_list_hh_in_hd_af_execute}
    ...    ${result_list_toncuoi}    ${list_soluong_in_hd}    ${list_giatri_quydoi_in_hd}
    \    Run Keyword If    '${get_giatri_quydoi}' == '1'    Validate product history frm API    ${invoice_code}    ${ma_hh}    ${result_toncuoi}
    \    ...    ${item_soluong}
    \    ...    ELSE    Validate unit product history frm API    ${invoice_code}    ${ma_hh}    ${result_toncuoi}
    \    ...    ${item_soluong}    ${get_giatri_quydoi}
    #validate product
    ${list_order_summary_af_execute}    Get list order summary frm product API    ${get_list_hh_in_dh_bf_execute}
    : FOR    ${result_tong_dh}    ${order_summary_af_execute}    IN ZIP    ${list_result_tongdh}    ${list_order_summary_af_execute}
    \    Should Be Equal As Numbers    ${order_summary_af_execute}    ${result_tong_dh}
    #assert value invoice
    ${get_ma_kh_by_hd}    ${get_tong_tien_hang}    ${get_khachtt_af_execute}    ${get_gghd_af_execute}    ${get_khachcantra}    ${get_trangthai}    ${get_ghichu_in_hd_af_execute}
    ...    Get invoice info have note incase discount by invoice code    ${invoice_code}
    Should Be Equal As Numbers    ${get_tong_tien_hang}    ${result_tongtienhang_tovalidate}
    Should Be Equal As Numbers    ${get_khachcantra}    ${result_khachcantra}
    Should Be Equal As Numbers    ${get_khachtt_af_execute}    ${result_khachcantra}
    Should Be Equal As Strings    ${get_ma_kh_by_hd}    ${input_ma_kh}
    Should Be Equal As Numbers    ${get_gghd_af_execute}    ${input_gghd}
    Should Be Equal As Strings    ${get_trangthai}    Hoàn thành
    Should Be Equal As Strings    ${get_ghichu_in_hd_af_execute}    ${get_ghichu_bf_execute}
    #assert value order
    ${get_ma_kh_in_dh_af_execute}    ${get_TTDH_in_dh_af_execute}    ${get_tongtienhang_in_dh_af_exxecute}    ${get_khachdatra_in_dh_af_execute}    ${get_ghichu_af_execute}    Get order info have note by order code    ${order_code}
    Should Be Equal As Strings    ${get_ma_kh_in_dh_af_execute}    ${input_ma_kh}
    Should Be Equal As Strings    ${get_TTDH_in_dh_af_execute}    3    #trạng thái hoàn thành
    Should Be Equal As Numbers    ${get_tongtienhang_in_dh_af_exxecute}    ${get_tongtienhang_in_dh_bf_execute}
    Should Be Equal As Numbers    ${get_khachdatra_in_dh_af_execute}    ${result_khachthanhtoan_in_dh}
    Should Be Equal As Strings    ${get_ghichu_af_execute}    ${get_ghichu_bf_execute}
    Validate invoice history frm Order    ${order_code}    ${invoice_code}    ${result_khachcantra}
    Run Keyword If    ${actual_surcharge1_value} > 100    Toggle surcharge VND    ${input_thukhac1}    false
    ...    ELSE    Toggle surcharge percentage    ${input_thukhac1}    false
    Run Keyword If    ${actual_surcharge2_value} > 100    Toggle surcharge VND    ${input_thukhac2}    false
    ...    ELSE    Toggle surcharge percentage    ${input_thukhac2}    false
