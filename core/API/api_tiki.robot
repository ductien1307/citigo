*** Settings ***
Resource          api_access.robot
Resource          api_danhmuc_hanghoa.robot
Library           DateTime

*** Variables ***
${mockapi_tiki}   https://tikimockapi.kvpos.com:9016
${endpoint_product_tiki}    /omnichannel/getproductbychannelid?ChannelId={0}&BranchId={1}&channelType=3
${endpoint_tiki}      /tikis
${endpoint_mapping_tiki}      /omnichannel/addproductandmapping?kvuniqueparam=2020
${endpoint_delete_mapping}    /omnichannel/deleteProductMapping?kvuniqueparam=2020

*** Keywords ***
Get tiki channel id thr API
    [Arguments]     ${input_shop_tiki}
    ${jsonpath_id_tiki}    Format String    $..Data[?(@.Name=='{0}')].Id    ${input_shop_tiki}
    ${get_channel_tiki_id}    Get data from API    ${endpoint_tiki}    ${jsonpath_id_tiki}
    Return From Keyword    ${get_channel_tiki_id}

Get id and item id in Tiki by item sku thr API
    [Arguments]     ${input_shop_tiki}    ${input_ma_hh_tiki}
    ${get_channel_tiki_id}   Get tiki channel id thr API    ${input_shop_tiki}
    ${endpoint_product_tiki}      Format String     ${endpoint_product_tiki}    ${get_channel_tiki_id}   ${BRANCH_ID}
    ${get_resp}   Get Request and return body    ${endpoint_product_tiki}
    ${jsonpath_item_id}     Format String     $..Data[?(@.ItemSku=='{0}')].ItemId    ${input_ma_hh_tiki}
    ${get_item_id}      Get data from response json    ${get_resp}    $..Data[?(@.ItemSku=='${input_ma_hh_tiki}')].ItemId
    ${get_map_id}      Get data from response json    ${get_resp}    $..Data[?(@.ItemSku=='${input_ma_hh_tiki}')].Id
    Return From Keyword   ${get_item_id}      ${get_map_id}

Get item id in Tiki by product code thr API
    [Arguments]     ${input_shop_tiki}    ${input_product}
    ${get_channel_tiki_id}   Get tiki channel id thr API    ${input_shop_tiki}
    ${endpoint_product_tiki}      Format String     ${endpoint_product_tiki}    ${get_channel_tiki_id}   ${BRANCH_ID}
    ${get_resp}   Get Request and return body    ${endpoint_product_tiki}
    ${jsonpath_item_id}   Set Variable    $..Data[?(@.KvProductSku=='${input_product}')].ItemId
    ${get_item_id}      Get data from response json    ${get_resp}    ${jsonpath_item_id}
    Return From Keyword   ${get_item_id}

Get list item id by list product code in Tiki thr API
    [Arguments]     ${input_shop_tiki}    ${list_product}
    ${get_channel_tiki_id}   Get tiki channel id thr API    ${input_shop_tiki}
    ${endpoint_product_tiki}      Format String     ${endpoint_product_tiki}    ${get_channel_tiki_id}   ${BRANCH_ID}
    ${get_resp}   Get Request and return body    ${endpoint_product_tiki}
    ${list_item_id}     Create List
    :FOR    ${item_pr}    IN ZIP    ${list_product}
    \     ${jsonpath_item_id}     Format String     $..Data[?(@.KvProductSku=='{0}')].ItemId    ${item_pr}
    \     ${get_item_id}      Get data from response json    ${get_resp}    ${jsonpath_item_id}
    \     Append To List      ${list_item_id}   ${get_item_id}
    Log    ${list_item_id}
    Return From Keyword   ${list_item_id}

Create order Tiki thr API
    [Arguments]    ${input_shop_tiki}  ${list_product_num}      ${list_price}     ${list_discount}       ${list_discount_point}   ${ten_kh}     ${dia_chi}     ${thanh_pho}    ${khu_vuc}      ${phuong_xa}      ${dien_thoai}
    [Timeout]    3 minute
    ${list_product}   Get Dictionary Keys      ${list_product_num}
    ${list_num}   Get Dictionary Values      ${list_product_num}
    ${list_item_id}   Get list item id by list product code in Tiki thr API     ${input_shop_tiki}  ${list_product}
    ${get_cur_date}     Get Current Date    result_format=%Y-%m-%d %H:%M:%S
    ${date}   Add Time To Date    ${get_cur_date}     1 hour    result_format=%Y-%m-%d %H:%M:%S
    ${length}     Get Length    ${list_item_id}
    ${dia_chi}    Set Variable If    '${dia_chi}'=='none'    ${EMPTY}   ${dia_chi}
    ${khu_vuc}    Set Variable If    '${khu_vuc}'=='none'    ${EMPTY}   ${khu_vuc}
    ${phuong_xa}    Set Variable If    '${phuong_xa}'=='none'    ${EMPTY}   ${phuong_xa}
    ${dien_thoai}    Set Variable If    '${dien_thoai}'=='none'    ${EMPTY}   ${dien_thoai}
    ${thanh_pho}    Set Variable If    '${thanh_pho}'=='none'    ${EMPTY}   ${thanh_pho}
    ${data_item}      Create List
    :FOR    ${index}      IN RANGE    ${length}
    \     Append To List     ${data_item}    {"id":147111800,"product_id":${list_item_id[${index}]},"product_name":"Áo lót đúc siêu nâng ngực không gọng bản to - A170 - Hồng - 34A/75A","sku":"2811659803540","original_sku":"","qty":${list_num[${index}]},"price":${list_price[${index}]} ,"confirmation_status":"confirmed","confirmed_at":"2020-05-18 20:41:20","must_confirmed_before_at":"2020-05-19 12:00:00","warehouse_code":"vln","inventory_type":"backorder","serial_number":[],"imei":[],"discount":{"discount_amount":${list_discount[${index}]},"discount_coupon":1000,"discount_tiki_point":${list_discount_point[${index}]}},"fees":[{"fee_type_id":1,"name":"Chiết khấu","key":"percent_per_item_sales_value","fee_total_amount":4250},{"fee_type_id":2,"name":"Phí thanh toán","key":"payment_processing_fee","fee_total_amount":0},{"fee_type_id":23,"name":"Phí cố định","key":"base_fee","fee_total_amount":10000},{"fee_type_id":24,"name":"Phí lấy hàng","key":"pickup_fee","fee_total_amount":5000}],"fee_total":19250,"seller_id":112944}
    Log     ${data_item}
    ${data_item}    Convert List to String    ${data_item}
    Log    ${data_item}
    ${data_str}    Set Variable      {"order_code":"979025469","coupon_code":null,"status":"queueing","total_price_before_discount":85000,"total_price_after_discount":76748,"created_at":"${date}","updated_at":"${date}","purchased_at":"${date}","fulfillment_type":"tiki_delivery","note":"","deliveryConfirmed":"","delivery_confirmed_at":"","is_rma":0,"tax":{"code":null,"name":null,"address":null},"discount":{"discount_amount":8252,"discount_coupon":0,"discount_tiki_point":0},"shipping":{"name":"${ten_kh}","street":"${dia_chi}","ward":"${phuong_xa}","city":"${khu_vuc}","region":"${thanh_pho}","country":"VN","phone":"${dien_thoai}","email":"","estimate_description":"Dự kiến giao hàng vào Thứ hai, 25/05/2020","shipping_fee":0},"items":[${data_item}],"payment":{"payment_method":"zalopay","updated_at":"${date}","description":""},"handling_fee":0,"collectable_total_price":0}
    Log    ${data_str}
    ${headers}    Create Dictionary    Content-Type=application/json
    Create Session    lolo    ${mockapi_tiki}
    ${resp}=    Post Request    lolo    /orders/   data=${data_str}    headers=${headers}
    Log    ${resp.request.body}
    Log    ${resp.json()}
    log    ${resp.status_code}
    Should Be Equal As Strings    ${resp.status_code}    200
    ${get_ma_dh_tiki}      Get data from response json     ${resp.json()}      $..order_code
    Return From Keyword    ${get_ma_dh_tiki}

Update status delivery in Tiki order
    [Arguments]   ${get_ma_dh_tiki}      ${input_trang_thai_giao}
    ${data_str}    Set Variable  {"status":"${input_trang_thai_giao}"}
    Log    ${data_str}
    ${headers}    Create Dictionary    Content-Type=application/json
    Create Session    lolo    ${mockapi_tiki}
    ${resp}=    Put Request    lolo    /orders/${get_ma_dh_tiki}    data=${data_str}    headers=${headers}
    Log    ${resp.request.body}
    Log    ${resp.json()}
    log    ${resp.status_code}
    Should Be Equal As Strings    ${resp.status_code}    200

Mapping product with tiki thr API
    [Arguments]   ${input_shop_tiki}    ${input_ma_hh_tiki}   ${input_product}
    ${get_item_id}  ${get_map_id}   Get id and item id in Tiki by item sku thr API        ${input_shop_tiki}    ${input_ma_hh_tiki}
    ${get_channel_id}   Get tiki channel id thr API      ${input_shop_tiki}
    ${get_product_id}   Get product id thr API    ${input_product}
    ${get_retailer_id}    Get RetailerID
    ${data_str}    Set Variable     {"ChannelProduct":{"BasePrice":0,"Price":0,"OnHand":0,"OnOrder":0,"Reserved":0,"EditChannelUrl":"https://sellercenter.tiki.vn/#/products/${get_item_id}","Id":"${get_map_id}","ItemId":${get_item_id},"ItemName":"Bộ Búp Bê Thời Trang Sariel 7721-7","ItemSku":"${input_ma_hh_tiki}","ParentItemId":2783283,"ChannelType":3,"Type":1,"RetailerId":${get_retailer_id},"RetailerCode":"${RETAILER_NAME}","BranchId":${BRANCH_ID},"ChannelId":${get_channel_id},"IsConnected":false,"CreatedDate":"","KvProductId":${get_product_id},"KvProductSku":"${input_product}","ErrorMessage":"","Status":"inactive","isSearch":true,"productSearchParam":"${input_product}","KvProductFullName":"chuột quang xám"}}
    Log    ${data_str}
    ${headers}=    Create Dictionary    Authorization=${bearertoken}    Content-Type=application/json;
    Create Session    lolo    ${API_URL}    cookies=${resp.cookies}
    ${resp}=    Post Request    lolo    ${endpoint_mapping_tiki}   data=${data_str}    headers=${headers}
    Log    ${resp.request.body}
    Log    ${resp.json()}
    log    ${resp.status_code}
    Should Be Equal As Strings    ${resp.status_code}    200

Delete product mapping Tiki thr API
    [Arguments]     ${input_shop_tiki}     ${input_product}
    ${get_item_id}      Get item id in Tiki by product code thr API      ${input_shop_tiki}    ${input_product}
    ${get_channel_id}   Get tiki channel id thr API      ${input_shop_tiki}
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

Delete tiki integration thr API
    [Arguments]   ${input_tiki}
    ${get_channel_id}      Get tiki channel id thr API       ${input_tiki}
    Create Session    lolo    ${API_URL}    cookies=${resp.cookies}
    ${resp}=    Delete Request    lolo    /tiki/${get_channel_id}?kvuniqueparam=2020
    Log    ${resp.request.body}
    Log    ${resp.json()}
    log    ${resp.status_code}
    Should Be Equal As Strings    ${resp.status_code}    200

Get item sku tiki by kv product sku
    [Arguments]     ${input_tiki}    ${input_ma_hh}
    ${get_channel_id}       Get tiki channel id thr API    ${input_tiki}
    ${endpoint_product_tiki}      Format String     ${endpoint_product_tiki}    ${get_channel_id}   ${BRANCH_ID}
    ${get_resp}   Get Request and return body    ${endpoint_product_tiki}
    ${get_item_sku}      Get data from response json    ${get_resp}    $..Data[?(@.KvProductSku=='${input_ma_hh}')].ItemSku
    Return From Keyword       ${get_item_sku}

Assert get item id in Tiki by kv product code succeed
    [Arguments]     ${input_shop_tiki}     ${input_product}
    ${get_item_id}   Get item id in Tiki by product code thr API    ${input_shop_tiki}     ${input_product}
    Should Not Be Equal As Strings    ${get_item_id}    0
    Return From Keyword    ${get_item_id}

Delete product mapping Tiki if mapping is visible thr API
    [Arguments]     ${input_shop_tiki}     ${input_product}
    ${get_item_sku}   Get item sku tiki by kv product sku      ${input_shop_tiki}     ${input_product}
    Run Keyword If    '${get_item_sku}'!='0'    Delete product mapping Tiki thr API    ${input_shop_tiki}     ${input_product}

Create list audit trail for map product Tiki
    [Arguments]     ${shop_tiki}      ${ma_hh}      ${ma_hh_tiki}
    ${get_item_id}      Wait Until Keyword Succeeds    10x    5s   Assert get item id in Tiki by kv product code succeed    ${shop_tiki}  ${ma_hh}
    ${list_audit}     Create List   Thêm mới liên kết hàng hóa: <br/>Tiki shop: ${shop_tiki} <br/>- <a href='#/Products?code=${ma_hh}' target='_blank'>${ma_hh}</a> liên kết với <a href='https://sellercenter.tiki.vn/#/products/${get_item_id}' target='_blank'>${get_item_id}</a> - ${ma_hh_tiki}<br/>
    Log    ${list_audit}
    Return From Keyword    ${list_audit}

Computaton total order Tiki
    [Arguments]     ${list_nums}    ${list_price}   ${list_discount}   ${list_discount_point}
    ${list_gg_sp}   Create List
    :FOR    ${item_num}   ${item_gg}    ${item_point}    IN ZIP      ${list_nums}    ${list_discount}   ${list_discount_point}
    \     ${item_gg_sp}     Minus       ${item_gg}      ${item_point}
    \     ${item_gg_sp}     Devision    ${item_gg_sp}   ${item_num}
    \     ${item_gg_sp}     Evaluate    round(${item_gg_sp},0)
    \     Append To List    ${list_gg_sp}   ${item_gg_sp}
    ${list_result_thanhtien}    Create List
    :FOR    ${item_num}     ${item_price}   ${item_gg_sp}     IN ZIP      ${list_nums}    ${list_price}     ${list_gg_sp}
    \     ${result_giamoi}    Minus     ${item_price}   ${item_gg_sp}
    \     ${result_thanhtien}    Multiplication and round    ${result_giamoi}    ${item_num}
    \     Append To List    ${list_result_thanhtien}    ${result_thanhtien}
    Log    ${list_result_thanhtien}
    ${result_tongtienhang}    Sum values in list    ${list_result_thanhtien}
    Return From Keyword   ${result_tongtienhang}

Check status order and status delivery Tiki
    [Arguments]     ${list_trangthai_tiki}
    ${get_length}   Get Length    ${list_trangthai_tiki}
    ${end_status}     Minus     ${get_length}   1
    ${end_status}   Replace floating point    ${end_status}
    ${input_trangthai_tiki}   Set Variable    ${list_trangthai_tiki[${end_status}]}
    ${result_trangthai_hoadon}      Run Keyword If      '${input_trangthai_tiki}'=='processing' or '${input_trangthai_tiki}'=='queueing'     Set Variable    Phiếu tạm    ELSE IF     '${input_trangthai_tiki}'=='canceled'     Set Variable    Đã hủy      ELSE      Set Variable    Đang xử lý
    ${result_trangthai_vandon}      Run Keyword If      '${input_trangthai_tiki}'=='picking'    Set Variable    Đang lấy hàng   ELSE IF      '${input_trangthai_tiki}'=='packaging' or '${input_trangthai_tiki}'=='finished_packing' or '${input_trangthai_tiki}'=='ready_to_ship'    Set Variable    Đã lấy hàng    ELSE IF     '${input_trangthai_tiki}'=='shipping' or '${input_trangthai_tiki}'=='handover_to_partner'    Set Variable   Đang giao hàng    ELSE IF   '${input_trangthai_tiki}'=='successful_delivery' or '${input_trangthai_tiki}'=='complete'     Set Variable   Giao thành công      ELSE IF       '${input_trangthai_tiki}'=='canceled'    Set Variable    Đã hủy    ELSE    Set Variable    Đang chuyển hoán
    ${result_status_vandon}      Run Keyword If      '${result_trangthai_vandon}'=='Đang lấy hàng'    Set Variable    7   ELSE IF      '${result_trangthai_vandon}'=='Đã lấy hàng'    Set Variable   9   ELSE IF     '${result_trangthai_vandon}'=='Đang giao hàng'    Set Variable   2    ELSE IF   '${result_trangthai_vandon}'=='Giao thành công'     Set Variable   3      ELSE    Set Variable    4
    Return From Keyword    ${result_trangthai_hoadon}       ${result_trangthai_vandon}      ${result_status_vandon}
