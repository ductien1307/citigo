*** Settings ***
Resource          ../../config/env_product/envi.robot
Resource          api_khachhang.robot
Resource          api_danhmuc_hanghoa.robot
Resource          api_access.robot
Resource          api_mhbh.robot
Resource          api_thietlap.robot
Resource          ../Ban_Hang/banhang_getandcompute.robot

*** Keywords ***
Post request to create shipping and get resp
    [Arguments]    ${request_payload}
    [Timeout]    3 minutes
    ${resp}    Post request thr API    /invoices    ${request_payload}
    Return From Keyword      ${resp}

Create new shipping with invoice have customer and carrier
    [Arguments]    ${input_ma_kh}    ${input_dtgh}    ${dict_product_nums}    ${input_khtt}
    [Timeout]    3 minutes
    ${get_id_kh}    Get customer id thr API    ${input_ma_kh}
    ${get_ten_kh}    ${get_dienthoai_kh}    ${get_diachi_kh}    ${get_khuvuc_kh}    ${get_phuongxa_kh}    Get info customer frm API    ${input_ma_kh}
    ${Uuid}      Generate Random String    4    [NUMBERS][NUMBERS]
    ${Uuid_code}      Catenate      SEPARATOR=      WA     ${Uuid}
    #get info van don
    ${list_products}    Get Dictionary Keys    ${dict_product_nums}
    ${list_nums}    Get Dictionary Values    ${dict_product_nums}
    ${list_result_thanhtien}    ${list_giavon}    ${list_result_toncuoi}    Get list total sale - endingstock - cost frm api    ${list_products}    ${list_nums}
    #
    ${get_id_dt}    Get deliverypartner id frm api    ${input_dtgh}
    ${ma_van_don}    Generate Random String       5       [LOWER]
    Set Test Variable    ${ma_van_don}    ${ma_van_don}
    #
    ${endpoint_danhmuc_hh_by_branch}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${resp_product_list}    Get Request and return body    ${endpoint_danhmuc_hh_by_branch}
    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}    Get List Jsonpath Product Frm List Product    ${list_products}
    ${list_giaban}    ${list_id_sp}    Get product info frm list jsonpath product    ${resp_product_list}    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}
    #compute
    ${result_tongtienhangtra}    Sum values in list and round    ${list_result_thanhtien}
    ${result_khtt}    Set Variable If    "${input_khtt}" == "all"    ${result_tongtienhangtra}    ${input_khtt}
    ${actual_khtt}    Set Variable If    "${input_khtt}" == "0"    0    ${result_khtt}
    ##
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    # Post request BH
    ${liststring_prs_invoice_detail}    Set Variable    needdel
    Log    ${liststring_prs_invoice_detail}
    : FOR    ${item_product_id}    ${item_price}    ${item_num}    IN ZIP    ${list_id_sp}   ${list_giaban}    ${list_nums}
    \    ${payload_each_product}    Format string    {{"BasePrice":{0},"IsLotSerialControl":true,"Note":"","Price":{0},"ProductId":{1},"Quantity":{2},"SellPrice":{0},"ProductName":"chuột quang hồng","Discount":0,"DiscountRatio":null,"CopiedPrice":134216.23,"ProductBatchExpireId":null}}    ${item_price}    ${item_product_id}
    \    ...    ${item_num}
    \    ${liststring_prs_invoice_detail}    Catenate    SEPARATOR=,    ${liststring_prs_invoice_detail}    ${payload_each_product}
    Log    ${liststring_prs_invoice_detail}
    ${liststring_prs_invoice_detail}    Replace String    ${liststring_prs_invoice_detail}    needdel,    ${EMPTY}    count=1
    ${request_payload}    Format String    {{"Invoice":{{"BranchId":{0},"RetailerId":{1},"UpdateInvoiceId":0,"UpdateReturnId":0,"IsChangeNormalToShippingDelivery":false,"CustomerId":{2},"SoldById":{3},"SoldBy":{{"CreatedBy":0,"CreatedDate":"2020-09-07T04:58:15.743Z","Email":"tthao@gmail.com","GivenName":"thao11","Id":{3},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false}},"SaleChannelId":0,"Seller":{{"CreatedBy":0,"CreatedDate":"2020-09-07T04:58:15.743Z","Email":"tthao@gmail.com","GivenName":"thao11","Id":{3},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false}},"OrderCode":"","Code":"Hóa đơn 1","InvoiceDetails":[{4}],"InvoiceOrderSurcharges":[],"InvoicePromotions":[],"DeliveryDetail":{{"Type":0,"TypeName":"","Status":1,"Receiver":"{7}","DeliveryBy":{8},"LocationName":"","WardName":"","CustomerId":{2},"CustomerCode":"{9}","BranchTakingAddressId":null,"BranchTakingAddressStr":"Thành phố Châu Đốc, An Giang","UsingPriceCod":1,"LastLocation":"","LastWard":"","Width":1,"Height":1,"Length":1,"Weight":500,"UsingOfBilling":false,"Paymenter":0,"PackageType":0,"UseDefaultPartner":false,"ServiceCode":"0","TotalProductPrice":200000,"PartnerCode":"{10}","PartnerName":"","PartnerDelivery":{{"Type":0,"Code":"{10}","CreatedDate":"2020-09-28T04:32:11.200Z","Id":{8},"LocationName":"","Name":"a","PartnerDeliveryGroupDetails":[],"RetailerId":{1},"SearchNumber":"","WardName":"","isActive":true,"isDeleted":false}},"ServiceAdd":null,"Price":null,"DeliveryCode":"{11}","DeliveryStatus":null,"ExpectedDelivery":null,"WeightEdited":true,"ExpectedDeliveryText":""}},"UsingCod":1,"Payments":[{{"Method":"Cash","MethodStr":"Tiền mặt","Amount":{5},"Id":-1}}],"Status":3,"Total":200000,"Surcharge":0,"Type":1,"Uuid":"{6}","addToAccount":"0","addToAccountSurplus":"0","addToAccountAllocation":"0","addToAccountPaymentAllocation":"0","PayingAmount":{5},"TotalBeforeDiscount":200000,"ProductDiscount":0,"DebugUuid":"","InvoiceWarranties":[],"CreatedBy":{3}}}}}
    ...    ${BRANCH_ID}    ${get_id_nguoitao}    ${get_id_kh}    ${get_id_nguoiban}    ${liststring_prs_invoice_detail}    ${actual_khtt}    ${Uuid_code}    ${get_ten_kh}
    ...    ${get_id_dt}    ${input_ma_kh}    ${input_dtgh}    ${ma_van_don}
    Log    ${request_payload}
    ${resp.json()}    Post request to create shipping and get resp    ${request_payload}
    ${string}    Convert To String    ${resp.json()}
    ${dict}    Set Variable    ${resp.json()}
    ${shipping_code}    Get From Dictionary    ${dict}    Code
    Return From Keyword    ${shipping_code}
