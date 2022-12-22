*** Settings ***
Resource          api_access.robot
Library           StringFormat
Library           DateTime
Resource          api_nhanvien.robot
Resource          ../share/computation.robot
Resource          ../share/datetime_in_mhbh.robot

*** Variables ***
${endpoint_ca_lam_viec}    /shifts/orderby-from-to?BranchId={0}&ShiftIds=
${endpoint_datlich_lamviec}     /timesheets/batchAddTimeSheetWhenCreateMultipleTimeSheet
${endpoint_chitiet_calam}     /clockings/get-clocking-for-calendar?BranchId={0}&ClockingStatusIn=1,2,3,4&EndTime=%22{1}%22&StartTime=%22{2}%22
${endpoint_chamcong}      /clockings/{0}
${endpoint_chamcong}    /paysheets?BranchIds={0}&OrderByDesc=CreatedDate&PaysheetStatuses=%5B1,2%5D&skip=0
${endpoint_xoa_ca_lamviec}    /shifts/{0}

*** Keywords ***
Add new shift
    [Arguments]     ${input_ten_ca}     ${input_gio_bd}     ${input_gio_kt}      ${input_branch}
    ${input_gio_bd}     Convert Time    ${input_gio_bd}
    ${input_gio_kt}     Convert Time    ${input_gio_kt}
    ${input_gio_bd}     Replace floating point    ${input_gio_bd}
    ${input_gio_kt}     Replace floating point    ${input_gio_kt}
    ${get_branch_id}      Get BranchID by BranchName    ${input_branch}
    ${payload}    Format String    {{"shift":{{"id":0,"name":"{0}","from":{1},"to":{2},"isActive":true,"branchId":{3}}}}}   ${input_ten_ca}      ${input_gio_bd}     ${input_gio_kt}    ${get_branch_id}
    Log    ${payload}
    ${headers}=    Create Dictionary    Authorization=${bearertoken}    content-type=application/json;charset=UTF-8        branchid=${get_branch_id}     retailer=${RETAILER_NAME}
    Create Session    lolo    ${TIMESHEET_API}        cookies=${resp.cookies}    verify=True    debug=1
    ${resp1}=    Post Request    lolo   /shifts   data=${payload}    headers=${headers}
    log    ${resp1.status_code}
    Log    ${resp1.request.body}
    Log    ${resp1.json()}
    Should Be Equal As Strings    ${resp1.status_code}    200

Update shift thr API
    [Arguments]     ${input_ten_ca}     ${input_gio_bd}     ${input_gio_kt}      ${input_branch}
    ${input_gio_bd}     Convert Time    ${input_gio_bd}
    ${input_gio_kt}     Convert Time    ${input_gio_kt}
    ${input_gio_bd}     Replace floating point    ${input_gio_bd}
    ${input_gio_kt}     Replace floating point    ${input_gio_kt}
    ${get_branch_id}      Get BranchID by BranchName    ${input_branch}
    ${get_shift_id}   Get shift id by branch thr API     ${input_ten_ca}    ${input_branch}
    ${endpoint_ca_lamviec}    Format String    ${endpoint_xoa_ca_lamviec}     ${get_shift_id}
    ${payload}    Format String   {{"shift":{{"id":{0},"name":"{1}","from":{2},"to":{3},"isActive":true,"branchId":{4}}}}}    ${get_shift_id}     ${input_ten_ca}      ${input_gio_bd}     ${input_gio_kt}    ${get_branch_id}
    Log    ${payload}
    ${headers}=    Create Dictionary    Authorization=${bearertoken}    content-type=application/json;charset=UTF-8        branchid=${get_branch_id}     retailer=${RETAILER_NAME}
    Create Session    lolo    ${TIMESHEET_API}        cookies=${resp.cookies}    verify=True    debug=1
    ${resp1}=    Put Request    lolo   ${endpoint_ca_lamviec}   data=${payload}    headers=${headers}
    log    ${resp1.status_code}
    Log    ${resp1.request.body}
    Log    ${resp1.json()}
    Should Be Equal As Strings    ${resp1.status_code}    200

Get shift id by branch thr API
    [Arguments]     ${input_ca_lv}    ${input_branch}
    [Timeout]     2 mins
    ${get_branch_id}    Get BranchID by BranchName    ${input_branch}
    ${jsonpath_calv_id}    Format String    $..result[?(@.name=="{0}")].id    ${input_ca_lv}
    ${endpoint_ca_lam_viec}      Format String       ${endpoint_ca_lam_viec}     ${get_branch_id}
    ${resp}  Get Request and return body by other url    ${TIMESHEET_API}    ${endpoint_ca_lam_viec}
    ${get_calv_id}    Get data from response json    ${resp}    ${jsonpath_calv_id}
    Return From Keyword    ${get_calv_id}

Add schedule work not repeat for one employee thr API
    [Arguments]     ${input_ten_ca}      ${input_branch}      ${input_ma_nv}
    ${start_date}    Get Current Date       result_format=%Y-%m-%d
    ${end_date}=    Add Time To Date      ${start_date}    1 day       result_format=%Y-%m-%d
    ${get_branch_id}      Get BranchID by BranchName    ${input_branch}
    ${get_id_ca}      Get shift id by branch thr API    ${input_ten_ca}      ${input_branch}
    ${get_id_nv}      Get employee id thr API     ${input_ma_nv}
    ${payload}    Format String    {{"TimeSheet":{{"id":0,"startDate":"{0}","endDate":"{1}","employeeId":{2},"isRepeat":false,"repeatType":1,"repeatEachDay":1,"branchId":{3},"clockings":[],"isDeleted":false,"saveOnHoliday":false,"note":"","timeSheetShifts":[{{"id":0,"timeSheetId":0,"shiftIds":"{4}","repeatDaysOfWeek":null}}]}},"EmployeeIds":[{2}]}}   ${start_date}      ${end_date}     ${get_id_nv}   ${get_branch_id}     ${get_id_ca}
    Log    ${payload}
    ${headers}=    Create Dictionary    Authorization=${bearertoken}    content-type=application/json;charset=UTF-8        branchid=${get_branch_id}     retailer=${RETAILER_NAME}
    Create Session    lolo    ${TIMESHEET_API}        cookies=${resp.cookies}    verify=True    debug=1
    ${resp1}=    Post Request    lolo   ${endpoint_datlich_lamviec}   data=${payload}    headers=${headers}
    log    ${resp1.status_code}
    Log    ${resp1.request.body}
    Log    ${resp1.json()}
    ${get_clocking_id}      Get data from response json    ${resp1.json()}    $..result..clockings..id
    ${get_timesheet_id}      Get data from response json    ${resp1.json()}    $..result..timeSheetShifts..timeSheetId
    Should Be Equal As Strings    ${resp1.status_code}    200
    ${get_clocking_id}      Convert To String    ${get_clocking_id}
    ${get_timesheet_id}      Convert To String    ${get_timesheet_id}
    Return From Keyword    ${get_clocking_id}   ${get_timesheet_id}

Get clocking status thr API
    [Arguments]   ${input_branch}
    [Timeout]     2 mins
    ${get_branch_id}    Get BranchID by BranchName    ${input_branch}
    ${get_start_time}   Get Current Date       result_format=%Y-%m-%d
    ${get_end_time}     Add Time To Date     ${get_start_time}    1 day     result_format=%Y-%m-%d
    ${endpoint_chitiet_calam}      Format String       ${endpoint_chitiet_calam}     ${get_branch_id}   ${get_end_time}     ${get_start_time}
    ${resp}  Get Request and return body by other url    ${TIMESHEET_API}    ${endpoint_chitiet_calam}
    ${get_clocking_status}    Get data from response json    ${resp}    $..data..clockingStatus
    Return From Keyword    ${get_clocking_status}

Update not timekeeping to timekeeping thr API
    [Arguments]     ${input_branch}   ${input_ca_lv}   ${input_ma_nv}       ${get_clocking_id}     ${get_timesheet_id}
    ${get_branch_id}      Get BranchID by BranchName    ${input_branch}
    ${get_day}   Get Current Date       result_format=%Y-%m-%d
    ${get_day_1}   Get Current Date       result_format=%d/%m/%Y
    ${input_gio_vao}    ${input_gio_ra}       Get shift infor thr API     ${input_ca_lv}    ${get_branch_id}
    ${get_check_in}    Subtract Time From Time      ${input_gio_vao}   420   timer   exclude_milles=no
    ${get_check_in}    Replace String     ${get_check_in}      00:    ${EMPTY}    count=1
    ${get_check_out}    Subtract Time From Time      ${input_gio_ra}   420   timer   exclude_milles=no
    ${get_check_out}    Replace String     ${get_check_out}      00:    ${EMPTY}    count=1
    ${get_employee_id}      Get employee id thr API    ${input_ma_nv}
    ${get_shift_id}     Get shift id by branch thr API    ${input_ca_lv}    ${input_branch}
    ${get_user_id}      Get User ID
    ${endpoint_chamcong}      Format String    ${endpoint_chamcong}   ${get_clocking_id}
    ${payload}    Format String    {{"Clocking":{{"id":{0},"shiftId":{1},"timeSheetId":{2},"employeeId":{3},"workById":{3},"clockingStatus":1,"startTime":"{4}T{5}:00.0000000","endTime":"{4}T{6}:00.0000000","branchId":{7},"tenantId":437336,"isDeleted":false,"employee":{{"id":{3},"code":"TLFV6","name":"Linh","isActive":true,"identityNumber":"","mobilePhone":"","email":"","facebook":"","address":"","locationName":"","wardName":"","note":"","tenantId":437336,"branchId":{7},"createdBy":{8},"createdDate":"","isDeleted":false}},"workBy":{{"id":{3},"code":"TLFV6","name":"Linh","isActive":true,"identityNumber":"","mobilePhone":"","email":"","facebook":"","address":"","locationName":"","wardName":"","note":"","tenantId":437336,"branchId":{7},"createdBy":{8},"createdDate":"","isDeleted":false}},"timeSheet":{{"id":{2},"employeeId":{3},"startDate":"{4}T00:00:00.0000000","endDate":"{4}T23:59:59.0000000","isRepeat":false,"repeatType":1,"repeatEachDay":1,"branchId":{7},"tenantId":437336,"isDeleted":false,"saveOnDaysOffOfBranch":false,"saveOnHoliday":false,"timeSheetStatus":1,"timeSheetShifts":[{{"id":24230,"shiftIds":"{1}","timeSheetShiftStatus":0,"timeSheetId":{2}}}],"note":"","employee":{{"id":{3},"code":"TLFV6","name":"Linh","isActive":true,"identityNumber":"","mobilePhone":"","email":"","facebook":"","address":"","locationName":"","wardName":"","note":"","tenantId":437336,"branchId":{7},"createdBy":{8},"createdDate":"","isDeleted":false}}}},"clockingHistories":[],"timeIsLate":0,"overTimeBeforeShiftWork":0,"timeIsLeaveWorkEarly":0,"overTimeAfterShiftWork":0,"clockingPaymentStatus":0}},"ReplacementEmployeeId":null,"ClockingHistory":{{"id":0,"clockingId":{0},"checkedInDate":"{4}T{10}:00.000Z","currentCheckInDate":"{9}","checkedOutDate":"{4}T{11}:00.000Z","currentCheckOutDate":"{9}","branchId":{7},"timeIsLate":0,"overTimeBeforeShiftWork":0,"timeIsLeaveWorkEarly":0,"overTimeAfterShiftWork":0,"clockingStatus":1,"timeKeepingType":1,"absenceType":null,"checkInDateType":2,"checkOutDateType":2}},"LeaveOfAbsence":false}}   ${get_clocking_id}      ${get_shift_id}     ${get_timesheet_id}   ${get_employee_id}      ${get_day}       ${input_gio_vao}      ${input_gio_ra}      ${get_branch_id}        ${get_user_id}    ${get_day_1}      ${get_check_in}     ${get_check_out}
    Log    ${payload}
    ${headers}=    Create Dictionary    Authorization=${bearertoken}    content-type=application/json;charset=UTF-8        branchid=${get_branch_id}     retailer=${RETAILER_NAME}
    Create Session    lolo    ${TIMESHEET_API}        cookies=${resp.cookies}    verify=True    debug=1
    ${resp1}=    Put Request    lolo      ${endpoint_chamcong}    data=${payload}    headers=${headers}
    log    ${resp1.status_code}
    Log    ${resp1.request.body}
    Log    ${resp1.json()}
    Should Be Equal As Strings    ${resp1.status_code}    200

Delete clocking thr API
    [Arguments]     ${input_clocking_id}      ${input_branch_id}
    ${payload}    Format String    {{"Ids":{0}}}   ${input_clocking_id}
    Log    ${payload}
    ${headers}=    Create Dictionary    Authorization=${bearertoken}    content-type=application/json;charset=UTF-8        branchid=${input_branch_id}     retailer=${RETAILER_NAME}
    Create Session    lolo    ${TIMESHEET_API}        cookies=${resp.cookies}    verify=True    debug=1
    ${resp1}=    Post Request    lolo   /clockings/cancelClockingByIds   data=${payload}    headers=${headers}
    log    ${resp1.status_code}
    Log    ${resp1.request.body}
    Log    ${resp1.json()}
    Should Be Equal As Strings    ${resp1.status_code}    200

Delete multi clocking thr API
    [Arguments]     ${list_clocking_id}      ${input_branch_id}
    ${list_clocking_id}   Convert To String    ${list_clocking_id}
    ${payload}    Format String    {{"Ids":{0}}}   ${list_clocking_id}
    Log    ${payload}
    ${headers}=    Create Dictionary    Authorization=${bearertoken}    content-type=application/json;charset=UTF-8        branchid=${input_branch_id}     retailer=${RETAILER_NAME}
    Create Session    lolo    ${TIMESHEET_API}        cookies=${resp.cookies}    verify=True    debug=1
    ${resp1}=    Post Request    lolo   /clockings/cancelClockingByIds   data=${payload}    headers=${headers}
    log    ${resp1.status_code}
    Log    ${resp1.request.body}
    Log    ${resp1.json()}
    Should Be Equal As Strings    ${resp1.status_code}    200

Add schedule work not repeat for one employee by day thr API
    [Arguments]    ${start_date}     ${input_ten_ca}      ${input_branch}      ${input_ma_nv}
    ${start_date}    Convert Date    ${start_date}      result_format=%Y-%m-%d
    ${end_date}=    Add Time To Date      ${start_date}    1 day       result_format=%Y-%m-%d
    ${get_branch_id}      Get BranchID by BranchName    ${input_branch}
    ${get_id_ca}      Get shift id by branch thr API    ${input_ten_ca}      ${input_branch}
    ${get_id_nv}      Get employee id thr API     ${input_ma_nv}
    ${payload}    Format String    {{"TimeSheet":{{"id":0,"startDate":"{0}","endDate":"{1}","employeeId":{2},"isRepeat":false,"repeatType":1,"repeatEachDay":1,"branchId":{3},"clockings":[],"isDeleted":false,"saveOnHoliday":false,"note":"","timeSheetShifts":[{{"id":0,"timeSheetId":0,"shiftIds":"{4}","repeatDaysOfWeek":null}}]}},"EmployeeIds":[{2}]}}   ${start_date}      ${end_date}     ${get_id_nv}   ${get_branch_id}     ${get_id_ca}
    Log    ${payload}
    ${headers}=    Create Dictionary    Authorization=${bearertoken}    content-type=application/json;charset=UTF-8        branchid=${get_branch_id}     retailer=${RETAILER_NAME}
    Create Session    lolo    ${TIMESHEET_API}        cookies=${resp.cookies}    verify=True    debug=1
    ${resp1}=    Post Request    lolo   ${endpoint_datlich_lamviec}   data=${payload}    headers=${headers}
    log    ${resp1.status_code}
    Log    ${resp1.request.body}
    Log    ${resp1.json()}
    ${get_clocking_id}      Get data from response json    ${resp1.json()}    $..result..clockings..id
    ${get_timesheet_id}      Get data from response json    ${resp1.json()}    $..result..timeSheetShifts..timeSheetId
    Should Be Equal As Strings    ${resp1.status_code}    200
    ${get_clocking_id}      Convert To String    ${get_clocking_id}
    ${get_timesheet_id}      Convert To String    ${get_timesheet_id}
    Return From Keyword    ${get_clocking_id}   ${get_timesheet_id}

Update not timekeeping to timekeeping by day thr API
    [Arguments]      ${input_branch}   ${input_day}    ${input_ca_lv}   ${input_ma_nv}     ${get_clocking_id}     ${get_timesheet_id}
    ${input_day1}   Convert Date     ${input_day}    result_format=%Y-%m-%d
    ${input_day2}   Convert Date      ${input_day}     result_format=%d/%m/%Y
    ${get_branch_id}      Get BranchID by BranchName    ${input_branch}
    ${input_gio_vao}    ${input_gio_ra}       Get shift infor thr API     ${input_ca_lv}    ${get_branch_id}
    ${get_check_in}    Subtract Time From Time      ${input_gio_vao}   420   timer   exclude_milles=no
    ${get_check_in}    Replace String     ${get_check_in}      00:    ${EMPTY}    count=1
    ${get_check_out}    Subtract Time From Time      ${input_gio_ra}   420   timer   exclude_milles=no
    ${get_check_out}    Replace String     ${get_check_out}      00:    ${EMPTY}    count=1
    ${get_employee_id}      Get employee id thr API    ${input_ma_nv}
    ${get_shift_id}     Get shift id by branch thr API    ${input_ca_lv}    ${input_branch}
    ${get_user_id}      Get User ID
    ${endpoint_chamcong}      Format String    ${endpoint_chamcong}   ${get_clocking_id}
    ${payload}    Format String    {{"Clocking":{{"id":{0},"shiftId":{1},"timeSheetId":{2},"employeeId":{3},"workById":{3},"clockingStatus":1,"startTime":"{4}T{5}:00.0000000","endTime":"{4}T{6}:00.0000000","branchId":{7},"tenantId":437336,"isDeleted":false,"employee":{{"id":{3},"code":"TLFV6","name":"Linh","isActive":true,"identityNumber":"","mobilePhone":"","email":"","facebook":"","address":"","locationName":"","wardName":"","note":"","tenantId":437336,"branchId":{7},"createdBy":{8},"createdDate":"","isDeleted":false}},"workBy":{{"id":{3},"code":"TLFV6","name":"Linh","isActive":true,"identityNumber":"","mobilePhone":"","email":"","facebook":"","address":"","locationName":"","wardName":"","note":"","tenantId":437336,"branchId":{7},"createdBy":{8},"createdDate":"","isDeleted":false}},"timeSheet":{{"id":{2},"employeeId":{3},"startDate":"{4}T00:00:00.0000000","endDate":"{4}T23:59:59.0000000","isRepeat":false,"repeatType":1,"repeatEachDay":1,"branchId":{7},"tenantId":437336,"isDeleted":false,"saveOnDaysOffOfBranch":false,"saveOnHoliday":false,"timeSheetStatus":1,"timeSheetShifts":[{{"id":24230,"shiftIds":"{1}","timeSheetShiftStatus":0,"timeSheetId":{2}}}],"note":"","employee":{{"id":{3},"code":"TLFV6","name":"Linh","isActive":true,"identityNumber":"","mobilePhone":"","email":"","facebook":"","address":"","locationName":"","wardName":"","note":"","tenantId":437336,"branchId":{7},"createdBy":{8},"createdDate":"","isDeleted":false}}}},"clockingHistories":[],"timeIsLate":0,"overTimeBeforeShiftWork":0,"timeIsLeaveWorkEarly":0,"overTimeAfterShiftWork":0,"clockingPaymentStatus":0}},"ReplacementEmployeeId":null,"ClockingHistory":{{"id":0,"clockingId":{0},"checkedInDate":"{4}T{10}:00.000Z","currentCheckInDate":"{9}","checkedOutDate":"{4}T{11}:00.000Z","currentCheckOutDate":"{9}","branchId":{7},"timeIsLate":0,"overTimeBeforeShiftWork":0,"timeIsLeaveWorkEarly":0,"overTimeAfterShiftWork":0,"clockingStatus":1,"timeKeepingType":1,"absenceType":null,"checkInDateType":2,"checkOutDateType":2}},"LeaveOfAbsence":false}}   ${get_clocking_id}      ${get_shift_id}     ${get_timesheet_id}   ${get_employee_id}      ${input_day1}       ${input_gio_vao}      ${input_gio_ra}      ${get_branch_id}        ${get_user_id}    ${input_day2}      ${get_check_in}     ${get_check_out}
    Log    ${payload}
    ${headers}=    Create Dictionary    Authorization=${bearertoken}    content-type=application/json;charset=UTF-8        branchid=${get_branch_id}     retailer=${RETAILER_NAME}
    Create Session    lolo    ${TIMESHEET_API}        cookies=${resp.cookies}    verify=True    debug=1
    ${resp1}=    Put Request    lolo      ${endpoint_chamcong}    data=${payload}    headers=${headers}
    log    ${resp1.status_code}
    Log    ${resp1.request.body}
    Log    ${resp1.json()}
    Should Be Equal As Strings    ${resp1.status_code}    200

Update not timekeeping to absent thr API
    [Arguments]      ${absent_type}   ${input_branch}      ${input_ca_lv}   ${input_ma_nv}       ${get_clocking_id}     ${get_timesheet_id}
    ${get_day}   Get Current Date       result_format=%Y-%m-%d
    ${get_day_1}   Get Current Date       result_format=%d/%m/%Y
    ${get_branch_id}      Get BranchID by BranchName    ${input_branch}
    ${input_gio_vao}    ${input_gio_ra}       Get shift infor thr API     ${input_ca_lv}    ${get_branch_id}
    ${get_employee_id}      Get employee id thr API    ${input_ma_nv}
    ${get_shift_id}     Get shift id by branch thr API    ${input_ca_lv}    ${input_branch}
    ${get_user_id}      Get User ID
    ${actual_absent_type}     Set Variable If    '${absent_type}'=='yes'     1       2
    ${endpoint_chamcong}      Format String    ${endpoint_chamcong}   ${get_clocking_id}
    ${payload}    Format String    {{"Clocking":{{"id":{0},"shiftId":{1},"timeSheetId":{2},"employeeId":{3},"workById":{3},"clockingStatus":1,"startTime":"{4}T{5}:00.0000000","endTime":"{4}T{6}:00.0000000","branchId":{7},"tenantId":,"isDeleted":false,"employee":{{"id":{3},"code":"NV017","name":"Nguyễn vẵn An","isActive":true,"identityNumber":"","mobilePhone":"","email":"","facebook":"","address":"","locationName":"","wardName":"","note":"","tenantId":,"branchId":{7},"createdBy":{8},"createdDate":"","isDeleted":false}},"workBy":{{"id":{3},"code":"NV017","name":"Nguyễn vẵn An","isActive":true,"identityNumber":"","mobilePhone":"","email":"","facebook":"","address":"","locationName":"","wardName":"","note":"","tenantId":,"branchId":{7},"createdBy":{8},"createdDate":"","isDeleted":false}},"timeSheet":{{"id":{2},"employeeId":{3},"startDate":"{4}T00:00:00.0000000","endDate":"{4}T23:59:59.0000000","isRepeat":false,"repeatType":1,"repeatEachDay":1,"branchId":{7},"tenantId":437336,"isDeleted":false,"saveOnDaysOffOfBranch":false,"saveOnHoliday":false,"timeSheetStatus":1,"timeSheetShifts":[{{"id":24397,"shiftIds":"{1}","timeSheetShiftStatus":0,"timeSheetId":{2}}}],"note":"","employee":{{"id":{3},"code":"NV017","name":"Nguyễn vẵn An","isActive":true,"identityNumber":"","mobilePhone":"","email":"","facebook":"","address":"","locationName":"","wardName":"","note":"","tenantId":437336,"branchId":{7},"createdBy":{8},"createdDate":"","isDeleted":false}}}},"clockingHistories":[],"timeIsLate":0,"overTimeBeforeShiftWork":0,"timeIsLeaveWorkEarly":0,"overTimeAfterShiftWork":0,"clockingPaymentStatus":0}},"ReplacementEmployeeId":null,"ClockingHistory":{{"id":0,"clockingId":{0},"checkedInDate":null,"currentCheckInDate":"{9}","checkedOutDate":null,"currentCheckOutDate":"{9}","branchId":{7},"timeIsLate":0,"overTimeBeforeShiftWork":0,"timeIsLeaveWorkEarly":0,"overTimeAfterShiftWork":0,"clockingStatus":1,"timeKeepingType":1,"absenceType":{10},"checkInDateType":2,"checkOutDateType":2}},"LeaveOfAbsence":true}}   ${get_clocking_id}      ${get_shift_id}     ${get_timesheet_id}   ${get_employee_id}     ${get_day}     ${input_gio_vao}       ${input_gio_ra}     ${get_branch_id}      ${get_user_id}         ${get_day_1}    ${actual_absent_type}
    Log    ${payload}
    ${headers}=    Create Dictionary    Authorization=${bearertoken}    content-type=application/json;charset=UTF-8        branchid=${get_branch_id}     retailer=${RETAILER_NAME}
    Create Session    lolo    ${TIMESHEET_API}        cookies=${resp.cookies}    verify=True    debug=1
    ${resp1}=    Put Request    lolo      ${endpoint_chamcong}    data=${payload}    headers=${headers}
    log    ${resp1.status_code}
    Log    ${resp1.request.body}
    Log    ${resp1.json()}
    Should Be Equal As Strings    ${resp1.status_code}    200

Update not timekeeping to late timekeeping thr API
    [Arguments]     ${input_branch}   ${input_ca_lv}   ${input_ma_nv}      ${time_late}   ${get_clocking_id}     ${get_timesheet_id}
    ${get_day}   Get Current Date       result_format=%Y-%m-%d
    ${get_day_1}   Get Current Date       result_format=%d/%m/%Y
    ${get_branch_id}      Get BranchID by BranchName    ${input_branch}
    ${input_gio_vao}    ${input_gio_ra}       Get shift infor thr API     ${input_ca_lv}    ${get_branch_id}
    ${get_check_in}    Subtract Time From Time      ${input_gio_vao}   420   timer   exclude_milles=no
    ${get_check_in}    Add Time To Time      ${get_check_in}   ${time_late}   timer   exclude_milles=no
    #${get_check_in}    Replace String      ${get_check_in}   00:   !   count=1
    ${get_check_in}    Replace string     ${get_check_in}     00:    ${EMPTY}     count=1
    ${get_check_out}    Subtract Time From Time      ${input_gio_ra}   420   timer   exclude_milles=no
    ${get_check_out}    Replace String     ${get_check_out}      00:    ${EMPTY}    count=1
    ${get_employee_id}      Get employee id thr API    ${input_ma_nv}
    ${get_shift_id}     Get shift id by branch thr API    ${input_ca_lv}    ${input_branch}
    ${get_user_id}      Get User ID
    ${endpoint_chamcong}      Format String    ${endpoint_chamcong}   ${get_clocking_id}
    ${payload}    Format String    {{"Clocking":{{"id":{0},"shiftId":{1},"timeSheetId":{2},"employeeId":{3},"workById":{3},"clockingStatus":1,"startTime":"{4}T{5}:00.0000000","endTime":"{4}T{6}:00.0000000","branchId":{7},"tenantId":437336,"isDeleted":false,"employee":{{"id":{3},"code":"TLFV6","name":"Linh","isActive":true,"identityNumber":"","mobilePhone":"","email":"","facebook":"","address":"","locationName":"","wardName":"","note":"","tenantId":437336,"branchId":{7},"createdBy":{8},"createdDate":"","isDeleted":false}},"workBy":{{"id":{3},"code":"TLFV6","name":"Linh","isActive":true,"identityNumber":"","mobilePhone":"","email":"","facebook":"","address":"","locationName":"","wardName":"","note":"","tenantId":437336,"branchId":{7},"createdBy":{8},"createdDate":"","isDeleted":false}},"timeSheet":{{"id":{2},"employeeId":{3},"startDate":"{4}T00:00:00.0000000","endDate":"{4}T23:59:59.0000000","isRepeat":false,"repeatType":1,"repeatEachDay":1,"branchId":{7},"tenantId":437336,"isDeleted":false,"saveOnDaysOffOfBranch":false,"saveOnHoliday":false,"timeSheetStatus":1,"timeSheetShifts":[{{"id":24230,"shiftIds":"{1}","timeSheetShiftStatus":0,"timeSheetId":{2}}}],"note":"","employee":{{"id":{3},"code":"TLFV6","name":"Linh","isActive":true,"identityNumber":"","mobilePhone":"","email":"","facebook":"","address":"","locationName":"","wardName":"","note":"","tenantId":437336,"branchId":{7},"createdBy":{8},"createdDate":"","isDeleted":false}}}},"clockingHistories":[],"timeIsLate":0,"overTimeBeforeShiftWork":0,"timeIsLeaveWorkEarly":0,"overTimeAfterShiftWork":0,"clockingPaymentStatus":0}},"ReplacementEmployeeId":null,"ClockingHistory":{{"id":0,"clockingId":{0},"checkedInDate":"{4}T{10}:00.000Z","currentCheckInDate":"{9}","checkedOutDate":"{4}T{11}:00.000Z","currentCheckOutDate":"{9}","branchId":{7},"timeIsLate":{12},"overTimeBeforeShiftWork":0,"timeIsLeaveWorkEarly":0,"overTimeAfterShiftWork":0,"clockingStatus":1,"timeKeepingType":1,"absenceType":null,"checkInDateType":2,"checkOutDateType":2}},"LeaveOfAbsence":false}}   ${get_clocking_id}      ${get_shift_id}     ${get_timesheet_id}   ${get_employee_id}      ${get_day}       ${input_gio_vao}      ${input_gio_ra}      ${get_branch_id}        ${get_user_id}    ${get_day_1}      ${get_check_in}     ${get_check_out}        ${time_late}
    Log    ${payload}
    ${headers}=    Create Dictionary    Authorization=${bearertoken}    content-type=application/json;charset=UTF-8        branchid=${get_branch_id}     retailer=${RETAILER_NAME}
    Create Session    lolo    ${TIMESHEET_API}        cookies=${resp.cookies}    verify=True    debug=1
    ${resp1}=    Put Request    lolo      ${endpoint_chamcong}    data=${payload}    headers=${headers}
    log    ${resp1.status_code}
    Log    ${resp1.request.body}
    Log    ${resp1.json()}
    Should Be Equal As Strings    ${resp1.status_code}    200

Update not timekeeping to timekeeping and over time thr API
    [Arguments]     ${input_branch}   ${input_ca_lv}   ${input_ma_nv}     ${input_di_som}      ${input_ve_muon}   ${get_clocking_id}     ${get_timesheet_id}
    ${get_day}   Get Current Date       result_format=%Y-%m-%d
    ${get_day_1}   Get Current Date       result_format=%d/%m/%Y
    ${get_branch_id}      Get BranchID by BranchName    ${input_branch}
    ${input_gio_vao}    ${input_gio_ra}       Get shift infor thr API     ${input_ca_lv}    ${get_branch_id}
    ${get_check_in}    Subtract Time From Time      ${input_gio_vao}   420   timer   exclude_milles=no
    ${get_check_in}    Subtract Time From Time      ${get_check_in}   ${input_di_som}   timer   exclude_milles=no
    ${get_check_in}    Replace string     ${get_check_in}     00:    ${EMPTY}     count=1
    ${get_check_out}    Subtract Time From Time      ${input_gio_ra}   420   timer   exclude_milles=no
    ${get_check_out}    Add Time To Time       ${get_check_out}   ${input_ve_muon}   timer   exclude_milles=no
    ${get_check_out}    Replace String     ${get_check_out}      00:    ${EMPTY}    count=1
    Log    ${input_gio_vao}
    Log    ${input_gio_ra}
    ${get_employee_id}      Get employee id thr API    ${input_ma_nv}
    ${get_shift_id}     Get shift id by branch thr API    ${input_ca_lv}    ${input_branch}
    ${get_user_id}      Get User ID
    ${endpoint_chamcong}      Format String    ${endpoint_chamcong}   ${get_clocking_id}
    ${payload}    Format String    {{"Clocking":{{"id":{0},"shiftId":{1},"timeSheetId":{2},"employeeId":{3},"workById":{3},"clockingStatus":1,"startTime":"{4}T{5}:00.0000000","endTime":"{4}T{6}:00.0000000","branchId":{7},"tenantId":,"isDeleted":false,"employee":{{"id":{3},"code":"TLFV6","name":"Linh","isActive":true,"identityNumber":"","mobilePhone":"","email":"","facebook":"","address":"","locationName":"","wardName":"","note":"","tenantId":,"branchId":{7},"createdBy":{8},"createdDate":"","isDeleted":false}},"workBy":{{"id":{3},"code":"TLFV6","name":"Linh","isActive":true,"identityNumber":"","mobilePhone":"","email":"","facebook":"","address":"","locationName":"","wardName":"","note":"","tenantId":,"branchId":{7},"createdBy":{8},"createdDate":"","isDeleted":false}},"timeSheet":{{"id":{2},"employeeId":{3},"startDate":"{4}T00:00:00.0000000","endDate":"{4}T23:59:59.0000000","isRepeat":false,"repeatType":1,"repeatEachDay":1,"branchId":{7},"tenantId":,"isDeleted":false,"saveOnDaysOffOfBranch":false,"saveOnHoliday":false,"timeSheetStatus":1,"timeSheetShifts":[{{"id":24230,"shiftIds":"{1}","timeSheetShiftStatus":0,"timeSheetId":{2}}}],"note":"","employee":{{"id":{3},"code":"TLFV6","name":"Linh","isActive":true,"identityNumber":"","mobilePhone":"","email":"","facebook":"","address":"","locationName":"","wardName":"","note":"","tenantId":,"branchId":{7},"createdBy":{8},"createdDate":"","isDeleted":false}}}},"clockingHistories":[],"timeIsLate":0,"overTimeBeforeShiftWork":0,"timeIsLeaveWorkEarly":0,"overTimeAfterShiftWork":0,"clockingPaymentStatus":0}},"ReplacementEmployeeId":null,"ClockingHistory":{{"id":0,"clockingId":{0},"checkedInDate":"{4}T{10}:00.000Z","currentCheckInDate":"{9}","checkedOutDate":"{4}T{11}:00.000Z","currentCheckOutDate":"{9}","branchId":{7},"timeIsLate":0,"overTimeBeforeShiftWork":{12},"timeIsLeaveWorkEarly":0,"overTimeAfterShiftWork":{13},"clockingStatus":1,"timeKeepingType":1,"absenceType":null,"checkInDateType":2,"checkOutDateType":2}},"LeaveOfAbsence":false}}   ${get_clocking_id}      ${get_shift_id}     ${get_timesheet_id}   ${get_employee_id}      ${get_day}       ${input_gio_vao}      ${input_gio_ra}      ${get_branch_id}        ${get_user_id}    ${get_day_1}      ${get_check_in}     ${get_check_out}        ${input_di_som}     ${input_ve_muon}
    Log    ${payload}
    ${headers}=    Create Dictionary    Authorization=${bearertoken}    content-type=application/json;charset=UTF-8        branchid=${get_branch_id}     retailer=${RETAILER_NAME}
    Create Session    lolo    ${TIMESHEET_API}        cookies=${resp.cookies}    verify=True    debug=1
    ${resp1}=    Put Request    lolo      ${endpoint_chamcong}    data=${payload}    headers=${headers}
    log    ${resp1.status_code}
    Log    ${resp1.request.body}
    Log    ${resp1.json()}
    Should Be Equal As Strings    ${resp1.status_code}    200

Update not timekeeping to timekeeping and over time by day thr API
    [Arguments]     ${input_branch}   ${input_day}    ${input_ca_lv}   ${input_ma_nv}    ${input_di_som}      ${input_ve_muon}   ${get_clocking_id}     ${get_timesheet_id}
    ${input_day1}   Convert Date     ${input_day}    result_format=%Y-%m-%d
    ${input_day2}   Convert Date      ${input_day}     result_format=%d/%m/%Y
    ${get_branch_id}      Get BranchID by BranchName    ${input_branch}
    ${input_gio_vao}    ${input_gio_ra}       Get shift infor thr API     ${input_ca_lv}    ${get_branch_id}
    ${get_check_in}    Subtract Time From Time      ${input_gio_vao}   420   timer   exclude_milles=no
    ${get_check_in}    Subtract Time From Time      ${get_check_in}   ${input_di_som}   timer   exclude_milles=no
    ${get_check_in}    Replace string     ${get_check_in}     00:    ${EMPTY}     count=1
    ${get_check_out}    Subtract Time From Time      ${input_gio_ra}   420   timer   exclude_milles=no
    ${get_check_out}    Add Time To Time       ${get_check_out}   ${input_ve_muon}   timer   exclude_milles=no
    ${get_check_out}    Replace String     ${get_check_out}      00:    ${EMPTY}    count=1
    Log    ${input_gio_vao}
    Log    ${input_gio_ra}
    ${get_employee_id}      Get employee id thr API    ${input_ma_nv}
    ${get_shift_id}     Get shift id by branch thr API    ${input_ca_lv}    ${input_branch}
    ${get_user_id}      Get User ID
    ${endpoint_chamcong}      Format String    ${endpoint_chamcong}   ${get_clocking_id}
    ${payload}    Format String    {{"Clocking":{{"id":{0},"shiftId":{1},"timeSheetId":{2},"employeeId":{3},"workById":{3},"clockingStatus":1,"startTime":"{4}T{5}:00.0000000","endTime":"{4}T{6}:00.0000000","branchId":{7},"tenantId":,"isDeleted":false,"employee":{{"id":{3},"code":"TLFV6","name":"Linh","isActive":true,"identityNumber":"","mobilePhone":"","email":"","facebook":"","address":"","locationName":"","wardName":"","note":"","tenantId":,"branchId":{7},"createdBy":{8},"createdDate":"","isDeleted":false}},"workBy":{{"id":{3},"code":"TLFV6","name":"Linh","isActive":true,"identityNumber":"","mobilePhone":"","email":"","facebook":"","address":"","locationName":"","wardName":"","note":"","tenantId":,"branchId":{7},"createdBy":{8},"createdDate":"","isDeleted":false}},"timeSheet":{{"id":{2},"employeeId":{3},"startDate":"{4}T00:00:00.0000000","endDate":"{4}T23:59:59.0000000","isRepeat":false,"repeatType":1,"repeatEachDay":1,"branchId":{7},"tenantId":,"isDeleted":false,"saveOnDaysOffOfBranch":false,"saveOnHoliday":false,"timeSheetStatus":1,"timeSheetShifts":[{{"id":24230,"shiftIds":"{1}","timeSheetShiftStatus":0,"timeSheetId":{2}}}],"note":"","employee":{{"id":{3},"code":"TLFV6","name":"Linh","isActive":true,"identityNumber":"","mobilePhone":"","email":"","facebook":"","address":"","locationName":"","wardName":"","note":"","tenantId":,"branchId":{7},"createdBy":{8},"createdDate":"","isDeleted":false}}}},"clockingHistories":[],"timeIsLate":0,"overTimeBeforeShiftWork":0,"timeIsLeaveWorkEarly":0,"overTimeAfterShiftWork":0,"clockingPaymentStatus":0}},"ReplacementEmployeeId":null,"ClockingHistory":{{"id":0,"clockingId":{0},"checkedInDate":"{4}T{10}:00.000Z","currentCheckInDate":"{9}","checkedOutDate":"{4}T{11}:00.000Z","currentCheckOutDate":"{9}","branchId":{7},"timeIsLate":0,"overTimeBeforeShiftWork":{12},"timeIsLeaveWorkEarly":0,"overTimeAfterShiftWork":{13},"clockingStatus":1,"timeKeepingType":1,"absenceType":null,"checkInDateType":2,"checkOutDateType":2}},"LeaveOfAbsence":false}}   ${get_clocking_id}      ${get_shift_id}     ${get_timesheet_id}   ${get_employee_id}      ${input_day1}       ${input_gio_vao}      ${input_gio_ra}      ${get_branch_id}        ${get_user_id}    ${input_day2}      ${get_check_in}     ${get_check_out}        ${input_di_som}     ${input_ve_muon}
    Log    ${payload}
    ${headers}=    Create Dictionary    Authorization=${bearertoken}    content-type=application/json;charset=UTF-8        branchid=${get_branch_id}     retailer=${RETAILER_NAME}
    Create Session    lolo    ${TIMESHEET_API}        cookies=${resp.cookies}    verify=True    debug=1
    ${resp1}=    Put Request    lolo      ${endpoint_chamcong}    data=${payload}    headers=${headers}
    log    ${resp1.status_code}
    Log    ${resp1.request.body}
    Log    ${resp1.json()}
    Should Be Equal As Strings    ${resp1.status_code}    200

Delete shift thr API
    [Arguments]     ${input_ten_ca}    ${input_branch}
    ${get_calv_id}      Get shift id by branch thr API    ${input_ten_ca}    ${input_branch}
    ${endpoint_xoa_ca_lamviec}    Format String    ${endpoint_xoa_ca_lamviec}     ${get_calv_id}
    ${headers}=    Create Dictionary    Authorization=${bearertoken}    content-type=application/json;charset=UTF-8        branchid=${BRANCH_ID}     retailer=${RETAILER_NAME}
    Create Session    lolo    ${TIMESHEET_API}        cookies=${resp.cookies}    verify=True    debug=1
    ${resp1}=    Delete Request    lolo   ${endpoint_xoa_ca_lamviec}    headers=${headers}
    log    ${resp1.status_code}
    Log    ${resp1.request.body}
    Log    ${resp1.json()}
    Should Be Equal As Strings    ${resp1.status_code}    200

Get shift infor thr API
    [Arguments]     ${input_ca_lv}    ${input_branch_id}
    [Timeout]     2 mins
    ${jsonpath_gio_bd}    Format String    $..result[?(@.name=="{0}")].from    ${input_ca_lv}
    ${jsonpath_gio_kt}    Format String    $..result[?(@.name=="{0}")].to    ${input_ca_lv}
    ${endpoint_ca_lam_viec}      Format String       ${endpoint_ca_lam_viec}     ${input_branch_id}
    ${resp}  Get Request and return body by other url    ${TIMESHEET_API}    ${endpoint_ca_lam_viec}
    ${get_gio_bd}    Get data from response json    ${resp}    ${jsonpath_gio_bd}
    ${get_gio_kt}    Get data from response json    ${resp}    ${jsonpath_gio_kt}
    ${get_gio_bd}     Convert minute to hour    ${get_gio_bd}
    ${get_gio_kt}     Convert minute to hour    ${get_gio_kt}
    Return From Keyword    ${get_gio_bd}      ${get_gio_kt}

Get clocking id and status by employee thr API
    [Arguments]    ${input_branch_id}       ${input_nv_id}
    ${get_cur_date}   Get Current Date       result_format=%Y-%m-%d
    ${get_start_time}    Subtract Time From Date      ${get_cur_date}   3 day     result_format=%Y-%m-%d
    ${get_end_time}     Add Time To Date     ${get_cur_date}    3 day     result_format=%Y-%m-%d
    ${endpoint_chitiet_calam}      Format String       ${endpoint_chitiet_calam}     ${input_branch_id}   ${get_end_time}     ${get_start_time}
    ${resp}  Get Request and return body by other url    ${TIMESHEET_API}    ${endpoint_chitiet_calam}
    ${jsonpath_clocking_id}     Format String    $..result..data[?(@.employeeId=={0})].id    ${input_nv_id}
    ${jsonpath_clocking_status}     Format String    $..result..data[?(@.employeeId=={0})].clockingStatus    ${input_nv_id}
    ${get_clocking_id}    Get raw data from response json    ${resp}    ${jsonpath_clocking_id}
    ${get_clocking_status}    Get raw data from response json    ${resp}    ${jsonpath_clocking_status}
    Return From Keyword    ${get_clocking_id}   ${get_clocking_status}

Get clocking id, absence type and status by employee thr API
    [Arguments]    ${input_branch_id}       ${input_nv_id}
    ${get_cur_date}   Get Current Date       result_format=%Y-%m-%d
    ${get_start_time}    Subtract Time From Date      ${get_cur_date}   3 day     result_format=%Y-%m-%d
    ${get_end_time}     Add Time To Date     ${get_cur_date}    3 day     result_format=%Y-%m-%d
    ${endpoint_chitiet_calam}      Format String       ${endpoint_chitiet_calam}     ${input_branch_id}   ${get_end_time}     ${get_start_time}
    ${resp}  Get Request and return body by other url    ${TIMESHEET_API}    ${endpoint_chitiet_calam}
    ${jsonpath_clocking_id}     Format String    $..result..data[?(@.employeeId=={0})].id    ${input_nv_id}
    ${jsonpath_clocking_status}     Format String    $..result..data[?(@.employeeId=={0})].clockingStatus    ${input_nv_id}
    ${jsonpath_absence_type}     Format String    $..result..data[?(@.employeeId=={0})].absenceType    ${input_nv_id}
    ${get_clocking_id}    Get raw data from response json    ${resp}    ${jsonpath_clocking_id}
    ${get_clocking_status}    Get raw data from response json    ${resp}    ${jsonpath_clocking_status}
    ${get_absence_type}    Get raw data from response json    ${resp}    ${jsonpath_absence_type}
    Return From Keyword    ${get_clocking_id}   ${get_clocking_status}    ${get_absence_type}

Add schedule work repeat for one employee thr API
    [Arguments]     ${input_ten_ca}      ${input_branch}      ${input_ma_nv}    ${repeat_type}    ${repeat_each_day}      ${input_start_date}   ${input_end_date}
    ${input_start_date}     Subtract Time From Date    ${input_start_date}    1 day      result_format=%Y-%m-%d
    ${get_branch_id}      Get BranchID by BranchName    ${input_branch}
    ${get_id_ca}      Get shift id by branch thr API    ${input_ten_ca}      ${input_branch}
    ${get_id_nv}      Get employee id thr API     ${input_ma_nv}
    ${repeat_type}      Set Variable If     '${repeat_type}'=='ngày'     1       2
    ${payload}    Format String    {{"TimeSheet":{{"id":0,"startDate":"{0}T17:00:00.000Z","endDate":"{1}T16:59:59.999Z","employeeId":{2},"isRepeat":true,"repeatType":{3},"repeatEachDay":{4},"branchId":{5},"clockings":[],"isDeleted":false,"saveOnHoliday":false,"note":"","timeSheetShifts":[{{"id":0,"timeSheetId":0,"shiftIds":"{6}","repeatDaysOfWeek":null}}]}},"EmployeeIds":[{2}]}}     ${input_start_date}    ${input_end_date}     ${get_id_nv}    ${repeat_type}    ${repeat_each_day}   ${get_branch_id}     ${get_id_ca}
    Log    ${payload}
    ${headers}=    Create Dictionary    Authorization=${bearertoken}    content-type=application/json;charset=UTF-8        branchid=${get_branch_id}     retailer=${RETAILER_NAME}
    Create Session    lolo    ${TIMESHEET_API}        cookies=${resp.cookies}    verify=True    debug=1
    ${resp1}=    Post Request    lolo   ${endpoint_datlich_lamviec}   data=${payload}    headers=${headers}
    log    ${resp1.status_code}
    Log    ${resp1.request.body}
    Log    ${resp1.json()}
    ${get_clocking_id}      Get raw data from response json    ${resp1.json()}    $..result..clockings..id
    ${get_timesheet_id}      Get raw data from response json    ${resp1.json()}    $..result..timeSheetShifts..timeSheetId
    Should Be Equal As Strings    ${resp1.status_code}    200
    ${get_clocking_id}      Convert To String    ${get_clocking_id}
    ${get_timesheet_id}      Convert To String    ${get_timesheet_id}
    Return From Keyword    ${get_clocking_id}   ${get_timesheet_id}

Update not timekeeping to timekeeping and over time over night thr API
    [Arguments]     ${input_branch}   ${input_ca_lv}   ${input_ma_nv}     ${input_di_som}      ${input_ve_muon}   ${get_clocking_id}     ${get_timesheet_id}
    ${get_day_checkin}   Get Current Date       result_format=%Y-%m-%d
    ${get_day_checkin_1}   Get Current Date       result_format=%d/%m/%Y
    ${get_day_checkout}   Add Time To Date    ${get_day_checkin}    1 day      result_format=%Y-%m-%d
    ${get_day_checkout_1}   Convert Date    ${get_day_checkout}       result_format=%d/%m/%Y
    ${get_branch_id}      Get BranchID by BranchName    ${input_branch}
    ${input_gio_vao}    ${input_gio_ra}       Get shift infor thr API     ${input_ca_lv}    ${get_branch_id}
    ${get_check_in}    Subtract Time From Time      ${input_gio_vao}   420   timer   exclude_milles=no
    ${get_check_in}    Subtract Time From Time      ${get_check_in}   ${input_di_som}   timer   exclude_milles=no
    ${get_check_in}    Replace string     ${get_check_in}     00:    ${EMPTY}     count=1
    ${get_check_out}    Subtract Time From Time      ${input_gio_ra}   420   timer   exclude_milles=no
    ${get_check_out}    Add Time To Time       ${get_check_out}   ${input_ve_muon}   timer   exclude_milles=no
    ${get_check_out}    Replace String     ${get_check_out}      00:    ${EMPTY}    count=1
    Log    ${input_gio_vao}
    Log    ${input_gio_ra}
    ${get_employee_id}      Get employee id thr API    ${input_ma_nv}
    ${get_shift_id}     Get shift id by branch thr API    ${input_ca_lv}    ${input_branch}
    ${get_user_id}      Get User ID
    ${endpoint_chamcong}      Format String    ${endpoint_chamcong}   ${get_clocking_id}
    ${payload}    Format String    {{"Clocking":{{"id":{0},"shiftId":{1},"timeSheetId":{2},"employeeId":{3},"workById":{3},"clockingStatus":1,"startTime":"{4}T{5}:00.0000000","endTime":"{4}T{6}:00.0000000","branchId":{7},"tenantId":,"isDeleted":false,"employee":{{"id":{3},"code":"TLFV6","name":"Linh","isActive":true,"identityNumber":"","mobilePhone":"","email":"","facebook":"","address":"","locationName":"","wardName":"","note":"","tenantId":,"branchId":{7},"createdBy":{8},"createdDate":"","isDeleted":false}},"workBy":{{"id":{3},"code":"TLFV6","name":"Linh","isActive":true,"identityNumber":"","mobilePhone":"","email":"","facebook":"","address":"","locationName":"","wardName":"","note":"","tenantId":,"branchId":{7},"createdBy":{8},"createdDate":"","isDeleted":false}},"timeSheet":{{"id":{2},"employeeId":{3},"startDate":"{4}T00:00:00.0000000","endDate":"{14}T23:59:59.0000000","isRepeat":false,"repeatType":1,"repeatEachDay":1,"branchId":{7},"tenantId":,"isDeleted":false,"saveOnDaysOffOfBranch":false,"saveOnHoliday":false,"timeSheetStatus":1,"timeSheetShifts":[{{"id":24230,"shiftIds":"{1}","timeSheetShiftStatus":0,"timeSheetId":{2}}}],"note":"","employee":{{"id":{3},"code":"TLFV6","name":"Linh","isActive":true,"identityNumber":"","mobilePhone":"","email":"","facebook":"","address":"","locationName":"","wardName":"","note":"","tenantId":,"branchId":{7},"createdBy":{8},"createdDate":"","isDeleted":false}}}},"clockingHistories":[],"timeIsLate":0,"overTimeBeforeShiftWork":0,"timeIsLeaveWorkEarly":0,"overTimeAfterShiftWork":0,"clockingPaymentStatus":0}},"ReplacementEmployeeId":null,"ClockingHistory":{{"id":0,"clockingId":{0},"checkedInDate":"{4}T{10}:00.000Z","currentCheckInDate":"{9}","checkedOutDate":"{4}T{11}:00.000Z","currentCheckOutDate":"{15}","branchId":{7},"timeIsLate":0,"overTimeBeforeShiftWork":{12},"timeIsLeaveWorkEarly":0,"overTimeAfterShiftWork":{13},"clockingStatus":1,"timeKeepingType":1,"absenceType":null,"checkInDateType":2,"checkOutDateType":3}},"LeaveOfAbsence":false}}    ${get_clocking_id}      ${get_shift_id}     ${get_timesheet_id}   ${get_employee_id}      ${get_day_checkin}       ${input_gio_vao}      ${input_gio_ra}      ${get_branch_id}        ${get_user_id}    ${get_day_checkin_1}      ${get_check_in}     ${get_check_out}        ${input_di_som}     ${input_ve_muon}    ${get_day_checkout}     ${get_day_checkout_1}
    Log    ${payload}
    ${headers}=    Create Dictionary    Authorization=${bearertoken}    content-type=application/json;charset=UTF-8        branchid=${get_branch_id}     retailer=${RETAILER_NAME}
    Create Session    lolo    ${TIMESHEET_API}        cookies=${resp.cookies}    verify=True    debug=1
    ${resp1}=    Put Request    lolo      ${endpoint_chamcong}    data=${payload}    headers=${headers}
    log    ${resp1.status_code}
    Log    ${resp1.request.body}
    Log    ${resp1.json()}
    Should Be Equal As Strings    ${resp1.status_code}    200

Update not timekeeping to late timekeeping and over time by day thr API
    [Arguments]     ${input_branch}   ${input_day}    ${input_ca_lv}   ${input_ma_nv}    ${time_late}     ${input_ve_muon}   ${get_clocking_id}     ${get_timesheet_id}
    ${input_day1}   Convert Date     ${input_day}    result_format=%Y-%m-%d
    ${input_day2}   Convert Date      ${input_day}     result_format=%d/%m/%Y
    ${get_branch_id}      Get BranchID by BranchName    ${input_branch}
    ${input_gio_vao}    ${input_gio_ra}       Get shift infor thr API     ${input_ca_lv}    ${get_branch_id}
    ${get_check_in}    Subtract Time From Time      ${input_gio_vao}   420   timer   exclude_milles=no
    ${get_check_in}    Add Time To Time      ${get_check_in}   ${time_late}   timer   exclude_milles=no
    ${get_check_in}    Replace string     ${get_check_in}     00:    ${EMPTY}     count=1
    ${get_check_out}    Subtract Time From Time      ${input_gio_ra}   420   timer   exclude_milles=no
    ${get_check_out}    Add Time To Time       ${get_check_out}   ${input_ve_muon}   timer   exclude_milles=no
    ${get_check_out}    Replace String     ${get_check_out}      00:    ${EMPTY}    count=1
    Log    ${input_gio_vao}
    Log    ${input_gio_ra}
    ${get_employee_id}      Get employee id thr API    ${input_ma_nv}
    ${get_shift_id}     Get shift id by branch thr API    ${input_ca_lv}    ${input_branch}
    ${get_user_id}      Get User ID
    ${endpoint_chamcong}      Format String    ${endpoint_chamcong}   ${get_clocking_id}
    ${payload}    Format String    {{"Clocking":{{"id":{0},"shiftId":{1},"timeSheetId":{2},"employeeId":{3},"workById":{3},"clockingStatus":1,"startTime":"{4}T{5}:00.0000000","endTime":"{4}T{6}:00.0000000","branchId":{7},"tenantId":,"isDeleted":false,"employee":{{"id":{3},"code":"TLFV6","name":"Linh","isActive":true,"identityNumber":"","mobilePhone":"","email":"","facebook":"","address":"","locationName":"","wardName":"","note":"","tenantId":,"branchId":{7},"createdBy":{8},"createdDate":"","isDeleted":false}},"workBy":{{"id":{3},"code":"TLFV6","name":"Linh","isActive":true,"identityNumber":"","mobilePhone":"","email":"","facebook":"","address":"","locationName":"","wardName":"","note":"","tenantId":,"branchId":{7},"createdBy":{8},"createdDate":"","isDeleted":false}},"timeSheet":{{"id":{2},"employeeId":{3},"startDate":"{4}T00:00:00.0000000","endDate":"{4}T23:59:59.0000000","isRepeat":false,"repeatType":1,"repeatEachDay":1,"branchId":{7},"tenantId":,"isDeleted":false,"saveOnDaysOffOfBranch":false,"saveOnHoliday":false,"timeSheetStatus":1,"timeSheetShifts":[{{"id":24230,"shiftIds":"{1}","timeSheetShiftStatus":0,"timeSheetId":{2}}}],"note":"","employee":{{"id":{3},"code":"TLFV6","name":"Linh","isActive":true,"identityNumber":"","mobilePhone":"","email":"","facebook":"","address":"","locationName":"","wardName":"","note":"","tenantId":,"branchId":{7},"createdBy":{8},"createdDate":"","isDeleted":false}}}},"clockingHistories":[],"timeIsLate":0,"overTimeBeforeShiftWork":0,"timeIsLeaveWorkEarly":0,"overTimeAfterShiftWork":0,"clockingPaymentStatus":0}},"ReplacementEmployeeId":null,"ClockingHistory":{{"id":0,"clockingId":{0},"checkedInDate":"{4}T{10}:00.000Z","currentCheckInDate":"{9}","checkedOutDate":"{4}T{11}:00.000Z","currentCheckOutDate":"{9}","branchId":{7},"timeIsLate":{12},"overTimeBeforeShiftWork":0,"timeIsLeaveWorkEarly":0,"overTimeAfterShiftWork":{13},"clockingStatus":1,"timeKeepingType":1,"absenceType":null,"checkInDateType":2,"checkOutDateType":2}},"LeaveOfAbsence":false}}   ${get_clocking_id}      ${get_shift_id}     ${get_timesheet_id}   ${get_employee_id}      ${input_day1}       ${input_gio_vao}      ${input_gio_ra}      ${get_branch_id}        ${get_user_id}    ${input_day2}      ${get_check_in}     ${get_check_out}        ${time_late}     ${input_ve_muon}
    Log    ${payload}
    ${headers}=    Create Dictionary    Authorization=${bearertoken}    content-type=application/json;charset=UTF-8        branchid=${get_branch_id}     retailer=${RETAILER_NAME}
    Create Session    lolo    ${TIMESHEET_API}        cookies=${resp.cookies}    verify=True    debug=1
    ${resp1}=    Put Request    lolo      ${endpoint_chamcong}    data=${payload}    headers=${headers}
    log    ${resp1.status_code}
    Log    ${resp1.request.body}
    Log    ${resp1.json()}
    Should Be Equal As Strings    ${resp1.status_code}    200
