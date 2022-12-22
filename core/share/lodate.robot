*** Settings ***
Library           SeleniumLibrary
Library           Collections
Library           StringFormat
Resource          discount.robot
Resource          constants.robot
Resource          javascript.robot
Resource          computation.robot
Resource          ../API/api_phieu_nhap_hang.robot
Resource          ../API/api_access.robot
Resource          ../Ban_Hang/banhang_page.robot
Resource          ../API/api_danhmuc_hanghoa.robot
Resource          ../Giao_dich/tra_hang_nhap_list_page.robot
Resource          ../../prepare/Hang_hoa/Sources/hanghoa.robot

*** Variables ***
${button_dong_lo}    //span[text()='{0}']//..//button[normalize-space()='×']
${txt_lo}         //span[@ng-bind="$getDisplayText()"]
${button_dong_lo_any_product}     //div[div[div[text()='{0}']]]//..//div//button[normalize-space()='×']

*** Keywords ***
Input products and lot name to any form auto fill lot
    [Arguments]    ${textbox_search_ma_sp}    ${input_ma_sp}    ${item_product_indropdown}    ${textbox_input_lo}    ${item_lo_indropdown}    ${cell_product_target}
    ...    ${cell_item_lo}    ${list_lo}
    Wait Until Keyword Succeeds    3 times    8s    Input data in textbox and wait until it is visible    ${textbox_search_ma_sp}    ${input_ma_sp}    ${item_product_indropdown}
    ...    ${cell_product_target}
    ${index_lo}    Set Variable    -1
    : FOR    ${item}    IN    ${list_lo}
    \    ${index_lo}    Evaluate    ${index_lo}+1
    \    ${item_lo}    Get From List    ${list_lo}    ${index_lo}
    \    Wait Until Keyword Succeeds    3 times    3s    Close button lot and input lot name    ${textbox_input_lo}    ${item_lo}
    \    ...    ${item_lo_indropdown}    ${cell_item_lo}

Close button lot and input lot name
    [Arguments]    ${textbox_location}    ${input_text}    ${xpath_item_dropdown}    ${target_locator}
    Wait Until Page Contains Element    ${textbox_location}    1 min
    ${get_ten_lo}    Get lot name frm UI    ${txt_lo}
    ${btn_dong_lo_sp}    Format String    ${button_dong_lo}    ${get_ten_lo}
    Click Element JS     ${btn_dong_lo_sp}
    Input Text    ${textbox_location}    ${input_text}
    ${item_dropdownlist}    Format String    ${xpath_item_dropdown}    ${input_text}
    Wait Until Element Is Visible    ${item_dropdownlist}    30 s
    Press Key    ${textbox_location}    ${ENTER_KEY}
    Element Should Contain    ${target_locator}    ${input_text}

Close button lot and input lot name for any product
    [Arguments]    ${input_product}    ${input_lo}
    ${button_dong_lo_any_product}     Format String    ${button_dong_lo_any_product}    ${input_product}
    Wait Until Page Contains Element    ${button_dong_lo_any_product}    1 min
    Click Element JS     ${button_dong_lo_any_product}
    ${textbox_lo}     Format String    ${textbox_nhap_lo_any_pr}    ${input_product}
    Input Text    ${textbox_lo}     ${input_lo}
    ${item_dropdownlist}    Format String    ${item_lo_in_dropdown}     ${input_lo}
    Wait Until Element Is Visible    ${item_dropdownlist}    30 s
    Press Key     ${textbox_lo}    ${ENTER_KEY}

Get lot name frm UI
    [Arguments]    ${locator}
    Wait Until Page Contains Element    ${locator}    2 mins
    ${get_text_ten lo}    Get text    ${locator}
    ${tenlo}    Convert To String    ${get_text_ten lo}
    Return From Keyword    ${tenlo}

Generate randomly list lots by num
    [Arguments]     ${list_num}
    ${list_num}     Convert string to list      ${list_num}
    ${list_tenlo}     Create List
    :FOR        ${item_num}       IN ZIP       ${list_num}
    \     ${tenlo}    Generate Random String    5    [UPPER][NUMBERS]
    \     Append To List    ${list_tenlo}    ${tenlo}
    Return From Keyword    ${list_tenlo}

Input list lot name and list num of product to tra hang nhanh form
    [Arguments]    ${input_ma_sp}    ${list_lo}    ${list_nums}
    ${list_result_lo}    Convert string to list    ${list_lo}
    ${list_result_nums}    Convert string to list    ${list_nums}
    : FOR    ${item_lo}    ${item_num}    IN ZIP    ${list_result_lo}    ${list_result_nums}
    \    Input Text    ${textbox_nhap_lo}   ${item_lo}
    \    ${item_dropdownlist}    Format String    ${item_lo_in_dropdown}    ${item_lo}
    \    Wait Until Element Is Visible    ${item_dropdownlist}    10 s
    \    Press Key    ${textbox_nhap_lo}    ${ENTER_KEY}
    \    Wait Until Page Contains Element    ${textbox_bh_soluongban}    10s
    \    Input data    ${textbox_bh_soluongban}    ${item_num}

Input lodate products and nums to Tra Hang Nhap
    [Arguments]    ${product_code}    ${num}       ${lastest_number}
    [Documentation]    Nhập mã sản phẩm, số lượng
    Wait Until Page Contains Element    ${textbox_search_trahangnhap}    2 mins
    ${target_display_by_product_code}      Format String        ${cell_product_code_display_thn}         ${product_code}
    Wait Until Keyword Succeeds    3 times    10 s    Input data in textbox and wait until it is visible    ${textbox_search_trahangnhap}    ${product_code}    ${dropdown_product_code_display}
    ...    ${target_display_by_product_code}
    ${textbox_quantity_thn}       Format String       ${textbox_quantity_thn}       ${product_code}
    Wait Until Page Contains Element    ${textbox_quantity_thn}    2 mins
    ${lastest_num}    Input number and validate data    ${textbox_quantity_thn}    ${num}    ${lastest_number}    ${cell_lastest_number_thn}
    Return From Keyword    ${lastest_num}

Input lot in textbox and wait until it is visible
    [Arguments]    ${textbox_location}    ${input_text}    ${xpath_item_dropdown}    ${target_locator}    ${input_number_lot}
    [Timeout]     3 mins
    Wait Until Page Contains Element    ${textbox_location}    1 min
    Input text    ${textbox_location}    ${input_text}
    Sleep    3 s
    ${item_dropdownlist}    Format String    ${xpath_item_dropdown}    ${input_text}
    Wait Until Page Contains Element       ${item_dropdownlist}    30s
    Press Key    ${textbox_location}    ${ENTER_KEY}
    Wait Until Page Contains Element       ${textbox_nh_soluong_lo}
    Input Text    ${textbox_nh_soluong_lo}    ${input_number_lot}
    Wait Until Keyword Succeeds    3 times    3 s    Click Element JS    ${button_save_lot_popup}
    Sleep    2s
    Element Should Contain    ${target_locator}    ${input_text}

Click lot and enter number in popup for lot
    [Documentation]    click vào lô và ấn enter để hiện lên popup nhập số lượng lô
    [Arguments]    ${input_text}    ${target_locator}    ${input_number}
    [Timeout]     3 mins
    ${item_dropdownlist}    Format String    ${target_locator}    ${input_text}
    Wait Until Page Contains Element       ${item_dropdownlist}    30s
    Click Element JS    ${item_dropdownlist}
    Wait Until Page Contains Element       ${textbox_nh_soluong_lo}
    Input Text    ${textbox_nh_soluong_lo}    ${input_number}
    Wait Until Keyword Succeeds    3 times    3 s    Click Element JS    ${button_save_lot_popup}

Create lodate product have genuine guarantees
    [Documentation]    hàng hóa lô date2 đơn vị tính có bảo hành bảo trì
    [Arguments]    ${ui_product_code}    ${ten}    ${ten_nhom}    ${giaban}    ${dvcb}    ${tendv1}    ${gtqd1}    ${giaban1}    ${ma_hh1}    ${time_bh}    ${timetype_bh}    ${time_bt}    ${timetype_bt}
    ${get_product_id}    Add lodate product incl 2 unit thr API    ${ui_product_code}    ${ten}    ${ten_nhom}    ${giaban}    ${dvcb}    ${ma_hh1}    ${giaban1}    ${tendv1}    ${gtqd1}
    Save guarantee after create product    ${time_bh}    ${timetype_bh}    ${time_bt}    ${timetype_bt}    ${get_product_id}
    ${product_id}    Get product id thr API    ${ma_hh1}
    Save guarantee after create product    ${time_bh}    ${timetype_bh}    ${time_bt}    ${timetype_bt}    ${product_id}

Get list batch expire id thr api
    [Arguments]    ${list_product}    ${list_tenlo}
    [Documentation]    lấy list id của lô - tracking lodate
    [Timeout]    5 minutes
    ${list_batchexpire_id}    Create List
    ${get_list_giatri_quydoi}   Get list gia tri quy doi frm product API    ${list_product}
    #${get_list_product_id}    Get list product id thr API    ${list_product}
    : FOR    ${item_tenlo}    ${get_dvqd}    ${item_sp}    IN ZIP    ${list_tenlo}    ${get_list_giatri_quydoi}    ${list_product}
    \    ${item_tenlo}    Convert To String    ${item_tenlo}
    \    ${item_tenlo}    Replace sq blackets    ${item_tenlo}
    \    ${jsonpath_batchlname}    Format String    $..Data[?(@.BatchName=="{0}")].Id    ${item_tenlo}
    \    ${hang_cb}    Run Keyword If    '${get_dvqd}'!='1'     Get basic product frm unit product    ${item_sp}    ELSE    Set Variable    0
    \    ${get_id_sp}    Run Keyword If    '${hang_cb}'!='0'    Get product id thr API    ${hang_cb}    ELSE    Get product id thr API    ${item_sp}
    \    ${endpoin_lodate}    Format String    ${endpoint_batchexpire_dvt}    ${get_id_sp}    ${get_dvqd}
    \    ${lodate_id}    Get data from API    ${endpoin_lodate}    ${jsonpath_batchlname}
    \    Append To List    ${list_batchexpire_id}    ${lodate_id}
    Return From Keyword    ${list_batchexpire_id}

Add new invoice with lodate product
    [Arguments]    ${input_ma_kh}    ${dict_product_nums}   ${input_gghd}    ${input_khtt}
    ${Uuid}      Generate Random String    4    [NUMBERS][NUMBERS]
    ${Uuid_code}      Catenate      SEPARATOR=      WA     ${Uuid}
    ${list_product}    Get Dictionary Keys    ${dict_product_nums}
    ${list_nums}    Get Dictionary Values    ${dict_product_nums}
    #Create list imei and other product    ${list_product}    ${list_nums}
    ${list_tenlo}    Create List
    : FOR    ${item_pr}    ${item_list_num}    IN ZIP    ${list_product}    ${list_nums}
    \    ${item_list_num}    Convert string to list    ${item_list_num}
    \    ${list_tenlo_by_pr}    Import multi lot for product and get list lots    ${item_pr}    ${item_list_num}
    \    Append To List    ${list_tenlo}    ${list_tenlo_by_pr}
    Set Test Variable    \${list_lots_TH}    ${list_tenlo}
    Log    ${list_tenlo}
    ${list_id_lo}    Get list batch expire id thr api    ${list_product}    ${list_tenlo}
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${jsonpath_id_kh}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_kh}
    ${get_id_kh}    Get data from API    ${endpoint_khachhang}    ${jsonpath_id_kh}
    ${endpoint_danhmuc_hh_co_dvt}    Format String    ${endpoint_list_hh_in_mhbh}    ${BRANCH_ID}    ${BRANCH_ID}
    ${get_resp_danhmuc_hh}    Get Request and return body    ${endpoint_danhmuc_hh_co_dvt}
    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}    Get list jsonpath product frm list product    ${list_product}
    ${list_giaban}    ${list_id_sp}    Get product info frm list jsonpath product    ${get_resp_danhmuc_hh}    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}
    ${list_result_thanhtien}    Create List
    : FOR    ${item_giaban}    ${item_nums}    IN ZIP    ${list_giaban}    ${list_nums}
    \    ${result_thanhtien}    Multiplication with price round 2    ${item_giaban}    ${item_nums}
    \    Append To List    ${list_result_thanhtien}    ${result_thanhtien}
    ${result_tongtienhang}    Sum values in list    ${list_result_thanhtien}
    ${giamgia_hd}    Set Variable If    0 < ${input_gghd} < 100    ${input_gghd}    null
    ${result_gghd}    Run Keyword If    0 < ${input_gghd} < 100    Convert % discount to VND    ${result_tongtienhang}    ${input_gghd}    ELSE    Set Variable    ${input_gghd}
    ${result_khtt}    Minus    ${result_tongtienhang}    ${result_gghd}
    ${actual_khtt}    Set Variable If    '${input_khtt}' == 'all'    ${result_khtt}    ${input_khtt}
    #post request
    ${liststring_prs_invoice_detail}    Set Variable    needdel
    Log    ${liststring_prs_invoice_detail}
    : FOR    ${item_gia_ban}    ${item_id_sp}    ${item_soluong}    ${item_id_lo}    IN ZIP    ${list_giaban}    ${list_id_sp}    ${list_nums}    ${list_id_lo}
    \    ${payload_each_product}    Format string    {{"BasePrice":75000,"IsLotSerialControl":false,"IsBatchExpireControl":true,"IsRewardPoint":false,"Note":"","Price":{0},"ProductId":{1},"Quantity":{2},"ProductCode":"TRLD02","ProductName":"son BBIA màu 01 - (Cai)","OriginPrice":75000,"PriceByPromotion":null,"PromotionParentProductId":null,"ProductBatchExpireId":{3},"CategoryId":0,"MasterProductId":0,"Unit":"Cai","Uuid":"","ProductWarranty":[],"SupplyPromotionTypes":"","Formulas":null}}
    \    ...    ${item_gia_ban}        ${item_id_sp}    ${item_soluong}    ${item_id_lo}
    \    ${liststring_prs_invoice_detail}    Catenate    SEPARATOR=,    ${liststring_prs_invoice_detail}    ${payload_each_product}
    ${liststring_prs_invoice_detail}    Replace String    ${liststring_prs_invoice_detail}    needdel,    ${EMPTY}    count=1
    ${request_payload}    Format String    {{"Invoice":{{"BranchId":{0},"RetailerId":{1},"UpdateInvoiceId":0,"UpdateReturnId":0,"CustomerId":{2},"SoldById":{3},"SoldBy":{{"CreatedBy":0,"CreatedDate":"2020-09-07T04:58:15.743Z","Email":"tthao@gmail.com","GivenName":"thao11","Id":{3},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false}},"SaleChannelId":0,"Seller":{{"CreatedBy":0,"CreatedDate":"2020-09-07T04:58:15.743Z","Email":"tthao@gmail.com","GivenName":"thao11","Id":{3},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false}},"OrderCode":"","Code":"Hóa đơn 1","Discount":{4},"DiscountRatio":{5},"InvoiceDetails":[{6}],"InvoiceOrderSurcharges":[],"InvoicePromotions":[],"InvoiceSupplierPromotions":[],"Payments":[{{"Method":"Cash","MethodStr":"Tiền mặt","Amount":{7},"Id":-1}}],"Status":1,"Total":{7},"Surcharge":0,"Type":1,"Uuid":"{8}","addToAccount":"0","addToAccountSurplus":"0","addToAccountAllocation":"0","addToAccountPaymentAllocation":"0","PayingAmount":{7},"TotalBeforeDiscount":472500,"ProductDiscount":0,"DebugUuid":"","InvoiceWarranties":[],"CreatedBy":{3}}}}}
    ...    ${BRANCH_ID}    ${get_id_nguoitao}    ${get_id_kh}    ${get_id_nguoiban}
    ...    ${result_gghd}    ${giamgia_hd}    ${liststring_prs_invoice_detail}    ${actual_khtt}    ${Uuid_code}
    Log    ${request_payload}
    ${invoice_code}    Post request to create invoice and get invoice code    ${request_payload}
    Return From Keyword    ${invoice_code}

Add new invoice incase discount - return code with lodate product
    [Documentation]    tạo hóa đơn lô date có giảm giá hàng hóa
    [Arguments]    ${input_ma_kh}    ${dict_product_nums}    ${list_ggsp}    ${list_discount_type}    ${input_gghd}    ${input_khtt}
    ${Uuid}      Generate Random String    4    [NUMBERS][NUMBERS]
    ${Uuid_code}      Catenate      SEPARATOR=      WA     ${Uuid}
    ${list_product}    Get Dictionary Keys    ${dict_product_nums}
    ${list_nums}    Get Dictionary Values    ${dict_product_nums}
    #Create list imei and other product    ${list_product}    ${list_nums}
    ${list_tenlo}    Create List
    : FOR    ${item_pr}    ${item_list_num}    IN ZIP    ${list_product}    ${list_nums}
    \    ${item_list_num}    Convert string to list    ${item_list_num}
    \    ${list_tenlo_by_pr}    Import multi lot for product and get list lots    ${item_pr}    ${item_list_num}
    \    Append To List    ${list_tenlo}    ${list_tenlo_by_pr}
    Set Test Variable    \${list_lots_TH}    ${list_tenlo}
    Log    ${list_tenlo}
    ${list_id_lo}    Get list batch expire id thr api    ${list_product}    ${list_tenlo}
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${jsonpath_id_kh}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_kh}
    ${get_id_kh}    Get data from API    ${endpoint_khachhang}    ${jsonpath_id_kh}
    ${endpoint_danhmuc_hh_co_dvt}    Format String    ${endpoint_list_hh_in_mhbh}    ${BRANCH_ID}    ${BRANCH_ID}
    ${get_resp_danhmuc_hh}    Get Request and return body    ${endpoint_danhmuc_hh_co_dvt}
    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}    Get list jsonpath product frm list product    ${list_product}
    #Sleep    60s
    ${list_giaban}    ${list_result_ggsp}    ${list_id_sp}    ${list_thanhtien}    Get product info frm list jsonpath product incase discount product - return total sale    ${get_resp_danhmuc_hh}    ${list_jsonpath_id_sp}
     ...    ${list_jsonpath_giaban}    ${list_ggsp}    ${list_discount_type}    ${list_nums}
    ${result_tongtienhang}    Sum values in list    ${list_thanhtien}
    ${giamgia_hd}    Set Variable If    0 < ${input_gghd} < 100    ${input_gghd}    null
    ${result_gghd}    Run Keyword If    0 < ${input_gghd} < 100    Convert % discount to VND    ${result_tongtienhang}    ${input_gghd}
    ...    ELSE    Set Variable    ${input_gghd}
    ${result_khtt}    Minus    ${result_tongtienhang}    ${result_gghd}
    ${actual_khtt}    Set Variable If    '${input_khtt}' == 'all'    ${result_khtt}    ${input_khtt}
    #post request
    ${liststring_prs_invoice_detail}    Set Variable    needdel
    Log    ${liststring_prs_invoice_detail}
    : FOR    ${item_gia_ban}    ${item_id_sp}    ${item_soluong}    ${item_id_lo}    ${item_result_ggsp}    ${item_ggsp}    IN ZIP    ${list_giaban}
    ...    ${list_id_sp}    ${list_nums}    ${list_id_lo}    ${list_result_ggsp}    ${list_ggsp}
    #\    ${item_imei}    Convert list to string and return    ${item_imei}
    \    ${item_ggsp}    Set Variable If    0 < ${item_ggsp} < 100    ${item_ggsp}    0
    \    ${payload_each_product}    Format string    {{"BasePrice":75000,"IsLotSerialControl":false,"IsBatchExpireControl":true,"IsRewardPoint":false,"Note":"","Price":{0},"ProductId":{1},"Quantity":{2},"ProductCode":"TRLD02","Discount":{4},"DiscountRatio":{5},"ProductName":"son BBIA màu 01 - (Cai)","OriginPrice":75000,"PriceByPromotion":null,"PromotionParentProductId":null,"ProductBatchExpireId":{3},"CategoryId":0,"MasterProductId":11689199,"Unit":"Cai","Uuid":"","ProductWarranty":[],"SupplyPromotionTypes":"","Formulas":null}}
    \    ...    ${item_gia_ban}    ${item_id_sp}    ${item_soluong}    ${item_id_lo}    ${item_result_ggsp}    ${item_ggsp}
    \    ${liststring_prs_invoice_detail}    Catenate    SEPARATOR=,    ${liststring_prs_invoice_detail}    ${payload_each_product}
    ${liststring_prs_invoice_detail}    Replace String    ${liststring_prs_invoice_detail}    needdel,    ${EMPTY}    count=1
    ${request_payload}    Format String    {{"Invoice":{{"BranchId":{0},"RetailerId":{1},"UpdateInvoiceId":0,"UpdateReturnId":0,"CustomerId":{2},"SoldById":{3},"SoldBy":{{"CreatedBy":0,"CreatedDate":"2020-09-07T04:58:15.743Z","Email":"tthao@gmail.com","GivenName":"thao11","Id":{3},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false}},"SaleChannelId":0,"Seller":{{"CreatedBy":0,"CreatedDate":"2020-09-07T04:58:15.743Z","Email":"tthao@gmail.com","GivenName":"thao11","Id":{3},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false}},"OrderCode":"","Code":"Hóa đơn 1","Discount":{4},"DiscountRatio":{5},"InvoiceDetails":[{6}],"InvoiceOrderSurcharges":[],"InvoicePromotions":[],"InvoiceSupplierPromotions":[],"Payments":[{{"Method":"Cash","MethodStr":"Tiền mặt","Amount":{7},"Id":-1}}],"Status":1,"Total":{7},"Surcharge":0,"Type":1,"Uuid":"{8}","addToAccount":"0","addToAccountSurplus":"0","addToAccountAllocation":"0","addToAccountPaymentAllocation":"0","PayingAmount":{7},"TotalBeforeDiscount":472500,"ProductDiscount":0,"DebugUuid":"","InvoiceWarranties":[],"CreatedBy":{3}}}}}
    ...    ${BRANCH_ID}    ${get_id_nguoitao}    ${get_id_kh}    ${get_id_nguoiban}
    ...    ${result_gghd}    ${giamgia_hd}    ${liststring_prs_invoice_detail}    ${actual_khtt}    ${Uuid_code}
    Log    ${request_payload}
    ${invoice_code}    Post request to create invoice and get invoice code    ${request_payload}
    Return From Keyword    ${invoice_code}

Create return - exchange invoice with lodate products
    [Documentation]    tạo đơn đổi - trả hàng THEO HÓA ĐƠN với hàng hóa lodate
    [Arguments]    ${get_ma_hd}    ${input_ma_kh}    ${dic_productnums_th}    ${dic_productnums_dth}    ${list_ggsp}    ${list_discount_type}
    ...    ${input_phi_th}     ${input_ggdth}    ${input_khtt}
    ${list_product_dth}    Get Dictionary Keys    ${dic_productnums_dth}
    ${list_nums_dth}    Get Dictionary Values    ${dic_productnums_dth}
    ${Uuid}      Generate Random String    4    [NUMBERS][NUMBERS]
    ${Uuid_code}      Catenate      SEPARATOR=      WA     ${Uuid}
    ${get_invoice_id}    Get invoice id    ${get_ma_hd}
    ${get_invoice_detail_id}    Get invoice detail id    ${get_ma_hd}
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${get_id_kh}    Get customer id thr API    ${input_ma_kh}
    #tao lo
    #get data frm Trả hàng
    ${list_id_lo}    Get list batch expire id thr api    ${list_product_dth}    ${list_lots_DTH}
    ${get_ma_kh_by_hd_bf_ex}    ${get_tong_tien_hang_bf_ex}    ${get_khach_tt_bf_ex}    ${get_trangthai_bf_ex}    Get invoice info by invoice code    ${get_ma_hd}
    ${get_list_hh_in_hd}    ${get_list_sl_in_hd}    Get list product and quantity frm invoice API    ${get_ma_hd}
    ${get_list_sl_in_hd}    Convert String to List    ${get_list_sl_in_hd}
    ${list_result_thanhtien_th}    ${list_giavon_th}    ${list_result_toncuoi_th}    Get list total sale - endingstock - cost frm product api    ${get_list_hh_in_hd}    ${get_list_sl_in_hd}
    ${list_result_thanhtien_dth}    ${list_giavon_dth}    ${list_result_toncuoi_dth}    ${list_result_newprice}    Get list total sale - endingstock - cost - newprice with additional invoice    ${list_product_dth}
    ...    ${list_nums_dth}    ${list_ggsp}    ${list_discount_type}
    ${get_no_bf_execute}    ${get_tongban_bf_execute}    ${get_tongban_tru_trahang_bf_execute}    Get Customer Debt from API    ${input_ma_kh}

    #compute trả hàng
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
    ${gghd_type}    Set Variable If    ${input_ggdth}>100    null    ${input_ggdth}
    ## payload tra Hang
    ${get_list_hh_in_hd}    ${get_list_sl_in_hd}    Get list product and quantity frm invoice API    ${get_ma_hd}
    ${get_list_baseprice_th}    Get list of Baseprice by Product Code    ${get_list_hh_in_hd}
    ${get_list_pr_th_id}    Get list product id thr API    ${get_list_hh_in_hd}
    Log   get id lô
    ${product_th}    Get Dictionary Keys    ${dic_productnums_th}
    ${list_id_lot_TH}    Get list batch expire id thr api    ${product_th}    ${list_lots_TH}
    ${liststring_prs_return_detail}    Set Variable    needdel
    : FOR    ${item_product_id}    ${item_price}    ${item_num}     ${item_lot_TH}   IN ZIP    ${get_list_pr_th_id}    ${get_list_baseprice_th}    ${get_list_sl_in_hd}    ${list_id_lot_TH}
    \    ${payload_each_product}    Format string    {{"BasePrice":{0},"IsLotSerialControl":false,"Note":"","Price":{0},"ProductId":{1},"Quantity":{2},"SerialNumbers":"","SellPrice":{0},"ProductName":"son BBIA màu #01 - (Cai)","Discount":0,"DiscountRatio":0,"CopiedPrice":{0},"InvoiceDetailId":{3},"IsMaster":true,"ProductBatchExpireId":{4},"ProductBatchExpire":{{"BatchName":"","CreatedDate":"","ExpireDate":"","FullName":"","FullNameVirgule":"","Id":{4},"OnHand":0,"ProductId":{1},"RetailerId":{5},"isExpired":false}},"Formulas":null}}
    \    ...    ${item_price}    ${item_product_id}    ${item_num}    ${get_invoice_detail_id}    ${item_lot_TH}     ${get_id_nguoitao}
    \    ${liststring_prs_return_detail}    Catenate    SEPARATOR=,    ${liststring_prs_return_detail}    ${payload_each_product}
    Log    ${liststring_prs_return_detail}
    ${liststring_prs_return_detail}    Replace String    ${liststring_prs_return_detail}    needdel,    ${EMPTY}    count=1
    #invoice
    ${endpoint_danhmuc_hh_by_branch}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${resp_product_list}    Get Request and return body    ${endpoint_danhmuc_hh_by_branch}
    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}    Get List Jsonpath Product Frm List Product    ${list_product_dth}
    ${list_giaban}    ${list_result_ggsp}    ${list_productid}   Get product info frm list jsonpath product incase discount product    ${resp_product_list}    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}
    ...    ${list_ggsp}    ${list_discount_type}
    ${liststring_prs_invoice_detail}    Set Variable    needdel
    ${liststring_prs_invoice_detail1}    Set Variable    needdel
    : FOR    ${item_product_id}    ${item_price}    ${item_num}    ${item_result_discountproduct}    ${item_discounttype}    ${item_id_lot}
    ...    IN ZIP    ${list_productid}    ${list_giaban}    ${list_nums_dth}    ${list_result_ggsp}    ${list_ggsp}    ${list_id_lo}
    \    ${payload_each_product}    Format string    {{"ProductId":{0},"ProductName":"Mứt dâu tây sấy - (Hop)","ProductFullName":"Mứt dâu tây sấy - (Hop)","ProductNameNoUnit":"Mứt dâu tây sấy","ProductSName":"Mứt dâu tây sấy","ProductCode":"LDQD017","ProductType":2,"ProductCategoryId":474130,"MasterProductId":12125893,"OnHand":1.25,"OnOrder":0,"Reserved":0,"ActualReserved":0,"Price":{1},"OriginSalePrice":{1},"Unit":"Hop","MasterUnitId":12125893,"Note":"","PromotionReceiverQty":1,"Quantity":{2},"ProductSerials":[],"Serials":[],"IsLotSerialControl":false,"IsRewardPoint":false,"CurrentQuery":"LDQD017","CategoryId":474130,"Promotions":[],"Discount":{3},"DiscountRatio":{4},"BasePrice":{1},"Cost":0,"DuplicationCartItems":[],"isDeleted":false,"ProductShelves":[],"AllowSale":true,"IsBatchExpireControl":true,"BatchExpire":{{"__type":"","BranchId":{6},"CreatedDate":"","ModifiedDate":"","OnHand":2.5,"Id":{5},"RetailerId":{7},"Revision":"AAAAABVbdVQ=","Status":1,"BatchName":"","ExpireDate":"","FullName":"","FullNameVirgule":"","ProductId":12125893,"isExpired":false}},"ProductWarranty":[],"Formulas":null,"Uuid":"","ConversionValue":2,"CartType":3,"Units":[{{"Id":{0},"Unit":"Hop","FullName":"LDQD017 Mứt dâu tây sấy - (Hop)","DiscountChanged":{3},"DiscountRatioChanged":{4}}}],"Error":"","SelectedUnit":{{"Id":{0},"Unit":"Hop","FullName":"Mứt dâu tây sấy - (Hop)"}},"discountRatioPriceWoRound":{4},"discountPriceWoRound":{3},"ProductWarrantyForPrint":[],"ProductMaintenanceForPrint":[],"MaxQuantity":null}}
    \    ...    ${item_product_id}    ${item_price}    ${item_num}    ${item_result_discountproduct}    ${item_discounttype}    ${item_id_lot}    ${BRANCH_ID}    ${get_id_nguoitao}
    \    ${payload_each_product_1}    Format string    {{"BasePrice":{0},"IsLotSerialControl":false,"IsBatchExpireControl":true,"IsRewardPoint":false,"Note":"","Price":{0},"OriginPrice":{0},"ProductId":{1},"Quantity":{2},"Discount":{4},"DiscountRatio":{5},"ProductName":"Mứt dâu tây sấy - (Cai)","ProductCode":"TRLD023","ProductBatchExpireId":{3},"Uuid":"","Formulas":null}}
    \    ...    ${item_price}    ${item_product_id}    ${item_num}    ${item_id_lot}    ${item_result_discountproduct}    ${item_discounttype}
    \    ${liststring_prs_invoice_detail}    Catenate    SEPARATOR=,    ${liststring_prs_invoice_detail}    ${payload_each_product}
    \    ${liststring_prs_invoice_detail1}    Catenate    SEPARATOR=,    ${liststring_prs_invoice_detail1}    ${payload_each_product_1}
    Log    ${liststring_prs_invoice_detail}
    Log    ${liststring_prs_invoice_detail1}
    ${liststring_prs_invoice_detail}    Replace String    ${liststring_prs_invoice_detail}    needdel,    ${EMPTY}    count=1
    ${liststring_prs_invoice_detail1}    Replace String    ${liststring_prs_invoice_detail1}    needdel,    ${EMPTY}    count=1
    ${request_payload}    Format String    {{"Return":{{"BranchId":{0},"RetailerId":{1},"InvoiceId":{2},"CustomerId":{3},"ReceivedById":{4},"ReceivedBy":{{"CreatedBy":0,"CreatedDate":"2018-07-30T08:27:36.800Z","GivenName":"anh.lv","Id":{4},"IsActive":true,"IsAdmin":true,"MobilePhone":"","Type":0,"isDeleted":false,"Name":"anh.lv"}},"SaleChannelId":0,"SaleChannel":null,"Code":"Trả hàng 1","ReturnDiscount":0,"ReturnFee":{5},"ReturnFeeRatio":{6},"ReturnDetails":[{7}],"InvoiceDetails":[{8}],"InvoiceOrderSurcharges":[],"Payments":[{{"Method":"Cash","MethodStr":"Tiền mặt","Amount":{9},"Id":-1}}],"Status":1,"Surcharge":0,"Type":3,"Uuid":"","PayingAmount":{9},"SumTotal":{10},"TotalBeforeDiscount":{18},"ProductDiscount":0,"TotalInvoice":{17},"TotalReturn":{11},"txtPay":"Tiền trả khách","addToAccount":"0","InvoiceComparePurchaseDate":"2020-05-05T16:03:35.1730000+07:00","ReturnSurcharges":[],"CreatedBy":{4}}},"Invoice":{{"BranchId":{12},"RetailerId":{1},"UpdateInvoiceId":0,"UpdateReturnId":0,"CustomerId":{3},"SoldById":{4},"SoldBy":{{"CreatedBy":0,"CreatedDate":"2018-07-30T08:27:36.800Z","GivenName":"anh.lv","Id":{4},"IsActive":true,"IsAdmin":true,"MobilePhone":"","Type":0,"isDeleted":false,"Name":"anh.lv"}},"SaleChannelId":0,"SaleChannel":null,"Seller":{{"CreatedBy":0,"CreatedDate":"2018-07-30T08:27:36.800Z","GivenName":"anh.lv","Id":{4},"IsActive":true,"IsAdmin":true,"MobilePhone":"","Type":0,"isDeleted":false,"Name":"anh.lv"}},"OrderCode":"","Discount":{13},"DiscountRatio":{14},"InvoiceDetails":[{15}],"InvoiceOrderSurcharges":[],"Status":1,"Total":{18},"Surcharge":0,"Type":1,"Uuid":"{16}","addToAccount":"0","PayingAmount":{9},"TotalBeforeDiscount":7000,"ProductDiscount":0,"DebugUuid":"","InvoiceWarranties":[],"CreatedBy":{4}}}}}
    ...    ${BRANCH_ID}    ${get_id_nguoitao}    ${get_invoice_id}    ${get_id_kh}    ${get_id_nguoiban}    ${result_phi_th}    ${input_phi_th}    ${liststring_prs_return_detail}
    ...    ${liststring_prs_invoice_detail}    ${actual_khtt}    ${result_kh_canthanhtoan}    ${result_tongtientra_tru_phith}   ${BRANCH_ID}
    ...    ${result_ggdth}    ${gghd_type}    ${liststring_prs_invoice_detail1}    ${Uuid_code}    ${result_tongtienmua_tru_gg}    ${result_tongtienmua}
    Log    ${request_payload}
    ${return_code}    Post request to create exchange and get return code    ${request_payload}
    Return From Keyword    ${return_code}

Delete data of tracking lodate
    [Arguments]    ${dict_loaihh}
    ${list_prs}    Get Dictionary Keys    ${dict_loaihh}
    ${list_hh}     Copy List    ${list_prs}
    ${list_type}    Get Dictionary Values    ${dict_loaihh}
    ${hang_quy_doi}    Create List
    :FOR    ${item_hh}    ${item_type}    IN ZIP    ${list_prs}    ${list_type}
    \    Run Keyword If    '${item_type}' == 'hhsx'    Run Keywords     Remove values from list     ${list_hh}     ${item_hh}    AND    Delete product thr API    ${item_hh}
    \    Run Keyword If    '${item_type}' == 'lodate_unit'    Run Keywords    Remove values from list     ${list_hh}     ${item_hh}    AND    Append To List    ${hang_quy_doi}    ${item_hh}
    Log     ${list_hh}
    Log     ${hang_quy_doi}
    :FOR    ${item_hh}    IN ZIP    ${hang_quy_doi}
    \    ${basic}    Get basic product frm unit product    ${item_hh}
    \    Wait Until Keyword Succeeds    3x    1s    Delete product thr API    ${basic}
    :FOR    ${item_hh}    IN ZIP    ${list_hh}
    \    Wait Until Keyword Succeeds    3x    1s    Delete product thr API    ${item_hh}

Create lits lot for list products
    [Documentation]    tạo list lô cho list hàng lô date theo số lượng input
    [Arguments]    ${list_product}    ${list_nums}
    ${list_lots}      Create List
    : FOR    ${item_pr}    ${item_list_num}    IN ZIP    ${list_product}    ${list_nums}
    \    ${item_list_num}    Convert string to list    ${item_list_num}
    \    ${list_tenlo_by_pr}    Import multi lot for product and get list lots    ${item_pr}    ${item_list_num}
    \    Append To List    ${list_lots}    ${list_tenlo_by_pr}
    Set Test Variable    \${list_lots_DTH}    ${list_lots}
    Return From Keyword    ${list_lots}

Assert values in Stock Card in tab Lo - HSD for basic and unit prs
    [Arguments]    ${ma_phieu}    ${input_actual_product}    ${input_product}    ${input_toncuoi}    ${input_num}    ${tenlo}
    [Documentation]    So sánh giá trị trong thẻ kho tab Lô - HSD
    [Timeout]    5 minutes
    ${soluong_in_thekho}    ${toncuoi_in_thekho}    Get Stock Card Lot in tab Lo - HSD frm API    ${ma_phieu}    ${input_actual_product}    ${input_product}    ${tenlo}
    ${get_gtqd}    Get conversion value of unit product    ${input_actual_product}
    ${sl_in_thekho}    Run Keyword If    '${get_gtqd}'!='1'    Multiplication    ${soluong_in_thekho}    ${get_gtqd}    ELSE    Set Variable    ${soluong_in_thekho}
    ${ton_in_thekho}    Run Keyword If    '${get_gtqd}'!='1'    Multiplication    ${toncuoi_in_thekho}    ${get_gtqd}    ELSE    Set Variable    ${toncuoi_in_thekho}
    Should Be Equal As Numbers    ${ton_in_thekho}    ${input_toncuoi}
    Should Be Equal As Numbers    ${sl_in_thekho}    ${input_num}

Add new order with lodate product incase discount - payment
    [Arguments]    ${input_ma_kh}    ${input_ggdh}    ${dict_product_nums}    ${list_ggsp}    ${list_discount_type}    ${input_khtt}
    [Timeout]          5 mins
    #get product info
    ${Uuid}      Generate Random String    4    [NUMBERS][NUMBERS]
    ${Uuid_code}      Catenate      SEPARATOR=      WA     ${Uuid}
    ${list_product}   Get Dictionary Keys    ${dict_product_nums}
    ${list_soluong_sp}      Get Dictionary Values    ${dict_product_nums}
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${jsonpath_id_kh}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_kh}
    ${get_id_kh}    Get data from API    ${endpoint_khachhang}    ${jsonpath_id_kh}
    ${endpoint_danhmuc_hh_co_dvt}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${get_resp_danhmuc_hh}    Get Request and return body    ${endpoint_danhmuc_hh_co_dvt}
    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}    Get list jsonpath product frm list product    ${list_product}
    ${list_giaban}    ${list_result_ggsp}    ${list_id_sp}      ${list_thanhtien}    Get product info frm list jsonpath product incase discount product - return total sale    ${get_resp_danhmuc_hh}    ${list_jsonpath_id_sp}
    ...   ${list_jsonpath_giaban}    ${list_ggsp}    ${list_discount_type}    ${list_soluong_sp}
    #compute
    ${result_tongtienhang}    Sum values in list    ${list_thanhtien}
    ${giamgia_dh}    Set Variable If    0 < ${input_ggdh} < 100    ${input_ggdh}    0
    ${result_ggdh}    Run Keyword If    0 < ${input_ggdh} < 100    Convert % discount to VND    ${result_tongtienhang}    ${input_ggdh}    ELSE    Set Variable    ${input_ggdh}
    ${result_khtt}    Minus and round    ${result_tongtienhang}    ${result_ggdh}
    ${actual_khtt}    Set Variable If    '${input_khtt}' == 'all'    ${result_khtt}    ${input_khtt}
    #post request
    ${liststring_prs_order_detail}     Set Variable      needdel
    Log        ${liststring_prs_order_detail}
    : FOR    ${item_gia_ban}   ${item_id_sp}   ${item_soluong}    ${item_result_ggsp}   ${item_ggsp}      IN ZIP       ${list_giaban}        ${list_id_sp}    ${list_soluong_sp}       ${list_result_ggsp}       ${list_ggsp}
    \    ${item_ggsp}   Set Variable If    0 < ${item_ggsp} < 100    ${item_ggsp}   0
    \    ${payload_each_product}        Format string           {{"BasePrice":{0},"Discount":{3},"DiscountRatio":{4},"IsBatchExpireControl":true,"IsLotSerialControl":false,"IsRewardPoint":false,"Note":"","Price":{0},"ProductCode":"TRLD023","ProductId":{1},"ProductName":"Mứt dâu tây sấy - (Cai)","Quantity":{2},"Uuid":"","OriginPrice":{0},"ProductBatchExpireId":null,"Formulas":null}}    ${item_gia_ban}   ${item_id_sp}   ${item_soluong}    ${item_result_ggsp}   ${item_ggsp}
    \    ${liststring_prs_order_detail}       Catenate      SEPARATOR=,      ${liststring_prs_order_detail}      ${payload_each_product}
    ${liststring_prs_order_detail}       Replace String      ${liststring_prs_order_detail}       needdel,       ${EMPTY}      count=1
    ${request_payload}    Format String    {{"Order":{{"BranchId":{0},"RetailerId":{1},"CustomerId":{2},"SoldById":{3},"SoldBy":{{"CreatedBy":0,"CreatedDate":"2018-07-30T08:27:36.800Z","Email":"","GivenName":"anh.lv","Id":{3},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false}},"SaleChannelId":0,"Seller":{{"CreatedBy":0,"CreatedDate":"2018-07-30T08:27:36.800Z","Email":"","GivenName":"anh.lv","Id":{3},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false}},"Code":"Đặt hàng 1","Discount":{4},"DiscountRatio":{5},"OrderDetails":[{6}],"InvoiceOrderSurcharges":[],"Payments":[{{"Method":"Cash","MethodStr":"Tiền mặt","Amount":{7},"Id":-1}}],"UsingCod":0,"Status":1,"Total":757500,"Extra":"{{\\"Amount\\":0,\\"Method\\":{{\\"Id\\":\\"Cash\\",\\"Label\\":\\"Tiền mặt\\"}}}}","Surcharge":0,"Type":2,"Uuid":"{8}","addToAccount":"0","PayingAmount":0,"TotalBeforeDiscount":757500,"ProductDiscount":0}}}}    ${BRANCH_ID}    ${get_id_nguoitao}    ${get_id_kh}    ${get_id_nguoiban}
    ...    ${result_ggdh}    ${giamgia_dh}    ${liststring_prs_order_detail}    ${actual_khtt}    ${Uuid_code}
    Log    ${request_payload}
    Set Test Variable    \${tongtienhang}    ${result_tongtienhang}
    Set Test Variable    \${ggdh}     ${result_ggdh}
    Set Test Variable    \${tongcong}    ${result_khtt}
    Set Test Variable    \${list_giabansp}    ${list_giaban}
    Set Test Variable    \${list_ggsp}    ${list_result_ggsp}
    Set Test Variable    \${actual_khtt}    ${actual_khtt}
    ${order_code}    Post request to create order and return code    ${request_payload}
    Sleep    20 s    wait for response to API
    Return From Keyword    ${order_code}

Get list batch expire info thr api
    [Arguments]    ${list_product}    ${list_tenlo}
    [Documentation]    lấy thông tin của lô
    [Timeout]    5 minutes
    ${list_batchexpire_id}    Create List
    ${list_batch_name}    Create List
    ${list_expire_date}    Create List
    ${list_fullnamevirgule}    Create List
    ${get_list_giatri_quydoi}   Get list gia tri quy doi frm product API    ${list_product}
    #${get_list_product_id}    Get list product id thr API    ${list_product}
    : FOR    ${item_tenlo}    ${get_dvqd}    ${item_sp}    IN ZIP    ${list_tenlo}    ${get_list_giatri_quydoi}    ${list_product}
    \    ${item_tenlo}    Convert To String    ${item_tenlo}
    \    ${item_tenlo}    Replace sq blackets    ${item_tenlo}
    \    ${jsonpath_batchlname}    Format String    $..Data[?(@.BatchName=="{0}")].Id    ${item_tenlo}
    \    ${get_batch_name}    Format String    $..Data[?(@.BatchName=="{0}")].BatchName    ${item_tenlo}
    \    ${get_expire_date}    Format String    $..Data[?(@.BatchName=="{0}")].ExpireDate   ${item_tenlo}
    \    ${get_fullnamevirgule}    Format String    $..Data[?(@.BatchName=="{0}")].FullNameVirgule   ${item_tenlo}
    \    ${hang_cb}    Run Keyword If    '${get_dvqd}'!='1'     Get basic product frm unit product    ${item_sp}    ELSE    Set Variable    0
    \    ${get_id_sp}    Run Keyword If    '${hang_cb}'!='0'    Get product id thr API    ${hang_cb}    ELSE    Get product id thr API    ${item_sp}
    \    ${endpoin_lodate}    Format String    ${endpoint_batchexpire}    ${get_id_sp}    ${get_dvqd}
    \    ${lodate_id}    Get data from API    ${endpoin_lodate}    ${jsonpath_batchlname}
    \    ${lodate_name}    Get data from API    ${endpoin_lodate}    ${get_batch_name}
    \    ${lodate_expire}    Get data from API    ${endpoin_lodate}    ${get_expire_date}
    \    ${lodate_fullname}    Get data from API    ${endpoin_lodate}    ${get_fullnamevirgule}
    \    Append To List    ${list_batchexpire_id}    ${lodate_id}
    \    Append To List    ${list_batch_name}    ${lodate_name}
    \    Append To List    ${list_expire_date}    ${lodate_expire}
    \    Append To List    ${list_fullnamevirgule}    ${lodate_fullname}
    Return From Keyword    ${list_batchexpire_id}    ${list_batch_name}    ${list_expire_date}    ${list_fullnamevirgule}

Add new order with lodate product no customer
    [Arguments]    ${input_ggdh}    ${result_ggdh}    ${dict_product_nums}    ${list_ggsp}    ${list_discount_type}    ${actual_khtt}
    [Timeout]          5 mins
    #get product info
    ${Uuid}      Generate Random String    4    [NUMBERS][NUMBERS]
    ${Uuid_code}      Catenate      SEPARATOR=      WA     ${Uuid}
    ${list_product}   Get Dictionary Keys    ${dict_product_nums}
    ${list_nums}      Get Dictionary Values    ${dict_product_nums}
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${endpoint_danhmuc_hh_co_dvt}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${get_resp}    Get Request and return body    ${endpoint_danhmuc_hh_co_dvt}
    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}    Get list jsonpath product frm list product    ${list_product}
    ${list_giaban}    ${list_result_ggsp}    ${list_id_sp}      Get product info frm list jsonpath product incase discount product    ${get_resp}    ${list_jsonpath_id_sp}
    ...   ${list_jsonpath_giaban}    ${list_ggsp}    ${list_discount_type}
    #post request
    ${liststring_prs_order_detail}     Set Variable      needdel
    Log        ${liststring_prs_order_detail}
    : FOR    ${item_gia_ban}   ${item_id_sp}   ${item_soluong}    ${item_result_ggsp}   ${item_ggsp}      IN ZIP       ${list_giaban}        ${list_id_sp}    ${list_nums}       ${list_result_ggsp}       ${list_ggsp}
    \    ${item_ggsp}   Set Variable If    0 < ${item_ggsp} < 100    ${item_ggsp}   0
    \    ${payload_each_product}        Format string           {{"BasePrice":{0},"Discount":{3},"DiscountRatio":{4},"IsBatchExpireControl":true,"IsLotSerialControl":false,"IsRewardPoint":false,"Note":"","Price":{0},"ProductCode":"TRLD023","ProductId":{1},"ProductName":"Mứt dâu tây sấy - (Cai)","Quantity":{2},"Uuid":"","OriginPrice":{0},"ProductBatchExpireId":null,"Formulas":null}}    ${item_gia_ban}   ${item_id_sp}   ${item_soluong}    ${item_result_ggsp}   ${item_ggsp}
    \    ${liststring_prs_order_detail}       Catenate      SEPARATOR=,      ${liststring_prs_order_detail}      ${payload_each_product}
    ${liststring_prs_order_detail}       Replace String      ${liststring_prs_order_detail}       needdel,       ${EMPTY}      count=1
    ${giamgia_dh}    Set Variable If    0 < ${input_ggdh} < 100    ${input_ggdh}    0
    ${request_payload}    Format String    {{"Order":{{"BranchId":{0},"RetailerId":{1},"SoldById":{2},"SoldBy":{{"CreatedBy":0,"CreatedDate":"2018-07-30T08:27:36.800Z","Email":"","GivenName":"anh.lv","Id":{2},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false}},"SaleChannelId":0,"Seller":{{"CreatedBy":0,"CreatedDate":"2018-07-30T08:27:36.800Z","Email":"","GivenName":"anh.lv","Id":{2},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false}},"Code":"Đặt hàng 1","Discount":{3},"DiscountRatio":{4},"OrderDetails":[{5}],"InvoiceOrderSurcharges":[],"Payments":[{{"Method":"Cash","MethodStr":"Tiền mặt","Amount":{6},"Id":-1}}],"UsingCod":0,"Status":1,"Total":757500,"Extra":"{{\\"Amount\\":0,\\"Method\\":{{\\"Id\\":\\"Cash\\",\\"Label\\":\\"Tiền mặt\\"}}}}","Surcharge":0,"Type":2,"Uuid":"","addToAccount":"0","PayingAmount":0,"TotalBeforeDiscount":757500,"ProductDiscount":0}}}}    ${BRANCH_ID}    ${get_id_nguoitao}    ${get_id_nguoiban}    ${result_ggdh}    ${giamgia_dh}  ${liststring_prs_order_detail}    ${actual_khtt}
    Log    ${request_payload}
    ${order_code}    Post request to create order and return code    ${request_payload}
    #get values
    Sleep    20 s    wait for response to API
    Return From Keyword    ${order_code}

Update order by add new lodate product
    [Documentation]    update đon đặt hàng bằng cách thêm sản phẩm lô date vào đơn đặt hàng
    [Arguments]     ${order_code}    ${dict_product_nums}    ${input_ma_kh}    ${list_ggsp}   ${list_discount_type}    ${input_ggdh}   ${result_ggdh}   ${actual_khtt}    ${input_ghichu}
    ${list_product}    Get Dictionary Keys    ${dict_product_nums}
    ${list_nums}    Get Dictionary Values    ${dict_product_nums}
    #dgọp list cũ trong order với list mới cbi thêm vào order
    ${get_list_hh_in_order}    ${get_list_sl_in_order}   Get list product and quantity frm API    ${order_code}
    ${list_result_order_summary}    Get list result order summary frm product API    ${list_product}    ${list_nums}
    :FOR    ${item_hanghoa}   ${item_num}   IN ZIP          ${get_list_hh_in_order}    ${get_list_sl_in_order}
    \   Append To List    ${list_product}   ${item_hanghoa}
    \   Append To List    ${list_nums}   ${item_num}
    #
    ${get_list_order_detail_id}   Get list orderdetail id frm order api    ${order_code}    ${list_product}
    #create order by API
    ${get_order_id}   ${get_payment_id}   Get order - payment frm order api    ${order_code}
    ${get_khachdatra_in_dh_bf_execute}    ${get_tongtienhang_in_dh_bf_execute}    Get paid value frm API    ${order_code}
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${jsonpath_id_kh}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_kh}
    ${get_id_kh}    Get data from API    ${endpoint_khachhang}    ${jsonpath_id_kh}
    ${endpoint_danhmuc_hh_co_dvt}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${get_resp_danhmuc_hh}    Get Request and return body    ${endpoint_danhmuc_hh_co_dvt}
    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}    Get list jsonpath product frm list product    ${list_product}
    ${list_giaban}    ${list_result_ggsp}    ${list_id_sp}    Get product info frm list jsonpath product incase discount product    ${get_resp_danhmuc_hh}    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}
    ...    ${list_ggsp}   ${list_discount_type}
    ${liststring_prs_order_detail}     Set Variable      needdel
    Log        ${liststring_prs_order_detail}
    : FOR    ${item_result_ggsp}   ${item_ggsp}  ${item_orderdetail_id}    ${item_gia_ban}   ${item_id_sp}   ${item_soluong}      IN ZIP       ${list_result_ggsp}       ${list_ggsp}      ${get_list_order_detail_id}       ${list_giaban}        ${list_id_sp}    ${list_nums}
    \     ${item_ggsp}    Set Variable If    0 < ${item_ggsp} < 100    ${item_ggsp}     0
    \    ${payload_each_product}        Format string       {{"BasePrice":{0},"Discount":{3},"DiscountRatio":{4},"IsBatchExpireControl":true,"IsLotSerialControl":false,"IsRewardPoint":false,"Note":"","Price":{0},"ProductCode":"TRLD023","ProductId":{1},"ProductName":"Mứt dâu tây sấy - (Cai)","Quantity":{2},"Uuid":"","OriginPrice":{0},"ProductBatchExpireId":null,"Formulas":null}}    ${item_gia_ban}   ${item_id_sp}   ${item_soluong}    ${item_result_ggsp}   ${item_ggsp}
    \    ${liststring_prs_order_detail}       Catenate      SEPARATOR=,      ${liststring_prs_order_detail}      ${payload_each_product}
    ${liststring_prs_order_detail}       Replace String      ${liststring_prs_order_detail}       needdel,       ${EMPTY}      count=1
    ${giamgia_dh}    Set Variable If    0 < ${input_ggdh} < 100    ${input_ggdh}    0
    ${request_payload}    Format String    {{"Order":{{"Id":{0},"BranchId":{1},"RetailerId":{2},"CustomerId":{3},"SoldById":{4},"SoldBy":{{"CreatedBy":0,"CreatedDate":"2018-12-10T08:33:32.447Z","Email":"","GivenName":"admin","Id":{4},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false,"Name":"admin"}},"SaleChannelId":0,"SaleChannel":null,"Seller":{{"CreatedBy":0,"CreatedDate":"2018-12-10T08:33:32.447Z","Email":"","GivenName":"admin","Id":{4},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false,"Name":"admin"}},"PurchaseDate":"","Code":"{5}","Discount":{6},"DiscountRatio":{7},"OrderDetails":[{8}],"InvoiceOrderSurcharges":[],"Payments":[{{"OrderValue":0,"DocumentValue":0,"PaidValue":0,"NeedPayValue":0,"CustomerName":"","CustomerCode":"","InvoiceCode":"","CustomerDebt":0,"CustomerOldDebt":0,"TargetCode":"","UserName":"","VoucherCampaignId":0,"Version":0,"TransGuid":"00000000000000000000000000000000","DocumentTypeValue":0,"Id":{9},"Code":"TTDH003658","Amount":{10},"AmountOriginal":0,"Method":"Cash","CreatedDate":"","CreatedBy":{4},"RetailerId":{2},"BranchId":{1},"OrderId":{0},"CustomerId":{3},"TransDate":"","UserId":{4},"Status":0,"System":false,"DeliveryPayments":[],"PaymentAllocation":[]}},{{"Method":"Cash","MethodStr":"Tiền mặt","Amount":{11},"Id":-2}}],"UsingCod":0,"Status":1,"Total":4693998,"Description":"{12}","Extra":"{{\\"Amount\\":50000,\\"Method\\":{{\\"Id\\":\\"Cash\\",\\"Label\\":\\"Tiền mặt\\"}},\\"activeCustomerGroupId\\":null,\\"ResetPromotion\\":false}}","Surcharge":0,"Type":2,"Uuid":"","addToAccount":"0","PayingAmount":50000,"TotalBeforeDiscount":5813001,"ProductDiscount":290650,"CreatedBy":441968,"CreatedDate":"","InvoiceWarranties":[]}}}}     ${get_order_id}   ${BRANCH_ID}    ${get_id_nguoitao}    ${get_id_kh}    ${get_id_nguoiban}
    ...    ${order_code}   ${result_ggdh}    ${giamgia_dh}    ${liststring_prs_order_detail}   ${get_payment_id}   ${get_khachdatra_in_dh_bf_execute}   ${actual_khtt}    ${input_ghichu}
    Log    ${request_payload}
    ${order_code}    Post request to create order and return code    ${request_payload}
    #get values
    Sleep    20 s    wait for response to API
    Return From Keyword    ${order_code}

Update order by delete lodate product
    [Arguments]     ${order_code}    ${list_product_del}    ${input_ma_kh}    ${list_ggsp}   ${list_discount_type}    ${input_ggdh}   ${result_ggdh}   ${actual_khtt}    ${input_ghichu}
    ${get_list_hh_in_dh_bf_execute}   Get list product frm API    ${order_code}
    #remove hang hoa trong list
    : FOR    ${ma_hh}   IN     @{list_product_del}
    \    Remove Values From List    ${get_list_hh_in_dh_bf_execute}    ${ma_hh}
    #
    ${get_list_order_detail_id}   Get list orderdetail id frm order api    ${order_code}    ${get_list_hh_in_dh_bf_execute}
    ${list_soluong_in_dh}    ${list_tong_dh}    Get list quantity - order summary frm API    ${order_code}    ${get_list_hh_in_dh_bf_execute}
    ${get_khachdatra_in_dh_bf_execute}    ${get_tongtienhang_in_dh_bf_execute}    Get paid value frm API    ${order_code}
    #delete product by post API
    ${get_order_id}   ${get_payment_id}   Get order - payment frm order api    ${order_code}
    ${get_list_order_detail_id}   Get list orderdetail id frm order api    ${order_code}    ${get_list_hh_in_dh_bf_execute}
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${jsonpath_id_kh}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_kh}
    ${get_id_kh}    Get data from API    ${endpoint_khachhang}    ${jsonpath_id_kh}
    ${endpoint_danhmuc_hh_co_dvt}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${get_resp_danhmuc_hh}    Get Request and return body    ${endpoint_danhmuc_hh_co_dvt}
    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}    Get list jsonpath product frm list product    ${get_list_hh_in_dh_bf_execute}
    ${list_giaban}    ${list_result_ggsp}    ${list_id_sp}    Get product info frm list jsonpath product incase discount product    ${get_resp_danhmuc_hh}    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}
    ...    ${list_ggsp}   ${list_discount_type}
    ${liststring_prs_order_detail}     Set Variable      needdel
    Log        ${liststring_prs_order_detail}
    : FOR    ${item_result_ggsp}   ${item_ggsp}  ${item_orderdetail_id}    ${item_gia_ban}   ${item_id_sp}   ${item_soluong}      IN ZIP       ${list_result_ggsp}       ${list_ggsp}      ${get_list_order_detail_id}       ${list_giaban}        ${list_id_sp}    ${list_soluong_in_dh}
    \     ${item_ggsp}    Set Variable If    0 < ${item_ggsp} < 100    ${item_ggsp}     0
    \    ${payload_each_product}        Format string       {{"BasePrice":1000000,"Discount":{0},"DiscountRatio":{1},"Id":{2},"IsLotSerialControl":false,"IsRewardPoint":false,"Note":"","Price":{3},"ProductCode":"Combo39","ProductId":{4},"ProductName":"Bộ mỹ phẩm 09","Quantity":{5},"Uuid":"","ProductBatchExpireId":null}}       ${item_result_ggsp}   ${item_ggsp}  ${item_orderdetail_id}    ${item_gia_ban}   ${item_id_sp}   ${item_soluong}
    \    ${liststring_prs_order_detail}       Catenate      SEPARATOR=,      ${liststring_prs_order_detail}      ${payload_each_product}
    ${liststring_prs_order_detail}       Replace String      ${liststring_prs_order_detail}       needdel,       ${EMPTY}      count=1
    ${giamgia_dh}    Set Variable If    0 < ${input_ggdh} < 100    ${input_ggdh}    0
    ${request_payload}    Format String    {{"Order":{{"Id":{0},"BranchId":{1},"RetailerId":{2},"CustomerId":{3},"SoldById":{4},"SoldBy":{{"CreatedBy":0,"CreatedDate":"2018-12-10T10:44:15.970Z","Email":"","GivenName":"admin","Id":{4},"IsActive":true,"IsAdmin":true,"Type":0,"UserName":"admin","isDeleted":false,"Name":"admin"}},"SaleChannelId":0,"SaleChannel":null,"Seller":{{"CreatedBy":0,"CreatedDate":"2018-12-10T10:44:15.970Z","Email":"","GivenName":"admin","Id":{4},"IsActive":true,"IsAdmin":true,"Type":0,"UserName":"admin","isDeleted":false,"Name":"admin"}},"PurchaseDate":"","Code":"{5}","Discount":{6},"DiscountRatio":{7},"OrderDetails":[{8}],"InvoiceOrderSurcharges":[],"Payments":[{{"OrderValue":0,"DocumentValue":0,"PaidValue":0,"NeedPayValue":0,"CustomerName":"","CustomerCode":"","InvoiceCode":"","CustomerDebt":0,"CustomerOldDebt":0,"TargetCode":"","UserName":"","VoucherCampaignId":0,"Version":0,"TransGuid":"00000000000000000000000000000000","DocumentTypeValue":0,"Id":{9},"Code":"TTDH001090","Amount":{10},"AmountOriginal":0,"Method":"Cash","CreatedDate":"","CreatedBy":{4},"RetailerId":{2},"BranchId":{1},"OrderId":{0},"CustomerId":{3},"TransDate":"","UserId":{4},"Status":0,"System":false,"DeliveryPayments":[],"PaymentAllocation":[]}},{{"Method":"Cash","MethodStr":"Tiền mặt","Amount":{11},"Id":-2}}],"UsingCod":0,"Status":1,"Total":3856000,"Description":"{12}","Extra":"{{\\"Amount\\":3846000,\\"Method\\":{{\\"Id\\":\\"Cash\\",\\"Label\\":\\"Tiền mặt\\"}},\\"activeCustomerGroupId\\":null,\\"ResetPromotion\\":false}}","Surcharge":0,"Type":2,"Uuid":"","addToAccount":"0","PayingAmount":3846000,"TotalBeforeDiscount":3967000,"ProductDiscount":111000,"CreatedBy":160324,"CreatedDate":"","InvoiceWarranties":[]}}}}     ${get_order_id}   ${BRANCH_ID}    ${get_id_nguoitao}    ${get_id_kh}    ${get_id_nguoiban}
    ...    ${order_code}   ${result_ggdh}    ${giamgia_dh}    ${liststring_prs_order_detail}    ${get_payment_id}    ${get_khachdatra_in_dh_bf_execute}    ${actual_khtt}   ${input_ghichu}
    Log    ${request_payload}
    ${order_code}    Post request to create order and return code    ${request_payload}
    #get values
    Sleep    20 s    wait for response to API
    Return From Keyword      ${order_code}
