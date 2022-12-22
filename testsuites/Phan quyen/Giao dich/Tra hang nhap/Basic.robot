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
Resource          ../../../../core/Giao_dich/nhap_hang_add_action.robot
Resource          ../../../../core/Giao_dich/nhap_hang_list_action.robot
Resource          ../../../../core/API/api_phieu_nhap_hang.robot
Resource          ../../../../core/Ban_Hang/banhang_manager_navigation.robot
Resource          ../../../../core/Giao_dich/tra_hang_nhap_list_action.robot
Resource          ../../../../core/API/api_tra_hang_nhap.robot
Resource          ../../../../core/API/api_danhmuc_hanghoa.robot

*** Variables ***
&{dict_thn}     TPG11=1

*** Test Cases ***
Xem DS
    [Documentation]     người dùng chỉ có quyền Trả hàng nhập: Xem DS
    [Tags]      PQ3
    [Template]    pqthn1
    usertnh1    123     ${dict_thn}

Xem DS + Thêm mới
    [Documentation]     người dùng chỉ có quyền Trả hàng nhập: Xem DS + Thêm mới
    [Tags]      PQ3
    [Template]    pqthn2
    usertnh2    123         TPG11

Xem DS + Thêm mới + Cập nhật
    [Documentation]     người dùng chỉ có quyền Trả hàng nhập: Xem DS + Thêm mới + Cập nhật
    [Tags]      PQ3
    [Template]    pqthn3
    usertnh3   123         ${dict_thn}

Xem DS + Xóa
    [Documentation]     người dùng chỉ có quyền Trả hàng nhập: Xem DS + Xóa
    [Tags]      PQ3
    [Template]    pqthn4
    usertnh4    123         ${dict_thn}

Xem DS + Thêm mới + Sao chép
    [Documentation]     người dùng chỉ có quyền Trả hàng nhập: Xem DS + Thêm mới + Sao chép
    [Tags]      PQ3
    [Template]    pqthn5
    usertnh5    123         ${dict_thn}

*** Keywords ***
pqthn1
    [Documentation]     người dùng chỉ có quyền Trả hàng nhập: Xem DS
    [Arguments]    ${taikhoan}    ${matkhau}      ${dict_product_num}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"PurchaseOrder_Read":false,"PurchaseOrder_Create":false,"PurchaseOrder_Clone":false,"Clocking_Copy":false,"PurchaseOrder_Update":false,"PurchaseOrder_Delete":false,"PurchaseOrder_UpdatePurchaseOrder":false,"PurchaseOrder_Export":false,"PurchaseReturn_Read":true}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    #
    ${get_ma_phieu}    Add new purchase return no payment without supplier    ${dict_product_num}
    Before Test Tra Hang Nhap
    Element Should Not Be Visible    ${menu_hh}
    Element Should Not Be Visible    ${menu_doitac}
    Element Should Not Be Visible    ${domain_soquy}
    Element Should Not Be Visible    ${domain_baocao}
    Element Should Not Be Visible    ${menu_nhanvien}
    Element Should Not Be Visible    ${button_banhang_on_quanly}
    Element Should Be Visible    ${button_export_invoice}
    Search code frm manager    ${get_ma_phieu}
    Element Should Not Be Visible    ${button_thn_luu}   20s
    Element Should Not Be Visible    ${button_thn_huy_bo}
    Element Should Not Be Visible    ${button_thn_sao_chep}
    Delete purchase return code    ${get_ma_phieu}
    Delete user    ${get_user_id}

pqthn2
    [Documentation]     người dùng chỉ có quyền Trả hàng nhập: Xem DS + Thêm mới
    [Arguments]    ${taikhoan}    ${matkhau}    ${product_code}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"PurchaseOrder_Read":false,"PurchaseOrder_Create":false,"PurchaseOrder_Clone":false,"Clocking_Copy":false,"PurchaseOrder_Update":false,"PurchaseOrder_Delete":false,"PurchaseOrder_UpdatePurchaseOrder":false,"PurchaseOrder_Export":false,"PurchaseReturn_Read":true,"PurchaseReturn_Create":true}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    #
    Before Test Tra Hang Nhap
    Element Should Not Be Visible    ${menu_hh}
    Element Should Not Be Visible    ${menu_doitac}
    Element Should Not Be Visible    ${domain_soquy}
    Element Should Not Be Visible    ${domain_baocao}
    Element Should Not Be Visible    ${menu_nhanvien}
    Element Should Not Be Visible    ${button_banhang_on_quanly}
    Element Should Be Visible    ${button_export_invoice}
    Wait Until Keyword Succeeds    3 times    1s    Add new Tra Hang Nhap
    ${ma_phiieu}      Generate code automatically       THNR
    Wait Until Page Contains Element    ${textbox_search_trahangnhap}    2 mins
    ${target_display_by_product_code}      Format String        ${cell_product_code_display_thn}         ${product_code}
    Wait Until Keyword Succeeds    3 times    2s    Input data in textbox and wait until it is visible    ${textbox_search_trahangnhap}    ${product_code}    ${dropdown_product_code_display}
    ...    ${target_display_by_product_code}
    Input purchase return Code      ${ma_phiieu}
    Click Element    ${button_finish_thn}
    Purchase return message success validation    ${ma_phiieu}
    Delete purchase return code    ${ma_phiieu}
    Delete user    ${get_user_id}

pqthn3
    [Documentation]     người dùng chỉ có quyền Trả hàng nhập: Xem DS + Thêm mới + Cập nhật
    [Arguments]    ${taikhoan}    ${matkhau}    ${dict_product_num}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"PurchaseOrder_Read":false,"PurchaseOrder_Create":false,"PurchaseOrder_Clone":false,"Clocking_Copy":false,"PurchaseOrder_Update":false,"PurchaseOrder_Delete":false,"PurchaseOrder_UpdatePurchaseOrder":false,"PurchaseOrder_Export":false,"PurchaseReturn_Read":true,"PurchaseReturn_Create":true,"PurchaseReturn_Update":true}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    #
    ${get_ma_phieu}    Add new purchase return no payment without supplier    ${dict_product_num}
    Before Test Tra Hang Nhap
    Element Should Not Be Visible    ${menu_hh}
    Element Should Not Be Visible    ${menu_doitac}
    Element Should Not Be Visible    ${domain_soquy}
    Element Should Not Be Visible    ${domain_baocao}
    Element Should Not Be Visible    ${menu_nhanvien}
    Element Should Not Be Visible    ${button_banhang_on_quanly}
    Element Should Be Visible    ${button_export_invoice}
    Search code frm manager    ${get_ma_phieu}
    Wait Until Page Contains Element    ${button_thn_luu}   20s
    Element Should Not Be Visible    ${button_thn_huy_bo}
    Element Should Not Be Visible    ${button_thn_sao_chep}
    Click Element    ${button_thn_luu}
    Wait Until Page Contains Element    ${toast_message}      50s
    Element Should Contain    ${toast_message}   Trả hàng ${get_ma_phieu} được cập nhật thành công
    Delete purchase return code    ${get_ma_phieu}
    Delete user    ${get_user_id}

pqthn4
    [Documentation]     người dùng chỉ có quyền Trả hàng nhập: Xem DS + Xóa
    [Arguments]    ${taikhoan}    ${matkhau}    ${dict_product_num}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"PurchaseOrder_Read":false,"PurchaseOrder_Create":false,"PurchaseOrder_Clone":false,"Clocking_Copy":false,"PurchaseOrder_Update":false,"PurchaseOrder_Delete":false,"PurchaseOrder_UpdatePurchaseOrder":false,"PurchaseOrder_Export":false,"PurchaseReturn_Read":true,"PurchaseReturn_Create":false,"PurchaseReturn_Update":false,"PurchaseReturn_Clone":false,"PurchaseReturn_Delete":true}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    #
    ${get_ma_phieu}    Add new purchase return no payment without supplier    ${dict_product_num}
    Before Test Tra Hang Nhap
    Element Should Not Be Visible    ${menu_hh}
    Element Should Not Be Visible    ${menu_doitac}
    Element Should Not Be Visible    ${domain_soquy}
    Element Should Not Be Visible    ${domain_baocao}
    Element Should Not Be Visible    ${menu_nhanvien}
    Element Should Not Be Visible    ${button_banhang_on_quanly}
    Element Should Be Visible    ${button_export_invoice}
    Search code frm manager    ${get_ma_phieu}
    Wait Until Page Contains Element    ${button_thn_huy_bo}   20s
    Element Should Not Be Visible    ${button_thn_sao_chep}
    Element Should Not Be Visible    ${button_thn_luu}
    Click Element    ${button_thn_huy_bo}
    Wait Until Page Contains Element    ${button_thn_dongy_huybo}      20s
    Click Element    ${button_thn_dongy_huybo}
    Wait Until Page Contains Element    ${toast_message}      20s
    Element Should Contain    ${toast_message}   Hủy phiếu trả hàng nhập: ${get_ma_phieu} thành công
    Delete user    ${get_user_id}

pqthn5
    [Documentation]     người dùng chỉ có quyền Trả hàng nhập: Xem DS + Thêm mới + Sao chép
    [Arguments]    ${taikhoan}    ${matkhau}    ${dict_product_num}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"PurchaseOrder_Read":false,"PurchaseOrder_Create":false,"PurchaseOrder_Clone":false,"Clocking_Copy":false,"PurchaseOrder_Update":false,"PurchaseOrder_Delete":false,"PurchaseOrder_UpdatePurchaseOrder":false,"PurchaseOrder_Export":false,"PurchaseReturn_Read":true,"PurchaseReturn_Create":true,"PurchaseReturn_Update":false,"PurchaseReturn_Clone":true}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    #
    ${get_ma_phieu}    Add new purchase return no payment without supplier    ${dict_product_num}
    Before Test Tra Hang Nhap
    Element Should Not Be Visible    ${menu_hh}
    Element Should Not Be Visible    ${menu_doitac}
    Element Should Not Be Visible    ${domain_soquy}
    Element Should Not Be Visible    ${domain_baocao}
    Element Should Not Be Visible    ${menu_nhanvien}
    Element Should Not Be Visible    ${button_banhang_on_quanly}
    Element Should Be Visible    ${button_export_invoice}
    Search code frm manager    ${get_ma_phieu}
    Wait Until Page Contains Element    ${button_thn_sao_chep}   20s
    Element Should Not Be Visible    ${button_thn_huy_bo}
    Element Should Not Be Visible    ${button_thn_luu}
    Click Element    ${button_thn_sao_chep}
    ${get_id_phieu}     Get purchase return id thr API    ${get_ma_phieu}
    ${url_sc}       Set Variable        ${URL}/#/PurchaseReturns/temp_${get_id_phieu}?type=clone
    Wait Until Keyword Succeeds    3 times    2s    Select Window   url=${url_sc}
    Wait Until Page Contains Element    ${button_finish_thn}      20s
    Click Element    ${button_finish_thn}
    Wait Until Page Contains Element    ${toast_message}      20s
    Element Should Contain    ${toast_message}   Phiếu trả hàng nhập ${get_ma_phieu}.01 được cập nhật thành công
    Delete user    ${get_user_id}
