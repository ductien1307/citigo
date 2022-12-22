*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    ${headless_browser}
Test Setup
Test Teardown     After Test
Library           Collections
Library           SeleniumLibrary
Resource          ../../../config/env_product/envi.robot
Resource          ../../../core/hang_hoa/hang_hoa_navigation.robot
Resource          ../../../core/share/computation.robot
Resource          ../../../core/Giao_dich/giaodich_nav.robot
Resource          ../../../core/API/api_thietlap.robot
Resource          ../../../core/Doi_Tac/doitac_navigation.robot
Resource          ../../../core/So_Quy/so_quy_navigation.robot
Resource          ../../../core/Bao_cao/bao_cao_navigation.robot
Resource          ../../../core/share/toast_message.robot
Resource          ../../../prepare/Hang_hoa/Sources/thietlap.robot
Resource          ../../../core/Nhan_vien/nhanvien_navigation.robot
Resource          ../../../core/Thiet_lap/thiet_lap_nav.robot
Resource          ../../../core/Thiet_lap/branch_list_action.robot
Resource          ../../../core/Hang_hoa/kiemkho_list_action.robot
Resource          ../../../core/API/api_kiemkho.robot
Resource          ../../../core/Ban_Hang/banhang_manager_navigation.robot

*** Variables ***
&{dict_kk}    TPG01=100

*** Test Cases ***
Xem DS
    [Documentation]     người dùng chỉ có quyền Kiểm kho: Xem DS
    [Tags]       PQ2
    [Template]    pqkk1
    userkk1    123

Xem DS + Thêm mới
    [Documentation]     người dùng chỉ có quyền Kiểm kho: Xem DS + Thêm mới
    [Tags]      PQ2
    [Template]    pqkk2
    userkk2    123       TPG01

Xem DS + Xóa
    [Documentation]     người dùng chỉ có quyền  Kiểm kho: Xem DS + Xóa
    [Tags]      PQ2
    [Template]    pqkk3
    userkk4    123    ${dict_kk}

Xem DS + Xuất file
    [Documentation]     người dùng chỉ có quyền  Kiểm kho: Xem DS + Xuất file
    [Tags]      PQ2
    [Template]    pqkk4
    userkk5   123       ${dict_kk}

Xem DS + Tồn kho
    [Documentation]     người dùng chỉ có quyền  Kiểm kho: Xem DS + Tồn kho
    [Tags]      PQ2
    [Template]    pqkk5
    userkk5   123       ${dict_kk}

Xem DS + Thêm mới + Sao chép
    [Documentation]     người dùng chỉ có quyền  Kiểm kho: Xem DS + Thêm mới + Sao chép
    [Tags]      PQ2
    [Template]    pqkk6
    userkk5   123       ${dict_kk}

Xem DS + Thêm mới + Hoàn thành
    [Documentation]     người dùng chỉ có quyền  Kiểm kho: Xem DS + Thêm mới Hoàn thành
    [Tags]     PQ2
    [Template]    pqkk7
    userkk5   123       TPG01

*** Keywords ***
pqkk1
    [Documentation]     người dùng chỉ có quyền Kiểm kho Xem DS
    [Arguments]    ${taikhoan}    ${matkhau}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"PriceBook_Read":false,"PriceBook_Import":false,"Clocking_Copy":false,"PriceBook_Export":false,"PriceBook_Create":false,"PriceBook_Update":false,"PriceBook_Delete":false,"StockTake_Read":true}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    #
    Before Test Kiem Kho
    Element Should Not Be Visible    ${menu_giaodich}
    Element Should Not Be Visible    ${menu_doitac}
    Element Should Not Be Visible    ${domain_soquy}
    Element Should Not Be Visible    ${domain_baocao}
    Element Should Not Be Visible    ${button_banhang_on_quanly}
    Element Should Not Be Visible    ${button_kiemkho}
    Element Should Not Be Visible    ${button_export}
    Delete user    ${get_user_id}

pqkk2
    [Documentation]     người dùng chỉ có quyền Kiểm kho Xem DS + Thêm mới
    [Arguments]    ${taikhoan}    ${matkhau}    ${input_ma_sp}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"StockTake_Read":true,"Clocking_Copy":false,"StockTake_Create":true}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    #
    Before Test Kiem Kho
    Element Should Not Be Visible    ${menu_giaodich}
    Element Should Not Be Visible    ${menu_doitac}
    Element Should Not Be Visible    ${domain_soquy}
    Element Should Not Be Visible    ${domain_baocao}
    Element Should Not Be Visible    ${button_banhang_on_quanly}
    Element Should Not Be Visible    ${button_export}
    #
    ${ma_phieukiem}    Generate code automatically    PKK
    Wait Until Keyword Succeeds    3 times    2s    Go to Inventory form
    Wait Until Keyword Succeeds    3 times    1s    Input data in textbox and wait until it is visible    ${textbox_search_ma_hh}    ${input_ma_sp}    ${item_first_product_dropdownlist}
    ...    ${cell_first_product_code}
    Input inventory counting code    ${ma_phieukiem}
    Element Should Not Be Visible    ${button_hoanthanh_kk}
    Click Element    ${button_luutam_kk}
    Update data success validation
    Delete Inventory code in Inventory Counting List    ${ma_phieukiem}
    Delete user    ${get_user_id}

pqkk3
    [Documentation]     người dùng chỉ có quyền Kiểm kho Xem DS + Xóa
    [Arguments]    ${taikhoan}    ${matkhau}    ${dict_product_nums}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"StockTake_Read":true,"StockTake_Create":false,"Clocking_Copy":false,"StockTake_Delete":true}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    #
    Before Test Kiem Kho
    Element Should Not Be Visible    ${menu_giaodich}
    Element Should Not Be Visible    ${menu_doitac}
    Element Should Not Be Visible    ${domain_soquy}
    Element Should Not Be Visible    ${domain_baocao}
    Element Should Not Be Visible    ${button_banhang_on_quanly}
    Element Should Not Be Visible    ${button_export}
    #
    ${get_ma_kk}      Add new inventory frm api    ${dict_product_nums}
    Reload Page
    Element Should Not Be Visible    ${button_kiemkho}
    Input data        ${textbox_search_maphieukiem}      ${get_ma_kk}
    Wait Until Page Contains Element    ${button_huy_phieukiem}
    Element Should Not Be Visible    ${button_luu_phieukiem}
    Element Should Be Visible    ${button_xuatfile_phieukiem}
    Element Should Not Be Visible    ${button_saochep_phieukiem}
    Element Should Be Visible    ${button_in_phieukiem}
    Click Element    ${button_huy_phieukiem}
    Wait Until Page Contains Element    ${button_dongy_huy_phieukiem}
    Click Element    ${button_dongy_huy_phieukiem}
    Wait Until Page Contains Element    ${toast_message}    2 min
    Element Should Contain    ${toast_message}    Hủy phiếu kiểm kho: ${get_ma_kk} thành công
    Delete user    ${get_user_id}

pqkk4
    [Documentation]     người dùng chỉ có quyền Kiểm kho Xem DS + Xuất file
    [Arguments]    ${taikhoan}    ${matkhau}    ${dict_product_nums}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"StockTake_Read":true,"StockTake_Create":false,"Clocking_Copy":false,"StockTake_Delete":false,"StockTake_Export":true}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    #
    Before Test Kiem Kho
    Element Should Not Be Visible    ${menu_giaodich}
    Element Should Not Be Visible    ${menu_doitac}
    Element Should Not Be Visible    ${domain_soquy}
    Element Should Not Be Visible    ${domain_baocao}
    Element Should Not Be Visible    ${button_banhang_on_quanly}
    Element Should Be Visible        ${button_export}
    #
    ${get_ma_kk}      Add new inventory frm api    ${dict_product_nums}
    Reload Page
    Input data        ${textbox_search_maphieukiem}      ${get_ma_kk}
    Wait Until Page Contains Element    ${button_xuatfile_phieukiem}
    Element Should Not Be Visible    ${button_luu_phieukiem}
    Element Should Not Be Visible    ${button_saochep_phieukiem}
    Element Should Be Visible    ${button_in_phieukiem}
    Element Should Not Be Visible    ${button_huy_phieukiem}
    Element Should Not Be Visible    ${button_kiemkho}
    Click Element    ${button_xuatfile_phieukiem}
    Wait Until Keyword Succeeds    3 times    3s    Element Should Contain    ${noti_export}    Nhấn vào đây để tải xuống
    Delete Inventory code in Inventory Counting List    ${get_ma_kk}
    Delete user    ${get_user_id}

pqkk5
    [Documentation]     người dùng chỉ có quyền Kiểm kho Xem DS + Tồn kho
    [Arguments]    ${taikhoan}    ${matkhau}    ${dict_product_nums}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"StockTake_Read":true,"StockTake_Create":false,"Clocking_Copy":false,"StockTake_Delete":false,"StockTake_Export":false,"StockTake_Inventory":true}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    #
    Before Test Kiem Kho
    Element Should Not Be Visible    ${menu_giaodich}
    Element Should Not Be Visible    ${menu_doitac}
    Element Should Not Be Visible    ${domain_soquy}
    Element Should Not Be Visible    ${domain_baocao}
    Element Should Not Be Visible    ${button_banhang_on_quanly}
    Element Should Not Be Visible       ${button_export}
    #
    ${get_ma_kk}      Add new inventory frm api    ${dict_product_nums}
    Reload Page
    Input data        ${textbox_search_maphieukiem}      ${get_ma_kk}
    Wait Until Page Contains Element    ${button_xuatfile_phieukiem}
    Element Should Not Be Visible    ${button_luu_phieukiem}
    Element Should Not Be Visible    ${button_saochep_phieukiem}
    Element Should Be Visible         ${button_in_phieukiem}
    Element Should Not Be Visible    ${button_huy_phieukiem}
    Element Should Not Be Visible    ${button_kiemkho}
    Element Should Be Visible    //th[text()='Tồn kho']
    Delete Inventory code in Inventory Counting List    ${get_ma_kk}
    Delete user    ${get_user_id}

pqkk6
    [Documentation]     người dùng chỉ có quyền Kiểm kho Xem DS + Thêm mới + Sao chép
    [Arguments]    ${taikhoan}    ${matkhau}    ${dict_product_nums}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"StockTake_Read":true,"StockTake_Create":true,"Clocking_Copy":false,"StockTake_Delete":false,"StockTake_Export":false,"StockTake_Inventory":false,"StockTake_Clone":true}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    #
    Before Test Kiem Kho
    Element Should Not Be Visible    ${menu_giaodich}
    Element Should Not Be Visible    ${menu_doitac}
    Element Should Not Be Visible    ${domain_soquy}
    Element Should Not Be Visible    ${domain_baocao}
    Element Should Not Be Visible    ${button_banhang_on_quanly}
    Element Should Not Be Visible       ${button_export}
    #
    ${get_ma_kk}      Add new inventory frm api    ${dict_product_nums}
    Reload Page
    Input data        ${textbox_search_maphieukiem}      ${get_ma_kk}
    Wait Until Page Contains Element    ${button_xuatfile_phieukiem}
    Element Should Be Visible    ${button_luu_phieukiem}
    Element Should Be Visible         ${button_in_phieukiem}
    Element Should Not Be Visible    ${button_huy_phieukiem}
    Element Should Be Visible    ${button_kiemkho}
    Click Element        ${button_saochep_phieukiem}
    ${get_inventory_count_id}   Get Inventory code id thr API    ${get_ma_kk}
    ${url_sc}       Set Variable        ${URL}/#/StockTakes/${get_inventory_count_id}?type=clone
    Wait Until Keyword Succeeds    3 times    2s    Select Window   url=${url_sc}
    Wait Until Page Contains Element    ${button_luutam_kk}     20s
    Click Element    ${button_luutam_kk}
    Update data success validation
    Delete Inventory code in Inventory Counting List    ${get_ma_kk}
    Delete user    ${get_user_id}

pqkk7
    [Documentation]     người dùng chỉ có quyền Kiểm kho Xem DS + Thêm mới + Hoàn thành
    [Arguments]    ${taikhoan}    ${matkhau}     ${input_ma_sp}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"StockTake_Read":true,"StockTake_Create":true,"Clocking_Copy":false,"StockTake_Delete":false,"StockTake_Export":false,"StockTake_Inventory":false,"StockTake_Clone":false,"StockTake_Finish":true}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    #
    Before Test Kiem Kho
    Element Should Not Be Visible    ${menu_giaodich}
    Element Should Not Be Visible    ${menu_doitac}
    Element Should Not Be Visible    ${domain_soquy}
    Element Should Not Be Visible    ${domain_baocao}
    Element Should Not Be Visible    ${button_banhang_on_quanly}
    Element Should Not Be Visible    ${button_export}
    #
    ${ma_phieukiem}    Generate code automatically    PKK
    Wait Until Keyword Succeeds    3 times    2s    Go to Inventory form
    Wait Until Keyword Succeeds    3 times    1s    Input data in textbox and wait until it is visible    ${textbox_search_ma_hh}    ${input_ma_sp}    ${item_first_product_dropdownlist}
    ...    ${cell_first_product_code}
    Input inventory counting code    ${ma_phieukiem}
    Click Element    ${button_hoanthanh_kk}
    Click Agree button on inventory balancing popup
    Update data success validation
    Delete Inventory code in Inventory Counting List    ${ma_phieukiem}
    Delete user    ${get_user_id}
