*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}      ${headless_browser}
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
Library           BuiltIn

*** Variables ***
&{dict_product02}    HH0056=2.5    SI039=2    QD126=4    DV063=1.5    Combo40=3
&{dict_product03}    HH0057=2.5    SI040=2    DVT60=1.8    DV064=2    Combo41=3.4
@{list_hh_delete1}    SI039
&{list_hh}        Combo42=2    HH0058=4.5
@{discount}    300000     90000  0     25   5000
@{discount_type}    changedown     changeup    none    dis    disvnd

*** Test Cases ***    Mã KH         List ggsp            List discount type    Hoàn trả tạm ứng    List product delete    List product - nums add    List product to create   Khách thanh toán
Lay 1 phan don hang
                      [Tags]        AEDX1       ED
                      [Template]    aetedh_create_inv8
                      CTKH100       ${discount}        ${discount_type}    50000               ${list_hh_delete1}     ${list_hh}             ${dict_product02}            3000000

Lay het don hang      [Tags]        AEDX1       ED
                      [Template]    aetedh_create_inv9
                      CTKH101       ${discount}        ${discount_type}    all                 ${list_hh}             ${dict_product03}


*** Keywords ***
aetedh_create_inv8
    [Arguments]    ${input_ma_kh}    ${list_ggsp}    ${list_discount_type}    ${input_hoantratamung}    ${list_product_delete}    ${dict_list_product}
    ...    ${dict_product_nums_tocreate}    ${input_khtt_tocreate}
    Set Selenium Speed    0.5s
    ${order_code}    Add new order with multi products    ${input_ma_kh}    ${dict_product_nums_tocreate}    ${input_khtt_tocreate}
    ${list_product_new}    Get Dictionary Keys    ${dict_list_product}
    ${list_nums_new}    Get Dictionary Values    ${dict_list_product}
    ${get_khachdatra_in_dh_bf_execute}    ${get_tongtienhang_in_dh_bf_execute}    Get paid value frm API    ${order_code}
    ${get_list_hh_in_dh_bf_execute}    ${get_ghichu_bf_execute}    Get ghi chu and list product frm API    ${order_code}
    #create imei
    ${list_result_tongdh_delete}    Get list order summary frm product API    ${list_product_delete}
    #get order summary and sub total of products
    : FOR    ${ma_hh_delete}    IN    @{list_product_delete}
    \    Remove Values From List    ${get_list_hh_in_dh_bf_execute}    ${ma_hh_delete}
    Log    ${get_list_hh_in_dh_bf_execute}
    ${get_list_sl_in_dh}    Get list quantity by order code    ${order_code}     ${get_list_hh_in_dh_bf_execute}
    ${list_result_tongdh}    ${result_list_toncuoi}    ${result_list_thanhtien}    ${list_result_giamoi}   Get list order summary - total sale - ending stocks incase discount and newprice    ${order_code}    ${get_list_hh_in_dh_bf_execute}
    ...    ${list_ggsp}   ${list_discount_type}
    ${list_result_tongdh_new}    ${result_list_toncuoi_new}    ${result_list_thanhtien_new}    ${list_result_giamoi_new}    Get list order summary - total sale - onhand incase discount by product list    ${list_product_new}    ${list_nums_new}
    ...    ${list_ggsp}   ${list_discount_type}
    #${list_result_tongdh_new}    ${result_list_toncuoi_new}    Reverse two lists    ${list_result_tongdh_new}    ${result_list_toncuoi_new}
    : FOR    ${result_tongdh}    ${result_toncuoi}    ${result_thanhtien}    IN ZIP    ${list_result_tongdh}    ${result_list_toncuoi}
    ...    ${result_list_thanhtien}
    \    Append To List    ${list_result_tongdh_new}    ${result_tongdh}
    \    Append To List    ${result_list_toncuoi_new}    ${result_toncuoi}
    \    Append To List    ${result_list_thanhtien_new}    ${result_thanhtien}
    Log    ${list_result_tongdh_new}
    Log    ${result_list_toncuoi_new}
    Log    ${result_list_thanhtien_new}
    #compute TTH with product
    ${result_tongsoluong}    Sum values in list    ${get_list_sl_in_dh}
    ${result_tongtienhang}    Sum values in list    ${result_list_thanhtien_new}
    ${tamung}    Minus and replace floating point    ${get_khachdatra_in_dh_bf_execute}    ${result_tongtienhang}
    ${result_tamung}    Set Variable If    '${input_hoantratamung}' == 'all'    ${tamung}    ${input_hoantratamung}
    ${result_khachdatra_in_dh}    Minus    ${get_khachdatra_in_dh_bf_execute}    ${result_tamung}
    #create invoice from order
    ${get_order_id}   ${get_payment_id}   Get order - payment frm order api    ${order_code}
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${jsonpath_id_kh}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_kh}
    ${get_id_kh}    Get data from API    ${endpoint_khachhang}    ${jsonpath_id_kh}
    ${endpoint_danhmuc_hh_co_dvt}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${get_resp_danhmuc_hh}    Get Request and return body    ${endpoint_danhmuc_hh_co_dvt}
    ${get_list_order_detail_id}   Get list orderdetail id frm order api    ${order_code}    ${get_list_hh_in_dh_bf_execute}
    ##payload product
    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}    Get list jsonpath product frm list product    ${get_list_hh_in_dh_bf_execute}
    ${list_giaban}    ${list_result_ggsp}    ${list_id_sp}    Get product info frm list jsonpath product incase discount product    ${get_resp_danhmuc_hh}
    ...    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}    ${list_ggsp}    ${list_discount_type}
    ${liststring_prs_order_detail}     Set Variable      needdel
    Log        ${liststring_prs_order_detail}
    : FOR    ${item_giaban}   ${item_id_sp}   ${item_so_luong}    ${item_result_ggsp}   ${item_ggsp}   ${item_orderdetail_id}      IN ZIP      ${list_giaban}
    ...        ${list_id_sp}    ${get_list_sl_in_dh}    ${list_result_ggsp}    ${list_ggsp}       ${get_list_order_detail_id}
    \     ${item_ggsp}    Set Variable If    0 < ${item_ggsp} < 100    ${item_ggsp}    0
    \    ${payload_each_product}        Format string       {{"BasePrice":{0},"IsLotSerialControl":false,"IsRewardPoint":false,"Note":"","Price":{0},"ProductId":{1},"Quantity":{2},"ProductCode":"Combo58","Discount":{3},"DiscountRatio":{4},"ProductName":"Combo dưỡng da 4","PriceByPromotion":null,"IsMaster":true,"PromotionParentProductId":null,"ProductBatchExpireId":null,"CategoryId":543556,"MasterProductId":13013923,"Unit":"","Uuid":"","OrderDetailId":{5},"ProductWarranty":[]}}    ${item_giaban}   ${item_id_sp}   ${item_so_luong}    ${item_result_ggsp}   ${item_ggsp}   ${item_orderdetail_id}
    \    ${liststring_prs_order_detail}       Catenate      SEPARATOR=,      ${liststring_prs_order_detail}      ${payload_each_product}
    ${liststring_prs_order_detail}       Replace String      ${liststring_prs_order_detail}       needdel,       ${EMPTY}      count=1
    ##payload product new
    ${list_jsonpath_id_sp_new}    ${list_jsonpath_giaban_new}    Get list jsonpath product frm list product    ${list_product_new}
    ${list_giaban_new}    ${list_result_ggsp_new}    ${list_id_sp_new}    Get product info frm list jsonpath product incase discount product    ${get_resp_danhmuc_hh}
    ...    ${list_jsonpath_id_sp_new}    ${list_jsonpath_giaban_new}    ${list_ggsp}    ${list_discount_type}
    ${liststring_prs_order_detail_new}     Set Variable      needdel
    Log        ${liststring_prs_order_detail_new}
    : FOR    ${item_giaban_new}   ${item_id_sp_new}   ${item_so_luong_new}    ${item_result_ggsp_new}   ${item_ggsp_new}      IN ZIP      ${list_giaban_new}
    ...    ${list_id_sp_new}    ${list_nums_new}    ${list_result_ggsp_new}    ${list_ggsp}
    \     ${item_ggsp_new}    Set Variable If    0 < ${item_ggsp_new} < 100    ${item_ggsp_new}    0
    \    ${payload_each_product}        Format string       {{"BasePrice":{0},"IsLotSerialControl":false,"IsRewardPoint":false,"Note":"","Price":{0},"ProductId":{1},"Quantity":{2},"ProductCode":"Combo58","Discount":{3},"DiscountRatio":{4},"ProductName":"Combo dưỡng da 4","PriceByPromotion":null,"IsMaster":true,"PromotionParentProductId":null,"ProductBatchExpireId":null,"CategoryId":543556,"MasterProductId":13013923,"Unit":"","Uuid":"","ProductWarranty":[]}}    ${item_giaban_new}   ${item_id_sp_new}   ${item_so_luong_new}    ${item_result_ggsp_new}   ${item_ggsp_new}
    \    ${liststring_prs_order_detail_new}       Catenate      SEPARATOR=,      ${liststring_prs_order_detail_new}      ${payload_each_product}
    ${liststring_prs_order_detail_new}       Replace String      ${liststring_prs_order_detail_new}       needdel,       ${EMPTY}      count=1
    ##post request
    ${actual_tamung}    Minus     0       ${result_tamung}
    ${request_payload}    Format String    {{"Invoice":{{"BranchId":{0},"RetailerId":{1},"OrderId":{2},"CustomerId":{3},"SoldById":{4},"SoldBy":{{"CreatedBy":0,"CreatedDate":"2018-12-10T10:44:15.970Z","Email":"","GivenName":"admin","Id":{4},"IsActive":true,"IsAdmin":true,"Type":0,"UserName":"admin","isDeleted":false,"Name":"admin"}},"SaleChannelId":0,"Seller":{{"CreatedBy":0,"CreatedDate":"2018-12-10T10:44:15.970Z","Email":"","GivenName":"admin","Id":{4},"IsActive":true,"IsAdmin":true,"Type":0,"UserName":"admin","isDeleted":false,"Name":"admin"}},"PriceBookId":0,"OrderCode":"{5}","Code":"Hóa đơn 1","InvoiceDetails":[{6},{7}],"InvoiceOrderSurcharges":[],"InvoicePromotions":[],"Payments":[{{"Method":"Cash","MethodStr":"Tiền mặt","Amount":{8},"Id":-1}}],"Status":1,"Total":{9},"Surcharge":0,"Type":1,"Uuid":"","addToAccount":"0","PayingAmount":0,"OrderPaidAmount":{10},"DepositReturn":{11},"TotalBeforeDiscount":{9},"ProductDiscount":384000,"PaidAmount":0,"DebugUuid":"","InvoiceWarranties":[],"CreatedBy":201567}}}}     ${BRANCH_ID}    ${get_id_nguoitao}    ${get_order_id}    ${get_id_kh}    ${get_id_nguoiban}
    ...   ${order_code}     ${liststring_prs_order_detail_new}     ${liststring_prs_order_detail}   ${actual_tamung}     ${result_tongtienhang}       ${result_tamung}    ${get_khachdatra_in_dh_bf_execute}
    Log    ${request_payload}
    ${invoice_code}    Post request to create invoice and get invoice code    ${request_payload}
    #get value
    Sleep    20s    wait for response to API
    #assert value product in invoice
    ${get_list_hh_in_hd_af_execute}    Get list product frm Invoice API    ${invoice_code}
    ${list_soluong_in_hd}    ${list_giatri_quydoi_in_hd}    Get list quantity and gia tri quy doi by invoice code    ${get_list_hh_in_hd_af_execute}    ${invoice_code}
    : FOR    ${ma_hh}    ${result_toncuoi}    ${item_soluong}    ${get_giatri_quydoi}    IN ZIP    ${get_list_hh_in_hd_af_execute}
    ...    ${result_list_toncuoi_new}    ${list_soluong_in_hd}    ${list_giatri_quydoi_in_hd}
    \    Run Keyword If    '${get_giatri_quydoi}' == '1'    Validate product history frm API    ${invoice_code}    ${ma_hh}    ${result_toncuoi}
    \    ...    ${item_soluong}
    \    ...    ELSE    Validate unit product history frm API    ${invoice_code}    ${ma_hh}    ${result_toncuoi}
    \    ...    ${item_soluong}    ${get_giatri_quydoi}
    #validate deleted product
    ${list_order_summary_delete_af_execute}    Get list order summary frm product API    ${list_product_delete}
    : FOR    ${result_tong_dh_delete}    ${order_summary_delete_af_execute}    IN ZIP    ${list_result_tongdh_delete}    ${list_order_summary_delete_af_execute}
    \    Should Be Equal As Numbers    ${result_tong_dh_delete}    ${order_summary_delete_af_execute}
    #validate product
    ${list_order_summary_af_execute}    Get list order summary frm product API    ${get_list_hh_in_hd_af_execute}
    : FOR    ${result_tong_dh}    ${order_summary_af_execute}    IN ZIP    ${list_result_tongdh_new}    ${list_order_summary_af_execute}
    \    Should Be Equal As Numbers    ${order_summary_af_execute}    ${result_tong_dh}
    #assert value invoice
    ${get_ma_kh_by_hd}    ${get_tong_tien_hang}    ${get_khach_tt}    ${get_trangthai}    ${get_ghichu_in_hd_af_execute}    Get invoice info have note by invoice code    ${invoice_code}
    Should Be Equal As Numbers    ${get_tong_tien_hang}    ${result_tongtienhang}
    Should Be Equal As Numbers    ${get_khach_tt}    ${result_tongtienhang}
    Should Be Equal As Strings    ${get_ma_kh_by_hd}    ${input_ma_kh}
    Should Be Equal As Strings    ${get_trangthai}    Hoàn thành
    Should Be Equal As Strings    ${get_ghichu_in_hd_af_execute}    ${get_ghichu_bf_execute}
    #assert value order
    ${get_ma_kh_in_dh_af_execute}    ${get_TTDH_in_dh_af_execute}    ${get_tongtienhang_in_dh_af_exxecute}    ${get_khachdatra_in_dh_af_execute}    ${get_ghichu_af_execute}    Get order info have note by order code    ${order_code}
    Should Be Equal As Strings    ${get_ma_kh_in_dh_af_execute}    ${input_ma_kh}
    Should Be Equal As Strings    ${get_TTDH_in_dh_af_execute}    2    #trạng thái đang giao hàng
    Should Be Equal As Numbers    ${get_tongtienhang_in_dh_af_exxecute}    ${get_tongtienhang_in_dh_bf_execute}
    Should Be Equal As Numbers    ${get_khachdatra_in_dh_af_execute}    ${result_khachdatra_in_dh}
    Should Be Equal As Strings    ${get_ghichu_af_execute}    ${get_ghichu_bf_execute}
    Validate invoice history frm Order    ${order_code}    ${invoice_code}    ${result_tongtienhang}
    Delete invoice by invoice code    ${invoice_code}
    Delete order frm Order code    ${order_code}

aetedh_create_inv9
    [Arguments]    ${input_ma_kh}    ${list_ggsp}    ${list_discount_type}    ${input_khtt}    ${dict_list_product_new}    ${dict_product_nums_create}
    Set Selenium Speed    0.5s
    ${order_code}    Add new order with multi product and no payment - get order code    ${input_ma_kh}    ${dict_product_nums_create}
    ${list_product_new}    Get Dictionary Keys    ${dict_list_product_new}
    ${list_nums_new}    Get Dictionary Values    ${dict_list_product_new}
    ${get_khachdatra_in_dh_bf_execute}    ${get_tongtienhang_in_dh_bf_execute}    Get paid value frm API    ${order_code}
    ${get_list_hh_in_dh_bf_execute}    ${get_ghichu_bf_execute}    Get ghi chu and list product frm API    ${order_code}
    ${get_list_nums_in_dh}    Get list quantity by order code    ${order_code}    ${get_list_hh_in_dh_bf_execute}
    #create imei
    Create list imei and other product    ${get_list_hh_in_dh_bf_execute}    ${get_list_nums_in_dh}
    ${get_list_status_imei}   Get list imei status thr API    ${get_list_hh_in_dh_bf_execute}
    #get order summary and sub total of products new
    ${list_result_tongdh}    ${result_list_toncuoi}    ${result_list_thanhtien}    ${list_result_giamoi}   Get list order summary - total sale - ending stocks incase discount and newprice    ${order_code}    ${get_list_hh_in_dh_bf_execute}
    ...    ${list_ggsp}   ${list_discount_type}
    ${list_result_tongdh_new}    ${result_list_toncuoi_new}    ${result_list_thanhtien_new}    ${list_result_giamoi_new}    Get list order summary - total sale - onhand incase discount by product list    ${list_product_new}    ${list_nums_new}
    ...    ${list_ggsp}   ${list_discount_type}
    #${list_result_tongdh_new}    ${result_list_toncuoi_new}    Reverse two lists    ${list_result_tongdh_new}    ${result_list_toncuoi_new}
    : FOR    ${result_tongdh}    ${result_toncuoi}    ${result_thanhtien}    IN ZIP    ${list_result_tongdh}    ${result_list_toncuoi}
    ...    ${result_list_thanhtien}
    \    Append To List    ${list_result_tongdh_new}    ${result_tongdh}
    \    Append To List    ${result_list_toncuoi_new}    ${result_toncuoi}
    \    Append To List    ${result_list_thanhtien_new}    ${result_thanhtien}
    Log    ${list_result_tongdh_new}
    Log    ${result_list_toncuoi_new}
    #compute for invoice, order
    ${result_tongsoluong}    Sum values in list    ${get_list_nums_in_dh}
    ${result_tongtienhang}    Sum values in list    ${result_list_thanhtien_new}
    ${result_khachcantra_in_hd}    Minus and replace floating point    ${result_tongtienhang}    ${get_khachdatra_in_dh_bf_execute}
    ${result_khdatra_in_hd}    Sum and replace floating point    ${result_khachcantra_in_hd}    ${get_khachdatra_in_dh_bf_execute}
    ${actual_khtt_all}    Set Variable If    '${input_khtt}' == 'all'    ${result_khachcantra_in_hd}    ${input_khtt}
    ${actual_khtt}    Set Variable If    '${input_khtt}' == '0'    0    ${actual_khtt_all}
    #compute for order
    ${result_khachthanhtoan_in_dh}    Sum and replace floating point    ${get_khachdatra_in_dh_bf_execute}    ${actual_khtt}
    #create invoice from order
    ${get_order_id}   ${get_payment_id}   Get order - payment frm order api    ${order_code}
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${jsonpath_id_kh}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_kh}
    ${get_id_kh}    Get data from API    ${endpoint_khachhang}    ${jsonpath_id_kh}
    ${endpoint_danhmuc_hh_co_dvt}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${get_resp_danhmuc_hh}    Get Request and return body    ${endpoint_danhmuc_hh_co_dvt}
    ${get_list_order_detail_id}   Get list orderdetail id frm order api    ${order_code}    ${get_list_hh_in_dh_bf_execute}
    ##payload product
    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}    Get list jsonpath product frm list product    ${get_list_hh_in_dh_bf_execute}
    ${list_giaban}    ${list_result_ggsp}    ${list_id_sp}    Get product info frm list jsonpath product incase discount product    ${get_resp_danhmuc_hh}
    ...    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}    ${list_ggsp}    ${list_discount_type}
    ${liststring_prs_order_detail}     Set Variable      needdel
    Log        ${liststring_prs_order_detail}
    : FOR    ${item_giaban}   ${item_id_sp}   ${item_so_luong}    ${item_result_ggsp}   ${item_ggsp}   ${item_orderdetail_id}   ${item_imei}      IN ZIP      ${list_giaban}
    ...        ${list_id_sp}    ${get_list_nums_in_dh}    ${list_result_ggsp}    ${list_ggsp}       ${get_list_order_detail_id}   ${imei_inlist}
    \    ${item_imei}    Convert list to string and return    ${item_imei}
    \     ${item_ggsp}    Set Variable If    0 < ${item_ggsp} < 100    ${item_ggsp}    0
    \    ${payload_each_product}        Format string       {{"BasePrice":{0},"IsLotSerialControl":true,"IsRewardPoint":false,"Note":"","Price":{0},"ProductId":{1},"Quantity":{2},"ProductCode":"SI059","SerialNumbers":"{3}","Discount":{4},"DiscountRatio":{5},"ProductName":"Tủ Lạnh Inverter Panasonic NR-BL267VSV1","PriceByPromotion":null,"IsMaster":true,"PromotionParentProductId":null,"ProductBatchExpireId":null,"CategoryId":543560,"MasterProductId":13012510,"Unit":"","Uuid":"","OrderDetailId":{6},"ProductWarranty":[]}}    ${item_gia_ban}   ${item_id_sp}   ${item_soluong}
    \    ...       ${item_imei}    ${item_result_ggsp}   ${item_ggsp}   ${item_orderdetail_id}
    \    ${liststring_prs_order_detail}       Catenate      SEPARATOR=,      ${liststring_prs_order_detail}      ${payload_each_product}
    ${liststring_prs_order_detail}       Replace String      ${liststring_prs_order_detail}       needdel,       ${EMPTY}      count=1
    ##payload product new
    ${list_jsonpath_id_sp_new}    ${list_jsonpath_giaban_new}    Get list jsonpath product frm list product    ${list_product_new}
    ${list_giaban_new}    ${list_result_ggsp_new}    ${list_id_sp_new}    Get product info frm list jsonpath product incase discount product    ${get_resp_danhmuc_hh}
    ...    ${list_jsonpath_id_sp_new}    ${list_jsonpath_giaban_new}    ${list_ggsp}    ${list_discount_type}
    ${liststring_prs_order_detail_new}     Set Variable      needdel
    Log        ${liststring_prs_order_detail_new}
    : FOR    ${item_giaban_new}   ${item_id_sp_new}   ${item_so_luong_new}    ${item_result_ggsp_new}   ${item_ggsp_new}      IN ZIP      ${list_giaban_new}
    ...    ${list_id_sp_new}    ${list_nums_new}    ${list_result_ggsp_new}    ${list_ggsp}
    \     ${item_ggsp_new}    Set Variable If    0 < ${item_ggsp_new} < 100    ${item_ggsp_new}    0
    \    ${payload_each_product}        Format string       {{"BasePrice":{0},"IsLotSerialControl":false,"IsRewardPoint":false,"Note":"","Price":{0},"ProductId":{1},"Quantity":{2},"ProductCode":"Combo58","Discount":{3},"DiscountRatio":{4},"ProductName":"Combo dưỡng da 4","PriceByPromotion":null,"IsMaster":true,"PromotionParentProductId":null,"ProductBatchExpireId":null,"CategoryId":543556,"MasterProductId":13013923,"Unit":"","Uuid":"","ProductWarranty":[]}}    ${item_giaban_new}   ${item_id_sp_new}   ${item_so_luong_new}    ${item_result_ggsp_new}   ${item_ggsp_new}
    \    ${liststring_prs_order_detail_new}       Catenate      SEPARATOR=,      ${liststring_prs_order_detail_new}      ${payload_each_product}
    ${liststring_prs_order_detail_new}       Replace String      ${liststring_prs_order_detail_new}       needdel,       ${EMPTY}      count=1
    ##post request
    ${request_payload}    Format String    {{"Invoice":{{"BranchId":{0},"RetailerId":{1},"OrderId":{2},"CustomerId":{3},"SoldById":{4},"SoldBy":{{"CreatedBy":0,"CreatedDate":"2018-12-10T10:44:15.970Z","Email":"","GivenName":"admin","Id":{4},"IsActive":true,"IsAdmin":true,"Type":0,"UserName":"admin","isDeleted":false,"Name":"admin"}},"SaleChannelId":0,"Seller":{{"CreatedBy":0,"CreatedDate":"2018-12-10T10:44:15.970Z","Email":"","GivenName":"admin","Id":{4},"IsActive":true,"IsAdmin":true,"Type":0,"UserName":"admin","isDeleted":false,"Name":"admin"}},"PriceBookId":0,"OrderCode":"{5}","Code":"Hóa đơn 1","InvoiceDetails":[{6},{7}],"InvoiceOrderSurcharges":[],"InvoicePromotions":[],"Payments":[{{"Method":"Cash","MethodStr":"Tiền mặt","Amount":{8},"Id":-1}}],"Status":1,"Total":{9},"Surcharge":0,"Type":1,"Uuid":"","addToAccount":"0","PayingAmount":{8},"OrderPaidAmount":{10},"DepositReturn":0,"TotalBeforeDiscount":{9},"ProductDiscount":384000,"PaidAmount":0,"DebugUuid":"","InvoiceWarranties":[],"CreatedBy":201567}}}}     ${BRANCH_ID}    ${get_id_nguoitao}    ${get_order_id}    ${get_id_kh}    ${get_id_nguoiban}
    ...   ${order_code}     ${liststring_prs_order_detail_new}     ${liststring_prs_order_detail}   ${actual_khtt}     ${result_tongtienhang}    ${get_khachdatra_in_dh_bf_execute}
    Log    ${request_payload}
    ${invoice_code}    Post request to create invoice and get invoice code    ${request_payload}
    #get value
    Sleep    20s    wait for response to API
    #assert value product in invoice
    ${get_list_hh_in_hd_af_execute}    Get list product frm Invoice API    ${invoice_code}
    ${list_soluong_in_hd}    ${list_giatri_quydoi_in_hd}    Get list quantity and gia tri quy doi by invoice code    ${get_list_hh_in_hd_af_execute}    ${invoice_code}
    : FOR    ${ma_hh}    ${result_toncuoi}    ${item_soluong}    ${get_giatri_quydoi}    IN ZIP    ${get_list_hh_in_hd_af_execute}
    ...    ${result_list_toncuoi_new}    ${list_soluong_in_hd}    ${list_giatri_quydoi_in_hd}
    \    Run Keyword If    '${get_giatri_quydoi}' == '1'    Validate product history frm API    ${invoice_code}    ${ma_hh}    ${result_toncuoi}
    \    ...    ${item_soluong}
    \    ...    ELSE    Validate unit product history frm API    ${invoice_code}    ${ma_hh}    ${result_toncuoi}
    \    ...    ${item_soluong}    ${get_giatri_quydoi}
    #validate product
    ${list_order_summary_af_execute}    Get list order summary frm product API    ${get_list_hh_in_hd_af_execute}
    : FOR    ${result_tong_dh}    ${order_summary_af_execute}    IN ZIP    ${list_result_tongdh_new}    ${list_order_summary_af_execute}
    \    Should Be Equal As Numbers    ${order_summary_af_execute}    ${result_tong_dh}
    #assert value invoice
    ${get_ma_kh_by_hd}    ${get_tong_tien_hang}    ${get_khach_tt}    ${get_trangthai}    ${get_ghichu_in_hd_af_execute}    Get invoice info have note by invoice code    ${invoice_code}
    Should Be Equal As Numbers    ${get_tong_tien_hang}    ${result_tongtienhang}
    Should Be Equal As Numbers    ${get_khach_tt}    ${actual_khtt}
    Should Be Equal As Strings    ${get_ma_kh_by_hd}    ${input_ma_kh}
    Should Be Equal As Strings    ${get_trangthai}    Hoàn thành
    Should Be Equal As Strings    ${get_ghichu_in_hd_af_execute}    ${get_ghichu_bf_execute}
    #assert value order
    ${get_ma_kh_in_dh_af_execute}    ${get_TTDH_in_dh_af_execute}    ${get_tongtienhang_in_dh_af_exxecute}    ${get_khachdatra_in_dh_af_execute}    ${get_ghichu_af_execute}    Get order info have note by order code    ${order_code}
    Should Be Equal As Strings    ${get_ma_kh_in_dh_af_execute}    ${input_ma_kh}
    Should Be Equal As Strings    ${get_TTDH_in_dh_af_execute}    3    #trạng thái hoàn thành
    Should Be Equal As Numbers    ${get_tongtienhang_in_dh_af_exxecute}    ${get_tongtienhang_in_dh_bf_execute}
    Should Be Equal As Numbers    ${get_khachdatra_in_dh_af_execute}    ${result_khachthanhtoan_in_dh}
    Should Be Equal As Strings    ${get_ghichu_af_execute}    ${get_ghichu_bf_execute}
    Validate invoice history frm Order    ${order_code}    ${invoice_code}    ${result_tongtienhang}
    Delete invoice by invoice code    ${invoice_code}
    Delete order frm Order code    ${order_code}
