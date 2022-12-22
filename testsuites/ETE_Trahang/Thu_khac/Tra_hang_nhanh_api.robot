*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    ${headless_browser}
Resource          ../../../core/API/api_danhmuc_hanghoa.robot
Resource          ../../../core/API/api_dathang.robot
Resource          ../../../core/API/api_khachhang.robot
Resource          ../../../core/API/api_mhbh.robot
Resource          ../../../core/Dat_Hang/dat_hang_action.robot
Resource          ../../../core/Dat_Hang/dat_hang_navigation.robot
Resource          ../../../core/Dat_Hang/dat_hang_page.robot
Resource          ../../../core/share/toast_message.robot
Resource          ../../../core/API/api_soquy.robot
Resource          ../../../core/share/javascript.robot
Resource          ../../../core/share/discount.robot
Resource          ../../../core/API/api_thietlap.robot

*** Variables ***
&{list_create_imei1}    SI024=2
&{list_create_imei2}    SI026=2
&{list_create_imei3}    SI025=1
&{list_product_tk01}    HH0040=4    DVT44=1.5    DV049=5    Combo25=2.4
&{list_product_tk02}    HH0042=1    QD101=4    DV051=1.5    Combo27=1.8
&{list_product_tk03}    HH0041=2.2  QD098=3.5    DV050=1    Combo26=5
@{list_vnd_ggsp}    2000    3000    4000    2500
@{list_%_ggsp}    5    10    15    17
@{list_giamoi}    190000.78    50000    500000    20000

*** Test Cases ***    Mã KH         List product&nums       List imei                 GGSP              GGSP IMEI     GGTH    Phí trả hàng     Khách TT    Thu khac
Khonghoantra_TH_1thukhac
                      [Tags]        AETTK
                      [Template]    aettk1
                      CTKH277       ${list_product_tk01}    ${list_create_imei1}    ${list_vnd_ggsp}    10000         50000     10000         all         TK003

Khonghoantra_TH_2thukhac
                      [Tags]        AETTK
                      [Template]    aettk2
                      CTKH278       ${list_product_tk02}    ${list_create_imei2}    ${list_%_ggsp}      20            30       16             0         TK007       TK008

Hoantra_TH_1thukhac    [Tags]        AETTK
                      [Template]    aettka1
                      CTKH279       ${list_product_tk03}    ${list_create_imei3}    ${list_giamoi}      30000      15000      0                0           TK005
                      CTKH279       ${list_product_tk03}    ${list_create_imei3}    ${list_giamoi}      10000      15         10000            100000      TK002

Hoantra_TH_2thukhac    [Tags]        AETTK
                      [Template]    aettka2
                      CTKH280       ${list_product_tk03}    ${list_create_imei3}    ${list_giamoi}      50000      15         10000       all         TK001       TK002
                      CTKH280       ${list_product_tk03}    ${list_create_imei3}    ${list_giamoi}      10000      10000      25          0           TK005       TK006
                      CTKH280       ${list_product_tk03}    ${list_create_imei3}    ${list_giamoi}      100000     50000      0          20000       TK005       TK001

*** Keywords ***
aettk1
    [Arguments]    ${input_ma_kh}    ${dict_product_nums}    ${list_imei}    ${list_ggsp}    ${input_ggsp_imei}    ${input_ggth}    ${input_phi_th}
    ...     ${input_khtt}    ${input_thukhac}
    ##Activate surcharge
    ${surcharge_vnd_value}    Get surcharge vnd value    ${input_thukhac}
    ${surcharge_%}    Get surcharge percentage value    ${input_thukhac}
    Run Keyword If    ${surcharge_%} == 0    Toggle surcharge VND    ${input_thukhac}    true
    ...    ELSE    Toggle surcharge percentage    ${input_thukhac}    true
    ${get_list_status}    Get list imei status thr API    ${list_imei}
    Create invoice with imei product    ${input_ma_kh}    ${list_imei}    ${get_list_status}
    ${input_imei_product}    Get Dictionary Keys    ${list_imei}
    ${input_imei_nums}    Get Dictionary Values    ${list_imei}
    ${input_product}    ${input_imei_nums}    Convert two list to string and return    ${input_imei_product}    ${input_imei_nums}
    ${list_products}    Get Dictionary Keys    ${dict_product_nums}
    ${list_nums}    Get Dictionary Values    ${dict_product_nums}
    #get data to validate
    ${get_list_baseprice}    Get list of Baseprice by Product Code    ${list_products}
    #
    ${imei}    Convert list to string and return    ${imei_inlist}
    ${list_status}    Get list imei status thr API    ${list_products}
    ${imei_by_product_inlist}    Create List
    : FOR    ${item_product}    ${item_status}    IN ZIP    ${list_products}    ${list_status}
    \    ${imei_by_product}    Run Keyword If    ${item_status}==0    Set Variable    ${EMPTY}
    \    ...    ELSE    Set Variable    ${imei}
    \    Append To List    ${imei_by_product_inlist}    ${imei_by_product}
    Log many    ${imei_by_product_inlist}
    ${list_result_thanhtien}    ${list_giavon}    ${list_result_toncuoi}    Get list total sale - endingstock - cost incase discount    ${list_products}    ${list_nums}    ${list_ggsp}
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
    ${endpoint_danhmuc_hh_by_branch}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${resp_product_list}    Get Request and return body    ${endpoint_danhmuc_hh_by_branch}
    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}    Get List Jsonpath Product Frm List Product    ${list_products}
    ${list_giaban}    ${list_result_ggsp}    ${list_productid}    Get product info frm list jsonpath product have discount product    ${resp_product_list}    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}
    ...    ${list_ggsp}
    ${list_result_newprice}    Get list result newprice incase discount product    ${list_products}    ${list_result_ggsp}
    ##
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${jsonpath_id_kh}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_kh}
    ${get_id_kh}    Get data from API    ${endpoint_khachhang}    ${jsonpath_id_kh}
    ${giamgia_th}    Set Variable If    0 < ${input_ggth} < 100    ${input_ggth}    null
    # Post request BH
    ${liststring_prs_return_detail}    Set Variable    needdel
    Log    ${liststring_prs_return_detail}
    : FOR    ${item_product_id}    ${item_price}    ${item_num}    ${item_result_discountproduct}    ${item_discounttype}    ${item_result_newprice}
    ...    ${item_imei}    IN ZIP    ${list_productid}    ${list_giaban}    ${list_nums}    ${list_result_ggsp}
    ...    ${list_ggsp}    ${list_result_newprice}    ${imei_by_product_inlist}
    \    ${item_imei}    Convert list to string and return    ${item_imei}
    \    ${payload_each_product}    Format string    {{"BasePrice":{0},"IsLotSerialControl":true,"Note":"","Price":{1},"ProductId":{2},"Quantity":{3},"SerialNumbers":"{4}","SellPrice":{0},"ProductName":"chuột quang hồng","Discount":{5},"DiscountRatio":{6},"CopiedPrice":134216.23,"ProductBatchExpireId":null}}    ${item_price}    ${item_result_newprice}    ${item_product_id}
    \    ...    ${item_num}    ${item_imei}    ${item_result_discountproduct}    ${item_discounttype}
    \    ${liststring_prs_return_detail}    Catenate    SEPARATOR=,    ${liststring_prs_return_detail}    ${payload_each_product}
    Log    ${liststring_prs_return_detail}
    ${liststring_prs_return_detail}    Replace String    ${liststring_prs_return_detail}    needdel,    ${EMPTY}    count=1
    ${request_payload}    Format String    {{"Return":{{"BranchId":{0},"RetailerId":{1},"CustomerId":{2},"ReceivedById":{3},"ReceivedBy":{{"CreatedBy":0,"CreatedDate":"2019-04-23T10:22:08.910Z","Email":"","GivenName":"admin","Id":20447,"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false}},"SaleChannelId":0,"SaleChannel":null,"Code":"Trả hàng 1","ReturnDiscount":{4},"ReturnFee":{5},"ReturnFeeRatio":{6},"ReturnDetails":[{8}],"InvoiceDetails":[],"InvoiceOrderSurcharges":[],"Payments":[{{"Method":"Cash","MethodStr":"Tiền mặt","Amount":{7},"Id":-1}}],"Status":1,"Surcharge":0,"Type":3,"Uuid":"W156508247445117","PayingAmount":{7},"TotalBeforeDiscount":0,"ProductDiscount":0,"TotalReturn":262626,"txtPay":"Tiền trả khách","addToAccount":"0","addToAccountSurplus":"0","addToAccountAllocation":"0","addToAccountPaymentAllocation":"0","ReturnSurcharges":[],"CreatedBy":20447}}}}    ${BRANCH_ID}    ${get_id_nguoitao}    ${get_id_kh}    ${get_id_nguoiban}
    ...    ${result_ggth}    ${result_phi_th}    ${input_phi_th}    ${actual_khtt}    ${liststring_prs_return_detail}
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
    Run Keyword If    ${surcharge_%} == 0    Toggle surcharge VND    ${input_thukhac}    false
    ...    ELSE    Toggle surcharge percentage    ${input_thukhac}    false

aettk2
    [Arguments]   ${input_ma_kh}    ${dict_product_nums}    ${list_imei}    ${list_ggsp}    ${input_ggsp_imei}    ${input_ggth}
    ...    ${input_phi_th}     ${input_khtt}    ${input_thukhac1}   ${input_thukhac2}
    #activate surcharge
    ${surcharge_value_1_vnd}    Get surcharge vnd value    ${input_thukhac1}
    ${surcharge_value_1_percentage}    Get surcharge percentage value    ${input_thukhac1}
    ${surcharge_value_2_vnd}    Get surcharge vnd value    ${input_thukhac2}
    ${surcharge_value_2_percentage}    Get surcharge percentage value    ${input_thukhac2}
    ${actual_surcharge1_value}    Set Variable If    ${surcharge_value_1_percentage} == 0    ${surcharge_value_1_vnd}    ${surcharge_value_1_percentage}
    ${actual_surcharge2_value}    Set Variable If    ${surcharge_value_2_percentage} == 0    ${surcharge_value_2_vnd}    ${surcharge_value_2_percentage}
    Run Keyword If    ${actual_surcharge1_value} > 100    Toggle surcharge VND    ${input_thukhac1}    true
    ...    ELSE    Toggle surcharge percentage    ${input_thukhac1}    true
    Run Keyword If    ${actual_surcharge2_value} > 100    Toggle surcharge VND    ${input_thukhac2}    true
    ...    ELSE    Toggle surcharge percentage    ${input_thukhac2}    true
    ${get_list_status}    Get list imei status thr API    ${list_imei}
    Create invoice with imei product    ${input_ma_kh}    ${list_imei}    ${get_list_status}
    ${input_imei_product}    Get Dictionary Keys    ${list_imei}
    ${input_imei_nums}    Get Dictionary Values    ${list_imei}
    ${input_product}    ${input_imei_nums}    Convert two list to string and return    ${input_imei_product}    ${input_imei_nums}
    ${list_products}    Get Dictionary Keys    ${dict_product_nums}
    ${list_nums}    Get Dictionary Values    ${dict_product_nums}
    #get data to validate
    ${get_list_baseprice}    Get list of Baseprice by Product Code    ${list_products}
    #
    ${imei}    Convert list to string and return    ${imei_inlist}
    ${list_status}    Get list imei status thr API    ${list_products}
    ${imei_by_product_inlist}    Create List
    : FOR    ${item_product}    ${item_status}    IN ZIP    ${list_products}    ${list_status}
    \    ${imei_by_product}    Run Keyword If    ${item_status}==0    Set Variable    ${EMPTY}
    \    ...    ELSE    Set Variable    ${imei}
    \    Append To List    ${imei_by_product_inlist}    ${imei_by_product}
    Log many    ${imei_by_product_inlist}
    ${list_result_thanhtien}    ${list_giavon}    ${list_result_toncuoi}    Get list total sale - endingstock - cost incase discount    ${list_products}    ${list_nums}    ${list_ggsp}
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
    ${endpoint_danhmuc_hh_by_branch}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${resp_product_list}    Get Request and return body    ${endpoint_danhmuc_hh_by_branch}
    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}    Get List Jsonpath Product Frm List Product    ${list_products}
    ${list_giaban}    ${list_result_ggsp}    ${list_productid}    Get product info frm list jsonpath product have discount product    ${resp_product_list}    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}
    ...    ${list_ggsp}
    ${list_result_newprice}    Get list result newprice incase discount product    ${list_products}    ${list_result_ggsp}
    ##
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${jsonpath_id_kh}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_kh}
    ${get_id_kh}    Get data from API    ${endpoint_khachhang}    ${jsonpath_id_kh}
    ${giamgia_th}    Set Variable If    0 < ${input_ggth} < 100    ${input_ggth}    null
    # Post request BH
    ${liststring_prs_return_detail}    Set Variable    needdel
    Log    ${liststring_prs_return_detail}
    : FOR    ${item_product_id}    ${item_price}    ${item_num}    ${item_result_discountproduct}    ${item_discounttype}    ${item_result_newprice}
    ...    ${item_imei}    IN ZIP    ${list_productid}    ${list_giaban}    ${list_nums}    ${list_result_ggsp}
    ...    ${list_ggsp}    ${list_result_newprice}    ${imei_by_product_inlist}
    \    ${item_imei}    Convert list to string and return    ${item_imei}
    \    ${payload_each_product}    Format string    {{"BasePrice":{0},"IsLotSerialControl":true,"Note":"","Price":{1},"ProductId":{2},"Quantity":{3},"SerialNumbers":"{4}","SellPrice":{0},"ProductName":"chuột quang hồng","Discount":{5},"DiscountRatio":{6},"CopiedPrice":134216.23,"ProductBatchExpireId":null}}    ${item_price}    ${item_result_newprice}    ${item_product_id}
    \    ...    ${item_num}    ${item_imei}    ${item_result_discountproduct}    ${item_discounttype}
    \    ${liststring_prs_return_detail}    Catenate    SEPARATOR=,    ${liststring_prs_return_detail}    ${payload_each_product}
    Log    ${liststring_prs_return_detail}
    ${liststring_prs_return_detail}    Replace String    ${liststring_prs_return_detail}    needdel,    ${EMPTY}    count=1
    ${request_payload}    Format String    {{"Return":{{"BranchId":{0},"RetailerId":{1},"CustomerId":{2},"ReceivedById":{3},"ReceivedBy":{{"CreatedBy":0,"CreatedDate":"2019-04-23T10:22:08.910Z","Email":"","GivenName":"admin","Id":20447,"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false}},"SaleChannelId":0,"SaleChannel":null,"Code":"Trả hàng 1","ReturnDiscount":{4},"ReturnFee":{5},"ReturnFeeRatio":{6},"ReturnDetails":[{8}],"InvoiceDetails":[],"InvoiceOrderSurcharges":[],"Payments":[{{"Method":"Cash","MethodStr":"Tiền mặt","Amount":{7},"Id":-1}}],"Status":1,"Surcharge":0,"Type":3,"Uuid":"W156508247445117","PayingAmount":{7},"TotalBeforeDiscount":0,"ProductDiscount":0,"TotalReturn":262626,"txtPay":"Tiền trả khách","addToAccount":"0","addToAccountSurplus":"0","addToAccountAllocation":"0","addToAccountPaymentAllocation":"0","ReturnSurcharges":[],"CreatedBy":20447}}}}    ${BRANCH_ID}    ${get_id_nguoitao}    ${get_id_kh}    ${get_id_nguoiban}
    ...    ${result_ggth}    ${result_phi_th}    ${input_phi_th}    ${actual_khtt}    ${liststring_prs_return_detail}
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
    #Delete return thr API    ${return_code}
    ## Deactivate surcharge
    Run Keyword If    ${actual_surcharge1_value} > 100    Toggle surcharge VND    ${input_thukhac1}    false
    ...    ELSE    Toggle surcharge percentage    ${input_thukhac1}    false
    Run Keyword If    ${actual_surcharge2_value} > 100    Toggle surcharge VND    ${input_thukhac2}    false
    ...    ELSE    Toggle surcharge percentage    ${input_thukhac2}    false

aettka1
    [Arguments]    ${input_ma_kh}    ${dict_product_nums}    ${list_imei}    ${list_newprice}   ${input_imei_newprice}    ${input_ggth}
    ...    ${input_phi_th}    ${input_khtt}    ${input_thukhac}
    #get info product, customer
    ${get_list_status}    Get list imei status thr API    ${list_imei}
    Create invoice with imei product    ${input_ma_kh}    ${list_imei}    ${get_list_status}
    ${input_imei_product}    Get Dictionary Keys    ${list_imei}
    ${input_imei_nums}    Get Dictionary Values    ${list_imei}
    ${input_imei_product}    ${input_imei_nums}    Convert two list to string and return    ${input_imei_product}    ${input_imei_nums}
    ${surcharge_vnd_value}    Get surcharge vnd value    ${input_thukhac}
    ${surcharge_%}    Get surcharge percentage value    ${input_thukhac}
    Run Keyword If    ${surcharge_%} == 0    Toggle surcharge VND    ${input_thukhac}    true
    ...    ELSE    Toggle surcharge percentage    ${input_thukhac}    true
    ${list_product}    Get Dictionary Keys    ${dict_product_nums}
    ${list_nums}    Get Dictionary Values    ${dict_product_nums}
    #get info tra hang
    Append To List    ${list_product}    ${input_imei_product}
    Append to List    ${list_nums}    ${input_imei_nums}
    Append To List    ${list_newprice}    ${input_imei_newprice}
    ${imei}    Convert list to string and return    ${imei_inlist}
    ${list_status}    Get list imei status thr API    ${list_product}
    ${imei_by_product_inlist}    Create List
    :FOR    ${item_product}    ${item_status}    IN ZIP    ${list_product}    ${list_status}
    \    ${imei_by_product}    Set Variable If    ${item_status}==0    ${EMPTY}    ${imei}
    \    Append To List    ${imei_by_product_inlist}    ${imei_by_product}
    Log many    ${imei_by_product_inlist}
    ${list_result_thanhtien_newprice}    ${list_giavon}    ${list_result_toncuoi}    Get list total sale - endingstock - cost incase newprice    ${list_product}    ${list_nums}    ${list_newprice}
    #compute
    ${result_tongtienhangtra}    Sum values in list    ${list_result_thanhtien_newprice}
    ${result_ggth}    Run Keyword If    0 < ${input_ggth} < 100    Convert % discount to VND and round    ${result_tongtienhangtra}    ${input_ggth}
    ...    ELSE    Set Variable    ${input_ggth}
    ${result_phi_th}    Run Keyword If    0 < ${input_phi_th} < 100    Convert % discount to VND and round    ${result_tongtienhangtra}    ${input_phi_th}
    ...    ELSE    Set Variable    ${input_phi_th}
    ${actual_surcharge_type}    Set Variable If    ${surcharge_%} == 0    ${surcharge_vnd_value}    ${surcharge_%}
    ${result_per_surchare_by_invoice}    Convert % discount to VND and round    ${result_tongtienhangtra}    ${surcharge_%}
    ${actual_surcharge_value}    Set Variable If    ${surcharge_%} == 0    ${surcharge_vnd_value}    ${result_per_surchare_by_invoice}
    ${result_khachcantra}   Minusx3 and replace foating point    ${result_tongtienhangtra}    ${result_ggth}    ${result_phi_th}
    ${result_tientrakhach}    Sum and replace floating point    ${result_khachcantra}    ${actual_surcharge_value}
    ${actual_khtt_all}    Set Variable If    '${input_khtt}' == 'all'    ${result_khachcantra}    ${input_khtt}
    ${actual_khtt}    Set Variable If    '${input_khtt}' == '0'    0    ${actual_khtt_all}
    #create return in BH
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${jsonpath_id_kh}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_kh}
    ${get_id_kh}    Get data from API    ${endpoint_khachhang}    ${jsonpath_id_kh}
    ${endpoint_danhmuc_hh_co_dvt}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${get_resp_danhmuc_hh}    Get Request and return body    ${endpoint_danhmuc_hh_co_dvt}
    ${get_id_thukhac}   ${get_thutu_thukhac}    Get Id and order surchage    ${input_thukhac}
    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}    Get list jsonpath product frm list product    ${list_product}
    ${list_giaban}    ${list_result_ggsp}    ${list_id_sp}    Get product info and new price frm list product    ${get_resp_danhmuc_hh}    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}   ${list_newprice}
    ${giamgia_th}    Set Variable If    0 < ${input_ggth} < 100    ${input_ggth}    null
    ${result_surcharge}   Run Keyword If    0 < ${surcharge_%} < 100       Convert % discount to VND and round    ${result_tongtienhangtra}    ${surcharge_%}      ELSE    Set Variable    ${surcharge_vnd_value}
    ${result_key_surcharge}   Set Variable If   0 < ${surcharge_%} < 100    SurValueRatio     SurValue
    ${result_value_surcharge}   Set Variable If   0 < ${surcharge_%} < 100    ${surcharge_%}     ${surcharge_vnd_value}
    ${result_key}   Set Variable If   0 < ${surcharge_%} < 100    ValueRatio     Value
    # Post request BH
    ${liststring_prs_return_detail}    Set Variable    needdel
    Log    ${liststring_prs_return_detail}
    :FOR    ${item_giaban}    ${input_newprice}    ${item_product_id}    ${item_num}    ${imei}   ${item_discount}   IN ZIP    ${list_giaban}    ${list_newprice}    ${list_id_sp}    ${list_nums}    ${imei_by_product_inlist}    ${list_result_ggsp}
    \    ${payload_each_product}    Format string    {{"BasePrice":{0},"IsLotSerialControl":true,"Note":"","Price":{1},"ProductId":{2},"Quantity":{3},"SerialNumbers":"{4}","SellPrice":{0},"ProductName":"Máy Làm Sữa Đậu Nành BLUESTONE SMB-7391","Discount":{5},"DiscountRatio":null,"CopiedPrice":3499000.05,"ProductBatchExpireId":null}}    ${item_giaban}    ${input_newprice}    ${item_product_id}    ${item_num}    ${imei}    ${item_discount}
    \    ${liststring_prs_return_detail}       Catenate      SEPARATOR=,      ${liststring_prs_return_detail}      ${payload_each_product}
    ${liststring_prs_return_detail}       Replace String      ${liststring_prs_return_detail}       needdel,       ${EMPTY}      count=1
    ${request_payload}    Format String    {{"Return":{{"BranchId":{0},"RetailerId":{1},"CustomerId":{2},"ReceivedById":{3},"ReceivedBy":{{"CreatedBy":0,"CreatedDate":"2018-07-30T08:27:36.800Z","Email":"","GivenName":"anh.lv","Id":{3},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false}},"SaleChannelId":0,"Code":"Trả hàng 1","ReturnDiscount":{4},"ReturnFee":{5},"ReturnFeeRatio":{6},"ReturnDetails":[{7}],"InvoiceDetails":[],"InvoiceOrderSurcharges":[{{"Code":"TK005","Name":"Phí giao hàng1","Order":{8},"RetailerId":{1},"{9}":{10},"SurchargeId":{11},"{12}":{10},"isAuto":true,"isReturnAuto":true,"Price":{13},"UsageFlag":true}}],"Payments":[{{"Method":"Cash","MethodStr":"Tiền mặt","Amount":{14},"Id":-1}}],"Status":1,"Surcharge":{13},"Type":3,"Uuid":"","PayingAmount":998402,"TotalBeforeDiscount":0,"ProductDiscount":0,"TotalReturn":1223002,"txtPay":"Tiền trả khách","addToAccount":"0","addToAccountSurplus":"0","addToAccountAllocation":"0","addToAccountPaymentAllocation":"0","ReturnSurcharges":[{{"Code":"TK005","Name":"Phí giao hàng1","Order":{8},"RetailerId":{1},"{9}":{10},"SurchargeId":{11},"{12}":{10},"isAuto":true,"isReturnAuto":true,"Price":{13},"UsageFlag":true}}],"CreatedBy":201567}}}}    ${BRANCH_ID}    ${get_id_nguoitao}    ${get_id_kh}    ${get_id_nguoiban}
    ...    ${result_ggth}    ${result_phi_th}    ${input_phi_th}    ${liststring_prs_return_detail}   ${get_thutu_thukhac}    ${result_key_surcharge}
    ...    ${result_value_surcharge}  ${get_id_thukhac}    ${result_key}  ${result_surcharge}    ${actual_khtt}
    Log    ${request_payload}
    ${return_code}    Post request to create return and get resp    ${request_payload}
    #get values
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
    ${get_tongtienhangtra_af_ex}    ${get_giamgiaphieutra}    ${get_phitrahang_af_ex}    ${get_cantrakhach_af_ex}    ${get_datrakhach_af_ex}    ${get_tongtien_hoadontra_af_ex}    Get return info incase discount by return code    ${return_code}
    Should Be Equal As Numbers    ${get_tongtienhangtra_af_ex}    ${result_tongtienhangtra}
    Should Be Equal As Numbers    ${get_giamgiaphieutra}    ${result_ggth}
    Should Be Equal As Numbers    ${get_phitrahang_af_ex}    ${result_phi_th}
    Should Be Equal As Numbers    ${get_datrakhach_af_ex}    ${actual_khtt}
    Should Be Equal As Numbers    ${get_tongtien_hoadontra_af_ex}    ${result_tientrakhach}
    Remove From List    ${list_newprice}    -1
    Delete return thr API        ${return_code}
    Run Keyword If    ${surcharge_%} == 0    Toggle surcharge VND    ${input_thukhac}    false
    ...    ELSE    Toggle surcharge percentage    ${input_thukhac}    false

aettka2
    [Arguments]     ${input_ma_kh}    ${dict_product_nums}    ${list_imei}    ${list_newprice}    ${input_newprice_imei}    ${input_ggth}
    ...    ${input_phi_th}    ${input_khtt}    ${input_thukhac1}    ${input_thukhac2}
    #activate surcharge
    ${get_list_status}    Get list imei status thr API    ${list_imei}
    Create invoice with imei product    ${input_ma_kh}    ${list_imei}    ${get_list_status}
    ${surcharge_value_1_vnd}    Get surcharge vnd value    ${input_thukhac1}
    ${surcharge_value_1_percentage}    Get surcharge percentage value    ${input_thukhac1}
    ${surcharge_value_2_vnd}    Get surcharge vnd value    ${input_thukhac2}
    ${surcharge_value_2_percentage}    Get surcharge percentage value    ${input_thukhac2}
    ${actual_surcharge1_value}    Set Variable If    ${surcharge_value_1_percentage} == 0    ${surcharge_value_1_vnd}    ${surcharge_value_1_percentage}
    ${actual_surcharge2_value}    Set Variable If    ${surcharge_value_2_percentage} == 0    ${surcharge_value_2_vnd}    ${surcharge_value_2_percentage}
    Run Keyword If    ${actual_surcharge1_value} > 100    Toggle surcharge VND    ${input_thukhac1}    true
    ...    ELSE    Toggle surcharge percentage    ${input_thukhac1}    true
    Run Keyword If    ${actual_surcharge2_value} > 100    Toggle surcharge VND    ${input_thukhac2}    true
    ...    ELSE    Toggle surcharge percentage    ${input_thukhac2}    true
    #get info product, customer
    ${list_products}    Get Dictionary Keys    ${dict_product_nums}
    ${list_nums}    Get Dictionary Values    ${dict_product_nums}
    ${input_imei_product}    Get Dictionary Keys    ${list_imei}
    ${input_imei_nums}    Get Dictionary Values    ${list_imei}
    ${input_imei_product}    ${input_imei_nums}    Convert two list to string and return    ${input_imei_product}    ${input_imei_nums}
    #get info tra hang
    Append To List    ${list_products}    ${input_imei_product}
    Append to List    ${list_nums}    ${input_imei_nums}
    Append To List    ${list_newprice}    ${input_newprice_imei}
    ${imei}    Convert list to string and return    ${imei_inlist}
    ${list_status}    Get list imei status thr API    ${list_products}
    ${imei_by_product_inlist}    Create List
    :FOR    ${item_product}    ${item_status}    IN ZIP    ${list_products}    ${list_status}
    \    ${imei_by_product}    Set Variable If    ${item_status}==0    ${EMPTY}    ${imei}
    \    Append To List    ${imei_by_product_inlist}    ${imei_by_product}
    Log many    ${imei_by_product_inlist}
    ${list_result_thanhtien_newprice}    ${list_giavon}    ${list_result_toncuoi}    Get list total sale - endingstock - cost incase newprice    ${list_products}    ${list_nums}    ${list_newprice}
    #compute
    ${result_tongtienhangtra}    Sum values in list    ${list_result_thanhtien_newprice}
    ${result_ggth}    Run Keyword If    0 < ${input_ggth} < 100    Convert % discount to VND and round    ${result_tongtienhangtra}    ${input_ggth}
    ...    ELSE    Set Variable    ${input_ggth}
    ${result_phi_th}    Run Keyword If    0 < ${input_phi_th} < 100    Convert % discount to VND and round    ${result_tongtienhangtra}    ${input_phi_th}
    ...    ELSE    Set Variable    ${input_phi_th}
    ${total_surcharge}=    Run Keyword If    ${actual_surcharge1_value} > 100 and ${actual_surcharge2_value} > 100    Sum    ${actual_surcharge1_value}    ${actual_surcharge2_value}
    ...    ELSE IF    ${actual_surcharge1_value} > 100 and ${actual_surcharge2_value} < 100    VND and Percentage Surcharges sum    ${actual_surcharge2_value}    ${result_tongtienhangtra}    ${actual_surcharge1_value}
    ...    ELSE IF    ${actual_surcharge1_value} < 100 and ${actual_surcharge2_value} < 100    Percentage and Percentage Surcharges sum    ${result_tongtienhangtra}    ${actual_surcharge1_value}    ${actual_surcharge2_value}
    ...    ELSE    Log    abv
    ${result_khachcantra}   Minusx3 and replace foating point    ${result_tongtienhangtra}    ${result_ggth}    ${result_phi_th}
    ${result_tientrakhach}    Sum and replace floating point    ${result_khachcantra}    ${total_surcharge}
    ${actual_khtt_all}    Set Variable If    '${input_khtt}' == 'all'    ${result_tientrakhach}    ${input_khtt}
    ${actual_khtt}    Set Variable If    '${input_khtt}' == '0'    0    ${actual_khtt_all}
    #input data into DH form
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${jsonpath_id_kh}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_kh}
    ${get_id_kh}    Get data from API    ${endpoint_khachhang}    ${jsonpath_id_kh}
    ${endpoint_danhmuc_hh_co_dvt}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${get_resp_danhmuc_hh}    Get Request and return body    ${endpoint_danhmuc_hh_co_dvt}
    ${get_id_thukhac1}   ${get_thutu_thukhac1}    Get Id and order surchage    ${input_thukhac1}
    ${get_id_thukhac2}   ${get_thutu_thukhac2}    Get Id and order surchage    ${input_thukhac2}
    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}    Get list jsonpath product frm list product    ${list_products}
    ${list_giaban}    ${list_result_ggsp}    ${list_id_sp}    Get product info and new price frm list product    ${get_resp_danhmuc_hh}    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}   ${list_newprice}
    ${giamgia_th}    Set Variable If    0 < ${input_ggth} < 100    ${input_ggth}    null
    ${result_surcharge1}   Run Keyword If    0 < ${actual_surcharge1_value} < 100       Convert % discount to VND and round    ${result_tongtienhangtra}    ${actual_surcharge1_value}      ELSE    Set Variable    ${actual_surcharge1_value}
    ${result_surcharge2}   Run Keyword If    0 < ${actual_surcharge2_value} < 100       Convert % discount to VND and round    ${result_tongtienhangtra}    ${actual_surcharge2_value}      ELSE    Set Variable    ${actual_surcharge2_value}
    ${result_key_surcharge1}   Set Variable If   0 < ${actual_surcharge1_value} < 100    SurValueRatio     SurValue
    ${result_key_surcharge2}   Set Variable If   0 < ${actual_surcharge2_value} < 100    SurValueRatio     SurValue
    ${result_key1}   Set Variable If   0 < ${actual_surcharge1_value} < 100    ValueRatio     Value
    ${result_key2}   Set Variable If   0 < ${actual_surcharge2_value} < 100    ValueRatio     Value
    # Post request BH
    ${liststring_prs_return_detail}    Set Variable    needdel
    Log    ${liststring_prs_return_detail}
    :FOR    ${item_giaban}    ${input_newprice}    ${item_product_id}    ${item_num}    ${imei}   ${item_discount}   IN ZIP    ${list_giaban}    ${list_newprice}    ${list_id_sp}    ${list_nums}    ${imei_by_product_inlist}    ${list_result_ggsp}
    \    ${payload_each_product}    Format string    {{"BasePrice":{0},"IsLotSerialControl":true,"Note":"","Price":{1},"ProductId":{2},"Quantity":{3},"SerialNumbers":"{4}","SellPrice":{0},"ProductName":"Máy Làm Sữa Đậu Nành BLUESTONE SMB-7391","Discount":{5},"DiscountRatio":null,"CopiedPrice":3499000.05,"ProductBatchExpireId":null}}    ${item_giaban}    ${input_newprice}    ${item_product_id}    ${item_num}    ${imei}    ${item_discount}
    \    ${liststring_prs_return_detail}       Catenate      SEPARATOR=,      ${liststring_prs_return_detail}      ${payload_each_product}
    ${liststring_prs_return_detail}       Replace String      ${liststring_prs_return_detail}       needdel,       ${EMPTY}      count=1
    ${request_payload}    Format String    {{"Return":{{"BranchId":{0},"RetailerId":{1},"CustomerId":{2},"ReceivedById":{3},"ReceivedBy":{{"CreatedBy":0,"CreatedDate":"2018-07-30T08:27:36.800Z","Email":"","GivenName":"anh.lv","Id":{3},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false}},"SaleChannelId":0,"SaleChannel":null,"Code":"Trả hàng 1","ReturnDiscount":{4},"ReturnFee":{5},"ReturnFeeRatio":{6},"ReturnDetails":[{7}],"InvoiceDetails":[],"InvoiceOrderSurcharges":[{{"Code":"TK001","Name":"Phí VAT1","Order":{8},"RetailerId":{1},"{9}":{10},"SurchargeId":{11},"{12}":{10},"isAuto":true,"isReturnAuto":true,"TextValue":"10.00 %","Price":{13},"UsageFlag":true}},{{"Code":"TK005","Name":"Phí giao hàng1","Order":{14},"RetailerId":{1},"{15}":{16},"SurchargeId":{17},"{18}":{16},"isAuto":true,"isReturnAuto":true,"TextValue":"20,000","Price":{19},"UsageFlag":true}}],"Payments":[{{"Method":"Cash","MethodStr":"Tiền mặt","Amount":{20},"Id":-1}}],"Status":1,"Surcharge":{21},"Type":3,"Uuid":"","PayingAmount":890101,"TotalBeforeDiscount":0,"ProductDiscount":0,"TotalReturn":1243002,"txtPay":"Tiền trả khách","addToAccount":"0","addToAccountSurplus":"0","addToAccountAllocation":"0","addToAccountPaymentAllocation":"0","ReturnSurcharges":[{{"Code":"TK001","Name":"Phí VAT1","Order":{8},"RetailerId":{1},"{9}":{10},"SurchargeId":{11},"{12}":{10},"isAuto":true,"isReturnAuto":true,"TextValue":"10.00 %","Price":{13},"UsageFlag":true}},{{"Code":"TK005","Name":"Phí giao hàng1","Order":{14},"RetailerId":{1},"{15}":{16},"SurchargeId":{17},"{18}":{16},"isAuto":true,"isReturnAuto":true,"TextValue":"20,000","Price":{19},"UsageFlag":true}}],"CreatedBy":201567}}}}    ${BRANCH_ID}    ${get_id_nguoitao}    ${get_id_kh}    ${get_id_nguoiban}
    ...    ${result_ggth}    ${result_phi_th}    ${giamgia_th}    ${liststring_prs_return_detail}
    ...   ${get_thutu_thukhac1}    ${result_key_surcharge1}    ${actual_surcharge1_value}  ${get_id_thukhac1}    ${result_key1}
    ...     ${result_surcharge1}    ${get_thutu_thukhac2}    ${result_key_surcharge2}    ${actual_surcharge2_value}  ${get_id_thukhac2}
    ...    ${result_key2}  ${result_surcharge2}    ${actual_khtt}    ${total_surcharge}
    Log    ${request_payload}
    ${return_code}    Post request to create return and get resp    ${request_payload}
    #get values
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
    ${get_tongtienhangtra_af_ex}    ${get_giamgiaphieutra}    ${get_phitrahang_af_ex}    ${get_cantrakhach_af_ex}    ${get_datrakhach_af_ex}    ${get_tongtien_hoadontra_af_ex}    Get return info incase discount by return code    ${return_code}
    Should Be Equal As Numbers    ${get_tongtienhangtra_af_ex}    ${result_tongtienhangtra}
    Should Be Equal As Numbers    ${get_giamgiaphieutra}    ${result_ggth}
    Should Be Equal As Numbers    ${get_phitrahang_af_ex}    ${result_phi_th}
    Should Be Equal As Numbers    ${get_datrakhach_af_ex}    ${actual_khtt}
    Should Be Equal As Numbers    ${get_tongtien_hoadontra_af_ex}    ${result_tientrakhach}
    Remove From List    ${list_newprice}    -1
    Delete return thr API        ${return_code}
    #Deactivate surcharge
    Run Keyword If    ${actual_surcharge1_value} > 100    Toggle surcharge VND    ${input_thukhac1}    false
    ...    ELSE    Toggle surcharge percentage    ${input_thukhac1}    false
    Run Keyword If    ${actual_surcharge2_value} > 100    Toggle surcharge VND    ${input_thukhac2}    false
    ...    ELSE    Toggle surcharge percentage    ${input_thukhac2}    false
