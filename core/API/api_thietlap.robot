*** Settings ***
Library           Collections
Library           RequestsLibrary
Library           SeleniumLibrary
Library           OperatingSystem
Library           String
Library           StringFormat
Library           JSONLibrary
Library           DateTime
Resource          ../share/computation.robot
Resource          api_access.robot
Resource          api_danhmuc_hanghoa.robot
Resource          api_nha_cung_cap.robot
Resource          api_khachhang.robot
Resource          ../share/list_dictionary.robot
Resource          ../../prepare/Hang_hoa/Sources/hanghoa.robot
Resource          ../../core/Thiet_lap/nguoidung_list_action.robot

*** Variables ***
${endpoint_thukhac}    /surcharge
${endpoint_surcharge_list}    /surcharge?format=json&ForManage=true&Includes=SurchargeBranches&%24inlinecount=allpages&BranchIds=%5B{0}%5D    #0 is branch id
${endpoint_campaign_list}    /campaigns?Includes=SalePromotions&%24inlinecount=allpages&%24top=30&Retailer={0}
${endpoint_cam_detail}    /campaigns/{0}
${endpoint_voucher_issue_list}    /vouchercampaign?Includes=VoucherBranchs&Includes=VoucherUsers&Includes=VoucherCustomerGroups&Includes=Vouchers&%24inlinecount=allpages&%24top=15&%24filter=IsActive+eq+1
${endpoint_list_vouchercode}    /voucher?%24inlinecount=allpages&CampaignId={0}&%24top=10    #top 10 voucher code
${endpoint_expense_list}    /expensesOther?format=json&ForManage=true&Includes=ExpensesOtherBranches&%24inlinecount=allpages&BranchIds=%5B{0}%5D&isForm=2&%24
${endpoint_promo_detail}    /campaigns?Includes=SalePromotions&%24inlinecount=allpages&%24top=15&%24filter=(IsActive+eq+1+and+(substringof(%27{0}%27%2CCode)+or+substringof(%27{1}%27%2CName)))    # ma khuyen mai
${endpoint_role}    /setting/roles
${endpoint_user}    /users?format=json
${endpoint_delete_user}    /users/{0}    #id user
${endpoint_branch_list}    /branchs?format=json
${endpoint_detail_role}    /setting/roles?IncludePrivileges=true
${endpoint_delete_branch}    /branchs?Id={0}    #id branch
${endpoint_surcharge_list_all}    /surcharge?format=json&ForManage=true&Includes=SurchargeBranches&%24inlinecount=allpages
${endpoint_delete_surcharge}    /surcharge/{0}?CompareCode=sfdfdfs&CompareName=t%C3%A8dfds    #id thu khac
${endpoint_promo_list}    /campaigns?Includes=SalePromotions&%24inlinecount=allpages&%24top=15
${endpoint_delete_promo}    /campaigns/{0}    #id promo
${endpoint_audittrail_list}    /logs?format=json&%24inlinecount=allpages&BranchIds={0}&%24top=200    #branch id
${endpoint_audittrail_detail}    /logs?format=json&%24inlinecount=allpages&BranchIds={0}&KeyWord={1}&FromDate={2}    #0:branch id - 1:mã giao dịch - 2:current date
${endpoint_shop_config_list}    /setting/pos
${endpoint_list_khuvuc}   /locations
${endpont_list_phuongxa}      /wards
${endpoint_list_phuong}   /wards/autocomplete?lid={0}&lname=H%C3%A0+N%E1%BB%99i+-+Qu%E1%BA%ADn+Ba+%C4%90%C3%ACnh&tearm=P    #id location
${endpoint_list_xa}   /wards/autocomplete?lid={0}&lname=H%C3%A0+N%E1%BB%99i+-+Qu%E1%BA%ADn+Ba+%C4%90%C3%ACnh&tearm=X    #id location
${endpoint_list_chiphi_nhaphang}    /expensesOther?format=json
${endpoint_del_chiphi_nhaphang}   /expensesOther/{0}    #id chi phi nhap hang
${endpoint_active_user}   /users/{0}/activeuser   #userid
${endpoint_thoigian_truycap}      /users/timeaccess
${endpoint_zalo_linking}      /zalo/linking
${endpoint_list_sms_email}     /sms-email-template?Includes=User&%24inlinecount=allpages&%24top=50
${endpoint_del_sms}     /sms-email-template/{0}
${endpoint_sms_email}     /sms-email-template/
${endpoint_voucher}    /voucherCampaign/{0}
${endpoint_vouchercode}    /voucher?%24inlinecount=allpages&CampaignId={0}&%24top=10    #id of voucherCampaign
${endpoint_delete_voucher}    /voucherCampaign/{0}?kvuniqueparam=2020
${endpoint_setting_point}     /setting/point?kvuniqueparam=2020
${endpoint_client_id}     /identityserver/clients/retailer?kvuniqueparam=2020
${endpoint_client_serect}     /identityserver/clients/secret?ClientId={0}&kvuniqueparam=2020&     #0: ClientId

*** Keywords ***
Toggle surcharge percentage
    [Arguments]    ${surchage_code}    ${status}
    [Timeout]    5 minute
    ${retailer_id}    Get RetailerID
    ${user_id}    Get User ID
    ${endpoint_thukhac_by_branch}    Format String    ${endpoint_surcharge_list}    ${BranchID}
    ${get_resp}    Get Request and return body    ${endpoint_thukhac_by_branch}
    Log    ${get_resp}
    ${jsonpath_surcharge_id}    Format String    $..Data[?(@.Code=="{0}")].Id    ${surchage_code}
    ${jsonpath_surcharge_name}    Format String    $..Data[?(@.Code=="{0}")].Name    ${surchage_code}
    ${jsonpath_surcharge_ratio}    Format String    $..Data[?(@.Code=="{0}")].ValueRatio    ${surchage_code}
    ${jsonpath_surcharge_autogen}    Format String    $..Data[?(@.Code=="{0}")].isAuto    ${surchage_code}
    ${jsonpath_surcharge_returnautogen}    Format String    $..Data[?(@.Code=="{0}")].isReturnAuto    ${surchage_code}
    ${jsonpath_surcharge_order}    Format String    $..Data[?(@.Code=="{0}")].Order    ${surchage_code}
    ${surcharge_name}    Get data from response json    ${get_resp}    ${jsonpath_surcharge_name}
    ${ratio}    Get data from response json    ${get_resp}    ${jsonpath_surcharge_ratio}
    ${surcharge_id}    Get data from response json    ${get_resp}    ${jsonpath_surcharge_id}
    ${autogen}    Get boolean value from API    ${endpoint_thukhac_by_branch}    ${jsonpath_surcharge_autogen}
    ${return_autogen}    Get boolean value from API    ${endpoint_thukhac_by_branch}    ${jsonpath_surcharge_returnautogen}
    ${order}    Get data from response json    ${get_resp}    ${jsonpath_surcharge_order}
    ${data_str}    Format String    {{"Surcharge":{{"__type":"KiotViet.Persistence.Surcharge, KiotViet.Persistence","Id":{0},"Code":"{3}","Name":"{4}","ForAllBranch":true,"ValueRatio":{5},"isActive":{8},"isAuto":{6},"RetailerId":{1},"CreatedDate":"","CreatedBy":{2},"Order":{9},"isReturnAuto":{7},"SurchargeBranches":[],"InvoiceOrderSurcharges":[],"ValueText":"","Status":"","IdForExpandRow":{0}}}}}    ${surcharge_id}    ${retailer_id}    ${user_id}    ${surchage_code}
    ...    ${surcharge_name}    ${ratio}    ${autogen}    ${return_autogen}    ${status}    ${order}
    log    ${data_str}
    Post request thr API    /surcharge    ${data_str}

Toggle surcharge VND
    [Arguments]    ${surchage_code}    ${status}
    [Timeout]    5 minute
    ${retailer_id}    Get RetailerID
    ${user_id}    Get User ID
    ${endpoint_thukhac_by_branch}    Format String    ${endpoint_surcharge_list}    ${BranchID}
    ${get_resp}    Get Request and return body    ${endpoint_thukhac_by_branch}
    Log    ${get_resp}
    ${jsonpath_surcharge_id}    Format String    $..Data[?(@.Code=="{0}")].Id    ${surchage_code}
    ${jsonpath_surcharge_name}    Format String    $..Data[?(@.Code=="{0}")].Name    ${surchage_code}
    ${jsonpath_surcharge_vnd}    Format String    $..Data[?(@.Code=="{0}")].Value    ${surchage_code}
    ${jsonpath_surcharge_autogen}    Format String    $..Data[?(@.Code=="{0}")].isAuto    ${surchage_code}
    ${jsonpath_surcharge_returnautogen}    Format String    $..Data[?(@.Code=="{0}")].isReturnAuto    ${surchage_code}
    ${jsonpath_surcharge_order}    Format String    $..Data[?(@.Code=="{0}")].Order    ${surchage_code}
    ${surcharge_name}    Get data from response json    ${get_resp}    ${jsonpath_surcharge_name}
    ${value}    Get data from response json    ${get_resp}    ${jsonpath_surcharge_vnd}
    ${surcharge_id}    Get data from response json    ${get_resp}    ${jsonpath_surcharge_id}
    ${autogen}    Get boolean value from API    ${endpoint_thukhac_by_branch}    ${jsonpath_surcharge_autogen}
    ${return_autogen}    Get boolean value from API    ${endpoint_thukhac_by_branch}    ${jsonpath_surcharge_returnautogen}
    ${order}    Get data from response json    ${get_resp}    ${jsonpath_surcharge_order}
    ${data_str}    Format String    {{"Surcharge":{{"__type":"KiotViet.Persistence.Surcharge, KiotViet.Persistence","Id":{0},"Code":"{3}","Name":"{4}","ForAllBranch":true,"Value":{5},"isActive":{8},"isAuto":{6},"RetailerId":{1},"CreatedDate":"","CreatedBy":{2},"Order":{9},"isReturnAuto":{7},"SurchargeBranches":[],"InvoiceOrderSurcharges":[],"ValueText":"","Status":"","IdForExpandRow":{0}}}}}    ${surcharge_id}    ${retailer_id}    ${user_id}    ${surchage_code}
    ...    ${surcharge_name}    ${value}    ${autogen}    ${return_autogen}    ${status}    ${order}
    log    ${data_str}
    Post request thr API    /surcharge    ${data_str}

Get surcharge vnd value
    [Arguments]    ${surchage_code}
    [Timeout]    3 minute
    ${endpoint_thukhac_by_branch}    Format String    ${endpoint_surcharge_list}    ${BranchID}
    ${jsonpath_surcharge_vnd}    Format String    $..Data[?(@.Code=="{0}")].Value    ${surchage_code}
    ${value}    Get data from API    ${endpoint_thukhac_by_branch}    ${jsonpath_surcharge_vnd}
    ${value}    Convert To Number    ${value}
    Return From Keyword    ${value}

Get surcharge percentage value
    [Arguments]    ${surchage_code}
    [Timeout]    3 minute
    ${endpoint_thukhac_by_branch}    Format String    ${endpoint_surcharge_list}    ${BranchID}
    ${jsonpath_surcharge_%}    Format String    $..Data[?(@.Code=="{0}")].ValueRatio    ${surchage_code}
    ${value}    Get data from API    ${endpoint_thukhac_by_branch}    ${jsonpath_surcharge_%}
    ${value}    Convert To Number    ${value}
    Return From Keyword    ${value}

Get Id promotion
    [Arguments]    ${promotion_code}
    [Timeout]    3 minute
    ${jsonpath_campaign_id}    Format String    $..Data[?(@.Code=="{0}")].Id    ${promotion_code}
    ${endpoint_campaign_list_by_retailername}    Format String    ${endpoint_campaign_list}    ${RETAILER_NAME}
    ${campaign_id}=    Get data from API by other url    ${PROMO_API}    ${endpoint_campaign_list_by_retailername}    ${jsonpath_campaign_id}
    Return From Keyword    ${campaign_id}

Toggle status of promotion
    [Arguments]    ${promotion_code}    ${status}
    [Timeout]    5 minute
    ${curdatetime}    Get Current Date    result_format=datetime
    ${month}    Evaluate    $curdatetime.month
    ${date}    Evaluate    $curdatetime.day
    ${jsonpath_cam}    Format String    $..Data[?(@.Code=="{0}")]    ${promotion_code}
    ${endpoint_campaign_list_by_retailername}    Format String    ${endpoint_campaign_list}    ${RETAILER_NAME}
    ${cam}    Get data from API by other url    ${PROMO_API}    ${endpoint_campaign_list_by_retailername}    ${jsonpath_cam}
    ${cam}    Convert To String    ${cam}
    ${cam}    Replace String    ${cam}    True    true
    ${cam}    Replace String    ${cam}    False    false
    ${cam}    Replace String    ${cam}    '    "
    ${cam_json}    Evaluate    json.loads('''${cam}''')    json
    Set To Dictionary    ${cam_json}    IsActive=${status}    ApplyMonths=${month}    ApplyDates=${date}
    ${cam}=    Evaluate    json.dumps(${cam_json})    json
    Log    ${cam}
    ${json_payload}    Set Variable    {"Campaign":${cam}}
    Log    ${json_payload}
    Post request by other URL API     ${PROMO_API}    /campaigns    ${json_payload}

Get Invoice value - Discounts - Promotion Name from Promotion Code
    [Arguments]    ${promotion_code}
    [Documentation]    Lay gia tri tong tien hang dap ung, discount hóa đơn, ten cua khuyen mai
    [Timeout]    5 minute
    ${promotion_id}    Get Id promotion    ${promotion_code}
    ${endpoint_cam_detail_by_id}    Format String    ${endpoint_cam_detail}    ${promotion_id}
    ${response_campaign}    Get response from API by other url    ${PROMO_API}    ${endpoint_cam_detail_by_id}
    ${cam}    Convert To String    ${response_campaign}
    ${cam}    Replace String    ${cam}    True    true
    ${cam}    Replace String    ${cam}    False    false
    ${cam}    Replace String    ${cam}    '    "
    ${cam}    Replace String    ${cam}    u"    "
    ${cam_json}    Evaluate    json.loads('''${cam}''')    json
    ${invoice_value}    Get value from json and evaluate    ${cam_json}    $.SalePromotions..InvoiceValue
    ${discount}    Get value from json and evaluate    ${cam_json}    $..Discount
    ${discount_ratio}    Get value from json and evaluate    ${cam_json}    $..DiscountRatio
    ${name}    Get value from json and evaluate    ${cam_json}    $..Name
    Return From Keyword    ${invoice_value}    ${discount}    ${discount_ratio}    ${name}

Get Invoice value - Discounts - Promotion Name - Promotion Sale - Id from Promotion Code
        [Arguments]    ${promotion_code}
        [Documentation]    Lay gia tri tong tien hang dap ung, discount hóa đơn, ten cua khuyen mai
        [Timeout]    5 minute
        ${promotion_id}    Get Id promotion    ${promotion_code}
        ${endpoint_cam_detail_by_id}    Format String    ${endpoint_cam_detail}    ${promotion_id}
        ${response_campaign}    Get response from API by other url    ${PROMO_API}    ${endpoint_cam_detail_by_id}
        ${cam}    Convert To String    ${response_campaign}
        ${cam}    Replace String    ${cam}    True    true
        ${cam}    Replace String    ${cam}    False    false
        ${cam}    Replace String    ${cam}    '    "
        ${cam}    Replace String    ${cam}    u"    "
        ${cam_json}    Evaluate    json.loads('''${cam}''')    json
        ${invoice_value}    Get value from json and evaluate    ${cam_json}    $.SalePromotions..InvoiceValue
        ${discount}    Get value from json and evaluate    ${cam_json}    $..Discount
        ${discount_ratio}    Get value from json and evaluate    ${cam_json}    $..DiscountRatio
        ${name}    Get value from json and evaluate    ${cam_json}    $..Name
        ${promotion_sale_id}        Get value from json and evaluate    ${cam_json}    $..SalePromotions..Id
        Return From Keyword    ${invoice_value}    ${discount}    ${discount_ratio}    ${name}       ${promotion_sale_id}       ${promotion_id}

Get Invoice value - Product Discounts - Promotion Name from Promotion Code
        [Arguments]    ${promotion_code}
        [Documentation]    Lay gia tri tong tien hang dap ung, discount hóa đơn, ten cua khuyen mai
        [Timeout]    5 minute
        ${promotion_id}    Get Id promotion    ${promotion_code}
        ${endpoint_cam_detail_by_id}    Format String    ${endpoint_cam_detail}    ${promotion_id}
        ${response_campaign}    Get response from API by other url    ${PROMO_API}    ${endpoint_cam_detail_by_id}
        ${cam}    Convert To String    ${response_campaign}
        ${cam}    Replace String    ${cam}    True    true
        ${cam}    Replace String    ${cam}    False    false
        ${cam}    Replace String    ${cam}    '    "
        ${cam}    Replace String    ${cam}    u"    "
        ${cam_json}    Evaluate    json.loads('''${cam}''')    json
        ${invoice_value}    Get value from json and evaluate    ${cam_json}    $.SalePromotions..InvoiceValue
        ${discount}    Get value from json and evaluate    ${cam_json}    $..ProductDiscount
        ${discount_ratio}    Get value from json and evaluate    ${cam_json}    $..DiscountRatio
        ${name}    Get value from json and evaluate    ${cam_json}    $..Name
        Return From Keyword    ${invoice_value}    ${discount}    ${discount_ratio}    ${name}

Get Invoice value - Product Discounts - Promotion Name - Promotion Id - Campaign Id from Promotion Code
    [Arguments]    ${promotion_code}
    [Documentation]    Lay gia tri tong tien hang dap ung, discount hóa đơn, ten cua khuyen mai
    [Timeout]    5 minute
    ${promotion_id}    Get Id promotion    ${promotion_code}
    ${endpoint_cam_detail_by_id}    Format String    ${endpoint_cam_detail}    ${promotion_id}
    ${response_campaign}    Get response from API by other url    ${PROMO_API}    ${endpoint_cam_detail_by_id}
    ${cam}    Convert To String    ${response_campaign}
    ${cam}    Replace String    ${cam}    True    true
    ${cam}    Replace String    ${cam}    False    false
    ${cam}    Replace String    ${cam}    '    "
    ${cam}    Replace String    ${cam}    u"    "
    ${cam_json}    Evaluate    json.loads('''${cam}''')    json
    ${invoice_value}    Get value from json and evaluate    ${cam_json}    $.SalePromotions..InvoiceValue
    ${discount}    Get value from json and evaluate    ${cam_json}    $..ProductDiscount
    ${discount_ratio}    Get value from json and evaluate    ${cam_json}    $..DiscountRatio
    ${name}    Get value from json and evaluate    ${cam_json}    $..Name
    ${promotion_sale_id}        Get value from json and evaluate    ${cam_json}    $..SalePromotions..Id
    Return From Keyword    ${invoice_value}    ${discount}    ${discount_ratio}    ${name}     ${promotion_sale_id}       ${promotion_id}

Get Invoice value - Received value - Discounts - Promotion Name from Promotion Code
    [Arguments]    ${promotion_code}
    [Documentation]    Lay gia tri tong tien hang dap ung, so luong tặng, giam gia SP, ten cua khuyen mai
    [Timeout]    5 minute
    ${promotion_id}    Get Id promotion    ${promotion_code}
    ${endpoint_cam_detail_by_id}    Format String    ${endpoint_cam_detail}    ${promotion_id}
    ${response_campaign}    Get response from API by other url    ${PROMO_API}    ${endpoint_cam_detail_by_id}
    ${cam}    Convert To String    ${response_campaign}
    ${cam}    Replace String    ${cam}    True    true
    ${cam}    Replace String    ${cam}    False    false
    ${cam}    Replace String    ${cam}    '    "
    ${cam}    Replace String    ${cam}    u"    "
    ${cam_json}    Evaluate    json.loads('''${cam}''')    json
    ${invoice_value}    Get value from json and evaluate    ${cam_json}    $.SalePromotions..InvoiceValue
    ${received_value}    Get value from json and evaluate    ${cam_json}    $.SalePromotions..ReceivedQuantity
    ${discount}    Get value from json and evaluate    ${cam_json}    $.SalePromotions..ProductDiscount
    ${discount_ratio}    Get value from json and evaluate    ${cam_json}    $.SalePromotions..ProductDiscountRatio
    ${name}    Get value from json and evaluate    ${cam_json}    $..Name
    Return From Keyword    ${invoice_value}    ${received_value}    ${discount}    ${discount_ratio}    ${name}

Get Invoice value - Received value - Discounts - Promotion Name - Promotion Id - Promotion Sale Id from Promotion Code
    [Arguments]    ${promotion_code}
    [Documentation]    Lay gia tri tong tien hang dap ung, so luong tặng, giam gia SP, ten cua khuyen mai
    [Timeout]    5 minute
    ${promotion_id}    Get Id promotion    ${promotion_code}
    ${endpoint_cam_detail_by_id}    Format String    ${endpoint_cam_detail}    ${promotion_id}
    ${response_campaign}    Get response from API by other url    ${PROMO_API}    ${endpoint_cam_detail_by_id}
    ${cam}    Convert To String    ${response_campaign}
    ${cam}    Replace String    ${cam}    True    true
    ${cam}    Replace String    ${cam}    False    false
    ${cam}    Replace String    ${cam}    '    "
    ${cam}    Replace String    ${cam}    u"    "
    ${cam_json}    Evaluate    json.loads('''${cam}''')    json
    ${invoice_value}    Get value from json and evaluate    ${cam_json}    $.SalePromotions..InvoiceValue
    ${received_value}    Get value from json and evaluate    ${cam_json}    $.SalePromotions..ReceivedQuantity
    ${discount}    Get value from json and evaluate    ${cam_json}    $.SalePromotions..ProductDiscount
    ${discount_ratio}    Get value from json and evaluate    ${cam_json}    $.SalePromotions..ProductDiscountRatio
    ${name}    Get value from json and evaluate    ${cam_json}    $..Name
    ${promotion_sale_id}        Get value from json and evaluate    ${cam_json}    $..SalePromotions..Id
    Return From Keyword    ${invoice_value}    ${received_value}    ${discount}    ${discount_ratio}    ${name}     ${promotion_sale_id}     ${promotion_id}

Get Number of sale product - promo product - promo value and name
    [Arguments]    ${promotion_code}
    [Documentation]    Lấy giá trị số lượng hàng bán, số lượng hàng được giảm giá, giá trị khuyến mại, giá sản phẩm bán với KM số lượng đáp ứng
    [Timeout]    5 minute
    ${promotion_id}    Get Id promotion    ${promotion_code}
    ${endpoint_cam_detail_by_id}    Format String    ${endpoint_cam_detail}    ${promotion_id}
    ${response_campaign}    Get response from API by other url    ${PROMO_API}    ${endpoint_cam_detail_by_id}
    ${cam}    Convert To String    ${response_campaign}
    ${cam}    Replace String    ${cam}    True    true
    ${cam}    Replace String    ${cam}    False    false
    ${cam}    Replace String    ${cam}    '    "
    ${cam}    Replace String    ${cam}    u"    "
    ${cam_json}    Evaluate    json.loads('''${cam}''')    json
    ${num_sale_product}    Get value from json and evaluate    ${cam_json}    $.SalePromotions..PrereqQuantity
    ${num_promo_product}    Get value from json and evaluate    ${cam_json}    $.SalePromotions..ReceivedQuantity
    ${product_price}    Get value from json and evaluate    ${cam_json}    $.SalePromotions..ProductPrice
    ${discount}    Get value from json and evaluate    ${cam_json}    $.SalePromotions..ProductDiscount
    ${discount_ratio}    Get value from json and evaluate    ${cam_json}    $.SalePromotions..ProductDiscountRatio
    ${name}    Get value from json and evaluate    ${cam_json}    $..Name
    Return From Keyword    ${num_sale_product}    ${num_promo_product}    ${product_price}    ${discount}    ${discount_ratio}    ${name}

Add new voucher code
    [Arguments]    ${voucher_issue_code}    ${number}
    [Documentation]    Tao moi voucher code
    [Timeout]    5 minute
    ${json_path_voucher_issue_id}    Format String    $..Data[?(@.Code=="{0}")].Id    ${voucher_issue_code}
    ${voucher_issue_id}    Get data from API    ${endpoint_voucher_issue_list}    ${json_path_voucher_issue_id}
    ${list_voucher_code}    Generate Voucher code automatically in list    ${number}
    ${list_voucher_code_tosend}    Catenate    SEPARATOR=","    @{list_voucher_code}
    ${data_str}    Format String    {{"Vouchers":["{1}"],"CampaignId":{0}}}    ${voucher_issue_id}    ${list_voucher_code_tosend}
    log    ${data_str}
    ${headers1}=    Create Dictionary    Authorization=${bearertoken}    Content-Type=application/json;charset=utf-8      Retailer=${RETAILER_NAME}     Branchid=${BRANCH_ID}
    Create Session    lolo    ${API_URL}    cookies=${resp.cookies}
    ${resp3}=    Wait Until Keyword Succeeds    3x    0s     Post Request    lolo    /voucher/save    data=${data_str}    headers=${headers1}
    Log    ${resp3.request.body}
    Should Be Equal As Strings    ${resp3.status_code}    204
    Return From Keyword    ${list_voucher_code}

Add new voucher and publish by API
    [Arguments]    ${voucher_issue_code}    ${number}    ${voucher_value}    ${type_sell}
    [Documentation]    publish voucher in case of saling this voucher
    [Timeout]    5 minute
    ${jsonpath_voucher_issue_id}    Format String    $..Data[?(@.Code=="{0}")].Id    ${voucher_issue_code}
    ${jsonpath_voucher_value}    Format String    $..Data[?(@.Code=="{0}")].Price    ${voucher_issue_code}
    ${jsonpath_minimum_invoicetotal}    Format String    $..Data[?(@.Code=="{0}")].PrereqPrice    ${voucher_issue_code}
    ${respvoucher}    Get Request and return body    ${endpoint_voucher_issue_list}
    ${voucher_issue_id}    Get data from response json    ${respvoucher}    ${jsonpath_voucher_issue_id}
    ${voucher_value}    Get data from response json    ${respvoucher}    ${jsonpath_voucher_value}
    ${voucher_minimum_invoicetotal}    Get data from response json    ${respvoucher}    ${jsonpath_minimum_invoicetotal}
    ${list_voucher_code}    Generate Voucher code automatically in list    ${number}
    ${list_voucher_code_tosend}    Catenate    SEPARATOR=","    @{list_voucher_code}
    ${data_str}    Format String    {{"Vouchers":["{1}"],"CampaignId":{0}}}    ${voucher_issue_id}    ${list_voucher_code_tosend}
    log    ${data_str}
    ${headers1}=    Create Dictionary    Authorization=${bearertoken}    Content-Type=application/json;charset=utf-8      Retailer=${RETAILER_NAME}     Branchid=${BRANCH_ID}
    Create Session    lolo    ${API_URL}    cookies=${resp.cookies}
    ${resp3}=    Wait Until Keyword Succeeds    3x    0s     Post Request    lolo    /voucher/save    data=${data_str}    headers=${headers1}
    Log    ${resp3.request.body}
    Should Be Equal As Strings    ${resp3.status_code}    204
    #publish
    ${item_voucher_toapply}    Get From List    ${list_voucher_code}    0
    ${jsonpath_list_voucher}    Format String    ${endpoint_list_vouchercode}    ${voucher_issue_id}
    ${resplistvoucher}    Get Request and return body    ${jsonpath_list_voucher}
    ${jsonpath_voucher_id}    Format String    $..Data[?(@.Code=="{0}")].Id    ${item_voucher_toapply}
    ${voucher_id}    Get data from response json    ${resplistvoucher}    ${jsonpath_voucher_id}
    ${currentdate}    Get Current Date
     ${currentdate}   Subtract Time From Date    ${currentdate}    20s
    ${data_payload}    Format String    {{"CampaignId":{0},"Vouchers":[{{"Id":{1},"Code":"SYLN1BXO","Status":0}}],"ReleaseDate":"{2}","Price":{3},"Cashflow":{{"PartnerType":"O","Value":{3},"PaymentMethod":"Cash","AccountId":null}},"SellType":"{4}","ComparePartnerName":null}}    ${voucher_issue_id}    ${voucher_id}    ${currentdate}    ${voucher_value}
    ...    ${type_sell}
    Post request thr API    /voucher/release    ${data_payload}
    Return From Keyword    ${item_voucher_toapply}    ${voucher_value}    ${voucher_minimum_invoicetotal}

Get voucher issue info and create new voucher code
    [Arguments]    ${voucher_code}    ${number}
    [Documentation]    Tao moi voucher code
    [Timeout]    5 minute
    ${jsonpath_voucher_issue_id}    Format String    $..Data[?(@.Code=="{0}")].Id    ${voucher_code}
    ${jsonpath_voucher_value}    Format String    $..Data[?(@.Code=="{0}")].Price    ${voucher_code}
    ${jsonpath_minimum_invoicetotal}    Format String    $..Data[?(@.Code=="{0}")].PrereqPrice    ${voucher_code}
    ${respvoucher}    Get Request and return body    ${endpoint_voucher_issue_list}
    ${voucher_issue_id}    Get data from response json    ${respvoucher}    ${jsonpath_voucher_issue_id}
    ${voucher_value}    Get data from response json    ${respvoucher}    ${jsonpath_voucher_value}
    ${voucher_minimum_invoicetotal}    Get data from response json    ${respvoucher}    ${jsonpath_minimum_invoicetotal}
    ${list_voucher_code}    Generate Voucher code automatically in list    ${number}
    ${list_voucher_code_tosend}    Catenate    SEPARATOR=","    @{list_voucher_code}
    ${data_str}    Format String    {{"Vouchers":["{1}"],"CampaignId":{0}}}    ${voucher_issue_id}    ${list_voucher_code_tosend}
    log    ${data_str}
    ${headers1}=    Create Dictionary    Authorization=${bearertoken}    Content-Type=application/json;charset=utf-8      Retailer=${RETAILER_NAME}     Branchid=${BRANCH_ID}
    Create Session    lolo    ${API_URL}    cookies=${resp.cookies}
    ${resp3}=    Wait Until Keyword Succeeds    3x    0s     Post Request    lolo    /voucher/save    data=${data_str}    headers=${headers1}
    Log    ${resp3.request.body}
    Should Be Equal As Strings    ${resp3.status_code}    204
    Return From Keyword    ${list_voucher_code}    ${voucher_value}    ${voucher_minimum_invoicetotal}

Toggle supplier's charge VND
    [Arguments]    ${expense_code}    ${status}
    [Timeout]    5 minute
    ${retailer_id}    Get RetailerID
    ${user_id}    Get User ID
    ${endpoint_cpnh_by_branch}    Format String    ${endpoint_expense_list}    ${BranchID}
    ${get_resp}    Get Request and return body    ${endpoint_cpnh_by_branch}
    ${jsonpath_expense_id}    Format String    $..Data[?(@.Code=="{0}")].Id    ${expense_code}
    ${jsonpath_expense_name}    Format String    $..Data[?(@.Code=="{0}")].Name    ${expense_code}
    ${jsonpath_expense_vnd}    Format String    $..Data[?(@.Code=="{0}")].Value    ${expense_code}
    ${jsonpath_expense_autogen}    Format String    $..Data[?(@.Code=="{0}")].isAuto    ${expense_code}
    ${jsonpath_expense_returnautogen}    Format String    $..Data[?(@.Code=="{0}")].isReturnAuto    ${expense_code}
    ${expense_name}    Get data from response json    ${get_resp}    ${jsonpath_expense_name}
    ${value}    Get data from response json    ${get_resp}    ${jsonpath_expense_vnd}
    ${exepense_id}    Get data from response json    ${get_resp}    ${jsonpath_expense_id}
    ${autogen}    Get boolean value from API    ${endpoint_cpnh_by_branch}    ${jsonpath_expense_autogen}
    ${return_autogen}    Get boolean value from API    ${endpoint_cpnh_by_branch}    ${jsonpath_expense_returnautogen}
    ${data_str}    Format String    {{"ExpensesOther":{{"__type":"KiotViet.Persistence.ExpensesOther, KiotViet.Persistence","Id":{0},"Code":"{1}","Name":"{2}","ForAllBranch":true,"Value":{3},"Form":0,"isActive":{4},"isAuto":{5},"CreatedDate":"","CreatedBy":{6},"isReturnAuto":{7},"RetailerId":{8},"PurchaseOrderExpensesOthers":[],"PurchaseReturnExpensesOthers":[],"ExpensesOtherBranches":[],"OrderSupplierExpensesOthers":[],"ValueText":"","Status":"","FormText":"","IdForExpandRow":{0},"isDetailexpand":true,"isOrder":true}}}}    ${exepense_id}    ${expense_code}    ${expense_name}    ${value}
    ...    ${status}    ${autogen}    ${user_id}    ${return_autogen}    ${retailer_id}
    Log    ${data_str}
    Post request thr API    /expensesOther    ${data_str}
    Return From Keyword    ${autogen}

Toggle supplier's charge %
    [Arguments]    ${expense_code}    ${status}
    [Timeout]    5 minute
    ${retailer_id}    Get RetailerID
    ${user_id}    Get User ID
    ${endpoint_cpnh_by_branch}    Format String    ${endpoint_expense_list}    ${BranchID}
    ${get_resp}    Get Request and return body    ${endpoint_cpnh_by_branch}
    ${jsonpath_expense_id}    Format String    $..Data[?(@.Code=="{0}")].Id    ${expense_code}
    ${jsonpath_expense_name}    Format String    $..Data[?(@.Code=="{0}")].Name    ${expense_code}
    ${jsonpath_expense_vnd}    Format String    $..Data[?(@.Code=="{0}")].ValueRatio    ${expense_code}
    ${jsonpath_expense_autogen}    Format String    $..Data[?(@.Code=="{0}")].isAuto    ${expense_code}
    ${jsonpath_expense_returnautogen}    Format String    $..Data[?(@.Code=="{0}")].isReturnAuto    ${expense_code}
    ${expense_name}    Get data from response json    ${get_resp}    ${jsonpath_expense_name}
    ${value}    Get data from response json    ${get_resp}    ${jsonpath_expense_vnd}
    ${exepense_id}    Get data from response json    ${get_resp}    ${jsonpath_expense_id}
    ${autogen}    Get boolean value from API    ${endpoint_cpnh_by_branch}    ${jsonpath_expense_autogen}
    ${return_autogen}    Get boolean value from API    ${endpoint_cpnh_by_branch}    ${jsonpath_expense_returnautogen}
    ${data_str}    Format String    {{"ExpensesOther":{{"__type":"KiotViet.Persistence.ExpensesOther, KiotViet.Persistence","Id":{0},"Code":"{1}","Name":"{2}","ForAllBranch":true,"ValueRatio":{3},"Form":0,"isActive":{4},"isAuto":{5},"CreatedDate":"","CreatedBy":{6},"isReturnAuto":{7},"RetailerId":{8},"PurchaseOrderExpensesOthers":[],"PurchaseReturnExpensesOthers":[],"ExpensesOtherBranches":[],"OrderSupplierExpensesOthers":[],"ValueText":"","Status":"","FormText":"","IdForExpandRow":{0},"isDetailexpand":true,"isOrder":true}}}}    ${exepense_id}    ${expense_code}    ${expense_name}    ${value}
    ...    ${status}    ${autogen}    ${user_id}    ${return_autogen}    ${retailer_id}
    Log    ${data_str}
    Post request thr API    /expensesOther    ${data_str}
    Return From Keyword    ${autogen}

Toggle other charge VND
    [Arguments]    ${expense_code}    ${status}
    [Timeout]    5 minute
    ${retailer_id}    Get RetailerID
    ${user_id}    Get User ID
    ${endpoint_cpnh_by_branch}    Format String    ${endpoint_expense_list}    ${BranchID}
    ${get_resp}    Get Request and return body    ${endpoint_cpnh_by_branch}
    ${jsonpath_expense_id}    Format String    $..Data[?(@.Code=="{0}")].Id    ${expense_code}
    ${jsonpath_expense_name}    Format String    $..Data[?(@.Code=="{0}")].Name    ${expense_code}
    ${jsonpath_expense_vnd}    Format String    $..Data[?(@.Code=="{0}")].Value    ${expense_code}
    ${jsonpath_expense_autogen}    Format String    $..Data[?(@.Code=="{0}")].isAuto    ${expense_code}
    ${jsonpath_expense_returnautogen}    Format String    $..Data[?(@.Code=="{0}")].isReturnAuto    ${expense_code}
    ${expense_name}    Get data from response json    ${get_resp}    ${jsonpath_expense_name}
    ${value}    Get data from response json    ${get_resp}    ${jsonpath_expense_vnd}
    ${exepense_id}    Get data from response json    ${get_resp}    ${jsonpath_expense_id}
    ${autogen}    Get boolean value from API    ${endpoint_cpnh_by_branch}    ${jsonpath_expense_autogen}
    ${return_autogen}    Get boolean value from API    ${endpoint_cpnh_by_branch}    ${jsonpath_expense_returnautogen}
    ${data_str}    Format String    {{"ExpensesOther":{{"__type":"KiotViet.Persistence.ExpensesOther, KiotViet.Persistence","Id":{0},"Code":"{1}","Name":"{2}","ForAllBranch":true,"Value":{3},"Form":1,"isActive":{4},"isAuto":{5},"CreatedDate":"","CreatedBy":{6},"isReturnAuto":false,"RetailerId":{7},"PurchaseOrderExpensesOthers":[],"PurchaseReturnExpensesOthers":[],"ExpensesOtherBranches":[],"OrderSupplierExpensesOthers":[],"ValueText":"","Status":"Đ","FormText":"","IdForExpandRow":{0},"isDetailexpand":true,"isOrder":true}}}}    ${exepense_id}    ${expense_code}    ${expense_name}    ${value}
    ...    ${status}    ${autogen}    ${user_id}    ${retailer_id}
    Log    ${data_str}
    Post request thr API    /expensesOther    ${data_str}
    Return From Keyword    ${autogen}

Toggle other charge %
    [Arguments]    ${expense_code}    ${status}
    [Timeout]    5 minute
    ${retailer_id}    Get RetailerID
    ${user_id}    Get User ID
    ${endpoint_cpnh_by_branch}    Format String    ${endpoint_expense_list}    ${BranchID}
    ${jsonpath_expense_id}    Format String    $..Data[?(@.Code=="{0}")].Id    ${expense_code}
    ${jsonpath_expense_name}    Format String    $..Data[?(@.Code=="{0}")].Name    ${expense_code}
    ${jsonpath_expense_vnd}    Format String    $..Data[?(@.Code=="{0}")].ValueRatio    ${expense_code}
    ${jsonpath_expense_autogen}    Format String    $..Data[?(@.Code=="{0}")].isAuto    ${expense_code}
    ${jsonpath_expense_returnautogen}    Format String    $..Data[?(@.Code=="{0}")].isReturnAuto    ${expense_code}
    ${expense_name}    Get data from API    ${endpoint_cpnh_by_branch}    ${jsonpath_expense_name}
    ${value}    Get data from API    ${endpoint_cpnh_by_branch}    ${jsonpath_expense_vnd}
    ${exepense_id}    Get data from API    ${endpoint_cpnh_by_branch}    ${jsonpath_expense_id}
    ${autogen}    Get boolean value from API    ${endpoint_cpnh_by_branch}    ${jsonpath_expense_autogen}
    ${return_autogen}    Get boolean value from API    ${endpoint_cpnh_by_branch}    ${jsonpath_expense_returnautogen}
    ${data_str}    Format String    {{"ExpensesOther":{{"__type":"KiotViet.Persistence.ExpensesOther, KiotViet.Persistence","Id":{0},"Code":"{1}","Name":"{2}","ForAllBranch":true,"ValueRatio":{3},"Form":1,"isActive":{4},"isAuto":{5},"CreatedDate":"","CreatedBy":{6},"ModifiedDate":"","ModifiedBy":20447,"isReturnAuto":false,"RetailerId":{7},"PurchaseOrderExpensesOthers":[],"PurchaseReturnExpensesOthers":[],"ExpensesOtherBranches":[],"OrderSupplierExpensesOthers":[],"ValueText":"","Status":"","FormText":"","IdForExpandRow":{0},"isDetailexpand":true,"isOrder":true}}}}    ${exepense_id}    ${expense_code}    ${expense_name}    ${value}
    ...    ${status}    ${autogen}    ${user_id}    ${retailer_id}
    Log    ${data_str}
    Post request thr API    /expensesOther    ${data_str}
    Return From Keyword    ${autogen}

Toggle list supplier's charge
    [Arguments]     ${list_cpnh}    ${list_supplier_charge_value}
    : FOR    ${item_cpnh}    ${item_sp_charge_value}    IN ZIP    ${list_cpnh}    ${list_supplier_charge_value}
    \    Run Keyword If    ${item_sp_charge_value}>100    Toggle supplier's charge VND    ${item_cpnh}    false
    \    ...    ELSE    Toggle supplier's charge %    ${item_cpnh}    false

Toggle list other charge
    [Arguments]     ${list_cpnhk}    ${list_other_charge_value}
    : FOR    ${item_cpnhk}    ${item_other_charge_value}    IN ZIP    ${list_cpnhk}    ${list_other_charge_value}
    \    Run Keyword If    ${item_other_charge_value}>100    Toggle other charge VND    ${item_cpnhk}    false
    \    ...    ELSE    Toggle other charge %    ${item_cpnhk}    false

Get expense VND value
    [Arguments]    ${expense_code}
    [Timeout]    3 minute
    ${endpoint_expense_by_branch}    Format String    ${endpoint_expense_list}    ${BranchID}
    ${jsonpath_expense_vnd}    Format String    $..Data[?(@.Code=="{0}")].Value    ${expense_code}
    ${value}    Get data from API    ${endpoint_expense_by_branch}    ${jsonpath_expense_vnd}
    ${value}    Convert To Number    ${value}
    Return From Keyword    ${value}

Get expense percentage value
    [Arguments]    ${expense_code}
    [Timeout]    3 minute
    ${endpoint_expense_by_branch}    Format String    ${endpoint_expense_list}    ${BranchID}
    ${jsonpath_expense_%}    Format String    $..Data[?(@.Code=="{0}")].ValueRatio    ${expense_code}
    ${value}    Get data from API    ${endpoint_expense_by_branch}    ${jsonpath_expense_%}
    ${value}    Convert To Number    ${value}
    Return From Keyword    ${value}

Get Id and order surchage
    [Arguments]    ${ma_thukhac}
    [Documentation]    Lay ID thu khac tu API list thu khac
    [Timeout]    3 minute
    ${jsonpath_id_surcharge}    Format String    $.Data[?(@.Code == "{0}")].Id    ${ma_thukhac}
    ${jsonpath_thutu_thukhac}    Format String    $.Data[?(@.Code == "{0}")].Order    ${ma_thukhac}
    ${endpoint_list_surcharge}    Format String    ${endpoint_surcharge_list}    ${BranchID}
    ${get_resp}    Get Request and return body    ${endpoint_list_surcharge}
    ${get_id_surcharge}    Get data from response json    ${get_resp}    ${jsonpath_id_surcharge}
    ${get_thutu_thukhac}    Get data from response json    ${get_resp}    ${jsonpath_thutu_thukhac}
    Return From Keyword    ${get_id_surcharge}    ${get_thutu_thukhac}

Get Id sale promotion
    [Arguments]    ${input_ma_promo}
    [Timeout]    3 minute
    ${endpoint_promo}    Format String    ${endpoint_promo_detail}    ${input_ma_promo}    ${input_ma_promo}
    ${get_id_sale_promo}    Get data from API by other url    ${PROMO_API}    ${endpoint_promo}    $..SalePromotions..Id
    Return From Keyword    ${get_id_sale_promo}

Get promotion info
    [Arguments]    ${input_ma_promo}
    [Timeout]    3 minute
    ${endpoint_promo}    Format String    ${endpoint_promo_detail}    ${input_ma_promo}    ${input_ma_promo}
    ${get_resp}    Get Request and return body by other url and branchid    ${PROMO_API}    ${endpoint_promo}
    ${get_id_sale_promo}    Get data from response json    ${get_resp}    $..SalePromotions..Id
    ${get_id_promo}    Get data from response json    ${get_resp}    $..SalePromotions..CampaignId
    ${get_promo_discount_vnd}    Get data from response json    ${get_resp}    $..SalePromotions..Discount
    #${get_promo_discount_vnd}    Get data from response json    ${get_resp}    $..SalePromotions..ProductDiscount
    ${get_promo_discount_%}    Get data from response json    ${get_resp}    $..SalePromotions..DiscountRatio
    #${get_promo_discount_%}    Get data from response json    ${get_resp}    $..SalePromotions..ProductDiscountRatio
    ${get_promo_discount}    Set Variable If    0 < ${get_promo_discount_%} < 100    ${get_promo_discount_%}    ${get_promo_discount_vnd}
    ${get_promo_discount}    Replace floating point    ${get_promo_discount}
    Return From Keyword    ${get_id_sale_promo}    ${get_id_promo}    ${get_promo_discount}

Get product promotion info
    [Arguments]    ${input_ma_promo}
    [Timeout]    3 minute
    ${endpoint_promo}    Format String    ${endpoint_promo_detail}    ${input_ma_promo}    ${input_ma_promo}
    ${get_resp}    Get Request and return body by other url and branchid    ${PROMO_API}    ${endpoint_promo}
    ${get_id_sale_promo}    Get data from response json    ${get_resp}    $..SalePromotions..Id
    ${get_id_promo}    Get data from response json    ${get_resp}    $..SalePromotions..CampaignId
    ${get_promo_discount_vnd}    Get data from response json    ${get_resp}    $..SalePromotions..ProductDiscount
    ${get_promo_discount_%}    Get data from response json    ${get_resp}    $..SalePromotions..ProductDiscountRatio
    ${get_promo_discount}    Set Variable If    0 < ${get_promo_discount_%} < 100    ${get_promo_discount_%}    ${get_promo_discount_vnd}
    ${get_promo_discount}    Replace floating point    ${get_promo_discount}
    Return From Keyword    ${get_id_sale_promo}    ${get_id_promo}    ${get_promo_discount}

Get status of return auto by surcharge code
    [Arguments]    ${input_surcharge_code}
    [Timeout]    3 minute
    ${endpoint_surcharge_list}    Format String    ${endpoint_surcharge_list}    ${BranchID}
    ${get_resp}    Get Request and return body    ${endpoint_surcharge_list}
    ${jsonpath_hoantrahang}    Format String    $.Data[?(@.Code == "{0}")].isReturnAuto    ${input_surcharge_code}
    ${get_hoantra_khitrahang}    Get data from response json    ${get_resp}    ${jsonpath_hoantrahang}
    Return From Keyword    ${get_hoantra_khitrahang}

Get role id
    [Timeout]    3 mins
    ${get_role_id}    Get data from API    ${endpoint_role}    $..Id
    Return From Keyword    ${get_role_id}

Get role id by role name
    [Timeout]   3 mins
    [Arguments]   ${role_name}
    ${jsonpath_role_id}     Format String    $[?(@.Name=="{0}")].Id    ${role_name}
    ${get_role_id}      Get data from API    ${endpoint_role}    ${jsonpath_role_id}
    Return From Keyword    ${get_role_id}

Get user info and validate
    [Arguments]    ${user_name}    ${user_mobile}    ${user_permissionname}    ${user_email}    ${user_branchname}
    [Timeout]    5 mins
    ${response_user_info}    Get Request and return body    ${endpoint_user}
    ${res_permission}    Get Request and return body    ${endpoint_detail_role}
    ${resp_branch}    Get Request and return body    ${endpoint_branch_list}
    ${jsonpath_name}    Format String    $..Data[?(@.CompareUserName=="{0}")].UserName    ${user_name}
    ${jsonpath_mobile}    Format String    $..Data[?(@.CompareUserName=="{0}")].MobilePhone    ${user_name}
    ${jsonpath_email}    Format String    $..Data[?(@.CompareUserName=="{0}")].Email    ${user_name}
    ${jsonpath_user_type}    Format String    $..Data[?(@.CompareUserName=="{0}")].Type    ${user_name}
    ${jsonpath_user_id}    Format String    $..Data[?(@.CompareUserName=="{0}")].Id    ${user_name}
    ${jsonpath_permission}    Format String    $[?(@.CompareName == '{0}')].Name    ${user_permissionname}
    ${jsonpath_branch_name}    Format String    $.Data[?(@.CompareBranchName== "{0}")].Name    ${user_branchname}
    ${jsonpath_phanquyen}    Format String    $[?(@.CompareName == '{0}')].Privileges    ${user_permissionname}
    ${get_name}    Get data from response json    ${response_user_info}    ${jsonpath_name}
    ${get_user_mobile}    Get data from response json    ${response_user_info}    ${jsonpath_mobile}
    ${get_user_email}    Get data from response json    ${response_user_info}    ${jsonpath_email}
    ${get_user_type}    Get data from response json    ${response_user_info}    ${jsonpath_user_type}
    ${get_user_id}    Get data from response json    ${response_user_info}    ${jsonpath_user_id}
    ${get_permission_name}    Get data from response json    ${res_permission}    ${jsonpath_permission}
    ${get_branch_name}    Get data from response json    ${resp_branch}    ${jsonpath_branch_name}
    ${get_list_phanquyen_tab}    Get raw data from response json    ${res_permission}    ${jsonpath_phanquyen}
    ${get_list_phanquyen_tab}    Convert To String    ${get_list_phanquyen_tab}
    Should Be Equal As Strings    ${get_user_type}    0
    Should Be Equal As Strings    ${user_name}    ${get_name}
    Should Be Equal As Strings    ${get_permission_name}    ${user_permissionname}
    Should Be Equal As Strings    ${get_branch_name}    ${user_branchname}
    Run Keyword If    '${user_mobile}'=='none'    Should Be Equal As Numbers    ${get_user_mobile}    0
    ...    ELSE    Should Be Equal As Strings    ${user_mobile}    ${get_user_mobile}
    Run Keyword If    '${user_email}'=='none'    Should Be Equal As Numbers    ${get_user_email}    0
    ...    ELSE    Should Be Equal As Strings    ${user_email}    ${get_user_email}
    List Should Contain Value    ${get_list_phanquyen_tab}    True
    Return From Keyword    ${get_user_id}

Get name of user
    [Arguments]    ${user_name}
    [Timeout]    5 mins
    ${response_user_info}    Get Request and return body    ${endpoint_user}
    ${jsonpath_username}    Format String    $..Data[?(@.CompareUserName=="{0}")].GivenName    ${user_name}
    ${get_name}    Get data from response json    ${response_user_info}    ${jsonpath_username}
    Return From Keyword    ${get_name}

Delete user
    [Arguments]    ${get_user_id}
    ${endpoint_delete_user}    Format String    ${endpoint_delete_user}    ${get_user_id}
    Create Session    lolo    ${API_URL}    cookies=${resp.cookies}
    ${headers}=    Create Dictionary    Authorization=${bearertoken}
    ${resp}=    RequestsLibrary.Delete Request    lolo    ${endpoint_delete_user}    headers=${headers}    allow_redirects=True
    Log    ${resp.request.body}
    Log    ${resp.json()}
    log    ${resp.status_code}
    Should Be Equal As Strings    ${resp.status_code}    200

Get branch info and validate
    [Arguments]    ${branch_name}    ${branch_mobile1}    ${branch_mobile2}    ${branch_address}    ${branch_location}    ${branch_ward}
    ...    ${branch_email}
    [Timeout]    5 mins
    ${response_branch_info}    Get Request and return body    ${endpoint_branch_list}
    ${jsonpath_name}    Format String    $..Data[?(@.CompareBranchName=="{0}")].Name    ${branch_name}
    ${jsonpath_mobile1}    Format String    $..Data[?(@.CompareBranchName=="{0}")].ContactNumber    ${branch_name}
    ${jsonpath_mobile2}    Format String    $..Data[?(@.CompareBranchName=="{0}")].SubContactNumber    ${branch_name}
    ${jsonpath_location}    Format String    $..Data[?(@.CompareBranchName=="{0}")].LocationName    ${branch_name}
    ${jsonpath_ward}    Format String    $..Data[?(@.CompareBranchName=="{0}")].WardName    ${branch_name}
    ${jsonpath_address}    Format String    $..Data[?(@.CompareBranchName=="{0}")].Address    ${branch_name}
    ${jsonpath_email}    Format String    $..Data[?(@.CompareBranchName=="{0}")].Email    ${branch_name}
    ${jsonpath_branch_type}    Format String    $..Data[?(@.CompareBranchName=="{0}")].Type    ${branch_name}
    ${jsonpath_branch_id}    Format String    $..Data[?(@.CompareBranchName=="{0}")].Id    ${branch_name}
    ${get_branch_name}    Get data from response json    ${response_branch_info}    ${jsonpath_name}
    ${get_branch_mobile1}    Get data from response json    ${response_branch_info}    ${jsonpath_mobile1}
    ${get_branch_mobile2}    Get data from response json    ${response_branch_info}    ${jsonpath_mobile2}
    ${get_branch_location}    Get data from response json    ${response_branch_info}    ${jsonpath_location}
    ${get_branch_ward}    Get data from response json    ${response_branch_info}    ${jsonpath_ward}
    ${get_branch_address}    Get data from response json    ${response_branch_info}    ${jsonpath_address}
    ${get_branch_email}    Get data from response json    ${response_branch_info}    ${jsonpath_email}
    ${get_branch_type}    Get data from response json    ${response_branch_info}    ${jsonpath_branch_type}
    ${get_branch_id}    Get data from response json    ${response_branch_info}    ${jsonpath_branch_id}
    Should Be Equal As Strings    ${get_branch_type}    0
    Should Be Equal As Strings    ${get_branch_name}    ${branch_name}
    Should Be Equal As Strings    ${branch_mobile1}    ${get_branch_mobile1}
    Run Keyword If    '${branch_mobile2}'=='none'    Should Be Equal As Numbers    ${get_branch_mobile2}    0
    ...    ELSE    Should Be Equal As Strings    ${branch_mobile2}    ${get_branch_mobile2}
    Should Be Equal As Strings    ${branch_address}    ${get_branch_address}
    Should Be Equal As Strings    ${branch_location}    ${get_branch_location}
    Should Be Equal As Strings    ${branch_ward}    ${get_branch_ward}
    Run Keyword If    '${branch_email}'=='none'    Should Be Equal As Numbers    ${get_branch_email}    0
    ...    ELSE    Should Be Equal As Strings    ${branch_email}    ${get_branch_email}
    Return From Keyword    ${get_branch_id}

Delete Branch
    [Arguments]    ${get_id_branch}
    ${endpoint_delete_branch}    Format String    ${endpoint_delete_branch}    ${get_id_branch}
    Create Session    lolo    ${API_URL}    cookies=${resp.cookies}
    ${headers}=    Create Dictionary    Authorization=${bearertoken}
    ${resp}=    RequestsLibrary.Delete Request    lolo    ${endpoint_delete_branch}    headers=${headers}    allow_redirects=True
    Log    ${resp.request.body}
    Log    ${resp.json()}
    log    ${resp.status_code}
    Should Be Equal As Strings    ${resp.status_code}    200

Get surcharge info and validate
    [Arguments]    ${surcharge_code}    ${surcharge_name}    ${surcharge_value}    ${surcharge_chinhanh}    ${surcharge_tudong_hoadon}    ${surcharge_tudong_hoantra}
    [Timeout]    5 mins
    ${response_surcharge_info}    Get Request and return body    ${endpoint_surcharge_list_all}
    ${jsonpath_surcharge_name}    Format String    $..Data[?(@.Code=="{0}")].Name    ${surcharge_code}
    ${jsonpath_surcharge_value_vnd}    Format String    $..Data[?(@.Code=="{0}")].Value    ${surcharge_code}
    ${jsonpath_surcharge_valueratio}    Format String    $..Data[?(@.Code=="{0}")].ValueRatio    ${surcharge_code}
    ${jsonpath_trangthai}    Format String    $..Data[?(@.Code=="{0}")].isActive    ${surcharge_code}
    ${jsonpath_tudong_hoadon}    Format String    $..Data[?(@.Code=="{0}")].isAuto    ${surcharge_code}
    ${jsonpath_tudong_hoantra}    Format String    $..Data[?(@.Code=="{0}")].isReturnAuto    ${surcharge_code}
    ${jsonpath_chinhanh}    Format String    $..Data[?(@.Code=="{0}")].ForAllBranch    ${surcharge_code}
    ${jsonpath_surcharge_id}    Format String    $..Data[?(@.Code=="{0}")].Id    ${surcharge_code}
    ${get_surcharge_name}    Get data from response json    ${response_surcharge_info}    ${jsonpath_surcharge_name}
    ${get_surcharge_value_vnd}    Get data from response json    ${response_surcharge_info}    ${jsonpath_surcharge_value_vnd}
    ${get_surcharge_valueratio}    Get data from response json    ${response_surcharge_info}    ${jsonpath_surcharge_valueratio}
    ${get_surcharge_value}    Set Variable If    0 < ${surcharge_value} < 100    ${get_surcharge_valueratio}    ${get_surcharge_value_vnd}
    ${get_surcharge_value}    Replace floating point    ${get_surcharge_value}
    ${get_surcharge_trangthai}    Get data from response json and return false value    ${response_surcharge_info}    ${jsonpath_trangthai}
    ${get_surcharge_tudong_hoadon}    Get data from response json and return false value    ${response_surcharge_info}    ${jsonpath_tudong_hoadon}
    ${get_surcharge_tudong_hoantra}    Get data from response json    ${response_surcharge_info}    ${jsonpath_tudong_hoantra}
    ${get_surcharge_chinhanh}    Get data from response json and return false value    ${response_surcharge_info}    ${jsonpath_chinhanh}
    ${get_surcharge_id}    Get data from response json    ${response_surcharge_info}    ${jsonpath_surcharge_id}
    Should Be Equal As Strings    ${get_surcharge_name}    ${surcharge_name}
    Should Be Equal As Strings    ${get_surcharge_value}    ${surcharge_value}
    Should Be Equal As Strings    ${get_surcharge_trangthai}    True
    Run Keyword If    '${surcharge_tudong_hoadon}'=='true'    Should Be Equal As Strings    ${get_surcharge_tudong_hoadon}    True
    ...    ELSE    Should Be Equal As Strings    ${get_surcharge_tudong_hoadon}    False
    Run Keyword If    '${surcharge_tudong_hoantra}'=='false'    Should Be Equal As Strings    ${get_surcharge_tudong_hoantra}    0
    ...    ELSE    Should Be Equal As Strings    ${get_surcharge_tudong_hoantra}    True
    Run Keyword If    '${surcharge_chinhanh}'=='true'    Should Be Equal As Strings    ${get_surcharge_chinhanh}    True
    ...    ELSE    Should Be Equal As Strings    ${get_surcharge_chinhanh}    False

Get surcharge id frm API
    [Arguments]    ${surcharge_code}
    ${response_surcharge_info}    Get Request and return body    ${endpoint_surcharge_list_all}
    ${jsonpath_surcharge_id}    Format String    $..Data[?(@.Code=="{0}")].Id    ${surcharge_code}
    ${get_surcharge_id}    Get data from response json    ${response_surcharge_info}    ${jsonpath_surcharge_id}
    Return From Keyword    ${get_surcharge_id}

Delete Surcharge
    [Arguments]    ${get_id_surcharge}
    ${endpoint_delete_surcharge}    Format String    ${endpoint_delete_surcharge}    ${get_id_surcharge}
    Delete request thr API    ${endpoint_delete_surcharge}

Get promo info and invoice validate
    [Arguments]    ${promo_code}    ${promo_name}    ${status}    ${tongtienhang}    ${promo_value}
    [Timeout]    5 mins
    ${get_id_promo}    Get Id promotion    ${promo_code}
    ${endpoint_promo_detail}    Format String    ${endpoint_cam_detail}    ${get_id_promo}
    ${response_promo_info}    Get response from API by other url    ${PROMO_API}    ${endpoint_promo_detail}
    ${get_promo_name}    Get data from response json    ${response_promo_info}    $.Name
    ${get_promo_trangthai}    Get data from response json and return false value    ${response_promo_info}    $.IsActive
    ${get_promo_type}    Get data from response json    ${response_promo_info}    $.PromotionType
    ${get_promo_invoicevalue}    Get data from response json    ${response_promo_info}    $.SalePromotions..InvoiceValue
    ${get_promo_discount_vnd}    Get data from response json    ${response_promo_info}    $..Discount
    ${get_promo_discount_%}    Get data from response json    ${response_promo_info}    $..DiscountRatio
    ${get_promo_value}    Set Variable If    0 < ${promo_value} < 100    ${get_promo_discount_%}    ${get_promo_discount_vnd}
    Should Be Equal As Strings    ${get_promo_name}    ${promo_name}
    Should Be Equal As Numbers    ${get_promo_value}    ${promo_value}
    Should Be Equal As Strings    ${get_promo_trangthai}    ${status}
    Should Be Equal As Numbers    ${get_promo_invoicevalue}    ${tongtienhang}
    Should Be Equal As Numbers    ${get_promo_type}    1
    Return From Keyword    ${get_id_promo}

Get promo info and product validate
    [Arguments]    ${promo_code}    ${promo_name}    ${status}    ${input_sl_mua}    ${input_nhomhang_mua}    ${input_sl_giamgia}
    ...    ${input_nhomhang_giamgia}
    [Timeout]    5 mins
    ${get_id_promo}    Get Id promotion    ${promo_code}
    ${get_id_nhomhang_buy}    Get category ID    ${input_nhomhang_mua}
    ${get_id_nhomhang_discount}    Get category ID    ${input_nhomhang_giamgia}
    ${endpoint_promo_detail}    Format String    ${endpoint_cam_detail}    ${get_id_promo}
    ${response_promo_info}    Get response from API by other url    ${PROMO_API}    ${endpoint_promo_detail}
    ${get_promo_name}    Get data from response json    ${response_promo_info}    $.Name
    ${get_promo_trangthai}    Get data from response json and return false value    ${response_promo_info}    $.IsActive
    ${get_promo_type}    Get data from response json    ${response_promo_info}    $.PromotionType
    ${get_promo_quantity_buy}    Get data from response json    ${response_promo_info}    $..PrereqQuantity
    ${get_promo_id_category_buy}    Get data from response json    ${response_promo_info}    $..PrereqCategoryId
    ${get_promo_quantity_discount}    Get data from response json    ${response_promo_info}    $..ReceivedQuantity
    ${get_promo_id_category_discount}    Get data from response json    ${response_promo_info}    $..ReceivedCategoryId
    Should Be Equal As Strings    ${get_promo_name}    ${promo_name}
    Should Be Equal As Strings    ${get_promo_trangthai}    ${status}
    Should Be Equal As Numbers    ${get_promo_type}    6
    Should Be Equal As Numbers    ${get_promo_quantity_buy}    ${input_sl_mua}
    Should Be Equal As Numbers    ${get_promo_quantity_discount}    ${input_sl_giamgia}
    Should Be Equal As Numbers    ${get_promo_id_category_buy}    ${get_id_nhomhang_buy}
    Should Be Equal As Numbers    ${get_promo_id_category_discount}    ${get_id_nhomhang_discount}
    Return From Keyword    ${get_id_promo}

Get promo info and invoice - product validate
    [Arguments]    ${promo_code}    ${promo_name}    ${status}    ${input_sl_mua}    ${input_nhomhang_mua}    ${input_sl_giamgia}
    ...    ${input_nhomhang_giamgia}    ${tongtienhang}    ${promo_value}
    [Timeout]    5 mins
    ${get_id_promo}    Get Id promotion    ${promo_code}
    ${get_id_nhomhang_buy}    Get category ID    ${input_nhomhang_mua}
    ${get_id_nhomhang_discount}    Get category ID    ${input_nhomhang_giamgia}
    ${endpoint_promo_detail}    Format String    ${endpoint_cam_detail}    ${get_id_promo}
    ${response_promo_info}    Get response from API by other url    ${PROMO_API}    ${endpoint_promo_detail}
    ${get_promo_name}    Get data from response json    ${response_promo_info}    $.Name
    ${get_promo_trangthai}    Get data from response json and return false value    ${response_promo_info}    $.IsActive
    ${get_promo_type}    Get data from response json    ${response_promo_info}    $.PromotionType
    ${get_promo_quantity_buy}    Get data from response json    ${response_promo_info}    $..PrereqQuantity
    ${get_promo_id_category_buy}    Get data from response json    ${response_promo_info}    $..PrereqCategoryId
    ${get_promo_quantity_discount}    Get data from response json    ${response_promo_info}    $..ReceivedQuantity
    ${get_promo_id_category_discount}    Get data from response json    ${response_promo_info}    $..ReceivedCategoryId
    ${get_promo_invoicevalue}    Get data from response json    ${response_promo_info}    $.SalePromotions..InvoiceValue
    ${get_promo_discount_vnd}    Get data from response json    ${response_promo_info}    $..ProductDiscount
    ${get_promo_discount_%}    Get data from response json    ${response_promo_info}    $..ProductDiscountRatio
    ${get_promo_value}    Set Variable If    0 < ${promo_value} < 100    ${get_promo_discount_%}    ${get_promo_discount_vnd}
    Should Be Equal As Strings    ${get_promo_name}    ${promo_name}
    Should Be Equal As Strings    ${get_promo_trangthai}    ${status}
    Should Be Equal As Numbers    ${get_promo_type}    17
    Should Be Equal As Numbers    ${get_promo_quantity_buy}    ${input_sl_mua}
    Should Be Equal As Numbers    ${get_promo_quantity_discount}    ${input_sl_giamgia}
    Should Be Equal As Numbers    ${get_promo_id_category_buy}    ${get_id_nhomhang_buy}
    Should Be Equal As Numbers    ${get_promo_id_category_discount}    ${get_id_nhomhang_discount}
    Should Be Equal As Numbers    ${get_promo_invoicevalue}    ${tongtienhang}
    Should Be Equal As Numbers    ${get_promo_value}    ${promo_value}
    Return From Keyword    ${get_id_promo}

Delete promo
    [Arguments]    ${get_id_promo}
    ${endpoint_delete_promo}    Format String    ${endpoint_delete_promo}    ${get_id_promo}
    Delete request by other URL API    ${PROMO_API}    ${endpoint_delete_promo}

Get audit trail no payment info and validate
    [Arguments]    ${ma_giaodich}    ${function_name}    ${input_thaotac}
    ${date_current}    Get Current Date    result_format=%Y-%m-%d
    ${get_id_nguoiban}    Get User ID
    ${endpoint_audittrail_detail}    Format String    ${endpoint_audittrail_detail}    ${BranchID}    ${ma_giaodich}    ${date_current}
    ${response_audittrail_info}    Get Request and return body    ${endpoint_audittrail_detail}
    ${jsonpath_id_nhanvien}    Format String    $.Data[?(@.FunctionName =='{0}')].UserId    ${function_name}
    ${jsonpath_thoigian}    Format String    $.Data[?(@.FunctionName =='{0}')].CreatedDate    ${function_name}
    ${jsonpath_thaotac}    Format String    $.Data[?(@.FunctionName =='{0}')].ActionName    ${function_name}
    ${jsonpath_id_chinhanh}    Format String    $.Data[?(@.FunctionName =='{0}')].BranchId    ${function_name}
    ${jsonpath_id_noidung}    Format String    $.Data[?(@.FunctionName =='{0}')].SubContent    ${function_name}
    ${get_lstt_id_nv}    Get data from response json    ${response_audittrail_info}    ${jsonpath_id_nhanvien}
    ${get_lstt_thoigian}    Get data from response json    ${response_audittrail_info}    ${jsonpath_thoigian}
    ${time_cut}    Replace String    ${get_lstt_thoigian}    0000+07:00    ${EMPTY}
    ${get_lstt_thoigian}    Convert Date    ${time_cut}    exclude_millis=yes    result_format=%Y-%m-%d
    ${get_lstt_thaotac}    Get data from response json    ${response_audittrail_info}    ${jsonpath_thaotac}
    ${get_lstt_id_chinhanh}    Get data from response json    ${response_audittrail_info}    ${jsonpath_id_chinhanh}
    Should Be Equal As Numbers    ${get_lstt_id_nv}    ${get_id_nguoiban}
    Should Be Equal As Strings    ${get_lstt_thoigian}    ${date_current}
    Should Be Equal As Strings    ${get_lstt_thaotac}    ${input_thaotac}
    Should Be Equal As Numbers    ${get_lstt_id_chinhanh}    ${BRANCH_ID}

Get audit trail payment info and validate
    [Arguments]    ${ma_giaodich}    ${function_name}    ${function_payment}    ${input_thaotac}
    ${date_current}    Get Current Date    result_format=%Y-%m-%d
    ${get_id_nguoiban}    Get User ID
    ${endpoint_audittrail_detail}    Format String    ${endpoint_audittrail_detail}    ${BranchID}    ${ma_giaodich}    ${date_current}
    ${response_audittrail_info}    Get Request and return body    ${endpoint_audittrail_detail}
    ${jsonpath_id_nhanvien}    Format String    $.Data[?(@.FunctionName =='{0}')].UserId    ${function_name}
    ${jsonpath_thoigian}    Format String    $.Data[?(@.FunctionName =='{0}')].CreatedDate    ${function_name}
    ${jsonpath_thaotac}    Format String    $.Data[?(@.FunctionName =='{0}')].ActionName    ${function_name}
    ${jsonpath_id_chinhanh}    Format String    $.Data[?(@.FunctionName =='{0}')].BranchId    ${function_name}
    ${jsonpath_id_nhanvien_payment}    Format String    $.Data[?(@.FunctionName =='{0}')].UserId    ${function_payment}
    ${jsonpath_thoigian_payment}    Format String    $.Data[?(@.FunctionName =='{0}')].CreatedDate    ${function_payment}
    ${jsonpath_thaotac_payment}    Format String    $.Data[?(@.FunctionName =='{0}')].ActionName    ${function_payment}
    ${jsonpath_id_chinhanh_payment}    Format String    $.Data[?(@.FunctionName =='{0}')].BranchId    ${function_payment}
    ${get_lstt_id_nv}    Get data from response json    ${response_audittrail_info}    ${jsonpath_id_nhanvien}
    ${get_lstt_thoigian}    Get data from response json    ${response_audittrail_info}    ${jsonpath_thoigian}
    ${time_cut}    Replace String    ${get_lstt_thoigian}    0000+07:00    ${EMPTY}
    ${get_lstt_thoigian}    Convert Date    ${time_cut}    exclude_millis=yes    result_format=%Y-%m-%d
    ${get_lstt_thaotac}    Get data from response json    ${response_audittrail_info}    ${jsonpath_thaotac}
    ${get_lstt_id_chinhanh}    Get data from response json    ${response_audittrail_info}    ${jsonpath_id_chinhanh}
    ${get_lstt_id_nv_payment}    Get data from response json    ${response_audittrail_info}    ${jsonpath_id_nhanvien_payment}
    ${get_lstt_thoigian_payment}    Get data from response json    ${response_audittrail_info}    ${jsonpath_thoigian}
    ${time_cut}    Replace String    ${get_lstt_thoigian}    0000+07:00    ${EMPTY}
    ${get_lstt_thoigian_payment}    Convert Date    ${time_cut}    exclude_millis=yes    result_format=%Y-%m-%d
    ${get_lstt_thaotac_payment}    Get data from response json    ${response_audittrail_info}    ${jsonpath_thaotac_payment}
    ${get_lstt_id_chinhanh_payment}    Get data from response json    ${response_audittrail_info}    ${jsonpath_id_chinhanh_payment}
    Should Be Equal As Numbers    ${get_lstt_id_nv}    ${get_id_nguoiban}
    Should Be Equal As Strings    ${get_lstt_thoigian}    ${date_current}
    Should Be Equal As Strings    ${get_lstt_thaotac}    ${input_thaotac}
    Should Be Equal As Numbers    ${get_lstt_id_chinhanh}    ${BRANCH_ID}
    Should Be Equal As Numbers    ${get_lstt_id_nv_payment}    ${get_id_nguoiban}
    Should Be Equal As Strings    ${get_lstt_thoigian_payment}    ${date_current}
    Should Be Equal As Strings    ${get_lstt_thaotac_payment}    ${input_thaotac}
    Should Be Equal As Numbers    ${get_lstt_id_chinhanh_payment}    ${BRANCH_ID}

Get shop config info and validate
    [Arguments]    ${input_electronic}
    ${resp_config}    Get Request and return body    ${endpoint_shop_config_list}
    ${get_cofig_cod}    Get data from response json    ${resp_config}    $.UseCod
    ${get_cofig_sellwhenoutstock}    Get data from response json    ${resp_config}    $.AllowSellWhenOutStock
    ${get_cofig_order}    Get data from response json    ${resp_config}    $.SellAllowOrder
    ${get_cofig_orderwhenoutstock}    Get data from response json    ${resp_config}    $.AllowOrderWhenOutStock
    ${get_cofig_cost}    Get data from response json    ${resp_config}    $.UseAvgCost
    ${get_cofig_product_unit}    Get data from response json    ${resp_config}    $.UseMultiUnit
    ${get_cofig_surcharge}    Get data from response json    ${resp_config}    $.UseSurcharge
    ${get_cofig_print}    Get data from response json    ${resp_config}    $.PrintPreview
    ${get_cofig_promo}    Get data from response json    ${resp_config}    $.UsePromotion
    ${get_cofig_orderpromo}    Get data from response json    ${resp_config}    $.UsePromotionForOrder
    ${get_cofig_sellwhenorder}    Get data from response json    ${resp_config}    $.AllowSellWhenOrderOutStock
    ${get_cofig_change_orderdate}    Get data from response json    ${resp_config}    $.NotAllowModifyOrderDate
    ${get_cofig_change_invoicedate}    Get data from response json    ${resp_config}    $.NotAllowModifyInvoiceDate
    ${get_cofig_change_returndate}    Get data from response json    ${resp_config}    $.NotAllowModifyReturnDate
    ${get_cofig_electronic}    Get data from response json    ${resp_config}    $.UseElectronicScales
    Should Be Equal As Strings    ${get_cofig_cod}    True
    Should Be Equal As Strings    ${get_cofig_sellwhenoutstock}    True
    Should Be Equal As Strings    ${get_cofig_order}    True
    Should Be Equal As Strings    ${get_cofig_orderwhenoutstock}    True
    Should Be Equal As Strings    ${get_cofig_product_unit}    True
    Should Be Equal As Strings    ${get_cofig_surcharge}    True
    Should Be Equal As Strings    ${get_cofig_print}    True
    Should Be Equal As Strings    ${get_cofig_promo}    True
    Should Be Equal As Strings    ${get_cofig_orderpromo}    True
    Should Be Equal As Strings    ${get_cofig_sellwhenorder}    True
    Should Be Equal As Strings    ${get_cofig_change_orderdate}    True
    Should Be Equal As Strings    ${get_cofig_change_invoicedate}    True
    Should Be Equal As Strings    ${get_cofig_change_returndate}    True
    Should Be Equal As Strings    ${get_cofig_electronic}    ${input_electronic}


Get status electronic - sms - manufac frm API
    ${resp_config}    Get Request and return body    ${endpoint_shop_config_list}
    ${get_cofig_manufac}    Get data from response json    ${resp_config}    $.UseManufacturing
    ${get_cofig_electronic}    Get data from response json    ${resp_config}    $.UseElectronicScales
    ${get_cofig_sms_email}    Get data from response json    ${resp_config}    $.SMSEmailMarketing
    Return From Keyword        ${get_cofig_manufac}    ${get_cofig_electronic}    ${get_cofig_sms_email}

Turn off value in shop config by api
    [Arguments]    ${input_manufac}
    ${request_payload}      Set Variable    {"Key":"UseElectronicScales","Settings":{"ManagerCustomerByBranch":false,"TimeSheet":true,"UseLazadaIntergate":false,"RewardPoint":true,"BookClosing":false,"UseCod":true,"UseShopeeIntergate":false,"IsBatchExpireIndustry":false,"SellAllowDeposit":false,"ShowPaymentMethod":false,"AllowSellWhenOutStock":true,"IsLimitUserDeviceAccess":false,"IsOffTwoFa":false,"SellDefaultChange":true,"LimitTimeReturn":false,"SellAllowOrder":true,"AllowOrderWhenOutStock":true,"UseTokenApi":false,"PurchaseDefaultChange":false,"AllowUsedDebtorCustomer":false,"LimitDebtorValue":false,"AllowUsedDebtorSupplier":false,"UseAvgCost":true,"UseVariants":true,"UseMultiUnit":true,"UseAutoSuggestProduct":true,"UseImei":false,"UseBatchExpire":false,"UseBarcode":true,"UseCodBranchReceiverReturnConfirm":false,"AutoCheckCod":false,"UsePriceCod":true,"UseCodByKvCarrier":false,"UseSurcharge":true,"HideKVInfo":false,"UseCustomLogo":false,"HideKVAd":false,"UseTotalQuantity":true,"PrintPreview":true,"SMSEmailMarketing":true,"UsePromotion":true,"UseSaleOnline":true,"UsePromotionCombine":false,"UsePromotionForOrder":true,"UseAutoPromotionForInvoice":false,"ExpensesOther":true,"UseVoucher":true,"UseVoucherCombinePromotion":false,"AllowReturnInvoiceHasVoucher":false,"UseElectronicScales":false,"ElectronicScalesCodePad":6,"ChecksumCodePad":0,"AutoSyncKitchen":true,"AllowSellWhenOrderOutStock":true,"UseManufacturing":true,"UseLazadaIntergate":true,"UseShopeeIntergate":true,"UseTikiIntergate":true,"UseSendoIntergate":true,"UseOmniChannelIntergate":true,"NotAllowModifyPurchaseDate":false,"UseExportReportEod":false,"NotAllowModifyOrderDate":true,"NotAllowModifyInvoiceDate":true,"NotAllowModifyReturnDate":true,"NotAllowModifyOrderSupplierDate":false,"NotAllowModifyPurchaseOrderDate":false,"NotAllowModifyPurchaseReturnDate":false,"NotAllowModifyTransferDate":false,"NotAllowModifyDemageItemsDate":false,"NotAllowModifyCashFlowDate":false,"NotAllowModifyStockTakeDate":false,"NotAllowModifyManufacturingDate":false,"RewardPoint_MoneyPerPoint":0,"RewardPoint_IsPointToMoney":false,"RewardPoint_PointToMoney":0,"RewardPoint_MoneyToPoint":0,"RewardPoint_ForDiscountProduct":false,"RewardPoint_ForDiscountInvoice":false,"RewardPoint_ForInvoiceUsingRewardPoint":false,"RewardPoint_ForInvoiceUsingVoucher":false,"RewardPoint_ForAllCustomer":false,"RewardPoint_InvoiceCount":0,"RewardPoint_Type":0,"RewardPoint_Product_IsMoneyPerPoint":true,"RewardPoint_Product_MoneyPerPoint":10000,"RewardPoint_Product_IsPointToMoney":false,"RewardPoint_Product_PointToMoney":0,"RewardPoint_Product_MoneyToPoint":0,"RewardPoint_Product_ForDiscountProduct":false,"RewardPoint_Product_ForDiscountInvoice":false,"RewardPoint_Product_ForInvoiceUsingRewardPoint":false,"RewardPoint_Product_ForInvoiceUsingVoucher":false,"RewardPoint_Product_ForAllCustomer":false,"RewardPoint_Product_InvoiceCount":0,"UseLimitTimeToReturn":false,"ManagerSupplierByBranch":false,"IsWarningReturn":true,"NumberDayToReturn":null,"UseMyKiot":false,"UseOrderSupplier":true,"Warranty":true,"Warranty_RemindOutOfWarrantyDate":false,"WarrantyNotifyDefault":true,"Warranty_RemindOutOfWarrantyDate_BeforeNumDays":0,"Warranty_RemindRepeatWarrantyDate":false,"MaintenanceNotifyDefault":true,"Warranty_RemindRepeatWarrantyDate_BeforeNumDays":0,"Warranty_RemindReturningWarrantyProduct":false,"Warranty_RemindReturningWarrantyProduct_BeforeNumDays":0,"Warranty_DefaultDeliveryDateWarrantyProduct_AfterNumDays":0,"CodePad":6,"IsConnectVG":false,"VgAppToken":"","MailServiceType":0,"GoogleMailAccount":"","GoogleMailPassword":"","YahooMailAccount":"","YahooMailPassword":"","SmtpServer":"","RetailerEmail":"","RetailerEmailAccount":"","RetailerEmailPassword":"","ReplyEmail":"","BccEmail":"","Port":0,"IsUseSSL":false,"CountKiotMailInMonth":0,"LastestSentKiotMail":23,"IsConnectedZalo":false,"ZaloBranchName":"","ZaloBranchId":-1,"ZaloName":"","IsUseZaloSmsHappyBirthday":true,"IsUseZaloSmsConfirmOrder":true,"IsUseZaloSmsConfirmInvoice":true,"ZaloSmsHappyBirthday":"{Ten_Cua_Hang} trân trọng chúc quý khách {Khach_Hang} những lời chúc tốt đẹp nhất nhân dịp sinh nhật. Kính chúc quý khách một sinh nhật nhiều niềm vui và hạnh phúc.","ZaloSmsConfirmOrder":"{Ten_Cua_Hang} cảm ơn quý khách đã đặt hàng tại cửa hàng. Đơn hàng {Ma_Don_Hang} gồm hàng hóa {Ten_Hang_Hoa} với tổng số tiền {Tong_Cong}.","ZaloSmsConfirmInvoice":"{Ten_Cua_Hang} shop cảm ơn quý khách đã mua hàng tại cửa hàng. Đơn hàng mã {Ma_Don_Hang} gồm hàng hóa {Ten_Hang_Hoa} với tổng số tiền {Tong_Cong}.","CodEmailReceiver":"","CodEmailNotification":"","CodContactNumberReceiver":256378913,"CodAccountId":7152,"IsConnectedClientDelivery":true,"IsConnectedPublicApi":false,"UsingMomoPayment":false,"MomoAccountId":0,"MomoEmailReceiver":"","MomoPhoneReceiver":"","MomoPaymentBranchId":0,"RetrictGmbFeature":false,"MomoToken":"","UseFileExportSecurity":false},"UpdateKeys":["ElectronicScalesCodePad","ChecksumCodePad","UseElectronicScales"]}
    Log    ${request_payload}
    Post request thr API    ${endpoint_shop_config_list}     ${request_payload}

Turn on - off allow sell when out stock in shop config thr API
    [Arguments]     ${status}
    ${request_payload}      Format String    {{"Key":"AllowSellWhenOutStock","Settings":{{"UseCod":true,"RewardPoint":true,"ManagerCustomerByBranch":false,"SellAllowDeposit":false,"ShowPaymentMethod":false,"AllowSellWhenOutStock":{0},"IsLimitUserDeviceAccess":false,"IsOffTwoFa":false,"SellDefaultChange":true,"LimitTimeReturn":false,"SellAllowOrder":true,"AllowOrderWhenOutStock":true,"UseTokenApi":false,"PurchaseDefaultChange":false,"AllowUsedDebtorCustomer":false,"LimitDebtorValue":false,"AllowUsedDebtorSupplier":false,"UseAvgCost":true,"UseVariants":true,"UseMultiUnit":true,"UseImei":true,"UseBatchExpire":false,"UseBarcode":true,"UseCodBranchReceiverReturnConfirm":false,"AutoCheckCod":false,"UsePriceCod":true,"UseCodByKvCarrier":false,"UseSurcharge":true,"HideKVInfo":false,"UseCustomLogo":false,"HideKVAd":false,"UseTotalQuantity":true,"PrintPreview":true,"SMSEmailMarketing":true,"UsePromotion":true,"UseSaleOnline":true,"UsePromotionCombine":false,"UsePromotionForOrder":true,"UseAutoPromotionForInvoice":false,"ExpensesOther":true,"UseVoucher":true,"UseVoucherCombinePromotion":false,"AllowReturnInvoiceHasVoucher":false,"UseElectronicScales":false,"ElectronicScalesCodePad":6,"ChecksumCodePad":0,"AutoSyncKitchen":true,"AllowSellWhenOrderOutStock":true,"UseManufacturing":true,"UseLazadaIntergate":true,"UseShopeeIntergate":true,"UseTikiIntergate":true,"UseSendoIntergate":true,"UseOmniChannelIntergate":true,"NotAllowModifyPurchaseDate":false,"UseExportReportEod":false,"NotAllowModifyOrderDate":true,"NotAllowModifyInvoiceDate":true,"NotAllowModifyReturnDate":true,"NotAllowModifyOrderSupplierDate":false,"NotAllowModifyPurchaseOrderDate":false,"NotAllowModifyPurchaseReturnDate":false,"NotAllowModifyTransferDate":false,"NotAllowModifyDemageItemsDate":false,"NotAllowModifyCashFlowDate":false,"NotAllowModifyStockTakeDate":false,"NotAllowModifyManufacturingDate":false,"RewardPoint_MoneyPerPoint":10000,"RewardPoint_IsPointToMoney":true,"RewardPoint_PointToMoney":1,"RewardPoint_MoneyToPoint":1000,"RewardPoint_ForDiscountProduct":false,"RewardPoint_ForDiscountInvoice":false,"RewardPoint_ForInvoiceUsingRewardPoint":false,"RewardPoint_ForInvoiceUsingVoucher":false,"RewardPoint_ForAllCustomer":true,"RewardPoint_InvoiceCount":0,"RewardPoint_Type":0,"RewardPoint_Product_IsMoneyPerPoint":true,"RewardPoint_Product_MoneyPerPoint":10000,"RewardPoint_Product_IsPointToMoney":false,"RewardPoint_Product_PointToMoney":0,"RewardPoint_Product_MoneyToPoint":0,"RewardPoint_Product_ForDiscountProduct":false,"RewardPoint_Product_ForDiscountInvoice":false,"RewardPoint_Product_ForInvoiceUsingRewardPoint":false,"RewardPoint_Product_ForInvoiceUsingVoucher":false,"RewardPoint_Product_ForAllCustomer":false,"RewardPoint_Product_InvoiceCount":0,"UseLimitTimeToReturn":false,"BookClosing":false,"ManagerSupplierByBranch":false,"IsWarningReturn":true,"NumberDayToReturn":null,"UseMyKiot":false,"UseOrderSupplier":true,"Warranty":true,"TimeSheet":true,"Warranty_RemindOutOfWarrantyDate":false,"WarrantyNotifyDefault":true,"Warranty_RemindOutOfWarrantyDate_BeforeNumDays":0,"Warranty_RemindRepeatWarrantyDate":false,"MaintenanceNotifyDefault":true,"Warranty_RemindRepeatWarrantyDate_BeforeNumDays":0,"Warranty_RemindReturningWarrantyProduct":false,"Warranty_RemindReturningWarrantyProduct_BeforeNumDays":0,"Warranty_DefaultDeliveryDateWarrantyProduct_AfterNumDays":0,"CodePad":6,"IsConnectVG":false,"VgAppToken":"","MailServiceType":0,"GoogleMailAccount":"","GoogleMailPassword":"","YahooMailAccount":"","YahooMailPassword":"","SmtpServer":"","RetailerEmail":"","RetailerEmailAccount":"","RetailerEmailPassword":"","ReplyEmail":"","BccEmail":"","Port":0,"IsUseSSL":false,"CountKiotMailInMonth":0,"LastestSentKiotMail":29,"IsConnectedZalo":false,"ZaloBranchName":"","ZaloBranchId":-1,"ZaloName":"","IsUseZaloSmsHappyBirthday":true,"IsUseZaloSmsConfirmOrder":true,"IsUseZaloSmsConfirmInvoice":true,"ZaloSmsHappyBirthday":"{{Ten_Cua_Hang}} trân trọng chúc quý khách {{Khach_Hang}} những lời chúc tốt đẹp nhất nhân dịp sinh nhật. Kính chúc quý khách một sinh nhật nhiều niềm vui và hạnh phúc.","ZaloSmsConfirmOrder":"{{Ten_Cua_Hang}} cảm ơn quý khách đã đặt hàng tại cửa hàng. Đơn hàng {{Ma_Don_Hang}} gồm hàng hóa {{Ten_Hang_Hoa}} với tổng số tiền {{Tong_Cong}}.","ZaloSmsConfirmInvoice":"{{Ten_Cua_Hang}} shop cảm ơn quý khách đã mua hàng tại cửa hàng. Đơn hàng mã {{Ma_Don_Hang}} gồm hàng hóa {{Ten_Hang_Hoa}} với tổng số tiền {{Tong_Cong}}.","CodEmailReceiver":"","CodEmailNotification":"","CodContactNumberReceiver":"#retailer_phone_default","CodAccountId":0,"IsConnectedClientDelivery":false}},"UpdateKeys":["AllowSellWhenOutStock"]}}    ${status}
    Log    ${request_payload}
    Post request thr API    ${endpoint_shop_config_list}     ${request_payload}

Turn on allow use auto promotion invoice in shop config
    ${request_payload}    Set Variable    {"Key":"UsePromotion","Settings":{"SellAllowDeposit":false,"ShowPaymentMethod":false,"AllowSellWhenOutStock":true,"IsLimitUserDeviceAccess":false,"IsOffTwoFa":false,"SellDefaultChange":true,"LimitTimeReturn":false,"SellAllowOrder":true,"AllowOrderWhenOutStock":true,"UseTokenApi":false,"PurchaseDefaultChange":false,"AllowUsedDebtorCustomer":false,"LimitDebtorValue":false,"AllowUsedDebtorSupplier":false,"UseAvgCost":true,"UseVariants":true,"UseMultiUnit":true,"UseImei":true,"UseBatchExpire":false,"UseBarcode":true,"UseCod":true,"UseCodBranchReceiverReturnConfirm":false,"AutoCheckCod":false,"UsePriceCod":true,"UseCodByKvCarrier":false,"UseSurcharge":true,"HideKVInfo":false,"UseCustomLogo":false,"HideKVAd":false,"UseTotalQuantity":true,"PrintPreview":true,"SMSEmailMarketing":true,"UsePromotion":true,"UseSaleOnline":true,"UsePromotionCombine":false,"UsePromotionForOrder":true,"UseAutoPromotionForInvoice":true,"ExpensesOther":true,"UseVoucher":true,"UseVoucherCombinePromotion":false,"AllowReturnInvoiceHasVoucher":false,"UseElectronicScales":false,"ElectronicScalesCodePad":6,"ChecksumCodePad":0,"AutoSyncKitchen":true,"AllowSellWhenOrderOutStock":true,"UseManufacturing":true,"UseLazadaIntergate":true,"UseShopeeIntergate":true,"UseTikiIntergate":true,"UseSendoIntergate":true,"UseOmniChannelIntergate":true,"NotAllowModifyPurchaseDate":false,"UseExportReportEod":false,"NotAllowModifyOrderDate":true,"NotAllowModifyInvoiceDate":true,"NotAllowModifyReturnDate":true,"NotAllowModifyOrderSupplierDate":false,"NotAllowModifyPurchaseOrderDate":false,"NotAllowModifyPurchaseReturnDate":false,"NotAllowModifyTransferDate":false,"NotAllowModifyDemageItemsDate":false,"NotAllowModifyCashFlowDate":false,"NotAllowModifyStockTakeDate":false,"NotAllowModifyManufacturingDate":false,"RewardPoint":true,"RewardPoint_MoneyPerPoint":10000,"RewardPoint_IsPointToMoney":true,"RewardPoint_PointToMoney":1,"RewardPoint_MoneyToPoint":1000,"RewardPoint_ForDiscountProduct":false,"RewardPoint_ForDiscountInvoice":false,"RewardPoint_ForInvoiceUsingRewardPoint":false,"RewardPoint_ForInvoiceUsingVoucher":false,"RewardPoint_ForAllCustomer":true,"RewardPoint_InvoiceCount":0,"RewardPoint_Type":0,"RewardPoint_Product_IsMoneyPerPoint":true,"RewardPoint_Product_MoneyPerPoint":10000,"RewardPoint_Product_IsPointToMoney":false,"RewardPoint_Product_PointToMoney":0,"RewardPoint_Product_MoneyToPoint":0,"RewardPoint_Product_ForDiscountProduct":false,"RewardPoint_Product_ForDiscountInvoice":false,"RewardPoint_Product_ForInvoiceUsingRewardPoint":false,"RewardPoint_Product_ForInvoiceUsingVoucher":false,"RewardPoint_Product_ForAllCustomer":false,"RewardPoint_Product_InvoiceCount":0,"UseLimitTimeToReturn":false,"BookClosing":false,"ManagerCustomerByBranch":false,"ManagerSupplierByBranch":false,"IsWarningReturn":true,"NumberDayToReturn":null,"UseMyKiot":false,"UseOrderSupplier":true,"Warranty":true,"TimeSheet":true,"Warranty_RemindOutOfWarrantyDate":false,"WarrantyNotifyDefault":true,"Warranty_RemindOutOfWarrantyDate_BeforeNumDays":0,"Warranty_RemindRepeatWarrantyDate":false,"MaintenanceNotifyDefault":true,"Warranty_RemindRepeatWarrantyDate_BeforeNumDays":0,"Warranty_RemindReturningWarrantyProduct":false,"Warranty_RemindReturningWarrantyProduct_BeforeNumDays":0,"Warranty_DefaultDeliveryDateWarrantyProduct_AfterNumDays":0,"CodePad":6,"IsConnectVG":false,"VgAppToken":"","MailServiceType":0,"GoogleMailAccount":"","GoogleMailPassword":"","YahooMailAccount":"","YahooMailPassword":"","SmtpServer":"","RetailerEmail":"","RetailerEmailAccount":"","RetailerEmailPassword":"","ReplyEmail":"","BccEmail":"","Port":0,"IsUseSSL":false,"CountKiotMailInMonth":0,"LastestSentKiotMail":29,"IsConnectedZalo":false,"ZaloBranchName":"","ZaloBranchId":-1,"ZaloName":"","IsUseZaloSmsHappyBirthday":true,"IsUseZaloSmsConfirmOrder":true,"IsUseZaloSmsConfirmInvoice":true,"ZaloSmsHappyBirthday":"{{Ten_Cua_Hang}} trân trọng chúc quý khách {{Khach_Hang}} những lời chúc tốt đẹp nhất nhân dịp sinh nhật. Kính chúc quý khách một sinh nhật nhiều niềm vui và hạnh phúc.","ZaloSmsConfirmOrder":"{{Ten_Cua_Hang}} cảm ơn quý khách đã đặt hàng tại cửa hàng. Đơn hàng {{Ma_Don_Hang}} gồm hàng hóa {{Ten_Hang_Hoa}} với tổng số tiền {{Tong_Cong}}.","ZaloSmsConfirmInvoice":"{{Ten_Cua_Hang}} shop cảm ơn quý khách đã mua hàng tại cửa hàng. Đơn hàng mã {{Ma_Don_Hang}} gồm hàng hóa {{Ten_Hang_Hoa}} với tổng số tiền {{Tong_Cong}}.","CodEmailReceiver":"","CodEmailNotification":"","CodContactNumberReceiver":"#retailer_phone_default","CodAccountId":0,"IsConnectedClientDelivery":false},"UpdateKeys":["UsePromotionCombine","UsePromotionForOrder","UseAutoPromotionForInvoice"]}
    Log    ${request_payload}
    Post request thr API    ${endpoint_shop_config_list}     ${request_payload}

Turn off allow use auto promotion invoice in shop config
    ${request_payload}    Set Variable    {"Key":"UsePromotion","Settings":{"SellAllowDeposit":false,"ShowPaymentMethod":false,"AllowSellWhenOutStock":true,"IsLimitUserDeviceAccess":false,"IsOffTwoFa":false,"SellDefaultChange":true,"LimitTimeReturn":false,"SellAllowOrder":true,"AllowOrderWhenOutStock":true,"UseTokenApi":false,"PurchaseDefaultChange":false,"AllowUsedDebtorCustomer":false,"LimitDebtorValue":false,"AllowUsedDebtorSupplier":false,"UseAvgCost":true,"UseVariants":true,"UseMultiUnit":true,"UseImei":true,"UseBatchExpire":false,"UseBarcode":true,"UseCod":true,"UseCodBranchReceiverReturnConfirm":false,"AutoCheckCod":false,"UsePriceCod":true,"UseCodByKvCarrier":false,"UseSurcharge":true,"HideKVInfo":false,"UseCustomLogo":false,"HideKVAd":false,"UseTotalQuantity":true,"PrintPreview":true,"SMSEmailMarketing":true,"UsePromotion":true,"UseSaleOnline":true,"UsePromotionCombine":false,"UsePromotionForOrder":true,"UseAutoPromotionForInvoice":false,"ExpensesOther":true,"UseVoucher":true,"UseVoucherCombinePromotion":false,"AllowReturnInvoiceHasVoucher":false,"UseElectronicScales":false,"ElectronicScalesCodePad":6,"ChecksumCodePad":0,"AutoSyncKitchen":true,"AllowSellWhenOrderOutStock":true,"UseManufacturing":true,"UseLazadaIntergate":true,"UseShopeeIntergate":true,"UseTikiIntergate":true,"UseSendoIntergate":true,"UseOmniChannelIntergate":true,"NotAllowModifyPurchaseDate":false,"UseExportReportEod":false,"NotAllowModifyOrderDate":true,"NotAllowModifyInvoiceDate":true,"NotAllowModifyReturnDate":true,"NotAllowModifyOrderSupplierDate":false,"NotAllowModifyPurchaseOrderDate":false,"NotAllowModifyPurchaseReturnDate":false,"NotAllowModifyTransferDate":false,"NotAllowModifyDemageItemsDate":false,"NotAllowModifyCashFlowDate":false,"NotAllowModifyStockTakeDate":false,"NotAllowModifyManufacturingDate":false,"RewardPoint":true,"RewardPoint_MoneyPerPoint":10000,"RewardPoint_IsPointToMoney":true,"RewardPoint_PointToMoney":1,"RewardPoint_MoneyToPoint":1000,"RewardPoint_ForDiscountProduct":false,"RewardPoint_ForDiscountInvoice":false,"RewardPoint_ForInvoiceUsingRewardPoint":false,"RewardPoint_ForInvoiceUsingVoucher":false,"RewardPoint_ForAllCustomer":true,"RewardPoint_InvoiceCount":0,"RewardPoint_Type":0,"RewardPoint_Product_IsMoneyPerPoint":true,"RewardPoint_Product_MoneyPerPoint":10000,"RewardPoint_Product_IsPointToMoney":false,"RewardPoint_Product_PointToMoney":0,"RewardPoint_Product_MoneyToPoint":0,"RewardPoint_Product_ForDiscountProduct":false,"RewardPoint_Product_ForDiscountInvoice":false,"RewardPoint_Product_ForInvoiceUsingRewardPoint":false,"RewardPoint_Product_ForInvoiceUsingVoucher":false,"RewardPoint_Product_ForAllCustomer":false,"RewardPoint_Product_InvoiceCount":0,"UseLimitTimeToReturn":false,"BookClosing":false,"ManagerCustomerByBranch":false,"ManagerSupplierByBranch":false,"IsWarningReturn":true,"NumberDayToReturn":null,"UseMyKiot":false,"UseOrderSupplier":true,"Warranty":true,"TimeSheet":true,"Warranty_RemindOutOfWarrantyDate":false,"WarrantyNotifyDefault":true,"Warranty_RemindOutOfWarrantyDate_BeforeNumDays":0,"Warranty_RemindRepeatWarrantyDate":false,"MaintenanceNotifyDefault":true,"Warranty_RemindRepeatWarrantyDate_BeforeNumDays":0,"Warranty_RemindReturningWarrantyProduct":false,"Warranty_RemindReturningWarrantyProduct_BeforeNumDays":0,"Warranty_DefaultDeliveryDateWarrantyProduct_AfterNumDays":0,"CodePad":6,"IsConnectVG":false,"VgAppToken":"","MailServiceType":0,"GoogleMailAccount":"","GoogleMailPassword":"","YahooMailAccount":"","YahooMailPassword":"","SmtpServer":"","RetailerEmail":"","RetailerEmailAccount":"","RetailerEmailPassword":"","ReplyEmail":"","BccEmail":"","Port":0,"IsUseSSL":false,"CountKiotMailInMonth":0,"LastestSentKiotMail":29,"IsConnectedZalo":false,"ZaloBranchName":"","ZaloBranchId":-1,"ZaloName":"","IsUseZaloSmsHappyBirthday":true,"IsUseZaloSmsConfirmOrder":true,"IsUseZaloSmsConfirmInvoice":true,"ZaloSmsHappyBirthday":"{{Ten_Cua_Hang}} trân trọng chúc quý khách {{Khach_Hang}} những lời chúc tốt đẹp nhất nhân dịp sinh nhật. Kính chúc quý khách một sinh nhật nhiều niềm vui và hạnh phúc.","ZaloSmsConfirmOrder":"{{Ten_Cua_Hang}} cảm ơn quý khách đã đặt hàng tại cửa hàng. Đơn hàng {{Ma_Don_Hang}} gồm hàng hóa {{Ten_Hang_Hoa}} với tổng số tiền {{Tong_Cong}}.","ZaloSmsConfirmInvoice":"{{Ten_Cua_Hang}} shop cảm ơn quý khách đã mua hàng tại cửa hàng. Đơn hàng mã {{Ma_Don_Hang}} gồm hàng hóa {{Ten_Hang_Hoa}} với tổng số tiền {{Tong_Cong}}.","CodEmailReceiver":"","CodEmailNotification":"","CodContactNumberReceiver":"#retailer_phone_default","CodAccountId":0,"IsConnectedClientDelivery":false},"UpdateKeys":["UsePromotionCombine","UsePromotionForOrder","UseAutoPromotionForInvoice"]}
    Log    ${request_payload}
    Post request thr API    ${endpoint_shop_config_list}     ${request_payload}

Turn on allow use promotion combine in shop config
    ${request_payload}    Set Variable    {"Key":"UsePromotion","Settings":{"SellAllowDeposit":false,"ShowPaymentMethod":false,"AllowSellWhenOutStock":true,"IsLimitUserDeviceAccess":false,"IsOffTwoFa":false,"SellDefaultChange":true,"LimitTimeReturn":false,"SellAllowOrder":true,"AllowOrderWhenOutStock":true,"UseTokenApi":false,"PurchaseDefaultChange":false,"AllowUsedDebtorCustomer":false,"LimitDebtorValue":false,"AllowUsedDebtorSupplier":false,"UseAvgCost":true,"UseVariants":true,"UseMultiUnit":true,"UseImei":true,"UseBatchExpire":false,"UseBarcode":true,"UseCod":true,"UseCodBranchReceiverReturnConfirm":false,"AutoCheckCod":false,"UsePriceCod":true,"UseCodByKvCarrier":false,"UseSurcharge":true,"HideKVInfo":false,"UseCustomLogo":false,"HideKVAd":false,"UseTotalQuantity":true,"PrintPreview":true,"SMSEmailMarketing":true,"UsePromotion":true,"UseSaleOnline":true,"UsePromotionCombine":true,"UsePromotionForOrder":true,"UseAutoPromotionForInvoice":false,"ExpensesOther":true,"UseVoucher":true,"UseVoucherCombinePromotion":false,"AllowReturnInvoiceHasVoucher":false,"UseElectronicScales":false,"ElectronicScalesCodePad":6,"ChecksumCodePad":0,"AutoSyncKitchen":true,"AllowSellWhenOrderOutStock":true,"UseManufacturing":true,"UseLazadaIntergate":true,"UseShopeeIntergate":true,"UseTikiIntergate":true,"UseSendoIntergate":true,"UseOmniChannelIntergate":true,"NotAllowModifyPurchaseDate":false,"UseExportReportEod":false,"NotAllowModifyOrderDate":true,"NotAllowModifyInvoiceDate":true,"NotAllowModifyReturnDate":true,"NotAllowModifyOrderSupplierDate":false,"NotAllowModifyPurchaseOrderDate":false,"NotAllowModifyPurchaseReturnDate":false,"NotAllowModifyTransferDate":false,"NotAllowModifyDemageItemsDate":false,"NotAllowModifyCashFlowDate":false,"NotAllowModifyStockTakeDate":false,"NotAllowModifyManufacturingDate":false,"RewardPoint":true,"RewardPoint_MoneyPerPoint":10000,"RewardPoint_IsPointToMoney":true,"RewardPoint_PointToMoney":1,"RewardPoint_MoneyToPoint":1000,"RewardPoint_ForDiscountProduct":false,"RewardPoint_ForDiscountInvoice":false,"RewardPoint_ForInvoiceUsingRewardPoint":false,"RewardPoint_ForInvoiceUsingVoucher":false,"RewardPoint_ForAllCustomer":true,"RewardPoint_InvoiceCount":0,"RewardPoint_Type":0,"RewardPoint_Product_IsMoneyPerPoint":true,"RewardPoint_Product_MoneyPerPoint":10000,"RewardPoint_Product_IsPointToMoney":false,"RewardPoint_Product_PointToMoney":0,"RewardPoint_Product_MoneyToPoint":0,"RewardPoint_Product_ForDiscountProduct":false,"RewardPoint_Product_ForDiscountInvoice":false,"RewardPoint_Product_ForInvoiceUsingRewardPoint":false,"RewardPoint_Product_ForInvoiceUsingVoucher":false,"RewardPoint_Product_ForAllCustomer":false,"RewardPoint_Product_InvoiceCount":0,"UseLimitTimeToReturn":false,"BookClosing":false,"ManagerCustomerByBranch":false,"ManagerSupplierByBranch":false,"IsWarningReturn":true,"NumberDayToReturn":null,"UseMyKiot":false,"UseOrderSupplier":true,"Warranty":true,"TimeSheet":true,"Warranty_RemindOutOfWarrantyDate":false,"WarrantyNotifyDefault":true,"Warranty_RemindOutOfWarrantyDate_BeforeNumDays":0,"Warranty_RemindRepeatWarrantyDate":false,"MaintenanceNotifyDefault":true,"Warranty_RemindRepeatWarrantyDate_BeforeNumDays":0,"Warranty_RemindReturningWarrantyProduct":false,"Warranty_RemindReturningWarrantyProduct_BeforeNumDays":0,"Warranty_DefaultDeliveryDateWarrantyProduct_AfterNumDays":0,"CodePad":6,"IsConnectVG":false,"VgAppToken":"","MailServiceType":0,"GoogleMailAccount":"","GoogleMailPassword":"","YahooMailAccount":"","YahooMailPassword":"","SmtpServer":"","RetailerEmail":"","RetailerEmailAccount":"","RetailerEmailPassword":"","ReplyEmail":"","BccEmail":"","Port":0,"IsUseSSL":false,"CountKiotMailInMonth":0,"LastestSentKiotMail":29,"IsConnectedZalo":false,"ZaloBranchName":"","ZaloBranchId":-1,"ZaloName":"","IsUseZaloSmsHappyBirthday":true,"IsUseZaloSmsConfirmOrder":true,"IsUseZaloSmsConfirmInvoice":true,"ZaloSmsHappyBirthday":"{{Ten_Cua_Hang}} trân trọng chúc quý khách {{Khach_Hang}} những lời chúc tốt đẹp nhất nhân dịp sinh nhật. Kính chúc quý khách một sinh nhật nhiều niềm vui và hạnh phúc.","ZaloSmsConfirmOrder":"{{Ten_Cua_Hang}} cảm ơn quý khách đã đặt hàng tại cửa hàng. Đơn hàng {{Ma_Don_Hang}} gồm hàng hóa {{Ten_Hang_Hoa}} với tổng số tiền {{Tong_Cong}}.","ZaloSmsConfirmInvoice":"{{Ten_Cua_Hang}} shop cảm ơn quý khách đã mua hàng tại cửa hàng. Đơn hàng mã {{Ma_Don_Hang}} gồm hàng hóa {{Ten_Hang_Hoa}} với tổng số tiền {{Tong_Cong}}.","CodEmailReceiver":"","CodEmailNotification":"","CodContactNumberReceiver":"#retailer_phone_default","CodAccountId":0,"IsConnectedClientDelivery":false},"UpdateKeys":["UsePromotionCombine","UsePromotionForOrder","UseAutoPromotionForInvoice"]}
    Log    ${request_payload}
    Post request thr API    ${endpoint_shop_config_list}     ${request_payload}

Turn off allow use promotion combine in shop config
    ${request_payload}    Set Variable    {"Key":"UsePromotion","Settings":{"SellAllowDeposit":false,"ShowPaymentMethod":false,"AllowSellWhenOutStock":true,"IsLimitUserDeviceAccess":false,"IsOffTwoFa":false,"SellDefaultChange":true,"LimitTimeReturn":false,"SellAllowOrder":true,"AllowOrderWhenOutStock":true,"UseTokenApi":false,"PurchaseDefaultChange":false,"AllowUsedDebtorCustomer":false,"LimitDebtorValue":false,"AllowUsedDebtorSupplier":false,"UseAvgCost":true,"UseVariants":true,"UseMultiUnit":true,"UseImei":true,"UseBatchExpire":false,"UseBarcode":true,"UseCod":true,"UseCodBranchReceiverReturnConfirm":false,"AutoCheckCod":false,"UsePriceCod":true,"UseCodByKvCarrier":false,"UseSurcharge":true,"HideKVInfo":false,"UseCustomLogo":false,"HideKVAd":false,"UseTotalQuantity":true,"PrintPreview":true,"SMSEmailMarketing":true,"UsePromotion":true,"UseSaleOnline":true,"UsePromotionCombine":false,"UsePromotionForOrder":true,"UseAutoPromotionForInvoice":false,"ExpensesOther":true,"UseVoucher":true,"UseVoucherCombinePromotion":false,"AllowReturnInvoiceHasVoucher":false,"UseElectronicScales":false,"ElectronicScalesCodePad":6,"ChecksumCodePad":0,"AutoSyncKitchen":true,"AllowSellWhenOrderOutStock":true,"UseManufacturing":true,"UseLazadaIntergate":true,"UseShopeeIntergate":true,"UseTikiIntergate":true,"UseSendoIntergate":true,"UseOmniChannelIntergate":true,"NotAllowModifyPurchaseDate":false,"UseExportReportEod":false,"NotAllowModifyOrderDate":true,"NotAllowModifyInvoiceDate":true,"NotAllowModifyReturnDate":true,"NotAllowModifyOrderSupplierDate":false,"NotAllowModifyPurchaseOrderDate":false,"NotAllowModifyPurchaseReturnDate":false,"NotAllowModifyTransferDate":false,"NotAllowModifyDemageItemsDate":false,"NotAllowModifyCashFlowDate":false,"NotAllowModifyStockTakeDate":false,"NotAllowModifyManufacturingDate":false,"RewardPoint":true,"RewardPoint_MoneyPerPoint":10000,"RewardPoint_IsPointToMoney":true,"RewardPoint_PointToMoney":1,"RewardPoint_MoneyToPoint":1000,"RewardPoint_ForDiscountProduct":false,"RewardPoint_ForDiscountInvoice":false,"RewardPoint_ForInvoiceUsingRewardPoint":false,"RewardPoint_ForInvoiceUsingVoucher":false,"RewardPoint_ForAllCustomer":true,"RewardPoint_InvoiceCount":0,"RewardPoint_Type":0,"RewardPoint_Product_IsMoneyPerPoint":true,"RewardPoint_Product_MoneyPerPoint":10000,"RewardPoint_Product_IsPointToMoney":false,"RewardPoint_Product_PointToMoney":0,"RewardPoint_Product_MoneyToPoint":0,"RewardPoint_Product_ForDiscountProduct":false,"RewardPoint_Product_ForDiscountInvoice":false,"RewardPoint_Product_ForInvoiceUsingRewardPoint":false,"RewardPoint_Product_ForInvoiceUsingVoucher":false,"RewardPoint_Product_ForAllCustomer":false,"RewardPoint_Product_InvoiceCount":0,"UseLimitTimeToReturn":false,"BookClosing":false,"ManagerCustomerByBranch":false,"ManagerSupplierByBranch":false,"IsWarningReturn":true,"NumberDayToReturn":null,"UseMyKiot":false,"UseOrderSupplier":true,"Warranty":true,"TimeSheet":true,"Warranty_RemindOutOfWarrantyDate":false,"WarrantyNotifyDefault":true,"Warranty_RemindOutOfWarrantyDate_BeforeNumDays":0,"Warranty_RemindRepeatWarrantyDate":false,"MaintenanceNotifyDefault":true,"Warranty_RemindRepeatWarrantyDate_BeforeNumDays":0,"Warranty_RemindReturningWarrantyProduct":false,"Warranty_RemindReturningWarrantyProduct_BeforeNumDays":0,"Warranty_DefaultDeliveryDateWarrantyProduct_AfterNumDays":0,"CodePad":6,"IsConnectVG":false,"VgAppToken":"","MailServiceType":0,"GoogleMailAccount":"","GoogleMailPassword":"","YahooMailAccount":"","YahooMailPassword":"","SmtpServer":"","RetailerEmail":"","RetailerEmailAccount":"","RetailerEmailPassword":"","ReplyEmail":"","BccEmail":"","Port":0,"IsUseSSL":false,"CountKiotMailInMonth":0,"LastestSentKiotMail":29,"IsConnectedZalo":false,"ZaloBranchName":"","ZaloBranchId":-1,"ZaloName":"","IsUseZaloSmsHappyBirthday":true,"IsUseZaloSmsConfirmOrder":true,"IsUseZaloSmsConfirmInvoice":true,"ZaloSmsHappyBirthday":"{{Ten_Cua_Hang}} trân trọng chúc quý khách {{Khach_Hang}} những lời chúc tốt đẹp nhất nhân dịp sinh nhật. Kính chúc quý khách một sinh nhật nhiều niềm vui và hạnh phúc.","ZaloSmsConfirmOrder":"{{Ten_Cua_Hang}} cảm ơn quý khách đã đặt hàng tại cửa hàng. Đơn hàng {{Ma_Don_Hang}} gồm hàng hóa {{Ten_Hang_Hoa}} với tổng số tiền {{Tong_Cong}}.","ZaloSmsConfirmInvoice":"{{Ten_Cua_Hang}} shop cảm ơn quý khách đã mua hàng tại cửa hàng. Đơn hàng mã {{Ma_Don_Hang}} gồm hàng hóa {{Ten_Hang_Hoa}} với tổng số tiền {{Tong_Cong}}.","CodEmailReceiver":"","CodEmailNotification":"","CodContactNumberReceiver":"#retailer_phone_default","CodAccountId":0,"IsConnectedClientDelivery":false},"UpdateKeys":["UsePromotionCombine","UsePromotionForOrder","UseAutoPromotionForInvoice"]}
    Log    ${request_payload}
    Post request thr API    ${endpoint_shop_config_list}     ${request_payload}

Get list expenses id
    [Arguments]    ${list_expense_code}
    [Timeout]    5 minute
    ${retailer_id}    Get RetailerID
    ${user_id}    Get User ID
    ${endpoint_cpnh_by_branch}    Format String    ${endpoint_expense_list}    ${BranchID}
    ${resp}       Get Request and return body    ${endpoint_cpnh_by_branch}
    ${list_cpnh_id}   Create List
    :FOR    ${item_cpnh}      IN ZIP    ${list_expense_code}
    \     ${jsonpath_expense_id}    Format String    $..Data[?(@.Code=="{0}")].Id    ${item_cpnh}
    \     ${exepense_id}    Get data from response json    ${resp}   ${jsonpath_expense_id}
    \     Append To List    ${list_cpnh_id}    ${exepense_id}
    Return From Keyword        ${list_cpnh_id}

Get location id
    [Arguments]    ${input_khuvuc}
    [Timeout]    3 minute
    ${resp}       Get Request and return body    ${endpoint_list_khuvuc}
    ${jsonpath_khuvuc}    Format String    $.Data[?(@.Name == "{0}")].Id    ${input_khuvuc}
    ${get_id_khuvuc}    Get data from response json    ${resp}    ${jsonpath_khuvuc}
    Return From Keyword        ${get_id_khuvuc}

Get ward id
    [Arguments]    ${input_phuongxa}
    [Timeout]    3 minute
    ${resp}       Get Request and return body    ${endpont_list_phuongxa}
    ${jsonpath_phuongxa}    Format String    $.Data[?(@.Name == "{0}")].Id    ${input_phuongxa}
    ${get_id_phuongxa}    Get data from response json    ${resp}    ${jsonpath_phuongxa}
    Return From Keyword        ${get_id_phuongxa}

Create new branch
    [Arguments]    ${input_tenchinhanh}    ${input_diachi}    ${input_quanhuyen}    ${input_phuongxa}   ${input_sdt}
    ${get_id_khuvuc}    Get location id    ${input_quanhuyen}
    ${get_id_phuongxa}    Get ward id    ${input_phuongxa}
    #${data_str}    Format String    {{"Branch":{{"temploc":"{0}","Name":"{1}","ContactNumber":"{2}","Address":"{3}","LocationName":"{0}","WardName":"{5}","WardId":{6},,"LocationId":{4}}},"IsAddMore":false,"IsRemove":false,"ApplyFrom":null}}    ${input_quanhuyen}
    #...     ${input_tenchinhanh}      ${input_sdt}      ${input_diachi}    ${get_id_khuvuc}
    ${data_str}    Format String    {{"Branch":{{"timeSheetBranchSetting":{{"workingDays":[1,2,3,4,5,6,0]}},"temploc":"{0}","tempw":"{1}","LocationName":"{0}","WardName":"{1}","LocationId":{2},"WardId":{3},"Name":"{4}","ContactNumber":"{5}","Address":"{6}"}},"BranchSetting":{{"workingDays":[1,2,3,4,5,6,0]}},"IsAddMore":false,"IsRemove":false,"ApplyFrom":null}}    ${input_quanhuyen}      ${input_phuongxa}     ${get_id_khuvuc}    ${get_id_phuongxa}
    ...   ${input_tenchinhanh}      ${input_sdt}      ${input_diachi}
    log    ${data_str}
    Post request thr API    /branchs     ${data_str}

Get expenses other info and validate
    [Arguments]    ${input_ma_cpnh}    ${input_ten_cpnh}    ${input_giatri_cpnh}    ${input_hinhthuc}   ${input_phamvi}    ${input_tudong_nhaphang}
    ...    ${input_hoantra_trahangnhap}
    [Timeout]    5 mins
    ${response_chiphi_info}    Get Request and return body    ${endpoint_list_chiphi_nhaphang}
    ${jsonpath_name}    Format String    $..Data[?(@.Code=="{0}")].Name    ${input_ma_cpnh}
    ${jsonpath_giatri_vnd}    Format String    $..Data[?(@.Code=="{0}")].Value    ${input_ma_cpnh}
    ${jsonpath_giatri_%}    Format String    $..Data[?(@.Code=="{0}")].ValueRatio    ${input_ma_cpnh}
    ${jsonpath_hinhthuc}    Format String    $..Data[?(@.Code=="{0}")].Form    ${input_ma_cpnh}
    ${jsonpath_branch}    Format String    $..Data[?(@.Code=="{0}")].ForAllBranch    ${input_ma_cpnh}
    ${jsonpath_tudong_nhaphang}    Format String    $..Data[?(@.Code=="{0}")].isAuto    ${input_ma_cpnh}
    ${jsonpath_status}    Format String    $..Data[?(@.Code=="{0}")].isActive    ${input_ma_cpnh}
    ${jsonpath_hoantra_trahangnhap}    Format String    $..Data[?(@.Code=="{0}")].isReturnAuto    ${input_ma_cpnh}
    ${jsonpath_id_expense}    Format String    $..Data[?(@.Code=="{0}")].Id    ${input_ma_cpnh}
    ${get_expense_name}    Get data from response json    ${response_chiphi_info}    ${jsonpath_name}
    ${get_expense_giatri_vnd}    Get data from response json    ${response_chiphi_info}    ${jsonpath_giatri_vnd}
    ${get_expense_giatri_vnd}    Replace floating point    ${get_expense_giatri_vnd}
    ${get_expense_giatri_%}    Get data from response json    ${response_chiphi_info}    ${jsonpath_giatri_%}
    ${get_expense_giatri_%}    Replace floating point    ${get_expense_giatri_%}
    ${get_expense_giatri}   Set Variable If    0 < ${input_giatri_cpnh} < 100    ${get_expense_giatri_%}    ${get_expense_giatri_vnd}
    ${get_expense_hinhthuc}    Get data from response json    ${response_chiphi_info}    ${jsonpath_hinhthuc}
    ${get_expense_branch}    Get data from response json and return false value    ${response_chiphi_info}    ${jsonpath_branch}
    ${get_expense_tudong}    Get data from response json and return false value    ${response_chiphi_info}    ${jsonpath_tudong_nhaphang}
    ${get_expense_status}     Get data from response json and return false value    ${response_chiphi_info}    ${jsonpath_status}
    ${get_expense_hoantra}    Get data from response json and return false value    ${response_chiphi_info}    ${jsonpath_hoantra_trahangnhap}
    ${get_expense_id}    Get data from response json    ${response_chiphi_info}    ${jsonpath_id_expense}
    Should Be Equal As Strings    ${get_expense_name}    ${input_ten_cpnh}
    Should Be Equal As Strings    ${get_expense_giatri}    ${input_giatri_cpnh}
    Run Keyword If    '${input_hinhthuc}'=='Chi phí nhập trả nhà cung cấp'    Should Be Equal As Numbers    ${get_expense_hinhthuc}    0
    ...     ELSE    Should Be Equal As Numbers    ${get_expense_hinhthuc}    1
    Run Keyword If    '${input_phamvi}'=='Toàn hệ thống'    Should Be Equal As Strings    ${get_expense_branch}    True
    ...     ELSE    Should Be Equal As Strings    ${get_expense_branch}    False
    Run Keyword If    '${input_tudong_nhaphang}'=='true'    Should Be Equal As Strings    ${get_expense_tudong}    True
    ...     ELSE    Should Be Equal As Strings    ${get_expense_tudong}    False
    Run Keyword If    '${input_hoantra_trahangnhap}' == 'true'    Should Be Equal As Strings    ${get_expense_hoantra}    True
    ...    ELSE IF   '${input_hoantra_trahangnhap}' == 'false'    Should Be Equal As Strings    ${get_expense_hoantra}    False
    ...    ELSE     Should Be Equal As Strings    ${get_expense_hoantra}    0
    Should Be Equal As Strings    ${get_expense_status}    True
    Return From Keyword    ${get_expense_id}

Get expenses id frm api
    [Arguments]    ${input_ma_cpnh}
    ${response_chiphi_info}    Get Request and return body    ${endpoint_list_chiphi_nhaphang}
    ${jsonpath_id_expense}    Format String    $..Data[?(@.Code=="{0}")].Id    ${input_ma_cpnh}
    ${get_expense_id}    Get data from response json    ${response_chiphi_info}    ${jsonpath_id_expense}
    Return From Keyword    ${get_expense_id}

Delete expense other
    [Arguments]    ${get_expense_id}
    ${endpoint_del_expense}    Format String    ${endpoint_del_chiphi_nhaphang}    ${get_expense_id}
    Delete request thr API    ${endpoint_del_expense}

Toggle status of promotion and not for all branch
    [Arguments]    ${promotion_code}    ${status}     ${input_ten_branch}
    [Timeout]    5 minute
    ${retailer_id}    Get RetailerID
    ${get_id_branch}    Get BranchID by BranchName    ${input_ten_branch}
    ${get_id_promo}     Get Id promotion    ${promotion_code}
    ${get_id_sale_promo}    Get Id sale promotion    ${promotion_code}
    ${curdatetime}    Get Current Date    result_format=datetime
    ${month}    Evaluate    $curdatetime.month
    ${date}    Evaluate    $curdatetime.day
    ${request_payload}    Format String    {{"Campaign":{{"Id":{0},"Name":"Khuyến mại giảm giá Hóa đơn VNĐ theo chi nhanh","IsActive":"{6}","ApplyMonths":"{1}","ApplyDates":"{2}","Weekday":null,"Hour":null,"IsGlobal":false,"ForAllUser":true,"ForAllCusGroup":true,"Type":0,"PromotionType":1,"SalePromotions":[{{"Id":{3},"Type":0,"InvoiceValue":5000000,"PromotionType":1,"Discount":200000,"RetailerId":{4},"CampaignId":{0},"PrereqApplySameKind":false,"ReceivedApplySameKind":false,"GiftIsBuyProduct":false,"DiscountType":"VND","ProductDiscountType":"VND","Uuid":""}}],"StartDate":null,"EndDate":null,"BirthdayTimeType":1,"_events":{{"change":[null]}},"_handlers":{{"CampaignBranches":{{}},"CampainCustomerGroups":{{}},"SalePromotions":{{}},"CampaignUsers":{{}}}},"Code":"{7}","CreatedDate":"2020-02-01T11:21:44.7830000","CreatedBy":438680,"ModifiedDate":"2020-02-01T11:24:53.9630000","ModifiedBy":438680,"RetailerId":{4},"CampaignBranches":[{{"BranchId":{5},"BranchName":"Nhánh A"}}],"CampainCustomerGroups":[],"CampaignUsers":[],"InvoiceValue":438680,"HasTransactions":false,"uid":"980c5287-959e-4e0e-b213-3e20700708ad","view_ApplyMonths":"Tháng 2","view_ApplyDates":"Ngày 1","view_Weekday":"","view_Hour":"","view_BirthdayTimeType":"ngày","InvoiceValueType":1,"selectedBranch":[{5}],"selectedBranchObj":[{{"Id":{5},"Name":"Nhánh A","Type":0,"Address":"129 Phố Và","Province":"Bắc Ninh","District":"Thành phố Bắc Ninh","ContactNumber":"0987878877","IsActive":true,"RetailerId":{4},"CreatedBy":438680,"LimitAccess":false,"LocationName":"Bắc Ninh - Thành phố Bắc Ninh","WardName":"Phường Hạp Lĩnh","isAcceptBookClosing":false,"GmbStatus":1,"Orders":[],"Transfers1":[],"DamageItems":[],"SurchargeBranches":[],"AdrApplications":[],"Customers":[],"Suppliers":[],"ExpensesOtherBranches":[],"OrderSuppliers":[],"WarrantyBranchGroups":[],"BranchTakingAddresses":[],"Patients":[],"Clinics":[],"Doctors":[],"DoctorQualifications":[],"DoctorSpecialities":[],"Prescriptions":[],"PayslipPayments":[],"PayslipPaymentAllocations":[],"IdOld":0,"TotalUser":1,"CompareBranchName":"Nhánh A","StatusGmbValue":"Chưa đăng ký","IsTimeSheetException":false}}],"selectedUser":[],"selectedUserObj":[],"selectedCustomerGroup":[],"selectedCustomerGroupObj":[]}}}}       ${get_id_promo}    ${month}    ${date}   ${get_id_sale_promo}    ${retailer_id}    ${get_id_branch}    ${status}   ${promotion_code}
    Post request by other URL API    ${PROMO_API}    /campaigns     ${request_payload}

Toggle status of promotion and not for all user
    [Arguments]    ${promotion_code}    ${status}     ${input_ten_user}   ${cat_sale}
    [Timeout]    5 minute
    ${get_id_cat}   Get category ID    ${cat_sale}
    ${retailer_id}    Get RetailerID
    ${get_id_user}    Get User ID by UserName    ${input_ten_user}
    ${get_id_promo}     Get Id promotion    ${promotion_code}
    ${get_id_sale_promo}    Get Id sale promotion    ${promotion_code}
    ${curdatetime}    Get Current Date    result_format=datetime
    ${month}    Evaluate    $curdatetime.month
    ${date}    Evaluate    $curdatetime.day
    ${request_payload}    Format String    {{"Campaign":{{"Id":{0},"Name":"KM theo HH hình thức giá bán theo SL mua theo user","IsActive":"{1}","ApplyMonths":"{2}","ApplyDates":"{3}","Weekday":null,"Hour":null,"IsGlobal":true,"ForAllUser":false,"ForAllCusGroup":true,"Type":1,"PromotionType":8,"SalePromotions":[{{"PrereqProductId":null,"PrereqProductIds":null,"PrereqCategoryId":{7},"PrereqCategoryIds":"{7}","PrereqEntity":{{"__type":"KiotViet.Web.Api.ProductAndGroup, KiotViet.Web.Api","Id":{7},"Name":"Nhóm:KM hàng","Code":"","Type":4,"LongName":"KM hàng","SubCategoryIds":[{7}],"IsRewardPoint":true,"HasVariants":false,"ProductIds":"","HasRelated":true,"MasterProductIds":[null],"ProductCodes":"","ApplySameKind":false,"CategoryIds":"{7}","Uuid":""}},"Type":1,"PromotionType":8,"InvoiceValue":0,"PrereqQuantity":3,"PrereqApplySameKind":false,"ProductPrice":50000,"ProductDiscount":null,"ProductDiscountRatio":null,"RetailerId":{4},"CampaignId":{0}}}],"StartDate":null,"EndDate":null,"BirthdayTimeType":1,"_events":{{"change":[null]}},"_handlers":{{"CampaignBranches":{{}},"CampainCustomerGroups":{{}},"SalePromotions":{{}},"CampaignUsers":{{}}}},"Code":"{6}","CreatedDate":"2020-01-31T10:33:03.1700000","CreatedBy":438680,"ModifiedDate":"2020-01-31T15:21:57.8430000","ModifiedBy":438680,"RetailerId":{4},"CampaignBranches":[],"CampainCustomerGroups":[],"CampaignUsers":[{{"UserId":{5},"GivenName":"tester"}}],"InvoiceValue":438680,"HasTransactions":false,"uid":"","view_ApplyMonths":"Tháng 1","view_ApplyDates":"Ngày 31","view_Weekday":"","view_Hour":"","view_BirthdayTimeType":"ngày","InvoiceValueType":1,"selectedBranch":[],"selectedBranchObj":[],"selectedUser":[{5}],"selectedUserObj":[{{"IdOld":0,"CompareGivenName":"tester","CompareIsLimitedByTrans":false,"CompareIsShowSumRow":true,"IsTimeSheetException":false,"Id":{5},"GivenName":"tester","CreatedDate":"2020-01-13T10:50:17.3700000+07:00","IsActive":true,"IsAdmin":false,"RetailerId":{4},"Type":0,"CreatedBy":438680,"CanAccessAnySite":false,"IsShowSumRow":true,"isDeleted":false,"Permissions":[],"Apps":[],"Invoices":[],"Transfers1":[],"PriceBookUsers":[],"CashFlows":[],"Invoices1":[],"Orders":[],"Returns1":[],"Manufacturings":[],"DamageItems":[],"TokenApis":[],"SmsEmailTemplates":[],"BalanceAdjustments1":[],"PointAdjustments":[],"PointAdjustmentsCreatedBy":[],"NotificationSettings":[],"DamageItems1":[],"PurchaseOrders1":[],"PurchaseReturns1":[],"CostAdjustments":[],"Devices":[],"OrderSuppliers":[],"OrderSuppliers1":[],"UserDevices":[],"PayslipPayments":[],"PayslipPaymentAllocations":[]}}],"selectedCustomerGroup":[],"selectedCustomerGroupObj":[]}}}}       ${get_id_promo}    ${status}    ${month}    ${date}    ${retailer_id}    ${get_id_user}   ${promotion_code}    ${get_id_cat}
    Post request by other URL API    ${PROMO_API}    /campaigns     ${request_payload}

Toggle status of promotion and not for all customer
    [Arguments]    ${promotion_code}    ${status}     ${input_ten_nhom_kh}    ${cat_sale}    ${cat_giveaway}
    [Timeout]    5 minute
    ${retailer_id}    Get RetailerID
    ${category_id_sale}    Get category ID    ${cat_sale}
    ${category_id_giveaway}    Get category ID    ${cat_giveaway}
    ${get_cus_group_id}    Get Customer Group ID by Customer Name    ${input_ten_nhom_kh}
    ${get_id_promo}     Get Id promotion    ${promotion_code}
    ${get_id_sale_promo}    Get Id sale promotion    ${promotion_code}
    ${curdatetime}    Get Current Date    result_format=datetime
    ${month}    Evaluate    $curdatetime.month
    ${date}    Evaluate    $curdatetime.day
    ${request_payload}    Format String     {{"Campaign":{{"Id":{0},"Name":"KM theo HH và HĐ hình thức tặng hàng theo nhóm KH","IsActive":"{1}","ApplyMonths":"{2}","ApplyDates":"{3}","Weekday":null,"Hour":null,"IsGlobal":true,"ForAllUser":true,"ForAllCusGroup":false,"Type":2,"PromotionType":16,"SalePromotions":[{{"Id":{4},"Type":2,"InvoiceValue":5000000,"PrereqCategoryId":{8},"PromotionType":16,"ReceivedCategoryId":{9},"PrereqQuantity":2,"ReceivedQuantity":1,"RetailerId":{5},"CampaignId":{0},"PrereqApplySameKind":false,"ReceivedApplySameKind":false,"ReceivedCategoryIds":"{9}","PrereqCategoryIds":"{8}","DiscountType":"VND","ProductDiscountType":"VND","Uuid":"","PrereqHirenchyCategoryStr":"Dịch vụ","PrereqProductId":null,"PrereqProductIds":null,"PrereqEntity":{{"__type":"KiotViet.Web.Api.ProductAndGroup, KiotViet.Web.Api","Id":{8},"Name":"Nhóm:Dịch vụ","Code":"","Type":4,"LongName":"Dịch vụ","SubCategoryIds":[{8}],"IsRewardPoint":true,"HasVariants":false,"ProductIds":"","HasRelated":true,"MasterProductIds":[null],"ProductCodes":"","ApplySameKind":false,"CategoryIds":"{8}","Uuid":""}},"PrereqProductCodes":null,"MasterProductIds":null,"CategoryIds":null,"ReceivedHirenchyCategoryStr":"Bánh nhập KM","ReceivedProductId":null,"ReceivedProductIds":null,"ReceivedEntity":{{"__type":"KiotViet.Web.Api.ProductAndGroup, KiotViet.Web.Api","Id":{9},"Name":"Nhóm:Bánh nhập KM","Code":"","Type":4,"LongName":"Bánh nhập KM","SubCategoryIds":[{9}],"IsRewardPoint":true,"HasVariants":false,"ProductIds":"","HasRelated":true,"MasterProductIds":[null],"ProductCodes":"","ApplySameKind":false,"CategoryIds":"{9}","Uuid":""}},"ReceivedProductCodes":null}}],"StartDate":null,"EndDate":null,"BirthdayTimeType":1,"_events":{{"change":[null]}},"_handlers":{{"CampaignBranches":{{}},"CampainCustomerGroups":{{}},"SalePromotions":{{}},"CampaignUsers":{{}}}},"Code":"{6}","CreatedDate":"2020-01-31T15:25:15.8170000","CreatedBy":438680,"RetailerId":{5},"CampaignBranches":[],"CampainCustomerGroups":[{{"CustomerGroupId":{7},"CustomerGroupName":"Nhóm khách VIP"}}],"CampaignUsers":[],"InvoiceValue":438680,"HasTransactions":false,"uid":"","view_ApplyMonths":"Tháng 1","view_ApplyDates":"Ngày 31","view_Weekday":"","view_Hour":"","view_BirthdayTimeType":"ngày","InvoiceValueType":1,"selectedBranch":[],"selectedBranchObj":[],"selectedUser":[],"selectedUserObj":[],"selectedCustomerGroup":[{7}],"selectedCustomerGroupObj":[{{"Id":{7},"Name":"Nhóm khách VIP","Description":"","CreatedDate":"2020-01-31T11:01:06.7800000+07:00","CreatedBy":438680,"RetailerId":{5},"Filter":"[{{\\"FieldName\\":\\"TotalRevenue\\",\\"Operator\\":0,\\"Value\\":500000,\\"DataType\\":\\"number\\",\\"$$hashKey\\":\\"object:5622\\"}}]","DiscountRatio":15,"TypeUpdate":5,"CustomerGroupDetails":[],"PriceBookCustomerGroups":[],"RewardPointCustomerGroups":[],"VoucherCustomerGroups":[],"CompareName":"Nhóm khách VIP","IdOld":0}}]}}}}       ${get_id_promo}    ${status}    ${month}    ${date}   ${get_id_sale_promo}    ${retailer_id}   ${promotion_code}    ${get_cus_group_id}    ${category_id_sale}    ${category_id_giveaway}
    Post request by other URL API    ${PROMO_API}    /campaigns     ${request_payload}

Toggle status of promotion and not for all filter
    [Arguments]    ${promotion_code}    ${status}     ${input_ten_branch}     ${input_ten_user}     ${input_ten_kh}    ${cat_sale}    ${cat_giveaway}
    [Timeout]    5 minute
    ${category_id_sale}    Get category ID    ${cat_sale}
    ${category_id_giveaway}    Get category ID    ${cat_giveaway}
    ${retailer_id}    Get RetailerID
    ${get_id_branch}    Get BranchID by BranchName    ${input_ten_branch}
    ${get_id_user}    Get User ID by UserName    ${input_ten_user}
    ${get_cus_group_id}    Get Customer Group ID by Customer Name    ${input_ten_kh}
    ${get_id_promo}     Get Id promotion    ${promotion_code}
    ${get_id_sale_promo}    Get Id sale promotion    ${promotion_code}
    ${curdatetime}    Get Current Date    result_format=datetime
    ${month}    Evaluate    $curdatetime.month
    ${date}    Evaluate    $curdatetime.day
    ${request_payload}    Format String    {{"Campaign":{{"Id":{0},"Name":"KM theo HH và HĐ hình thức GG hàng VND và không áp dụng all filter","IsActive":"{1}","ApplyMonths":"{2}","ApplyDates":"{3}","Weekday":null,"Hour":null,"IsGlobal":false,"ForAllUser":false,"ForAllCusGroup":false,"Type":2,"PromotionType":17,"SalePromotions":[{{"Id":{4},"Type":2,"InvoiceValue":5000000,"PrereqCategoryId":{10},"PromotionType":17,"ReceivedCategoryId":{11},"ProductDiscount":60000,"PrereqQuantity":3,"ReceivedQuantity":1,"RetailerId":{5},"CampaignId":{0},"PrereqApplySameKind":false,"ReceivedApplySameKind":false,"ReceivedCategoryIds":"{11}","PrereqCategoryIds":"{10}","DiscountType":"VND","ProductDiscountType":"VND","Uuid":"","PrereqHirenchyCategoryStr":"KM Hàng mua","PrereqProductId":null,"PrereqProductIds":null,"PrereqEntity":{{"__type":"KiotViet.Web.Api.ProductAndGroup, KiotViet.Web.Api","Id":{10},"Name":"Nhóm:KM Hàng mua","Code":"","Type":4,"LongName":"KM Hàng mua","SubCategoryIds":[{10}],"IsRewardPoint":true,"HasVariants":false,"ProductIds":"","HasRelated":true,"MasterProductIds":[null],"ProductCodes":"","ApplySameKind":false,"CategoryIds":"{10}","Uuid":""}},"PrereqProductCodes":null,"MasterProductIds":null,"CategoryIds":null,"ReceivedHirenchyCategoryStr":"KM Hàng tặng","ReceivedProductId":null,"ReceivedProductIds":null,"ReceivedEntity":{{"__type":"KiotViet.Web.Api.ProductAndGroup, KiotViet.Web.Api","Id":{11},"Name":"Nhóm:KM Hàng tặng","Code":"","Type":4,"LongName":"KM Hàng tặng","SubCategoryIds":[{11}],"IsRewardPoint":true,"HasVariants":false,"ProductIds":"","HasRelated":true,"MasterProductIds":[null],"ProductCodes":"","ApplySameKind":false,"CategoryIds":"{11}","Uuid":""}},"ReceivedProductCodes":null}}],"StartDate":null,"EndDate":null,"BirthdayTimeType":1,"_events":{{"change":[null]}},"_handlers":{{"CampaignBranches":{{}},"CampainCustomerGroups":{{}},"SalePromotions":{{}},"CampaignUsers":{{}}}},"Code":"{9}","CreatedDate":"2020-01-31T16:46:26.6670000","CreatedBy":438680,"RetailerId":{5},"CampaignBranches":[{{"BranchId":{6},"BranchName":"Nhánh A"}}],"CampainCustomerGroups":[{{"CustomerGroupId":{7},"CustomerGroupName":"Nhóm khách VIP"}}],"CampaignUsers":[{{"UserId":{8},"GivenName":"tester"}}],"InvoiceValue":438680,"HasTransactions":false,"uid":"","view_ApplyMonths":"Tháng 1","view_ApplyDates":"Ngày 31","view_Weekday":"","view_Hour":"","view_BirthdayTimeType":"ngày","InvoiceValueType":1,"selectedBranch":[{6}],"selectedBranchObj":[{{"Id":{6},"Name":"Nhánh A","Type":0,"Address":"129 Phố Và","Province":"Bắc Ninh","District":"Thành phố Bắc Ninh","ContactNumber":"0987878877","IsActive":true,"RetailerId":{5},"CreatedBy":438680,"LimitAccess":false,"LocationName":"Bắc Ninh - Thành phố Bắc Ninh","WardName":"Phường Hạp Lĩnh","isAcceptBookClosing":false,"GmbStatus":1,"Orders":[],"Transfers1":[],"DamageItems":[],"SurchargeBranches":[],"AdrApplications":[],"Customers":[],"Suppliers":[],"ExpensesOtherBranches":[],"OrderSuppliers":[],"WarrantyBranchGroups":[],"BranchTakingAddresses":[],"Patients":[],"Clinics":[],"Doctors":[],"DoctorQualifications":[],"DoctorSpecialities":[],"Prescriptions":[],"PayslipPayments":[],"PayslipPaymentAllocations":[],"IdOld":0,"TotalUser":1,"CompareBranchName":"Nhánh A","StatusGmbValue":"Chưa đăng ký","IsTimeSheetException":false}}],"selectedUser":[{8}],"selectedUserObj":[{{"IdOld":0,"CompareGivenName":"tester","CompareIsLimitedByTrans":false,"CompareIsShowSumRow":true,"IsTimeSheetException":false,"Id":{8},"GivenName":"tester","CreatedDate":"2020-01-13T10:50:17.3700000+07:00","IsActive":true,"IsAdmin":false,"RetailerId":{5},"Type":0,"CreatedBy":438680,"CanAccessAnySite":false,"IsShowSumRow":true,"isDeleted":false,"Permissions":[],"Apps":[],"Invoices":[],"Transfers1":[],"PriceBookUsers":[],"CashFlows":[],"Invoices1":[],"Orders":[],"Returns1":[],"Manufacturings":[],"DamageItems":[],"TokenApis":[],"SmsEmailTemplates":[],"BalanceAdjustments1":[],"PointAdjustments":[],"PointAdjustmentsCreatedBy":[],"NotificationSettings":[],"DamageItems1":[],"PurchaseOrders1":[],"PurchaseReturns1":[],"CostAdjustments":[],"Devices":[],"OrderSuppliers":[],"OrderSuppliers1":[],"UserDevices":[],"PayslipPayments":[],"PayslipPaymentAllocations":[]}}],"selectedCustomerGroup":[{7}],"selectedCustomerGroupObj":[{{"Id":{7},"Name":"Nhóm khách VIP","Description":"","CreatedDate":"2020-01-31T11:01:06.7800000+07:00","CreatedBy":438680,"RetailerId":{5},"Filter":"[{{\\"FieldName\\":\\"TotalRevenue\\",\\"Operator\\":0,\\"Value\\":500000,\\"DataType\\":\\"number\\",\\"$$hashKey\\":\\"object:5622\\"}}]","DiscountRatio":15,"TypeUpdate":5,"CustomerGroupDetails":[],"PriceBookCustomerGroups":[],"RewardPointCustomerGroups":[],"VoucherCustomerGroups":[],"CompareName":"Nhóm khách VIP","IdOld":0}}]}}}}       ${get_id_promo}    ${status}    ${month}    ${date}   ${get_id_sale_promo}    ${retailer_id}    ${get_id_branch}    ${get_cus_group_id}    ${get_id_user}   ${promotion_code}    ${category_id_sale}    ${category_id_giveaway}
    Post request by other URL API    ${PROMO_API}    /campaigns     ${request_payload}

Update full time acesss thr API
    [Arguments]     ${taikhoan}
    ${get_user_id}      Get User ID by UserName     ${taikhoan}
    ${get_retaier_id}    Get RetailerID
    ${payload}        Format String    {{"UserId":{0},"IsLimitTime":false,"TimeAccess":[{{"IsChild":false,"NumberOrder":0,"UserId":{0},"DayOfWeek":"Monday","Name":"Thứ hai","IsActive":false,"RetailerId":{1}}},{{"IsChild":false,"NumberOrder":1,"UserId":{0},"DayOfWeek":"Tuesday","Name":"Thứ ba","IsActive":false,"RetailerId":{1}}},{{"IsChild":false,"NumberOrder":2,"UserId":{0},"DayOfWeek":"Wednesday","Name":"Thứ tư","IsActive":false,"RetailerId":{1}}},{{"IsChild":false,"NumberOrder":3,"UserId":{0},"DayOfWeek":"Thursday","Name":"Thứ năm","IsActive":false,"RetailerId":{1}}},{{"IsChild":false,"NumberOrder":4,"UserId":{0},"DayOfWeek":"Friday","Name":"Thứ sáu","IsActive":false,"RetailerId":{1}}},{{"IsChild":false,"NumberOrder":{1},"UserId":{0},"DayOfWeek":"Saturday","Name":"Thứ bảy","IsActive":false,"RetailerId":{1}}},{{"IsChild":false,"NumberOrder":6,"UserId":{0},"DayOfWeek":"Sunday","Name":"Chủ nhật","IsActive":false,"RetailerId":{1}}}]}}     ${get_user_id}     ${get_retaier_id}
    Post request thr API    /users/timeaccess    ${payload}

Update only accessible by time frame thr API
    [Arguments]      ${taikhoan}     ${input_day}      ${time_start}     ${time_end}
    ${get_user_id}      Get User ID by UserName     ${taikhoan}
    ${list_str_monday}      Run Keyword If    '${input_day}'=='Monday'     Format String    {{"NumberOrder":0,"DayOfWeek":"Monday","Name":"Thứ hai","From":"{0}","To":"{1}","IsActive":{2}}}    ${time_start}      ${time_end}       true      ELSE       Format String    {{"NumberOrder":0,"DayOfWeek":"Monday","Name":"Thứ hai","From":"{0}","To":"{1}","IsActive":{2}}}    ${time_start}      ${time_end}       false
    ${list_str_tuesday}     Run Keyword If    '${input_day}'=='Tuesday'    Format String    {{"NumberOrder":1,"DayOfWeek":"Tuesday","Name":"Thứ ba","From":"{0}","To":"{1}","IsActive":{2}}}    ${time_start}      ${time_end}       true     ELSE       Format String    {{"NumberOrder":1,"DayOfWeek":"Tuesday","Name":"Thứ ba","From":"{0}","To":"{1}","IsActive":{2}}}    ${time_start}      ${time_end}       false
    ${list_str_wednesday}     Run Keyword If    '${input_day}'=='Wednesday'     Format String   {{"NumberOrder":2,"DayOfWeek":"Wednesday","Name":"Thứ tư","From":"{0}","To":"{1}","IsActive":{2}}}      ${time_start}      ${time_end}       true     ELSE       Format String      {{"NumberOrder":2,"DayOfWeek":"Wednesday","Name":"Thứ tư","From":"{0}","To":"{1}","IsActive":{2}}}      ${time_start}      ${time_end}       false
    ${list_str_thursday}      Run Keyword If    '${input_day}'=='Thursday'     Format String   {{"NumberOrder":3,"DayOfWeek":"Thursday","Name":"Thứ năm","From":"{0}","To":"{1}","IsActive":{2}}}      ${time_start}      ${time_end}       true     ELSE       Format String      {{"NumberOrder":3,"DayOfWeek":"Thursday","Name":"Thứ năm","From":"{0}","To":"{1}","IsActive":{2}}}     ${time_start}      ${time_end}       false
    ${list_str_friday}      Run Keyword If    '${input_day}'=='Friday'     Format String      {{"NumberOrder":4,"DayOfWeek":"Friday","Name":"Thứ sáu","From":"{0}","To":"{1}","IsActive":{2}}}      ${time_start}      ${time_end}       true     ELSE       Format String      {{"NumberOrder":4,"DayOfWeek":"Friday","Name":"Thứ sáu","From":"{0}","To":"{1}","IsActive":{2}}}    ${time_start}      ${time_end}       false
    ${list_str_saturday}      Run Keyword If    '${input_day}'=='Saturday'     Format String   {{"NumberOrder":5,"DayOfWeek":"Saturday","Name":"Thứ bảy","From":"{0}","To":"{1}","IsActive":{2}}}      ${time_start}      ${time_end}       true     ELSE       Format String      {{"NumberOrder":5,"DayOfWeek":"Saturday","Name":"Thứ bảy","From":"{0}","To":"{1}","IsActive":{2}}}     ${time_start}      ${time_end}       false
    ${list_str_sunday}      Run Keyword If    '${input_day}'=='Sunday'     Format String     {{"NumberOrder":6,"DayOfWeek":"Sunday","Name":"Chủ nhật","From":"{0}","To":"{1}","IsActive":{2}}}      ${time_start}      ${time_end}       true     ELSE       Format String      {{"NumberOrder":6,"DayOfWeek":"Sunday","Name":"Chủ nhật","From":"{0}","To":"{1}","IsActive":{2}}}    ${time_start}      ${time_end}       false
    ${list_str_day}     Set Variable    ${list_str_monday},${list_str_tuesday},${list_str_wednesday},${list_str_thursday},${list_str_friday},${list_str_saturday},${list_str_sunday}
    ${payload1}        Format String    {{"UserId":{0},"IsLimitTime":true,"TimeAccess":[{1}]}}    ${get_user_id}    ${list_str_day}
    Log    ${payload1}
    Post request thr API     /users/timeaccess    ${payload1}

Delete Zalo connection
    [Timeout]       1 min
    Delete request thr API    ${endpoint_zalo_linking}

Get Zalo connection status
    [Timeout]    2 minute
    ${zalo_status}    Get data from API    ${endpoint_zalo_linking}    $.IsConnectedZalo
    Return From Keyword    ${zalo_status}

Get timesheet branch setting ưorking days
    [Arguments]    ${branch_name}
    [Timeout]    5 mins
    ${response_branch_info}    Get Request and return body    ${endpoint_branch_list}
    ${jsonpath_ưorking_days}    Format String    $..Data[?(@.Name=="{0}")].TimeSheetBranchSettingWorkingDays   ${branch_name}
    ${list_working_days}    Get raw data from response json    ${response_branch_info}    ${jsonpath_ưorking_days}
    ${list_working_days}      Replace sq blackets    ${list_working_days}
    ${list_working_days}      Convert String to List      ${list_working_days}
    ${list_result_working_days}     Create List
    :FOR    ${item_working_days}      IN ZIP      ${list_working_days}
    \     ${item_working_days}      Run Keyword If    '${item_working_days}'=='0'   Set Variable    CN      ELSE IF    '${item_working_days}'=='1'   Set Variable    T2      ELSE IF    '${item_working_days}'=='2'   Set Variable    T3    ELSE IF    '${item_working_days}'=='3'   Set Variable    T4    ELSE IF    '${item_working_days}'=='4'   Set Variable    T5      ELSE IF    '${item_working_days}'=='5'   Set Variable    T6      ELSE      Set Variable    T7
    \     Append To List    ${list_result_working_days}    ${item_working_days}
    Return From Keyword         ${list_result_working_days}

Update working day for branch
    [Arguments]    ${input_branch}    ${input_branch_id}    ${ngay_nghi}
    [Timeout]    5 minute
    @{list_day}     Create List    0    1     2     3     4     5     6
    ${item_ngay_nghi}      Run Keyword If    '${ngay_nghi}'=='Sunday'   Set Variable    0      ELSE IF    '${ngay_nghi}'=='Monday'   Set Variable    1      ELSE IF    '${ngay_nghi}'=='Tuesday'   Set Variable    2    ELSE IF    '${ngay_nghi}'=='Wednesday'   Set Variable    3    ELSE IF    '${ngay_nghi}'=='Thursday'   Set Variable    4      ELSE IF    '${ngay_nghi}'=='Friday'   Set Variable    5      ELSE      Set Variable    6
    Run Keyword If      '${ngay_nghi}'!='none'    Remove From List    ${list_day}    ${item_ngay_nghi}    ELSE      Log     Ignore
    ${working_days}    Set Variable    needdel
    : FOR     ${item_day}    IN ZIP   ${list_day}
    \    ${working_days}    Catenate    SEPARATOR=,    ${working_days}    ${item_day}
    ${working_days}    Replace String    ${working_days}    needdel,    ${EMPTY}    count=1
    ${get_retailer_id}    Get RetailerID
    ${data_str}    Format String    {{"Branch":{{"Id":{0},"Name":"{1}","Type":0,"Address":"Hà Nội","Province":"Hà Nội","District":"Quận Ba Đình","ContactNumber":"0987545635","IsActive":true,"RetailerId":{2},"CreatedBy":20447,"LimitAccess":false,"LocationName":"Hà Nội - Quận Ba Đình","WardName":"Phường Điện Biên","isAcceptBookClosing":false,"GmbStatus":1,"Orders":[],"Transfers1":[],"Retailer":{{"CrudGuid":"","Id":437336,"CompanyName":"autobot2","CompanyAddress":"abc","Website":"Test Auto","Phone":"34534534","Code":"autobot2","IsActive":true,"IsAdminActive":true,"GroupId":1,"CreatedDate":"","ModifiedDate":"","ExpiryDate":"","UseCustomLogo":false,"Referrer":"","Zone":"Hà Nội","CreatedBy":0,"ModifiedBy":65774,"MakeSampleData":false,"LatestClearData":"2019-04-23T17:22:27.7930000+07:00","IndustryId":4,"SignUpType":"Web Site","MaximumProducts":0,"MaximumBranchs":20,"ContractType":2,"LimitKiotMailInMonth":0,"ContractDate":"","LocationName":"Hà Nội - Quận Cầu Giấy","Province":"Hà Nội","District":"Quận Cầu Giấy","WardName":"Phường Nghĩa Tân","MaximumFanpages":20,"Branches":[],"Customers":[],"ObjectAccesses":[],"PriceBooks":[],"PropertyAccesses":[],"PurchaseOrders":[],"PurchasePayments":[],"PurchaseReturns":[],"Returns":[],"StockTakes":[],"Suppliers":[],"BankAccounts":[],"EmailMarketings":[],"EmailTemplates":[],"Surcharges":[],"AdrApplications":[],"RewardPointCustomerGroups":[],"SmsEmailTemplates":[],"ProductSerials":[],"NotificationSettings":[],"PartnerDeliveries":[],"ExpensesOthers":[],"SaleChannels":[],"ImportExportFiles":[],"Devices":[],"BatchExpires":[],"WarrantyBranchGroups":[],"OrderSuppliers":[],"PriceBookDependencies":[],"MedicineManufacturers":[],"AddressBooks":[],"BranchTakingAddresses":[],"Patients":[],"DoctorOffices":[],"ShippingTasks":[],"Clinics":[],"Doctors":[],"DoctorQualifications":[],"DoctorSpecialities":[],"Prescriptions":[],"RetailerRouteOfAdministrations":[],"UserDevices":[],"ShippingTaskDetails":[],"ShippingTaskOrderDetails":[],"PayslipPayments":[],"PayslipPaymentAllocations":[],"DeliveryCrossChecks":[]}},"DamageItems":[],"SurchargeBranches":[],"AdrApplications":[],"Customers":[],"Suppliers":[],"ExpensesOtherBranches":[],"OrderSuppliers":[],"WarrantyBranchGroups":[],"BranchTakingAddresses":[],"Patients":[],"Clinics":[],"Doctors":[],"DoctorQualifications":[],"DoctorSpecialities":[],"Prescriptions":[],"PayslipPayments":[],"PayslipPaymentAllocations":[],"IdOld":0,"TotalUser":"3","CompareBranchName":"Nhánh A","StatusGmbValue":"Chưa đăng ký","TimeSheetBranchSettingWorkingDays":[{3}],"IsTimeSheetException":false,"LocationId":239,"WardId":9,"Status":"Đang hoạt động","GmbEmailInfo":"","PharmacySyncStatus":false,"timeSheetBranchSetting":{{"workingDays":[{3}]}},"temploc":"Hà Nội - Quận Ba Đình","tempw":"Phường Điện Biên"}},"BranchSetting":{{"workingDays":[{3}]}},"IsAddMore":false,"IsRemove":false,"ApplyFrom":null}}
    ...   ${input_branch_id}    ${input_branch}        ${get_retailer_id}   ${working_days}
    log    ${data_str}
    Post request thr API    /branchs    ${data_str}

Get sms email template id frm api
    [Arguments]    ${input_tieude}
    [Timeout]    2 minute
    ${resp}    Get Request and return body    ${endpoint_list_sms_email}
    ${jsonpath_id_sms}    Format String    $..Data[?(@.Title=="{0}")].Id    ${input_tieude}
    ${get_sms_id}    Get data from response json    ${resp}    ${jsonpath_id_sms}
    Return From Keyword    ${get_sms_id}

Delete sms email template
    [Arguments]    ${input_tieude}
    [Timeout]    2 minute
    ${get_sms_id}     Get sms email template id frm api    ${input_tieude}
    ${endpoint_del_sms}    Format String    ${endpoint_del_sms}    ${get_sms_id}
    Delete request thr API    ${endpoint_del_sms}

Add sms email template thr API
    [Arguments]    ${input_tieude}    ${input_noidung}
    [Timeout]    2 minute
    ${data_str}    Format String    {{"Template":{{"Type":1,"Title":"{0}","Content":"{1}"}}}}    ${input_tieude}    ${input_noidung}
    log    ${data_str}
    Post request thr API    ${endpoint_sms_email}    ${data_str}

#get id cua 1 campaign voucher
Get voucher campaign id
    [Arguments]    ${voucher_code}
    [Timeout]    3 minute
    ${jsonpath_voucher_id}    Format String    $..Data[?(@.Code=="{0}")].Id    ${voucher_code}
    ${voucher_id}=    Get data from API by other url    ${API_URL}    ${endpoint_voucher_issue_list}    ${jsonpath_voucher_id}
    Return From Keyword    ${voucher_id}

Delete voucher campaign
    [Arguments]    ${voucher_name}
    ${get_id_voucher}    Get voucher campaign id    ${voucher_name}
    ${endpoint_voucher}    Format String    ${endpoint_delete_voucher}    ${get_id_voucher}
    Delete request thr API    ${endpoint_voucher}

Get voucher campaign info and validate
    [Arguments]    ${voucher_code}    ${voucher_name}    ${tongtienhang}    ${menhgia}
    [Timeout]    5 mins
    ${get_id_voucher}    Get voucher campaign id    ${voucher_code}
    ${endpoint_voucher_detail}    Format String    ${endpoint_voucher}    ${get_id_voucher}
    ${response_voucher_info}    Get response from API by other url    ${API_URL}    ${endpoint_voucher_detail}
    ${get_voucher_name}    Get data from response json    ${response_voucher_info}    $.Name
    ${get_voucher_menhgia}    Get data from response json    ${response_voucher_info}    $.Price
    ${get_voucher_value}    Get data from response json    ${response_voucher_info}    $.PrereqPrice
    Should Be Equal As Strings    ${get_voucher_name}    ${voucher_name}
    Should Be Equal As Numbers    ${get_voucher_menhgia}    ${menhgia}
    Should Be Equal As Numbers    ${get_voucher_value}    ${tongtienhang}
    Return From Keyword    ${get_id_voucher}

#get id cua 1 voucher
Get voucher id
    [Arguments]    ${campaignID}    ${voucher_code}
    ${voucher_name}    Replace sq blackets    ${voucher_code}
    [Timeout]    3 minute
    ${endpoint_voucher_code}    Format String    ${endpoint_vouchercode}    ${campaignID}
    ${jsonpath_voucher_id}    Format String    $..Data[?(@.Code=="{0}")].Id    ${voucher_name}
    ${voucher_id}=    Get data from API by other url    ${API_URL}    ${endpoint_voucher_code}    ${jsonpath_voucher_id}
    Return From Keyword    ${voucher_id}

Return voucher code by API
    [Arguments]    ${vouchercampaign_code}    ${voucher_code}
    ${return_date}=    Get Current Date
    log    ${return_date}
    ${voucher_name}    Replace sq blackets    ${voucher_code}
    ${get_voucher_campaign_id}    Get voucher campaign id    ${vouchercampaign_code}
    ${get_voucherId}    Get voucher id    ${get_voucher_campaign_id}    ${voucher_code}
    ${data_str}    Format String    {{"CampaignId":{0},"Vouchers":[{{"Id":{1},"Code":"{2}","Status":1,"Price":0}}],"ReturnDate":"{3}","Price":0,"Cashflow":{{"PartnerType":"O","Value":0,"PaymentMethod":"Cash","AccountId":null}},"KeepTime":true,"ComparePartnerName":null}}    ${get_voucher_campaign_id}    ${get_voucherId}    ${voucher_name}    ${return_date}
    log    ${data_str}
    Post request thr API    /voucher/return?kvuniqueparam=2020     ${data_str}

Get audit trail info thr API
    [Arguments]    ${ma_giaodich}    ${function_name}
    ${date_current}    Get Current Date    result_format=%Y-%m-%d
    ${get_id_nguoiban}    Get User ID
    ${endpoint_audittrail_detail}    Format String    ${endpoint_audittrail_detail}    ${BranchID}    ${ma_giaodich}    ${date_current}
    ${response_audittrail_info}    Get Request and return body    ${endpoint_audittrail_detail}
    ${jsonpath_thoigian}    Format String    $.Data[?(@.FunctionName =='{0}')].CreatedDate    ${function_name}
    ${jsonpath_thaotac}    Format String    $.Data[?(@.FunctionName =='{0}')].ActionName    ${function_name}
    ${jsonpath_noidung}    Format String    $.Data[?(@.FunctionName =='{0}')].SubContent    ${function_name}
    ${jsonpath_id_lstt}     Format String    $.Data[?(@.FunctionName =='{0}')].Id    ${function_name}
    ${get_lstt_thoigian}    Get raw data from response json    ${response_audittrail_info}    ${jsonpath_thoigian}
    ${get_lstt_thaotac}    Get raw data from response json    ${response_audittrail_info}    ${jsonpath_thaotac}
    ${get_lstt_noidung}    Get raw data from response json    ${response_audittrail_info}    ${jsonpath_noidung}
    ${get_id_lstt}    Get raw data from response json    ${response_audittrail_info}    ${jsonpath_id_lstt}
    Return From Keyword    ${get_lstt_thoigian}   ${get_lstt_thaotac}       ${get_lstt_noidung}     ${get_id_lstt}

Get two audit trail succeed
    [Arguments]     ${input_thoigian}   ${ma_giaodich}    ${function_name}
    ${get_lstt_thoigian}   ${get_lstt_thaotac}     ${get_lstt_noidung}   ${get_id_lstt}    Get audit trail info thr API      ${ma_giaodich}    ${function_name}
    ${time_cut}    Replace String    ${get_lstt_thoigian[0]}    0000+07:00    ${EMPTY}
    ${time_cut_1}    Replace String    ${get_lstt_thoigian[1]}    0000+07:00    ${EMPTY}
    ${lstt_thoigian}    Convert Date    ${time_cut}    exclude_millis=yes    result_format=%Y-%m-%d %H:%M:%S
    ${lstt_thoigian_1}    Convert Date    ${time_cut_1}    exclude_millis=yes    result_format=%Y-%m-%d %H:%M:%S
    ${get_status_success}      Run Keyword If    '${lstt_thoigian}'>='${input_thoigian}' and '${lstt_thoigian_1}'>='${input_thoigian}'    Set Variable    PASS
    Run Keyword If    '${get_status_success}'!='PASS'     Fail    Audit Trai chưa đủ 2 log đồng bộ tồn kho và giá trả về hàng hóa ${ma_giaodich}
    Return From Keyword     ${get_lstt_thoigian}   ${get_lstt_thaotac}  ${get_lstt_noidung}     ${get_id_lstt}

Get audit trail info by action name thr API
    [Arguments]    ${ma_giaodich}    ${function_name}
    Log     ${ma_giaodich}
    ${date_current}    Get Current Date    result_format=%Y-%m-%d
    ${get_id_nguoiban}    Get User ID
    ${endpoint_audittrail_detail}    Format String    ${endpoint_audittrail_detail}    ${BranchID}    ${ma_giaodich}    ${date_current}
    ${response_audittrail_info}    Get Request and return body    ${endpoint_audittrail_detail}
    ${jsonpath_thoigian}    Format String    $.Data[?(@.ActionName =='{0}')].CreatedDate    ${function_name}
    ${jsonpath_chucnang}    Format String    $.Data[?(@.ActionName =='{0}')].FunctionName    ${function_name}
    ${jsonpath_noidung}    Format String    $.Data[?(@.ActionName =='{0}')].SubContent    ${function_name}
    ${jsonpath_id_lstt}     Format String    $.Data[?(@.ActionName =='{0}')].Id    ${function_name}
    ${get_lstt_thoigian}    Get data from response json    ${response_audittrail_info}    ${jsonpath_thoigian}
    ${get_lstt_chucnang}    Get data from response json    ${response_audittrail_info}    ${jsonpath_chucnang}
    ${get_lstt_noidung}    Get data from response json    ${response_audittrail_info}    ${jsonpath_noidung}
    ${get_id_lstt}    Get data from response json    ${response_audittrail_info}    ${jsonpath_id_lstt}
    Should Not Be Equal As Strings       ${get_lstt_noidung}    0
    Return From Keyword    ${get_lstt_thoigian}     ${get_lstt_chucnang}       ${get_lstt_noidung}    ${get_id_lstt}

Get audit trail by time
    [Arguments]     ${input_thoigian}   ${ma_giaodich}    ${function_name}
    ${get_lstt_thoigian}   ${get_lstt_thaotac}     ${get_lstt_noidung}   ${get_id_lstt}    Get audit trail info thr API      ${ma_giaodich}    ${function_name}
    ${time_cut}    Replace String    ${get_lstt_thoigian[0]}    0000+07:00    ${EMPTY}
    ${lstt_thoigian}    Convert Date    ${time_cut}    exclude_millis=yes    result_format=%Y-%m-%d %H:%M:%S
    ${get_status_success}      Run Keyword If    '${lstt_thoigian}'>='${input_thoigian}'    Set Variable    PASS
    Run Keyword If    '${get_status_success}'!='PASS'     Fail    Audit Trai chưa có log đồng bộ trả về hàng hóa ${ma_giaodich}
    Return From Keyword     ${get_lstt_thoigian}   ${get_lstt_thaotac}  ${get_lstt_noidung}     ${get_id_lstt}

Get list supplier charge values thr API
    [Arguments]      ${list_cpnh}
    ${list_supplier_charge_value}    Create List
    ${list_supplier_charge_auto}    Create List
    : FOR    ${item_cpnh}    IN ZIP    ${list_cpnh}
    \    ${supplier_charge_vnd}    Get expense VND value    ${item_cpnh}
    \    ${supplier_charge_%}    Get expense percentage value    ${item_cpnh}
    \    ${supplier_charge_value}    Set Variable If    ${supplier_charge_%}==0    ${supplier_charge_vnd}    ${supplier_charge_%}
    \    ${is_auto}     Run Keyword If    ${supplier_charge_value}>100    Toggle supplier's charge VND    ${item_cpnh}    true
    \    ...    ELSE    Toggle supplier's charge %    ${item_cpnh}    true
    \    Append To List    ${list_supplier_charge_value}    ${supplier_charge_value}
    \    Append To List    ${list_supplier_charge_auto}    ${is_auto}
    Return From Keyword    ${list_supplier_charge_value}      ${list_supplier_charge_auto}

Get list other charge values thr API
    [Arguments]      ${list_cpnhk}
    ${list_other_charge_value}      Create List
    ${list_other_charge_auto}      Create List
    : FOR    ${item_cpnhk}    IN ZIP    ${list_cpnhk}
    \    ${other_charge_vnd}    Get expense VND value    ${item_cpnhk}
    \    ${other_charge_%}    Get expense percentage value    ${item_cpnhk}
    \    ${other_charge_value}    Set Variable If    ${other_charge_%}==0    ${other_charge_vnd}    ${other_charge_%}
    \    ${is_auto}   Run Keyword If    ${other_charge_value}>100    Toggle other charge VND    ${item_cpnhk}    true
    \    ...    ELSE    Toggle other charge %    ${item_cpnhk}    true
    \    Append To List    ${list_other_charge_value}    ${other_charge_value}
    \    Append To List    ${list_other_charge_auto}    ${is_auto}
    Return From Keyword    ${list_other_charge_value}       ${list_other_charge_auto}

Get list supplier charge and other charge values thr API
    [Arguments]     ${list_cpnh}      ${list_cpnhk}
    ${list_supplier_charge_value}      ${list_supplier_charge_auto}     Get list supplier charge values thr API    ${list_cpnh}
    ${list_other_charge_value}       ${list_other_charge_auto}      Get list other charge values thr API      ${list_cpnhk}
    Return From Keyword    ${list_supplier_charge_value}      ${list_supplier_charge_auto}      ${list_other_charge_value}       ${list_other_charge_auto}

Computation total expense charge
    [Arguments]     ${list_supplier_charge_default}      ${list_other_charge_default}   ${list_supplier_charge_value}     ${list_other_charge_value}      ${tongtien_tru_gg}
    ${total_supplier_charge}    Set Variable    0
    : FOR    ${item_supplier_charge_default}   ${item_supplier_charge_value}     IN ZIP    ${list_supplier_charge_default}      ${list_supplier_charge_value}
    \    ${item_supplier_charge}=    Run Keyword If    ${item_supplier_charge_default}> 100 and '${item_supplier_charge_value}'=='none'   Set Variable    ${item_supplier_charge_default}
    \    ...    ELSE IF    0<${item_supplier_charge_default}<=100 and '${item_supplier_charge_value}'=='none'    Convert % discount to VND and round    ${item_supplier_charge_default}    ${tongtien_tru_gg}     ELSE IF    ${item_supplier_charge_value}> 100     Set Variable    ${item_supplier_charge_value}     ELSE    Convert % discount to VND and round    ${item_supplier_charge_value}    ${tongtien_tru_gg}
    \    ${total_supplier_charge}    Sum    ${total_supplier_charge}    ${item_supplier_charge}
    \    Log    ${total_supplier_charge}
    ${total_other_charge}    Set Variable    0
    : FOR    ${item_other_charge_default}   ${item_other_charge_value}     IN ZIP    ${list_other_charge_default}     ${list_other_charge_value}
    \    ${item_other_charge}=    Run Keyword If    ${item_other_charge_default}>100 and '${item_other_charge_value}'=='none'    Set Variable    ${item_other_charge_default}
    \    ...    ELSE IF     0<${item_other_charge_default}<=100 and '${item_supplier_charge_value}'=='none'    Convert % discount to VND and round    ${item_other_charge_default}    ${tongtien_tru_gg}    ELSE IF   ${item_other_charge_value}>100      Set Variable   ${item_other_charge_value}     ELSE    Convert % discount to VND and round    ${item_other_charge_value}    ${tongtien_tru_gg}
    \    ${total_other_charge}    Sum    ${total_other_charge}    ${item_other_charge}
    \    Log    ${total_other_charge}
    ${total_expense_value}    Sum    ${total_supplier_charge}    ${total_other_charge}
    Return From Keyword    ${total_expense_value}   ${total_supplier_charge}    ${total_other_charge}

Computation total supplier charge
    [Arguments]     ${list_supplier_charge_default}     ${list_supplier_charge_value}      ${tongtien_tru_gg}
    ${total_supplier_charge}    Set Variable    0
    : FOR    ${item_supplier_charge_default}   ${item_supplier_charge_value}     IN ZIP    ${list_supplier_charge_default}      ${list_supplier_charge_value}
    \    ${item_supplier_charge}=    Run Keyword If    ${item_supplier_charge_default}> 100 and '${item_supplier_charge_value}'=='none'   Set Variable    ${item_supplier_charge_default}
    \    ...    ELSE IF    0<${item_supplier_charge_default}<=100 and '${item_supplier_charge_value}'=='none'    Convert % discount to VND and round    ${item_supplier_charge_default}    ${tongtien_tru_gg}     ELSE IF    ${item_supplier_charge_value}> 100     Set Variable    ${item_supplier_charge_value}     ELSE    Convert % discount to VND and round    ${item_supplier_charge_value}    ${tongtien_tru_gg}
    \    ${total_supplier_charge}    Sum    ${total_supplier_charge}    ${item_supplier_charge}
    \    Log    ${total_supplier_charge}
    Return From Keyword    ${total_supplier_charge}

Create list audit trail for sync product
    [Arguments]       ${ma_hh}    ${gia_ban}    ${ton}
    ${gia_ban}    Run Keyword If    '${gia_ban}'!='none'   Add thousands separator in a number string   ${gia_ban}    ELSE    Set Variable    none
    ${ton}    Run Keyword If    '${ton}'!='none'      Set Variable If    ${ton}<0    0      ${ton}    ELSE    Set Variable    none
    ${ton}    Run Keyword If    '${ton}'!='none'      Convert from number to interger    ${ton}        ELSE    Set Variable    none
    ${log_dongbo_gia}   Set Variable      thành công: Giá bán: ${gia_ban}
    ${log_dongbo_ton}   Set Variable      thành công: SL sẵn bán: ${ton}
    ${list_audit}   Run Keyword If    '${gia_ban}'!='none' and '${ton}'=='none'    Create List    ${log_dongbo_gia}     ELSE IF    '${gia_ban}'=='none' and '${ton}'!='none'      Create List    ${log_dongbo_ton}     ELSE      Create List    ${log_dongbo_gia}      ${log_dongbo_ton}
    Log    ${list_audit}
    Return From Keyword    ${list_audit}

Assert audit trail by time succeed
    [Arguments]     ${input_thoigian}   ${ma_giaodich}    ${function_name}    ${input_list_noidung}
    Log       ${input_list_noidung}
    ${index}     Get Length    ${input_list_noidung}
    ${get_lstt_thoigian}   ${get_lstt_thaotac}    ${get_lstt_noidung}    ${get_id_lstt}     Run Keyword If    '${index}'=='2'  Wait Until Keyword Succeeds    20 times    5s    Get two audit trail succeed     ${input_thoigian}    ${ma_giaodich}   ${function_name}     ELSE      Wait Until Keyword Succeeds    20 times    5s      Get audit trail by time    ${input_thoigian}    ${ma_giaodich}   ${function_name}
    ${list_lstt_noidung}  Create List
    :FOR    ${item}     IN RANGE    ${index}
    \     ${get_lstt_noidung}     Get data from API      /logs/${get_id_lstt[${item}]}?kvuniqueparam=2020     $.Content
    \     Append To List      ${list_lstt_noidung}      ${get_lstt_noidung}
    Log    ${list_lstt_noidung}
    ${list_lstt_noidung}      Convert List to String    ${list_lstt_noidung}
    Log    ${input_list_noidung}
    :FOR    ${item}     IN RANGE    ${index}
    \     Log    ${input_list_noidung[${item}]}
    \     Should Contain    ${list_lstt_noidung}    ${input_list_noidung[${item}]}

Assert audit trail by action name
    [Arguments]     ${ma_giaodich}    ${action_name}    ${input_noidung}
    ${get_lstt_thoigian}   ${get_lstt_thaotac}    ${get_lstt_noidung}   ${get_id_lstt}   Wait Until Keyword Succeeds    5x    3x    Get audit trail info by action name thr API     ${ma_giaodich}   ${action_name}
    ${get_lstt_noidung}     Get data from API      /logs/${get_id_lstt}?kvuniqueparam=2020     $.Content
    Should Contain    ${get_lstt_noidung}    ${input_noidung}

Assert get branch id succeed
    [Arguments]     ${branch_name}
    ${get_branch_id}      Get BranchID by BranchName    ${branch_name}
    Should Not Be Equal As Numbers    ${get_branch_id}    0
    Return From Keyword    ${get_branch_id}

Setting reward point by invoice thr API
    [Arguments]    ${input_tyle_quydoi}   ${list_option}    ${input_customer}
    [Documentation]    thiết lập tích điểm
    [Timeout]    5 minute
    ${list_full_option}     Create List    Không tích điểm cho sản phẩm giảm giá   Không tích điểm cho hóa đơn giảm giá    Không tích điểm cho hóa đơn thanh toán bằng điểm thưởng   Không tích điểm cho hóa đơn thanh toán bằng voucher
    ${list_status}    Create List
    :FOR    ${item_option}   IN ZIP    ${list_full_option}
    \   ${status}   Run Keyword And Return Status     List Should Contain Value     ${list_option}    ${item_option}
    \   ${status}   Set Variable IF    '${status}'=='True'      true     false
    \   Append To List    ${list_status}   ${status}
    Log     ${list_status}
    ${actual_status_customer}     Set Variable If     '${input_customer}'=='all'    true    false
    ${actual_cus_group_id}     Run Keyword If      '${input_customer}'=='all'    Set Variable    ${EMPTY}    ELSE    Get customer group id thr API    ${input_customer}
    ${data_str}    Set Variable         {"RewardPoint_Type":0,"RewardPoint_MoneyPerPoint":${input_tyle_quydoi},"RewardPoint_IsPointToMoney":true,"RewardPoint_InvoiceCount":0,"RewardPoint_PointToMoney":10,"RewardPoint_MoneyToPoint":1000,"RewardPoint_ForDiscountProduct":${list_status[0]},"RewardPoint_ForDiscountInvoice":${list_status[1]},"RewardPoint_ForInvoiceUsingRewardPoint":${list_status[2]},"RewardPoint_ForInvoiceUsingVoucher":${list_status[3]},"RewardPoint_ForAllCustomer":${actual_status_customer} ,"RewardPoint_CustomerGroup":[${actual_cus_group_id}],"RewardPoint_Product_IsMoneyPerPoint":true,"RewardPoint_Product_MoneyPerPoint":10000,"RewardPoint_Product_IsPointToMoney":true,"RewardPoint_Product_InvoiceCount":0,"RewardPoint_Product_PointToMoney":10,"RewardPoint_Product_MoneyToPoint":1000,"RewardPoint_Product_ForDiscountProduct":false,"RewardPoint_Product_ForDiscountInvoice":false,"RewardPoint_Product_ForInvoiceUsingRewardPoint":false,"RewardPoint_Product_ForInvoiceUsingVoucher":false,"RewardPoint_Product_ForAllCustomer":true,"RewardPoint_Product_CustomerGroup":[],"HasProductPoint":true,"HasRewardPoint":true,"RewardPoint_ForAllProduct":false}
    log    ${data_str}
    Post request thr API    ${endpoint_setting_point}    ${data_str}

Setting reward point by product thr API
    [Arguments]    ${input_tyle_quydoi}   ${list_option}    ${input_customer}
    [Documentation]    thiết lập tích điểm
    [Timeout]    5 minute
    ${list_full_option}     Create List    Không tích điểm cho sản phẩm giảm giá   Không tích điểm cho hóa đơn giảm giá    Không tích điểm cho hóa đơn thanh toán bằng điểm thưởng   Không tích điểm cho hóa đơn thanh toán bằng voucher
    ${list_status}    Create List
    :FOR    ${item_option}   IN ZIP    ${list_full_option}
    \   ${status}   Run Keyword And Return Status     List Should Contain Value     ${list_option}    ${item_option}
    \   ${status}   Set Variable IF    '${status}'=='True'      true     false
    \   Append To List    ${list_status}   ${status}
    Log     ${list_status}
    ${actual_status_customer}     Set Variable If     '${input_customer}'=='all'    true    false
    ${actual_cus_group_id}     Run Keyword If      '${input_customer}'=='all'    Set Variable    ${EMPTY}    ELSE    Get customer group id thr API    ${input_customer}
    ${data_str}    Set Variable    {"RewardPoint_Type":1,"RewardPoint_MoneyPerPoint":${input_tyle_quydoi},"RewardPoint_IsPointToMoney":false,"RewardPoint_InvoiceCount":0,"RewardPoint_PointToMoney":0,"RewardPoint_MoneyToPoint":0,"RewardPoint_ForDiscountProduct":${list_status[0]},"RewardPoint_ForDiscountInvoice":${list_status[1]},"RewardPoint_ForInvoiceUsingRewardPoint":${list_status[2]},"RewardPoint_ForInvoiceUsingVoucher":${list_status[3]},"RewardPoint_ForAllCustomer":${actual_status_customer},"RewardPoint_CustomerGroup":[${actual_cus_group_id}],"RewardPoint_Product_IsMoneyPerPoint":true,"RewardPoint_Product_MoneyPerPoint":${input_tyle_quydoi},"RewardPoint_Product_IsPointToMoney":true,"RewardPoint_Product_InvoiceCount":0,"RewardPoint_Product_PointToMoney":10,"RewardPoint_Product_MoneyToPoint":1000,"RewardPoint_Product_ForDiscountProduct":${list_status[0]},"RewardPoint_Product_ForDiscountInvoice":${list_status[1]},"RewardPoint_Product_ForInvoiceUsingRewardPoint":${list_status[2]},"RewardPoint_Product_ForInvoiceUsingVoucher":${list_status[3]},"RewardPoint_Product_ForAllCustomer":${actual_status_customer},"RewardPoint_Product_CustomerGroup":[${actual_cus_group_id}],"HasProductPoint":true,"HasRewardPoint":true,"RewardPoint_ForAllProduct":false}
    log    ${data_str}
    Post request thr API    ${endpoint_setting_point}    ${data_str}

Get point to money and money to point thr API
    ${get_resp}    Get Request and return body    ${endpoint_setting_point}
    ${get_money_to_point}    Get data from response json    ${get_resp}    $.RewardPoint_Product_PointToMoney
    ${get_point_to_money}    Get data from response json    ${get_resp}    $.RewardPoint_Product_MoneyToPoint
    ${get_invoice_count}    Get data from response json    ${get_resp}    $.RewardPoint_Product_InvoiceCount
    Return From Keyword    ${get_money_to_point}    ${get_point_to_money}   ${get_invoice_count}

Get client id thr API
    ${get_client_id}      Get data from API    ${endpoint_client_id}    $.ClientId
    Return From Keyword    ${get_client_id}

Get client id and cliend secret thr API
    ${get_client_id}    Get client id thr API
    ${endpoint_client_serect}   Format String    ${endpoint_client_serect}    ${get_client_id}
    ${get_client_secret}      Get data from API    ${endpoint_client_serect}    $.ClientSecret
    Return From Keyword    ${get_client_id}   ${get_client_secret}
