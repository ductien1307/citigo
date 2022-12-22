*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    ${headless_browser}
Test Setup
Test Teardown     After Test
Library           Collections
Library           SeleniumLibrary
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
Resource          ../../../prepare/Hang_hoa/Sources/thietlap.robot
Resource          ../../../core/Nhan_vien/nhanvien_navigation.robot
Resource          ../../../core/Thiet_lap/thiet_lap_nav.robot
Resource          ../../../core/Thiet_lap/thukhac_list_action.robot

*** Variables ***

*** Test Cases ***
Xem DS
    [Documentation]     người dùng chỉ có quyền Thu khác: Xem DS
    [Tags]      PQ1
    [Template]    pqtk1
    usertk1    123     TK02

Xem DS + Thêm mới
    [Documentation]     người dùng chỉ có quyền Thu khác: Xem DS + Thêm mới
    [Tags]      PQ1
    [Template]    pqtk2
    usertk2    123    TKPQ4         Phí abc     200000         true           none              false                      false

Xem DS + Cập nhật
    [Documentation]     người dùng chỉ có quyền Thu khác: Xem DS + Cập nhật
    [Tags]      PQ1
    [Template]    pqtk3
    usertk3    123      TKPQ2      Phí new 2          20            9                        false                      true             true                  20000            true

Xem DS + Xóa
    [Documentation]     người dùng chỉ có quyền Thu khác Xem DS + Xóa
    [Tags]      PQ1
    [Template]    pqtk4
    usertk4    123     TKPQ3           Phí new           20000            9                        true                  false

*** Keywords ***
pqtk1
    [Documentation]     người dùng chỉ có quyền Thu khác: Xem DS
    [Arguments]    ${taikhoan}    ${matkhau}    ${input_thukhac}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"Branch_Read":false,"Branch_Delete":false,"Clocking_Copy":false,"Branch_Create":false,"Branch_Update":false,"Surcharge_Read":true,"Surcharge_Update":false}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    Before Test Quan ly
    #
    Log    validate UI
    Element Should Not Be Visible    ${menu_giaodich}
    Element Should Not Be Visible    ${menu_hh}
    Element Should Not Be Visible    ${menu_doitac}
    Element Should Not Be Visible    ${menu_nhanvien}
    Element Should Not Be Visible    ${menu_soquy}
    Element Should Not Be Visible    ${domain_baocao}
    Element Should Not Be Visible    ${button_banhang_on_quanly}
    #
    Go to any thiet lap    ${button_quanly_thukhac}
    Wait Until Element Is Visible    ${textbox_search_surcharge}     10s
    Element Should Not Be Visible      ${button_themmoi_all_form}
    Input data    ${textbox_search_surcharge}    ${input_thukhac}
    Wait Until Element Is Visible    ${checkbox_filter_luachonhienthi_tatca}
    Click Element    ${checkbox_filter_luachonhienthi_tatca}
    Sleep   1s
    Element Should Not Be Visible    ${button_capnhat_surcharge}
    Element Should Not Be Visible    ${button_delete_surcharge}
    Element Should Not Be Visible    ${button_active_surcharge}
    Delete user    ${get_user_id}

pqtk2
    [Documentation]     người dùng chỉ có quyền Thu khác: Xem DS + Thêm mới
    [Arguments]    ${taikhoan}    ${matkhau}     ${input_ma_tk}   ${input_loaithu}   ${input_giatri}    ${input_chinhanh}  ${input_thutu_hienthi}    ${tudong_hoadon}    ${hoantra_trahang}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"Branch_Read":false,"Branch_Delete":false,"Clocking_Copy":false,"Branch_Create":false,"Branch_Update":false,"Surcharge_Read":true,"Surcharge_Update":false,"Surcharge_Create":true}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    Before Test Quan ly
    #
    Log    validate UI
    Element Should Not Be Visible    ${menu_giaodich}
    Element Should Not Be Visible    ${menu_hh}
    Element Should Not Be Visible    ${menu_doitac}
    Element Should Not Be Visible    ${menu_nhanvien}
    Element Should Not Be Visible    ${menu_soquy}
    Element Should Not Be Visible    ${domain_baocao}
    Element Should Not Be Visible    ${button_banhang_on_quanly}
    #
    ${get_id_surcharge}    Get surcharge id frm API    ${input_ma_tk}
    Run Keyword If    '${get_id_surcharge}' == '0'    Log    Ignore     ELSE    Delete surcharge    ${get_id_surcharge}
    Go to any thiet lap    ${button_quanly_thukhac}
    Wait Until Element Is Visible    ${button_themmoi_all_form}     10s
    Click Element JS   ${button_themmoi_all_form}
    Sleep    1s
    Input text    ${textbox_surcharge_mathukhac}   ${input_ma_tk}
    Input text     ${textbox_surcharge_loaithu}   ${input_loaithu}
    Run Keyword If   0 < ${input_giatri} < 100   Select value any form    ${icon_giatri_%}     ${textbox_surcharge_giatri}   ${input_giatri}    ELSE       Input text     ${textbox_surcharge_giatri}   ${input_giatri}
    Run Keyword If    '${input_chinhanh}' == 'true'    Log     Ignore click    ELSE      Select branch in add surcharge popup    ${input_chinhanh}
    Run Keyword If    '${input_thutu_hienthi}' == 'none'    Log     Ignore input    ELSE      Input text     ${textbox_surcharge_thutuhienthi}   ${input_thutu_hienthi}
    Run Keyword If    '${tudong_hoadon}' == 'true'    Log     Ignore click    ELSE      Click Element JS    ${checkbox_surcharge_tudong_hoadon}
    Run Keyword If    '${hoantra_trahang}' == 'false'    Log     Ignore click    ELSE      Click Element JS    ${checkbox_surcharge_hoanlai_trahang}
    Click Element JS        ${button_surcharge_save}
    Surcharge create success validation
    Wait Until Keyword Succeeds    3x    5x    Get surcharge info and validate    ${input_ma_tk}    ${input_loaithu}    ${input_giatri}    ${input_chinhanh}    ${tudong_hoadon}    ${hoantra_trahang}
    ${get_surcharge_id}    Get surcharge id frm API    ${input_ma_tk}
    Delete surcharge    ${get_surcharge_id}
    Delete user    ${get_user_id}

pqtk3
    [Documentation]     người dùng chỉ có quyền Thu khác: Xem DS + Cập nhật
    [Arguments]    ${taikhoan}    ${matkhau}    ${input_ma_tk}   ${input_loaithu}   ${input_giatri}  ${input_thutu_hienthi}    ${tudong_hoadon}    ${hoantra_trahang}
    ...     ${input_tudong_hd_new}    ${input_giatri_new}    ${surcharge_chinhanh}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"Branch_Read":false,"Branch_Delete":false,"Clocking_Copy":false,"Branch_Create":false,"Branch_Update":false,"Surcharge_Read":true,"Surcharge_Update":true,"Surcharge_Create":false}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    Before Test Quan ly
    #
    Log    validate UI
    Element Should Not Be Visible    ${menu_giaodich}
    Element Should Not Be Visible    ${menu_hh}
    Element Should Not Be Visible    ${menu_doitac}
    Element Should Not Be Visible    ${menu_nhanvien}
    Element Should Not Be Visible    ${menu_soquy}
    Element Should Not Be Visible    ${domain_baocao}
    Element Should Not Be Visible    ${button_banhang_on_quanly}
    #
    ${get_id_surcharge}    Get surcharge id frm API    ${input_ma_tk}
    Run Keyword If    '${get_id_surcharge}' == '0'    Log    Ignore     ELSE    Delete Surcharge    ${get_id_surcharge}
    Create new Surcharge by percentage    ${input_ma_tk}   ${input_loaithu}    ${input_giatri}    ${input_thutu_hienthi}    ${tudong_hoadon}
    ...    ${hoantra_trahang}
    Go to any thiet lap    ${button_quanly_thukhac}
    Element Should Not Be Visible   ${button_themmoi_all_form}
    #
    Go to update surcharge form    ${input_ma_tk}
    Element Should Be Visible        ${button_active_surcharge}
    Run Keyword If   0 < ${input_giatri_new} < 100   Select value any form    ${icon_giatri_%}     ${textbox_surcharge_giatri}   ${input_giatri_new}
    ...    ELSE     Select value any form    ${icon_giatri_vnd}     ${textbox_surcharge_giatri}   ${input_giatri_new}
    Run Keyword If    '${tudong_hoadon}' == 'true'    Log     Ignore click    ELSE      Click Element JS    ${checkbox_surcharge_tudong_hoadon}
    Click Element JS        ${button_surcharge_save}
    Surcharge create success validation
    ${get_surcharge_id}    Get surcharge id frm API    ${input_ma_tk}
    Delete surcharge    ${get_surcharge_id}
    Delete user    ${get_user_id}

pqtk4
    [Documentation]     người dùng chỉ có quyền Thu khác: Xem DS + Xóa
    [Arguments]    ${taikhoan}    ${matkhau}     ${input_ma_tk}   ${input_loaithu}   ${input_giatri}  ${input_thutu_hienthi}    ${tudong_hoadon}    ${hoantra_trahang}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"Surcharge_Read":true,"Surcharge_Update":false,"Clocking_Copy":false,"Surcharge_Delete":true}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    Before Test Quan ly
    #
    Log    validate UI
    Element Should Not Be Visible    ${menu_giaodich}
    Element Should Not Be Visible    ${menu_hh}
    Element Should Not Be Visible    ${menu_doitac}
    Element Should Not Be Visible    ${menu_nhanvien}
    Element Should Not Be Visible    ${menu_soquy}
    Element Should Not Be Visible    ${domain_baocao}
    Element Should Not Be Visible    ${button_banhang_on_quanly}
    #
    ${get_id_surcharge}    Get surcharge id frm API    ${input_ma_tk}
    Run Keyword If    '${get_id_surcharge}' == '0'    Log    Ignore     ELSE    Delete surcharge    ${get_id_surcharge}
    Create new Surcharge by percentage    ${input_ma_tk}   ${input_loaithu}    ${input_giatri}    ${input_thutu_hienthi}    ${tudong_hoadon}
    ...    ${hoantra_trahang}
    Go to any thiet lap    ${button_quanly_thukhac}
    Element Should Not Be Visible   ${button_themmoi_all_form}
    #
    Wait Until Element Is Visible    ${textbox_search_surcharge}
    Input data    ${textbox_search_surcharge}    ${input_ma_tk}
    Wait Until Element Is Visible    ${checkbox_filter_luachonhienthi_tatca}
    Click Element JS    ${checkbox_filter_luachonhienthi_tatca}
    Sleep    1s
    Wait Until Element Is Visible    ${button_delete_surcharge}
    Element Should Not Be Visible    ${button_active_surcharge}
    Element Should Not Be Visible    ${button_capnhat_surcharge}
    Click Element JS    ${button_delete_surcharge}
    Wait Until Element Is Visible    ${button_dongy_del_promo}
    Click Element JS    ${button_dongy_del_promo}
    Delete data success validation
    Delete user    ${get_user_id}
