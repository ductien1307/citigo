*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    ${headless_browser}
Resource          ../../../../core/API/api_danhmuc_hanghoa.robot
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
&{list_create_imei}    KLSI0009=2
&{list_product}    KLCB009=5.6    KLDV009=6.5    KLQD009=3    KLT0009=6
@{list_discount}    6000.5    10    12000    150000.6
@{list_discount_type}    dis    dis    change    change

*** Test Cases ***    Mã KH         List products and nums    List IMEI              List GGSP1          GGSP imei                GGTH    Phí trả hàng    Khách thanh toán
Basic                 [Tags]        THKLA
                      [Template]    ethkl_api_01
                      CRPKH001      ${list_product}           ${list_create_imei}    ${list_discount}    ${list_discount_type}    12      dis             5000                10    all

*** Keywords ***
ethkl_api_01
    [Arguments]    ${input_ma_kh}    ${dict_product_nums}    ${list_imei}    ${list_change}    ${list_change_type}    ${input_change_imei}
    ...    ${input_change_type_imei}    ${input_ggth}    ${input_phi_th}    ${input_khtt}
    ${get_list_status}    Get list imei status thr API    ${list_imei}
    Create invoice with imei product    ${input_ma_kh}    ${list_imei}    ${get_list_status}
    #get info tra hang
    ${input_imei_product}    Get Dictionary Keys    ${list_imei}
    ${input_imei_nums}    Get Dictionary Values    ${list_imei}
    ${input_product}    ${input_imei_nums}    Convert two list to string and return    ${input_imei_product}    ${input_imei_nums}
    ${list_products}    Get Dictionary Keys    ${dict_product_nums}
    ${list_nums}    Get Dictionary Values    ${dict_product_nums}
    #get data to validate
    Append To List    ${list_products}    ${input_product}
    Append to List    ${list_nums}    ${input_imei_nums}
    Append To List    ${list_change}    ${input_change_imei}
    Append To List    ${list_change_type}    ${input_change_type_imei}
    ${imei}    Convert list to string and return    ${imei_inlist}
    ${list_status}    Get list imei status thr API    ${list_products}
    ${imei_by_product_inlist}    Create List
    : FOR    ${item_product}    ${item_status}    IN ZIP    ${list_products}    ${list_status}
    \    ${imei_by_product}    Run Keyword If    ${item_status}==0    Set Variable    ${EMPTY}
    \    ...    ELSE    Set Variable    ${imei}
    \    Append To List    ${imei_by_product_inlist}    ${imei_by_product}
    Log many    ${imei_by_product_inlist}
    ${list_result_thanhtien}    ${list_giavon}    ${list_result_toncuoi}    Get list total sale - endingstock - cost incase changing product price    ${list_products}    ${list_nums}    ${list_change}
    ...    ${list_change_type}
    #compute
    ${result_tongtienhangtra}    Sum values in list and round    ${list_result_thanhtien}
    ${result_ggth}    Run Keyword If    0 < ${input_ggth} < 100    Convert % discount to VND and round    ${result_tongtienhangtra}    ${input_ggth}
    ...    ELSE    Set Variable    ${input_ggth}
    ${result_phi_th}    Run Keyword If    0 < ${input_phi_th} < 100    Convert % discount to VND and round    ${result_tongtienhangtra}    ${input_phi_th}
    ...    ELSE    Set Variable    ${input_phi_th}
    ${result_cantrakhach}    Minusx3 and replace foating point    ${result_tongtienhangtra}    ${result_ggth}    ${result_phi_th}
    ${result_khtt}    Set Variable If    "${input_khtt}" == "all"    ${result_cantrakhach}    ${input_khtt}
    ${actual_khtt}    Set Variable If    "${input_khtt}" == "0"    0    ${result_khtt}
    #
    ${list_productid}    Get list product id thr API    ${list_products}
    ${list_giaban}    ${list_result_ggsp}    ${list_result_newprice}    Get list baseprice - result discount - result newprice product incase changing price    ${list_products}    ${list_change}    ${list_change_type}
    ##
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${giamgia_th}    Set Variable If    0 < ${input_ggth} < 100    ${input_ggth}    null
    # Post request BH
    ${liststring_prs_invoice_detail}    Set Variable    needdel
    Log    ${liststring_prs_invoice_detail}
    : FOR    ${item_product_id}    ${item_price}    ${item_num}    ${item_result_discountproduct}    ${item_change}    ${item_change_type}
    ...    ${item_result_newprice}    ${item_imei}    IN ZIP    ${list_productid}    ${list_giaban}    ${list_nums}
    ...    ${list_result_ggsp}    ${list_change}    ${list_change_type}    ${list_result_newprice}    ${imei_by_product_inlist}
    \    ${item_imei}    Convert list to string and return    ${item_imei}
    \    ${item_dis%}    Set Variable If    0<${item_change}<100 and '${item_change_type}'=='dis'    ${item_change}    null
    \    ${payload_each_product}    Format string    {{"BasePrice":{0},"IsLotSerialControl":true,"Note":"","Price":{1},"ProductId":{2},"Quantity":{3},"SerialNumbers":"{4}","SellPrice":{0},"ProductName":"chuột quang hồng","Discount":{5},"DiscountRatio":{6},"CopiedPrice":134216.23,"ProductBatchExpireId":null}}    ${item_price}    ${item_result_newprice}    ${item_product_id}
    \    ...    ${item_num}    ${item_imei}    ${item_result_discountproduct}    ${item_dis%}
    \    ${liststring_prs_invoice_detail}    Catenate    SEPARATOR=,    ${liststring_prs_invoice_detail}    ${payload_each_product}
    Log    ${liststring_prs_invoice_detail}
    ${liststring_prs_invoice_detail}    Replace String    ${liststring_prs_invoice_detail}    needdel,    ${EMPTY}    count=1
    ${request_payload}    Format String    {{"Return":{{"BranchId":{0},"RetailerId":{1},"ReceivedById":{2},"ReceivedBy":{{"CreatedBy":0,"CreatedDate":"2019-04-23T10:22:08.910Z","Email":"","GivenName":"admin","Id":20447,"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false}},"SaleChannelId":0,"SaleChannel":null,"Code":"Trả hàng 1","ReturnDiscount":{3},"ReturnFee":{4},"ReturnFeeRatio":{5},"ReturnDetails":[{7}],"InvoiceDetails":[],"InvoiceOrderSurcharges":[],"Payments":[{{"Method":"Cash","MethodStr":"Tiền mặt","Amount":{6},"Id":-1}}],"Status":1,"Surcharge":0,"Type":3,"Uuid":"W156508247445117","PayingAmount":{6},"TotalBeforeDiscount":0,"ProductDiscount":0,"TotalReturn":262626,"txtPay":"Tiền trả khách","addToAccount":"0","addToAccountSurplus":"0","addToAccountAllocation":"0","addToAccountPaymentAllocation":"0","ReturnSurcharges":[],"CreatedBy":20447}}}}    ${BRANCH_ID}    ${get_id_nguoitao}    ${get_id_nguoiban}    ${result_ggth}
    ...    ${result_phi_th}    ${input_phi_th}    ${actual_khtt}    ${liststring_prs_invoice_detail}
    Log    ${request_payload}
    ${return_code}    Post request to create return and get resp    ${request_payload}
    Sleep    20 s    wait for response to API
    #assert value product in invoice
    ${get_list_hh_in_th_af_execute}    Get list product frm Return API    ${return_code}
    ${list_soluong_in_hd}    ${list_giatriquydoi_in_hd}    Get list quantity and gia tri quy doi with return have multi product    ${get_list_hh_in_th_af_execute}    ${return_code}
    : FOR    ${item_ma_hh}    ${result_toncuoi}    ${item_giavon}    ${get_soluong_in_hd}    ${get_giatri_quydoi}    IN ZIP
    ...    ${get_list_hh_in_th_af_execute}    ${list_result_toncuoi}    ${list_giavon}    ${list_soluong_in_hd}    ${list_giatriquydoi_in_hd}
    \    Run Keyword If    '${get_giatri_quydoi}' == '1'    Validate onhand and cost frm API    ${return_code}    ${item_ma_hh}    ${result_toncuoi}
    \    ...    ${item_giavon}    ${get_soluong_in_hd}
    \    ...    ELSE    Validate onhand and cost frm unit product    ${return_code}    ${item_ma_hh}    ${result_toncuoi}
    \    ...    ${item_giavon}    ${get_soluong_in_hd}    ${get_giatri_quydoi}
    #assert value in return
    ${get_tongtienhangtra_af_ex}    ${get_giamgiaphieutra}    ${get_phitrahang_af_ex}    ${get_cantrakhach_af_ex}    ${get_datrakhach_af_ex}    ${get_tongtien_hoadontra_af_ex}    Get return info incase discount by return code
    ...    ${return_code}
    Should Be Equal As Numbers    ${get_tongtienhangtra_af_ex}    ${result_tongtienhangtra}
    Should Be Equal As Numbers    ${get_giamgiaphieutra}    ${result_ggth}
    Should Be Equal As Numbers    ${get_phitrahang_af_ex}    ${result_phi_th}
    Should Be Equal As Numbers    ${get_datrakhach_af_ex}    ${actual_khtt}
    Should Be Equal As Numbers    ${get_tongtien_hoadontra_af_ex}    ${result_cantrakhach}
    Delete return thr API    ${return_code}
