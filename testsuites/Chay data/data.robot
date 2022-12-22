*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}      ${headless_browser}
Library           Collections
Resource          ../../config/env_product/envi.robot


*** Variables ***

*** Test Cases ***
Them moi kh
    [Tags]
    [Template]    Add category
    270

Them moi hh
    [Tags]
    [Template]   Add multi product
    10000

Invoice                   [Tags]
      [Template]              Add multi invoice
      1

Branch                   [Tags]      RUN
      [Template]              Add multi branch
      59

*** Keyword ***
Add mutil customer
    [Arguments]    ${time}
    Repeat Keyword    ${time}    Add customers basic    An

Add customers basic
    [Arguments]    ${tenkh}
    #${retailer_id}    Get RetailerID
    ${retailer_id}      Set Variable    437336
    ${data_str}    Format String    {{"Customer":{{"BranchId":{0},"IsActive":true,"Type":0,"temploc":"","tempw":"","Code":"","Name":"{1}","ContactNumber":"","Address":"","LocationName":"","WardName":"","CustomerGroupDetails":[],"RetailerId":{2},"Uuid":""}}}}    ${BRANCH_ID}    ${tenkh}    ${retailer_id}
    log    ${data_str}
    ${headers1}=    Create Dictionary    Authorization=${bearertoken}    Content-Type=application/json;charset=utf-8
    Create Session    lolo    ${API_URL}    cookies=${resp.cookies}
    ${resp3}=    Post Request    lolo    /customers    data=${data_str}    headers=${headers1}
    Log    ${resp3.request.body}
    Log    ${resp3.json()}
    log    ${resp3.status_code}
    Should Be Equal As Strings    ${resp3.status_code}    200

Add multi product
    [Arguments]     ${time}
    Repeat Keyword    ${time}    Add product incl 2 units thrAPI    mahh    ten_hh    ten_nhom    giaban    giavon    ton    dvcb    tendv1    gtqd1    giaban1    ma_hh1    tendv2    gtqd2    giaban2    ma_hh2

Add product basic
    [Arguments]       ${ten_sp}    ${ten_nhom}    ${gia_ban}    ${giavon}    ${ton}
    #${cat_id}    Hanghoa.Get category ID    ${ten_nhom}
    #log    ${cat_id}
    ${cat_id}     Set Variable    1412
    ${format_data}    Format String    "Id":0,"ProductType":2,"CategoryId":{0},"CategoryName":"","isActive":false,"VariantCount":0,"AllowsSale":true,"isDeleted":false,"Code":"","BasePrice":{1},"Cost":{2},"LatestPurchasePrice":0,"OnHand":{3},"OnHandCompareMin":0,"OnHandCompareMax":0,"CompareOnHand":0,"CompareCost":0,"CompareBasePrice":0,"CompareCode":"","CompareUnit":"","Reserved":0,"MinQuantity":0,"MaxQuantity":999999999,"CustomId":0,"CustomValue":0,"MasterProductId":0,"Unit":"","ConversionValue":1,"OrderTemplate":"","IsLotSerialControl":false,"IsRewardPoint":false,"ProductFormulas":[],"Name":"{4}","ListPriceBookDetail":[],"ProductImages":[]    ${cat_id}      ${gia_ban}    ${giavon}    ${ton}    ${ten_sp}
    log    ${format_data}
    ${data}    Evaluate    (None, '[{${format_data}}]')
    ${payload}    Create Dictionary    ListProducts=${data}
    Log    ${payload}
    Create Session    lolo    ${API_URL}    cookies=${resp.cookies}    verify=True    debug=1
    ${resp1}=    Post Request    lolo    /products/addmany    files=${payload}
    Log    ${resp1.request.body}
    Log    ${resp1.json()}
    log    ${resp1.status_code}
    Should Be Equal As Strings    ${resp1.status_code}    200
    Log to Console    ${resp1.json()}

Add multi invoice
    [Arguments]       ${time}
    ${list_Uuid_code}   Create List
    :FOR    ${item}     IN RANGE      1
     \    ${Uuid}      Generate Random String    6    [UPPER][NUMBERS]
     \    ${Uuid_code}      Catenate      SEPARATOR=      WA     ${Uuid}
     \    Append To List    ${list_Uuid_code}    ${Uuid_code}
    :FOR      ${Uuid_code}    IN      @{list_Uuid_code}
     \    Add invoice    ${Uuid_code}

Add invoice
    [Arguments]       ${Uuid_code}
    ${request_payload}    Format String    {{"Invoice":{{"BranchId":35,"RetailerId":19,"UpdateInvoiceId":0,"UpdateReturnId":0,"IsChangeNormalToShippingDelivery":false,"CustomerId":93,"SoldById":47,"SoldBy":{{"CreatedBy":0,"CreatedDate":"2020-02-04T08:37:32.677Z","Email":"","GivenName":"anh.lv","Id":47,"IsActive":true,"IsAdmin":true,"Language":"vi-VN","MobilePhone":"","Type":0,"UserName":"admin","isDeleted":false}},"SaleChannelId":0,"SaleChannel":null,"Seller":{{"CreatedBy":0,"CreatedDate":"2020-02-04T08:37:32.677Z","Email":"","GivenName":"anh.lv","Id":47,"IsActive":true,"IsAdmin":true,"Language":"vi-VN","MobilePhone":"","Type":0,"UserName":"admin","isDeleted":false}},"OrderCode":"","Code":"Hóa đơn 1","InvoiceDetails":[{{"BasePrice":1000000,"IsLotSerialControl":false,"IsRewardPoint":false,"Note":"","Price":1000000,"ProductId":35752,"Quantity":1,"ProductCode":"CBBH01","ProductName":"Combo bảo hành1","OriginPrice":1000000,"PriceByPromotion":null,"ProductFormulaHistoryId":297,"PromotionParentProductId":null,"ProductBatchExpireId":null,"CategoryId":4117,"MasterProductId":35752,"Unit":"","Uuid":"W15871072888394"}}],"InvoiceOrderSurcharges":[],"InvoicePromotions":[],"DeliveryDetail":{{"Type":0,"TypeName":"","Status":2,"Address":"121677 HNDOO","ContactNumber":"7777777","Receiver":"Ma ma choco","DeliveryBy":91,"LocationName":"","WardName":"","CustomerId":93,"CustomerCode":"KH009","BranchTakingAddressId":null,"BranchTakingAddressStr":"Hà nội, Phường Trung Hòa, Quận Cầu Giấy, Hà Nội","UsingPriceCod":1,"LastLocation":"","LastWard":"","Width":1,"Height":1,"Length":1,"Weight":500,"UsingOfBilling":false,"Paymenter":0,"PackageType":0,"UseDefaultPartner":false,"ServiceCode":"0","TotalProductPrice":1000000,"ServiceAdd":null,"Price":30000,"DeliveryCode":"","DeliveryStatus":null,"ExpectedDelivery":null,"PartnerCode":"DT00001","PartnerDelivery":{{"Type":0,"Code":"DT00001","ContactNumber":"01689346782","CreatedDate":"2020-02-04T09:02:24.033Z","Id":91,"LocationName":"","Name":"Giao hàng nhanh","PartnerDeliveryGroupDetails":[],"RetailerId":19,"SearchNumber":"01689346782","WardName":"","isActive":true,"isDeleted":false}},"WeightEdited":true,"PartnerName":"","ExpectedDeliveryText":""}},"UsingCod":1,"Payments":[],"Status":3,"Total":1000000,"Surcharge":0,"Type":1,"Uuid":"{0}","addToAccount":"0","addToAccountSurplus":"0","addToAccountAllocation":"0","addToAccountPaymentAllocation":"0","PayingAmount":0,"TotalBeforeDiscount":1000000,"ProductDiscount":0,"DebugUuid":"","InvoiceWarranties":[],"CreatedBy":47}}}}       ${Uuid_code}
    ${request_payload}    Set Variable    ${request_payload}
    ${headers}=    Create Dictionary    Authorization=${bearertoken}    Content-Type=application/json;charset=UTF-8    Retailer=${RETAILER_NAME}    BranchId=${BRANCH_ID}    Zone=${env}
    Create Session    kiotvietapi    ${SALE_API_URL}    cookies=${resp.cookies}    verify=True    debug=1
    ${resp}=    Post Request    kiotvietapi    /invoices/save    data=${request_payload}    headers=${headers}
    Log    ${resp.request.body}
    Log    ${resp.json()}
    Log    ${resp.status_code}
    Should Be Equal As Strings    ${resp.status_code}    200

Add multi branch
    [Arguments]     ${time}
    Repeat Keyword    ${time}    Create new branch

Create new branch
    ${name}      Generate Random String    6    [UPPER][NUMBERS]
    ${input_branch}      Catenate      SEPARATOR=      Chi nhánh     ${name}
    ${input_sdt}      Generate Random String    7    [NUMBERS]
    ${input_sdt}      Catenate      SEPARATOR=      098     ${input_sdt}
    ${data_str}    Format String    {{"Branch":{{"timeSheetBranchSetting":{{"workingDays":[1,2,3,4,5,6,0]}},"temploc":"Hà Nội - Quận Hoàng Mai","tempw":"Phường Đại Kim","Name":"{0}","ContactNumber":"{1}","Address":"1B Yết Kiêu","LocationName":"Hà Nội - Quận Hoàng Mai","WardName":"Phường Đại Kim","LocationId":244,"WardId":109}},"BranchSetting":{{"workingDays":[1,2,3,4,5,6,0]}},"IsAddMore":false,"IsRemove":false,"ApplyFrom":null}}    ${input_branch}      ${input_sdt}
    log    ${data_str}
    ${headers1}=    Create Dictionary    Authorization=${bearertoken}    Content-Type=application/json;charset=utf-8
    Create Session    lolo    https://linhhd99.kvpos.com:59913/api    cookies=${resp.cookies}
    ${resp3}=    Post Request    lolo    /branchs    data=${data_str}    headers=${headers1}
    Log    ${resp3.request.body}
    Log    ${resp3.json()}
    log    ${resp3.status_code}
    Should Be Equal As Strings    ${resp3.status_code}    200

Add product incl 2 units thrAPI
    [Arguments]    ${mahh}    ${ten_hh}    ${giaban}    ${giavon}    ${ton}
    ...    ${dvcb}    ${tendv1}    ${gtqd1}    ${giaban1}    ${ma_hh1}    ${tendv2}
    ...    ${gtqd2}    ${giaban2}    ${ma_hh2}
    Creat new
    Add categories thr API    SPABC
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
    Create Session    lolo    ${API_URL}    cookies=${resp.cookies}    verify=True    debug=1
    Create Dictionary    cookies=${resp.cookies}    verify=True    debug=1
    ${resp1}=    Post Request    lolo    /products/addmany    files=${payload}    #headers=${header}
    Log    ${resp1.request.body}
    Log    ${resp1.json()}
    log    ${resp1.status_code}
    Should Be Equal As Strings    ${resp1.status_code}    200
    Log to Console    ${resp1.json()}

Add category
    [Arguments]     ${time}
    Repeat Keyword    ${time}     Add category thr API    1

Add category thr API
    [Arguments]    ${a}
    ${ten_cat}    Generate Random String    12    [LOWER]
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
    ${headers1}=    Create Dictionary    Authorization=${bearertoken}    Content-Type=application/json;charset=utf-8
    Create Session    lolo    ${API_URL}    cookies=${resp.cookies}
    ${resp2}=    Post Request    lolo    /categories    data=${data_str}    headers=${headers1}
    Log    ${resp2.request.body}
    Log    ${resp2.json()}
    Should Be Equal As Strings    ${resp2.status_code}    200
