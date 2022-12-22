*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    ${headless_browser}
Test Teardown     After Test
Resource         ../../../core/Thiet_lap/thiet_lap_nav.robot
Resource         ../../../core/Thiet_lap/branch_list_page.robot
Resource         ../../../core/Thiet_lap/branch_list_action.robot
Resource         ../../../core/API/api_thietlap.robot
Resource         ../../../core/API/api_access.robot
Resource         ../../../core/share/javascript.robot
Resource         ../../../core/share/toast_message.robot
Resource         ../../../core/Thiet_lap/thiet_lap_nav.robot
Resource         ../../../core/Thiet_lap/khuyenmai_list_page.robot

*** Test Cases ***      Branch name        Phone1         Address                Location                Ward                 Active
Ngung hoat dong       [Tags]   OPT
                      [Template]    unactive_branch
                      Chi nhánh new  0912411111       4C Trần Hưng Đạo     Hà Nội - Quận Hoàn Kiếm      Phường Cửa Nam         false


*** Keywords ***
unactive_branch
    [Arguments]    ${input_name}   ${input_phone}  ${input_address}    ${input_location}    ${input_ward}      ${input_active_branch}
    Set Selenium Speed    1s
    ${get_branch_id}    Get BranchID by BranchName    ${input_name}
    Run Keyword If    '${get_branch_id}' == '0'    Log    Ignore delete     ELSE      Delete Branch    ${get_branch_id}
    Create new branch    ${input_name}    ${input_address}    ${input_location}   ${input_ward}    ${input_phone}
    ${get_current_branch_name}    Get current branch name
    Sleep    2s
    Before Test Quan ly
    Switch Branch    ${get_current_branch_name}    ${input_name}
    ${get_current_branch_name}    Get current branch name
    ${get_retailer_id}    Get RetailerID
    ${get_branch_id}    Get BranchID by BranchName    ${input_name}
    ${data_str}   Format String     {{"Branch":{{"Id":{0},"Name":"ttttt","Type":0,"Address":"234","Province":"Đà Nẵng","District":"Quận Cẩm Lệ","ContactNumber":"0988900231","IsActive":true,"RetailerId":{1},"CreatedBy":172395,"LimitAccess":{2},"LocationName":"Đà Nẵng - Quận Cẩm Lệ","WardName":"Phường Hòa Thọ Đông","isAcceptBookClosing":false,"GmbStatus":1,"Orders":[],"Transfers1":[],"Retailer":{{"CrudGuid":"00000000000000000000000000000000","Id":{1},"CompanyName":"autolive","CompanyAddress":"Shop test - 1B yết Kiêu","Phone":"123456","Code":"autobot","IsActive":true,"IsAdminActive":true,"GroupId":1,"CreatedDate":"2018-06-19T17:13:44.5830000+07:00","ModifiedDate":"2019-12-20T15:41:56.1430000+07:00","ExpiryDate":"2021-01-01T00:00:00.0000000+07:00","UseCustomLogo":false,"Referrer":"https://www.google.com.vn/","Zone":"Miền Nam","CreatedBy":0,"ModifiedBy":65774,"MakeSampleData":false,"LatestClearData":"2019-07-31T01:00:12.8870000+07:00","IndustryId":10,"SignUpType":"Web Site","MaximumProducts":0,"MaximumBranchs":20,"ContractType":2,"LimitKiotMailInMonth":0,"ContractDate":"2018-06-26T00:00:00.0000000+07:00","LocationName":"Hà Nội - Quận Hoàn Kiếm","Province":"Hà Nội","District":"Quận Hoàn Kiếm","WardName":"Phường Trần Hưng Đạo","MaximumFanpages":20,"Branches":[],"Customers":[],"ObjectAccesses":[],"PriceBooks":[],"PropertyAccesses":[],"PurchaseOrders":[],"PurchasePayments":[],"PurchaseReturns":[],"Returns":[],"StockTakes":[],"Suppliers":[],"BankAccounts":[],"EmailMarketings":[],"EmailTemplates":[],"Surcharges":[],"AdrApplications":[],"RewardPointCustomerGroups":[],"SmsEmailTemplates":[],"ProductSerials":[],"NotificationSettings":[],"PartnerDeliveries":[],"ExpensesOthers":[],"SaleChannels":[],"ImportExportFiles":[],"Devices":[],"BatchExpires":[],"WarrantyBranchGroups":[],"OrderSuppliers":[],"PriceBookDependencies":[],"MedicineManufacturers":[],"AddressBooks":[],"BranchTakingAddresses":[],"Patients":[],"DoctorOffices":[],"ShippingTasks":[],"Clinics":[],"Doctors":[],"DoctorQualifications":[],"DoctorSpecialities":[],"Prescriptions":[],"UserDevices":[],"ShippingTaskDetails":[],"ShippingTaskOrderDetails":[],"PayslipPayments":[],"PayslipPaymentAllocations":[]}},"DamageItems":[],"SurchargeBranches":[],"AdrApplications":[],"Customers":[],"Suppliers":[],"ExpensesOtherBranches":[],"OrderSuppliers":[],"WarrantyBranchGroups":[],"BranchTakingAddresses":[],"Patients":[],"Clinics":[],"Doctors":[],"DoctorQualifications":[],"DoctorSpecialities":[],"Prescriptions":[],"PayslipPayments":[],"PayslipPaymentAllocations":[],"IdOld":0,"TotalUser":"0","CompareBranchName":"ttttt","StatusGmbValue":"Chưa đăng ký","TimeSheetBranchSettingWorkingDays":[0,1,2,3,4,5,6],"IsTimeSheetException":false,"Status":"Đang hoạt động","GmbEmailInfo":"Email để quản lý địa điểm này trên Google: <strong>undefined</strong>","PharmacySyncStatus":false}}}}    ${get_branch_id}    ${get_retailer_id}    ${input_active_branch}
    log    ${data_str}
    ${headers1}=    Create Dictionary    Authorization=${bearertoken}    Content-Type=application/json;charset=utf-8
    Create Session    mai    ${API_URL}    cookies=${resp.cookies}
    ${resp3}=    Post Request    mai    /branchs/active    data=${data_str}    headers=${headers1}
    Log    ${resp3.request.body}
    Log    ${resp3.json()}
    log    ${resp3.status_code}
    Should Be Equal As Strings    ${resp3.status_code}    200
    Reload page
    Wait Until Element Is Visible    ${textbox_login_username}
    Wait Until Keyword Succeeds    3 times    30 s    Login    ${USER_NAME}    ${PASSWORD}
    Delete Branch    ${get_branch_id}
