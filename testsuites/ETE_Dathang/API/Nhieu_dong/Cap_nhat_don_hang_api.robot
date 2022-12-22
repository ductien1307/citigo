*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    ${headless_browser}
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
#them 1 dong
&{list_product1}    HH0004=3    SI004=1    DVT04=2.1    DV004=2    Combo04=4
&{list_product2}    HH0006=3    SI005=1    QD005=1    DV005=1.3    Combo05=3
&{list_product3}    HH0007=2    SI006=1    DVT06=2    DV006=4.5    Combo06=3
&{list_product4}    DV007=1
&{list_product5}    Combo07=1
&{list_product_delete01}    HH0004=3    SI004=1
&{list_product_delete02}    QD005=1    DV005=1.3
&{list_product_delete03}    SI006=4.5    Combo06=3
&{list_productadd}    HH0008=3.8    SI007=2   QD025=2
@{list_soluong_update}    1     3.75      4.2
@{discount}     25000     0     2500
@{discount_type}   disvnd    none    changedown
@{list_soluong_addrow}   5,3.4     3.5,1,4.2     2
@{discount_addrow}     10,30    380000.55,20000,10000     0
@{discount_type_addrow}   dis,dis     changeup,changedown,disvnd    none

*** Test Cases ***    Mã KH         List product&nums       GGSP        List quantity udpate       List type discount        List nums add row      GGSP add row       List type discount add row          List product delete       List product add    GGDH       Khách TT     Ghi chú                 Khách thanh toán to create
Them_dong              [Tags]     AEDUM
                      [Template]    etedh_ud1
                      CTKH015       ${list_product1}     ${discount}    ${list_soluong_update}    ${discount_type}   ${list_soluong_addrow}    ${discount_addrow}     ${discount_type_addrow}         ${list_product_delete01}    ${list_productadd}    0          all                 Thanh toán hết                500000
                      CTKH016       ${list_product2}     ${discount}    ${list_soluong_update}    ${discount_type}   ${list_soluong_addrow}    ${discount_addrow}     ${discount_type_addrow}          ${list_product_delete02}    ${list_productadd}   200000      500000            Đã đặt cọc                     0
                      CTKH017       ${list_product3}     ${discount}    ${list_soluong_update}    ${discount_type}   ${list_soluong_addrow}    ${discount_addrow}     ${discount_type_addrow}          ${list_product_delete03}    ${list_productadd}   15          0                 Thanh toán khi nhận hàng       all

Them_dong              [Tags]       AEDUM
                      [Template]    etedh_ud2
                      CTKH018       ${list_product4}     Bảng giá đặt hàng        150000          200000                 Đã đặt cọc

Them_50_dong              [Tags]       AEDUM
                      [Template]    etedh_ud3
                      CTKH019       CTKH011     25          0         Thanh toán khi nhận hàng      Combo07    1    ${list_product5}

*** Keywords ***
etedh_ud1
    [Arguments]    ${input_ma_kh}    ${dict_product_nums}   ${list_ggsp}    ${list_quantity_update}    ${list_discount_type}   ${list_nums_addrow}   ${list_discount_addrow}
    ...   ${list_type_discount_addrow}     ${list_product_delete}   ${list_product_addnew}      ${input_ggdh}    ${input_khtt}    ${input_ghichu}    ${input_khtt_create_order}
    #get info product, customer
    ${list_nums_addrow}   ${list_discount_addrow}    ${list_type_discount_addrow}   Convert three string list to composite list    ${list_nums_addrow}    ${list_discount_addrow}
    ...    ${list_type_discount_addrow}
    ${list_product_del}    Get Dictionary Keys    ${list_product_delete}
    ${list_nums_del}    Get Dictionary Values    ${list_product_delete}
    ${list_product_add}    Get Dictionary Keys    ${list_product_addnew}
    ${list_nums_add}    Get Dictionary Values    ${list_product_addnew}
    ${order_code}    Add new order with multi products    ${input_ma_kh}    ${dict_product_nums}    ${input_khtt_create_order}
    ${get_khachdatra_in_dh_bf_execute}    ${get_tongtienhang_in_dh_bf_execute}    Get paid value frm API    ${order_code}
    ${get_list_hh_in_dh_bf_execute}   ${get_list_sl_in_dh_bf_execute}    Get list product and quantity frm API    ${order_code}
    ${list_result_tongdh_delete}    Get list order summary incase delete product    ${order_code}    ${list_product_del}
    #get order summary and sub total of products
    : FOR    ${ma_hh}   ${number}    IN ZIP     ${list_product_delete}    ${list_nums_del}
    \    Remove Values From List    ${get_list_hh_in_dh_bf_execute}    ${ma_hh}
    \    Remove Values From List    ${get_list_sl_in_dh_bf_execute}    ${number}
    Log    ${get_list_hh_in_dh_bf_execute}
    Log    ${get_list_sl_in_dh_bf_execute}
    ${list_result_thanhtien}    ${list_result_tongdh}    ${list_result_tongdh_add}    ${list_result_giamoi}    ${list_result_giamoi_add}    Get list total sale - order summary incase update quantity and add product    ${order_code}    ${get_list_hh_in_dh_bf_execute}
    ...   ${list_quantity_update}   ${list_ggsp}    ${list_discount_type}    ${list_product_add}    ${list_nums_add}
    ${list_result_thanhtien_addrow}    ${list_result_giamoi_addrow}    ${list_result_order_summary}    Get list total sale - order summary - newprice incase add row product    ${get_list_hh_in_dh_bf_execute}    ${list_nums_addrow}
    ...    ${list_discount_addrow}    ${list_type_discount_addrow}    ${list_result_tongdh}
    ${list_result_thanhtien_addrow_add}    ${list_result_giamoi_addrow_add}    ${list_result_order_summary_add}    Get list total sale - order summary - newprice incase add row product    ${list_product_add}    ${list_nums_addrow}
    ...    ${list_discount_addrow}    ${list_type_discount_addrow}    ${list_result_tongdh_add}
    #compute
    ${result_tongsoluong}    Sum values in list and round    ${get_list_sl_in_dh_bf_execute}
    ${result_tongtienhang_update}    Sum values in list and round    ${list_result_thanhtien}
    ${result_tongtienhang_addrow}    Sum values in list and round    ${list_result_thanhtien_addrow}
    ${result_tongtienhang_addrow_add}    Sum values in list and round    ${list_result_thanhtien_addrow_add}
    ${result_tongtienhang}   Sum x 3    ${result_tongtienhang_update}     ${result_tongtienhang_addrow}    ${result_tongtienhang_addrow_add}
    ${result_ggdh}    Run Keyword If    0 < ${input_ggdh} < 100    Convert % discount to VND and round    ${result_tongtienhang}    ${input_ggdh}
    ...    ELSE    Set Variable    ${input_ggdh}
    ${result_tongcong_in_dh}    Run Keyword If    0 < ${input_ggdh} < 100    Price after % discount invoice    ${result_tongtienhang}    ${input_ggdh}
    ...    ELSE    Minus and replace floating point    ${result_tongtienhang}    ${input_ggdh}
    ${result_khachcantra}    Minus and replace floating point    ${result_tongcong_in_dh}    ${get_khachdatra_in_dh_bf_execute}
    ${actual_khtt_all}    Set Variable If    '${input_khtt}' == 'all'    ${result_khachcantra}    ${input_khtt}
    ${actual_khtt}    Set Variable If    '${input_khtt}' == '0'    0    ${actual_khtt_all}
    ${actual_khtt_paymented}    Sum and replace floating point    ${actual_khtt}    ${get_khachdatra_in_dh_bf_execute}
    #get value
    ${get_order_id}   ${get_payment_id}   Get order - payment frm order api    ${order_code}
    ${get_list_order_detail_id}   Get list orderdetail id frm order api    ${order_code}    ${get_list_hh_in_dh_bf_execute}
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${jsonpath_id_kh}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_kh}
    ${get_id_kh}    Get data from API    ${endpoint_khachhang}    ${jsonpath_id_kh}
    ${endpoint_danhmuc_hh_co_dvt}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${get_resp_danhmuc_hh}    Get Request and return body    ${endpoint_danhmuc_hh_co_dvt}
    #payload product
    ${list_nums}    ${list_discount}    ${list_type_discount}    Add value into three composite list    ${list_nums_addrow}   ${list_discount_addrow}    ${list_type_discount_addrow}
    ...    ${list_quantity_update}   ${list_ggsp}    ${list_discount_type}
    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}    Get list jsonpath product frm list product    ${get_list_hh_in_dh_bf_execute}
    ${list_giaban}    ${list_result_ggsp}    ${list_id_sp}    Get product info frm multi row jsonpath product have discount product    ${get_resp_danhmuc_hh}    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}
    ...    ${list_discount}    ${list_type_discount}
    ${liststring_prs_order_detail}     Create List
    : FOR    ${item_gia_ban}   ${orderdetail_id}   ${item_id_sp}   ${item_soluong}    ${item_result_ggsp}   ${item_ggsp}      IN ZIP       ${list_giaban}
    ...   ${get_list_order_detail_id}   ${list_id_sp}    ${list_nums}   ${list_result_ggsp}  ${list_discount}
    \    ${liststring_prs_order_detail}        Get payload product incase update order     ${item_gia_ban}    ${orderdetail_id}   ${item_id_sp}
    \    ...    ${item_soluong}    ${item_result_ggsp}   ${item_ggsp}      ${liststring_prs_order_detail}
    ${liststring_prs_order_detail}    Convert List to String    ${liststring_prs_order_detail}
    Log     ${liststring_prs_order_detail}
    #payloadd product add
    ${list_nums_addrow}   ${list_discount_addrow}    ${list_type_discount_addrow}    Delete value into three composite list    ${list_nums_addrow}   ${list_discount_addrow}    ${list_type_discount_addrow}
    ...    ${list_quantity_update}   ${list_ggsp}    ${list_discount_type}
    ${list_nums_new}    ${list_discount_new}    ${list_type_discount_new}    Add value into three composite list    ${list_nums_addrow}   ${list_discount_addrow}    ${list_type_discount_addrow}
    ...    ${list_nums_add}      ${list_ggsp}    ${list_discount_type}
    ${list_jsonpath_id_sp_add}    ${list_jsonpath_giaban_add}    Get list jsonpath product frm list product    ${list_product_add}
    ${list_giaban_add}    ${list_result_ggsp_add}    ${list_id_sp_add}    Get product info frm multi row jsonpath product have discount product    ${get_resp_danhmuc_hh}    ${list_jsonpath_id_sp_add}    ${list_jsonpath_giaban_add}
    ...    ${list_discount_new}    ${list_type_discount_new}
    ${liststring_prs_order_detail_add}     Create List
    : FOR    ${item_gia_ban_add}   ${item_id_sp_add}   ${item_soluong_add}    ${item_result_ggsp_add}   ${item_ggsp_add}      IN ZIP       ${list_giaban_add}
    ...   ${list_id_sp_add}    ${list_nums_new}   ${list_result_ggsp_add}  ${list_discount_new}
    \    ${liststring_prs_order_detail_add}        Get payload product incase create order    ${item_gia_ban_add}    ${item_id_sp_add}
    \    ...    ${item_soluong_add}    ${item_result_ggsp_add}   ${item_ggsp_add}      ${liststring_prs_order_detail_add}
    ${liststring_prs_order_detail_add}    Convert List to String    ${liststring_prs_order_detail_add}
    Log     ${liststring_prs_order_detail_add}
    ${giamgia_dh}    Set Variable If    0 < ${input_ggdh} < 100    ${input_ggdh}    0
    ${request_payload}    Format String    {{"Order":{{"Id":{0},"BranchId":{1},"RetailerId":{2},"CustomerId":{3},"SoldById":{4},"SoldBy":{{"CreatedBy":0,"CreatedDate":"2018-12-10T08:33:32.447Z","Email":"","GivenName":"admin","Id":{4},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false,"Name":"admin"}},"SaleChannelId":0,"SaleChannel":null,"Seller":{{"CreatedBy":0,"CreatedDate":"2018-12-10T08:33:32.447Z","Email":"","GivenName":"admin","Id":{4},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false,"Name":"admin"}},"PurchaseDate":"","Code":"{5}","Discount":{6},"DiscountRatio":{7},"OrderDetails":[{8},{9}],"InvoiceOrderSurcharges":[],"Payments":[{{"OrderValue":0,"DocumentValue":0,"PaidValue":0,"NeedPayValue":0,"CustomerName":"","CustomerCode":"","InvoiceCode":"","CustomerDebt":0,"CustomerOldDebt":0,"TargetCode":"","UserName":"","VoucherCampaignId":0,"Version":0,"TransGuid":"00000000000000000000000000000000","DocumentTypeValue":0,"Id":{10},"Code":"TTDH003658","Amount":{11},"AmountOriginal":0,"Method":"Cash","CreatedDate":"","CreatedBy":{4},"RetailerId":{2},"BranchId":{1},"OrderId":{0},"CustomerId":{3},"TransDate":"","UserId":{4},"Status":0,"System":false,"DeliveryPayments":[],"PaymentAllocation":[]}},{{"Method":"Cash","MethodStr":"Tiền mặt","Amount":{12},"Id":-2}}],"UsingCod":0,"Status":1,"Total":4693998,"Description":"{13}","Extra":"{{\\"Amount\\":50000,\\"Method\\":{{\\"Id\\":\\"Cash\\",\\"Label\\":\\"Tiền mặt\\"}},\\"activeCustomerGroupId\\":null,\\"ResetPromotion\\":false}}","Surcharge":0,"Type":2,"Uuid":"","addToAccount":"0","PayingAmount":50000,"TotalBeforeDiscount":5813001,"ProductDiscount":290650,"CreatedBy":441968,"CreatedDate":"","InvoiceWarranties":[]}}}}     ${get_order_id}   ${BRANCH_ID}    ${get_id_nguoitao}    ${get_id_kh}    ${get_id_nguoiban}
    ...    ${order_code}   ${result_ggdh}    ${giamgia_dh}    ${liststring_prs_order_detail}    ${liststring_prs_order_detail_add}   ${get_payment_id}   ${get_khachdatra_in_dh_bf_execute}   ${actual_khtt}    ${input_ghichu}
    Log    ${request_payload}
    ${order_code}    Post request to create order and return code    ${request_payload}
    #get values
    Sleep    20 s    wait for response to API
    #validate deleted product
    ${list_order_summary_delete_af_execute}    Get list order summary frm product API    ${list_product_del}
    : FOR    ${result_tong_dh_delete}    ${order_summary_delete_af_execute}    IN ZIP    ${list_result_tongdh_delete}    ${list_order_summary_delete_af_execute}
    \    Should Be Equal As Numbers    ${result_tong_dh_delete}    ${order_summary_delete_af_execute}
    #validate product
    ${list_order_summary_af_execute}    Get list order summary frm product API    ${get_list_hh_in_dh_bf_execute}
    : FOR    ${result_tong_dh}    ${order_summary_af_execute}    IN ZIP    ${list_result_order_summary}    ${list_order_summary_af_execute}
    \    Should Be Equal As Numbers    ${order_summary_af_execute}    ${result_tong_dh}
    #validate product add
    ${list_order_summary_add_af_execute}    Get list order summary frm product API    ${list_product_add}
    : FOR    ${result_tong_dh}    ${order_summary_af_execute}    IN ZIP    ${list_result_order_summary_add}    ${list_order_summary_add_af_execute}
    \    Should Be Equal As Numbers    ${order_summary_af_execute}    ${result_tong_dh}
    ${get_ma_kh_in_dh_af_execute}    ${get_TTDH_in_dh_af_execute}    ${get_tongtienhang_in_dh_af_exxecute}    ${get_khachdatra_in_dh_af_execute}
    ...    ${get_giamgia_in_dh_af_execute}    ${get_tongcong_in_dh_af_execute}    ${get_ghichu_af_execute}    Get order info have note incase discount by order code    ${order_code}
    Should Be Equal As Strings    ${get_ma_kh_in_dh_af_execute}    ${input_ma_kh}
    Should Be Equal As Numbers    ${get_TTDH_in_dh_af_execute}    1    #1 : phiếu tạm
    Should Be Equal As Numbers    ${get_tongtienhang_in_dh_af_exxecute}    ${result_tongtienhang}
    Should Be Equal As Numbers    ${get_giamgia_in_dh_af_execute}    ${input_ggdh}
    Should Be Equal As Numbers    ${get_tongcong_in_dh_af_execute}    ${result_tongcong_in_dh}
    Should Be Equal As Numbers    ${get_khachdatra_in_dh_af_execute}    ${actual_khtt_paymented}
    Should Be Equal As Strings    ${get_ghichu_af_execute}    ${input_ghichu}
    Delete order frm Order code    ${order_code}
    After Test

etedh_ud2
    [Arguments]    ${input_ma_kh}     ${dict_product_nums}    ${input_ten_bangia}   ${input_ggdh}    ${input_khtt}    ${input_ghichu}
    #get info product, customer
    ${order_code}    Add new order with multi product and no payment - get order code    ${input_ma_kh}    ${dict_product_nums}
    ${get_khachdatra_in_dh_bf_execute}    ${get_tongtienhang_in_dh_bf_execute}    Get paid value frm API    ${order_code}
    ${get_list_hh_in_dh_bf_execute}   ${get_list_sl_in_dh_bf_execute}    Get list product and quantity frm API    ${order_code}
    ${list_tongdh_bf_execute}    Get list order summary frm product API    ${get_list_hh_in_dh_bf_execute}
    #get order summary and sub total of products
    ${get_id_banggia}    ${list_giaban_new}    Get list gia ban from PriceBook api    ${input_ten_bangia}    ${get_list_hh_in_dh_bf_execute}
    #compute
    ${list_result_thanhtien}    Create List
    ${list_result_tongdh}    Create List
    : FOR    ${soluong}    ${giaban}   ${get_tongdh}   IN ZIP   ${get_list_sl_in_dh_bf_execute}    ${list_giaban_new}  ${list_tongdh_bf_execute}
    \    ${result_thanhtien_addrow}    Multiplication and round    1    ${giaban}
    \    ${reuslt_thanhtien}   Multiplication and round    ${soluong}    ${giaban}
    \    ${result_tongdh}   Sum   ${get_tongdh}   1
    \    Append To List    ${list_result_thanhtien}    ${result_thanhtien_addrow}
    \    Append To List    ${list_result_thanhtien}    ${reuslt_thanhtien}
    \    Append To List    ${list_result_tongdh}    ${result_tongdh}
    ${result_tongtienhang}    Sum values in list and round    ${list_result_thanhtien}
    ${result_tongsoluong}    Sum values in list and round    ${get_list_sl_in_dh_bf_execute}
    ${result_ggdh}    Run Keyword If    0 < ${input_ggdh} < 100    Convert % discount to VND and round    ${result_tongtienhang}    ${input_ggdh}
    ...    ELSE    Set Variable    ${input_ggdh}
    ${result_tongcong_in_dh}    Minus and replace floating point    ${result_tongtienhang}    ${result_ggdh}
    ${result_khachcantra}    Minus and replace floating point    ${result_tongcong_in_dh}    ${get_khachdatra_in_dh_bf_execute}
    ${actual_khtt_all}    Set Variable If    '${input_khtt}' == 'all'    ${result_khachcantra}    ${input_khtt}
    ${actual_khtt}    Set Variable If    '${input_khtt}' == '0'    0    ${actual_khtt_all}
    ${actual_khtt_paymented}    Sum and replace floating point    ${actual_khtt}    ${get_khachdatra_in_dh_bf_execute}
    ${result_actual_khtt}    Set Variable If    '${input_khtt}' == 'all'    ${actual_khtt}    ${actual_khtt_paymented}
    #update BG into DH form
    ${get_order_id}   ${get_payment_id}   Get order - payment frm order api    ${order_code}
    ${get_list_order_detail_id}   Get list orderdetail id frm order api    ${order_code}    ${get_list_hh_in_dh_bf_execute}
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${jsonpath_id_kh}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_kh}
    ${get_id_kh}    Get data from API    ${endpoint_khachhang}    ${jsonpath_id_kh}
    ${endpoint_danhmuc_hh_co_dvt}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${get_resp_danhmuc_hh}    Get Request and return body    ${endpoint_danhmuc_hh_co_dvt}
    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}    Get list jsonpath product frm list product    ${get_list_hh_in_dh_bf_execute}
    ${list_giaban}    ${list_id_sp}    Get product info frm list jsonpath product    ${get_resp_danhmuc_hh}    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}
    ${liststring_prs_order_detail}     Set Variable      needdel
    :FOR      ${id_product}   ${gia_ban}    ${orderdetail_id}  ${nums}    IN ZIP    ${list_id_sp}    ${list_giaban_new}    ${get_list_order_detail_id}   ${get_list_sl_in_dh_bf_execute}
    \         ${result}   Sum   ${gia_ban}   ${nums}
    Log        ${liststring_prs_order_detail}
    : FOR    ${item}      IN RANGE      2
    \    ${payload_each_product}        Format string           {{"BasePrice":35000,"Discount":0,"DiscountRatio":0,"Id":{0},"IsBatchExpireControl":false,"IsLotSerialControl":false,"IsMaster":false,"IsRewardPoint":false,"MaxQuantity":0,"Note":"","Price":{1},"ProductCode":"HH0040","ProductId":{2},"ProductName":"Kẹo Mút Chupa Chups Hương Trái Cây","Quantity":{3},"SerialNumbers":"","Uuid":"","OriginPrice":{1},"ProductBatchExpireId":null}}    ${orderdetail_id}   ${gia_ban}    ${id_product}  ${nums}
    \    ${liststring_prs_order_detail}       Catenate      SEPARATOR=,      ${liststring_prs_order_detail}      ${payload_each_product}
    ${liststring_prs_order_detail}       Replace String      ${liststring_prs_order_detail}       needdel,       ${EMPTY}      count=1
    Log    ${liststring_prs_order_detail}
    ${giamgia_dh}    Set Variable If    0 < ${input_ggdh} < 100    ${input_ggdh}    0
    #payload product
    ${request_payload}    Format String    {{"Order":{{"Id":{0},"BranchId":{1},"RetailerId":{2},"CustomerId":{3},"SoldById":{4},"SoldBy":{{"CreatedBy":0,"CreatedDate":"2018-12-10T10:44:15.970Z","Email":"","GivenName":"admin","Id":{4},"IsActive":true,"IsAdmin":true,"Type":0,"UserName":"admin","isDeleted":false,"Name":"admin"}},"SaleChannelId":0,"SaleChannel":null,"Seller":{{"CreatedBy":0,"CreatedDate":"2018-12-10T10:44:15.970Z","Email":"","GivenName":"admin","Id":{4},"IsActive":true,"IsAdmin":true,"Type":0,"UserName":"admin","isDeleted":false,"Name":"admin"}},"PricebookId":{5},"PurchaseDate":"","Code":"DH001258","Discount":{6},"OrderDetails":[{7}],"InvoiceOrderSurcharges":[],"Payments":[{{"Method":"Cash","MethodStr":"Tiền mặt","Amount":{8},"Id":-1}}],"UsingCod":0,"Status":1,"Total":1554774,"Description":"{9}","Extra":"{{\\"Amount\\":0,\\"Method\\":{{\\"Id\\":\\"Cash\\",\\"Label\\":\\"Tiền mặt\\"}},\\"PriceBookId\\":{{\\"CreatedBy\\":{4},\\"CreatedDate\\":\\"2019-03-15T10:03:14.523Z\\",\\"EndDate\\":\\"2020-03-14T10:03:04.220Z\\",\\"ForAllCusGroup\\":true,\\"Id\\":{5},\\"IsActive\\":true,\\"IsGlobal\\":true,\\"Name\\":\\"Bảng giá đặt hàng\\",\\"PriceBookCustomerGroups\\":[],\\"RetailerId\\":{2},\\"StartDate\\":\\"2019-03-15T10:03:04.220Z\\"}},\\"ResetPromotion\\":false}}","Surcharge":0,"Type":2,"Uuid":"W156325170059267","addToAccount":"0","PayingAmount":0,"TotalBeforeDiscount":1671800,"ProductDiscount":0,"CreatedBy":160324,"CreatedDate":"","InvoiceWarranties":[]}}}}     ${get_order_id}   ${BRANCH_ID}    ${get_id_nguoitao}    ${get_id_kh}    ${get_id_nguoiban}
    ...   ${get_id_banggia}   ${input_ggdh}   ${liststring_prs_order_detail}   ${input_khtt}   ${input_ghichu}
    Log    ${request_payload}
    ${order_code}    Post request to create order and return code    ${request_payload}
    #get values
    Sleep    20 s    wait for response to API
    #validate product
    ${list_order_summary_af_execute}    Get list order summary frm product API    ${get_list_hh_in_dh_bf_execute}
    : FOR    ${ma_hh}    ${giaban_new}    ${result_tong_dh}    ${order_summary_af_execute}    IN ZIP    ${get_list_hh_in_dh_bf_execute}    ${list_giaban_new}    ${list_result_tongdh}    ${list_order_summary_af_execute}
    \    Should Be Equal As Numbers    ${order_summary_af_execute}    ${result_tong_dh}
    \    Validate price when change pricebook    ${ma_hh}    ${order_code}    ${giaban_new}
    #assert value order
    ${get_ma_kh_in_dh_af_execute}    ${get_TTDH_in_dh_af_execute}    ${get_tongtienhang_in_dh_af_exxecute}    ${get_khachdatra_in_dh_af_execute}    ${get_giamgia_in_dh_af_execute}    ${get_tongcong_in_dh_af_execute}    ${get_ghichu_af_execute}    Get order info have note incase discount by order code    ${order_code}
    Should Be Equal As Strings    ${get_ma_kh_in_dh_af_execute}    ${input_ma_kh}
    Should Be Equal As Numbers    ${get_TTDH_in_dh_af_execute}    1    #1 : phiếu tạm
    Should Be Equal As Numbers    ${get_tongtienhang_in_dh_af_exxecute}    ${result_tongtienhang}
    Should Be Equal As Numbers    ${get_giamgia_in_dh_af_execute}    ${result_ggdh}
    Should Be Equal As Numbers    ${get_tongcong_in_dh_af_execute}    ${result_tongcong_in_dh}
    Should Be Equal As Numbers    ${get_khachdatra_in_dh_af_execute}    ${actual_khtt_paymented}
    Should Be Equal As Strings    ${get_ghichu_af_execute}    ${input_ghichu}
    Delete order frm Order code    ${order_code}
    After Test

etedh_ud3
    [Arguments]    ${input_ma_kh}    ${input_ma_kh_update}    ${input_ggdh}    ${input_khtt}    ${input_ghichu}    ${product}    ${nums}    ${dic_product_nums}
    #get info product, customer
    ${order_code}    Add new order with multi product and no payment - get order code    ${input_ma_kh}    ${dic_product_nums}
    ${get_khachdatra_in_dh_bf_execute}    ${get_tongtienhang_in_dh_bf_execute}    Get paid value frm API    ${order_code}
    ${get_no_bf_execute}    ${get_tongban_bf_execute}    ${get_tongban_tru_trahang_bf_execute}    Get Customer Debt from API    ${input_ma_kh}
    ${get_no_kh_update_bf_execute}    ${get_tongban_kh_update_bf_execute}    ${get_tongban_tru_trahang_kh_update_bf_execute}    Get Customer Debt from API    ${input_ma_kh_update}
    ${get_tenhang_af_purchase}    ${get_giaban_bf_purchase}    Get product name and price frm API    ${product}
    #compute
    ${get_order_summary}    Get order summary frm product API    ${product}
    ${result_tongso_dh}    Sum   ${get_order_summary}    50
    ${result_thanhtien}    Multiplication and round    ${get_giaban_bf_purchase}    ${nums}
    ${result_thanhtien_addrow}    Multiplication and round    ${get_giaban_bf_purchase}    50
    ${result_tongtienhang}    Sum and round     ${result_thanhtien}    ${result_thanhtien_addrow}
    ${result_ggdh}    Run Keyword If    0 < ${input_ggdh} < 100    Convert % discount to VND and round    ${result_tongtienhang}    ${input_ggdh}    ELSE    Set Variable    ${input_ggdh}
    ${result_tongcong_in_dh}    Minus and round     ${result_tongtienhang}    ${result_ggdh}
    ${actual_khtt_all}    Set Variable If    '${input_khtt}' == 'all'    ${result_tongcong_in_dh}    ${input_khtt}
    ${actual_khtt}    Set Variable If    '${input_khtt}' == '0'    0    ${actual_khtt_all}
    ${actual_khtt_paymented}    Sum and replace floating point    ${actual_khtt}    ${get_khachdatra_in_dh_bf_execute}
    ${result_actual_khtt}    Set Variable If    ${get_khachdatra_in_dh_bf_execute} > 0 and '${input_khtt}' == 'all'    ${actual_khtt}    ${actual_khtt_paymented}    #tính lại tổng cộng với đơn hàng đã đặt cọc khi thay đổi khách hàng
    #du no khach hang
    ${result_no_hientai_kh}    Minus and replace floating point    ${get_no_bf_execute}    ${get_khachdatra_in_dh_bf_execute}
    ${result_tongban_kh}    Minus and replace floating point    ${get_tongban_bf_execute}    ${get_khachdatra_in_dh_bf_execute}
    ${result_no_hientai_kh_update}    Minus and replace floating point    ${get_no_kh_update_bf_execute}    ${actual_khtt}
    #update data into order form
    ${get_order_id}   ${get_payment_id}   Get order - payment frm order api    ${order_code}
    ${get_order_detail_id}   Get orderdetail id frm order api    ${order_code}    ${product}
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${jsonpath_id_kh}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_kh_update}
    ${get_id_kh}    Get data from API    ${endpoint_khachhang}    ${jsonpath_id_kh}
    ${endpoint_danhmuc_hh_co_dvt}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${get_resp_danhmuc_hh}    Get Request and return body    ${endpoint_danhmuc_hh_co_dvt}
    ${id_product}   Get product id thr API    ${product}
    ${liststring_prs_order_detail}     Set Variable      needdel
    Log        ${liststring_prs_order_detail}
    : FOR    ${item}      IN RANGE      51
    \    ${payload_each_product}        Format string           {{"BasePrice":35000,"Discount":0,"DiscountRatio":0,"Id":{0},"IsBatchExpireControl":false,"IsLotSerialControl":false,"IsMaster":false,"IsRewardPoint":false,"MaxQuantity":0,"Note":"","Price":{1},"ProductCode":"HH0040","ProductId":{2},"ProductName":"Kẹo Mút Chupa Chups Hương Trái Cây","Quantity":{3},"SerialNumbers":"","Uuid":"","OriginPrice":{1},"ProductBatchExpireId":null}}    ${get_order_detail_id}   ${get_giaban_bf_purchase}   ${id_product}  ${nums}
    \    ${liststring_prs_order_detail}       Catenate      SEPARATOR=,      ${liststring_prs_order_detail}      ${payload_each_product}
    ${liststring_prs_order_detail}       Replace String      ${liststring_prs_order_detail}       needdel,       ${EMPTY}      count=1
    Log    ${liststring_prs_order_detail}
    ${giamgia_dh}    Set Variable If    0 < ${input_ggdh} < 100    ${input_ggdh}    0
    ${request_payload}    Format String    {{"Order":{{"Id":{0},"BranchId":{1},"RetailerId":{2},"CustomerId":{3},"SoldById":{4},"SoldBy":{{"CreatedBy":0,"CreatedDate":"2018-12-10T10:44:15.970Z","Email":"","GivenName":"admin","Id":{4},"IsActive":true,"IsAdmin":true,"Type":0,"UserName":"admin","isDeleted":false,"Name":"admin"}},"SaleChannelId":0,"SaleChannel":null,"Seller":{{"CreatedBy":0,"CreatedDate":"2018-12-10T10:44:15.970Z","Email":"","GivenName":"admin","Id":{4},"IsActive":true,"IsAdmin":true,"Type":0,"UserName":"admin","isDeleted":false,"Name":"admin"}},"PurchaseDate":"","Code":"DH001317","Discount":{5},"DiscountRatio":{6},"OrderDetails":[{7}],"InvoiceOrderSurcharges":[],"Payments":[{{"Method":"Cash","MethodStr":"Tiền mặt","Amount":{8},"Id":-1}}],"UsingCod":0,"Status":1,"Total":1671800,"Description":"{9}","Extra":"{{\\"Amount\\":1000000,\\"Method\\":{{\\"Id\\":\\"Cash\\",\\"Label\\":\\"Tiền mặt\\"}},\\"ResetPromotion\\":false}}","Surcharge":0,"Type":2,"Uuid":"","addToAccount":"0","PayingAmount":1000000,"TotalBeforeDiscount":1671800,"ProductDiscount":0,"CreatedBy":160324,"CreatedDate":"","InvoiceWarranties":[]}}}}     ${get_order_id}   ${BRANCH_ID}    ${get_id_nguoitao}    ${get_id_kh}    ${get_id_nguoiban}
    ...    ${result_ggdh}    ${giamgia_dh}   ${liststring_prs_order_detail}   ${actual_khtt}    ${input_ghichu}
    Log    ${request_payload}
    ${order_code}    Post request to create order and return code    ${request_payload}
    #get values
    Sleep    20 s    wait for response to API
    #assert value product
    ${order_summary_af_execute}    Get order summary by order code    ${order_code}
    Should Be Equal As Numbers    ${order_summary_af_execute}    ${result_tongso_dh}
    #assert value order
    ${get_ma_kh_in_dh_af_execute}    ${get_TTDH_in_dh_af_execute}    ${get_tongtienhang_in_dh_af_exxecute}    ${get_khachdatra_in_dh_af_execute}    ${get_giamgia_in_dh_af_execute}    ${get_tongcong_in_dh_af_execute}    ${get_ghichu_af_execute}    Get order info have note incase discount by order code    ${order_code}
    Should Be Equal As Strings    ${get_ma_kh_in_dh_af_execute}    ${input_ma_kh_update}
    Should Be Equal As Numbers    ${get_TTDH_in_dh_af_execute}    1    #1 : phiếu tạm
    Should Be Equal As Numbers    ${get_tongtienhang_in_dh_af_exxecute}    ${result_tongtienhang}
    Should Be Equal As Numbers    ${get_giamgia_in_dh_af_execute}    ${input_ggdh}
    Should Be Equal As Numbers    ${get_tongcong_in_dh_af_execute}    ${result_tongcong_in_dh}
    Should Be Equal As Numbers    ${get_khachdatra_in_dh_af_execute}    ${actual_khtt_paymented}
    Should Be Equal As Strings    ${get_ghichu_af_execute}    ${input_ghichu}
    #assert value khach hang after delete
    ${get_no_af_execute}    ${get_tongban_af_execute}    ${get_tongban_tru_trahang_af_execute}    Get Customer Debt from API    ${input_ma_kh}
    Should Be Equal As Numbers    ${get_no_af_execute}    ${result_no_hientai_kh}
    Should Be Equal As Numbers    ${get_tongban_af_execute}    ${result_tongban_kh}
    Delete order frm Order code    ${order_code}
    After Test
