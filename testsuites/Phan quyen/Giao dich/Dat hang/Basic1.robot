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
&{list_product1}    NHMT006=3
@{discount}        10
@{discount_type}   dis

*** Test Cases ***
Sao chép
    [Documentation]     Cập nhật người dùng csó quyền Đặt hàng: xem ds + thêm mới + Sao chép
    [Tags]        PQ
    [Template]    pqdh5
    thuy.ct    123        PQKH002        NHMT006               3.6             80000

Tạo hóa đơn
    [Documentation]     Cập nhật người dùng có quyền: Đặt hàng: xem ds + thêm mới + Cập nhật + Tạo hóa đơn, Hóa đơn: Thêm mới + Thay đổi giá + Cập nhật giảm giá hd, Khách hàng: xem ds
    [Tags]        PQ
    [Template]    pqdh4
    thuy.ct    123        PQKH002       15          ${list_product1}    ${discount}    ${discount_type}        all

*** Keywords ***
pqdh4
    [Documentation]     Cập nhật người dùng có quyền: Đặt hàng: xem ds + thêm mới + Cập nhật + Tạo hóa đơn, Hóa đơn: Thêm mới + Thay đổi giá + Cập nhật giảm giá hd, Khách hàng: xem ds
    [Arguments]    ${taikhoan}    ${matkhau}      ${input_ma_kh}    ${input_ggdh_tocreate}   ${dict_product_nums}    ${list_discount}    ${list_discount_type}   ${input_khtt_tocreate}
    Log    Cập nhật quyền Đặt hàng: xem ds + thêm mới + Cập nhật + Tạo hóa đơn, Hóa đơn: Thêm mới + Thay đổi giá + Cập nhật giảm giá hd, Khách hàng: xem ds
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên thu ngân
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String  {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"Order_Read":true,"TableAndRoom_Read":true,"TableAndRoom_Create":true,"TableAndRoom_Update":true,"TableAndRoom_Delete":true,"Clocking_Copy":false,"Order_Create":true,"Product_Delete":false,"Product_PurchasePrice":false,"Product_Update":false,"Invoice_ChangePrice":true,"Invoice_ChangeDiscount":true,"Customer_Read":true,"Order_Update":true,"Order_Delete":false,"Order_MakeInvoice":true,"Invoice_UpdateCompleted":false,"Invoice_ModifySeller":false,"Invoice_Create":true}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}      ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Selenium Speed    0.5s
    #get info product, customer
    ${order_code}   Add new order incase discount - payment    ${input_ma_kh}    ${input_ggdh_tocreate}    ${dict_product_nums}    ${list_discount}
    ...   ${list_discount_type}   ${input_khtt_tocreate}
    ${list_product}    Get Dictionary Keys    ${dict_product_nums}
    ${list_num}    Get Dictionary Values    ${dict_product_nums}
    Create list imei and other product    ${list_product}    ${list_num}
    ${order_code}    ${get_khachdatra_in_dh_bf_execute}    ${get_ggdh_in_dh_bf_execute}    ${get_tongtienhang_in_dh_bf_execute}    ${get_tongcong_in_dh_bf_execute}    Get order code - paid - discount value frm API    ${input_ma_kh}
    ${get_list_status_imei}   Get list imei status thr API    ${list_product}
    ${list_result_tongdh}    ${result_list_toncuoi}    ${result_list_thanhtien}    Get list order summary - total sale - ending stocks frm API    ${order_code}    ${list_product}
    #compute
    ${result_tongtienhang}    Sum values in list    ${result_list_thanhtien}
    ${result_TTH_tru_ggdh}    Run Keyword If    0 < ${get_ggdh_in_dh_bf_execute} < 100    Price after % discount invoice    ${result_tongtienhang}    ${get_ggdh_in_dh_bf_execute}
    ...    ELSE IF    ${get_ggdh_in_dh_bf_execute} > 100    Minus and replace floating point    ${result_tongtienhang}    ${get_ggdh_in_dh_bf_execute}
    ...    ELSE    Set Variable    ${result_tongtienhang}
    ${result_gghd}    Run Keyword If    0 < ${get_ggdh_in_dh_bf_execute} < 100    Convert % discount to VND and round    ${result_tongtienhang}    ${get_ggdh_in_dh_bf_execute}
    ...    ELSE    Set Variable    ${get_ggdh_in_dh_bf_execute}
    #create invoice from order
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    Wait Until Keyword Succeeds    3 times    20 s    Before Test Ban Hang
    Go to xu ly dat hang    ${order_code}
    Wait Until Keyword Succeeds    3 times    5s    Go to BH frm process order    ${order_code}
    : FOR    ${item_product}    ${status_imei}    ${item_imei}    IN ZIP    ${list_product}    ${get_list_status_imei}    ${imei_inlist}
    \    Run Keyword If    '${status_imei}' == 'True'    Wait Until Keyword Succeeds    3 times    8 s    Input imei incase multi product to any form    ${item_product}    ${texbox_imei_search_multi_product}
    \    ...    ${item_serial_in_dropdown}    ${cell_imei_multi_product}    @{item_imei}    ELSE      Log     Ignore input
    Wait Until Keyword Succeeds    3 times    2s    Click Element JS    ${button_bh_thanhtoan}
    Invoice message success validation
    ${invoice_code}    Wait Until Keyword Succeeds    3 times    2s    Get saved code after execute
    #get value
    Delete invoice by invoice code    ${invoice_code}
    Delete order frm Order code    ${order_code}

pqdh5
    [Documentation]     Cập nhật người dùng csó quyền Đặt hàng: xem ds + thêm mới + Sao chép
    [Arguments]    ${taikhoan}    ${matkhau}      ${input_ma_kh}    ${input_ma_hh}    ${input_soluong}    ${input_khtt}
    Log    Cập nhật quyền Đặt hàng: Xem DS + Thêm mới + Sao chép
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên thu ngân
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String   {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"Invoice_Read":false,"Invoice_Create":false,"TableAndRoom_Read":true,"TableAndRoom_Create":true,"TableAndRoom_Update":true,"TableAndRoom_Delete":true,"Invoice_CopyInvoice":false,"Clocking_Copy":false,"Invoice_Update":false,"Invoice_Delete":false,"Invoice_Export":false,"Invoice_ReadOnHand":false,"Invoice_ChangePrice":false,"Invoice_ChangeDiscount":false,"Invoice_ModifySeller":false,"Invoice_UpdateCompleted":false,"Invoice_RepeatPrint":false,"Invoice_UpdateWarranty":false,"Order_Read":true,"Order_Create":true,"Order_CopyOrder":true}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}      ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    ${get_ma_dh}    Add new order frm API    ${input_ma_kh}    ${input_ma_hh}    ${input_soluong}    ${input_khtt}
    ##
    Before Test QL Dat Hang
    Search order code    ${get_ma_dh}
    Wait Until Page Contains Element    ${button_dh_saochep}     1 min
    ${jsonpath_id_dh}    Format String    $..Data[?(@.Code == '{0}')].Id    ${get_ma_dh}
    ${get_id_dh}    Get data from API    ${endpoint_order}    ${jsonpath_id_dh}
    Wait Until Keyword Succeeds    3x    5s    Click Element    ${button_dh_saochep}
    ${url_bh}       Set Variable       ${URL}/sale/#/?copyorder=${get_id_dh}
    Wait Until Keyword Succeeds    10 times    6s    Select Window   url=${url_bh}
    ${text_tab_sc}    Set Variable       Copy_${get_ma_dh}
    Wait Until Keyword Succeeds    3 times    5s    Deactivate print preview page
    ${tab_saochep}      Format String    //span[text()='{0}']    ${text_tab_sc}
    Wait Until Page Contains Element      ${tab_saochep}      1 min
    Wait Until Page Contains Element    ${button_bh_dathang}    1 min
    Click Element JS    ${button_bh_dathang}
    Order message success validation
    ${order_code}    Get saved code after execute
    ${result_order_code}      Set Variable        ${get_ma_dh}.01
    Should Be Equal As Strings    ${order_code}    ${result_order_code}
    Delete order frm Order code    ${order_code}
    Delete order frm Order code    ${get_ma_dh}
