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
Resource          ../../../../core/Doi_Tac/khachhang_list_action.robot
Resource          ../../../../core/API/api_khachhang.robot
Resource          ../../../../core/API/api_danhmuc_hanghoa.robot
Resource          ../../../../core/Ban_Hang/banhang_manager_navigation.robot
Resource          ../../../../core/API/api_access.robot

*** Variables ***

*** Test Cases ***
Xem DS + Cập nhật
    [Documentation]     người dùng chỉ có quyền Khách hàng: Xem DS, Tích điểm KH: Xem DS + Cập nhật
    [Tags]        PQ4
    [Template]    pqtdkh1
    usertdkh1    123       PQKH10        10

*** Keywords ***
pqtdkh1
    [Documentation]     người dùng chỉ có quyền Khách hàng: Xem DS, Tích điểm KH: Xem DS + Cập nhật
    [Arguments]    ${taikhoan}    ${matkhau}      ${input_ma_kh}       ${input_giatri}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_id_kh}      Get Customer ID    ${input_ma_kh}
    Run Keyword If    ${get_id_kh}!=0        Delete customer    ${get_id_kh}
    Add customers    ${input_ma_kh}    testqp    0986598754    abc
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"PartnerDelivery_Read":false,"PurchasePayment_Create":false,"PurchasePayment_Update":false,"PurchasePayment_Delete":false,"Clocking_Copy":false,"PartnerDelivery_Update":false,"DeliveryAdjustment_Read":false,"DeliveryAdjustment_Update":false,"SupplierAdjustment_Read":false,"DeliveryAdjustment_Delete":false,"CustomerPointAdjustment_Read":true,"CustomerPointAdjustment_Update":true,"SupplierAdjustment_Create":false,"SupplierAdjustment_Update":false,"SupplierAdjustment_Delete":false,"PartnerDelivery_Create":false,"PartnerDelivery_Delete":false,"PartnerDelivery_Import":false,"PartnerDelivery_Export":false,"DeliveryAdjustment_Create":false,"Customer_Read":true,"Customer_Create":true,"Customer_Update":true,"Customer_Delete":true,"Customer_ViewPhone":true,"Customer_Import":true,"Customer_Export":true,"Customer_UpdateGroup":true}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    #
    Before Test Doi Tac Khach Hang
    Element Should Not Be Visible    ${menu_hh}
    Element Should Not Be Visible    ${menu_giaodich}
    Element Should Not Be Visible    ${domain_soquy}
    Element Should Not Be Visible    ${domain_baocao}
    Element Should Not Be Visible    ${menu_nhanvien}
    Element Should Not Be Visible    ${button_banhang_on_quanly}
    Search customer      ${input_ma_kh}
    Wait Until Page Contains Element    ${tab_lichsu_tichdiem}      30s
    Click Element JS     ${tab_lichsu_tichdiem}
    Wait Until Page Contains Element    ${button_dieuchinh_tichdiem}      30s
    Click Element     ${button_dieuchinh_tichdiem}
    Wait Until Page Contains Element    ${textbox_diem_moi}      30s
    Input Text    ${textbox_diem_moi}    ${input_giatri}
    Click Element    ${button_capnhat_tichdiem}
    Update data success validation
    Delete customer by Customer Code    ${input_ma_kh}
    Delete user    ${get_user_id}
