*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}      ${headless_browser}
Resource          ../../../../config/env_product/envi.robot
Resource          ../../../../core/Doi_Tac/doitac_navigation.robot
Resource          ../../../../core/Doi_Tac/khachhang_list_action.robot
Resource          ../../../../core/Doi_Tac/khachhang_list_page.robot
Resource          ../../../../core/API/api_khachhang.robot
Resource          ../../../../core/share/toast_message.robot
Resource          ../../../../core/API/api_trahang.robot
Resource          ../../../../core/API/api_danhmuc_hanghoa.robot
Resource          ../../../../core/API/api_mhbh.robot
Resource          ../../../../core/API/api_soquy.robot
Resource          ../../../../prepare/Hang_hoa/Sources/doitac.robot

*** Variables ***
&{list_prs_num_TH1}    CNKH02=3.5
&{list_prs_num_TH2}    CNKHDV02=2
@{discount}    140000
@{discount_type}    changedown


*** Test Cases ***    Mã KH        Tên KH         List products invoice 1     List products invoice 2      List discount      List discount type      Phí trả hàng    GGTH          Payment to return 1     Payment to return 2
Thanh toan du         [Tags]      APBKH
                      [Template]    phanbo4
                      KHPBCN6     Khách công nợ 6      ${list_prs_num_TH1}      ${list_prs_num_TH2}               ${discount}          ${discount_type}       10000         10              0                       150000

Thanh toan no           [Tags]      APBKHA
                      [Template]    phanbo5
                      KHPBCN7     Khách công nợ 7      Chi 3      50000      ${list_prs_num_TH2}      ${discount}          ${discount_type}      15            15000      100000

*** Keywords ***
phanbo4
    [Arguments]    ${input_ma_kh}    ${input_ten_kh}    ${list_product_TH1}    ${list_product_TH2}    ${list_ggsp}   ${list_discount_type}   ${input_phi_th}
    ...   ${input_ggth}   ${input_khtt_tocreate_return}   ${input_thanhtoandu}
    ##delete customer
    ${get_customer_id}    Get customer id thr API    ${input_ma_kh}
    Run Keyword If    '${get_customer_id}' == '0'    Log    Ignore delete     ELSE      Delete customer    ${get_customer_id}
    Sleep    1s
    ## create customer
    ${date_current}   Get Current Date      result_format=%Y-%m-%d
    Add customer with birthday    ${input_ma_kh}    ${input_ten_kh}    ${date_current}
    Sleep    2s
    ${ma_trahang}  Add new return - payment surplus frm API    ${input_ma_kh}    ${list_product_TH1}    ${input_khtt_tocreate_return}
    ${list_product}   Get Dictionary Keys    ${list_product_TH2}
    ${list_nums}   Get Dictionary Values    ${list_product_TH2}
    #get order summary and sub total of products
    ${result_list_thanhtien}    ${get_list_giavon}    ${result_list_toncuoi}   Get list total sale - endingstock - cost incase discount and newprice    ${list_product}
    ...    ${list_nums}    ${list_ggsp}    ${list_discount_type}
    ${get_no_bf_execute}    ${get_tongban_bf_execute}    ${get_tongban_tru_trahang_bf_execute}    ${get_customer_name}    Get Customer Info from API    ${input_ma_kh}
    ##compute cong no khac hang
    ${result_tongtienhang}    Sum values in list    ${result_list_thanhtien}
    ${result_ggth}    Run Keyword If    0 < ${input_ggth} < 100    Convert % discount to VND and round    ${result_tongtienhang}    ${input_ggth}
    ...    ELSE    Set Variable    ${input_ggth}
    ${result_phi_th}    Run Keyword If    0 < ${input_phi_th} < 100    Convert % discount to VND and round    ${result_tongtienhang}    ${input_phi_th}
    ...    ELSE    Set Variable    ${input_phi_th}
    ${result_cantrakhach}    Minusx3 and replace foating point    ${result_tongtienhang}    ${result_ggth}    ${result_phi_th}
    ${result_khtt}   Sum and replace floating point   ${input_thanhtoandu}    ${result_cantrakhach}
    ##du no khach hang
    ${result_du_no_th_KH}    Minus    ${get_no_bf_execute}    ${result_cantrakhach}
    ${result_PTT_th_KH}    Sum and replace floating point    ${result_du_no_th_KH}    ${result_cantrakhach}
    ${result_tongban_tru_TH}    Minus and replace floating point    ${get_tongban_tru_trahang_bf_execute}    ${result_cantrakhach}
    #create invoice frm Order API
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${jsonpath_id_kh}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_kh}
    ${get_id_kh}    Get data from API    ${endpoint_khachhang}    ${jsonpath_id_kh}
    ${endpoint_danhmuc_hh_co_dvt}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${get_resp_danhmuc_hh}    Get Request and return body    ${endpoint_danhmuc_hh_co_dvt}
    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}    Get list jsonpath product frm list product    ${list_product}
    ${list_giaban}    ${list_result_ggsp}    ${list_id_sp}    Get product info frm list jsonpath product incase discount product    ${get_resp_danhmuc_hh}
    ...    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}    ${list_ggsp}   ${list_discount_type}
    ${trahang}   Set Variable If   0 < ${input_phi_th} < 100    ${input_phi_th}      0
    ${liststring_prs_order_detail}     Set Variable      needdel
    Log        ${liststring_prs_order_detail}
    : FOR    ${item_gia_ban}   ${item_id_sp}   ${item_soluong}   ${item_ggsp}   ${result_ggsp}      IN ZIP      ${list_giaban}        ${list_id_sp}    ${list_nums}    ${list_ggsp}    ${list_result_ggsp}
    \    ${payload_each_product}        Format string       {{"BasePrice":{0},"IsLotSerialControl":false,"Note":"","Price":{1},"ProductId":{2},"Quantity":{3},"SellPrice":{0},"ProductName":"Ô mai chanh đào Hồng Lam","Discount":{4},"DiscountRatio":null,"CopiedPrice":{0},"ProductBatchExpireId":null}}    ${item_gia_ban}   ${item_ggsp}   ${item_id_sp}   ${item_soluong}    ${result_ggsp}
    \    ${liststring_prs_order_detail}       Catenate      SEPARATOR=,      ${liststring_prs_order_detail}      ${payload_each_product}
    ${liststring_prs_order_detail}       Replace String      ${liststring_prs_order_detail}       needdel,       ${EMPTY}      count=1
    ${request_payload}    Format String    {{"Return":{{"BranchId":{0},"RetailerId":{1},"CustomerId":{2},"ReceivedById":{3},"ReceivedBy":{{"CreatedBy":0,"CreatedDate":"2018-07-30T08:27:36.800Z","Email":"","GivenName":"anh.lv","Id":{3},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false}},"SaleChannelId":0,"SaleChannel":null,"Code":"Trả hàng 1","ReturnDiscount":{4},"ReturnFee":{5},"ReturnFeeRatio":{6},"ReturnDetails":[{7}],"InvoiceDetails":[],"InvoiceOrderSurcharges":[],"Payments":[{{"Method":"Cash","MethodStr":"Tiền mặt","Amount":{8},"Id":-1}}],"PaymentSurplus":[],"Status":1,"Surcharge":0,"Type":3,"Uuid":"","PayingAmount":{9},"TotalBeforeDiscount":0,"ProductDiscount":0,"TotalReturn":{8},"txtPay":"Tiền trả khách","addToAccount":"0","addToAccountSurplus":"1","addToAccountAllocation":"0","addToAccountPaymentAllocation":"1","ReturnSurcharges":[],"CreatedBy":201567}}}}     ${BRANCH_ID}    ${get_id_nguoitao}    ${get_id_kh}    ${get_id_nguoiban}
    ...    ${result_ggth}    ${result_phi_th}    ${trahang}   ${liststring_prs_order_detail}    ${result_cantrakhach}
    ...    ${result_khtt}
    Log    ${request_payload}
    ${return_code}    Post request to create return and get resp    ${request_payload}
    Sleep    20 s    wait for response to API
    #assert value product in invoice
    ${get_list_hh_in_th_af_execute}    Get list product frm Return API    ${return_code}
    ${list_soluong_in_hd}    ${list_giatriquydoi_in_hd}    Get list quantity and gia tri quy doi with return have multi product    ${get_list_hh_in_th_af_execute}    ${return_code}
    : FOR    ${item_ma_hh}    ${result_toncuoi}    ${item_giavon}    ${get_soluong_in_hd}    ${get_giatri_quydoi}    IN ZIP
    ...    ${get_list_hh_in_th_af_execute}    ${result_list_toncuoi}    ${get_list_giavon}    ${list_soluong_in_hd}    ${list_giatriquydoi_in_hd}
    \    Run Keyword If    '${get_giatri_quydoi}' == '1'    Validate onhand and cost frm API    ${return_code}    ${item_ma_hh}    ${result_toncuoi}
    \    ...    ${item_giavon}    ${get_soluong_in_hd}
    \    ...    ELSE    Validate onhand and cost frm unit product    ${return_code}    ${item_ma_hh}    ${result_toncuoi}
    \    ...    ${item_giavon}    ${get_soluong_in_hd}    ${get_giatri_quydoi}
    ##validate invoice allocate
    ${get_tongtienhangtra_af_ex}    ${get_giamgiaphieutra}    ${get_phitrahang_af_ex}    ${get_cantrakhach_af_ex}    ${get_datrakhach_af_ex}    ${get_tongtien_hoadontra_af_ex}    Get return info incase discount by return code
    ...    ${return_code}
    Should Be Equal As Numbers    ${get_tongtienhangtra_af_ex}    ${result_tongtienhang}
    Should Be Equal As Numbers    ${get_giamgiaphieutra}    ${result_ggth}
    Should Be Equal As Numbers    ${get_phitrahang_af_ex}    ${result_phi_th}
    Should Be Equal As Numbers    ${get_datrakhach_af_ex}    ${result_cantrakhach}
    Should Be Equal As Numbers    ${get_tongtien_hoadontra_af_ex}    ${result_cantrakhach}
    #assert customer and so quy
    ${get_no_af_execute_kh}    ${get_tongban_af_execute_kh}    ${get_tongban_tru_trahang_af_execute_kh}    Get Customer Debt from API after purchase    ${input_ma_kh}    ${return_code}    ${result_cantrakhach}
    ${get_maphieu_soquy}    Get Ma Phieu Thu in So quy    ${return_code}
    Should Be Equal As Numbers    ${get_no_af_execute_kh}    ${result_PTT_th_KH}
    Should Be Equal As Numbers    ${get_tongban_af_execute_kh}    ${get_tongban_bf_execute}
    Should Be Equal As Numbers    ${get_tongban_tru_trahang_af_execute_kh}    ${result_tongban_tru_TH}
    Validate customer history and debt if return is paid    ${input_ma_kh}    ${return_code}    ${result_du_no_th_KH}    ${result_PTT_th_KH}
    Validate So quy info from Rest API if Invoice is paid    ${get_maphieu_soquy}    ${result_cantrakhach}
    Delete return thr API        ${return_code}
    ${get_customer_id}    Get Customer ID    ${input_ma_kh}
    Delete customer    ${get_customer_id}

phanbo5
    [Arguments]    ${input_ma_kh}    ${input_ten_kh}    ${input_loai_thuchi}    ${input_giatri}    ${list_product_TH}    ${list_ggsp}   ${list_discount_type}   ${input_phi_th}
    ...   ${input_ggth}   ${input_khtt}
    ##delete customer
    ${get_customer_id}    Get customer id thr API    ${input_ma_kh}
    Run Keyword If    '${get_customer_id}' == '0'    Log    Ignore delete     ELSE      Delete customer    ${get_customer_id}
    Sleep    1s
    ## create customer
    ${date_current}   Get Current Date      result_format=%Y-%m-%d
    Add customer with birthday    ${input_ma_kh}    ${input_ten_kh}    ${date_current}
    Sleep    2s
    ${result_giatri}    Minus   0    ${input_giatri}
    ${ma_phieu}    Add cash flow in tab Tien mat for customer and not used for financial reporting    ${input_ma_kh}    ${input_loai_thuchi}    ${result_giatri}    0
    Sleep    20s
    ${list_product}   Get Dictionary Keys    ${list_product_TH}
    ${list_nums}   Get Dictionary Values    ${list_product_TH}
    #get order summary and sub total of products
    ${result_list_thanhtien}    ${get_list_giavon}    ${result_list_toncuoi}   Get list total sale - endingstock - cost incase discount and newprice    ${list_product}
    ...    ${list_nums}    ${list_ggsp}    ${list_discount_type}
    ${get_no_bf_execute}    ${get_tongban_bf_execute}    ${get_tongban_tru_trahang_bf_execute}    ${get_customer_name}    Get Customer Info from API    ${input_ma_kh}
    ##compute cong no khac hang
    ${result_tongtienhang}    Sum values in list    ${result_list_thanhtien}
    ${result_ggth}    Run Keyword If    0 < ${input_ggth} < 100    Convert % discount to VND and round    ${result_tongtienhang}    ${input_ggth}
    ...    ELSE    Set Variable    ${input_ggth}
    ${result_phi_th}    Run Keyword If    0 < ${input_phi_th} < 100    Convert % discount to VND and round    ${result_tongtienhang}    ${input_phi_th}
    ...    ELSE    Set Variable    ${input_phi_th}
    ${result_cantrakhach}    Minusx3 and replace foating point    ${result_tongtienhang}    ${result_ggth}    ${result_phi_th}
    ${result_khtt}   Sum and replace floating point   ${input_giatri}    ${input_khtt}
    ##du no khach hang
    ${result_du_no_th_KH}    Minus    ${get_no_bf_execute}    ${result_cantrakhach}
    ${result_PTT_th_KH}    Sum and replace floating point    ${result_du_no_th_KH}    ${input_khtt}
    ${result_tongban_tru_TH}    Minus and replace floating point    ${get_tongban_tru_trahang_bf_execute}    ${result_cantrakhach}
    #create invoice frm Order API
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${get_id_allocate}    Get allocation id frm sale api    ${input_ma_kh}    ${ma_phieu}
    ${jsonpath_id_kh}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_kh}
    ${get_id_kh}    Get data from API    ${endpoint_khachhang}    ${jsonpath_id_kh}
    ${endpoint_danhmuc_hh_co_dvt}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${get_resp_danhmuc_hh}    Get Request and return body    ${endpoint_danhmuc_hh_co_dvt}
    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}    Get list jsonpath product frm list product    ${list_product}
    ${list_giaban}    ${list_result_ggsp}    ${list_id_sp}    Get product info frm list jsonpath product incase discount product    ${get_resp_danhmuc_hh}
    ...    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}    ${list_ggsp}   ${list_discount_type}
    ${trahang}   Set Variable If   0 < ${input_phi_th} < 100    ${input_phi_th}      0
    ${liststring_prs_order_detail}     Set Variable      needdel
    Log        ${liststring_prs_order_detail}
    : FOR    ${item_gia_ban}   ${item_id_sp}   ${item_soluong}   ${item_ggsp}   ${result_ggsp}      IN ZIP      ${list_giaban}        ${list_id_sp}    ${list_nums}    ${list_ggsp}    ${list_result_ggsp}
    \    ${payload_each_product}        Format string       {{"BasePrice":{0},"IsLotSerialControl":false,"Note":"","Price":{1},"ProductId":{2},"Quantity":{3},"SellPrice":{0},"ProductName":"Ô mai chanh đào Hồng Lam","Discount":{4},"DiscountRatio":null,"CopiedPrice":{0},"ProductBatchExpireId":null}}    ${item_gia_ban}   ${item_ggsp}   ${item_id_sp}   ${item_soluong}    ${result_ggsp}
    \    ${liststring_prs_order_detail}       Catenate      SEPARATOR=,      ${liststring_prs_order_detail}      ${payload_each_product}
    ${liststring_prs_order_detail}       Replace String      ${liststring_prs_order_detail}       needdel,       ${EMPTY}      count=1
    ${request_payload}    Format String    {{"Return":{{"BranchId":{0},"RetailerId":{1},"CustomerId":{2},"ReceivedById":{3},"ReceivedBy":{{"CreatedBy":0,"CreatedDate":"2018-07-30T08:27:36.800Z","Email":"","GivenName":"anh.lv","Id":{3},"IsActive":true,"IsAdmin":true,"Language":"vi-VN","Type":0,"UserName":"admin","isDeleted":false}},"SaleChannelId":0,"SaleChannel":null,"Code":"Trả hàng 1","ReturnDiscount":{4},"ReturnFee":{5},"ReturnFeeRatio":{6},"ReturnDetails":[{7}],"InvoiceDetails":[],"InvoiceOrderSurcharges":[],"Payments":[{{"Method":"Cash","MethodStr":"Tiền mặt","Amount":{8},"Id":-1}}],"PaymentSurplus":[{{"AccountId":0,"Method":"","Amount":{9},"InvoiceId":{10},"Id":{10},"DocumentCode":"{11}","CodNeedPayment":0,"IsCompleteInvoice":false,"AutoAllocation":1}}],"Status":1,"Surcharge":0,"Type":3,"Uuid":"","PayingAmount":{8},"TotalBeforeDiscount":0,"ProductDiscount":0,"TotalReturn":{12},"txtPay":"Tiền trả khách","addToAccount":"0","addToAccountSurplus":"1","addToAccountAllocation":"0","addToAccountPaymentAllocation":"1","ReturnSurcharges":[],"CreatedBy":201567}}}}
    ...   ${BRANCH_ID}    ${get_id_nguoitao}    ${get_id_kh}    ${get_id_nguoiban}    ${result_ggth}    ${result_phi_th}    ${trahang}
    ...   ${liststring_prs_order_detail}    ${input_khtt}   ${input_giatri}    ${get_id_allocate}    ${ma_phieu}    ${result_tongtienhang}
    Log    ${request_payload}
    ${return_code}    Post request to create return and get resp    ${request_payload}
    Sleep    20 s    wait for response to API
    #assert value product in invoice
    ${get_list_hh_in_th_af_execute}    Get list product frm Return API    ${return_code}
    ${list_soluong_in_hd}    ${list_giatriquydoi_in_hd}    Get list quantity and gia tri quy doi with return have multi product    ${get_list_hh_in_th_af_execute}    ${return_code}
    : FOR    ${item_ma_hh}    ${result_toncuoi}    ${item_giavon}    ${get_soluong_in_hd}    ${get_giatri_quydoi}    IN ZIP
    ...    ${get_list_hh_in_th_af_execute}    ${result_list_toncuoi}    ${get_list_giavon}    ${list_soluong_in_hd}    ${list_giatriquydoi_in_hd}
    \    Run Keyword If    '${get_giatri_quydoi}' == '1'    Validate onhand and cost frm API    ${return_code}    ${item_ma_hh}    ${result_toncuoi}
    \    ...    ${item_giavon}    ${get_soluong_in_hd}
    \    ...    ELSE    Validate onhand and cost frm unit product    ${return_code}    ${item_ma_hh}    ${result_toncuoi}
    \    ...    ${item_giavon}    ${get_soluong_in_hd}    ${get_giatri_quydoi}
    ##validate invoice allocate
    ${get_datrakhach}   ${get_ptt_pb}   Get return info after allocate    ${return_code}    ${ma_phieu}
    Should Be Equal As Numbers    ${get_datrakhach}    ${result_khtt}
    Should Be Equal As Numbers    ${get_ptt_pb}    ${input_giatri}
    #assert customer and so quy
    ${get_no_af_execute_kh}    ${get_tongban_af_execute_kh}    ${get_tongban_tru_trahang_af_execute_kh}    Get Customer Debt from API after purchase    ${input_ma_kh}    ${return_code}    ${input_khtt}
    ${get_maphieu_soquy}    Get Ma Phieu Thu in So quy    ${return_code}
    Should Be Equal As Numbers    ${get_no_af_execute_kh}    ${result_PTT_th_KH}
    Should Be Equal As Numbers    ${get_tongban_af_execute_kh}    ${get_tongban_bf_execute}
    Should Be Equal As Numbers    ${get_tongban_tru_trahang_af_execute_kh}    ${result_tongban_tru_TH}
    Validate customer history and debt if return is paid    ${input_ma_kh}    ${return_code}    ${result_du_no_th_KH}    ${result_PTT_th_KH}
    Validate So quy info from Rest API if Invoice is paid    ${get_maphieu_soquy}    ${input_khtt}
    Delete return thr API        ${return_code}
    ${get_customer_id}    Get Customer ID    ${input_ma_kh}
    Delete customer    ${get_customer_id}
