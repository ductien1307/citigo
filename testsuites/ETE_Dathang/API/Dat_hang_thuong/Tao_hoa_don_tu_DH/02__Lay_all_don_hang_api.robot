*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    ${headless_browser}
Test Setup
Test Teardown     After Test
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
&{dict_product_nums01}    HH0053=4.5    SI036=2    QD120=1.5    DV060=4    Combo37=1
&{dict_product_nums02}    HH0054=2.5    SI037=1    DVT57=2.5    DV061=3    Combo38=4
@{discount}    500000     7000.3   0     25   70000.55
@{discount_type}    changedown     disvnd    none    dis   changeup

*** Test Cases ***    Mã KH        GGDH           List product            List discount    List discount type     Khách thanh toán
Dat hang giam gia             [Tags]        AEDX1      ED
                      [Template]    aetedh_create_inv4
                      CTKH097       10            ${dict_product_nums01}    ${discount}    ${discount_type}        all

Dat hang khong GG     [Tags]        AEDX1       ED
                      [Template]    aetedh_create_inv5
                      CTKH098       ${discount}       ${discount_type}      20000   10000     ${dict_product_nums02}      500000
*** Keywords ***
aetedh_create_inv4
    [Arguments]    ${input_ma_kh}    ${input_ggdh_tocreate}   ${dict_product_nums}    ${list_discount}    ${list_discount_type}   ${input_khtt_tocreate}
    Set Selenium Speed    0.5s
    #get info product, customer
    ${order_code}   Add new order incase discount - payment    ${input_ma_kh}    ${input_ggdh_tocreate}    ${dict_product_nums}    ${list_discount}
    ...   ${list_discount_type}   ${input_khtt_tocreate}
    ${list_product}    Get Dictionary Keys    ${dict_product_nums}
    ${list_num}    Get Dictionary Values    ${dict_product_nums}
    Create list imei and other product    ${list_product}    ${list_num}
    ${order_code}    ${get_khachdatra_in_dh_bf_execute}    ${get_ggdh_in_dh_bf_execute}    ${get_tongtienhang_in_dh_bf_execute}    ${get_tongcong_in_dh_bf_execute}    Get order code - paid - discount value frm API    ${input_ma_kh}
    ${get_list_status_imei}   Get list imei status thr API    ${list_product}
    ${list_result_tongdh}    ${result_list_toncuoi}    ${result_list_thanhtien}    Get list order summary - total sale - ending stocks frm API    ${order_code}    ${list_product}
    #compute
    ${result_tongtienhang}    Sum values in list    ${result_list_thanhtien}
    ${result_TTH_tru_ggdh}    Run Keyword If    0 < ${get_ggdh_in_dh_bf_execute} < 100    Price after % discount invoice    ${result_tongtienhang}    ${get_ggdh_in_dh_bf_execute}
    ...    ELSE IF    ${get_ggdh_in_dh_bf_execute} > 100    Minus and replace floating point    ${result_tongtienhang}    ${get_ggdh_in_dh_bf_execute}
    ...    ELSE    Set Variable    ${result_tongtienhang}
    ${result_gghd}    Run Keyword If    0 < ${get_ggdh_in_dh_bf_execute} < 100    Convert % discount to VND and round    ${result_tongtienhang}    ${get_ggdh_in_dh_bf_execute}
    ...    ELSE    Set Variable    ${get_ggdh_in_dh_bf_execute}
    #create invoice from order
    ${get_order_id}   ${get_payment_id}   Get order - payment frm order api    ${order_code}
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${jsonpath_id_kh}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_kh}
    ${get_id_kh}    Get data from API    ${endpoint_khachhang}    ${jsonpath_id_kh}
    ${endpoint_danhmuc_hh_co_dvt}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${get_resp_danhmuc_hh}    Get Request and return body    ${endpoint_danhmuc_hh_co_dvt}
    ${get_list_order_detail_id}   Get list orderdetail id frm order api    ${order_code}    ${list_product}
    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}    Get list jsonpath product frm list product    ${list_product}
    ${list_giaban}    ${list_result_ggsp}    ${list_id_sp}    Get product info frm list jsonpath product incase discount product    ${get_resp_danhmuc_hh}
    ...    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}    ${list_discount}    ${list_discount_type}
    ${liststring_prs_order_detail}     Set Variable      needdel
    Log        ${liststring_prs_order_detail}
    : FOR    ${item_gia_ban}   ${item_id_sp}   ${item_soluong}    ${item_imei}    ${item_result_ggsp}   ${item_ggsp}   ${item_orderdetail_id}      IN ZIP      ${list_giaban}
    ...   ${list_id_sp}    ${list_num}    ${imei_inlist}    ${list_result_ggsp}    ${list_discount}       ${get_list_order_detail_id}
    \    ${item_imei}    Convert list to string and return    ${item_imei}
    \     ${item_ggsp}    Set Variable If    0 < ${item_ggsp} < 100    ${item_ggsp}    0
    \    ${payload_each_product}        Format string       {{"BasePrice":{0},"IsLotSerialControl":true,"IsRewardPoint":false,"Note":"","Price":{0},"ProductId":{1},"Quantity":{2},"ProductCode":"SI059","SerialNumbers":"{3}","Discount":{4},"DiscountRatio":{5},"ProductName":"Tủ Lạnh Inverter Panasonic NR-BL267VSV1","PriceByPromotion":null,"IsMaster":true,"PromotionParentProductId":null,"ProductBatchExpireId":null,"CategoryId":543560,"MasterProductId":13012510,"Unit":"","Uuid":"","OrderDetailId":{6},"ProductWarranty":[]}}    ${item_gia_ban}   ${item_id_sp}   ${item_soluong}       ${item_imei}    ${item_result_ggsp}   ${item_ggsp}   ${item_orderdetail_id}
    \    ${liststring_prs_order_detail}       Catenate      SEPARATOR=,      ${liststring_prs_order_detail}      ${payload_each_product}
    ${liststring_prs_order_detail}       Replace String      ${liststring_prs_order_detail}       needdel,       ${EMPTY}      count=1
    ${giamgia_hd}    Set Variable If    0 < ${get_ggdh_in_dh_bf_execute} < 100    ${get_ggdh_in_dh_bf_execute}    0
    ${request_payload}    Format String    {{"Invoice":{{"BranchId":{0},"RetailerId":{1},"OrderId":{2},"CustomerId":{3},"SoldById":{4},"SoldBy":{{"CreatedBy":0,"CreatedDate":"2018-12-10T10:44:15.970Z","Email":"","GivenName":"admin","Id":{4},"IsActive":true,"IsAdmin":true,"Type":0,"UserName":"admin","isDeleted":false,"Name":"admin"}},"SaleChannelId":0,"Seller":{{"CreatedBy":0,"CreatedDate":"2018-12-10T10:44:15.970Z","Email":"","GivenName":"admin","Id":{4},"IsActive":true,"IsAdmin":true,"Type":0,"UserName":"admin","isDeleted":false,"Name":"admin"}},"PriceBookId":0,"OrderCode":"{5}","Code":"Hóa đơn 1","Discount":{6},"DiscountRatio":{7},"InvoiceDetails":[{8}],"InvoiceOrderSurcharges":[],"InvoicePromotions":[],"Payments":[],"Status":1,"Total":{9},"Surcharge":0,"Type":1,"Uuid":"","addToAccount":"0","PayingAmount":0,"OrderPaidAmount":{10},"TotalBeforeDiscount":{11},"ProductDiscount":0,"PaidAmount":0,"DebugUuid":"","InvoiceWarranties":[],"CreatedBy":160324}}}}     ${BRANCH_ID}    ${get_id_nguoitao}    ${get_order_id}    ${get_id_kh}    ${get_id_nguoiban}
    ...   ${order_code}     ${result_gghd}    ${giamgia_hd}    ${liststring_prs_order_detail}    ${result_TTH_tru_ggdh}    ${get_khachdatra_in_dh_bf_execute}    ${result_tongtienhang}
    Log    ${request_payload}
    ${invoice_code}    Post request to create invoice and get invoice code    ${request_payload}
    #get value
    Sleep    10s    wait for response to API
    #assert value product in invoice
    ${get_list_hh_in_hd_af_execute}    Get list product frm Invoice API    ${invoice_code}
    ${list_soluong_in_hd}    ${list_giatri_quydoi_in_hd}    Get list quantity and gia tri quy doi by invoice code    ${get_list_hh_in_hd_af_execute}    ${invoice_code}
    : FOR    ${ma_hh}    ${result_toncuoi}    ${item_soluong}    ${get_giatri_quydoi}    IN ZIP    ${get_list_hh_in_hd_af_execute}
    ...    ${result_list_toncuoi}    ${list_soluong_in_hd}    ${list_giatri_quydoi_in_hd}
    \    Run Keyword If    '${get_giatri_quydoi}' == '1'    Validate product history frm API    ${invoice_code}    ${ma_hh}    ${result_toncuoi}
    \    ...    ${item_soluong}
    \    ...    ELSE    Validate unit product history frm API    ${invoice_code}    ${ma_hh}    ${result_toncuoi}
    \    ...    ${item_soluong}    ${get_giatri_quydoi}
    #validate product
    ${list_order_summary_af_execute}    Get list order summary frm product API    ${list_product}
    : FOR    ${result_tong_dh}    ${order_summary_af_execute}    IN ZIP    ${list_result_tongdh}    ${list_order_summary_af_execute}
    \    Should Be Equal As Numbers    ${order_summary_af_execute}    ${result_tong_dh}
    #assert value invoice
    ${get_ma_kh_by_hd}    ${get_tong_tien_hang}    ${get_khachtt_af_execute}    ${get_gghd_af_execute}    ${get_khachcantra}    ${get_trangthai}    ${get_ghichu_in_hd_af_execute}
    ...    Get invoice info have note incase discount by invoice code    ${invoice_code}
    Run Keyword If    ${get_ggdh_in_dh_bf_execute} == 0    Should Be Equal As Numbers    ${get_khachcantra}    ${result_tongtienhang}
    ...    ELSE    Should Be Equal As Numbers    ${get_tong_tien_hang}    ${result_tongtienhang}
    Run Keyword If    ${get_ggdh_in_dh_bf_execute} == 0    Log    Ignore validate
    ...    ELSE    Should Be Equal As Numbers    ${get_tong_tien_hang}    ${result_tongtienhang}
    Should Be Equal As Numbers    ${get_khachcantra}    ${result_TTH_tru_ggdh}
    Should Be Equal As Numbers    ${get_khachtt_af_execute}    ${result_TTH_tru_ggdh}
    Should Be Equal As Strings    ${get_ma_kh_by_hd}    ${input_ma_kh}
    Should Be Equal As Numbers    ${get_gghd_af_execute}    ${result_gghd}
    Should Be Equal As Strings    ${get_trangthai}    Hoàn thành
    Should Be Equal As Strings    ${get_ghichu_in_hd_af_execute}    0
    #assert value order
    ${get_ma_kh_in_dh_af_execute}    ${get_TTDH_in_dh_af_execute}    ${get_tongtienhang_in_dh_af_exxecute}    ${get_khachdatra_in_dh_af_execute}    ${get_giamgia_in_dh_af_execute}    ${get_tongcong_in_dh_af_execute}    ${get_ghichu_in_dh_af_execute}
    ...    Get order info have note incase discount by order code    ${order_code}
    Should Be Equal As Strings    ${get_ma_kh_in_dh_af_execute}    ${input_ma_kh}
    Should Be Equal As Numbers    ${get_TTDH_in_dh_af_execute}    3    #trạng thái hoàn thành
    Should Be Equal As Numbers    ${get_tongtienhang_in_dh_af_exxecute}    ${result_tongtienhang}
    Should Be Equal As Numbers    ${get_khachdatra_in_dh_af_execute}    ${get_khachdatra_in_dh_bf_execute}
    Should Be Equal As Numbers    ${get_giamgia_in_dh_af_execute}    ${get_ggdh_in_dh_bf_execute}
    Should Be Equal As Numbers    ${get_tongcong_in_dh_af_execute}    ${get_tongcong_in_dh_bf_execute}
    Should Be Equal As Strings    ${get_ghichu_in_dh_af_execute}    0
    Validate invoice history frm Order    ${order_code}    ${invoice_code}    ${result_TTH_tru_ggdh}
    Delete invoice by invoice code    ${invoice_code}
    Delete order frm Order code    ${order_code}

aetedh_create_inv5
    [Arguments]    ${input_ma_kh}    ${list_ggsp}    ${list_discount_type}    ${input_gghd}    ${input_khtt}    ${dict_product_nums_tocreate}
    ...    ${input_khtt_tocreate}
    Set Selenium Speed    0.5s
    #get info product, customer
    ${order_code}    Add new order with multi products    ${input_ma_kh}    ${dict_product_nums_tocreate}    ${input_khtt_tocreate}
    ${get_no_bf_execute}    ${get_tongban_bf_execute}    ${get_tongban_tru_trahang_bf_execute}    Get Customer Debt from API    ${input_ma_kh}
    ${get_khachdatra_in_dh_bf_execute}    ${get_tongtienhang_in_dh_bf_execute}    Get paid value frm API    ${order_code}
    ${get_list_hh_in_dh_bf_execute}    ${get_ghichu_bf_execute}    Get ghi chu and list product frm API    ${order_code}
    ${get_list_nums_in_dh}    Get list quantity by order code    ${order_code}    ${get_list_hh_in_dh_bf_execute}
    #create imei
    Create list imei and other product    ${get_list_hh_in_dh_bf_execute}    ${get_list_nums_in_dh}
    ${get_list_status_imei}   Get list imei status thr API    ${get_list_hh_in_dh_bf_execute}
    ${list_result_tongdh}    ${result_list_toncuoi}    ${result_list_thanhtien}    ${list_result_giamoi}        Get list order summary - total sale - ending stocks incase discount and newprice    ${order_code}    ${get_list_hh_in_dh_bf_execute}
    ...    ${list_ggsp}   ${list_discount_type}
    #compute for invoice, order
    ${result_tongtienhang}    Sum values in list    ${result_list_thanhtien}
    ${result_TTH_tru_gghd}    Run Keyword If    0 < ${input_gghd} < 100    Price after % discount invoice    ${result_tongtienhang}    ${input_gghd}
    ...    ELSE IF    ${input_gghd} > 100    Minus and replace floating point    ${result_tongtienhang}    ${input_gghd}
    ...    ELSE    Set Variable    ${result_tongtienhang}
    ${result_gghd}    Run Keyword If    0 < ${input_gghd} < 100    Convert % discount to VND and round    ${result_tongtienhang}    ${input_gghd}
    ...    ELSE    Set Variable    ${input_gghd}
    ${result_khachcantra_in_hd}    Minus and replace floating point    ${result_TTH_tru_gghd}    ${get_khachdatra_in_dh_bf_execute}
    ${actual_khcantra_all}    Set Variable If    '${input_khtt}' == 'all'    ${result_khachcantra_in_hd}    ${input_khtt}
    ${actual_khachcantra}    Set Variable If    '${input_khtt}' == '0'    0    ${actual_khcantra_all}
    #compute invoice info to Quan ly
    ${result_khtt}    Run Keyword If    '${input_khtt}' != 'all'    Sum    ${input_khtt}    ${get_khachdatra_in_dh_bf_execute}
    ${actual_khtt_in_hd}    Set Variable If    '${input_khtt}' == 'all'    ${result_TTH_tru_gghd}    ${result_khtt}
    #compute for order
    ${result_khachthanhtoan_in_dh}    Sum and round 2    ${get_khachdatra_in_dh_bf_execute}    ${actual_khachcantra}
    #compute for cong no KH
    ${result_du_no_hd_KH}    Sum    ${get_no_bf_execute}    ${result_TTH_tru_gghd}
    ${result_PTT_hd_KH}    Minus    ${result_du_no_hd_KH}    ${actual_khachcantra}
    ${result_tongban_KH}    Sum    ${result_TTH_tru_gghd}    ${get_tongban_bf_execute}
    #create invoice from order
    ${get_order_id}   ${get_payment_id}   Get order - payment frm order api    ${order_code}
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${jsonpath_id_kh}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_kh}
    ${get_id_kh}    Get data from API    ${endpoint_khachhang}    ${jsonpath_id_kh}
    ${endpoint_danhmuc_hh_co_dvt}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${get_resp_danhmuc_hh}    Get Request and return body    ${endpoint_danhmuc_hh_co_dvt}
    ${get_list_order_detail_id}   Get list orderdetail id frm order api    ${order_code}    ${get_list_hh_in_dh_bf_execute}
    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}    Get list jsonpath product frm list product    ${get_list_hh_in_dh_bf_execute}
    ${list_giaban}    ${list_result_ggsp}    ${list_id_sp}    Get product info frm list jsonpath product incase discount product    ${get_resp_danhmuc_hh}
    ...    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}    ${list_ggsp}    ${list_discount_type}
    ${liststring_prs_order_detail}     Set Variable      needdel
    Log        ${liststring_prs_order_detail}
    : FOR    ${item_gia_ban}   ${item_id_sp}   ${item_soluong}    ${item_imei}    ${item_result_ggsp}   ${item_ggsp}   ${item_orderdetail_id}      IN ZIP      ${list_giaban}
    ...    ${list_id_sp}    ${get_list_nums_in_dh}    ${imei_inlist}    ${list_result_ggsp}    ${list_ggsp}   ${get_list_order_detail_id}
    \    ${item_imei}    Convert list to string and return    ${item_imei}
    \     ${item_ggsp}    Set Variable If    0 < ${item_ggsp} < 100    ${item_ggsp}    0
    \    ${payload_each_product}        Format string       {{"BasePrice":{0},"IsLotSerialControl":true,"IsRewardPoint":false,"Note":"","Price":{0},"ProductId":{1},"Quantity":{2},"ProductCode":"SI059","SerialNumbers":"{3}","Discount":{4},"DiscountRatio":{5},"ProductName":"Tủ Lạnh Inverter Panasonic NR-BL267VSV1","PriceByPromotion":null,"IsMaster":true,"PromotionParentProductId":null,"ProductBatchExpireId":null,"CategoryId":543560,"MasterProductId":13012510,"Unit":"","Uuid":"","OrderDetailId":{6},"ProductWarranty":[]}}    ${item_gia_ban}   ${item_id_sp}   ${item_soluong}       ${item_imei}    ${item_result_ggsp}   ${item_ggsp}   ${item_orderdetail_id}
    \    ${liststring_prs_order_detail}       Catenate      SEPARATOR=,      ${liststring_prs_order_detail}      ${payload_each_product}
    ${liststring_prs_order_detail}       Replace String      ${liststring_prs_order_detail}       needdel,       ${EMPTY}      count=1
    ${giamgia_hd}    Set Variable If    0 < ${input_gghd} < 100    ${input_gghd}    0
    ${request_payload}    Format String    {{"Invoice":{{"BranchId":{0},"RetailerId":{1},"OrderId":{2},"CustomerId":{3},"SoldById":{4},"SoldBy":{{"CreatedBy":0,"CreatedDate":"2018-12-10T10:44:15.970Z","Email":"","GivenName":"admin","Id":{4},"IsActive":true,"IsAdmin":true,"Type":0,"UserName":"admin","isDeleted":false,"Name":"admin"}},"SaleChannelId":0,"Seller":{{"CreatedBy":0,"CreatedDate":"2018-12-10T10:44:15.970Z","Email":"","GivenName":"admin","Id":{4},"IsActive":true,"IsAdmin":true,"Type":0,"UserName":"admin","isDeleted":false,"Name":"admin"}},"PriceBookId":0,"OrderCode":"{5}","Code":"Hóa đơn 1","Discount":{6},"DiscountRatio":{7},"InvoiceDetails":[{8}],"InvoiceOrderSurcharges":[],"InvoicePromotions":[],"Payments":[{{"Method":"Cash","MethodStr":"Tiền mặt","Amount":{9},"Id":-1}}],"Status":1,"Total":{10},"Surcharge":0,"Type":1,"Uuid":"","addToAccount":"0","PayingAmount":{9},"OrderPaidAmount":{11},"DepositReturn":0,"TotalBeforeDiscount":{12},"ProductDiscount":384000,"PaidAmount":{9},"DebugUuid":"","InvoiceWarranties":[],"CreatedBy":201567}}}}     ${BRANCH_ID}    ${get_id_nguoitao}    ${get_order_id}    ${get_id_kh}    ${get_id_nguoiban}
    ...   ${order_code}     ${result_gghd}    ${giamgia_hd}    ${liststring_prs_order_detail}   ${actual_khachcantra}     ${result_TTH_tru_gghd}    ${get_khachdatra_in_dh_bf_execute}    ${result_tongtienhang}
    Log    ${request_payload}
    ${invoice_code}    Post request to create invoice and get invoice code    ${request_payload}
    #get value
    Sleep    20s    wait for response to API
    ${get_list_hh_in_hd_af_execute}    Get list product frm Invoice API    ${invoice_code}
    ${list_soluong_in_hd}    ${list_giatri_quydoi_in_hd}    Get list quantity and gia tri quy doi by invoice code    ${get_list_hh_in_hd_af_execute}    ${invoice_code}
    : FOR    ${ma_hh}    ${result_toncuoi}    ${item_soluong}    ${get_giatri_quydoi}    IN ZIP    ${get_list_hh_in_hd_af_execute}
    ...    ${result_list_toncuoi}    ${list_soluong_in_hd}    ${list_giatri_quydoi_in_hd}
    \    Run Keyword If    '${get_giatri_quydoi}' == '1'    Validate product history frm API    ${invoice_code}    ${ma_hh}    ${result_toncuoi}
    \    ...    ${item_soluong}
    \    ...    ELSE    Validate unit product history frm API    ${invoice_code}    ${ma_hh}    ${result_toncuoi}
    \    ...    ${item_soluong}    ${get_giatri_quydoi}
    #validate product
    ${list_order_summary_af_execute}    Get list order summary frm product API    ${get_list_hh_in_dh_bf_execute}
    : FOR    ${result_tong_dh}    ${order_summary_af_execute}    IN ZIP    ${list_result_tongdh}    ${list_order_summary_af_execute}
    \    Should Be Equal As Numbers    ${order_summary_af_execute}    ${result_tong_dh}
    #assert value invoice
    ${get_ma_kh_by_hd}    ${get_tong_tien_hang}    ${get_khachtt_af_execute}    ${get_gghd_af_execute}    ${get_khachcantra}    ${get_trangthai}    ${get_ghichu_in_hd_af_execute}
    ...    Get invoice info have note incase discount by invoice code    ${invoice_code}
    Run Keyword If    ${input_gghd} == 0    Should Be Equal As Numbers    ${get_khachcantra}    ${result_tongtienhang}
    ...    ELSE    Should Be Equal As Numbers    ${get_tong_tien_hang}    ${result_tongtienhang}
    Run Keyword If    ${input_gghd} == 0    Log    Ignore validate
    ...    ELSE    Should Be Equal As Numbers    ${get_tong_tien_hang}    ${result_tongtienhang}
    Should Be Equal As Numbers    ${get_khachcantra}    ${result_TTH_tru_gghd}
    Should Be Equal As Numbers    ${get_khachtt_af_execute}    ${actual_khtt_in_hd}
    Should Be Equal As Strings    ${get_ma_kh_by_hd}    ${input_ma_kh}
    Should Be Equal As Numbers    ${get_gghd_af_execute}    ${result_gghd}
    Should Be Equal As Strings    ${get_trangthai}    Hoàn thành
    Should Be Equal As Strings    ${get_ghichu_in_hd_af_execute}    ${get_ghichu_bf_execute}
    #assert value order
    ${get_ma_kh_in_dh_af_execute}    ${get_TTDH_in_dh_af_execute}    ${get_tongtienhang_in_dh_af_exxecute}    ${get_khachdatra_in_dh_af_execute}    ${get_ghichu_af_execute}    Get order info have note by order code    ${order_code}
    Should Be Equal As Strings    ${get_ma_kh_in_dh_af_execute}    ${input_ma_kh}
    Should Be Equal As Strings    ${get_TTDH_in_dh_af_execute}    3    #trạng thái hoàn thành
    Should Be Equal As Numbers    ${get_tongtienhang_in_dh_af_exxecute}    ${get_tongtienhang_in_dh_bf_execute}
    Should Be Equal As Numbers    ${get_khachdatra_in_dh_af_execute}    ${result_khachthanhtoan_in_dh}
    Should Be Equal As Strings    ${get_ghichu_af_execute}    ${get_ghichu_bf_execute}
    Validate invoice history frm Order    ${order_code}    ${invoice_code}    ${result_TTH_tru_gghd}
    #assert customer and so quy
    ${get_no_af_execute_kh}    ${get_tongban_af_execute_kh}    ${get_tongban_tru_trahang_af_execute_kh}    Get Customer Debt from API after purchase    ${input_ma_kh}    ${invoice_code}    ${actual_khachcantra}
    ${get_maphieu_soquy}    Get Ma Phieu Thu in So quy    ${invoice_code}
    Run Keyword If    '${input_khtt}' == '0'    Should Be Equal As Numbers    ${get_no_af_execute_kh}    ${result_du_no_hd_KH}
    ...    ELSE    Should Be Equal As Numbers    ${get_no_af_execute_kh}    ${result_PTT_hd_KH}
    Should Be Equal As Numbers    ${get_tongban_af_execute_kh}    ${result_tongban_KH}
    Should Be Equal As Numbers    ${get_tongban_tru_trahang_af_execute_kh}    ${result_tongban_KH}
    Run Keyword If    '${input_khtt}' == '0'    Validate customer history and debt if invoice is not paid frm order    ${input_ma_kh}    ${invoice_code}    ${result_du_no_hd_KH}
    ...    ELSE    Validate customer history and debt if invoice is paid frm order    ${input_ma_kh}    ${invoice_code}    ${result_du_no_hd_KH}    ${result_PTT_hd_KH}
    Run Keyword If    '${result_tongtienhang}' == '0'    Validate history tab of customer frm Order    ${input_ma_kh}    ${invoice_code}
    Run Keyword If    '${input_khtt}' == '0'    Validate So quy info from Rest API if Invoice is not paid    ${get_maphieu_soquy}
    ...    ELSE    Validate So quy info from Rest API if Invoice is paid    ${get_maphieu_soquy}    ${actual_khachcantra}
    Delete invoice by invoice code    ${invoice_code}
    Delete order frm Order code    ${order_code}
