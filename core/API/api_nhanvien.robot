*** Settings ***
Library           Collections
Library           RequestsLibrary
Library           SeleniumLibrary
Library           OperatingSystem
Library           String
Library           StringFormat
Library           JSONLibrary
Library           DateTime
Resource          ../share/computation.robot
Resource          api_access.robot
Resource          api_danhmuc_hanghoa.robot
Resource          api_thietlaphoahong.robot
Resource          ../share/comparasion.robot

*** Variables ***
${endpoint_nhanvien}        /employees?BranchIds=%5B{0}%5D&OrderByDesc=id&includeFingerPrint=true&skip=0
${endpoint_delete_nhanvien}     /employees/{0}
${endpoint_themmoi_nhanvien}      /employees
${endpoint_phieuluong_nv}     /payslips?OrderByDesc=id&employeeId={0}&skip=0&take=5
${endpoint_phu_cap}     /allowance/list-by-ids
${endpoint_giam_tru}     /deduction/list-by-ids
${endpoint_tab_noluong_nhanvien}     /employees/{0}/debt?format=json&GroupCode=true&%24inlinecount=allpages&%24top=5

*** Keywords ***
Get employee id thr API
    [Arguments]     ${input_nv}
    [Timeout]     2 mins
    ${jsonpath_nv_id}    Format String    $..data[?(@.code=="{0}")].id    ${input_nv}
    ${endpoint_nhanvien}      Format String       ${endpoint_themmoi_nhanvien}    ${BRANCH_ID}
    ${resp}  Get Request and return body by other url    ${TIMESHEET_API}    ${endpoint_nhanvien}
    ${get_id_nv}    Get data from response json    ${resp}    ${jsonpath_nv_id}
    Return From Keyword    ${get_id_nv}

Delete employee thr API
    [Arguments]         ${input_ma_nv}
    [Timeout]          5 mins
    ${get_id_nv}      Get employee id thr API    ${input_ma_nv}
    ${endpoint_delete_nhanvien}     Format String     ${endpoint_delete_nhanvien}     ${get_id_nv}
    ${headers}=    Create Dictionary    Authorization=${bearertoken}    accept=application/json, text/plain, */*      branchid=${BRANCH_ID}     retailer=${RETAILER_NAME}
    Create Session    lolo    ${TIMESHEET_API}    cookies=${resp.cookies}
    ${resp}=    RequestsLibrary.Delete Request    lolo    ${endpoint_delete_nhanvien}    headers=${headers}
    log    ${resp.status_code}
    Log    ${resp.json()}
    Should Be Equal As Strings    ${resp.status_code}    200

Delete employee if it exists thr API
    [Arguments]   ${input_ma_nv}
    ${get_nv_id}      Get employee id thr API    ${input_ma_nv}
    Run Keyword If    ${get_nv_id}==0    Log    Ignore        ELSE      Delete employee thr API    ${input_ma_nv}

Get employee infor thr API
    [Arguments]    ${input_ma_nv}
    [Timeout]    5 mins
    ${jsonpath_ten_nv}    Format String   $..data[?(@.code=="{0}")].name    ${input_ma_nv}
    ${jsonpath_ngaysinh}    Format String    $..data[?(@.code=="{0}")].dob     ${input_ma_nv}
    ${jsonpath_gioitinh}    Format String   $..data[?(@.code=="{0}")].gender    ${input_ma_nv}
    ${jsonpath_cmtnd}    Format String    $..data[?(@.code=="{0}")].identityNumber     ${input_ma_nv}
    ${jsonpath_phongban}    Format String   $..data[?(@.code=="{0}")].department.name    ${input_ma_nv}
    ${jsonpath_chucdanh}    Format String    $..data[?(@.code=="{0}")].jobTitle.name     ${input_ma_nv}
    ${jsonpath_chinhanh_id}    Format String    $..data[?(@.code=="{0}")].branchId     ${input_ma_nv}
    ${jsonpath_user_id}    Format String   $..data[?(@.code=="{0}")].userId    ${input_ma_nv}
    ${jsonpath_sdt}    Format String   $..data[?(@.code=="{0}")].mobilePhone    ${input_ma_nv}
    ${jsonpath_email}    Format String    $..data[?(@.code=="{0}")].email     ${input_ma_nv}
    ${jsonpath_facebook}    Format String   $..data[?(@.code=="{0}")].facebook    ${input_ma_nv}
    ${jsonpath_diachi}    Format String    $..data[?(@.code=="{0}")].address     ${input_ma_nv}
    ${jsonpath_khuvuc}    Format String   $..data[?(@.code=="{0}")].locationName    ${input_ma_nv}
    ${jsonpath_phuongxa}    Format String    $..data[?(@.code=="{0}")].wardName     ${input_ma_nv}
    ${endpoint_nhanvien}      Format String       ${endpoint_nhanvien}    ${BRANCH_ID}
    ${resp}    Get Request and return body by other url    ${TIMESHEET_API}     ${endpoint_nhanvien}
    ${get_ten_nv}    Get data from response json    ${resp}    ${jsonpath_ten_nv}
    ${get_ngaysinh}    Get data from response json    ${resp}    ${jsonpath_ngaysinh}
    ${get_gioitinh}     Get data from response json    ${resp}    ${jsonpath_gioitinh}
    ${get_cmtnd}    Get data from response json    ${resp}    ${jsonpath_cmtnd}
    ${get_phongban}    Get data from response json    ${resp}    ${jsonpath_phongban}
    ${get_chucdanh}    Get data from response json    ${resp}    ${jsonpath_chucdanh}
    ${get_user_id}    Get data from response json    ${resp}    ${jsonpath_user_id}
    ${get_chinhanh_id}    Get data from response json    ${resp}    ${jsonpath_chinhanh_id}
    ${get_sdt}    Get data from response json    ${resp}    ${jsonpath_sdt}
    ${get_email}    Get data from response json    ${resp}    ${jsonpath_email}
    ${get_facebook}    Get data from response json    ${resp}    ${jsonpath_facebook}
    ${get_diachi}    Get data from response json    ${resp}    ${jsonpath_diachi}
    ${get_khuvuc}    Get data from response json    ${resp}    ${jsonpath_khuvuc}
    ${get_phuongxa}    Get data from response json    ${resp}    ${jsonpath_phuongxa}
    ${get_result_ngaysinh}     Run Keyword If    '${get_ngaysinh}'=='0'   Set Variable    0    ELSE    Replace String    ${get_ngaysinh}    T00:00:00.0000000+07:00    ${EMPTY}
    ${get_result_ngaysinh}     Run Keyword If    '${get_ngaysinh}'=='0'   Set Variable    0    ELSE    Replace String    ${get_result_ngaysinh}    T00:00:00.0000000    ${EMPTY}
    ${get_result_ngaysinh}     Run Keyword If    '${get_ngaysinh}'=='0'  Set Variable    0    ELSE    Convert Date    ${get_result_ngaysinh}   date_format=%Y-%m-%d     result_format=%d%m%Y
    Return From Keyword       ${get_ten_nv}   ${get_result_ngaysinh}     ${get_gioitinh}     ${get_cmtnd}    ${get_phongban}   ${get_chucdanh}     ${get_user_id}    ${get_chinhanh_id}    ${get_sdt}    ${get_email}    ${get_facebook}   ${get_diachi}   ${get_khuvuc}   ${get_phuongxa}

Get employee info and validate
    [Arguments]     ${input_ma_nv}    ${input_ten_nv}     ${input_ngay_sinh}    ${input_gioitinh}   ${input_cmtnd}    ${input_phongban}     ${input_chucdanh}     ${input_ghichu}    ${input_nguoidung}      ${input_sdt}      ${input_email}    ${input_facebook}      ${input_diachi}      ${input_khuvuc}     ${input_phuongxa}
    ${get_ten_nv}   ${get_ngaysinh}   ${get_gioitinh}   ${get_cmtnd}    ${get_phongban}   ${get_chucdanh}     ${get_user_id}    ${get_chinhanh_id}    ${get_sdt}    ${get_email}    ${get_facebook}   ${get_diachi}   ${get_khuvuc}   ${get_phuongxa}     Get employee infor thr API    ${input_ma_nv}
    ${input_user_id}      Get User ID by UserName    ${input_nguoidung}
    Should Be Equal As Strings    ${input_ten_nv}    ${get_ten_nv}
    Run Keyword If    '${input_ngay_sinh}'=='none'    Should Be Equal As Numbers    ${get_ngaysinh}    0    ELSE      Should Be Equal As Strings    ${get_ngaysinh}    ${input_ngay_sinh}
    Run Keyword If    '${input_gioitinh}'=='Nam'    Should Be Equal As Strings      ${get_gioitinh}    True      ELSE     Should Be Equal As Numbers     ${get_gioitinh}   0
    Run Keyword If    '${input_cmtnd}'=='none'    Should Be Equal As Numbers    ${get_cmtnd}    0    ELSE      Should Be Equal As Strings    ${get_cmtnd}    ${input_cmtnd}
    Run Keyword If    '${input_phongban}'=='none'    Should Be Equal As Numbers    ${get_phongban}    0    ELSE      Should Be Equal As Strings    ${get_phongban}    ${input_phongban}
    Run Keyword If    '${input_chucdanh}'=='none'    Should Be Equal As Numbers    ${get_chucdanh}    0    ELSE      Should Be Equal As Strings    ${get_chucdanh}    ${input_chucdanh}
    Run Keyword If    '${input_nguoidung}'=='none'    Should Be Equal As Numbers    ${get_user_id}    0    ELSE      Should Be Equal As Strings    ${get_user_id}     ${input_user_id}
    Should Be Equal As Numbers    ${get_chinhanh_id}    ${BRANCH_ID}
    Run Keyword If    '${input_sdt}'=='none'    Should Be Equal As Numbers    ${get_sdt}    0    ELSE      Should Be Equal As Strings    ${get_sdt}    ${input_sdt}
    Run Keyword If    '${input_email}'=='none'    Should Be Equal As Numbers    ${get_email}    0    ELSE      Should Be Equal As Strings     ${get_email}     ${input_email}
    Run Keyword If    '${input_facebook}'=='none'    Should Be Equal As Numbers    ${get_facebook}    0    ELSE      Should Be Equal As Strings    ${get_facebook}    ${input_facebook}
    Run Keyword If    '${input_diachi}'=='none'    Should Be Equal As Numbers    ${get_diachi}    0    ELSE      Should Be Equal As Strings    ${get_diachi}    ${input_diachi}
    Run Keyword If    '${input_khuvuc}'=='none'    Should Be Equal As Numbers    ${get_khuvuc}    0    ELSE      Should Be Equal As Strings    ${get_khuvuc}    ${input_khuvuc}
    Run Keyword If    '${input_phuongxa}'=='none'    Should Be Equal As Numbers    ${get_phuongxa}    0    ELSE      Should Be Equal As Strings    ${get_phuongxa}    ${input_phuongxa}

Add employee thr API
    [Timeout]   2 mins
    [Arguments]    ${ma_nv}    ${ten_nv}      ${input_branch}
    ${get_branch_id}      Get BranchID by BranchName    ${input_branch}
    ${get_branch_id}      Convert To String    ${${get_branch_id}}
    ${data_employee}    Format String    {{"id":0,"code":"{0}","name":"{1}","dob":null,"gender":null,"identityNumber":null,"mobilePhone":null,"email":null,"facebook":null,"address":null,"LocationName":"","WardName":"","note":null,"branchId":{2},"profilePictures":[],"departmentId":null,"jobTitleId":null,"userId":null,"tenantId":2,"temploc":"","tempw":"","workBranchIds":[{2}],"isNotUpdateUserId":false}}    ${ma_nv}    ${ten_nv}    ${get_branch_id}
    ${data_payrate}   Set Variable    {"salaryPeriod":1,"payRateTemplateId":null,"mainSalaryRuleValue":null,"overtimeSalaryRuleValue":null,"commissionSalaryRuleValue":null,"allowanceRuleValue":null,"deductionRuleValue":{"deductionRuleValueDetails":[]}}
    log    ${data_employee}
    ${payload}    Create Dictionary    employee=${data_employee}   payRate=${data_payrate}
    Log    ${payload}
    ${headers}=    Create Dictionary    Authorization=${bearertoken}    Content-Type=application/x-www-form-urlencoded    accept=application/json, text/plain, */*     branchid=${get_branch_id}     retailer=${RETAILER_NAME}
    Log     ${headers}
    Create Session    lolo    ${TIMESHEET_API}        cookies=${resp.cookies}    verify=True    debug=1
    ${resp1}=    Wait Until Keyword Succeeds    3x    0s     Post Request    lolo    ${endpoint_themmoi_nhanvien}   data=${payload}    headers=${headers}
    log    ${resp1.status_code}
    Log    ${resp1.request.body}
    Log    ${resp1.json()}
    Should Be Equal As Strings    ${resp1.status_code}    200

Add employee and set salary by shift thr API
    [Timeout]   2 mins
    [Arguments]    ${ma_nv}    ${ten_nv}      ${input_branch}   ${input_mucluong_theoca}      ${input_luong_ngaynghi}     ${input_luong_ngayle}
    ${get_branch_id}      Get BranchID by BranchName    ${input_branch}
    ${moneytype_ngaynghi}   Set Variable If    ${input_luong_ngaynghi}>1000    1       2
    ${moneytype_ngayle}   Set Variable If    ${input_luong_ngayle}>1000    1       2
    ${data_employee}    Format String    {{"id":0,"code":"{0}","name":"{1}","dob":null,"gender":null,"identityNumber":null,"mobilePhone":null,"email":null,"facebook":null,"address":null,"LocationName":"","WardName":"","note":null,"branchId":{2},"profilePictures":[],"departmentId":null,"jobTitleId":null,"userId":null,"tenantId":2,"temploc":"","tempw":"","workBranchIds":[{2}],"isNotUpdateUserId":false}}    ${ma_nv}    ${ten_nv}    ${get_branch_id}
    ${data_payRate}    Format String  {{"salaryPeriod":5,"payRateTemplateId":null,"mainSalaryRuleValue":{{"mainSalaryValueDetails":[{{"shiftId":0,"default":{0},"rank":0,"mainSalaryHolidays":[{{"moneyTypes":2,"type":6,"value":100,"isApply":false,"sort":0}},{{"moneyTypes":2,"type":0,"value":100,"isApply":false,"sort":1}},{{"moneyTypes":{1},"type":8,"value":{2},"isApply":true,"sort":2}},{{"moneyTypes":{3},"type":9,"value":{4},"isApply":true,"sort":3}}]}}],"type":2}},"overtimeSalaryRuleValue":null,"commissionSalaryRuleValue":null,"allowanceRuleValue":null,"deductionRuleValue":{{"deductionRuleValueDetails":[]}}}}     ${input_mucluong_theoca}    ${moneytype_ngaynghi}     ${input_luong_ngaynghi}     ${moneytype_ngayle}     ${input_luong_ngayle}
    Log    ${data_employee}
    Log    ${data_payRate}
    ${payload}    Create Dictionary    employee=${data_employee}     payRate=${data_payRate}
    Log    ${payload}
    ${headers}=    Create Dictionary    Authorization=${bearertoken}    Content-Type=application/x-www-form-urlencoded    accept=application/json, text/plain, */*     branchid=${get_branch_id}     retailer=${RETAILER_NAME}
    Log     ${headers}
    Create Session    lolo    ${TIMESHEET_API}        cookies=${resp.cookies}    verify=True    debug=1
    ${resp1}=    Wait Until Keyword Succeeds    3x    0s     Post Request    lolo    ${endpoint_themmoi_nhanvien}   data=${payload}    headers=${headers}
    log    ${resp1.status_code}
    Log    ${resp1.request.body}
    Log    ${resp1.json()}
    Should Be Equal As Strings    ${resp1.status_code}    200

Get pay slip by employee thr API
    [Timeout]     2 mins
    [Arguments]     ${ma_nhan_vien}
    ${get_nv_id}      Get employee id thr API    ${ma_nhan_vien}
    ${endpoint_phieuluong_nv}      Format String       ${endpoint_phieuluong_nv}    ${get_nv_id}
    ${resp}  Get Request and return body by other url    ${TIMESHEET_API}    ${endpoint_phieuluong_nv}
    ${get_ma_phieu}    Get data from response json    ${resp}    $..result..data..code
    Return From Keyword    ${get_ma_phieu}

Get allowance id thr API
    [Arguments]     ${input_phu_cap}
    ${jsonpath_phucap_id}    Format String    $..data[?(@.name=="{0}")].id    ${input_phu_cap}
    ${resp}  Get Request and return body by other url    ${TIMESHEET_API}     ${endpoint_phu_cap}
    ${get_phucap_id}    Get data from response json    ${resp}    ${jsonpath_phucap_id}
    Return From Keyword    ${get_phucap_id}

Get deducation id thr API
    [Arguments]     ${input_phu_cap}
    ${jsonpath_giamtru_id}    Format String    $..data[?(@.name=="{0}")].id    ${input_phu_cap}
    ${resp}  Get Request and return body by other url    ${TIMESHEET_API}     ${endpoint_giam_tru}
    ${get_giamtru_id}    Get data from response json    ${resp}    ${jsonpath_giamtru_id}
    Return From Keyword    ${get_giamtru_id}

Add employee and set salary by shift and allowance thr API
    [Timeout]   2 mins
    [Arguments]    ${ma_nv}    ${ten_nv}      ${input_branch}   ${input_mucluong_theoca}      ${input_luong_ngaynghi}     ${input_luong_ngayle}     ${list_ten_phu_cap}     ${list_giatri_phucap}       ${list_apdung_phucap}
    ${get_branch_id}      Get BranchID by BranchName    ${input_branch}
    ${moneytype_ngaynghi}   Set Variable If    ${input_luong_ngaynghi}>1000    1       2
    ${moneytype_ngayle}   Set Variable If    ${input_luong_ngayle}>1000    1       2
    ${data_employee}    Format String    {{"id":0,"code":"{0}","name":"{1}","dob":null,"gender":null,"identityNumber":null,"mobilePhone":null,"email":null,"facebook":null,"address":null,"LocationName":"","WardName":"","note":null,"branchId":{2},"profilePictures":[],"departmentId":null,"jobTitleId":null,"userId":null,"tenantId":2,"temploc":"","tempw":"","workBranchIds":[{2}],"isNotUpdateUserId":false}}    ${ma_nv}    ${ten_nv}    ${get_branch_id}
    ${liststring_allowanceRuleValueDetails}    Set Variable    needdel
    : FOR    ${item_ten_phu_cap}    ${item_giatri_phucap}    ${item_apdung_phucap}      IN ZIP
    ...    ${list_ten_phu_cap}     ${list_giatri_phucap}       ${list_apdung_phucap}
    \    ${get_phucap_id}       Get allowance id thr API    ${item_ten_phu_cap}
    \    ${value}    Set Variable If    ${item_giatri_phucap}>1000    ${item_giatri_phucap}   null
    \    ${valueRatio}      Set Variable If    ${item_giatri_phucap}<1000    ${item_giatri_phucap}   null
    \    ${type}      Set Variable If    ${item_giatri_phucap}>1000 and '${item_apdung_phucap}'=='yes'      1    null
    \    ${payload_each_allowance}    Format string    {{"allowanceId":{0},"value":{1},"valueRatio":{2},"type":{3}}}    ${get_phucap_id}        ${value}    ${valueRatio}    ${type}
    \    ${liststring_allowanceRuleValueDetails}    Catenate    SEPARATOR=,    ${liststring_allowanceRuleValueDetails}    ${payload_each_allowance}
    ${liststring_allowanceRuleValueDetails}    Replace String    ${liststring_allowanceRuleValueDetails}    needdel,    ${EMPTY}    count=1
    ${data_payRate}    Format String  {{"salaryPeriod":5,"payRateTemplateId":null,"mainSalaryRuleValue":{{"mainSalaryValueDetails":[{{"shiftId":0,"default":{0},"rank":0,"mainSalaryHolidays":[{{"moneyTypes":2,"type":6,"value":100,"isApply":false,"sort":0}},{{"moneyTypes":2,"type":0,"value":100,"isApply":false,"sort":1}},{{"moneyTypes":{1},"type":8,"value":{2},"isApply":true,"sort":2}},{{"moneyTypes":{3},"type":9,"value":{4},"isApply":true,"sort":3}}]}}],"type":2}},"overtimeSalaryRuleValue":null,"commissionSalaryRuleValue":null,"allowanceRuleValue":{{"allowanceRuleValueDetails":[{5}]}},"deductionRuleValue":{{"deductionRuleValueDetails":[]}}}}     ${input_mucluong_theoca}    ${moneytype_ngaynghi}     ${input_luong_ngaynghi}     ${moneytype_ngayle}     ${input_luong_ngayle}      ${liststring_allowanceRuleValueDetails}
    Log    ${data_employee}
    Log    ${data_payRate}
    ${payload}    Create Dictionary    employee=${data_employee}     payRate=${data_payRate}
    Log    ${payload}
    ${headers}=    Create Dictionary    Authorization=${bearertoken}    Content-Type=application/x-www-form-urlencoded    accept=application/json, text/plain, */*     branchid=${get_branch_id}     retailer=${RETAILER_NAME}
    Log     ${headers}
    Create Session    lolo    ${TIMESHEET_API}        cookies=${resp.cookies}    verify=True    debug=1
    ${resp1}=    Wait Until Keyword Succeeds    3x    0s     Post Request    lolo    ${endpoint_themmoi_nhanvien}   data=${payload}    headers=${headers}
    log    ${resp1.status_code}
    Log    ${resp1.request.body}
    Log    ${resp1.json()}
    Should Be Equal As Strings    ${resp1.status_code}    200

Add employee and set salary by shift and deduction thr API
    [Timeout]   2 mins
    [Arguments]    ${ma_nv}    ${ten_nv}      ${input_branch}   ${input_mucluong_theoca}      ${input_luong_ngaynghi}     ${input_luong_ngayle}     ${list_ten_giam_tru}     ${list_giatri_giamtru}       ${list_apdung_giamtru}
    ${get_branch_id}      Get BranchID by BranchName    ${input_branch}
    ${moneytype_ngaynghi}   Set Variable If    ${input_luong_ngaynghi}>1000    1       2
    ${moneytype_ngayle}   Set Variable If    ${input_luong_ngayle}>1000    1       2
    ${data_employee}    Format String    {{"id":0,"code":"{0}","name":"{1}","dob":null,"gender":null,"identityNumber":null,"mobilePhone":null,"email":null,"facebook":null,"address":null,"LocationName":"","WardName":"","note":null,"branchId":{2},"profilePictures":[],"departmentId":null,"jobTitleId":null,"userId":null,"tenantId":2,"temploc":"","tempw":"","workBranchIds":[{2}],"isNotUpdateUserId":false}}    ${ma_nv}    ${ten_nv}    ${get_branch_id}
    ${liststring_deductionRuleValueDetails}    Set Variable    needdel
    : FOR    ${item_ten_giam_tru}    ${item_giatri_giamtru}    ${item_apdung_giamtru}      IN ZIP
    ...   ${list_ten_giam_tru}     ${list_giatri_giamtru}       ${list_apdung_giamtru}
    \    ${get_giamtru_id}       Get deducation id thr API      ${item_ten_giam_tru}
    \    ${value}    Set Variable If    ${item_giatri_giamtru}>1000    ${item_giatri_giamtru}   null
    \    ${valueRatio}      Set Variable If    ${item_giatri_giamtru}<1000    ${item_giatri_giamtru}   null
    \    ${type}      Set Variable If    ${item_giatri_giamtru}>1000 and '${item_apdung_giamtru}'=='yes'      1    null
    \    ${payload_each_deduction}    Format string   {{"deductionId":{0},"value":{1},"valueRatio":{2},"type":{3}}}    ${get_giamtru_id}        ${value}    ${valueRatio}    ${type}
    \    ${liststring_deductionRuleValueDetails}    Catenate    SEPARATOR=,    ${liststring_deductionRuleValueDetails}    ${payload_each_deduction}
    ${liststring_deductionRuleValueDetails}    Replace String    ${liststring_deductionRuleValueDetails}    needdel,    ${EMPTY}    count=1
    ${data_payRate}    Format String  {{"salaryPeriod":5,"payRateTemplateId":null,"mainSalaryRuleValue":{{"mainSalaryValueDetails":[{{"shiftId":0,"default":{0},"rank":0,"mainSalaryHolidays":[{{"moneyTypes":2,"type":6,"value":100,"isApply":false,"sort":0}},{{"moneyTypes":2,"type":0,"value":100,"isApply":false,"sort":1}},{{"moneyTypes":{1},"type":8,"value":{2},"isApply":true,"sort":2}},{{"moneyTypes":{3},"type":9,"value":{4},"isApply":true,"sort":3}}]}}],"type":2}},"overtimeSalaryRuleValue":null,"commissionSalaryRuleValue":null,"allowanceRuleValue":null,"deductionRuleValue":{{"deductionRuleValueDetails":[{5}]}}}}     ${input_mucluong_theoca}    ${moneytype_ngaynghi}     ${input_luong_ngaynghi}     ${moneytype_ngayle}     ${input_luong_ngayle}      ${liststring_deductionRuleValueDetails}
    Log    ${data_employee}
    Log    ${data_payRate}
    ${payload}    Create Dictionary    employee=${data_employee}     payRate=${data_payRate}
    Log    ${payload}
    ${headers}=    Create Dictionary    Authorization=${bearertoken}    Content-Type=application/x-www-form-urlencoded    accept=application/json, text/plain, */*     branchid=${get_branch_id}     retailer=${RETAILER_NAME}
    Log     ${headers}
    Create Session    lolo    ${TIMESHEET_API}        cookies=${resp.cookies}    verify=True    debug=1
    ${resp1}=    Wait Until Keyword Succeeds    3x    0s     Post Request    lolo    ${endpoint_themmoi_nhanvien}   data=${payload}    headers=${headers}
    log    ${resp1.status_code}
    Log    ${resp1.request.body}
    Log    ${resp1.json()}
    Should Be Equal As Strings    ${resp1.status_code}    200

Add employee and set salary by shift and over time thr API
    [Timeout]   2 mins
    [Arguments]    ${ma_nv}    ${ten_nv}      ${input_branch}   ${input_mucluong_theoca}      ${input_luong_ngaynghi}     ${input_luong_ngayle}    ${input_ot_ngaythuong}     ${input_ot_ngaynghi}    ${input_ot_ngayle}
    ${get_branch_id}      Get BranchID by BranchName    ${input_branch}
    ${moneytype_ngaynghi}   Set Variable If    ${input_luong_ngaynghi}>1000    1       2
    ${moneytype_ngayle}   Set Variable If    ${input_luong_ngayle}>1000    1       2
    ${moneytype_ot_ngaythuong}   Set Variable If    ${input_ot_ngaythuong}>1000    1       2
    ${moneytype_ot_ngaynghi}   Set Variable If    ${input_ot_ngaynghi}>1000    1       2
    ${moneytype_ot_ngayle}   Set Variable If    ${input_ot_ngayle}>1000    1       2
    ${data_employee}    Format String    {{"id":0,"code":"{0}","name":"{1}","dob":null,"gender":null,"identityNumber":null,"mobilePhone":null,"email":null,"facebook":null,"address":null,"LocationName":"","WardName":"","note":null,"branchId":{2},"profilePictures":[],"departmentId":null,"jobTitleId":null,"userId":null,"tenantId":2,"temploc":"","tempw":"","workBranchIds":[{2}],"isNotUpdateUserId":false}}    ${ma_nv}    ${ten_nv}    ${get_branch_id}
    ${data_payRate}    Format String  {{"salaryPeriod":5,"payRateTemplateId":null,"mainSalaryRuleValue":{{"mainSalaryValueDetails":[{{"shiftId":0,"default":{0},"rank":0,"mainSalaryHolidays":[{{"moneyTypes":2,"type":6,"value":100,"isApply":false,"sort":0}},{{"moneyTypes":2,"type":0,"value":100,"isApply":false,"sort":1}},{{"moneyTypes":{1},"type":8,"value":{2},"isApply":true,"sort":2}},{{"moneyTypes":{3},"type":9,"value":{4},"isApply":true,"sort":3}}]}}],"type":2}},"overtimeSalaryRuleValue":{{"overtimeSalaryDays":[{{"value":{5},"moneyTypes":{6},"type":7,"isApply":true,"sort":0}},{{"value":200,"moneyTypes":2,"type":6,"isApply":false,"sort":1}},{{"value":200,"moneyTypes":2,"type":0,"isApply":false,"sort":2}},{{"value":{7},"moneyTypes":{8},"type":8,"isApply":true,"sort":3}},{{"value":{9},"moneyTypes":{10},"type":9,"isApply":true,"sort":4}}]}},"commissionSalaryRuleValue":null,"allowanceRuleValue":null,"deductionRuleValue":{{"deductionRuleValueDetails":[]}}}}    ${input_mucluong_theoca}    ${moneytype_ngaynghi}     ${input_luong_ngaynghi}     ${moneytype_ngayle}     ${input_luong_ngayle}      ${input_ot_ngaythuong}     ${moneytype_ot_ngaythuong}    ${input_ot_ngaynghi}     ${moneytype_ot_ngaynghi}      ${input_ot_ngayle}    ${moneytype_ot_ngayle}
    Log    ${data_employee}
    Log    ${data_payRate}
    ${payload}    Create Dictionary    employee=${data_employee}     payRate=${data_payRate}
    Log    ${payload}
    ${headers}=    Create Dictionary    Authorization=${bearertoken}    Content-Type=application/x-www-form-urlencoded    accept=application/json, text/plain, */*     branchid=${get_branch_id}     retailer=${RETAILER_NAME}
    Log     ${headers}
    Create Session    lolo    ${TIMESHEET_API}        cookies=${resp.cookies}    verify=True    debug=1
    ${resp1}=    Wait Until Keyword Succeeds    3x    0s     Post Request    lolo    ${endpoint_themmoi_nhanvien}   data=${payload}    headers=${headers}
    log    ${resp1.status_code}
    Log    ${resp1.request.body}
    Log    ${resp1.json()}
    Should Be Equal As Strings    ${resp1.status_code}    200

Add employee and set salary by shift and over time bay day thr API
    [Timeout]   2 mins
    [Arguments]    ${ma_nv}    ${ten_nv}      ${input_branch}   ${input_mucluong_theoca}      ${input_luong_ngaynghi}     ${input_luong_ngayle}    ${input_ot_ngaythuong}     ${input_ot_ngaynghi}    ${input_ot_ngayle}
    ${get_branch_id}      Get BranchID by BranchName    ${input_branch}
    ${moneytype_ngaynghi}   Set Variable If    ${input_luong_ngaynghi}>1000    1       2
    ${moneytype_ngayle}   Set Variable If    ${input_luong_ngayle}>1000    1       2
    ${moneytype_ot_ngaythuong}   Set Variable If    ${input_ot_ngaythuong}>1000    1       2
    ${moneytype_ot_ngaynghi}   Set Variable If    ${input_ot_ngaynghi}>1000    1       2
    ${moneytype_ot_ngayle}   Set Variable If    ${input_ot_ngayle}>1000    1       2
    ${data_employee}    Format String    {{"id":0,"code":"{0}","name":"{1}","dob":null,"gender":null,"identityNumber":null,"mobilePhone":null,"email":null,"facebook":null,"address":null,"LocationName":"","WardName":"","note":null,"branchId":{2},"profilePictures":[],"departmentId":null,"jobTitleId":null,"userId":null,"tenantId":2,"temploc":"","tempw":"","workBranchIds":[{2}],"isNotUpdateUserId":false}}    ${ma_nv}    ${ten_nv}    ${get_branch_id}
    ${data_payRate}    Format String  {{"salaryPeriod":5,"payRateTemplateId":null,"mainSalaryRuleValue":{{"mainSalaryValueDetails":[{{"shiftId":0,"default":{0},"rank":0,"mainSalaryHolidays":[{{"moneyTypes":2,"type":6,"value":100,"isApply":false,"sort":0}},{{"moneyTypes":2,"type":0,"value":100,"isApply":false,"sort":1}},{{"moneyTypes":{1},"type":8,"value":{2},"isApply":true,"sort":2}},{{"moneyTypes":{3},"type":9,"value":{4},"isApply":true,"sort":3}}]}}],"type":2}},"overtimeSalaryRuleValue":{{"overtimeSalaryDays":[{{"value":{5},"moneyTypes":{6},"type":7,"isApply":true,"sort":0}},{{"value":200,"moneyTypes":2,"type":6,"isApply":false,"sort":1}},{{"value":200,"moneyTypes":2,"type":0,"isApply":false,"sort":2}},{{"value":{7},"moneyTypes":{8},"type":8,"isApply":true,"sort":3}},{{"value":{9},"moneyTypes":{10},"type":9,"isApply":true,"sort":4}}]}},"commissionSalaryRuleValue":null,"allowanceRuleValue":null,"deductionRuleValue":{{"deductionRuleValueDetails":[]}}}}    ${input_mucluong_theoca}    ${moneytype_ngaynghi}     ${input_luong_ngaynghi}     ${moneytype_ngayle}     ${input_luong_ngayle}      ${input_ot_ngaythuong}     ${moneytype_ot_ngaythuong}    ${input_ot_ngaynghi}     ${moneytype_ot_ngaynghi}      ${input_ot_ngayle}    ${moneytype_ot_ngayle}
    Log    ${data_employee}
    Log    ${data_payRate}
    ${payload}    Create Dictionary    employee=${data_employee}     payRate=${data_payRate}
    Log    ${payload}
    ${headers}=    Create Dictionary    Authorization=${bearertoken}    Content-Type=application/x-www-form-urlencoded    accept=application/json, text/plain, */*     branchid=${get_branch_id}     retailer=${RETAILER_NAME}
    Log     ${headers}
    Create Session    lolo    ${TIMESHEET_API}        cookies=${resp.cookies}    verify=True    debug=1
    ${resp1}=    Wait Until Keyword Succeeds    3x    0s     Post Request    lolo    ${endpoint_themmoi_nhanvien}   data=${payload}    headers=${headers}
    log    ${resp1.status_code}
    Log    ${resp1.request.body}
    Log    ${resp1.json()}
    Should Be Equal As Strings    ${resp1.status_code}    200

Add employee and set salary by shift and commission thr API
    [Timeout]   2 mins
    [Arguments]    ${ma_nv}    ${ten_nv}    ${input_user}    ${input_branch}   ${input_mucluong_theoca}     ${input_doanhthu}    ${input_giatri}    ${input_type}
    ${get_branch_id}      Get BranchID by BranchName    ${input_branch}
    ${get_user_id}    Get User ID by UserName     ${input_user}
    ${get_value}     Set Variable If     '${input_type}'=='VND'     ${input_giatri}     null
    ${get_value_ratio}     Set Variable If     '${input_type}'=='% Doanh thu'     ${input_giatri}     null
    ${get_commission_id}      Run Keyword If    '${input_type}'=='VND' or '${input_type}'=='% Doanh thu'   Set Variable    null      ELSE      Get commission id    ${input_type}
    ${data_employee}    Format String   {{"id":0,"code":"{0}","name":"{1}","dob":null,"gender":null,"identityNumber":null,"mobilePhone":null,"email":null,"facebook":null,"address":null,"LocationName":"","WardName":"","note":null,"branchId":{2},"profilePictures":[],"departmentId":null,"jobTitleId":null,"userId":{3},"tenantId":2,"temploc":"","tempw":"","workBranchIds":[{2}],"isNotUpdateUserId":false}}     ${ma_nv}    ${ten_nv}    ${get_branch_id}      ${get_user_id}
    ${data_payRate}    Format String  {{"salaryPeriod":5,"payRateTemplateId":null,"mainSalaryRuleValue":{{"mainSalaryValueDetails":[{{"shiftId":0,"default":{0},"rank":0,"mainSalaryHolidays":[{{"moneyTypes":2,"type":6,"value":100,"isApply":false,"sort":0}},{{"moneyTypes":2,"type":0,"value":100,"isApply":false,"sort":1}},{{"moneyTypes":2,"type":8,"value":100,"isApply":true,"sort":2}},{{"moneyTypes":2,"type":9,"value":100,"isApply":true,"sort":3}}]}}],"type":2}},"overtimeSalaryRuleValue":null,"commissionSalaryRuleValue":{{"type":1,"commissionSalaryRuleValueDetails":[{{"commissionLevel":{1},"commissionTableId":{2},"value":{3},"valueRatio":{4}}}]}},"allowanceRuleValue":null,"deductionRuleValue":{{"deductionRuleValueDetails":[]}}}}    ${input_mucluong_theoca}    ${input_doanhthu}     ${get_commission_id}     ${get_value}     ${get_value_ratio}
    Log    ${data_employee}
    Log    ${data_payRate}
    ${payload}    Create Dictionary    employee=${data_employee}     payRate=${data_payRate}
    Log    ${payload}
    ${headers}=    Create Dictionary    Authorization=${bearertoken}    Content-Type=application/x-www-form-urlencoded    accept=application/json, text/plain, */*     branchid=${get_branch_id}     retailer=${RETAILER_NAME}
    Log     ${headers}
    Create Session    lolo    ${TIMESHEET_API}        cookies=${resp.cookies}    verify=True    debug=1
    ${resp1}=    Wait Until Keyword Succeeds    3x    0s     Post Request    lolo    ${endpoint_themmoi_nhanvien}   data=${payload}    headers=${headers}
    log    ${resp1.status_code}
    Log    ${resp1.request.body}
    Log    ${resp1.json()}
    Should Be Equal As Strings    ${resp1.status_code}    200

Add employee and set salary by the working hour thr API
    [Timeout]   2 mins
    [Arguments]    ${ma_nv}    ${ten_nv}      ${input_branch}   ${input_mucluong_theogio}      ${input_luong_ngaynghi}     ${input_luong_ngayle}     ${list_ten_phu_cap}     ${list_giatri_phucap}       ${list_apdung_phucap}   ${list_ten_giam_tru}     ${list_giatri_giamtru}       ${list_apdung_giamtru}
    ${get_branch_id}      Get BranchID by BranchName    ${input_branch}
    ${moneytype_ngaynghi}   Set Variable If    ${input_luong_ngaynghi}>1000    1       2
    ${moneytype_ngayle}   Set Variable If    ${input_luong_ngayle}>1000    1       2
    ${data_employee}    Format String    {{"id":0,"code":"{0}","name":"{1}","dob":null,"gender":null,"identityNumber":null,"mobilePhone":null,"email":null,"facebook":null,"address":null,"LocationName":"","WardName":"","note":null,"branchId":{2},"profilePictures":[],"departmentId":null,"jobTitleId":null,"userId":null,"tenantId":2,"temploc":"","tempw":"","workBranchIds":[{2}],"isNotUpdateUserId":false}}    ${ma_nv}    ${ten_nv}    ${get_branch_id}
    #
    ${liststring_allowanceRuleValueDetails}    Set Variable    needdel
    : FOR    ${item_ten_phu_cap}    ${item_giatri_phucap}    ${item_apdung_phucap}      IN ZIP
    ...    ${list_ten_phu_cap}     ${list_giatri_phucap}       ${list_apdung_phucap}
    \    ${get_phucap_id}       Get allowance id thr API    ${item_ten_phu_cap}
    \    ${value}    Set Variable If    ${item_giatri_phucap}>1000    ${item_giatri_phucap}   null
    \    ${valueRatio}      Set Variable If    ${item_giatri_phucap}<1000    ${item_giatri_phucap}   null
    \    ${type}      Set Variable If    ${item_giatri_phucap}>1000 and '${item_apdung_phucap}'=='yes'      1    null
    \    ${payload_each_allowance}    Format string    {{"allowanceId":{0},"value":{1},"valueRatio":{2},"type":{3}}}    ${get_phucap_id}        ${value}    ${valueRatio}    ${type}
    \    ${liststring_allowanceRuleValueDetails}    Catenate    SEPARATOR=,    ${liststring_allowanceRuleValueDetails}    ${payload_each_allowance}
    ${liststring_allowanceRuleValueDetails}    Replace String    ${liststring_allowanceRuleValueDetails}    needdel,    ${EMPTY}    count=1
    Log    ${liststring_allowanceRuleValueDetails}
    #
    ${liststring_deductionRuleValueDetails}    Set Variable    needdel
    : FOR    ${item_ten_giam_tru}    ${item_giatri_giamtru}    ${item_apdung_giamtru}      IN ZIP
    ...   ${list_ten_giam_tru}     ${list_giatri_giamtru}       ${list_apdung_giamtru}
    \    ${get_giamtru_id}       Get deducation id thr API      ${item_ten_giam_tru}
    \    ${value}    Set Variable If    ${item_giatri_giamtru}>1000    ${item_giatri_giamtru}   null
    \    ${valueRatio}      Set Variable If    ${item_giatri_giamtru}<1000    ${item_giatri_giamtru}   null
    \    ${type}      Set Variable If    ${item_giatri_giamtru}>1000 and '${item_apdung_giamtru}'=='yes'      1    null
    \    ${payload_each_deduction}    Format string   {{"deductionId":{0},"value":{1},"valueRatio":{2},"type":{3}}}    ${get_giamtru_id}        ${value}    ${valueRatio}    ${type}
    \    ${liststring_deductionRuleValueDetails}    Catenate    SEPARATOR=,    ${liststring_deductionRuleValueDetails}    ${payload_each_deduction}
    ${liststring_deductionRuleValueDetails}    Replace String    ${liststring_deductionRuleValueDetails}    needdel,    ${EMPTY}    count=1
    Log    ${liststring_deductionRuleValueDetails}
    #
    ${data_payRate}    Format String  {{"salaryPeriod":5,"payRateTemplateId":null,"mainSalaryRuleValue":{{"mainSalaryValueDetails":[{{"shiftId":0,"default":{0},"rank":0,"mainSalaryHolidays":[{{"moneyTypes":2,"type":6,"value":100,"isApply":false,"sort":0}},{{"moneyTypes":2,"type":0,"value":100,"isApply":false,"sort":1}},{{"moneyTypes":{1},"type":8,"value":{2},"isApply":true,"sort":2}},{{"moneyTypes":{3},"type":9,"value":{4},"isApply":true,"sort":3}}]}}],"type":1}},"overtimeSalaryRuleValue":null,"commissionSalaryRuleValue":null,"allowanceRuleValue":{{"allowanceRuleValueDetails":[{5}]}},"deductionRuleValue":{{"deductionRuleValueDetails":[{6}]}}}}     ${input_mucluong_theogio}    ${moneytype_ngaynghi}     ${input_luong_ngaynghi}     ${moneytype_ngayle}     ${input_luong_ngayle}     ${liststring_allowanceRuleValueDetails}   ${liststring_deductionRuleValueDetails}
    Log    ${data_employee}
    Log    ${data_payRate}
    ${payload}    Create Dictionary    employee=${data_employee}     payRate=${data_payRate}
    Log    ${payload}
    ${headers}=    Create Dictionary    Authorization=${bearertoken}    Content-Type=application/x-www-form-urlencoded    accept=application/json, text/plain, */*     branchid=${get_branch_id}     retailer=${RETAILER_NAME}
    Log     ${headers}
    Create Session    lolo    ${TIMESHEET_API}        cookies=${resp.cookies}    verify=True    debug=1
    ${resp1}=    Wait Until Keyword Succeeds    3x    0s     Post Request    lolo    ${endpoint_themmoi_nhanvien}   data=${payload}    headers=${headers}
    log    ${resp1.status_code}
    Log    ${resp1.request.body}
    Log    ${resp1.json()}
    Should Be Equal As Strings    ${resp1.status_code}    200

Add employee and set salary fixed by the working hour thr API
    [Timeout]   2 mins
    [Arguments]    ${ma_nv}    ${ten_nv}      ${input_branch}   ${input_mucluong_codinh}      ${list_ten_phu_cap}     ${list_giatri_phucap}       ${list_apdung_phucap}   ${list_ten_giam_tru}     ${list_giatri_giamtru}       ${list_apdung_giamtru}
    ${get_branch_id}      Get BranchID by BranchName    ${input_branch}
    ${data_employee}    Format String    {{"id":0,"code":"{0}","name":"{1}","dob":null,"gender":null,"identityNumber":null,"mobilePhone":null,"email":null,"facebook":null,"address":null,"LocationName":"","WardName":"","note":null,"branchId":{2},"profilePictures":[],"departmentId":null,"jobTitleId":null,"userId":null,"tenantId":2,"temploc":"","tempw":"","workBranchIds":[{2}],"isNotUpdateUserId":false}}    ${ma_nv}    ${ten_nv}    ${get_branch_id}
    #
    ${liststring_allowanceRuleValueDetails}    Set Variable    needdel
    : FOR    ${item_ten_phu_cap}    ${item_giatri_phucap}    ${item_apdung_phucap}      IN ZIP
    ...    ${list_ten_phu_cap}     ${list_giatri_phucap}       ${list_apdung_phucap}
    \    ${get_phucap_id}       Get allowance id thr API    ${item_ten_phu_cap}
    \    ${value}    Set Variable If    ${item_giatri_phucap}>1000    ${item_giatri_phucap}   null
    \    ${valueRatio}      Set Variable If    ${item_giatri_phucap}<1000    ${item_giatri_phucap}   null
    \    ${type}      Set Variable If    ${item_giatri_phucap}>1000 and '${item_apdung_phucap}'=='yes'      1    null
    \    ${payload_each_allowance}    Format string    {{"allowanceId":{0},"value":{1},"valueRatio":{2},"type":{3}}}    ${get_phucap_id}        ${value}    ${valueRatio}    ${type}
    \    ${liststring_allowanceRuleValueDetails}    Catenate    SEPARATOR=,    ${liststring_allowanceRuleValueDetails}    ${payload_each_allowance}
    ${liststring_allowanceRuleValueDetails}    Replace String    ${liststring_allowanceRuleValueDetails}    needdel,    ${EMPTY}    count=1
    Log    ${liststring_allowanceRuleValueDetails}
    #
    ${liststring_deductionRuleValueDetails}    Set Variable    needdel
    : FOR    ${item_ten_giam_tru}    ${item_giatri_giamtru}    ${item_apdung_giamtru}      IN ZIP
    ...   ${list_ten_giam_tru}     ${list_giatri_giamtru}       ${list_apdung_giamtru}
    \    ${get_giamtru_id}       Get deducation id thr API      ${item_ten_giam_tru}
    \    ${value}    Set Variable If    ${item_giatri_giamtru}>1000    ${item_giatri_giamtru}   null
    \    ${valueRatio}      Set Variable If    ${item_giatri_giamtru}<1000    ${item_giatri_giamtru}   null
    \    ${type}      Set Variable If    ${item_giatri_giamtru}>1000 and '${item_apdung_giamtru}'=='yes'      1    null
    \    ${payload_each_deduction}    Format string   {{"deductionId":{0},"value":{1},"valueRatio":{2},"type":{3}}}    ${get_giamtru_id}        ${value}    ${valueRatio}    ${type}
    \    ${liststring_deductionRuleValueDetails}    Catenate    SEPARATOR=,    ${liststring_deductionRuleValueDetails}    ${payload_each_deduction}
    ${liststring_deductionRuleValueDetails}    Replace String    ${liststring_deductionRuleValueDetails}    needdel,    ${EMPTY}    count=1
    Log    ${liststring_deductionRuleValueDetails}
    #
    ${data_payRate}    Format String  {{"salaryPeriod":5,"payRateTemplateId":null,"mainSalaryRuleValue":{{"mainSalaryValueDetails":[{{"shiftId":0,"default":{0},"rank":0,"mainSalaryHolidays":[]}}],"type":4}},"overtimeSalaryRuleValue":null,"commissionSalaryRuleValue":null,"allowanceRuleValue":{{"allowanceRuleValueDetails":[{1}]}},"deductionRuleValue":{{"deductionRuleValueDetails":[{2}]}}}}     ${input_mucluong_codinh}        ${liststring_allowanceRuleValueDetails}   ${liststring_deductionRuleValueDetails}
    Log    ${data_employee}
    Log    ${data_payRate}
    ${payload}    Create Dictionary    employee=${data_employee}     payRate=${data_payRate}
    Log    ${payload}
    ${headers}=    Create Dictionary    Authorization=${bearertoken}    Content-Type=application/x-www-form-urlencoded    accept=application/json, text/plain, */*     branchid=${get_branch_id}     retailer=${RETAILER_NAME}
    Log     ${headers}
    Create Session    lolo    ${TIMESHEET_API}        cookies=${resp.cookies}    verify=True    debug=1
    ${resp1}=    Wait Until Keyword Succeeds    3x    0s     Post Request    lolo    ${endpoint_themmoi_nhanvien}   data=${payload}    headers=${headers}
    log    ${resp1.status_code}
    Log    ${resp1.request.body}
    Log    ${resp1.json()}
    Should Be Equal As Strings    ${resp1.status_code}    200

Add employee and set salary by standard day thr API
    [Timeout]   2 mins
    [Arguments]    ${ma_nv}    ${ten_nv}      ${input_branch}   ${input_mucluong_ngaycong}      ${input_luong_ot_ngaythuong}   ${input_luong_ot_ngaynghi}     ${input_luong_ot_ngayle}      ${list_ten_phu_cap}     ${list_giatri_phucap}       ${list_apdung_phucap}   ${list_ten_giam_tru}     ${list_giatri_giamtru}       ${list_apdung_giamtru}
    ${get_branch_id}      Get BranchID by BranchName    ${input_branch}
    ${moneytype_ot_ngaythuong}   Set Variable If    ${input_luong_ot_ngaythuong}>1000    1       2
    ${moneytype_ot_ngaynghi}   Set Variable If    ${input_luong_ot_ngaynghi}>1000    1       2
    ${moneytype_ot_ngayle}   Set Variable If    ${input_luong_ot_ngayle}>1000    1       2
    ${data_employee}    Format String    {{"id":0,"code":"{0}","name":"{1}","dob":null,"gender":null,"identityNumber":null,"mobilePhone":null,"email":null,"facebook":null,"address":null,"LocationName":"","WardName":"","note":null,"branchId":{2},"profilePictures":[],"departmentId":null,"jobTitleId":null,"userId":null,"tenantId":2,"temploc":"","tempw":"","workBranchIds":[{2}],"isNotUpdateUserId":false}}    ${ma_nv}    ${ten_nv}    ${get_branch_id}
    #
    ${liststring_allowanceRuleValueDetails}    Set Variable    needdel
    : FOR    ${item_ten_phu_cap}    ${item_giatri_phucap}    ${item_apdung_phucap}      IN ZIP
    ...    ${list_ten_phu_cap}     ${list_giatri_phucap}       ${list_apdung_phucap}
    \    ${get_phucap_id}       Get allowance id thr API    ${item_ten_phu_cap}
    \    ${value}    Set Variable If    ${item_giatri_phucap}>1000    ${item_giatri_phucap}   null
    \    ${valueRatio}      Set Variable If    ${item_giatri_phucap}<1000    ${item_giatri_phucap}   null
    \    ${type}      Set Variable If    ${item_giatri_phucap}>1000 and '${item_apdung_phucap}'=='yes'      1    null
    \    ${payload_each_allowance}    Format string    {{"allowanceId":{0},"value":{1},"valueRatio":{2},"type":{3}}}    ${get_phucap_id}        ${value}    ${valueRatio}    ${type}
    \    ${liststring_allowanceRuleValueDetails}    Catenate    SEPARATOR=,    ${liststring_allowanceRuleValueDetails}    ${payload_each_allowance}
    ${liststring_allowanceRuleValueDetails}    Replace String    ${liststring_allowanceRuleValueDetails}    needdel,    ${EMPTY}    count=1
    Log    ${liststring_allowanceRuleValueDetails}
    #
    ${liststring_deductionRuleValueDetails}    Set Variable    needdel
    : FOR    ${item_ten_giam_tru}    ${item_giatri_giamtru}    ${item_apdung_giamtru}      IN ZIP
    ...   ${list_ten_giam_tru}     ${list_giatri_giamtru}       ${list_apdung_giamtru}
    \    ${get_giamtru_id}       Get deducation id thr API      ${item_ten_giam_tru}
    \    ${value}    Set Variable If    ${item_giatri_giamtru}>1000    ${item_giatri_giamtru}   null
    \    ${valueRatio}      Set Variable If    ${item_giatri_giamtru}<1000    ${item_giatri_giamtru}   null
    \    ${type}      Set Variable If    ${item_giatri_giamtru}>1000 and '${item_apdung_giamtru}'=='yes'      1    null
    \    ${payload_each_deduction}    Format string   {{"deductionId":{0},"value":{1},"valueRatio":{2},"type":{3}}}    ${get_giamtru_id}        ${value}    ${valueRatio}    ${type}
    \    ${liststring_deductionRuleValueDetails}    Catenate    SEPARATOR=,    ${liststring_deductionRuleValueDetails}    ${payload_each_deduction}
    ${liststring_deductionRuleValueDetails}    Replace String    ${liststring_deductionRuleValueDetails}    needdel,    ${EMPTY}    count=1
    Log    ${liststring_deductionRuleValueDetails}
    #
    ${data_payRate}    Format String  {{"salaryPeriod":5,"payRateTemplateId":null,"mainSalaryRuleValue":{{"mainSalaryValueDetails":[{{"shiftId":0,"default":{0},"rank":0,"mainSalaryHolidays":[]}}],"type":3}},"overtimeSalaryRuleValue":{{"overtimeSalaryDays":[{{"value":{1},"moneyTypes":{2},"type":7,"isApply":true,"sort":0}},{{"value":200,"moneyTypes":2,"type":6,"isApply":false,"sort":1}},{{"value":200,"moneyTypes":2,"type":0,"isApply":false,"sort":2}},{{"value":{3},"moneyTypes":{4},"type":8,"isApply":true,"sort":3}},{{"value":{5},"moneyTypes":{6},"type":9,"isApply":true,"sort":4}}]}},"commissionSalaryRuleValue":null,"allowanceRuleValue":{{"allowanceRuleValueDetails":[{7}]}},"deductionRuleValue":{{"deductionRuleValueDetails":[{8}]}}}}     ${input_mucluong_ngaycong}    ${input_luong_ot_ngaythuong}     ${moneytype_ot_ngaythuong}     ${input_luong_ot_ngaynghi}   ${moneytype_ot_ngaynghi}     ${input_luong_ot_ngayle}       ${moneytype_ot_ngayle}       ${liststring_allowanceRuleValueDetails}   ${liststring_deductionRuleValueDetails}
    Log    ${data_employee}
    Log    ${data_payRate}
    ${payload}    Create Dictionary    employee=${data_employee}     payRate=${data_payRate}
    Log    ${payload}
    ${headers}=    Create Dictionary    Authorization=${bearertoken}    Content-Type=application/x-www-form-urlencoded    accept=application/json, text/plain, */*     branchid=${get_branch_id}     retailer=${RETAILER_NAME}
    Log     ${headers}
    Create Session    lolo    ${TIMESHEET_API}        cookies=${resp.cookies}    verify=True    debug=1
    ${resp1}=    Wait Until Keyword Succeeds    3x    0s     Post Request    lolo    ${endpoint_themmoi_nhanvien}   data=${payload}    headers=${headers}
    log    ${resp1.status_code}
    Log    ${resp1.request.body}
    Log    ${resp1.json()}
    Should Be Equal As Strings    ${resp1.status_code}    200

Update employee and salary by shift thr API
    [Timeout]   2 mins
    [Arguments]    ${ma_nv}    ${ten_nv}      ${input_branch}   ${input_mucluong_theoca}      ${input_luong_ngaynghi}     ${input_luong_ngayle}     ${ky_han_traluong}
    ${get_branch_id}      Get BranchID by BranchName    ${input_branch}
    ${get_emplyee_id}     Get employee id thr API     ${ma_nv}
    ${moneytype_ngaynghi}   Set Variable If    ${input_luong_ngaynghi}>1000    1       2
    ${moneytype_ngayle}   Set Variable If    ${input_luong_ngayle}>1000    1       2
    ${salary_period}      Run Keyword If    '${ky_han_traluong}'=='Hàng tháng'    Set Variable    1     ELSE IF     '${ky_han_traluong}'=='2 lần 1 tháng'    Set Variable    2    ELSE IF     '${ky_han_traluong}'=='Hàng tuần'    Set Variable    3    ELSE IF     '${ky_han_traluong}'=='2 tuần 1 lần'    Set Variable    4    ELSE     Set Variable    5
    ${data_employee}    Format String    {{"id":{0},"code":"{1}","name":"{2}","identityNumber":"","mobilePhone":"","email":"","facebook":"","address":"","LocationName":"","WardName":"","note":"","branchId":{3},"profilePictures":[],"userId":null,"tenantId":437336,"temploc":"","tempw":"","isNotUpdateUserId":false}}    ${get_emplyee_id}   ${ma_nv}    ${ten_nv}    ${get_branch_id}
    ${data_payRate}    Format String  {{"salaryPeriod":{5},"payRateTemplateId":0,"mainSalaryRuleValue":{{"mainSalaryValueDetails":[{{"shiftId":0,"default":{0},"rank":0,"mainSalaryHolidays":[{{"moneyTypes":2,"type":6,"value":100,"isApply":false,"sort":0}},{{"moneyTypes":2,"type":0,"value":100,"isApply":false,"sort":1}},{{"moneyTypes":{1},"type":8,"value":{2},"isApply":true,"sort":2}},{{"moneyTypes":{3},"type":9,"value":{4},"isApply":true,"sort":3}}]}}],"type":2}},"overtimeSalaryRuleValue":null,"commissionSalaryRuleValue":null,"allowanceRuleValue":null,"deductionRuleValue":{{"deductionRuleValueDetails":[]}}}}     ${input_mucluong_theoca}    ${moneytype_ngaynghi}     ${input_luong_ngaynghi}     ${moneytype_ngayle}     ${input_luong_ngayle}      ${salary_period}
    Log    ${data_employee}
    Log    ${data_payRate}
    ${payload}    Create Dictionary    employee=${data_employee}     payRate=${data_payRate}
    Log    ${payload}
    ${headers}=    Create Dictionary    Authorization=${bearertoken}    Content-Type=application/x-www-form-urlencoded    accept=application/json, text/plain, */*     branchid=${get_branch_id}     retailer=${RETAILER_NAME}
    Log     ${headers}
    Create Session    lolo    ${TIMESHEET_API}        cookies=${resp.cookies}    verify=True    debug=1
    ${resp1}=    Put Request    lolo    /employees/${get_emplyee_id}   data=${payload}    headers=${headers}
    log    ${resp1.status_code}
    Log    ${resp1.request.body}
    Log    ${resp1.json()}
    Should Be Equal As Strings    ${resp1.status_code}    200

Validate status and value in Tab No luong nhan vien
    [Arguments]    ${input_bh_ma_kh}    ${input_ma_phieu}   ${input_trangthai_phieuluong}     ${input_giatri_phieuluong}      ${input_duno}
    [Timeout]    5 mins
    ${get_trangthai_phieuluong}      ${get_giatri_phieuluong}     ${get_duno}     Get document type and value in Tab No luong nhan vien    ${input_bh_ma_kh}    ${input_ma_phieu}
    Should Be Equal As Numbers    ${get_trangthai_phieuluong}    ${input_trangthai_phieuluong}      #14: phieu luong, 0: phieu thanh toan
    Should Be Equal As Numbers    ${get_giatri_phieuluong}    ${input_giatri_phieuluong}
    Should Be Equal As Numbers    ${get_duno}    ${input_duno}

Get document type and value in Tab No luong nhan vien
    [Arguments]    ${input_ma_nv}    ${input_ma_phieu}
    [Timeout]    5 mins
    ${get_nv_id}      Get employee id thr API    ${input_ma_nv}
    ${endpoint_tab_noluong}    Format String    ${endpoint_tab_noluong_nhanvien}    ${get_nv_id}
    ${get_resp}     Get Request and return body    ${endpoint_tab_noluong}
    ${jsonpath_trangthai_phieuluong}    Format String    $..Data[?(@.DocumentCode=="{0}")].DocumentType    ${input_ma_phieu}
    ${jsonpath_giatri_phieuluong}    Format String    $..Data[?(@.DocumentCode=="{0}")].Value    ${input_ma_phieu}
    ${jsonpath_duno}    Format String    $..Data[?(@.DocumentCode=="{0}")].Balance    ${input_ma_phieu}
    ${get_trangthai_phieuluong}     Get data from response json    ${get_resp}    ${jsonpath_trangthai_phieuluong}
    ${get_giatri_phieuluong}     Get data from response json    ${get_resp}    ${jsonpath_giatri_phieuluong}
    ${get_duno}      Get data from response json      ${get_resp}    ${jsonpath_duno}
    Return From Keyword    ${get_trangthai_phieuluong}      ${get_giatri_phieuluong}    ${get_duno}

Get Emplyee Debt from API
    [Arguments]    ${input_ma_nv}    ${input_ma_phieu}    ${input_tientra_nv}
    [Timeout]    5 mins
    ${get_nv_id}      Get employee id thr API    ${input_ma_nv}
    ${endpoint_tab_noluong}    Format String    ${endpoint_tab_noluong_nhanvien}    ${get_nv_id}
    ${jsonpath_duno}    Format String    $..Data[?(@.Code=="{0}")].Balance    ${input_ma_phieu}
    ${jsonpath_tongban_trutrahang}    Format String    $..Data[?(@.Code=="{0}")].TotalRevenue    ${input_ma_kh}
    ${actual_code_thanhtoan}    Set Variable If    '${input_khach_tt}' == '0'    ${input_ma_hd}    ${document_code_if_paid}
    ${jsonpath_no}    Format String    $..Data[?(@.DocumentCode == '{0}')].Balance    ${actual_code_thanhtoan}
    ${get_no}    Get data from response json    ${get_resp}    ${jsonpath_no}
    ${get_tongban}    Get data from response json    ${get_resp}    ${jsonpath_tongban}
    ${get_tongban_tru_trahang}    Get data from response json    ${get_resp}    ${jsonpath_tongban_trutrahang}
    Return From Keyword    ${get_no}    ${get_tongban}    ${get_tongban_tru_trahang}

Get all pay slip by employee thr API
    [Timeout]     2 mins
    [Arguments]     ${ma_nhan_vien}
    ${get_nv_id}      Get employee id thr API    ${ma_nhan_vien}
    ${endpoint_phieuluong_nv}      Format String       ${endpoint_phieuluong_nv}    ${get_nv_id}
    ${resp}  Get Request and return body by other url    ${TIMESHEET_API}    ${endpoint_phieuluong_nv}
    ${get_list_phieu}    Get raw data from response json    ${resp}    $..result..data..code
    Return From Keyword    ${get_list_phieu}

Create payslip payment for employee and return code thr API
    [Arguments]     ${input_ma_nv}     ${input_thanhtoan}   ${input_branch_id}
    ${get_nv_id}      Get employee id thr API    ${input_ma_nv}
    ${payload}    Format String  {{"PayslipPayments":[{{"AccountId":0,"BranchId":{0},"Amount":{1},"EmployeeId":{2},"EmployeeName":"abcd","EmployeeCode":"NV000010","Method":"Cash","TransDate":""}}],"Paysheets":[]}}      ${input_branch_id}      ${input_thanhtoan}      ${get_nv_id}
    Log    ${payload}
    ${headers}=    Create Dictionary    Authorization=${bearertoken}    Content-Type=application/json;charset=UTF-8    accept=application/json, text/plain, */*     branchid=${input_branch_id}     retailer=${RETAILER_NAME}
    Log     ${headers}
    Create Session    lolo    ${API_URL}        cookies=${resp.cookies}    verify=True    debug=1
    ${resp1}=    Wait Until Keyword Succeeds    3x    0s     Post Request    lolo   /payslip-payments   data=${payload}    headers=${headers}
    log    ${resp1.status_code}
    Log    ${resp1.request.body}
    Log    ${resp1.json()}
    Should Be Equal As Strings    ${resp1.status_code}    200
    ${get_ma_phieu}     Get data from response json    ${resp1.json()}   $..TargetCode
    Return From Keyword    ${get_ma_phieu}
