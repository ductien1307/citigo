*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    ${headless_browser}
Library           Collections
Library           BuiltIn
Resource          ../../../../core/Ban_Hang/banhang_action.robot
Resource          ../../../../core/Tra_hang/tra_hang_action.robot
Resource          ../../../../core/Tra_hang/tra_hang_page.robot
Resource          ../../../../core/API/api_soquy.robot
Resource          ../../../../core/API/api_trahang.robot
Resource          ../../../../config/env_product/envi.robot
Resource          ../../../../core/Ban_Hang/banhang_page.robot
Resource          ../../../../core/Tra_hang/doi_tra_hang_action.robot
Resource          ../../../../core/share/toast_message.robot
Resource          ../../../../core/share/discount.robot
Resource          ../../../../core/share/computation.robot

*** Variables ***
&{list_product_nums_TH}    KLCB003=1.5
&{list_imei_dth}    KLSI0002=3
&{list_product_nums_DTH}    KLT0002=6    KLQD002=3.3    KLDV002=7    KLCB002=2.6
@{list_discount}    75000    15    5000    160000
@{list_discount_type}    change    dis    dis    change
@{list_surcharge}    TK003    TK007
@{list_surcharge1}    TK001    TK006

*** Test Cases ***    List thu khác         List product trả hàng      List product đổi trả hàng    List imei           Phí trả hàng    List change         List change type         Change imei    Change type imei    GGDTH    Khách thanh toán
Basic                 [Tags]                EDTTKA1
                      [Template]            edtnkl_api01
                      ${list_surcharge}     ${list_product_nums_TH}    ${list_product_nums_DTH}     ${list_imei_dth}    15              ${list_discount}    ${list_discount_type}    5000           dis                 50000    0
                      ${list_surcharge1}    ${list_product_nums_TH}    ${list_product_nums_DTH}     ${list_imei_dth}    30000           ${list_discount}    ${list_discount_type}    15             dis                 20       100000

*** Keywords ***
edtnkl_api01
    [Arguments]    ${list_thukhac}    ${dic_product_nums_th}    ${dic_product_nums_dth}    ${list_imei_nums}    ${input_phi_th}    ${list_change}
    ...    ${list_change_type}    ${input_change_imei}    ${input_change_imei_type}    ${input_ggdth}    ${input_khtt}
    ${list_product_dth}    Get Dictionary Keys    ${dic_product_nums_dth}
    ${list_nums_dth}    Get Dictionary Values    ${dic_product_nums_dth}
    ${list_imei_product_dth}    Get Dictionary Keys    ${list_imei_nums}
    ${list_imei_nums_dth}    Get Dictionary Values    ${list_imei_nums}
    ${input_product_imei}    ${input_imei_nums}    Convert two list to string and return    ${list_imei_product_dth}    ${list_imei_nums_dth}
    Create list imei    ${list_imei_product_dth}    ${list_imei_nums_dth}
    #get data frm Trả hàng
    ${list_product_th}    Get Dictionary Keys    ${dic_product_nums_th}
    ${list_nums_th}    Get Dictionary Values    ${dic_product_nums_th}
    ${list_result_thanhtien_th}    ${list_giavon_th}    ${list_result_toncuoi_th}    Get list total sale - endingstock - cost frm product api    ${list_product_th}    ${list_nums_th}
    ${get_list_baseprice}    Get list of Baseprice by Product Code    ${list_product_dth}
    ${get_list_baseprice_th}    Get list of Baseprice by Product Code    ${list_product_th}
    ${get_list_pr_th_id}    Get list product id thr API    ${list_product_th}
    #thu khac
    ${list_actual_surcharge_value}    Create List
    : FOR    ${item_thukhac}    IN ZIP    ${list_thukhac}
    \    ${surcharge_value_vnd}    Get surcharge vnd value    ${item_thukhac}
    \    ${surcharge_value_percentage}    Get surcharge percentage value    ${item_thukhac}
    \    ${actual_surcharge_value}    Set Variable If    ${surcharge_value_percentage} == 0    ${surcharge_value_vnd}    ${surcharge_value_percentage}
    \    Run Keyword If    ${actual_surcharge_value} > 100    Toggle surcharge VND    ${item_thukhac}    true
    \    ...    ELSE    Toggle surcharge percentage    ${item_thukhac}    true
    \    Append To List    ${list_actual_surcharge_value}    ${actual_surcharge_value}
    Log    ${list_actual_surcharge_value}
    ${list_id_thukhac}    Create List
    ${list_thutu_thukhac}    Create List
    : FOR    ${item_thukhac}    IN ZIP    ${list_thukhac}
    \    ${get_id_thukhac}    ${get_thutu_thukhac}    Get Id and order surchage    ${item_thukhac}
    \    Append To List    ${list_id_thukhac}    ${get_id_thukhac}
    \    Append To List    ${list_thutu_thukhac}    ${get_thutu_thukhac}
    Log    ${list_id_thukhac}
    Log    ${list_thutu_thukhac}
    #get data frm Doi hang
    Append To List    ${list_product_dth}    ${input_product_imei}
    Append to List    ${list_nums_dth}    ${input_imei_nums}
    Append to List    ${list_change}    ${input_change_imei}
    Append to List    ${list_change_type}    ${input_change_imei_type}
    ${list_result_thanhtien_dth}    ${list_giavon_dth}    ${list_result_toncuoi_dth}    Get list total sale - endingstock - cost incase changing product price with additional invoice    ${list_product_dth}    ${list_nums_dth}    ${list_change}
    ...    ${list_change_type}
    ${list_newprice}    ${list_result_ggsp}    Computation list price and result discount incase changing price by product code    ${list_product_dth}    ${list_change}    ${list_change_type}
    ${get_list_pr_dth_id}    Get list product id thr API    ${list_product_dth}
    ${get_list_baseprice_dth}    Get list of Baseprice by Product Code    ${list_product_dth}
    ${get_list_imei_status}    Get list imei status thr API    ${list_product_dth}
    #compute trả hàng
    ${result_tongtientra}    Sum values in list    ${list_result_thanhtien_th}
    ${result_phi_th}    Run Keyword If    0 < ${input_phi_th} < 100    Convert % discount to VND and round    ${result_tongtientra}    ${input_phi_th}
    ...    ELSE    Set Variable    ${input_phi_th}
    ${result_tongtientra_tru_phith}    Minus and round 2    ${result_tongtientra}    ${result_phi_th}
    #compute mua hàng
    ${result_tongtienmua}    Sum values in list    ${list_result_thanhtien_dth}
    ${result_ggdth}    Run Keyword If    0 < ${input_ggdth} < 100    Convert % discount to VND and round    ${result_tongtienmua}    ${input_ggdth}
    ...    ELSE    Set Variable    ${input_ggdth}
    ${result_tongtienmua_tru_gg}    Minus    ${result_tongtienmua}    ${result_ggdth}
    #tinh tong thu khac
    ${list_result_thukhac}    Create List
    : FOR    ${item_value}    IN ZIP    ${list_actual_surcharge_value}
    \    ${result_thukhac}    Run Keyword If    ${item_value}>100    Set Variable    ${item_value}
    \    ...    ELSE    Convert % discount to VND and round    ${item_value}    ${result_tongtienmua_tru_gg}
    \    Append To List    ${list_result_thukhac}    ${result_thukhac}
    Log    ${list_result_thukhac}
    ${total_thukhac}    Sum values in list    ${list_result_thukhac}
    #
    ${result_tongtienmua_cong_thukhac}    Sum    ${result_tongtienmua}    ${total_thukhac}
    ${result_tongtienmua_gom_gg_thukhac}    Sum    ${result_tongtienmua_tru_gg}    ${total_thukhac}
    ${result_khachthanhtoan}    Minus and round 2    ${result_tongtienmua_gom_gg_thukhac}    ${result_tongtientra_tru_phith}
    ${result_cantrakhach}    Minus and round 2    ${result_tongtientra_tru_phith}    ${result_tongtienmua_gom_gg_thukhac}
    ${result_kh_canthanhtoan}    Set Variable If    ${result_tongtienmua_gom_gg_thukhac}<${result_tongtientra_tru_phith}    ${result_cantrakhach}    ${result_khachthanhtoan}
    ${result_khtt}    Set Variable If    "${input_khtt}" == "all"    ${result_kh_canthanhtoan}    ${input_khtt}
    ${actual_khtt}    Set Variable If    "${input_khtt}" == "0"    0    ${result_khtt}
    ${actuall_trahang}    Set Variable If    ${result_tongtienmua_gom_gg_thukhac}<${result_tongtientra_tru_phith}    ${actual_khtt}    0
    # Post request BH
    #return
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${liststring_prs_return_detail}    Set Variable    needdel
    : FOR    ${item_product_id}    ${item_price}    ${item_num}    IN ZIP    ${get_list_pr_th_id}    ${get_list_baseprice_th}
    ...    ${list_nums_th}
    \    ${payload_each_product}    Format string    {{"BasePrice":{0},"IsLotSerialControl":false,"Note":"","Price":{0},"ProductId":{1},"Quantity":{2},"SellPrice":{0},"ProductName":"Túi 8 Bánh Socola Kitkat Trà Xanh SB","CopiedPrice":{0},"ProductBatchExpireId":null}}    ${item_price}    ${item_product_id}    ${item_num}
    \    ${liststring_prs_return_detail}    Catenate    SEPARATOR=,    ${liststring_prs_return_detail}    ${payload_each_product}
    Log    ${liststring_prs_return_detail}
    ${liststring_prs_return_detail}    Replace String    ${liststring_prs_return_detail}    needdel,    ${EMPTY}    count=1
    #invoice
    ${liststring_prs_invoice_detail}    Set Variable    needdel
    ${liststring_prs_invoice_detail1}    Set Variable    needdel
    ${list_imei}    Convert list to string and return    ${imei_inlist}
    : FOR    ${item_product_id}    ${item_price}    ${item_num}    ${item_result_discountproduct}    ${item_change}    ${item_status}
    ...    ${item_change_type}    IN ZIP    ${get_list_pr_dth_id}    ${get_list_baseprice_dth}    ${list_nums_dth}    ${list_result_ggsp}
    ...    ${list_change}    ${get_list_imei_status}    ${list_change_type}
    \    ${item_imei}    Set Variable If    ${item_status}==0    ${EMPTY}    ${list_imei}
    \    ${item_dis_ratio}    Set Variable If    0<${item_change}<100 and '${item_change_type}'=='dis'    ${item_change}    null
    \    ${payload_each_product}    Format string    {{"ProductId":{0},"ProductName":"chuột quang hồng","ProductFullName":"chuột quang hồng","ProductNameNoUnit":"chuột quang hồng","ProductAttributeLabel":"","ProductSName":"chuột quang hồng","ProductCode":"NS01","ProductType":2,"ProductCategoryId":173814,"MasterProductId":9326934,"OnHand":17,"OnOrder":0,"Reserved":0,"Price":{1},"Unit":"","Note":"","PromotionReceiverQty":1,"Quantity":{2},"ProductSerials":[],"Serials":[],"IsLotSerialControl":true,"IsRewardPoint":false,"CurrentQuery":"ns","CategoryId":173814,"Promotions":[],"Discount":{3},"DiscountRatio":{4},"BasePrice":{1},"DuplicationCartItems":[],"isDeleted":false,"ProductShelves":[],"AllowSale":true,"ProductWarranty":[],"Formulas":null,"Uuid":"W156654643335689","CartType":3,"Units":[],"MaxQuantity":null,"SerialNumbers":"{5}","discountRatioPriceWoRound":{4},"discountPriceWoRound":{3}}}    ${item_product_id}    ${item_price}    ${item_num}
    \    ...    ${item_result_discountproduct}    ${item_dis_ratio}    ${item_imei}
    \    ${payload_each_product_1}    Format string    {{"BasePrice":{0},"IsLotSerialControl":true,"IsRewardPoint":false,"Note":"","Price":{0},"ProductId":{1},"Quantity":{2},"SerialNumbers":"{3}","Discount":{4},"DiscountRatio":{5},"ProductName":"chuột quang hồng","ProductCode":"NS01","ProductBatchExpireId":null,"Uuid":"W156654643335689"}}    ${item_price}    ${item_product_id}    ${item_num}
    \    ...    ${item_imei}    ${item_result_discountproduct}    ${item_dis_ratio}
    \    ${liststring_prs_invoice_detail}    Catenate    SEPARATOR=,    ${liststring_prs_invoice_detail}    ${payload_each_product}
    \    ${liststring_prs_invoice_detail1}    Catenate    SEPARATOR=,    ${liststring_prs_invoice_detail1}    ${payload_each_product_1}
    Log    ${liststring_prs_invoice_detail}
    Log    ${liststring_prs_invoice_detail1}
    ${liststring_prs_invoice_detail}    Replace String    ${liststring_prs_invoice_detail}    needdel,    ${EMPTY}    count=1
    ${liststring_prs_invoice_detail1}    Replace String    ${liststring_prs_invoice_detail1}    needdel,    ${EMPTY}    count=1
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
    ${dis_ratio_actual}    Set Variable If    ${input_ggdth}>100    null    ${input_ggdth}
    ${request_payload}    Format String    {{"Return":{{"BranchId":{0},"RetailerId":{1},"ReceivedById":{2},"ReceivedBy":{{"CreatedBy":0,"CreatedDate":"2018-12-10T08:33:32.447Z","Email":"","GivenName":"admin","Id":{2},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false}},"SaleChannelId":0,"SaleChannel":null,"Code":"Trả hàng 1","ReturnDiscount":0,"ReturnFee":{3},"ReturnFeeRatio":{4},"ReturnDetails":[{5}],"InvoiceDetails":[{6}],"InvoiceOrderSurcharges":[],"Status":1,"Surcharge":0,"Type":3,"Uuid":"W15670471588182","PayingAmount":{7},"SumTotal":{8},"TotalBeforeDiscount":1050000,"ProductDiscount":210000,"TotalInvoice":{9},"TotalReturn":260000,"txtPay":"Tiền khách trả","addToAccount":"0","addToAccountSurplus":"0","addToAccountAllocation":"0","addToAccountPaymentAllocation":"0","ReturnSurcharges":[],"CreatedBy":{2}}},"Invoice":{{"BranchId":{0},"RetailerId":{1},"UpdateInvoiceId":0,"UpdateReturnId":0,"SoldById":{2},"SoldBy":{{"CreatedBy":0,"CreatedDate":"2018-12-10T08:33:32.447Z","Email":"","GivenName":"admin","Id":441968,"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false}},"SaleChannelId":0,"SaleChannel":null,"Seller":{{"CreatedBy":0,"CreatedDate":"2018-12-10T08:33:32.447Z","Email":"","GivenName":"admin","Id":441968,"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false}},"OrderCode":"","Discount":{10},"DiscountRatio":{11},"InvoiceDetails":[{12}],"InvoiceOrderSurcharges":[{13}],"Payments":[{{"Method":"Cash","MethodStr":"Tiền mặt","Amount":{7},"Id":-1}}],"Status":1,"Total":{9},"Surcharge":0,"Type":1,"Uuid":"W15670471588182","addToAccount":"0","addToAccountSurplus":"0","addToAccountAllocation":"0","addToAccountPaymentAllocation":"0","PayingAmount":{7},"TotalBeforeDiscount":1050000,"ProductDiscount":210000,"DebugUuid":"156704715869740","InvoiceWarranties":[],"CreatedBy":441968}}}}    ${BRANCH_ID}    ${get_id_nguoitao}    ${get_id_nguoiban}    ${result_phi_th}
    ...    ${input_phi_th}    ${liststring_prs_return_detail}    ${liststring_prs_invoice_detail}    ${actual_khtt}    ${result_kh_canthanhtoan}    ${result_tongtienmua_gom_gg_thukhac}
    ...    ${result_ggdth}    ${input_ggdth}    ${liststring_prs_invoice_detail1}    ${liststring_prs_invoice_surchargel}
    Log    ${request_payload}
    ${return_code}   Post request to create exchange and get return code    ${request_payload}
    Sleep    10s    wait for response to API
    #tat thu khac
    : FOR    ${item_thukhac}    ${item_value}    IN ZIP    ${list_thukhac}    ${list_actual_surcharge_value}
    \    Run Keyword If    ${item_value} > 100    Toggle surcharge VND    ${item_thukhac}    false
    \    ...    ELSE    Toggle surcharge percentage    ${item_thukhac}    false
    #assert value in return
    ${get_tongtienhangtra_af_ex}    ${get_phitrahang_af_ex}    ${get_cantrakhach_af_ex}    ${get_datrakhach_af_ex}    ${get_tongtien_hoadontra_af_ex}    Get return info by return code    ${return_code}
    Should Be Equal As Numbers    ${get_tongtienhangtra_af_ex}    ${result_tongtientra}
    Should Be Equal As Numbers    ${get_phitrahang_af_ex}    ${result_phi_th}
    Should Be Equal As Numbers    ${get_datrakhach_af_ex}    ${actuall_trahang}
    Should Be Equal As Numbers    ${get_tongtien_hoadontra_af_ex}    ${result_tongtientra_tru_phith}
    #assert value in đổi hàng
    ${get_additional_invoice_code}    Get additional invoice code by return code    ${return_code}
    ${get_ma_kh_by_hd_af_ex}    ${get_tong_tien_hang_af_ex}    ${get_khach_tt_af_ex}    ${get_giamgia_hd_af_ex}    ${get_khach_can_tra_af_ex}    ${get_trangthai_af_ex}    Get additional invoice info incase discount by additional invoice code
    ...    ${get_additional_invoice_code}
    Should Be Equal As Numbers    ${get_tong_tien_hang_af_ex}    ${result_tongtienmua_cong_thukhac}
    Run Keyword If    ${result_tongtienmua_gom_gg_thukhac}<${result_tongtientra_tru_phith}    Should Be Equal As Numbers    ${get_khach_can_tra_af_ex}    0
    ...    ELSE    Should Be Equal As Numbers    ${get_khach_can_tra_af_ex}    ${result_kh_canthanhtoan}
    Should Be Equal As Numbers    ${get_giamgia_hd_af_ex}    ${result_ggdth}
    Run Keyword If    ${result_tongtienmua_gom_gg_thukhac}<${result_tongtientra_tru_phith}    Should Be Equal As Numbers    ${get_khach_tt_af_ex}    0
    ...    ELSE    Should Be Equal As Numbers    ${get_khach_tt_af_ex}    ${actual_khtt}
    Should Be Equal As Strings    ${get_ma_kh_by_hd_af_ex}    0
    Should Be Equal As Strings    ${get_trangthai_af_ex}    Hoàn thành
