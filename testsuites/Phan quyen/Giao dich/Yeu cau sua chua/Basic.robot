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
Resource          ../../../../core/Nhan_vien/nhanvien_navigation.robot
Resource          ../../../../core/Thiet_lap/thiet_lap_nav.robot
Resource          ../../../../core/Giao_dich/yeu_cau_sua_chua_list_action.robot
Resource          ../../../../core/API/api_yeucau_suachua.robot
Resource          ../../../../core/API/api_danhmuc_hanghoa.robot
Resource          ../../../../core/Ban_Hang/banhang_manager_navigation.robot
Resource          ../../../../core/API/api_access.robot
Resource          ../../../../core/Dat_Hang/dat_hang_page.robot
Resource          ../../../../core/share/javascript.robot
Resource          ../../../../core/API/api_hoadon_banhang.robot

*** Variables ***
&{dict_pr}      TPG14=2
&{dict_pr_thaythe}      TPG15=3

*** Test Cases ***
Xem DS + Thêm mới
    [Documentation]     người dùng chỉ có quyền Yêu cầu sửa chữa Xem DS, Hàng hóa: Xem DS
    [Tags]      PQ2
    [Template]    pqycsc1
    userycsc1    123      TPG14

Xem DS + Cập nhật
    [Documentation]     người dùng chỉ có quyền Yêu cầu sửa chữa Xem DS + Thêm mới + Cập nhật
    [Tags]      PQ2
    [Template]    pqycsc2
    userycsc2    123         TPG14

Xem DS + Xóa
    [Documentation]     người dùng chỉ có quyền Yêu cầu sửa chữa Xem DS + Xóa, Hàng hóa: Xem DS
    [Tags]      PQ2
    [Template]    pqycsc3
    userycsc3    123         TPG14

Xem DS + In
    [Documentation]     người dùng chỉ có quyền Yêu cầu sửa chữa Xem DS + In, Hàng hóa: Xem DS (đang có bug trên live)
    [Tags]      #PQ2
    [Template]    pqycsc4
    userycsc4    123         TPG14

Xem DS + Xuất file
    [Documentation]     người dùng chỉ có quyền Yêu cầu sửa chữa Xem DS + Xuất file, Hàng hóa: Xem DS   (đang có bug trên live)
    [Tags]      #PQ2
    [Template]    pqycsc5
    userycsc5    123         TPG14

Xem DS + Vập nhật + Tạo hóa đơn
    [Documentation]     người dùng chỉ có quyền Yêu cầu sửa chữa Xem DS + Xuất file, Hàng hóa: Xem DS
    [Tags]      PQ2
    [Template]    pqycsc6
    userycsc6    123         ${dict_pr}     ${dict_pr_thaythe}      CTKH003      5000

Xem DS + Vập nhật hạn bảo hành
    [Documentation]     người dùng chỉ có quyền Yêu cầu sửa chữa Xem DS + Vập nhật hạn bảo hành
    [Tags]       PQ2
    [Template]    pqycsc7
    userycsc7    123        TPG14

Xem DS + Xem giá bán
    [Documentation]     người dùng chỉ có quyền Yêu cầu sửa chữa Xem DS + Xem giá bán
    [Tags]        PQ2
    [Template]    pqycsc8
    userycsc8    123        TPG14

*** Keywords ***
pqycsc1
    [Documentation]     người dùng chỉ có quyền Yêu cầu sửa chữa Xem DS + Thêm mới
    [Arguments]    ${taikhoan}    ${matkhau}      ${input_ma_sp}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"Product_Read":true,"WarrantyOrder_Read":true,"WarrantyRepairingProduct_Read":false,"WarrantyRepairingProduct_Update":false,"Clocking_Copy":false,"WarrantyOrder_Create":true}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    #
    Before Test Ban Hang
    Wait Until Page Contains Element    ${textbox_bh_search_ma_sp}    2 mins
    Wait Until Keyword Succeeds    3 times    3 s    Input data in textbox and wait until it is visible    ${textbox_bh_search_ma_sp}    ${input_ma_sp}    ${cell_sanpham}
    ...    ${cell_sc_ma_sp}
    Click Element JS    ${button_bh_thanhtoan}
    Wait Until Keyword Succeeds    3 times    2s    Click Element JS    ${button_dongy_popup_nocustomer}
    Wait Until Page Contains Element    ${toast_message}    30s
    Element Should Contain    ${toast_message}      Phiếu yêu cầu được cập nhật thành công
    ${get_ma_phieu}    Get saved code after execute
    Delete warranty order thr API    ${get_ma_phieu}
    Delete user    ${get_user_id}

pqycsc2
    [Documentation]     người dùng chỉ có quyền Yêu cầu sửa chữa Xem DS + Cập nhật, Hàng hóa: Xem DS
    [Arguments]    ${taikhoan}    ${matkhau}      ${input_ma_sp}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"Product_Read":true,"WarrantyOrder_Read":true,"WarrantyRepairingProduct_Read":false,"WarrantyRepairingProduct_Update":false,"Clocking_Copy":false,"WarrantyOrder_Create":false,"WarrantyOrder_Update":true}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    #
    ${get_ma_phieu}     Add new warranty order frm API    ${input_ma_sp}
    Before Test Yeu Cau Sua Chua
    Input data         ${textbox_search_ma_yeu_cau}       ${get_ma_phieu}
    Wait Until Page Contains Element    ${button_sc_luu}    1 min
    Element Should Be Visible    ${button_sc_xu_ly_yeu_cau}
    Element Should Be Visible    ${button_sc_ket_thuc_yeu_cau}
    Element Should Not Be Visible    ${button_sc_huy_bo}
    Element Should Not Be Visible    ${button_sc_in}
    Element Should Not Be Visible    ${button_sc_xuatfile}
    Click Element    ${button_sc_luu}
    Wait Until Page Contains Element    ${toast_message}    30s
    Element Should Contain    ${toast_message}     Cập nhật yêu cầu sửa chữa thành công
    Delete warranty order thr API    ${get_ma_phieu}
    Delete user    ${get_user_id}

pqycsc3
    [Documentation]     người dùng chỉ có quyền Yêu cầu sửa chữa Xem DS + Xóa, Hàng hóa: Xem DS
    [Arguments]    ${taikhoan}    ${matkhau}      ${input_ma_sp}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"Product_Read":true,"WarrantyOrder_Read":true,"WarrantyRepairingProduct_Read":false,"WarrantyRepairingProduct_Update":false,"Clocking_Copy":false,"WarrantyOrder_Create":false,"WarrantyOrder_Update":false,"WarrantyOrder_Delete":true}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    #
    ${get_ma_phieu}     Add new warranty order frm API    ${input_ma_sp}
    Before Test Yeu Cau Sua Chua
    Input data         ${textbox_search_ma_yeu_cau}       ${get_ma_phieu}
    Wait Until Page Contains Element    ${button_sc_huy_bo}    1 min
    Element Should Not Be Visible      ${button_sc_luu}
    Element Should Not Be Visible    ${button_sc_xu_ly_yeu_cau}
    Element Should Not Be Visible    ${button_sc_ket_thuc_yeu_cau}
    Element Should Not Be Visible    ${button_sc_in}
    Element Should Not Be Visible    ${button_sc_xuatfile}
    Click Element    ${button_sc_huy_bo}
    Wait Until Page Contains Element    ${button_sc_dongy_kethuc_huybo}    30s
    Click Element    ${button_sc_dongy_kethuc_huybo}
    Wait Until Page Contains Element    ${toast_message}    30s
    Element Should Contain    ${toast_message}     Hủy phiếu yêu cầu ${get_ma_phieu} thành công.
    Delete user    ${get_user_id}

pqycsc4
    [Documentation]     người dùng chỉ có quyền Yêu cầu sửa chữa Xem DS + In, Hàng hóa: Xem DS
    [Arguments]    ${taikhoan}    ${matkhau}      ${input_ma_sp}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"Product_Read":true,"WarrantyOrder_Read":true,"WarrantyOrder_Delete":false,"Clocking_Copy":false,"WarrantyOrder_Print":true,"WarrantyOrder_Create":false,"WarrantyOrder_Update":false,"WarrantyOrder_Export":false,"WarrantyOrder_CreateInvoice":false,"WarrantyOrder_UpdateExpire":false,"WarrantyOrder_ViewPrice":false,"WarrantyRepairingProduct_Read":false,"WarrantyRepairingProduct_Update":false,"Product_Create":false,"Product_Update":false,"Product_Delete":false,"Product_PurchasePrice":false,"Product_Cost":false,"Product_Import":false,"Product_Export":false}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    #
    ${get_ma_phieu}     Add new warranty order frm API    ${input_ma_sp}
    Before Test Yeu Cau Sua Chua
    Input data         ${textbox_search_ma_yeu_cau}       ${get_ma_phieu}
    Wait Until Page Contains Element    ${button_sc_in}    1 min
    Element Should Not Be Visible      ${button_sc_luu}
    Element Should Not Be Visible    ${button_sc_xu_ly_yeu_cau}
    Element Should Not Be Visible    ${button_sc_ket_thuc_yeu_cau}
    Element Should Not Be Visible    ${button_sc_huy_bo}
    Element Should Not Be Visible    ${button_sc_xuatfile}
    Click Element    ${button_sc_in}
    Element Should Not Be Visible    ${toast_message_error}
    Delete warranty order thr API    ${get_ma_phieu}
    Delete user    ${get_user_id}

pqycsc5
    [Documentation]     người dùng chỉ có quyền Yêu cầu sửa chữa Xem DS + Xuất file, Hàng hóa: Xem DS
    [Arguments]    ${taikhoan}    ${matkhau}      ${input_ma_sp}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"Product_Read":true,"WarrantyOrder_Read":true,"WarrantyOrder_Delete":false,"Clocking_Copy":false,"WarrantyOrder_Print":false,"WarrantyOrder_Create":false,"WarrantyOrder_Update":false,"WarrantyOrder_Export":true,"WarrantyOrder_CreateInvoice":false,"WarrantyOrder_UpdateExpire":false,"WarrantyOrder_ViewPrice":false,"WarrantyRepairingProduct_Read":false,"WarrantyRepairingProduct_Update":false,"Product_Create":false,"Product_Update":false,"Product_Delete":false,"Product_PurchasePrice":false,"Product_Cost":false,"Product_Import":false,"Product_Export":true,"WarrantyProduct_Read":false,"WarrantyProduct_Update":false,"WarrantyProduct_Export":false}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    #
    ${get_ma_phieu}     Add new warranty order frm API    ${input_ma_sp}
    Before Test Yeu Cau Sua Chua
    Input data         ${textbox_search_ma_yeu_cau}       ${get_ma_phieu}
    Wait Until Page Contains Element    ${button_sc_xuatfile}    1 min
    Element Should Not Be Visible      ${button_sc_luu}
    Element Should Not Be Visible    ${button_sc_xu_ly_yeu_cau}
    Element Should Not Be Visible    ${button_sc_ket_thuc_yeu_cau}
    Element Should Not Be Visible    ${button_sc_huy_bo}
    Element Should Not Be Visible    ${button_sc_in}
    Wait Until Page Contains Element    ${button_export_invoice}    1 mins
    Click Element JS    ${button_export_invoice}
    Sleep    1s
    Wait Until Page Contains Element    //div[contains(@class,'addProductBtn')]//ul//a[text()=' Danh sách tổng quan']    1 mins
    Click Element JS    //div[contains(@class,'addProductBtn')]//ul//a[text()=' Danh sách tổng quan']
    Wait Until Keyword Succeeds    4 times    5s    Element Should Contain    ${noti_export}    Nhấn vào đây để tải xuống
    Delete warranty order thr API    ${get_ma_phieu}
    Delete user    ${get_user_id}

pqycsc6
    [Documentation]     người dùng chỉ có quyền Yêu cầu sửa chữa Xem DS + Cập nhật + Thêm mới, Hàng hóa: Xem DS, Hóa đơn: Xem DS+ Thêm mới
    [Arguments]    ${taikhoan}    ${matkhau}      ${dict_sp}     ${dict_sp_thaythe}      ${input_ma_kh}      ${input_khtt}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"Invoice_Read":true,"Invoice_Create":true,"Product_Read":true,"WarrantyOrder_Read":true,"WarrantyOrder_Update":true,"Product_Export":true,"WarrantyOrder_CreateInvoice":true,"Clocking_Copy":false,"Invoice_Update":false}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    #
    ${get_ma_phieu}     Add new warranty order have alternative product frm API    ${dict_sp}     ${dict_sp_thaythe}      ${input_ma_kh}      ${input_khtt}
    Before Test Yeu Cau Sua Chua
    Input data         ${textbox_search_ma_yeu_cau}       ${get_ma_phieu}
    Wait Until Page Contains Element    ${button_sc_xu_ly_yeu_cau}    1 min
    Element Should Be Visible      ${button_sc_luu}
    Element Should Be Visible    ${button_sc_ket_thuc_yeu_cau}
    Element Should Not Be Visible    ${button_sc_huy_bo}
    Element Should Not Be Visible    ${button_sc_in}
    Click Element    ${button_sc_xu_ly_yeu_cau}
    Wait Until Keyword Succeeds    3 times    3s    Select Window   url=${URL}/sale/#/
    Wait Until Keyword Succeeds    3 times    3s    Deactivate print preview page
    Wait Until Page Contains Element   ${button_taohoadon}
    Click Element JS    ${button_taohoadon}
    Wait Until Page Contains Element    //*[@id='saveWarrantyInvoice']    1 min
    Click Element JS    //*[@id='saveWarrantyInvoice']
    Invoice message success validation
    Wait Until Keyword Succeeds    3 times    2s    Click Element JS    //button[@class='btn btn-danger btn-confirm']
    Delete warranty order thr API       ${get_ma_phieu}
    Delete user    ${get_user_id}

pqycsc7
    [Documentation]     người dùng chỉ có quyền Yêu cầu sửa chữa Xem DS + Cập nhật hạn bảo hành
    [Arguments]    ${taikhoan}    ${matkhau}      ${input_ma_sp}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"Invoice_Read":false,"Invoice_Create":false,"Product_Read":true,"WarrantyOrder_Read":true,"WarrantyOrder_Update":false,"Product_Export":false,"WarrantyOrder_CreateInvoice":false,"Clocking_Copy":false,"Invoice_Update":false,"Invoice_Delete":false,"Invoice_Export":false,"Invoice_ReadOnHand":false,"Invoice_ChangePrice":false,"Invoice_ChangeDiscount":false,"Invoice_ModifySeller":false,"Invoice_UpdateCompleted":false,"Invoice_RepeatPrint":false,"Invoice_CopyInvoice":false,"Invoice_UpdateWarranty":false,"Invoice_Import":false,"WarrantyOrder_UpdateExpire":true,"WarrantyProduct_Read":false,"PriceBook_Read":false,"PriceBook_Create":false,"PriceBook_Update":false,"PriceBook_Delete":false,"PriceBook_Import":false,"PriceBook_Export":false,"WarrantyOrder_ViewPrice":false,"Product_Create":false,"Product_Update":false,"Product_Delete":false,"Product_PurchasePrice":false,"Product_Cost":false,"Product_Import":false,"WarrantyProduct_Update":false,"WarrantyProduct_Export":false,"WarrantyOrder_Create":false}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    #
    ${get_ma_phieu}     Add new warranty order frm API    ${input_ma_sp}
    Before Test Yeu Cau Sua Chua
    Input data         ${textbox_search_ma_yeu_cau}       ${get_ma_phieu}
    Element Should Not Be Visible    ${button_sc_luu}
    Element Should Not Be Visible    ${button_sc_ket_thuc_yeu_cau}
    Element Should Not Be Visible    ${button_sc_huy_bo}
    Element Should Not Be Visible    ${button_sc_in}
    Element Should Not Be Visible    ${button_sc_xu_ly_yeu_cau}
    Delete warranty order thr API       ${get_ma_phieu}
    Delete user    ${get_user_id}

pqycsc8
    [Documentation]     người dùng chỉ có quyền Yêu cầu sửa chữa Xem DS + Xem giá bán
    [Arguments]    ${taikhoan}    ${matkhau}      ${input_ma_sp}
    Set Selenium Speed    0.1
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"Invoice_Read":false,"Invoice_Create":false,"Product_Read":false,"WarrantyOrder_Read":true,"WarrantyOrder_Update":false,"Product_Export":false,"WarrantyOrder_CreateInvoice":false,"Clocking_Copy":false,"Invoice_Update":false,"Invoice_Delete":false,"Invoice_Export":false,"Invoice_ReadOnHand":false,"Invoice_ChangePrice":false,"Invoice_ChangeDiscount":false,"Invoice_ModifySeller":false,"Invoice_UpdateCompleted":false,"Invoice_RepeatPrint":false,"Invoice_CopyInvoice":false,"Invoice_UpdateWarranty":false,"Invoice_Import":false,"WarrantyOrder_UpdateExpire":false,"WarrantyProduct_Read":false,"PriceBook_Read":false,"PriceBook_Create":false,"PriceBook_Update":false,"PriceBook_Delete":false,"PriceBook_Import":false,"PriceBook_Export":false,"WarrantyOrder_ViewPrice":true,"Product_Create":false,"Product_Update":false,"Product_Delete":false,"Product_PurchasePrice":false,"Product_Cost":false,"Product_Import":false,"WarrantyProduct_Update":false,"WarrantyProduct_Export":false,"WarrantyOrder_Create":false}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    #
    ${get_ma_phieu}     Add new warranty order frm API    ${input_ma_sp}
    Before Test Yeu Cau Sua Chua
    Input data         ${textbox_search_ma_yeu_cau}       ${get_ma_phieu}
    Element Should Not Be Visible    ${button_sc_luu}
    Element Should Not Be Visible    ${button_sc_ket_thuc_yeu_cau}
    Element Should Not Be Visible    ${button_sc_huy_bo}
    Element Should Not Be Visible    ${button_sc_in}
    Element Should Not Be Visible    ${button_sc_xu_ly_yeu_cau}
    Delete warranty order thr API       ${get_ma_phieu}
    Delete user    ${get_user_id}
