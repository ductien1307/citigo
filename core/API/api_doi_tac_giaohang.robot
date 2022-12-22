*** Settings ***
Library           Collections
Library           RequestsLibrary
Library           SeleniumLibrary
Library           OperatingSystem
Library           String
Library           StringFormat
Library           JSONLibrary
Resource          api_access.robot
Resource          api_hoadon_banhang.robot

*** Variables ***
${endpoint_dtgh}    /partnerdelivery?format=json&Includes=TotalWeight,TotalCost,TotalInvoices,TotalDebt,LocationName,WardName&ForSummaryRow=true
${endpoint_tab_lichsu_gh}    /invoicesdelivery?format=json&%24inlinecount=allpages&DeliveryPartnerId={0}&DateFilterType=alltime&%24top=5    #id ĐTGH
${endpoint_tab_cong_no_dtgh}    /partnerdelivery/{0}/debt?format=json&GroupCode=true&%24inlinecount=allpages&%24top=5    #Id ĐTGH
${endpoint_delete_partner}    /partnerdelivery/{0}    #id Dtgh
${endpoint_tao_phieu_dieu_chinh_dtgh}     /partnerdelivery/{0}/debt?kvuniqueparam=2020

*** Keywords ***
Get info tab lich su giao hang
    [Arguments]    ${input_ma_DTGH}    ${input_ma_hd}
    [Timeout]          5 mins
    ${jsonpath_parternid}    Format String    $..Data[?(@.Code=="{0}")].Id    ${input_ma_DTGH}
    ${jsonpath_giatri_hd}    Format String    $..Data[?(@.InvoiceCode=="{0}")].NewInvoiceTotal    ${input_ma_hd}
    ${jsonpath_phi_gh}    Format String    $..Data[?(@.InvoiceCode=="{0}")].Price    ${input_ma_hd}
    ${jsonpath_trangthai_gh}    Format String    $..Data[?(@.InvoiceCode=="{0}")].Status    ${input_ma_hd}
    ${get_id_dtgh}    Get data from API    ${endpoint_dtgh}    ${jsonpath_parternid}
    ${endpoint_tab_lichsu_gh}    Format String    ${endpoint_tab_lichsu_gh}    ${get_id_dtgh}
    ${get_giatri_hd_in_tab_lichsu}    Get data from API    ${endpoint_tab_lichsu_gh}    ${jsonpath_giatri_hd}
    ${get_phi_gh_in_tab_lichsu}    Get data from API    ${endpoint_tab_lichsu_gh}    ${jsonpath_phi_gh}
    ${get_ttgh_in_tab_lichsu}    Get data from API    ${endpoint_tab_lichsu_gh}    ${jsonpath_trangthai_gh}
    Return From Keyword    ${get_giatri_hd_in_tab_lichsu}    ${get_phi_gh_in_tab_lichsu}    ${get_ttgh_in_tab_lichsu}

Validate partnerdelivery if TTGH is not Chua giao hang or Da huy
    [Arguments]    ${input_ma_dtgh}    ${input_ma_hd}    ${input_phi_gh}    ${result_no_hientai}
    [Timeout]          5 mins
    ${get_giatri_hd_in_tab_lichsu}    ${get_phi_gh_in_tab_lichsu}    ${get_ttgh_in_tab_lichsu}    Get info tab lich su giao hang    ${input_ma_dtgh}    ${input_ma_hd}
    ${get_loai_in_tab_congno}    ${get_giatri_in_tab_congno}    ${get_nohientai_in_tab_congno}    Get info tab phi can tra DTGH frm API    ${input_ma_dtgh}    ${input_ma_hd}
    ${get_trangthai_gh_af_execute}    ${get_khachcantra_in_hd_af_execute}    Get delivery status frm Invoice    ${input_ma_hd}
    Should Be Equal As Numbers    ${get_loai_in_tab_congno}    3
    Should Be Equal As Numbers    ${get_giatri_in_tab_congno}    ${input_phi_gh}
    Should Be Equal As Numbers    ${get_nohientai_in_tab_congno}    ${result_no_hientai}
    Should Be Equal As Numbers    ${get_giatri_hd_in_tab_lichsu}    ${get_khachcantra_in_hd_af_execute}
    Should Be Equal As Numbers    ${get_phi_gh_in_tab_lichsu}    ${input_phi_gh}
    Should Be Equal As Numbers    ${get_ttgh_in_tab_lichsu}    ${get_trangthai_gh_af_execute}

Get info tab phi can tra DTGH frm API
    [Arguments]    ${input_ma_DTGH}    ${input_ma_hd}
    [Timeout]          5 mins
    ${jsonpath_parternid}    Format String    $..Data[?(@.Code=="{0}")].Id    ${input_ma_DTGH}
    ${get_id_dtgh}    Get data from API    ${endpoint_dtgh}    ${jsonpath_parternid}
    ${jsonpath_loai}    Format String    $..Data[?(@.DocumentCode=="{0}")].DocumentType    ${input_ma_hd}
    ${jsonpath_giatri}    Format String    $..Data[?(@.DocumentCode=="{0}")].Value    ${input_ma_hd}
    ${jsonpath_no_hientai}    Format String    $..Data[?(@.DocumentCode=="{0}")].Balance    ${input_ma_hd}
    ${endpoint_congno_dtgh}    Format String    ${endpoint_tab_cong_no_dtgh}    ${get_id_dtgh}
    ${get_loai_in_tab_congno}    Get data from API    ${endpoint_congno_dtgh}    ${jsonpath_loai}
    ${get_giatri_in_tab_congno_bf}    Get data from API    ${endpoint_congno_dtgh}    ${jsonpath_giatri}
    ${get_string_giatri_in_tab_congno}    Convert To String    ${get_giatri_in_tab_congno_bf}
    ${get_string_giatri_in_tab_congno}    Replace String    ${get_string_giatri_in_tab_congno}    -    ${EMPTY}
    ${get_giatri_in_tab_congno}    Convert To Number    ${get_string_giatri_in_tab_congno}
    ${get_nohientai_bf_in_tab_congno}    Get data from API    ${endpoint_congno_dtgh}    ${jsonpath_no_hientai}
    ${get_string_nohientai_in_tab_congno}    Convert To String    ${get_nohientai_bf_in_tab_congno}
    ${get_string_nohientai_in_tab_congno}    Replace String    ${get_string_nohientai_in_tab_congno}    -    ${EMPTY}
    ${get_nohientai_in_tab_congno}    Convert To Number    ${get_string_nohientai_in_tab_congno}
    Return From Keyword    ${get_loai_in_tab_congno}    ${get_giatri_in_tab_congno}    ${get_nohientai_in_tab_congno}

Validate partnerdelivery if TTGH is Chua giao hang or Da huy
    [Arguments]    ${input_ma_DTGH}    ${input_ma_hd}    ${input_phi_gh}
    [Timeout]          5 mins
    ${get_trangthai_gh_af_execute}    ${get_khachcantra_in_hd_af_execute}    Get delivery status frm Invoice    ${input_ma_hd}
    ${get_giatri_hd_in_tab_lichsu}    ${get_phi_gh_in_tab_lichsu}    ${get_ttgh_in_tab_lichsu}    Get info tab lich su giao hang    ${input_ma_DTGH}    ${input_ma_hd}
    Should Be Equal As Numbers    ${get_giatri_hd_in_tab_lichsu}    ${get_khachcantra_in_hd_af_execute}
    Run Keyword If    '${input_phi_gh}' == '0'    Should Be Equal As Numbers    ${get_phi_gh_in_tab_lichsu}    0
    ...    ELSE    Should Be Equal As Numbers    ${get_phi_gh_in_tab_lichsu}    ${input_phi_gh}
    Should Be Equal As Numbers    ${get_ttgh_in_tab_lichsu}    ${get_trangthai_gh_af_execute}

Get cong no DTGH frm API
    [Arguments]    ${input_ma_DTGH}
    [Timeout]          5 mins
    ${jsonpath_tong_hd}    Format String    $..Data[?(@.Code=="{0}")].TotalInvoices    ${input_ma_DTGH}
    ${jsonpath_no_hientai}    Format String    $..Data[?(@.Code=="{0}")].TotalDebt    ${input_ma_DTGH}
    ${jsonpath_tong_phi_gh}    Format String    $..Data[?(@.Code=="{0}")].TotalCost    ${input_ma_DTGH}
    ${get_resp}     Get Request and return body    ${endpoint_dtgh}
    ${get_tong_hd_execute}    Get data from response json       ${get_resp}    ${jsonpath_tong_hd}
    ${get_no_hientai_execute}   Get data from response json       ${get_resp}    ${jsonpath_no_hientai}
    ${get_phi_giao_hang}    Get data from response json       ${get_resp}    ${jsonpath_tong_phi_gh}
    Return From Keyword    ${get_tong_hd_execute}    ${get_no_hientai_execute}    ${get_phi_giao_hang}

Validate no can tra hien tai if phi giao hang bang 0
    [Arguments]    ${get_no_hientai_bf_purchase}    ${get_no_hientai_af_purchase}
    [Timeout]          5 mins
    ${result_no_hien_tai}    Sum    ${get_no_hientai_bf_purchase}    0
    Should Be Equal As Numbers    ${get_no_hientai_af_purchase}    ${result_no_hien_tai}

Validate no can tra hien tai if phi giao hang khac 0
    [Arguments]    ${get_no_hientai_bf_purchase}    ${get_no_hientai_af_purchase}    ${input_phi_gh}
    [Timeout]          5 mins
    ${result_no_hien_tai}    Sum    ${get_no_hientai_bf_purchase}    ${input_phi_gh}
    Should Be Equal As Numbers    ${get_no_hientai_af_purchase}    ${result_no_hien_tai}

Validate partnerdelivery if Phi giao hang is set zero
    [Arguments]    ${input_ma_dtgh}    ${input_ma_hd}
    ${get_trangthai_gh_af_execute}    ${get_khachcantra_in_hd_af_execute}    Get delivery status frm Invoice    ${input_ma_hd}
    [Timeout]          5 mins
    ${get_giatri_hd_in_tab_lichsu}    ${get_phi_gh_in_tab_lichsu}    ${get_ttgh_in_tab_lichsu}    Get info tab lich su giao hang    ${input_ma_dtgh}    ${input_ma_hd}
    Should Be Equal As Numbers    ${get_giatri_hd_in_tab_lichsu}    ${get_khachcantra_in_hd_af_execute}
    Should Be Equal As Numbers    ${get_phi_gh_in_tab_lichsu}    0
    Should Be Equal As Numbers    ${get_ttgh_in_tab_lichsu}    ${get_trangthai_gh_af_execute}

Get info ĐTGH frm APi
    [Arguments]    ${input_ten_DTGH}
    [Timeout]          5 mins
    ${jsonpath_ma_DTGh}    Format String    $..Data[?(@.Name == '{0}')].Code    ${input_ten_DTGH}
    ${jsonpath_id_DTGH}    Format String    $..Data[?(@.Name == '{0}')].Id    ${input_ten_DTGH}
    ${get_ma_DTGH}    Get data from API    ${endpoint_dtgh}    ${jsonpath_ma_DTGh}
    ${get_id_DTGH}    Get data from API    ${endpoint_dtgh}    ${jsonpath_id_DTGH}
    ${endpoint_congno_dtgh}    Format String    ${endpoint_tab_cong_no_dtgh}    ${get_id_DTGH}
    ${get_first_ma_hd_tab_lichsu_gh}    Get data from API    ${endpoint_congno_dtgh}    $..Data[0].DocumentCode
    Return From Keyword    ${get_first_ma_hd_tab_lichsu_gh}    ${get_ma_DTGH}    ${get_id_DTGH}

Validate no can tra hien tai if phi giao hang is set zero
    [Arguments]    ${get_no_hientai_bf_purchase}    ${get_no_hientai_af_purchase}    ${input_phi_gh}
    [Timeout]          5 mins
    ${result_no_hien_tai}    Minus    ${get_no_hientai_bf_purchase}    ${input_phi_gh}
    Should Be Equal As Numbers    ${get_no_hientai_af_purchase}    ${result_no_hien_tai}

Computation Cong no DTGH
    [Arguments]    ${input_ma_dtgh}    ${input_phi_gh}
    [Timeout]          5 mins
    ${get_tong_hd_bf_purchase}    ${get_no_hientai_bf_purchase}    ${get_tong_phi_gh_bf_purchase}    Get cong no DTGH frm API    ${input_ma_dtgh}
    ${result_tong_hd_DTGH}    Sum    ${get_tong_hd_bf_purchase}    1
    ${resul_tong_phi_gh_DTGH}    Sum    ${get_tong_phi_gh_bf_purchase}    ${input_phi_gh}
    ${resul_no_cantra_hientai_DTGH}    Sum    ${get_no_hientai_bf_purchase}    ${input_phi_gh}
    ${result_no_hientai_in_tab_congno_DTGH}    Sum    ${get_no_hientai_bf_purchase}    ${input_phi_gh}
    Return From Keyword    ${result_tong_hd_DTGH}    ${resul_tong_phi_gh_DTGH}    ${resul_no_cantra_hientai_DTGH}    ${result_no_hientai_in_tab_congno_DTGH}

Get DTGH name frm API
    [Arguments]    ${input_ma_dtgh}
    [Timeout]          5 mins
    ${jsonpath_ten_dtgh}    Format String    $..Data[?(@.Code == '{0}')].Name    ${input_ma_dtgh}
    ${get_ten_dtgh}    Get data from API    ${endpoint_dtgh}    ${jsonpath_ten_dtgh}
    Return From Keyword    ${get_ten_dtgh}

Get DTGH debt after cash flow
    [Arguments]    ${input_ma_DTGH}    ${input_ma_phieu}
    [Timeout]          5 mins
    ${jsonpath_parternid}    Format String    $..Data[?(@.Code=="{0}")].Id    ${input_ma_DTGH}
    ${get_id_dtgh}    Get data from API    ${endpoint_dtgh}    ${jsonpath_parternid}
    ${endpoint_debt_tab_by_dtgh}    Format String    ${endpoint_tab_cong_no_dtgh}    ${get_id_dtgh}
    ${jsonpath_no}    Format String    $..Data[?(@.DocumentCode == '{0}')].Value    ${input_ma_phieu}
    ${get_no}    Get data from API    ${endpoint_debt_tab_by_dtgh}    ${jsonpath_no}
    Return From Keyword    ${get_no}

Get deliverypartner info and validate
    [Arguments]      ${deliverypartner_code}      ${deliverypartner_name}     ${delivery_mobile}      ${delivery_address}       ${delivery_location}     ${delivery_ward}      ${delivery_email}      ${delivery_note}
    [Timeout]          5 mins
    ${jsonpath_deliverypartnername}    Format String    $..Data[?(@.Code=="{0}")].Name    ${deliverypartner_code}
    ${jsonpath_mobile}    Format String    $..Data[?(@.Code=="{0}")].ContactNumber    ${deliverypartner_code}
    ${jsonpath_location}    Format String    $..Data[?(@.Code=="{0}")].LocationName    ${deliverypartner_code}
    ${jsonpath_ward}    Format String    $..Data[?(@.Code=="{0}")].WardName    ${deliverypartner_code}
    ${jsonpath_address}    Format String    $..Data[?(@.Code=="{0}")].Address    ${deliverypartner_code}
    ${jsonpath_email}    Format String    $..Data[?(@.Code=="{0}")].Email    ${deliverypartner_code}
    ${jsonpath_delivery_note}      Format String    $..Data[?(@.Code=="{0}")].Comments    ${deliverypartner_code}
    ${jsonpath_delivery_id}    Format String    $..Data[?(@.Code=="{0}")].Id    ${deliverypartner_code}
    ${response_dtgh_info}    Get Request and return body    ${endpoint_dtgh}
    ${get_deliverypartner_name}    Get data from response json    ${response_dtgh_info}    ${jsonpath_deliverypartnername}
    ${get_deliverypartner_mobile}    Get data from response json    ${response_dtgh_info}    ${jsonpath_mobile}
    ${get_deliverypartner_location}    Get data from response json    ${response_dtgh_info}    ${jsonpath_location}
    ${get_deliverypartner_ward}    Get data from response json    ${response_dtgh_info}    ${jsonpath_ward}
    ${get_deliverypartner_address}    Get data from response json    ${response_dtgh_info}    ${jsonpath_address}
    ${get_deliverypartner_email}    Get data from response json    ${response_dtgh_info}    ${jsonpath_email}
    ${get_deliverypartner_note}    Get data from response json    ${response_dtgh_info}    ${jsonpath_delivery_note}
    ${get_deliverypartner_id}    Get data from response json    ${response_dtgh_info}    ${jsonpath_delivery_id}
    #Should Be Equal As Strings    ${delivery_type}    ${get_deliverypartner_type}
    Should Be Equal As Strings    ${deliverypartner_name}    ${get_deliverypartner_name}
    Run Keyword If    '${delivery_mobile}'=='none'      Should Be Equal As Numbers    ${get_deliverypartner_mobile}      0     ELSE     Should Be Equal As Strings    ${delivery_mobile}    ${get_deliverypartner_mobile}
    Run Keyword If    '${delivery_address}'=='none'       Should Be Equal As Numbers     ${get_deliverypartner_address}      0     ELSE     Should Be Equal As Strings    ${delivery_address}    ${get_deliverypartner_address}
    Run Keyword If    '${delivery_location}'=='none'       Should Be Equal As Numbers    ${get_deliverypartner_location}     0     ELSE     Should Be Equal As Strings    ${delivery_location}    ${get_deliverypartner_location}
    Run Keyword If    '${delivery_ward}'=='none'       Should Be Equal As Numbers    ${get_deliverypartner_ward}     0     ELSE     Should Be Equal As Strings    ${delivery_ward}    ${get_deliverypartner_ward}
    Run Keyword If    '${delivery_email}'=='none'       Should Be Equal As Numbers    ${get_deliverypartner_email}     0     ELSE     Should Be Equal As Strings    ${delivery_email}    ${get_deliverypartner_email}
    Run Keyword If    '${delivery_note}'=='none'       Should Be Equal As Numbers    ${get_deliverypartner_note}     0     ELSE     Should Be Equal As Strings    ${delivery_note}    ${get_deliverypartner_note}
    Return From Keyword    ${get_deliverypartner_id}

Get deliverypartner id frm api
    [Arguments]      ${deliverypartner_code}
    ${response_dtgh_info}    Get Request and return body    ${endpoint_dtgh}
    ${jsonpath_delivery_id}    Format String    $..Data[?(@.Code=="{0}")].Id    ${deliverypartner_code}
    ${get_deliverypartner_id}    Get data from response json    ${response_dtgh_info}    ${jsonpath_delivery_id}
    Return From Keyword    ${get_deliverypartner_id}

Delete DeliveryPartner
      [Arguments]         ${delivery_id}
      [Timeout]          5 mins
      ${data_str}    Format String    {{"Ids":[{0}]}}      ${delivery_id}
      log    ${data_str}
      ${endpoint_delete_delivery_byid}       Format String    ${endpoint_delete_partner}    ${delivery_id}
      Delete request thr API     ${endpoint_delete_delivery_byid}

Delete delivery exist frm api
      [Arguments]         ${input_delivery}
      ${get_delivery_id}   Get deliverypartner id frm api    ${input_delivery}
      Run Keyword If    '${get_delivery_id}' == '0'    Log     Ignore del     ELSE    Delete DeliveryPartner    ${get_delivery_id}

Adapt Delivery Partner Dept
    [Arguments]        ${deliverypartner_code}        ${adjusted_amount}
    ${get_id_dtgh}    Get deliverypartner id frm api        ${deliverypartner_code}
    ${data_str}    Format String    {{"Adjustment":{{"Balance":{0},"Value":null,"AdjustmentDate":""}},"partnerdeliveryId":{1},"CompareCode":"{2}","CompareName":"abc"}}    ${adjusted_amount}     ${get_id_dtgh}    ${deliverypartner_code}
    log    ${data_str}
    ${endpoint_adjust_debt}        Format String        ${endpoint_tao_phieu_dieu_chinh_dtgh}        ${get_id_dtgh}
    ${resp3.json()}   Post request thr API    ${endpoint_adjust_debt}    ${data_str}
    ${ma_phieu}     Get data from response json    ${resp3.json()}    $..Code
    Return From Keyword    ${ma_phieu}
