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
Xem DS
    [Documentation]     người dùng chỉ có quyền Công nợ KH: Xem DS, KHách hàng: Xem DS
    [Tags]        PQ4
    [Template]    pqcnkh1
    usercnkh1    123       CTKH006

Xem DS + Thêm mới
    [Documentation]     người dùng chỉ có quyền Công nợ KH: Xem DS + Thêm mới, Khách hàng: Xrm DS
    [Tags]        PQ4
    [Template]    pqcnkh2
    usercnkh2    123          CTKH081     120000    none

Xem DS + Cập nhật
    [Documentation]     người dùng chỉ có quyền Công nợ KH: Xem DS + Thêm mới + Cập nhật, Khách hàng: Xrm DS
    [Tags]        PQ4
    [Template]    pqcnkh3
    usercnkh3   123        CTKH081     75000    150000

Xem DS + Xóa
    [Documentation]     người dùng chỉ có quyền Công nợ KH: Xem DS + Xóa, Khách hàng: Xrm DS
    [Tags]        PQ4
    [Template]    pqcnkh4
    usercnkh4    123        CTKH081     95000

*** Keywords ***
pqcnkh1
    [Documentation]     người dùng chỉ có quyền Công nợ KH: Xem DS, KHách hàng: Xem DS
    [Arguments]    ${taikhoan}    ${matkhau}      ${input_ma_kh}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"PartnerDelivery_Read":false,"PartnerDelivery_Create":false,"Clocking_Copy":false,"PartnerDelivery_Update":false,"PartnerDelivery_Delete":false,"PartnerDelivery_Import":false,"PartnerDelivery_Export":false,"CustomerAdjustment_Read":true,"Customer_Read":true,"Customer_Create":false,"Customer_Update":false,"Customer_Delete":false,"Customer_ViewPhone":false,"Customer_Import":false,"Customer_Export":false,"Customer_UpdateGroup":false,"CustomerAdjustment_Create":false,"CustomerAdjustment_Update":false,"CustomerAdjustment_Delete":false}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
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
    Element Should Not Be Visible      ${button_active_customer}      20s
    Element Should Not Be Visible    ${button_update_customer}
    Element Should Not Be Visible    ${button_delete_customer}
    Element Should Be Visible    //a[@class='k-link'][contains(text(),'Nợ hiện tại')]         #cột nợ hiện tại
    Delete user    ${get_user_id}

pqcnkh2
    [Documentation]     người dùng chỉ có quyền Công nợ KH: Xem DS + Thêm mới, KHách hàng: Xem DS
    [Arguments]    ${taikhoan}    ${matkhau}      ${input_ma_kh}    ${input_giatri}    ${mo_ta}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_id_kh}      Get Customer ID    ${input_ma_kh}
    Run Keyword If    ${get_id_kh}!=0        Delete customer    ${get_id_kh}
    Add customers    ${input_ma_kh}    testqp    0987546542    abc
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"PartnerDelivery_Read":false,"PartnerDelivery_Create":false,"Clocking_Copy":false,"PartnerDelivery_Update":false,"PartnerDelivery_Delete":false,"PartnerDelivery_Import":false,"PartnerDelivery_Export":false,"CustomerAdjustment_Read":true,"Customer_Read":true,"Customer_Create":false,"Customer_Update":false,"Customer_Delete":false,"Customer_ViewPhone":false,"Customer_Import":false,"Customer_Export":false,"Customer_UpdateGroup":false,"CustomerAdjustment_Create":true,"CustomerAdjustment_Update":false,"CustomerAdjustment_Delete":false}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
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
    #
    Search customer and go to tab No can thu tu khach    ${input_ma_kh}
    Wait Until Page Contains Element    ${button_dieuchinh_congno}
    Click Element JS    ${button_dieuchinh_congno}
    Input data in popup Dieu chinh    ${input_giatri}    ${mo_ta}
    Wait Until Keyword Succeeds    3 times    3s    Update data success validation
    Sleep    5s
    ${get_ma_phieu}     ${get_giatri}     ${get_du_no}      Get ma phieu, gia tri, du no in tab No can thu tu khach    ${input_ma_kh}
    Should Be Equal As Numbers    ${input_giatri}    ${get_du_no}
    Delete customer by Customer Code    ${input_ma_kh}
    Delete user    ${get_user_id}

pqcnkh3
    [Documentation]     người dùng chỉ có quyền Công nợ KH: Xem DS + Thêm mới + Cập nhật, KHách hàng: Xem DS
    [Arguments]    ${taikhoan}    ${matkhau}      ${input_ma_kh}    ${input_giatri}   ${input_giatri_new}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_id_kh}      Get Customer ID    ${input_ma_kh}
    Run Keyword If    ${get_id_kh}!=0        Delete customer    ${get_id_kh}
    Add customers    ${input_ma_kh}    testqp    0987546592    abc
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"Customer_Read":true,"CustomerAdjustment_Read":true,"CustomerAdjustment_Create":true,"Clocking_Copy":false,"CustomerAdjustment_Update":true}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    #
    ${get_ma_phieu}     Adapt Customer Dept    ${input_ma_kh}    ${input_giatri}
    Before Test Doi Tac Khach Hang
    Element Should Not Be Visible    ${menu_hh}
    Element Should Not Be Visible    ${menu_giaodich}
    Element Should Not Be Visible    ${domain_soquy}
    Element Should Not Be Visible    ${domain_baocao}
    Element Should Not Be Visible    ${menu_nhanvien}
    Element Should Not Be Visible    ${button_banhang_on_quanly}
    #
    Search customer and go to tab No can thu tu khach    ${input_ma_kh}
    ${cell_maphieu}     Format String       ${cell_ma_phieu_canbang}      ${get_ma_phieu}
    Wait Until Page Contains Element    ${cell_maphieu}       40s
    Click Element    ${cell_maphieu}
    Wait Until Page Contains Element    ${button_edit_dieuchinh_capnhat}      40s
    Element Should Not Be Visible    ${button_huybo_dieuchinh}
    Sleep    60s
    Click Element JS    ${button_edit_dieuchinh_capnhat}
    Wait Until Keyword Succeeds    3 times    3s    Update data success validation
    Delete customer by Customer Code    ${input_ma_kh}
    Delete user    ${get_user_id}

pqcnkh4
    [Documentation]     người dùng chỉ có quyền Công nợ KH: Xem DS + Xóa, KHách hàng: Xem DS
    [Arguments]    ${taikhoan}    ${matkhau}      ${input_ma_kh}    ${input_giatri}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_id_kh}      Get Customer ID    ${input_ma_kh}
    Run Keyword If    ${get_id_kh}!=0        Delete customer    ${get_id_kh}
    Add customers    ${input_ma_kh}    testqp    0987536542    abc
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"Customer_Read":true,"CustomerAdjustment_Read":true,"CustomerAdjustment_Create":true,"Clocking_Copy":false,"CustomerAdjustment_Update":false,"CustomerAdjustment_Delete":true}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    #
    ${get_ma_phieu}     Adapt Customer Dept    ${input_ma_kh}    ${input_giatri}
    Before Test Doi Tac Khach Hang
    Element Should Not Be Visible    ${menu_hh}
    Element Should Not Be Visible    ${menu_giaodich}
    Element Should Not Be Visible    ${domain_soquy}
    Element Should Not Be Visible    ${domain_baocao}
    Element Should Not Be Visible    ${menu_nhanvien}
    Element Should Not Be Visible    ${button_banhang_on_quanly}
    #
    Search customer and go to tab No can thu tu khach    ${input_ma_kh}
    ${cell_maphieu}     Format String       ${cell_ma_phieu_canbang}      ${get_ma_phieu}
    Wait Until Page Contains Element    ${cell_maphieu}       40s
    Click Element    ${cell_maphieu}
    Wait Until Page Contains Element    ${button_huybo_dieuchinh}      40s
    Click Element JS    ${button_huybo_dieuchinh}
    Wait Until Page Contains Element    ${button_dongy_huybo_dieuchinh}      40s
    Click Element JS    ${button_dongy_huybo_dieuchinh}
    Wait Until Page Contains Element    ${toast_message}      40s
    Element Should Contain    ${toast_message}      Xóa điều chỉnh công nợ thành công
    Delete customer by Customer Code    ${input_ma_kh}
    Delete user    ${get_user_id}
