*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}      ${headless_browser}
Resource          ../../../../config/env_product/envi.robot
Resource          ../../../../core/Doi_Tac/doitac_navigation.robot
Resource          ../../../../core/Doi_Tac/khachhang_list_action.robot
Resource          ../../../../core/Doi_Tac/khachhang_list_page.robot
Resource          ../../../../core/API/api_khachhang.robot
Resource          ../../../../core/share/toast_message.robot
Resource          ../../../../core/API/api_dathang.robot
Resource          ../../../../core/API/api_hoadon_banhang.robot
Resource          ../../../../core/API/api_danhmuc_hanghoa.robot
Resource          ../../../../core/API/api_mhbh.robot
Resource          ../../../../core/API/api_mhbh_dathang.robot
Resource          ../../../../core/API/api_soquy.robot
Resource          ../../../../prepare/Hang_hoa/Sources/doitac.robot

*** Variables ***
&{list_prs_num_invoice}    CNKH01=1
&{list_prs_num_order}    CNKHCB01=1    QDCNKH02=2
@{list_prs_order_del}    QDCNKH02
@{discount}    5     50000
@{discount_type}    dis     changeup


*** Test Cases ***    Mã KH       Tên KH            List products invoice      List product order       List prodcut del             List discount      List discount type     Discount invoice         Payment to invoice    Thanh toán dư
Dat hang               [Tags]      APBKH
                      [Template]    phanbo1
                      KHPBCN1     Khách công nợ 1     ${list_prs_num_invoice}      ${list_prs_num_order}    ${list_prs_order_del}       ${discount}     ${discount_type}          10000                  200000                  50000

*** Keywords ***
phanbo1
    [Arguments]    ${input_ma_kh}    ${input_ten_kh}    ${list_product_invoice}    ${list_product_order}   ${list_product_delete}    ${list_ggsp}   ${list_discount_type}
    ...   ${input_ggdh}   ${input_khtt_tocreate_invoice}   ${input_thanhtoandu}
    ##delete customer
    ${get_customer_id}    Get customer id thr API    ${input_ma_kh}
    Run Keyword If    '${get_customer_id}' == '0'    Log    Ignore delete     ELSE      Delete customer    ${get_customer_id}
    Sleep    1s
    ## create customer
    ${date_current}   Get Current Date      result_format=%Y-%m-%d
    Add customer with birthday    ${input_ma_kh}    ${input_ten_kh}    ${date_current}
    Sleep    2s
    ${ma_hd}  Add new invoice - payment - enter into account frm API    ${input_ma_kh}    ${list_product_invoice}    ${input_khtt_tocreate_invoice}
    ${order_code}   Add new order incase discount - no payment    ${input_ma_kh}    ${input_ggdh}    ${list_product_order}    ${list_ggsp}    ${list_discount_type}
    ${get_no_bf_execute}    ${get_tongban_bf_execute}    ${get_tongban_tru_trahang_bf_execute}    ${get_customer_name}    Get Customer Info from API    ${input_ma_kh}
    ${get_list_hh_in_dh_bf_execute}    ${get_ghichu_bf_execute}    Get ghi chu and list product frm API    ${order_code}
    #get order summary and sub total of products
    : FOR    ${ma_hh}   IN    @{list_product_delete}
    \    Remove Values From List    ${get_list_hh_in_dh_bf_execute}    ${ma_hh}
    Log    ${get_list_hh_in_dh_bf_execute}
    ${get_list_quantity_in_dh_bf_ex}    ${get_list_discount_in_dh_bf_ex}   Get list quantity and discount by order code    ${order_code}    ${get_list_hh_in_dh_bf_execute}
    ${list_result_tongdh}    ${result_list_toncuoi}    ${result_list_thanhtien}   ${list_result_giamoi}    Get list order summary - total sale - ending stocks incase discount    ${order_code}    ${get_list_hh_in_dh_bf_execute}    ${get_list_discount_in_dh_bf_ex}
    ##compute cong no khac hang
    ${result_tongtienhang}    Sum values in list    ${result_list_thanhtien}
    ${result_TTH_tru_gghd}   Minus and replace floating point    ${result_tongtienhang}   ${input_ggdh}
    ${result_khtt}    Sum    ${result_TTH_tru_gghd}    ${input_thanhtoandu}
    ##phan bo hoa don
    ${result_phanbo_hoadon}   Sum    ${input_khtt_tocreate_invoice}       ${input_thanhtoandu}
    ##du no khach hang
    ${result_du_no_hd_KH}    Sum    ${get_no_bf_execute}    ${result_TTH_tru_gghd}
    ${result_PTT_hd_KH}    Minus and replace floating point    ${result_du_no_hd_KH}    ${result_khtt}
    ${result_tongban_KH}    Sum and replace floating point    ${result_TTH_tru_gghd}    ${get_tongban_bf_execute}
    #create invoice frm Order API
    ${get_invoice_id}    Get invoice id    ${ma_hd}
    ${get_order_id}   ${get_payment_id}   Get order - payment frm order api    ${order_code}
    ${get_list_order_detail_id}   Get list orderdetail id frm order api    ${order_code}    ${get_list_hh_in_dh_bf_execute}
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${jsonpath_id_kh}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_kh}
    ${get_id_kh}    Get data from API    ${endpoint_khachhang}    ${jsonpath_id_kh}
    ${endpoint_danhmuc_hh_co_dvt}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${get_resp_danhmuc_hh}    Get Request and return body    ${endpoint_danhmuc_hh_co_dvt}
    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}    Get list jsonpath product frm list product    ${get_list_hh_in_dh_bf_execute}
    ${list_giaban}    ${list_result_ggsp}    ${list_id_sp}    Get product info frm list jsonpath product have discount product    ${get_resp_danhmuc_hh}    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}    ${get_list_discount_in_dh_bf_ex}
    ${liststring_prs_order_detail}     Set Variable      needdel
    Log        ${liststring_prs_order_detail}
    : FOR    ${item_gia_ban}   ${item_id_sp}   ${item_soluong}    ${item_result_ggsp}   ${item_ggsp}   ${item_orderdetail_id}      IN ZIP      ${list_giaban}        ${list_id_sp}    ${get_list_quantity_in_dh_bf_ex}    ${list_result_ggsp}    ${get_list_discount_in_dh_bf_ex}       ${get_list_order_detail_id}
    \    ${payload_each_product}        Format string       {{"BasePrice":{0},"IsLotSerialControl":false,"IsRewardPoint":false,"Note":"","Price":{0},"ProductId":{1},"Quantity":{2},"ProductCode":"HH0042","Discount":{3},"DiscountRatio":{4},"ProductName":"Bánh Trứng Tik-Tok Bơ Sữa (120g)","OriginPrice":{0},"PriceByPromotion":null,"IsMaster":true,"PromotionParentProductId":null,"ProductBatchExpireId":null,"CategoryId":794169,"MasterProductId":{1},"Unit":"","Uuid":"","OrderDetailId":{5},"ProductWarranty":[]}}    ${item_gia_ban}   ${item_id_sp}   ${item_soluong}    ${item_result_ggsp}   ${item_ggsp}   ${item_orderdetail_id}
    \    ${liststring_prs_order_detail}       Catenate      SEPARATOR=,      ${liststring_prs_order_detail}      ${payload_each_product}
    ${liststring_prs_order_detail}       Replace String      ${liststring_prs_order_detail}       needdel,       ${EMPTY}      count=1
    ${request_payload}    Format String    {{"Invoice":{{"BranchId":{0},"RetailerId":{1},"OrderId":{2},"UpdateInvoiceId":0,"UpdateReturnId":0,"CustomerId":{3},"SoldById":{4},"SoldBy":{{"CreatedBy":0,"CreatedDate":"2018-07-30T08:27:36.800Z","GivenName":"anh.lv","Id":{4},"IsActive":true,"IsAdmin":true,"Type":0,"isDeleted":false,"Name":"anh.lv"}},"SaleChannelId":0,"Seller":{{"CreatedBy":0,"CreatedDate":"2018-07-30T08:27:36.800Z","GivenName":"anh.lv","Id":{4},"IsActive":true,"IsAdmin":true,"Type":0,"isDeleted":false,"Name":"anh.lv"}},"PriceBookId":0,"OrderCode":"{5}","Code":"Hóa đơn 2","Discount":{6},"InvoiceDetails":[{7}],"InvoiceOrderSurcharges":[],"InvoicePromotions":[],"Payments":[{{"Method":"Cash","MethodStr":"Tiền mặt","Amount":{8},"Id":-1}}],"PaymentsAllocations":[{{"AccountId":0,"Method":"","Amount":{9},"InvoiceId":{10},"DocumentCode":"{11}","CodNeedPayment":0,"IsCompleteInvoice":false,"AutoAllocation":1}}],"Status":1,"Total":{12},"Surcharge":0,"Type":1,"Uuid":"","addToAccount":"1","addToAccountAllocation":"1","PayingAmount":{8},"OrderPaidAmount":0,"TotalBeforeDiscount":{13},"ProductDiscount":0,"PaidAmount":0,"DebugUuid":"","InvoiceWarranties":[],"CreatedBy":201567}}}}     ${BRANCH_ID}    ${get_id_nguoitao}    ${get_order_id}    ${get_id_kh}    ${get_id_nguoiban}   ${order_code}     ${input_ggdh}    ${liststring_prs_order_detail}    ${result_khtt}
    ...    ${input_thanhtoandu}    ${get_invoice_id}    ${ma_hd}   ${result_TTH_tru_gghd}   ${result_tongtienhang}
    Log    ${request_payload}
    ${invoice_code}    Post request to create invoice and get invoice code    ${request_payload}
    Sleep    20 s    wait for response to API
    #assert value product in invoice
    ${get_list_hh_in_hd_af_execute}    Get list product frm Invoice API    ${invoice_code}
    ${list_soluong_in_hd}    ${list_giatri_quydoi_in_hd}    Get list quantity and gia tri quy doi by invoice code    ${get_list_hh_in_hd_af_execute}    ${invoice_code}
    : FOR    ${ma_hh}    ${result_toncuoi}    ${item_soluong}    ${get_giatri_quydoi}    IN ZIP    ${get_list_hh_in_hd_af_execute}
    ...    ${result_list_toncuoi}    ${list_soluong_in_hd}    ${list_giatri_quydoi_in_hd}
    \    Run Keyword If    '${get_giatri_quydoi}' == '1'    Validate product history frm API    ${invoice_code}    ${ma_hh}    ${result_toncuoi}
    \    ...    ${item_soluong}
    \    ...    ELSE    Validate unit product history frm API    ${invoice_code}    ${ma_hh}    ${result_toncuoi}   ${item_soluong}    ${get_giatri_quydoi}
    ##validate invoice allocate
    ${get_maphieu_soquy}    Get Ma Phieu Thu in So quy    ${invoice_code}
    ${get_khachtt_af_allocate}    ${get_ptt_af_allocate}    Get invoice info after allocate     ${ma_hd}    ${get_maphieu_soquy}
    Should Be Equal As Numbers    ${get_khachtt_af_allocate}    ${result_phanbo_hoadon}
    Should Be Equal As Numbers    ${get_ptt_af_allocate}    ${input_thanhtoandu}
    #assert customer and so quy
    ${get_no_af_execute_kh}    ${get_tongban_af_execute_kh}    ${get_tongban_tru_trahang_af_execute_kh}    Get Customer Debt from API after purchase    ${input_ma_kh}    ${invoice_code}    ${result_khtt}
    Should Be Equal As Numbers    ${get_no_af_execute_kh}    ${result_PTT_hd_KH}
    Should Be Equal As Numbers    ${get_tongban_af_execute_kh}    ${result_tongban_KH}
    Run Keyword If    '${result_tongtienhang}' == '0'    Validate history tab of customer frm Order    ${input_ma_kh}    ${invoice_code}
    Validate customer history and debt if invoice is paid frm order    ${input_ma_kh}    ${invoice_code}    ${result_du_no_hd_KH}    ${result_PTT_hd_KH}
    Validate So quy info from Rest API if Invoice is paid    ${get_maphieu_soquy}    ${result_khtt}
    Delete invoice by invoice code    ${ma_hd}
    Delete invoice by invoice code    ${invoice_code}
    Delete order frm Order code       ${order_code}
    ${get_customer_id}    Get Customer ID    ${input_ma_kh}
    Delete customer    ${get_customer_id}
