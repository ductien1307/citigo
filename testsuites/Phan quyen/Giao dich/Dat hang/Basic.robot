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
Resource          ../../../../core/Giao_dich/giaodich_nav.robot
Resource          ../../../../core/So_Quy/so_quy_navigation.robot
Resource          ../../../../core/Bao_cao/bao_cao_navigation.robot
Resource          ../../../../core/share/toast_message.robot
Resource          ../../../../core/Giao_dich/nhaphang_getandcompute.robot
Resource          ../../../../core/API/api_soquy.robot
Resource          ../../../../core/API/api_mhbh_dathang.robot
Resource          ../../../../core/Giao_dich/dathang_list_action.robot

*** Variables ***
&{list_product1}    TP013=4     RPSI0002=2
@{discount}        10              150000
@{discount_type}     dis        Changeup

*** Test Cases ***
Thêm mới
    [Documentation]     Cập nhật người dùng có quyền: xem ds đặt hàng + thêm mới dh + thay đổi giá + cập nhật giảm giá hd + xem ds kh
    [Tags]      PQ
    [Template]    pqdh1
    ngoc.db   123    PQKH001       ${list_product1}     ${discount}      ${discount_type}        10          all

Cập nhật
    [Documentation]     Cập nhật người dùng có quyền: xem ds đặt hàng + thêm mới dh + cập nhật dh + thay đổi giá + cập nhật giảm giá hd + xem ds kh
    [Tags]      PQ
    [Template]    pqdh2
    ngoc.db    123     PQKH001          ${list_product1}    ${discount}       ${discount_type}         15         all                Combo033               3.6             80000             0      Thanh toán khi nhận hàng

Xóa
    [Documentation]     Cập nhật người dùng có quyền: xem ds đặt hàng + xóa phiếu
    [Tags]        PQ
    [Template]    pqdh3
    ngoc.db    123    PQKH001       Combo033               3.6             80000

*** Keywords ***
pqdh1
    [Documentation]     Cập nhật người dùng có quyền: xem ds đặt hàng + thêm mới dh + thay đổi giá + cập nhật giảm giá hd + xem ds kh
    [Arguments]    ${taikhoan}    ${matkhau}     ${input_ma_kh}    ${dict_product_nums}    ${list_ggsp}   ${list_discount_type}    ${input_ggdh}    ${input_khtt}
    Log    Cập nhật quyền xem ds đặt hàng
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên thu ngân
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"Order_Read":true,"TableAndRoom_Read":true,"TableAndRoom_Create":true,"TableAndRoom_Update":true,"TableAndRoom_Delete":true,"Clocking_Copy":false,"Order_Create":true,"Product_Delete":false,"Product_PurchasePrice":false,"Product_Update":false,"Invoice_ChangePrice":true,"Invoice_ChangeDiscount":true,"Customer_Read":true}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}     ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    ##
    Before Test Ban Hang
    #
    Set Selenium Speed    0.5s
    ${list_product}    Get Dictionary Keys    ${dict_product_nums}
    ${list_nums}    Get Dictionary Values    ${dict_product_nums}
    ${get_no_bf_execute}    ${get_tongban_bf_execute}    ${get_tongban_tru_trahang_bf_execute}    Get Customer Debt from API    ${input_ma_kh}
    ${list_result_thanhtien}    ${list_result_order_summary}    ${list_result_giamoi}    Get list total sale and order summary incase discount and newprice    ${list_product}
    ...    ${list_nums}    ${list_ggsp}    ${list_discount_type}
    #compute
    ${result_tongtienhang}    Sum values in list    ${list_result_thanhtien}
    ${result_tongtienhang}    Replace floating point    ${result_tongtienhang}
    ${result_tongcong}    Run Keyword If    0 < ${input_ggdh} < 100    Price after % discount invoice    ${result_tongtienhang}    ${input_ggdh}
    ...    ELSE IF    ${input_ggdh} > 100    Minus and replace floating point    ${result_tongtienhang}    ${input_ggdh}
    ...    ELSE    Set Variable    ${result_tongtienhang}
    ${result_ggdh}    Run Keyword If    0 < ${input_ggdh} < 100    Convert % discount to VND and round    ${result_tongtienhang}    ${input_ggdh}
    ...    ELSE    Set Variable    ${input_ggdh}
    ${result_tongcong}    Replace floating point    ${result_tongcong}
    ${actual_khtt_all}    Set Variable If    '${input_khtt}' == 'all'    ${result_tongcong}    ${input_khtt}
    ${actual_khtt}    Set Variable If    '${input_khtt}' == '0'    0    ${actual_khtt_all}
    ${result_no_hientai_kh}    Minus    ${get_no_bf_execute}    ${actual_khtt}    #Do đặt hàng không ghi nhận phiếu đặt, mà phiếu thanh toán ghi nhận là số âm nên khi tính công nợ sẽ là trừ
    #input data into DH form
    Element Should Not Be Visible    ${tab_hoadon}
    Element Should Not Be Visible      ${icon_select_th_hd}
    Wait Until Keyword Succeeds    3 times    5 s    Click Element JS    ${tab_dathang}
    ${laster_nums}    Set Variable    0
    : FOR    ${item_product}    ${item_nums}    ${item_ggsp}    ${item_price}   ${item_discount_type}    IN ZIP    ${list_product}
    ...    ${list_nums}    ${list_ggsp}    ${list_result_giamoi}    ${list_discount_type}
    \    ${laster_nums}    Wait Until Keyword Succeeds    3 times    5 s    Input product-num in sale form    ${item_product}    ${item_nums}
    \    ...    ${laster_nums}    ${cell_tongsoluong_dh}
    \    Run keyword if    '${item_discount_type}' == 'dis'     Wait Until Keyword Succeeds    3 times    5 s    Input % discount for multi product    ${item_product}    ${item_ggsp}
    \    ...    ${item_price}    ELSE IF    '${item_discount_type}' == 'disvnd'    Input VND discount for multi product    ${item_product}    ${item_ggsp}    ${item_price}
    \    ...     ELSE IF  '${item_discount_type}' == 'changeup' or '${item_discount_type}' == 'changedown'    Wait Until Keyword Succeeds    3 times    5 s    Input newprice for multi product    ${item_product}    ${item_ggsp}
    \    ...    ELSE    Log    Ignore input
    Wait Until Keyword Succeeds    3 times    5 s    Run keyword if    0 < ${input_ggdh} < 100    Input % discount order    ${input_ggdh}
    ...    ${result_ggdh}   ELSE    Input VND discount order    ${input_ggdh}
    Wait Until Keyword Succeeds    3 times    5 s    Run Keyword If    '${input_khtt}' == '0'    Input Khach Hang    ${input_ma_kh}
    ...    ELSE    Input Order info    ${input_ma_kh}    ${actual_khtt}    ${result_tongcong}
    Wait Until Keyword Succeeds    3 times    5 s    Click Element JS    ${button_bh_dathang}
    Order message success validation
    ${get_ma_dh}    Get saved code after execute
    Delete order frm Order code    ${get_ma_dh}

pqdh2
    [Documentation]     Cập nhật người dùng có quyền: xem ds đặt hàng + thêm mới dh + cập nhật dh + thay đổi giá + cập nhật giảm giá hd + xem ds kh
    [Arguments]    ${taikhoan}    ${matkhau}      ${input_ma_kh}    ${dict_product_nums}    ${list_ggsp}   ${list_discount_type}    ${input_ggdh}    ${input_khtt}    ${input_ma_hh}
    ...    ${input_soluong}   ${input_ggsp}    ${input_khtt_create_order}    ${input_ghichu}
    Log    Cập nhật quyền xem ds đặt hàng
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên thu ngân
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String   {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"Order_Read":true,"TableAndRoom_Read":true,"TableAndRoom_Create":true,"TableAndRoom_Update":true,"TableAndRoom_Delete":true,"Clocking_Copy":false,"Order_Create":true,"Product_Delete":false,"Product_PurchasePrice":false,"Product_Update":false,"Invoice_ChangePrice":true,"Invoice_ChangeDiscount":true,"Customer_Read":true,"Order_Update":true}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}      ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    ##
    #get info product, customer
    ${order_code}    Add new order frm API    ${input_ma_kh}    ${input_ma_hh}    ${input_soluong}    ${input_khtt_create_order}
    ${list_product}    Get Dictionary Keys    ${dict_product_nums}
    ${list_nums}    Get Dictionary Values    ${dict_product_nums}
    ${get_khachdatra_in_dh_bf_execute}    ${get_tongtienhang_in_dh_bf_execute}    Get paid value frm API    ${order_code}
    ${get_tongso_dh_bf_execute}    Get order summary by order code    ${order_code}
    ${product_name_in_order}   ${base_price_in_order}   Get product name and price frm API    ${input_ma_hh}
    ${result_thanhtien_in_order}  Multiplication and round   ${input_ggsp}    ${input_soluong}
    #get value to Validate
    ${list_result_thanhtien}    ${list_result_order_summary}    ${list_result_giamoi}    Get list total sale and order summary incase discount and newprice    ${list_product}
    ...    ${list_nums}    ${list_ggsp}   ${list_discount_type}
    #compute
    ${result_tongthanhtien}    Sum values in list and round    ${list_result_thanhtien}
    ${result_tongtienhang}    Sum and replace floating point    ${result_tongthanhtien}    ${result_thanhtien_in_order}
    ${result_ggdh}    Run Keyword If    0 < ${input_ggdh} < 100    Convert % discount to VND and round    ${result_tongtienhang}    ${input_ggdh}
    ...    ELSE    Set Variable    ${input_ggdh}
    ${result_tongcong_in_dh}    Run Keyword If    0 < ${input_ggdh} < 100    Price after % discount invoice    ${result_tongtienhang}    ${input_ggdh}
    ...    ELSE    Minus and replace floating point    ${result_tongtienhang}    ${input_ggdh}
    ${result_khachcantra}    Minus and replace floating point    ${result_tongcong_in_dh}    ${get_khachdatra_in_dh_bf_execute}
    ${actual_khtt_all}    Set Variable If    '${input_khtt}' == 'all'    ${result_khachcantra}    ${input_khtt}
    ${actual_khtt}    Set Variable If    '${input_khtt}' == '0'    0    ${actual_khtt_all}
    ${actual_khtt_paymented}    Sum and replace floating point    ${actual_khtt}    ${get_khachdatra_in_dh_bf_execute}
    #input data into DH form
    Wait Until Keyword Succeeds    3 times    20 s    Before Test Ban Hang
    Element Should Not Be Visible    ${tab_hoadon}
    Element Should Not Be Visible      ${icon_select_th_hd}
    Go to xu ly dat hang    ${order_code}
    ${lastest_nums}    Set Variable    0
    Wait Until Keyword Succeeds    3 times    5 s    Input newprice for multi product    ${input_ma_hh}    ${input_ggsp}
    : FOR    ${item_product}    ${item_nums}    ${item_ggsp}    ${item_price}   ${item_discount_type}    IN ZIP    ${list_product}
    ...    ${list_nums}    ${list_ggsp}    ${list_result_giamoi}    ${list_discount_type}
    \    ${lastest_nums}    Wait Until Keyword Succeeds    3 times    5 s    Input product-num in sale form    ${item_product}    ${item_nums}
    \    ...    ${lastest_nums}    ${cell_tongsoluong_dh}
    \    Run keyword if    '${item_discount_type}' == 'dis'     Wait Until Keyword Succeeds    3 times    5 s    Input % discount for multi product    ${item_product}    ${item_ggsp}
    \    ...    ${item_price}    ELSE IF    '${item_discount_type}' == 'disvnd'    Input VND discount for multi product    ${item_product}    ${item_ggsp}    ${item_price}
    \    ...     ELSE IF  '${item_discount_type}' == 'changeup' or '${item_discount_type}' == 'changedown'    Wait Until Keyword Succeeds    3 times    5 s    Input newprice for multi product    ${item_product}    ${item_ggsp}
    \    ...    ELSE    Log    Ignore input
    Run Keyword If    0 < ${input_ggdh} < 100    Wait Until Keyword Succeeds    3 times    5 s    Input % discount order    ${input_ggdh}    ${result_ggdh}
    ...    ELSE    Wait Until Keyword Succeeds    3 times    5 s    Input VND discount order    ${input_ggdh}
    Run Keyword If    ${input_khtt}!=0    Wait Until Keyword Succeeds    3 times    5 s    Input order payment into BH    ${actual_khtt}    ${result_khachcantra}
    Input text to Ghi chu field    ${input_ghichu}
    Click Element JS    ${button_luu_order}
    Sleep    0.5s
    Order message success validation
    ${get_ma_dh}    Get saved code after execute
    #get values
    Sleep    15 s    wait for response to API
    #assert value order
    ${get_ma_kh_in_dh_af_execute}    ${get_TTDH_in_dh_af_execute}    ${get_tongtienhang_in_dh_af_exxecute}    ${get_khachdatra_in_dh_af_execute}    ${get_giamgia_in_dh_af_execute}    ${get_tongcong_in_dh_af_execute}    ${get_ghichu_in_dh_af_execute}
    ...    Get order info incase discount by order code    ${order_code}
    Should Be Equal As Strings    ${get_ma_kh_in_dh_af_execute}    ${input_ma_kh}
    Should Be Equal As Numbers    ${get_TTDH_in_dh_af_execute}    1    #1 : phiếu tạm
    Should Be Equal As Numbers    ${get_tongtienhang_in_dh_af_exxecute}    ${result_tongtienhang}
    Should Be Equal As Numbers    ${get_khachdatra_in_dh_af_execute}    ${actual_khtt_paymented}
    Should Be Equal As Numbers    ${get_giamgia_in_dh_af_execute}    ${result_ggdh}
    Should Be Equal As Numbers    ${get_tongcong_in_dh_af_execute}    ${result_tongcong_in_dh}
    Should Be Equal As Strings    ${get_ghichu_in_dh_af_execute}    ${input_ghichu}
    Delete order frm Order code    ${get_ma_dh}

pqdh3
    [Documentation]     Cập nhật người dùng có quyền: xem ds đặt hàng + xóa phiếu
    [Arguments]    ${taikhoan}    ${matkhau}      ${input_ma_kh}    ${input_ma_hh}    ${input_soluong}    ${input_khtt_create_order}
    Log    Cập nhật quyền xem ds + xóa phiếu dh
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên thu ngân
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String   {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"Order_Read":true,"TableAndRoom_Read":true,"TableAndRoom_Create":true,"TableAndRoom_Update":true,"TableAndRoom_Delete":true,"Clocking_Copy":false,"Order_Create":false,"Product_Delete":false,"Product_PurchasePrice":false,"Product_Update":false,"Invoice_ChangePrice":false,"Invoice_ChangeDiscount":false,"Customer_Read":false,"Order_Update":false,"Order_Delete":true}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"testhh","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}      ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    ##
    Before Test QL Dat Hang
    #
    ${order_code}    Add new order frm API    ${input_ma_kh}    ${input_ma_hh}    ${input_soluong}    ${input_khtt_create_order}
    Reload Page
    Search order code      ${order_code}
    Wait Until Page Contains Element    ${button_dh_huybo}    1 min
    Click Element    ${button_dh_huybo}
    Wait Until Page Contains Element    ${button_dh_dongy_huybo}    1 min
    Wait Until Keyword Succeeds    3 times    3s      Click Element     ${button_dh_dongy_huybo}
    Wait Until Keyword Succeeds    3 times    3s    Delete order message success validation    ${order_code}
    ${jsonpath_id_dh}    Format String    $..Data[?(@.Code == '{0}')].Id    ${order_code}
    ${get_id_dh}    Get data from API    ${endpoint_order}    ${jsonpath_id_dh}
    ${endpoint_orderdetail}    Format String    ${endpoint_order_detail}    ${get_id_dh}
    ${get_TTDH}    Get data from API      ${endpoint_orderdetail}    $.Status
    Should Be Equal As Numbers    ${get_TTDH}    4    #4: đã hủy
