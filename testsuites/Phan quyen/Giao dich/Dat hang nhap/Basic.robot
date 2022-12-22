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
Resource          ../../../../core/Giao_dich/dat_hang_nhap_list_action.robot
Resource          ../../../../core/Giao_dich/dat_hang_nhap_add_action.robot
Resource          ../../../../core/API/api_dathangnhap.robot
Resource          ../../../../core/Ban_Hang/banhang_manager_navigation.robot

*** Variables ***
&{dict_dhn}     TPG02=1

*** Test Cases ***
Xem DS
    [Documentation]     người dùng chỉ có quyền Đặt hàng nhập: Xem DS
    [Tags]      PQ3
    [Template]    pqdhn1
    userdhn1    123      ${dict_dhn}

Xem DS + Thêm mới
    [Documentation]     người dùng chỉ có quyền Đặt hàng nhập: Xem DS + Thêm mới, Hàng hóa: Xem DS
    [Tags]      PQ3
    [Template]    pqdhn2
    userdhn2    123       TPG02

Xem DS + Cập nhật
    [Documentation]     người dùng chỉ có quyền Đặt hàng nhập: Xem DS + Cập nhật
    [Tags]      PQ3
    [Template]    pqdhn3
    userdhn3    123       ${dict_dhn}

Xem DS + Xóa
    [Documentation]     người dùng chỉ có quyền  Đặt hàng nhập: Xem DS + Xóa
    [Tags]      PQ3
    [Template]    pqdhn4
    userdhn4    123    ${dict_dhn}

Xem DS + IN lại
    [Documentation]     người dùng chỉ có quyền  Đặt hàng nhập: Xem DS + In lại
    [Tags]    PQ3
    [Template]    pqdhn5
    userdhn5    123    ${dict_dhn}

*** Keywords ***
pqdhn1
    [Documentation]     người dùng chỉ có quyền Đặt hàng nhập: Xem DS
    [Arguments]    ${taikhoan}    ${matkhau}      ${dict_product_num}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"Manufacturing_Read":false,"Product_Read":false,"Manufacturing_Export":false,"Clocking_Copy":false,"Product_Create":false,"Product_Update":false,"Product_Delete":false,"Product_PurchasePrice":false,"Product_Cost":false,"Product_Import":false,"Product_Export":false,"Manufacturing_Create":false,"Manufacturing_Update":false,"Manufacturing_Delete":false,"StockTake_Read":false,"StockTake_Create":false,"StockTake_Delete":false,"OrderSupplier_Read":true,"OrderSupplier_Create":false,"StockTake_Export":false,"StockTake_Inventory":false,"StockTake_Clone":false,"StockTake_Finish":false}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    #
    ${ma_phieu}   Add new purchase order no payment without supplier    ${dict_product_num}
    Before Test Dat Hang Nhap
    Element Should Not Be Visible    ${menu_hh}
    Element Should Not Be Visible    ${menu_doitac}
    Element Should Not Be Visible    ${domain_soquy}
    Element Should Not Be Visible    ${domain_baocao}
    Element Should Not Be Visible    ${menu_nhanvien}
    Element Should Not Be Visible    ${button_banhang_on_quanly}
    Element Should Not Be Visible    ${button_export_invoice}
    Element Should Not Be Visible    ${button_tao_phieu_dhn}
    Search code frm manager    ${ma_phieu}
    Element Should Not Be Visible     ${button_luu_phieu_dhn}
    Element Should Not Be Visible     ${button_ketthuc_phieu_dhn}
    Element Should Not Be Visible    ${button_dhn_mo_phieu}
    Element Should Not Be Visible    ${button_group_dhn}
    Delete purchase order code    ${ma_phieu}
    Delete user    ${get_user_id}

pqdhn2
    [Documentation]     người dùng chỉ có quyền Đặt hàng nhập: Xem DS + Thêm mới, Hàng hóa: Xem DS
    [Arguments]    ${taikhoan}    ${matkhau}    ${input_ma_sp}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"Manufacturing_Read":false,"Product_Read":true,"Manufacturing_Export":false,"Clocking_Copy":false,"Product_Create":false,"Product_Update":false,"Product_Delete":false,"Product_PurchasePrice":false,"Product_Cost":false,"Product_Import":false,"Product_Export":false,"Manufacturing_Create":false,"Manufacturing_Update":false,"Manufacturing_Delete":false,"StockTake_Read":false,"StockTake_Create":false,"StockTake_Delete":false,"OrderSupplier_Read":true,"OrderSupplier_Create":true,"StockTake_Export":false,"StockTake_Inventory":false,"StockTake_Clone":false,"StockTake_Finish":false}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    #
    Before Test Dat Hang Nhap
    Element Should Be Visible    ${menu_hh}
    Element Should Not Be Visible    ${menu_doitac}
    Element Should Not Be Visible    ${domain_soquy}
    Element Should Not Be Visible    ${domain_baocao}
    Element Should Not Be Visible    ${menu_nhanvien}
    Element Should Not Be Visible    ${button_banhang_on_quanly}
    Element Should Not Be Visible    ${button_export_invoice}
    Go to tao phieu DHN
    ${ma_phieu}    Generate code automatically    PDN
    input text    ${textbox_dhn_ma_phieu}    ${ma_phieu}
    Wait Until Page Contains Element    ${textbox_nh_search_hh}    1 min
    Wait Until Keyword Succeeds    3 times    3s    Input data in textbox and wait until it is visible    ${textbox_nh_search_hh}    ${input_ma_sp}    ${nh_item_indropdown_search}
    ...    ${nh_cell_first_product_code}
    Click Element    ${button_dat_hang_nhap}
    Wait Until Page Contains Element      //button[i[@class='fa fa-check']]     20s
    Click Element     //button[i[@class='fa fa-check']]
    Wait Until Keyword Succeeds    3 times    3 s    Purchase order message success validation    ${ma_phieu}
    Delete purchase order code    ${ma_phieu}
    Delete user    ${get_user_id}

pqdhn3
    [Documentation]     người dùng chỉ có quyền Đặt hàng nhập: Xem DS + Cập nhật
    [Arguments]    ${taikhoan}    ${matkhau}    ${dict_product_num}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"Manufacturing_Read":false,"Product_Read":false,"Manufacturing_Export":false,"Clocking_Copy":false,"Product_Create":false,"Product_Update":false,"Product_Delete":false,"Product_PurchasePrice":false,"Product_Cost":false,"Product_Import":false,"Product_Export":false,"Manufacturing_Create":false,"Manufacturing_Update":false,"Manufacturing_Delete":false,"StockTake_Read":false,"StockTake_Create":false,"StockTake_Delete":false,"OrderSupplier_Read":true,"OrderSupplier_Create":false,"StockTake_Export":false,"StockTake_Inventory":false,"StockTake_Clone":false,"StockTake_Finish":false,"OrderSupplier_Update":true}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    #
    ${ma_phieu}   Add new purchase order no payment without supplier    ${dict_product_num}
    Before Test Dat Hang Nhap
    Element Should Not Be Visible    ${menu_hh}
    Element Should Not Be Visible    ${menu_doitac}
    Element Should Not Be Visible    ${domain_soquy}
    Element Should Not Be Visible    ${domain_baocao}
    Element Should Not Be Visible    ${menu_nhanvien}
    Element Should Not Be Visible    ${button_banhang_on_quanly}
    Element Should Not Be Visible    ${button_export_invoice}
    Element Should Not Be Visible    ${button_tao_phieu_dhn}
    #
    Search code frm manager    ${ma_phieu}
    Wait Until Page Contains Element    ${button_luu_phieu_dhn}
    Element Should Be Visible    ${button_ketthuc_phieu_dhn}
    Element Should Be Visible    ${button_dhn_mo_phieu}
    Element Should Not Be Visible    ${button_group_dhn}
    Click Element    ${button_luu_phieu_dhn}
    Purchase order message success validation    ${ma_phieu}
    Delete purchase order code    ${ma_phieu}
    Delete user    ${get_user_id}

pqdhn4
    [Documentation]     người dùng chỉ có quyền Đặt hàng nhập: Xem DS + Xóa
    [Arguments]    ${taikhoan}    ${matkhau}    ${dict_product_num}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"Manufacturing_Read":false,"Product_Read":false,"Manufacturing_Export":false,"Clocking_Copy":false,"Product_Create":false,"Product_Update":false,"Product_Delete":false,"Product_PurchasePrice":false,"Product_Cost":false,"Product_Import":false,"Product_Export":false,"Manufacturing_Create":false,"Manufacturing_Update":false,"Manufacturing_Delete":false,"StockTake_Read":false,"StockTake_Create":false,"StockTake_Delete":false,"OrderSupplier_Read":true,"OrderSupplier_Create":false,"StockTake_Export":false,"StockTake_Inventory":false,"StockTake_Clone":false,"StockTake_Finish":false,"OrderSupplier_Update":false,"OrderSupplier_Delete":true}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    #
    ${ma_phieu}   Add new purchase order no payment without supplier    ${dict_product_num}
    Before Test Dat Hang Nhap
    Element Should Not Be Visible    ${menu_hh}
    Element Should Not Be Visible    ${menu_doitac}
    Element Should Not Be Visible    ${domain_soquy}
    Element Should Not Be Visible    ${domain_baocao}
    Element Should Not Be Visible    ${menu_nhanvien}
    Element Should Not Be Visible    ${button_banhang_on_quanly}
    Element Should Not Be Visible    ${button_export_invoice}
    Element Should Not Be Visible    ${button_tao_phieu_dhn}
    #
    Search code frm manager    ${ma_phieu}
    Wait Until Page Contains Element    ${button_huybo_phieu_dhn}
    Element Should Not Be Visible    ${button_ketthuc_phieu_dhn}
    Element Should Not Be Visible    ${button_dhn_mo_phieu}
    Element Should Not Be Visible    ${button_dhn_tao_phieu_nhap}
    Element Should Not Be Visible    ${button_luu_phieu_dhn}
    Element Should Not Be Visible    ${button_group_dhn}
    Click Element    ${button_huybo_phieu_dhn}
    Wait Until Page Contains Element    ${button_dongy_huy_phieu_dhn}         20s
    Click Element    ${button_dongy_huy_phieu_dhn}
    Wait Until Element Is Visible    ${toast_message}    1 min
    Element Should Contain    ${toast_message}    Hủy phiếu đặt hàng nhập ${ma_phieu} thành công
    Delete user    ${get_user_id}

pqdhn5
    [Documentation]     người dùng chỉ có quyền Đặt hàng nhập: Xem DS + In lại
    [Arguments]    ${taikhoan}    ${matkhau}    ${dict_product_num}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"OrderSupplier_Read":true,"OrderSupplier_Create":false,"Product_Read":false,"OrderSupplier_Clone":false,"Clocking_Copy":false,"Product_Create":false,"Product_Update":false,"Product_Delete":false,"Product_PurchasePrice":false,"Product_Cost":false,"Product_Import":false,"Product_Export":false,"OrderSupplier_RepeatPrint":true}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    #
    ${ma_phieu}   Add new purchase order no payment without supplier    ${dict_product_num}
    Before Test Dat Hang Nhap
    Element Should Not Be Visible    ${menu_doitac}
    Element Should Not Be Visible    ${domain_soquy}
    Element Should Not Be Visible    ${domain_baocao}
    Element Should Not Be Visible    ${menu_nhanvien}
    Element Should Not Be Visible    ${button_banhang_on_quanly}
    Element Should NoT Be Visible    ${button_tao_phieu_dhn}
    Element Should Not Be Visible    ${button_export_invoice}
    #
    Search code frm manager    ${ma_phieu}
    Wait Until Page Contains Element    ${button_group_dhn}    20s
    Click Element    ${button_group_dhn}
    Wait Until Page Contains Element    ${button_dhn_in}    20s
    Click Element    ${button_dhn_in}
    Delete purchase order code        ${ma_phieu}
    Delete user    ${get_user_id}
