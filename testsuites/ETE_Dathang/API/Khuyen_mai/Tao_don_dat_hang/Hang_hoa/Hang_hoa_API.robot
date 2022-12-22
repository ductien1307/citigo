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
&{list_product_nums1}    PROMO2=3
&{list_product_nums2}    DVL010=3
&{dict_promo_nor1}    HKM001=2    HKM002=0
&{dict_promo_nor2}    HKM001=1    HKM002=1
@{list_no_discount}    0    0    0    0    0

*** Test Cases ***    List product nums        GGDH                                                                Mã KH      Khách thanh toán    Mã khuyến mãi    List product          List GGSP
KM HH hinh thuc mua hang GG hang vnd
                      [Documentation]      San pham KM la SP dich vu\nCase khong validate ton kho cua SP KM
                      [Tags]                   AKMDH
                      [Template]               edhkm01_api
                      ${list_product_nums1}    5000                                                               CTKH116    10000              KM06            ${dict_promo_nor1}    ${list_no_discount}    #mua hang gg hang vnd

KM HH hinh thuc mua hang GG hang %
                      [Tags]                   AKMDH
                      [Template]               edhkm02_api
                      ${list_product_nums1}    10000                                                               CTKH117    0                   KM07            ${dict_promo_nor2}    ${list_no_discount}    #mua hang gg hang %

KM HH hinh thuc mua hang GG hang va tang hang
                      [Tags]                   AKMDH
                      [Template]               edhkm03_api
                      ${list_product_nums1}    8000                                                               CTKH118    all                 KM08            ${dict_promo_nor1}    ${list_no_discount}    #mua hang gg hang tang hang

KM HH hinh thuc gia ban theo SL mua
                      [Documentation]          San pham KM la SP dich vu\nCase khong validate ton kho cua SP KM
                      [Tags]                   AKMDH
                      [Template]               edhkm04_api
                      ${list_product_nums2}    5                                                                   CTKH119    0                   KM09

KM HH hinh thuc gia ban theo SL mua GG VND
                      [Documentation]          San pham KM la SP dich vu\nCase khong validate ton kho cua SP KM
                      [Tags]                   AKMDH
                      [Template]               edhkm05_api
                      ${list_product_nums2}    0                                                                   CTKH120    all                 KM10

KM HH hinh thuc gia ban theo SL mua GG %
                      [Documentation]          San pham KM la SP dich vu\nCase khong validate ton kho cua SP KM
                      [Tags]                   AKMDH
                      [Template]               edhkm06_api
                      ${list_product_nums2}    10                                                                  CTKH121    20000              KM11



*** Keywords ***
edhkm01_api
    [Arguments]    ${dict_product_num}    ${input_discount_order}    ${input_ma_kh}    ${input_bh_khachtt}    ${input_khuyemmai}    ${dict_promo_product}
    ...    ${list_ggsp}
    [Timeout]
    Set Selenium Speed    0.5s
    ## Get info ton cuoi, cong no khach hang
    Toggle status of promotion    ${input_khuyemmai}    1
    ${num_sale_product}    ${num_promo_product}    ${product_price}    ${discount}    ${discount_ratio}    ${name}    Get Number of sale product - promo product - promo value and name
    ...    ${input_khuyemmai}
    ${list_product}    Get Dictionary Keys    ${dict_product_num}
    ${list_nums}    Get Dictionary Values    ${dict_product_num}
    ${list_promo_product}    Get Dictionary Keys    ${dict_promo_product}
    ${list_promo_num}    Get Dictionary Values    ${dict_promo_product}
    ${get_no_bf_execute}    ${get_tongban_bf_execute}    ${get_tongban_tru_trahang_bf_execute}    ${get_customer_name}    Get Customer Info from API    ${input_ma_kh}
    #create lists
    ${list_material_by_combo}    create list
    ${list_quantity_material_by_combo}    create list
    : FOR    ${item_product}    IN    @{list_product}
    \    ${list_material_product_code_by_combo}    ${list_material_quantity_by_combo}    Get material product code and quantity lists of combo    ${item_product}
    \    Append To List    ${list_material_by_combo}    ${list_material_product_code_by_combo}
    \    Append To List    ${list_quantity_material_by_combo}    ${list_material_quantity_by_combo}
    Log Many    ${list_material_by_combo}
    Log Many    ${list_quantity_material_by_combo}
    # Promo products
    ${list_result_totalsale_promo}    ${list_result_onhand_promo}    Run keyword if    ${discount} != 0    Get list of total sale - result onhand in case discount product    ${list_promo_product}    ${list_promo_num}
    ...    ${discount}
    ...    ELSE    Get list of total sale - result onhand in case discount product    ${list_promo_product}    ${list_promo_num}    ${discount_ratio}
    ${total_promo_sale}    Sum values in list    ${list_result_totalsale_promo}
    # Input data into BH form
    ${list_result_thanhtien}    ${list_result_order_summary}    ${list_result_giamoi}    Get list total sale and order summary incase discount    ${list_product}    ${list_nums}    ${list_ggsp}
    ${list_result_order_summary_promotion}    Get list result order summary frm product API    ${list_promo_product}    ${list_promo_num}
    #Compute
    ${result_tongtienhang}    Sum values in list    ${list_result_thanhtien}
    ${result_tongtienhang_promo}    Sum    ${result_tongtienhang}    ${total_promo_sale}
    ${actual_tongtienhang}    Set Variable If    ${discount} == 0 and ${discount_ratio} == 0    ${result_tongtienhang}    ${result_tongtienhang_promo}
    ${result_khachcantra}    Minus    ${actual_tongtienhang}    ${input_discount_order}
    ${result_khachcantra}    Replace floating point    ${result_khachcantra}
    ${actual_khachtt}    Set Variable If    '${input_bh_khachtt}' == 'all'    ${result_khachcantra}    ${input_bh_khachtt}
    ${result_nohientai}    Minus    ${get_no_bf_execute}    ${actual_khachtt}
    #create order
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${jsonpath_id_kh}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_kh}
    ${get_id_kh}    Get data from API    ${endpoint_khachhang}    ${jsonpath_id_kh}
    ${endpoint_danhmuc_hh_co_dvt}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${get_resp_danhmuc_hh}    Get Request and return body    ${endpoint_danhmuc_hh_co_dvt}
    ${get_id_sale_promo}    ${get_id_promotion}    ${get_promo_discount}    Get product promotion info    ${input_khuyemmai}
    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}    Get list jsonpath product frm list product    ${list_product}
    ${list_giaban}    ${list_id_sp}    Get product info frm list jsonpath product    ${get_resp_danhmuc_hh}    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}
    ${list_jsonpath_id_sp_promo}    ${list_jsonpath_giaban_promo}    Get list jsonpath product frm list product    ${list_promo_product}
    ${list_giaban_promo}    ${list_id_sp_promo}    Get product info frm list jsonpath product    ${get_resp_danhmuc_hh}    ${list_jsonpath_id_sp_promo}    ${list_jsonpath_giaban_promo}
    ${get_id_sp1}    Get From List    ${list_id_sp}    0
    ${get_gia_ban1}    Get From List    ${list_giaban}    0
    ${input_soluong1}    Get From List    ${list_nums}    0
    ${get_id_sp_promo1}    Get From List    ${list_id_sp_promo}    0
    ${get_gia_ban_promo1}    Get From List    ${list_giaban_promo}    0
    ${get_gia_ban_promo1}   Replace floating point    ${get_gia_ban_promo1}
    ${input_soluong_promo1}    Get From List    ${list_promo_num}    0
    ${discount1}    Set Variable If    ${get_gia_ban_promo1}>=${get_promo_discount}    ${get_promo_discount}     ${get_gia_ban_promo1}
    #post request
    ${request_payload}    Format String    {{"Order":{{"BranchId":{0},"RetailerId":{1},"CustomerId":{2},"SoldById":{3},"SoldBy":{{"CreatedBy":0,"CreatedDate":"2018-07-30T08:27:36.800Z","Email":"","GivenName":"anh.lv","Id":{3},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false}},"SaleChannelId":0,"SaleChannel":null,"Seller":{{"CreatedBy":0,"CreatedDate":"2018-07-30T08:27:36.800Z","Email":"","GivenName":"anh.lv","Id":{3},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false}},"Code":"Đặt hàng 1","Discount":{4},"OrderDetails":[{{"BasePrice":{5},"IsLotSerialControl":false,"IsRewardPoint":false,"Note":"","Price":{5},"ProductCode":"PROMO1","ProductId":{6},"ProductName":"Kẹo Mút Chupa Chups Hương Trái Cây","Quantity":{7},"Uuid":"","OriginPrice":{5},"ProductBatchExpireId":null}},{{"BasePrice":{8},"Discount":{9},"IsLotSerialControl":false,"IsRewardPoint":false,"Note":"","Price":{8},"ProductCode":"HKM001","ProductId":{10},"ProductName":"Gói 6 Thanh Bánh Socola KitKat 2F 17g","PromotionParentProductId":{6},"PromotionParentType":1,"Quantity":{11},"SalePromotionId":{12},"Uuid":"","OriginPrice":{8},"ProductBatchExpireId":null}}],"InvoiceOrderSurcharges":[],"OrderPromotions":[{{"SalePromotionId":{12},"Type":5,"TargetType":1,"TargetProductId":{6},"PromotionId":{13},"ProductId":null,"RelatedProductId":{6},"Discount":30000,"RelatedProductQty":1,"ProductQty":2,"PromotionInfo":"KM theo HH hình thức mua hàng GG hàng vnd: Khi mua 1 PROMO1 - Kẹo Mút Chupa Chups Hương Trái Cây giảm giá 30,000 cho 2 HKM001 - Gói 6 Thanh Bánh Socola KitKat 2F 17g","PrintPromotionInfo":"Mua 1 Kẹo Mút Chupa Chups Hương Trái Cây giảm giá 30,000 cho 2 Gói 6 Thanh Bánh Socola KitKat 2F 17g","ProductIds":"{10}","RelatedProductIds":"{6}","RelatedCategoryIds":"","BackupSelectedSerials":{{}}}}],"Payments":[{{"Method":"Cash","MethodStr":"Tiền mặt","Amount":{14},"Id":-1}}],"UsingCod":0,"Status":1,"Total":40000,"Extra":"{{\\"Amount\\":10000,\\"Method\\":{{\\"Id\\":\\"Cash\\",\\"Label\\":\\"Tiền mặt\\"}},\\"ResetPromotion\\":false}}","Surcharge":0,"Type":2,"Uuid":"","addToAccount":"0","PayingAmount":10000,"TotalBeforeDiscount":105000,"ProductDiscount":60000,"CreatedBy":201567,"InvoiceWarranties":[]}}}}    ${BRANCH_ID}    ${get_id_nguoitao}    ${get_id_kh}    ${get_id_nguoiban}    ${input_discount_order}
    ...    ${get_gia_ban1}    ${get_id_sp1}    ${input_soluong1}    ${get_gia_ban_promo1}  ${discount1}    ${get_id_sp_promo1}    ${input_soluong_promo1}
    ...    ${get_id_sale_promo}    ${get_id_promotion}    ${input_bh_khachtt}
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
    Should Be Equal As Numbers    ${get_giamgia_in_dh_af_execute}    ${input_discount_order}
    Should Be Equal As Numbers    ${get_tongcong_in_dh_af_execute}    ${result_khachcantra}
    #assert value product
    ${list_order_summary_af_execute}    Get list order summary frm product API    ${list_product}
    : FOR    ${result_tong_dh}    ${order_summary_af_execute}    IN ZIP    ${list_result_order_summary}    ${list_order_summary_af_execute}
    \    Should Be Equal As Numbers    ${order_summary_af_execute}    ${result_tong_dh}
    #assert value product promotion
    ${list_order_summary_af_execute_promotion}    Get list order summary frm product API    ${list_promo_product}
    : FOR    ${result_order_summary_pro}    ${order_summary_af_execute_pro}    IN ZIP    ${list_result_order_summary_promotion}    ${list_order_summary_af_execute_promotion}
    \    Should Be Equal As Numbers    ${order_summary_af_execute_pro}    ${result_order_summary_pro}
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

edhkm02_api
    [Arguments]    ${dict_product_num}    ${input_discount_order}    ${input_ma_kh}    ${input_bh_khachtt}    ${input_khuyemmai}    ${dict_promo_product}
    ...    ${list_ggsp}
    [Timeout]
    Set Selenium Speed    0.5s
    ## Get info ton cuoi, cong no khach hang
    Toggle status of promotion    ${input_khuyemmai}    1
    ${num_sale_product}    ${num_promo_product}    ${product_price}    ${discount}    ${discount_ratio}    ${name}    Get Number of sale product - promo product - promo value and name
    ...    ${input_khuyemmai}
    ${list_product}    Get Dictionary Keys    ${dict_product_num}
    ${list_nums}    Get Dictionary Values    ${dict_product_num}
    ${list_promo_product}    Get Dictionary Keys    ${dict_promo_product}
    ${list_promo_num}    Get Dictionary Values    ${dict_promo_product}
    ${get_no_bf_execute}    ${get_tongban_bf_execute}    ${get_tongban_tru_trahang_bf_execute}    ${get_customer_name}    Get Customer Info from API    ${input_ma_kh}
    #create lists
    ${list_material_by_combo}    create list
    ${list_quantity_material_by_combo}    create list
    : FOR    ${item_product}    IN    @{list_product}
    \    ${list_material_product_code_by_combo}    ${list_material_quantity_by_combo}    Get material product code and quantity lists of combo    ${item_product}
    \    Append To List    ${list_material_by_combo}    ${list_material_product_code_by_combo}
    \    Append To List    ${list_quantity_material_by_combo}    ${list_material_quantity_by_combo}
    Log Many    ${list_material_by_combo}
    Log Many    ${list_quantity_material_by_combo}
    # Promo products
    ${list_result_totalsale_promo}    ${list_result_onhand_promo}    Run keyword if    ${discount} != 0    Get list of total sale - result onhand in case discount product    ${list_promo_product}    ${list_promo_num}
    ...    ${discount}
    ...    ELSE    Get list of total sale - result onhand in case discount product    ${list_promo_product}    ${list_promo_num}    ${discount_ratio}
    ${total_promo_sale}    Sum values in list    ${list_result_totalsale_promo}
    # Input data into BH form
    ${laster_nums}    Set Variable    0
    ${list_result_thanhtien}    ${list_result_order_summary}    ${list_result_giamoi}    Get list total sale and order summary incase discount    ${list_product}    ${list_nums}    ${list_ggsp}
    ${list_result_order_summary_promotion}    Get list result order summary frm product API    ${list_promo_product}    ${list_promo_num}
    #Compute
    ${result_tongtienhang}    Sum values in list    ${list_result_thanhtien}
    ${result_tongtienhang_promo}    Sum    ${result_tongtienhang}    ${total_promo_sale}
    ${actual_tongtienhang}    Set Variable If    ${discount} == 0 and ${discount_ratio} == 0    ${result_tongtienhang}    ${result_tongtienhang_promo}
    ${result_khachcantra}    Minus    ${actual_tongtienhang}    ${input_discount_order}
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
    ${get_id_sale_promo}    ${get_id_promotion}    ${get_promo_discount}    Get product promotion info    ${input_khuyemmai}
    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}    Get list jsonpath product frm list product    ${list_product}
    ${list_giaban}    ${list_id_sp}    Get product info frm list jsonpath product    ${get_resp_danhmuc_hh}    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}
    ${list_jsonpath_id_sp_promo}    ${list_jsonpath_giaban_promo}    Get list jsonpath product frm list product    ${list_promo_product}
    ${list_giaban_promo}    ${list_id_sp_promo}    Get product info frm list jsonpath product    ${get_resp_danhmuc_hh}    ${list_jsonpath_id_sp_promo}    ${list_jsonpath_giaban_promo}
    #post request
    ${get_id_sp1}    Get From List    ${list_id_sp}    0
    ${get_gia_ban1}    Get From List    ${list_giaban}    0
    ${input_soluong1}    Get From List    ${list_nums}    0
    ${get_id_sp_promo1}    Get From List    ${list_id_sp_promo}    0
    ${get_id_sp_promo2}    Get From List    ${list_id_sp_promo}    1
    ${get_gia_ban_promo1}    Get From List    ${list_giaban_promo}    0
    ${get_gia_ban_promo2}    Get From List    ${list_giaban_promo}    1
    ${input_soluong_promo1}    Get From List    ${list_promo_num}    0
    ${input_soluong_promo2}    Get From List    ${list_promo_num}    1
    ${result_discount1}    Run Keyword If    0 < ${get_promo_discount} < 100    Convert % discount to VND and round    ${get_gia_ban_promo1}    ${get_promo_discount}    ELSE      Set Variable    ${get_promo_discount}
    ${result_discount2}    Run Keyword If    0 < ${get_promo_discount} < 100    Convert % discount to VND and round    ${get_gia_ban_promo2}    ${get_promo_discount}    ELSE      Set Variable    ${get_promo_discount}
    #post request
    ${request_payload}    Format String    {{"Order":{{"BranchId":{0},"RetailerId":{1},"CustomerId":{2},"SoldById":{3},"SoldBy":{{"CreatedBy":0,"CreatedDate":"2018-07-30T08:27:36.800Z","Email":"","GivenName":"anh.lv","Id":{3},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false}},"SaleChannelId":0,"SaleChannel":null,"Seller":{{"CreatedBy":0,"CreatedDate":"2018-07-30T08:27:36.800Z","Email":"","GivenName":"anh.lv","Id":{3},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false}},"Code":"Đặt hàng 1","Discount":{4},"OrderDetails":[{{"BasePrice":{5},"IsLotSerialControl":false,"IsRewardPoint":false,"Note":"","Price":{5},"ProductCode":"PROMO1","ProductId":{6},"ProductName":"Kẹo Mút Chupa Chups Hương Trái Cây","Quantity":{7},"Uuid":"","OriginPrice":{5},"ProductBatchExpireId":null}},{{"BasePrice":{8},"Discount":{9},"DiscountRatio":{10},"IsLotSerialControl":false,"IsRewardPoint":false,"Note":"","Price":{8},"ProductCode":"HKM001","ProductId":{11},"ProductName":"Gói 6 Thanh Bánh Socola KitKat 2F 17g","PromotionParentProductId":{6},"PromotionParentType":1,"Quantity":{12},"SalePromotionId":{13},"Uuid":"","OriginPrice":{8},"ProductBatchExpireId":null}},{{"BasePrice":{14},"Discount":{15},"DiscountRatio":{16},"IsLotSerialControl":false,"IsRewardPoint":false,"Note":"","Price":{14},"ProductCode":"HKM001","ProductId":{17},"ProductName":"Gói 6 Thanh Bánh Socola KitKat 2F 17g","PromotionParentProductId":{6},"PromotionParentType":1,"Quantity":{18},"SalePromotionId":{13},"Uuid":"","OriginPrice":{14},"ProductBatchExpireId":null}}],"InvoiceOrderSurcharges":[],"OrderPromotions":[{{"SalePromotionId":{13},"Type":5,"TargetType":1,"TargetProductId":{6},"PromotionId":{19},"ProductId":null,"RelatedProductId":{6},"Discount":30000,"RelatedProductQty":1,"ProductQty":2,"PromotionInfo":"KM theo HH hình thức mua hàng GG hàng %: Khi mua 1 PROMO1 - Kẹo Mút Chupa Chups Hương Trái Cây giảm giá 5% cho 1 HKM001 - Gói 6 Thanh Bánh Socola KitKat 2F 17g,1 HKM002 - Kẹo Hồng Sâm Vitamin Daegoung Food","PrintPromotionInfo":"Mua 1 Kẹo Mút Chupa Chups Hương Trái Cây giảm giá 5% cho 1 Gói 6 Thanh Bánh Socola KitKat 2F 17g,1 Kẹo Hồng Sâm Vitamin Daegoung Food","ProductIds":"{11},{17}","RelatedProductIds":"{6}","RelatedCategoryIds":"","BackupSelectedSerials":{{}}}}],"Payments":[{{"Method":"Cash","MethodStr":"Tiền mặt","Amount":{20},"Id":-1}}],"UsingCod":0,"Status":1,"Total":40000,"Extra":"{{\\"Amount\\":10000,\\"Method\\":{{\\"Id\\":\\"Cash\\",\\"Label\\":\\"Tiền mặt\\"}},\\"ResetPromotion\\":false}}","Surcharge":0,"Type":2,"Uuid":"","addToAccount":"0","PayingAmount":10000,"TotalBeforeDiscount":105000,"ProductDiscount":60000,"CreatedBy":201567,"InvoiceWarranties":[]}}}}    ${BRANCH_ID}    ${get_id_nguoitao}    ${get_id_kh}    ${get_id_nguoiban}    ${input_discount_order}
    ...    ${get_gia_ban1}    ${get_id_sp1}    ${input_soluong1}    ${get_gia_ban_promo1}    ${result_discount1}    ${get_promo_discount}
    ...    ${get_id_sp_promo1}    ${input_soluong_promo1}    ${get_id_sale_promo}    ${get_gia_ban_promo2}    ${result_discount2}    ${get_promo_discount}
    ...    ${get_id_sp_promo2}    ${input_soluong_promo2}    ${get_id_promotion}    ${input_bh_khachtt}
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
    Should Be Equal As Numbers    ${get_giamgia_in_dh_af_execute}    ${input_discount_order}
    Should Be Equal As Numbers    ${get_tongcong_in_dh_af_execute}    ${result_khachcantra}
    #assert value product
    ${list_order_summary_af_execute}    Get list order summary frm product API    ${list_product}
    : FOR    ${result_tong_dh}    ${order_summary_af_execute}    IN ZIP    ${list_result_order_summary}    ${list_order_summary_af_execute}
    \    Should Be Equal As Numbers    ${order_summary_af_execute}    ${result_tong_dh}
    #assert value product promotion
    ${list_order_summary_af_execute_promotion}    Get list order summary frm product API    ${list_promo_product}
    : FOR    ${result_order_summary_pro}    ${order_summary_af_execute_pro}    IN ZIP    ${list_result_order_summary_promotion}    ${list_order_summary_af_execute_promotion}
    \    Should Be Equal As Numbers    ${order_summary_af_execute_pro}    ${result_order_summary_pro}
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

edhkm03_api
    [Arguments]    ${dict_product_num}    ${input_discount_order}    ${input_ma_kh}    ${input_bh_khachtt}    ${input_khuyemmai}    ${dict_promo_product}
    ...    ${list_ggsp}
    [Timeout]
    Set Selenium Speed    0.5s
    ## Get info ton cuoi, cong no khach hang
    Toggle status of promotion    ${input_khuyemmai}    1
    ${num_sale_product}    ${num_promo_product}    ${product_price}    ${discount}    ${discount_ratio}    ${name}    Get Number of sale product - promo product - promo value and name
    ...    ${input_khuyemmai}
    ${list_product}    Get Dictionary Keys    ${dict_product_num}
    ${list_nums}    Get Dictionary Values    ${dict_product_num}
    ${list_promo_product}    Get Dictionary Keys    ${dict_promo_product}
    ${list_promo_num}    Get Dictionary Values    ${dict_promo_product}
    ${get_no_bf_execute}    ${get_tongban_bf_execute}    ${get_tongban_tru_trahang_bf_execute}    ${get_customer_name}    Get Customer Info from API    ${input_ma_kh}
    #create lists
    ${list_material_by_combo}    create list
    ${list_quantity_material_by_combo}    create list
    : FOR    ${item_product}    IN    @{list_product}
    \    ${list_material_product_code_by_combo}    ${list_material_quantity_by_combo}    Get material product code and quantity lists of combo    ${item_product}
    \    Append To List    ${list_material_by_combo}    ${list_material_product_code_by_combo}
    \    Append To List    ${list_quantity_material_by_combo}    ${list_material_quantity_by_combo}
    Log Many    ${list_material_by_combo}
    Log Many    ${list_quantity_material_by_combo}
    # Promo products
    ${list_result_totalsale_promo}    ${list_result_onhand_promo}    Run keyword if    ${discount} != 0    Get list of total sale - result onhand in case discount product    ${list_promo_product}    ${list_promo_num}
    ...    ${discount}
    ...    ELSE    Get list of total sale - result onhand in case discount product    ${list_promo_product}    ${list_promo_num}    ${discount_ratio}
    ${total_promo_sale}    Sum values in list    ${list_result_totalsale_promo}
    # Input data into BH form
    ${laster_nums}    Set Variable    0
    ${list_result_thanhtien}    ${list_result_order_summary}    ${list_result_giamoi}    Get list total sale and order summary incase discount    ${list_product}    ${list_nums}    ${list_ggsp}
    ${list_result_order_summary_promotion}    Get list result order summary frm product API    ${list_promo_product}    ${list_promo_num}
    #Compute
    ${result_tongtienhang}    Sum values in list    ${list_result_thanhtien}
    ${result_tongtienhang_promo}    Sum    ${result_tongtienhang}    ${total_promo_sale}
    ${actual_tongtienhang}    Set Variable If    ${discount} == 0 and ${discount_ratio} == 0    ${result_tongtienhang}    ${result_tongtienhang_promo}
    ${result_khachcantra}    Minus    ${actual_tongtienhang}    ${input_discount_order}
    ${result_khachcantra}    Replace floating point    ${result_khachcantra}
    ${actual_khachtt}    Set Variable If    '${input_bh_khachtt}' == 'all'    ${result_khachcantra}    ${input_bh_khachtt}
    ${result_nohientai}    Minus    ${get_no_bf_execute}    ${actual_khachtt}
    #create order
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${jsonpath_id_kh}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_kh}
    ${get_id_kh}    Get data from API    ${endpoint_khachhang}    ${jsonpath_id_kh}
    ${endpoint_danhmuc_hh_co_dvt}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${get_resp_danhmuc_hh}    Get Request and return body    ${endpoint_danhmuc_hh_co_dvt}
    ${get_id_sale_promo}    ${get_id_promotion}    ${get_promo_discount}    Get product promotion info    ${input_khuyemmai}
    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}    Get list jsonpath product frm list product    ${list_product}
    ${list_giaban}    ${list_id_sp}    Get product info frm list jsonpath product    ${get_resp_danhmuc_hh}    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}
    ${list_jsonpath_id_sp_promo}    ${list_jsonpath_giaban_promo}    Get list jsonpath product frm list product    ${list_promo_product}
    ${list_giaban_promo}    ${list_id_sp_promo}    Get product info frm list jsonpath product    ${get_resp_danhmuc_hh}    ${list_jsonpath_id_sp_promo}    ${list_jsonpath_giaban_promo}
    ${get_id_sp1}    Get From List    ${list_id_sp}    0
    ${get_gia_ban1}    Get From List    ${list_giaban}    0
    ${input_soluong1}    Get From List    ${list_nums}    0
    ${get_id_sp_promo1}    Get From List    ${list_id_sp_promo}    0
    ${get_gia_ban_promo1}    Get From List    ${list_giaban_promo}    0
    ${get_gia_ban_promo1}   Replace floating point    ${get_gia_ban_promo1}
    ${input_soluong_promo1}    Get From List    ${list_promo_num}    0
    #post request
    ${request_payload}    Format String    {{"Order":{{"BranchId":{0},"RetailerId":{1},"CustomerId":{2},"SoldById":{3},"SoldBy":{{"CreatedBy":0,"CreatedDate":"2018-07-30T08:27:36.800Z","Email":"","GivenName":"anh.lv","Id":{3},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false}},"SaleChannelId":0,"SaleChannel":null,"Seller":{{"CreatedBy":0,"CreatedDate":"2018-07-30T08:27:36.800Z","Email":"","GivenName":"anh.lv","Id":{3},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false}},"Code":"Đặt hàng 1","Discount":{4},"OrderDetails":[{{"BasePrice":{5},"IsLotSerialControl":false,"IsRewardPoint":false,"Note":"","Price":{5},"ProductCode":"PROMO1","ProductId":{6},"ProductName":"Kẹo Mút Chupa Chups Hương Trái Cây","Quantity":{7},"Uuid":"","OriginPrice":{5},"ProductBatchExpireId":null}},{{"BasePrice":{8},"Discount":{8},"IsLotSerialControl":false,"IsRewardPoint":false,"Note":"","Price":{8},"ProductCode":"HKM001","ProductId":{9},"ProductName":"Gói 6 Thanh Bánh Socola KitKat 2F 17g","PromotionParentProductId":{6},"PromotionParentType":1,"Quantity":{10},"SalePromotionId":{11},"Uuid":"","OriginPrice":{8},"ProductBatchExpireId":null}}],"InvoiceOrderSurcharges":[],"OrderPromotions":[{{"Type":6,"TargetType":1,"SalePromotionId":{11},"PromotionId":{12},"ProductId":null,"RelatedProductId":{6},"RelatedProductQty":1,"ProductQty":2,"PromotionInfo":"KM theo HH hinh thuc mua hang tặng hàng: Khi mua 1 PROMO1 - Kẹo Mút Chupa Chups Hương Trái Cây tặng 2 HKM001 - Gói 6 Thanh Bánh Socola KitKat 2F 17g","PrintPromotionInfo":"Mua 1 Kẹo Mút Chupa Chups Hương Trái Cây tặng 2 Gói 6 Thanh Bánh Socola KitKat 2F 17g","ProductIds":"{9}","RelatedProductIds":"{6}","RelatedCategoryIds":"","BackupSelectedSerials":{{}}}}],"Payments":[{{"Method":"Cash","MethodStr":"Tiền mặt","Amount":{13},"Id":-1}}],"UsingCod":0,"Status":1,"Total":27000,"Extra":"{{\\"Amount\\":27000,\\"Method\\":{{\\"Id\\":\\"Cash\\",\\"Label\\":\\"Tiền mặt\\"}},\\"ResetPromotion\\":false}}","Surcharge":0,"Type":2,"Uuid":"W157251940218230","addToAccount":"0","PayingAmount":27000,"TotalBeforeDiscount":105000,"ProductDiscount":70000,"CreatedBy":201567,"InvoiceWarranties":[]}}}}    ${BRANCH_ID}    ${get_id_nguoitao}    ${get_id_kh}    ${get_id_nguoiban}    ${input_discount_order}
    ...    ${get_gia_ban1}    ${get_id_sp1}    ${input_soluong1}    ${get_gia_ban_promo1}    ${get_id_sp_promo1}    ${input_soluong_promo1}
    ...    ${get_id_sale_promo}    ${get_id_promotion}    ${actual_khachtt}
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
    Should Be Equal As Numbers    ${get_giamgia_in_dh_af_execute}    ${input_discount_order}
    Should Be Equal As Numbers    ${get_tongcong_in_dh_af_execute}    ${result_khachcantra}
    #assert value product
    ${list_order_summary_af_execute}    Get list order summary frm product API    ${list_product}
    : FOR    ${result_tong_dh}    ${order_summary_af_execute}    IN ZIP    ${list_result_order_summary}    ${list_order_summary_af_execute}
    \    Should Be Equal As Numbers    ${order_summary_af_execute}    ${result_tong_dh}
    #assert value product promotion
    ${list_order_summary_af_execute_promotion}    Get list order summary frm product API    ${list_promo_product}
    : FOR    ${result_order_summary_pro}    ${order_summary_af_execute_pro}    IN ZIP    ${list_result_order_summary_promotion}    ${list_order_summary_af_execute_promotion}
    \    Should Be Equal As Numbers    ${order_summary_af_execute_pro}    ${result_order_summary_pro}
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

edhkm04_api
    [Arguments]    ${dict_product_num}    ${input_bh_giamdh}    ${input_ma_kh}    ${input_bh_khachtt}    ${input_khuyemmai}
    [Timeout]
    ## Get info ton cuoi, cong no khach hang
    Toggle status of promotion    ${input_khuyemmai}    1
    ${list_product}    Get Dictionary Keys    ${dict_product_num}
    ${list_nums}    Get Dictionary Values    ${dict_product_num}
    ${num_sale_product}    ${num_promo_product}    ${product_price}    ${discount}    ${discount_ratio}    ${name}    Get Number of sale product - promo product - promo value and name
    ...    ${input_khuyemmai}
    ${get_no_bf_execute}    ${get_tongban_bf_execute}    ${get_tongban_tru_trahang_bf_execute}    ${get_customer_name}    Get Customer Info from API    ${input_ma_kh}
    # Input data into BH form
    ${total_sale_number}    Sum values in list    ${list_nums}
    ${list_result_totalsale}    ${list_result_onhand_af_ex}    Run Keyword If    ${discount} != 0 and ${discount_ratio} ==0    Get list of total sale - result onhand in case discount product    ${list_product}    ${list_nums}
    ...    ${discount}
    ...    ELSE IF    ${discount} == 0 and ${discount_ratio} != 0    Get list of total sale - result onhand in case discount product    ${list_product}    ${list_nums}    ${discount_ratio}
    ...    ELSE IF    ${total_sale_number} < ${num_sale_product}    Get list of total sale - result onhand with one discount    ${list_product}    ${list_nums}
    ...    ELSE    Get list of total sale - result onhand in case promotion    ${list_product}    ${list_nums}    ${product_price}    ${num_sale_product}
    ${list_result_order_summary}    Get list result order summary frm product API    ${list_product}    ${list_nums}
    ${result_tongtienhang}    Sum values in list    ${list_result_totalsale}
    ${result_khachcantra}    Price after % discount invoice    ${result_tongtienhang}    ${input_bh_giamdh}
    ${result_khachcantra}    Replace floating point    ${result_khachcantra}
    ${result_discount_by_vnd}    Convert % discount to VND and round    ${result_tongtienhang}    ${input_bh_giamdh}
    ${actual_khachtt}    Set Variable If    '${input_bh_khachtt}' == 'all'    ${result_khachcantra}    ${input_bh_khachtt}
    ${result_no_hoadon}    Minus    ${result_khachcantra}    ${actual_khachtt}
    ${result_nohientai}    sum    ${result_no_hoadon}    ${get_no_bf_execute}
    ${result_tongban}    Sum    ${result_khachcantra}    ${get_tongban_bf_execute}
    #post request by API
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${jsonpath_id_kh}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_kh}
    ${get_id_kh}    Get data from API    ${endpoint_khachhang}    ${jsonpath_id_kh}
    ${endpoint_danhmuc_hh_co_dvt}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${get_resp_danhmuc_hh}    Get Request and return body    ${endpoint_danhmuc_hh_co_dvt}
    ${get_id_sale_promo}    ${get_id_promotion}    ${get_promo_discount}    Get product promotion info    ${input_khuyemmai}
    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}    Get list jsonpath product frm list product    ${list_product}
    ${list_giaban}    ${list_id_sp}    Get product info frm list jsonpath product    ${get_resp_danhmuc_hh}    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}
    ${get_id_sp1}    Get From List    ${list_id_sp}    0
    ${get_gia_ban1}    Get From List    ${list_giaban}    0
    ${input_soluong1}    Get From List    ${list_nums}    0
    ${discount1}    Minus    ${get_gia_ban1}    ${product_price}
    #post request
    ${request_payload}    Format String    {{"Order":{{"BranchId":{0},"RetailerId":{1},"CustomerId":{2},"SoldById":{3},"SoldBy":{{"CreatedBy":0,"CreatedDate":"2018-07-30T08:27:36.800Z","Email":"","GivenName":"anh.lv","Id":{3},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false}},"SaleChannelId":0,"SaleChannel":null,"Seller":{{"CreatedBy":0,"CreatedDate":"2018-07-30T08:27:36.800Z","Email":"","GivenName":"anh.lv","Id":{3},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false}},"Code":"Đặt hàng 1","Discount":{4},"DiscountRatio":{5},"OrderDetails":[{{"BasePrice":1649000,"Discount":{6},"IsLotSerialControl":true,"IsRewardPoint":false,"Note":"","Price":{7},"ProductCode":"SI040","ProductId":{8},"ProductName":"Máy Xay Sinh Tố Philips HR2115 (600W)","PromotionParentProductId":{8},"PromotionParentType":1,"Quantity":{9},"SalePromotionId":{10},"Uuid":"","ProductBatchExpireId":null}}],"InvoiceOrderSurcharges":[],"OrderPromotions":[{{"Type":8,"TargetType":1,"SalePromotionId":{10},"PromotionId":{11},"ProductId":{8},"ProductPrice":80000,"ProductQty":3,"RelatedProductId":{8},"PromotionInfo":"KM theo HH hình thức giá bán theo SL mua: Khi mua 3 PROMO2 - Bánh Trứng Tik-Tok Sầu Riêng giá 80,000","PrintPromotionInfo":"Mua từ 3 Bánh Trứng Tik-Tok Sầu Riêng giá 80,000","RelatedProductIds":"{8}","RelatedCategoryIds":"794174","PromotionApplicationType":""}}],"Payments":[],"UsingCod":0,"Status":1,"Total":456000,"Extra":"{{\\"Amount\\":0,\\"Method\\":{{\\"Id\\":\\"Cash\\",\\"Label\\":\\"Tiền mặt\\"}},\\"ResetPromotion\\":false}}","Surcharge":0,"Type":2,"Uuid":"","addToAccount":"0","PayingAmount":0,"TotalBeforeDiscount":9894001,"ProductDiscount":9414001,"CreatedBy":201567,"InvoiceWarranties":[]}}}}    ${BRANCH_ID}    ${get_id_nguoitao}    ${get_id_kh}    ${get_id_nguoiban}   ${result_discount_by_vnd}     ${input_bh_giamdh}    ${discount1}
    ...    ${get_gia_ban1}    ${get_id_sp1}    ${input_soluong1}    ${get_id_sale_promo}    ${get_id_promotion}
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
    Should Be Equal As Numbers    ${get_giamgia_in_dh_af_execute}    ${result_discount_by_vnd}
    Should Be Equal As Numbers    ${get_tongcong_in_dh_af_execute}    ${result_khachcantra}
    #assert value product
    ${list_order_summary_af_execute}    Get list order summary frm product API    ${list_product}
    : FOR    ${result_tong_dh}    ${order_summary_af_execute}    IN ZIP    ${list_result_order_summary}    ${list_order_summary_af_execute}
    \    Should Be Equal As Numbers    ${order_summary_af_execute}    ${result_tong_dh}
    #Delete order frm Order code    ${order_code}
    Toggle status of promotion    ${input_khuyemmai}    0

edhkm05_api
    [Arguments]    ${dict_product_num}    ${input_bh_giamdh}    ${input_ma_kh}    ${input_bh_khachtt}    ${input_khuyemmai}
    [Timeout]
    ## Get info ton cuoi, cong no khach hang
    Toggle status of promotion    ${input_khuyemmai}    1
    ${list_product}    Get Dictionary Keys    ${dict_product_num}
    ${list_nums}    Get Dictionary Values    ${dict_product_num}
    ${num_sale_product}    ${num_promo_product}    ${product_price}    ${discount}    ${discount_ratio}    ${name}    Get Number of sale product - promo product - promo value and name
    ...    ${input_khuyemmai}
    ${get_no_bf_execute}    ${get_tongban_bf_execute}    ${get_tongban_tru_trahang_bf_execute}    ${get_customer_name}    Get Customer Info from API    ${input_ma_kh}
    # Input data into BH form
    ${total_sale_number}    Sum values in list    ${list_nums}
    ${list_result_totalsale}    ${list_result_onhand_af_ex}    Run Keyword If    ${discount} != 0 and ${discount_ratio} ==0    Get list of total sale - result onhand in case discount product    ${list_product}    ${list_nums}
    ...    ${discount}
    ...    ELSE IF    ${discount} == 0 and ${discount_ratio} != 0    Get list of total sale - result onhand in case discount product    ${list_product}    ${list_nums}    ${discount_ratio}
    ...    ELSE IF    ${total_sale_number} < ${num_sale_product}    Get list of total sale - result onhand with one discount    ${list_product}    ${list_nums}
    ...    ELSE    Get list of total sale - result onhand in case promotion    ${list_product}    ${list_nums}    ${product_price}    ${num_sale_product}
    ${list_result_order_summary}    Get list result order summary frm product API    ${list_product}    ${list_nums}
    ${result_tongtienhang}    Sum values in list    ${list_result_totalsale}
    ${result_khachcantra}    Price after % discount invoice    ${result_tongtienhang}    ${input_bh_giamdh}
    ${result_khachcantra}    Replace floating point    ${result_khachcantra}
    ${result_discount_by_vnd}    Convert % discount to VND and round    ${result_tongtienhang}    ${input_bh_giamdh}
    ${actual_khachtt}    Set Variable If    '${input_bh_khachtt}' == 'all'    ${result_khachcantra}    ${input_bh_khachtt}
    ${result_no_hoadon}    Minus    ${result_khachcantra}    ${actual_khachtt}
    ${result_nohientai}    sum    ${result_no_hoadon}    ${get_no_bf_execute}
    ${result_tongban}    Sum    ${result_khachcantra}    ${get_tongban_bf_execute}
    #post request by API
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${jsonpath_id_kh}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_kh}
    ${get_id_kh}    Get data from API    ${endpoint_khachhang}    ${jsonpath_id_kh}
    ${endpoint_danhmuc_hh_co_dvt}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${get_resp_danhmuc_hh}    Get Request and return body    ${endpoint_danhmuc_hh_co_dvt}
    ${get_id_sale_promo}    ${get_id_promotion}    ${get_promo_discount}    Get product promotion info    ${input_khuyemmai}
    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}    Get list jsonpath product frm list product    ${list_product}
    ${list_giaban}    ${list_id_sp}    Get product info frm list jsonpath product    ${get_resp_danhmuc_hh}    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}
    ${get_id_sp1}    Get From List    ${list_id_sp}    0
    ${get_gia_ban1}    Get From List    ${list_giaban}    0
    ${input_soluong1}    Get From List    ${list_nums}    0
    #post request
    ${request_payload}    Format String    {{"Order":{{"BranchId":{0},"RetailerId":{1},"CustomerId":{2},"SoldById":{3},"SoldBy":{{"CreatedBy":0,"CreatedDate":"2018-07-30T08:27:36.800Z","Email":"","GivenName":"anh.lv","Id":{3},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false}},"SaleChannelId":0,"SaleChannel":null,"Seller":{{"CreatedBy":0,"CreatedDate":"2018-07-30T08:27:36.800Z","Email":"","GivenName":"anh.lv","Id":{3},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false}},"Code":"Đặt hàng 1","Discount":{4},"DiscountRatio":{5},"OrderDetails":[{{"BasePrice":1649000,"Discount":{6},"IsLotSerialControl":true,"IsRewardPoint":false,"Note":"","Price":{7},"ProductCode":"SI040","ProductId":{8},"ProductName":"Máy Xay Sinh Tố Philips HR2115 (600W)","PromotionParentProductId":{8},"PromotionParentType":1,"Quantity":{9},"SalePromotionId":{10},"Uuid":"","ProductBatchExpireId":null}}],"InvoiceOrderSurcharges":[],"OrderPromotions":[{{"Type":8,"TargetType":1,"SalePromotionId":{10},"PromotionId":{11},"ProductId":{8},"ProductPrice":80000,"ProductQty":3,"RelatedProductId":{8},"PromotionInfo":"KM theo HH hình thức giá bán theo SL mua GG vnd: Khi mua 3 PROMO2 - Bánh Trứng Tik-Tok Sầu Riêng giảm giá 20,000","PrintPromotionInfo":"Mua từ 3 Bánh Trứng Tik-Tok Sầu Riêng được giảm giá 20,000 mỗi sản phẩm","RelatedProductIds":"{8}","RelatedCategoryIds":"794174","PromotionApplicationType":""}}],"Payments":[{{"Method":"Cash","MethodStr":"Tiền mặt","Amount":{12},"Id":-1}}],"UsingCod":0,"Status":1,"Total":456000,"Extra":"{{\\"Amount\\":0,\\"Method\\":{{\\"Id\\":\\"Cash\\",\\"Label\\":\\"Tiền mặt\\"}},\\"ResetPromotion\\":false}}","Surcharge":0,"Type":2,"Uuid":"","addToAccount":"0","PayingAmount":0,"TotalBeforeDiscount":9894001,"ProductDiscount":9414001,"CreatedBy":201567,"InvoiceWarranties":[]}}}}    ${BRANCH_ID}    ${get_id_nguoitao}    ${get_id_kh}    ${get_id_nguoiban}
    ...   ${result_discount_by_vnd}     ${input_bh_giamdh}    ${get_promo_discount}    ${get_gia_ban1}    ${get_id_sp1}    ${input_soluong1}    ${get_id_sale_promo}
    ...    ${get_id_promotion}    ${actual_khachtt}
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
    Should Be Equal As Numbers    ${get_giamgia_in_dh_af_execute}    ${result_discount_by_vnd}
    Should Be Equal As Numbers    ${get_tongcong_in_dh_af_execute}    ${result_khachcantra}
    #assert value product
    ${list_order_summary_af_execute}    Get list order summary frm product API    ${list_product}
    : FOR    ${result_tong_dh}    ${order_summary_af_execute}    IN ZIP    ${list_result_order_summary}    ${list_order_summary_af_execute}
    \    Should Be Equal As Numbers    ${order_summary_af_execute}    ${result_tong_dh}
    #Delete order frm Order code    ${order_code}
    Toggle status of promotion    ${input_khuyemmai}    0

edhkm06_api
    [Arguments]    ${dict_product_num}    ${input_bh_giamdh}    ${input_ma_kh}    ${input_bh_khachtt}    ${input_khuyemmai}
    [Timeout]
    ## Get info ton cuoi, cong no khach hang
    Toggle status of promotion    ${input_khuyemmai}    1
    ${list_product}    Get Dictionary Keys    ${dict_product_num}
    ${list_nums}    Get Dictionary Values    ${dict_product_num}
    ${num_sale_product}    ${num_promo_product}    ${product_price}    ${discount}    ${discount_ratio}    ${name}    Get Number of sale product - promo product - promo value and name
    ...    ${input_khuyemmai}
    ${get_no_bf_execute}    ${get_tongban_bf_execute}    ${get_tongban_tru_trahang_bf_execute}    ${get_customer_name}    Get Customer Info from API    ${input_ma_kh}
    # Input data into BH form
    ${total_sale_number}    Sum values in list    ${list_nums}
    ${list_result_totalsale}    ${list_result_onhand_af_ex}    Run Keyword If    ${discount} != 0 and ${discount_ratio} ==0    Get list of total sale - result onhand in case discount product    ${list_product}    ${list_nums}
    ...    ${discount}
    ...    ELSE IF    ${discount} == 0 and ${discount_ratio} != 0    Get list of total sale - result onhand in case discount product    ${list_product}    ${list_nums}    ${discount_ratio}
    ...    ELSE IF    ${total_sale_number} < ${num_sale_product}    Get list of total sale - result onhand with one discount    ${list_product}    ${list_nums}
    ...    ELSE    Get list of total sale - result onhand in case promotion    ${list_product}    ${list_nums}    ${product_price}    ${num_sale_product}
    ${list_result_order_summary}    Get list result order summary frm product API    ${list_product}    ${list_nums}
    ${result_tongtienhang}    Sum values in list    ${list_result_totalsale}
    ${result_khachcantra}    Price after % discount invoice    ${result_tongtienhang}    ${input_bh_giamdh}
    ${result_khachcantra}    Replace floating point    ${result_khachcantra}
    ${result_discount_by_vnd}    Convert % discount to VND and round    ${result_tongtienhang}    ${input_bh_giamdh}
    ${actual_khachtt}    Set Variable If    '${input_bh_khachtt}' == 'all'    ${result_khachcantra}    ${input_bh_khachtt}
    ${result_no_hoadon}    Minus    ${result_khachcantra}    ${actual_khachtt}
    ${result_nohientai}    sum    ${result_no_hoadon}    ${get_no_bf_execute}
    ${result_tongban}    Sum    ${result_khachcantra}    ${get_tongban_bf_execute}
    #post request by API
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${jsonpath_id_kh}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_kh}
    ${get_id_kh}    Get data from API    ${endpoint_khachhang}    ${jsonpath_id_kh}
    ${endpoint_danhmuc_hh_co_dvt}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${get_resp_danhmuc_hh}    Get Request and return body    ${endpoint_danhmuc_hh_co_dvt}
    ${get_id_sale_promo}    ${get_id_promotion}    ${get_promo_discount}    Get product promotion info    ${input_khuyemmai}
    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}    Get list jsonpath product frm list product    ${list_product}
    ${list_giaban}    ${list_id_sp}    Get product info frm list jsonpath product    ${get_resp_danhmuc_hh}    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}
    ${get_id_sp1}    Get From List    ${list_id_sp}    0
    ${get_gia_ban1}    Get From List    ${list_giaban}    0
    ${input_soluong1}    Get From List    ${list_nums}    0
    ${discount1}    Convert % discount to VND    ${get_gia_ban1}         ${get_promo_discount}
    #post request
    ${request_payload}    Format String    {{"Order":{{"BranchId":{0},"RetailerId":{1},"CustomerId":{2},"SoldById":{3},"SoldBy":{{"CreatedBy":0,"CreatedDate":"2018-07-30T08:27:36.800Z","Email":"","GivenName":"anh.lv","Id":{3},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false}},"SaleChannelId":0,"SaleChannel":null,"Seller":{{"CreatedBy":0,"CreatedDate":"2018-07-30T08:27:36.800Z","Email":"","GivenName":"anh.lv","Id":{3},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false}},"Code":"Đặt hàng 1","Discount":{4},"DiscountRatio":{5},"OrderDetails":[{{"BasePrice":1649000,"Discount":{6},"DiscountRatio":{7},"IsLotSerialControl":true,"IsRewardPoint":false,"Note":"","Price":{8},"ProductCode":"SI040","ProductId":{9},"ProductName":"Máy Xay Sinh Tố Philips HR2115 (600W)","PromotionParentProductId":{9},"PromotionParentType":1,"Quantity":{10},"SalePromotionId":{11},"Uuid":"","ProductBatchExpireId":null}}],"InvoiceOrderSurcharges":[],"OrderPromotions":[{{"Type":8,"TargetType":1,"SalePromotionId":{11},"PromotionId":{12},"ProductId":{9},"ProductPrice":20,"ProductQty":3,"RelatedProductId":{9},"PromotionInfo":"KM theo HH hình thức giá bán theo SL mua GG %: Khi mua 3 PROMO2 - Bánh Trứng Tik-Tok Sầu Riêng giảm giá 20%","PrintPromotionInfo":"Mua từ 3 Bánh Trứng Tik-Tok Sầu Riêng được giảm giá 20.00% mỗi sản phẩm","RelatedProductIds":"{9}","RelatedCategoryIds":"794174","PromotionApplicationType":"%"}}],"Payments":[{{"Method":"Cash","MethodStr":"Tiền mặt","Amount":{13},"Id":-1}}],"UsingCod":0,"Status":1,"Total":7123681,"Extra":"{{\\"Amount\\":100000,\\"Method\\":{{\\"Id\\":\\"Cash\\",\\"Label\\":\\"Tiền mặt\\"}},\\"ResetPromotion\\":false}}","Surcharge":0,"Type":2,"Uuid":"","addToAccount":"0","PayingAmount":100000,"TotalBeforeDiscount":9894001,"ProductDiscount":1978800,"CreatedBy":201567,"InvoiceWarranties":[]}}}}   ${BRANCH_ID}    ${get_id_nguoitao}    ${get_id_kh}    ${get_id_nguoiban}
    ...   ${result_discount_by_vnd}     ${input_bh_giamdh}    ${discount1}    ${get_promo_discount}    ${get_gia_ban1}
    ...   ${get_id_sp1}    ${input_soluong1}    ${get_id_sale_promo}    ${get_id_promotion}    ${actual_khachtt}
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
    Should Be Equal As Numbers    ${get_giamgia_in_dh_af_execute}    ${result_discount_by_vnd}
    Should Be Equal As Numbers    ${get_tongcong_in_dh_af_execute}    ${result_khachcantra}
    #assert value product
    ${list_order_summary_af_execute}    Get list order summary frm product API    ${list_product}
    : FOR    ${result_tong_dh}    ${order_summary_af_execute}    IN ZIP    ${list_result_order_summary}    ${list_order_summary_af_execute}
    \    Should Be Equal As Numbers    ${order_summary_af_execute}    ${result_tong_dh}
    #Delete order frm Order code    ${order_code}
    Toggle status of promotion    ${input_khuyemmai}    0
