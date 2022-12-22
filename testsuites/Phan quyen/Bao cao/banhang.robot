*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    ${headless_browser}
Test Setup
Test Teardown     After Test
Library           Collections
Library           SeleniumLibrary
Resource          ../../../config/env_product/envi.robot
Resource          ../../../core/hang_hoa/hang_hoa_navigation.robot
Resource          ../../../core/share/computation.robot
Resource          ../../../core/Giao_dich/giaodich_nav.robot
Resource          ../../../core/API/api_thietlap.robot
Resource          ../../../core/Doi_Tac/doitac_navigation.robot
Resource          ../../../core/Giao_dich/giaodich_nav.robot
Resource          ../../../core/So_Quy/so_quy_navigation.robot
Resource          ../../../core/Bao_cao/bao_cao_navigation.robot
Resource          ../../../core/share/toast_message.robot
Resource          ../../../prepare/Hang_hoa/Sources/thietlap.robot
Resource          ../../../core/Nhan_vien/nhanvien_navigation.robot
Resource          ../../../core/Thiet_lap/thiet_lap_nav.robot
Resource          ../../../core/Bao_cao/bc_cuoi_ngay_list_action.robot

*** Variables ***

*** Test Cases ***
BC Bán hàng - Nhân viên
    [Documentation]     người dùng chỉ có quyền BC Bán hàng: Nhân viên
    [Tags]       PQ5
    [Template]    pnbcbh1
    userbcbh1    123

BC Bán hàng - Lợi nhuận
    [Documentation]     người dùng chỉ có quyền BC Bán hàng: Lợi nhuận
    [Tags]       PQ5
    [Template]     pnbcbh2
    userbcbh2    123

BC Bán hàng - Giảm giá hóa đơn
    [Documentation]     người dùng chỉ có quyền BC Bán hàng: Giảm giá hóa đơn
    [Tags]       PQ5
    [Template]      pnbcbh3
    userbcbh3    123

BC Bán hàng - Trả hàng
    [Documentation]     người dùng chỉ có quyền BC Bán hàng:Trả hàng
    [Tags]       PQ5
    [Template]      pnbcbh4
    userbcbh4    123

BC Bán hàng - Thời gian
    [Documentation]     người dùng chỉ có quyền BC Bán hàng: Thời gian
    [Tags]       PQ5
    [Template]     pnbcbh5
    userbcbh2    123

BC Bán hàng - Chi nhánh
    [Documentation]     người dùng chỉ có quyền BC Bán hàng: Chi nhánh
    [Tags]       PQ5
    [Template]      pnbcbh6
    userbcbh3    123


*** Keywords ***
pnbcbh1
    [Documentation]     người dùng chỉ có quyền BC Bán hàng: Nhân viên
    [Arguments]    ${taikhoan}    ${matkhau}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"EndOfDayReport_EndOfDayProduct":false,"Clocking_Copy":false,"EndOfDayReport_EndOfDaySynthetic":false,"EndOfDayReport_EndOfDayCashFlow":false,"EndOfDayReport_EndOfDayDocument":false,"SaleReport_SaleByUser":true}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    Before Test BC Ban Hang
    #
    Log    validate UI
    Element Should Not Be Visible    ${menu_giaodich}
    Element Should Not Be Visible    ${menu_hh}
    Element Should Not Be Visible    ${menu_doitac}
    Element Should Not Be Visible    ${menu_nhanvien}
    Element Should Not Be Visible    ${menu_soquy}
    Element Should Not Be Visible    ${button_banhang_on_quanly}
    #
    Wait Until Keyword Succeeds    3x    3s    Click Element    ${checkbox_bao_cao}
    Wait Until Keyword Succeeds    3x    5s    Element Should Contain    ${cell_du_lieu_bc}    Báo cáo bán hàng theo nhân viên
    Element Should Contain    ${cell_du_lieu_bc}    Doanh thu thuần
    Delete user    ${get_user_id}

pnbcbh2
    [Documentation]     người dùng chỉ có quyền BC Bán hàng: Lợi nhuận
    [Arguments]    ${taikhoan}    ${matkhau}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"EndOfDayReport_EndOfDayProduct":false,"Clocking_Copy":false,"EndOfDayReport_EndOfDaySynthetic":false,"EndOfDayReport_EndOfDayCashFlow":false,"EndOfDayReport_EndOfDayDocument":false,"SaleReport_SaleByUser":false,"SaleReport_SaleProfitByInvoice":true}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    Before Test BC Ban Hang
    #
    Log    validate UI
    Element Should Not Be Visible    ${menu_giaodich}
    Element Should Not Be Visible    ${menu_hh}
    Element Should Not Be Visible    ${menu_doitac}
    Element Should Not Be Visible    ${menu_nhanvien}
    Element Should Not Be Visible    ${menu_soquy}
    Element Should Not Be Visible    ${button_banhang_on_quanly}
    #
    Wait Until Keyword Succeeds    3x    3s    Click Element    ${checkbox_bao_cao}
    Wait Until Keyword Succeeds    3x    5s    Element Should Contain    ${cell_du_lieu_bc}    Báo cáo lợi nhuận theo hóa đơn
    Element Should Contain    ${cell_du_lieu_bc}    Lợi nhuận
    Delete user    ${get_user_id}

pnbcbh3
    [Documentation]     người dùng chỉ có quyền BC Bán hàng: Gảim giá hóa đơn
    [Arguments]    ${taikhoan}    ${matkhau}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"EndOfDayReport_EndOfDayProduct":false,"Clocking_Copy":false,"EndOfDayReport_EndOfDaySynthetic":false,"EndOfDayReport_EndOfDayCashFlow":false,"EndOfDayReport_EndOfDayDocument":false,"SaleReport_SaleByUser":false,"SaleReport_SaleProfitByInvoice":false,"SaleReport_SaleDiscountByInvoice":true}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    Before Test BC Ban Hang
    #
    Log    validate UI
    Element Should Not Be Visible    ${menu_giaodich}
    Element Should Not Be Visible    ${menu_hh}
    Element Should Not Be Visible    ${menu_doitac}
    Element Should Not Be Visible    ${menu_nhanvien}
    Element Should Not Be Visible    ${menu_soquy}
    Element Should Not Be Visible    ${button_banhang_on_quanly}
    #
    Wait Until Keyword Succeeds    3x    3s    Click Element    ${checkbox_bao_cao}
    Wait Until Keyword Succeeds    3x    5s    Element Should Contain    ${cell_du_lieu_bc}   Báo cáo tổng hợp giảm giá hóa đơn
    Element Should Contain    ${cell_du_lieu_bc}    Giảm giá HĐ
    Delete user    ${get_user_id}

pnbcbh4
    [Documentation]     người dùng chỉ có quyền BC Bán hàng: Trả hàng
    [Arguments]    ${taikhoan}    ${matkhau}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"EndOfDayReport_EndOfDayProduct":false,"Clocking_Copy":false,"EndOfDayReport_EndOfDaySynthetic":false,"EndOfDayReport_EndOfDayCashFlow":false,"EndOfDayReport_EndOfDayDocument":false,"SaleReport_SaleByUser":false,"SaleReport_SaleProfitByInvoice":false,"SaleReport_SaleDiscountByInvoice":false,"SaleReport_SaleByRefund":true}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    Before Test BC Ban Hang
    #
    Log    validate UI
    Element Should Not Be Visible    ${menu_giaodich}
    Element Should Not Be Visible    ${menu_hh}
    Element Should Not Be Visible    ${menu_doitac}
    Element Should Not Be Visible    ${menu_nhanvien}
    Element Should Not Be Visible    ${menu_soquy}
    Element Should Not Be Visible    ${button_banhang_on_quanly}
    #
    Wait Until Keyword Succeeds    3x    3s    Click Element    ${checkbox_bao_cao}
    Wait Until Keyword Succeeds    3x    5s    Element Should Contain    ${cell_du_lieu_bc}   Báo cáo trả hàng theo hóa đơn
    Element Should Contain    ${cell_du_lieu_bc}   Giá trị trả
    Delete user    ${get_user_id}

pnbcbh5
    [Documentation]     người dùng chỉ có quyền BC Bán hàng: Thời gian
    [Arguments]    ${taikhoan}    ${matkhau}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"EndOfDayReport_EndOfDayProduct":false,"Clocking_Copy":false,"EndOfDayReport_EndOfDaySynthetic":false,"EndOfDayReport_EndOfDayCashFlow":false,"EndOfDayReport_EndOfDayDocument":false,"SaleReport_SaleByUser":false,"SaleReport_SaleProfitByInvoice":false,"SaleReport_SaleDiscountByInvoice":false,"SaleReport_SaleByRefund":false,"SaleReport_SaleByTime":true}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    Before Test BC Ban Hang
    #
    Log    validate UI
    Element Should Not Be Visible    ${menu_giaodich}
    Element Should Not Be Visible    ${menu_hh}
    Element Should Not Be Visible    ${menu_doitac}
    Element Should Not Be Visible    ${menu_nhanvien}
    Element Should Not Be Visible    ${menu_soquy}
    Element Should Not Be Visible    ${button_banhang_on_quanly}
    #
    Wait Until Keyword Succeeds    3x    3s    Click Element    ${checkbox_bao_cao}
    Wait Until Keyword Succeeds    3x    5s    Element Should Contain    ${cell_du_lieu_bc}   Báo cáo bán hàng theo thời gian
    Element Should Contain    ${cell_du_lieu_bc}       Doanh thu thuần
    Delete user    ${get_user_id}

pnbcbh6
    [Documentation]     người dùng chỉ có quyền BC Bán hàng: Thời gian
    [Arguments]    ${taikhoan}    ${matkhau}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"EndOfDayReport_EndOfDayProduct":false,"Clocking_Copy":false,"EndOfDayReport_EndOfDaySynthetic":false,"EndOfDayReport_EndOfDayCashFlow":false,"EndOfDayReport_EndOfDayDocument":false,"SaleReport_SaleByUser":false,"SaleReport_SaleProfitByInvoice":false,"SaleReport_SaleDiscountByInvoice":false,"SaleReport_SaleByRefund":false,"SaleReport_SaleByTime":false,"PayslipPayment_Create":false,"PayslipPayment_Update":false,"PayslipPayment_Delete":false,"SaleReport_BranchSaleReport":true}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    Before Test BC Ban Hang
    #
    Log    validate UI
    Element Should Not Be Visible    ${menu_giaodich}
    Element Should Not Be Visible    ${menu_hh}
    Element Should Not Be Visible    ${menu_doitac}
    Element Should Not Be Visible    ${menu_nhanvien}
    Element Should Not Be Visible    ${menu_soquy}
    Element Should Not Be Visible    ${button_banhang_on_quanly}
    #
    Wait Until Keyword Succeeds    3x    3s    Click Element    ${checkbox_bao_cao}
    Wait Until Keyword Succeeds    3x    5s    Element Should Contain    ${cell_du_lieu_bc}      Báo cáo bán hàng theo chi nhánh
    Element Should Contain    ${cell_du_lieu_bc}       Doanh thu thuần
    Delete user    ${get_user_id}
