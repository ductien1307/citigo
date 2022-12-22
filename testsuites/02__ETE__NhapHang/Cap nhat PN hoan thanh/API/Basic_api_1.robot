*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}      ${headless_browser}
Library           Collections
Resource          ../../../../core/hang_hoa/hang_hoa_navigation.robot
Resource          ../../../../core/share/computation.robot
Resource          ../../../../core/Giao_dich/nhap_hang_add_action.robot
Resource          ../../../../core/Giao_dich/nhap_hang_add_page.robot
Resource          ../../../../core/Giao_dich/nhap_hang_list_action.robot
Resource          ../../../../core/Giao_dich/giaodich_nav.robot
Resource          ../../../../core/API/api_danhmuc_hanghoa.robot
Resource          ../../../../core/Doi_Tac/doitac_navigation.robot
Resource          ../../../../core/Doi_Tac/ncc_list_action.robot
Resource          ../../../../core/So_Quy/so_quy_list_action.robot
Resource          ../../../../core/share/toast_message.robot
Resource          ../../../../core/API/api_nha_cung_cap.robot
Resource          ../../../../core/API/api_phieu_nhap_hang.robot
Resource          ../../../../core/API/api_soquy.robot
Resource          ../../../../core/Giao_dich/nhaphang_getandcompute.robot
Resource          ../../../../core/share/javascript.robot
Resource          ../../../../core/share/list_dictionary.robot

*** Variables ***
&{dict_pr1}        NHP003=5.2       NQD03=3     NS03=2
@{list_newprice1}    45000    89000.5    69000
@{list_num_edit1}     5       6.3       2
@{list_newprice_edit1}      65000       45000.6       70000
@{list_discount_edit1}      10000       15        20

*** Test Cases ***      Mã NCC      Dict SP-SL      List giá mới      GGPN      Tra ncc     List num eit      List gm edit           List gg edit              GGPN edit     Tien tra ncc      NCC eidt
Ko thanh toan
    [Tags]    ENA
    [Template]    ena01
    NCC0004        ${dict_pr1}       ${list_newprice1}        30000       0          ${list_num_edit1}     ${list_newprice_edit1}    ${list_discount_edit1}    20            300000              none

*** Keywords ***
ena01
    [Arguments]    ${supplier_code}    ${dict_pr_num}    ${list_newprice}    ${input_ggpn}    ${input_datrancc}    ${list_num_edit}
    ...    ${list_newprice_edit}    ${list_discount_edit}    ${input_nh_discount_edit}    ${input_tientrancc}    ${supplier_code_edit}
    ${list_pr}    Get Dictionary Keys    ${dict_pr_num}
    ${list_num}    Get Dictionary Values    ${dict_pr_num}
    #
    Log    get dvcb cua sp
    ${list_pr_cb}    Get list code basic of product unit    ${list_pr}
    ${get_list_status}    Get list imei status thr API    ${list_pr}
    #
    Log    get tong no, tong mua cua nha cung cap truoc khi nhap hang cua ncc edit
    ${result_supplier_code}    Set Variable If    '${supplier_code_edit}'=='none'    ${supplier_code}    ${supplier_code_edit}
    ${get_no_ncc_hientai}    ${get_tong_mua}    ${get_tong_mua_tru_tra_hang}    Get Supplier Debt from API    ${result_supplier_code}
    #
    Log    tinh tong can tra ncc
    ${list_result_thanhtien_af}    ${list_result_newprice_af}    ${list_result_onhand_cb_af}    ${list_dongia}    ${list_result_onhand_actual_af}    ${list_actual_num_cb}    ${list_result_newprice_cb_af}
    ...    ${list_result_newprice_bf}    ${list_result_discount_vnd}    Get list of total purchase receipt - result onhand actual product in case of price change and have discount    ${list_pr_cb}    ${list_pr}    ${list_num_edit}
    ...    ${list_newprice_edit}    ${list_discount_edit}
    ${result_tongtienhang}    Sum values in list    ${list_result_thanhtien_af}
    #
    ${result_discount_nh}    Run Keyword If    0 < ${input_nh_discount_edit} < 100    Convert % discount to VND and round    ${result_tongtienhang}    ${input_nh_discount_edit}
    ...    ELSE    Set Variable    ${input_nh_discount_edit}
    ${result_cantrancc}    Minus    ${result_tongtienhang}    ${result_discount_nh}
    ${actual_tientrancc}    Set Variable If    '${input_tientrancc}'=='all'    ${result_cantrancc}    ${input_tientrancc}
    ${actual_tientrancc}    Run Keyword If    '${input_tientrancc}'=='all'    Replace floating point    ${actual_tientrancc}
    ...    ELSE    Set Variable    ${input_tientrancc}
    #
    Log    tinh toan gia von sau khi nhap hang
    ${list_cost_cb_af_ex}    Computation list of cost incase purchase order have discount and price change    ${list_pr_cb}    ${list_result_newprice_cb_af}    ${list_actual_num_cb}    ${result_discount_nh}    ${result_tongtienhang}
    #
    Log    tinh tong no, tong mua cua ncc sau khi nhap hang
    ${result_no_phieunhap}    Minus    ${result_cantrancc}    ${actual_tientrancc}
    ${result_no_ncc}    sum    ${get_no_ncc_hientai}    ${result_no_phieunhap}
    ${result_no_ncc}    Minus    0    ${result_no_ncc}
    ${result_tongmua}    sum    ${result_cantrancc}    ${get_tong_mua}
    ${result_tongmua_tru_tranghag}    sum    ${result_cantrancc}    ${get_tong_mua_tru_tra_hang}
    #
    Log    ttao phieu nhap qua api
    ${receipt_code}    Add new purchase receipt thr API    ${supplier_code}    ${dict_pr_num}    ${list_newprice}    ${input_ggpn}    ${input_datrancc}
    #
    Log    tao phieu qua API
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${get_id_ncc}    Get Supplier Id    ${result_supplier_code}
    ${get_id_ncc_bf}    Get Supplier Id    ${supplier_code}
    ${get_id_pn}    Get purchase receipt id thr API    ${receipt_code}
    ${get_list_prs_id}    Get list product id thr API    ${list_pr}
    ${liststring_prs_order_detail}    Set Variable    needdel
    : FOR    ${item_pr}    ${item_pr_id}    ${item_newprice}    ${item_num}    ${item_giamgia}    ${item_price_af_discount}
    ...    ${item_status}    ${item_list_imei}    IN ZIP    ${list_pr}    ${get_list_prs_id}    ${list_newprice_edit}
    ...    ${list_num_edit}    ${list_discount_edit}    ${list_result_newprice_af}    ${get_list_status}    ${list_imei_all}
    \    ${discount_type}    Set Variable If    ${item_giamgia}>100    null    ${item_giamgia}
    \    ${discount_vnd}    Run Keyword If    ${item_giamgia}>100    Set variable    ${item_giamgia}
    \    ...    ELSE    Convert % discount to VND    ${item_newprice}    ${item_giamgia}
    \    ${discount_vnd}      Evaluate    round(${discount_vnd},2)
    \    ${result_alocation}    Price after apllocate discount    ${item_price_af_discount}    ${result_tongtienhang}    ${result_discount_nh}
    \    ${payload_each_product}    Format string    {{"Unit":"","ListProductUnit":[],"Units":[],"SelectedUnit":{0},"ShowUnit":false,"OnOrder":0,"Shelves":"","IsTrans":false,"ProductName":"chuột quang hồng","ProductCode":"NS01","ReturnQuantity":0,"SubTotal":270000,"OrderQuantity":0,"CategoryTree":"Thiết bị số - Phụ kiện số","ProductShelvesStr":"","Reserved":0,"OnHand":151,"ConversionValue":1,"ProductSName":"chuột quang hồng","Id":7616892,"PurchaseId":0,"ProductId":{0},"Quantity":{1},"Price":{2},"Discount":{3},"CreatedDate":"","Description":"","SerialNumbers":"{5}","DiscountRatio":{4},"Allocation":{6},"OrderByNumber":0,"AllocationSuppliers":0,"AllocationThirdParty":0,"Product":{{"TradeMarkName":"","Id":{0},"Code":"NS01","Name":"chuột quang hồng","CategoryId":173814,"AllowsSale":true,"BasePrice":300000,"Tax":0,"RetailerId":{7},"isActive":true,"CreatedDate":"","ProductType":2,"HasVariants":false,"Unit":"","ConversionValue":1,"OrderTemplate":"","FullName":"chuột quang hồng","IsLotSerialControl":true,"IsRewardPoint":false,"isDeleted":false,"MasterCode":"SPC001818","Revision":"AAAAAAmfZW0=","Formula":[],"ProductImages":[],"PurchaseReturnDetails":[],"ProductChild":[],"ProductAttributes":[],"ProductChildUnit":[],"PriceBookDetails":[],"ProductBranches":[],"TableAndRooms":[],"Manufacturings":[],"ManufacturingDetails":[],"DamageDetails":[],"ProductSerials":[],"ProductFormulaHistories":[],"OrderSupplierDetails":[],"ProductShelves":[],"PrescriptionDetails":[],"ProductShelvesStr":"","OnHand":151,"Reserved":0}},"TotalValue":297500,"tabIndex":100,"ViewIndex":1,"tags":[],"DiscountValue":0,"DiscountType":"VND","adjustedPrice":{2},"priceAfterDiscount":{8},"OriginPrice":{2}}}    ${item_pr_id}    ${item_num}    ${item_newprice}
    \    ...    ${discount_vnd}    ${discount_type}     ${item_list_imei}    ${result_alocation}    ${get_id_nguoitao}    ${item_price_af_discount}
    \    ${liststring_prs_order_detail}    Catenate    SEPARATOR=,    ${liststring_prs_order_detail}    ${payload_each_product}
    Log    ${liststring_prs_order_detail}
    ${liststring_prs_order_detail}    Replace String    ${liststring_prs_order_detail}    needdel,    ${EMPTY}    count=1
    #
    ${result_ggpn_type}    Set Variable If    ${input_nh_discount_edit}>100    null    ${input_nh_discount_edit}
    ${request_payload}    Format String    {{"PurchaseOrder":{{"Code":"{0}","PurchaseOrderDetails":[{1}],"UserId":{2},"CompareUserId":{2},"User":{{"CompareGivenName":"admin","CompareIsLimitedByTrans":false,"CompareIsShowSumRow":true,"CompareUserName":"admin","Id":{2},"Email":"","GivenName":"admin","CreatedDate":"","IsActive":true,"IsAdmin":true,"RetailerId":437336,"UserName":"admin","Type":0,"CreatedBy":0,"CanAccessAnySite":false,"Language":"vi-VN","LocationName":"","WardName":"","isDeleted":false,"Permissions":[],"Apps":[],"Invoices":[],"Transfers1":[],"PriceBookUsers":[],"CashFlows":[],"Invoices1":[],"Orders":[],"Returns1":[],"Manufacturings":[],"DamageItems":[],"TokenApis":[],"SmsEmailTemplates":[],"BalanceAdjustments1":[],"PointAdjustments":[],"PointAdjustmentsCreatedBy":[],"NotificationSettings":[],"DamageItems1":[],"PurchaseOrders1":[],"PurchaseReturns1":[],"CostAdjustments":[],"Devices":[],"OrderSuppliers":[],"OrderSuppliers1":[]}},"CreatedDate":"","PurchaseDate":"","ComparePurchaseDate":"","Description":"","Supplier":{{"TotalInvoiced":0,"CompareCode":"NCC0027","CompareName":"NCC Thu Hương","ComparePhone":"977654899","Id":{3},"Name":"NCC Thu Hương","Phone":"977654899","RetailerId":{4},"Code":"NCC0027","CreatedDate":"","CreatedBy":{2},"Debt":0,"LocationName":"","WardName":"","BranchId":{5},"isDeleted":false,"isActive":true,"SearchNumber":"977654899","PurchaseOrders":[],"PurchaseReturns":[],"PurchasePayments":[],"SupplierGroupDetails":[],"OrderSuppliers":[]}},"SupplierId":{3},"CompareSupplierId":{6},"SubTotal":{7},"Branch":{{"Id":{5},"Name":"Chi nhánh trung tâm","Type":0,"Address":"abc","Province":"Hà Nội","District":"Quận Cầu Giấy","IsActive":true,"RetailerId":{4},"CreatedBy":0,"LimitAccess":false,"LocationName":"Hà Nội - Quận Cầu Giấy","isAcceptBookClosing":false,"GmbStatus":1,"Orders":[],"Transfers1":[],"DamageItems":[],"SurchargeBranches":[],"AdrApplications":[],"Customers":[],"Suppliers":[],"ExpensesOtherBranches":[],"OrderSuppliers":[],"WarrantyBranchGroups":[],"BranchTakingAddresses":[],"TotalUser":0,"CompareBranchName":"Chi nhánh trung tâm","StatusGmbValue":"Chưa đăng ký"}},"Status":3,"StatusValue":"Đã nhập hàng","CompareStatusValue":"Đã nhập hàng","Discount":{8},"CompareDiscount":{9},"DiscountRatio":{10},"Id":0,"UpdatePurchaseId":{11},"Account":{{}},"Total":{12},"TotalQuantity":2,"ExpensesOthersTitle":"","ExpensesOthersRtpTitle":"","PurchaseOrderExpensesOthers":[],"PurchaseOrderExpensesOthersRs":[],"PurchaseOrderExpensesOthersRtp":[],"ExReturnSuppliers":0,"ExReturnThirdParty":0,"PaidAmount":0,"PayingAmount":{13},"ChangeAmount":-67750,"paymentMethod":"","BalanceDue":267750,"DepositReturn":267750,"OriginTotal":267750,"PricebookDetail":[],"paymentMethodObj":null,"paymentReturnType":0,"PurchasePayments":[{{"Amount":{13},"Method":"Cash"}}],"BranchId":{5}}},"PurchaseOrderLargeData":null,"Complete":true,"CopyFrom":0,"PricebookDetail":[],"IsFinalizedOS":false}}    ${receipt_code}    ${liststring_prs_order_detail}    ${get_id_nguoiban}    ${get_id_ncc}
    ...    ${get_id_nguoiban}    ${BRANCH_ID}    ${get_id_ncc_bf}    ${result_tongtienhang}    ${result_discount_nh}    ${input_ggpn}
    ...    ${result_ggpn_type}    ${get_id_pn}    ${result_cantrancc}    ${actual_tientrancc}
    Log    ${request_payload}
    Post request thr API    /purchaseOrders   ${request_payload}
    Sleep    10s    wait for response to API
    #
    Log    validate thong tin tren phieu nhap
    ${result_tongsoluong}    Sum values in list    ${list_num_edit}
    ${get_supplier_code}    ${get_tongtienhang}    ${get_tiendatra_ncc}    ${get_giamgia_pn}    ${get_tongcong}    ${get_tongsoluong}    ${get_trangthai}
    ...    Get purchase receipt info incase discount by purchase receipt code    ${receipt_code}
    Should Be Equal As Strings    ${get_supplier_code}    ${result_supplier_code}
    Should Be Equal As Numbers    ${get_tongtienhang}    ${result_tongtienhang}
    Should Be Equal As Numbers    ${get_tiendatra_ncc}    ${actual_tientrancc}
    Should Be Equal As Numbers    ${get_tongsoluong}    ${result_tongsoluong}
    Should Be Equal As Numbers    ${get_tongcong}    ${result_cantrancc}
    Should Be Equal As Numbers    ${get_giamgia_pn}    ${result_discount_nh}
    Should Be Equal As Strings    ${get_trangthai}    Đã nhập hàng
    #
    Log    validate the kho, so quy
    : FOR    ${item_product}    ${item_onhand_af_ex}    ${item_num_cb}    ${item_status}    ${item_imei}    IN ZIP
    ...    ${list_pr_cb}    ${list_result_onhand_cb_af}    ${list_actual_num_cb}    ${get_list_status}    ${list_imei_all}
    \    ${item_imei}    Run Keyword If    '${item_status}'=='True'    Convert string to list    ${item_imei}
    \    ...    ELSE    Set Variable    ${item_imei}
    \    Wait Until Keyword Succeeds    3 times    30s    Assert values in Stock Card    ${receipt_code}    ${item_product}
    \    ...    ${item_onhand_af_ex}    ${item_num_cb}
    \    Run Keyword If    '${item_status}'=='True'    Wait Until Keyword Succeeds    3 times    30s    Assert imei avaiable in SerialImei tab
    \    ...    ${item_product}    ${item_imei}
    ${nav_tientra_ncc}=    Catenate    -    ${actual_tientrancc}
    ${get_ma_pn_soquy}    Get Ma Phieu Chi in So quy    ${receipt_code}
    Run Keyword If    '${actual_tientrancc}' == '0'    Validate So quy info from Rest API if Invoice is not paid    ${receipt_code}
    ...    ELSE    Validate So quy info from Rest API if Invoice is paid    ${get_ma_pn_soquy}    ${nav_tientra_ncc}
    #
    Log    validate in tab no can tra ncc
    Run Keyword If    '${actual_tientrancc}'=='0'    Validate status in Tab No can tra NCC if purchase order is not paid until success    ${result_supplier_code}    ${receipt_code}
    ...    ELSE    Validate status in Tab No can tra NCC if purchase order is paid until success    ${result_supplier_code}    ${get_ma_pn_soquy}    ${receipt_code}
    Assert ma phieu nhap is avaliable in Tab No can tra NCC and Lich su nhap/tra hang    ${result_supplier_code}    ${receipt_code}
    #
    Log    validate tổng nợ, tổng mua
    ${get_no_af_purchase}    ${get_tongmua_af_purchase}    ${get_tongmua_tru_trahang_af_purchase}    Get Supplier Debt from API after purchase    ${result_supplier_code}    ${receipt_code}    ${actual_tientrancc}
    Should Be Equal As Numbers    ${get_no_af_purchase}    ${result_no_ncc}
    Should Be Equal As Numbers    ${get_tongmua_af_purchase}    ${result_tongmua}
    Should Be Equal As Numbers    ${get_tongmua_tru_trahang_af_purchase}    ${result_tongmua_tru_tranghag}
    #
    Log    validate gia von
    Wait Until Keyword Succeeds    3 times    30s    Assert list of onhand, cost af receipt    ${list_pr_cb}    ${list_result_onhand_cb_af}    ${list_cost_cb_af_ex}
    #
    Log    valdate phieu nhap con trong ncc cu
    Run Keyword If    '${supplier_code_edit}'=='none'    Log    Ignore ncc
    ...    ELSE    Assert ma phieu nhap is not avaliable in Tab No can tra NCC and Lich su nhap/tra hang    ${supplier_code}    ${receipt_code}
    Delete purchase receipt code    ${receipt_code}
