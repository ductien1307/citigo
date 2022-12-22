*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    ${headless_browser}
Resource          ../../../../core/API/api_danhmuc_hanghoa.robot
Resource          ../../../../core/API/api_dathang.robot
Resource          ../../../../core/API/api_khachhang.robot
Resource          ../../../../core/API/api_mhbh_dathang.robot
Resource          ../../../../core/Dat_Hang/dat_hang_action.robot
Resource          ../../../../core/Dat_Hang/dat_hang_navigation.robot
Resource          ../../../../core/Dat_Hang/dat_hang_page.robot
Resource          ../../../../core/share/toast_message.robot
Resource          ../../../../core/API/api_soquy.robot
Resource          ../../../../core/API/api_thietlap.robot
Resource          ../../../../config/env_product/envi.robot
Library           Collections
Resource          ../../../../core/API/api_thietlap.robot

*** Variables ***
@{list_product_delete}    DVT63
@{discount}    15    20000    0    80000
@{discount_type}   dis     disvnd    none    changeup
&{list_product_tk03}    HH0060=5    SI043=2    DVT63=2.8    DV067=3    Combo44=1

*** Test Cases ***    Mã KH              Mã thu khác      Khách thanh toán    Ghi chú ĐH       List sản phẩm           List giá mới        List product to create    Khách thanh toán to create
Tudong_DH_1thukhac    [Documentation]    1. Cập nhật đơn đặt hàng được tạo qua API, xóa sản phẩm và thay đổi giá cho đơn hàng \n2. Thu khác tự động cập nhật vào đơn hàng và có 1 thu khác tính theo %\n3. Validate dữ diệu hàng hóa, công nợ khách hàng, sổ quỹ
                      [Tags]             AEDTKA
                      [Template]         etedh_ud_tk1_api
                      CTKH106            TK001          all                 Đã thanh toán    ${list_product_delete}    ${discount}    ${discount_type}    ${list_product_tk03}    0

*** Keywords ***
etedh_ud_tk1_api
    [Arguments]    ${input_ma_kh}    ${input_thukhac}    ${input_khtt}    ${input_ghichu}    ${list_product}    ${list_giamoi}
    ...    ${dict_product_nums}    ${input_khtt_create}
    #get info to validate
    ${order_code}    Add new order have surcharge    ${input_ma_kh}    ${dict_product_nums}    ${input_thukhac}    ${input_khtt_create}
    ${get_khachdatra_in_dh_bf_execute}    ${get_tongtienhang_in_dh_bf_execute}    Get paid value frm API    ${order_code}
    ${get_no_bf_execute}    ${get_tongban_bf_execute}    ${get_tongban_tru_trahang_bf_execute}    Get Customer Debt from API    ${input_ma_kh}
    ${get_list_hh_in_dh_bf_execute}    ${get_ghichu_bf_execute}    Get ghi chu and list product frm API    ${order_code}
    #get order summary and sub total of products
    ${list_tongdh_bf_execute}    Create List
    ${index}    Set Variable    -1
    : FOR    ${ma_hh}    IN    @{list_product}
    \    Remove Values From List    ${get_list_hh_in_dh_bf_execute}    ${ma_hh}
    Log    ${get_list_hh_in_dh_bf_execute}
    ${get_list_quantity_in_dh_bf_ex}    Get list quantity by order code    ${order_code}    ${get_list_hh_in_dh_bf_execute}
    ${list_result_tongdh_delete}    Get list order summary incase delete product    ${order_code}    ${list_product}
    ${list_result_thanhtien}    ${list_result_tongdh}    Get list total sale and order summary incase newprice and delete product    ${order_code}    ${get_list_hh_in_dh_bf_execute}    ${list_giamoi}
    ##Activate surcharge
    ${surcharge_vnd_value}    Get surcharge vnd value    ${input_thukhac}
    ${surcharge_%}    Get surcharge percentage value    ${input_thukhac}
    Run Keyword If    ${surcharge_%} == 0    Toggle surcharge VND    ${input_thukhac}    true
    ...    ELSE    Toggle surcharge percentage    ${input_thukhac}    true
    ${surcharge}    Set Variable If    ${surcharge_%} == 0    ${surcharge_vnd_value}        ${surcharge_%}
    #compute
    ${result_tongtienhang}    Sum values in list    ${list_result_thanhtien}
    ${result_khachcantra_no_surchare}    Minus and replace floating point    ${result_tongtienhang}    ${get_khachdatra_in_dh_bf_execute}
    ${result_surcharge}    Convert % discount to VND and round    ${result_khachcantra_no_surchare}    ${surcharge_%}
    ${result_tongtienhang_tovalidate}    Sum    ${result_tongtienhang}    ${result_surcharge}
    ${result_khachcantra}    Sum and replace floating point    ${result_surcharge}    ${result_khachcantra_no_surchare}
    ${actual_khtt_all}    Set Variable If    '${input_khtt}' == 'all'    ${result_khachcantra}    ${input_khtt}
    ${actual_khtt}    Set Variable If    '${input_khtt}' == '0'    0    ${actual_khtt_all}
    ${actual_khtt_paymented}    Sum and replace floating point    ${actual_khtt}    ${get_khachdatra_in_dh_bf_execute}
    ${result_no_hientai_kh}    Minus and replace floating point    ${get_no_bf_execute}    ${actual_khtt}    #Do đặt hàng không ghi nhận phiếu đặt, mà phiếu thanh toán ghi nhận là số âm nên khi tính công nợ sẽ là trừ
    #delete product into BH form
    ${get_order_id}   ${get_payment_id}   Get order - payment frm order api    ${order_code}
    ${get_list_order_detail_id}   Get list orderdetail id frm order api    ${order_code}    ${get_list_hh_in_dh_bf_execute}
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${get_id_thukhac}   ${get_thutu_thukhac}    Get Id and order surchage    ${input_thukhac}
    ${jsonpath_id_kh}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_kh}
    ${get_id_kh}    Get data from API    ${endpoint_khachhang}    ${jsonpath_id_kh}
    ${endpoint_danhmuc_hh_co_dvt}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${get_resp_danhmuc_hh}    Get Request and return body    ${endpoint_danhmuc_hh_co_dvt}
    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}    Get list jsonpath product frm list product    ${get_list_hh_in_dh_bf_execute}
    ${list_giaban}    ${list_result_ggsp}    ${list_id_sp}    Get product info and new price frm list product    ${get_resp_danhmuc_hh}    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}    ${list_giamoi}
    ${liststring_prs_order_detail}     Set Variable      needdel
    Log        ${liststring_prs_order_detail}
    : FOR    ${item_result_ggsp}   ${item_orderdetail_id}    ${item_gia_ban}   ${item_id_sp}   ${item_soluong}      IN ZIP       ${list_result_ggsp}       ${get_list_order_detail_id}       ${list_giaban}        ${list_id_sp}    ${get_list_quantity_in_dh_bf_ex}
    \    ${payload_each_product}        Format string       {{"BasePrice":31000,"Discount":{0},"Id":{1},"IsLotSerialControl":false,"IsMaster":true,"IsRewardPoint":false,"MaxQuantity":0,"Note":"","Price":{2},"ProductCode":"DV055","ProductId":{3},"ProductName":"Nails 7","Quantity":{4},"Uuid":"","ProductBatchExpireId":null}}       ${item_result_ggsp}   ${item_orderdetail_id}    ${item_gia_ban}   ${item_id_sp}   ${item_soluong}
    \    ${liststring_prs_order_detail}       Catenate      SEPARATOR=,      ${liststring_prs_order_detail}      ${payload_each_product}
    ${liststring_prs_order_detail}       Replace String      ${liststring_prs_order_detail}       needdel,       ${EMPTY}      count=1
    ${request_payload}    Format String    {{"Order":{{"Id":{0},"BranchId":{1},"RetailerId":{2},"CustomerId":{3},"SoldById":{4},"SoldBy":{{"CreatedBy":0,"CreatedDate":"2018-07-30T08:27:36.800Z","GivenName":"anh.lv","Id":{4},"IsActive":true,"IsAdmin":true,"Name":"anh.lv","Type":0,"isDeleted":false}},"SaleChannelId":0,"SaleChannel":null,"Seller":{{"CreatedBy":0,"CreatedDate":"2018-07-30T08:27:36.800Z","GivenName":"anh.lv","Id":{4},"IsActive":true,"IsAdmin":true,"Name":"anh.lv","Type":0,"isDeleted":false}},"PurchaseDate":"","Code":"{5}","OrderDetails":[{6}],"InvoiceOrderSurcharges":[{{"Code":"TK001","Name":"Phí VAT1","OrderId":{0},"Price":{7},"SurValueRatio":{8},"SurchargeId":{9},"SurchargeName":"Phí VAT1"}}],"Payments":[{{"OrderValue":0,"DocumentValue":0,"PaidValue":0,"NeedPayValue":0,"CustomerName":"","CustomerCode":"","InvoiceCode":"","CustomerDebt":0,"CustomerOldDebt":0,"TargetCode":"","UserName":"","VoucherCampaignId":0,"Version":0,"IsUpdate":false,"TransGuid":"00000000000000000000000000000000","DocumentTypeValue":0,"Id":{10},"Code":"TTDH000876","Amount":{11},"AmountOriginal":0,"Method":"Cash","CreatedDate":"","CreatedBy":{4},"RetailerId":{2},"BranchId":{1},"OrderId":{0},"CustomerId":{3},"TransDate":"","UserId":{4},"Status":0,"System":false,"DeliveryPayments":[],"PaymentAllocation":[]}},{{"Method":"Cash","MethodStr":"Tiền mặt","Amount":{12},"Id":-2}}],"UsingCod":0,"Status":1,"Total":5489000,"Description":"{13}","Extra":"{{\\"Amount\\":0,\\"Method\\":{{\\"Id\\":\\"Cash\\",\\"Label\\":\\"Tiền mặt\\"}},\\"ResetPromotion\\":false}}","Surcharge":499000,"Type":2,"Uuid":"W156514787460174","addToAccount":"0","PayingAmount":0,"TotalBeforeDiscount":6116000,"ProductDiscount":1126000,"CreatedBy":201567,"CreatedDate":"","InvoiceWarranties":[]}}}}     ${get_order_id}   ${BRANCH_ID}    ${get_id_nguoitao}    ${get_id_kh}    ${get_id_nguoiban}
    ...    ${order_code}   ${liststring_prs_order_detail}    ${result_surcharge}    ${surcharge}    ${get_id_thukhac}   ${get_payment_id}    ${get_khachdatra_in_dh_bf_execute}    ${actual_khtt}     ${input_ghichu}
    Log    ${request_payload}
    ${order_code}    Post request to create order and return code    ${request_payload}
    #get values
    Sleep    20 s    wait for response to API
    #validate deleted product
    ${list_order_summary_delete_af_execute}    Get list order summary frm product API    ${list_product}
    : FOR    ${result_tong_dh_delete}    ${order_summary_delete_af_execute}    IN ZIP    ${list_result_tongdh_delete}    ${list_order_summary_delete_af_execute}
    \    Should Be Equal As Numbers    ${result_tong_dh_delete}    ${order_summary_delete_af_execute}
    #validate product
    ${get_list_hh_in_dh_af_execute}    Get list product frm API    ${order_code}
    ${list_order_summary_af_execute}    Get list order summary frm product API    ${get_list_hh_in_dh_af_execute}
    : FOR    ${result_tong_dh}    ${order_summary_af_execute}    IN ZIP    ${list_result_tongdh}    ${list_order_summary_af_execute}
    \    Should Be Equal As Numbers    ${order_summary_af_execute}    ${result_tong_dh}
    #assert value order
    ${get_ma_kh_in_dh_af_execute}    ${get_TTDH_in_dh_af_execute}    ${get_tongtienhang_in_dh_af_exxecute}    ${get_khachdatra_in_dh_af_execute}    ${get_ghichu_af_execute}    Get order info have note by order code    ${order_code}
    Should Be Equal As Strings    ${get_ma_kh_in_dh_af_execute}    ${input_ma_kh}
    Should Be Equal As Numbers    ${get_TTDH_in_dh_af_execute}    1    #1 : phiếu tạm
    Should Be Equal As Numbers    ${get_tongtienhang_in_dh_af_exxecute}    ${result_tongtienhang_tovalidate}
    Should Be Equal As Numbers    ${get_khachdatra_in_dh_af_execute}    ${actual_khtt_paymented}
    Should Be Equal As Strings    ${get_ghichu_af_execute}    ${input_ghichu}
    #assert value khach hang and so quy
    ${get_no_af_execute}    ${get_tongban_af_execute}    ${get_tongban_tru_trahang_af_execute}    Get Customer Debt from API    ${input_ma_kh}
    ${get_ma_phieutt_in_dh}    Get ma phieu thanh toan dat hang frm API    ${order_code}
    Should Be Equal As Numbers    ${get_no_af_execute}    ${result_no_hientai_kh}
    Should Be Equal As Numbers    ${get_tongban_af_execute}    ${get_tongban_bf_execute}
    Should Be Equal As Numbers    ${get_tongban_tru_trahang_af_execute}    ${get_tongban_tru_trahang_bf_execute}
    Run Keyword If    '${input_khtt}' == '0'    Validate history in customer if order is not paid    ${input_ma_kh}    ${order_code}
    ...    ELSE    Validate history and debt in customer if order is paid    ${input_ma_kh}    ${order_code}    ${actual_khtt}    ${result_no_hientai_kh}
    Run Keyword If    '${input_khtt}' == '0'    Validate So quy info if Order is not paid    ${order_code}
    ...    ELSE    Validate So quy info if Order is paid    ${get_ma_phieutt_in_dh}    ${actual_khtt}
    Run Keyword If    ${surcharge_%} == 0    Toggle surcharge VND    ${input_thukhac}    false
    ...    ELSE    Toggle surcharge percentage    ${input_thukhac}    false
    Delete order frm Order code    ${order_code}
