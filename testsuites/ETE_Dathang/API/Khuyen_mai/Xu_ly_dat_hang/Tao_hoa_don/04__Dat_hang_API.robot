*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    ${headless_browser}
Resource          ../../../../../../core/API/api_thietlap.robot
Resource          ../../../../../../core/API/api_dathang.robot
Resource          ../../../../../../core/Ban_Hang/banhang_getandcompute.robot
Resource          ../../../../../../core/share/toast_message.robot
Resource          ../../../../../../core/API/api_mhbh_dathang.robot
Resource          ../../../../../../core/API/api_hoadon_banhang.robot
Resource          ../../../../../../core/API/api_mhbh.robot
Resource          ../../../../../../core/API/api_soquy.robot
Resource          ../../../../../../core/API/api_danhmuc_hanghoa.robot
Resource          ../../../../../../core/Dat_Hang/dat_hang_action.robot
Resource          ../../../../../../core/Dat_Hang/dat_hang_page.robot

*** Variables ***
&{list_product1}    SIL011=1    Combo169=4
&{list_product2}    Combo168=2    Combo170=3
&{list_giveaway1}    DV031=1    DV032=1    DV033=1
&{list_giveaway2}    DV031=2
@{list_ggsp}      2000    10
@{list_giamoi}    1500000   120000
@{list_no_discount}  0      0

*** Test Cases ***    Product and num list    List imei                    Product Discount        Order Discount    Customer    Payment    Promotion Code       Khách thanh toán to create order
KM DH                 [Tags]                  AKMDH5
                      [Template]              edxkm1_api
                      ${list_product1}      ${list_ggsp}      10          CTKH274     all          KM01          all        #giam gia HD VND

KM dat hang tang hang
                      [Documentation]         San pham KM la SP dich vu\nCase khong validate ton kho cua SP KM
                      [Tags]                  AKMDH5
                      [Template]              edxkm2_api
                      ${list_product2}      50000     CTKH275           250000      KM03      ${list_giveaway1}    ${list_giamoi}     0

KM dat hang giam gia SP
                      [Tags]                  AKMDH5
                      [Template]              edxkm3_api
                      ${list_product1}      15          CTKH276           all         KM05      ${list_giveaway2}    100000

*** Keywords ***
edxkm1_api
    [Arguments]    ${dict_product_num}    ${list_discount_product}    ${input_discount_inv}    ${input_ma_kh}    ${input_tamung}    ${input_khuyemmai}    ${input_khtt_create_order}
    ## Get info ton cuoi, cong no khach hang
    Toggle status of promotion    ${input_khuyemmai}    1
    ${order_code}     Add new order with order - order discount promotion    ${input_ma_kh}    ${dict_product_num}    ${input_khuyemmai}    ${input_khtt_create_order}
    ${list_product}    Get Dictionary Keys    ${dict_product_num}
    ${list_nums}    Get Dictionary Values    ${dict_product_num}
    ${invoice_value}    ${discount}    ${discount_ratio}    ${name}    Get Invoice value - Discounts - Promotion Name from Promotion Code    ${input_khuyemmai}
    Create list imei and other product    ${list_product}    ${list_nums}
    ${get_ma_dh_in_dh_bf_execute}    ${get_khachdatra_in_dh_bf_execute}    ${get_ggdh_in_dh_bf_execute}    ${get_tongtienhang_in_dh_bf_execute}    ${get_tongcong_in_dh_bf_execute}    Get order code - paid - discount value frm API    ${input_ma_kh}
    ${get_no_bf_execute}    ${get_tongban_bf_execute}    ${get_tongban_tru_trahang_bf_execute}    Get Customer Debt from API    ${input_ma_kh}
    ${get_list_ordersummary_bf_execute}    Get list order summary by order code    ${order_code}
    ${list_result_order_summary}    Get list order summary after create invoice    ${get_list_ordersummary_bf_execute}    ${list_nums}
    ${list_result_thanhtien}    ${list_order_summary}    ${list_result_giamoi}    Get list total sale and order summary incase discount    ${list_product}    ${list_nums}    ${list_ggsp}
    #compute
    ${result_tongtienhang}    Sum values in list    ${list_result_thanhtien}
    ${result_af_invoice_discount}    Price after % discount invoice    ${result_tongtienhang}    ${input_discount_inv}
    ${result_discount_invoice_by_vnd}    Convert % discount to VND and round    ${result_tongtienhang}    ${input_discount_inv}
    ${result_discount_ratio_by_invoice_promo}    Convert % discount to VND and round    ${result_tongtienhang}    ${discount_ratio}
    ${actual_promo_value}    Set Variable If    ${discount} == 0    ${result_discount_ratio_by_invoice_promo}    ${discount}
    ${final_discount}=    Run Keyword If    ${result_tongtienhang} > ${invoice_value}    Sum    ${actual_promo_value}    ${result_discount_invoice_by_vnd}
    ...    ELSE    Set Variable    ${result_discount_invoice_by_vnd}
    ${result_khachcantra}    Minus    ${result_tongtienhang}    ${final_discount}
    ${result_tamung}  Run Keyword If    ${result_khachcantra}>${get_khachdatra_in_dh_bf_execute}    Minus and replace floating point        ${result_khachcantra}   ${get_khachdatra_in_dh_bf_execute}
    ...   ELSE    Minus and replace floating point    ${get_khachdatra_in_dh_bf_execute}    ${result_khachcantra}
    ${actual_tamung}    Set Variable If    '${input_tamung}' == 'all'    ${result_tamung}    ${input_tamung}
    ${result_nohientai}    Sum    ${get_no_bf_execute}    ${result_khachcantra}
    ${result_PTT_hd_KH}    Sum    ${result_nohientai}    ${actual_tamung}
    ${result_tongban}    Sum    ${result_khachcantra}    ${get_tongban_bf_execute}
    #create invoice
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
    ${list_giaban}    ${list_result_ggsp}    ${list_id_sp}    Get product info frm list jsonpath product have discount product    ${get_resp_danhmuc_hh}    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}   ${list_discount_product}
    #list payload of product new
    ${liststring_prs_order_detail}     Set Variable      needdel
    Log        ${liststring_prs_order_detail}
    : FOR   ${item_gia_ban}   ${item_id_sp}   ${item_soluong}    ${item_imei}     ${item_result_ggsp}    ${item_ggps}   ${get_orderdetail_id}      IN ZIP   ${list_giaban}        ${list_id_sp}    ${list_nums}   ${imei_inlist}    ${list_result_ggsp}   ${list_discount_product}    ${get_list_order_detail_id}
    \    ${item_imei}    Convert list to string and return    ${item_imei}
    \    ${item_ggps}   Set Variable If    0 < ${item_ggps} < 100    ${item_ggps}   0
    \    ${payload_each_product}        Format string       {{"BasePrice":44000.53,"IsLotSerialControl":false,"IsRewardPoint":false,"Note":"","Price":{0},"ProductId":{1},"Quantity":{2},"ProductCode":"DV068","SerialNumbers":"{3}","Discount":{4},"DiscountRatio":{5},"ProductName":"Nails 20","IsMaster":true,"ProductBatchExpireId":null,"CategoryId":794172,"MasterProductId":{1},"Unit":"","Uuid":"","OrderDetailId":{6},"ProductWarranty":[]}}   ${item_gia_ban}   ${item_id_sp}   ${item_soluong}    ${item_imei}   ${item_result_ggsp}    ${item_ggps}    ${get_orderdetail_id}
    \    ${liststring_prs_order_detail}       Catenate      SEPARATOR=,      ${liststring_prs_order_detail}      ${payload_each_product}
    ${liststring_prs_order_detail}       Replace String      ${liststring_prs_order_detail}       needdel,       ${EMPTY}      count=1
    ${tamung}   Minus     0    ${actual_tamung}
    #post request
    ${request_payload}    Format String    {{"Invoice":{{"BranchId":{0},"RetailerId":{1},"OrderId":{2},"UpdateInvoiceId":0,"UpdateReturnId":0,"CustomerId":{3},"SoldById":{4},"SoldBy":{{"CreatedBy":0,"CreatedDate":"2018-07-30T08:27:36.800Z","GivenName":"anh.lv","Id":{4},"IsActive":true,"IsAdmin":true,"Type":0,"isDeleted":false,"Name":"anh.lv"}},"SaleChannelId":0,"Seller":{{"CreatedBy":0,"CreatedDate":"2018-07-30T08:27:36.800Z","GivenName":"anh.lv","Id":{4},"IsActive":true,"IsAdmin":true,"Type":0,"isDeleted":false,"Name":"anh.lv"}},"PriceBookId":0,"OrderCode":"{5}","Code":"Hóa đơn 1","Discount":{6},"DiscountRatio":{7},"InvoiceDetails":[{8}],"InvoiceOrderSurcharges":[],"InvoicePromotions":[{{"Discount":20000,"PromotionId":{9},"PromotionInfo":"Khuyến mại giảm giá Hóa đơn VNĐ: Tổng tiền hàng từ 5,000,000 giảm giá 20,000 cho hóa đơn","SalePromotionId":{10},"TargetType":0,"Type":1,"PrintPromotionInfo":"Khuyến mại giảm giá Hóa đơn VNĐ: Tổng tiền hàng từ 5,000,000 giảm giá 20,000 cho hóa đơn"}}],"Payments":[{{"Method":"Cash","MethodStr":"Tiền mặt","Amount":{11},"Id":-1}}],"Status":1,"Total":{12},"Surcharge":0,"Type":1,"Uuid":"","addToAccount":"0","PayingAmount":{12},"OrderPaidAmount":{13},"DepositReturn":{14},"TotalBeforeDiscount":{15},"ProductDiscount":275800,"PaidAmount":2800000,"DebugUuid":"","InvoiceWarranties":[],"DiscountByPromotion":20000,"DiscountByPromotionValue":20000,"CreatedBy":201567}}}}    ${BRANCH_ID}    ${get_id_nguoitao}    ${get_order_id}    ${get_id_kh}    ${get_id_nguoiban}
    ...     ${order_code}    ${final_discount}     ${input_discount_inv}    ${liststring_prs_order_detail}
    ...     ${get_id_promotion}   ${get_id_sale_promo}    ${tamung}   ${result_khachcantra}    ${get_khachdatra_in_dh_bf_execute}
    ...     ${actual_tamung}    ${result_tongtienhang}
    Log    ${request_payload}
    ${invoice_code}    Post request to create invoice and get invoice code    ${request_payload}
    #get values
    Sleep    20 s    wait for response to API
    #assert value invoice
    ${get_ma_kh_by_hd}    ${get_tong_tien_hang}    ${get_khachtt_af_execute}    ${get_gghd_af_execute}    ${get_khachcantra}    ${get_trangthai}    ${get_ghichu_in_hd_af_execute}
    ...    Get invoice info have note incase discount by invoice code    ${invoice_code}
    Should Be Equal As Numbers    ${get_tong_tien_hang}    ${result_tongtienhang}
    Should Be Equal As Numbers    ${get_khachcantra}    ${result_khachcantra}
    Should Be Equal As Numbers    ${get_khachtt_af_execute}    ${result_khachcantra}
    Should Be Equal As Strings    ${get_ma_kh_by_hd}    ${input_ma_kh}
    Should Be Equal As Numbers    ${get_gghd_af_execute}    ${final_discount}
    Should Be Equal As Strings    ${get_trangthai}    Hoàn thành
    ${get_ma_kh_in_dh_af_execute}    ${get_TTDH_in_dh_af_execute}    ${get_tongtienhang_in_dh_af_exxecute}    ${get_khachdatra_in_dh_af_execute}    ${get_giamgia_in_dh_af_execute}    ${get_tongcong_in_dh_af_execute}    ${get_ghichu_in_dh_af_execute}
    ...    Get order info have note incase discount by order code    ${order_code}
    Should Be Equal As Strings    ${get_ma_kh_in_dh_af_execute}    ${input_ma_kh}
    Should Be Equal As Numbers    ${get_TTDH_in_dh_af_execute}    3    #trạng thái hoàn thành
    Should Be Equal As Numbers    ${get_tongtienhang_in_dh_af_exxecute}    ${get_tongtienhang_in_dh_bf_execute}
    Should Be Equal As Numbers    ${get_khachdatra_in_dh_af_execute}    ${result_khachcantra}
    Should Be Equal As Numbers    ${get_giamgia_in_dh_af_execute}    ${get_ggdh_in_dh_bf_execute}
    Should Be Equal As Numbers    ${get_tongcong_in_dh_af_execute}    ${get_tongcong_in_dh_bf_execute}
    Validate invoice history frm Order    ${order_code}    ${invoice_code}    ${result_khachcantra}
    #assert value product
    ${get_list_ordersummary_af_execute}    Get list order summary by order code    ${order_code}
    : FOR    ${result_order_summary}    ${order_summary_af_execute}    IN ZIP    ${list_result_order_summary}    ${get_list_ordersummary_af_execute}
    \    Should Be Equal As Numbers    ${order_summary_af_execute}    ${result_order_summary}
    #assert customer and so quy
    ${get_no_af_execute_kh}    ${get_tongban_af_execute_kh}    ${get_tongban_tru_trahang_af_execute_kh}    Run Keyword If    ${input_tamung}!=0    Get Customer Debt from API after purchase    ${input_ma_kh}
    ...    ${invoice_code}    ${result_tongtienhang}
    ...    ELSE    Get Customer Debt from API    ${input_ma_kh}
    ${get_maphieu_soquy}    Get Ma Phieu Thu in So quy    ${invoice_code}
    Run Keyword If    '${input_tamung}' == '0'    Should Be Equal As Numbers    ${get_no_af_execute_kh}    ${result_nohientai}
    ...    ELSE    Should Be Equal As Numbers    ${get_no_af_execute_kh}    ${result_PTT_hd_KH}
    Should Be Equal As Numbers    ${get_tongban_af_execute_kh}    ${result_tongban}
    Run Keyword If    '${input_tamung}' == '0'    Validate customer history and debt if invoice is not paid frm order    ${input_ma_kh}    ${invoice_code}    ${result_nohientai}
    ...    ELSE    Validate customer history and debt if invoice is paid deposit refund frm order    ${input_ma_kh}    ${invoice_code}    ${result_nohientai}    ${result_PTT_hd_KH}
    Run Keyword If    '${result_tongtienhang}' == '0'    Validate history tab of customer frm Order    ${input_ma_kh}    ${invoice_code}
    Run Keyword If    '${input_tamung}' == '0'    Validate So quy info from Rest API if Invoice is not paid    ${get_maphieu_soquy}
    ...    ELSE    Validate So quy info from Rest API if Invoice is paid    ${get_maphieu_soquy}    ${result_tamung}
    Delete invoice by invoice code    ${invoice_code}
    Delete order frm Order code    ${order_code}
    Toggle status of promotion    ${input_khuyemmai}    0

edxkm2_api
    [Arguments]    ${dict_product_nums}    ${input_gghd}    ${input_ma_kh}    ${input_bh_khachtt}    ${input_khuyemmai}    ${list_giveaway}
    ...    ${list_newprice}   ${input_khach_tt_to_create}
    [Timeout]
    ## Get info ton cuoi, cong no khach hang
    Toggle status of promotion    ${input_khuyemmai}    1
    ${order_code}     Add new order with order - Offering free items Promotion    ${input_ma_kh}    ${dict_product_nums}    ${input_khuyemmai}    ${list_giveaway}       ${input_khach_tt_to_create}
    ${invoice_value}    ${received_value}    ${discount}    ${discount_ratio}    ${name}    Get Invoice value - Received value - Discounts - Promotion Name from Promotion Code    ${input_khuyemmai}
    #create lists
    ${list_product}    Get Dictionary Keys    ${dict_product_nums}
    ${list_nums}    Get Dictionary Values    ${dict_product_nums}
    Create list imei and other product    ${list_product}    ${list_nums}
    ${get_ma_dh_in_dh_bf_execute}    ${get_khachdatra_in_dh_bf_execute}    ${get_ggdh_in_dh_bf_execute}    ${get_tongtienhang_in_dh_bf_execute}    ${get_tongcong_in_dh_bf_execute}    Get order code - paid - discount value frm API    ${input_ma_kh}
    ${get_list_hh_in_dh_bf_execute}    ${get_ghichu_bf_execute}    Get ghi chu and list product frm API    ${order_code}
    ${get_list_nums}   ${get_list_ordersummary_bf_execute}    Get list quantity - order summary frm API    ${order_code}    ${get_list_hh_in_dh_bf_execute}
    ${list_result_order_summary}    Get list order summary after create invoice    ${get_list_ordersummary_bf_execute}    ${get_list_nums}
    ${result_list_thanhtien}    Create List
    :FOR    ${item_giaban}    ${item_soluong}   IN ZIP    ${list_newprice}    ${list_nums}
    \     ${result_thanhtien}    Multiplication and round    ${item_giaban}    ${item_soluong}
    \     Append to list    ${result_list_thanhtien}     ${result_thanhtien}
    #compute
    ${result_tongtienhang}    Sum values in list    ${result_list_thanhtien}
    ${result_khachcantra}    Minus    ${result_tongtienhang}    ${input_gghd}
    ${actual_khachtt}    Set Variable If    '${input_bh_khachtt}' == 'all'    ${result_khachcantra}    ${input_bh_khachtt}
    ${result_khachdatra}      Sum     ${get_khachdatra_in_dh_bf_execute}    ${actual_khachtt}
    #create invoice
    ${list_promo_product}    Get Dictionary Keys    ${list_giveaway}
    ${list_promo_num}    Get Dictionary Values    ${list_giveaway}
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${jsonpath_id_kh}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_kh}
    ${get_id_kh}    Get data from API    ${endpoint_khachhang}    ${jsonpath_id_kh}
    ${endpoint_danhmuc_hh_co_dvt}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${get_resp_danhmuc_hh}    Get Request and return body    ${endpoint_danhmuc_hh_co_dvt}
    ${get_id_sale_promo}    ${get_id_promotion}    ${get_promo_discount}    Get promotion info    ${input_khuyemmai}
    ${get_order_id}   ${get_payment_id}   Get order - payment frm order api    ${order_code}
    ${get_list_order_detail_id}   Get list orderdetail id frm order api    ${order_code}    ${list_product}
    ${get_list_order_detail_id_promo}   Get list orderdetail id frm order api    ${order_code}    ${list_promo_product}
    #get list gia ban, id san pham, discount of product
    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}    Get list jsonpath product frm list product    ${list_product}
    ${list_giaban}    ${list_result_ggsp}    ${list_id_sp}    Get product info and new price frm list product    ${get_resp_danhmuc_hh}    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}   ${list_newprice}
    ${list_jsonpath_id_sp_promo}    ${list_jsonpath_giaban_promo}    Get list jsonpath product frm list product    ${list_promo_product}
    ${list_giaban_promo}    ${list_id_sp_promo}    Get product info frm list jsonpath product    ${get_resp_danhmuc_hh}    ${list_jsonpath_id_sp_promo}    ${list_jsonpath_giaban_promo}
    #list payload of product
    ${liststring_prs_order_detail}     Set Variable      needdel
    Log        ${liststring_prs_order_detail}
    : FOR   ${item_gia_ban}   ${item_id_sp}   ${item_soluong}    ${item_imei}     ${item_result_ggsp}   ${get_orderdetail_id}      IN ZIP   ${list_giaban}        ${list_id_sp}    ${list_nums}   ${imei_inlist}    ${list_result_ggsp}   ${get_list_order_detail_id}
    \    ${item_imei}    Convert list to string and return    ${item_imei}
    \    ${payload_each_product}        Format string       {{"BasePrice":389000,"IsLotSerialControl":true,"IsRewardPoint":false,"Note":"","Price":{0},"ProductId":{1},"Quantity":{2},"ProductCode":"SI041","SerialNumbers":"{3}","Discount":{4},"DiscountRatio":null,"ProductName":"Lò Nướng Sunhouse SHD4210 (10L)","IsMaster":true,"ProductBatchExpireId":null,"CategoryId":794174,"MasterProductId":{1},"Unit":"","Uuid":"","OrderDetailId":{5},"ProductWarranty":[]}}   ${item_gia_ban}   ${item_id_sp}   ${item_soluong}    ${item_imei}   ${item_result_ggsp}    ${get_orderdetail_id}
    \    ${liststring_prs_order_detail}       Catenate      SEPARATOR=,      ${liststring_prs_order_detail}      ${payload_each_product}
    ${liststring_prs_order_detail}       Replace String      ${liststring_prs_order_detail}       needdel,       ${EMPTY}      count=1
    #list payload of product promo
    ${liststring_prs_order_detail_promo}     Set Variable      needdel
    Log        ${liststring_prs_order_detail_promo}
    : FOR   ${item_gia_ban_promo}   ${item_id_sp_promo}   ${item_soluong_promo}   ${get_orderdetail_id_promo}      IN ZIP   ${list_giaban_promo}        ${list_id_sp_promo}    ${list_promo_num}    ${get_list_order_detail_id_promo}
    \    ${payload_each_product_promo}        Format string       {{"BasePrice":30000,"IsLotSerialControl":false,"IsRewardPoint":false,"Note":"","Price":{0},"ProductId":{1},"Quantity":{2},"ProductCode":"DV031","Discount":{0},"DiscountRatio":0,"ProductName":"Dập phồng tóc - Loreal","SalePromotionId":{3},"ProductBatchExpireId":null,"CategoryId":794172,"MasterProductId":{1},"Unit":"","Uuid":"","OrderDetailId":{4},"ProductWarranty":[]}}   ${item_gia_ban_promo}   ${item_id_sp_promo}   ${item_soluong_promo}    ${get_id_sale_promo}    ${get_orderdetail_id_promo}
    \    ${liststring_prs_order_detail_promo}       Catenate      SEPARATOR=,      ${liststring_prs_order_detail_promo}      ${payload_each_product_promo}
    ${liststring_prs_order_detail_promo}       Replace String      ${liststring_prs_order_detail_promo}       needdel,       ${EMPTY}      count=1
    ${get_id_sp_promo}    Get From List    ${list_id_sp_promo}    0
    ${list_id_sp_promo}   Convert list to string and return     ${list_id_sp_promo}
    #post request
    ${request_payload}    Format String    {{"Invoice":{{"BranchId":{0},"RetailerId":{1},"OrderId":{2},"UpdateInvoiceId":0,"UpdateReturnId":0,"CustomerId":{3},"SoldById":{4},"SoldBy":{{"CreatedBy":0,"CreatedDate":"2018-07-30T08:27:36.800Z","GivenName":"anh.lv","Id":{4},"IsActive":true,"IsAdmin":true,"Type":0,"isDeleted":false,"Name":"anh.lv"}},"SaleChannelId":0,"Seller":{{"CreatedBy":0,"CreatedDate":"2018-07-30T08:27:36.800Z","GivenName":"anh.lv","Id":{4},"IsActive":true,"IsAdmin":true,"Type":0,"isDeleted":false,"Name":"anh.lv"}},"PriceBookId":0,"OrderCode":"{5}","Code":"Hóa đơn 2","Discount":{6},"InvoiceDetails":[{7},{8}],"InvoiceOrderSurcharges":[],"InvoicePromotions":[{{"ProductId":{9},"ProductIds":"{10}","ProductQty":3,"PromotionId":{11},"PromotionInfo":"Khuyến mại hóa đơn tặng hàng: Tổng tiền hàng từ 1,000,000 tặng 1 DV031 - Dập phồng tóc - Loreal, 1 DV032 - Nhuộm tóc - Loreal, 1 DV033 - Hấp phục hồi Loreal cho hóa đơn","SalePromotionId":{12},"TargetType":0,"Type":2,"PrintPromotionInfo":"Tổng tiền hàng từ 1,000,000 tặng 1 Dập phồng tóc - Loreal, 1 Nhuộm tóc - Loreal, 1 Hấp phục hồi Loreal cho hóa đơn","DisplayPrice":30000}}],"Payments":[{{"Method":"Cash","MethodStr":"Tiền mặt","Amount":{13},"Id":-1}}],"Status":1,"Total":1100000,"Surcharge":0,"Type":1,"Uuid":"","addToAccount":"0","PayingAmount":250000,"OrderPaidAmount":0,"TotalBeforeDiscount":1066000,"ProductDiscount":-84000,"PaidAmount":0,"DebugUuid":"15667215772699","InvoiceWarranties":[],"CreatedBy":201567}}}}    ${BRANCH_ID}    ${get_id_nguoitao}    ${get_order_id}    ${get_id_kh}    ${get_id_nguoiban}
    ...     ${order_code}    ${input_gghd}    ${liststring_prs_order_detail}    ${liststring_prs_order_detail_promo}
    ...    ${get_id_sp_promo}    ${list_id_sp_promo}     ${get_id_promotion}   ${get_id_sale_promo}    ${actual_khachtt}
    Log    ${request_payload}
    ${invoice_code}    Post request to create invoice and get invoice code    ${request_payload}
    #get values
    Sleep    20 s    wait for response to API
    #assert value invoice
    ${get_ma_kh_by_hd}    ${get_tong_tien_hang}    ${get_khachtt_af_execute}    ${get_gghd_af_execute}    ${get_khachcantra}    ${get_trangthai}    ${get_ghichu_in_hd_af_execute}
    ...    Get invoice info have note incase discount by invoice code    ${invoice_code}
    Should Be Equal As Numbers    ${get_tong_tien_hang}    ${result_tongtienhang}
    Should Be Equal As Numbers    ${get_khachcantra}    ${result_khachcantra}
    Should Be Equal As Numbers    ${get_khachtt_af_execute}    ${result_khachdatra}
    Should Be Equal As Strings    ${get_ma_kh_by_hd}    ${input_ma_kh}
    Should Be Equal As Numbers    ${get_gghd_af_execute}    ${input_gghd}
    Should Be Equal As Strings    ${get_trangthai}    Hoàn thành
    #assert value order
    ${get_ma_kh_in_dh_af_execute}    ${get_TTDH_in_dh_af_execute}    ${get_tongtienhang_in_dh_af_exxecute}    ${get_khachdatra_in_dh_af_execute}    ${get_giamgia_in_dh_af_execute}    ${get_tongcong_in_dh_af_execute}    ${get_ghichu_in_dh_af_execute}
    ...    Get order info have note incase discount by order code    ${order_code}
    Should Be Equal As Strings    ${get_ma_kh_in_dh_af_execute}    ${input_ma_kh}
    Should Be Equal As Numbers    ${get_TTDH_in_dh_af_execute}    3    #trạng thái hoàn thành
    Should Be Equal As Numbers    ${get_tongtienhang_in_dh_af_exxecute}    ${get_tongtienhang_in_dh_bf_execute}
    Should Be Equal As Numbers    ${get_khachdatra_in_dh_af_execute}    ${result_khachdatra}
    Should Be Equal As Numbers    ${get_giamgia_in_dh_af_execute}    ${get_ggdh_in_dh_bf_execute}
    Should Be Equal As Numbers    ${get_tongcong_in_dh_af_execute}    ${get_tongcong_in_dh_bf_execute}
    Validate invoice history frm Order    ${order_code}    ${invoice_code}    ${result_khachcantra}
    #assert value product
    ${list_order_summary_af_execute}    Get list order summary by order code    ${order_code}
    : FOR    ${result_tong_dh}    ${order_summary_af_execute}    IN ZIP    ${list_result_order_summary}    ${list_order_summary_af_execute}
    \    Should Be Equal As Numbers    ${order_summary_af_execute}    ${result_tong_dh}
    Delete invoice by invoice code    ${invoice_code}
    Delete order frm Order code    ${order_code}
    Toggle status of promotion    ${input_khuyemmai}    0

edxkm3_api
    [Arguments]    ${dict_product_num}    ${input_gghd}    ${input_ma_kh}    ${input_bh_khachtt}    ${input_khuyemmai}    ${dict_promo_product}
    ...   ${input_khtt_create_order}
    [Timeout]
    ## Get info ton cuoi, cong no khach hang
    Toggle status of promotion    ${input_khuyemmai}    1
    ${order_code}     Add new order with order - offering discount pricing promotion    ${input_ma_kh}    ${dict_product_num}    ${input_khuyemmai}    ${dict_promo_product}   ${input_khtt_create_order}
    ${invoice_value}    ${received_value}    ${discount}    ${discount_ratio}    ${name}    Get Invoice value - Received value - Discounts - Promotion Name from Promotion Code    ${input_khuyemmai}
    ${list_product}    Get Dictionary Keys    ${dict_product_num}
    ${list_nums}    Get Dictionary Values    ${dict_product_num}
    ${list_promo_product}    Get Dictionary Keys    ${dict_promo_product}
    ${list_promo_num}    Get Dictionary Values    ${dict_promo_product}
    Create list imei and other product    ${list_product}    ${list_nums}
    ${get_ma_dh_in_dh_bf_execute}    ${get_khachdatra_in_dh_bf_execute}    ${get_ggdh_in_dh_bf_execute}    ${get_tongtienhang_in_dh_bf_execute}    ${get_tongcong_in_dh_bf_execute}    Get order code - paid - discount value frm API    ${input_ma_kh}
    ${get_list_hh_in_dh_bf_execute}    ${get_ghichu_bf_execute}    Get ghi chu and list product frm API    ${order_code}
    ${get_list_nums}   ${get_list_ordersummary_bf_execute}    Get list quantity - order summary frm API    ${order_code}    ${get_list_hh_in_dh_bf_execute}
    ${list_result_order_summary}    Get list order summary after create invoice    ${get_list_ordersummary_bf_execute}    ${get_list_nums}
    #order summary
    ${result_ggdh}    Convert % discount to VND and round    ${get_tongtienhang_in_dh_bf_execute}    ${input_gghd}
    ${result_khachcantra}    Minus and replace floating point     ${get_tongtienhang_in_dh_bf_execute}    ${result_ggdh}
    ${actual_khachtt}    Set Variable If    '${input_bh_khachtt}' == 'all'    ${result_khachcantra}    ${input_bh_khachtt}
    ${result_khachdatra_in_dh}    Sum    ${result_khachcantra}    ${get_khachdatra_in_dh_bf_execute}
    #create invoice
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${jsonpath_id_kh}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_kh}
    ${get_id_kh}    Get data from API    ${endpoint_khachhang}    ${jsonpath_id_kh}
    ${endpoint_danhmuc_hh_co_dvt}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${get_resp_danhmuc_hh}    Get Request and return body    ${endpoint_danhmuc_hh_co_dvt}
    ${get_id_sale_promo}    ${get_id_promotion}    ${get_promo_discount}    Get promotion info    ${input_khuyemmai}
    ${get_order_id}   ${get_payment_id}   Get order - payment frm order api    ${order_code}
    ${get_list_order_detail_id}   Get list orderdetail id frm order api    ${order_code}    ${list_product}
    ${get_list_order_detail_id_promo}   Get list orderdetail id frm order api    ${order_code}    ${list_promo_product}
    #get list gia ban, id san pham, discount of product
    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}    Get list jsonpath product frm list product    ${list_product}
    ${list_giaban}    ${list_id_sp}    Get product info frm list jsonpath product    ${get_resp_danhmuc_hh}    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}
    ${list_jsonpath_id_sp_promo}    ${list_jsonpath_giaban_promo}    Get list jsonpath product frm list product    ${list_promo_product}
    ${list_giaban_promo}    ${list_id_sp_promo}    Get product info frm list jsonpath product    ${get_resp_danhmuc_hh}    ${list_jsonpath_id_sp_promo}    ${list_jsonpath_giaban_promo}
    #list payload of product
    ${liststring_prs_order_detail}     Set Variable      needdel
    Log        ${liststring_prs_order_detail}
    : FOR   ${item_gia_ban}   ${item_id_sp}   ${item_soluong}    ${get_orderdetail_id}    ${item_imei}      IN ZIP   ${list_giaban}        ${list_id_sp}    ${list_nums}   ${get_list_order_detail_id}    ${imei_inlist}
    \    ${item_imei}    Convert list to string and return    ${item_imei}
    \    ${payload_each_product}        Format string       {{"BasePrice":44000.53,"IsLotSerialControl":false,"IsRewardPoint":false,"Note":"","Price":{0},"ProductId":{1},"Quantity":{2},"ProductCode":"DV068","SerialNumbers":"{3}","Discount":0,"DiscountRatio":0,"ProductName":"Nails 20","IsMaster":true,"ProductBatchExpireId":null,"CategoryId":794172,"MasterProductId":{1},"Unit":"","Uuid":"","OrderDetailId":{4},"ProductWarranty":[]}}   ${item_gia_ban}   ${item_id_sp}   ${item_soluong}    ${item_imei}    ${get_orderdetail_id}
    \    ${liststring_prs_order_detail}       Catenate      SEPARATOR=,      ${liststring_prs_order_detail}      ${payload_each_product}
    ${liststring_prs_order_detail}       Replace String      ${liststring_prs_order_detail}       needdel,       ${EMPTY}      count=1
    #list payload of product promo
    ${liststring_prs_order_detail_promo}     Set Variable      needdel
    Log        ${liststring_prs_order_detail_promo}
    : FOR   ${item_gia_ban_promo}   ${item_id_sp_promo}   ${item_soluong_promo}   ${get_orderdetail_id_promo}      IN ZIP   ${list_giaban_promo}        ${list_id_sp_promo}    ${list_promo_num}    ${get_list_order_detail_id_promo}
    \    ${result_promo}    Convert % discount to VND and round    ${item_gia_ban_promo}    ${get_promo_discount}
    \    ${payload_each_product_promo}        Format string       {{"BasePrice":30000,"IsLotSerialControl":false,"IsRewardPoint":false,"Note":"","Price":{0},"ProductId":{1},"Quantity":{2},"ProductCode":"DV031","Discount":{3},"DiscountRatio":{4},"ProductName":"Dập phồng tóc - Loreal","SalePromotionId":338154,"ProductBatchExpireId":null,"CategoryId":794172,"MasterProductId":{1},"Unit":"","Uuid":"","OrderDetailId":{5},"ProductWarranty":[]}}   ${item_gia_ban_promo}   ${item_id_sp_promo}   ${item_soluong_promo}    ${result_promo}   ${get_promo_discount}    ${get_orderdetail_id_promo}
    \    ${liststring_prs_order_detail_promo}       Catenate      SEPARATOR=,      ${liststring_prs_order_detail_promo}      ${payload_each_product_promo}
    ${liststring_prs_order_detail_promo}       Replace String      ${liststring_prs_order_detail_promo}       needdel,       ${EMPTY}      count=1
    ${get_id_sp_promo}    Get From List    ${list_id_sp_promo}    0
    #post request
    ${request_payload}    Format String    {{"Invoice":{{"BranchId":{0},"RetailerId":{1},"OrderId":{2},"UpdateInvoiceId":0,"UpdateReturnId":0,"CustomerId":{3},"SoldById":{4},"SoldBy":{{"CreatedBy":0,"CreatedDate":"2018-07-30T08:27:36.800Z","GivenName":"anh.lv","Id":{4},"IsActive":true,"IsAdmin":true,"Type":0,"isDeleted":false,"Name":"anh.lv"}},"SaleChannelId":0,"Seller":{{"CreatedBy":0,"CreatedDate":"2018-07-30T08:27:36.800Z","GivenName":"anh.lv","Id":{4},"IsActive":true,"IsAdmin":true,"Type":0,"isDeleted":false,"Name":"anh.lv"}},"PriceBookId":0,"OrderCode":"{5}","Code":"Hóa đơn 2","Discount":{6},"DiscountRatio":{7},"InvoiceDetails":[{8},{9}],"InvoiceOrderSurcharges":[],"InvoicePromotions":[{{"ProductId":{10},"ProductIds":"{10}","ProductQty":2,"PromotionId":{11},"PromotionInfo":"Khuyến mại hóa đơn giảm giá SP %: Tổng tiền hàng từ 3,000,000 giảm giá 10% cho 2 DV031 - Dập phồng tóc - Loreal","SalePromotionId":{12},"TargetType":0,"Type":3,"PrintPromotionInfo":"Tổng tiền hàng từ 3,000,000 giảm giá 10% cho 2 Dập phồng tóc - Loreal","DisplayPrice":30000}}],"Payments":[{{"Method":"Cash","MethodStr":"Tiền mặt","Amount":{13},"Id":-1}}],"Status":1,"Total":2829653,"Surcharge":0,"Type":1,"Uuid":"W156672424851036","addToAccount":"0","PayingAmount":2729653,"OrderPaidAmount":100000,"DepositReturn":0,"TotalBeforeDiscount":3335004,"ProductDiscount":6000,"PaidAmount":100000,"DebugUuid":"156672424839584","InvoiceWarranties":[],"CreatedBy":201567}}}}    ${BRANCH_ID}    ${get_id_nguoitao}    ${get_order_id}    ${get_id_kh}    ${get_id_nguoiban}
    ...     ${order_code}    ${result_ggdh}    ${input_gghd}    ${liststring_prs_order_detail}    ${liststring_prs_order_detail_promo}
    ...    ${get_id_sp_promo}    ${get_id_promotion}   ${get_id_sale_promo}    ${actual_khachtt}
    Log    ${request_payload}
    ${invoice_code}    Post request to create invoice and get invoice code    ${request_payload}
    #get values
    Sleep    20 s    wait for response to API
    #assert value invoice
    ${get_ma_kh_by_hd}    ${get_tong_tien_hang}    ${get_khachtt_af_execute}    ${get_gghd_af_execute}    ${get_khachcantra}    ${get_trangthai}    ${get_ghichu_in_hd_af_execute}
    ...    Get invoice info have note incase discount by invoice code    ${invoice_code}
    Should Be Equal As Numbers    ${get_tong_tien_hang}    ${get_tongtienhang_in_dh_bf_execute}
    Should Be Equal As Numbers    ${get_khachcantra}    ${actual_khachtt}
    Should Be Equal As Numbers    ${get_khachtt_af_execute}    ${actual_khachtt}
    Should Be Equal As Strings    ${get_ma_kh_by_hd}    ${input_ma_kh}
    Should Be Equal As Numbers    ${get_gghd_af_execute}    ${result_ggdh}
    Should Be Equal As Strings    ${get_trangthai}    Hoàn thành
    #assert value order
    ${get_ma_kh_in_dh_af_execute}    ${get_TTDH_in_dh_af_execute}    ${get_tongtienhang_in_dh_af_exxecute}    ${get_khachdatra_in_dh_af_execute}    ${get_giamgia_in_dh_af_execute}    ${get_tongcong_in_dh_af_execute}    ${get_ghichu_in_dh_af_execute}
    ...    Get order info have note incase discount by order code    ${order_code}
    Should Be Equal As Strings    ${get_ma_kh_in_dh_af_execute}    ${input_ma_kh}
    Should Be Equal As Numbers    ${get_TTDH_in_dh_af_execute}    3    #trạng thái hoàn thành
    Should Be Equal As Numbers    ${get_tongtienhang_in_dh_af_exxecute}    ${get_tongtienhang_in_dh_bf_execute}
    Should Be Equal As Numbers    ${get_khachdatra_in_dh_af_execute}    ${result_khachdatra_in_dh}
    Should Be Equal As Numbers    ${get_giamgia_in_dh_af_execute}    ${get_ggdh_in_dh_bf_execute}
    Should Be Equal As Numbers    ${get_tongcong_in_dh_af_execute}    ${get_tongcong_in_dh_bf_execute}
    Validate invoice history frm Order    ${order_code}    ${invoice_code}    ${actual_khachtt}
    #assert value product
    ${list_order_summary_af_execute}    Get list order summary by order code    ${order_code}
    : FOR    ${result_tong_dh}    ${order_summary_af_execute}    IN ZIP    ${list_result_order_summary}    ${list_order_summary_af_execute}
    \    Should Be Equal As Numbers    ${order_summary_af_execute}    ${result_tong_dh}
    Delete invoice by invoice code    ${invoice_code}
    Delete order frm Order code    ${order_code}
    Toggle status of promotion    ${input_khuyemmai}    0
