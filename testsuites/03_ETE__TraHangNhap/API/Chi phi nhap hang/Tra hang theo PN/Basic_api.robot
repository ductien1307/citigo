*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}      ${headless_browser}
Resource          ../../../../../core/API/api_phieu_nhap_hang.robot
Resource          ../../../../../core/Giao_dich/tra_hang_nhap_list_page.robot
Resource          ../../../../../core/Giao_dich/tra_hang_nhap_list_action.robot
Resource          ../../../../../core/API/api_danhmuc_hanghoa.robot
Resource          ../../../../../core/API/api_nha_cung_cap.robot
Resource          ../../../../../core/API/api_tra_hang_nhap.robot
Resource          ../../../../../core/Giao_dich/nhaphang_getandcompute.robot
Resource          ../../../../../core/share/toast_message.robot
Resource          ../../../../../core/API/api_soquy.robot

*** Variables ***
&{dict_pr1}       DNT019=7.5    DNT022=15    NQD04=6    NS01=3
@{list_newprice1}    45000    89000.5    69000    90000
&{dict_pr_return1}    DNT019=6    DNT022=7.2    NQD04=6    NS01=2
&{dict_discountvalue1}    DNT019=10000    DNT022=15    NQD04=0    NS01=79000.64
&{dict_discounttype1}    DNT019=dis    DNT022=dis    NQD04=none    NS01=change
@{CPNH}           CPNH2    CPNH4

*** Test Cases ***    NCC              Dict sp - sl nhap    List gia nhap         GGPN             Tien tra ncc       Dict sp - sl tra       Discount Value            Discount Type             Purchase return Discount    Payment    CPNH hoan lai
Ko phan bo ggpn       [Tags]                       ETNCA1
                      [Template]                   ethnca2
                      NCC0002          ${dict_pr1}          ${list_newprice1}     30000            60000              ${dict_pr_return1}    ${dict_discountvalue1}    ${dict_discounttype1}      all                         ${CPNH}

Phan bo ggpn          [Tags]                       ETNCA1
                      [Template]                   ethnca3
                      NCC0003          ${dict_pr1}           ${list_newprice1}     20              30000              ${dict_pr_return1}    ${dict_discountvalue1}    ${dict_discounttype1}      20000                        40000        ${CPNH}

*** Keywords ***
ethnca2
    [Arguments]    ${supplier_code}    ${dict_pr}    ${list_newprice}    ${input_ggpn}    ${input_datrancc}    ${dict_pr_return}
    ...    ${dict_discountvalue}    ${dict_discounttype}    ${input_paid_supplier}    ${list_cpnh}
    ${receipt_code}    Add new purchase receipt thr API    ${supplier_code}    ${dict_pr}    ${list_newprice}    ${input_ggpn}    ${input_datrancc}
    ${list_products}    Get Dictionary Keys    ${dict_pr_return}
    ${list_nums_return}    Get Dictionary Values    ${dict_pr_return}
    ${list_nums}    Get Dictionary Values    ${dict_pr}
    ${list_product_discount}    Get Dictionary Values    ${dict_discountvalue}
    ${list_product_discount_type}    Get Dictionary Values    ${dict_discounttype}
    Log    get dvcb cua sp
    ${list_pr_cb}    Get list code basic of product unit    ${list_products}
    Log    get list imei
    ${get_list_imei_status}    Get list imei status thr API    ${list_products}
    ${list_imei_return}    Create List
    : FOR    ${item_num_return}    ${item_list_imei}    ${item_status}    IN ZIP    ${list_nums_return}    ${list_imei_all}
    ...    ${get_list_imei_status}
    \    ${item_list_imei_return}    Run Keyword If    '${item_status}'=='True'    Convert string to List    ${item_list_imei}
    \    ...    ELSE    Set Variable    ${EMPTY}
    \    ${item_list_imei_return}    Run Keyword If    '${item_status}'=='True'    Get list imei by num    ${item_num_return}    ${item_list_imei_return}
    \    ...    ELSE    Set Variable    ${EMPTY}
    \    Append To List    ${list_imei_return}    ${item_list_imei_return}
    Log    ${list_imei_return}
    #
    Log    tính thanh tien, toan kho, gia moi
    ${list_result_thanhtien_af}    ${list_result_newprice_af}    ${list_result_onhand_cb_af}    ${list_result_onhand_actual_af}    ${list_actual_num_cb}    ${list_result_newprice_cb_af}    ${list_gianhap}
    ...    ${list_result_disvnd_by_pr}    Get list of total purchase return - result onhand actual product in case of price change    ${list_pr_cb}    ${list_products}    ${list_nums_return}    ${list_product_discount}
    ...    ${list_product_discount_type}
    ${get_no_bf_execute}    ${get_tong_mua_bf_execute}    ${supplier_name}    Get Supplier Info    ${supplier_code}
    Log    get tong tien hang, giam gia phieu nhap, gia nhap sp
    ${get_tongtienhang}    ${get_ggpn}    Get sub total - discount purchase receipt by purchase receipt code    ${receipt_code}
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
    Log    tinh tong tien hang phieu tra
    ${result_tongtienhang}    Sum values in list    ${list_result_thanhtien_af}
    ${result_discount_vnd}    Price after apllocate discount    ${get_ggpn}    ${get_tongtienhang}    ${result_tongtienhang}
    ${result_discount_vnd}    Evaluate    round(${result_discount_vnd}, 0)
    ${result_tongtien_tru_gg}    Minus    ${result_tongtienhang}    ${result_discount_vnd}
    #
    Log    tinh tong cpnh
    ${list_supplier_charge_value_vnd}    Create List
    : FOR    ${item_supplier_charge}    IN ZIP    ${list_supplier_charge_value}
    \    ${item_supplier_charge}=    Run Keyword If    ${item_supplier_charge}> 100    Set Variable    ${item_supplier_charge}
    \    ...    ELSE    Convert % discount to VND and round    ${item_supplier_charge}    ${result_tongtien_tru_gg}
    \    ${item_supplier_charge}    Replace floating point    ${item_supplier_charge}
    \    Append To List    ${list_supplier_charge_value_vnd}    ${item_supplier_charge}
    Log    ${list_supplier_charge_value_vnd}
    ${total_supplier_charge}    Sum values in list    ${list_supplier_charge_value_vnd}
    Log    tinh ncc can tra
    ${paid_supplier_value}    Sum    ${result_tongtien_tru_gg}    ${total_supplier_charge}
    ${actual_supplier_payment}    Set Variable If    '${input_paid_supplier}' == 'all'    ${paid_supplier_value}    ${input_paid_supplier}
    ${actual_supplier_payment}    Replace floating point    ${actual_supplier_payment}
    ${result_recent_debt_purchase_return}    Minus    ${paid_supplier_value}    ${actual_supplier_payment}
    ${result_nohientai}    Minus    ${get_no_bf_execute}    ${result_recent_debt_purchase_return}
    ${result_tong_mua_af_ex}    Sum    ${get_tong_mua_bf_execute}    0
    Log    tinh toan gia von sau khi nhap hang
    ${list_cost_cb_af_ex}    Computation list of cost incase purchase return have discount, price change and have expense    ${list_pr_cb}    ${list_result_newprice_cb_af}    ${list_actual_num_cb}    ${result_discount_vnd}    ${result_tongtienhang}
    ...    ${total_supplier_charge}
    #
    Log    tao phieu qua api
    ${purchase_return_code}    Generate code automatically    THNR
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${get_id_ncc}    Get Supplier Id    ${supplier_code}
    ${get_pur_oder_id}    Get purchase receipt id thr API    ${receipt_code}
    ${get_list_prs_id}    Get list product id thr API    ${list_products}
    ${get_list_prs_order_detail_id}    Get list product order detail id in purchase receipt thr API    ${list_products}    ${receipt_code}
    Log    json return detail
    ${liststring_prs_return_detail}    Set Variable    needdel
    : FOR    ${item_product}    ${item_num_return}    ${item_list_imei}    ${item_discount}    ${item_discount_type}    ${item_newprice}
    ...    ${item_status}    ${item_pr_id}    ${item_gianhap}    ${item_disvnd}    ${item_num}    ${item_id_order}
    ...    IN ZIP    ${list_products}    ${list_nums_return}    ${list_imei_return}    ${list_product_discount}    ${list_product_discount_type}
    ...    ${list_result_newprice_af}    ${get_list_imei_status}    ${get_list_prs_id}    ${list_gianhap}    ${list_result_disvnd_by_pr}    ${list_nums}
    ...    ${get_list_prs_order_detail_id}
    \    ${discount_%}    Set Variable If    '${item_discount_type}'=='dis' and 0<${item_discount}<100    ${item_discount}    null
    \    ${discount_type}    Set Variable If    '${item_discount_type}'=='dis' and 0<${item_discount}<100    %    VND
    \    ${list_imei_to_input}    Run Keyword If    '${item_status}'=='True'    Convert To String    ${item_list_imei}
    \    ...    ELSE    Set Variable    ${EMPTY}
    \    ${list_imei_to_input}    Run Keyword If    '${item_status}'=='True'    Replace sq blackets    ${list_imei_to_input}
    \    ...    ELSE    Set Variable    ${EMPTY}
    \    ${payload_each_product}    Format string    {{"PurchaseOrderSerials":"","ProductId":{0},"Product":{{"TradeMarkName":"","Id":{0},"Code":"NS02","Name":"chuột quang xám","CategoryId":173814,"AllowsSale":true,"BasePrice":300000,"Tax":0,"RetailerId":{1},"isActive":true,"CreatedDate":"","ProductType":2,"HasVariants":false,"Unit":"","ConversionValue":1,"OrderTemplate":"","FullName":"chuột quang xám","IsLotSerialControl":true,"IsRewardPoint":false,"isDeleted":false,"MasterCode":"SPC001819","Revision":"AAAAAAmfZbc=","Formula":[],"ProductImages":[],"PurchaseReturnDetails":[],"ProductChild":[],"ProductAttributes":[],"ProductChildUnit":[],"PriceBookDetails":[],"ProductBranches":[],"TableAndRooms":[],"Manufacturings":[],"ManufacturingDetails":[],"DamageDetails":[],"ProductSerials":[],"ProductFormulaHistories":[],"OrderSupplierDetails":[],"ProductShelves":[],"PrescriptionDetails":[],"OnHand":4,"Reserved":0}},"BuyPrice":{2},"suggestedReturnPrice":{2},"ReturnPrice":{3},"Quantity":{4},"ReturnQuantity":0,"SellQuantity":{5},"BuyAndReturnQuantity":{5},"PurchaseOrderDetailId":{6},"ProductBatchExpires":[],"ListProductUnit":[],"Units":[],"Unit":"","SelectedUnit":{0},"ShowUnit":false,"ConversionValue":1,"OnHand":4,"OnOrder":0,"Reserved":0,"Shelves":"","Note":"","discountType":"{7}","discountValue":{8},"IsLotSerialControl":true,"ProductSerials":[],"UniqueId":"{0}_0","ViewIndex":1,"rowPerProduct":1,"isOdd":true,"ProductCode":"NS02","ProductName":"chuột quang xám","Serials":[],"SerialNumbers":"{9}","rowIndex":0,"discountValueWoRound":{10},"Discount":{11},"DiscountRatio":{10},"ReturnPriceWoRound":{3},"OrderByNumber":0}}    ${item_pr_id}    ${get_id_nguoitao}    ${item_gianhap}
    \    ...    ${item_newprice}    ${item_num_return}    ${item_num}    ${item_id_order}    ${discount_type}
    \    ...    ${item_discount}    ${list_imei_to_input}    ${discount_%}    ${item_disvnd}
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
    ${request_payload}    Format String    {{"PurchaseReturn":{{"Code":"{0}","PurchaseReturnDetails":[{1}],"PurchaseOrderDetails":[],"UserId":{2},"User":{{"id":{2},"username":"admin","givenName":"admin","Id":{2},"UserName":"admin","GivenName":"admin","IsAdmin":true,"IsLimitedByTrans":false,"IsShowSumRow":true,"Theme":""}},"ReceivedById":{2},"CompareReceivedById":{2},"CompareReturnDate":"","ModifiedDate":"","Description":"","Supplier":{{"TotalInvoiced":0,"CompareCode":"NCC0010","CompareName":"NCC Thu Hương","ComparePhone":"0977654899","Id":{3},"Name":"NCC Thu Hương","Phone":"0977654899","RetailerId":{4},"Code":"NCC0010","CreatedDate":"","CreatedBy":{2},"Debt":-77042,"LocationName":"","WardName":"","BranchId":{5},"isDeleted":false,"isActive":true,"SearchNumber":"0977654899","PurchaseOrders":[],"PurchaseReturns":[],"PurchasePayments":[],"SupplierGroupDetails":[],"OrderSuppliers":[]}},"SupplierId":{3},"SubTotal":{6},"Branch":{{"id":{5},"name":"Chi nhánh trung tâm","Id":{5},"Name":"Chi nhánh trung tâm","Address":"abc","LocationName":"Hà Nội - Quận Cầu Giấy","WardName":"","ContactNumber":"","SubContactNumber":""}},"Status":3,"CompareStatus":3,"StatusValue":"Phiếu tạm","Discount":{7},"DiscountRatio":null,"Id":0,"TotalReturn":{8},"BalanceDue":205578,"PaidAmount":0,"PayingAmount":{9},"ChangeAmount":-135578,"Account":{{}},"paymentMethod":null,"ExpensesOthersTitle":"Phí nhập 2, Phí nhập 4","PurchaseOrderExpensesOthers":[],"PurchaseReturnExpensesOthers":[{12}],"ExReturnSuppliers":{10},"PurchaseOrderSubTotal":272958,"isAutoChangeDiscount":true,"paymentMethodObj":null,"TotalQuantity":2,"OriginTotal":145578,"Total":1620000,"PurchaseOrderId":{11},"PurchaseOrderDiscount":116982,"PurchaseOrderTotal":389940,"PurchasePayments":[{{"Amount":{9},"Method":"Cash"}}],"BranchId":{5}}},"Completed":true,"CopyFrom":"","PurchaseReturnOld":"{11}"}}    ${purchase_return_code}    ${liststring_prs_return_detail}    ${get_id_nguoiban}    ${get_id_ncc}
    ...    ${get_id_nguoitao}    ${BRANCH_ID}    ${result_tongtienhang}    ${result_discount_vnd}    ${paid_supplier_value}    ${actual_supplier_payment}
    ...    ${total_supplier_charge}    ${get_pur_oder_id}    ${liststring_cpnh}
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
    Should Be Equal As Numbers    ${payment_return_total}    ${result_tongtienhang}
    Should Be Equal As Numbers    ${payment_return_total}    ${result_tongtienhang}
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
    : FOR    ${item_product}    ${item_imei_by_pr}    ${item_status}    IN ZIP    ${list_products}    ${list_imei_return}
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

ethnca3
    [Arguments]    ${supplier_code}    ${dict_pr}    ${list_newprice}    ${input_ggpn}    ${input_datrancc}    ${dict_pr_return}
    ...    ${dict_discountvalue}    ${dict_discounttype}    ${return_discount}    ${input_paid_supplier}    ${list_cpnh}
    ${receipt_code}    Add new purchase receipt thr API    ${supplier_code}    ${dict_pr}    ${list_newprice}    ${input_ggpn}    ${input_datrancc}
    ${list_products}    Get Dictionary Keys    ${dict_pr_return}
    ${list_nums_return}    Get Dictionary Values    ${dict_pr_return}
    ${list_product_discount}    Get Dictionary Values    ${dict_discountvalue}
    ${list_product_discount_type}    Get Dictionary Values    ${dict_discounttype}
    ${list_nums}    Get Dictionary Values    ${dict_pr}
    Log    get dvcb cua sp
    ${list_pr_cb}    Get list code basic of product unit    ${list_products}
    #
    Log    get list imei
    ${get_list_imei_status}    Get list imei status thr API    ${list_products}
    ${list_imei_return}    Create List
    : FOR    ${item_num_return}    ${item_list_imei}    ${item_status}    IN ZIP    ${list_nums_return}    ${list_imei_all}
    ...    ${get_list_imei_status}
    \    ${item_list_imei_return}    Run Keyword If    '${item_status}'=='True'    Convert string to List    ${item_list_imei}
    \    ...    ELSE    Set Variable    ${EMPTY}
    \    ${item_list_imei_return}    Run Keyword If    '${item_status}'=='True'    Get list imei by num    ${item_num_return}    ${item_list_imei_return}
    \    ...    ELSE    Set Variable    ${EMPTY}
    \    Append To List    ${list_imei_return}    ${item_list_imei_return}
    Log    ${list_imei_return}
    #
    Log    tinh thanh tien phieu tra, get tong tien,gg phieu nhap
    ${get_tongtienhang}    ${get_ggpn}    Get sub total - discount purchase receipt by purchase receipt code    ${receipt_code}
    ${get_list_gianhap}    Get list supply price of product by purchase reciept code    ${receipt_code}    ${list_products}
    ${list_price_allocate}    ${list_discount_allocate}    Computation supply price allocation in purchase order    ${get_list_gianhap}    ${get_ggpn}    ${get_tongtienhang}
    ${list_result_thanhtien_af}    ${list_result_newprice_af}    ${list_result_onhand_cb_af}    ${list_actual_num_cb}    ${list_result_newprice_cb_af}    ${list_result_disvnd_by_pr}    Get list of total purchase return - result onhand actual product in case allocation price
    ...    ${list_pr_cb}    ${list_products}    ${list_price_allocate}    ${list_nums_return}    ${list_product_discount}    ${list_product_discount_type}
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
    ${result_tongtien_tru_gg}    Minus    ${result_tongtienhang}    ${return_discount}
    #
    Log    tinh tong cpnh
    ${list_supplier_charge_value_vnd}    Create List
    : FOR    ${item_supplier_charge}    IN ZIP    ${list_supplier_charge_value}
    \    ${item_supplier_charge}=    Run Keyword If    ${item_supplier_charge}> 100    Set Variable    ${item_supplier_charge}
    \    ...    ELSE    Convert % discount to VND and round    ${item_supplier_charge}    ${result_tongtien_tru_gg}
    \    ${item_supplier_charge}    Replace floating point    ${item_supplier_charge}
    \    Append To List    ${list_supplier_charge_value_vnd}    ${item_supplier_charge}
    Log    ${list_supplier_charge_value_vnd}
    ${total_supplier_charge}    Sum values in list    ${list_supplier_charge_value_vnd}
    #
    ${paid_supplier_value}    Sum    ${result_tongtien_tru_gg}    ${total_supplier_charge}
    ${actual_supplier_payment}    Set Variable If    '${input_paid_supplier}' == 'all'    ${paid_supplier_value}    ${input_paid_supplier}
    ${actual_supplier_payment}    Replace floating point    ${actual_supplier_payment}
    ${result_recent_debt_purchase_return}    Minus    ${paid_supplier_value}    ${actual_supplier_payment}
    ${result_nohientai}    Minus    ${get_no_bf_execute}    ${result_recent_debt_purchase_return}
    ${result_tong_mua_af_ex}    Sum    ${get_tong_mua_bf_execute}    0
    #
    Log    tinh toan gia von sau khi nhap hang
    ${list_cost_cb_af_ex}    Computation list of cost incase purchase return have discount, price change and have expense    ${list_pr_cb}    ${list_result_newprice_cb_af}    ${list_actual_num_cb}    ${return_discount}    ${result_tongtienhang}
    ...    ${total_supplier_charge}
    #
    Log    tao phieu qua api
    ${purchase_return_code}    Generate code automatically    THNR
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${get_id_ncc}    Get Supplier Id    ${supplier_code}
    ${get_pur_oder_id}    Get purchase receipt id thr API    ${receipt_code}
    ${get_list_prs_id}    Get list product id thr API    ${list_products}
    ${get_list_prs_order_detail_id}    Get list product order detail id in purchase receipt thr API    ${list_products}    ${receipt_code}
    Log    json return detail
    ${liststring_prs_return_detail}    Set Variable    needdel
    : FOR    ${item_product}    ${item_num_return}    ${item_list_imei}    ${item_discount}    ${item_discount_type}    ${item_newprice}
    ...    ${item_status}    ${item_pr_id}    ${item_gianhap}    ${item_disvnd}    ${item_num}    ${item_id_order}
    ...    IN ZIP    ${list_products}    ${list_nums_return}    ${list_imei_return}    ${list_product_discount}    ${list_product_discount_type}
    ...    ${list_result_newprice_af}    ${get_list_imei_status}    ${get_list_prs_id}    ${list_price_allocate}    ${list_result_disvnd_by_pr}    ${list_nums}
    ...    ${get_list_prs_order_detail_id}
    \    ${discount_%}    Set Variable If    '${item_discount_type}'=='dis' and 0<${item_discount}<100    ${item_discount}    null
    \    ${discount_type}    Set Variable If    '${item_discount_type}'=='dis' and 0<${item_discount}<100    %    VND
    \    ${list_imei_to_input}    Run Keyword If    '${item_status}'=='True'    Convert To String    ${item_list_imei}
    \    ...    ELSE    Set Variable    ${EMPTY}
    \    ${list_imei_to_input}    Run Keyword If    '${item_status}'=='True'    Replace sq blackets    ${list_imei_to_input}
    \    ...    ELSE    Set Variable    ${EMPTY}
    \    ${payload_each_product}    Format string    {{"PurchaseOrderSerials":"","ProductId":{0},"Product":{{"TradeMarkName":"","Id":{0},"Code":"NS02","Name":"chuột quang xám","CategoryId":173814,"AllowsSale":true,"BasePrice":300000,"Tax":0,"RetailerId":{1},"isActive":true,"CreatedDate":"","ProductType":2,"HasVariants":false,"Unit":"","ConversionValue":1,"OrderTemplate":"","FullName":"chuột quang xám","IsLotSerialControl":true,"IsRewardPoint":false,"isDeleted":false,"MasterCode":"SPC001819","Revision":"AAAAAAmfZbc=","Formula":[],"ProductImages":[],"PurchaseReturnDetails":[],"ProductChild":[],"ProductAttributes":[],"ProductChildUnit":[],"PriceBookDetails":[],"ProductBranches":[],"TableAndRooms":[],"Manufacturings":[],"ManufacturingDetails":[],"DamageDetails":[],"ProductSerials":[],"ProductFormulaHistories":[],"OrderSupplierDetails":[],"ProductShelves":[],"PrescriptionDetails":[],"OnHand":4,"Reserved":0}},"BuyPrice":{2},"suggestedReturnPrice":{2},"ReturnPrice":{3},"Quantity":{4},"ReturnQuantity":0,"SellQuantity":{5},"BuyAndReturnQuantity":{5},"PurchaseOrderDetailId":{6},"ProductBatchExpires":[],"ListProductUnit":[],"Units":[],"Unit":"","SelectedUnit":{0},"ShowUnit":false,"ConversionValue":1,"OnHand":4,"OnOrder":0,"Reserved":0,"Shelves":"","Note":"","discountType":"{7}","discountValue":{8},"IsLotSerialControl":true,"ProductSerials":[],"UniqueId":"{0}_0","ViewIndex":1,"rowPerProduct":1,"isOdd":true,"ProductCode":"NS02","ProductName":"chuột quang xám","Serials":[],"SerialNumbers":"{9}","rowIndex":0,"discountValueWoRound":{10},"Discount":{11},"DiscountRatio":{10},"ReturnPriceWoRound":{3},"OrderByNumber":0}}    ${item_pr_id}    ${get_id_nguoitao}    ${item_gianhap}
    \    ...    ${item_newprice}    ${item_num_return}    ${item_num}    ${item_id_order}    ${discount_type}
    \    ...    ${item_discount}    ${list_imei_to_input}    ${discount_%}    ${item_disvnd}
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
    ${request_payload}    Format String    {{"PurchaseReturn":{{"Code":"{0}","PurchaseReturnDetails":[{1}],"PurchaseOrderDetails":[],"UserId":{2},"User":{{"id":{2},"username":"admin","givenName":"admin","Id":{2},"UserName":"admin","GivenName":"admin","IsAdmin":true,"IsLimitedByTrans":false,"IsShowSumRow":true,"Theme":""}},"ReceivedById":{2},"CompareReceivedById":{2},"CompareReturnDate":"","ModifiedDate":"","Description":"","Supplier":{{"TotalInvoiced":0,"CompareCode":"NCC0010","CompareName":"NCC Thu Hương","ComparePhone":"0977654899","Id":{3},"Name":"NCC Thu Hương","Phone":"0977654899","RetailerId":{4},"Code":"NCC0010","CreatedDate":"","CreatedBy":{2},"Debt":-77042,"LocationName":"","WardName":"","BranchId":{5},"isDeleted":false,"isActive":true,"SearchNumber":"0977654899","PurchaseOrders":[],"PurchaseReturns":[],"PurchasePayments":[],"SupplierGroupDetails":[],"OrderSuppliers":[]}},"SupplierId":{3},"SubTotal":{6},"Branch":{{"id":{5},"name":"Chi nhánh trung tâm","Id":{5},"Name":"Chi nhánh trung tâm","Address":"abc","LocationName":"Hà Nội - Quận Cầu Giấy","WardName":"","ContactNumber":"","SubContactNumber":""}},"Status":3,"CompareStatus":3,"StatusValue":"Phiếu tạm","Discount":{7},"DiscountRatio":null,"Id":0,"TotalReturn":{8},"BalanceDue":205578,"PaidAmount":0,"PayingAmount":{9},"ChangeAmount":-135578,"Account":{{}},"paymentMethod":null,"ExpensesOthersTitle":"Phí nhập 2, Phí nhập 4","PurchaseOrderExpensesOthers":[],"PurchaseReturnExpensesOthers":[{12}],"ExReturnSuppliers":{10},"PurchaseOrderSubTotal":272958,"isAutoChangeDiscount":true,"paymentMethodObj":null,"TotalQuantity":2,"OriginTotal":145578,"Total":1620000,"PurchaseOrderId":{11},"PurchaseOrderDiscount":116982,"PurchaseOrderTotal":389940,"PurchasePayments":[{{"Amount":{9},"Method":"Cash"}}],"BranchId":{5}}},"Completed":true,"CopyFrom":"","PurchaseReturnOld":"{11}"}}    ${purchase_return_code}    ${liststring_prs_return_detail}    ${get_id_nguoiban}    ${get_id_ncc}
    ...    ${get_id_nguoitao}    ${BRANCH_ID}    ${result_tongtienhang}    ${return_discount}    ${paid_supplier_value}    ${actual_supplier_payment}
    ...    ${total_supplier_charge}    ${get_pur_oder_id}    ${liststring_cpnh}
    Log    ${request_payload}
    ${headers}=    Create Dictionary    Authorization=${bearertoken}    Content-Type=application/json;charset=UTF-8    Retailer=${RETAILER_NAME}    BranchId=${BRANCH_ID}    Zone=${env}
    Create Session    lolo    ${API_URL}    cookies=${resp.cookies}    verify=True    debug=1
    ${resp}=    Post Request    lolo    /PurchaseReturns    data=${request_payload}    headers=${headers}
    Log    ${resp.request.body}
    Log    ${resp.json()}
    Log    ${resp.status_code}
    Should Be Equal As Strings    ${resp.status_code}    200
    Sleep    10s    wait for response to API
    Log    tat cpnh
    : FOR    ${item_cpnh}    ${item_sp_charge_value}    IN ZIP    ${list_cpnh}    ${list_supplier_charge_value}
    \    Run Keyword If    ${item_sp_charge_value}>100    Toggle supplier's charge VND    ${item_cpnh}    false
    \    ...    ELSE    Toggle supplier's charge %    ${item_cpnh}    false
    #
    Log    assert values in Hoa don
    ${quantity_total}    ${payment_return_total}    ${supplier_need_pay}    ${supplier_payment}    ${status}    Get Purchase Return Info    ${purchase_return_code}
    Should Be Equal As Numbers    ${payment_return_total}    ${result_tongtienhang}
    Should Be Equal As Numbers    ${payment_return_total}    ${result_tongtienhang}
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
    : FOR    ${item_product}    ${item_imei_by_pr}    ${item_status}    IN ZIP    ${list_products}    ${list_imei_return}
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
