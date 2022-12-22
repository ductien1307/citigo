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
&{dict_product_nums01}    TP017=6
&{list_create_imei1}    GHIM02=2
@{list_discount}    18    25
&{list_productnums_TH1}    GHC0004=1
&{list_productnums_DTH01}         GHC0003=7      TP017=5.5
&{list_imei_dth01}    GHIM03=1
@{list_giamoi}    190000    20000.5

*** Test Cases ***
Thêm mới
    [Documentation]     (case trả hàng)    Người dùng có quyền Hóa đơn: Xem DS, Thay đổi giá, Cập nhật gghd; Khách hàng: Xem DS; Trả hàng: Xem DS, Thêm mới
    [Tags]        PQ
    [Template]    pqth1
    ninh.nt    123    PQKH005       ${dict_product_nums01}    ${list_create_imei1}    10               0                   ${list_discount}       18       all

Thêm mới 1
    [Documentation]     (case đổi trả hàng)    Người dùng có quyền Hóa đơn: Xem DS, Thêm mới, Thay đổi giá, Cập nhật gghd; Khách hàng: Xem DS; Trả hàng: Xem DS, Thêm mới
    [Tags]        PQ
    [Template]    pqth2
    ninh.nt    123    PQKH005       ${list_productnums_TH1}    ${list_productnums_DTH01}    ${list_imei_dth01}    10               ${list_giamoi}    35000           50000    100000              all

*** Keywords ***
pqth1
    [Documentation]     Người dùng có quyền Hóa đơn: Xem DS, Thay đổi giá, Cập nhật gghd; Khách hàng: Xem DS; Trar hangf: Xem DS, Thêm mới
    [Arguments]    ${taikhoan}    ${matkhau}    ${input_ma_kh}    ${dict_product_nums}    ${list_imei}    ${input_phi_th}    ${input_khtt}    ${list_ggsp}
    ...    ${input_gghd}    ${input_khtt_hd}
    Log    Cập nhật Người dùng có quyền Hóa đơn: Xem DS, Thay đổi giá, Cập nhật gghd; Khách hàng: Xem DS; Trar hangf: Xem DS, Thêm mới
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên thu ngân
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"Invoice_Read":true,"Invoice_Delete":false,"TableAndRoom_Read":true,"TableAndRoom_Create":true,"TableAndRoom_Update":true,"TableAndRoom_Delete":true,"Clocking_Copy":false,"Invoice_Create":false,"Invoice_Update":false,"Invoice_Export":false,"Invoice_ReadOnHand":false,"Invoice_ChangePrice":true,"Invoice_ChangeDiscount":true,"Invoice_ModifySeller":false,"Invoice_UpdateCompleted":false,"Invoice_RepeatPrint":false,"Invoice_CopyInvoice":false,"Invoice_UpdateWarranty":false,"Return_Read":true,"Return_Create":true,"Customer_Read":true,"Customer_UpdateGroup":false}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}     ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    ##
    Set Selenium Speed    0.5s
    #create hoa don
    ${list_product_imei}    Get Dictionary Keys    ${list_imei}
    ${list_nums_imei}    Get Dictionary Values    ${list_imei}
    ${get_ma_hd}    Add new invoice incase discount with multi product - get invoice code    ${input_ma_kh}    ${dict_product_nums}    ${list_ggsp}    ${input_gghd}    none
    ...    ${input_khtt_hd}
    ${input_product}    ${input_imei_nums}    Convert two list to string and return    ${list_product_imei}    ${list_nums_imei}
    #get data to validate
    Wait Until Keyword Succeeds    3 times    8 s    Before Test Ban Hang deactivate print warranty
    Reload Page
    Set Global Variable    \${USER_NAME}    ${USER_ADMIN}
    ${get_list_hh_in_hd}    ${get_list_sl_in_hd}    Get list product and quantity frm invoice API    ${get_ma_hd}
    ${get_list_sl_in_hd}    Convert String to List    ${get_list_sl_in_hd}
    ${get_ma_kh_by_hd_bf_ex}    ${get_tong_tien_hang_bf_ex}    ${get_khach_tt_bf_ex}    ${get_giamgia_hd_bf_ex}    ${get_khachcantra_bf_ex}    ${get_trangthai_bf_ex}    Get invoice info incase discount by invoice code
    ...    ${get_ma_hd}
    ${get_du_no_kh}    Get Du no cuoi KH from API    ${input_ma_kh}
    ${list_result_thanhtien}    ${list_giavon}    ${list_result_toncuoi}    Get list total sale - endingstock - cost incase discount    ${get_list_hh_in_hd}    ${get_list_sl_in_hd}    ${list_ggsp}
    Remove Values From List    ${get_list_hh_in_hd}    ${input_product}
    Remove Values From List    ${get_list_sl_in_hd}    ${input_imei_nums}
    #compute value invoice and customer
    ${result_gghd}    Run Keyword If    0 < ${input_gghd} < 100    Convert % discount to VND and round    ${get_tong_tien_hang_bf_ex}    ${input_gghd}
    ...    ELSE    Set Variable    ${input_gghd}
    ${result_tongtienhangtra}    Sum values in list    ${list_result_thanhtien}
    ${result_phi_th}    Run Keyword If    0 < ${input_phi_th} < 100    Convert % discount to VND and round    ${result_tongtienhangtra}    ${input_phi_th}
    ...    ELSE    Set Variable    ${input_phi_th}
    ${result_cantrakhach}    Minusx3 and replace foating point    ${result_tongtienhangtra}    ${result_phi_th}    ${result_gghd}
    ${result_khtt}    Set Variable If    "${input_khtt}" == "all"    ${result_cantrakhach}    ${input_khtt}
    ${actual_khtt}    Set Variable If    "${input_khtt}" == "0"    0    ${result_khtt}
    #create return
    Wait Until Keyword Succeeds    3 times    8 s    Select Invoice from Ban Hang page    ${get_ma_hd}
    Element Should Not Be Visible        ${textbox_th_search_hangdoi}
    : FOR    ${item_imei}    IN    @{imei_inlist}
    \    Run Keyword If    "${item_imei}" == "${EMPTY}"    Log    Ignore
    \    ...    ELSE    Wait Until Keyword Succeeds    3 times    8 s    Input imei incase multi product to any form
    \    ...    ${input_product}    ${texbox_imei_search_multi_product}    ${item_serial_in_dropdown}    ${cell_imei_multi_product}    @{item_imei}
    ${laster_number}    Set Variable    0
    : FOR    ${item_hh}    ${item_soluong}    IN ZIP    ${get_list_hh_in_hd}    ${get_list_sl_in_hd}
    \    ${laster_number}    Input nums for multi product    ${item_hh}    ${item_soluong}    ${laster_number}    ${cell_laster_numbers_return}
    Wait Until Keyword Succeeds    3 times    8 s    Run keyword if    0 < ${input_phi_th} < 100    Input % return free value    ${input_phi_th}
    ...    ${result_phi_th}
    ...    ELSE    Input VND return free value    ${input_phi_th}
    Wait Until Keyword Succeeds    3 times    8 s    Input payment into any form    ${textbox_th_khachttTraHang}    ${actual_khtt}    ${button_th}
    Wait Until Keyword Succeeds    3 times    8 s    Run Keyword If    0 <=${get_khach_tt_bf_ex} < ${result_tongtienhangtra} and ${input_khtt} != 0 and ${get_du_no_kh} > 0    Close return popup
    ...    ELSE    Log    Ignore click
    Sleep    10s
    ${return_code}      Wait Until Keyword Succeeds    3 times    3s     Get saved code after execute
    Execute Javascript    location.reload();
    Sleep    5 s    wait for response to API
    #assert value product
    Set Global Variable    \${USER_NAME}    ${USER_ADMIN}
    #assert value in invoice
    ${get_ma_kh_by_hd_af_ex}    ${get_tong_tien_hang_af_ex}    ${get_khach_tt_af_ex}    ${get_giamgia_hd_af_ex}    ${get_khachcantra_af_ex}    ${get_trangthai_af_ex}    Get invoice info incase discount by invoice code
    ...    ${get_ma_hd}
    Should Be Equal As Numbers    ${get_tong_tien_hang_af_ex}    ${get_tong_tien_hang_bf_ex}
    Should Be Equal As Numbers    ${get_khach_tt_af_ex}    ${get_khach_tt_bf_ex}
    Should Be Equal As Numbers    ${get_giamgia_hd_af_ex}    ${get_giamgia_hd_bf_ex}
    Should Be Equal As Numbers    ${get_khachcantra_af_ex}    ${get_khachcantra_bf_ex}
    Should Be Equal As Strings    ${get_ma_kh_by_hd_af_ex}    ${get_ma_kh_by_hd_bf_ex}
    Should Be Equal As Strings    ${get_trangthai_af_ex}    ${get_trangthai_bf_ex}
    #assert value in return
    ${get_tongtienhangtra_af_ex}    ${get_giamgiaphieutra}    ${get_phitrahang_af_ex}    ${get_cantrakhach_af_ex}    ${get_datrakhach_af_ex}    ${get_tongtien_hoadontra_af_ex}    Get return info incase discount by return code
    ...    ${return_code}
    Should Be Equal As Numbers    ${get_tongtienhangtra_af_ex}    ${result_tongtienhangtra}
    Should Be Equal As Numbers    ${get_giamgiaphieutra}    ${result_gghd}
    Should Be Equal As Numbers    ${get_phitrahang_af_ex}    ${result_phi_th}
    Should Be Equal As Numbers    ${get_tongtien_hoadontra_af_ex}    ${result_cantrakhach}
    Should Be Equal As Numbers    ${get_datrakhach_af_ex}    ${actual_khtt}
    Validate return history by invoice code    ${get_ma_hd}    ${return_code}    ${result_tongtienhangtra}
    Delete return thr API    ${return_code}

pqth2
    [Documentation]     Người dùng có quyền Hóa đơn: Xem DS, Thêm mới, Thay đổi giá, Cập nhật gghd; Khách hàng: Xem DS; Trar hangf: Xem DS, Thêm mới
    [Arguments]    ${taikhoan}    ${matkhau}     ${input_ma_kh}    ${dic_productnums_th}    ${dic_productnums_dth}    ${list_imei_nums}    ${input_phi_th}    ${list_newprice}
    ...    ${input_newprice_imei}    ${input_ggdth}    ${input_khtt}    ${input_khtt_hd}
    Log    Cập nhật Người dùng có quyền Hóa đơn: Xem DS, Thêm mới, Thay đổi giá, Cập nhật gghd; Khách hàng: Xem DS; Trar hangf: Xem DS, Thêm mới
    ${get_user_id}    Get User ID by UserName    ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên thu ngân
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"Customer_Read":true,"Invoice_Read":true,"Return_Read":true,"Return_Create":true,"TableAndRoom_Read":true,"TableAndRoom_Create":true,"TableAndRoom_Update":true,"TableAndRoom_Delete":true,"Invoice_ChangePrice":true,"Invoice_ChangeDiscount":true,"Clocking_Copy":false,"Invoice_Create":true}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}     ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    ##
    Set Selenium Speed    0.5s
    #create hoa don
    ${list_product_dth}    Get Dictionary Keys    ${dic_productnums_dth}
    ${list_nums_dth}    Get Dictionary Values    ${dic_productnums_dth}
    ${list_imei_product_dth}    Get Dictionary Keys    ${list_imei_nums}
    ${list_imei_nums_dth}    Get Dictionary Values    ${list_imei_nums}
    ${input_product_imei}    ${input_imei_nums}    Convert two list to string and return    ${list_imei_product_dth}    ${list_imei_nums_dth}
    Create list imei    ${list_imei_product_dth}    ${list_imei_nums_dth}
    ${get_ma_hd}    Add new invoice frm API    ${input_ma_kh}    ${dic_productnums_th}    ${input_khtt_hd}
    #get data frm Trả hàng
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    Wait Until Keyword Succeeds    3 times    8 s    Before Test Ban Hang
    Set Global Variable    \${USER_NAME}    ${USER_ADMIN}
    ${get_ma_kh_by_hd_bf_ex}    ${get_tong_tien_hang_bf_ex}    ${get_khach_tt_bf_ex}    ${get_trangthai_bf_ex}    Get invoice info by invoice code    ${get_ma_hd}
    ${get_list_hh_in_hd}    ${get_list_sl_in_hd}    Get list product and quantity frm invoice API    ${get_ma_hd}
    ${get_list_sl_in_hd}    Convert String to List    ${get_list_sl_in_hd}
    ${get_no_bf_execute}    ${get_tongban_bf_execute}    ${get_tongban_tru_trahang_bf_execute}    Get Customer Debt from API    ${input_ma_kh}
    ${list_result_thanhtien_th}    ${list_giavon_th}    ${list_result_toncuoi_th}    Get list total sale - endingstock - cost frm product api    ${get_list_hh_in_hd}    ${get_list_sl_in_hd}
    #input product into DTH form
    Select Invoice from Ban Hang page    ${get_ma_hd}
    ${laster_nums}    Set Variable    0
    : FOR    ${item_hh}    ${item_soluong}    IN ZIP    ${get_list_hh_in_hd}    ${get_list_sl_in_hd}
    \    ${laster_nums}    Input nums for multi product    ${item_hh}    ${item_soluong}    ${laster_nums}    ${cell_laster_numbers_return}
    ${laster_nums1}    Set Variable    0
    : FOR    ${item_product_dth}    ${item_nums_dth}    ${item_newprice}    IN ZIP    ${list_product_dth}    ${list_nums_dth}
    ...    ${list_newprice}
    \    ${laster_nums1}    Wait Until Keyword Succeeds    3 times    5 s    Input product and nums into Doi tra hang form    ${item_product_dth}    ${item_nums_dth}
    \    ...    ${laster_nums1}
    \    Wait Until Keyword Succeeds    3 times    5 s    Input newprice for multi product    ${item_product_dth}    ${item_newprice}
    : FOR    ${item_product_imei}    ${item_imei}    IN ZIP    ${list_imei_product_dth}    ${imei_inlist}
    \    Wait Until Keyword Succeeds    3 times    8 s    Input product and imei incase multi product to any form    ${textbox_th_search_hangdoi}    ${item_product_imei}
    \    ...    ${cell_dth_sanpham}    ${textbox_dth_nhap_serial}    ${item_dth_imei_in_dropdown}    ${cell_dth_ma_sanpham}    ${cell_dth_imei_multi_product}
    \    ...    @{item_imei}
    Wait Until Keyword Succeeds    3 times    5 s    Input newprice for multi product    ${input_product_imei}    ${input_newprice_imei}
    #get data frm Doi hang
    Append To List    ${list_product_dth}    ${input_product_imei}
    Append to List    ${list_nums_dth}    ${input_imei_nums}
    Append to List    ${list_newprice}    ${input_newprice_imei}
    ${list_result_thanhtien_dth}    ${list_giavon_dth}    ${list_result_toncuoi_dth}    Get list total sale - endingstock - cost incase newprice with additional invoice    ${list_product_dth}    ${list_nums_dth}    ${list_newprice}
    #compute trả hàngGet list total sale - endingstock - cost frm product api
    ${result_tongtientra}    Sum values in list    ${list_result_thanhtien_th}
    ${result_phi_th}    Run Keyword If    0 < ${input_phi_th} < 100    Convert % discount to VND and round    ${result_tongtientra}    ${input_phi_th}
    ...    ELSE    Set Variable    ${input_phi_th}
    ${result_tongtientra_tru_phith}    Minus and round 2    ${result_tongtientra}    ${result_phi_th}
    #compute mua hàng
    ${result_tongtienmua}    Sum values in list    ${list_result_thanhtien_dth}
    ${result_ggdth}    Run Keyword If    0 < ${input_ggdth} < 100    Convert % discount to VND and round    ${result_tongtienmua}    ${input_ggdth}
    ...    ELSE    Set Variable    ${input_ggdth}
    ${result_tongtienmua_tru_gg}    Minus and round 2    ${result_tongtienmua}    ${result_ggdth}
    ${result_khachthanhtoan}    Minus and round 2    ${result_tongtienmua_tru_gg}    ${result_tongtientra_tru_phith}
    ${result_cantrakhach}    Minus and round 2    ${result_tongtientra_tru_phith}    ${result_tongtienmua_tru_gg}
    ${result_kh_canthanhtoan}    Set Variable If    ${result_tongtienmua_tru_gg}<${result_tongtientra_tru_phith}    ${result_cantrakhach}    ${result_khachthanhtoan}
    ${result_khtt}    Set Variable If    "${input_khtt}" == "all"    ${result_kh_canthanhtoan}    ${input_khtt}
    ${actual_khtt}    Set Variable If    "${input_khtt}" == "0"    0    ${result_khtt}
    ${actuall_trahang}    Set Variable If    ${result_tongtienmua_tru_gg}<${result_tongtientra_tru_phith}    ${actual_khtt}    0
    #compute KH
    ${result_du_no_th_KH}    Minus    ${get_no_bf_execute}    ${result_tongtientra_tru_phith}
    ${result_PTT_th_KH}    Run Keyword If    ${result_tongtienmua_tru_gg}<${result_tongtientra_tru_phith}    Sum    ${result_du_no_th_KH}    ${actual_khtt}
    ...    ELSE    Set Variable    ${result_du_no_th_KH}
    ${result_du_no_KH}    Sum and replace floating point    ${result_PTT_th_KH}    ${result_tongtienmua_tru_gg}
    ${result_PTT_dth_KH}    Run Keyword If    ${result_tongtienmua_tru_gg}>${result_tongtientra_tru_phith}    Minus    ${result_du_no_KH}    ${actual_khtt}
    ...    ELSE    Set Variable    ${result_du_no_KH}
    ${result_tongban}    Sum and replace floating point    ${get_tongban_bf_execute}    ${result_tongtienmua_tru_gg}
    #create đổi trả hàng
    Wait Until Keyword Succeeds    3 times    5 s    Run keyword if    0 < ${input_phi_th} < 100    Input % return free value    ${input_phi_th}
    ...    ${result_phi_th}
    ...    ELSE    Input VND return free value    ${input_phi_th}
    Wait Until Keyword Succeeds    3 times    5 s    Run Keyword If    0 < ${input_ggdth} < 100    Input % discount additional invoice    ${input_ggdth}
    ...    ${result_ggdth}
    ...    ELSE    Input VND discount additional invoice    ${input_ggdth}
    ${button_thanhtoan}    Set Variable If    ${result_tongtienmua_tru_gg}<${result_tongtientra_tru_phith}    ${textbox_dth_tientrakhach}    ${textbox_dth_khachthanhtoan}
    Wait Until Keyword Succeeds    3 times    5 s    Run Keyword If    "${input_khtt}" == "all"    Click Element JS    ${button_th}
    ...    ELSE    Input payment into any form    ${button_thanhtoan}    ${result_khtt}    ${button_th}
    Return message success validation
    ${return_code}    Wait Until Keyword Succeeds    3 times    5 s    Get saved code after execute
    Execute Javascript    location.reload();
    Sleep    20 s    wait for response to API
    #assert value product trả hàng
    ${get_list_hh_in_th_af_execute}    Get list product frm Return API    ${return_code}
    ${get_additional_invoice_code}    Get additional invoice code by return code    ${return_code}
    ${get_list_hh_in_th_af_execute}    Reverse List one    ${get_list_hh_in_th_af_execute}
    #assert value in invoice
    ${get_ma_kh_by_hd_af_ex}    ${get_tong_tien_hang_af_ex}    ${get_khach_tt_af_ex}    ${get_trangthai_af_ex}    Get invoice info by invoice code    ${get_ma_hd}
    Should Be Equal As Numbers    ${get_tong_tien_hang_af_ex}    ${get_tong_tien_hang_bf_ex}
    Should Be Equal As Numbers    ${get_khach_tt_af_ex}    ${get_khach_tt_bf_ex}
    Should Be Equal As Strings    ${get_ma_kh_by_hd_af_ex}    ${get_ma_kh_by_hd_bf_ex}
    Should Be Equal As Strings    ${get_trangthai_af_ex}    ${get_trangthai_bf_ex}
    #assert value in return
    ${get_tongtienhangtra_af_ex}    ${get_phitrahang_af_ex}    ${get_cantrakhach_af_ex}    ${get_datrakhach_af_ex}    ${get_tongtien_hoadontra_af_ex}    Get return info by return code    ${return_code}
    Should Be Equal As Numbers    ${get_tongtienhangtra_af_ex}    ${result_tongtientra}
    Should Be Equal As Numbers    ${get_phitrahang_af_ex}    ${result_phi_th}
    Run Keyword If    ${result_cantrakhach}>0    Should Be Equal As Numbers    ${get_cantrakhach_af_ex}    ${result_cantrakhach}    ELSE   Should Be Equal As Numbers    ${get_cantrakhach_af_ex}    0
    Should Be Equal As Numbers    ${get_datrakhach_af_ex}    ${actuall_trahang}
    Should Be Equal As Numbers    ${get_tongtien_hoadontra_af_ex}    ${result_tongtientra_tru_phith}
    Validate return history by invoice code    ${get_ma_hd}    ${return_code}    ${result_tongtientra}
    #assert value in đổi hàng
    ${get_ma_kh_by_hd_af_ex}    ${get_tong_tien_hang_af_ex}    ${get_khach_tt_af_ex}    ${get_giamgia_hd_af_ex}    ${get_khach_can_tra_af_ex}    ${get_trangthai_af_ex}    Get additional invoice info incase discount by additional invoice code
    ...    ${get_additional_invoice_code}
    Should Be Equal As Strings    ${get_ma_kh_by_hd_af_ex}    ${input_ma_kh}
    Should Be Equal As Strings    ${get_trangthai_af_ex}    Hoàn thành
    Remove From List    ${list_newprice}    -1
    Delete return thr API    ${return_code}
