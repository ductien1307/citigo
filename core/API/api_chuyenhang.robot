*** Settings ***
Resource          api_access.robot
Resource          api_danhmuc_hanghoa.robot
Resource          ../share/imei.robot

*** Variables ***
${endpoint_delete_pch}    /transfers?CompareCode={0}&CompareStatus=2&Id={1}    #0: ma phieu - 1: Id phiếu chuyển hàng
${endpoint_pch_list}    /Transfers?format=json&Includes=FromBranch&Includes=ToBranch&Includes=User&Includes=ReceivedUser&Includes=TotalSendQuantity&Includes=TotalReceiveQuantity&Includes=TotalProductType&%24inlinecount=allpages&FromDate=&ToDate=&MatchStatus=0&TimeRange=month&IsCheckTimeRange=true&%24top=10&%24filter
${endpoint_pch_active_list}     /Transfers?format=json&Includes=FromBranch&Includes=ToBranch&Includes=User&Includes=ReceivedUser&Includes=TotalSendQuantity&Includes=TotalReceiveQuantity&Includes=TotalProductType&%24inlinecount=allpages&FromDate=&ToDate=&MatchStatus=0&TimeRange=alltime&IsCheckTimeRange=true&%24top=15&%24filter=((FromBranchId+eq+{0}+or+ToBranchId+eq+{0})+and+(Status+eq+1+or+Status+eq+2+or+Status+eq+3)+and+(Status+eq+1+or+Status+eq+2+or+Status+eq+3)+and+(Status+eq+1+or+Status+eq+2+or+Status+eq+3)+and+(Status+eq+1+or+Status+eq+2+or+Status+eq+3))    #branch id

*** Keywords ***
Delete Transform code
    [Arguments]    ${input_transformcode}
    [Timeout]    3 minutes
    ${jsonpath_transformid}    Format String    $..Data[?(@.Code=="{0}")].Id    ${input_transformcode}
    ${get_transform_id}    Get data from API    ${endpoint_pch_list}    ${jsonpath_transformid}
    ${endpoint_delete_pch_by_id}    Format String    ${endpoint_delete_pch}    ${input_transformcode}    ${get_transform_id}
    Delete request thr API    ${endpoint_delete_pch_by_id}

Delete Transform code with other user
    [Arguments]    ${input_transformcode}   ${get_bearertoken}    ${resp.cookies}
    [Timeout]    3 minutes
    ${jsonpath_transformid}    Format String    $..Data[?(@.Code=="{0}")].Id    ${input_transformcode}
    ${get_transform_id}    Get data from API    ${endpoint_pch_list}    ${jsonpath_transformid}
    ${endpoint_delete_pch_by_id}    Format String    ${endpoint_delete_pch}    ${input_transformcode}    ${get_transform_id}
    Delete request thr API    ${endpoint_delete_pch_by_id}

Post request to create transform
    [Arguments]    ${request_payload}
    Post request thr API    /transfers    ${request_payload}

Add new transform frm API
    [Arguments]    ${input_branch_chuyen}    ${input_branch_nhan}  ${dict_product_nums}
    ${list_product}    Get Dictionary Keys    ${dict_product_nums}
    ${list_nums}    Get Dictionary Values    ${dict_product_nums}
    ${ma_phieuchuyen}    Generate code automatically    PCH
    Create list imei and other product    ${list_product}    ${list_nums}
    ${list_result_transferring_onhand}    Create List
    ${list_result_received_onhand}    Create List
    :FOR      ${item_product}   ${item_nums}    IN ZIP    ${list_product}     ${list_nums}
    \     ${transferring_onhand_af_trans}    ${transferring_cost_af_trans}    Get Cost and OnHand frm API    ${item_product}
    \     ${received_onhand_af_trans}    ${received_cost_af_trans}    Get Cost and Onhand frm API by Branch    ${item_product}    ${input_branch_nhan}
    \    ${transferring_onhand_bf_trans}    Minus    ${transferring_onhand_af_trans}    ${item_nums}
    \    ${received_onhand_bf_trans}    Sum    ${received_onhand_af_trans}    ${item_nums}
    \    Append To List    ${list_result_transferring_onhand}    ${transferring_onhand_bf_trans}
    \    Append To List    ${list_result_received_onhand}    ${received_onhand_bf_trans}
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${get_list_product_id}    Get list product id thr API    ${list_product}
    ${get_list_cost}    Get list cost frm API by product code    ${list_product}
    ${get_branch_id_chuyen}   Get BranchID by BranchName    ${input_branch_chuyen}
    ${get_branch_id_nhan}   Get BranchID by BranchName    ${input_branch_nhan}
    ${liststring_prs_tranform_detail}     Set Variable      needdel
    Log        ${liststring_prs_tranform_detail}
    : FOR   ${item_id_sp}   ${item_soluong}    ${item_giavon}    ${item_imei}    IN ZIP        ${get_list_product_id}    ${list_nums}      ${get_list_cost}    ${imei_inlist}
    \    ${item_imei}    Convert list to string and return    ${item_imei}
    \    ${quantity}    Set Variable If    '${item_imei}' != 'null'    0    ${item_soluong}
    \    ${payload_each_product}        Format string       {{"ProductId":{0},"OnHand":31,"Product":{{"Id":{0},"Name":"Máy Xay Sinh Tố Philips HR2118","Code":"SI031","IsLotSerialControl":true,"IsBatchExpireControl":false,"ProductShelvesStr":"","OnHand":31,"Reserved":38}},"SendQuantity":{1},"ReceiveQuantity":{2},"Price":{3},"ProductName":"Máy Xay Sinh Tố Philips HR2118","ProductSerials":[],"ShowUnit":false,"ListProductUnit":[{{"Id":{0},"Unit":"","Code":"SI031","Conversion":0,"MasterUnitId":0}}],"Units":[{{"Id":{0},"Unit":"","Code":"SI031","Conversion":0,"MasterUnitId":0}}],"Unit":"","SelectedUnit":{0},"OnOrder":0,"SendPrice":0,"ReceiverPrice":0,"SerialNumbers":"{4}","rowNumber":0,"NextBranchQuantity":0,"rowShowSerials":0,"isSerialProduct":true,"AdjustmentValue":1,"ReceiveQuantityNotNull":0,"IsMatchProductBatchExpire":false,"IsZeroProductBatchExpire":true,"OrderByNumber":0}}    ${item_id_sp}   ${item_soluong}    ${quantity}    ${item_giavon}    ${item_imei}
    \    ${liststring_prs_tranform_detail}       Catenate      SEPARATOR=,      ${liststring_prs_tranform_detail}      ${payload_each_product}
    ${liststring_prs_tranform_detail}       Replace String      ${liststring_prs_tranform_detail}       needdel,       ${EMPTY}      count=1
    ##post request
    ${request_payload}    Format String    {{"Transfer":{{"Id":0,"Code":"{0}","TransferDetails":[{1}],"FromBranchId":{2},"FromBranch":{{"id":{2},"name":"Chi nhánh trung tâm","address":"1B Yết Kiêu","LocationId":0,"LocationName":"Hà Nội - Quận Hoàn Kiếm","WardId":0,"WardName":"","Id":{2},"Name":"Chi nhánh trung tâm","Address":"1B Yết Kiêu","CompanyName":"autoto","BearerToken":"","Privileges":{{}}}},"ToBranchId":{3},"ToBranch":{{"Id":{3},"Name":"Nhánh A","Type":0,"Address":"22A Hai Bà Trưng","Province":"Hà Nội","District":"Quận Hoàn Kiếm","ContactNumber":"0987654321","IsActive":true,"RetailerId":{4},"CreatedBy":{5},"LimitAccess":false,"LocationName":"Hà Nội - Quận Hoàn Kiếm","WardName":"","isAcceptBookClosing":false,"GmbStatus":1,"Orders":[],"Transfers1":[],"DamageItems":[],"SurchargeBranches":[],"AdrApplications":[],"Customers":[],"Suppliers":[],"ExpensesOtherBranches":[],"OrderSuppliers":[],"WarrantyBranchGroups":[],"BranchTakingAddresses":[],"Patients":[],"Clinics":[],"Doctors":[],"DoctorQualifications":[],"DoctorSpecialities":[],"Prescriptions":[],"PayslipPayments":[],"PayslipPaymentAllocations":[],"IdOld":0,"TotalUser":0,"CompareBranchName":"Nhánh A","StatusGmbValue":"Chưa đăng ký","IsTimeSheetException":false}},"Status":2,"CompareStatus":1,"StatusValue":"Phiếu tạm","CreatedBy":{5},"User":{{"id":{5},"username":"admin","givenName":"anh.lv","Id":{5},"UserName":"admin","GivenName":"anh.lv","IsAdmin":true,"IsLimitedByTrans":false,"IsShowSumRow":true,"Theme":""}},"Description":"","ReceivedDescription":"","TotalSendQuantity":2,"TotalReceiveQuantity":1,"Price":0,"TransferType":0}},"TransferLargeData":null,"CopyFrom":""}}    ${ma_phieuchuyen}   ${liststring_prs_tranform_detail}    ${get_branch_id_chuyen}    ${get_branch_id_nhan}     ${get_id_nguoitao}    ${get_id_nguoiban}
    Log    ${request_payload}
    Post request to create transform    ${request_payload}
    Return From Keyword    ${ma_phieuchuyen}    ${list_result_transferring_onhand}    ${list_result_received_onhand}

Add new transform with other user
    [Arguments]    ${input_branch_chuyen}    ${input_branch_nhan}  ${dict_product_nums}    ${input_username}    ${input_password}
    ${get_bearertoken}    ${resp.cookies}     Get BearerToken with other user    ${input_username}    ${input_password}
    ${list_product}    Get Dictionary Keys    ${dict_product_nums}
    ${list_nums}    Get Dictionary Values    ${dict_product_nums}
    ${ma_phieuchuyen}    Generate code automatically    PCH
    Create list imei and other product    ${list_product}    ${list_nums}
    ${list_result_transferring_onhand}    Create List
    ${list_result_received_onhand}    Create List
    :FOR      ${item_product}   ${item_nums}    IN ZIP    ${list_product}     ${list_nums}
    \     ${transferring_onhand_af_trans}    ${transferring_cost_af_trans}    Get Cost and OnHand frm API    ${item_product}
    \     ${received_onhand_af_trans}    ${received_cost_af_trans}    Get Cost and Onhand frm API by Branch    ${item_product}    ${input_branch_nhan}
    \    ${transferring_onhand_bf_trans}    Minus    ${transferring_onhand_af_trans}    ${item_nums}
    \    ${received_onhand_bf_trans}    Sum    ${received_onhand_af_trans}    ${item_nums}
    \    Append To List    ${list_result_transferring_onhand}    ${transferring_onhand_bf_trans}
    \    Append To List    ${list_result_received_onhand}    ${received_onhand_bf_trans}
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID by UserName    ${input_username}
    ${get_list_product_id}    Get list product id thr API    ${list_product}
    ${get_list_cost}    Get list cost frm API by product code    ${list_product}
    ${get_branch_id_chuyen}   Get BranchID by BranchName    ${input_branch_chuyen}
    ${get_branch_id_nhan}   Get BranchID by BranchName    ${input_branch_nhan}
    ${liststring_prs_tranform_detail}     Set Variable      needdel
    Log        ${liststring_prs_tranform_detail}
    : FOR   ${item_id_sp}   ${item_soluong}    ${item_giavon}    ${item_imei}    IN ZIP        ${get_list_product_id}    ${list_nums}      ${get_list_cost}    ${imei_inlist}
    \    ${item_imei}    Convert list to string and return    ${item_imei}
    \    ${quantity}    Set Variable If    '${item_imei}' != 'null'    0    ${item_soluong}
    \    ${payload_each_product}        Format string       {{"ProductId":{0},"OnHand":-174,"Product":{{"Id":{0},"Name":"Sữa Rửa Mặt Tạo Bọt Ngăn Ngừa Mụn","Code":"TP129","IsLotSerialControl":false,"IsBatchExpireControl":false,"ProductShelvesStr":"","OnHand":-174,"Reserved":0}},"SendQuantity":{1},"ReceiveQuantity":{2},"Price":{3},"ProductName":"Sữa Rửa Mặt Tạo Bọt Ngăn Ngừa Mụn","ProductSerials":[],"ShowUnit":false,"ListProductUnit":[{{"Id":{0},"Unit":"","Code":"TP129","Conversion":0,"MasterUnitId":0}}],"Units":[{{"Id":{0},"Unit":"","Code":"TP129","Conversion":0,"MasterUnitId":0}}],"Unit":"","SelectedUnit":{0},"OnOrder":0,"ConversionValue":1,"SendPrice":180000,"ReceiverPrice":180000,"SerialNumbers":"{4}","rowNumber":0,"NextBranchQuantity":0,"rowShowSerials":0,"AdjustmentValue":0,"ReceiveQuantityNotNull":1,"IsMatchProductBatchExpire":true,"IsZeroProductBatchExpire":false,"OrderByNumber":0}}    ${item_id_sp}   ${item_soluong}    ${quantity}    ${item_giavon}    ${item_imei}
    \    ${liststring_prs_tranform_detail}       Catenate      SEPARATOR=,      ${liststring_prs_tranform_detail}      ${payload_each_product}
    ${liststring_prs_tranform_detail}       Replace String      ${liststring_prs_tranform_detail}       needdel,       ${EMPTY}      count=1
    ##post request
    ${request_payload}    Format String    {{"Transfer":{{"Id":0,"Code":"{0}","TransferDetails":[{1}],"FromBranchId":{2},"FromBranch":{{"id":{2},"name":"Chi nhánh trung tâm","Id":{2},"Name":"Chi nhánh trung tâm","Address":"Hòa An","LocationName":"Đà Nẵng - Quận Cẩm Lệ","WardName":"","ContactNumber":"","SubContactNumber":""}},"ToBranchId":{3},"ToBranch":{{"Id":{3},"Name":"Nhánh A","Type":0,"Address":"12 Cầu Giấy","Province":"Hà Nội ","District":"Quận Hà Đông","ContactNumber":"456789","IsActive":true,"RetailerId":{4},"CreatedBy":{5},"LimitAccess":false,"LocationName":"Hà Nội - Quận Hà Đông","WardName":"Phường Biên Giang","isAcceptBookClosing":false,"GmbStatus":1,"Orders":[],"Transfers1":[],"DamageItems":[],"SurchargeBranches":[],"AdrApplications":[],"Customers":[],"Suppliers":[],"ExpensesOtherBranches":[],"OrderSuppliers":[],"WarrantyBranchGroups":[],"BranchTakingAddresses":[],"Patients":[],"Clinics":[],"Doctors":[],"DoctorQualifications":[],"DoctorSpecialities":[],"Prescriptions":[],"PayslipPayments":[],"PayslipPaymentAllocations":[],"IdOld":0,"TotalUser":3,"CompareBranchName":"Nhánh A","StatusGmbValue":"Chưa đăng ký","TimeSheetBranchSettingWorkingDays":[0,1,2,3,4,5,6],"IsTimeSheetException":false}},"Status":2,"CompareStatus":1,"StatusValue":"Phiếu tạm","CreatedBy":{5},"User":{{"id":{5},"username":"le.dv","givenName":"Đặng Văn Lê","Id":{5},"UserName":"le.dv","GivenName":"Đặng Văn Lê","IsAdmin":false,"IsLimitedByTrans":false,"IsShowSumRow":true,"Theme":""}},"Description":"","ReceivedDescription":"","TotalSendQuantity":1,"TotalReceiveQuantity":1,"Price":0,"TransferType":0}},"TransferLargeData":null,"CopyFrom":""}}    ${ma_phieuchuyen}   ${liststring_prs_tranform_detail}    ${get_branch_id_chuyen}    ${get_branch_id_nhan}     ${get_id_nguoitao}    ${get_id_nguoiban}
    Log    ${request_payload}
    Post request thr API    /transfers    ${request_payload}
    Return From Keyword    ${ma_phieuchuyen}    ${list_result_transferring_onhand}    ${list_result_received_onhand}

Add new transform frm lodate API
    [Arguments]    ${input_branch_chuyen}    ${input_branch_nhan}  ${dict_product_nums}   ${list_nums_trans}
    ${list_product}    Get Dictionary Keys    ${dict_product_nums}
    ${list_nums}    Get Dictionary Values    ${dict_product_nums}
    ${ma_phieuchuyen}    Generate code automatically    PCH
    ${list_tenlo_all}    Import lot name for products by generating randomly    ${list_product}    ${list_nums}
    ${list_result_source_onhand_af_trans}    Create List
    ${list_result_target_onhand_af_trans}    Create List
    ${list_result_source_onhand_lot_af_trans}    Create List
    ${list_result_target_onhand_lot_af_trans}    Create List
    :FOR      ${input_product}    ${input_tenlo}    ${input_num}    IN ZIP    ${list_product}    ${list_tenlo_all}    ${list_nums_trans}
    \    ${source_onhand_bf_trans}    ${source_baseprice_bf_trans}    Get Cost and OnHand frm API    ${input_product}
    \    ${target_onhand_bf_trans}    ${target_baseprice_bf_trans}    Get Cost and Onhand frm API by Branch    ${input_product}    ${input_branch_nhan}
    \    ${source_onhand_lo_bf_trans}    Get Onhand Lot in tab Lo - HSD frm API    ${input_product}    ${input_tenlo}
    \    ${target_onhand_lo_bf_trans}    Get lot onhand frm API by Branch Name    ${input_branch_nhan}    ${input_product}    ${input_tenlo}
    \    ${source_onhand_af_ex}    Minus    ${source_onhand_bf_trans}    ${input_num}
    \    ${target_onhand_af_trans}    Sum    ${target_onhand_bf_trans}    ${input_num}
    \    ${source_lot_onhand_af_ex}    Minus    ${source_onhand_lo_bf_trans}    ${input_num}
    \    ${target_onhand_lot_af_trans}    Sum    ${target_onhand_lo_bf_trans}    ${input_num}
    \    Append To List    ${list_result_source_onhand_af_trans}    ${source_onhand_af_ex}
    \    Append To List    ${list_result_target_onhand_af_trans}    ${target_onhand_af_trans}
    \    Append To List    ${list_result_source_onhand_lot_af_trans}    ${source_lot_onhand_af_ex}
    \    Append To List    ${list_result_target_onhand_lot_af_trans}    ${target_onhand_lot_af_trans}
    ##create trans
    ${get_retailer_id}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${get_list_product_id}    Get list product id thr API    ${list_product}
    ${get_list_cost}    Get list cost frm API by product code    ${list_product}
    ${get_branch_id_nhan}   Get BranchID by BranchName    ${input_branch_nhan}
    ${get_list_batch_expire}    Get list batch expire id frm api    ${list_product}    ${list_tenlo_all}
    ${liststring_prs_tranform_detail}     Set Variable      needdel
    Log        ${liststring_prs_tranform_detail}
    : FOR   ${item_id_sp}   ${item_soluong}    ${item_giavon}    ${item_batch_id}    IN ZIP        ${get_list_product_id}    ${list_nums_trans}      ${get_list_cost}    ${get_list_batch_expire}
    \    ${payload_each_product}        Format string       {{"ProductId":{0},"OnHand":120,"Product":{{"Id":{0},"Name":"Gói 3 Thanh Bánh Chocolate KitKat Chunky 38g","Code":"LD01","IsLotSerialControl":false,"IsBatchExpireControl":true,"ProductShelvesStr":"","OnHand":1161.4,"Reserved":0}},"SendQuantity":{1},"ReceiveQuantity":{1},"Price":{2},"ProductName":"Gói 3 Thanh Bánh Chocolate KitKat Chunky 38g","ProductSerials":[],"subIndex":-1,"ProductBatchExpires":[],"ProductBatchExpire":[],"ProductBatchExpire":[{{"Id":{3},"FullNameVirgule":"ABC - 09/06/2019","BatchName":"ABC","ExpireDate":"","ProductId":{0},"IsBatchExpireControl":true,"OnHand":118,"Status":1,"BranchId":{4},"IsExpire":true,"IsAboutToExpire":false}}],"ProductBatchExpireId":{3},"ShowUnit":false,"ListProductUnit":[{{"Id":{0},"Unit":"","Code":"LD01","Conversion":0,"MasterUnitId":0}}],"Units":[{{"Id":{0},"Unit":"","Code":"LD01","Conversion":0,"MasterUnitId":0}}],"Unit":"","SelectedUnit":{0},"OnOrder":0,"ConversionValue":1,"SendPrice":49211.5,"ReceiverPrice":49211.5,"rowNumber":1,"NextBranchQuantity":0,"rowShowSerials":1,"isBatchExpireProduct":true,"AdjustmentValue":0,"ReceiveQuantityNotNull":1,"IsMatchProductBatchExpire":false,"IsZeroProductBatchExpire":false,"OrderByNumber":1}}    ${item_id_sp}   ${item_soluong}    ${item_giavon}    ${item_batch_id}    ${BRANCH_ID}
    \    ${liststring_prs_tranform_detail}       Catenate      SEPARATOR=,      ${liststring_prs_tranform_detail}      ${payload_each_product}
    ${liststring_prs_tranform_detail}       Replace String      ${liststring_prs_tranform_detail}       needdel,       ${EMPTY}      count=1
    ##post request
    ${request_payload}    Format String    {{"Transfer":{{"Id":0,"Code":"{0}","TransferDetails":[{1}],"FromBranchId":{2},"FromBranch":{{"id":{2},"name":"Chi nhánh trung tâm","Id":{2},"Name":"Chi nhánh trung tâm","Address":"hà nội","LocationName":"Hà Nội - Quận Ba Đình","WardName":"","ContactNumber":"","SubContactNumber":""}},"ToBranchId":{3},"ToBranch":{{"Id":{3},"Name":"Nhánh A","Type":0,"Address":"Hà nội","Province":"Hà Nội","District":"Quận Ba Đình","ContactNumber":"0983256789","IsActive":true,"RetailerId":{4},"CreatedBy":{5},"LimitAccess":false,"LocationName":"Hà Nội - Quận Ba Đình","WardName":"Phường Cống Vị","isAcceptBookClosing":false,"GmbStatus":1,"Orders":[],"Transfers1":[],"DamageItems":[],"SurchargeBranches":[],"AdrApplications":[],"Customers":[],"Suppliers":[],"ExpensesOtherBranches":[],"OrderSuppliers":[],"WarrantyBranchGroups":[],"BranchTakingAddresses":[],"Patients":[],"Clinics":[],"Doctors":[],"DoctorQualifications":[],"DoctorSpecialities":[],"Prescriptions":[],"PayslipPayments":[],"PayslipPaymentAllocations":[],"IdOld":0,"TotalUser":1,"CompareBranchName":"Nhánh A","StatusGmbValue":"Chưa đăng ký","IsTimeSheetException":false}},"Status":2,"CompareStatus":1,"StatusValue":"Phiếu tạm","CreatedBy":{5},"User":{{"id":{5},"username":"admin","givenName":"admin","Id":{5},"UserName":"admin","GivenName":"admin","IsAdmin":true,"IsLimitedByTrans":false,"IsShowSumRow":true,"Theme":""}},"Description":"","ReceivedDescription":"","TotalSendQuantity":2,"TotalReceiveQuantity":2,"Price":0,"TransferType":0}},"TransferLargeData":null,"CopyFrom":""}}    ${ma_phieuchuyen}   ${liststring_prs_tranform_detail}    ${BRANCH_ID}    ${get_branch_id_nhan}     ${get_retailer_id}    ${get_id_nguoiban}
    Log    ${request_payload}
    Post request to create transform    ${request_payload}
    Return From Keyword    ${ma_phieuchuyen}    ${list_tenlo_all}    ${list_result_source_onhand_af_trans}    ${list_result_target_onhand_af_trans}    ${list_result_source_onhand_lot_af_trans}    ${list_result_target_onhand_lot_af_trans}

Get transform id frm api
    [Arguments]    ${input_transformcode}
    [Timeout]    3 minutes
    ${endpoint_chuyenhang}    Format String     ${endpoint_pch_active_list}     ${BRANCH_ID}
    ${jsonpath_transformid}    Format String    $..Data[?(@.Code=="{0}")].Id    ${input_transformcode}
    ${get_transform_id}    Get data from API    ${endpoint_chuyenhang}    ${jsonpath_transformid}
    Return From Keyword    ${get_transform_id}

Get total, onhand af transfer finish
    [Arguments]    ${list_pr}    ${list_pr_cb}    ${list_num}   ${input_branch_name}
    ${list_result_total}    Create List
    ${list_result_onhand_source}    Create List
    ${list_result_onhand_target}    Create List
    ${source_list_onhand_bf_trans}    Create List
    ${target_list_onhand_bf_rev}    Create List
    ${list_result_num_cb}   Create List
    ${list_dvqd_unit}   Get list dvqd by list products    ${list_pr}
    ${source_list_cost_cb_bf_trans}    ${source_list_onhand_cb_bf_trans}    Get list cost - onhand frm API    ${list_pr_cb}
    ${target_onhand_cb_bf_rev}    ${target_cost_cb_bf_rev}    Get list cost and onhand frm API by Branch    ${list_pr_cb}    ${input_branch_name}
    : FOR    ${item_pr}   ${item_onhand_cb_source}    ${item_cost_cb_source}    ${item_dvqd}    ${item_num}    ${item_onhand_cb_target}
    ...    IN ZIP    ${list_pr}   ${source_list_onhand_cb_bf_trans}    ${source_list_cost_cb_bf_trans}    ${list_dvqd_unit}    ${list_num}    ${target_onhand_cb_bf_rev}
    \    ${actual_pr_num_cb}    Multiplication and round any number     ${item_num}    ${item_dvqd}    3
    \    ${item_onhand_source}    Devision and round any number     ${item_onhand_cb_source}    ${item_dvqd}    3
    \    ${item_target_source}    Devision and round any number     ${item_onhand_cb_target}    ${item_dvqd}    3
    \    ${result_onhand_source_af}    Minus    ${item_onhand_cb_source}    ${actual_pr_num_cb}
    \    ${result_onhand_target_af}    Sum    ${item_onhand_cb_target}    ${actual_pr_num_cb}
    \    ${total}    Multiplication and round    ${actual_pr_num_cb}    ${item_cost_cb_source}
    \    Append To List    ${list_result_total}    ${total}
    \    Append To List    ${list_result_onhand_source}    ${result_onhand_source_af}
    \    Append To List    ${list_result_onhand_target}    ${result_onhand_target_af}
    \    Append To List    ${source_list_onhand_bf_trans}    ${item_onhand_source}
    \    Append To List    ${target_list_onhand_bf_rev}    ${item_target_source}
    \    Append To List    ${list_result_num_cb}    ${actual_pr_num_cb}
    ${result_tong_gt_chuyen}    Sum values in list    ${list_result_total}
    Return From Keyword    ${result_tong_gt_chuyen}     ${list_result_onhand_source}    ${list_result_onhand_target}      ${list_result_num_cb}   ${source_list_onhand_bf_trans}   ${target_list_onhand_bf_rev}

Get transfer infor
    [Timeout]     3 minute
    [Arguments]    ${ma_phieu}
    ${get_resp}    Get Request and return body    ${endpoint_pch_list}
    ${jsonpath_tong_sl_chuyen}    Format String    $..Data[?(@.Code=="{0}")].TotalSendQuantity    ${ma_phieu}
    ${jsonpath_tong_gt_chuyen}    Format String    $..Data[?(@.Code=="{0}")].SendTotalPrice    ${ma_phieu}
    ${jsonpath_tong_sl_nhan}    Format String    $..Data[?(@.Code=="{0}")].TotalReceiveQuantity    ${ma_phieu}
    ${jsonpath_tong_gt_nhan}    Format String    $..Data[?(@.Code=="{0}")].ReceiveTotalPrice    ${ma_phieu}
    ${jsontpath_trangthai}    Format String    $..Data[?(@.Code=="{0}")].StatusValue    ${ma_phieu}
    ${get_tong_sl_chuyen}    Get data from response json    ${get_resp}    ${jsonpath_tong_sl_chuyen}
    ${get_tong_gt_chuyen}    Get data from response json    ${get_resp}    ${jsonpath_tong_gt_chuyen}
    ${get_tong_sl_nhan}    Get data from response json    ${get_resp}    ${jsonpath_tong_sl_nhan}
    ${get_tong_gt_nhan}    Get data from response json    ${get_resp}    ${jsonpath_tong_gt_nhan}
    ${get_trang_thai}    Get data from response json    ${get_resp}    ${jsontpath_trangthai}
    Return From Keyword    ${get_tong_sl_chuyen}    ${get_tong_gt_chuyen}   ${get_tong_sl_nhan}   ${get_tong_gt_nhan}   ${get_trang_thai}

Assert transfer infor
    [Arguments]     ${ma_phieu}     ${input_tong_sl_chuyen}     ${input_tong_gt_chuyen}     ${input_tong_sl_nhan}     ${input_tong_gt_nhan}   ${input_trangthai}
    ${get_tong_sl_chuyen}    ${get_tong_gt_chuyen}   ${get_tong_sl_nhan}   ${get_tong_gt_nhan}   ${get_trang_thai}   Get transfer infor    ${ma_phieu}
    Should Be Equal As Numbers    ${get_tong_sl_chuyen}    ${input_tong_sl_chuyen}
    Should Be Equal As Numbers    ${get_tong_gt_chuyen}    ${input_tong_gt_chuyen}
    Should Be Equal As Numbers    ${get_tong_sl_nhan}    ${input_tong_sl_nhan}
    Should Be Equal As Numbers    ${get_tong_gt_nhan}    ${input_tong_gt_nhan}
    Should Be Equal As Strings    ${get_trang_thai}    ${input_trangthai}

Add new basic transform frm API
    [Arguments]    ${input_branch_chuyen}    ${input_branch_nhan}  ${dict_product_nums}
    ${list_product}    Get Dictionary Keys    ${dict_product_nums}
    ${list_nums}    Get Dictionary Values    ${dict_product_nums}
    ${ma_phieuchuyen}    Generate code automatically    PCH
    Create list imei and other product    ${list_product}    ${list_nums}
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${get_list_product_id}    Get list product id thr API    ${list_product}
    ${get_list_cost}    Get list cost frm API by product code    ${list_product}
    ${get_branch_id_chuyen}   Get BranchID by BranchName    ${input_branch_chuyen}
    ${get_branch_id_nhan}   Get BranchID by BranchName    ${input_branch_nhan}
    ${liststring_prs_tranform_detail}     Set Variable      needdel
    Log        ${liststring_prs_tranform_detail}
    : FOR   ${item_id_sp}   ${item_soluong}    ${item_giavon}    ${item_imei}    IN ZIP        ${get_list_product_id}    ${list_nums}      ${get_list_cost}    ${imei_inlist}
    \    ${item_imei}    Convert list to string and return    ${item_imei}
    \    ${quantity}    Set Variable If    '${item_imei}' != 'null'    0    ${item_soluong}
    \    ${payload_each_product}        Format string       {{"ProductId":{0},"OnHand":31,"Product":{{"Id":{0},"Name":"Máy Xay Sinh Tố Philips HR2118","Code":"SI031","IsLotSerialControl":true,"IsBatchExpireControl":false,"ProductShelvesStr":"","OnHand":31,"Reserved":38}},"SendQuantity":{1},"ReceiveQuantity":{2},"Price":{3},"ProductName":"Máy Xay Sinh Tố Philips HR2118","ProductSerials":[],"ShowUnit":false,"ListProductUnit":[{{"Id":{0},"Unit":"","Code":"SI031","Conversion":0,"MasterUnitId":0}}],"Units":[{{"Id":{0},"Unit":"","Code":"SI031","Conversion":0,"MasterUnitId":0}}],"Unit":"","SelectedUnit":{0},"OnOrder":0,"SendPrice":0,"ReceiverPrice":0,"SerialNumbers":"{4}","rowNumber":0,"NextBranchQuantity":0,"rowShowSerials":0,"isSerialProduct":true,"AdjustmentValue":1,"ReceiveQuantityNotNull":0,"IsMatchProductBatchExpire":false,"IsZeroProductBatchExpire":true,"OrderByNumber":0}}    ${item_id_sp}   ${item_soluong}    ${quantity}    ${item_giavon}    ${item_imei}
    \    ${liststring_prs_tranform_detail}       Catenate      SEPARATOR=,      ${liststring_prs_tranform_detail}      ${payload_each_product}
    ${liststring_prs_tranform_detail}       Replace String      ${liststring_prs_tranform_detail}       needdel,       ${EMPTY}      count=1
    ##post request
    ${request_payload}    Format String    {{"Transfer":{{"Id":0,"Code":"{0}","TransferDetails":[{1}],"FromBranchId":{2},"FromBranch":{{"id":{2},"name":"Chi nhánh trung tâm","address":"1B Yết Kiêu","LocationId":0,"LocationName":"Hà Nội - Quận Hoàn Kiếm","WardId":0,"WardName":"","Id":{2},"Name":"Chi nhánh trung tâm","Address":"1B Yết Kiêu","CompanyName":"autoto","BearerToken":"","Privileges":{{}}}},"ToBranchId":{3},"ToBranch":{{"Id":{3},"Name":"Nhánh A","Type":0,"Address":"22A Hai Bà Trưng","Province":"Hà Nội","District":"Quận Hoàn Kiếm","ContactNumber":"0987654321","IsActive":true,"RetailerId":{4},"CreatedBy":{5},"LimitAccess":false,"LocationName":"Hà Nội - Quận Hoàn Kiếm","WardName":"","isAcceptBookClosing":false,"GmbStatus":1,"Orders":[],"Transfers1":[],"DamageItems":[],"SurchargeBranches":[],"AdrApplications":[],"Customers":[],"Suppliers":[],"ExpensesOtherBranches":[],"OrderSuppliers":[],"WarrantyBranchGroups":[],"BranchTakingAddresses":[],"Patients":[],"Clinics":[],"Doctors":[],"DoctorQualifications":[],"DoctorSpecialities":[],"Prescriptions":[],"PayslipPayments":[],"PayslipPaymentAllocations":[],"IdOld":0,"TotalUser":0,"CompareBranchName":"Nhánh A","StatusGmbValue":"Chưa đăng ký","IsTimeSheetException":false}},"Status":2,"CompareStatus":1,"StatusValue":"Phiếu tạm","CreatedBy":{5},"User":{{"id":{5},"username":"admin","givenName":"anh.lv","Id":{5},"UserName":"admin","GivenName":"anh.lv","IsAdmin":true,"IsLimitedByTrans":false,"IsShowSumRow":true,"Theme":""}},"Description":"","ReceivedDescription":"","TotalSendQuantity":2,"TotalReceiveQuantity":1,"Price":0,"TransferType":0}},"TransferLargeData":null,"CopyFrom":""}}    ${ma_phieuchuyen}   ${liststring_prs_tranform_detail}    ${get_branch_id_chuyen}    ${get_branch_id_nhan}     ${get_id_nguoitao}    ${get_id_nguoiban}
    Log    ${request_payload}
    Post request to create transform    ${request_payload}
    Return From Keyword    ${ma_phieuchuyen}

Get total, onhand af transfer a part
    [Arguments]    ${list_pr}    ${list_pr_cb}    ${list_num}   ${list_num_recieve}  ${input_branch_name}
    ${list_result_total_chuyen}    Create List
    ${list_result_total_nhan}    Create List
    ${list_result_onhand_source}    Create List
    ${list_result_onhand_target}    Create List
    ${list_dvqd_unit}   Get list dvqd by list products    ${list_pr}
    ${source_list_cost_cb_bf_trans}    ${source_list_onhand_cb_bf_trans}    Get list cost - onhand frm API    ${list_pr_cb}
    ${target_onhand_cb_bf_rev}    ${target_cost_cb_bf_rev}    Get list cost and onhand frm API by Branch    ${list_pr_cb}    ${input_branch_name}
    : FOR    ${item_pr}   ${item_onhand_cb_source}    ${item_cost_cb_source}    ${item_dvqd}    ${item_num}    ${item_onhand_cb_target}   ${item_num_recieve}
    ...    IN ZIP    ${list_pr}   ${source_list_onhand_cb_bf_trans}    ${source_list_cost_cb_bf_trans}    ${list_dvqd_unit}    ${list_num}    ${target_onhand_cb_bf_rev}    ${list_num_recieve}
    \    ${result_num_not_recieve}    Minus   ${item_num}   ${item_num_recieve}
    \    ${result_num_cb_trans}      Multiplication and round any number     ${item_num}    ${item_dvqd}    3
    \    ${result_num_cb_not_recieve}    Multiplication and round any number     ${result_num_not_recieve}    ${item_dvqd}    3
    \    ${result_num_cb_recieve}    Multiplication and round any number     ${item_num_recieve}    ${item_dvqd}    3
    \    ${result_onhand_source_af}    Sum    ${item_onhand_cb_source}    ${result_num_cb_not_recieve}
    \    ${result_onhand_target_af}    Sum    ${item_onhand_cb_target}    ${result_num_cb_recieve}
    \    ${total_chuyen}    Multiplication and round    ${result_num_cb_trans}    ${item_cost_cb_source}
    \    ${total_nhan}    Multiplication and round    ${result_num_cb_recieve}    ${item_cost_cb_source}
    \    Append To List    ${list_result_total_chuyen}    ${total_chuyen}
    \    Append To List    ${list_result_total_nhan}    ${total_nhan}
    \    Append To List    ${list_result_onhand_source}    ${result_onhand_source_af}
    \    Append To List    ${list_result_onhand_target}    ${result_onhand_target_af}
    ${result_tong_gt_chuyen}    Sum values in list    ${list_result_total_chuyen}
    ${result_tong_sl_chuyen}    Sum values in list    ${list_num}
    ${result_tong_gt_nhan}    Sum values in list    ${list_result_total_nhan}
    ${result_tong_sl_nhan}    Sum values in list    ${list_num_recieve}
    Return From Keyword   ${result_tong_sl_chuyen}     ${result_tong_gt_chuyen}    ${result_tong_sl_nhan}    ${result_tong_gt_nhan}    ${list_result_onhand_source}    ${list_result_onhand_target}

Get total, onhand af transfer not finish
    [Arguments]    ${list_pr}    ${list_pr_cb}    ${list_num}   ${input_branch_name}
    ${list_result_total}    Create List
    ${list_result_onhand_source}    Create List
    ${list_result_onhand_target}    Create List
    ${list_dvqd_unit}   Get list dvqd by list products    ${list_pr}
    ${source_list_cost_cb_bf_trans}    ${source_list_onhand_cb_bf_trans}    Get list cost - onhand frm API    ${list_pr_cb}
    ${target_onhand_cb_bf_rev}    ${target_cost_cb_bf_rev}    Get list cost and onhand frm API by Branch    ${list_pr_cb}    ${input_branch_name}
    : FOR    ${item_pr}     ${item_dvqd}    ${item_num}     ${item_cost_cb_source}     IN ZIP    ${list_pr}     ${list_dvqd_unit}    ${list_num}      ${source_list_cost_cb_bf_trans}
    \    ${actual_pr_num_cb}    Multiplication and round any number     ${item_num}    ${item_dvqd}    3
    \    ${total}    Multiplication and round    ${actual_pr_num_cb}    ${item_cost_cb_source}
    \    Append To List    ${list_result_total}    ${total}
    ${result_tong_sl_chuyen}    Sum values in list    ${list_num}
    ${result_tong_gt_chuyen}    Sum values in list    ${list_result_total}
    ${list_result_onhand_source}    Set Variable       ${source_list_onhand_cb_bf_trans}
    ${list_result_onhand_target}    Set Variable       ${target_onhand_cb_bf_rev}
    Return From Keyword     ${result_tong_sl_chuyen}     ${result_tong_gt_chuyen}     ${list_result_onhand_source}    ${list_result_onhand_target}

Get total, onhand af transfer cancel
    [Arguments]    ${list_pr}    ${list_pr_cb}    ${list_num}   ${input_branch_name}
    ${list_result_onhand_source}    Create List
    ${list_result_onhand_target}    Create List
    ${list_dvqd_unit}   Get list dvqd by list products    ${list_pr}
    ${source_list_cost_cb_bf_trans}    ${source_list_onhand_cb_bf_trans}    Get list cost - onhand frm API    ${list_pr_cb}
    ${target_onhand_cb_bf_rev}    ${target_cost_cb_bf_rev}    Get list cost and onhand frm API by Branch    ${list_pr_cb}    ${input_branch_name}
    : FOR    ${item_pr}   ${item_onhand_cb_source}    ${item_cost_cb_source}    ${item_dvqd}    ${item_num}    ${item_onhand_cb_target}
    ...    IN ZIP    ${list_pr}   ${source_list_onhand_cb_bf_trans}    ${source_list_cost_cb_bf_trans}    ${list_dvqd_unit}    ${list_num}    ${target_onhand_cb_bf_rev}
    \    ${actual_pr_num_cb}    Multiplication and round any number     ${item_num}    ${item_dvqd}    3
    \    ${item_onhand_cb_source_af}    Sum      ${item_onhand_cb_source}   ${actual_pr_num_cb}
    \    Append To List    ${list_result_onhand_source}    ${item_onhand_cb_source_af}
    ${list_result_onhand_target}    Set Variable       ${target_onhand_cb_bf_rev}
    Return From Keyword        ${list_result_onhand_source}    ${list_result_onhand_target}

Get list imei del to transfer
    [Arguments]   ${imei_inlist}    ${list_num_changes}    ${list_imei_status}
    ${list_del_imei}    Create List
    : FOR    ${item_imei_by_product_inlist}    ${item_index_to_remove_inlist}    ${item_status}   IN ZIP    ${imei_inlist}    ${list_num_changes}    ${list_imei_status}
    \    ${item_index_to_remove_inlist}    Convert String to List    ${item_index_to_remove_inlist}
    \    ${imei_del}    Run Keyword If    '${item_status}'=='True'    Get list item by index list    ${item_imei_by_product_inlist}    ${item_index_to_remove_inlist}    ${list_del_imei}   ELSE    Set Variable    ${item_imei_by_product_inlist}
    \    Append to list    ${list_del_imei}    ${imei_del}
    Return From Keyword      ${list_del_imei}
