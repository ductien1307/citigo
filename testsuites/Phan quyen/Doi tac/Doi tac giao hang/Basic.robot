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
Resource          ../../../../core/Doi_Tac/giaohang_list_action.robot
Resource          ../../../../core/API/api_doi_tac_giaohang.robot
Resource          ../../../../core/API/api_danhmuc_hanghoa.robot
Resource          ../../../../core/Ban_Hang/banhang_manager_navigation.robot
Resource          ../../../../core/API/api_access.robot

*** Variables ***

*** Test Cases ***
Xem DS
    [Documentation]     người dùng chỉ có quyền Đối tác giao hàng: Xem DS
    [Tags]        PQ4
    [Template]    pqdtgh1
    userdtgh1    123       DT00008

Xem DS + Thêm mới
    [Documentation]     người dùng chỉ có quyền Đối tác giao hàng: Xem DS + Thêm mới
    [Tags]        PQ4
    [Template]    pqdtgh2
    userdtgh2    123          PQDTGH01      Cá nhân       Thái       none       1B yết kiêu        none      none        none          none     none

Xem DS + Cập nhật
    [Documentation]     người dùng chỉ có quyền Đối tác giao hàng: Xem DS + Thêm mới + Cập nhật
    [Tags]        PQ4
    [Template]    pqdtgh3
    userdtgh3   123       PQDTGH02      Hào       0986542369     Công ty       1B yết kiêu       none      none        none          none     none

Xem DS + Xóa
    [Documentation]     người dùng chỉ có quyền Đối tác giao hàng: Xem DS + Xóa
    [Tags]        PQ4
    [Template]    pqdtgh4
    userdtgh4    123       PQDTGH03      Huy       0988765787

Xem DS + Import
    [Documentation]     người dùng chỉ có quyền Đối tác giao hàng: Xem DS + Import
    [Tags]
    [Template]    pqdtgh5
    userdtgh5    123      C:\\Delivery.xlsx     DTGHN001

Xem DS + Xuất file
    [Documentation]     người dùng chỉ có quyền Đối tác giao hàng: Xem DS + Xuất file
    [Tags]
    [Template]    pqdtgh6
    userdtgh6    123      DT00008


*** Keywords ***
pqdtgh1
    [Documentation]     người dùng chỉ có quyền Đối tác giao hàng: Xem DS
    [Arguments]    ${taikhoan}    ${matkhau}     ${input_ma_dtgh}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"Supplier_Read":false,"Supplier_Export":false,"Clocking_Copy":false,"Supplier_Import":false,"Supplier_MobilePhone":false,"Supplier_Create":false,"Supplier_Update":false,"Supplier_Delete":false,"PartnerDelivery_Read":true}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    #
    Before Test Doi Tac Giao Hang
    Element Should Not Be Visible    ${menu_hh}
    Element Should Not Be Visible    ${menu_giaodich}
    Element Should Not Be Visible    ${domain_soquy}
    Element Should Not Be Visible    ${domain_baocao}
    Element Should Not Be Visible    ${menu_nhanvien}
    Element Should Not Be Visible    ${button_banhang_on_quanly}
    Search delivery partner          ${input_ma_dtgh}
    Element Should Not Be Visible      ${button_active_delivery}      20s
    Element Should Not Be Visible    ${button_update_delivery}
    Element Should Not Be Visible    ${button_delete_delivery}
    Element Should Not Be Visible    ${button_add_deliverypartner}
    Delete user    ${get_user_id}

pqdtgh2
    [Documentation]     người dùng chỉ có quyền Đối tác giao hàng: Xem DS
    [Arguments]    ${taikhoan}    ${matkhau}     ${deliverypartner_code}    ${input_deliverypartner_type}       ${input_deliverypartner_name}    ${input_deliverypartner_mobile}    ${input_deliverypartner_address}      ${input_deliverypartner_location}       ${input_deliverypartner_ward}       ${input_deliverypartner_email}       ${input_deliverypartner_group}      ${input_deliverypartner_note}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_id_dtgh}    Get deliverypartner id frm api    ${deliverypartner_code}
    Run Keyword If    '${get_id_dtgh}' == '0'    Log    Ignore delete     ELSE      Delete DeliveryPartner    ${get_id_dtgh}
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"Supplier_Read":false,"Supplier_Export":false,"Clocking_Copy":false,"Supplier_Import":false,"Supplier_MobilePhone":false,"Supplier_Create":false,"Supplier_Update":false,"Supplier_Delete":false,"PartnerDelivery_Read":true,"PartnerDelivery_Create":true}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    #
    Before Test Doi Tac Giao Hang
    Element Should Not Be Visible    ${menu_hh}
    Element Should Not Be Visible    ${menu_giaodich}
    Element Should Not Be Visible    ${domain_soquy}
    Element Should Not Be Visible    ${domain_baocao}
    Element Should Not Be Visible    ${menu_nhanvien}
    Element Should Not Be Visible    ${button_banhang_on_quanly}
    Wait Until Keyword Succeeds    3 times    3 s    Go to Add new deliverypartner
    Select Delivery Partner Type    ${input_deliverypartner_type}
    Wait until Element is Enabled       ${textbox_deliverypartner_code}       10 s
    Set Focus to element       ${textbox_deliverypartner_code}
    Wait Until Keyword Succeeds    3 times    3 s     Input data       ${textbox_deliverypartner_code}       ${deliverypartner_code}
    Wait Until Keyword Succeeds    3 times    3 s     Input data       ${textbox_deliverypartner_name}       ${input_deliverypartner_name}
    Run Keyword If    '${input_deliverypartner_mobile}' == 'none'    Log     Ignore input      ELSE       Input data       ${textbox_deliverypartnermobile}       ${input_deliverypartner_mobile}
    Run Keyword If    '${input_deliverypartner_address}' == 'none'    Log     Ignore input      ELSE       Input data       ${textbox_deliverypartner_address}       ${input_deliverypartner_address}
    Run Keyword If    '${input_deliverypartner_location}' == 'none'    Log     Ignore input      ELSE       Input data      ${textbox_deliverypartner_location}     ${input_deliverypartner_location}
    Run Keyword If    '${input_deliverypartner_ward}' == 'none'    Log     Ignore input      ELSE       Input data    ${textbox_deliverypartner_ward}    ${input_deliverypartner_ward}
    Run Keyword If    '${input_deliverypartner_group}' == 'none'    Log     Ignore input      ELSE       Input data      ${textbox_deliverypartner_group}      ${input_deliverypartner_group}
    Run Keyword If    '${input_deliverypartner_email}' == 'none'    Log     Ignore input      ELSE       Input data    ${textbox_deliverypartner_email}      ${input_deliverypartner_email}
    Run Keyword If    '${input_deliverypartner_note}' == 'none'    Log     Ignore input      ELSE       Input data    ${textbox_deliverypartner_note}      ${input_deliverypartner_note}
    Wait Until Element Is Enabled        ${button_deliverypartner_luu}
    Click Element        ${button_deliverypartner_luu}
    Wait Until Page Contains Element    ${toast_message}      50s
    Element Should Contain    ${toast_message}    Thông tin đối tác giao hàng được cập nhật thành công
    Sleep          5s
    ${deliverypartner_id}      Get deliverypartner info and validate    ${deliverypartner_code}    ${input_deliverypartner_name}    ${input_deliverypartner_mobile}    ${input_deliverypartner_address}    ${input_deliverypartner_location}    ${input_deliverypartner_ward}    ${input_deliverypartner_email}      ${input_deliverypartner_note}
    Delete deliverypartner    ${deliverypartner_id}
    Delete user    ${get_user_id}

pqdtgh3
    [Documentation]     người dùng chỉ có quyền Đối tác giao hàng: Xem DS + Cập nhật
    [Arguments]    ${taikhoan}    ${matkhau}     ${deliverypartner_code}    ${input_deliverypartner_name}    ${input_deliverypartner_mobile}    ${input_deliverypartner_type}    ${input_deliverypartner_address}
    ...      ${input_deliverypartner_location}       ${input_deliverypartner_ward}       ${input_deliverypartner_email}       ${input_deliverypartner_group}      ${input_deliverypartner_note}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_id_dtgh}    Get deliverypartner id frm api    ${deliverypartner_code}
    Run Keyword If    '${get_id_dtgh}' == '0'    Log    Ignore delete     ELSE      Delete DeliveryPartner    ${get_id_dtgh}
    Add partner delivery    ${deliverypartner_code}    ${input_deliverypartner_name}    ${input_deliverypartner_mobile}
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"PartnerDelivery_Read":true,"PartnerDelivery_Create":false,"Clocking_Copy":false,"PartnerDelivery_Update":true}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    #
    Before Test Doi Tac Giao Hang
    Element Should Not Be Visible    ${menu_hh}
    Element Should Not Be Visible    ${menu_giaodich}
    Element Should Not Be Visible    ${domain_soquy}
    Element Should Not Be Visible    ${domain_baocao}
    Element Should Not Be Visible    ${menu_nhanvien}
    Element Should Not Be Visible    ${button_banhang_on_quanly}
    Wait Until Keyword Succeeds    3 times    3 s    Go to udpate delivery partner    ${deliverypartner_code}
    Select Delivery Partner Type    ${input_deliverypartner_type}
    Run Keyword If    '${input_deliverypartner_address}' == 'none'    Log     Ignore input      ELSE       Input data       ${textbox_deliverypartner_address}       ${input_deliverypartner_address}
    Run Keyword If    '${input_deliverypartner_location}' == 'none'    Log     Ignore input      ELSE       Input data      ${textbox_deliverypartner_location}     ${input_deliverypartner_location}
    Run Keyword If    '${input_deliverypartner_ward}' == 'none'    Log     Ignore input      ELSE       Input data    ${textbox_deliverypartner_ward}    ${input_deliverypartner_ward}
    Run Keyword If    '${input_deliverypartner_group}' == 'none'    Log     Ignore input      ELSE       Input data      ${textbox_deliverypartner_group}      ${input_deliverypartner_group}
    Run Keyword If    '${input_deliverypartner_email}' == 'none'    Log     Ignore input      ELSE       Input data    ${textbox_deliverypartner_email}      ${input_deliverypartner_email}
    Run Keyword If    '${input_deliverypartner_note}' == 'none'    Log     Ignore input      ELSE       Input data    ${textbox_deliverypartner_note}      ${input_deliverypartner_note}
    Wait Until Element Is Enabled        ${button_deliverypartner_luu}
    Click Element        ${button_deliverypartner_luu}
    Wait Until Page Contains Element    ${toast_message}      50s
    Element Should Contain    ${toast_message}    Thông tin đối tác giao hàng được cập nhật thành công
    Sleep         5s
    ${deliverypartner_id}      Get deliverypartner info and validate    ${deliverypartner_code}    ${input_deliverypartner_name}    ${input_deliverypartner_mobile}    ${input_deliverypartner_address}    ${input_deliverypartner_location}    ${input_deliverypartner_ward}    ${input_deliverypartner_email}      ${input_deliverypartner_note}
    Delete deliverypartner    ${deliverypartner_id}
    Delete user    ${get_user_id}

pqdtgh4
    [Documentation]     người dùng chỉ có quyền Đối tác giao hàng: Xem DS + Xóa
    [Arguments]    ${taikhoan}    ${matkhau}      ${deliverypartner_code}       ${input_deliverypartner_name}    ${input_deliverypartner_mobile}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_id_dtgh}    Get deliverypartner id frm api    ${deliverypartner_code}
    Run Keyword If    '${get_id_dtgh}' == '0'    Log    Ignore delete     ELSE      Delete DeliveryPartner    ${get_id_dtgh}
    Add partner delivery    ${deliverypartner_code}    ${input_deliverypartner_name}    ${input_deliverypartner_mobile}
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"PartnerDelivery_Read":true,"PartnerDelivery_Create":false,"Clocking_Copy":false,"PartnerDelivery_Update":false,"PartnerDelivery_Delete":true}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    #
    Before Test Doi Tac Giao Hang
    Element Should Not Be Visible    ${menu_hh}
    Element Should Not Be Visible    ${menu_giaodich}
    Element Should Not Be Visible    ${domain_soquy}
    Element Should Not Be Visible    ${domain_baocao}
    Element Should Not Be Visible    ${menu_nhanvien}
    Element Should Not Be Visible    ${button_banhang_on_quanly}
    Wait Until Keyword Succeeds    3 times    3 s    Search delivery partner    ${deliverypartner_code}
    Sleep    3s
    Wait Until Page Contains Element    ${button_delete_delivery}    2 mins
    Element Should Not Be Visible      ${button_active_delivery}      20s
    Element Should Not Be Visible    ${button_update_delivery}
    Click Element JS    ${button_delete_delivery}
    Wait Until Page Contains Element    ${button_dongy_del_promo}    2 mins
    Click Element JS    ${button_dongy_del_promo}
    Wait Until Page Contains Element    ${toast_message}
    ${msg}    Format String    Xóa đối tác giao hàng {0} thành công    ${input_deliverypartner_name}
    Element Should Contain    ${toast_message}    ${msg}
    Delete user    ${get_user_id}

pqdtgh5
    [Documentation]     người dùng chỉ có quyền Đối tác giao hàng: Xem DS + Import
    [Arguments]    ${taikhoan}    ${matkhau}      ${input_excel_file}    ${input_delivery}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_delivery_id}   Get deliverypartner id frm api    ${input_delivery}
    Run Keyword If    '${get_delivery_id}' == '0'    Log     Ignore del     ELSE    Delete DeliveryPartner    ${get_delivery_id}
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"PartnerDelivery_Read":true,"PartnerDelivery_Create":false,"Clocking_Copy":false,"PartnerDelivery_Update":false,"PartnerDelivery_Delete":false,"PartnerDelivery_Import":true}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    #
    Before Test Doi Tac Giao Hang
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
    Wait Until Keyword Succeeds    3 times    3s    Wait Until Element Contains    ${toast_message_import}    Import thành công. Nhấn phím F5 để thấy dữ liệu mới nhất.    30s
    Delete user    ${get_user_id}

pqdtgh6
    [Documentation]     người dùng chỉ có quyền Đối tác giao hàng: Xem DS + Xuất file
    [Arguments]    ${taikhoan}    ${matkhau}     ${input_ma_dtgh}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"PartnerDelivery_Read":true,"PartnerDelivery_Create":false,"Clocking_Copy":false,"PartnerDelivery_Update":false,"PartnerDelivery_Delete":false,"PartnerDelivery_Import":false,"PartnerDelivery_Export":true}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    #
    Before Test Doi Tac Giao Hang
    Element Should Not Be Visible    ${menu_hh}
    Element Should Not Be Visible    ${menu_giaodich}
    Element Should Not Be Visible    ${domain_soquy}
    Element Should Not Be Visible    ${domain_baocao}
    Element Should Not Be Visible    ${menu_nhanvien}
    Element Should Not Be Visible    ${button_banhang_on_quanly}
    Search delivery partner          ${input_ma_dtgh}
    Element Should Not Be Visible      ${button_active_delivery}      20s
    Element Should Not Be Visible    ${button_update_delivery}
    Element Should Not Be Visible    ${button_delete_delivery}
    Wait Until Keyword Succeeds    3 times    3s    Click Element JS      ${button_export}
    Wait Until Keyword Succeeds    3 times    7s    Element Should Contain    ${noti_export}    Nhấn vào đây để tải xuống
    Delete user    ${get_user_id}
