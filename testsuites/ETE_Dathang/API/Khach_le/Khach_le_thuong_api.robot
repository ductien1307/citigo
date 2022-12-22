*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}      ${headless_browser}
Test Setup
Test Teardown     After Test
Library           SeleniumLibrary
Resource          ../../../../core/API/api_danhmuc_hanghoa.robot
Resource          ../../../../core/API/api_dathang.robot
Resource          ../../../../core/API/api_khachhang.robot
Resource          ../../../../core/API/api_mhbh.robot
Resource          ../../../../core/Dat_Hang/dat_hang_action.robot
Resource          ../../../../core/Dat_Hang/dat_hang_navigation.robot
Resource          ../../../../core/Dat_Hang/dat_hang_page.robot
Resource          ../../../../core/Ban_Hang/banhang_action.robot
Resource          ../../../../core/Ban_Hang/banhang_navigation.robot
Resource          ../../../../core/share/toast_message.robot
Resource          ../../../../core/API/api_soquy.robot
Resource          ../../../../core/share/javascript.robot
Resource          ../../../../core/share/discount.robot
Resource          ../../../../core/API/api_mhbh_dathang.robot

*** Variables ***
&{list_product1}    HH0021=4.75    SIL001=1    DVT20=2.5    DVL001=1    CBKH001=1.5
&{list_product2}    HH0022=1       SIL002=2    DVT21=3      DVL002=1.5    CBKH002=2.5
&{list_product3}    HH0023=1       SIL003=2    DVT22=4      DVL003=1.5    CBKH003=1.8
&{list_product4}    HH0024=3.6     SIL004=1    DVT23=2.4    DVL004=2     CBKH004=3
&{list_product_delete}    CBKH002=2.5    DVT21=3
&{list_product_delete1}    SIL003=2
&{list_productadd}       DV013=1.25    Combo12=2
@{list_nums_update}   1     3.5
@{discount}           15   45000.22    0    5000      150000.45
@{discount_type}      dis   changedown    none     disvnd   changeup
&{discount_del}    SIL003=150000.45
&{discount_type_del}     SIL003=changeup

*** Test Cases ***    List product&nums    List GGSP      List discount type    GGDH       Khách TT
Create order             [Tags]       AEDNOCUS
                      [Template]    edhkl5
                      ${list_product1}     ${discount}     ${discount_type}     0          all

Update order          [Tags]     AEDNOCUS    
                      [Template]    edhkl6
                      ${list_product2}     ${discount}    ${list_nums_update}    ${discount_type}    ${list_product_delete}    ${list_productadd}   10000      100000     Đã đặt cọc     0

Lay 1 phan don hang       [Tags]         AEDNOCUS
                      [Template]    edhkl7
                      ${list_product_delete1}     150000      20    ${list_product3}     ${discount}   ${discount_type}     ${discount_del}   ${discount_type_del}

Lay all phan don hang       [Tags]       AEDNOCUSA
                      [Template]    edhkl8
                      ${list_product4}     200000    ${discount}    ${discount_type}    20000        0

*** Keywords ***
edhkl5
    [Arguments]    ${dict_product_nums}   ${list_ggsp}    ${list_discount_type}   ${input_ggdh}    ${input_khtt}
    #get info product, customer
    ${list_product}    Get Dictionary Keys    ${dict_product_nums}
    ${list_nums}    Get Dictionary Values    ${dict_product_nums}
    ${list_result_thanhtien}    ${list_result_ordersummary}    ${list_result_giamoi}    Get list total sale and order summary incase discount and newprice    ${list_product}    ${list_nums}    ${list_ggsp}    ${list_discount_type}
    #compute
    ${result_tongtienhang}    Sum values in list and round    ${list_result_thanhtien}
    ${result_tongcong}    Run Keyword If    0 < ${input_ggdh} < 100    Price after % discount invoice    ${result_tongtienhang}    ${input_ggdh}
    ...    ELSE IF    ${input_ggdh} > 100    Minus and replace floating point    ${result_tongtienhang}    ${input_ggdh}
    ...    ELSE    Set Variable    ${result_tongtienhang}
    ${result_ggdh}    Run Keyword If    0 < ${input_ggdh} < 100    Convert % discount to VND and round    ${result_tongtienhang}    ${input_ggdh}    ELSE    Set Variable    ${input_ggdh}
    ${result_tongcong}    Replace floating point    ${result_tongcong}
    ${actual_khtt_all}    Set Variable If    '${input_khtt}' == 'all'    ${result_tongcong}    ${input_khtt}
    ${actual_khtt}    Set Variable If    '${input_khtt}' == '0'    0    ${actual_khtt_all}
    #input data into DH form
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${endpoint_danhmuc_hh_co_dvt}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${get_resp}    Get Request and return body    ${endpoint_danhmuc_hh_co_dvt}
    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}    Get list jsonpath product frm list product    ${list_product}
    ${list_giaban}    ${list_result_ggsp}    ${list_id_sp}      Get product info frm list jsonpath product incase discount product    ${get_resp}    ${list_jsonpath_id_sp}
    ...   ${list_jsonpath_giaban}    ${list_ggsp}    ${list_discount_type}
    #post request
    ${liststring_prs_order_detail}     Set Variable      needdel
    Log        ${liststring_prs_order_detail}
    : FOR    ${item_gia_ban}   ${item_id_sp}   ${item_soluong}    ${item_result_ggsp}   ${item_ggsp}      IN ZIP       ${list_giaban}        ${list_id_sp}    ${list_nums}       ${list_result_ggsp}       ${list_ggsp}
    \    ${item_ggsp}   Set Variable If    0 < ${item_ggsp} < 100    ${item_ggsp}   0
    \    ${payload_each_product}        Format string           {{"BasePrice":200000,"IsLotSerialControl":false,"IsRewardPoint":false,"Note":"","Price":{0},"ProductId":{1},"Quantity":{2},"Discount":{3},"DiscountRatio":{4},"ProductCode":"Combo05"}}    ${item_gia_ban}   ${item_id_sp}   ${item_soluong}    ${item_result_ggsp}   ${item_ggsp}
    \    ${liststring_prs_order_detail}       Catenate      SEPARATOR=,      ${liststring_prs_order_detail}      ${payload_each_product}
    ${liststring_prs_order_detail}       Replace String      ${liststring_prs_order_detail}       needdel,       ${EMPTY}      count=1
    ${giamgia_dh}    Set Variable If    0 < ${input_ggdh} < 100    ${input_ggdh}    0
    ${request_payload}    Format String    {{"Order":{{"BranchId":{0},"RetailerId":{1},"SoldById":{2},"SoldBy":{{"CreatedBy":0,"CreatedDate":"2018-07-30T08:27:36.800Z","Email":"","GivenName":"anh.lv","Id":{2},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false}},"SaleChannelId":0,"Seller":{{"CreatedBy":0,"CreatedDate":"2018-07-30T08:27:36.800Z","Email":"","GivenName":"anh.lv","Id":{2},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false}},"Code":"Đặt hàng 1","Discount":{3},"DiscountRatio":{4},"OrderDetails":[{5}],"InvoiceOrderSurcharges":[],"Payments":[{{"Method":"Cash","MethodStr":"Tiền mặt","Amount":{6},"Id":-1}}],"UsingCod":0,"Status":1,"Total":757500,"Extra":"{{\\"Amount\\":0,\\"Method\\":{{\\"Id\\":\\"Cash\\",\\"Label\\":\\"Tiền mặt\\"}}}}","Surcharge":0,"Type":2,"Uuid":"","addToAccount":"0","PayingAmount":0,"TotalBeforeDiscount":757500,"ProductDiscount":0}}}}    ${BRANCH_ID}    ${get_id_nguoitao}    ${get_id_nguoiban}    ${result_ggdh}    ${giamgia_dh}  ${liststring_prs_order_detail}    ${actual_khtt}
    Log    ${request_payload}
    ${order_code}    Post request to create order and return code    ${request_payload}
    #get values
    Sleep    10 s    wait for response to API
    #assert value product
    ${list_order_summary_af_execute}    Get list order summary frm product API    ${list_product}
    : FOR    ${result_tong_dh}    ${order_summary_af_execute}    IN ZIP    ${list_result_order_summary}    ${list_order_summary_af_execute}
    \    Should Be Equal As Numbers    ${order_summary_af_execute}    ${result_tong_dh}
    #assert value order
    ${get_ma_kh_in_dh_af_execute}    ${get_TTDH_in_dh_af_execute}    ${get_tongtienhang_in_dh_af_exxecute}    ${get_khachdatra_in_dh_af_execute}    ${get_giamgia_in_dh_af_execute}    ${get_tongcong_in_dh_af_execute}    ${get_ghichu_in_dh_af_execute}
    ...    Get order info incase discount by order code    ${order_code}
    Should Be Equal As Strings    ${get_ma_kh_in_dh_af_execute}    0
    Should Be Equal As Numbers    ${get_TTDH_in_dh_af_execute}    1    #1 : phiếu tạm
    Run Keyword If    ${input_ggdh} == 0    Should Be Equal As Numbers    ${get_tongcong_in_dh_af_execute}    ${result_tongtienhang}
    ...    ELSE    Should Be Equal As Numbers    ${get_tongtienhang_in_dh_af_exxecute}    ${result_tongtienhang}
    Run Keyword If    ${input_ggdh} == 0    Log    Ignore validate
    ...    ELSE    Should Be Equal As Numbers    ${get_tongtienhang_in_dh_af_exxecute}    ${result_tongtienhang}
    Should Be Equal As Numbers    ${get_khachdatra_in_dh_af_execute}    ${actual_khtt}
    Should Be Equal As Numbers    ${get_giamgia_in_dh_af_execute}    ${result_ggdh}
    Should Be Equal As Numbers    ${get_tongcong_in_dh_af_execute}    ${result_tongcong}
    Delete order frm Order code    ${order_code}

edhkl6
    [Arguments]    ${dict_product_nums}   ${list_ggsp}    ${list_quantity_update}    ${list_discount_type}    ${list_product_delete}   ${list_product_addnew}
    ...      ${input_ggdh}    ${input_khtt}    ${input_ghichu}    ${input_khtt_create_order}
    #get info product, customer
    ${list_product_del}    Get Dictionary Keys    ${list_product_delete}
    ${list_nums_del}    Get Dictionary Values    ${list_product_delete}
    ${list_product_add}    Get Dictionary Keys    ${list_product_addnew}
    ${list_nums_add}    Get Dictionary Values    ${list_product_addnew}
    ${order_code}    Add new order with multi products no customer    ${dict_product_nums}    ${input_khtt_create_order}
    ${get_khachdatra_in_dh_bf_execute}    ${get_tongtienhang_in_dh_bf_execute}    Get paid value frm API    ${order_code}
    ${get_list_hh_in_dh_bf_execute}   ${get_list_sl_in_dh_bf_execute}    Get list product and quantity frm API    ${order_code}
    ${list_result_tongdh_delete}    Get list order summary incase delete product    ${order_code}    ${list_product_del}
    #get order summary and sub total of products
    : FOR    ${ma_hh}   ${number}   IN ZIP     ${list_product_delete}    ${list_nums_del}
    \    Remove Values From List    ${get_list_hh_in_dh_bf_execute}    ${ma_hh}
    \    Remove Values From List    ${get_list_sl_in_dh_bf_execute}    ${number}
    Log    ${get_list_hh_in_dh_bf_execute}
    Log    ${get_list_sl_in_dh_bf_execute}
    ${list_result_thanhtien}    ${list_result_tongdh}    ${list_result_tongdh_add}    ${list_result_giamoi}    ${list_result_giamoi_add}    Get list total sale - order summary incase update quantity and add product    ${order_code}    ${get_list_hh_in_dh_bf_execute}
    ...   ${list_quantity_update}   ${list_ggsp}    ${list_discount_type}    ${list_product_add}    ${list_nums_add}
    #compute
    ${result_tongsoluong}    Sum values in list and round    ${get_list_sl_in_dh_bf_execute}
    ${result_tongtienhang}    Sum values in list and round    ${list_result_thanhtien}
    ${result_ggdh}    Run Keyword If    0 < ${input_ggdh} < 100    Convert % discount to VND and round    ${result_tongtienhang}    ${input_ggdh}
    ...    ELSE    Set Variable    ${input_ggdh}
    ${result_tongcong}    Run Keyword If    0 < ${input_ggdh} < 100    Price after % discount invoice    ${result_tongtienhang}    ${input_ggdh}
    ...    ELSE    Minus and replace floating point    ${result_tongtienhang}    ${input_ggdh}
    ${result_khachcantra}    Minus and replace floating point    ${result_tongcong}    ${get_khachdatra_in_dh_bf_execute}
    ${actual_khtt_all}    Set Variable If    '${input_khtt}' == 'all'    ${result_khachcantra}    ${input_khtt}
    ${actual_khtt}    Set Variable If    '${input_khtt}' == '0'    0    ${actual_khtt_all}
    ${actual_khtt_paymented}    Sum and replace floating point    ${actual_khtt}    ${get_khachdatra_in_dh_bf_execute}
    #delete product into BH form
    ${get_order_id}   ${get_payment_id}   Get order - payment frm order api    ${order_code}
    ${get_list_order_detail_id}   Get list orderdetail id frm order api    ${order_code}    ${get_list_hh_in_dh_bf_execute}
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${endpoint_danhmuc_hh_co_dvt}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${get_resp_danhmuc_hh}    Get Request and return body    ${endpoint_danhmuc_hh_co_dvt}
    #payload product
    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}    Get list jsonpath product frm list product    ${get_list_hh_in_dh_bf_execute}
    ${list_giaban}    ${list_result_ggsp}    ${list_id_sp}     Get product info frm list jsonpath product incase discount product    ${get_resp_danhmuc_hh}    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}
    ...    ${list_ggsp}    ${list_discount_type}
    ${liststring_prs_order_detail}     Set Variable      needdel
    Log        ${liststring_prs_order_detail}
    : FOR    ${item_result_ggsp}   ${item_ggsp}  ${item_orderdetail_id}    ${item_gia_ban}   ${item_id_sp}   ${item_soluong}      IN ZIP       ${list_result_ggsp}       ${list_ggsp}      ${get_list_order_detail_id}       ${list_giaban}        ${list_id_sp}    ${list_quantity_update}
    \    ${item_ggsp}   Set Variable If    0 < ${item_ggsp} < 100    ${item_ggsp}   0
    \    ${payload_each_product}        Format string       {{"BasePrice":1000000,"Discount":{0},"DiscountRatio":{1},"Id":{2},"IsLotSerialControl":false,"IsRewardPoint":false,"Note":"","Price":{3},"ProductCode":"Combo39","ProductId":{4},"ProductName":"Bộ mỹ phẩm 09","Quantity":{5},"Uuid":"","ProductBatchExpireId":null}}       ${item_result_ggsp}   ${item_ggsp}  ${item_orderdetail_id}    ${item_gia_ban}   ${item_id_sp}   ${item_soluong}
    \    ${liststring_prs_order_detail}       Catenate      SEPARATOR=,      ${liststring_prs_order_detail}      ${payload_each_product}
    ${liststring_prs_order_detail}       Replace String      ${liststring_prs_order_detail}       needdel,       ${EMPTY}      count=1
    Log     ${liststring_prs_order_detail}
    #payloadd product add
    ${list_jsonpath_id_sp_add}    ${list_jsonpath_giaban_add}    Get list jsonpath product frm list product    ${list_product_add}
    ${list_giaban_add}    ${list_result_ggsp_add}    ${list_id_sp_add}     Get product info frm list jsonpath product incase discount product    ${get_resp_danhmuc_hh}    ${list_jsonpath_id_sp_add}    ${list_jsonpath_giaban_add}
    ...     ${list_ggsp}    ${list_discount_type}
    ${liststring_prs_order_detail_add}     Set Variable      needdel
    Log        ${liststring_prs_order_detail_add}
    : FOR    ${item_result_ggsp_add}   ${item_ggsp_add}  ${item_gia_ban_add}   ${item_id_sp_add}   ${item_soluong_add}      IN ZIP       ${list_result_ggsp_add}       ${list_ggsp}      ${list_giaban_add}        ${list_id_sp_add}    ${list_nums_add}
    \    ${item_ggsp_add}   Set Variable If    0 < ${item_ggsp} < 100    ${item_ggsp}   0
    \    ${payload_each_product}        Format string       {{"BasePrice":25000.06,"Discount":{0},"DiscountRatio":{1},"IsLotSerialControl":false,"IsMaster":false,"IsRewardPoint":false,"Note":"","Price":{2},"ProductCode":"DV049","ProductId":{3},"ProductName":"Nails 1","Quantity":{4},"SerialNumbers":"","Uuid":"","ProductBatchExpireId":null}}       ${item_result_ggsp_add}   ${item_ggsp_add}  ${item_gia_ban_add}   ${item_id_sp_add}   ${item_soluong_add}
    \    ${liststring_prs_order_detail_add}       Catenate      SEPARATOR=,      ${liststring_prs_order_detail_add}      ${payload_each_product}
    ${liststring_prs_order_detail_add}       Replace String      ${liststring_prs_order_detail_add}       needdel,       ${EMPTY}      count=1
    Log     ${liststring_prs_order_detail_add}
    ${giamgia_dh}    Set Variable If    0 < ${input_ggdh} < 100    ${input_ggdh}    0
    ${request_payload}    Format String    {{"Order":{{"Id":{0},"BranchId":{1},"RetailerId":{2},"SoldById":{3},"SoldBy":{{"CreatedBy":0,"CreatedDate":"2018-12-10T08:33:32.447Z","Email":"","GivenName":"admin","Id":{3},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false,"Name":"admin"}},"SaleChannelId":0,"SaleChannel":null,"Seller":{{"CreatedBy":0,"CreatedDate":"2018-12-10T08:33:32.447Z","Email":"","GivenName":"admin","Id":{3},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false,"Name":"admin"}},"PurchaseDate":"","Code":"{4}","Discount":{5},"DiscountRatio":{6},"OrderDetails":[{7},{8}],"InvoiceOrderSurcharges":[],"Payments":[{{"OrderValue":0,"DocumentValue":0,"PaidValue":0,"NeedPayValue":0,"CustomerName":"","CustomerCode":"","InvoiceCode":"","CustomerDebt":0,"CustomerOldDebt":0,"TargetCode":"","UserName":"","VoucherCampaignId":0,"Version":0,"TransGuid":"00000000000000000000000000000000","DocumentTypeValue":0,"Id":{9},"Code":"TTDH003658","Amount":{10},"AmountOriginal":0,"Method":"Cash","CreatedDate":"","CreatedBy":{3},"RetailerId":{2},"BranchId":{1},"OrderId":{0},"TransDate":"","UserId":{3},"Status":0,"System":false,"DeliveryPayments":[],"PaymentAllocation":[]}},{{"Method":"Cash","MethodStr":"Tiền mặt","Amount":{11},"Id":-2}}],"UsingCod":0,"Status":1,"Total":4693998,"Description":"{12}","Extra":"{{\\"Amount\\":50000,\\"Method\\":{{\\"Id\\":\\"Cash\\",\\"Label\\":\\"Tiền mặt\\"}},\\"activeCustomerGroupId\\":null,\\"ResetPromotion\\":false}}","Surcharge":0,"Type":2,"Uuid":"","addToAccount":"0","PayingAmount":50000,"TotalBeforeDiscount":5813001,"ProductDiscount":290650,"CreatedBy":441968,"CreatedDate":"","InvoiceWarranties":[]}}}}     ${get_order_id}   ${BRANCH_ID}    ${get_id_nguoitao}    ${get_id_nguoiban}
    ...    ${order_code}   ${result_ggdh}    ${giamgia_dh}    ${liststring_prs_order_detail}    ${liststring_prs_order_detail_add}   ${get_payment_id}   ${get_khachdatra_in_dh_bf_execute}   ${actual_khtt}    ${input_ghichu}
    Log    ${request_payload}
    ${order_code}    Post request to create order and return code    ${request_payload}
    #get values
    Sleep    10 s    wait for response to API
    #validate deleted product
    ${list_order_summary_delete_af_execute}    Get list order summary frm product API    ${list_product_del}
    : FOR    ${result_tong_dh_delete}    ${order_summary_delete_af_execute}    IN ZIP    ${list_result_tongdh_delete}    ${list_order_summary_delete_af_execute}
    \    Should Be Equal As Numbers    ${result_tong_dh_delete}    ${order_summary_delete_af_execute}
    #validate product
    ${list_order_summary_af_execute}    Get list order summary frm product API    ${get_list_hh_in_dh_bf_execute}
    : FOR    ${result_tong_dh}    ${order_summary_af_execute}    IN ZIP    ${list_result_tongdh}    ${list_order_summary_af_execute}
    \    Should Be Equal As Numbers    ${order_summary_af_execute}    ${result_tong_dh}
    #validate product add
    ${list_order_summary_add_af_execute}    Get list order summary frm product API    ${list_product_add}
    : FOR    ${result_tong_dh}    ${order_summary_af_execute}    IN ZIP    ${list_result_tongdh_add}    ${list_order_summary_add_af_execute}
    \    Should Be Equal As Numbers    ${order_summary_af_execute}    ${result_tong_dh}
    ${get_ma_kh_in_dh_af_execute}    ${get_TTDH_in_dh_af_execute}    ${get_tongtienhang_in_dh_af_exxecute}    ${get_khachdatra_in_dh_af_execute}    ${get_giamgia_in_dh_af_execute}    ${get_tongcong_in_dh_af_execute}    ${get_ghichu_af_execute}    Get order info have note incase discount by order code    ${order_code}
    Should Be Equal As Strings    ${get_ma_kh_in_dh_af_execute}    0
    Should Be Equal As Numbers    ${get_TTDH_in_dh_af_execute}    1    #1 : phiếu tạm
    Should Be Equal As Numbers    ${get_tongtienhang_in_dh_af_exxecute}    ${result_tongtienhang}
    Should Be Equal As Numbers    ${get_giamgia_in_dh_af_execute}    ${result_ggdh}
    Should Be Equal As Numbers    ${get_tongcong_in_dh_af_execute}    ${result_tongcong}
    Should Be Equal As Numbers    ${get_khachdatra_in_dh_af_execute}    ${actual_khtt_paymented}
    Should Be Equal As Strings    ${get_ghichu_af_execute}    ${input_ghichu}
    Delete order frm Order code    ${order_code}

edhkl7
    [Arguments]    ${list_product_delete}   ${input_khtt}   ${input_ggdh_tocreate}   ${list_product_tocreate}   ${list_ggsp_tocreate}   ${list_discount_type_tocreate}
    ...   ${list_ggsp_delete}   ${list_discount_type_del}
    [Documentation]    1. Get thông tin của khách hàng và product (dòng 2 -7)
    ...    2. Lấy ra tổng đặt hàng và tồn kho của từng sản phẩm, tính toán
    #get info product, customer
    ${order_code}   Add new order incase discount - no payment - no customer   ${input_ggdh_tocreate}   ${list_product_tocreate}   ${list_ggsp_tocreate}   ${list_discount_type_tocreate}
    ${list_product_del}    Get Dictionary Keys    ${list_product_delete}
    ${list_nums_del}    Get Dictionary Values    ${list_product_delete}
    ${list_discount_del}    Get Dictionary Values    ${list_ggsp_delete}
    ${list_disscount_type_del}    Get Dictionary Values    ${list_discount_type_del}
    ${get_ma_kh}    ${get_TTDH}    ${get_tongtienhang_in_dh_bf_execute}    ${get_khachdatra_in_dh_bf_execute}    ${get_ggdh_in_dh_bf_execute}    ${get_tongcong_in_dh_bf_execute}    Get order info incase discount not note by order code    ${order_code}
    ${get_list_hh_in_dh_bf_execute}    ${get_ghichu_bf_execute}   Get ghi chu and list product frm API    ${order_code}
    ${list_result_tongdh_delete}    Get list order summary frm product API    ${list_product_delete}
    #get order summary and sub total of products
    : FOR    ${ma_hh}   ${discount_type_delete}   ${discount_del}   IN ZIP    ${list_product_del}   ${list_disscount_type_del}    ${list_discount_del}
    \    Remove Values From List    ${get_list_hh_in_dh_bf_execute}    ${ma_hh}
    \    Remove Values From List    ${list_discount_type_tocreate}    ${discount_type_delete}
    \    Remove Values From List    ${list_ggsp_tocreate}    ${discount_del}
    Log    ${get_list_hh_in_dh_bf_execute}
    Log    ${list_discount_type_tocreate}
    Log     ${list_ggsp_tocreate}
    ${get_list_nums_in_dh}    Get list quantity by order code    ${order_code}    ${get_list_hh_in_dh_bf_execute}
    ${get_list_status}    Get list imei status thr API    ${get_list_hh_in_dh_bf_execute}
    Create list imei and other product    ${get_list_hh_in_dh_bf_execute}    ${get_list_nums_in_dh}
    ${list_result_tongdh}    ${result_list_toncuoi}    ${result_list_thanhtien}    Get list order summary - total sale - ending stocks frm API    ${order_code}    ${get_list_hh_in_dh_bf_execute}
    ${list_giatri_quydoi}    Get list gia tri quy doi frm product API    ${get_list_hh_in_dh_bf_execute}
    #compute invoice info
    ${result_tongtienhang}    Sum values in list    ${result_list_thanhtien}
    ${result_TTH_tru_ggdh}    Run Keyword If    0 < ${get_ggdh_in_dh_bf_execute} < 100    Price after % discount invoice    ${result_tongtienhang}    ${get_ggdh_in_dh_bf_execute}
    ...    ELSE IF    ${get_ggdh_in_dh_bf_execute} > 100    Minus and replace floating point    ${result_tongtienhang}    ${get_ggdh_in_dh_bf_execute}
    ...    ELSE    Set Variable    ${result_tongtienhang}
    ${result_ggdh}    Run Keyword If    0 < ${get_ggdh_in_dh_bf_execute} < 100    Convert % discount to VND and round    ${result_tongtienhang}    ${get_ggdh_in_dh_bf_execute}
    ...    ELSE    Set Variable    ${get_ggdh_in_dh_bf_execute}
    ${result_khachcantra}    Minus and replace floating point    ${result_TTH_tru_ggdh}    ${get_khachdatra_in_dh_bf_execute}
    ${actual_khtt_all}    Set Variable If    '${input_khtt}' == 'all'    ${result_khachcantra}    ${input_khtt}
    ${actual_khtt}    Set Variable If    '${input_khtt}' == '0'    0    ${actual_khtt_all}
    #compute order info
    ${actual_khtt_paymented}    Sum and replace floating point    ${actual_khtt}    ${get_khachdatra_in_dh_bf_execute}
    #create invoice frm Order
    ${get_order_id}   ${get_payment_id}   Get order - payment frm order api    ${order_code}
    ${get_list_order_detail_id}   Get list orderdetail id frm order api    ${order_code}    ${get_list_hh_in_dh_bf_execute}
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${endpoint_danhmuc_hh_co_dvt}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${get_resp_danhmuc_hh}    Get Request and return body    ${endpoint_danhmuc_hh_co_dvt}
    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}    Get list jsonpath product frm list product    ${get_list_hh_in_dh_bf_execute}
    ${list_giaban}    ${list_result_ggsp}    ${list_id_sp}      Get product info frm list jsonpath product incase discount product    ${get_resp_danhmuc_hh}    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}
    ...    ${list_ggsp_tocreate}    ${list_discount_type_tocreate}
    ${liststring_prs_order_detail}     Set Variable      needdel
    Log        ${liststring_prs_order_detail}
    : FOR    ${item_gia_ban}   ${item_id_sp}   ${item_soluong}    ${item_result_ggsp}   ${item_ggsp}   ${item_orderdetail_id}      IN ZIP      ${list_giaban}        ${list_id_sp}    ${get_list_nums_in_dh}    ${list_result_ggsp}       ${list_ggsp_tocreate}       ${get_list_order_detail_id}
    \    ${item_ggsp}   Set Variable If    0 < ${item_ggsp} < 100    ${item_ggsp}   0
    \    ${payload_each_product}        Format string       {{"BasePrice":650000,"IsLotSerialControl":false,"IsRewardPoint":false,"Note":"","Price":{0},"ProductId":{1},"Quantity":{2},"ProductCode":"Combo58","Discount":{3},"DiscountRatio":{4},"ProductName":"Combo dưỡng da 4","PriceByPromotion":null,"IsMaster":true,"PromotionParentProductId":null,"ProductBatchExpireId":null,"CategoryId":543556,"MasterProductId":{1},"Unit":"","Uuid":"","OrderDetailId":{5},"ProductWarranty":[]}}    ${item_gia_ban}   ${item_id_sp}   ${item_soluong}    ${item_result_ggsp}   ${item_ggsp}   ${item_orderdetail_id}
    \    ${liststring_prs_order_detail}       Catenate      SEPARATOR=,      ${liststring_prs_order_detail}      ${payload_each_product}
    ${liststring_prs_order_detail}       Replace String      ${liststring_prs_order_detail}       needdel,       ${EMPTY}      count=1
    ${giamgia_dh}    Set Variable If    0 < ${get_ggdh_in_dh_bf_execute} < 100    ${get_ggdh_in_dh_bf_execute}    0
    ${request_payload}    Format String    {{"Invoice":{{"BranchId":{0},"RetailerId":{1},"OrderId":{2},"SoldById":{3},"SoldBy":{{"CreatedBy":0,"CreatedDate":"2018-12-10T10:44:15.970Z","Email":"","GivenName":"admin","Id":{3},"IsActive":true,"IsAdmin":true,"Type":0,"UserName":"admin","isDeleted":false,"Name":"admin"}},"SaleChannelId":0,"Seller":{{"CreatedBy":0,"CreatedDate":"2018-12-10T10:44:15.970Z","Email":"","GivenName":"admin","Id":{3},"IsActive":true,"IsAdmin":true,"Type":0,"UserName":"admin","isDeleted":false,"Name":"admin"}},"PriceBookId":0,"OrderCode":"{4}","Code":"Hóa đơn 1","Discount":{5},"DiscountRatio":{6},"InvoiceDetails":[{7}],"InvoiceOrderSurcharges":[],"InvoicePromotions":[],"Payments":[{{"Method":"Cash","MethodStr":"Tiền mặt","Amount":{8},"Id":-1}}],"Status":1,"Total":{9},"Surcharge":0,"Type":1,"Uuid":"","addToAccount":"0","PayingAmount":{8},"OrderPaidAmount":0,"TotalBeforeDiscount":{10},"ProductDiscount":0,"PaidAmount":0,"DebugUuid":"","InvoiceWarranties":[],"CreatedBy":160324}}}}     ${BRANCH_ID}    ${get_id_nguoitao}    ${get_order_id}    ${get_id_nguoiban}
    ...   ${order_code}     ${result_ggdh}    ${giamgia_dh}    ${liststring_prs_order_detail}    ${actual_khtt}   ${result_TTH_tru_ggdh}   ${result_tongtienhang}
    Log    ${request_payload}
    ${invoice_code}    Post request to create invoice and get invoice code    ${request_payload}
    Sleep    10 s    wait for response to API
    #assert value product in invoice
    ${get_list_hh_in_hd_af_execute}    Get list product frm Invoice API    ${invoice_code}
    ${list_soluong_in_hd}    ${list_giatri_quydoi_in_hd}    Get list quantity and gia tri quy doi by invoice code    ${get_list_hh_in_hd_af_execute}    ${invoice_code}
    : FOR    ${ma_hh}    ${result_toncuoi}    ${item_soluong}    ${get_giatri_quydoi}    IN ZIP    ${get_list_hh_in_hd_af_execute}    ${result_list_toncuoi}    ${list_soluong_in_hd}   ${list_giatri_quydoi}
    \    Run Keyword If    '${get_giatri_quydoi}' == '1'    Validate product history frm API    ${invoice_code}    ${ma_hh}    ${result_toncuoi}    ${item_soluong}
    \    ...    ELSE    Validate unit product history frm API    ${invoice_code}    ${ma_hh}    ${result_toncuoi}    ${item_soluong}    ${get_giatri_quydoi}
    #validate deleted product
    ${list_order_summary_delete_af_execute}    Get list order summary frm product API    ${list_product_delete}
    : FOR    ${result_tong_dh_delete}    ${order_summary_delete_af_execute}    IN ZIP    ${list_result_tongdh_delete}    ${list_order_summary_delete_af_execute}
    \    Should Be Equal As Numbers    ${result_tong_dh_delete}    ${order_summary_delete_af_execute}
    #validate product
    ${list_order_summary_af_execute}    Get list order summary frm product API    ${get_list_hh_in_hd_af_execute}
    : FOR    ${result_tong_dh}    ${order_summary_af_execute}    IN ZIP    ${list_result_tongdh}    ${list_order_summary_af_execute}
    \    Should Be Equal As Numbers    ${order_summary_af_execute}    ${result_tong_dh}
    #assert value invoice
    ${get_ma_kh_by_hd}    ${get_tong_tien_hang}    ${get_khachtt_af_execute}    ${get_gghd_af_execute}    ${get_khachcantra}    ${get_trangthai}    ${get_ghichu_in_hd_af_execute}
    ...    Get invoice info have note incase discount by invoice code    ${invoice_code}
    Run Keyword If    ${get_ggdh_in_dh_bf_execute} == 0    Should Be Equal As Numbers    ${get_khachcantra}    ${result_tongtienhang}
    ...    ELSE    Should Be Equal As Numbers    ${get_tong_tien_hang}    ${result_tongtienhang}
    Run Keyword If    ${get_ggdh_in_dh_bf_execute} == 0    Log    Ignore validate
    ...    ELSE    Should Be Equal As Numbers    ${get_tong_tien_hang}    ${result_tongtienhang}
    Should Be Equal As Numbers    ${get_khachcantra}    ${result_khachcantra}
    Should Be Equal As Numbers    ${get_khachtt_af_execute}    ${actual_khtt}
    Should Be Equal As Strings    ${get_ma_kh_by_hd}    0
    Should Be Equal As Numbers    ${get_gghd_af_execute}    ${result_ggdh}
    Should Be Equal As Strings    ${get_trangthai}    Hoàn thành
    Should Be Equal As Strings    ${get_ghichu_in_hd_af_execute}    ${get_ghichu_bf_execute}
    #assert value order
    ${get_ma_kh_in_dh_af_execute}    ${get_TTDH_in_dh_af_execute}    ${get_tongtienhang_in_dh_af_exxecute}    ${get_khachdatra_in_dh_af_execute}    ${get_giamgia_in_dh_af_execute}    ${get_tongcong_in_dh_af_execute}    ${get_ghichu_in_dh_af_execute}
    ...    Get order info have note incase discount by order code    ${order_code}
    Should Be Equal As Strings    ${get_ma_kh_in_dh_af_execute}    0
    Should Be Equal As Numbers    ${get_TTDH_in_dh_af_execute}    2    #trạng thái đang giao hàng
    Should Be Equal As Numbers    ${get_tongtienhang_in_dh_af_exxecute}    ${get_tongtienhang_in_dh_bf_execute}
    Should Be Equal As Numbers    ${get_khachdatra_in_dh_af_execute}    ${actual_khtt_paymented}
    Should Be Equal As Numbers    ${get_giamgia_in_dh_af_execute}    ${get_ggdh_in_dh_bf_execute}
    Should Be Equal As Numbers    ${get_tongcong_in_dh_af_execute}    ${get_tongcong_in_dh_bf_execute}
    Should Be Equal As Strings    ${get_ghichu_in_dh_af_execute}    ${get_ghichu_bf_execute}
    Validate invoice history frm Order    ${order_code}    ${invoice_code}    ${result_TTH_tru_ggdh}
    Delete invoice by invoice code    ${invoice_code}
    Delete order frm Order code    ${order_code}

edhkl8
    [Arguments]    ${list_product_tocreate}    ${input_khtt_tocreate}    ${list_ggsp}   ${list_discount_type}   ${input_gghd}    ${input_khtt}
    #get info product, customer
    ${order_code}    Add new order with multi products no customer    ${list_product_tocreate}    ${input_khtt_tocreate}
    ${get_khachdatra_in_dh_bf_execute}    ${get_tongtienhang_in_dh_bf_execute}    Get paid value frm API    ${order_code}
    ${get_list_hh_in_dh_bf_execute}    ${get_ghichu_bf_execute}   Get ghi chu and list product frm API    ${order_code}
    ${get_list_nums_in_dh}    Get list quantity by order code    ${order_code}    ${get_list_hh_in_dh_bf_execute}
    ${get_list_status}    Get list imei status thr API    ${get_list_hh_in_dh_bf_execute}
    Create list imei and other product    ${get_list_hh_in_dh_bf_execute}    ${get_list_nums_in_dh}
    ${list_result_tong_dh}    ${list_result_toncuoi}    ${result_list_thanhtien}    ${list_result_giamoi}    Get list order summary - total sale - ending stocks incase discount and newprice    ${order_code}    ${get_list_hh_in_dh_bf_execute}    ${list_ggsp}    ${list_discount_type}
    ${list_giatri_quydoi}    Get list gia tri quy doi frm product API    ${get_list_hh_in_dh_bf_execute}
    #compute TTH with product
    ${result_tongtienhang}    Sum values in list    ${result_list_thanhtien}
    ${result_tongsoluong}    Sum values in list    ${get_list_nums_in_dh}
    ${result_TTH_tru_gghd}    Run Keyword If    0 < ${input_gghd} < 100    Price after % discount invoice    ${result_tongtienhang}    ${input_gghd}
    ...    ELSE IF    ${input_gghd} > 100    Minus and replace floating point    ${result_tongtienhang}    ${input_gghd}
    ...    ELSE    Set Variable    ${result_tongtienhang}
    ${result_gghd}    Run Keyword If    0 < ${input_gghd} < 100    Convert % discount to VND and round    ${result_tongtienhang}    ${input_gghd}
    ...    ELSE    Set Variable    ${input_gghd}
    ${result_khachcantra_in_hd}    Minus and replace floating point    ${result_TTH_tru_gghd}    ${get_khachdatra_in_dh_bf_execute}
    ${actual_khcantra_all}    Set Variable If    '${input_khtt}' == 'all'    ${result_khachcantra_in_hd}    ${input_khtt}
    ${actual_khachcantra}    Set Variable If    '${input_khtt}' == '0'    0    ${actual_khcantra_all}
    #compute invoice info to Quan ly
    ${result_khtt}    Run Keyword If    '${input_khtt}' != 'all'    Sum    ${input_khtt}    ${get_khachdatra_in_dh_bf_execute}
    ${actual_khtt_in_hd}    Set Variable If    '${input_khtt}' == 'all'    ${result_TTH_tru_gghd}    ${result_khtt}
    #compute for order
    ${result_khachthanhtoan_in_dh}    Sum and round 2    ${get_khachdatra_in_dh_bf_execute}    ${actual_khachcantra}
    #create invoice frm Order
    ${get_order_id}   ${get_payment_id}   Get order - payment frm order api    ${order_code}
    ${get_list_order_detail_id}   Get list orderdetail id frm order api    ${order_code}    ${get_list_hh_in_dh_bf_execute}
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${endpoint_danhmuc_hh_co_dvt}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${get_resp_danhmuc_hh}    Get Request and return body    ${endpoint_danhmuc_hh_co_dvt}
    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}    Get list jsonpath product frm list product    ${get_list_hh_in_dh_bf_execute}
    ${list_giaban}    ${list_result_ggsp}    ${list_id_sp}      Get product info frm list jsonpath product incase discount product    ${get_resp_danhmuc_hh}    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}
    ...    ${list_ggsp}    ${list_discount_type}
    ${liststring_prs_order_detail}     Set Variable      needdel
    Log        ${liststring_prs_order_detail}
    : FOR    ${item_gia_ban}   ${item_id_sp}   ${item_soluong}    ${item_imei}    ${item_result_ggsp}   ${item_ggsp}   ${item_orderdetail_id}      IN ZIP      ${list_giaban}
    ...    ${list_id_sp}    ${get_list_nums_in_dh}    ${imei_inlist}    ${list_result_ggsp}    ${list_ggsp}       ${get_list_order_detail_id}
    \    ${item_imei}    Convert list to string and return    ${item_imei}
    \     ${item_ggsp}    Set Variable If    0 < ${item_ggsp} < 100    ${item_ggsp}    0
    \    ${payload_each_product}        Format string       {{"BasePrice":175000,"IsLotSerialControl":true,"IsRewardPoint":false,"Note":"","Price":{0},"ProductId":{1},"Quantity":{2},"ProductCode":"SI059","SerialNumbers":"{3}","Discount":{4},"DiscountRatio":{5},"ProductName":"Tủ Lạnh Inverter Panasonic NR-BL267VSV1","PriceByPromotion":null,"IsMaster":true,"PromotionParentProductId":null,"ProductBatchExpireId":null,"CategoryId":543560,"MasterProductId":{1},"Unit":"","Uuid":"","OrderDetailId":{6},"ProductWarranty":[]}}    ${item_gia_ban}   ${item_id_sp}   ${item_soluong}       ${item_imei}    ${item_result_ggsp}   ${item_ggsp}   ${item_orderdetail_id}
    \    ${liststring_prs_order_detail}       Catenate      SEPARATOR=,      ${liststring_prs_order_detail}      ${payload_each_product}
    ${liststring_prs_order_detail}       Replace String      ${liststring_prs_order_detail}       needdel,       ${EMPTY}      count=1
    ${giamgia_hd}    Set Variable If    0 < ${input_gghd} < 100    ${input_gghd}    0
    ${request_payload}    Format String    {{"Invoice":{{"BranchId":{0},"RetailerId":{1},"OrderId":{2},"SoldById":{3},"SoldBy":{{"CreatedBy":0,"CreatedDate":"2018-12-10T10:44:15.970Z","Email":"","GivenName":"admin","Id":{3},"IsActive":true,"IsAdmin":true,"Type":0,"UserName":"admin","isDeleted":false,"Name":"admin"}},"SaleChannelId":0,"Seller":{{"CreatedBy":0,"CreatedDate":"2018-12-10T10:44:15.970Z","Email":"","GivenName":"admin","Id":{3},"IsActive":true,"IsAdmin":true,"Type":0,"UserName":"admin","isDeleted":false,"Name":"admin"}},"PriceBookId":0,"OrderCode":"{4}","Code":"Hóa đơn 1","Discount":{5},"DiscountRatio":{6},"InvoiceDetails":[{7}],"InvoiceOrderSurcharges":[],"InvoicePromotions":[],"Payments":[{{"Method":"Cash","MethodStr":"Tiền mặt","Amount":{8},"Id":-1}}],"Status":1,"Total":{9},"Surcharge":0,"Type":1,"Uuid":"W156396619193254","addToAccount":"0","PayingAmount":{8},"OrderPaidAmount":{10},"DepositReturn":0,"TotalBeforeDiscount":{11},"ProductDiscount":384000,"PaidAmount":1000000,"DebugUuid":"","InvoiceWarranties":[],"CreatedBy":201567}}}}     ${BRANCH_ID}    ${get_id_nguoitao}    ${get_order_id}    ${get_id_nguoiban}
    ...   ${order_code}     ${result_gghd}    ${giamgia_hd}    ${liststring_prs_order_detail}   ${actual_khachcantra}     ${result_TTH_tru_gghd}    ${get_khachdatra_in_dh_bf_execute}    ${result_tongtienhang}
    Log    ${request_payload}
    ${invoice_code}    Post request to create invoice and get invoice code    ${request_payload}
    Sleep    10 s    wait for response to API
    #assert value product in invoice
    ${get_list_hh_in_hd_af_execute}    Get list product frm Invoice API    ${invoice_code}
    ${list_soluong_in_hd}    ${list_giatri_quydoi_in_hd}    Get list quantity and gia tri quy doi by invoice code    ${get_list_hh_in_hd_af_execute}    ${invoice_code}
    : FOR    ${ma_hh}    ${result_toncuoi}    ${item_soluong}    ${get_giatri_quydoi}    IN ZIP    ${get_list_hh_in_hd_af_execute}    ${list_result_toncuoi}    ${list_soluong_in_hd}    ${list_giatri_quydoi}
    \    Run Keyword If    '${get_giatri_quydoi}' == '1'    Validate product history frm API    ${invoice_code}    ${ma_hh}    ${result_toncuoi}    ${item_soluong}
    \    ...    ELSE    Validate unit product history frm API    ${invoice_code}    ${ma_hh}    ${result_toncuoi}   ${item_soluong}    ${get_giatri_quydoi}
    #validate product
    ${list_order_summary_af_execute}    Get list order summary frm product API    ${get_list_hh_in_hd_af_execute}
    : FOR    ${result_tong_dh}    ${order_summary_af_execute}    IN ZIP    ${list_result_tong_dh}    ${list_order_summary_af_execute}
    \    Should Be Equal As Numbers    ${order_summary_af_execute}    ${result_tong_dh}
    #assert value invoice
    ${get_ma_kh_by_hd}    ${get_tong_tien_hang}    ${get_khachtt_af_execute}    ${get_gghd_af_execute}    ${get_khachcantra}    ${get_trangthai}    ${get_ghichu_in_hd_af_execute}
    ...    Get invoice info have note incase discount by invoice code    ${invoice_code}
    Run Keyword If    ${input_gghd} == 0    Should Be Equal As Numbers    ${get_khachcantra}    ${result_tongtienhang}
    ...    ELSE    Should Be Equal As Numbers    ${get_tong_tien_hang}    ${result_tongtienhang}
    Run Keyword If    ${input_gghd} == 0    Log    Ignore validate
    ...    ELSE    Should Be Equal As Numbers    ${get_tong_tien_hang}    ${result_tongtienhang}
    Should Be Equal As Numbers    ${get_khachcantra}    ${result_TTH_tru_gghd}
    Should Be Equal As Numbers    ${get_khachtt_af_execute}    ${actual_khtt_in_hd}
    Should Be Equal As Strings    ${get_ma_kh_by_hd}    0
    Should Be Equal As Numbers    ${get_gghd_af_execute}    ${result_gghd}
    Should Be Equal As Strings    ${get_trangthai}    Hoàn thành
    Should Be Equal As Strings    ${get_ghichu_in_hd_af_execute}    ${get_ghichu_bf_execute}
    #assert value order
    ${get_ma_kh_in_dh_af_execute}    ${get_TTDH_in_dh_af_execute}    ${get_tongtienhang_in_dh_af_exxecute}    ${get_khachdatra_in_dh_af_execute}    ${get_ghichu_af_execute}    Get order info have note by order code    ${order_code}
    Should Be Equal As Strings    ${get_ma_kh_in_dh_af_execute}    0
    Should Be Equal As Strings    ${get_TTDH_in_dh_af_execute}    3    #trạng thái hoàn thành
    Should Be Equal As Numbers    ${get_tongtienhang_in_dh_af_exxecute}    ${get_tongtienhang_in_dh_bf_execute}
    Should Be Equal As Numbers    ${get_khachdatra_in_dh_af_execute}    ${result_khachthanhtoan_in_dh}
    Should Be Equal As Strings    ${get_ghichu_af_execute}    ${get_ghichu_bf_execute}
    Validate invoice history frm Order    ${order_code}    ${invoice_code}    ${result_TTH_tru_gghd}
    Delete invoice by invoice code    ${invoice_code}
    Delete order frm Order code    ${order_code}
