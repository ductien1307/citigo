*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    ${headless_browser}
Library           Collections
Library           BuiltIn
Resource          ../../../../../core/Ban_Hang/banhang_action.robot
Resource          ../../../../../core/Tra_hang/tra_hang_action.robot
Resource          ../../../../../core/Tra_hang/tra_hang_page.robot
Resource          ../../../../../core/API/api_soquy.robot
Resource          ../../../../../config/env_product/envi.robot
Resource          ../../../../../core/Ban_Hang/banhang_page.robot
Resource          ../../../../../core/Tra_hang/doi_tra_hang_action.robot
Resource          ../../../../../core/share/toast_message.robot
Resource          ../../../../../core/Ban_Hang/banhang_getandcompute.robot

*** Variables ***
&{list_productnums_DTH}    KLCB002=5.5    KLDV003=8    KLQD002=6.5    KLSI0002=3    KLT0002=7
&{list_productnums_TH}    KLCB003=4
&{list_imei_dth}    KLSI0002=3
@{list_discount}    15    30000    5000    115000
@{list_disoucnt_type}    dis    change    dis    change

*** Test Cases ***    List product trả hàng     List product đổi trả hàng    List imei           Phí trả hàng    List change         List change type         Change IMEI    Change type IMEI    GGDTH    Khách thanh toán
Giam_gia              [Tags]                    DTKLA
                      [Template]                edthkl_hd_api_01
                      ${list_productnums_TH}    ${list_productnums_DTH}      ${list_imei_dth}    15              ${list_discount}    ${list_disoucnt_type}    110000         change              20       20000

*** Keywords ***
edthkl_hd_api_01
    [Arguments]    ${dic_productnums_th}    ${dic_productnums_dth}    ${list_imei_nums}    ${input_phi_th}    ${list_change}    ${list_change_type}
    ...    ${input_change_imei}    ${input_change_imei_type}    ${input_ggdth}    ${input_khtt}
    ${list_product_dth}    Get Dictionary Keys    ${dic_productnums_dth}
    ${list_nums_dth}    Get Dictionary Values    ${dic_productnums_dth}
    ${list_imei_product_dth}    Get Dictionary Keys    ${list_imei_nums}
    ${list_imei_nums_dth}    Get Dictionary Values    ${list_imei_nums}
    ${input_product_imei}    ${input_imei_nums}    Convert two list to string and return    ${list_imei_product_dth}    ${list_imei_nums_dth}
    Create list imei    ${list_imei_product_dth}    ${list_imei_nums_dth}
    ${get_ma_hd}    Add invoice without customer no payment thr API    ${dic_productnums_th}
    #get data frm Trả hàng
    Sleep    5s
    ${get_ma_kh_by_hd_bf_ex}    ${get_tong_tien_hang_bf_ex}    ${get_khach_tt_bf_ex}    ${get_trangthai_bf_ex}    Get invoice info by invoice code    ${get_ma_hd}
    ${get_list_hh_in_hd}    ${get_list_sl_in_hd}    Get list product and quantity frm invoice API    ${get_ma_hd}
    ${get_list_sl_in_hd}    Convert String to List    ${get_list_sl_in_hd}
    ${list_result_thanhtien_th}    ${list_giavon_th}    ${list_result_toncuoi_th}    Get list total sale - endingstock - cost frm product api    ${get_list_hh_in_hd}    ${get_list_sl_in_hd}
    ${get_list_pr_th_id}    Get list product id thr API    ${get_list_hh_in_hd}
    ${get_list_baseprice_th}    Get list of Baseprice by Product Code    ${get_list_hh_in_hd}
    #get data frm Doi hang
    Append To List    ${list_product_dth}    ${input_product_imei}
    Append to List    ${list_nums_dth}    ${input_imei_nums}
    Append to List    ${list_change}    ${input_change_imei}
    Append To List    ${list_change_type}    ${input_change_imei_type}
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
    ${result_khachthanhtoan}    Minus and round 2    ${result_tongtienmua_tru_gg}    ${result_tongtientra_tru_phith}
    ${result_cantrakhach}    Minus and round 2    ${result_tongtientra_tru_phith}    ${result_tongtienmua_tru_gg}
    ${result_kh_canthanhtoan}    Set Variable If    ${result_tongtienmua_tru_gg}<${result_tongtientra_tru_phith}    ${result_cantrakhach}    ${result_khachthanhtoan}
    ${result_khtt}    Set Variable If    "${input_khtt}" == "all"    ${result_kh_canthanhtoan}    ${input_khtt}
    ${actual_khtt}    Set Variable If    "${input_khtt}" == "0"    0    ${result_khtt}
    ${actuall_trahang}    Set Variable If    ${result_tongtienmua_tru_gg}<${result_tongtientra_tru_phith}    ${actual_khtt}    0
    # Post request BH
    #return
    ${get_invoice_id}    Get invoice id    ${get_ma_hd}
    ${get_invoice_detail_id}    Get invoice detail id    ${get_ma_hd}
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${liststring_prs_return_detail}    Set Variable    needdel
    : FOR    ${item_product_id}    ${item_price}    ${item_num}    IN ZIP    ${get_list_pr_th_id}    ${get_list_baseprice_th}
    ...    ${get_list_sl_in_hd}
    \    ${payload_each_product}    Format string    {{"BasePrice":{0},"IsLotSerialControl":false,"Note":"","Price":{0},"ProductId":{1},"Quantity":{2},"SerialNumbers":"","SellPrice":{0},"ProductName":"Bánh Snack Khoai Tây Vị Thịt Nướng Ligo - (hộp tự gen)","CopiedPrice":{0},"InvoiceDetailId":{3},"IsMaster":true,"ProductBatchExpireId":null}}    ${item_price}    ${item_product_id}    ${item_num}
    \    ...    ${get_invoice_detail_id}
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
    \    ${payload_each_product}    Format string    {{"ProductId":{0},"ProductName":"chuột quang hồng","ProductFullName":"chuột quang hồng","ProductNameNoUnit":"chuột quang hồng","ProductAttributeLabel":"","ProductSName":"chuột quang hồng","ProductCode":"NS01","ProductType":2,"ProductCategoryId":173814,"MasterProductId":9326934,"OnHand":13,"OnOrder":0,"Reserved":0,"Price":{1},"Unit":"","Note":"","PromotionReceiverQty":1,"Quantity":{2},"ProductSerials":[],"Serials":[],"IsLotSerialControl":true,"IsRewardPoint":false,"CurrentQuery":"ns01","CategoryId":173814,"Promotions":[],"Discount":{3},"DiscountRatio":{4},"BasePrice":{1},"DuplicationCartItems":[],"isDeleted":false,"ProductShelves":[],"AllowSale":true,"ProductWarranty":[],"Formulas":null,"Uuid":"W156707473197813","CartType":3,"Units":[],"MaxQuantity":null,"SerialNumbers":"{5}","discountRatioPriceWoRound":{4},"discountPriceWoRound":{3}}}    ${item_product_id}    ${item_price}    ${item_num}
    \    ...    ${item_result_discountproduct}    ${item_dis_ratio}    ${item_imei}
    \    ${payload_each_product_1}    Format string    {{"BasePrice":{0},"IsLotSerialControl":true,"IsRewardPoint":false,"Note":"","Price":{0},"ProductId":{1},"Quantity":{2},"SerialNumbers":"{3}","Discount":{4},"DiscountRatio":{5},"ProductName":"chuột quang hồng","ProductCode":"NS01","ProductBatchExpireId":null,"Uuid":"W156707473197813"}}    ${item_price}    ${item_product_id}    ${item_num}
    \    ...    ${item_imei}    ${item_result_discountproduct}    ${item_dis_ratio}
    \    ${liststring_prs_invoice_detail}    Catenate    SEPARATOR=,    ${liststring_prs_invoice_detail}    ${payload_each_product}
    \    ${liststring_prs_invoice_detail1}    Catenate    SEPARATOR=,    ${liststring_prs_invoice_detail1}    ${payload_each_product_1}
    Log    ${liststring_prs_invoice_detail}
    Log    ${liststring_prs_invoice_detail1}
    ${liststring_prs_invoice_detail}    Replace String    ${liststring_prs_invoice_detail}    needdel,    ${EMPTY}    count=1
    ${liststring_prs_invoice_detail1}    Replace String    ${liststring_prs_invoice_detail1}    needdel,    ${EMPTY}    count=1
    ${ggdth_ratio_actual}    Set Variable If    0<${item_change}<100 and '${item_change_type}'=='dis'    ${input_ggdth}    null
    ${request_payload}    Format String    {{"Return":{{"BranchId":{0},"RetailerId":{1},"InvoiceId":{13},"ReceivedById":{2},"ReceivedBy":{{"CreatedBy":0,"CreatedDate":"2019-04-23T10:22:08.910Z","GivenName":"admin","Id":{2},"IsActive":true,"IsAdmin":true,"Type":0,"isDeleted":false,"Name":"admin"}},"SaleChannelId":0,"SaleChannel":null,"Code":"Trả hàng 1","ReturnDiscount":0,"ReturnFee":{3},"ReturnFeeRatio":{4},"ReturnDetails":[{5}],"InvoiceDetails":[{6}],"InvoiceOrderSurcharges":[],"Status":1,"Surcharge":0,"Type":3,"Uuid":"W156707476984266","PayingAmount":{7},"SumTotal":{8},"TotalBeforeDiscount":600000,"ProductDiscount":60000,"TotalInvoice":{9},"TotalReturn":335160,"txtPay":"Tiền khách trả","addToAccount":"0","InvoiceComparePurchaseDate":"2019-08-29T17:24:55.2870000+07:00","ReturnSurcharges":[],"CreatedBy":{2}}},"Invoice":{{"BranchId":{0},"RetailerId":{1},"UpdateInvoiceId":0,"UpdateReturnId":0,"SoldById":{2},"SoldBy":{{"CreatedBy":0,"CreatedDate":"2019-04-23T10:22:08.910Z","GivenName":"admin","Id":{2},"IsActive":true,"IsAdmin":true,"Type":0,"isDeleted":false,"Name":"admin"}},"SaleChannelId":0,"SaleChannel":null,"Seller":{{"CreatedBy":0,"CreatedDate":"2019-04-23T10:22:08.910Z","GivenName":"admin","Id":20447,"IsActive":true,"IsAdmin":true,"Type":0,"isDeleted":false,"Name":"admin"}},"OrderCode":"","Discount":{10},"DiscountRatio":{11},"InvoiceDetails":[{12}],"InvoiceOrderSurcharges":[],"Payments":[{{"Method":"Cash","MethodStr":"Tiền mặt","Amount":{7},"Id":-1}}],"Status":1,"Total":{9},"Surcharge":0,"Type":1,"Uuid":"W156707476984266","addToAccount":"0","PayingAmount":{7},"TotalBeforeDiscount":600000,"ProductDiscount":60000,"DebugUuid":"156707476973135","InvoiceWarranties":[],"CreatedBy":20447}}}}    ${BRANCH_ID}    ${get_id_nguoitao}    ${get_id_nguoiban}    ${result_phi_th}
    ...    ${input_phi_th}    ${liststring_prs_return_detail}    ${liststring_prs_invoice_detail}    ${actual_khtt}    ${result_kh_canthanhtoan}    ${result_tongtienmua_tru_gg}
    ...    ${result_ggdth}    ${ggdth_ratio_actual}    ${liststring_prs_invoice_detail1}    ${get_invoice_id}
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
    Run Keyword If    ${result_cantrakhach}>0    Should Be Equal As Numbers    ${get_cantrakhach_af_ex}    ${result_cantrakhach}
    ...    ELSE    Should Be Equal As Numbers    ${get_cantrakhach_af_ex}    0
    Should Be Equal As Numbers    ${get_datrakhach_af_ex}    ${actuall_trahang}
    Should Be Equal As Numbers    ${get_tongtien_hoadontra_af_ex}    ${result_tongtientra_tru_phith}
    Validate return history by invoice code    ${get_ma_hd}    ${return_code}    ${result_tongtientra}
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
    #assert so quy
    ${code}    Set Variable If    ${result_tongtienmua_tru_gg}<${result_tongtientra_tru_phith}    ${return_code}    ${get_additional_invoice_code}
    ${get_maphieu_soquy}    Get Ma Phieu Thu in So quy    ${code}
    Run Keyword If    '${input_khtt}' == '0'    Validate So quy info from Rest API if Invoice is not paid    ${get_maphieu_soquy}
    ...    ELSE    Validate So quy info from Rest API if Invoice is paid    ${get_maphieu_soquy}    ${actual_khtt}
