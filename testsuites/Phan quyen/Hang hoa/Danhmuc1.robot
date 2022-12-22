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
Xem DS
    [Documentation]     người dùng chỉ có quyền xem ds hàng hóa
    [Tags]      PQ
    [Template]    pqh1
    anh.nk    123   NHP032

Xem DS + Thêm mới
    [Documentation]     người dùng chỉ có quyền xem ds + thêm mới hàng hóa
    [Tags]      PQ
    [Template]    pqh2
    anh.nk    123      GreenCross       Dịch vụ           80000.6          2

Xem DS + Cập nhật
    [Documentation]     người dùng chỉ có quyền xem ds + cập nhật hàng hóa
    [Tags]      PQ
    [Template]    pqh3
    anh.nk    123      GreenCross       Dịch vụ           80000.6

Xem DS + Xóa hh
    [Documentation]     người dùng chỉ có quyền xem ds + xóa hàng hóa
    [Tags]      PQ
    [Template]    pqh4
    anh.nk    123

*** Keywords ***
pqh1
    [Documentation]     người dùng chỉ có quyền xem ds hàng hóa
    [Arguments]    ${taikhoan}    ${matkhau}     ${ma_hh}
    Log    Cập nhật quyền xem ds hh
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"Invoice_Read":false,"Invoice_Create":false,"Invoice_Update":false,"Invoice_Delete":false,"Order_Read":false,"Order_Create":false,"Order_Update":false,"Order_Delete":false,"Product_Read":true,"Return_Read":false,"Return_Create":false,"Return_Update":false,"Return_Delete":false,"TableAndRoom_Read":true,"TableAndRoom_Create":true,"TableAndRoom_Update":true,"TableAndRoom_Delete":true,"Order_RepeatPrint":false,"Order_Export":false,"Order_MakeInvoice":false,"Order_CopyOrder":false,"Order_UpdateWarranty":false,"Invoice_Export":false,"Invoice_ReadOnHand":false,"Invoice_ChangePrice":false,"Invoice_ChangeDiscount":false,"Invoice_ModifySeller":false,"Invoice_UpdateCompleted":false,"Invoice_RepeatPrint":false,"Invoice_CopyInvoice":false,"Invoice_UpdateWarranty":false,"Return_RepeatPrint":false,"Return_CopyReturn":false,"Return_Export":false,"Clocking_Copy":false}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    ${token_value}    ${resp.cookies}    Get BearerToken from API
    #
    Before Test Hang Hoa
    Sleep    3s
    ${endpoint_danhmuc_hh_co_dvt}   Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${get_list_hh}       Get raw data from API      ${endpoint_danhmuc_hh_co_dvt}     $..Code
    List Should Contain Value    ${get_list_hh}    ${ma_hh}
    Log    validate domain giao dịc, sổ quỹ, báo cáo, button bán hàng
    Element Should Not Be Visible    ${menu_giaodich}
    Element Should Not Be Visible    ${menu_doitac}
    Element Should Not Be Visible    ${domain_soquy}
    Element Should Not Be Visible    ${domain_baocao}
    Element Should Not Be Visible    ${button_banhang_on_quanly}
    Element Should Not Be Visible    ${button_them_moi}
    Element Should Not Be Visible    ${button_import_hh}
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

pqh2
    [Documentation]     người dùng chỉ có quyền xem ds + thêm mới hàng hóa
    [Arguments]    ${taikhoan}    ${matkhau}    ${ten_hanghoa}    ${nhom_hang}    ${giaban}      ${tonkho}
    Log    Cập nhật quyền xem ds + thêm mới hh
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"Product_Read":true,"TableAndRoom_Read":true,"TableAndRoom_Create":true,"TableAndRoom_Update":true,"TableAndRoom_Delete":true,"Clocking_Copy":false,"Product_Create":true}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}     ${taikhoan}
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
    Element Should Not Be Visible        ${textbox_giavon}
    Input Text    ${textbox_hh_giaban}    ${giaban}
    Element Should Be Visible    //input[@disabled="disabled"]
    Select Nhom Hang    ${nhom_hang}
    Click Element    ${button_luu}
    Wait Until Keyword Succeeds    3 times    3s    Product create success validation
    Sleep    15s
    Wait Until Keyword Succeeds    3 times    3s    Assert data in case create product    ${ma_hh}    ${ten_hanghoa}    ${nhom_hang}
    ...    0    0    ${giaban}
    Log    valdate button xuất file, ngừng kinh doanh, xóa ko hiển thị
    Search product code     ${ma_hh}
    Element Should Not Be Visible    ${button_capnhat_hh}
    Element Should Be Visible        ${button_in_tem_ma}
    Element Should Be Visible    ${button_sao_chep}
    Element Should Not Be Visible    ${button_ngungkinhdoanh}
    Element Should Not Be Visible    ${button_xoa_hh}
    Delete product thr API    ${ma_hh}
    Reload Page

pqh3
    [Documentation]     người dùng chỉ có quyền xem ds + cập nhật hàng hóa
    [Arguments]    ${taikhoan}    ${matkhau}    ${ten_hanghoa_up}    ${nhom_hang_up}    ${giaban_up}
    Log    Cập nhật quyền xem ds + cập nhật hh
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"Product_Read":true,"Product_Create":false,"Clocking_Copy":false,"Product_Update":true}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}     ${taikhoan}
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
    ${ma_hh}    Generate code automatically    HHT
    Add product thr API    ${ma_hh}    Bánh ngọt    Kẹo bánh    70000    40000    10
    Reload Page
    Search product code and click update product    ${ma_hh}
    ${mahh_up}    Generate code automatically    HHT
    Input Text    ${textbox_ma_hh}    ${mahh_up}
    Input Text    ${textbox_ten_hh}    ${ten_hanghoa_up}
    Element Should Not Be Visible        ${textbox_giavon}
    Input Text    ${textbox_hh_giaban}    ${giaban_up}
    Element Should Be Visible    //input[@disabled="disabled"]
    Select Nhom Hang    ${nhom_hang_up}
    Click Element    ${button_luu}
    Wait Until Keyword Succeeds    3 times    3s    Update data success validation
    Sleep    30s
    Wait Until Keyword Succeeds    3 times    3s    Assert data in case create product    ${mahh_up}    ${ten_hanghoa_up}    ${nhom_hang_up}
    ...    10    40000    ${giaban_up}
    Log    valdate button xuất file, ngừng kinh doanh, xóa ko hiển thị
    Search product code     ${mahh_up}
    Element Should Be Visible        ${button_capnhat_hh}
    Element Should Be Visible        ${button_in_tem_ma}
    Element Should Not Be Visible    ${button_sao_chep}
    Element Should Be Visible        ${button_ngungkinhdoanh}
    Element Should Not Be Visible    ${button_xoa_hh}
    Delete product thr API    ${mahh_up}
    Reload Page

pqh4
    [Documentation]     người dùng chỉ có quyền xem ds + xóa hàng hóa
    [Arguments]    ${taikhoan}    ${matkhau}
    Log    Cập nhật quyền xem ds + xóa hh
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"Product_Read":true,"Product_Update":false,"TableAndRoom_Read":true,"TableAndRoom_Create":true,"TableAndRoom_Update":true,"TableAndRoom_Delete":true,"Clocking_Copy":false,"Product_Delete":true}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}      ${taikhoan}
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
    ${ma_hh}    Generate code automatically    HHT
    Add product thr API    ${ma_hh}    Bánh ngọt    Kẹo bánh    70000    40000    0
    Reload Page
    Log    valdate button xuất file, ngừng kinh doanh, xóa ko hiển thị
    Search product code     ${ma_hh}
    Element Should Not Be Visible        ${button_capnhat_hh}
    Element Should Be Visible        ${button_in_tem_ma}
    Element Should Not Be Visible    ${button_sao_chep}
    Element Should Not Be Visible        ${button_ngungkinhdoanh}
    Element Should Be Visible    ${button_xoa_hh}
    Reload Page
    Search product code and delete product    ${ma_hh}
    Wait Until Keyword Succeeds    3 times    3s    Delete product success validation    ${ma_hh}
    Reload Page
