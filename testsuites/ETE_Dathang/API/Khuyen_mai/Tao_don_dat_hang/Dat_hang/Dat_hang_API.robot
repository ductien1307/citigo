*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    ${headless_browser}
Resource          ../../../../../../core/API/api_thietlap.robot
Resource          ../../../../../../core/API/api_dathang.robot
Resource          ../../../../../../core/Ban_Hang/banhang_getandcompute.robot
Resource          ../../../../../../core/share/toast_message.robot
Resource          ../../../../../../core/API/api_mhbh_dathang.robot
Resource          ../../../../../../core/API/api_soquy.robot
Resource          ../../../../../../core/API/api_danhmuc_hanghoa.robot

*** Variables ***
&{list_product1}    PROMO4=2.5
&{list_product2}    PROMO5=5.3
&{dic_serial}    SIL009=3    SIL010=1
&{list_giveaway1}    DV031=1    DV032=1    DV033=1
&{list_giveaway2}    DV031=1
&{list_giveaway3}    DV032=1    DV033=1
@{list_no_discount}    0    0
@{list_ggsp}      2000

*** Test Cases ***    Product and num list    Product Discount                                                    Order Discount    Customer    Payment    Promotion Code
KM DH                 [Tags]                  AKMDH1
                      [Template]              edhkm1_api
                      ${list_product1}        ${list_ggsp}                                                        15                 CTKH120     500000      KM02                #giam gia HD %
                      ${list_product1}        ${list_ggsp}                                                        16                 CTKH121     all        KM01                #giam gia HD VND

KM dat hang tang hang
                      [Documentation]         San pham KM la SP dich vu\nCase khong validate ton kho cua SP KM
                      [Tags]                  AKMDH1
                      [Template]              edhkm2_api
                      ${list_product2}        30000                                                               CTKH259           0           KM03      ${list_giveaway1}    ${list_no_discount}
                      ${list_product2}        50000                                                               CTKH260           all         KM03      ${list_giveaway1}    ${list_no_discount}

KM dat hang giam gia SP
                      [Tags]                  AKMDH1
                      [Template]              edhkm3_api
                      ${dic_serial}          50000                                                               CTKH261           50000       KM04      ${list_giveaway2}    ${list_no_discount}
                      ${dic_serial}          0                                                                   CTKH262           0           KM05      ${list_giveaway3}    ${list_no_discount}

*** Keywords ***
edhkm1_api
    [Arguments]    ${dict_product_num}    ${list_discount_product}    ${input_ggdh}    ${input_ma_kh}    ${input_bh_khachtt}    ${input_khuyemmai}
    ## Get info ton cuoi, cong no khach hang
    Toggle status of promotion    ${input_khuyemmai}    1
    ${list_product}    Get Dictionary Keys    ${dict_product_num}
    ${list_nums}    Get Dictionary Values    ${dict_product_num}
    ${order_value}    ${discount}    ${discount_ratio}    ${name}    Get Invoice value - Discounts - Promotion Name from Promotion Code    ${input_khuyemmai}
    ${get_no_bf_execute}    ${get_tongban_bf_execute}    ${get_tongban_tru_trahang_bf_execute}    Get Customer Debt from API    ${input_ma_kh}
    ${list_result_thanhtien}    ${list_result_order_summary}    ${list_result_giamoi}    Get list total sale and order summary incase discount    ${list_product}    ${list_nums}    ${list_discount_product}
    #compute
    ${result_tongtienhang}    Sum values in list    ${list_result_thanhtien}
    ${result_af_invoice_discount}    Price after % discount invoice    ${result_tongtienhang}    ${input_ggdh}
    ${result_discount_invoice_by_vnd}    Convert % discount to VND and round    ${result_tongtienhang}    ${input_ggdh}
    ${result_discount_ratio_by_invoice_promo}    Convert % discount to VND and round    ${result_tongtienhang}    ${discount_ratio}
    ${actual_promo_value}    Set Variable If    ${discount} == 0    ${result_discount_ratio_by_invoice_promo}    ${discount}
    ${final_discount}=    Run Keyword If    ${result_tongtienhang} > ${order_value}    Sum    ${actual_promo_value}    ${result_discount_invoice_by_vnd}
    ...    ELSE    Set Variable    ${result_discount_invoice_by_vnd}
    ${result_khachcantra}    Minus    ${result_tongtienhang}    ${final_discount}
    ${result_khachcantra}    Replace floating point    ${result_khachcantra}
    ${actual_khachtt}    Set Variable If    '${input_bh_khachtt}' == 'all'    ${result_khachcantra}    ${input_bh_khachtt}
    ${result_nohientai}    Minus    ${get_no_bf_execute}    ${actual_khachtt}
    ${result_tongban}    Sum    ${result_khachcantra}    ${get_tongban_bf_execute}
    #create order
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${get_id_sale_promo}    ${get_id_promotion}    ${get_promo_discount}    Get promotion info    ${input_khuyemmai}
    ${jsonpath_id_kh}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_kh}
    ${get_id_kh}    Get data from API    ${endpoint_khachhang}    ${jsonpath_id_kh}
    ${endpoint_danhmuc_hh_co_dvt}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${get_resp_danhmuc_hh}    Get Request and return body    ${endpoint_danhmuc_hh_co_dvt}
    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}    Get list jsonpath product frm list product    ${list_product}
    ${list_giaban}    ${list_result_ggsp}    ${list_id_sp}    Get product info frm list jsonpath product have discount product    ${get_resp_danhmuc_hh}    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}    ${list_discount_product}
    ${text_promo_info}    Set Variable If    0 < ${get_promo_discount} < 100    Khuyến mại giảm giá Hóa đơn %: Tổng tiền hàng từ 4,000,000 giảm giá 5% cho hóa đơn     Khuyến mại giảm giá Hóa đơn VNĐ: Tổng tiền hàng từ 5,000,000 giảm giá 20,000 cho hóa đơn
    #post request
    ${liststring_prs_order_detail}     Set Variable      needdel
    Log        ${liststring_prs_order_detail}
    : FOR   ${item_result_ggsp}   ${item_ggsp}    ${item_gia_ban}   ${item_id_sp}   ${item_soluong}      IN ZIP   ${list_result_ggsp}    ${list_discount_product}       ${list_giaban}        ${list_id_sp}    ${list_nums}
    \    ${item_ggsp}   Set Variable If    0 < ${item_ggsp} < 100    ${item_ggsp}   0
    \    ${payload_each_product}        Format string       {{"BasePrice":105000.02,"Discount":{0},"DiscountRatio":{1},"IsLotSerialControl":false,"IsRewardPoint":false,"Note":"","Price":{2},"ProductCode":"HH0052","ProductId":{3},"ProductName":"Bánh Pía Sầu Riêng Truly Vietnam Có Trứng","Quantity":{4},"Uuid":"","ProductBatchExpireId":null}}   ${item_result_ggsp}   ${item_ggsp}       ${item_gia_ban}   ${item_id_sp}   ${item_soluong}
    \    ${liststring_prs_order_detail}       Catenate      SEPARATOR=,      ${liststring_prs_order_detail}      ${payload_each_product}
    ${liststring_prs_order_detail}       Replace String      ${liststring_prs_order_detail}       needdel,       ${EMPTY}      count=1
    ${giamgia}    Set Variable If    0 < ${input_ggdh} < 100    ${input_ggdh}     0
    ${key_discount}    Set Variable If    0 < ${get_promo_discount} < 100    DiscountRatio     Discount
    ${request_payload}    Format String    {{"Order":{{"BranchId":{0},"RetailerId":{1},"CustomerId":{2},"SoldById":{3},"SoldBy":{{"CreatedBy":0,"CreatedDate":"2018-07-30T08:27:36.800Z","Email":"","GivenName":"anh.lv","Id":{3},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false}},"SaleChannelId":0,"SaleChannel":null,"Seller":{{"CreatedBy":0,"CreatedDate":"2018-07-30T08:27:36.800Z","Email":"","GivenName":"anh.lv","Id":{3},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false}},"Code":"Đặt hàng 1","Discount":{4},"DiscountRatio":{5},"OrderDetails":[{6}],"InvoiceOrderSurcharges":[],"OrderPromotions":[{{"Type":1,"TargetType":0,"SalePromotionId":{7},"PromotionId":{8},"{9}":{10},"PromotionInfo":"{11}","PrintPromotionInfo":"{11}"}}],"Payments":[{{"Method":"Cash","MethodStr":"Tiền mặt","Amount":{12},"Id":-1}}],"UsingCod":0,"Status":1,"Total":995000,"Extra":"{{\\"Amount\\":195000,\\"Method\\":{{\\"Id\\":\\"Cash\\",\\"Label\\":\\"Tiền mặt\\"}},\\"ResetPromotion\\":false}}","Surcharge":0,"Type":2,"Uuid":"","addToAccount":"0","PayingAmount":195000,"TotalBeforeDiscount":1015000,"ProductDiscount":0,"CreatedBy":201567,"InvoiceWarranties":[],"DiscountByPromotion":20000,"DiscountByPromotionValue":20000,"DiscountByPromotionRatio":0}}}}    ${BRANCH_ID}    ${get_id_nguoitao}    ${get_id_kh}    ${get_id_nguoiban}   ${final_discount}    ${giamgia}    ${liststring_prs_order_detail}    ${get_id_sale_promo}
    ...    ${get_id_promotion}   ${key_discount}    ${get_promo_discount}     ${text_promo_info}    ${actual_khachtt}
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
    Should Be Equal As Numbers    ${get_khachdatra_in_dh_af_execute}    ${actual_khachtt}
    Should Be Equal As Numbers    ${get_giamgia_in_dh_af_execute}    ${final_discount}
    Should Be Equal As Numbers    ${get_tongcong_in_dh_af_execute}    ${result_khachcantra}
    #assert value product
    ${list_order_summary_af_execute}    Get list order summary frm product API    ${list_product}
    : FOR    ${result_tong_dh}    ${order_summary_af_execute}    IN ZIP    ${list_result_order_summary}    ${list_order_summary_af_execute}
    \    Should Be Equal As Numbers    ${order_summary_af_execute}    ${result_tong_dh}
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
    #Delete order frm Order code    ${order_code}
    Toggle status of promotion    ${input_khuyemmai}    0

edhkm2_api
    [Arguments]    ${dict_product_nums}    ${input_ggdh}    ${input_ma_kh}    ${input_bh_khachtt}    ${input_khuyemmai}    ${list_giveaway}
    ...    ${list_discount}
    [Timeout]
    ## Get info ton cuoi, cong no khach hang
    Toggle status of promotion    ${input_khuyemmai}    1
    ${order_value}    ${received_value}    ${discount}    ${discount_ratio}    ${name}    Get Invoice value - Received value - Discounts - Promotion Name from Promotion Code    ${input_khuyemmai}
    #create lists
    ${list_prs}    Get Dictionary Keys    ${dict_product_nums}
    ${list_nums}    Get Dictionary Values    ${dict_product_nums}
    ${list_giveaway_product}    Get Dictionary Keys    ${list_giveaway}
    ${list_giveaway_num}    Get Dictionary Values    ${list_giveaway}
    ${list_result_thanhtien}    ${list_result_order_summary}    ${list_result_newprice}    Get list total sale and order summary incase discount    ${list_prs}    ${list_nums}    ${list_discount}
    ${list_result_order_summary_promotion}    Get list result order summary frm product API    ${list_giveaway_product}    ${list_giveaway_num}
    #compute
    ${result_tongtienhang}    Sum values in list    ${list_result_thanhtien}
    ${result_khachcantra}    Minus    ${result_tongtienhang}    ${input_ggdh}
    ${actual_khachtt}    Set Variable If    '${input_bh_khachtt}' == 'all'    ${result_khachcantra}    ${input_bh_khachtt}
    #create order
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${jsonpath_id_kh}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_kh}
    ${get_id_kh}    Get data from API    ${endpoint_khachhang}    ${jsonpath_id_kh}
    ${endpoint_danhmuc_hh_co_dvt}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${get_resp_danhmuc_hh}    Get Request and return body    ${endpoint_danhmuc_hh_co_dvt}
    ${get_id_sale_promo}    ${get_id_promotion}    ${get_promo_discount}    Get promotion info    ${input_khuyemmai}
    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}    Get list jsonpath product frm list product    ${list_prs}
    ${list_giaban}    ${list_id_sp}    Get product info frm list jsonpath product    ${get_resp_danhmuc_hh}    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}
    ${list_jsonpath_id_sp_promo}    ${list_jsonpath_giaban_promo}    Get list jsonpath product frm list product    ${list_giveaway_product}
    ${list_giaban_promo}    ${list_id_sp_promo}    Get product info frm list jsonpath product    ${get_resp_danhmuc_hh}    ${list_jsonpath_id_sp_promo}    ${list_jsonpath_giaban_promo}
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
    : FOR    ${item_gia_ban_promo}   ${item_id_sp_promo}   ${item_soluong_promo}      IN ZIP   ${list_giaban_promo}        ${list_id_sp_promo}    ${list_giveaway_num}
    \    ${payload_each_product_promo}        Format string       {{"BasePrice":40000,"Discount":{0},"IsLotSerialControl":false,"IsRewardPoint":false,"Note":"","Price":{0},"ProductCode":"DV032","ProductId":{1},"ProductName":"Nhuộm tóc - Loreal","PromotionParentType":0,"Quantity":{2},"SalePromotionId":{3},"Uuid":"","ProductBatchExpireId":null}}   ${item_gia_ban_promo}   ${item_id_sp_promo}   ${item_soluong_promo}    ${get_id_sale_promo}
    \    ${liststring_prs_order_detail_promo}       Catenate      SEPARATOR=,      ${liststring_prs_order_detail_promo}      ${payload_each_product_promo}
    ${liststring_prs_order_detail_promo}       Replace String      ${liststring_prs_order_detail_promo}       needdel,       ${EMPTY}      count=1
    ${id_sp_promo1}     Get From List    ${list_id_sp_promo}    0
    ${list_id_sp_promo}   Convert list to string and return     ${list_id_sp_promo}
    #post request
    ${request_payload}    Format String    {{"Order":{{"BranchId":{0},"RetailerId":{1},"CustomerId":{2},"SoldById":{3},"SoldBy":{{"CreatedBy":0,"CreatedDate":"2018-07-30T08:27:36.800Z","Email":"","GivenName":"anh.lv","Id":{3},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false}},"SaleChannelId":0,"SaleChannel":null,"Seller":{{"CreatedBy":0,"CreatedDate":"2018-07-30T08:27:36.800Z","Email":"","GivenName":"anh.lv","Id":{3},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false}},"Code":"Đặt hàng 1","Discount":{4},"OrderDetails":[{5},{6}],"InvoiceOrderSurcharges":[],"OrderPromotions":[{{"Type":2,"TargetType":0,"SalePromotionId":{7},"PromotionId":{8},"ProductId":{9},"ProductQty":3,"PromotionInfo":"Khuyến mại hóa đơn tặng hàng: Tổng tiền hàng từ 5,000,000 tặng 1 DV031 - Dập phồng tóc - Loreal, 1 DV032 - Nhuộm tóc - Loreal, 1 DV033 - Hấp phục hồi Loreal cho hóa đơn","PrintPromotionInfo":"Tổng tiền hàng từ 5,000,000 tặng 1 Dập phồng tóc - Loreal, 1 Nhuộm tóc - Loreal, 1 Hấp phục hồi Loreal cho hóa đơn","ProductIds":"{10}"}}],"Payments":[{{"Method":"Cash","MethodStr":"Tiền mặt","Amount":{11},"Id":-1}}],"UsingCod":0,"Status":1,"Total":1074800,"Extra":"{{\\"Amount\\":500000,\\"Method\\":{{\\"Id\\":\\"Cash\\",\\"Label\\":\\"Tiền mặt\\"}},\\"ResetPromotion\\":false}}","Surcharge":0,"Type":2,"Uuid":"","addToAccount":"0","PayingAmount":500000,"TotalBeforeDiscount":1194800,"ProductDiscount":90000,"CreatedBy":201567,"InvoiceWarranties":[]}}}}    ${BRANCH_ID}    ${get_id_nguoitao}    ${get_id_kh}    ${get_id_nguoiban}
    ...    ${input_ggdh}      ${liststring_prs_order_detail}     ${liststring_prs_order_detail_promo}
    ...    ${get_id_sale_promo}    ${get_id_promotion}    ${id_sp_promo1}        ${list_id_sp_promo}    ${actual_khachtt}
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
    Should Be Equal As Numbers    ${get_khachdatra_in_dh_af_execute}    ${actual_khachtt}
    Should Be Equal As Numbers    ${get_giamgia_in_dh_af_execute}    ${input_ggdh}
    Should Be Equal As Numbers    ${get_tongcong_in_dh_af_execute}    ${result_khachcantra}
    #assert value product
    ${list_order_summary_af_execute}    Get list order summary frm product API    ${list_prs}
    : FOR    ${result_tong_dh}    ${order_summary_af_execute}    IN ZIP    ${list_result_order_summary}    ${list_order_summary_af_execute}
    \    Should Be Equal As Numbers    ${order_summary_af_execute}    ${result_tong_dh}
    #assert value product promotion
    ${list_order_summary_af_execute_promotion}    Get list order summary frm product API    ${list_giveaway_product}
    : FOR    ${result_order_summary_pro}    ${order_summary_af_execute_pro}    IN ZIP    ${list_result_order_summary_promotion}    ${list_order_summary_af_execute_promotion}
    \    Should Be Equal As Numbers    ${order_summary_af_execute_pro}    ${result_order_summary_pro}
    #Delete order frm Order code    ${order_code}
    Toggle status of promotion    ${input_khuyemmai}    0

edhkm3_api
    [Arguments]    ${dict_product_num}    ${input_ggdh}    ${input_ma_kh}    ${input_bh_khachtt}    ${input_khuyemmai}    ${dict_promo_product}
    ...    ${list_discount}
    [Timeout]
    ## Get info ton cuoi, cong no khach hang
    Toggle status of promotion    ${input_khuyemmai}    1
    ${order_value}    ${received_value}    ${discount}    ${discount_ratio}    ${name}    Get Invoice value - Received value - Discounts - Promotion Name from Promotion Code    ${input_khuyemmai}
    ${list_product}    Get Dictionary Keys    ${dict_product_num}
    ${list_nums}    Get Dictionary Values    ${dict_product_num}
    ${list_promo_product}    Get Dictionary Keys    ${dict_promo_product}
    ${list_promo_num}    Get Dictionary Values    ${dict_promo_product}
    # Promo products
    ${result_discount}    Set Variable If    ${discount_ratio} != 0    ${discount_ratio}    ${discount}
    ${list_result_totalsale_promo}    ${list_result_onhand_promo}    Run keyword if    ${discount} != 0    Get list of total sale - result onhand in case discount product    ${list_promo_product}    ${list_promo_num}
    ...    ${discount}    ELSE    Get list of total sale - result onhand in case discount product    ${list_promo_product}    ${list_promo_num}    ${discount_ratio}
    ${total_promo_sale}    Sum values in list    ${list_result_totalsale_promo}
    ${list_result_thanhtien}    ${list_result_order_summary}    ${list_result_newprice}    Get list total sale and order summary incase discount    ${list_product}    ${list_nums}    ${list_discount}
    #computation
    ${result_tongtienhang}    Sum values in list    ${list_result_thanhtien}
    ${result_tongtienhang_promo}    Sum    ${result_tongtienhang}    ${total_promo_sale}
    ${actual_tongtienhang}    Set Variable If    ${result_tongtienhang} > ${order_value}    ${result_tongtienhang_promo}    ${result_tongtienhang}
    ${result_khachcantra}    Minus and replace floating point     ${actual_tongtienhang}    ${input_ggdh}
    ${actual_khachtt}    Set Variable If    '${input_bh_khachtt}' == 'all'    ${result_khachcantra}    ${input_bh_khachtt}
    #create orders
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${jsonpath_id_kh}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_kh}
    ${get_id_kh}    Get data from API    ${endpoint_khachhang}    ${jsonpath_id_kh}
    ${endpoint_danhmuc_hh_co_dvt}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${get_resp_danhmuc_hh}    Get Request and return body    ${endpoint_danhmuc_hh_co_dvt}
    ${get_id_sale_promo}    ${get_id_promotion}    ${get_promo_discount}    Get promotion info    ${input_khuyemmai}
    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}    Get list jsonpath product frm list product    ${list_product}
    ${list_giaban}    ${list_id_sp}    Get product info frm list jsonpath product    ${get_resp_danhmuc_hh}    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}
    ${list_jsonpath_id_sp_promo}    ${list_jsonpath_giaban_promo}    Get list jsonpath product frm list product    ${list_promo_product}
    ${list_giaban_promo}    ${list_id_sp_promo}    Get product info frm list jsonpath product    ${get_resp_danhmuc_hh}    ${list_jsonpath_id_sp_promo}    ${list_jsonpath_giaban_promo}
    ${text_promo_info}    Set Variable If    0 < ${discount_ratio} < 100    Khuyến mại hóa đơn giảm giá SP %: Tổng tiền hàng từ 5,000,000 giảm giá 10% cho 1 DV031 - Dập phồng tóc - Loreal, 1 DV032 - Nhuộm tóc - Loreal     Khuyến mại hóa đơn giảm giá SP VND: Tổng tiền hàng từ 5,000,000 giảm giá 20,000 cho 1 DV031 - Dập phồng tóc - Loreal
    ${text_promo_print}    Set Variable If    0 < ${discount_ratio} < 100   Tổng tiền hàng từ 5,000,000 giảm giá 10% cho 1 Dập phồng tóc - Loreal, 1 Nhuộm tóc - Loreal     Tổng tiền hàng từ 5,000,000 giảm giá 20,000 cho 1 Dập phồng tóc - Loreal
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
    : FOR    ${item_gia_ban_promo}   ${item_id_sp_promo}   ${item_soluong_promo}      IN ZIP   ${list_giaban_promo}        ${list_id_sp_promo}    ${list_promo_num}
    \    ${giamgia}   Run Keyword If   0 < ${result_discount} < 100    Convert % discount to VND and round     ${item_gia_ban_promo}    ${result_discount}    ELSE    Set Variable    ${result_discount}
    \    ${payload_each_product_promo}        Format string       {{"BasePrice":{0},"Discount":{1},"IsLotSerialControl":false,"IsRewardPoint":false,"Note":"","Price":{0},"ProductCode":"DV032","ProductId":{2},"ProductName":"Nhuộm tóc - Loreal","PromotionParentType":0,"Quantity":{3},"SalePromotionId":{4},"Uuid":"","ProductBatchExpireId":null}}   ${item_gia_ban_promo}    ${giamgia}   ${item_id_sp_promo}   ${item_soluong_promo}    ${get_id_sale_promo}
    \    ${liststring_prs_order_detail_promo}       Catenate      SEPARATOR=,      ${liststring_prs_order_detail_promo}      ${payload_each_product_promo}
    ${liststring_prs_order_detail_promo}       Replace String      ${liststring_prs_order_detail_promo}       needdel,       ${EMPTY}      count=1
    ${id_sp_promo1}     Get From List    ${list_id_sp_promo}    0
    ${list_id_sp_promo}   Convert list to string and return     ${list_id_sp_promo}
    #post request
    ${request_payload}    Format String    {{"Order":{{"BranchId":{0},"RetailerId":{1},"CustomerId":{2},"SoldById":{3},"SoldBy":{{"CreatedBy":0,"CreatedDate":"2018-07-30T08:27:36.800Z","Email":"","GivenName":"anh.lv","Id":{3},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false}},"SaleChannelId":0,"SaleChannel":null,"Seller":{{"CreatedBy":0,"CreatedDate":"2018-07-30T08:27:36.800Z","Email":"","GivenName":"anh.lv","Id":{3},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false}},"Code":"Đặt hàng 1","Discount":{4},"OrderDetails":[{5},{6}],"InvoiceOrderSurcharges":[],"OrderPromotions":[{{"Type":3,"TargetType":0,"SalePromotionId":{7},"PromotionId":{8},"ProductId":{9},"ProductQty":2,"PromotionInfo":"{10}","PrintPromotionInfo":"{11}","ProductIds":"{12}"}}],"Payments":[{{"Method":"Cash","MethodStr":"Tiền mặt","Amount":{13},"Id":-1}}],"UsingCod":0,"Status":1,"Total":2460000,"Extra":"{{\\"Amount\\":2460000,\\"Method\\":{{\\"Id\\":\\"Cash\\",\\"Label\\":\\"Tiền mặt\\"}},\\"ResetPromotion\\":false}}","Surcharge":0,"Type":2,"Uuid":"W156594778992155","addToAccount":"0","PayingAmount":2460000,"TotalBeforeDiscount":3082000,"ProductDiscount":7000,"CreatedBy":201567,"InvoiceWarranties":[]}}}}    ${BRANCH_ID}    ${get_id_nguoitao}    ${get_id_kh}    ${get_id_nguoiban}
    ...    ${input_ggdh}      ${liststring_prs_order_detail}    ${liststring_prs_order_detail_promo}    ${get_id_sale_promo}    ${get_id_promotion}    ${id_sp_promo1}    ${text_promo_info}    ${text_promo_print}        ${list_id_sp_promo}    ${actual_khachtt}
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
    Should Be Equal As Numbers    ${get_khachdatra_in_dh_af_execute}    ${actual_khachtt}
    Should Be Equal As Numbers    ${get_giamgia_in_dh_af_execute}    ${input_ggdh}
    Should Be Equal As Numbers    ${get_tongcong_in_dh_af_execute}    ${result_khachcantra}
    #assert value product
    ${list_order_summary_af_execute}    Get list order summary frm product API    ${list_product}
    : FOR    ${result_tong_dh}    ${order_summary_af_execute}    IN ZIP    ${list_result_order_summary}    ${list_order_summary_af_execute}
    \    Should Be Equal As Numbers    ${order_summary_af_execute}    ${result_tong_dh}
    Delete order frm Order code    ${order_code}
    Toggle status of promotion    ${input_khuyemmai}    0
