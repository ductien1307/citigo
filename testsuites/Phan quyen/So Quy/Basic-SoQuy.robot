*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    ${headless_browser}
Test Teardown     After Test
Resource         ../../../core/Thiet_lap/thiet_lap_nav.robot
Resource         ../../../core/Thiet_lap/khuyenmai_list_page.robot
Resource         ../../../core/Thiet_lap/khuyenmai_list_action.robot
Resource         ../../../core/API/api_thietlap.robot
Resource         ../../../core/API/api_danhmuc_hanghoa.robot
Resource         ../../../core/share/javascript.robot
Resource         ../../../core/share/toast_message.robot
Resource         ../../../core/share/computation.robot
Resource         ../../../prepare/Hang_hoa/Sources/thietlap.robot
Library           SeleniumLibrary
Resource         ../../../core/API/api_soquy.robot
Resource         ../../../core/So_Quy/so_quy_navigation.robot
Resource         ../../../core/So_Quy/so_quy_add_action.robot
Resource         ../../../core/So_Quy/so_quy_add_page.robot
Resource         ../../../core/So_Quy/so_quy_list_action.robot
Resource         ../../../core/So_Quy/so_quy_list_page.robot


*** Test Cases ***
Xem DS
    [Documentation]     người dùng chỉ có quyền  Xem DS
    [Tags]    PQ6
    [Template]    soquy1
    [Timeout]    2mins
    soquy    123

Them moi phieu thu tien mat
    [Documentation]     Thêm mới phiếu thu tiền mặt
    [Timeout]    3mins
    [Tags]    PQ6
    [Template]    soquy2
    soquy    123    Nhân viên    Nguyễn Thị An    Khác    30000    phieu thu tien mat

Them moi phieu chi ngan hang
    [Documentation]     thêm mới phiếu chi ngân hàng
    [Timeout]    3mins
    [Tags]    PQ6
    [Template]    soquy3
    soquy    123    Nhân viên    Nguyễn Thị An    Khác    22222     Chuyển khoản    1234   phieu chi ngan hang

Update gia tri phieu
    [Documentation]     update giá trị phiếu
    [Timeout]    2mins
    [Tags]    PQ6
    [Template]    soquy4
    soquy    123    an.nt    Thu 2    11111    updatevalue    true    22222

Xoa phieu
    [Documentation]     xóa phiếu
    [Timeout]    2mins
    [Tags]    PQ6
    [Template]    soquy5
    soquy    123    an.nt    Thu 2    11111    delete    true

xuat file
    [Documentation]     xuất file
    [Timeout]    2mins
    [Tags]    PQ6
    [Template]    soquy6
    soquy    123    an.nt    Thu 2    11111    xuatfile    false

*** Keywords ***
soquy1
    [Documentation]     người dùng chỉ có quyền: xem DS
    [Arguments]    ${taikhoan}    ${matkhau}
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role    ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"CashFlow_Read":true,"Clocking_Copy":false}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    #
    Set Selenium Speed    0.2
    Before Test Quan ly
    Click Element    ${menu_soquy}
    Wait Until Page Contains Element    ${button_tab_ngan_hang}
    Element Should Not Be Visible    ${menu_giaodich}
    Element Should Not Be Visible    ${menu_doitac}
    Element Should Not Be Visible    ${domain_baocao}
    Element Should Not Be Visible    ${button_banhang_on_quanly}
    Element Should Not Be Visible    ${button_lap_phieu_thu}
    Element Should Not Be Visible    ${button_lap_phieu_chi}
    Delete user    ${get_user_id}

soquy2
    [Documentation]     người dùng có quyền: xem DS, thêm mới: thêm phiếu thu tiền mặt
    [Arguments]    ${taikhoan}    ${matkhau}    ${input_payer_group}    ${input_payer}    ${input_receipt_cat}
    ...    ${input_value}    ${input_note}
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role    ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"CashFlow_Read":true,"CashFlow_Create":true,"Clocking_Copy":false}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    #
    ${input_receipt_code}    Generate code automatically    PTTM
    Set Selenium Speed    0.2
    Before Test Quan ly
    Click Element    ${menu_soquy}
    Wait Until Element Is Visible    ${button_lap_phieu_thu}
    Click Element    ${button_lap_phieu_thu}
    Input data in form Lap phieu thu chi (Tien mat)    ${input_receipt_code}    ${input_payer_group}    ${input_payer}    ${input_receipt_cat}
    ...    ${input_value}    ${input_note}
    Click Element    ${button_sq_luu}
    ${get_phuongthuc}    ${get_trang_thai}    ${get_loai_thu_chi}    ${get_ten}    ${get_gia_tri}    Get paymen infor frm API    ${input_receipt_code}
    Should Be Equal As Strings    ${get_phuongthuc}    Cash
    Should Be Equal As Strings    ${get_trang_thai}    Đã thanh toán
    Should Be Equal As Strings    ${get_ten}    ${input_payer}
    Should Be Equal As Numbers    ${get_gia_tri}    ${input_value}
    Delete user    ${get_user_id}

soquy3
    [Documentation]     người dùng có quyền: xem DS, thêm mới: thêm phiếu chi ngân hàng
    [Arguments]    ${taikhoan}    ${matkhau}    ${input_receiver_group}    ${input_receiver_name}    ${input_payment_cat}
    ...    ${input_value}    ${input_payment_method}    ${input_account}    ${input_note}
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role    ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"CashFlow_Read":true,"CashFlow_Create":true,"Clocking_Copy":false}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    #
    ${input_payment_code}    Generate code automatically    PCNH
    Set Selenium Speed    0.2
    Before Test Quan ly
    Click Element    ${menu_soquy}
    Wait Until Element Is Visible    ${button_tab_ngan_hang}
    Click Element    ${button_tab_ngan_hang}
    Wait Until Element Is Visible    ${button_lap_phieu_chi}
    Click Element    ${button_lap_phieu_chi}
    #
    Input data in form Lap phieu thu chi (Ngan hang)    ${input_payment_code}    ${input_receiver_group}    ${input_receiver_name}    ${input_payment_cat}
    ...    ${input_value}    ${input_payment_method}    ${input_account}    ${input_note}
    Click Element    ${button_sq_luu}
    Sleep    10s
    ${phuongthuc}    Set Variable If    '${input_payment_method}'=='Thẻ'    Card    Transfer
    ${value}=    Minus    0    ${input_value}
    ${get_phuongthuc}    ${get_trang_thai}    ${get_loai_thu_chi}    ${get_ten}    ${get_gia_tri}    Get paymen infor frm API    ${input_payment_code}
    Should Be Equal As Strings    ${get_phuongthuc}    ${phuongthuc}
    Should Be Equal As Strings    ${get_trang_thai}    Đã thanh toán
    Should Be Equal As Strings    ${get_ten}    ${input_receiver_name}
    Should Be Equal As Numbers    ${get_gia_tri}    ${value}
    Delete user    ${get_user_id}

soquy4
    [Documentation]     update trường giá trị, người dùng có quyền sổ quỹ: xem, cập nhật
    [Arguments]    ${taikhoan}    ${matkhau}    ${input_payer}    ${input_payment_cat}    ${input_value}    ${input_note}    ${hach_toan}    ${input_value_new}
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role    ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"CashFlow_Read":true,"CashFlow_Create":false,"Clocking_Copy":false,"CashFlow_Update":true}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    #
    Set Selenium Speed    0.2
    ${get_id_loai_thu_chi}    Get payment category id    ${input_payment_cat}
    Run Keyword If    ${get_id_loai_thu_chi}==0        Add new payment/receipt type     ${input_payment_cat}    ELSE    Log     Ignore
    ${ma_phieu}    Add cash flow in tab Tien mat for employee    ${input_payer}    ${input_payment_cat}    ${input_value}    ${input_note}    ${hach_toan}
    Before Test Quan ly
    Click Element    ${menu_soquy}
    Go to So quy and update transaction form    ${ma_phieu}
    Update value field    ${input_value_new}
    ${get_phuongthuc}    ${get_trang_thai}    ${get_loai_thu_chi}    ${get_ten}    ${get_gia_tri}    Get paymen infor frm API    ${ma_phieu}
    Should Be Equal As Strings    ${get_phuongthuc}    Cash
    Should Be Equal As Strings    ${get_trang_thai}    Đã thanh toán
    Should Be Equal As Numbers    ${get_gia_tri}    ${input_value_new}
    Delete user    ${get_user_id}

soquy5
    [Documentation]     update trường giá trị, người dùng có quyền sổ quỹ: xem, cập nhật
    [Arguments]    ${taikhoan}    ${matkhau}    ${input_payer}    ${input_payment_cat}    ${input_value}    ${input_note}    ${hach_toan}
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role    ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"CashFlow_Read":true,"CashFlow_Update":false,"Clocking_Copy":false,"CashFlow_Delete":true}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    #
    Set Selenium Speed    0.2
    ${get_id_loai_thu_chi}    Get payment category id    ${input_payment_cat}
    Run Keyword If    ${get_id_loai_thu_chi}==0        Add new payment/receipt type     ${input_payment_cat}    ELSE    Log     Ignore
    ${ma_phieu}    Add cash flow in tab Tien mat for employee    ${input_payer}    ${input_payment_cat}    ${input_value}    ${input_note}    ${hach_toan}
    Before Test Quan ly
    Go to So quy and update transaction form    ${ma_phieu}
    Cancel transaction
    Message delete transaction success validation
    Delete user    ${get_user_id}

soquy6
    [Documentation]     update trường giá trị, người dùng có quyền sổ quỹ: xem, cập nhật
    [Arguments]    ${taikhoan}    ${matkhau}    ${input_payer}    ${input_payment_cat}    ${input_value}    ${input_note}    ${hach_toan}
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role    ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"Campaign_Read":false,"Campaign_Update":false,"Campaign_Delete":false,"Invoice_Read":false,"Invoice_Create":false,"Invoice_Update":false,"Invoice_Delete":false,"Product_Read":false,"Product_Create":false,"Product_Update":false,"Product_Delete":false,"Product_PurchasePrice":false,"Product_Cost":false,"Product_Import":false,"Product_Export":false,"Invoice_Export":false,"Invoice_ReadOnHand":false,"Invoice_ChangePrice":false,"Invoice_ChangeDiscount":false,"Invoice_ModifySeller":false,"Invoice_UpdateCompleted":false,"Invoice_RepeatPrint":false,"Invoice_CopyInvoice":false,"Invoice_UpdateWarranty":false,"Invoice_Import":false,"Clocking_Copy":false,"CashFlow_Read":true,"CashFlow_Create":false,"CashFlow_Update":false,"CashFlow_Delete":false,"CashFlow_Export":true,"Campaign_Create":false}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    #
    Set Selenium Speed    0.2
    ${get_id_loai_thu_chi}    Get payment category id    ${input_payment_cat}
    Run Keyword If    ${get_id_loai_thu_chi}==0        Add new payment/receipt type     ${input_payment_cat}    ELSE    Log     Ignore
    ${ma_phieu}    Add cash flow in tab Tien mat for employee    ${input_payer}    ${input_payment_cat}    ${input_value}    ${input_note}    ${hach_toan}
    Before Test Quan ly
    Click Element    ${menu_soquy}
    Input data        ${textbox_search_ma_phieu}      ${ma_phieu}
    Sleep    2s
    Element Should Not Be Visible    ${button_mophieu}
    Wait Until Page Contains Element    ${button_xuatfile}
    Click Element    ${button_xuatfile}
    Wait Until Keyword Succeeds    3 times    3s    Element Should Contain    //a[@class='noti_link ng-binding']    Nhấn vào đây để tải xuống
    Delete payment frm API    ${ma_phieu}
    Delete user    ${get_user_id}
