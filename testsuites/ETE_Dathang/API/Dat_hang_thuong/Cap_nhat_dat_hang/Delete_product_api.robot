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
&{list_product_u2}    HH0045=3    SI028=1    DVT48=3.5    DV052=1    Combo29=2
@{discount}    15    20000    0    80000
@{discount_type}   dis     disvnd    none    changeup
@{list_product_delete}    SI028

*** Test Cases ***    Mã KH        Khách thanh toán    Ghi chú ĐH         GGDH     List product               List GGSP     List discount type        List product to create    Khách thanh toán to create
Delete product        [Tags]             AEDU
                      [Template]         aetedh_ud2
                      CTKH088      500000                 Đã thanh toán      0         ${list_product_delete}    ${discount}    ${discount_type}         ${list_product_u2}    0

*** Keywords ***
aetedh_ud2
    [Arguments]    ${input_ma_kh}    ${input_khtt}    ${input_ghichu}   ${input_ggdh}    ${list_product_del}    ${list_ggsp}    ${list_discount_type}
    ...    ${dict_product_nums}    ${input_khtt_create_order}
    #get info to validate
    ${order_code}    Add new order with multi products    ${input_ma_kh}    ${dict_product_nums}    ${input_khtt_create_order}
    Sleep    5s
    ${get_khachdatra_in_dh_bf_execute}    ${get_tongtienhang_in_dh_bf_execute}    Get paid value frm API    ${order_code}
    ${get_list_hh_in_dh_bf_execute}   Get list product frm API    ${order_code}
    #get order summary and sub total of products
    : FOR    ${ma_hh}   IN     @{list_product_del}
    \    Remove Values From List    ${get_list_hh_in_dh_bf_execute}    ${ma_hh}
    Log    ${get_list_hh_in_dh_bf_execute}
    ${list_result_tongdh_delete}    Get list order summary incase delete product    ${order_code}    ${list_product_del}
    ${list_soluong_in_dh}    ${list_tong_dh}    Get list quantity - order summary frm API    ${order_code}    ${get_list_hh_in_dh_bf_execute}
    ${get_list_baseprice}    Get list of Baseprice by Product Code    ${get_list_hh_in_dh_bf_execute}
    ${list_result_thanhtien}    Create List
    ${list_result_giamoi}    Create List
    : FOR    ${get_soluong_in_dh}    ${item_ggsp}   ${discount_type}   ${item_baseprice}    IN ZIP    ${list_soluong_in_dh}    ${list_ggsp}
    ...    ${list_discount_type}    ${get_list_baseprice}
    \    ${result_giamoi}    Run Keyword If    '${discount_type}' == 'dis'    Price after % discount product    ${item_baseprice}    ${item_ggsp}
    \    ...    ELSE IF    '${discount_type}' == 'disvnd'    Minus and round 2    ${item_baseprice}    ${item_ggsp}
    \    ...    ELSE IF    '${discount_type}' == 'changeup' or '${discount_type}' == 'changedown'   Set Variable   ${item_ggsp}
    \    ...    ELSE     Set Variable    ${item_baseprice}
    \    ${result_thanhtien}    Multiplication with price round 2    ${get_soluong_in_dh}    ${result_giamoi}
    \    Append To List    ${list_result_giamoi}    ${result_giamoi}
    \    Append To List    ${list_result_thanhtien}    ${result_thanhtien}
    #compute
    ${result_tongtienhang}    Sum values in list and round    ${list_result_thanhtien}
    ${result_tongcong_in_dh}    Run Keyword If    0 < ${input_ggdh} < 100    Price after % discount invoice    ${result_tongtienhang}    ${input_ggdh}
    ...    ELSE    Minus and replace floating point    ${result_tongtienhang}    ${input_ggdh}
    ${result_ggdh}    Run Keyword If    0 < ${input_ggdh} < 100    Convert % discount to VND and round    ${result_tongtienhang}    ${input_ggdh}
    ...    ELSE    Set Variable    ${input_ggdh}
    ${result_khachcantra}    Minus and replace floating point    ${result_tongcong_in_dh}    ${get_khachdatra_in_dh_bf_execute}
    ${actual_khtt_all}    Set Variable If    '${input_khtt}' == 'all'    ${result_khachcantra}    ${input_khtt}
    ${actual_khtt}    Set Variable If    '${input_khtt}' == '0'    0    ${actual_khtt_all}
    ${actual_khtt_paymented}    Sum and replace floating point    ${actual_khtt}    ${get_khachdatra_in_dh_bf_execute}
    #delete product by post API
    ${get_order_id}   ${get_payment_id}   Get order - payment frm order api    ${order_code}
    ${get_list_order_detail_id}   Get list orderdetail id frm order api    ${order_code}    ${get_list_hh_in_dh_bf_execute}
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${jsonpath_id_kh}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_kh}
    ${get_id_kh}    Get data from API    ${endpoint_khachhang}    ${jsonpath_id_kh}
    ${endpoint_danhmuc_hh_co_dvt}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${get_resp_danhmuc_hh}    Get Request and return body    ${endpoint_danhmuc_hh_co_dvt}
    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}    Get list jsonpath product frm list product    ${get_list_hh_in_dh_bf_execute}
    ${list_giaban}    ${list_result_ggsp}    ${list_id_sp}    Get product info frm list jsonpath product incase discount product    ${get_resp_danhmuc_hh}    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}
    ...    ${list_ggsp}   ${list_discount_type}
    ${liststring_prs_order_detail}     Set Variable      needdel
    Log        ${liststring_prs_order_detail}
    : FOR    ${item_result_ggsp}   ${item_ggsp}  ${item_orderdetail_id}    ${item_gia_ban}   ${item_id_sp}   ${item_soluong}      IN ZIP       ${list_result_ggsp}       ${list_ggsp}      ${get_list_order_detail_id}       ${list_giaban}        ${list_id_sp}    ${list_soluong_in_dh}
    \     ${item_ggsp}    Set Variable If    0 < ${item_ggsp} < 100    ${item_ggsp}     0
    \    ${payload_each_product}        Format string       {{"BasePrice":1000000,"Discount":{0},"DiscountRatio":{1},"Id":{2},"IsLotSerialControl":false,"IsRewardPoint":false,"Note":"","Price":{3},"ProductCode":"Combo39","ProductId":{4},"ProductName":"Bộ mỹ phẩm 09","Quantity":{5},"Uuid":"","ProductBatchExpireId":null}}       ${item_result_ggsp}   ${item_ggsp}  ${item_orderdetail_id}    ${item_gia_ban}   ${item_id_sp}   ${item_soluong}
    \    ${liststring_prs_order_detail}       Catenate      SEPARATOR=,      ${liststring_prs_order_detail}      ${payload_each_product}
    ${liststring_prs_order_detail}       Replace String      ${liststring_prs_order_detail}       needdel,       ${EMPTY}      count=1
    ${giamgia_dh}    Set Variable If    0 < ${input_ggdh} < 100    ${input_ggdh}    0
    ${request_payload}    Format String    {{"Order":{{"Id":{0},"BranchId":{1},"RetailerId":{2},"CustomerId":{3},"SoldById":{4},"SoldBy":{{"CreatedBy":0,"CreatedDate":"2018-12-10T10:44:15.970Z","Email":"","GivenName":"admin","Id":{4},"IsActive":true,"IsAdmin":true,"Type":0,"UserName":"admin","isDeleted":false,"Name":"admin"}},"SaleChannelId":0,"SaleChannel":null,"Seller":{{"CreatedBy":0,"CreatedDate":"2018-12-10T10:44:15.970Z","Email":"","GivenName":"admin","Id":{4},"IsActive":true,"IsAdmin":true,"Type":0,"UserName":"admin","isDeleted":false,"Name":"admin"}},"PurchaseDate":"","Code":"{5}","Discount":{6},"DiscountRatio":{7},"OrderDetails":[{8}],"InvoiceOrderSurcharges":[],"Payments":[{{"OrderValue":0,"DocumentValue":0,"PaidValue":0,"NeedPayValue":0,"CustomerName":"","CustomerCode":"","InvoiceCode":"","CustomerDebt":0,"CustomerOldDebt":0,"TargetCode":"","UserName":"","VoucherCampaignId":0,"Version":0,"TransGuid":"00000000000000000000000000000000","DocumentTypeValue":0,"Id":{9},"Code":"TTDH001090","Amount":{10},"AmountOriginal":0,"Method":"Cash","CreatedDate":"","CreatedBy":{4},"RetailerId":{2},"BranchId":{1},"OrderId":{0},"CustomerId":{3},"TransDate":"","UserId":{4},"Status":0,"System":false,"DeliveryPayments":[],"PaymentAllocation":[]}},{{"Method":"Cash","MethodStr":"Tiền mặt","Amount":{11},"Id":-2}}],"UsingCod":0,"Status":1,"Total":3856000,"Description":"{12}","Extra":"{{\\"Amount\\":3846000,\\"Method\\":{{\\"Id\\":\\"Cash\\",\\"Label\\":\\"Tiền mặt\\"}},\\"activeCustomerGroupId\\":null,\\"ResetPromotion\\":false}}","Surcharge":0,"Type":2,"Uuid":"","addToAccount":"0","PayingAmount":3846000,"TotalBeforeDiscount":3967000,"ProductDiscount":111000,"CreatedBy":160324,"CreatedDate":"","InvoiceWarranties":[]}}}}     ${get_order_id}   ${BRANCH_ID}    ${get_id_nguoitao}    ${get_id_kh}    ${get_id_nguoiban}
    ...    ${order_code}   ${result_ggdh}    ${giamgia_dh}    ${liststring_prs_order_detail}    ${get_payment_id}    ${get_khachdatra_in_dh_bf_execute}    ${actual_khtt}   ${input_ghichu}
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
    Should Be Equal As Strings    ${get_ghichu_in_dh_af_execute}   ${input_ghichu}
    #validate deleted product
    ${list_order_summary_delete_af_execute}    Get list order summary frm product API    ${list_product_del}
    : FOR    ${result_tong_dh_delete}    ${order_summary_delete_af_execute}    IN ZIP    ${list_result_tongdh_delete}    ${list_order_summary_delete_af_execute}
    \    Should Be Equal As Numbers    ${result_tong_dh_delete}    ${order_summary_delete_af_execute}
    #validate product
    ${get_list_hh_in_dh_af_execute}    Get list product frm API    ${order_code}
    ${list_order_summary_af_execute}    Get list order summary frm product API    ${get_list_hh_in_dh_af_execute}
    : FOR    ${result_tong_dh}    ${order_summary_af_execute}    IN ZIP    ${list_tong_dh}    ${list_order_summary_af_execute}
    \    Should Be Equal As Numbers    ${order_summary_af_execute}    ${result_tong_dh}
    Delete order frm Order code    ${order_code}
