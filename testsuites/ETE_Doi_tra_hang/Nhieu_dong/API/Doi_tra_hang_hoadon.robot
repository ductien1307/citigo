*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    ${headless_browser}
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
&{list_productnums_TH1}    DTDV7=90
&{list_productnums_TH2}    DTH009=5
&{list_productnums_DTH01}    DTH011=3.2    DTU006=2.4    DTDV8=3    DTCombo08=2    DTS06=1
@{discount}           14         0     10000     105000    220000
@{discount_type}      dis     none     disvnd    changedown    changeup
@{list_soluong_addrow}   2     5,3,4       3.5,2.75     1        1,2
@{discount_addrow}   59000     10,0,700000.55        15,5000      135000.47         0,250000
@{discount_type_addrow}  changedown    dis,none,changeup     dis,disvnd   changedown    none,changeup

*** Test Cases ***    Mã KH         List product trả hàng      List product đổi trả hàng    Phí trả hàng    List GGSP      List discount type           GGDTH    Khách thanh toán    List nums addrow         List ggsp addrow        List type addrow
Them dong              [Tags]        AETDM
                      [Template]    edtm03
                      CTKH050       ${list_productnums_TH1}    ${list_productnums_DTH01}    15000              ${discount}     ${discount_type}              20000        all        ${list_soluong_addrow}    ${discount_addrow}      ${discount_type_addrow}

Them 50 dong             [Tags]        AETDM
                      [Template]    edtm04
                      CTKH051       ${list_productnums_TH2}    DTCombo05    1    20              15        2000000         200000

*** Keywords ***
edtm03
    [Arguments]    ${input_ma_kh}    ${dic_productnums_th}    ${dic_productnums_dth}    ${input_phi_th}    ${list_ggsp}    ${list_discounttype}
    ...    ${input_ggdth}    ${input_khtt}    ${list_nums_addrow}   ${list_discount_addrow}    ${list_discount_type_addrow}
    ${list_nums_addrow}   ${list_discount_addrow}    ${list_discount_type_addrow}   Convert three string list to composite list    ${list_nums_addrow}    ${list_discount_addrow}
    ...    ${list_discount_type_addrow}
    ${get_ma_hd}    Add new invoice no payment frm API    ${input_ma_kh}    ${dic_productnums_th}
    ${list_product_dth}    Get Dictionary Keys    ${dic_product_nums_dth}
    ${list_nums_dth}    Get Dictionary Values    ${dic_product_nums_dth}
    Create list imei and other product   ${list_product_dth}    ${list_nums_dth}
    #get data frm Trả hàng
    ${get_no_bf_execute}    Get Du no cuoi KH from API    ${input_ma_kh}
    ${list_product_th}    Get Dictionary Keys    ${dic_product_nums_th}
    ${list_nums_th}    Get Dictionary Values    ${dic_product_nums_th}
    ${list_giatri_quydoi}    Get list gia tri quy doi frm product API    ${list_product_dth}
    ${get_list_status_dth}    Get list imei status thr API    ${list_product_dth}
    ${list_imei_inlist}   Create list imei incase other product have multi row    ${list_product_dth}    ${list_nums_addrow}    ${get_list_status_dth}
    ${get_list_hh_in_hd}    ${get_list_sl_in_hd}    Get list product and quantity frm invoice API    ${get_ma_hd}
    ${get_list_sl_in_hd}    Convert String to List    ${get_list_sl_in_hd}
    ${list_result_thanhtien_th}    ${list_giavon_th}    ${list_result_toncuoi_th}    Get list total sale - endingstock - cost frm product api    ${get_list_hh_in_hd}    ${get_list_sl_in_hd}
    ${list_result_tongtienmua_tru_gg}    ${list_giavon_dth}    ${list_result_toncuoi_dth}    Get list total sale - endingstock - cost incase discount and newprice with additional invoice    ${list_product_dth}
    ...    ${list_nums_dth}    ${list_ggsp}   ${list_discounttype}
    ${list_result_thanhtien_addrow}      ${list_result_newprice_addrow}   ${list_result_toncuoi}    ${list_result_soluong}   Get list total sale - ending stock - total quantity incase add row product    ${list_product_dth}
    ...    ${list_nums_addrow}    ${list_discount_addrow}    ${list_discount_type_addrow}    ${list_result_toncuoi_dth}    ${list_nums_dth}    ${list_giatri_quydoi}
    ${get_list_baseprice}    Get list of Baseprice by Product Code    ${list_product_dth}
    #compute trả hàng
    ${result_tongtientra}    Sum values in list    ${list_result_thanhtien_th}
    ${result_phi_th}    Run Keyword If    0 < ${input_phi_th} < 100    Convert % discount to VND and round    ${result_tongtientra}    ${input_phi_th}
    ...    ELSE    Set Variable    ${input_phi_th}
    ${result_tongtientra_tru_phith}    Minus and round 2    ${result_tongtientra}    ${result_phi_th}
    #compute mua hàng
    ${result_tongtien_mua}    Sum values in list    ${list_result_tongtienmua_tru_gg}
    ${result_tongtienmua_addrow}    Sum values in list    ${list_result_thanhtien_addrow}
    ${result_tongtienmua}   Sum and replace floating point    ${result_tongtien_mua}    ${result_tongtienmua_addrow}
    ${result_ggdth}    Run Keyword If    0 < ${input_ggdth} < 100    Convert % discount to VND and round    ${result_tongtienmua}    ${input_ggdth}
    ...    ELSE    Set Variable    ${input_ggdth}
    ${result_tongtienmua_tru_gg}    Minus    ${result_tongtienmua}    ${result_ggdth}
    ${result_khachthanhtoan}    Minus and round 2    ${result_tongtienmua_tru_gg}    ${result_tongtientra_tru_phith}
    ${result_cantrakhach}    Minus and round 2    ${result_tongtientra_tru_phith}    ${result_tongtienmua_tru_gg}
    ${result_kh_canthanhtoan}    Set Variable If    ${result_tongtienmua_tru_gg}<${result_tongtientra_tru_phith}    ${result_cantrakhach}    ${result_khachthanhtoan}
    ${result_khtt}    Set Variable If    "${input_khtt}" == "all"    ${result_kh_canthanhtoan}    ${input_khtt}
    ${actual_khtt}    Set Variable If    "${input_khtt}" == "0"    0    ${result_khtt}
    ${actuall_trahang}    Set Variable If    ${result_tongtienmua_tru_gg}<${result_tongtientra_tru_phith}    ${actual_khtt}    0
    #compute KH
    ${result_du_no_th_KH}    Minus    ${get_no_bf_execute}    ${result_tongtientra_tru_phith}
    ${result_PTT_th_KH}    Run Keyword If    ${result_tongtienmua_tru_gg}<${result_tongtientra_tru_phith}    Sum    ${result_du_no_th_KH}    ${actual_khtt}
    ...    ELSE    Set Variable    ${result_du_no_th_KH}
    ${result_du_no_KH}    Sum and replace floating point    ${result_PTT_th_KH}    ${result_tongtienmua_tru_gg}
    ${result_PTT_dth_KH}    Run Keyword If    ${result_tongtienmua_tru_gg}>${result_tongtientra_tru_phith}    Minus    ${result_du_no_KH}    ${actual_khtt}
    ...    ELSE    Set Variable    ${result_du_no_KH}
    #info doi tra hang
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${jsonpath_id_kh}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_kh}
    ${get_id_kh}    Get data from API    ${endpoint_khachhang}    ${jsonpath_id_kh}
    ${endpoint_danhmuc_hh_co_dvt}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${get_resp_danhmuc_hh}    Get Request and return body    ${endpoint_danhmuc_hh_co_dvt}
    ${get_invoice_id}    Get invoice id    ${get_ma_hd}
    #return
    ${list_jsonpath_id_sp_th}    ${list_jsonpath_giaban_th}    Get list jsonpath product frm list product    ${list_product_th}
    ${list_giaban_th}    ${list_id_sp_th}    Get product info frm list jsonpath product    ${get_resp_danhmuc_hh}    ${list_jsonpath_id_sp_th}    ${list_jsonpath_giaban_th}
    ${liststring_prs_return_detail}    Set Variable    needdel
    : FOR    ${item_product_id}    ${item_price}    ${item_num}    IN ZIP    ${list_id_sp_th}    ${list_giaban_th}    ${list_nums_th}
    \    ${payload_return_product}    Format string    {{"BasePrice":{0},"IsLotSerialControl":false,"Note":"","Price":{0},"ProductId":{1},"Quantity":{2},"SellPrice":{0},"ProductName":"Túi 8 Bánh Socola Kitkat Trà Xanh SB","CopiedPrice":{0},"ProductBatchExpireId":null}}    ${item_price}    ${item_product_id}    ${item_num}
    \    ${liststring_prs_return_detail}    Catenate    SEPARATOR=,    ${liststring_prs_return_detail}    ${payload_return_product}
    Log    ${liststring_prs_return_detail}
    ${liststring_prs_return_detail}    Replace String    ${liststring_prs_return_detail}    needdel,    ${EMPTY}    count=1
    #payload product DTH
    ${list_jsonpath_id_sp_dth}    ${list_jsonpath_giaban_dth}    Get list jsonpath product frm list product    ${list_product_dth}
    ${list_giaban_dth}    ${list_result_ggsp_dth}    ${list_id_sp_dth}    Get product info frm list jsonpath product have discount product    ${get_resp_danhmuc_hh}    ${list_jsonpath_id_sp_dth}    ${list_jsonpath_giaban_dth}    ${list_ggsp}
    ${list_giaban_dth_addrow}    ${list_result_ggsp_dth_addrow}    ${list_id_sp_dth_addrow}    Get product info frm multi row jsonpath product have discount product    ${get_resp_danhmuc_hh}    ${list_jsonpath_id_sp_dth}    ${list_jsonpath_giaban_dth}
    ...     ${list_discount_addrow}    ${list_discount_type_addrow}
    ${liststring_prs_invoice_detail}     Create List
    : FOR    ${item_pr_id}    ${item_nums_dth}    ${item_giaban}    ${item_ggsp_dth}   ${result_ggsp}    ${item_imei}    ${item_nums_dth_addrow}
    ...     ${item_ggsp_dth_addrow}   ${result_ggsp_addrow}    ${item_imei_addrow}   ${imei_status}    IN ZIP    ${list_id_sp_dth}    ${list_nums_dth}    ${list_giaban_dth}
    ...   ${list_ggsp}    ${list_result_ggsp_dth}    ${imei_inlist}     ${list_nums_addrow}   ${list_discount_addrow}    ${list_result_ggsp_dth_addrow}
    ...    ${list_imei_inlist}    ${get_list_status_dth}
    \    ${payload_product}     Run Keyword If    '${imei_status}' == '0'    Get payload product incase multi row product and additional invoice    ${item_pr_id}    ${item_nums_dth}    ${item_giaban}    ${item_ggsp_dth}
    \    ...    ${result_ggsp}    ${item_nums_dth_addrow}    ${item_ggsp_dth_addrow}    ${result_ggsp_addrow}
    \    ...    ELSE    Get payload imei product incase multi row product and additional invoice    ${item_pr_id}    ${item_nums_dth}    ${item_giaban}    ${item_ggsp_dth}
    \    ...    ${result_ggsp}    ${item_imei}    ${item_nums_dth_addrow}    ${item_ggsp_dth_addrow}    ${result_ggsp_addrow}    ${item_imei_addrow}
    \     Append To List    ${liststring_prs_invoice_detail}    ${payload_product}
    ${liststring_prs_invoice_detail}    Convert List to String    ${liststring_prs_invoice_detail}
    Log     ${liststring_prs_invoice_detail}
    #payload product DTH 1
    ${list_nums_dth}    ${list_discount_dth}    ${list_type_discount_dth}    Add value into three composite list    ${list_nums_addrow}   ${list_discount_addrow}    ${list_discount_type_addrow}
    ...    ${list_nums_dth}    ${list_ggsp}    ${list_discounttype}
    ${list_jsonpath_id_sp_dth}    ${list_jsonpath_giaban_dth}    Get list jsonpath product frm list product    ${list_product_dth}
    ${list_giaban_dth}    ${list_result_ggsp_dth}    ${list_id_sp_dth}    Get product info frm multi row jsonpath product have discount product    ${get_resp_danhmuc_hh}    ${list_jsonpath_id_sp_dth}    ${list_jsonpath_giaban_dth}
    ...    ${list_discount_dth}    ${list_type_discount_dth}
    ${list_imei_inlist}   Convert string list to composite list    ${list_imei_inlist}
    ${list_imei_gop}    Create List
    :FOR  ${imei1}    ${imei2}    ${status}   IN ZIP    ${imei_inlist}    ${list_imei_inlist}    ${get_list_status_dth}
    \     Run Keyword If    '${status}' == 'True'    Append To List    ${list_imei_gop}    ${imei1}     ELSE    Log    Ingore
    \     Run Keyword If    '${status}' == 'True'    Append To List    ${list_imei_gop}    ${imei2}     ELSE    Log    Ingore
    Remove From List    ${list_imei_inlist}    3
    Insert Into List    ${list_imei_inlist}    3    ${list_imei_gop}
    Log     ${list_imei_inlist}
    ${liststring_prs_invoice_detail1}     Create List
    :FOR    ${item_giaban}    ${result_ggsp}    ${item_pr_id}    ${item_num}    ${item_ggsp}    ${item_discount_type}   ${item_imei}    ${imei_status1}    IN ZIP    ${list_giaban_dth}    ${list_result_ggsp_dth}    ${list_id_sp_dth}
    ...    ${list_nums_dth}    ${list_discount_dth}    ${list_type_discount_dth}    ${list_imei_inlist}    ${get_list_status_dth}
    \    ${liststring_prs_invoice_detail1}    Run Keyword If    '${imei_status1}' == '0'    Get payload product incase create additional invoice    ${item_pr_id}    ${item_num}    ${item_giaban}    ${item_ggsp}
    \    ...   ${item_discount_type}   ${result_ggsp}    ${liststring_prs_invoice_detail1}    ELSE    Get payload imei product incase create additional invoice    ${item_pr_id}    ${item_num}    ${item_giaban}    ${item_ggsp}
    \    ...   ${item_discount_type}   ${item_imei}    ${result_ggsp}    ${liststring_prs_invoice_detail1}
    ${liststring_prs_invoice_detail1}    Convert List to String    ${liststring_prs_invoice_detail1}
    Log     ${liststring_prs_invoice_detail1}
    ###
    ${dis_ratio_actual}    Set Variable If    ${input_ggdth}>100    null    ${input_ggdth}
    ${request_payload}    Format String    {{"Return":{{"BranchId":{0},"RetailerId":{1},"InvoiceId":{2},"CustomerId":{3},"ReceivedById":{4},"ReceivedBy":{{"CreatedBy":0,"CreatedDate":"2019-04-23T10:22:08.910Z","GivenName":"admin","Id":{4},"IsActive":true,"IsAdmin":true,"Type":0,"isDeleted":false,"Name":"admin"}},"SaleChannelId":0,"SaleChannel":null,"Code":"Trả hàng 1","ReturnDiscount":0,"ReturnFee":{5},"ReturnFeeRatio":{6},"ReturnDetails":[{7}],"InvoiceDetails":[{8}],"InvoiceOrderSurcharges":[],"Payments":[{{"Method":"Cash","MethodStr":"Tiền mặt","Amount":{9},"Id":-1}}],"Status":1,"Surcharge":0,"Type":3,"Uuid":"","PayingAmount":{9},"SumTotal":{10},"TotalBeforeDiscount":600000,"ProductDiscount":60000,"TotalInvoice":{11},"TotalReturn":335160,"txtPay":"Tiền khách trả","addToAccount":"0","InvoiceComparePurchaseDate":"2019-08-29T17:24:55.2870000+07:00","ReturnSurcharges":[],"CreatedBy":{4}}},"Invoice":{{"BranchId":{0},"RetailerId":{1},"UpdateInvoiceId":0,"UpdateReturnId":0,"CustomerId":{3},"SoldById":{4},"SoldBy":{{"CreatedBy":0,"CreatedDate":"2019-04-23T10:22:08.910Z","GivenName":"admin","Id":{4},"IsActive":true,"IsAdmin":true,"Type":0,"isDeleted":false,"Name":"admin"}},"SaleChannelId":0,"SaleChannel":null,"Seller":{{"CreatedBy":0,"CreatedDate":"2019-04-23T10:22:08.910Z","GivenName":"admin","Id":20447,"IsActive":true,"IsAdmin":true,"Type":0,"isDeleted":false,"Name":"admin"}},"OrderCode":"","Discount":{12},"DiscountRatio":{13},"InvoiceDetails":[{14}],"InvoiceOrderSurcharges":[],"Status":1,"Total":{11},"Surcharge":0,"Type":1,"Uuid":"","addToAccount":"0","PayingAmount":{9},"TotalBeforeDiscount":600000,"ProductDiscount":60000,"DebugUuid":"","InvoiceWarranties":[],"CreatedBy":20447}}}}    ${BRANCH_ID}    ${get_id_nguoitao}        ${get_invoice_id}    ${get_id_kh}   ${get_id_nguoiban}    ${result_phi_th}
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
    : FOR    ${item_ma_hh}    ${result_toncuoi}    ${item_giavon}    ${get_soluong_in_dth}    ${get_giatri_quydoi_dth}    IN ZIP
    ...    ${list_product_dth}    ${list_result_toncuoi}    ${list_giavon_dth}    ${list_result_soluong}    ${list_giatri_quydoi}
    \    Run Keyword If    '${get_giatri_quydoi_dth}' == '1'    Validate onhand and cost frm API    ${get_additional_invoice_code}    ${item_ma_hh}    ${result_toncuoi}
    \    ...    ${item_giavon}    ${get_soluong_in_dth}
    \    ...    ELSE    Validate onhand and cost frm unit product    ${get_additional_invoice_code}    ${item_ma_hh}    ${result_toncuoi}
    \    ...    ${item_giavon}    ${get_soluong_in_dth}    ${get_giatri_quydoi_dth}
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
    Should Be Equal As Strings    ${get_ma_kh_by_hd_af_ex}    ${input_ma_kh}
    Should Be Equal As Strings    ${get_trangthai_af_ex}    Hoàn thành
    #assert customer and so quy
    ${get_no_af_execute_kh}    Get Du no cuoi KH from API    ${input_ma_kh}
    Should Be Equal As Numbers    ${get_no_af_execute_kh}    ${result_PTT_dth_KH}
    Delete return thr API    ${return_code}

edtm04
    [Arguments]    ${input_ma_kh}    ${dic_productnums_th}    ${input_product_dth}    ${input_nums_dth}    ${input_phi_th}    ${input_ggdth}    ${input_khtt}    ${input_khtt_hd}
    ${get_ma_hd}    Add new invoice frm API    ${input_ma_kh}    ${dic_productnums_th}    ${input_khtt_hd}
    #get data frm Trả hàng
    ${get_no_bf_execute}    Get Du no cuoi KH from API    ${input_ma_kh}
    ${list_product_th}    Get Dictionary Keys    ${dic_product_nums_th}
    ${list_nums_th}    Get Dictionary Values    ${dic_product_nums_th}
    ${list_result_thanhtien_th}    ${list_giavon_th}    ${list_result_toncuoi_th}    Get list total sale - endingstock - cost frm product api    ${list_product_th}    ${list_nums_th}
    ${get_onhand_dth}    ${get_baseprice}   Get Onhand and Baseprice frm API    ${input_product_dth}
    ${result_thanhtien_dth}     Multiplication with price round 2    ${get_baseprice}   51
    #compute trả hàng
    ${result_tongtientra}    Sum values in list    ${list_result_thanhtien_th}
    ${result_phi_th}    Run Keyword If    0 < ${input_phi_th} < 100    Convert % discount to VND and round    ${result_tongtientra}    ${input_phi_th}
    ...    ELSE    Set Variable    ${input_phi_th}
    ${result_tongtientra_tru_phith}    Minus and round 2    ${result_tongtientra}    ${result_phi_th}
    #compute mua hàng
    ${result_ggdth}    Run Keyword If    0 < ${input_ggdth} < 100    Convert % discount to VND and round    ${result_thanhtien_dth}    ${input_ggdth}
    ...    ELSE    Set Variable    ${input_ggdth}
    ${result_tongtienmua_tru_gg}    Minus and round 2       ${result_thanhtien_dth}     ${result_ggdth}
    ${result_khachthanhtoan}    Minus and round 2    ${result_tongtienmua_tru_gg}    ${result_tongtientra_tru_phith}
    ${result_cantrakhach}    Minus and round 2    ${result_tongtientra_tru_phith}    ${result_tongtienmua_tru_gg}
    ${result_kh_canthanhtoan}    Set Variable If    ${result_tongtienmua_tru_gg}<${result_tongtientra_tru_phith}    ${result_cantrakhach}    ${result_khachthanhtoan}
    ${result_khtt}    Set Variable If    "${input_khtt}" == "all"    ${result_kh_canthanhtoan}    ${input_khtt}
    ${actual_khtt}    Set Variable If    "${input_khtt}" == "0"    0    ${result_khtt}
    ${actuall_trahang}    Set Variable If    ${result_tongtienmua_tru_gg}<${result_tongtientra_tru_phith}    ${actual_khtt}    0
    #compute KH
    ${result_du_no_th_KH}    Minus    ${get_no_bf_execute}    ${result_tongtientra_tru_phith}
    ${result_PTT_th_KH}    Run Keyword If    ${result_tongtienmua_tru_gg}<${result_tongtientra_tru_phith}    Sum    ${result_du_no_th_KH}    ${actual_khtt}
    ...    ELSE    Set Variable    ${result_du_no_th_KH}
    ${result_du_no_dth_KH}    Sum and replace floating point    ${result_PTT_th_KH}    ${result_tongtienmua_tru_gg}
    ${result_PTT_dth_KH}    Run Keyword If    ${result_tongtienmua_tru_gg}>${result_tongtientra_tru_phith}    Minus    ${result_du_no_dth_KH}    ${actual_khtt}
    ...    ELSE    Set Variable    ${result_du_no_dth_KH}
    #info doi tra hang
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${jsonpath_id_kh}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_kh}
    ${get_id_kh}    Get data from API    ${endpoint_khachhang}    ${jsonpath_id_kh}
    ${endpoint_danhmuc_hh_co_dvt}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${get_resp_danhmuc_hh}    Get Request and return body    ${endpoint_danhmuc_hh_co_dvt}
    ${get_invoice_id}    Get invoice id    ${get_ma_hd}
    #return
    ${list_jsonpath_id_sp_th}    ${list_jsonpath_giaban_th}    Get list jsonpath product frm list product    ${list_product_th}
    ${list_giaban_th}    ${list_id_sp_th}    Get product info frm list jsonpath product    ${get_resp_danhmuc_hh}    ${list_jsonpath_id_sp_th}    ${list_jsonpath_giaban_th}
    ${liststring_prs_return_detail}    Set Variable    needdel
    : FOR    ${item_product_id}    ${item_price}    ${item_num}    IN ZIP    ${list_id_sp_th}    ${list_giaban_th}    ${list_nums_th}
    \    ${payload_return_product}    Format string    {{"BasePrice":{0},"IsLotSerialControl":false,"Note":"","Price":{0},"ProductId":{1},"Quantity":{2},"SellPrice":{0},"ProductName":"Túi 8 Bánh Socola Kitkat Trà Xanh SB","CopiedPrice":{0},"ProductBatchExpireId":null}}    ${item_price}    ${item_product_id}    ${item_num}
    \    ${liststring_prs_return_detail}    Catenate    SEPARATOR=,    ${liststring_prs_return_detail}    ${payload_return_product}
    Log    ${liststring_prs_return_detail}
    ${liststring_prs_return_detail}    Replace String    ${liststring_prs_return_detail}    needdel,    ${EMPTY}    count=1
    #payload product DTH
    ${liststring_prs_invoice_detail}     Create List
    ${id_product}   Get product id thr API    ${input_product_dth}
    ${liststring_prs_addrow}    Set Variable    needdel
    : FOR    ${item}    IN RANGE      51
    \    ${payload_duplicate_product}    Format String    {{"ProductId":{0},"ProductName":"chuột quang hồng","ProductFullName":"chuột quang hồng","ProductNameNoUnit":"chuột quang hồng","ProductAttributeLabel":"","ProductSName":"chuột quang hồng","ProductCode":"SI001","ProductType":2,"ProductCategoryId":794174,"MasterProductId":{0},"OnHand":20,"OnOrder":0,"Reserved":64,"Price":{1},"OriginSalePrice":{1},"Unit":"","Note":"","PromotionReceiverQty":1,"Quantity":{2},"ProductSerials":[],"IsLotSerialControl":true,"IsRewardPoint":false,"CurrentQuery":"SI001","CategoryId":794174,"Discount":0,"DiscountRatio":0,"BasePrice":{1},"isDeleted":false,"ProductShelves":[],"AllowSale":true,"ProductWarranty":[],"Formulas":null,"CartType":{2},"Units":[],"MaxQuantity":null,"SerialNumbers":"","IsMaster":false,"ChildNumber":0,"subBatchProducts":null,"BatchExpire":null,"Uuid":""}}
    \    ...    ${id_product}    ${get_baseprice}    ${input_nums_dth}
    \    ${liststring_prs_addrow}    Catenate    SEPARATOR=,    ${liststring_prs_addrow}    ${payload_duplicate_product}
    ${liststring_prs_addrow}    Replace String    ${liststring_prs_addrow}    needdel,    ${EMPTY}    count=1
    Log    ${liststring_prs_addrow}
    ${payload_product}    Format String    {{"ProductId":{0},"ProductName":"chuột quang hồng","ProductFullName":"chuột quang hồng","ProductNameNoUnit":"chuột quang hồng","ProductAttributeLabel":"","ProductSName":"chuột quang hồng","ProductCode":"SI001","ProductType":2,"ProductCategoryId":794174,"MasterProductId":{0},"OnHand":20,"OnOrder":0,"Reserved":64,"Price":{1},"OriginSalePrice":{1},"Unit":"","Note":"","PromotionReceiverQty":1,"Quantity":{2},"ProductSerials":[],"Serials":[],"IsLotSerialControl":true,"IsRewardPoint":false,"CurrentQuery":"SI001","CategoryId":794174,"Promotions":[],"BasePrice":{1},"DuplicationCartItems":[{3}],"isDeleted":false,"ProductShelves":[],"AllowSale":true,"ProductWarranty":[],"Formulas":null,"Uuid":"","CartType":3,"Units":[],"MaxQuantity":null,"SerialNumbers":"","discountPriceWoRound":0,"discountRatioPriceWoRound":0,"IsMaster":true}}
    ...    ${id_product}    ${get_baseprice}    ${input_nums_dth}    ${liststring_prs_addrow}
    ${liststring_prs_invoice_detail}    Catenate    SEPARATOR=,    ${liststring_prs_invoice_detail}    ${payload_product}
    Log    ${liststring_prs_invoice_detail}
    ${liststring_prs_invoice_detail}    Replace String    ${liststring_prs_invoice_detail}    needdel,    ${EMPTY}    count=1
    Log     ${liststring_prs_invoice_detail}
    #payload product DTH 1
    ${liststring_prs_invoice_detail1}     Create List
    : FOR    ${item}    IN RANGE      51
    \    ${payload_each_product}    Format String    {{"BasePrice":{0},"IsLotSerialControl":true,"IsRewardPoint":false,"Note":"","Price":{0},"OriginPrice":{0},"ProductId":{1},"Quantity":{2},"SerialNumbers":"","Discount":0,"DiscountRatio":0,"ProductName":"Máy Làm Tỏi Đen Tiross TS906 - Màu Bạc","ProductCode":"DTS05","ProductBatchExpireId":null,"Uuid":""}}
    \    ...    ${get_baseprice}    ${id_product}    ${input_nums_dth}
    \    Append To List      ${liststring_prs_invoice_detail1}    ${payload_each_product}
    ${liststring_prs_invoice_detail1}    Convert List to String    ${liststring_prs_invoice_detail1}
    Log     ${liststring_prs_invoice_detail1}
    ###
    ${dis_ratio_actual}    Set Variable If    ${input_ggdth}>100    null    ${input_ggdth}
    ${request_payload}    Format String    {{"Return":{{"BranchId":{0},"RetailerId":{1},"InvoiceId":{2},"CustomerId":{3},"ReceivedById":{4},"ReceivedBy":{{"CreatedBy":0,"CreatedDate":"2019-04-23T10:22:08.910Z","GivenName":"admin","Id":{4},"IsActive":true,"IsAdmin":true,"Type":0,"isDeleted":false,"Name":"admin"}},"SaleChannelId":0,"SaleChannel":null,"Code":"Trả hàng 1","ReturnDiscount":0,"ReturnFee":{5},"ReturnFeeRatio":{6},"ReturnDetails":[{7}],"InvoiceDetails":[{8}],"InvoiceOrderSurcharges":[],"Status":1,"Surcharge":0,"Type":3,"Uuid":"","PayingAmount":{9},"SumTotal":{10},"TotalBeforeDiscount":600000,"ProductDiscount":60000,"TotalInvoice":{11},"TotalReturn":335160,"txtPay":"Tiền khách trả","addToAccount":"0","InvoiceComparePurchaseDate":"2019-08-29T17:24:55.2870000+07:00","ReturnSurcharges":[],"CreatedBy":{4}}},"Invoice":{{"BranchId":{0},"RetailerId":{1},"UpdateInvoiceId":0,"UpdateReturnId":0,"CustomerId":{3},"SoldById":{4},"SoldBy":{{"CreatedBy":0,"CreatedDate":"2019-04-23T10:22:08.910Z","GivenName":"admin","Id":{4},"IsActive":true,"IsAdmin":true,"Type":0,"isDeleted":false,"Name":"admin"}},"SaleChannelId":0,"SaleChannel":null,"Seller":{{"CreatedBy":0,"CreatedDate":"2019-04-23T10:22:08.910Z","GivenName":"admin","Id":20447,"IsActive":true,"IsAdmin":true,"Type":0,"isDeleted":false,"Name":"admin"}},"OrderCode":"","Discount":{12},"DiscountRatio":{13},"InvoiceDetails":[{14}],"InvoiceOrderSurcharges":[],"Payments":[{{"Method":"Cash","MethodStr":"Tiền mặt","Amount":{9},"Id":-1}}],"Status":1,"Total":{11},"Surcharge":0,"Type":1,"Uuid":"","addToAccount":"0","PayingAmount":{9},"TotalBeforeDiscount":600000,"ProductDiscount":60000,"DebugUuid":"","InvoiceWarranties":[],"CreatedBy":20447}}}}    ${BRANCH_ID}    ${get_id_nguoitao}    ${get_invoice_id}    ${get_id_kh}    ${get_id_nguoiban}    ${result_phi_th}    ${input_phi_th}    ${liststring_prs_return_detail}    ${liststring_prs_invoice_detail}
    ...   ${actual_khtt}    ${result_kh_canthanhtoan}    ${result_tongtienmua_tru_gg}    ${result_ggdth}    ${dis_ratio_actual}    ${liststring_prs_invoice_detail1}
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
    ${num_soluong_in_chungtu}    ${cost_in_chungtu}    ${toncuoi_in_chungtu}    Get Cost - onhand - quantity frm API after purchase    ${get_additional_invoice_code}    ${input_product_dth}
    Should Be Equal As Numbers    ${num_soluong_in_chungtu}    51
    Should Be Equal As Numbers    ${toncuoi_in_chungtu}    0
    #assert value in return
    ${get_tongtienhangtra_af_ex}    ${get_phitrahang_af_ex}    ${get_cantrakhach_af_ex}    ${get_datrakhach_af_ex}    ${get_tongtien_hoadontra_af_ex}    Get return info by return code    ${return_code}
    Should Be Equal As Numbers    ${get_tongtienhangtra_af_ex}    ${result_tongtientra}
    Should Be Equal As Numbers    ${get_phitrahang_af_ex}    ${result_phi_th}
    Should Be Equal As Numbers    ${get_datrakhach_af_ex}    ${actuall_trahang}
    Should Be Equal As Numbers    ${get_tongtien_hoadontra_af_ex}    ${result_tongtientra_tru_phith}
    #assert value in đổi hàng
    ${get_ma_kh_by_hd_af_ex}    ${get_tong_tien_hang_af_ex}    ${get_khach_tt_af_ex}    ${get_giamgia_hd_af_ex}    ${get_khach_can_tra_af_ex}    ${get_trangthai_af_ex}    Get additional invoice info incase discount by additional invoice code
    ...    ${get_additional_invoice_code}
    Should Be Equal As Numbers    ${get_tong_tien_hang_af_ex}    ${result_thanhtien_dth}
    Run Keyword If    ${result_tongtienmua_tru_gg}<${result_tongtientra_tru_phith}    Should Be Equal As Numbers    ${get_khach_can_tra_af_ex}    0
    ...    ELSE    Should Be Equal As Numbers    ${get_khach_can_tra_af_ex}    ${result_kh_canthanhtoan}
    Should Be Equal As Numbers    ${get_giamgia_hd_af_ex}    ${result_ggdth}
    Run Keyword If    ${result_tongtienmua_tru_gg}<${result_tongtientra_tru_phith}    Should Be Equal As Numbers    ${get_khach_tt_af_ex}    0
    ...    ELSE    Should Be Equal As Numbers    ${get_khach_tt_af_ex}    ${actual_khtt}
    Should Be Equal As Strings    ${get_ma_kh_by_hd_af_ex}    ${input_ma_kh}
    Should Be Equal As Strings    ${get_trangthai_af_ex}    Hoàn thành
    #assert customer and so quy
    ${get_no_af_execute_kh}    Get Du no cuoi KH from API    ${input_ma_kh}
    Should Be Equal As Numbers    ${get_no_af_execute_kh}    ${result_PTT_dth_KH}
    Delete return thr API    ${return_code}
