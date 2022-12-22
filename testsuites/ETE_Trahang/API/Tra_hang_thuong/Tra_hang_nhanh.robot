*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    ${headless_browser}
Test Teardown     After Test
Resource          ../../../../core/API/api_danhmuc_hanghoa.robot
Resource          ../../../../core/API/api_khachhang.robot
Resource          ../../../../core/API/api_mhbh.robot
Resource          ../../../../core/share/toast_message.robot
Resource          ../../../../core/API/api_soquy.robot
Resource          ../../../../core/share/javascript.robot
Resource          ../../../../core/Tra_hang/tra_hang_action.robot
Resource          ../../../../core/API/api_trahang.robot
Resource          ../../../../core/Tra_hang/tra_hang_page.robot
Resource          ../../../../core/Tra_hang/tra_hang_popup_page.robot
Resource          ../../../../core/Ban_Hang/banhang_action.robot
Resource          ../../../../core/Ban_Hang/banhang_page.robot

*** Variables ***
&{list_product1}    HH0078=5.6    SI060=1    DVT79=3.5    DV084=2    Combo63=1
&{list_product2}    HH0079=5.6    SI061=2    DVT80=3.5    DV085=2    Combo64=1
&{list_product3}    HH0080=5.6    SI062=1    DVT81=3.5    DV086=2    Combo65=1
@{list_discount}    20    10000.33    0    200000.05    28000
@{discount_type}    dis    disvnd    none    changeup    changedown

*** Test Cases ***    Mã KH         List products       List GGSP           Discount type       GGTH     Phí trả hàng    Khách thanh toán
Giam_gia              [Tags]        AETHN               ET
                      [Template]    etna1
                      CTKH123       ${list_product2}    ${list_discount}    ${discount_type}    0        10              0
                      CTKH124      ${list_product1}    ${list_discount}    ${discount_type}    10000    20000           all
                      CTKH125      ${list_product3}    ${list_discount}    ${discount_type}    15       0               200000

*** Keywords ***
etna1
    [Arguments]    ${input_ma_kh}    ${dict_product_nums}    ${list_ggsp}    ${list_discount_type}    ${input_ggth}    ${input_phi_th}
    ...    ${input_khtt}
    Set Selenium Speed    0.5s
    #get info tra hang
    ${list_products}    Get Dictionary Keys    ${dict_product_nums}
    ${list_nums}    Get Dictionary Values    ${dict_product_nums}
    ${get_list_status_product}    Get list imei status thr API    ${list_products}
    Create invoice with imei product    ${input_ma_kh}    ${dict_product_nums}    ${get_list_status_product}
    #get data to validate
    ${get_list_baseprice}    Get list of Baseprice by Product Code    ${list_products}
    ${list_result_thanhtien}    ${list_giavon}    ${list_result_toncuoi}    ${list_result_newprice}    Get list total sale - endingstock - cost - newprice incase discount frm api    ${list_products}    ${list_nums}
    ...    ${list_ggsp}    ${list_discount_type}
    #compute
    ${result_tongtienhangtra}    Sum values in list and round    ${list_result_thanhtien}
    ${result_ggth}    Run Keyword If    0 < ${input_ggth} < 100    Convert % discount to VND and round    ${result_tongtienhangtra}    ${input_ggth}
    ...    ELSE    Set Variable    ${input_ggth}
    ${result_phi_th}    Run Keyword If    0 < ${input_phi_th} < 100    Convert % discount to VND and round    ${result_tongtienhangtra}    ${input_phi_th}
    ...    ELSE    Set Variable    ${input_phi_th}
    ${result_cantrakhach}    Minusx3 and replace foating point    ${result_tongtienhangtra}    ${result_ggth}    ${result_phi_th}
    ${result_khtt}    Set Variable If    "${input_khtt}" == "all"    ${result_cantrakhach}    ${input_khtt}
    ${actual_khtt}    Set Variable If    "${input_khtt}" == "0"    0    ${result_khtt}
    #
    ${endpoint_danhmuc_hh_by_branch}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${resp_product_list}    Get Request and return body    ${endpoint_danhmuc_hh_by_branch}
    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}    Get List Jsonpath Product Frm List Product    ${list_products}
    ${list_giaban}    ${list_productid}    Get product info frm list jsonpath product    ${resp_product_list}    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}
    ##
    ${Uuid}      Generate Random String    4    [NUMBERS][NUMBERS]
    ${Uuid_code}      Catenate      SEPARATOR=      WA     ${Uuid}
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${jsonpath_id_kh}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_kh}
    ${get_id_kh}    Get data from API    ${endpoint_khachhang}    ${jsonpath_id_kh}
    ${giamgia_th}    Set Variable If    0 < ${input_ggth} < 100    ${input_ggth}    null
    # Post request BH
    ${liststring_prs_invoice_detail}    Set Variable    needdel
    Log    ${liststring_prs_invoice_detail}
    : FOR    ${item_product_id}    ${item_price}    ${item_num}    ${item_ggsp}    ${item_result_newprice}    ${item_imei}
    ...    IN ZIP    ${list_productid}    ${list_giaban}    ${list_nums}    ${list_ggsp}    ${list_result_newprice}
    ...    ${imei_inlist}
    \    ${item_imei}    Convert list to string and return    ${item_imei}
    \    ${item_ggsp}    Set Variable If    0 < ${item_ggsp} < 100    ${item_ggsp}    0
    \    ${payload_each_product}    Format string    {{"BasePrice":{0},"IsLotSerialControl":true,"Note":"","Price":{1},"ProductId":{2},"Quantity":{3},"SerialNumbers":"{4}","SellPrice":{0},"ProductName":"chuột quang hồng","Discount":{5},"DiscountRatio":{6},"CopiedPrice":134216.23,"ProductBatchExpireId":null}}    ${item_price}    ${item_result_newprice}    ${item_product_id}
    \    ...    ${item_num}    ${item_imei}    ${item_result_newprice}    ${item_ggsp}
    \    ${liststring_prs_invoice_detail}    Catenate    SEPARATOR=,    ${liststring_prs_invoice_detail}    ${payload_each_product}
    Log    ${liststring_prs_invoice_detail}
    ${liststring_prs_invoice_detail}    Replace String    ${liststring_prs_invoice_detail}    needdel,    ${EMPTY}    count=1
    ${request_payload}    Format String    {{"Return":{{"BranchId":{0},"RetailerId":{1},"CustomerId":{2},"ReceivedById":{3},"ReceivedBy":{{"CreatedBy":0,"CreatedDate":"2019-04-23T10:22:08.910Z","Email":"","GivenName":"admin","Id":20447,"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false}},"SaleChannelId":0,"SaleChannel":null,"Code":"Trả hàng 1","ReturnDiscount":{4},"ReturnFee":{5},"ReturnFeeRatio":{6},"ReturnDetails":[{8}],"InvoiceDetails":[],"InvoiceOrderSurcharges":[],"Payments":[{{"Method":"Cash","MethodStr":"Tiền mặt","Amount":{7},"Id":-1}}],"Status":1,"Surcharge":0,"Type":3,"Uuid":"{9}","PayingAmount":{7},"TotalBeforeDiscount":0,"ProductDiscount":0,"TotalReturn":262626,"txtPay":"Tiền trả khách","addToAccount":"0","addToAccountSurplus":"0","addToAccountAllocation":"0","addToAccountPaymentAllocation":"0","ReturnSurcharges":[],"CreatedBy":20447}}}}    ${BRANCH_ID}    ${get_id_nguoitao}    ${get_id_kh}    ${get_id_nguoiban}
    ...    ${result_ggth}    ${result_phi_th}    ${input_phi_th}    ${actual_khtt}    ${liststring_prs_invoice_detail}    ${Uuid_code}
    Log    ${request_payload}
    ${return_code}    Post request to create return and get resp    ${request_payload}
    Sleep    20 s    wait for response to API
    #assert value product in invoice
    ${get_list_hh_in_th_af_execute}    Get list product frm Return API    ${return_code}
    ${list_soluong_in_hd}    ${list_giatriquydoi_in_hd}    Get list quantity and gia tri quy doi with return have multi product    ${get_list_hh_in_th_af_execute}    ${return_code}
    : FOR    ${item_ma_hh}    ${result_toncuoi}    ${item_giavon}    ${get_soluong_in_hd}    ${get_giatri_quydoi}    IN ZIP
    ...    ${get_list_hh_in_th_af_execute}    ${list_result_toncuoi}    ${list_giavon}    ${list_soluong_in_hd}    ${list_giatriquydoi_in_hd}
    \    Run Keyword If    '${get_giatri_quydoi}' == '1'    Validate onhand and cost frm API    ${return_code}    ${item_ma_hh}    ${result_toncuoi}
    \    ...    ${item_giavon}    ${get_soluong_in_hd}
    \    ...    ELSE    Validate onhand and cost frm unit product    ${return_code}    ${item_ma_hh}    ${result_toncuoi}
    \    ...    ${item_giavon}    ${get_soluong_in_hd}    ${get_giatri_quydoi}
    #assert value in return
    ${get_tongtienhangtra_af_ex}    ${get_giamgiaphieutra}    ${get_phitrahang_af_ex}    ${get_cantrakhach_af_ex}    ${get_datrakhach_af_ex}    ${get_tongtien_hoadontra_af_ex}    Get return info incase discount by return code
    ...    ${return_code}
    Should Be Equal As Numbers    ${get_tongtienhangtra_af_ex}    ${result_tongtienhangtra}
    Should Be Equal As Numbers    ${get_giamgiaphieutra}    ${result_ggth}
    Should Be Equal As Numbers    ${get_phitrahang_af_ex}    ${result_phi_th}
    Should Be Equal As Numbers    ${get_datrakhach_af_ex}    ${actual_khtt}
    Should Be Equal As Numbers    ${get_tongtien_hoadontra_af_ex}    ${result_cantrakhach}
    Delete return thr API    ${return_code}
