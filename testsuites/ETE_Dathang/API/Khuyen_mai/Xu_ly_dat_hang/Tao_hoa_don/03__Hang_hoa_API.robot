*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    ${headless_browser}
Resource          ../../../../../../core/API/api_thietlap.robot
Resource          ../../../../../../core/API/api_dathang.robot
Resource          ../../../../../../core/Ban_Hang/banhang_getandcompute.robot
Resource          ../../../../../../core/share/toast_message.robot
Resource          ../../../../../../core/API/api_mhbh_dathang.robot
Resource          ../../../../../../core/API/api_hoadon_banhang.robot
Resource          ../../../../../../core/API/api_soquy.robot
Resource          ../../../../../../core/API/api_danhmuc_hanghoa.robot
Resource          ../../../../../../core/Dat_Hang/dat_hang_action.robot
Resource          ../../../../../../core/Dat_Hang/dat_hang_page.robot

*** Variables ***
&{dict_product1}    HH0035=1    HH0036=1
&{dict_product_delete}  HH0036=1
&{dict_promo_nor1}    HKM001=2    HKM002=2
&{dict_promo_nor2}    HKM002=4
&{list_product2}    DVT34=3.5
@{list_no_discount}    0

*** Test Cases ***    List product nums    GGDH              Mã KH      KTT    Mã khuyến mãi    List product          List GGSP              Khách thanh toán to create order    List product add
KM HH hinh thuc mua hang GG hang
                      [Tags]               AKMDH4
                      [Template]           edxhh01_api
                      ${dict_product1}     1000             KHKM07    5000     KM06            ${dict_promo_nor1}    ${list_no_discount}    300000        ${dict_product_delete}         #mua hang gg hang vnd

KM HH hinh thuc mua hang tang hang
                      [Tags]               AKMDH4
                      [Template]           edxhh02_api
                      ${dict_product1}     0             KHKM08    0        KM08            ${dict_promo_nor2}    0      #mua hang gg hang tang hang

KM HH hinh thuc gia ban theo SL mua
                      [Documentation]      San pham KM la SP dich vu\nCase khong validate ton kho cua SP KM
                      [Tags]               AKMDH4
                      [Template]           edxhh03_api
                      ${list_product2}     10            KHKM09    0           KM11            10000                ${dict_product_delete}       ${list_no_discount}                 #giam gia san pham theo so luong mua %

*** Keywords ***
edxhh01_api
    [Arguments]    ${dict_product_num}    ${input_discount_inv}    ${input_ma_kh}    ${input_hoantratamung}    ${input_khuyemmai}    ${dict_promo_product}
    ...    ${list_ggsp}    ${input_khtt_create_order}    ${dict_product_del}
    [Timeout]
    ## Get info ton cuoi, cong no khach hang
    Toggle status of promotion    ${input_khuyemmai}    1
    ${order_code}    Add new order with promotion buy product and get other product discount    ${input_ma_kh}    ${dict_product_num}    ${input_khuyemmai}    ${dict_promo_product}    ${input_khtt_create_order}
    ${num_sale_product}    ${num_promo_product}    ${product_price}    ${discount}    ${discount_ratio}    ${name}    Get Number of sale product - promo product - promo value and name
    ...    ${input_khuyemmai}
    ${list_product_del}    Get Dictionary Keys    ${dict_product_del}
    ${list_nums_del}    Get Dictionary Values    ${dict_product_del}
    ${list_promo_product}    Get Dictionary Keys    ${dict_promo_product}
    ${list_promo_num}    Get Dictionary Values    ${dict_promo_product}
    ${get_no_bf_execute}    ${get_tongban_bf_execute}    ${get_tongban_tru_trahang_bf_execute}    ${get_customer_name}    Get Customer Info from API    ${input_ma_kh}
    ${get_khachdatra_in_dh_bf_execute}    ${get_tongtienhang_in_dh_bf_execute}    Get paid value frm API    ${order_code}
    ${get_list_hh_in_dh_bf_execute}    ${get_ghichu_bf_execute}   Get ghi chu and list product frm API    ${order_code}
    ${get_list_nums_in_dh}    Get list quantity by order code    ${order_code}    ${get_list_hh_in_dh_bf_execute}
    ${list_order_summary_bf_execute}    Get list order summary by order code    ${order_code}
    ${list_result_order_summary_del}    Get list order summary frm product API    ${list_product_del}
    Remove From List    ${list_order_summary_bf_execute}   -1
    :FOR    ${item_product}    IN ZIP    ${list_product_del}
    \    Remove Values From List   ${get_list_hh_in_dh_bf_execute}    ${item_product}
    Remove From List    ${get_list_nums_in_dh}   -1
    Log    ${get_list_nums_in_dh}
    ${get_ma_dh_in_dh_bf_execute}    ${get_khachdatra_in_dh_bf_execute}    ${get_ggdh_in_dh_bf_execute}    ${get_tongtienhang_in_dh_bf_execute}    ${get_tongcong_in_dh_bf_execute}    Get order code - paid - discount value frm API    ${input_ma_kh}
    ${list_result_order_summary}    ${result_list_toncuoi}    ${result_list_thanhtien}    Get list order summary - total sale - ending stocks frm API    ${order_code}    ${get_list_hh_in_dh_bf_execute}
    #Compute
    ${result_tongtienhang}    Sum values in list    ${result_list_thanhtien}
    ${result_khachcantra}    Minus and replace floating point    ${result_tongtienhang}    ${input_discount_inv}
    ${tamung}    Minus and replace floating point    ${get_khachdatra_in_dh_bf_execute}    ${result_khachcantra}
    ${result_tamung}    Set Variable If    '${input_hoantratamung}' == 'all'    ${tamung}    ${input_hoantratamung}
    ${result_khachdatra_in_dh}    Minus and replace floating point    ${get_khachdatra_in_dh_bf_execute}    ${result_tamung}
    #compute Customer
    ${result_du_no_hd_KH}    Sum    ${get_no_bf_execute}    ${result_khachcantra}
    ${result_PTT_hd_KH}    Sum    ${result_du_no_hd_KH}    ${result_tamung}
    ${result_tongban_KH}    Sum and replace floating point    ${result_khachcantra}    ${get_tongban_bf_execute}
    #create invoice
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${jsonpath_id_kh}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_kh}
    ${get_id_kh}    Get data from API    ${endpoint_khachhang}    ${jsonpath_id_kh}
    ${endpoint_danhmuc_hh_co_dvt}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${get_resp_danhmuc_hh}    Get Request and return body    ${endpoint_danhmuc_hh_co_dvt}
    ${get_id_sale_promo}    ${get_id_promotion}    ${get_promo_discount}    Get promotion info    ${input_khuyemmai}
    ${get_order_id}   ${get_payment_id}   Get order - payment frm order api    ${order_code}
    ${get_list_order_detail_id}   Get list orderdetail id frm order api    ${order_code}    ${get_list_hh_in_dh_bf_execute}
    ${get_list_order_detail_id_promo}   Get list orderdetail id frm order api    ${order_code}    ${list_promo_product}
    #get list gia ban, id san pham, discount of product
    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}    Get list jsonpath product frm list product    ${get_list_hh_in_dh_bf_execute}
    ${list_giaban}    ${list_id_sp}    Get product info frm list jsonpath product    ${get_resp_danhmuc_hh}    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}
    ${list_jsonpath_id_sp_promo}    ${list_jsonpath_giaban_promo}    Get list jsonpath product frm list product    ${list_promo_product}
    ${list_giaban_promo}    ${list_id_sp_promo}    Get product info frm list jsonpath product    ${get_resp_danhmuc_hh}    ${list_jsonpath_id_sp_promo}    ${list_jsonpath_giaban_promo}
    ${get_id_sp1}    Get From List    ${list_id_sp}    0
    ${get_gia_ban1}    Get From List    ${list_giaban}    0
    ${input_soluong1}    Get From List    ${get_list_nums_in_dh}    0
    ${get_id_order_detail1}    Get From List    ${get_list_order_detail_id}    0
    ${actual_tamung}    Minus     0    ${result_tamung}
    #list payload of product new
    ${liststring_prs_order_detail}     Set Variable      needdel
    Log        ${liststring_prs_order_detail}
    : FOR   ${item_gia_ban}   ${item_id_sp}   ${item_soluong}   ${get_orderdetail_id}      IN ZIP   ${list_giaban_promo}        ${list_id_sp_promo}    ${list_promo_num}    ${get_list_order_detail_id_promo}
    \    ${payload_each_product}        Format string       {{"BasePrice":82000,"IsLotSerialControl":false,"IsRewardPoint":false,"Note":"","Price":{0},"ProductId":{1},"Quantity":{2},"ProductCode":"NK001","Discount":{3},"DiscountRatio":0,"ProductName":"Hạt tặng 1","SalePromotionId":{4},"PromotionParentProductId":{5},"ProductBatchExpireId":null,"CategoryId":794171,"MasterProductId":{1},"Unit":"","Uuid":"","OrderDetailId":{6},"ProductWarranty":[]}}   ${item_gia_ban}   ${item_id_sp}   ${item_soluong}    ${get_promo_discount}    ${get_id_sale_promo}    ${get_id_sp1}   ${get_orderdetail_id}
    \    ${liststring_prs_order_detail}       Catenate      SEPARATOR=,      ${liststring_prs_order_detail}      ${payload_each_product}
    ${liststring_prs_order_detail}       Replace String      ${liststring_prs_order_detail}       needdel,       ${EMPTY}      count=1
    ${list_id_sp}   Convert list to string and return     ${list_id_sp}
    ${list_id_sp_promo}   Convert list to string and return     ${list_id_sp_promo}
    #post request
    ${request_payload}    Format String    {{"Invoice":{{"BranchId":{0},"RetailerId":{1},"OrderId":{2},"UpdateInvoiceId":0,"UpdateReturnId":0,"CustomerId":{3},"SoldById":{4},"SoldBy":{{"CreatedBy":0,"CreatedDate":"2018-07-30T08:27:36.800Z","GivenName":"anh.lv","Id":{4},"IsActive":true,"IsAdmin":true,"Type":0,"isDeleted":false,"Name":"anh.lv"}},"SaleChannelId":0,"Seller":{{"CreatedBy":0,"CreatedDate":"2018-07-30T08:27:36.800Z","GivenName":"anh.lv","Id":{4},"IsActive":true,"IsAdmin":true,"Type":0,"isDeleted":false,"Name":"anh.lv"}},"PriceBookId":0,"OrderCode":"{5}","Code":"Hóa đơn 1","Discount":{6},"InvoiceDetails":[{{"BasePrice":64000.02,"IsLotSerialControl":false,"IsRewardPoint":false,"Note":"","Price":{7},"ProductId":{8},"Quantity":{9},"ProductCode":"HH0044","Discount":0,"DiscountRatio":0,"ProductName":"Túi 8 Bánh Socola Kitkat Trà Xanh SB","IsMaster":true,"ProductBatchExpireId":null,"CategoryId":794169,"MasterProductId":{8},"Unit":"","Uuid":"","OrderDetailId":{10},"ProductWarranty":[]}},{11}],"InvoiceOrderSurcharges":[],"InvoicePromotions":[{{"Discount":30000,"ProductIds":"{12}","ProductQty":2,"PromotionId":{13},"PromotionInfo":"KM theo HH hình thức mua hàng GG hàng vnd: Khi mua 1 HH0035 - Kem Hàn Quốc trà xanh XXXD, 1 HH0036 - Kem whipping cream Anchor giảm giá 30,000 cho 2 HKM001 - Gói 6 Thanh Bánh Socola KitKat 2F 17g, 2 HKM002 - Kẹo Hồng Sâm Vitamin Daegoung Food 2","RelatedCategoryIds":"1147662","RelatedProductId":{8},"RelatedProductIds":"{12}","RelatedProductQty":1,"SalePromotionId":{14},"TargetType":1,"Type":5,"PrintPromotionInfo":"Mua 1 Kem Hàn Quốc trà xanh XXXD, 1 Kem whipping cream Anchor giảm giá 30,000 cho 2 Gói 6 Thanh Bánh Socola KitKat 2F 17g, 2 Kẹo Hồng Sâm Vitamin Daegoung Food 2"}}],"Payments":[{{"Method":"Cash","MethodStr":"Tiền mặt","Amount":{15},"Id":-1}}],"Status":1,"Total":{16},"Surcharge":0,"Type":1,"Uuid":"","addToAccount":"0","PayingAmount":{16},"OrderPaidAmount":{17},"DepositReturn":{18},"TotalBeforeDiscount":{19},"ProductDiscount":120000,"PaidAmount":300000,"DebugUuid":"","InvoiceWarranties":[],"CreatedBy":201567}}}}    ${BRANCH_ID}    ${get_id_nguoitao}    ${get_order_id}    ${get_id_kh}    ${get_id_nguoiban}
    ...     ${order_code}     ${input_discount_inv}    ${get_gia_ban1}    ${get_id_sp1}    ${input_soluong1}   ${get_id_order_detail1}
    ...    ${liststring_prs_order_detail}    ${list_id_sp_promo}    ${get_id_promotion}    ${get_id_sale_promo}    ${actual_tamung}   ${result_khachcantra}
    ...    ${get_khachdatra_in_dh_bf_execute}   ${result_tamung}    ${result_tongtienhang}
    Log    ${request_payload}
    ${invoice_code}    Post request to create invoice and get invoice code    ${request_payload}
    #get values
    Sleep    20 s    wait for response to API
    #assert value product
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
    ${list_order_summary_af_execute}    Get list order summary frm product API    ${get_list_hh_in_dh_bf_execute}
    : FOR    ${result_tong_dh}    ${order_summary_af_execute}    IN ZIP    ${list_result_order_summary}    ${list_order_summary_af_execute}
    \    Should Be Equal As Numbers    ${order_summary_af_execute}    ${result_tong_dh}
    ${list_order_summary_del_af_execute}    Get list order summary frm product API    ${list_product_del}
    : FOR    ${result_tong_dh_del}    ${order_summary_af_execute_del}    IN ZIP    ${list_result_order_summary_del}    ${list_order_summary_del_af_execute}
    \    Should Be Equal As Numbers    ${order_summary_af_execute_del}    ${result_tong_dh_del}
    #assert value invoice
    ${get_ma_kh_by_hd}    ${get_tong_tien_hang}    ${get_khachtt_af_execute}    ${get_gghd_af_execute}    ${get_khachcantra}    ${get_trangthai}    ${get_ghichu_in_hd_af_execute}
    ...    Get invoice info have note incase discount by invoice code    ${invoice_code}
    Should Be Equal As Numbers    ${get_tong_tien_hang}    ${result_tongtienhang}
    Should Be Equal As Numbers    ${get_khachcantra}    ${result_khachcantra}
    Should Be Equal As Numbers    ${get_khachtt_af_execute}    ${result_khachcantra}
    Should Be Equal As Strings    ${get_ma_kh_by_hd}    ${input_ma_kh}
    Should Be Equal As Numbers    ${get_gghd_af_execute}    ${input_discount_inv}
    Should Be Equal As Strings    ${get_trangthai}    Hoàn thành
    #assert value order
    ${get_ma_kh_in_dh_af_execute}    ${get_TTDH_in_dh_af_execute}    ${get_tongtienhang_in_dh_af_exxecute}    ${get_khachdatra_in_dh_af_execute}    ${get_giamgia_in_dh_af_execute}    ${get_tongcong_in_dh_af_execute}    ${get_ghichu_in_dh_af_execute}
    ...    Get order info have note incase discount by order code    ${order_code}
    Should Be Equal As Strings    ${get_ma_kh_in_dh_af_execute}    ${input_ma_kh}
    Should Be Equal As Numbers    ${get_TTDH_in_dh_af_execute}    2    #trạng thái đang giao hàng
    Should Be Equal As Numbers    ${get_tongtienhang_in_dh_af_exxecute}    ${get_tongtienhang_in_dh_bf_execute}
    Should Be Equal As Numbers    ${get_khachdatra_in_dh_af_execute}    ${result_khachdatra_in_dh}
    Should Be Equal As Numbers    ${get_giamgia_in_dh_af_execute}    ${get_ggdh_in_dh_bf_execute}
    Should Be Equal As Numbers    ${get_tongcong_in_dh_af_execute}    ${get_tongcong_in_dh_bf_execute}
    Validate invoice history frm Order    ${order_code}    ${invoice_code}    ${result_khachcantra}
    #assert customer and so quy
    ${get_no_af_execute_kh}    ${get_tongban_af_execute_kh}    ${get_tongban_tru_trahang_af_execute_kh}    Run Keyword If    ${input_hoantratamung}<0    Get Customer Debt from API after purchase    ${input_ma_kh}
    ...    ${invoice_code}    ${result_tongtienhang}
    ...    ELSE    Get Customer Debt from API    ${input_ma_kh}
    ${get_maphieu_soquy}    Get Ma Phieu Thu in So quy    ${invoice_code}
    Run Keyword If    '${input_hoantratamung}' == '0'    Should Be Equal As Numbers    ${get_no_af_execute_kh}    ${result_du_no_hd_KH}
    ...    ELSE    Should Be Equal As Numbers    ${get_no_af_execute_kh}    ${result_PTT_hd_KH}
    Should Be Equal As Numbers    ${get_tongban_af_execute_kh}    ${result_tongban_KH}
    Run Keyword If    '${input_hoantratamung}' == '0'    Validate customer history and debt if invoice is not paid frm order    ${input_ma_kh}    ${invoice_code}    ${result_du_no_hd_KH}
    ...    ELSE    Validate customer history and debt if invoice is paid deposit refund frm order    ${input_ma_kh}    ${invoice_code}    ${result_du_no_hd_KH}    ${result_PTT_hd_KH}
    Run Keyword If    '${result_tongtienhang}' == '0'    Validate history tab of customer frm Order    ${input_ma_kh}    ${invoice_code}
    Run Keyword If    '${input_hoantratamung}' == '0'    Validate So quy info from Rest API if Invoice is not paid    ${get_maphieu_soquy}
    ...    ELSE    Validate So quy info from Rest API if Invoice is paid    ${get_maphieu_soquy}    ${result_tamung}
    Delete invoice by invoice code    ${invoice_code}
    Delete order frm Order code    ${order_code}
    Toggle status of promotion    ${input_khuyemmai}    0

edxhh02_api
    [Arguments]    ${dict_product_num}    ${input_discount_inv}    ${input_ma_kh}    ${input_bh_khachtt}    ${input_khuyemmai}    ${dict_promo_product}
    ...    ${input_khtt_create_order}
    [Timeout]
    ## Get info ton cuoi, cong no khach hang
    Toggle status of promotion    ${input_khuyemmai}    1
    ${order_code}    Add new order with promotion buy product and get other product free    ${input_ma_kh}    ${dict_product_num}    ${input_khuyemmai}    ${dict_promo_product}    ${input_khtt_create_order}
    ${num_sale_product}    ${num_promo_product}    ${product_price}    ${discount}    ${discount_ratio}    ${name}    Get Number of sale product - promo product - promo value and name
    ...    ${input_khuyemmai}
    ${list_product}    Get Dictionary Keys    ${dict_product_num}
    ${list_nums}    Get Dictionary Values    ${dict_product_num}
    ${list_promo_product}    Get Dictionary Keys    ${dict_promo_product}
    ${list_promo_num}    Get Dictionary Values    ${dict_promo_product}
    ${get_ma_dh_in_dh_bf_execute}    ${get_khachdatra_in_dh_bf_execute}    ${get_ggdh_in_dh_bf_execute}    ${get_tongtienhang_in_dh_bf_execute}    ${get_tongcong_in_dh_bf_execute}    Get order code - paid - discount value frm API    ${input_ma_kh}
    ${get_list_hh_in_dh_bf_execute}    ${get_ghichu_bf_execute}    Get ghi chu and list product frm API    ${order_code}
    ${get_list_nums}   ${get_list_ordersummary_bf_execute}    Get list quantity - order summary frm API    ${order_code}    ${get_list_hh_in_dh_bf_execute}
    ${list_result_order_summary}    Get list order summary after create invoice    ${get_list_ordersummary_bf_execute}    ${get_list_nums}
    #Compute
    ${result_khachcantra}    Minus and replace floating point    ${get_tongtienhang_in_dh_bf_execute}    ${input_discount_inv}
    ${result_khachcanthanhtoan}    Minus and replace floating point    ${result_khachcantra}        ${get_khachdatra_in_dh_bf_execute}
    ${actual_khachtt}    Set Variable If    '${input_bh_khachtt}' == 'all'    ${result_khachcantra}    ${input_bh_khachtt}
    ${result_khachdatra}    Sum    ${get_khachdatra_in_dh_bf_execute}    ${actual_khachtt}
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
    ${get_id_sp1}    Get From List    ${list_id_sp}    0
    ${get_gia_ban1}    Get From List    ${list_giaban}    0
    ${input_soluong1}    Get From List    ${list_nums}    0
    ${get_id_order_detail1}    Get From List    ${get_list_order_detail_id}    0
    ${get_id_sp2}    Get From List    ${list_id_sp}    1
    ${get_gia_ban2}    Get From List    ${list_giaban}    1
    ${input_soluong2}    Get From List    ${list_nums}    1
    ${get_id_order_detail2}    Get From List    ${get_list_order_detail_id}    1
    #list payload of product new
    ${liststring_prs_order_detail}     Set Variable      needdel
    Log        ${liststring_prs_order_detail}
    : FOR   ${item_gia_ban}   ${item_id_sp}   ${item_soluong}   ${get_orderdetail_id}      IN ZIP   ${list_giaban_promo}        ${list_id_sp_promo}    ${list_promo_num}    ${get_list_order_detail_id_promo}
    \    ${payload_each_product}        Format string       {{"BasePrice":82000,"IsLotSerialControl":false,"IsRewardPoint":false,"Note":"","Price":{0},"ProductId":{1},"Quantity":{2},"ProductCode":"NK001","Discount":{0},"DiscountRatio":0,"ProductName":"Hạt tặng 1","SalePromotionId":{3},"PromotionParentProductId":{4},"ProductBatchExpireId":null,"CategoryId":794171,"MasterProductId":{1},"Unit":"","Uuid":"","OrderDetailId":{5},"ProductWarranty":[]}}   ${item_gia_ban}   ${item_id_sp}   ${item_soluong}    ${get_id_sale_promo}    ${get_id_sp1}   ${get_orderdetail_id}
    \    ${liststring_prs_order_detail}       Catenate      SEPARATOR=,      ${liststring_prs_order_detail}      ${payload_each_product}
    ${liststring_prs_order_detail}       Replace String      ${liststring_prs_order_detail}       needdel,       ${EMPTY}      count=1
    ${id_sp_promo}    Get From List     ${list_id_sp_promo}     0
    ${list_id_sp}   Convert list to string and return     ${list_id_sp}
    #post request
    ${request_payload}    Format String    {{"Invoice":{{"BranchId":{0},"RetailerId":{1},"OrderId":{2},"UpdateInvoiceId":0,"UpdateReturnId":0,"CustomerId":{3},"SoldById":{4},"SoldBy":{{"CreatedBy":0,"CreatedDate":"2018-07-30T08:27:36.800Z","GivenName":"anh.lv","Id":{4},"IsActive":true,"IsAdmin":true,"Type":0,"isDeleted":false,"Name":"anh.lv"}},"SaleChannelId":0,"Seller":{{"CreatedBy":0,"CreatedDate":"2018-07-30T08:27:36.800Z","GivenName":"anh.lv","Id":{4},"IsActive":true,"IsAdmin":true,"Type":0,"isDeleted":false,"Name":"anh.lv"}},"PriceBookId":0,"OrderCode":"{5}","Code":"Hóa đơn 2","Discount":{6},"InvoiceDetails":[{{"BasePrice":64000.02,"IsLotSerialControl":false,"IsRewardPoint":false,"Note":"","Price":{7},"ProductId":{8},"Quantity":{9},"ProductCode":"HH0044","Discount":0,"DiscountRatio":0,"ProductName":"Túi 8 Bánh Socola Kitkat Trà Xanh SB","IsMaster":true,"ProductBatchExpireId":null,"CategoryId":794169,"MasterProductId":{8},"Unit":"","Uuid":"","OrderDetailId":{10},"ProductWarranty":[]}},{11},{{"BasePrice":35000,"IsLotSerialControl":false,"IsRewardPoint":false,"Note":"","Price":{12},"ProductId":{13},"Quantity":{14},"ProductCode":"HH0045","Discount":0,"DiscountRatio":0,"ProductName":"Gói 6 Thanh Bánh Socola KitKat 2F 17g","IsMaster":true,"ProductBatchExpireId":null,"CategoryId":794169,"MasterProductId":{13},"Unit":"","Uuid":"","OrderDetailId":{15},"ProductWarranty":[]}}],"InvoiceOrderSurcharges":[],"InvoicePromotions":[{{"Discount":30000,"ProductIds":"{16}","ProductQty":2,"PromotionId":{17},"PromotionInfo":"KM theo HH hinh thuc mua hang tặng hàng: KM theo HH hinh thuc mua hang tặng hàng: Khi mua 1 HH0035 - Kem Hàn Quốc trà xanh XXXD, 1 HH0036 - Kem whipping cream Anchor tặng 4 HKM002 - Kẹo Hồng Sâm Vitamin Daegoung Food 2","RelatedCategoryIds":"1147662","RelatedProductId":{8},"RelatedProductIds":"{18}","RelatedProductQty":1,"SalePromotionId":{19},"TargetType":1,"Type":5,"PrintPromotionInfo":"Mua 1 Kem Hàn Quốc trà xanh XXXD, 1 Kem whipping cream Anchor tặng 4 Kẹo Hồng Sâm Vitamin Daegoung Food 2","RootRelatedCategoryIds":"1147662"}}],"Payments":[],"Status":1,"Total":97000,"Surcharge":0,"Type":1,"Uuid":"","addToAccount":"0","PayingAmount":0,"OrderPaidAmount":10000,"DepositReturn":0,"TotalBeforeDiscount":459000,"ProductDiscount":360000,"PaidAmount":10000,"DebugUuid":"156661688659029","InvoiceWarranties":[],"CreatedBy":201567}}}}    ${BRANCH_ID}    ${get_id_nguoitao}    ${get_order_id}    ${get_id_kh}    ${get_id_nguoiban}
    ...     ${order_code}     ${input_discount_inv}    ${get_gia_ban1}    ${get_id_sp1}    ${input_soluong1}   ${get_id_order_detail1}
    ...    ${liststring_prs_order_detail}    ${get_gia_ban2}    ${get_id_sp2}    ${input_soluong2}   ${get_id_order_detail2}    ${id_sp_promo}
    ...     ${get_id_promotion}   ${list_id_sp}    ${get_id_sale_promo}
    Log    ${request_payload}
    ${invoice_code}    Post request to create invoice and get invoice code    ${request_payload}
    #get values
    Sleep    20 s    wait for response to API
    #assert value invoice
    ${get_ma_kh_by_hd}    ${get_tong_tien_hang}    ${get_khachtt_af_execute}    ${get_gghd_af_execute}    ${get_khachcantra}    ${get_trangthai}    ${get_ghichu_in_hd_af_execute}
    ...    Get invoice info have note incase discount by invoice code    ${invoice_code}
    Should Be Equal As Numbers    ${get_tong_tien_hang}    ${get_tongtienhang_in_dh_bf_execute}
    Should Be Equal As Numbers    ${get_khachcantra}    ${result_khachcantra}
    Should Be Equal As Numbers    ${get_khachtt_af_execute}    ${result_khachdatra}
    Should Be Equal As Strings    ${get_ma_kh_by_hd}    ${input_ma_kh}
    Should Be Equal As Numbers    ${get_gghd_af_execute}    ${input_discount_inv}
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

edxhh03_api
    [Arguments]    ${dict_product_num}    ${input_discount_inv}    ${input_ma_kh}    ${input_bh_khachtt}    ${input_khuyemmai}    ${input_khtt_create_order}
    ...    ${dict_product_add}    ${list_ggsp}
    ## Get info ton cuoi, cong no khach hang
    Toggle status of promotion    ${input_khuyemmai}    1
    ${order_code}    Add new order with promotion buy every items at a fixed reduced price    ${input_ma_kh}    ${dict_product_num}    ${input_khuyemmai}    ${input_khtt_create_order}
    ${num_sale_product}    ${num_promo_product}    ${product_price}    ${discount}    ${discount_ratio}    ${name}    Get Number of sale product - promo product - promo value and name
    ...    ${input_khuyemmai}
    ${list_product}    Get Dictionary Keys    ${dict_product_num}
    ${list_nums}    Get Dictionary Values    ${dict_product_num}
    ${list_product_add}    Get Dictionary Keys    ${dict_product_add}
    ${list_nums_add}    Get Dictionary Values    ${dict_product_add}
    ${get_ma_dh_in_dh_bf_execute}    ${get_khachdatra_in_dh_bf_execute}    ${get_ggdh_in_dh_bf_execute}    ${get_tongtienhang_in_dh_bf_execute}    ${get_tongcong_in_dh_bf_execute}    Get order code - paid - discount value frm API    ${input_ma_kh}
    ${get_list_product_type}    ${list_tonkho_service}    Get list product type and ending stock of service frm API    ${list_product}
    ${get_list_thanhtien_in_dh}    ${get_list_soluong_in_dh}    ${get_list_tongso_dh_bf_execute}    ${get_list_ton_bf_execute}    Get list quantity - sub total - order summary - ending stock frm API    ${order_code}    ${list_product}
    ${list_result_order_summary}    ${result_list_toncuoi}    ${result_list_thanhtien}    Get list order summary - total sale - ending stocks frm API    ${order_code}    ${list_product}
    ${list_thanhtien_Add}    Create List
    ${get_list_baseprice}    Get list of Baseprice by Product Code    ${list_product_add}
    ${list_onhand}    Get list onhand frm API    ${list_product_add}
    : FOR    ${input_soluong}    ${get_ton_bf_execute}    ${item_giaban}    IN ZIP    ${list_nums_add}    ${list_onhand}    ${get_list_baseprice}
    \    ${result_toncuoi}    Minus and replace floating point    ${get_ton_bf_execute}    ${input_soluong}
    \    ${result_thanhtien}    Multiplication and round    ${item_giaban}    ${input_soluong}
    \    Append To List    ${result_list_toncuoi}    ${result_toncuoi}
    \    Append To List    ${list_thanhtien_Add}    ${result_thanhtien}
    #Compute
    ${result_tongtienhang_add}    Sum values in list    ${list_thanhtien_Add}
    ${result_tongtienhang}    Sum values in list    ${result_list_thanhtien}
    ${result_tongtienhang}    Sum and replace floating point    ${result_tongtienhang_add}     ${result_tongtienhang}
    ${result_tongsoluong}    Sum values in list    ${list_nums}
    ${result_gghd}    Convert % discount to VND and round    ${result_tongtienhang}    ${input_discount_inv}
    ${result_khachcantra}    Minus and replace floating point    ${result_tongtienhang}    ${result_gghd}
    ${result_khachcanthanhtoan}    Minus and replace floating point    ${result_khachcantra}        ${get_khachdatra_in_dh_bf_execute}
    ${actual_khachtt}    Set Variable If    '${input_bh_khachtt}' == 'all'    ${result_khachcanthanhtoan}    ${input_bh_khachtt}
    ${result_khachdatra}    Sum    ${get_khachdatra_in_dh_bf_execute}    ${actual_khachtt}
    ${result_tongcong}     Sum    ${result_khachcantra}    ${result_khachdatra}
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
    #list payload of product new
    ${list_jsonpath_id_sp_add}    ${list_jsonpath_giaban_add}    Get list jsonpath product frm list product    ${list_product_add}
    ${list_giaban_add}    ${list_id_sp_add}    Get product info frm list jsonpath product    ${get_resp_danhmuc_hh}     ${list_jsonpath_id_sp_add}    ${list_jsonpath_giaban_add}
    ${liststring_prs_order_detail_add}     Set Variable      needdel
    Log        ${liststring_prs_order_detail_add}
    : FOR   ${item_gia_ban_add}   ${item_id_sp_add}   ${item_soluong_add}      IN ZIP   ${list_giaban_add}        ${list_id_sp_add}    ${list_nums_add}
    \    ${payload_each_product_add}        Format string       {{"BasePrice":{0},"IsLotSerialControl":true,"IsRewardPoint":false,"Note":"","Price":{0},"ProductId":{1},"Quantity":{2},"ProductCode":"SI029","Discount":0,"DiscountRatio":0,"ProductName":"Ấm Điện Đun Nước Thủy Tinh Lock&Lock","ProductBatchExpireId":null,"CategoryId":794174,"MasterProductId":{1},"Unit":"","Uuid":"","ProductWarranty":[]}}   ${item_gia_ban}   ${item_id_sp_add}   ${item_soluong_add}
    \    ${liststring_prs_order_detail_add}       Catenate      SEPARATOR=,      ${liststring_prs_order_detail_add}      ${payload_each_product_add}
    ${liststring_prs_order_detail_add}       Replace String      ${liststring_prs_order_detail_add}       needdel,       ${EMPTY}      count=1
    ## get payload product
    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}    Get list jsonpath product frm list product    ${list_product}
    ${list_giaban}    ${list_id_sp}    Get product info frm list jsonpath product    ${get_resp_danhmuc_hh}     ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}
    ${get_id_sp}    Get From List     ${list_id_sp}     0
    ${liststring_prs_order_detail}     Set Variable      needdel
    Log        ${liststring_prs_order_detail}
    : FOR   ${item_gia_ban}   ${item_id_sp}   ${item_soluong}   ${get_orderdetail_id}      IN ZIP   ${list_giaban}        ${list_id_sp}    ${list_nums}    ${get_list_order_detail_id}
    \    ${result_ggsp}   Convert % discount to VND and round   ${item_gia_ban}    ${get_promo_discount}
    \    ${payload_each_product}        Format string       {{"BasePrice":{0},"IsLotSerialControl":true,"IsRewardPoint":false,"Note":"","Price":{0},"ProductId":{1},"Quantity":{2},"ProductCode":"SI029","Discount":{3},"DiscountRatio":{4},"ProductName":"Ấm Điện Đun Nước Thủy Tinh Lock&Lock","SalePromotionId":{5},"PromotionParentProductId":{6},"ProductBatchExpireId":null,"CategoryId":794174,"MasterProductId":{1},"Unit":"","Uuid":"","OrderDetailId":{7},"ProductWarranty":[]}}   ${item_gia_ban}   ${item_id_sp}   ${item_soluong}    ${result_ggsp}    ${get_promo_discount}    ${get_id_sale_promo}    ${get_id_sp}   ${get_orderdetail_id}
    \    ${liststring_prs_order_detail}       Catenate      SEPARATOR=,      ${liststring_prs_order_detail}      ${payload_each_product}
    ${liststring_prs_order_detail}       Replace String      ${liststring_prs_order_detail}       needdel,       ${EMPTY}      count=1
    ${list_id_sp}   Convert list to string and return     ${list_id_sp}
    #post request
    ${request_payload}    Format String    {{"Invoice":{{"BranchId":{0},"RetailerId":{1},"OrderId":{2},"UpdateInvoiceId":0,"UpdateReturnId":0,"CustomerId":{3},"SoldById":{4},"SoldBy":{{"CreatedBy":0,"CreatedDate":"2018-07-30T08:27:36.800Z","GivenName":"anh.lv","Id":{4},"IsActive":true,"IsAdmin":true,"Type":0,"isDeleted":false,"Name":"anh.lv"}},"SaleChannelId":0,"Seller":{{"CreatedBy":0,"CreatedDate":"2018-07-30T08:27:36.800Z","GivenName":"anh.lv","Id":{4},"IsActive":true,"IsAdmin":true,"Type":0,"isDeleted":false,"Name":"anh.lv"}},"PriceBookId":0,"OrderCode":"{5}","Code":"Hóa đơn 2","Discount":{6},"DiscountRatio":{7},"InvoiceDetails":[{8},{9}],"InvoiceOrderSurcharges":[],"InvoicePromotions":[{{"ProductId":{10},"ProductQty":2,"PromotionId":{11},"PromotionInfo":"KM theo HH hình thức giá bán theo SL mua GG %: Khi mua 3 DVT34 Kẹo Hồng Sâm Vitamin Daegoung Food (chiếc) giảm giá 20%","RelatedCategoryIds":"680827","RelatedProductId":{10},"RelatedProductIds":"{12}","SalePromotionId":{13},"TargetType":1,"Type":8,"PrintPromotionInfo":"Mua 3 Kẹo Hồng Sâm Vitamin Daegoung Food (chiếc) giảm giá 20%","ProductPrice":20,"DisplayPrice":299000,"PromotionApplicationType":"%"}}],"Payments":[{{"Method":"Cash","MethodStr":"Tiền mặt","Amount":{14},"Id":-1}}],"Status":1,"Total":2156400,"Surcharge":0,"Type":1,"Uuid":"","addToAccount":"0","PayingAmount":2056400,"OrderPaidAmount":100000,"DepositReturn":0,"TotalBeforeDiscount":2995000,"ProductDiscount":599000,"PaidAmount":100000,"DebugUuid":"15666193588915","InvoiceWarranties":[],"CreatedBy":201567}}}}    ${BRANCH_ID}    ${get_id_nguoitao}    ${get_order_id}    ${get_id_kh}    ${get_id_nguoiban}
    ...     ${order_code}    ${result_gghd}     ${input_discount_inv}    ${liststring_prs_order_detail_add}    ${liststring_prs_order_detail}
    ...       ${get_id_sp}     ${get_id_promotion}   ${list_id_sp}    ${get_id_sale_promo}    ${actual_khachtt}
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
    Should Be Equal As Numbers    ${get_gghd_af_execute}    ${result_gghd}
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
