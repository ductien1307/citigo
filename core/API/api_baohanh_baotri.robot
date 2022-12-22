*** Settings ***
Resource          api_access.robot
Resource          api_hoadon_banhang.robot
Resource          api_danhmuc_hanghoa.robot

*** Variables ***
${endpoint_list_baohanh}    /invoices/warranty?format=json&Includes=ProductName&Includes=CustomerPhone&Includes=BranchName&Includes=ProductWarranties&Includes=ProductCode&Includes=Invoice&Includes=CustomerName&Includes=CustomerCode&Includes=Note&%24inlinecount=allpages&WarrantyFilterType=alltime&ExpiryWarrantyFilterType=alltime&PurchaseFilterType=month&WarrantyStatusKey=2&BranchIds={0}&%24top=15    #Branch id
${endpoint_phieubaohanh_deltail}  /invoices/warranty?format=json&Includes=ProductName&Includes=CustomerPhone&Includes=BranchName&Includes=ProductWarranties&Includes=ProductCode&Includes=Invoice&Includes=CustomerName&Includes=CustomerCode&Includes=Note&%24inlinecount=allpages&ProductCodeKey={0}&ProductNameKey=&InvoiceCodeKey={1}&WarrantyFilterType=alltime&ExpiryWarrantyFilterType=alltime&PurchaseFilterType=month&WarrantyStatusKey=2&BranchIds={2}   #ma HH, branch id
${endpoint_phieubaohanh_imei_detail}    /invoices/warranty?format=json&Includes=ProductName&Includes=CustomerPhone&Includes=BranchName&Includes=ProductWarranties&Includes=ProductCode&Includes=Invoice&Includes=CustomerName&Includes=CustomerCode&Includes=Note&%24inlinecount=allpages&SerialKey={0}&WarrantyFilterType=alltime&ExpiryWarrantyFilterType=alltime&PurchaseFilterType=month&WarrantyStatusKey=2&BranchIds={1}&%24top=15   #ma HH, branch id
${endpoint_list_baohanh_in_product}   /warranty?ProductIds={0}&RetailerId={1}   #product id, retailer id
*** Keywords ***
Get warranty info by invoice code and product code
    [Arguments]    ${input_ma_hh}   ${input_ma_hd}
    [Timeout]    5 minutes
    ${endpoint_deltail_pbh}   Format String   ${endpoint_phieubaohanh_deltail}    ${input_ma_hh}   ${input_ma_hd}    ${BRANCH_ID}
    ${resp}  Get Request and return body    ${endpoint_deltail_pbh}
    ${jsonpath_ma_kh}    Format String    $.Data..CustomerCode    ${input_ma_hh}
    ${jsonpath_quantity}    Format String    $.Data..Quantity    ${input_ma_hh}
    ${get_customer_in_pbh}    Get data from response json    ${resp}    ${jsonpath_ma_kh}
    ${get_quantity_in_pbh}    Get data from response json    ${resp}    ${jsonpath_quantity}
    ${get_time_bh_in_pbh}    Get raw data from response json    ${resp}    $..ProductWarranties[?(@.WarrantyType==1)].NumberTime
    ${get_timetype_bh_in_pbh}    Get raw data from response json    ${resp}    $..ProductWarranties[?(@.WarrantyType==1)].TimeType
    ${get_time_bt_in_pbh}    Get data from response json    ${resp}    $..ProductWarranties[?(@.WarrantyType==3)].NumberTime
    ${get_timetype_bt_in_pbh}    Get data from response json    ${resp}    $..ProductWarranties[?(@.WarrantyType==3)].TimeType
    ${get_quantity_in_pbh}   Convert To Number    ${get_quantity_in_pbh}
    ${get_time_bt_in_pbh}   Convert To Number    ${get_time_bt_in_pbh}
    ${get_timetype_bt_in_pbh}   Convert To Number    ${get_timetype_bt_in_pbh}
    Return From Keyword    ${get_customer_in_pbh}    ${get_quantity_in_pbh}    ${get_time_bh_in_pbh}    ${get_timetype_bh_in_pbh}
    ...    ${get_time_bt_in_pbh}    ${get_timetype_bt_in_pbh}

Get warranty info by imei code
    [Arguments]    ${input_imei}
    [Timeout]    5 minutes
    ${endpoint_deltail_pbh}   Format String   ${endpoint_phieubaohanh_imei_detail}    ${input_imei}    ${BRANCH_ID}
    ${resp}  Get Request and return body    ${endpoint_deltail_pbh}
    ${jsonpath_ma_hd}    Format String    $.Data[?(@.SerialNumbers== "{0}")]..Code    ${input_imei}
    ${jsonpath_ma_kh}    Format String    $.Data[?(@.SerialNumbers=='{0}')].CustomerCode    ${input_imei}
    ${jsonpath_quantity}    Format String    $.Data[?(@.SerialNumbers=='{0}')]..Quantity    ${input_imei}
    ${get_customer_in_pbh}    Get data from response json    ${resp}    ${jsonpath_ma_kh}
    ${get_invoice_code_in_pbh}    Get data from response json    ${resp}    ${jsonpath_ma_hd}
    ${get_quantity_in_pbh}    Get data from response json    ${resp}    ${jsonpath_quantity}
    ${get_time_bh_in_pbh}    Get raw data from response json    ${resp}    $..ProductWarranties[?(@.WarrantyType==1)].NumberTime
    ${get_timetype_bh_in_pbh}    Get raw data from response json    ${resp}    $..ProductWarranties[?(@.WarrantyType==1)].TimeType
    ${get_time_bt_in_pbh}    Get data from response json    ${resp}    $..ProductWarranties[?(@.WarrantyType==3)].NumberTime
    ${get_timetype_bt_in_pbh}    Get data from response json    ${resp}    $..ProductWarranties[?(@.WarrantyType==3)].TimeType
    ${get_quantity_in_pbh}   Convert To Number    ${get_quantity_in_pbh}
    ${get_time_bt_in_pbh}   Convert To Number    ${get_time_bt_in_pbh}
    ${get_timetype_bt_in_pbh}   Convert To Number    ${get_timetype_bt_in_pbh}
    Return From Keyword    ${get_customer_in_pbh}    ${get_invoice_code_in_pbh}    ${get_quantity_in_pbh}    ${get_time_bh_in_pbh}    ${get_timetype_bh_in_pbh}
    ...    ${get_time_bt_in_pbh}    ${get_timetype_bt_in_pbh}

Get list warranty imei info frm warranty api
    [Arguments]    ${list_imei}
    [Timeout]    5 minutes
    ${list_customer_in_pbh}   Create List
    ${list_invoice_code_pbh}   Create List
    ${list_quantity_in_pbh}   Create List
    ${list_time_bh_in_pbh}   Create List
    ${list_timetype_bh_pbh}   Create List
    ${list_time_bt_in_pbh}   Create List
    ${list_timetype_bt_in_pbh}   Create List
    :FOR      ${item_imei}     IN    @{list_imei}
    \    ${get_customer_in_pbh}    ${get_invoice_code_in_pbh}    ${get_quantity_in_pbh}    ${get_time_bh_in_pbh}    ${get_timetype_bh_in_pbh}
    \    ...    ${get_time_bt_in_pbh}    ${get_timetype_bt_in_pbh}    Get warranty info by imei code    ${item_imei}
    \    Append To List    ${list_customer_in_pbh}    ${get_customer_in_pbh}
    \    Append To List    ${list_invoice_code_pbh}    ${get_invoice_code_in_pbh}
    \    Append To List    ${list_quantity_in_pbh}    ${get_quantity_in_pbh}
    \    Append To List    ${list_time_bh_in_pbh}    ${get_time_bh_in_pbh}
    \    Append To List    ${list_timetype_bh_pbh}    ${get_timetype_bh_in_pbh}
    \    Append To List    ${list_time_bt_in_pbh}    ${get_time_bt_in_pbh}
    \    Append To List    ${list_timetype_bt_in_pbh}    ${get_timetype_bt_in_pbh}
    Return From Keyword    ${list_customer_in_pbh}    ${list_invoice_code_pbh}    ${list_quantity_in_pbh}    ${list_time_bh_in_pbh}
    ...    ${list_timetype_bh_pbh}    ${list_time_bt_in_pbh}    ${list_timetype_bt_in_pbh}

Get list warranty info frm warranty api
    [Arguments]    ${list_product}    ${invoice_code}
    [Timeout]    5 minutes
    ${list_customer_in_pbh}   Create List
    ${list_quantity_in_pbh}   Create List
    ${list_time_bh_in_pbh}   Create List
    ${list_timetype_bh_pbh}   Create List
    ${list_time_bt_in_pbh}   Create List
    ${list_timetype_bt_in_pbh}   Create List
    :FOR      ${product}     IN    @{list_product}
    \    ${get_customer_in_pbh}    ${get_quantity_in_pbh}    ${get_time_bh_in_pbh}    ${get_timetype_bh_in_pbh}
    \    ...    ${get_time_bt_in_pbh}    ${get_timetype_bt_in_pbh}    Get warranty info by invoice code and product code    ${product}    ${invoice_code}
    \    Append To List    ${list_customer_in_pbh}    ${get_customer_in_pbh}
    \    Append To List    ${list_quantity_in_pbh}    ${get_quantity_in_pbh}
    \    Append To List    ${list_time_bh_in_pbh}    ${get_time_bh_in_pbh}
    \    Append To List    ${list_timetype_bh_pbh}    ${get_timetype_bh_in_pbh}
    \    Append To List    ${list_time_bt_in_pbh}    ${get_time_bt_in_pbh}
    \    Append To List    ${list_timetype_bt_in_pbh}    ${get_timetype_bt_in_pbh}
    Return From Keyword    ${list_customer_in_pbh}    ${list_quantity_in_pbh}    ${list_time_bh_in_pbh}
    ...    ${list_timetype_bh_pbh}    ${list_time_bt_in_pbh}    ${list_timetype_bt_in_pbh}

Assert multi value in guarantee
      [Arguments]    ${list_time_bh_in_pbh}    ${list_timetype_bh_pbh}    ${list_time_bh_in_pro}    ${list_timetype_bh_in_pro}
      [Timeout]    5 minutes
      :FOR    ${get_time_bh_pbh}    ${get_timetype_bh_pbh}    ${get_time_bh_in_pro}   ${get_timetype_bh_in_pro}   IN ZIP    ${list_time_bh_in_pbh}
      ...    ${list_timetype_bh_pbh}    ${list_time_bh_in_pro}    ${list_timetype_bh_in_pro}
      \     Should Be Equal As Numbers    ${get_time_bh_pbh}    ${get_time_bh_in_pro}
      \     Should Be Equal As Numbers    ${get_timetype_bh_pbh}    ${get_timetype_bh_in_pro}

Assert value in Warranty
    [Arguments]   ${list_product}    ${input_ma_kh}    ${invoice_code}   ${list_soluong_in_hd}    ${list_time_bh_in_pro}    ${list_timetype_bh_in_pro}
    ...    ${list_time_bt_in_pro}    ${list_timetype_bt_in_pro}
    [Timeout]    5 minutes
    ${list_customer_in_pbh}    ${list_quantity_in_pbh}    ${list_time_bh_in_pbh}    ${list_timetype_bh_pbh}
    ...    ${list_time_bt_in_pbh}    ${list_timetype_bt_in_pbh}   Get list warranty info frm warranty api    ${list_product}    ${invoice_code}
    :FOR    ${get_ma_kh_pbh}    ${get_quantity_pbh}    ${get_time_bh_pbh}    ${get_timetype_bh_pbh}    ${get_time_bt_in_pbh}
    ...     ${get_timetype_bt_in_pbh}   ${get_time_bh_in_pro}   ${get_timetype_bh_in_pro}   ${get_time_bt_in_pro}   ${get_timetype_bt_in_pro}   ${get_so_luong_in_hd}   IN ZIP    ${list_customer_in_pbh}
    ...    ${list_quantity_in_pbh}    ${list_time_bh_in_pbh}    ${list_timetype_bh_pbh}    ${list_time_bt_in_pbh}    ${list_timetype_bt_in_pbh}
    ...    ${list_time_bh_in_pro}    ${list_timetype_bh_in_pro}    ${list_time_bt_in_pro}    ${list_timetype_bt_in_pro}   ${list_soluong_in_hd}
    \     Should Be Equal As Strings    ${get_ma_kh_pbh}    ${input_ma_kh}
    \     Should Be Equal As Numbers    ${get_quantity_pbh}    ${get_so_luong_in_hd}
    \     Assert multi value in guarantee    ${get_time_bh_pbh}    ${get_timetype_bh_pbh}   ${get_time_bh_in_pro}   ${get_timetype_bh_in_pro}
    \     Should Be Equal As Numbers    ${get_time_bt_in_pbh}    ${get_time_bt_in_pro}
    \     Should Be Equal As Numbers    ${get_timetype_bt_in_pbh}    ${get_timetype_bt_in_pro}

Assert value warranty in invoice
    [Arguments]    ${invoice_code}    ${get_list_product_in_warranty}    ${list_product_type}
    ${list_time_bh_in_inv}    ${list_timetype_bh_inv}    ${list_time_bt_in_inv}    ${list_timetype_bt_in_inv}    Get list guarranty info frm invoice API    ${invoice_code}    ${get_list_product_in_warranty}
    ${get_list_time_bh_in_pro}    ${get_list_timetype_bh_in_pro}    ${get_list_time_bt_in_pro}    ${get_list_timetype_bt_in_pro}    Get list warranty from product API    ${get_list_product_in_warranty}
    : FOR    ${get_time_bh_inv}    ${get_timetype_bh_inv}    ${get_time_bt_in_inv}    ${get_timetype_bt_in_inv}    ${get_time_bh_in_pro}    ${get_timetype_bh_in_pro}
    ...    ${get_time_bt_in_pro}    ${get_timetype_bt_in_pro}    ${product_type}    IN ZIP    ${list_time_bh_in_inv}    ${list_timetype_bh_inv}
    ...    ${list_time_bt_in_inv}    ${list_timetype_bt_in_inv}    ${get_list_time_bh_in_pro}    ${get_list_timetype_bh_in_pro}    ${get_list_time_bt_in_pro}    ${ get_list_timetype_bt_in_pro}
    ...    ${list_product_type}
    \    Assert multi value in guarantee    ${get_time_bh_inv}    ${get_timetype_bh_inv}    ${get_time_bh_in_pro}    ${get_timetype_bh_in_pro}
    \    Should Be Equal As Numbers    ${get_time_bt_in_inv}    ${get_time_bt_in_pro}
    \    Should Be Equal As Numbers    ${get_timetype_bt_in_inv}    ${get_timetype_bt_in_pro}
