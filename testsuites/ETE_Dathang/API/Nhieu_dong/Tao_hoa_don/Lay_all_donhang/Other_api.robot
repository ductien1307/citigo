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
&{list_product6}    HH0022=4.75    DVT22=2.5    DVL010=1    Combo166=1.5    SI252=2
@{no_discount}           0    0    0    0   0
@{no_discount_type}      none    none    none    none       none
###
&{list_product7}    HH0023=4.75    DVT23=2.5    DVL011=1    Combo167=1.5    SI253=2
&{list_product8}   KLDV020=1
&{list_product_delete}    SI253=2
&{list_discount_delete}    SI253=0
&{list_discount_type_delete}    SI253=none
&{list_product_add}    HH0024=4.75    DVT24=2.5
@{discount}           20    20000.67    2500    2000   0
@{discount_type}      dis    changeup    disvnd    changedown       none
@{discount_new}   100000.55        15000
@{discount_type_new}  changeup     disvnd
@{list_soluong_addrow_new}   2      3.5,2.75
@{discount_addrow_new}   30000     10,0
@{discount_type_addrow_new}  changedown    dis,none
####
@{list_soluong_addrow}   2      1       3.5,2.75     5,3,4        1,2
@{discount_addrow}   590000     550000.55        15,1000      10,0,50000.1         0,350000
@{discount_type_addrow}  changedown    changeup     dis,disvnd   dis,none,changedown    none,changeup

*** Test Cases ***    Mã KH         List product&nums           Bảng giá    List nums add row             GGSP add row       List type discount add row      Khách TT
Thay_doi_bang_gia      [Tags]     AEDXM2
                      [Template]    etedh_taohoadon04
                      KHKM10       ${list_product6}           Bảng giá hóa đơn     ${list_soluong_addrow}    ${discount_addrow}     ${discount_type_addrow}      15          0     ${no_discount}   ${no_discount_type}

Add_product_order_1phan     [Tags]    AEDXM2
                      [Template]    etedh_taohoadon05
                      KHKM11   ${list_product7}    5000000     ${discount}   ${discount_type}     ${list_discount_delete}   ${list_discount_type_delete}    ${list_product_delete}    ${list_soluong_addrow}    ${discount_addrow}     ${discount_type_addrow}    10    200000     ${list_product_add}     ${discount_new}   ${discount_type_new}    ${list_soluong_addrow_new}    ${discount_addrow_new}     ${discount_type_addrow_new}

Add_product_all_order              [Tags]  AEDXM2
                      [Template]    etedh_taohoadon06
                      KHKM12        ${list_product8}   KLDV020   1   all   ${list_product_add}     50000     all

*** Keywords ***
etedh_taohoadon04
    [Arguments]    ${input_ma_kh}   ${list_product_tocreate}    ${input_ten_banggia}    ${list_nums_addrow}   ${list_discount_addrow}
    ...   ${list_type_discount_addrow}    ${input_gghd}    ${input_khtt}    ${list_ggsp}    ${list_discount_type}
    Set Selenium Speed    0.5s
    #get info product, customer
    ${list_nums_addrow}   ${list_discount_addrow}    ${list_type_discount_addrow}   Convert three string list to composite list    ${list_nums_addrow}    ${list_discount_addrow}
    ...    ${list_type_discount_addrow}
    ${order_code}    Add new order with multi product and no payment - get order code    ${input_ma_kh}    ${list_product_tocreate}
    ${get_khachdatra_in_dh_bf_execute}    ${get_tongtienhang_in_dh_bf_execute}    Get paid value frm API    ${order_code}
    ${get_list_hh_in_dh_bf_execute}    ${get_ghichu_bf_execute}   Get ghi chu and list product frm API    ${order_code}
    ${get_list_nums_in_dh}    Get list quantity by order code    ${order_code}    ${get_list_hh_in_dh_bf_execute}
    ${get_list_order_summary}   Get list order summary frm product API    ${get_list_hh_in_dh_bf_execute}
    ${list_result_tongdh}    Get list order summary after create invoice    ${get_list_order_summary}    ${get_list_nums_in_dh}
    ${get_no_bf_execute}    ${get_tongban_bf_execute}    ${get_tongban_tru_trahang_bf_execute}    Get Customer Debt from API    ${input_ma_kh}
    ${list_nums}    ${list_discount}    ${list_type_discount}    Add value into three composite list    ${list_nums_addrow}   ${list_discount_addrow}    ${list_type_discount_addrow}
    ...    ${get_list_nums_in_dh}    ${list_ggsp}    ${list_discount_type}
    ${get_list_status}    Get list imei status thr API    ${get_list_hh_in_dh_bf_execute}
    ${list_imei_inlist}   Create list imei incase other product have multi row    ${get_list_hh_in_dh_bf_execute}    ${list_nums}    ${get_list_status}
    ${list_giatri_quydoi}    Get list gia tri quy doi frm product API    ${get_list_hh_in_dh_bf_execute}
    ${list_result_toncuoi}   Create List
    ${list_result_soluong}   Create List
    ${result_list_thanhtien}    Create List
    ${list_result_ggsp}    Create List
    ${get_id_banggia}    ${list_giaban_in_banggia}    Get list gia ban from PriceBook api    ${input_ten_banggia}    ${get_list_hh_in_dh_bf_execute}
    ${list_toncuoi}    Get list onhand frm API    ${get_list_hh_in_dh_bf_execute}
    ${get_list_product_type}    ${list_tonkho_service}    Get list product type and ending stock of service frm API    ${get_list_hh_in_dh_bf_execute}
    :FOR    ${item_product}    ${item_toncuoi}     ${item_nums}     ${giatri_quydoi}   ${get_ton_dv_bf_execute}    ${get_product_type}    IN ZIP    ${get_list_hh_in_dh_bf_execute}    ${list_toncuoi}
    ...      ${list_nums}    ${list_giatri_quydoi}    ${list_tonkho_service}    ${get_list_product_type}
    \    ${result_soluong}   Sum values in list    ${item_nums}
    \    ${result_toncuoi}    Run Keyword If    '${giatri_quydoi}' == '1'    Computation and get list ending stock    ${item_toncuoi}    ${get_ton_dv_bf_execute}
    \    ...    ${result_soluong}    ${get_product_type}    ELSE    Computation and get list ending stock for unit product    ${item_product}    ${giatri_quydoi}    ${result_soluong}
    \     Append To List    ${list_result_toncuoi}    ${result_toncuoi}
    \     Append To List    ${list_result_soluong}    ${result_soluong}
    :FOR  ${item_giaban}      ${item_quantity}    ${item_gg_sp}    ${type_discount}   IN ZIP    ${list_giaban_in_banggia}   ${list_nums}   ${list_discount}    ${list_type_discount}
    \   ${list_result_thanhtien}    ${list_newprice}    Get list total sale incase add row product    ${item_giaban}   ${item_quantity}    ${item_gg_sp}    ${type_discount}
    \   ${result_ggsp}       Get list discount product incase multi row product    ${item_giaban}   ${item_gg_sp}    ${type_discount}
    \   Append to List     ${result_list_thanhtien}    ${list_result_thanhtien}
    \   Append to List     ${list_result_ggsp}    ${result_ggsp}
    ${result_list_thanhtien}    Convert String to List    ${result_list_thanhtien}
    #compute TTH with product
    ${result_tongtienhang}    Sum values in list    ${result_list_thanhtien}
    ${result_tongsoluong}    Sum values in list    ${get_list_nums_in_dh}
    ${result_TTH_tru_gghd}    Run Keyword If    0 < ${input_gghd} < 100    Price after % discount invoice    ${result_tongtienhang}    ${input_gghd}
    ...    ELSE IF    ${input_gghd} > 100    Minus and replace floating point    ${result_tongtienhang}    ${input_gghd}
    ...    ELSE    Set Variable    ${result_tongtienhang}
    ${result_gghd}    Run Keyword If    0 < ${input_gghd} < 100    Convert % discount to VND and round    ${result_tongtienhang}    ${input_gghd}
    ...    ELSE    Set Variable    ${input_gghd}
    ${result_khachcantra}    Minus and replace floating point    ${result_TTH_tru_gghd}    ${get_khachdatra_in_dh_bf_execute}
    ${actual_khtt_all}    Set Variable If    '${input_khtt}' == 'all'    ${result_khachcantra}    ${input_khtt}
    ${actual_khtt}    Set Variable If    '${input_khtt}' == '0'    0    ${actual_khtt_all}
    ${actual_khtt_paymented}    Sum and replace floating point    ${actual_khtt}    ${get_khachdatra_in_dh_bf_execute}
    #compute cong no KH
    ${result_du_no_hd_KH}    Sum    ${get_no_bf_execute}    ${result_TTH_tru_gghd}
    ${result_PTT_hd_KH}    Minus and replace floating point    ${result_du_no_hd_KH}    ${actual_khtt}
    ${result_tongban_KH}    Sum and replace floating point    ${result_TTH_tru_gghd}    ${get_tongban_bf_execute}
    #create invoice frm Order
    ${get_order_id}   ${get_payment_id}   Get order - payment frm order api    ${order_code}
    ${get_list_order_detail_id}   Get list orderdetail id frm order api    ${order_code}    ${get_list_hh_in_dh_bf_execute}
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${jsonpath_id_kh}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_kh}
    ${get_id_kh}    Get data from API    ${endpoint_khachhang}    ${jsonpath_id_kh}
    ${get_list_id_product}    Get list product id thr API    ${get_list_hh_in_dh_bf_execute}
    #get list string
    ${liststring_prs_order_detail}     Create List
    : FOR    ${item_gia_ban}   ${item_id_sp}   ${item_soluong}    ${item_result_ggsp}   ${item_ggsp}    ${item_orderdetail_id}    ${imei_status}    ${imei_inlist}      IN ZIP       ${list_giaban_in_banggia}
    ...   ${get_list_id_product}    ${list_nums}   ${list_result_ggsp}   ${list_discount}    ${get_list_order_detail_id}    ${get_list_status}     ${list_imei_inlist}
    \    ${liststring_prs_order_detail}    Run Keyword If   ${imei_status} == 0     Get payload product incase process order    ${item_gia_ban}    ${item_id_sp}   ${item_soluong}
    \    ...    ${item_result_ggsp}   ${item_ggsp}    ${item_orderdetail_id}    ${liststring_prs_order_detail}    ELSE      Get payload product incase process order have imei        ${item_gia_ban}    ${item_id_sp}   ${item_soluong}
    \    ...    ${item_result_ggsp}   ${item_ggsp}    ${item_orderdetail_id}    ${imei_inlist}    ${imei_status}    ${liststring_prs_order_detail}
    ${liststring_prs_order_detail}    Convert List to String    ${liststring_prs_order_detail}
    Log     ${liststring_prs_order_detail}
    ${giamgia_dh}    Set Variable If    0 < ${input_gghd} < 100    ${input_gghd}    0
    #payload
    ${request_payload}    Format String    {{"Invoice":{{"BranchId":{0},"RetailerId":{1},"OrderId":{2},"CustomerId":{3},"SoldById":{4},"SoldBy":{{"CreatedBy":0,"CreatedDate":"2018-12-10T10:44:15.970Z","Email":"","GivenName":"admin","Id":{4},"IsActive":true,"IsAdmin":true,"Type":0,"UserName":"admin","isDeleted":false,"Name":"admin"}},"SaleChannelId":0,"Seller":{{"CreatedBy":0,"CreatedDate":"2018-12-10T10:44:15.970Z","Email":"","GivenName":"admin","Id":{4},"IsActive":true,"IsAdmin":true,"Type":0,"UserName":"admin","isDeleted":false,"Name":"admin"}},"PriceBookId":{5},"OrderCode":"{6}","Code":"Hóa đơn 1","Discount":{7},"DiscountRatio":{8},"InvoiceDetails":[{9}],"InvoiceOrderSurcharges":[],"InvoicePromotions":[],"Payments":[{{"Method":"Cash","MethodStr":"Tiền mặt","Amount":{10},"Id":-1}}],"Status":1,"Total":{11},"Surcharge":0,"Type":1,"Uuid":"","addToAccount":"0","PayingAmount":{10},"OrderPaidAmount":0,"DepositReturn":0,"TotalBeforeDiscount":{12},"ProductDiscount":384000,"PaidAmount":1000000,"DebugUuid":"","InvoiceWarranties":[],"CreatedBy":201567}}}}     ${BRANCH_ID}    ${get_id_nguoitao}    ${get_order_id}    ${get_id_kh}    ${get_id_nguoiban}
    ...    ${get_id_banggia}   ${order_code}    ${result_gghd}     ${giamgia_dh}    ${liststring_prs_order_detail}   ${actual_khtt}   ${result_TTH_tru_gghd}     ${result_tongtienhang}
    Log    ${request_payload}
    ${invoice_code}    Post request to create invoice and get invoice code    ${request_payload}
    Sleep    20 s    wait for response to API
    #assert value product in invoice
    : FOR    ${ma_hh}    ${result_toncuoi}    ${item_soluong}    ${get_giatri_quydoi}    IN ZIP    ${get_list_hh_in_dh_bf_execute}    ${list_result_toncuoi}    ${list_result_soluong}    ${list_giatri_quydoi}
    \    Run Keyword If    '${get_giatri_quydoi}' == '1'    Validate product history frm API    ${invoice_code}    ${ma_hh}    ${result_toncuoi}    ${item_soluong}
    \    ...    ELSE    Validate unit product history frm API    ${invoice_code}    ${ma_hh}    ${result_toncuoi}   ${item_soluong}    ${get_giatri_quydoi}
    #validate product
    ${list_order_summary_af_execute}    Get list order summary frm product API    ${get_list_hh_in_dh_bf_execute}
    ${list_giaban_in_hd}    Get list price after change pricebook frm invoice API    ${get_list_hh_in_dh_bf_execute}    ${invoice_code}
    : FOR    ${result_tong_dh}    ${order_summary_af_execute}    ${get_giaban_in_hd}    ${giaban_new}    IN ZIP    ${list_result_tongdh}
    ...    ${list_order_summary_af_execute}    ${list_giaban_in_hd}    ${list_giaban_in_banggia}
    \    Should Be Equal As Numbers    ${order_summary_af_execute}    ${result_tong_dh}
    \    Should Be Equal As Numbers    ${get_giaban_in_hd}    ${giaban_new}
    #assert value invoice
    ${get_ma_kh_by_hd}    ${get_tong_tien_hang}    ${get_khachtt_af_execute}    ${get_gghd_af_execute}    ${get_khachcantra}    ${get_trangthai}    ${get_ghichu_in_hd_af_execute}
    ...    Get invoice info have note incase discount by invoice code    ${invoice_code}
    Run Keyword If    ${input_gghd} == 0    Should Be Equal As Numbers    ${get_khachcantra}    ${result_tongtienhang}
    ...    ELSE    Should Be Equal As Numbers    ${get_tong_tien_hang}    ${result_tongtienhang}
    Run Keyword If    ${input_gghd} == 0    Log    Ignore validate
    ...    ELSE    Should Be Equal As Numbers    ${get_tong_tien_hang}    ${result_tongtienhang}
    Should Be Equal As Numbers    ${get_khachcantra}    ${result_TTH_tru_gghd}
    Should Be Equal As Numbers    ${get_khachtt_af_execute}    ${actual_khtt_paymented}
    Should Be Equal As Strings    ${get_ma_kh_by_hd}    ${input_ma_kh}
    Should Be Equal As Numbers    ${get_gghd_af_execute}    ${result_gghd}
    Should Be Equal As Strings    ${get_trangthai}    Hoàn thành
    Should Be Equal As Strings    ${get_ghichu_in_hd_af_execute}    ${get_ghichu_bf_execute}
    #assert value order
    ${get_ma_kh_in_dh_af_execute}    ${get_TTDH_in_dh_af_execute}    ${get_tongtienhang_in_dh_af_exxecute}    ${get_khachdatra_in_dh_af_execute}    ${get_ghichu_af_execute}    Get order info have note by order code    ${order_code}
    Should Be Equal As Strings    ${get_ma_kh_in_dh_af_execute}    ${input_ma_kh}
    Should Be Equal As Strings    ${get_TTDH_in_dh_af_execute}    3    #trạng thái hoàn thành
    Should Be Equal As Numbers    ${get_tongtienhang_in_dh_af_exxecute}    ${get_tongtienhang_in_dh_bf_execute}
    Should Be Equal As Numbers    ${get_khachdatra_in_dh_af_execute}    ${actual_khtt_paymented}
    Should Be Equal As Strings    ${get_ghichu_af_execute}    ${get_ghichu_bf_execute}
    Validate invoice history frm Order    ${order_code}    ${invoice_code}    ${result_TTH_tru_gghd}
    #assert Customer
    ${get_no_af_execute_kh}    ${get_tongban_af_execute_kh}    ${get_tongban_tru_trahang_af_execute_kh}    Get Customer Debt from API after purchase    ${input_ma_kh}    ${invoice_code}    ${actual_khtt}
    Run Keyword If    '${input_khtt}' == '0'    Should Be Equal As Numbers    ${get_no_af_execute_kh}    ${result_du_no_hd_KH}
    ...    ELSE    Should Be Equal As Numbers    ${get_no_af_execute_kh}    ${result_PTT_hd_KH}
    Delete invoice by invoice code    ${invoice_code}
    Delete order frm Order code    ${order_code}

etedh_taohoadon05
    [Arguments]    ${input_ma_kh}   ${list_product_tocreate}    ${input_khtt_tocreate}    ${list_ggsp}   ${list_discount_type}    ${list_ggsp_del}   ${list_discount_type_del}    ${list_product_delete}    ${list_nums_addrow}
    ...   ${list_discount_addrow}   ${list_type_discount_addrow}    ${input_gghd}    ${input_khtt}   ${dict_product_new}    ${list_ggsp_new}
    ...    ${list_discount_type_new}    ${list_nums_addrow_new}   ${list_discount_addrow_new}   ${list_type_discount_addrow_new}
    Set Selenium Speed    0.5s
    #get info product, customer
    ${list_product_new}    Get Dictionary Keys    ${dict_product_new}
    ${list_nums_new}    Get Dictionary Values    ${dict_product_new}
    ${list_ggsp_delete}    Get Dictionary Values    ${list_ggsp_del}
    ${list_discounttype_del}    Get Dictionary Values    ${list_discount_type_del}
    ${list_nums_addrow}   ${list_discount_addrow}    ${list_type_discount_addrow}   Convert three string list to composite list    ${list_nums_addrow}    ${list_discount_addrow}
    ...    ${list_type_discount_addrow}
    ${list_nums_addrow_new}   ${list_discount_addrow_new}   ${list_type_discount_addrow_new}   Convert three string list to composite list    ${list_nums_addrow_new}   ${list_discount_addrow_new}
    ...   ${list_type_discount_addrow_new}
    ${list_product_del}    Get Dictionary Keys    ${list_product_delete}
    ${list_nums_del}    Get Dictionary Values    ${list_product_delete}
    ${order_code}    Add new order with multi products    ${input_ma_kh}    ${list_product_tocreate}    ${input_khtt_tocreate}
    ${get_khachdatra_in_dh_bf_execute}    ${get_tongtienhang_in_dh_bf_execute}    Get paid value frm API    ${order_code}
    ${get_list_hh_in_dh_bf_execute}    ${get_ghichu_bf_execute}   Get ghi chu and list product frm API    ${order_code}
    ${get_list_nums_in_dh}    Get list quantity by order code    ${order_code}    ${get_list_hh_in_dh_bf_execute}
    ${list_result_tongdh_delete}    Get list order summary frm product API    ${list_product_del}
    ${get_no_bf_execute}    ${get_tongban_bf_execute}    ${get_tongban_tru_trahang_bf_execute}    Get Customer Debt from API    ${input_ma_kh}
    #get order summary and sub total of products
    : FOR    ${ma_hh}    ${item_nums}   ${item_ggsp_del}    ${discount_type_del}    IN ZIP    ${list_product_del}    ${list_nums_del}    ${list_ggsp_delete}    ${list_discounttype_del}
    \    Remove Values From List    ${get_list_hh_in_dh_bf_execute}    ${ma_hh}
    \    Remove Values From List    ${get_list_nums_in_dh}    ${item_nums}
    \    Remove Values From List    ${list_ggsp}    ${item_ggsp_del}
    \    Remove Values From List    ${list_discount_type}    ${discount_type_del}
    Log    ${get_list_hh_in_dh_bf_execute}
    Log    ${get_list_nums_in_dh}
    Log    ${list_ggsp}
    Log    ${list_discount_type}
    #get list value of product
    ${get_list_order_detail_id}   Get list orderdetail id frm order api    ${order_code}    ${get_list_hh_in_dh_bf_execute}
    ${get_list_order_summary}   Get list order summary frm product API    ${get_list_hh_in_dh_bf_execute}
    ${list_result_tongdh}    Get list order summary after create invoice    ${get_list_order_summary}    ${get_list_nums_in_dh}
    ${list_nums}    ${list_discount}    ${list_type_discount}    Add value into three composite list    ${list_nums_addrow}   ${list_discount_addrow}    ${list_type_discount_addrow}
    ...    ${get_list_nums_in_dh}    ${list_ggsp}    ${list_discount_type}
    ${get_list_status}    Get list imei status thr API    ${get_list_hh_in_dh_bf_execute}
    ${list_imei_inlist}   Create list imei incase other product have multi row    ${get_list_hh_in_dh_bf_execute}    ${list_nums}    ${get_list_status}
    ${list_giatri_quydoi}    Get list gia tri quy doi frm product API    ${get_list_hh_in_dh_bf_execute}
    ${result_list_thanhtien}      ${list_result_toncuoi}    ${list_result_soluong}   Get list total sale - ending stock - total quantity incase catenate value all product    ${get_list_hh_in_dh_bf_execute}    ${list_nums}
    ...    ${list_giatri_quydoi}    ${list_discount}    ${list_type_discount}
    #get list value of product new
    ${get_list_order_summary_new}   Get list order summary frm product API    ${list_product_new}
    ${list_result_tongdh_new}    Get list order summary after create invoice    ${get_list_order_summary_new}    ${list_nums_new}
    ${list_nums_new}    ${list_discount_new}    ${list_type_discount_new}    Add value into three composite list    ${list_nums_addrow_new}   ${list_discount_addrow_new}   ${list_type_discount_addrow_new}
    ...    ${list_nums_new}   ${list_ggsp_new}    ${list_discount_type_new}
    ${get_list_status_new}    Get list imei status thr API    ${list_product_new}
    ${list_imei_inlist_new}   Create list imei incase other product have multi row    ${list_product_new}    ${list_nums_new}    ${get_list_status}
    ${list_giatri_quydoi_new}    Get list gia tri quy doi frm product API    ${list_product_new}
    ${result_list_thanhtien_new}      ${list_result_toncuoi_new}    ${list_result_soluong_new}   Get list total sale - ending stock - total quantity incase catenate value all product    ${list_product_new}    ${list_nums_new}
    ...    ${list_giatri_quydoi_new}     ${list_discount_new}    ${list_type_discount_new}
    #compute TTH with product
    ${result_tongtienhang}    Sum values in list    ${result_list_thanhtien}
    ${result_tongsoluong}    Sum values in list    ${get_list_nums_in_dh}
    ${result_tongtienhang_new}    Sum values in list    ${result_list_thanhtien_new}
    ${result_tongtienhang}    Sum    ${result_tongtienhang}    ${result_tongtienhang_new}
    ${result_TTH_tru_ggdh}    Run Keyword If    0 < ${input_gghd} < 100    Price after % discount invoice    ${result_tongtienhang}    ${input_gghd}
    ...    ELSE IF    ${input_gghd} > 100    Minus and replace floating point    ${result_tongtienhang}    ${input_gghd}
    ...    ELSE    Set Variable    ${result_tongtienhang}
    ${result_gghd}    Run Keyword If    0 < ${input_gghd} < 100    Convert % discount to VND and round    ${result_tongtienhang}    ${input_gghd}
    ...    ELSE    Set Variable    ${input_gghd}
    ${tamung}    Minus and replace floating point    ${get_khachdatra_in_dh_bf_execute}    ${result_TTH_tru_ggdh}
    ${actual_khtt_all}    Set Variable If    '${input_khtt}' == 'all'    ${tamung}    ${input_khtt}
    ${actual_khtt}    Set Variable If    '${input_khtt}' == '0'    0    ${actual_khtt_all}
    ${actual_khtt_paymented}    Minus    ${get_khachdatra_in_dh_bf_execute}    ${actual_khtt}
    ${result_du_no_hd_KH}    Sum    ${get_no_bf_execute}    ${result_TTH_tru_ggdh}
    ${result_PTT_hd_KH}    Sum    ${result_du_no_hd_KH}    ${actual_khtt}
    #create invoice from order
    ${get_order_id}   ${get_payment_id}   Get order - payment frm order api    ${order_code}
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${jsonpath_id_kh}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_kh}
    ${get_id_kh}    Get data from API    ${endpoint_khachhang}    ${jsonpath_id_kh}
    ${endpoint_danhmuc_hh_co_dvt}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${get_resp_danhmuc_hh}    Get Request and return body    ${endpoint_danhmuc_hh_co_dvt}
    #payload products
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
    #payload prodcut new
    ${list_jsonpath_id_sp_new}    ${list_jsonpath_giaban_new}    Get list jsonpath product frm list product    ${list_product_new}
    ${list_giaban_new}    ${list_result_ggsp_new}    ${list_id_sp_new}    Get product info frm multi row jsonpath product have discount product    ${get_resp_danhmuc_hh}    ${list_jsonpath_id_sp_new}    ${list_jsonpath_giaban_new}
    ...    ${list_discount_new}    ${list_type_discount_new}
    ${liststring_prs_order_detail_new}     Create List
    : FOR    ${item_gia_ban_add}   ${item_id_sp_add}   ${item_soluong_add}    ${item_result_ggsp_add}   ${item_ggsp_add}      IN ZIP       ${list_giaban_new}
    ...   ${list_id_sp_new}    ${list_nums_new}   ${list_result_ggsp_new}  ${list_discount_new}
    \    ${liststring_prs_order_detail_new}        Get payload product incase create order    ${item_gia_ban_add}    ${item_id_sp_add}
    \    ...    ${item_soluong_add}    ${item_result_ggsp_add}   ${item_ggsp_add}      ${liststring_prs_order_detail_new}
    ${liststring_prs_order_detail_new}    Convert List to String    ${liststring_prs_order_detail_new}
    Log     ${liststring_prs_order_detail_new}
    #payload
    ${giamgia_dh}    Set Variable If    0 < ${input_gghd} < 100    ${input_gghd}    0
    ${actual_tamung}    Minus     0       ${actual_khtt}
    ${request_payload}    Format String    {{"Invoice":{{"BranchId":{0},"RetailerId":{1},"OrderId":{2},"CustomerId":{3},"SoldById":{4},"SoldBy":{{"CreatedBy":0,"CreatedDate":"2018-12-10T10:44:15.970Z","Email":"","GivenName":"admin","Id":{4},"IsActive":true,"IsAdmin":true,"Type":0,"UserName":"admin","isDeleted":false,"Name":"admin"}},"SaleChannelId":0,"Seller":{{"CreatedBy":0,"CreatedDate":"2018-12-10T10:44:15.970Z","Email":"","GivenName":"admin","Id":{4},"IsActive":true,"IsAdmin":true,"Type":0,"UserName":"admin","isDeleted":false,"Name":"admin"}},"PriceBookId":0,"OrderCode":"{5}","Code":"Hóa đơn 1","Discount":{6},"DiscountRatio":{7},"InvoiceDetails":[{8},{9}],"InvoiceOrderSurcharges":[],"InvoicePromotions":[],"Payments":[{{"Method":"Cash","MethodStr":"Tiền mặt","Amount":{10},"Id":-1}}],"Status":1,"Total":{11},"Surcharge":0,"Type":1,"Uuid":"","addToAccount":"0","PayingAmount":0,"OrderPaidAmount":{12},"DepositReturn":{13},"TotalBeforeDiscount":{14},"ProductDiscount":384000,"PaidAmount":1000000,"DebugUuid":"","InvoiceWarranties":[],"CreatedBy":201567}}}}     ${BRANCH_ID}    ${get_id_nguoitao}    ${get_order_id}    ${get_id_kh}    ${get_id_nguoiban}
    ...   ${order_code}    ${result_gghd}    ${giamgia_dh}     ${liststring_prs_order_detail}     ${liststring_prs_order_detail_new}   ${actual_tamung}     ${result_TTH_tru_ggdh}    ${get_khachdatra_in_dh_bf_execute}       ${actual_khtt}     ${result_tongtienhang}
    Log    ${request_payload}
    ${invoice_code}    Post request to create invoice and get invoice code    ${request_payload}
    #get value
    Sleep    20s    wait for response to API
    #assert value product in invoice
    : FOR    ${ma_hh}    ${result_toncuoi}    ${item_soluong}    ${get_giatri_quydoi}    IN ZIP    ${get_list_hh_in_dh_bf_execute}    ${list_result_toncuoi}    ${list_result_soluong}    ${list_giatri_quydoi}
    \    Run Keyword If    '${get_giatri_quydoi}' == '1'    Validate product history frm API    ${invoice_code}    ${ma_hh}    ${result_toncuoi}    ${item_soluong}
    \    ...    ELSE    Validate unit product history frm API    ${invoice_code}    ${ma_hh}    ${result_toncuoi}   ${item_soluong}    ${get_giatri_quydoi}
    : FOR    ${ma_hh_new}    ${result_toncuoi_new}    ${item_soluong_new}    ${get_giatri_quydoi_new}    IN ZIP    ${list_product_new}         ${list_result_toncuoi_new}    ${list_result_soluong_new}     ${list_giatri_quydoi_new}
    \    Run Keyword If    '${get_giatri_quydoi_new}' == '1'    Validate product history frm API    ${invoice_code}    ${ma_hh_new}    ${result_toncuoi_new}    ${item_soluong_new}
    \    ...    ELSE    Validate unit product history frm API    ${invoice_code}    ${ma_hh_new}    ${result_toncuoi_new}    ${item_soluong_new}    ${get_giatri_quydoi_new}
    #validate deleted product
    ${list_order_summary_delete_af_execute}    Get list order summary frm product API    ${list_product_del}
    : FOR    ${result_tong_dh_delete}    ${order_summary_delete_af_execute}    IN ZIP    ${list_result_tongdh_delete}    ${list_order_summary_delete_af_execute}
    \    Should Be Equal As Numbers    ${result_tong_dh_delete}    ${order_summary_delete_af_execute}
    #validate product
    ${list_order_summary_af_execute}    Get list order summary frm product API    ${get_list_hh_in_dh_bf_execute}
    : FOR    ${result_tong_dh}    ${order_summary_af_execute}    IN ZIP    ${list_result_tong_dh}    ${list_order_summary_af_execute}
    \    Should Be Equal As Numbers    ${order_summary_af_execute}    ${result_tong_dh}
    #assert value invoice
    ${get_ma_kh_by_hd}    ${get_tong_tien_hang}    ${get_khachtt_af_execute}    ${get_gghd_af_execute}    ${get_khachcantra}    ${get_trangthai}    ${get_ghichu_in_hd_af_execute}
    ...    Get invoice info have note incase discount by invoice code    ${invoice_code}
    Run Keyword If    ${input_gghd} == 0    Should Be Equal As Numbers    ${get_khachcantra}    ${result_tongtienhang}
    ...    ELSE    Should Be Equal As Numbers    ${get_tong_tien_hang}    ${result_tongtienhang}
    Should Be Equal As Numbers    ${get_khachcantra}    ${result_TTH_tru_ggdh}
    Should Be Equal As Numbers    ${get_khachtt_af_execute}    ${result_TTH_tru_ggdh}
    Should Be Equal As Strings    ${get_ma_kh_by_hd}    ${input_ma_kh}
    Should Be Equal As Numbers    ${get_gghd_af_execute}    ${result_gghd}
    Should Be Equal As Strings    ${get_trangthai}    Hoàn thành
    Should Be Equal As Strings    ${get_ghichu_in_hd_af_execute}    ${get_ghichu_bf_execute}
    #assert value order
    ${get_ma_kh_in_dh_af_execute}    ${get_TTDH_in_dh_af_execute}    ${get_tongtienhang_in_dh_af_exxecute}    ${get_khachdatra_in_dh_af_execute}    ${get_ghichu_af_execute}    Get order info have note by order code    ${order_code}
    Should Be Equal As Strings    ${get_ma_kh_in_dh_af_execute}    ${input_ma_kh}
    Should Be Equal As Strings    ${get_TTDH_in_dh_af_execute}    2    #trạng thái đang giao hàng
    Should Be Equal As Numbers    ${get_tongtienhang_in_dh_af_exxecute}    ${get_tongtienhang_in_dh_bf_execute}
    Should Be Equal As Numbers    ${get_khachdatra_in_dh_af_execute}    ${actual_khtt_paymented}
    Should Be Equal As Strings    ${get_ghichu_af_execute}    ${get_ghichu_bf_execute}
    Validate invoice history frm Order    ${order_code}    ${invoice_code}    ${result_TTH_tru_ggdh}
    #assert Customer
    ${get_no_af_execute_kh}    ${get_tongban_af_execute_kh}    ${get_tongban_tru_trahang_af_execute_kh}    Get Customer Debt from API after purchase    ${input_ma_kh}    ${invoice_code}    ${actual_khtt}
    Run Keyword If    '${input_khtt}' == '0'    Should Be Equal As Numbers    ${get_no_af_execute_kh}    ${result_du_no_hd_KH}
    ...    ELSE    Should Be Equal As Numbers    ${get_no_af_execute_kh}    ${result_PTT_hd_KH}
    #Delete invoice by invoice code    ${invoice_code}
    #Delete order frm Order code    ${order_code}

etedh_taohoadon06
    [Arguments]    ${input_ma_kh}   ${list_product_tocreate}    ${input_product}    ${input_soluong}    ${input_khtt_tocreate}   ${dict_product_new}    ${input_gghd}    ${input_khtt}
    Set Selenium Speed    0.5s
    #get info product, customer
    ${list_product_new}    Get Dictionary Keys    ${dict_product_new}
    ${list_nums_new}    Get Dictionary Values    ${dict_product_new}
    ${order_code}    Add new order with multi products    ${input_ma_kh}    ${list_product_tocreate}    ${input_khtt_tocreate}
    ${get_khachdatra_in_dh_bf_execute}    ${get_tongtienhang_in_dh_bf_execute}    Get paid value frm API    ${order_code}
    ${get_list_hh_in_dh_bf_execute}    ${get_ghichu_bf_execute}   Get ghi chu and list product frm API    ${order_code}
    ${get_list_nums_in_dh}    Get list quantity by order code    ${order_code}    ${get_list_hh_in_dh_bf_execute}
    ${get_no_bf_execute}    ${get_tongban_bf_execute}    ${get_tongban_tru_trahang_bf_execute}    Get Customer Debt from API    ${input_ma_kh}
    #get order summary and sub total of products
    ${list_giatri_quydoi_new}    Get list gia tri quy doi frm product API    ${list_product_new}
    ${list_result_thanhtien_new}    Create List
    ${list_result_order_summary_new}    Create List
    ${list_tonkho_new}    Create List
    ${get_list_product_type}    ${list_tonkho_service}    Get list product type and ending stock of service frm API    ${list_product_new}
    ${get_list_toncuoi}   Get list onhand frm API    ${list_product_new}
    ${list_baseprice}    ${list_order_summary}    Get list base price and order summary frm product API    ${list_product_new}
    : FOR    ${item_ma_hh}    ${nums}    ${get_baseprice}    ${get_tong_dh}    ${get_ton_bf_execute}    ${get_toncuoi_dv_execute}    ${giatri_quydoi}    ${get_product_type}    IN ZIP
    ...    ${list_product_new}    ${list_nums_new}    ${list_baseprice}    ${list_order_summary}   ${get_list_toncuoi}    ${list_tonkho_service}    ${list_giatri_quydoi_new}    ${get_list_product_type}
    \    ${result_tongso_dh}    Sum    ${get_tong_dh}    ${nums}
    \    ${result_thanhtien}    Multiplication and round    ${get_baseprice}    ${nums}
    \    ${result_toncuoi}    Run Keyword If    '${giatri_quydoi}' == '1'    Computation and get list ending stock    ${get_ton_bf_execute}    ${get_toncuoi_dv_execute}
    \    ...    ${nums}    ${get_product_type}
    \    ...    ELSE    Computation and get list ending stock for unit product    ${item_product}    ${giatri_quydoi}    ${nums}
    \    Append To List    ${list_tonkho_new}    ${result_toncuoi}
    \    Append To List    ${list_result_thanhtien_new}    ${result_thanhtien}
    \    Append To List    ${list_result_order_summary_new}    ${result_tongso_dh}
    #####
    ${list_result_thanhtien_addrow}    Create List
    ${list_result_tongso_dh}    Create List
    ${list_result_thanhtien}    Create List
    ${list_result_toncuoi}    Create List
    ${list_result_tongsoluong}    Create List
    ${list_giatri_quydoi}    Get list gia tri quy doi frm product API    ${get_list_hh_in_dh_bf_execute}
    ${get_list_baseprice_addrow}   ${get_list_order_summary_addrow}   Get list base price and order summary frm product API    ${get_list_hh_in_dh_bf_execute}
    ${get_list_product_type_addrow}    ${list_tonkho_service_addrow}    Get list product type and ending stock of service frm API    ${get_list_hh_in_dh_bf_execute}
    :FOR      ${item_soluong}   ${item_giaban}    ${item_tong_dh}   ${get_onhand}   IN ZIP    ${get_list_nums_in_dh}     ${get_list_baseprice_addrow}   ${get_list_order_summary_addrow}    ${list_tonkho_service_addrow}
    \   ${result_tongso_dh}    Minus   ${item_tong_dh}    ${item_soluong}
    \   ${result_thanhtien}    Multiplication and round    ${item_giaban}    ${item_soluong}
    \   ${result_thanhtien_addrow}    Multiplication and round    ${item_giaban}    50
    \   ${result_toncuoi}   Minusx3 and replace foating point   ${get_onhand}    ${item_soluong}    50
    \   ${result_tongsoluong}   Sum   ${item_soluong}    50
    \   Append To List    ${list_result_thanhtien}   ${result_thanhtien}
    \   Append To List    ${list_result_tongso_dh}   ${result_tongso_dh}
    \   Append To List    ${list_result_thanhtien_addrow}   ${result_thanhtien_addrow}
    \   Append To List    ${list_result_toncuoi}   ${result_toncuoi}
    \   Append To List    ${list_result_tongsoluong}   ${result_tongsoluong}
    #compute TTH with product
    ${result_tongtienhang}    Sum values in list    ${list_result_thanhtien}
    ${result_tongsoluong}    Sum values in list    ${get_list_nums_in_dh}
    ${result_tongtienhang_new}    Sum values in list    ${list_result_thanhtien_new}
    ${result_tongtienhang_addrow}    Sum values in list    ${list_result_thanhtien_addrow}
    ${result_tongtienhang}    Sum x 3    ${result_tongtienhang}       ${result_tongtienhang_addrow}    ${result_tongtienhang_new}
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
    #payload product new
    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}    Get list jsonpath product frm list product    ${list_product_new}
    ${list_giaban_new}    ${list_id_sp}      Get product info frm list jsonpath product    ${get_resp_danhmuc_hh}    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}
    ${liststring_prs_order_detail_new}     Set Variable      needdel
    Log        ${liststring_prs_order_detail_new}
    : FOR    ${item_gia_ban}   ${item_id_sp}   ${item_soluong}    IN ZIP      ${list_giaban_new}        ${list_id_sp}    ${list_nums_new}
    \    ${payload_each_product}        Format string       {{"BasePrice":{0},"IsLotSerialControl":false,"IsMaster":false,"IsRewardPoint":false,"Note":"","Price":{0},"ProductCode":"DV049","ProductId":{1},"ProductName":"Nails 1","Quantity":{2},"Uuid":"","OriginPrice":{0},"ProductBatchExpireId":null}}    ${item_gia_ban}   ${item_id_sp}   ${item_soluong}
    \    ${liststring_prs_order_detail_new}       Catenate      SEPARATOR=,      ${liststring_prs_order_detail_new}      ${payload_each_product}
    ${liststring_prs_order_detail_new}       Replace String      ${liststring_prs_order_detail_new}       needdel,       ${EMPTY}      count=1
    ${giamgia_hd}    Set Variable If    0 < ${input_gghd} < 100    ${input_gghd}    0
    #payload
    ${request_payload}    Format String    {{"Invoice":{{"BranchId":{0},"RetailerId":{1},"OrderId":{2},"UpdateInvoiceId":0,"UpdateReturnId":0,"CustomerId":{3},"SoldById":{4},"SoldBy":{{"CreatedBy":0,"CreatedDate":"2018-07-30T08:27:36.800Z","Email":"","GivenName":"anh.lv","Id":{4},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false,"Name":"anh.lv"}},"SaleChannelId":0,"Seller":{{"CreatedBy":0,"CreatedDate":"2018-07-30T08:27:36.800Z","Email":"","GivenName":"anh.lv","Id":{4},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false,"Name":"anh.lv"}},"PriceBookId":0,"OrderCode":"{5}","Code":"Hóa đơn 2","Discount":{6},"DiscountRatio":{7},"InvoiceDetails":[{8},{9}],"InvoiceOrderSurcharges":[],"InvoicePromotions":[],"Payments":[{{"Method":"Cash","MethodStr":"Tiền mặt","Amount":{10},"Id":-1}}],"Status":1,"Total":{11},"Surcharge":0,"Type":1,"Uuid":"","addToAccount":"0","PayingAmount":{10},"OrderPaidAmount":{12},"TotalBeforeDiscount":{13},"ProductDiscount":60800,"PaidAmount":2000000,"DebugUuid":"","InvoiceWarranties":[],"CreatedBy":201567}}}}     ${BRANCH_ID}    ${get_id_nguoitao}    ${get_order_id}    ${get_id_kh}    ${get_id_nguoiban}
    ...   ${order_code}     ${result_gghd}    ${giamgia_hd}    ${liststring_prs_order_detail}    ${liststring_prs_order_detail_new}    ${actual_khachcantra}    ${result_TTH_tru_gghd}   ${get_khachdatra_in_dh_bf_execute}    ${result_tongtienhang}
    Log    ${request_payload}
    ${invoice_code}    Post request to create invoice and get invoice code    ${request_payload}
    #get value
    Sleep    20s    wait for response to API
    #assert ending stock of product
    : FOR    ${ma_hh}    ${result_toncuoi}    ${item_soluong}    ${get_giatri_quydoi}    IN ZIP    ${get_list_hh_in_dh_bf_execute}    ${list_result_toncuoi}    ${list_result_tongsoluong}    ${list_giatri_quydoi}
    \    Run Keyword If    '${get_giatri_quydoi}' == '1'    Validate product history frm API    ${invoice_code}    ${ma_hh}    ${result_toncuoi}    ${item_soluong}
    \    ...    ELSE    Validate unit product history frm API    ${invoice_code}    ${ma_hh}    ${result_toncuoi}   ${item_soluong}    ${get_giatri_quydoi}
    : FOR    ${ma_hh_new}    ${result_toncuoi_new}    ${item_soluong_new}    ${get_giatri_quydoi_new}    IN ZIP    ${list_product_new}    ${list_tonkho_new}    ${list_nums_new}    ${list_giatri_quydoi_new}
    \    Run Keyword If    '${get_giatri_quydoi_new}' == '1'    Validate product history frm API    ${invoice_code}    ${ma_hh_new}    ${result_toncuoi_new}    ${item_soluong_new}
    \    ...    ELSE    Validate unit product history frm API    ${invoice_code}    ${ma_hh_new}    ${result_toncuoi_new}    ${item_soluong_new}    ${get_giatri_quydoi_new}
    #validate ordersummary of product
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
