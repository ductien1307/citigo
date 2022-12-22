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
Library           BuiltIn
*** Variables ***
&{list_product_u5}    HH0048=3.5    SI031=2    QD110=1.75    DV055=3    Combo32=1

*** Test Cases ***    Mã KH         Mã KH update    Khách thanh toán    Ghi chú
Update_customer
                      [Tags]        AEDU1     ED
                      [Template]    aetedh_ud5
                      CTKH091      CTKH092         1000000             Đã đặt cọc                  ${list_product_u5}

*** Keywords ***
aetedh_ud5
    [Arguments]    ${input_ma_kh}    ${input_ma_kh_update}    ${input_khtt}   ${input_ghichu}    ${dic_product_nums}
    #get info product, customer
    ${order_code}    Add new order with multi product and no payment - get order code    ${input_ma_kh}    ${dic_product_nums}
    ${get_khachdatra_in_dh_bf_execute}    ${get_tongtienhang_in_dh_bf_execute}    Get paid value frm API    ${order_code}
    ${get_no_bf_execute}    ${get_tongban_bf_execute}    ${get_tongban_tru_trahang_bf_execute}    Get Customer Debt from API    ${input_ma_kh}
    ${get_no_kh_update_bf_execute}    ${get_tongban_kh_update_bf_execute}    ${get_tongban_tru_trahang_kh_update_bf_execute}    Get Customer Debt from API    ${input_ma_kh_update}
    ${get_list_hh_in_dh_bf_execute}   ${get_list_sl_in_order}    Get list product and quantity frm API    ${order_code}
    ${list_tongdh_bf_execute}    Get list order summary frm product API    ${get_list_hh_in_dh_bf_execute}
    #compute
    ${get_tongtienhang_in_dh_bf_execute}    Replace floating point    ${get_tongtienhang_in_dh_bf_execute}
    ${actual_khtt_all}    Set Variable If    '${input_khtt}' == 'all'    ${get_tongtienhang_in_dh_bf_execute}    ${input_khtt}
    ${actual_khtt}    Set Variable If    '${input_khtt}' == '0'    0    ${actual_khtt_all}
    ${actual_khtt_paymented}    Sum and replace floating point    ${actual_khtt}    ${get_khachdatra_in_dh_bf_execute}
    ${result_actual_khtt}    Set Variable If    ${get_khachdatra_in_dh_bf_execute} > 0 and '${input_khtt}' == 'all'    ${actual_khtt}    ${actual_khtt_paymented}    #tính lại tổng cộng với đơn hàng đã đặt cọc khi thay đổi khách hàng
    ${result_no_hientai_kh}    Minus and replace floating point    ${get_no_bf_execute}    ${get_khachdatra_in_dh_bf_execute}
    ${result_tongban_kh}    Minus and replace floating point    ${get_tongban_bf_execute}    ${get_khachdatra_in_dh_bf_execute}
    ${result_no_hientai_kh_update}    Minus and replace floating point    ${get_no_kh_update_bf_execute}    ${actual_khtt}
    #update data into order form
    ${get_order_id}   ${get_payment_id}   Get order - payment frm order api    ${order_code}
    ${get_list_order_detail_id}   Get list orderdetail id frm order api    ${order_code}    ${get_list_hh_in_dh_bf_execute}
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${jsonpath_id_kh}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_kh_update}
    ${get_id_kh}    Get data from API    ${endpoint_khachhang}    ${jsonpath_id_kh}
    ${endpoint_danhmuc_hh_co_dvt}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${get_resp_danhmuc_hh}    Get Request and return body    ${endpoint_danhmuc_hh_co_dvt}
    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}    Get list jsonpath product frm list product    ${get_list_hh_in_dh_bf_execute}
    ${list_giaban}    ${list_id_sp}    Get product info frm list jsonpath product    ${get_resp_danhmuc_hh}    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}
    ${liststring_prs_order_detail}     Set Variable      needdel
    Log        ${liststring_prs_order_detail}
    : FOR    ${item_orderdetail_id}    ${item_gia_ban}   ${item_id_sp}   ${item_soluong}      IN ZIP       ${get_list_order_detail_id}       ${list_giaban}        ${list_id_sp}    ${get_list_sl_in_order}
    \    ${payload_each_product}        Format string       {{"BasePrice":550000,"Discount":0,"DiscountRatio":0,"Id":{0},"IsLotSerialControl":false,"IsMaster":true,"IsRewardPoint":false,"MaxQuantity":0,"Note":"","Price":{1},"ProductCode":"Combo56","ProductId":{2},"ProductName":"Combo dưỡng da 2","Quantity":{3},"Uuid":"","ProductBatchExpireId":null}}       ${item_orderdetail_id}    ${item_gia_ban}   ${item_id_sp}   ${item_soluong}
    \    ${liststring_prs_order_detail}       Catenate      SEPARATOR=,      ${liststring_prs_order_detail}      ${payload_each_product}
    ${liststring_prs_order_detail}       Replace String      ${liststring_prs_order_detail}       needdel,       ${EMPTY}      count=1
    ${request_payload}    Format String    {{"Order":{{"Id":{0},"BranchId":{1},"RetailerId":{2},"CustomerId":{3},"SoldById":{4},"SoldBy":{{"CreatedBy":0,"CreatedDate":"2018-12-10T10:44:15.970Z","Email":"","GivenName":"admin","Id":{4},"IsActive":true,"IsAdmin":true,"Type":0,"UserName":"admin","isDeleted":false,"Name":"admin"}},"SaleChannelId":0,"SaleChannel":null,"Seller":{{"CreatedBy":0,"CreatedDate":"2018-12-10T10:44:15.970Z","Email":"","GivenName":"admin","Id":{4},"IsActive":true,"IsAdmin":true,"Type":0,"UserName":"admin","isDeleted":false,"Name":"admin"}},"PurchaseDate":"","Code":"DH001317","Discount":"","OrderDetails":[{5}],"InvoiceOrderSurcharges":[],"Payments":[{{"Method":"Cash","MethodStr":"Tiền mặt","Amount":{6},"Id":-1}}],"UsingCod":0,"Status":1,"Total":1671800,"Extra":"{{\\"Amount\\":1000000,\\"Method\\":{{\\"Id\\":\\"Cash\\",\\"Label\\":\\"Tiền mặt\\"}},\\"ResetPromotion\\":false}}","Surcharge":0,"Type":2,"Uuid":"","addToAccount":"0","PayingAmount":1000000,"TotalBeforeDiscount":1671800,"ProductDiscount":0,"CreatedBy":160324,"CreatedDate":"","InvoiceWarranties":[]}}}}     ${get_order_id}   ${BRANCH_ID}    ${get_id_nguoitao}    ${get_id_kh}    ${get_id_nguoiban}
    ...   ${liststring_prs_order_detail}   ${actual_khtt}
    Log    ${request_payload}
    ${order_code}    Post request to create order and return code    ${request_payload}
    #get values
    Sleep    20 s    wait for response to API
    #assert value product
    ${get_list_hh_in_dh_af_execute}    Get list product frm API    ${order_code}
    ${list_order_summary_af_execute}    Get list order summary frm product API    ${get_list_hh_in_dh_af_execute}
    : FOR    ${result_tong_dh}    ${order_summary_af_execute}    IN ZIP    ${list_tongdh_bf_execute}    ${list_order_summary_af_execute}
    \    Should Be Equal As Numbers    ${order_summary_af_execute}    ${result_tong_dh}
    #assert value order
    ${get_ma_kh_in_dh_af_execute}    ${get_TTDH_in_dh_af_execute}    ${get_tongtienhang_in_dh_af_exxecute}    ${get_khachdatra_in_dh_af_execute}    ${get_ghichu_af_execute}    Get order info have note by order code    ${order_code}
    Should Be Equal As Strings    ${get_ma_kh_in_dh_af_execute}    ${input_ma_kh_update}
    Should Be Equal As Numbers    ${get_TTDH_in_dh_af_execute}    1    #1 : phiếu tạm
    Should Be Equal As Numbers    ${get_tongtienhang_in_dh_af_exxecute}    ${get_tongtienhang_in_dh_bf_execute}
    Should Be Equal As Numbers    ${get_khachdatra_in_dh_af_execute}    ${actual_khtt_paymented}
    Should Be Equal As Strings    ${get_ghichu_af_execute}    0
    #assert value khach hang after delete
    ${get_no_af_execute}    ${get_tongban_af_execute}    ${get_tongban_tru_trahang_af_execute}    Get Customer Debt from API    ${input_ma_kh}
    Should Be Equal As Numbers    ${get_no_af_execute}    ${result_no_hientai_kh}
    Should Be Equal As Numbers    ${get_tongban_af_execute}    ${result_tongban_kh}
    Delete order frm Order code    ${order_code}
