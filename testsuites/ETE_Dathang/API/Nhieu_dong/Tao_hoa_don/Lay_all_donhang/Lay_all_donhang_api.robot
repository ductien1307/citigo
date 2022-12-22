*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    ${headless_browser}
Test Setup
Test Teardown     After Test
Library           SeleniumLibrary
Resource          ../../../../../../core/API/api_danhmuc_hanghoa.robot
Resource          ../../../../../../core/API/api_dathang.robot
Resource          ../../../../../../core/API/api_khachhang.robot
Resource          ../../../../../../core/API/api_mhbh.robot
Resource          ../../../../../../core/Dat_Hang/dat_hang_action.robot
Resource          ../../../../../../core/Dat_Hang/dat_hang_navigation.robot
Resource          ../../../../../../core/Dat_Hang/dat_hang_page.robot
Resource          ../../../../../../core/Ban_Hang/banhang_action.robot
Resource          ../../../../../../core/Ban_Hang/banhang_page.robot
Resource          ../../../../../../core/Ban_Hang/banhang_navigation.robot
Resource          ../../../../../../core/share/toast_message.robot
Resource          ../../../../../../core/API/api_soquy.robot
Resource          ../../../../../../core/share/javascript.robot
Resource          ../../../../../../core/share/list_dictionary.robot
Resource          ../../../../../../core/share/discount.robot
Resource          ../../../../../../core/API/api_mhbh_dathang.robot
Resource          ../../../../../../core/API/api_hoadon_banhang.robot
Resource          ../../../../../../core/share/imei.robot

*** Variables ***
&{list_product1}    HH0018=4.75    DVT17=2.5    DV018=1    Combo18=1.5    SI018=1
&{list_product2}    HH0019=4.75    DVT18=2.5    DV019=1    Combo19=1.5    SI019=1
&{list_product3}    HH0020=4.75    QDKL019=2.5    DV020=1    Combo20=1.5    SI020=1
&{list_product4}    HH0021=4.75    DVT20=2.5    DV021=1    Combo21=1.5    SI021=1
&{list_product5}   DVT21=1
@{discount}           14         0     1000     5000    320000
@{discount_type}      dis     none     disvnd    changedown    changeup
@{list_soluong_addrow}   2      1       3.5,2.75     5,3,4        1,2
@{discount_addrow}   590000     3200000.55        15,5000      10,0,50000.1         0,350000
@{discount_type_addrow}  changedown    changeup     dis,disvnd   dis,none,changedown    none,changeup

*** Test Cases ***    Mã KH         List product&nums    List nums add row             GGSP add row       List type discount add row      Khách TT
Create_order          [Template]    Add new order incase discount - payment
                      [Tags]      AEDXM2
                      CTKH031       0                ${list_product1}           ${discount}           ${discount_type}      all
                      CTKH032       20               ${list_product2}           ${discount}           ${discount_type}      500000
                      CTKH033       15000            ${list_product3}           ${discount}           ${discount_type}      all

Them_dong              [Tags]     AEDXM2
                      [Template]    etedh_taohoadon01
                      CTKH031       ${list_soluong_addrow}    ${discount_addrow}     ${discount_type_addrow}    ${discount}       ${discount_type}     all
                      CTKH032       ${list_soluong_addrow}    ${discount_addrow}     ${discount_type_addrow}    ${discount}      ${discount_type}     500000
                      CTKH033       ${list_soluong_addrow}    ${discount_addrow}     ${discount_type_addrow}    ${discount}       ${discount_type}     0

Them_dong              [Tags]     AEDXM2
                      [Template]    etedh_taohoadon02
                      CTKH034       ${list_product1}    500000     ${discount}    ${discount_type}    ${list_soluong_addrow}    ${discount_addrow}     ${discount_type_addrow}      15          0

Them_50_dong              [Tags]    AEDXM2
                      [Template]    etedh_taohoadon03
                      CTKH007        ${list_product5}   DVT21     1   all     50000     1000000

*** Keywords ***
etedh_taohoadon01
    [Arguments]    ${input_ma_kh}    ${list_nums_addrow}   ${list_discount_addrow}   ${list_type_discount_addrow}   ${list_ggsp}    ${list_discount_type}    ${input_khtt}
    [Documentation]    1. Get thông tin của khách hàng và product (dòng 2 -7)
    ...    2. Lấy ra tổng đặt hàng và tồn kho của từng sản phẩm, tính toán
    Set Selenium Speed    0.5s
    #get info product, customer
    ${list_nums_addrow}   ${list_discount_addrow}    ${list_type_discount_addrow}   Convert three string list to composite list    ${list_nums_addrow}    ${list_discount_addrow}
    ...    ${list_type_discount_addrow}
    ${order_code}    ${get_khachdatra_in_dh_bf_execute}    ${get_ggdh_in_dh_bf_execute}    ${get_tongtienhang_in_dh_bf_execute}    ${get_tongcong_in_dh_bf_execute}    Get order code - paid - discount value frm API    ${input_ma_kh}
    ${get_list_hh_in_dh_bf_execute}    ${get_ghichu_bf_execute}   Get ghi chu and list product frm API    ${order_code}
    ${get_list_nums_in_dh}    Get list quantity by order code    ${order_code}    ${get_list_hh_in_dh_bf_execute}
    ${get_list_order_summary}   Get list order summary frm product API    ${get_list_hh_in_dh_bf_execute}
    ${list_result_tongdh}    Get list order summary after create invoice    ${get_list_order_summary}    ${get_list_nums_in_dh}
    ${list_nums}    ${list_discount}    ${list_type_discount}    Add value into three composite list    ${list_nums_addrow}   ${list_discount_addrow}    ${list_type_discount_addrow}
    ...    ${get_list_nums_in_dh}    ${list_ggsp}    ${list_discount_type}
    ${get_list_status}    Get list imei status thr API    ${get_list_hh_in_dh_bf_execute}
    ${list_imei_inlist}   Create list imei incase other product have multi row    ${get_list_hh_in_dh_bf_execute}    ${list_nums}    ${get_list_status}
    ${list_giatri_quydoi}    Get list gia tri quy doi frm product API    ${get_list_hh_in_dh_bf_execute}
    ${result_list_thanhtien}      ${list_result_toncuoi}    ${list_result_soluong}   Get list total sale - ending stock - total quantity incase catenate value all product    ${get_list_hh_in_dh_bf_execute}    ${list_nums}
    ...    ${list_giatri_quydoi}    ${list_discount}    ${list_type_discount}
    #compute invoice info
    ${result_tongtienhang}    Sum values in list    ${result_list_thanhtien}
    ${result_tongsoluong}    Sum values in list    ${get_list_nums_in_dh}
    ${result_TTH_tru_ggdh}    Run Keyword If    0 < ${get_ggdh_in_dh_bf_execute} < 100    Price after % discount invoice    ${result_tongtienhang}    ${get_ggdh_in_dh_bf_execute}
    ...    ELSE IF    ${get_ggdh_in_dh_bf_execute} > 100    Minus and replace floating point    ${result_tongtienhang}    ${get_ggdh_in_dh_bf_execute}
    ...    ELSE    Set Variable    ${result_tongtienhang}
    ${result_gghd}    Run Keyword If    0 < ${get_ggdh_in_dh_bf_execute} < 100    Convert % discount to VND and round    ${result_tongtienhang}    ${get_ggdh_in_dh_bf_execute}
    ...    ELSE    Set Variable    ${get_ggdh_in_dh_bf_execute}
    ${result_khachcantra}    Minus and replace floating point    ${result_TTH_tru_ggdh}    ${get_khachdatra_in_dh_bf_execute}
    ${actual_khtt_all}    Set Variable If    '${input_khtt}' == 'all'    ${result_khachcantra}    ${input_khtt}
    ${actual_khtt}    Set Variable If    '${input_khtt}' == '0'    0    ${actual_khtt_all}
    #compute order info
    ${actual_khtt_paymented}    Sum and replace floating point    ${actual_khtt}    ${get_khachdatra_in_dh_bf_execute}
    #create invoice frm Order
    ${get_order_id}   ${get_payment_id}   Get order - payment frm order api    ${order_code}
    ${get_list_order_detail_id}   Get list orderdetail id frm order api    ${order_code}    ${get_list_hh_in_dh_bf_execute}
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${jsonpath_id_kh}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_kh}
    ${get_id_kh}    Get data from API    ${endpoint_khachhang}    ${jsonpath_id_kh}
    ${endpoint_danhmuc_hh_co_dvt}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${get_resp_danhmuc_hh}    Get Request and return body    ${endpoint_danhmuc_hh_co_dvt}
    #get list string
    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}    Get list jsonpath product frm list product    ${get_list_hh_in_dh_bf_execute}
    ${list_giaban}    ${list_result_ggsp}    ${list_id_sp}    Get product info frm multi row jsonpath product have discount product    ${get_resp_danhmuc_hh}    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}
    ...    ${list_discount}    ${list_type_discount}
    ${liststring_prs_order_detail}     Create List
    : FOR    ${item_gia_ban}   ${item_id_sp}   ${item_soluong}    ${item_result_ggsp}   ${item_ggsp}    ${item_orderdetail_id}    ${imei_status}    ${imei_inlist}      IN ZIP       ${list_giaban}
    ...   ${list_id_sp}    ${list_nums}   ${list_result_ggsp}   ${list_discount}    ${get_list_order_detail_id}    ${get_list_status}     ${list_imei_inlist}
    \    ${liststring_prs_order_detail}    Run Keyword If   ${imei_status} == 0     Get payload product incase process order    ${item_gia_ban}    ${item_id_sp}   ${item_soluong}
    \    ...    ${item_result_ggsp}   ${item_ggsp}    ${item_orderdetail_id}    ${liststring_prs_order_detail}    ELSE      Get payload product incase process order have imei        ${item_gia_ban}    ${item_id_sp}   ${item_soluong}
    \    ...    ${item_result_ggsp}   ${item_ggsp}    ${item_orderdetail_id}    ${imei_inlist}    ${imei_status}    ${liststring_prs_order_detail}
    ${liststring_prs_order_detail}    Convert List to String    ${liststring_prs_order_detail}
    Log     ${liststring_prs_order_detail}
    ${giamgia_dh}    Set Variable If    0 < ${get_ggdh_in_dh_bf_execute} < 100    ${get_ggdh_in_dh_bf_execute}    0
    #payload
    ${request_payload}    Format String    {{"Invoice":{{"BranchId":{0},"RetailerId":{1},"OrderId":{2},"UpdateInvoiceId":0,"UpdateReturnId":0,"CustomerId":{3},"SoldById":{4},"SoldBy":{{"CreatedBy":0,"CreatedDate":"2018-07-30T08:27:36.800Z","GivenName":"anh.lv","Id":{4},"IsActive":true,"IsAdmin":true,"Type":0,"isDeleted":false,"Name":"anh.lv"}},"SaleChannelId":0,"Seller":{{"CreatedBy":0,"CreatedDate":"2018-07-30T08:27:36.800Z","GivenName":"anh.lv","Id":{4},"IsActive":true,"IsAdmin":true,"Type":0,"isDeleted":false,"Name":"anh.lv"}},"PriceBookId":0,"OrderCode":"{5}","Code":"Hóa đơn 2","Discount":{6},"DiscountRatio":{7},"InvoiceDetails":[{8}],"InvoiceOrderSurcharges":[],"InvoicePromotions":[],"Payments":[{{"Method":"Cash","MethodStr":"Tiền mặt","Amount":{9},"Id":-1}}],"Status":1,"Total":{10},"Surcharge":0,"Type":1,"Uuid":"","addToAccount":"0","PayingAmount":{9},"OrderPaidAmount":0,"TotalBeforeDiscount":{11},"ProductDiscount":136999,"PaidAmount":0,"DebugUuid":"","InvoiceWarranties":[],"CreatedBy":201567}}}}     ${BRANCH_ID}    ${get_id_nguoitao}    ${get_order_id}    ${get_id_kh}    ${get_id_nguoiban}
    ...   ${order_code}     ${result_gghd}    ${giamgia_dh}    ${liststring_prs_order_detail}    ${actual_khtt}   ${result_TTH_tru_ggdh}   ${result_tongtienhang}
    Log    ${request_payload}
    ${invoice_code}    Post request to create invoice and get invoice code    ${request_payload}
    Sleep    20 s    wait for response to API
    #assert value product in invoice
    : FOR    ${ma_hh}    ${result_toncuoi}    ${item_soluong}    ${get_giatri_quydoi}    IN ZIP    ${get_list_hh_in_dh_bf_execute}    ${list_result_toncuoi}    ${list_result_soluong}    ${list_giatri_quydoi}
    \    Run Keyword If    '${get_giatri_quydoi}' == '1'    Validate product history frm API    ${invoice_code}    ${ma_hh}    ${result_toncuoi}    ${item_soluong}
    \    ...    ELSE    Validate unit product history frm API    ${invoice_code}    ${ma_hh}    ${result_toncuoi}   ${item_soluong}    ${get_giatri_quydoi}
    #validate product
    ${list_order_summary_af_execute}    Get list order summary frm product API    ${get_list_hh_in_dh_bf_execute}
    : FOR    ${result_tong_dh}    ${order_summary_af_execute}    IN ZIP    ${list_result_tongdh}    ${list_order_summary_af_execute}
    \    Should Be Equal As Numbers    ${order_summary_af_execute}    ${result_tong_dh}
    #assert value invoice
    ${get_ma_kh_by_hd}    ${get_tong_tien_hang}    ${get_khachtt_af_execute}    ${get_gghd_af_execute}    ${get_khachcantra}    ${get_trangthai}    ${get_ghichu_in_hd_af_execute}
    ...    Get invoice info have note incase discount by invoice code    ${invoice_code}
    Run Keyword If    ${get_ggdh_in_dh_bf_execute} == 0    Should Be Equal As Numbers    ${get_khachcantra}    ${result_tongtienhang}
    ...    ELSE    Should Be Equal As Numbers    ${get_tong_tien_hang}    ${result_tongtienhang}
    Run Keyword If    ${get_ggdh_in_dh_bf_execute} == 0    Log    Ignore validate
    ...    ELSE    Should Be Equal As Numbers    ${get_tong_tien_hang}    ${result_tongtienhang}
    Should Be Equal As Numbers    ${get_khachcantra}    ${result_TTH_tru_ggdh}
    Should Be Equal As Numbers    ${get_khachtt_af_execute}    ${actual_khtt_paymented}
    Should Be Equal As Strings    ${get_ma_kh_by_hd}    ${input_ma_kh}
    Should Be Equal As Numbers    ${get_gghd_af_execute}    ${result_gghd}
    Should Be Equal As Strings    ${get_trangthai}    Hoàn thành
    Should Be Equal As Strings    ${get_ghichu_in_hd_af_execute}    ${get_ghichu_bf_execute}
    #assert value order
    ${get_ma_kh_in_dh_af_execute}    ${get_TTDH_in_dh_af_execute}    ${get_tongtienhang_in_dh_af_exxecute}    ${get_khachdatra_in_dh_af_execute}    ${get_giamgia_in_dh_af_execute}    ${get_tongcong_in_dh_af_execute}    ${get_ghichu_in_dh_af_execute}
    ...    Get order info have note incase discount by order code    ${order_code}
    Should Be Equal As Strings    ${get_ma_kh_in_dh_af_execute}    ${input_ma_kh}
    Should Be Equal As Numbers    ${get_TTDH_in_dh_af_execute}    3    #trạng thái hoàn thành
    Should Be Equal As Numbers    ${get_tongtienhang_in_dh_af_exxecute}    ${get_tongtienhang_in_dh_bf_execute}
    Should Be Equal As Numbers    ${get_khachdatra_in_dh_af_execute}    ${actual_khtt_paymented}
    Should Be Equal As Numbers    ${get_giamgia_in_dh_af_execute}    ${get_ggdh_in_dh_bf_execute}
    Should Be Equal As Numbers    ${get_tongcong_in_dh_af_execute}    ${get_tongcong_in_dh_bf_execute}
    Should Be Equal As Strings    ${get_ghichu_in_dh_af_execute}    ${get_ghichu_bf_execute}
    Validate invoice history frm Order    ${order_code}    ${invoice_code}    ${result_TTH_tru_ggdh}
    Delete invoice by invoice code    ${invoice_code}
    Delete order frm Order code    ${order_code}

etedh_taohoadon02
    [Arguments]    ${input_ma_kh}   ${list_product_tocreate}    ${input_khtt_tocreate}    ${list_ggsp}   ${list_discount_type}    ${list_nums_addrow}
    ...   ${list_discount_addrow}   ${list_type_discount_addrow}    ${input_gghd}    ${input_khtt}
    #get info product, customer
    ${list_nums_addrow}   ${list_discount_addrow}    ${list_type_discount_addrow}   Convert three string list to composite list    ${list_nums_addrow}    ${list_discount_addrow}
    ...    ${list_type_discount_addrow}
    ${order_code}    Add new order with multi products    ${input_ma_kh}    ${list_product_tocreate}    ${input_khtt_tocreate}
    ${get_khachdatra_in_dh_bf_execute}    ${get_tongtienhang_in_dh_bf_execute}    Get paid value frm API    ${order_code}
    ${get_list_hh_in_dh_bf_execute}    ${get_ghichu_bf_execute}   Get ghi chu and list product frm API    ${order_code}
    ${get_no_bf_execute}    ${get_tongban_bf_execute}    ${get_tongban_tru_trahang_bf_execute}    Get Customer Debt from API    ${input_ma_kh}
    ${get_list_nums_in_dh}    Get list quantity by order code    ${order_code}    ${get_list_hh_in_dh_bf_execute}
    ${get_list_order_summary}   Get list order summary frm product API    ${get_list_hh_in_dh_bf_execute}
    ${list_result_tongdh}    Get list order summary after create invoice    ${get_list_order_summary}    ${get_list_nums_in_dh}
    ${list_nums}    ${list_discount}    ${list_type_discount}    Add value into three composite list    ${list_nums_addrow}   ${list_discount_addrow}    ${list_type_discount_addrow}
    ...    ${get_list_nums_in_dh}    ${list_ggsp}    ${list_discount_type}
    ${get_list_status}    Get list imei status thr API    ${get_list_hh_in_dh_bf_execute}
    ${list_imei_inlist}   Create list imei incase other product have multi row    ${get_list_hh_in_dh_bf_execute}    ${list_nums}    ${get_list_status}
    ${list_giatri_quydoi}    Get list gia tri quy doi frm product API    ${get_list_hh_in_dh_bf_execute}
    ${result_list_thanhtien}      ${list_result_toncuoi}    ${list_result_soluong}   Get list total sale - ending stock - total quantity incase catenate value all product    ${get_list_hh_in_dh_bf_execute}    ${list_nums}
    ...    ${list_giatri_quydoi}    ${list_discount}    ${list_type_discount}
    #compute TTH with product
    ${result_tongtienhang}    Sum values in list    ${result_list_thanhtien}
    ${result_tongsoluong}    Sum values in list    ${get_list_nums_in_dh}
    ${result_TTH_tru_gghd}    Run Keyword If    0 < ${input_gghd} < 100    Price after % discount invoice    ${result_tongtienhang}    ${input_gghd}
    ...    ELSE IF    ${input_gghd} > 100    Minus and replace floating point    ${result_tongtienhang}    ${input_gghd}
    ...    ELSE    Set Variable    ${result_tongtienhang}
    ${result_gghd}    Run Keyword If    0 < ${input_gghd} < 100    Convert % discount to VND and round    ${result_tongtienhang}    ${input_gghd}
    ...    ELSE    Set Variable    ${input_gghd}
    ${result_khachcantra_in_hd}    Minus and replace floating point    ${result_TTH_tru_gghd}    ${get_khachdatra_in_dh_bf_execute}
    ${actual_khcantra_all}    Set Variable If    '${input_khtt}' == 'all'    ${result_khachcantra_in_hd}    ${input_khtt}
    ${actual_khachcantra}    Set Variable If    '${input_khtt}' == '0'    0    ${actual_khcantra_all}
    #compute invoice info to Quan ly
    ${result_khtt}    Run Keyword If    '${input_khtt}' != 'all'    Sum    ${input_khtt}    ${get_khachdatra_in_dh_bf_execute}
    ${actual_khtt_in_hd}    Set Variable If    '${input_khtt}' == 'all'    ${result_TTH_tru_gghd}    ${result_khtt}
    #compute for order
    ${result_khachthanhtoan_in_dh}    Sum and round 2    ${get_khachdatra_in_dh_bf_execute}    ${actual_khachcantra}
    #compute for cong no KH
    ${result_du_no_hd_KH}    Sum    ${get_no_bf_execute}    ${result_TTH_tru_gghd}
    ${result_PTT_hd_KH}    Minus and replace floating point    ${result_du_no_hd_KH}    ${actual_khachcantra}
    ${result_tongban_KH}    Sum and replace floating point    ${result_TTH_tru_gghd}    ${get_tongban_bf_execute}
    #create invoice frm Order
    ${get_order_id}   ${get_payment_id}   Get order - payment frm order api    ${order_code}
    ${get_list_order_detail_id}   Get list orderdetail id frm order api    ${order_code}    ${get_list_hh_in_dh_bf_execute}
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${jsonpath_id_kh}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_kh}
    ${get_id_kh}    Get data from API    ${endpoint_khachhang}    ${jsonpath_id_kh}
    ${endpoint_danhmuc_hh_co_dvt}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${get_resp_danhmuc_hh}    Get Request and return body    ${endpoint_danhmuc_hh_co_dvt}
    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}    Get list jsonpath product frm list product    ${get_list_hh_in_dh_bf_execute}
    ${list_giaban}    ${list_result_ggsp}    ${list_id_sp}    Get product info frm multi row jsonpath product have discount product    ${get_resp_danhmuc_hh}    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}
    ...    ${list_discount}    ${list_type_discount}
    ${liststring_prs_order_detail}     Create List
    : FOR    ${item_gia_ban}   ${item_id_sp}   ${item_soluong}    ${item_result_ggsp}   ${item_ggsp}    ${item_orderdetail_id}    ${imei_status}    ${imei_inlist}      IN ZIP       ${list_giaban}
    ...   ${list_id_sp}    ${list_nums}   ${list_result_ggsp}   ${list_discount}    ${get_list_order_detail_id}    ${get_list_status}     ${list_imei_inlist}
    \    ${liststring_prs_order_detail}    Run Keyword If   ${imei_status} == 0     Get payload product incase process order    ${item_gia_ban}    ${item_id_sp}   ${item_soluong}
    \    ...    ${item_result_ggsp}   ${item_ggsp}    ${item_orderdetail_id}    ${liststring_prs_order_detail}    ELSE      Get payload product incase process order have imei        ${item_gia_ban}    ${item_id_sp}   ${item_soluong}
    \    ...    ${item_result_ggsp}   ${item_ggsp}    ${item_orderdetail_id}    ${imei_inlist}    ${imei_status}    ${liststring_prs_order_detail}
    ${liststring_prs_order_detail}    Convert List to String    ${liststring_prs_order_detail}
    Log     ${liststring_prs_order_detail}
    ${giamgia_hd}    Set Variable If    0 < ${input_gghd} < 100    ${input_gghd}    0
    ${request_payload}    Format String    {{"Invoice":{{"BranchId":{0},"RetailerId":{1},"OrderId":{2},"UpdateInvoiceId":0,"UpdateReturnId":0,"CustomerId":{3},"SoldById":{4},"SoldBy":{{"CreatedBy":0,"CreatedDate":"2018-07-30T08:27:36.800Z","Email":"","GivenName":"anh.lv","Id":{4},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false,"Name":"anh.lv"}},"SaleChannelId":0,"Seller":{{"CreatedBy":0,"CreatedDate":"2018-07-30T08:27:36.800Z","Email":"","GivenName":"anh.lv","Id":{4},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false,"Name":"anh.lv"}},"PriceBookId":0,"OrderCode":"{5}","Code":"Hóa đơn 2","Discount":{6},"DiscountRatio":{7},"InvoiceDetails":[{8}],"InvoiceOrderSurcharges":[],"InvoicePromotions":[],"Payments":[{{"Method":"Cash","MethodStr":"Tiền mặt","Amount":{9},"Id":-1}}],"Status":1,"Total":{10},"Surcharge":0,"Type":1,"Uuid":"","addToAccount":"0","PayingAmount":{9},"OrderPaidAmount":{11},"TotalBeforeDiscount":{12},"ProductDiscount":60800,"PaidAmount":2000000,"DebugUuid":"","InvoiceWarranties":[],"CreatedBy":201567}}}}     ${BRANCH_ID}    ${get_id_nguoitao}    ${get_order_id}    ${get_id_kh}    ${get_id_nguoiban}
    ...   ${order_code}     ${result_gghd}    ${giamgia_hd}    ${liststring_prs_order_detail}    ${actual_khachcantra}     ${result_TTH_tru_gghd}   ${get_khachdatra_in_dh_bf_execute}    ${result_tongtienhang}
    Log    ${request_payload}
    ${invoice_code}    Post request to create invoice and get invoice code    ${request_payload}
    Sleep    20 s    wait for response to API
    #assert value product in invoice
    : FOR    ${ma_hh}    ${result_toncuoi}    ${item_soluong}    ${get_giatri_quydoi}    IN ZIP    ${get_list_hh_in_dh_bf_execute}    ${list_result_toncuoi}    ${list_result_soluong}    ${list_giatri_quydoi}
    \    Run Keyword If    '${get_giatri_quydoi}' == '1'    Validate product history frm API    ${invoice_code}    ${ma_hh}    ${result_toncuoi}    ${item_soluong}
    \    ...    ELSE    Validate unit product history frm API    ${invoice_code}    ${ma_hh}    ${result_toncuoi}   ${item_soluong}    ${get_giatri_quydoi}
    #validate product
    ${list_order_summary_af_execute}    Get list order summary frm product API    ${get_list_hh_in_dh_bf_execute}
    : FOR    ${result_tong_dh}    ${order_summary_af_execute}    IN ZIP    ${list_result_tongdh}    ${list_order_summary_af_execute}
    \    Should Be Equal As Numbers    ${order_summary_af_execute}    ${result_tong_dh}
    #assert value invoice
    ${get_ma_kh_by_hd}    ${get_tong_tien_hang}    ${get_khachtt_af_execute}    ${get_gghd_af_execute}    ${get_khachcantra}    ${get_trangthai}    ${get_ghichu_in_hd_af_execute}
    ...    Get invoice info have note incase discount by invoice code    ${invoice_code}
    Run Keyword If    ${input_gghd} == 0    Should Be Equal As Numbers    ${get_khachcantra}    ${result_tongtienhang}
    ...    ELSE    Should Be Equal As Numbers    ${get_tong_tien_hang}    ${result_tongtienhang}
    Run Keyword If    ${input_gghd} == 0    Log    Ignore validate
    ...    ELSE    Should Be Equal As Numbers    ${get_tong_tien_hang}    ${result_tongtienhang}
    Should Be Equal As Numbers    ${get_khachcantra}    ${result_TTH_tru_gghd}
    Should Be Equal As Numbers    ${get_khachtt_af_execute}    ${actual_khtt_in_hd}
    Should Be Equal As Strings    ${get_ma_kh_by_hd}    ${input_ma_kh}
    Should Be Equal As Numbers    ${get_gghd_af_execute}    ${result_gghd}
    Should Be Equal As Strings    ${get_trangthai}    Hoàn thành
    Should Be Equal As Strings    ${get_ghichu_in_hd_af_execute}    ${get_ghichu_bf_execute}
    #assert value order
    ${get_ma_kh_in_dh_af_execute}    ${get_TTDH_in_dh_af_execute}    ${get_tongtienhang_in_dh_af_exxecute}    ${get_khachdatra_in_dh_af_execute}    ${get_ghichu_af_execute}    Get order info have note by order code    ${order_code}
    Should Be Equal As Strings    ${get_ma_kh_in_dh_af_execute}    ${input_ma_kh}
    Should Be Equal As Strings    ${get_TTDH_in_dh_af_execute}    3    #trạng thái hoàn thành
    Should Be Equal As Numbers    ${get_tongtienhang_in_dh_af_exxecute}    ${get_tongtienhang_in_dh_bf_execute}
    Should Be Equal As Numbers    ${get_khachdatra_in_dh_af_execute}    ${result_khachthanhtoan_in_dh}
    Should Be Equal As Strings    ${get_ghichu_af_execute}    ${get_ghichu_bf_execute}
    Validate invoice history frm Order    ${order_code}    ${invoice_code}    ${result_TTH_tru_gghd}
    #assert Customer
    ${get_no_af_execute_kh}    ${get_tongban_af_execute_kh}    ${get_tongban_tru_trahang_af_execute_kh}    Get Customer Debt from API after purchase    ${input_ma_kh}    ${invoice_code}    ${actual_khachcantra}
    Run Keyword If    '${input_khtt}' == '0'    Should Be Equal As Numbers    ${get_no_af_execute_kh}    ${result_du_no_hd_KH}
    ...    ELSE    Should Be Equal As Numbers    ${get_no_af_execute_kh}    ${result_PTT_hd_KH}
    Delete invoice by invoice code    ${invoice_code}
    Delete order frm Order code    ${order_code}

etedh_taohoadon03
    [Arguments]    ${input_ma_kh}   ${list_product_tocreate}    ${input_product}    ${input_soluong}    ${input_khtt_tocreate}    ${input_gghd}    ${input_khtt}
    Set Selenium Speed    0.1s
    #get info product, customer
    ${order_code}    Add new order with multi products    ${input_ma_kh}    ${list_product_tocreate}    ${input_khtt_tocreate}
    ${get_khachdatra_in_dh_bf_execute}    ${get_tongtienhang_in_dh_bf_execute}    Get paid value frm API    ${order_code}
    ${get_list_hh_in_dh_bf_execute}    ${get_ghichu_bf_execute}   Get ghi chu and list product frm API    ${order_code}
    ${get_list_nums_in_dh}    Get list quantity by order code    ${order_code}    ${get_list_hh_in_dh_bf_execute}
    ${get_no_bf_execute}    ${get_tongban_bf_execute}    ${get_tongban_tru_trahang_bf_execute}    Get Customer Debt from API    ${input_ma_kh}
    #get order summary and sub total of products
    ${list_result_thanhtien}    Create List
    ${list_result_tongso_dh}    Create List
    ${list_thanhtien_addrow}    Create List
    ${list_result_toncuoi}    Create List
    ${list_result_tongsoluong}    Create List
    ${get_list_baseprice}   ${get_list_order_summary}   Get list base price and order summary frm product API    ${get_list_hh_in_dh_bf_execute}
    ${get_list_product_type}    ${list_tonkho_service}    Get list product type and ending stock of service frm API    ${get_list_hh_in_dh_bf_execute}
    :FOR      ${item_soluong}   ${item_giaban}    ${item_tong_dh}   ${get_onhand}   IN ZIP    ${get_list_nums_in_dh}     ${get_list_baseprice}   ${get_list_order_summary}    ${list_tonkho_service}
    \   ${result_tongso_dh}    Minus   ${item_tong_dh}    ${item_soluong}
    \   ${result_thanhtien}    Multiplication and round    ${item_giaban}    ${item_soluong}
    \   ${result_thanhtien_addrow}    Multiplication and round    ${item_giaban}    50
    \   ${result_toncuoi}   Minusx3 and replace foating point   ${get_onhand}    ${item_soluong}    50
    \   ${result_tongsoluong}   Sum   ${item_soluong}    50
    \   Append To List    ${list_result_thanhtien}   ${result_thanhtien}
    \   Append To List    ${list_result_tongso_dh}   ${result_tongso_dh}
    \   Append To List    ${list_thanhtien_addrow}   ${result_thanhtien_addrow}
    \   Append To List    ${list_result_toncuoi}   ${result_toncuoi}
    \   Append To List    ${list_result_tongsoluong}   ${result_tongsoluong}
    ${list_giatri_quydoi}    Get list gia tri quy doi frm product API    ${get_list_hh_in_dh_bf_execute}
    #compute TTH with product
    ${result_tongtienhang}    Sum values in list    ${list_result_thanhtien}
    ${result_tongsoluong}    Sum values in list    ${get_list_nums_in_dh}
    ${result_tongtienhang_addrow}    Sum values in list    ${list_thanhtien_addrow}
    ${result_tongtienhang}    Sum and round    ${result_tongtienhang}       ${result_tongtienhang_addrow}
    ${result_TTH_tru_gghd}    Run Keyword If    0 < ${input_gghd} < 100    Price after % discount invoice    ${result_tongtienhang}    ${input_gghd}
    ...    ELSE IF    ${input_gghd} > 100    Minus and replace floating point    ${result_tongtienhang}    ${input_gghd}
    ...    ELSE    Set Variable    ${result_tongtienhang}
    ${result_gghd}    Run Keyword If    0 < ${input_gghd} < 100    Convert % discount to VND and round    ${result_tongtienhang}    ${input_gghd}
    ...    ELSE    Set Variable    ${input_gghd}
    ${result_khachcantra_in_hd}    Minus and replace floating point    ${result_TTH_tru_gghd}    ${get_khachdatra_in_dh_bf_execute}
    ${actual_khcantra_all}    Set Variable If    '${input_khtt}' == 'all'    ${result_khachcantra_in_hd}    ${input_khtt}
    ${actual_khachcantra}    Set Variable If    '${input_khtt}' == '0'    0    ${actual_khcantra_all}
    #compute invoice info to Quan ly
    ${result_khtt}    Run Keyword If    '${input_khtt}' != 'all'    Sum    ${input_khtt}    ${get_khachdatra_in_dh_bf_execute}
    ${actual_khtt_in_hd}    Set Variable If    '${input_khtt}' == 'all'    ${result_TTH_tru_gghd}    ${result_khtt}
    #compute for order
    ${result_khachthanhtoan_in_dh}    Sum and round 2    ${get_khachdatra_in_dh_bf_execute}    ${actual_khachcantra}
    #compute for cong no KH
    ${result_du_no_hd_KH}    Sum    ${get_no_bf_execute}    ${result_TTH_tru_gghd}
    ${result_PTT_hd_KH}    Minus and replace floating point    ${result_du_no_hd_KH}    ${actual_khachcantra}
    ${result_tongban_KH}    Sum and replace floating point    ${result_TTH_tru_gghd}    ${get_tongban_bf_execute}
    #create invoice from order
    ${get_order_id}   ${get_payment_id}   Get order - payment frm order api    ${order_code}
    ${get_order_detail_id}   Get orderdetail id frm order api    ${order_code}    ${input_product}
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${jsonpath_id_kh}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_kh}
    ${get_id_kh}    Get data from API    ${endpoint_khachhang}    ${jsonpath_id_kh}
    ${endpoint_danhmuc_hh_co_dvt}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${get_resp_danhmuc_hh}    Get Request and return body    ${endpoint_danhmuc_hh_co_dvt}
    ${id_product}   Get product id thr API    ${input_product}
    #get list string
    ${liststring_prs_order_detail}     Set Variable      needdel
    Log        ${liststring_prs_order_detail}
    : FOR    ${item}      IN RANGE      51
    \    ${payload_each_product}        Format string           {{"BasePrice":{0},"IsLotSerialControl":false,"IsRewardPoint":false,"Note":"","Price":{0},"ProductId":{1},"Quantity":{2},"ProductCode":"DV008","Discount":0,"DiscountRatio":0,"ProductName":"Nhuộm tóc - Loreal","OriginPrice":{0},"PriceByPromotion":null,"IsMaster":true,"PromotionParentProductId":null,"ProductBatchExpireId":null,"CategoryId":794172,"MasterProductId":{1},"Unit":"","Uuid":"","OrderDetailId":{3},"ProductWarranty":[]}}    ${item_giaban}   ${id_product}   ${input_soluong}    ${get_order_detail_id}
    \    ${liststring_prs_order_detail}       Catenate      SEPARATOR=,      ${liststring_prs_order_detail}      ${payload_each_product}
    ${liststring_prs_order_detail}       Replace String      ${liststring_prs_order_detail}       needdel,       ${EMPTY}      count=1
    Log    ${liststring_prs_order_detail}
    ${giamgia_hd}    Set Variable If    0 < ${input_gghd} < 100    ${input_gghd}    0
    #payload
    ${request_payload}    Format String    {{"Invoice":{{"BranchId":{0},"RetailerId":{1},"OrderId":{2},"UpdateInvoiceId":0,"UpdateReturnId":0,"CustomerId":{3},"SoldById":{4},"SoldBy":{{"CreatedBy":0,"CreatedDate":"2018-07-30T08:27:36.800Z","Email":"","GivenName":"anh.lv","Id":{4},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false,"Name":"anh.lv"}},"SaleChannelId":0,"Seller":{{"CreatedBy":0,"CreatedDate":"2018-07-30T08:27:36.800Z","Email":"","GivenName":"anh.lv","Id":{4},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false,"Name":"anh.lv"}},"PriceBookId":0,"OrderCode":"{5}","Code":"Hóa đơn 2","Discount":{6},"DiscountRatio":{7},"InvoiceDetails":[{8}],"InvoiceOrderSurcharges":[],"InvoicePromotions":[],"Payments":[{{"Method":"Cash","MethodStr":"Tiền mặt","Amount":{9},"Id":-1}}],"Status":1,"Total":{10},"Surcharge":0,"Type":1,"Uuid":"","addToAccount":"0","PayingAmount":{9},"OrderPaidAmount":{11},"TotalBeforeDiscount":{12},"ProductDiscount":60800,"PaidAmount":2000000,"DebugUuid":"","InvoiceWarranties":[],"CreatedBy":201567}}}}     ${BRANCH_ID}    ${get_id_nguoitao}    ${get_order_id}    ${get_id_kh}    ${get_id_nguoiban}
    ...   ${order_code}     ${result_gghd}    ${giamgia_hd}    ${liststring_prs_order_detail}    ${actual_khachcantra}    ${result_TTH_tru_gghd}   ${get_khachdatra_in_dh_bf_execute}    ${result_tongtienhang}
    Log    ${request_payload}
    ${invoice_code}    Post request to create invoice and get invoice code    ${request_payload}
    #get value
    Sleep    20s    wait for response to API
    #assert value product in invoice
    : FOR    ${ma_hh}    ${result_toncuoi}    ${item_soluong}    ${get_giatri_quydoi}    IN ZIP    ${get_list_hh_in_dh_bf_execute}    ${list_result_toncuoi}    ${list_result_tongsoluong}    ${list_giatri_quydoi}
    \    Run Keyword If    '${get_giatri_quydoi}' == '1'    Validate product history frm API    ${invoice_code}    ${ma_hh}    ${result_toncuoi}
    \    ...    ${item_soluong}    ELSE    Validate unit product history frm API    ${invoice_code}    ${ma_hh}    ${result_toncuoi}    ${item_soluong}    ${get_giatri_quydoi}
    #validate product
    ${list_order_summary_af_execute}    Get list order summary frm product API    ${get_list_hh_in_dh_bf_execute}
    : FOR    ${result_tong_dh}    ${order_summary_af_execute}    IN ZIP    ${list_result_tongso_dh}    ${list_order_summary_af_execute}
    \    Should Be Equal As Numbers    ${order_summary_af_execute}    ${result_tong_dh}
    #assert value invoice
    ${get_ma_kh_by_hd}    ${get_tong_tien_hang}    ${get_khachtt_af_execute}    ${get_gghd_af_execute}    ${get_khachcantra}    ${get_trangthai}    ${get_ghichu_in_hd_af_execute}
    ...    Get invoice info have note incase discount by invoice code    ${invoice_code}
    Run Keyword If    ${input_gghd} == 0    Should Be Equal As Numbers    ${get_khachcantra}    ${result_tongtienhang}
    ...    ELSE    Should Be Equal As Numbers    ${get_tong_tien_hang}    ${result_tongtienhang}
    Run Keyword If    ${input_gghd} == 0    Log    Ignore validate
    ...    ELSE    Should Be Equal As Numbers    ${get_tong_tien_hang}    ${result_tongtienhang}
    Should Be Equal As Numbers    ${get_khachcantra}    ${result_TTH_tru_gghd}
    Should Be Equal As Numbers    ${get_khachtt_af_execute}    ${actual_khtt_in_hd}
    Should Be Equal As Strings    ${get_ma_kh_by_hd}    ${input_ma_kh}
    Should Be Equal As Numbers    ${get_gghd_af_execute}    ${result_gghd}
    Should Be Equal As Strings    ${get_trangthai}    Hoàn thành
    Should Be Equal As Strings    ${get_ghichu_in_hd_af_execute}    ${get_ghichu_bf_execute}
    #assert value order
    ${get_ma_kh_in_dh_af_execute}    ${get_TTDH_in_dh_af_execute}    ${get_tongtienhang_in_dh_af_exxecute}    ${get_khachdatra_in_dh_af_execute}    ${get_ghichu_af_execute}    Get order info have note by order code    ${order_code}
    Should Be Equal As Strings    ${get_ma_kh_in_dh_af_execute}    ${input_ma_kh}
    Should Be Equal As Strings    ${get_TTDH_in_dh_af_execute}    3    #trạng thái hoàn thành
    Should Be Equal As Numbers    ${get_tongtienhang_in_dh_af_exxecute}    ${get_tongtienhang_in_dh_bf_execute}
    Should Be Equal As Numbers    ${get_khachdatra_in_dh_af_execute}    ${result_khachthanhtoan_in_dh}
    Should Be Equal As Strings    ${get_ghichu_af_execute}    ${get_ghichu_bf_execute}
    Validate invoice history frm Order    ${order_code}    ${invoice_code}    ${result_TTH_tru_gghd}
    #assert Customer
    ${get_no_af_execute_kh}    ${get_tongban_af_execute_kh}    ${get_tongban_tru_trahang_af_execute_kh}    Get Customer Debt from API after purchase    ${input_ma_kh}    ${invoice_code}    ${actual_khachcantra}
    Run Keyword If    '${input_khtt}' == '0'    Should Be Equal As Numbers    ${get_no_af_execute_kh}    ${result_du_no_hd_KH}
    ...    ELSE    Should Be Equal As Numbers    ${get_no_af_execute_kh}    ${result_PTT_hd_KH}
    Delete invoice by invoice code    ${invoice_code}
    Delete order frm Order code    ${order_code}
