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

*** Variables ***
&{dict_nh}     TPG03=1

*** Test Cases ***
Xem DS
    [Documentation]     người dùng chỉ có quyền Nhập hàng: Xem DS
    [Tags]      PQ3
    [Template]    pqnh1
    usernh1    123      ${dict_nh}

Xem DS + Thêm mới
    [Documentation]     người dùng chỉ có quyền Nhập hàng: Xem DS + Thêm mới, Hàng hóa: Xem DS
    [Tags]      PQ3
    [Template]    pqnh2
    usernh2    123       TPG02

Xem DS + Thêm mới + Cập nhật
    [Documentation]     người dùng chỉ có quyền Nhập hàng: Xem DS + Thêm mới +Cập nhật
    [Tags]      PQ3
    [Template]    pqnh3
    usernh3    123       ${dict_nh}

Xem DS + Thêm mới + Xóa
    [Documentation]     người dùng chỉ có quyền Nhập hàng: Xem DS + Thêm mới + Xóa
    [Tags]      PQ3
    [Template]    pqnh4
    usernh4    123    ${dict_nh}

Xem DS + Thêm mới +Cập nhật + Cập nhật phiếu nhập hoàn thành
    [Documentation]     người dùng chỉ có quyền Nhập hàng: Xem DS + Thêm mới +Cập nhật + Cập nhật phiếu nhập hoàn thành
    [Tags]      PQ3
    [Template]    pqnh5
    usernh5    123    ${dict_nh}

Xem DS + Xuất file
    [Documentation]     người dùng chỉ có quyền Nhập hàng: Xem DS  +Xuất file
    [Tags]      PQ3
    [Template]    pqnh6
    usernh5    123    ${dict_nh}

Xem DS + Thêm mới = Sao chép
    [Documentation]     người dùng chỉ có quyền Nhập hàng: Xem DS + Thêm mới + Sao chép
    [Tags]      PQ3
    [Template]    pqnh7
    usernh7    123    ${dict_nh}

*** Keywords ***
pqnh1
    [Documentation]     người dùng chỉ có quyền Nhập hàng: Xem DS
    [Arguments]    ${taikhoan}    ${matkhau}      ${dict_product_num}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"OrderSupplier_Read":false,"OrderSupplier_RepeatPrint":false,"Clocking_Copy":false,"OrderSupplier_Create":false,"OrderSupplier_Update":false,"OrderSupplier_Delete":false,"OrderSupplier_Export":false,"OrderSupplier_MakePurchase":false,"OrderSupplier_Clone":false,"PurchaseOrder_Read":true}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    #
    ${get_ma_phieu}   Add new purchase receipt without supplier    ${dict_product_num}
    Before Test Import Product
    Element Should Not Be Visible    ${menu_hh}
    Element Should Not Be Visible    ${menu_doitac}
    Element Should Not Be Visible    ${domain_soquy}
    Element Should Not Be Visible    ${domain_baocao}
    Element Should Not Be Visible    ${menu_nhanvien}
    Element Should Not Be Visible    ${button_banhang_on_quanly}
    Element Should Not Be Visible    ${button_export_invoice}
    Search code frm manager    ${get_ma_phieu}
    Element Should Not Be Visible   ${button_nh_luu_pn}
    Element Should Not Be Visible   ${button_nh_huy_bo}
    Element Should Not Be Visible   ${button_trahangnhap_in_importform}
    Element Should Not Be Visible   ${button_mo_phieu_nhap}
    Delete user    ${get_user_id}

pqnh2
    [Documentation]     người dùng chỉ có quyền Nhập hàng: Xem DS + Thêm mới
    [Arguments]    ${taikhoan}    ${matkhau}      ${input_ma_sp}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"OrderSupplier_Read":false,"OrderSupplier_RepeatPrint":false,"Clocking_Copy":false,"OrderSupplier_Create":false,"OrderSupplier_Update":false,"OrderSupplier_Delete":false,"OrderSupplier_Export":false,"OrderSupplier_MakePurchase":false,"OrderSupplier_Clone":false,"PurchaseOrder_Read":true,"PurchaseOrder_Create":true}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    #
    Before Test Import Product
    Element Should Not Be Visible    ${menu_hh}
    Element Should Not Be Visible    ${menu_doitac}
    Element Should Not Be Visible    ${domain_soquy}
    Element Should Not Be Visible    ${domain_baocao}
    Element Should Not Be Visible    ${menu_nhanvien}
    Element Should Not Be Visible    ${button_banhang_on_quanly}
    Element Should Not Be Visible    ${button_export_invoice}
    Go to PNH
    Wait Until Keyword Succeeds    3 times    1s    Input data in textbox and wait until it is visible    ${textbox_nh_search_hh}    ${input_ma_sp}    ${nh_item_indropdown_search}
    ...    ${nh_cell_first_product_code}
    ${ma_phieu}    Generate code automatically    PNH
    Input Text    ${textbox_nh_ma_phieunhap}    ${ma_phieu}
    Element Should Not Be Visible   ${button_nh_luu_pn}
    Element Should Not Be Visible   ${button_nh_huy_bo}
    Element Should Not Be Visible   ${button_trahangnhap_in_importform}
    Element Should Not Be Visible   ${button_mo_phieu_nhap}
    Click Element    ${button_nh_hoanthanh}
    Wait Until Page Contains Element    //div[div[p[contains(text(),'hưa nhập nhà cung cấp')]]]//..//div[@class="kv-window-footer"]//button   20s
    Click Element    //div[div[p[contains(text(),'hưa nhập nhà cung cấp')]]]//..//div[@class="kv-window-footer"]//button
    Wait Until Keyword Succeeds    3 times    3 s    Purchase receipt message success validation    ${ma_phieu}
    Delete purchase receipt code     ${ma_phieu}
    Delete user    ${get_user_id}

pqnh3
    [Documentation]     người dùng chỉ có quyền Nhập hàng: Xem DS + Thêm mới + Cập nhật
    [Arguments]    ${taikhoan}    ${matkhau}      ${dict_product_num}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"OrderSupplier_Read":false,"OrderSupplier_RepeatPrint":false,"Clocking_Copy":false,"OrderSupplier_Create":false,"OrderSupplier_Update":false,"OrderSupplier_Delete":false,"OrderSupplier_Export":false,"OrderSupplier_MakePurchase":false,"OrderSupplier_Clone":false,"PurchaseOrder_Read":true,"PurchaseOrder_Create":true,"PurchaseOrder_Update":true}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    #
    ${get_ma_phieu}   Add new purchase receipt without supplier    ${dict_product_num}
    Before Test Import Product
    Element Should Not Be Visible    ${menu_hh}
    Element Should Not Be Visible    ${menu_doitac}
    Element Should Not Be Visible    ${domain_soquy}
    Element Should Not Be Visible    ${domain_baocao}
    Element Should Not Be Visible    ${menu_nhanvien}
    Element Should Not Be Visible    ${button_banhang_on_quanly}
    Element Should Not Be Visible    ${button_export_invoice}
    Search code frm manager    ${get_ma_phieu}
    Wait Until Page Contains Element    ${button_nh_luu_pn}    20s
    Click Element    ${button_nh_luu_pn}
    Purchase receipt message success validation    ${get_ma_phieu}
    Delete purchase receipt code     ${get_ma_phieu}
    Delete user    ${get_user_id}

pqnh4
    [Documentation]     người dùng chỉ có quyền Nhập hàng: Xem DS + Thêm mới + Xóa
    [Arguments]    ${taikhoan}    ${matkhau}      ${dict_product_num}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"PurchaseOrder_Read":true,"PurchaseOrder_Create":true,"PurchaseOrder_Update":false,"Clocking_Copy":false,"PurchaseOrder_Delete":true}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    #
    ${get_ma_phieu}   Add new purchase receipt without supplier    ${dict_product_num}
    Before Test Import Product
    Element Should Not Be Visible    ${menu_hh}
    Element Should Not Be Visible    ${menu_doitac}
    Element Should Not Be Visible    ${domain_soquy}
    Element Should Not Be Visible    ${domain_baocao}
    Element Should Not Be Visible    ${menu_nhanvien}
    Element Should Not Be Visible    ${button_banhang_on_quanly}
    Element Should Not Be Visible    ${button_export_invoice}
    Search code frm manager    ${get_ma_phieu}
    Wait Until Page Contains Element    ${button_nh_huy_bo}    20s
    Click Element    ${button_nh_huy_bo}
    Wait Until Page Contains Element    ${button_dongy_huybo_pn}    20s
    Click Element    ${button_dongy_huybo_pn}
    Wait Until Element Is Visible    ${toast_message}    2 min
    Element Should Contain    ${toast_message}    Hủy phiếu nhập ${get_ma_phieu} thành công
    Delete user    ${get_user_id}

pqnh5
    [Documentation]     người dùng chỉ có quyền Nhập hàng: Xem DS + Thêm mới + Cập nhật + Cập nhật phiếu nhập hoàn thành
    [Arguments]    ${taikhoan}    ${matkhau}      ${dict_product_num}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"PurchaseOrder_Read":true,"PurchaseOrder_Create":true,"PurchaseOrder_Update":true,"Clocking_Copy":false,"PurchaseOrder_Delete":false,"PurchaseOrder_UpdatePurchaseOrder":true}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    #
    ${get_ma_phieu}   Add new purchase receipt without supplier    ${dict_product_num}
    Before Test Import Product
    Element Should Not Be Visible    ${menu_hh}
    Element Should Not Be Visible    ${menu_doitac}
    Element Should Not Be Visible    ${domain_soquy}
    Element Should Not Be Visible    ${domain_baocao}
    Element Should Not Be Visible    ${menu_nhanvien}
    Element Should Not Be Visible    ${button_banhang_on_quanly}
    Element Should Not Be Visible    ${button_export_invoice}
    Search purchase receipt code and click open    ${get_ma_phieu}
    Wait Until Page Contains Element    ${button_nh_luu}      15s
    Click Element    ${button_nh_luu}
    Wait Until Page Contains Element    ${button_nh_dongy_capnhat}      15s
    Click Element     ${button_nh_dongy_capnhat}
    Wait Until Page Contains Element    //button[@class='btn-confirm kv2Btn']
    Click Element     //button[@class='btn-confirm kv2Btn']
    Wait Until Keyword Succeeds    3 times    3 s    Purchase receipt message success validation    ${get_ma_phieu}
    Delete purchase receipt code    ${get_ma_phieu}
    Delete user    ${get_user_id}

pqnh6
    [Documentation]     người dùng chỉ có quyền Nhập hàng: Xem DS + TXuất file
    [Arguments]    ${taikhoan}    ${matkhau}      ${dict_product_num}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"PurchaseOrder_Read":true,"PurchaseOrder_Create":false,"PurchaseOrder_Update":false,"Clocking_Copy":false,"PurchaseOrder_Delete":false,"PurchaseOrder_UpdatePurchaseOrder":false,"WarrantyOrder_Read":false,"WarrantyOrder_Create":false,"WarrantyOrder_Update":false,"WarrantyOrder_Delete":false,"WarrantyOrder_Print":false,"WarrantyOrder_Export":false,"WarrantyOrder_CreateInvoice":false,"WarrantyOrder_UpdateExpire":false,"WarrantyOrder_ViewPrice":false,"PurchaseOrder_Export":true}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    #
    ${get_ma_phieu}   Add new purchase receipt without supplier    ${dict_product_num}
    Before Test Import Product
    Element Should Not Be Visible    ${menu_hh}
    Element Should Not Be Visible    ${menu_doitac}
    Element Should Not Be Visible    ${domain_soquy}
    Element Should Not Be Visible    ${domain_baocao}
    Element Should Not Be Visible    ${menu_nhanvien}
    Element Should Not Be Visible    ${button_banhang_on_quanly}
    Wait Until Keyword Succeeds    3 times    3s     Go to select export file other form    ${cell_item_export_tongquan}    ${get_ma_phieu}
    Wait Until Keyword Succeeds    3 times    3s    Element Should Contain    ${noti_export}    Nhấn vào đây để tải xuống
    Delete purchase receipt code    ${get_ma_phieu}
    Delete user    ${get_user_id}

pqnh7
    [Documentation]     người dùng chỉ có quyền Nhập hàng: Xem DS + Thêm mới + Sao chép
    [Arguments]    ${taikhoan}    ${matkhau}       ${dict_product_num}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"PurchaseOrder_Read":true,"PurchaseOrder_Create":true,"PurchaseOrder_Update":false,"Clocking_Copy":false,"PurchaseOrder_Delete":false,"PurchaseOrder_UpdatePurchaseOrder":false,"WarrantyOrder_Read":false,"WarrantyOrder_Create":false,"WarrantyOrder_Update":false,"WarrantyOrder_Delete":false,"WarrantyOrder_Print":false,"WarrantyOrder_Export":false,"WarrantyOrder_CreateInvoice":false,"WarrantyOrder_UpdateExpire":false,"WarrantyOrder_ViewPrice":false,"PurchaseOrder_Export":false,"PurchaseOrder_Clone":true}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    #
    ${get_ma_phieu}   Add new purchase receipt without supplier    ${dict_product_num}
    Before Test Import Product
    Element Should Not Be Visible    ${menu_hh}
    Element Should Not Be Visible    ${menu_doitac}
    Element Should Not Be Visible    ${domain_soquy}
    Element Should Not Be Visible    ${domain_baocao}
    Element Should Not Be Visible    ${menu_nhanvien}
    Element Should Not Be Visible    ${button_banhang_on_quanly}
    Element Should Not Be Visible    ${button_export_invoice}
    Search code frm manager    ${get_ma_phieu}
    Wait Until Page Contains Element    ${button_nh_group}
    Click Element    ${button_nh_group}
    Wait Until Page Contains Element    ${button_nh_saochep}
    Click Element    ${button_nh_saochep}
    ${get_id_phieu}   Get purchase receipt id thr API    ${get_ma_phieu}
    ${url_sc}       Set Variable        ${URL}/#/PurchaseOrder/${get_id_phieu}?type=clone
    Wait Until Keyword Succeeds    3 times    2s    Select Window   url=${url_sc}
    Click Element    ${button_nh_hoanthanh}
    Wait Until Page Contains Element    //div[div[p[contains(text(),'hưa nhập nhà cung cấp')]]]//..//div[@class="kv-window-footer"]//button   20s
    Click Element    //div[div[p[contains(text(),'hưa nhập nhà cung cấp')]]]//..//div[@class="kv-window-footer"]//button
    Wait Until Keyword Succeeds    3 times    3 s    Purchase receipt message success validation    ${get_ma_phieu}.01
    Delete purchase receipt code     ${get_ma_phieu}
    Delete user    ${get_user_id}
