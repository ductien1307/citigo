*** Settings ***
Resource          api_hoadon_banhang.robot
Resource          api_access_mobile.robot
Resource          ../share/computation.robot
Library           StringFormat
Library           String
Library           Collections
Resource          ../share/imei.robot

*** Variables ***
${endpoint_danhmuc_hh_man}    /branchs/{0}/products?Orderby=-Id&Skip=0&CategoryId=0&IsActive=true       # branchid
${endpoint_danhmuc_hh_pos}    /products/sync?BranchId={0}     # branchid
${endpoint_list_cat_man}    /categories
*** Keywords ***
Get list exchange value from product mobile API
    [Arguments]    ${list_product}
    [Timeout]    3 minutes
    ${endpoint_pr}    Format String    ${endpoint_danhmuc_hh_man}    ${BRANCH_ID}
    ${get_resp}    Get mobile Request and return body    ${endpoint_pr}
    ${list_giatri_quydoi}    Create List
    : FOR    ${item_product}    IN    @{list_product}
    \    ${jsonpath_giatri_quydoi}    Format String    $.Data[?(@.Code=="{0}")].ConversionValue    ${item_product}
    \    ${get_giatri_quydoi_in_hd}    Get mobile data from response json    ${get_resp}    ${jsonpath_giatri_quydoi}
    \    Append To List    ${list_giatri_quydoi}    ${get_giatri_quydoi_in_hd}
    Return From Keyword    ${list_giatri_quydoi}

Get list base price - onhand - gia tri quy doi frm mobile API
    [Arguments]    ${list_products}
    [Timeout]    5 minutes
    ${list_baseprice}    Create List
    ${list_onhand}    Create List
    ${endpoint_pr}    Format String    ${endpoint_danhmuc_hh_man}    ${BRANCH_ID}
    ${get_resp}    Get mobile Request and return body    ${endpoint_pr}
    ${list_giatri_quydoi}    Get list exchange value from product mobile API    ${list_products}
    : FOR    ${item_ma_hh}    ${get_giatri_quydoi}    IN ZIP    ${list_products}    ${list_giatri_quydoi}
    \    ${jsonpath_ton}    Format String    $.Data[?(@.Code=="{0}")].OnHand    ${item_ma_hh}
    \    ${jsonpath_giaban}    Format String    $.Data[?(@.Code=="{0}")].BasePrice    ${item_ma_hh}
    \    ${giaban}    Get mobile data from response json    ${get_resp}    ${jsonpath_giaban}
    \    ${ton}    Get mobile data from response json    ${get_resp}    ${jsonpath_ton}
    \    ${ton}    Convert To Number    ${ton}
    \    ${ton}    Evaluate    round(${ton}, 3)
    \    Append to list    ${list_baseprice}    ${giaban}
    \    Append to list    ${list_onhand}    ${ton}
    Return From Keyword    ${list_baseprice}    ${list_onhand}    ${list_giatri_quydoi}

Get list product id and base price frm mobile API
    [Arguments]    ${list_products}
    [Timeout]    5 minutes
    ${list_baseprice}    Create List
    ${list_product_id}    Create List
    ${endpoint_pr}    Format String    ${endpoint_danhmuc_hh_man}    ${BRANCH_ID}
    ${get_resp}    Get mobile Request and return body    ${endpoint_pr}
    : FOR    ${item_ma_hh}      IN ZIP    ${list_products}    
    \    ${jsonpath_productid}    Format String    $.Data[?(@.Code=="{0}")].Id    ${item_ma_hh}
    \    ${jsonpath_giaban}    Format String    $.Data[?(@.Code=="{0}")].BasePrice    ${item_ma_hh}
    \    ${giaban}    Get mobile data from response json    ${get_resp}    ${jsonpath_giaban}
    \    ${product_id}    Get mobile data from response json    ${get_resp}    ${jsonpath_productid}
    \    Append to list    ${list_baseprice}    ${giaban}
    \    Append to list    ${list_product_id}    ${product_id}
    Return From Keyword    ${list_baseprice}    ${list_product_id}

Get category ID frm mobile api
    [Arguments]    ${category_name}
    ${jsonpath_productid}    Format String    $.Data[?(@.Name=="{0}")].Id    ${category_name}
    ${get_catergory_id}   Get data from mobile API    ${endpoint_list_cat_man}    ${jsonpath_productid}
    Return From Keyword      ${get_catergory_id}

Add new normal product frm mobile api
    [Arguments]    ${ui_product_code}    ${ten_sp}    ${ten_nhom}    ${gia_ban}    ${giavon}    ${ton}
    ${cat_id}    Get category ID frm mobile api    ${ten_nhom}
    ${payload}    Format String       {{"Product":{{"Id":0,"ProductType":2,"CategoryId":{0},"isActive":false,"HasVariants":false,"AllowsSale":true,"Name":"{1}","Code":"{2}","Description":"","BasePrice":{3},"Cost":{4},"LatestPurchasePrice":0.0,"OnHand":{5},"Reserved":0.0,"MinQuantity":0.0,"MaxQuantity":9.99999999E8,"CustomId":0,"CustomValue":0,"Unit":"","ConversionValue":0.0,"OrderTemplate":"","ProductAttributes":[],"ProductSerials":[],"IsLotSerialControl":false,"IsRewardPoint":true,"CategoryName":"Bánh nhập KM","Formulas":[],"IsTopping":false,"IsTimeType":false,"isDeleted":false,"IsProcessedGoods":false,"MasterProductId":0,"MasterUnitId":0,"ProductFormulas":[],"ProductUnits":[],"Barcode":"","Content":"","GlobalMedicineId":0,"IsBatchExpireControl":false,"IsMedicineProduct":false,"MedicineCode":"","ProductBatchExpires":[],"ProductImages":[],"ProductShelves":[],"RewardPoint":10,"Weight":0.0}}}}      ${cat_id}    ${ten_sp}    ${ui_product_code}    ${gia_ban}    ${giavon}    ${ton}
    Wait Until Keyword Succeeds    3 times    5s    Post request thr mobile API    /products    ${payload}
