*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    ${headless_browser}
Test Setup
Test Teardown     After Test
Library           Collections
Resource          ../../../../config/env_product/envi.robot
Resource          ../../../../core/hang_hoa/hang_hoa_navigation.robot
Resource          ../../../../core/hang_hoa/hang_hoa_add_action.robot
Resource          ../../../../core/hang_hoa/danh_muc_list_action.robot
Resource          ../../../../core/share/computation.robot
Resource          ../../../../core/Giao_dich/giaodich_nav.robot
Resource          ../../../../core/API/api_danhmuc_hanghoa.robot
Resource          ../../../../core/API/api_thietlap.robot
Resource          ../../../../core/Doi_Tac/doitac_navigation.robot
Resource          ../../../../core/So_Quy/so_quy_navigation.robot
Resource          ../../../../core/Bao_cao/bao_cao_navigation.robot
Resource          ../../../../core/share/toast_message.robot
Resource          ../../../../core/Giao_dich/nhaphang_getandcompute.robot
Resource          ../../../../core/API/api_soquy.robot
Resource          ../../../../core/API/api_mhbh.robot
Resource          ../../../../core/Giao_dich/hoa_don_list_action.robot

*** Variables ***
&{invoice_1}      TP015=3.5    RPSI0003=4       GHC0004=1
&{discount_1}      TP015=15    RPSI0003=14000      GHC0004=190000
&{discount_type1}      TP015=dis    RPSI0003=disvnd   GHC0004=changedown
&{product_type1}      TP015=pro    RPSI0003=imei      GHC0004=com
@{newprice_1}      150000    85000      190000

*** Test Cases ***
Thêm mới
    [Documentation]     Cập nhật người dùng có quyền: Hóa đơn: Xem DS, Thêm mới, Thay đổi giá, Cập nhật gghd; Khách hàng: Xem DS
    [Tags]        PQ
    [Template]    pqhd1
    nham.nt    123     ${invoice_1}            ${product_type1}          ${discount_1}         ${discount_type1}          10                   PQKH003        100000

Cập nhật
    [Documentation]     Cập nhật Người dùng có quyền Hóa đơn: Xem DS, Cập nhật
    [Tags]        PQ
    [Template]    pqhd2
    nham.nt    123     PQKH003          ${invoice_1}    ${newprice_1}              15         all

Xóa
    [Documentation]     Cập nhật gười dùng có quyền Hóa đơn: Xem DS, Xóa
    [Tags]        PQ
    [Template]    pqhd3
    nham.nt    123    PQKH003          ${invoice_1}    ${newprice_1}              15         all

*** Keywords ***
pqhd1
    [Documentation]     Cập nhật người dùng có quyền: Hóa đơn: Xem DS, Thêm mới, Thay đổi giá, Cập nhật gghd; Khách hàng: Xem DS
    [Arguments]    ${taikhoan}    ${matkhau}    ${dict_product_num}    ${dict_product_type}      ${dict_discount}      ${dict_discount_type}      ${input_invoice_discount}    ${input_bh_ma_kh}    ${input_bh_khachtt}
    Log    Cập nhật Người dùng có quyền Hóa đơn: Xem DS, Thêm mới, Thay đổi giá, Cập nhật gghd; Khách hàng: Xem DS
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên thu ngân
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"Customer_Read":true,"Invoice_Create":true,"Order_Read":false,"Order_Create":false,"Order_Update":false,"TableAndRoom_Read":true,"TableAndRoom_Create":true,"TableAndRoom_Update":true,"TableAndRoom_Delete":true,"Invoice_ChangePrice":true,"Invoice_ChangeDiscount":true,"Order_MakeInvoice":false,"Clocking_Copy":false,"StockTake_Read":false,"StockTake_Create":false,"StockTake_Delete":false,"StockTake_Export":false,"StockTake_Inventory":false,"StockTake_Clone":false,"StockTake_Finish":false,"Order_Delete":false,"Order_RepeatPrint":false,"Order_Export":false,"Order_CopyOrder":false,"Order_UpdateWarranty":false,"Invoice_Read":true}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}      ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    ##
    Before Test Ban Hang
    #
    ${list_products}    Get Dictionary Keys    ${dict_product_num}
    ${list_nums}    Get Dictionary Values    ${dict_product_num}
    ${list_product_type}    Get Dictionary Values    ${dict_product_type}
    ${list_discount_product}    Get Dictionary Values    ${dict_discount}
    ${list_discount_type}    Get Dictionary Values    ${dict_discount_type}
    ${list_unit}       Get list of keys from dictionary by value    ${dict_product_type}      unit
    ${list_imei_product}       Get list of keys from dictionary by value    ${dict_product_type}      imei
    ${list_unit_quan}=       Get list of values from dictionary by list of keys    ${dict_product_num}    ${list_unit}
    ${get_no_bf_execute}    ${get_tongban_bf_execute}    ${get_tongban_tru_trahang_bf_execute}    Get Customer Debt from API    ${input_bh_ma_kh}
    Log      Create list imei for imei products
    ${list_imei_all}    create list
    : FOR    ${item_product}     ${item_num}    ${item_product_type}    IN ZIP    ${list_products}    ${list_nums}      ${list_product_type}
    \    ${list_imei_by_single_product}=      Run Keyword If    '${item_product_type}' == 'imei'      Import multi imei for product    ${item_product}    ${item_num}      ELSE      Set Variable    nonimei
    \    Append to List       ${list_imei_all}        ${list_imei_by_single_product}
    Log       ${list_imei_all}
    ${list_imei_for_validation}      Copy list      ${list_imei_all}
    Remove values From List      ${list_imei_for_validation}        nonimei
    Log       Get Data
    ${list_product_for_validation}       ${list_product_quan_for_validation}     ${list_product_type_for_validation}       Remove combo and unit from validation lists    ${list_products}    ${list_nums}    ${list_product_type}
    ${list_product_for_validation}       ${list_product_quan_for_validation}     ${list_product_type_for_validation}       Extract combo and unit products for validation lists        ${list_products}    ${list_nums}    ${list_product_type}       ${list_product_for_validation}       ${list_product_quan_for_validation}     ${list_product_type_for_validation}
    ${list_result_ton_af_ex}        Get list of result onhand incase changing product price    ${list_product_for_validation}    ${list_product_quan_for_validation}
    ${list_result_thanhtien}      ${list_result_newprice}    Get list of total sale - result new price incase changing product price    ${list_products}    ${list_nums}    ${list_discount_product}      ${list_discount_type}
    Sleep     30 s
    Reload Page
    Log      Input data into BH form
    ${lastest_num}    Set Variable    0
    : FOR    ${item_product}     ${item_product_type}       ${item_num}        ${item_list_imei}    ${item_discount}      ${item_discount_type}     ${item_newprice}    IN ZIP    ${list_products}       ${list_product_type}
    ...    ${list_nums}    ${list_imei_all}       ${list_discount_product}    ${list_discount_type}      ${list_result_newprice}
    \    ${lastest_num}=        Run Keyword If    '${item_product_type}' == 'imei'    Input products - IMEIs and validate lastest number in BH form    ${item_product}    ${item_num}      ${item_list_imei}    ${lastest_num}     ELSE      Input product-num in BH form    ${item_product}    ${item_num}      ${lastest_num}
    \    Run keyword if    '${item_discount_type}' == 'dis'    Wait Until Keyword Succeeds    3 times    5 s    Input % discount for product    ${item_discount}    ${item_newprice}
    \    ...    ELSE IF    '${item_discount_type}' == 'disvnd'    Wait Until Keyword Succeeds    3 times    5 s    Input vnd discount for product    ${item_discount}    ${item_newprice}
    \    ...    ELSE IF     '${item_discount_type}' == 'changeup' or '${item_discount_type}' == 'changedown'  Wait Until Keyword Succeeds    3 times    5 s    Input new price of product    ${item_discount}        ELSE       Log        ignore
    ${result_tongtienhang}    Sum values in list    ${list_result_thanhtien}
    Validate UI Total Invoice value    ${result_tongtienhang}
    ${result_khachcantra}=    Run Keyword If    0 < ${input_invoice_discount} < 100    Price after % discount invoice    ${result_tongtienhang}    ${input_invoice_discount}
    ...    ELSE IF    ${input_invoice_discount} > 100    Minus    ${result_tongtienhang}    ${input_invoice_discount}
    ...    ELSE    Set Variable    ${result_tongtienhang}
    ${result_discount_invoice}    Run Keyword If    0 < ${input_invoice_discount} < 100    Convert % discount to VND and round    ${result_tongtienhang}    ${input_invoice_discount}
    ...    ELSE    Set Variable    ${input_invoice_discount}
    ${actual_khachtt}    Set Variable If    '${input_bh_khachtt}' == 'all'    ${result_khachcantra}    ${input_bh_khachtt}
    ${result_no_hoadon}    Minus    ${result_khachcantra}    ${actual_khachtt}
    ${result_nohientai}    sum    ${result_no_hoadon}    ${get_no_bf_execute}
    ${result_tongban}    Sum    ${result_khachcantra}    ${get_tongban_bf_execute}
    Run Keyword If    0 < ${input_invoice_discount} < 100    Wait Until Keyword Succeeds    3 times    8 s    Input % discount invoice    ${input_invoice_discount}
    ...    ${result_discount_invoice}
    ...    ELSE IF    ${input_invoice_discount} > 100    Input VND discount invoice    ${input_invoice_discount}
    ...    ELSE    Log    Ignore discount
    Run Keyword If    '${input_bh_khachtt}' == 'all'    Input Khach Hang    ${input_bh_ma_kh}
    ...    ELSE    Input Invoice info    ${input_bh_ma_kh}    ${input_bh_khachtt}    ${result_khachcantra}
    Click Element JS    ${button_bh_thanhtoan}
    Invoice message success validation
    ${invoice_code}    Get saved code after execute
    Sleep    20 s    wait for response to API
    Log       assert values in Hoa don
    Set Global Variable    \${USER_NAME}     ${USER_ADMIN}
    ${get_ma_kh_by_hd}    ${get_tong_tien_hang}    ${get_khach_tt}    ${get_giamgia_hd}    ${get_khachcantra}    ${get_trangthai}    Get invoice info incase discount by invoice code
    ...    ${invoice_code}
    Run Keyword If    ${input_invoice_discount} == 0    Should Be Equal As Numbers    ${get_khachcantra}    ${result_tongtienhang}
    ...    ELSE    Should Be Equal As Numbers    ${get_tong_tien_hang}    ${result_tongtienhang}
    Run Keyword If    ${input_invoice_discount} == 0    Log    Ignore validate
    ...    ELSE    Should Be Equal As Numbers    ${get_tong_tien_hang}    ${result_tongtienhang}
    Should Be Equal As Numbers    ${get_khachcantra}    ${result_khachcantra}
    Should Be Equal As Numbers    ${get_khach_tt}    ${actual_khachtt}
    Should Be Equal As Strings    ${get_ma_kh_by_hd}    ${input_bh_ma_kh}
    Should Be Equal As Numbers    ${get_giamgia_hd}    ${result_discount_invoice}
    Should Be Equal As Strings    ${get_trangthai}    Hoàn thành
    Delete invoice by invoice code    ${invoice_code}

pqhd2
    [Documentation]     Cập nhật Người dùng có quyền Hóa đơn: Xem DS, Cập nhật
    [Arguments]    ${taikhoan}    ${matkhau}    ${input_bh_ma_kh}    ${dict_product_num}    ${list_newprice}    ${input_gghd}      ${input_khtt}
    Log    Cập nhật Người dùng có quyền Hóa đơn: Xem DS, Cập nhật
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên thu ngân
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"Customer_Read":false,"Invoice_Create":false,"Order_Read":false,"Order_Create":false,"Order_Update":false,"TableAndRoom_Read":true,"TableAndRoom_Create":true,"TableAndRoom_Update":true,"TableAndRoom_Delete":true,"Invoice_ChangePrice":false,"Invoice_ChangeDiscount":false,"Order_MakeInvoice":false,"Clocking_Copy":false,"StockTake_Read":false,"StockTake_Create":false,"StockTake_Delete":false,"StockTake_Export":false,"StockTake_Inventory":false,"StockTake_Clone":false,"StockTake_Finish":false,"Order_Delete":false,"Order_RepeatPrint":false,"Order_Export":false,"Order_CopyOrder":false,"Order_UpdateWarranty":false,"Invoice_Read":true,"Invoice_Update":true}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}    ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    #
    Before Test QL Hoa don
    ${get_ma_hd}      Add new invoice incase newprice with multi product - get invoice code    ${input_bh_ma_kh}    ${dict_product_num}    ${list_newprice}    ${input_gghd}    none    ${input_khtt}
    Reload Page
    Search invoice code    ${get_ma_hd}
    Element Should Not Be Visible     ${button_hd_banhang}
    Element Should Not Be Visible     ${button_hd_xuatfile}
    Element Should Not Be Visible     ${button_hd_mo_phieu}
    Element Should Not Be Visible     ${button_hd_tra_hang}
    Element Should Not Be Visible     ${button_hd_in}
    Element Should Not Be Visible     ${button_hd_sao_chep}
    Element Should Not Be Visible     ${button_hd_huy_bo}
    Element Should Be Visible    ${button_hd_xuatfile_hd}
    Click Element     ${button_hd_luu}
    Invoice update message success validation    ${get_ma_hd}
    Delete invoice by invoice code    ${get_ma_hd}

pqhd3
    [Documentation]     Cập nhật gười dùng có quyền Hóa đơn: Xem DS, Xóa
    [Arguments]    ${taikhoan}    ${matkhau}    ${input_bh_ma_kh}    ${dict_product_num}    ${list_newprice}    ${input_gghd}      ${input_khtt}
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên thu ngân
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"Invoice_Read":true,"Invoice_Update":false,"TableAndRoom_Read":true,"TableAndRoom_Create":true,"TableAndRoom_Update":true,"TableAndRoom_Delete":true,"Clocking_Copy":false,"Invoice_Delete":true}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}      ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    #
    Before Test QL Hoa don
    ${get_ma_hd}      Add new invoice incase newprice with multi product - get invoice code    ${input_bh_ma_kh}    ${dict_product_num}    ${list_newprice}    ${input_gghd}    none    ${input_khtt}
    Reload Page
    Search invoice code    ${get_ma_hd}
    Element Should Not Be Visible     ${button_hd_banhang}
    Element Should Not Be Visible     ${button_hd_xuatfile}
    Element Should Not Be Visible     ${button_hd_mo_phieu}
    Element Should Not Be Visible     ${button_hd_tra_hang}
    Element Should Not Be Visible     ${button_hd_in}
    Element Should Not Be Visible     ${button_hd_sao_chep}
    Element Should Not Be Visible   ${button_hd_luu}
    Element Should Be Visible    ${button_hd_xuatfile_hd}
    Click Element     ${button_hd_huy_bo}
    Wait Until Page Contains Element    ${button_hd_dongy_huybo}    30s
    Wait Until Keyword Succeeds    3 times   1s   Click Element    ${button_hd_dongy_huybo}
    Invoice delete message success validation    ${get_ma_hd}
    Set Global Variable    \${USER_NAME}     admin
    ${endpoint_hoadon_by_branch}    Format String    ${endpoint_hoadon}    ${BRANCH_ID}
    ${jsonpath_invoice_id}    Format String    $..Data[?(@.Code=="{0}")].Id    ${get_ma_hd}
    ${get_invoice_id}    Get data from API by BranchID    ${BRANCH_ID}    ${endpoint_hoadon_by_branch}    ${jsonpath_invoice_id}
    ${endpoint_invoice_by_id}    Format String    ${endpoint_invoice_detail}    ${get_invoice_id}
    ${get_resp}    Get Request and return body    ${endpoint_invoice_by_id}
    ${get_trangthai}    Get data from response json    ${get_resp}    $.Status
    Should Be Equal As Numbers    ${get_trangthai}    2
