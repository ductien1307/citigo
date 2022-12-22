*** Settings ***
Library           Collections
Library           RequestsLibrary
Library           SeleniumLibrary
Library           OperatingSystem
Library           String
Library           StringFormat
Library           JSONLibrary
Resource          ../share/computation.robot
Resource          ../share/imei.robot
Resource          api_access.robot
Resource          api_danhmuc_hanghoa.robot
Resource          api_nha_cung_cap.robot
Resource          ../share/list_dictionary.robot
Resource          ../../prepare/Hang_hoa/Sources/hanghoa.robot
Resource          ../../prepare/Hang_hoa/Sources/giaodich.robot

*** Variables ***
${endpoint_phieu_tra_nhap_hang}    /purchasereturns?format=json&Includes=Branch&Includes=PurchaseOrder&Includes=Supplier&Includes=TotalReturn&Includes=TotalQuantity&Includes=User&Includes=User1&Includes=PaymentCode&Includes=PaymentId&Includes=TotalPayment&Includes=TotalProductType&ForSummaryRow=true&%24inlinecount=allpages&%24top=15&%24filter=(BranchId+eq+{0})    #branch ID
${endpoint_delete_ptnh}    /PurchaseReturns/{0}?CompareCode={1}&CompareStatus=1&IsVoidPayment=true   #0: id phieu tra hang nhap, 1: ma phieu tra hang nhap

*** Keywords ***
Get purchase return id thr API
    [Arguments]     ${input_purchase_return_code}
    [Timeout]    5 mins
    ${jsonpath_pur_order_id}    Format String    $..Data[?(@.Code=="{0}")].Id    ${input_purchase_return_code}
    ${endpoint_phieu_tra_nhap_hang}    Format String    ${endpoint_phieu_tra_nhap_hang}    ${BRANCH_ID}
    ${get_pur_return_id}    Get data from API    ${endpoint_phieu_tra_nhap_hang}    ${jsonpath_pur_order_id}
    Return From Keyword    ${get_pur_return_id}

Get Purchase Return Info
    [Arguments]    ${input_purchase_return_code}
    [Timeout]    5 mins
    ${endpoint_purchase_return_endpoint_by_branch}    Format String    ${endpoint_phieu_tra_nhap_hang}    ${BRANCH_ID}
    ${respbody}    Get Request and return body    ${endpoint_purchase_return_endpoint_by_branch}
    ${jsonpath_status}    Format String    $.Data[?(@.Code=='{0}')].Status    ${input_purchase_return_code}
    ${jsonpath_quantity_total}    Format String    $.Data[?(@.Code=='{0}')].TotalQuantity    ${input_purchase_return_code}
    ${jsonpath_payment_return_total}    Format String    $.Data[?(@.Code=='{0}')].SubTotal    ${input_purchase_return_code}
    ${jsonpath_supplier_need_pay}    Format String    $.Data[?(@.Code=='{0}')].TotalReturn    ${input_purchase_return_code}
    ${jsonpath_supplier_payment}    Format String    $.Data[?(@.Code=='{0}')].TotalPayment    ${input_purchase_return_code}
    ${quantity_total}    Get data from response json    ${respbody}    ${jsonpath_quantity_total}
    ${payment_return_total}    Get data from response json    ${respbody}    ${jsonpath_payment_return_total}
    ${supplier_need_pay}    Get data from response json    ${respbody}    ${jsonpath_supplier_need_pay}
    ${supplier_payment}    Get data from response json    ${respbody}    ${jsonpath_supplier_payment}
    ${supplier_payment}    Convert To Number    ${supplier_payment}
    ${supplier_payment}    Minus    0    ${supplier_payment}
    ${status}    Get data from response json    ${respbody}    ${jsonpath_status}
    ${final_status}=    Run Keyword If    ${status} == 1    Set Variable    Hoàn thành
    ...    ELSE    Set Variable    Lưu tạm
    Return From Keyword    ${quantity_total}    ${payment_return_total}    ${supplier_need_pay}    ${supplier_payment}    ${final_status}

Delete purchase return code
    [Arguments]    ${purchase_return_code}
    [Timeout]    5 mins
    ${jsonpath_pur_order_id}    Format String    $..Data[?(@.Code=="{0}")].Id    ${purchase_return_code}
    ${endpoint_phieu_tra_nhap_hang}    Format String    ${endpoint_phieu_tra_nhap_hang}    ${BRANCH_ID}
    ${get_pur_return_id}    Get data from API    ${endpoint_phieu_tra_nhap_hang}    ${jsonpath_pur_order_id}
    ${endpoint_delete_pnh_by_id}    Format String    ${endpoint_delete_ptnh}    ${get_pur_return_id}    ${purchase_return_code}
    Delete request thr API    ${endpoint_delete_pnh_by_id}

Get list of total purchase return - result onhand actual product in case of price change
    [Arguments]    ${input_list_product_cb}    ${input_list_actualproduct}    ${input_list_num}    ${input_list_change}    ${input_list_change_type}
    [Documentation]    tinh toan gia tri thanh tien, gia moi, ton kho, ton kho dvcb sau hi tra hang nhap (ko phan bo giam gia phieu nhap)
    ${list_result_thanhtien_af}    Create list
    ${list_result_newprice_af}    Create list
    ${list_result_onhand_actual_af}    Create list
    ${list_result_onhand_cb_af}    Create list
    ${list_actual_num_cb}    Create List
    ${list_result_newprice_cb_af}    Create list
    ${list_gianhap}     Create List
    ${list_result_disvnd_by_pr}    Create List
    ${get_list_onhand_cb_bf_purchase}    ${get_list_lastprice_cb_bf_purchase}    ${get_list_cost_cb_bf_purchase}    Get list of Onhand, LatestPurchasePrice and Cost frm API    ${input_list_product_cb}
    ${get_list_onhand_actual_bf_purchase}    ${get_list_lastprice_actual_bf_purchase}    ${get_list_cost_actual_bf_purchase}    ${get_list_dvqd}    Get list of Onhand, LastestPurchasePrice and Cost - Conversation values by searching product API    ${input_list_actualproduct}
    ${get_list_slphieunhap_cb}    Get list of total import product frm API    ${input_list_product_cb}
    : FOR    ${item_lastprice_cb}    ${item_num_actual}    ${item_change}    ${item_change_type}    ${item_onhand_cb}    ${item_slphieunhap_cb}
    ...    ${item_cost_cb}    ${item_onhand_actual_bf}    ${item_lastprice_actual_bf}    ${item_dvqd}    IN ZIP    ${get_list_lastprice_cb_bf_purchase}
    ...    ${input_list_num}    ${input_list_change}    ${input_list_change_type}    ${get_list_onhand_cb_bf_purchase}    ${get_list_slphieunhap_cb}    ${get_list_cost_cb_bf_purchase}
    ...    ${get_list_onhand_actual_bf_purchase}    ${get_list_lastprice_actual_bf_purchase}    ${get_list_dvqd}
    \    ${item_cost_actual}    Multiplication with price round 2    ${item_cost_cb}    ${item_dvqd}
    \    ${item_gianhap}    Run Keyword If    ${item_slphieunhap_cb} == 0    Set Variable    ${item_cost_actual}
    \    ...    ELSE    Set Variable    ${item_lastprice_actual_bf}
    \    ${result_newprice}    Run Keyword If    0 < ${item_change} < 100 and '${item_change_type}'=='dis'    Price after % discount product    ${item_gianhap}    ${item_change}
    \    ...    ELSE IF    ${item_change} > 100 and '${item_change_type}'=='dis'    Minus    ${item_gianhap}    ${item_change}
    \    ...    ELSE IF    '${item_change_type}'=='change'    Set Variable    ${item_change}
    \    ...    ELSE    Set Variable    ${item_gianhap}
    \    ${result_gg_vnd}     Minus    ${item_gianhap}    ${result_newprice}
    \    ${result_newprice_cb}    Devision    ${result_newprice}    ${item_dvqd}
    \    ${result_newprice_cb}    Evaluate    round(${result_newprice_cb}, 2)
    \    ${result_thanhtien}    Multiplication and round    ${item_num_actual}    ${result_newprice}
    \    ${acutal_import_cb}    Multiplication for onhand    ${item_dvqd}    ${item_num_actual}
    \    ${result_onhand_cb}    Minus and round 3    ${item_onhand_cb}    ${acutal_import_cb}
    \    ${result_onhand_actual}    Minus and round 3    ${item_onhand_actual_bf}    ${item_num_actual}
    \    Append to list    ${list_result_thanhtien_af}    ${result_thanhtien}
    \    Append to list    ${list_result_newprice_af}    ${result_newprice}
    \    Append to list    ${list_result_onhand_cb_af}    ${result_onhand_cb}
    \    Append to list    ${list_result_onhand_actual_af}    ${result_onhand_actual}
    \    Append To List    ${list_actual_num_cb}    ${acutal_import_cb}
    \    Append To List    ${list_result_newprice_cb_af}    ${result_newprice_cb}
    \    Append To List    ${list_gianhap}    ${item_gianhap}
    \    Append To List    ${list_result_disvnd_by_pr}    ${result_gg_vnd}
    Return From Keyword    ${list_result_thanhtien_af}    ${list_result_newprice_af}    ${list_result_onhand_cb_af}    ${list_result_onhand_actual_af}    ${list_actual_num_cb}    ${list_result_newprice_cb_af}    ${list_gianhap}     ${list_result_disvnd_by_pr}

Get list of total purchase return - result onhand and total
    [Arguments]    ${input_list_product_cb}     ${input_list_num}    ${input_list_price}
    ${list_result_thanhtien_af}    Create list
    ${list_result_onhand_cb_af}    Create list
    ${list_actual_num_cb}    Create List
    ${get_list_onhand_cb_bf_purchase}     Get list onhand frm API    ${input_list_product_cb}
    : FOR     ${item_pr}      ${item_num_cb}    ${item_gianhap}     ${item_onhand_cb_bf}      IN ZIP     ${input_list_product_cb}
    ...    ${input_list_num}    ${input_list_price}       ${get_list_onhand_cb_bf_purchase}
    \    ${result_thanhtien}    Multiplication and round       ${item_num_cb}    ${item_gianhap}
    \    ${result_toncuoi_cb}    Minus      ${item_onhand_cb_bf}    ${item_num_cb}
    \    ${result_toncuoi_cb}   Evaluate    round(${result_toncuoi_cb},3)
    \    Append to list    ${list_result_thanhtien_af}    ${result_thanhtien}
    \    Append to list    ${list_result_onhand_cb_af}    ${result_toncuoi_cb}
    Return From Keyword    ${list_result_thanhtien_af}      ${list_result_onhand_cb_af}

Get list of total purchase return - result onhand actual product in case allocation price
    [Arguments]    ${input_list_product_cb}    ${input_list_actualproduct}    ${list_price_allocate}    ${input_list_num}    ${input_list_change}    ${input_list_change_type}
    [Documentation]    tinh toan gia tri thanh tien, gia moi, ton kho, ton kho dvcb sau hi tra hang nhap (phan bo giam gia phieu nhap)
    ${list_result_thanhtien_af}    Create list
    ${list_result_newprice_af}    Create list
    ${list_result_onhand_cb_af}    Create list
    ${list_actual_num_cb}    Create List
    ${list_result_newprice_cb_af}    Create list
    ${list_result_disvnd_by_pr}     Create List
    ${get_list_dvqd}    Get list gia tri quy doi frm product API    ${input_list_actualproduct}
    ${get_list_onhand_cb_bf_purchase}    Get list onhand frm API    ${input_list_product_cb}
    : FOR    ${item_num_actual}    ${item_change}    ${item_change_type}    ${item_onhand_cb}    ${item_dvqd}    ${item_price_allocate}
    ...    IN ZIP    ${input_list_num}    ${input_list_change}    ${input_list_change_type}    ${get_list_onhand_cb_bf_purchase}    ${get_list_dvqd}
    ...    ${list_price_allocate}
    \    ${result_newprice}    Run Keyword If    0 < ${item_change} < 100 and '${item_change_type}'=='dis'    Price after % discount product    ${item_price_allocate}    ${item_change}
    \    ...    ELSE IF    ${item_change} > 100 and '${item_change_type}'=='dis'    Minus    ${item_price_allocate}    ${item_change}
    \    ...    ELSE IF    '${item_change_type}'=='change'    Set Variable    ${item_change}
    \    ...    ELSE    Set Variable    ${item_price_allocate}
    \    ${result_newprice_cb}    Devision    ${result_newprice}    ${item_dvqd}
    \    ${result_newprice_cb}    Evaluate    round(${result_newprice_cb}, 2)
    \    ${result_thanhtien}    Multiplication and round    ${item_num_actual}    ${result_newprice}
    \    ${acutal_import_cb}    Multiplication for onhand    ${item_dvqd}    ${item_num_actual}
    \    ${result_onhand_cb}    Minus    ${item_onhand_cb}    ${acutal_import_cb}
    \    ${result_disvnd_pr}      Minus    ${item_price_allocate}    ${result_newprice}
    \    Append to list    ${list_result_thanhtien_af}    ${result_thanhtien}
    \    Append to list    ${list_result_newprice_af}    ${result_newprice}
    \    Append to list    ${list_result_onhand_cb_af}    ${result_onhand_cb}
    \    Append To List    ${list_actual_num_cb}    ${acutal_import_cb}
    \    Append To List    ${list_result_newprice_cb_af}    ${result_newprice_cb}
    \    Append To List    ${list_result_disvnd_by_pr}    ${result_disvnd_pr}
    Return From Keyword    ${list_result_thanhtien_af}    ${list_result_newprice_af}    ${list_result_onhand_cb_af}    ${list_actual_num_cb}    ${list_result_newprice_cb_af}     ${list_result_disvnd_by_pr}

Add new purchase return no payment without supplier
    [Arguments]    ${dict_product_num}
    [Timeout]    3 minutes
    ## Get info ton cuoi, cong no khach hang
    ${list_product}    Get Dictionary Keys    ${dict_product_num}
    ${list_nums}    Get Dictionary Values    ${dict_product_num}
    ${endpoint_danhmuc_hh_by_branch}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${get_list_prd_id}    Get list product id thr API    ${list_product}
    ${get_list_baseprice}   Get list of Baseprice by Product Code    ${list_product}
    ${list_thanhtien}   Create List
    :FOR    ${item_nums}    ${item_price}   IN ZIP    ${list_nums}    ${get_list_baseprice}
    \       ${item_thanhtien}   Multiplication with price round 2    ${item_nums}    ${item_price}
    \       Append To List    ${list_thanhtien}    ${item_thanhtien}
    ${result_tongtienhang}    Sum values in list    ${list_thanhtien}
    ##
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    # Post request BH
    ${ma_phieu}    Generate code automatically    THN
    ${liststring_prs_purchase_detail}    Set Variable    needdel
    Log    ${liststring_prs_purchase_detail}
    : FOR    ${item_product_id}    ${item_price}    ${item_num}    IN ZIP    ${get_list_prd_id}    ${get_list_baseprice}    ${list_nums}
    \    ${payload_each_product}    Format string    {{"PurchaseOrderSerials":"","ProductBatchExpires":[],"ProductId":{0},"Product":{{"Id":{0},"Name":"Bánh xu kem Nhật","Code":"HH0001","IsLotSerialControl":false,"IsBatchExpireControl":false,"ProductShelvesStr":"","OnHand":1200,"Reserved":67.5}},"BuyPrice":{1},"suggestedReturnPrice":{1},"ReturnPrice":{1},"Quantity":{2},"ReturnQuantity":0,"SellQuantity":null,"ReturnSerials":null,"IsLotSerialControl":false,"IsBatchExpireControl":false,"ConversionValue":1,"ListProductUnit":[{{"Id":{0},"Unit":"","Code":"HH0001","Conversion":0,"MasterUnitId":0}}],"Units":[{{"Id":{0},"Unit":"","Code":"HH0001","Conversion":0,"MasterUnitId":0}}],"Unit":"","SelectedUnit":{0},"ShowUnit":false,"OnHand":1200,"OnOrder":0,"Reserved":67.5,"UniqueId":"20171638_0","ViewIndex":1,"rowPerProduct":1,"isOdd":true,"ProductCode":"HH0001","ProductName":"Bánh xu kem Nhật","OrderByNumber":0}}    ${item_product_id}    ${item_price}    ${item_num}
    \    ${liststring_prs_purchase_detail}    Catenate    SEPARATOR=,    ${liststring_prs_purchase_detail}    ${payload_each_product}
    ${liststring_prs_purchase_detail}    Replace String    ${liststring_prs_purchase_detail}    needdel,    ${EMPTY}    count=1
    ${request_payload}    Format String    {{"PurchaseReturn":{{"Code":"{0}","PurchaseReturnDetails":[{1}],"PurchaseOrderDetails":[],"UserId":{2},"User":{{"id":{2},"username":"admin","givenName":"anh.lv","Id":{2},"UserName":"admin","GivenName":"anh.lv","IsAdmin":true,"IsLimitedByTrans":false,"IsShowSumRow":true,"Theme":""}},"ReceivedById":{2},"CompareReceivedById":{2},"CompareReturnDate":"","ModifiedDate":"","Description":"","Supplier":null,"SupplierId":null,"SubTotal":{3},"Branch":{{"id":74831,"name":"Chi nhánh trung tâm","Id":{4},"Name":"Chi nhánh trung tâm","Address":"1B Yết Kiêu","LocationName":"Hà Nội - Quận Hoàn Kiếm","WardName":"","ContactNumber":"","SubContactNumber":""}},"Status":3,"CompareStatus":3,"StatusValue":"Phiếu tạm","Discount":0,"DiscountRatio":null,"Id":0,"TotalReturn":{3},"BalanceDue":90000,"PaidAmount":0,"PayingAmount":0,"ChangeAmount":-90000,"Account":{{}},"paymentMethod":null,"ExpensesOthersTitle":"","PurchaseOrderExpensesOthers":[],"PurchaseReturnExpensesOthers":[],"ExReturnSuppliers":0,"PurchaseOrderSubTotal":0,"isAutoChangeDiscount":false,"paymentMethodObj":null,"TotalQuantity":1,"OriginTotal":90000,"Total":0,"PurchaseOrderExpensesOthersRtp":[],"PurchaseOrderExpensesOthersRs":[],"BranchId":{4}}},"Completed":true,"CopyFrom":"","PurchaseReturnOld":"new"}}    ${ma_phieu}    ${liststring_prs_purchase_detail}    ${get_id_nguoiban}
    ...    ${result_tongtienhang}    ${BRANCH_ID}
    Log    ${request_payload}
    ${headers}=    Create Dictionary    Authorization=${bearertoken}    Content-Type=application/json;charset=UTF-8    Retailer=${RETAILER_NAME}    BranchId=${BRANCH_ID}
    Create Session    lolo    ${API_URL}    verify=True    debug=1
    ${resp}=    Wait Until Keyword Succeeds    3x    0s     Post Request    lolo    /PurchaseReturns    data=${request_payload}    headers=${headers}
    Log    ${resp.request.body}
    Log    ${resp.json()}
    Log    ${resp.status_code}
    Should Be Equal As Strings    ${resp.status_code}    200
    Return From Keyword    ${ma_phieu}

Computation list result price - total value in case return multi row
    [Arguments]    ${list_nums}    ${list_change}    ${list_change_type}    ${input_giatralai}
    ${list_giamoi}    Create List
    ${index}      Set Variable    -1
    : FOR    ${item_change}    ${item_change_type}    IN ZIP    ${list_change}    ${list_change_type}
    \    ${index}     Sum    ${Index}    1
    \    ${index}   Replace floating point    ${index}
    \    ${item_giatralai_main}     Run Keyword If    '${item_change_type}'=='dis' and 0 < ${item_change} < 100    Price after % discount product    ${input_giatralai}    ${item_change}    ELSE IF      '${item_change_type}'=='dis' and ${item_change} > 100    Minus    ${input_giatralai}    ${item_change}      ELSE IF     '${item_change_type}'=='change'      Set Variable    ${item_change}     ELSE        Set Variable    ${input_giatralai}
    \    ${item_giamoi}     Run Keyword If    ${index}>0 and '${item_change_type}'=='dis' and 0 < ${item_change} < 100    Price after % discount product    ${input_giatralai}    ${item_change}    ELSE IF      ${index}>0 and '${item_change_type}'=='dis' and ${item_change} > 100    Minus   ${input_giatralai}    ${item_change}       ELSE IF     ${index}>0 and '${item_change_type}'=='change'    Set Variable    ${item_change}       ELSE     Set Variable     ${item_giatralai_main}
    \    ${item_giamoi}   Evaluate    round(${item_giamoi},2)
    \    Append To List    ${list_giamoi}    ${item_giamoi}
    Log    ${list_giamoi}
    ${list_thanhtien}    Create List
    : FOR    ${item_num}    ${item_giamoi}    IN ZIP    ${list_nums}    ${list_giamoi}
    \    ${thanhtien}    Multiplication and round    ${item_num}    ${item_giamoi}
    \    Append To List    ${list_thanhtien}    ${thanhtien}
    ${result_thanhtien}    Sum values in list    ${list_thanhtien}
    Return From Keyword    ${list_giamoi}    ${result_thanhtien}

Get list of total purchase return - result onhand actual product in case of multi row product
    [Arguments]    ${input_list_product_cb}    ${input_list_actualproduct}    ${input_list_num}    ${input_list_change}    ${input_list_change_type}
    ${list_result_thanhtien_af}    Create list
    ${list_result_newprice_af}    Create list
    ${list_result_onhand_cb_af}    Create list
    ${list_actual_num_cb}    Create List
    ${get_list_onhand_cb_bf_purchase}    ${get_list_lastprice_cb_bf_purchase}    ${get_list_cost_cb_bf_purchase}    Get list of Onhand, LatestPurchasePrice and Cost frm API    ${input_list_product_cb}
    ${get_list_onhand_actual_bf_purchase}    ${get_list_lastprice_actual_bf_purchase}    ${get_list_cost_actual_bf_purchase}    ${get_list_dvqd}    Get list of Onhand, LastestPurchasePrice and Cost - Conversation values by searching product API    ${input_list_actualproduct}
    ${get_list_slphieunhap_cb}    Get list of total import product frm API    ${input_list_product_cb}
    ${index}    Set Variable    -1
    : FOR    ${item_lastprice_cb}    ${item_num_actual}    ${item_change}    ${item_change_type}    ${item_onhand_cb}    ${item_slphieunhap_cb}
    ...    ${item_cost_cb}    ${item_onhand_actual_bf}    ${item_lastprice_actual_bf}    ${item_dvqd}    IN ZIP    ${get_list_lastprice_cb_bf_purchase}
    ...    ${input_list_num}    ${input_list_change}    ${input_list_change_type}    ${get_list_onhand_cb_bf_purchase}    ${get_list_slphieunhap_cb}    ${get_list_cost_cb_bf_purchase}
    ...    ${get_list_onhand_actual_bf_purchase}    ${get_list_lastprice_actual_bf_purchase}    ${get_list_dvqd}
    \    ${item_change}    Convert string to list    ${item_change}
    \    ${item_change_type}    Convert string to list    ${item_change_type}
    \    ${item_num_actual}    Convert string to list    ${item_num_actual}
    \    ${item_cost_actual}    Multiplication with price round 2    ${item_cost_cb}    ${item_dvqd}
    \    ${item_gianhap}    Run Keyword If    ${item_slphieunhap_cb} == 0    Set Variable    ${item_cost_actual}
    \    ...    ELSE    Set Variable    ${item_lastprice_actual_bf}
    \    ${list_giamoi}    ${result_thanhtien}    Computation list result price - total value in case return multi row    ${item_num_actual}    ${item_change}    ${item_change_type}      ${item_gianhap}
    \    ${result_num}    Sum values in list    ${item_num_actual}
    \    ${result_num_cb}    Multiplication for onhand    ${item_dvqd}    ${result_num}
    \    ${result_toncuoi_cb}    Minus       ${item_onhand_cb}    ${result_num_cb}
    \    ${result_toncuoi_cb}    Evaluate    round(${result_toncuoi_cb},3)
    \    Append to list    ${list_result_thanhtien_af}    ${result_thanhtien}
    \    Append to list    ${list_result_newprice_af}    ${list_giamoi}
    \    Append to list    ${list_result_onhand_cb_af}    ${result_toncuoi_cb}
    \    Append to list    ${list_actual_num_cb}    ${result_num_cb}
    Return From Keyword    ${list_result_thanhtien_af}    ${list_result_newprice_af}    ${list_result_onhand_cb_af}    ${list_actual_num_cb}

Computation supply price of capital allocated incase purchase return by list product
    [Arguments]    ${list_product}    ${list_dongia}    ${list_num}   ${input_ggpn}    ${input_tongtienhang}
    ${get_list_dvqd}    Get list dvqd by list products    ${list_product}
    ${list_gianhap_phanbo_cb}    Create List
    ${list_num_cb}      Create List
    :FOR    ${item_pr}    ${item_dongia}   ${itemt_num}    ${item_dvqd}      IN ZIP    ${list_product}     ${list_dongia}   ${list_num}     ${get_list_dvqd}
    \    ${item_dongia_cb}   Devision    ${item_dongia}    ${item_dvqd}
    \    ${item_pbgg_cb}    Price after apllocate discount    ${item_dongia_cb}     ${input_tongtienhang}    ${input_ggpn}
    \    ${item_gianhap_cb}      Minus and round 2      ${item_dongia_cb}    ${item_pbgg_cb}
    \    ${item_num_cb}     Multiplication for onhand    ${itemt_num}    ${item_dvqd}
    \    Append to list    ${list_gianhap_phanbo_cb}      ${item_gianhap_cb}
    \    Append To List    ${list_num_cb}        ${item_num_cb}
    Return From Keyword    ${list_gianhap_phanbo_cb}     ${list_num_cb}

Computation supply price of capital allocated incase purchase return
    [Arguments]     ${list_dongia}    ${list_num}   ${input_ggpn}    ${input_tongtienhang}   ${input_dvqd}
    ${list_gianhap_phanbo_cb}    Create List
    ${list_num_cb}      Create List
    :FOR    ${item_dongia}   ${item_num}       IN ZIP       ${list_dongia}   ${list_num}
    \    ${item_dongia_cb}   Devision    ${item_dongia}    ${input_dvqd}
    \    ${item_pbgg_cb}    Price after apllocate discount    ${item_dongia_cb}     ${input_tongtienhang}    ${input_ggpn}
    \    ${item_gianhap_cb}      Minus and round 2      ${item_dongia_cb}    ${item_pbgg_cb}
    \    ${item_num_cb}     Multiplication for onhand    ${item_num}    ${input_dvqd}
    \    Append to list    ${list_gianhap_phanbo_cb}      ${item_gianhap_cb}
    \    Append To List    ${list_num_cb}        ${item_num_cb}
    Return From Keyword    ${list_gianhap_phanbo_cb}     ${list_num_cb}

Computation list supply price of capital allocated incase purchase return multi row
    [Arguments]    ${list_product}    ${list_dongia}    ${list_num}   ${input_ggpn}    ${input_tongtienhang}
    ${get_list_dvqd}    Get list dvqd by list products    ${list_product}
    ${list_gianhap_phanbo}    Create List
    ${list_num_cb}    Create List
    :FOR    ${item_product}   ${item_dongia}    ${item_num}    ${item_dvqd}    IN ZIP    ${list_product}   ${list_dongia}    ${list_num}   ${get_list_dvqd}
    \    ${item_num}    Convert String to List    ${item_num}
    \    ${item_gianhap}    ${item_num_cb}    Computation supply price of capital allocated incase purchase return      ${item_dongia}   ${item_num}   ${input_ggpn}    ${input_tongtienhang}     ${item_dvqd}
    \    Append to list    ${list_gianhap_phanbo}    ${item_gianhap}
    \    Append To List    ${list_num_cb}    ${item_num_cb}
    Return From Keyword    ${list_gianhap_phanbo}   ${list_num_cb}

Computation list total value in case of multi row product
    [Arguments]    ${list_nums}    ${list_price}
    ${list_thanhtien}    Create List
    : FOR    ${item_num}    ${item_price}    IN ZIP    ${list_nums}    ${list_price}
    \    ${thanhtien}    Multiplication and round    ${item_num}    ${item_price}
    \    Append To List    ${list_thanhtien}    ${thanhtien}
    ${result_thanhtien}    Sum values in list    ${list_thanhtien}
    Return From Keyword     ${result_thanhtien}

Get list of total purchase return by receipt - result onhand actual product in case of multi row product
    [Arguments]    ${input_list_product_cb}    ${input_list_actualproduct}    ${input_list_num}    ${input_list_price}
    ${list_result_thanhtien_af}    Create list
    ${list_result_onhand_cb_af}    Create list
    ${list_actual_num_cb}    Create List
    ${get_list_onhand_cb_bf_purchase}     Get list onhand frm API    ${input_list_product_cb}
    ${get_list_onhand_actual_bf_purchase}    ${get_list_lastprice_actual_bf_purchase}    ${get_list_cost_actual_bf_purchase}    ${get_list_dvqd}    Get list of Onhand, LastestPurchasePrice and Cost - Conversation values by searching product API    ${input_list_actualproduct}
    : FOR     ${item_num_actual}    ${item_gianhap}       ${item_onhand_cb}
    ...     ${item_onhand_actual_bf}     ${item_dvqd}    IN ZIP
    ...    ${input_list_num}    ${input_list_price}      ${get_list_onhand_cb_bf_purchase}
    ...    ${get_list_onhand_actual_bf_purchase}       ${get_list_dvqd}
    \    ${item_num_actual}    Convert string to list    ${item_num_actual}
    \    ${result_thanhtien}    Computation list total value in case of multi row product    ${item_num_actual}    ${item_gianhap}
    \    ${result_num}    Sum values in list    ${item_num_actual}
    \    ${result_num_cb}    Multiplication for onhand    ${item_dvqd}    ${result_num}
    \    ${result_toncuoi_cb}    Minus      ${item_onhand_cb}    ${result_num_cb}
    \    ${result_toncuoi_cb}   Evaluate    round(${result_toncuoi_cb},3)
    \    Append to list    ${list_result_thanhtien_af}    ${result_thanhtien}
    \    Append to list    ${list_result_onhand_cb_af}    ${result_toncuoi_cb}
    \    Append to list    ${list_actual_num_cb}    ${result_num_cb}
    Return From Keyword    ${list_result_thanhtien_af}      ${list_result_onhand_cb_af}    ${list_actual_num_cb}

Assert values by purchaser return code
    [Arguments]     ${purchase_return_code}     ${input_tongtienhang}     ${input_tongtien_tru_gg}      ${input_tientra_ncc}     ${input_trangthai}
    ${quantity_total}    ${payment_return_total}    ${supplier_need_pay}    ${supplier_payment}    ${status}    Get Purchase Return Info    ${purchase_return_code}
    Should Be Equal As Numbers    ${payment_return_total}    ${input_tongtienhang}
    Should Be Equal As Numbers    ${supplier_need_pay}    ${input_tongtien_tru_gg}
    Should Be Equal As Numbers    ${supplier_payment}    ${input_tientra_ncc}
    Should Be Equal As Strings    ${status}    ${input_trangthai}

Assert values by purchaser return code until succeed
    [Arguments]     ${purchase_return_code}     ${input_tongtienhang}     ${input_tongtien_tru_gg}      ${input_tientra_ncc}     ${input_trangthai}
    Wait Until Keyword Succeeds    5x    3s    Assert values by purchaser return code    ${purchase_return_code}     ${input_tongtienhang}     ${input_tongtien_tru_gg}      ${input_tientra_ncc}     ${input_trangthai}
