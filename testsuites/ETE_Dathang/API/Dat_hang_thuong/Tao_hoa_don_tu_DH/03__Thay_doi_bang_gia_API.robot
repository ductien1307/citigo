*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}      ${headless_browser}
Test Setup
Test Teardown     After Test
Library           Collections
Library           BuiltIn
Resource          ../../../../../config/env_product/envi.robot
Resource          ../../../../../core/API/api_mhbh_dathang.robot
Resource          ../../../../../core/API/api_danhmuc_hanghoa.robot
Resource          ../../../../../core/API/api_dathang.robot
Resource          ../../../../../core/API/api_khachhang.robot
Resource          ../../../../../core/API/api_mhbh.robot
Resource          ../../../../../core/Dat_Hang/dat_hang_action.robot
Resource          ../../../../../core/Dat_Hang/dat_hang_navigation.robot
Resource          ../../../../../core/Dat_Hang/dat_hang_page.robot
Resource          ../../../../../core/share/toast_message.robot
Resource          ../../../../../core/API/api_soquy.robot
Resource          ../../../../../config/env_product/envi.robot

*** Variables ***
&{dict_product01}    HH0055=2.5    SI038=2    QD124=3    DV062=2.5    Combo39=1

*** Test Cases ***    Mã KH         Tên Bảng giá         GGDH     Khách thanh toán    List product
Thay doi bang gia     [Tags]        AEDX1       ED
                      [Template]    aetedh_create_inv7
                      CTKH099       Bảng giá hóa đơn     20000    500000              ${dict_product01}

*** Keywords ***
aetedh_create_inv7
    [Arguments]    ${input_ma_kh}    ${input_ten_bangia}    ${input_gghd}    ${input_khtt}    ${dict_product_nums_create}
    Set Selenium Speed    0.5s
    #get info product, customer
    ${order_code}    Add new order with multi product and no payment - get order code    ${input_ma_kh}    ${dict_product_nums_create}
    ${get_khachdatra_in_dh_bf_execute}    ${get_tongtienhang_in_dh_bf_execute}    Get paid value frm API    ${order_code}
    ${get_list_hh_in_dh_bf_execute}    ${get_ghichu_bf_execute}    Get ghi chu and list product frm API    ${order_code}
    ${get_list_nums_in_dh}    Get list quantity by order code    ${order_code}    ${get_list_hh_in_dh_bf_execute}
    ${list_result_tongdh}    ${result_list_toncuoi}    ${result_list_thanhtien}    ${list_giaban_new}    Change pricebook and get list order summary and ending stocks frm API    ${order_code}    ${get_list_hh_in_dh_bf_execute}
    ...    ${input_ten_bangia}
    #create imei
    Create list imei and other product    ${get_list_hh_in_dh_bf_execute}    ${get_list_nums_in_dh}
    ${get_id_banggia}    ${list_giaban_new}    Get list gia ban from PriceBook api    ${input_ten_bangia}    ${get_list_hh_in_dh_bf_execute}
    #compute invoice info
    ${result_tongtienhang}    Sum values in list    ${result_list_thanhtien}
    ${result_TTH_tru_gghd}    Minus and replace floating point    ${result_tongtienhang}    ${input_gghd}
    ${result_khachcantra}    Minus and replace floating point    ${result_TTH_tru_gghd}    ${get_khachdatra_in_dh_bf_execute}
    ${actual_khtt_all}    Set Variable If    '${input_khtt}' == 'all'    ${result_khachcantra}    ${input_khtt}
    ${actual_khtt}    Set Variable If    '${input_khtt}' == '0'    0    ${actual_khtt_all}
    #compute order info
    ${actual_khtt_paymented}    Sum and replace floating point    ${actual_khtt}    ${get_khachdatra_in_dh_bf_execute}
    #create invoice
    ${get_order_id}   ${get_payment_id}   Get order - payment frm order api    ${order_code}
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${jsonpath_id_kh}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_kh}
    ${get_id_kh}    Get data from API    ${endpoint_khachhang}    ${jsonpath_id_kh}
    ${endpoint_danhmuc_hh_co_dvt}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${get_resp_danhmuc_hh}    Get Request and return body    ${endpoint_danhmuc_hh_co_dvt}
    ${get_list_order_detail_id}   Get list orderdetail id frm order api    ${order_code}    ${get_list_hh_in_dh_bf_execute}
    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}    Get list jsonpath product frm list product    ${get_list_hh_in_dh_bf_execute}
    ${list_giaban}    ${list_id_sp}    Get product info frm list jsonpath product    ${get_resp_danhmuc_hh}    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}
    ${liststring_prs_order_detail}     Set Variable      needdel
    Log        ${liststring_prs_order_detail}
    : FOR    ${item_gia_ban}   ${item_id_sp}   ${item_soluong}    ${item_imei}    ${item_orderdetail_id}      IN ZIP      ${list_giaban_new}
    ...    ${list_id_sp}    ${get_list_nums_in_dh}    ${imei_inlist}    ${get_list_order_detail_id}
    \    ${item_imei}    Convert list to string and return    ${item_imei}
    \    ${payload_each_product}        Format string       {{"BasePrice":{0},"IsLotSerialControl":true,"IsRewardPoint":false,"Note":"","Price":{0},"ProductId":{1},"Quantity":{2},"ProductCode":"SI059","SerialNumbers":"{3}","ProductName":"Tủ Lạnh Inverter Panasonic NR-BL267VSV1","PriceByPromotion":null,"IsMaster":true,"PromotionParentProductId":null,"ProductBatchExpireId":null,"CategoryId":543560,"MasterProductId":{1},"Unit":"","Uuid":"","OrderDetailId":{4},"ProductWarranty":[]}}    ${item_gia_ban}   ${item_id_sp}   ${item_soluong}       ${item_imei}    ${item_orderdetail_id}
    \    ${liststring_prs_order_detail}       Catenate      SEPARATOR=,      ${liststring_prs_order_detail}      ${payload_each_product}
    ${liststring_prs_order_detail}       Replace String      ${liststring_prs_order_detail}       needdel,       ${EMPTY}      count=1
    ${request_payload}    Format String    {{"Invoice":{{"BranchId":{0},"RetailerId":{1},"OrderId":{2},"CustomerId":{3},"SoldById":{4},"SoldBy":{{"CreatedBy":0,"CreatedDate":"2018-12-10T10:44:15.970Z","Email":"","GivenName":"admin","Id":{4},"IsActive":true,"IsAdmin":true,"Type":0,"UserName":"admin","isDeleted":false,"Name":"admin"}},"SaleChannelId":0,"Seller":{{"CreatedBy":0,"CreatedDate":"2018-12-10T10:44:15.970Z","Email":"","GivenName":"admin","Id":{4},"IsActive":true,"IsAdmin":true,"Type":0,"UserName":"admin","isDeleted":false,"Name":"admin"}},"PriceBookId":{5},"OrderCode":"{6}","Code":"Hóa đơn 1","Discount":{7},"InvoiceDetails":[{8}],"InvoiceOrderSurcharges":[],"InvoicePromotions":[],"Payments":[{{"Method":"Cash","MethodStr":"Tiền mặt","Amount":{9},"Id":-1}}],"Status":1,"Total":{10},"Surcharge":0,"Type":1,"Uuid":"","addToAccount":"0","PayingAmount":{9},"OrderPaidAmount":{11},"DepositReturn":0,"TotalBeforeDiscount":{10},"ProductDiscount":384000,"PaidAmount":{9},"DebugUuid":"","InvoiceWarranties":[],"CreatedBy":201567}}}}     ${BRANCH_ID}    ${get_id_nguoitao}    ${get_order_id}    ${get_id_kh}    ${get_id_nguoiban}
    ...    ${get_id_banggia}   ${order_code}     ${input_gghd}    ${liststring_prs_order_detail}   ${actual_khtt}     ${result_tongtienhang}    ${get_khachdatra_in_dh_bf_execute}
    Log    ${request_payload}
    ${invoice_code}    Post request to create invoice and get invoice code    ${request_payload}
    #get value
    Sleep    20s    wait for response to API
    #validate product
    ${list_order_summary_af_execute}    Get list order summary frm product API    ${get_list_hh_in_dh_bf_execute}
    ${list_giaban_in_hd}    Get list price after change pricebook frm invoice API    ${get_list_hh_in_dh_bf_execute}    ${invoice_code}
    : FOR    ${result_tong_dh}    ${order_summary_af_execute}    ${get_giaban_in_hd}    ${giaban_new}    IN ZIP    ${list_result_tongdh}
    ...    ${list_order_summary_af_execute}    ${list_giaban_in_hd}    ${list_giaban_new}
    \    Should Be Equal As Numbers    ${order_summary_af_execute}    ${result_tong_dh}
    \    Should Be Equal As Numbers    ${get_giaban_in_hd}    ${giaban_new}
    #assert value invoice
    ${get_ma_kh_by_hd}    ${get_tong_tien_hang}    ${get_khachtt_af_execute}    ${get_gghd_af_execute}    ${get_khachcantra}    ${get_trangthai}    ${get_ghichu_in_hd_af_execute}
    ...    Get invoice info have note incase discount by invoice code    ${invoice_code}
    Should Be Equal As Numbers    ${get_tong_tien_hang}    ${result_tongtienhang}
    Should Be Equal As Numbers    ${get_khachcantra}    ${result_TTH_tru_gghd}
    Should Be Equal As Numbers    ${get_khachtt_af_execute}    ${actual_khtt}
    Should Be Equal As Strings    ${get_ma_kh_by_hd}    ${input_ma_kh}
    Should Be Equal As Numbers    ${get_gghd_af_execute}    ${input_gghd}
    Should Be Equal As Strings    ${get_trangthai}    Hoàn thành
    Should Be Equal As Strings    ${get_ghichu_in_hd_af_execute}    ${get_ghichu_bf_execute}
    #assert value order
    ${get_ma_kh_in_dh_af_execute}    ${get_TTDH_in_dh_af_execute}    ${get_tongtienhang_in_dh_af_exxecute}    ${get_khachdatra_in_dh_af_execute}    ${get_ghichu_af_execute}    Get order info have note by order code    ${order_code}
    Should Be Equal As Strings    ${get_ma_kh_in_dh_af_execute}    ${input_ma_kh}
    Should Be Equal As Strings    ${get_TTDH_in_dh_af_execute}    3    #trạng thái hoàn thành
    Should Be Equal As Numbers    ${get_tongtienhang_in_dh_af_exxecute}    ${get_tongtienhang_in_dh_bf_execute}
    Should Be Equal As Numbers    ${get_khachdatra_in_dh_af_execute}    ${actual_khtt}
    Should Be Equal As Strings    ${get_ghichu_af_execute}    ${get_ghichu_bf_execute}
    Validate invoice history frm Order    ${order_code}    ${invoice_code}    ${result_TTH_tru_gghd}
    Delete invoice by invoice code    ${invoice_code}
    Delete order frm Order code    ${order_code}
