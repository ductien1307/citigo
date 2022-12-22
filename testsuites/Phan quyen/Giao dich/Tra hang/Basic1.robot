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
Resource          ../../../../core/API/api_trahang.robot
Resource          ../../../../core/Giao_dich/hoa_don_list_action.robot
Resource          ../../../../core/Giao_dich/tra_hang_list_action.robot

*** Variables ***
&{dict_product_nums01}    NHMT008=6
&{list_create_imei1}    GHIM04=2
@{list_giamoi}    190000    20000.5

*** Test Cases ***
Xóa
    [Documentation]     Người dùng có quyền Trả hàng: Xem DS, Xóa (trên live đang lỗi)
    [Tags]        #PQ
    [Template]    pqth3
    [Timeout]       5 mins
    hung.hq    123   PQKH006      ${dict_product_nums01}          ${list_create_imei1}      ${list_giamoi}    100000      15000               10    100000

Sao chép
    [Documentation]     Người dùng có quyền Trả hàng: Xem DS, Sao chép
    [Tags]        PQ
    [Template]    pqth4
    [Timeout]       5 mins
    hung.hq    123   PQKH006      ${dict_product_nums01}          ${list_create_imei1}     ${list_giamoi}     100000      15000               10    100000

Cập nhật
    [Documentation]     Người dùng có quyền Trả hàng: Xem DS, Cập nhật
    [Tags]        PQ
    [Template]    pqth5
    [Timeout]       5 mins
    hung.hq    123   PQKH006      ${dict_product_nums01}          ${list_create_imei1}    ${list_giamoi}      100000      15000               10    100000

*** Keywords ***
pqth3
    [Documentation]     Người dùng có quyền Trả hàng: Xem DS, Xóa (trên live đang lỗi)
    [Arguments]    ${taikhoan}    ${matkhau}    ${input_ma_kh}    ${dict_product_nums}     ${list_imei}    ${list_newprice}    ${newprice_imei}    ${input_ggth}
    ...    ${input_phi_th}    ${input_khtt}
    Log    Cập nhật Người dùng có quyền Trả hàng: Xem DS, Xóa
    ${get_user_id}    Get User ID by UserName    ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên thu ngân
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String   {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"Customer_Read":false,"Invoice_Read":false,"Return_Read":true,"Return_Update":false,"TableAndRoom_Read":true,"TableAndRoom_Create":true,"TableAndRoom_Update":true,"TableAndRoom_Delete":true,"Invoice_ChangePrice":false,"Invoice_ChangeDiscount":false,"Clocking_Copy":false,"Invoice_Create":false,"Invoice_Update":false,"Invoice_Delete":false,"Invoice_Export":false,"Invoice_ReadOnHand":false,"Invoice_ModifySeller":false,"Invoice_UpdateCompleted":false,"Invoice_RepeatPrint":false,"Invoice_CopyInvoice":false,"Invoice_UpdateWarranty":false,"Customer_Create":false,"Customer_Update":false,"Customer_Delete":false,"Customer_ViewPhone":false,"Customer_Import":false,"Customer_Export":false,"Customer_UpdateGroup":false,"Return_Delete":true}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}     ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #create hoa don
    ${return_code}   Add new return thr API    ${input_ma_kh}    ${dict_product_nums}    ${list_imei}    ${list_newprice}    ${newprice_imei}    ${input_ggth}
    ...    ${input_phi_th}    ${input_khtt}
    #get data frm Trả hàng
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    Wait Until Keyword Succeeds    3 times    8 s    Before Test QL Tra hang
    Search return code    ${return_code}
    Wait Until Page Contains Element    ${button_th_huybo}        30s
    Click Element    ${button_th_huybo}
    Wait Until Page Contains Element    ${button_th_dongy_huybo}    10s
    Click Element    ${button_th_dongy_huybo}
    Return delete message success validation    ${return_code}
    ${endpoint_trahang}    Format String    ${endpoint_trahang}    ${BranchId}
    ${get_resp}    Get Request and return body    ${endpoint_trahang}
    ${jsonpath_trangthai}    Format String    $.Data[?(@.Code == '{0}')].Status    ${return_code}
    ${get_trangthai}    Get data from response json    ${get_resp}    ${jsonpath_trangthai}
    Set Global Variable    \${USER_NAME}     admin
    Should Be Equal As Numbers    ${get_trangthai}    2
    Delete return thr API    ${return_code}

pqth4
    [Documentation]     Người dùng có quyền Trả hàng: Xem DS, Xóa (trên live đang lỗi)
    [Arguments]    ${taikhoan}    ${matkhau}    ${input_ma_kh}    ${dict_product_nums}    ${list_imei}    ${list_newprice}    ${newprice_imei}    ${input_ggth}
    ...    ${input_phi_th}    ${input_khtt}
    Log    Cập nhật Người dùng Trả hàng: Xem DS, Xóa
    ${get_user_id}    Get User ID by UserName    ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên thu ngân
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String   {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"Invoice_Read":false,"Invoice_Create":false,"TableAndRoom_Read":true,"TableAndRoom_Create":true,"TableAndRoom_Update":true,"TableAndRoom_Delete":true,"Invoice_CopyInvoice":false,"Clocking_Copy":false,"Invoice_Update":false,"Invoice_Delete":false,"Invoice_Export":false,"Invoice_ReadOnHand":false,"Invoice_ChangePrice":false,"Invoice_ChangeDiscount":false,"Invoice_ModifySeller":false,"Invoice_UpdateCompleted":false,"Invoice_RepeatPrint":false,"Invoice_UpdateWarranty":false,"Order_Read":false,"Order_Create":false,"Order_CopyOrder":false,"Order_Update":false,"Order_Delete":false,"Order_RepeatPrint":false,"Order_Export":false,"Order_MakeInvoice":false,"Order_UpdateWarranty":false,"Return_Read":true,"Return_Create":true,"Return_CopyReturn":true,"Return_Update":false,"Return_Delete":false,"Return_RepeatPrint":false,"Return_Export":false}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}       ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #create hoa don
    ${input_imei_product}    Get Dictionary Keys    ${list_imei}
    ${input_imei_nums}    Get Dictionary Values    ${list_imei}
    ${input_product}    ${input_imei_nums}    Convert two list to string and return    ${input_imei_product}    ${input_imei_nums}
    ${list_products}    Get Dictionary Keys    ${dict_product_nums}
    ${list_nums}    Get Dictionary Values    ${dict_product_nums}
    ${get_ma_th}   Add new return thr API    ${input_ma_kh}    ${dict_product_nums}    ${list_imei}    ${list_newprice}    ${newprice_imei}    ${input_ggth}
    ...    ${input_phi_th}    ${input_khtt}
    #get data frm Trả hàng
    #
    ${get_list_status}    Get list imei status thr API    ${list_imei}
    Create invoice with imei product    ${input_ma_kh}    ${list_imei}    ${get_list_status}
    Sleep    4s
    Append To List    ${list_products}    ${input_product}
    Append to List    ${list_nums}    ${input_imei_nums}
    Append To List    ${list_newprice}    ${newprice_imei}
    ${list_result_thanhtien_newprice}    ${list_giavon}    ${list_result_toncuoi}    Get list total sale - endingstock - cost incase newprice    ${list_products}    ${list_nums}    ${list_newprice}
    #compute
    ${result_tongtienhangtra}    Sum values in list and round    ${list_result_thanhtien_newprice}
    ${result_ggth}    Run Keyword If    0 < ${input_ggth} < 100    Convert % discount to VND and round    ${result_tongtienhangtra}    ${input_ggth}
    ...    ELSE    Set Variable    ${input_ggth}
    ${result_phi_th}    Run Keyword If    0 < ${input_phi_th} < 100    Convert % discount to VND and round    ${result_tongtienhangtra}    ${input_phi_th}
    ...    ELSE    Set Variable    ${input_phi_th}
    ${result_cantrakhach}    Minusx3 and replace foating point    ${result_tongtienhangtra}    ${result_ggth}    ${result_phi_th}
    ${result_khtt}    Set Variable If    "${input_khtt}" == "all"    ${result_cantrakhach}    ${input_khtt}
    ${actual_khtt}    Set Variable If    "${input_khtt}" == "0"    0    ${result_khtt}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    Wait Until Keyword Succeeds    3 times    8 s    Before Test QL Tra hang
    ${get_return_id}    Get return id    ${get_ma_th}
    Search return code    ${get_ma_th}
    Wait Until Page Contains Element    ${button_th_saochep}     1 min
    Wait Until Keyword Succeeds    3 times    4s    Click Element    ${button_th_saochep}
    ${url_bh}       Set Variable        ${URL}/sale/#/?return=${get_return_id}
    Wait Until Keyword Succeeds    3 times    2s    Select Window   url=${url_bh}
    Wait Until Keyword Succeeds    3 times    5s    Deactivate print warranty and preview page
    ${text_tab_sc}    Set Variable       Copy_${get_ma_th}
    ${tab_saochep}      Format String    //span[text()='{0}']    ${text_tab_sc}
    Wait Until Page Contains Element      ${tab_saochep}      1 min
    : FOR    ${item_imei}    IN    @{imei_inlist}
    \    Wait Until Keyword Succeeds    3 times    5 s    Input product and imei incase multi product to any form    ${textbox_bh_search_ma_sp}    ${input_product}
    \    ...    ${item_search_product_indropdow}    ${textbox_nhap_serial}    ${item_serial_in_dropdown}    ${cell_bh_ma_sp}    ${cell_item_input_imei}
    \    ...    @{item_imei}
    Wait Until Page Contains Element    ${button_th}    1 min
    Click Element JS    ${button_th}
    Return message success validation
    ${return_code}    Wait Until Keyword Succeeds    3 times    5 s    Get saved code after execute
    ${result_return_code}      Set Variable        ${get_ma_th}.01
    Should Be Equal As Strings    ${return_code}    ${result_return_code}
    Sleep    15s
    Set Global Variable    \${USER_NAME}    ${USER_ADMIN}
    #assert value in return
    ${get_tongtienhangtra_af_ex}    ${get_giamgiaphieutra}    ${get_phitrahang_af_ex}    ${get_cantrakhach_af_ex}    ${get_datrakhach_af_ex}    ${get_tongtien_hoadontra_af_ex}    Get return info incase discount by return code    ${return_code}
    Should Be Equal As Numbers    ${get_tongtienhangtra_af_ex}    ${result_tongtienhangtra}
    Should Be Equal As Numbers    ${get_giamgiaphieutra}    ${result_ggth}
    Should Be Equal As Numbers    ${get_phitrahang_af_ex}    ${result_phi_th}
    Should Be Equal As Numbers    ${get_datrakhach_af_ex}    ${result_cantrakhach}
    Should Be Equal As Numbers    ${get_tongtien_hoadontra_af_ex}    ${result_cantrakhach}
    Remove From List    ${list_newprice}    -1
    Delete return thr API        ${return_code}

pqth5
    [Documentation]     Người dùng có quyền Trả hàng: Xem DS, Cập nhật
    [Arguments]    ${taikhoan}    ${matkhau}    ${input_ma_kh}    ${dict_product_nums}    ${list_imei}    ${list_newprice}    ${newprice_imei}    ${input_ggth}
    ...    ${input_phi_th}    ${input_khtt}
    ${get_user_id}    Get User ID by UserName    ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên thu ngân
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String   {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"Order_Read":false,"Order_Update":false,"Return_Read":true,"Return_Update":true,"TableAndRoom_Read":true,"TableAndRoom_Create":true,"TableAndRoom_Update":true,"TableAndRoom_Delete":true,"Clocking_Copy":false,"Order_Create":false,"Order_Delete":false,"Order_RepeatPrint":false,"Order_Export":false,"Order_MakeInvoice":false,"Order_CopyOrder":false,"Order_UpdateWarranty":false,"Return_Create":true}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}       ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #create hoa don
    ${input_imei_product}    Get Dictionary Keys    ${list_imei}
    ${input_imei_nums}    Get Dictionary Values    ${list_imei}
    ${input_product}    ${input_imei_nums}    Convert two list to string and return    ${input_imei_product}    ${input_imei_nums}
    ${list_products}    Get Dictionary Keys    ${dict_product_nums}
    ${list_nums}    Get Dictionary Values    ${dict_product_nums}
    ${get_ma_th}   Add new return thr API    ${input_ma_kh}    ${dict_product_nums}    ${list_imei}    ${list_newprice}    ${newprice_imei}    ${input_ggth}
    ...    ${input_phi_th}    ${input_khtt}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    Wait Until Keyword Succeeds    3 times    8 s    Before Test QL Tra hang
    Search return code    ${get_ma_th}
    Wait until page contains element    ${button_th_luu}    25s
    Click Element     ${button_th_luu}
    Return update message success validation    ${get_ma_th}
    Delete return thr API    ${get_ma_th}
