*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    ${headless_browser}
Resource          ../../../../../core/API/api_thietlap.robot
Resource          ../../../../../core/API/api_access.robot
Resource          ../../../../../core/API/api_dathang.robot
Resource          ../../../../../core/Ban_Hang/banhang_getandcompute.robot
Resource          ../../../../../core/Ban_Hang/banhang_page.robot
Resource          ../../../../../core/share/toast_message.robot
Resource          ../../../../../core/API/api_mhbh_dathang.robot
Resource          ../../../../../core/API/api_soquy.robot
Resource          ../../../../../core/API/api_danhmuc_hanghoa.robot
Resource          ../../../../../config/env_product/envi.robot

*** Variables ***
&{list_product_nums1}    HTKM01=3   SIKM01=2
&{list_product_nums2}    DVKM01=11   SIKM01=1
@{list_del_product}    SIKM01
&{list_give1}    SIKM03=1
@{list_discount}    10000    15
@{discount_type}   disvnd     dis
*** Test Cases ***    Product and num list    Product Discount      List discount type      Order Discount    Customer    Payment    Promotion Code       Tên chi nhánh
KM DH va giam gia dh theo chi nhanh                 [Tags]                  AEDPVKM
                      [Template]              akmpv1
                      ${list_product_nums1}        ${list_discount}      ${discount_type}           15             CTKH070     50000      KM018                Nhánh A                #giam gia HD %

KM HH va HD hinh thuc tang hang theo nhom KH
                      [Tags]                   AEDPVKM
                      [Template]               akmpv2
                      ${list_product_nums2}    34000          CTKH072         300000      100000              KM020      ${list_give1}        ${list_del_product}   Nhóm khách VIP

*** Keywords ***
akmpv1
    [Arguments]    ${dict_product_num}    ${list_ggsp}     ${list_discount_type}   ${input_ggdh}    ${input_ma_kh}    ${input_bh_khachtt}
    ...    ${input_khuyenmai}    ${input_ten_branch}
    ## Get info ton cuoi, cong no khach hang
    ${get_current_branch_name}    Get current branch name
    Switch branch    ${get_current_branch_name}     ${input_ten_branch}
    Toggle status of promotion and not for all branch    ${input_khuyenmai}    1    ${input_ten_branch}
    ${list_product}    Get Dictionary Keys    ${dict_product_num}
    ${list_nums}    Get Dictionary Values    ${dict_product_num}
    ${invoice_value}    ${discount}    ${discount_ratio}    ${name}    Get Invoice value - Discounts - Promotion Name from Promotion Code    ${input_khuyenmai}
    ${get_no_bf_execute}    ${get_tongban_bf_execute}    ${get_tongban_tru_trahang_bf_execute}    Get Customer Debt from API    ${input_ma_kh}
    ${list_result_thanhtien}    Create List
    ${list_result_order_summary}    Create List
    ${list_result_giamoi}    Create List
    ${get_list_baseprice}    ${list_order_summary}    Get list of baseprice and order summary by product code and branch id    ${list_product}    ${input_ten_branch}
    : FOR    ${item_ma_hh}    ${nums}    ${input_ggsp}    ${get_tong_dh}    ${get_giaban_bf_execute}    ${discount_type}    IN ZIP    ${list_product}
    ...     ${list_nums}    ${list_ggsp}    ${list_order_summary}    ${get_list_baseprice}   ${list_discount_type}
    \    ${result_tongso_dh}    Sum    ${get_tong_dh}    ${nums}
    \    ${result_giamoi}    Run Keyword If    '${discount_type}' == 'dis'    Price after % discount product    ${get_giaban_bf_execute}    ${input_ggsp}
    \    ...    ELSE IF    '${discount_type}' == 'disvnd'    Minus and round 2    ${get_giaban_bf_execute}    ${input_ggsp}
    \    ...    ELSE IF    '${discount_type}' == 'changeup' or '${discount_type}' == 'changedown'   Set Variable   ${input_ggsp}
    \    ...    ELSE     Set Variable    ${get_giaban_bf_execute}
    \    ${result_thanhtien}    Multiplication and round    ${result_giamoi}    ${nums}
    \    Append To List    ${list_result_thanhtien}    ${result_thanhtien}
    \    Append To List    ${list_result_order_summary}    ${result_tongso_dh}
    \    Append To List    ${list_result_giamoi}    ${result_giamoi}
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
    ${result_nohientai}    Minus    ${get_no_bf_execute}    ${actual_khachtt}
    ${result_tongban}    Sum    ${result_khachcantra}    ${get_tongban_bf_execute}
    #create order
    ${get_id_branch}    Get BranchID by BranchName    ${input_ten_branch}
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${get_id_sale_promo}    ${get_id_promotion}    ${get_promo_discount}    Get promotion info    ${input_khuyenmai}
    ${jsonpath_id_kh}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_kh}
    ${get_id_kh}    Get data from API    ${endpoint_khachhang}    ${jsonpath_id_kh}
    ${endpoint_danhmuc_hh_co_dvt}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${get_id_branch}
    ${get_resp_danhmuc_hh}    Get Request and return body    ${endpoint_danhmuc_hh_co_dvt}
    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}    Get list jsonpath product frm list product    ${list_product}
    ${list_giaban}    ${list_result_ggsp}    ${list_id_sp}    Get product info frm list jsonpath product incase discount product    ${get_resp_danhmuc_hh}
    ...    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}    ${list_ggsp}     ${list_discount_type}
    #post request
    ${liststring_prs_order_detail}     Set Variable      needdel
    Log        ${liststring_prs_order_detail}
    : FOR   ${item_result_ggsp}   ${item_ggsp}    ${item_gia_ban}   ${item_id_sp}   ${item_soluong}      IN ZIP   ${list_result_ggsp}
    ...    ${list_ggsp}       ${list_giaban}    ${list_id_sp}    ${list_nums}
    \    ${item_ggsp}   Set Variable If    0 < ${item_ggsp} < 100    ${item_ggsp}   0
    \    ${payload_each_product}        Format string       {{"BasePrice":105000.02,"Discount":{0},"DiscountRatio":{1},"IsLotSerialControl":false,"IsRewardPoint":false,"Note":"","Price":{2},"ProductCode":"HH0052","ProductId":{3},"ProductName":"Bánh Pía Sầu Riêng Truly Vietnam Có Trứng","Quantity":{4},"Uuid":"","ProductBatchExpireId":null}}   ${item_result_ggsp}   ${item_ggsp}       ${item_gia_ban}   ${item_id_sp}   ${item_soluong}
    \    ${liststring_prs_order_detail}       Catenate      SEPARATOR=,      ${liststring_prs_order_detail}      ${payload_each_product}
    ${liststring_prs_order_detail}       Replace String      ${liststring_prs_order_detail}       needdel,       ${EMPTY}      count=1
    ${request_payload}    Format String    {{"Order":{{"BranchId":{0},"RetailerId":{1},"CustomerId":{2},"SoldById":{3},"SoldBy":{{"CreatedBy":0,"CreatedDate":"2018-07-30T08:27:36.800Z","Email":"","GivenName":"anh.lv","Id":{3},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false}},"SaleChannelId":0,"SaleChannel":null,"Seller":{{"CreatedBy":0,"CreatedDate":"2018-07-30T08:27:36.800Z","Email":"","GivenName":"anh.lv","Id":{3},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false}},"Code":"Đặt hàng 1","Discount":{4},"OrderDetails":[{5}],"InvoiceOrderSurcharges":[],"OrderPromotions":[{{"Type":1,"TargetType":0,"SalePromotionId":{6},"PromotionId":{7},"Discount":{8},"PromotionInfo":"Khuyến mại giảm giá Hóa đơn VNĐ theo chi nhanh:Tổng tiền hàng từ 5,000,000 giảm giá 200,000 cho hóa đơn","PrintPromotionInfo":"Khuyến mại giảm giá Hóa đơn VNĐ theo chi nhanh: Tổng tiền hàng từ 5,000,000 giảm giá 200,000 cho hóa đơn"}}],"Payments":[{{"Method":"Cash","MethodStr":"Tiền mặt","Amount":{9},"Id":-1}}],"UsingCod":0,"Status":1,"Total":5300000,"Extra":"{{\\"Amount\\":100000,\\"Method\\":{{\\"Id\\":\\"Cash\\",\\"Label\\":\\"Tiền mặt\\"}},\\"ResetPromotion\\":false}}","Surcharge":0,"Type":2,"Uuid":"","addToAccount":"0","PayingAmount":100000,"TotalBeforeDiscount":5500000,"ProductDiscount":0,"CreatedBy":201567,"InvoiceWarranties":[],"DiscountByPromotion":200000,"DiscountByPromotionValue":200000,"DiscountByPromotionRatio":0}}}}    ${get_id_branch}    ${get_id_nguoitao}    ${get_id_kh}    ${get_id_nguoiban}   ${final_discount}    ${liststring_prs_order_detail}    ${get_id_sale_promo}
    ...    ${get_id_promotion}   ${discount}    ${actual_khachtt}
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
    ${list_order_summary_af_execute}    Get list of order summary by product code and branch id    ${list_product}    ${input_ten_branch}
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
    ${get_id_branch}    Get BranchID by BranchName    ${input_ten_branch}
    ${get_endpoint_by_branch}    Format String    ${endpoint_tong_quy}    ${get_id_branch}
    ${jsonpath_giatri_hd}    Format String    $..Data[?(@.Code=="{0}")].Amount    ${get_ma_phieutt_in_dh}
    ${get_hd_giatri}    Get data from API    ${get_endpoint_by_branch}    ${jsonpath_giatri_hd}
    Should Be Equal As Numbers    ${get_hd_giatri}    ${actual_khachtt}
    Delete order frm Order code    ${order_code}
    Toggle status of promotion and not for all branch    ${input_khuyenmai}    0    ${input_ten_branch}

akmpv2
    [Arguments]    ${dict_product_num}    ${input_discount_inv}    ${input_ma_kh}    ${input_bh_khachtt}    ${input_khtt_create_order}    ${input_khuyenmai}
    ...   ${give}    ${list_product_del}    ${input_ten_nhom_kh}
    [Timeout]
    ## Get info ton cuoi, cong no khach hang
    Toggle status of promotion and not for all customer    ${input_khuyenmai}    1    ${input_ten_nhom_kh}    Dịch vụ     Bánh nhập KM
    ${list_product}    Get Dictionary Keys    ${dict_product_num}
    ${list_nums}    Get Dictionary Values    ${dict_product_num}
    ${list_give_product}    Get Dictionary Keys    ${give}
    ${list_give_nums}    Get Dictionary Values    ${give}
    ${order_code}     Add new order with multi products    ${input_ma_kh}    ${dict_product_num}    ${input_khtt_create_order}
    ${invoice_value}    ${received_value}    ${discount}    ${discount_ratio}    ${name}    Get Invoice value - Received value - Discounts - Promotion Name from Promotion Code    ${input_khuyenmai}
    Create list imei and other product    ${list_give_product}    ${list_give_nums}
    ${get_list_hh_in_dh_bf_execute}    ${get_ghichu_bf_execute}    Get ghi chu and list product frm API    ${order_code}
    ${list_result_tongdh_delete}    Get list order summary frm product API    ${list_product}
    ${get_no_bf_execute}    ${get_tongban_bf_execute}    ${get_tongban_tru_trahang_bf_execute}    Get Customer Debt from API    ${input_ma_kh}
    ${get_khachdatra_in_dh_bf_execute}    ${get_tongtienhang_in_dh_bf_execute}    Get paid value frm API    ${order_code}
    #get order summary and sub total of products
    : FOR    ${ma_hh}    IN    @{list_product_del}
    \    Remove Values From List    ${get_list_hh_in_dh_bf_execute}    ${ma_hh}
    Log    ${get_list_hh_in_dh_bf_execute}
    ${get_list_nums_in_dh}    Get list quantity by order code    ${order_code}    ${get_list_hh_in_dh_bf_execute}
    ${list_result_tongdh}    ${result_list_toncuoi}    ${result_list_thanhtien}    Get list order summary - total sale - ending stocks frm API    ${order_code}    ${get_list_hh_in_dh_bf_execute}
    #Compute
    ${result_tongtienhang}    Sum values in list    ${result_list_thanhtien}
    ${result_khachcantra}    Minus and replace floating point    ${result_tongtienhang}    ${input_discount_inv}
    ${result_khachcanthanhtoan}    Minus and replace floating point    ${result_khachcantra}        ${get_khachdatra_in_dh_bf_execute}
    ${actual_khachtt}    Set Variable If    '${input_bh_khachtt}' == 'all'    ${result_khachcantra}    ${input_bh_khachtt}
    ${result_khachdatra}    Sum    ${get_khachdatra_in_dh_bf_execute}    ${actual_khachtt}
    ${get_list_status}    Get list imei status thr API    ${list_give_product}
    #create invoice
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${jsonpath_id_kh}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_kh}
    ${get_id_kh}    Get data from API    ${endpoint_khachhang}    ${jsonpath_id_kh}
    ${endpoint_danhmuc_hh_co_dvt}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${get_resp_danhmuc_hh}    Get Request and return body    ${endpoint_danhmuc_hh_co_dvt}
    ${get_id_sale_promo}    ${get_id_promotion}    ${get_promo_discount}    Get promotion info    ${input_khuyenmai}
    ${get_order_id}   ${get_payment_id}   Get order - payment frm order api    ${order_code}
    ${get_list_order_detail_id}   Get list orderdetail id frm order api    ${order_code}    ${get_list_hh_in_dh_bf_execute}
    #list payload of product
    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}    Get list jsonpath product frm list product    ${get_list_hh_in_dh_bf_execute}
    ${list_giaban}    ${list_id_sp}    Get product info frm list jsonpath product    ${get_resp_danhmuc_hh}    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}
    ${liststring_prs_order_detail}     Set Variable      needdel
    Log        ${liststring_prs_order_detail}
    : FOR   ${item_gia_ban}   ${item_id_sp}   ${item_soluong}   ${get_orderdetail_id}      IN ZIP    ${list_giaban}        ${list_id_sp}    ${list_nums}   ${get_list_order_detail_id}
    \    ${payload_each_product}        Format string       {{"BasePrice":{0},"IsLotSerialControl":false,"IsRewardPoint":false,"Note":"","Price":{0},"ProductId":{1},"Quantity":{2},"ProductCode":"DVKM01","Discount":0,"DiscountRatio":0,"ProductName":"Hàng DV khuyến mại 1","SalePromotionId":null,"OriginPrice":{0},"PriceByPromotion":null,"IsMaster":true,"PromotionParentProductId":null,"ProductBatchExpireId":null,"CategoryId":794172,"MasterProductId":{1},"Unit":"","Uuid":"","OrderDetailId":{3},"ProductWarranty":[]}}   ${item_gia_ban}   ${item_id_sp}   ${item_soluong}    ${get_orderdetail_id}
    \    ${liststring_prs_order_detail}       Catenate      SEPARATOR=,      ${liststring_prs_order_detail}      ${payload_each_product}
    ${liststring_prs_order_detail}       Replace String      ${liststring_prs_order_detail}       needdel,       ${EMPTY}      count=1
    #list payload of product promo
    ${list_jsonpath_id_sp_promo}    ${list_jsonpath_giaban_promo}    Get list jsonpath product frm list product    ${list_give_product}
    ${list_giaban_promo}    ${list_id_sp_promo}    Get product info frm list jsonpath product    ${get_resp_danhmuc_hh}    ${list_jsonpath_id_sp_promo}    ${list_jsonpath_giaban_promo}
    ${liststring_prs_order_detail_promo}     Set Variable      needdel
    Log        ${liststring_prs_order_detail_promo}
    : FOR   ${item_gia_ban_promo}   ${item_id_sp_promo}   ${item_soluong_promo}   ${item_imei}    IN ZIP   ${list_giaban_promo}    ${list_id_sp_promo}    ${list_give_nums}    ${imei_inlist}
    \    ${item_imei}    Convert list to string and return    ${item_imei}
    \    ${payload_each_product_promo}        Format string       {{"BasePrice":{0},"IsLotSerialControl":true,"IsRewardPoint":false,"Note":"","Price":{0},"ProductId":{1},"Quantity":{2},"ProductCode":"SIKM03","SerialNumbers":"{3}","Discount":{0},"ProductName":"Hàng KM imei 3","SalePromotionId":{4},"OriginPrice":{0},"ProductBatchExpireId":null,"CategoryId":813065,"MasterProductId":{1},"Unit":"","Uuid":"","ProductWarranty":[]}}   ${item_gia_ban_promo}   ${item_id_sp_promo}   ${item_soluong_promo}   ${item_imei}    ${get_id_sale_promo}
    \    ${liststring_prs_order_detail_promo}       Catenate      SEPARATOR=,      ${liststring_prs_order_detail_promo}      ${payload_each_product_promo}
    ${liststring_prs_order_detail_promo}       Replace String      ${liststring_prs_order_detail_promo}       needdel,       ${EMPTY}      count=1
    ${get_id_sp_promo}    Get From List    ${list_id_sp_promo}    0
    ${list_id_sp_promo}   Convert list to string and return     ${list_id_sp_promo}
    #post request
    ${request_payload}    Format String    {{"Invoice":{{"BranchId":{0},"RetailerId":{1},"OrderId":{2},"UpdateInvoiceId":0,"UpdateReturnId":0,"CustomerId":{3},"SoldById":{4},"SoldBy":{{"CreatedBy":0,"CreatedDate":"2018-07-30T08:27:36.800Z","GivenName":"anh.lv","Id":{4},"IsActive":true,"IsAdmin":true,"Type":0,"isDeleted":false,"Name":"anh.lv"}},"SaleChannelId":0,"Seller":{{"CreatedBy":0,"CreatedDate":"2018-07-30T08:27:36.800Z","GivenName":"anh.lv","Id":{4},"IsActive":true,"IsAdmin":true,"Type":0,"isDeleted":false,"Name":"anh.lv"}},"PriceBookId":0,"OrderCode":"{5}","Code":"Hóa đơn 2","Discount":{6},"InvoiceDetails":[{7},{8}],"InvoiceOrderSurcharges":[],"InvoicePromotions":[{{"Type":16,"TargetType":2,"SalePromotionId":{9},"PromotionId":{10},"ProductId":{11},"RelatedProductQty":2,"ProductQty":1,"SelectedSerials":"IM015","PromotionInfo":"KM theo HH và HĐ hình thức tặng hàng theo nhóm KH: Tổng tiền hàng từ 5,000,000 và mua 11 DVKM01 - Hàng DV khuyến mại 1 tặng 1 SIKM03 - Hàng KM imei 3 cho hóa đơn","PrintPromotionInfo":"Tổng tiền hàng từ 5,000,000 tặng 1 Hàng KM imei 3 cho hóa đơn","ProductIds":"{11}","BackupSelectedSerials":{{"{11}":"IM015"}}}}],"Payments":[{{"Method":"Cash","MethodStr":"Tiền mặt","Amount":{12},"Id":-1}}],"Status":1,"Total":{13},"Surcharge":0,"Type":1,"Uuid":"","addToAccount":"0","PayingAmount":{12},"OrderPaidAmount":{14},"DepositReturn":0,"TotalBeforeDiscount":{15},"ProductDiscount":200000,"PaidAmount":{14},"DebugUuid":"","InvoiceWarranties":[],"ActiveCustomerGroupId":28571,"CreatedBy":201567}}}}    ${BRANCH_ID}    ${get_id_nguoitao}    ${get_order_id}    ${get_id_kh}    ${get_id_nguoiban}
    ...     ${order_code}   ${input_discount_inv}    ${liststring_prs_order_detail}    ${liststring_prs_order_detail_promo}   ${get_id_sale_promo}
    ...    ${get_id_promotion}    ${list_id_sp_promo}    ${actual_khachtt}    ${result_khachcantra}    ${get_khachdatra_in_dh_bf_execute}    ${result_tongtienhang}
    Log    ${request_payload}
    ${invoice_code}    Post request to create invoice and get invoice code    ${request_payload}
    #get values
    Sleep    20 s    wait for response to API
    #assert value product in invoice
    ${get_list_hh_in_hd_af_execute}    Get list product frm Invoice API    ${invoice_code}
    ${list_soluong_in_hd}    ${list_giatri_quydoi_in_hd}    Get list quantity and gia tri quy doi by invoice code    ${get_list_hh_in_hd_af_execute}    ${invoice_code}
    : FOR    ${ma_hh}    ${result_toncuoi}    ${item_soluong}    ${get_giatri_quydoi}    IN ZIP    ${get_list_hh_in_hd_af_execute}
    ...    ${result_list_toncuoi}    ${list_soluong_in_hd}    ${list_giatri_quydoi_in_hd}
    \    Run Keyword If    '${get_giatri_quydoi}' == '1'    Validate product history frm API    ${invoice_code}    ${ma_hh}    ${result_toncuoi}
    \    ...    ${item_soluong}
    \    ...    ELSE    Validate unit product history frm API    ${invoice_code}    ${ma_hh}    ${result_toncuoi}
    \    ...    ${item_soluong}    ${get_giatri_quydoi}
    #assert value product
    ${list_order_summary_af_execute}    Get list order summary by order code    ${order_code}
    : FOR    ${result_tong_dh}    ${order_summary_af_execute}    IN ZIP    ${list_result_tongdh}    ${list_order_summary_af_execute}
    \    Should Be Equal As Numbers    ${order_summary_af_execute}    ${result_tong_dh}
    #assert value invoice
    ${get_ma_kh_by_hd}    ${get_tong_tien_hang}    ${get_khachtt_af_execute}    ${get_gghd_af_execute}    ${get_khachcantra}    ${get_trangthai}    ${get_ghichu_in_hd_af_execute}
    ...    Get invoice info have note incase discount by invoice code    ${invoice_code}
    Should Be Equal As Numbers    ${get_tong_tien_hang}    ${result_tongtienhang}
    Should Be Equal As Numbers    ${get_khachcantra}    ${result_khachcantra}
    Should Be Equal As Numbers    ${get_khachtt_af_execute}    ${result_khachdatra}
    Should Be Equal As Strings    ${get_ma_kh_by_hd}    ${input_ma_kh}
    Should Be Equal As Numbers    ${get_gghd_af_execute}    ${input_discount_inv}
    Should Be Equal As Strings    ${get_trangthai}    Hoàn thành
    #assert value order
    ${get_ma_kh_in_dh_af_execute}    ${get_TTDH_in_dh_af_execute}    ${get_tongtienhang_in_dh_af_exxecute}    ${get_khachdatra_in_dh_af_execute}    ${get_ghichu_af_execute}    Get order info have note by order code    ${order_code}
    Should Be Equal As Strings    ${get_ma_kh_in_dh_af_execute}    ${input_ma_kh}
    Should Be Equal As Strings    ${get_TTDH_in_dh_af_execute}    2    #trạng thái đang giao hàng
    Should Be Equal As Numbers    ${get_tongtienhang_in_dh_af_exxecute}    ${get_tongtienhang_in_dh_bf_execute}
    Should Be Equal As Numbers    ${get_khachdatra_in_dh_af_execute}    ${result_khachdatra}
    Should Be Equal As Strings    ${get_ghichu_af_execute}    ${get_ghichu_bf_execute}
    Validate invoice history frm Order    ${order_code}    ${invoice_code}    ${result_khachcantra}
    Delete invoice by invoice code    ${invoice_code}
    Delete order frm Order code    ${order_code}
    Toggle status of promotion and not for all customer    ${input_khuyenmai}    0    ${input_ten_nhom_kh}    Dịch vụ     Bánh nhập KM
