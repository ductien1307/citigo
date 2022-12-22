*** Settings ***
Library           Collections
Library           RequestsLibrary
Library           SeleniumLibrary
Library           OperatingSystem
Library           String
Library           StringFormat
Library           JSONLibrary
Resource          ../share/computation.robot
Resource          api_access.robot
Resource          api_phieu_nhap_hang.robot
Resource          ../../config/env_product/envi.robot

*** Variables ***
${key_ma_phieu}    Code
${endpoint_soquytienmat}    /cashflow?format=json&IncludeTotal=True&IncludeBranch=True&IncludeUser=True&%24inlinecount=allpages&%24top=10&%24filter=(BranchId+eq+{0}+and+TransDate+eq+%27thismonth%27+and+Status+eq+0+and+Method+eq+%27Cash%27)
${key_loaithuchi}    CashGroup
${key_giatri_hoadon}    Amount
${endpoint_delete_phieu_thuchi}    /cashflow/{0}?CompareCode={1}    #0: ma phieu
${endpoint_so_quy}    /cashflow?format=json&IncludeTotal=True&IncludeBranch=True&IncludeUser=True&%24inlinecount=allpages&IncludeAccount=true&Description=&DescriptionKey=&%24top=15&%24filter=(BranchId+eq+{0}+and+TransDate+eq+%27thismonth%27+and+Status+eq+0)    #0: branch id
${endpoint_so_quy_chi_tiet}    /cashflow/{0}?CompareCode={1}&IncludeUser=true
${endpoint_chi_tiet_so_quy_kh_ko_hach_toan}    /payments/code?Code={0}&ForDetail=1&Includes=User&Includes=CreatedName&Includes=Invoice&Includes=Return
${endpoint_tienmat}    /cashflow?format=json&IncludeTotal=True&IncludeBranch=True&IncludeUser=True&%24inlinecount=allpages&Description=&DescriptionKey=&%24top=15&%24filter=(BranchId+eq+{0}+and+TransDate+eq+%27thismonth%27+and+Status+eq+0+and+Method+eq+%27Cash%27)    #0: branch id
${endpoint_nganhang}    /cashflow?format=json&IncludeTotal=True&IncludeBranch=True&IncludeUser=True&%24inlinecount=allpages&IncludeAccount=true&Description=&DescriptionKey=&%24top=15&%24filter=(BranchId+eq+{0}+and+TransDate+eq+%27thismonth%27+and+Status+eq+0+and+Method+ne+%27Cash%27)    #0: branch id
${endpoint_so_quy_khach_hang}    /payments/code?Code={0}&ForDetail=1&Includes=User&Includes=CreatedName&Includes=Invoice&Includes=Return    #0: ma phieu
${endpoint_loai_thu_chi}    /cashflow/groups?ExcludeDeleted=true
${endpoint_tk_ngan_hang}    //bankaccount
${endpoint_tong_quy}      /cashflow?format=json&IncludeTotal=True&IncludeBranch=True&IncludeUser=True&%24inlinecount=allpages&IncludeAccount=true&Description=&DescriptionKey=&%24top=50&%24filter=(BranchId+eq+{0}+and+TransDate+eq+%27thismonth%27+and+Status+eq+0)
${endpoint_soquy_allbranch}   /cashflow?format=json&IncludeTotal=True&IncludeBranch=True&IncludeUser=True&%24inlinecount=allpages&Description=&DescriptionKey=&%24top=15&%24filter=(TransDate+eq+%27thismonth%27+and+Status+eq+0+and+Method+eq+%27Cash%27
${endpoint_delete_payment_in_customerdebt}    /payments?Code={0}    #ma phieu
${endpoint_delete_purchase_payment}   /purchasepayments?Code={0}&PartnerId={1}&kvuniqueparam=2020    #0- ma phieu nha; 1-id phieu chi cua phieu nhap

*** Keywords ***
Validate So quy info from Rest API if Invoice is paid
    [Arguments]    ${input_ma_chungtu}    ${input_khachtt}
    [Timeout]     3 minute
    ${get_endpoint_by_branch}    Format String    ${endpoint_tong_quy}    ${BRANCH_ID}
    ${get_resp}    Get Request and return body    ${get_endpoint_by_branch}
    ${jsonpath_giatri_hd}    Format String    $..Data[?(@.Code=="{0}")].Amount    ${input_ma_chungtu}
    ${jsonpath_loaithuchi}    Format String    $..Data[?(@.Code=="{0}")].CashGroup    ${input_ma_chungtu}
    ${get_hd_giatri}    Get data from response json    ${get_resp}    ${jsonpath_giatri_hd}
    ${get_loaithutien}    Get data from response json    ${get_resp}    ${jsonpath_loaithuchi}
    ${get_khachtt}    Minus    0    ${input_khachtt}
    ${result_khtt}    Set Variable If    '${get_loaithutien}' == 'Tiền trả khách'    ${get_khachtt}    ${input_khachtt}
    Should Be Equal As Numbers    ${get_hd_giatri}    ${result_khtt}

Validate So quy info from Rest API if Invoice is not paid
    [Arguments]    ${input_ma_chungtu}
    [Timeout]     3 minute
    ${get_endpoint_sqtm_by_branch}    Format String    ${endpoint_soquytienmat}    ${BRANCH_ID}
    ${jsonpath_first_maphieu}    Format String    $..Data[0].Code
    ${get_maphieu_ontop}    Get data from API    ${get_endpoint_sqtm_by_branch}    ${jsonpath_first_maphieu}
    Should Not Be Equal    ${get_maphieu_ontop}    ${input_ma_chungtu}

Validate So quy info from Rest API if Invoice is paid in case multi-payments
    [Arguments]    ${input_ma_chungtu}    ${input_cash_payment}        ${input_other_payment}
    [Timeout]     3 minute
    ${doc_code_for_other_paymentmethod}        Catenate        SEPARATOR=      ${input_ma_chungtu}     -1
    ${get_endpoint_by_branch}    Format String    ${endpoint_tong_quy}    ${BRANCH_ID}
    ${get_resp}    Get Request and return body    ${get_endpoint_by_branch}
    ${jsonpath_cash_amount}    Format String    $..Data[?(@.Code=="{0}")].Amount    ${input_ma_chungtu}
    ${jsonpath_other_amount}    Format String    $..Data[?(@.Code=="{0}")].Amount    ${doc_code_for_other_paymentmethod}
    ${jsonpath_loaithuchi}    Format String    $..Data[?(@.Code=="{0}")].CashGroup    ${input_ma_chungtu}
    ${get_cash_amount}    Get data from response json    ${get_resp}    ${jsonpath_cash_amount}
    ${get_other_amount}    Get data from response json    ${get_resp}    ${jsonpath_other_amount}
    ${get_loaithutien}    Get data from response json    ${get_resp}    ${jsonpath_loaithuchi}
    Should Be Equal As Numbers    ${get_cash_amount}    ${input_cash_payment}
    Should Be Equal As Numbers    ${get_other_amount}    ${input_other_payment}

Validate So quy info from Rest API if Purchase return is paid
    [Arguments]    ${input_ma_chungtu}    ${input_khachtt}
    [Timeout]     3 minute
    ${get_endpoint_by_branch}    Format String    ${endpoint_soquytienmat}    ${BRANCH_ID}
    ${get_resp}    Get Request and return body    ${get_endpoint_by_branch}
    ${jsonpath_giatri_hd}    Format String    $..Data[?(@.Code=="{0}")].Amount    ${input_ma_chungtu}
    ${jsonpath_loaithuchi}    Format String    $..Data[?(@.Code=="{0}")].CashGroup    ${input_ma_chungtu}
    ${get_hd_giatri}    Get data from response json    ${get_resp}    ${jsonpath_giatri_hd}
    ${get_loaithutien}    Get data from response json    ${get_resp}    ${jsonpath_loaithuchi}
    ${get_khachtt}    Minus    0    ${input_khachtt}
    ${result_khtt}    Set Variable If    '${get_loaithutien}' == 'Tiền trả khách'    ${get_khachtt}    ${input_khachtt}
    Should Be Equal As Numbers    ${get_hd_giatri}    ${result_khtt}

Validate So quy info if Order is paid
    [Arguments]    ${input_ma_dh}    ${input_khachtt}
    [Timeout]     3 minute
    ${get_endpoint_by_branch}    Format String    ${endpoint_tong_quy}    ${BRANCH_ID}
    ${jsonpath_giatri_hd}    Format String    $..Data[?(@.Code=="{0}")].Amount    ${input_ma_dh}
    ${get_hd_giatri}    Get data from API    ${get_endpoint_by_branch}    ${jsonpath_giatri_hd}
    Should Be Equal As Numbers    ${get_hd_giatri}    ${input_khachtt}

Validate So quy info if Order is not paid
    [Arguments]    ${input_ma_dh}
    [Timeout]     3 minute
    ${get_endpoint_sqtm_by_branch}    Format String    ${endpoint_tong_quy}    ${BRANCH_ID}
    ${jsonpath_first_maphieu}    Format String    $..Data[0].Code
    ${get_maphieu_ontop}    Get data from API    ${get_endpoint_sqtm_by_branch}    ${jsonpath_first_maphieu}
    Should Not Be Equal    ${get_maphieu_ontop}    ${input_ma_dh}

Validate So quy info from Rest API if Invoice is paid until success
    [Arguments]    ${input_ma_hd}    ${input_khachtt}
    [Timeout]     5 minute
    Wait Until Keyword Succeeds    3 times    2 s    Validate So quy info from Rest API if Invoice is paid    ${input_ma_hd}    ${input_khachtt}

Validate So quy info from Rest API if Invoice is not paid until success
    [Arguments]    ${input_ma_hd}
    [Timeout]     5 minute
    Wait Until Keyword Succeeds    3 times    2 s    Validate So quy info from Rest API if Invoice is not paid    ${input_ma_hd}

Validate So quy info from API
    [Arguments]   ${ma_phieu}      ${input_paid_supplier}      ${actual_supplier_payment}      ${loai_thu_chi}
    ${get_maphieu_soquy}   Run Keyword If    '${loai_thu_chi}'=='Phiếu chi'    Get Ma Phieu Chi in So quy    ${ma_phieu}      ELSE IF    '${loai_thu_chi}'=='Phiếu thu'   Get Ma Phieu Thu in So quy    ${ma_phieu}   ELSE    Set Variable    PT${ma_phieu}
    Run Keyword If    '${input_paid_supplier}' == '0'    Validate So quy info from Rest API if Invoice is not paid until success    ${get_maphieu_soquy}
    ...    ELSE    Validate So quy info from Rest API if Invoice is paid until success    ${get_maphieu_soquy}    ${actual_supplier_payment}

Delete payment frm API
    [Arguments]    ${ma_phieu}
    [Timeout]     3 minute
    ${get_id_phieu}    Get payment id frm API    ${ma_phieu}
    ${endpoint_delete}    Format String    ${endpoint_delete_phieu_thuchi}    ${get_id_phieu}    ${ma_phieu}
    Delete request thr API    ${endpoint_delete}

Delete payment created customer debt
    [Arguments]    ${ma_phieu}
    [Timeout]     3 minute
    ${endpoint_delete}    Format String    ${endpoint_delete_payment_in_customerdebt}    ${ma_phieu}
    Delete request thr API    ${endpoint_delete}

Delete purchase payment frm API
    [Arguments]    ${ma_phieu}
    [Timeout]     3 minute
    ${get_payment_code}    Get payment code by purchase code    ${ma_phieu}
    ${get_payment_id}   Get payment id frm API    ${get_payment_code}
    ${endpoint_delete}    Format String    ${endpoint_delete_purchase_payment}    ${get_payment_code}    ${get_payment_id}
    Delete request thr API    ${endpoint_delete}

Get payment id frm API
    [Arguments]    ${ma_phieu}
    [Timeout]     3 minute
    ${endpointd_ds_phieu}    Format String    $..Data[?(@.Code=="{0}")].Id    ${ma_phieu}
    ${endpoint_sq}    Format String    ${endpoint_so_quy}    ${BRANCH_ID}
    Log    ${endpoint_sq}
    ${get_id_phieu}    Get data from API    ${endpoint_sq}    ${endpointd_ds_phieu}
    Return From Keyword    ${get_id_phieu}

Get paymen infor frm API
    [Arguments]    ${ma_phieu}
    [Timeout]     5 minute
    ${endpoint_sq}    Format String    ${endpoint_so_quy}    ${BRANCH_ID}
    ${resp}    Get Request and return body    ${endpoint_sq}
    ${jsonpath_phuongthuc}    Format String    $..Data[?(@.Code=="{0}")].Method    ${ma_phieu}
    ${jsonpath_trangthai}    Format String    $..Data[?(@.Code=="{0}")].StatusValue    ${ma_phieu}
    ${jsonpath_loai_thu_chi}    Format String    $..Data[?(@.Code=="{0}")].CashGroup    ${ma_phieu}
    ${jsonpath_teni}    Format String    $..Data[?(@.Code=="{0}")].PartnerName    ${ma_phieu}
    ${jsonpath_giatri}    Format String    $..Data[?(@.Code=="{0}")].Amount    ${ma_phieu}
    ${get_phuongthuc}    Get data from response json    ${resp}    ${jsonpath_phuongthuc}
    ${get_trang_thai}    Get data from response json    ${resp}    ${jsonpath_trangthai}
    ${get_loai_thu_chi}    Get data from response json    ${resp}    ${jsonpath_loai_thu_chi}
    ${get_ten}    Get data from response json    ${resp}    ${jsonpath_teni}
    ${get_gia_tri}    Get data from response json    ${resp}    ${jsonpath_giatri}
    Return From Keyword    ${get_phuongthuc}    ${get_trang_thai}    ${get_loai_thu_chi}    ${get_ten}    ${get_gia_tri}

Get payment detail frm API
    [Arguments]    ${ma_phieu}
    [Timeout]     3 minute
    ${get_id_phieu}    Get payment id frm API    ${ma_phieu}
    ${endpoint_chitiet}    Format String    ${endpoint_so_quy_chi_tiet}    ${get_id_phieu}    ${ma_phieu}
    ${resp}    Get Request and return body    ${endpoint_chitiet}
    ${get_phuongthuc}    Get data from response json    ${resp}    $..PaymentMethod
    ${get_trang_thai}    Get data from response json    ${resp}    $..StatusValue
    ${get_gia_tri}    Get data from response json    ${resp}    $..CompareValue
    ${get_hach_toan}    Get data from response json    ${resp}    $..UsedForFinancialReporting
    Return From Keyword    ${get_phuongthuc}    ${get_trang_thai}    ${get_gia_tri}    ${get_hach_toan}

Get cashflow info frm API
    [Arguments]    ${ma_phieu}
    [Timeout]     5 minute
    ${endpoint_sq}    Format String    ${endpoint_so_quy}    ${BRANCH_ID}
    ${resp}    Get Request and return body    ${endpoint_sq}
    ${jsonpath_giatri}    Format String    $..Data[?(@.Code=="{0}")].Amount    ${ma_phieu}
    ${jsonpath_loai_thu_chi}    Format String    $..Data[?(@.Code=="{0}")].CashGroup    ${ma_phieu}
    ${jsonpath_ten}    Format String    $..Data[?(@.Code=="{0}")].ParnerUserName    ${ma_phieu}
    ${jsonpath_trangthai}    Format String    $..Data[?(@.Code=="{0}")].StatusValue    ${ma_phieu}
    ${jsonpath_doituongnop}    Format String    $..Data[?(@.Code=="{0}")].PartnerName    ${ma_phieu}
    ${jsonpath_hachtoan}    Format String    $..Data[?(@.Code=="{0}")].UsedForFinancialReporting    ${ma_phieu}
    ${get_gia_tri}    Get data from response json    ${resp}    ${jsonpath_giatri}
    ${get_loai_thu_chi}    Get data from response json    ${resp}    ${jsonpath_loai_thu_chi}
    ${get_ten}    Get data from response json    ${resp}    ${jsonpath_ten}
    ${get_trang_thai}    Get data from response json    ${resp}    ${jsonpath_trangthai}
    ${get_doituongnop}    Get data from response json    ${resp}    ${jsonpath_doituongnop}
    ${get_hach_toan}    Get data from response json    ${resp}    ${jsonpath_hachtoan}
    Return From Keyword    ${get_gia_tri}    ${get_loai_thu_chi}    ${get_ten}    ${get_trang_thai}   ${get_doituongnop}    ${get_hach_toan}

Get cashflow info with automatic payment
    [Arguments]    ${ma_phieu}
    [Timeout]     5 minute
    ${resp}    Get Request and return body    ${endpoint_soquy_allbranch}
    ${jsonpath_giatri}    Format String    $..Data[?(@.Code=="{0}")].Amount    ${ma_phieu}
    ${jsonpath_loai_thu_chi}    Format String    $..Data[?(@.Code=="{0}")].CashGroup    ${ma_phieu}
    ${jsonpath_ten}    Format String    $..Data[?(@.Code=="{0}")].ParnerUserName    ${ma_phieu}
    ${jsonpath_trangthai}    Format String    $..Data[?(@.Code=="{0}")].StatusValue    ${ma_phieu}
    ${jsonpath_doituongnop}    Format String    $..Data[?(@.Code=="{0}")].PartnerName    ${ma_phieu}
    ${jsonpath_hachtoan}    Format String    $..Data[?(@.Code=="{0}")].UsedForFinancialReporting    ${ma_phieu}
    ${get_gia_tri}    Get data from response json    ${resp}    ${jsonpath_giatri}
    ${get_gia_tri}    Replace floating point    ${get_gia_tri}
    ${get_loai_thu_chi}    Get data from response json    ${resp}    ${jsonpath_loai_thu_chi}
    ${get_ten}    Get data from response json    ${resp}    ${jsonpath_ten}
    ${get_trang_thai}    Get data from response json    ${resp}    ${jsonpath_trangthai}
    ${get_doituongnop}    Get data from response json    ${resp}    ${jsonpath_doituongnop}
    ${get_hach_toan}    Get data from response json    ${resp}    ${jsonpath_hachtoan}
    Return From Keyword    ${get_gia_tri}    ${get_loai_thu_chi}    ${get_ten}    ${get_trang_thai}   ${get_doituongnop}    ${get_hach_toan}

Get automatic payment code frm api
    [Arguments]    ${ma_phieu}
    [Timeout]     3 minute
    ${get_id_maphieu}   Get payment id frm API    ${ma_phieu}
    ${jsonpath_maphieu_tudong}    Format String    $.Data[?(@.PairedId == {0})].Code    ${get_id_maphieu}
    ${get_maphieu_tudong}    Get data from API    ${endpoint_soquy_allbranch}    ${jsonpath_maphieu_tudong}
    Return From Keyword    ${get_maphieu_tudong}

Get payment detail for customer not used for financial reporting
    [Arguments]    ${ma_phieu}
    [Timeout]     3 minute
    ${endpoint_chitiet}    Format String    ${endpoint_chi_tiet_so_quy_kh_ko_hach_toan}    ${ma_phieu}
    ${resp}    Get Request and return body    ${endpoint_chitiet}
    ${get_phuongthuc}    Get data from response json    ${resp}    $..Method
    ${get_trang_thai}    Get data from response json    ${resp}    $..Status
    ${get_gia_tri}    Get data from response json    ${resp}    $..Amount
    ${get_hach_toan}    Get data from response json    ${resp}    $..UsedForFinancialReporting
    Return From Keyword    ${get_phuongthuc}    ${get_trang_thai}    ${get_gia_tri}    ${get_hach_toan}

Get balance in So quy Tien mat
    [Timeout]     3 minute
    ${endpoint_tm}    Format String    ${endpoint_tienmat}    ${BRANCH_ID}
    ${resp}    Get Request and return body    ${endpoint_tm}
    ${get_tong_thu}    Get data from response json    ${resp}    $..Total1Value
    ${get_tong_chi}    Get data from response json    ${resp}    $..Total2Value
    ${get_quy_dau_ky}    Get data from response json    ${resp}    $..Total4Value
    ${get_ton_quy}    Get data from response json    ${resp}    $..Total3Value
    Return From Keyword    ${get_quy_dau_ky}    ${get_tong_thu}    ${get_tong_chi}    ${get_ton_quy}

Get balance in So quy Ngan hang
    [Timeout]     3 minute
    ${endpoint_nh}    Format String    ${endpoint_nganhang}    ${BRANCH_ID}
    ${resp}    Get Request and return body    ${endpoint_nh}
    ${get_tong_thu}    Get data from response json    ${resp}    $..Total1Value
    ${get_tong_chi}    Get data from response json    ${resp}    $..Total2Value
    ${get_quy_dau_ky}    Get data from response json    ${resp}    $..Total4Value
    ${get_ton_quy}    Get data from response json    ${resp}    $..Total3Value
    Return From Keyword    ${get_quy_dau_ky}    ${get_tong_thu}    ${get_tong_chi}    ${get_ton_quy}

Get balance in So quy Tien mat for other branch
    [Arguments]    ${input_branch_id}
    [Timeout]     3 minute
    ${endpoint_tm}    Format String    ${endpoint_tienmat}    ${input_branch_id}
    ${resp}    Get Request and return body    ${endpoint_tm}
    ${get_tong_thu}    Get data from response json    ${resp}    $..Total1Value
    ${get_tong_chi}    Get data from response json    ${resp}    $..Total2Value
    ${get_quy_dau_ky}    Get data from response json    ${resp}    $..Total4Value
    ${get_ton_quy}    Get data from response json    ${resp}    $..Total3Value
    Return From Keyword    ${get_quy_dau_ky}    ${get_tong_thu}    ${get_tong_chi}    ${get_ton_quy}

Get balance in So quy Ngan hang for other branch
    [Arguments]    ${input_branch_id}
    [Timeout]     3 minute
    ${endpoint_nh}    Format String    ${endpoint_nganhang}    ${input_branch_id}
    ${resp}    Get Request and return body    ${endpoint_nh}
    ${get_tong_thu}    Get data from response json    ${resp}    $..Total1Value
    ${get_tong_chi}    Get data from response json    ${resp}    $..Total2Value
    ${get_quy_dau_ky}    Get data from response json    ${resp}    $..Total4Value
    ${get_ton_quy}    Get data from response json    ${resp}    $..Total3Value
    Return From Keyword    ${get_quy_dau_ky}    ${get_tong_thu}    ${get_tong_chi}    ${get_ton_quy}

Compute balance in tab Tien mat af add receipt
    [Arguments]    ${value}
    [Timeout]     3 minute
    ${get_quy_dau_ky}    ${get_tong_thu}    ${get_tong_chi}    ${get_ton_quy}    Get balance in So quy Tien mat
    ${quy_dau_ky_af}    Set Variable    ${get_quy_dau_ky}
    ${tong_chi_af}    Set Variable    ${get_tong_chi}
    ${tong_thu_af}    Sum    ${get_tong_thu}    ${value}
    ${ton_quy_af}    Sum    ${quy_dau_ky_af}    ${tong_thu_af}
    ${ton_quy_af}    Sum    ${ton_quy_af}    ${tong_chi_af}
    ${ton_quy_af}    Evaluate    round(${ton_quy_af}, 0)
    Return From Keyword    ${quy_dau_ky_af}    ${tong_thu_af}    ${tong_chi_af}    ${ton_quy_af}

Compute balance in tab Tien mat af add payment
    [Arguments]    ${value}
    [Timeout]     3 minute
    ${get_quy_dau_ky}    ${get_tong_thu}    ${get_tong_chi}    ${get_ton_quy}    Get balance in So quy Tien mat
    ${quy_dau_ky_af}    Set Variable    ${get_quy_dau_ky}
    ${tong_thu_af}    Set Variable    ${get_tong_thu}
    ${tong_chi_af}    Minus    ${get_tong_chi}    ${value}
    ${ton_quy_af}    Sum    ${quy_dau_ky_af}    ${tong_thu_af}
    ${ton_quy_af}    Sum    ${ton_quy_af}    ${tong_chi_af}
    ${ton_quy_af}    Evaluate    round(${ton_quy_af}, 0)
    Return From Keyword    ${quy_dau_ky_af}    ${tong_thu_af}    ${tong_chi_af}    ${ton_quy_af}

Compute balance in tab Ngan hang af add receipt
    [Arguments]    ${value}
    [Timeout]     3 minute
    ${get_quy_dau_ky}    ${get_tong_thu}    ${get_tong_chi}    ${get_ton_quy}    Get balance in So quy Ngan hang
    ${quy_dau_ky_af}    Set Variable    ${get_quy_dau_ky}
    ${tong_chi_af}    Set Variable    ${get_tong_chi}
    ${tong_thu_af}    Sum    ${get_tong_thu}    ${value}
    ${ton_quy_af}    Sum    ${quy_dau_ky_af}    ${tong_thu_af}
    ${ton_quy_af}    Sum    ${ton_quy_af}    ${tong_chi_af}
    ${ton_quy_af}    Evaluate    round(${ton_quy_af}, 0)
    Return From Keyword    ${quy_dau_ky_af}    ${tong_thu_af}    ${tong_chi_af}    ${ton_quy_af}

Compute balance in tab Ngan hang af add payment
    [Arguments]    ${value}
    [Timeout]     3 minute
    ${get_quy_dau_ky}    ${get_tong_thu}    ${get_tong_chi}    ${get_ton_quy}    Get balance in So quy Ngan hang
    ${quy_dau_ky_af}    Set Variable    ${get_quy_dau_ky}
    ${tong_thu_af}    Set Variable    ${get_tong_thu}
    ${tong_chi_af}    Minus    ${get_tong_chi}    ${value}
    ${ton_quy_af}    Sum    ${quy_dau_ky_af}    ${tong_thu_af}
    ${ton_quy_af}    Sum    ${ton_quy_af}    ${tong_chi_af}
    ${ton_quy_af}    Evaluate    round(${ton_quy_af}, 0)
    Return From Keyword    ${quy_dau_ky_af}    ${tong_thu_af}    ${tong_chi_af}    ${ton_quy_af}

Compute balance in tab Tien mat with other branch
    [Arguments]   ${branch_id}    ${value}    ${cashflow_type}
    [Timeout]     3 minute
    ${get_quy_dau_ky}    ${get_tong_thu}    ${get_tong_chi}    ${get_ton_quy}    Get balance in So quy Tien mat for other branch    ${branch_id}
    ${quy_dau_ky_af}    Set Variable    ${get_quy_dau_ky}
    ${tong_chi_af}    Run Keyword If    '${cashflow_type}' == 'Thu'    Set Variable    ${get_tong_chi}    ELSE      Minus    ${get_tong_chi}    ${value}
    ${tong_thu_af}    Run Keyword If    '${cashflow_type}' == 'Thu'    Sum    ${get_tong_thu}    ${value}    ELSE    Set Variable    ${get_tong_thu}
    ${ton_quy_af}    Sum    ${quy_dau_ky_af}    ${tong_thu_af}
    ${ton_quy_af}    Sum    ${ton_quy_af}    ${tong_chi_af}
    ${ton_quy_af}    Evaluate    round(${ton_quy_af}, 0)
    Return From Keyword    ${quy_dau_ky_af}    ${tong_thu_af}    ${tong_chi_af}    ${ton_quy_af}

Compute balance in tab Ngan hang with other branch
    [Arguments]   ${branch_id}    ${value}    ${cashflow_type}
    [Timeout]     3 minute
    ${get_quy_dau_ky}    ${get_tong_thu}    ${get_tong_chi}    ${get_ton_quy}    Get balance in So quy Ngan hang for other branch    ${branch_id}
    ${quy_dau_ky_af}    Set Variable    ${get_quy_dau_ky}
    ${tong_chi_af}    Run Keyword If    '${cashflow_type}' == 'Thu'    Set Variable    ${get_tong_chi}    ELSE      Minus    ${get_tong_chi}    ${value}
    ${tong_thu_af}    Run Keyword If    '${cashflow_type}' == 'Thu'    Sum    ${get_tong_thu}    ${value}    ELSE    Set Variable    ${get_tong_thu}
    ${ton_quy_af}    Sum    ${quy_dau_ky_af}    ${tong_thu_af}
    ${ton_quy_af}    Sum    ${ton_quy_af}    ${tong_chi_af}
    ${ton_quy_af}    Evaluate    round(${ton_quy_af}, 0)
    Return From Keyword    ${quy_dau_ky_af}    ${tong_thu_af}    ${tong_chi_af}    ${ton_quy_af}

Get customer payment detail frm API
    [Arguments]    ${ma_phieu}
    [Timeout]     3 minute
    ${endpoint_chitiet}    Format String    ${endpoint_so_quy_chi_tiet}    ${ma_phieu}
    ${resp}    Get Request and return body    ${endpoint_chitiet}
    ${get_phuongthuc}    Get data from response json    ${resp}    $..PaymentMethod
    ${get_trang_thai}    Get data from response json    ${resp}    $..StatusValue
    ${get_gia_tri}    Get data from response json    ${resp}    $..CompareValue
    ${get_hach_toan}    Get data from response json    ${resp}    $..UsedForFinancialReporting
    Return From Keyword    ${get_phuongthuc}    ${get_trang_thai}    ${get_gia_tri}    ${get_hach_toan}

Get payment category id
    [Arguments]    ${ten}
    [Timeout]     3 minute
    ${jsonpath_id}    Format String    $..Data[?(@.Name=="{0}")].Id    ${ten}
    ${get_id_phieu}    Get data from API    ${endpoint_loai_thu_chi}    ${jsonpath_id}
    Return From Keyword    ${get_id_phieu}

Get bank account id
    [Arguments]    ${ten}
    [Timeout]     3 minute
    ${jsonpath_id}    Format String    $..Data[?(@.Account=="{0}")].Id    ${ten}
    ${get_id_acc}    Get data from API    ${endpoint_tk_ngan_hang}    ${jsonpath_id}
    Return From Keyword    ${get_id_acc}

Get status used for financial reporting frm API
    [Arguments]    ${ten}
    [Timeout]     3 minute
    ${jsonpath_status}    Format String    $..Data[?(@.Name=="{0}")].UsedForFinancialReporting    ${ten}
    ${get_status}    Get data from API    ${endpoint_loai_thu_chi}    ${jsonpath_status}
    Return From Keyword    ${get_status}

Add cash flow in tab Tien mat for customer and not used for financial reporting
    [Arguments]    ${ma_kh}    ${loai_thu_chi}    ${gia_tri}    ${ghi_chu}
    [Timeout]     5 minute
    ${ma_phieu}    Generate code automatically    TCTM
    ${get_id_loai_thu}    Get payment category id    ${loai_thu_chi}
    ${gei_id_kh}    Get customer id thr API    ${ma_kh}
    ${data_str}    Format String    {{"Payments":[{{"Code":"{0}","DocumentCode":null,"Amount":{1},"Method":"Cash","CustomerId":{2},"CustomerName":"","Description":"{3}","AccountId":null,"CashFlowGroupId":{4},"AutoAllocation":null,"Uuid":""}}],"BranchId":{5}}}    ${ma_phieu}    ${gia_tri}    ${gei_id_kh}    ${ghi_chu}
    ...    ${get_id_loai_thu}    ${BRANCH_ID}
    Log    ${data_str}
    Post request thr API    /payments    ${data_str}
    Return From Keyword    ${ma_phieu}

Delete payment for cutomer not used for financial reporting thr API
    [Arguments]    ${ma_phieu}
    [Timeout]     5 minute
    ${get_id_phieu}    Get payment id frm API    ${ma_phieu}
    ${endpoint_delete}    Format String    /payments?Code={0}    ${ma_phieu}
    Delete request thr API    ${endpoint_delete}

Add cash flow in tab Ngan hang for customer and not used for financial reporting
    [Arguments]    ${ma_kh}    ${loai_thu_chi}    ${gia_tri}    ${ghi_chu}    ${phuong_thuc}    ${tk_nh}
    [Timeout]     5 minute
    ${ma_phieu}    Generate code automatically    TCTM
    ${get_id_loai_thu}    Get payment category id    ${loai_thu_chi}
    ${gei_id_kh}    Get customer id thr API    ${ma_kh}
    ${get_id_tk}    Get bank account id    ${tk_nh}
    ${data_str}    Format String    {{"Payments":[{{"Code":"{0}","DocumentCode":null,"Amount":{1},"Method":"{2}","CustomerId":{3},"CustomerName":"","Description":"{4}","AccountId":{5},"CashFlowGroupId":{6},"AutoAllocation":null,"Uuid":""}}],"BranchId":{7}}}    ${ma_phieu}    ${gia_tri}    ${phuong_thuc}    ${gei_id_kh}
    ...    ${ghi_chu}    ${get_id_tk}    ${get_id_loai_thu}    ${BRANCH_ID}
    Log    ${data_str}
    Post request thr API    /payments    ${data_str}
    Return From Keyword    ${ma_phieu}

Add cash flow in tab Tien mat for other
    [Arguments]    ${ten_nguoi_nop}    ${loai_thu_chi}    ${gia_tri}    ${ghi_chu}    ${hach_toan}
    [Timeout]     5 minute
    ${ma_phieu}    Generate code automatically    TCTMK
    ${get_id_loai_thu_chi}    Get payment category id    ${loai_thu_chi}
    ${get_id_partner}    Get partner id    ${ten_nguoi_nop}
    ${data_str}    Format String    {{"Cashflow":{{"Value":{0},"UsedForFinancialReporting":{1},"PartnerType":"O","PaymentMethod":"Cash","PartnerId":{2},"PartnerName":"{3}","PartnerContactNo":"0764566","Code":"{4}","Description":"{5}","CashFlowGroupId":{6},"BranchId":{7}}},"ComparePartnerName":"","CashflowGroupName":"","CompareCashFlowGroupId":"","CompareDescription":"","CompareCashflowGroupName":"Tìm loại thu","PartnerName":""}}    ${gia_tri}    ${hach_toan}    ${get_id_partner}    ${ten_nguoi_nop}
    ...    ${ma_phieu}    ${ghi_chu}    ${get_id_loai_thu_chi}    ${BRANCH_ID}
    Log    ${data_str}
    Post request thr API    /cashflow    ${data_str}
    Return From Keyword    ${ma_phieu}

Get partner id
    [Arguments]    ${name}
    [Timeout]     3 minute
    ${jsonpath_user_id}    Format String    $..Data[?(@.Name == '{0}')].Id    ${name}
    ${get_user_id}    Get data from API    /partners    ${jsonpath_user_id}
    Return From Keyword    ${get_user_id}

Add cash flow in tab Ngan hang for other
    [Arguments]    ${ten_nguoi_nop}    ${loai_thu_chi}    ${gia_tri}    ${ghi_chu}    ${phuong_thuc}    ${tk_nh}
    ...    ${hach_toan}
    [Timeout]     5 minute
    ${ma_phieu}    Generate code automatically    TCNHK
    ${get_id_loai_thu_chi}    Get payment category id    ${loai_thu_chi}
    ${get_id_partner}    Get partner id    ${ten_nguoi_nop}
    ${get_id_tk}    Get bank account id    ${tk_nh}
    ${data_str}    Format String    {{"Cashflow":{{"Value":{0},"UsedForFinancialReporting":{1},"PartnerType":"O","PaymentMethod":"{2}","Total":0,"Plus":0,"PartnerId":{3},"PartnerName":"","PartnerContactNo":"","Description":"{4}","Code":"{5}","CashFlowGroupId":{6},"AccountId":{7},"BranchId":{8}}},"ComparePartnerName":"","CashflowGroupName":"","CompareCashFlowGroupId":"","CompareDescription":"","CompareCashflowGroupName":"","PartnerName":""}}    ${gia_tri}    ${hach_toan}    ${phuong_thuc}    ${get_id_partner}
    ...    ${ghi_chu}    ${ma_phieu}    ${get_id_loai_thu_chi}    ${get_id_tk}    ${BRANCH_ID}    #
    ...    # 0    1    2    3    # 4    5
    ...    # 6    7    8
    Log    ${data_str}
    Post request thr API    /cashflow    ${data_str}
    Return From Keyword    ${ma_phieu}

Add cash flow in tab Tien mat for employee
    [Timeout]     5 minute
    [Arguments]    ${ten_nguoi_nop}    ${loai_thu_chi}    ${gia_tri}    ${ghi_chu}    ${hach_toan}
    ${ma_phieu}    Generate code automatically    TCTMU
    ${get_id_loai_thu_chi}    Get payment category id    ${loai_thu_chi}
    ${get_id_partner}    Get User ID by UserName    ${ten_nguoi_nop}
    ${data_str}    Format String    {{"Cashflow":{{"Value":{0},"UsedForFinancialReporting":{1},"PartnerType":"U","PaymentMethod":"Cash","Total":0,"Plus":0,"PartnerId":{2},"PartnerName":"","PartnerContactNo":"","Code":"{3}","Description":"{4}","CashFlowGroupId":{5},"BranchId":{6}}},"ComparePartnerName":"","CashflowGroupName":"","CompareCashFlowGroupId":"","CompareDescription":"","CompareCashflowGroupName":"","PartnerName":""}}    ${gia_tri}    ${hach_toan}    ${get_id_partner}    ${ma_phieu}
    ...    ${ghi_chu}    ${get_id_loai_thu_chi}    ${BRANCH_ID}
    Log    ${data_str}
    Post request thr API    /cashflow    ${data_str}
    Return From Keyword    ${ma_phieu}

Add cash flow in tab Ngan hang for employee
    [Timeout]     5 minute
    [Arguments]    ${ten_nguoi_nop}    ${loai_thu_chi}    ${gia_tri}    ${ghi_chu}    ${phuong_thuc}    ${tk_nh}
    ...    ${hach_toan}
    ${ma_phieu}    Generate code automatically    TCNHK
    ${get_id_loai_thu_chi}    Get payment category id    ${loai_thu_chi}
    ${get_user_id}    Get User ID by UserName    ${ten_nguoi_nop}
    ${get_id_tk}    Get bank account id    ${tk_nh}
    ${data_str}    Format String    {{"Cashflow":{{"Value":{0},"UsedForFinancialReporting":{1},"PartnerType":"U","PaymentMethod":"{2}","Total":0,"Plus":0,"PartnerId":{3},"PartnerName":"","Description":"{4}","Code":"{5}","CashFlowGroupId":{6},"AccountId":{7},"BranchId":{8}}},"ComparePartnerName":"","CashflowGroupName":"","CompareCashFlowGroupId":"","CompareDescription":"","CompareCashflowGroupName":"","PartnerName":""}}    ${gia_tri}    ${hach_toan}    ${phuong_thuc}    ${get_user_id}
    ...    ${ghi_chu}    ${ma_phieu}    ${get_id_loai_thu_chi}    ${get_id_tk}    ${BRANCH_ID}    #
    ...    # 0    1    2    3    # 4    5
    ...    # 6    7    8
    Log    ${data_str}
    Post request thr API    /cashflow    ${data_str}
    Return From Keyword    ${ma_phieu}

Get payment detail in tab Tong quy thr API
    [Arguments]    ${input_ma_chungtu}
    [Timeout]     3 minute
    ${get_endpoint_by_branch}    Format String    ${endpoint_tong_quy}    ${BRANCH_ID}
    ${get_resp}    Get Request and return body    ${get_endpoint_by_branch}
    ${jsonpath_giatri_hd}    Format String    $..Data[?(@.Code=="{0}")].Amount    ${input_ma_chungtu}
    ${jsonpath_loaithuchi}    Format String    $..Data[?(@.Code=="{0}")].CashGroup    ${input_ma_chungtu}
    ${jsonpath_id_kh}       Format String    $..Data[?(@.Code=="{0}")].PartnerId    ${input_ma_chungtu}
    ${get_hd_giatri}    Get data from response json    ${get_resp}    ${jsonpath_giatri_hd}
    ${get_loaithutien}    Get data from response json    ${get_resp}    ${jsonpath_loaithuchi}
    ${get_id_kh}        Get data from response json    ${get_resp}    ${jsonpath_id_kh}
    Return From Keyword    ${get_hd_giatri}  ${get_loaithutien}  ${get_id_kh}

Add new payment/receipt type
    [Arguments]    ${name}
    ${data_str}    Format String    {{"Group":{{"FlowType":1,"UsedForFinancialReporting":true,"Name":"{0}"}}}}    ${name}
    Log    ${data_str}
    Post request thr API    /cashflow/groups?kvuniqueparam=2020     ${data_str}
