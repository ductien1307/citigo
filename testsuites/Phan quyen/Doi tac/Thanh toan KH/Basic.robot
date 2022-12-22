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
Resource          ../../../../core/API/api_mhbh.robot
Resource          ../../../../core/API/api_soquy.robot

*** Variables ***
&{dict_hh}     TPG16=5

*** Test Cases ***
Xem DS + Thêm mới
    [Documentation]     người dùng chỉ có quyền Thanh toán KH:Thêm mới, Khách hàng: Xrm DS, Công nợ KH: Xem DS
    [Tags]      PQ4
    [Template]    pqttkh1
    userttkh2    123          CTKH082     ${dict_hh}    50000     all

Xem DS + Cập nhật + Xóa
    [Documentation]     người dùng chỉ có quyền Thanh toán KH:Thêm mới + Cập nhật + Xóa, Khách hàng: Xrm DS, Công nợ KH: Xem DS
    [Tags]      PQ4
    [Template]    pqttkh2
    userttkh3   123        CTKH082     ${dict_hh}    35000

Xem DS + Cập nhật
    [Documentation]     người dùng chỉ có quyền Thanh toán KH: Cập nhật, Khách hàng: Xrm DS, Công nợ KH: Xem DS
    [Tags]      PQ4
    [Template]    pqttkh3
    userttkh4    123        CTKH082     ${dict_hh}    35000


*** Keywords ***
pqttkh1
    [Documentation]     người dùng chỉ có quyền Thanh toán KH: Thêm mới, KHách hàng: Xem DS, Công nợ KH: Xem DS
    [Arguments]    ${taikhoan}    ${matkhau}      ${input_ma_kh}    ${dict_product_nums}  ${input_khtt}     ${input_tien_thu}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"Customer_Read":true,"CustomerAdjustment_Read":true,"CustomerAdjustment_Create":false,"Clocking_Copy":false,"CustomerAdjustment_Update":false,"CustomerAdjustment_Delete":false,"Payment_Create":true}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    #
    ${get_ma_hd}    Add new invoice frm API    ${input_ma_kh}    ${dict_product_nums}  ${input_khtt}
    Before Test Doi Tac Khach Hang
    Element Should Not Be Visible    ${menu_hh}
    Element Should Not Be Visible    ${menu_giaodich}
    Element Should Not Be Visible    ${domain_soquy}
    Element Should Not Be Visible    ${domain_baocao}
    Element Should Not Be Visible    ${menu_nhanvien}
    Element Should Not Be Visible    ${button_banhang_on_quanly}
    #
    Search customer and go to tab No can thu tu khach    ${input_ma_kh}
    Wait Until Page Contains Element    ${button_thanhtoan_congno}
    Click Element JS    ${button_thanhtoan_congno}
    ${get_no_hd}    Get du no hoa don thr API    ${get_ma_hd}
    ${get_no_cuoi_kh}    Get Du no cuoi KH from API    ${input_ma_kh}
    ${result_tien_thu}    Set Variable If    '${input_tien_thu}'=='all'    ${get_no_hd}    ${input_tien_thu}
    ${result_tien_thu}    Run Keyword If    '${input_tien_thu}'=='all'    Replace floating point    ${result_tien_thu}
    ...    ELSE    Set Variable    ${input_tien_thu}
    ${result_no_af_ex}    Minus    ${get_no_cuoi_kh}    ${result_tien_thu}
    Wait Until Element Is Visible    ${textbox_thu_tu_khach_in_customer}    10s
    ${xp_thutien}    Format String    ${textbox_tien_thu_theo_hoadon}    ${get_ma_hd}
    Input Text    ${xp_thutien}    ${result_tien_thu}
    Click Element JS    ${button_tao_phieu_thu_in_customer}
    Wait Until Keyword Succeeds    3 times    3s    Update data success validation
    ${actual_tien_thu}    Minus    0    ${result_tien_thu}
    ${get_ma_phieu}    ${get_giatri}    ${get_du_no}    Get ma phieu, gia tri, du no in tab No can thu tu khach    ${input_ma_kh}
    Should Be Equal As Numbers    ${get_giatri}    ${actual_tien_thu}
    Should Be Equal As Numbers    ${get_du_no}    ${result_no_af_ex}
    ${get_id_kh}    Get customer id thr API    ${input_ma_kh}
    ${get_actual_giatri}    ${get_loaithutien}    ${get_actual_id_kh}    Get payment detail in tab Tong quy thr API    ${get_ma_phieu}
    Should Be Equal As Numbers    ${get_actual_giatri}    ${result_tien_thu}
    Should Be Equal As Numbers    ${get_actual_id_kh}    ${get_id_kh}
    Should Be Equal As Strings    ${get_loaithutien}    Tiền khách trả

pqttkh2
    [Documentation]     người dùng chỉ có quyền Thanh toán KH: Cập nhật + Xóa, KHách hàng: Xem DS, Công nợ KH: Xem DS
    [Arguments]    ${taikhoan}    ${matkhau}      ${input_ma_kh}    ${dict_product_nums}  ${input_khtt}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_ma_hd}    Add new invoice frm API    ${input_ma_kh}    ${dict_product_nums}  ${input_khtt}
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"Customer_Read":true,"CustomerAdjustment_Read":true,"Payment_Create":false,"Clocking_Copy":false,"Payment_Delete":true,"Payment_Update":true}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    #
    ${get_ma_phieu_tt}      Put unpaid value for invoice    ${input_ma_kh}    ${get_ma_hd}
    Before Test Doi Tac Khach Hang
    Element Should Not Be Visible    ${menu_hh}
    Element Should Not Be Visible    ${menu_giaodich}
    Element Should Not Be Visible    ${domain_soquy}
    Element Should Not Be Visible    ${domain_baocao}
    Element Should Not Be Visible    ${menu_nhanvien}
    Element Should Not Be Visible    ${button_banhang_on_quanly}
    #
    Search customer and go to tab No can thu tu khach    ${input_ma_kh}
    ${cell_maphieu}     Format string       ${cell_ma_phieu_canbang}      ${get_ma_phieu_tt}
    Wait Until Page Contains Element    ${cell_maphieu}       20s
    Click Element      ${cell_maphieu}
    Wait Until Page Contains Element    ${button_capnhat_phieutt}       20s
    Click Element      ${button_capnhat_phieutt}
    Wait Until Page Contains Element    ${toast_message}        30s
    Element Should Contain    ${toast_message}    ${get_ma_phieu_tt} được cập nhật thành công
    Delete user    ${get_user_id}

pqttkh3
    [Documentation]     người dùng chỉ có quyền Thanh toán KH: Cập nhật, KHách hàng: Xem DS, Công nợ KH: Xem DS
    [Arguments]    ${taikhoan}    ${matkhau}      ${input_ma_kh}    ${dict_product_nums}  ${input_khtt}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_ma_hd}    Add new invoice frm API    ${input_ma_kh}    ${dict_product_nums}  ${input_khtt}
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"Customer_Read":true,"CustomerAdjustment_Read":true,"Payment_Create":false,"Clocking_Copy":false,"Payment_Delete":false,"Payment_Update":true}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    #
    ${get_ma_phieu_tt}      Put unpaid value for invoice    ${input_ma_kh}    ${get_ma_hd}
    Before Test Doi Tac Khach Hang
    Element Should Not Be Visible    ${menu_hh}
    Element Should Not Be Visible    ${menu_giaodich}
    Element Should Not Be Visible    ${domain_soquy}
    Element Should Not Be Visible    ${domain_baocao}
    Element Should Not Be Visible    ${menu_nhanvien}
    Element Should Not Be Visible    ${button_banhang_on_quanly}
    #
    Search customer and go to tab No can thu tu khach    ${input_ma_kh}
    ${cell_maphieu}     Format string       ${cell_ma_phieu_canbang}      ${get_ma_phieu_tt}
    Wait Until Page Contains Element    ${cell_maphieu}       20s
    Click Element      ${cell_maphieu}
    Wait Until Page Contains Element    ${button_capnhat_phieutt}       20s
    Element Should Not Be Visible    ${button_huybo_phieutt}
    Click Element      ${button_capnhat_phieutt}
    Wait Until Page Contains Element    ${toast_message}        30s
    Element Should Contain    ${toast_message}       Phiếu thu ${get_ma_phieu_tt} được cập nhật thành công
    Delete user    ${get_user_id}
