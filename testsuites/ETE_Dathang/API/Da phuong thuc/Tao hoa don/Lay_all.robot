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
&{list_product}    KLCB017=4    KLT0017=8    KLQD017=5.2    KLDV017=3    KLSI0017=2
@{discount}       14    0    5000    25000    320000
@{discount_type}    dis    none    disvnd    changedown    changeup
&{dict_method}    Chuyển khoản=30000    Thẻ=20000    Tiền mặt=10000

*** Test Cases ***    Mã kh         List product&nums    Khtt to create    List GGSP      List discount type    GGDH    Phương thức
Lay all don hang      [Tags]        DHDPTA
                      [Template]    edhpta03
                      DHDPT003      ${list_product}      200000            ${discount}    ${discount_type}      10      ${dict_method}

*** Keywords ***
edhpta03
    [Arguments]    ${input_ma_kh}    ${list_product_tocreate}    ${input_khtt_tocreate}    ${list_ggsp}    ${list_discount_type}    ${input_gghd}
    ...    ${dict_phuongthuctt}
    Set Selenium Speed    0.5s
    #get info product, customer
    ${order_code}    Add new order with multi products    ${input_ma_kh}    ${list_product_tocreate}    ${input_khtt_tocreate}
    ${list_phuong_thuc}    Get Dictionary Keys    ${dict_phuongthuctt}
    ${list_gia_tri}    Get Dictionary Values    ${dict_phuongthuctt}
    ${get_khachdatra_in_dh_bf_execute}    ${get_tongtienhang_in_dh_bf_execute}    Get paid value frm API    ${order_code}
    ${get_list_hh_in_dh_bf_execute}    ${get_ghichu_bf_execute}    Get ghi chu and list product frm API    ${order_code}
    ${get_list_nums_in_dh}    Get list quantity by order code    ${order_code}    ${get_list_hh_in_dh_bf_execute}
    ${get_list_status}    Get list imei status thr API    ${get_list_hh_in_dh_bf_execute}
    Create list imei and other product    ${get_list_hh_in_dh_bf_execute}    ${get_list_nums_in_dh}
    ${list_result_tong_dh}    ${list_result_toncuoi}    ${result_list_thanhtien}    ${list_result_giamoi}    Get list order summary - total sale - ending stocks incase discount and newprice    ${order_code}    ${get_list_hh_in_dh_bf_execute}
    ...    ${list_ggsp}    ${list_discount_type}
    ${list_giatri_quydoi}    Get list gia tri quy doi frm product API    ${get_list_hh_in_dh_bf_execute}
    #compute TTH with product
    ${result_tongtienhang}    Sum values in list    ${result_list_thanhtien}
    ${result_tongsoluong}    Sum values in list    ${get_list_nums_in_dh}
    ${result_TTH_tru_gghd}    Run Keyword If    0 < ${input_gghd} < 100    Price after % discount invoice    ${result_tongtienhang}    ${input_gghd}
    ...    ELSE IF    ${input_gghd} > 100    Minus and replace floating point    ${result_tongtienhang}    ${input_gghd}
    ...    ELSE    Set Variable    ${result_tongtienhang}
    ${result_gghd}    Run Keyword If    0 < ${input_gghd} < 100    Convert % discount to VND and round    ${result_tongtienhang}    ${input_gghd}
    ...    ELSE    Set Variable    ${input_gghd}
    ${result_khachcantra_in_hd}    Minus and replace floating point    ${result_TTH_tru_gghd}    ${get_khachdatra_in_dh_bf_execute}
    ${actual_khachcantra}    Set Variable    ${result_khachcantra_in_hd}
    #compute invoice info to Quan ly
    ${result_khtt}    Sum values in list    ${list_gia_tri}
    ${result_khtt_all}    Sum    ${result_khtt}    ${input_khtt_tocreate}
    #compute for order
    ${result_khachthanhtoan_in_dh}    Sum and round 2    ${get_khachdatra_in_dh_bf_execute}    ${actual_khachcantra}
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
    ...    ${list_jsonpath_giaban}    ${list_ggsp}    ${list_discount_type}  
    ${liststring_prs_order_detail}    Set Variable    needdel
    Log    ${liststring_prs_order_detail}
    : FOR    ${item_gia_ban}    ${item_id_sp}    ${item_soluong}    ${item_imei}    ${item_result_ggsp}    ${item_ggsp}
    ...    ${item_orderdetail_id}    IN ZIP    ${list_giaban}    ${list_id_sp}    ${get_list_nums_in_dh}    ${imei_inlist}
    ...    ${list_result_ggsp}    ${list_ggsp}    ${get_list_order_detail_id}
    \    ${item_imei}    Convert list to string and return    ${item_imei}
    \    ${item_ggsp}    Set Variable If    0 < ${item_ggsp} < 100    ${item_ggsp}    0
    \    ${payload_each_product}    Format string    {{"BasePrice":175000,"IsLotSerialControl":true,"IsRewardPoint":false,"Note":"","Price":{0},"ProductId":{1},"Quantity":{2},"ProductCode":"SI059","SerialNumbers":"{3}","Discount":{4},"DiscountRatio":{5},"ProductName":"Tủ Lạnh Inverter Panasonic NR-BL267VSV1","PriceByPromotion":null,"IsMaster":true,"PromotionParentProductId":null,"ProductBatchExpireId":null,"CategoryId":543560,"MasterProductId":{1},"Unit":"","Uuid":"","OrderDetailId":{6},"ProductWarranty":[]}}    ${item_gia_ban}    ${item_id_sp}    ${item_soluong}
    \    ...    ${item_imei}    ${item_result_ggsp}    ${item_ggsp}    ${item_orderdetail_id}
    \    ${liststring_prs_order_detail}    Catenate    SEPARATOR=,    ${liststring_prs_order_detail}    ${payload_each_product}
    ${liststring_prs_order_detail}    Replace String    ${liststring_prs_order_detail}    needdel,    ${EMPTY}    count=1
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
    ${giamgia_hd}    Set Variable If    0 < ${input_gghd} < 100    ${input_gghd}    0
    ${request_payload}    Format String    {{"Invoice":{{"BranchId":{0},"RetailerId":{1},"OrderId":{2},"CustomerId":{13},"SoldById":{3},"SoldBy":{{"CreatedBy":0,"CreatedDate":"2018-12-10T10:44:15.970Z","Email":"","GivenName":"admin","Id":{3},"IsActive":true,"IsAdmin":true,"Type":0,"UserName":"admin","isDeleted":false,"Name":"admin"}},"SaleChannelId":0,"Seller":{{"CreatedBy":0,"CreatedDate":"2018-12-10T10:44:15.970Z","Email":"","GivenName":"admin","Id":{3},"IsActive":true,"IsAdmin":true,"Type":0,"UserName":"admin","isDeleted":false,"Name":"admin"}},"PriceBookId":0,"OrderCode":"{4}","Code":"Hóa đơn 1","Discount":{5},"DiscountRatio":{6},"InvoiceDetails":[{7}],"InvoiceOrderSurcharges":[],"InvoicePromotions":[],"Payments":[{8}],"Status":1,"Total":{9},"Surcharge":0,"Type":1,"Uuid":"W156396619193254","addToAccount":"0","PayingAmount":{10},"OrderPaidAmount":{11},"DepositReturn":0,"TotalBeforeDiscount":{12},"ProductDiscount":384000,"PaidAmount":1000000,"DebugUuid":"","InvoiceWarranties":[],"CreatedBy":201567}}}}    ${BRANCH_ID}    ${get_id_nguoitao}    ${get_order_id}    ${get_id_nguoiban}
    ...    ${order_code}    ${result_gghd}    ${giamgia_hd}    ${liststring_prs_order_detail}    ${liststring_paymens}    ${result_TTH_tru_gghd}
    ...    ${result_khtt}    ${get_khachdatra_in_dh_bf_execute}    ${result_tongtienhang}    ${get_id_kh}
    Log    ${request_payload}
    ${invoice_code}    Post request to create invoice and get invoice code    ${request_payload}
    Sleep    20 s    wait for response to API
    #validate so quy
    ${list_phuong_thuc_valdate_dh}    Copy List    ${list_phuong_thuc}
    ${list_gia_tri_validate_dh}    Copy List    ${list_gia_tri}
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
    #validate tab LSTT dat hang
    ${get_ma_phieutt_in_dh}    Get ma phieu thanh toan dat hang frm API    ${order_code}
    Append To List    ${list_phuong_thuc_valdate_dh}    ${get_ma_phieutt_in_dh}
    Append To List    ${list_gia_tri_validate_dh}    ${input_khtt_tocreate}
    ${get_list_ma_phieu_tt_validate_dh}    ${get_list_phuongthuc_tt_validate_dh}    ${get_list_tienthu_tt_validate_dh}    Get receipt number - method - amount in tab Lich su thanh toan dat hang thr API    ${order_code}
    : FOR    ${item_phuong_thuc}    ${item_gia_tri}    ${item_ma_phieu}    ${item_result_tienthu}    ${item_result_phuongthuc}    IN ZIP
    ...    ${list_phuong_thuc_valdate_dh}    ${list_gia_tri_validate_dh}    ${get_list_ma_phieu_tt_validate_dh}    ${get_list_tienthu_tt_validate_dh}    ${get_list_phuongthuc_tt_validate_dh}
    \    ${item_phuong_thuc}    Run Keyword If    '${item_phuong_thuc}'=='Thẻ'    Set Variable    Card
    \    ...    ELSE IF    '${item_phuong_thuc}'=='Chuyển khoản'    Set Variable    Transfer
    \    ...    ELSE    Set Variable    Cash
    \    Should Be Equal As Strings    ${item_phuong_thuc}    ${item_result_phuongthuc}
    \    Should Be Equal As Numbers    ${item_gia_tri}    ${item_result_tienthu}
    \    Validate So quy info if Order is paid    ${item_ma_phieu}    ${item_gia_tri}
    #
    ${get_ma_kh_by_hd}    ${get_tong_tien_hang}    ${get_khachtt_af_execute}    ${get_gghd_af_execute}    ${get_khachcantra}    ${get_trangthai}    ${get_ghichu_in_hd_af_execute}
    ...    Get invoice info have note incase discount by invoice code    ${invoice_code}
    Run Keyword If    ${input_gghd} == 0    Should Be Equal As Numbers    ${get_khachcantra}    ${result_tongtienhang}
    ...    ELSE    Should Be Equal As Numbers    ${get_tong_tien_hang}    ${result_tongtienhang}
    Run Keyword If    ${input_gghd} == 0    Log    Ignore validate
    ...    ELSE    Should Be Equal As Numbers    ${get_tong_tien_hang}    ${result_tongtienhang}
    Should Be Equal As Numbers    ${get_khachcantra}    ${result_TTH_tru_gghd}
    Should Be Equal As Numbers    ${get_khachtt_af_execute}    ${result_khtt_all}
    Should Be Equal As Strings    ${get_ma_kh_by_hd}    ${input_ma_kh}
    Should Be Equal As Numbers    ${get_gghd_af_execute}    ${result_gghd}
    Should Be Equal As Strings    ${get_trangthai}    Hoàn thành
    Should Be Equal As Strings    ${get_ghichu_in_hd_af_execute}    ${get_ghichu_bf_execute}
    #assert value order
    ${get_ma_kh_in_dh_af_execute}    ${get_TTDH_in_dh_af_execute}    ${get_tongtienhang_in_dh_af_exxecute}    ${get_khachdatra_in_dh_af_execute}    ${get_ghichu_af_execute}    Get order info have note by order code    ${order_code}
    Should Be Equal As Strings    ${get_ma_kh_in_dh_af_execute}    ${input_ma_kh}
    Should Be Equal As Strings    ${get_TTDH_in_dh_af_execute}    3    #trạng thái hoàn thành
    Should Be Equal As Numbers    ${get_tongtienhang_in_dh_af_exxecute}    ${get_tongtienhang_in_dh_bf_execute}
    Should Be Equal As Numbers    ${get_khachdatra_in_dh_af_execute}    ${result_khtt_all}
    Should Be Equal As Strings    ${get_ghichu_af_execute}    ${get_ghichu_bf_execute}
    Validate invoice history frm Order    ${order_code}    ${invoice_code}    ${result_TTH_tru_gghd}
    Delete invoice by invoice code    ${invoice_code}
    Delete order frm Order code    ${order_code}
