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
Resource          ../../../../core/Nhan_vien/nhanvien_navigation.robot
Resource          ../../../../core/Thiet_lap/thiet_lap_nav.robot
Resource          ../../../../core/Ban_Hang/chuyenhang_form_page.robot
Resource          ../../../../core/Giao_dich/chuyenhang_page_action.robot
Resource          ../../../../core/API/api_chuyenhang.robot
Resource          ../../../../core/API/api_danhmuc_hanghoa.robot
Resource          ../../../../core/Ban_Hang/banhang_manager_navigation.robot
Resource          ../../../../core/API/api_access.robot

*** Variables ***
&{dict_ch}     TPG12=1
${excel_file}      C:\\Transform.xlsx

*** Test Cases ***
Xem DS
    [Documentation]     người dùng chỉ có quyền Chuyển hàng: Xem DS
    [Tags]      PQ3
    [Template]    pqch1
    userch1    123       ${dict_ch}     Nhánh A

Xem DS + Thêm mới
    [Documentation]     người dùng chỉ có quyền Chuyển hàng: Xem DS + Thêm mới
    [Tags]      PQ3
    [Template]    pqch2
    userch2    123         TPG12      Nhánh A

Xem DS + Thêm mới + Cập nhật
    [Documentation]     người dùng chỉ có quyền Chuyển hàng: Xem DS + Thêm mới + Cập nhật ở cả 2 CN
    [Tags]      PQ3
    [Template]    pqch3
    userch3   123         ${dict_ch}     Nhánh A

Xem DS + Xóa
    [Documentation]     người dùng chỉ có quyền Chuyển hàng: Xem DS + Xóa
    [Tags]      PQ3
    [Template]    pqch4
    userch4    123        ${dict_ch}     Nhánh A

Xem DS + Xuất file
    [Documentation]     người dùng chỉ có quyền Chuyển hàng: Xem DS + Xuất file
    [Tags]      PQ3
    [Template]    pqch5
    userch5    123        ${dict_ch}     Nhánh A

Xem DS + Thêm mới + Sao chép
    [Documentation]     người dùng chỉ có quyền Chuyển hàng: Xem DS + Thêm mới + Sao chép
    [Tags]      PQ3
    [Template]    pqch6
    userch6    123         ${dict_ch}     Nhánh A

Xem DS + Thêm mới + Import
    [Documentation]     người dùng chỉ có quyền Chuyển hàng: Xem DS + Thêm mới + Import
    [Tags]      PQ3
    [Template]    pqch7
    userch7    123         ${excel_file}

*** Keywords ***
pqch1
    [Documentation]     người dùng chỉ có quyền Chuyển hàng: Xem DS
    [Arguments]    ${taikhoan}    ${matkhau}      ${dict_product_num}   ${input_branchname}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"PurchaseOrder_Read":false,"PurchaseOrder_Create":false,"PurchaseOrder_Clone":false,"Clocking_Copy":false,"PurchaseOrder_Update":false,"PurchaseOrder_Delete":false,"PurchaseOrder_UpdatePurchaseOrder":false,"PurchaseOrder_Export":false,"PurchaseReturn_Read":false,"PurchaseReturn_Create":false,"PurchaseReturn_Update":false,"PurchaseReturn_Clone":false,"PurchaseReturn_Delete":false,"Transfer_Read":true}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    #
    ${get_ma_phieu}  ${list_result_transferring_onhand}    ${list_result_received_onhand}    Add new transform frm API    Chi nhánh trung tâm    ${input_branchname}    ${dict_product_num}
    Before Test Inventory Transfer
    Element Should Not Be Visible    ${menu_hh}
    Element Should Not Be Visible    ${menu_doitac}
    Element Should Not Be Visible    ${domain_soquy}
    Element Should Not Be Visible    ${domain_baocao}
    Element Should Not Be Visible    ${menu_nhanvien}
    Element Should Not Be Visible    ${button_banhang_on_quanly}
    Element Should Not Be Visible    ${button_export_invoice}
    Element Should Not Be Visible    ${button_chuyenhang}
    Element Should Not Be Visible    ${button_import}
    Search transform code code    ${get_ma_phieu}
    Element Should Not Be Visible      ${button_save_trans}
    Element Should Not Be Visible    ${button_copy_trans}
    Element Should Not Be Visible    ${button_cancel_transferring}
    Delete Transform code    ${get_ma_phieu}
    Delete user    ${get_user_id}

pqch2
    [Documentation]     người dùng chỉ có quyền Chuyển hàng: Xem DS + Thêm mới
    [Arguments]    ${taikhoan}    ${matkhau}    ${input_product_code}     ${input_branchname}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"PurchaseOrder_Read":false,"PurchaseOrder_Create":false,"PurchaseOrder_Clone":false,"Clocking_Copy":false,"PurchaseOrder_Update":false,"PurchaseOrder_Delete":false,"PurchaseOrder_UpdatePurchaseOrder":false,"PurchaseOrder_Export":false,"PurchaseReturn_Read":false,"PurchaseReturn_Create":false,"PurchaseReturn_Update":false,"PurchaseReturn_Clone":false,"PurchaseReturn_Delete":false,"Transfer_Read":true,"Transfer_Create":true}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    #
    Before Test Inventory Transfer
    Element Should Not Be Visible    ${menu_hh}
    Element Should Not Be Visible    ${menu_doitac}
    Element Should Not Be Visible    ${domain_soquy}
    Element Should Not Be Visible    ${domain_baocao}
    Element Should Not Be Visible    ${menu_nhanvien}
    Element Should Not Be Visible    ${button_banhang_on_quanly}
    Element Should Not Be Visible    ${button_export_invoice}
    Element Should Not Be Visible    ${button_import}
    Wait Until Keyword Succeeds    3 times    2s    Go To Inventory Transfer form
    ${ma_phieuchuyen}    Generate code automatically    PCH
    ${get_current_branch_name}    Get current branch name
    Select Branch on Inventory Transfer form    ${input_branchname}
    Wait Until Keyword Succeeds    3 times    2s    Input data in textbox and wait until it is visible    ${textbox_chuyenhang_search_product}    ${input_product_code}    ${item_ch_first_product_dropdownlist_search}
    ...    ${cell_first_product_code}
    Input inventory transfer code    ${ma_phieuchuyen}
    Click Element    ${button_ch_hoanthanh}
    Wait Until Page Contains Element    ${toast_message}      1 min
    Wait Until Keyword Succeeds    3 times   1s   Element Should Contain    ${toast_message}      Cập nhật phiếu chuyển hàng thành công
    Delete user    ${get_user_id}
    Delete Transform code    ${ma_phieuchuyen}

pqch3
    [Documentation]     người dùng chỉ có quyền Chuyển hàng: Xem DS + Thêm mới + Cập nhật ở 2 CN
    [Arguments]    ${taikhoan}    ${matkhau}    ${dict_product_num}     ${input_branchname}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${get_branchid}     Get BranchID by BranchName    ${input_branchname}
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"Transfer_Read":true,"Transfer_Update":true,"Clocking_Copy":false,"Transfer_Create":true}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
    ${payload1}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"Transfer_Read":true,"Transfer_Update":true,"Clocking_Copy":false,"Transfer_Create":true}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${get_branchid}    ${get_role_id}        ${taikhoan}
    Log    ${payload}
    Log    ${payload1}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload1}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    #
    ${get_ma_phieu}  ${list_result_transferring_onhand}    ${list_result_received_onhand}    Add new transform frm API    Chi nhánh trung tâm    ${input_branchname}    ${dict_product_num}
    Before Test Inventory Transfer
    Element Should Not Be Visible    ${menu_hh}
    Element Should Not Be Visible    ${menu_doitac}
    Element Should Not Be Visible    ${domain_soquy}
    Element Should Not Be Visible    ${domain_baocao}
    Element Should Not Be Visible    ${menu_nhanvien}
    Element Should Not Be Visible    ${button_banhang_on_quanly}
    Element Should Not Be Visible    ${button_export_invoice}
    Element Should Not Be Visible    ${button_import}
    Search transform code code    ${get_ma_phieu}
    Wait Until Page Contains Element      ${button_save_trans}      20s
    Element Should Not Be Visible    ${button_copy_trans}
    Element Should Not Be Visible    ${button_cancel_transferring}
    Click Element    ${button_save_trans}
    Wait Until Page Contains Element    ${toast_message}      1 min
    Wait Until Keyword Succeeds    3 times   1s   Element Should Contain    ${toast_message}      Cập nhật phiếu chuyển hàng thành công
    Delete user    ${get_user_id}
    Delete Transform code    ${get_ma_phieu}

pqch4
    [Documentation]     người dùng chỉ có quyền Chuyển hàng: Xem DS + Xóa
    [Arguments]    ${taikhoan}    ${matkhau}    ${dict_product_num}     ${input_branchname}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"Transfer_Read":true,"Transfer_Create":false,"Transfer_Update":false,"Clocking_Copy":false,"Transfer_Delete":true}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    #
    ${get_ma_phieu}  ${list_result_transferring_onhand}    ${list_result_received_onhand}    Add new transform frm API    Chi nhánh trung tâm    ${input_branchname}    ${dict_product_num}
    Before Test Inventory Transfer
    Element Should Not Be Visible    ${menu_hh}
    Element Should Not Be Visible    ${menu_doitac}
    Element Should Not Be Visible    ${domain_soquy}
    Element Should Not Be Visible    ${domain_baocao}
    Element Should Not Be Visible    ${menu_nhanvien}
    Element Should Not Be Visible    ${button_banhang_on_quanly}
    Element Should Not Be Visible    ${button_export_invoice}
    Element Should Not Be Visible    ${button_import}
    Search transform code code    ${get_ma_phieu}
    Wait Until Page Contains Element      ${button_cancel_transferring}      20s
    Element Should Not Be Visible    ${button_copy_trans}
    Element Should Not Be Visible    ${button_save_trans}
    Wait Until Keyword Succeeds    3 times    1s    Click button cancel transferring
    Wait Until Keyword Succeeds    3 times    1s    Confirm Action Cancel
    Wait Until Page Contains Element    ${toast_message}      1 min
    Wait Until Keyword Succeeds    3 times   1s   Element Should Contain    ${toast_message}      Hủy phiếu chuyển hàng: ${get_ma_phieu} thành công
    Delete user    ${get_user_id}

pqch5
    [Documentation]     người dùng chỉ có quyền Chuyển hàng: Xem DS + Xuất file
    [Arguments]    ${taikhoan}    ${matkhau}    ${dict_product_num}     ${input_branchname}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"Transfer_Read":true,"Transfer_Create":false,"Transfer_Update":false,"Clocking_Copy":false,"Transfer_Delete":false,"Transfer_Export":true}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    #
    ${get_ma_phieu}  ${list_result_transferring_onhand}    ${list_result_received_onhand}    Add new transform frm API    Chi nhánh trung tâm    ${input_branchname}    ${dict_product_num}
    Before Test Inventory Transfer
    Element Should Not Be Visible    ${menu_hh}
    Element Should Not Be Visible    ${menu_doitac}
    Element Should Not Be Visible    ${domain_soquy}
    Element Should Not Be Visible    ${domain_baocao}
    Element Should Not Be Visible    ${menu_nhanvien}
    Element Should Not Be Visible    ${button_banhang_on_quanly}
    Element Should Not Be Visible    ${button_import}
    Search transform code code    ${get_ma_phieu}
    Wait Until Keyword Succeeds    3 times    3s     Go to select export file    ${cell_item_export_tongquan}    ${get_ma_phieu}
    Wait Until Keyword Succeeds    3 times    3s    Element Should Contain    ${noti_export}    Nhấn vào đây để tải xuống
    Delete user    ${get_user_id}
    Delete Transform code    ${get_ma_phieu}

pqch6
    [Documentation]     người dùng chỉ có quyền Chuyển hàng: Xem DS + Thêm mới + Sao chép
    [Arguments]    ${taikhoan}    ${matkhau}    ${dict_product_num}     ${input_branchname}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"Transfer_Read":true,"Transfer_Create":true,"Transfer_Update":false,"Clocking_Copy":false,"Transfer_Delete":false,"Transfer_Export":false,"Transfer_Clone":true}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    #
    ${get_ma_phieu}  ${list_result_transferring_onhand}    ${list_result_received_onhand}    Add new transform frm API    Chi nhánh trung tâm    ${input_branchname}    ${dict_product_num}
    Before Test Inventory Transfer
    Element Should Not Be Visible    ${menu_hh}
    Element Should Not Be Visible    ${menu_doitac}
    Element Should Not Be Visible    ${domain_soquy}
    Element Should Not Be Visible    ${domain_baocao}
    Element Should Not Be Visible    ${menu_nhanvien}
    Element Should Not Be Visible    ${button_banhang_on_quanly}
    Element Should Not Be Visible    ${button_export_invoice}
    Element Should Not Be Visible    ${button_import}
    #
    Search transform code code    ${get_ma_phieu}
    Wait Until Page Contains Element      ${button_copy_trans}      20s
    Element Should Not Be Visible    ${button_cancel_transferring}
    Element Should Not Be Visible    ${button_save_trans}
    ${get_id_phieu}   Get transform id frm api      ${get_ma_phieu}
    ${url_sc}       Set Variable        ${URL}/#/Transfers/Copy_${get_id_phieu}
    Click Element    ${button_copy_trans}
    Wait Until Keyword Succeeds    3 times    2s    Select Window   url=${url_sc}
    Wait Until Page Contains Element    ${button_ch_hoanthanh}     20s
    Click Element    ${button_ch_hoanthanh}
    Wait Until Page Contains Element    ${toast_message}      1 min
    Wait Until Keyword Succeeds    3 times   1s   Element Should Contain    ${toast_message}      Cập nhật phiếu chuyển hàng thành công
    Delete user    ${get_user_id}
    Delete Transform code    ${get_ma_phieu}.01

pqch7
    [Documentation]     người dùng chỉ có quyền Chuyển hàng: Xem DS + Thêm mới + Import
    [Arguments]    ${taikhoan}    ${matkhau}      ${input_excel_file}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"Transfer_Read":true,"Transfer_Create":true,"Transfer_Clone":false,"Clocking_Copy":false,"Transfer_Import":true,"Transfer_Update":false,"Transfer_Delete":false,"Transfer_Export":false}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    #
    Before Test Inventory Transfer
    Element Should Not Be Visible    ${menu_hh}
    Element Should Not Be Visible    ${menu_doitac}
    Element Should Not Be Visible    ${domain_soquy}
    Element Should Not Be Visible    ${domain_baocao}
    Element Should Not Be Visible    ${menu_nhanvien}
    Element Should Not Be Visible    ${button_banhang_on_quanly}
    Element Should Not Be Visible    ${button_export_invoice}
    #
    Wait Until Page Contains Element    ${button_import}      30s
    Wait Until Keyword Succeeds    3 times    1s    Click Element JS      ${button_import}
    Choose File    ${button_chonfile}    ${input_excel_file}
    Wait Until Element Is Visible    ${button_uploadfile}    2 min
    Wait Until Keyword Succeeds    3 times    1s    Click Element      ${button_uploadfile}
    Wait Until Keyword Succeeds    3 times    3s    Element Should Contain       ${toast_message_import}    Import thành công. Nhấn phím F5 để thấy dữ liệu mới nhất.
    Delete user    ${get_user_id}
