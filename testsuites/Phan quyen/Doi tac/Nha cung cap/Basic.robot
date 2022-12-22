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
Resource          ../../../../core/Doi_Tac/ncc_list_action.robot
Resource          ../../../../core/API/api_nha_cung_cap.robot
Resource          ../../../../core/API/api_danhmuc_hanghoa.robot
Resource          ../../../../core/Ban_Hang/banhang_manager_navigation.robot
Resource          ../../../../core/API/api_access.robot

*** Variables ***

*** Test Cases ***
Xem DS
    [Documentation]     người dùng chỉ có quyền Nhà cung cấp: Xem DS
    [Tags]        PQ4
    [Template]    pqncc1
    userncc1    123       NCC0043

Xem DS + Thêm mới
    [Documentation]     người dùng chỉ có quyền Nhà cung cấp: Xem DS + Thêm mới
    [Tags]        PQ4
    [Template]    pqncc2
    userncc2    123           PQNCC002      Thái       0974872345       1B yết kiêu        none     none         none        none      none       none         none

Xem DS + Cập nhật
    [Documentation]     người dùng chỉ có quyền Nhà cung cấp: Xem DS + Thêm mới + Cập nhật
    [Tags]        PQ4
    [Template]    pqncc3
    userncc3   123      PQNCC003   Hoàng    0973375623     92 Trần Hưng Đạo       none     none         none        none      none      none     none

Xem DS + Xóa
    [Documentation]     người dùng chỉ có quyền Nhà cung cấp: Xem DS + Xóa
    [Tags]        PQ4
    [Template]    pqncc4
    userncc4    123       PQNCC004   Thanh    0941345967

Xem DS + Điện thoại
    [Documentation]     người dùng chỉ có quyền Nhà cung cấp: Xem DS + Điện thoại
    [Tags]        PQ4
    [Template]    pqncc5
    userncc5    123          NCC0043

Xem DS + Điện thoại +Import
    [Documentation]     người dùng chỉ có quyền Nhà cung cấp: Xem DS + Điện thoại +Import
    [Tags]        PQ4
    [Template]    pqncc6
    userncc6    123      C:\\Supplier.xlsx     NCC000001

Xem DS + Xuất file
    [Documentation]     người dùng chỉ có quyền Nhà cung cấp: Xem DS + Xuất file
    [Tags]        PQ4
    [Template]    pqncc7
    userncc7    123

*** Keywords ***
pqncc1
    [Documentation]     người dùng chỉ có quyền Nhà cung cấp: Xem DS
    [Arguments]    ${taikhoan}    ${matkhau}     ${input_ma_ncc}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"Customer_Read":false,"Customer_Import":false,"Clocking_Copy":false,"Customer_Export":false,"Customer_UpdateGroup":false,"Customer_Update":false,"Customer_Create":false,"Customer_Delete":false,"Customer_ViewPhone":false,"Supplier_Read":true}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    #
    Before Test Nha Cung Cap
    Element Should Not Be Visible    ${menu_hh}
    Element Should Not Be Visible    ${menu_giaodich}
    Element Should Not Be Visible    ${domain_soquy}
    Element Should Not Be Visible    ${domain_baocao}
    Element Should Not Be Visible    ${menu_nhanvien}
    Element Should Not Be Visible    ${button_banhang_on_quanly}
    Search supplier        ${input_ma_ncc}
    Element Should Not Be Visible      ${button_active_supplier}      20s
    Element Should Not Be Visible    ${button_update_supplier}
    Element Should Not Be Visible    ${button_delete_supplier}
    Element Should Not Be Visible     ${button_add_new_supplier}
    Delete user    ${get_user_id}

pqncc2
    [Documentation]     người dùng chỉ có quyền Nhà cung cấp: Xem DS + Thêm mới
    [Arguments]    ${taikhoan}    ${matkhau}      ${supplier_code}    ${input_supplier_name}    ${input_supplier_mobile}    ${input_supplier_address}      ${input_supplier_location}       ${input_supplier_ward}       ${input_supplier_email}       ${input_supplier_company}      ${input_supplier_mst}       ${input_supplier_group}      ${input_supplier_note}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_supplier_id}    Get Supplier Id    ${supplier_code}
    Run Keyword If    '${get_supplier_id}' == '0'    Log    Ignore delete     ELSE      Delete supplier    ${get_supplier_id}
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"Customer_Read":false,"Customer_Import":false,"Clocking_Copy":false,"Customer_Export":false,"Customer_UpdateGroup":false,"Customer_Update":false,"Customer_Create":false,"Customer_Delete":false,"Customer_ViewPhone":false,"Supplier_Read":true,"Supplier_Create":true}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    #
    Before Test Nha Cung Cap
    Element Should Not Be Visible    ${menu_hh}
    Element Should Not Be Visible    ${menu_giaodich}
    Element Should Not Be Visible    ${domain_soquy}
    Element Should Not Be Visible    ${domain_baocao}
    Element Should Not Be Visible    ${menu_nhanvien}
    Element Should Not Be Visible    ${button_banhang_on_quanly}
    Wait Until Keyword Succeeds    3 times    3 s    Go to Add new supplier
    Wait until Element is Enabled       ${textbox_supplier_code}         10 s
    Set Focus to element       ${textbox_supplier_code}
    Wait Until Keyword Succeeds    3 times    3 s     Input data       ${textbox_supplier_code}       ${supplier_code}
    Wait Until Keyword Succeeds    3 times    3 s     Input data       ${textbox_supplier_name}       ${input_supplier_name}
    Run Keyword If    '${input_supplier_mobile}' == 'none'    Log     Ignore input      ELSE       Input data       ${textbox_suppliermobile}       ${input_supplier_mobile}
    Run Keyword If    '${input_supplier_address}' == 'none'    Log     Ignore input      ELSE       Input data       ${textbox_supplier_address}       ${input_supplier_address}
    Run Keyword If    '${input_supplier_location}' == 'none'    Log     Ignore input      ELSE       Input data    ${textbox_supplier_location}     ${input_supplier_location}
    Run Keyword If    '${input_supplier_ward}' == 'none'    Log     Ignore input      ELSE       Input data    ${textbox_supplier_ward}    ${input_supplier_ward}
    Run Keyword If    '${input_supplier_group}' == 'none'    Log     Ignore input      ELSE       Input data      ${textbox_supplier_group}      ${input_supplier_group}
    Run Keyword If    '${input_supplier_mst}' == 'none'    Log     Ignore input      ELSE       Input data    ${textbox_supplier_mst}      ${input_supplier_mst}
    Run Keyword If    '${input_supplier_company}' == 'none'    Log     Ignore input      ELSE       Input data    ${textbox_supplier_company}      ${input_supplier_company}
    Run Keyword If    '${input_supplier_email}' == 'none'    Log     Ignore input      ELSE       Input data    ${textbox_supplier_email}      ${input_supplier_email}
    Run Keyword If    '${input_supplier_note}' == 'none'    Log     Ignore input      ELSE       Input data    ${textbox_supplier_note}      ${input_supplier_note}
    Wait Until Element Is Enabled        ${button_supplier_luu}
    Click Element        ${button_supplier_luu}
    Wait Until Page Contains Element    ${toast_message}      50s
    Element Should Contain    ${toast_message}      Thông tin nhà cung cấp được cập nhật thành công
    Sleep          5s
    ${supplier_id}      Get supplier info and validate    ${supplier_code}    ${input_supplier_name}    ${input_supplier_mobile}    ${input_supplier_address}    ${input_supplier_location}    ${input_supplier_ward}    ${input_supplier_email}      ${input_supplier_company}       ${input_supplier_note}
    Delete supplier    ${supplier_id}
    Delete user    ${get_user_id}

pqncc3
    [Documentation]     người dùng chỉ có quyền Nhà cung cấp: Xem DS + Cập nhật
    [Arguments]    ${taikhoan}    ${matkhau}     ${supplier_code}    ${input_supplier_name}    ${input_supplier_mobile}    ${input_supplier_address}      ${input_supplier_location}       ${input_supplier_ward}
    ...       ${input_supplier_email}       ${input_supplier_company}      ${input_supplier_mst}       ${input_supplier_group}      ${input_supplier_note}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_supplier_id}    Get Supplier Id    ${supplier_code}
    Run Keyword If    '${get_supplier_id}' == '0'    Log    Ignore delete     ELSE      Delete supplier    ${get_supplier_id}
    Add supplier    ${supplier_code}    ${input_supplier_name}    ${input_supplier_mobile}
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"Supplier_Read":true,"Supplier_Create":false,"Clocking_Copy":false,"Supplier_Update":true}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    #
    Before Test Nha Cung Cap
    Element Should Not Be Visible    ${menu_hh}
    Element Should Not Be Visible    ${menu_giaodich}
    Element Should Not Be Visible    ${domain_soquy}
    Element Should Not Be Visible    ${domain_baocao}
    Element Should Not Be Visible    ${menu_nhanvien}
    Element Should Not Be Visible    ${button_banhang_on_quanly}
    Wait Until Keyword Succeeds    3 times    3 s    Go to update supplier    ${supplier_code}
    Run Keyword If    '${input_supplier_mobile}' == 'none'    Log     Ignore input      ELSE       Input data       ${textbox_suppliermobile}       ${input_supplier_mobile}
    Run Keyword If    '${input_supplier_address}' == 'none'    Log     Ignore input      ELSE       Input data       ${textbox_supplier_address}       ${input_supplier_address}
    Run Keyword If    '${input_supplier_location}' == 'none'    Log     Ignore input      ELSE       Input data    ${textbox_supplier_location}     ${input_supplier_location}
    Run Keyword If    '${input_supplier_ward}' == 'none'    Log     Ignore input      ELSE       Input data    ${textbox_supplier_ward}    ${input_supplier_ward}
    Run Keyword If    '${input_supplier_mst}' == 'none'    Log     Ignore input      ELSE       Input data    ${textbox_supplier_mst}      ${input_supplier_mst}
    Run Keyword If    '${input_supplier_company}' == 'none'    Log     Ignore input      ELSE       Input data    ${textbox_supplier_company}      ${input_supplier_company}
    Run Keyword If    '${input_supplier_email}' == 'none'    Log     Ignore input      ELSE       Input data    ${textbox_supplier_email}      ${input_supplier_email}
    Wait Until Element Is Enabled        ${button_supplier_luu}
    Click Element        ${button_supplier_luu}
    Wait Until Page Contains Element    ${toast_message}      50s
    Element Should Contain    ${toast_message}      Thông tin nhà cung cấp được cập nhật thành công
    Sleep          3s
    ${supplier_id}      Get supplier info and validate    ${supplier_code}    ${input_supplier_name}    ${input_supplier_mobile}    ${input_supplier_address}
    ...    ${input_supplier_location}    ${input_supplier_ward}    ${input_supplier_email}      ${input_supplier_company}       ${input_supplier_note}
    Delete supplier    ${supplier_id}
    Delete user    ${get_user_id}

pqncc4
    [Documentation]     người dùng chỉ có quyền Nhà cung cấp: Xem DS + Xóa
    [Arguments]    ${taikhoan}    ${matkhau}      ${supplier_code}       ${input_supplier_name}    ${input_supplier_mobile}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_supplier_id}    Get Supplier Id    ${supplier_code}
    Run Keyword If    '${get_supplier_id}' == '0'    Log    Ignore delete     ELSE      Delete supplier    ${get_supplier_id}
    Add supplier    ${supplier_code}    ${input_supplier_name}    ${input_supplier_mobile}
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"Supplier_Read":true,"Supplier_Create":false,"Clocking_Copy":false,"Supplier_Update":false,"Supplier_Delete":true}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    #
    Before Test Nha Cung Cap
    Element Should Not Be Visible    ${menu_hh}
    Element Should Not Be Visible    ${menu_giaodich}
    Element Should Not Be Visible    ${domain_soquy}
    Element Should Not Be Visible    ${domain_baocao}
    Element Should Not Be Visible    ${menu_nhanvien}
    Element Should Not Be Visible    ${button_banhang_on_quanly}
    Wait Until Keyword Succeeds    3 times    3 s    Search supplier    ${supplier_code}
    Sleep    3s
    Wait Until Page Contains Element    ${button_delete_supplier}    2 mins
    Element Should Not Be Visible    ${button_active_supplier}
    Element Should Not Be Visible    ${button_update_supplier}
    Click Element JS    ${button_delete_supplier}
    Wait Until Page Contains Element    ${button_dongy_del_promo}    2 mins
    Click Element JS    ${button_dongy_del_promo}
    Wait Until Page Contains Element    ${toast_message}
    ${msg}    Format String    Xóa nhà cung cấp {0} thành công    ${input_supplier_name}
    Element Should Contain    ${toast_message}    ${msg}
    Delete user    ${get_user_id}

pqncc5
    [Documentation]     người dùng chỉ có quyền Nhà cung cấp: Xem DS + Điện thoại
    [Arguments]    ${taikhoan}    ${matkhau}     ${input_ma_ncc}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"Supplier_Read":true,"Supplier_Create":false,"Clocking_Copy":false,"Supplier_Update":false,"Supplier_Delete":false,"Supplier_MobilePhone":true}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    #
    Before Test Nha Cung Cap
    Element Should Not Be Visible    ${menu_hh}
    Element Should Not Be Visible    ${menu_giaodich}
    Element Should Not Be Visible    ${domain_soquy}
    Element Should Not Be Visible    ${domain_baocao}
    Element Should Not Be Visible    ${menu_nhanvien}
    Element Should Not Be Visible    ${button_banhang_on_quanly}
    Wait Until Page Contains Element    //a[contains(text(),'Điện thoại')]        30s         #cột điện thoại
    Search supplier        ${input_ma_ncc}
    Element Should Not Be Visible      ${button_active_supplier}      20s
    Element Should Not Be Visible    ${button_update_supplier}
    Element Should Not Be Visible    ${button_delete_supplier}
    Wait Until Page Contains Element        //label[contains(text(),'Điện thoại:')]//..//strong       30s
    ${get_text}     Get Text    //label[contains(text(),'Điện thoại:')]//..//strong
    Should Not Be Equal As Strings    ${get_text}    ${EMPTY}
    Delete user    ${get_user_id}

pqncc6
    [Documentation]     người dùng chỉ có quyền Nhà cung cấp: Xem DS + Điện thoại +Import
    [Arguments]    ${taikhoan}    ${matkhau}     ${input_excel_file}       ${input_supplier}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_supplier_id}   Get Supplier Id    ${input_supplier}
    Run Keyword If    '${get_supplier_id}' == '0'    Log     Ignore del     ELSE    Delete supplier    ${get_supplier_id}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"DeliveryAdjustment_Read":false,"PartnerDelivery_Read":false,"PurchasePayment_Create":false,"Clocking_Copy":false,"PurchasePayment_Delete":false,"PurchasePayment_Update":false,"PartnerDelivery_Create":false,"PartnerDelivery_Update":false,"PartnerDelivery_Delete":false,"PartnerDelivery_Import":false,"PartnerDelivery_Export":false,"DeliveryAdjustment_Create":false,"DeliveryAdjustment_Update":false,"DeliveryAdjustment_Delete":false,"Supplier_Read":true,"Supplier_Create":false,"Supplier_MobilePhone":true,"Supplier_Import":true}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}   ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    #
    Before Test Nha Cung Cap
    Element Should Not Be Visible    ${menu_hh}
    Element Should Not Be Visible    ${menu_giaodich}
    Element Should Not Be Visible    ${domain_soquy}
    Element Should Not Be Visible    ${domain_baocao}
    Element Should Not Be Visible    ${menu_nhanvien}
    Element Should Not Be Visible    ${button_banhang_on_quanly}
    Wait Until Keyword Succeeds    3 times    3s    Click Element JS      ${button_import}
    Choose File    ${button_chonfile}    ${input_excel_file}
    Wait Until Element Is Visible    ${button_uploadfile}    2 min
    Wait Until Keyword Succeeds    3 times    3s    Click Element      ${button_uploadfile}
    Wait Until Keyword Succeeds    3 times    3s      Wait Until Element Contains    ${toast_message_import}    Import thành công. Nhấn phím F5 để thấy dữ liệu mới nhất.    2 min
    Delete suplier    ${input_supplier}
    Delete user    ${get_user_id}

pqncc7
    [Documentation]     người dùng chỉ có quyền Nhà cung cấp: Xem DS + Xuất file
    [Arguments]    ${taikhoan}    ${matkhau}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"Supplier_Read":true,"Supplier_Export":true,"Clocking_Copy":false,"Supplier_Import":false,"Supplier_MobilePhone":false}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    #
    Before Test Nha Cung Cap
    Element Should Not Be Visible    ${menu_hh}
    Element Should Not Be Visible    ${menu_giaodich}
    Element Should Not Be Visible    ${domain_soquy}
    Element Should Not Be Visible    ${domain_baocao}
    Element Should Not Be Visible    ${menu_nhanvien}
    Element Should Not Be Visible    ${button_banhang_on_quanly}
    Wait Until Keyword Succeeds    3 times    3s    Click Element JS      ${button_export}
    Wait Until Keyword Succeeds    3 times    3s    Element Should Contain    ${noti_export}    Nhấn vào đây để tải xuống
    Delete user    ${get_user_id}
