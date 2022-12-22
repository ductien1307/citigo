*** Settings ***
Library           Collections
Library           RequestsLibrary
Library           SeleniumLibrary
Library           OperatingSystem
Library           String
Library           JSONLibrary
Library           StringFormat
Resource          ../../../core/API/api_access.robot
Resource          ../../../core/API/api_nha_cung_cap.robot
Resource          ../../../core/API/api_doi_tac_giaohang.robot
Resource          ../../../core/share/computation.robot

*** Keywords ***
Create new invoice w customer
    [Arguments]    ${ma_hh}    ${quantity}    ${customer}
    ${endpoint_danhmuc_hh_co_dvt}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${jsonpath_product_id}    Format String    $..Data[?(@.Code=="{0}")].ProductId    ${ma_hh}
    ${cus_id}    Get Customer ID    ${customer}
    ${userid}    Get User ID
    ${retailerid}    Get Retailer ID
    ${get_product_id}    Get data from API    ${endpoint_danhmuc_hh_co_dvt}    ${jsonpath_product_id}
    ${data_str}    Format String    {{"Invoice":{{"BranchId":{0},"RetailerId":364689,"CustomerId":{4},"SoldById":192226,"SoldBy":{{"CreatedBy":0,"CreatedDate":"2018-12-06T09:34:17.777Z","Email":"","GivenName":"mini","Id":192226,"IsActive":true,"IsAdmin":true,"Type":0,"UserName":"admin","isDeleted":false}},"SaleChannelId":0,"Seller":{{"CreatedBy":0,"CreatedDate":"2018-12-06T09:34:17.777Z","Email":"","GivenName":"mini","Id":192226,"IsActive":true,"IsAdmin":true,"Type":0,"UserName":"admin","isDeleted":false}},"OrderCode":"","Code":"Hóa đơn 1","InvoiceDetails":[{{"BasePrice":70000,"IsLotSerialControl":false,"IsRewardPoint":false,"Note":"","Price":70000,"ProductId":{1},"Quantity":{2},"ProductCode":"{3}","ProductName":"Bánh xu kem Nhật","SalePromotionId":null,"PriceByPromotion":null,"PromotionParentProductId":null,"ProductBatchExpireId":null,"CategoryId":777011,"MasterProductId":15577744,"Unit":""}}],"InvoiceOrderSurcharges":[],"InvoicePromotions":[],"Payments":[],"Status":1,"Total":350000,"Surcharge":0,"Type":1,"Uuid":"W154418059943445","addToAccount":"0","PayingAmount":0,"TotalBeforeDiscount":350000,"ProductDiscount":0,"DebugUuid":"154418059932477"}}}}    ${BRANCH_ID}    ${get_product_id}    ${quantity}    ${ma_hh}
    ...    ${cus_id}
    log    ${data_str}
    ${headers1}=    Create Dictionary    Authorization=${bearertoken}    Content-Type=application/json;charset=utf-8        Retailer=${RETAILER_NAME}     Branchid=${BRANCH_ID}
    Create Session    lolo    https://sale.kiotapi.com/api    #cookies=${resp.cookies}
    ${resp3}=    Post Request    lolo    /invoices    data=${data_str}    headers=${headers1}
    Log    ${resp3.request.body}
    Log    ${resp3.json()}
    Should Be Equal As Strings    ${resp3.status_code}    200

Import serial numbers
    [Arguments]    ${product_id}    ${product_code}    ${serialnums_string}    ${sum_soluong}    ${userid}
    ${data_str}    Format String    {{"PurchaseOrder":{{"PurchaseOrderDetails":[{{"ProductId":{0},"ConversionValue":1,"Product":{{"Name":"","Code":"{1}","IsLotSerialControl":true,"IsBatchExpireControl":false,"ProductShelvesStr":"","OnHand":20,"Reserved":0}},"ProductName":"","ProductCode":"{1}","Description":"","Price":0,"priceAfterDiscount":0,"Quantity":{3},"ShowUnit":false,"ListProductUnit":[{{"Id":{0},"Unit":"","Code":"{1}"}}],"Units":[{{"Id":{0},"Unit":"","Code":"{1}"}}],"Unit":"","SelectedUnit":{0},"OnOrder":0,"ProductBatchExpires":[],"tabIndex":100,"ViewIndex":1,"TotalValue":null,"Discount":null,"Allocation":"","AllocationSuppliers":"","AllocationThirdParty":"","SerialNumbers":"{2}","allSuggestSerial":[]}}],"UserId":{4},"CompareUserId":{4},"User":{{"id":{4},"username":"admin","givenName":"admin","Id":{4},"UserName":"admin","GivenName":"admin","IsAdmin":true,"IsLimitedByTrans":false,"IsShowSumRow":true,"Theme":""}},"Description":"","CompareSupplierId":0,"SubTotal":0,"Branch":{{"id":{5},"name":"","Id":{5},"Name":"","Address":"","LocationName":"","WardName":"","ContactNumber":""}},"Status":1,"StatusValue":"Phiếu tạm","CompareStatusValue":"Phiếu tạm","Discount":0,"CompareDiscount":0,"DiscountRatio":0,"Id":0,"Account":{{}},"Total":0,"TotalQuantity":1,"ExpensesOthersTitle":"","ExpensesOthersRtpTitle":"","PurchaseOrderExpensesOthers":[],"PurchaseOrderExpensesOthersRs":[],"PurchaseOrderExpensesOthersRtp":[],"ExReturnSuppliers":0,"ExReturnThirdParty":0,"PaidAmount":0,"PayingAmount":0,"ChangeAmount":0,"paymentMethod":"","BalanceDue":0,"DepositReturn":0,"OriginTotal":0,"PricebookDetail":[],"paymentMethodObj":null,"paymentReturnType":0,"BranchId":{5}}},"Complete":true,"CopyFrom":0,"PricebookDetail":[],"IsImportOrderSupplier":false,"IsFinalizedOS":false}}    ${product_id}    ${product_code}    ${serialnums_string}    ${sum_soluong}
    ...    ${userid}    ${BRANCH_ID}
    log    ${data_str}
    Post request thr API    /purchaseOrders    ${data_str}

import Lot for prd
    [Arguments]    ${product_id}    ${sum_soluong}    ${tenlo}    ${hansudung}    ${gianhap}    ${userid}
    ${data_str}    Format String    {{"PurchaseOrder":{{"PurchaseOrderDetails":[{{"ProductId":{0},"ConversionValue":1,"Product":{{"Name":"","Code":"","IsLotSerialControl":false,"IsBatchExpireControl":true,"ProductShelvesStr":"","OnHand":0,"Reserved":0}},"ProductName":"","ProductCode":"","Description":"","Price":{1},"priceAfterDiscount":0,"Quantity":{2},"ShowUnit":false,"ListProductUnit":[{{"Id":{0},"Unit":"","Code":""}}],"Units":[{{"Id":{0},"Unit":"","Code":""}}],"Unit":"","SelectedUnit":{0},"OnOrder":0,"ProductBatchExpires":[],"tabIndex":100,"ViewIndex":1,"TotalValue":0,"Discount":0,"Allocation":0,"AllocationSuppliers":0,"AllocationThirdParty":0,"BatchExpireNumber":[{{"FullNameVirgule":""}}],"ProductBatchExpiresAdd":{{"Id":-1,"BatchName":"{3}","FullNameVirgule":"","ExpireDate":"{4}","DisplayType":0,"BranchId":-1,"Status":0,"IsUpdate":false}},"DiscountValue":0,"DiscountType":"VND","DiscountRatio":null,"adjustedPrice":0,"OrderByNumber":0}}],"UserId":{5},"CompareUserId":{5},"User":{{"id":{5},"username":"admin","givenName":"admin","Id":2300,"UserName":"admin","GivenName":"admin","IsAdmin":true,"IsLimitedByTrans":false,"IsShowSumRow":true,"Theme":""}},"Description":"","CompareSupplierId":0,"SubTotal":0,"Branch":{{"id":{6},"name":"","Id":{6},"Name":"","Address":"","LocationName":"","WardName":"","ContactNumber":""}},"Status":1,"StatusValue":"Phiếu tạm","CompareStatusValue":"Phiếu tạm","Discount":0,"CompareDiscount":0,"DiscountRatio":0,"Id":0,"Account":{{}},"Total":0,"TotalQuantity":1,"ExpensesOthersTitle":"","ExpensesOthersRtpTitle":"","PurchaseOrderExpensesOthers":[],"PurchaseOrderExpensesOthersRs":[],"PurchaseOrderExpensesOthersRtp":[],"ExReturnSuppliers":0,"ExReturnThirdParty":0,"PaidAmount":0,"PayingAmount":0,"ChangeAmount":0,"paymentMethod":"","BalanceDue":0,"DepositReturn":0,"OriginTotal":0,"PricebookDetail":[],"paymentMethodObj":null,"paymentReturnType":0,"BranchId":{6}}},"Complete":true,"CopyFrom":0,"PricebookDetail":[],"IsImportOrderSupplier":false,"IsFinalizedOS":false}}    ${product_id}    ${gianhap}    ${sum_soluong}    ${tenlo}
    ...    ${hansudung}    ${userid}    ${BRANCH_ID}
    Log    ${data_str}
    Post request thr API    /purchaseOrders    ${data_str}

Add new sale channel thr API
    [Arguments]    ${ten_kenh}
    ${data_str}    Format String    {{"SaleChannel":{{"IsActive":true,"Name":"{0}","Img":"fas fa-shopping-cart","Description":""}}}}    ${ten_kenh}
    Log    ${data_str}
    Post request thr API    /salechannel   ${data_str}
