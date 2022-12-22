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
Resource          ../../../../core/Giao_dich/xuat_huy_list_action.robot
Resource          ../../../../core/Giao_dich/xuat_huy_add_action.robot
Resource          ../../../../core/API/api_xuathuy.robot
Resource          ../../../../core/API/api_danhmuc_hanghoa.robot
Resource          ../../../../core/Ban_Hang/banhang_manager_navigation.robot
Resource          ../../../../core/API/api_access.robot

*** Variables ***
&{dict_xh}     TPG13=1

*** Test Cases ***
Xem DS
    [Documentation]     người dùng chỉ có quyền Xuất hủy: Xem DS
    [Tags]      PQ3
    [Template]    pqxh1
    userxh1    123    ${dict_xh}

Xem DS + Thêm mới
    [Documentation]     người dùng chỉ có quyền Xuất hủy: Xem DS + Thêm mới
    [Tags]      PQ3
    [Template]    pqxh2
    userxh2    123         TPG13

Xem DS + Thêm mới + Cập nhật
    [Documentation]     người dùng chỉ có quyền Xuất hủy: Xem DS + Thêm mới + Cập nhật
    [Tags]      PQ3
    [Template]    pqxh3
    userxh3   123         ${dict_xh}

Xem DS + Xóa
    [Documentation]     người dùng chỉ có quyền Xuất hủy: Xem DS + Xóa
    [Tags]      PQ3
    [Template]    pqxh4
    userxh4    123        ${dict_xh}

Xem DS + Xuất file
    [Documentation]     người dùng chỉ có quyền Xuất hủy: Xem DS + Xuất file
    [Tags]      PQ3
    [Template]    pqxh5
    userxh5    123        ${dict_xh}

Xem DS + Thêm mới + Sao chép
    [Documentation]     người dùng chỉ có quyền Xuất hủy: Xem DS + Thêm mới + Sao chép
    [Tags]      PQ3
    [Template]    pqxh6
    userxh6    123         ${dict_xh}

*** Keywords ***
pqxh1
    [Documentation]     người dùng chỉ có quyền Xuất hủy: Xem DS
    [Arguments]    ${taikhoan}    ${matkhau}      ${dict_product_num}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"Transfer_Read":false,"Transfer_Create":false,"Transfer_Import":false,"Clocking_Copy":false,"Transfer_Update":false,"Transfer_Delete":false,"Transfer_Export":false,"Transfer_Clone":false,"DamageItem_Read":true}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    #
    ${damage_code}    Add new damage frm API    ${dict_product_num}
    Before Test Xuat Huy
    Element Should Not Be Visible    ${menu_hh}
    Element Should Not Be Visible    ${menu_doitac}
    Element Should Not Be Visible    ${domain_soquy}
    Element Should Not Be Visible    ${domain_baocao}
    Element Should Not Be Visible    ${menu_nhanvien}
    Element Should Not Be Visible    ${button_banhang_on_quanly}
    Element Should Not Be Visible    ${button_export_invoice}
    Search damage code    ${damage_code}
    Element Should Not Be Visible      ${button_xh_huybo}      20s
    Element Should Not Be Visible    ${button_xh_luu}
    Element Should Not Be Visible    ${button_xh_saochep}
    Delete user    ${get_user_id}
    Delete damage documentation thr API    ${damage_code}

pqxh2
    [Documentation]     người dùng chỉ có quyền Xuất hủy: Xem DS + Thêm mới
    [Arguments]    ${taikhoan}    ${matkhau}    ${input_product_code}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"Transfer_Read":false,"Transfer_Create":false,"Transfer_Import":false,"Clocking_Copy":false,"Transfer_Update":false,"Transfer_Delete":false,"Transfer_Export":false,"Transfer_Clone":false,"DamageItem_Read":true,"DamageItem_Create":true}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    #
    Before Test Xuat Huy
    KV Click Element    ${button_taophieu_xh}
    Element Should Not Be Visible    ${menu_hh}
    Element Should Not Be Visible    ${menu_doitac}
    Element Should Not Be Visible    ${domain_soquy}
    Element Should Not Be Visible    ${domain_baocao}
    Element Should Not Be Visible    ${menu_nhanvien}
    Element Should Not Be Visible    ${button_banhang_on_quanly}
    Element Should Not Be Visible    ${button_export_invoice}
    #
    ${ma_phieu}    Generate code automatically    XH
    Input data    ${textbox_xh_nhap_maphieu}    ${ma_phieu}
    Input product - num in XH form    ${input_product_code}    1
    Click Element     ${button_xh_hoanthanh}
    Damage doc message success validation    ${ma_phieu}
    Delete user    ${get_user_id}
    Delete damage documentation thr API    ${ma_phieu}

pqxh3
    [Documentation]     người dùng chỉ có quyền Xuất hủy: Xem DS + Thêm mới + Cập nhật
    [Arguments]    ${taikhoan}    ${matkhau}    ${dict_product_num}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"Transfer_Read":false,"Transfer_Create":false,"Transfer_Import":false,"Clocking_Copy":false,"Transfer_Update":false,"Transfer_Delete":false,"Transfer_Export":false,"Transfer_Clone":false,"DamageItem_Read":true,"DamageItem_Create":true,"DamageItem_Update":true}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    #
    ${damage_code}    Add new damage frm API    ${dict_product_num}
    Before Test Xuat Huy
    Element Should Not Be Visible    ${menu_hh}
    Element Should Not Be Visible    ${menu_doitac}
    Element Should Not Be Visible    ${domain_soquy}
    Element Should Not Be Visible    ${domain_baocao}
    Element Should Not Be Visible    ${menu_nhanvien}
    Element Should Not Be Visible    ${button_banhang_on_quanly}
    Element Should Not Be Visible    ${button_export_invoice}
    Search damage code    ${damage_code}
    Wait Until Page Contains Element      ${button_xh_luu}      50s
    Element Should Not Be Visible    ${button_xh_saochep}
    Click Element    ${button_xh_luu}
    Wait Until Page Contains Element    ${toast_message}      50s
    Element Should Contain    ${toast_message}      Phiếu xuất hủy ${damage_code} được cập nhật thành công
    Delete user    ${get_user_id}
    Delete damage documentation thr API    ${damage_code}

pqxh4
    [Documentation]     người dùng chỉ có quyền Xuất hủy: Xem DS + Xóa
    [Arguments]    ${taikhoan}    ${matkhau}    ${dict_product_num}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"Transfer_Read":false,"Transfer_Create":false,"Transfer_Import":false,"Clocking_Copy":false,"Transfer_Update":false,"Transfer_Delete":false,"Transfer_Export":false,"Transfer_Clone":false,"DamageItem_Read":true,"DamageItem_Create":false,"DamageItem_Update":false,"DamageItem_Delete":true}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    #
    ${damage_code}    Add new damage frm API    ${dict_product_num}
    Before Test Xuat Huy
    Element Should Not Be Visible    ${menu_hh}
    Element Should Not Be Visible    ${menu_doitac}
    Element Should Not Be Visible    ${domain_soquy}
    Element Should Not Be Visible    ${domain_baocao}
    Element Should Not Be Visible    ${menu_nhanvien}
    Element Should Not Be Visible    ${button_banhang_on_quanly}
    Element Should Not Be Visible    ${button_export_invoice}
    Search damage code    ${damage_code}
    Wait Until Page Contains Element      ${button_xh_huybo}      20s
    Element Should Not Be Visible    ${button_xh_saochep}
    Element Should Not Be Visible    ${button_xh_luu}
    Click Element    ${button_xh_huybo}
    Wait Until Page Contains Element    ${button_xh_dongy_huybo}     20s
    Click Element    ${button_xh_dongy_huybo}
    Wait Until Page Contains Element    ${toast_message}      1 min
    Wait Until Keyword Succeeds    3 times   1s   Element Should Contain    ${toast_message}     Hủy phiếu ${damage_code} thành công
    Delete user    ${get_user_id}

pqxh5
    [Documentation]     người dùng chỉ có quyền Xuất hủy: Xem DS + Xuất file
    [Arguments]    ${taikhoan}    ${matkhau}    ${dict_product_num}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"Transfer_Read":false,"Transfer_Create":false,"Transfer_Import":false,"Clocking_Copy":false,"Transfer_Update":false,"Transfer_Delete":false,"Transfer_Export":false,"Transfer_Clone":false,"DamageItem_Read":true,"DamageItem_Create":false,"DamageItem_Update":false,"DamageItem_Delete":false,"DamageItem_Clone":false,"DamageItem_Export":true}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    #
    ${damage_code}    Add new damage frm API    ${dict_product_num}
    Before Test Xuat Huy
    Element Should Not Be Visible    ${menu_hh}
    Element Should Not Be Visible    ${menu_doitac}
    Element Should Not Be Visible    ${domain_soquy}
    Element Should Not Be Visible    ${domain_baocao}
    Element Should Not Be Visible    ${menu_nhanvien}
    Element Should Not Be Visible    ${button_banhang_on_quanly}
    Search damage code        ${damage_code}
    Wait Until Keyword Succeeds    3 times    3s     Go to select export file    ${cell_item_export_tongquan}    ${damage_code}
    Wait Until Keyword Succeeds    3 times    3s    Element Should Contain    ${noti_export}    Nhấn vào đây để tải xuống
    Delete user    ${get_user_id}
    Delete damage documentation thr API       ${damage_code}

pqxh6
    [Documentation]     người dùng chỉ có quyền Xuất hủy: Xem DS + Thêm mới + Sao chép
    [Arguments]    ${taikhoan}    ${matkhau}    ${dict_product_num}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"DamageItem_Read":true,"DamageItem_Export":false,"Clocking_Copy":false,"DamageItem_Clone":true,"DamageItem_Create":true}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    #
    ${damage_code}    Add new damage frm API    ${dict_product_num}
    Before Test Xuat Huy
    Element Should Not Be Visible    ${menu_hh}
    Element Should Not Be Visible    ${menu_doitac}
    Element Should Not Be Visible    ${domain_soquy}
    Element Should Not Be Visible    ${domain_baocao}
    Element Should Not Be Visible    ${menu_nhanvien}
    Element Should Not Be Visible    ${button_banhang_on_quanly}
    Element Should Not Be Visible    ${button_export_invoice}
    #
    Search damage code       ${damage_code}
    Wait Until Page Contains Element      ${button_xh_saochep}      20s
    Element Should Not Be Visible    ${button_xh_luu}
    Element Should Not Be Visible    ${button_xh_huybo}
    ${get_id_phieu}   Get damage id         ${damage_code}
    ${url_sc}       Set Variable        ${URL}/#/DamageItems/${get_id_phieu}?type=clone
    Click Element    ${button_xh_saochep}
    Wait Until Keyword Succeeds    3 times    2s    Select Window   url=${url_sc}
    Wait Until Page Contains Element    ${button_ch_hoanthanh}     20s
    Click Element     ${button_xh_hoanthanh}
    Damage doc message success validation    ${damage_code}.01
    Delete user    ${get_user_id}
    Delete damage documentation thr API       ${damage_code}.01
