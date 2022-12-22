*** Settings ***
Suite Setup       Init Test Environment   ${env}    ${remote}    tester      ${headless_browser}
Resource          ../../../../../core/API/api_thietlap.robot
Resource          ../../../../../core/API/api_dathang.robot
Resource          ../../../../../core/Ban_Hang/banhang_getandcompute.robot
Resource          ../../../../../core/Ban_Hang/banhang_page.robot
Resource          ../../../../../core/share/toast_message.robot
Resource          ../../../../../core/API/api_mhbh_dathang.robot
Resource          ../../../../../core/API/api_soquy.robot
Resource          ../../../../../core/API/api_danhmuc_hanghoa.robot
Resource          ../../../../../config/env_product/envi.robot

*** Variables ***
&{list_product_nums4}    DVTKM01=3
&{list_product_nums5}    DVTKM03=6
&{list_give1}    SIKM03=1
@{list_quantity}    5
&{list_give2}    HTKM03=1
@{list_discount}    1000000
@{discount_type}   changeup

*** Test Cases ***    Product and num list    Customer    Payment    Promotion Code       Payment to create   Quantity new      User name
KM HH giam gia SP theo user
                      [Tags]                   AEDPVKM
                      [Template]               akmpv3
                      ${list_product_nums4}    CTKH071       all      KM019                20000             ${list_quantity}    tester

KM HH va HD hinh thuc giam gia SP khong all filter
                      [Tags]                   AEDPVKM
                      [Template]               akmpv4
                      ${list_product_nums5}    20          CTKH072       0        KM021      ${list_give2}        ${list_discount}     ${discount_type}    200000    Nhánh A     tester       Nhóm khách VIP

*** Keywords ***
akmpv3
    [Arguments]    ${dict_product_num}    ${input_ma_kh}    ${input_bh_khachtt}    ${input_khuyenmai}    ${input_khtt_create_order}
    ...    ${list_quantity}    ${input_username}
    [Timeout]
    ## Get info ton cuoi, cong no khach hang
    Toggle status of promotion and not for all user   ${input_khuyenmai}    1    ${input_username}    KM hàng
    ${order_code}    Add new order with promotion buy every items at a fixed reduced price    ${input_ma_kh}    ${dict_product_num}    ${input_khuyenmai}    ${input_khtt_create_order}
    ${num_sale_product}    ${num_promo_product}    ${product_price}    ${discount}    ${discount_ratio}    ${name}    Get Number of sale product - promo product - promo value and name
    ...    ${input_khuyenmai}
    ${list_product}    Get Dictionary Keys    ${dict_product_num}
    ${list_nums}    Get Dictionary Values    ${dict_product_num}
    ${get_no_bf_execute}    ${get_tongban_bf_execute}    ${get_tongban_tru_trahang_bf_execute}    ${get_customer_name}    Get Customer Info from API    ${input_ma_kh}
    ${get_khachdatra_in_dh_bf_execute}    ${get_tongtienhang_in_dh_bf_execute}    Get paid value frm API    ${order_code}
    ${get_list_hh_in_dh_bf_execute}    ${get_ghichu_bf_execute}    Get ghi chu and list product frm API    ${order_code}
    ${list_result_thanhtien}    Create List
    ${list_result_order_summary}    Create List
    ${list_thanhtien}    ${list_soluong_in_dh}    ${list_order_summary}    ${list_onhand}    Get list quantity - sub total - order summary - ending stock frm API    ${order_code}    ${list_product}
    : FOR    ${get_soluong_in_dh}    ${input_soluong}    ${get_tongso_dh_bf_execute}    IN ZIP    ${list_soluong_in_dh}    ${list_quantity}    ${list_order_summary}
    \    ${result_soluong_giam}    Minus    ${get_soluong_in_dh}    ${input_soluong}
    \    ${result_soluong_tang}    Minus    ${input_soluong}    ${get_soluong_in_dh}
    \    ${result_soluong}    Set Variable If    ${input_soluong}>${get_soluong_in_dh}    ${result_soluong_tang}    ${result_soluong_giam}
    \    ${result_tongdh_tang}    Sum    ${get_tongso_dh_bf_execute}    ${result_soluong}
    \    ${result_tongdh_giam}    Minus    ${get_tongso_dh_bf_execute}    ${result_soluong}
    \    ${result_tongdh}    Set Variable If    ${input_soluong}>${get_soluong_in_dh}    ${result_tongdh_tang}    ${result_tongdh_giam}
    \    ${result_thanhtien_ggsp}    Multiplication and round    ${product_price}    ${input_soluong}
    \    Append To List    ${list_result_thanhtien}    ${result_thanhtien_ggsp}
    \    Append To List    ${list_result_order_summary}    ${result_tongdh}
    #Compute
    ${result_tongtienhang}    Sum values in list    ${list_result_thanhtien}
    ${result_khachcantra}   Minus And Replace Floating Point    ${result_tongtienhang}     ${get_khachdatra_in_dh_bf_execute}
    ${actual_khachtt}    Set Variable If    '${input_bh_khachtt}' == 'all'    ${result_khachcantra}    ${input_bh_khachtt}
    ${result_nohientai}    Minus    ${get_no_bf_execute}    ${actual_khachtt}
    #create invoice
    ${get_order_id}   ${get_payment_id}   Get order - payment frm order api    ${order_code}
    ${get_list_order_detail_id}   Get list orderdetail id frm order api    ${order_code}    ${list_product}
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${jsonpath_id_kh}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_kh}
    ${get_id_sale_promo}    ${get_id_promotion}    ${get_promo_discount}    Get promotion info    ${input_khuyenmai}
    ${get_id_kh}    Get data from API    ${endpoint_khachhang}    ${jsonpath_id_kh}
    ${endpoint_danhmuc_hh_co_dvt}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${get_resp_danhmuc_hh}    Get Request and return body    ${endpoint_danhmuc_hh_co_dvt}
    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}    Get list jsonpath product frm list product    ${list_product}
    ${list_giaban}    ${list_id_sp}    Get product info frm list jsonpath product    ${get_resp_danhmuc_hh}    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}
    ${liststring_prs_order_detail}     Set Variable      needdel
    Log        ${liststring_prs_order_detail}
    : FOR    ${item_orderdetail_id}    ${item_gia_ban}   ${item_id_sp}   ${item_soluong}      IN ZIP    ${get_list_order_detail_id}   ${list_giaban}
    ...      ${list_id_sp}    ${list_quantity}
    \    ${discount}    Minus    ${item_gia_ban}    ${product_price}
    \    ${payload_each_product}        Format string       {{"BasePrice":{0},"Discount":{1},"Id":{2},"IsLotSerialControl":false,"IsRewardPoint":false,"MaxQuantity":0,"Note":"","Price":{0},"ProductCode":"DVTKM01","ProductId":{3},"ProductName":"Hàng ĐVT khuyen mai 01 - (chiếc)","PromotionParentProductId":{3},"PromotionParentType":1,"Quantity":{4},"SalePromotionId":{5},"Uuid":"","OriginPrice":{0},"ProductBatchExpireId":null}}    ${item_gia_ban}    ${discount}      ${item_orderdetail_id}   ${item_id_sp}   ${item_soluong}    ${get_id_sale_promo}
    \    ${liststring_prs_order_detail}       Catenate      SEPARATOR=,      ${liststring_prs_order_detail}      ${payload_each_product}
    ${liststring_prs_order_detail}       Replace String      ${liststring_prs_order_detail}       needdel,       ${EMPTY}      count=1
    ${request_payload}    Format String    {{"Order":{{"Id":{0},"BranchId":{1},"RetailerId":{2},"CustomerId":{3},"SoldById":{4},"SoldBy":{{"CreatedBy":160324,"CreatedDate":"2020-01-13T03:46:19.093Z","GivenName":"tester","Id":{4},"IsActive":true,"IsAdmin":false,"Type":0,"isDeleted":false,"Name":"tester"}},"SaleChannelId":0,"SaleChannel":null,"Seller":{{"CreatedBy":160324,"CreatedDate":"2020-01-13T03:46:19.093Z","GivenName":"tester","Id":{4},"IsActive":true,"IsAdmin":false,"Type":0,"isDeleted":false,"Name":"tester"}},"PurchaseDate":"","Code":"{5}","Discount":0,"OrderDetails":[{6}],"InvoiceOrderSurcharges":[],"OrderPromotions":[{{"Type":8,"TargetType":1,"SalePromotionId":{7},"PromotionId":{8},"ProductId":{9},"ProductPrice":50000,"ProductQty":5,"RelatedProductId":{9},"PromotionInfo":"KM theo HH hình thức giá bán theo SL mua theo user: Khi mua 5 DVTKM01 - Hàng ĐVT khuyen mai 01 - (chiếc) giá 50,000","PrintPromotionInfo":"Mua từ 5 chiếc Hàng ĐVT khuyen mai 01 giá 50,000","RelatedProductIds":"{9}","RelatedCategoryIds":"584740","PromotionApplicationType":""}}],"Payments":[{{"IdOld":0,"OrderValue":0,"DocumentValue":0,"PaidValue":0,"NeedPayValue":0,"CustomerName":"","CustomerCode":"","InvoiceCode":"","CustomerDebt":0,"CustomerOldDebt":0,"TargetCode":"","UserName":"","VoucherCampaignId":0,"Version":0,"IsUpdate":false,"TransGuid":"00000000000000000000000000000000","DocumentTypeValue":0,"Id":{10},"Code":"TTDH001253","Amount":{11},"AmountOriginal":0,"Method":"Cash","CreatedDate":"","CreatedBy":{4},"RetailerId":{2},"BranchId":{1},"OrderId":{0},"CustomerId":{3},"TransDate":"","UserId":{4},"Status":0,"System":false,"DeliveryPayments":[],"PaymentAllocation":[]}},{{"Method":"Cash","MethodStr":"Tiền mặt","Amount":{12},"Id":-2}}],"UsingCod":0,"Status":1,"Total":{13},"Extra":"{{\\"Amount\\":230000,\\"Method\\":{{\\"Id\\":\\"Cash\\",\\"Label\\":\\"Tiền mặt\\"}},\\"activeCustomerGroupId\\":null,\\"ResetPromotion\\":false}}","Surcharge":0,"Type":2,"Uuid":"","addToAccount":"0","PayingAmount":{12},"TotalBeforeDiscount":{13},"ProductDiscount":150000,"CreatedBy":{4},"CreatedDate":"","InvoiceWarranties":[]}}}}     ${get_order_id}   ${BRANCH_ID}    ${get_id_nguoitao}    ${get_id_kh}    ${get_id_nguoiban}
    ...    ${order_code}   ${liststring_prs_order_detail}    ${get_id_sale_promo}    ${get_id_promotion}   ${item_id_sp}   ${get_payment_id}
    ...   ${get_khachdatra_in_dh_bf_execute}   ${actual_khachtt}     ${result_tongtienhang}
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
    Should Be Equal As Numbers    ${get_khachdatra_in_dh_af_execute}    ${result_tongtienhang}
    Should Be Equal As Numbers    ${get_giamgia_in_dh_af_execute}    0
    Should Be Equal As Numbers    ${get_tongcong_in_dh_af_execute}    ${result_tongtienhang}
    #assert value product
    ${list_order_summary_af_execute}    Get list order summary by order code    ${order_code}
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
    Delete order frm Order code    ${order_code}
    Toggle status of promotion and not for all user   ${input_khuyenmai}    0    ${input_username}    KM hàng

akmpv4
    [Arguments]    ${dict_product_nums_tocreate}  ${input_gghd}    ${input_ma_kh}    ${input_khtt}   ${input_khuyenmai}    ${list_promo_product}
    ...   ${list_ggsp}   ${list_discount_type}    ${input_khtt_tocreate}    ${input_ten_branch}    ${input_ten_user}    ${input_ten_group_kh}
    Set Selenium Speed    0.5s
    Toggle status of promotion and not for all filter   ${input_khuyenmai}    1    ${input_ten_branch}    ${input_ten_user}    ${input_ten_group_kh}    KM Hàng mua     KM Hàng tặng
    ${invoice_value}    ${received_value}    ${discount}    ${discount_ratio}    ${name}    Get Invoice value - Received value - Discounts - Promotion Name from Promotion Code    ${input_khuyenmai}
    ${order_code}    Add new order incase discount - payment with other branch    ${input_ma_kh}    0    ${dict_product_nums_tocreate}    ${list_ggsp}
    ...   ${list_discount_type}    ${input_khtt_tocreate}    ${input_ten_branch}
    #get info product, customer
    ${list_product_promo}    Get Dictionary Keys    ${list_promo_product}
    ${list_nums_promo}    Get Dictionary Values    ${list_promo_product}
    ${get_khachdatra_in_dh_bf_execute}    ${get_tongtienhang_in_dh_bf_execute}    Get paid value frm API    ${order_code}
    ${get_list_hh_in_dh_bf_execute}    ${get_list_nums_in_dh}    Get list product and quantity frm API    ${order_code}
    ##get value
    ${list_result_tongdh}    Create List
    ${result_list_toncuoi}    Create List
    ${result_list_thanhtien}    Create List
    ${list_giatri_quydoi}    Get list gia tri quy doi frm product API    ${get_list_hh_in_dh_bf_execute}
    ${get_list_product_type}    ${list_tonkho_service}    Get list product type and ending stock of service with other branch    ${get_list_hh_in_dh_bf_execute}    ${input_ten_branch}
    ${get_list_baseprice}    ${list_order_summary}    Get list of baseprice and order summary by product code and branch id    ${get_list_hh_in_dh_bf_execute}    ${input_ten_branch}
    ${list_onhand}    Get list onhand with other branch    ${get_list_hh_in_dh_bf_execute}    ${input_ten_branch}
    : FOR    ${item_product}    ${get_soluong_in_dh}    ${get_tongso_dh_bf_execute}    ${get_ton_bf_execute}    ${get_toncuoi_dv_execute}    ${giatri_quydoi}
    ...    ${get_product_type}    ${get_giaban_bf_execute}    ${input_ggsp}   ${discount_type}    IN ZIP    ${get_list_hh_in_dh_bf_execute}    ${get_list_nums_in_dh}
    ...    ${list_order_summary}    ${list_onhand}    ${list_tonkho_service}    ${list_giatri_quydoi}    ${get_list_product_type}    ${get_list_baseprice}    ${list_ggsp}    ${list_discount_type}
    \    ${result_tongdh}    Minus and round 2    ${get_tongso_dh_bf_execute}    ${get_soluong_in_dh}
    \    ${result_toncuoi}    Run Keyword If    '${giatri_quydoi}' == '1'    Computation and get list ending stock    ${get_ton_bf_execute}    ${get_toncuoi_dv_execute}
    \    ...    ${get_soluong_in_dh}    ${get_product_type}
    \    ...    ELSE    Computation and get list ending stock for unit product    ${item_product}    ${giatri_quydoi}    ${get_soluong_in_dh}
    \    ${ressult_giamoi}    Run Keyword If    '${discount_type}' == 'dis'    Price after % discount product    ${get_giaban_bf_execute}    ${input_ggsp}
    \    ...    ELSE IF    '${discount_type}' == 'disvnd'    Minus and round 2    ${get_giaban_bf_execute}    ${input_ggsp}
    \    ...    ELSE IF    '${discount_type}' == 'changeup' or '${discount_type}' == 'changedown'   Set Variable   ${input_ggsp}
    \    ...     ELSE    Set Variable    ${get_giaban_bf_execute}
    \    ${result_thanhtien}    Multiplication and round    ${ressult_giamoi}    ${get_soluong_in_dh}
    \    Append To List    ${list_result_tongdh}    ${result_tongdh}
    \    Append To List    ${result_list_toncuoi}    ${result_toncuoi}
    \    Append To List    ${result_list_thanhtien}    ${result_thanhtien}
    #compute product promo
    ${get_list_baseprice_promo}   Get list of Baseprice by Product Code    ${list_product_promo}
    ${list_onhand_promo}    Get list onhand with other branch    ${list_product_promo}    ${input_ten_branch}
    ${result_thanhtien_promo}   Create List
    ${list_result_toncuoi_promo}   Create List
    :FOR    ${item_giaban}    ${item_nums}   ${item_onhand}   IN ZIP    ${get_list_baseprice_promo}    ${list_nums_promo}    ${list_onhand_promo}
    \     ${giaban}   Minus     ${item_giaban}    ${discount}
    \     ${thanhtien}    Multiplication and round     ${giaban}    ${item_nums}
    \     ${result_tonkho}    Minus   ${item_onhand}    ${item_nums}
    \     Append To List     ${result_thanhtien_promo}     ${thanhtien}
    \     Append To List     ${list_result_toncuoi_promo}     ${result_tonkho}
    #compute TTH with product
    ${result_tongtienhang}    Sum values in list    ${result_list_thanhtien}
    ${result_tongtienhang_promo}    Sum values in list    ${result_thanhtien_promo}
    ${result_tongtienhang}    Sum    ${result_tongtienhang}    ${result_tongtienhang_promo}
    ${result_gghd}    Run Keyword If    0 < ${input_gghd} < 100    Convert % discount to VND and round    ${result_tongtienhang}    ${input_gghd}
    ...    ELSE    Set Variable    ${input_gghd}
    ${result_TTH_tru_gghd}    Run Keyword If    0 < ${input_gghd} < 100    Price after % discount invoice    ${result_tongtienhang}    ${input_gghd}
    ...    ELSE    Minus and replace floating point    ${result_tongtienhang}    ${input_gghd}
    ${result_khachcantra}    Minus and replace floating point    ${result_TTH_tru_gghd}    ${get_khachdatra_in_dh_bf_execute}
    ${actual_khtt}    Set Variable If    '${input_khtt}' == 'all'    ${result_khachcantra}    ${input_khtt}
    ${result_khachdatra_in_dh}    Sum    ${get_khachdatra_in_dh_bf_execute}    ${actual_khtt}
    #create invoice from order
    ${get_id_branch}    Get BranchID by BranchName    ${input_ten_branch}
    ${get_order_id}   ${get_payment_id}   Get order - payment frm order api    ${order_code}
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${get_id_sale_promo}    ${get_id_promotion}    ${get_promo_discount}    Get promotion info    ${input_khuyenmai}
    ${jsonpath_id_kh}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_kh}
    ${get_id_kh}    Get data from API    ${endpoint_khachhang}    ${jsonpath_id_kh}
    ${endpoint_danhmuc_hh_co_dvt}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${get_resp_danhmuc_hh}    Get Request and return body    ${endpoint_danhmuc_hh_co_dvt}
    ${get_list_order_detail_id}   Get list orderdetail id frm order api    ${order_code}    ${get_list_hh_in_dh_bf_execute}
    #list payload of product
    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}    Get list jsonpath product frm list product    ${get_list_hh_in_dh_bf_execute}
    ${list_giaban}    ${list_result_ggsp}    ${list_id_sp}    Get product info frm list jsonpath product incase discount product    ${get_resp_danhmuc_hh}
    ...    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}    ${list_discount}    ${list_discount_type}
    ${liststring_prs_order_detail}     Set Variable      needdel
    Log        ${liststring_prs_order_detail}
    : FOR   ${item_gia_ban}   ${item_id_sp}   ${item_soluong}   ${get_orderdetail_id}   ${item_result_ggsp}      IN ZIP    ${list_giaban}
    ...   ${list_id_sp}    ${get_list_nums_in_dh}   ${get_list_order_detail_id}    ${list_result_ggsp}
    \    ${payload_each_product}        Format string       {{"BasePrice":{0},"IsLotSerialControl":false,"IsRewardPoint":false,"Note":"","Price":{0},"ProductId":{1},"Quantity":{2},"ProductCode":"DVTKM03","Discount":{3},"DiscountRatio":0,"ProductName":"Hàng ĐVT khuyen mai 03 - (chiếc)","SalePromotionId":null,"OriginPrice":{0},"PriceByPromotion":null,"IsMaster":true,"PromotionParentProductId":null,"ProductBatchExpireId":null,"CategoryId":601457,"MasterProductId":{1},"Unit":"chiếc","Uuid":"","OrderDetailId":{4},"ProductWarranty":[]}}   ${item_gia_ban}   ${item_id_sp}   ${item_soluong}   ${item_result_ggsp}
    \    ...    ${get_orderdetail_id}
    \    ${liststring_prs_order_detail}       Catenate      SEPARATOR=,      ${liststring_prs_order_detail}      ${payload_each_product}
    ${liststring_prs_order_detail}       Replace String      ${liststring_prs_order_detail}       needdel,       ${EMPTY}      count=1
    #list payload of product promo
    ${list_jsonpath_id_sp_promo}    ${list_jsonpath_giaban_promo}    Get list jsonpath product frm list product    ${list_product_promo}
    ${list_giaban_promo}    ${list_id_sp_promo}    Get product info frm list jsonpath product    ${get_resp_danhmuc_hh}    ${list_jsonpath_id_sp_promo}    ${list_jsonpath_giaban_promo}
    ${liststring_prs_order_detail_promo}     Set Variable      needdel
    Log        ${liststring_prs_order_detail_promo}
    : FOR   ${item_gia_ban_promo}   ${item_id_sp_promo}   ${item_soluong_promo}    IN ZIP   ${list_giaban_promo}    ${list_id_sp_promo}    ${list_nums_promo}
    \    ${payload_each_product_promo}        Format string       {{"BasePrice":{0},"IsLotSerialControl":false,"IsRewardPoint":false,"Note":"","Price":{0},"ProductId":{1},"Quantity":{2},"ProductCode":"HTKM03","Discount":{3},"ProductName":"Hàng KM theo phạm vi 3","SalePromotionId":{4},"OriginPrice":520000,"ProductBatchExpireId":null,"CategoryId":601458,"MasterProductId":{1},"Unit":"","Uuid":"","ProductWarranty":[]}}   ${item_gia_ban_promo}   ${item_id_sp_promo}   ${item_soluong_promo}   ${discount}    ${get_id_sale_promo}
    \    ${liststring_prs_order_detail_promo}       Catenate      SEPARATOR=,      ${liststring_prs_order_detail_promo}      ${payload_each_product_promo}
    ${liststring_prs_order_detail_promo}       Replace String      ${liststring_prs_order_detail_promo}       needdel,       ${EMPTY}      count=1
    ${get_id_sp_promo}    Get From List    ${list_id_sp_promo}    0
    ${list_id_sp_promo}   Convert list to string and return     ${list_id_sp_promo}
    ##post request
    ${giamgia_hd}    Set Variable If    0 < ${input_gghd} < 100    ${input_gghd}    0
    ${request_payload}    Format String    {{"Invoice":{{"BranchId":{0},"RetailerId":{1},"OrderId":{2},"UpdateInvoiceId":0,"UpdateReturnId":0,"CustomerId":{3},"SoldById":{4},"SoldBy":{{"CreatedBy":160324,"CreatedDate":"2020-01-13T03:46:19.093Z","GivenName":"tester","Id":{4},"IsActive":true,"IsAdmin":false,"Type":0,"isDeleted":false,"Name":"tester"}},"SaleChannelId":0,"Seller":{{"CreatedBy":160324,"CreatedDate":"2020-01-13T03:46:19.093Z","GivenName":"tester","Id":{4},"IsActive":true,"IsAdmin":false,"Type":0,"isDeleted":false,"Name":"tester"}},"PriceBookId":0,"OrderCode":"{5}","Code":"Hóa đơn 2","Discount":{6},"DiscountRatio":{7},"InvoiceDetails":[{8},{9}],"InvoiceOrderSurcharges":[],"InvoicePromotions":[{{"Type":17,"TargetType":2,"SalePromotionId":{10},"PromotionId":{11},"ProductId":{12},"RelatedProductQty":3,"ProductQty":1,"PromotionInfo":"KM theo HH và HĐ hình thức GG hàng VND và không áp dụng all filter: Tổng tiền hàng từ 5,000,000 và mua 6 DVTKM03 - Hàng ĐVT khuyen mai 03 - (chiếc) giảm giá 60,000 cho 1 HTKM03 - Hàng KM theo phạm vi 3","PrintPromotionInfo":"Tổng tiền hàng từ 5,000,000 và mua 6 DVTKM03 - Hàng ĐVT khuyen mai 03 - (chiếc) giảm giá 60,000 cho 1 Hàng KM theo phạm vi 3","ProductIds":"{12}","BackupSelectedSerials":{{}}}}],"Payments":[],"Status":1,"Total":{13},"Surcharge":0,"Type":1,"Uuid":"","addToAccount":"0","PayingAmount":0,"OrderPaidAmount":{14},"DepositReturn":0,"TotalBeforeDiscount":{15},"ProductDiscount":-5460000,"PaidAmount":200000,"DebugUuid":"","InvoiceWarranties":[],"CreatedBy":{4}}}}}     ${get_id_branch}    ${get_id_nguoitao}    ${get_order_id}    ${get_id_kh}    ${get_id_nguoiban}
    ...   ${order_code}     ${result_gghd}    ${giamgia_hd}    ${liststring_prs_order_detail}    ${liststring_prs_order_detail_promo}
    ...    ${get_id_sale_promo}    ${get_id_promotion}    ${get_id_sp_promo}    ${result_TTH_tru_gghd}    ${get_khachdatra_in_dh_bf_execute}    ${result_tongtienhang}
    Log    ${request_payload}
    ${invoice_code}    Post request to create invoice and get invoice code    ${request_payload}
    #get value
    Sleep    20s    wait for response to API
    #assert value product in invoice
    : FOR    ${ma_hh}    ${result_toncuoi}    ${item_soluong}    IN ZIP    ${get_list_hh_in_dh_bf_execute}
    ...    ${result_list_toncuoi}    ${get_list_nums_in_dh}
    \     ${soluong_in_thekho}    ${toncuoi_in_thekho}    Get Stock Card info frm API by Branch and User    ${invoice_code}    ${ma_hh}    ${input_ten_branch}    ${input_ten_user}
    \     Should Be Equal As Numbers    ${toncuoi_in_thekho}    ${result_toncuoi}
    \     Should Be Equal As Numbers    ${soluong_in_thekho}    ${item_soluong}
    #assert value product promo in invoice
    : FOR    ${ma_hh_promo}    ${result_toncuoi_promo}    ${item_soluong_promo}    IN ZIP    ${list_product_promo}
    ...    ${list_result_toncuoi_promo}    ${list_nums_promo}
    \     ${soluong_in_thekho_promo}    ${toncuoi_in_thekho_promo}    Get Stock Card info frm API by Branch and User    ${invoice_code}    ${ma_hh_promo}    ${input_ten_branch}    ${input_ten_user}
    \     Should Be Equal As Numbers    ${toncuoi_in_thekho_promo}    ${result_toncuoi_promo}
    \     Should Be Equal As Numbers    ${soluong_in_thekho_promo}    ${item_soluong_promo}
    #validate product
    ${list_order_summary_af_execute}    Get list of order summary by product code and branch id    ${get_list_hh_in_dh_bf_execute}    ${input_ten_branch}
    : FOR    ${result_tong_dh}    ${order_summary_af_execute}    IN ZIP    ${list_result_tongdh}    ${list_order_summary_af_execute}
    \    Should Be Equal As Numbers    ${order_summary_af_execute}    ${result_tong_dh}
    #assert value invoice
    ${get_ma_kh_by_hd}    ${get_tong_tien_hang}    ${get_khach_tt}    ${get_giamgia_hd}    ${get_khachcantra}    ${get_trangthai}    Get invoice info with other branch and user    ${invoice_code}
    ...    ${input_ten_branch}    ${input_ten_user}
    Should Be Equal As Numbers    ${get_tong_tien_hang}    ${result_tongtienhang}
    Should Be Equal As Numbers    ${get_khachcantra}    ${result_TTH_tru_gghd}
    Should Be Equal As Numbers    ${get_khach_tt}    ${result_khachdatra_in_dh}
    Should Be Equal As Strings    ${get_ma_kh_by_hd}    ${input_ma_kh}
    Should Be Equal As Numbers    ${get_giamgia_hd}    ${result_gghd}
    Should Be Equal As Strings    ${get_trangthai}    Hoàn thành
    #assert value order
    ${get_ma_kh_in_dh_af_execute}    ${get_TTDH_in_dh_af_execute}    ${get_tongtienhang_in_dh_af_exxecute}    ${get_khachdatra_in_dh_af_execute}    ${get_ghichu_af_execute}    Get order info have note by order code    ${order_code}
    Should Be Equal As Strings    ${get_ma_kh_in_dh_af_execute}    ${input_ma_kh}
    Should Be Equal As Strings    ${get_TTDH_in_dh_af_execute}    3    #trạng thái hoan thanh
    Should Be Equal As Numbers    ${get_tongtienhang_in_dh_af_exxecute}    ${get_tongtienhang_in_dh_bf_execute}
    Should Be Equal As Numbers    ${get_khachdatra_in_dh_af_execute}    ${result_khachdatra_in_dh}
    Should Be Equal As Strings    ${get_ghichu_af_execute}    0
    Validate invoice history frm Order    ${order_code}    ${invoice_code}    ${result_TTH_tru_gghd}
    ## Deactivate surcharge
    Delete invoice by invoice code and other branch    ${invoice_code}   ${input_ten_branch}
    Delete order frm Order code    ${order_code}
    Toggle status of promotion and not for all filter   ${input_khuyenmai}    0    ${input_ten_branch}    ${input_ten_user}    ${input_ten_group_kh}    KM Hàng mua     KM Hàng tặng
