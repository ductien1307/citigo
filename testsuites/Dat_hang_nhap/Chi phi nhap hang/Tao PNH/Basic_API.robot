*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}      ${headless_browser}
Library           Collections
Resource          ../../../../core/hang_hoa/hang_hoa_navigation.robot
Resource          ../../../../core/share/computation.robot
Resource          ../../../../core/Giao_dich/dat_hang_nhap_add_action.robot
Resource          ../../../../core/Giao_dich/dat_hang_nhap_list_action.robot
Resource          ../../../../core/Giao_dich/giaodich_nav.robot
Resource          ../../../../core/API/api_danhmuc_hanghoa.robot
Resource          ../../../../core/Doi_Tac/doitac_navigation.robot
Resource          ../../../../core/Doi_Tac/ncc_list_action.robot
Resource          ../../../../core/So_Quy/so_quy_list_action.robot
Resource          ../../../../core/share/toast_message.robot
Resource          ../../../../core/API/api_nha_cung_cap.robot
Resource          ../../../../core/API/api_dathangnhap.robot
Resource          ../../../../core/API/api_soquy.robot
Resource          ../../../../core/Giao_dich/nhaphang_getandcompute.robot
Resource          ../../../../core/Giao_dich/nhap_hang_add_action.robot

*** Variables ***
&{dict_pr}        DNT019=11.4    DNT020=7.6    DNQD011=9    DNS002=3    DNS003=4
&{dict_giamoi}    DNT019=85000.84    DNT020=89000.63    DNQD011=70000    DNS002=112000    DNS003=55000
&{dict_gg}        DNT019=15    DNT020=0    DNQD011=10000.25    DNS002=25000    DNS003=5
&{dict_type}      DNT019=15    DNT020=0    DNQD011=null    DNS002=null    DNS003=5
@{list_pr_del}    DNT020    DNS003
&{dict_pr_edit}    DNT019=3    DNQD011=6.2      DNS002=3
&{dict_pr1}        DNQD108=5    DNS018=2    DNT018=7.5
&{dict_giamoi1}    DNQD108=75000.6    DNS018=95000.63    DNT018=70000
&{dict_gg1}        DNQD108=10    DNS018=15000.25    DNT018=0
&{dict_type1}      DNQD108=10    DNS018=null    DNT018=0
@{CPNH}           CPNH3    CPNH8
@{CPNHK}          CPNH11    CPNH16
@{CPNH1}          CPNH2    CPNH5
@{CPNHK1}         CPNH10    CPNH14

*** Test Cases ***
Phieu tam
    [Documentation]    Phiếu tạm - ko thanh toán
    [Tags]    EDNCA2
    [Template]    Add new purchase order no payment thr API
    NCC0006    ${dict_pr}    ${dict_giamoi}    ${dict_gg}    ${dict_type}    20

Da xac nhan
    [Documentation]    Đã xác nhận - thanh toán
    [Tags]    EDNCA2
    [Template]    Add new purchase order Da xac nhan NCC have payment thr API
    NCC0007    ${dict_pr1}    ${dict_giamoi1}    ${dict_gg1}    ${dict_type1}   30000    250000

Lấy 1 phan đơn hang
    [Documentation]    Tạo PN từ phiếu dhn tạm - ko thanh toán - lấy 1 phần đơn hàng
    [Tags]    EDNCA2
    [Template]    dhnca03
    NCC0006    ${list_pr_del}    ${dict_pr_edit}    all          ${CPNH}    ${CPNHK}

Lay all don hang
    [Documentation]    Tạo PN từ phiếu dhn tạm - có thanh toán - lấy all đơn hàng
    [Tags]    EDNCA2
    [Template]    dhnca04
    NCC0007    all    ${CPNH1}    ${CPNHK1}

*** Keywords ***
dhnca03
    [Arguments]    ${ma_ncc}    ${list_del}    ${dict_edit}    ${input_tientrancc}    ${list_cpnh}    ${list_cpnhk}
    [Documentation]    Tạo PN từ phiếu dhn tạm - ko thanh toán - lấy 1 phần đơn hàng - CPNH ko tự động
    Log    Get thong tin pheu dhn - ncc
    ${ma_phieu_dat}    Get first purchase order code frm API    ${ma_ncc}
    ${get_soluong}    ${get_tongtienhang}    ${get_giamga_vnd}    ${get_giamgia_%}    ${get_datrancc}    ${get_cantrancc}    Get purchase order summary thr api
    ...    ${ma_phieu_dat}
    ${get_no_ncc_hientai}    ${get_tong_mua}    ${get_tong_mua_tru_tra_hang}    Get Supplier Debt from API    ${ma_ncc}
    Log    Get list sp edit, xoa
    ${list_prs_edit}    Get Dictionary Keys    ${dict_edit}
    ${list_nums_edit}    Get Dictionary Values    ${dict_edit}
    Log    Bật cpnh và get giá trị cpnh
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
    ${list_other_charge_value}    Create List
    : FOR    ${item_cpnhk}    IN ZIP    ${list_cpnhk}
    \    ${other_charge_vnd}    Get expense VND value    ${item_cpnhk}
    \    ${other_charge_%}    Get expense percentage value    ${item_cpnhk}
    \    ${other_charge_value}    Set Variable If    ${other_charge_%}==0    ${other_charge_vnd}    ${other_charge_%}
    \    Run Keyword If    ${other_charge_value}>100    Toggle other charge VND    ${item_cpnhk}    true
    \    ...    ELSE    Toggle other charge %    ${item_cpnhk}    true
    \    Append To List    ${list_other_charge_value}    ${other_charge_value}
    Log    ${list_other_charge_value}
    Log    Get imei infor
    ${get_list_imei_status}    Get list imei status thr API    ${list_prs_edit}
    ${list_price_af_discount}    ${list_nums_order}    ${list_thanhtien}    ${list_price_bf_discount}    ${list_disvnd}    ${list_dis%}    Get list product detail in purchase order detail frm API
    ...    ${ma_phieu_dat}    ${list_prs_edit}
    ${list_price_af_discount_del}    ${list_num_del}    ${list_thanhtien_del}    Get list infor in purchase order detail frm API    ${ma_phieu_dat}    ${list_del}
    Log    Tính tổng tiền hàng
    ${list_thanhtien_edit_af}    Create List
    : FOR    ${item_num}    ${item_price}    IN ZIP    ${list_nums_edit}    ${list_price_af_discount}
    \    ${thanhtien_edit}    Multiplication and round    ${item_num}    ${item_price}
    \    Append To List    ${list_thanhtien_edit_af}    ${thanhtien_edit}
    Log    ${list_thanhtien_edit_af}
    ${result_tongtienhang}    Sum values in list    ${list_thanhtien_edit_af}
    ${result_giamgia}    Run Keyword If    0<${get_giamgia_%}<=100    Convert % discount to VND and round    ${get_giamgia_%}    ${result_tongtienhang}
    ...    ELSE    Set Variable    ${get_giamga_vnd}
    ${result_tongtien_tru_gg}    Minus    ${result_tongtienhang}    ${result_giamgia}
    Log    Tính tổng cpnh
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
    ${list_other_charge_value_vnd}    Create List
    : FOR    ${item_other_charge}    IN ZIP    ${list_other_charge_value}
    \    ${item_other_charge}=    Run Keyword If    ${item_other_charge}>100    Set Variable    ${item_other_charge}
    \    ...    ELSE    Convert % discount to VND and round    ${item_other_charge}    ${result_tongtien_tru_gg}
    \    ${item_other_charge}    Replace floating point    ${item_other_charge}
    \    Append To List    ${list_other_charge_value_vnd}    ${item_other_charge}
    Log    ${list_other_charge_value_vnd}
    ${total_other_charge}    Sum values in list    ${list_other_charge_value_vnd}
    ${total_expense_value}    Sum    ${total_supplier_charge}    ${total_other_charge}
    #
    ${total_num}    Sum values in list and not round    ${list_nums_edit}
    Log    Get list sp cơ bản, tính toán giá vốn, tồn kho
    ${list_prs_cb}    Get list code basic of product unit    ${list_prs_edit}
    ${list_price_cb}    ${list_num_cb}    Computation list price and num of basic product    ${list_prs_cb}    ${list_price_af_discount}    ${list_nums_edit}
    #
    Log    Tinh toan gia von, sd dat nhap
    ${list_cost_af}    Computation list of cost incase purchase order have discount, price change and have expense    ${list_prs_cb}    ${list_price_cb}    ${list_num_cb}    ${result_giamgia}    ${result_tongtienhang}
    ...    ${total_expense_value}
    ${list_onhand_af}    Get list onhand after purchase receipt    ${list_prs_cb}    ${list_num_cb}
    #
    ${get_list_on_order_af}    Computation list on order after purchase receipt frm draft    ${list_prs_edit}    ${list_nums_order}    ${list_nums_edit}
    ${get_list_on_order_del_af}    Computation list on order after Da xac nhan NCC    ${list_del}    ${list_num_del}
    #
    Log    tinh can tra ncc, tong no
    ${result_cantrancc_af}    Sum    ${result_tongtien_tru_gg}    ${total_supplier_charge}
    ${actual_tientrancc}    Set Variable If    '${input_tientrancc}'=='all'    ${result_cantrancc_af}    ${input_tientrancc}
    ${actual_tientrancc}    Run Keyword If    '${input_tientrancc}'=='all'    Replace floating point    ${actual_tientrancc}
    ...    ELSE    Set Variable    ${input_tientrancc}
    ${actual_tientrancc}    Set Variable If    ${actual_tientrancc}<0    0    ${actual_tientrancc}
    ${sum_tientrancc}    Sum    ${get_datrancc}    ${actual_tientrancc}
    #
    ${result_no_phieunhap}    Minus    ${result_cantrancc_af}    ${actual_tientrancc}
    ${result_no_ncc}    sum    ${get_no_ncc_hientai}    ${result_no_phieunhap}
    ${result_tongmua}    sum    ${result_cantrancc_af}    ${get_tong_mua}
    ${result_tongmua_tru_trahang}    sum    ${result_cantrancc_af}    ${get_tong_mua_tru_tra_hang}
    #
    Log    tao phieu qua API
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${get_id_ncc}    Get Supplier Id    ${ma_ncc}
    ${get_list_prs_id}    Get list product id thr API    ${list_prs_edit}
    ${get_purchase_order_id}    Get purchase order id frm API    ${ma_phieu_dat}
    ${list_order_detail_id}    Get list product order id frm purchase order detail api    ${ma_phieu_dat}    ${get_list_prs_id}
    ${list_imei_all}    Create List
    ${liststring_prs_order_detail}    Set Variable    needdel
    : FOR    ${item_pr}    ${item_pr_id}    ${item_status}    ${item_price_bf_discount}    ${item_num_order}    ${item_num_edit}
    ...    ${item_disvnd}    ${item_dis%}    ${item_pr_order_id}    IN ZIP    ${list_prs_edit}    ${get_list_prs_id}
    ...    ${get_list_imei_status}    ${list_price_bf_discount}    ${list_nums_order}    ${list_nums_edit}    ${list_disvnd}    ${list_dis%}
    ...    ${list_order_detail_id}
    \    ${discount_type}    Set Variable If    ${item_dis%}==0    null    ${item_disvnd}
    \    ${list_imei}    Run Keyword If    '${item_status}'=='True'    Create list imei by generating random    ${item_num_edit}
    \    ...    ELSE    Set Variable    ${EMPTY}
    \    ${list_imei}    Run Keyword If    '${item_status}'=='True'    Convert List to String    ${list_imei}
    \    ...    ELSE    Set Variable    ${EMPTY}
    \    Append To List    ${list_imei_all}    ${list_imei}
    \    ${payload_each_product}    Format string    {{"Unit":"","ListProductUnit":[],"Units":[],"SelectedUnit":8296366,"ShowUnit":false,"Shelves":"","Id":{0},"OrderSupplierId":{1},"ProductId":{2},"Quantity":{3},"Price":{4},"Discount":{5},"Allocation":10450,"CreatedDate":"","Description":"","DiscountRatio":{6},"OrderByNumber":0,"AllocationSuppliers":40040,"AllocationThirdParty":17950,"OrderQuantity":{7},"Product":{{"Id":{2},"Code":"{8}","Name":"chuột quang xám","CategoryId":173814,"AllowsSale":true,"BasePrice":289.68,"Tax":0,"RetailerId":{9},"isActive":true,"CreatedDate":"","ProductType":2,"HasVariants":false,"Unit":"","ConversionValue":1,"OrderTemplate":"","FullName":"chuột quang xám","IsLotSerialControl":true,"IsRewardPoint":false,"isDeleted":false,"MasterCode":"SPC001784","Revision":"AAAAAAfuux8=","Formula":[],"ProductImages":[],"PurchaseReturnDetails":[],"ProductChild":[],"ProductAttributes":[],"ProductChildUnit":[],"PriceBookDetails":[],"ProductBranches":[],"TableAndRooms":[],"Manufacturings":[],"ManufacturingDetails":[],"DamageDetails":[],"ProductSerials":[],"ProductFormulaHistories":[],"OrderSupplierDetails":[],"ProductShelves":[],"PrescriptionDetails":[],"OnHand":128,"Reserved":0}},"ProductName":"chuột quang xám","ProductCode":"{8}","SubTotal":209000,"Reserved":0,"OnHand":128,"OnOrder":16,"tabIndex":100,"ViewIndex":1,"TotalValue":null,"allSuggestSerial":[],"SerialNumbers":"{10}"}}    ${item_pr_order_id}    ${get_purchase_order_id}    ${item_pr_id}
    \    ...    ${item_num_edit}    ${item_price_bf_discount}    ${item_disvnd}    ${item_dis%}    ${item_num_order}
    \    ...    ${item_pr}    ${get_id_nguoitao}    ${list_imei}
    \    ${liststring_prs_order_detail}    Catenate    SEPARATOR=,    ${liststring_prs_order_detail}    ${payload_each_product}
    Log    ${liststring_prs_order_detail}
    ${liststring_prs_order_detail}    Replace String    ${liststring_prs_order_detail}    needdel,    ${EMPTY}    count=1
    Log    ${list_imei_all}
    #
    ${ma_phieu_nhap}    Generate code automatically    PN
    ${get_list_cpnh_id}    Get list expenses id    ${list_cpnh}
    ${get_list_cpnhk_id}    Get list expenses id    ${list_cpnhk}
    ${liststring_cpnh}    Set Variable    needdel
    : FOR    ${item_cpnh}    ${item_cpnh_id}    ${item_giatri}    IN ZIP    ${list_cpnh}    ${get_list_cpnh_id}
    ...    ${list_supplier_charge_value_vnd}
    \    ${payload_cpnh}    Format String    {{"ExpensesOtherId":{0},"Id":{0},"ExValue":{1},"Price":{1},"Name":"Phí nhập 3","Code":"{2}","Form":0}}    ${item_cpnh_id}    ${item_giatri}    ${item_cpnh}
    \    ${liststring_cpnh}    Catenate    SEPARATOR=,    ${liststring_cpnh}    ${payload_cpnh}
    Log    ${liststring_cpnh}
    ${liststring_cpnh}    Replace String    ${liststring_cpnh}    needdel,    ${EMPTY}    count=1
    #
    ${liststring_cpnhk}    Set Variable    needdel
    : FOR    ${item_cpnhk}    ${item_cpnhk_id}    ${item_giatri}    IN ZIP    ${list_cpnhk}    ${get_list_cpnhk_id}
    ...    ${list_other_charge_value_vnd}
    \    ${payload_cpnhk}    Format String    {{"ExpensesOtherId":{0},"Id":{0},"ExValue":{1},"Price":{1},"Name":"Phí nhập 3","Code":"{2}","Form":1}}    ${item_cpnhk_id}    ${item_giatri}    ${item_cpnhk}
    \    ${liststring_cpnhk}    Catenate    SEPARATOR=,    ${liststring_cpnhk}    ${payload_cpnhk}
    Log    ${liststring_cpnhk}
    ${liststring_cpnhk}    Replace String    ${liststring_cpnhk}    needdel,    ${EMPTY}    count=1
    ${liststring_all_cpnh}    Catenate    SEPARATOR=,    ${liststring_cpnh}    ${liststring_cpnhk}
    Log    ${liststring_all_cpnh}
    #
    ${result_gg_%}    Set Variable If    0<${get_giamgia_%}<100    ${get_giamgia_%}    null
    ${request_payload}    Format String    {{"PurchaseOrder":{{"Code":"{0}","OrderSupplierCode":"{1}","OrderSupplierId":"{2}","PurchaseOrderDetails":[{3}],"UserId":{4},"CompareUserId":{4},"User":{{"CompareGivenName":"admin","CompareIsLimitedByTrans":false,"CompareIsShowSumRow":true,"CompareUserName":"admin","Id":{4},"Email":"","GivenName":"admin","CreatedDate":"","IsActive":true,"IsAdmin":true,"RetailerId":{5},"UserName":"admin","Type":0,"CreatedBy":0,"CanAccessAnySite":false,"Language":"vi-VN","LocationName":"","WardName":"","isDeleted":false,"Permissions":[],"Apps":[],"Invoices":[],"Transfers1":[],"PriceBookUsers":[],"CashFlows":[],"Invoices1":[],"Orders":[],"Returns1":[],"Manufacturings":[],"DamageItems":[],"TokenApis":[],"SmsEmailTemplates":[],"BalanceAdjustments1":[],"PointAdjustments":[],"PointAdjustmentsCreatedBy":[],"NotificationSettings":[],"DamageItems1":[],"PurchaseOrders1":[],"PurchaseReturns1":[],"CostAdjustments":[],"Devices":[],"OrderSuppliers":[],"OrderSuppliers1":[]}},"CreatedDate":"","Description":"","Supplier":{{"TotalInvoiced":0,"CompareCode":"NCC0025","CompareName":"NCC Thái Bình","ComparePhone":"977654897","Id":{6},"Name":"NCC Thái Bình","Phone":"977654897","RetailerId":{5},"Code":"NCC0025","CreatedDate":"","CreatedBy":{4},"Debt":1420435,"LocationName":"","WardName":"","BranchId":{8},"isDeleted":false,"isActive":true,"SearchNumber":"977654897","PurchaseOrders":[],"PurchaseReturns":[],"PurchasePayments":[],"SupplierGroupDetails":[],"OrderSuppliers":[]}},"SupplierId":{6},"CompareSupplierId":{6},"SubTotal":{7},"Branch":{{"Id":{8},"Name":"Chi nhánh trung tâm","Type":0,"Address":"abc","Province":"Hà Nội","District":"Quận Cầu Giấy","IsActive":true,"RetailerId":{5},"CreatedBy":0,"LimitAccess":false,"LocationName":"Hà Nội - Quận Cầu Giấy","isAcceptBookClosing":false,"GmbStatus":1,"Orders":[],"Transfers1":[],"DamageItems":[],"SurchargeBranches":[],"AdrApplications":[],"Customers":[],"Suppliers":[],"ExpensesOtherBranches":[],"OrderSuppliers":[],"WarrantyBranchGroups":[],"BranchTakingAddresses":[],"TotalUser":0,"CompareBranchName":"Chi nhánh trung tâm","StatusGmbValue":"Chưa đăng ký"}},"Status":1,"StatusValue":"Phiếu tạm","CompareStatusValue":"Phiếu tạm","Discount":{9},"CompareDiscount":502012,"DiscountRatio":{10},"Id":0,"UpdatePurchaseId":0,"Account":{{}},"Total":{11},"TotalQuantity":{12},"ExpensesOthersTitle":"Phí nhập 3, Phí nhập 8","ExpensesOthersRtpTitle":"Phí nhập 11, Phí nhập 16","PurchaseOrderExpensesOthers":[{13}],"PurchaseOrderExpensesOthersRs":[{14}],"PurchaseOrderExpensesOthersRtp":[{15}],"ExReturnSuppliers":{16},"ExReturnThirdParty":{17},"PaidAmount":0,"PayingAmount":{18},"ChangeAmount":-198763,"paymentMethod":"","BalanceDue":698763,"DepositReturn":698763,"OriginTotal":495202,"PricebookDetail":[],"paymentMethodObj":null,"paymentReturnType":0,"PurchasePayments":[{{"Amount":{18},"Method":"Cash"}}],"BranchId":{8}}},"PurchaseOrderLargeData":null,"Complete":true,"CopyFrom":0,"PricebookDetail":[],"IsFinalizedOS":false}}    ${ma_phieu_nhap}    ${ma_phieu_dat}    ${get_purchase_order_id}    ${liststring_prs_order_detail}
    ...    ${get_id_nguoiban}    ${get_id_nguoitao}    ${get_id_ncc}    ${result_tongtienhang}    ${BRANCH_ID}    ${result_giamgia}
    ...    ${result_gg_%}    ${result_cantrancc_af}    ${total_num}    ${liststring_all_cpnh}    ${liststring_cpnh}    ${liststring_cpnhk}
    ...    ${total_supplier_charge}    ${total_other_charge}    ${actual_tientrancc}
    Log    ${request_payload}
    ${headers}=    Create Dictionary    Authorization=${bearertoken}    Content-Type=application/json;charset=UTF-8    Retailer=${RETAILER_NAME}    BranchId=${BRANCH_ID}    Zone=${env}
    Create Session    lolo    ${API_URL}    cookies=${resp.cookies}    verify=True    debug=1
    ${resp}=    Post Request    lolo    /purchaseOrders    data=${request_payload}    headers=${headers}
    Log    ${resp.request.body}
    Log    ${resp.json()}
    Log    ${resp.status_code}
    Should Be Equal As Strings    ${resp.status_code}    200
    Sleep    10s    wait for response to API
    #
    Log    Tắt cpnh
    : FOR    ${item_cpnh}    ${item_sp_charge_value}    IN ZIP    ${list_cpnh}    ${list_supplier_charge_value}
    \    Run Keyword If    ${item_sp_charge_value}>100    Toggle supplier's charge VND    ${item_cpnh}    false
    \    ...    ELSE    Toggle supplier's charge %    ${item_cpnh}    false
    : FOR    ${item_cpnhk}    ${item_other_charge_value}    IN ZIP    ${list_cpnhk}    ${list_other_charge_value}
    \    Run Keyword If    ${item_other_charge_value}>100    Toggle other charge VND    ${item_cpnhk}    false
    \    ...    ELSE    Toggle other charge %    ${item_cpnhk}    false
    Log    validate thông tin
    Log    validate thong tin tren phieu dat nhap
    ${get_supplier_code_dh}    ${get_tongtienhang_dh}    ${get_tiendatra_ncc_dh}    ${get_giamgia_pn_dh}    ${get_tongcong_dh}    ${get_tongsoluong_dh}    ${get_trangthai_dh}
    ...    Get purchase order info by purchase order code    ${ma_phieu_dat}
    Should Be Equal As Strings    ${get_supplier_code_dh}    ${ma_ncc}
    Should Be Equal As Numbers    ${get_tongtienhang_dh}    ${get_tongtienhang}
    Should Be Equal As Numbers    ${get_tiendatra_ncc_dh}    ${sum_tientrancc}
    Should Be Equal As Numbers    ${get_tongsoluong_dh}    ${get_soluong}
    Should Be Equal As Numbers    ${get_tongcong_dh}    ${get_cantrancc}
    Should Be Equal As Numbers    ${get_giamgia_pn_dh}    ${get_giamga_vnd}
    Should Be Equal As Strings    ${get_trangthai_dh}    Nhập một phần
    Log    validate in tab lich su dat hang nhap
    ${get_status}    ${get_total}    Get sumary in tab Lich su dat hang nhap    ${ma_ncc}    ${ma_phieu_dat}
    Should Be Equal As Numbers    ${get_status}    2
    Should Be Equal As Numbers    ${get_total}    ${get_cantrancc}
    Log    validate so lượng đã nhập
    ${get_list_order_qty}    Get list order quality in purchase order frm API    ${ma_phieu_dat}    ${list_prs_edit}
    : FOR    ${item_num}    ${item_order_qty}    IN ZIP    ${list_nums_edit}    ${get_list_order_qty}
    \    Should Be Equal As Numbers    ${item_num}    ${item_order_qty}
    #
    Log    validate the kho, so quy
    : FOR    ${item_product}    ${item_onhand_af_ex}    ${item_num}    IN ZIP    ${list_prs_cb}    ${list_onhand_af}
    ...    ${list_num_cb}
    \    Wait Until Keyword Succeeds    3 times    30s    Assert values in Stock Card    ${ma_phieu_nhap}    ${item_product}
    \    ...    ${item_onhand_af_ex}    ${item_num}
    Log    the kho imei
    : FOR    ${item_product}    ${item_num}    ${item_imei}    ${item_status}    IN ZIP    ${list_prs_edit}
    ...    ${list_nums_edit}    ${list_imei_all}    ${get_list_imei_status}
    \    Run Keyword If    '${item_status}'=='[True]'    Assert imei avaiable in SerialImei tab    ${item_product}    ${item_imei}
    \    ...    ELSE    Log    Ignore validate imei
    Log    validate so quy
    ${nav_tientra_ncc}=    Catenate    -    ${actual_tientrancc}
    ${get_ma_pn_soquy}    Get Ma Phieu Chi in So quy    ${ma_phieu_nhap}
    Run Keyword If    '${actual_tientrancc}' == '0'    Validate So quy info from Rest API if Invoice is not paid    ${ma_phieu_nhap}
    ...    ELSE    Validate So quy info from Rest API if Invoice is paid    ${get_ma_pn_soquy}    ${nav_tientra_ncc}
    #
    Log    validate in tab no can tra ncc
    Run Keyword If    '${actual_tientrancc}'=='0'    Validate status in Tab No can tra NCC if purchase order is not paid until success    ${ma_ncc}    ${ma_phieu_nhap}
    ...    ELSE    Validate status in Tab No can tra NCC if purchase order is paid until success    ${ma_ncc}    ${get_ma_pn_soquy}    ${ma_phieu_nhap}
    Assert ma phieu nhap is avaliable in Tab No can tra NCC and Lich su nhap/tra hang    ${ma_ncc}    ${ma_phieu_nhap}
    Log    validate tổng nợ, tổng mua
    ${get_no_af_purchase}    ${get_tongmua_af_purchase}    ${get_tongmua_tru_trahang_af_purchase}    Get Supplier Debt from API    ${ma_ncc}
    Should Be Equal As Numbers    ${get_no_af_purchase}    ${result_no_ncc}
    Should Be Equal As Numbers    ${get_tongmua_af_purchase}    ${result_tongmua}
    Should Be Equal As Numbers    ${get_tongmua_tru_trahang_af_purchase}    ${result_tongmua_tru_trahang}
    Log    validate gia von
    ${list_result_cost_af_ex}    ${list_result_onhand_af_ex}    Get list cost - onhand frm API    ${list_prs_cb}
    : FOR    ${item_pr}    ${item_cost}    ${item_result_cost}    IN ZIP    ${list_prs_cb}    ${list_cost_af}
    ...    ${list_result_cost_af_ex}
    \    ${item_cost_rd}    Evaluate    round(${item_cost},1)
    \    ${item_result_cost_rd}    Evaluate    round(${item_result_cost},1)
    \    Should Be Equal As Numbers    ${item_cost_rd}    ${item_result_cost_rd}
    #
    Validate purchase receipt history frm purchase order    ${ma_phieu_dat}    ${ma_phieu_nhap}
    Log    validate thong tin tren phieu nhap
    ${get_supplier_code_nh}    ${get_tongtienhang_nh}    ${get_tiendatra_ncc_nh}    ${get_giamgia_pn_nh}    ${get_tongcong_nh}    ${get_tongsoluong_nh}    ${get_trangthai_mh}
    ...    Get purchase receipt info incase discount by purchase receipt code    ${ma_phieu_nhap}
    Should Be Equal As Strings    ${get_supplier_code_nh}    ${ma_ncc}
    Should Be Equal As Numbers    ${get_tongtienhang_nh}    ${result_tongtienhang}
    Should Be Equal As Numbers    ${get_tiendatra_ncc_nh}    ${sum_tientrancc}
    Should Be Equal As Numbers    ${get_tongsoluong_nh}    ${total_num}
    Should Be Equal As Numbers    ${get_tongcong_nh}    ${result_cantrancc_af}
    Should Be Equal As Numbers    ${get_giamgia_pn_nh}    ${result_giamgia}
    Should Be Equal As Strings    ${get_trangthai_mh}    Đã nhập hàng
    Log    valdate so luong dat ncc
    ${get_list_on_order_actual_af}    Get list on order frm API    ${list_prs_edit}
    ${get_list_on_order_del_actual_af}    Get list on order frm API    ${list_del}
    : FOR    ${item_on_order}    ${item_on_order_actual}    IN ZIP    ${get_list_on_order_af}    ${get_list_on_order_actual_af}
    \    Should Be Equal As Numbers    ${item_on_order}    ${item_on_order_actual}
    : FOR    ${item_on_order}    ${item_on_order_actual}    IN ZIP    ${get_list_on_order_del_af}    ${get_list_on_order_del_actual_af}
    \    Should Be Equal As Numbers    ${item_on_order}    ${item_on_order_actual}

dhnca04
    [Arguments]    ${ma_ncc}    ${input_tientrancc}    ${list_cpnh}    ${list_cpnhk}
    [Documentation]    Tạo PN từ phiếu dhn tạm - có thanh toán - lấy all đơn hàng - CPNH tự động
    Log    Bat cpnh va get list gia tri
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
    ${list_other_charge_value}    Create List
    : FOR    ${item_cpnhk}    IN ZIP    ${list_cpnhk}
    \    ${other_charge_vnd}    Get expense VND value    ${item_cpnhk}
    \    ${other_charge_%}    Get expense percentage value    ${item_cpnhk}
    \    ${other_charge_value}    Set Variable If    ${other_charge_%}==0    ${other_charge_vnd}    ${other_charge_%}
    \    Run Keyword If    ${other_charge_value}>100    Toggle other charge VND    ${item_cpnhk}    true
    \    ...    ELSE    Toggle other charge %    ${item_cpnhk}    true
    \    Append To List    ${list_other_charge_value}    ${other_charge_value}
    Log    ${list_other_charge_value}
    #
    Log    Get thong tin phieu dat nhap
    ${ma_phieu_dat}    Get first purchase order code frm API    ${ma_ncc}
    ${get_soluong}    ${get_tongtienhang}    ${get_giamgia_vnd}    ${get_giamgia_%}    ${get_datrancc}    ${get_cantrancc}    Get purchase order summary thr api
    ...    ${ma_phieu_dat}
    ${get_list_prs}    Get list product in purchase order frm API    ${ma_phieu_dat}
    ${get_list_imei_status}    Get list imei status thr API    ${get_list_prs}
    ${list_price_af_discount}    ${list_num}    ${list_thanhtien}    ${list_price_bf_discount}    ${list_disvnd}    ${list_dis%}    Get list product detail in purchase order detail frm API
    ...    ${ma_phieu_dat}    ${get_list_prs}
    ${get_no_ncc_hientai}    ${get_tong_mua}    ${get_tong_mua_tru_tra_hang}    Get Supplier Debt from API    ${ma_ncc}
    ${result_tongtien_tru_gg}    Minus    ${get_tongtienhang}    ${get_giamgia_vnd}
    #
    Log    Get list dvcb cua sp
    ${list_prs_cb}    Get list code basic of product unit    ${get_list_prs}
    ${list_price_cb}    ${list_num_cb}    Computation list price and num of basic product    ${get_list_prs}    ${list_price_af_discount}    ${list_num}
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
    ${list_other_charge_value_vnd}    Create List
    : FOR    ${item_other_charge}    IN ZIP    ${list_other_charge_value}
    \    ${item_other_charge}=    Run Keyword If    ${item_other_charge}>100    Set Variable    ${item_other_charge}
    \    ...    ELSE    Convert % discount to VND and round    ${item_other_charge}    ${result_tongtien_tru_gg}
    \    ${item_other_charge}    Replace floating point    ${item_other_charge}
    \    Append To List    ${list_other_charge_value_vnd}    ${item_other_charge}
    Log    ${list_other_charge_value_vnd}
    ${total_other_charge}    Sum values in list    ${list_other_charge_value_vnd}
    ${total_expense_value}    Sum    ${total_supplier_charge}    ${total_other_charge}
    #
    Log    tinh toan gia von
    ${list_cost_af}    Computation list of cost incase purchase order have discount, price change and have expense    ${list_prs_cb}    ${list_price_cb}    ${list_num_cb}    ${get_giamgia_vnd}    ${get_tongtienhang}
    ...    ${total_expense_value}
    ${list_onhand_af}    Get list onhand after purchase receipt    ${list_prs_cb}    ${list_num_cb}
    Log    tinh so luong dat ncc
    ${get_list_on_order_af}    Computation list on order after purchase receipt frm processing    ${get_list_prs}    ${list_num}
    #
    Log    tinh can tra ncc, tong no
    ${result_tongtienhang_gg_cpnh}    Sum    ${result_tongtien_tru_gg}    ${total_supplier_charge}
    ${result_cantrancc_af}    Minus    ${result_tongtienhang_gg_cpnh}    ${get_datrancc}
    ${actual_tientrancc}    Set Variable If    '${input_tientrancc}'=='all'    ${result_cantrancc_af}    ${input_tientrancc}
    ${actual_tientrancc}    Run Keyword If    '${input_tientrancc}'=='all'    Replace floating point    ${actual_tientrancc}
    ...    ELSE    Set Variable    ${input_tientrancc}
    ${sum_tientrancc}    Sum    ${get_datrancc}    ${actual_tientrancc}
    #
    ${result_no_phieunhap}    Minus    ${result_tongtienhang_gg_cpnh}    ${actual_tientrancc}
    ${result_no_ncc}    Sum    ${get_no_ncc_hientai}    ${result_no_phieunhap}
    ${result_tongmua}    Sum    ${result_tongtienhang_gg_cpnh}    ${get_tong_mua}
    ${result_tongmua_tru_trahang}    Sum    ${result_tongtienhang_gg_cpnh}    ${get_tong_mua_tru_tra_hang}
    #
    Log    tao phieu qua API
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${get_id_ncc}    Get Supplier Id    ${ma_ncc}
    ${get_list_prs_id}    Get list product id thr API    ${get_list_prs}
    ${get_purchase_order_id}    Get purchase order id frm API    ${ma_phieu_dat}
    ${list_order_detail_id}    Get list product order id frm purchase order detail api    ${ma_phieu_dat}    ${get_list_prs_id}
    ${list_imei_all}    Create List
    ${liststring_prs_order_detail}    Set Variable    needdel
    : FOR    ${item_pr}    ${item_pr_id}    ${item_status}    ${item_price_bf_discount}    ${item_num_order}    ${item_num_edit}
    ...    ${item_disvnd}    ${item_dis%}    ${item_pr_order_id}    IN ZIP    ${get_list_prs}    ${get_list_prs_id}
    ...    ${get_list_imei_status}    ${list_price_bf_discount}    ${list_num}    ${list_num}    ${list_disvnd}    ${list_dis%}
    ...    ${list_order_detail_id}
    \    ${discount_type}    Set Variable If    ${item_dis%}==0    null    ${item_disvnd}
    \    ${list_imei}    Run Keyword If    '${item_status}'=='True'    Create list imei by generating random    ${item_num_edit}
    \    ...    ELSE    Set Variable    ${EMPTY}
    \    ${list_imei}    Run Keyword If    '${item_status}'=='True'    Convert List to String    ${list_imei}
    \    ...    ELSE    Set Variable    ${EMPTY}
    \    Append To List    ${list_imei_all}    ${list_imei}
    \    ${payload_each_product}    Format string    {{"Unit":"","ListProductUnit":[],"Units":[],"SelectedUnit":8296366,"ShowUnit":false,"Shelves":"","Id":{0},"OrderSupplierId":{1},"ProductId":{2},"Quantity":{3},"Price":{4},"Discount":{5},"Allocation":10450,"CreatedDate":"","Description":"","DiscountRatio":{6},"OrderByNumber":0,"AllocationSuppliers":40040,"AllocationThirdParty":17950,"OrderQuantity":{7},"Product":{{"Id":{2},"Code":"{8}","Name":"chuột quang xám","CategoryId":173814,"AllowsSale":true,"BasePrice":289.68,"Tax":0,"RetailerId":{9},"isActive":true,"CreatedDate":"","ProductType":2,"HasVariants":false,"Unit":"","ConversionValue":1,"OrderTemplate":"","FullName":"chuột quang xám","IsLotSerialControl":true,"IsRewardPoint":false,"isDeleted":false,"MasterCode":"SPC001784","Revision":"AAAAAAfuux8=","Formula":[],"ProductImages":[],"PurchaseReturnDetails":[],"ProductChild":[],"ProductAttributes":[],"ProductChildUnit":[],"PriceBookDetails":[],"ProductBranches":[],"TableAndRooms":[],"Manufacturings":[],"ManufacturingDetails":[],"DamageDetails":[],"ProductSerials":[],"ProductFormulaHistories":[],"OrderSupplierDetails":[],"ProductShelves":[],"PrescriptionDetails":[],"OnHand":128,"Reserved":0}},"ProductName":"chuột quang xám","ProductCode":"{8}","SubTotal":209000,"Reserved":0,"OnHand":128,"OnOrder":16,"tabIndex":100,"ViewIndex":1,"TotalValue":null,"allSuggestSerial":[],"SerialNumbers":"{10}"}}    ${item_pr_order_id}    ${get_purchase_order_id}    ${item_pr_id}
    \    ...    ${item_num_edit}    ${item_price_bf_discount}    ${item_disvnd}    ${item_dis%}    ${item_num_order}
    \    ...    ${item_pr}    ${get_id_nguoitao}    ${list_imei}
    \    ${liststring_prs_order_detail}    Catenate    SEPARATOR=,    ${liststring_prs_order_detail}    ${payload_each_product}
    Log    ${liststring_prs_order_detail}
    ${liststring_prs_order_detail}    Replace String    ${liststring_prs_order_detail}    needdel,    ${EMPTY}    count=1
    Log    ${list_imei_all}
    #
    ${ma_phieu_nhap}    Generate code automatically    PN
    ${get_list_cpnh_id}    Get list expenses id    ${list_cpnh}
    ${get_list_cpnhk_id}    Get list expenses id    ${list_cpnhk}
    ${liststring_cpnh}    Set Variable    needdel
    : FOR    ${item_cpnh}    ${item_cpnh_id}    ${item_giatri}    IN ZIP    ${list_cpnh}    ${get_list_cpnh_id}
    ...    ${list_supplier_charge_value_vnd}
    \    ${payload_cpnh}    Format String    {{"ExpensesOtherId":{0},"Id":{0},"ExValue":{1},"Price":{1},"Name":"Phí nhập 3","Code":"{2}","Form":0}}    ${item_cpnh_id}    ${item_giatri}    ${item_cpnh}
    \    ${liststring_cpnh}    Catenate    SEPARATOR=,    ${liststring_cpnh}    ${payload_cpnh}
    Log    ${liststring_cpnh}
    ${liststring_cpnh}    Replace String    ${liststring_cpnh}    needdel,    ${EMPTY}    count=1
    #
    ${liststring_cpnhk}    Set Variable    needdel
    : FOR    ${item_cpnhk}    ${item_cpnhk_id}    ${item_giatri}    IN ZIP    ${list_cpnhk}    ${get_list_cpnhk_id}
    ...    ${list_other_charge_value_vnd}
    \    ${payload_cpnhk}    Format String    {{"ExpensesOtherId":{0},"Id":{0},"ExValue":{1},"Price":{1},"Name":"Phí nhập 3","Code":"{2}","Form":1}}    ${item_cpnhk_id}    ${item_giatri}    ${item_cpnhk}
    \    ${liststring_cpnhk}    Catenate    SEPARATOR=,    ${liststring_cpnhk}    ${payload_cpnhk}
    Log    ${liststring_cpnhk}
    ${liststring_cpnhk}    Replace String    ${liststring_cpnhk}    needdel,    ${EMPTY}    count=1
    ${liststring_all_cpnh}    Catenate    SEPARATOR=,    ${liststring_cpnh}    ${liststring_cpnhk}
    Log    ${liststring_all_cpnh}
    #
    ${result_gg_%}    Set Variable If    0<${get_giamgia_%}<100    ${get_giamgia_%}    null
    ${request_payload}    Format String    {{"PurchaseOrder":{{"Code":"{0}","OrderSupplierCode":"{1}","OrderSupplierId":"{2}","PurchaseOrderDetails":[{3}],"UserId":{4},"CompareUserId":{4},"User":{{"CompareGivenName":"admin","CompareIsLimitedByTrans":false,"CompareIsShowSumRow":true,"CompareUserName":"admin","Id":{4},"Email":"","GivenName":"admin","CreatedDate":"","IsActive":true,"IsAdmin":true,"RetailerId":{5},"UserName":"admin","Type":0,"CreatedBy":0,"CanAccessAnySite":false,"Language":"vi-VN","LocationName":"","WardName":"","isDeleted":false,"Permissions":[],"Apps":[],"Invoices":[],"Transfers1":[],"PriceBookUsers":[],"CashFlows":[],"Invoices1":[],"Orders":[],"Returns1":[],"Manufacturings":[],"DamageItems":[],"TokenApis":[],"SmsEmailTemplates":[],"BalanceAdjustments1":[],"PointAdjustments":[],"PointAdjustmentsCreatedBy":[],"NotificationSettings":[],"DamageItems1":[],"PurchaseOrders1":[],"PurchaseReturns1":[],"CostAdjustments":[],"Devices":[],"OrderSuppliers":[],"OrderSuppliers1":[]}},"CreatedDate":"","Description":"","Supplier":{{"TotalInvoiced":0,"CompareCode":"NCC0025","CompareName":"NCC Thái Bình","ComparePhone":"977654897","Id":{6},"Name":"NCC Thái Bình","Phone":"977654897","RetailerId":{5},"Code":"NCC0025","CreatedDate":"","CreatedBy":{4},"Debt":1420435,"LocationName":"","WardName":"","BranchId":{8},"isDeleted":false,"isActive":true,"SearchNumber":"977654897","PurchaseOrders":[],"PurchaseReturns":[],"PurchasePayments":[],"SupplierGroupDetails":[],"OrderSuppliers":[]}},"SupplierId":{6},"CompareSupplierId":{6},"SubTotal":{7},"Branch":{{"Id":{8},"Name":"Chi nhánh trung tâm","Type":0,"Address":"abc","Province":"Hà Nội","District":"Quận Cầu Giấy","IsActive":true,"RetailerId":{5},"CreatedBy":0,"LimitAccess":false,"LocationName":"Hà Nội - Quận Cầu Giấy","isAcceptBookClosing":false,"GmbStatus":1,"Orders":[],"Transfers1":[],"DamageItems":[],"SurchargeBranches":[],"AdrApplications":[],"Customers":[],"Suppliers":[],"ExpensesOtherBranches":[],"OrderSuppliers":[],"WarrantyBranchGroups":[],"BranchTakingAddresses":[],"TotalUser":0,"CompareBranchName":"Chi nhánh trung tâm","StatusGmbValue":"Chưa đăng ký"}},"Status":1,"StatusValue":"Phiếu tạm","CompareStatusValue":"Phiếu tạm","Discount":{9},"CompareDiscount":502012,"DiscountRatio":{10},"Id":0,"UpdatePurchaseId":0,"Account":{{}},"Total":{11},"TotalQuantity":{12},"ExpensesOthersTitle":"Phí nhập 3, Phí nhập 8","ExpensesOthersRtpTitle":"Phí nhập 11, Phí nhập 16","PurchaseOrderExpensesOthers":[{13}],"PurchaseOrderExpensesOthersRs":[{14}],"PurchaseOrderExpensesOthersRtp":[{15}],"ExReturnSuppliers":{16},"ExReturnThirdParty":{17},"PaidAmount":0,"PayingAmount":{18},"ChangeAmount":-198763,"paymentMethod":"","BalanceDue":698763,"DepositReturn":698763,"OriginTotal":495202,"PricebookDetail":[],"paymentMethodObj":null,"paymentReturnType":0,"PurchasePayments":[{{"Amount":{18},"Method":"Cash"}}],"BranchId":{8}}},"PurchaseOrderLargeData":null,"Complete":true,"CopyFrom":0,"PricebookDetail":[],"IsFinalizedOS":false}}    ${ma_phieu_nhap}    ${ma_phieu_dat}    ${get_purchase_order_id}    ${liststring_prs_order_detail}
    ...    ${get_id_nguoiban}    ${get_id_nguoitao}    ${get_id_ncc}    ${get_tongtienhang}    ${BRANCH_ID}    ${get_giamgia_vnd}
    ...    ${result_gg_%}    ${result_cantrancc_af}    ${get_soluong}    ${liststring_all_cpnh}    ${liststring_cpnh}    ${liststring_cpnhk}
    ...    ${total_supplier_charge}    ${total_other_charge}    ${actual_tientrancc}
    Log    ${request_payload}
    ${headers}=    Create Dictionary    Authorization=${bearertoken}    Content-Type=application/json;charset=UTF-8    Retailer=${RETAILER_NAME}    BranchId=${BRANCH_ID}    Zone=${env}
    Create Session    lolo    ${API_URL}    cookies=${resp.cookies}    verify=True    debug=1
    ${resp}=    Post Request    lolo    /purchaseOrders    data=${request_payload}    headers=${headers}
    Log    ${resp.request.body}
    Log    ${resp.json()}
    Log    ${resp.status_code}
    Should Be Equal As Strings    ${resp.status_code}    200
    Sleep    10s    wait for response to API
    #
    Log    tat cpnh
    : FOR    ${item_cpnh}    ${item_sp_charge_value}    IN ZIP    ${list_cpnh}    ${list_supplier_charge_value}
    \    Run Keyword If    ${item_sp_charge_value}>100    Toggle supplier's charge VND    ${item_cpnh}    false
    \    ...    ELSE    Toggle supplier's charge %    ${item_cpnh}    false
    : FOR    ${item_cpnhk}    ${item_other_charge_value}    IN ZIP    ${list_cpnhk}    ${list_other_charge_value}
    \    Run Keyword If    ${item_other_charge_value}>100    Toggle other charge VND    ${item_cpnhk}    false
    \    ...    ELSE    Toggle other charge %    ${item_cpnhk}    false
    Log    validate thong tin tren phieu dat nhap
    ${get_supplier_code_dh}    ${get_tongtienhang_dh}    ${get_tiendatra_ncc_dh}    ${get_giamgia_pn_dh}    ${get_tongcong_dh}    ${get_tongsoluong_dh}    ${get_trangthai_dh}
    ...    Get purchase order info by purchase order code    ${ma_phieu_dat}
    Should Be Equal As Strings    ${get_supplier_code_dh}    ${ma_ncc}
    Should Be Equal As Numbers    ${get_tongtienhang_dh}    ${get_tongtienhang}
    Should Be Equal As Numbers    ${get_tiendatra_ncc_dh}    ${sum_tientrancc}
    Should Be Equal As Numbers    ${get_tongsoluong_dh}    ${get_soluong}
    Should Be Equal As Numbers    ${get_tongcong_dh}    ${get_cantrancc}
    Should Be Equal As Numbers    ${get_giamgia_pn_dh}    ${get_giamgia_vnd}
    Should Be Equal As Strings    ${get_trangthai_dh}    Hoàn thành
    Log    validate in tab lich su dat hang nhap
    ${get_status}    ${get_total}    Get sumary in tab Lich su dat hang nhap    ${ma_ncc}    ${ma_phieu_dat}
    Should Be Equal As Numbers    ${get_status}    3
    Should Be Equal As Numbers    ${get_total}    ${get_cantrancc}
    Log    validate so lượng đã nhập
    ${get_list_order_qty}    Get list order quality in purchase order frm API    ${ma_phieu_dat}    ${get_list_prs}
    : FOR    ${item_num}    ${item_order_qty}    IN ZIP    ${list_num}    ${get_list_order_qty}
    \    Should Be Equal As Numbers    ${item_num}    ${item_order_qty}
    Log    validate the kho, so quy
    : FOR    ${item_product}    ${item_onhand_af_ex}    ${item_num}    IN ZIP    ${list_prs_cb}    ${list_onhand_af}
    ...    ${list_num_cb}
    \    Wait Until Keyword Succeeds    3 times    30s    Assert values in Stock Card    ${ma_phieu_nhap}    ${item_product}
    \    ...    ${item_onhand_af_ex}    ${item_num}
    #the kho imei
    : FOR    ${item_product}    ${item_num}    ${item_imei}    ${item_status}    IN ZIP    ${get_list_prs}
    ...    ${list_num}    ${list_imei_all}    ${get_list_imei_status}
    \    Run Keyword If    '${item_status}'=='[True]'    Assert imei avaiable in SerialImei tab    ${item_product}    ${item_imei}
    \    ...    ELSE    Log    Ignore validate imei
    #
    Log    validate so quy
    ${nav_tientra_ncc}=    Catenate    -    ${actual_tientrancc}
    ${get_ma_pn_soquy}  Get Ma Phieu Thu in So quy     ${ma_phieu_nhap}
    Run Keyword If    '${actual_tientrancc}' == '0'    Validate So quy info from Rest API if Invoice is not paid    ${ma_phieu_nhap}
    ...    ELSE    Validate So quy info from Rest API if Invoice is paid    ${get_ma_pn_soquy}    ${nav_tientra_ncc}
    #
    Log    validate in tab no can tra ncc
    Run Keyword If    '${actual_tientrancc}'=='0'    Validate status in Tab No can tra NCC if purchase order is not paid until success    ${ma_ncc}    ${ma_phieu_nhap}
    ...    ELSE    Validate status in Tab No can tra NCC if purchase order is paid until success    ${ma_ncc}    ${get_ma_pn_soquy}    ${ma_phieu_nhap}
    Assert ma phieu nhap is avaliable in Tab No can tra NCC and Lich su nhap/tra hang    ${ma_ncc}    ${ma_phieu_nhap}
    #
    Log    validate tổng nợ, tổng mua
    ${get_no_af_purchase}    ${get_tongmua_af_purchase}    ${get_tongmua_tru_trahang_af_purchase}    Get Supplier Debt from API    ${ma_ncc}
    Should Be Equal As Numbers    ${get_no_af_purchase}    ${result_no_ncc}
    Should Be Equal As Numbers    ${get_tongmua_af_purchase}    ${result_tongmua}
    Should Be Equal As Numbers    ${get_tongmua_tru_trahang_af_purchase}    ${result_tongmua_tru_trahang}
    #
    Log    validate gia von
    ${list_result_cost_af_ex}    ${list_result_onhand_af_ex}    Get list cost - onhand frm API    ${list_prs_cb}
    : FOR    ${item_pr}    ${item_cost}    ${item_result_cost}    IN ZIP    ${list_prs_cb}    ${list_cost_af}
    ...    ${list_result_cost_af_ex}
    \    ${item_cost_rd}    Evaluate    round(${item_cost},1)
    \    ${item_result_cost_rd}    Evaluate    round(${item_result_cost},1)
    \    Should Be Equal As Numbers    ${item_cost_rd}    ${item_result_cost_rd}
    #
    Log    validate sl dat ncc
    ${get_list_on_order_actual_af}    Get list on order frm API    ${get_list_prs}
    : FOR    ${item_on_order}    ${item_on_order_actual}    IN ZIP    ${get_list_on_order_af}    ${get_list_on_order_actual_af}
    \    Should Be Equal As Numbers    ${item_on_order}    ${item_on_order_actual}
    #
    Validate purchase receipt history frm purchase order    ${ma_phieu_dat}    ${ma_phieu_nhap}
    Log    validate thong tin tren phieu nhap
    ${get_supplier_code_nh}    ${get_tongtienhang_nh}    ${get_tiendatra_ncc_nh}    ${get_giamgia_pn_nh}    ${get_tongcong_nh}    ${get_tongsoluong_nh}    ${get_trangthai_mh}
    ...    Get purchase receipt info incase discount by purchase receipt code    ${ma_phieu_nhap}
    Should Be Equal As Strings    ${get_supplier_code_nh}    ${ma_ncc}
    Should Be Equal As Numbers    ${get_tongtienhang_nh}    ${get_tongtienhang}
    Should Be Equal As Numbers    ${get_tiendatra_ncc_nh}    ${sum_tientrancc}
    Should Be Equal As Numbers    ${get_tongsoluong_nh}    ${get_soluong}
    Should Be Equal As Numbers    ${get_tongcong_nh}    ${result_tongtienhang_gg_cpnh}
    Should Be Equal As Numbers    ${get_giamgia_pn_nh}    ${get_giamgia_vnd}
    Should Be Equal As Strings    ${get_trangthai_mh}    Đã nhập hàng
