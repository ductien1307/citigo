*** Settings ***
Resource          api_access.robot
Resource          api_danhmuc_hanghoa.robot
Library           DateTime

*** Variables ***
${endpoint_sendo}     /sendos
${sendo_mock_api}    https://api-hcm.kvpos.com:9017/api
${endpoint_product_sendo}     /omnichannel/getproductbychannelid?ChannelId={0}&BranchId={1}&channelType=4
${endpoint_add_product_sendo}       /omnichannel/addproductandmapping?kvuniqueparam=2020
${endpoint_delete_mapping}    /omnichannel/deleteProductMapping?kvuniqueparam=2020

*** Keywords ***
Get Sendo channel id thr API
    [Arguments]     ${input_sendo}
    ${get_resp}     Get Request and return body    ${endpoint_sendo}
    ${jsonpath_sendo_id}    Format String    $..Data[?(@.Name=='{0}')].Id    ${input_sendo}
    ${get_sendo_channel_id}    Get data from response json     ${get_resp}   ${jsonpath_sendo_id}
    Return From Keyword    ${get_sendo_channel_id}

Get Sendo channel id and identitykey id thr API
    [Arguments]     ${input_sendo}
    ${get_resp}     Get Request and return body    ${endpoint_sendo}
    ${jsonpath_identityke_id}    Format String    $..Data[?(@.Name=='{0}')].IdentityKey    ${input_sendo}
    ${jsonpath_sendo_id}    Format String    $..Data[?(@.Name=='{0}')].Id    ${input_sendo}
    ${get_identitykey_id}    Get data from response json     ${get_resp}   ${jsonpath_identityke_id}
    ${get_sendo_channel_id}    Get data from response json     ${get_resp}   ${jsonpath_sendo_id}
    Return From Keyword    ${get_sendo_channel_id}     ${get_identitykey_id}

Get map id, item id, parent item id in Sendo by item sku thr API
    [Arguments]     ${input_sendo}    ${input_ma_hh_sendo}
    ${get_sendo_channel_id}      ${get_identitykey_id}     Get Sendo channel id and identitykey id thr API    ${input_sendo}
    ${endpoint_product_sendo}      Format String     ${endpoint_product_sendo}    ${get_sendo_channel_id}   ${BRANCH_ID}
    ${get_resp}   Get Request and return body    ${endpoint_product_sendo}
    ${jsonpath_item_id}     Format String     $..Data[?(@.ItemSku=='{0}')].ItemId    ${input_ma_hh_sendo}
    ${get_item_id}      Get data from response json    ${get_resp}    $..Data[?(@.ItemSku=='${input_ma_hh_sendo}')].ItemId
    ${get_map_id}      Get data from response json    ${get_resp}    $..Data[?(@.ItemSku=='${input_ma_hh_sendo}')].Id
    ${get_parent_item_id}      Get data from response json    ${get_resp}    $..Data[?(@.ItemSku=='${input_ma_hh_sendo}')].ParentItemId
    Return From Keyword       ${get_map_id}   ${get_item_id}    ${get_parent_item_id}

Get item id, parent item id and item sku in Sendo by Kv Product Sku thr API
    [Arguments]     ${input_sendo}    ${input_product}
    ${get_sendo_channel_id}      ${get_identitykey_id}     Get Sendo channel id and identitykey id thr API    ${input_sendo}
    ${endpoint_product_sendo}      Format String     ${endpoint_product_sendo}    ${get_sendo_channel_id}   ${BRANCH_ID}
    ${get_resp}   Get Request and return body    ${endpoint_product_sendo}
    ${get_item_id}      Get data from response json    ${get_resp}    $..Data[?(@.KvProductSku=='${input_product}')].ItemId
    ${get_parent_item_id}      Get data from response json    ${get_resp}    $..Data[?(@.KvProductSku=='${input_product}')].ParentItemId
    ${get_item_sku_id}      Get data from response json    ${get_resp}    $..Data[?(@.KvProductSku=='${input_product}')].ItemSku
    Return From Keyword        ${get_item_id}    ${get_parent_item_id}    ${get_item_sku_id}

Get item id in Sendo by product code thr API
    [Arguments]     ${input_sendo}    ${input_product}
    ${get_sendo_channel_id}      ${get_identitykey_id}     Get sendo channel id and identitykey id thr API    ${input_sendo}
    ${endpoint_product_sendo}      Format String     ${endpoint_product_sendo}    ${get_sendo_channel_id}   ${BRANCH_ID}
    ${get_resp}   Get Request and return body    ${endpoint_product_sendo}
    ${jsonpath_item_id}   Set Variable    $..Data[?(@.KvProductSku=='${input_product}')].ItemId
    ${get_item_id}      Get data from response json    ${get_resp}    ${jsonpath_item_id}
    Return From Keyword   ${get_item_id}

Get list item id by list product code in Sendo thr API
    [Arguments]     ${input_sendo}    ${list_product}
    ${get_sendo_channel_id}      ${get_identitykey_id}     Get Sendo channel id and identitykey id thr API    ${input_sendo}
    ${endpoint_product_sendo}      Format String     ${endpoint_product_sendo}    ${get_sendo_channel_id}   ${BRANCH_ID}
    ${get_resp}   Get Request and return body    ${endpoint_product_sendo}
    ${list_item_id}     Create List
    :FOR    ${item_pr}    IN ZIP    ${list_product}
    \     ${jsonpath_item_id}     Format String     $..Data[?(@.KvProductSku=='{0}')].ItemId    ${item_pr}
    \     ${get_item_id}      Get data from response json    ${get_resp}    ${jsonpath_item_id}
    \     Append To List      ${list_item_id}   ${get_item_id}
    Log    ${list_item_id}
    Return From Keyword   ${list_item_id}

Mapping product with Sendo thr API
    [Arguments]   ${input_sendo}    ${input_ma_hh_sendo}   ${input_product}
    ${get_map_id}  ${get_item_id}   ${get_parent_item_id}     Get map id, item id, parent item id in Sendo by item sku thr API     ${input_sendo}    ${input_ma_hh_sendo}
    ${get_sendo_channel_id}      ${get_identitykey_id}     Get Sendo channel id and identitykey id thr API    ${input_sendo}
    ${get_product_id}   Get product id thr API    ${input_product}
    ${get_retailer_id}    Get RetailerID
    ${data_str}    Set Variable        {"ChannelProduct":{"BasePrice":0,"Price":0,"OnHand":0,"OnOrder":0,"Reserved":0,"EditChannelUrl":"https://ban.sendo.vn/shop#product/detail/${get_parent_item_id}","Id":"${get_map_id}","ItemId":"${get_item_id}","ItemName":"","ItemSku":"${input_ma_hh_sendo}","ParentItemId":"${get_parent_item_id}","ChannelType":4,"Type":2,"RetailerId":${get_retailer_id},"RetailerCode":"${RETAILER_NAME}","BranchId":${BRANCH_ID},"ChannelId":${get_sendo_channel_id},"IsConnected":false,"CreatedDate":"","ModifiedDate":"","KvProductId":${get_product_id},"KvProductSku":"${input_product}","ErrorMessage":"","Status":"active","isSearch":true,"productSearchParam":"${input_product}","KvProductFullName":""}}
    Log    ${data_str}
    ${headers}=    Create Dictionary      Content-Type=application/json;charset=UTF-8
    Create Session    lolo    ${API_URL}    cookies=${resp.cookies}
    ${resp}=    Post Request    lolo    ${endpoint_add_product_sendo}   data=${data_str}    headers=${headers}
    Log    ${resp.request.body}
    Log    ${resp.json()}
    log    ${resp.status_code}
    Should Be Equal As Strings    ${resp.status_code}    200

Delete product mapping Sendo thr API
    [Arguments]     ${input_sendo}     ${input_product}
    ${get_item_id}      Get item id in Sendo by product code thr API      ${input_sendo}    ${input_product}
    ${get_sendo_channel_id}      ${get_identitykey_id}     Get Sendo channel id and identitykey id thr API    ${input_sendo}
    ${get_product_id}   Get product id thr API    ${input_product}
    ${data_str}    Set Variable     {"ChannelId":${get_sendo_channel_id},"KvProductId":${get_product_id},"ChannelProductId":"${get_item_id}"}
    Log    ${data_str}
    ${headers}=    Create Dictionary    Authorization=${bearertoken}    Content-Type=application/json;
    Create Session    lolo    ${API_URL}    cookies=${resp.cookies}
    ${resp}=    Post Request    lolo    ${endpoint_delete_mapping}   data=${data_str}    headers=${headers}
    Log    ${resp.request.body}
    Log    ${resp.json()}
    log    ${resp.status_code}
    Should Be Equal As Strings    ${resp.status_code}    200

Delete product mapping Sendo if mapping is visible thr API
    [Arguments]     ${input_sendo}     ${input_product}
    ${get_item_sku}   Get item sku Sendo by kv product sku   ${input_sendo}     ${input_product}
    Run Keyword If    '${get_item_sku}'!='0'   Delete product mapping Sendo thr API    ${input_sendo}     ${input_product}

Delete Sendo integration thr API
    [Arguments]   ${input_sendo}
    ${get_sendo_channel_id}      ${get_identitykey_id}     Get Sendo channel id and identitykey id thr API    ${input_sendo}
    Create Session    lolo    ${API_URL}    cookies=${resp.cookies}
    ${resp}=    Delete Request    lolo    /sendo/${get_sendo_channel_id}?kvuniqueparam=2020
    Log    ${resp.request.body}
    Log    ${resp.json()}
    log    ${resp.status_code}
    Should Be Equal As Strings    ${resp.status_code}    200

Get item sku Sendo by kv product sku
    [Arguments]     ${input_sendo}    ${input_ma_hh}
    ${get_sendo_channel_id}      ${get_identitykey_id}     Get sendo channel id and identitykey id thr API    ${input_sendo}
    ${endpoint_product_sendo}      Format String     ${endpoint_product_sendo}    ${get_sendo_channel_id}   ${BRANCH_ID}
    ${get_resp}   Get Request and return body    ${endpoint_product_sendo}
    ${get_item_sku}      Get data from response json    ${get_resp}    $..Data[?(@.KvProductSku=='${input_ma_hh}')].ItemSku
    Return From Keyword       ${get_item_sku}

Get item id and parent item id in Sendo by product code thr API
    [Arguments]     ${input_sendo}    ${input_product}
    ${get_sendo_channel_id}      ${get_identitykey_id}     Get sendo channel id and identitykey id thr API    ${input_sendo}
    ${endpoint_product_sendo}      Format String     ${endpoint_product_sendo}    ${get_sendo_channel_id}   ${BRANCH_ID}
    ${get_resp}   Get Request and return body    ${endpoint_product_sendo}
    ${get_item_id}      Get data from response json    ${get_resp}    $..Data[?(@.KvProductSku=='${input_product}')].ItemId
    ${get_parent_item_id}      Get data from response json    ${get_resp}    $..Data[?(@.KvProductSku=='${input_product}')].ParentItemId
    Return From Keyword   ${get_item_id}      ${get_parent_item_id}

Assert get item id in Sendo by kv product code succeed
    [Arguments]     ${input_sendo}     ${input_product}
    ${get_item_id}      ${get_parent_item_id}  Get item id and parent item id in Sendo by product code thr API   ${input_sendo}     ${input_product}
    Should Not Be Equal As Strings    ${get_item_id}    0
    Return From Keyword    ${get_item_id}      ${get_parent_item_id}

Create list audit trail for map product Sendo
    [Arguments]     ${input_sendo}      ${ma_hh}      ${ma_hh_sendo}
    ${get_item_id}      ${get_parent_item_id}     Wait Until Keyword Succeeds    10x    2x   Assert get item id in Sendo by kv product code succeed    ${input_sendo}      ${ma_hh}
    ${list_audit}     Create List     Thêm mới liên kết hàng hóa: <br/>Sendo shop: ${input_sendo} <br/>- <a href='#/Products?code=${ma_hh}' target='_blank'>${ma_hh}</a> liên kết với <a href='https://ban.sendo.vn/shop#product/detail/${get_parent_item_id}' target='_blank'>${get_item_id}</a> - ${ma_hh_sendo}<br/>
    Log    ${list_audit}
    Return From Keyword    ${list_audit}

Get product variant id and attribute hash by product code
    [Arguments]     ${input_sendo}    ${input_product}
    ${get_item_id}      ${var_id}   Get item id and parent item id in Sendo by product code thr API    ${input_sendo}    ${input_product}
    ${attr_hash}   Run Keyword If    ${get_item_id}==${get_parent_item_id}    Set Variable    null    ELSE      Remove String   ${get_item_id}    ${var_id}_
    Return From Keyword   ${var_id}     ${attr_hash}

Get list product variant id and attribute hash by list product code
    [Arguments]     ${input_sendo}    ${list_product}
    ${get_sendo_channel_id}      ${get_identitykey_id}     Get sendo channel id and identitykey id thr API    ${input_sendo}
    ${endpoint_product_sendo}      Format String     ${endpoint_product_sendo}    ${get_sendo_channel_id}   ${BRANCH_ID}
    ${get_resp}   Get Request and return body    ${endpoint_product_sendo}
    ${list_var_id}    Create List
    ${list_attr_hash}     Create List
    :FOR      ${item_pr}    IN ZIP      ${list_product}
    \     ${get_item_id}      Get data from response json    ${get_resp}    $..Data[?(@.KvProductSku=='${item_pr}')].ItemId
    \     ${get_var_id}      Get data from response json    ${get_resp}    $..Data[?(@.KvProductSku=='${item_pr}')].ParentItemId
    \     ${attr_hash}   Run Keyword If    ${get_item_id}==${get_var_id}    Set Variable    null    ELSE      Remove String   ${get_item_id}    ${get_var_id}_
    \     Append To List     ${list_var_id}   ${get_var_id}
    \     Append To List     ${list_attr_hash}   ${attr_hash}
    Return From Keyword   ${list_var_id}      ${list_attr_hash}

Create order Sendo
    [Arguments]     ${input_sendo}    ${list_product_num}      ${list_price}    ${discount}     ${ten_kh}     ${dia_chi}      ${phuong_xa}      ${dien_thoai}
    ${list_product}   Get Dictionary Keys      ${list_product_num}
    ${list_num}   Get Dictionary Values      ${list_product_num}
    ${get_channel_id}     ${get_identitykey_id}    Get Sendo channel id and identitykey id thr API    ${input_sendo}
    ${list_var_id}      ${list_attr_hash}     Get list product variant id and attribute hash by list product code    ${input_sendo}    ${list_product}
    ${dia_chi}    Set Variable If    '${dia_chi}'=='none'    ${EMPTY}   ${dia_chi}
    ${phuong_xa}    Set Variable If    '${phuong_xa}'=='none'    ${EMPTY}   ${phuong_xa}
    ${dien_thoai}    Set Variable If    '${dien_thoai}'=='none'    ${EMPTY}   ${dien_thoai}
    ${length}     Get Length    ${list_product}
    ${sku_details}      Create List
    :FOR    ${index}      IN RANGE    ${length}
    \     ${result_attr_hash}     Set Variable If    '${list_attr_hash[${index}]}'=='null'    null       "${list_attr_hash[${index}]}"
    \     Append To List     ${sku_details}    {"product_variant_id":${list_var_id[${index}]},"product_name":"Thú bông chó","sku":"SP3534595","quantity":${list_num[${index}]},"size":"","color":"","price":${list_price[${index}]},"sub_total":150000,"weight":10,"product_image":"https://media3.scdn.vn/img3/2019/9_10/c7OrsP.png","description":"Kích thước: 26 - Màu sắc: Vàng - phong cách: trẻ trung ","unit_id":2,"attribute_hash":${result_attr_hash},"shop_program_percent":5,"shop_program_amount":5000,"is_flash_sales":true,"flash_sale_amount":5000,"flash_deal_type_names":["BulkSale","ComboDiscount"],"is_combo_discount":true,"combo_parent_product_id":0}
    Log     ${sku_details}
    ${sku_details}    Convert List to String    ${sku_details}
    Log    ${sku_details}
    ${data_str}    Set Variable      {"store_id":"${get_identitykey_id}","sales_order":{"order_number":"1607511339","order_status":2,"delivery_status":0,"payment_status":1,"tracking_number":"","carrier_name":"Chuyển phát tiêu chuẩn","carrier_code":"ecom_shipping_dispatch_cptc_sc","carrier_phone":"","sort_code":"","buyer_phone":"0903607123","buyer_address":"Tòa nhà FPT Tân Thuận, Lô L29B-31B—33B, đường số 8, KCX Tân Thuận","buyer_region_id":1,"buyer_district_id":7,"buyer_region":"","buyer_district":"","buyer_ward":"","sales_order_merges":"","is_shop_voucher":false,"is_delivery_failed":null,"warning_status":null,"is_merge":false,"mobile_discount_amount":0,"allow_check":false,"is_self_shipping":false,"bank_name":"","is_installment":false,"is_first_order":null,"installment_fee":0,"sendo_support_fee_to_buyer":2000,"reason_cancel_code":"CBS","voucher_value":0,"region_name":"Tòa nhà FPT Tân Thuận, Lô L29B-31B—33B, đường số 8, KCX Tân Thuận, Phường Tân Thuận Đông, Quận 7, Hồ Chí Minh","seller_shipping_fee":10000,"senpay_free_shipping":0,"sendo_support_fee":0,"parent_order_number":"","child_order_number":"","transferred_amount":0,"affiliate_from_source":"","affiliate_name":"","affiliate_total_amount":0,"receiver_address":"","receiver_ward":"","receiver_district":"","receiver_region":"","bank_code":"","installment_bank_fee":0,"payment_period":"","percent_installment":0,"transportation_type":"","receiver_email":"buunguyenvn@yahoo.com","tracking_link":"","payment_status_name":"Chưa nhận tiền","senpay_fee":0,"store_picking_address":"123 Nguyễn Đình Chiểu, Phường 12, Quận 10, Hồ Chí Minh","is_declare_value":null,"declare_value_fee":0,"cod_fee":0,"is_post_office":null,"post_offices_fee":0,"sales_order_type":1,"types_of_sales_promotion":6,"is_printed":false,"sales_product_type":1,"payment_type":null,"ship_from_region_id":1,"ship_from_country_code":"","receiver_name":"${ten_kh}","ship_to_address":"${dia_chi}","ship_to_ward":"${phuong_xa}","ship_from_district_id":10,"ship_to_district_id":7,"ship_to_country_code":"VN","ship_to_zipcode":"700000","shipping_contact_phone":"${dien_thoai}","ship_to_region_id":1,"ship_from_ward":"Phường 12","shipping_type":1,"shipping_fee":12000,"ship_from_address":"123 Nguyễn Đình Chiểu","total_amount":311000,"weight":260,"actual_weight":260,"payment_method":1,"note":"Đơn hàng Test QC","reason_delay":"","reason_cancel":"Người bán quá hạn xác nhận tình trạng hàng","canceled_by":"scheduler","refund_to_buyer_amount":0,"transfer_to_seller_amount":0,"refund_trans":null,"is_disputing":false,"sub_total":376000,"stage":1,"process_refund_amount":0,"can_action":true,"order_date_time_stamp":1607511339,"ticket_use_date_time_stamp":0,"payment_status_date_time_stamp":1595930389,"delay_date_time_stamp":null,"delay_to_date_time_stamp":null,"submit_date_time_stamp":null,"pod_date_time_stamp":null,"canceled_date_time_stamp":1596103411,"created_date_time_stamp":1607511339,"updated_date_time_stamp":1607522155,"expected_delivery_date_time_stamp":null,"order_status_date_time_stamp":1607522155,"delivery_status_date_time_stamp":null,"total_amount_buyer":376000,"payment_type1":0,"payment_status1":0,"payment_type1_amount":0,"payment_type2":0,"payment_status2":0,"payment_type2_amount":0,"fds_expired_time":0,"shop_program_name":"ShopPlus","shop_program_amount":5000,"shipping_voucher_amount":10000,"seller_pay_later_fee":50000,"shop_voucher_amount":${discount},"sendo_voucher_amount":0},"sku_details":[${sku_details}]}
    Log    ${data_str}
    ${headers}    Create Dictionary    Content-Type=application/json
    Create Session    lolo    ${sendo_mock_api}
    ${resp}=    Post Request    lolo    /partner/salesorder/create   data=${data_str}    headers=${headers}
    Log    ${resp.request.body}
    Log    ${resp.json()}
    log    ${resp.status_code}
    Should Be Equal As Strings    ${resp.status_code}    200
    ${get_ma_dh_sendo}      Get data from response json     ${resp.json()}      $..order_number
    Return From Keyword    ${get_ma_dh_sendo}

Update status Sendo
    [Arguments]     ${input_ma_dh_sendo}    ${input_status}
    ${data_str}    Set Variable      {"order_status":${input_status}}
    ${headers}    Create Dictionary    Content-Type=application/json
    Create Session    lolo    ${sendo_mock_api}
    ${resp}=    Put Request    lolo    /partner/salesorder/updateStatus/${input_ma_dh_sendo}   data=${data_str}    headers=${headers}
    Log    ${resp.request.body}
    Log    ${resp.json()}
    log    ${resp.status_code}
    Should Be Equal As Strings    ${resp.status_code}    200

Check status order and status delivery Sendo
    [Arguments]    ${list_trangthai_sendo}
    ${get_length}   Get Length    ${list_trangthai_sendo}
    ${end_status}     Minus     ${get_length}   1
    ${end_status}   Replace floating point    ${end_status}
    ${result_trangthai_hoadon}      Run Keyword If      '${list_trangthai_sendo[${end_status}]}'=='2' or '${list_trangthai_sendo[${end_status}]}'=='3'     Set Variable    Phiếu tạm    ELSE IF     '${list_trangthai_sendo[${end_status}]}'=='13'     Set Variable    Đã hủy      ELSE IF  '${list_trangthai_sendo[${end_status}]}'=='6' or '${list_trangthai_sendo[${end_status}]}'=='7' or '${list_trangthai_sendo[${end_status}]}'=='8' or '${list_trangthai_sendo[${end_status}]}'=='21'     Set Variable    Đang xử lý   ELSE IF      '${list_trangthai_sendo[${end_status}]}'=='returned'      Set Variable    Hoàn thànhG
    ${result_trangthai_vandon}      Run Keyword If     '${list_trangthai_sendo[${end_status}]}'=='6' or '${list_trangthai_sendo[${end_status}]}'=='7'    Set Variable   Đang giao hàng    ELSE IF   '${list_trangthai_sendo[${end_status}]}'=='8'    Set Variable   Giao thành công       ELSE IF      '${list_trangthai_sendo[${end_status}]}'=='21'    Set Variable     Đang chuyển hoán    ELSE    Set Variable    Đã chuyển hoán
    ${result_status_vandon}    Run Keyword If     '${result_trangthai_vandon}'=='Giao thành công'     Set Variable   3      ELSE IF   '${result_trangthai_vandon}'=='Đã chuyển hoàn'     Set Variable    5   ELSE      Set Variable    4
    Return From Keyword    ${result_trangthai_hoadon}       ${result_trangthai_vandon}      ${result_status_vandon}

Get token sendo thr API
    [Arguments]        ${taikhoan}     ${matkhau}
    ${data_str}   Set Variable    {"username":"${taikhoan}","password":"${matkhau}","source":3,"g-recaptcha-response":"","g-recaptcha-type":"invisible"}
    ${headers}    Create Dictionary    Content-Type=application/json
    Create Session    lolo    https://oauth.sendo.vn
    ${resp}=    Post Request    lolo    /login/sendoid   data=${data_str}    headers=${headers}
    Log    ${resp.request.body}
    Log    ${resp.json()}
    log    ${resp.status_code}
    Should Be Equal As Strings    ${resp.status_code}    200
    ${get_token}      Get data from response json     ${resp.json()}      $..token
    Return From Keyword    ${get_token}

Get token sendo id thr API
    [Arguments]        ${taikhoan}     ${matkhau}
    ${get_token}    Get token sendo thr API    ${taikhoan}     ${matkhau}
    ${access_token}   Set Variable    access_token=${get_token}
    ${headers}    Create Dictionary   Cookie=${access_token}     Content-Length=0
    Create Session    lolo    https://seller-api.sendo.vn/api
    ${resp}=    Post Request    lolo    /token/web/tokensendoid     headers=${headers}
    Log    ${resp.request.body}
    Log    ${resp.json()}
    log    ${resp.status_code}
    Should Be Equal As Strings    ${resp.status_code}    200
    ${get_token_id}      Get data from response json     ${resp.json()}      $..token
    Return From Keyword    ${get_token_id}

Get secret key and shop key Sendo thr API
    [Arguments]     ${taikhoan}     ${matkhau}
    ${get_token_id}     Get token sendo id thr API      ${taikhoan}     ${matkhau}
    ${headers}    Create Dictionary   Authorization=${get_token_id}     content-type=application/json
    Create Session    lolo    https://seller-api.sendo.vn/api
    ${resp}=    Get Request    lolo    /web/StoreConfigPartner     headers=${headers}
    Log    ${resp.request.body}
    Log    ${resp.json()}
    log    ${resp.status_code}
    Should Be Equal As Strings    ${resp.status_code}    200
    ${get_secret_key}      Get data from response json     ${resp.json()}      $..secret_key
    ${get_shop_key}      Get data from response json     ${resp.json()}      $..shop_key
    Return From Keyword    ${get_secret_key}    ${get_shop_key}
