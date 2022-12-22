*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}      ${headless_browser}
Library           Collections
Resource          ../../../core/hang_hoa/hang_hoa_navigation.robot
Resource          ../../../core/share/computation.robot
Resource          ../../../core/Giao_dich/dat_hang_nhap_add_action.robot
Resource          ../../../core/Giao_dich/dat_hang_nhap_list_action.robot
Resource          ../../../core/Giao_dich/giaodich_nav.robot
Resource          ../../../core/API/api_danhmuc_hanghoa.robot
Resource          ../../../core/Doi_Tac/doitac_navigation.robot
Resource          ../../../core/Doi_Tac/ncc_list_action.robot
Resource          ../../../core/So_Quy/so_quy_list_action.robot
Resource          ../../../core/share/toast_message.robot
Resource          ../../../core/API/api_nha_cung_cap.robot
Resource          ../../../core/API/api_dathangnhap.robot
Resource          ../../../core/API/api_soquy.robot
Resource          ../../../core/Giao_dich/nhaphang_getandcompute.robot
Resource          ../../../core/Giao_dich/nhap_hang_add_action.robot

*** Variables ***
&{dict_pr}    DNQD007=5    DNS017=3    DNT017=11
&{dict_giamoi}    DNQD007=none    DNS017=89000    DNT017=85000.84
&{dict_gg}    DNQD007=10    DNS017=10000.25    DNT017=0
&{dict_pr1}    DNQD108=5    DNS018=2    DNT018=7.5
&{dict_giamoi1}    DNQD108=55000.5    DNS018=12000    DNT018=none
&{dict_gg1}    DNQD108=20    DNS018=10000.25    DNT018=0
@{CPNH}           CPNH3    CPNH8
@{CPNHK}          CPNH11    CPNH16
@{CPNH1}          CPNH2    CPNH5
@{CPNHK1}         CPNH10    CPNH14

*** Test Cases ***
Phieu tam
    [Documentation]    Phiếu tạm
    [Tags]      EDNCA1
    [Template]    dhnca01
    NCC0002    ${dict_pr}    ${dict_giamoi}    ${dict_gg}    20    all    ${CPNH1}    ${CPNHK1}

Da xac nhan
    [Documentation]    Đã xác nhận
    [Tags]      EDNCA1
    [Template]    dhnca02
    NCC0005    ${dict_pr1}    ${dict_giamoi1}    ${dict_gg1}    30000    80000    ${CPNH1}    ${CPNHK1}

*** Keywords ***
dhnca01
    [Arguments]    ${input_supplier_code}    ${dict_prs}    ${dict_newprice}    ${dict_discount}    ${input_discount}    ${input_tientrancc}
    ...    ${list_cpnh}    ${list_cpnhk}
    Log    Bat cpnh va get gia tri
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
    ${list_prs}    Get Dictionary Keys    ${dict_prs}
    ${list_nums}    Get Dictionary Values    ${dict_prs}
    ${list_newprice}    Get Dictionary Values    ${dict_newprice}
    ${list_gg}    Get Dictionary Values    ${dict_discount}
    ${ma_phieu}    Generate code automatically    PDN
    ${list_prs_cb}    Get list code basic of product unit    ${list_prs}
    #
    Log    get tong no, tong mua cua nha cung cap truoc khi nhap hang
    ${get_no_ncc_hientai}    ${get_tong_mua}    ${get_tong_mua_tru_tra_hang}    Get Supplier Debt from API    ${input_supplier_code}
    #
    ${list_result_thanhtien_af}    ${list_result_newprice_af}    ${list_result_onhand_cb_af}    ${list_dongia}    ${list_result_onhand_actual_af}    ${list_actual_num_cb}    ${list_result_newprice_cb_af}       ${list_result_newprice_bf}    ${list_result_discount_vnd}
    ...    Get list of total purchase receipt - result onhand actual product in case of price change and have discount    ${list_prs_cb}     ${list_prs}     ${list_nums}    ${list_newprice}    ${list_gg}
    ${result_tongtienhang}    Sum values in list    ${list_result_thanhtien_af}
    ${list_cost_bf_ex}    ${list_onhand_bf_ex}    Get list cost - onhand frm API    ${list_prs_cb}
    #
    ${get_list_on_order_af}    Get list on order frm API    ${list_prs}
    #
    ${result_discount_nh}    Run Keyword If    0 < ${input_discount} < 100    Convert % discount to VND and round    ${result_tongtienhang}    ${input_discount}
    ...    ELSE    Set Variable    ${input_discount}
    ${result_tongtien_tru_gg}    Minus    ${result_tongtienhang}    ${result_discount_nh}
    #
    Log    tinh tong CPNH
    ${list_supplier_charge_value_vnd}    Create List
    : FOR    ${item_supplier_charge}    IN ZIP    ${list_supplier_charge_value}
    \    ${item_supplier_charge}=    Run Keyword If    ${item_supplier_charge}> 100    Set Variable    ${item_supplier_charge}
    \    ...    ELSE    Convert % discount to VND and round    ${item_supplier_charge}    ${result_tongtien_tru_gg}
    \    ${item_supplier_charge}      Replace floating point    ${item_supplier_charge}
    \    Append To List    ${list_supplier_charge_value_vnd}    ${item_supplier_charge}
    Log    ${list_supplier_charge_value_vnd}
    ${total_supplier_charge}      Sum values in list    ${list_supplier_charge_value_vnd}
    ${list_other_charge_value_vnd}    Create List
    : FOR    ${item_other_charge}    IN ZIP    ${list_other_charge_value}
    \    ${item_other_charge}=    Run Keyword If    ${item_other_charge}>100    Set Variable    ${item_other_charge}
    \    ...    ELSE    Convert % discount to VND and round    ${item_other_charge}    ${result_tongtien_tru_gg}
    \    ${item_other_charge}       Replace floating point    ${item_other_charge}
    \    Append To List    ${list_other_charge_value_vnd}    ${item_other_charge}
    Log    ${list_other_charge_value_vnd}
    ${total_other_charge}     Sum values in list    ${list_other_charge_value_vnd}
    ${total_expense_value}    Sum    ${total_supplier_charge}    ${total_other_charge}
    #
    ${result_cantrancc}    Sum    ${result_tongtien_tru_gg}    ${total_supplier_charge}
    ${actual_tientrancc}    Set Variable If    '${input_tientrancc}'=='all'    ${result_cantrancc}    ${input_tientrancc}
    ${actual_tientrancc}    Run Keyword If    '${input_tientrancc}'=='all'    Replace floating point    ${actual_tientrancc}
    ...    ELSE    Set Variable    ${input_tientrancc}
    ${result_no_ncc}    Minus    ${get_no_ncc_hientai}    ${actual_tientrancc}
    ${total_num}    Sum values in list    ${list_nums}
    #
    Log    tao phieu qua API
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${get_id_ncc}    Get Supplier Id    ${input_supplier_code}
    ${get_list_prs_id}    Get list product id thr API    ${list_prs}
    ${liststring_prs_order_detail}    Set Variable    needdel
    : FOR    ${item_pr}    ${item_pr_id}    ${item_newprice}    ${item_num}    ${item_giamgia}    ${item_price_af_discount}
    ...    IN ZIP    ${list_prs}    ${get_list_prs_id}    ${list_dongia}    ${list_nums}    ${list_gg}
    ...    ${list_result_newprice_af}
    \    ${discount_type}    Set Variable If       ${item_giamgia}>100    null    ${item_giamgia}
    \    ${discount_vnd}    Run Keyword If    ${item_giamgia}>100    Set variable     ${item_giamgia}
    \    ...    ELSE    Convert % discount to VND and round     ${item_newprice}    ${item_giamgia}
    \    ${payload_each_product}    Format string    {{"ProductId":{0},"Product":{{"Name":"Nước Hoa La Rive In Woman Eau De Parfum vial","Code":"{1}","IsLotSerialControl":false}},"ProductName":"Nước Hoa La Rive In Woman Eau De Parfum vial","ProductCode":"{1}","Description":"","Price":{2},"priceAfterDiscount":{3},"Quantity":{4},"ShowUnit":false,"ListProductUnit":[{{"Id":{0},"Unit":"","Code":"{1}","Conversion":0,"MasterUnitId":0}}],"Units":[{{"Id":{0},"Unit":"","Code":"{1}","Conversion":0,"MasterUnitId":0}}],"Unit":"","SelectedUnit":{0},"OnHand":-30.2,"OnOrder":0,"Reserved":0,"tabIndex":100,"ViewIndex":1,"rowNumber":0,"TotalValue":20000,"Discount":{5},"Allocation":20250,"AllocationSuppliers":48175,"AllocationThirdParty":32437.5,"DiscountValue":0,"DiscountType":"VND","DiscountRatio":{6},"adjustedPrice":{2},"OriginPrice":{2},"OrderByNumber":0}}    ${item_pr_id}    ${item_pr}    ${item_newprice}
    \    ...    ${item_price_af_discount}    ${item_num}    ${discount_vnd}    ${discount_type}
    \    ${liststring_prs_order_detail}    Catenate    SEPARATOR=,    ${liststring_prs_order_detail}    ${payload_each_product}
    Log    ${liststring_prs_order_detail}
    ${liststring_prs_order_detail}    Replace String    ${liststring_prs_order_detail}    needdel,    ${EMPTY}    count=1
    #
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
    ${request_payload}    Format String    {{"OrderSupplier":{{"ImportDate":null,"Code":"{0}","OrderSupplierDetails":[{1}],"UserId":{2},"CompareUserId":{2},"User":{{"id":{2},"username":"admin","givenName":"admin","Id":{2},"UserName":"admin","GivenName":"admin","IsAdmin":true,"IsLimitedByTrans":false,"IsShowSumRow":true,"Theme":""}},"Description":"","Supplier":{{"TotalInvoiced":0,"CompareCode":"NCC0010","CompareName":"NCC Thu Hương","ComparePhone":"0977654899","Id":{3},"Name":"NCC Thu Hương","Phone":"0977654899","RetailerId":{4},"Code":"NCC0010","CreatedDate":"2019-05-25T15:49:08.8770000+07:00","CreatedBy":{2},"Debt":200000,"LocationName":"","WardName":"","BranchId":{5},"isDeleted":false,"isActive":true,"SearchNumber":"0977654899","PurchaseOrders":[],"PurchaseReturns":[],"PurchasePayments":[],"SupplierGroupDetails":[],"OrderSuppliers":[]}},"SupplierId":{3},"SubTotal":{6},"Branch":{{"id":{5},"name":"Chi nhánh trung tâm","Id":{5},"Name":"Chi nhánh trung tâm","Address":"abc","LocationName":"Hà Nội - Quận Cầu Giấy","WardName":"","ContactNumber":"","SubContactNumber":""}},"Status":0,"StatusValue":"Phiếu tạm","CompareStatusValue":"Phiếu tạm","Discount":{7},"CompareDiscount":0,"DiscountRatio":{8},"Id":0,"Account":{{}},"Total":{9},"TotalQuantity":{10},"ExpensesOthersTitle":"Phí nhập 3, Phí nhập 8","ExpensesOthersRtpTitle":"Phí nhập 11, Phí nhập 16","OrderSupplierExpensesOthers":[{12}],"OrderSupplierExpensesOthersRs":[{13}],"OrderSupplierExpensesOthersRtp":[{14}],"ExReturnSuppliers":{15},"ExReturnThirdParty":{16},"PaidAmount":0,"PayingAmount":{11},"ChangeAmount":-151700,"paymentMethod":"","BalanceDue":651700,"paymentReturnType":0,"OriginTotal":459000,"paymentMethodObj":null,"DiscountRatioWoRound":{8},"DiscountWoRound":{7},"PurchaseOrderExpenssaveDataesOthers":[{12}],"PurchasePayments":[{{"Amount":{11},"Method":"Cash"}}],"BranchId":{5}}},"Complete":true,"CopyFrom":0}}    ${ma_phieu}    ${liststring_prs_order_detail}    ${get_id_nguoiban}    ${get_id_ncc}
    ...    ${get_id_nguoiban}    ${BRANCH_ID}    ${result_tongtienhang}    ${result_discount_nh}    ${input_discount}    ${result_cantrancc}
    ...    ${total_num}    ${actual_tientrancc}    ${liststring_all_cpnh}    ${liststring_cpnh}    ${liststring_cpnhk}    ${total_supplier_charge}      ${total_other_charge}
    Log    ${request_payload}
    ${headers}=    Create Dictionary    Authorization=${bearertoken}    Content-Type=application/json;charset=UTF-8    Retailer=${RETAILER_NAME}    BranchId=${BRANCH_ID}    Zone=${env}
    Create Session    lolo    ${API_URL}    cookies=${resp.cookies}    verify=True    debug=1
    ${resp}=    Post Request    lolo    /ordersuppliers    data=${request_payload}    headers=${headers}
    Log    ${resp.request.body}
    Log    ${resp.json()}
    Log    ${resp.status_code}
    Should Be Equal As Strings    ${resp.status_code}    200
    Sleep    10s    wait for response to API
    #
    Log    tat CPNH
    : FOR    ${item_cpnh}    ${item_sp_charge_value}    IN ZIP    ${list_cpnh}    ${list_supplier_charge_value}
    \    Run Keyword If    ${item_sp_charge_value}>100    Toggle supplier's charge VND    ${item_cpnh}    false
    \    ...    ELSE    Toggle supplier's charge %    ${item_cpnh}    false
    : FOR    ${item_cpnhk}    ${item_other_charge_value}    IN ZIP    ${list_cpnhk}    ${list_other_charge_value}
    \    Run Keyword If    ${item_other_charge_value}>100    Toggle other charge VND    ${item_cpnhk}    false
    \    ...    ELSE    Toggle other charge %    ${item_cpnhk}    false
    Log    validate thong tin tren phieu nhap
    #
    ${get_supplier_code}    ${get_tongtienhang}    ${get_tiendatra_ncc}    ${get_giamgia_pn}    ${get_tongcong}    ${get_tongsoluong}    ${get_trangthai}
    ...    Get purchase order info by purchase order code    ${ma_phieu}
    Should Be Equal As Strings    ${get_supplier_code}    ${input_supplier_code}
    Should Be Equal As Numbers    ${get_tongtienhang}    ${result_tongtienhang}
    Should Be Equal As Numbers    ${get_tiendatra_ncc}    ${actual_tientrancc}
    Should Be Equal As Numbers    ${get_tongsoluong}    ${total_num}
    Should Be Equal As Numbers    ${get_tongcong}    ${result_cantrancc}
    Should Be Equal As Numbers    ${get_giamgia_pn}    ${result_discount_nh}
    Should Be Equal As Strings    ${get_trangthai}    Phiếu tạm
    #
    Log    validate so quy
    ${nav_tientra_ncc}=    Catenate    -    ${actual_tientrancc}
    ${get_ma_pn_soquy}    Get Ma Phieu Thu in So quy    ${ma_phieu}
    Run Keyword If    '${actual_tientrancc}' == '0'    Validate So quy info from Rest API if Invoice is not paid    ${ma_phieu}
    ...    ELSE    Validate So quy info from Rest API if Invoice is paid    ${get_ma_pn_soquy}    ${nav_tientra_ncc}
    #
    Log    validate in tab no can tra ncc
    Run Keyword If    '${actual_tientrancc}'=='0'    Log    Ignore validate
    ...    ELSE    Validate status in Tab No can tra NCC if purchase order draft is paid until success    ${input_supplier_code}    ${get_ma_pn_soquy}
    #
    Log    validate in tab lich su dat hang nhap
    ${get_status}    ${get_total}    Get sumary in tab Lich su dat hang nhap    ${input_supplier_code}    ${ma_phieu}
    Should Be Equal As Numbers    ${get_status}    0
    Should Be Equal As Numbers    ${get_total}    ${result_cantrancc}
    Log    validate tổng nợ, tổng mua
    ${get_no_af_purchase}    ${get_tongmua_af_purchase}    ${get_tongmua_tru_trahang_af_purchase}    Get Supplier Debt from API    ${input_supplier_code}
    Should Be Equal As Numbers    ${get_no_af_purchase}    ${result_no_ncc}
    Should Be Equal As Numbers    ${get_tongmua_af_purchase}    ${get_tong_mua}
    Should Be Equal As Numbers    ${get_tongmua_tru_trahang_af_purchase}    ${get_tong_mua_tru_tra_hang}
    Log    validate gia von
    ${list_result_cost_af_ex}    ${list_result_onhand_af_ex}    Get list cost - onhand frm API    ${list_prs_cb}
    : FOR    ${item_cost_bf}    ${item_cost_af}    ${item_onhand_bf}    ${item_onhand_af}    IN ZIP    ${list_cost_bf_ex}
    ...    ${list_result_cost_af_ex}    ${list_onhand_bf_ex}    ${list_result_onhand_af_ex}
    \    Should Be Equal As Numbers    ${item_cost_bf}    ${item_cost_af}
    \    Should Be Equal As Numbers    ${item_onhand_bf}    ${item_onhand_af}
    #
    Log    validate dat ncc
    ${get_list_actual_on_order_af}    Get list on order frm API    ${list_prs}
    : FOR    ${item_on_order}    ${item_actual_on_order}    IN ZIP    ${get_list_on_order_af}    ${get_list_actual_on_order_af}
    \    Should Be Equal As Numbers    ${item_on_order}    ${item_actual_on_order}
    #
    Delete purchase order code    ${ma_phieu}

dhnca02
    [Arguments]    ${input_supplier_code}    ${dict_prs}    ${dict_newprice}    ${dict_discount}    ${input_discount}    ${input_tientrancc}
    ...    ${list_cpnh}    ${list_cpnhk}
    [Tags]    cccu
    Log    Bật cpnh và get giá trị
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
    ${list_prs}    Get Dictionary Keys    ${dict_prs}
    ${list_nums}    Get Dictionary Values    ${dict_prs}
    ${list_newprice}    Get Dictionary Values    ${dict_newprice}
    ${list_gg}    Get Dictionary Values    ${dict_discount}
    ${ma_phieu}    Generate code automatically    PDN
    ${list_prs_cb}    Get list code basic of product unit    ${list_prs}
    #
    Log    get tong no, tong mua cua nha cung cap truoc khi nhap hang
    ${get_no_ncc_hientai}    ${get_tong_mua}    ${get_tong_mua_tru_tra_hang}    Get Supplier Debt from API    ${input_supplier_code}
    #
    ${list_result_thanhtien_af}    ${list_result_newprice_af}    ${list_result_onhand_af}    ${list_dongia}    ${list_result_onhand_actual_af}    ${list_actual_num_cb}    ${list_result_newprice_cb_af}      ${list_result_newprice_bf}    ${list_result_discount_vnd}
    ...    Get list of total purchase receipt - result onhand actual product in case of price change and have discount      ${list_prs_cb}     ${list_prs}    ${list_nums}    ${list_newprice}    ${list_gg}
    ${result_tongtienhang}    Sum values in list    ${list_result_thanhtien_af}
    ${list_cost_bf_ex}    ${list_onhand_bf_ex}    Get list cost - onhand frm API    ${list_prs_cb}
    #
    ${get_list_on_order_af}    Computation list on order after Da xac nhan NCC    ${list_prs}    ${list_nums}
    #
    ${result_discount_nh}    Run Keyword If    0 < ${input_discount} < 100    Convert % discount to VND and round    ${result_tongtienhang}    ${input_discount}
    ...    ELSE    Set Variable    ${input_discount}
    ${result_tongtien_tru_gg}    Minus    ${result_tongtienhang}    ${result_discount_nh}
    #
    Log    tinh tong CPNH
    ${list_supplier_charge_value_vnd}    Create List
    : FOR    ${item_supplier_charge}    IN ZIP    ${list_supplier_charge_value}
    \    ${item_supplier_charge}=    Run Keyword If    ${item_supplier_charge}> 100    Set Variable    ${item_supplier_charge}
    \    ...    ELSE    Convert % discount to VND and round    ${item_supplier_charge}    ${result_tongtien_tru_gg}
    \    ${item_supplier_charge}      Replace floating point    ${item_supplier_charge}
    \    Append To List    ${list_supplier_charge_value_vnd}    ${item_supplier_charge}
    Log    ${list_supplier_charge_value_vnd}
    ${total_supplier_charge}      Sum values in list    ${list_supplier_charge_value_vnd}
    ${list_other_charge_value_vnd}    Create List
    : FOR    ${item_other_charge}    IN ZIP    ${list_other_charge_value}
    \    ${item_other_charge}=    Run Keyword If    ${item_other_charge}>100    Set Variable    ${item_other_charge}
    \    ...    ELSE    Convert % discount to VND and round    ${item_other_charge}    ${result_tongtien_tru_gg}
    \    ${item_other_charge}       Replace floating point    ${item_other_charge}
    \    Append To List    ${list_other_charge_value_vnd}    ${item_other_charge}
    Log    ${list_other_charge_value_vnd}
    ${total_other_charge}     Sum values in list    ${list_other_charge_value_vnd}
    ${total_expense_value}    Sum    ${total_supplier_charge}    ${total_other_charge}
    #
    ${result_cantrancc}    Sum    ${result_tongtien_tru_gg}    ${total_supplier_charge}
    ${actual_tientrancc}    Set Variable If    '${input_tientrancc}'=='all'    ${result_cantrancc}    ${input_tientrancc}
    ${actual_tientrancc}    Run Keyword If    '${input_tientrancc}'=='all'    Replace floating point    ${actual_tientrancc}
    ...    ELSE    Set Variable    ${input_tientrancc}
    ${result_no_ncc}    Minus    ${get_no_ncc_hientai}    ${actual_tientrancc}
    ${total_num}    Sum values in list    ${list_nums}
    #
    Log    tao phieu qua API
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${get_id_ncc}    Get Supplier Id    ${input_supplier_code}
    ${get_list_prs_id}    Get list product id thr API    ${list_prs}
    ${liststring_prs_order_detail}    Set Variable    needdel
    : FOR    ${item_pr}    ${item_pr_id}    ${item_newprice}    ${item_num}    ${item_giamgia}    ${item_price_af_discount}
    ...    IN ZIP    ${list_prs}    ${get_list_prs_id}    ${list_dongia}    ${list_nums}    ${list_gg}
    ...    ${list_result_newprice_af}
    \    ${discount_type}    Set Variable If       ${item_giamgia}>100    null    ${item_giamgia}
    \    ${discount_vnd}    Run Keyword If    ${item_giamgia}>100    Set variable     ${item_giamgia}
    \    ...    ELSE    Convert % discount to VND      ${item_newprice}    ${item_giamgia}
    \    ${payload_each_product}    Format string    {{"ProductId":{0},"Product":{{"Name":"Nước Hoa La Rive In Woman Eau De Parfum vial","Code":"{1}","IsLotSerialControl":false}},"ProductName":"Nước Hoa La Rive In Woman Eau De Parfum vial","ProductCode":"{1}","Description":"","Price":{2},"priceAfterDiscount":{3},"Quantity":{4},"ShowUnit":false,"ListProductUnit":[{{"Id":{0},"Unit":"","Code":"{1}","Conversion":0,"MasterUnitId":0}}],"Units":[{{"Id":{0},"Unit":"","Code":"{1}","Conversion":0,"MasterUnitId":0}}],"Unit":"","SelectedUnit":{0},"OnHand":-30.2,"OnOrder":0,"Reserved":0,"tabIndex":100,"ViewIndex":1,"rowNumber":0,"TotalValue":20000,"Discount":{5},"Allocation":20250,"AllocationSuppliers":48175,"AllocationThirdParty":32437.5,"DiscountValue":0,"DiscountType":"VND","DiscountRatio":{6},"adjustedPrice":{2},"OriginPrice":{2},"OrderByNumber":0}}    ${item_pr_id}    ${item_pr}    ${item_newprice}
    \    ...    ${item_price_af_discount}    ${item_num}    ${discount_vnd}    ${discount_type}
    \    ${liststring_prs_order_detail}    Catenate    SEPARATOR=,    ${liststring_prs_order_detail}    ${payload_each_product}
    Log    ${liststring_prs_order_detail}
    ${liststring_prs_order_detail}    Replace String    ${liststring_prs_order_detail}    needdel,    ${EMPTY}    count=1
    #
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
    ${request_payload}    Format String    {{"OrderSupplier":{{"ImportDate":null,"Code":"{0}","OrderSupplierDetails":[{1}],"UserId":{2},"CompareUserId":{2},"User":{{"id":{2},"username":"admin","givenName":"admin","Id":{2},"UserName":"admin","GivenName":"admin","IsAdmin":true,"IsLimitedByTrans":false,"IsShowSumRow":true,"Theme":""}},"Description":"","Supplier":{{"TotalInvoiced":0,"CompareCode":"NCC0010","CompareName":"NCC Thu Hương","ComparePhone":"0977654899","Id":{3},"Name":"NCC Thu Hương","Phone":"0977654899","RetailerId":{4},"Code":"NCC0010","CreatedDate":"2019-05-25T15:49:08.8770000+07:00","CreatedBy":{2},"Debt":200000,"LocationName":"","WardName":"","BranchId":{5},"isDeleted":false,"isActive":true,"SearchNumber":"0977654899","PurchaseOrders":[],"PurchaseReturns":[],"PurchasePayments":[],"SupplierGroupDetails":[],"OrderSuppliers":[]}},"SupplierId":{3},"SubTotal":{6},"Branch":{{"id":{5},"name":"Chi nhánh trung tâm","Id":{5},"Name":"Chi nhánh trung tâm","Address":"abc","LocationName":"Hà Nội - Quận Cầu Giấy","WardName":"","ContactNumber":"","SubContactNumber":""}},"Status":1,"StatusValue":"Đã xác nhận NCC","CompareStatusValue":"Phiếu tạm","Discount":{7},"CompareDiscount":0,"DiscountRatio":{8},"Id":0,"Account":{{}},"Total":{9},"TotalQuantity":{10},"ExpensesOthersTitle":"Phí nhập 3, Phí nhập 8","ExpensesOthersRtpTitle":"Phí nhập 11, Phí nhập 16","OrderSupplierExpensesOthers":[{12}],"OrderSupplierExpensesOthersRs":[{13}],"OrderSupplierExpensesOthersRtp":[{14}],"ExReturnSuppliers":{15},"ExReturnThirdParty":{16},"PaidAmount":0,"PayingAmount":{11},"ChangeAmount":-151700,"paymentMethod":"","BalanceDue":651700,"paymentReturnType":0,"OriginTotal":459000,"paymentMethodObj":null,"DiscountRatioWoRound":{8},"DiscountWoRound":{7},"PurchaseOrderExpenssaveDataesOthers":[{12}],"PurchasePayments":[{{"Amount":{11},"Method":"Cash"}}],"BranchId":{5}}},"Complete":true,"CopyFrom":0}}    ${ma_phieu}    ${liststring_prs_order_detail}    ${get_id_nguoiban}    ${get_id_ncc}
    ...    ${get_id_nguoiban}    ${BRANCH_ID}    ${result_tongtienhang}    ${result_discount_nh}    ${input_discount}    ${result_cantrancc}
    ...    ${total_num}    ${actual_tientrancc}    ${liststring_all_cpnh}    ${liststring_cpnh}    ${liststring_cpnhk}    ${total_supplier_charge}      ${total_other_charge}
    Log    ${request_payload}
    ${headers}=    Create Dictionary    Authorization=${bearertoken}    Content-Type=application/json;charset=UTF-8    Retailer=${RETAILER_NAME}    BranchId=${BRANCH_ID}    Zone=${env}
    Create Session    lolo    ${API_URL}    cookies=${resp.cookies}    verify=True    debug=1
    ${resp}=    Post Request    lolo    /ordersuppliers    data=${request_payload}    headers=${headers}
    Log    ${resp.request.body}
    Log    ${resp.json()}
    Log    ${resp.status_code}
    Should Be Equal As Strings    ${resp.status_code}    200
    Sleep    10s    wait for response to API
    #TAT CPNH
    : FOR    ${item_cpnh}    ${item_sp_charge_value}    IN ZIP    ${list_cpnh}    ${list_supplier_charge_value}
    \    Run Keyword If    ${item_sp_charge_value}>100    Toggle supplier's charge VND    ${item_cpnh}    false
    \    ...    ELSE    Toggle supplier's charge %    ${item_cpnh}    false
    : FOR    ${item_cpnhk}    ${item_other_charge_value}    IN ZIP    ${list_cpnhk}    ${list_other_charge_value}
    \    Run Keyword If    ${item_other_charge_value}>100    Toggle other charge VND    ${item_cpnhk}    false
    \    ...    ELSE    Toggle other charge %    ${item_cpnhk}    false
    #validate thong tin tren phieu nhap
    ${get_supplier_code}    ${get_tongtienhang}    ${get_tiendatra_ncc}    ${get_giamgia_pn}    ${get_tongcong}    ${get_tongsoluong}    ${get_trangthai}
    ...    Get purchase order info by purchase order code    ${ma_phieu}
    Should Be Equal As Strings    ${get_supplier_code}    ${input_supplier_code}
    Should Be Equal As Numbers    ${get_tongtienhang}    ${result_tongtienhang}
    Should Be Equal As Numbers    ${get_tiendatra_ncc}    ${actual_tientrancc}
    Should Be Equal As Numbers    ${get_tongsoluong}    ${total_num}
    Should Be Equal As Numbers    ${get_tongcong}    ${result_cantrancc}
    Should Be Equal As Numbers    ${get_giamgia_pn}    ${result_discount_nh}
    Should Be Equal As Strings    ${get_trangthai}    Đã xác nhận NCC
    #validate so quy
    ${nav_tientra_ncc}=    Catenate    -    ${actual_tientrancc}
    ${get_ma_pn_soquy}    Get Ma Phieu Thu in So quy    ${ma_phieu}
    Run Keyword If    '${actual_tientrancc}' == '0'    Validate So quy info from Rest API if Invoice is not paid    ${ma_phieu}
    ...    ELSE    Validate So quy info from Rest API if Invoice is paid    ${get_ma_pn_soquy}    ${nav_tientra_ncc}
    #validate in tab no can tra ncc
    Run Keyword If    '${actual_tientrancc}'=='0'    Log    Ignore validate
    ...    ELSE    Validate status in Tab No can tra NCC if purchase order draft is paid until success    ${input_supplier_code}    ${get_ma_pn_soquy}
    #validate in tab lich su dat hang nhap
    ${get_status}    ${get_total}    Get sumary in tab Lich su dat hang nhap    ${input_supplier_code}    ${ma_phieu}
    Should Be Equal As Numbers    ${get_status}    1
    Should Be Equal As Numbers    ${get_total}    ${result_cantrancc}
    #validate tổng nợ, tổng mua
    ${get_no_af_purchase}    ${get_tongmua_af_purchase}    ${get_tongmua_tru_trahang_af_purchase}    Get Supplier Debt from API    ${input_supplier_code}
    Should Be Equal As Numbers    ${get_no_af_purchase}    ${result_no_ncc}
    Should Be Equal As Numbers    ${get_tongmua_af_purchase}    ${get_tong_mua}
    Should Be Equal As Numbers    ${get_tongmua_tru_trahang_af_purchase}    ${get_tong_mua_tru_tra_hang}
    #validate gia von
    ${list_result_cost_af_ex}    ${list_result_onhand_af_ex}    Get list cost - onhand frm API    ${list_prs_cb}
    : FOR    ${item_cost_bf}    ${item_cost_af}    ${item_onhand_bf}    ${item_onhand_af}    IN ZIP    ${list_cost_bf_ex}
    ...    ${list_result_cost_af_ex}    ${list_onhand_bf_ex}    ${list_result_onhand_af_ex}
    \    Should Be Equal As Numbers    ${item_cost_bf}    ${item_cost_af}
    \    Should Be Equal As Numbers    ${item_onhand_bf}    ${item_onhand_af}
    #validate dat ncc
    ${get_list_actual_on_order_af}    Get list on order frm API    ${list_prs}
    : FOR    ${item_on_order}    ${item_actual_on_order}    IN ZIP    ${get_list_on_order_af}    ${get_list_actual_on_order_af}
    \    Should Be Equal As Numbers    ${item_on_order}    ${item_actual_on_order}
    #
    Delete purchase order code    ${ma_phieu}
