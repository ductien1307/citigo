*** Settings ***
Resource          api_hoadon_banhang.robot
Resource          api_hanghoa.robot
Resource          api_access.robot
Resource          ../share/list_dictionary.robot
Resource          ../share/discount.robot
Library           StringFormat
*** Variables ***
${endpoint_thekho}    /products/{0}/history?format=json&%24inlinecount=allpages&%24filter=BranchId+eq+{1}    # 0 is Product ID, 1 is branch Id
${endpoint_material}    /formula?format=json&Includes=Material&%24inlinecount=allpages&%24top=10&%24filter=ProductId+eq+{0}    # 0 is master product id
${endpoint_master_product}    /branchs/{0}/products?format=json&Includes=ProductAttributes&IsTabVariants=true&%24inlinecount=allpages
${enpoint_unit_detail}    /products/{0}/initialdata?Includes=ProductAttributes&ProductType=2
${endpoint_unit_info}       /branchs/{0}/products?format=json&Includes=ProductAttributes&IsTabVariants=true&%24inlinecount=allpages&%24filter=(MasterProductId+eq+{1}+or+MasterProductId+eq+-999999+or+Id+eq+-999999+or+Id+eq+{1})
${endpoint_danhmuc_hh_co_dvt}    /branchs/{0}/products?format=json&Includes=ProductAttributes&IsTabVariants=true&%24inlinecount=allpages    # branchid
${endpoint_imei_tab}    /products/{0}/serials?format=json&%24inlinecount=allpages&%24filter=Status+eq+1    # 0 is product id
${endpoint_single_product}    /products/{0}    # 0 is Id
${endpoint_batchexpire_dvt}    /products/{0}/{1}/-1/batchexpire?format=json&%24inlinecount=allpages    # 0: id sp, 1: giá trị quy đổi
${endpoint_batchexpire}     /products/{0}/{1}/1/batchexpire?format=json&%24inlinecount=allpages   # 0: id sp, 1: giá trị quy đổi
${endpoint_thekho_lo_dvt}    /products/{0}/{1}/{2}/batchexpirehistory?format=json&%24inlinecount=allpages    #0: id sp, 1: id của lô, 2: giá trị quy đôi
${endpoint_delete_product}    /products/{0}
${endpoint_delete_list_product}        /products/deleteproductlist
${endpoint_delete_category}    /categories?Id={0}    #0: id nhom hang
${endpoint_list_hh_in_mhbh}    /branchs/{0}/products/sync/fetchpaging?BranchId={1}&IncludeRemoved=true&Includes=Image&Includes=ProductAttributes&PageNum=1&PromotionVersion=true    #branchid
${endpoint_hanghoa_theo_nhom}    /branchs/{0}/masterproducts?format=json&Includes=ProductAttributes&ForSummaryRow=true&CategoryId={1}&AttributeFilter=%5B%5D&ProductTypes=&IsImei=2&IsFormulas=2&IsActive=true&AllowSale=&IsBatchExpireControl=2&ShelvesIds=&TrademarkIds=&StockoutDate=alltime    # 1: category id
${endpoint_warranty_in_product}   /warranty?ProductIds={0}&RetailerId={1}   #id product - retailerid
${endpoint_chitiet_hh}    /products/{0}/initialdata?Includes=ProductAttributes    #product id
${endpoint_ngung_kd}    /products/{0}/activeproduct
${endpoint_onhandbybranch}    /products/{0}/onhandbybranch?kvuniqueparam=2020    #product id

*** Keywords ***
Get list base price - cost - onhand - gia tri quy doi frm API
    [Arguments]    ${list_products}
    [Timeout]    5 minute
    ${list_baseprice}    Create List
    ${list_cost}    Create List
    ${list_onhand}    Create List
    ${endpoint_pr}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${get_resp}    Get Request and return body    ${endpoint_pr}
    Log    ${get_resp}
    ${list_giatri_quydoi}    Get list gia tri quy doi frm product API    ${list_products}
    : FOR    ${item_ma_hh}    ${get_giatri_quydoi}    IN ZIP    ${list_products}    ${list_giatri_quydoi}
    \    ${jsonpath_giaban}    Format String    $..Data[?(@.Code=="{0}")].BasePrice      ${item_ma_hh}
    \      ${jsonpath_giavon}    Format String    $..Data[?(@.Code=="{0}")].Cost    ${item_ma_hh}
    \    ${giaban}    Get data from response json    ${get_resp}    ${jsonpath_giaban}
    \    ${giavon}    ${ton}    Run Keyword If    '${get_giatri_quydoi}'=='1'    Get Cost and OnHand frm response API    ${item_ma_hh}
    \    ...    ${get_resp}
    \    ...    ELSE    Get cost and onhand incase unit product frm response API    ${item_ma_hh}    ${get_resp}
    \    Append to list    ${list_baseprice}    ${giaban}
    \    Append to list    ${list_cost}    ${giavon}
    \    Append to list    ${list_onhand}    ${ton}
    Return From Keyword    ${list_baseprice}    ${list_cost}    ${list_onhand}    ${list_giatri_quydoi}

Get list gia von - ton kho - gia tri quy doi
    [Arguments]    ${list_products}
    [Timeout]    5 minute
    ${list_cost}    Create List
    ${list_onhand}    Create List
    ${endpoint_pr}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${get_resp}    Get Request and return body    ${endpoint_pr}
    ${list_giatri_quydoi}    Get list gia tri quy doi frm product API    ${list_products}
    Log    ${get_resp}
    : FOR    ${item_ma_hh}    ${get_giatri_quydoi}    IN ZIP    ${list_products}    ${list_giatri_quydoi}
    \    ${jsonpath_giavon}    Format String    $..Data[?(@.Code=="{0}")].Cost    ${item_ma_hh}
    \    ${giavon}    ${ton}    Run Keyword If    '${get_giatri_quydoi}'=='1'    Get Cost and OnHand frm response API    ${item_ma_hh}
    \    ...    ${get_resp}
    \    ...    ELSE    Get cost and onhand incase unit product frm response API    ${item_ma_hh}    ${get_resp}
    \    Append to list    ${list_cost}    ${giavon}
    \    Append to list    ${list_onhand}    ${ton}
    Return From Keyword    ${list_cost}    ${list_onhand}    ${list_giatri_quydoi}

Get list cost - onhand frm API
    [Arguments]    ${list_products}
    [Timeout]    5 minute
    ${list_cost}    Create List
    ${list_onhand}    Create List
    ${endpoint_pr}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${get_resp}    Get Request and return body    ${endpoint_pr}
    ${list_giatri_quydoi}    Get list gia tri quy doi frm product API    ${list_products}
    Log    ${get_resp}
    : FOR    ${item_ma_hh}    ${get_giatri_quydoi}    IN ZIP    ${list_products}    ${list_giatri_quydoi}
    \    ${giavon}    ${ton}    Run Keyword If    '${get_giatri_quydoi}'=='1'    Get Cost and OnHand frm response API    ${item_ma_hh}
    \    ...    ${get_resp}
    \    ...    ELSE    Get cost and onhand incase unit product frm response API    ${item_ma_hh}    ${get_resp}
    \    Append to list    ${list_cost}    ${giavon}
    \    Append to list    ${list_onhand}    ${ton}
    Return From Keyword    ${list_cost}    ${list_onhand}

Get list cost frm API by product code
    [Arguments]    ${list_products}
    [Timeout]    5 minute
    ${list_cost}    Create List
    ${endpoint_pr}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${get_resp}    Get Request and return body    ${endpoint_pr}
    : FOR    ${item_product}   IN ZIP    ${list_products}
    \    ${jsonpath_giavon}    Format String    $..Data[?(@.Code=="{0}")].Cost    ${item_product}
    \    ${cost}    Get data from response json    ${get_resp}    ${jsonpath_giavon}
    \    Append to list    ${list_cost}    ${cost}
    Return From Keyword    ${list_cost}

Get Cost and OnHand frm response API
    [Arguments]    ${input_products}    ${get_resp}
    [Timeout]    5 minute
    ${jsonpath_giavon}    Format String    $..Data[?(@.Code=="{0}")].Cost    ${input_products}
    ${jsonpath_ton}    Format String    $..Data[?(@.Code=="{0}")].OnHand    ${input_products}
    ${cost}    Get data from response json    ${get_resp}    ${jsonpath_giavon}
    ${onhand}    Get data from response json    ${get_resp}    ${jsonpath_ton}
    ${onhand}    Convert To Number    ${onhand}
    ${onhand}    Evaluate    round(${onhand}, 3)
    Return From Keyword    ${cost}    ${onhand}

Get cost and onhand incase unit product frm response API
    [Arguments]    ${input_products}    ${get_resp}
    ${get_ma_hh_cb}    Get basic product frm unit product    ${input_products}
    ${jsonpath_giavon}    Format String    $..Data[?(@.Code=="{0}")].Cost    ${get_ma_hh_cb}
    ${jsonpath_ton}    Format String    $..Data[?(@.Code=="{0}")].OnHand    ${get_ma_hh_cb}
    ${cost}    Get data from response json    ${get_resp}    ${jsonpath_giavon}
    ${ton}    Get data from response json    ${get_resp}    ${jsonpath_ton}
    ${ton}    Convert To Number    ${ton}
    ${ton}    Evaluate    round(${ton}, 3)
    Return From Keyword    ${cost}    ${ton}

Get The kho Info frm API
    [Arguments]    ${input_sochungtu}    ${input_ma_hh}
    [Timeout]    3 minute
    ${endpoint_danhmuc_hh_co_dvt}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${list_toncuoi_in_chungtu}    Create List
    ${list_num_soluong_in_chungtu}    Create List
    ${jsonpath_productid}    Format String    $..Data[?(@.Code=="{0}")].Id    ${input_ma_hh}
    ${get_product_id}    Get data from API    ${endpoint_danhmuc_hh_co_dvt}    ${jsonpath_productid}
    ${endpoint_thekho_in_product}    Format String    ${endpoint_thekho}    ${get_product_id}    ${BRANCH_ID}
    ${get_resp}    Get Request and return body    ${endpoint_thekho_in_product}
    ${jsonpath_soluong_in_chungtu}    Format String    $..Data[?(@.DocumentCode=="{0}")].Quantity    ${input_sochungtu}
    ${soluong_in_chungtu}    Get data from response json    ${get_resp}    ${jsonpath_soluong_in_chungtu}
    ${soluong_in_chungtu}    Convert To String    ${soluong_in_chungtu}
    ${string_soluong_in_chungtu}    Replace String    ${soluong_in_chungtu}    -    ${EMPTY}
    ${num_soluong_in_chungtu}    Convert To Number    ${string_soluong_in_chungtu}
    ${jsonpath_toncuoi_in_chungtu}    Format String    $..Data[?(@.DocumentCode=="{0}")].EndingStocks    ${input_sochungtu}
    ${toncuoi_in_chungtu}    Get data from response json    ${get_resp}    ${jsonpath_toncuoi_in_chungtu}
    ${toncuoi_in_chungtu}    Convert to Number    ${toncuoi_in_chungtu}
    Return From Keyword    ${num_soluong_in_chungtu}    ${toncuoi_in_chungtu}

Get code unit frm API
    [Arguments]    ${input_ma_sp}    ${unitname}
    [Timeout]    3 minute
    ${endpoint_pr}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${id_coban}    Get product id thr API    ${input_ma_sp}
    ${endpoint_pr}    Format String    ${enpoint_unit_detail}    ${id_coban}
    ${jsonpath_mahang_unit}    Format String    $..ProductUnits[?(@.Unit=="{0}")].Code    ${unitname}
    ${mahang_unit}    Get data from API    ${endpoint_pr}    ${jsonpath_mahang_unit}
    Return From Keyword    ${mahang_unit}

Get list of unit codes and onhands frm API
    [Arguments]    ${product_code}
    [Timeout]    3 minute
    ${product_id}       Get product id thr API    ${product_code}
    ${endpoint_info_unit}    Format String    ${endpoint_unit_info}    ${BRANCH_ID}       ${product_id}
    ${resp_list_unit_info}     Get Request and return body    ${endpoint_info_unit}
    ${list_units}    Get raw data from response json    ${resp_list_unit_info}    $..Code
    ${list_onhands}    Get raw data from response json    ${resp_list_unit_info}     $..OnHand
    Return From Keyword      ${list_units}         ${list_onhands}

Get list of unit codes frm API
    [Arguments]    ${product_code}
    [Timeout]    3 minute
    ${product_id}       Get product id thr API    ${product_code}
    ${endpoint_info_unit}    Format String    ${endpoint_unit_info}    ${BRANCH_ID}       ${product_id}
    ${resp_list_unit_info}     Get Request and return body    ${endpoint_info_unit}
    ${list_units}    Get raw data from response json    ${resp_list_unit_info}    $..Code
    Return From Keyword      ${list_units}

Get DVQD frm API
    [Arguments]    ${input_ma_sp}    ${unitname}
    [Timeout]    3 minute
    ${id_unit_coban}    Get product id thr API    ${input_ma_sp}
    ${endpoint_pr}    Format String    ${enpoint_unit_detail}    ${id_unit_coban}
    ${jsonpath_dvqd}    Format String    $..ProductUnits[?(@.Unit=="{0}")].ConversionValue    ${unitname}
    ${dvqd}    Get data from API    ${endpoint_pr}    ${jsonpath_dvqd}
    ${dvqd}    Convert To Number    ${dvqd}
    Return From Keyword    ${dvqd}

Get Gia ban Gia von Ton kho frm API after purchase
    [Arguments]    ${input_mahang}    ${input_ma_hd}
    [Timeout]    5 minute
    ${endpoint_danhmuc_hh_co_dvt}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${jsonpath_productid}    Format String    $..Data[?(@.Code=="{0}")].Id    ${input_mahang}
    ${get_product_id}    Get data from API    ${endpoint_danhmuc_hh_co_dvt}    ${jsonpath_productid}
    ${endpoint_thekho_in_product}    Format String    ${endpoint_thekho}    ${get_product_id}    ${BRANCH_ID}
    Wait Until Keyword Succeeds    3 times    50 s    Get and validate data from API    ${endpoint_thekho_in_product}    ${input_ma_hd}    $..Data[0].DocumentCode
    ${endpoint_pr}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${get_resp_pr}    Get Request and return body    ${endpoint_pr}
    ${jsonpath_giaban}    Format String    $..Data[?(@.Code=="{0}")].BasePrice    ${input_mahang}
    ${jsonpath_giavon}    Format String    $..Data[?(@.Code=="{0}")].Cost    ${input_mahang}
    ${jsonpath_ton}    Format String    $..Data[?(@.Code=="{0}")].OnHand    ${input_mahang}
    ${giaban}    Get data from response json    ${get_resp_pr}    ${jsonpath_giaban}
    ${giavon}    Get data from response json    ${get_resp_pr}    ${jsonpath_giavon}
    ${ton}    Get data from response json    ${get_resp_pr}    ${jsonpath_ton}
    ${ton}    Convert To Number    ${ton}
    ${ton}    Evaluate    round(${ton}, 3)
    Return From Keyword    ${giaban}    ${giavon}    ${ton}

Get Cost - onhand - quantity frm API after purchase
    [Arguments]    ${input_ma_chungtu}    ${input_ma_hh}
    [Timeout]    5 minute
    ${endpoint_danhmuc_hh_co_dvt}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${get_resp_pr}    Get Request and return body    ${endpoint_danhmuc_hh_co_dvt}
    ${jsonpath_productid}    Format String    $..Data[?(@.Code=="{0}")].Id    ${input_ma_hh}
    ${get_product_id}    Get data from response json    ${get_resp_pr}    ${jsonpath_productid}
    ${endpoint_thekho_in_product}    Format String    ${endpoint_thekho}    ${get_product_id}    ${BRANCH_ID}
    ${get_resp}    Get Request and return body    ${endpoint_thekho_in_product}
    Wait Until Keyword Succeeds    3 times    50 s    Get and validate data from API    ${endpoint_thekho_in_product}    ${input_ma_chungtu}    $..Data[0].DocumentCode
    ${jsonpath_giavon}    Format String    $.Data[?(@.DocumentCode =='{0}')].Cost    ${input_ma_chungtu}
    ${jsonpath_ton}    Format String    $.Data[?(@.DocumentCode =='{0}')].EndingStocks    ${input_ma_chungtu}
    ${jsonpath_soluong_in_chungtu}    Format String    $.Data[?(@.DocumentCode =='{0}')].Quantity    ${input_ma_chungtu}
    ${soluong_in_chungtu}    Get data from response json    ${get_resp}    ${jsonpath_soluong_in_chungtu}
    ${soluong_in_chungtu}    Convert To String    ${soluong_in_chungtu}
    ${string_soluong_in_chungtu}    Replace String    ${soluong_in_chungtu}    -    ${EMPTY}
    ${num_soluong_in_chungtu}    Convert To Number    ${string_soluong_in_chungtu}
    ${giavon}    Get data from response json    ${get_resp}    ${jsonpath_giavon}
    ${ton}    Get data from response json    ${get_resp}    ${jsonpath_ton}
    ${ton}    Convert To Number    ${ton}
    ${ton}    Evaluate    round(${ton}, 3)
    Return From Keyword    ${num_soluong_in_chungtu}    ${giavon}    ${ton}

Get list base price and order summary frm product API
    [Arguments]    ${list_product}
    ${endpoint_pr}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${get_resp}    Get Request and return body    ${endpoint_pr}
    ${list_baseprice}    Create List
    ${list_order_summary}    Create List
    : FOR    ${item_ma_hh}    IN    @{list_product}
    \    ${jsonpath_giaban}    Format String    $..Data[?(@.Code=="{0}")].BasePrice    ${item_ma_hh}
    \    ${jsonpath_tong_dh}    Format String    $..Data[?(@.Code == '{0}')].Reserved    ${item_ma_hh}
    \    ${giaban}    Get data from response json    ${get_resp}    ${jsonpath_giaban}
    \    ${get_tong_dh}    Get data from response json    ${get_resp}    ${jsonpath_tong_dh}
    \    Append To List    ${list_baseprice}    ${giaban}
    \    Append To List    ${list_order_summary}    ${get_tong_dh}
    Return From Keyword    ${list_baseprice}    ${list_order_summary}

Get Onhand and Baseprice frm API
    [Arguments]    ${input_mahang}
    [Timeout]    3 minute
    ${endpoint_pr}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${get_resp}    Get Request and return body    ${endpoint_pr}
    ${jsonpath_ton}    Format String    $..Data[?(@.Code=="{0}")].OnHand    ${input_mahang}
    ${jsonpath_giaban}    Format String    $..Data[?(@.Code=="{0}")].BasePrice    ${input_mahang}
    ${ton}    Get data from response json    ${get_resp}    ${jsonpath_ton}
    ${ton}    Convert To Number    ${ton}
    ${ton}    Evaluate    round(${ton}, 3)
    ${giaban}    Get data from response json    ${get_resp}    ${jsonpath_giaban}
    Return From Keyword    ${ton}    ${giaban}

Get list of Onhand and Baseprice frm API
    [Arguments]    ${list_product_code}
    [Timeout]    3 minute
    ${list_onhand}    Create List
    ${list_baseprice}    Create List
    ${endpoint_pr}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${resp1.bodyjson}    Get Request and return body    ${endpoint_pr}
    : FOR    ${item_product}    IN ZIP    ${list_product_code}
    \    ${jsonpath_ton}    Format String    $..Data[?(@.Code=="{0}")].OnHand    ${item_product}
    \    ${jsonpath_giaban}    Format String    $..Data[?(@.Code=="{0}")].BasePrice    ${item_product}
    \    ${ton}    Get data from response json    ${resp1.bodyjson}    ${jsonpath_ton}
    \    ${ton}    Convert To Number    ${ton}
    \    ${ton}    Evaluate    round(${ton}, 3)
    \    ${giaban}    Get data from response json    ${resp1.bodyjson}    ${jsonpath_giaban}
    \    Append to list    ${list_onhand}    ${ton}
    \    Append to list    ${list_baseprice}    ${giaban}
    Return From Keyword    ${list_onhand}    ${list_baseprice}

Get list of Onhand and Baseprice frm API by Branch Name
    [Arguments]    ${list_product_codes}        ${branch_name}
    [Timeout]    3 minute
    ${list_onhand}    Create List
    ${list_baseprice}    Create List
    ${branchid}      Get BranchID by BranchName     ${branch_name}
    ${endpoint_pr}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${branchid}
    ${resp1.bodyjson}    Get Request and return body    ${endpoint_pr}
    : FOR    ${item_product}    IN ZIP    ${list_product_codes}
    \    ${jsonpath_ton}    Format String    $..Data[?(@.Code=="{0}")].OnHand    ${item_product}
    \    ${jsonpath_giaban}    Format String    $..Data[?(@.Code=="{0}")].BasePrice    ${item_product}
    \    ${ton}    Get data from response json    ${resp1.bodyjson}    ${jsonpath_ton}
    \    ${ton}    Convert To Number    ${ton}
    \    ${ton}    Evaluate    round(${ton}, 3)
    \    ${giaban}    Get data from response json    ${resp1.bodyjson}    ${jsonpath_giaban}
    \    Append to list    ${list_onhand}    ${ton}
    \    Append to list    ${list_baseprice}    ${giaban}
    Return From Keyword    ${list_onhand}    ${list_baseprice}

Get list of Onhands and Costs frm API
        [Arguments]    ${list_product_code}
        [Timeout]    3 minute
        ${list_onhand}    Create List
        ${list_cost}    Create List
        ${endpoint_pr}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
        ${resp1.bodyjson}    Get Request and return body    ${endpoint_pr}
        : FOR    ${item_product}    IN ZIP    ${list_product_code}
        \    ${jsonpath_onhand}    Format String    $..Data[?(@.Code=="{0}")].OnHand    ${item_product}
        \    ${jsonpath_cost}    Format String    $..Data[?(@.Code=="{0}")].Cost    ${item_product}
        \    ${ton}    Get data from response json    ${resp1.bodyjson}    ${jsonpath_onhand}
        \    ${ton}    Convert To Number    ${ton}
        \    ${ton}    Evaluate    round(${ton}, 3)
        \    ${cost}    Get data from response json    ${resp1.bodyjson}    ${jsonpath_cost}
        \    Append to list    ${list_onhand}    ${ton}
        \    Append to list    ${list_cost}    ${cost}
        Return From Keyword    ${list_onhand}    ${list_cost}

Get list of Baseprice by Product Code
    [Arguments]    ${list_product_code}
    [Timeout]    3 minute
    ${list_baseprice}    Create List
    ${endpoint_pr}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${resp1.bodyjson}    Get Request and return body    ${endpoint_pr}
    : FOR    ${item_product}    IN ZIP    ${list_product_code}
    \    ${jsonpath_giaban}    Format String    $..Data[?(@.Code=="{0}")].BasePrice    ${item_product}
    \    ${giaban_string}    Get data from response json    ${resp1.bodyjson}    ${jsonpath_giaban}
    \    ${giaban}    Convert To Number    ${giaban_string}
    \    Append to list    ${list_baseprice}    ${giaban}
    Return From Keyword    ${list_baseprice}

Get list of Product Id and Baseprice by Product Code
    [Arguments]    ${list_product_code}
    [Timeout]    3 minute
    ${list_baseprice}    Create List
    ${list_product_id}    Create List
    ${endpoint_pr}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${resp1.bodyjson}    Get Request and return body    ${endpoint_pr}
    : FOR    ${item_product}    IN ZIP    ${list_product_code}
    \    ${jsonpath_giaban}    Format String    $..Data[?(@.Code=="{0}")].BasePrice    ${item_product}
    \    ${jsonpath_productid}    Format String    $..Data[?(@.Code=="{0}")].Id    ${item_product}
    \    ${giaban_string}    Get data from response json    ${resp1.bodyjson}    ${jsonpath_giaban}
    \    ${giaban}    Convert To Number    ${giaban_string}
    \    ${product_id}    Get data from response json    ${resp1.bodyjson}    ${jsonpath_productid}
    \    Append to list    ${list_baseprice}    ${giaban}
    \    Append to list    ${list_product_id}    ${product_id}
    Return From Keyword    ${list_baseprice}    ${list_product_id}

Get list of Onhand by Product Code
    [Arguments]    ${list_product_code}
    [Timeout]    3 minute
    ${list_onhand}    Create List
    ${endpoint_pr}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${resp1.bodyjson}    Get Request and return body    ${endpoint_pr}
    : FOR    ${item_product}    IN ZIP    ${list_product_code}
    \    ${jsonpath_ton}    Format String    $..Data[?(@.Code=="{0}")].OnHand    ${item_product}
    \    ${ton}    Get data from response json    ${resp1.bodyjson}    ${jsonpath_ton}
    \    ${ton}    Convert To Number    ${ton}
    \    ${ton}    Evaluate    round(${ton}, 3)
    \    Append to list    ${list_onhand}    ${ton}
    Return From Keyword    ${list_onhand}

Get list of Baseprice from API by Id
    [Arguments]    ${list_product_id}
    [Timeout]    3 minute
    ${list_baseprice}    Create List
    : FOR    ${item_product_id}    IN ZIP    ${list_product_id}
    \    ${endpoint_product_by_id}    Format String    ${endpoint_single_product}    ${item_product_id}
    \    ${giaban_string}    Get data from API    ${endpoint_product_by_id}    $.BasePrice
    \    ${giaban}    Convert To Number    ${giaban_string}
    \    Append to list    ${list_baseprice}    ${giaban}
    Return From Keyword    ${list_baseprice}

Get list of Id from API by Product Code
    [Arguments]    ${list_product_code}
    [Timeout]    3 minute
    ${list_product_id}    Create List
    ${endpoint_pr}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${resp1.bodyjson}    Get Request and return body    ${endpoint_pr}
    : FOR    ${item_product_code}    IN ZIP    ${list_product_code}
    \    ${jsonpath_id}    Format String    $..Data[?(@.Code=="{0}")].Id    ${item_product_code}
    \    ${id_string}    Get data from response json    ${resp1.bodyjson}    ${jsonpath_id}
    \    Append to list    ${list_product_id}    ${id_string}
    Return From Keyword    ${list_product_id}

Assert list of Onhand after execute
    [Arguments]    ${list_product_code}    ${list_result_onhand}
    [Timeout]    3 minutes
    ${get_list_onhand}    ${get_list_baseprice}    Get list of Onhand and Baseprice frm API    ${list_product_code}
    : FOR    ${item_pr}   ${item_result_onhand}    ${item_onhand}    IN ZIP    ${list_product_code}   ${list_result_onhand}    ${get_list_onhand}
    \    Should Be Equal As Numbers    ${item_result_onhand}    ${item_onhand}

Assert list of Onhand after execute by branch
    [Arguments]    ${list_product_code}    ${list_result_onhand}    ${input_branch}
    [Timeout]    3 minutes
    ${get_list_onhand}    ${get_list_baseprice}    Get list of Onhand and Baseprice frm API by Branch Name      ${list_product_code}    ${input_branch}
    : FOR    ${item_pr}   ${item_result_onhand}    ${item_onhand}    IN ZIP    ${list_product_code}   ${list_result_onhand}    ${get_list_onhand}
    \    Should Be Equal As Numbers    ${item_result_onhand}    ${item_onhand}

Assert list of Onhand after execute until succeed
    [Arguments]   ${list_product_code}    ${list_result_onhand}
    Wait Until Keyword Succeeds    5x    3s    Assert list of Onhand after execute      ${list_product_code}    ${list_result_onhand}

Assert list of Onhand after execute in case having multi-product types
    [Arguments]    ${list_product_code}    ${list_product_type}    ${list_result_onhand}
    [Timeout]    3 minutes
    ${get_list_onhand}    ${get_list_baseprice}    Get list of Onhand and Baseprice frm API    ${list_product_code}
    : FOR    ${item_product_code}    ${item_product_type}    ${item_result_onhand}    ${item_onhand}    IN ZIP    ${list_product_code}
    ...    ${list_product_type}    ${list_result_onhand}    ${get_list_onhand}
    \    Run Keyword If    '${item_product_type}' == 'ser'    Should Be Equal As Numbers    0.0    ${item_onhand}
    \    ...    ELSE    Should Be Equal As Numbers    ${item_result_onhand}    ${item_onhand}

Assert list of Onhand after execute in case having multi-product types until success
    [Arguments]    ${list_product_code}    ${list_product_type}    ${list_result_onhand}
    Wait Until Keyword Succeeds    5 times    3 s     Assert list of Onhand after execute in case having multi-product types       ${list_product_code}    ${list_product_type}    ${list_result_onhand}

Get Onhand frm API after purchase
    [Arguments]    ${input_mahang}    ${input_ma_hd}
    [Timeout]   3 minute
    ${endpoint_danhmuc_hh_co_dvt}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${jsonpath_productid}    Format String    $..Data[?(@.Code=="{0}")].Id    ${input_mahang}
    ${get_product_id}    Get data from API    ${endpoint_danhmuc_hh_co_dvt}    ${jsonpath_productid}
    ${endpoint_thekho_in_product}    Format String    ${endpoint_thekho}    ${get_product_id}    ${BRANCH_ID}
    Wait Until Keyword Succeeds    3 times    5 s    Get and validate data from API    ${endpoint_thekho_in_product}    ${input_ma_hd}    $..Data[0].DocumentCode
    ${endpoint_pr}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${jsonpath_ton}    Format String    $..Data[?(@.Code=="{0}")].OnHand    ${input_mahang}
    ${ton}    Get data from API    ${endpoint_pr}    ${jsonpath_ton}
    ${ton}    Convert To Number    ${ton}
    ${ton}    Evaluate    round(${ton}, 3)
    Return From Keyword    ${ton}

Get Cost and OnHand frm API
    [Arguments]    ${input_mahang}
    [Timeout]    3 minute
    ${endpoint_pr}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${get_resp}    Get Request and return body    ${endpoint_pr}
    ${jsonpath_giavon}    Format String    $..Data[?(@.Code=="{0}")].Cost    ${input_mahang}
    ${jsonpath_ton}    Format String    $..Data[?(@.Code=="{0}")].OnHand    ${input_mahang}
    ${cost}    Get data from response json    ${get_resp}    ${jsonpath_giavon}
    ${onhand}    Get data from response json    ${get_resp}    ${jsonpath_ton}
    Return From Keyword    ${onhand}    ${cost}

Get Stock Card info frm API
    [Arguments]    ${input_sochungtu}    ${input_mahang}
    [Documentation]    lấy dữ liệu số lượng và tồn cuối được ghi nhật trên mã chứng từ
    ...    Không xóa dấu âm của số lượng
    [Timeout]    3 minute
    ${endpoint_danhmuc_hh_co_dvt}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${jsonpath_productid}    Format String    $..Data[?(@.Code=="{0}")].Id    ${input_mahang}
    ${get_product_id}    Get data from API    ${endpoint_danhmuc_hh_co_dvt}    ${jsonpath_productid}
    ${endpoint_thekho_in_product}    Format String    ${endpoint_thekho}    ${get_product_id}    ${BRANCH_ID}
    ${resp.stockcard}    Get Request and return body    ${endpoint_thekho_in_product}
    ${jsonpath_soluong_in_chungtu}    Format String    $..Data[?(@.DocumentCode=="{0}")].Quantity    ${input_sochungtu}
    ${jsonpath_toncuoi_in_chungtu}    Format String    $..Data[?(@.DocumentCode=="{0}")].EndingStocks    ${input_sochungtu}
    ${num_soluong_in_chungtu}    Get data from response json    ${resp.stockcard}    ${jsonpath_soluong_in_chungtu}
    ${toncuoi_in_chungtu}    Get data from response json    ${resp.stockcard}    ${jsonpath_toncuoi_in_chungtu}
    ${num_soluong_in_chungtu}    Convert To Number    ${num_soluong_in_chungtu}
    ${toncuoi_in_chungtu}    Convert to Number    ${toncuoi_in_chungtu}
    Return From Keyword    ${num_soluong_in_chungtu}    ${toncuoi_in_chungtu}

Get all documents in Stock Card
    [Arguments]    ${input_sochungtu}    ${input_mahang}
    [Documentation]    lấy dữ liệu số lượng và tồn cuối được ghi nhật trên mã chứng từ
    ...    Không xóa dấu âm của số lượng
    [Timeout]    3 minute
    ${endpoint_danhmuc_hh_co_dvt}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${jsonpath_productid}    Format String    $..Data[?(@.Code=="{0}")].Id    ${input_mahang}
    ${get_product_id}    Get data from API    ${endpoint_danhmuc_hh_co_dvt}    ${jsonpath_productid}
    ${endpoint_thekho_in_product}    Format String    ${endpoint_thekho}    ${get_product_id}    ${BRANCH_ID}
    ${all_docs}    Get raw data from API    ${endpoint_thekho_in_product}    $..DocumentCode
    Return From Keyword    ${all_docs}

Get Cost and Imei OnHand frm API
    [Arguments]    ${input_mahang}
    [Timeout]    3 minute
    ${endpoint_pr}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${get_resp}    Get Request and return body    ${endpoint_pr}
    ${jsonpath_giavon}    Format String    $..Data[?(@.Code=="{0}")].Cost    ${input_mahang}
    ${jsonpath_ton}    Format String    $..Data[?(@.Code=="{0}")].OnHand    ${input_mahang}
    ${jsonpath_productid}    Format String    $..Data[?(@.Code=="{0}")].ProductId    ${input_mahang}
    ${get_product_id}    Get data from response json    ${get_resp}    ${jsonpath_productid}
    ${endpoint_imei_tab_by_productid}    Format String    ${endpoint_imei_tab}    ${get_product_id}
    ${list_imei}    Get raw data from API    ${endpoint_imei_tab_by_productid}    $..SerialNumber
    ${giavon}    Get data from response json    ${get_resp}    ${jsonpath_giavon}
    ${ton}    Get data from response json    ${get_resp}    ${jsonpath_ton}
    Return From Keyword    ${giavon}    ${ton}    ${list_imei}

Assert values not avaiable in Stock Card
    [Arguments]    ${ma_phieukiem}    ${ma_hh}
    [Timeout]    3 minute
    ${all_docs}    Get all documents in Stock Card    ${ma_phieukiem}    ${ma_hh}
    List Should Not Contain Value    ${all_docs}    ${ma_phieukiem}

Assert values in Stock Card
    [Arguments]    ${ma_phieu}    ${ma_hh}    ${input_toncuoi}    ${input_num_instock}
    [Timeout]    3 minute
    ${soluong_in_thekho}    ${toncuoi_in_thekho}    Get Stock Card info frm API    ${ma_phieu}    ${ma_hh}
    Should Be Equal As Numbers    ${toncuoi_in_thekho}    ${input_toncuoi}
    Should Be Equal As Numbers    ${soluong_in_thekho}    ${input_num_instock}

Assert imei avaiable in SerialImei tab
    [Arguments]    ${input_mahang}    ${list_counted_imei}
    [Timeout]    3 minute
    ${endpoint_pr}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${jsonpath_productid}    Format String    $..Data[?(@.Code=="{0}")].Id    ${input_mahang}
    ${get_product_id}    Get data from API    ${endpoint_pr}    ${jsonpath_productid}
    ${endpoint_imei_tab_by_productid}    Format String    ${endpoint_imei_tab}    ${get_product_id}
    ${list_imei}    Get raw data from API    ${endpoint_imei_tab_by_productid}    $..SerialNumber
    List Should Contain Sub List    ${list_imei}    ${list_counted_imei}

Assert imei not avaiable in SerialImei tab
    [Arguments]    ${input_mahang}    @{list_imei_ex}
    [Timeout]    3 minute
    ${endpoint_pr}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${jsonpath_productid}    Format String    $..Data[?(@.Code=="{0}")].Id    ${input_mahang}
    ${get_product_id}    Get data from API    ${endpoint_pr}    ${jsonpath_productid}
    ${endpoint_imei_tab_by_productid}    Format String    ${endpoint_imei_tab}    ${get_product_id}
    ${list_imei}    Get raw data from API    ${endpoint_imei_tab_by_productid}    $..SerialNumber
    : FOR    ${item_imei_ex}    IN    @{list_imei_ex}
    \    List Should Not Contain Value    ${list_imei}    ${item_imei_ex}

Get Cost and string-Imei OnHand frm API
    [Arguments]    ${input_mahang}
    [Timeout]    3 minute
    ${endpoint_pr}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${jsonpath_giavon}    Format String    $..Data[?(@.Code=="{0}")].Cost    ${input_mahang}
    ${jsonpath_ton}    Format String    $..Data[?(@.Code=="{0}")].OnHand    ${input_mahang}
    ${jsonpath_productid}    Format String    $..Data[?(@.Code=="{0}")].ProductId    ${input_mahang}
    ${resp_product_list}    Get Request and return body    ${endpoint_pr}
    ${get_product_id}    Get data from response json    ${resp_product_list}    ${jsonpath_productid}
    ${endpoint_imei_tab_by_productid}    Format String    ${endpoint_imei_tab}    ${get_product_id}
    ${list_imei}    Get raw data from API    ${endpoint_imei_tab_by_productid}    $..SerialNumber
    ${giavon}    Get data from response json    ${resp_product_list}    ${jsonpath_giavon}
    ${ton}    Get data from response json    ${resp_product_list}    ${jsonpath_ton}
    Return From Keyword    ${giavon}    ${ton}    ${list_imei}

Get String-Imei OnHand by Product Id frm API
     [Arguments]    ${product_id}
     [Timeout]    3 minute
     ${endpoint_imei_tab_by_productid}    Format String    ${endpoint_imei_tab}    ${product_id}
     ${list_imei}    Get raw data from API    ${endpoint_imei_tab_by_productid}    $..SerialNumber
     Return From Keyword     ${list_imei}

Get Cost and Onhand frm API by Branch
    [Arguments]    ${input_productcode}    ${input_branch_name}
    [Timeout]    3 minute
    ${branchid}    ${endpoint_product_list_bybranch}    Get BranchID and Endpoint Product list by BranchName    ${input_branch_name}
    ${jsonpath_giavon}    Format String    $..Data[?(@.Code=="{0}")].Cost    ${input_productcode}
    ${jsonpath_ton}    Format String    $..Data[?(@.Code=="{0}")].OnHand    ${input_productcode}
    ${resp_product_list_by_branch}        Get Request and return body    ${endpoint_product_list_bybranch}
    ${onhand}    Get data from response json    ${resp_product_list_by_branch}    ${jsonpath_ton}
    ${cost}    Get data from response json    ${resp_product_list_by_branch}    ${jsonpath_giavon}
    Return From Keyword    ${onhand}    ${cost}

Get list cost and onhand frm API by Branch
    [Arguments]    ${list_pr}    ${input_branch_name}
    [Timeout]    3 minute
    ${branchid}    ${endpoint_product_list_bybranch}    Get BranchID and Endpoint Product list by BranchName    ${input_branch_name}
    ${resp_product_list_by_branch}        Get Request and return body    ${endpoint_product_list_bybranch}
    ${list_onhand}    Create List
    ${list_cost}      Create List
    :FOR    ${item_pr}      IN ZIP    ${list_pr}
    \   ${jsonpath_giavon}    Format String    $..Data[?(@.Code=="{0}")].Cost    ${item_pr}
    \   ${jsonpath_ton}    Format String    $..Data[?(@.Code=="{0}")].OnHand    ${item_pr}
    \   ${onhand}    Get data from response json    ${resp_product_list_by_branch}    ${jsonpath_ton}
    \   ${cost}    Get data from response json    ${resp_product_list_by_branch}    ${jsonpath_giavon}
    \   Append To List    ${list_onhand}    ${onhand}
    \   Append To List    ${list_cost}    ${cost}
    Return From Keyword    ${list_onhand}    ${list_cost}

Get BranchID and Endpoint Product list by BranchName
    [Arguments]    ${input_branch_name}
    [Timeout]    3 minute
    ${jsonpath_product_id_byname}    Format String    $..Data[?(@.Name=="{0}")].Id    ${input_branch_name}
    ${get_branch_id}    Get data from API    ${endpoint_branch_list}    ${jsonpath_product_id_byname}
    ${endpoint_productlist_by_branch}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${get_branch_id}
    Return From Keyword    ${get_branch_id}    ${endpoint_productlist_by_branch}

Get Stock Card info frm API by Branch
    [Arguments]    ${input_sochungtu}    ${input_mahang}    ${input_branch_name}
    [Documentation]    lấy dữ liệu số lượng và tồn cuối được ghi nhật trên mã chứng từ
    ...    Không xóa dấu âm của số lượng
    [Timeout]    3 minute
    ${branchid_by_branch}    ${endpoint_product_list_bybranch}    Get BranchID and Endpoint Product list by BranchName    ${input_branch_name}
    ${jsonpath_productid}    Format String    $..Data[?(@.Code=="{0}")].Id    ${input_mahang}
    ${get_product_id}    Get data from API    ${endpoint_product_list_bybranch}    ${jsonpath_productid}
    ${endpoint_thekho_in_product}    Format String    ${endpoint_thekho}    ${get_product_id}    ${branchid_by_branch}
    ${jsonpath_soluong_in_chungtu}    Format String    $..Data[?(@.DocumentCode=="{0}")].Quantity    ${input_sochungtu}
    ${jsonpath_toncuoi_in_chungtu}    Format String    $..Data[?(@.DocumentCode=="{0}")].EndingStocks    ${input_sochungtu}
    ${resp_stockcard}       Get Request and return body from API by BranchID     ${branchid_by_branch}    ${endpoint_thekho_in_product}
    ${soluong_in_chungtu}    Get data from response json       ${resp_stockcard}    ${jsonpath_soluong_in_chungtu}
    ${toncuoi_in_chungtu}    Get data from response json    ${resp_stockcard}     ${jsonpath_toncuoi_in_chungtu}
    ${num_soluong_in_chungtu}    Convert To Number    ${soluong_in_chungtu}
    ${toncuoi_in_chungtu}    Convert to Number    ${toncuoi_in_chungtu}
    Return From Keyword    ${num_soluong_in_chungtu}    ${toncuoi_in_chungtu}

Get Stock Card info frm API by Branch and User
    [Arguments]    ${input_sochungtu}    ${input_mahang}    ${input_branch_name}    ${input_user_name}
    [Documentation]    lấy dữ liệu số lượng và tồn cuối được ghi nhật trên mã chứng từ
    ...    Không xóa dấu âm của số lượng
    [Timeout]    3 minute
    ${branchid_by_branch}    ${endpoint_product_list_bybranch}    Get BranchID and Endpoint Product list by BranchName    ${input_branch_name}
    ${jsonpath_productid}    Format String    $..Data[?(@.Code=="{0}")].Id    ${input_mahang}
    ${get_product_id}    Get data from API    ${endpoint_product_list_bybranch}    ${jsonpath_productid}
    ${endpoint_thekho_in_product}    Format String    ${endpoint_thekho}    ${get_product_id}    ${branchid_by_branch}
    ${jsonpath_soluong_in_chungtu}    Format String    $..Data[?(@.DocumentCode=='{0}')].Quantity    ${input_sochungtu}
    ${jsonpath_toncuoi_in_chungtu}    Format String    $..Data[?(@.DocumentCode=='{0}')].EndingStocks    ${input_sochungtu}
    ${resp_stockcard}        Get Request and return body from API by BranchID and UserID    ${branchid_by_branch}    ${endpoint_thekho_in_product}    ${input_user_name}
    ${soluong_in_chungtu}    Get data from response json       ${resp_stockcard}    ${jsonpath_soluong_in_chungtu}
    ${toncuoi_in_chungtu}    Get data from response json    ${resp_stockcard}     ${jsonpath_toncuoi_in_chungtu}
    ${soluong_in_chungtu}    Convert To String    ${soluong_in_chungtu}
    ${soluong_in_chungtu}    Replace String    ${soluong_in_chungtu}    -    ${EMPTY}
    ${num_soluong_in_chungtu}    Convert To Number    ${soluong_in_chungtu}
    ${toncuoi_in_chungtu}    Convert to Number    ${toncuoi_in_chungtu}
    Return From Keyword    ${num_soluong_in_chungtu}    ${toncuoi_in_chungtu}

Assert values in Stock Card by Branch
    [Arguments]    ${ma_phieu}    ${product_code}    ${onhand}    ${quantity}    ${branch_name}
    [Timeout]    3 minute
    ${soluong_in_thekho}    ${toncuoi_in_thekho}    Get Stock Card info frm API by Branch    ${ma_phieu}    ${product_code}    ${branch_name}
    Should Be Equal As Numbers    ${toncuoi_in_thekho}    ${onhand}
    Should Be Equal As Numbers    ${soluong_in_thekho}    ${quantity}

Get all documents in Stock Card by Branch Name
    [Arguments]    ${input_branch_name}    ${input_sochungtu}    ${input_mahang}
    [Documentation]    lấy dữ liệu số lượng và tồn cuối được ghi nhật trên mã chứng từ
    ...    Không xóa dấu âm của số lượng
    [Timeout]    5 minute
    ${get_branch_id}    ${endpoint_productlist_by_branch}    Get BranchID and Endpoint Product list by BranchName    ${input_branch_name}
    ${endpoint_danhmuc_hh_co_dvt}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${get_branch_id}
    ${jsonpath_productid}    Format String    $..Data[?(@.Code=="{0}")].Id    ${input_mahang}
    ${get_product_id}    Get data from API by BranchID    ${get_branch_id}    ${endpoint_danhmuc_hh_co_dvt}    ${jsonpath_productid}
    ${endpoint_thekho_in_product}    Format String    ${endpoint_thekho}    ${get_product_id}    ${get_branch_id}
    ${all_docs}    Get raw data from API by BranchID    ${get_branch_id}    ${endpoint_thekho_in_product}    $..DocumentCode
    Return From Keyword    ${all_docs}

Assert values not avaiable in Stock Card by Branch Name
    [Arguments]    ${branch_name}    ${ma_phieukiem}    ${ma_hh}
    [Timeout]    3 minute
    ${all_docs}    Get all documents in Stock Card by Branch Name    ${branch_name}    ${ma_phieukiem}    ${ma_hh}
    List Should Not Contain Value    ${all_docs}    ${ma_phieukiem}

Get Cost and Imei OnHand frm API by Branch Name
    [Arguments]    ${branch_name}    ${input_mahang}
    [Timeout]    3 minute
    ${get_branch_id}    ${endpoint_productlist_by_branch}    Get BranchID and Endpoint Product list by BranchName    ${branch_name}
    ${endpoint_pr}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${get_branch_id}
    ${jsonpath_giavon}    Format String    $..Data[?(@.Code=="{0}")].Cost    ${input_mahang}
    ${jsonpath_ton}    Format String    $..Data[?(@.Code=="{0}")].OnHand    ${input_mahang}
    ${jsonpath_productid}    Format String    $..Data[?(@.Code=="{0}")].ProductId    ${input_mahang}
    ${get_product_id}    Get data from API by BranchID    ${get_branch_id}    ${endpoint_pr}    ${jsonpath_productid}
    ${endpoint_imei_tab_by_productid}    Format String    ${endpoint_imei_tab}    ${get_product_id}
    ${list_imei}    Get raw data from API by BranchID    ${get_branch_id}    ${endpoint_imei_tab_by_productid}    $..SerialNumber
    ${giavon}    Get data from API by BranchID    ${get_branch_id}    ${endpoint_pr}    ${jsonpath_giavon}
    ${ton}    Get data from API by BranchID    ${get_branch_id}    ${endpoint_pr}    ${jsonpath_ton}
    Return From Keyword    ${giavon}    ${ton}    ${list_imei}

Get List IMEI by product by BranchName
    [Arguments]    ${branch_name}    ${input_mahang}
    [Timeout]    3 minute
    ${get_branch_id}    ${endpoint_productlist_by_branch}    Get BranchID and Endpoint Product list by BranchName    ${branch_name}
    ${endpoint_pr}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${get_branch_id}
    ${jsonpath_productid}    Format String    $..Data[?(@.Code=="{0}")].Id    ${input_mahang}
    ${get_product_id}    Get data from API    ${endpoint_pr}    ${jsonpath_productid}
    ${endpoint_imei_tab_by_productid}    Format String    ${endpoint_imei_tab}    ${get_product_id}
    ${list_imei}    Get raw data from API    ${endpoint_imei_tab_by_productid}    $..SerialNumber
    Return From Keyword    ${list_imei}

Assert imei avaiable in SerialImei tab by BranchName
    [Arguments]    ${branch_name}    ${input_mahang}    ${list_counted_imei}
    [Timeout]    3 minute
    ${get_branch_id}    ${endpoint_productlist_by_branch}    Get BranchID and Endpoint Product list by BranchName    ${branch_name}
    ${endpoint_pr}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${get_branch_id}
    ${jsonpath_productid}    Format String    $..Data[?(@.Code=="{0}")].Id    ${input_mahang}
    ${get_product_id}    Get data from API    ${endpoint_pr}    ${jsonpath_productid}
    ${endpoint_imei_tab_by_productid}    Format String    ${endpoint_imei_tab}    ${get_product_id}
    ${list_imei}    Get raw data from API by BranchID    ${get_branch_id}    ${endpoint_imei_tab_by_productid}    $..SerialNumber
    List Should Contain Sub List    ${list_imei}    ${list_counted_imei}

Assert imei not avaiable in SerialImei tab by BranchName
    [Arguments]    ${branch_name}    ${input_mahang}    @{list_imei_ex}
    [Timeout]    3 minute
    ${get_branch_id}    ${endpoint_productlist_by_branch}    Get BranchID and Endpoint Product list by BranchName    ${branch_name}
    ${endpoint_pr}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${get_branch_id}
    ${jsonpath_productid}    Format String    $..Data[?(@.Code=="{0}")].Id    ${input_mahang}
    ${get_product_id}    Get data from API    ${endpoint_pr}    ${jsonpath_productid}
    ${endpoint_imei_tab_by_productid}    Format String    ${endpoint_imei_tab}    ${get_product_id}
    ${list_imei}    Get raw data from API by BranchID    ${get_branch_id}    ${endpoint_imei_tab_by_productid}    $..SerialNumber
    : FOR    ${item_imei_ex}    IN    @{list_imei_ex}
    \    List Should Not Contain Value    ${list_imei}    ${item_imei_ex}

Get Cost and Onhand of Unit frm API by Branch
    [Arguments]    ${input_productcode}    ${input_branch_name}
    [Timeout]    3 minute
    ${branchid}    ${endpoint_product_list_bybranch}    Get BranchID and Endpoint unit product list by BranchName    ${input_branch_name}
    ${jsonpath_giavon}    Format String    $..Data[?(@.Code=="{0}")].Cost    ${input_productcode}
    ${jsonpath_ton}    Format String    $..Data[?(@.Code=="{0}")].OnHand    ${input_productcode}
    ${resp_product_list_by_branch}       Get Request and return body       ${endpoint_product_list_bybranch}
    ${onhand}     Get data from response json    ${resp_product_list_by_branch}    ${jsonpath_ton}
    ${cost}    Get data from response json    ${resp_product_list_by_branch}    ${jsonpath_giavon}
    Return From Keyword    ${onhand}    ${cost}

Get Cost and OnHand of Unit frm API
    [Arguments]    ${input_mahang}
    [Timeout]    3 minute
    ${endpoint_pr}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${jsonpath_giavon}    Format String    $..Data[?(@.Code=="{0}")].Cost    ${input_mahang}
    ${jsonpath_ton}    Format String    $..Data[?(@.Code=="{0}")].OnHand    ${input_mahang}
    ${resp_product_list}       Get Request and return body    ${endpoint_pr}
    ${cost}    Get data from response json    ${resp_product_list}    ${jsonpath_giavon}
    ${onhand}    Get data from response json    ${resp_product_list}    ${jsonpath_ton}
    Return From Keyword    ${onhand}    ${cost}

Get BranchID and Endpoint unit product list by BranchName
    [Arguments]    ${input_branch_name}
    [Timeout]    3 minute
    ${jsonpath_product_id_byname}    Format String    $..Data[?(@.Name=="{0}")].Id    ${input_branch_name}
    ${get_branch_id}    Get data from API    ${endpoint_branch_list}    ${jsonpath_product_id_byname}
    ${endpoint_productlist_by_branch}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${get_branch_id}
    Return From Keyword    ${get_branch_id}    ${endpoint_productlist_by_branch}

Get DVQD by product code frm API
    [Arguments]    ${input_ma_sp}
    [Timeout]    2 minute
    ${endpoint_pr}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${jsonpath_dvqd}    Format String    $..Data[?(@.Code=="{0}")].ConversionValue    ${input_ma_sp}
    ${dvqd}    Get data from API    ${endpoint_pr}    ${jsonpath_dvqd}
    ${dvqd}    Convert To Number    ${dvqd}
    Return From Keyword    ${dvqd}

Get list DVQD by product code
    [Arguments]    ${input_ma_sp}
    [Timeout]    3 minute
    ${id_unit_coban}    Get product id thr API    ${input_ma_sp}
    ${endpoint_pr}    Format String    ${enpoint_unit_detail}    ${id_unit_coban}
    ${jsonpath_dvqd}    Format String    $..ProductUnits..Code
    ${list_dvqd}    Get raw data from API    ${endpoint_pr}    ${jsonpath_dvqd}
    Return From Keyword    ${list_dvqd}

Get list dvqd by list products
    [Arguments]    ${input_list_product_code}
    [Timeout]    2 minute
    ${list_dvqd_unit}    Create list
    ${endpoint_pr}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${resp1.bodyjson}    Get Request and return body    ${endpoint_pr}
    : FOR    ${item_product}    IN ZIP    ${input_list_product_code}
    \    ${jsonpath_dvqd}    Format String    $.Data[?(@.Code == "{0}")].ConversionValue    ${item_product}
    \    ${dvqd}    Get data from response json    ${resp1.bodyjson}    ${jsonpath_dvqd}
    \    Append to List    ${list_dvqd_unit}    ${dvqd}
    Return From Keyword     ${list_dvqd_unit}

Validate product history frm API
    [Arguments]    ${input_ma_hd}    ${input_ma_hh}    ${result_toncuoi}    ${result_soluongban}
    [Documentation]    1. Validate tồn kho, thẻ kho khi tạo hóa đơn từ đơn đặt hàng
    [Timeout]    3 minutes
    ${num_soluong_in_chungtu}    ${toncuoi_in_chungtu}    Get The kho Info frm API    ${input_ma_hd}    ${input_ma_hh}
    Should Be Equal As Numbers    ${num_soluong_in_chungtu}    ${result_soluongban}
    Should Be Equal As Numbers    ${toncuoi_in_chungtu}    ${result_toncuoi}

Validate unit product history frm API
    [Arguments]    ${input_ma_hd}    ${input_ma_hh}    ${result_toncuoi}    ${get_so_luong_in_hd}    ${get_giatri_quydoi_hh}
    [Timeout]    5 minutes
    ${get_ma_hh_cb}    Get basic product frm unit product    ${input_ma_hh}
    ${result_soluongban}    Multiplication for onhand    ${get_so_luong_in_hd}    ${get_giatri_quydoi_hh}
    ${num_soluong_in_chungtu}    ${toncuoi_in_chungtu}    Get The kho Info frm API    ${input_ma_hd}    ${get_ma_hh_cb}
    Should Be Equal As Numbers    ${num_soluong_in_chungtu}    ${result_soluongban}
    Should Be Equal As Numbers    ${toncuoi_in_chungtu}    ${result_toncuoi}

Validate onhand and cost frm API
    [Arguments]    ${input_ma_chungtu}    ${input_ma_hh}    ${result_toncuoi}    ${input_cost}    ${input_soluong_in_chungtu}
    [Documentation]    1. Validate tồn kho, giá vốn khi tạo hóa đơn từ đơn đặt hàng
    [Timeout]    5 minutes
    ${num_soluong_in_chungtu}    ${cost_in_chungtu}    ${toncuoi_in_chungtu}    Get Cost - onhand - quantity frm API after purchase    ${input_ma_chungtu}    ${input_ma_hh}
    Should Be Equal As Numbers    ${num_soluong_in_chungtu}    ${input_soluong_in_chungtu}
    Should Be Equal As Numbers    ${cost_in_chungtu}    ${input_cost}
    Should Be Equal As Numbers    ${toncuoi_in_chungtu}    ${result_toncuoi}

Validate onhand and cost frm unit product
    [Arguments]    ${input_ma_chungtu}    ${input_ma_hh}    ${result_toncuoi}    ${input_cost}    ${get_so_luong_in_hd}    ${get_giatri_quydoi_hh}
    [Timeout]    5 minutes
    ${get_ma_hh_cb}    Get basic product frm unit product    ${input_ma_hh}
    ${result_soluongban}    Multiplication for onhand    ${get_so_luong_in_hd}    ${get_giatri_quydoi_hh}
    ${num_soluong_in_chungtu}    ${cost_in_chungtu}    ${toncuoi_in_chungtu}    Get Cost - onhand - quantity frm API after purchase    ${input_ma_chungtu}    ${get_ma_hh_cb}
    Should Be Equal As Numbers    ${num_soluong_in_chungtu}    ${result_soluongban}
    Should Be Equal As Numbers    ${cost_in_chungtu}    ${input_cost}
    Should Be Equal As Numbers    ${toncuoi_in_chungtu}    ${result_toncuoi}

Get list product type and ending stock of service frm API
    [Arguments]    ${list_sp}
    [Timeout]    5 minute
    ${list_product_type}    Create List
    ${list_tonkho_service}    Create List
    ${endpoint_hh}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${get_resp}    Get Request and return body    ${endpoint_hh}
    : FOR    ${item_ma_hh}    IN    @{list_sp}
    \    ${jsonpath_id_hh}    Format String    $.Data[?(@.Code == '{0}')].Id    ${item_ma_hh}
    \    ${get_id_hh}    Get data from response json    ${get_resp}    ${jsonpath_id_hh}
    \    ${endpoint_thekho_in_product}    Format String    ${endpoint_thekho}    ${get_id_hh}    ${BRANCH_ID}
    \    ${jsonpath_productype}    Format String    $..Data[?(@.Code == '{0}')].ProductType    ${item_ma_hh}
    \    ${get_product_type}    Get data from response json    ${get_resp}    ${jsonpath_productype}
    \    ${get_endingstocks}    Get data from API    ${endpoint_thekho_in_product}    $.Data[0]..EndingStocks
    \    Append To List    ${list_product_type}    ${get_product_type}
    \    Append To List    ${list_tonkho_service}    ${get_endingstocks}
    Return From Keyword    ${list_product_type}    ${list_tonkho_service}

Get list product type and ending stock of service with other branch
    [Arguments]    ${list_sp}   ${input_ten_branch}
    [Timeout]    5 minute
    ${list_product_type}    Create List
    ${list_tonkho_service}    Create List
    ${get_branch_id}    Get BranchID by BranchName    ${input_ten_branch}
    ${endpoint_hh}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${get_branch_id}
    ${get_resp}    Get Request and return body    ${endpoint_hh}
    : FOR    ${item_ma_hh}    IN    @{list_sp}
    \    ${jsonpath_id_hh}    Format String    $.Data[?(@.Code == '{0}')].Id    ${item_ma_hh}
    \    ${get_id_hh}    Get data from response json    ${get_resp}    ${jsonpath_id_hh}
    \    ${endpoint_thekho_in_product}    Format String    ${endpoint_thekho}    ${get_id_hh}    ${get_branch_id}
    \    ${jsonpath_productype}    Format String    $..Data[?(@.Code == '{0}')].ProductType    ${item_ma_hh}
    \    ${get_product_type}    Get data from response json    ${get_resp}    ${jsonpath_productype}
    \    ${get_endingstocks}    Get data from API    ${endpoint_thekho_in_product}    $.Data[0]..EndingStocks
    \    Append To List    ${list_product_type}    ${get_product_type}
    \    Append To List    ${list_tonkho_service}    ${get_endingstocks}
    Return From Keyword    ${list_product_type}    ${list_tonkho_service}

Assert Onhand after execute
    [Arguments]    ${product_code}    ${invoice_code}    ${result_onhand}
    [Timeout]    5 minutes
    ${onhand}    ${baseprice}    Get Onhand and Baseprice frm API    ${product_code}
    Should Be Equal As Numbers    ${onhand}    ${result_onhand}

Get Baseprice-Imei-OnHand frm API
    [Arguments]    ${input_mahang}
    [Timeout]    3 minute
    ${endpoint_pr}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${jsonpath_baseprice}    Format String    $..Data[?(@.Code=="{0}")].BasePrice    ${input_mahang}
    ${jsonpath_onhand}    Format String    $..Data[?(@.Code=="{0}")].OnHand    ${input_mahang}
    ${jsonpath_productid}    Format String    $..Data[?(@.Code=="{0}")].ProductId    ${input_mahang}
    ${get_product_id}    Get data from API    ${endpoint_pr}    ${jsonpath_productid}
    ${endpoint_imei_tab_by_productid}    Format String    ${endpoint_imei_tab}    ${get_product_id}
    ${list_imei}    Get raw data from API    ${endpoint_imei_tab_by_productid}    $..SerialNumber
    ${baseprice}    Get data from API    ${endpoint_pr}    ${jsonpath_baseprice}
    ${onhand}    Get data from API    ${endpoint_pr}    ${jsonpath_onhand}
    Return From Keyword    ${baseprice}    ${onhand}    ${list_imei}

Get material product code and quantity lists of combo
    [Arguments]    ${input_combo_ui_code}
    [Timeout]    3 minute
    ${endpoint_danhmuc_hh_co_dvt}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${jsonpath_comboid}    Format String    $..Data[?(@.Code=="{0}")].Id    ${input_combo_ui_code}
    ${get_combo_id}    Get data from API    ${endpoint_danhmuc_hh_co_dvt}    ${jsonpath_comboid}
    ${endpoint_material_by_combo_id}    Format String    ${endpoint_material}    ${get_combo_id}
    ${resp.material}    Get Request and return body    ${endpoint_material_by_combo_id}
    ${list_material_product_code}    Get Value From Json    ${resp.material}    $.Data..MaterialCode
    ${list_material_quantity}    Get Value From Json    ${resp.material}    $.Data..Quantity
    Return From Keyword    ${list_material_product_code}    ${list_material_quantity}

Get list of Combo material product codes and actual sale quantity
    [Arguments]    ${input_combo_code}    ${input_combo_sale_quantity}
    [Timeout]    2 minute
    ${list_actual_sale_quantity}    Create list
    ${endpoint_danhmuc_hh_co_dvt}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${jsonpath_comboid}    Format String    $..Data[?(@.Code=="{0}")].Id    ${input_combo_code}
    ${get_combo_id}    Get data from API    ${endpoint_danhmuc_hh_co_dvt}    ${jsonpath_comboid}
    ${endpoint_material_by_combo_id}    Format String    ${endpoint_material}    ${get_combo_id}
    ${resp.material}    Get Request and return body    ${endpoint_material_by_combo_id}
    ${list_material_product_code}    Get Value From Json    ${resp.material}    $.Data..MaterialCode
    ${list_material_quantity}    Get Value From Json    ${resp.material}    $.Data..Quantity
    ${index}    Set Variable    -1
    : FOR    ${item_in_materiallist}    IN    @{list_material_quantity}
    \    ${index}    Evaluate    ${index} + 1
    \    ${item_quantity}    Get From List    ${list_material_quantity}    ${index}
    \    ${item_actualsale}    Multiplication    ${item_quantity}    ${input_combo_sale_quantity}
    \    Append to list    ${list_actual_sale_quantity}    ${item_actualsale}
    Return From Keyword    ${list_material_product_code}    ${list_actual_sale_quantity}

Assert Onhand before execute in List
    [Arguments]    ${list_product}    ${invoice_code}    ${list_result_onhand}
    [Timeout]    5 minutes
    : FOR    ${item_product}    ${item_result_onhand}    IN ZIP    ${list_product}    ${list_result_onhand}
    \    Assert Onhand after execute    ${item_product}    ${invoice_code}    ${item_result_onhand}

Assert list by list of Onhand after execute
    [Arguments]    ${list_product}    ${list_result_onhand}
    [Timeout]    5 minutes
    : FOR    ${item_list_product}    ${item_list_result_onhand}    IN ZIP    ${list_product}    ${list_result_onhand}
    \    Assert list of Onhand after execute    ${item_list_product}    ${item_list_result_onhand}

Assert values in Stock Card in List
    [Arguments]    ${ma_phieu}    ${list_product}    ${list_onhand}    ${list_num}
    [Timeout]    3 minute
    : FOR    ${item_pr}    ${item_onhand}    ${item_num}    IN ZIP    ${list_product}    ${list_onhand}
    ...    ${list_num}
    \    Assert values in Stock Card    ${ma_phieu}    ${item_pr}    ${item_onhand}    ${item_num}

Assert values in Stock Card incase service product
    [Arguments]    ${ma_phieu}    ${ma_hh}    ${input_num}
    [Timeout]    3 minute
    ${soluong_in_thekho}    ${toncuoi_in_thekho}    Get Stock Card info frm API    ${ma_phieu}    ${ma_hh}
    Should Be Equal As Numbers    ${soluong_in_thekho}    ${input_num}

Get The kho info with unit product
    [Arguments]    ${input_ma_hh_unit}    ${input_sochungtu}
    [Timeout]    5 minutes
    ${endpoint_danhmuc_hh_co_dvt}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${jsonpath_id_hh_cb}    Format String    $..Data[?(@.Code == '{0}')].MasterProductId    ${input_ma_hh_unit}
    ${get_id_hh_cb}    Get data from API    ${endpoint_danhmuc_hh_co_dvt}    ${jsonpath_id_hh_cb}
    ${endpoint_thekho_in_product}    Format String    ${endpoint_thekho}    ${get_id_hh_cb}    ${BRANCH_ID}
    ${jsonpath_soluong_in_chungtu}    Format String    $..Data[?(@.DocumentCode=="{0}")].Quantity    ${input_sochungtu}    #mã hóa đơn, kiểm kho, nhập hàng...
    ${soluong_in_chungtu}    Get data from API    ${endpoint_thekho_in_product}    ${jsonpath_soluong_in_chungtu}
    ${soluong_in_chungtu}    Convert To String    ${soluong_in_chungtu}
    ${string_soluong_in_chungtu}    Replace String    ${soluong_in_chungtu}    -    ${EMPTY}
    ${num_soluong_in_chungtu}    Convert To Number    ${string_soluong_in_chungtu}
    ${jsonpath_toncuoi_in_chungtu}    Format String    $..Data[?(@.DocumentCode=="{0}")].EndingStocks    ${input_sochungtu}
    ${toncuoi_in_chungtu}    Get data from API    ${endpoint_thekho_in_product}    ${jsonpath_toncuoi_in_chungtu}
    ${toncuoi_in_chungtu}    Convert to Number    ${toncuoi_in_chungtu}
    Return From Keyword    ${num_soluong_in_chungtu}    ${toncuoi_in_chungtu}

Get basic product frm unit product
    [Arguments]    ${input_ma_hh_unit}
    [Timeout]    5 minutes
    ${endpoint_danhmuc_hh_co_dvt}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${get_resp}    Get Request and return body    ${endpoint_danhmuc_hh_co_dvt}
    ${jsonpath_id_hh_cb}    Format String    $..Data[?(@.Code == '{0}')].MasterUnitId    ${input_ma_hh_unit}
    ${get_id_hh_cb}    Get data from response json    ${get_resp}    ${jsonpath_id_hh_cb}
    ${jsonpath_ma_hh_cb}    Format String    $..Data[?(@.Id == {0})].Code    ${get_id_hh_cb}
    ${get_ma_hh_cb}    Get data from response json    ${get_resp}    ${jsonpath_ma_hh_cb}
    Return From Keyword    ${get_ma_hh_cb}

Get list of master products and its quantity from unit product list
    [Arguments]    ${input_unit_product_list}    ${input_unit_product_quan_list}
    [Timeout]    5 minutes
    ${list_master_product}    Create list
    ${list_master_product_quan}    Create list
    ${endpoint_danhmuc_hh_co_dvt}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${get_resp}    Get Request and return body    ${endpoint_danhmuc_hh_co_dvt}
    : FOR    ${item_unit_product}    ${item_unit_quan}    IN ZIP    ${input_unit_product_list}    ${input_unit_product_quan_list}
    \    ${jsonpath_id_hh_cb}    Format String    $..Data[?(@.Code == '{0}')].MasterUnitId    ${item_unit_product}
    \    ${get_id_hh_cb}    Get data from response json    ${get_resp}    ${jsonpath_id_hh_cb}
    \    ${jsonpath_ma_hh_cb}    Format String    $..Data[?(@.Id == {0})].Code    ${get_id_hh_cb}
    \    ${jsonpath_dvqd}    Format String    $.Data[?(@.Code == "{0}")].ConversionValue    ${item_unit_product}
    \    ${conversion_value}    Get data from response json    ${get_resp}    ${jsonpath_dvqd}
    \    ${get_ma_hh_cb}    Get data from response json    ${get_resp}    ${jsonpath_ma_hh_cb}
    \    ${item_master_quan}    Multiplication    ${item_unit_quan}    ${conversion_value}
    \    Append to list    ${list_master_product}    ${get_ma_hh_cb}
    \    Append to list    ${list_master_product_quan}    ${item_master_quan}
    Return From Keyword    ${list_master_product}    ${list_master_product_quan}

Get list master product and its quantity from unit product
    [Arguments]    ${input_unit_product}    ${input_unit_product_quan}
    [Timeout]    5 minutes
    ${endpoint_danhmuc_hh_co_dvt}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${get_resp}    Get Request and return body    ${endpoint_danhmuc_hh_co_dvt}
    ${jsonpath_id_hh_cb}    Format String    $..Data[?(@.Code == '{0}')].MasterUnitId    ${input_unit_product}
    ${get_id_hh_cb}    Get data from response json    ${get_resp}    ${jsonpath_id_hh_cb}
    ${jsonpath_ma_hh_cb}    Format String    $..Data[?(@.Id == {0})].Code    ${get_id_hh_cb}
    ${jsonpath_dvqd}    Format String    $.Data[?(@.Code == "{0}")].ConversionValue    ${input_unit_product}
    ${conversion_value}    Get data from response json    ${get_resp}    ${jsonpath_dvqd}
    ${get_ma_hh_cb}    Get data from response json    ${get_resp}    ${jsonpath_ma_hh_cb}
    ${item_master_quan}    Multiplication    ${input_unit_product_quan}    ${conversion_value}
    Return From Keyword    ${get_ma_hh_cb}    ${item_master_quan}

Get list jsonpath product frm list product
    [Arguments]    ${list_product}
    [Timeout]    3 minutes
    ${list_jsonpath_id_sp}    Create List
    ${list_jsonpath_giaban}    Create List
    : FOR    ${ma_hh}    IN    @{list_product}
    \    ${jsonpath_id_sp}    Format String    $..Data[?(@.Code == '{0}')].Id    ${ma_hh}
    \    ${jsonpath_gia_ban}    Format String    $..Data[?(@.Code == '{0}')].BasePrice    ${ma_hh}
    \    Append To List    ${list_jsonpath_id_sp}    ${jsonpath_id_sp}
    \    Append To List    ${list_jsonpath_giaban}    ${jsonpath_gia_ban}
    Return From Keyword    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}

Get product info frm list jsonpath product have discount product
    [Arguments]    ${get_resp_product}    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}    ${list_ggsp}
    [Timeout]    3 minutes
    ${list_id_sp}    Create List
    ${list_result_ggsp}    Create List
    ${list_giaban}    Create List
    : FOR    ${jsonpath_id_sp}    ${jsonpath_giaban}    ${giamgia_sp}    IN ZIP    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}
    ...    ${list_ggsp}
    \    ${get_id_sp}    Get data from response json    ${get_resp_product}    ${jsonpath_id_sp}
    \    ${get_gia_ban}    Get data from response json    ${get_resp_product}    ${jsonpath_giaban}
    \    ${result_ggsp}    Run Keyword If    0 < ${giamgia_sp} < 100    Convert % discount to VND    ${get_gia_ban}    ${giamgia_sp}
    \    ...    ELSE    Set Variable    ${giamgia_sp}
    \    Append To List    ${list_giaban}    ${get_gia_ban}
    \    Append To List    ${list_result_ggsp}    ${result_ggsp}
    \    Append To List    ${list_id_sp}    ${get_id_sp}
    Return From Keyword    ${list_giaban}    ${list_result_ggsp}    ${list_id_sp}

Get product info frm list jsonpath product
    [Arguments]    ${get_resp_product}    ${list_jsonpath_id_sp}    ${list_jsonpath_gia_ban}
    [Timeout]    20 minutes
    ${list_giaban}    Create List
    ${list_id_sp}    Create List
    : FOR    ${jsonpath_id_sp}    ${jsonpath_gia_ban}    IN ZIP    ${list_jsonpath_id_sp}    ${list_jsonpath_gia_ban}
    \    ${get_id_sp}    Get data from response json    ${get_resp_product}    ${jsonpath_id_sp}
    \    ${get_gia_ban}    Get data from response json    ${get_resp_product}    ${jsonpath_gia_ban}
    \    Append To List    ${list_giaban}    ${get_gia_ban}
    \    Append To List    ${list_id_sp}    ${get_id_sp}
    Return From Keyword    ${list_giaban}    ${list_id_sp}

Get product info and new price frm list product
    [Arguments]    ${get_resp_product}    ${list_jsonpath_id_sp}    ${list_jsonpath_gia_ban}    ${list_giamoi}
    [Timeout]    5 minutes
    ${list_giaban}    Create List
    ${list_result_ggsp}    Create List
    ${list_id_sp}    Create List
    : FOR    ${jsonpath_id_sp}    ${jsonpath_gia_ban}    ${input_giamoi}    IN ZIP    ${list_jsonpath_id_sp}    ${list_jsonpath_gia_ban}
    ...    ${list_giamoi}
    \    ${get_id_sp}    Get data from response json    ${get_resp_product}    ${jsonpath_id_sp}
    \    ${get_gia_ban}    Get data from response json    ${get_resp_product}    ${jsonpath_gia_ban}
    \    ${result_ggsp}    Minus and round 2    ${get_gia_ban}    ${input_giamoi}
    \    Append To List    ${list_giaban}    ${get_gia_ban}
    \    Append To List    ${list_result_ggsp}    ${result_ggsp}
    \    Append To List    ${list_id_sp}    ${get_id_sp}
    Return From Keyword    ${list_giaban}    ${list_result_ggsp}    ${list_id_sp}

Get product name and price frm API
    [Arguments]    ${input_mahang}
    [Timeout]    3 minutes
    ${endpoint_danhmuc_hh_co_dvt}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${get_resp_danhmuc_hh}    Get Request and return body    ${endpoint_danhmuc_hh_co_dvt}
    ${jsonpath_productname}    Format String    $..Data[?(@.Code=="{0}")].FullName    ${input_mahang}
    ${jsonpath_baseprice}    Format String    $..Data[?(@.Code=="{0}")].BasePrice    ${input_mahang}
    ${productname}    Get data from response json    ${get_resp_danhmuc_hh}    ${jsonpath_productname}
    ${baseprice}    Get data from response json    ${get_resp_danhmuc_hh}    ${jsonpath_baseprice}
    Return From Keyword    ${productname}    ${baseprice}

Get product name and price frm unit product API
    [Arguments]    ${input_ma_sp}    ${unit_name}
    [Timeout]    5 minutes
    ${endpoint_pr}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${get_resp_danhmuc_hh}    Get Request and return body    ${endpoint_pr}
    ${mahang_unit}    Get code unit frm API    ${input_ma_sp}    ${unit_name}
    ${jsonpath_ten_hh_unit_bf}    Format String    $..Data[?(@.Code=="{0}")].FullName    ${mahang_unit}
    ${ten_hh_unit_bf}    Get data from response json    ${get_resp_danhmuc_hh}    ${jsonpath_ten_hh_unit_bf}
    ${ten_hh_unit}    Convert To String    ${ten_hh_unit_bf}
    ${jsonpath_baseprice}    Format String    $..Data[?(@.Code=="{0}")].BasePrice    ${mahang_unit}
    ${giaban_hh_unit}    Get data from response json    ${get_resp_danhmuc_hh}    ${jsonpath_baseprice}
    Return From Keyword    ${ten_hh_unit}    ${giaban_hh_unit}

Assert imei avaiable in Invoice
    [Arguments]    ${input_ma_hd}    ${input_mahang}    ${list_counted_imei}
    [Timeout]    3 minute
    ${get_list_serialnumber}    Get serial number in invoice details    ${input_ma_hd}    ${input_mahang}
    ${get_list_serialnumber}    Convert String to List    ${get_list_serialnumber}
    List Should Contain Sub List    ${get_list_serialnumber}    ${list_counted_imei}

Get weight - price - onhand frm product API
    [Arguments]    ${input_mahang}
    [Timeout]    5 minutes
    ${endpoint_danhmuc_hh_co_dvt}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${jsonpath_trongluong}    Format String    $..Data[?(@.Code=="{0}")].Weight    ${input_mahang}
    ${jsonpath_baseprice}    Format String    $..Data[?(@.Code=="{0}")].BasePrice    ${input_mahang}
    ${jsonpath_ton}    Format String    $..Data[?(@.Code=="{0}")].OnHand    ${input_mahang}
    ${ton}    Get data from API    ${endpoint_danhmuc_hh_co_dvt}    ${jsonpath_ton}
    ${ton}    Convert To Number    ${ton}
    ${ton}    Evaluate    round(${ton}, 3)
    ${trongluong_hh}    Get data from API    ${endpoint_danhmuc_hh_co_dvt}    ${jsonpath_trongluong}
    ${baseprice}    Get data from API    ${endpoint_danhmuc_hh_co_dvt}    ${jsonpath_baseprice}
    Return From Keyword    ${trongluong_hh}    ${baseprice}    ${ton}

Get list order summary frm product API
    [Arguments]    ${list_hanghoa}
    [Timeout]    5 minutes
    ${endpoint_danhmuc_hh_co_dvt}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${get_resp}    Get Request and return body    ${endpoint_danhmuc_hh_co_dvt}
    ${list_tong_dh}    Create List
    : FOR    ${input_mahang}    IN    @{list_hanghoa}
    \    ${jsonpath_tong_dh}    Format String    $..Data[?(@.Code=="{0}")].Reserved    ${input_mahang}
    \    ${get_tong_dh_string}    Get data from response json    ${get_resp}    ${jsonpath_tong_dh}
    \    ${get_ordersummary}    Convert To Number    ${get_tong_dh_string}
    \    Append To List    ${list_tong_dh}    ${get_ordersummary}
    Return From Keyword    ${list_tong_dh}

Get order summary frm product API
    [Arguments]    ${input_mahang}
    [Timeout]    3 minutes
    ${endpoint_danhmuc_hh_co_dvt}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${jsonpath_tong_dh}    Format String    $..Data[?(@.Code=="{0}")].Reserved    ${input_mahang}
    ${get_tong_dh_string}    Get data from API    ${endpoint_danhmuc_hh_co_dvt}    ${jsonpath_tong_dh}
    ${get_ordersummary}    Convert To Number    ${get_tong_dh_string}
    Return From Keyword    ${get_ordersummary}

Get list result order summary frm product API
    [Arguments]    ${list_hanghoa}    ${list_nums}
    [Timeout]    3 minutes
    ${endpoint_danhmuc_hh_co_dvt}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${get_resp}    Get Request and return body    ${endpoint_danhmuc_hh_co_dvt}
    ${list_tong_dh}    Create List
    : FOR    ${input_mahang}    ${input_soluong}    IN ZIP    ${list_hanghoa}    ${list_nums}
    \    ${jsonpath_tong_dh}    Format String    $..Data[?(@.Code=="{0}")].Reserved    ${input_mahang}
    \    ${get_tong_dh}    Get data from response json    ${get_resp}    ${jsonpath_tong_dh}
    \    ${result_tong_dh}    Sum    ${get_tong_dh}    ${input_soluong}
    \    Append To List    ${list_tong_dh}    ${result_tong_dh}
    Return From Keyword    ${list_tong_dh}

Get list order summary incase delete product
    [Arguments]    ${input_ma_dh}    ${list_hanghoa}
    [Timeout]    5 minutes
    ${endpoint_danhmuc_hh_co_dvt}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${get_resp}    Get Request and return body    ${endpoint_danhmuc_hh_co_dvt}
    ${list_soluong_in_hd}    Get list quantity by order code    ${input_ma_dh}    ${list_hanghoa}
    ${list_tong_dh}    Create List
    : FOR    ${input_mahang}    ${item_soluong}    IN ZIP    ${list_hanghoa}    ${list_soluong_in_hd}
    \    ${jsonpath_tong_dh}    Format String    $..Data[?(@.Code=="{0}")].Reserved    ${input_mahang}
    \    ${get_tong_dh}    Get data from response json    ${get_resp}    ${jsonpath_tong_dh}
    \    ${result_tong_dh}    Minus    ${get_tong_dh}    ${item_soluong}
    \    Append To List    ${list_tong_dh}    ${result_tong_dh}
    Return From Keyword    ${list_tong_dh}

Computation price incase discount by product code
    [Arguments]    ${input_mahang}    ${input_ggsp}
    [Timeout]    5 minutes
    ${endpoint_pr}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${jsonpath_giaban}    Format String    $..Data[?(@.Code=="{0}")].BasePrice    ${input_mahang}
    ${giaban}    Get data from API    ${endpoint_pr}    ${jsonpath_giaban}
    ${newprice}    Run Keyword If    0 < ${input_ggsp} < 100    Price after % discount product    ${giaban}    ${input_ggsp}
    ...    ELSE    Minus and round 2    ${giaban}    ${input_ggsp}
    Return From Keyword    ${newprice}

Get list onhand frm API
    [Arguments]    ${list_product}
    [Timeout]    3 minutes
    ${endpoint_pr}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${get_resp}    Get Request and return body    ${endpoint_pr}
    ${list_onhand}    Create List
    : FOR    ${input_mahang}    IN    @{list_product}
    \    ${jsonpath_ton}    Format String    $..Data[?(@.Code=="{0}")].OnHand    ${input_mahang}
    \    ${ton}    Get data from response json    ${get_resp}    ${jsonpath_ton}
    \    ${ton}    Convert To Number    ${ton}
    \    ${ton}    Evaluate    round(${ton}, 3)
    \    Append to list    ${list_onhand}    ${ton}
    Return From Keyword    ${list_onhand}

Get list onhand with other branch
    [Arguments]    ${list_product}    ${input_ten_branch}
    [Timeout]    3 minutes
    ${get_branch_id}   Get BranchID by BranchName     ${input_ten_branch}
    ${endpoint_pr}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${get_branch_id}
    ${get_resp}    Get Request and return body    ${endpoint_pr}
    ${list_onhand}    Create List
    : FOR    ${input_mahang}    IN    @{list_product}
    \    ${jsonpath_ton}    Format String    $..Data[?(@.Code=="{0}")].OnHand    ${input_mahang}
    \    ${ton}    Get data from response json    ${get_resp}    ${jsonpath_ton}
    \    ${ton}    Convert To Number    ${ton}
    \    ${ton}    Evaluate    round(${ton}, 3)
    \    Append to list    ${list_onhand}    ${ton}
    Return From Keyword    ${list_onhand}

Get onhand frm API
    [Arguments]    ${input_mahang}
    [Timeout]    3 minutes
    ${endpoint_pr}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${get_resp}    Get Request and return body    ${endpoint_pr}
    ${jsonpath_ton}    Format String    $..Data[?(@.Code=="{0}")].OnHand    ${input_mahang}
    ${ton}    Get data from response json    ${get_resp}    ${jsonpath_ton}
    ${ton}    Convert To Number    ${ton}
    ${ton}    Evaluate    round(${ton}, 3)
    Return From Keyword    ${ton}

Get unit onhand frm API
    [Arguments]    ${input_mahang}
    ${get_ma_hh_cb}    Get basic product frm unit product    ${input_mahang}
    ${endpoint_pr}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${get_resp}    Get Request and return body    ${endpoint_pr}
    ${jsonpath_ton}    Format String    $..Data[?(@.Code=="{0}")].OnHand    ${get_ma_hh_cb}
    ${ton}    Get data from response json    ${get_resp}    ${jsonpath_ton}
    ${ton}    Convert To Number    ${ton}
    ${ton}    Evaluate    round(${ton}, 3)
    Return From Keyword    ${ton}

Get list gia tri quy doi frm product API
    [Arguments]    ${list_product}
    [Timeout]    3 minutes
    ${endpoint_pr}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${get_resp}    Get Request and return body    ${endpoint_pr}
    ${list_giatri_quydoi}    Create List
    : FOR    ${item_product}    IN    @{list_product}
    \    ${jsonpath_giatri_quydoi}    Format String    $.Data[?(@.Code == "{0}")].ConversionValue    ${item_product}
    \    ${get_giatri_quydoi_in_hd}    Get data from response json    ${get_resp}    ${jsonpath_giatri_quydoi}
    \    Append To List    ${list_giatri_quydoi}    ${get_giatri_quydoi_in_hd}
    Return From Keyword    ${list_giatri_quydoi}

Get list of Onhand and Base price - Conversation values by searching product API
    [Arguments]    ${input_list_product_code}
    [Timeout]    3 minute
    ${list_baseprice_unit}    Create List
    ${list_onhand_unit}    Create list
    ${list_dvqd_unit}    Create list
    ${endpoint_pr}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${resp1bodyjson}    Get Request and return body    ${endpoint_pr}
    : FOR    ${item_product}    IN ZIP    ${input_list_product_code}
    \    ${jsonpath_giaban}    Format String    $.Data[?(@.Code == "{0}")].BasePrice    ${item_product}
    \    ${jsonpath_tonkho}    Format String    $.Data[?(@.Code == "{0}")].OnHand    ${item_product}
    \    ${jsonpath_dvqd}    Format String    $.Data[?(@.Code == "{0}")].ConversionValue    ${item_product}
    \    ${giaban}    Get data from response json    ${resp1bodyjson}    ${jsonpath_giaban}
    \    ${ton}    Get data from response json    ${resp1bodyjson}    ${jsonpath_tonkho}
    \    ${dvqd}    Get data from response json    ${resp1bodyjson}    ${jsonpath_dvqd}
    \    Append to List    ${list_baseprice_unit}    ${giaban}
    \    Append to List    ${list_onhand_unit}    ${ton}
    \    Append to List    ${list_dvqd_unit}    ${dvqd}
    Return From Keyword    ${list_baseprice_unit}    ${list_onhand_unit}    ${list_dvqd_unit}

Get Stock Card Lot in tab Lo - HSD frm API
    [Arguments]    ${input_sochungtu}    ${input_actual_product}    ${input_product}    ${item_tenlo}
    [Timeout]    5 minutes
    ${endpoint_pr}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${jsonpath_id_sp_actual}    Format String    $..Data[?(@.Code=="{0}")].Id    ${input_actual_product}
    ${jsonpath_id_sp}    Format String    $..Data[?(@.Code=="{0}")].Id    ${input_product}
    ${resp_pr}    Get Request and return body    ${endpoint_pr}
    ${get_id_sp_actual}    Get data from response json    ${resp_pr}    ${jsonpath_id_sp_actual}
    ${get_id_sp}    Get data from response json    ${resp_pr}    ${jsonpath_id_sp}
    ${jsonpath_dvqd}    Format String    $.Data[?(@.Code == "{0}")].ConversionValue    ${input_actual_product}
    ${get_dvqd}    Get data from response json    ${resp_pr}    ${jsonpath_dvqd}
    #get id batchexpire
    ${item_tenlo}    Convert To String    ${item_tenlo}
    ${item_tenlo}    Replace sq blackets    ${item_tenlo}
    ${jsonpath_batchlname}    Format String    $..Data[?(@.BatchName=="{0}")].Id    ${item_tenlo}
    ${endpoin_lodate}    Format String    ${endpoint_batchexpire_dvt}    ${get_id_sp}    ${get_dvqd}
    ${lodate_id}    Get data from API    ${endpoin_lodate}    ${jsonpath_batchlname}
    log    ${lodate_id}
    #
    ${endpoint_thekho_lo}    Format String    ${endpoint_thekho_lo_dvt}    ${get_id_sp}    ${lodate_id}    ${get_dvqd}
    ${resp.stockcard}    Get Request and return body    ${endpoint_thekho_lo}
    ${jsonpath_soluong_in_chungtu}    Format String    $..Data[?(@.DocumentCode=="{0}")].Quantity    ${input_sochungtu}
    ${jsonpath_toncuoi_in_chungtu}    Format String    $..Data[?(@.DocumentCode=="{0}")].EndingStocks    ${input_sochungtu}
    ${num_soluong_in_chungtu}    Get data from response json    ${resp.stockcard}    ${jsonpath_soluong_in_chungtu}
    ${toncuoi_in_chungtu}    Get data from response json    ${resp.stockcard}    ${jsonpath_toncuoi_in_chungtu}
    ${num_soluong_in_chungtu}    Convert To Number    ${num_soluong_in_chungtu}
    ${toncuoi_in_chungtu}    Convert to Number    ${toncuoi_in_chungtu}
    Return From Keyword    ${num_soluong_in_chungtu}    ${toncuoi_in_chungtu}

Get Onhand Lot by unit in tab Lo - HSD frm API
    [Arguments]    ${input_actual_product}    ${input_tenlo}    ${input_product}
    [Documentation]    get tồn kho của lô theo dvt ở tab Lô - HSD
    [Timeout]    5 minutes
    ${endpoint_pr}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${jsonpath_id_sp}    Format String    $..Data[?(@.Code=="{0}")].Id    ${input_product}
    ${resp_pr}    Get Request and return body    ${endpoint_pr}
    ${get_id_sp}    Get data from response json    ${resp_pr}    ${jsonpath_id_sp}
    ${jsonpath_dvqd}    Format String    $.Data[?(@.Code == "{0}")].ConversionValue    ${input_actual_product}
    ${get_dvqd}    Get data from response json    ${resp_pr}    ${jsonpath_dvqd}
    ${enpoint_batchexpire}    Format String    ${endpoint_batchexpire_dvt}    ${get_id_sp}    ${get_dvqd}
    ${input_tenlo}    Convert To String    ${input_tenlo}
    ${input_tenlo}    Replace sq blackets    ${input_tenlo}
    ${jsonpath_onhand_lo}    Format String    $..Data[?(@.BatchName=="{0}")].OnHand    ${input_tenlo}
    ${get_ton_lo}    Get data from API    ${enpoint_batchexpire}    ${jsonpath_onhand_lo}
    ${get_ton_lo}    Convert To Number    ${get_ton_lo}
    ${get_ton_lo}    Evaluate    round(${get_ton_lo}, 3)
    Return From Keyword    ${get_ton_lo}

Get Onhand Lot in tab Lo - HSD frm API
    [Arguments]    ${input_product}    ${input_tenlo}
    [Documentation]    get tồn kho lô ở tab Lô - HSD
    [Timeout]    5 minutes
    ${endpoint_pr}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${jsonpath_id_sp_actual}    Format String    $..Data[?(@.Code=="{0}")].Id    ${input_product}
    ${jsonpath_id_sp}    Format String    $..Data[?(@.Code=="{0}")].Id    ${input_product}
    ${get_id_sp}    Get data from API    ${endpoint_pr}    ${jsonpath_id_sp}
    ${enpoint_batchexpire}    Format String    ${endpoint_batchexpire_dvt}    ${get_id_sp}    1
    ${input_tenlo}    Convert To String    ${input_tenlo}
    ${input_tenlo}    Replace sq blackets    ${input_tenlo}
    ${jsonpath_onhand_lo}    Format String    $..Data[?(@.BatchName=="{0}")].OnHand    ${input_tenlo}
    ${get_ton_lo}    Get data from API    ${enpoint_batchexpire}    ${jsonpath_onhand_lo}
    ${get_ton_lo}    Convert To Number    ${get_ton_lo}
    ${get_ton_lo}    Evaluate    round(${get_ton_lo}, 3)
    Return From Keyword    ${get_ton_lo}

Assert values in Stock Card in tab Lo - HSD
    [Arguments]    ${ma_phieu}    ${input_actual_product}    ${input_product}    ${input_toncuoi}    ${input_num}    ${tenlo}
    [Documentation]    So sánh giá trị trong thẻ kho tab Lô - HSD
    [Timeout]    5 minutes
    ${soluong_in_thekho}    ${toncuoi_in_thekho}    Get Stock Card Lot in tab Lo - HSD frm API    ${ma_phieu}    ${input_actual_product}    ${input_product}    ${tenlo}
    Should Be Equal As Numbers    ${toncuoi_in_thekho}    ${input_toncuoi}
    Should Be Equal As Numbers    ${soluong_in_thekho}    ${input_num}

Get list of Onhand, LatestPurchasePrice and Cost frm API
    [Arguments]    ${list_product_code}
    [Timeout]    5 minute
    ${list_onhand}    Create List
    ${list_latestprice}    Create List
    ${list_cost}    Create List
    ${endpoint_pr}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${resp1.bodyjson}    Get Request and return body    ${endpoint_pr}
    : FOR    ${item_product}    IN ZIP    ${list_product_code}
    \    ${jsonpath_ton}    Format String    $..Data[?(@.Code=="{0}")].OnHand    ${item_product}
    \    ${jsonpath_gianhapcuoi}    Format String    $..Data[?(@.Code=="{0}")].LatestPurchasePrice    ${item_product}
    \    ${jsonpath_giavon}    Format String    $..Data[?(@.Code=="{0}")].Cost    ${item_product}
    \    ${ton}    Get data from response json    ${resp1.bodyjson}    ${jsonpath_ton}
    \    ${ton}    Convert To Number    ${ton}
    \    ${ton}    Evaluate    round(${ton}, 3)
    \    ${gianhapcuoi}    Get data from response json    ${resp1.bodyjson}    ${jsonpath_gianhapcuoi}
    \    ${giavon}    Get data from response json    ${resp1.bodyjson}    ${jsonpath_giavon}
    \    Append to list    ${list_onhand}    ${ton}
    \    Append to list    ${list_latestprice}    ${gianhapcuoi}
    \    Append to list    ${list_cost}    ${giavon}
    Return From Keyword    ${list_onhand}    ${list_latestprice}    ${list_cost}

Get list of Onhand, LastestPurchasePrice and Cost - Conversation values by searching product API
    [Arguments]    ${input_list_product_code}
    [Timeout]    5 minute
    ${list_onhand}    Create List
    ${list_latestprice}    Create List
    ${list_cost}    Create List
    ${list_dvqd_unit}    Create list
    ${endpoint_pr}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${resp1.bodyjson}    Get Request and return body    ${endpoint_pr}
    : FOR    ${item_product}    IN ZIP    ${input_list_product_code}
    \    ${jsonpath_ton}    Format String    $..Data[?(@.Code=="{0}")].OnHand    ${item_product}
    \    ${jsonpath_gianhapcuoi}    Format String    $..Data[?(@.Code=="{0}")].LatestPurchasePrice    ${item_product}
    \    ${jsonpath_giavon}    Format String    $..Data[?(@.Code=="{0}")].Cost    ${item_product}
    \    ${jsonpath_dvqd}    Format String    $.Data[?(@.Code == "{0}")].ConversionValue    ${item_product}
    \    ${ton}    Get data from response json    ${resp1.bodyjson}    ${jsonpath_ton}
    \    ${ton}    Convert To Number    ${ton}
    \    ${ton}    Evaluate    round(${ton}, 3)
    \    ${gianhapcuoi}    Get data from response json    ${resp1.bodyjson}    ${jsonpath_gianhapcuoi}
    \    ${giavon}    Get data from response json    ${resp1.bodyjson}    ${jsonpath_giavon}
    \    ${dvqd}    Get data from response json    ${resp1.bodyjson}    ${jsonpath_dvqd}
    \    Append to list    ${list_onhand}    ${ton}
    \    Append to list    ${list_latestprice}    ${gianhapcuoi}
    \    Append to list    ${list_cost}    ${giavon}
    \    Append to List    ${list_dvqd_unit}    ${dvqd}
    Return From Keyword    ${list_onhand}    ${list_latestprice}    ${list_cost}    ${list_dvqd_unit}

Assert list of onhand, cost, latestpurchaseprice af execute
    [Arguments]    ${list_prs}    ${list_result_onhand}    ${list_result_cost}    ${list_result_latestprice}
    [Timeout]    5 minutes
    ${get_list_onhand_af}    ${get_list_latestprice_af}    ${get_list_cost_af}    Get list of Onhand, LatestPurchasePrice and Cost frm API    ${list_prs}
    : FOR    ${item_pr}    ${item_result_onhand}    ${item_result_cost}    ${item_result_latestprice}    ${item_onhand_af}    ${item_cost_af}
    ...    ${item_latestprice_af}    IN ZIP    ${list_prs}    ${list_result_onhand}    ${list_result_cost}    ${list_result_latestprice}
    ...    ${get_list_onhand_af}    ${get_list_cost_af}    ${get_list_latestprice_af}
    \    Should Be Equal As Numbers    ${item_result_onhand}    ${item_onhand_af}
    \    Should Be Equal As Numbers    ${item_result_latestprice}    ${item_latestprice_af}
    \    ${chenh_lech}        Minus    ${item_cost_af}     ${item_result_cost}
    \    ${chenh_lech}      Evaluate    abs(${chenh_lech})
    \    Run Keyword If    ${chenh_lech}>0.15    Fail    Lệch giá vốn hàng ${item_pr}

Assert list of onhand, cost af execute
    [Arguments]    ${list_prs}    ${list_result_onhand}    ${list_result_cost}
    ${list_result_cost_af_ex}    ${list_result_onhand_af_ex}    Get list cost - onhand frm API    ${list_prs}
    : FOR    ${item_pr}   ${item_result_cost}    ${item_cost_af}    ${item_result_onhand}    ${item_onhand_af}    IN ZIP   ${list_prs}     ${list_result_cost}
    ...    ${list_result_cost_af_ex}    ${list_result_onhand}    ${list_result_onhand_af_ex}
    \    ${lech_ton_kho}    Minus   ${item_result_onhand}    ${item_onhand_af}
    \    Run Keyword If    ${lech_ton_kho}!=0    Fail    Lệch tồn kho hàng ${item_pr}
    \    ${chenh_lech_gv}        Minus    ${item_cost_af}     ${item_result_cost}
    \    ${chenh_lech_gv}      Evaluate    abs(${chenh_lech_gv})
    \    Run Keyword If    ${chenh_lech_gv}>0.15    Fail    Lệch giá vốn hàng ${item_pr}

Assert list on order af execute
    [Arguments]    ${list_prs}    ${list_on_order}
    ${get_list_actual_on_order_af}    Get list on order frm API    ${list_prs}
    : FOR    ${item_pr}   ${item_on_order}    ${item_actual_on_order}    IN ZIP    ${list_prs}    ${list_on_order}    ${get_list_actual_on_order_af}
    \    ${chenh_lech_on_order}     Minus       ${item_on_order}    ${item_actual_on_order}
    \    Run Keyword If    ${chenh_lech_on_order}!=0    Fail    Lệch số lượng đặt hàng nhập hàng ${item_pr}

Assert lodate is not avaiable in tab Lo - HSD
    [Arguments]    ${input_product}    @{list_tenlo_ex}
    [Timeout]    3 minutes
    ${endpoint_pr}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${jsonpath_id_sp}    Format String    $..Data[?(@.Code=="{0}")].Id    ${input_product}
    ${get_id_sp}    Get data from API    ${endpoint_pr}    ${jsonpath_id_sp}
    ${endpoint_lodate}    Format String    ${endpoint_batchexpire_dvt}    ${get_id_sp}    1
    ${list_tenlo}    Get raw data from API    ${endpoint_lodate}    $..BatchName
    : FOR    ${item_tenlo_ex}    IN    @{list_tenlo_ex}
    \    List Should Not Contain Value    ${list_tenlo}    ${item_tenlo_ex}

Get lot onhand frm API by Branch Name
    [Arguments]    ${branch_name}    ${input_product}    ${input_tenlo}
    [Timeout]    3 minutes
    ${get_branch_id}    ${endpoint_productlist_by_branch}    Get BranchID and Endpoint Product list by BranchName    ${branch_name}
    ${endpoint_pr}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${get_branch_id}
    ${jsonpath_id_sp_actual}    Format String    $..Data[?(@.Code=="{0}")].Id    ${input_product}
    ${jsonpath_id_sp}    Format String    $..Data[?(@.Code=="{0}")].Id    ${input_product}
    ${get_id_sp}    Get data from API    ${endpoint_pr}    ${jsonpath_id_sp}
    ${enpoint_batchexpire}    Format String    ${endpoint_batchexpire_dvt}    ${get_id_sp}    1
    ${input_tenlo}    Convert To String    ${input_tenlo}
    ${input_tenlo}    Replace sq blackets    ${input_tenlo}
    ${jsonpath_onhand_lo}    Format String    $..Data[?(@.BatchName=="{0}")].OnHand    ${input_tenlo}
    ${get_ton_lo}    Get data from API by BranchID    ${get_branch_id}    ${enpoint_batchexpire}    ${jsonpath_onhand_lo}
    ${get_ton_lo}    Convert To Number    ${get_ton_lo}
    ${get_ton_lo}    Evaluate    round(${get_ton_lo}, 3)
    Return From Keyword    ${get_ton_lo}

Get Stock Card Lot in tab Lo - HSD frm API by Branch Name
    [Arguments]    ${branch_name}    ${input_sochungtu}    ${input_actual_product}    ${input_product}    ${item_tenlo}
    [Timeout]    5 minutes
    ${get_branch_id}    ${endpoint_productlist_by_branch}    Get BranchID and Endpoint Product list by BranchName    ${branch_name}
    ${endpoint_pr}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${jsonpath_id_sp_actual}    Format String    $..Data[?(@.Code=="{0}")].Id    ${input_actual_product}
    ${jsonpath_id_sp}    Format String    $..Data[?(@.Code=="{0}")].Id    ${input_product}
    ${resp_pr}    Get Request and return body    ${endpoint_pr}
    ${get_id_sp_actual}    Get data from response json    ${resp_pr}    ${jsonpath_id_sp_actual}
    ${get_id_sp}    Get data from response json    ${resp_pr}    ${jsonpath_id_sp}
    ${jsonpath_dvqd}    Format String    $.Data[?(@.Code == "{0}")].ConversionValue    ${input_actual_product}
    ${get_dvqd}    Get data from response json    ${resp_pr}    ${jsonpath_dvqd}
    #get id batchexpire
    ${item_tenlo}    Convert To String    ${item_tenlo}
    ${item_tenlo}    Replace sq blackets    ${item_tenlo}
    ${jsonpath_batchlname}    Format String    $..Data[?(@.BatchName=="{0}")].Id    ${item_tenlo}
    ${endpoin_lodate}    Format String    ${endpoint_batchexpire_dvt}    ${get_id_sp}    ${get_dvqd}
    ${lodate_id}    Get data from API    ${endpoin_lodate}    ${jsonpath_batchlname}
    ${endpoint_thekho_lo}    Format String    ${endpoint_thekho_lo_dvt}    ${get_id_sp}    ${lodate_id}    ${get_dvqd}
    ${jsonpath_soluong_in_chungtu}    Format String    $..Data[?(@.DocumentCode=="{0}")].Quantity    ${input_sochungtu}
    ${jsonpath_toncuoi_in_chungtu}    Format String    $..Data[?(@.DocumentCode=="{0}")].EndingStocks    ${input_sochungtu}
    ${num_soluong_in_chungtu}    Get data from API by BranchID    ${get_branch_id}    ${endpoint_thekho_lo}    ${jsonpath_soluong_in_chungtu}
    ${toncuoi_in_chungtu}    Get data from API by BranchID    ${get_branch_id}    ${endpoint_thekho_lo}    ${jsonpath_toncuoi_in_chungtu}
    ${num_soluong_in_chungtu}    Convert To Number    ${num_soluong_in_chungtu}
    ${toncuoi_in_chungtu}    Convert to Number    ${toncuoi_in_chungtu}
    Return From Keyword    ${num_soluong_in_chungtu}    ${toncuoi_in_chungtu}

Assert values in Stock Card in tab Lo - HSD by Branch Name
    [Arguments]    ${branch_name}    ${ma_phieu}    ${input_actual_product}    ${input_product}    ${input_toncuoi}    ${input_num}
    ...    ${tenlo}
    [Documentation]    So sánh giá trị trong thẻ kho tab Lô - HSD
    [Timeout]    5 minutes
    ${soluong_in_thekho}    ${toncuoi_in_thekho}    Get Stock Card Lot in tab Lo - HSD frm API by Branch Name    ${branch_name}    ${ma_phieu}    ${input_actual_product}    ${input_product}
    ...    ${tenlo}
    Should Be Equal As Numbers    ${toncuoi_in_thekho}    ${input_toncuoi}
    Should Be Equal As Numbers    ${soluong_in_thekho}    ${input_num}

Get list order summary - total sale - onhand incase discount by product list
    [Arguments]    ${list_product}    ${list_soluong}    ${list_ggsp}   ${list_discount_type}
    [Timeout]    5 minutes
    ${list_tonkho}    Create List
    ${list_thanhtien}    Create List
    ${list_giamoi}    Create List
    ${list_base_price}    ${list_tongso_dh_bf_execute}    Get list base price and order summary frm product API    ${list_product}
    ${list_giatri_quydoi}    Get list gia tri quy doi frm product API    ${list_product}
    ${get_list_product_type}    ${list_tonkho_service}    Get list product type and ending stock of service frm API    ${list_product}
    ${list_onhand}    Get list onhand frm API    ${list_product}
    : FOR    ${input_soluong}    ${input_ggsp}    ${get_ton_bf_execute}    ${get_toncuoi_dv_execute}    ${item_giaban}    ${get_product_type}
    ...   ${discount_type}    IN ZIP    ${list_soluong}    ${list_ggsp}    ${list_onhand}    ${list_tonkho_service}    ${list_base_price}
    ...    ${get_list_product_type}   ${list_discount_type}
    \    ${result_toncuoi_hht}    Minus and round 2    ${get_ton_bf_execute}    ${input_soluong}
    \    ${result_toncuoi_dv}    Minus and round 2    ${get_toncuoi_dv_execute}    ${input_soluong}
    \    ${result_toncuoi_cb}    Set Variable If    '${get_product_type}' == '1'    0
    \    ${result_toncuoi_bf}    Set Variable If    '${get_product_type}' == '2'    ${result_toncuoi_hht}    ${result_toncuoi_dv}
    \    ${result_toncuoi}    Set Variable If    '${get_product_type}' == '1'    ${result_toncuoi_cb}    ${result_toncuoi_bf}
    \    ${result_giamoi}    Run Keyword If    '${discount_type}' == 'dis'    Price after % discount product    ${item_giaban}    ${input_ggsp}
    \    ...    ELSE IF    '${discount_type}' == 'disvnd'    Minus and round 2    ${item_giaban}    ${input_ggsp}
    \    ...    ELSE IF    '${discount_type}' == 'changeup' or '${discount_type}' == 'changedown'   Set Variable   ${input_ggsp}
    \    ...    ELSE     Set Variable    ${item_giaban}
    \    ${result_thanhtien}    Multiplication and round    ${result_giamoi}    ${input_soluong}
    \    Append To List    ${list_tonkho}    ${result_toncuoi}
    \    Append To List    ${list_thanhtien}    ${result_thanhtien}
    \    Append To List    ${list_giamoi}    ${result_giamoi}
    Return From Keyword    ${list_tongso_dh_bf_execute}    ${list_tonkho}    ${list_thanhtien}    ${list_giamoi}

Get list total sale - endingstock - cost frm product api
    [Arguments]    ${list_product}    ${list_nums}
    [Timeout]    3 minutes
    ${list_result_thanhtien}    Create List
    ${list_result_toncuoi}    Create List
    ${list_baseprice}    ${list_cost}    ${list_onhand}    ${list_giatri_quydoi}    Get list base price - cost - onhand - gia tri quy doi frm API    ${list_product}
    ${get_list_product_type}    ${list_tonkho_service}    Get list product type and ending stock of service frm API    ${list_product}
    : FOR    ${item_product}    ${item_nums}    ${item_price}    ${item_onhand}    ${get_giatri_quydoi}    ${get_product_type}
    ...    ${get_tonkho_dv}    IN ZIP    ${list_product}    ${list_nums}    ${list_baseprice}    ${list_onhand}
    ...    ${list_giatri_quydoi}    ${get_list_product_type}    ${list_tonkho_service}
    \    ${result_thanhtien}    Multiplication and round    ${item_nums}    ${item_price}
    \    ${result_toncuoi}    Run Keyword If    '${get_giatri_quydoi}' == '1'    Computation and get endingstock frm API    ${item_product}    ${item_nums}
    \    ...    ${item_onhand}    ${get_product_type}    ${get_tonkho_dv}
    \    ...    ELSE    Computation and get endingstock for unit product    ${item_product}    ${item_nums}    ${get_giatri_quydoi}
    \    Append to list    ${list_result_thanhtien}    ${result_thanhtien}
    \    Append to list    ${list_result_toncuoi}    ${result_toncuoi}
    Return From Keyword    ${list_result_thanhtien}    ${list_cost}    ${list_result_toncuoi}

Delete product thr API
    [Arguments]    ${input_prd_code}
    [Timeout]    3 minutes
    ${endpoint_pr}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${jsonpath_product_id}    Format String    $..Data[?(@.Code=="{0}")].Id    ${input_prd_code}
    ${get_product_id}    Get data from API    ${endpoint_pr}    ${jsonpath_product_id}
    ${endpoint_delete_prd}    Format String    ${endpoint_delete_product}    ${get_product_id}
    Delete request thr API    ${endpoint_delete_prd}

Delete list product thr API
    [Arguments]    ${list_product_code}
    [Timeout]    3 minutes
    ${list_product_id}    Get list product id thr API    ${list_product_code}
    ${string_list_product_id}         Convert To String        ${list_product_id}
    ${string_list_product_id}     Remove String      ${string_list_product_id}     [     ] 
    ${reqpayload}      Format String        {{"Ids":[{0}]}}        ${string_list_product_id}
    Post request thr API    ${endpoint_delete_list_product}    ${reqpayload}

Assert data in case create product
    [Arguments]    ${input_mahang}    ${input_ten_sp}    ${input_nhomhang}    ${input_ton}    ${input_giavon}    ${input_giaban}
    [Timeout]    3 minutes
    #${endpoint_pr}    Format String    /branchs/{0}/masterproducts?format=json&Includes=ProductAttributes&ForSummaryRow=true&CategoryId=0&AttributeFilter=%5B%5D&KeyWord={1}    ${BRANCH_ID}    ${input_mahang}
    ${endpoint_pr}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${get_resp}    Get Request and return body    ${endpoint_pr}
    ${jsonpath_ton}    Format String    $..Data[?(@.Code=="{0}")].OnHand    ${input_mahang}
    ${jsonpath_price}    Format String    $..Data[?(@.Code=="{0}")].BasePrice    ${input_mahang}
    ${jsonpath_cost}    Format String    $..Data[?(@.Code=="{0}")].Cost    ${input_mahang}
    ${jsonpath_name}    Format String    $..Data[?(@.Code=="{0}")].FullName    ${input_mahang}
    ${jsonpath_group}    Format String    $..Data[?(@.Code=="{0}")].CategoryName    ${input_mahang}
    ${ten}    Get data from response json    ${get_resp}    ${jsonpath_name}
    ${nhomhang}    Get data from response json    ${get_resp}    ${jsonpath_group}
    ${giaban}    Get data from response json    ${get_resp}    ${jsonpath_price}
    ${giavon}    Get data from response json    ${get_resp}    ${jsonpath_cost}
    ${ton}    Get data from response json    ${get_resp}    ${jsonpath_ton}
    Should Contain    ${ten}    ${input_ten_sp}
    Should Be Equal As Strings    ${nhomhang}    ${input_nhomhang}
    Should Be Equal As Numbers    ${ton}    ${input_ton}
    Should Be Equal As Numbers    ${giavon}    ${input_giavon}
    Should Be Equal As Numbers    ${giaban}    ${input_giaban}

Assert data in case create product have trade mark name
    [Arguments]    ${input_mahang}    ${input_ma_vach}    ${input_ten_sp}    ${input_nhomhang}    ${input_ton}    ${input_giavon}    ${input_giaban}    ${input_thuong_hieu}
    [Timeout]    3 minutes
    ${endpoint_pr}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${get_resp}    Get Request and return body    ${endpoint_pr}
    ${jsonpath_ton}    Format String    $..Data[?(@.Code=="{0}")].OnHand    ${input_mahang}
    ${jsonpath_price}    Format String    $..Data[?(@.Code=="{0}")].BasePrice    ${input_mahang}
    ${jsonpath_cost}    Format String    $..Data[?(@.Code=="{0}")].Cost    ${input_mahang}
    ${jsonpath_name}    Format String    $..Data[?(@.Code=="{0}")].FullName    ${input_mahang}
    ${jsonpath_group}    Format String    $..Data[?(@.Code=="{0}")].CategoryName    ${input_mahang}
    ${jsonpath_thuong_hieu}    Format String    $..Data[?(@.Code=="{0}")].TradeMarkName    ${input_mahang}
    ${jsonpath_ma_vach}    Format String    $..Data[?(@.Code=="{0}")].Barcode    ${input_mahang}
    ${ten}    Get data from response json    ${get_resp}    ${jsonpath_name}
    ${nhomhang}    Get data from response json    ${get_resp}    ${jsonpath_group}
    ${giaban}    Get data from response json    ${get_resp}    ${jsonpath_price}
    ${giavon}    Get data from response json    ${get_resp}    ${jsonpath_cost}
    ${ton}    Get data from response json    ${get_resp}    ${jsonpath_ton}
    ${get_thuong_hieu}    Get data from response json     ${get_resp}     ${jsonpath_thuong_hieu}
    ${get_ma_vach}       Get data from response json     ${get_resp}    ${jsonpath_ma_vach}
    Should Contain    ${ten}    ${input_ten_sp}
    Should Be Equal As Strings    ${nhomhang}    ${input_nhomhang}
    Should Be Equal As Numbers    ${ton}    ${input_ton}
    Should Be Equal As Numbers    ${giavon}    ${input_giavon}
    Should Be Equal As Numbers    ${giaban}    ${input_giaban}
    Should Be Equal As Strings    ${get_ma_vach}    ${input_ma_vach}
    Should Be Equal As Strings    ${get_thuong_hieu}    ${input_thuong_hieu}

Delete category thr API
    [Arguments]    ${ten_nhom}
    [Timeout]    3 minutes
    ${cat_id}    Get category ID    ${ten_nhom}
    ${endpoint_delete_cat}    Format String    ${endpoint_delete_category}    ${cat_id}
    Delete request thr API    ${endpoint_delete_cat}

Assert product is not available thr API
    [Arguments]    ${item_pr}
    [Timeout]    3 minutes
    ${endpoint_pr}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${list_pr}    Get raw data from API    ${endpoint_pr}    $..Code
    List Should Not Contain Value    ${list_pr}    ${item_pr}

Get total product in category thr API
    [Arguments]    ${ten_nhom}    ${tongsl}
    [Timeout]    3 minutes
    ${cat_id}    Get category ID    ${ten_nhom}
    ${endpoint_hanghoa_theo_nhom}    Format String    ${endpoint_hanghoa_theo_nhom}    ${BRANCH_ID}    ${cat_id}
    ${total}    Get data from API    ${endpoint_hanghoa_theo_nhom}    $..TotalProduct
    ${total}    Sum    ${total}    ${tongsl}
    Return From Keyword    ${total}

Get list cost, lastest purchase price, baseprice thr API
    [Arguments]    ${list_product}
    [Timeout]    3 minutes
    ${endpoint_pr}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${resp}    Get Request and return body    ${endpoint_pr}
    ${list_giavon}    Create List
    ${list_gianhapcuoi}    Create List
    ${list_giaban}    Create List
    :FOR      ${item_product}      IN ZIP    ${list_product}
    \     ${jsonpath_gianhapcuoi}    Format String    $..Data[?(@.Code=="{0}")].LatestPurchasePrice    ${item_product}
    \     ${jsonpath_giavon}    Format String    $..Data[?(@.Code=="{0}")].Cost    ${item_product}
    \     ${jsonpath_giaban}    Format String    $..Data[?(@.Code=="{0}")].BasePrice    ${item_product}
    \     ${gianhapcuoi}    Get data from response json    ${resp}    ${jsonpath_gianhapcuoi}
    \     ${giavon}    Get data from response json    ${resp}    ${jsonpath_giavon}
    \     ${giaban}    Get data from response json    ${resp}    ${jsonpath_giaban}
    \     Append To List    ${list_giavon}    ${giavon}
    \     Append To List    ${list_gianhapcuoi}    ${gianhapcuoi}
    \     Append To List    ${list_giaban}    ${giaban}
    Return From Keyword    ${list_giavon}    ${list_gianhapcuoi}    ${list_giaban}

Get list code basic of product unit
    [Arguments]    ${list_product}
    [Timeout]    3 minutes
    ${endpoint_pr}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${resp}    Get Request and return body    ${endpoint_pr}
    ${list_pr_cb}     Create List
    :FOR      ${item_product}     IN ZIP    ${list_product}
    \     ${jsonpath_id_sp_coban}    Format String    $..Data[?(@.Code=="{0}")].MasterUnitId    ${item_product}
    \     ${id_sp_coban}    Get data from response json    ${resp}    ${jsonpath_id_sp_coban}
    \     ${jsonpath_ma_sp_coban}    Format String    $..Data[?(@.Id=={0})].Code    ${id_sp_coban}
    \     ${ma_sp_coban}    Get data from response json    ${resp}    ${jsonpath_ma_sp_coban}
    \     ${ma_sp_cb}    Set Variable If    ${id_sp_coban}==0    ${item_product}    ${ma_sp_coban}
    \     Append to list      ${list_pr_cb}     ${ma_sp_cb}
    Return From Keyword    ${list_pr_cb}

Get product code from MasterProductId
    [Arguments]    ${input_mahang}
    [Timeout]    3 minutes
    ${endpoint_pr}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${resp}    Get Request and return body    ${endpoint_pr}
    ${jsonpath_id_sp}    Format String    $..Data[?(@.Code=="{0}")].Id    ${input_mahang}
    ${get_id_sp_coban}    Get data from response json    ${resp}    ${jsonpath_id_sp}
    ${jsonpath_ma_sp_thuoc_tinh}    Format String    $..Data[?(@.MasterProductId=={0})].Code    ${get_id_sp_coban}
    ${get_list_sp_thuoc_tinh}    Get raw data from response json    ${resp}    ${jsonpath_ma_sp_thuoc_tinh}
    Return From Keyword    ${get_list_sp_thuoc_tinh}

Get list cost - onhand of product unit
    [Arguments]    ${list_pr_cb}    ${list_pr_qd}
    [Timeout]    3 minutes
    ${get_list_cost_cb_bf}    ${get_list_onhand_cb_bf}    Get list cost - onhand frm API    ${list_pr_cb}
    ${get_list_onhand_actual_bf}    ${get_list_latestprice_actual}    ${get_list_cost_actual_bf}    ${list_dvqd_unit}    Get list of Onhand, LastestPurchasePrice and Cost - Conversation values by searching product API    ${list_pr_qd}
    ${list_cost_qd}    Create List
    : FOR    ${item_dvqd}    ${item_cost_cb}    IN ZIP    ${list_dvqd_unit}    ${get_list_cost_cb_bf}
    \    ${result_cost_actual}    Multiplication with price round 2    ${item_cost_cb}    ${item_dvqd}
    \    Append To List    ${list_cost_qd}    ${result_cost_actual}
    Return From Keyword    ${list_cost_qd}    ${get_list_onhand_actual_bf}

Get list product id thr API
    [Arguments]    ${list_product}
    ${list_id_sp}    Create List
    ${endpoint_hh_co_dvt}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${resp}    Get Request and return body    ${endpoint_hh_co_dvt}
    : FOR    ${ma_hh}    IN    @{list_product}
    \    ${jsonpath_id_sp}    Format String    $..Data[?(@.Code == '{0}')].Id    ${ma_hh}
    \    ${get_prd_id}    Get data from response json    ${resp}    ${jsonpath_id_sp}
    \    Append To List    ${list_id_sp}    ${get_prd_id}
    Return From Keyword    ${list_id_sp}

Get product id thr API
    [Arguments]    ${input_product}
    ${list_id_sp}    Create List
    ${endpoint_hh_co_dvt}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${resp}    Get Request and return body    ${endpoint_hh_co_dvt}
    ${jsonpath_id_sp}    Format String     $..Data[?(@.Code == '{0}')].Id    ${input_product}
    ${get_prd_id}    Get data from response json    ${resp}    ${jsonpath_id_sp}
    Return From Keyword    ${get_prd_id}

Assert data in case create unit product
    [Arguments]    ${input_mahang}    ${input_ten_sp}    ${input_nhomhang}    ${input_ton}    ${input_giavon}    ${input_giaban}
    [Timeout]    3 minutes
    #${endpoint_pr}    Format String    /branchs/{0}/masterproducts?format=json&Includes=ProductAttributes&ForSummaryRow=true&CategoryId=0&AttributeFilter=%5B%5D&KeyWord={1}    ${BRANCH_ID}    ${input_mahang}
    ${endpoint_pr}    Format String     ${endpoint_danhmuc_hh_co_dvt}       ${BRANCH_ID}
    ${get_resp}    Get Request and return body    ${endpoint_pr}
    ${jsonpath_ton}    Format String    $..Data[?(@.Code=="{0}")].OnHand    ${input_mahang}
    ${jsonpath_price}    Format String    $..Data[?(@.Code=="{0}")].BasePrice    ${input_mahang}
    ${jsonpath_cost}    Format String    $..Data[?(@.Code=="{0}")].Cost    ${input_mahang}
    ${jsonpath_name}    Format String    $..Data[?(@.Code=="{0}")].FullName    ${input_mahang}
    ${jsonpath_group}    Format String    $..Data[?(@.Code=="{0}")].CategoryName    ${input_mahang}
    ${ten}    Get data from response json    ${get_resp}    ${jsonpath_name}
    ${nhomhang}    Get data from response json    ${get_resp}    ${jsonpath_group}
    ${giaban}    Get data from response json    ${get_resp}    ${jsonpath_price}
    ${giavon}    Get data from response json    ${get_resp}    ${jsonpath_cost}
    ${ton}    Get data from response json    ${get_resp}    ${jsonpath_ton}
    Should Contain    ${ten}    ${input_ten_sp}
    Should Be Equal As Strings    ${nhomhang}    ${input_nhomhang}
    Should Be Equal As Numbers    ${ton}    ${input_ton}
    Should Be Equal As Numbers    ${giavon}    ${input_giavon}
    Should Be Equal As Numbers    ${giaban}    ${input_giaban}

Get list imei status thr API
    [Arguments]    ${list_prs}
    [Timeout]    20 minutes
    ${endpoint_hh}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${resp}    Get Request and return body    ${endpoint_hh}
    ${list_imei_status}    Create List
    : FOR    ${item_pr}    IN ZIP    ${list_prs}
    \    ${jsonpath_imei_status}    Format String    $..Data[?(@.Code=="{0}")].IsLotSerialControl    ${item_pr}
    \    ${get_imei_status}    Get data from response json    ${resp}    ${jsonpath_imei_status}
    \    Append To List    ${list_imei_status}    ${get_imei_status}
    Log    ${list_imei_status}
    Return From Keyword    ${list_imei_status}

Get list imei status and id product thr API
    [Arguments]    ${list_product}
    ${list_id_sp}    Create List
    ${list_imei_status}    Create List
    ${endpoint_hh_co_dvt}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${resp}    Get Request and return body    ${endpoint_hh_co_dvt}
    : FOR    ${ma_hh}    IN    @{list_product}
    \    ${jsonpath_id_sp}    Format String    $..Data[?(@.Code == '{0}')].Id    ${ma_hh}
    \    ${jsonpath_imei_status}    Format String    $..Data[?(@.Code=="{0}")].IsLotSerialControl    ${ma_hh}
    \    ${get_prd_id}    Get data from response json    ${resp}    ${jsonpath_id_sp}
    \    ${get_imei_status}    Get data from response json    ${resp}    ${jsonpath_imei_status}
    \    Append To List    ${list_imei_status}    ${get_imei_status}
    \    Append To List    ${list_id_sp}    ${get_prd_id}
    Return From Keyword    ${list_id_sp}    ${list_imei_status}

Get list on order frm API
    [Arguments]    ${list_prs}
    [Timeout]    3 minutes
    ${endpoint_hh}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${resp}    Get Request and return body    ${endpoint_hh}
    ${list_on_order}    Create List
    : FOR    ${item_pr}    IN ZIP    ${list_prs}
    \    ${endpoint_on_order}    Format String    $..Data[?(@.Code=="{0}")].OnOrder    ${item_pr}
    \    ${get_on_order}    Get data from response json    ${resp}    ${endpoint_on_order}
    \    Append To List    ${list_on_order}    ${get_on_order}
    Log    ${list_on_order}
    Return From Keyword    ${list_on_order}

Get list of total import product frm API
    [Arguments]    ${list_product_code}
    [Timeout]    3 minutes
    ${get_list_pr_id}    Get list product id thr API    ${list_product_code}
    ${list_total}    Create List
    : FOR    ${item_product}    ${item_pr_id}    IN ZIP    ${list_product_code}    ${get_list_pr_id}
    \    ${endpoint_tk}    Format String    ${endpoint_thekho}    ${item_pr_id}    ${BRANCH_ID}
    \    ${list_document_cod}    Get data from API    ${endpoint_tk}    $..Data[?(@.DocumentType==2)].DocumentType
    \    ${total}    Set Variable If    ${list_document_cod}!=0    1    0
    \    Append To List    ${list_total}    ${total}
    Log    ${list_total}
    Return From Keyword    ${list_total}

Assert list of onhand, cost af receipt
    [Arguments]    ${list_prs}    ${list_result_onhand}    ${list_result_cost}
    [Timeout]    3 minutes
    ${get_list_onhand_af}    ${get_list_latestprice_af}    ${get_list_cost_af}    Get list of Onhand, LatestPurchasePrice and Cost frm API    ${list_prs}
    : FOR    ${item_pr}    ${item_result_onhand}    ${item_result_cost}    ${item_onhand_af}    ${item_cost_af}    ${item_latestprice_af}
    ...    IN ZIP    ${list_prs}    ${list_result_onhand}    ${list_result_cost}    ${get_list_onhand_af}    ${get_list_cost_af}
    ...    ${get_list_latestprice_af}
    \    ${chenh_lech_tonkho}   Minus    ${item_result_onhand}    ${item_onhand_af}
    \    Run Keyword If    ${chenh_lech_tonkho}!=0    Fail    Lệch tồn kho hàng ${item_pr}
    \    ${chenh_lech}        Minus    ${item_cost_af}     ${item_result_cost}
    \    ${chenh_lech}      Evaluate    abs(${chenh_lech})
    \    Run Keyword If    ${chenh_lech}>0.15    Fail    Lệch giá vốn hàng ${item_pr}

Get list of total purchase return - result new price incase having imported products
    [Arguments]    ${input_list_product}    ${list_costs}    ${input_list_num}    ${input_list_discount}    ${input_list_discount_type}
    [Documentation]    Lấy list tổng trả nhập hàng, giá mới trong trường hợp đã có PNH trước đó
    [Timeout]    5 minutes
    ${list_result_total_purchase_return}    Create list
    ${list_result_newprice_purchase_return}    Create list
    : FOR    ${item_product}    ${item_cost}    ${item_num}    ${item_discount}    ${item_discount_type}    IN ZIP
    ...    ${input_list_product}    ${list_costs}    ${input_list_num}    ${input_list_discount}    ${input_list_discount_type}
    \    ${result_newprice}=    Run Keyword If    '${item_discount_type}' == 'dis'    Price after % discount product    ${item_cost}    ${item_discount}
    \    ...    ELSE IF    '${item_discount_type}' == 'disvnd'    Minus    ${item_cost}    ${item_discount}
    \    ...    ELSE IF    '${item_discount_type}' == 'changeup' or '${item_discount_type}' == 'changedown'    Set Variable    ${item_discount}
    \    ...    ELSE    Set Variable    ${item_cost}
    \    ${result_total_pur_return}    Multiplication and round    ${item_num}    ${result_newprice}
    \    Append to list    ${list_result_total_purchase_return}    ${result_total_pur_return}
    \    Append to list    ${list_result_newprice_purchase_return}    ${result_newprice}
    Return From Keyword    ${list_result_total_purchase_return}    ${list_result_newprice_purchase_return}

#discount and newprice dùng chung KeyWord
Get product info frm list jsonpath product incase discount product - return total sale
    [Arguments]    ${get_resp_product}    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}    ${list_ggsp}    ${list_discount_type}    ${list_nums}
    [Timeout]    3 minutes
    ${list_id_sp}    Create List
    ${list_result_ggsp}    Create List
    ${list_giaban}    Create List
    ${list_thanhtien}    Create List
    : FOR    ${jsonpath_id_sp}    ${jsonpath_giaban}    ${item_nums}    ${giamgia_sp}    ${discount_type}    IN ZIP    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}
    ...    ${list_nums}    ${list_ggsp}    ${list_discount_type}
    \    ${get_id_sp}    Get data from response json    ${get_resp_product}    ${jsonpath_id_sp}
    \    ${get_gia_ban}    Get data from response json    ${get_resp_product}    ${jsonpath_giaban}
    \    ${result_ggsp}    Run Keyword If    '${discount_type}' == 'dis'    Convert % discount to VND    ${get_gia_ban}    ${giamgia_sp}
    \    ...    ELSE IF    '${discount_type}' == 'changeup' or '${discount_type}' == 'changedown'    Minus and round 2    ${get_gia_ban}    ${giamgia_sp}
    \    ...    ELSE    Set Variable    ${giamgia_sp}
    \    ${result_giamoi}    Run Keyword If    '${discount_type}' == 'dis'    Price after % discount product    ${get_gia_ban}    ${giamgia_sp}
    \    ...    ELSE IF    '${discount_type}' == 'disvnd'    Minus and round 2    ${get_gia_ban}    ${giamgia_sp}
    \    ...    ELSE IF    '${discount_type}' == 'changeup' or '${discount_type}' == 'changedown'    Set Variable    ${giamgia_sp}
    \    ...    ELSE    Set Variable    ${get_gia_ban}
    \    ${result_thanhtien}    Multiplication and round    ${result_giamoi}    ${item_nums}
    \    Append To List    ${list_giaban}    ${get_gia_ban}
    \    Append To List    ${list_result_ggsp}    ${result_ggsp}
    \    Append To List    ${list_id_sp}    ${get_id_sp}
    \    Append To List    ${list_thanhtien}    ${result_thanhtien}
    Return From Keyword    ${list_giaban}    ${list_result_ggsp}    ${list_id_sp}    ${list_thanhtien}

Get product info frm list jsonpath product incase discount product
    [Arguments]    ${get_resp_product}    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}    ${list_ggsp}    ${list_discount_type}
    [Timeout]    3 minutes
    ${list_id_sp}    Create List
    ${list_result_ggsp}    Create List
    ${list_giaban}    Create List
    : FOR    ${jsonpath_id_sp}    ${jsonpath_giaban}    ${giamgia_sp}    ${discount_type}    IN ZIP    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}    ${list_ggsp}    ${list_discount_type}
    \    ${get_id_sp}    Get data from response json    ${get_resp_product}    ${jsonpath_id_sp}
    \    ${get_gia_ban}    Get data from response json    ${get_resp_product}    ${jsonpath_giaban}
    \    ${result_ggsp}    Run Keyword If    '${discount_type}' == 'dis'    Convert % discount to VND    ${get_gia_ban}    ${giamgia_sp}
    \    ...    ELSE IF    '${discount_type}' == 'changeup' or '${discount_type}' == 'changedown'    Minus and round 2    ${get_gia_ban}    ${giamgia_sp}
    \    ...    ELSE    Set Variable    ${giamgia_sp}
    \    ${result_giamoi}    Run Keyword If    '${discount_type}' == 'dis'    Price after % discount product    ${get_gia_ban}    ${giamgia_sp}
    \    ...    ELSE IF    '${discount_type}' == 'disvnd'    Minus and round 2    ${get_gia_ban}    ${giamgia_sp}
    \    ...    ELSE IF    '${discount_type}' == 'changeup' or '${discount_type}' == 'changedown'    Set Variable    ${giamgia_sp}    ELSE    Set Variable    ${get_gia_ban}
    \    Append To List    ${list_giaban}    ${get_gia_ban}
    \    Append To List    ${list_result_ggsp}    ${result_ggsp}
    \    Append To List    ${list_id_sp}    ${get_id_sp}
    Return From Keyword    ${list_giaban}    ${list_result_ggsp}    ${list_id_sp}

Get product info frm multi row jsonpath product have discount product
    [Arguments]    ${get_resp_product}    ${list_jsonpath_id_sp}    ${list_jsonpath_giaban}    ${list_ggsp}    ${list_discount_type}
    [Timeout]    3 minutes
    ${list_id_sp}    Create List
    ${list_result_ggsp}    Create List
    ${list_giaban}    Create List
    : FOR    ${jsonpath_id_sp}    ${jsonpath_giaban}    ${item_giamgia_sp}    ${item_discount_type}    IN ZIP    ${list_jsonpath_id_sp}
    ...    ${list_jsonpath_giaban}    ${list_ggsp}    ${list_discount_type}
    \    ${get_id_sp}    Get data from response json    ${get_resp_product}    ${jsonpath_id_sp}
    \    ${get_gia_ban}    Get data from response json    ${get_resp_product}    ${jsonpath_giaban}
    \    ${result_ggsp}    Get list discount product incase multi row product    ${get_gia_ban}    ${item_giamgia_sp}    ${item_discount_type}
    \    Append To List    ${list_giaban}    ${get_gia_ban}
    \    Append To List    ${list_result_ggsp}    ${result_ggsp}
    \    Append To List    ${list_id_sp}    ${get_id_sp}
    Return From Keyword    ${list_giaban}    ${list_result_ggsp}    ${list_id_sp}

Get list discount product incase multi row product
    [Arguments]    ${get_gia_ban}    ${list_ggsp}    ${list_discount_type}
    ${list_result_ggsp}    Create List
    : FOR    ${item_ggsp}    ${discount_type}    IN ZIP    ${list_ggsp}    ${list_discount_type}
    \    ${ggsp}    Run Keyword If    '${discount_type}' == 'dis'    Convert % discount to VND    ${get_gia_ban}    ${item_ggsp}
    \    ...    ELSE IF    '${discount_type}' == 'disvnd'    Set Variable    ${item_ggsp}
    \    ...    ELSE IF    '${discount_type}' == 'changeup' or '${discount_type}' == 'changedown'    Minus and round 2    ${get_gia_ban}    ${item_ggsp}
    \    ...    ELSE    Set Variable    ${item_ggsp}
    \    Append to List    ${list_result_ggsp}    ${ggsp}
    Return From Keyword    ${list_result_ggsp}

Get payload product incase multi row product
    [Arguments]    ${item_gia_ban}    ${item_id_sp}    ${list_soluong}    ${list_result_ggsp}    ${list_ggsp}    ${liststring_prs_order_detail}
    : FOR    ${item_soluong}    ${item_result_ggsp}    ${item_ggsp}    IN ZIP    ${list_soluong}    ${list_result_ggsp}
    ...    ${list_ggsp}
    \    ${item_ggsp}    Set Variable If    0 < ${item_ggsp} < 100    ${item_ggsp}    0
    \    ${payload_each_product}    Format string    {{"BasePrice":25000.06,"Discount":{0},"DiscountRatio":{1},"IsLotSerialControl":false,"IsMaster":false,"IsRewardPoint":false,"Note":"","Price":{2},"ProductCode":"DV049","ProductId":{3},"ProductName":"Nails 1","Quantity":{4},"SerialNumbers":"","Uuid":"","OriginPrice":{2},"ProductBatchExpireId":null}}    ${item_result_ggsp}    ${item_ggsp}    ${item_gia_ban}
    \    ...    ${item_id_sp}    ${item_soluong}
    \    Append To List    ${liststring_prs_order_detail}    ${payload_each_product}
    Return From Keyword    ${liststring_prs_order_detail}

Get list baseprice - result discount - result newprice product incase changing price
    [Arguments]    ${list_product}    ${list_change}    ${list_change_type}
    [Timeout]    3 minutes
    ${list_result_ggsp}    Create List
    ${list_giaban}    Get list of Baseprice by Product Code    ${list_product}
    ${list_result_newprice}    Create List
    : FOR    ${item_giaban}    ${item_change}    ${item_change_type}    IN ZIP    ${list_giaban}    ${list_change}
    ...    ${list_change_type}
    \    ${result_ggsp}    Run Keyword If    0 <${item_change}< 100 and '${item_change_type}'=='dis'    Convert % discount to VND    ${item_giaban}    ${item_change}
    \    ...    ELSE IF    '${item_change_type}'=='change'    Minus    ${item_giaban}    ${item_change}
    \    ...    ELSE    Set Variable    ${item_change}
    \    ${result_newprice}    Run Keyword If    '${item_change_type}'=='dis'    Minus    ${item_giaban}    ${result_ggsp}
    \    ...    ELSE    Set Variable    ${item_change}
    \    Append To List    ${list_result_ggsp}    ${result_ggsp}
    \    Append To List    ${list_result_newprice}    ${result_newprice}
    Return From Keyword    ${list_giaban}    ${list_result_ggsp}    ${list_result_newprice}

Update price product thr API
    [Arguments]    ${ma_sp}    ${pr_type}    ${gia_ban}
    [Timeout]    3 minutes
    ${get_prd_id}    Get product ID    ${ma_sp}
    ${endpoint_pr}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${get_resp}    Get Request and return body    ${endpoint_pr}
    ${jsonpath_ton}    Format String    $..Data[?(@.Code=="{0}")].OnHand    ${ma_sp}
    ${jsonpath_price}    Format String    $..Data[?(@.Code=="{0}")].BasePrice    ${ma_sp}
    ${jsonpath_cost}    Format String    $..Data[?(@.Code=="{0}")].Cost    ${ma_sp}
    ${jsonpath_name}    Format String    $..Data[?(@.Code=="{0}")].Name    ${ma_sp}
    ${jsonpath_group}    Format String    $..Data[?(@.Code=="{0}")].CategoryName    ${ma_sp}
    ${jsonpath_lastestpurchase}    Format String    $..Data[?(@.Code=="{0}")].LatestPurchasePrice    ${ma_sp}
    ${jsonpath_group}    Format String    $..Data[?(@.Code=="{0}")].CategoryName    ${ma_sp}
    ${jsonpath_unit}    Format String    $..Data[?(@.Code=="{0}")].Unit    ${ma_sp}
    ${ten}    Get data from response json    ${get_resp}    ${jsonpath_name}
    ${nhomhang}    Get data from response json    ${get_resp}    ${jsonpath_group}
    ${giaban_bf}    Get data from response json    ${get_resp}    ${jsonpath_price}
    ${giavon}    Get data from response json    ${get_resp}    ${jsonpath_cost}
    ${ton}    Get data from response json    ${get_resp}    ${jsonpath_ton}
    ${group}    Get data from response json    ${get_resp}    ${jsonpath_group}
    ${lastestprice}    Get data from response json    ${get_resp}    ${jsonpath_lastestpurchase}
    ${unit}    Get data from response json    ${get_resp}    ${jsonpath_unit}
    ${get_list_material_code}    ${get_list_quantity}    Get material product code and quantity lists of combo    ${ma_sp}
    ${get_list_material_id}    Run Keyword If    '${pr_type}'=='com'    Get list product id thr API    ${get_list_material_code}
    ...    ELSE    Set Variable    none
    ${get_material_id_1}    Run Keyword If    '${pr_type}'=='com'    Get From List    ${get_list_material_id}    0
    ...    ELSE    Set Variable    none
    ${get_material_id_2}    Run Keyword If    '${pr_type}'=='com'    Get From List    ${get_list_material_id}    1
    ...    ELSE    Set Variable    none
    ${get_quantity_1}    Run Keyword If    '${pr_type}'=='com'    Get From List    ${get_list_quantity}    0
    ...    ELSE    Set Variable    none
    ${get_quantity_2}    Run Keyword If    '${pr_type}'=='com'    Get From List    ${get_list_quantity}    1
    ...    ELSE    Set Variable    none
    ${get_cat_id}    Get category ID    ${nhomhang}
    ${get_retailer_id}    Get RetailerID
    ${format_data}    Run Keyword If    '${pr_type}'=='pro'    Format String    "Id":{0},"ProductType":2,"CategoryId":{1},"CategoryName":"","isActive":true,"HasVariants":false,"VariantCount":0,"AllowsSale":true,"isDeleted":false,"Name":"{8}","FullName":"{8}","Code":"{2}","BasePrice":{3},"Cost":{4},"LatestPurchasePrice":{5},"OnHand":{6},"OnOrder":0,"OnHandCompareMin":0,"OnHandCompareMax":0,"CompareOnHand":0,"CompareCost":{4},"CompareBasePrice":{7},"CompareCode":"{2}","CompareName":"{8}","CompareUnit":"","CompareProductShelves":[],"Reserved":0,"MinQuantity":0,"MaxQuantity":999999999,"CustomId":0,"CustomValue":0,"Unit":"","ConversionValue":1,"OrderTemplate":"","ProductAttributes":[],"ProductShelves":[],"ProductUnits":[],"IsLotSerialControl":false,"IsRewardPoint":false,"IsBatchExpireControl":false,"FormulaCount":0,"TradeMarkName":"","MasterCode":"SPC002324","GenuineGuarantees":[],"StoreGuarantees":[],"RepeatGuarantee":{{"Uuid":-1,"TimeType":2,"ProductId":{0},"RetailerId":{9},"Description":"Toàn bộ sản phẩm"}},"GuaranteesToDelete":[],"ProductFormulas":[],"ProductFormulasOld":[],"ProductImages":[],"ListPriceBookDetail":[]    ${get_prd_id}    ${get_cat_id}
    ...    ${ma_sp}    ${gia_ban}    ${giavon}    ${lastestprice}    ${ton}    ${giaban_bf}
    ...    ${ten}    ${get_retailer_id}
    ...    ELSE IF    '${pr_type}'=='ser'    Format String    "Id":{0},"ProductType":3,"CategoryId":{1},"CategoryName":"","isActive":true,"HasVariants":false,"VariantCount":0,"AllowsSale":true,"isDeleted":false,"Name":"{8}","FullName":"{8}","Code":"{2}","BasePrice":{3},"Cost":{4},"LatestPurchasePrice":{5},"OnHand":{6},"OnOrder":0,"OnHandCompareMin":0,"OnHandCompareMax":0,"CompareOnHand":0,"CompareCost":{4},"CompareBasePrice":{7},"CompareCode":"KLDV020","CompareName":"{8}","CompareUnit":"","CompareProductShelves":[],"Reserved":0,"MinQuantity":0,"MaxQuantity":0,"CustomId":0,"CustomValue":0,"Unit":"","ConversionValue":1,"OrderTemplate":"","ProductAttributes":[],"ProductShelves":[],"ProductUnits":[],"IsLotSerialControl":false,"IsRewardPoint":false,"IsBatchExpireControl":false,"FormulaCount":0,"TradeMarkName":"","MasterCode":"SPC002360","GenuineGuarantees":[],"StoreGuarantees":[],"RepeatGuarantee":{{"Uuid":-1,"TimeType":2,"ProductId":{0},"RetailerId":{9},"Description":"Toàn bộ sản phẩm"}},"GuaranteesToDelete":[],"ProductFormulas":[],"ProductFormulasOld":[],"ProductImages":[],"ListPriceBookDetail":[]    ${get_prd_id}    ${get_cat_id}
    ...    ${ma_sp}    ${gia_ban}    ${giavon}    ${lastestprice}    ${ton}    ${giaban_bf}
    ...    ${ten}    ${get_retailer_id}
    ...    ELSE IF    '${pr_type}'=='imei'    Format String    "Id":{0},"ProductType":2,"CategoryId":{1},"CategoryName":"","isActive":true,"HasVariants":false,"VariantCount":0,"AllowsSale":true,"isDeleted":false,"Name":"{8}","FullName":"{8}","Code":"{2}","BasePrice":{3},"Cost":{4},"LatestPurchasePrice":{5},"OnHand":{6},"OnOrder":0,"OnHandCompareMin":0,"OnHandCompareMax":0,"CompareOnHand":0,"CompareCost":{4},"CompareBasePrice":{7},"CompareCode":"{2}","CompareName":"{8}","CompareUnit":"","CompareProductShelves":[],"Reserved":0,"MinQuantity":0,"MaxQuantity":999999999,"CustomId":0,"CustomValue":0,"Unit":"","ConversionValue":1,"OrderTemplate":"","ProductAttributes":[],"ProductShelves":[],"ProductUnits":[],"IsLotSerialControl":true,"IsRewardPoint":false,"IsBatchExpireControl":false,"FormulaCount":0,"TradeMarkName":"","MasterCode":"SPC002324","GenuineGuarantees":[],"StoreGuarantees":[],"RepeatGuarantee":{{"Uuid":-1,"TimeType":2,"ProductId":{0},"RetailerId":{9},"Description":"Toàn bộ sản phẩm"}},"GuaranteesToDelete":[],"ProductFormulas":[],"ProductFormulasOld":[],"ProductImages":[],"ListPriceBookDetail":[]    ${get_prd_id}    ${get_cat_id}
    ...    ${ma_sp}    ${gia_ban}    ${giavon}    ${lastestprice}    ${ton}    ${giaban_bf}
    ...    ${ten}    ${get_retailer_id}
    ...    ELSE IF    '${pr_type}'=='unit'    Format String    "Id":{0},"ProductType":2,"CategoryId":{1},"CategoryName":"","isActive":true,"HasVariants":false,"VariantCount":0,"AllowsSale":true,"isDeleted":false,"Name":"{8}","FullName":"{8}","Code":"{2}","BasePrice":{3},"Cost":{4},"LatestPurchasePrice":{5},"OnHand":{6},"OnOrder":0,"OnHandCompareMin":0,"OnHandCompareMax":0,"CompareOnHand":150,"CompareCost":{4},"CompareBasePrice":{7},"CompareCode":"{2}","CompareName":"{8}","CompareUnit":"{9}","CompareProductShelves":[],"Reserved":0,"MinQuantity":0,"MaxQuantity":999999999,"CustomId":0,"CustomValue":0,"Unit":"{9}","ConversionValue":1,"OrderTemplate":"","ProductAttributes":[],"ProductShelves":[],"ProductUnits":[],"IsLotSerialControl":false,"IsRewardPoint":false,"IsBatchExpireControl":false,"FormulaCount":0,"TradeMarkName":"","MasterCode":"SPC002317","GenuineGuarantees":[],"StoreGuarantees":[],"RepeatGuarantee":{{"Uuid":-1,"TimeType":2,"ProductId":{0},"RetailerId":{10},"Description":"Toàn bộ sản phẩm"}},"GuaranteesToDelete":[],"ProductFormulas":[],"ProductFormulasOld":[],"ProductImages":[],"ListPriceBookDetail":[]    ${get_prd_id}    ${get_cat_id}
    ...    ${ma_sp}    ${gia_ban}    ${giavon}    ${lastestprice}    ${ton}    ${giaban_bf}
    ...    ${ten}    ${unit}    ${get_retailer_id}
    ...    ELSE    Format String    "Id":{0},"ProductType":1,"CategoryId":{1},"CategoryName":"","isActive":true,"HasVariants":false,"VariantCount":0,"AllowsSale":true,"isDeleted":false,"Name":"{2}","FullName":"{2}","Code":"{3}","BasePrice":{4},"Cost":{5},"LatestPurchasePrice":0,"OnHand":{6},"OnOrder":0,"OnHandCompareMin":0,"OnHandCompareMax":0,"CompareOnHand":0,"CompareCost":{5},"CompareBasePrice":{7},"CompareCode":"{3}","CompareName":"{2}","CompareUnit":"","CompareProductShelves":[],"Reserved":0,"MinQuantity":0,"MaxQuantity":0,"CustomId":0,"CustomValue":0,"Unit":"","ConversionValue":1,"OrderTemplate":"","ProductAttributes":[],"ProductShelves":[],"ProductFormulas":[{{"MaterialId":{8},"MaterialCode":"RPT0011","MaterialName":"Ô mai chanh đào Hồng Lam","Quantity":{9},"Cost":30000,"BasePrice":60000,"$$hashKey":"object:12313"}},{{"MaterialId":{10},"MaterialCode":"RPT0015","MaterialName":"Kem whipping cream Anchor","Quantity":{11},"Cost":35000,"BasePrice":20025.46,"$$hashKey":"object:12314"}}],"ProductUnits":[],"IsLotSerialControl":false,"IsRewardPoint":false,"IsBatchExpireControl":false,"FormulaCount":0,"TradeMarkName":"","MasterCode":"SPC002377","GenuineGuarantees":[],"StoreGuarantees":[],"RepeatGuarantee":{{"Uuid":-1,"TimeType":2,"ProductId":{0},"RetailerId":{12},"Description":"Toàn bộ sản phẩm"}},"GuaranteesToDelete":[],"ProductFormulasOld":[{{"MaterialId":{8},"MaterialCode":"RPT0011","MaterialName":"Ô mai chanh đào Hồng Lam","Quantity":{9},"Cost":30000,"BasePrice":60000,"$$hashKey":"object:12313"}},{{"MaterialId":{10},"MaterialCode":"RPT0015","MaterialName":"Kem whipping cream Anchor","Quantity":{11},"Cost":35000,"BasePrice":20025.46,"$$hashKey":"object:12314"}}],"ProductImages":[],"ListPriceBookDetail":[]    ${get_prd_id}    ${get_cat_id}    ${ten}
    ...    ${ma_sp}    ${gia_ban}    ${giavon}    ${ton}    ${giaban_bf}    ${get_material_id_1}
    ...    ${get_quantity_1}    ${get_material_id_2}    ${get_quantity_2}    ${get_retailer_id}
    log    ${format_data}
    ${data}    Evaluate    (None, '{${format_data}}')
    ${data1}    Evaluate    (None, '[]')
    ${payload}    Create Dictionary    Product=${data}    ListUnitPriceBookDetail=${data1}
    Log    ${payload}
    Post request data form thr API    /products/photo    files=${payload}

Get material id of combo product thr API
    [Arguments]    ${ma_hh}
    [Timeout]    3 minutes
    ${endpoint_list_hh}    Format String    ${endpoint_list_hh_in_mhbh}    ${BRANCH_ID}    ${BRANCH_ID}
    ${get_resp}    Get Request and return body    ${endpoint_list_hh}
    ${jsonpath_materialid}    FormatString    $.Data[?(@.Code == "{0}")].MaterialId    ${ma_hh}
    ${jsonpath_quantity}    FormatString    $.Data[?(@.Code == "{0}")].Quantity    ${ma_hh}
    ${get_material_id}    Get raw data from response json    ${get_resp}    ${jsonpath_materialid}
    ${get_quantity}    Get raw data from response json    ${get_resp}    ${jsonpath_quantity}
    Return From Keyword    ${get_material_id}    ${get_quantity}

Get lists of product code in group
    [Arguments]       ${category_name}
    ${cat_id}       Get category ID        ${category_name}
    ${endpoint_list_pro_by_cat}       Format String        ${endpoint_hanghoa_theo_nhom}       ${BRANCH_ID}      ${cat_id}
    ${resp_list_pro_by_cat}       Get Request and return body    ${endpoint_list_pro_by_cat}
    ${list_products}        Get raw data from response json    ${resp_list_pro_by_cat}    $..Code
    Return From Keyword    ${list_products}

Get actual quantity of master product by its product code
    [Arguments]       ${list_prs}       ${list_nums}
    ${list_dvqd}    Create List
    ${index_list_pr}    Set Variable    0
    : FOR    ${item_pr}    IN    @{list_prs}
    \    ${index_list_pr}    Evaluate    ${index_list_pr} + 1
    \    ${dvqd}    Get DVQD by product code frm API    ${item_pr}
    \    Append To List    ${list_dvqd}    ${dvqd}
    \    Log Many    ${list_dvqd}
    log many    ${list_dvqd}
    ### list actual num and cal
    ${list_actual_num}    Create List
    ${index_dvqd}    Set Variable    -1
    ${index_num}    Set Variable    -1
    : FOR    ${item_dvqd}    ${item_num}    IN ZIP    ${list_dvqd}    ${list_nums}
    \    ${index_dvqd}    Evaluate    ${index_dvqd} + 1
    \    ${index_num}    Evaluate    ${index_num} + 1
    \    ${item_dvqd}    Get From List    ${list_dvqd}    ${index_dvqd}
    \    ${item_num}    Get From List    ${list_nums}    ${index_num}
    \    ${actual_num}    Multiplication and replace floating point    ${item_dvqd}    ${item_num}
    \    Append To List    ${list_actual_num}    ${actual_num}
    Log Many    ${list_actual_num}
    ${actual_num_pr}    Sum values in list    ${list_actual_num}
    Return From Keyword    ${actual_num_pr}

Get list product name thr API
    [Arguments]    ${list_products}
    [Timeout]    3 minutes
    ${endpoint_danhmuc_hh_co_dvt}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${get_resp_danhmuc_hh}    Get Request and return body    ${endpoint_danhmuc_hh_co_dvt}
    ${list_prs_name}      Create List
    :FOR      ${item_pr}      IN ZIP      ${list_products}
    \     ${jsonpath_productname}    Format String    $..Data[?(@.Code=="{0}")].FullName    ${item_pr}
    \     ${productname}    Get data from response json    ${get_resp_danhmuc_hh}    ${jsonpath_productname}
    \     Append To List    ${list_prs_name}    ${productname}
    Return From Keyword    ${list_prs_name}

Get list lots onhand by unit in tab Lo - HSD frm API
    [Arguments]    ${input_product}    ${list_tenlo}    ${input_product_cb}
    [Documentation]    get tồn kho của lô theo dvt ở tab Lô - HSD
    [Timeout]    5 minutes
    ${endpoint_pr}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${resp_pr}    Get Request and return body    ${endpoint_pr}
    ${jsonpath_id_sp}    Format String    $..Data[?(@.Code=="{0}")].Id    ${input_product_cb}
    ${get_id_sp}    Get data from response json    ${resp_pr}    ${jsonpath_id_sp}
    ${jsonpath_dvqd}    Format String    $.Data[?(@.Code == "{0}")].ConversionValue    ${input_product}
    ${get_dvqd}    Get data from response json    ${resp_pr}    ${jsonpath_dvqd}
    ${endpoint_batchexpire}    Format String    ${endpoint_batchexpire_dvt}    ${get_id_sp}    ${get_dvqd}
    ${resp_lo}      Get Request and return body    ${endpoint_batchexpire}
    ${list_ton_lo}    Create List
    :FOR    ${item_lo}      IN ZIP      ${list_tenlo}
    \     ${item_lo}    Convert To String    ${item_lo}
    \     ${item_lo}    Replace sq blackets    ${item_lo}
    \     ${jsonpath_onhand_lo}    Format String    $..Data[?(@.BatchName=="{0}")].OnHand    ${item_lo}
    \     ${get_ton_lo}    Get data from response json    ${resp_lo}    ${jsonpath_onhand_lo}
    \     ${get_ton_lo}    Convert To Number    ${get_ton_lo}
    \     ${get_ton_lo}    Evaluate    round(${get_ton_lo}, 3)
    \     Append to list      ${list_ton_lo}    ${get_ton_lo}
    Return From Keyword    ${list_ton_lo}

Assert list values in Stock Card in tab Lo - HSD
    [Arguments]    ${ma_phieu}      ${input_actual_product}      ${input_product}    ${list_toncuoi}    ${list_num}    ${list_tenlo}
    [Documentation]    So sánh giá trị trong thẻ kho tab Lô - HSD
    [Timeout]    5 minutes
    :FOR        ${item_toncuoi}     ${item_num}       ${item_lo}      IN ZIP       ${list_toncuoi}    ${list_num}    ${list_tenlo}
    \       ${soluong_in_thekho}    ${toncuoi_in_thekho}    Get Stock Card Lot in tab Lo - HSD frm API    ${ma_phieu}    ${input_actual_product}    ${input_product}    ${item_lo}
    \       Should Be Equal As Numbers    ${toncuoi_in_thekho}    ${item_toncuoi}
    \       Should Be Equal As Numbers    ${soluong_in_thekho}    ${item_num}

Get list total sale - endingstock incase discount by product list
    [Arguments]    ${list_product}    ${list_soluong}    ${list_ggsp}
    [Timeout]    5 minutes
    ${list_tonkho}    Create List
    ${list_thanhtien}    Create List
    ${list_base_price}    Get list of Baseprice by Product Code    ${list_product}
    ${list_giatri_quydoi}    Get list gia tri quy doi frm product API    ${list_product}
    ${get_list_product_type}    ${list_tonkho_service}    Get list product type and ending stock of service frm API    ${list_product}
    ${list_onhand}    Get list onhand frm API    ${list_product}
    : FOR    ${input_soluong}    ${input_ggsp}    ${get_ton_bf_execute}    ${get_toncuoi_dv_execute}    ${item_giaban}    ${get_product_type}
    ...    IN ZIP    ${list_soluong}    ${list_ggsp}    ${list_onhand}    ${list_tonkho_service}    ${list_base_price}
    ...    ${get_list_product_type}
    \    ${result_toncuoi_hht}    Minus and round 2    ${get_ton_bf_execute}    ${input_soluong}
    \    ${result_toncuoi_dv}    Minus and round 2    ${get_toncuoi_dv_execute}    ${input_soluong}
    \    ${result_toncuoi_cb}    Set Variable If    '${get_product_type}' == '1'    0
    \    ${result_toncuoi_bf}    Set Variable If    '${get_product_type}' == '2'    ${result_toncuoi_hht}    ${result_toncuoi_dv}
    \    ${result_toncuoi}    Set Variable If    '${get_product_type}' == '1'    ${result_toncuoi_cb}    ${result_toncuoi_bf}
    \    ${ressult_giamoi}    Run Keyword If    0 < ${input_ggsp} < 100    Price after % discount product    ${item_giaban}    ${input_ggsp}
    \    ...    ELSE IF    ${input_ggsp} > 100    Minus and round 2    ${item_giaban}    ${input_ggsp}
    \    ...    ELSE    Set Variable    ${item_giaban}
    \    ${result_thanhtien}    Multiplication and round    ${ressult_giamoi}    ${input_soluong}
    \    Append To List    ${list_tonkho}    ${result_toncuoi}
    \    Append To List    ${list_thanhtien}    ${result_thanhtien}
    Return From Keyword    ${list_tonkho}    ${list_thanhtien}

Get list of baseprice and order summary by product code and branch id
    [Arguments]    ${list_product_code}   ${input_ten_branch}
    [Timeout]    3 minute
    ${list_baseprice}    Create List
    ${list_order_summary}    Create List
    ${get_id_branch}    Get BranchID by BranchName    ${input_ten_branch}
    ${endpoint_pr}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${get_id_branch}
    ${get_resp}    Get Request and return body    ${endpoint_pr}
    : FOR    ${item_product}    IN ZIP    ${list_product_code}
    \    ${jsonpath_giaban}    Format String    $..Data[?(@.Code=="{0}")].BasePrice    ${item_product}
    \    ${jsonpath_tong_dh}    Format String    $..Data[?(@.Code=="{0}")].Reserved    ${item_product}
    \    ${get_tong_dh_string}    Get data from response json    ${get_resp}    ${jsonpath_tong_dh}
    \    ${giaban_string}    Get data from response json    ${get_resp}    ${jsonpath_giaban}
    \    ${giaban}    Convert To Number    ${giaban_string}
    \    ${get_ordersummary}    Convert To Number    ${get_tong_dh_string}
    \    Append to list    ${list_baseprice}    ${giaban}
    \    Append to list    ${list_order_summary}    ${get_ordersummary}
    Return From Keyword    ${list_baseprice}    ${list_order_summary}

Get list of order summary by product code and branch id
    [Arguments]    ${list_product_code}   ${input_ten_branch}
    [Timeout]    3 minute
    ${list_order_summary}    Create List
    ${get_id_branch}    Get BranchID by BranchName    ${input_ten_branch}
    ${endpoint_pr}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${get_id_branch}
    ${get_resp}    Get Request and return body    ${endpoint_pr}
    : FOR    ${item_product}    IN ZIP    ${list_product_code}
    \    ${jsonpath_tong_dh}    Format String    $..Data[?(@.Code=="{0}")].Reserved    ${item_product}
    \    ${get_tong_dh_string}    Get data from response json    ${get_resp}    ${jsonpath_tong_dh}
    \    ${get_ordersummary}    Convert To Number    ${get_tong_dh_string}
    \    Append to list    ${list_order_summary}    ${get_ordersummary}
    Return From Keyword    ${list_order_summary}

Get list product and nums imei for warranty
    [Arguments]   ${product_code}   ${nums}
    ${list_pr_imei}    Create List
    ${list_nums_imei}    Create List
    :FOR    ${item}     IN RANGE    ${nums}
    \     Append To List    ${list_nums_imei}      1
    \     Append To List    ${list_pr_imei}   ${product_code}
    Return From Keyword    ${list_pr_imei}    ${list_nums_imei}

Get list component product and nums by combo code
    [Arguments]    ${product_code}
    [Timeout]    3 minute
    ${get_id_product}   Get product id thr API    ${product_code}
    ${endpoint_chitiet_hh}    Format String   ${endpoint_chitiet_hh}    ${get_id_product}
    ${get_list_component_pr}    Get raw data from API    ${endpoint_chitiet_hh}    $..ProductFormulas..MaterialCode
    ${get_list_component_pr_nums}    Get raw data from API    ${endpoint_chitiet_hh}    $..ProductFormulas..Quantity
    Return From Keyword    ${get_list_component_pr}    ${get_list_component_pr_nums}

Get list product and nums for warranty
    [Arguments]    ${list_product}    ${list_nums}    ${list_product_type}
    ${list_product_warranty}    Create List
    ${list_nums_warranty}    Create List
    :FOR    ${product_code}    ${item_nums}   ${product_type}     IN ZIP    ${list_product}    ${list_nums}    ${list_product_type}
    \     ${get_list_pr}    ${get_list_nums}    Run Keyword If    '${product_type}' == 'com'    Get list component product and nums by combo code    ${product_code}
    \     ...   ELSE IF    '${product_type}' == 'imei'    Get list product and nums imei for warranty    ${product_code}    ${item_nums}   ELSE    Log     Ignore
    \     Run Keyword If    '${product_type}' == 'com' or '${product_type}' == 'imei'    Remove Values From List    ${list_product}    ${product_code}
    \     Run Keyword If    '${product_type}' == 'com' or '${product_type}' == 'imei'    Remove Values From List    ${list_nums}    ${item_nums}
    \     Append To List    ${list_product_warranty}     ${get_list_pr}
    \     Append To List    ${list_nums_warranty}     ${get_list_nums}
    ${list_product_warranty}    Convert String to List    ${list_product_warranty}
    ${list_nums_warranty}    Convert String to List    ${list_nums_warranty}
    Remove Values From List    ${list_product_warranty}   None
    Remove Values From List    ${list_nums_warranty}   None
    Log    ${list_product}
    :FOR    ${product_warranty}    ${nums_warranty}    IN ZIP    ${list_product_warranty}    ${list_nums_warranty}
    \    Append To List    ${list_product}    ${product_warranty}
    \    Append To List    ${list_nums}    ${nums_warranty}
    Return From Keyword    ${list_product}    ${list_nums}

Get warranty from product API
    [Arguments]    ${input_id_hh}   ${retailer_id}
    [Timeout]    3 minutes
    ${endpoint_baohanh_baotri_in_product}   Format String   ${endpoint_list_baohanh_in_product}    ${input_id_hh}   ${retailer_id}
    ${resp}  Get Request and return body by other url    ${WARRANTY_API}    ${endpoint_baohanh_baotri_in_product}
    ${get_time_bh_in_pro}    Get raw data from response json    ${resp}    $[?(@.WarrantyType == 1)].NumberTime
    ${get_timetype_bh_in_pro}    Get raw data from response json    ${resp}    $[?(@.WarrantyType == 1)].TimeType
    ${get_time_bt_in_pro}    Get data from response json    ${resp}    $[?(@.WarrantyType == 3)].NumberTime
    ${get_timetype_bt_in_pro}    Get data from response json    ${resp}    $[?(@.WarrantyType == 3)].TimeType
    ${get_time_bt_in_pro}   Convert To Number    ${get_time_bt_in_pro}
    ${get_timetype_bt_in_pro}   Convert To Number    ${get_timetype_bt_in_pro}
    Return From Keyword    ${get_time_bh_in_pro}    ${get_timetype_bh_in_pro}    ${get_time_bt_in_pro}    ${get_timetype_bt_in_pro}

Get warranty from combo product
    [Arguments]    ${input_id_combo}    ${get_retailer_id}
    [Timeout]    3 minutes
    ${get_list_product_component_id}     Get list component product by combo product id    ${input_id_combo}
    ${list_time_bh}   Create List
    ${list_timetype_bh}   Create List
    ${list_time_bt}   Create List
    ${list_timetype_bt}   Create List
    ${get_list_product_id}    Get list product id thr API    ${get_list_product_component_id}
    :FOR    ${item_id_product}   IN    @{get_list_product_id}
    \     ${get_time_bh_in_pro}    ${get_timetype_bh_in_pro}    ${get_time_bt_in_pro}    ${get_timetype_bt_in_pro}    Get warranty from product API    ${item_id_product}    ${get_retailer_id}
    \     Append To List    ${list_time_bh}    ${get_time_bh_in_pro}
    \     Append To List    ${list_timetype_bh}    ${get_timetype_bh_in_pro}
    \     Append To List    ${list_time_bt}    ${get_time_bt_in_pro}
    \     Append To List    ${list_timetype_bt}    ${get_timetype_bt_in_pro}
    Return From Keyword    ${list_time_bh}    ${list_timetype_bh}    ${list_time_bt}   ${list_timetype_bt}

Get list warranty from product API
    [Arguments]    ${list_product}
    [Timeout]    3 minutes
    ${list_time_bh}   Create List
    ${list_timetype_bh}   Create List
    ${list_time_bt}   Create List
    ${list_timetype_bt}   Create List
    ${get_list_product_id}    Get list product id thr API    ${list_product}
    ${get_retailer_id}    Get RetailerID
    :FOR    ${item_id_product}   IN    @{get_list_product_id}
    \     ${get_time_bh_in_pro}    ${get_timetype_bh_in_pro}    ${get_time_bt_in_pro}    ${get_timetype_bt_in_pro}    Get warranty from product API    ${item_id_product}    ${get_retailer_id}
    \     Append To List    ${list_time_bh}    ${get_time_bh_in_pro}
    \     Append To List    ${list_timetype_bh}    ${get_timetype_bh_in_pro}
    \     Append To List    ${list_time_bt}    ${get_time_bt_in_pro}
    \     Append To List    ${list_timetype_bt}    ${get_timetype_bt_in_pro}
    Return From Keyword    ${list_time_bh}    ${list_timetype_bh}    ${list_time_bt}   ${list_timetype_bt}

Validate allow sale status by product code
    [Arguments]    ${input_mahang}    ${input_status_allowsale}
    [Timeout]    3 minutes
    ${endpoint_pr}    Format String    /branchs/{0}/masterproducts?format=json&Includes=ProductAttributes&ForSummaryRow=true&CategoryId=0&AttributeFilter=%5B%5D&ProductKey={1}&ProductTypes=&IsImei=2&IsFormulas=2&IsActive=true&AllowSale=&IsBatchExpireControl=2&ShelvesIds=&TrademarkIds=&StockoutDate=alltime&supplierIds=&take=10&skip=0&page=1&pageSize=10&filter%5Blogic%5D=and    ${BRANCH_ID}    ${input_mahang}
    ${get_resp}    Get Request and return body    ${endpoint_pr}
    ${jsonpath_allowsale}    Format String    $..Data[?(@.Code=="{0}")].AllowsSale    ${input_mahang}
    ${status}    Get data from response json and return false value    ${get_resp}    ${jsonpath_allowsale}
    Run Keyword If    '${input_status_allowsale}' == 'true'    Should Be Equal As Strings    ${status}    True    ELSE    Should Be Equal As Strings    ${status}    False

Get list of unit name have allow sale
    [Arguments]    ${product_code}
    [Timeout]    3 minute
    ${get_product_id}   Get product id thr API    ${product_code}
    ${endpoint_product_detail}    Format String     ${endpoint_unit_info}    ${BRANCH_ID}    ${get_product_id}
    ${get_resp}   Get Request and return body    ${endpoint_product_detail}
    ${list_unit_name}    Get raw data from response json    ${get_resp}    $.Data[?(@.AllowsSale == true)].Unit
    Return From Keyword      ${list_unit_name}

Get list ending stocks frm API
    [Arguments]    ${list_product}    ${list_nums}
    [Timeout]    5 minutes
    ${list_tonkho}    Create List
    ${list_giatri_quydoi}    Get list gia tri quy doi frm product API    ${list_product}
    ${get_list_product_type}    ${list_tonkho_service}    Get list product type and ending stock of service frm API    ${list_product}
    ${get_list_ton_bf_execute}    Get list onhand frm API    ${list_product}
    : FOR    ${item_product}    ${get_soluong_in_dh}   ${get_ton_bf_execute}    ${get_toncuoi_dv_execute}    ${giatri_quydoi}    ${get_product_type}    IN ZIP    ${list_product}
    ...    ${list_nums}    ${get_list_ton_bf_execute}    ${list_tonkho_service}    ${list_giatri_quydoi}    ${get_list_product_type}
    \    ${result_toncuoi}    Run Keyword If    '${giatri_quydoi}' == '1'    Computation and get list ending stock    ${get_ton_bf_execute}    ${get_toncuoi_dv_execute}
    \    ...    ${get_soluong_in_dh}    ${get_product_type}
    \    ...    ELSE    Computation and get list ending stock for unit product    ${item_product}    ${giatri_quydoi}    ${get_soluong_in_dh}
    \    Append To List    ${list_tonkho}    ${result_toncuoi}
    Return From Keyword    ${list_tonkho}

Get list batch expire id frm api
    [Arguments]    ${list_product}    ${list_tenlo}
    [Timeout]    5 minutes
    ${list_batchexpire_id}    Create List
    ${get_list_giatri_quydoi}   Get list gia tri quy doi frm product API    ${list_product}
    ${get_list_product_id}    Get list product id thr API    ${list_product}
    : FOR    ${item_tenlo}    ${get_dvqd}    ${get_id_sp}    IN ZIP    ${list_tenlo}    ${get_list_giatri_quydoi}    ${get_list_product_id}
    \    ${item_tenlo}    Convert To String    ${item_tenlo}
    \    ${item_tenlo}    Replace sq blackets    ${item_tenlo}
    \    ${jsonpath_batchlname}    Format String    $..Data[?(@.BatchName=="{0}")].Id    ${item_tenlo}
    \    ${endpoin_lodate}    Format String    ${endpoint_batchexpire}    ${get_id_sp}    ${get_dvqd}
    \    ${lodate_id}    Get data from API    ${endpoin_lodate}    ${jsonpath_batchlname}
    \    Append To List    ${list_batchexpire_id}    ${lodate_id}
    Return From Keyword    ${list_batchexpire_id}

Set inactive for poduct thr API
    [Arguments]    ${input_mahang}
    ${get_pr_id}    Get product id thr API    ${input_mahang}
    ${request_payload}    Format String   {{"productId":{0},"CompareCode":"PIB10035","IsActive":true,"Branches":[]}}    ${get_pr_id}
    ${endpoint_ngung_kd}      Format String    ${endpoint_ngung_kd}    ${get_pr_id}
    log    ${request_payload}
    Post request thr API    ${endpoint_ngung_kd}    ${request_payload}

Get list onhand lot from list product thr API
    [Arguments]    ${list_product}    ${list_tenlo}
    [Documentation]    get tồn kho lô ở tab Lô - HSD
    [Timeout]    5 minutes
    ${endpoint_pr}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${get_resp}     Get Request and return body    ${endpoint_pr}
    ${list_tonlo}    Create List
    :FOR    ${item_product}   ${item_lo}     IN ZIP      ${list_product}      ${list_tenlo}
    \    ${jsonpath_id_sp_actual}    Format String    $..Data[?(@.Code=="{0}")].Id    ${item_product}
    \    ${jsonpath_id_sp}    Format String    $..Data[?(@.Code=="{0}")].Id    ${item_product}
    \    ${get_id_sp}    Get data from response json    ${get_resp}     ${jsonpath_id_sp}
    \    ${enpoint_batchexpire}    Format String    ${endpoint_batchexpire}    ${get_id_sp}    1
    \    ${item_lo}    Replace sq blackets    ${item_lo}
    \    ${jsonpath_onhand_lo}    Format String    $..Data[?(@.BatchName=="{0}")].OnHand    ${item_lo}
    \    ${get_ton_lo}    Get data from API    ${enpoint_batchexpire}    ${jsonpath_onhand_lo}
    \    ${get_ton_lo}    Convert To Number    ${get_ton_lo}
    \    ${get_ton_lo}    Evaluate    round(${get_ton_lo}, 3)
    \    Append to list     ${list_tonlo}     ${get_ton_lo}
    Return From Keyword    ${list_tonlo}

Get list note frm product API
    [Arguments]    ${list_hanghoa}
    [Timeout]    5 minutes
    ${endpoint_danhmuc_hh_co_dvt}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${get_resp}    Get Request and return body    ${endpoint_danhmuc_hh_co_dvt}
    ${list_tong_dh}    Create List
    : FOR    ${input_mahang}    IN    @{list_hanghoa}
    \    ${jsonpath_tong_dh}    Format String    $..Data[?(@.Code=="{0}")].Reserved    ${input_mahang}
    \    ${get_tong_dh_string}    Get data from response json    ${get_resp}    ${jsonpath_tong_dh}
    \    ${get_ordersummary}    Convert To Number    ${get_tong_dh_string}
    \    Append To List    ${list_tong_dh}    ${get_ordersummary}
    Return From Keyword    ${list_tong_dh}

Get list total sale and order summary frm api
    [Arguments]    ${list_product}    ${list_soluong}
    [Timeout]    3 minutes
    ${list_result_thanhtien}    Create List
    ${list_result_order_summary}    Create List
    ${list_order_summary}    Get list order summary frm product API    ${list_product}
    ${get_list_baseprice}   Get list of Baseprice by Product Code    ${list_product}
    : FOR    ${item_ma_hh}    ${nums}    ${item_baseprice}    ${get_tong_dh}    IN ZIP    ${list_product}    ${list_soluong}    ${get_list_baseprice}    ${list_order_summary}
    \    ${result_tongso_dh}    Sum    ${get_tong_dh}    ${nums}
    \    ${result_thanhtien}    Multiplication and round    ${item_baseprice}    ${nums}
    \    Append To List    ${list_result_thanhtien}    ${result_thanhtien}
    \    Append To List    ${list_result_order_summary}    ${result_tongso_dh}
    Return From Keyword    ${list_result_thanhtien}    ${list_result_order_summary}


Get list total sale and newprice incase discount
    [Arguments]    ${list_product}    ${list_soluong}    ${list_ggsp}   ${list_discount_type}
    [Timeout]    3 minutes
    ${list_result_thanhtien}    Create List
    ${list_newprice}    Create List
    ${get_list_baseprice}    Get list of Baseprice by Product Code    ${list_product}
    : FOR    ${item_ma_hh}    ${nums}    ${input_ggsp}    ${get_giaban_bf_execute}    ${discount_type}    IN ZIP    ${list_product}     ${list_soluong}
    ...    ${list_ggsp}    ${get_list_baseprice}   ${list_discount_type}
    \    ${result_giamoi}    Run Keyword If    '${discount_type}' == 'dis'    Price after % discount product    ${get_giaban_bf_execute}    ${input_ggsp}
    \    ...    ELSE IF    '${discount_type}' == 'disvnd'    Minus and round 2    ${get_giaban_bf_execute}    ${input_ggsp}
    \    ...    ELSE IF    '${discount_type}' == 'changeup' or '${discount_type}' == 'changedown'   Set Variable   ${input_ggsp}
    \    ...    ELSE     Set Variable    ${get_giaban_bf_execute}
    \    ${result_thanhtien}    Multiplication and round    ${result_giamoi}    ${nums}
    \    Append To List    ${list_result_thanhtien}    ${result_thanhtien}
    \    Append To List    ${list_newprice}    ${result_giamoi}
    Return From Keyword    ${list_result_thanhtien}    ${list_newprice}

Get list product type and gia tri quy doi frm API
    [Arguments]    ${list_sp}
    [Timeout]    5 minute
    ${list_product_type}    Create List
    ${list_giatri_quydoi}    Create List
    ${endpoint_hh}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${get_resp}    Get Request and return body    ${endpoint_hh}
    : FOR    ${item_ma_hh}    IN    @{list_sp}
    \    ${jsonpath_giatri_quydoi}    Format String    $.Data[?(@.Code == "{0}")].ConversionValue    ${item_ma_hh}
    \    ${jsonpath_productype}    Format String    $..Data[?(@.Code == '{0}')].ProductType    ${item_ma_hh}
    \    ${get_product_type}    Get data from response json    ${get_resp}    ${jsonpath_productype}
    \    ${get_giatri_quydoi_in_hd}    Get data from response json    ${get_resp}    ${jsonpath_giatri_quydoi}
    \    Append To List    ${list_giatri_quydoi}    ${get_giatri_quydoi_in_hd}
    \    Append To List    ${list_product_type}    ${get_product_type}
    Return From Keyword    ${list_product_type}    ${list_giatri_quydoi}

Assert product info
    [Arguments]    ${input_ma_hd}    ${input_ma_hh}    ${result_toncuoi}    ${product_type}    ${cost_product}    ${result_soluongban}
    :FOR    ${time}     IN RANGE    10
    \     ${num_soluong_in_chungtu}    ${toncuoi_in_chungtu}    Get Stock Card info frm API    ${input_ma_hd}    ${input_ma_hh}
    \     Run Keyword If    '${num_soluong_in_chungtu}'=='${result_soluongban}'    Validate onhand and cost frm API    ${input_ma_hd}    ${input_ma_hh}    ${result_toncuoi}
    \     ...    ${cost_product}    ${num_soluong_in_chungtu}
    \     Exit For Loop If    '${num_soluong_in_chungtu}'=='${result_soluongban}'

Assert unit product info
    [Arguments]    ${input_ma_hd}    ${input_ma_hh}    ${result_toncuoi}    ${get_so_luong_in_hd}    ${get_giatri_quydoi_hh}    ${cost_product}
    ${get_ma_hh_cb}    Get basic product frm unit product    ${input_ma_hh}
    ${result_soluongban}    Multiplication for onhand    ${get_so_luong_in_hd}    ${get_giatri_quydoi_hh}
    :FOR    ${time}     IN RANGE    10
    \     ${num_soluong_in_chungtu}    ${toncuoi_in_chungtu}    Get Stock Card info frm API    ${input_ma_hd}    ${input_ma_hh}
    \     Run Keyword If    '${toncuoi_in_chungtu}'=='${result_toncuoi}'    Validate onhand and cost frm unit product    ${input_ma_hd}    ${input_ma_hh}
    \     ...    ${result_toncuoi}    ${cost_product}    ${get_so_luong_in_hd}    ${get_giatri_quydoi_hh}     ${num_soluong_in_chungtu}
    \     Exit For Loop If    '${toncuoi_in_chungtu}'=='${result_toncuoi}'

Assert list of onhand after order process
    [Arguments]    ${invoice_code}    ${list_product}    ${list_nums}   ${list_result_onhand}
    ${list_product_type}    ${list_giatri_quydoi}    Get list product type and gia tri quy doi frm API    ${list_product}
    ${list_cost_product}     Get list cost frm API by product code    ${list_product}
    : FOR    ${ma_hh}    ${result_toncuoi}    ${item_soluong}    ${get_giatri_quydoi}    ${product_type}    ${cost_product}    IN ZIP    ${list_product}
    ...    ${list_result_onhand}    ${list_nums}    ${list_giatri_quydoi}    ${list_product_type}    ${list_cost_product}
    \    Run Keyword If    '${get_giatri_quydoi}' == '1'    Assert product info    ${invoice_code}    ${ma_hh}    ${result_toncuoi}   ${product_type}    ${cost_product}
    \    ...    ${item_soluong}    ELSE    Assert unit product info    ${invoice_code}    ${ma_hh}    ${result_toncuoi}    ${item_soluong}    ${get_giatri_quydoi}    ${cost_product}

Asssert value on order in Stock Card
    [Arguments]    ${product_id}
    [Timeout]    5 minutes
    ${endpoint_tonkho}    Format String    ${endpoint_onhandbybranch}    ${product_id}
    ${get_resp}    Get Request and return body    ${endpoint_tonkho}
    ${jsonpath_on_order}    Format String    $..Data[?(@.BranchId=={0})].OnOrder    ${BRANCH_ID}
    ${get_on_order}    Get data from response json    ${get_resp}    ${jsonpath_on_order}
    ${get_sl_on_order}    Convert To Number    ${get_on_order}
    Return From Keyword    ${get_sl_on_order}

Get list master product from product code
    [Arguments]   ${list_pr}
    ${list_code}    Create List
    ${endpoint_danhmuc_hh_co_dvt}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${resp}    Get Request and return body    ${endpoint_danhmuc_hh_co_dvt}
    : FOR    ${input_mahang}    IN    @{list_pr}
    \    ${jsonpath_mastercode}    Format String    $..Data[?(@.Code=="{0}")].MasterCode    ${input_mahang}
    \    ${get_master_code}    Get data from response json    ${resp}    ${jsonpath_mastercode}
    \    Append To List    ${list_code}    ${get_master_code}
    Return From Keyword    ${list_code}
