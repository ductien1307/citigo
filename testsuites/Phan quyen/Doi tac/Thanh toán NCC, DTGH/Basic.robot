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
Resource          ../../../../core/API/api_nha_cung_cap.robot
Resource          ../../../../core/API/api_danhmuc_hanghoa.robot
Resource          ../../../../core/Ban_Hang/banhang_manager_navigation.robot
Resource          ../../../../core/API/api_access.robot

*** Variables ***

*** Test Cases ***
Xem DS + Thêm mới
    [Documentation]     Đang có bug trên live: User có quyền Công nợ NCC: Xem DS, Nhà cung cấp: Xrm DS, Thanh toán NCC: Thêm mới thực hiện tạo phiếu tt báo lỗi nhưng khi load lại trang lại xh
    [Tags]
    [Template]    pqcttncc1

Xem DS + Cập nhật
    [Documentation]     người dùng chỉ có quyền Công nợ NCC: Xem DS, Nhà cung cấp: Xrm DS, Thanh toán NCC: Xóa + Cập nhật
    [Tags]      PQ4
    [Template]    pqcttncc2
    userttncc2   123        PQNCC005     75000

Xem DS + Xóa
    [Documentation]     người dùng chỉ có quyền Công nợ NCC: Xem DS, Nhà cung cấp: Xrm DS, Thanh toán NCC: Xóa + Cập nhật
    [Tags]      PQ4
    [Template]    pqcttncc3
    userttncc3    123        PQNCC006     95000

*** Keywords ***
pqcttncc1

pqcttncc2
    [Documentation]     người dùng chỉ có quyền Công nợ NCC: Xem DS, Nhà cung cấp: Xrm DS, Thanh toán NCC: Xóa + Cập nhật
    [Arguments]    ${taikhoan}    ${matkhau}      ${input_ma_ncc}     ${input_giatri}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_id_ncc}     Get Supplier Id    ${input_ma_ncc}
    Run Keyword If    ${get_id_ncc}!=0         Delete suplier      ${input_ma_ncc}
    Add supplier    ${input_ma_ncc}    test pq      0987456985
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"PartnerDelivery_Read":false,"PurchasePayment_Create":false,"PurchasePayment_Update":true,"PurchasePayment_Delete":true,"Clocking_Copy":false,"PartnerDelivery_Update":false,"DeliveryAdjustment_Read":false,"DeliveryAdjustment_Update":false,"SupplierAdjustment_Read":true,"DeliveryAdjustment_Delete":false,"CustomerPointAdjustment_Read":false,"CustomerPointAdjustment_Update":false,"SupplierAdjustment_Create":false,"SupplierAdjustment_Update":false,"SupplierAdjustment_Delete":false,"PartnerDelivery_Create":false,"PartnerDelivery_Delete":false,"PartnerDelivery_Import":false,"PartnerDelivery_Export":false,"DeliveryAdjustment_Create":false,"Customer_Read":false,"Customer_Create":false,"Customer_Update":false,"Customer_Delete":false,"Customer_ViewPhone":false,"Customer_Import":false,"Customer_Export":false,"Customer_UpdateGroup":false,"Supplier_Read":true,"Supplier_Create":false,"Supplier_Update":false,"Supplier_Delete":false,"Supplier_MobilePhone":false,"Supplier_Import":false,"Supplier_Export":false}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}     ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    #
    ${get_ma_phieu}     Adapt Supplier Dept       ${input_ma_ncc}    ${input_giatri}
    Sleep    3s
    ${get_ma_phieu_tt}     Add new purchase payment thr API     ${input_ma_ncc}    ${input_giatri}
    Before Test Nha Cung Cap
    Element Should Not Be Visible    ${menu_hh}
    Element Should Not Be Visible    ${menu_giaodich}
    Element Should Not Be Visible    ${domain_soquy}
    Element Should Not Be Visible    ${domain_baocao}
    Element Should Not Be Visible    ${menu_nhanvien}
    Element Should Not Be Visible    ${button_banhang_on_quanly}
    Search supplier         ${input_ma_ncc}
    Wait Until Keyword Succeeds    3x    3s    Click Element    ${tab_nocantra_ncc}
    ${cell_maphieu}     Format String       ${cell_ma_phieu_canbang}      ${get_ma_phieu_tt}
    Wait Until Page Contains Element    ${cell_maphieu}       40s
    Click Element    ${cell_maphieu}
    Wait Until Page Contains Element    ${button_capnhat_phieutt_ncc}      20s
    Click Element    ${button_capnhat_phieutt_ncc}
    Wait Until Page Contains Element    ${toast_message}      40s
    Element Should Contain    ${toast_message}      Phiếu chi ${get_ma_phieu_tt} được cập nhật thành công
    Delete user    ${get_user_id}
    Delete suplier      ${input_ma_ncc}

pqcttncc3
    [Documentation]      người dùng chỉ có quyền Công nợ NCC: Xem DS, Nhà cung cấp: Xrm DS, Thanh toán NCC: Xóa + Cập nhật
    [Arguments]    ${taikhoan}    ${matkhau}      ${input_ma_ncc}     ${input_giatri}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_id_ncc}     Get Supplier Id    ${input_ma_ncc}
    Run Keyword If    ${get_id_ncc}!=0         Delete suplier      ${input_ma_ncc}
    Add supplier    ${input_ma_ncc}    test pq      0985632145
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"PartnerDelivery_Read":false,"PurchasePayment_Create":false,"PurchasePayment_Update":true,"PurchasePayment_Delete":true,"Clocking_Copy":false,"PartnerDelivery_Update":false,"DeliveryAdjustment_Read":false,"DeliveryAdjustment_Update":false,"SupplierAdjustment_Read":true,"DeliveryAdjustment_Delete":false,"CustomerPointAdjustment_Read":false,"CustomerPointAdjustment_Update":false,"SupplierAdjustment_Create":false,"SupplierAdjustment_Update":false,"SupplierAdjustment_Delete":false,"PartnerDelivery_Create":false,"PartnerDelivery_Delete":false,"PartnerDelivery_Import":false,"PartnerDelivery_Export":false,"DeliveryAdjustment_Create":false,"Customer_Read":false,"Customer_Create":false,"Customer_Update":false,"Customer_Delete":false,"Customer_ViewPhone":false,"Customer_Import":false,"Customer_Export":false,"Customer_UpdateGroup":false,"Supplier_Read":true,"Supplier_Create":false,"Supplier_Update":false,"Supplier_Delete":false,"Supplier_MobilePhone":false,"Supplier_Import":false,"Supplier_Export":false}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}     ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    #
    ${get_ma_phieu}     Adapt Supplier Dept       ${input_ma_ncc}    ${input_giatri}
    Sleep    3s
    ${get_ma_phieu_tt}     Add new purchase payment thr API     ${input_ma_ncc}    ${input_giatri}
    Before Test Nha Cung Cap
    Element Should Not Be Visible    ${menu_hh}
    Element Should Not Be Visible    ${menu_giaodich}
    Element Should Not Be Visible    ${domain_soquy}
    Element Should Not Be Visible    ${domain_baocao}
    Element Should Not Be Visible    ${menu_nhanvien}
    Element Should Not Be Visible    ${button_banhang_on_quanly}
    Search supplier         ${input_ma_ncc}
    Wait Until Keyword Succeeds    3x    3s    Click Element    ${tab_nocantra_ncc}
    ${cell_maphieu}     Format String       ${cell_ma_phieu_canbang}      ${get_ma_phieu_tt}
    Wait Until Page Contains Element    ${cell_maphieu}       40s
    Click Element    ${cell_maphieu}
    Wait Until Page Contains Element    ${button_huybo_phieutt_ncc}      20s
    Click Element    ${button_huybo_phieutt_ncc}
    Wait Until Page Contains Element    ${button_dongy_huybo_dieuchinh}      40s
    Click Element JS    ${button_dongy_huybo_dieuchinh}
    Wait Until Page Contains Element    ${toast_message}      40s
    Element Should Contain    ${toast_message}      Phiếu chi ${get_ma_phieu_tt} đã được hủy
    Delete user    ${get_user_id}
    Delete suplier      ${input_ma_ncc}
