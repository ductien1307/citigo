*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    ${headless_browser}
Test Setup
Test Teardown     After Test
Library           Collections
Library           SeleniumLibrary
Resource          ../../../../config/env_product/envi.robot
Resource          ../../../../core/hang_hoa/hang_hoa_navigation.robot
Resource          ../../../../core/share/computation.robot
Resource          ../../../../core/Giao_dich/giaodich_nav.robot
Resource          ../../../../core/API/api_thietlap.robot
Resource          ../../../../core/Doi_Tac/doitac_navigation.robot
Resource          ../../../../core/So_Quy/so_quy_navigation.robot
Resource          ../../../../core/Bao_cao/bao_cao_navigation.robot
Resource          ../../../../core/share/toast_message.robot
Resource          ../../../../prepare/Hang_hoa/Sources/thietlap.robot
Resource          ../../../../prepare/Hang_hoa/Sources/doitac.robot
Resource          ../../../../core/Nhan_vien/nhanvien_navigation.robot
Resource          ../../../../core/Thiet_lap/thiet_lap_nav.robot
Resource          ../../../../core/Doi_Tac/khachhang_list_action.robot
Resource          ../../../../core/API/api_khachhang.robot
Resource          ../../../../core/API/api_danhmuc_hanghoa.robot
Resource          ../../../../core/Ban_Hang/banhang_manager_navigation.robot
Resource          ../../../../core/API/api_access.robot

*** Variables ***

*** Test Cases ***
Xem DS
    [Documentation]     người dùng chỉ có quyền Khách hàng: Xem DS
    [Tags]        PQ4
    [Template]    pqkh1
    userkh1    123       CTKH006

Xem DS + Thêm mới
    [Documentation]     người dùng chỉ có quyền Khách hàng: Xem DS + Thêm mới
    [Tags]        PQ4
    [Template]    pqkh2
    userkh2    123           PQKH001           Cá nhân        Thái       none       none        none        none       none         none          none      none       Nam       none         none       none

Xem DS + Cập nhật
    [Documentation]     người dùng chỉ có quyền Khách hàng: Xem DS + Thêm mới + Cập nhật
    [Tags]        PQ4
    [Template]    pqkh3
    userkh3   123       PQKH002     Hồng    0985658965     15 Trương định    Cá nhân       none      none     none        none          none               none       Nam       none         none       none

Xem DS + Xóa
    [Documentation]     người dùng chỉ có quyền Khách hàng: Xem DS + Xóa
    [Tags]        PQ4
    [Template]    pqkh4
    userkh4    123       PQKH003     Mai    0945628113     15 Trương định

Xem DS + Điện thoại
    [Documentation]     người dùng chỉ có quyền Khách hàng: Xem DS + Điện thoại
    [Tags]        PQ4
    [Template]    pqkh5
    userkh5    123          CTKH006

Xem DS + Import
    [Documentation]     người dùng chỉ có quyền Khách hàng: Xem DS + Import
    [Tags]        PQ4
    [Template]    pqkh6
    userkh6    123      C:\\Customers.xlsx     KH000008

Xem DS + Xuất file
    [Documentation]     người dùng chỉ có quyền Khách hàng: Xem DS + Xuất file
    [Tags]        PQ4
    [Template]    pqkh7
    userkh7    123

Xem DS + Thêm mới + Cập nhật nhóm KH
    [Documentation]     người dùng chỉ có quyền Khách hàng: Xem DS + Thêm mới + Cập nhật nhóm KH
    [Tags]        PQ4
    [Template]    pqkh8
    userkh8    123       PQKH003     Cá nhân        Thái       none       none        none        none       none         Thành viên          none      none       Nam       none         none       none

*** Keywords ***
pqkh1
    [Documentation]     người dùng chỉ có quyền Khách hàng: Xem DS
    [Arguments]    ${taikhoan}    ${matkhau}      ${input_ma_kh}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"PurchaseOrder_Read":false,"PurchaseOrder_Update":false,"PurchaseOrder_Delete":false,"PurchaseOrder_UpdatePurchaseOrder":false,"PurchaseOrder_Export":false,"PurchaseOrder_Clone":false,"Clocking_Copy":false,"PurchaseOrder_Create":false,"Product_Read":false,"Product_Create":false,"Product_Update":false,"Product_Delete":false,"Product_PurchasePrice":false,"Product_Cost":false,"Product_Import":false,"Product_Export":false,"Customer_Read":true}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    #
    Before Test Doi Tac Khach Hang
    Element Should Not Be Visible    ${menu_hh}
    Element Should Not Be Visible    ${menu_giaodich}
    Element Should Not Be Visible    ${domain_soquy}
    Element Should Not Be Visible    ${domain_baocao}
    Element Should Not Be Visible    ${menu_nhanvien}
    Element Should Not Be Visible    ${button_banhang_on_quanly}
    Search customer      ${input_ma_kh}
    Element Should Not Be Visible      ${button_active_customer}      20s
    Element Should Not Be Visible    ${button_update_customer}
    Element Should Not Be Visible    ${button_delete_customer}
    Element Should Not Be Visible    ${button_add_new_customer}
    Delete user    ${get_user_id}

pqkh2
    [Documentation]     người dùng chỉ có quyền Khách hàng: Xem DS + Thêm mới
    [Arguments]    ${taikhoan}    ${matkhau}      ${customer_code}    ${input_customer_type}    ${input_customer_name}    ${input_customer_mobile}    ${input_customer_birthday}    ${input_customer_address}    ${input_customer_location}
    ...    ${input_customer_ward}    ${input_customer_group}    ${input_customer_company}    ${input_customer_mst}    ${input_customer_gender}    ${input_customer_email}
    ...    ${input_customer_facebook}    ${input_customer_note}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_customer_id}    Get customer id thr API    ${customer_code}
    Run Keyword If    '${get_customer_id}' == '0'    Log    Ignore delete     ELSE      Delete customer    ${get_customer_id}
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"OrderSupplier_Read":false,"OrderSupplier_RepeatPrint":false,"Clocking_Copy":false,"OrderSupplier_Create":false,"OrderSupplier_Update":false,"OrderSupplier_Delete":false,"OrderSupplier_Export":false,"OrderSupplier_MakePurchase":false,"OrderSupplier_Clone":false,"Customer_Read":true,"Customer_Create":true}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    #
    Before Test Doi Tac Khach Hang
    Element Should Not Be Visible    ${menu_hh}
    Element Should Not Be Visible    ${menu_giaodich}
    Element Should Not Be Visible    ${domain_soquy}
    Element Should Not Be Visible    ${domain_baocao}
    Element Should Not Be Visible    ${menu_nhanvien}
    Element Should Not Be Visible    ${button_banhang_on_quanly}
    Go to Add new Customer
    Select Customer Type    ${input_customer_type}
    Wait until Element is Enabled       ${textbox_customercode}        10 s
    Set Focus to element       ${textbox_customercode}
    Input Text       ${textbox_customercode}       ${customer_code}
    Input Text       ${textbox_customername}       ${input_customer_name}
    Run Keyword If    '${input_customer_mobile}' == 'none'    Log     Ignore input      ELSE       Input Text       ${textbox_customermobile}       ${input_customer_mobile}
    Run Keyword If    '${input_customer_birthday}' == 'none'    Log     Ignore input      ELSE       Input Text       ${textbox_customer_birthdate}       ${input_customer_birthday}
    Run Keyword If    '${input_customer_address}' == 'none'    Log     Ignore input      ELSE       Input Text       ${textbox_customer_address}       ${input_customer_address}
    Run Keyword If    '${input_customer_location}' == 'none'    Log     Ignore input      ELSE     Input Text    ${textbox_customer_khuvuc}    ${input_customer_location}
    Run Keyword If    '${input_customer_ward}' == 'none'    Log     Ignore input      ELSE         Input Text    ${textbox_customer_phuongxa}    ${input_customer_ward}
    Run Keyword If    '${input_customer_group}' == 'none'    Log     Ignore input      ELSE       Input Text    ${textbox_customer_group}      ${input_customer_group}
    Run Keyword If    '${input_customer_mst}' == 'none'    Log     Ignore input      ELSE       Input Text    ${textbox_customer_mst}      ${input_customer_mst}
    Run Keyword If    '${input_customer_company}' == 'none'    Log     Ignore input      ELSE       Input Text    ${textbox_customer_company}      ${input_customer_company}
    Run Keyword If    '${input_customer_gender}' == 'none'    Log     Ignore input      ELSE       Select Gender    ${input_customer_gender}
    Run Keyword If    '${input_customer_email}' == 'none'    Log     Ignore input      ELSE       Input text    ${textbox_customer_email}      ${input_customer_email}
    Run Keyword If    '${input_customer_facebook}' == 'none'    Log     Ignore input      ELSE       Input text    ${textbox_customer_facebook}      ${input_customer_facebook}
    Run Keyword If    '${input_customer_note}' == 'none'    Log     Ignore input      ELSE       Input text    ${textbox_customer_note}      ${input_customer_note}
    Click Element JS        ${button_customer_luu}
    Wait Until Page Contains Element    ${toast_message}    1 min
    Wait Until Element Contains    ${toast_message}    Thông tin khách hàng được cập nhật thành công
    Sleep     5s
    ${customer_id}      Get Customer info and validate    ${input_customer_type}    ${customer_code}    ${input_customer_name}    ${input_customer_mobile}    ${input_customer_address}    ${input_customer_location}    ${input_customer_ward}    ${input_customer_gender}    ${input_customer_email}      ${input_customer_company}
    Delete customer    ${customer_id}

pqkh3
    [Documentation]     người dùng chỉ có quyền Khách hàng: Xem DS + Cập nhật
    [Arguments]    ${taikhoan}    ${matkhau}      ${customer_code}    ${input_customer_name}    ${input_customer_mobile}    ${input_customer_address}    ${input_customer_type}    ${input_customer_birthday}    ${input_customer_location}
    ...    ${input_customer_ward}    ${input_customer_group}    ${input_customer_company}    ${input_customer_mst}    ${input_customer_gender}    ${input_customer_email}
    ...    ${input_customer_facebook}    ${input_customer_note}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_customer_id}    Get customer id thr API    ${customer_code}
    Run Keyword If    '${get_customer_id}' == '0'    Log    Ignore delete     ELSE      Delete customer    ${get_customer_id}
    Add customers    ${customer_code}    ${input_customer_name}    ${input_customer_mobile}    ${input_customer_address}
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"OrderSupplier_Read":false,"OrderSupplier_RepeatPrint":false,"Clocking_Copy":false,"OrderSupplier_Create":false,"OrderSupplier_Update":false,"OrderSupplier_Delete":false,"OrderSupplier_Export":false,"OrderSupplier_MakePurchase":false,"OrderSupplier_Clone":false,"Customer_Read":true,"Customer_Create":false,"SupplierAdjustment_Read":false,"SupplierAdjustment_Create":false,"SupplierAdjustment_Update":false,"SupplierAdjustment_Delete":false,"Customer_Update":true}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    #
    Before Test Doi Tac Khach Hang
    Element Should Not Be Visible    ${menu_hh}
    Element Should Not Be Visible    ${menu_giaodich}
    Element Should Not Be Visible    ${domain_soquy}
    Element Should Not Be Visible    ${domain_baocao}
    Element Should Not Be Visible    ${menu_nhanvien}
    Element Should Not Be Visible    ${button_banhang_on_quanly}
    Go to update customer    ${customer_code}
    Select Customer Type    ${input_customer_type}
    Run Keyword If    '${input_customer_birthday}' == 'none'    Log     Ignore input      ELSE       Input Text       ${textbox_customer_birthdate}       ${input_customer_birthday}
    Run Keyword If    '${input_customer_location}' == 'none'    Log     Ignore input      ELSE     Input data       ${textbox_customer_khuvuc}    ${input_customer_location}
    Run Keyword If    '${input_customer_ward}' == 'none'    Log     Ignore input      ELSE           Input data       ${textbox_customer_phuongxa}    ${input_customer_ward}
    Run Keyword If    '${input_customer_company}' == 'none'    Log     Ignore input      ELSE       Input Text    ${textbox_customer_company}      ${input_customer_company}
    Run Keyword If    '${input_customer_gender}' == 'none'    Log     Ignore input      ELSE       Select Gender    ${input_customer_gender}
    Click Element        ${button_customer_luu}
    Sleep    2s
    ${customer_id}      Get Customer info and validate    ${input_customer_type}    ${customer_code}    ${input_customer_name}    ${input_customer_mobile}
    ...    ${input_customer_address}    ${input_customer_location}    ${input_customer_ward}    ${input_customer_gender}    ${input_customer_email}      ${input_customer_company}
    Delete customer    ${customer_id}
    Delete user    ${get_user_id}

pqkh4
    [Documentation]     người dùng chỉ có quyền Khách hàng: Xem DS + Xóa
    [Arguments]    ${taikhoan}    ${matkhau}      ${customer_code}    ${input_customer_name}    ${input_customer_mobile}    ${input_customer_address}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_customer_id}    Get customer id thr API    ${customer_code}
    Run Keyword If    '${get_customer_id}' == '0'    Log    Ignore delete     ELSE      Delete customer    ${get_customer_id}
    Add customers    ${customer_code}    ${input_customer_name}    ${input_customer_mobile}    ${input_customer_address}
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"OrderSupplier_Read":false,"OrderSupplier_RepeatPrint":false,"Clocking_Copy":false,"OrderSupplier_Create":false,"OrderSupplier_Update":false,"OrderSupplier_Delete":false,"OrderSupplier_Export":false,"OrderSupplier_MakePurchase":false,"OrderSupplier_Clone":false,"Customer_Read":true,"Customer_Create":false,"SupplierAdjustment_Read":false,"SupplierAdjustment_Create":false,"SupplierAdjustment_Update":false,"SupplierAdjustment_Delete":false,"Customer_Update":false,"Customer_Delete":true}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    #
    Before Test Doi Tac Khach Hang
    Element Should Not Be Visible    ${menu_hh}
    Element Should Not Be Visible    ${menu_giaodich}
    Element Should Not Be Visible    ${domain_soquy}
    Element Should Not Be Visible    ${domain_baocao}
    Element Should Not Be Visible    ${menu_nhanvien}
    Element Should Not Be Visible    ${button_banhang_on_quanly}
    Search customer     ${customer_code}
    Element Should Not Be Visible      ${button_active_customer}      20s
    Element Should Not Be Visible    ${button_update_customer}
    Wait Until Page Contains Element    ${button_delete_customer}    2 mins
    Click Element    ${button_delete_customer}
    Wait Until Page Contains Element    ${button_dongy_del_promo}    2 mins
    Click Element    ${button_dongy_del_promo}
    Wait Until Page Contains Element    ${toast_message}
    ${msg}    Format String    Xóa khách hàng {0} thành công    ${input_customer_name}
    Element Should Contain    ${toast_message}    ${msg}
    Delete user    ${get_user_id}

pqkh5
    [Documentation]     người dùng chỉ có quyền Khách hàng: Xem DS + Điện thoại
    [Arguments]    ${taikhoan}    ${matkhau}      ${input_ma_kh}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"OrderSupplier_Read":false,"OrderSupplier_RepeatPrint":false,"Clocking_Copy":false,"OrderSupplier_Create":false,"OrderSupplier_Update":false,"OrderSupplier_Delete":false,"OrderSupplier_Export":false,"OrderSupplier_MakePurchase":false,"OrderSupplier_Clone":false,"Customer_Read":true,"Customer_Create":false,"SupplierAdjustment_Read":false,"SupplierAdjustment_Create":false,"SupplierAdjustment_Update":false,"SupplierAdjustment_Delete":false,"Customer_Update":false,"Customer_Delete":false,"Customer_ViewPhone":true}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    #
    Before Test Doi Tac Khach Hang
    Element Should Not Be Visible    ${menu_hh}
    Element Should Not Be Visible    ${menu_giaodich}
    Element Should Not Be Visible    ${domain_soquy}
    Element Should Not Be Visible    ${domain_baocao}
    Element Should Not Be Visible    ${menu_nhanvien}
    Element Should Not Be Visible    ${button_banhang_on_quanly}
    Element Should Be Visible    //a[contains(text(),'Điện thoại')]       #cột điện thoại
    Search customer      ${input_ma_kh}
    Element Should Not Be Visible      ${button_active_customer}      20s
    Element Should Not Be Visible    ${button_update_customer}
    Element Should Not Be Visible    ${button_delete_customer}
    Wait Until Page Contains Element        //label[contains(text(),'Điện thoại:')]//..//strong       30s
    ${get_text}     Get Text    //label[contains(text(),'Điện thoại:')]//..//strong
    Should Not Be Equal As Strings    ${get_text}    ${EMPTY}
    Delete user    ${get_user_id}

pqkh6
    [Documentation]     người dùng chỉ có quyền Khách hàng: Xem DS + Import
    [Arguments]    ${taikhoan}    ${matkhau}      ${input_excel_file}    ${input_customer}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_customer_id}   Get customer id thr API    ${input_customer}
    Run Keyword If    '${get_customer_id}' == '0'    Log     Ignore del     ELSE    Delete customer    ${get_customer_id}
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"Customer_Read":true,"Customer_Import":true,"Clocking_Copy":false}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    #
    Before Test Doi Tac Khach Hang
    Element Should Not Be Visible    ${menu_hh}
    Element Should Not Be Visible    ${menu_giaodich}
    Element Should Not Be Visible    ${domain_soquy}
    Element Should Not Be Visible    ${domain_baocao}
    Element Should Not Be Visible    ${menu_nhanvien}
    Element Should Not Be Visible    ${button_banhang_on_quanly}
    Wait Until Keyword Succeeds    3 times    3s    Go to select import or export    ${item_button_import}
    Wait Until Page Contains Element    //button[@class='btn-confirm btn btn-success']      30s
    Click Element    //button[@class='btn-confirm btn btn-success']
    Choose File    ${button_chonfile}    ${input_excel_file}
    Wait Until Element Is Visible    ${button_uploadfile}    2 min
    Wait Until Keyword Succeeds    3 times    3s    Click Element      ${button_uploadfile}
    Wait Until Keyword Succeeds    3x    3s     Wait Until Element Contains    ${toast_message_import}    Import thành công. Nhấn phím F5 để thấy dữ liệu mới nhất.    2 min
    Delete customer by Customer Code       ${input_customer}
    Delete user    ${get_user_id}

pqkh7
    [Documentation]     người dùng chỉ có quyền Khách hàng: Xem DS + Xuất file
    [Arguments]    ${taikhoan}    ${matkhau}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"Customer_Read":true,"Customer_Import":false,"Clocking_Copy":false,"Customer_Export":true}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    #
    Before Test Doi Tac Khach Hang
    Element Should Not Be Visible    ${menu_hh}
    Element Should Not Be Visible    ${menu_giaodich}
    Element Should Not Be Visible    ${domain_soquy}
    Element Should Not Be Visible    ${domain_baocao}
    Element Should Not Be Visible    ${menu_nhanvien}
    Element Should Not Be Visible    ${button_banhang_on_quanly}
    Wait Until Keyword Succeeds    3 times    3s    Go to select import or export    ${item_button_export}
    Wait Until Keyword Succeeds    3 times    3s    Element Should Contain    ${noti_export}    Nhấn vào đây để tải xuống
    Delete user    ${get_user_id}

pqkh8
    [Documentation]     người dùng chỉ có quyền Khách hàng: Xem DS + Thêm mới + Cập nhật nhóm KH
    [Arguments]    ${taikhoan}    ${matkhau}      ${customer_code}    ${input_customer_type}    ${input_customer_name}    ${input_customer_mobile}    ${input_customer_birthday}    ${input_customer_address}    ${input_customer_location}
    ...    ${input_customer_ward}    ${input_customer_group}    ${input_customer_company}    ${input_customer_mst}    ${input_customer_gender}    ${input_customer_email}
    ...    ${input_customer_facebook}    ${input_customer_note}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_customer_id}    Get customer id thr API    ${customer_code}
    Run Keyword If    '${get_customer_id}' == '0'    Log    Ignore delete     ELSE      Delete customer    ${get_customer_id}
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"OrderSupplier_Read":false,"OrderSupplier_RepeatPrint":false,"Clocking_Copy":false,"OrderSupplier_Create":false,"OrderSupplier_Update":false,"OrderSupplier_Delete":false,"OrderSupplier_Export":false,"OrderSupplier_MakePurchase":false,"OrderSupplier_Clone":false,"Customer_Read":true,"Customer_Create":true}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    #
    Before Test Doi Tac Khach Hang
    Element Should Not Be Visible    ${menu_hh}
    Element Should Not Be Visible    ${menu_giaodich}
    Element Should Not Be Visible    ${domain_soquy}
    Element Should Not Be Visible    ${domain_baocao}
    Element Should Not Be Visible    ${menu_nhanvien}
    Element Should Not Be Visible    ${button_banhang_on_quanly}
    Go to Add new Customer
    Select Customer Type    ${input_customer_type}
    Wait until Element is Enabled       ${textbox_customercode}        10 s
    Set Focus to element       ${textbox_customercode}
    Input Text       ${textbox_customercode}       ${customer_code}
    Input Text       ${textbox_customername}       ${input_customer_name}
    Run Keyword If    '${input_customer_mobile}' == 'none'    Log     Ignore input      ELSE       Input Text       ${textbox_customermobile}       ${input_customer_mobile}
    Run Keyword If    '${input_customer_birthday}' == 'none'    Log     Ignore input      ELSE       Input Text       ${textbox_customer_birthdate}       ${input_customer_birthday}
    Run Keyword If    '${input_customer_address}' == 'none'    Log     Ignore input      ELSE       Input Text       ${textbox_customer_address}       ${input_customer_address}
    Run Keyword If    '${input_customer_location}' == 'none'    Log     Ignore input      ELSE     Input data   ${textbox_customer_khuvuc}    ${input_customer_location}
    Run Keyword If    '${input_customer_ward}' == 'none'    Log     Ignore input      ELSE         Input Text    ${textbox_customer_phuongxa}    ${input_customer_ward}
    Run Keyword If    '${input_customer_group}' == 'none'    Log     Ignore input      ELSE       Input Text    ${textbox_customer_group}      ${input_customer_group}
    Run Keyword If    '${input_customer_mst}' == 'none'    Log     Ignore input      ELSE       Input Text    ${textbox_customer_mst}      ${input_customer_mst}
    Run Keyword If    '${input_customer_company}' == 'none'    Log     Ignore input      ELSE       Input Text    ${textbox_customer_company}      ${input_customer_company}
    Run Keyword If    '${input_customer_gender}' == 'none'    Log     Ignore input      ELSE       Select Gender    ${input_customer_gender}
    Run Keyword If    '${input_customer_email}' == 'none'    Log     Ignore input      ELSE       Input text    ${textbox_customer_email}      ${input_customer_email}
    Run Keyword If    '${input_customer_facebook}' == 'none'    Log     Ignore input      ELSE       Input text    ${textbox_customer_facebook}      ${input_customer_facebook}
    Run Keyword If    '${input_customer_note}' == 'none'    Log     Ignore input      ELSE       Input text    ${textbox_customer_note}      ${input_customer_note}
    Click Element JS        ${button_customer_luu}
    Wait Until Page Contains Element    ${toast_message}    1 min
    Wait Until Element Contains    ${toast_message}    Thông tin khách hàng được cập nhật thành công
    Sleep     5s
    ${customer_id}      Get Customer info and validate    ${input_customer_type}    ${customer_code}    ${input_customer_name}    ${input_customer_mobile}    ${input_customer_address}    ${input_customer_location}    ${input_customer_ward}    ${input_customer_gender}    ${input_customer_email}      ${input_customer_company}
    Delete customer    ${customer_id}
