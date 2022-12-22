*** Settings ***
Library           Collections
Library           RequestsLibrary
Library           SeleniumLibrary
Library           OperatingSystem
Library           String
Library           StringFormat
Library           JSONLibrary
Resource          ../share/computation.robot
Resource          api_access.robot
Resource          api_danhmuc_hanghoa.robot
Resource          api_nha_cung_cap.robot
Resource          ../share/list_dictionary.robot
Resource          ../../prepare/Hang_hoa/Sources/hanghoa.robot
Resource          ../../prepare/Hang_hoa/Sources/giaodich.robot
Resource          ../Giao_dich/nhaphang_getandcompute.robot
Resource          ../../prepare/Hang_hoa/Sources/doitac.robot

*** Variables ***
${endpoint_phieu_dat_hang_nhap}    /ordersuppliers?format=json&Includes=Branch&Includes=Total&Includes=PaidAmount&Includes=TotalQuantity&Includes=TotalProductType&Includes=SubTotal&Includes=Supplier&Includes=User&ForSummaryRow=true&Includes=User1&Includes=PurchaseOrders&%24inlinecount=allpages&%24top=15&%24filter=(BranchId+eq+{0}+and+(Status+eq+0+or+Status+eq+1+or+Status+eq+2+or+Status+eq+3)+and+OrderDate+eq+%27thisweek%27)
${endpoint_phieu_dat_hang_nhap_co_status_huy}    /ordersuppliers?format=json&Includes=Branch&Includes=Total&Includes=PaidAmount&Includes=TotalQuantity&Includes=TotalProductType&Includes=SubTotal&Includes=Supplier&Includes=User&ForSummaryRow=true&Includes=User1&Includes=PurchaseOrders&%24inlinecount=allpages&%24top=15&%24filter=(BranchId+eq+{0}+and+OrderDate+eq+%27month%27+and+(Status+eq+0+or+Status+eq+1+or+Status+eq+2+or+Status+eq+3+or+Status+eq+4))
${endpoint_delete_phieu_dhn}    /ordersuppliers?CompareStatus=0&Id={0}
${endpoint_chi_tiet_phieu_dhn}    /OrderSuppliers/{0}/details?format=json&Includes=Product&Includes=Product&isFilter=true&%24inlinecount=allpages&%24top=10
${endpoint_lichsu_nhaphang}    /purchaseOrders?OrderSupplierCode={0}&format=json&Includes=Branch&Includes=Total&Includes=PaidAmount&Includes=TotalQuantity&Includes=TotalProductType&Includes=SubTotal&Includes=Supplier&Includes=User&Includes=OrderSupplier&%24inlinecount=allpages
${endpoint_ketthuc_phieudhn}       /ordersuppliers/OrderSupplierFinalized
${endpoint_hanglodate}    /products/{0}/{1}/1/batchexpire?format=json&%24inlinecount=allpages&%24top=10    #pro_id,1=gtri quy doi
${endpoint_chitiet_hanghoa}    /branchs/{0}/masterproducts?format=json&Includes=ProductAttributes&ForSummaryRow=true&CategoryId=0&AttributeFilter=%5B%5D&ProductKey={1}&ProductTypes=&IsImei=2&IsFormulas=2&IsActive=true&AllowSale=&IsBatchExpireControl=2&ShelvesIds=&TrademarkIds=&StockoutDate=alltime&supplierIds=&take=15&skip=0&page=1&pageSize=15&filter%5Blogic%5D=and     #0=branchid, 1=pro_code
${endpoint_hh_by_master_product}    /branchs/{0}/products?MasterProductId={1}&kvuniqueparam=2020
${endpoint_nhaphang_by_branch}    /purchaseOrders?format=json&Includes=Branch&Includes=Total&Includes=PaidAmount&Includes=TotalQuantity&Includes=TotalProductType&Includes=SubTotal&Includes=Supplier&Includes=User&Includes=OrderSupplier&ForSummaryRow=true&Includes=User1&%24inlinecount=allpages&%24top=15&%24filter=(BranchId+eq+{0}+and+PurchaseDate+eq+%27month%27+and+(Status+eq+1+or+Status+eq+3))

*** Keywords ***
Delete purchase order code
    [Arguments]    ${ma_phieu}
    [Timeout]    3 minutes
    ${jsonpath_pur_order_id}    Format String    $..Data[?(@.Code=="{0}")].Id    ${ma_phieu}
    ${ednpoint_dhn}    Format String    ${endpoint_phieu_dat_hang_nhap}    ${BRANCH_ID}
    ${get_pur_oder_id}    Get data from API    ${ednpoint_dhn}    ${jsonpath_pur_order_id}
    ${endpoint_delete_dhn}    Format String    ${endpoint_delete_phieu_dhn}    ${get_pur_oder_id}
    Delete request thr API    ${endpoint_delete_dhn}

Get purchase order info by purchase order code
    [Arguments]    ${input_ma_phieu}
    [Timeout]    3 minutes
    ${ednpoint_dhn}    Format String    ${endpoint_phieu_dat_hang_nhap}    ${BRANCH_ID}
    ${jsonpath_id_phieu}    Format String    $..Data[?(@.Code== '{0}')].Id    ${input_ma_phieu}
    ${jsonpath_tiendatra_ncc}    Format String    $.Data[?(@.Code== '{0}')].PaidAmount    ${input_ma_phieu}
    ${jsonpath_tongtienhang}    Format String    $.Data[?(@.Code== '{0}')].SubTotal    ${input_ma_phieu}
    ${jsonpath_discount}    Format String    $.Data[?(@.Code== '{0}')].Discount    ${input_ma_phieu}
    ${jsonpath_tongcong}    Format String    $.Data[?(@.Code== '{0}')].Total    ${input_ma_phieu}
    ${jsonpath_tongsoluong}    Format String    $.Data[?(@.Code== '{0}')].TotalQuantity    ${input_ma_phieu}
    ${jsonpath_trangthai}    Format String    $.Data[?(@.Code== '{0}')].StatusValue    ${input_ma_phieu}
    ${jsonpath_ma_ncc}    Format String    $.Data[?(@.Code== '{0}')].Supplier.Code    ${input_ma_phieu}
    ${resp.pnh}    Get Request and return body    ${ednpoint_dhn}
    ${get_id_phieunhap}    Get data from response json    ${resp.pnh}    ${jsonpath_id_phieu}
    ${get_supplier_code}    Get data from response json    ${resp.pnh}    ${jsonpath_ma_ncc}
    ${get_tongtienhang}    Get data from response json    ${resp.pnh}    ${jsonpath_tongtienhang}
    ${get_tiendatra_ncc}    Get data from response json    ${resp.pnh}    ${jsonpath_tiendatra_ncc}
    ${get_giamgia_pn}    Get data from response json    ${resp.pnh}    ${jsonpath_discount}
    ${get_tongcong}    Get data from response json    ${resp.pnh}    ${jsonpath_tongcong}
    ${get_tongsoluong}    Get data from response json    ${resp.pnh}    ${jsonpath_tongsoluong}
    ${get_trangthai}    Get data from response json    ${resp.pnh}    ${jsonpath_trangthai}
    Return From Keyword    ${get_supplier_code}    ${get_tongtienhang}    ${get_tiendatra_ncc}    ${get_giamgia_pn}    ${get_tongcong}    ${get_tongsoluong}
    ...    ${get_trangthai}

Add new purchase order have payment thr API
    [Arguments]    ${input_supplier_code}    ${dict_product_num}    ${dict_newprice}    ${dict_discount}    ${dict_discount1_type}    ${input_discount}
    ...    ${input_tientrancc}
    ## Get info ton cuoi, cong no khach hang
    ${list_product}    Get Dictionary Keys    ${dict_product_num}
    ${list_nums}    Get Dictionary Values    ${dict_product_num}
    ${list_newprice}    Get Dictionary Values    ${dict_newprice}
    ${list_discount_product}    Get Dictionary Values    ${dict_discount}
    ${list_discountproduct_type}    Get Dictionary Values    ${dict_discount1_type}
    #create lists
    ${list_result_thanhtien}    create list
    ${list_result_onhand_af_ex}    create list
    #
    ${endpoint_danhmuc_hh_by_branch}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${get_list_prd_id}    Get list product id thr API    ${list_product}
    ${list_thanhtien}    ${list_result_newprice}    ${list_result_ggsp}    Get product infor incase purchase    ${list_newprice}    ${list_discount_product}    ${list_nums}
    #
    ${result_tongtienhang}    Sum values in list    ${list_thanhtien}
    ${result_discount_invoice}    Run Keyword If    0 <= ${input_discount} <= 100    Convert % discount to VND and round    ${result_tongtienhang}    ${input_discount}
    ...    ELSE    Set Variable    ${input_discount}
    ${result_tientrancc}      Minus    ${result_tongtienhang}    ${result_discount_invoice}
    ${actual_tientrancc}    Set Variable If    '${input_tientrancc}' == 'all'    ${result_tientrancc}    ${input_tientrancc}
    Set Test Variable    \${result_tongcong_dhn}    ${result_tientrancc}
    ##
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${get_id_ncc}    Get Supplier Id    ${input_supplier_code}
    ${giamgia_hd}    Set Variable If    0 <= ${input_discount} <= 100    ${input_discount}    null
    ${result_gghd}    Run Keyword If    0 <= ${input_discount} <= 100    Convert % discount to VND    ${result_tongtienhang}    ${input_discount}
    ...    ELSE    Set Variable    ${input_discount}
    # Post request BH
    ${ma_phieu}    Generate code automatically    PDN
    ${liststring_prs_invoice_detail}    Set Variable    needdel
    Log    ${liststring_prs_invoice_detail}
    : FOR    ${item_product_id}    ${item_price}    ${item_num}    ${item_result_discountproduct}    ${item_discounttype}    ${item_thanhtien}
    ...    ${item_result_newprice}    IN ZIP    ${get_list_prd_id}    ${list_newprice}    ${list_nums}    ${list_result_ggsp}
    ...    ${list_discountproduct_type}    ${list_thanhtien}    ${list_result_newprice}
    \    ${payload_each_product}    Format string    {{"ProductId":{0},"Product":{{"Name":"Nước Hoa La Rive In Woman Eau De Parfum vial","Code":"TPC002","IsLotSerialControl":false}},"ProductName":"Nước Hoa La Rive In Woman Eau De Parfum vial","ProductCode":"TPC002","Description":"","Price":{1},"priceAfterDiscount":{2},"Quantity":{3},"ShowUnit":false,"ListProductUnit":[{{"Id":4794241,"Unit":"","Code":"TPC002","Conversion":0,"MasterUnitId":0}}],"Units":[{{"Id":4794241,"Unit":"","Code":"TPC002","Conversion":0,"MasterUnitId":0}}],"Unit":"","SelectedUnit":4794241,"OnHand":500,"OnOrder":0,"Reserved":0,"tabIndex":100,"ViewIndex":1,"rowNumber":0,"TotalValue":{4},"Discount":{5},"Allocation":31875,"AllocationSuppliers":0,"AllocationThirdParty":0,"DiscountValue":0,"DiscountType":"VND","DiscountRatio":{6},"adjustedPrice":250000,"OriginPrice":250000,"OrderByNumber":0}}    ${item_product_id}    ${item_price}    ${item_result_newprice}
    \    ...    ${item_num}    ${item_thanhtien}    ${item_result_discountproduct}    ${item_discounttype}
    \    ${liststring_prs_invoice_detail}    Catenate    SEPARATOR=,    ${liststring_prs_invoice_detail}    ${payload_each_product}
    ${liststring_prs_invoice_detail}    Replace String    ${liststring_prs_invoice_detail}    needdel,    ${EMPTY}    count=1
    ${request_payload}    Format String    {{"OrderSupplier":{{"ImportDate":null,"Code":"{0}","OrderSupplierDetails":[{11}],"UserId":{1},"CompareUserId":{1},"User":{{"id":{1},"username":"admin","givenName":"admin","Id":{1},"UserName":"admin","GivenName":"admin","IsAdmin":true,"IsLimitedByTrans":false,"IsShowSumRow":true,"Theme":""}},"Description":"","Supplier":{{"TotalInvoiced":0,"CompareCode":"{2}","CompareName":"NXB Nhã Nam","ComparePhone":"0977654892","Id":{3},"Name":"NXB Nhã Nam","Phone":"0977654892","RetailerId":{4},"Code":"NCC0003","CreatedDate":"2019-05-25T15:49:08.4300000+07:00","CreatedBy":20447,"Debt":-1519440,"LocationName":"","WardName":"","BranchId":{5},"isDeleted":false,"isActive":true,"SearchNumber":"0977654892","PurchaseOrders":[],"PurchaseReturns":[],"PurchasePayments":[],"SupplierGroupDetails":[],"OrderSuppliers":[]}},"SupplierId":{3},"CompareSupplierId":0,"SubTotal":{9},"Branch":{{"id":{5},"name":"Chi nhánh trung tâm","Id":{5},"Name":"Chi nhánh trung tâm","Address":"abc","LocationName":"Hà Nội - Quận Cầu Giấy","WardName":"","ContactNumber":"","SubContactNumber":""}},"Status":0,"StatusValue":"Phiếu tạm","CompareStatusValue":"Phiếu tạm","Discount":{6},"CompareDiscount":0,"DiscountRatio":{7},"Id":0,"Account":{{}},"Total":{10},"TotalQuantity":5,"ExpensesOthersTitle":"","ExpensesOthersRtpTitle":"","OrderSupplierExpensesOthers":[],"OrderSupplierExpensesOthersRs":[],"OrderSupplierExpensesOthersRtp":[],"ExReturnSuppliers":0,"ExReturnThirdParty":0,"PaidAmount":0,"PayingAmount":{8},"ChangeAmount":-858681,"paymentMethod":"","BalanceDue":{10},"paymentReturnType":0,"OriginTotal":{10},"paymentMethodObj":null,"DiscountRatioWoRound":{7},"DiscountWoRound":{6},"PurchaseOrderExpenssaveDataesOthers":[],"PurchasePayments":[{{"Amount":{8},"Method":"Cash"}}],"BranchId":{5}}},"Complete":true,"CopyFrom":0}}    ${ma_phieu}    ${get_id_nguoiban}    ${input_supplier_code}    ${get_id_ncc}
    ...    ${get_id_nguoitao}    ${BRANCH_ID}    ${result_gghd}    ${giamgia_hd}    ${actual_tientrancc}    ${result_tongtienhang}
    ...    ${result_tientrancc}    ${liststring_prs_invoice_detail}
    Log    ${request_payload}
    Wait Until Keyword Succeeds    3 times    3s    Post request to create purchase order and get resp    ${request_payload}
    Return From Keyword    ${ma_phieu}

Post request to create purchase order and get resp
    [Arguments]    ${request_payload}
    [Timeout]    3 minutes
    Post request thr API    /ordersuppliers    ${request_payload}

Get purchase order id frm API
    [Arguments]    ${ma_phieu}
    [Timeout]    3 minutes
    ${jsonpath_pur_order_id}    Format String    $..Data[?(@.Code=="{0}")].Id    ${ma_phieu}
    ${ednpoint_dhn}    Format String    ${endpoint_phieu_dat_hang_nhap}    ${BRANCH_ID}
    ${get_pur_oder_id}    Get data from API    ${ednpoint_dhn}    ${jsonpath_pur_order_id}
    Return From Keyword    ${get_pur_oder_id}

Get list infor in purchase order detail frm API
    [Arguments]    ${ma_phieu}    ${list_prs}
    [Timeout]    3 minutes
    ${get_pur_id}    Get purchase order id frm API    ${ma_phieu}
    ${endpoint_detail}    Format String    ${endpoint_chi_tiet_phieu_dhn}    ${get_pur_id}
    ${resp}    Get Request and return body    ${endpoint_detail}
    ${get_list_pr_id}    Get list product id thr API    ${list_prs}
    ${list_qty}    Create List
    ${list_total}    Create List
    ${list_price_af_discount}    Create List
    : FOR    ${item_pr}    IN ZIP    ${get_list_pr_id}
    \    ${jsonpath_qty}    Format String    $..Data[?(@.ProductId=={0})].Quantity    ${item_pr}
    \    ${jsonpath_total}    Format String    $..Data[?(@.ProductId== {0})].SubTotal    ${item_pr}
    \    ${jsonpath_price}    Format String    $..Data[?(@.ProductId== {0})].Price    ${item_pr}
    \    ${jsonpath_discount}    Format String    $..Data[?(@.ProductId== {0})].Discount    ${item_pr}
    \    ${get_qty}    Get data from response json    ${resp}    ${jsonpath_qty}
    \    ${get_total}    Get data from response json    ${resp}    ${jsonpath_total}
    \    ${get_price}    Get data from response json    ${resp}    ${jsonpath_price}
    \    ${get_discount}    Get data from response json    ${resp}    ${jsonpath_discount}
    \    ${price_af_discount}    Minus    ${get_price}    ${get_discount}
    \    Append To List    ${list_qty}    ${get_qty}
    \    Append To List    ${list_total}    ${get_total}
    \    Append To List    ${list_price_af_discount}    ${price_af_discount}
    Return From Keyword    ${list_price_af_discount}    ${list_qty}    ${list_total}

Get purchase order summary thr api
    [Arguments]    ${ma_phieu}
    [Timeout]    3 minutes
    ${jsonpath_tong_soluong}    Format String    $..Data[?(@.Code=="{0}")].TotalQty    ${ma_phieu}
    ${jsonpath_tongtienhang}    Format String    $..Data[?(@.Code=="{0}")].TotalAmt    ${ma_phieu}
    ${jsonpath_datrancc}    Format String    $..Data[?(@.Code=="{0}")].TotalPayment    ${ma_phieu}
    ${jsonpath_cantrancc}    Format String    $..Data[?(@.Code=="{0}")].Total    ${ma_phieu}
    ${jsonpath_giamgia_vnd}    Format String    $..Data[?(@.Code=="{0}")].Discount    ${ma_phieu}
    ${jsonpath_giamgiat_%}    Format String    $..Data[?(@.Code=="{0}")].DiscountRatio    ${ma_phieu}
    ${ednpoint_dhn}    Format String    ${endpoint_phieu_dat_hang_nhap}    ${BRANCH_ID}
    ${resp}    Get Request and return body    ${ednpoint_dhn}
    ${get_soluong}    Get data from response json    ${resp}    ${jsonpath_tong_soluong}
    ${get_tongtienhang}    Get data from response json    ${resp}    ${jsonpath_tongtienhang}
    ${get_datrancc}    Get data from response json    ${resp}    ${jsonpath_datrancc}
    ${get_cantrancc}    Get data from response json    ${resp}    ${jsonpath_cantrancc}
    ${get_giamgia_vnd}    Get data from response json    ${resp}    ${jsonpath_giamgia_vnd}
    ${get_giamgia_%}    Get data from response json    ${resp}    ${jsonpath_giamgiat_%}
    #${get_giamgai}    Set Variable If    0<${get_giamgia_%}<=100    ${get_giamgia_%}    ${get_giamgia_vnd}
    Return From Keyword    ${get_soluong}    ${get_tongtienhang}    ${get_giamgia_vnd}    ${get_giamgia_%}    ${get_datrancc}    ${get_cantrancc}
    [Teardown]

Add new purchase order no payment thr API
    [Arguments]    ${input_supplier_code}    ${dict_product_num}    ${dict_newprice}    ${dict_discount}    ${dict_discount1_type}    ${input_discount}
    [Timeout]    3 minutes
    ## Get info ton cuoi, cong no khach hang
    ${list_product}    Get Dictionary Keys    ${dict_product_num}
    ${list_nums}    Get Dictionary Values    ${dict_product_num}
    ${list_newprice}    Get Dictionary Values    ${dict_newprice}
    ${list_discount_product}    Get Dictionary Values    ${dict_discount}
    ${list_discountproduct_type}    Get Dictionary Values    ${dict_discount1_type}
    #create lists
    ${list_result_thanhtien}    create list
    ${list_result_onhand_af_ex}    create list
    #
    ${endpoint_danhmuc_hh_by_branch}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${get_list_prd_id}    Get list product id thr API    ${list_product}
    ${list_thanhtien}    ${list_result_newprice}    ${list_result_ggsp}    Get product infor incase purchase    ${list_newprice}    ${list_discount_product}    ${list_nums}
    #
    ${result_tongtienhang}    Sum values in list    ${list_thanhtien}
    ${result_discount_invoice}    Run Keyword If    0 <= ${input_discount} <= 100    Convert % discount to VND and round    ${result_tongtienhang}    ${input_discount}
    ...    ELSE    Set Variable    ${input_discount}
    ${result_tientrancc}      Minus    ${result_tongtienhang}    ${result_discount_invoice}
    Set Test Variable    \${result_tongcong_dhn}    ${result_tientrancc}
    ##
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${get_id_ncc}    Get Supplier Id    ${input_supplier_code}
    ${giamgia_hd}    Set Variable If    0 <= ${input_discount} <= 100    ${input_discount}    null
    ${result_gghd}    Run Keyword If    0 <= ${input_discount} <= 100    Convert % discount to VND    ${result_tongtienhang}    ${input_discount}
    ...    ELSE    Set Variable    ${input_discount}
    # Post request BH
    ${ma_phieu}    Generate code automatically    PDN
    ${liststring_prs_invoice_detail}    Set Variable    needdel
    Log    ${liststring_prs_invoice_detail}
    : FOR    ${item_product_id}    ${item_price}    ${item_num}    ${item_result_discountproduct}    ${item_discounttype}    ${item_thanhtien}
    ...    ${item_result_newprice}    IN ZIP    ${get_list_prd_id}    ${list_newprice}    ${list_nums}    ${list_result_ggsp}
    ...    ${list_discountproduct_type}    ${list_thanhtien}    ${list_result_newprice}
    \    ${payload_each_product}    Format string    {{"ProductId":{0},"Product":{{"Name":"Nước Hoa La Rive In Woman Eau De Parfum vial","Code":"TPC002","IsLotSerialControl":false}},"ProductName":"Nước Hoa La Rive In Woman Eau De Parfum vial","ProductCode":"TPC002","Description":"","Price":{1},"priceAfterDiscount":{2},"Quantity":{3},"ShowUnit":false,"ListProductUnit":[{{"Id":4794241,"Unit":"","Code":"TPC002","Conversion":0,"MasterUnitId":0}}],"Units":[{{"Id":4794241,"Unit":"","Code":"TPC002","Conversion":0,"MasterUnitId":0}}],"Unit":"","SelectedUnit":4794241,"OnHand":500,"OnOrder":0,"Reserved":0,"tabIndex":100,"ViewIndex":1,"rowNumber":0,"TotalValue":{4},"Discount":{5},"Allocation":31875,"AllocationSuppliers":0,"AllocationThirdParty":0,"DiscountValue":0,"DiscountType":"VND","DiscountRatio":{6},"adjustedPrice":250000,"OriginPrice":250000,"OrderByNumber":0}}    ${item_product_id}    ${item_price}    ${item_result_newprice}
    \    ...    ${item_num}    ${item_thanhtien}    ${item_result_discountproduct}    ${item_discounttype}
    \    ${liststring_prs_invoice_detail}    Catenate    SEPARATOR=,    ${liststring_prs_invoice_detail}    ${payload_each_product}
    ${liststring_prs_invoice_detail}    Replace String    ${liststring_prs_invoice_detail}    needdel,    ${EMPTY}    count=1
    ${request_payload}    Format String    {{"OrderSupplier":{{"ImportDate":null,"Code":"{0}","OrderSupplierDetails":[{10}],"UserId":{1},"CompareUserId":{1},"User":{{"id":{1},"username":"admin","givenName":"admin","Id":{1},"UserName":"admin","GivenName":"admin","IsAdmin":true,"IsLimitedByTrans":false,"IsShowSumRow":true,"Theme":""}},"Description":"","Supplier":{{"TotalInvoiced":0,"CompareCode":"{2}","CompareName":"Hoa quả sạch tiki","ComparePhone":"0977654891","Id":{3},"Name":"Hoa quả sạch tiki","Phone":"0977654891","RetailerId":{4},"Code":"{3}","CreatedDate":"2019-05-25T15:49:07.3600000+07:00","CreatedBy":20447,"Debt":-2983563,"LocationName":"","WardName":"","BranchId":{5},"isDeleted":false,"isActive":true,"SearchNumber":"0977654891","PurchaseOrders":[],"PurchaseReturns":[],"PurchasePayments":[],"SupplierGroupDetails":[],"OrderSuppliers":[]}},"SupplierId":{3},"CompareSupplierId":0,"SubTotal":{8},"Branch":{{"id":{5},"name":"Chi nhánh trung tâm","Id":{5},"Name":"Chi nhánh trung tâm","Address":"abc","LocationName":"Hà Nội - Quận Cầu Giấy","WardName":"","ContactNumber":"","SubContactNumber":""}},"Status":0,"StatusValue":"Phiếu tạm","CompareStatusValue":"Phiếu tạm","Discount":{6},"CompareDiscount":0,"DiscountRatio":{7},"Id":0,"Account":{{}},"Total":{9},"TotalQuantity":4,"ExpensesOthersTitle":"","ExpensesOthersRtpTitle":"","OrderSupplierExpensesOthers":[],"OrderSupplierExpensesOthersRs":[],"OrderSupplierExpensesOthersRtp":[],"ExReturnSuppliers":0,"ExReturnThirdParty":0,"PaidAmount":0,"PayingAmount":0,"ChangeAmount":-{9},"paymentMethod":"","BalanceDue":{9},"paymentReturnType":0,"OriginTotal":{9},"paymentMethodObj":null,"DiscountRatioWoRound":{7},"DiscountWoRound":{6},"PurchaseOrderExpenssaveDataesOthers":[],"BranchId":{5}}},"Complete":true,"CopyFrom":0}}    ${ma_phieu}    ${get_id_nguoiban}    ${input_supplier_code}    ${get_id_ncc}
    ...    ${get_id_nguoitao}    ${BRANCH_ID}    ${result_gghd}    ${giamgia_hd}    ${result_tongtienhang}    ${result_tientrancc}
    ...    ${liststring_prs_invoice_detail}
    Log    ${request_payload}
    Wait Until Keyword Succeeds    3 times    3s    Post request to create purchase order and get resp    ${request_payload}
    Return From Keyword    ${ma_phieu}

Add new purchase order no payment without supplier
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
    ${ma_phieu}    Generate code automatically    PDN
    ${liststring_prs_purchase_detail}    Set Variable    needdel
    Log    ${liststring_prs_purchase_detail}
    : FOR    ${item_product_id}    ${item_price}    ${item_num}     ${item_thanhtien}    IN ZIP    ${get_list_prd_id}    ${get_list_baseprice}    ${list_nums}
    ...    ${list_thanhtien}
    \    ${payload_each_product}    Format string    {{"ProductId":{0},"Product":{{"Name":"Nước Hoa La Rive In Woman Eau De Parfum vial","Code":"TPC002","IsLotSerialControl":false}},"ProductName":"Nước Hoa La Rive In Woman Eau De Parfum vial","ProductCode":"TPC002","Description":"","Price":{1},"priceAfterDiscount":{1},"Quantity":{2},"ShowUnit":false,"ListProductUnit":[{{"Id":4794241,"Unit":"","Code":"TPC002","Conversion":0,"MasterUnitId":0}}],"Units":[{{"Id":4794241,"Unit":"","Code":"TPC002","Conversion":0,"MasterUnitId":0}}],"Unit":"","SelectedUnit":4794241,"OnHand":500,"OnOrder":0,"Reserved":0,"tabIndex":100,"ViewIndex":1,"rowNumber":0,"TotalValue":{3},"Discount":0,"Allocation":31875,"AllocationSuppliers":0,"AllocationThirdParty":0,"DiscountValue":0,"DiscountType":"VND","DiscountRatio":0,"adjustedPrice":250000,"OriginPrice":250000,"OrderByNumber":0}}    ${item_product_id}    ${item_price}    ${item_num}    ${item_thanhtien}
    \    ${liststring_prs_purchase_detail}    Catenate    SEPARATOR=,    ${liststring_prs_purchase_detail}    ${payload_each_product}
    ${liststring_prs_purchase_detail}    Replace String    ${liststring_prs_purchase_detail}    needdel,    ${EMPTY}    count=1
    ${request_payload}    Format String    {{"OrderSupplier":{{"ImportDate":null,"Code":"{0}","OrderSupplierDetails":[{1}],"UserId":{2},"CompareUserId":{2},"User":{{"id":{2},"username":"admin","givenName":"anh.lv","Id":{2},"UserName":"admin","GivenName":"anh.lv","IsAdmin":true,"IsLimitedByTrans":false,"IsShowSumRow":true,"Theme":""}},"Description":"","CompareSupplierId":0,"SubTotal":{3},"Branch":{{"id":{4},"name":"Chi nhánh trung tâm","Id":{4},"Name":"Chi nhánh trung tâm","Address":"Hòa An","LocationName":"Đà Nẵng - Quận Cẩm Lệ","WardName":"","ContactNumber":"","SubContactNumber":""}},"Status":0,"StatusValue":"Phiếu tạm","CompareStatusValue":"Phiếu tạm","Discount":0,"CompareDiscount":0,"DiscountRatio":0,"Id":0,"Account":{{}},"Total":{3},"TotalQuantity":1,"ExpensesOthersTitle":"","ExpensesOthersRtpTitle":"","OrderSupplierExpensesOthers":[],"OrderSupplierExpensesOthersRs":[],"OrderSupplierExpensesOthersRtp":[],"ExReturnSuppliers":0,"ExReturnThirdParty":0,"PaidAmount":0,"PayingAmount":0,"ChangeAmount":-500000,"paymentMethod":"","BalanceDue":{3},"paymentReturnType":0,"OriginTotal":{3},"paymentMethodObj":null,"PurchaseOrderExpenssaveDataesOthers":[],"BranchId":{4}}},"Complete":true,"CopyFrom":0}}    ${ma_phieu}    ${liststring_prs_purchase_detail}    ${get_id_nguoiban}
    ...    ${result_tongtienhang}    ${BRANCH_ID}
    Log    ${request_payload}
    Wait Until Keyword Succeeds    3 times    3s    Post request to create purchase order and get resp    ${request_payload}
    Return From Keyword    ${ma_phieu}

Get list product in purchase order frm API
    [Arguments]    ${ma_phieu}
    [Timeout]    3 minutes
    ${get_order_id}    Get purchase order id frm API    ${ma_phieu}
    ${endpoint_dhn}    Format String    ${endpoint_chi_tiet_phieu_dhn}    ${get_order_id}
    ${get_list_prs}    Get raw data from API    ${endpoint_dhn}    $.Data..Code
    Return From Keyword    ${get_list_prs}

Get list order quality in purchase order frm API
    [Arguments]    ${ma_phieu}    ${list_prs}
    [Timeout]    3 minutes
    ${get_order_id}    Get purchase order id frm API    ${ma_phieu}
    ${get_list_id_psr}    Get list product id thr API    ${list_prs}
    ${endpoint_dhn}    Format String    ${endpoint_chi_tiet_phieu_dhn}    ${get_order_id}
    ${resp}    Get Request and return body    ${endpoint_dhn}
    ${list_order_qty}    Create List
    : FOR    ${item_id_pr}    IN ZIP    ${get_list_id_psr}
    \    ${jsonpath_order_qty}    Format String    $.Data[?(@.ProductId=={0})].OrderQuantity    ${item_id_pr}
    \    ${get_order_qty}    Get data from response json    ${resp}    ${jsonpath_order_qty}
    \    Append To List    ${list_order_qty}    ${get_order_qty}
    Return From Keyword    ${list_order_qty}

Validate purchase receipt history frm purchase order
    [Arguments]    ${ma_phieu_dat}    ${ma_phieu_nhap}
    [Timeout]    3 minutes
    ${ednpoint_lsnh}    Format String    ${endpoint_lichsu_nhaphang}    ${ma_phieu_dat}
    ${jsonpath_trang_thai}    Format String    $..Data[?(@.CompareCode== "{0}")].CompareStatusValue    ${ma_phieu_nhap}
    ${get_trang_thai}    Get data from API    ${ednpoint_lsnh}    ${jsonpath_trang_thai}
    Should Be Equal As Strings    ${get_trang_thai}    Đã nhập hàng

Add new purchase order Da xac nhan NCC no payment thr API
    [Arguments]    ${input_supplier_code}    ${dict_product_num}    ${dict_newprice}    ${dict_discount}    ${dict_discount1_type}    ${input_discount}
    [Timeout]    3 minutes
    ## Get info ton cuoi, cong no khach hang
    ${list_product}    Get Dictionary Keys    ${dict_product_num}
    ${list_nums}    Get Dictionary Values    ${dict_product_num}
    ${list_newprice}    Get Dictionary Values    ${dict_newprice}
    ${list_discount_product}    Get Dictionary Values    ${dict_discount}
    ${list_discountproduct_type}    Get Dictionary Values    ${dict_discount1_type}
    #create lists
    ${list_result_thanhtien}    create list
    ${list_result_onhand_af_ex}    create list
    #
    ${endpoint_danhmuc_hh_by_branch}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${get_list_prd_id}    Get list product id thr API    ${list_product}
    ${list_thanhtien}    ${list_result_newprice}    ${list_result_ggsp}    Get product infor incase purchase    ${list_newprice}    ${list_discount_product}    ${list_nums}
    #
    ${result_tongtienhang}    Sum values in list    ${list_thanhtien}
    ${result_discount_invoice}    Run Keyword If    0 <= ${input_discount} <= 100    Convert % discount to VND and round    ${result_tongtienhang}    ${input_discount}
    ...    ELSE    Set Variable    ${input_discount}
    ${result_tientrancc}     Minus    ${result_tongtienhang}    ${result_discount_invoice}
    Set Test Variable    \${result_tongcong_dhn}    ${result_tientrancc}
    ##
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${get_id_ncc}    Get Supplier Id    ${input_supplier_code}
    ${giamgia_hd}    Set Variable If    0 <= ${input_discount} <= 100    ${input_discount}    null
    ${result_gghd}    Run Keyword If    0 <= ${input_discount} <= 100    Convert % discount to VND    ${result_tongtienhang}    ${input_discount}
    ...    ELSE    Set Variable    ${input_discount}
    # Post request BH
    ${ma_phieu}    Generate code automatically    PDN
    ${liststring_prs_invoice_detail}    Set Variable    needdel
    Log    ${liststring_prs_invoice_detail}
    : FOR    ${item_product_id}    ${item_price}    ${item_num}    ${item_result_discountproduct}    ${item_discounttype}    ${item_thanhtien}
    ...    ${item_result_newprice}    IN ZIP    ${get_list_prd_id}    ${list_newprice}    ${list_nums}    ${list_result_ggsp}
    ...    ${list_discountproduct_type}    ${list_thanhtien}    ${list_result_newprice}
    \    ${payload_each_product}    Format string    {{"ProductId":{0},"Product":{{"Name":"Nước Hoa La Rive In Woman Eau De Parfum vial","Code":"TPC002","IsLotSerialControl":false}},"ProductName":"Nước Hoa La Rive In Woman Eau De Parfum vial","ProductCode":"TPC002","Description":"","Price":{1},"priceAfterDiscount":{2},"Quantity":{3},"ShowUnit":false,"ListProductUnit":[{{"Id":4794241,"Unit":"","Code":"TPC002","Conversion":0,"MasterUnitId":0}}],"Units":[{{"Id":4794241,"Unit":"","Code":"TPC002","Conversion":0,"MasterUnitId":0}}],"Unit":"","SelectedUnit":4794241,"OnHand":500,"OnOrder":0,"Reserved":0,"tabIndex":100,"ViewIndex":1,"rowNumber":0,"TotalValue":{4},"Discount":{5},"Allocation":31875,"AllocationSuppliers":0,"AllocationThirdParty":0,"DiscountValue":0,"DiscountType":"VND","DiscountRatio":{6},"adjustedPrice":250000,"OriginPrice":250000,"OrderByNumber":0}}    ${item_product_id}    ${item_price}    ${item_result_newprice}
    \    ...    ${item_num}    ${item_thanhtien}    ${item_result_discountproduct}    ${item_discounttype}
    \    ${liststring_prs_invoice_detail}    Catenate    SEPARATOR=,    ${liststring_prs_invoice_detail}    ${payload_each_product}
    ${liststring_prs_invoice_detail}    Replace String    ${liststring_prs_invoice_detail}    needdel,    ${EMPTY}    count=1
    ${request_payload}    Format String    {{"OrderSupplier":{{"ImportDate":null,"Code":"{0}","OrderSupplierDetails":[{10}],"UserId":{1},"CompareUserId":{1},"User":{{"id":{1},"username":"admin","givenName":"admin","Id":{1},"UserName":"admin","GivenName":"admin","IsAdmin":true,"IsLimitedByTrans":false,"IsShowSumRow":true,"Theme":""}},"Description":"","Supplier":{{"TotalInvoiced":0,"CompareCode":"{2}","CompareName":"NXB Nhã Nam","ComparePhone":"0977654892","Id":{3},"Name":"NXB Nhã Nam","Phone":"0977654892","RetailerId":{4},"Code":"{2}","CreatedDate":"2019-05-25T15:49:08.4300000+07:00","CreatedBy":{1},"Debt":-1519440,"LocationName":"","WardName":"","BranchId":{5},"isDeleted":false,"isActive":true,"SearchNumber":"0977654892","PurchaseOrders":[],"PurchaseReturns":[],"PurchasePayments":[],"SupplierGroupDetails":[],"OrderSuppliers":[]}},"SupplierId":{3},"CompareSupplierId":0,"SubTotal":{8},"Branch":{{"id":{5},"name":"Chi nhánh trung tâm","Id":{5},"Name":"Chi nhánh trung tâm","Address":"abc","LocationName":"Hà Nội - Quận Cầu Giấy","WardName":"","ContactNumber":"","SubContactNumber":""}},"Status":1,"StatusValue":"Đã xác nhận NCC","CompareStatusValue":"Phiếu tạm","Discount":{6},"CompareDiscount":0,"DiscountRatio":{7},"Id":0,"Account":{{}},"Total":{9},"TotalQuantity":5,"ExpensesOthersTitle":"","ExpensesOthersRtpTitle":"","OrderSupplierExpensesOthers":[],"OrderSupplierExpensesOthersRs":[],"OrderSupplierExpensesOthersRtp":[],"ExReturnSuppliers":0,"ExReturnThirdParty":0,"PaidAmount":0,"PayingAmount":0,"ChangeAmount":-{9},"paymentMethod":"","BalanceDue":{9},"paymentReturnType":0,"OriginTotal":{9},"paymentMethodObj":null,"DiscountRatioWoRound":{7},"DiscountWoRound":{6},"PurchaseOrderExpenssaveDataesOthers":[],"BranchId":{5}}},"Complete":true,"CopyFrom":0}}    ${ma_phieu}    ${get_id_nguoiban}    ${input_supplier_code}    ${get_id_ncc}
    ...    ${get_id_nguoitao}    ${BRANCH_ID}    ${result_gghd}    ${giamgia_hd}    ${result_tongtienhang}    ${result_tientrancc}
    ...    ${liststring_prs_invoice_detail}
    Log    ${request_payload}
    Wait Until Keyword Succeeds    3 times    3s    Post request to create purchase order and get resp    ${request_payload}
    Return From Keyword    ${ma_phieu}

Add new purchase order Da xac nhan NCC have payment thr API
    [Arguments]    ${input_supplier_code}    ${dict_product_num}    ${dict_newprice}    ${dict_discount}    ${dict_discount1_type}    ${input_discount}
    ...    ${input_tientrancc}
    [Timeout]    3 minutes
    ## Get info ton cuoi, cong no khach hang
    ${list_product}    Get Dictionary Keys    ${dict_product_num}
    ${list_nums}    Get Dictionary Values    ${dict_product_num}
    ${list_newprice}    Get Dictionary Values    ${dict_newprice}
    ${list_discount_product}    Get Dictionary Values    ${dict_discount}
    ${list_discountproduct_type}    Get Dictionary Values    ${dict_discount1_type}
    #create lists
    ${list_result_thanhtien}    create list
    ${list_result_onhand_af_ex}    create list
    #
    ${endpoint_danhmuc_hh_by_branch}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${get_list_prd_id}    Get list product id thr API    ${list_product}
    ${list_thanhtien}    ${list_result_newprice}    ${list_result_ggsp}    Get product infor incase purchase    ${list_newprice}    ${list_discount_product}    ${list_nums}
    #
    ${result_tongtienhang}    Sum values in list    ${list_thanhtien}
    ${result_discount_invoice}    Run Keyword If    0 <= ${input_discount} <= 100    Convert % discount to VND and round    ${result_tongtienhang}    ${input_discount}
    ...    ELSE    Set Variable    ${input_discount}
    ${result_tientrancc}        Minus    ${result_tongtienhang}    ${result_discount_invoice}
    ${actual_tientrancc}    Set Variable If    '${input_tientrancc}' == 'all'    ${result_tientrancc}    ${input_tientrancc}
    Set Test Variable    \${result_tongcong_dhn}    ${result_tientrancc}
    ##
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${get_id_ncc}    Get Supplier Id    ${input_supplier_code}
    ${giamgia_hd}    Set Variable If    0 <= ${input_discount} <= 100    ${input_discount}    null
    ${result_gghd}    Run Keyword If    0 <= ${input_discount} <= 100    Convert % discount to VND    ${result_tongtienhang}    ${input_discount}
    ...    ELSE    Set Variable    ${input_discount}
    # Post request BH
    ${ma_phieu}    Generate code automatically    PDN
    ${liststring_prs_invoice_detail}    Set Variable    needdel
    Log    ${liststring_prs_invoice_detail}
    : FOR    ${item_product_id}    ${item_price}    ${item_num}    ${item_result_discountproduct}    ${item_discounttype}    ${item_thanhtien}
    ...    ${item_result_newprice}    IN ZIP    ${get_list_prd_id}    ${list_newprice}    ${list_nums}    ${list_result_ggsp}
    ...    ${list_discountproduct_type}    ${list_thanhtien}    ${list_result_newprice}
    \    ${payload_each_product}    Format string    {{"ProductId":{0},"Product":{{"Name":"Nước Hoa La Rive In Woman Eau De Parfum vial","Code":"TPC002","IsLotSerialControl":false}},"ProductName":"Nước Hoa La Rive In Woman Eau De Parfum vial","ProductCode":"TPC002","Description":"","Price":{1},"priceAfterDiscount":{2},"Quantity":{3},"ShowUnit":false,"ListProductUnit":[{{"Id":4794241,"Unit":"","Code":"TPC002","Conversion":0,"MasterUnitId":0}}],"Units":[{{"Id":4794241,"Unit":"","Code":"TPC002","Conversion":0,"MasterUnitId":0}}],"Unit":"","SelectedUnit":4794241,"OnHand":500,"OnOrder":0,"Reserved":0,"tabIndex":100,"ViewIndex":1,"rowNumber":0,"TotalValue":{4},"Discount":{5},"Allocation":31875,"AllocationSuppliers":0,"AllocationThirdParty":0,"DiscountValue":0,"DiscountType":"VND","DiscountRatio":{6},"adjustedPrice":250000,"OriginPrice":250000,"OrderByNumber":0}}    ${item_product_id}    ${item_price}    ${item_result_newprice}
    \    ...    ${item_num}    ${item_thanhtien}    ${item_result_discountproduct}    ${item_discounttype}
    \    ${liststring_prs_invoice_detail}    Catenate    SEPARATOR=,    ${liststring_prs_invoice_detail}    ${payload_each_product}
    ${liststring_prs_invoice_detail}    Replace String    ${liststring_prs_invoice_detail}    needdel,    ${EMPTY}    count=1
    ${request_payload}    Format String    {{"OrderSupplier":{{"ImportDate":null,"Code":"{0}","OrderSupplierDetails":[{11}],"UserId":{1},"CompareUserId":{1},"User":{{"id":{1},"username":"admin","givenName":"admin","Id":{1},"UserName":"admin","GivenName":"admin","IsAdmin":true,"IsLimitedByTrans":false,"IsShowSumRow":true,"Theme":""}},"Description":"","Supplier":{{"TotalInvoiced":0,"CompareCode":"{2}","CompareName":"NXB Nhã Nam","ComparePhone":"0977654892","Id":{3},"Name":"NXB Nhã Nam","Phone":"0977654892","RetailerId":{4},"Code":"{2}","CreatedDate":"2019-05-25T15:49:08.4300000+07:00","CreatedBy":20447,"Debt":-1519440,"LocationName":"","WardName":"","BranchId":{5},"isDeleted":false,"isActive":true,"SearchNumber":"0977654892","PurchaseOrders":[],"PurchaseReturns":[],"PurchasePayments":[],"SupplierGroupDetails":[],"OrderSuppliers":[]}},"SupplierId":{3},"CompareSupplierId":0,"SubTotal":{9},"Branch":{{"id":{5},"name":"Chi nhánh trung tâm","Id":{5},"Name":"Chi nhánh trung tâm","Address":"abc","LocationName":"Hà Nội - Quận Cầu Giấy","WardName":"","ContactNumber":"","SubContactNumber":""}},"Status":1,"StatusValue":"Đã xác nhận NCC","CompareStatusValue":"Phiếu tạm","Discount":{6},"CompareDiscount":0,"DiscountRatio":{7},"Id":0,"Account":{{}},"Total":{10},"TotalQuantity":5,"ExpensesOthersTitle":"","ExpensesOthersRtpTitle":"","OrderSupplierExpensesOthers":[],"OrderSupplierExpensesOthersRs":[],"OrderSupplierExpensesOthersRtp":[],"ExReturnSuppliers":0,"ExReturnThirdParty":0,"PaidAmount":0,"PayingAmount":{8},"ChangeAmount":-858681,"paymentMethod":"","BalanceDue":{10},"paymentReturnType":0,"OriginTotal":{10},"paymentMethodObj":null,"DiscountRatioWoRound":{7},"DiscountWoRound":{6},"PurchaseOrderExpenssaveDataesOthers":[],"PurchasePayments":[{{"Amount":{8},"Method":"Cash"}}],"BranchId":{5}}},"Complete":true,"CopyFrom":0}}    ${ma_phieu}    ${get_id_nguoiban}    ${input_supplier_code}    ${get_id_ncc}
    ...    ${get_id_nguoitao}    ${BRANCH_ID}    ${result_gghd}    ${giamgia_hd}    ${actual_tientrancc}    ${result_tongtienhang}
    ...    ${result_tientrancc}    ${liststring_prs_invoice_detail}
    Log    ${request_payload}
    Wait Until Keyword Succeeds    3 times    3s    Post request to create purchase order and get resp    ${request_payload}
    Return From Keyword    ${ma_phieu}

Get list product order id frm purchase order detail api
    [Arguments]    ${input_ma_pdn}    ${list_product_id}
    [Timeout]    3 minutes
    ${get_id_order}    Get purchase order id frm API    ${input_ma_pdn}
    ${endpoint_orderdetail}    Format String    ${endpoint_chi_tiet_phieu_dhn}       ${get_id_order}
    ${get_resp}    Get Request and return body    ${endpoint_orderdetail}
    ${list_order_detail_id}    Create List
    : FOR    ${item_product_id}    IN    @{list_product_id}
    \    ${jsonpath_id_orderdetail}    Format String    $.Data[?(@.ProductId=={0})].Id    ${item_product_id}
    \    ${get_id_orderdetail}    Get data from response json    ${get_resp}    ${jsonpath_id_orderdetail}
    \    Append to list    ${list_order_detail_id}    ${get_id_orderdetail}
    Return From Keyword    ${list_order_detail_id}

Get list product detail in purchase order detail frm API
    [Arguments]    ${ma_phieu}    ${list_prs}
    [Timeout]    3 minutes
    ${get_pur_id}    Get purchase order id frm API    ${ma_phieu}
    ${endpoint_detail}    Format String    ${endpoint_chi_tiet_phieu_dhn}    ${get_pur_id}
    ${resp}    Get Request and return body    ${endpoint_detail}
    ${get_list_pr_id}    Get list product id thr API    ${list_prs}
    ${list_qty}    Create List
    ${list_total}    Create List
    ${list_price_af_discount}    Create List
    ${list_price_bf_discount}    Create List
    ${list_discount_vnd}      Create List
    ${list_discount_%}    Create List
    : FOR    ${item_pr}    IN ZIP    ${get_list_pr_id}
    \    ${jsonpath_qty}    Format String    $..Data[?(@.ProductId=={0})].Quantity    ${item_pr}
    \    ${jsonpath_total}    Format String    $..Data[?(@.ProductId== {0})].SubTotal    ${item_pr}
    \    ${jsonpath_price}    Format String    $..Data[?(@.ProductId== {0})].Price    ${item_pr}
    \    ${jsonpath_discount}    Format String    $..Data[?(@.ProductId== {0})].Discount    ${item_pr}
    \    ${jsonpath_discount_ratio}    Format String    $..Data[?(@.ProductId== {0})].DiscountRatio    ${item_pr}
    \    ${get_qty}    Get data from response json    ${resp}    ${jsonpath_qty}
    \    ${get_total}    Get data from response json    ${resp}    ${jsonpath_total}
    \    ${get_price}    Get data from response json    ${resp}    ${jsonpath_price}
    \    ${get_discount}    Get data from response json    ${resp}    ${jsonpath_discount}
    \    ${get_discount_%}    Get data from response json    ${resp}    ${jsonpath_discount_ratio}
    \    ${price_af_discount}    Minus    ${get_price}    ${get_discount}
    \    Append To List    ${list_qty}    ${get_qty}
    \    Append To List    ${list_total}    ${get_total}
    \    Append To List    ${list_price_af_discount}    ${price_af_discount}
    \    Append To List    ${list_price_bf_discount}    ${get_price}
    \    Append To List    ${list_discount_vnd}    ${get_discount}
    \    Append To List    ${list_discount_%}    ${get_discount_%}
    Return From Keyword    ${list_price_af_discount}    ${list_qty}    ${list_total}      ${list_price_bf_discount}     ${list_discount_vnd}        ${list_discount_%}

Add new purchase order no payment with supplier
    [Arguments]    ${ma_ncc}      ${dict_product_num}
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
    ${get_id_ncc}   Get Supplier Id    ${ma_ncc}
    # Post request BH
    ${ma_phieu}    Generate code automatically    PDN
    ${liststring_prs_purchase_detail}    Set Variable    needdel
    Log    ${liststring_prs_purchase_detail}
    : FOR    ${item_product_id}    ${item_price}    ${item_num}     ${item_thanhtien}    IN ZIP    ${get_list_prd_id}    ${get_list_baseprice}    ${list_nums}
    ...    ${list_thanhtien}
    \    ${payload_each_product}    Format string    {{"ProductId":{0},"Product":{{"Name":"Nước Hoa La Rive In Woman Eau De Parfum vial","Code":"TPC002","IsLotSerialControl":false}},"ProductName":"Nước Hoa La Rive In Woman Eau De Parfum vial","ProductCode":"TPC002","Description":"","Price":{1},"priceAfterDiscount":{1},"Quantity":{2},"ShowUnit":false,"ListProductUnit":[{{"Id":4794241,"Unit":"","Code":"TPC002","Conversion":0,"MasterUnitId":0}}],"Units":[{{"Id":4794241,"Unit":"","Code":"TPC002","Conversion":0,"MasterUnitId":0}}],"Unit":"","SelectedUnit":4794241,"OnHand":500,"OnOrder":0,"Reserved":0,"tabIndex":100,"ViewIndex":1,"rowNumber":0,"TotalValue":{3},"Discount":0,"Allocation":31875,"AllocationSuppliers":0,"AllocationThirdParty":0,"DiscountValue":0,"DiscountType":"VND","DiscountRatio":0,"adjustedPrice":250000,"OriginPrice":250000,"OrderByNumber":0}}    ${item_product_id}    ${item_price}    ${item_num}    ${item_thanhtien}
    \    ${liststring_prs_purchase_detail}    Catenate    SEPARATOR=,    ${liststring_prs_purchase_detail}    ${payload_each_product}
    ${liststring_prs_purchase_detail}    Replace String    ${liststring_prs_purchase_detail}    needdel,    ${EMPTY}    count=1
    ${request_payload}    Format String    {{"OrderSupplier":{{"ImportDate":null,"Code":"{0}","OrderSupplierDetails":[{1}],"UserId":{2},"CompareUserId":{2},"User":{{"id":{2},"username":"admin","givenName":"admin","Id":{2},"UserName":"admin","GivenName":"admin","IsAdmin":true,"IsLimitedByTrans":false,"IsShowSumRow":true,"Theme":""}},"Description":"","Supplier":{{"IdOld":0,"TotalInvoiced":0,"CompareCode":"NCC0002","CompareName":"Hoa quả sạch tiki","ComparePhone":"0977654891","Id":${3},"Name":"Hoa quả sạch tiki","Phone":"0977654891","RetailerId":{4},"Code":"NCC0002","CreatedDate":"","CreatedBy":{2},"Debt":24555296,"LocationName":"","WardName":"","BranchId":11352,"isDeleted":false,"isActive":true,"SearchNumber":"0977654891","PurchaseOrders":[],"PurchaseReturns":[],"PurchasePayments":[],"SupplierGroupDetails":[],"OrderSuppliers":[]}},"SupplierId":{3},"CompareSupplierId":0,"SubTotal":{5},"Branch":{{"id":{6},"name":"Chi nhánh trung tâm","Id":11352,"Name":"Chi nhánh trung tâm","Address":"abc","LocationName":"Hà Nội - Quận Cầu Giấy","WardName":"","ContactNumber":"","SubContactNumber":""}},"Status":0,"StatusValue":"Phiếu tạm","CompareStatusValue":"Phiếu tạm","Discount":0,"CompareDiscount":0,"DiscountRatio":0,"Id":0,"Account":{{}},"Total":240000,"TotalQuantity":2,"ExpensesOthersTitle":"","ExpensesOthersRtpTitle":"","OrderSupplierExpensesOthers":[],"OrderSupplierExpensesOthersRs":[],"OrderSupplierExpensesOthersRtp":[],"ExReturnSuppliers":0,"ExReturnThirdParty":0,"PaidAmount":0,"PayingAmount":0,"ChangeAmount":-240000,"paymentMethod":"","BalanceDue":240000,"paymentReturnType":0,"OriginTotal":240000,"paymentMethodObj":null,"PurchaseOrderExpenssaveDataesOthers":[],"BranchId":{6}}},"Complete":true,"CopyFrom":0}}    ${ma_phieu}    ${liststring_prs_purchase_detail}    ${get_id_nguoiban}      ${get_id_ncc}
    ...    ${get_id_nguoitao}     ${result_tongtienhang}    ${BRANCH_ID}
    Log    ${request_payload}
    Wait Until Keyword Succeeds    3 times    3s    Post request to create purchase order and get resp    ${request_payload}
    Return From Keyword    ${ma_phieu}

Execute finish purchase order
    [Arguments]    ${ma_phieu}
    ${get_id_phieu}     Get purchase order id frm API    ${ma_phieu}
    ${data_payload}    Format String   {{"Id":{0},"IsFinalized":true}}    ${get_id_phieu}
    log    ${data_payload}
    Post request thr API    ${endpoint_ketthuc_phieudhn}    ${data_payload}

Assert values in purchase order code
    [Arguments]     ${ma_phieu}    ${input_supplier_code}      ${input_tongtienhang}   ${input_tientrancc}    ${input_soluong}    ${input_cantrancc}   ${input_ggpn}     ${input_trangthai}
    ${get_supplier_code}    ${get_tongtienhang}    ${get_tiendatra_ncc}    ${get_giamgia_pn}    ${get_tongcong}    ${get_tongsoluong}    ${get_trangthai}
    ...    Get purchase order info by purchase order code    ${ma_phieu}
    Should Be Equal As Strings    ${get_supplier_code}    ${input_supplier_code}
    Should Be Equal As Numbers    ${get_tongtienhang}    ${input_tongtienhang}
    Should Be Equal As Numbers    ${get_tiendatra_ncc}    ${input_tientrancc}
    Should Be Equal As Numbers    ${get_tongsoluong}    ${input_soluong}
    Should Be Equal As Numbers    ${get_tongcong}    ${input_cantrancc}
    Should Be Equal As Numbers    ${get_giamgia_pn}    ${input_ggpn}
    Should Be Equal As Strings    ${get_trangthai}    ${input_trangthai}

Assert values in purchase order code until succeed
    [Arguments]     ${ma_phieu}    ${input_supplier_code}      ${input_tongtienhang}   ${input_tientrancc}    ${input_soluong}    ${input_cantrancc}   ${input_ggpn}     ${input_trangthai}
    Wait Until Keyword Succeeds    5x    3s   Assert values in purchase order code    ${ma_phieu}    ${input_supplier_code}      ${input_tongtienhang}   ${input_tientrancc}    ${input_soluong}    ${input_cantrancc}   ${input_ggpn}     ${input_trangthai}

Get order supplier id thr API
    [Arguments]    ${ma_pn}
    [Timeout]    3 mins
    ${jsonpath_ma_pdn_id}    Format String    $..Data[?(@.Code=="{0}")].Id    ${ma_pn}
    ${endpoint_phieu_dat_hang_nhap}    Format String    ${endpoint_phieu_dat_hang_nhap}    ${BRANCH_ID}
    ${get_ma_pdn_id}    Get data from API    ${endpoint_phieu_dat_hang_nhap}    ${jsonpath_ma_pdn_id}
    Return From Keyword    ${get_ma_pdn_id}

Get status of order supplier thr API
    [Arguments]    ${ma_phieu_dhn}
    ${endpoint_pdhn}    Format String    ${endpoint_phieu_dat_hang_nhap_co_status_huy}    ${BRANCH_ID}
    ${resp}     Get Request and return body    ${endpoint_pdhn}
    ${jsonpath_status}    Format String    $..Data[?(@.Code=="{0}")].StatusValue    ${ma_phieu_dhn}
    ${get_status}    Get data from response json    ${resp}    ${jsonpath_status}
    Return From Keyword    ${get_status}

Get list order supplier details id of product
    [Arguments]    ${list_sp}
    ${list_details_id}    Create List
    ${endpoint_phieu_dat_hang_nhap}    Format String    ${endpoint_phieu_dat_hang_nhap}    ${BRANCH_ID}
    :FOR    ${item_prs}    IN ZIP    ${list_sp}
    \    ${get_id}    Get product id thr API    ${item_prs}
    \    ${json_get_id}     Format String    $.OrderSupplierDetails..[?(@.ProductId=={0})].Id    ${get_id}
    \    ${get_detais_id}    Get data from API    ${endpoint_phieu_dat_hang_nhap}    ${json_get_id}
    \    Append To List    ${list_details_id}    ${get_detais_id}
    Return From Keyword    ${list_details_id}

Get info lodate of lodate products
    [Documentation]    get id, tên lô và hạn sử dụng của hàng hóa lô date
    [Arguments]    ${list_sp}
    ${list_batch_name}    Create List
    ${list_expire_date}    Create List
    ${list_fullnamevirgule}    Create List
    ${list_batch_id}    Create List
    :FOR    ${item_prs}    IN ZIP    ${list_sp}
    \    ${get_id}    Get product id thr API    ${item_prs}
    \    ${get_gtqd}    Get conversion value of unit product    ${item_prs}
    \    ${endpoint_lodate_pro}    Format String    ${endpoint_hanglodate}    ${get_id}    ${get_gtqd}
    \    ${get_batch_id}    Get data from API    ${endpoint_lodate_pro}    $..Data[0]..Id
    \    ${get_batch_name}    Get data from API    ${endpoint_lodate_pro}    $..Data[0]..BatchName
    \    ${get_expire_date}    Get data from API    ${endpoint_lodate_pro}    $..Data[0]..ExpireDate
    \    ${get_fullnamevirgule}    Get data from API    ${endpoint_lodate_pro}    $..Data[0]..FullNameVirgule
    \    Append To List    ${list_batch_id}    ${get_batch_id}
    \    Append To List    ${list_batch_name}    ${get_batch_name}
    \    Append To List    ${list_expire_date}    ${get_expire_date}
    \    Append To List    ${list_fullnamevirgule}    ${list_fullnamevirgule}
    Return From Keyword    ${list_batch_id}    ${list_batch_name}    ${list_expire_date}    ${list_fullnamevirgule}

Add new purchase order from order suppliers
    [Documentation]    tạo phiếu nhập hàng lô date từ phiếu đặt hàng nhập
    [Arguments]    ${ma_phieu_dhn}    ${dict_product_num}    ${input_supplier_code}    ${ten_nhom}
    ${list_product}    Get Dictionary Keys    ${dict_product_num}
    ${list_nums}    Get Dictionary Values    ${dict_product_num}
    ${cate_id}    Get category ID    ${ten_nhom}
    ${list_product_name}    Get list product name thr API    ${list_product}
    ${get_list_prs_id}    Get list product id thr API    ${list_product}
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${get_id_ncc}    Get Supplier Id    ${input_supplier_code}
    ${ten_ncc}    Get supplier name frm API    ${input_supplier_code}
    ${get_id_pdhn}    Get purchase order id frm API    ${ma_phieu_dhn}
    ${get_name_ncc}    Get supplier name frm API    ${input_supplier_code}
    ${list_batch_id}    ${list_batch_name}    ${list_expire_date}    ${list_fullnamevirgule}    Get info lodate of lodate products    ${list_product}
    ${list_product_order_id}    Get list product order id frm purchase order detail api    ${ma_phieu_dhn}    ${get_list_prs_id}
    ${ma_phieu_nhap}    Generate code automatically    PN
    ${liststring_prs_order_detail}    Set Variable    needdel
    : FOR    ${item_product_order_id}    ${item_pr}    ${item_pr_id}    ${item_num}    ${item_name}    ${item_batch_id}    ${item_batch_name}    ${item_expire_date}    ${item_batch_fullname}    IN ZIP
    ...    ${list_product_order_id}    ${list_product}    ${get_list_prs_id}    ${list_nums}    ${list_product_name}    ${list_batch_id}    ${list_batch_name}    ${list_expire_date}    ${list_fullnamevirgule}
    \    ${payload_each_product}    Format string    {{"Unit":"","ListProductUnit":[],"Units":[],"SelectedUnit":{0},"ShowUnit":false,"Shelves":"","ProductBatchExpires":[{{"Id":{1},"ProductId":{0},"OnHand":52,"SystemCount":0,"BatchName":"{3}","ExpireDate":"{11}","FullNameVirgule":"{2}","Status":1,"IsExpire":false,"ReturnQuantity":0,"SellQuantity":0,"PurchaseOrderDetailId":0}}],"Id":{4},"OrderSupplierId":{4},"ProductId":{0},"Quantity":{10},"Price":112000,"Discount":25000,"Allocation":17400,"CreatedDate":"2020-12-09T17:56:49.3300000+07:00","Description":"","OrderByNumber":1,"AllocationSuppliers":0,"AllocationThirdParty":0,"OrderQuantity":1.5,"RetailerId":0,"Product":{{"IdOld":0,"CrudGuid":"","ParentUnits":[],"CategoryOld":0,"Id":{0},"Code":"{6}","Name":"{7}","CategoryId":{8},"AllowsSale":true,"BasePrice":150000,"Tax":0,"RetailerId":{9},"isActive":true,"CreatedDate":"2020-12-09T17:56:30.1700000+07:00","ProductType":2,"HasVariants":false,"Unit":"","ConversionValue":1,"OrderTemplate":"","FullName":"{7}","IsLotSerialControl":false,"IsRewardPoint":false,"isDeleted":false,"MasterCode":"SPC001027","Revision":"AAAAAA1C+1Y=","IsBatchExpireControl":true,"Formula":[],"ProductImages":[],"PurchaseReturnDetails":[],"ProductChild":[],"ProductAttributes":[],"ProductChildUnit":[],"PriceBookDetails":[],"ProductBranches":[],"TableAndRooms":[],"Manufacturings":[],"ManufacturingDetails":[],"DamageDetails":[],"ProductSerials":[],"ProductFormulaHistories":[],"OrderSupplierDetails":[],"ProductShelves":[],"PrescriptionDetails":[],"SamplePrescriptionDetails":[],"OnHand":52,"Reserved":0,"ActualReserved":0}},"ProductName":"{7}","ProductCode":"{6}","SubTotal":130500,"Reserved":0,"OnHand":52,"OnOrder":0,"ActualReserved":0,"tabIndex":100,"ViewIndex":2,"TotalValue":87000,"allSuggestSerial":[],"ProductBatchExpireList":[{{"Id":{1},"BatchName":"{3}","FullNameVirgule":"{2}","ExpireDate":"{11}","DisplayType":1,"Status":1,"IsUpdate":1,"OnHand":1,"SystemCount":52}}]}}
    \    ...    ${item_pr_id}    ${item_batch_id}    ${item_batch_fullname}    ${item_batch_name}    ${item_product_order_id}    ${get_id_pdhn}    ${item_pr}    ${item_name}    ${cate_id}    ${get_id_nguoitao}    ${item_num}    ${item_expire_date}
    \    ${liststring_prs_order_detail}    Catenate    SEPARATOR=,    ${liststring_prs_order_detail}    ${payload_each_product}
    Log    ${liststring_prs_order_detail}
    ${liststring_prs_order_detail}    Replace String    ${liststring_prs_order_detail}    needdel,    ${EMPTY}    count=1
    ${request_payload}    Format String    {{"PurchaseOrder":{{"Code":"{0}","OrderSupplierCode":"{1}","OrderSupplierId":"{2}","PurchaseOrderDetails":[{9}],"UserId":{3},"CompareUserId":{3},"User":{{"IdOld":0,"CompareGivenName":"thao11","CompareIsLimitedByTrans":false,"CompareIsShowSumRow":true,"CompareUserName":"admin","IsTimeSheetException":false,"Id":{3},"Email":"tthao@gmail.com","GivenName":"thao11","CreatedDate":"2020-09-07T11:58:15.7430000+07:00","IsActive":true,"IsAdmin":true,"RetailerId":{7},"UserName":"admin","Type":0,"CreatedBy":0,"CanAccessAnySite":false,"Language":"vi-VN","LocationName":"","WardName":"","isDeleted":false,"Permissions":[],"Apps":[],"Invoices":[],"Transfers1":[],"PriceBookUsers":[],"CashFlows":[],"Invoices1":[],"Orders":[],"Returns1":[],"Manufacturings":[],"DamageItems":[],"TokenApis":[],"SmsEmailTemplates":[],"BalanceAdjustments1":[],"PointAdjustments":[],"PointAdjustmentsCreatedBy":[],"NotificationSettings":[],"DamageItems1":[],"PurchaseOrders1":[],"PurchaseReturns1":[],"CostAdjustments":[],"Devices":[],"OrderSuppliers":[],"OrderSuppliers1":[],"UserDevices":[],"PayslipPayments":[],"PayslipPaymentAllocations":[]}},"CreatedDate":"2020-12-09T10:56:59.277Z","Description":"","Supplier":{{"IdOld":0,"TotalInvoiced":0,"CompareCode":"{4}","CompareName":"{5}","ComparePhone":"0989234816","Id":{6},"Name":"{5}","Phone":"0989234816","RetailerId":{7},"Code":"{4}","CreatedDate":"2020-12-09T17:56:45.3230000+07:00","CreatedBy":{3},"LocationName":"","WardName":"","BranchId":{8},"isDeleted":false,"isActive":true,"SearchNumber":"0989234816","PurchaseOrders":[],"PurchaseReturns":[],"PurchasePayments":[],"SupplierGroupDetails":[],"OrderSuppliers":[]}},"SupplierId":{6},"CompareSupplierId":{6},"SubTotal":252877,"Branch":{{"Id":{8},"Name":"Chi nhánh trung tâm","Type":0,"Address":"1b Yết kiêu","Province":"Hà Nội","District":"Quận Hoàn Kiếm","ContactNumber":"0379089988","IsActive":true,"RetailerId":{7},"CreatedBy":0,"LimitAccess":false,"LocationName":"Hà Nội - Quận Hoàn Kiếm","WardName":"Phường Trần Hưng Đạo","isAcceptBookClosing":false,"GmbStatus":1,"Orders":[],"Transfers1":[],"DamageItems":[],"SurchargeBranches":[],"AdrApplications":[],"Customers":[],"Suppliers":[],"ExpensesOtherBranches":[],"OrderSuppliers":[],"WarrantyBranchGroups":[],"BranchTakingAddresses":[],"Patients":[],"Clinics":[],"Doctors":[],"DoctorQualifications":[],"DoctorSpecialities":[],"Prescriptions":[],"PayslipPayments":[],"PayslipPaymentAllocations":[],"IdOld":0,"TotalUser":0,"CompareBranchName":"Chi nhánh trung tâm","StatusGmbValue":"Chưa đăng ký","IsTimeSheetException":false,"LocationId":0,"WardId":0}},"Status":1,"StatusValue":"Phiếu tạm","CompareStatusValue":"Phiếu tạm","Discount":50575,"CompareDiscount":139333,"DiscountRatio":20,"Id":0,"UpdatePurchaseId":0,"Account":{{}},"Total":202302,"TotalQuantity":3.5,"ExpensesOthersTitle":"","ExpensesOthersRtpTitle":"","PurchaseOrderExpensesOthers":[],"PurchaseOrderExpensesOthersRs":[],"PurchaseOrderExpensesOthersRtp":[],"PurchasePayments":[],"ExReturnSuppliers":0,"ExReturnThirdParty":0,"PaidAmount":0,"PayingAmount":0,"ChangeAmount":-202302,"paymentMethod":"","BalanceDue":202302,"DepositReturn":202302,"OriginTotal":202302,"PricebookDetail":[],"paymentMethodObj":null,"paymentReturnType":0,"Uuid":"","BranchId":{8}}},"PurchaseOrderLargeData":null,"Complete":true,"CopyFrom":0,"PricebookDetail":[],"IsFinalizedOS":false}}
    ...    ${ma_phieu_nhap}    ${ma_phieu_dhn}    ${get_id_pdhn}    ${get_id_nguoiban}    ${input_supplier_code}    ${ten_ncc}    ${get_id_ncc}    ${get_id_nguoitao}    ${BRANCH_ID}    ${liststring_prs_order_detail}
    Log    ${request_payload}
    Post request thr API    /purchaseOrders     ${request_payload}
    Return From Keyword    ${ma_phieu_nhap}

Add product for tracking by product type thr API
    [Arguments]      ${loai_hh}   ${ma_hh}    ${ten_sp}   ${nhom_hang}   ${gia_ban}    ${gia_von}    ${ton}     ${sp_1}    ${sl_1}    ${sp_2}    ${sl_2}    ${dvcb}    ${ma_hh_qd}    ${giaban2}    ${dvqd}    ${giatriqd}
    Run Keyword If   '${loai_hh}'=='pro'    Add product thr API   ${ma_hh}    ${ten_sp}    ${nhom_hang}   ${gia_ban}    ${gia_von}     ${ton}
    ...     ELSE IF   '${loai_hh}'=='imei'      Add imei product thr API    ${ma_hh}    ${ten_sp}    ${nhom_hang}   ${gia_ban}
    ...     ELSE IF     '${loai_hh}'=='lodate'     Add lodate product thr API    ${ma_hh}    ${ten_sp}   ${nhom_hang}   ${gia_ban}
    ...     ELSE IF     '${loai_hh}'=='combo'     Add combo and wait    ${ma_hh}    ${ten_sp}   ${nhom_hang}   ${gia_ban}     ${sp_1}   ${sl_1}   ${sp_2}   ${sl_2}
    ...     ELSE IF     '${loai_hh}'=='lodate_unit'      Add lodate product incl 2 unit thr API    ${ma_hh}    ${ten_sp}   ${nhom_hang}    ${gia_ban}    ${dvcb}    ${ma_hh_qd}    ${giaban2}    ${dvqd}    ${giatriqd}
    ...     ELSE    Add product manufacturing    ${ma_hh}    ${ten_sp}   ${nhom_hang}      ${gia_ban}   ${ton}    ${sp_1}   ${sl_1}     ${sp_2}   ${sl_2}

Add supplier by supplier code
    [Arguments]    ${input_supplier_code}
    #tạo ncc
    Delete supplier if supplier exist    ${input_supplier_code}
    ${ten_ncc}    Generate code automatically    Nha cung cap
    ${mobile_number}    Generate Mobile number
    Add supplier    ${input_supplier_code}    ${ten_ncc}    ${mobile_number}
    ${get_supplier_id}    Get Supplier Id    ${input_supplier_code}
    Return From Keyword    ${get_supplier_id}

Get data for request copy PDN
    [Documentation]    get dữ liệu cho request sao chép phiếu đặt hàng nhập
    [Arguments]    ${dict_product_num}    ${tennhom}    ${input_supplier_code}    ${ma_phieu_dhn}
    ${list_prs}    Get Dictionary Keys    ${dict_product_num}
    ${list_nums}    Get Dictionary Values    ${dict_product_num}
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${cate_id}    Get category ID    ${tennhom}
    ${get_id_ncc}    Get Supplier Id    ${input_supplier_code}
    ${ten_ncc}    Get supplier name frm API    ${input_supplier_code}
    ${get_id_pdhn}    Get order supplier id thr API    ${ma_phieu_dhn}
    ${get_list_prs_id}    Get list product id thr API    ${list_prs}
    ${list_product_name}    Get list product name thr API    ${list_prs}
    #${list_master_product}    Get list master product from product code    ${list_prs}
    ${list_product_order_id}    Get list product order id frm purchase order detail api    ${ma_phieu_dhn}    ${get_list_prs_id}
    ${get_list_on_order_bf}    Get list on order frm API    ${list_prs}
    ${get_time}    Get Current Date
    ${str_time}    Subtract Time From Date    ${get_time}    00:00:30:00
    Return From Keyword    ${list_prs}    ${list_nums}    ${get_id_nguoitao}    ${get_id_nguoiban}    ${cate_id}    ${get_id_ncc}    ${ten_ncc}    ${get_id_pdhn}    ${get_list_prs_id}    ${list_product_name}
    ...        ${list_product_order_id}    ${get_list_on_order_bf}    ${str_time}

Get list prs status thr API
    [Arguments]    ${list_prs}
    [Documentation]    lấy thông tin của hàng hóa imei, lô date, quy đổi thông qua các status
    [Timeout]    20 minutes
    ${list_imei_status}    Create List
    ${list_batch_status}    Create List
    ${list_gtqd}    Create List
    : FOR    ${item_pr}    IN ZIP    ${list_prs}
    \    ${endpoint_hh}    Format String    ${endpoint_chitiet_hanghoa}    ${BRANCH_ID}    ${item_pr}
    \    ${resp}    Get Request and return body    ${endpoint_hh}
    \    ${jsonpath_imei_status}    Format String    $..Data[?(@.Code=="{0}")].IsLotSerialControl    ${item_pr}
    \    ${jsonpath_batch_status}    Format String    $..Data[?(@.Code=="{0}")].IsBatchExpireControl    ${item_pr}
    \    ${json_gtqd}    Format String    $..Data[?(@.Code=="{0}")].ConversionValue    ${item_pr}
    \    ${get_imei_status}    Get data from response json    ${resp}    ${jsonpath_imei_status}
    \    ${get_batch_status}    Get data from response json    ${resp}    ${jsonpath_batch_status}
    \    ${get_gtqd}    Get data from response json    ${resp}    ${json_gtqd}
    \    Append To List    ${list_imei_status}    ${get_imei_status}
    \    Append To List    ${list_batch_status}    ${get_batch_status}
    \    Append To List    ${list_gtqd}    ${get_gtqd}
    # ${count_imei}    Count Values In List    ${list_imei_status}
    # ${count_batch}    Count Values In List    ${list_imei_status}
    # ${list_imei}    Run Keyword If    ${count_imei}!=0    Convert List to String    ${list_imei_status}    ELSE    log
    # ${list_lodate}    Convert List to String    ${list_batch_status}
    # Log    ${list_imei}    ${list_batch}    ${list_gtqd}
    Return From Keyword    ${list_imei_status}    ${list_batch_status}    ${list_gtqd}

Get conversion value of unit product
    [Documentation]    lay ra gia tri quy doi cua hang dvt
    [Arguments]    ${pro_code}
    ${endpoint_hh}    Format String    ${endpoint_chitiet_hanghoa}    ${BRANCH_ID}    ${pro_code}
    ${resp}    Get Request and return body    ${endpoint_hh}
    ${json_gtqd}    Format String    $..Data[?(@.Code=="{0}")].ConversionValue    ${pro_code}
    ${get_gtqd}    Get data from response json    ${resp}    ${json_gtqd}
    Return From Keyword    ${get_gtqd}

Get unit of basic product
    [Documentation]    lấy thông tin đơn vị của hàng hóa cơ bản
    [Arguments]     ${product_code}
    ${endpoint_hh}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${resp}    Get Request and return body    ${endpoint_hh}
    ${jsonpath_unit}    Format String    $..Data[?(@.Code=="{0}")].Unit    ${product_code}
    ${get_unit}    Get data from response json    ${resp}    ${jsonpath_unit}
    ${get_product_id}    Get product id thr API    ${product_code}
    Return From Keyword     ${get_product_id}    ${get_unit}

Get info product incase lodate product have unit
    [Documentation]    lấy thông tin của hàng hóa quy doi
    [Arguments]    ${product_code}     ${master_product_id}
    ${endpoint_hh}    Format String    ${endpoint_hh_by_master_product}    ${BRANCH_ID}     ${master_product_id}
    ${resp}    Get Request and return body    ${endpoint_hh}
    ${jsonpath_unit}    Format String    $..Data[?(@.Code=="{0}")].Unit    ${product_code}
    ${jsonpath_fullname}     Format String    $..Data[?(@.Code=="{0}")].FullName
    ${get_unit}    Get data from response json    ${resp}    ${jsonpath_unit}
    ${get_fullname}    Get data from response json    ${resp}    ${jsonpath_fullname}
    Return From Keyword    ${get_fullname}    ${get_unit}

Create batch list by generating random batch code
    [Arguments]    ${quantity}
    ${list_batch_name}    Create List
    ${list_full_name}    Create List
    ${list_expire}    Create List
    : FOR    ${item}    IN RANGE    ${quantity}
    \    ${batch_name}    ${full_name}    ${expire}    Add new batch expire by generating random
    \    Append To List    ${list_batch_name}    ${batch_name}
    \    Append To List    ${list_full_name}    ${full_name}
    \    Append To List    ${list_expire}    ${expire}
    Return From Keyword    ${list_batch_name}    ${list_full_name}    ${list_expire}

Add new batch expire by generating random
    [Arguments]    @{EMPTY}
    ${batch_name}    Generate Random String    4    [UPPER]
    ${curdatetime}    Get Current Date
    ${currentdate}    Get Current Date
    ${date}=    Add Time To Date    ${currentdate}    30 days
    ${expire}=    Add Time To Date    ${curdatetime}    30 days
    ${lo_date}    Set Variable    {0} - {1}
    ${full_name}    Format String    ${lo_date}    ${batch_name}    ${date}
    Return From Keyword    ${batch_name}    ${full_name}    ${expire}

Asssert value on order in Stock Card incase increase
    [Documentation]    Validate thẻ kho của hàng hóa trong trường hợp tăng tồn kho
    [Arguments]    ${list_prs}    ${ma_phieu_dhn}    ${get_list_on_order_bf}    ${list_nums}
    ${get_list_actual_on_order_af}    Get list on order frm API    ${list_prs}
    : FOR    ${item_on_order}    ${item_actual_on_order}    ${item_nums}    IN ZIP    ${get_list_on_order_bf}    ${get_list_actual_on_order_af}    ${list_nums}
    \    ${item_on_order_bf}    Sum    ${item_on_order}    ${item_nums}
    \    Should Be Equal As Numbers    ${item_on_order_bf}    ${item_actual_on_order}

Validate status of order supplier coppy
    [Documentation]    kiểm tra trạng thái của phiếu đặt nhập
    [Arguments]    ${ma_phieu_dhn}    ${status_of_phieu}
    ${ma_phieu_2}    Set Variable    {0}.01
    ${ma_phieu_coppy}    Format String    ${ma_phieu_2}    ${ma_phieu_dhn}
    ${get_status_pdn}    Get status of order supplier thr API    ${ma_phieu_coppy}
    Run Keyword If    '${get_status_pdn}'!='0'    Should Be Equal As Strings     ${get_status_pdn}    ${status_of_phieu}
    Return From Keyword     ${ma_phieu_coppy}

Asssert value on order in Stock Card incase reduction
    [Documentation]    validate thẻ kho của hàng hóa trong trường hợp tồn kho giảm
    [Arguments]    ${list_prs}    ${get_list_on_order_bf}    ${list_nums}
    ${get_list_actual_on_order_af}    Get list on order frm API    ${list_prs}
    : FOR    ${item_on_order}    ${item_actual_on_order}    ${item_nums}    IN ZIP    ${get_list_on_order_bf}    ${get_list_actual_on_order_af}    ${list_nums}
    \    ${item_on_order_bf}    Minus    ${item_on_order}    ${item_nums}
    \    Should Be Equal As Numbers    ${item_on_order_bf}    ${item_actual_on_order}

Asssert value on order in Stock Card incase change quantity
    [Documentation]    validate số lượng khi thay đổi số lượng của đơn đặt hàng nhập do phiếu nhập
    [Arguments]    ${get_list_on_order_bf}    ${dict_product_num}    ${dict_nhaphang}
    ${list_prs}    Get Dictionary Keys    ${dict_product_num}
    ${list_nums}    Get Dictionary Values    ${dict_product_num}
    ${list_prs_nhaphang}    Get Dictionary Keys    ${dict_nhaphang}
    ${list_nums_nhaphang}    Get Dictionary Values    ${dict_nhaphang}
    #
    ${list_prs_cp}    Copy List    ${list_prs}
    ${list_prs_validate}    Copy List    ${list_prs_nhaphang}
    ${list_num_validate}    Copy List    ${list_nums_nhaphang}
    #tìm kiếm các hàng hóa ko được nhập
    :FOR    ${item_prs}    ${item_pr_nhap}
    ...    IN ZIP    ${list_prs}    ${list_prs_nhaphang}
    \    Run Keyword If   '${item_prs}'=='${item_pr_nhap}'    Remove Values From List    ${list_prs_cp}    ${item_prs}
    #với mỗi hàng hóa ko đc nhập gán sl nhập = 0
    :FOR   ${item}    IN ZIP    ${list_prs_cp}
    \    Append To List    ${list_prs_validate}    ${item}
    \    Append To List    ${list_num_validate}    0
    ${list_new_order}    Create List
    Log    ${list_prs_validate}
    Log    ${list_num_validate}
    :FOR    ${item_on_order}    ${item_prs}    ${item_nums}   ${item_pr_nhap}    ${item_num_nhap}    IN ZIP
    ...    ${get_list_on_order_bf}    ${list_prs}    ${list_nums}    ${list_prs_validate}    ${list_num_validate}
    \    ${sl_new}    Run Keyword If    '${item_num_nhap}'<='${item_nums}'    Minus    ${item_nums}    ${item_num_nhap}    ELSE    Set Variable    0
    \    ${sl_new_order}    Sum    ${item_on_order}    ${sl_new}
    \    Run Keyword If    '${item_prs}'=='${item_pr_nhap}'     Wait Until Keyword Succeeds    3x    3s    Validate on order number of product    ${item_prs}    ${sl_new_order}

Asssert value on order in Stock Card incase change quantity of order supplier
    [Documentation]    validate số lượng khi thay đổi số lượng của phiếu đặt hàng nhập
    [Arguments]    ${get_list_on_order_bf}    ${dict_product_num}    ${dict_nhaphang}    ${dict_update_pdn}
    ${list_prs}    Get Dictionary Keys    ${dict_product_num}
    ${list_nums}    Get Dictionary Values    ${dict_product_num}
    ${list_prs_nhaphang}    Get Dictionary Keys    ${dict_nhaphang}
    ${list_nums_nhaphang}    Get Dictionary Values    ${dict_nhaphang}
    ${list_prs_update}    Get Dictionary Keys    ${dict_update_pdn}
    ${list_nums_update}    Get Dictionary Values    ${dict_update_pdn}
    #
    ${list_prs_cp}    Copy List    ${list_prs}
    ${list_prs_validate}    Copy List    ${list_prs_nhaphang}
    ${list_num_validate}    Copy List    ${list_nums_nhaphang}
    #tìm kiếm các hàng hóa ko được nhập
    :FOR    ${item_prs}    ${item_pr_nhap}
    ...    IN ZIP    ${list_prs}    ${list_prs_nhaphang}
    \    Run Keyword If   '${item_prs}'=='${item_pr_nhap}'    Remove Values From List    ${list_prs_cp}    ${item_prs}
    #với mỗi hàng hóa ko đc nhập gán sl nhập = 0
    :FOR   ${item}    IN ZIP    ${list_prs_cp}
    \    Append To List    ${list_prs_validate}    ${item}
    \    Append To List    ${list_num_validate}    0
    ${list_new_order}    Create List
    Log    ${list_prs_validate}
    Log    ${list_num_validate}
    #${get_list_actual_on_order_af}    Get list on order frm API    ${list_prs}
    :FOR    ${item_on_order}    ${item_prs}    ${item_num}    ${item_pr_update}    ${item_nums_update}    ${item_pr_nhap}    ${item_num_nhap}    IN ZIP
    ...    ${get_list_on_order_bf}    ${list_prs}    ${list_nums}    ${list_prs_update}    ${list_nums_update}    ${list_prs_validate}    ${list_num_validate}
    #số lượng order mới = số lượng order cũ - chênh lệch sau khi update phiếu đặt nhập
    #\    ${sl_new}    Minus    ${item_on_order}    ${item_num}
    #\    ${sl_new1}    Sum    ${sl_new}    ${item_nums_update}
    #nếu số lượng nhập <= số lượng đặt thì lấy sl đặt - nhập , nếu sl nhập> sl đặt thì lấy sl đặt - sl đặt(về 0)
    \    ${sl_new}    Run Keyword If    '${item_num_nhap}'<='${item_nums_update}' and '${item_nums_update}'>='${item_num}' and '${item_num_nhap}'<'${item_num}'    Minus    ${item_nums_update}    ${item_num_nhap}
    \    ...    ELSE IF    '${item_num_nhap}'<='${item_nums_update}' and '${item_nums_update}'>='${item_num}'    Minus    ${item_nums_update}    ${item_num}
    \    ...    ELSE    Set Variable    0
    #\    ${af_update}    Run Keyword If    '${item_nums_update}'>'${item_num}'    Minus    ${item_nums_update}    ${item_num}    ELSE    Set Variable    0
    \    ${sl_new_order}    Sum    ${sl_new}    ${item_on_order}
    \    Run Keyword If    '${item_pr_update}'=='${item_prs}'    Wait Until Keyword Succeeds    3x    3s    Validate on order number of product    ${item_prs}    ${sl_new_order}

Validate on order number of product
    [Arguments]    ${item_prs}    ${item_on_order_expected}
    [Documentation]    check so luong dat hang nhap cua hang hoa
    ${item_actual_on_order}    Get on order frm API    ${item_prs}
    ${check}   Minus    ${item_actual_on_order}    ${item_on_order_expected}
    Run Keyword If    ${check}!=0    Fail    lệch số lượng đặt hàng nhập

Coppy order supplier frm existing order supplier
    [Documentation]    Coppy phiếu đặt hàng nhập từ 1 phiếu đã có sẵn
    [Arguments]    ${dict_product_num}    ${tennhom}    ${input_supplier_code}    ${ma_phieu_dhn}
    ${list_prs}    ${list_nums}    ${get_id_nguoitao}    ${get_id_nguoiban}    ${cate_id}    ${get_id_ncc}    ${ten_ncc}    ${get_id_pdhn}    ${get_list_prs_id}    ${list_product_name}
    ...    ${list_product_order_id}    ${get_list_on_order_bf}    ${str_time}    Get data for request copy PDN    ${dict_product_num}    ${tennhom}    ${input_supplier_code}    ${ma_phieu_dhn}
    #
    ${liststring_prs_order_detail}    Set Variable    needdel
    : FOR    ${item_product_order_id}    ${item_pr}    ${item_pr_id}    ${item_num}    ${item_name}    IN ZIP    ${list_product_order_id}    ${list_prs}    ${get_list_prs_id}    ${list_nums}    ${list_product_name}
    \    ${payload_each_product}    Format string    {{"Unit":"","ListProductUnit":[],"Units":[],"SelectedUnit":{0},"ShowUnit":false,"Shelves":"","Id":{1},"OrderSupplierId":{2},"ProductId":{0},"Quantity":{3},"Price":85000.84,"Discount":12750.13,"Allocation":14450.16,"CreatedDate":"2020-11-19T16:17:47.0370000+07:00","Description":"","DiscountRatio":15,"OrderByNumber":0,"AllocationSuppliers":0,"AllocationThirdParty":0,"OrderQuantity":0,"RetailerId":0,"Product":{{"IdOld":0,"CrudGuid":"00000000000000000000000000000000","ParentUnits":[],"CategoryOld":0,"Id":{0},"Code":"{4}","Name":"{5}","CategoryId":{6},"AllowsSale":true,"BasePrice":1520000,"Tax":0,"RetailerId":{7},"isActive":true,"CreatedDate":"2020-11-19T16:17:37.6770000+07:00","ProductType":2,"HasVariants":false,"Unit":"","ConversionValue":1,"OrderTemplate":"","FullName":"{5}","IsLotSerialControl":true,"IsRewardPoint":false,"isDeleted":false,"MasterCode":"SPC000837","Revision":"AAAAAAtIVFo=","Formula":[],"ProductImages":[],"PurchaseReturnDetails":[],"ProductChild":[],"ProductAttributes":[],"ProductChildUnit":[],"PriceBookDetails":[],"ProductBranches":[],"TableAndRooms":[],"Manufacturings":[],"ManufacturingDetails":[],"DamageDetails":[],"ProductSerials":[],"ProductFormulaHistories":[],"OrderSupplierDetails":[],"ProductShelves":[],"PrescriptionDetails":[],"SamplePrescriptionDetails":[]}},"ProductName":"{5}","ProductCode":"{4}","SubTotal":133664,"Reserved":0,"OnHand":0,"OnOrder":{3},"ActualReserved":0,"PurchaseId":0,"tabIndex":100,"ViewIndex":1,"rowNumber":0,"TotalValue":133664}}
    \    ...    ${item_pr_id}    ${item_product_order_id}    ${get_id_pdhn}    ${item_num}    ${item_pr}    ${item_name}    ${cate_id}    ${get_id_nguoitao}
    \    ${liststring_prs_order_detail}    Catenate    SEPARATOR=,    ${liststring_prs_order_detail}    ${payload_each_product}
    Log    ${liststring_prs_order_detail}
    ${liststring_prs_order_detail}    Replace String    ${liststring_prs_order_detail}    needdel,    ${EMPTY}    count=1
    ${request_payload}    Format String    {{"OrderSupplier":{{"ImportDate":null,"Code":"{0}.01","OrderSupplierDetails":[{1}],"UserId":{2},"CompareUserId":{2},"User":{{"IdOld":0,"CompareGivenName":"thao11","CompareIsLimitedByTrans":false,"CompareIsShowSumRow":true,"CompareUserName":"admin","IsTimeSheetException":false,"Id":{2},"Email":"tthao@gmail.com","GivenName":"thao11","CreatedDate":"2020-09-07T11:58:15.7430000+07:00","IsActive":true,"IsAdmin":true,"RetailerId":{3},"UserName":"admin","Type":0,"CreatedBy":0,"CanAccessAnySite":false,"Language":"vi-VN","LocationName":"","WardName":"","isDeleted":false,"Permissions":[],"Apps":[],"Invoices":[],"Transfers1":[],"PriceBookUsers":[],"CashFlows":[],"Invoices1":[],"Orders":[],"Returns1":[],"Manufacturings":[],"DamageItems":[],"TokenApis":[],"SmsEmailTemplates":[],"BalanceAdjustments1":[],"PointAdjustments":[],"PointAdjustmentsCreatedBy":[],"NotificationSettings":[],"DamageItems1":[],"PurchaseOrders1":[],"PurchaseReturns1":[],"CostAdjustments":[],"Devices":[],"OrderSuppliers":[],"OrderSuppliers1":[],"UserDevices":[],"PayslipPayments":[],"PayslipPaymentAllocations":[]}},"CreatedDate":"2020-11-19T09:17:47.037Z","Description":"","Supplier":{{"IdOld":0,"TotalInvoiced":0,"CompareCode":"{4}","CompareName":"{5}","ComparePhone":"0988014471","Id":{6},"Name":"{5}","Phone":"0988014471","RetailerId":{3},"Code":"{4}","CreatedDate":"2020-11-19T16:17:42.1670000+07:00","CreatedBy":{2},"LocationName":"","WardName":"","BranchId":{7},"isDeleted":false,"isActive":true,"SearchNumber":"0988014471","PurchaseOrders":[],"PurchaseReturns":[],"PurchasePayments":[],"SupplierGroupDetails":[],"OrderSuppliers":[]}},"SupplierId":{6},"CompareSupplierId":{6},"SubTotal":696665,"Branch":{{"Id":{7},"Name":"Chi nhánh trung tâm","Type":0,"Address":"1b Yết kiêu","Province":"Hà Nội","District":"Quận Hoàn Kiếm","ContactNumber":"0379089988","IsActive":true,"RetailerId":{3},"CreatedBy":0,"LimitAccess":false,"LocationName":"Hà Nội - Quận Hoàn Kiếm","WardName":"Phường Trần Hưng Đạo","isAcceptBookClosing":false,"GmbStatus":1,"Orders":[],"Transfers1":[],"DamageItems":[],"SurchargeBranches":[],"AdrApplications":[],"Customers":[],"Suppliers":[],"ExpensesOtherBranches":[],"OrderSuppliers":[],"WarrantyBranchGroups":[],"BranchTakingAddresses":[],"Patients":[],"Clinics":[],"Doctors":[],"DoctorQualifications":[],"DoctorSpecialities":[],"Prescriptions":[],"PayslipPayments":[],"PayslipPaymentAllocations":[],"IdOld":0,"TotalUser":0,"CompareBranchName":"Chi nhánh trung tâm","StatusGmbValue":"Chưa đăng ký","IsTimeSheetException":false,"LocationId":0,"WardId":0}},"Status":1,"StatusValue":"Đã xác nhận NCC","CompareStatusValue":"Phiếu tạm","Discount":139333,"CompareDiscount":139333,"DiscountRatio":20,"Id":0,"Account":{{}},"Total":557332,"TotalQuantity":9.35,"ExpensesOthersTitle":"","ExpensesOthersRtpTitle":"","OrderSupplierExpensesOthers":[],"OrderSupplierExpensesOthersRs":[],"OrderSupplierExpensesOthersRtp":[],"ExReturnSuppliers":0,"ExReturnThirdParty":0,"PaidAmount":0,"PayingAmount":0,"ChangeAmount":-557332,"paymentMethod":"","BalanceDue":557332,"paymentReturnType":0,"OriginTotal":557332,"paymentMethodObj":null,"PurchaseOrderExpenssaveDataesOthers":[],"PurchasePayments":[],"BranchId":{7}}},"Complete":true,"CopyFrom":{8}}}
    ...    ${ma_phieu_dhn}    ${liststring_prs_order_detail}    ${get_id_nguoiban}    ${get_id_nguoitao}    ${input_supplier_code}    ${ten_ncc}    ${get_id_ncc}    ${BRANCH_ID}    ${get_id_pdhn}    ${str_time}
    Log    ${request_payload}
    Post request thr API     /ordersuppliers    ${request_payload}

Update order supplier frm existing order supplier
    [Documentation]    Update trạng thái của phiếu đặt hàng nhập
    [Arguments]    ${dict_product_num}    ${tennhom}    ${input_supplier_code}    ${ma_phieu_dhn}     ${value_status}
    ${list_prs}    ${list_nums}    ${get_id_nguoitao}    ${get_id_nguoiban}    ${cat_id}    ${get_id_ncc}    ${ten_ncc}    ${get_id_pdhn}    ${get_list_prs_id}    ${list_product_name}
    ...    ${list_product_order_id}    ${get_list_on_order_bf}    ${str_time}    Get data for request copy PDN    ${dict_product_num}    ${tennhom}    ${input_supplier_code}    ${ma_phieu_dhn}
    ${liststring_prs_order_detail}    Set Variable    needdel
    : FOR    ${item_product_order_id}    ${item_pr}    ${item_pr_id}    ${item_num}    ${item_name}    IN ZIP    ${list_product_order_id}    ${list_prs}    ${get_list_prs_id}    ${list_nums}    ${list_product_name}
    \    ${payload_each_product}    Format string    {{"Id":{0},"OrderSupplierId":{1},"ProductId":{2},"Quantity":{3},"Price":500000,"Discount":0,"Allocation":0,"CreatedDate":"2020-11-12T16:47:26.6900000+07:00","Description":"","OrderByNumber":0,"AllocationSuppliers":0,"AllocationThirdParty":0,"OrderQuantity":0,"RetailerId":{4},"Product":{{"IdOld":0,"TradeMarkName":"","CrudGuid":"00000000000000000000000000000000","ParentUnits":[],"CategoryOld":0,"Id":{2},"Code":"{5}","Name":"{7}","CategoryId":{6},"AllowsSale":true,"BasePrice":1520000,"Tax":0,"RetailerId":{4},"isActive":true,"CreatedDate":"2020-11-12T16:46:21.9930000+07:00","ProductType":2,"HasVariants":false,"Unit":"","ConversionValue":1,"OrderTemplate":"","FullName":"{7}","IsLotSerialControl":true,"IsRewardPoint":false,"isDeleted":false,"MasterCode":"","Revision":"","Formula":[],"ProductImages":[],"PurchaseReturnDetails":[],"ProductChild":[],"ProductAttributes":[],"ProductChildUnit":[],"PriceBookDetails":[],"ProductBranches":[],"TableAndRooms":[],"Manufacturings":[],"ManufacturingDetails":[],"DamageDetails":[],"ProductSerials":[],"ProductFormulaHistories":[],"OrderSupplierDetails":[],"ProductShelves":[],"PrescriptionDetails":[],"SamplePrescriptionDetails":[]}},"ProductName":"{7}","ProductCode":"{5}","SubTotal":0,"Reserved":0,"OnHand":0,"OnOrder":0,"ActualReserved":0,"ProductNameNoUnit":"{7}","PriceSale":0}}
    \    ...    ${item_product_order_id}    ${get_id_ncc}    ${item_pr_id}    ${item_num}    ${get_id_nguoitao}    ${item_pr}    ${cat_id}    ${item_name}
    \    ${liststring_prs_order_detail}    Catenate    SEPARATOR=,    ${liststring_prs_order_detail}    ${payload_each_product}
    Log    ${liststring_prs_order_detail}
    ${liststring_prs_order_detail}    Replace String    ${liststring_prs_order_detail}    needdel,    ${EMPTY}    count=1
    ${request_payload}    Format String    {{"OrderSupplier":{{"Id":{0},"Code":"{1}","OrderDate":"{9}","SupplierId":{2},"BranchId":{3},"RetailerId":{4},"UserId":{5},"Description":"","Status":{10},"DiscountRatio":0,"Discount":0,"CreatedDate":"2020-11-12T12:56:41.330Z","CreatedBy":{5},"Total":4099500,"ExReturnSuppliers":0,"ExReturnThirdParty":0,"TotalPayment":0,"TotalAmt":4099500,"ProductQty":4,"TotalQty":9.35,"Branch":{{"Id":{3},"Name":"Chi nhánh trung tâm","Type":0,"Address":"1b Yết kiêu","Province":"Hà Nội","District":"Quận Hoàn Kiếm","ContactNumber":"0379089988","IsActive":true,"RetailerId":{4},"CreatedBy":0,"LimitAccess":false,"LocationName":"Hà Nội - Quận Hoàn Kiếm","WardName":"Phường Trần Hưng Đạo","isAcceptBookClosing":false,"GmbStatus":1,"Orders":[],"Transfers1":[],"DamageItems":[],"SurchargeBranches":[],"AdrApplications":[],"Customers":[],"Suppliers":[],"ExpensesOtherBranches":[],"OrderSuppliers":[],"WarrantyBranchGroups":[],"BranchTakingAddresses":[],"Patients":[],"Clinics":[],"Doctors":[],"DoctorQualifications":[],"DoctorSpecialities":[],"Prescriptions":[],"PayslipPayments":[],"PayslipPaymentAllocations":[],"IdOld":0,"TotalUser":0,"CompareBranchName":"Chi nhánh trung tâm","StatusGmbValue":"Chưa đăng ký","IsTimeSheetException":false,"LocationId":0,"WardId":0}},"User":{{"IdOld":0,"CompareGivenName":"thao11","CompareIsLimitedByTrans":false,"CompareIsShowSumRow":true,"CompareUserName":"admin","IsTimeSheetException":false,"Id":{5},"Email":"tthao@gmail.com","GivenName":"thao11","CreatedDate":"2020-09-07T11:58:15.7430000+07:00","IsActive":true,"IsAdmin":true,"RetailerId":{4},"UserName":"admin","Type":0,"CreatedBy":0,"CanAccessAnySite":false,"Language":"vi-VN","LocationName":"","WardName":"","isDeleted":false,"Permissions":[],"Apps":[],"Invoices":[],"Transfers1":[],"PriceBookUsers":[],"CashFlows":[],"Invoices1":[],"Orders":[],"Returns1":[],"Manufacturings":[],"DamageItems":[],"TokenApis":[],"SmsEmailTemplates":[],"BalanceAdjustments1":[],"PointAdjustments":[],"PointAdjustmentsCreatedBy":[],"NotificationSettings":[],"DamageItems1":[],"PurchaseOrders1":[],"PurchaseReturns1":[],"CostAdjustments":[],"Devices":[],"OrderSuppliers":[],"OrderSuppliers1":[],"UserDevices":[],"PayslipPayments":[],"PayslipPaymentAllocations":[]}},"OrderSupplierDetails":[{7}],"OrderSupplierExpensesOthers":[],"Supplier":{{"IdOld":0,"TotalInvoiced":0,"CompareCode":"{6}","CompareName":"{8}","ComparePhone":"0980342982","Id":{2},"Name":"{8}","Phone":"0980342982","RetailerId":{4},"Code":"{6}","CreatedDate":"2020-11-12T19:56:36.8100000+07:00","CreatedBy":{5},"LocationName":"","WardName":"","BranchId":{3},"isDeleted":false,"isActive":true,"SearchNumber":"0980342982","PurchaseOrders":[],"PurchaseReturns":[],"PurchasePayments":[],"SupplierGroupDetails":[],"OrderSuppliers":[]}},"User1":{{"IdOld":0,"CompareGivenName":"thao11","CompareIsLimitedByTrans":false,"CompareIsShowSumRow":true,"CompareUserName":"admin","IsTimeSheetException":false,"Id":{5},"Email":"tthao@gmail.com","GivenName":"thao11","CreatedDate":"2020-09-07T11:58:15.7430000+07:00","IsActive":true,"IsAdmin":true,"RetailerId":{4},"UserName":"admin","Type":0,"CreatedBy":0,"CanAccessAnySite":false,"Language":"vi-VN","LocationName":"","WardName":"","isDeleted":false,"Permissions":[],"Apps":[],"Invoices":[],"Transfers1":[],"PriceBookUsers":[],"CashFlows":[],"Invoices1":[],"Orders":[],"Returns1":[],"Manufacturings":[],"DamageItems":[],"TokenApis":[],"SmsEmailTemplates":[],"BalanceAdjustments1":[],"PointAdjustments":[],"PointAdjustmentsCreatedBy":[],"NotificationSettings":[],"DamageItems1":[],"PurchaseOrders1":[],"PurchaseReturns1":[],"CostAdjustments":[],"Devices":[],"OrderSuppliers":[],"OrderSuppliers1":[],"UserDevices":[],"PayslipPayments":[],"PayslipPaymentAllocations":[]}},"PurchaseOrders":[],"PurchasePayments":[],"CompareCode":"{1}","CompareUserId":{5},"CompareSupplierId":{2},"CompareOrderDate":"{9}","CompareDiscount":0,"TotalQuantity":9.35,"TotalProductType":4,"SubTotal":4099500,"PaidAmount":0,"ToComplete":false,"CompareStatusValue":"Phiếu tạm","StatusValue":1,"ViewPrice":true,"SupplierDebt":0,"SupplierOldDebt":0,"EventId":0,"EventAction":0,"RetryCount":0,"DocumentTypeByEvent":0,"IdOld":0,"isShowSupplier":false,"ShortDescription":"","WaitingDays":null,"isWarning":true,"PurchaseDate":null,"OrderSupplierExpensesOthersRs":[],"OrderSupplierExpensesOthersRtp":[]}},"ListUpdate":true,"IsUpdatePayment":false,"IsUpdateSupplier":false,"IsUpdateValue":true,"IsUpdateOnlyOrder":true}}
    ...    ${get_id_pdhn}    ${ma_phieu_dhn}    ${get_id_ncc}    ${BRANCH_ID}    ${get_id_nguoitao}    ${get_id_nguoiban}    ${input_supplier_code}    ${liststring_prs_order_detail}    ${ten_ncc}    ${str_time}     ${value_status}
    Log    ${request_payload}
    Post request thr API     /ordersuppliers    ${request_payload}

Create purchase order from order supplier
    [Documentation]    tạo phiếu đặt hàng lấy all phiếu đặt nhập
    [Arguments]    ${dict_product_num}    ${list_nums}    ${tennhom}    ${input_supplier_code}    ${ma_phieu_dhn}
    ${get_supplier_id}    Get Supplier Id    ${input_supplier_code}
    ${list_prs}    ${list_nums_nhap}    ${get_id_nguoitao}    ${get_id_nguoiban}    ${cat_id}    ${get_id_ncc}    ${ten_ncc}    ${get_id_pdhn}    ${get_list_prs_id}    ${list_product_name}
    ...    ${list_product_order_id}    ${get_list_on_order_bf}    ${str_time}    Get data for request copy PDN    ${dict_product_num}    ${tennhom}    ${input_supplier_code}    ${ma_phieu_dhn}
    ${list_imei_status}    ${list_batch_status}    ${list_gtqd}     Get list prs status thr API    ${list_prs}
    ${liststring_prs_order_detail}    Set Variable    needdel
    ${list_imei_all}    Create List
    : FOR    ${item_pr}    ${item_pr_id}    ${item_imei_status}    ${item_batch_status}    ${item_gtqd}    ${item_num_order}    ${item_num_nhap}    ${item_pr_order_id}    ${item_name}    IN ZIP
    ...    ${list_prs}    ${get_list_prs_id}    ${list_imei_status}    ${list_batch_status}    ${list_gtqd}    ${list_nums}    ${list_nums_nhap}    ${list_product_order_id}    ${list_product_name}
    \    ${get_ma_hh_cb}    Run Keyword If    '${item_batch_status}'=='True' and '${item_gtqd}'=='1'    Get basic product frm unit product    ${item_pr}    ELSE    Set Variable    0
    \    ${batch_name}    ${full_name}    ${expire}    Run Keyword If    '${item_batch_status}'=='True'    Add new batch expire by generating random
    \    ${list_imei}    Run Keyword If    '${item_imei_status}'=='True'    Create list imei by generating random    ${item_num_nhap}
    \    ...    ELSE    Set Variable    ${EMPTY}
    \    ${list_imei}    Run Keyword If    '${item_imei_status}'=='True'    Convert List to String    ${list_imei}
    \    ...    ELSE    Set Variable    ${EMPTY}
    \    Append To List    ${list_imei_all}    ${list_imei}
    \    ${payload_each_product}    Run Keyword If    '${item_imei_status}'=='True'    Format string    {{"Unit":"","ListProductUnit":[],"Units":[],"SelectedUnit":{0},"ShowUnit":false,"Shelves":"","Id":{1},"OrderSupplierId":{2},"ProductId":{0},"Quantity":{3},"Price":85000.84,"Discount":12750.13,"Allocation":14450.09,"CreatedDate":"2020-12-15T17:33:45.5900000+07:00","Description":"","DiscountRatio":15,"OrderByNumber":3,"AllocationSuppliers":0,"AllocationThirdParty":0,"OrderQuantity":0,"RetailerId":0,"Product":{{"IdOld":0,"CrudGuid":"00000000000000000000000000000000","ParentUnits":[],"CategoryOld":0,"Id":{0},"Code":"{4}","Name":"{5}","CategoryId":{6},"AllowsSale":true,"BasePrice":70000,"Tax":0,"RetailerId":{7},"isActive":true,"CreatedDate":"2020-12-15T17:31:37.3270000+07:00","ProductType":2,"HasVariants":false,"Unit":"","ConversionValue":1,"OrderTemplate":"","FullName":"{5}","IsLotSerialControl":true,"IsRewardPoint":false,"isDeleted":false,"MasterCode":"SPC001155","Revision":"AAAAAA3VOVU=","Formula":[],"ProductImages":[],"PurchaseReturnDetails":[],"ProductChild":[],"ProductAttributes":[],"ProductChildUnit":[],"PriceBookDetails":[],"ProductBranches":[],"TableAndRooms":[],"Manufacturings":[],"ManufacturingDetails":[],"DamageDetails":[],"ProductSerials":[],"ProductFormulaHistories":[],"OrderSupplierDetails":[],"ProductShelves":[],"PrescriptionDetails":[],"SamplePrescriptionDetails":[],"OnHand":3,"Reserved":0,"ActualReserved":0}},"ProductName":"{5}","ProductCode":"{4}","SubTotal":144501,"Reserved":0,"OnHand":3,"OnOrder":{3},"ActualReserved":0,"tabIndex":100,"ViewIndex":4,"TotalValue":null,"allSuggestSerial":[],"SerialNumbers":"{8}"}}
    \    ...    ${item_pr_id}    ${item_pr_order_id}    ${get_id_pdhn}    ${item_num_nhap}    ${item_pr}    ${item_name}    ${cat_id}    ${get_id_nguoitao}    ${list_imei}
    \    ...    ELSE IF    '${item_batch_status}'=='True'    Format String    {{"Unit":"Hop","ListProductUnit":[],"Units":[{{"Id":{0},"Unit":"Hop","Code":"{1}","Conversion":0,"MasterUnitId":0}}],"SelectedUnit":{0},"ShowUnit":true,"MasterUnitId":10859960,"Shelves":"","Id":{2},"OrderSupplierId":{3},"ProductId":{0},"Quantity":{4},"Price":140000,"Discount":0,"Allocation":0,"CreatedDate":"2020-12-29T18:11:24.8970000+07:00","Description":"","DiscountRatio":0,"OrderByNumber":0,"AllocationSuppliers":0,"AllocationThirdParty":0,"OrderQuantity":0,"RetailerId":0,"Product":{{"IdOld":0,"CrudGuid":"00000000000000000000000000000000","ParentUnits":[],"CategoryOld":0,"Id":{0},"Code":"{1}","Name":"Lip Balm Himalaya ","CategoryId":{5},"AllowsSale":true,"BasePrice":140000,"Tax":0,"RetailerId":{6},"isActive":true,"CreatedDate":"2020-12-29T18:11:00.6600000+07:00","ProductType":2,"HasVariants":false,"MasterProductId":10859960,"Unit":"Hop","ConversionValue":{10},"MasterUnitId":10859960,"OrderTemplate":"","FullName":"Lip Balm Himalaya (Hop)","IsLotSerialControl":false,"IsRewardPoint":false,"isDeleted":false,"MasterCode":"SPC001466","Revision":"AAAAAA8MPr4=","IsBatchExpireControl":true,"Formula":[],"ProductImages":[],"PurchaseReturnDetails":[],"ProductChild":[],"ProductAttributes":[],"ProductChildUnit":[],"PriceBookDetails":[],"ProductBranches":[],"TableAndRooms":[],"Manufacturings":[],"ManufacturingDetails":[],"DamageDetails":[],"ProductSerials":[],"ProductFormulaHistories":[],"OrderSupplierDetails":[],"ProductShelves":[],"PrescriptionDetails":[],"SamplePrescriptionDetails":[],"OnHand":0,"Reserved":0,"ActualReserved":0}},"ProductName":"Lip Balm Himalaya ","ProductCode":"{1}","SubTotal":490000,"Reserved":0,"OnHand":0,"OnOrder":{4},"ActualReserved":0,"tabIndex":100,"ViewIndex":1,"TotalValue":490000,"allSuggestSerial":[],"ProductBatchExpireList":[{{"Id":-1,"BatchName":"{7}","FullNameVirgule":"{8}","ExpireDate":"{9}","DisplayType":1,"Status":2,"IsUpdate":1,"OnHand":{4},"SystemCount":0}}]}}
    \    ...    ${item_pr_id}    ${item_pr}    ${item_pr_order_id}    ${get_id_pdhn}    ${item_num_nhap}    ${cat_id}    ${get_id_nguoitao}    ${batch_name}    ${full_name}
    \    ...    ${expire}    ${item_gtqd}
    \    ...    ELSE    Format String    {{"Unit":"","ListProductUnit":[],"Units":[],"SelectedUnit":{0},"ShowUnit":false,"Shelves":"","Id":{1},"OrderSupplierId":{2},"ProductId":{0},"Quantity":{3},"Price":150000,"Discount":0,"Allocation":0,"CreatedDate":"2020-12-29T18:11:24.8970000+07:00","Description":"","DiscountRatio":0,"OrderByNumber":3,"AllocationSuppliers":0,"AllocationThirdParty":0,"OrderQuantity":0,"RetailerId":0,"Product":{{"IdOld":0,"CrudGuid":"00000000000000000000000000000000","ParentUnits":[],"CategoryOld":0,"Id":{0},"Code":"{4}","Name":"Sữa vinamilk pha nguyên kem","CategoryId":{5},"AllowsSale":true,"BasePrice":150000,"Tax":0,"RetailerId":{6},"isActive":true,"CreatedDate":"2020-12-29T18:11:04.8300000+07:00","ProductType":2,"HasVariants":false,"Unit":"","ConversionValue":1,"OrderTemplate":"","FullName":"Sữa vinamilk pha nguyên kem","IsLotSerialControl":false,"IsRewardPoint":false,"isDeleted":false,"MasterCode":"SPC001468","Revision":"AAAAAA8MP00=","Formula":[],"ProductImages":[],"PurchaseReturnDetails":[],"ProductChild":[],"ProductAttributes":[],"ProductChildUnit":[],"PriceBookDetails":[],"ProductBranches":[],"TableAndRooms":[],"Manufacturings":[],"ManufacturingDetails":[],"DamageDetails":[],"ProductSerials":[],"ProductFormulaHistories":[],"OrderSupplierDetails":[],"ProductShelves":[],"PrescriptionDetails":[],"SamplePrescriptionDetails":[],"OnHand":10,"Reserved":0,"ActualReserved":0}},"ProductName":"Sữa vinamilk pha nguyên kem","ProductCode":"{4}","SubTotal":375000,"Reserved":0,"OnHand":10,"OnOrder":{3},"ActualReserved":0,"tabIndex":100,"ViewIndex":4,"TotalValue":null,"allSuggestSerial":[]}}
    \    ...    ${item_pr_id}    ${item_pr_order_id}    ${get_id_pdhn}    ${item_num_nhap}    ${item_pr}    ${cat_id}    ${get_id_nguoitao}
    \    ${liststring_prs_order_detail}    Catenate    SEPARATOR=,    ${liststring_prs_order_detail}    ${payload_each_product}
    Log    ${liststring_prs_order_detail}
    ${liststring_prs_order_detail}    Replace String    ${liststring_prs_order_detail}    needdel,    ${EMPTY}    count=1
    #
    ${ma_phieu_nhap}    Generate code automatically    PN
    ${request_payload}    Format String    {{"PurchaseOrder":{{"Code":"{8}","OrderSupplierCode":"{0}","OrderSupplierId":"{1}","PurchaseOrderDetails":[{2}],"UserId":{3},"CompareUserId":{3},"User":{{"IdOld":0,"CompareGivenName":"thao11","CompareIsLimitedByTrans":false,"CompareIsShowSumRow":true,"CompareUserName":"admin","IsTimeSheetException":false,"Id":{3},"Email":"tthao@gmail.com","GivenName":"thao11","CreatedDate":"2020-09-07T11:58:15.7430000+07:00","IsActive":true,"IsAdmin":true,"RetailerId":{4},"UserName":"admin","Type":0,"CreatedBy":0,"CanAccessAnySite":false,"Language":"vi-VN","LocationName":"","WardName":"","isDeleted":false,"Permissions":[],"Apps":[],"Invoices":[],"Transfers1":[],"PriceBookUsers":[],"CashFlows":[],"Invoices1":[],"Orders":[],"Returns1":[],"Manufacturings":[],"DamageItems":[],"TokenApis":[],"SmsEmailTemplates":[],"BalanceAdjustments1":[],"PointAdjustments":[],"PointAdjustmentsCreatedBy":[],"NotificationSettings":[],"DamageItems1":[],"PurchaseOrders1":[],"PurchaseReturns1":[],"CostAdjustments":[],"Devices":[],"OrderSuppliers":[],"OrderSuppliers1":[],"UserDevices":[],"PayslipPayments":[],"PayslipPaymentAllocations":[]}},"CreatedDate":"","ModifiedDate":"2020-12-29T11:11:35.160Z","Description":"","Supplier":{{"IdOld":0,"TotalInvoiced":0,"CompareCode":"{5}","CompareName":"Nha cung capcc25da","ComparePhone":"0985449573","Id":{6},"Name":"Nha cung capcc25da","Phone":"0985449573","RetailerId":{4},"Code":"{5}","CreatedDate":"2020-12-29T18:11:21.9170000+07:00","CreatedBy":{3},"LocationName":"","WardName":"","BranchId":{7},"isDeleted":false,"isActive":true,"SearchNumber":"0985449573","PurchaseOrders":[],"PurchaseReturns":[],"PurchasePayments":[],"SupplierGroupDetails":[],"OrderSuppliers":[]}},"SupplierId":{6},"CompareSupplierId":{6},"SubTotal":1110000,"Branch":{{"Id":{7},"Name":"Chi nhánh trung tâm","Type":0,"Address":"1b Yết kiêu","Province":"Hà Nội","District":"Quận Hoàn Kiếm","ContactNumber":"0379089988","IsActive":true,"RetailerId":{4},"CreatedBy":0,"LimitAccess":false,"LocationName":"Hà Nội - Quận Hoàn Kiếm","WardName":"Phường Trần Hưng Đạo","isAcceptBookClosing":false,"GmbStatus":1,"Orders":[],"Transfers1":[],"DamageItems":[],"SurchargeBranches":[],"AdrApplications":[],"Customers":[],"Suppliers":[],"ExpensesOtherBranches":[],"OrderSuppliers":[],"WarrantyBranchGroups":[],"BranchTakingAddresses":[],"Patients":[],"Clinics":[],"Doctors":[],"DoctorQualifications":[],"DoctorSpecialities":[],"Prescriptions":[],"PayslipPayments":[],"PayslipPaymentAllocations":[],"IdOld":0,"TotalUser":0,"CompareBranchName":"Chi nhánh trung tâm","StatusGmbValue":"Chưa đăng ký","IsTimeSheetException":false,"LocationId":0,"WardId":0}},"Status":1,"StatusValue":"Phiếu tạm","CompareStatusValue":"Phiếu tạm","Discount":0,"CompareDiscount":0,"DiscountRatio":0,"Id":0,"UpdatePurchaseId":0,"Account":{{}},"Total":1110000,"TotalQuantity":9.5,"ExpensesOthersTitle":"","ExpensesOthersRtpTitle":"","PurchaseOrderExpensesOthers":[],"PurchaseOrderExpensesOthersRs":[],"PurchaseOrderExpensesOthersRtp":[],"PurchasePayments":[],"ExReturnSuppliers":0,"ExReturnThirdParty":0,"PaidAmount":0,"PayingAmount":0,"ChangeAmount":-1110000,"paymentMethod":"","BalanceDue":1110000,"DepositReturn":1110000,"OriginTotal":1110000,"PricebookDetail":[],"paymentMethodObj":null,"paymentReturnType":0,"Uuid":"","BranchId":{7}}},"PurchaseOrderLargeData":null,"Complete":true,"CopyFrom":0,"PricebookDetail":[],"IsFinalizedOS":false}}
    ...    ${ma_phieu_dhn}    ${get_id_pdhn}    ${liststring_prs_order_detail}    ${get_id_nguoiban}    ${get_id_nguoitao}    ${input_supplier_code}    ${get_supplier_id}     ${BRANCH_ID}    ${ma_phieu_nhap}
    Log    ${request_payload}
    Post request thr API     /ordersuppliers    ${request_payload}
    Return From Keyword    ${ma_phieu_nhap}

Get purchase order id
    [Documentation]    đây mới là api lấy id của phiếu nhập hàng moà
    [Arguments]    ${ma_phieu_nhap}
    [Timeout]    3 minutes
    ${jsonpath_pur_order_id}    Format String    $..Data[?(@.Code=="{0}")].Id    ${ma_phieu_nhap}
    ${ednpoint_nh}    Format String    ${endpoint_nhaphang_by_branch}    ${BRANCH_ID}
    ${get_pur_oder_id}    Get data from API    ${ednpoint_nh}    ${jsonpath_pur_order_id}
    Return From Keyword    ${get_pur_oder_id}

Update purchase order created from order supplier
    [Documentation]    tạo phiếu đặt hàng lấy all phiếu đặt nhập
    [Arguments]    ${dict_product_num}    ${list_nums}    ${tennhom}    ${input_supplier_code}    ${ma_phieu_dhn}     ${ma_phieu_nhap}
    ${get_supplier_id}    Get Supplier Id    ${input_supplier_code}
    ${id_phieunhap}    Get purchase order id    ${ma_phieu_nhap}
    ${list_prs}    ${list_nums_edit}    ${get_id_nguoitao}    ${get_id_nguoiban}    ${cat_id}    ${get_id_ncc}    ${ten_ncc}    ${get_id_pdhn}    ${get_list_prs_id}    ${list_product_name}
    ...    ${list_product_order_id}    ${get_list_on_order_bf}    ${str_time}    Get data for request copy PDN    ${dict_product_num}    ${tennhom}    ${input_supplier_code}    ${ma_phieu_dhn}
    ${list_imei_status}    ${list_batch_status}    ${list_gtqd}     Get list prs status thr API    ${list_prs}
    ${liststring_prs_order_detail}    Set Variable    needdel
    ${list_imei_all}    Create List
    : FOR    ${item_pr}    ${item_pr_id}    ${item_imei_status}    ${item_batch_status}    ${item_gtqd}    ${item_num_order}    ${item_num_edit}    ${item_pr_order_id}    ${item_name}    IN ZIP
    ...    ${list_prs}    ${get_list_prs_id}    ${list_imei_status}    ${list_batch_status}    ${list_gtqd}    ${list_nums}    ${list_nums_edit}    ${list_product_order_id}    ${list_product_name}
    \    ${get_ma_hh_cb}    Run Keyword If    '${item_batch_status}'=='True' and '${item_gtqd}'=='1'    Get basic product frm unit product    ${item_pr}    ELSE    Set Variable    0
    \    ${batch_name}    ${full_name}    ${expire}    Run Keyword If    '${item_batch_status}'=='True'    Add new batch expire by generating random
    \    ${list_imei}    Run Keyword If    '${item_imei_status}'=='True'    Create list imei by generating random    ${item_num_edit}
    \    ...    ELSE    Set Variable    ${EMPTY}
    \    ${list_imei}    Run Keyword If    '${item_imei_status}'=='True'    Convert List to String    ${list_imei}
    \    ...    ELSE    Set Variable    ${EMPTY}
    \    Append To List    ${list_imei_all}    ${list_imei}
    \    ${payload_each_product}    Run Keyword If    '${item_imei_status}'=='True'    Format string    {{"Unit":"","ListProductUnit":[],"Units":[],"SelectedUnit":{0},"ShowUnit":false,"Shelves":"","Id":{1},"OrderSupplierId":{2},"ProductId":{0},"Quantity":{9},"Price":85000.84,"Discount":12750.13,"Allocation":14450.09,"CreatedDate":"2020-12-15T17:33:45.5900000+07:00","Description":"","DiscountRatio":15,"OrderByNumber":3,"AllocationSuppliers":0,"AllocationThirdParty":0,"OrderQuantity":{9},"RetailerId":0,"Product":{{"IdOld":0,"CrudGuid":"00000000000000000000000000000000","ParentUnits":[],"CategoryOld":0,"Id":{0},"Code":"{4}","Name":"{5}","CategoryId":{6},"AllowsSale":true,"BasePrice":70000,"Tax":0,"RetailerId":{7},"isActive":true,"CreatedDate":"2020-12-15T17:31:37.3270000+07:00","ProductType":2,"HasVariants":false,"Unit":"","ConversionValue":1,"OrderTemplate":"","FullName":"{5}","IsLotSerialControl":true,"IsRewardPoint":false,"isDeleted":false,"MasterCode":"SPC001155","Revision":"AAAAAA3VOVU=","Formula":[],"ProductImages":[],"PurchaseReturnDetails":[],"ProductChild":[],"ProductAttributes":[],"ProductChildUnit":[],"PriceBookDetails":[],"ProductBranches":[],"TableAndRooms":[],"Manufacturings":[],"ManufacturingDetails":[],"DamageDetails":[],"ProductSerials":[],"ProductFormulaHistories":[],"OrderSupplierDetails":[],"ProductShelves":[],"PrescriptionDetails":[],"SamplePrescriptionDetails":[],"OnHand":3,"Reserved":0,"ActualReserved":0}},"ProductName":"{5}","ProductCode":"{4}","SubTotal":144501,"Reserved":0,"OnHand":3,"OnOrder":2,"ActualReserved":0,"tabIndex":100,"ViewIndex":4,"TotalValue":null,"allSuggestSerial":[],"SerialNumbers":"{8}"}}
    \    ...    ${item_pr_id}    ${item_pr_order_id}    ${get_id_pdhn}    ${item_num_edit}    ${item_pr}    ${item_name}    ${cat_id}    ${get_id_nguoitao}    ${list_imei}    ${item_num_edit}
    \    ...    ELSE IF    '${item_batch_status}'=='True'    Format String    {{"Unit":"Hop","ListProductUnit":[],"Units":[{{"Id":{0},"Unit":"Hop","Code":"{1}","Conversion":0,"MasterUnitId":0}}],"SelectedUnit":{0},"ShowUnit":true,"MasterUnitId":10859960,"Shelves":"","Id":{2},"OrderSupplierId":{3},"ProductId":{0},"Quantity":{11},"Price":140000,"Discount":0,"Allocation":0,"CreatedDate":"2020-12-29T18:11:24.8970000+07:00","Description":"","DiscountRatio":0,"OrderByNumber":0,"AllocationSuppliers":0,"AllocationThirdParty":0,"OrderQuantity":{4},"RetailerId":0,"Product":{{"IdOld":0,"CrudGuid":"00000000000000000000000000000000","ParentUnits":[],"CategoryOld":0,"Id":{0},"Code":"{1}","Name":"Lip Balm Himalaya ","CategoryId":{5},"AllowsSale":true,"BasePrice":140000,"Tax":0,"RetailerId":{6},"isActive":true,"CreatedDate":"2020-12-29T18:11:00.6600000+07:00","ProductType":2,"HasVariants":false,"MasterProductId":10859960,"Unit":"Hop","ConversionValue":{10},"MasterUnitId":10859960,"OrderTemplate":"","FullName":"Lip Balm Himalaya (Hop)","IsLotSerialControl":false,"IsRewardPoint":false,"isDeleted":false,"MasterCode":"SPC001466","Revision":"AAAAAA8MPr4=","IsBatchExpireControl":true,"Formula":[],"ProductImages":[],"PurchaseReturnDetails":[],"ProductChild":[],"ProductAttributes":[],"ProductChildUnit":[],"PriceBookDetails":[],"ProductBranches":[],"TableAndRooms":[],"Manufacturings":[],"ManufacturingDetails":[],"DamageDetails":[],"ProductSerials":[],"ProductFormulaHistories":[],"OrderSupplierDetails":[],"ProductShelves":[],"PrescriptionDetails":[],"SamplePrescriptionDetails":[],"OnHand":0,"Reserved":0,"ActualReserved":0}},"ProductName":"Lip Balm Himalaya ","ProductCode":"{1}","SubTotal":490000,"Reserved":0,"OnHand":0,"OnOrder":{4},"ActualReserved":0,"tabIndex":100,"ViewIndex":1,"TotalValue":490000,"allSuggestSerial":[],"ProductBatchExpireList":[{{"Id":-1,"BatchName":"{7}","FullNameVirgule":"{8}","ExpireDate":"{9}","DisplayType":1,"Status":2,"IsUpdate":1,"OnHand":{4},"SystemCount":0}}]}}
    \    ...    ${item_pr_id}    ${item_pr}    ${item_pr_order_id}    ${get_id_pdhn}    ${item_num_edit}    ${cat_id}    ${get_id_nguoitao}    ${batch_name}    ${full_name}
    \    ...    ${expire}    ${item_gtqd}    ${item_num_edit}
    \    ...    ELSE    Format String    {{"Unit":"","ListProductUnit":[],"Units":[],"SelectedUnit":{0},"ShowUnit":false,"Shelves":"","Id":{1},"OrderSupplierId":{2},"ProductId":{0},"Quantity":{7},"Price":150000,"Discount":0,"Allocation":0,"CreatedDate":"2020-12-29T18:11:24.8970000+07:00","Description":"","DiscountRatio":0,"OrderByNumber":3,"AllocationSuppliers":0,"AllocationThirdParty":0,"OrderQuantity":{3},"RetailerId":0,"Product":{{"IdOld":0,"CrudGuid":"00000000000000000000000000000000","ParentUnits":[],"CategoryOld":0,"Id":{0},"Code":"{4}","Name":"Sữa vinamilk pha nguyên kem","CategoryId":{5},"AllowsSale":true,"BasePrice":150000,"Tax":0,"RetailerId":{6},"isActive":true,"CreatedDate":"2020-12-29T18:11:04.8300000+07:00","ProductType":2,"HasVariants":false,"Unit":"","ConversionValue":1,"OrderTemplate":"","FullName":"Sữa vinamilk pha nguyên kem","IsLotSerialControl":false,"IsRewardPoint":false,"isDeleted":false,"MasterCode":"SPC001468","Revision":"AAAAAA8MP00=","Formula":[],"ProductImages":[],"PurchaseReturnDetails":[],"ProductChild":[],"ProductAttributes":[],"ProductChildUnit":[],"PriceBookDetails":[],"ProductBranches":[],"TableAndRooms":[],"Manufacturings":[],"ManufacturingDetails":[],"DamageDetails":[],"ProductSerials":[],"ProductFormulaHistories":[],"OrderSupplierDetails":[],"ProductShelves":[],"PrescriptionDetails":[],"SamplePrescriptionDetails":[],"OnHand":10,"Reserved":0,"ActualReserved":0}},"ProductName":"Sữa vinamilk pha nguyên kem","ProductCode":"{4}","SubTotal":375000,"Reserved":0,"OnHand":10,"OnOrder":{3},"ActualReserved":0,"tabIndex":100,"ViewIndex":4,"TotalValue":null,"allSuggestSerial":[]}}
    \    ...    ${item_pr_id}    ${item_pr_order_id}    ${get_id_pdhn}    ${item_num_edit}    ${item_pr}    ${cat_id}    ${get_id_nguoitao}    ${item_num_edit}
    \    ${liststring_prs_order_detail}    Catenate    SEPARATOR=,    ${liststring_prs_order_detail}    ${payload_each_product}
    Log    ${liststring_prs_order_detail}
    ${liststring_prs_order_detail}    Replace String    ${liststring_prs_order_detail}    needdel,    ${EMPTY}    count=1
    # tạo request
    ${request_payload}    Format String    {{"PurchaseOrder":{{"Code":"{0}","OrderSupplierCode":"{1}","OrderSupplierId":{2},"PurchaseOrderDetails":[{9}],"UserId":{3},"CompareUserId":{3},"User":{{"IdOld":0,"CompareGivenName":"anh.lv","CompareIsLimitedByTrans":false,"CompareIsShowSumRow":true,"CompareUserName":"admin","IsTimeSheetException":false,"Id":{3},"Email":"","GivenName":"anh.lv","MobilePhone":"","CreatedDate":"","IsActive":true,"IsAdmin":true,"RetailerId":{4},"UserName":"admin","Type":0,"CreatedBy":0,"CanAccessAnySite":false,"Language":"vi-VN","LocationName":"","WardName":"","isDeleted":false,"Permissions":[],"Apps":[],"Invoices":[],"Transfers1":[],"PriceBookUsers":[],"CashFlows":[],"Invoices1":[],"Orders":[],"Returns1":[],"Manufacturings":[],"DamageItems":[],"TokenApis":[],"SmsEmailTemplates":[],"BalanceAdjustments1":[],"PointAdjustments":[],"PointAdjustmentsCreatedBy":[],"NotificationSettings":[],"DamageItems1":[],"PurchaseOrders1":[],"PurchaseReturns1":[],"CostAdjustments":[],"Devices":[],"OrderSuppliers":[],"OrderSuppliers1":[],"UserDevices":[],"PayslipPayments":[],"PayslipPaymentAllocations":[]}},"CreatedDate":"","PurchaseDate":"","ComparePurchaseDate":"","Description":"","Supplier":{{"IdOld":0,"TotalInvoiced":0,"CompareCode":"{5}","CompareName":"Nha cung cap1f0e0b","ComparePhone":"0982767981","Id":{7},"Name":"Nha cung cap1f0e0b","Phone":"0982767981","RetailerId":{4},"Code":"{5}","CreatedDate":"2021-01-19T11:33:06.1870000+07:00","CreatedBy":{3},"Debt":994501,"LocationName":"","WardName":"","BranchId":{6},"isDeleted":false,"isActive":true,"SearchNumber":"0982767981","PurchaseOrders":[],"PurchaseReturns":[],"PurchasePayments":[],"SupplierGroupDetails":[],"OrderSuppliers":[]}},"SupplierId":{7},"CompareSupplierId":{7},"SubTotal":994501,"Branch":{{"Id":{6},"Name":"Chi nhánh trung tâm","Type":0,"Address":"1b Yết Kiêu","Province":"Hà Nội","District":"Quận Hoàn Kiếm","ContactNumber":"0987898545","IsActive":true,"RetailerId":{4},"CreatedBy":0,"LimitAccess":false,"LocationName":"Hà Nội - Quận Hoàn Kiếm","WardName":"Phường Trần Hưng Đạo","isAcceptBookClosing":false,"GmbStatus":1,"SubContactNumber":"","ConfirmStatus":1,"Orders":[],"Transfers1":[],"DamageItems":[],"SurchargeBranches":[],"AdrApplications":[],"Customers":[],"Suppliers":[],"ExpensesOtherBranches":[],"OrderSuppliers":[],"WarrantyBranchGroups":[],"BranchTakingAddresses":[],"Patients":[],"Clinics":[],"Doctors":[],"DoctorQualifications":[],"DoctorSpecialities":[],"Prescriptions":[],"PayslipPayments":[],"PayslipPaymentAllocations":[],"IdOld":0,"TotalUser":0,"CompareBranchName":"Chi nhánh trung tâm","StatusGmbValue":"Chưa đăng ký","IsTimeSheetException":false,"LocationId":0,"WardId":0}},"Status":3,"StatusValue":"Đã nhập hàng","CompareStatusValue":"Đã nhập hàng","Discount":0,"CompareDiscount":0,"DiscountRatio":0,"Id":0,"UpdatePurchaseId":{8},"Account":{{}},"Total":994501,"TotalQuantity":8,"ExpensesOthersTitle":"","ExpensesOthersRtpTitle":"","PurchaseOrderExpensesOthers":[],"PurchaseOrderExpensesOthersRs":[],"PurchaseOrderExpensesOthersRtp":[],"PurchasePayments":[],"ExReturnSuppliers":0,"ExReturnThirdParty":0,"PaidAmount":0,"PayingAmount":0,"ChangeAmount":-994501,"paymentMethod":"","BalanceDue":994501,"DepositReturn":994501,"OriginTotal":994501,"PricebookDetail":[],"paymentMethodObj":null,"paymentReturnType":0,"Uuid":"","BranchId":{6}}},"PurchaseOrderLargeData":null,"Complete":true,"CopyFrom":0,"PricebookDetail":[],"IsFinalizedOS":false}}
    ...    ${ma_phieu_nhap}    ${ma_phieu_dhn}     ${get_id_pdhn}    ${get_id_nguoiban}    ${get_id_nguoitao}    ${input_supplier_code}    ${BRANCH_ID}    ${get_id_ncc}     ${id_phieunhap}    ${liststring_prs_order_detail}
    Log    ${request_payload}
    Post request thr API     /ordersuppliers    ${request_payload}
    Return From Keyword    ${ma_phieu_nhap}

Check id of list product
    [Documentation]    kiem tra id cua list hang hoa
    [Arguments]    ${list_prs}
    : FOR    ${item_pr}     IN ZIP    ${list_prs}
    \    ${get_product_id}    Get product ID    ${item_pr}
    \    Run Keyword If    '${get_product_id}'=='0'    Fail    Lỗi do không tạo được hàng hóa

Update number in order supplier
    [Documentation]    update số lượng hàng hóa trong phiếu đặt hàng nhập
    [Arguments]    ${dict_product_num}    ${list_nums}    ${tennhom}    ${input_supplier_code}    ${ma_phieu_dhn}
    ${get_supplier_id}    Get Supplier Id    ${input_supplier_code}
    ${list_prs}    ${list_nums_update}    ${get_id_nguoitao}    ${get_id_nguoiban}    ${cat_id}    ${get_id_ncc}    ${ten_ncc}    ${get_id_pdhn}    ${get_list_prs_id}    ${list_product_name}
    ...    ${list_product_order_id}    ${get_list_on_order_bf}    ${str_time}    Get data for request copy PDN    ${dict_product_num}    ${tennhom}    ${input_supplier_code}    ${ma_phieu_dhn}
    ${list_imei_status}    ${list_batch_status}    ${list_gtqd}     Get list prs status thr API    ${list_prs}
    ${liststring_prs_order_detail}    Set Variable    needdel
    ${list_imei_all}    Create List
    : FOR    ${item_pr}    ${item_pr_id}    ${item_imei_status}    ${item_batch_status}    ${item_gtqd}    ${item_num_order}    ${item_num_edit}    ${item_pr_order_id}    ${item_name}    IN ZIP
    ...    ${list_prs}    ${get_list_prs_id}    ${list_imei_status}    ${list_batch_status}    ${list_gtqd}    ${list_nums}    ${list_nums_update}    ${list_product_order_id}    ${list_product_name}
    \    ${get_ma_hh_cb}    Run Keyword If    '${item_batch_status}'=='True' and '${item_gtqd}'=='1'    Get basic product frm unit product    ${item_pr}    ELSE    Set Variable    0
    \    ${batch_name}    ${full_name}    ${expire}    Run Keyword If    '${item_batch_status}'=='True'    Add new batch expire by generating random
    \    ${list_imei}    Run Keyword If    '${item_imei_status}'=='True'    Create list imei by generating random    ${item_num_edit}
    \    ...    ELSE    Set Variable    ${EMPTY}
    \    ${list_imei}    Run Keyword If    '${item_imei_status}'=='True'    Convert List to String    ${list_imei}
    \    ...    ELSE    Set Variable    ${EMPTY}
    \    Append To List    ${list_imei_all}    ${list_imei}
    \    ${payload_each_product}    Run Keyword If    '${item_imei_status}'=='True'    Format string    {{"Unit":"","ListProductUnit":[],"Units":[],"SelectedUnit":{0},"ShowUnit":false,"Shelves":"","Id":{1},"OrderSupplierId":{2},"ProductId":{0},"Quantity":{9},"Price":85000.84,"Discount":12750.13,"Allocation":14450.09,"CreatedDate":"2020-12-15T17:33:45.5900000+07:00","Description":"","DiscountRatio":15,"OrderByNumber":3,"AllocationSuppliers":0,"AllocationThirdParty":0,"OrderQuantity":{9},"RetailerId":0,"Product":{{"IdOld":0,"CrudGuid":"00000000000000000000000000000000","ParentUnits":[],"CategoryOld":0,"Id":{0},"Code":"{4}","Name":"{5}","CategoryId":{6},"AllowsSale":true,"BasePrice":70000,"Tax":0,"RetailerId":{7},"isActive":true,"CreatedDate":"2020-12-15T17:31:37.3270000+07:00","ProductType":2,"HasVariants":false,"Unit":"","ConversionValue":1,"OrderTemplate":"","FullName":"{5}","IsLotSerialControl":true,"IsRewardPoint":false,"isDeleted":false,"MasterCode":"SPC001155","Revision":"AAAAAA3VOVU=","Formula":[],"ProductImages":[],"PurchaseReturnDetails":[],"ProductChild":[],"ProductAttributes":[],"ProductChildUnit":[],"PriceBookDetails":[],"ProductBranches":[],"TableAndRooms":[],"Manufacturings":[],"ManufacturingDetails":[],"DamageDetails":[],"ProductSerials":[],"ProductFormulaHistories":[],"OrderSupplierDetails":[],"ProductShelves":[],"PrescriptionDetails":[],"SamplePrescriptionDetails":[],"OnHand":3,"Reserved":0,"ActualReserved":0}},"ProductName":"{5}","ProductCode":"{4}","SubTotal":144501,"Reserved":0,"OnHand":3,"OnOrder":0,"ActualReserved":0,"tabIndex":100,"ViewIndex":4,"TotalValue":null,"allSuggestSerial":[],"SerialNumbers":"{8}"}}
    \    ...    ${item_pr_id}    ${item_pr_order_id}    ${get_id_pdhn}    ${item_num_edit}    ${item_pr}    ${item_name}    ${cat_id}    ${get_id_nguoitao}    ${list_imei}    ${item_num_edit}
    \    ...    ELSE IF    '${item_batch_status}'=='True'    Format String    {{"Unit":"Hop","ListProductUnit":[{{"Id":{0},"Unit":"Hop","Code":"TRLDQD006","Conversion":0,"MasterUnitId":0,"PriceChanged":70000,"DiscountChanged":10000.25}}],"Units":[{{"Id":{0},"Unit":"Hop","Code":"TRLDQD006","Conversion":0,"MasterUnitId":0}}],"SelectedUnit":{0},"ShowUnit":true,"MasterUnitId":12383891,"Shelves":"","ProductBatchExpires":[],"Id":{1},"OrderSupplierId":{2},"ProductId":{0},"Quantity":{3},"Price":70000,"Discount":10000.25,"Allocation":11999.91,"CreatedDate":"2021-04-02T15:03:46.1530000+07:00","Description":"","OrderByNumber":0,"AllocationSuppliers":0,"AllocationThirdParty":0,"OrderQuantity":{3},"RetailerId":0,"Product":{{"IdOld":0,"CrudGuid":"00000000000000000000000000000000","ParentUnits":[],"CategoryOld":0,"Id":{0},"Code":"TRLDQD006","Name":"Lip Balm Himalaya ","CategoryId":457670,"AllowsSale":true,"BasePrice":140000,"Tax":0,"RetailerId":{4},"isActive":true,"CreatedDate":"2021-04-02T15:03:18.7330000+07:00","ProductType":2,"HasVariants":false,"MasterProductId":12383891,"Unit":"Hop","ConversionValue":2,"MasterUnitId":12383891,"OrderTemplate":"","FullName":"Lip Balm Himalaya (Hop)","IsLotSerialControl":false,"IsRewardPoint":false,"isDeleted":false,"MasterCode":"SPC003339","Revision":"AAAAABaqlE0=","IsBatchExpireControl":true,"Formula":[],"ProductImages":[],"PurchaseReturnDetails":[],"ProductChild":[],"ProductAttributes":[],"ProductChildUnit":[],"PriceBookDetails":[],"ProductBranches":[],"TableAndRooms":[],"Manufacturings":[],"ManufacturingDetails":[],"DamageDetails":[],"ProductSerials":[],"ProductFormulaHistories":[],"OrderSupplierDetails":[],"ProductShelves":[],"PrescriptionDetails":[],"SamplePrescriptionDetails":[]}},"ProductName":"Lip Balm Himalaya ","ProductCode":"TRLDQD006","SubTotal":269999,"Reserved":0,"OnHand":3.5,"OnOrder":0,"ActualReserved":0,"tabIndex":100,"ViewIndex":1,"rowNumber":0,"TotalValue":269999}}
    \    ...    ${item_pr_id}    ${item_pr_order_id}    ${get_id_pdhn}    ${item_num_edit}    ${get_id_nguoitao}
    \    ...    ELSE    Format String    {{"Unit":"","ListProductUnit":[],"Units":[],"SelectedUnit":{0},"ShowUnit":false,"Shelves":"","Id":{1},"OrderSupplierId":{2},"ProductId":{0},"Quantity":{7},"Price":150000,"Discount":0,"Allocation":0,"CreatedDate":"2020-12-29T18:11:24.8970000+07:00","Description":"","DiscountRatio":0,"OrderByNumber":3,"AllocationSuppliers":0,"AllocationThirdParty":0,"OrderQuantity":{3},"RetailerId":0,"Product":{{"IdOld":0,"CrudGuid":"00000000000000000000000000000000","ParentUnits":[],"CategoryOld":0,"Id":{0},"Code":"{4}","Name":"Sữa vinamilk pha nguyên kem","CategoryId":{5},"AllowsSale":true,"BasePrice":150000,"Tax":0,"RetailerId":{6},"isActive":true,"CreatedDate":"2020-12-29T18:11:04.8300000+07:00","ProductType":2,"HasVariants":false,"Unit":"","ConversionValue":1,"OrderTemplate":"","FullName":"Sữa vinamilk pha nguyên kem","IsLotSerialControl":false,"IsRewardPoint":false,"isDeleted":false,"MasterCode":"SPC001468","Revision":"AAAAAA8MP00=","Formula":[],"ProductImages":[],"PurchaseReturnDetails":[],"ProductChild":[],"ProductAttributes":[],"ProductChildUnit":[],"PriceBookDetails":[],"ProductBranches":[],"TableAndRooms":[],"Manufacturings":[],"ManufacturingDetails":[],"DamageDetails":[],"ProductSerials":[],"ProductFormulaHistories":[],"OrderSupplierDetails":[],"ProductShelves":[],"PrescriptionDetails":[],"SamplePrescriptionDetails":[],"OnHand":10,"Reserved":0,"ActualReserved":0}},"ProductName":"Sữa vinamilk pha nguyên kem","ProductCode":"{4}","SubTotal":375000,"Reserved":0,"OnHand":0,"OnOrder":0,"ActualReserved":0,"tabIndex":100,"ViewIndex":4,"TotalValue":null,"allSuggestSerial":[]}}
    \    ...    ${item_pr_id}    ${item_pr_order_id}    ${get_id_pdhn}    ${item_num_edit}    ${item_pr}    ${cat_id}    ${get_id_nguoitao}    ${item_num_edit}
    \    ${liststring_prs_order_detail}    Catenate    SEPARATOR=,    ${liststring_prs_order_detail}    ${payload_each_product}
    Log    ${liststring_prs_order_detail}
    ${liststring_prs_order_detail}    Replace String    ${liststring_prs_order_detail}    needdel,    ${EMPTY}    count=1
    #
    ${request_payload}    Format String    {{"OrderSupplier":{{"Code":"{0}","OrderSupplierDetails":[{6}],"UserId":{1},"CompareUserId":{1},"User":{{"IdOld":0,"CompareGivenName":"thao11","CompareIsLimitedByTrans":false,"CompareIsShowSumRow":true,"CompareUserName":"admin","IsTimeSheetException":false,"Id":{1},"Email":"tthao@gmail.com","GivenName":"thao11","CreatedDate":"2020-09-07T11:58:15.7430000+07:00","IsActive":true,"IsAdmin":true,"RetailerId":{2},"UserName":"admin","Type":0,"CreatedBy":0,"CanAccessAnySite":false,"Language":"vi-VN","LocationName":"","WardName":"","isDeleted":false,"Permissions":[],"Apps":[],"Invoices":[],"Transfers1":[],"PriceBookUsers":[],"CashFlows":[],"Invoices1":[],"Orders":[],"Returns1":[],"Manufacturings":[],"DamageItems":[],"TokenApis":[],"SmsEmailTemplates":[],"BalanceAdjustments1":[],"PointAdjustments":[],"PointAdjustmentsCreatedBy":[],"NotificationSettings":[],"DamageItems1":[],"PurchaseOrders1":[],"PurchaseReturns1":[],"CostAdjustments":[],"Devices":[],"OrderSuppliers":[],"OrderSuppliers1":[],"UserDevices":[],"PayslipPayments":[],"PayslipPaymentAllocations":[]}},"OrderDate":"2021-04-02T08:03:46.150Z","CreatedDate":"2021-04-02T08:03:46.153Z","ComparePurchaseDate":"2021-04-02T08:03:46.150Z","Description":"","Supplier":{{"IdOld":0,"TotalInvoiced":0,"CompareCode":"TRNCC003","CompareName":"Nha cung capa0e0cb","ComparePhone":"0986033912","IsCusSupCombine":false,"Id":{3},"Name":"Nha cung capa0e0cb","Phone":"0986033912","RetailerId":{2},"Code":"TRNCC003","CreatedBy":{1},"Debt":1052251,"LocationName":"","WardName":"","BranchId":{4},"isDeleted":false,"isActive":true,"SearchNumber":"0986033912","PurchaseOrders":[],"PurchaseReturns":[],"PurchasePayments":[],"SupplierGroupDetails":[],"OrderSuppliers":[],"CustomerSupplierCombines":[]}},"SupplierId":{3},"CompareSupplierId":{3},"SubTotal":707502,"Branch":{{"Id":{4},"Name":"Chi nhánh trung tâm","Type":0,"Address":"1b Yết kiêu","Province":"Hà Nội","District":"Quận Hoàn Kiếm","ContactNumber":"0379089988","IsActive":true,"RetailerId":{2},"CreatedBy":0,"LimitAccess":false,"LocationName":"Hà Nội - Quận Hoàn Kiếm","WardName":"Phường Trần Hưng Đạo","isAcceptBookClosing":false,"GmbStatus":1,"Orders":[],"Transfers1":[],"DamageItems":[],"SurchargeBranches":[],"AdrApplications":[],"Customers":[],"Suppliers":[],"ExpensesOtherBranches":[],"OrderSuppliers":[],"WarrantyBranchGroups":[],"BranchTakingAddresses":[],"Patients":[],"Clinics":[],"Doctors":[],"DoctorQualifications":[],"DoctorSpecialities":[],"Prescriptions":[],"PayslipPayments":[],"PayslipPaymentAllocations":[],"IdOld":0,"TotalUser":0,"CompareBranchName":"Chi nhánh trung tâm","StatusGmbValue":"Chưa đăng ký","IsTimeSheetException":false,"LocationId":0,"WardId":0}},"Status":2,"StatusValue":"Nhập một phần","CompareStatusValue":"Nhập một phần","Discount":0,"CompareDiscount":0,"DiscountRatio":0,"Id":{5},"Account":{{}},"Total":566002,"TotalQuantity":9.5,"ExpensesOthersTitle":"","ExpensesOthersRtpTitle":"","OrderSupplierExpensesOthers":[],"OrderSupplierExpensesOthersRs":[],"OrderSupplierExpensesOthersRtp":[],"ExReturnSuppliers":0,"ExReturnThirdParty":0,"PaidAmount":0,"PayingAmount":0,"ChangeAmount":-566002,"paymentMethod":"","BalanceDue":566002,"paymentReturnType":0,"OriginTotal":566002,"paymentMethodObj":null,"PurchaseOrderExpenssaveDataesOthers":[],"PurchasePayments":[],"BranchId":{4}}},"Complete":true,"CopyFrom":0}}
    ...    ${ma_phieu_dhn}    ${get_id_nguoiban}    ${get_id_nguoitao}    ${get_supplier_id}    ${BRANCH_ID}    ${get_id_pdhn}    ${liststring_prs_order_detail}
    Log    ${request_payload}
    ${headers}=    Create Dictionary    Authorization=${bearertoken}    Content-Type=application/json;charset=UTF-8    Retailer=${RETAILER_NAME}    BranchId=${BRANCH_ID}    Zone=${env}
    Create Session    lolo    ${API_URL}    cookies=${resp.cookies}    verify=True    debug=1
    ${resp}=    Wait Until Keyword Succeeds    3x    0s     Post Request    lolo    /ordersuppliers?kvuniqueparam=2020    data=${request_payload}    headers=${headers}
    Log    ${resp.request.body}
    Log    ${resp.json()}
    Log    ${resp.status_code}
    Should Be Equal As Strings    ${resp.status_code}    200

Get on order frm API
    [Arguments]    ${prs_code}
    [Documentation]     lấy order của hàng hóa
    [Timeout]    3 minutes
    ${endpoint_hh}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${resp}    Get Request and return body    ${endpoint_hh}
    ${endpoint_on_order}    Format String    $..Data[?(@.Code=="{0}")].OnOrder    ${prs_code}
    ${get_on_order}    Get data from response json    ${resp}    ${endpoint_on_order}
    Return From Keyword    ${get_on_order}
