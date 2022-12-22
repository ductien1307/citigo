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
&{dict_product1}      PROMO3=1    HH0034=1
&{dict_product_new}    DVL009=1
&{dict_promo_nor1}    HKM001=2    HKM002=2
&{dict_promo_nor2}    HKM001=4
&{dict_promo_update1}    HKM001=4    HKM002=2
&{dict_promo_update2}     HKM001=1    HKM002=3
&{list_product2}    DVL010=3
@{list_no_discount}    0    0
@{list_quantity}    5

*** Test Cases ***    List product nums    GGDH             Mã KH      Khách thanh toán    Mã khuyến mãi    List product          List GGSP              KTT to create order    List product add
KM HH hinh thuc mua hang GG hang
                      [Tags]               AKMDH2
                      [Template]           eduhh01_api
                      ${dict_product1}     10000            CTKH265    10000               KM06            ${dict_promo_nor1}    ${list_no_discount}    0       ${dict_product_new}    ${dict_promo_update1}   #mua hang gg hang vnd

KM HH hinh thuc mua hang tang hang
                      [Tags]               AKMDH2
                      [Template]           eduhh02_api
                      ${dict_product1}     2000             CTKH264    all                 KM08            ${dict_promo_nor2}    5000      ${dict_promo_update2}    #mua hang gg hang tang hang

KM HH hinh thuc gia ban theo SL mua
                      [Documentation]      San pham KM la SP dich vu\nCase khong validate ton kho cua SP KM
                      [Tags]               AKMDH2
                      [Template]           eduhh03_api
                      ${list_product2}     10               CTKH265    0                   KM11            100000                ${list_quantity}       ${list_no_discount}                 #giam gia san pham theo so luong mua %

*** Keywords ***
eduhh01_api
    [Arguments]    ${dict_product_num}    ${input_discount_order}    ${input_ma_kh}    ${input_bh_khachtt}    ${input_khuyemmai}    ${dict_promo_product}
    ...    ${list_ggsp}    ${input_khtt_create_order}    ${dict_product_add}      ${dict_promo_product_add}
    [Timeout]
    ## Get info ton cuoi, cong no khach hang
    Toggle status of promotion    ${input_khuyemmai}    1
    ${order_code}    Add new order with promotion buy product and get other product discount    ${input_ma_kh}    ${dict_product_num}    ${input_khuyemmai}    ${dict_promo_product}    ${input_khtt_create_order}
    ${num_sale_product}    ${num_promo_product}    ${product_price}    ${discount}    ${discount_ratio}    ${name}    Get Number of sale product - promo product - promo value and name
    ...    ${input_khuyemmai}
    ${list_promo_product_add}    Get Dictionary Keys    ${dict_promo_product_add}
    ${list_promo_num_add}    Get Dictionary Values    ${dict_promo_product_add}
    ${list_product}    Get Dictionary Keys    ${dict_product_num}
    ${list_nums}    Get Dictionary Values    ${dict_product_num}
    ${list_promo_product}    Get Dictionary Keys    ${dict_promo_product}
    ${list_promo_num}    Get Dictionary Values    ${dict_promo_product}
    ${list_product_add}    Get Dictionary Keys    ${dict_product_add}
    ${list_nums_add}    Get Dictionary Values    ${dict_product_add}
    ${get_no_bf_execute}    ${get_tongban_bf_execute}    ${get_tongban_tru_trahang_bf_execute}    ${get_customer_name}    Get Customer Info from API    ${input_ma_kh}
    ${get_khachdatra_in_dh_bf_execute}    ${get_tongtienhang_in_dh_bf_execute}    Get paid value frm API    ${order_code}
    ${get_list_ordersummary_bf_execute}    Get list order summary frm product API    ${list_product}
    ${list_result_thanhtien_add}    ${list_result_order_summary_add}    ${list_result_giamoi_add}    Get list total sale and order summary incase discount    ${list_product_add}    ${list_nums_add}    ${list_ggsp}
    ${list_result_thanhtien}    ${list_result_order_summary}    ${list_result_giamoi}    Get list total sale and order summary incase discount    ${list_product}    ${list_nums}    ${list_ggsp}
    ##get thanh tien promo
    ${get_list_baseprice}    Get list of Baseprice by Product Code    ${list_promo_product_add}
    ${list_order_summary}    Get list order summary frm product API    ${list_promo_product_add}
    ${list_result_order_summary_promo}    Create List
    ${list_result_thanhtien_promo}    Create List
    : FOR    ${order_summary_add}    ${promo_num}    ${promo_num_add}   ${item_giaban}    IN ZIP    ${list_order_summary}    ${list_promo_num}    ${list_promo_num_add}    ${get_list_baseprice}
    \     ${result_newprice}    Minus and round   ${item_giaban}    ${discount}
    \    ${result_thanhtien}    Multiplication and round    ${result_newprice}    ${promo_num_add}
    \    ${result_promo_num}    Run Keyword If    0 < ${promo_num_add} < ${promo_num}     Minus and replace floating point    ${promo_num}    ${promo_num_add}
    \    ...    ELSE IF    ${promo_num_add} > ${promo_num}    Minus and replace floating point    ${promo_num_add}    ${promo_num}    ELSE    Set Variable     ${promo_num_add}
    \    ${result_order_summary_promo}    Run Keyword If    0 < ${promo_num_add} < ${promo_num}     Minus and replace floating point    ${order_summary_add}    ${result_promo_num}
    \    ...    ELSE IF    ${promo_num_add} > ${promo_num}    Sum and replace floating point    ${order_summary_add}    ${result_promo_num}   ELSE    Set Variable     ${order_summary_add}
    \    Append to list    ${list_result_order_summary_promo}    ${result_order_summary_promo}
    \    Append to list    ${list_result_thanhtien_promo}    ${result_thanhtien}
    #order summary
    : FOR    ${order_summary_promo_add}    IN    @{list_result_order_summary_promo}
    \    Append To List    ${list_result_order_summary_add}    ${order_summary_promo_add}
    : FOR    ${order_summary}    IN    @{get_list_ordersummary_bf_execute}
    \    Append To List    ${list_result_order_summary_add}    ${order_summary}
    ${list_result_order_summary_add}    Convert String to List    ${list_result_order_summary_add}
    Log    ${list_result_order_summary_add}
    #Compute
    ${result_tongtienhang}    Sum values in list    ${list_result_thanhtien}
    ${result_thanhtien_promo_add}     Sum values in list    ${list_result_thanhtien_promo}
    ${result_tongtienhang_add}    Sum values in list    ${list_result_thanhtien_add}
    ${result_tongtienhang}    Sum x 3     ${result_tongtienhang}    ${result_tongtienhang_add}    ${result_thanhtien_promo_add}
    ${result_khachcantra}    Minus    ${result_tongtienhang}    ${input_discount_order}
    ${result_khachcantra}    Replace floating point    ${result_khachcantra}
    ${actual_khachtt}    Set Variable If    '${input_bh_khachtt}' == 'all'    ${result_khachcantra}    ${input_bh_khachtt}
    ${result_nohientai}    Minus    ${get_no_bf_execute}    ${actual_khachtt}
    #create invoice
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${jsonpath_id_kh}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_kh}
    ${get_id_kh}    Get data from API    ${endpoint_khachhang}    ${jsonpath_id_kh}
    ${endpoint_danhmuc_hh_co_dvt}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${get_resp_danhmuc_hh}    Get Request and return body    ${endpoint_danhmuc_hh_co_dvt}
    ${get_id_sale_promo}    ${get_id_promotion}    ${get_promo_discount}    Get product promotion info     ${input_khuyemmai}
    ${get_order_id}   ${get_payment_id}   Get order - payment frm order api    ${order_code}
    ${get_list_order_detail_id}   Get list orderdetail id frm order api    ${order_code}    ${list_product}
    #get list gia ban, id san pham, discount of product
    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}    Get list jsonpath product frm list product    ${list_product}
    ${list_giaban}    ${list_id_sp}    Get product info frm list jsonpath product    ${get_resp_danhmuc_hh}    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}
    ${list_jsonpath_id_sp_promo}    ${list_jsonpath_giaban_promo}    Get list jsonpath product frm list product    ${list_promo_product_add}
    ${list_giaban_promo}    ${list_id_sp_promo}    Get product info frm list jsonpath product    ${get_resp_danhmuc_hh}    ${list_jsonpath_id_sp_promo}    ${list_jsonpath_giaban_promo}
    ${list_jsonpath_id_sp_new}    ${list_jsonpath_giaban_new}    Get list jsonpath product frm list product    ${list_product_add}
    ${list_giaban_new}    ${list_id_sp_new}    Get product info frm list jsonpath product    ${get_resp_danhmuc_hh}        ${list_jsonpath_id_sp_new}    ${list_jsonpath_giaban_new}
    ${get_id_sp1}    Get From List    ${list_id_sp}    0
    ${get_id_sp2}    Get From List    ${list_id_sp}    1
    ${get_gia_ban1}    Get From List    ${list_giaban}    0
    ${get_gia_ban2}    Get From List    ${list_giaban}    1
    ${input_soluong1}    Get From List    ${list_nums}    0
    ${input_soluong2}    Get From List    ${list_nums}    1
    ${get_id_order_detail1}    Get From List    ${get_list_order_detail_id}    0
    ${get_id_order_detail2}    Get From List    ${get_list_order_detail_id}    1
    #list payload of product new
    ${liststring_prs_order_detail_new}     Set Variable      needdel
    Log        ${liststring_prs_order_detail_new}
    : FOR   ${item_gia_ban_new}   ${item_id_sp_new}   ${item_soluong_new}      IN ZIP   ${list_giaban_new}        ${list_id_sp_new}    ${list_nums_add}
    \    ${payload_each_product_new}        Format string       {{"BasePrice":7000.05,"IsLotSerialControl":false,"IsRewardPoint":false,"Note":"","Price":{0},"ProductCode":"DVT44","ProductId":{1},"ProductName":"Kẹo Foxs Hương Bạc Hà Hộp 180g - (cái)","Quantity":{2},"Uuid":"","ProductBatchExpireId":null}}   ${item_gia_ban_new}   ${item_id_sp_new}   ${item_soluong_new}
    \    ${liststring_prs_order_detail_new}       Catenate      SEPARATOR=,      ${liststring_prs_order_detail_new}      ${payload_each_product_new}
    ${liststring_prs_order_detail_new}       Replace String      ${liststring_prs_order_detail_new}       needdel,       ${EMPTY}      count=1
    #list payload of product promotion
    ${liststring_prs_order_detail_promo}     Set Variable      needdel
    Log        ${liststring_prs_order_detail_promo}
    : FOR   ${item_gia_ban_promo}   ${item_id_sp_promo}   ${item_soluong_promo}      IN ZIP   ${list_giaban_promo}        ${list_id_sp_promo}    ${list_promo_num_add}
    \    ${discount}    Set Variable If    ${item_gia_ban_promo}>=${get_promo_discount}    ${get_promo_discount}     ${item_gia_ban_promo}
    \    ${payload_each_product_promo}        Format string       {{"BasePrice":82000,"Discount":{0},"IsLotSerialControl":false,"IsRewardPoint":false,"Note":"","Price":{1},"ProductCode":"NK001","ProductId":{2},"ProductName":"Hạt tặng 1","PromotionParentProductId":{3},"PromotionParentType":1,"Quantity":{4},"SalePromotionId":{5},"Uuid":"","ProductBatchExpireId":null}}   ${discount}   ${item_gia_ban_promo}   ${item_id_sp_promo}    ${get_id_sp1}   ${item_soluong_promo}    ${get_id_sale_promo}
    \    ${liststring_prs_order_detail_promo}       Catenate      SEPARATOR=,      ${liststring_prs_order_detail_promo}      ${payload_each_product_promo}
    ${liststring_prs_order_detail_promo}       Replace String      ${liststring_prs_order_detail_promo}       needdel,       ${EMPTY}      count=1
    ${list_id_sp}   Convert list to string and return     ${list_id_sp_new}
    ${list_id_sp_promo}   Convert list to string and return     ${list_id_sp_promo}
    #post request
    ${request_payload}    Format String    {{"Order":{{"Id":{0},"BranchId":{1},"RetailerId":{2},"CustomerId":{3},"SoldById":{4},"SoldBy":{{"CreatedBy":0,"CreatedDate":"2018-07-30T08:27:36.800Z","GivenName":"anh.lv","Id":{4},"IsActive":true,"IsAdmin":true,"Type":0,"isDeleted":false,"Name":"anh.lv"}},"SaleChannelId":0,"SaleChannel":null,"Seller":{{"CreatedBy":0,"CreatedDate":"2018-07-30T08:27:36.800Z","GivenName":"anh.lv","Id":{4},"IsActive":true,"IsAdmin":true,"Type":0,"isDeleted":false,"Name":"anh.lv"}},"PurchaseDate":"","Code":"{5}","Discount":{6},"OrderDetails":[{7},{8},{{"BasePrice":{9},"Discount":0,"DiscountRatio":0,"Id":{10},"IsLotSerialControl":false,"IsMaster":true,"IsRewardPoint":false,"MaxQuantity":0,"Note":"","Price":{9},"ProductCode":"HH0042","ProductId":{11},"ProductName":"Bánh Trứng Tik-Tok Bơ Sữa (120g)","Quantity":{12},"Uuid":"","ProductBatchExpireId":null}},{{"BasePrice":38000,"Discount":0,"DiscountRatio":0,"Id":{13},"IsLotSerialControl":false,"IsMaster":true,"IsRewardPoint":false,"MaxQuantity":0,"Note":"","Price":{14},"ProductCode":"HH0043","ProductId":{15},"ProductName":"Gói 3 Thanh Bánh Chocolate KitKat Chunky 38g","Quantity":{16},"Uuid":"","ProductBatchExpireId":null}}],"InvoiceOrderSurcharges":[],"OrderPromotions":[{{"SalePromotionId":{17},"Type":5,"TargetType":1,"PromotionId":{18},"ProductId":null,"RelatedProductId":{19},"Discount":30000,"RelatedProductQty":1,"ProductQty":2,"PromotionInfo":"KM theo HH hình thức mua hàng GG hàng vnd: Khi mua 1 DVL009 - Dịch vụ 09, 1 PROMO3 - Bánh Trứng Tik-Tok Bơ Sữa (120g), 1 HH0034 - Trà sữa Royal tea mix Myanma giảm giá 30,000 cho 4 HKM001 - Gói 6 Thanh Bánh Socola KitKat 2F 17g, 2 HKM002 - Kẹo Hồng Sâm Vitamin Daegoung Food","PrintPromotionInfo":"Mua 1 Dịch vụ 09, 1 Bánh Trứng Tik-Tok Bơ Sữa (120g), 1 Trà sữa Royal tea mix Myanma giảm giá 30,000 cho 4 Gói 6 Thanh Bánh Socola KitKat 2F 17g, 2 Kẹo Hồng Sâm Vitamin Daegoung Food","ProductIds":"{20}","RelatedProductIds":"{21}","BackupSelectedSerials":{{}},"RelatedCategoryIds":"794169"}}],"Payments":[{{"OrderValue":0,"DocumentValue":0,"PaidValue":0,"NeedPayValue":0,"CustomerName":"","CustomerCode":"","InvoiceCode":"","CustomerDebt":0,"CustomerOldDebt":0,"TargetCode":"","UserName":"","VoucherCampaignId":0,"Version":0,"IsUpdate":false,"TransGuid":"00000000000000000000000000000000","DocumentTypeValue":0,"Id":{22},"Code":"TTDH001182","Amount":{23},"AmountOriginal":0,"Method":"Cash","CreatedDate":"","CreatedBy":{4},"RetailerId":{2},"BranchId":{1},"OrderId":{0},"CustomerId":{3},"TransDate":"","UserId":{4},"Status":0,"System":false,"DeliveryPayments":[],"PaymentAllocation":[]}},{{"Method":"Cash","MethodStr":"Tiền mặt","Amount":{24},"Id":-2}}],"UsingCod":0,"Status":1,"Total":289500,"Extra":"{{\\"Amount\\":10000,\\"Method\\":{{\\"Id\\":\\"Cash\\",\\"Label\\":\\"Tiền mặt\\"}},\\"activeCustomerGroupId\\":null,\\"ResetPromotion\\":false}}","Surcharge":0,"Type":2,"Uuid":"","addToAccount":"0","PayingAmount":10000,"TotalBeforeDiscount":419500,"ProductDiscount":120000,"CreatedBy":201567,"CreatedDate":"","InvoiceWarranties":[]}}}}    ${get_order_id}    ${BRANCH_ID}    ${get_id_nguoitao}    ${get_id_kh}    ${get_id_nguoiban}
    ...     ${order_code}     ${input_discount_order}    ${liststring_prs_order_detail_new}    ${liststring_prs_order_detail_promo}   ${get_gia_ban1}   ${get_id_order_detail1}    ${get_id_sp1}    ${input_soluong1}
    ...   ${get_id_order_detail2}   ${get_gia_ban2}    ${get_id_sp2}    ${input_soluong2}
    ...    ${get_id_sale_promo}    ${get_id_promotion}   ${item_id_sp_new}    ${list_id_sp_promo}    ${list_id_sp}   ${get_payment_id}    ${get_khachdatra_in_dh_bf_execute}    ${actual_khachtt}
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
    Should Be Equal As Numbers    ${get_giamgia_in_dh_af_execute}    ${input_discount_order}
    Should Be Equal As Numbers    ${get_tongcong_in_dh_af_execute}    ${result_khachcantra}
    #assert value product
    ${list_order_summary_af_execute}    Get list order summary by order code    ${order_code}
    : FOR    ${result_tong_dh}    ${order_summary_af_execute}    IN ZIP    ${list_result_order_summary_add}    ${list_order_summary_af_execute}
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
    Delete order frm Order code    ${order_code}
    Toggle status of promotion    ${input_khuyemmai}    0

eduhh02_api
    [Arguments]    ${dict_product_num}    ${input_discount_order}    ${input_ma_kh}    ${input_bh_khachtt}    ${input_khuyemmai}    ${dict_promo_product}
    ...    ${input_khtt_create_order}      ${dict_promo_product_add}
    [Timeout]
    ## Get info ton cuoi, cong no khach hang
    Toggle status of promotion    ${input_khuyemmai}    1
    ${order_code}    Add new order with promotion buy product and get other product free    ${input_ma_kh}    ${dict_product_num}    ${input_khuyemmai}    ${dict_promo_product}    ${input_khtt_create_order}
    ${num_sale_product}    ${num_promo_product}    ${product_price}    ${discount}    ${discount_ratio}    ${name}    Get Number of sale product - promo product - promo value and name
    ...    ${input_khuyemmai}
    ${list_promo_product_add}    Get Dictionary Keys    ${dict_promo_product_add}
    ${list_promo_num_add}    Get Dictionary Values    ${dict_promo_product_add}
    ${list_product}    Get Dictionary Keys    ${dict_product_num}
    ${list_nums}    Get Dictionary Values    ${dict_product_num}
    ${list_promo_product}    Get Dictionary Keys    ${dict_promo_product}
    ${list_promo_num}    Get Dictionary Values    ${dict_promo_product}
    Append To List    ${list_promo_num}     0
    ${get_khachdatra_in_dh_bf_execute}    ${get_tongtienhang_in_dh_bf_execute}    Get paid value frm API    ${order_code}
    ${get_list_ordersummary_bf_execute}    Get list order summary frm product API    ${list_product}
    ${get_list_ordersummary_bf_execute}    Convert String to List    ${get_list_ordersummary_bf_execute}
    ${get_list_ordersummary_bf_execute_promo_add}    Get list order summary frm product API    ${list_promo_product_add}
    :FOR    ${order_summary_add}    ${promo_num}    ${promo_num_add}    IN ZIP    ${get_list_ordersummary_bf_execute_promo_add}    ${list_promo_num}
    ...    ${list_promo_num_add}
    \    ${result_promo_num}    Run Keyword If    0 < ${promo_num_add} < ${promo_num}     Minus and replace floating point    ${promo_num}    ${promo_num_add}
    \    ...    ELSE IF    ${promo_num_add} > ${promo_num}    Minus and replace floating point    ${promo_num_add}    ${promo_num}    ELSE    Set Variable     ${promo_num_add}
    \    ${result_order_summary_promo}    Run Keyword If    0 < ${promo_num_add} < ${promo_num}     Minus and replace floating point    ${order_summary_add}    ${result_promo_num}
    \    ...    ELSE IF    ${promo_num_add} > ${promo_num}    Sum and replace floating point    ${order_summary_add}    ${result_promo_num}   ELSE    Set Variable     ${order_summary_add}
    \    Append to list    ${get_list_ordersummary_bf_execute}    ${result_order_summary_promo}
    Sort List    ${get_list_ordersummary_bf_execute}
    Log    ${get_list_ordersummary_bf_execute}
    #Compute
    ${result_khachcantra}   Minusx3 and replace foating point     ${get_tongtienhang_in_dh_bf_execute}    ${input_discount_order}    ${get_khachdatra_in_dh_bf_execute}
    ${actual_khachtt}    Set Variable If    '${input_bh_khachtt}' == 'all'    ${result_khachcantra}    ${input_bh_khachtt}
    ${result_khachdatra}    Sum    ${get_khachdatra_in_dh_bf_execute}    ${actual_khachtt}
    #create invoice
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${jsonpath_id_kh}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_kh}
    ${get_id_kh}    Get data from API    ${endpoint_khachhang}    ${jsonpath_id_kh}
    ${endpoint_danhmuc_hh_co_dvt}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${get_resp_danhmuc_hh}    Get Request and return body    ${endpoint_danhmuc_hh_co_dvt}
    ${get_id_sale_promo}    ${get_id_promotion}    ${get_promo_discount}    Get product promotion info    ${input_khuyemmai}
    ${get_order_id}   ${get_payment_id}   Get order - payment frm order api    ${order_code}
    ${get_list_order_detail_id}   Get list orderdetail id frm order api    ${order_code}    ${list_product}
    #get list gia ban, id san pham, discount of product
    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}    Get list jsonpath product frm list product    ${list_product}
    ${list_giaban}    ${list_id_sp}    Get product info frm list jsonpath product    ${get_resp_danhmuc_hh}    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}
    ${list_jsonpath_id_sp_promo}    ${list_jsonpath_giaban_promo}    Get list jsonpath product frm list product    ${list_promo_product_add}
    ${list_giaban_promo}    ${list_id_sp_promo}    Get product info frm list jsonpath product    ${get_resp_danhmuc_hh}    ${list_jsonpath_id_sp_promo}    ${list_jsonpath_giaban_promo}
    #list payload of product
    ${get_id_sp1}    Get From List    ${list_id_sp}    0
    ${get_id_sp2}    Get From List    ${list_id_sp}    1
    ${get_gia_ban1}    Get From List    ${list_giaban}    0
    ${get_gia_ban2}    Get From List    ${list_giaban}    1
    ${input_soluong1}    Get From List    ${list_nums}    0
    ${input_soluong2}    Get From List    ${list_nums}    1
    ${get_id_order_detail1}    Get From List    ${get_list_order_detail_id}    0
    ${get_id_order_detail2}    Get From List    ${get_list_order_detail_id}    1
    ## list payload of product promo
    ${liststring_prs_order_detail_promo}     Set Variable      needdel
    Log        ${liststring_prs_order_detail_promo}
    : FOR   ${item_gia_ban_promo}   ${item_id_sp_promo}   ${item_soluong_promo}      IN ZIP   ${list_giaban_promo}        ${list_id_sp_promo}    ${list_promo_num_add}
    \    ${payload_each_product_promo}        Format string       {{"BasePrice":{0},"Discount":{0},"IsLotSerialControl":false,"IsRewardPoint":false,"Note":"","Price":{0},"ProductCode":"HKM001","ProductId":{1},"ProductName":"Gói 6 Thanh Bánh Socola KitKat 2F 17g","PromotionParentProductId":{2},"PromotionParentType":1,"Quantity":{3},"SalePromotionId":{4},"Uuid":"","OriginPrice":{0},"ProductBatchExpireId":null}}   ${item_gia_ban_promo}   ${item_id_sp_promo}    ${get_id_sp1}           ${item_soluong_promo}   ${get_id_sale_promo}
    \    ${liststring_prs_order_detail_promo}       Catenate      SEPARATOR=,      ${liststring_prs_order_detail_promo}      ${payload_each_product_promo}
    ${liststring_prs_order_detail_promo}       Replace String      ${liststring_prs_order_detail_promo}       needdel,       ${EMPTY}      count=1
    ${list_id_sp_promo}   Convert list to string and return     ${list_id_sp_promo}
    ${id_sp1}     Get From List    ${list_id_sp}    0
    ${list_id_sp}   Convert list to string and return     ${list_id_sp}
    #post request
    ${request_payload}    Format String    {{"Order":{{"Id":{0},"BranchId":{1},"RetailerId":{2},"CustomerId":{3},"SoldById":{4},"SoldBy":{{"CreatedBy":0,"CreatedDate":"2018-07-30T08:27:36.800Z","GivenName":"anh.lv","Id":{4},"IsActive":true,"IsAdmin":true,"Type":0,"isDeleted":false,"Name":"anh.lv"}},"SaleChannelId":0,"SaleChannel":null,"Seller":{{"CreatedBy":0,"CreatedDate":"2018-07-30T08:27:36.800Z","GivenName":"anh.lv","Id":{4},"IsActive":true,"IsAdmin":true,"Type":0,"isDeleted":false,"Name":"anh.lv"}},"PurchaseDate":"","Code":"{5}","Discount":{6},"OrderDetails":[{{"BasePrice":{7},"Discount":0,"DiscountRatio":0,"Id":{8},"IsLotSerialControl":false,"IsMaster":true,"IsRewardPoint":false,"MaxQuantity":0,"Note":"","Price":{7},"ProductCode":"HH0034","ProductId":{9},"ProductName":"Trà sữa Royal tea mix Myanma","Quantity":{10},"Uuid":"","OriginPrice":{7},"ProductBatchExpireId":null}},{11},{{"BasePrice":{12},"Discount":0,"DiscountRatio":0,"Id":{13},"IsLotSerialControl":false,"IsMaster":true,"IsRewardPoint":false,"MaxQuantity":0,"Note":"","Price":{12},"ProductCode":"PROMO3","ProductId":{14},"ProductName":"Bánh Trứng Tik-Tok Bơ Sữa (120g)","Quantity":{15},"Uuid":"","OriginPrice":{12},"ProductBatchExpireId":null}}],"InvoiceOrderSurcharges":[],"OrderPromotions":[{{"Type":6,"TargetType":1,"SalePromotionId":{16},"PromotionId":{17},"ProductId":null,"RelatedProductId":{18},"RelatedProductQty":1,"ProductQty":2,"PromotionInfo":"KM theo HH hinh thuc mua hang tặng hàng: Khi mua 1 HH0034 - Trà sữa Royal tea mix Myanma, 1 PROMO3 - Bánh Trứng Tik-Tok Bơ Sữa (120g) tặng 1 HKM001 - Gói 6 Thanh Bánh Socola KitKat 2F 17g, 3 HKM002 - Kẹo Hồng Sâm Vitamin Daegoung Food","PrintPromotionInfo":"Mua 1 Trà sữa Royal tea mix Myanma, 1 Bánh Trứng Tik-Tok Bơ Sữa (120g) tặng 1 Gói 6 Thanh Bánh Socola KitKat 2F 17g, 3 Kẹo Hồng Sâm Vitamin Daegoung Food","ProductIds":"{19}","RelatedProductIds":"{20}","RelatedCategoryIds":"","BackupSelectedSerials":{{}}}}],"Payments":[{{"OrderValue":0,"DocumentValue":0,"PaidValue":0,"NeedPayValue":0,"CustomerName":"","CustomerCode":"","InvoiceCode":"","CustomerDebt":0,"CustomerOldDebt":0,"TargetCode":"","UserName":"","VoucherCampaignId":0,"Version":0,"IsUpdate":false,"TransGuid":"00000000000000000000000000000000","DocumentTypeValue":0,"Id":{21},"Code":"TTDH002464","Amount":{22},"AmountOriginal":0,"Method":"Cash","CreatedDate":"","CreatedBy":{4},"RetailerId":{2},"BranchId":{1},"OrderId":{0},"CustomerId":{3},"TransDate":"","UserId":{4},"Status":0,"System":false,"DeliveryPayments":[],"PaymentAllocation":[]}},{{"Method":"Cash","MethodStr":"Tiền mặt","Amount":{23},"Id":-2}}],"UsingCod":0,"Status":1,"Total":17000,"Extra":"{{\\"Amount\\":5000,\\"Method\\":{{\\"Id\\":\\"Cash\\",\\"Label\\":\\"Tiền mặt\\"}},\\"activeCustomerGroupId\\":null,\\"ResetPromotion\\":true}}","Surcharge":0,"Type":2,"Uuid":"","addToAccount":"0","PayingAmount":5000,"TotalBeforeDiscount":156000,"ProductDiscount":137000,"CreatedBy":{4},"CreatedDate":"","InvoiceWarranties":[]}}}}    ${get_order_id}    ${BRANCH_ID}    ${get_id_nguoitao}    ${get_id_kh}    ${get_id_nguoiban}
    ...     ${order_code}     ${input_discount_order}   ${get_gia_ban1}   ${get_id_order_detail1}    ${get_id_sp1}    ${input_soluong1}
    ...    ${liststring_prs_order_detail_promo}   ${get_gia_ban2}   ${get_id_order_detail2}    ${get_id_sp2}    ${input_soluong2}
    ...    ${get_id_sale_promo}    ${get_id_promotion}    ${id_sp1}    ${list_id_sp_promo}   ${list_id_sp}   ${get_payment_id}
    ...   ${get_khachdatra_in_dh_bf_execute}    ${actual_khachtt}
    Log    ${request_payload}
    ${order_code}    Post request to create order and return code    ${request_payload}
    #get values
    Sleep    20 s    wait for response to API
    #assert values in order
    ${get_ma_kh_in_dh_af_execute}    ${get_TTDH_in_dh_af_execute}    ${get_tongtienhang_in_dh_af_exxecute}    ${get_khachdatra_in_dh_af_execute}    ${get_giamgia_in_dh_af_execute}    ${get_tongcong_in_dh_af_execute}    ${get_ghichu_in_dh_af_execute}
    ...    Get order info incase discount by order code    ${order_code}
    Should Be Equal As Strings    ${get_ma_kh_in_dh_af_execute}    ${get_ma_kh_in_dh_af_execute}
    Should Be Equal As Numbers    ${get_TTDH_in_dh_af_execute}    1    #1 : phiếu tạm
    Should Be Equal As Numbers    ${get_tongtienhang_in_dh_af_exxecute}    ${get_tongtienhang_in_dh_bf_execute}
    Should Be Equal As Numbers    ${get_khachdatra_in_dh_af_execute}    ${result_khachdatra}
    Should Be Equal As Numbers    ${get_giamgia_in_dh_af_execute}    ${input_discount_order}
    Should Be Equal As Numbers    ${get_tongcong_in_dh_af_execute}    ${result_khachdatra}
    #assert value product
    ${list_order_summary_af_execute}    Get list order summary by order code    ${order_code}
    ${list_order_summary_af_execute}    Convert String to List    ${list_order_summary_af_execute}
    Sort List    ${list_order_summary_af_execute}
    Log    ${list_order_summary_af_execute}
    : FOR    ${result_tong_dh}    ${order_summary_af_execute}    IN ZIP    ${get_list_ordersummary_bf_execute}    ${list_order_summary_af_execute}
    \    Should Be Equal As Numbers    ${order_summary_af_execute}    ${result_tong_dh}
    Delete order frm Order code    ${order_code}
    Toggle status of promotion    ${input_khuyemmai}    0

eduhh03_api
    [Arguments]    ${dict_product_num}    ${input_discount_order}    ${input_ma_kh}    ${input_bh_khachtt}    ${input_khuyemmai}    ${input_khtt_create_order}
    ...    ${list_soluong_new}    ${list_ggsp}
    ## Get info ton cuoi, cong no khach hang
    Toggle status of promotion    ${input_khuyemmai}    1
    ${order_code}    Add new order with promotion buy every items at a fixed reduced price    ${input_ma_kh}    ${dict_product_num}    ${input_khuyemmai}    ${input_khtt_create_order}
    ${num_sale_product}    ${num_promo_product}    ${product_price}    ${discount}    ${discount_ratio}    ${name}    Get Number of sale product - promo product - promo value and name
    ...    ${input_khuyemmai}
    ${list_product}    Get Dictionary Keys    ${dict_product_num}
    ${list_nums}    Get Dictionary Values    ${dict_product_num}
    ${get_khachdatra_in_dh_bf_execute}    ${get_tongtienhang_in_dh_bf_execute}    Get paid value frm API    ${order_code}
    ${get_list_ordersummary_bf_execute}    Get list order summary frm product API    ${list_product}
    ${total_sale_number}    Sum values in list    ${list_soluong_new}
    ${list_result_totalsale}    ${list_result_onhand_af_ex}    Run Keyword If    ${discount} != 0 and ${discount_ratio} ==0    Get list of total sale - result onhand in case discount product    ${list_product}    ${list_soluong_new}
    ...    ${discount}
    ...    ELSE IF    ${discount} == 0 and ${discount_ratio} != 0    Get list of total sale - result onhand in case discount product    ${list_product}    ${list_soluong_new}    ${discount_ratio}
    ...    ELSE IF    ${total_sale_number} < ${num_sale_product}    Get list of total sale - result onhand with one discount    ${list_product}    ${list_soluong_new}
    ...    ELSE    Get list of total sale - result onhand in case promotion    ${list_product}    ${list_soluong_new}    ${product_price}    ${num_sale_product}
    ${list_result_order_summary}      Create List
    : FOR    ${order_summary}    ${quantity}    ${quantity_add}    IN ZIP    ${get_list_ordersummary_bf_execute}    ${list_nums}
    ...    ${list_soluong_new}
    \    ${result_quantity}    Run Keyword If    0 < ${quantity_add} < ${quantity}    Minus and replace floating point    ${quantity}    ${quantity_add}
    \    ...    ELSE    Minus and replace floating point    ${quantity_add}    ${quantity}
    \    ${result_ordersummary}    Run Keyword If    0 < ${quantity_add} < ${quantity}    Minus and replace floating point    ${order_summary}    ${result_quantity}
    \    ...    ELSE    Sum and replace floating point    ${order_summary}    ${result_quantity}
    \    Append To List    ${list_result_order_summary}    ${result_ordersummary}
    Log    ${list_result_order_summary}
    #Compute
    ${result_tongtienhang}    Sum values in list    ${list_result_totalsale}
    ${result_ggdh}    Convert % discount to VND and round    ${result_tongtienhang}    ${input_discount_order}
    ${result_khachcantra}    Minusx3 and replace foating point    ${result_tongtienhang}    ${result_ggdh}    ${get_khachdatra_in_dh_bf_execute}
    ${actual_khachtt}    Set Variable If    '${input_bh_khachtt}' == 'all'    ${result_khachcantra}    ${input_bh_khachtt}
    ${result_khachdatra}    Sum    ${get_khachdatra_in_dh_bf_execute}    ${actual_khachtt}
    ${result_tongcong}     Sum    ${result_khachcantra}    ${result_khachdatra}
    #create invoice
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${jsonpath_id_kh}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_kh}
    ${get_id_kh}    Get data from API    ${endpoint_khachhang}    ${jsonpath_id_kh}
    ${endpoint_danhmuc_hh_co_dvt}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${get_resp_danhmuc_hh}    Get Request and return body    ${endpoint_danhmuc_hh_co_dvt}
    ${get_id_sale_promo}    ${get_id_promotion}    ${get_promo_discount}    Get product promotion info    ${input_khuyemmai}
    ${get_order_id}   ${get_payment_id}   Get order - payment frm order api    ${order_code}
    ${get_list_order_detail_id}   Get list orderdetail id frm order api    ${order_code}    ${list_product}
    #get list gia ban, id san pham, discount of product
    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}    Get list jsonpath product frm list product    ${list_product}
    ${list_giaban}    ${list_id_sp}    Get product info frm list jsonpath product    ${get_resp_danhmuc_hh}    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}
    #list payload of product new
    ${liststring_prs_order_detail}     Set Variable      needdel
    Log        ${liststring_prs_order_detail}
    : FOR   ${item_gia_ban}   ${item_id_sp}   ${item_soluong}   ${item_id_orderdetail}      IN ZIP   ${list_giaban}        ${list_id_sp}    ${list_soluong_new}    ${get_list_order_detail_id}
    \    ${result_ggsp}   Convert % discount to VND   ${item_gia_ban}    ${get_promo_discount}
    \    ${payload_each_product}        Format string       {{"BasePrice":299000,"Discount":{0},"DiscountRatio":{1},"Id":{2},"IsLotSerialControl":true,"IsRewardPoint":false,"MaxQuantity":0,"Note":"","Price":{3},"ProductCode":"SI027","ProductId":{4},"ProductName":"Bàn Ủi Khô Philips HD1172","PromotionParentProductId":{4},"PromotionParentType":1,"Quantity":{5},"SalePromotionId":{6},"Uuid":"","ProductBatchExpireId":null}}    ${result_ggsp}   ${get_promo_discount}   ${item_id_orderdetail}   ${item_gia_ban}   ${item_id_sp}   ${item_soluong}    ${get_id_sale_promo}
    \    ${liststring_prs_order_detail}       Catenate      SEPARATOR=,      ${liststring_prs_order_detail}      ${payload_each_product}
    ${liststring_prs_order_detail}       Replace String      ${liststring_prs_order_detail}       needdel,       ${EMPTY}      count=1
    ${id_sp1}  Get From List     ${list_id_sp}    0
    ${list_id_sp}   Convert list to string and return    ${list_id_sp}
    #post request
    ${request_payload}    Format String    {{"Order":{{"Id":{0},"BranchId":{1},"RetailerId":{2},"CustomerId":{3},"SoldById":{4},"SoldBy":{{"CreatedBy":0,"CreatedDate":"2018-12-10T08:33:32.447Z","GivenName":"admin","Id":{4},"IsActive":true,"IsAdmin":true,"Type":0,"isDeleted":false,"Name":"admin"}},"SaleChannelId":0,"SaleChannel":null,"Seller":{{"CreatedBy":0,"CreatedDate":"2018-12-10T08:33:32.447Z","GivenName":"admin","Id":{4},"IsActive":true,"IsAdmin":true,"Type":0,"isDeleted":false,"Name":"admin"}},"PurchaseDate":"","Code":"{{5}}","Discount":{6},"DiscountRatio":{7},"OrderDetails":[{8}],"InvoiceOrderSurcharges":[],"OrderPromotions":[{{"Type":8,"TargetType":1,"SalePromotionId":{9},"PromotionId":{10},"ProductId":{11},"ProductPrice":20,"ProductQty":2,"RelatedProductId":{11},"PromotionInfo":"KM theo HH hình thức giá bán theo SL mua GG %: Khi mua 5 DVL010 - Dịch vụ 10 giảm giá 20%","PrintPromotionInfo":"Mua từ 5 Dịch vụ 10 được giảm giá 20.00% mỗi sản phẩm","RelatedProductIds":"{12}","RelatedCategoryIds":"1147661","PromotionApplicationType":"%"}}],"Payments":[{{"OrderValue":0,"DocumentValue":0,"PaidValue":0,"NeedPayValue":0,"CustomerName":"","CustomerCode":"","InvoiceCode":"","CustomerDebt":0,"CustomerOldDebt":0,"TargetCode":"","UserName":"","VoucherCampaignId":0,"Version":0,"IsUpdate":false,"TransGuid":"00000000000000000000000000000000","DocumentTypeValue":0,"Id":{13},"Code":"TTDH000556","Amount":{14},"AmountOriginal":0,"Method":"Cash","CreatedDate":"","CreatedBy":{4},"RetailerId":{2},"BranchId":{1},"OrderId":{0},"CustomerId":{3},"TransDate":"","UserId":{4},"Status":0,"System":false,"DeliveryPayments":[],"PaymentAllocation":[]}}],"UsingCod":0,"Status":1,"Total":1052000,"Extra":"{{\\"Amount\\":0,\\"Method\\":{{\\"Id\\":\\"Cash\\",\\"Label\\":\\"Tiền mặt\\"}},\\"activeCustomerGroupId\\":null,\\"ResetPromotion\\":false}}","Surcharge":0,"Type":2,"Uuid":"","addToAccount":"0","PayingAmount":0,"TotalBeforeDiscount":1315000,"ProductDiscount":263000,"CreatedBy":441968,"CreatedDate":"","InvoiceWarranties":[]}}}}    ${get_order_id}    ${BRANCH_ID}    ${get_id_nguoitao}    ${get_id_kh}    ${get_id_nguoiban}
    ...     ${order_code}    ${result_ggdh}     ${input_discount_order}    ${liststring_prs_order_detail}
    ...    ${get_id_sale_promo}    ${get_id_promotion}    ${id_sp1}    ${list_id_sp}   ${get_payment_id}    ${get_khachdatra_in_dh_bf_execute}
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
    Should Be Equal As Numbers    ${get_giamgia_in_dh_af_execute}    ${result_ggdh}
    Should Be Equal As Numbers    ${get_tongcong_in_dh_af_execute}    ${result_tongcong}
    #assert value product
    ${list_order_summary_af_execute}    Get list order summary by order code    ${order_code}
    : FOR    ${result_tong_dh}    ${order_summary_af_execute}    IN ZIP    ${list_result_order_summary}    ${list_order_summary_af_execute}
    \    Should Be Equal As Numbers    ${order_summary_af_execute}    ${result_tong_dh}
    Delete order frm Order code    ${order_code}
    Toggle status of promotion    ${input_khuyemmai}    0
