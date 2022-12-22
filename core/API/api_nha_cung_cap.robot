*** Settings ***
Library           Collections
Library           RequestsLibrary
Library           SeleniumLibrary
Library           OperatingSystem
Library           String
Library           StringFormat
Library           JSONLibrary
Library           DateTime
Resource          ../share/computation.robot
Resource          api_access.robot

*** Variables ***
${endpoint_ncc}    /suppliers?format=json&Includes=TotalInvoiced&Includes=LocationName&Includes=WardName&ForSummaryRow=true
${key_no_ncc_hientai}    TotalInvoiced
${key_tong_mua}    TotalInvoicedWithoutReturn
${key_ma_ncc}     Code
${endpoint_delete_suppliers}    /suppliers/{0}    #id ncc
${endpoint_tab_lichsu_nth}    /suppliers/{0}/transactionhistory?format=json&Includes=Total&%24inlinecount=allpages    #id NCC
${endpoint_tab_nocantra_ncc}    suppliers/{0}/debt?format=json&GroupCode=true&%24inlinecount=allpages    #id NCC
${endpoint_tab_lichsu_dathangnhap}    /suppliers/{0}/ordertranshistory?format=json&Includes=Total&%24inlinecount=allpages&%24top=5&%24filter=PurchaseDate+eq+%27alltime%27
${endpoint_xoa_phieu_tab_nocantra}      /suppliers/{0}/debtdelete?kvuniqueparam=2020
${endpoint_tao_phieu_dieu_chinh_ncc}      /suppliers/{0}/debt?kvuniqueparam=2020
${endpoint_tao_phieu_tt_ncc}      /purchasepayments?kvuniqueparam=2020

*** Keywords ***
Get Supplier Info
    [Arguments]    ${input_ma_ncc}
    [Timeout]          5 mins
    ${jsonpath_no_ncc_hientai}    Format String    $..Data[?(@.Code=="{0}")].Debt    ${input_ma_ncc}
    ${jsonpath_tongmua}    Format String    $..Data[?(@.Code=="{0}")].TotalInvoiced    ${input_ma_ncc}
    ${jsonpath_name}    Format String    $..Data[?(@.Code=="{0}")].Name    ${input_ma_ncc}
    ${resp_body}      Get Request and return body    ${endpoint_ncc}
    ${get_no_ncc_hientai}    Get data from response json    ${resp_body}    ${jsonpath_no_ncc_hientai}
    ${get_tong_mua}    Get data from response json   ${resp_body}    ${jsonpath_tongmua}
    ${get_name}    Get data from response json   ${resp_body}    ${jsonpath_name}
    Return From Keyword    ${get_no_ncc_hientai}    ${get_tong_mua}       ${get_name}

Get ma phieu if purchase oder is not paid
    [Arguments]    ${input_ma_ncc}    ${ma_phieunhap}
    [Timeout]          5 mins
    ${jsonpath_ncc_id}    Format String    $..Data[?(@.Code=="{0}")].Id    ${input_ma_ncc}
    ${get_ncc_id}    Get data from API    ${endpoint_ncc}    ${jsonpath_ncc_id}
    ${endpoint_tab_by_ncc_id}    Format String    ${endpoint_tab_nocantra_ncc}    ${get_ncc_id}
    ${jsonpath_trangthai_ma_phieunhap}    Format String    $..Data[?(@.DocumentCode=="{0}")].DocumentType    ${ma_phieunhap}
    ${get_trangthai_ma_phieunhap}    Get data from API    ${endpoint_tab_by_ncc_id}    ${jsonpath_trangthai_ma_phieunhap}
    Return From Keyword    ${get_trangthai_ma_phieunhap}

Validate status in Tab No can tra NCC if purchase order is not paid
    [Arguments]    ${input_ma_ncc}    ${ma_phieunhap}
    [Timeout]          5 mins
    ${get_trangthai_ma_phieunhap}    Get ma phieu if purchase oder is not paid    ${input_ma_ncc}    ${ma_phieunhap}
    Should Be Equal As Numbers    ${get_trangthai_ma_phieunhap}    2

Validate status in Tab No can tra NCC if purchase order is not paid until success
    [Arguments]    ${input_ma_ncc}    ${ma_phieunhap}
    [Timeout]          5 mins
    Wait Until Keyword Succeeds    5 times    30s    Validate status in Tab No can tra NCC if purchase order is not paid    ${input_ma_ncc}    ${ma_phieunhap}

Validate status in Tab No can tra NCC incase purchase order
    [Arguments]     ${input_supplier_code}    ${import_code}    ${actual_tientrancc}
    ${get_ma_pn_soquy}    Get Ma Phieu Chi in So quy    ${import_code}
    Run Keyword If    '${actual_tientrancc}'=='0'    Validate status in Tab No can tra NCC if purchase order is not paid until success    ${input_supplier_code}    ${import_code}
    ...    ELSE    Validate status in Tab No can tra NCC if purchase order is paid until success    ${input_supplier_code}    ${get_ma_pn_soquy}    ${import_code}

Validate status in Tab No can tra NCC incase purchase return
    [Arguments]     ${input_supplier_code}    ${purchase_return_code}    ${input_paid_supplier}
    ${get_maphieu_soquy}    Catenate    SEPARATOR=    PT    ${purchase_return_code}
    Run Keyword If    '${input_paid_supplier}' == '0'    Validate status in Debt Tab of Supplier if purchase return is not paid until success    ${input_supplier_code}    ${purchase_return_code}
    ...    ELSE    Validate status in Debt Tab of Supplier if purchase return is paid until success    ${input_supplier_code}    ${get_maphieu_soquy}    ${purchase_return_code}

Get ma phieu if purchase order is paid
    [Arguments]    ${input_ma_ncc}    ${ma_phieu_thanhtoan}    ${ma_phieunhap}
    [Timeout]          5 mins
    ${jsonpath_ncc_id}    Format String    $..Data[?(@.Code=="{0}")].Id    ${input_ma_ncc}
    ${get_ncc_id}    Get data from API    ${endpoint_ncc}    ${jsonpath_ncc_id}
    ${endpoint_tab_by_ncc_id}    Format String    ${endpoint_tab_nocantra_ncc}    ${get_ncc_id}
    ${jsonpath_trangthai_maphieu_thanhtoan}    Format String    $..Data[?(@.DocumentCode=="{0}")].DocumentType    ${ma_phieu_thanhtoan}
    ${get_trangthai_maphieu_thanhtoan}    Get data from API    ${endpoint_tab_by_ncc_id}    ${jsonpath_trangthai_maphieu_thanhtoan}
    ${jsonpath_trangthai_ma_phieunhap}    Format String    $..Data[?(@.DocumentCode=="{0}")].DocumentType    ${ma_phieunhap}
    ${get_trangthai_ma_phieunhap}    Get data from API    ${endpoint_tab_by_ncc_id}    ${jsonpath_trangthai_ma_phieunhap}
    Return From Keyword    ${get_trangthai_maphieu_thanhtoan}    ${get_trangthai_ma_phieunhap}

Validate status in Tab No can tra NCC if purchase order is paid
    [Arguments]    ${input_ma_ncc}    ${ma_phieu_thanhtoan}    ${ma_phieunhap}
    [Timeout]          5 mins
    ${get_trangthai_maphieu_thanhtoan}    ${get_trangthai_ma_phieunhap}    Get ma phieu if purchase order is paid    ${input_ma_ncc}    ${ma_phieu_thanhtoan}    ${ma_phieunhap}
    Should Be Equal As Numbers    ${get_trangthai_ma_phieunhap}    2
    Should Be Equal As Numbers    ${get_trangthai_maphieu_thanhtoan}    0

Validate status in Tab No can tra NCC if purchase order is paid until success
    [Arguments]    ${input_ma_ncc}    ${ma_phieu_thanhtoan}    ${ma_phieunhap}
    [Timeout]          5 mins
    Wait Until Keyword Succeeds    5 times    30 s    Validate status in Tab No can tra NCC if purchase order is paid    ${input_ma_ncc}    ${ma_phieu_thanhtoan}    ${ma_phieunhap}

Get Supplier Debt from API after purchase
    [Arguments]    ${input_ma_ncc}    ${input_ma_pn}    ${input_tientra_ncc}
    [Timeout]          5 mins
    ${jsonpath_id_nhcc}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_ncc}
    ${get_id_ncc}    Get data from API    ${endpoint_ncc}    ${jsonpath_id_nhcc}
    ${endpoint_history_tab_by_supplier}    Format String    ${endpoint_tab_lichsu_nth}    ${get_id_ncc}
    ${endpoint_debt_tab_by_supplier}    Format String    ${endpoint_tab_nocantra_ncc}    ${get_id_ncc}
    Wait Until Keyword Succeeds    3 times    50 s    Get and validate data from API    ${endpoint_history_tab_by_supplier}    ${input_ma_pn}    $..Data[0].Code
    ${jsonpath_tongmua}    Format String    $..Data[?(@.Code=="{0}")].TotalInvoiced    ${input_ma_ncc}
    ${jsonpath_tongmua_trutrahang}    Format String    $..Data[?(@.Code=="{0}")].TotalInvoicedWithoutReturn    ${input_ma_ncc}
    ${document_code_if_paid}    Catenate    SEPARATOR=    PC    ${input_ma_pn}
    ${actual_code_thanhtoan}    Set Variable If    '${input_tientra_ncc}' == '0'    ${input_ma_pn}    ${document_code_if_paid}
    ${jsonpath_no}    Format String    $..Data[?(@.DocumentCode == '{0}')].Balance    ${actual_code_thanhtoan}
    ${get_no}    Get data from API    ${endpoint_debt_tab_by_supplier}    ${jsonpath_no}
    ${get_tongmua}    Get data from API    ${endpoint_ncc}    ${jsonpath_tongmua}
    ${get_tongmua_tru_trahang}    Get data from API    ${endpoint_ncc}    ${jsonpath_tongmua_trutrahang}
    Return From Keyword    ${get_no}    ${get_tongmua}    ${get_tongmua_tru_trahang}

Get Supplier Debt from API
    [Arguments]    ${input_ma_ncc}
    [Timeout]          5 mins
    ${jsonpath_no_ncc_hientai}    Format String    $..Data[?(@.Code=="{0}")].Debt    ${input_ma_ncc}
    ${jsonpath_tongmua}    Format String    $..Data[?(@.Code=="{0}")].TotalInvoiced    ${input_ma_ncc}
    ${jsonpath_tongmua_tru_trahang}    Format String    $..Data[?(@.Code=="{0}")].TotalInvoicedWithoutReturn    ${input_ma_ncc}
    ${resp_ncc}    Get Request and return body    ${endpoint_ncc}
    ${get_no_ncc_hientai}    Get data from response json    ${resp_ncc}    ${jsonpath_no_ncc_hientai}
    ${get_tong_mua}    Get data from response json    ${resp_ncc}    ${jsonpath_tongmua}
    ${get_tong_mua_tru_tra_hang}    Get data from response json    ${resp_ncc}    ${jsonpath_tongmua_tru_trahang}
    Return From Keyword    ${get_no_ncc_hientai}    ${get_tong_mua}    ${get_tong_mua_tru_tra_hang}

Validate status in Tab No can tra NCC if purchase order draft is paid
    [Arguments]    ${input_ma_ncc}    ${ma_phieu_thanhtoan}
    [Timeout]          5 mins
    ${get_trangthai_maphieu_thanhtoan}    Get payment code if purchase order is paid    ${input_ma_ncc}    ${ma_phieu_thanhtoan}
    Should Be Equal As Numbers    ${get_trangthai_maphieu_thanhtoan}    0

Get payment code if purchase order is paid
    [Arguments]    ${input_ma_ncc}    ${ma_phieu_thanhtoan}
    [Timeout]          5 mins
    ${jsonpath_ncc_id}    Format String    $..Data[?(@.Code=="{0}")].Id    ${input_ma_ncc}
    ${get_ncc_id}    Get data from API    ${endpoint_ncc}    ${jsonpath_ncc_id}
    ${endpoint_tab_by_ncc_id}    Format String    ${endpoint_tab_nocantra_ncc}    ${get_ncc_id}
    ${jsonpath_trangthai_maphieu_thanhtoan}    Format String    $..Data[?(@.DocumentCode=="{0}")].DocumentType    ${ma_phieu_thanhtoan}
    ${get_trangthai_maphieu_thanhtoan}    Get data from API    ${endpoint_tab_by_ncc_id}    ${jsonpath_trangthai_maphieu_thanhtoan}
    Return From Keyword    ${get_trangthai_maphieu_thanhtoan}

Validate status in Tab No can tra NCC if purchase order draft is paid until success
    [Arguments]    ${input_ma_ncc}    ${ma_phieu_thanhtoan}
    [Timeout]          5 mins
    Wait Until Keyword Succeeds    5 times    3s    Validate status in Tab No can tra NCC if purchase order draft is paid    ${input_ma_ncc}    ${ma_phieu_thanhtoan}

Validate status in Tab No can tra NCC incase purchase order draft
    [Arguments]    ${import_code}     ${input_ma_ncc}    ${actual_tientrancc}
    [Timeout]          5 mins
    ${ma_phieu_thanhtoan}    Get Ma Phieu Chi in So quy    ${import_code}
    Run Keyword If    '${actual_tientrancc}'=='0'    Log    Ignore validate
    ...    ELSE    Validate status in Tab No can tra NCC if purchase order draft is paid until success    ${input_ma_ncc}    ${ma_phieu_thanhtoan}

Get all documents in Tab No can tra NCC
    [Arguments]    ${input_ma_ncc}
    [Timeout]          5 mins
    ${jsonpath_ncc_id}    Format String    $..Data[?(@.Code=="{0}")].Id    ${input_ma_ncc}
    ${get_ncc_id}    Get data from API    ${endpoint_ncc}    ${jsonpath_ncc_id}
    ${endpoint_tab_nocantra_ncc}    Format String    ${endpoint_tab_nocantra_ncc}    ${get_ncc_id}
    ${all_docs}    Get raw data from API    ${endpoint_tab_nocantra_ncc}    $..DocumentCode
    Return From Keyword    ${all_docs}

Get all documents in Tab Lich su nhap/tra hang
    [Arguments]    ${input_ma_ncc}
    [Timeout]          5 mins
    ${jsonpath_ncc_id}    Format String    $..Data[?(@.Code=="{0}")].Id    ${input_ma_ncc}
    ${get_ncc_id}    Get data from API    ${endpoint_ncc}    ${jsonpath_ncc_id}
    ${endpoint_tab_lichsu_ncc}    Format String    ${endpoint_tab_lichsu_nth}    ${get_ncc_id}
    ${all_docs}    Get raw data from API    ${endpoint_tab_lichsu_ncc}    $..Code
    Return From Keyword    ${all_docs}

Assert ma phieu nhap is not avaliable in Tab No can tra NCC and Lich su nhap/tra hang
    [Arguments]    ${ma_nha_cc}    ${ma_phieu_nhap}
    [Timeout]          5 mins
    ${all_docs_tab_lichsu}    Get all documents in Tab Lich su nhap/tra hang    ${ma_nha_cc}
    ${all_docs_tab_ncc}    Get all documents in Tab No can tra NCC    ${ma_nha_cc}
    List Should Not Contain Value    ${all_docs_tab_lichsu}    ${ma_phieu_nhap}
    List Should Not Contain Value    ${all_docs_tab_ncc}    ${ma_phieu_nhap}

Assert ma phieu nhap is avaliable in Tab No can tra NCC and Lich su nhap/tra hang
    [Arguments]    ${ma_nha_cc}    ${ma_phieu_nhap}
    [Timeout]          5 mins
    ${all_docs_tab_lichsu}    Get all documents in Tab Lich su nhap/tra hang    ${ma_nha_cc}
    ${all_docs_tab_ncc}    Get all documents in Tab No can tra NCC    ${ma_nha_cc}
    List Should Contain Value    ${all_docs_tab_lichsu}    ${ma_phieu_nhap}
    List Should Contain Value    ${all_docs_tab_ncc}    ${ma_phieu_nhap}

Assert expense value
    [Arguments]    ${total_expense_value}    ${expense_locator}
    [Timeout]          5 mins
    ${get_expense_value}    Get text and convert to number    ${expense_locator}
    Should Be Equal As Numbers    ${get_expense_value}    ${total_expense_value}

Get supplier name frm API
    [Arguments]    ${input_ma_mcc}
    [Timeout]          5 mins
    ${jsonpath_ten_ncc}    Format String    $..Data[?(@.Code == '{0}')].Name    ${input_ma_mcc}
    ${get_ten_ncc}    Get data from API    ${endpoint_ncc}    ${jsonpath_ten_ncc}
    Return From Keyword    ${get_ten_ncc}

Get supplier debt after cash flow
    [Arguments]    ${input_ma_ncc}    ${input_ma_phieu}
    [Timeout]          5 mins
    ${jsonpath_id_nhcc}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_ncc}
    ${get_id_ncc}    Get data from API    ${endpoint_ncc}    ${jsonpath_id_nhcc}
    ${endpoint_debt_tab_by_supplier}    Format String    ${endpoint_tab_nocantra_ncc}    ${get_id_ncc}
    ${jsonpath_no}    Format String    $..Data[?(@.DocumentCode == '{0}')].Value    ${input_ma_phieu}
    ${get_no}    Get data from API    ${endpoint_debt_tab_by_supplier}    ${jsonpath_no}
    Return From Keyword    ${get_no}

Get sumary in tab Lich su dat hang nhap
    [Arguments]    ${input_ma_ncc}    ${input_ma_phieu}
    [Timeout]          5 mins
    ${jsonpath_ncc_id}    Format String    $..Data[?(@.Code=="{0}")].Id    ${input_ma_ncc}
    ${get_ncc_id}    Get data from API    ${endpoint_ncc}    ${jsonpath_ncc_id}
    ${endpoint_tab_nocantra_ncc}    Format String    ${endpoint_tab_lichsu_dathangnhap}    ${get_ncc_id}
    ${jsonpath_status}    Format String    $..Data[?(@.Code=="{0}")].Status    ${input_ma_phieu}
    ${jsonpath_total}    Format String    $..Data[?(@.Code=="{0}")].Total    ${input_ma_phieu}
    ${resp}    Get Request and return body    ${endpoint_tab_nocantra_ncc}
    ${get_status}    Get data from response json    ${resp}    ${jsonpath_status}
    ${get_total}    Get data from response json    ${resp}    ${jsonpath_total}
    Return From Keyword    ${get_status}    ${get_total}

Assert sumary in tab Lich su dat hang nhap
    [Arguments]     ${input_supplier_code}    ${ma_phieu}   ${input_cantrancc}   ${input_trangthai}
    ${get_status}    ${get_total}    Get sumary in tab Lich su dat hang nhap    ${input_supplier_code}    ${ma_phieu}
    ${result_trang_thai}     Run Keyword If      '${input_trangthai}'=='Phiếu tạm'     Set Variable    0     ELSE IF     '${input_trangthai}'=='Đã xác nhận NCC'   Set Variable      1   ELSE IF     '${input_trangthai}'=='Nhập một phần'   Set Variable      2     ELSE    Set Variable    3
    Should Be Equal As Numbers    ${get_status}    ${result_trang_thai}
    Should Be Equal As Numbers    ${get_total}    ${input_cantrancc}

Get Supplier Id
    [Arguments]    ${input_ma_ncc}
    [Timeout]          5 mins
    ${jsonpath_id_nhcc}    Format String    $..Data[?(@.Code == '{0}')].Id    ${input_ma_ncc}
    ${get_id_ncc}    Get data from API    ${endpoint_ncc}    ${jsonpath_id_nhcc}
    Return From Keyword    ${get_id_ncc}

Get first purchase order code frm API
    [Arguments]    ${ma_ncc}
    [Timeout]          5 mins
    ${get_id_ncc}    Get Supplier Id    ${ma_ncc}
    ${endpoint_tab_dhn}    Format String    ${endpoint_tab_lichsu_dathangnhap}    ${get_id_ncc}
    ${resp}    Get Request and return body    ${endpoint_tab_dhn}
    ${get_ma_dh}    Get data from response json    ${resp}    $.Data[0].Code
    Return From Keyword    ${get_ma_dh}

Get supplier info and validate
    [Arguments]      ${supplier_code}      ${sup_name}     ${sup_mobile}      ${sup_address}       ${sup_location}     ${sup_ward}      ${sup_email}      ${sup_company}      ${sup_note}
    [Timeout]          5 mins
    ${response_khachhang_info}    Get Request and return body    ${endpoint_ncc}
    ${jsonpath_suppliername}    Format String    $..Data[?(@.Code=="{0}")].Name    ${supplier_code}
    ${jsonpath_mobile}    Format String    $..Data[?(@.Code=="{0}")].Phone    ${supplier_code}
    ${jsonpath_location}    Format String    $..Data[?(@.Code=="{0}")].LocationName    ${supplier_code}
    ${jsonpath_ward}    Format String    $..Data[?(@.Code=="{0}")].WardName    ${supplier_code}
    ${jsonpath_address}    Format String    $..Data[?(@.Code=="{0}")].Address    ${supplier_code}
    ${jsonpath_email}    Format String    $..Data[?(@.Code=="{0}")].Email    ${supplier_code}
    ${jsonpath_cus_company}    Format String    $..Data[?(@.Code=="{0}")].Company    ${supplier_code}
    ${jsonpath_cus_id}    Format String    $..Data[?(@.Code=="{0}")].Id    ${supplier_code}
    ${jsonpath_cus_note}    Format String    $..Data[?(@.Code=="{0}")].Comment    ${supplier_code}
    ${get_supplier_name}    Get data from response json    ${response_khachhang_info}    ${jsonpath_suppliername}
    ${get_supplier_mobile}    Get data from response json    ${response_khachhang_info}    ${jsonpath_mobile}
    ${get_supplier_location}    Get data from response json    ${response_khachhang_info}    ${jsonpath_location}
    ${get_supplier_ward}    Get data from response json    ${response_khachhang_info}    ${jsonpath_ward}
    ${get_supplier_address}    Get data from response json    ${response_khachhang_info}    ${jsonpath_address}
    ${get_supplier_email}    Get data from response json    ${response_khachhang_info}    ${jsonpath_email}
    ${get_supplier_note}    Get data from response json    ${response_khachhang_info}    ${jsonpath_cus_note}
    ${get_supplier_company}    Get data from response json    ${response_khachhang_info}    ${jsonpath_cus_company}
    ${get_supplier_id}    Get data from response json    ${response_khachhang_info}    ${jsonpath_cus_id}
    Should Be Equal As Strings    ${sup_name}    ${get_supplier_name}
    Run Keyword If    '${sup_mobile}'=='none'      Should Be Equal As Numbers    ${get_supplier_mobile}      0     ELSE     Should Be Equal As Strings    ${sup_mobile}    ${get_supplier_mobile}
    Run Keyword If    '${sup_address}'=='none'       Should Be Equal As Numbers     ${get_supplier_address}      0     ELSE     Should Be Equal As Strings    ${sup_address}    ${get_supplier_address}
    Run Keyword If    '${sup_location}'=='none'       Should Be Equal As Numbers    ${get_supplier_location}     0     ELSE     Should Be Equal As Strings    ${sup_location}    ${get_supplier_location}
    Run Keyword If    '${sup_ward}'=='none'       Should Be Equal As Numbers    ${get_supplier_ward}     0     ELSE     Should Be Equal As Strings    ${sup_ward}    ${get_supplier_ward}
    Run Keyword If    '${sup_note}'=='none'       Should Be Equal As Numbers   ${get_supplier_note}      0     ELSE     Should Be Equal As Strings    ${sup_note}    ${get_supplier_note}
    Run Keyword If    '${sup_email}'=='none'       Should Be Equal As Numbers    ${get_supplier_email}     0     ELSE     Should Be Equal As Strings    ${sup_email}    ${get_supplier_email}
    Run Keyword If    '${sup_company}'=='none'       Should Be Equal As Numbers    ${get_supplier_company}      0    ELSE     Should Be Equal As Strings    ${sup_company}    ${get_supplier_company}
    Return From Keyword    ${get_supplier_id}

Delete supplier
    [Arguments]         ${supplier_id}
    [Timeout]          5 mins
    ${data_str}    Format String    {{"Ids":[{0}]}}      ${supplier_id}
    log    ${data_str}
    ${endpoint_delete_sup_byid}       Format String    ${endpoint_delete_suppliers}    ${supplier_id}
    Delete request thr API    ${endpoint_delete_sup_byid}

Delete supplier if supplier exist
    [Arguments]     ${ma_ncc}
    ${get_id_ncc}    Get Supplier Id    ${ma_ncc}
    Run Keyword If    ${get_id_ncc}==0    Log    Ignore    ELSE    Delete supplier    ${get_id_ncc}

Validate status in Tab of Supplier if purchase return is not paid
    [Arguments]    ${input_ma_ncc}    ${purchase_return_code}
    [Timeout]          5 mins
    ${get_trangthai_ma_phieunhap}    Get ma phieu if purchase oder is not paid    ${input_ma_ncc}    ${purchase_return_code}
    Should Be Equal As Numbers    ${get_trangthai_ma_phieunhap}    5

Validate status in Debt Tab of Supplier if purchase return is not paid until success
    [Arguments]    ${input_ma_ncc}    ${purchase_return_code}
    [Timeout]          5 mins
    Wait Until Keyword Succeeds    5 times    3s    Validate status in Tab of Supplier if purchase return is not paid    ${input_ma_ncc}    ${purchase_return_code}

Validate status in Debt Tab of Supplier if purchase return is paid
    [Arguments]    ${input_ma_ncc}    ${ma_phieu_thanhtoan}    ${purchase_return_code}
    [Timeout]          5 mins
    ${get_trangthai_maphieu_thanhtoan}    ${get_trangthai_ma_phieunhap}    Get ma phieu if purchase order is paid    ${input_ma_ncc}    ${ma_phieu_thanhtoan}    ${purchase_return_code}
    Should Be Equal As Numbers    ${get_trangthai_ma_phieunhap}    5
    Should Be Equal As Numbers    ${get_trangthai_maphieu_thanhtoan}    0

Validate status in Debt Tab of Supplier incase purchase return
    [Arguments]      ${supplier_code}    ${purchase_return_code}      ${input_paid_supplier}    ${get_maphieu_soquy}
    Run Keyword If    '${input_paid_supplier}' == '0'    Validate status in Debt Tab of Supplier if purchase return is not paid until success    ${supplier_code}    ${purchase_return_code}
    ...    ELSE    Validate status in Debt Tab of Supplier if purchase return is paid until success    ${supplier_code}    ${get_maphieu_soquy}    ${purchase_return_code}

Validate status in Debt Tab of Supplier if purchase return is paid until success
    [Arguments]    ${input_ma_ncc}    ${ma_phieu_thanhtoan}    ${ma_phieunhap}
    [Timeout]          5 mins
    Wait Until Keyword Succeeds    5 times    30 s    Validate status in Debt Tab of Supplier if purchase return is paid    ${input_ma_ncc}    ${ma_phieu_thanhtoan}    ${ma_phieunhap}

Get ma phieu, gia tri, du no in tab No can tra NCC
    [Arguments]   ${input_ma_ccc}
    [Timeout]   3 mins
    ${get_id_ncc}    Get Supplier Id      ${input_ma_ccc}
    ${endpoint_congno_ncc}    Format String    ${endpoint_tab_nocantra_ncc}    ${get_id_ncc}
    ${get_resp}     Get Request and return body    ${endpoint_congno_ncc}
    ${get_ma_phieu}   Get data from response json    ${get_resp}    $.Data..DocumentCode
    ${jsonpath_giatri}    Format String    $..Data[?(@.DocumentCode=="{0}")].Value    ${get_ma_phieu}
    ${jsonpath_duno}    Format String    $..Data[?(@.DocumentCode=="{0}")].Balance    ${get_ma_phieu}
    ${get_giatri}   Get data from response json    ${get_resp}    ${jsonpath_giatri}
    ${get_duno}     Get data from response json    ${get_resp}    ${jsonpath_duno}
    Return From Keyword    ${get_ma_phieu}    ${get_giatri}     ${get_duno}

Delete debt supplier thr API
    [Arguments]   ${input_ma_ccc}    ${ma_phieu}
    [Timeout]   3 mins
    ${get_id_ncc}    Get Supplier Id       ${input_ma_ccc}
    ${endpoint_delete_phieu}      Format String    ${endpoint_xoa_phieu_tab_nocantra}    ${get_id_ncc}
    ${endpoint_congno_ncc}    Format String    ${endpoint_tab_nocantra_ncc}    ${get_id_ncc}
    ${jsonpath_id_phieu}      Format String  $..Data[?(@.DocumentCode=="{0}")].DocumentId    ${ma_phieu}
    ${get_id_phieu}   Get data from API    ${endpoint_congno_ncc}      ${jsonpath_id_phieu}
    ${get_retailer_id}      Get RetailerID
    ${data_str}   Format String    {{"Adjustment":{{"Id":{0},"Code":"{1}","PartnerId":{2},"PartnerType":1,"CreatedDate":"","CreatedBy":20447,"RetailerId":{3},"Balance":22222,"AdjustmentDate":"","User":{{"IdOld":0,"CompareGivenName":"admin","CompareIsLimitedByTrans":false,"CompareIsShowSumRow":true,"CompareUserName":"admin","IsTimeSheetException":false,"Id":20447,"Email":"","GivenName":"admin","CreatedDate":"","IsActive":true,"IsAdmin":true,"RetailerId":{3},"UserName":"admin","Type":0,"CreatedBy":0,"CanAccessAnySite":false,"Language":"vi-VN","LocationName":"","WardName":"","isDeleted":false,"TfaSecretKey":"","Permissions":[],"Apps":[],"Invoices":[],"Transfers1":[],"PriceBookUsers":[],"CashFlows":[],"Invoices1":[],"Orders":[],"Returns1":[],"Manufacturings":[],"DamageItems":[],"TokenApis":[],"SmsEmailTemplates":[],"BalanceAdjustments1":[],"PointAdjustments":[],"PointAdjustmentsCreatedBy":[],"NotificationSettings":[],"DamageItems1":[],"PurchaseOrders1":[],"PurchaseReturns1":[],"CostAdjustments":[],"Devices":[],"OrderSuppliers":[],"OrderSuppliers1":[],"UserDevices":[],"PayslipPayments":[],"PayslipPaymentAllocations":[]}},"IdOld":0}},"supplierId":{2},"CompareCode":"NCC0043","CompareName":"abc"}}        ${get_id_phieu}     ${ma_phieu}   ${get_id_ncc}    ${get_retailer_id}
    Post request thr API    ${endpoint_delete_phieu}    ${data_str}

Adapt Supplier Dept
    [Arguments]        ${supplier_code}        ${adjusted_amount}
    ${get_id_ncc}    Get Supplier Id    ${supplier_code}
    ${data_str}    Format String    {{"Adjustment":{{"Balance":{0},"Value":44222,"AdjustmentDate":"2020-08-12T04:35:57.086Z"}},"supplierId":{1},"CompareCode":"{2}","CompareName":"abc","CompareBalance":222,"CompareAdjustmentDate":""}}    ${adjusted_amount}     ${get_id_ncc}    ${supplier_code}
    log    ${data_str}
    ${headers1}=    Create Dictionary    Authorization=${bearertoken}    Content-Type=application/json;charset=utf-8
    Create Session    lolo    ${API_URL}    cookies=${resp.cookies}
    ${endpoint_adjust_debt}        Format String        ${endpoint_tao_phieu_dieu_chinh_ncc}        ${get_id_ncc}
    ${resp3.json()}    Post request thr API    ${endpoint_adjust_debt}    ${data_str}
    ${ma_phieu}     Get data from response json    ${resp3.json()}    $..Code
    Return From Keyword    ${ma_phieu}

Add new purchase payment thr API
    [Arguments]        ${supplier_code}        ${adjusted_amount}
    ${get_id_ncc}    Get Supplier Id    ${supplier_code}
    ${get_cur_date}     Get Current Date        result_format=%Y-%m-%d
    ${data_str}    Format String    {{"PurchasePayments":[{{"Amount":{0},"Method":"Cash","SupplierId":{1},"SupplierName":"abc","TransDate":"{3}","AccountId":0,"Uuid":""}}],"BranchId":{2}}}   ${adjusted_amount}     ${get_id_ncc}    ${BRANCH_ID}     ${get_cur_date}
    log    ${data_str}
    ${resp3.json()}    Post request thr API    ${endpoint_tao_phieu_tt_ncc}    ${data_str}
    ${ma_phieu}     Get data from response json    ${resp3.json()}    $..Code
    Return From Keyword    ${ma_phieu}

Assert Cong no Nha cung cap
    [Arguments]     ${supplier_code}      ${input_no_af_execute}      ${input_tong_mua_af_execute}
    ${get_no_af_execute}    ${get_tong_mua_af_execute}    ${supplier_name}    Get Supplier Info    ${supplier_code}
    Should Be Equal As Numbers    ${get_no_af_execute}    ${input_no_af_execute}
    Should Be Equal As Numbers    ${get_tong_mua_af_execute}    ${input_tong_mua_af_execute}

Supplier debt calculation af reciept
    [Arguments]     ${input_supplier_code}      ${result_cantrancc}    ${actual_tientrancc}     ${trang_thai_phieu}
    ${get_no_ncc_hientai}    ${get_tong_mua}    ${get_tong_mua_tru_tra_hang}    Get Supplier Debt from API    ${input_supplier_code}
    ${result_no_phieunhap}    Minus    ${result_cantrancc}    ${actual_tientrancc}
    ${result_no_ncc}   Run Keyword If    '${trang_thai_phieu}'=='Phiếu tạm'    Minus    ${get_no_ncc_hientai}    ${actual_tientrancc}     ELSE      Sum    ${get_no_ncc_hientai}    ${result_no_phieunhap}
    #${result_no_ncc}    Minus    0    ${result_no_ncc}
    ${result_tongmua}   Run Keyword If    '${trang_thai_phieu}'=='Phiếu tạm'    Set Variable   ${get_tong_mua}    ELSE    Sum    ${result_cantrancc}    ${get_tong_mua}
    ${result_tongmua_tru_trahang}     Run Keyword If    '${trang_thai_phieu}'=='Phiếu tạm'    Set Variable   ${get_tong_mua_tru_tra_hang}    ELSE     Sum    ${result_cantrancc}    ${get_tong_mua_tru_tra_hang}
    Return From Keyword    ${result_no_ncc}     ${result_tongmua}     ${result_tongmua_tru_trahang}

Supplier debt calculation af reciept order
    [Arguments]     ${input_supplier_code}      ${result_cantrancc}    ${input_tientrancc}
    ${get_no_ncc_hientai}    ${get_tong_mua}    ${get_tong_mua_tru_tra_hang}    Get Supplier Debt from API    ${input_supplier_code}
    ${actual_tientrancc}    Set Variable If    '${input_tientrancc}'=='all'    ${result_cantrancc}    ${input_tientrancc}
    ${actual_tientrancc}    Run Keyword If    '${input_tientrancc}'=='all'    Replace floating point    ${actual_tientrancc}
    ...    ELSE    Set Variable    ${input_tientrancc}
    ${result_no_ncc}    Minus    ${get_no_ncc_hientai}    ${actual_tientrancc}
    ${result_tongmua}     Set Variable    ${get_tong_mua}
    ${result_tongmua_tru_trahang}     Set Variable      ${get_tong_mua_tru_tra_hang}
    Return From Keyword    ${result_no_ncc}     ${result_tongmua}     ${result_tongmua_tru_trahang}

Supplier debt calculation af purchase return
    [Arguments]     ${input_supplier_code}      ${input_ncc_cantra}    ${input_ncc_tra}     ${trang_thai_phieu}
    ${get_no_ncc_hientai}    ${get_tong_mua}    ${get_tong_mua_tru_tra_hang}    Get Supplier Debt from API    ${input_supplier_code}
    ${result_no_phieutranhap}    Minus    ${input_ncc_cantra}    ${input_ncc_tra}
    ${result_no_ncc}        Minus    ${get_no_ncc_hientai}    ${result_no_phieutranhap}
    ${result_tongmua}   Set Variable      ${get_tong_mua}
    ${result_tongmua_tru_trahang}     Run Keyword If    '${trang_thai_phieu}'=='Phiếu tạm'    Set Variable   ${get_tong_mua_tru_tra_hang}    ELSE     Minus      ${get_tong_mua_tru_tra_hang}     ${input_ncc_cantra}
    Return From Keyword    ${result_no_ncc}     ${result_tongmua}     ${result_tongmua_tru_trahang}
