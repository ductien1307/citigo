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
BC Khách hàng - Công nợ
    [Documentation]     người dùng chỉ có quyền BC Khách hàng: Công nợ
    [Tags]
    [Template]    pnbckh1
    userbckh1    123

BC Khách hàng - Hàng bán theo khách
    [Documentation]     người dùng chỉ có quyền BC Khách hàng: Hàng bán theo khách
    [Tags]
    [Template]     pnbckh2
    userbckh2    123

BC Khách hàng - Bán hàng
    [Documentation]     người dùng chỉ có quyền BC Khách hàng: Bán hàng
    [Tags]
    [Template]     pnbckh3
    userbckh3    123

BC Khách hàng - Lợi nhuận
    [Documentation]     người dùng chỉ có quyền BC Khách hàng: Lợi nhuận
    [Tags]
    [Template]     pnbckh4
    userbckh4   123

*** Keywords ***
pnbckh1
    [Documentation]     người dùng chỉ có quyền BC Khách hàng: Công nợ
    [Arguments]    ${taikhoan}    ${matkhau}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"EndOfDayReport_EndOfDayProduct":false,"Clocking_Copy":false,"EndOfDayReport_EndOfDaySynthetic":false,"EndOfDayReport_EndOfDayCashFlow":false,"EndOfDayReport_EndOfDayDocument":false,"SaleReport_SaleByUser":false,"SaleReport_SaleProfitByInvoice":false,"SaleReport_SaleDiscountByInvoice":false,"SaleReport_SaleByRefund":false,"SaleReport_SaleByTime":false,"PayslipPayment_Create":false,"PayslipPayment_Update":false,"PayslipPayment_Delete":false,"SaleReport_BranchSaleReport":false,"OrderReport_ByDocReport":false,"OrderReport_ByProductReport":false,"ProductReport_ProducStockInOutStock":false,"ProductReport_ProductByBatchExpire":false,"ProductReport_ProductByCustomer":false,"ProductReport_ProductByDamageItem":false,"ProductReport_ProductBySupplier":false,"ProductReport_ProductByUser":false,"ProductReport_ProducInOutStock":false,"ProductReport_ProducInOutStockDetail":false,"ProductReport_ProductByProfit":false,"ProductReport_ProductBySale":false,"FinancialReport_SalePerformanceReport":false,"CustomerReport_BigCustomerDebt":true,"CustomerReport_CustomerProduct":false}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    Before Test BC Khach Hang
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
    Wait Until Keyword Succeeds    3x    5s    Element Should Contain    ${cell_du_lieu_bc}     Báo cáo công nợ theo khách hàng
    Element Should Contain    ${cell_du_lieu_bc}      Nợ cuối k
    Delete user    ${get_user_id}

pnbckh2
    [Documentation]     người dùng chỉ có quyền BC Khách hàng: Hàng bán theo khách
    [Arguments]    ${taikhoan}    ${matkhau}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"EndOfDayReport_EndOfDayProduct":false,"Clocking_Copy":false,"EndOfDayReport_EndOfDaySynthetic":false,"EndOfDayReport_EndOfDayCashFlow":false,"EndOfDayReport_EndOfDayDocument":false,"SaleReport_SaleByUser":false,"SaleReport_SaleProfitByInvoice":false,"SaleReport_SaleDiscountByInvoice":false,"SaleReport_SaleByRefund":false,"SaleReport_SaleByTime":false,"PayslipPayment_Create":false,"PayslipPayment_Update":false,"PayslipPayment_Delete":false,"SaleReport_BranchSaleReport":false,"OrderReport_ByDocReport":false,"OrderReport_ByProductReport":false,"ProductReport_ProducStockInOutStock":false,"ProductReport_ProductByBatchExpire":false,"ProductReport_ProductByCustomer":false,"ProductReport_ProductByDamageItem":false,"ProductReport_ProductBySupplier":false,"ProductReport_ProductByUser":false,"ProductReport_ProducInOutStock":false,"ProductReport_ProducInOutStockDetail":false,"ProductReport_ProductByProfit":false,"ProductReport_ProductBySale":false,"FinancialReport_SalePerformanceReport":false,"CustomerReport_BigCustomerDebt":false,"CustomerReport_CustomerProduct":true}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    Before Test BC Khach Hang
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
    Wait Until Keyword Succeeds    3x    5s    Element Should Contain    ${cell_du_lieu_bc}     Báo cáo hàng bán theo khách
    Element Should Contain    ${cell_du_lieu_bc}      Doanh thu thuần
    Delete user    ${get_user_id}

pnbckh3
    [Documentation]     người dùng chỉ có quyền BC Khách hàng: Bán hàng
    [Arguments]    ${taikhoan}    ${matkhau}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"EndOfDayReport_EndOfDayProduct":false,"Clocking_Copy":false,"EndOfDayReport_EndOfDaySynthetic":false,"EndOfDayReport_EndOfDayCashFlow":false,"EndOfDayReport_EndOfDayDocument":false,"SaleReport_SaleByUser":false,"SaleReport_SaleProfitByInvoice":false,"SaleReport_SaleDiscountByInvoice":false,"SaleReport_SaleByRefund":false,"SaleReport_SaleByTime":false,"PayslipPayment_Create":false,"PayslipPayment_Update":false,"PayslipPayment_Delete":false,"SaleReport_BranchSaleReport":false,"OrderReport_ByDocReport":false,"OrderReport_ByProductReport":false,"ProductReport_ProducStockInOutStock":false,"ProductReport_ProductByBatchExpire":false,"ProductReport_ProductByCustomer":false,"ProductReport_ProductByDamageItem":false,"ProductReport_ProductBySupplier":false,"ProductReport_ProductByUser":false,"ProductReport_ProducInOutStock":false,"ProductReport_ProducInOutStockDetail":false,"ProductReport_ProductByProfit":false,"ProductReport_ProductBySale":false,"FinancialReport_SalePerformanceReport":false,"CustomerReport_BigCustomerDebt":false,"CustomerReport_CustomerProduct":false,"CustomerReport_CustomerSale":true}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    Before Test BC Khach Hang
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
    Wait Until Keyword Succeeds    3x    5s    Element Should Contain    ${cell_du_lieu_bc}     Báo cáo bán hàng theo khách hàng
    Element Should Contain    ${cell_du_lieu_bc}     Doanh thu thuần
    Delete user    ${get_user_id}

pnbckh4
    [Documentation]     người dùng chỉ có quyền BC Khách hàng: Lợi nhuận
    [Arguments]    ${taikhoan}    ${matkhau}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"EndOfDayReport_EndOfDayProduct":false,"Clocking_Copy":false,"EndOfDayReport_EndOfDaySynthetic":false,"EndOfDayReport_EndOfDayCashFlow":false,"EndOfDayReport_EndOfDayDocument":false,"SaleReport_SaleByUser":false,"SaleReport_SaleProfitByInvoice":false,"SaleReport_SaleDiscountByInvoice":false,"SaleReport_SaleByRefund":false,"SaleReport_SaleByTime":false,"PayslipPayment_Create":false,"PayslipPayment_Update":false,"PayslipPayment_Delete":false,"SaleReport_BranchSaleReport":false,"OrderReport_ByDocReport":false,"OrderReport_ByProductReport":false,"ProductReport_ProducStockInOutStock":false,"ProductReport_ProductByBatchExpire":false,"ProductReport_ProductByCustomer":false,"ProductReport_ProductByDamageItem":false,"ProductReport_ProductBySupplier":false,"ProductReport_ProductByUser":false,"ProductReport_ProducInOutStock":false,"ProductReport_ProducInOutStockDetail":false,"ProductReport_ProductByProfit":false,"ProductReport_ProductBySale":false,"FinancialReport_SalePerformanceReport":false,"CustomerReport_BigCustomerDebt":false,"CustomerReport_CustomerProduct":false,"CustomerReport_CustomerSale":false,"CustomerReport_CustomerProfit":true}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    Before Test BC Khach Hang
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
    Wait Until Keyword Succeeds    3x    5s    Element Should Contain    ${cell_du_lieu_bc}     Báo cáo lợi nhuận theo khách hàng
    Element Should Contain    ${cell_du_lieu_bc}     Lợi nhuận gộp
    Delete user    ${get_user_id}
