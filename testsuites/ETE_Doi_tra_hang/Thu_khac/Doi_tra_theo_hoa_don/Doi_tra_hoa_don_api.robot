*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    ${headless_browser}
Test Setup
Test Teardown     After Test
Library           Collections
Library           BuiltIn
Resource          ../../../../core/API/api_khachhang.robot
Resource          ../../../../core/Ban_Hang/banhang_action.robot
Resource          ../../../../core/Tra_hang/tra_hang_action.robot
Resource          ../../../../core/Tra_hang/tra_hang_page.robot
Resource          ../../../../core/API/api_soquy.robot
Resource          ../../../../config/env_product/envi.robot
Resource          ../../../../core/Ban_Hang/banhang_page.robot
Resource          ../../../../core/Tra_hang/doi_tra_hang_action.robot
Resource          ../../../../core/share/toast_message.robot

*** Variables ***
&{list_productnums_TH2}    DTH007=2
&{list_productnums_DTH02}    DTH002=3    QDDT3=2.4    DTDV2=1.25    DTCombo02=2
&{list_imei_dth2}    DTS02=1
@{list_discount}    0    600000    3500    6100
@{list_discount_type}   none    changeup     disvnd    changedown
@{list_surcharge1}    TK001      TK002

*** Test Cases ***    Mã KH         List product trả hàng      List product đổi trả hàng    List imei            Phí trả hàng    List GGSP      List discount type           GGSP IMEI    Discount type imei        GGDTH    Khách thanh toán    KTT hóa đơn    Thu khác
Thu_khac             [Tags]        AETDS
                      [Template]    edts01
                      CTKH045       ${list_productnums_TH2}    ${list_productnums_DTH02}    ${list_imei_dth2}    30000              ${list_discount}     ${list_discount_type}      20000      disvnd          10000        100000         0         ${list_surcharge1}

*** Keywords ***
edts01
    [Arguments]    ${input_ma_kh}    ${dic_productnums_th}    ${dic_productnums_dth}    ${list_imei_nums}    ${input_phi_th}    ${list_ggsp}    ${list_discounttype}
    ...    ${input_ggsp_imei}   ${discount_type_imei}    ${input_ggdth}    ${input_khtt}    ${input_khtt_hd}  ${list_thukhac}
    ${list_product_dth}    Get Dictionary Keys    ${dic_productnums_dth}
    ${list_nums_dth}    Get Dictionary Values    ${dic_productnums_dth}
    ${list_imei_product_dth}    Get Dictionary Keys    ${list_imei_nums}
    ${list_imei_nums_dth}    Get Dictionary Values    ${list_imei_nums}
    ${list_product_th}    Get Dictionary Keys    ${dic_productnums_th}
    ${list_nums_th}    Get Dictionary Values    ${dic_productnums_th}
    ${input_product_imei}    ${input_imei_nums}    Convert two list to string and return    ${list_imei_product_dth}    ${list_imei_nums_dth}
    Create list imei    ${list_imei_product_dth}    ${list_imei_nums_dth}
    ${get_ma_hd}    Add new invoice frm API    ${input_ma_kh}    ${dic_productnums_th}    ${input_khtt_hd}
    ${list_actual_surcharge_value}    Create List
    : FOR    ${item_thukhac}    IN ZIP    ${list_thukhac}
    \    ${surcharge_value_vnd}    Get surcharge vnd value    ${item_thukhac}
    \    ${surcharge_value_percentage}    Get surcharge percentage value    ${item_thukhac}
    \    ${actual_surcharge_value}    Set Variable If    ${surcharge_value_percentage} == 0    ${surcharge_value_vnd}    ${surcharge_value_percentage}
    \    Run Keyword If    ${actual_surcharge_value} > 100    Toggle surcharge VND    ${item_thukhac}    true
    \    ...    ELSE    Toggle surcharge percentage    ${item_thukhac}    true
    \    Append To List    ${list_actual_surcharge_value}    ${actual_surcharge_value}
    Log    ${list_actual_surcharge_value}
    #get data frm Trả hàng
    Sleep    5s
    ${get_ma_kh_by_hd_bf_ex}    ${get_tong_tien_hang_bf_ex}    ${get_khach_tt_bf_ex}    ${get_trangthai_bf_ex}    Get invoice info by invoice code    ${get_ma_hd}
    ${get_list_hh_in_hd}    ${get_list_sl_in_hd}    Get list product and quantity frm invoice API    ${get_ma_hd}
    ${get_list_sl_in_hd}    Convert String to List    ${get_list_sl_in_hd}
    ${list_result_thanhtien_th}    ${list_giavon_th}    ${list_result_toncuoi_th}    Get list total sale - endingstock - cost frm product api    ${get_list_hh_in_hd}    ${get_list_sl_in_hd}
    ${get_list_baseprice}    Get list of Baseprice by Product Code    ${list_product_dth}
    #get data frm Doi hang
    Append To List    ${list_product_dth}    ${input_product_imei}
    Append to List    ${list_nums_dth}    ${input_imei_nums}
    Append to List    ${list_ggsp}    ${input_ggsp_imei}
    Append to List    ${list_discounttype}    ${discount_type_imei}
    ${list_result_thanhtien_dth}    ${list_giavon_dth}    ${list_result_toncuoi_dth}    Get list total sale - endingstock - cost incase discount and newprice with additional invoice    ${list_product_dth}
    ...    ${list_nums_dth}    ${list_ggsp}    ${list_discounttype}
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
    ${list_result_thukhac}    Create List
    : FOR    ${item_value}    IN ZIP    ${list_actual_surcharge_value}
    \    ${result_thukhac}    Run Keyword If    ${item_value}>100    Set Variable    ${item_value}
    \    ...    ELSE    Convert % discount to VND and round    ${item_value}    ${result_tongtienmua_tru_gg}
    \    Append To List    ${list_result_thukhac}    ${result_thukhac}
    Log    ${list_result_thukhac}
    ${total_surcharge}    Sum values in list    ${list_result_thukhac}
    ${result_tongtienmua_thukhac}    sum    ${result_tongtienmua_tru_gg}    ${total_surcharge}
    ${result_khachthanhtoan}    Minus and round 2    ${result_tongtienmua_thukhac}    ${result_tongtientra_tru_phith}
    ${result_cantrakhach}    Minus and round 2    ${result_tongtientra_tru_phith}    ${result_tongtienmua_thukhac}
    ${result_kh_canthanhtoan}    Set Variable If    ${result_tongtienmua_thukhac}<${result_tongtientra_tru_phith}    ${result_cantrakhach}    ${result_khachthanhtoan}
    ${result_khtt}    Set Variable If    "${input_khtt}" == "all"    ${result_kh_canthanhtoan}    ${input_khtt}
    ${actual_khtt}    Set Variable If    "${input_khtt}" == "0"    0    ${result_khtt}
    ${actuall_trahang}    Set Variable If    ${result_tongtienmua_tru_gg}<${result_tongtientra_tru_phith}    ${actual_khtt}    0
    ${result_tongtienmua_tovalidate}    Sum    ${result_tongtienmua}    ${total_surcharge}
    #create đổi trả hàng
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${jsonpath_id_kh}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_kh}
    ${get_id_kh}    Get data from API    ${endpoint_khachhang}    ${jsonpath_id_kh}
    ${endpoint_danhmuc_hh_co_dvt}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${get_resp_danhmuc_hh}    Get Request and return body    ${endpoint_danhmuc_hh_co_dvt}
    ${get_invoice_id}    Get invoice id    ${get_ma_hd}
    ${get_invoice_detail_id}    Get invoice detail id    ${get_ma_hd}
    ${get_list_imei_status}    Get list imei status thr API    ${list_product_dth}
    ##tra hang
    ${list_jsonpath_id_sp_th}    ${list_jsonpath_giaban_th}    Get list jsonpath product frm list product    ${list_product_th}
    ${list_giaban_th}    ${list_id_sp_th}    Get product info frm list jsonpath product    ${get_resp_danhmuc_hh}    ${list_jsonpath_id_sp_th}    ${list_jsonpath_giaban_th}
    ${liststring_prs_return_detail}    Set Variable    needdel
    : FOR    ${item_product_id_th}    ${item_price_th}    ${item_num_th}    IN ZIP    ${list_id_sp_th}    ${list_giaban_th}    ${list_nums_th}
    \    ${payload_each_product_th}    Format string    {{"BasePrice":{0},"IsLotSerialControl":false,"Note":"","Price":{0},"ProductId":{1},"Quantity":{2},"SerialNumbers":"","SellPrice":{0},"ProductName":"Bánh xu kem Nhật","CopiedPrice":{0},"InvoiceDetailId":{3},"IsMaster":true,"ProductBatchExpireId":null}}    ${item_price_th}
    \    ...    ${item_product_id_th}    ${item_num_th}    ${get_invoice_detail_id}
    \    ${liststring_prs_return_detail}    Catenate    SEPARATOR=,    ${liststring_prs_return_detail}    ${payload_each_product_th}
    Log    ${liststring_prs_return_detail}
    ${liststring_prs_return_detail}    Replace String    ${liststring_prs_return_detail}    needdel,    ${EMPTY}    count=1
    #doi tra hang
    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}    Get list jsonpath product frm list product     ${list_product_dth}
    ${list_giaban}    ${list_result_ggsp}    ${list_id_sp}     Get product info frm list jsonpath product incase discount product    ${get_resp_danhmuc_hh}    ${list_jsonpath_id_sp}
    ...    ${list_jsonpath_giaban}    ${list_ggsp}    ${list_discounttype}
    ${liststring_prs_invoice_detail}    Set Variable    needdel
    ${liststring_prs_invoice_detail1}    Set Variable    needdel
    ${list_imei}    Convert list to string and return    ${imei_inlist}
    : FOR    ${item_product_id}    ${item_price}    ${item_num}   ${item_ggsp}    ${item_result_discountproduct}    ${item_status}    IN ZIP    ${list_id_sp}
    ...    ${list_giaban}    ${list_nums_dth}   ${list_ggsp}    ${list_result_ggsp}    ${get_list_imei_status}
    \    ${item_imei}    Set Variable If    ${item_status}==0    ${EMPTY}    ${list_imei}
    \    ${item_dis_ratio}    Set Variable If    0<${item_ggsp}<100 and '${item_ggsp}'=='dis'    ${item_ggsp}    null
    \    ${payload_each_product}    Format string    {{"ProductId":{0},"ProductName":"chuột quang hồng","ProductFullName":"chuột quang hồng","ProductNameNoUnit":"chuột quang hồng","ProductAttributeLabel":"","ProductSName":"chuột quang hồng","ProductCode":"NS01","ProductType":2,"ProductCategoryId":173814,"MasterProductId":9326934,"OnHand":17,"OnOrder":0,"Reserved":0,"Price":{1},"Unit":"","Note":"","PromotionReceiverQty":1,"Quantity":{2},"ProductSerials":[],"Serials":[],"IsLotSerialControl":true,"IsRewardPoint":false,"CurrentQuery":"ns","CategoryId":173814,"Promotions":[],"Discount":{3},"DiscountRatio":{4},"BasePrice":{1},"DuplicationCartItems":[],"isDeleted":false,"ProductShelves":[],"AllowSale":true,"ProductWarranty":[],"Formulas":null,"Uuid":"","CartType":3,"Units":[],"MaxQuantity":null,"SerialNumbers":"{5}","discountRatioPriceWoRound":{4},"discountPriceWoRound":{3}}}    ${item_product_id}    ${item_price}    ${item_num}
    \    ...    ${item_result_discountproduct}    ${item_dis_ratio}    ${item_imei}
    \    ${payload_each_product_1}    Format string    {{"BasePrice":{0},"IsLotSerialControl":true,"IsRewardPoint":false,"Note":"","Price":{0},"ProductId":{1},"Quantity":{2},"SerialNumbers":"{3}","Discount":{4},"DiscountRatio":{5},"ProductName":"chuột quang hồng","ProductCode":"NS01","ProductBatchExpireId":null,"Uuid":""}}    ${item_price}    ${item_product_id}    ${item_num}
    \    ...    ${item_imei}    ${item_result_discountproduct}    ${item_dis_ratio}
    \    ${liststring_prs_invoice_detail}    Catenate    SEPARATOR=,    ${liststring_prs_invoice_detail}    ${payload_each_product}
    \    ${liststring_prs_invoice_detail1}    Catenate    SEPARATOR=,    ${liststring_prs_invoice_detail1}    ${payload_each_product_1}
    Log    ${liststring_prs_invoice_detail}
    Log    ${liststring_prs_invoice_detail1}
    ${liststring_prs_invoice_detail}    Replace String    ${liststring_prs_invoice_detail}    needdel,    ${EMPTY}    count=1
    ${liststring_prs_invoice_detail1}    Replace String    ${liststring_prs_invoice_detail1}    needdel,    ${EMPTY}    count=1
    ##thu khac
    ${list_id_thukhac}    Create List
    ${list_thutu_thukhac}    Create List
    : FOR    ${item_thukhac}    IN ZIP    ${list_thukhac}
    \    ${get_id_thukhac}    ${get_thutu_thukhac}    Get Id and order surchage    ${item_thukhac}
    \    Append To List    ${list_id_thukhac}    ${get_id_thukhac}
    \    Append To List    ${list_thutu_thukhac}    ${get_thutu_thukhac}
    Log    ${list_id_thukhac}
    Log    ${list_thutu_thukhac}
    ${liststring_prs_invoice_surchargel}    Set Variable    needdel
    : FOR    ${item_thukhac}    ${item_id_thukhac}    ${item_thutu_thukhac}    ${item_value}    ${item_result_price}    IN ZIP
    ...    ${list_thukhac}    ${list_id_thukhac}    ${list_thutu_thukhac}    ${list_actual_surcharge_value}    ${list_result_thukhac}
    \    ${payload_thukhac}    Run Keyword If    0<${item_value}<100    Format String    {{"Code":"{0}","Name":"thu 1","Order":{1},"RetailerId":{2},"SurValueRatio":{3},"SurchargeId":{4},"ValueRatio":{3},"isAuto":false,"isReturnAuto":false,"TextValue":"","Price":{5},"UsageFlag":true}}    ${item_thukhac}
    \    ...    ${item_thutu_thukhac}    ${get_id_nguoitao}    ${item_value}    ${item_id_thukhac}    ${item_result_price}
    \    ...    ELSE    Format String    {{"Code":"{0}","Name":"thu 2","Order":{1},"RetailerId":{2},"SurValue":{3},"SurchargeId":{4},"Value":{3},"isAuto":false,"isReturnAuto":false,"TextValue":"","Price":{3},"UsageFlag":true}}    ${item_thukhac}    ${item_thutu_thukhac}
    \    ...    ${get_id_nguoitao}    ${item_value}    ${item_id_thukhac}
    \    ${liststring_prs_invoice_surchargel}    Catenate    SEPARATOR=,    ${liststring_prs_invoice_surchargel}    ${payload_thukhac}
    Log    ${liststring_prs_invoice_surchargel}
    ${liststring_prs_invoice_surchargel}    Replace String    ${liststring_prs_invoice_surchargel}    needdel,    ${EMPTY}    count=1
    ##request payload
    ${dis_ratio_actual}    Set Variable If    ${input_ggdth}>100    null    ${input_ggdth}
    ${request_payload}    Format String    {{"Return":{{"BranchId":{0},"RetailerId":{1},"InvoiceId":{2},"CustomerId":{3},"ReceivedById":{4},"ReceivedBy":{{"CreatedBy":0,"CreatedDate":"2019-04-23T10:22:08.910Z","GivenName":"admin","Id":{4},"IsActive":true,"IsAdmin":true,"Type":0,"isDeleted":false,"Name":"admin"}},"SaleChannelId":0,"SaleChannel":null,"Code":"Trả hàng 1","ReturnDiscount":0,"ReturnFee":{5},"ReturnFeeRatio":{6},"ReturnDetails":[{7}],"InvoiceDetails":[{8}],"InvoiceOrderSurcharges":[],"Status":1,"Surcharge":0,"Type":3,"Uuid":"","PayingAmount":{9},"SumTotal":{10},"TotalBeforeDiscount":600000,"ProductDiscount":60000,"TotalInvoice":{11},"TotalReturn":{12},"txtPay":"Tiền khách trả","addToAccount":"0","InvoiceComparePurchaseDate":"","ReturnSurcharges":[],"CreatedBy":{4}}},"Invoice":{{"BranchId":{0},"RetailerId":{1},"UpdateInvoiceId":0,"UpdateReturnId":0,"CustomerId":{3},"SoldById":{4},"SoldBy":{{"CreatedBy":0,"CreatedDate":"2019-04-23T10:22:08.910Z","GivenName":"admin","Id":{4},"IsActive":true,"IsAdmin":true,"Type":0,"isDeleted":false,"Name":"admin"}},"SaleChannelId":0,"SaleChannel":null,"Seller":{{"CreatedBy":0,"CreatedDate":"2019-04-23T10:22:08.910Z","GivenName":"admin","Id":{4},"IsActive":true,"IsAdmin":true,"Type":0,"isDeleted":false,"Name":"admin"}},"OrderCode":"","Discount":{13},"DiscountRatio":{14},"InvoiceDetails":[{15}],"InvoiceOrderSurcharges":[{16}],"Payments":[{{"Method":"Cash","MethodStr":"Tiền mặt","Amount":{9},"Id":-1}}],"Status":1,"Total":{11},"Surcharge":0,"Type":1,"Uuid":"","addToAccount":"0","PayingAmount":{9},"TotalBeforeDiscount":600000,"ProductDiscount":60000,"DebugUuid":"","InvoiceWarranties":[],"CreatedBy":20447}}}}    ${BRANCH_ID}    ${get_id_nguoitao}   ${get_invoice_id}    ${get_id_kh}    ${get_id_nguoiban}
    ...    ${result_phi_th}    ${input_phi_th}    ${liststring_prs_return_detail}    ${liststring_prs_invoice_detail}    ${actual_khtt}    ${result_kh_canthanhtoan}
    ...    ${result_tongtienmua_thukhac}    ${result_tongtientra}    ${result_ggdth}    ${dis_ratio_actual}    ${liststring_prs_invoice_detail1}    ${liststring_prs_invoice_surchargel}
    Log    ${request_payload}
    ${return_code}   Post request to create exchange and get return code    ${request_payload}
    Sleep    10s    wait for response to API
    #assert value product trả hàng
    ${get_list_hh_in_th_af_execute}    Get list product frm Return API    ${return_code}
    ${list_soluong_in_th}    ${list_giatriquydoi_in_th}    Get list quantity and gia tri quy doi with return have multi product    ${get_list_hh_in_th_af_execute}    ${return_code}
    : FOR    ${item_ma_hh}    ${result_toncuoi}    ${item_giavon}    ${get_soluong_in_th}    ${get_giatri_quydoi_th}    IN ZIP
    ...    ${get_list_hh_in_th_af_execute}    ${list_result_toncuoi_th}    ${list_giavon_th}    ${list_soluong_in_th}    ${list_giatriquydoi_in_th}
    \    Run Keyword If    '${get_giatri_quydoi_th}' == '1'    Validate onhand and cost frm API    ${return_code}    ${item_ma_hh}    ${result_toncuoi}
    \    ...    ${item_giavon}    ${get_soluong_in_th}
    \    ...    ELSE    Validate onhand and cost frm unit product    ${return_code}    ${item_ma_hh}    ${result_toncuoi}
    \    ...    ${item_giavon}    ${get_soluong_in_th}    ${get_giatri_quydoi_th}
    #assert value product đổi trả hàng
    ${get_additional_invoice_code}    Get additional invoice code by return code    ${return_code}
    ${get_list_hh_in_dth_af_execute}    Get list product after create invoice    ${get_additional_invoice_code}
    #${get_list_hh_in_dth_af_execute}    Reverse List one    ${get_list_hh_in_dth_af_execute}
    ${list_soluong_in_dth}    ${list_giatriquydoi_in_dth}    Get list quantity and gia tri quy doi frm additional invoice code    ${get_list_hh_in_dth_af_execute}    ${get_additional_invoice_code}
    : FOR    ${item_ma_hh}    ${result_toncuoi}    ${item_giavon}    ${get_soluong_in_dth}    ${get_giatri_quydoi_dth}    IN ZIP
    ...    ${get_list_hh_in_dth_af_execute}    ${list_result_toncuoi_dth}    ${list_giavon_dth}    ${list_soluong_in_dth}    ${list_giatriquydoi_in_dth}
    \    Run Keyword If    '${get_giatri_quydoi_dth}' == '1'    Validate onhand and cost frm API    ${get_additional_invoice_code}    ${item_ma_hh}    ${result_toncuoi}
    \    ...    ${item_giavon}    ${get_soluong_in_dth}
    \    ...    ELSE    Validate onhand and cost frm unit product    ${get_additional_invoice_code}    ${item_ma_hh}    ${result_toncuoi}
    \    ...    ${item_giavon}    ${get_soluong_in_dth}    ${get_giatri_quydoi_dth}
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
    Should Be Equal As Numbers    ${get_tong_tien_hang_af_ex}    ${result_tongtienmua_tovalidate}
    Run Keyword If    ${result_tongtienmua_thukhac}<${result_tongtientra_tru_phith}    Should Be Equal As Numbers    ${get_khach_can_tra_af_ex}    0
    ...    ELSE    Should Be Equal As Numbers    ${get_khach_can_tra_af_ex}    ${result_kh_canthanhtoan}
    Should Be Equal As Numbers    ${get_giamgia_hd_af_ex}    ${result_ggdth}
    Run Keyword If    ${result_tongtienmua_thukhac}<${result_tongtientra_tru_phith}    Should Be Equal As Numbers    ${get_khach_tt_af_ex}    0
    ...    ELSE    Should Be Equal As Numbers    ${get_khach_tt_af_ex}    ${actual_khtt}
    Should Be Equal As Strings    ${get_ma_kh_by_hd_af_ex}    ${input_ma_kh}
    Should Be Equal As Strings    ${get_trangthai_af_ex}    Hoàn thành
    Delete return thr API    ${return_code}
    Delete invoice by invoice code    ${get_ma_hd}
    : FOR    ${item_thukhac}    ${item_value}    IN ZIP    ${list_thukhac}    ${list_actual_surcharge_value}
    \    Run Keyword If    ${item_value} > 100    Toggle surcharge VND    ${item_thukhac}    false
    \    ...    ELSE    Toggle surcharge percentage    ${item_thukhac}    false

edts02
    [Arguments]    ${input_ma_kh}    ${dic_productnums_th}    ${dic_productnums_dth}    ${list_imei_nums}    ${input_phi_th}    ${list_ggsp}    ${list_discounttype}
    ...    ${input_ggsp_imei}   ${discount_type_imei}    ${input_ggdth}    ${input_khtt}    ${input_khtt_hd}  ${list_thukhac}
    ${list_product_dth}    Get Dictionary Keys    ${dic_productnums_dth}
    ${list_nums_dth}    Get Dictionary Values    ${dic_productnums_dth}
    ${list_imei_product_dth}    Get Dictionary Keys    ${list_imei_nums}
    ${list_imei_nums_dth}    Get Dictionary Values    ${list_imei_nums}
    ${input_product_imei}    ${input_imei_nums}    Convert two list to string and return    ${list_imei_product_dth}    ${list_imei_nums_dth}
    Create list imei    ${list_imei_product_dth}    ${list_imei_nums_dth}
    ${get_ma_hd}    Add new invoice frm API    ${input_ma_kh}    ${dic_productnums_th}    ${input_khtt_hd}
    ${list_actual_surcharge_value}    Create List
    : FOR    ${item_thukhac}    IN ZIP    ${list_thukhac}
    \    ${surcharge_value_vnd}    Get surcharge vnd value    ${item_thukhac}
    \    ${surcharge_value_percentage}    Get surcharge percentage value    ${item_thukhac}
    \    ${actual_surcharge_value}    Set Variable If    ${surcharge_value_percentage} == 0    ${surcharge_value_vnd}    ${surcharge_value_percentage}
    \    Run Keyword If    ${actual_surcharge_value} > 100    Toggle surcharge VND    ${item_thukhac}    true
    \    ...    ELSE    Toggle surcharge percentage    ${item_thukhac}    true
    \    Append To List    ${list_actual_surcharge_value}    ${actual_surcharge_value}
    Log    ${list_actual_surcharge_value}
    #get data frm Trả hàng
    Sleep    5s
    ${get_ma_kh_by_hd_bf_ex}    ${get_tong_tien_hang_bf_ex}    ${get_khach_tt_bf_ex}    ${get_trangthai_bf_ex}    Get invoice info by invoice code    ${get_ma_hd}
    ${get_list_hh_in_hd}    ${get_list_sl_in_hd}    Get list product and quantity frm invoice API    ${get_ma_hd}
    ${get_list_sl_in_hd}    Convert String to List    ${get_list_sl_in_hd}
    ${list_result_thanhtien_th}    ${list_giavon_th}    ${list_result_toncuoi_th}    Get list total sale - endingstock - cost frm product api    ${get_list_hh_in_hd}    ${get_list_sl_in_hd}
    ${get_list_baseprice}    Get list of Baseprice by Product Code    ${list_product_dth}
    #input product into DTH form
    Wait Until Keyword Succeeds    3 times    8 s    Before Test Ban Hang
    Select Invoice from Ban Hang page    ${get_ma_hd}
    ${laster_nums}    Set Variable    0
    : FOR    ${item_hh}    ${item_soluong}    IN ZIP    ${get_list_hh_in_hd}    ${get_list_sl_in_hd}
    \    ${laster_number}    Input nums for multi product    ${item_hh}    ${item_soluong}    ${laster_nums}    ${cell_laster_numbers_return}
    ${laster_nums1}    Set Variable    0
    : FOR    ${item_product_dth}    ${item_nums_dth}    ${item_giaban}    ${item_ggsp}    ${discount_type}    IN ZIP    ${list_product_dth}
    ...    ${list_nums_dth}    ${get_list_baseprice}    ${list_ggsp}    ${list_discounttype}
    \    ${laster_nums1}    Wait Until Keyword Succeeds    3 times    5 s    Input product and nums into Doi tra hang form    ${item_product_dth}    ${item_nums_dth}
    \    ...    ${laster_nums1}
    \    ${newprice}    Run Keyword If    '${discount_type}' == 'dis'     Price after % discount product    ${item_giaban}    ${item_ggsp}
    \    ...    ELSE IF    '${discount_type}' == 'disvnd'    Minus    ${item_giaban}    ${item_ggsp}
    \    ...    ELSE IF    '${discount_type}' == 'changeup' or '${discount_type}' == 'changedown'  Set Variable   ${item_ggsp}    ELSE    Set Variable    ${item_giaban}
    \    Run keyword if    '${discount_type}' == 'dis'     Wait Until Keyword Succeeds    3 times    5 s    Input % discount for multi product
    \    ...    ${item_product_dth}    ${item_ggsp}    ${newprice}    ELSE IF    '${discount_type}' == 'disvnd'   Wait Until Keyword Succeeds    3 times    5 s        Input VND discount for multi product    ${item_product_dth}
    \    ...    ${item_ggsp}    ${newprice}
    \    ...    ELSE IF    '${discount_type}' == 'changeup' or '${discount_type}' == 'changedown'  Wait Until Keyword Succeeds    3 times    5 s    Input newprice for multi product    ${item_product_dth}   ${item_ggsp}
    \    ...    ELSE    Log    Ignore input
    : FOR    ${item_product_imei}    ${item_imei}    IN ZIP    ${list_imei_product_dth}    ${imei_inlist}
    \    Wait Until Keyword Succeeds    3 times    8 s    Input product and imei incase multi product to any form    ${textbox_th_search_hangdoi}    ${item_product_imei}
    \    ...    ${cell_dth_sanpham}    ${textbox_dth_nhap_serial}    ${item_dth_imei_in_dropdown}    ${cell_dth_ma_sanpham}    ${cell_dth_imei_multi_product}
    \    ...    @{item_imei}
    ${newprice_imei}    Computation price incase discount by product code    ${input_product_imei}    ${input_ggsp_imei}
    Run keyword if    '${discount_type_imei}' == 'dis'    Wait Until Keyword Succeeds    3 times    5 s        Input % discount for multi product    ${input_product_imei}
    ...    ${input_ggsp_imei}    ${newprice_imei}
    ...    ELSE IF   '${discount_type_imei}' == 'disvnd'    Wait Until Keyword Succeeds    3 times    5 s    Input VND discount for multi product    ${input_product_imei}    ${input_ggsp_imei}    ${newprice_imei}
    ...    ELSE IF    '${discount_type_imei}' == 'changeup' or '${discount_type_imei}' == 'changedown'  Wait Until Keyword Succeeds    3 times    5 s    Input newprice for multi product    ${input_product_imei}    ${input_ggsp_imei}
    ...    ELSE    Log    Ignore input
    #get data frm Doi hang
    Append To List    ${list_product_dth}    ${input_product_imei}
    Append to List    ${list_nums_dth}    ${input_imei_nums}
    Append to List    ${list_ggsp}    ${input_ggsp_imei}
    Append to List    ${list_discounttype}    ${discount_type_imei}
    ${list_result_thanhtien_dth}    ${list_giavon_dth}    ${list_result_toncuoi_dth}    Get list total sale - endingstock - cost incase discount and newprice with additional invoice    ${list_product_dth}
    ...    ${list_nums_dth}    ${list_ggsp}    ${list_discounttype}
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
    ${list_result_thukhac}    Create List
    : FOR    ${item_value}    IN ZIP    ${list_actual_surcharge_value}
    \    ${result_thukhac}    Run Keyword If    ${item_value}>100    Set Variable    ${item_value}
    \    ...    ELSE    Convert % discount to VND and round    ${item_value}    ${result_tongtienmua_tru_gg}
    \    Append To List    ${list_result_thukhac}    ${result_thukhac}
    Log    ${list_result_thukhac}
    ${total_surcharge}    Sum values in list    ${list_result_thukhac}
    ${result_tongtienmua_thukhac}    sum    ${result_tongtienmua_tru_gg}    ${total_surcharge}
    ${result_khachthanhtoan}    Minus and round 2    ${result_tongtienmua_thukhac}    ${result_tongtientra_tru_phith}
    ${result_cantrakhach}    Minus and round 2    ${result_tongtientra_tru_phith}    ${result_tongtienmua_thukhac}
    ${result_kh_canthanhtoan}    Set Variable If    ${result_tongtienmua_thukhac}<${result_tongtientra_tru_phith}    ${result_cantrakhach}    ${result_khachthanhtoan}
    ${result_khtt}    Set Variable If    "${input_khtt}" == "all"    ${result_kh_canthanhtoan}    ${input_khtt}
    ${actual_khtt}    Set Variable If    "${input_khtt}" == "0"    0    ${result_khtt}
    ${actuall_trahang}    Set Variable If    ${result_tongtienmua_tru_gg}<${result_tongtientra_tru_phith}    ${actual_khtt}    0
    ${result_tongtienhangmua_tovalidate}    Sum    ${result_tongtienmua}    ${total_surcharge}
    #create đổi trả hàng
    ${button_thanhtoan}    Set Variable If    ${result_tongtienmua_thukhac}<${result_tongtientra_tru_phith}    ${textbox_dth_tientrakhach}    ${textbox_dth_khachthanhtoan}
    Wait Until Keyword Succeeds    3 times    5 s    Run keyword if    0 < ${input_phi_th} < 100    Input % return free value    ${input_phi_th}
    ...    ${result_phi_th}
    ...    ELSE    Input VND return free value    ${input_phi_th}
    Wait Until Keyword Succeeds    3 times    5 s    Run Keyword If    0 < ${input_ggdth} < 100    Input % discount additional invoice    ${input_ggdth}
    ...    ${result_ggdth}
    ...    ELSE    Input VND discount additional invoice    ${input_ggdth}
    ${button_thanhtoan}    Set Variable If    ${result_tongtienmua_tru_gg}<${result_tongtientra_tru_phith}    ${textbox_dth_tientrakhach}    ${textbox_dth_khachthanhtoan}
    Run Keyword If    "${input_khtt}" == "all"    Click Element JS    ${button_th}
    ...    ELSE    Input payment into any form    ${button_thanhtoan}    ${input_khtt}    ${button_th}
    Return message success validation
    ${return_code}    Wait Until Keyword Succeeds    3 times    5 s    Get saved code after execute
    Execute Javascript    location.reload();
    Sleep    20 s    wait for response to API
    #assert value product trả hàng
    ${get_list_hh_in_th_af_execute}    Get list product frm Return API    ${return_code}
    ${get_list_hh_in_th_af_execute}    Reverse List one    ${get_list_hh_in_th_af_execute}
    ${list_soluong_in_th}    ${list_giatriquydoi_in_th}    Get list quantity and gia tri quy doi with return have multi product    ${get_list_hh_in_th_af_execute}    ${return_code}
    : FOR    ${item_ma_hh}    ${result_toncuoi}    ${item_giavon}    ${get_soluong_in_th}    ${get_giatri_quydoi_th}    IN ZIP
    ...    ${get_list_hh_in_th_af_execute}    ${list_result_toncuoi_th}    ${list_giavon_th}    ${list_soluong_in_th}    ${list_giatriquydoi_in_th}
    \    Run Keyword If    '${get_giatri_quydoi_th}' == '1'    Validate onhand and cost frm API    ${return_code}    ${item_ma_hh}    ${result_toncuoi}
    \    ...    ${item_giavon}    ${get_soluong_in_th}
    \    ...    ELSE    Validate onhand and cost frm unit product    ${return_code}    ${item_ma_hh}    ${result_toncuoi}
    \    ...    ${item_giavon}    ${get_soluong_in_th}    ${get_giatri_quydoi_th}
    #assert value product đổi trả hàng
    ${get_additional_invoice_code}    Get additional invoice code by return code    ${return_code}
    ${get_list_hh_in_dth_af_execute}    Get list product after create invoice    ${get_additional_invoice_code}
    ${get_list_hh_in_dth_af_execute}    Reverse List one    ${get_list_hh_in_dth_af_execute}
    ${list_soluong_in_dth}    ${list_giatriquydoi_in_dth}    Get list quantity and gia tri quy doi frm additional invoice code    ${get_list_hh_in_dth_af_execute}    ${get_additional_invoice_code}
    : FOR    ${item_ma_hh}    ${result_toncuoi}    ${item_giavon}    ${get_soluong_in_dth}    ${get_giatri_quydoi_dth}    IN ZIP
    ...    ${get_list_hh_in_dth_af_execute}    ${list_result_toncuoi_dth}    ${list_giavon_dth}    ${list_soluong_in_dth}    ${list_giatriquydoi_in_dth}
    \    Run Keyword If    '${get_giatri_quydoi_dth}' == '1'    Validate onhand and cost frm API    ${get_additional_invoice_code}    ${item_ma_hh}    ${result_toncuoi}
    \    ...    ${item_giavon}    ${get_soluong_in_dth}
    \    ...    ELSE    Validate onhand and cost frm unit product    ${get_additional_invoice_code}    ${item_ma_hh}    ${result_toncuoi}
    \    ...    ${item_giavon}    ${get_soluong_in_dth}    ${get_giatri_quydoi_dth}
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
    Should Be Equal As Numbers    ${get_tong_tien_hang_af_ex}    ${result_tongtienhangmua_tovalidate}
    Run Keyword If    ${result_tongtienmua_thukhac}<${result_tongtientra_tru_phith}    Should Be Equal As Numbers    ${get_khach_can_tra_af_ex}    0
    ...    ELSE    Should Be Equal As Numbers    ${get_khach_can_tra_af_ex}    ${result_kh_canthanhtoan}
    Should Be Equal As Numbers    ${get_giamgia_hd_af_ex}    ${result_ggdth}
    Run Keyword If    ${result_tongtienmua_thukhac}<${result_tongtientra_tru_phith}    Should Be Equal As Numbers    ${get_khach_tt_af_ex}    0
    ...    ELSE    Should Be Equal As Numbers    ${get_khach_tt_af_ex}    ${actual_khtt}
    Should Be Equal As Strings    ${get_ma_kh_by_hd_af_ex}    ${input_ma_kh}
    Should Be Equal As Strings    ${get_trangthai_af_ex}    Hoàn thành
    Delete return thr API    ${return_code}
    Delete invoice by invoice code    ${get_ma_hd}
    : FOR    ${item_thukhac}    ${item_value}    IN ZIP    ${list_thukhac}    ${list_actual_surcharge_value}
    \    Run Keyword If    ${item_value} > 100    Toggle surcharge VND    ${item_thukhac}    false
    \    ...    ELSE    Toggle surcharge percentage    ${item_thukhac}    false
