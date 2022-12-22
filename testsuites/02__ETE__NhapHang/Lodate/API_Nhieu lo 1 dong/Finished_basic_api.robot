*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}      ${headless_browser}
Library           Collections
Resource          ../../../../core/hang_hoa/hang_hoa_navigation.robot
Resource          ../../../../core/share/computation.robot
Resource          ../../../../core/Giao_dich/nhap_hang_add_action.robot
Resource          ../../../../core/Giao_dich/nhap_hang_add_page.robot
Resource          ../../../../core/API/api_phieu_nhap_hang.robot
Resource          ../../../../core/Giao_dich/giaodich_nav.robot
Resource          ../../../../core/API/api_danhmuc_hanghoa.robot
Resource          ../../../../core/Doi_Tac/doitac_navigation.robot
Resource          ../../../../core/Doi_Tac/ncc_list_action.robot
Resource          ../../../../core/So_Quy/so_quy_list_action.robot
Resource          ../../../../core/share/toast_message.robot
Resource          ../../../../core/API/api_nha_cung_cap.robot
Resource          ../../../../core/API/api_soquy.robot
Resource          ../../../../core/Giao_dich/nhaphang_getandcompute.robot
Resource          ../../../../core/Giao_dich/nhap_hang_list_action.robot
Resource          ../../../../core/share/lodate.robot

*** Variables ***
&{dict_imp}       LD04=9,6    QD24=3.7,6,8
&{dict_giamoi}    LD04=92000.5    QD24=none
&{dict_gg}        LD04=7000    QD24=15

*** Test Cases ***    Mã NCC        Mã SP - SL       Giá mới           GGSP          GGPN     Tiền trả NCC
Finished
                      [Tags]        ENNLA
                      [Template]    ennla1
                      NCC0016       ${dict_imp}      ${dict_giamoi}    ${dict_gg}     10        all

*** Keywords ***
ennla1
    [Arguments]    ${input_supplier_code}    ${dict_im}    ${dict_newprice}    ${dict_discount_prd}    ${input_nh_discount}    ${input_tientrancc}
    ${list_nums}    Get Dictionary Values    ${dict_im}
    ${list_prs}    Get Dictionary Keys    ${dict_im}
    ${list_newprice}    Get Dictionary Values    ${dict_newprice}
    ${list_discount_prd}    Get Dictionary Values    ${dict_discount_prd}
    ${import_code}    Generate code automatically    PNH
    #
    ${list_pr_cb}    Get list code basic of product unit    ${list_prs}
    #
    Log    get tong no, tong mua cua nha cung cap truoc khi nhap hang
    ${get_no_ncc_hientai}    ${get_tong_mua}    ${get_tong_mua_tru_tra_hang}    Get Supplier Debt from API    ${input_supplier_code}
    #
    Log    tinh thanh tien, tong tien hang
    ${list_result_num}    Create List
    : FOR    ${item_list_num}    IN ZIP    ${list_nums}
    \    ${item_list_num}    Convert string to list    ${item_list_num}
    \    ${result_num}    Sum values in list    ${item_list_num}
    \    Append To List    ${list_result_num}    ${result_num}
    Log    ${list_result_num}
    ${list_result_thanhtien_af}    ${list_result_newprice_af}    ${list_result_onhand_cb_af}    ${list_dongia}    ${list_result_onhand_actual_af}    ${list_actual_num_cb}    ${list_result_newprice_cb_af}
    ...    ${list_result_newprice_bf}    ${list_result_discount_vnd}    Get list of total purchase receipt - result onhand actual product in case of price change and have discount    ${list_pr_cb}    ${list_prs}    ${list_result_num}
    ...    ${list_newprice}    ${list_discount_prd}
    ${result_tongtienhang}    Sum values in list    ${list_result_thanhtien_af}
    ${result_discount_nh}    Run Keyword If    0 < ${input_nh_discount} < 100    Convert % discount to VND and round    ${result_tongtienhang}    ${input_nh_discount}
    ...    ELSE    Set Variable    ${input_nh_discount}
    ${result_cantrancc}    Minus    ${result_tongtienhang}    ${result_discount_nh}
    ${actual_tientrancc}    Set Variable If    '${input_tientrancc}'=='all'    ${result_cantrancc}    ${input_tientrancc}
    ${actual_tientrancc}    Run Keyword If    '${input_tientrancc}'=='all'    Replace floating point    ${actual_tientrancc}
    ...    ELSE    Set Variable    ${input_tientrancc}
    #
    ${result_no_phieunhap}    Minus    ${result_cantrancc}    ${actual_tientrancc}
    ${result_no_ncc}    sum    ${get_no_ncc_hientai}    ${result_no_phieunhap}
    ${result_no_ncc}    Minus    0    ${result_no_ncc}
    ${result_tongmua}    sum    ${result_cantrancc}    ${get_tong_mua}
    ${result_tongmua_tru_tranghag}    sum    ${result_cantrancc}    ${get_tong_mua_tru_tra_hang}
    #
    Log     tinh toan gia von sau khi nhap hang
    ${list_cost_cb_af_ex}    Computation list of cost incase purchase order have discount and price change    ${list_pr_cb}    ${list_result_newprice_cb_af}    ${list_actual_num_cb}    ${result_discount_nh}    ${result_tongtienhang}
    #
    Log    tao phieu qua API
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${get_id_ncc}    Get Supplier Id    ${input_supplier_code}
    ${get_list_prs_id}    Get list product id thr API    ${list_prs}
    ${list_tenlo}    Create List
    : FOR    ${item_list_num}    IN ZIP      ${list_nums}
    \    ${list_tenlo_by_pr}   Generate randomly list lots by num     ${item_list_num}
    \    Append To List    ${list_tenlo}    ${list_tenlo_by_pr}
    Log    ${list_tenlo}
    #
    ${list_liststring_lodate}    Create List
    : FOR    ${item_list_num}    ${item_list_lo}    IN ZIP    ${list_nums}    ${list_tenlo}
    \    ${liststring_lodate}    Create json for product batch expire list    ${item_list_num}    ${item_list_lo}
    \    Append To List    ${list_liststring_lodate}    ${liststring_lodate}
    Log    ${list_liststring_lodate}
    #
    ${liststring_prs_order_detail}    Set Variable    needdel
    : FOR    ${item_pr}    ${item_pr_id}    ${item_num}    ${item_newprice_bf}    ${item_discount}    ${item_newprice_af}
    ...    ${item_result_dis_vnd}    ${item_liststring_lodate}    IN ZIP    ${list_prs}    ${get_list_prs_id}    ${list_result_num}
    ...    ${list_result_newprice_bf}      ${list_discount_prd}    ${list_result_newprice_af}     ${list_result_discount_vnd}    ${list_liststring_lodate}
    \    ${pr_discount_type}    Set Variable If    ${item_discount}>0    null    ${item_discount}
    \    ${result_allocation}       Price after apllocate discount    ${item_newprice_af}    ${result_tongtienhang}    ${result_discount_nh}
    \    ${result_allocation}     Evaluate    round(${result_allocation},2)
    \    ${payload_each_product}    Format string    {{"ProductId":{0},"ConversionValue":1,"Product":{{"Name":"hàng lodate","Code":"SP000031","IsLotSerialControl":false,"IsBatchExpireControl":true,"ProductShelvesStr":"","OnHand":0,"Reserved":0}},"ProductName":"hàng lodate","ProductCode":"SP000031","Description":"","Price":{1},"priceAfterDiscount":{2},"Quantity":{3},"ShowUnit":false,"ListProductUnit":[{{"Id":{0},"Unit":"","Code":"SP000031","Conversion":0,"MasterUnitId":0,"PriceChanged":{1},"DiscountChanged":{4},"DiscountRatioChanged":{5}}}],"Units":[{{"Id":{0},"Unit":"","Code":"SP000031","Conversion":0,"MasterUnitId":0}}],"Unit":"","SelectedUnit":{0},"OnOrder":0,"ProductBatchExpires":[],"ListProductSerialHavingTrans":[],"ListProductBatchExpireHavingTrans":[],"tabIndex":100,"ViewIndex":1,"TotalValue":315000,"Discount":{4},"Allocation":{7},"AllocationSuppliers":0,"AllocationThirdParty":0,"ProductBatchExpireList":[{6}],"DiscountValue":0,"DiscountType":"VND","DiscountRatio":{5},"adjustedPrice":{1},"OriginPrice":{1},"allSuggestSerial":[],"OrderByNumber":0}}    ${item_pr_id}    ${item_newprice_bf}    ${item_newprice_af}
    \    ...    ${item_num}    ${item_result_dis_vnd}    ${pr_discount_type}    ${item_liststring_lodate}    ${result_allocation}
    \    ${liststring_prs_order_detail}    Catenate    SEPARATOR=,    ${liststring_prs_order_detail}    ${payload_each_product}
    Log    ${liststring_prs_order_detail}
    ${liststring_prs_order_detail}    Replace String    ${liststring_prs_order_detail}    needdel,    ${EMPTY}    count=1
    #
    ${discount_type}    Set Variable If    ${input_nh_discount}>0    null    ${input_nh_discount}
    ${request_payload}    Format String    {{"PurchaseOrder":{{"Code":"{0}","PurchaseOrderDetails":[{1}],"UserId":{2},"CompareUserId":{2},"User":{{"id":{2},"username":"admin","givenName":"admin","Id":{2},"UserName":"admin","GivenName":"admin","IsAdmin":true,"IsLimitedByTrans":false,"IsShowSumRow":true,"Theme":""}},"Description":"","Supplier":{{"TotalInvoiced":0,"CompareCode":"NCC0002","CompareName":"Hoa quả sạch tiki","ComparePhone":"0977654891","Id":{3},"Name":"Hoa quả sạch tiki","Phone":"0977654891","RetailerId":{4},"Code":"NCC0002","CreatedDate":"","CreatedBy":{2},"LocationName":"","WardName":"","BranchId":{5},"isDeleted":false,"isActive":true,"SearchNumber":"0977654891","PurchaseOrders":[],"PurchaseReturns":[],"PurchasePayments":[],"SupplierGroupDetails":[],"OrderSuppliers":[]}},"SupplierId":{3},"SubTotal":{6},"Branch":{{"id":{5},"name":"Chi nhánh trung tâm","Id":{5},"Name":"Chi nhánh trung tâm","Address":"hà nội","LocationName":"Hà Nội - Quận Ba Đình","WardName":"","ContactNumber":"","SubContactNumber":""}},"Status":1,"StatusValue":"Phiếu tạm","CompareStatusValue":"Phiếu tạm","Discount":{7},"CompareDiscount":0,"DiscountRatio":{8},"Id":0,"UpdatePurchaseId":0,"Account":{{}},"Total":{9},"TotalQuantity":7,"ExpensesOthersTitle":"","ExpensesOthersRtpTitle":"","PurchaseOrderExpensesOthers":[],"PurchaseOrderExpensesOthersRs":[],"PurchaseOrderExpensesOthersRtp":[],"ExReturnSuppliers":0,"ExReturnThirdParty":0,"PaidAmount":0,"PayingAmount":{10},"ChangeAmount":-183500,"paymentMethod":"","BalanceDue":283500,"DepositReturn":283500,"OriginTotal":283500,"PricebookDetail":[],"paymentMethodObj":null,"paymentReturnType":0,"DiscountRatioWoRound":{8},"DiscountWoRound":{7},"PurchasePayments":[{{"Amount":{10},"Method":"Cash"}}],"BranchId":{5}}},"PurchaseOrderLargeData":null,"Complete":true,"CopyFrom":0,"PricebookDetail":[],"IsFinalizedOS":false}}    ${import_code}    ${liststring_prs_order_detail}    ${get_id_nguoiban}    ${get_id_ncc}
    ...    ${get_id_nguoitao}    ${BRANCH_ID}    ${result_tongtienhang}    ${result_discount_nh}    ${discount_type}    ${result_cantrancc}
    ...    ${actual_tientrancc}
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
    Log    validate thong tin tren phieu nhap
    ${result_tongsoluong}    Sum values in list    ${list_result_num}
    ${get_supplier_code}    ${get_tongtienhang}    ${get_tiendatra_ncc}    ${get_giamgia_pn}    ${get_tongcong}    ${get_tongsoluong}    ${get_trangthai}
    ...    Get purchase receipt info incase discount by purchase receipt code    ${import_code}
    Should Be Equal As Strings    ${get_supplier_code}    ${input_supplier_code}
    Should Be Equal As Numbers    ${get_tongtienhang}    ${result_tongtienhang}
    Should Be Equal As Numbers    ${get_tiendatra_ncc}    ${actual_tientrancc}
    Should Be Equal As Numbers    ${get_tongsoluong}    ${result_tongsoluong}
    Should Be Equal As Numbers    ${get_tongcong}    ${result_cantrancc}
    Should Be Equal As Numbers    ${get_giamgia_pn}    ${result_discount_nh}
    Should Be Equal As Strings    ${get_trangthai}    Đã nhập hàng
    #
    Log    validate the kho, so quy
    : FOR    ${item_product}    ${item_onhand_af_ex}    ${item_num_cb}    IN ZIP    ${list_pr_cb}    ${list_result_onhand_cb_af}
    ...    ${list_actual_num_cb}
    \    Wait Until Keyword Succeeds    3 times    30s    Assert values in Stock Card    ${import_code}    ${item_product}
    \    ...    ${item_onhand_af_ex}    ${item_num_cb}
    : FOR    ${item_product}    ${item_num}    ${item_list_lo}    ${item_pr_cb}    IN ZIP    ${list_prs}
    ...    ${list_nums}    ${list_tenlo}    ${list_pr_cb}
    \    ${item_num}    Convert string to list    ${item_num}
    \    ${item_list_lo}    Convert string to list    ${item_list_lo}
    \    Wait Until Keyword Succeeds    3 times    30s    Assert list values in Stock Card in tab Lo - HSD    ${import_code}    ${item_product}
    \    ...    ${item_pr_cb}    ${item_num}    ${item_num}    ${item_list_lo}
    ${nav_tientra_ncc}=    Catenate    -    ${actual_tientrancc}
    ${get_ma_pn_soquy}    Get Ma Phieu Chi in So quy    ${import_code}
    Run Keyword If    '${actual_tientrancc}' == '0'    Validate So quy info from Rest API if Invoice is not paid    ${import_code}
    ...    ELSE    Validate So quy info from Rest API if Invoice is paid    ${get_ma_pn_soquy}    ${nav_tientra_ncc}
    #
    Log    validate in tab no can tra ncc
    Run Keyword If    '${actual_tientrancc}'=='0'    Validate status in Tab No can tra NCC if purchase order is not paid until success    ${input_supplier_code}    ${import_code}
    ...    ELSE    Validate status in Tab No can tra NCC if purchase order is paid until success    ${input_supplier_code}    ${get_ma_pn_soquy}    ${import_code}
    Assert ma phieu nhap is avaliable in Tab No can tra NCC and Lich su nhap/tra hang    ${input_supplier_code}    ${import_code}
    #
    Log    validate tổng nợ, tổng mua
    ${get_no_af_purchase}    ${get_tongmua_af_purchase}    ${get_tongmua_tru_trahang_af_purchase}    Get Supplier Debt from API after purchase    ${input_supplier_code}    ${import_code}    ${actual_tientrancc}
    Should Be Equal As Numbers    ${get_no_af_purchase}    ${result_no_ncc}
    Should Be Equal As Numbers    ${get_tongmua_af_purchase}    ${result_tongmua}
    Should Be Equal As Numbers    ${get_tongmua_tru_trahang_af_purchase}    ${result_tongmua_tru_tranghag}
    #
    Log    validate gia von
    Wait Until Keyword Succeeds    3 times    30s    Assert list of onhand, cost af receipt    ${list_pr_cb}    ${list_result_onhand_cb_af}    ${list_cost_cb_af_ex}
    Delete purchase receipt code    ${import_code}
