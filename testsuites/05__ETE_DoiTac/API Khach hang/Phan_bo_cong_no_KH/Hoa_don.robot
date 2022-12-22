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
&{list_prs_num_invoice1}    CNKHS01=1
&{list_prs_num_invoice2}    CNKHDV01=3
@{discount}    20000
@{discount_type}    disvnd


*** Test Cases ***    Mã KH        Tên KH         List products invoice 1     List products invoice 2      List discount      List discount type     Payment to invoice    Thanh toán dư
Thanh toan du         [Tags]      APBKH
                      [Template]    phanbo2
                      KHPBCN2     Khách công nợ 2      ${list_prs_num_invoice1}      ${list_prs_num_invoice2}      ${discount}          ${discount_type}    500000                  100000

Thanh toan no           [Tags]      APBKH
                      [Template]    phanbo3
                      KHPBCN3     Khách công nợ 3      ${list_prs_num_invoice1}      ${list_prs_num_invoice2}      ${discount}          ${discount_type}      15      1000000                  100000

*** Keywords ***
phanbo2
    [Arguments]    ${input_ma_kh}    ${input_ten_kh}    ${list_product_invoice1}    ${list_product_invoice2}    ${list_ggsp}   ${list_discount_type}
    ...   ${input_khtt_tocreate_invoice}   ${input_thanhtoandu}
    ##delete customer
    ${get_customer_id}    Get customer id thr API    ${input_ma_kh}
    Run Keyword If    '${get_customer_id}' == '0'    Log    Ignore delete     ELSE      Delete customer    ${get_customer_id}
    Sleep    1s
    ## create customer
    ${date_current}   Get Current Date      result_format=%Y-%m-%d
    Add customer with birthday    ${input_ma_kh}    ${input_ten_kh}    ${date_current}
    Sleep    2s
    ${ma_hd}  Add new invoice - payment surplus frm API    ${input_ma_kh}    ${list_product_invoice1}    ${input_khtt_tocreate_invoice}
    ${get_no_bf_execute}    ${get_tongban_bf_execute}    ${get_tongban_tru_trahang_bf_execute}    ${get_customer_name}    Get Customer Info from API    ${input_ma_kh}
    ${list_product}   Get Dictionary Keys    ${list_product_invoice2}
    ${list_nums}   Get Dictionary Values    ${list_product_invoice2}
    #get order summary and sub total of products
    ${result_list_toncuoi}    ${result_list_thanhtien}    Get list total sale - endingstock incase discount by product list    ${list_product}    ${list_nums}    ${list_ggsp}
    ##compute cong no khac hang
    ${result_tongtienhang}    Sum values in list    ${result_list_thanhtien}
    ${result_khtt}    Sum    ${result_tongtienhang}    ${input_thanhtoandu}
    ##phan bo hoa don
    ${result_phanbo_hoadon}   Sum    ${input_khtt_tocreate_invoice}       ${input_thanhtoandu}
    ##du no khach hang
    ${result_du_no_hd_KH}    Sum    ${get_no_bf_execute}    ${result_tongtienhang}
    ${result_PTT_hd_KH}    Minus and replace floating point    ${result_du_no_hd_KH}    ${result_khtt}
    ${result_tongban_KH}    Sum and replace floating point    ${result_tongtienhang}    ${get_tongban_bf_execute}
    #create invoice frm Order API
    ${get_invoice_id}    Get invoice id    ${ma_hd}
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${jsonpath_id_kh}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_kh}
    ${get_id_kh}    Get data from API    ${endpoint_khachhang}    ${jsonpath_id_kh}
    ${endpoint_danhmuc_hh_co_dvt}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${get_resp_danhmuc_hh}    Get Request and return body    ${endpoint_danhmuc_hh_co_dvt}
    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}    Get list jsonpath product frm list product    ${list_product}
    ${list_giaban}    ${list_id_sp}    Get product info frm list jsonpath product    ${get_resp_danhmuc_hh}    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}
    ${liststring_prs_order_detail}     Set Variable      needdel
    Log        ${liststring_prs_order_detail}
    : FOR    ${item_gia_ban}   ${item_id_sp}   ${item_soluong}   ${item_ggsp}      IN ZIP      ${list_giaban}        ${list_id_sp}    ${list_nums}    ${list_ggsp}
    \    ${payload_each_product}        Format string       {{"BasePrice":{0},"IsLotSerialControl":false,"IsRewardPoint":false,"Note":"","Price":{0},"ProductId":{1},"Quantity":{2},"ProductCode":"HH0042","Discount":{3},"DiscountRatio":0,"ProductName":"Bánh Trứng Tik-Tok Bơ Sữa (120g)","OriginPrice":{0},"PriceByPromotion":null,"IsMaster":true,"PromotionParentProductId":null,"ProductBatchExpireId":null,"CategoryId":794169,"MasterProductId":{1},"Unit":"","Uuid":"","ProductWarranty":[]}}    ${item_gia_ban}   ${item_id_sp}   ${item_soluong}   ${item_ggsp}
    \    ${liststring_prs_order_detail}       Catenate      SEPARATOR=,      ${liststring_prs_order_detail}      ${payload_each_product}
    ${liststring_prs_order_detail}       Replace String      ${liststring_prs_order_detail}       needdel,       ${EMPTY}      count=1
    ${request_payload}    Format String    {{"Invoice":{{"BranchId":{0},"RetailerId":{1},"UpdateInvoiceId":0,"UpdateReturnId":0,"CustomerId":{2},"SoldById":{3},"SoldBy":{{"CreatedBy":0,"CreatedDate":"2018-07-30T08:27:36.800Z","Email":"","GivenName":"anh.lv","Id":{3},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false}},"SaleChannelId":0,"SaleChannel":null,"Seller":{{"CreatedBy":0,"CreatedDate":"2018-07-30T08:27:36.800Z","Email":"","GivenName":"anh.lv","Id":{3},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false}},"OrderCode":"","Code":"Hóa đơn 1","InvoiceDetails":[{4}],"InvoiceOrderSurcharges":[],"InvoicePromotions":[],"Payments":[{{"Method":"Cash","MethodStr":"Tiền mặt","Amount":{5},"Id":-1}}],"PaymentsAllocations":[{{"AccountId":0,"Method":"","Amount":{6},"InvoiceId":{7},"DocumentCode":"{8}","CodNeedPayment":0,"IsCompleteInvoice":false,"AutoAllocation":1}}],"Status":1,"Total":{9},"Surcharge":0,"Type":1,"Uuid":"","addToAccount":"1","addToAccountSurplus":"0","addToAccountAllocation":"1","addToAccountPaymentAllocation":"0","PayingAmount":{5},"TotalBeforeDiscount":{9},"ProductDiscount":0,"DebugUuid":"","InvoiceWarranties":[],"CreatedBy":201567}}}}     ${BRANCH_ID}    ${get_id_nguoitao}    ${get_id_kh}    ${get_id_nguoiban}   ${liststring_prs_order_detail}    ${result_khtt}   ${input_thanhtoandu}    ${get_invoice_id}    ${ma_hd}
    ...    ${result_tongtienhang}
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
    ${get_customer_id}    Get Customer ID    ${input_ma_kh}
    Delete customer    ${get_customer_id}

phanbo3
    [Arguments]    ${input_ma_kh}    ${input_ten_kh}    ${list_product_invoice1}    ${list_product_invoice2}    ${list_ggsp}   ${list_discount_type}   ${input_gghd}
    ...   ${input_khtt_tocreate_invoice}   ${input_khtt}
    ##delete customer
    ${get_customer_id}    Get customer id thr API    ${input_ma_kh}
    Run Keyword If    '${get_customer_id}' == '0'    Log    Ignore delete     ELSE      Delete customer    ${get_customer_id}
    Sleep    1s
    ## create customer
    ${date_current}   Get Current Date      result_format=%Y-%m-%d
    Add customer with birthday    ${input_ma_kh}    ${input_ten_kh}    ${date_current}
    Sleep    2s
    ${ma_hd}  Add new invoice - payment allocation frm API    ${input_ma_kh}    ${list_product_invoice1}    ${input_khtt_tocreate_invoice}
    ${get_no_bf_execute}    ${get_tongban_bf_execute}    ${get_tongban_tru_trahang_bf_execute}    ${get_customer_name}    Get Customer Info from API    ${input_ma_kh}
    ${list_product}   Get Dictionary Keys    ${list_product_invoice2}
    ${list_nums}   Get Dictionary Values    ${list_product_invoice2}
    ${get_khachcantra}    ${get_khachthanhtoan}   Get paid value from invoice api    ${ma_hd}
    #get order summary and sub total of products
    ${result_list_toncuoi}    ${result_list_thanhtien}    Get list total sale - endingstock incase discount by product list    ${list_product}    ${list_nums}    ${list_ggsp}
    ##compute cong no khac hang
    ${result_tongtienhang}    Sum values in list    ${result_list_thanhtien}
    ${result_gghd}    Run Keyword If    0 < ${input_gghd} < 100    Convert % discount to VND and round    ${result_tongtienhang}    ${input_gghd}
    ...    ELSE    Set Variable    ${input_gghd}
    ${result_TTH_tru_gghd}    Minus and replace floating point    ${result_tongtienhang}    ${result_gghd}
    ${result_phanbo_hoadon}   Minus and replace floating point    ${input_khtt_tocreate_invoice}       ${get_khachcantra}
    ${result_khtt}    Sum    ${input_khtt}    ${result_phanbo_hoadon}
    ##du no khach hang
    ${result_du_no_hd_KH}    Sum    ${get_no_bf_execute}    ${result_TTH_tru_gghd}
    ${result_PTT_hd_KH}    Minus and replace floating point    ${result_du_no_hd_KH}    ${input_khtt}
    ${result_tongban_KH}    Sum and replace floating point    ${result_TTH_tru_gghd}    ${get_tongban_bf_execute}
    #create invoice frm Order API
    ${get_maphieu_soquy}    Get Ma Phieu Thu in So quy    ${ma_hd}
    ${get_id_allocate}    Get allocation id frm sale api    ${input_ma_kh}    ${get_maphieu_soquy}
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${jsonpath_id_kh}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_kh}
    ${get_id_kh}    Get data from API    ${endpoint_khachhang}    ${jsonpath_id_kh}
    ${endpoint_danhmuc_hh_co_dvt}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${get_resp_danhmuc_hh}    Get Request and return body    ${endpoint_danhmuc_hh_co_dvt}
    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}    Get list jsonpath product frm list product    ${list_product}
    ${list_giaban}    ${list_id_sp}    Get product info frm list jsonpath product    ${get_resp_danhmuc_hh}    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}
    ${liststring_prs_order_detail}     Set Variable      needdel
    Log        ${liststring_prs_order_detail}
    : FOR    ${item_gia_ban}   ${item_id_sp}   ${item_soluong}   ${item_ggsp}      IN ZIP      ${list_giaban}        ${list_id_sp}    ${list_nums}    ${list_ggsp}
    \    ${payload_each_product}        Format string       {{"BasePrice":{0},"IsLotSerialControl":false,"IsRewardPoint":false,"Note":"","Price":{0},"ProductId":{1},"Quantity":{2},"ProductCode":"HH0042","Discount":{3},"DiscountRatio":0,"ProductName":"Bánh Trứng Tik-Tok Bơ Sữa (120g)","OriginPrice":{0},"PriceByPromotion":null,"IsMaster":true,"PromotionParentProductId":null,"ProductBatchExpireId":null,"CategoryId":794169,"MasterProductId":{1},"Unit":"","Uuid":"","ProductWarranty":[]}}    ${item_gia_ban}   ${item_id_sp}   ${item_soluong}   ${item_ggsp}
    \    ${liststring_prs_order_detail}       Catenate      SEPARATOR=,      ${liststring_prs_order_detail}      ${payload_each_product}
    ${liststring_prs_order_detail}       Replace String      ${liststring_prs_order_detail}       needdel,       ${EMPTY}      count=1
    ${request_payload}    Format String    {{"Invoice":{{"BranchId":{0},"RetailerId":{1},"UpdateInvoiceId":0,"UpdateReturnId":0,"CustomerId":{2},"SoldById":{3},"SoldBy":{{"CreatedBy":0,"CreatedDate":"2018-07-30T08:27:36.800Z","Email":"","GivenName":"anh.lv","Id":{3},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false}},"SaleChannelId":0,"SaleChannel":null,"Seller":{{"CreatedBy":0,"CreatedDate":"2018-07-30T08:27:36.800Z","Email":"","GivenName":"anh.lv","Id":{3},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false}},"OrderCode":"","Code":"Hóa đơn 1","Discount":{4},"DiscountRatio":{5},"InvoiceDetails":[{6}],"InvoiceOrderSurcharges":[],"InvoicePromotions":[],"Payments":[{{"Method":"Cash","MethodStr":"Tiền mặt","Amount":{7},"Id":-1}}],"PaymentSurplus":[{{"AccountId":0,"Method":"","Amount":{8},"InvoiceId":{9},"Id":{9},"DocumentCode":"{10}","CodNeedPayment":0,"IsCompleteInvoice":false,"AutoAllocation":1}}],"Status":1,"Total":{11},"Surcharge":0,"Type":1,"Uuid":"","addToAccount":"0","addToAccountSurplus":"1","addToAccountAllocation":"0","addToAccountPaymentAllocation":"1","PayingAmount":{7},"TotalBeforeDiscount":{12},"ProductDiscount":0,"DebugUuid":"","InvoiceWarranties":[],"CreatedBy":201567}}}}     ${BRANCH_ID}    ${get_id_nguoitao}    ${get_id_kh}    ${get_id_nguoiban}       ${result_gghd}    ${input_gghd}   ${liststring_prs_order_detail}    ${input_khtt}
    ...   ${result_phanbo_hoadon}    ${get_id_allocate}    ${get_maphieu_soquy}    ${result_TTH_tru_gghd}    ${result_tongtienhang}
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
    ${get_khachtt_af_allocate}    ${get_ptt_af_allocate}    Get invoice info after allocate     ${invoice_code}    ${get_maphieu_soquy}
    Should Be Equal As Numbers    ${get_khachtt_af_allocate}    ${result_khtt}
    Should Be Equal As Numbers    ${get_ptt_af_allocate}    ${result_phanbo_hoadon}
    #assert customer and so quy
    ${get_maphieu_soquy2}    Get Ma Phieu Thu in So quy    ${invoice_code}
    ${get_no_af_execute_kh}    ${get_tongban_af_execute_kh}    ${get_tongban_tru_trahang_af_execute_kh}    Get Customer Debt from API after purchase    ${input_ma_kh}    ${invoice_code}    ${input_khtt}
    Should Be Equal As Numbers    ${get_no_af_execute_kh}    ${result_PTT_hd_KH}
    Should Be Equal As Numbers    ${get_tongban_af_execute_kh}    ${result_tongban_KH}
    Run Keyword If    '${result_tongtienhang}' == '0'    Validate history tab of customer frm Order    ${input_ma_kh}    ${invoice_code}
    Validate customer history and debt if invoice is paid frm order    ${input_ma_kh}    ${invoice_code}    ${result_du_no_hd_KH}    ${result_PTT_hd_KH}
    Validate So quy info from Rest API if Invoice is paid    ${get_maphieu_soquy2}    ${input_khtt}
    Delete invoice by invoice code    ${ma_hd}
    Delete invoice by invoice code    ${invoice_code}
    ${get_customer_id}    Get Customer ID    ${input_ma_kh}
    Delete customer    ${get_customer_id}
