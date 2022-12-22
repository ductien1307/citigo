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
Resource          ../../../../core/Giao_dich/nhap_hang_add_action.robot
Resource          ../../../../core/Giao_dich/nhap_hang_list_action.robot
Resource          ../../../../core/API/api_dathangnhap.robot
Resource          ../../../../core/API/api_phieu_nhap_hang.robot
Resource          ../../../../core/Ban_Hang/banhang_manager_navigation.robot

*** Variables ***
&{dict_dhn}     TPG02=1

*** Test Cases ***
Xem DS + Xuất file
    [Documentation]     người dùng chỉ có quyền  Đặt hàng nhập Xem DS + Xuất file
    [Tags]    PQ3
    [Template]    pqdhn6
    userdhn6   123       ${dict_dhn}

Xem DS + Tạo phiếu nhập
    [Documentation]     người dùng chỉ có quyền  Đặt hàng nhập: Xem DS + Tạo phiếu nhập, Nhập hàng: Xem DS + Thêm mới
    [Tags]    PQ3
    [Template]    pqdhn7
    userdhn7   123       ${dict_dhn}

Xem DS + Thêm mới + Sao chép
    [Documentation]     người dùng chỉ có quyền  Đặt hàng nhập: Xem DS + Thêm mới + Sao chép, Hàng hóa: Xem DS
    [Tags]    PQ3
    [Template]    pqdhn8
    userdhn8   123       ${dict_dhn}


*** Keywords ***
pqdhn6
    [Documentation]     người dùng chỉ có quyền Đặt hàng nhập: Xem DS + Xuất file
    [Arguments]    ${taikhoan}    ${matkhau}    ${dict_product_num}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"Manufacturing_Read":false,"Product_Read":false,"Manufacturing_Export":false,"Clocking_Copy":false,"Product_Create":false,"Product_Update":false,"Product_Delete":false,"Product_PurchasePrice":false,"Product_Cost":false,"Product_Import":false,"Product_Export":false,"Manufacturing_Create":false,"Manufacturing_Update":false,"Manufacturing_Delete":false,"StockTake_Read":false,"StockTake_Create":false,"StockTake_Delete":false,"OrderSupplier_Read":true,"OrderSupplier_Create":false,"StockTake_Export":false,"StockTake_Inventory":false,"StockTake_Clone":false,"StockTake_Finish":false,"OrderSupplier_Update":false,"OrderSupplier_Delete":false,"OrderSupplier_RepeatPrint":false,"OrderSupplier_Export":true,"OrderSupplier_MakePurchase":false,"OrderSupplier_Clone":false,"PurchaseOrder_Read":false,"PurchaseOrder_Create":false,"PurchaseOrder_Update":false,"PurchaseOrder_Delete":false,"PurchaseOrder_UpdatePurchaseOrder":false,"PurchaseOrder_Export":false,"PurchaseOrder_Clone":false}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
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
    Element Should Not Be Visible    ${button_tao_phieu_dhn}
    #
    Wait Until Keyword Succeeds    3 times    3s    Go to select export file other form    ${cell_item_export_tongquan}    ${ma_phieu}
    Wait Until Keyword Succeeds    3 times    3s    Element Should Contain    ${noti_export}    Nhấn vào đây để tải xuống
    Delete purchase order code    ${ma_phieu}
    Delete user    ${get_user_id}

pqdhn7
    [Documentation]     người dùng chỉ có quyền Đặt hàng nhập: Xem DS + Tạo phiếu nhập, Nhập hàng:Xem DS + Thêm mới
    [Arguments]    ${taikhoan}    ${matkhau}    ${dict_product_num}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"Manufacturing_Read":false,"Product_Read":false,"Manufacturing_Export":false,"Clocking_Copy":false,"Product_Create":false,"Product_Update":false,"Product_Delete":false,"Product_PurchasePrice":false,"Product_Cost":false,"Product_Import":false,"Product_Export":false,"Manufacturing_Create":false,"Manufacturing_Update":false,"Manufacturing_Delete":false,"StockTake_Read":false,"StockTake_Create":false,"StockTake_Delete":false,"OrderSupplier_Read":true,"OrderSupplier_Create":false,"StockTake_Export":false,"StockTake_Inventory":false,"StockTake_Clone":false,"StockTake_Finish":false,"OrderSupplier_Update":false,"OrderSupplier_Delete":false,"OrderSupplier_RepeatPrint":false,"OrderSupplier_Export":false,"OrderSupplier_MakePurchase":true,"OrderSupplier_Clone":false,"PurchaseOrder_Read":true,"PurchaseOrder_Create":true,"PurchaseOrder_Update":false,"PurchaseOrder_Delete":false,"PurchaseOrder_UpdatePurchaseOrder":false,"PurchaseOrder_Export":false,"PurchaseOrder_Clone":false,"WarrantyRepairingProduct_Read":false,"WarrantyRepairingProduct_Update":false}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
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
    Element Should Not Be Visible    ${button_tao_phieu_dhn}
    Element Should Not Be Visible    ${button_export_invoice}
    #
    Search code frm manager    ${ma_phieu}
    Wait Until Page Contains Element    ${button_dhn_tao_phieu_nhap}    20s
    Click Element    ${button_dhn_tao_phieu_nhap}
    Wait Until Page Contains Element    ${button_nh_hoanthanh}    20s
    ${ma_phieu_nh}    Generate code automatically    PNH
    Input Text    ${textbox_nh_ma_phieunhap}    ${ma_phieu_nh}
    Click Element    ${button_nh_hoanthanh}
    Purchase receipt message success validation    ${ma_phieu_nh}
    Delete purchase receipt code        ${ma_phieu_nh}
    Delete user    ${get_user_id}

pqdhn8
    [Documentation]     người dùng chỉ có quyền Đặt hàng nhập: Xem DS + Thêm mới + Sao chép, Hàng hóa: Xem DS
    [Arguments]    ${taikhoan}    ${matkhau}    ${dict_product_num}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"OrderSupplier_Read":true,"OrderSupplier_Create":true,"Product_Read":true,"OrderSupplier_Clone":true,"Clocking_Copy":false}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
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
    Element Should Be Visible    ${button_tao_phieu_dhn}
    Element Should Not Be Visible    ${button_export_invoice}
    #
    Search code frm manager    ${ma_phieu}
    Wait Until Page Contains Element    ${button_group_dhn}    20s
    Click Element    ${button_group_dhn}
    Wait Until Page Contains Element    ${button_dhn_sao_chep}    20s
    Click Element    ${button_dhn_sao_chep}
    ${get_dhn_id}   Get purchase order id frm API      ${ma_phieu}
    ${url_sc}       Set Variable        ${URL}/#/OrderSupplier/${get_dhn_id}?type=clone
    Wait Until Keyword Succeeds    3 times    2s    Select Window   url=${url_sc}
    Wait Until Page Contains Element    ${button_dat_hang_nhap}     20s
    Click Element    ${button_dat_hang_nhap}
    Wait Until Page Contains Element      //button[i[@class='fa fa-check']]     20s
    Click Element     //button[i[@class='fa fa-check']]
    Wait Until Keyword Succeeds    3 times    3 s    Purchase order message success validation    ${ma_phieu}.01
    Delete purchase order code        ${ma_phieu}
    Delete user    ${get_user_id}
