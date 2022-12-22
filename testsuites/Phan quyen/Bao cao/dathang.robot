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
BC Đặt hàng - Giao dịch
    [Documentation]     người dùng chỉ có quyền BC Đặt hàng: Giao dịch
    [Tags]       PQ5
    [Template]    pnbcdh1
    userbcdh1    123

BC Đặt hàng -Hàng hóa
    [Documentation]     người dùng chỉ có quyền BC Đặt hàng: Hàng hóa
    [Tags]       PQ5
    [Template]     pnbcdh2
    userbcdh2    123

*** Keywords ***
pnbcdh1
    [Documentation]     người dùng chỉ có quyền BC Đặt hàng: Giao dịch
    [Arguments]    ${taikhoan}    ${matkhau}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"EndOfDayReport_EndOfDayProduct":false,"Clocking_Copy":false,"EndOfDayReport_EndOfDaySynthetic":false,"EndOfDayReport_EndOfDayCashFlow":false,"EndOfDayReport_EndOfDayDocument":false,"SaleReport_SaleByUser":false,"SaleReport_SaleProfitByInvoice":false,"SaleReport_SaleDiscountByInvoice":false,"SaleReport_SaleByRefund":false,"SaleReport_SaleByTime":false,"PayslipPayment_Create":false,"PayslipPayment_Update":false,"PayslipPayment_Delete":false,"SaleReport_BranchSaleReport":false,"OrderReport_ByDocReport":true}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    Before Test BC Dat Hang
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
    Wait Until Keyword Succeeds    3x    5s    Element Should Contain    ${cell_du_lieu_bc}    Báo cáo danh sách đơn đặt hàng
    Element Should Contain    ${cell_du_lieu_bc}    Giá trị đơn đặ
    Delete user    ${get_user_id}

pnbcdh2
    [Documentation]     người dùng chỉ có quyền BC Đặt hàng: Giao dịch
    [Arguments]    ${taikhoan}    ${matkhau}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"EndOfDayReport_EndOfDayProduct":false,"Clocking_Copy":false,"EndOfDayReport_EndOfDaySynthetic":false,"EndOfDayReport_EndOfDayCashFlow":false,"EndOfDayReport_EndOfDayDocument":false,"SaleReport_SaleByUser":false,"SaleReport_SaleProfitByInvoice":false,"SaleReport_SaleDiscountByInvoice":false,"SaleReport_SaleByRefund":false,"SaleReport_SaleByTime":false,"PayslipPayment_Create":false,"PayslipPayment_Update":false,"PayslipPayment_Delete":false,"SaleReport_BranchSaleReport":false,"OrderReport_ByDocReport":false,"OrderReport_ByProductReport":true}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
    Log    ${payload}
    ${headers1}=    Create Dictionary    Authorization=${bearertoken}    Content-Type=application/json;charset=utf-8
    Create Session    lolo    ${API_URL}    cookies=${resp.cookies}
    ${resp3}=    Post Request    lolo    ${endpoint_update_quyen}    data=${payload}    headers=${headers1}
    Log    ${resp3.request.body}
    Log    ${resp3.json()}
    Log    ${resp3.status_code}
    Should Be Equal As Strings    ${resp3.status_code}    200
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    Before Test BC Dat Hang
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
    Wait Until Keyword Succeeds    3x    5s    Element Should Contain    ${cell_du_lieu_bc}    Báo cáo đặt hàng theo hàng hóa
    Element Should Contain    ${cell_du_lieu_bc}   Giá trị hàng đặt
    Delete user    ${get_user_id}
