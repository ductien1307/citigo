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
Resource          ../../../../core/Doi_Tac/khachhang_list_action.robot
Resource          ../../../../core/Doi_Tac/ncc_list_action.robot
Resource          ../../../../core/API/api_doi_tac_giaohang.robot
Resource          ../../../../core/API/api_danhmuc_hanghoa.robot
Resource          ../../../../core/Ban_Hang/banhang_manager_navigation.robot
Resource          ../../../../core/API/api_access.robot

*** Variables ***

*** Test Cases ***
Xem DS
    [Documentation]     người dùng chỉ có quyền Công nợ ĐTGH: Xem DS, Dối tác giao hàng: Xem DS
    [Tags]      PQ4
    [Template]    pqcngh1
    userccngh1    123       DT00009

Xem DS + Thêm mới
    [Documentation]     người dùng chỉ có quyền Công nợ ĐTGH: Xem DS + Thêm mới, Dối tác giao hàng: Xrm DS + Cập nhật (dang có bug phải thêm quyền Công nợ ĐTGH: Cập nhật)
    [Tags]
    [Template]    pqcngh2
    userccngh2    123          PQDT001    135000

Xem DS + Cập nhật
    [Documentation]     người dùng chỉ có quyền Công nợ ĐTGH: Xem DS + Thêm mới + Cập nhật, Dối tác giao hàng: Xrm DS + Cập nhật, Công nợ NCC: Xem DS
    [Tags]      PQ4
    [Template]    pqcngh3
    userccngh3   123        PQDT002     75000    115000

Xem DS + Xóa
    [Documentation]     người dùng chỉ có quyền Công nợ ĐTGH: Xem DS + Xóa, Dối tác giao hàng: Xrm DS, Công nợ NCC: Xem DS
    [Tags]      PQ4
    [Template]    pqcngh4
    userccngh4    123        PQDT003     95000

*** Keywords ***
pqcngh1
    [Documentation]     người dùng chỉ có quyền Công nợ ĐTGH: Xem DS, Dối tác giao hàng: Xem DS
    [Arguments]    ${taikhoan}    ${matkhau}      ${input_ma_dtgh}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"Supplier_Read":false,"Supplier_Update":false,"SupplierAdjustment_Read":false,"SupplierAdjustment_Delete":false,"Clocking_Copy":false,"Supplier_Create":false,"Supplier_Delete":false,"Supplier_MobilePhone":false,"Supplier_Import":false,"Supplier_Export":false,"SupplierAdjustment_Create":false,"SupplierAdjustment_Update":false,"PartnerDelivery_Read":true,"DeliveryAdjustment_Read":true}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
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
    Search delivery partner           ${input_ma_dtgh}
    Element Should Not Be Visible      ${button_update_delivery}      20s
    Element Should Not Be Visible    ${button_update_delivery}
    Element Should Not Be Visible    ${button_delete_delivery}
    Element Should Be Visible    //a[@class='k-link'][contains(text(),'Nợ cần trả hiện tại')]        #cột nợ hiện tại
    Delete user    ${get_user_id}

pqcngh2
    [Documentation]     người dùng chỉ có quyền Công nợ ĐTGH: Xem DS + Thêm mới, Dối tác giao hàng: Xem DS
    [Arguments]    ${taikhoan}    ${matkhau}      ${input_ma_dtgh}     ${input_giatri}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_id_dtgh}     Get deliverypartner id frm api        ${input_ma_dtgh}
    Run Keyword If    ${get_id_dtgh}!=0       Delete DeliveryPartner    ${get_id_dtgh}
    Add partner delivery    ${input_ma_dtgh}     testqp    0985674589
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"DeliveryAdjustment_Read":true,"DeliveryAdjustment_Update":true,"PartnerDelivery_Read":true,"PartnerDelivery_Update":true,"Clocking_Copy":false}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"user4"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
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
    Search delivery partner     ${input_ma_dtgh}
    Wait Until Keyword Succeeds    3x    3s    Click Element    ${tab_nocantra_dtgh}
    Wait Until Page Contains Element    ${button_dieuchinh_congno}
    Click Element JS    ${button_dieuchinh_congno}
    Input data in popup Dieu chinh    ${input_giatri}    none
    Wait Until Keyword Succeeds    3 times    3s    Update data success validation
    Sleep    5s
    ${get_tong_hd_execute}    ${get_no_hientai_execute}    ${get_phi_giao_hang}      Get cong no DTGH frm API    ${input_ma_dtgh}
    Should Be Equal As Numbers    ${input_giatri}    ${get_no_hientai_execute}
    Delete user    ${get_user_id}
    Delete partner delivery    ${input_ma_dtgh}

pqcngh3
    [Documentation]     người dùng chỉ có quyền Công nợ ĐTGH: Xem DS + Cạp nhật, Dối tác giao hàng: Xem DS + Cạp nhật, Công nợ NCC: Xem DS
    [Arguments]    ${taikhoan}    ${matkhau}      ${input_ma_dtgh}     ${input_giatri}   ${input_giatri_new}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_id_dtgh}     Get deliverypartner id frm api        ${input_ma_dtgh}
    Run Keyword If    ${get_id_dtgh}!=0       Delete DeliveryPartner    ${get_id_dtgh}
    Add partner delivery    ${input_ma_dtgh}     testqp    0982674589
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"PartnerDelivery_Read":true,"PurchasePayment_Create":false,"PurchasePayment_Update":false,"PurchasePayment_Delete":false,"Clocking_Copy":false,"PartnerDelivery_Update":true,"DeliveryAdjustment_Read":true,"DeliveryAdjustment_Update":true,"SupplierAdjustment_Read":true}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    #
    ${get_ma_phieu}     Adapt Delivery Partner Dept        ${input_ma_dtgh}    ${input_giatri}
    Before Test Doi Tac Giao Hang
    Element Should Not Be Visible    ${menu_hh}
    Element Should Not Be Visible    ${menu_giaodich}
    Element Should Not Be Visible    ${domain_soquy}
    Element Should Not Be Visible    ${domain_baocao}
    Element Should Not Be Visible    ${menu_nhanvien}
    Element Should Not Be Visible    ${button_banhang_on_quanly}
    Search delivery partner     ${input_ma_dtgh}
    Wait Until Keyword Succeeds    3x    3s    Click Element    ${tab_nocantra_dtgh}
    ${cell_maphieu}     Format String       ${cell_ma_phieu_canbang}      ${get_ma_phieu}
    Wait Until Page Contains Element    ${cell_maphieu}       40s
    Click Element    ${cell_maphieu}
    Wait Until Page Contains Element    ${button_edit_dieuchinh_capnhat}      40s
    #Sleep    60s
    Click Element JS    ${button_edit_dieuchinh_capnhat}
    Wait Until Keyword Succeeds    3 times    3s    Update data success validation
    Delete user    ${get_user_id}
    Delete partner delivery    ${input_ma_dtgh}

pqcngh4
    [Documentation]     người dùng chỉ có quyền Công nợ ĐTGH: Xem DS + Xóa, Dối tác giao hàng: Xem DS + Cập nhật, , Công nợ NCC: Xem DS
    [Arguments]    ${taikhoan}    ${matkhau}      ${input_ma_dtgh}     ${input_giatri}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_id_dtgh}     Get deliverypartner id frm api        ${input_ma_dtgh}
    Run Keyword If    ${get_id_dtgh}!=0       Delete DeliveryPartner    ${get_id_dtgh}
    Add partner delivery    ${input_ma_dtgh}     testqp    0986578965
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"PartnerDelivery_Read":true,"PurchasePayment_Create":false,"PurchasePayment_Update":false,"PurchasePayment_Delete":false,"Clocking_Copy":false,"PartnerDelivery_Update":true,"DeliveryAdjustment_Read":true,"DeliveryAdjustment_Update":false,"SupplierAdjustment_Read":true,"DeliveryAdjustment_Delete":true}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    #
    ${get_ma_phieu}     Adapt Delivery Partner Dept        ${input_ma_dtgh}    ${input_giatri}
    Before Test Doi Tac Giao Hang
    Element Should Not Be Visible    ${menu_hh}
    Element Should Not Be Visible    ${menu_giaodich}
    Element Should Not Be Visible    ${domain_soquy}
    Element Should Not Be Visible    ${domain_baocao}
    Element Should Not Be Visible    ${menu_nhanvien}
    Element Should Not Be Visible    ${button_banhang_on_quanly}
    Search delivery partner     ${input_ma_dtgh}
    Wait Until Keyword Succeeds    3x    3s    Click Element    ${tab_nocantra_dtgh}
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
    Delete partner delivery      ${input_ma_dtgh}
