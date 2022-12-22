*** Settings ***
Resource          api_hoadon_banhang.robot
Resource          api_access.robot
Resource          api_danhmuc_hanghoa.robot

*** Variables ***
${endpoint_delete_price_book}    /pricebook/{0}
${endpoint_ds_bang_gia}    /pricebook/filter?includeAll=true&Includes=PriceBookBranches&Includes=PriceBookCustomerGroups&Includes=PriceBookUsers&Includes=PriceBookDependency&IncludeSortName=true&%24inlinecount=allpages
${endpoint_hh_trong_banggia}    /pricebook/getlistitems?PriceBookIds={0}&%24inlinecount=allpage
${endpoint_banggia_add_nhomhang}    /pricebook/addcategory
${endpoint_banggia_chinhsua_gia}    /pricebook/calcprice

*** Keywords ***
Delete price book thr API
    [Arguments]    ${name}
    [Timeout]    3 minute
    ${get_pricet_id}    Get price book id    ${name}
    ${endpoint_dl_price}    Format String    ${endpoint_delete_price_book}    ${get_pricet_id}
    Delete request thr API    ${endpoint_dl_price}

Get total product in price book thr API
    [Arguments]    ${name}
    [Timeout]    3 minute
    ${price_id}    Get price book id    ${name}
    ${endpoint_hh_trong_banggia}    Format String    ${endpoint_hh_trong_banggia}    ${price_id}
    ${total}    Get data from API    ${endpoint_hh_trong_banggia}    $..Total
    Return From Keyword    ${total}

Get price book id
    [Arguments]    ${name}
    [Timeout]    3 minute
    ${jsonpath_price_book_id}    Format String    $..Data[?(@.Name=="{0}")].Id    ${name}
    ${get_pricet_id}    Get data from API    ${endpoint_ds_bang_gia}    ${jsonpath_price_book_id}
    Return From Keyword    ${get_pricet_id}

Assert price in price book thr API
    [Arguments]    ${ten_bang_gia}    ${ma_hh}    ${input_giamoi}
    ${giaban}    Get price of product in price book thr API    ${ten_bang_gia}    ${ma_hh}
    Should Be Equal As Numbers    ${giaban}    ${input_giamoi}

Assert list price in price book thr API
    [Arguments]   ${ten_bang_gia}     ${list_pr}    ${list_new_price}
    ${list_result_price}    Get list price of list product in price book thr API    ${ten_bang_gia}     ${list_pr}
    : FOR    ${item_hh}    ${item_price}    ${item_result_price}    IN ZIP    ${list_pr}    ${list_new_price}    ${list_result_price}
    \      Should Be Equal As Numbers    ${item_price}    ${item_result_price}

Get and compute list new price by general infor in price book
    [Arguments]    ${list_pr}    ${value}    ${tanggiam}   ${gia_ss}
    [Timeout]    5 minute
    ${list_giavon}    ${list_gianhapcuoi}    ${list_giaban}    Get list cost, lastest purchase price, baseprice thr API    ${list_pr}
    ${list_giaban_bg}    Get list price of list product in price book thr API    ${gia_ss}    ${list_pr}
    ${list_price}   Run Keyword If    '${gia_ss}'=='Giá vốn'    Set Variable    ${list_giavon}    ELSE IF   '${gia_ss}'=='Giá hiện tại' or '${gia_ss}'=='Giá chung'    Set Variable    ${list_giaban}   ELSE IF   '${gia_ss}'=='Giá nhập lần cuối'    Set Variable    ${list_gianhapcuoi}    ELSE    Set Variable    ${list_giaban_bg}
    ${list_newprice}    Create List
    : FOR     ${item_pr}   ${item_price}     IN ZIP    ${list_pr}   ${list_price}
    \     ${newprice}    Run Keyword If    ${value}>999 and '${tanggiam}'=='giảm'   Minus and round 2    ${item_price}    ${value}    ELSE IF      ${value}<=999 and '${tanggiam}'=='giảm'     Price after % discount product    ${item_price}    ${value}     ELSE IF    ${value}<=999 and '${tanggiam}'=='tăng'   Price after % increase product     ${item_price}    ${value}    ELSE   Sum and round 2    ${item_price}    ${value}
    \     ${newprice}   Run Keyword If    ${newprice}<0    Set Variable    0       ELSE    Set Variable    ${newprice}
    \     Append To List    ${list_newprice}      ${newprice}
    Return From Keyword    ${list_newprice}

Get and compute list new price in price book
    [Arguments]    ${list_pr}    ${list_value}    ${is_tanggiam}   ${list_gia_ss}
    [Timeout]    5 minute
    ${list_giavon}    ${list_gianhapcuoi}    ${list_giaban}    Get list cost, lastest purchase price, baseprice thr API    ${list_pr}
    ${list_newprice}    Create List
    : FOR     ${item_pr}   ${item_value}      ${item_gia_ss}    ${item_giavon}    ${item_gianhapcuoi}    ${item_giaban}       IN ZIP    ${list_pr}   ${list_value}    ${list_gia_ss}    ${list_giavon}    ${list_gianhapcuoi}    ${list_giaban}
    \     ${item_price}   Run Keyword If    '${item_gia_ss}'=='Giá vốn'    Set Variable    ${item_giavon}    ELSE IF   '${item_gia_ss}'=='Giá hiện tại' or '${item_gia_ss}'=='Giá chung'    Set Variable    ${item_giaban}   ELSE   Set Variable    ${item_gianhapcuoi}
    \     ${newprice}    Run Keyword If    ${item_value}>999 and '${is_tanggiam}'=='giảm'   Minus and round 2    ${item_price}    ${item_value}    ELSE IF      ${item_value}<=999 and '${is_tanggiam}'=='giảm'     Price after % discount product    ${item_price}    ${item_value}     ELSE IF    ${item_value}<=999 and '${is_tanggiam}'=='tăng'   Price after % increase product     ${item_price}    ${item_value}    ELSE   Sum and round 2    ${item_price}    ${item_value}
    \     ${newprice}   Run Keyword If    ${newprice}<0    Set Variable    0       ELSE    Set Variable    ${newprice}
    \     Append To List    ${list_newprice}      ${newprice}
    Return From Keyword    ${list_newprice}

Assert price book is not avaiable thr API
    [Arguments]    ${ten_bang_gia}
    [Timeout]    3 minute
    ${all_price_book}    Get all price book name thr API
    List Should Not Contain Value    ${all_price_book}    ${ten_bang_gia}

Get all price book name thr API
    [Timeout]    3 minute
    ${all_price_book}    Get raw data from API    ${endpoint_ds_bang_gia}    $..CompareName
    Return From Keyword    ${all_price_book}

Assert product is not avaiable in price book
    [Arguments]    ${ten_bang_gia}    ${list_hh}
    [Timeout]    3 minute
    ${get_pb_id}    Get price book id    ${ten_bang_gia}
    ${endpoint_hh_trong_banggia}    Format String    ${endpoint_hh_trong_banggia}    ${get_pb_id}
    ${get_all_prd}    Get raw data from API    ${endpoint_hh_trong_banggia}    $..Code
    Log    ${get_all_prd}
    : FOR    ${item_hh}    IN ZIP    ${list_hh}
    \    List Should Not Contain Value    ${get_all_prd}    ${item_hh}

Get price of product in price book thr API
    [Arguments]    ${ten_bang_gia}    ${ma_sp}
    [Timeout]    5 minute
    ${get_pricebook_id}    Get price book id    ${ten_bang_gia}
    ${endpoint_bg}    Format String    ${endpoint_hh_trong_banggia}    ${get_pricebook_id}
    ${resp}    Get Request and return body    ${endpoint_bg}
    ${jsonpath_giaban}    Format String    $..Data[?(@.Code=="{0}")].Pb1    ${ma_sp}
    ${giaban}    Get data from response json    ${resp}    ${jsonpath_giaban}
    Return From Keyword    ${giaban}

Get list price of list product in price book thr API
    [Arguments]   ${ten_bang_gia}   ${list_pr}
    ${get_pricebook_id}    Get price book id    ${ten_bang_gia}
    ${endpoint_bg}    Format String    ${endpoint_hh_trong_banggia}    ${get_pricebook_id}
    ${resp}    Get Request and return body    ${endpoint_bg}
    ${list_giaban}    Create List
    :FOR    ${item_pr}    IN ZIP    ${list_pr}
    \    ${jsonpath_giaban}    Format String    $..Data[?(@.Code=="{0}")].Pb1    ${item_pr}
    \    ${get_giaban}    Get data from response json    ${resp}    ${jsonpath_giaban}
    \    Append To List    ${list_giaban}    ${get_giaban}
    Return From Keyword       ${list_giaban}

Get price and value in tab Advanced settings
    [Arguments]    ${ten_bang_gia}
    [Timeout]    5 minute
    ${resp}    Get Request and return body    ${endpoint_ds_bang_gia}
    Log    ${resp}
    ${jsonpath_paren_id}    Format String    $..Data[?(@.Name=="{0}")].PriceBookDependency.ParentId    ${ten_bang_gia}
    ${jsonpath_value_%}    Format String    $..Data[?(@.Name=="{0}")].PriceBookDependency.ValueRatio    ${ten_bang_gia}
    ${jsonpath_value_vnd}    Format String    $..Data[?(@.Name=="{0}")].PriceBookDependency.Value    ${ten_bang_gia}
    ${get_paren_id}    Get data from response json    ${resp}    ${jsonpath_paren_id}
    ${get_value_%}    Get data from response json    ${resp}    ${jsonpath_value_%}
    ${get_value_vnd}    Get data from response json    ${resp}    ${jsonpath_value_vnd}
    ${value}    Run Keyword If    ${get_value_%}==0 and ${get_value_vnd}!=0    Set Variable    ${get_value_vnd}
    ...    ELSE IF    ${get_value_%}!=0 and ${get_value_vnd}==0    Set Variable    ${get_value_%}
    ...    ELSE    Set Variable    0
    Return From Keyword    ${get_paren_id}    ${value}

Assert price and value in tab Advanced settings
    [Arguments]    ${ten_bang_gia}    ${gia_ss}    ${is_tanggiam}   ${value}
    [Timeout]    5 minute
    ${get_paren_id}    ${get_value}    Get price and value in tab Advanced settings    ${ten_bang_gia}
    ${get_pricebook_id}    Get price book id    ${gia_ss}
    ${praren_id}    Run Keyword If    '${gia_ss}'=='Giá vốn'    Set Variable    -2
    ...    ELSE IF    '${gia_ss}'=='Giá nhập lần cuối'    Set Variable    -1
    ...    ELSE IF    '${gia_ss}'=='Giá chung'    Set Variable    0
    ...    ELSE    Set Variable    ${get_pricebook_id}
    ${result_value}    Run Keyword If    '${is_tanggiam}'=='giảm'    Minus    0    ${value}    ELSE    Set Variable    ${value}
    Should Be Equal As Numbers    ${get_paren_id}    ${praren_id}
    Should Be Equal As Numbers    ${get_value}    ${result_value}


Changing price in price book thr API
    [Arguments]    ${ten_bang_gia}    ${ma_sp}    ${gia_moi}
    [Timeout]    3 minutes
    ${get_pb_id}    Get price book id    ${ten_bang_gia}
    ${get_prd_id}    Get product ID    ${ma_sp}
    ${payload}    Format String    {{"PricebookId":{0},"ItemCalc":{{"PricebookId":{0},"ProductId":{1},"PriceDirect":{2}}}}}    ${get_pb_id}    ${get_prd_id}    ${gia_moi}
    Log    ${payload}
    Post request thr API    /pricebook/calcPriceForAllItems    ${payload}

Changing list price in price book thr API
    [Arguments]    ${ten_bang_gia}    ${list_prs}    ${list_price}
    [Timeout]    5 minutes
    : FOR    ${item_pr}    ${item_price}    IN ZIP    ${list_prs}    ${list_price}
    \    Changing price in price book thr API    ${ten_bang_gia}    ${item_pr}    ${item_price}

Get list products price by price book thr API
    [Arguments]    ${input_ten_banggia}    ${list_product}
    [Timeout]    3 minutes
    ${list_giaban}    Create List
    ${get_id_banggia}     Get price book id    ${input_ten_banggia}
    ${endpoint_pricebook}    Format String    ${endpoint_pricebook_detail}    ${get_id_banggia}
    ${get_resp}    Get Request and return body    ${endpoint_pricebook}
    : FOR    ${input_ma_hh}    IN    @{list_product}
    \    ${jsonpath_giaban}    Format String    $..Data[?(@.Code == '{0}')].Pb1    ${input_ma_hh}
    \    ${get_giaban}    Get data from response json    ${get_resp}    ${jsonpath_giaban}
    \    Append To List    ${list_giaban}    ${get_giaban}
    Return From Keyword    ${list_giaban}

Add new price book had parent
    [Arguments]    ${input_banggia}     ${input_banggia_cha}      ${input_discount}
    ${get_pb_cha_id}      Get price book id    ${input_banggia_cha}
    ${request_payload}    Format String    {{"PriceBook":{{"Id":0,"Name":"{0}","IsGlobal":true,"IsActive":true,"ForAllUser":true,"ForAllCusGroup":true,"StartDate":"2020-03-09T10:47:52.540Z","EndDate":"2025-03-09T10:47:52.540Z","price":0,"CommodityDisplayType":1,"discountTypes":{{"money":"VND","percent":"%"}},"CalcValueType":"%","CalcValue":{1},"CalcZone":true,"CalcPriceType":{2},"oparationTypes":{{"plus":"+","sub":"-"}},"oparation":"-","TotalPriceBookDetail":0,"UseAutoCreateProducts":false,"UseAutoRound":false,"UseAutoRoundValue":0,"selectedUser":[],"selectedBranch":[],"selectedCustomerGroup":[],"defaultCalcPriceType":-999999,"calcActive":1,"PriceBookCustomerGroups":[],"PriceBookUsers":[],"PriceBookBranches":[],"PriceBookDependencyDto":{{"ParentId":{2},"Value":null,"ValueRatio":-10,"IsAuto":true,"UseAutoRoundValue":null,"IsPlusSign":false,"UseAutoCreateProducts":false}}}},"IsUpdateProduct":false}}    ${input_banggia}     ${input_discount}     ${get_pb_cha_id}
    log    ${request_payload}
    Post request thr API    /pricebook    ${request_payload}

Update price formula increase percent thr API
    [Arguments]    ${input_banggia}     ${input_percent}      ${input_active}
    ${get_user_id}      Get User ID
    ${get_retailer_id}    Get RetailerID
    ${get_bg_id}      Get price book id     ${input_banggia}
    ${request_payload}   Set Variable     {"PriceBook":{"IdOld":0,"CompareName":"${input_banggia}","CompareIsActive":true,"CompareStartDate":"","CompareEndDate":"","CompareCommodityDisplayType":1,"TotalPriceBookDetail":9,"Id":${get_bg_id},"Name":"${input_banggia}","IsActive":${input_active},"IsGlobal":true,"CreatedDate":"","CreatedBy":${get_user_id},"ModifiedDate":"","ModifiedBy":${get_user_id},"RetailerId":${get_retailer_id},"StartDate":"2020-11-24T14:14:54.5430000+07:00","EndDate":"2022-11-24T14:14:54.5430000+07:00","ForAllUser":true,"ForAllCusGroup":true,"CommodityDisplayType":1,"PriceBookBranches":[],"PriceBookDetails":[],"PriceBookCustomerGroups":[],"PriceBookUsers":[],"Invoices":[],"AdrApplications":[],"PriceBookDependency":{"PriceBookId":${get_bg_id},"RetailerId":${get_user_id},"ParentId":0,"IsAuto":true,"ValueRatio":${input_percent},"IsPlusSign":true},"Returns":[],"discountTypes":{"money":"VND","percent":"%"},"CalcValueType":"%","CalcValue":${input_percent},"CalcZone":true,"CalcPriceType":0,"oparationTypes":{"plus":"+","sub":"-"},"oparation":"+","UseAutoCreateProducts":false,"UseAutoRound":false,"UseAutoRoundValue":0,"selectedUser":[],"selectedBranch":[],"selectedCustomerGroup":[],"defaultCalcPriceType":-999999,"PriceBookDependencyDto":{"ParentId":0,"Value":null,"ValueRatio":${input_percent},"IsAuto":true,"UseAutoRoundValue":null,"IsPlusSign":true,"UseAutoCreateProducts":null}},"IsUpdateProduct":true}
    log    ${request_payload}
    Post request thr API    /pricebook?kvuniqueparam=2020    ${request_payload}

Add product into pricebook thr API
    [Arguments]     ${input_banggia}    ${input_ma_hh}
    ${get_pr_id}      Get product id thr API    ${input_ma_hh}
    ${get_bg_id}      Get price book id    ${input_banggia}
    ${ton}      ${gia_ban}    Get Onhand and Baseprice frm API    ${input_ma_hh}
    ${request_payload}    Set Variable    {"ProductId":${get_pr_id},"PriceBookIds":[${get_bg_id}],"Price": ${gia_ban}}
    Post request thr API    /pricebook/addItemsIntoPricebookDetails?kvuniqueparam=2020     ${request_payload}

Remove product from pricebook thr API
    [Arguments]     ${input_banggia}    ${input_ma_hh}
    ${get_pr_id}      Get product id thr API    ${input_ma_hh}
    ${get_bg_id}      Get price book id    ${input_banggia}
    ${ton}      ${gia_ban}    Get Onhand and Baseprice frm API    ${input_ma_hh}
    Delete request thr API    /pricebook/pricebookdeleteitems?PriceBookIds=${get_bg_id}&ProductIds=${get_pr_id}&kvuniqueparam=2020

Delete price book if it exists
    [Arguments]   ${input_banggia}
    ${get_id_bg}      Get price book id     ${input_banggia}
    Run Keyword If    '${get_id_bg}'=='0'    Log    Ignore bg    ELSE      Delete price book thr API    ${input_banggia}
