*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}      ${headless_browser}
Test Setup
Test Teardown     After Test
Library           SeleniumLibrary
Resource          ../../../../core/API/api_danhmuc_hanghoa.robot
Resource          ../../../../core/API/api_dathang.robot
Resource          ../../../../core/API/api_khachhang.robot
Resource          ../../../../core/API/api_mhbh.robot
Resource          ../../../../core/Dat_Hang/dat_hang_action.robot
Resource          ../../../../core/Dat_Hang/dat_hang_navigation.robot
Resource          ../../../../core/Dat_Hang/dat_hang_page.robot
Resource          ../../../../core/Ban_Hang/banhang_action.robot
Resource          ../../../../core/Ban_Hang/banhang_page.robot
Resource          ../../../../core/Ban_Hang/banhang_navigation.robot
Resource          ../../../../core/share/toast_message.robot
Resource          ../../../../core/API/api_soquy.robot
Resource          ../../../../core/share/javascript.robot
Resource          ../../../../core/share/discount.robot
Resource          ../../../../core/API/api_mhbh_dathang.robot

*** Variables ***
&{dict_product_num_01}    HH0025=3.6     SIL005=1    DVT24=2.4    DVL005=2     CBKH005=3
&{dict_product_num_02}    HH0026=3.6     SIL006=1    QDKL025=2.4    DVL006=2     CBKH006=3
&{list_product_delete}    SIL006=1
@{discount}           10   85000.22    0    5000      190000.45
@{discount_type}      dis   changedown    none     disvnd   changeup
@{list_soluong_addrow}   2   4   3.5,1.8,2     3     1,2
@{discount_addrow}   7000     5     3000,10000,0     89000     7,200000.56
@{discount_type_addrow}  disvnd    dis   disvnd,changedown,none   changeup  dis,changeup
&{list_productadd}       SIL007=1    DVL007=2.8
@{list_nums_update}   1     3     2.5   4
*** Test Cases ***    List product&nums    List GGSP      List discount type    GGDH       Khách TT
Update order          [Tags]     AEDMNOCUS
                      [Template]    edhkl10
                      ${dict_product_num_01}     ${discount}    ${list_nums_update}    ${discount_type}   ${list_soluong_addrow}    ${discount_addrow}     ${discount_type_addrow}     ${list_product_delete}    ${list_productadd}   200000      500000    Đã đặt cọc    100000

Lay all phan don hang       [Tags]       AEDNOCUS
                      [Template]    edhkl12
                      ${dict_product_num_02}    ${discount}    ${discount_type}    0   ${list_soluong_addrow}    ${discount_addrow}     ${discount_type_addrow}     all

*** Keywords ***
edhkl9
    [Arguments]    ${dict_product_nums}   ${list_ggsp}    ${list_discount_type}   ${list_nums_addrow}   ${list_discount_addrow}    ${list_type_discount_addrow}
    ...       ${input_ggdh}    ${input_khtt}
    #get info product, customer
    Set Selenium Speed    0.5s
    ${list_nums_addrow}   ${list_discount_addrow}    ${list_type_discount_addrow}   Convert three string list to composite list    ${list_nums_addrow}    ${list_discount_addrow}
    ...    ${list_type_discount_addrow}
    ${list_product}    Get Dictionary Keys    ${dict_product_nums}
    ${list_nums}    Get Dictionary Values    ${dict_product_nums}
    ${list_result_thanhtien}    ${list_result_ordersummary}    ${list_result_giamoi}    Get list total sale and order summary incase discount and newprice    ${list_product}    ${list_nums}    ${list_ggsp}    ${list_discount_type}
    ${list_result_thanhtien_addrow}    ${list_result_giamoi_addrow}    ${list_result_order_summary}    Get list total sale - order summary - newprice incase add row product    ${list_product}    ${list_nums_addrow}
    ...    ${list_discount_addrow}    ${list_type_discount_addrow}    ${list_result_ordersummary}
    ${get_list_id_product}    Get list product id thr API    ${list_product}
    #compute
    ${result_tongtienhang}    Sum values in list and round    ${list_result_thanhtien}
    ${result_tongtienhang_addrow}    Sum values in list and round    ${list_result_thanhtien_addrow}
    ${result_tongtienhang}    Sum and round     ${result_tongtienhang}    ${result_tongtienhang_addrow}
    ${result_tongcong}    Run Keyword If    0 < ${input_ggdh} < 100    Price after % discount invoice    ${result_tongtienhang}    ${input_ggdh}
    ...    ELSE IF    ${input_ggdh} > 100    Minus and replace floating point    ${result_tongtienhang}    ${input_ggdh}
    ...    ELSE    Set Variable    ${result_tongtienhang}
    ${result_ggdh}    Run Keyword If    0 < ${input_ggdh} < 100    Convert % discount to VND and round    ${result_tongtienhang}    ${input_ggdh}    ELSE    Set Variable    ${input_ggdh}
    ${result_tongcong}    Replace floating point    ${result_tongcong}
    ${actual_khtt_all}    Set Variable If    '${input_khtt}' == 'all'    ${result_tongcong}    ${input_khtt}
    ${actual_khtt}    Set Variable If    '${input_khtt}' == '0'    0    ${actual_khtt_all}
    #input data into DH form
    Before Test turning on display mode      ${toggle_item_themdong}
    Wait Until Keyword Succeeds    3 times    5 s    Click Element JS    ${tab_dathang}
    Reload Page
    ${laster_nums}    Set Variable    0
    : FOR    ${item_product}    ${item_nums}    ${item_ggsp}    ${result_giamoi}    ${discount_type}       ${nums_addrow}    ${item_ggsp_addrow}    ${result_giamoi_addrow}
    ...   ${discount_type_addrow}   ${product_id}    IN ZIP    ${list_product}    ${list_nums}   ${list_ggsp}  ${list_result_giamoi}   ${list_discount_type}
    ...   ${list_nums_addrow}    ${list_discount_addrow}   ${list_result_giamoi_addrow}   ${list_type_discount_addrow}    ${get_list_id_product}
    \    ${laster_nums}    Wait Until Keyword Succeeds    3 times    5 s    Input product-num in sale form    ${item_product}    ${item_nums}    ${laster_nums}    ${cell_tongsoluong_dh}
    \    Run Keyword If    '${discount_type}' == 'dis'   Wait Until Keyword Succeeds    3 times    5 s   Input % discount for multi product    ${item_product}    ${item_ggsp}    ${result_giamoi}
    \    ...    ELSE IF    '${discount_type}' == 'disvnd'  Wait Until Keyword Succeeds    3 times    5 s    Input VND discount for multi product    ${item_product}    ${item_ggsp}    ${result_giamoi}
    \    ...    ELSE IF    '${discount_type}' == 'changeup' or '${discount_type}' == 'changedown'  Wait Until Keyword Succeeds    3 times    5 s    Input newprice for multi product    ${item_product}   ${item_ggsp}
    \    ...    ELSE    Log    Ignore input
    \     ${laster_nums}    Add row product incase multi product in MHBH    ${item_product}   ${nums_addrow}    ${item_ggsp_addrow}
    \     ...   ${result_giamoi_addrow}   ${discount_type_addrow}   ${product_id}        ${laster_nums}    ${cell_tongsoluong_dh}
    Wait Until Keyword Succeeds    3 times    5 s    Run keyword if    0 < ${input_ggdh} < 100    Wait Until Keyword Succeeds    3 times    5 s    Input % discount order    ${input_ggdh}    ${result_ggdh}
    ...    ELSE    Wait Until Keyword Succeeds    3 times    5 s    Input VND discount order    ${input_ggdh}
    Run Keyword If    '${input_khtt}' == '0'    Log      Ingore input    ELSE    Wait Until Keyword Succeeds    3 times    5 s    Input payment from customer
    ...    ${textbox_dh_khachtt}    ${actual_khtt}    ${result_tongcong}    ${cell_tinhvaocongno_order}
    Wait Until Keyword Succeeds    3 times    5 s    Click Element JS    ${button_bh_dathang}
    Wait Until Keyword Succeeds    3 times    5 s    Click Element JS    ${button_dongy_popup_nocustomer}
    Sleep   2s
    Order message success validation
    ${get_ma_dh}    Get saved code after execute
    #get values
    Sleep    20 s    wait for response to API
    #assert value product
    ${list_order_summary_af_execute}    Get list order summary frm product API    ${list_product}
    : FOR    ${result_tong_dh}    ${order_summary_af_execute}    IN ZIP    ${list_result_order_summary}    ${list_order_summary_af_execute}
    \    Should Be Equal As Numbers    ${order_summary_af_execute}    ${result_tong_dh}
    #assert value order
    ${get_ma_kh_in_dh_af_execute}    ${get_TTDH_in_dh_af_execute}    ${get_tongtienhang_in_dh_af_exxecute}    ${get_khachdatra_in_dh_af_execute}    ${get_giamgia_in_dh_af_execute}    ${get_tongcong_in_dh_af_execute}    ${get_ghichu_in_dh_af_execute}
    ...    Get order info incase discount by order code    ${get_ma_dh}
    Should Be Equal As Strings    ${get_ma_kh_in_dh_af_execute}    0
    Should Be Equal As Numbers    ${get_TTDH_in_dh_af_execute}    1    #1 : phiếu tạm
    Run Keyword If    ${input_ggdh} == 0    Should Be Equal As Numbers    ${get_tongcong_in_dh_af_execute}    ${result_tongtienhang}
    ...    ELSE    Should Be Equal As Numbers    ${get_tongtienhang_in_dh_af_exxecute}    ${result_tongtienhang}
    Run Keyword If    ${input_ggdh} == 0    Log    Ignore validate
    ...    ELSE    Should Be Equal As Numbers    ${get_tongtienhang_in_dh_af_exxecute}    ${result_tongtienhang}
    Should Be Equal As Numbers    ${get_khachdatra_in_dh_af_execute}    ${actual_khtt}
    Should Be Equal As Numbers    ${get_giamgia_in_dh_af_execute}    ${result_ggdh}
    Should Be Equal As Numbers    ${get_tongcong_in_dh_af_execute}    ${result_tongcong}
    Delete order frm Order code    ${get_ma_dh}

edhkl10
    [Arguments]    ${dict_product_nums}   ${list_ggsp}    ${list_quantity_update}    ${list_discount_type}   ${list_nums_addrow}   ${list_discount_addrow}
    ...   ${list_type_discount_addrow}     ${list_product_delete}   ${list_product_addnew}      ${input_ggdh}    ${input_khtt}    ${input_ghichu}    ${input_khtt_create_order}
    #get info product, customer
    ${list_nums_addrow}   ${list_discount_addrow}    ${list_type_discount_addrow}   Convert three string list to composite list    ${list_nums_addrow}    ${list_discount_addrow}
    ...    ${list_type_discount_addrow}
    ${list_product_del}    Get Dictionary Keys    ${list_product_delete}
    ${list_nums_del}    Get Dictionary Values    ${list_product_delete}
    ${list_product_add}    Get Dictionary Keys    ${list_product_addnew}
    ${list_nums_add}    Get Dictionary Values    ${list_product_addnew}
    ${order_code}    Add new order with multi products no customer    ${dict_product_nums}    ${input_khtt_create_order}
    ${get_khachdatra_in_dh_bf_execute}    ${get_tongtienhang_in_dh_bf_execute}    Get paid value frm API    ${order_code}
    ${get_list_hh_in_dh_bf_execute}   ${get_list_sl_in_dh_bf_execute}    Get list product and quantity frm API    ${order_code}
    ${list_result_tongdh_delete}    Get list order summary incase delete product    ${order_code}    ${list_product_del}
    #get order summary and sub total of products
    : FOR    ${ma_hh}   ${number}    IN ZIP     ${list_product_delete}    ${list_nums_del}
    \    Remove Values From List    ${get_list_hh_in_dh_bf_execute}    ${ma_hh}
    \    Remove Values From List    ${get_list_sl_in_dh_bf_execute}    ${number}
    Log    ${get_list_hh_in_dh_bf_execute}
    Log    ${get_list_sl_in_dh_bf_execute}
    ${list_result_thanhtien}    ${list_result_tongdh}    ${list_result_tongdh_add}    ${list_result_giamoi}    ${list_result_giamoi_add}    Get list total sale - order summary incase update quantity and add product    ${order_code}    ${get_list_hh_in_dh_bf_execute}
    ...   ${list_quantity_update}   ${list_ggsp}    ${list_discount_type}    ${list_product_add}    ${list_nums_add}
    ${list_result_thanhtien_addrow}    ${list_result_giamoi_addrow}    ${list_result_order_summary}    Get list total sale - order summary - newprice incase add row product    ${get_list_hh_in_dh_bf_execute}    ${list_nums_addrow}
    ...    ${list_discount_addrow}    ${list_type_discount_addrow}    ${list_result_tongdh}
    ${list_result_thanhtien_addrow_add}    ${list_result_giamoi_addrow_add}    ${list_result_order_summary_add}    Get list total sale - order summary - newprice incase add row product    ${list_product_add}    ${list_nums_addrow}
    ...    ${list_discount_addrow}    ${list_type_discount_addrow}    ${list_result_tongdh_add}
    #compute
    ${result_tongsoluong}    Sum values in list and round    ${get_list_sl_in_dh_bf_execute}
    ${result_tongtienhang_update}    Sum values in list and round    ${list_result_thanhtien}
    ${result_tongtienhang_addrow}    Sum values in list and round    ${list_result_thanhtien_addrow}
    ${result_tongtienhang_addrow_add}    Sum values in list and round    ${list_result_thanhtien_addrow_add}
    ${result_tongtienhang}   Sum x 3    ${result_tongtienhang_update}     ${result_tongtienhang_addrow}    ${result_tongtienhang_addrow_add}
    ${result_ggdh}    Run Keyword If    0 < ${input_ggdh} < 100    Convert % discount to VND and round    ${result_tongtienhang}    ${input_ggdh}
    ...    ELSE    Set Variable    ${input_ggdh}
    ${result_tongcong_in_dh}    Run Keyword If    0 < ${input_ggdh} < 100    Price after % discount invoice    ${result_tongtienhang}    ${input_ggdh}
    ...    ELSE    Minus and replace floating point    ${result_tongtienhang}    ${input_ggdh}
    ${result_khachcantra}    Minus and replace floating point    ${result_tongcong_in_dh}    ${get_khachdatra_in_dh_bf_execute}
    ${actual_khtt_all}    Set Variable If    '${input_khtt}' == 'all'    ${result_khachcantra}    ${input_khtt}
    ${actual_khtt}    Set Variable If    '${input_khtt}' == '0'    0    ${actual_khtt_all}
    ${actual_khtt_paymented}    Sum and replace floating point    ${actual_khtt}    ${get_khachdatra_in_dh_bf_execute}
    #get value
    ${get_order_id}   ${get_payment_id}   Get order - payment frm order api    ${order_code}
    ${get_list_order_detail_id}   Get list orderdetail id frm order api    ${order_code}    ${get_list_hh_in_dh_bf_execute}
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${endpoint_danhmuc_hh_co_dvt}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${get_resp_danhmuc_hh}    Get Request and return body    ${endpoint_danhmuc_hh_co_dvt}
    #payload product
    ${list_nums}    ${list_discount}    ${list_type_discount}    Add value into three composite list    ${list_nums_addrow}   ${list_discount_addrow}    ${list_type_discount_addrow}
    ...    ${list_quantity_update}   ${list_ggsp}    ${list_discount_type}
    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}    Get list jsonpath product frm list product    ${get_list_hh_in_dh_bf_execute}
    ${list_giaban}    ${list_result_ggsp}    ${list_id_sp}    Get product info frm multi row jsonpath product have discount product    ${get_resp_danhmuc_hh}    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}
    ...    ${list_discount}    ${list_type_discount}
    ${liststring_prs_order_detail}     Create List
    : FOR    ${item_gia_ban}   ${orderdetail_id}   ${item_id_sp}   ${item_soluong}    ${item_result_ggsp}   ${item_ggsp}      IN ZIP       ${list_giaban}
    ...   ${get_list_order_detail_id}   ${list_id_sp}    ${list_nums}   ${list_result_ggsp}  ${list_discount}
    \    ${liststring_prs_order_detail}        Get payload product incase update order     ${item_gia_ban}    ${orderdetail_id}   ${item_id_sp}
    \    ...    ${item_soluong}    ${item_result_ggsp}   ${item_ggsp}      ${liststring_prs_order_detail}
    ${liststring_prs_order_detail}    Convert List to String    ${liststring_prs_order_detail}
    Log     ${liststring_prs_order_detail}
    #payloadd product add
    ${list_nums_addrow}   ${list_discount_addrow}    ${list_type_discount_addrow}    Delete value into three composite list    ${list_nums_addrow}   ${list_discount_addrow}    ${list_type_discount_addrow}
    ...    ${list_quantity_update}   ${list_ggsp}    ${list_discount_type}
    ${list_nums_new}    ${list_discount_new}    ${list_type_discount_new}    Add value into three composite list    ${list_nums_addrow}   ${list_discount_addrow}    ${list_type_discount_addrow}
    ...    ${list_nums_add}      ${list_ggsp}    ${list_discount_type}
    ${list_jsonpath_id_sp_add}    ${list_jsonpath_giaban_add}    Get list jsonpath product frm list product    ${list_product_add}
    ${list_giaban_add}    ${list_result_ggsp_add}    ${list_id_sp_add}    Get product info frm multi row jsonpath product have discount product    ${get_resp_danhmuc_hh}    ${list_jsonpath_id_sp_add}    ${list_jsonpath_giaban_add}
    ...    ${list_discount_new}    ${list_type_discount_new}
    ${liststring_prs_order_detail_add}     Create List
    : FOR    ${item_gia_ban_add}   ${item_id_sp_add}   ${item_soluong_add}    ${item_result_ggsp_add}   ${item_ggsp_add}      IN ZIP       ${list_giaban_add}
    ...   ${list_id_sp_add}    ${list_nums_new}   ${list_result_ggsp_add}  ${list_discount_new}
    \    ${liststring_prs_order_detail_add}        Get payload product incase create order    ${item_gia_ban_add}    ${item_id_sp_add}
    \    ...    ${item_soluong_add}    ${item_result_ggsp_add}   ${item_ggsp_add}      ${liststring_prs_order_detail_add}
    ${liststring_prs_order_detail_add}    Convert List to String    ${liststring_prs_order_detail_add}
    Log     ${liststring_prs_order_detail_add}
    ${giamgia_dh}    Set Variable If    0 < ${input_ggdh} < 100    ${input_ggdh}    0
    ${request_payload}    Format String    {{"Order":{{"Id":{0},"BranchId":{1},"RetailerId":{2},"SoldById":{3},"SoldBy":{{"CreatedBy":0,"CreatedDate":"2018-12-10T08:33:32.447Z","Email":"","GivenName":"admin","Id":{3},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false,"Name":"admin"}},"SaleChannelId":0,"SaleChannel":null,"Seller":{{"CreatedBy":0,"CreatedDate":"2018-12-10T08:33:32.447Z","Email":"","GivenName":"admin","Id":{3},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false,"Name":"admin"}},"PurchaseDate":"","Code":"{4}","Discount":{5},"DiscountRatio":{6},"OrderDetails":[{7},{8}],"InvoiceOrderSurcharges":[],"Payments":[{{"OrderValue":0,"DocumentValue":0,"PaidValue":0,"NeedPayValue":0,"CustomerName":"","CustomerCode":"","InvoiceCode":"","CustomerDebt":0,"CustomerOldDebt":0,"TargetCode":"","UserName":"","VoucherCampaignId":0,"Version":0,"TransGuid":"00000000000000000000000000000000","DocumentTypeValue":0,"Id":{9},"Code":"TTDH003658","Amount":{10},"AmountOriginal":0,"Method":"Cash","CreatedDate":"","CreatedBy":{3},"RetailerId":{2},"BranchId":{1},"OrderId":{0},"TransDate":"","UserId":{3},"Status":0,"System":false,"DeliveryPayments":[],"PaymentAllocation":[]}},{{"Method":"Cash","MethodStr":"Tiền mặt","Amount":{11},"Id":-2}}],"UsingCod":0,"Status":1,"Total":4693998,"Description":"{12}","Extra":"{{\\"Amount\\":50000,\\"Method\\":{{\\"Id\\":\\"Cash\\",\\"Label\\":\\"Tiền mặt\\"}},\\"activeCustomerGroupId\\":null,\\"ResetPromotion\\":false}}","Surcharge":0,"Type":2,"Uuid":"","addToAccount":"0","PayingAmount":50000,"TotalBeforeDiscount":5813001,"ProductDiscount":290650,"CreatedBy":441968,"CreatedDate":"","InvoiceWarranties":[]}}}}     ${get_order_id}   ${BRANCH_ID}    ${get_id_nguoitao}    ${get_id_nguoiban}
    ...    ${order_code}   ${result_ggdh}    ${giamgia_dh}    ${liststring_prs_order_detail}    ${liststring_prs_order_detail_add}   ${get_payment_id}   ${get_khachdatra_in_dh_bf_execute}   ${actual_khtt}    ${input_ghichu}
    Log    ${request_payload}
    ${order_code}    Post request to create order and return code    ${request_payload}
    #get values
    Sleep    20 s    wait for response to API
    #validate deleted product
    ${list_order_summary_delete_af_execute}    Get list order summary frm product API    ${list_product_del}
    : FOR    ${result_tong_dh_delete}    ${order_summary_delete_af_execute}    IN ZIP    ${list_result_tongdh_delete}    ${list_order_summary_delete_af_execute}
    \    Should Be Equal As Numbers    ${result_tong_dh_delete}    ${order_summary_delete_af_execute}
    #validate product
    ${list_order_summary_af_execute}    Get list order summary frm product API    ${get_list_hh_in_dh_bf_execute}
    : FOR    ${result_tong_dh}    ${order_summary_af_execute}    IN ZIP    ${list_result_order_summary}    ${list_order_summary_af_execute}
    \    Should Be Equal As Numbers    ${order_summary_af_execute}    ${result_tong_dh}
    #validate product add
    ${list_order_summary_add_af_execute}    Get list order summary frm product API    ${list_product_add}
    : FOR    ${result_tong_dh}    ${order_summary_af_execute}    IN ZIP    ${list_result_order_summary_add}    ${list_order_summary_add_af_execute}
    \    Should Be Equal As Numbers    ${order_summary_af_execute}    ${result_tong_dh}
    ${get_ma_kh_in_dh_af_execute}    ${get_TTDH_in_dh_af_execute}    ${get_tongtienhang_in_dh_af_exxecute}    ${get_khachdatra_in_dh_af_execute}
    ...    ${get_giamgia_in_dh_af_execute}    ${get_tongcong_in_dh_af_execute}    ${get_ghichu_af_execute}    Get order info have note incase discount by order code    ${order_code}
    Should Be Equal As Strings    ${get_ma_kh_in_dh_af_execute}    0
    Should Be Equal As Numbers    ${get_TTDH_in_dh_af_execute}    1    #1 : phiếu tạm
    Should Be Equal As Numbers    ${get_tongtienhang_in_dh_af_exxecute}    ${result_tongtienhang}
    Should Be Equal As Numbers    ${get_giamgia_in_dh_af_execute}    ${input_ggdh}
    Should Be Equal As Numbers    ${get_tongcong_in_dh_af_execute}    ${result_tongcong_in_dh}
    Should Be Equal As Numbers    ${get_khachdatra_in_dh_af_execute}    ${actual_khtt_paymented}
    Should Be Equal As Strings    ${get_ghichu_af_execute}    ${input_ghichu}
    Delete order frm Order code    ${order_code}
    After Test

edhkl11
    [Arguments]    ${list_product_delete}   ${list_nums_addrow}   ${list_discount_addrow}   ${list_type_discount_addrow}    ${input_khtt}   ${input_ggdh_tocreate}
    ...   ${list_product_tocreate}   ${list_ggsp_tocreate}   ${list_discount_type_tocreate}   ${input_khtt_to_create}
    [Documentation]    1. Get thông tin của khách hàng và product (dòng 2 -7)
    ...    2. Lấy ra tổng đặt hàng và tồn kho của từng sản phẩm, tính toán
    Set Selenium Speed    0.5s
    #get info product, customer
    ${order_code}   Add new order incase discount - payment - nocus and return order code   ${input_ggdh_tocreate}   ${list_product_tocreate}   ${list_ggsp_tocreate}   ${list_discount_type_tocreate}   ${input_khtt_to_create}
    ${list_nums_addrow}   ${list_discount_addrow}    ${list_type_discount_addrow}   Convert three string list to composite list    ${list_nums_addrow}    ${list_discount_addrow}
    ...    ${list_type_discount_addrow}
    ${list_product_del}    Get Dictionary Keys    ${list_product_delete}
    ${list_nums_del}    Get Dictionary Values    ${list_product_delete}
    ${get_ma_kh}    ${get_TTDH}    ${get_tongtienhang_in_dh_bf_execute}    ${get_khachdatra_in_dh_bf_execute}    ${get_ggdh_in_dh_bf_execute}    ${get_tongcong_in_dh_bf_execute}    Get order info incase discount not note by order code    ${order_code}
    ${get_list_hh_in_dh_bf_execute}    ${get_ghichu_bf_execute}   Get ghi chu and list product frm API    ${order_code}
    ${get_list_nums_in_dh}    Get list quantity by order code    ${order_code}    ${get_list_hh_in_dh_bf_execute}
    ${list_result_tongdh_delete}    Get list order summary frm product API    ${list_product_delete}
    #get order summary and sub total of products
    : FOR    ${ma_hh}    ${item_nums}    IN ZIP    ${list_product_del}    ${list_nums_del}
    \    Remove Values From List    ${get_list_hh_in_dh_bf_execute}    ${ma_hh}
    \    Remove Values From List    ${get_list_nums_in_dh}    ${item_nums}
    Log    ${get_list_hh_in_dh_bf_execute}
    Log    ${get_list_nums_in_dh}
    ${get_list_id_product}    Get list product id thr API    ${get_list_hh_in_dh_bf_execute}
    ${get_list_status}    Get list imei status thr API    ${get_list_hh_in_dh_bf_execute}
    Create list imei and other product    ${get_list_hh_in_dh_bf_execute}    ${get_list_nums_in_dh}
    ${list_result_tongdh}    ${result_list_toncuoi}    ${result_list_thanhtien}    Get list order summary - total sale - ending stocks frm API    ${order_code}    ${get_list_hh_in_dh_bf_execute}
    ${list_imei_inlist}   Create list imei incase other product have multi row    ${get_list_hh_in_dh_bf_execute}    ${list_nums_addrow}    ${get_list_status}
    ${list_giatri_quydoi}    Get list gia tri quy doi frm product API    ${get_list_hh_in_dh_bf_execute}
    ${list_result_thanhtien_addrow}      ${list_result_newprice_addrow}   ${list_result_toncuoi}    ${list_result_soluong}   Get list total sale - ending stock - total quantity incase add row product    ${get_list_hh_in_dh_bf_execute}
    ...    ${list_nums_addrow}    ${list_discount_addrow}    ${list_type_discount_addrow}    ${result_list_toncuoi}    ${get_list_nums_in_dh}    ${list_giatri_quydoi}
    #compute invoice info
    ${result_tongtienhang}    Sum values in list    ${result_list_thanhtien}
    ${result_tongsoluong}    Sum values in list    ${get_list_nums_in_dh}
    ${result_tongtienhang_addrow}    Sum values in list and round    ${list_result_thanhtien_addrow}
    ${result_tongtienhang}    Sum    ${result_tongtienhang}    ${result_tongtienhang_addrow}
    ${result_TTH_tru_ggdh}    Run Keyword If    0 < ${get_ggdh_in_dh_bf_execute} < 100    Price after % discount invoice    ${result_tongtienhang}    ${get_ggdh_in_dh_bf_execute}
    ...    ELSE IF    ${get_ggdh_in_dh_bf_execute} > 100    Minus and replace floating point    ${result_tongtienhang}    ${get_ggdh_in_dh_bf_execute}
    ...    ELSE    Set Variable    ${result_tongtienhang}
    ${result_ggdh}    Run Keyword If    0 < ${get_ggdh_in_dh_bf_execute} < 100    Convert % discount to VND and round    ${result_tongtienhang}    ${get_ggdh_in_dh_bf_execute}
    ...    ELSE    Set Variable    ${get_ggdh_in_dh_bf_execute}
    ${tamung}    Minus and replace floating point    ${get_khachdatra_in_dh_bf_execute}    ${result_TTH_tru_ggdh}
    ${result_khtt}    Minus and replace floating point    ${result_TTH_tru_ggdh}    ${get_khachdatra_in_dh_bf_execute}
    ${result_khachcantra}   Set Variable If   ${get_khachdatra_in_dh_bf_execute}>${result_TTH_tru_ggdh}     ${tamung}    ${result_khtt}
    ${actual_khtt_all}    Set Variable If    '${input_khtt}' == 'all'    ${result_khachcantra}    ${input_khtt}
    ${actual_khtt}    Set Variable If    '${input_khtt}' == '0'    0    ${actual_khtt_all}
    #compute order info
    ${result_khachthanhtoan_in_dh}    Sum and replace floating point    ${actual_khtt}    ${get_khachdatra_in_dh_bf_execute}
    ${result_khachtamung_in_dh}    Minus    ${get_khachdatra_in_dh_bf_execute}    ${actual_khtt}
    ${actual_khtt_paymented}    Set Variable If   ${get_khachdatra_in_dh_bf_execute}>${result_TTH_tru_ggdh}    ${result_khachtamung_in_dh}    ${result_khachthanhtoan_in_dh}
    ${get_list_status}    Get list imei status thr API    ${get_list_hh_in_dh_bf_execute}
    #create invoice frm Order
    Before Test turning on display mode      ${toggle_item_themdong}
    Go to xu ly dat hang    ${order_code}
    Go to BH frm process order    ${order_code}
    Delete list product into BH form    ${list_product_delete}
    ${laster_nums}    Set Variable    ${result_tongsoluong}
    : FOR    ${item_ma_hh}   ${item_imei}   ${item_status_imei}    IN ZIP    ${get_list_hh_in_dh_bf_execute}    ${imei_inlist}    ${get_list_status}
    \    Run Keyword If    '${item_status_imei}' != '0'    Input imei incase multi product to any form    ${item_ma_hh}    ${texbox_imei_search_multi_product}    ${item_serial_in_dropdown}    ${cell_imei_multi_product}    @{item_imei}
    : FOR    ${item_product1}   ${nums_addrow}    ${item_ggsp_addrow}    ${result_giamoi_addrow}   ${discount_type_addrow}   ${product_id}   ${item_status_imei}    ${item_imei_inlist}    IN ZIP    ${get_list_hh_in_dh_bf_execute}
    ...   ${list_nums_addrow}    ${list_discount_addrow}   ${list_result_newprice_addrow}   ${list_type_discount_addrow}   ${get_list_id_product}       ${get_list_status}     ${list_imei_inlist}
    \     ${laster_nums}    Run Keyword If    '${item_status_imei}' == '0'    Add row product incase multi product in MHBH    ${item_product1}   ${nums_addrow}    ${item_ggsp_addrow}
    \     ...   ${result_giamoi_addrow}   ${discount_type_addrow}   ${product_id}    ${laster_nums}    ${cell_lastest_number}
    \    ...  ELSE      Add row product incase imei in MHBH    ${item_product1}    ${nums_addrow}    ${discount_type_addrow}    ${item_ggsp_addrow}    ${result_giamoi_addrow}    ${product_id}    ${laster_nums}    ${cell_lastest_number}    ${item_imei_inlist}
    Run Keyword If    "${input_khtt}" == "all"    Click Element JS    ${button_bh_thanhtoan}    ELSE IF   ${get_khachdatra_in_dh_bf_execute}>${result_TTH_tru_ggdh}
    ...     Input customer payment and deposit refund into BH form    ${input_khtt}     ELSE   Input customer payment into BH form    ${input_khtt}    ${result_khachcantra}
    Sleep   1s
    Run Keyword If    "${input_khtt}" == "all"    Log     Ingore click      ELSE    Click Element JS    ${button_dongy_popup_nocustomer}
    Wait Until Page Contains Element    ${button_cancel}    2 mins
    Wait Until Keyword Succeeds    3 times    20 s    Click Element JS    ${button_cancel}    #tắt popup kết thúc đơn ĐH
    ${invoice_code}    Get saved code after execute
    Sleep    20 s    wait for response to API
    #assert value product in invoice
    : FOR    ${ma_hh}    ${result_toncuoi}    ${item_soluong}    ${get_giatri_quydoi}    IN ZIP    ${get_list_hh_in_dh_bf_execute}
    ...    ${list_result_toncuoi}    ${list_result_soluong}        ${list_giatri_quydoi}
    \    Run Keyword If    '${get_giatri_quydoi}' == '1'    Validate product history frm API    ${invoice_code}    ${ma_hh}    ${result_toncuoi}    ${item_soluong}
    \    ...    ELSE    Validate unit product history frm API    ${invoice_code}    ${ma_hh}    ${result_toncuoi}    ${item_soluong}    ${get_giatri_quydoi}
    #validate deleted product
    ${list_order_summary_delete_af_execute}    Get list order summary frm product API    ${list_product_delete}
    : FOR    ${result_tong_dh_delete}    ${order_summary_delete_af_execute}    IN ZIP    ${list_result_tongdh_delete}    ${list_order_summary_delete_af_execute}
    \    Should Be Equal As Numbers    ${result_tong_dh_delete}    ${order_summary_delete_af_execute}
    #validate product
    ${list_order_summary_af_execute}    Get list order summary frm product API    ${get_list_hh_in_dh_bf_execute}
    : FOR    ${result_tong_dh}    ${order_summary_af_execute}    IN ZIP    ${list_result_tongdh}    ${list_order_summary_af_execute}
    \    Should Be Equal As Numbers    ${order_summary_af_execute}    ${result_tong_dh}
    #assert value invoice
    ${get_ma_kh_by_hd}    ${get_tong_tien_hang}    ${get_khachtt_af_execute}    ${get_gghd_af_execute}    ${get_khachcantra}    ${get_trangthai}    ${get_ghichu_in_hd_af_execute}
    ...    Get invoice info have note incase discount by invoice code    ${invoice_code}
    Run Keyword If    ${get_ggdh_in_dh_bf_execute} == 0    Should Be Equal As Numbers    ${get_khachcantra}    ${result_tongtienhang}
    ...    ELSE    Should Be Equal As Numbers    ${get_tong_tien_hang}    ${result_tongtienhang}
    Should Be Equal As Numbers    ${get_khachcantra}    ${result_TTH_tru_ggdh}
    Run Keyword If    ${get_khachdatra_in_dh_bf_execute}>${result_TTH_tru_ggdh}    Should Be Equal As Numbers    ${get_khachtt_af_execute}    ${result_TTH_tru_ggdh}
    ...    ELSE    Should Be Equal As Numbers    ${get_khachtt_af_execute}    ${actual_khtt_paymented}
    Should Be Equal As Strings    ${get_ma_kh_by_hd}    0
    Should Be Equal As Numbers    ${get_gghd_af_execute}    ${result_ggdh}
    Should Be Equal As Strings    ${get_trangthai}    Hoàn thành
    Should Be Equal As Strings    ${get_ghichu_in_hd_af_execute}    ${get_ghichu_bf_execute}
    #assert value order
    ${get_ma_kh_in_dh_af_execute}    ${get_TTDH_in_dh_af_execute}    ${get_tongtienhang_in_dh_af_exxecute}    ${get_khachdatra_in_dh_af_execute}    ${get_giamgia_in_dh_af_execute}    ${get_tongcong_in_dh_af_execute}    ${get_ghichu_in_dh_af_execute}
    ...    Get order info have note incase discount by order code    ${order_code}
    Should Be Equal As Strings    ${get_ma_kh_in_dh_af_execute}    0
    Should Be Equal As Numbers    ${get_TTDH_in_dh_af_execute}    2    #trạng thái đang giao hàng
    Should Be Equal As Numbers    ${get_tongtienhang_in_dh_af_exxecute}    ${get_tongtienhang_in_dh_bf_execute}
    Should Be Equal As Numbers    ${get_khachdatra_in_dh_af_execute}    ${actual_khtt_paymented}
    Should Be Equal As Numbers    ${get_giamgia_in_dh_af_execute}    ${get_ggdh_in_dh_bf_execute}
    Should Be Equal As Numbers    ${get_tongcong_in_dh_af_execute}    ${get_tongcong_in_dh_bf_execute}
    Should Be Equal As Strings    ${get_ghichu_in_dh_af_execute}    ${get_ghichu_bf_execute}
    Validate invoice history frm Order    ${order_code}    ${invoice_code}    ${result_TTH_tru_ggdh}
    Delete invoice by invoice code    ${invoice_code}
    Delete order frm Order code    ${order_code}

edhkl12
    [Arguments]   ${list_product_tocreate}   ${list_ggsp}    ${list_discount_type}   ${input_ggdh_tocreate}      ${list_nums_addrow}   ${list_discount_addrow}   ${list_type_discount_addrow}    ${input_khtt}
    [Documentation]    1. Get thông tin của khách hàng và product (dòng 2 -7)
    ...    2. Lấy ra tổng đặt hàng và tồn kho của từng sản phẩm, tính toán
    Set Selenium Speed    0.5s
    #get info product, customer
    ${order_code}   Add new order incase discount - no payment - no customer   ${input_ggdh_tocreate}   ${list_product_tocreate}   ${list_ggsp}    ${list_discount_type}
    ${list_nums_addrow}   ${list_discount_addrow}    ${list_type_discount_addrow}   Convert three string list to composite list    ${list_nums_addrow}    ${list_discount_addrow}
    ...    ${list_type_discount_addrow}
    ${get_ma_kh}    ${get_TTDH}    ${get_tongtienhang_in_dh_bf_execute}    ${get_khachdatra_in_dh_bf_execute}    ${get_ggdh_in_dh_bf_execute}    ${get_tongcong_in_dh_bf_execute}    Get order info incase discount not note by order code    ${order_code}
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
    ${request_payload}    Format String    {{"Invoice":{{"BranchId":{0},"RetailerId":{1},"OrderId":{2},"UpdateInvoiceId":0,"UpdateReturnId":0,"SoldById":{3},"SoldBy":{{"CreatedBy":0,"CreatedDate":"2018-07-30T08:27:36.800Z","GivenName":"anh.lv","Id":{3},"IsActive":true,"IsAdmin":true,"Type":0,"isDeleted":false,"Name":"anh.lv"}},"SaleChannelId":0,"Seller":{{"CreatedBy":0,"CreatedDate":"2018-07-30T08:27:36.800Z","GivenName":"anh.lv","Id":{3},"IsActive":true,"IsAdmin":true,"Type":0,"isDeleted":false,"Name":"anh.lv"}},"PriceBookId":0,"OrderCode":"{4}","Code":"Hóa đơn 2","Discount":{5},"DiscountRatio":{6},"InvoiceDetails":[{7}],"InvoiceOrderSurcharges":[],"InvoicePromotions":[],"Payments":[{{"Method":"Cash","MethodStr":"Tiền mặt","Amount":{8},"Id":-1}}],"Status":1,"Total":{9},"Surcharge":0,"Type":1,"Uuid":"","addToAccount":"0","PayingAmount":{8},"OrderPaidAmount":0,"TotalBeforeDiscount":{10},"ProductDiscount":136999,"PaidAmount":0,"DebugUuid":"","InvoiceWarranties":[],"CreatedBy":201567}}}}     ${BRANCH_ID}    ${get_id_nguoitao}    ${get_order_id}    ${get_id_nguoiban}
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
    Should Be Equal As Strings    ${get_ma_kh_by_hd}    0
    Should Be Equal As Numbers    ${get_gghd_af_execute}    ${result_gghd}
    Should Be Equal As Strings    ${get_trangthai}    Hoàn thành
    Should Be Equal As Strings    ${get_ghichu_in_hd_af_execute}    ${get_ghichu_bf_execute}
    #assert value order
    ${get_ma_kh_in_dh_af_execute}    ${get_TTDH_in_dh_af_execute}    ${get_tongtienhang_in_dh_af_exxecute}    ${get_khachdatra_in_dh_af_execute}    ${get_giamgia_in_dh_af_execute}    ${get_tongcong_in_dh_af_execute}    ${get_ghichu_in_dh_af_execute}
    ...    Get order info have note incase discount by order code    ${order_code}
    Should Be Equal As Strings    ${get_ma_kh_in_dh_af_execute}    0
    Should Be Equal As Numbers    ${get_TTDH_in_dh_af_execute}    3    #trạng thái hoàn thành
    Should Be Equal As Numbers    ${get_tongtienhang_in_dh_af_exxecute}    ${get_tongtienhang_in_dh_bf_execute}
    Should Be Equal As Numbers    ${get_khachdatra_in_dh_af_execute}    ${actual_khtt_paymented}
    Should Be Equal As Numbers    ${get_giamgia_in_dh_af_execute}    ${get_ggdh_in_dh_bf_execute}
    Should Be Equal As Numbers    ${get_tongcong_in_dh_af_execute}    ${get_tongcong_in_dh_bf_execute}
    Should Be Equal As Strings    ${get_ghichu_in_dh_af_execute}    ${get_ghichu_bf_execute}
    Validate invoice history frm Order    ${order_code}    ${invoice_code}    ${result_TTH_tru_ggdh}
    Delete invoice by invoice code    ${invoice_code}
    Delete order frm Order code    ${order_code}
