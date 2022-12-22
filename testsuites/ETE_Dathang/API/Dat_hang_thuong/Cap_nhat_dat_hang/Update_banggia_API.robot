*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}      ${headless_browser}
Resource          ../../../../../core/API/api_danhmuc_hanghoa.robot
Resource          ../../../../../core/API/api_dathang.robot
Resource          ../../../../../core/API/api_khachhang.robot
Resource          ../../../../../core/API/api_mhbh.robot
Resource          ../../../../../core/API/api_mhbh_dathang.robot
Resource          ../../../../../core/Dat_Hang/dat_hang_action.robot
Resource          ../../../../../core/Dat_Hang/dat_hang_navigation.robot
Resource          ../../../../../core/Dat_Hang/dat_hang_page.robot
Resource          ../../../../../core/share/toast_message.robot
Resource          ../../../../../core/API/api_soquy.robot
Resource          ../../../../../config/env_product/envi.robot
Library           Collections
*** Variables ***
&{list_product_u4}    HH0047=2    SI030=1    DVT50=1.75    DV054=2.7    Combo31=1

*** Test Cases ***    Mã KH         Tên Bảng giá         Khách thanh toán    Ghi chú
updateDH_changeBG     [Tags]        AEDU     ED
                      [Template]    aetedh_ud4
                      CTKH090       Bảng giá đặt hàng    0                   Thanh toán khi nhận hàng    ${list_product_u4}

*** Keywords ***
aetedh_ud4
    [Arguments]    ${input_ma_kh}    ${input_ten_bangia}    ${input_khtt}    ${input_ghichu}    ${dic_product_nums}
    #get info product, customer
    ${order_code}    Add new order with multi product and no payment - get order code    ${input_ma_kh}    ${dic_product_nums}
    ${get_khachdatra_in_dh_bf_execute}    ${get_tongtienhang_in_dh_bf_execute}    Get paid value frm API    ${order_code}
    ${get_list_hh_in_dh_bf_execute}   ${get_list_sl_in_order}    Get list product and quantity frm API    ${order_code}
    ${list_tongdh_bf_execute}    Get list order summary frm product API    ${get_list_hh_in_dh_bf_execute}
    #get order summary and sub total of products
    ${get_id_banggia}    ${list_giaban_new}    Get list gia ban from PriceBook api    ${input_ten_bangia}    ${get_list_hh_in_dh_bf_execute}
    #compute
    ${list_result_thanhtien}    Create List
    : FOR    ${ma_hh}    ${giaban}    IN ZIP    ${get_list_hh_in_dh_bf_execute}    ${list_giaban_new}
    \    ${list_result_thanhtien}    Get TTH with change pricebook    ${order_code}    ${ma_hh}    ${giaban}    ${list_result_thanhtien}
    ${result_tongtienhang}    Sum values in list and round    ${list_result_thanhtien}
    ${result_khachcantra}    Minus and replace floating point    ${result_tongtienhang}    ${get_khachdatra_in_dh_bf_execute}
    ${actual_khtt_all}    Set Variable If    '${input_khtt}' == 'all'    ${result_khachcantra}    ${input_khtt}
    ${actual_khtt}    Set Variable If    '${input_khtt}' == '0'    0    ${actual_khtt_all}
    ${actual_khtt_paymented}    Sum and replace floating point    ${actual_khtt}    ${get_khachdatra_in_dh_bf_execute}
    ${result_actual_khtt}    Set Variable If    '${input_khtt}' == 'all'    ${actual_khtt}    ${actual_khtt_paymented}
    #update BG by post api
    ${get_order_id}   ${get_payment_id}   Get order - payment frm order api    ${order_code}
    ${get_list_order_detail_id}   Get list orderdetail id frm order api    ${order_code}    ${get_list_hh_in_dh_bf_execute}
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${jsonpath_id_kh}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_kh}
    ${get_id_kh}    Get data from API    ${endpoint_khachhang}    ${jsonpath_id_kh}
    ${endpoint_danhmuc_hh_co_dvt}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${get_resp_danhmuc_hh}    Get Request and return body    ${endpoint_danhmuc_hh_co_dvt}
    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}    Get list jsonpath product frm list product    ${get_list_hh_in_dh_bf_execute}
    ${list_giaban}    ${list_id_sp}    Get product info frm list jsonpath product    ${get_resp_danhmuc_hh}    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}
    ${liststring_prs_order_detail}     Set Variable      needdel
    Log        ${liststring_prs_order_detail}
    : FOR    ${item_orderdetail_id}    ${item_gia_ban}   ${item_id_sp}   ${item_soluong}      IN ZIP       ${get_list_order_detail_id}       ${list_giaban_new}        ${list_id_sp}    ${get_list_sl_in_order}
    \    ${payload_each_product}        Format string       {{"BasePrice":550000,"Id":{0},"IsLotSerialControl":false,"IsMaster":true,"IsRewardPoint":false,"MaxQuantity":0,"Note":"","Price":{1},"ProductCode":"Combo56","ProductId":{2},"ProductName":"Combo dưỡng da 2","Quantity":{3},"Uuid":"","ProductBatchExpireId":null}}       ${item_orderdetail_id}    ${item_gia_ban}   ${item_id_sp}   ${item_soluong}
    \    ${liststring_prs_order_detail}       Catenate      SEPARATOR=,      ${liststring_prs_order_detail}      ${payload_each_product}
    ${liststring_prs_order_detail}       Replace String      ${liststring_prs_order_detail}       needdel,       ${EMPTY}      count=1
    ${request_payload}    Format String    {{"Order":{{"Id":{0},"BranchId":{1},"RetailerId":{2},"CustomerId":{3},"SoldById":{4},"SoldBy":{{"CreatedBy":0,"CreatedDate":"2018-12-10T10:44:15.970Z","Email":"","GivenName":"admin","Id":{4},"IsActive":true,"IsAdmin":true,"Type":0,"UserName":"admin","isDeleted":false,"Name":"admin"}},"SaleChannelId":0,"SaleChannel":null,"Seller":{{"CreatedBy":0,"CreatedDate":"2018-12-10T10:44:15.970Z","Email":"","GivenName":"admin","Id":{4},"IsActive":true,"IsAdmin":true,"Type":0,"UserName":"admin","isDeleted":false,"Name":"admin"}},"PricebookId":{5},"PurchaseDate":"","Code":"DH001258","Discount":0,"OrderDetails":[{6}],"InvoiceOrderSurcharges":[],"Payments":[],"UsingCod":0,"Status":1,"Total":1554774,"Description":"{7}","Extra":"{{\\"Amount\\":0,\\"Method\\":{{\\"Id\\":\\"Cash\\",\\"Label\\":\\"Tiền mặt\\"}},\\"PriceBookId\\":{{\\"CreatedBy\\":{4},\\"CreatedDate\\":\\"2019-03-15T10:03:14.523Z\\",\\"EndDate\\":\\"2020-03-14T10:03:04.220Z\\",\\"ForAllCusGroup\\":true,\\"Id\\":{5},\\"IsActive\\":true,\\"IsGlobal\\":true,\\"Name\\":\\"Bảng giá đặt hàng\\",\\"PriceBookCustomerGroups\\":[],\\"RetailerId\\":{2},\\"StartDate\\":\\"2019-03-15T10:03:04.220Z\\"}},\\"ResetPromotion\\":false}}","Surcharge":0,"Type":2,"Uuid":"W156325170059267","addToAccount":"0","PayingAmount":0,"TotalBeforeDiscount":1671800,"ProductDiscount":0,"CreatedBy":160324,"CreatedDate":"","InvoiceWarranties":[]}}}}     ${get_order_id}   ${BRANCH_ID}    ${get_id_nguoitao}    ${get_id_kh}    ${get_id_nguoiban}
    ...   ${get_id_banggia}   ${liststring_prs_order_detail}   ${input_ghichu}
    Log    ${request_payload}
    ${order_code}    Post request to create order and return code    ${request_payload}
    #get values
    Sleep    20 s    wait for response to API
    #validate product
    ${get_list_hh_in_dh_af_execute}    Get list product frm API    ${order_code}
    ${list_order_summary_af_execute}    Get list order summary frm product API    ${get_list_hh_in_dh_af_execute}
    : FOR    ${ma_hh}    ${giaban_new}    ${result_tong_dh}    ${order_summary_af_execute}    IN ZIP    ${get_list_hh_in_dh_af_execute}
    ...    ${list_giaban_new}    ${list_tongdh_bf_execute}    ${list_order_summary_af_execute}
    \    Should Be Equal As Numbers    ${order_summary_af_execute}    ${result_tong_dh}
    \    Validate price when change pricebook    ${ma_hh}    ${order_code}    ${giaban_new}
    #assert value order
    ${get_ma_kh_in_dh_af_execute}    ${get_TTDH_in_dh_af_execute}    ${get_tongtienhang_in_dh_af_exxecute}    ${get_khachdatra_in_dh_af_execute}    ${get_ghichu_af_execute}    Get order info have note by order code    ${order_code}
    Should Be Equal As Strings    ${get_ma_kh_in_dh_af_execute}    ${input_ma_kh}
    Should Be Equal As Numbers    ${get_TTDH_in_dh_af_execute}    1    #1 : phiếu tạm
    Should Be Equal As Numbers    ${get_tongtienhang_in_dh_af_exxecute}    ${result_tongtienhang}
    Should Be Equal As Numbers    ${get_khachdatra_in_dh_af_execute}    ${actual_khtt_paymented}
    Should Be Equal As Strings    ${get_ghichu_af_execute}    ${input_ghichu}
    Delete order frm Order code    ${order_code}
