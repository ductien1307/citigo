*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}      ${headless_browser}
Library           SeleniumLibrary
Library           Collections
Resource          ../../../../../core/API/api_danhmuc_hanghoa.robot
Resource          ../../../../../core/API/api_dathang.robot
Resource          ../../../../../core/API/api_khachhang.robot
Resource          ../../../../../core/API/api_mhbh.robot
Resource          ../../../../../core/Dat_Hang/dat_hang_action.robot
Resource          ../../../../../core/Dat_Hang/dat_hang_navigation.robot
Resource          ../../../../../core/Dat_Hang/dat_hang_page.robot
Resource          ../../../../../core/Ban_Hang/banhang_action.robot
Resource          ../../../../../core/Ban_Hang/banhang_page.robot
Resource          ../../../../../core/Ban_Hang/banhang_navigation.robot
Resource          ../../../../../core/share/toast_message.robot
Resource          ../../../../../core/API/api_soquy.robot
Resource          ../../../../../core/share/javascript.robot
Resource          ../../../../../core/share/list_dictionary.robot
Resource          ../../../../../core/share/discount.robot
Resource          ../../../../../core/API/api_mhbh_dathang.robot
Resource          ../../../../../core/API/api_hoadon_banhang.robot
Resource          ../../../../../core/share/imei.robot
Resource          ../../../../../core/share/computation.robot
Resource          ../../../../../config/env_product/envi.robot
Resource          ../../../../../core/API/api_thietlap.robot

*** Variables ***
&{list_product}    KLCB018=7     KLDV018=3        KLQD018=4   KLSI0018=2    KLT0018=3.6
&{list_product_delete}    KLCB018=7    KLT0018=3.6
@{discount}       15    0    1000    5000    225000
@{discount_type}    dis    none    disvnd    changedown    changeup
&{dict_method}    Chuyển khoản=50000    Thẻ=40000    Tiền mặt=10000
&{discount_del}    KLCB018=15    KLT0018=0
&{discount_type_del}    KLCB018=dis    KLT0018=none

*** Test Cases ***    Ma kh         List product&nums delete    GGDH    List product&nums    List GGSP      List discount type    Phuong thuc       Voucher
Lay 1 phan don hang
                      [Tags]        DHDPTA
                      [Template]    edhpta04
                      DHDPT004      ${list_product_delete}      20      ${list_product}      ${discount}    ${discount_type}      ${dict_method}    ${discount_del}    ${discount_type_del}

*** Keywords ***
edhpta04
    [Arguments]    ${input_ma_kh}    ${list_product_delete}    ${input_ggdh_tocreate}    ${list_product_tocreate}    ${list_ggsp_tocreate}    ${list_discount_type_tocreate}
    ...    ${dict_phuongthuctt}    ${list_ggsp_delete}    ${list_discount_type_del}
    Set Selenium Speed    0.5s
    #get info product, customer
    ${order_code}    Add new order incase changing price - no payment    ${input_ma_kh}    ${input_ggdh_tocreate}    ${list_product_tocreate}    ${list_ggsp_tocreate}    ${list_discount_type_tocreate}
    ${list_product_del}    Get Dictionary Keys    ${list_product_delete}
    ${list_nums_del}    Get Dictionary Values    ${list_product_delete}
    ${list_phuong_thuc}    Get Dictionary Keys    ${dict_phuongthuctt}
    ${list_gia_tri}    Get Dictionary Values    ${dict_phuongthuctt}
    ${list_discount_del}    Get Dictionary Values    ${list_ggsp_delete}
    ${list_disscount_type_del}    Get Dictionary Values    ${list_discount_type_del}
    ${get_ma_kh}    ${get_TTDH}    ${get_tongtienhang_in_dh_bf_execute}    ${get_khachdatra_in_dh_bf_execute}    ${get_ggdh_in_dh_bf_execute}    ${get_tongcong_in_dh_bf_execute}    Get order info incase discount not note by order code
    ...    ${order_code}
    ${get_list_hh_in_dh_bf_execute}    ${get_ghichu_bf_execute}    Get ghi chu and list product frm API    ${order_code}
    ${list_result_tongdh_delete}    Get list order summary frm product API    ${list_product_delete}
    #get order summary and sub total of products
    : FOR    ${ma_hh}    ${discount_type_delete}    ${discount_del}    IN ZIP    ${list_product_del}    ${list_disscount_type_del}
    ...    ${list_discount_del}
    \    Remove Values From List    ${get_list_hh_in_dh_bf_execute}    ${ma_hh}
    \    Remove Values From List    ${list_discount_type_tocreate}    ${discount_type_delete}
    \    Remove Values From List    ${list_ggsp_tocreate}    ${discount_del}
    Log    ${get_list_hh_in_dh_bf_execute}
    Log    ${list_discount_type_tocreate}
    Log    ${list_ggsp_tocreate}
    ${get_list_nums_in_dh}    Get list quantity by order code    ${order_code}    ${get_list_hh_in_dh_bf_execute}
    ${get_list_status}    Get list imei status thr API    ${get_list_hh_in_dh_bf_execute}
    Create list imei and other product    ${get_list_hh_in_dh_bf_execute}    ${get_list_nums_in_dh}
    ${list_result_tongdh}    ${result_list_toncuoi}    ${result_list_thanhtien}    Get list order summary - total sale - ending stocks frm API    ${order_code}    ${get_list_hh_in_dh_bf_execute}
    #compute invoice info
    ${result_tongtienhang}    Sum values in list    ${result_list_thanhtien}
    ${result_tongsoluong}    Sum values in list    ${get_list_nums_in_dh}
    ${result_TTH_tru_ggdh}    Run Keyword If    0 < ${get_ggdh_in_dh_bf_execute} < 100    Price after % discount invoice    ${result_tongtienhang}    ${get_ggdh_in_dh_bf_execute}
    ...    ELSE IF    ${get_ggdh_in_dh_bf_execute} > 100    Minus and replace floating point    ${result_tongtienhang}    ${get_ggdh_in_dh_bf_execute}
    ...    ELSE    Set Variable    ${result_tongtienhang}
    ${result_ggdh}    Run Keyword If    0 < ${get_ggdh_in_dh_bf_execute} < 100    Convert % discount to VND and round    ${result_tongtienhang}    ${get_ggdh_in_dh_bf_execute}
    ...    ELSE    Set Variable    ${get_ggdh_in_dh_bf_execute}
    ${result_khachcantra}    Minus and replace floating point    ${result_TTH_tru_ggdh}    ${get_khachdatra_in_dh_bf_execute}
    ${actual_khtt}    Sum values in list    ${list_gia_tri}
    #compute order info
    ${actual_khtt_paymented}    Sum and replace floating point    ${actual_khtt}    ${get_khachdatra_in_dh_bf_execute}
    #create invoice frm Order
    ${get_order_id}    ${get_payment_id}    Get order - payment frm order api    ${order_code}
    ${get_list_order_detail_id}    Get list orderdetail id frm order api    ${order_code}    ${get_list_hh_in_dh_bf_execute}
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${get_id_kh}    Get customer id thr API    ${input_ma_kh}
    ${endpoint_danhmuc_hh_co_dvt}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${get_resp_danhmuc_hh}    Get Request and return body    ${endpoint_danhmuc_hh_co_dvt}
    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}    Get list jsonpath product frm list product    ${get_list_hh_in_dh_bf_execute}
    ${list_giaban}    ${list_result_ggsp}    ${list_id_sp}    Get product info frm list jsonpath product incase discount product    ${get_resp_danhmuc_hh}    ${list_jsonpath_id_sp}
    ...    ${list_jsonpath_giaban}    ${list_ggsp_tocreate}    ${list_discount_type_tocreate}
    ${liststring_prs_order_detail}    Set Variable    needdel
    Log    ${liststring_prs_order_detail}
    : FOR    ${item_gia_ban}    ${item_id_sp}    ${item_soluong}    ${item_result_ggsp}    ${item_ggsp}    ${item_orderdetail_id}
    ...    ${item_imei}    IN ZIP    ${list_giaban}    ${list_id_sp}    ${get_list_nums_in_dh}    ${list_result_ggsp}
    ...    ${list_ggsp_tocreate}    ${get_list_order_detail_id}    ${imei_inlist}
    \    ${item_ggsp}    Set Variable If    0 < ${item_ggsp} < 100    ${item_ggsp}    0
    \    ${item_imei}    Convert list to string and return    ${item_imei}
    \    ${payload_each_product}    Format string    {{"BasePrice":175000,"IsLotSerialControl":true,"IsRewardPoint":false,"Note":"","Price":{0},"ProductId":{1},"Quantity":{2},"ProductCode":"SI059","SerialNumbers":"{3}","Discount":{4},"DiscountRatio":{5},"ProductName":"Tủ Lạnh Inverter Panasonic NR-BL267VSV1","PriceByPromotion":null,"IsMaster":true,"PromotionParentProductId":null,"ProductBatchExpireId":null,"CategoryId":543560,"MasterProductId":{1},"Unit":"","Uuid":"","OrderDetailId":{6},"ProductWarranty":[]}}    ${item_gia_ban}    ${item_id_sp}    ${item_soluong}
    \    ...    ${item_imei}    ${item_result_ggsp}    ${item_ggsp}    ${item_orderdetail_id}
    \    ${liststring_prs_order_detail}    Catenate    SEPARATOR=,    ${liststring_prs_order_detail}    ${payload_each_product}
    ${liststring_prs_order_detail}    Replace String    ${liststring_prs_order_detail}    needdel,    ${EMPTY}    count=1
    #
    ${liststring_paymens}    Set Variable    needdel
    : FOR    ${item_phuong_thuc}    ${item_gia_tri}    IN ZIP    ${list_phuong_thuc}    ${list_gia_tri}
    \    ${item_method}    Run Keyword If    '${item_phuong_thuc}'=='Thẻ'    Set Variable    Card
    \    ...    ELSE IF    '${item_phuong_thuc}'=='Chuyển khoản'    Set Variable    Transfer
    \    ...    ELSE    Set Variable    Cash
    \    ${item_method_id}    Run Keyword If    '${item_phuong_thuc}'=='Thẻ'    Set Variable    -2
    \    ...    ELSE IF    '${item_phuong_thuc}'=='Chuyển khoản'    Set Variable    -1
    \    ...    ELSE    Set Variable    -3
    \    ${payload_each_payment}    Format String    {{"Method":"{0}","MethodStr":"{1}","Amount":{2},"Id":{3},"AccountId":0,"UsePoint":null}}    ${item_method}    ${item_phuong_thuc}    ${item_gia_tri}
    \    ...    ${item_method_id}
    \    ${liststring_paymens}    Catenate    SEPARATOR=,    ${liststring_paymens}    ${payload_each_payment}
    ${liststring_paymens}    Replace String    ${liststring_paymens}    needdel,    ${EMPTY}    count=1
    #
    ${giamgia_dh}    Set Variable If    0 < ${get_ggdh_in_dh_bf_execute} < 100    ${get_ggdh_in_dh_bf_execute}    0
    ${request_payload}    Format String    {{"Invoice":{{"BranchId":{0},"RetailerId":{1},"OrderId":{2},"CustomerId":{13},"SoldById":{3},"SoldBy":{{"CreatedBy":0,"CreatedDate":"2018-12-10T10:44:15.970Z","Email":"","GivenName":"admin","Id":{3},"IsActive":true,"IsAdmin":true,"Type":0,"UserName":"admin","isDeleted":false,"Name":"admin"}},"SaleChannelId":0,"Seller":{{"CreatedBy":0,"CreatedDate":"2018-12-10T10:44:15.970Z","Email":"","GivenName":"admin","Id":{3},"IsActive":true,"IsAdmin":true,"Type":0,"UserName":"admin","isDeleted":false,"Name":"admin"}},"PriceBookId":0,"OrderCode":"{4}","Code":"Hóa đơn 1","Discount":{5},"DiscountRatio":{6},"InvoiceDetails":[{7}],"InvoiceOrderSurcharges":[],"InvoicePromotions":[],"Payments":[{8}],"Status":1,"Total":{9},"Surcharge":0,"Type":1,"Uuid":"W156396619193254","addToAccount":"0","PayingAmount":{10},"OrderPaidAmount":{11},"DepositReturn":0,"TotalBeforeDiscount":{12},"ProductDiscount":384000,"PaidAmount":1000000,"DebugUuid":"","InvoiceWarranties":[],"CreatedBy":201567}}}}    ${BRANCH_ID}    ${get_id_nguoitao}    ${get_order_id}    ${get_id_nguoiban}
    ...    ${order_code}    ${result_ggdh}    ${giamgia_dh}    ${liststring_prs_order_detail}    ${liststring_paymens}    ${result_TTH_tru_ggdh}
    ...    ${actual_khtt}    ${get_khachdatra_in_dh_bf_execute}    ${result_tongtienhang}    ${get_id_kh}
    Log    ${request_payload}
    Log    ${request_payload}
    ${invoice_code}    Post request to create invoice and get invoice code    ${request_payload}
    Sleep    20 s    wait for response to API
    #assert value invoice
    ${get_ma_kh_by_hd}    ${get_tong_tien_hang}    ${get_khachtt_af_execute}    ${get_gghd_af_execute}    ${get_khachcantra}    ${get_trangthai}    ${get_ghichu_in_hd_af_execute}
    ...    Get invoice info have note incase discount by invoice code    ${invoice_code}
    Run Keyword If    ${get_ggdh_in_dh_bf_execute} == 0    Should Be Equal As Numbers    ${get_khachcantra}    ${result_tongtienhang}
    ...    ELSE    Should Be Equal As Numbers    ${get_tong_tien_hang}    ${result_tongtienhang}
    Run Keyword If    ${get_ggdh_in_dh_bf_execute} == 0    Log    Ignore validate
    ...    ELSE    Should Be Equal As Numbers    ${get_tong_tien_hang}    ${result_tongtienhang}
    Should Be Equal As Numbers    ${get_khachcantra}    ${result_khachcantra}
    Should Be Equal As Numbers    ${get_khachtt_af_execute}    ${actual_khtt}
    Should Be Equal As Strings    ${get_ma_kh_by_hd}    ${input_ma_kh}
    Should Be Equal As Numbers    ${get_gghd_af_execute}    ${result_ggdh}
    Should Be Equal As Strings    ${get_trangthai}    Hoàn thành
    Should Be Equal As Strings    ${get_ghichu_in_hd_af_execute}    ${get_ghichu_bf_execute}
    #assert value order
    ${get_ma_kh_in_dh_af_execute}    ${get_TTDH_in_dh_af_execute}    ${get_tongtienhang_in_dh_af_exxecute}    ${get_khachdatra_in_dh_af_execute}    ${get_giamgia_in_dh_af_execute}    ${get_tongcong_in_dh_af_execute}    ${get_ghichu_in_dh_af_execute}
    ...    Get order info have note incase discount by order code    ${order_code}
    Should Be Equal As Strings    ${get_ma_kh_in_dh_af_execute}    ${input_ma_kh}
    Should Be Equal As Numbers    ${get_TTDH_in_dh_af_execute}    2    #trạng thái đang giao hàng
    Should Be Equal As Numbers    ${get_tongtienhang_in_dh_af_exxecute}    ${get_tongtienhang_in_dh_bf_execute}
    Should Be Equal As Numbers    ${get_khachdatra_in_dh_af_execute}    ${actual_khtt_paymented}
    Should Be Equal As Numbers    ${get_giamgia_in_dh_af_execute}    ${get_ggdh_in_dh_bf_execute}
    Should Be Equal As Numbers    ${get_tongcong_in_dh_af_execute}    ${get_tongcong_in_dh_bf_execute}
    Should Be Equal As Strings    ${get_ghichu_in_dh_af_execute}    ${get_ghichu_bf_execute}
    Validate invoice history frm Order    ${order_code}    ${invoice_code}    ${result_TTH_tru_ggdh}
    #validate so quy
    ${get_list_ma_phieu_tt}    ${get_list_phuongthuc_tt}    ${get_list_tienthu_tt}    Get receipt number - method - amount in tab Lich su thanh toan hoa don thr API    ${invoice_code}
    : FOR    ${item_phuong_thuc}    ${item_gia_tri}    ${item_ma_phieu}    ${item_result_tienthu}    ${item_result_phuongthuc}    IN ZIP
    ...    ${list_phuong_thuc}    ${list_gia_tri}    ${get_list_ma_phieu_tt}    ${get_list_tienthu_tt}    ${get_list_phuongthuc_tt}
    \    ${item_phuong_thuc}    Run Keyword If    '${item_phuong_thuc}'=='Thẻ'    Set Variable    Card
    \    ...    ELSE IF    '${item_phuong_thuc}'=='Chuyển khoản'    Set Variable    Transfer
    \    ...    ELSE    Set Variable    Cash
    \    Should Be Equal As Strings    ${item_phuong_thuc}    ${item_result_phuongthuc}
    \    Should Be Equal As Numbers    ${item_gia_tri}    ${item_result_tienthu}
    \    Validate status in Tab No can thu tu khach if Invoice is paid until success    ${input_ma_kh}    ${item_ma_phieu}    ${invoice_code}
    \    Validate So quy info from Rest API if Invoice is paid until success    ${item_ma_phieu}    ${item_gia_tri}
    #
    Delete invoice by invoice code    ${invoice_code}
    Delete order frm Order code    ${order_code}
