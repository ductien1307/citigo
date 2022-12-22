*** Settings ***
Resource          api_access.robot
Resource          api_danhmuc_hanghoa.robot
Library           DateTime

*** Variables ***
${endpoint_shopee_tool}     https://api-hcm.kvpos.com:9018
${endpoint_shopee}       /shopees
${endpoint_product_shopee}    /omnichannel/getproductbychannelid?ChannelId={0}&BranchId={1}&channelType=2
${endpoint_add_product_shopee}    /omnichannel/addproductandmapping?kvuniqueparam=2020
${endpoint_delete_mapping}    /omnichannel/deleteProductMapping?kvuniqueparam=2020
${endpoint_mapping_shopee}      /omnichannel/mappingproducts?kvuniqueparam=2020
${endpoint_shopee_create_order}     /api/v1/orders/create
${endpoint_shopee_my_income}    /api/v1/orders/my_income/create
${endpoint_shopee_update_order_status}    /api/v1/orders/update/status
${endpoint_shopee_create_logistics}    /api/v1/logistics/tracking/create
${endpoint_shopee_update_logistics}   /api/v1/logistics/update/status

*** Keywords ***
Get shopee channel id and identitykey id thr API
    [Arguments]     ${input_shopee}
    ${get_resp}     Get Request and return body    ${endpoint_shopee}
    ${jsonpath_identityke_id}    Format String    $..Data[?(@.Name=='{0}')].IdentityKey    ${input_shopee}
    ${jsonpath_shopee_id}    Format String    $..Data[?(@.Name=='{0}')].Id    ${input_shopee}
    ${get_identitykey_id}    Get data from response json     ${get_resp}   ${jsonpath_identityke_id}
    ${get_shopee_channel_id}    Get data from response json     ${get_resp}   ${jsonpath_shopee_id}
    Return From Keyword    ${get_shopee_channel_id}     ${get_identitykey_id}

Get map id, item id, parent item id in Shopee by item sku thr API
    [Arguments]     ${input_shopee}    ${input_ma_hh_shopee}
    ${get_shopee_channel_id}      ${get_identitykey_id}     Get shopee channel id and identitykey id thr API    ${input_shopee}
    ${endpoint_product_shopee}      Format String     ${endpoint_product_shopee}    ${get_shopee_channel_id}   ${BRANCH_ID}
    ${get_resp}   Get Request and return body    ${endpoint_product_shopee}
    ${jsonpath_item_id}     Format String     $..Data[?(@.ItemSku=='{0}')].ItemId    ${input_ma_hh_shopee}
    ${get_item_id}      Get data from response json    ${get_resp}    $..Data[?(@.ItemSku=='${input_ma_hh_shopee}')].ItemId
    ${get_map_id}      Get data from response json    ${get_resp}    $..Data[?(@.ItemSku=='${input_ma_hh_shopee}')].Id
    ${get_parent_item_id}      Get data from response json    ${get_resp}    $..Data[?(@.ItemSku=='${input_ma_hh_shopee}')].ParentItemId
    Return From Keyword       ${get_map_id}   ${get_item_id}    ${get_parent_item_id}

Get item id, parent item id and item sku in Shopee by Kv Product Sku thr API
    [Arguments]     ${input_shopee}    ${input_product}
    Log    ${input_product}
    ${get_shopee_channel_id}      ${get_identitykey_id}     Get shopee channel id and identitykey id thr API    ${input_shopee}
    ${endpoint_product_shopee}      Format String     ${endpoint_product_shopee}    ${get_shopee_channel_id}   ${BRANCH_ID}
    ${get_resp}   Get Request and return body    ${endpoint_product_shopee}
    ${get_item_id}      Get data from response json    ${get_resp}    $..Data[?(@.KvProductSku=='${input_product}')].ItemId
    ${get_parent_item_id}      Get data from response json    ${get_resp}    $..Data[?(@.KvProductSku=='${input_product}')].ParentItemId
    ${get_item_sku_id}      Get data from response json    ${get_resp}    $..Data[?(@.KvProductSku=='${input_product}')].ItemSku
    Return From Keyword        ${get_item_id}    ${get_parent_item_id}    ${get_item_sku_id}

Get item id in Shopee by product code thr API
    [Arguments]     ${input_shopee}    ${input_product}
    ${get_shopee_channel_id}      ${get_identitykey_id}     Get shopee channel id and identitykey id thr API    ${input_shopee}
    ${endpoint_product_shopee}      Format String     ${endpoint_product_shopee}    ${get_shopee_channel_id}   ${BRANCH_ID}
    ${get_resp}   Get Request and return body    ${endpoint_product_shopee}
    ${jsonpath_item_id}   Set Variable    $..Data[?(@.KvProductSku=='${input_product}')].ItemId
    ${get_item_id}      Get data from response json    ${get_resp}    ${jsonpath_item_id}
    Return From Keyword   ${get_item_id}

Get list item id by list product code in Shopee thr API
    [Arguments]     ${input_shopee}    ${list_product}
    ${get_shopee_channel_id}      ${get_identitykey_id}     Get shopee channel id and identitykey id thr API    ${input_shopee}
    ${endpoint_product_shopee}      Format String     ${endpoint_product_shopee}    ${get_shopee_channel_id}   ${BRANCH_ID}
    ${get_resp}   Get Request and return body    ${endpoint_product_shopee}
    ${list_item_id}     Create List
    :FOR    ${item_pr}    IN ZIP    ${list_product}
    \     ${jsonpath_item_id}     Format String     $..Data[?(@.KvProductSku=='{0}')].ItemId    ${item_pr}
    \     ${get_item_id}      Get data from response json    ${get_resp}    ${jsonpath_item_id}
    \     Append To List      ${list_item_id}   ${get_item_id}
    Log    ${list_item_id}
    Return From Keyword   ${list_item_id}

Mapping product with shopee thr API
    [Arguments]   ${input_shopee}    ${input_ma_hh_shopee}   ${input_product}
    ${get_map_id}  ${get_item_id}   ${get_parent_item_id}     Get map id, item id, parent item id in Shopee by item sku thr API     ${input_shopee}    ${input_ma_hh_shopee}
    ${get_shopee_channel_id}      ${get_identitykey_id}     Get shopee channel id and identitykey id thr API    ${input_shopee}
    ${get_product_id}   Get product id thr API    ${input_product}
    ${get_retailer_id}    Get RetailerID
    ${data_str}    Set Variable     {"ChannelProduct":{"BasePrice":0,"Price":0,"OnHand":0,"OnOrder":0,"Reserved":0,"EditChannelUrl":"https://banhang.uat.shopee.vn/portal/product/${get_item_id}","Id":"${get_map_id}","ItemId":${get_item_id},"ItemSku":"${input_ma_hh_shopee}","ParentItemId":${get_parent_item_id},"ChannelType":2,"Type":1,"RetailerId":${get_retailer_id},"RetailerCode":"${RETAILER_NAME}","BranchId":${BRANCH_ID},"ChannelId":${get_shopee_channel_id},"IsConnected":false,"CreatedDate":"","ModifiedDate":"","KvProductId":${get_product_id},"KvProductSku":"${input_product}","ErrorMessage":"","isSearch":true,"Status": "NORMAL","productSearchParam":"","KvProductFullName":"Dầu gội số 5"}}
    Log    ${data_str}
    ${headers}=    Create Dictionary    Authorization=${bearertoken}    Content-Type=application/json;
    Create Session    lolo    ${API_URL}    cookies=${resp.cookies}
    ${resp}=    Post Request    lolo    ${endpoint_add_product_shopee}   data=${data_str}    headers=${headers}
    Log    ${resp.request.body}
    Log    ${resp.json()}
    log    ${resp.status_code}
    Should Be Equal As Strings    ${resp.status_code}    200

Delete product mapping Shopee thr API
    [Arguments]     ${input_shopee}     ${input_product}
    ${get_item_id}      Get item id in Shopee by product code thr API      ${input_shopee}    ${input_product}
    ${get_shopee_channel_id}      ${get_identitykey_id}     Get shopee channel id and identitykey id thr API    ${input_shopee}
    ${get_product_id}   Get product id thr API    ${input_product}
    ${data_str}    Set Variable     {"ChannelId":${get_shopee_channel_id},"KvProductId":${get_product_id},"ChannelProductId":${get_item_id}}
    Log    ${data_str}
    ${headers}=    Create Dictionary    Authorization=${bearertoken}    Content-Type=application/json;
    Create Session    lolo    ${API_URL}    cookies=${resp.cookies}
    ${resp}=    Post Request    lolo    ${endpoint_delete_mapping}   data=${data_str}    headers=${headers}
    Log    ${resp.request.body}
    Log    ${resp.json()}
    log    ${resp.status_code}
    Should Be Equal As Strings    ${resp.status_code}    200

Delete product mapping Shopee if mapping is visible thr API
    [Arguments]     ${input_shopee}     ${input_product}
    ${get_item_sku}   Get item sku shopee by kv product sku   ${input_shopee}     ${input_product}
    Run Keyword If    '${get_item_sku}'!='0'   Delete product mapping Shopee thr API    ${input_shopee}     ${input_product}

Create order Shopee thr API
    [Arguments]    ${input_shopee}  ${list_product_num}      ${input_price}     ${giam_gia_dh}    ${ten_kh}       ${dia_chi}      ${phuong_xa}      ${dien_thoai}
    [Timeout]    3 minute
    Log    Tạo đơn shopee
    ${list_product}   Get Dictionary Keys      ${list_product_num}
    ${list_num}   Get Dictionary Values      ${list_product_num}
    ${get_shopee_channel_id}      ${get_identitykey_id}     Get shopee channel id and identitykey id thr API    ${input_shopee}
    ${get_item_id}   ${get_parent_item_id}     ${get_item_sku}   Get item id, parent item id and item sku in Shopee by Kv Product Sku thr API    ${input_shopee}    ${list_product[0]}
    ${status_thuoctinh}     Set Variable If    '${get_item_id}'=='${get_parent_item_id}'    False      True
    ${data_str_ko_tt}    Set Variable   {"recipientAddress":{"name":"${ten_kh}","phone":"${dien_thoai}","city":"${dia_chi}","district":"${phuong_xa}","state":"${dia_chi}","fullAddress":"${dia_chi}"},"messageToSeller":"${phuong_xa}","note":"${phuong_xa}","orderItems":[{"itemId":${get_item_id},"itemSku":"${get_item_sku}","variationOriginalPrice":${input_price},"variationQuantityPurchased":${list_num[0]}}],"trackingNo":"trackingNo","buyerUsername":"${ten_kh}","shopId":${get_identitykey_id}}
    ${data_str_tt}    Set Variable    {"recipientAddress":{"name":"${ten_kh}","phone":"${dien_thoai}","city":"${dia_chi}","district":"${phuong_xa}","state":"${dia_chi}","fullAddress":"${dia_chi}"},"messageToSeller":"${phuong_xa}","note":"${phuong_xa}","orderItems":[{"itemId":${get_parent_item_id},"itemSku":"${get_item_sku}","variationId":${get_item_id},"variationSku":"${get_item_sku}","variationOriginalPrice":${input_price},"variationQuantityPurchased": ${list_num[0]}}],"trackingNo":"trackingNo","buyerUsername":"${ten_kh}","shopId":${get_identitykey_id}}
    ${data_str}    Set Variable If    '${status_thuoctinh}'==False      ${data_str_ko_tt}     ${data_str_tt}
    Log    ${data_str}
    ${headers}    Create Dictionary    Content-Type=application/json
    Create Session    lolo    ${endpoint_shopee_tool}
    ${resp}=    Post Request    lolo    ${endpoint_shopee_create_order}   data=${data_str}    headers=${headers}
    Log    ${resp.request.body}
    Log    ${resp.json()}
    log    ${resp.status_code}
    Should Be Equal As Strings    ${resp.status_code}    201
    ${get_ma_dh_shopee}      Get data from response json     ${resp.json()}      $..orderSn
    #
    Log    create my income
    ${data_my_income}    Set Variable    {"order":{"orderSn": ${get_ma_dh_shopee},"shopId": ${get_identitykey_id},"incomeDetails":{"voucherSeller": ${giam_gia_dh}}}}
    Log    ${data_my_income}
    Create Session    lolo1    ${endpoint_shopee_tool}
    ${resp1}=    Post Request    lolo1    ${endpoint_shopee_my_income}   data=${data_my_income}    headers=${headers}
    Log    ${resp1.request.body}
    Log    ${resp1.json()}
    log    ${resp1.status_code}
    Should Be Equal As Strings    ${resp1.status_code}    201
    Log    ${get_ma_dh_shopee}
    Return From Keyword    ${get_ma_dh_shopee}

Update order status Shopee thr API
    [Arguments]     ${input_shopee}     ${input_ma_dh}    ${input_order_status}   ${logistics_status}
    Log    update order
    ${get_shopee_channel_id}      ${get_identitykey_id}     Get shopee channel id and identitykey id thr API    ${input_shopee}
    ${data_str}    Set Variable    {"orderSn": "${input_ma_dh}", "orderStatus": "${input_order_status}"}
    Log    ${data_str}
    ${headers}    Create Dictionary    Content-Type=application/json
    Create Session    lolo    ${endpoint_shopee_tool}
    ${resp}=    Post Request    lolo    ${endpoint_shopee_update_order_status}   data=${data_str}    headers=${headers}
    Log    ${resp.request.body}
    Log    ${resp.json()}
    log    ${resp.status_code}
    Should Be Equal As Strings    ${resp.status_code}    200
    #
    Log    create logistic
    ${logistics_status}   Set Variable If    '${logistics_status}'=='none'    ${EMPTY}     ${logistics_status}
    ${data_logistic}    Set Variable    {"trackingNumber": "GHN324242","logisticsStatus": "${logistics_status}","shopId": ${get_identitykey_id},"orderSn": "${input_ma_dh}"}
    Log    ${data_logistic}
    Create Session    lolo2    ${endpoint_shopee_tool}
    ${resp1}=    Post Request    lolo2    ${endpoint_shopee_create_logistics}   data=${data_logistic}    headers=${headers}
    Log    ${resp1.request.body}
    Log    ${resp1.json()}
    log    ${resp1.status_code}
    Run Keyword If    '${logistics_status}'=='LOGISTICS_READY'   Should Be Equal As Strings    ${resp1.status_code}    201    ELSE    Should Be Equal As Strings    ${resp1.status_code}    400
    #
    Log    create my income
    ${data_my_income}    Set Variable    {"order":{"orderSn": ${input_ma_dh},"shopId": ${get_identitykey_id},"incomeDetails":{"voucherSeller": 1000}}}
    Log    ${data_my_income}
    Create Session    lolo2    ${endpoint_shopee_tool}
    ${resp2}=    Post Request    lolo2    ${endpoint_shopee_my_income}   data=${data_my_income}    headers=${headers}
    Log    ${resp2.request.body}
    Log    ${resp2.json()}
    log    ${resp2.status_code}
    Should Be Equal As Strings    ${resp2.status_code}    201

Update logistics status Shopee thr API
    [Arguments]      ${input_ma_dh}    ${input_order_status}     ${logistics_status}
    Log    update order
    ${data_str}    Set Variable    {"orderSn": "${input_ma_dh}", "orderStatus": "${input_order_status}"}
    Log    ${data_str}
    ${headers}    Create Dictionary    Content-Type=application/json
    Create Session    lolo    ${endpoint_shopee_tool}
    ${resp}=    Post Request    lolo    ${endpoint_shopee_update_order_status}   data=${data_str}    headers=${headers}
    Log    ${resp.request.body}
    Log    ${resp.json()}
    log    ${resp.status_code}
    Should Be Equal As Strings    ${resp.status_code}    200
    #
    Log    update logistic
    ${data_logistic}    Set Variable    {"orderSn": "${input_ma_dh}", "logisticsStatus":"${logistics_status}"}
    Log    ${data_logistic}
    Create Session    lolo2    ${endpoint_shopee_tool}
    ${resp2}=    Post Request    lolo2    ${endpoint_shopee_update_logistics}   data=${data_logistic}    headers=${headers}
    Log    ${resp2.request.body}
    Log    ${resp2.json()}
    log    ${resp2.status_code}
    Should Be Equal As Strings    ${resp2.status_code}    200

Delete shoppee integration thr API
    [Arguments]   ${input_shopee}
    ${get_shopee_channel_id}      ${get_identitykey_id}     Get shopee channel id and identitykey id thr API    ${input_shopee}
    Create Session    lolo    ${API_URL}    cookies=${resp.cookies}
    ${resp}=    Delete Request    lolo    /shopee/${get_shopee_channel_id}?kvuniqueparam=2020
    Log    ${resp.request.body}
    Log    ${resp.json()}
    log    ${resp.status_code}
    Should Be Equal As Strings    ${resp.status_code}    200

Clone all product from KV
    [Arguments]     ${shop_shopee}
    ${get_retailer_id}      Get RetailerID
    ${get_shopee_channel_id}      ${get_identitykey_id}     Get shopee channel id and identitykey id thr API    ${input_shopee}
    ${data}    Set Variable   {"retailerId":${get_retailer_id} ,"shopId":${get_identitykey_id}}
    Log    ${data}
    Create Session    lolo1    ${endpoint_shopee_tool}
    ${headers}    Create Dictionary    Content-Type=application/json
    ${resp1}=    Post Request    lolo1    /api/products/cloneFromKv   data=${data}    headers=${headers}
    Log    ${resp1.request.body}
    Log    ${resp1.json()}
    log    ${resp1.status_code}
    Should Be Equal As Strings    ${resp1.status_code}    200

Remove all items by shop
    [Arguments]     ${input_shopee}
    ${get_shopee_channel_id}      ${get_identitykey_id}     Get shopee channel id and identitykey id thr API    ${input_shopee}
    ${data}    Set Variable   {"shopid":${get_identitykey_id}}
    Log    ${data}
    Create Session    lolo1    ${endpoint_shopee_tool}
    ${headers}    Create Dictionary    Content-Type=application/json
    ${resp1}=    Post Request    lolo1    /api/v1/items/remove_all   data=${data}    headers=${headers}
    Log    ${resp1.request.body}
    Log    ${resp1.json()}
    log    ${resp1.status_code}
    Should Be Equal As Strings    ${resp1.status_code}    200

Create product normal
    [Arguments]     ${input_shopee}      ${item_sku}     ${ten_sp}     ${gia_ban}    ${ton}
    ${get_shopee_channel_id}      ${get_identitykey_id}     Get shopee channel id and identitykey id thr API    ${input_shopee}
    ${data}    Set Variable   {"shopId":${get_identitykey_id},"itemSku":"${item_sku}","name":"${ten_sp}","price":${gia_ban},"stock":${ton},"status":"NORMAL","hasVariation":false}
    Log    ${data}
    Create Session    lolo1    ${endpoint_shopee_tool}
    ${headers}    Create Dictionary    Content-Type=application/json
    ${resp1}=    Post Request    lolo1    /api/products   data=${data}    headers=${headers}
    Log    ${resp1.request.body}
    Log    ${resp1.json()}
    log    ${resp1.status_code}
    Should Be Equal As Strings    ${resp1.status_code}    200

Create product variation
    [Arguments]     ${input_shopee}      ${item_sku}     ${ten_item}     ${gia_ban}    ${ton}    ${var_sku1}   ${ten_var1}   ${gia_ban_Var1}   ${ton_var1}   ${var_sku2}   ${ten_var2}   ${gia_ban_Var2}   ${ton_var2}
    ${get_retailer_id}      Get RetailerID
    ${get_shopee_channel_id}      ${get_identitykey_id}     Get shopee channel id and identitykey id thr API    ${input_shopee}
    ${data}    Set Variable   {"shopId":${get_identitykey_id},"itemSku":"${item_sku}","name":"${ten_item},"price":${gia_ban},"stock":${ton}"retailerId":${get_retailer_id},"hasVariation":true,"status":"NORMAL","variations":[{"variationSku":"${var_sku1}","name":"${ten_var1}","price":${gia_ban_Var1},"stock":${ton_var1}},{"variationSku":"${var_sku2}","name":"${ten_var2}","price":${gia_ban_Var2},"stock":${ton_var2}}]}
    Log    ${data}
    Create Session    lolo1    ${endpoint_shopee_tool}
    ${headers}    Create Dictionary    Content-Type=application/json
    ${resp1}=    Post Request    lolo1    /api/products   data=${data}    headers=${headers}
    Log    ${resp1.request.body}
    Log    ${resp1.json()}
    log    ${resp1.status_code}
    Should Be Equal As Strings    ${resp1.status_code}    200

Get item sku shopee by kv product sku
    [Arguments]     ${input_shopee}    ${input_ma_hh}
    ${get_shopee_channel_id}      ${get_identitykey_id}     Get shopee channel id and identitykey id thr API    ${input_shopee}
    ${endpoint_product_shopee}      Format String     ${endpoint_product_shopee}    ${get_shopee_channel_id}   ${BRANCH_ID}
    ${get_resp}   Get Request and return body    ${endpoint_product_shopee}
    ${get_item_sku}      Get data from response json    ${get_resp}    $..Data[?(@.KvProductSku=='${input_ma_hh}')].ItemSku
    Return From Keyword       ${get_item_sku}

Remove normal product
    [Arguments]     ${input_shopee}    ${input_ma_hh}
    ${get_item_id}      Get item id in Shopee by product code thr API    ${input_shopee}    ${input_ma_hh}
    ${get_shopee_channel_id}      ${get_identitykey_id}     Get shopee channel id and identitykey id thr API    ${input_shopee}
    ${data}    Set Variable   {"shopid":${get_identitykey_id},"item_id":${get_item_id}}
    Log    ${data}
    Create Session    lolo1    ${endpoint_shopee_tool}
    ${headers}    Create Dictionary    Content-Type=application/json
    ${resp1}=    Post Request    lolo1    /api/products   data=${data}    headers=${headers}
    Log    ${resp1.request.body}
    Log    ${resp1.json()}
    log    ${resp1.status_code}
    Should Be Equal As Strings    ${resp1.status_code}    200

Assert get item id in Shopee by kv product code succeed
    [Arguments]     ${input_shopee}     ${input_product}
    ${get_item_id}    ${get_parent_item_id}    ${get_item_sku_id}    Get item id, parent item id and item sku in Shopee by Kv Product Sku thr API    ${input_shopee}      ${input_product}
    Should Not Be Equal As Strings    ${get_item_id}    0
    Return From Keyword    ${get_item_id}   ${get_parent_item_id}

Create list audit trail for map product Shopee
    [Arguments]     ${input_shopee}      ${ma_hh}      ${ma_hh_shopee}
    ${get_item_id}   ${get_parent_item_id}      Wait Until Keyword Succeeds    10x    2x   Assert get item id in Shopee by kv product code succeed    ${input_shopee}      ${ma_hh}
    ${list_audit}     Create List     Thêm mới liên kết hàng hóa: <br/>Shopee shop: ${input_shopee} <br/>- <a href='#/Products?code=${ma_hh}' target='_blank'>${ma_hh}</a> liên kết với <a href='https://banhang.uat.shopee.vn/portal/product/${get_parent_item_id}' target='_blank'>${get_item_id}</a> - ${ma_hh_shopee}<br/>
    Log    ${list_audit}
    Return From Keyword    ${list_audit}

Check status order and status delivery Shopee
    [Arguments]     ${list_trangthai_shopee}
    ${get_length}   Get Length    ${list_trangthai_shopee}
    ${end_status}     Minus     ${get_length}   1
    ${end_status}   Replace floating point    ${end_status}
    Log   check trạng thái đơn hàng, vận đơn
    ${result_trangthai_hoadon}      Run Keyword If      '${list_trangthai_shopee[${end_status}]}'=='READY_TO_SHIP'    Set Variable    Chưa giao hàng      ELSE     Set Variable    Đang xử lý
    ${result_trangthai_vandon}      Run Keyword If      '${list_trangthai_shopee[${end_status}]}'=='READY_TO_SHIP'    Set Variable   Chưa giao hàng    ELSE IF      '${list_trangthai_shopee[${end_status}]}'=='CANCELLED'     Set Variable    Đang chuyển hoàn    ELSE IF     '${list_trangthai_shopee[${end_status}]}'=='SHIPPED' or '${list_trangthai_shopee[${end_status}]}'=='TO_CONFIRM_RECEIVE'    Set Variable   Đang giao hàng    ELSE IF   '${list_trangthai_shopee[${end_status}]}'=='COMPLETED'      Set Variable   Giao thành công
    ${result_status_vandon}      Run Keyword If      '${result_trangthai_vandon}'=='Đang lấy hàng'    Set Variable    7   ELSE IF      '${result_trangthai_vandon}'=='Đã lấy hàng'    Set Variable   9   ELSE IF     '${result_trangthai_vandon}'=='Đang giao hàng'    Set Variable   2    ELSE IF   '${result_trangthai_vandon}'=='Giao thành công'     Set Variable   3      ELSE    Set Variable    4
    Return From Keyword    ${result_trangthai_hoadon}       ${result_trangthai_vandon}      ${result_status_vandon}
