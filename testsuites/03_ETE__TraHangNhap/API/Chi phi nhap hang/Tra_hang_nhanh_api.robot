*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}      ${headless_browser}
Resource          ../../../../core/API/api_phieu_nhap_hang.robot
Resource          ../../../../core/Giao_dich/tra_hang_nhap_list_page.robot
Resource          ../../../../core/Giao_dich/tra_hang_nhap_list_action.robot
Resource          ../../../../core/API/api_danhmuc_hanghoa.robot
Resource          ../../../../core/API/api_nha_cung_cap.robot
Resource          ../../../../core/API/api_tra_hang_nhap.robot
Resource          ../../../../core/Giao_dich/nhaphang_getandcompute.robot
Resource          ../../../../core/share/toast_message.robot
Resource          ../../../../core/API/api_soquy.robot

*** Variables ***
&{dict_pr1}       DNT019=5    DNT022=11.2    NQD04=9    NS01=3
&{dict_discountvalue1}    DNT019=4000    DNT022=14    NQD04=0    NS01=25499.28
&{dict_discounttype1}    DNT019=dis    DNT022=dis    NQD04=none    NS01=change
@{CPNH}           CPNH2    CPNH4

*** Test Cases ***    Product Code and Quantity    Discount Value            Discount Type            Purchase return Discount    Payment    Supplier Code      CPNH hoan lai
Tra Hang Nhap Nhanh
                      [Tags]                       ETNCA
                      [Template]                   ethnca1
                      ${dict_pr1}                  ${dict_discountvalue1}    ${dict_discounttype1}    10                          all        NCC0001            ${CPNH}

*** Keywords ***
ethnca1
    [Arguments]    ${dict_pr}    ${dict_discountvalue}    ${dict_discounttype}    ${return_discount}    ${input_paid_supplier}    ${supplier_code}
    ...    ${list_cpnh}
    ${list_products}    Get Dictionary Keys    ${dict_pr}
    ${list_nums}    Get Dictionary Values    ${dict_pr}
    ${list_product_discount}    Get Dictionary Values    ${dict_discountvalue}
    ${list_product_discount_type}    Get Dictionary Values    ${dict_discounttype}
    ${list_all_imeis}    Create List
    ${list_nums}    Get Dictionary Values    ${dict_pr}
    #
    Log     get dvcb cua sp
    ${list_pr_cb}    Get list code basic of product unit    ${list_products}
    #
    Log    get list imei
    ${get_list_imei_status}    Get list imei status thr API    ${list_products}
    ${list_all_imeis}    Create List
    : FOR    ${item_product}    ${item_num}    ${item_status}    IN ZIP    ${list_products}    ${list_nums}
    ...    ${get_list_imei_status}
    \    ${imei_by_product}    Run Keyword If    '${item_status}'=='True'    Import multi imei for product    ${item_product}    ${item_num}
    \    ...    ELSE    Set Variable    ${EMPTY}
    \    Append To List    ${list_all_imeis}    ${imei_by_product}
    Log    ${list_all_imeis}
    Sleep    10s
    #
    Log    Get Data
    ${list_result_thanhtien_af}    ${list_result_newprice_af}    ${list_result_onhand_cb_af}    ${list_result_onhand_actual_af}    ${list_actual_num_cb}    ${list_result_newprice_cb_af}    ${list_gianhap}
    ...    ${list_result_disvnd_by_pr}    Get list of total purchase return - result onhand actual product in case of price change    ${list_pr_cb}    ${list_products}    ${list_nums}    ${list_product_discount}
    ...    ${list_product_discount_type}
    ${get_no_bf_execute}    ${get_tong_mua_bf_execute}    ${supplier_name}    Get Supplier Info    ${supplier_code}
    #
    Log    Bat CPNH
    ${list_supplier_charge_value}    Create List
    : FOR    ${item_cpnh}    IN ZIP    ${list_cpnh}
    \    ${supplier_charge_vnd}    Get expense VND value    ${item_cpnh}
    \    ${supplier_charge_%}    Get expense percentage value    ${item_cpnh}
    \    ${supplier_charge_value}    Set Variable If    ${supplier_charge_%}==0    ${supplier_charge_vnd}    ${supplier_charge_%}
    \    Run Keyword If    ${supplier_charge_value}>100    Toggle supplier's charge VND    ${item_cpnh}    true
    \    ...    ELSE    Toggle supplier's charge %    ${item_cpnh}    true
    \    Append To List    ${list_supplier_charge_value}    ${supplier_charge_value}
    Log    ${list_supplier_charge_value}
    #
    Log    tinh tong tien hang
    ${result_tongtienhang}    Sum values in list    ${list_result_thanhtien_af}
    ${result_discount_invoice}    Run Keyword If    0 < ${return_discount} < 100    Convert % discount to VND and round    ${result_tongtienhang}    ${return_discount}
    ...    ELSE    Set Variable    ${return_discount}
    ${result_tongtien_tru_gg}    Minus    ${result_tongtienhang}    ${result_discount_invoice}
    #
    Log    tinh tong CPNH
    ${list_supplier_charge_value_vnd}    Create List
    : FOR    ${item_supplier_charge}    IN ZIP    ${list_supplier_charge_value}
    \    ${item_supplier_charge}=    Run Keyword If    ${item_supplier_charge}> 100    Set Variable    ${item_supplier_charge}
    \    ...    ELSE    Convert % discount to VND and round    ${item_supplier_charge}    ${result_tongtien_tru_gg}
    \    ${item_supplier_charge}    Replace floating point    ${item_supplier_charge}
    \    Append To List    ${list_supplier_charge_value_vnd}    ${item_supplier_charge}
    Log    ${list_supplier_charge_value_vnd}
    ${total_supplier_charge}    Sum values in list    ${list_supplier_charge_value_vnd}
    #
    Log    tinh ncc can tra, tong no
    ${paid_supplier_value}    Sum    ${result_tongtien_tru_gg}    ${total_supplier_charge}
    ${actual_supplier_payment}    Set Variable If    '${input_paid_supplier}' == 'all'    ${paid_supplier_value}    ${input_paid_supplier}
    ${actual_supplier_payment}    Replace floating point    ${actual_supplier_payment}
    ${result_recent_debt_purchase_return}    Minus    ${paid_supplier_value}    ${actual_supplier_payment}
    ${result_nohientai}    Minus    ${get_no_bf_execute}    ${result_recent_debt_purchase_return}
    ${result_tong_mua_af_ex}    Sum    ${get_tong_mua_bf_execute}    0
    #
    Log    tinh toan gia von sau khi nhap hang
    ${list_cost_cb_af_ex}    Computation list of cost incase purchase return have discount, price change and have expense    ${list_pr_cb}    ${list_result_newprice_cb_af}    ${list_actual_num_cb}    ${result_discount_invoice}    ${result_tongtienhang}
    ...    ${total_supplier_charge}
    #
    Log    tao phieu qua api
    ${purchase_return_code}    Generate code automatically    THNR
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${get_id_ncc}    Get Supplier Id    ${supplier_code}
    ${get_list_prs_id}    Get list product id thr API    ${list_products}
    Log    json return detail
    ${liststring_prs_return_detail}    Set Variable    needdel
    : FOR    ${item_product}    ${item_num}    ${item_list_imei}    ${item_change}    ${item_change_type}    ${item_newprice}
    ...    ${item_status}    ${item_pr_id}    ${item_gianhap}    ${item_disvnd}    IN ZIP    ${list_products}
    ...    ${list_nums}    ${list_all_imeis}    ${list_product_discount}    ${list_product_discount_type}    ${list_result_newprice_af}    ${get_list_imei_status}
    ...    ${get_list_prs_id}       ${list_gianhap}      ${list_result_disvnd_by_pr}
    \    ${discount_%}    Set Variable If    '${item_change_type}'=='dis' and 0<${item_change}<100    ${item_change}    null
    \    ${discount_type}    Set Variable If    '${item_change_type}'=='dis' and 0<${item_change}<100    %    VND
    \    ${list_imei_to_input}    Run Keyword If    '${item_status}'=='True'    Convert To String    ${item_list_imei}
    \    ...    ELSE    Set Variable    ${EMPTY}
    \    ${list_imei_to_input}    Run Keyword If    '${item_status}'=='True'      Replace sq blackets     ${list_imei_to_input}     ELSE    Set Variable    ${EMPTY}
    \    ${payload_each_product}    Format string    {{"PurchaseOrderSerials":"","ProductBatchExpires":[],"ProductId":{0},"Product":{{"Id":{0},"Name":"chuột quang hồng","Code":"NS01","IsLotSerialControl":true,"IsBatchExpireControl":false,"ProductShelvesStr":"","OnHand":68,"Reserved":0}},"BuyPrice":{1},"suggestedReturnPrice":{1},"ReturnPrice":{2},"Quantity":{3},"ReturnQuantity":0,"SellQuantity":null,"ReturnSerials":null,"IsLotSerialControl":true,"IsBatchExpireControl":false,"ConversionValue":1,"ListProductUnit":[{{"Id":{0},"Unit":"","Code":"NS01","Conversion":0,"MasterUnitId":0,"DiscountChanged":{4},"DiscountRatioChanged":{5},"PriceChanged":{3}}}],"Units":[{{"Id":{0},"Unit":"","Code":"NS01","Conversion":0,"MasterUnitId":0}}],"Unit":"","SelectedUnit":{0},"ShowUnit":false,"OnHand":68,"OnOrder":0,"Reserved":0,"ProductSerials":[],"UniqueId":"","ViewIndex":2,"rowPerProduct":1,"isOdd":false,"ProductCode":"NS01","ProductName":"chuột quang hồng","Serials":[],"SerialNumbers":"{6}","discountType":"{7}","discountValue":{5},"rowIndex":0,"discountValueWoRound":{5},"Discount":{4},"DiscountRatio":{5},"ReturnPriceWoRound":{4},"OrderByNumber":1}}
    \    ...  ${item_pr_id}    ${item_gianhap}    ${item_newprice}
    \    ...    ${item_num}    ${item_disvnd}    ${discount_%}    ${list_imei_to_input}    ${discount_type}
    \    ${liststring_prs_return_detail}    Catenate    SEPARATOR=,    ${liststring_prs_return_detail}    ${payload_each_product}
    Log    ${liststring_prs_return_detail}
    ${liststring_prs_return_detail}    Replace String    ${liststring_prs_return_detail}    needdel,    ${EMPTY}    count=1
    #
    Log    json cpnh
    ${get_list_cpnh_id}    Get list expenses id    ${list_cpnh}
    ${liststring_cpnh}    Set Variable    needdel
    : FOR    ${item_cpnh}    ${item_cpnh_id}    ${item_giatri}    IN ZIP    ${list_cpnh}    ${get_list_cpnh_id}
    ...    ${list_supplier_charge_value_vnd}
    \    ${payload_cpnh}    Format String    {{"ExpensesOtherId":{0},"Id":{0},"ExValue":{1},"Price":{1},"Name":"Phí nhập 3","Code":"{2}"}}    ${item_cpnh_id}    ${item_giatri}    ${item_cpnh}
    \    ${liststring_cpnh}    Catenate    SEPARATOR=,    ${liststring_cpnh}    ${payload_cpnh}
    Log    ${liststring_cpnh}
    ${liststring_cpnh}    Replace String    ${liststring_cpnh}    needdel,    ${EMPTY}    count=1
    #
    Log    json request
    ${request_payload}    Format String    {{"PurchaseReturn":{{"Code":"{0}","PurchaseReturnDetails":[{11}],"PurchaseOrderDetails":[],"UserId":{1},"User":{{"id":{1},"username":"admin","givenName":"admin","Id":{1},"UserName":"admin","GivenName":"admin","IsAdmin":true,"IsLimitedByTrans":false,"IsShowSumRow":true,"Theme":""}},"ReceivedById":{1},"CompareReceivedById":{1},"CompareReturnDate":"","ModifiedDate":"2","Description":"","Supplier":{{"TotalInvoiced":0,"CompareCode":"NCC0008","CompareName":"NCC Thái Bình","ComparePhone":"0977654897","Id":{2},"Name":"NCC Thái Bình","Phone":"0977654897","RetailerId":437336,"Code":"NCC0008","CreatedDate":"2019-05-25T15:49:09.6630000+07:00","CreatedBy":{1},"Debt":0,"LocationName":"","WardName":"","BranchId":{3},"isDeleted":false,"isActive":true,"SearchNumber":"0977654897","PurchaseOrders":[],"PurchaseReturns":[],"PurchasePayments":[],"SupplierGroupDetails":[],"OrderSuppliers":[]}},"SupplierId":{2},"SubTotal":{4},"Branch":{{"id":{3},"name":"Chi nhánh trung tâm","Id":{3},"Name":"Chi nhánh trung tâm","Address":"abc","LocationName":"Hà Nội - Quận Cầu Giấy","WardName":"","ContactNumber":"","SubContactNumber":""}},"Status":3,"CompareStatus":3,"StatusValue":"Phiếu tạm","Discount":{5},"DiscountRatio":{6},"Id":0,"TotalReturn":{7},"BalanceDue":485280,"PaidAmount":0,"PayingAmount":{8},"ChangeAmount":-335280,"Account":{{}},"paymentMethod":null,"ExpensesOthersTitle":"Phí nhập 2, Phí nhập 4","PurchaseOrderExpensesOthers":[],"PurchaseReturnExpensesOthers":[{12}],"ExReturnSuppliers":{9},"PurchaseOrderSubTotal":0,"isAutoChangeDiscount":false,"paymentMethodObj":null,"TotalQuantity":6,"OriginTotal":{10},"Total":420000,"PurchasePayments":[{{"Amount":{8},"Method":"Cash"}}],"BranchId":{3}}},"Completed":true,"CopyFrom":"","PurchaseReturnOld":"new"}}    ${purchase_return_code}    ${get_id_nguoiban}    ${get_id_ncc}    ${BRANCH_ID}
    ...    ${result_tongtienhang}    ${result_discount_invoice}    ${return_discount}    ${paid_supplier_value}    ${actual_supplier_payment}    ${total_supplier_charge}
    ...    ${result_tongtien_tru_gg}    ${liststring_prs_return_detail}    ${liststring_cpnh}    ${get_id_nguoitao}
    Log    ${request_payload}
    Post request thr API    /PurchaseReturns   ${request_payload}
    Sleep    10s    wait for response to API
    #
    Log    tat cpnh
    : FOR    ${item_cpnh}    ${item_sp_charge_value}    IN ZIP    ${list_cpnh}    ${list_supplier_charge_value}
    \    Run Keyword If    ${item_sp_charge_value}>100    Toggle supplier's charge VND    ${item_cpnh}    false
    \    ...    ELSE    Toggle supplier's charge %    ${item_cpnh}    false
    #
    Log    assert values in Hoa don
    ${quantity_total}    ${payment_return_total}    ${supplier_need_pay}    ${supplier_payment}    ${status}    Get Purchase Return Info    ${purchase_return_code}
    Run Keyword If    ${return_discount} == 0    Should Be Equal As Numbers    ${supplier_need_pay}    ${result_tongtienhang}
    ...    ELSE    Should Be Equal As Numbers    ${payment_return_total}    ${result_tongtienhang}
    Run Keyword If    ${return_discount} == 0    Log    Ignore validate
    ...    ELSE    Should Be Equal As Numbers    ${payment_return_total}    ${result_tongtienhang}
    Should Be Equal As Numbers    ${supplier_need_pay}    ${paid_supplier_value}
    Should Be Equal As Numbers    ${supplier_payment}    ${actual_supplier_payment}
    Should Be Equal As Strings    ${status}    Hoàn thành
    Log    Assert values in product list and stock card
    ${list_num_cb_instockcard}    Change negative number to positive number and vice versa in List    ${list_actual_num_cb}
    : FOR    ${item_product}    ${item_onhand_af_ex}    ${item_num_cb}    IN ZIP    ${list_pr_cb}    ${list_result_onhand_cb_af}
    ...    ${list_num_cb_instockcard}
    \    Wait Until Keyword Succeeds    3 times    30s    Assert values in Stock Card    ${purchase_return_code}    ${item_product}
    \    ...    ${item_onhand_af_ex}    ${item_num_cb}
    Log    assert imei
    : FOR    ${item_product}    ${item_imei_by_pr}    ${item_status}    IN ZIP    ${list_products}    ${list_all_imeis}
    ...    ${get_list_imei_status}
    \    ${list_imei_to_input}    Run Keyword If    '${item_status}'=='True'    Convert String to List    ${item_imei_by_pr}
    \    ...    ELSE    Log    Ignore
    \    Run Keyword If    '${item_status}'=='True'    Assert imei not avaiable in SerialImei tab    ${item_product}    @{list_imei_to_input}    Log
    \    ...    Ignore
    Log    assert value in tab cong no khach hang
    ${get_maphieu_soquy}    Catenate    SEPARATOR=    PT    ${purchase_return_code}
    Run Keyword If    '${input_paid_supplier}' == '0'    Validate status in Debt Tab of Supplier if purchase return is not paid until success    ${supplier_code}    ${purchase_return_code}
    ...    ELSE    Validate status in Debt Tab of Supplier if purchase return is paid until success    ${supplier_code}    ${get_maphieu_soquy}    ${purchase_return_code}
    Log    assert values in Khach hang and So quy
    #
    ${get_no_af_execute}    ${get_tong_mua_af_execute}    ${supplier_name}    Get Supplier Info    ${supplier_code}
    Should Be Equal As Numbers    ${result_nohientai}    ${get_no_af_execute}
    Should Be Equal As Numbers    ${result_tong_mua_af_ex}    ${get_tong_mua_af_execute}
    Run Keyword If    '${input_paid_supplier}' == '0'    Validate So quy info from Rest API if Invoice is not paid until success    ${get_maphieu_soquy}
    ...    ELSE    Validate So quy info from Rest API if Invoice is paid until success    ${get_maphieu_soquy}    ${actual_supplier_payment}
    #
    Wait Until Keyword Succeeds    3 times    30s    Assert list of onhand, cost af receipt    ${list_pr_cb}    ${list_result_onhand_cb_af}    ${list_cost_cb_af_ex}
    Delete purchase return code    ${purchase_return_code}
