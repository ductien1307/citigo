*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    ${headless_browser}
Library           Collections
Library           BuiltIn
Resource          ../../../../core/Ban_Hang/banhang_action.robot
Resource          ../../../../core/Tra_hang/tra_hang_action.robot
Resource          ../../../../core/Tra_hang/tra_hang_page.robot
Resource          ../../../../core/API/api_soquy.robot
Resource          ../../../../config/env_product/envi.robot
Resource          ../../../../core/Ban_Hang/banhang_page.robot
Resource          ../../../../core/Tra_hang/doi_tra_hang_action.robot
Resource          ../../../../core/share/toast_message.robot
Resource          ../../../../core/Ban_Hang/banhang_getandcompute.robot

*** Variables ***
&{list_productnums_DTH}    KLCB005=5    KLDV005=2    KLQD004=6    KLSI0004=4    KLT0005=4.5
&{list_productnums_TH}    KLQD005=3.5
@{list_discount}    1200,0,50000    15,25    230000,70000    360000,0    10,150000
@{list_discount_type}    dis,none,change    dis,dis    change,none    change,dis    dis,change
@{list_num_dth}    4.5,5,4    5,6.2    7,3    4,3    2.5,3

*** Test Cases ***    List product trả hàng      List product đổi trả hàng    Phí trả hàng    List num trả hàng    List change         List change type         GGDTH    Khách thanh toán
Nhieu dong            [Tags]                     DTKLA1
                      [Template]                 edthn_nn_01
                      ${list_product_nums_TH}    ${list_product_nums_DTH}     15              ${list_num_dth}      ${list_discount}    ${list_discount_type}    50000    all

*** Keywords ***
edthn_nn_01
    [Arguments]    ${dic_product_nums_th}    ${list_product_dth}    ${input_phi_th}    ${list_num}    ${list_change}    ${list_change_type}
    ...    ${input_ggdth}    ${input_khtt}
    #tach sp imei khoi list
    ${get_list_baseprice}    Get list of Baseprice by Product Code    ${list_product_dth}
    ${get_list_imei_status}    Get list imei status thr API    ${list_product_dth}
    #tao list imei cho sp
    ${list_imei}    create list
    : FOR    ${item_product}    ${item_num}    ${item_status}    IN ZIP    ${list_product_dth}    ${list_num}
    ...    ${get_list_imei_status}
    \    ${item_num}    Split String    ${item_num}    ,
    \    ${imei_by_product}    Run Keyword If    '${item_status}'=='True'    Create list imei for multi row    ${item_product}    ${item_num}
    \    ...    ELSE    Set Variable    ${EMPTY}
    \    Append To List    ${list_imei}    ${imei_by_product}
    Log    ${list_imei}
    #get data frm Trả hàng
    ${list_product_th}    Get Dictionary Keys    ${dic_product_nums_th}
    ${list_nums_th}    Get Dictionary Values    ${dic_product_nums_th}
    ${list_result_thanhtien_th}    ${list_giavon_th}    ${list_result_toncuoi_th}    Get list total sale - endingstock - cost frm product api    ${list_product_th}    ${list_nums_th}
    ${get_list_pr_th_id}    Get list product id thr API    ${list_product_th}
    ${get_list_baseprice_th}    Get list of Baseprice by Product Code    ${list_product_th}
    #get dât form doi hang
    ${get_list_baseprice_dth}    Get list of Baseprice by Product Code    ${list_product_dth}
    ${get_list_pr_dth_id}    Get list product id thr API    ${list_product_dth}
    ${list_result_thanhtien_dth}    ${list_giavon_dth}    ${list_result_toncuoi_dth}    Get list total sale - endingstock - cost incase changing product price with additional multi row invoice    ${list_product_dth}    ${list_num}    ${list_change}
    ...    ${list_change_type}
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
    ${result_khachthanhtoan}    Minus and round 2    ${result_tongtienmua_tru_gg}    ${result_tongtientra_tru_phith}
    ${result_cantrakhach}    Minus and round 2    ${result_tongtientra_tru_phith}    ${result_tongtienmua_tru_gg}
    ${result_kh_canthanhtoan}    Set Variable If    ${result_tongtienmua_tru_gg}<${result_tongtientra_tru_phith}    ${result_cantrakhach}    ${result_khachthanhtoan}
    ${result_khtt}    Set Variable If    "${input_khtt}" == "all"    ${result_kh_canthanhtoan}    ${input_khtt}
    ${actual_khtt}    Set Variable If    "${input_khtt}" == "0"    0    ${result_khtt}
    ${actuall_trahang}    Set Variable If    ${result_tongtienmua_tru_gg}<${result_tongtientra_tru_phith}    ${actual_khtt}    0
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
    : FOR    ${item_product_dth}    ${item_pr_id}    ${item_nums_dth}    ${item_giaban}    ${item_change}    ${item_change_type}
    ...    ${item_status}    ${item_imei}    IN ZIP    ${list_product_dth}    ${get_list_pr_dth_id}    ${list_num}
    ...    ${get_list_baseprice}    ${list_change}    ${list_change_type}    ${get_list_imei_status}    ${list_imei}
    \    ${item_nums_dth}    Split String    ${item_nums_dth}    ,
    \    ${item_change}    Split String    ${item_change}    ,
    \    ${item_change_type}    Split String    ${item_change_type}    ,
    \    ${list_newprice}    ${list_disvnd}    Computation list price and result discount incase changing price - multi row    ${item_change}    ${item_change_type}    ${item_giaban}
    \    ${lduplicationartitems}    ${lduplicationartitems1}    Run Keyword If    '${item_status}'=='True'    Infuse value into multi row product imei    ${item_pr_id}
    \    ...    ${item_nums_dth}    ${item_giaban}    ${item_change}    ${item_change_type}    ${list_disvnd}
    \    ...    ${item_imei}
    \    ...    ELSE    Infuse value into multi row product    ${item_pr_id}    ${item_nums_dth}    ${item_giaban}
    \    ...    ${item_change}    ${item_change_type}    ${list_disvnd}
    \    ${liststring_prs_invoice_detail1}    Catenate    SEPARATOR=,    ${liststring_prs_invoice_detail1}    ${lduplicationartitems1}
    Log    ${liststring_prs_invoice_detail1}
    : FOR    ${item_product_dth}    ${item_pr_id}    ${item_nums_dth}    ${item_giaban}    ${item_change}    ${item_change_type}
    ...    ${item_status}    ${item_imei}    IN ZIP    ${list_product_dth}    ${get_list_pr_dth_id}    ${list_num}
    ...    ${get_list_baseprice}    ${list_change}    ${list_change_type}    ${get_list_imei_status}    ${list_imei}
    \    ${item_nums_dth}    Split String    ${item_nums_dth}    ,
    \    ${item_change}    Split String    ${item_change}    ,
    \    ${item_change_type}    Split String    ${item_change_type}    ,
    \    ${list_newprice}    ${list_disvnd}    Computation list price and result discount incase changing price - multi row    ${item_change}    ${item_change_type}    ${item_giaban}
    \    ${get_num_main}    Remove From List    ${item_nums_dth}    0
    \    ${get_change_main}    Remove From List    ${item_change}    0
    \    ${get_change_type_main}    Remove From List    ${item_change_type}    0
    \    ${get_imei_main}    Run Keyword If    '${item_status}'=='True'    Remove From List    ${item_imei}    0
    \    ...    ELSE    Set Variable    ${EMPTY}
    \    ${get_disvnd_main}    Remove From List    ${list_disvnd}    0
    \    ${lduplicationartitems}    ${lduplicationartitems1}    Run Keyword If    '${item_status}'=='True'    Infuse value into multi row product imei    ${item_pr_id}
    \    ...    ${item_nums_dth}    ${item_giaban}    ${item_change}    ${item_change_type}    ${list_disvnd}
    \    ...    ${item_imei}
    \    ...    ELSE    Infuse value into multi row product    ${item_pr_id}    ${item_nums_dth}    ${item_giaban}
    \    ...    ${item_change}    ${item_change_type}    ${list_disvnd}
    \    ${item_dis_ratio}    Set Variable If    0<${get_change_main}<100 and '${get_change_type_main}'=='dis'    ${get_change_main}    null
    \    ${payload_each_product}    Format String    {{"ProductId":{0},"ProductName":"Sản phẩm IMEI 9","ProductFullName":"Sản phẩm IMEI 9","ProductNameNoUnit":"Sản phẩm IMEI 9","ProductAttributeLabel":"","ProductSName":"Sản phẩm IMEI 9","ProductCode":"RPSI0009","ProductType":2,"ProductCategoryId":173814,"MasterProductId":{0},"OnHand":7,"OnOrder":0,"Reserved":0,"Price":{1},"OriginSalePrice":{1},"Unit":"","Note":"","PromotionReceiverQty":1,"Quantity":{2},"ProductSerials":[],"Serials":[],"IsLotSerialControl":true,"IsRewardPoint":false,"CurrentQuery":"RPSI0009","CategoryId":173814,"Promotions":[],"Discount":{3},"DiscountRatio":{4},"BasePrice":{1},"DuplicationCartItems":[{5}],"isDeleted":false,"ProductShelves":[],"AllowSale":true,"ProductWarranty":[],"Formulas":null,"Uuid":"W157076259318239","CartType":3,"Units":[],"MaxQuantity":null,"IsMaster":true,"SerialNumbers":"0WBHV,L21N7","discountRatioPriceWoRound":{4},"discountPriceWoRound":{3}}},{5}    ${item_pr_id}    ${item_giaban}    ${get_num_main}
    \    ...    ${get_disvnd_main}    ${item_dis_ratio}    ${lduplicationartitems}
    \    ${liststring_prs_invoice_detail}    Catenate    SEPARATOR=,    ${liststring_prs_invoice_detail}    ${payload_each_product}
    Log    ${liststring_prs_invoice_detail}
    ${liststring_prs_invoice_detail}    Replace String    ${liststring_prs_invoice_detail}    needdel,    ${EMPTY}    count=1
    ${liststring_prs_invoice_detail1}    Replace String    ${liststring_prs_invoice_detail1}    needdel,    ${EMPTY}    count=1
    ${dis_ratio_actual}    Set Variable If    ${input_ggdth}>100    null    ${input_ggdth}
    ${request_payload}    Format String    {{"Return":{{"BranchId":{0},"RetailerId":{1},"ReceivedById":{2},"ReceivedBy":{{"CreatedBy":0,"CreatedDate":"2018-12-10T08:33:32.447Z","Email":"","GivenName":"admin","Id":{2},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false}},"SaleChannelId":0,"SaleChannel":null,"Code":"Trả hàng 1","ReturnDiscount":0,"ReturnFee":{3},"ReturnFeeRatio":{4},"ReturnDetails":[{5}],"InvoiceDetails":[{6}],"InvoiceOrderSurcharges":[],"Status":1,"Surcharge":0,"Type":3,"Uuid":"W15670471588182","PayingAmount":{7},"SumTotal":{8},"TotalBeforeDiscount":1050000,"ProductDiscount":210000,"TotalInvoice":{9},"TotalReturn":260000,"txtPay":"Tiền khách trả","addToAccount":"0","addToAccountSurplus":"0","addToAccountAllocation":"0","addToAccountPaymentAllocation":"0","ReturnSurcharges":[],"CreatedBy":{2}}},"Invoice":{{"BranchId":{0},"RetailerId":{1},"UpdateInvoiceId":0,"UpdateReturnId":0,"SoldById":{2},"SoldBy":{{"CreatedBy":0,"CreatedDate":"2018-12-10T08:33:32.447Z","Email":"","GivenName":"admin","Id":441968,"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false}},"SaleChannelId":0,"SaleChannel":null,"Seller":{{"CreatedBy":0,"CreatedDate":"2018-12-10T08:33:32.447Z","Email":"","GivenName":"admin","Id":441968,"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false}},"OrderCode":"","Discount":{10},"DiscountRatio":{11},"InvoiceDetails":[{12}],"InvoiceOrderSurcharges":[],"Payments":[{{"Method":"Cash","MethodStr":"Tiền mặt","Amount":{7},"Id":-1}}],"Status":1,"Total":{9},"Surcharge":0,"Type":1,"Uuid":"W15670471588182","addToAccount":"0","addToAccountSurplus":"0","addToAccountAllocation":"0","addToAccountPaymentAllocation":"0","PayingAmount":{7},"TotalBeforeDiscount":1050000,"ProductDiscount":210000,"DebugUuid":"156704715869740","InvoiceWarranties":[],"CreatedBy":441968}}}}    ${BRANCH_ID}    ${get_id_nguoitao}    ${get_id_nguoiban}    ${result_phi_th}
    ...    ${input_phi_th}    ${liststring_prs_return_detail}    ${liststring_prs_invoice_detail}    ${actual_khtt}    ${result_kh_canthanhtoan}    ${result_tongtienmua_tru_gg}
    ...    ${result_ggdth}    ${dis_ratio_actual}    ${liststring_prs_invoice_detail1}
    Log    ${request_payload}
    ${return_code}   Post request to create exchange and get return code    ${request_payload}
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
    ${get_list_cost_af}    ${get_list_onhand_af}    Get list cost - onhand frm API    ${list_product_dth}
    : FOR    ${item_cost_actual}    ${item_onhand_actual}    ${item_cost}    ${item_onhand}    IN ZIP    ${get_list_cost_af}
    ...    ${get_list_onhand_af}    ${list_giavon_dth}    ${list_result_toncuoi_dth}
    \    Should Be Equal As Numbers    ${item_cost_actual}    ${item_cost}
    \    Should Be Equal As Numbers    ${item_onhand_actual}    ${item_onhand}
    #assert value in return
    ${get_tongtienhangtra_af_ex}    ${get_phitrahang_af_ex}    ${get_cantrakhach_af_ex}    ${get_datrakhach_af_ex}    ${get_tongtien_hoadontra_af_ex}    Get return info by return code    ${return_code}
    Should Be Equal As Numbers    ${get_tongtienhangtra_af_ex}    ${result_tongtientra}
    Should Be Equal As Numbers    ${get_phitrahang_af_ex}    ${result_phi_th}
    Should Be Equal As Numbers    ${get_datrakhach_af_ex}    ${actuall_trahang}
    Should Be Equal As Numbers    ${get_tongtien_hoadontra_af_ex}    ${result_tongtientra_tru_phith}
    #assert value in đổi hàng
    ${get_ma_kh_by_hd_af_ex}    ${get_tong_tien_hang_af_ex}    ${get_khach_tt_af_ex}    ${get_giamgia_hd_af_ex}    ${get_khach_can_tra_af_ex}    ${get_trangthai_af_ex}    Get additional invoice info incase discount by additional invoice code
    ...    ${get_additional_invoice_code}
    Should Be Equal As Numbers    ${get_tong_tien_hang_af_ex}    ${result_tongtienmua}
    Run Keyword If    ${result_tongtienmua_tru_gg}<${result_tongtientra_tru_phith}    Should Be Equal As Numbers    ${get_khach_can_tra_af_ex}    0
    ...    ELSE    Should Be Equal As Numbers    ${get_khach_can_tra_af_ex}    ${result_kh_canthanhtoan}
    Should Be Equal As Numbers    ${get_giamgia_hd_af_ex}    ${result_ggdth}
    Run Keyword If    ${result_tongtienmua_tru_gg}<${result_tongtientra_tru_phith}    Should Be Equal As Numbers    ${get_khach_tt_af_ex}    0
    ...    ELSE    Should Be Equal As Numbers    ${get_khach_tt_af_ex}    ${actual_khtt}
    Should Be Equal As Strings    ${get_ma_kh_by_hd_af_ex}    0
    Should Be Equal As Strings    ${get_trangthai_af_ex}    Hoàn thành
