*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    ${headless_browser}
Test Setup
Test Teardown     After Test
Library           Collections
Resource          ../../../config/env_product/envi.robot
Resource          ../../../core/hang_hoa/hang_hoa_navigation.robot
Resource          ../../../core/hang_hoa/hang_hoa_add_action.robot
Resource          ../../../core/hang_hoa/danh_muc_list_action.robot
Resource          ../../../core/share/computation.robot
Resource          ../../../core/Giao_dich/giaodich_nav.robot
Resource          ../../../core/API/api_danhmuc_hanghoa.robot
Resource          ../../../core/API/api_thietlap.robot
Resource          ../../../core/Doi_Tac/doitac_navigation.robot
Resource          ../../../core/Giao_dich/giaodich_nav.robot
Resource          ../../../core/So_Quy/so_quy_navigation.robot
Resource          ../../../core/Bao_cao/bao_cao_navigation.robot
Resource          ../../../core/share/toast_message.robot
Resource          ../../../core/Giao_dich/nhaphang_getandcompute.robot

*** Variables ***

*** Test Cases ***
Xem DS + Thêm mới + Giá vốn
    [Documentation]     người dùng chỉ có quyền xem ds + thêm mới hàng hóa, giá vỗn
    [Tags]      PQ
    [Template]    pqh5
    manh.nd    123      GreenCross       Dịch vụ           150000          80000.6          2

Xem DS + Import
    [Documentation]     người dùng chỉ có quyền xem ds hàng hóa + import
    [Tags]      PQ
    [Template]    pqh6
    manh.nd    123   NHP032

Xem DS + Xuất file
    [Documentation]     người dùng chỉ có quyền xem ds hàng hóa + xuất file
    [Tags]      PQ
    [Template]    pqh7
    manh.nd    123   NHP032

*** Keywords ***
pqh5
    [Documentation]     người dùng chỉ có quyền xem ds + thêm mới hàng hóa, giá vỗn
    [Arguments]    ${taikhoan}    ${matkhau}    ${ten_hanghoa}    ${nhom_hang}    ${giaban}     ${giavon}     ${tonkho}
    Log    Cập nhật quyền xem ds + thêm mới hh + giã vỗn
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"Product_Read":true,"Product_Create":true,"TableAndRoom_Read":true,"TableAndRoom_Create":true,"TableAndRoom_Update":true,"TableAndRoom_Delete":true,"Product_PurchasePrice":false,"Clocking_Copy":false,"Product_Cost":true}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{0}","CompareUserName":"{0}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}     ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    #
    Before Test Hang Hoa
    Sleep    3s
    Log    validate domain giao dịc, sổ quỹ, báo cáo, button bán hàng
    Element Should Not Be Visible    ${menu_giaodich}
    Element Should Not Be Visible    ${menu_doitac}
    Element Should Not Be Visible    ${domain_soquy}
    Element Should Not Be Visible    ${domain_baocao}
    Element Should Not Be Visible    ${button_banhang_on_quanly}
    Element Should Not Be Visible    ${button_import_hh}
    Element Should Not Be Visible    ${button_xuatfile_hh}
    Log    validate thiết lập giá, sx, kiểm kho ko hiển thị
    Click Element    ${menu_hh}
    Sleep    2s
    Element Should Not Be Visible    ${domain_thietlapgia}
    Element Should Not Be Visible    ${domain_kiemkho}
    Element Should Not Be Visible    ${domain_sanxuat}
    #
    Log    thêm mới hh
    Go to Them moi Hang Hoa
    ${ma_hh}    Generate code automatically    HHT
    Set Selenium Speed    0.6 seconds
    Input Text    ${textbox_ma_hh}    ${ma_hh}
    Input Text    ${textbox_ten_hh}    ${ten_hanghoa}
    Input Text    ${textbox_hh_giaban}    ${giaban}
    Input Text    ${textbox_giavon}    ${giavon}
    #ton kho bị disabled
    Element Should Be Visible    //input[@disabled="disabled"]
    Select Nhom Hang    ${nhom_hang}
    Click Element    ${button_luu}
    Wait Until Page Contains Element        ${button_dongy_apdung_giavon}     20s
    Wait Until Keyword Succeeds    3 times    1s      Click Element   ${button_dongy_apdung_giavon}
    Wait Until Keyword Succeeds    3 times    3s    Product create success validation
    Sleep    15s
    Wait Until Keyword Succeeds    3 times    3s    Assert data in case create product    ${ma_hh}    ${ten_hanghoa}    ${nhom_hang}
    ...    0    ${giavon}    ${giaban}
    Log    valdate button xuất file, ngừng kinh doanh, xóa ko hiển thị
    Search product code     ${ma_hh}
    Element Should Not Be Visible    ${button_capnhat_hh}
    Element Should Be Visible        ${button_in_tem_ma}
    Element Should Be Visible    ${button_sao_chep}
    Element Should Not Be Visible    ${button_ngungkinhdoanh}
    Element Should Not Be Visible    ${button_xoa_hh}
    Delete product thr API    ${ma_hh}
    Reload Page

pqh6
    [Documentation]     người dùng chỉ có quyền xem ds hàng hóa + import
    [Arguments]    ${taikhoan}    ${matkhau}     ${ma_hh}
    Log    Cập nhật quyền xem ds hh + import
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"Invoice_Read":false,"Invoice_Create":false,"Invoice_Update":false,"Invoice_Delete":false,"Order_Read":false,"Order_Create":false,"Order_Update":false,"Order_Delete":false,"Product_Read":true,"Return_Read":false,"Return_Create":false,"Return_Update":false,"Return_Delete":false,"TableAndRoom_Read":true,"TableAndRoom_Create":true,"TableAndRoom_Update":true,"TableAndRoom_Delete":true,"Order_RepeatPrint":false,"Order_Export":false,"Order_MakeInvoice":false,"Order_CopyOrder":false,"Order_UpdateWarranty":false,"Invoice_Export":false,"Invoice_ReadOnHand":false,"Invoice_ChangePrice":false,"Invoice_ChangeDiscount":false,"Invoice_ModifySeller":false,"Invoice_UpdateCompleted":false,"Invoice_RepeatPrint":false,"Invoice_CopyInvoice":false,"Invoice_UpdateWarranty":false,"Return_RepeatPrint":false,"Return_CopyReturn":false,"Return_Export":false,"Clocking_Copy":false}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}       ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    #
    Before Test Hang Hoa
    Sleep    3s
    ${endpoint_danhmuc_hh_co_dvt}   Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${get_list_hh}       Get raw data from API      ${endpoint_danhmuc_hh_co_dvt}     $..Code
    List Should Contain Value    ${get_list_hh}    ${ma_hh}
    Log    validate domain giao dịch, sổ quỹ, báo cáo, button bán hàng
    Element Should Not Be Visible    ${menu_giaodich}
    Element Should Not Be Visible    ${menu_doitac}
    Element Should Not Be Visible    ${domain_soquy}
    Element Should Not Be Visible    ${domain_baocao}
    Element Should Not Be Visible    ${button_banhang_on_quanly}
    Element Should Not Be Visible    ${button_them_moi}
    Element Should Be Enabled        ${button_import_hh}
    Element Should Not Be Visible    ${button_xuatfile_hh}
    Log    valdate button xuất file, ngừng kinh doanh, xóa ko hiển thị
    Search product code    ${ma_hh}
    Element Should Not Be Visible    ${button_capnhat_hh}
    Element Should Be Visible        ${button_in_tem_ma}
    Element Should Not Be Visible    ${button_sao_chep}
    Element Should Not Be Visible    ${button_ngungkinhdoanh}
    Element Should Not Be Visible    ${button_xoa_hh}
    Log    validate thiết lập giá, sx, kiểm kho ko hiển thị
    Click Element    ${menu_hh}
    Sleep    2s
    Element Should Not Be Visible    ${domain_thietlapgia}
    Element Should Not Be Visible    ${domain_kiemkho}
    Element Should Not Be Visible    ${domain_sanxuat}
    Reload Page

pqh7
    [Documentation]     người dùng chỉ có quyền xem ds hàng hóa + xuất file
    [Arguments]    ${taikhoan}    ${matkhau}     ${ma_hh}
    Log    Cập nhật quyền xem ds hh + xuất file
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"Product_Read":true,"TableAndRoom_Read":true,"TableAndRoom_Create":true,"TableAndRoom_Update":true,"TableAndRoom_Delete":true,"Clocking_Copy":false,"Product_Export":true}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}     ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    #
    Before Test Hang Hoa
    Sleep    3s
    ${endpoint_danhmuc_hh_co_dvt}   Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${get_list_hh}       Get raw data from API      ${endpoint_danhmuc_hh_co_dvt}     $..Code
    List Should Contain Value    ${get_list_hh}    ${ma_hh}
    Log    validate domain giao dịch, sổ quỹ, báo cáo, button bán hàng
    Element Should Not Be Visible    ${menu_giaodich}
    Element Should Not Be Visible    ${menu_doitac}
    Element Should Not Be Visible    ${domain_soquy}
    Element Should Not Be Visible    ${domain_baocao}
    Element Should Not Be Visible    ${button_banhang_on_quanly}
    Element Should Not Be Visible    ${button_them_moi}
    Element Should Not Be Visible    ${button_import_hh}
    Element Should Be Enabled        ${button_xuatfile_hh}
    Log    valdate button xuất file, ngừng kinh doanh, xóa ko hiển thị
    Search product code    ${ma_hh}
    Element Should Not Be Visible    ${button_capnhat_hh}
    Element Should Be Visible        ${button_in_tem_ma}
    Element Should Not Be Visible    ${button_sao_chep}
    Element Should Not Be Visible    ${button_ngungkinhdoanh}
    Element Should Not Be Visible    ${button_xoa_hh}
    Log    validate thiết lập giá, sx, kiểm kho ko hiển thị
    Click Element    ${menu_hh}
    Sleep    2s
    Element Should Not Be Visible    ${domain_thietlapgia}
    Element Should Not Be Visible    ${domain_kiemkho}
    Element Should Not Be Visible    ${domain_sanxuat}
    Reload Page
