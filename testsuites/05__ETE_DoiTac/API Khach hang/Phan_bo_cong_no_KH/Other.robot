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
&{list_prs_num1}    CNKHS02=1
&{list_prs_num2}    CNKHDV02=2

*** Test Cases ***    Mã KH         Tên KH         List products invoice      Payment to invoice    Payment to invoice 1     Payment
Phieu thu_MHBH         [Tags]      APBKH
                      [Template]    phanbo6
                      KHPBCN4     Khách công nợ 4      ${list_prs_num1}         850000                500000                  200000

Phieu thu_Soquy         [Tags]      APBKH
                      [Template]    phanbo7
                      KHPBCN5     Khách công nợ 5      ${list_prs_num2}     Thu 2         400000                  90000

*** Keywords ***
phanbo6
    [Arguments]    ${input_ma_kh}    ${input_ten_kh}    ${list_product_invoice}   ${input_khtt_tocreate_invoice}   ${input_khtt_tocreate_invoice1}   ${input_thanhtoan}
    ##delete customer
    ${get_customer_id}    Get customer id thr API    ${input_ma_kh}
    Run Keyword If    '${get_customer_id}' == '0'    Log    Ignore delete     ELSE      Delete customer    ${get_customer_id}
    Sleep    1s
    ## create customer
    ${date_current}   Get Current Date      result_format=%Y-%m-%d
    Add customer with birthday    ${input_ma_kh}    ${input_ten_kh}    ${date_current}
    Sleep    2s
    ${ma_hd}    Add new invoice - payment allocation frm API    ${input_ma_kh}    ${list_product_invoice}    ${input_khtt_tocreate_invoice}
    ${ma_hd1}    Add new invoice - payment allocation frm API    ${input_ma_kh}    ${list_product_invoice}    ${input_khtt_tocreate_invoice1}
    ${get_khachcantra}    ${get_khachthanhtoan}   Get paid value from invoice api    ${ma_hd}
    ${get_khachcantra1}    ${get_khachthanhtoan1}   Get paid value from invoice api    ${ma_hd1}
    ${get_no_bf_execute}    ${get_tongban_bf_execute}    ${get_tongban_tru_trahang_bf_execute}    ${get_customer_name}    Get Customer Info from API    ${input_ma_kh}
    ##compute cong no khac hang
    ${result_khachno}    Minus and replace floating point    ${get_khachcantra}    ${get_khachthanhtoan}
    ${result_khachno1}    Minus and replace floating point    ${get_khachcantra1}    ${get_khachthanhtoan1}
    ${result_phanbo_hoadon}  Run Keyword If    ${result_khachno} < ${input_thanhtoan}    Set Variable    ${result_khachno}    ELSE     Minus and replace floating point    ${input_thanhtoan}       ${result_khachno}
    ${result_phanbo_hoadon1}   Minus and replace floating point    ${input_thanhtoan}       ${result_phanbo_hoadon}
    ${result_khtt}    Minus and replace floating point    ${input_thanhtoan}    ${result_phanbo_hoadon}
    ${result_khachdatra}    Sum    ${result_phanbo_hoadon}     ${input_khtt_tocreate_invoice}
    ${result_khachdatra1}    Sum    ${result_phanbo_hoadon1}     ${input_khtt_tocreate_invoice1}
    ##du no khach hang
    ${result_du_no_hd_KH}    Minus    ${get_no_bf_execute}    ${input_thanhtoan}
    #create invoice frm Order API
    ${get_invoice_id}    Get invoice id    ${ma_hd}
    ${get_invoice_id1}    Get invoice id    ${ma_hd1}
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${jsonpath_id_kh}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_kh}
    ${get_id_kh}    Get data from API    ${endpoint_khachhang}    ${jsonpath_id_kh}
    ${request_payload}    Format String    {{"BranchId":{0},"Payments":[{{"AccountId":0,"Method":"Cash","Amount":{1},"InvoiceId":{2},"DocumentCode":"{3}","CustomerId":{4},"CustomerName":"Khách hàng 5","UserId":{5},"IsUsePriceCod":false,"CodNeedPayment":0,"IsCompleteInvoice":false,"Uuid":"","AutoAllocation":1}},{{"AccountId":0,"Method":"Cash","Amount":{6},"InvoiceId":{7},"DocumentCode":"{8}","CustomerId":{4},"CustomerName":"Khách hàng 5","UserId":{5},"IsUsePriceCod":false,"CodNeedPayment":0,"IsCompleteInvoice":false,"Uuid":"","AutoAllocation":1}}]}}     ${BRANCH_ID}    ${result_phanbo_hoadon}    ${get_invoice_id}    ${ma_hd}        ${get_id_kh}    ${get_id_nguoiban}
    ...    ${result_phanbo_hoadon1}    ${get_invoice_id1}    ${ma_hd1}    ${result_khtt}
    Log    ${request_payload}
    ${headers1}=    Create Dictionary    Authorization=${bearertoken}    Content-Type=application/json;charset=utf-8
    Create Session    lolo    ${API_URL}    cookies=${resp.cookies}
    ${resp3}=    Post Request    lolo    /payments    data=${request_payload}    headers=${headers1}
    Log    ${resp3.request.body}
    Log    ${resp3.json()}
    Log    ${resp3.status_code}
    Should Be Equal As Strings    ${resp3.status_code}    200
    ${payload}    Convert To String    ${resp3.json()}
    ${cam}    Replace string     ${payload}   '     "
    ${source data}=    Evaluate     json.loads("""${cam}""")    json
    ${all data members}=    Set Variable     ${source data['Payments']}
    :FOR    ${item}   IN      @{all data members}
    \     ${payment_code}   Get From Dictionary   ${item}   Code
    Sleep    20 s    wait for response to API
    ##validate invoice allocate
    ${get_khachtt_af_allocate}    ${get_ptt_af_allocate}    Get invoice info after allocate     ${ma_hd}    ${payment_code}
    Should Be Equal As Numbers    ${get_khachtt_af_allocate}    ${result_khachdatra}
    Should Be Equal As Numbers    ${get_ptt_af_allocate}    ${result_phanbo_hoadon}
    ##validate invoice allocate
    ${get_khachtt_af_allocate1}    ${get_ptt_af_allocate1}    Get invoice info after allocate     ${ma_hd1}    ${payment_code}
    Should Be Equal As Numbers    ${get_khachtt_af_allocate1}    ${result_khachdatra1}
    Should Be Equal As Numbers    ${get_ptt_af_allocate1}    ${result_phanbo_hoadon1}
    #assert customer and so quy
    ${get_no_af_execute_kh}    ${get_tongban_af_execute_kh}    ${get_tongban_tru_trahang_af_execute_kh}    Get Customer Debt from API    ${input_ma_kh}
    Should Be Equal As Numbers    ${get_no_af_execute_kh}    ${result_du_no_hd_KH}
    Should Be Equal As Numbers    ${get_tongban_af_execute_kh}    ${get_tongban_bf_execute}
    Delete invoice by invoice code    ${ma_hd}
    Delete invoice by invoice code    ${ma_hd1}
    ${get_customer_id}    Get Customer ID    ${input_ma_kh}
    Delete customer    ${get_customer_id}

phanbo7
    [Arguments]    ${input_ma_kh}    ${input_ten_kh}    ${list_product_invoice}    ${input_loai_thuchi}   ${input_khtt_tocreate_invoice}   ${input_thanhtoan}
    ##delete customer
    ${get_customer_id}    Get customer id thr API    ${input_ma_kh}
    Run Keyword If    '${get_customer_id}' == '0'    Log    Ignore delete     ELSE      Delete customer    ${get_customer_id}
    Sleep    1s
    ## create customer
    ${date_current}   Get Current Date      result_format=%Y-%m-%d
    Add customer with birthday    ${input_ma_kh}    ${input_ten_kh}    ${date_current}
    Sleep    2s
    ${ma_hd}    Add new invoice - payment allocation frm API    ${input_ma_kh}    ${list_product_invoice}    ${input_khtt_tocreate_invoice}
    ${get_khachcantra}    ${get_khachthanhtoan}   Get paid value from invoice api    ${ma_hd}
    ${get_no_bf_execute}    ${get_tongban_bf_execute}    ${get_tongban_tru_trahang_bf_execute}    ${get_customer_name}    Get Customer Info from API    ${input_ma_kh}
    ##compute cong no khac hang
    ${result_khachno}    Minus and replace floating point    ${get_khachcantra}    ${get_khachthanhtoan}
    ${result_khachdatra}    Sum    ${input_thanhtoan}     ${input_khtt_tocreate_invoice}
    ##du no khach hang
    ${result_du_no_hd_KH}    Minus    ${get_no_bf_execute}    ${input_thanhtoan}
    #create invoice frm Order API
    ${payment_code}    Generate code automatically    TTM
    ${get_id_loai_thu}    Get payment category id    ${input_loai_thuchi}
    ${get_invoice_id}    Get invoice id    ${ma_hd}
    ${get_id_nguoitao}    Get RetailerID
    ${get_id_nguoiban}    Get User ID
    ${jsonpath_id_kh}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_kh}
    ${get_id_kh}    Get data from API    ${endpoint_khachhang}    ${jsonpath_id_kh}
    ${request_payload}    Format String    {{"Payments":[{{"Code":"{0}","DocumentCode":"{1}","Amount":{2},"Method":"Cash","InvoiceId":{3},"ReturnId":null,"CustomerId":{4},"CustomerName":"Nguyễn Thị Hoài","AccountId":null,"IsUsePriceCod":false,"CodNeedPayment":0,"IsCompleteInvoice":false,"CashFlowGroupId":{5},"AutoAllocation":1,"Uuid":""}}],"BranchId":{6}}}   ${payment_code}
    ...    ${ma_hd}    ${input_thanhtoan}    ${get_invoice_id}   ${get_id_kh}    ${get_id_loai_thu}     ${BRANCH_ID}
    Log    ${request_payload}
    ${headers1}=    Create Dictionary    Authorization=${bearertoken}    Content-Type=application/json;charset=utf-8
    Create Session    lolo    ${API_URL}    cookies=${resp.cookies}
    ${resp3}=    Post Request    lolo    /payments    data=${request_payload}    headers=${headers1}
    Log    ${resp3.request.body}
    Log    ${resp3.json()}
    Log    ${resp3.status_code}
    Should Be Equal As Strings    ${resp3.status_code}    200
    Sleep    20 s    wait for response to API
    ##validate invoice allocate
    ${get_khachtt_af_allocate}    ${get_ptt_af_allocate}    Get invoice info after allocate     ${ma_hd}    ${payment_code}
    Should Be Equal As Numbers    ${get_khachtt_af_allocate}    ${result_khachdatra}
    Should Be Equal As Numbers    ${get_ptt_af_allocate}    ${input_thanhtoan}
    #assert customer and so quy
    ${get_no_af_execute_kh}    ${get_tongban_af_execute_kh}    ${get_tongban_tru_trahang_af_execute_kh}    Get Customer Debt from API    ${input_ma_kh}
    Should Be Equal As Numbers    ${get_no_af_execute_kh}    ${result_du_no_hd_KH}
    Should Be Equal As Numbers    ${get_tongban_af_execute_kh}    ${get_tongban_bf_execute}
    Delete invoice by invoice code    ${ma_hd}
    ${get_customer_id}    Get Customer ID    ${input_ma_kh}
    Delete customer    ${get_customer_id}
