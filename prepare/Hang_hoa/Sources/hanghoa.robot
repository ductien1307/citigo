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
Resource          ../../../core/API/api_thietlapgia.robot
Resource          ../../../core/API/api_danhmuc_thuoc.robot
Resource          giaodich.robot

*** Variables ***
${quantity}    1

*** Keywords ***
Import product
    [Arguments]    ${ma_pn}    ${sp_id}    ${gia_nhap}    ${so_luong}    ${ui_ncc_code}
    ${jsonpath_ncc_id}    Format String    $..Data[?(@.Code=="{0}")].Id    ${ui_ncc_code}
    ${get_ncc_id}    Get data from API    ${endpoint_ncc}    Id
    ${data_str}    Format String    {{"PurchaseOrder":{{"Code":"{0}","PurchaseOrderDetails":[{{"ProductId":{1},"Product":{{"Name":"","Code":"","IsLotSerialControl":false}},"ProductName":"trrrr","ProductCode":"SP000030","Description":"","Price":{2},"priceAfterDiscount":47500,"Quantity":{3},"Allocation":"0.0000","AllocationSuppliers":"0.0000","AllocationThirdParty":"0.0000","TotalValue":0,"ViewIndex":1,"RowNumber":1,"sortValue":0,"productGroupCount":1,"rowNumber":0,"Id":0,"DiscountValue":0,"DiscountType":"VND","DiscountRatio":0,"Discount":0,"adjustedPrice":50000,"OriginPrice":50000}}],"UserId":156178,"CompareUserId":156178,"User":{{"id":156178,"username":"Admin","givenName":"Admin","Id":156178,"UserName":"Admin","GivenName":"Admin","IsAdmin":true,"IsLimitedByTrans":false,"IsShowSumRow":true,"Theme":""}},"Description":"","Supplier":{{"TotalInvoiced":0,"CompareCode":"NCC0003","CompareName":"CôngtyPharmedic","Id":185509,"Name":"CôngtyPharmedic","RetailerId":286770,"Code":"NCC0003","CreatedDate":"2018-06-05T16:49:43.9800000","CreatedBy":156178,"isDeleted":false,"isActive":true,"PurchaseOrders":[],"PurchaseReturns":[],"PurchasePayments":[],"SupplierGroupDetails":[]}},"SupplierId":{4},"CompareSupplierId":0,"SubTotal":190000,"Branch":{{"id":62644,"name":"ChinhánhHàNội","Id":55762,"Name":"ChinhánhHàNội","Address":"","LocationName":"","WardName":"","ContactNumber":""}},"Status":1,"StatusValue":"Phiếutạm","CompareStatusValue":"Phiếutạm","Discount":0,"CompareDiscount":0,"DiscountRatio":0,"Id":0,"Account":{{}},"Total":190000,"TotalQuantity":4,"ExpensesOthersTitle":"","ExpensesOthersRtpTitle":"","PurchaseOrderExpensesOthers":[],"PurchaseOrderExpensesOthersRs":[],"PurchaseOrderExpensesOthersRtp":[],"ExReturnSuppliers":0,"ExReturnThirdParty":0,"PaidAmount":0,"PayingAmount":0,"ChangeAmount":-190000,"paymentMethod":"","BalanceDue":190000,"OriginTotal":190000,"paymentMethodObj":null,"BranchId":{5}}},"Complete":true,"CopyFrom":0}}    ${ma_pn}    ${sp_id}    ${gia_nhap}    ${so_luong}
    ...    ${get_ncc_id}    ${BRANCH_ID}
    log    ${data_str}
    Post request thr API       /purchaseOrders    ${data_str}

Add imei product thr API
    [Arguments]    ${ui_product_code}    ${ten_sp}    ${ten_nhom}    ${gia_ban}
    ${cat_id}    Hanghoa.Get category ID    ${ten_nhom}
    log    ${cat_id}
    ${format_data}    Format String    "Id":0,"ProductType":2,"CategoryId":{0},"CategoryName":"","isActive":false,"VariantCount":0,"AllowsSale":true,"isDeleted":false,"Code":"{1}","BasePrice":{2},"Cost":0,"LatestPurchasePrice":0,"OnHand":0,"OnHandCompareMin":0,"OnHandCompareMax":0,"CompareOnHand":0,"CompareCost":0,"CompareBasePrice":0,"CompareCode":"","CompareUnit":"","Reserved":0,"MinQuantity":0,"MaxQuantity":999999999,"CustomId":0,"CustomValue":0,"MasterProductId":0,"Unit":"","ConversionValue":1,"OrderTemplate":"","IsLotSerialControl":true,"IsRewardPoint":false,"ProductFormulas":[],"Name":"{3}","ListPriceBookDetail":[],"ProductImages":[]    ${cat_id}    ${ui_product_code}    ${gia_ban}    ${ten_sp}
    log    ${format_data}
    ${data}    Evaluate    (None, '[{${format_data}}]')
    ${branch_pr_cost}   Set Variable    "Id":${BRANCH_ID},"Name":"Chi nhánh trung tâm"
    ${branch_pr_cost}     Evaluate    (None, '[{${branch_pr_cost}}]')
    ${payload}    Create Dictionary    ListProducts=${data}     BranchForProductCosts=${branch_pr_cost}
    Log    ${payload}
    Post request data form thr API    /products/addmany    ${payload}
    ${endpoint_pr}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${jsonpath_product_id}    Format String    $..Data[?(@.Code=="{0}")].Id    ${ui_product_code}
    ${get_product_id}    Get data from API    ${endpoint_pr}    ${jsonpath_product_id}
    Return From Keyword    ${get_product_id}

Add service
    [Arguments]    ${ui_product_code}    ${ten_sp}    ${ten_nhom}    ${gia_ban}    ${gia_von}
    ${cat_id}    Hanghoa.Get category ID    ${ten_nhom}
    log    ${cat_id}
    ${format_data}    Format String    "Id":0,"ProductType":3,"CategoryId":{0},"CategoryName":"","isActive":false,"VariantCount":0,"AllowsSale":true,"isDeleted":false,"Code":"{1}","BasePrice":{2},"Cost":{3},"LatestPurchasePrice":0,"OnHand":0,"OnHandCompareMin":0,"OnHandCompareMax":0,"CompareOnHand":0,"CompareCost":0,"CompareBasePrice":0,"CompareCode":"","CompareUnit":"","Reserved":0,"MinQuantity":0,"MaxQuantity":999999999,"CustomId":0,"CustomValue":0,"MasterProductId":0,"Unit":"","ConversionValue":1,"OrderTemplate":"","IsLotSerialControl":false,"IsRewardPoint":false,"ProductFormulas":[],"Name":"{4}","ListPriceBookDetail":[],"ProductImages":[]    ${cat_id}    ${ui_product_code}    ${gia_ban}    ${gia_von}
    ...    ${ten_sp}
    log    ${format_data}
    ${data}    Evaluate    (None, '[{${format_data}}]')
    ${branch_pr_cost}   Set Variable    "Id":${BRANCH_ID},"Name":"Chi nhánh trung tâm"
    ${branch_pr_cost}     Evaluate    (None, '[{${branch_pr_cost}}]')
    ${payload}    Create Dictionary    ListProducts=${data}     BranchForProductCosts=${branch_pr_cost}
    Log    ${payload}
    Post request data form thr API    /products/addmany    ${payload}
    ${jsonpath_product_id}    Format String    $..Data[?(@.Code=="{0}")].ProductId    ${ui_product_code}
    ${endpoint_danhmuc_hh_co_dvt}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${get_product_id}    Get data from API    ${endpoint_danhmuc_hh_co_dvt}    ${jsonpath_product_id}
    Return From Keyword    ${get_product_id}

Add combo products
    [Arguments]    ${ui_combo_code}    ${ten_sp}    ${nhom_id}    ${giaban}    ${id_pr1}    ${soluong1}
    ...    ${id_pr2}    ${soluong2}
    ${format_data}    Format String    "Id":0,"ProductType":1,"CategoryId":{2},"CategoryName":"","isActive":false,"VariantCount":0,"AllowsSale":true,"isDeleted":false,"Code":"{0}","BasePrice":{3},"Cost":0,"LatestPurchasePrice":0,"OnHand":0,"OnHandCompareMin":0,"OnHandCompareMax":0,"CompareOnHand":0,"CompareCost":0,"CompareBasePrice":0,"CompareCode":"","CompareUnit":"","Reserved":0,"MinQuantity":0,"MaxQuantity":999999999,"CustomId":0,"CustomValue":0,"MasterProductId":0,"Unit":"","ConversionValue":1,"OrderTemplate":"","IsLotSerialControl":false,"IsRewardPoint":false,"ProductFormulas":[{{"MaterialId":{4},"MaterialName":"Hạt macca","MaterialCode":"TPC001","Quantity":{5},"Cost":50000,"BasePrice":70000,"$$hashKey":"object:607"}},{{"MaterialId":{6},"MaterialName":"Hạt hướng dương","MaterialCode":"TPC002","Quantity":{7},"Cost":40000,"BasePrice":80000,"$$hashKey":"object:613"}}],"Name":"{1}","ListPriceBookDetail":[],"ProductImages":[]    ${ui_combo_code}    ${ten_sp}    ${nhom_id}    ${giaban}
    ...    ${id_pr1}    ${soluong1}    ${id_pr2}    ${soluong2}
    log    ${format_data}
    ${data}    Evaluate    (None, '[{${format_data}}]')
    ${branch_pr_cost}   Set Variable    "Id":${BRANCH_ID},"Name":"Chi nhánh trung tâm"
    ${branch_pr_cost}     Evaluate    (None, '[{${branch_pr_cost}}]')
    ${payload}    Create Dictionary    ListProducts=${data}     BranchForProductCosts=${branch_pr_cost}
    Log    ${payload}
    Post request data form thr API    /products/addmany    ${payload}

Deactive product
    [Arguments]    ${ui_product_code}
    ${endpoint_pr}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${jsonpath_product_id}    Format String    $..Data[?(@.Code=="{0}")].ProductId    ${ui_product_code}
    ${get_product_id}    Get data from API    ${endpoint_danhmuc_hh_co_dvt}    ${jsonpath_product_id}
    ${data_str}    Format String    {{"productId":{0},"CompareCode":"IP020","IsActive":true}}    ${get_product_id}
    log    ${data_str}
    ${endpoint_active_product}    Format String    /products/{0}/activeproduct    ${get_product_id}
    Post request data form thr API    ${endpoint_active_product}    ${data_str}

Add product thr API
    [Arguments]    ${ui_product_code}    ${ten_sp}    ${ten_nhom}    ${gia_ban}    ${giavon}    ${ton}
    ${cat_id}    Hanghoa.Get category ID    ${ten_nhom}
    log    ${cat_id}
    ${format_data}    Format String    "Id":0,"ProductType":2,"CategoryId":{0},"CategoryName":"","isActive":false,"VariantCount":0,"AllowsSale":true,"isDeleted":false,"Code":"{1}","BasePrice":{2},"Cost":{3},"LatestPurchasePrice":0,"OnHand":{4},"OnHandCompareMin":0,"OnHandCompareMax":0,"CompareOnHand":0,"CompareCost":0,"CompareBasePrice":0,"CompareCode":"","CompareUnit":"","Reserved":0,"MinQuantity":0,"MaxQuantity":999999999,"CustomId":0,"CustomValue":0,"MasterProductId":0,"Unit":"","ConversionValue":1,"OrderTemplate":"","IsLotSerialControl":false,"IsRewardPoint":false,"ProductFormulas":[],"Name":"{5}","ListPriceBookDetail":[],"ProductImages":[]    ${cat_id}    ${ui_product_code}    ${gia_ban}    ${giavon}
    ...    ${ton}    ${ten_sp}
    log    ${format_data}
    ${data}    Evaluate    (None, '[{${format_data}}]')
    ${branch_pr_cost}   Set Variable    "Id":${BRANCH_ID},"Name":"Chi nhánh trung tâm"
    ${branch_pr_cost}     Evaluate    (None, '[{${branch_pr_cost}}]')
    ${payload}    Create Dictionary    ListProducts=${data}     BranchForProductCosts=${branch_pr_cost}
    Log    ${payload}
    Post request data form thr API    /products/addmany    ${payload}

Add product to negative onhand
    [Arguments]    ${ma_hh}    ${quantity}
    ${endpoint_danhmuc_hh_co_dvt}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${jsonpath_product_id}    Format String    $..Data[?(@.Code=="{0}")].ProductId    ${ma_hh}
    ${userid}    Get User ID
    ${retailerid}    Get Retailer ID
    ${get_product_id}    Get data from API    ${endpoint_danhmuc_hh_co_dvt}    ${jsonpath_product_id}
    ${data_str}    Format String    {{"Invoice":{{"BranchId":{0},"RetailerId":{5},"SoldById":{4},"SoldBy":{{"CreatedBy":0,"CreatedDate":"2018-06-19T10:13:44.947Z","Email":"","GivenName":"ha","Id":172395,"IsActive":true,"IsAdmin":true,"Type":0,"UserName":"123456","isDeleted":false}},"SaleChannelId":0,"Seller":{{"CreatedBy":0,"CreatedDate":"2018-06-19T10:13:44.947Z","Email":"","GivenName":"ha","Id":172395,"IsActive":true,"IsAdmin":true,"Type":0,"UserName":"123456","isDeleted":false}},"OrderCode":"","Code":"Hóa đơn 1","InvoiceDetails":[{{"BasePrice":2500000,"IsLotSerialControl":false,"IsRewardPoint":false,"Note":"","Price":2500000,"ProductId":{1},"Quantity":{2},"ProductCode":"{3}","ProductName":"Jomalone red roses"}}],"InvoiceOrderSurcharges":[],"InvoicePromotions":[],"Payments":[{{"Method":"Cash","MethodStr":"Tiền mặt","Amount":2500000,"Id":-1}}],"Status":1,"Total":2500000,"Surcharge":0,"Type":1,"Uuid":"W153171314616413","addToAccount":"0","PayingAmount":2500000,"TotalBeforeDiscount":2500000,"ProductDiscount":0}}}}    ${BRANCH_ID}    ${get_product_id}    ${quantity}    ${ma_hh}
    ...    ${userid}    ${retailerid}
    log    ${data_str}
    Post request thr API    /invoices    ${data_str}

Create normal invoice
    [Arguments]    ${ma_hh}    ${quantity}
    ${endpoint_danhmuc_hh_co_dvt}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${jsonpath_product_id}    Format String    $..Data[?(@.Code=="{0}")].ProductId    ${ma_hh}
    ${ran}    Generate Random String    18    [NUMBERS]
    ${userid}    Get User ID
    ${retailerid}    Get Retailer ID
    ${get_product_id}    Get data from API    ${endpoint_danhmuc_hh_co_dvt}    ${jsonpath_product_id}
    ${get_pr_id_1}    Get product ID    ${ma_hh}
    log    ${get_product_id}
    ${index}     Get Substring    ${ma_hh}    -2
    ${data_str}    Format String    {{"Invoice":{{"BranchId":{0},"RetailerId":{5},"SoldById":{4},"SoldBy":{{"CreatedBy":0,"CreatedDate":"2018-06-19T10:13:44.947Z","Email":"","GivenName":"ha","Id":172395,"IsActive":true,"IsAdmin":true,"Type":0,"UserName":"123456","isDeleted":false}},"SaleChannelId":0,"Seller":{{"CreatedBy":0,"CreatedDate":"2018-06-19T10:13:44.947Z","Email":"","GivenName":"admin","Id":125992,"IsActive":true,"IsAdmin":true, "Type":0,"UserName":"","isDeleted":false}},"OrderCode":"","Code":"Hóa đơn 1","InvoiceDetails":[{{"BasePrice":200000,"IsLotSerialControl":false,"IsRewardPoint":false,"Note":"","Price":200000,"ProductId":{1},"Quantity":{2},"ProductCode":"{3}","ProductName":"Test hóa đơn lần ${index}"}}],"InvoiceOrderSurcharges":[],"InvoicePromotions":[],"Payments":[{{"Method":"Cash","MethodStr":"Tiền mặt","Amount":200000,"Id":-1}}],"Status":1,"Total":200000,"Surcharge":0,"Type":1,"Uuid":"W${ran}","addToAccount":"0","PayingAmount":200000,"TotalBeforeDiscount":200000,"ProductDiscount":0}}}}    ${BRANCH_ID}    ${get_pr_id_1}    ${quantity}    ${ma_hh}
    ...    ${userid}    ${retailerid}    ${index}
    log    ${data_str}
    Post request thr API    /invoices    ${data_str}

Create multiple prducts invoice
    [Arguments]    ${ma_hh_1}    ${ma_hh_2}
    ${endpoint_danhmuc_hh_co_dvt}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${jsonpath_product_id_1}    Format String    $..Data[?(@.Code=="{0}")].ProductId    ${ma_hh_1}
    ${jsonpath_product_id_2}    Format String    $..Data[?(@.Code=="{0}")].ProductId    ${ma_hh_2}
    ${userid}    Get User ID
    ${retailerid}    Get Retailer ID
    ${get_pr_id_1}    Get product ID    ${ma_hh_1}
    ${get_pr_id_2}    Get product ID    ${ma_hh_2}
    ${ran}  Generate Random String    15    [NUMBERS]
    ${pr1}     Get Substring    ${ma_hh_1}    -2
    ${pr2}     Get Substring    ${ma_hh_2}    -2

    ${data_str}    Format String    {{"Invoice":{{"BranchId":{0},"RetailerId":{5},"SoldById":{4},"SoldBy":{{"CreatedBy":0,"CreatedDate":"2018-06-19T10:13:44.947Z","Email":"","GivenName":"ha","Id":172395,"IsActive":true,"IsAdmin":true,"Type":0,"UserName":"123456","isDeleted":false}},"SaleChannelId":0,"Seller":{{"CreatedBy":0,"CreatedDate":"2018-06-19T10:13:44.947Z","Email":"","GivenName":"admin","Id":125992,"IsActive":true,"IsAdmin":true, "Type":0,"UserName":"","isDeleted":false}},"OrderCode":"","Code":"Hóa đơn 1","InvoiceDetails":[{{"BasePrice":200000,"IsLotSerialControl":false,"IsRewardPoint":false,"Note":"","Price":200000,"ProductId":{1},"Quantity":{2},"ProductCode":"{3}","ProductName":"Test hóa đơn lần ${pr_1}"}},{{"BasePrice":200000,"IsLotSerialControl":false,"IsRewardPoint":false,"Note":"","Price":200000,"ProductId":${get_pr_id_2},"Quantity":{2},"ProductCode":"${ma_hh_2}","ProductName":"Test hóa đơn lần ${pr2}"}}],"InvoiceOrderSurcharges":[],"InvoicePromotions":[],"Payments":[{{"Method":"Cash","MethodStr":"Tiền mặt","Amount":400000,"Id":-1}}],"Status":1,"Total":400000,"Surcharge":0,"Type":1,"Uuid":"W${ran}","addToAccount":"0","PayingAmount":400000,"TotalBeforeDiscount":400000,"ProductDiscount":0}}}}    ${BRANCH_ID}    ${get_pr_id_1}    ${quantity}    ${ma_hh_1}
    ...    ${userid}    ${retailerid}

    Post request thr API    /invoices    ${data_str}

Create delivery invoice
    [Arguments]    ${ma_hh}    ${quantity}
    ${endpoint_danhmuc_hh_co_dvt}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${jsonpath_product_id}    Format String    $..Data[?(@.Code=="{0}")].ProductId    ${ma_hh}
    ${ran}    Generate Random String    18    [NUMBERS]
    ${userid}    Get User ID
    ${retailerid}    Get Retailer ID
    ${get_product_id}    Get data from API    ${endpoint_danhmuc_hh_co_dvt}    ${jsonpath_product_id}
    ${get_pr_id_1}    Get product ID    ${ma_hh}
    log    ${get_product_id}
    ${index}     Get Substring    ${ma_hh}    -2

    ${data_str}    Format String    {{"Invoice":{{"BranchId":{0},"RetailerId":{5},"UpdateInvoiceId":0,"UpdateReturnId":0,"SoldById":{4},"SoldBy":{{"CreatedBy":0,"CreatedDate":"2021-09-10T08:42:24.810Z","GivenName":"admin","Id":125992,"IsActive":true,"IsAdmin":true,"MobilePhone":"0946852806","Type":0,"UserName":"admin","isDeleted":false}},"SaleChannelId":0,"Seller":{{"CreatedBy":0,"CreatedDate":"2021-09-10T08:42:24.810Z","GivenName":"admin","Id":125992,"IsActive":true,"IsAdmin":true,"MobilePhone":"0946852806","Type":0,"UserName":"admin","isDeleted":false}},"OrderCode":"","Code":"Hóa đơn 1","InvoiceDetails":[{{"BasePrice":200000,"IsLotSerialControl":false, "IsRewardPoint":false,"Note":"","Price":200000,"ProductId":${get_pr_id_1},"Quantity":1,"ProductCode":"${ma_hh}","Weight":33,"ProductName":"Test hóa đơn lần ${index}","OriginPrice":200000,"ProductBatchExpireId":null,"Unit":"","Uuid":"W${ran}w","ProductWarranty":[],"Formulas":null}}],"InvoiceOrderSurcharges":[],"InvoicePromotions":[],"InvoiceSupplierPromotions":[],"DeliveryDetail":{{"Type":0,"TypeName":"","Status":1,"Address":"","ContactNumber":"","Receiver":"","DeliveryBy":null,"LocationId":null,"LocationName":null,"WardName":null,"CustomerId":null,"CustomerCode":null,"BranchTakingAddressId":null,"BranchTakingAddressStr":"Hà Nội, Phường Thanh Xuân Bắc, Quận Thanh Xuân, Hà Nội - 0946852806","WardId":null,"Weight":33,"Height":1,"Width":1,"Length":1,"UsingPriceCod":1,"LastLocation":"","LastWard":""}},"UsingCod":1,"Payments":[],"Status":3,"Total":200000,"Surcharge":0,"Type":1,"Uuid":"W${ran}","addToAccount":"0","PayingAmount":0,"TotalBeforeDiscount":200000,"ProductDiscount":0,"DebugUuid":"W${ran}","InvoiceWarranties":[],"CreatedBy":125992}}}}     ${BRANCH_ID}    ${get_pr_id_1}    ${quantity}    ${ma_hh}
    ...    ${userid}    ${retailerid}    ${index}
    log    ${data_str}
    Post request thr API    /invoices    ${data_str}

Deactive a product
    [Arguments]    ${name}
    ${product_id}    Get product ID    ${name}
    ${endpoint}    Format String    products/{0}/activeproduct?kvuniqueparam=2020     ${product_id}
    ${data_str}    Set Variable    {"productId":${product_id},"CompareCode":"${name}","IsActive":true,"Branches":[]}
    Log     ${data_str}
    Post request thr API    ${endpoint}    ${data_str}

Delete a Product
    [Arguments]    ${name}
    ${product_id}    Get product ID    ${name}
    ${endpoint}    Set Variable    products/${product_id}?kvuniqueparam=2020
    log    ${endpoint}
    Delete request thr API    ${endpoint}

Add product incl 2 units thrAPI
    [Arguments]    ${mahh}    ${ten_hh}    ${ten_nhom}    ${giaban}    ${giavon}    ${ton}
    ...    ${dvcb}    ${tendv1}    ${gtqd1}    ${giaban1}    ${ma_hh1}    ${tendv2}
    ...    ${gtqd2}    ${giaban2}    ${ma_hh2}
    ${cat_id}    Hanghoa.Get category ID    ${ten_nhom}
    log    ${cat_id}
    ${ton_qd1}    Divide OnHand    ${ton}    ${gtqd1}
    ${ton_qd2}    Divide OnHand    ${ton}    ${gtqd2}
    ${giavon_qd1}    Multiplication with price round 2    ${giavon}    ${gtqd1}
    ${giavon_qd2}    Multiplication with price round 2    ${giavon}    ${gtqd2}
    ${format_data}    Format String    "Id":0,"ProductType":2,"CategoryId":{2},"CategoryName":"","isActive":false,"VariantCount":0,"AllowsSale":true,"isDeleted":false,"Code":"{0}","BasePrice":{3},"Cost":{4},"LatestPurchasePrice":0,"OnHand":{5},"OnOrder":0,"OnHandCompareMin":0,"OnHandCompareMax":0,"CompareOnHand":0,"CompareCost":0,"CompareBasePrice":0,"CompareCode":"","CompareUnit":"","Reserved":0,"MinQuantity":0,"MaxQuantity":999999999,"CustomId":0,"CustomValue":0,"MasterProductId":0,"Unit":"{6}","ConversionValue":1,"OrderTemplate":"","IsLotSerialControl":false,"IsRewardPoint":false,"ProductFormulas":[],"Name":"{1}","ListPriceBookDetail":[],"FullName":"","MasterCode":"","ListUnitPriceBookDetail":null,"ProductFormulasOld":[],"ProductImages":[]}},{{"Id":0,"ProductType":2,"CategoryId":{2},"CategoryName":"","isActive":false,"VariantCount":0,"AllowsSale":true,"isDeleted":false,"Code":"{10}","BasePrice":{9},"Cost":{17},"LatestPurchasePrice":0,"OnHand":{15},"OnOrder":0,"OnHandCompareMin":0,"OnHandCompareMax":0,"CompareOnHand":0,"CompareCost":0,"CompareBasePrice":0,"CompareCode":"","CompareUnit":"","Reserved":0,"MinQuantity":0,"MaxQuantity":999999999,"CustomId":0,"CustomValue":0,"MasterProductId":0,"Unit":"{7}","ConversionValue":{8},"OrderTemplate":"","IsLotSerialControl":false,"IsRewardPoint":false,"ProductFormulas":[],"Name":"{1}","ListPriceBookDetail":[],"ProductUnits":[{{"Id":0,"Unit":"{7}","Code":"{10}","ConversionValue":4,"BasePrice":0,"Cost":0,"OnHand":0}},{{"Id":0,"Unit":"{11}","Code":"","ConversionValue":1,"BasePrice":0}}],"FullName":"","MasterCode":"","ListUnitPriceBookDetail":[],"ProductFormulasOld":[],"ProductImages":[]}},{{"Id":0,"ProductType":2,"CategoryId":{2},"CategoryName":"","isActive":false,"VariantCount":0,"AllowsSale":true,"isDeleted":false,"Code":"{14}","BasePrice":{13},"Cost":{18},"LatestPurchasePrice":0,"OnHand":{16},"OnOrder":0,"OnHandCompareMin":0,"OnHandCompareMax":0,"CompareOnHand":0,"CompareCost":0,"CompareBasePrice":0,"CompareCode":"","CompareUnit":"","Reserved":0,"MinQuantity":0,"MaxQuantity":999999999,"CustomId":0,"CustomValue":0,"MasterProductId":0,"Unit":"{11}","ConversionValue":{12},"OrderTemplate":"","IsLotSerialControl":false,"IsRewardPoint":false,"ProductFormulas":[],"Name":"{1}","ListPriceBookDetail":[],"ProductUnits":[{{"Id":0,"Unit":"{7}","Code":"{10}","ConversionValue":4,"BasePrice":0,"Cost":0,"OnHand":0}},{{"Id":0,"Unit":"{11}","Code":"","ConversionValue":1,"BasePrice":0}}],"FullName":"","MasterCode":"","ListUnitPriceBookDetail":[],"ProductFormulasOld":[],"ProductImages":[]    ${mahh}    ${ten_hh}    ${cat_id}    ${giaban}
    ...    ${giavon}    ${ton}    ${dvcb}    ${tendv1}    ${gtqd1}    ${giaban1}
    ...    ${ma_hh1}    ${tendv2}    ${gtqd2}    ${giaban2}    ${ma_hh2}    ${ton_qd1}
    ...    ${ton_qd2}    ${giavon_qd1}    ${giavon_qd2}
    log    ${format_data}    #    0    1    2    3
    ...    # 4    5    6    7    8    9
    ...    # 10    11    12    13    14    15
    ...    # 16
    ${data}    Evaluate    (None, '[{${format_data}}]')
    ${branch_pr_cost}   Set Variable    "Id":${BRANCH_ID},"Name":"Chi nhánh trung tâm"
    ${branch_pr_cost}     Evaluate    (None, '[{${branch_pr_cost}}]')
    ${payload}    Create Dictionary    ListProducts=${data}     BranchForProductCosts=${branch_pr_cost}
    Log    ${payload}
    Post request data form thr API    /products/addmany    ${payload}

Add product incl 1 unit thrAPI
    [Arguments]    ${mahh}    ${ten_hh}    ${ten_nhom}    ${giaban}    ${giavon}    ${ton}
    ...    ${dvcb}    ${tendv1}    ${gtqd1}    ${giaban1}    ${ma_hh1}
    ${cat_id}    Hanghoa.Get category ID    ${ten_nhom}
    log    ${cat_id}
    ${ton_qd}    Divide OnHand    ${ton}    ${gtqd1}
    ${format_data}    Format String    "Id":0,"ProductType":2,"CategoryId":{2},"CategoryName":"","isActive":false,"VariantCount":0,"AllowsSale":true,"isDeleted":false,"Code":"{0}","BasePrice":{3},"Cost":{4},"LatestPurchasePrice":0,"OnHand":{5},"OnOrder":0,"OnHandCompareMin":0,"OnHandCompareMax":0,"CompareOnHand":0,"CompareCost":0,"CompareBasePrice":0,"CompareCode":"","CompareUnit":"","Reserved":0,"MinQuantity":0,"MaxQuantity":999999999,"CustomId":0,"CustomValue":0,"MasterProductId":0,"Unit":"{6}","ConversionValue":1,"OrderTemplate":"","IsLotSerialControl":false,"IsRewardPoint":false,"ProductFormulas":[],"Name":"{1}","ListPriceBookDetail":[],"FullName":"","MasterCode":"","ListUnitPriceBookDetail":null,"ProductFormulasOld":[],"ProductImages":[]}},{{"Id":0,"ProductType":2,"CategoryId":{2},"CategoryName":"","isActive":false,"VariantCount":0,"AllowsSale":true,"isDeleted":false,"Code":"{10}","BasePrice":{9},"Cost":20000,"LatestPurchasePrice":0,"OnHand":{11},"OnOrder":0,"OnHandCompareMin":0,"OnHandCompareMax":0,"CompareOnHand":0,"CompareCost":0,"CompareBasePrice":0,"CompareCode":"","CompareUnit":"","Reserved":0,"MinQuantity":0,"MaxQuantity":999999999,"CustomId":0,"CustomValue":0,"MasterProductId":0,"Unit":"{7}","ConversionValue":{8},"OrderTemplate":"","IsLotSerialControl":false,"IsRewardPoint":false,"ProductFormulas":[],"Name":"{1}","ListPriceBookDetail":[],"ProductUnits":[{{"Id":0,"Unit":"{7}","Code":"","ConversionValue":1,"BasePrice":0}}],"FullName":"","MasterCode":"","ListUnitPriceBookDetail":[],"ProductFormulasOld":[],"ProductImages":[]    ${mahh}    ${ten_hh}    ${cat_id}    ${giaban}
    ...    ${giavon}    ${ton}    ${dvcb}    ${tendv1}    ${gtqd1}    ${giaban1}
    ...    ${ma_hh1}    ${ton_qd}
    log    ${format_data}    #    0    1    2    3
    ...    # 4    5    6    7    8    9
    ...    # 10
    ${data}    Evaluate    (None, '[{${format_data}}]')
    ${branch_pr_cost}   Set Variable    "Id":${BRANCH_ID},"Name":"Chi nhánh trung tâm"
    ${branch_pr_cost}     Evaluate    (None, '[{${branch_pr_cost}}]')
    ${payload}    Create Dictionary    ListProducts=${data}     BranchForProductCosts=${branch_pr_cost}
    Log    ${payload}
    Post request data form thr API    /products/addmany    ${payload}

Import serial numbers in dev env
    [Arguments]    ${sp_id}    ${gia_nhap}    ${serialnums}    ${sum_soluong}
    ${get_user_id}    Get User ID
    ${data_str}    Format String    {{"PurchaseOrder":{{"PurchaseOrderDetails":[{{"ProductId":{0},"ConversionValue":1,"Product":{{"Name":"chuột quang hồng","Code":"NS01","IsLotSerialControl":true,"IsBatchExpireControl":false,"ProductShelvesStr":"","OnHand":0,"Reserved":0}},"ProductName":"chuột quang hồng","ProductCode":"NS01","Description":"","Price":{1},"priceAfterDiscount":200000,"Quantity":{3},"ShowUnit":false,"ListProductUnit":[{{"Id":{0},"Unit":"","Code":"NS01","Conversion":0,"MasterUnitId":0}}],"Units":[{{"Id":{0},"Unit":"","Code":"NS01","Conversion":0,"MasterUnitId":0}}],"Unit":"","SelectedUnit":{0},"OnOrder":0,"ProductBatchExpires":[],"tabIndex":100,"ViewIndex":1,"TotalValue":200000,"Discount":0,"tags":[{{"text":"aaa"}}],"SerialNumbers":"{2}","DiscountValue":0,"DiscountType":"VND","DiscountRatio":null,"adjustedPrice":200000,"Allocation":0,"AllocationSuppliers":0,"AllocationThirdParty":0,"OrderByNumber":0}}],"UserId":{5},"CompareUserId":{5},"User":{{"id":{5},"username":"admin","givenName":"admin","Id":441968,"UserName":"admin","GivenName":"admin","IsAdmin":true,"IsLimitedByTrans":false,"IsShowSumRow":true,"Theme":""}},"Description":"","CompareSupplierId":0,"SubTotal":200000,"Branch":{{"id":{4},"name":"Chi nhánh trung tâm","Id":{4},"Name":"Chi nhánh trung tâm","Address":"","LocationName":"Đà Nẵng - Quận Cẩm Lệ","WardName":"","ContactNumber":"","SubContactNumber":""}},"Status":1,"StatusValue":"Phiếu tạm","CompareStatusValue":"Phiếu tạm","Discount":0,"CompareDiscount":0,"DiscountRatio":0,"Id":0,"Account":{{}},"Total":200000,"TotalQuantity":1,"ExpensesOthersTitle":"","ExpensesOthersRtpTitle":"","PurchaseOrderExpensesOthers":[],"PurchaseOrderExpensesOthersRs":[],"PurchaseOrderExpensesOthersRtp":[],"ExReturnSuppliers":0,"ExReturnThirdParty":0,"PaidAmount":0,"PayingAmount":0,"ChangeAmount":-200000,"paymentMethod":"","BalanceDue":200000,"DepositReturn":200000,"OriginTotal":200000,"PricebookDetail":[],"paymentMethodObj":null,"paymentReturnType":0,"BranchId":{4}}},"Complete":true,"CopyFrom":0,"PricebookDetail":[],"IsFinalizedOS":false}}    ${sp_id}    ${gia_nhap}    ${serialnums}    ${sum_soluong}
    ...    ${BRANCH_ID}    ${get_user_id}
    log    ${data_str}
    Post request thr API    /purchaseOrders    ${data_str}

Add HH co trong luong thr API
    [Arguments]    ${code}    ${ten_sp}    ${ten_nhom}    ${gia_ban}    ${giavon}    ${ton}
    ...    ${trongluong}
    ${cat_id}    Hanghoa.Get category ID    ${ten_nhom}
    log    ${cat_id}
    ${format_data}    Format String    "Id":0,"ProductType":2,"CategoryId":{0},"CategoryName":"","isActive":false,"VariantCount":0,"AllowsSale":true,"isDeleted":false,"Code":"{1}","BasePrice":{2},"Cost":{3},"LatestPurchasePrice":0,"OnHand":{4},"OnHandCompareMin":0,"OnHandCompareMax":0,"CompareOnHand":0,"CompareCost":0,"CompareBasePrice":0,"CompareCode":"","CompareUnit":"","Reserved":0,"MinQuantity":0,"MaxQuantity":999999999,"CustomId":0,"CustomValue":0,"MasterProductId":0,"Unit":"","ConversionValue":1,"OrderTemplate":"","IsLotSerialControl":false,"IsRewardPoint":false,"ProductFormulas":[],"Name":"{5}","Weight":"{6}","ListPriceBookDetail":[],"ProductImages":[]    ${cat_id}    ${code}    ${gia_ban}    ${giavon}
    ...    ${ton}    ${ten_sp}    ${trongluong}
    log    ${format_data}
    ${data}    Evaluate    (None, '[{${format_data}}]')
    ${branch_pr_cost}   Set Variable    "Id":${BRANCH_ID},"Name":"Chi nhánh trung tâm"
    ${branch_pr_cost}     Evaluate    (None, '[{${branch_pr_cost}}]')
    ${payload}    Create Dictionary    ListProducts=${data}     BranchForProductCosts=${branch_pr_cost}
    Log    ${payload}
    Post request data form thr API    /products/addmany    ${payload}
    Create Session    lolo    ${API_URL}    cookies=${resp.cookies}    verify=True    debug=1

Add categories thr API
    [Arguments]    ${ten_cat}
    #${credential}=    Create Dictionary    username=${USER_NAME}    password=${PASSWORD}
    #${header}=    Create Dictionary    Authorization=${bearertoken}    branchid={BRANCH_ID}
    #Create Session    env    ${API_URL}    headers=${header}    verify=True
    #${resp1}=    Post Request    env    /auth/credentials    data=${credential}
    #Should Be Equal As Strings    ${resp1.status_code}    200
    #Log    ${resp1.json()}
    #${bearertoken}    Get usable bearer token in json    ${resp1.json()}
    #Log    ${resp1.status_code}
    ${data_str}    Format String    {{"Category":{{"Id":0,"Name":"{0}","ParentId":0}},"CompareCateName":""}}    ${ten_cat}
    log    ${data_str}
    Post request thr API    /categories    ${data_str}

Add combo
    [Arguments]    ${ui_combo_code}    ${ten_sp}    ${nhom}    ${giaban}    ${ui_code_pr1}    ${soluong1}
    ...    ${ui_code_pr2}    ${soluong2}
    ${endpoint_pr}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${jsonpath_product_id1}    Format String    $..Data[?(@.Code=="{0}")].Id    ${ui_code_pr1}
    ${jsonpath_product_id2}    Format String    $..Data[?(@.Code=="{0}")].Id    ${ui_code_pr2}
    ${get_product_id1}    Get data from API    ${endpoint_pr}    ${jsonpath_product_id1}
    ${get_product_id2}    Get data from API    ${endpoint_pr}    ${jsonpath_product_id2}
    ${cat_id}    Hanghoa.Get category ID    ${nhom}
    Add combo products    ${ui_combo_code}    ${ten_sp}    ${cat_id}    ${giaban}    ${get_product_id1}    ${soluong1}
    ...    ${get_product_id2}    ${soluong2}

Add product and wait
    [Arguments]    ${ui_product_code}    ${ten_sp}    ${ten_nhom}    ${gia_ban}    ${giavon}    ${ton}
    Wait Until Keyword Succeeds    3x    1s    Add product thr API    ${ui_product_code}    ${ten_sp}    ${ten_nhom}
    ...    ${gia_ban}    ${giavon}    ${ton}

Add combo and wait
    [Arguments]    ${ui_combo_code}    ${ten_sp}    ${nhom}    ${giaban}    ${ui_code_pr1}    ${soluong1}
    ...    ${ui_code_pr2}    ${soluong2}
    Wait Until Keyword Succeeds    3x    1s    Add combo    ${ui_combo_code}    ${ten_sp}    ${nhom}
    ...    ${giaban}    ${ui_code_pr1}    ${soluong1}    ${ui_code_pr2}    ${soluong2}

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
    ${headers1}=    Create Dictionary    Authorization=${bearertoken}    Content-Type=application/json;charset=utf-8    Retailer=${RETAILER_NAME}    BranchId=${BRANCH_ID}
    Create Session    lolo    https://sale.kiotapi.com/api    #cookies=${resp.cookies}
    ${resp3}=    Post Request    lolo    /invoices    data=${data_str}    headers=${headers1}
    Log    ${resp3.request.body}
    Log    ${resp3.json()}
    Should Be Equal As Strings    ${resp3.status_code}    200

Get product ID
    [Arguments]    ${ma_hh}
    ${endpoint_hh_co_dvt}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${resp}    Get Request and return body    ${endpoint_hh_co_dvt}
    ${jsonpath_id_sp}    Format String    $..Data[?(@.Code == '{0}')].Id    ${ma_hh}
    ${get_prd_id}    Get data from response json    ${resp}    ${jsonpath_id_sp}
    Return From Keyword    ${get_prd_id}

Get category ID
    [Arguments]    ${category_name}
    # post to get bearer token
    ${resp1.json()}   Get Request and return body    /categories
    Log   ${resp1.json()}
    ${json_path}    Format String    $..Data[?(@.Name=="{0}")].{1}    ${category_name}    Id
    ${get_raw_data}    Get Value From Json    ${resp1.json()}    ${json_path}
    ${result} =    Evaluate    ${get_raw_data}[0] if ${get_raw_data} else 0
    ${result} =    Evaluate    $result or 0
    Return From Keyword    ${result}

Add new bang gia
    [Arguments]    ${input_ten_bangia}
    ${request_payload}    Format String    {{"PriceBook":{{"Id":0,"Name":"{0}","IsGlobal":true,"IsActive":true,"ForAllUser":true,"ForAllCusGroup":true,"StartDate":"2019-03-12T03:21:44.091Z","EndDate":"2025-03-12T03:21:44.091Z","selectedUser":[],"selectedBranch":[],"selectedCustomerGroup":[],"PriceBookCustomerGroups":[],"PriceBookUsers":[],"PriceBookBranches":[]}}}}    ${input_ten_bangia}
    log    ${request_payload}
    Post request thr API    /pricebook    ${request_payload}

Add lodate product thr API
    [Arguments]    ${ui_product_code}    ${tensp}    ${tennhom}    ${giaban}
    ${cat_id}    Get category ID    ${tennhom}
    Log    ${cat_id}
    ${format_data}    Format String    "Id":0,"ProductType":2,"CategoryId":{0},"CategoryName":"","isActive":false,"VariantCount":0,"AllowsSale":true,"isDeleted":false,"Code":"{1}","BasePrice":{2},"Cost":0,"LatestPurchasePrice":0,"OnHand":0,"OnOrder":0,"OnHandCompareMin":0,"OnHandCompareMax":0,"CompareOnHand":0,"CompareCost":0,"CompareBasePrice":0,"CompareCode":"","CompareUnit":"","Reserved":0,"MinQuantity":0,"MaxQuantity":999999999,"CustomId":0,"CustomValue":0,"MasterProductId":0,"Unit":"","ConversionValue":1,"OrderTemplate":"","IsLotSerialControl":false,"IsRewardPoint":false,"IsBatchExpireControl":true,"ProductFormulas":[],"Name":"{3}","ListPriceBookDetail":[],"ProductFormulasOld":[],"ProductImages":[]    ${cat_id}    ${ui_product_code}    ${giaban}    ${tensp}
    Log    ${format_data}
    ${data}    Evaluate    (None,'[{${format_data}}]')
    ${branch_pr_cost}   Set Variable    "Id":${BRANCH_ID},"Name":"Chi nhánh trung tâm"
    ${branch_pr_cost}     Evaluate    (None, '[{${branch_pr_cost}}]')
    ${payload}    Create Dictionary    ListProducts=${data}     BranchForProductCosts=${branch_pr_cost}
    Log    ${payload}
    Post request data form thr API    /products/addmany    ${payload}
    ${endpoint_pr}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${jsonpath_product_id}    Format String    $..Data[?(@.Code=="{0}")].Id    ${ui_product_code}
    ${get_product_id}    Get data from API    ${endpoint_pr}    ${jsonpath_product_id}
    Return From Keyword    ${get_product_id}

Add lodate product incl 1 unit thr API
    [Arguments]    ${masp}    ${tensp}    ${tennhom}    ${giaban}    ${dvcb}
    ${cat_id}    Get category ID    ${tennhom}
    Log    ${cat_id}
    ${format_data}    Format String    "Id":0,"ProductType":2,"CategoryId":{0},"CategoryName":"","isActive":false,"VariantCount":0,"AllowsSale":true,"isDeleted":false,"Code":"{1}","BasePrice":{2},"Cost":0,"LatestPurchasePrice":0,"OnHand":0,"OnOrder":0,"OnHandCompareMin":0,"OnHandCompareMax":0,"CompareOnHand":0,"CompareCost":0,"CompareBasePrice":0,"CompareCode":"","CompareUnit":"","Reserved":0,"MinQuantity":0,"MaxQuantity":999999999,"CustomId":0,"CustomValue":0,"MasterProductId":0,"Unit":"{3}","ConversionValue":1,"OrderTemplate":"","IsLotSerialControl":false,"IsRewardPoint":false,"IsBatchExpireControl":true,"GenuineGuarantees":[],"StoreGuarantees":[],"RepeatGuarantee":{{"Uuid":-1,"TimeType":2,"ProductId":0,"RetailerId":437950,"Description":"Toàn bộ sản phẩm"}},"ProductFormulas":[],"Name":"{4}","ListPriceBookDetail":[],"FullName":"","MasterCode":"","ListUnitPriceBookDetail":null,"ProductFormulasOld":[],"ProductImages":[]    ${cat_id}    ${masp}    ${giaban}    ${dvcb}
    ...    ${tensp}
    Log    ${format_data}    #    0    1    2    3
    ...    # 4
    ${data}    Evaluate    (None,'[{${format_data}}]')
    ${branch_pr_cost}   Set Variable    "Id":${BRANCH_ID},"Name":"Chi nhánh trung tâm"
    ${branch_pr_cost}     Evaluate    (None, '[{${branch_pr_cost}}]')
    ${payload}    Create Dictionary    ListProducts=${data}     BranchForProductCosts=${branch_pr_cost}
    Log    ${payload}
    Post request data form thr API    /products/addmany    ${payload}
    ${endpoint_pr}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${jsonpath_product_id}    Format String    $..Data[?(@.Code=="{0}")].Id    ${masp}
    ${get_product_id}    Get data from API    ${endpoint_pr}    ${jsonpath_product_id}
    Return From Keyword    ${get_product_id}

Add lodate product incl 2 unit thr API
    [Arguments]    ${masp}    ${tensp}    ${tennhom}    ${giaban}    ${dvcb}    ${masp2}
    ...    ${giaban2}    ${dvqd}    ${giatriqd}
    ${cat_id}    Get category ID    ${tennhom}
    Log    ${cat_id}
    ${format_data}    Format String    "Id":0,"ProductType":2,"CategoryId":{0},"CategoryName":"","isActive":false,"VariantCount":0,"AllowsSale":true,"isDeleted":false,"Code":"{1}","BasePrice":{2},"Cost":0,"LatestPurchasePrice":0,"OnHand":0,"OnOrder":0,"OnHandCompareMin":0,"OnHandCompareMax":0,"CompareOnHand":0,"CompareCost":0,"CompareBasePrice":0,"CompareCode":"","CompareUnit":"","Reserved":0,"MinQuantity":0,"MaxQuantity":999999999,"CustomId":0,"CustomValue":0,"MasterProductId":0,"Unit":"{3}","ConversionValue":1,"OrderTemplate":"","IsLotSerialControl":false,"IsRewardPoint":false,"IsBatchExpireControl":true,"GenuineGuarantees":[],"StoreGuarantees":[],"RepeatGuarantee":{{"Uuid":-1,"TimeType":2,"ProductId":0,"RetailerId":437950,"Description":"Toàn bộ sản phẩm"}},"ProductFormulas":[],"Name":"{4}","ListPriceBookDetail":[],"FullName":"","MasterCode":"","ListUnitPriceBookDetail":null,"ProductFormulasOld":[],"ProductImages":[]}},{{"Id":0,"ProductType":2,"CategoryId":{0},"CategoryName":"","isActive":false,"VariantCount":0,"AllowsSale":true,"isDeleted":false,"Code":"{5}","BasePrice":{6},"Cost":0,"LatestPurchasePrice":0,"OnHand":0,"OnOrder":0,"OnHandCompareMin":0,"OnHandCompareMax":0,"CompareOnHand":0,"CompareCost":0,"CompareBasePrice":0,"CompareCode":"","CompareUnit":"","Reserved":0,"MinQuantity":0,"MaxQuantity":999999999,"CustomId":0,"CustomValue":0,"MasterProductId":0,"Unit":"{7}","ConversionValue":{8},"OrderTemplate":"","IsLotSerialControl":false,"IsRewardPoint":false,"IsBatchExpireControl":true,"GenuineGuarantees":[],"StoreGuarantees":[],"RepeatGuarantee":{{"Uuid":-1,"TimeType":2,"ProductId":0,"RetailerId":437950,"Description":"Toàn bộ sản phẩm"}},"ProductFormulas":[],"Name":"{4}","ListPriceBookDetail":[],"ProductUnits":[{{"Id":0,"Unit":"lốc","Code":"","ConversionValue":1,"BasePrice":0}}],"FullName":"","MasterCode":"","ListUnitPriceBookDetail":[],"ProductFormulasOld":[],"ProductImages":[]    ${cat_id}    ${masp}    ${giaban}    ${dvcb}
    ...    ${tensp}    ${masp2}    ${giaban2}    ${dvqd}    ${giatriqd}
    Log    ${format_data}    #    0    1    2    3
    ...    # 4    5    6    7    8
    ${data}    Evaluate    (None,'[{${format_data}}]')
    ${branch_pr_cost}   Set Variable    "Id":${BRANCH_ID},"Name":"Chi nhánh trung tâm"
    ${branch_pr_cost}     Evaluate    (None, '[{${branch_pr_cost}}]')
    ${payload}    Create Dictionary    ListProducts=${data}     BranchForProductCosts=${branch_pr_cost}
    Log    ${payload}
    Post request data form thr API    /products/addmany    ${payload}
    ${endpoint_pr}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${jsonpath_product_id}    Format String    $..Data[?(@.Code=="{0}")].Id    ${masp}
    ${get_product_id}    Get data from API    ${endpoint_pr}    ${jsonpath_product_id}
    Return From Keyword    ${get_product_id}

Add attribute thr API
    [Arguments]    ${input_thuoctinh}
    ${request_payload}    Format String    {{"Attribute":{{"Id":0,"Name":"{0}"}}}}    ${input_thuoctinh}
    log    ${request_payload}
    Post request thr API    /attributes     ${request_payload}

Add shelve thr API
    [Arguments]    ${input_vitri}
    ${request_payload}    Format String    {{"Shelves":{{"Name":"{0}"}}}}    ${input_vitri}
    log    ${request_payload}
    Post request thr API      /shelves     ${request_payload}

Add all category into price book thr API
    [Arguments]    ${ten_bang_gia}
    ${pricebook_id}    Get price book id    ${ten_bang_gia}
    ${request_payload}    Format String    {{"CategoryId":0,"PriceBookId":{0},"ComparePriceBookName":""}}    ${pricebook_id}
    Log    ${request_payload}
    Post request thr API      ${endpoint_banggia_add_nhomhang}     ${request_payload}

Reduced price for all product in pricebook thr API
    [Arguments]    ${ten_bang_gia}    ${giamgia}
    ${pricebook_id}    Get price book id    ${ten_bang_gia}
    ${request_payload}    Format String    {{"PriceBookId":{0},"PriceBookName":"","Operator":2,"CalcValue":{1},"CalcValueType":"%","CalcPriceType":"3","CalcPriceTypeName":"Giá chung","Keyword":"","CategoryId":0,"Number":1636}}    ${pricebook_id}    ${giamgia}
    Log    ${request_payload}
    Post request thr API      ${endpoint_banggia_chinhsua_gia}     ${request_payload}

Add new price book and add all category - discount %
    [Arguments]    ${input_ten_banggia}    ${giamgia}
    Add new bang gia    ${input_ten_banggia}
    Add all category into price book thr API    ${input_ten_banggia}
    Reduced price for all product in pricebook thr API    ${input_ten_banggia}    ${giamgia}

Add product have genuine guarantees
    [Arguments]    ${ui_product_code}    ${ten_sp}    ${ten_nhom}    ${gia_ban}    ${giavon}    ${ton}    ${time_bh}    ${timetype_bh}
    ...    ${time_bt}    ${timetype_bt}
    ${cat_id}    Hanghoa.Get category ID    ${ten_nhom}
    ${get_retailer_id}    Get RetailerID
    log    ${cat_id}
    ${format_data}    Format String    "Id":0,"ProductType":2,"CategoryId":{0},"CategoryName":"","isActive":false,"VariantCount":0,"AllowsSale":true,"isDeleted":false,"Code":"{1}","BasePrice":{2},"Cost":{3},"LatestPurchasePrice":0,"OnHand":{4},"OnOrder":0,"OnHandCompareMin":0,"OnHandCompareMax":0,"CompareOnHand":0,"CompareCost":0,"CompareBasePrice":0,"CompareCode":"","CompareBarcode":"","CompareUnit":"","Reserved":0,"MinQuantity":0,"MaxQuantity":999999999,"CustomId":0,"CustomValue":0,"MasterProductId":0,"Unit":"","ConversionValue":1,"OrderTemplate":"","IsLotSerialControl":false,"IsRewardPoint":true,"FormulaCount":0,"Barcode":"","GenuineGuarantees":[{{"Uuid":,"Id":-9999,"Description":"Toàn bộ sản phẩm","NumberTime":{5},"TimeType":{6},"WarrantyType":1,"ProductId":0,"RetailerId":{7},"$$hashKey":"object:3895"}}],"StoreGuarantees":[],"RepeatGuarantee":{{"Uuid":,"TimeType":{8},"ProductId":0,"RetailerId":{7},"Description":"Toàn bộ sản phẩm","NumberTime":{9}}},"ProductFormulas":[],"Name":"{10}","showMaintenance":true,"ListPriceBookDetail":[],"ProductFormulasOld":[],"ProductImages":[],"RewardPoint":0,"IsWarranty":3    ${cat_id}    ${ui_product_code}    ${gia_ban}    ${giavon}
    ...    ${ton}    ${time_bh}    ${timetype_bh}    ${get_retailer_id}    ${timetype_bt}    ${time_bt}    ${ten_sp}
    log    ${format_data}
    ${data}    Evaluate    (None, '[{${format_data}}]')
    ${branch_pr_cost}   Set Variable    "Id":${BRANCH_ID},"Name":"Chi nhánh trung tâm"
    ${branch_pr_cost}     Evaluate    (None, '[{${branch_pr_cost}}]')
    ${payload}    Create Dictionary    ListProducts=${data}     BranchForProductCosts=${branch_pr_cost}
    Log    ${payload}
    Post request data form thr API    /products/addmany    ${payload}
    :FOR    ${time}     IN RANGE      10
    \   ${endpoint_danhmuc_hh_co_dvt}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    \   ${jsonpath_product_id}    Format String    $..Data[?(@.Code=="{0}")].Id    ${ui_product_code}
    \   ${get_product_id}    Get data from API    ${endpoint_danhmuc_hh_co_dvt}    ${jsonpath_product_id}
    \   Exit For Loop If    ${get_product_id} != 0
    Return From Keyword    ${get_product_id}

Add service have genuine guarantees
    [Arguments]    ${ui_product_code}    ${ten_sp}    ${ten_nhom}    ${gia_ban}    ${gia_von}   ${time_bh1}   ${timetype_bh1}   ${time_bh2}   ${timetype_bh2}
    ...   ${time_bh3}   ${timetype_bh3}    ${time_bt}    ${timetype_bt}
    ${cat_id}    Hanghoa.Get category ID    ${ten_nhom}
    ${get_retailer_id}    Get RetailerID
    log    ${cat_id}
    ${format_data}    Format String    "Id":0,"ProductType":3,"CategoryId":{0},"CategoryName":"","isActive":false,"VariantCount":0,"AllowsSale":true,"isDeleted":false,"Code":"{1}","BasePrice":{2},"Cost":{3},"LatestPurchasePrice":0,"OnHand":0,"OnOrder":0,"OnHandCompareMin":0,"OnHandCompareMax":0,"CompareOnHand":0,"CompareCost":0,"CompareBasePrice":0,"CompareCode":"","CompareBarcode":"","CompareUnit":"","Reserved":0,"MinQuantity":0,"MaxQuantity":999999999,"CustomId":0,"CustomValue":0,"MasterProductId":0,"Unit":"","ConversionValue":1,"OrderTemplate":"","IsLotSerialControl":false,"IsRewardPoint":false,"FormulaCount":0,"Barcode":"","GenuineGuarantees":[{{"Uuid":,"Id":-9999,"Description":"Phần cứng","NumberTime":{4},"TimeType":{5},"WarrantyType":1,"ProductId":0,"RetailerId":{6},"$$hashKey":"object:5796"}},{{"Uuid":,"Id":-9999,"Description":"1 đổi 1","NumberTime":{7},"TimeType":{8},"WarrantyType":1,"ProductId":0,"RetailerId":{6},"$$hashKey":"object:5818"}},{{"Uuid":,"Id":-9999,"Description":"Pin","NumberTime":{9},"TimeType":{10},"WarrantyType":1,"ProductId":0,"RetailerId":{6},"$$hashKey":"object:5843"}}],"StoreGuarantees":[],"RepeatGuarantee":{{"Uuid":,"TimeType":{11},"ProductId":0,"RetailerId":{6},"Description":"Toàn bộ sản phẩm","NumberTime":{12}}},"ProductFormulas":[],"Name":"{13}","showMaintenance":true,"ListPriceBookDetail":[],"ProductFormulasOld":[],"ProductImages":[],"IsWarranty":3
    ...   ${cat_id}    ${ui_product_code}    ${gia_ban}    ${gia_von}   ${time_bh1}   ${timetype_bh1}    ${get_retailer_id}   ${time_bh2}   ${timetype_bh2}
    ...   ${time_bh3}   ${timetype_bh3}    ${timetype_bt}    ${time_bt}    ${ten_sp}
    log    ${format_data}
    ${data}    Evaluate    (None, '[{${format_data}}]')
    ${branch_pr_cost}   Set Variable    "Id":${BRANCH_ID},"Name":"Chi nhánh trung tâm"
    ${branch_pr_cost}     Evaluate    (None, '[{${branch_pr_cost}}]')
    ${payload}    Create Dictionary    ListProducts=${data}     BranchForProductCosts=${branch_pr_cost}
    Log    ${payload}
    Post request data form thr API    /products/addmany    ${payload}
    ${jsonpath_product_id}    Format String    $..Data[?(@.Code=="{0}")].Id    ${ui_product_code}
    ${endpoint_danhmuc_hh_co_dvt}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${get_product_id}    Get data from API    ${endpoint_danhmuc_hh_co_dvt}    ${jsonpath_product_id}
    Return From Keyword    ${get_product_id}

Add imei product have guarantees
    [Arguments]    ${ui_product_code}    ${ten_sp}    ${ten_nhom}    ${gia_ban}   ${giavon}    ${time_bh1}   ${timetype_bh1}   ${time_bh2}   ${timetype_bh2}
    ...   ${time_bh3}   ${timetype_bh3}    ${time_bt}    ${timetype_bt}
    ${cat_id}    Hanghoa.Get category ID    ${ten_nhom}
    ${get_retailer_id}    Get RetailerID
    ${format_data}    Format String    "Id":0,"ProductType":2,"CategoryId":{0},"CategoryName":"","isActive":false,"VariantCount":0,"AllowsSale":true,"isDeleted":false,"Code":"{1}","BasePrice":{2},"Cost":{13},"LatestPurchasePrice":0,"OnHand":0,"OnOrder":0,"OnHandCompareMin":0,"OnHandCompareMax":0,"CompareOnHand":0,"CompareCost":0,"CompareBasePrice":0,"CompareCode":"","CompareBarcode":"","CompareUnit":"","Reserved":0,"MinQuantity":0,"MaxQuantity":999999999,"CustomId":0,"CustomValue":0,"MasterProductId":0,"Unit":"","ConversionValue":1,"OrderTemplate":"","IsLotSerialControl":true,"IsRewardPoint":false,"FormulaCount":0,"Barcode":"","GenuineGuarantees":[{{"Uuid":,"Id":-9999,"Description":"Phần cứng","NumberTime":{3},"TimeType":{4},"WarrantyType":1,"ProductId":0,"RetailerId":{5},"$$hashKey":"object:5796"}},{{"Uuid":,"Id":-9999,"Description":"1 đổi 1","NumberTime":{6},"TimeType":{7},"WarrantyType":1,"ProductId":0,"RetailerId":{5},"$$hashKey":"object:5818"}},{{"Uuid":,"Id":-9999,"Description":"Pin","NumberTime":{8},"TimeType":{9},"WarrantyType":1,"ProductId":0,"RetailerId":{5},"$$hashKey":"object:5843"}}],"StoreGuarantees":[],"RepeatGuarantee":{{"Uuid":,"TimeType":{10},"ProductId":0,"RetailerId":{5},"Description":"Toàn bộ sản phẩm","NumberTime":{11}}},"ProductFormulas":[],"Name":"{12}","showMaintenance":true,"ListPriceBookDetail":[],"ProductFormulasOld":[],"ProductImages":[],"IsWarranty":3   ${cat_id}    ${ui_product_code}    ${gia_ban}
    ...   ${time_bh1}   ${timetype_bh1}    ${get_retailer_id}   ${time_bh2}   ${timetype_bh2}   ${time_bh3}   ${timetype_bh3}    ${timetype_bt}
    ...    ${time_bt}    ${ten_sp}   ${giavon}
    log    ${format_data}
    ${data}    Evaluate    (None, '[{${format_data}}]')
    ${branch_pr_cost}   Set Variable    "Id":${BRANCH_ID},"Name":"Chi nhánh trung tâm"
    ${branch_pr_cost}     Evaluate    (None, '[{${branch_pr_cost}}]')
    ${payload}    Create Dictionary    ListProducts=${data}     BranchForProductCosts=${branch_pr_cost}
    Log    ${payload}
    Post request data form thr API    /products/addmany    ${payload}
    ${endpoint_pr}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${jsonpath_product_id}    Format String    $..Data[?(@.Code=="{0}")].Id    ${ui_product_code}
    ${get_product_id}    Get data from API    ${endpoint_pr}    ${jsonpath_product_id}
    Return From Keyword    ${get_product_id}

Add product incl 2 units have guarantee
    [Arguments]    ${mahh}    ${ten}    ${ten_nhom}    ${giaban}    ${giavon}    ${ton}    ${dvcb}    ${tendv1}    ${gtqd1}    ${giaban1}
    ...    ${ma_hh1}    ${tendv2}    ${gtqd2}    ${giaban2}    ${ma_hh2}    ${time_bh}    ${timetype_bh}    ${time_bt}    ${timetype_bt}
    ${cat_id}    Hanghoa.Get category ID    ${ten_nhom}
    ${get_retailer_id}    Get RetailerID
    log    ${cat_id}
    ${ton_qd1}    Divide OnHand    ${ton}    ${gtqd1}
    ${ton_qd2}    Divide OnHand    ${ton}    ${gtqd2}
    ${giavon_qd1}    Multiplication with price round 2    ${giavon}    ${gtqd1}
    ${giavon_qd2}    Multiplication with price round 2    ${giavon}    ${gtqd2}
    ${format_data}    Format String    "Id":0,"ProductType":2,"CategoryId":{0},"CategoryName":"","isActive":false,"HasVariants":false,"VariantCount":0,"AllowsSale":true,"isDeleted":false,"Code":"{1}","BasePrice":{2},"Cost":{3},"LatestPurchasePrice":0,"OnHand":{4},"OnOrder":0,"OnHandCompareMin":0,"OnHandCompareMax":0,"CompareOnHand":0,"CompareCost":0,"CompareBasePrice":0,"CompareCode":"","CompareBarcode":"","CompareUnit":"","Reserved":0,"MinQuantity":0,"MaxQuantity":999999999,"CustomId":0,"CustomValue":0,"MasterProductId":0,"Unit":"{5}","ConversionValue":1,"OrderTemplate":"","IsLotSerialControl":false,"IsRewardPoint":true,"FormulaCount":0,"Barcode":"","GenuineGuarantees":[{{"Uuid":1,"Id":-9999,"Description":"Toàn bộ sản phẩm","NumberTime":{6},"TimeType":{7},"WarrantyType":1,"ProductId":0,"RetailerId":{8},"$$hashKey":"object:21719"}}],"StoreGuarantees":[],"RepeatGuarantee":{{"Uuid":-1,"TimeType":{9},"ProductId":0,"RetailerId":{8},"Description":"Toàn bộ sản phẩm","NumberTime":{10}}},"ProductFormulas":[],"Name":"{11}","ProductAttributes":[],"ListPriceBookDetail":[],"FullName":"","MasterCode":"","ListUnitPriceBookDetail":null,"RewardPoint":0,"MasterUnitIdClone":null,"ProductFormulasOld":[],"ProductImages":[],"IsWarranty":3}},{{"Id":0,"ProductType":2,"CategoryId":{0},"CategoryName":"","isActive":false,"HasVariants":false,"VariantCount":0,"AllowsSale":true,"isDeleted":false,"Code":"{12}","BasePrice":{13},"Cost":{14},"LatestPurchasePrice":0,"OnHand":{15},"OnOrder":0,"OnHandCompareMin":0,"OnHandCompareMax":0,"CompareOnHand":0,"CompareCost":0,"CompareBasePrice":0,"CompareCode":"","CompareBarcode":"","CompareUnit":"","Reserved":0,"MinQuantity":0,"MaxQuantity":999999999,"CustomId":0,"CustomValue":0,"MasterProductId":0,"Unit":"{16}","ConversionValue":{17},"OrderTemplate":"","IsLotSerialControl":false,"IsRewardPoint":true,"FormulaCount":0,"Barcode":"","GenuineGuarantees":[{{"Uuid":1,"Id":-9999,"Description":"Toàn bộ sản phẩm","NumberTime":{6},"TimeType":{7},"WarrantyType":1,"ProductId":0,"RetailerId":{8},"$$hashKey":"object:21719"}}],"StoreGuarantees":[],"RepeatGuarantee":{{"Uuid":-1,"TimeType":{9},"ProductId":0,"RetailerId":{8},"Description":"Toàn bộ sản phẩm","NumberTime":{10}}},"ProductFormulas":[],"Name":"{11}","ProductAttributes":[],"ListPriceBookDetail":[],"ProductUnits":[{{"Id":0,"Unit":"{16}","Code":"{12}","ConversionValue":1,"BasePrice":0,"AllowsSale":true}}],"FullName":"","MasterCode":"","ListUnitPriceBookDetail":[],"RewardPoint":0,"MasterUnitIdClone":null,"ProductFormulasOld":[],"ProductImages":[],"IsWarranty":3}},{{"Id":0,"ProductType":2,"CategoryId":{0},"CategoryName":"","isActive":false,"HasVariants":false,"VariantCount":0,"AllowsSale":true,"isDeleted":false,"Code":"{18}","BasePrice":{19},"Cost":{20},"LatestPurchasePrice":0,"OnHand":{21},"OnOrder":0,"OnHandCompareMin":0,"OnHandCompareMax":0,"CompareOnHand":0,"CompareCost":0,"CompareBasePrice":0,"CompareCode":"","CompareBarcode":"","CompareUnit":"","Reserved":0,"MinQuantity":0,"MaxQuantity":999999999,"CustomId":0,"CustomValue":0,"MasterProductId":0,"Unit":"{22}","ConversionValue":{23},"OrderTemplate":"","IsLotSerialControl":false,"IsRewardPoint":true,"FormulaCount":0,"Barcode":"","GenuineGuarantees":[{{"Uuid":1,"Id":-9999,"Description":"Toàn bộ sản phẩm","NumberTime":{6},"TimeType":{7},"WarrantyType":1,"ProductId":0,"RetailerId":{8},"$$hashKey":"object:21719"}}],"StoreGuarantees":[],"RepeatGuarantee":{{"Uuid":-1,"TimeType":{9},"ProductId":0,"RetailerId":{8},"Description":"Toàn bộ sản phẩm","NumberTime":{10}}},"ProductFormulas":[],"Name":"{11}","ProductAttributes":[],"ListPriceBookDetail":[],"ProductUnits":[{{"Id":0,"Unit":"{16}","Code":"{12}","ConversionValue":{17},"BasePrice":{13},"AllowsSale":true,"Cost":{14},"OnHand":{15}}},{{"Id":0,"Unit":"{22}","Code":"{18}","ConversionValue":1,"BasePrice":0,"AllowsSale":true}}],"FullName":"","MasterCode":"","ListUnitPriceBookDetail":[],"RewardPoint":0,"MasterUnitIdClone":null,"ProductFormulasOld":[],"ProductImages":[],"IsWarranty":3    ${cat_id}    ${mahh}    ${giaban}   ${giavon}    ${ton}     ${dvcb}    ${time_bh}    ${timetype_bh}    ${get_retailer_id}
    ...    ${timetype_bt}     ${time_bt}    ${ten}    ${ma_hh1}    ${giaban1}    ${giavon_qd1}    ${ton_qd1}   ${tendv1}    ${gtqd1}
    ...    ${ma_hh2}    ${giaban2}    ${giavon_qd2}    ${ton_qd2}    ${tendv2}    ${gtqd2}
    ${data}    Evaluate    (None, '[{${format_data}}]')
    ${branch_pr_cost}   Set Variable    "Id":${BRANCH_ID},"Name":"Chi nhánh trung tâm"
    ${branch_pr_cost}     Evaluate    (None, '[{${branch_pr_cost}}]')
    ${payload}    Create Dictionary    ListProducts=${data}     BranchForProductCosts=${branch_pr_cost}
    Log    ${payload}
    Post request data form thr API    /products/addmany    ${payload}
    ${endpoint_pr}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${jsonpath_product_id1}    Format String    $..Data[?(@.Code=="{0}")].Id    ${mahh}
    ${jsonpath_product_id2}    Format String    $..Data[?(@.Code=="{0}")].Id    ${ma_hh1}
    ${jsonpath_product_id3}    Format String    $..Data[?(@.Code=="{0}")].Id    ${ma_hh2}
    ${get_product_id1}    Get data from API    ${endpoint_pr}    ${jsonpath_product_id1}
    ${get_product_id2}    Get data from API    ${endpoint_pr}    ${jsonpath_product_id2}
    ${get_product_id3}    Get data from API    ${endpoint_pr}    ${jsonpath_product_id3}
    Return From Keyword    ${get_product_id1}    ${get_product_id2}    ${get_product_id3}

Save guarantee after create product
    [Arguments]    ${time_bh}    ${timetype_bh}    ${time_bt}    ${timetype_bt}   ${product_id}
    ${retailer_id}    Get RetailerID
    ${data_str}    Format String    {{"productIdsToSaveForMany":null,"warranties":[{{"Uuid":1,"Id":-9999,"Description":"Toàn bộ sản phẩm","NumberTime":{0},"TimeType":{1},"WarrantyType":1,"ProductId":{2},"RetailerId":{3}}},{{"Uuid":-1,"TimeType":{4},"ProductId":{2},"RetailerId":{3},"Description":"Toàn bộ sản phẩm","NumberTime":{5},"WarrantyType":3}}]}}    ${time_bh}    ${timetype_bh}    ${product_id}    ${retailer_id}
    ...    ${timetype_bt}    ${time_bt}
    log    ${data_str}
    Post request by other URL API    ${WARRANTY_API}    /warranty/save?kvuniqueparam=2020     ${data_str}

Save multi guarantee after create product
    [Arguments]    ${time_bh}    ${timetype_bh}    ${time_bh1}    ${timetype_bh1}    ${time_bh2}    ${timetype_bh2}    ${time_bt}    ${timetype_bt}
    ...   ${product_id}
    ${retailer_id}    Get RetailerID
    ${data_str}    Format String    {{"productIdsToSaveForMany":null,"warranties":[{{"Uuid":1,"Id":-9999,"Description":"Toàn bộ sản phẩm","NumberTime":{0},"TimeType":{1},"WarrantyType":1,"ProductId":{2},"RetailerId":{3}}},{{"Uuid":2,"Id":-9999,"Description":"Phần cứng","NumberTime":{4},"TimeType":{5},"WarrantyType":1,"ProductId":{2},"RetailerId":{3}}},{{"Uuid":3,"Id":-9999,"Description":"1 đổi 1","NumberTime":{6},"TimeType":{7},"WarrantyType":1,"ProductId":{2},"RetailerId":{3}}},{{"Uuid":-1,"TimeType":{8},"ProductId":{2},"RetailerId":{3},"Description":"Toàn bộ sản phẩm","NumberTime":{9},"WarrantyType":3}}]}}    ${time_bh}    ${timetype_bh}    ${product_id}    ${retailer_id}
    ...    ${time_bh1}    ${timetype_bh1}    ${time_bh2}    ${timetype_bh2}    ${timetype_bt}    ${time_bt}
    log    ${data_str}
    Post request by other URL API    ${WARRANTY_API}    /warranty/save      ${data_str}

Save unit procut guarantee after create product
    [Arguments]    ${time_bh}    ${timetype_bh}    ${time_bt}    ${timetype_bt}   ${product_id1}   ${product_id2}   ${product_id3}
    ${retailer_id}    Get RetailerID
    ${data_str}    Format String    {{"productIdsToSaveForMany":null,"warranties":[{{"Uuid":1,"Id":-9999,"Description":"Toàn bộ sản phẩm","NumberTime":{0},"TimeType":{1},"WarrantyType":1,"ProductId":{2},"RetailerId":{3}}},{{"Uuid":-1,"TimeType":{4},"ProductId":{2},"RetailerId":{3},"Description":"Toàn bộ sản phẩm","NumberTime":{5},"WarrantyType":3}},{{"Uuid":1,"Id":-9999,"Description":"Toàn bộ sản phẩm","NumberTime":{0},"TimeType":{1},"WarrantyType":1,"ProductId":{6},"RetailerId":{3}}},{{"Uuid":-1,"TimeType":{4},"ProductId":{6},"RetailerId":{3},"Description":"Toàn bộ sản phẩm","NumberTime":{5},"WarrantyType":3}},{{"Uuid":1,"Id":-9999,"Description":"Toàn bộ sản phẩm","NumberTime":{0},"TimeType":{1},"WarrantyType":1,"ProductId":{7},"RetailerId":{3}}},{{"Uuid":-1,"TimeType":{4},"ProductId":{7},"RetailerId":{3},"Description":"Toàn bộ sản phẩm","NumberTime":{5},"WarrantyType":3}}]}}    ${time_bh}    ${timetype_bh}    ${product_id1}    ${retailer_id}
    ...    ${timetype_bt}    ${time_bt}   ${product_id2}   ${product_id3}
    log    ${data_str}
    Post request by other URL API    ${WARRANTY_API}    /warranty/save      ${data_str}

Add product incl 2 units for allow sale
    [Arguments]    ${mahh}    ${ten_hh}    ${ten_nhom}    ${giaban}    ${giavon}    ${ton}
    ...    ${dvcb}    ${tendv1}    ${gtqd1}    ${giaban1}    ${ma_hh1}    ${tendv2}
    ...    ${gtqd2}    ${giaban2}    ${ma_hh2}    ${btt_cb}   ${btt_qd1}   ${btt_qd2}
    ${cat_id}    Hanghoa.Get category ID    ${ten_nhom}
    log    ${cat_id}
    ${ton_qd1}    Divide OnHand    ${ton}    ${gtqd1}
    ${ton_qd2}    Divide OnHand    ${ton}    ${gtqd2}
    ${giavon_qd1}    Multiplication with price round 2    ${giavon}    ${gtqd1}
    ${giavon_qd2}    Multiplication with price round 2    ${giavon}    ${gtqd2}
    ${format_data}    Format String    "Id":0,"ProductType":2,"CategoryId":{0},"CategoryName":"","isActive":false,"VariantCount":0,"AllowsSale":{1},"isDeleted":false,"Code":"{2}","BasePrice":{3},"Cost":{4},"LatestPurchasePrice":0,"OnHand":{5},"OnOrder":0,"OnHandCompareMin":0,"OnHandCompareMax":0,"CompareOnHand":0,"CompareCost":0,"CompareBasePrice":0,"CompareCode":"","CompareBarcode":"","CompareUnit":"","Reserved":0,"MinQuantity":0,"MaxQuantity":999999999,"CustomId":0,"CustomValue":0,"MasterProductId":0,"Unit":"{6}","ConversionValue":1,"OrderTemplate":"","IsLotSerialControl":false,"IsRewardPoint":true,"FormulaCount":0,"Barcode":"","GenuineGuarantees":[],"StoreGuarantees":[],"RepeatGuarantee":{{"Uuid":-1,"TimeType":2,"ProductId":0,"RetailerId":307027,"Description":"Toàn bộ sản phẩm"}},"ProductFormulas":[],"Name":"{7}","ListPriceBookDetail":[],"FullName":"","MasterCode":"","ListUnitPriceBookDetail":null,"RewardPoint":0,"MasterUnitIdClone":null,"ProductFormulasOld":[],"ProductImages":[],"IsWarranty":0}},{{"Id":0,"ProductType":2,"CategoryId":{0},"CategoryName":"","isActive":false,"VariantCount":0,"AllowsSale":{8},"isDeleted":false,"Code":"{9}","BasePrice":{10},"Cost":{11},"LatestPurchasePrice":0,"OnHand":{12},"OnOrder":0,"OnHandCompareMin":0,"OnHandCompareMax":0,"CompareOnHand":0,"CompareCost":0,"CompareBasePrice":0,"CompareCode":"","CompareBarcode":"","CompareUnit":"","Reserved":0,"MinQuantity":0,"MaxQuantity":999999999,"CustomId":0,"CustomValue":0,"MasterProductId":0,"Unit":"{13}","ConversionValue":{14},"OrderTemplate":"","IsLotSerialControl":false,"IsRewardPoint":true,"FormulaCount":0,"Barcode":"","GenuineGuarantees":[],"StoreGuarantees":[],"RepeatGuarantee":{{"Uuid":-1,"TimeType":2,"ProductId":0,"RetailerId":307027,"Description":"Toàn bộ sản phẩm"}},"ProductFormulas":[],"Name":"{7}","ListPriceBookDetail":[],"FullName":"","MasterCode":"","ListUnitPriceBookDetail":[],"RewardPoint":0,"MasterUnitIdClone":null,"hasManualEditCode":true,"ProductFormulasOld":[],"ProductImages":[],"IsWarranty":0}},{{"Id":0,"ProductType":2,"CategoryId":{0},"CategoryName":"","isActive":false,"VariantCount":0,"AllowsSale":{15},"isDeleted":false,"Code":"{16}","BasePrice":{17},"Cost":{18},"LatestPurchasePrice":0,"OnHand":{19},"OnOrder":0,"OnHandCompareMin":0,"OnHandCompareMax":0,"CompareOnHand":0,"CompareCost":0,"CompareBasePrice":0,"CompareCode":"","CompareBarcode":"","CompareUnit":"","Reserved":0,"MinQuantity":0,"MaxQuantity":999999999,"CustomId":0,"CustomValue":0,"MasterProductId":0,"Unit":"{20}","ConversionValue":{21},"OrderTemplate":"","IsLotSerialControl":false,"IsRewardPoint":true,"FormulaCount":0,"Barcode":"","GenuineGuarantees":[],"StoreGuarantees":[],"RepeatGuarantee":{{"Uuid":-1,"TimeType":2,"ProductId":0,"RetailerId":307027,"Description":"Toàn bộ sản phẩm"}},"ProductFormulas":[],"Name":"{7}","ListPriceBookDetail":[],"FullName":"","MasterCode":"","ListUnitPriceBookDetail":[],"RewardPoint":0,"MasterUnitIdClone":null,"hasManualEditCode":true,"ProductFormulasOld":[],"ProductImages":[],"IsWarranty":0        ${cat_id}    ${btt_cb}    ${mahh}    ${giaban}   ${giavon}    ${ton}     ${dvcb}
    ...     ${ten_hh}   ${btt_qd1}    ${ma_hh1}    ${giaban1}    ${giavon_qd1}    ${ton_qd1}   ${tendv1}    ${gtqd1}   ${btt_qd2}
    ...    ${ma_hh2}    ${giaban2}    ${giavon_qd2}    ${ton_qd2}    ${tendv2}    ${gtqd2}
    ${data}    Evaluate    (None, '[{${format_data}}]')
    ${branch_pr_cost}   Set Variable    "Id":${BRANCH_ID},"Name":"Chi nhánh trung tâm"
    ${branch_pr_cost}     Evaluate    (None, '[{${branch_pr_cost}}]')
    ${payload}    Create Dictionary    ListProducts=${data}     BranchForProductCosts=${branch_pr_cost}
    Log    ${payload}
    Post request data form thr API    /products/addmany    ${payload}

Add new trade mark thr API
    [Arguments]    ${input_thuonghieu}
    ${request_payload}    Format String     {{"TradeMark":{{"Name":"{0}"}}}}       ${input_thuonghieu}
    log    ${request_payload}
    Post request thr API    /trademark    ${request_payload}
    ${headers}=    Create Dictionary    Authorization=${bearertoken}    Content-Type=application/json;

Add product have min quantity and max quantity thr API
    [Arguments]    ${ui_product_code}    ${ten_sp}    ${ten_nhom}    ${gia_ban}    ${giavon}    ${ton}    ${ton_min}    ${ton_max}
    ${cat_id}    Hanghoa.Get category ID    ${ten_nhom}
    log    ${cat_id}
    ${retailerid}     Get RetailerID
    ${format_data}    Format String    "Id":0,"ProductType":2,"CategoryId":{0},"CategoryName":"","isActive":false,"VariantCount":0,"AllowsSale":true,"isDeleted":false,"Code":"{1}","BasePrice":{2},"Cost":{3},"LatestPurchasePrice":0,"OnHand":{4},"OnHandCompareMin":0,"OnHandCompareMax":0,"CompareOnHand":0,"CompareCost":0,"CompareBasePrice":0,"CompareCode":"","CompareUnit":"","Reserved":0,"MinQuantity":{5},"MaxQuantity":{6},"CustomId":0,"CustomValue":0,"MasterProductId":0,"Unit":"","ConversionValue":1,"OrderTemplate":"","IsLotSerialControl":false,"IsRewardPoint":false,"ProductFormulas":[],"Name":"{7}","ListPriceBookDetail":[],"ProductImages":[]    ${cat_id}    ${ui_product_code}    ${gia_ban}    ${giavon}
    ...    ${ton}     ${ton_min}    ${ton_max}      ${ten_sp}
    log    ${format_data}
    ${data}    Evaluate    (None, '[{${format_data}}]')
    ${branch_pr_cost}   Set Variable    "Id":${BRANCH_ID},"Name":"Chi nhánh trung tâm"
    ${branch_pr_cost}     Evaluate    (None, '[{${branch_pr_cost}}]')
    ${payload}    Create Dictionary    ListProducts=${data}     BranchForProductCosts=${branch_pr_cost}
    Log    ${payload}
    Post request data form thr API    /products/addmany    ${payload}

Add medicine thr API
    [Arguments]    ${ma_hh}    ${ten_thuoc}    ${nhom_hang}     ${giaban}    ${giavon}     ${duong_dung}
    ${cat_id}    Hanghoa.Get category ID    ${nhom_hang}
    log    ${cat_id}
    ${retailerid}     Get RetailerID
    ${get_ma_thuoc}    ${get_so_dk}    ${get_hoat_chat}      ${get_ham_luong}      ${get_hang_sx}      ${get_quy_cach_dong_goi}    ${get_don_vi}      Get infor of medicine thr API    ${ten_thuoc}
    ${get_ham_luong}      Set Variable If    '${get_ham_luong}'=='0'    1g   ${get_ham_luong}
    ${get_id_duongdung}     Get id duong dung thr API    ${duong_dung}
    ${format_data}    Format String    "Id":0,"ProductType":2,"CategoryId":{0},"CategoryName":"","isActive":false,"VariantCount":0,"AllowsSale":true,"isDeleted":false,"Code":"{1}","BasePrice":{2},"Cost":{3},"LatestPurchasePrice":0,"OnHand":0,"OnOrder":0,"OnHandCompareMin":0,"OnHandCompareMax":0,"CompareOnHand":0,"CompareCost":0,"CompareBasePrice":0,"CompareCode":"","CompareBarcode":"","CompareUnit":"","Reserved":0,"MinQuantity":0,"MaxQuantity":999999999,"CustomId":0,"CustomValue":0,"MasterProductId":0,"Unit":"{4}","ConversionValue":1,"OrderTemplate":"","IsLotSerialControl":false,"IsRewardPoint":false,"FormulaCount":0,"Barcode":"","oldBaseUnit":"{4}","Description":"","IsBatchExpireControl":true,"GenuineGuarantees":[],"StoreGuarantees":[],"RepeatGuarantee":{{"Uuid":-1,"TimeType":2,"ProductId":0,"RetailerId":{5},"Description":"Toàn bộ sản phẩm"}},"ProductFormulas":[],"Name":"{6}","GlobalMedicineId":5,"MedicineCode":"{7}","RegistrationNo":"{8}","ActiveElement":"{9}","Content":"{10}","GlobalManufacturerName":"{11}","GlobalManufacturerCountryName":"Việt Nam","PackagingSize":"{12}","GlobalManufacturerId":858,"GlobalRoaId":{13},"RetailerRoaId":null,"RouteOfAdministration":"{14}","ListPriceBookDetail":[],"ProductFormulasOld":[],"ProductImages":[]    ${cat_id}    ${ma_hh}    ${giaban}    ${giavon}
    ...    ${get_don_vi}      ${retailerid}     ${ten_thuoc}    ${get_ma_thuoc}     ${get_so_dk}      ${get_hoat_chat}      ${get_ham_luong}      ${get_hang_sx}     ${get_quy_cach_dong_goi}      ${get_id_duongdung}    ${duong_dung}
    log    ${format_data}
    ${data}    Evaluate    (None, '[{${format_data}}]')
    ${payload}    Create Dictionary    ListProducts=${data}
    Log    ${payload}
    Post request data form thr API    /products/addmany    ${payload}

Add product manufacturing
    [Arguments]    ${ma_sp}    ${ten_sp}    ${nhom_hang}    ${gia_ban}    ${ton}    ${hang_tp1}    ${so_luong1}
    ...    ${hang_tp2}    ${so_luong2}
    ${get_cat_id}     Get category ID    ${nhom_hang}
    ${get_pr_id_1}    Get product ID    ${hang_tp1}
    ${get_pr_id_2}    Get product ID    ${hang_tp2}
    ${format_data}    Format String    "Id":0,"ProductType":2,"CategoryId":{2},"CategoryName":"","isActive":false,"VariantCount":0,"AllowsSale":true,"isDeleted":false,"Code":"{0}","BasePrice":{3},"Cost":0,"LatestPurchasePrice":0,"OnHand":{8},"OnHandCompareMin":0,"OnHandCompareMax":0,"CompareOnHand":0,"CompareCost":0,"CompareBasePrice":0,"CompareCode":"","CompareUnit":"","Reserved":0,"MinQuantity":0,"MaxQuantity":999999999,"CustomId":0,"CustomValue":0,"MasterProductId":0,"Unit":"","ConversionValue":1,"OrderTemplate":"","IsLotSerialControl":false,"IsRewardPoint":false,"ProductFormulas":[{{"MaterialId":{4},"MaterialName":"Hạt macca","MaterialCode":"TPC001","Quantity":{5},"Cost":50000,"BasePrice":70000,"$$hashKey":"object:607"}},{{"MaterialId":{6},"MaterialName":"Hạt hướng dương","MaterialCode":"TPC002","Quantity":{7},"Cost":40000,"BasePrice":80000,"$$hashKey":"object:613"}}],"Name":"{1}","ListPriceBookDetail":[],"ProductImages":[]    ${ma_sp}    ${ten_sp}    ${get_cat_id}    ${gia_ban}
    ...    ${get_pr_id_1}    ${so_luong1}    ${get_pr_id_2}    ${so_luong2}     ${ton}
    log    ${format_data}
    ${data}    Evaluate    (None, '[{${format_data}}]')
    ${payload}    Create Dictionary    ListProducts=${data}
    Log    ${payload}
    Post request data form thr API    /products/addmany    ${payload}

Add product have point thr API
    [Arguments]    ${ui_product_code}    ${ten_sp}    ${ten_nhom}    ${gia_ban}    ${giavon}    ${ton}    ${diem_thuong}
    ${cat_id}    Hanghoa.Get category ID    ${ten_nhom}
    log    ${cat_id}
    ${format_data}    Format String    "Id":0,"ProductType":2,"CategoryId":{0},"CategoryName":"","isActive":false,"VariantCount":0,"AllowsSale":true,"isDeleted":false,"Code":"{1}","BasePrice":{2},"Cost":{3},"LatestPurchasePrice":0,"OnHand":{4},"OnHandCompareMin":0,"OnHandCompareMax":0,"CompareOnHand":0,"CompareCost":0,"CompareBasePrice":0,"CompareCode":"","CompareUnit":"","Reserved":0,"MinQuantity":0,"MaxQuantity":999999999,"CustomId":0,"CustomValue":0,"MasterProductId":0,"Unit":"","ConversionValue":1,"OrderTemplate":"","IsLotSerialControl":false,"IsRewardPoint":true,"ProductFormulas":[],"Name":"{5}","RewardPoint":{6},"ListPriceBookDetail":[],"ProductImages":[]    ${cat_id}    ${ui_product_code}    ${gia_ban}    ${giavon}
    ...    ${ton}    ${ten_sp}    ${diem_thuong}
    log    ${format_data}
    ${data}    Evaluate    (None, '[{${format_data}}]')
    ${branch_pr_cost}   Set Variable    "Id":${BRANCH_ID},"Name":"Chi nhánh trung tâm"
    ${branch_pr_cost}     Evaluate    (None, '[{${branch_pr_cost}}]')
    ${payload}    Create Dictionary    ListProducts=${data}     BranchForProductCosts=${branch_pr_cost}
    Log    ${payload}
    Post request data form thr API    /products/addmany    ${payload}

Add product by generated info automatically
    [Arguments]    ${ma_hang}
    ${ten_nhom}    Generate Random String    5    [LOWER]
    ${ten_hang}    Generate Random String    5    [LOWER]
    Add categories thr API    ${ten_nhom}
    Add product thr API    ${ma_hang}    ${ten_hang}    ${ten_nhom}    500000    20000    50
    Return From Keyword    ${ten_hang}    ${ten_nhom}

Add category into price book thr API
    [Arguments]    ${ten_bang_gia}    ${nhom_hang}
    ${pricebook_id}    Get price book id    ${ten_bang_gia}
    ${cat_id}   Get category ID    ${nhom_hang}
    ${request_payload}    Format String  {{"CategoryId":{0},"PricebookIds":[{1}]}}    ${cat_id}    ${pricebook_id}
    Log    ${request_payload}
    Post request thr API    /pricebook/addItemsIntoPricebookDetails?kvuniqueparam=2020    ${request_payload}

Add new price book and add category and price formula
    [Arguments]    ${input_ten_banggia}     ${nhom_hang}    ${giamgia}
    Add new bang gia    ${input_ten_banggia}
    Add category into price book thr API    ${input_ten_banggia}      ${nhom_hang}
    Update price formula increase percent thr API      ${input_ten_banggia}    ${giamgia}     true

create serial in live env
    [Arguments]    ${ui_product_code}    ${ten_sp}    ${ten_nhom}    ${gia_ban}    ${gia}    ${serialnums}
    ...    ${total_nums}
    ${get_product_id}    Add imei product thr API    ${ui_product_code}    ${ten_sp}    ${ten_nhom}    ${gia_ban}
    ${get_user_id}    Get User ID
    Import serial numbers    ${get_product_id}    ${ui_product_code}    ${serialnums}    ${total_nums}    ${get_user_id}

create hh lodate
    [Arguments]    ${ui_product_code}    ${tensp}    ${tennhom}    ${giaban}    ${gianhap}    ${sum_soluong}
    ...    ${tenlo}
    ${get_product_id}    Add lodate product thr API    ${ui_product_code}    ${tensp}    ${tennhom}    ${giaban}
    ${get_user_id}    Get User ID
    ${date}    Get Current Date
    ${hsd}=    Add Time To Date    ${date}    30 days
    import Lot for prd    ${get_product_id}    ${sum_soluong}    ${tenlo}    ${hsd}    ${gianhap}    ${get_user_id}
