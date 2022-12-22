*** Settings ***
Resource          api_access.robot
Resource          api_danhmuc_hanghoa.robot
Library           DateTime

*** Variables ***
${mockapi_tiki}   https://tikimockapi.kvpos.com:9016
${endpoint_lazada}      /lazadas
${endpoint_mapping_lazada}      /omnichannel/addproductandmapping?kvuniqueparam=2020
${endpoint_product_lazada}    /omnichannel/getproductbychannelid?ChannelId={0}&BranchId={1}&channelType=1
${api_lazada_client}    https://lazadaclient.kvpos.com:9015
${endpoint_lazada_client_sku}     /skus?%24inlinecount=allpages&%24top=1000&%24filter=UserId+eq+%27lazada3%40gmail.com%27
${endpoint_lazada_client_order}     /Orders?%24inlinecount=allpages&%24top=10&%24orderby=CreateAt+desc&%24filter=startswith(OrderNumber%2C%27{0}%27)
${endpoint_delete_mapping}    /omnichannel/deleteProductMapping?kvuniqueparam=2020

*** Keywords ***
Get lazada channel id thr API
    [Arguments]     ${input_shop_lazada}
    ${jsonpath_id_lzd}    Format String    $..Data[?(@.Name=='{0}')].Id    ${input_shop_lazada}
    ${get_channel_lzd_id}    Get data from API    ${endpoint_lazada}    ${jsonpath_id_lzd}
    Return From Keyword    ${get_channel_lzd_id}

Delete lazada integration thr API
    [Arguments]   ${input_shop_lazada}
    ${get_channel_lzd_id}     Get lazada channel id thr API   ${input_shop_lazada}
    Create Session    lolo    ${API_URL}    cookies=${resp.cookies}
    ${resp}=    Delete Request    lolo    /lazada/${get_channel_lzd_id}?kvuniqueparam=2020
    Log    ${resp.request.body}
    Log    ${resp.json()}
    log    ${resp.status_code}
    Should Be Equal As Strings    ${resp.status_code}    200

Get id and item id in Lazada by item sku thr API
    [Arguments]     ${input_shop_lzd}    ${input_ma_hh_lzd}
    ${get_channel_id}   Get lazada channel id thr API      ${input_shop_lzd}
    ${endpoint_product_lazada}      Format String     ${endpoint_product_lazada}    ${get_channel_id}   ${BRANCH_ID}
    ${get_resp}   Get Request and return body    ${endpoint_product_lazada}
    ${get_item_id}      Get data from response json    ${get_resp}    $..Data[?(@.ItemSku=='${input_ma_hh_lzd}')].ItemId
    ${get_map_id}      Get data from response json    ${get_resp}    $..Data[?(@.ItemSku=='${input_ma_hh_lzd}')].Id
    Return From Keyword   ${get_item_id}      ${get_map_id}

Mapping product with Lazada thr API
    [Arguments]   ${input_shop_lzd}    ${input_ma_hh_lzd}   ${input_product}
    ${get_item_id}  ${get_map_id}   Get id and item id in Lazada by item sku thr API      ${input_shop_lzd}    ${input_ma_hh_lzd}
    ${get_channel_id}   Get lazada channel id thr API      ${input_shop_lzd}
    ${get_product_id}   Get product id thr API    ${input_product}
    ${get_retailer_id}    Get RetailerID
    ${data_str}    Set Variable     {"ChannelProduct":{"BasePrice":0,"Price":0,"OnHand":0,"OnOrder":0,"Reserved":0,"EditChannelUrl":"","Id":"${get_map_id}","ItemId":${get_item_id},"ItemName":"Khay đựng tiền Apos 1404 (edit)","ItemSku":"${input_ma_hh_lzd}","ItemImages":[],"ParentItemId":250060016,"ChannelType":1,"Type":1,"RetailerId":${get_retailer_id},"RetailerCode":"${RETAILER_NAME}","BranchId":${BRANCH_ID},"ChannelId":${get_channel_id},"IsConnected":false,"CreatedDate":"","ModifiedDate":"","KvProductId":${get_product_id},"KvProductSku":"${input_product}","ErrorMessage":"","Status":"inactive","isSearch":true,"productSearchParam":"${input_product}","KvProductFullName":"Nước Hoa The Face Shop Suzy Eau De Parfum vial"}}
    Log    ${data_str}
    ${headers}=    Create Dictionary    Authorization=${bearertoken}    Content-Type=application/json;
    Create Session    lolo    ${API_URL}    cookies=${resp.cookies}
    ${resp}=    Post Request    lolo    ${endpoint_mapping_lazada}   data=${data_str}    headers=${headers}
    Log    ${resp.request.body}
    Log    ${resp.json()}
    log    ${resp.status_code}
    Should Be Equal As Strings    ${resp.status_code}    200

Get list sku by product code thr API
    [Arguments]     ${input_shop_lzd}     ${list_product}
    ${get_channel_id}   Get lazada channel id thr API      ${input_shop_lzd}
    ${endpoint_product_lazada}      Format String     ${endpoint_product_lazada}    ${get_channel_id}   ${BRANCH_ID}
    ${get_resp}   Get Request and return body    ${endpoint_product_lazada}
    ${list_sku}   Create List
    :FOR    ${item_product}     IN ZIP      ${list_product}
    \     ${get_item_sku}      Get data from response json    ${get_resp}    $..Data[?(@.KvProductSku=='${item_product}')].ItemSku
    \     Append To List     ${list_sku}    ${get_item_sku}
    Log    ${list_sku}
    Return From Keyword   ${list_sku}

Add new price for sku in lazada client thr API
    [Arguments]     ${input_sku}    ${input_price}
    ${data_str}     Set Variable    {"Sku":{"UserId":"lazada3@gmail.com","Sku":"${input_sku}","Price":${input_price}}}
    Log    ${data_str}
    ${headers}    Create Dictionary    Content-Type=application/json;charset=UTF-8
    Create Session    lolo    ${api_lazada_client}
    ${resp}=    Post Request    lolo    /skus   data=${data_str}    headers=${headers}
    Log    ${resp.request.body}
    Log    ${resp.status_code}
    Should Be Equal As Strings    ${resp.status_code}    204

Update price for sku in lazada client thr API
    [Arguments]     ${input_id_sku}   ${input_sku}    ${input_price}
    ${get_cur}    Get Current Date     result_format=%Y-%m-%d
    ${data_str}     Set Variable    {"Sku":{"Id":${input_id_sku},"Sku":"${input_sku}","Price":${input_price},"CreateAt":"${get_cur}","UserId":"lazada3@gmail.com"}}
    Log    ${data_str}
    ${headers}    Create Dictionary    Content-Type=application/json;charset=UTF-8    Accept=application/json, text/plain, */*
    Create Session    lolo    ${api_lazada_client}
    ${resp}=    Post Request    lolo    /skus   data=${data_str}    headers=${headers}
    Log    ${resp.request.body}
    Log    ${resp.status_code}
    Should Be Equal As Strings    ${resp.status_code}    204

Get list id of sku in lazada client thr API
    [Arguments]   ${list_sku}
    ${header}    Create Dictionary    Accept=application/json, text/javascript, */*; q=0.01
    ${params}    Create Dictionary    format=json
    Create Session    lzd    ${api_lazada_client}
    ${resp}=    RequestsLibrary.Get Request    lzd    ${endpoint_lazada_client_sku}    params=${params}    headers=${header}
    Log    ${resp.request.body}
    Log    ${resp.json()}
    log    ${resp.status_code}
    Should Be Equal As Strings    ${resp.status_code}    200
    ${list_id}      Create List
    :FOR      ${item_sku}     IN ZIP    ${list_sku}
    \     ${get_all_id_sku}    Get raw data from response json    ${resp.json()}     $..Data[?(@.Sku=='${item_sku}')].Id
    \     ${length}     Get Length    ${get_all_id_sku}
    \     ${index}      Minus and replace floating point    ${length}   1
    \     Run Keyword If    ${index}<0    Append To List    ${list_id}      0    ELSE      Append To List      ${list_id}      ${get_all_id_sku[${index}]}
    Log    ${list_id}
    Return From Keyword    ${list_id}

Change price sku in lazada client thr API
    [Arguments]     ${input_shop_lzd}     ${list_product}     ${list_price}
    ${list_sku}     Get list sku by product code thr API    ${input_shop_lzd}     ${list_product}
    ${list_id}    Get list id of sku in lazada client thr API    ${list_sku}
    :FOR    ${item_id}      ${item_sku}     ${item_price}     IN ZIP    ${list_id}    ${list_sku}   ${list_price}
    \     Run Keyword If    ${item_id}==0   Add new price for sku in lazada client thr API    ${item_sku}     ${item_price}   ELSE      Update price for sku in lazada client thr API    ${item_id}      ${item_sku}     ${item_price}
    Return From Keyword     ${list_sku}

Create order Lazada
    [Arguments]     ${list_sku}   ${ten_kh}   ${sdt}    ${dia_chi}   ${khu_vuc}    ${phuong_xa}
    ${order_number}     Generate Random String      5     [NUMBERS]
    ${length}     Get Length    ${list_sku}
    ${data_item}      Create List
    :FOR    ${index}      IN RANGE    ${length}
    \     Append To List     ${data_item}    {"OrderItemId":"","Sku":"${list_sku[${index}]}","ShippingType":"dropshipping","Status":"pending","ShipmentProvider":""}
    Log     ${data_item}
    Log     ${data_item}
    ${data_item}    Convert List to String    ${data_item}
    ${data_str}    Set Variable     {"Order":{"OrderItems":[${data_item}],"UserId":"lazada3@gmail.com","OrderNumber":${order_number},"AddressBilling":{"FirstName":"${ten_kh}","LastName":"","Phone":"${sdt}"},"AddressShipping":{"FirstName":"${ten_kh}","LastName":"","Address1":"${dia_chi}","Ward":"${phuong_xa}","Region":"${khu_vuc}"},"WarehouseCode":"dropshipping"}}
    Log    ${data_str}
    ${headers}    Create Dictionary    Content-Type=application/json;charset=UTF-8
    Create Session    lolo      ${api_lazada_client}
    :FOR      ${time}     IN RANGE      5
    \    ${resp}=    Post Request    lolo    /Orders   data=${data_str}    headers=${headers}
    \    Exit For Loop If    '${resp.status_code}'=='204'
    Log    ${resp.request.body}
    log    ${resp.status_code}
    Should Be Equal As Strings    ${resp.status_code}    204
    Return From Keyword    ${order_number}

Get order id by order number thr API
    [Arguments]     ${order_number}
    ${endpoint_lazada_client_order}   Format String     ${endpoint_lazada_client_order}   ${order_number}
    ${header}    Create Dictionary    Accept=application/json, text/javascript, */*; q=0.01
    ${params}    Create Dictionary    format=json
    Create Session    lzd    ${api_lazada_client}
    ${resp}=    RequestsLibrary.Get Request    lzd    ${endpoint_lazada_client_order}    params=${params}    headers=${header}
    Log    ${resp.request.body}
    Log    ${resp.json()}
    log    ${resp.status_code}
    Should Be Equal As Strings    ${resp.status_code}    200
    ${get_oder_id}      Get data from response json    ${resp.json()}    $..Data..OrderId
    Return From Keyword    ${get_oder_id}

Get order id, address shipping id and address billing id by order number thr API
    [Arguments]     ${order_number}
    ${endpoint_lazada_client_order}   Format String     ${endpoint_lazada_client_order}   ${order_number}
    ${header}    Create Dictionary    Accept=application/json, text/javascript, */*; q=0.01
    ${params}    Create Dictionary    format=json
    Create Session    lzd    ${api_lazada_client}
    ${resp}=    RequestsLibrary.Get Request    lzd    ${endpoint_lazada_client_order}    params=${params}    headers=${header}
    Log    ${resp.request.body}
    Log    ${resp.json()}
    log    ${resp.status_code}
    Should Be Equal As Strings    ${resp.status_code}    200
    ${get_oder_id}      Get data from response json    ${resp.json()}    $..Data..OrderId
    ${get_shipping_id}      Get data from response json    ${resp.json()}    $..Data..AddressShipping.Id
    ${get_billing_id}      Get data from response json    ${resp.json()}    $..Data..AddressBilling.Id
    Return From Keyword    ${get_oder_id}   ${get_shipping_id}    ${get_billing_id}

Get list order item id by order number thr API
    [Arguments]     ${order_number}     ${list_sku}
    ${endpoint_lazada_client_order}   Format String     ${endpoint_lazada_client_order}   ${order_number}
    ${header}    Create Dictionary    Accept=application/json, text/javascript, */*; q=0.01
    ${params}    Create Dictionary    format=json
    Create Session    lzd    ${api_lazada_client}
    ${resp}=    RequestsLibrary.Get Request    lzd    ${endpoint_lazada_client_order}    params=${params}    headers=${header}
    Log    ${resp.request.body}
    Log    ${resp.json()}
    log    ${resp.status_code}
    Should Be Equal As Strings    ${resp.status_code}    200
    ${list_order_item_id}   Create List
    :FOR      ${item_sku}   IN ZIP    ${list_sku}
    \    ${get_oder_item_id}      Get data from response json    ${resp.json()}     $..Data..OrderItems[?(@.Sku=='${item_sku}')].OrderItemId
    \    Append To List   ${list_order_item_id}     ${get_oder_item_id}
    Log    ${list_order_item_id}
    Return From Keyword    ${list_order_item_id}

Update status order Lazada
    [Arguments]      ${order_number}      ${list_sku}    ${list_price}     ${ten_kh}   ${sdt}    ${dia_chi}   ${khu_vuc}    ${phuong_xa}   ${status}
    ${get_oder_id}   ${get_shipping_id}    ${get_billing_id}   Get order id, address shipping id and address billing id by order number thr API    ${order_number}
    ${list_order_item_id}     Get list order item id by order number thr API    ${order_number}    ${list_sku}
    ${get_cur}    Get Current Date     result_format=%Y-%m-%d
    ${length}     Get Length    ${list_sku}
    ${data_item}      Create List
    :FOR    ${index}      IN RANGE    ${length}
    \     Append To List     ${data_item}    {"OrderItemId":${list_order_item_id[${index}]},"Sku":"${list_sku[${index}]}","ShippingType":"dropshipping","Status":"${status}","ShipmentProvider":"","ItemPrice":${list_price[${index}]},"OrderId":${get_oder_id}}
    Log     ${data_item}
    Log     ${data_item}
    ${data_item}    Convert List to String    ${data_item}
    ${data_str}    Set Variable     {"Order":{"OrderId":${get_oder_id},"OrderNumber":${order_number},"OrderItems":[${data_item}],"AddressBillingId":${get_billing_id},"AddressShippingId":${get_shipping_id},"AddressBilling":{"Id":${get_billing_id},"FirstName":"${ten_kh}","LastName":"","Phone":"${sdt}"},"AddressShipping":{"Id":${get_shipping_id},"FirstName":"${ten_kh}","LastName":"","Address1":"${dia_chi}","Ward":"${phuong_xa}","Region":"${khu_vuc}"},"CreateAt":"${get_cur}","UserId":"lazada3@gmail.com","WarehouseCode":"dropshipping"}}
    Log    ${data_str}
    ${headers}    Create Dictionary    Content-Type=application/json;charset=UTF-8
    Create Session    lolo      ${api_lazada_client}
    ${resp}=    Post Request    lolo    /Orders   data=${data_str}    headers=${headers}
    Log    ${resp.request.body}
    log    ${resp.status_code}
    Should Be Equal As Strings    ${resp.status_code}    204

Get item id in Lazada by product code thr API
    [Arguments]     ${input_shop_lazada}    ${input_product}
    ${get_channel_id}     Get lazada channel id thr API        ${input_shop_lazada}
    ${endpoint_product_lzd}      Format String     ${endpoint_product_lazada}    ${get_channel_id}   ${BRANCH_ID}
    ${get_resp}   Get Request and return body    ${endpoint_product_lzd}
    ${jsonpath_item_id}   Set Variable    $..Data[?(@.KvProductSku=='${input_product}')].ItemId
    ${get_item_id}      Get data from response json    ${get_resp}    ${jsonpath_item_id}
    Return From Keyword   ${get_item_id}

Get item sku lazada by kv product sku
    [Arguments]     ${input_shop_lazada}    ${input_ma_hh}
    Log    ${input_ma_hh}
    ${get_channel_id}      Get lazada channel id thr API        ${input_shop_lazada}
    ${endpoint_product_lzd}      Format String     ${endpoint_product_lazada}    ${get_channel_id}   ${BRANCH_ID}
    ${get_resp}   Get Request and return body    ${endpoint_product_lzd}
    ${get_item_sku}      Get data from response json    ${get_resp}    $..Data[?(@.KvProductSku=='${input_ma_hh}')].ItemSku
    Return From Keyword       ${get_item_sku}

Get item id and parent item id in Lazada by kv product sku
    [Arguments]     ${input_shop_lazada}    ${input_ma_hh}
    ${get_channel_id}      Get lazada channel id thr API        ${input_shop_lazada}
    ${endpoint_product_lzd}      Format String     ${endpoint_product_lazada}    ${get_channel_id}   ${BRANCH_ID}
    ${get_resp}   Get Request and return body    ${endpoint_product_lzd}
    ${get_item_id}      Get data from response json    ${get_resp}    $..Data[?(@.KvProductSku=='${input_ma_hh}')].ItemId
    ${get_parent_item_id}      Get data from response json    ${get_resp}    $..Data[?(@.KvProductSku=='${input_ma_hh}')].ParentItemId
    Return From Keyword       ${get_item_id}      ${get_parent_item_id}

Assert get item id by kv product sku succeed
    [Arguments]     ${input_shop_lazada}      ${ma_hh}
    ${get_item_id}      ${get_parent_item_id}      Get item id and parent item id in Lazada by kv product sku      ${input_shop_lazada}      ${ma_hh}
    Should Not Be Equal As Strings    ${get_item_id}    0
    Return From Keyword      ${get_item_id}      ${get_parent_item_id}

Create list audit trail for map product Lazada
    [Arguments]     ${input_shop_lazada}      ${ma_hh}      ${ma_hh_lzd}
    ${get_item_id}      ${get_parent_item_id}    Wait Until Keyword Succeeds    20x    5x   Assert get item id by kv product sku succeed       ${input_shop_lazada}  ${ma_hh}
    ${list_audit}     Create List    Thêm mới liên kết hàng hóa: <br/>Lazada shop: ${input_shop_lazada} <br/>- <a href='#/Products?code=${ma_hh}' target='_blank'>${ma_hh}</a> liên kết với
    #${get_item_id}</a> - ${ma_hh_lzd}<br/>
    #${list_audit}     Create List    Thêm mới liên kết hàng hóa: <br/>Lazada shop: ${input_shop_lazada} <br/>- <a href='#/Products?code=${ma_hh}' target='_blank'>${ma_hh}</a> liên kết với <a href='https://sellercenter.lazada.vn/product/publish/edit/${get_parent_item_id}' target='_blank'>${get_item_id}</a> - ${ma_hh_lzd}<br/>
    Log    ${list_audit}
    Return From Keyword    ${list_audit}

Delete product mapping Lazada thr API
    [Arguments]     ${input_shop_lazada}     ${input_product}
    ${get_item_id}      Get item id in Lazada by product code thr API      ${input_shop_lazada}    ${input_product}
    ${get_channel_id}       Get lazada channel id thr API    ${input_shop_lazada}
    ${get_product_id}   Get product id thr API    ${input_product}
    ${data_str}    Set Variable     {"ChannelId":${get_channel_id},"KvProductId":${get_product_id},"ChannelProductId":${get_item_id}}
    Log    ${data_str}
    ${headers}=    Create Dictionary    Authorization=${bearertoken}    Content-Type=application/json;
    Create Session    lolo    ${API_URL}    cookies=${resp.cookies}
    ${resp}=    Post Request    lolo    ${endpoint_delete_mapping}   data=${data_str}    headers=${headers}
    Log    ${resp.request.body}
    Log    ${resp.json()}
    log    ${resp.status_code}
    Should Be Equal As Strings    ${resp.status_code}    200

Delete product mapping Lazada if mapping is visible thr API
    [Arguments]     ${input_shop_lazada}     ${input_product}
    ${get_item_sku}   Get item sku lazada by kv product sku    ${input_shop_lazada}     ${input_product}
    Run Keyword If    '${get_item_sku}'!='0'   Delete product mapping Lazada thr API    ${input_shop_lazada}     ${input_product}

Check status order and status delivery Lazada
    [Arguments]   ${list_trangthai_lzd}
    ${get_length}   Get Length    ${list_trangthai_lzd}
    ${end_status}     Minus     ${get_length}   1
    ${end_status}   Replace floating point    ${end_status}
    ${result_trangthai_hoadon}      Run Keyword If       '${list_trangthai_lzd[${end_status}]}'=='canceled'     Set Variable    Đã hủy   ELSE     Set Variable    Đang xử lý
    ${result_trangthai_vandon}      Run Keyword If       '${list_trangthai_lzd[${end_status}]}'=='ready_to_ship'    Set Variable    Đã lấy hàng    ELSE IF     '${list_trangthai_lzd[${end_status}]}'=='shipped'    Set Variable   Đang giao hàng    ELSE IF   '${list_trangthai_lzd[${end_status}]}'=='delivered'      Set Variable   Giao thành công       ELSE IF      '${list_trangthai_lzd[${end_status}]}'=='canceled'    Set Variable    Đã hủy    ELSE   Set Variable    Đang chuyển hoàn
    ${result_status_vandon}      Run Keyword If      '${result_trangthai_vandon}'=='Đang lấy hàng'    Set Variable    7   ELSE IF      '${result_trangthai_vandon}'=='Đã lấy hàng'    Set Variable   9   ELSE IF     '${result_trangthai_vandon}'=='Đang giao hàng'    Set Variable   2    ELSE IF   '${result_trangthai_vandon}'=='Giao thành công'     Set Variable   3      ELSE   Set Variable    4
    Return From Keyword    ${result_trangthai_hoadon}       ${result_trangthai_vandon}      ${result_status_vandon}
