*** Settings ***
Resource          api_access.robot
Resource          api_danhmuc_hanghoa.robot
Resource          api_dathangnhap.robot
Resource          ../share/imei.robot
Resource          ../share/computation.robot
Resource          ../Hang_Hoa/kiemkho_list_action.robot
Library           StringFormat

*** Variables ***
${endpoint_phieukiem_list}    /stocktakes?format=json&Includes=UserCreate&Includes=Branch&Includes=User&%24inlinecount=allpages&CodeKey=&%24top=10&%24filter=(CreatedDate+eq+%27year%27+and+(Status+eq+0+or+Status+eq+1)+and+(Status+eq+0+or+Status+eq+1)+and+(Status+eq+0+or+Status+eq+1))
${endpoint_inventory_count_detailed}    /stocktakes/{0}/details?format=json&Includes=Product    # chi tiết phiếu kiểm bao gồm mã hàng hóa, 0 là Id phiếu kiểm
${endpoint_delete_inventory_code}     /stocktakes/{0}?CompareCode={1}&CompareStatusId=1       #0 is Id, 1 is Code
${value_status_inventorycode_finished}    1    # trạng thái hoàn thành
${value_status_inventorycode_draft}    0    # trạng thái phiếu tạm

*** Keywords ***
Get created inventory code info and assert values
    [Arguments]    ${input_inventory_code}    ${comp_ma_hh}    ${comp_tonkho}    ${comp_thucte}    ${comp_soluong_lech}    ${comp_giatri_lech}
    [Timeout]          5 mins
    [Documentation]    Lấy mã hàng hóa, tồn kho, thực tế, số lượng lệch, giá trị lệch
    ${jsonpath_inventory_id}    Format String    $..Data[?(@.Code=="{0}")].Id    ${input_inventory_code}
    ${get_inventory_count_id}    Get data from API    ${endpoint_phieukiem_list}    ${jsonpath_inventory_id}
    ${endpoint_inventory_count_detail}    Format String    ${endpoint_inventory_count_detailed}    ${get_inventory_count_id}
    ${resp_inventory_count_detail}       Get Request and return body      ${endpoint_inventory_count_detail}
    ${ma_hh}    Get data from response json     ${resp_inventory_count_detail}    $..Data[0].ProductCode
    ${tonkho}    Get data from response json     ${resp_inventory_count_detail}    $..Data[0].SystemCount
    ${thucte}    Get data from response json     ${resp_inventory_count_detail}    $..Data[0].ActualCount
    ${soluong_lech}    Get data from response json     ${resp_inventory_count_detail}    $..Data[0].AdjustmentValue
    ${giatri_lech}    Get data from response json     ${resp_inventory_count_detail}    $..Data[0].Cost
    ${tonkho}    Convert To Number    ${tonkho}
    ${thucte}    Convert To Number    ${thucte}
    ${soluong_lech}    Convert To Number    ${soluong_lech}
    ${giatri_lech}    Convert To Number    ${giatri_lech}
    Should Be Equal    ${ma_hh}    ${comp_ma_hh}
    Should Be Equal As Numbers    ${tonkho}    ${comp_tonkho}
    Should Be Equal As Numbers    ${thucte}    ${comp_thucte}
    Should Be Equal As Numbers    ${soluong_lech}    ${comp_soluong_lech}
    Should Be Equal As Numbers    ${giatri_lech}    ${comp_giatri_lech}

Get and assert info of products in inventory code
    [Arguments]    ${input_inventory_code}    ${comp_ma_hh}    ${comp_tonkho}    ${comp_thucte}    ${comp_soluong_lech}    ${comp_giatri_lech}
    ...    ${index}    ${status}
    [Documentation]    Lấy mã hàng hóa, tồn kho, thực tế, số lượng lệch, giá trị lệch
    [Timeout]          5 mins
    ${jsonpath_inventory_id}    Format String    $..Data[?(@.Code=="{0}")].Id    ${input_inventory_code}
    ${get_inventory_count_id}    Get data from API    ${endpoint_phieukiem_list}    ${jsonpath_inventory_id}
    ${endpoint_inventory_count_detail}    Format String    ${endpoint_inventory_count_detailed}    ${get_inventory_count_id}
    ${get_resp}     Get Request and return body    ${endpoint_inventory_count_detail}
    ${jsonpath_productcode}    Format String    $..Data[{0}].ProductCode    ${index}
    ${jsonpath_onhand}    Format String    $..Data[{0}].SystemCount    ${index}
    ${jsonpath_actualcount}    Format String    $..Data[{0}].ActualCount    ${index}
    ${jsonpath_num_diff}    Format String    $..Data[{0}].AdjustmentValue    ${index}
    ${jsonpath_cost_diff}    Format String    $..Data[{0}].Cost    ${index}
    ${ma_hh}    Get data from response json    ${get_resp}    ${jsonpath_productcode}
    ${tonkho}    Get data from response json    ${get_resp}    ${jsonpath_onhand}
    ${thucte}    Get data from response json    ${get_resp}    ${jsonpath_actualcount}
    ${soluong_lech}    Get data from response json    ${get_resp}    ${jsonpath_num_diff}
    ${giatri_lech}    Get data from response json    ${get_resp}    ${jsonpath_cost_diff}
    ${jsonpath_status}    Format String    $..Data[?(@.Code=="{0}")].Status    ${input_inventory_code}
    ${status_inventorycode}    Get data from API    ${endpoint_phieukiem_list}    ${jsonpath_status}
    ${tonkho}    Convert To Number    ${tonkho}
    ${thucte}    Convert To Number    ${thucte}
    ${soluong_lech}    Convert To Number    ${soluong_lech}
    ${giatri_lech}    Convert To Number    ${giatri_lech}
    Should Be Equal    ${ma_hh}    ${comp_ma_hh}
    Should Be Equal As Numbers    ${tonkho}    ${comp_tonkho}
    Should Be Equal As Numbers    ${thucte}    ${comp_thucte}
    Should Be Equal As Numbers    ${soluong_lech}    ${comp_soluong_lech}
    Should Be Equal As Numbers    ${giatri_lech}    ${comp_giatri_lech}
    Should Be Equal As Numbers    ${status_inventorycode}    ${status}
    Return From Keyword    ${index}

Get and assert info of imei in Inventory
    [Arguments]    ${input_inventory_code}    ${comp_ma_hh}    ${comp_tonkho}    ${comp_thucte}    ${comp_soluong_lech}    ${comp_giatri_lech}
    ...    ${index}    ${status}    @{list_imei}
    [Documentation]    Lấy mã hàng hóa, tồn kho, thực tế, số lượng lệch, giá trị lệch
    [Timeout]          5 mins
    ${jsonpath_inventory_id}    Format String    $..Data[?(@.Code=="{0}")].Id    ${input_inventory_code}
    ${jsonpath_status}    Format String    $..Data[?(@.Code=="{0}")].Status    ${input_inventory_code}
    ${resp_inventory_list}       Get Request and return body       ${endpoint_phieukiem_list}
    ${get_inventory_count_id}   Get data from response json    ${resp_inventory_list}    ${jsonpath_inventory_id}
    ${status_inventorycode}    Get data from response json    ${resp_inventory_list}    ${jsonpath_status}
    ${endpoint_inventory_count_detail}    Format String    ${endpoint_inventory_count_detailed}    ${get_inventory_count_id}
    ${jsonpath_productcode}    Format String    $..Data[{0}].ProductCode    ${index}
    ${jsonpath_onhand}    Format String    $..Data[{0}].SystemCount    ${index}
    ${jsonpath_actualcount}    Format String    $..Data[{0}].ActualCount    ${index}
    ${jsonpath_num_diff}    Format String    $..Data[{0}].AdjustmentValue    ${index}
    ${jsonpath_cost_diff}    Format String    $..Data[{0}].Cost    ${index}
    ${jsonpath_serial_actualcounted}    Format String    $..Data[{0}].SerialNumbers    ${index}
    ${resp_inventory_count_detail}       Get Request and return body      ${endpoint_inventory_count_detail}
    ${ma_hh}    Get data from response json    ${resp_inventory_count_detail}    ${jsonpath_productcode}
    ${tonkho}    Get data from response json    ${resp_inventory_count_detail}    ${jsonpath_onhand}
    ${thucte}    Get data from response json    ${resp_inventory_count_detail}    ${jsonpath_actualcount}
    ${soluong_lech}    Get data from response json    ${resp_inventory_count_detail}    ${jsonpath_num_diff}
    ${giatri_lech}    Get data from response json    ${resp_inventory_count_detail}    ${jsonpath_cost_diff}
    ${list_imei_counted_in_inventory}    Get raw data from response json    ${resp_inventory_count_detail}    ${jsonpath_serial_actualcounted}
    ${list_imei_counted_in_inventory}    Convert To String    ${list_imei_counted_in_inventory}
    ${list_imei_counted_in_inventory}    Replace sq blackets    ${list_imei_counted_in_inventory}
    @{list_imei_counted_in_inventory}    Split String    ${list_imei_counted_in_inventory}    ,
    ${tonkho}    Convert To Number    ${tonkho}
    ${thucte}    Convert To Number    ${thucte}
    ${soluong_lech}    Convert To Number    ${soluong_lech}
    ${giatri_lech}    Convert To Number    ${giatri_lech}
    Should Be Equal    ${ma_hh}    ${comp_ma_hh}
    Should Be Equal As Numbers    ${tonkho}    ${comp_tonkho}
    Should Be Equal As Numbers    ${thucte}    ${comp_thucte}
    Should Be Equal As Numbers    ${soluong_lech}    ${comp_soluong_lech}
    Should Be Equal As Numbers    ${giatri_lech}    ${comp_giatri_lech}
    Should Be Equal As Numbers    ${status_inventorycode}    ${status}
    List Should Contain Sub List    ${list_imei_counted_in_inventory}    ${list_imei}

Get and assert info of imeis in Inventory
    [Arguments]    ${input_inventory_code}    ${comp_ma_hh}    ${comp_tonkho}    ${comp_thucte}    ${comp_soluong_lech}    ${comp_giatri_lech}
    ...    ${index}    ${status}    ${list_imei}
    [Documentation]    Lấy mã hàng hóa, tồn kho, thực tế, số lượng lệch, giá trị lệch
    [Timeout]          5 mins
    ${jsonpath_inventory_id}    Format String    $..Data[?(@.Code=="{0}")].Id    ${input_inventory_code}
    ${jsonpath_status}    Format String    $..Data[?(@.Code=="{0}")].Status    ${input_inventory_code}
    ${resp_inventory_list}       Get Request and return body       ${endpoint_phieukiem_list}
    ${get_inventory_count_id}   Get data from response json    ${resp_inventory_list}    ${jsonpath_inventory_id}
    ${status_inventorycode}    Get data from response json    ${resp_inventory_list}    ${jsonpath_status}
    ${endpoint_inventory_count_detail}    Format String    ${endpoint_inventory_count_detailed}    ${get_inventory_count_id}
    ${jsonpath_productcode}    Format String    $..Data[{0}].ProductCode    ${index}
    ${jsonpath_onhand}    Format String    $..Data[{0}].SystemCount    ${index}
    ${jsonpath_actualcount}    Format String    $..Data[{0}].ActualCount    ${index}
    ${jsonpath_num_diff}    Format String    $..Data[{0}].AdjustmentValue    ${index}
    ${jsonpath_cost_diff}    Format String    $..Data[{0}].Cost    ${index}
    ${jsonpath_serial_actualcounted}    Format String    $..Data[{0}].SerialNumbers    ${index}
    ${resp_inventory_count_detail}       Get Request and return body      ${endpoint_inventory_count_detail}
    ${ma_hh}    Get data from response json    ${resp_inventory_count_detail}    ${jsonpath_productcode}
    ${tonkho}    Get data from response json    ${resp_inventory_count_detail}    ${jsonpath_onhand}
    ${actual_num}    Get data from response json   ${resp_inventory_count_detail}    ${jsonpath_actualcount}
    ${soluong_lech}    Get data from response json    ${resp_inventory_count_detail}    ${jsonpath_num_diff}
    ${giatri_lech}    Get data from response json    ${resp_inventory_count_detail}    ${jsonpath_cost_diff}
    ${list_imei_counted_in_inventory}    Get raw data from response json    ${resp_inventory_count_detail}    ${jsonpath_serial_actualcounted}
    ${list_imei_counted_in_inventory}    Convert String to List   ${list_imei_counted_in_inventory}
    Log Many    @{list_imei_counted_in_inventory}
    ${list_imei}    Convert String to List    ${list_imei}
    ${tonkho}    Convert To Number    ${tonkho}
    ${actual_num}    Convert To Number    ${actual_num}
    ${soluong_lech}    Convert To Number    ${soluong_lech}
    ${giatri_lech}    Convert To Number    ${giatri_lech}
    Should Be Equal    ${ma_hh}    ${comp_ma_hh}
    Should Be Equal As Numbers    ${tonkho}    ${comp_tonkho}
    Should Be Equal As Numbers    ${actual_num}    ${comp_thucte}
    Should Be Equal As Numbers    ${soluong_lech}    ${comp_soluong_lech}
    Should Be Equal As Numbers    ${giatri_lech}    ${comp_giatri_lech}
    Should Be Equal As Numbers    ${status_inventorycode}    ${status}
    List Should Contain Sub List    ${list_imei_counted_in_inventory}    ${list_imei}

Get and assert info in Inventory
    [Arguments]    ${inventory_code}    ${list_product_codes}    ${list_system_count}    ${list_currentquan}       ${status}
    [Documentation]    Lấy ra list sản phẩm, tồn thực tế, tồn ghi nhận trong hệ thống và so sánh. Validate trạng thái
    [Timeout]          5 mins
    ${jsonpath_inventory_id}    Format String    $..Data[?(@.Code=="{0}")].Id    ${inventory_code}
    ${jsonpath_status}    Format String    $..Data[?(@.Code=="{0}")].Status    ${inventory_code}
    ${resp_inventory_list}       Get Request and return body       ${endpoint_phieukiem_list}
    ${get_inventory_count_id}   Get data from response json    ${resp_inventory_list}    ${jsonpath_inventory_id}
    ${status_inventorycode}    Get data from response json    ${resp_inventory_list}    ${jsonpath_status}
    ${endpoint_inventory_count_detail}    Format String    ${endpoint_inventory_count_detailed}    ${get_inventory_count_id}
    ${resp_inventory_count_detail}       Get Request and return body      ${endpoint_inventory_count_detail}
    ${list_product_codes_inventory}    Get raw data from response json    ${resp_inventory_count_detail}      $..ProductCode
    ${list_actualcount_inventory}    Get raw data from response json   ${resp_inventory_count_detail}    $..ActualCount
    ${list_systemquan_inventory}    Get raw data from response json    ${resp_inventory_count_detail}    $..SystemCount
    Log       ${list_currentquan}
    Log       ${list_system_count}
    ${list_system_count}       Evaluate     list(map(int, $list_system_count))
    ${list_currentquan}       Evaluate     list(map(int, $list_currentquan))
    List Should Contain Sub List    ${list_product_codes_inventory}    ${list_product_codes}
    List Should Contain Sub List   ${list_systemquan_inventory}    ${list_system_count}
    List Should Contain Sub List    ${list_actualcount_inventory}    ${list_currentquan}
    Should Be Equal As Numbers    ${status_inventorycode}    ${status}


Add new inventory frm api
    [Arguments]    ${dict_product_nums}
    ${list_products}    Get Dictionary Keys    ${dict_product_nums}
    ${list_nums}    Get Dictionary Values    ${dict_product_nums}
    ${get_id_nguoiban}    Get User ID
    ${get_list_product_id}    Get list product id thr API    ${list_products}
    ${get_list_status_imei}   Get list imei status thr API    ${list_products}
    ${ma_phieukiem}    Generate code automatically    PKK
    # Post request BH
    ${liststring_prs_inventory_detail}    Set Variable    needdel
    Log    ${liststring_prs_inventory_detail}
    : FOR    ${item_product_id}    ${item_num}    ${status_imei}    IN ZIP    ${get_list_product_id}    ${list_nums}    ${get_list_status_imei}
    \    ${count}     Set Variable If    '${status_imei}' =='true'    null      1
    \    ${payload_each_product}    Format string    {{\\"ProductName\\":\\"Giỏ đựng quà\\",\\"ProductId\\":0,\\"Count\\":{0},\\"Icon\\":\\"fa-edit\\",\\"Serials\\":\\"\\",\\"ActionName\\":\\"typ\\"}},{{\\"ProductName\\":\\"Giỏ đựng quà\\",\\"ProductId\\":{1},\\"Count\\":{2},\\"Icon\\":\\"fa-add\\",\\"Serials\\":\\"\\",\\"ActionName\\":\\"add\\"}}    ${item_num}    ${item_product_id}
    \    ...    ${count}
    \    ${liststring_prs_inventory_detail}    Catenate    SEPARATOR=,    ${liststring_prs_inventory_detail}    ${payload_each_product}
    Log    ${liststring_prs_inventory_detail}
    ${liststring_prs_inventory_detail}    Replace String    ${liststring_prs_inventory_detail}    needdel,    ${EMPTY}    count=1
    ###
    ${liststring_prs_inventory_detail1}    Set Variable    needdel
    ${index_actualnums}    Set Variable    -1
    Log    ${liststring_prs_inventory_detail1}
    : FOR    ${item_product_id}    ${item_num}    IN ZIP    ${get_list_product_id}    ${list_nums}
    \    ${index_actualnums}    Evaluate    ${index_actualnums} + 1
    \    ${payload_each_product1}    Format string    {{"Id":0,"ProductId":{0},"ActualCount":{1},"ProductName":"Giỏ đựng quà","ProductCode":"PIB05","IsDraft":false,"ConversionValue":1,"OrderByNumber":{2}}}    ${item_product_id}    ${item_num}
    \    ...    ${index_actualnums}
    \    ${liststring_prs_inventory_detail1}    Catenate    SEPARATOR=,    ${liststring_prs_inventory_detail1}    ${payload_each_product1}
    Log    ${liststring_prs_inventory_detail1}
    ${liststring_prs_inventory_detail1}    Replace String    ${liststring_prs_inventory_detail1}    needdel,    ${EMPTY}    count=1
    ${request_payload}    Format String    {{"IsAdjust":true,"StockTake":{{"CreatedBy":{0},"BranchId":{1},"Id":0,"Code":"{2}","CreatedDate":"","Description":"","RecentHistory":"[{3}]"}},"StockTakeDetail":[{4}],"StockTakeDetailLargeData":null,"CompareIsAjust":false}}    ${get_id_nguoiban}    ${BRANCH_ID}      ${ma_phieukiem}    ${liststring_prs_inventory_detail}
    ...    ${liststring_prs_inventory_detail1}
    Log    ${request_payload}
    Post request to create inventory and get resp    ${request_payload}
    Return From Keyword    ${ma_phieukiem}

Post request to create inventory and get resp
    [Arguments]    ${request_payload}
    [Timeout]    3 minutes
    Post request thr API    /stocktakes    ${request_payload}

Get Inventory code id thr API
    [Arguments]    ${input_inventory_code}
    [Timeout]          2 mins
    ${jsonpath_inventory_id}    Format String    $..Data[?(@.Code=="{0}")].Id    ${input_inventory_code}
    ${get_inventory_count_id}    Get data from API    ${endpoint_phieukiem_list}    ${jsonpath_inventory_id}
    Return From Keyword    ${get_inventory_count_id}

Delete Inventory code in Inventory Counting List
    [Arguments]    ${input_inventory_code}
    [Timeout]          5 mins
    ${jsonpath_inventory_id}    Format String    $..Data[?(@.Code=="{0}")].Id    ${input_inventory_code}
    ${get_inventory_count_id}    Get data from API    ${endpoint_phieukiem_list}    ${jsonpath_inventory_id}
    ${endpoint_inventory_del_inventorycode}    Format String    ${endpoint_delete_inventory_code}    ${get_inventory_count_id}    ${input_inventory_code}
    Delete request thr API    ${endpoint_inventory_del_inventorycode}

Get Cost and string-lot OnHand frm API
    [Arguments]    ${input_mahang}
    [Timeout]    3 minute
    ${dvqd}    Get DVQD by product code frm API    ${input_mahang}
    ${get_dvqd}    Convert To Number    ${dvqd}
    ${endpoint_pr}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${jsonpath_giavon}    Format String    $..Data[?(@.Code=="{0}")].Cost    ${input_mahang}
    ${jsonpath_ton}    Format String    $..Data[?(@.Code=="{0}")].OnHand    ${input_mahang}
    ${jsonpath_productid}    Format String    $..Data[?(@.Code=="{0}")].Id    ${input_mahang}
    ${resp_product_list}    Get Request and return body    ${endpoint_pr}
    ${get_product_id}    Get data from response json    ${resp_product_list}    ${jsonpath_productid}
    ${endpoint_lo_tab_by_productid}    Format String    ${endpoint_hanglodate}    ${get_product_id}    ${get_dvqd}
    ${list_lo}    Get raw data from API    ${endpoint_lo_tab_by_productid}    $..Data..BatchName
    ${giavon}    Get data from response json    ${resp_product_list}    ${jsonpath_giavon}
    ${ton}    Get data from response json    ${resp_product_list}    ${jsonpath_ton}
    Return From Keyword    ${giavon}    ${ton}    ${list_lo}

Get and assert info of lots in Inventory
    [Arguments]    ${input_inventory_code}    ${comp_ma_hh}    ${comp_tonkho}    ${comp_thucte}    ${comp_soluong_lech}    ${comp_giatri_lech}
    ...    ${index}    ${status}    ${list_imei}
    [Documentation]    Lấy mã hàng hóa, tồn kho, thực tế, số lượng lệch, giá trị lệch
    [Timeout]          5 mins
    ${jsonpath_inventory_id}    Format String    $..Data[?(@.Code=="{0}")].Id    ${input_inventory_code}
    ${jsonpath_status}    Format String    $..Data[?(@.Code=="{0}")].Status    ${input_inventory_code}
    ${resp_inventory_list}       Get Request and return body       ${endpoint_phieukiem_list}
    ${get_inventory_count_id}   Get data from response json    ${resp_inventory_list}    ${jsonpath_inventory_id}
    ${status_inventorycode}    Get data from response json    ${resp_inventory_list}    ${jsonpath_status}
    ${endpoint_inventory_count_detail}    Format String    ${endpoint_inventory_count_detailed}    ${get_inventory_count_id}
    ${jsonpath_productcode}    Format String    $..Data[{0}].ProductCode    ${index}
    ${jsonpath_onhand}    Format String    $..Data[{0}].SystemCount    ${index}
    ${jsonpath_actualcount}    Format String    $..Data[{0}].ActualCount    ${index}
    ${jsonpath_num_diff}    Format String    $..Data[{0}].AdjustmentValue    ${index}
    ${jsonpath_cost_diff}    Format String    $..Data[{0}].Cost    ${index}
    ${jsonpath_serial_actualcounted}    Format String    $..Data[{0}]..BatchName    ${index}
    ${resp_inventory_count_detail}       Get Request and return body      ${endpoint_inventory_count_detail}
    ${ma_hh}    Get data from response json    ${resp_inventory_count_detail}    ${jsonpath_productcode}
    ${tonkho}    Get data from response json    ${resp_inventory_count_detail}    ${jsonpath_onhand}
    ${actual_num}    Get data from response json   ${resp_inventory_count_detail}    ${jsonpath_actualcount}
    ${soluong_lech}    Get data from response json    ${resp_inventory_count_detail}    ${jsonpath_num_diff}
    ${giatri_lech}    Get data from response json    ${resp_inventory_count_detail}    ${jsonpath_cost_diff}
    ${list_imei_counted_in_inventory}    Get raw data from response json    ${resp_inventory_count_detail}    ${jsonpath_serial_actualcounted}
    ${list_imei_counted_in_inventory}    Convert String to List   ${list_imei_counted_in_inventory}
    Log Many    @{list_imei_counted_in_inventory}
    ${list_imei}    Convert String to List    ${list_imei}
    ${tonkho}    Convert To Number    ${tonkho}
    ${actual_num}    Convert To Number    ${actual_num}
    ${soluong_lech}    Convert To Number    ${soluong_lech}
    ${giatri_lech}    Convert To Number    ${giatri_lech}
    Should Be Equal    ${ma_hh}    ${comp_ma_hh}
    Should Be Equal As Numbers    ${tonkho}    ${comp_tonkho}
    Should Be Equal As Numbers    ${actual_num}    ${comp_thucte}
    Should Be Equal As Numbers    ${soluong_lech}    ${comp_soluong_lech}
    Should Be Equal As Numbers    ${giatri_lech}    ${comp_giatri_lech}
    Should Be Equal As Numbers    ${status_inventorycode}    ${status}
    List Should Contain Sub List    ${list_imei_counted_in_inventory}    ${list_imei}

Assert lot avaiable in Lo-HSD tab
    [Arguments]    ${input_mahang}    ${list_counted_lots}
    [Documentation]    so sánh list lô input có tồn tại trong list lô đc get ra từ hàng hóa hay không
    [Timeout]    3 minute
    ${dvqd}    Get DVQD by product code frm API    ${input_mahang}
    ${get_dvqd}    Convert from number to interger    ${dvqd}
    ${mahang}    Run Keyword If    ${dvqd}!=1    Get basic product frm unit product    ${input_mahang}    ELSE     Set Variable    ${input_mahang}
    ${endpoint_pr}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${jsonpath_productid}    Format String    $..Data[?(@.Code=="{0}")].Id    ${mahang}
    ${get_product_id}    Get data from API    ${endpoint_pr}    ${jsonpath_productid}
    ${endpoint_lo_tab_by_productid}    Format String    ${endpoint_hanglodate}    ${get_product_id}    ${get_dvqd}
    ${list_lo}    Get raw data from API    ${endpoint_lo_tab_by_productid}    $..Data..BatchName
    List Should Contain Sub List    ${list_lo}    ${list_counted_lots}

Assert values in Stock Card of unit prs
    [Arguments]    ${ma_phieu}    ${input_mahang}    ${input_toncuoi}    ${input_num_instock}
    [Timeout]    3 minute
    ${dvqd}    Get DVQD by product code frm API    ${input_mahang}
    ${ma_hh}    Run Keyword If    ${dvqd}==1    Set Variable    ${input_mahang}    ELSE    Get basic product frm unit product    ${input_mahang}
    ${soluong_in_thekho1}    ${toncuoi_in_thekho1}    Get Stock Card info frm API    ${ma_phieu}    ${ma_hh}
    ${soluong_in_thekho}    Run Keyword If    ${dvqd}!=1    Divide OnHand    ${soluong_in_thekho1}    ${dvqd}    ELSE    Set Variable    ${soluong_in_thekho1}
    ${toncuoi_in_thekho}    Run Keyword If    ${dvqd}!=1    Divide OnHand    ${toncuoi_in_thekho1}    ${dvqd}    ELSE    Set Variable    ${toncuoi_in_thekho1}
    Should Be Equal As Numbers    ${toncuoi_in_thekho}    ${input_toncuoi}
    Should Be Equal As Numbers    ${soluong_in_thekho}    ${input_num_instock}
