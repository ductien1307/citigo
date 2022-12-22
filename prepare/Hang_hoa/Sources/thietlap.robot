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
Resource          ../../../core/API/api_khachhang.robot
Resource          ../../../core/API/api_thietlap.robot
Resource          ../../../core/share/computation.robot
Resource          ../../../core/share/list_dictionary.robot
Library           DateTime
Resource          hanghoa.robot

*** Keywords ***
Create new Surcharge by percentage
    [Arguments]    ${surchage_code}    ${name_surchage}    ${value_ratio}    ${order}    ${autogen}    ${return_autogen}
    ${retailer_id}    Get RetailerID
    ${data_str}    Format String    {{"Surcharge":{{"ForAllBranch":true,"isAuto":{5},"isActive":false,"DiscountType":"%","Code":"{0}","isReturnAuto":{6},"Name":"{1}","ValueRatio":{2},"Order":"{4}","RetailerId":{3},"SurchargeBranches":[]}}}}    ${surchage_code}    ${name_surchage}    ${value_ratio}    ${retailer_id}
    ...    ${order}    ${autogen}    ${return_autogen}
    log    ${data_str}
    Post request thr API    /surcharge     ${data_str}

Create new Surcharge by vnd
    [Arguments]    ${surcharge_code}    ${name_surchage}    ${value}    ${order}    ${autogen}    ${return_autogen}
    ${retailer_id}    Get RetailerID
    ${data_str}    Format String    {{"Surcharge":{{"ForAllBranch":true,"isAuto":{5},"isActive":false,"DiscountType":"VND","Code":"{0}","isReturnAuto":{6},"Name":"{1}","Value":{2},"Order":"{4}","RetailerId":{3},"SurchargeBranches":[]}}}}    ${surcharge_code}    ${name_surchage}    ${value}    ${retailer_id}
    ...    ${order}    ${autogen}    ${return_autogen}
    log    ${data_str}
    Post request thr API    /surcharge     ${data_str}

Create promotion by invoice with discount invoice
    [Arguments]    ${promotion_code}    ${promotion_name}    ${valuevnd}    ${value_percentage}    ${type_discount}    ${invoice_value}
    ${retailer_name}    Get Retailer name
    ${retailer_id}    Get RetailerID
    ${curdatetime}    Get Current Date    result_format=datetime
    ${month}    Evaluate    $curdatetime.month
    ${date}    Evaluate    $curdatetime.day
    ${data_str}    Format String    {{"Campaign":{{"Id":0,"Name":"{2}","IsActive":"0","ApplyMonths":"{6}","ApplyDates":"{7}","Weekday":"","Hour":"","IsGlobal":true,"ForAllUser":true,"ForAllCusGroup":true,"Type":0,"PromotionType":1,"SalePromotions":[{{"Uuid":"","Type":0,"PromotionType":1,"InvoiceValue":{8},"PrereqProductId":null,"PrereqCategoryId":null,"PrereqCategoryIds":null,"PrereqQuantity":null,"PrereqApplySameKind":false,"Discount":{3},"DiscountRatio":{4},"DiscountType":"{5}","ReceivedProductId":null,"ReceivedCategoryId":null,"ReceivedQuantity":null,"ReceivedApplySameKind":false,"ProductDiscount":null,"ProductDiscountRatio":null,"ProductDiscountType":"%","ReceivedVoucherCampaignIds":null,"RetailerId":{0}}}],"StartDate":null,"EndDate":null,"BirthdayTimeType":1,"RetailerId":{0},"InvoiceValueType":1,"selectedBranch":[],"selectedBranchObj":[],"selectedUser":[],"selectedUserObj":[],"selectedCustomerGroup":[],"selectedCustomerGroupObj":[],"Code":"{1}","CampaignBranches":[],"CampaignUsers":[],"CampainCustomerGroups":[]}}}}    ${retailer_id}    ${promotion_code}    ${promotion_name}    ${valuevnd}
    ...    ${value_percentage}    ${type_discount}    ${month}    ${date}    ${invoice_value}
    log    ${data_str}
    Post request by other URL API    ${PROMO_API}    /campaigns     ${data_str}

Create promotion by invoice with give away
        [Arguments]    ${promotion_code}    ${promotion_name}    ${invoice_value}     ${category_name}
        ${category_id}     Get category ID    ${category_name}
        ${retailer_id}    Get RetailerID
        ${retailer_name}    Get Retailer name
        ${curdatetime}    Get Current Date    result_format=datetime
        ${month}    Evaluate    $curdatetime.month
        ${date}    Evaluate    $curdatetime.day
        ${data_str}    Format String    {{"Campaign":{{"Id":0,"Name":"{2}","IsActive":"0","ApplyMonths":"{5}","ApplyDates":"{6}","Weekday":"","Hour":"","IsGlobal":true,"ForAllUser":true,"ForAllCusGroup":true,"Type":0,"PromotionType":2,"SalePromotions":[{{"Uuid":"","Type":0,"PromotionType":2,"InvoiceValue":{3},"PrereqProductId":null,"PrereqCategoryId":null,"PrereqCategoryIds":null,"PrereqQuantity":null,"PrereqApplySameKind":false,"Discount":null,"DiscountRatio":null,"DiscountType":"%","ReceivedProductId":null,"ReceivedCategoryId":{4},"ReceivedQuantity":3,"ReceivedApplySameKind":false,"ProductDiscount":null,"ProductDiscountRatio":null,"ProductDiscountType":"%","ReceivedVoucherCampaignIds":null,"RetailerId":{0},"ReceivedHirenchyCategoryStr":" Dịch vụ","ReceivedProductIds":null,"ReceivedCategoryIds":"{4}","ReceivedEntity":{{"__type":"KiotViet.Web.Api.ProductAndGroup, KiotViet.Web.Api","Id":{4},"Name":"","Code":"","Type":4,"LongName":" Dịch vụ","SubCategoryIds":[{4}],"IsRewardPoint":true,"HasVariants":false,"ProductIds":"","HasRelated":true,"MasterProductIds":[null],"ProductCodes":"","CategoryIds":"{4}"}},"ReceivedProductCodes":null}}],"StartDate":null,"EndDate":null,"BirthdayTimeType":1,"RetailerId":{0},"InvoiceValueType":1,"selectedBranch":[],"selectedBranchObj":[],"selectedUser":[],"selectedUserObj":[],"selectedCustomerGroup":[],"selectedCustomerGroupObj":[],"Code":"{1}","CampaignBranches":[],"CampaignUsers":[],"CampainCustomerGroups":[]}}}}    ${retailer_id}	    ${promotion_code}    	${promotion_name}    ${invoice_value}    ${category_id}     ${month}   ${date}
        log    ${data_str}
        Post request by other URL API    ${PROMO_API}    /campaigns     ${data_str}

Create promotion by invoice with product discount
      [Arguments]    ${promotion_code}    	${promotion_name}    ${invoice_value}    ${quantity}	  ${category_name}     ${discount_product}		${discount_product_ratio}		${discount_type}
      ${category_id}     Get category ID    ${category_name}
      ${retailer_id}    Get RetailerID
      ${retailer_name}    Get Retailer name
      ${curdatetime}    Get Current Date    result_format=datetime
      ${month}    Evaluate    $curdatetime.month
      ${date}    Evaluate    $curdatetime.day
      ${data_str}    Format String    {{"Campaign":{{"Id":0,"Name":"{2}","IsActive":"0","ApplyMonths":"{9}","ApplyDates":"{10}","Weekday":"","Hour":"","IsGlobal":true,"ForAllUser":true,"ForAllCusGroup":true,"Type":0,"PromotionType":3,"SalePromotions":[{{"Uuid":"","Type":0,"PromotionType":3,"InvoiceValue":{3},"PrereqProductId":null,"PrereqCategoryId":null,"PrereqCategoryIds":null,"PrereqQuantity":null,"PrereqApplySameKind":false,"Discount":null,"DiscountRatio":null,"DiscountType":"%","ReceivedProductId":null,"ReceivedCategoryId":{5},"ReceivedQuantity":{4},"ReceivedApplySameKind":false,"ProductDiscount":{6},"ProductDiscountRatio":{7},"ProductDiscountType":"{8}","ReceivedVoucherCampaignIds":null,"RetailerId":{0},"ReceivedHirenchyCategoryStr":" Hạt nhập khẩu","ReceivedProductIds":null,"ReceivedCategoryIds":"{5}","ReceivedEntity":{{"__type":"KiotViet.Web.Api.ProductAndGroup, KiotViet.Web.Api","Id":{5},"Name":"","Code":"","Type":4,"LongName":" Hạt nhập khẩu","SubCategoryIds":[{5}],"IsRewardPoint":true,"HasVariants":false,"ProductIds":"","HasRelated":true,"MasterProductIds":[null],"ProductCodes":"","CategoryIds":"{5}"}},"ReceivedProductCodes":null}}],"StartDate":null,"EndDate":null,"BirthdayTimeType":1,"RetailerId":{0},"InvoiceValueType":1,"selectedBranch":[],"selectedBranchObj":[],"selectedUser":[],"selectedUserObj":[],"selectedCustomerGroup":[],"selectedCustomerGroupObj":[],"Code":"{1}","CampaignBranches":[],"CampaignUsers":[],"CampainCustomerGroups":[]}}}}    ${retailer_id}	    ${promotion_code}    	${promotion_name}    ${invoice_value}    ${quantity}	${category_id}     ${discount_product}		${discount_product_ratio}		    ${discount_type}     ${month}     ${date}
      log    ${data_str}
      Post request by other URL API    ${PROMO_API}    /campaigns     ${data_str}

Create promotion by product with product discount
    [Arguments]    ${promotion_code}    ${promotion_name}    ${promotion_type}    ${num_cat_one}    ${num_cat_two}    ${discount_product_vnd}
    ...    ${discount_product_percentage}    ${discount_type}    ${category_one}    ${category_two}
    ${category_id_one}    Get category ID    ${category_one}
    ${category_id_two}    Get category ID    ${category_two}
    ${retailer_id}    Get RetailerID
    ${retailer_name}    Get Retailer name
    ${curdatetime}    Get Current Date    result_format=datetime
    ${month}    Evaluate    $curdatetime.month
    ${date}    Evaluate    $curdatetime.day
    ${data_str}    Format String    {{"Campaign":{{"Id":0,"Name":"{2}","IsActive":"0","ApplyMonths":"{11}","ApplyDates":"{12}","Weekday":"","Hour":"","IsGlobal":true,"ForAllUser":true,"ForAllCusGroup":true,"Type":1,"PromotionType":{3},"SalePromotions":[{{"Uuid":"","Type":1,"PromotionType":{3},"InvoiceValue":0,"PrereqProductId":null,"PrereqCategoryId":{6},"PrereqCategoryIds":"{6}","PrereqQuantity":{4},"PrereqApplySameKind":false,"Discount":null,"DiscountRatio":null,"DiscountType":"%","ReceivedProductId":null,"ReceivedCategoryId":{7},"ReceivedQuantity":{5},"ReceivedApplySameKind":false,"ProductDiscount":{8},"ProductDiscountRatio":{9},"ProductDiscountType":"{10}","ReceivedVoucherCampaignIds":null,"RetailerId":{0},"PrereqHirenchyCategoryStr":" Hàng mới về","PrereqProductIds":null,"PrereqEntity":{{"__type":"KiotViet.Web.Api.ProductAndGroup, KiotViet.Web.Api","Id":{6},"Name":"","Code":"","Type":4,"LongName":" Hàng mới về","SubCategoryIds":[{6}],"IsRewardPoint":true,"HasVariants":false,"ProductIds":"","HasRelated":true,"MasterProductIds":[null],"ProductCodes":"","CategoryIds":"{6}"}},"PrereqProductCodes":null,"MasterProductIds":null,"CategoryIds":null,"ReceivedHirenchyCategoryStr":" Hoa quả nhập","ReceivedProductIds":null,"ReceivedCategoryIds":"{7}","ReceivedEntity":{{"__type":"KiotViet.Web.Api.ProductAndGroup, KiotViet.Web.Api","Id":{7},"Name":"","Code":"","Type":4,"LongName":" Hoa quả nhập","SubCategoryIds":[{7}],"IsRewardPoint":true,"HasVariants":false,"ProductIds":"","HasRelated":true,"MasterProductIds":[null],"ProductCodes":"","CategoryIds":"{7}"}},"ReceivedProductCodes":null}}],"StartDate":null,"EndDate":null,"BirthdayTimeType":1,"RetailerId":{0},"InvoiceValueType":1,"selectedBranch":[],"selectedBranchObj":[],"selectedUser":[],"selectedUserObj":[],"selectedCustomerGroup":[],"selectedCustomerGroupObj":[],"Code":"{1}","CampaignBranches":[],"CampaignUsers":[],"CampainCustomerGroups":[]}}}}    ${retailer_id}    ${promotion_code}    ${promotion_name}    ${promotion_type}
    ...    ${num_cat_one}    ${num_cat_two}    ${category_id_one}    ${category_id_two}    ${discount_product_vnd}    ${discount_product_percentage}
    ...    ${discount_type}    ${month}    ${date}
    log    ${data_str}
    Post request by other URL API    ${PROMO_API}    /campaigns     ${data_str}

Create promotion by product with baseprice based on quantity
    [Arguments]    ${promotion_code}    ${promotion_name}    ${category_name}    ${quantity}    ${product_price}    ${product_discount}
    ...    ${product_discount_ratio}
    ${category_id}    Get category ID    ${category_name}
    ${retailer_id}    Get RetailerID
    ${retailer_name}    Get Retailer name
    ${curdatetime}    Get Current Date    result_format=datetime
    ${month}    Evaluate    $curdatetime.month
    ${date}    Evaluate    $curdatetime.day
    ${data_str}    Format String    {{"Campaign":{{"Id":0,"Name":"{2}","IsActive":"0","ApplyMonths":"{8}","ApplyDates":"{9}","Weekday":"","Hour":"","IsGlobal":true,"ForAllUser":true,"ForAllCusGroup":true,"Type":1,"PromotionType":8,"SalePromotions":[{{"PrereqProductId":null,"PrereqProductIds":null,"PrereqCategoryId":{3},"PrereqCategoryIds":"{3}","PrereqEntity":{{"__type":"KiotViet.Web.Api.ProductAndGroup, KiotViet.Web.Api","Id":{3},"Name":"","Code":"","Type":4,"LongName":" Thiết bị số - Phụ kiện số","SubCategoryIds":[{3}],"IsRewardPoint":true,"HasVariants":false,"ProductIds":"","HasRelated":true,"MasterProductIds":[null],"ProductCodes":"","CategoryIds":"{3}","Uuid":"15523879619737342"}},"Type":1,"PromotionType":8,"InvoiceValue":0,"PrereqQuantity":{4},"PrereqApplySameKind":false,"ProductPrice":{5},"ProductDiscount":{6},"ProductDiscountRatio":{7},"RetailerId":{0}}}],"StartDate":null,"EndDate":null,"BirthdayTimeType":1,"RetailerId":{0},"InvoiceValueType":1,"selectedBranch":[],"selectedBranchObj":[],"selectedUser":[],"selectedUserObj":[],"selectedCustomerGroup":[],"selectedCustomerGroupObj":[],"Code":"{1}","CampaignBranches":[],"CampaignUsers":[],"CampainCustomerGroups":[]}}}}    ${retailer_id}    ${promotion_code}    ${promotion_name}    ${category_id}
    ...    ${quantity}    ${product_price}    ${product_discount}    ${product_discount_ratio}    ${month}    ${date}
    log    ${data_str}
    Post request by other URL API    ${PROMO_API}    /campaigns     ${data_str}

Create promotion by invoice and product with invoice discount
    [Arguments]    ${promotion_code}    ${promotion_name}    ${category_name}    ${total}    ${invoice_discount}    ${invoice_discount_ratio}      ${discount_type}
     ${category_id}    Get category ID    ${category_name}
     ${retailer_id}    Get RetailerID
     ${retailer_name}    Get Retailer name
     ${curdatetime}    Get Current Date    result_format=datetime
     ${month}    Evaluate    $curdatetime.month
     ${date}    Evaluate    $curdatetime.day
     ${data_str}    Format String    {{"Campaign":{{"Id":0,"Name":"{2}","IsActive":false,"ApplyMonths":"{8}","ApplyDates":"{9}","Weekday":"","Hour":"","IsGlobal":true,"ForAllUser":true,"ForAllCusGroup":true,"Type":2,"PromotionType":15,"SalePromotions":[{{"Uuid":"15719908837449537","Type":2,"PromotionType":15,"InvoiceValue":{4},"PrereqProductId":null,"PrereqCategoryId":{3},"PrereqCategoryIds":"{3}","PrereqQuantity":1,"PrereqApplySameKind":false,"Discount":{5},"DiscountRatio":{6},"DiscountType":"{7}","ReceivedProductId":null,"ReceivedCategoryId":null,"ReceivedQuantity":null,"ReceivedApplySameKind":false,"ProductDiscount":null,"ProductDiscountRatio":null,"ProductDiscountType":"%","ReceivedVoucherCampaignIds":null,"RetailerId":{0},"PrereqHirenchyCategoryStr":" KM HĐ HH","PrereqProductIds":null,"PrereqEntity":{{"__type":"KiotViet.Web.Api.ProductAndGroup, KiotViet.Web.Api","Id":{3},"Name":"","Code":"","Type":4,"LongName":" KM HĐ HH","SubCategoryIds":[{3}],"IsRewardPoint":true,"HasVariants":false,"ProductIds":"","HasRelated":true,"MasterProductIds":[null],"ProductCodes":"","CategoryIds":"{3}","Uuid":"15719908837449537"}},"PrereqProductCodes":null,"MasterProductIds":null,"CategoryIds":null}}],"StartDate":null,"EndDate":null,"BirthdayTimeType":1,"RetailerId":{0},"InvoiceValueType":1,"selectedBranch":[],"selectedBranchObj":[],"selectedUser":[],"selectedUserObj":[],"selectedCustomerGroup":[],"selectedCustomerGroupObj":[],"Code":"{1}","CampaignBranches":[],"CampaignUsers":[],"CampainCustomerGroups":[]}}}}     ${retailer_id}    ${promotion_code}    ${promotion_name}    ${category_id}    ${total}    ${invoice_discount}    ${invoice_discount_ratio}      ${discount_type}    ${month}    ${date}
     log    ${data_str}
     Post request by other URL API    ${PROMO_API}    /campaigns     ${data_str}

Create promotion by invoice and product with giveaway
      [Arguments]    ${promotion_code}    ${promotion_name}   ${total}    ${cat_sale}     ${cat_sale_quan}    ${cat_giveaway}      ${cat_giveaway_quan}
      ${category_id_sale}    Get category ID    ${cat_sale}
      ${category_id_giveaway}         Get category ID    ${cat_giveaway}
      ${retailer_id}    Get RetailerID
      ${retailer_name}    Get Retailer name
      ${curdatetime}    Get Current Date    result_format=datetime
      ${month}    Evaluate    $curdatetime.month
      ${date}    Evaluate    $curdatetime.day
      ${data_str}    Format String    {{"Campaign":{{"Id":0,"Name":"{2}","IsActive":false,"ApplyMonths":"{8}","ApplyDates":"{9}","Weekday":"","Hour":"","IsGlobal":true,"ForAllUser":true,"ForAllCusGroup":true,"Type":2,"PromotionType":16,"SalePromotions":[{{"Uuid":"15719975178195344","Type":2,"PromotionType":16,"InvoiceValue":{3},"PrereqProductId":null,"PrereqCategoryId":{4},"PrereqCategoryIds":"{4}","PrereqQuantity":{5},"PrereqApplySameKind":false,"Discount":null,"DiscountRatio":null,"DiscountType":"%","ReceivedProductId":null,"ReceivedCategoryId":{6},"ReceivedQuantity":{7},"ReceivedApplySameKind":false,"ProductDiscount":null,"ProductDiscountRatio":null,"ProductDiscountType":"%","ReceivedVoucherCampaignIds":null,"RetailerId":{0},"PrereqHirenchyCategoryStr":" KM Hàng mua","PrereqProductIds":null,"PrereqEntity":{{"__type":"KiotViet.Web.Api.ProductAndGroup, KiotViet.Web.Api","Id":{4},"Name":"","Code":"","Type":4,"LongName":" KM Hàng mua","SubCategoryIds":[{4}],"IsRewardPoint":true,"HasVariants":false,"ProductIds":"","HasRelated":true,"MasterProductIds":[null],"ProductCodes":"","CategoryIds":"{4}","Uuid":"15719975178195344"}},"PrereqProductCodes":null,"MasterProductIds":null,"CategoryIds":null,"ReceivedHirenchyCategoryStr":" KM Hàng tặng","ReceivedProductIds":null,"ReceivedCategoryIds":"{6}","ReceivedEntity":{{"__type":"KiotViet.Web.Api.ProductAndGroup, KiotViet.Web.Api","Id":{6},"Name":"","Code":"","Type":4,"LongName":" KM Hàng tặng","SubCategoryIds":[{6}],"IsRewardPoint":true,"HasVariants":false,"ProductIds":"","HasRelated":true,"MasterProductIds":[null],"ProductCodes":"","CategoryIds":"{6}","Uuid":"15719975178195344"}},"ReceivedProductCodes":null}}],"StartDate":null,"EndDate":null,"BirthdayTimeType":1,"RetailerId":{0},"InvoiceValueType":1,"selectedBranch":[],"selectedBranchObj":[],"selectedUser":[],"selectedUserObj":[],"selectedCustomerGroup":[],"selectedCustomerGroupObj":[],"Code":"{1}","CampaignBranches":[],"CampaignUsers":[],"CampainCustomerGroups":[]}}}}     ${retailer_id}    ${promotion_code}    ${promotion_name}    ${total}    ${category_id_sale}      ${cat_sale_quan}        ${category_id_giveaway}       ${cat_giveaway_quan}     ${month}    ${date}
      log    ${data_str}
      Post request by other URL API    ${PROMO_API}    /campaigns     ${data_str}

Create promotion by invoice and product with product discount
    [Arguments]    ${promotion_code}    ${promotion_name}   ${total}    ${cat_sale}     ${cat_sale_quan}    ${cat_giveaway}      ${cat_giveaway_quan}       ${product_discount}       ${product_discount_ratio}       ${product_discount_type}
    ${category_id_sale}    Get category ID    ${cat_sale}
    ${category_id_giveaway}         Get category ID    ${cat_giveaway}
    ${retailer_id}    Get RetailerID
    ${retailer_name}    Get Retailer name
    ${curdatetime}    Get Current Date    result_format=datetime
    ${month}    Evaluate    $curdatetime.month
    ${date}    Evaluate    $curdatetime.day
    ${data_str}    Format String    {{"Campaign":{{"Id":0,"Name":"{2}","IsActive":"0","ApplyMonths":"{11}","ApplyDates":"{12}","Weekday":"","Hour":"","IsGlobal":true,"ForAllUser":true,"ForAllCusGroup":true,"Type":2,"PromotionType":17,"SalePromotions":[{{"Uuid":"15719983304796762","Type":2,"PromotionType":17,"InvoiceValue":{3},"PrereqProductId":null,"PrereqCategoryId":{4},"PrereqCategoryIds":"{4}","PrereqQuantity":{5},"PrereqApplySameKind":false,"Discount":null,"DiscountRatio":null,"DiscountType":"%","ReceivedProductId":null,"ReceivedCategoryId":{9},"ReceivedQuantity":{10},"ReceivedApplySameKind":false,"ProductDiscount":{6},"ProductDiscountRatio":{7},"ProductDiscountType":"{8}","ReceivedVoucherCampaignIds":null,"RetailerId":{0},"PrereqHirenchyCategoryStr":" KM Hàng mua","PrereqProductIds":null,"PrereqEntity":{{"__type":"KiotViet.Web.Api.ProductAndGroup, KiotViet.Web.Api","Id":{4},"Name":"","Code":"","Type":4,"LongName":" KM Hàng mua","SubCategoryIds":[{4}],"IsRewardPoint":true,"HasVariants":false,"ProductIds":"","HasRelated":true,"MasterProductIds":[null],"ProductCodes":"","CategoryIds":"{4}","Uuid":"15719983304796762"}},"PrereqProductCodes":null,"MasterProductIds":null,"CategoryIds":null,"ReceivedHirenchyCategoryStr":" KM Hàng tặng","ReceivedProductIds":null,"ReceivedCategoryIds":"{9}","ReceivedEntity":{{"__type":"KiotViet.Web.Api.ProductAndGroup, KiotViet.Web.Api","Id":{9},"Name":"","Code":"","Type":4,"LongName":" KM Hàng tặng","SubCategoryIds":[{9}],"IsRewardPoint":true,"HasVariants":false,"ProductIds":"","HasRelated":true,"MasterProductIds":[null],"ProductCodes":"","CategoryIds":"{9}","Uuid":"15719983304796762"}},"ReceivedProductCodes":null}}],"StartDate":null,"EndDate":null,"BirthdayTimeType":1,"RetailerId":{0},"InvoiceValueType":1,"selectedBranch":[],"selectedBranchObj":[],"selectedUser":[],"selectedUserObj":[],"selectedCustomerGroup":[],"selectedCustomerGroupObj":[],"Code":"{1}","CampaignBranches":[],"CampaignUsers":[],"CampainCustomerGroups":[]}}}}     ${retailer_id}    ${promotion_code}    ${promotion_name}    ${total}    ${category_id_sale}      ${cat_sale_quan}        ${product_discount}       ${product_discount_ratio}      ${product_discount_type}        ${category_id_giveaway}       ${cat_giveaway_quan}     ${month}    ${date}
    log    ${data_str}
    Post request by other URL API    ${PROMO_API}    /campaigns     ${data_str}

Create promotion by invoice and product with product discount and auto fill
    [Arguments]    ${promotion_code}    ${promotion_name}   ${total}    ${cat_sale}     ${cat_sale_quan}    ${cat_giveaway}      ${cat_giveaway_quan}       ${product_discount}       ${product_discount_ratio}       ${product_discount_type}
    ${category_id_sale}    Get category ID    ${cat_sale}
    ${category_id_giveaway}         Get category ID    ${cat_giveaway}
    ${retailer_id}    Get RetailerID
    ${curdatetime}    Get Current Date    result_format=datetime
    ${month}    Evaluate    $curdatetime.month
    ${date}    Evaluate    $curdatetime.day
    ${data_str}    Format String    {{"Campaign":{{"Id":0,"Name":"{0}","IsActive":false,"ApplyMonths":"{1}","ApplyDates":"{2}","Weekday":"","Hour":"","IsGlobal":true,"ForAllUser":true,"ForAllCusGroup":true,"Type":2,"PromotionType":17,"SalePromotions":[{{"Uuid":"","Type":2,"PromotionType":17,"InvoiceValue":{3},"PrereqProductId":null,"PrereqCategoryId":{4},"PrereqCategoryIds":"{4}","PrereqQuantity":{5},"PrereqApplySameKind":false,"Discount":null,"DiscountRatio":null,"DiscountType":"%","ReceivedCategoryId":{6},"ReceivedQuantity":{7},"ReceivedApplySameKind":false,"ProductDiscount":{8},"ProductDiscountRatio":{9},"ProductDiscountType":"{10}","ReceivedVoucherCampaignIds":null,"RetailerId":{11},"GiftIsBuyProduct":true,"PrereqHirenchyCategoryStr":"sản phẩm bất kỳ trong mọi nhóm hàng","PrereqProductIds":null,"PrereqEntity":{{"Type":4,"GiftIsBuyProduct":true,"conditionUuid":"","CategoryIds":[{4}],"HasVariants":false,"ProductIds":"","HasRelated":false,"MasterProductIds":[],"ProductCodes":"","Id":{4},"Name":"Tất cả nhóm hàng","Uuid":""}},"PrereqProductCodes":null,"MasterProductIds":null,"CategoryIds":null,"ReceivedProductIds":"","ReceivedCategoryIds":"{6}","ReceivedEntity":{{"HasVariants":false,"ProductIds":"","HasRelated":false,"MasterProductIds":[],"ProductCodes":"","GiftIsBuyProduct":true,"CategoryIds":"{6}","Uuid":""}}}}],"StartDate":"","EndDate":"","BirthdayTimeType":1,"RetailerId":{11},"InvoiceValueType":1,"selectedBranch":[],"selectedBranchObj":[],"selectedUser":[],"selectedUserObj":[],"selectedCustomerGroup":[],"selectedCustomerGroupObj":[],"Code":"{12}","CampaignBranches":[],"CampaignUsers":[],"CampainCustomerGroups":[]}}}}    ${promotion_name}     ${month}    ${date}    ${total}      ${category_id_sale}      ${cat_sale_quan}        ${category_id_giveaway}       ${cat_giveaway_quan}
    ...        ${product_discount}       ${product_discount_ratio}      ${product_discount_type}    ${retailer_id}    ${promotion_code}
    log    ${data_str}
    Post request by other URL API    ${PROMO_API}    /campaigns     ${data_str}

Create voucher issue
    [Arguments]    ${voucher_code}    ${voucher_name}    ${value}    ${totalsale}
    ${retailer_id}    Get RetailerID
    ${getcurrentdate}    Get Current Date
    ${enddate}    Add Time To Date    ${getcurrentdate}    365 days
    ${data_str}    Format String    {{"VoucherCampaign":{{"Id":0,"Name":"{1}","IsActive":true,"HasVoucherUsed":false,"IsGlobal":true,"ForAllUser":true,"ForAllCusGroup":true,"StartDate":"{5}","EndDate":"{6}","ExpireTimeType":1,"ApplyTimeType":1,"RetailerId":{4},"selectedBranch":[],"selectedBranchObj":[],"selectedUser":[],"selectedUserObj":[],"selectedCustomerGroup":[],"selectedCustomerGroupObj":[],"PrereqProductIds":"","PrereqCategoryIds":"0","Code":"{0}","PrereqPrice":{3},"Price":{2},"VoucherBranchs":[],"VoucherUsers":[],"VoucherCustomerGroups":[]}}}}    ${voucher_code}    ${voucher_name}    ${value}    ${totalsale}
    ...    ${retailer_id}    ${getcurrentdate}    ${enddate}
    log    ${data_str}
    Post request thr API    /voucherCampaign    ${data_str}

Create new Supplier's charge by vnd
    [Arguments]    ${code}    ${name}    ${value}    ${autogen}    ${return_autogen}
    ${retailer_id}    Get RetailerID
    ${data_str}    Format String    {{"ExpensesOther":{{"ForAllBranch":true,"isAuto":{0},"isActive":true,"DiscountType":"VND","IsForBranch":true,"Form":0,"selectedBranch":[],"Code":"{1}","Name":"{2}","Value":{3},"isReturnAuto":{4},"RetailerId":{5},"ExpensesOtherBranches":[]}}}}    ${autogen}    ${code}    ${name}    ${value}
    ...    ${return_autogen}    ${retailer_id}
    log    ${data_str}
    Post request thr API    /expensesOther    ${data_str}

Create new Supplier's charge by percentage
    [Arguments]    ${code}    ${name}    ${value}    ${autogen}    ${return_autogen}
    ${retailer_id}    Get RetailerID
    ${data_str}    Format String    {{"ExpensesOther":{{"ForAllBranch":true,"isAuto":{0},"isActive":true,"DiscountType":"%","IsForBranch":true,"Form":0,"selectedBranch":[],"Code":"{1}","Name":"{2}","ValueRatio":{3},"isReturnAuto":{4},"RetailerId":{5},"ExpensesOtherBranches":[]}}}}    ${autogen}    ${code}    ${name}    ${value}
    ...    ${return_autogen}    ${retailer_id}
    log    ${data_str}
    Post request thr API    /expensesOther    ${data_str}

Create new Other charge by vnd
    [Arguments]    ${code}    ${name}    ${value}    ${autogen}
    ${retailer_id}    Get RetailerID
    ${data_str}    Format String    {{"ExpensesOther":{{"ForAllBranch":true,"isAuto":{0},"isActive":true,"DiscountType":"VND","IsForBranch":true,"Form":1,"selectedBranch":[],"Code":"{1}","Name":"{2}","Value":{3},"isReturnAuto":false,"RetailerId":{4},"ExpensesOtherBranches":[]}}}}    ${autogen}    ${code}    ${name}    ${value}
    ...    ${retailer_id}
    log    ${data_str}
    Post request thr API    /expensesOther    ${data_str}

Create new Other charge by percentage
    [Arguments]    ${code}    ${name}    ${value}    ${autogen}
    ${retailer_id}    Get RetailerID
    ${data_str}    Format String    {{"ExpensesOther":{{"ForAllBranch":true,"isAuto":{0},"isActive":true,"DiscountType":"%","IsForBranch":true,"Form":1,"selectedBranch":[],"Code":"{1}","Name":"{2}","ValueRatio":{3},"isReturnAuto":false,"RetailerId":{4},"ExpensesOtherBranches":[]}}}}    ${autogen}    ${code}    ${name}    ${value}
    ...    ${retailer_id}
    log    ${data_str}
    Post request thr API    /expensesOther    ${data_str}

Create new user
    [Arguments]    ${ten_ng_dung}    ${ten_dang_nhap}    ${mat_khau}    ${sdt}      ${vai_tro}
    ${get_role_id}    Get role id by role name    ${vai_tro}
    ${data_str}    Format String    {{"User":{{"IsActive":true,"temploc":"","tempw":"","IsShowSumRow":true,"GivenName":"{0}","UserName":"{1}","PlainPassword":"{2}","RetypePassword":"{2}","MobilePhone":"{3}","LocationName":"","WardName":"","Permissions":[{{"RoleId":"{4}","BranchId":{5}}}]}}}}    ${ten_ng_dung}    ${ten_dang_nhap}    ${mat_khau}    ${sdt}
    ...    ${get_role_id}    ${BRANCH_ID}
    log    ${data_str}
    Post request thr API    /users   ${data_str}

Create new role full permissions
    [Arguments]   ${ten_quyen}
    ${payload}      Format String    {{"Role":{{"Id":0,"Name":"{0}","isActive":true}},"Rights":["PosParameter_Update","PrintTemplate_Read","PrintTemplate_Update","User_Read","User_Create","User_Update","User_Delete","User_Export","Branch_Read","Branch_Create","Branch_Update","Branch_Delete","Surcharge_Read","Surcharge_Create","Surcharge_Update","Surcharge_Delete","ExpensesOther_Read","ExpensesOther_Create","ExpensesOther_Update","ExpensesOther_Delete","SmsEmailTemplate_Read","SmsEmailTemplate_Create","SmsEmailTemplate_Update","SmsEmailTemplate_Delete","SmsEmailTemplate_SendSMS","SmsEmailTemplate_SendEmail","SmsEmailTemplate_SendZalo","AuditTrail_Read","DashBoard_Read","Customer_Read","Customer_Create","Customer_Update","Customer_Delete","Customer_ViewPhone","Customer_Import","Customer_Export","Customer_UpdateGroup","CustomerAdjustment_Read","CustomerAdjustment_Create","CustomerAdjustment_Update","CustomerAdjustment_Delete","Payment_Create","Payment_Delete","Payment_Update","CustomerPointAdjustment_Read","CustomerPointAdjustment_Update","Supplier_Read","Supplier_Create","Supplier_Update","Supplier_Delete","Supplier_MobilePhone","Supplier_Import","Supplier_Export","SupplierAdjustment_Read","SupplierAdjustment_Create","SupplierAdjustment_Update","SupplierAdjustment_Delete","PurchasePayment_Create","PurchasePayment_Delete","PurchasePayment_Update","PartnerDelivery_Read","PartnerDelivery_Create","PartnerDelivery_Update","PartnerDelivery_Delete","PartnerDelivery_Import","PartnerDelivery_Export","DeliveryAdjustment_Read","DeliveryAdjustment_Create","DeliveryAdjustment_Update","DeliveryAdjustment_Delete","Campaign_Read","Campaign_Create","Campaign_Update","Campaign_Delete","VoucherCampaign_Read","VoucherCampaign_Create","VoucherCampaign_Update","VoucherCampaign_Delete","VoucherCampaign_Release","FinancialReport_SalePerformanceReport","SaleChannelReport_ByProduct","SaleChannelReport_ByProfit","SaleChannelReport_BySale","UserReport_ByProfitReport","UserReport_ByUserReport","UserReport_BySaleReport","SupplierReport_BigByLiabilitiesReport","SupplierReport_SupplierInforReport","SupplierReport_PurchaseOrderReport","CustomerReport_BigCustomerDebt","CustomerReport_CustomerProduct","CustomerReport_CustomerSale","CustomerReport_CustomerProfit","ProductReport_ProducStockInOutStock","ProductReport_ProductByBatchExpire","ProductReport_ProductByCustomer","ProductReport_ProductByDamageItem","ProductReport_ProductBySupplier","ProductReport_ProductByUser","ProductReport_ProducInOutStock","ProductReport_ProducInOutStockDetail","ProductReport_ProductByProfit","ProductReport_ProductBySale","OrderReport_ByDocReport","OrderReport_ByProductReport","SaleReport_SaleByUser","SaleReport_SaleProfitByInvoice","SaleReport_SaleDiscountByInvoice","SaleReport_SaleByRefund","SaleReport_SaleByTime","SaleReport_BranchSaleReport","EndOfDayReport_EndOfDaySynthetic","EndOfDayReport_EndOfDayProduct","EndOfDayReport_EndOfDayCashFlow","EndOfDayReport_EndOfDayDocument","CashFlow_Read","CashFlow_Create","CashFlow_Update","CashFlow_Delete","CashFlow_Export","DamageItem_Read","DamageItem_Create","DamageItem_Update","DamageItem_Delete","DamageItem_Clone","DamageItem_Export","Transfer_Read","Transfer_Create","Transfer_Update","Transfer_Delete","Transfer_Export","Transfer_Clone","Transfer_Import","PurchaseReturn_Read","PurchaseReturn_Create","PurchaseReturn_Update","PurchaseReturn_Delete","PurchaseReturn_Clone","PurchaseOrder_Read","PurchaseOrder_Create","PurchaseOrder_Update","PurchaseOrder_Delete","PurchaseOrder_UpdatePurchaseOrder","PurchaseOrder_Export","PurchaseOrder_Clone","WarrantyOrder_Read","WarrantyOrder_Create","WarrantyOrder_Update","WarrantyOrder_Delete","WarrantyOrder_Print","WarrantyOrder_Export","WarrantyOrder_CreateInvoice","WarrantyOrder_UpdateExpire","WarrantyOrder_ViewPrice","WarrantyRepairingProduct_Read","WarrantyRepairingProduct_Update","OrderSupplier_Read","OrderSupplier_Create","OrderSupplier_Update","OrderSupplier_Delete","OrderSupplier_RepeatPrint","OrderSupplier_Export","OrderSupplier_MakePurchase","OrderSupplier_Clone","Return_Read","Return_Create","Return_Update","Return_Delete","Return_RepeatPrint","Return_CopyReturn","Return_Export","Invoice_Read","Invoice_Create","Invoice_Update","Invoice_Delete","Invoice_Export","Invoice_ReadOnHand","Invoice_ChangePrice","Invoice_ChangeDiscount","Invoice_ModifySeller","Invoice_UpdateCompleted","Invoice_RepeatPrint","Invoice_CopyInvoice","Invoice_UpdateWarranty","Order_Read","Order_Create","Order_Update","Order_Delete","Order_RepeatPrint","Order_Export","Order_MakeInvoice","Order_CopyOrder","Order_UpdateWarranty","Manufacturing_Read","Manufacturing_Create","Manufacturing_Update","Manufacturing_Delete","Manufacturing_Export","WarrantyProduct_Read","WarrantyProduct_Update","WarrantyProduct_Export","StockTake_Read","StockTake_Create","StockTake_Delete","StockTake_Export","StockTake_Inventory","StockTake_Clone","StockTake_Finish","PriceBook_Read","PriceBook_Create","PriceBook_Update","PriceBook_Delete","PriceBook_Import","PriceBook_Export","Product_Read","Product_Create","Product_Update","Product_Delete","Product_PurchasePrice","Product_Cost","Product_Import","Product_Export"],"UpdateAllUser":false}}    ${ten_quyen}
    Post request thr API    /roles   ${payload}

Create new user by role
    [Arguments]    ${ten_dang_nhap}    ${mat_khau}    ${role_name}
    ${get_role_id}    Get role id by role name    ${role_name}
    ${get_branch_id_nhanh_a}    Get BranchID by BranchName    Nhánh A
    ${data_str}    Format String    {{"User":{{"IsActive":true,"temploc":"","tempw":"","IsShowSumRow":true,"Language":"vi-VN","GivenName":"{0}","UserName":"{0}","PlainPassword":"{1}","RetypePassword":"{1}","LocationName":"","WardName":"","Permissions":[{{"RoleId":"{2}","BranchId":{3}}},{{"RoleId":"{2}","BranchId":{4}}}]}},"IncludeAllBranch":true,"Branches":[{{"Id":{3},"Name":"Chi nhánh trung tâm"}},{{"Id":{4},"Name":"Nhánh A"}}]}}    ${ten_dang_nhap}    ${mat_khau}     ${get_role_id}      ${BRANCH_ID}      ${get_branch_id_nhanh_a}
    log    ${data_str}
    Post request thr API    /users   ${data_str}

Create basic role
    [Arguments]   ${ten_quyen}
    ${payload_quantri}      Set Variable    {"Role":{"Id":0,"Name":"Quản trị chi nhánh","isActive":true},"Rights":["PrintTemplate_Read","PrintTemplate_Update","User_Read","User_Create","User_Update","User_Delete","Branch_Read","DashBoard_Read","Payment_Create","Payment_Delete","Payment_Update","CustomerPointAdjustment_Read","CustomerPointAdjustment_Update","Customer_Read","Customer_Create","Customer_Update","Customer_Delete","Customer_ViewPhone","Customer_UpdateGroup","CustomerAdjustment_Read","CustomerAdjustment_Create","Supplier_Read","Supplier_Create","Supplier_Update","Supplier_Delete","SupplierAdjustment_Read","SupplierAdjustment_Create","PurchasePayment_Create","PurchasePayment_Update","Product_Read","Product_Create","Product_Update","Product_Delete","Product_Cost","Product_Import","PriceBook_Read","PriceBook_Create","PriceBook_Update","PriceBook_Delete","StockTake_Read","StockTake_Create","StockTake_Delete","StockTake_Export","StockTake_Inventory","StockTake_Finish","EndOfDayReport_EndOfDaySynthetic","SaleReport_SaleByUser","SaleReport_SaleByTime","ProductReport_ProductBySupplier","ProductReport_ProducInOutStock","ProductReport_ProducInOutStockDetail","ProductReport_ProductByProfit","ProductReport_ProductBySale","Order_Read","Order_Create","Order_Update","Order_Delete","Invoice_Read","Invoice_Create","Invoice_Update","Invoice_Delete","Invoice_ReadOnHand","Invoice_ChangeDiscount","Return_Read","Return_Create","Return_Update","Return_Delete","PurchaseOrder_Read","PurchaseOrder_Create","PurchaseOrder_Update","PurchaseOrder_Delete","PurchaseReturn_Read","PurchaseReturn_Create","PurchaseReturn_Update","PurchaseReturn_Delete","Transfer_Read","Transfer_Create","Transfer_Update","Transfer_Delete","CashFlow_Read","CashFlow_Create","CashFlow_Update","CashFlow_Delete"],"UpdateAllUser":false}
    ${payload_kho}    Set Variable    {"Role":{"Id":0,"Name":"Nhân viên kho","isActive":true},"Rights":["Product_Read","Product_Create","Product_Update","Product_Delete","Product_Cost","Product_Import","PriceBook_Read","PriceBook_Create","PriceBook_Update","PriceBook_Delete","StockTake_Read","StockTake_Create","StockTake_Export","StockTake_Inventory","StockTake_Finish","PurchaseOrder_Read","PurchaseOrder_Create","PurchaseOrder_Update","PurchaseOrder_Delete","PurchaseReturn_Read","PurchaseReturn_Create","PurchaseReturn_Update","PurchaseReturn_Delete","Transfer_Read","Transfer_Create","Transfer_Update","Transfer_Delete","Supplier_Read","Supplier_Create","Supplier_Update","Supplier_Delete","SupplierAdjustment_Read","SupplierAdjustment_Create","PurchasePayment_Create","PurchasePayment_Delete","PurchasePayment_Update"],"UpdateAllUser":false}
    ${payload_thungan}    Set Variable    {"Role":{"Id":0,"Name":"Nhân viên thu ngân","isActive":true},"Rights":["Order_Read","Order_Create","Order_Update","Order_Delete","Invoice_Read","Invoice_Create","Invoice_Update","Invoice_Delete","Invoice_ReadOnHand","Return_Read","Return_Create","Return_Update","Customer_Delete","Customer_Update","Customer_Create","Customer_Read","Customer_ViewPhone","CustomerAdjustment_Read","CustomerAdjustment_Create","Payment_Create","Payment_Delete","Payment_Update","CustomerPointAdjustment_Read"],"UpdateAllUser":false}
    ${payload}      Run Keyword If        '${ten_quyen}'=='Quản trị chi nhánh'    Set Variable    ${payload_quantri}   ELSE IF    '${ten_quyen}'=='Nhân viên kho'     Set Variable    ${payload_kho}    ELSE     Set Variable    ${payload_thungan}
    Post request thr API    /roles   ${payload}

Create promotion by invoice with discount invoice and not for all branch
    [Arguments]    ${promotion_code}    ${promotion_name}    ${valuevnd}    ${value_percentage}    ${type_discount}    ${invoice_value}   ${input_branch}
    ${retailer_name}    Get Retailer name
    ${retailer_id}    Get RetailerID
    ${get_branch_id}    Get BranchID by BranchName    ${input_branch}
    ${curdatetime}    Get Current Date    result_format=datetime
    ${month}    Evaluate    $curdatetime.month
    ${date}    Evaluate    $curdatetime.day
    ${data_str}    Format String    {{"Campaign":{{"Id":0,"Name":"{0}","IsActive":"0","ApplyMonths":"{1}","ApplyDates":"{2}","Weekday":"","Hour":"","IsGlobal":false,"ForAllUser":true,"ForAllCusGroup":true,"Type":0,"PromotionType":1,"SalePromotions":[{{"Uuid":"","Type":0,"PromotionType":1,"InvoiceValue":{3},"PrereqProductId":null,"PrereqCategoryId":null,"PrereqCategoryIds":null,"PrereqQuantity":null,"PrereqApplySameKind":false,"Discount":{4},"DiscountRatio":{5},"DiscountType":"{6}","ReceivedProductId":null,"ReceivedCategoryId":null,"ReceivedQuantity":null,"ReceivedApplySameKind":false,"ProductDiscount":null,"ProductDiscountRatio":null,"ProductDiscountType":"%","ReceivedVoucherCampaignIds":null,"RetailerId":{7},"GiftIsBuyProduct":false}}],"StartDate":null,"EndDate":null,"BirthdayTimeType":1,"RetailerId":{7},"InvoiceValueType":1,"selectedBranch":[{8}],"selectedBranchObj":[{{"Id":{8},"Name":"Nhánh A","Type":0,"Address":"22A Hai Bà Trưng","Province":"Hà Nội","District":"Quận Hoàn Kiếm","ContactNumber":"0987654321","IsActive":true,"RetailerId":{7},"CreatedBy":201567,"LimitAccess":false,"LocationName":"Hà Nội - Quận Hoàn Kiếm","WardName":"","isAcceptBookClosing":false,"GmbStatus":1,"Orders":[],"Transfers1":[],"DamageItems":[],"SurchargeBranches":[],"AdrApplications":[],"Customers":[],"Suppliers":[],"ExpensesOtherBranches":[],"OrderSuppliers":[],"WarrantyBranchGroups":[],"BranchTakingAddresses":[],"Patients":[],"Clinics":[],"Doctors":[],"DoctorQualifications":[],"DoctorSpecialities":[],"Prescriptions":[],"PayslipPayments":[],"PayslipPaymentAllocations":[],"IdOld":0,"TotalUser":0,"CompareBranchName":"Nhánh A","StatusGmbValue":"Chưa đăng ký","IsTimeSheetException":false}}],"selectedUser":[],"selectedUserObj":[],"selectedCustomerGroup":[],"selectedCustomerGroupObj":[],"Code":"{9}","CampaignBranches":[{{"BranchId":{8},"BranchName":"Nhánh A"}}],"CampaignUsers":[],"CampainCustomerGroups":[]}}}}    ${promotion_name}    ${month}    ${date}    ${invoice_value}    ${valuevnd}
    ...    ${value_percentage}    ${type_discount}    ${retailer_id}    ${get_branch_id}    ${promotion_code}
    log    ${data_str}
    Post request by other URL API    ${PROMO_API}    /campaigns     ${data_str}

Create promotion by product with baseprice based on quantity and not for all user
    [Arguments]    ${promotion_code}    ${promotion_name}    ${category_name}    ${quantity}    ${product_price}   ${input_username}
    ${category_id}    Get category ID    ${category_name}
    ${retailer_id}    Get RetailerID
    ${retailer_name}    Get Retailer name
    ${get_user_id}   Get User ID by UserName    ${input_username}
    ${curdatetime}    Get Current Date    result_format=datetime
    ${month}    Evaluate    $curdatetime.month
    ${date}    Evaluate    $curdatetime.day
    ${data_str}    Format String    {{"Campaign":{{"Id":0,"Name":"{0}","IsActive":"0","ApplyMonths":"{1}","ApplyDates":"{2}","Weekday":"","Hour":"","IsGlobal":true,"ForAllUser":false,"ForAllCusGroup":true,"Type":1,"PromotionType":8,"SalePromotions":[{{"PrereqProductId":null,"PrereqProductIds":null,"PrereqCategoryId":{3},"PrereqCategoryIds":"{3}","PrereqEntity":{{"__type":"KiotViet.Web.Api.ProductAndGroup, KiotViet.Web.Api","Id":{3},"Name":"Nhóm:KM hàng","Code":"","Type":4,"LongName":" KM hàng","SubCategoryIds":[{3}],"IsRewardPoint":true,"HasVariants":false,"ProductIds":"","HasRelated":true,"MasterProductIds":[null],"ProductCodes":"","CategoryIds":"{3}","Uuid":""}},"Type":1,"PromotionType":8,"InvoiceValue":0,"PrereqQuantity":{4},"PrereqApplySameKind":false,"ProductPrice":{5},"ProductDiscount":null,"ProductDiscountRatio":null,"RetailerId":{6}}}],"StartDate":null,"EndDate":null,"BirthdayTimeType":1,"RetailerId":{6},"InvoiceValueType":1,"selectedBranch":[],"selectedBranchObj":[],"selectedUser":[{7}],"selectedUserObj":[{{"IdOld":0,"CompareGivenName":"tester","CompareIsLimitedByTrans":false,"CompareIsShowSumRow":true,"IsTimeSheetException":false,"Id":{7},"GivenName":"tester","CreatedDate":"2020-01-13T10:50:17.3700000+07:00","IsActive":true,"IsAdmin":false,"RetailerId":{6},"Type":0,"CreatedBy":438680,"CanAccessAnySite":false,"IsShowSumRow":true,"isDeleted":false,"Permissions":[],"Apps":[],"Invoices":[],"Transfers1":[],"PriceBookUsers":[],"CashFlows":[],"Invoices1":[],"Orders":[],"Returns1":[],"Manufacturings":[],"DamageItems":[],"TokenApis":[],"SmsEmailTemplates":[],"BalanceAdjustments1":[],"PointAdjustments":[],"PointAdjustmentsCreatedBy":[],"NotificationSettings":[],"DamageItems1":[],"PurchaseOrders1":[],"PurchaseReturns1":[],"CostAdjustments":[],"Devices":[],"OrderSuppliers":[],"OrderSuppliers1":[],"UserDevices":[],"PayslipPayments":[],"PayslipPaymentAllocations":[]}}],"selectedCustomerGroup":[],"selectedCustomerGroupObj":[],"Code":"{8}","CampaignBranches":[],"CampaignUsers":[{{"UserId":{7},"GivenName":"tester"}}],"CampainCustomerGroups":[]}}}}      ${promotion_name}    ${month}    ${date}    ${category_id}
    ...    ${quantity}    ${product_price}    ${retailer_id}    ${get_user_id}    ${promotion_code}
    log    ${data_str}
    Post request by other URL API    ${PROMO_API}    /campaigns     ${data_str}

Create promotion by invoice and product with giveaway and not for all customers
      [Arguments]    ${promotion_code}    ${promotion_name}   ${total}    ${cat_sale}     ${cat_sale_quan}    ${cat_giveaway}
      ...      ${cat_giveaway_quan}   ${group_customer_name}
      ${category_id_sale}    Get category ID    ${cat_sale}
      ${category_id_giveaway}    Get category ID    ${cat_giveaway}
      ${retailer_id}    Get RetailerID
      ${retailer_name}    Get Retailer name
      ${get_cus_group_id}   Get Customer Group ID by Customer Name    ${group_customer_name}
      ${curdatetime}    Get Current Date    result_format=datetime
      ${month}    Evaluate    $curdatetime.month
      ${date}    Evaluate    $curdatetime.day
      ${data_str}    Format String    {{"Campaign":{{"Id":0,"Name":"{0}","IsActive":"0","ApplyMonths":"{1}","ApplyDates":"{2}","Weekday":"","Hour":"","IsGlobal":true,"ForAllUser":true,"ForAllCusGroup":false,"Type":2,"PromotionType":16,"SalePromotions":[{{"Uuid":"","Type":2,"PromotionType":16,"InvoiceValue":{3},"PrereqProductId":null,"PrereqCategoryId":{4},"PrereqCategoryIds":"{4}","PrereqQuantity":{5},"PrereqApplySameKind":false,"Discount":null,"DiscountRatio":null,"DiscountType":"%","ReceivedProductId":null,"ReceivedCategoryId":{6},"ReceivedQuantity":{7},"ReceivedApplySameKind":false,"ProductDiscount":null,"ProductDiscountRatio":null,"ProductDiscountType":"%","ReceivedVoucherCampaignIds":null,"RetailerId":{8},"PrereqHirenchyCategoryStr":" Dịch vụ","PrereqProductIds":null,"PrereqEntity":{{"__type":"KiotViet.Web.Api.ProductAndGroup, KiotViet.Web.Api","Id":{4},"Name":"Nhóm:Dịch vụ","Code":"","Type":4,"LongName":"Dịch vụ","SubCategoryIds":[{4}],"IsRewardPoint":true,"HasVariants":false,"ProductIds":"","HasRelated":true,"MasterProductIds":[null],"ProductCodes":"","CategoryIds":"{4}","Uuid":""}},"PrereqProductCodes":null,"MasterProductIds":null,"CategoryIds":null,"ReceivedHirenchyCategoryStr":" Bánh nhập KM","ReceivedProductIds":null,"ReceivedCategoryIds":"{6}","ReceivedEntity":{{"__type":"KiotViet.Web.Api.ProductAndGroup, KiotViet.Web.Api","Id":{6},"Name":"Nhóm:Bánh nhập KM","Code":"","Type":4,"LongName":"Bánh nhập KM","SubCategoryIds":[{6}],"IsRewardPoint":true,"HasVariants":false,"ProductIds":"","HasRelated":true,"MasterProductIds":[null],"ProductCodes":"","CategoryIds":"{6}","Uuid":""}},"ReceivedProductCodes":null}}],"StartDate":null,"EndDate":null,"BirthdayTimeType":1,"RetailerId":{8},"InvoiceValueType":1,"selectedBranch":[],"selectedBranchObj":[],"selectedUser":[],"selectedUserObj":[],"selectedCustomerGroup":[{9}],"selectedCustomerGroupObj":[{{"Id":{9},"Name":"Nhóm khách VIP","Description":"","CreatedDate":"","CreatedBy":438680,"RetailerId":{8},"Filter":"[{{\\"FieldName\\":\\"TotalRevenue\\",\\"Operator\\":0,\\"Value\\":500000,\\"DataType\\":\\"number\\",\\"$$hashKey\\":\\"object:5622\\"}}]","DiscountRatio":15,"TypeUpdate":5,"CustomerGroupDetails":[],"PriceBookCustomerGroups":[],"RewardPointCustomerGroups":[],"VoucherCustomerGroups":[],"CompareName":"Nhóm khách VIP","IdOld":0}}],"Code":"{10}","CampaignBranches":[],"CampaignUsers":[],"CampainCustomerGroups":[{{"CustomerGroupId":{9},"CustomerGroupName":"Nhóm khách VIP"}}]}}}}    ${promotion_name}     ${month}    ${date}    ${total}    ${category_id_sale}      ${cat_sale_quan}        ${category_id_giveaway}       ${cat_giveaway_quan}     ${retailer_id}      ${get_cus_group_id}    ${promotion_code}
      log    ${data_str}
      Post request by other URL API    ${PROMO_API}    /campaigns     ${data_str}

Create promotion by invoice and product with product discount and not for all filter
    [Arguments]    ${promotion_code}    ${promotion_name}   ${total}    ${cat_sale}     ${cat_sale_quan}    ${cat_giveaway}      ${cat_giveaway_quan}
    ...       ${product_discount}       ${product_discount_ratio}       ${product_discount_type}    ${input_branch}    ${input_username}    ${group_customer_name}
    ${category_id_sale}    Get category ID    ${cat_sale}
    ${category_id_giveaway}         Get category ID    ${cat_giveaway}
    ${retailer_id}    Get RetailerID
    ${retailer_name}    Get Retailer name
    ${get_branch_id}    Get BranchID by BranchName    ${input_branch}
    ${get_user_id}   Get User ID by UserName    ${input_username}
    ${get_cus_group_id}   Get Customer Group ID by Customer Name    ${group_customer_name}
    ${curdatetime}    Get Current Date    result_format=datetime
    ${month}    Evaluate    $curdatetime.month
    ${date}    Evaluate    $curdatetime.day
    ${data_str}    Format String    {{"Campaign":{{"Id":0,"Name":"{0}","IsActive":"0","ApplyMonths":"{1}","ApplyDates":"{2}","Weekday":"","Hour":"","IsGlobal":false,"ForAllUser":false,"ForAllCusGroup":false,"Type":2,"PromotionType":17,"SalePromotions":[{{"Uuid":"","Type":2,"PromotionType":17,"InvoiceValue":{3},"PrereqProductId":null,"PrereqCategoryId":{4},"PrereqCategoryIds":"{4}","PrereqQuantity":{5},"PrereqApplySameKind":false,"Discount":null,"DiscountRatio":null,"DiscountType":"%","ReceivedProductId":null,"ReceivedCategoryId":{6},"ReceivedQuantity":{7},"ReceivedApplySameKind":false,"ProductDiscount":{8},"ProductDiscountRatio":{9},"ProductDiscountType":"{10}","ReceivedVoucherCampaignIds":null,"RetailerId":{11},"PrereqHirenchyCategoryStr":"Kẹo bánh","PrereqProductIds":null,"PrereqEntity":{{"__type":"KiotViet.Web.Api.ProductAndGroup, KiotViet.Web.Api","Id":{4},"Name":"Nhóm:Kẹo bánh","Code":"","Type":4,"LongName":"Kẹo bánh","SubCategoryIds":[{4}],"IsRewardPoint":true,"HasVariants":false,"ProductIds":"","HasRelated":true,"MasterProductIds":[null],"ProductCodes":"","CategoryIds":"{4}","Uuid":""}},"PrereqProductCodes":null,"MasterProductIds":null,"CategoryIds":null,"ReceivedHirenchyCategoryStr":"Hạt nhập khẩu KM","ReceivedProductIds":null,"ReceivedCategoryIds":"{6}","ReceivedEntity":{{"__type":"KiotViet.Web.Api.ProductAndGroup, KiotViet.Web.Api","Id":{6},"Name":"Nhóm:Hạt nhập khẩu KM","Code":"","Type":4,"LongName":"Hạt nhập khẩu KM","SubCategoryIds":[{6}],"IsRewardPoint":true,"HasVariants":false,"ProductIds":"","HasRelated":true,"MasterProductIds":[null],"ProductCodes":"","CategoryIds":"{6}","Uuid":""}},"ReceivedProductCodes":null}}],"StartDate":null,"EndDate":null,"BirthdayTimeType":1,"RetailerId":{11},"InvoiceValueType":1,"selectedBranch":[{12}],"selectedBranchObj":[{{"Id":{12},"Name":"Nhánh A","Type":0,"Address":"129 Phố Và","Province":"Bắc Ninh","District":"Thành phố Bắc Ninh","ContactNumber":"0987878877","IsActive":true,"RetailerId":{11},"CreatedBy":438680,"LimitAccess":false,"LocationName":"Bắc Ninh - Thành phố Bắc Ninh","WardName":"Phường Hạp Lĩnh","isAcceptBookClosing":false,"GmbStatus":1,"Orders":[],"Transfers1":[],"DamageItems":[],"SurchargeBranches":[],"AdrApplications":[],"Customers":[],"Suppliers":[],"ExpensesOtherBranches":[],"OrderSuppliers":[],"WarrantyBranchGroups":[],"BranchTakingAddresses":[],"Patients":[],"Clinics":[],"Doctors":[],"DoctorQualifications":[],"DoctorSpecialities":[],"Prescriptions":[],"PayslipPayments":[],"PayslipPaymentAllocations":[],"IdOld":0,"TotalUser":1,"CompareBranchName":"Nhánh A","StatusGmbValue":"Chưa đăng ký","IsTimeSheetException":false}}],"selectedUser":[{13}],"selectedUserObj":[{{"IdOld":0,"CompareGivenName":"tester","CompareIsLimitedByTrans":false,"CompareIsShowSumRow":true,"IsTimeSheetException":false,"Id":{13},"GivenName":"tester","CreatedDate":"2020-01-13T10:50:17.3700000+07:00","IsActive":true,"IsAdmin":false,"RetailerId":{11},"Type":0,"CreatedBy":438680,"CanAccessAnySite":false,"IsShowSumRow":true,"isDeleted":false,"Permissions":[],"Apps":[],"Invoices":[],"Transfers1":[],"PriceBookUsers":[],"CashFlows":[],"Invoices1":[],"Orders":[],"Returns1":[],"Manufacturings":[],"DamageItems":[],"TokenApis":[],"SmsEmailTemplates":[],"BalanceAdjustments1":[],"PointAdjustments":[],"PointAdjustmentsCreatedBy":[],"NotificationSettings":[],"DamageItems1":[],"PurchaseOrders1":[],"PurchaseReturns1":[],"CostAdjustments":[],"Devices":[],"OrderSuppliers":[],"OrderSuppliers1":[],"UserDevices":[],"PayslipPayments":[],"PayslipPaymentAllocations":[]}}],"selectedCustomerGroup":[{14}],"selectedCustomerGroupObj":[{{"Id":{14},"Name":"Nhóm khách VIP","Description":"","CreatedDate":"2020-01-31T11:01:06.7800000+07:00","CreatedBy":438680,"RetailerId":{11},"Filter":"[{{\\"FieldName\\":\\"TotalRevenue\\",\\"Operator\\":0,\\"Value\\":500000,\\"DataType\\":\\"number\\",\\"$$hashKey\\":\\"object:5622\\"}}]","DiscountRatio":15,"TypeUpdate":5,"CustomerGroupDetails":[],"PriceBookCustomerGroups":[],"RewardPointCustomerGroups":[],"VoucherCustomerGroups":[],"CompareName":"Nhóm khách VIP","IdOld":0}}],"Code":"{15}","CampaignBranches":[{{"BranchId":{12},"BranchName":"Nhánh A"}}],"CampaignUsers":[{{"UserId":{13},"GivenName":"tester"}}],"CampainCustomerGroups":[{{"CustomerGroupId":{14},"CustomerGroupName":"Nhóm khách VIP"}}]}}}}    ${promotion_name}     ${month}    ${date}    ${total}
    ...    ${category_id_sale}      ${cat_sale_quan}    ${category_id_giveaway}    ${cat_giveaway_quan}        ${product_discount}       ${product_discount_ratio}      ${product_discount_type}     ${retailer_id}
    ...    ${get_branch_id}    ${get_user_id}    ${get_cus_group_id}    ${promotion_code}
    log    ${data_str}
    Post request by other URL API    ${PROMO_API}    /campaigns     ${data_str}

Active user from Api
    [Arguments]   ${input_username}   ${input_stt_active}
    ${user_id}    Get User ID by UserName    ${input_username}
    ${endpoint}   Format String    ${endpoint_active_user}    ${user_id}
    ${data_str}    Format String    {{"userId":{0},"CompareUserName":"{1}","CompareGivenName":"Hương - Kế Toán","IsActive":{2}}}    ${user_id}   ${input_username}   ${input_stt_active}
    log    ${data_str}
    Post request thr API    ${endpoint}    ${data_str}

Get phone frm user api
    [Arguments]    ${user_name}
    [Timeout]    5 mins
    ${response_user_info}    Get Request and return body    ${endpoint_user}
    ${jsonpath_mobile}    Format String    $..Data[?(@.CompareUserName=="{0}")].MobilePhone    ${user_name}
    ${get_user_mobile}    Get data from response json    ${response_user_info}    ${jsonpath_mobile}
    Return From Keyword    ${get_user_mobile}

Update user info frm tai khoan popup
    [Arguments]   ${input_username}   ${input_email}   ${input_phone}
    ${user_id}    Get User ID by UserName    ${input_username}
    ${retailer_id}    Get RetailerID
    ${data_str}    Format String    {{"OldPassword":"","User":{{"IdOld":0,"CompareGivenName":"anh.lv","CompareIsLimitedByTrans":false,"CompareIsShowSumRow":true,"CompareUserName":"{3}","IsTimeSheetException":false,"Id":{0},"Email":"{1}","GivenName":"anh.lv","MobilePhone":"{2}","CreatedDate":"2018-07-30T15:27:36.8000000+07:00","IsActive":true,"IsAdmin":true,"RetailerId":{3},"UserName":"admin","Type":0,"CreatedBy":0,"CanAccessAnySite":false,"Language":"vi-VN","LocationName":"","WardName":"","isDeleted":false,"Permissions":[],"Apps":[],"Invoices":[],"Transfers1":[],"PriceBookUsers":[],"CashFlows":[],"Invoices1":[],"Orders":[],"Returns1":[],"Manufacturings":[],"DamageItems":[],"TokenApis":[],"SmsEmailTemplates":[],"BalanceAdjustments1":[],"PointAdjustments":[],"PointAdjustmentsCreatedBy":[],"NotificationSettings":[],"DamageItems1":[],"PurchaseOrders1":[],"PurchaseReturns1":[],"CostAdjustments":[],"Devices":[],"OrderSuppliers":[],"OrderSuppliers1":[],"UserDevices":[],"PayslipPayments":[],"PayslipPaymentAllocations":[],"temploc":"","tempw":"","OldPassword":"","RetypePassword":"","PlainPassword":""}},"CompareUserName":"{3}","IncludeAllBranch":false}}    ${user_id}   ${input_email}   ${input_phone}    ${retailer_id}   ${input_username}
    log    ${data_str}
    Post request thr API    /users     ${data_str}
