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
Resource         ../../../core/share/discount.robot
Resource         ../../../prepare/Hang_hoa/Sources/thietlap.robot
Library           SeleniumLibrary
Resource         ../../../core/Thiet_lap/Quan_ly_khuyen_mai/Cap_nhat_khuyen_mai.robot
Resource         ../../../core/Thiet_lap/Quan_ly_khuyen_mai/Them_moi_khuyen_mai.robot


*** Test Cases ***
Xem DS
    [Documentation]     người dùng chỉ có quyền Khuyến mại: Xem DS
    [Timeout]    2mins
    [Tags]    PQ6
    [Template]    pqkm1
    userkm    123    KM020

Xem va them moi KM
    [Documentation]     người dùng có quyền: Xem DS + thêm mới
    [Timeout]    2mins
    [Tags]    PQ6
    [Template]    pqkm2
    userkm    123    CTKM01   khuyenmai1008    True    Hóa đơn    Giảm giá hóa đơn    100000    5000

Xem va cap nhat KM
    [Documentation]     người dùng chỉ có quyền Khuyến mại: Xem DS + cập nhật, và quyền xem Danh mục Sản phẩm
    [Timeout]    2mins
    [Tags]    PQ6
    [Template]    pqkm3
    userkm    123    CTKM02   KM1008    100000    1    Gia dụng    null    7    Giảm giá hàng   Tất cả nhóm hàng   2   50000    False

Xem va Xoa KM
    [Documentation]    người dùng có quyền Khuyến mại: xem DS, cập nhật, Xóa và quyền Danh mục sản phẩm + Hóa đơn
    [Timeout]    2mins
    [Tags]    PQ6
    [Template]    pqkm4
    userkm    123    CTKM03    KM1009    Gia dụng    1    20000    null    25000

*** Keywords ***
pqkm1
    [Documentation]     người dùng chỉ có quyền: xem DS
    [Arguments]    ${taikhoan}    ${matkhau}    ${input_ma_promo}
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role    ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"Campaign_Read":true,"PriceBook_Read":false,"PriceBook_Create":false,"PriceBook_Update":false,"PriceBook_Delete":false,"Product_Read":false,"Product_Create":false,"Product_Update":false,"Product_Delete":false,"PurchaseOrder_Read":false,"PurchaseOrder_Create":false,"PurchaseOrder_Update":false,"PurchaseOrder_Delete":false,"PurchasePayment_Create":false,"PurchasePayment_Update":false,"PurchasePayment_Delete":false,"PurchaseReturn_Read":false,"PurchaseReturn_Create":false,"PurchaseReturn_Update":false,"PurchaseReturn_Delete":false,"StockTake_Read":false,"StockTake_Create":false,"Supplier_Read":false,"Supplier_Create":false,"Supplier_Update":false,"Supplier_Delete":false,"SupplierAdjustment_Read":false,"SupplierAdjustment_Create":false,"Transfer_Read":false,"Transfer_Create":false,"Transfer_Update":false,"Transfer_Delete":false,"Product_Cost":false,"Product_Import":false,"StockTake_Finish":false,"StockTake_Export":false,"StockTake_Inventory":false,"Clocking_Copy":false,"Product_PurchasePrice":false,"Product_Export":false,"PriceBook_Import":false,"PriceBook_Export":false,"StockTake_Delete":false,"StockTake_Clone":false,"PurchaseOrder_UpdatePurchaseOrder":false,"PurchaseOrder_Export":false,"PurchaseOrder_Clone":false,"PurchaseReturn_Clone":false,"Transfer_Export":false,"Transfer_Clone":false,"Transfer_Import":false,"Supplier_MobilePhone":false,"Supplier_Import":false,"Supplier_Export":false,"SupplierAdjustment_Update":false,"SupplierAdjustment_Delete":false}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    #
    Set Selenium Speed    0.2
    Before Test Quan ly
    Go to any thiet lap    ${button_quanly_khuyenmai}
    Wait Until Element Is Visible    ${textbox_search_promo}
    Input data    ${textbox_search_promo}    ${input_ma_promo}
    Wait Until Element Is Visible    ${checkbox_filter_trangthai_tatca}
    Click Element JS    ${checkbox_filter_trangthai_tatca}
    Sleep    2s
    Element Should Not Be Visible    ${menu_giaodich}
    Element Should Not Be Visible    ${menu_doitac}
    Element Should Not Be Visible    ${domain_soquy}
    Element Should Not Be Visible    ${domain_baocao}
    Element Should Not Be Visible    ${button_banhang_on_quanly}
    Element Should Not Be Visible    ${button_themmoi_all_form}
    Element Should Not Be Visible    ${button_capnhat_promo}
    Element Should Not Be Visible    ${button_delete_promo}
    Delete user    ${get_user_id}

pqkm2
    [Documentation]     người dùng có quyền khuyên mại: Xem DS + Thêm mới
    [Arguments]    ${taikhoan}    ${matkhau}    ${input_ma_promo}   ${input_promo_name}   ${input_status}    ${input_KMtheo}  ${input_hinhthuc}    ${input_tongtienhang}    ${input_promo_value}
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0    Create new user by role    ${taikhoan}    ${matkhau}    Nhân viên kho
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"Campaign_Read":true,"PriceBook_Read":false,"PriceBook_Create":false,"PriceBook_Update":false,"PriceBook_Delete":false,"Product_Read":false,"Product_Create":false,"Product_Update":false,"Product_Delete":false,"PurchaseOrder_Read":false,"PurchaseOrder_Create":false,"PurchaseOrder_Update":false,"PurchaseOrder_Delete":false,"PurchasePayment_Create":false,"PurchasePayment_Update":false,"PurchasePayment_Delete":false,"PurchaseReturn_Read":false,"PurchaseReturn_Create":false,"PurchaseReturn_Update":false,"PurchaseReturn_Delete":false,"StockTake_Read":false,"StockTake_Create":false,"Supplier_Read":false,"Supplier_Create":false,"Supplier_Update":false,"Supplier_Delete":false,"SupplierAdjustment_Read":false,"SupplierAdjustment_Create":false,"Transfer_Read":false,"Transfer_Create":false,"Transfer_Update":false,"Transfer_Delete":false,"Product_Cost":false,"Product_Import":false,"StockTake_Finish":false,"StockTake_Export":false,"StockTake_Inventory":false,"Clocking_Copy":false,"Product_PurchasePrice":false,"Product_Export":false,"PriceBook_Import":false,"PriceBook_Export":false,"StockTake_Delete":false,"StockTake_Clone":false,"PurchaseOrder_UpdatePurchaseOrder":false,"PurchaseOrder_Export":false,"PurchaseOrder_Clone":false,"PurchaseReturn_Clone":false,"Transfer_Export":false,"Transfer_Clone":false,"Transfer_Import":false,"Supplier_MobilePhone":false,"Supplier_Import":false,"Supplier_Export":false,"SupplierAdjustment_Update":false,"SupplierAdjustment_Delete":false,"Campaign_Create":true}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    Before Test Quan ly
    #đi đến màn hình KM và kiểm tra các element
    Element Should Not Be Visible    ${menu_giaodich}
    Element Should Not Be Visible    ${menu_doitac}
    Element Should Not Be Visible    ${domain_soquy}
    Element Should Not Be Visible    ${domain_baocao}
    Element Should Not Be Visible    ${button_banhang_on_quanly}
    # thêm mới CTKM
    ${get_id_promo}    Get Id promotion    ${input_ma_promo}
    Run Keyword If    '${get_id_promo}' == '0'    Log    Ignore     ELSE    Delete promo    ${get_id_promo}
    Set Selenium Speed    0.2
    Go to any thiet lap    ${button_quanly_khuyenmai}
    Click Element JS   ${button_themmoi_all_form}
    Input text    ${textbox_promotion_code}   ${input_ma_promo}
    Input text     ${textbox_promotion_name}   ${input_promo_name}
    Run Keyword If    '${input_status}' == 'False'     Click Element JS    ${checkbox_promotion_chuaapdung}    ELSE    Log     Ignore click
    Run Keyword If    '${input_KMtheo}' == 'Hóa đơn'    Log     Ignore input    ELSE      Select combobox any form    ${dropdown_khuyenmaitheo}    ${cell_item_dropdown}    ${input_KMtheo}
    Run Keyword If    '${input_KMtheo}' == 'Giảm giá hóa đơn'    Log     Ignore input    ELSE      Select combobox any form    ${dropdown_hinhthuc}    ${cell_item_dropdown}    ${input_hinhthuc}
    Input text    ${textbox_tongtienhang}   ${input_tongtienhang}
    Run Keyword If   0 < ${input_promo_value} < 100   Select value any form    ${button_giamgia_%}     ${textbox_giatriKM}   ${input_promo_value}    ELSE       Input text     ${textbox_giatriKM}   ${input_promo_value}
    Wait Until Element Is Visible    ${button_promotion_save}
    Click Element JS        ${button_promotion_save}
    #Sleep   10s
    #kiểm tra thêm mới ctkm thành công
    Promo message success validation
    ${get_promo_id}    Get promo info and invoice validate    ${input_ma_promo}   ${input_promo_name}   ${input_status}    ${input_tongtienhang}    ${input_promo_value}
    Delete promo    ${get_promo_id}
    Delete user    ${get_user_id}

pqkm3
    [Documentation]    người dùng chỉ có quyền Khuyến mại: Xem DS + cập nhật, và quyền xem Danh mục Sản phẩm
    [Arguments]    ${taikhoan}    ${matkhau}    ${input_ma_promo}   ${input_promo_name}    ${input_tongtienhang}    ${input_quantity}    ${input_category_name}
    ...    ${discount_product}    ${discount_product_ratio}    ${discount_type}   ${input_cat_name_new}   ${input_quantity_new}   ${input_discount_product_new}
    ...    ${input_status_new}
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"Campaign_Read":true,"Campaign_Update":true,"Product_Read":true,"Product_Create":true,"Product_Update":true,"Product_Delete":true,"Product_PurchasePrice":true,"Product_Cost":true,"Product_Import":true,"Product_Export":true,"Clocking_Copy":false}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    #
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    #cập nhật CTKM
    ${get_id_promo}    Get Id promotion    ${input_ma_promo}
    Run Keyword If    '${get_id_promo}' == '0'    Log    Ignore     ELSE          Delete promo    ${get_id_promo}
    Create promotion by invoice with product discount    ${input_ma_promo}    ${input_promo_name}    ${input_tongtienhang}    ${input_quantity}
    ...    ${input_category_name}    ${discount_product}    ${discount_product_ratio}    ${discount_type}
    Set Selenium Speed    0.2
    Before Test Quan ly
    Go to any thiet lap    ${button_quanly_khuyenmai}
    Go to update promotion form    ${input_ma_promo}
    Run Keyword If   0 < ${input_discount_product_new} < 100   Input data    ${textbox_giatriKM}   ${input_discount_product_new}
    ...    ELSE   Select value any form    ${button_giamgia_vnd}     ${textbox_giatriKM}   ${input_discount_product_new}
    Input data    ${textbox_hang_giamgia}   ${input_quantity_new}
    Wait Until Page Contains Element    ${icon_clear_category}    2mins
    Click Element    ${icon_clear_category}
    Select category from Chon nhom hang popup    ${button_menu_hangtang}    ${input_cat_name_new}
    Wait Until Element Is Visible    ${button_promotion_save}
    Click Element JS        ${button_promotion_save}
    #kiểm tra message
    Promo message success validation
    ${cat_id}    Get category ID    ${input_cat_name_new}
    ${get_id_promo}    Get Id promotion    ${input_ma_promo}
    ${endpoint_promo_detail}    Format String    ${endpoint_cam_detail}    ${get_id_promo}
    ${response_promo_info}    Get response from API by other url    ${PROMO_API}    ${endpoint_promo_detail}
    ${get_promo_name}    Get data from response json    ${response_promo_info}    $.Name
    ${get_promo_trangthai}    Get data from response json and return false value    ${response_promo_info}    $.IsActive
    ${get_promo_type}    Get data from response json    ${response_promo_info}    $.PromotionType
    ${get_promo_invoicevalue}    Get data from response json    ${response_promo_info}    $.SalePromotions..InvoiceValue
    ${get_promo_value}    Get data from response json    ${response_promo_info}    $.SalePromotions..ProductDiscount
    ${get_category_id}    Get data from response json    ${response_promo_info}    $.SalePromotions..ReceivedCategoryId
    Should Be Equal As Strings    ${get_promo_name}    ${input_promo_name}
    Should Be Equal As Numbers    ${get_promo_value}    ${input_discount_product_new}
    Should Be Equal As Strings    ${get_promo_trangthai}    ${input_status_new}
    Should Be Equal As Numbers    ${get_promo_invoicevalue}    ${input_tongtienhang}
    Should Be Equal As Numbers    ${get_category_id}    ${cat_id}
    Should Be Equal As Numbers    ${get_promo_type}    3
    Delete promo    ${get_id_promo}

pqkm4
    [Documentation]    người dùng có quyền Khuyến mại: xem DS, cập nhật, Xóa và quyền Danh mục sản phẩm + Hóa đơn
    [Arguments]    ${taikhoan}    ${matkhau}    ${input_ma_promo}    ${input_promo_name}    ${input_category_name}    ${input_quantity}
    ...    ${input_price}    ${discount_product}    ${discount_product_ratio}
    #kiểm tra và phân quyền cho account
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    Run Keyword If    ${get_user_id}==0        Create new user by role        ${taikhoan}    ${matkhau}      Nhân viên kho
    ${get_user_id}    Get User ID by UserName     ${taikhoan}
    ${get_role_id}    Get role id by role name    Nhân viên kho
    ${endpoint_update_quyen}    Format String    /users/{0}/privileges    ${get_user_id}
    ${payload}    Format String    {{"UserId":{0},"BranchId":{1},"RoleId":{2},"Data":{{"Campaign_Read":true,"Campaign_Update":true,"Campaign_Delete":true,"Product_Read":true,"Product_Create":true,"Product_Update":true,"Product_Delete":true,"Product_PurchasePrice":true,"Product_Cost":true,"Product_Import":true,"Product_Export":true,"Clocking_Copy":false,"Invoice_Read":true,"Invoice_Create":true,"Invoice_Update":true,"Invoice_Delete":true,"Invoice_Export":true,"Invoice_ReadOnHand":true,"Invoice_ChangePrice":true,"Invoice_ChangeDiscount":true,"Invoice_ModifySeller":true,"Invoice_UpdateCompleted":true,"Invoice_RepeatPrint":true,"Invoice_CopyInvoice":true,"Invoice_UpdateWarranty":true,"Invoice_Import":true}},"TimeAccess":[],"BranchName":"Chi nhánh trung tâm","userId":{0},"CompareGivenName":"{3}","CompareUserName":"{3}"}}    ${get_user_id}    ${BRANCH_ID}    ${get_role_id}        ${taikhoan}
    Log    ${payload}
    Post request thr API    ${endpoint_update_quyen}   ${payload}
    Set Global Variable    \${USER_NAME}    ${taikhoan}
    Set Global Variable    \${PASSWORD}    ${matkhau}
    Set Selenium Speed    0.2
    Before Test Quan ly
    Set Selenium Speed    2s
    ${get_id_promo}    Get Id promotion    ${input_ma_promo}
    Run Keyword If    '${get_id_promo}' == '0'    Log    Ignore     ELSE          Delete promo    ${get_id_promo}
    Create promotion by product with baseprice based on quantity    ${input_ma_promo}   ${input_promo_name}    ${input_category_name}    ${input_quantity}
    ...    ${input_price}    ${discount_product}    ${discount_product_ratio}
    Go to any thiet lap    ${button_quanly_khuyenmai}
    Wait Until Element Is Visible    ${textbox_search_promo}
    Input data    ${textbox_search_promo}    ${input_ma_promo}
    Wait Until Element Is Visible    ${checkbox_filter_trangthai_tatca}
    Click Element JS    ${checkbox_filter_trangthai_tatca}
    Sleep    2s
    Wait Until Element Is Visible    ${button_delete_promo}
    Click Element JS    ${button_delete_promo}
    Sleep    2s
    Wait Until Element Is Visible    ${button_dongy_del_promo}
    Click Element JS    ${button_dongy_del_promo}
    Sleep   1s
    Delete promotion message succest validation    ${input_ma_promo}
