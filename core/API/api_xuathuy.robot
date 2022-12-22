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
Resource          ../../config/env_product/envi.robot

*** Variables ***
${endpoint_ds_phieu_xuat_huy}    /damageItems?format=json&Includes=TotalAmount&Includes=TotalQuantity&Includes=User&Includes=User1&Includes=Branch&%24inlinecount=allpages&%24top=15&%24filter=(BranchId+eq+{0}+and+TransDate+eq+%27year%27+and+(Status+eq+1+or+Status+eq+2))
${endpoint_delete_phieu_xh}    /damageItems?CompareDamageItemCode={0}&CompareStatus=2&Id={1}    #0: ma phieu, #1: id phieu
${endpoint_chi_tiet_phieu_xh}    /damageitems/{0}/details?format=json&Includes=Product&Includes=ProductBatchExpire&%24inlinecount=allpages

*** Keywords ***
Delete damage documentation thr API
    [Timeout]     3 minute
    [Arguments]    ${ma_phieu}
    ${get_phieu_id}    Get damage id    ${ma_phieu}
    ${endpoint_delete_pnh_by_id}    Format String    ${endpoint_delete_phieu_xh}    ${ma_phieu}    ${get_phieu_id}
    Delete request thr API    ${endpoint_delete_pnh_by_id}

Get damage documentation infor
    [Timeout]     3 minute
    [Arguments]    ${ma_phieu}
    ${endpoint_ds_phieu_xuat_huy}    Format String    ${endpoint_ds_phieu_xuat_huy}    ${BRANCH_ID}
    ${get_resp}    Get Request and return body    ${endpoint_ds_phieu_xuat_huy}
    ${jsonpath_tong_sl}    Format String    $..Data[?(@.Code=="{0}")].TotalQuantity    ${ma_phieu}
    ${jsonpath_tong_gt_huy}    Format String    $..Data[?(@.Code=="{0}")].TotalAmount    ${ma_phieu}
    ${jsontpath_trangthai}    Format String    $..Data[?(@.Code=="{0}")].Status    ${ma_phieu}
    ${get_tong_so_luong}    Get data from response json    ${get_resp}    ${jsonpath_tong_sl}
    ${get_tong_gt_huy}    Get data from response json    ${get_resp}    ${jsonpath_tong_gt_huy}
    ${get_trang_thai}    Get data from response json    ${get_resp}    ${jsontpath_trangthai}
    Return From Keyword    ${get_tong_so_luong}    ${get_tong_gt_huy}    ${get_trang_thai}

Get damage id
    [Timeout]     3 minute
    [Arguments]    ${ma_phieu}
    ${endpoint_ds_phieu_xuat_huy}    Format String    ${endpoint_ds_phieu_xuat_huy}    ${BRANCH_ID}
    ${jsonpath_phieu_xh_id}    Format String    $..Data[?(@.Code=="{0}")].Id    ${ma_phieu}
    ${get_phieu_id}    Get data from API    ${endpoint_ds_phieu_xuat_huy}    ${jsonpath_phieu_xh_id}
    Return From Keyword    ${get_phieu_id}

Add new damage documentation with multi product
    [Timeout]     5 minute
    [Arguments]    ${dict_product_nums}
    ${list_product}    Get Dictionary Keys    ${dict_product_nums}
    ${list_number}    Get Dictionary Values    ${dict_product_nums}
    ${get_nguoitao_id}    Get User ID
    ${endpoint_danhmuc_hh_co_dvt}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${get_resp_dmhh}    Get Request and return body    ${endpoint_danhmuc_hh_co_dvt}
    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}    Get list jsonpath product frm list product    ${list_product}
    ${list_giaban}    ${list_id_sp}    Get product info frm list jsonpath product    ${get_resp_dmhh}    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}
    ${get_id_sp1}    Get From List    ${list_id_sp}    0
    ${get_id_sp2}    Get From List    ${list_id_sp}    1
    ${get_id_sp3}    Get From List    ${list_id_sp}    2
    ${input_soluong1}    Get From List    ${list_number}    0
    ${input_soluong2}    Get From List    ${list_number}    1
    ${input_soluong3}    Get From List    ${list_number}    2
    #
    ${ma_phieu}    Generate code automatically    XH
    ${request_payload}    Format String    {{"DamageItem":{{"Code":"{0}","DamageDetails":[{{"ProductId":{1},"Product":{{"Name":"Kem gấu TH true milk","Code":"NHP003","IsLotSerialControl":false,"IsBatchExpireControl":false,"ProductShelvesStr":"","OnHand":-5,"Reserved":0}},"ProductCode":"NHP003","ProductName":"Kem gấu TH true milk","Description":"","ProductCost":35000,"ShowUnit":false,"ListProductUnit":[{{"Id":4071650,"Unit":"","Code":"NHP003","Conversion":0,"MasterUnitId":0}}],"Units":[{{"Id":4071650,"Unit":"","Code":"NHP003","Conversion":0,"MasterUnitId":0}}],"Unit":"","SelectedUnit":4071650,"Quantity":{2},"ProductSerials":[],"IsLotSerialControl":false,"ProductBatchExpires":[],"ConversionValue":1,"OnOrder":0,"rowNumber":0,"totalCost":385000,"viewIndex":0,"tempProductSerials":[],"OrderByNumber":0}},{{"ProductId":{3},"Product":{{"Name":"Ô mai chanh đào Hồng Lam","Code":"NHP002","IsLotSerialControl":false,"IsBatchExpireControl":false,"ProductShelvesStr":"","OnHand":0,"Reserved":0}},"ProductCode":"NHP002","ProductName":"Ô mai chanh đào Hồng Lam","Description":"","ProductCost":30000,"ShowUnit":false,"ListProductUnit":[{{"Id":4071649,"Unit":"","Code":"NHP002","Conversion":0,"MasterUnitId":0}}],"Units":[{{"Id":4071649,"Unit":"","Code":"NHP002","Conversion":0,"MasterUnitId":0}}],"Unit":"","SelectedUnit":4071649,"Quantity":{4},"ProductSerials":[],"IsLotSerialControl":false,"ProductBatchExpires":[],"ConversionValue":1,"OnOrder":0,"rowNumber":1,"totalCost":360000,"viewIndex":1,"tempProductSerials":[],"OrderByNumber":1}},{{"ProductId":{5},"Product":{{"Name":"Bánh xu kem Nhật","Code":"NHP001","IsLotSerialControl":false,"IsBatchExpireControl":false,"ProductShelvesStr":"","OnHand":1196,"Reserved":0}},"ProductCode":"NHP001","ProductName":"Bánh xu kem Nhật","Description":"","ProductCost":50000,"ShowUnit":false,"ListProductUnit":[{{"Id":4071647,"Unit":"","Code":"NHP001","Conversion":0,"MasterUnitId":0}}],"Units":[{{"Id":4071647,"Unit":"","Code":"NHP001","Conversion":0,"MasterUnitId":0}}],"Unit":"","SelectedUnit":4071647,"Quantity":{6},"ProductSerials":[],"IsLotSerialControl":false,"ProductBatchExpires":[],"ConversionValue":1,"OnOrder":0,"rowNumber":2,"totalCost":650000,"viewIndex":2,"tempProductSerials":[],"OrderByNumber":2}}],"UserId":{7},"CompareUserId":{7},"User":{{"id":{7},"username":"admin","givenName":"admin","Id":{7},"UserName":"admin","GivenName":"admin","IsAdmin":true,"IsLimitedByTrans":false,"IsShowSumRow":true,"Theme":""}},"Description":"","Branch":{{"id":{8},"name":"Chi nhánh trung tâm","Id":{8},"Name":"Chi nhánh trung tâm","Address":"abc","LocationName":"Hà Nội - Quận Cầu Giấy","WardName":"","ContactNumber":"","SubContactNumber":""}},"Status":1,"CompareStatus":1,"StatusValue":"Phiếu tạm","Id":0,"TotalQuantity":36,"TotalDamageCost":1395000,"SubTotal":0}},"Complete":false}}    ${ma_phieu}    ${get_id_sp1}    ${input_soluong1}    ${get_id_sp2}
    ...    ${input_soluong2}    ${get_id_sp3}    ${input_soluong3}    ${get_nguoitao_id}    ${BRANCH_ID}
    Log    ${request_payload}
    ${resp}    Post request to create damage doc and get resp    ${request_payload}
    Return From Keyword    ${ma_phieu}

Post request to create damage doc and get resp
    [Timeout]     3 minute
    [Arguments]    ${request_payload}
    ${resp}   Post request thr API     /damageItems    ${request_payload}
    Return From Keyword        ${resp}

Get total quallity - total amount by damage code
    [Timeout]     5 minute
    [Arguments]    ${ma_phieu}
    ${jsonpath_total_qlty}    Format String    $..Data[?(@.Code == '{0}')].TotalQuantity    ${ma_phieu}
    ${jsonpath_total_amount}    Format String    $..Data[?(@.Code == '{0}')].TotalAmount    ${ma_phieu}
    ${endpoint_ds_phieu_xuat_huy}    Format String    ${endpoint_ds_phieu_xuat_huy}    ${BRANCH_ID}
    ${resp}    Get Request and return body    ${endpoint_ds_phieu_xuat_huy}
    ${get_total_qltyl}    Get data from response json    ${resp}    ${jsonpath_total_qlty}
    ${get_total_amount}    Get data from response json    ${resp}    ${jsonpath_total_amount}
    Return From Keyword    ${get_total_qltyl}    ${get_total_amount}

Get list of quality - damage value by damage code
    [Timeout]     5 minute
    [Arguments]    ${ma_phieu}    ${list_sp}
    ${get_damage_id}    Get damage id    ${ma_phieu}
    ${endpoint_chitiet}    Format String    ${endpoint_chi_tiet_phieu_xh}    ${get_damage_id}
    ${list_id_sp}    Get list product id thr API    ${list_sp}
    ${list_soluong}    Create List
    ${list_gt_huy}    Create List
    ${get_resp}    Get Request and return body    ${endpoint_chitiet}
    Log    ${get_resp}
    : FOR    ${item_id_sp}    IN ZIP    ${list_id_sp}
    \    ${jsonpath_quality}    Format String    $..Data[?(@.ProductId=={0})].Quantity    ${item_id_sp}
    \    ${jsonpath_cost}    Format String    $..Data[?(@.ProductId=={0})].ProductCost    ${item_id_sp}
    \    ${so_luong}    Get data from response json    ${get_resp}    ${jsonpath_quality}
    \    ${gia_von}    Get data from response json    ${get_resp}    ${jsonpath_cost}
    \    ${gt_huy}    Multiplication and round    ${gia_von}    ${so_luong}
    \    Append To List    ${list_soluong}    ${so_luong}
    \    Append To List    ${list_gt_huy}    ${gt_huy}
    Return From Keyword    ${list_soluong}    ${list_gt_huy}

Get list product by damage code
    [Timeout]     3 minute
    [Arguments]    ${ma_phieu}
    ${get_damage_id}    Get damage id    ${ma_phieu}
    ${endpoint_chitiet}    Format String    ${endpoint_chi_tiet_phieu_xh}    ${get_damage_id}
    ${get_resp}    Get Request and return body    ${endpoint_chitiet}
    ${get_list_hh}    Get raw data from response json    ${get_resp}    $..Data..Product.Code
    Return From Keyword    ${get_list_hh}

Add new damage frm API
    [Arguments]    ${dict_product_num}
    ${list_product}    Get Dictionary Keys    ${dict_product_num}
    ${list_nums}    Get Dictionary Values    ${dict_product_num}
    ${endpoint_danhmuc_hh_by_branch}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${get_list_prd_id}    Get list product id thr API    ${list_product}
    ${get_list_cost}  Get list cost frm API by product code    ${list_product}
    Create list imei and other product    ${list_product}    ${list_nums}
    ${list_thanhtien}   Create List
    :FOR    ${item_nums}    ${item_price}   IN ZIP    ${list_nums}    ${get_list_cost}
    \       ${item_thanhtien}   Multiplication with price round 2    ${item_nums}    ${item_price}
    \       Append To List    ${list_thanhtien}    ${item_thanhtien}
    ${result_tonggiatri}    Sum values in list    ${list_thanhtien}
    ##
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    # Post request BH
    ${ma_phieu}    Generate code automatically    XH
    ${liststring_prs_damage_detail}    Set Variable    needdel
    Log    ${liststring_prs_damage_detail}
    : FOR    ${item_product_id}    ${item_price}    ${item_num}   ${item_thanhtien}   ${item_imei}    IN ZIP    ${get_list_prd_id}    ${get_list_cost}    ${list_nums}    ${list_thanhtien}    ${imei_inlist}
    \    ${item_imei}    Convert list to string and return    ${item_imei}
    \    ${payload_each_product}    Format string    {{"ProductId":{0},"Product":{{"Name":"Kệ đựng đồ","Code":"IM27","IsLotSerialControl":true,"IsBatchExpireControl":false,"ProductShelvesStr":"","OnHand":31,"Reserved":0}},"ProductCode":"IM27","ProductName":"Kệ đựng đồ","Description":"","ProductCost":{1},"ShowUnit":false,"ListProductUnit":[{{"Id":{0},"Unit":"","Code":"IM27","Conversion":0,"MasterUnitId":0}}],"Units":[{{"Id":{0},"Unit":"","Code":"IM27","Conversion":0,"MasterUnitId":0}}],"Unit":"","SelectedUnit":{0},"Quantity":{2},"ProductSerials":[],"IsLotSerialControl":true,"ProductBatchExpires":[],"ConversionValue":1,"OnOrder":0,"rowNumber":1,"totalCost":{3},"SerialNumbers":"{4}","SelectedSerials":[{{"text":"{4}","SerialNumber":"{4}","cssClass":""}}],"viewIndex":1,"isSerialProduct":true,"tempProductSerials":[],"OrderByNumber":1}}    ${item_product_id}    ${item_price}    ${item_num}   ${item_thanhtien}    ${item_imei}
    \    ${liststring_prs_damage_detail}    Catenate    SEPARATOR=,    ${liststring_prs_damage_detail}    ${payload_each_product}
    ${liststring_prs_damage_detail}    Replace String    ${liststring_prs_damage_detail}    needdel,    ${EMPTY}    count=1
    ${request_payload}    Format String    {{"DamageItem":{{"Code":"{0}","DamageDetails":[{1}],"UserId":{2},"CompareUserId":{2},"User":{{"id":{2},"username":"admin","givenName":"anh.lv","Id":{2},"UserName":"admin","GivenName":"anh.lv","IsAdmin":true,"IsLimitedByTrans":false,"IsShowSumRow":true,"Theme":""}},"Description":"","Branch":{{"id":{3},"name":"Chi nhánh trung tâm","Id":{3},"Name":"Chi nhánh trung tâm","Address":"1B Yết Kiêu","LocationName":"Hà Nội - Quận Hoàn Kiếm","WardName":"","ContactNumber":"","SubContactNumber":""}},"Status":1,"CompareStatus":1,"StatusValue":"Phiếu tạm","Id":0,"TotalQuantity":3,"TotalDamageCost":{4},"SubTotal":0}},"DamageItemLargeData":null,"Complete":true}}    ${ma_phieu}    ${liststring_prs_damage_detail}    ${get_id_nguoiban}    ${BRANCH_ID}    ${result_tonggiatri}
    Log    ${request_payload}
    Post request to create damage doc and get resp    ${request_payload}
    Return From Keyword    ${ma_phieu}

Get total - result onhand af damage
    [Arguments]    ${list_pr}    ${list_actual_pr}    ${list_num}
    ${list_result_total}    Create List
    ${list_result_onhand_actual}    Create List
    ${list_result_onhand_cb}    Create List
    ${list_actual_num_cb}    Create List
    ${list_actual_cost}    Create List
    ${list_cost_cb}     Create List
    ${get_list_cost_cb_bf}    ${get_list_onhand_cb_bf}    Get list cost - onhand frm API    ${list_pr}
    ${get_list_onhand_actual_bf}    ${get_list_latestprice_actual}    ${get_list_cost_actual_bf}    ${list_dvqd_unit}    Get list of Onhand, LastestPurchasePrice and Cost - Conversation values by searching product API    ${list_actual_pr}
    : FOR    ${item_onhand_actual}    ${item_cost_actual}    ${item_dvqd}    ${item_num}    ${item_onhand_cb}    ${item_cost_cb}
    ...    IN ZIP    ${get_list_onhand_actual_bf}    ${get_list_cost_actual_bf}    ${list_dvqd_unit}    ${list_num}    ${get_list_onhand_cb_bf}
    ...    ${get_list_cost_cb_bf}
    \    ${actual_pr_num_cb}    Multiplication    ${item_dvqd}    ${item_num}
    \    ${actual_pr_num_cb}=    Evaluate    round(${actual_pr_num_cb}, 3)
    \    ${result_onhand_cb}    Minus    ${item_onhand_cb}    ${actual_pr_num_cb}
    \    ${result_onhand_actual}    Minus    ${item_onhand_actual}    ${item_num}
    \    ${result_cost_actual}    Multiplication with price round 2    ${item_cost_cb}    ${item_dvqd}
    \    ${total}    Multiplication and round    ${item_num}    ${result_cost_actual}
    \    Append To List    ${list_result_total}    ${total}
    \    Append To List    ${list_result_onhand_actual}    ${result_onhand_actual}
    \    Append To List    ${list_result_onhand_cb}    ${result_onhand_cb}
    \    Append To List    ${list_actual_num_cb}    ${actual_pr_num_cb}
    ${result_tong_gt_huy}    Sum values in list    ${list_result_total}
    ${result_tong_sl_huy}    Sum values in list    ${list_num}
    Return From Keyword    ${result_tong_gt_huy}    ${result_tong_sl_huy}    ${list_result_onhand_cb}    ${list_actual_num_cb}

Assert damage documentation infor
    [Arguments]     ${ma_phieu}     ${input_lastest_num}     ${input_tong_gt_huy}     ${input_trangthai}
    ${get_tong_sl}    ${get_tong_gt_huy}    ${get_trang_thai}    Get damage documentation infor    ${ma_phieu}
    Should Be Equal As Numbers    ${get_tong_sl}    ${input_lastest_num}
    Should Be Equal As Numbers    ${get_tong_gt_huy}    ${input_tong_gt_huy}
    Should Be Equal As Numbers    ${get_trang_thai}    ${input_trangthai}

Assert damage documentation infor until susseed
    [Arguments]     ${ma_phieu}     ${input_lastest_num}     ${input_tong_gt_huy}   ${input_trangthai}
    Wait Until Keyword Succeeds   5x      3s      Assert damage documentation infor    ${ma_phieu}     ${input_lastest_num}     ${input_tong_gt_huy}    ${input_trangthai}
