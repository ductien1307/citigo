*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    ${headless_browser}
Resource          ../../../../core/API/api_thietlap.robot
Resource          ../../../../core/API/api_dathang.robot
Resource          ../../../../core/Ban_Hang/banhang_getandcompute.robot
Resource          ../../../../core/share/toast_message.robot
Resource          ../../../../core/API/api_mhbh_dathang.robot
Resource          ../../../../core/API/api_soquy.robot
Resource          ../../../../core/API/api_danhmuc_hanghoa.robot
Resource          ../../../../config/env_product/envi.robot

*** Variables ***
&{list_product_nums1}    HKM004=4
&{list_product_nums2}    DVT37=7
&{list_product_nums3}    DVT38=3    HKM008=3.5
&{list_give1}    HKM006=1
&{list_give2}    HKM007=1
&{list_product_del}    HKM008=3.5
@{list_discount}    10
@{list_nodiscount}    0
@{list_giamoi}    800000

*** Test Cases ***    List product nums        GGHD          Mã KH      Khách TT    Mã khuyến mãi     Khuyến mãi add thêm
Khuyen mai gop
                      [Tags]                   AEDKMG
                      [Template]               edg1_api
                      ${list_product_nums1}    15            CTKH041       all                KM11            KM013

KM HH va HD hinh thuc tang hang - 1TK
                      [Tags]                   AEDKMG
                      [Template]               edg2_api
                      ${list_product_nums2}    0           CTKH042       0      KM015      ${list_give1}     ${list_giamoi}      200000    TK004

KM HH va HD hinh thuc giam gia hang - 2TK
                      [Tags]                   AEDKMG
                      [Template]               edg3_api
                      ${list_product_nums3}    0               CTKH043       20000      KM016      ${list_give2}        ${list_discount}      all     ${list_product_del}     TK008       TK003

*** Keywords ***
edg1_api
    [Arguments]    ${dict_product_num}    ${input_ggdh}    ${input_ma_kh}    ${input_khtt}    ${input_khuyenmai}    ${input_khuyenmai_add}
    ## Get info ton cuoi, cong no khach hang
    Turn on allow use promotion combine in shop config
    Toggle status of promotion    ${input_khuyenmai_add}    1
    Toggle status of promotion    ${input_khuyenmai}    1
    ${list_product}    Get Dictionary Keys    ${dict_product_num}
    ${list_nums}    Get Dictionary Values    ${dict_product_num}
    ${num_sale_product}    ${num_promo_product}    ${product_price}    ${discount}    ${discount_ratio}    ${name}    Get Number of sale product - promo product - promo value and name
    ...    ${input_khuyenmai}
    ${invoice_value}    ${discount_add}    ${discount_ratio_add}    ${name_add}    Get Invoice value - Discounts - Promotion Name from Promotion Code    ${input_khuyenmai_add}
    ${get_no_bf_execute}    ${get_tongban_bf_execute}    ${get_tongban_tru_trahang_bf_execute}    ${get_customer_name}    Get Customer Info from API    ${input_ma_kh}
    ##get value promo
    ${total_sale_number}    Sum values in list    ${list_nums}
    ${list_result_totalsale}    ${list_result_onhand_af_ex}    Run Keyword If    ${discount} != 0 and ${discount_ratio} ==0    Get list of total sale - result onhand in case discount product    ${list_product}    ${list_nums}
    ...    ${discount}
    ...    ELSE IF    ${discount} == 0 and ${discount_ratio} != 0    Get list of total sale - result onhand in case discount product    ${list_product}    ${list_nums}    ${discount_ratio}
    ...    ELSE IF    ${total_sale_number} < ${num_sale_product}    Get list of total sale - result onhand with one discount    ${list_product}    ${list_nums}
    ...    ELSE    Get list of total sale - result onhand in case promotion    ${list_product}    ${list_nums}    ${product_price}    ${num_sale_product}
    ${list_result_order_summary}    Get list result order summary frm product API    ${list_product}    ${list_nums}
    #compute
    ${result_tongtienhang}    Sum values in list    ${list_result_totalsale}
    ${result_discount_invoice_by_vnd}   Convert % discount to VND and round    ${result_tongtienhang}    ${input_ggdh}
    ${result_discount_ratio_by_invoice_promo}    Convert % discount to VND and round    ${result_tongtienhang}    ${discount_ratio_add}
    ${actual_promo_value}    Set Variable If    ${discount_add} == 0    ${result_discount_ratio_by_invoice_promo}    ${discount_add}
    ${final_discount}=    Run Keyword If    ${result_tongtienhang} > ${invoice_value}    Sum    ${actual_promo_value}    ${result_discount_invoice_by_vnd}
    ...    ELSE    Set Variable    ${result_discount_invoice_by_vnd}
    ${result_khachcantra}    Minus and replace floating point    ${result_tongtienhang}    ${final_discount}
    ${actual_khachtt}    Set Variable If    '${input_khtt}' == 'all'    ${result_khachcantra}    ${input_khtt}
    ${result_no_hoadon}    Minus    ${result_khachcantra}    ${actual_khachtt}
    ${result_nohientai}    sum    ${result_no_hoadon}    ${get_no_bf_execute}
    ${result_tongban}    Sum    ${result_khachcantra}    ${get_tongban_bf_execute}
    ##create order
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${get_id_sale_promo}    ${get_id_promotion}    ${get_promo_discount}    Get promotion info    ${input_khuyenmai}
    ${get_id_sale_promo_add}    ${get_id_promotion_add}    ${get_promo_discount_add}    Get promotion info    ${input_khuyenmai_add}
    ${jsonpath_id_kh}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_kh}
    ${get_id_kh}    Get data from API    ${endpoint_khachhang}    ${jsonpath_id_kh}
    ${endpoint_danhmuc_hh_co_dvt}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${get_resp_danhmuc_hh}    Get Request and return body    ${endpoint_danhmuc_hh_co_dvt}
    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}    Get list jsonpath product frm list product    ${list_product}
    ${list_giaban}    ${list_id_sp}    Get product info frm list jsonpath product    ${get_resp_danhmuc_hh}    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}
    #post request
    ${liststring_prs_order_detail}     Set Variable      needdel
    Log        ${liststring_prs_order_detail}
    : FOR    ${item_gia_ban}   ${item_id_sp}   ${item_soluong}      IN ZIP       ${list_giaban}        ${list_id_sp}    ${list_nums}
    \    ${discount_ratio}   Set Variable If    0 < ${discount_ratio} < 100    ${discount_ratio}   0
    \    ${result_ggsp}   Convert % discount to VND    ${item_gia_ban}    ${discount_ratio}
    \    ${payload_each_product}        Format string       {{"BasePrice":{0},"Discount":{1},"DiscountRatio":{2},"IsLotSerialControl":false,"IsRewardPoint":false,"Note":"","Price":{0},"ProductCode":"HKM004","ProductId":{3},"ProductName":"Hàng khuyến mại 2","PromotionParentProductId":{3},"PromotionParentType":1,"Quantity":{4},"SalePromotionId":{5},"Uuid":"","OriginPrice":{0},"ProductBatchExpireId":null}}   ${item_gia_ban}   ${result_ggsp}   ${discount_ratio}
    \    ...   ${item_id_sp}   ${item_soluong}    ${get_id_sale_promo}
    \    ${liststring_prs_order_detail}       Catenate      SEPARATOR=,      ${liststring_prs_order_detail}      ${payload_each_product}
    ${liststring_prs_order_detail}       Replace String      ${liststring_prs_order_detail}       needdel,       ${EMPTY}      count=1
    ${request_payload}    Format String    {{"Order":{{"BranchId":{0},"RetailerId":{1},"CustomerId":{2},"SoldById":{3},"SoldBy":{{"CreatedBy":0,"CreatedDate":"2018-12-10T10:42:37.447Z","Email":"","GivenName":"admin","Id":{3},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false}},"SaleChannelId":0,"SaleChannel":null,"Seller":{{"CreatedBy":0,"CreatedDate":"2018-12-10T10:42:37.447Z","Email":"","GivenName":"admin","Id":{3},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false}},"Code":"Đặt hàng 1","Discount":{4},"OrderDetails":[{5}],"InvoiceOrderSurcharges":[],"OrderPromotions":[{{"Type":8,"TargetType":1,"SalePromotionId":{6},"PromotionId":{7},"ProductId":{8},"ProductPrice":{9},"ProductQty":4,"RelatedProductId":{8},"PromotionInfo":"KM theo HH hình thức giá bán theo SL mua GG %: Khi mua 4 HKM004 - Hàng khuyến mại 2 giảm giá 20%","PrintPromotionInfo":"Mua từ 4 Hàng khuyến mại 2 được giảm giá 20.00% mỗi sản phẩm","RelatedProductIds":"{8}","RelatedCategoryIds":"","PromotionApplicationType":"%"}},{{"Type":15,"TargetType":2,"SalePromotionId":{10},"PromotionId":{11},"DiscountRatio":{12},"PromotionInfo":"KM theo HH và HĐ hình thức GG HĐ %: Tổng tiền hàng từ 4,000,000 và mua 4 HKM004 - Hàng khuyến mại 2 giảm giá 5% cho hóa đơn","PrintPromotionInfo":"KM theo HH và HĐ hình thức GG HĐ %: Tổng tiền hàng từ 4,000,000 và mua 4 HKM004 - Hàng khuyến mại 2 giảm giá 5% cho hóa đơn"}}],"Payments":[{{"Method":"Cash","MethodStr":"Tiền mặt","Amount":{13},"Id":-1}}],"UsingCod":0,"Status":1,"Total":4712001,"Extra":"{{\\"Amount\\":100000,\\"Method\\":{{\\"Id\\":\\"Cash\\",\\"Label\\":\\"Tiền mặt\\"}},\\"ResetPromotion\\":false}}","Surcharge":0,"Type":2,"Uuid":"","addToAccount":"0","PayingAmount":100000,"TotalBeforeDiscount":6200002,"ProductDiscount":1240000,"CreatedBy":196750,"InvoiceWarranties":[],"DiscountByPromotion":248000,"DiscountByPromotionValue":0,"DiscountByPromotionRatio":5}}}}    ${BRANCH_ID}    ${get_id_nguoitao}    ${get_id_kh}    ${get_id_nguoiban}   ${final_discount}    ${liststring_prs_order_detail}    ${get_id_sale_promo}
    ...    ${get_id_promotion}   ${item_id_sp}    ${get_promo_discount}    ${get_id_sale_promo_add}   ${get_id_promotion_add}    ${get_promo_discount_add}    ${actual_khachtt}
    Log    ${request_payload}
    ${order_code}    Post request to create order and return code    ${request_payload}
    #assert value product
    ${list_order_summary_af_execute}    Get list order summary frm product API    ${list_product}
    : FOR    ${result_tong_dh}    ${order_summary_af_execute}    IN ZIP    ${list_result_order_summary}    ${list_order_summary_af_execute}
    \    Should Be Equal As Numbers    ${order_summary_af_execute}    ${result_tong_dh}
    #assert values in order
    ${get_ma_kh_in_dh_af_execute}    ${get_TTDH_in_dh_af_execute}    ${get_tongtienhang_in_dh_af_exxecute}    ${get_khachdatra_in_dh_af_execute}    ${get_giamgia_in_dh_af_execute}    ${get_tongcong_in_dh_af_execute}    ${get_ghichu_in_dh_af_execute}
    ...    Get order info incase discount by order code    ${order_code}
    Should Be Equal As Strings    ${get_ma_kh_in_dh_af_execute}    ${get_ma_kh_in_dh_af_execute}
    Should Be Equal As Numbers    ${get_TTDH_in_dh_af_execute}    1    #1 : phiếu tạm
    Should Be Equal As Numbers    ${get_tongtienhang_in_dh_af_exxecute}    ${result_tongtienhang}
    Should Be Equal As Numbers    ${get_khachdatra_in_dh_af_execute}    ${actual_khachtt}
    Should Be Equal As Numbers    ${get_giamgia_in_dh_af_execute}    ${final_discount}
    Should Be Equal As Numbers    ${get_tongcong_in_dh_af_execute}    ${result_khachcantra}
    Delete order frm Order code    ${order_code}
    Toggle status of promotion    ${input_khuyenmai}    0
    Toggle status of promotion    ${input_khuyenmai_add}    0
    Turn off allow use promotion combine in shop config

edg2_api
    [Arguments]    ${dict_product_nums}    ${input_gghd}    ${input_ma_kh}    ${input_bh_khachtt}    ${input_khuyenmai}    ${list_giveaway}
    ...    ${list_newprice}   ${input_khach_tt_to_create}   ${input_ma_thukhac}
    [Timeout]
    ## Get info ton cuoi, cong no khach hang
    ${surcharge_vnd_value}    Get surcharge vnd value    ${input_ma_thukhac}
    ${surcharge_%}    Get surcharge percentage value    ${input_ma_thukhac}
    Run Keyword If    ${surcharge_%} == 0    Toggle surcharge VND    ${input_ma_thukhac}    true
    ...    ELSE    Toggle surcharge percentage    ${input_ma_thukhac}    true
    Toggle status of promotion    ${input_khuyenmai}    1
    ${order_code}     Add new order with multi products    ${input_ma_kh}    ${dict_product_nums}    ${input_khach_tt_to_create}
    ${invoice_value}    ${received_value}    ${discount}    ${discount_ratio}    ${name}    Get Invoice value - Received value - Discounts - Promotion Name from Promotion Code    ${input_khuyenmai}
    #compute product
    ${list_product}    Get Dictionary Keys    ${dict_product_nums}
    ${list_nums}    Get Dictionary Values    ${dict_product_nums}
    ${list_product_promo}    Get Dictionary Keys    ${list_giveaway}
    ${list_nums_promo}    Get Dictionary Values    ${list_giveaway}
    ${get_ma_dh_in_dh_bf_execute}    ${get_khachdatra_in_dh_bf_execute}    ${get_ggdh_in_dh_bf_execute}    ${get_tongtienhang_in_dh_bf_execute}    ${get_tongcong_in_dh_bf_execute}    Get order code - paid - discount value frm API    ${input_ma_kh}
    ${get_list_hh_in_dh_bf_execute}    ${get_ghichu_bf_execute}    Get ghi chu and list product frm API    ${order_code}
    ${get_list_nums}   ${get_list_ordersummary_bf_execute}    Get list quantity - order summary frm API    ${order_code}    ${get_list_hh_in_dh_bf_execute}
    ${list_result_tongdh}    ${result_list_toncuoi}    ${result_list_thanhtien}    Get list order summary - total sale - ending stocks incase newprice    ${order_code}    ${get_list_hh_in_dh_bf_execute}    ${list_newprice}
    #compute product promo
    ${get_list_baseprice}   Get list of Baseprice by Product Code    ${list_product_promo}
    ${get_list_onhand}   Get list of Onhand by Product Code    ${list_product_promo}
    ${result_thanhtien_promo}   Create List
    ${list_result_toncuoi_promo}   Create List
    :FOR    ${item_giaban}    ${item_nums}   ${item_onhand}   IN ZIP    ${get_list_baseprice}    ${list_nums_promo}    ${get_list_onhand}
    \     ${giaban}   Minus     ${item_giaban}    ${discount}
    \     ${thanhtien}    Multiplication and round     ${giaban}    ${item_nums}
    \     ${result_tonkho}    Minus   ${item_onhand}    ${item_nums}
    \     Append To List     ${result_thanhtien_promo}     ${thanhtien}
    \     Append To List     ${list_result_toncuoi_promo}     ${result_tonkho}
    #compute
    ${result_tongtienhang}    Sum values in list    ${result_list_thanhtien}
    ${result_tongtienhang_promo}    Sum values in list    ${result_thanhtien_promo}
    ${result_tongtienhang}    Sum    ${result_tongtienhang}    ${result_tongtienhang_promo}
    ${result_tongtienhang_tru_gghd}    Minus and replace floating point    ${result_tongtienhang}    ${input_gghd}
    ${actual_surcharge_type}    Set Variable If    ${surcharge_%} == 0    ${surcharge_vnd_value}    ${surcharge_%}
    ${result_per_surchare_by_invoice}    Convert % discount to VND and round    ${result_tongtienhang_tru_gghd}    ${surcharge_%}
    ${actual_surcharge_value}    Set Variable If    ${surcharge_%} == 0    ${surcharge_vnd_value}    ${result_per_surchare_by_invoice}
    ${result_tongtienhang_tovalidate}    Sum    ${result_tongtienhang}    ${actual_surcharge_value}
    ${result_khachcantra}    Sum and replace floating point    ${result_tongtienhang_tru_gghd}    ${actual_surcharge_value}
    ${result_khachcantra}    Minus and replace floating point    ${result_khachcantra}    ${get_khachdatra_in_dh_bf_execute}
    ${actual_khachtt}    Set Variable If    '${input_bh_khachtt}' == 'all'    ${result_khachcantra}    ${input_bh_khachtt}
    ${result_khachdatra}      Sum     ${get_khachdatra_in_dh_bf_execute}    ${actual_khachtt}
    #create order
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${jsonpath_id_kh}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_kh}
    ${get_id_kh}    Get data from API    ${endpoint_khachhang}    ${jsonpath_id_kh}
    ${endpoint_danhmuc_hh_co_dvt}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${get_resp_danhmuc_hh}    Get Request and return body    ${endpoint_danhmuc_hh_co_dvt}
    ${get_id_sale_promo}    ${get_id_promotion}    ${get_promo_discount}    Get promotion info    ${input_khuyenmai}
    ${get_order_id}   ${get_payment_id}   Get order - payment frm order api    ${order_code}
    ${get_list_order_detail_id}   Get list orderdetail id frm order api    ${order_code}    ${list_product}
    ${get_list_order_detail_id_promo}   Get list orderdetail id frm order api    ${order_code}    ${list_product_promo}
    ${get_id_thukhac}   ${get_thutu_thukhac}    Get Id and order surchage    ${input_ma_thukhac}
    #get list gia ban, id san pham, discount of product
    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}    Get list jsonpath product frm list product    ${list_product}
    ${list_giaban}    ${list_result_ggsp}    ${list_id_sp}    Get product info and new price frm list product    ${get_resp_danhmuc_hh}    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}   ${list_newprice}
    ${list_jsonpath_id_sp_promo}    ${list_jsonpath_giaban_promo}    Get list jsonpath product frm list product    ${list_product_promo}
    ${list_giaban_promo}    ${list_id_sp_promo}    Get product info frm list jsonpath product    ${get_resp_danhmuc_hh}    ${list_jsonpath_id_sp_promo}    ${list_jsonpath_giaban_promo}
    #list payload of product
    ${liststring_prs_order_detail}     Set Variable      needdel
    Log        ${liststring_prs_order_detail}
    : FOR   ${item_gia_ban}   ${newprice}   ${item_id_sp}   ${item_soluong}   ${get_orderdetail_id}      IN ZIP    ${list_giaban}   ${list_newprice}        ${list_id_sp}    ${list_nums}   ${get_list_order_detail_id}
    \    ${result_ggsp}   Minus    ${item_gia_ban}   ${newprice}
    \    ${payload_each_product}        Format string       {{"BasePrice":{0},"IsLotSerialControl":false,"IsBatchExpireControl":false,"IsRewardPoint":false,"Note":"","Price":{0},"ProductId":{1},"Quantity":{2},"ProductCode":"DVT37","Discount":{3},"DiscountRatio":0,"ProductName":"Đơn vị tính 37 - (chiếc)","SalePromotionId":null,"OriginPrice":{0},"PriceByPromotion":null,"IsMaster":true,"PromotionParentProductId":null,"ProductBatchExpireId":null,"CategoryId":1187274,"MasterProductId":{1},"Unit":"chiếc","Uuid":"","OrderDetailId":{4},"ProductWarranty":[]}}   ${item_gia_ban}   ${item_id_sp}   ${item_soluong}       ${result_ggsp}    ${get_orderdetail_id}
    \    ${liststring_prs_order_detail}       Catenate      SEPARATOR=,      ${liststring_prs_order_detail}      ${payload_each_product}
    ${liststring_prs_order_detail}       Replace String      ${liststring_prs_order_detail}       needdel,       ${EMPTY}      count=1
    #list payload of product promo
    ${liststring_prs_order_detail_promo}     Set Variable      needdel
    Log        ${liststring_prs_order_detail_promo}
    : FOR   ${item_gia_ban_promo}   ${item_id_sp_promo}   ${item_soluong_promo}      IN ZIP   ${list_giaban_promo}        ${list_id_sp_promo}    ${list_nums_promo}
    \    ${payload_each_product_promo}        Format string       {{"BasePrice":{0},"IsLotSerialControl":false,"IsBatchExpireControl":false,"IsRewardPoint":false,"Note":"","Price":{0},"ProductId":{1},"Quantity":{2},"ProductCode":"HKM006","Discount":{3},"ProductName":"Hàng khuyến mại 3","SalePromotionId":{4},"OriginPrice":{0},"ProductBatchExpireId":null,"CategoryId":1187275,"MasterProductId":{1},"Unit":"","Uuid":"","ProductWarranty":[]}}   ${item_gia_ban_promo}   ${item_id_sp_promo}   ${item_soluong_promo}    ${discount}    ${get_id_sale_promo}
    \    ${liststring_prs_order_detail_promo}       Catenate      SEPARATOR=,      ${liststring_prs_order_detail_promo}      ${payload_each_product_promo}
    ${liststring_prs_order_detail_promo}       Replace String      ${liststring_prs_order_detail_promo}       needdel,       ${EMPTY}      count=1
    ${get_id_sp_promo}    Get From List    ${list_id_sp_promo}    0
    ${list_id_sp_promo}   Convert list to string and return     ${list_id_sp_promo}
    #post request
    ${request_payload}    Format String    {{"Invoice":{{"BranchId":{0},"RetailerId":{1},"OrderId":{2},"UpdateInvoiceId":0,"UpdateReturnId":0,"CustomerId":{3},"SoldById":{4},"SoldBy":{{"CreatedBy":0,"CreatedDate":"2018-12-10T08:33:32.447Z","GivenName":"admin","Id":{4},"IsActive":true,"IsAdmin":true,"Type":0,"isDeleted":false,"Name":"admin"}},"SaleChannelId":0,"Seller":{{"CreatedBy":0,"CreatedDate":"2018-12-10T08:33:32.447Z","GivenName":"admin","Id":{4},"IsActive":true,"IsAdmin":true,"Type":0,"isDeleted":false,"Name":"admin"}},"PriceBookId":0,"OrderCode":"{5}","Code":"Hóa đơn 2","Discount":0,"InvoiceDetails":[{6},{7}],"InvoiceOrderSurcharges":[{{"Code":"TK004","Name":"Phí VAT4","Order":{8},"RetailerId":{1},"SurValueRatio":{9},"SurchargeId":{10},"ValueRatio":{9},"isAuto":false,"isReturnAuto":false,"TextValue":"{9}.00 %","Price":{11},"UsageFlag":true}}],"InvoicePromotions":[{{"Type":17,"TargetType":2,"SalePromotionId":{12},"PromotionId":{13},"ProductId":{14},"RelatedProductQty":2,"ProductQty":1,"PromotionInfo":"KM theo HH và HĐ hình thức GG hàng %: Tổng tiền hàng từ 3,000,000 và mua 7 DVT37 - Đơn vị tính 37 - (chiếc) giảm giá 50,000 cho 1 HKM006 - Hàng khuyến mại 3","PrintPromotionInfo":"Tổng tiền hàng từ 3,000,000 và mua 7 DVT37 - Đơn vị tính 37 - (chiếc) giảm giá 50,000 cho 1 Hàng khuyến mại 3","ProductIds":"{14}","BackupSelectedSerials":{{}}}}],"Payments":[],"Status":1,"Total":3937500,"Surcharge":187500,"Type":1,"Uuid":"","addToAccount":"0","PayingAmount":0,"OrderPaidAmount":200000,"DepositReturn":0,"TotalBeforeDiscount":3800000,"ProductDiscount":50000,"PaidAmount":200000,"DebugUuid":"","InvoiceWarranties":[],"CreatedBy":441968}}}}    ${BRANCH_ID}    ${get_id_nguoitao}    ${get_order_id}    ${get_id_kh}    ${get_id_nguoiban}
    ...     ${order_code}    ${liststring_prs_order_detail}    ${liststring_prs_order_detail_promo}   ${get_thutu_thukhac}
    ...    ${actual_surcharge_type}    ${get_id_thukhac}    ${actual_surcharge_value}    ${get_id_sp_promo}    ${list_id_sp_promo}
    ...     ${get_id_promotion}   ${get_id_sale_promo}    ${actual_khachtt}
    Log    ${request_payload}
    ${invoice_code}    Post request to create invoice and get invoice code    ${request_payload}
    #get values
    Sleep    20 s    wait for response to API
    #assert value product in invoice
    ${list_soluong_in_hd}    ${list_giatri_quydoi_in_hd}    Get list quantity and gia tri quy doi by invoice code    ${get_list_hh_in_dh_bf_execute}    ${invoice_code}
    : FOR    ${ma_hh}    ${result_toncuoi}    ${item_soluong}    ${get_giatri_quydoi}    IN ZIP    ${get_list_hh_in_dh_bf_execute}
    ...    ${result_list_toncuoi}    ${list_soluong_in_hd}    ${list_giatri_quydoi_in_hd}
    \    Run Keyword If    '${get_giatri_quydoi}' == '1'    Validate product history frm API    ${invoice_code}    ${ma_hh}    ${result_toncuoi}    ${item_soluong}
    \    ...    ELSE    Validate unit product history frm API    ${invoice_code}    ${ma_hh}    ${result_toncuoi}    ${item_soluong}    ${get_giatri_quydoi}
    #assert value product promo in invoice
    ${list_soluong_in_hd_promo}    ${list_giatri_quydoi_in_hd_promo}    Get list quantity and gia tri quy doi by invoice code    ${list_product_promo}    ${invoice_code}
    : FOR    ${ma_hh_promo}    ${result_toncuoi_promo}    ${item_soluong_promo}    ${get_giatri_quydoi_promo}    IN ZIP    ${list_product_promo}
    ...    ${list_result_toncuoi_promo}    ${list_soluong_in_hd_promo}    ${list_giatri_quydoi_in_hd_promo}
    \    Run Keyword If    '${get_giatri_quydoi}' == '1'    Validate product history frm API    ${invoice_code}    ${ma_hh_promo}    ${result_toncuoi_promo}    ${item_soluong_promo}
    \    ...    ELSE    Validate unit product history frm API    ${invoice_code}    ${ma_hh_promo}    ${result_toncuoi_promo}    ${item_soluong_promo}    ${get_giatri_quydoi_promo}
    #assert value product
    ${list_order_summary_af_execute}    Get list order summary by order code    ${order_code}
    : FOR    ${result_tong_dh}    ${order_summary_af_execute}    IN ZIP    ${list_result_tongdh}    ${list_order_summary_af_execute}
    \    Should Be Equal As Numbers    ${order_summary_af_execute}    ${result_tong_dh}
    #assert value invoice
    ${get_ma_kh_by_hd}    ${get_tong_tien_hang}    ${get_khachtt_af_execute}    ${get_gghd_af_execute}    ${get_khachcantra}    ${get_trangthai}    ${get_ghichu_in_hd_af_execute}
    ...    Get invoice info have note incase discount by invoice code    ${invoice_code}
    Should Be Equal As Numbers    ${get_tong_tien_hang}    ${result_tongtienhang_tovalidate}
    Should Be Equal As Numbers    ${get_khachcantra}    ${result_tongtienhang_tovalidate}
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
    Validate invoice history frm Order    ${order_code}    ${invoice_code}    ${result_tongtienhang_tovalidate}
    Delete invoice by invoice code    ${invoice_code}
    Delete order frm Order code    ${order_code}
    Run Keyword If    ${surcharge_%} == 0    Toggle surcharge VND    ${input_ma_thukhac}    false
    ...   ELSE    Toggle surcharge percentage    ${input_ma_thukhac}    false
    Toggle status of promotion    ${input_khuyenmai}    0

edg3_api
    [Arguments]    ${dict_product_nums_tocreate}  ${input_gghd}    ${input_ma_kh}    ${input_hoantratamung}   ${input_khuyenmai}    ${list_promo_product}
    ...   ${list_ggsp}    ${input_khtt_tocreate}    ${list_product_del}    ${input_thukhac1}    ${input_thukhac2}
    Set Selenium Speed    0.5s
    ${order_code}    Add new order have multi surcharge    ${input_ma_kh}    ${dict_product_nums_tocreate}    ${input_thukhac2}    ${input_thukhac1}    ${input_khtt_tocreate}
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
    Toggle status of promotion    ${input_khuyenmai}    1
    ${invoice_value}    ${received_value}    ${discount}    ${discount_ratio}    ${name}    Get Invoice value - Received value - Discounts - Promotion Name from Promotion Code    ${input_khuyenmai}
    #get info product, customer
    ${list_product_promo}    Get Dictionary Keys    ${list_promo_product}
    ${list_nums_promo}    Get Dictionary Values    ${list_promo_product}
    ${list_produc}    Get Dictionary Keys    ${list_product_del}
    ${list_nums_del}    Get Dictionary Values    ${list_product_del}
    ${get_khachdatra_in_dh_bf_execute}    ${get_tongtienhang_in_dh_bf_execute}    Get paid value frm API    ${order_code}
    ${get_list_hh_in_dh_bf_execute}    ${get_list_nums_in_dh}    Get list product and quantity frm API    ${order_code}
    ${list_result_tongdh_delete}    Get list order summary frm product API    ${list_product_del}
    #get order summary and sub total of products
    : FOR    ${ma_hh}   ${item_nums}    IN ZIP    ${list_product_del}    ${list_nums_del}
    \    Remove Values From List    ${get_list_hh_in_dh_bf_execute}    ${ma_hh}
    \    Remove Values From List    ${get_list_nums_in_dh}    ${item_nums}
    Log    ${get_list_hh_in_dh_bf_execute}
    ${list_result_tongdh}    ${result_list_toncuoi}    ${result_list_thanhtien}    ${list_result_giamoi}    Get list order summary - total sale - ending stocks incase discount    ${order_code}    ${get_list_hh_in_dh_bf_execute}
    ...    ${list_ggsp}
    #compute product promo
    ${get_list_baseprice}   Get list of Baseprice by Product Code    ${list_product_promo}
    ${get_list_product_type}    ${list_tonkho_service}    Get list product type and ending stock of service frm API    ${list_product_promo}
    ${result_thanhtien_promo}   Create List
    ${list_result_toncuoi_promo}   Create List
    :FOR    ${item_giaban}    ${item_nums}   ${item_onhand}   IN ZIP    ${get_list_baseprice}    ${list_nums_promo}    ${list_tonkho_service}
    \     ${giaban}   Price after % discount product     ${item_giaban}    ${discount_ratio}
    \     ${thanhtien}    Multiplication and round     ${giaban}    ${item_nums}
    \     ${result_tonkho}    Minus   ${item_onhand}    ${item_nums}
    \     Append To List     ${result_thanhtien_promo}     ${thanhtien}
    \     Append To List     ${list_result_toncuoi_promo}     ${result_tonkho}
    #compute TTH with product
    ${result_tongtienhang}    Sum values in list    ${result_list_thanhtien}
    ${result_tongtienhang_promo}    Sum values in list    ${result_thanhtien_promo}
    ${result_tongtienhang}    Sum    ${result_tongtienhang}    ${result_tongtienhang_promo}
    ${result_khachdatra}    Minus and replace floating point    ${result_tongtienhang}    ${get_khachdatra_in_dh_bf_execute}
    ${total_surcharge}=    Run Keyword If    ${actual_surcharge1_value} > 100 and ${actual_surcharge2_value} > 100    Sum    ${actual_surcharge1_value}    ${actual_surcharge2_value}
    ...    ELSE IF    ${actual_surcharge1_value} > 100 and ${actual_surcharge2_value} < 100    VND and Percentage Surcharges sum    ${actual_surcharge2_value}    ${result_tongtienhang}    ${actual_surcharge1_value}
    ...    ELSE IF    ${actual_surcharge1_value} < 100 and ${actual_surcharge2_value} < 100    Percentage and Percentage Surcharges sum    ${result_tongtienhang}    ${actual_surcharge1_value}    ${actual_surcharge2_value}
    ...    ELSE    Log    abv
    ${result_tongtienhang_tovalidate}    Sum    ${result_tongtienhang}    ${total_surcharge}
    ${tamung}    Minus and replace floating point    ${get_khachdatra_in_dh_bf_execute}    ${result_tongtienhang}
    ${result_tamung}    Set Variable If    '${input_hoantratamung}' == 'all'    ${tamung}    ${input_hoantratamung}
    ${result_khachdatra_in_dh}    Minus    ${get_khachdatra_in_dh_bf_execute}    ${result_tamung}
    ##thu khac
    ${get_id_thukhac1}   ${get_thutu_thukhac1}    Get Id and order surchage    ${input_thukhac1}
    ${get_id_thukhac2}   ${get_thutu_thukhac2}    Get Id and order surchage    ${input_thukhac2}
    ${jsonpath_id_order}    Format String    $..Data[?(@.Code == '{0}')].Id    ${order_code}
    ${get_id_order }    Get data from API by BranchID    ${BRANCH_ID}    ${endpoint_order}    ${jsonpath_id_order}
    ${endpoint_orderdetail}    Format String    ${endpoint_order_detail}    ${get_id_order }
    ${get_list_id_detail_thukhac}    Get raw data from API by BranchID    ${BRANCH_ID}    ${endpoint_orderdetail}    $.InvoiceOrderSurcharges..Id
    #create invoice from order
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${jsonpath_id_kh}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_kh}
    ${get_id_kh}    Get data from API    ${endpoint_khachhang}    ${jsonpath_id_kh}
    ${endpoint_danhmuc_hh_co_dvt}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${get_resp_danhmuc_hh}    Get Request and return body    ${endpoint_danhmuc_hh_co_dvt}
    ${get_id_sale_promo}    ${get_id_promotion}    ${get_promo_discount}    Get promotion info    ${input_khuyenmai}
    ${get_order_id}   ${get_payment_id}   Get order - payment frm order api    ${order_code}
    ${get_list_order_detail_id}   Get list orderdetail id frm order api    ${order_code}    ${get_list_hh_in_dh_bf_execute}
    ${get_list_order_detail_id_promo}   Get list orderdetail id frm order api    ${order_code}    ${list_product_promo}
    #get list gia ban, id san pham, discount of product
    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}    Get list jsonpath product frm list product    ${get_list_hh_in_dh_bf_execute}
    ${list_giaban}    ${list_result_ggsp}    ${list_id_sp}    Get product info frm list jsonpath product have discount product    ${get_resp_danhmuc_hh}    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}   ${list_ggsp}
    ${list_jsonpath_id_sp_promo}    ${list_jsonpath_giaban_promo}    Get list jsonpath product frm list product    ${list_product_promo}
    ${list_giaban_promo}    ${list_id_sp_promo}    Get product info frm list jsonpath product    ${get_resp_danhmuc_hh}    ${list_jsonpath_id_sp_promo}    ${list_jsonpath_giaban_promo}
    #list payload of product
    ${liststring_prs_order_detail}     Set Variable      needdel
    Log        ${liststring_prs_order_detail}
    : FOR   ${item_gia_ban}   ${item_ggsp}    ${item_result_ggsp}   ${item_id_sp}   ${item_soluong}   ${get_orderdetail_id}      IN ZIP    ${list_giaban}   ${list_ggsp}    ${list_result_ggsp}   ${list_id_sp}    ${get_list_nums_in_dh}   ${get_list_order_detail_id}
    \    ${payload_each_product}        Format string       {{"BasePrice":{0},"IsLotSerialControl":false,"IsRewardPoint":false,"Note":"","Price":{0},"ProductId":{1},"Quantity":{2},"ProductCode":"DVT38","Discount":{3},"DiscountRatio":{4},"ProductName":"Đơn vị tính 38 - (cái)","SalePromotionId":null,"OriginPrice":{0},"PriceByPromotion":null,"IsMaster":true,"PromotionParentProductId":null,"ProductBatchExpireId":null,"CategoryId":1187274,"MasterProductId":{1},"Unit":"cái","Uuid":"","OrderDetailId":{0},"ProductWarranty":[]}}   ${item_gia_ban}   ${item_id_sp}
    \    ...   ${item_soluong}    ${item_result_ggsp}   ${item_ggsp}    ${get_orderdetail_id}
    \    ${liststring_prs_order_detail}       Catenate      SEPARATOR=,      ${liststring_prs_order_detail}      ${payload_each_product}
    ${liststring_prs_order_detail}       Replace String      ${liststring_prs_order_detail}       needdel,       ${EMPTY}      count=1
    #list payload of product promo
    ${liststring_prs_order_detail_promo}     Set Variable      needdel
    Log        ${liststring_prs_order_detail_promo}
    : FOR   ${item_gia_ban_promo}   ${item_id_sp_promo}   ${item_soluong_promo}      IN ZIP   ${list_giaban_promo}        ${list_id_sp_promo}    ${list_nums_promo}
    \    ${result_ggsp}   Convert % discount to vnd   ${item_gia_ban_promo}    ${discount_ratio}
    \    ${payload_each_product_promo}        Format string       {{"BasePrice":{0},"IsLotSerialControl":false,"IsRewardPoint":false,"Note":"","Price":{0},"ProductId":{1},"Quantity":{2},"ProductCode":"HKM007","Discount":{3},"DiscountRatio":{4},"ProductName":"Hàng khuyến mại 5","SalePromotionId":{5},"OriginPrice":{0},"ProductBatchExpireId":null,"CategoryId":1187275,"MasterProductId":{1},"Unit":"","Uuid":"","ProductWarranty":[]}}   ${item_gia_ban_promo}   ${item_id_sp_promo}   ${item_soluong_promo}    ${result_ggsp}    ${discount_ratio}    ${get_id_sale_promo}
    \    ${liststring_prs_order_detail_promo}       Catenate      SEPARATOR=,      ${liststring_prs_order_detail_promo}      ${payload_each_product_promo}
    ${liststring_prs_order_detail_promo}       Replace String      ${liststring_prs_order_detail_promo}       needdel,       ${EMPTY}      count=1
    ${get_id_sp_promo}    Get From List    ${list_id_sp_promo}    0
    ${list_id_sp_promo}   Convert list to string and return     ${list_id_sp_promo}
    ${get_id_detail_thukhac1}    Get From List    ${get_list_id_detail_thukhac}    0
    ${get_id_detail_thukhac2}    Get From List    ${get_list_id_detail_thukhac}    1
    ${actual_value_surcharge1}  Run Keyword If    0 < ${actual_surcharge1_value} < 100   Convert % discount to VND and round    ${result_tongtienhang}    ${actual_surcharge1_value}    ELSE   Set Variable    ${actual_surcharge1_value}
    ${actual_value_surcharge2}  Run Keyword If    0 < ${actual_surcharge2_value} < 100   Convert % discount to VND and round    ${result_tongtienhang}    ${actual_surcharge2_value}    ELSE   Set Variable    ${actual_surcharge2_value}
    ${actual_tamung}    Minus   0    ${result_tamung}
    #post request
    ${request_payload}    Format String    {{"Invoice":{{"BranchId":{0},"RetailerId":{1},"OrderId":{2},"UpdateInvoiceId":0,"UpdateReturnId":0,"CustomerId":{3},"SoldById":{4},"SoldBy":{{"CreatedBy":0,"CreatedDate":"2018-12-10T08:33:32.447Z","GivenName":"admin","Id":{4},"IsActive":true,"IsAdmin":true,"Type":0,"isDeleted":false,"Name":"admin"}},"SaleChannelId":0,"Seller":{{"CreatedBy":0,"CreatedDate":"2018-12-10T08:33:32.447Z","GivenName":"admin","Id":{4},"IsActive":true,"IsAdmin":true,"Type":0,"isDeleted":false,"Name":"admin"}},"PriceBookId":0,"OrderCode":"{5}","Code":"Hóa đơn 2","Discount":0,"InvoiceDetails":[{6},{7}],"InvoiceOrderSurcharges":[{{"Id":{8},"SurchargeId":{9},"SurValueRatio":{10},"Price":{11},"CreatedDate":"2019-11-15T16:49:24.0366667+07:00","SurchargeName":"","SurchargeIsReturnAuto":false,"Code":"TK003","Name":"Phí VAT3"}},{{"Id":{12},"SurchargeId":{13},"SurValue":{14},"Price":{15},"CreatedDate":"2019-11-15T16:49:24.0366667+07:00","SurchargeName":"","SurchargeIsReturnAuto":false,"Code":"TK008","Name":"Phí giao hàng4"}}],"InvoicePromotions":[{{"Type":17,"TargetType":2,"SalePromotionId":{16},"PromotionId":{17},"ProductId":{18},"RelatedProductQty":3,"ProductQty":1,"PromotionInfo":"KM theo HH và HĐ hình thức GG hàng VND: Tổng tiền hàng từ 4,000,000 và mua 3 DVT38 - Đơn vị tính 38 - (cái) giảm giá 6 cho 1 HKM007 - Hàng khuyến mại 5","PrintPromotionInfo":"Tổng tiền hàng từ 4,000,000 và mua 3 DVT38 - Đơn vị tính 38 - (cái) giảm giá 6 cho 1 Hàng khuyến mại 5","ProductIds":"{18}","BackupSelectedSerials":{{}}}}],"Payments":[{{"Method":"Cash","MethodStr":"Tiền mặt","Amount":{19},"Id":-1}}],"Status":1,"Total":{20},"Surcharge":{21},"Type":1,"Uuid":"","addToAccount":"0","PayingAmount":0,"OrderPaidAmount":{22},"DepositReturn":{23},"TotalBeforeDiscount":{24},"ProductDiscount":6000,"PaidAmount":5960000,"DebugUuid":"","InvoiceWarranties":[],"CreatedBy":441968}}}}    ${BRANCH_ID}    ${get_id_nguoitao}    ${get_order_id}    ${get_id_kh}    ${get_id_nguoiban}
    ...     ${order_code}    ${liststring_prs_order_detail}    ${liststring_prs_order_detail_promo}   ${get_id_detail_thukhac1}    ${get_id_thukhac1}
    ...    ${actual_surcharge1_value}    ${actual_value_surcharge1}   ${get_id_detail_thukhac2}    ${get_id_thukhac2}
    ...    ${actual_surcharge2_value}    ${actual_value_surcharge2}    ${get_id_sale_promo}     ${get_id_promotion}    ${get_id_sp_promo}    ${actual_tamung}
    ...     ${result_tongtienhang_tovalidate}    ${total_surcharge}    ${get_khachdatra_in_dh_bf_execute}    ${result_tamung}   ${result_tongtienhang}
    Log    ${request_payload}
    ${invoice_code}    Post request to create invoice and get invoice code    ${request_payload}
    #get value
    Sleep    20s    wait for response to API
    #assert value product in invoice
    ${list_soluong_in_hd}    ${list_giatri_quydoi_in_hd}    Get list quantity and gia tri quy doi by invoice code    ${get_list_hh_in_dh_bf_execute}    ${invoice_code}
    : FOR    ${ma_hh}    ${result_toncuoi}    ${item_soluong}    ${get_giatri_quydoi}    IN ZIP    ${get_list_hh_in_dh_bf_execute}
    ...    ${result_list_toncuoi}    ${list_soluong_in_hd}    ${list_giatri_quydoi_in_hd}
    \    Run Keyword If    '${get_giatri_quydoi}' == '1'    Validate product history frm API    ${invoice_code}    ${ma_hh}    ${result_toncuoi}    ${item_soluong}
    \    ...    ELSE    Validate unit product history frm API    ${invoice_code}    ${ma_hh}    ${result_toncuoi}
    \    ...    ${item_soluong}    ${get_giatri_quydoi}
    #assert value product promo in invoice
    ${list_soluong_in_hd_promo}    ${list_giatri_quydoi_in_hd_promo}    Get list quantity and gia tri quy doi by invoice code    ${list_product_promo}    ${invoice_code}
    : FOR    ${ma_hh_promo}    ${result_toncuoi_promo}    ${item_soluong_promo}    ${get_giatri_quydoi_promo}    IN ZIP    ${list_product_promo}
    ...    ${list_result_toncuoi_promo}    ${list_soluong_in_hd_promo}    ${list_giatri_quydoi_in_hd_promo}
    \    Run Keyword If    '${get_giatri_quydoi}' == '1'    Validate product history frm API    ${invoice_code}    ${ma_hh_promo}    ${result_toncuoi_promo}    ${item_soluong_promo}
    \    ...    ELSE    Validate unit product history frm API    ${invoice_code}    ${ma_hh_promo}    ${result_toncuoi_promo}    ${item_soluong_promo}    ${get_giatri_quydoi_promo}
    #validate deleted product
    ${list_order_summary_delete_af_execute}    Get list order summary frm product API    ${list_product_del}
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
    Should Be Equal As Strings    ${get_ghichu_in_hd_af_execute}    0
    #assert value order
    ${get_ma_kh_in_dh_af_execute}    ${get_TTDH_in_dh_af_execute}    ${get_tongtienhang_in_dh_af_exxecute}    ${get_khachdatra_in_dh_af_execute}    ${get_ghichu_af_execute}    Get order info have note by order code    ${order_code}
    Should Be Equal As Strings    ${get_ma_kh_in_dh_af_execute}    ${input_ma_kh}
    Should Be Equal As Strings    ${get_TTDH_in_dh_af_execute}    2    #trạng thái đang giao hàng
    Should Be Equal As Numbers    ${get_tongtienhang_in_dh_af_exxecute}    ${get_tongtienhang_in_dh_bf_execute}
    Should Be Equal As Numbers    ${get_khachdatra_in_dh_af_execute}    ${result_khachdatra_in_dh}
    Should Be Equal As Strings    ${get_ghichu_af_execute}    0
    Validate invoice history frm Order    ${order_code}    ${invoice_code}    ${result_tongtienhang_tovalidate}
    ## Deactivate surcharge
    Delete invoice by invoice code    ${invoice_code}
    Delete order frm Order code    ${order_code}
    Run Keyword If    ${actual_surcharge1_value} > 100    Toggle surcharge VND    ${input_thukhac1}    false
    ...    ELSE    Toggle surcharge percentage    ${input_thukhac1}    false
    Run Keyword If    ${actual_surcharge2_value} > 100    Toggle surcharge VND    ${input_thukhac2}    false
    ...    ELSE    Toggle surcharge percentage    ${input_thukhac2}    false
    Toggle status of promotion    ${input_khuyenmai}    0
