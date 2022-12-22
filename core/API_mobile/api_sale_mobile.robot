*** Settings ***
Library           Collections
Library           RequestsLibrary
Library           AppiumLibrary
Library           OperatingSystem
Library           String
Library           JSONLibrary
Library           StringFormat
Resource          api_product_list_mobile.robot
Resource          api_access_mobile.robot
Resource          api_doitac_mobile.robot
Resource          ../API/api_khachhang.robot
Resource          ../share/list_dictionary.robot
Resource          ../share/imei.robot
Resource          ../share/computation.robot

*** Keywords ***
Add new invoice from mobile api
    [Arguments]    ${input_ma_kh}    ${dict_product_nums}   ${input_gghd}    ${input_khtt}
    ${Uuid}      Generate Random String    4    [NUMBERS][NUMBERS]
    ${Uuid_code}      Catenate      SEPARATOR=      WA     ${Uuid}
    ${list_product}    Get Dictionary Keys      ${dict_product_nums}
    ${list_nums}      Get Dictionary Values    ${dict_product_nums}
    Create list imei and other product    ${list_product}    ${list_nums}
    #get product info
    ${get_id_nguoiban}    Get User ID frm mobile api
    ${get_id_kh}    Get customer id thr API      ${input_ma_kh}
    ${list_giaban}    ${list_id_sp}    Get list product id and base price frm mobile API    ${list_product}
    ${list_result_thanhtien}    Create List
    : FOR    ${item_giaban}    ${item_nums}    IN ZIP    ${list_giaban}    ${list_nums}
    \    ${result_thanhtien}    Multiplication with price round 2    ${item_giaban}    ${item_nums}
    \    Append To List    ${list_result_thanhtien}    ${result_thanhtien}
    ${result_tongtienhang}    Sum values in list    ${list_result_thanhtien}
    ${giamgia_hd}    Set Variable If    0 < ${input_gghd} < 100    ${input_gghd}    null
    ${result_gghd}    Run Keyword If    0 < ${input_gghd} < 100    Convert % discount to VND    ${result_tongtienhang}    ${input_gghd}    ELSE    Set Variable    ${input_gghd}
    ${result_khtt}    Minus    ${result_tongtienhang}    ${result_gghd}
    ${actual_khtt}    Set Variable If    '${input_khtt}' == 'all'    ${result_khtt}    ${input_khtt}
    #post request
    ${liststring_prs_invoice_detail}    Set Variable    needdel
    Log    ${liststring_prs_invoice_detail}
    : FOR    ${item_product}    ${item_gia_ban}    ${item_id_sp}    ${item_soluong}    ${item_imei}    IN ZIP    ${list_product}    ${list_giaban}    ${list_id_sp}    ${list_nums}    ${imei_inlist}
    \    ${item_imei}    Convert list to string and return    ${item_imei}
    \    ${payload_each_product}    Format string    {{"ProductId":{0},"Quantity":{1},"Discount":0,"Price":{2},"Note":"","SerialNumbers":"{3}","IsRewardPoint":false,"UsePoint":false,"CategoryId":947999,"DiscountRatio":0,"IsMaster":true,"MasterProductId":22540574,"OriginPrice":300000.0,"ProductCode":"{4}","ProductFullName":"Máy Vắt Cam Lock&Lock EJJ231","Weight":0.0000}}    ${item_id_sp}    ${item_soluong}    ${item_gia_ban}    ${item_imei}    ${item_product}
    \    ${liststring_prs_invoice_detail}    Catenate    SEPARATOR=,    ${liststring_prs_invoice_detail}    ${payload_each_product}
    ${liststring_prs_invoice_detail}    Replace String    ${liststring_prs_invoice_detail}    needdel,    ${EMPTY}    count=1
    ${payment_payload}    Run Keyword If    '${input_khtt}'=='0'    Set Variable    ${EMPTY}    ELSE      Format String    {{"Amount":{0},"Method":"Cash"}}    ${actual_khtt}
    ${request_payload}    Format String    {{"Invoice":{{"Discount":{0},"DiscountRatio":{1},"Status":1,"CustomerId":{2},"SoldById":{3},"Payments":[{4}],"InvoiceDetails":[{5}],"Uuid":"{6}","Point":0.0,"IsPayByPoint":false,"BranchId":{7},"PriceBookId":0,"ActiveCustomerGroupId":0,"DepositReturn":0.0,"InvoiceOrderSurcharges":[],"InvoicePromotions":[],"InvoiceWarranties":[],"PayingAmount":500000.0000,"SaleChannelId":0,"Surcharge":0,"Id":0,"Total":1207025.0000,"TotalInvoice":997550.0000,"TotalPaymentInvoice":500000.0000,"UsingCod":0}}}}       ${result_gghd}    ${giamgia_hd}    ${get_id_kh}    ${get_id_nguoiban}    ${payment_payload}    ${liststring_prs_invoice_detail}    ${Uuid_code}     ${BRANCH_ID}
    Log    ${request_payload}
    : FOR    ${time}    IN RANGE    5
    \    ${resp.status_code}    ${resp.json()}    Post request thr mobile API    /invoices    ${request_payload}
    \    Exit For Loop If    '${resp.status_code}'=='200'
    ${string}    Convert To String    ${resp.json()}
    ${dict}    Set Variable    ${resp.json()}
    ${invoice_code}    Get From Dictionary    ${dict}    Code
    Return From Keyword    ${invoice_code}
