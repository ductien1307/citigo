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
Resource          ../../../../core/Doi_Tac/khachhang_list_action.robot
Resource          ../../../../core/API/api_nha_cung_cap.robotF
Resource          ../../../../core/API/api_danhmuc_hanghoa.robot
Resource          ../../../../core/Ban_Hang/banhang_manager_navigation.robot
Resource          ../../../../core/API/api_access.robot

*** Variables ***

*** Test Cases ***
Xem DS
    [Documentation]     người dùng chỉ có quyền Công nợ NCC: Xem DS, Nhà cung cấp: Xem DS
    [Tags]      PQ4
    [Template]    pqcnncc1
    usercnncc1    123       NCC0043

Xem DS + Thêm mới
    [Documentation]     người dùng chỉ có quyền Công nợ NCC: Xem DS + Thêm mới, Nhà cung cấp: Xrm DS
    [Tags]      PQ4
    [Template]    pqcnncc2
    usercnncc2    123          PQNCC001    135000

Xem DS + Cập nhật
    [Documentation]     người dùng chỉ có quyền Công nợ NCC: Xem DS + Thêm mới + Cập nhật, Nhà cung cấp: Xrm DS + Cập nhật
    [Tags]      PQ4
    [Template]    pqcnncc3
    usercnncc3   123        PQNCC002     75000    115000

Xem DS + Xóa
    [Documentation]     người dùng chỉ có quyền Công nợ NCC: Xem DS + Xóa, Nhà cung cấp: Xrm DS + Cập nhật
    [Tags]      PQ4
    [Template]    pqcnncc4
    usercnncc4    123        PQNCC003     95000

*** Keywords ***
pqcnncc1
    [Documentation]     người dùng chỉ có quyền Công nợ NCC: Xem DS, Nhà cung cấp: Xem DS
    [Arguments]    ${taikhoan}    ${matkhau}      ${input_ma_ncc}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"Customer_Read":false,"CustomerAdjustment_Read":false,"Payment_Create":false,"Clocking_Copy":false,"Payment_Delete":false,"Payment_Update":false,"CustomerAdjustment_Create":false,"CustomerAdjustment_Update":false,"CustomerAdjustment_Delete":false,"Customer_Create":false,"Customer_Update":false,"Customer_Delete":false,"Customer_ViewPhone":false,"Customer_Import":false,"Customer_Export":false,"Customer_UpdateGroup":false,"Supplier_Read":true,"SupplierAdjustment_Read":true}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
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
    Search supplier         ${input_ma_ncc}
    Element Should Not Be Visible      ${button_active_supplier}      20s
    Element Should Not Be Visible    ${button_update_supplier}
    Element Should Not Be Visible    ${button_delete_supplier}
    Element Should Be Visible    //a[@class='k-link'][contains(text(),'Nợ cần trả hiện tại')]        #cột nợ hiện tại
    Delete user    ${get_user_id}

pqcnncc2
    [Documentation]     người dùng chỉ có quyền Công nợ NCC: Xem DS + Thêm mới, Nhà cung cấp: Xem DS
    [Arguments]    ${taikhoan}    ${matkhau}      ${input_ma_ncc}     ${input_giatri}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_id_ncc}     Get Supplier Id    ${input_ma_ncc}
    Run Keyword If    ${get_id_ncc}!=0         Delete suplier      ${input_ma_ncc}
    Add supplier    ${input_ma_ncc}    test pq      0986596669
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"Customer_Read":false,"CustomerAdjustment_Read":false,"CustomerAdjustment_Create":false,"DeliveryAdjustment_Read":false,"DeliveryAdjustment_Create":false,"DeliveryAdjustment_Update":false,"DeliveryAdjustment_Delete":false,"PartnerDelivery_Read":false,"PartnerDelivery_Create":false,"PartnerDelivery_Update":false,"PartnerDelivery_Delete":false,"PurchasePayment_Create":false,"PurchasePayment_Update":false,"PurchasePayment_Delete":false,"Supplier_Read":true,"SupplierAdjustment_Read":true,"SupplierAdjustment_Create":true,"SupplierAdjustment_Update":false,"SupplierAdjustment_Delete":false,"PartnerDelivery_Import":false,"PartnerDelivery_Export":false,"Clocking_Copy":false,"Customer_Create":false,"Customer_Update":false,"Customer_Delete":false,"Customer_ViewPhone":false,"Customer_Import":false,"Customer_Export":false,"Customer_UpdateGroup":false,"CustomerAdjustment_Update":false,"CustomerAdjustment_Delete":false,"Supplier_Create":false,"Supplier_Update":true,"Supplier_Delete":false,"Supplier_MobilePhone":false,"Supplier_Import":false,"Supplier_Export":false}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
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
    Search supplier         ${input_ma_ncc}
    Wait Until Keyword Succeeds    3x    3x    Click Element    ${tab_nocantra_ncc}
    Wait Until Page Contains Element    ${button_dieuchinh_congno}
    Click Element JS    ${button_dieuchinh_congno}
    Input data in popup Dieu chinh    ${input_giatri}    none
    Wait Until Keyword Succeeds    3 times    3s    Update data success validation
    Sleep    5s
    ${get_ma_phieu}     ${get_giatri}     ${get_du_no}      Get ma phieu, gia tri, du no in tab No can tra NCC       ${input_ma_ncc}
    ${input_giatri}     Minus    0    ${input_giatri}
    Should Be Equal As Numbers    ${input_giatri}    ${get_du_no}
    Delete user    ${get_user_id}
    Delete suplier      ${input_ma_ncc}

pqcnncc3
    [Documentation]     người dùng chỉ có quyền Công nợ NCC: Xem DS + Thêm mới, Nhà cung cấp: Xem DS
    [Arguments]    ${taikhoan}    ${matkhau}      ${input_ma_ncc}     ${input_giatri}   ${input_giatri_new}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_id_ncc}     Get Supplier Id    ${input_ma_ncc}
    Run Keyword If    ${get_id_ncc}!=0         Delete suplier      ${input_ma_ncc}
    Add supplier    ${input_ma_ncc}    test pq      0987456695
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"Supplier_Read":true,"Supplier_Update":true,"SupplierAdjustment_Read":true,"SupplierAdjustment_Update":true,"Clocking_Copy":false}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    #
    ${get_ma_phieu}     Adapt Supplier Dept       ${input_ma_ncc}    ${input_giatri}
    Before Test Nha Cung Cap
    Element Should Not Be Visible    ${menu_hh}
    Element Should Not Be Visible    ${menu_giaodich}
    Element Should Not Be Visible    ${domain_soquy}
    Element Should Not Be Visible    ${domain_baocao}
    Element Should Not Be Visible    ${menu_nhanvien}
    Element Should Not Be Visible    ${button_banhang_on_quanly}
    Search supplier         ${input_ma_ncc}
    Wait Until Keyword Succeeds    3x    3s    Click Element    ${tab_nocantra_ncc}
    ${cell_maphieu}     Format String       ${cell_ma_phieu_canbang}      ${get_ma_phieu}
    Wait Until Page Contains Element    ${cell_maphieu}       40s
    Click Element    ${cell_maphieu}
    Wait Until Page Contains Element    ${button_edit_dieuchinh_ncc_capnhat}      40s
    #Sleep    60s
    Click Element JS    ${button_edit_dieuchinh_ncc_capnhat}
    Wait Until Keyword Succeeds    3 times    3s    Update data success validation
    Delete user    ${get_user_id}
    Delete suplier      ${input_ma_ncc}

pqcnncc4
    [Documentation]     người dùng chỉ có quyền Công nợ NCC: Xem DS + Xóa, Nhà cung cấp: Xem DS
    [Arguments]    ${taikhoan}    ${matkhau}      ${input_ma_ncc}     ${input_giatri}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_id_ncc}     Get Supplier Id    ${input_ma_ncc}
    Run Keyword If    ${get_id_ncc}!=0         Delete suplier      ${input_ma_ncc}
    Add supplier    ${input_ma_ncc}    test pq      0986596542
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"Supplier_Read":true,"Supplier_Update":true,"SupplierAdjustment_Read":true,"SupplierAdjustment_Update":false,"Clocking_Copy":false,"SupplierAdjustment_Delete":true}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    #
    ${get_ma_phieu}     Adapt Supplier Dept       ${input_ma_ncc}    ${input_giatri}
    Before Test Nha Cung Cap
    Element Should Not Be Visible    ${menu_hh}
    Element Should Not Be Visible    ${menu_giaodich}
    Element Should Not Be Visible    ${domain_soquy}
    Element Should Not Be Visible    ${domain_baocao}
    Element Should Not Be Visible    ${menu_nhanvien}
    Element Should Not Be Visible    ${button_banhang_on_quanly}
    Search supplier         ${input_ma_ncc}
    Wait Until Keyword Succeeds    3x    3s    Click Element    ${tab_nocantra_ncc}
    ${cell_maphieu}     Format String       ${cell_ma_phieu_canbang}      ${get_ma_phieu}
    Wait Until Page Contains Element    ${cell_maphieu}       40s
    Click Element    ${cell_maphieu}
    Wait Until Page Contains Element    ${button_huybo_dieuchinh}      20s
    Click Element JS    ${button_huybo_dieuchinh}
    Wait Until Page Contains Element    ${button_dongy_huybo_dieuchinh}      40s
    Click Element JS    ${button_dongy_huybo_dieuchinh}
    Wait Until Page Contains Element    ${toast_message}      40s
    Element Should Contain    ${toast_message}      Xóa điều chỉnh công nợ thành công
    Delete user    ${get_user_id}
    Delete suplier      ${input_ma_ncc}
