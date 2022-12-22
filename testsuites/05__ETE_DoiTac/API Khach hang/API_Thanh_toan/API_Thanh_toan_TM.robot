*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}      ${headless_browser}
Resource          ../../../../config/env_product/envi.robot
Resource          ../../../../core/Doi_Tac/doitac_navigation.robot
Resource          ../../../../core/Doi_Tac/khachhang_list_action.robot
Resource          ../../../../core/Doi_Tac/khachhang_list_page.robot
Resource          ../../../../core/API/api_khachhang.robot
Resource          ../../../../core/share/toast_message.robot
Resource          ../../../../core/share/computation.robot
Resource          ../../../core/API/api_hoadon_banhang.robot
Resource          ../../../../core/API/api_soquy.robot

*** Variables ***
&{list_prs_num} 	 GHDV006=8
@{list_giamoi}    65000.5

*** Test Cases ***    Mã KH         List products and nums                 List giá mới      GGHD    Mã Combo    Khách thanh toán    TIền thu từ khách
Thanh toan theo hd    [Tags]        CNKHA
                      [Template]    Thanh toan cong no theo hoa don API
                      CTKH006      ${list_prs_num}                        ${list_giamoi}    10000       none     100000              all

*** Keywords ***
Thanh toan cong no theo hoa don API
    [Arguments]    ${input_ma_kh}    ${dict_product_nums}    ${list_newprice}    ${input_gghd}    ${ma_hh_combo}    ${input_khtt}
    ...    ${input_tien_thu}
    ${get_ma_hd}    Add new invoice incase newprice with multi product - get invoice code    ${input_ma_kh}    ${dict_product_nums}    ${list_newprice}    ${input_gghd}    ${ma_hh_combo}
    ...    ${input_khtt}
    ${get_no_hd}    Get du no hoa don thr API    ${get_ma_hd}
    ##
    ${get_no_cuoi_kh}    Get Du no cuoi KH from API    ${input_ma_kh}
    ${result_tien_thu}    Set Variable If    '${input_tien_thu}'=='all'    ${get_no_hd}    ${input_tien_thu}
    ${result_tien_thu}    Run Keyword If    '${input_tien_thu}'=='all'    Replace floating point    ${result_tien_thu}
    ...    ELSE    Set Variable    ${input_tien_thu}
    ${result_no_af_ex}    Minus    ${get_no_cuoi_kh}    ${result_tien_thu}
    ${get_id_kh}    Get customer id thr API    ${input_ma_kh}
    ${get_id_hd}    Get invoice id    ${get_ma_hd}
    ${data_str}    Format String    {{"Payments":[{{"DocumentCode":"{0}","Amount":{1},"Method":"Cash","InvoiceId":{2},"CustomerId":{3},"CustomerName":"bcd","AccountId":0,"IsUsePriceCod":false,"CodNeedPayment":0,"IsCompleteInvoice":false,"AutoAllocation":1,"Uuid":""}}],"BranchId":{4}}}    ${get_ma_hd}    ${result_tien_thu}    ${get_id_hd}    ${get_id_kh}
    ...    ${BRANCH_ID}
    Log    ${data_str}
    ${headers1}=    Create Dictionary    Authorization=${bearertoken}    Content-Type=application/json;charset=utf-8
    Create Session    lolo    ${API_URL}    cookies=${resp.cookies}
    ${resp3}=    Post Request    lolo    /payments    data=${data_str}    headers=${headers1}
    Log    ${resp3.request.body}
    Log    ${resp3.json()}
    Should Be Equal As Strings    ${resp3.status_code}    200
    Sleep    5s
    ${actual_tien_thu}    Minus    0    ${result_tien_thu}
    ${get_ma_phieu}    ${get_giatri}    ${get_du_no}    Get ma phieu, gia tri, du no in tab No can thu tu khach    ${input_ma_kh}
    Should Be Equal As Numbers    ${get_giatri}    ${actual_tien_thu}
    Should Be Equal As Numbers    ${get_du_no}    ${result_no_af_ex}
    ${get_id_kh}    Get customer id thr API    ${input_ma_kh}
    ${get_actual_giatri}    ${get_loaithutien}    ${get_actual_id_kh}    Get payment detail in tab Tong quy thr API    ${get_ma_phieu}
    Should Be Equal As Numbers    ${get_actual_giatri}    ${result_tien_thu}
    Should Be Equal As Numbers    ${get_actual_id_kh}    ${get_id_kh}
    Should Be Equal As Strings    ${get_loaithutien}    Tiền khách trả
