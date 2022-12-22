*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    ${headless_browser}
Test Setup
Test Teardown
Resource          ../../../../core/API/api_danhmuc_hanghoa.robot
Resource          ../../../../core/API/api_khachhang.robot
Resource          ../../../../core/API/api_mhbh.robot
Resource          ../../../../core/share/toast_message.robot
Resource          ../../../../core/API/api_soquy.robot
Resource          ../../../../core/share/javascript.robot
Resource          ../../../../core/Tra_hang/tra_hang_action.robot
Resource          ../../../../core/API/api_trahang.robot
Resource          ../../../../core/Tra_hang/tra_hang_page.robot
Resource          ../../../../core/Tra_hang/tra_hang_popup_page.robot
Resource          ../../../../core/Ban_Hang/banhang_action.robot
Resource          ../../../../core/Ban_Hang/banhang_page.robot

*** Variables ***
&{invoice_1}      KLCB014=7,6.3    KLT0014=1,6    KLQD014=3,1,4    KLDV014=3    KLSI0014=2,3
&{invoice_1_product_line_num}    KLT0014=2    KLQD014=2    KLQD015=3    KLDV014=1    KLSI0014=2
&{discount_1}     KLCB014=15,0    KLT0014=0,4000    KLQD014=5,10000,0    KLDV014=99899.67    KLSI0014=130000,10
&{discount_type1}    KLCB014=dis,none    KLT0014=none,disvnd    KLQD014=dis,disvnd,none    KLDV014=changeup    KLSI0014=changeup,dis
&{product_type1}    KLCB014=com    KLT0014=pro    KLQD014=unit    KLDV014=ser    KLSI0014=imei
&{dict_edit}      KLCB014=2.3    KLT0014=0,3.4    KLQD014=2,0,3    KLDV014=2    KLSI0014=1,2
&{dict_edit1}     KLCB014=7,6.3    KLT0014=1,6    KLQD014=3,1,4    KLDV014=3    KLSI0014=2,3

*** Test Cases ***    Product and num list    Product Type        Product Line Number              Product Discount    Discount Type        Invoice Discount    Invoice Discount Type    Customer    Payment
Tra 1 phan            [Tags]                  THNDA
                      [Template]              ethnda01
                      ${invoice_1}            ${product_type1}    ${invoice_1_product_line_num}    ${discount_1}       ${discount_type1}    50000               null                     CRPKH015    0          ${dict_edit}     20    50000
                      ${invoice_1}            ${product_type1}    ${invoice_1_product_line_num}    ${discount_1}       ${discount_type1}    50000               null                     CRPKH015    50000      ${dict_edit1}    30    0

*** Keywords ***
ethnda01
    [Arguments]    ${dict_product_num}    ${dict_product_type}    ${dict_product_line_num}    ${dict_discount}    ${dict_discount_type}    ${input_invoice_discount}
    ...    ${input_invoice_discount_type}    ${input_ma_kh}    ${input_bh_khachtt}    ${dict_product_num_edit}    ${input_phi_th}    ${input_khtt}
    ${list_products}    Get Dictionary Keys    ${dict_product_num}
    ${list_nums}    Get Dictionary Values    ${dict_product_num}
    ${list_product_type}    Get Dictionary Values    ${dict_product_type}
    ${list_discount_product}    Get Dictionary Values    ${dict_discount}
    ${list_discount_type}    Get Dictionary Values    ${dict_discount_type}
    ${list_product_line_num}    Get Dictionary Values    ${dict_product_line_num}
    ${list_num_edit}    Get Dictionary Values    ${dict_product_num_edit}
    ${get_ma_hd}    Add new invoice with multi row product thr API    ${dict_product_num}    ${dict_product_type}    ${dict_product_line_num}    ${dict_discount}    ${dict_discount_type}
    ...    ${input_invoice_discount}    ${input_invoice_discount_type}    ${input_ma_kh}    ${input_bh_khachtt}
    Sleep    2s
    ${get_ma_kh_by_hd_bf_ex}    ${get_tong_tien_hang_bf_ex}    ${get_khach_tt_bf_ex}    ${get_giamgia_hd_bf_ex}    ${get_khachcantra_bf_ex}    ${get_trangthai_bf_ex}    Get invoice info incase discount by invoice code
    ...    ${get_ma_hd}
    ${get_du_no_kh}    Get Du no cuoi KH from API    ${input_ma_kh}
    ${get_ma_kh_by_hd_bf_ex}    ${get_tong_tien_hang_bf_ex}    ${get_khach_tt_bf_ex}    ${get_giamgia_hd_bf_ex}    ${get_khachcantra_bf_ex}    ${get_trangthai_bf_ex}    Get invoice info incase discount by invoice code
    ...    ${get_ma_hd}
    ${get_du_no_kh}    Get Du no cuoi KH from API    ${input_ma_kh}
    ${list_imei_actual}    Create List
    : FOR    ${item_pr_type}    ${item_list_num_edit}    ${item_list_imei}    ${item_list_num}    IN ZIP    ${list_product_type}
    ...    ${list_num_edit}    ${list_imei_all}    ${list_nums}
    \    ${item_list_num_edit}    Convert String to List    ${item_list_num_edit}
    \    ${item_list_num}    Convert String to List    ${item_list_num}
    \    ${item_imei_actual}    Run Keyword If    '${item_pr_type}' == 'imei'    Get list imei from list multi row imei    ${item_list_num_edit}    ${item_list_imei}
    \    ...    ELSE    Create list by list Quantity    ${item_list_num}
    \    Append To List    ${list_imei_actual}    ${item_imei_actual}
    Log    ${list_imei_actual}
    #compute value invoice and customer
    ${list_product_id}    ${get_list_baseprice}    ${list_result_product_discount_by_list_product_line}    ${list_result_newprice_by_list_product_line}    ${list_result_totalsale}    Get list of product id - baseprice - list result product discount - list result new price - list total sale incase changing product price    ${list_products}
    ...    ${list_nums}    ${list_discount_product}    ${list_discount_type}
    ${list_result_thanhtien}    ${list_result_toncuoi}    ${list_giavon}    Get list total sale - result onhand - cost incase return multi row product    ${list_products}    ${list_product_type}    ${list_num_edit}
    ...    ${list_discount_product}    ${list_discount_type}
    ${result_gghd}    Run Keyword If    0 < ${input_invoice_discount} < 100    Convert % discount to VND and round    ${get_tong_tien_hang_bf_ex}    ${input_invoice_discount}
    ...    ELSE    Set Variable    ${input_invoice_discount}
    ${list_result_gghd}    Create List
    : FOR    ${item_result_thanhtien}    IN    @{list_result_thanhtien}
    \    ${item_gghd}    Run Keyword If    ${input_invoice_discount} > 0    Price after apllocate discount    ${result_gghd}    ${get_tong_tien_hang_bf_ex}
    \    ...    ${item_result_thanhtien}
    \    ...    ELSE    Set Variable    0
    \    Append To List    ${list_result_gghd}    ${item_gghd}
    Log    ${list_result_gghd}
    #compute value invoice and customer
    ${result_tongtienhangtra}    Sum values in list    ${list_result_thanhtien}
    ${result_allocate_gghd}    Sum values in list and round    ${list_result_gghd}
    ${result_tongtienhangtra}    Sum values in list    ${list_result_thanhtien}
    ${result_phi_th}    Run Keyword If    0 < ${input_phi_th} < 100    Convert % discount to VND and round    ${result_tongtienhangtra}    ${input_phi_th}
    ...    ELSE    Set Variable    ${input_phi_th}
    ${result_cantrakhach}    Minusx3 and replace foating point    ${result_tongtienhangtra}    ${result_phi_th}    ${result_allocate_gghd}
    ${result_khtt}    Set Variable If    "${input_khtt}" == "all"    ${result_cantrakhach}    ${input_khtt}
    ${actual_khtt}    Set Variable If    "${input_khtt}" == "0"    0    ${result_khtt}
    #create return
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${get_id_kh}    Get customer id thr API    ${input_ma_kh}
    ${get_invoice_id}    Get invoice id    ${get_ma_hd}
    ${get_invoice_detail_id}    Get invoice detail id    ${get_ma_hd}
    # Post request BH
    ${liststring_prs_invoice_detail}    Set Variable    needdel
    Log    ${liststring_prs_invoice_detail}
    : FOR    ${item_product_id}    ${item_price}    ${item_num}    ${item_imei}    ${item_baseprice}    ${item_pr_type}
    ...    IN ZIP    ${list_product_id}    ${list_result_newprice_by_list_product_line}    ${list_num_edit}    ${list_imei_actual}    ${get_list_baseprice}
    ...    ${list_product_type}
    \    ${payload_each_product}    Create json for each product in csse return multi row    ${item_product_id}    ${item_pr_type}    ${item_num}    ${item_baseprice}
    \    ...    ${item_price}    ${item_imei}    ${get_invoice_detail_id}
    \    ${liststring_prs_invoice_detail}    Catenate    SEPARATOR=,    ${liststring_prs_invoice_detail}    ${payload_each_product}
    Log    ${liststring_prs_invoice_detail}
    ${phi_trahang}    Set Variable If    0 < ${input_phi_th} < 100    ${input_phi_th}    null
    ${liststring_prs_invoice_detail}    Replace String    ${liststring_prs_invoice_detail}    needdel,    ${EMPTY}    count=1
    ${request_payload}    Format String    {{"Return":{{"BranchId":{0},"RetailerId":{1},"InvoiceId":{2},"CustomerId":{3},"ReceivedById":{4},"ReceivedBy":{{"CreatedBy":0,"CreatedDate":"2019-04-23T10:22:08.910Z","GivenName":"admin","Id":20447,"IsActive":true,"IsAdmin":true,"Type":0,"isDeleted":false,"Name":"admin"}},"SaleChannelId":0,"SaleChannel":null,"Code":"Trả hàng 1","ReturnDiscount":{5},"ReturnFee":{6},"ReturnFeeRatio":{7},"ReturnDetails":[{9}],"InvoiceDetails":[],"InvoiceOrderSurcharges":[],"Payments":[{{"Method":"Cash","MethodStr":"Tiền mặt","Amount":{8},"Id":-1}}],"Status":1,"Surcharge":0,"Type":3,"Uuid":"W156542876173942","PayingAmount":{8},"TotalBeforeDiscount":0,"ProductDiscount":0,"TotalReturn":119990,"txtPay":"Tiền trả khách","addToAccount":"0","InvoiceComparePurchaseDate":"2019-08-10T16:18:47.1900000+07:00","ReturnSurcharges":[],"CreatedBy":20447}}}}    ${BRANCH_ID}    ${get_id_nguoitao}    ${get_invoice_id}    ${get_id_kh}
    ...    ${get_id_nguoiban}    ${result_allocate_gghd}    ${result_phi_th}    ${phi_trahang}    ${actual_khtt}    ${liststring_prs_invoice_detail}
    Log    ${request_payload}
    ${return_code}    Post request to create return and get resp    ${request_payload}
    Sleep    15s    wait for response to API
    #assert value product
    ${get_list_cost_af}    ${get_list_onhand_af}    Get list cost - onhand frm API    ${list_products}
    : FOR    ${item_cost_actual}    ${item_onhand_actual}    ${item_cost}    ${item_onhand}    IN ZIP    ${get_list_cost_af}
    ...    ${get_list_onhand_af}    ${list_giavon}    ${list_result_toncuoi}
    \    Should Be Equal As Numbers    ${item_cost_actual}    ${item_cost}
    \    Should Be Equal As Numbers    ${item_onhand_actual}    ${item_onhand}
    #assert value in invoice
    ${get_ma_kh_by_hd_af_ex}    ${get_tong_tien_hang_af_ex}    ${get_khach_tt_af_ex}    ${get_giamgia_hd_af_ex}    ${get_khachcantra_af_ex}    ${get_trangthai_af_ex}    Get invoice info incase discount by invoice code
    ...    ${get_ma_hd}
    Should Be Equal As Numbers    ${get_tong_tien_hang_af_ex}    ${get_tong_tien_hang_bf_ex}
    Should Be Equal As Numbers    ${get_khach_tt_af_ex}    ${get_khach_tt_bf_ex}
    Should Be Equal As Numbers    ${get_giamgia_hd_af_ex}    ${get_giamgia_hd_bf_ex}
    Should Be Equal As Numbers    ${get_khachcantra_af_ex}    ${get_khachcantra_bf_ex}
    Should Be Equal As Strings    ${get_ma_kh_by_hd_af_ex}    ${get_ma_kh_by_hd_bf_ex}
    Should Be Equal As Strings    ${get_trangthai_af_ex}    ${get_trangthai_bf_ex}
    #assert value in return
    ${get_tongtienhangtra_af_ex}    ${get_giamgiaphieutra}    ${get_phitrahang_af_ex}    ${get_cantrakhach_af_ex}    ${get_datrakhach_af_ex}    ${get_tongtien_hoadontra_af_ex}    Get return info incase discount by return code
    ...    ${return_code}
    Should Be Equal As Numbers    ${get_tongtienhangtra_af_ex}    ${result_tongtienhangtra}
    Should Be Equal As Numbers    ${get_giamgiaphieutra}    ${result_allocate_gghd}
    Should Be Equal As Numbers    ${get_phitrahang_af_ex}    ${result_phi_th}
    Should Be Equal As Numbers    ${get_tongtien_hoadontra_af_ex}    ${result_cantrakhach}
    Should Be Equal As Numbers    ${get_datrakhach_af_ex}    ${actual_khtt}
    Delete return thr API    ${return_code}
