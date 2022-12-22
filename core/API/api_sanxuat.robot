Resource          api_access.robot
Library           StringFormat
Library           DateTime
Resource          api_danhmuc_hanghoa.robot
Resource          api_access.robot
Resource          ../share/computation.robot

*** Variables ***
${endpoint_phieu_sx}     /manufacturing?kvuniqueparam=2020
${endpoint_ds_phieu_sx}     /manufacturing?format=json&Includes=Product&Includes=User&%24inlinecount=allpages
${endpoint_delete_phieu_sx}     /manufacturing/{0}?CompareCode={1}&CompareStatus=1
${endpoint_phieu_sx_detail}      /manufacturing/getitems?format=json&ManufacturingId={0}&ProductFormulaHistoryId={1}      #0: id phieu sx, 1: id product formula history

*** Keywords ***
Get manufacturing id thr API
    [Arguments]      ${input_ma_phieu}
    ${jsonpath_maphieu_id}    Format String    $..Data[?(@.Code=="{0}")].Id    ${input_ma_phieu}
    ${resp}  Get Request and return body       ${endpoint_ds_phieu_sx}
    ${get_id_phieu}    Get data from response json    ${resp}    ${jsonpath_maphieu_id}
    Return From Keyword    ${get_id_phieu}

Delete manufacturing thr API
    [Timeout]   2 mins
    [Arguments]    ${input_ma_phieu}
    ${get_id_phieu}   Get manufacturing id thr API    ${input_ma_phieu}
    ${endpoint_delete_psx}    Format String    ${endpoint_delete_phieu_sx}    ${get_id_phieu}    ${input_ma_phieu}
    Delete request thr API    ${endpoint_delete_psx}

Add manufacturing thr API
    [Arguments]         ${input_ma_sp}      ${input_so_luong}
    ${ma_phieu}      Generate code automatically    SX
    ${get_pr_id}    Get Product ID      ${input_ma_sp}
    ${payload}    Format String    {{"Manufacturing":{{"Id":0,"Code":"{0}","Description":"","Quantity":{1},"Product":{{"__type":"<>f__AnonymousType205`14[[System.Int64, mscorlib],[System.String, mscorlib],[System.String, mscorlib],[System.Decimal, mscorlib],[System.Double, mscorlib],[System.Decimal, mscorlib],[System.Decimal, mscorlib],[System.Nullable`1[[System.Int64, mscorlib]], mscorlib],[System.Double, mscorlib],[System.Boolean, mscorlib],[System.Nullable`1[[System.Byte, mscorlib]], mscorlib],[System.Nullable`1[[System.Int32, mscorlib]], mscorlib],[System.Nullable`1[[System.Boolean, mscorlib]], mscorlib],[System.Nullable`1[[System.Int32, mscorlib]], mscorlib]], KiotViet.Web.Api","Id":{2},"Name":"abc","Code":"SPSX01","BasePrice":50000,"OnHand":100,"Cost":416684.22,"LatestPurchasePrice":0,"Reserved":0,"IsLotSerialControl":false,"ProductType":2,"ProductFormulaHistoryId":"","IsBatchExpireControl":false,"IsWarranty":0}},"Status":1,"ProductId":{2},"ProductCode":"SPSX01","ProductFormulaHistoryId":""}}}}    ${ma_phieu}   ${input_so_luong}     ${get_pr_id}
    log    ${payload}
    Post request thr API      ${endpoint_phieu_sx}    ${payload}
    Return From Keyword    ${ma_phieu}

Get manufacturing id and product formula history id thr API
    [Arguments]      ${input_ma_phieu}
    ${jsonpath_maphieu_id}    Format String    $..Data[?(@.Code=="{0}")].Id    ${input_ma_phieu}
    ${jsonpath_his_id}    Format String    $..Data[?(@.Code=="{0}")].ProductFormulaHistoryId    ${input_ma_phieu}
    ${resp}  Get Request and return body       ${endpoint_ds_phieu_sx}
    ${get_id_phieu}    Get data from response json    ${resp}    ${jsonpath_maphieu_id}
    ${get_id_his}    Get data from response json    ${resp}    ${jsonpath_his_id}
    Return From Keyword    ${get_id_phieu}      ${get_id_his}

Get item by manufacturing code
    [Arguments]     ${input_ma_phieu}
    ${get_id_phieu}     ${get_id_his}     Get manufacturing id and product formula history id thr API    ${input_ma_phieu}
    ${endpoint_manu_detail}     Format String     ${endpoint_phieu_sx_detail}     ${get_id_phieu}     ${get_id_his}
    ${resp}  Get Request and return body       ${endpoint_manu_detail}
    ${get_list_code}      Get data from response json    ${resp}       $.Data..Code
    ${get_list_quantity}      Get data from response json    ${resp}       $.Data..Quantity
    ${get_list_onhand}      Get data from response json    ${resp}       $.Data..Onhand
    Return From Keyword    ${get_list_code}     ${get_list_quantity}    ${get_list_onhand}
