*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    ${headless_browser}
Resource          ../../../../../../core/API/api_thietlap.robot
Resource          ../../../../../../core/API/api_dathang.robot
Resource          ../../../../../../core/Ban_Hang/banhang_getandcompute.robot
Resource          ../../../../../../core/share/toast_message.robot
Resource          ../../../../../../core/API/api_mhbh_dathang.robot
Resource          ../../../../../../core/API/api_soquy.robot
Resource          ../../../../../../core/API/api_danhmuc_hanghoa.robot
Resource          ../../../../../../core/Dat_Hang/dat_hang_action.robot
Resource          ../../../../../../core/Dat_Hang/dat_hang_page.robot

*** Variables ***
&{list_product1}    Combo166=3.5    DVL011=1
&{list_product2}    Combo167=4
&{list_giveaway1}    DV031=1    DV032=1    DV033=1
&{list_giveaway2}    DV031=2
&{list_giveaway_add}    DV031=1    DV032=1
@{list_ggsp}      2000    10
@{list_giamoi}    1500000
${list_no_discount}  0      0

*** Test Cases ***    Product and num list    Product Discount           Order Discount    Customer    Payment    Promotion Code       Khách thanh toán to create order
KM DH                 [Tags]                  AKMDH3
                      [Template]              edukm1_api
                      ${list_product1}        ${list_ggsp}               10                 KHKM04     0          KM01          500000        #giam gia HD VND

KM dat hang tang hang
                      [Documentation]         San pham KM la SP dich vu\nCase khong validate ton kho cua SP KM
                      [Tags]                  AKMDH3
                      [Template]              edukm2_api
                      ${list_product2}        50000                   KHKM05           all      KM03      ${list_giveaway1}    ${list_giamoi}     0

KM dat hang giam gia SP
                      [Tags]                  AKMDH3
                      [Template]              edukm3_api
                      ${list_product1}         15                     KHKM06           all         KM05      ${list_giveaway2}   100000      ${list_giveaway_add}

*** Keywords ***
edukm1_api
    [Arguments]    ${dict_product_num}    ${list_discount_product}    ${input_ggdh}    ${input_ma_kh}    ${input_bh_khachtt}    ${input_khuyemmai}    ${input_khtt_create_order}
    ## Get info ton cuoi, cong no khach hang
    Toggle status of promotion    ${input_khuyemmai}    1
    ${order_code}     Add new order with order - order discount promotion    ${input_ma_kh}    ${dict_product_num}    ${input_khuyemmai}    ${input_khtt_create_order}
    ${list_product}    Get Dictionary Keys    ${dict_product_num}
    ${list_nums}    Get Dictionary Values    ${dict_product_num}
    ${invoice_value}    ${discount}    ${discount_ratio}    ${name}    Get Invoice value - Discounts - Promotion Name from Promotion Code    ${input_khuyemmai}
    ${get_no_bf_execute}    ${get_tongban_bf_execute}    ${get_tongban_tru_trahang_bf_execute}    Get Customer Debt from API    ${input_ma_kh}
    ${get_khachdatra_in_dh_bf_execute}    ${get_tongtienhang_in_dh_bf_execute}    Get paid value frm API    ${order_code}
    ${get_list_ordersummary_bf_execute}    Get list order summary by order code    ${order_code}
    #create lists
    ${list_result_thanhtien}    ${list_result_order_summary}    ${list_result_giamoi}    Get list total sale and order summary incase discount    ${list_product}    ${list_nums}    ${list_ggsp}
    #compute
    ${result_tongtienhang}    Sum values in list    ${list_result_thanhtien}
    ${result_af_invoice_discount}    Price after % discount invoice    ${result_tongtienhang}    ${input_ggdh}
    ${result_discount_invoice_by_vnd}    Convert % discount to VND and round    ${result_tongtienhang}    ${input_ggdh}
    ${result_discount_ratio_by_invoice_promo}    Convert % discount to VND and round    ${result_tongtienhang}    ${discount_ratio}
    ${actual_promo_value}    Set Variable If    ${discount} == 0    ${result_discount_ratio_by_invoice_promo}    ${discount}
    ${final_discount}=    Run Keyword If    ${result_tongtienhang} > ${invoice_value}    Sum    ${actual_promo_value}    ${result_discount_invoice_by_vnd}
    ...    ELSE    Set Variable    ${result_discount_invoice_by_vnd}
    ${result_khachcantra}    Minus    ${result_tongtienhang}    ${final_discount}
    ${result_khachcantra}    Replace floating point    ${result_khachcantra}
    ${actual_khachtt}    Set Variable If    '${input_bh_khachtt}' == 'all'    ${result_khachcantra}    ${input_bh_khachtt}
    ${result_khachdatra}    Sum    ${get_khachdatra_in_dh_bf_execute}    ${actual_khachtt}
    ${result_nohientai}    Minus    ${get_no_bf_execute}    ${actual_khachtt}
    ${result_tongban}    Sum    ${result_khachcantra}    ${get_tongban_bf_execute}
    #update order by order api
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${jsonpath_id_kh}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_kh}
    ${get_id_kh}    Get data from API    ${endpoint_khachhang}    ${jsonpath_id_kh}
    ${endpoint_danhmuc_hh_co_dvt}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${get_resp_danhmuc_hh}    Get Request and return body    ${endpoint_danhmuc_hh_co_dvt}
    ${get_id_sale_promo}    ${get_id_promotion}    ${get_promo_discount}    Get promotion info    ${input_khuyemmai}
    ${get_order_id}   ${get_payment_id}   Get order - payment frm order api    ${order_code}
    ${get_list_order_detail_id}   Get list orderdetail id frm order api    ${order_code}    ${list_product}
    #get list gia ban, id san pham, discount of product
    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}    Get list jsonpath product frm list product    ${list_product}
    ${list_giaban}    ${list_result_ggsp}    ${list_id_sp}    Get product info frm list jsonpath product have discount product    ${get_resp_danhmuc_hh}    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}    ${list_discount_product}
    #list payload of product new
    ${liststring_prs_order_detail}     Set Variable      needdel
    Log        ${liststring_prs_order_detail}
    : FOR   ${item_result_ggsp}   ${item_ggsp}    ${item_id_orderdetail}   ${item_gia_ban}   ${item_id_sp}   ${item_soluong}      IN ZIP    ${list_result_ggsp}    ${list_discount_product}    ${get_list_order_detail_id}   ${list_giaban}        ${list_id_sp}    ${list_nums}
    \    ${item_ggsp}     Set Variable If    0 < ${item_ggsp} < 100    ${item_ggsp}   0
    \    ${payload_each_product}        Format string       {{"BasePrice":43000,"Discount":{0},"DiscountRatio":{1},"Id":{2},"IsLotSerialControl":false,"IsMaster":true,"IsRewardPoint":false,"MaxQuantity":0,"Note":"","Price":{3},"ProductCode":"DV067","ProductId":{4},"ProductName":"Nails 19","Quantity":{5},"Uuid":"","ProductBatchExpireId":null}}   ${item_result_ggsp}   ${item_ggsp}    ${item_id_orderdetail}   ${item_gia_ban}   ${item_id_sp}   ${item_soluong}
    \    ${liststring_prs_order_detail}       Catenate      SEPARATOR=,      ${liststring_prs_order_detail}      ${payload_each_product}
    ${liststring_prs_order_detail}       Replace String      ${liststring_prs_order_detail}       needdel,       ${EMPTY}      count=1
    #post request
    ${request_payload}    Format String    {{"Order":{{"Id":{0},"BranchId":{1},"RetailerId":{2},"CustomerId":{3},"SoldById":{4},"SoldBy":{{"CreatedBy":0,"CreatedDate":"2018-12-10T08:33:32.447Z","GivenName":"admin","Id":{4},"IsActive":true,"IsAdmin":true,"Type":0,"isDeleted":false,"Name":"admin"}},"SaleChannelId":0,"SaleChannel":null,"Seller":{{"CreatedBy":0,"CreatedDate":"2018-12-10T08:33:32.447Z","GivenName":"admin","Id":{4},"IsActive":true,"IsAdmin":true,"Type":0,"isDeleted":false,"Name":"admin"}},"PurchaseDate":"","Code":"{5}","Discount":{6},"DiscountRatio":{7},"OrderDetails":[{8}],"InvoiceOrderSurcharges":[],"OrderPromotions":[{{"Id":13191,"OrderId":{0},"PromotionId":{9},"SalePromotionId":{10},"PromotionInfo":"Khuyến mại giảm giá Hóa đơn VNĐ: Tổng tiền hàng từ 5,000,000 giảm giá 20,000 cho hóa đơn","Type":1,"Discount":20000,"TargetType":0,"PrintPromotionInfo":"Khuyến mại giảm giá Hóa đơn VNĐ: Tổng tiền hàng từ 5,000,000 giảm giá 20,000 cho hóa đơn"}}],"Payments":[{{"OrderValue":0,"DocumentValue":0,"PaidValue":0,"NeedPayValue":0,"CustomerName":"","CustomerCode":"","InvoiceCode":"","CustomerDebt":0,"CustomerOldDebt":0,"TargetCode":"","UserName":"","VoucherCampaignId":0,"Version":0,"IsUpdate":false,"TransGuid":"00000000000000000000000000000000","DocumentTypeValue":0,"Id":{11},"Code":"TTDH000567","Amount":{12},"AmountOriginal":0,"Method":"Cash","CreatedDate":"","CreatedBy":{4},"RetailerId":{2},"BranchId":{1},"OrderId":{0},"CustomerId":{3},"TransDate":"","UserId":{4},"Status":0,"System":false,"DeliveryPayments":[],"PaymentAllocation":[]}}],"UsingCod":0,"Status":1,"Total":501280,"Extra":"{{\\"Amount\\":0,\\"Method\\":{{\\"Id\\":\\"Cash\\",\\"Label\\":\\"Tiền mặt\\"}},\\"activeCustomerGroupId\\":null,\\"ResetPromotion\\":false}}","Surcharge":0,"Type":2,"Uuid":"","addToAccount":"0","PayingAmount":0,"TotalBeforeDiscount":641000,"ProductDiscount":61800,"CreatedBy":441968,"CreatedDate":"2019-08-22T13:48:25.0900000+07:00","InvoiceWarranties":[],"DiscountByPromotion":20000,"DiscountByPromotionValue":20000,"DiscountByPromotionRatio":0}}}}    ${get_order_id}    ${BRANCH_ID}    ${get_id_nguoitao}    ${get_id_kh}    ${get_id_nguoiban}
    ...     ${order_code}    ${final_discount}     ${input_ggdh}    ${liststring_prs_order_detail}
    ...     ${get_id_promotion}   ${get_id_sale_promo}   ${get_payment_id}    ${get_khachdatra_in_dh_bf_execute}
    Log    ${request_payload}
    ${order_code}    Post request to create order and return code    ${request_payload}
    #get values
    Sleep    20 s    wait for response to API
    #assert values in order
    ${get_ma_kh_in_dh_af_execute}    ${get_TTDH_in_dh_af_execute}    ${get_tongtienhang_in_dh_af_exxecute}    ${get_khachdatra_in_dh_af_execute}    ${get_giamgia_in_dh_af_execute}    ${get_tongcong_in_dh_af_execute}    ${get_ghichu_in_dh_af_execute}
    ...    Get order info incase discount by order code    ${order_code}
    Should Be Equal As Strings    ${get_ma_kh_in_dh_af_execute}    ${get_ma_kh_in_dh_af_execute}
    Should Be Equal As Numbers    ${get_TTDH_in_dh_af_execute}    1    #1 : phiếu tạm
    Should Be Equal As Numbers    ${get_tongtienhang_in_dh_af_exxecute}    ${result_tongtienhang}
    Should Be Equal As Numbers    ${get_khachdatra_in_dh_af_execute}    ${result_khachdatra}
    Should Be Equal As Numbers    ${get_giamgia_in_dh_af_execute}    ${final_discount}
    Should Be Equal As Numbers    ${get_tongcong_in_dh_af_execute}    ${result_khachcantra}
    #assert value product
    ${get_list_ordersummary_af_execute}    Get list order summary by order code    ${order_code}
    : FOR    ${get_order_summary_bf_execute}    ${order_summary_af_execute}    IN ZIP    ${get_list_ordersummary_bf_execute}    ${get_list_ordersummary_af_execute}
    \    Should Be Equal As Numbers    ${order_summary_af_execute}    ${get_order_summary_bf_execute}
    #assert value khach hang and so quy
    ${get_no_af_execute}    ${get_tongban_af_execute}    ${get_tongban_tru_trahang_af_execute}    Get Customer Debt from API    ${input_ma_kh}
    ${get_ma_phieutt_in_dh}    Get ma phieu thanh toan dat hang frm API    ${order_code}
    Should Be Equal As Numbers    ${get_no_af_execute}    ${result_nohientai}
    Should Be Equal As Numbers    ${get_tongban_af_execute}    ${get_tongban_bf_execute}
    Should Be Equal As Numbers    ${get_tongban_tru_trahang_af_execute}    ${get_tongban_tru_trahang_bf_execute}
    Run Keyword If    '${input_bh_khachtt}' == '0'    Validate history in customer if order is not paid    ${input_ma_kh}    ${order_code}
    ...    ELSE    Validate history and debt in customer if order is paid    ${input_ma_kh}    ${order_code}    ${actual_khachtt}    ${result_nohientai}
    Run Keyword If    '${input_bh_khachtt}' == '0'    Validate So quy info if Order is not paid    ${order_code}
    ...    ELSE    Validate So quy info if Order is paid    ${get_ma_phieutt_in_dh}    ${actual_khachtt}
    Delete order frm Order code    ${order_code}
    Toggle status of promotion    ${input_khuyemmai}    0

edukm2_api
    [Arguments]    ${dict_product_nums}    ${input_ggdh}    ${input_ma_kh}    ${input_bh_khachtt}    ${input_khuyemmai}    ${list_giveaway}
    ...    ${list_newprice}   ${input_khach_tt_to_create}
    [Timeout]
    #Get info ton cuoi, cong no khach hang
    Toggle status of promotion    ${input_khuyemmai}    1
    ${order_code}     Add new order with order - Offering free items Promotion    ${input_ma_kh}    ${dict_product_nums}    ${input_khuyemmai}    ${list_giveaway}       ${input_khach_tt_to_create}
    ${invoice_value}    ${received_value}    ${discount}    ${discount_ratio}    ${name}    Get Invoice value - Received value - Discounts - Promotion Name from Promotion Code    ${input_khuyemmai}
    #create lists
    ${list_prs}    Get Dictionary Keys    ${dict_product_nums}
    ${list_nums}    Get Dictionary Values    ${dict_product_nums}
    ${list_giveaway_product}    Get Dictionary Keys    ${list_giveaway}
    ${list_giveaway_num}    Get Dictionary Values    ${list_giveaway}
    ${get_khachdatra_in_dh_bf_execute}    ${get_tongtienhang_in_dh_bf_execute}    Get paid value frm API    ${order_code}
    ${get_list_ordersummary_bf_execute}    Get list order summary by order code    ${order_code}
    ${list_result_thanhtien}    ${list_result_order_summary}    Get list total sale and order summary incase newprice    ${list_prs}    ${list_nums}    ${list_newprice}
    #compute
    ${result_tongtienhang}    Sum values in list    ${list_result_thanhtien}
    ${result_khachcantra}    Minus    ${result_tongtienhang}    ${input_ggdh}
    ${actual_khachtt}    Set Variable If    '${input_bh_khachtt}' == 'all'    ${result_khachcantra}    ${input_bh_khachtt}
    ${result_khachdatra}      Sum     ${get_khachdatra_in_dh_bf_execute}    ${actual_khachtt}
    #create order
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${jsonpath_id_kh}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_kh}
    ${get_id_kh}    Get data from API    ${endpoint_khachhang}    ${jsonpath_id_kh}
    ${endpoint_danhmuc_hh_co_dvt}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${get_resp_danhmuc_hh}    Get Request and return body    ${endpoint_danhmuc_hh_co_dvt}
    ${get_id_sale_promo}    ${get_id_promotion}    ${get_promo_discount}    Get product promotion info    ${input_khuyemmai}
    ${get_order_id}   ${get_payment_id}   Get order - payment frm order api    ${order_code}
    ${get_list_order_detail_id}   Get list orderdetail id frm order api    ${order_code}    ${list_prs}
    ${get_list_order_detail_id_promo}   Get list orderdetail id frm order api    ${order_code}    ${list_giveaway_product}
    #get list gia ban, id san pham, discount of product
    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}    Get list jsonpath product frm list product    ${list_prs}
    ${list_giaban}    ${list_result_ggsp}    ${list_id_sp}    Get product info and new price frm list product    ${get_resp_danhmuc_hh}    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}    ${list_newprice}
    ${list_jsonpath_id_sp_promo}    ${list_jsonpath_giaban_promo}    Get list jsonpath product frm list product    ${list_giveaway_product}
    ${list_giaban_promo}    ${list_id_sp_promo}    Get product info frm list jsonpath product    ${get_resp_danhmuc_hh}    ${list_jsonpath_id_sp_promo}    ${list_jsonpath_giaban_promo}
    #list payload of product new
    ${liststring_prs_order_detail}     Set Variable      needdel
    Log        ${liststring_prs_order_detail}
    : FOR   ${item_result_ggsp}   ${item_id_orderdetail}   ${item_gia_ban}   ${item_id_sp}   ${item_soluong}      IN ZIP    ${list_result_ggsp}    ${get_list_order_detail_id}   ${list_giaban}        ${list_id_sp}    ${list_nums}
    \    ${payload_each_product}        Format string       {{"BasePrice":29000.02,"Discount":{0},"Id":{1},"IsLotSerialControl":false,"IsMaster":true,"IsRewardPoint":false,"MaxQuantity":0,"Note":"","Price":{2},"ProductCode":"HH0060","ProductId":{3},"ProductName":"Kẹo Dẻo Haribo Goldbears (100g)","Quantity":{4},"Uuid":"","ProductBatchExpireId":null}}   ${item_result_ggsp}   ${item_id_orderdetail}   ${item_gia_ban}   ${item_id_sp}   ${item_soluong}
    \    ${liststring_prs_order_detail}       Catenate      SEPARATOR=,      ${liststring_prs_order_detail}      ${payload_each_product}
    ${liststring_prs_order_detail}       Replace String      ${liststring_prs_order_detail}       needdel,       ${EMPTY}      count=1
    #list payload of product promotion
    ${liststring_prs_order_detail_promo}     Set Variable      needdel
    Log        ${liststring_prs_order_detail_promo}
    : FOR   ${item_gia_ban_promo}   ${item_id_orderdetail_promo}   ${item_id_sp_promo}   ${item_soluong_promo}      IN ZIP   ${list_giaban_promo}    ${get_list_order_detail_id_promo}    ${list_id_sp_promo}    ${list_giveaway_num}
    \    ${payload_each_product_promo}        Format string       {{"BasePrice":30000,"Discount":{0},"DiscountRatio":0,"Id":{1},"IsLotSerialControl":false,"IsRewardPoint":false,"MaxQuantity":0,"Note":"","Price":{0},"ProductCode":"DV031","ProductId":{2},"ProductName":"Dập phồng tóc - Loreal","PromotionParentType":0,"Quantity":{3},"SalePromotionId":{4},"Uuid":"","ProductBatchExpireId":null}}   ${item_gia_ban_promo}   ${item_id_orderdetail_promo}   ${item_id_sp_promo}   ${item_soluong_promo}    ${get_id_sale_promo}
    \    ${liststring_prs_order_detail_promo}       Catenate      SEPARATOR=,      ${liststring_prs_order_detail_promo}      ${payload_each_product_promo}
    ${liststring_prs_order_detail_promo}       Replace String      ${liststring_prs_order_detail_promo}       needdel,       ${EMPTY}      count=1
    ${id_sp_promo}     Get From List    ${list_id_sp_promo}    0
    ${list_id_sp_promo}   Convert list to string and return     ${list_id_sp_promo}
    #post request
    ${request_payload}    Format String    {{"Order":{{"Id":{0},"BranchId":{1},"RetailerId":{2},"CustomerId":{3},"SoldById":{4},"SoldBy":{{"CreatedBy":0,"CreatedDate":"2018-12-10T08:33:32.447Z","GivenName":"admin","Id":{4},"IsActive":true,"IsAdmin":true,"Type":0,"isDeleted":false,"Name":"admin"}},"SaleChannelId":0,"SaleChannel":null,"Seller":{{"CreatedBy":0,"CreatedDate":"2018-12-10T08:33:32.447Z","GivenName":"admin","Id":{4},"IsActive":true,"IsAdmin":true,"Type":0,"isDeleted":false,"Name":"admin"}},"PurchaseDate":"","Code":"{5}","Discount":{6},"OrderDetails":[{7},{8}],"InvoiceOrderSurcharges":[],"OrderPromotions":[{{"Id":13214,"OrderId":{0},"ProductId":{9},"PromotionId":{10},"SalePromotionId":{11},"PromotionInfo":"Khuyến mại hóa đơn tặng hàng: Tổng tiền hàng từ 5,000,000 tặng 1 DV031 - Dập phồng tóc - Loreal, 1 DV032 - Nhuộm tóc - Loreal, 1 DV033 - Hấp phục hồi Loreal cho hóa đơn","Type":2,"ProductQty":3,"TargetType":0,"ProductIds":"{12}","PrintPromotionInfo":"Tổng tiền hàng từ 5,000,000 tặng 1 Dập phồng tóc - Loreal, 1 Nhuộm tóc - Loreal, 1 Hấp phục hồi Loreal cho hóa đơn","DisplayPrice":30000}}],"Payments":[{{"OrderValue":0,"DocumentValue":0,"PaidValue":0,"NeedPayValue":0,"CustomerName":"","CustomerCode":"","InvoiceCode":"","CustomerDebt":0,"CustomerOldDebt":0,"TargetCode":"","UserName":"","VoucherCampaignId":0,"Version":0,"IsUpdate":false,"TransGuid":"00000000000000000000000000000000","DocumentTypeValue":0,"Id":{13},"Code":"TTDH000574","Amount":{14},"AmountOriginal":0,"Method":"Cash","CreatedDate":"","CreatedBy":{4},"RetailerId":{2},"BranchId":{1},"OrderId":{0},"CustomerId":{3},"TransDate":"","UserId":{4},"Status":0,"System":false,"DeliveryPayments":[],"PaymentAllocation":[]}},{{"Method":"Cash","MethodStr":"Tiền mặt","Amount":{15},"Id":-2}}],"UsingCod":0,"Status":1,"Total":1900000,"Extra":"{{\\"Amount\\":500000,\\"Method\\":{{\\"Id\\":\\"Cash\\",\\"Label\\":\\"Tiền mặt\\"}},\\"activeCustomerGroupId\\":null,\\"ResetPromotion\\":false}}","Surcharge":0,"Type":2,"Uuid":"W15664608240060","addToAccount":"0","PayingAmount":500000,"TotalBeforeDiscount":1826000,"ProductDiscount":-124000,"CreatedBy":441968,"CreatedDate":"","InvoiceWarranties":[]}}}}    ${get_order_id}    ${BRANCH_ID}    ${get_id_nguoitao}    ${get_id_kh}    ${get_id_nguoiban}
    ...     ${order_code}    ${input_ggdh}    ${liststring_prs_order_detail}    ${liststring_prs_order_detail_promo}    ${id_sp_promo}
    ...     ${get_id_promotion}   ${get_id_sale_promo}    ${list_id_sp_promo}   ${get_payment_id}    ${get_khachdatra_in_dh_bf_execute}    ${actual_khachtt}
    Log    ${request_payload}
    ${order_code}    Post request to create order and return code    ${request_payload}
    #get values
    Sleep    20 s    wait for response to API
    #assert values in order
    ${get_ma_kh_in_dh_af_execute}    ${get_TTDH_in_dh_af_execute}    ${get_tongtienhang_in_dh_af_exxecute}    ${get_khachdatra_in_dh_af_execute}    ${get_giamgia_in_dh_af_execute}    ${get_tongcong_in_dh_af_execute}    ${get_ghichu_in_dh_af_execute}
    ...    Get order info incase discount by order code    ${order_code}
    Should Be Equal As Strings    ${get_ma_kh_in_dh_af_execute}    ${get_ma_kh_in_dh_af_execute}
    Should Be Equal As Numbers    ${get_TTDH_in_dh_af_execute}    1    #1 : phiếu tạm
    Should Be Equal As Numbers    ${get_tongtienhang_in_dh_af_exxecute}    ${result_tongtienhang}
    Should Be Equal As Numbers    ${get_khachdatra_in_dh_af_execute}    ${result_khachdatra}
    Should Be Equal As Numbers    ${get_giamgia_in_dh_af_execute}    ${input_ggdh}
    Should Be Equal As Numbers    ${get_tongcong_in_dh_af_execute}    ${result_khachcantra}
    #assert value product
    ${list_order_summary_af_execute}    Get list order summary by order code    ${order_code}
    : FOR    ${result_tong_dh}    ${order_summary_af_execute}    IN ZIP    ${get_list_ordersummary_bf_execute}    ${list_order_summary_af_execute}
    \    Should Be Equal As Numbers    ${order_summary_af_execute}    ${result_tong_dh}
    #Delete order frm Order code    ${order_code}
    Toggle status of promotion    ${input_khuyemmai}    0

edukm3_api
    [Arguments]    ${dict_product_num}    ${input_ggdh}    ${input_bh_ma_kh}    ${input_bh_khachtt}    ${input_khuyemmai}    ${dict_promo_product}
    ...    ${input_khtt_create_order}    ${dict_promo_product_add}
    [Timeout]
    ## Get info ton cuoi, cong no khach hang
    Toggle status of promotion    ${input_khuyemmai}    1
    ${order_code}     Add new order with order - offering discount pricing promotion    ${input_bh_ma_kh}    ${dict_product_num}    ${input_khuyemmai}    ${dict_promo_product}   ${input_khtt_create_order}
    ${invoice_value}    ${received_value}    ${discount}    ${discount_ratio}    ${name}    Get Invoice value - Received value - Discounts - Promotion Name from Promotion Code    ${input_khuyemmai}
    ${list_product}    Get Dictionary Keys    ${dict_product_num}
    ${list_nums}    Get Dictionary Values    ${dict_product_num}
    ${list_promo_product}    Get Dictionary Keys    ${dict_promo_product}
    ${list_promo_num}    Get Dictionary Values    ${dict_promo_product}
    ${list_promo_product_add}    Get Dictionary Keys    ${dict_promo_product_add}
    ${list_promo_num_add}    Get Dictionary Values    ${dict_promo_product_add}
    ${get_khachdatra_in_dh_bf_execute}    ${get_tongtienhang_in_dh_bf_execute}    Get paid value frm API    ${order_code}
    #get data
    ${result_list_thanhtien}  Create List
    ${get_list_giaban}  Get list of Baseprice by Product Code    ${list_product}
    :FOR    ${item_giaban}    ${item_soluong}   IN ZIP    ${get_list_giaban}    ${list_nums}
    \     ${result_thanhtien}    Multiplication and round    ${item_giaban}    ${item_soluong}
    \     Append to list    ${result_list_thanhtien}     ${result_thanhtien}
    # Promo products
    ${list_result_totalsale_promo}    ${list_result_onhand_promo}    Run keyword if    ${discount} != 0    Get list of total sale - result onhand in case discount product    ${list_promo_product_add}    ${list_promo_num_add}
    ...    ${discount}
    ...    ELSE    Get list of total sale - result onhand in case discount product    ${list_promo_product_add}    ${list_promo_num_add}    ${discount_ratio}
    ${total_promo_sale}    Sum values in list    ${list_result_totalsale_promo}
    ${get_list_ordersummary_bf_execute}   Get list order summary by order code    ${order_code}
    ${list_result_order_summary_add}    Get list result order summary frm product API    ${list_promo_product_add}    ${list_promo_num_add}
    : FOR    ${order_summary}    IN    @{list_result_order_summary_add}
    \    Append To List    ${get_list_ordersummary_bf_execute}    ${order_summary}
    Log    ${get_list_ordersummary_bf_execute}
    #computation
    ${result_tongtienhang}    Sum values in list    ${result_list_thanhtien}
    ${result_tongtienhang_promo}    Sum    ${result_tongtienhang}    ${total_promo_sale}
    ${actual_tongtienhang}    Set Variable If    ${result_tongtienhang} > ${invoice_value}    ${result_tongtienhang_promo}    ${result_tongtienhang}
    ${result_ggdh}    Convert % discount to VND and round    ${actual_tongtienhang}    ${input_ggdh}
    ${result_khachcantra}   Minusx3 and replace foating point    ${actual_tongtienhang}   ${get_khachdatra_in_dh_bf_execute}    ${result_ggdh}
    ${actual_khachtt}    Set Variable If    '${input_bh_khachtt}' == 'all'    ${result_khachcantra}    ${input_bh_khachtt}
    ${result_khachdatra}      Sum     ${get_khachdatra_in_dh_bf_execute}    ${actual_khachtt}
    #create order
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${jsonpath_id_kh}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_bh_ma_kh}
    ${get_id_kh}    Get data from API    ${endpoint_khachhang}    ${jsonpath_id_kh}
    ${endpoint_danhmuc_hh_co_dvt}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${get_resp_danhmuc_hh}    Get Request and return body    ${endpoint_danhmuc_hh_co_dvt}
    ${get_id_sale_promo}    ${get_id_promotion}    ${get_promo_discount}    Get product promotion info    ${input_khuyemmai}
    ${get_order_id}   ${get_payment_id}   Get order - payment frm order api    ${order_code}
    ${get_list_order_detail_id}   Get list orderdetail id frm order api    ${order_code}    ${list_product}
    ${get_list_order_detail_id_promo}   Get list orderdetail id frm order api    ${order_code}    ${list_promo_product_add}
    #get list gia ban, id san pham, discount of product
    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}    Get list jsonpath product frm list product    ${list_product}
    ${list_giaban}    ${list_id_sp}    Get product info frm list jsonpath product    ${get_resp_danhmuc_hh}    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}
    ${list_jsonpath_id_sp_promo}    ${list_jsonpath_giaban_promo}    Get list jsonpath product frm list product    ${list_promo_product_add}
    ${list_giaban_promo}    ${list_id_sp_promo}    Get product info frm list jsonpath product    ${get_resp_danhmuc_hh}    ${list_jsonpath_id_sp_promo}    ${list_jsonpath_giaban_promo}
    #list payload of product new
    ${liststring_prs_order_detail}     Set Variable      needdel
    Log        ${liststring_prs_order_detail}
    : FOR   ${item_id_orderdetail}   ${item_gia_ban}   ${item_id_sp}   ${item_soluong}      IN ZIP    ${get_list_order_detail_id}   ${list_giaban}        ${list_id_sp}    ${list_nums}
    \    ${payload_each_product}        Format string       {{"BasePrice":380000.78,"Discount":0,"DiscountRatio":0,"Id":{0},"IsLotSerialControl":false,"IsMaster":true,"IsRewardPoint":false,"MaxQuantity":0,"Note":"","Price":{1},"ProductCode":"DV125","ProductId":{2},"ProductName":"Uốn tóc 47","Quantity":{3},"Uuid":"","ProductBatchExpireId":null}}   ${item_id_orderdetail}   ${item_gia_ban}   ${item_id_sp}   ${item_soluong}
    \    ${liststring_prs_order_detail}       Catenate      SEPARATOR=,      ${liststring_prs_order_detail}      ${payload_each_product}
    ${liststring_prs_order_detail}       Replace String      ${liststring_prs_order_detail}       needdel,       ${EMPTY}      count=1
    #list payload of product promotion
    ${liststring_prs_order_detail_promo}     Set Variable      needdel
    Log        ${liststring_prs_order_detail_promo}
    : FOR   ${item_gia_ban_promo}   ${item_id_orderdetail_promo}   ${item_id_sp_promo}   ${item_soluong_promo}      IN ZIP   ${list_giaban_promo}    ${get_list_order_detail_id_promo}    ${list_id_sp_promo}    ${list_promo_num_add}
    \    ${result_ggsp}   Convert % discount to VND and round   ${item_gia_ban_promo}      ${get_promo_discount}
    \    ${payload_each_product_promo}        Format string       {{"BasePrice":30000,"Discount":{0},"DiscountRatio":{1},"IsLotSerialControl":false,"IsRewardPoint":false,"Note":"","Price":{2},"ProductCode":"DV031","ProductId":{3},"ProductName":"Dập phồng tóc - Loreal","PromotionParentType":0,"Quantity":{4},"SalePromotionId":{5},"Uuid":"","ProductBatchExpireId":null}}    ${result_ggsp}    ${get_promo_discount}   ${item_gia_ban_promo}   ${item_id_sp_promo}   ${item_soluong_promo}    ${get_id_sale_promo}
    \    ${liststring_prs_order_detail_promo}       Catenate      SEPARATOR=,      ${liststring_prs_order_detail_promo}      ${payload_each_product_promo}
    ${liststring_prs_order_detail_promo}       Replace String      ${liststring_prs_order_detail_promo}       needdel,       ${EMPTY}      count=1
    ${id_sp_promo}     Get From List    ${list_id_sp_promo}    0
    ${list_id_sp_promo}   Convert list to string and return     ${list_id_sp_promo}
    #post request
    ${request_payload}    Format String    {{"Order":{{"Id":{0},"BranchId":{1},"RetailerId":{2},"CustomerId":{3},"SoldById":{4},"SoldBy":{{"CreatedBy":0,"CreatedDate":"2018-12-10T08:33:32.447Z","GivenName":"admin","Id":{4},"IsActive":true,"IsAdmin":true,"Type":0,"isDeleted":false,"Name":"admin"}},"SaleChannelId":0,"SaleChannel":null,"Seller":{{"CreatedBy":0,"CreatedDate":"2018-12-10T08:33:32.447Z","GivenName":"admin","Id":{4},"IsActive":true,"IsAdmin":true,"Type":0,"isDeleted":false,"Name":"admin"}},"PurchaseDate":"","Code":"{5}","Discount":{6},"DiscountRatio":{7},"OrderDetails":[{8},{9}],"InvoiceOrderSurcharges":[],"OrderPromotions":[{{"Type":3,"TargetType":0,"SalePromotionId":{10},"PromotionId":{11},"ProductId":{12},"ProductQty":2,"PromotionInfo":"Khuyến mại hóa đơn giảm giá SP %: Tổng tiền hàng từ 5,000,000 giảm giá 10% cho 2 DV031 - Dập phồng tóc - Loreal","PrintPromotionInfo":"Tổng tiền hàng từ 5,000,000 giảm giá 10% cho 2 Dập phồng tóc - Loreal","ProductIds":"{13}"}}],"Payments":[{{"OrderValue":0,"DocumentValue":0,"PaidValue":0,"NeedPayValue":0,"CustomerName":"","CustomerCode":"","InvoiceCode":"","CustomerDebt":0,"CustomerOldDebt":0,"TargetCode":"","UserName":"","VoucherCampaignId":0,"Version":0,"IsUpdate":false,"TransGuid":"00000000000000000000000000000000","DocumentTypeValue":0,"Id":{14},"Code":"TTDH000579","Amount":{15},"AmountOriginal":0,"Method":"Cash","CreatedDate":"","CreatedBy":{4},"RetailerId":{2},"BranchId":{1},"OrderId":{0},"CustomerId":{3},"TransDate":"","UserId":{4},"Status":0,"System":false,"DeliveryPayments":[],"PaymentAllocation":[]}},{{"Method":"Cash","MethodStr":"Tiền mặt","Amount":{16},"Id":-2}}],"UsingCod":0,"Status":1,"Total":3118004,"Extra":"{{\\"Amount\\":3018004,\\"Method\\":{{\\"Id\\":\\"Cash\\",\\"Label\\":\\"Tiền mặt\\"}},\\"activeCustomerGroupId\\":null,\\"ResetPromotion\\":false}}","Surcharge":0,"Type":2,"Uuid":"W156646859424149","addToAccount":"0","PayingAmount":3018004,"TotalBeforeDiscount":3125004,"ProductDiscount":7000,"CreatedBy":441968,"CreatedDate":"2","InvoiceWarranties":[]}}}}    ${get_order_id}    ${BRANCH_ID}    ${get_id_nguoitao}    ${get_id_kh}    ${get_id_nguoiban}
    ...     ${order_code}    ${result_ggdh}    ${input_ggdh}    ${liststring_prs_order_detail}    ${liststring_prs_order_detail_promo}   ${get_id_sale_promo}
    ...     ${get_id_promotion}    ${id_sp_promo}    ${list_id_sp_promo}   ${get_payment_id}    ${get_khachdatra_in_dh_bf_execute}    ${actual_khachtt}
    Log    ${request_payload}
    ${order_code}    Post request to create order and return code    ${request_payload}
    #get values
    Sleep    20 s    wait for response to API
    #assert values in order
    ${get_ma_kh_in_dh_af_execute}    ${get_TTDH_in_dh_af_execute}    ${get_tongtienhang_in_dh_af_exxecute}    ${get_khachdatra_in_dh_af_execute}    ${get_giamgia_in_dh_af_execute}    ${get_tongcong_in_dh_af_execute}    ${get_ghichu_in_dh_af_execute}
    ...    Get order info incase discount by order code    ${order_code}
    Should Be Equal As Strings    ${get_ma_kh_in_dh_af_execute}    ${get_ma_kh_in_dh_af_execute}
    Should Be Equal As Numbers    ${get_TTDH_in_dh_af_execute}    1    #1 : phiếu tạm
    Should Be Equal As Numbers    ${get_tongtienhang_in_dh_af_exxecute}    ${actual_tongtienhang}
    Should Be Equal As Numbers    ${get_khachdatra_in_dh_af_execute}    ${result_khachdatra}
    Should Be Equal As Numbers    ${get_giamgia_in_dh_af_execute}    ${result_ggdh}
    Should Be Equal As Numbers    ${get_tongcong_in_dh_af_execute}    ${result_khachdatra}
    #assert value product
    ${list_order_summary_af_execute}    Get list order summary frm product API    ${list_product}
    : FOR    ${result_tong_dh}    ${order_summary_af_execute}    IN ZIP    ${get_list_ordersummary_bf_execute}    ${list_order_summary_af_execute}
    \    Should Be Equal As Numbers    ${order_summary_af_execute}    ${result_tong_dh}
    Delete order frm Order code    ${order_code}
    Toggle status of promotion    ${input_khuyemmai}    0
