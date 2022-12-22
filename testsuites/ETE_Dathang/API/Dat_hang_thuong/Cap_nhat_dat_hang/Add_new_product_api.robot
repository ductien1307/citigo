*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}      ${headless_browser}
Resource          ../../../../../core/API/api_danhmuc_hanghoa.robot
Resource          ../../../../../core/API/api_dathang.robot
Resource          ../../../../../core/API/api_khachhang.robot
Resource          ../../../../../core/API/api_mhbh.robot
Resource          ../../../../../core/API/api_mhbh_dathang.robot
Resource          ../../../../../core/Dat_Hang/dat_hang_action.robot
Resource          ../../../../../core/Dat_Hang/dat_hang_navigation.robot
Resource          ../../../../../core/Dat_Hang/dat_hang_page.robot
Resource          ../../../../../core/share/toast_message.robot
Resource          ../../../../../core/API/api_soquy.robot
Resource          ../../../../../config/env_product/envi.robot
Library           Collections
*** Variables ***
&{list_product_u1}    SI027=1    QD103=2.4    DV052=2    Combo28=3
@{discount}    15    20000    0    250000.55
@{discount_type}   dis     disvnd    none    changedown

*** Test Cases ***    Mã khách hàng    List product&nums     List GGSP        List discount type       GGDH       Khách thanh toán    Product to create    Nums to create   GGSP to create    Discount type       Payment create    Ghi chú
Add new product            [Tags]           AEDU
                      [Template]       aetedh_ud1
                      CTKH087          ${list_product_u1}    ${discount}       ${discount_type}         15         all                HH0044               3.6                  80000         changeup         0               Thanh toán khi nhận hàng

*** Keywords ***
aetedh_ud1
    [Arguments]    ${input_ma_kh}    ${dict_product_nums}    ${list_ggsp}   ${list_discount_type}    ${input_ggdh}    ${input_khtt}
    ...    ${input_ma_hh}    ${input_soluong}   ${input_ggsp}   ${input_discount_type}    ${input_khtt_create_order}   ${input_ghichu}
    #get info product, customer
    ${order_code}    Add new order frm API    ${input_ma_kh}    ${input_ma_hh}    ${input_soluong}    ${input_khtt_create_order}
    Sleep    5s
    ${list_product}    Get Dictionary Keys    ${dict_product_nums}
    ${list_nums}    Get Dictionary Values    ${dict_product_nums}
    ${get_list_hh_in_order}    ${get_list_sl_in_order}   Get list product and quantity frm API    ${order_code}
    ${list_result_order_summary}    Get list result order summary frm product API    ${list_product}    ${list_nums}
    :FOR    ${item_hanghoa}   ${item_num}   IN ZIP          ${get_list_hh_in_order}    ${get_list_sl_in_order}
    \   Append To List    ${list_product}   ${item_hanghoa}
    \   Append To List    ${list_nums}   ${item_num}
    Append To List    ${list_ggsp}    ${input_ggsp}
    Append To List    ${list_discount_type}    ${input_discount_type}
    ${get_khachdatra_in_dh_bf_execute}    ${get_tongtienhang_in_dh_bf_execute}    Get paid value frm API    ${order_code}
    ${get_no_bf_execute}    ${get_tongban_bf_execute}    ${get_tongban_tru_trahang_bf_execute}    Get Customer Debt from API    ${input_ma_kh}
    Sleep    5s
    ${get_tongso_dh_bf_execute}    Get order summary by order code    ${order_code}
    #get value to Validate
    ${list_result_thanhtien}    Get result list total sale incase discount    ${list_product}    ${list_nums}    ${list_ggsp}   ${list_discount_type}
    #compute
    ${result_tongtienhang}    Sum values in list and round    ${list_result_thanhtien}
    ${result_tongcong_in_dh}    Run Keyword If    0 < ${input_ggdh} < 100    Price after % discount invoice    ${result_tongtienhang}    ${input_ggdh}
    ...    ELSE    Minus and replace floating point    ${result_tongtienhang}    ${input_ggdh}
    ${result_ggdh}    Run Keyword If    0 < ${input_ggdh} < 100    Convert % discount to VND and round    ${result_tongtienhang}    ${input_ggdh}    ELSE    Set Variable    ${input_ggdh}
    ${result_khachcantra}    Minus and replace floating point    ${result_tongcong_in_dh}    ${get_khachdatra_in_dh_bf_execute}
    ${actual_khtt_all}    Set Variable If    '${input_khtt}' == 'all'    ${result_khachcantra}    ${input_khtt}
    ${actual_khtt}    Set Variable If    '${input_khtt}' == '0'    0    ${actual_khtt_all}
    ${actual_khtt_paymented}    Sum and replace floating point    ${actual_khtt}    ${get_khachdatra_in_dh_bf_execute}
    ${result_no_hientai_kh}    Minus and replace floating point    ${get_no_bf_execute}    ${actual_khtt}    #Do đơn đặt hàng không được ghi nhận vào công nợ mà chỉ ghi nhận phiếu thanh toán của đơn đặt hàng nên sẽ thành công thức trừ
    #create order by API
    ${get_order_id}   ${get_payment_id}   Get order - payment frm order api    ${order_code}
    ${get_list_order_detail_id}   Get list orderdetail id frm order api    ${order_code}    ${list_product}
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${jsonpath_id_kh}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_kh}
    ${get_id_kh}    Get data from API    ${endpoint_khachhang}    ${jsonpath_id_kh}
    ${endpoint_danhmuc_hh_co_dvt}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${get_resp_danhmuc_hh}    Get Request and return body    ${endpoint_danhmuc_hh_co_dvt}
    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}    Get list jsonpath product frm list product    ${list_product}
    ${list_giaban}    ${list_result_ggsp}    ${list_id_sp}    Get product info frm list jsonpath product incase discount product    ${get_resp_danhmuc_hh}    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}
    ...    ${list_ggsp}   ${list_discount_type}
    ${liststring_prs_order_detail}     Set Variable      needdel
    Log        ${liststring_prs_order_detail}
    : FOR    ${item_result_ggsp}   ${item_ggsp}  ${item_orderdetail_id}    ${item_gia_ban}   ${item_id_sp}   ${item_soluong}      IN ZIP       ${list_result_ggsp}       ${list_ggsp}      ${get_list_order_detail_id}       ${list_giaban}        ${list_id_sp}    ${list_nums}
    \     ${item_ggsp}    Set Variable If    0 < ${item_ggsp} < 100    ${item_ggsp}     0
    \    ${payload_each_product}        Format string       {{"BasePrice":1000000,"Discount":{0},"DiscountRatio":{1},"Id":{2},"IsLotSerialControl":false,"IsRewardPoint":false,"Note":"","Price":{3},"ProductCode":"Combo39","ProductId":{4},"ProductName":"Bộ mỹ phẩm 09","Quantity":{5},"Uuid":"","ProductBatchExpireId":null}}       ${item_result_ggsp}   ${item_ggsp}  ${item_orderdetail_id}    ${item_gia_ban}   ${item_id_sp}   ${item_soluong}
    \    ${liststring_prs_order_detail}       Catenate      SEPARATOR=,      ${liststring_prs_order_detail}      ${payload_each_product}
    ${liststring_prs_order_detail}       Replace String      ${liststring_prs_order_detail}       needdel,       ${EMPTY}      count=1
    ${giamgia_dh}    Set Variable If    0 < ${input_ggdh} < 100    ${input_ggdh}    0
    ${request_payload}    Format String    {{"Order":{{"Id":{0},"BranchId":{1},"RetailerId":{2},"CustomerId":{3},"SoldById":{4},"SoldBy":{{"CreatedBy":0,"CreatedDate":"2018-12-10T08:33:32.447Z","Email":"","GivenName":"admin","Id":{4},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false,"Name":"admin"}},"SaleChannelId":0,"SaleChannel":null,"Seller":{{"CreatedBy":0,"CreatedDate":"2018-12-10T08:33:32.447Z","Email":"","GivenName":"admin","Id":{4},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false,"Name":"admin"}},"PurchaseDate":"","Code":"{5}","Discount":{6},"DiscountRatio":{7},"OrderDetails":[{8}],"InvoiceOrderSurcharges":[],"Payments":[{{"OrderValue":0,"DocumentValue":0,"PaidValue":0,"NeedPayValue":0,"CustomerName":"","CustomerCode":"","InvoiceCode":"","CustomerDebt":0,"CustomerOldDebt":0,"TargetCode":"","UserName":"","VoucherCampaignId":0,"Version":0,"TransGuid":"00000000000000000000000000000000","DocumentTypeValue":0,"Id":{9},"Code":"TTDH003658","Amount":{10},"AmountOriginal":0,"Method":"Cash","CreatedDate":"","CreatedBy":{4},"RetailerId":{2},"BranchId":{1},"OrderId":{0},"CustomerId":{3},"TransDate":"","UserId":{4},"Status":0,"System":false,"DeliveryPayments":[],"PaymentAllocation":[]}},{{"Method":"Cash","MethodStr":"Tiền mặt","Amount":{11},"Id":-2}}],"UsingCod":0,"Status":1,"Total":4693998,"Description":"{12}","Extra":"{{\\"Amount\\":50000,\\"Method\\":{{\\"Id\\":\\"Cash\\",\\"Label\\":\\"Tiền mặt\\"}},\\"activeCustomerGroupId\\":null,\\"ResetPromotion\\":false}}","Surcharge":0,"Type":2,"Uuid":"","addToAccount":"0","PayingAmount":50000,"TotalBeforeDiscount":5813001,"ProductDiscount":290650,"CreatedBy":441968,"CreatedDate":"","InvoiceWarranties":[]}}}}     ${get_order_id}   ${BRANCH_ID}    ${get_id_nguoitao}    ${get_id_kh}    ${get_id_nguoiban}
    ...    ${order_code}   ${result_ggdh}    ${giamgia_dh}    ${liststring_prs_order_detail}   ${get_payment_id}   ${get_khachdatra_in_dh_bf_execute}   ${actual_khtt}    ${input_ghichu}
    Log    ${request_payload}
    ${order_code}    Post request to create order and return code    ${request_payload}
    #get values
    Sleep    20 s    wait for response to API
    #assert value order
    ${get_ma_kh_in_dh_af_execute}    ${get_TTDH_in_dh_af_execute}    ${get_tongtienhang_in_dh_af_exxecute}    ${get_khachdatra_in_dh_af_execute}    ${get_giamgia_in_dh_af_execute}    ${get_tongcong_in_dh_af_execute}    ${get_ghichu_in_dh_af_execute}
    ...    Get order info incase discount by order code    ${order_code}
    Should Be Equal As Strings    ${get_ma_kh_in_dh_af_execute}    ${input_ma_kh}
    Should Be Equal As Numbers    ${get_TTDH_in_dh_af_execute}    1    #1 : phiếu tạm
    Should Be Equal As Numbers    ${get_tongtienhang_in_dh_af_exxecute}    ${result_tongtienhang}
    Should Be Equal As Numbers    ${get_khachdatra_in_dh_af_execute}    ${actual_khtt_paymented}
    Should Be Equal As Numbers    ${get_giamgia_in_dh_af_execute}    ${result_ggdh}
    Should Be Equal As Numbers    ${get_tongcong_in_dh_af_execute}    ${result_tongcong_in_dh}
    Should Be Equal As Strings    ${get_ghichu_in_dh_af_execute}    ${input_ghichu}
    #assert value khach hang and so quy
    ${get_no_af_execute}    ${get_tongban_af_execute}    ${get_tongban_tru_trahang_af_execute}    Get Customer Debt from API    ${input_ma_kh}
    ${get_ma_phieutt_in_dh}    Get ma phieu thanh toan dat hang frm API    ${order_code}
    Should Be Equal As Numbers    ${get_no_af_execute}    ${result_no_hientai_kh}
    Should Be Equal As Numbers    ${get_tongban_af_execute}    ${get_tongban_bf_execute}
    Should Be Equal As Numbers    ${get_tongban_tru_trahang_af_execute}    ${get_tongban_tru_trahang_bf_execute}
    Run Keyword If    '${input_khtt}' == '0'    Validate history in customer if order is not paid    ${input_ma_kh}    ${order_code}
    ...    ELSE    Validate history and debt in customer if order is paid    ${input_ma_kh}    ${order_code}    ${actual_khtt}    ${result_no_hientai_kh}
    Run Keyword If    '${input_khtt}' == '0'    Validate So quy info if Order is not paid    ${order_code}
    ...    ELSE    Validate So quy info if Order is paid    ${get_ma_phieutt_in_dh}    ${actual_khtt}
    #assert value product
    ${get_tongso_dh_af_execute}    Get order summary frm product API    ${input_ma_hh}
    Should Be Equal As Numbers    ${get_tongso_dh_af_execute}    ${get_tongso_dh_bf_execute}
    ${list_order_summary_af_execute}    Get list order summary frm product API    ${list_product}
    : FOR    ${result_tong_dh}    ${order_summary_af_execute}    IN ZIP    ${list_result_order_summary}    ${list_order_summary_af_execute}
    \    Should Be Equal As Numbers    ${order_summary_af_execute}    ${result_tong_dh}
    Delete order frm Order code    ${order_code}
