Resource          api_access.robot
Library           StringFormat
Library           DateTime
Resource          api_nhanvien.robot
Resource          api_chamcong.robot
Resource          api_access.robot
Resource          ../share/computation.robot

*** Variables ***
${endpoint_cancel_paysheet}     /paysheets/cancel-paysheet
${endpoint_paysheet}      /paysheets?BranchIds={0}&OrderByDesc=CreatedDate&PaySheetKeyword=&PaysheetStatuses=%5B1,2%5D&skip=0
${endpoint_payslip}   /payslip/getPayslipsByPaysheetId?PaysheetId={0}&OrderBy=Id&OrderByDesc=id&payslipStatuses=1&payslipStatuses=2&skip=0&take=100

*** Keywords ***
Get paysheet id thr API
    [Arguments]     ${ma_bang_luong}     ${input_branch_id}
    ${endpoint_paysheet}      Format String    ${endpoint_paysheet}    ${input_branch_id}
    ${jsonpath_bangluong_id}    Format String    $..data[?(@.code=="{0}")].id    ${ma_bang_luong}
    ${resp}  Get Request and return body by other url    ${TIMESHEET_API}    ${endpoint_paysheet}
    ${get_id_bangluong}    Get data from response json    ${resp}    ${jsonpath_bangluong_id}
    Return From Keyword    ${get_id_bangluong}

Delete pay sheet thr API
    [Timeout]   2 mins
    [Arguments]    ${ma_bang_luong}     ${input_branch_id}
    ${get_id_bangluong}   Get paysheet id thr API    ${ma_bang_luong}     ${input_branch_id}
    ${payload}    Format String    {{"Id":{0},"isCheckPayslipPayment":true,"isCancelPayment":false}}   ${get_id_bangluong}
    Log    ${payload}
    ${headers}=    Create Dictionary    Authorization=${bearertoken}    Content-Type=application/json;charset=UTF-8    accept=application/json, text/plain, */*     branchid=${input_branch_id}     retailer=${RETAILER_NAME}
    Log     ${headers}
    Create Session    lolo    ${TIMESHEET_API}        cookies=${resp.cookies}    verify=True    debug=1
    ${resp1}=    Put Request    lolo    ${endpoint_cancel_paysheet}   data=${payload}    headers=${headers}
    log    ${resp1.status_code}
    Log    ${resp1.request.body}
    Log    ${resp1.json()}
    Should Be Equal As Strings    ${resp1.status_code}    200

Get total net salary by pay sheet code thr API
    [Timeout]   2 mins
    [Arguments]    ${ma_bang_luong}     ${input_branch_id}
    ${endpoint_paysheet}      Format String     ${endpoint_paysheet}        ${input_branch_id}
    ${jsonpath_total_net}    Format String     $..result..data[?(@.code=="{0}")].totalNetSalary   ${ma_bang_luong}
    ${resp}  Get Request and return body by other url    ${TIMESHEET_API}    ${endpoint_paysheet}
    ${get_total_net}    Get data from response json    ${resp}    ${jsonpath_total_net}
    Return From Keyword    ${get_total_net}

Get total payment and total need pay by pay sheet code
    [Timeout]   2 mins
    [Arguments]    ${ma_bang_luong}   ${ma_phieu_luong}     ${input_branch_id}
    ${get_id_bangluong}   Get paysheet id thr API     ${ma_bang_luong}     ${input_branch_id}
    ${endpoint_payslip}      Format String     ${endpoint_payslip}        ${get_id_bangluong}
    ${jsonpath_total_need_pay}    Format String     $..result..data[?(@.code=="{0}")].totalNeedPay   ${ma_phieu_luong}
    ${jsonpath_total_payment}    Format String     $..result..data[?(@.code=="{0}")].totalPayment   ${ma_phieu_luong}
    ${resp}  Get Request and return body by other url    ${TIMESHEET_API}    ${endpoint_payslip}
    ${get_total_payment}    Get data from response json    ${resp}    ${jsonpath_total_payment}
    ${get_total_need_pay}    Get data from response json    ${resp}    ${jsonpath_total_need_pay}
    ${get_total_payment}      Replace floating point    ${get_total_payment}
    ${get_total_need_pay}      Replace floating point    ${get_total_need_pay}
    Return From Keyword    ${get_total_payment}     ${get_total_need_pay}

Get pay sheet infor by pay sheet code
    [Timeout]   2 mins
    [Arguments]    ${ma_bang_luong}   ${ma_phieu_luong}     ${input_branch_id}
    ${get_id_bangluong}   Get paysheet id thr API     ${ma_bang_luong}     ${input_branch_id}
    ${endpoint_payslip}      Format String     ${endpoint_payslip}        ${get_id_bangluong}
    ${jsonpath_payslipStatus}    Format String     $..result..data[?(@.code=="{0}")].payslipStatus   ${ma_phieu_luong}
    ${jsonpath_mainSalary}    Format String     $..result..data[?(@.code=="{0}")].mainSalary   ${ma_phieu_luong}
    ${jsonpath_hoahong}    Format String     $..result..data[?(@.code=="{0}")].commissionSalary   ${ma_phieu_luong}
    ${jsonpath_lamthem}    Format String     $..result..data[?(@.code=="{0}")].overtimeSalary   ${ma_phieu_luong}
    ${jsonpath_phucap}    Format String     $..result..data[?(@.code=="{0}")].allowance   ${ma_phieu_luong}
    ${jsonpath_giamtru}    Format String     $..result..data[?(@.code=="{0}")].deduction   ${ma_phieu_luong}
    ${jsonpath_datra}    Format String     $..result..data[?(@.code=="{0}")].totalPayment   ${ma_phieu_luong}
    ${jsonpath_cantra}    Format String     $..result..data[?(@.code=="{0}")].totalNeedPay   ${ma_phieu_luong}
    ${jsonpath_thuong}    Format String     $..result..data[?(@.code=="{0}")].bonus   ${ma_phieu_luong}
    ${resp}  Get Request and return body by other url    ${TIMESHEET_API}    ${endpoint_payslip}
    ${get_trangthai}    Get data from response json    ${resp}    ${jsonpath_payslipStatus}
    ${get_luongchinh}    Get data from response json    ${resp}    ${jsonpath_mainSalary}
    ${get_hoahong}    Get data from response json    ${resp}    ${jsonpath_hoahong}
    ${get_lamthem}    Get data from response json    ${resp}    ${jsonpath_lamthem}
    ${get_phucap}    Get data from response json    ${resp}    ${jsonpath_phucap}
    ${get_giamtru}    Get data from response json    ${resp}    ${jsonpath_giamtru}
    ${get_datra}    Get data from response json    ${resp}    ${jsonpath_datra}
    ${get_cantra}    Get data from response json    ${resp}    ${jsonpath_cantra}
    ${get_thuong}    Get data from response json    ${resp}    ${jsonpath_thuong}
    Return From Keyword    ${get_trangthai}   ${get_luongchinh}     ${get_hoahong}    ${get_lamthem}    ${get_phucap}   ${get_giamtru}    ${get_datra}    ${get_cantra}   ${get_thuong}
