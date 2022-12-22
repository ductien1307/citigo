*** Settings ***
Resource          api_hoadon_banhang.robot
Resource          api_access.robot
Resource          api_phieu_nhap_hang.robot
Resource          ../share/computation.robot
Resource          api_danhmuc_hanghoa.robot
Resource          ../share/computation.robot

*** Variables ***
${endpoint_addproduct}    /products/addmany
${endpoint_tab_thanhphan}     /formula?format=json&Includes=Material&%24inlinecount=allpages&%24top=10&%24filter=ProductId+eq+{0}

*** Keywords ***
Create basic product thr API
    ${product_group_name}      Set Variable      Đồ ăn vặt
    ${cat_id}    Hanghoa.Get category ID    ${product_group_name}
    ${product_code}      Generate code automatically    HH
    ${baseprice}     Set Variable    78900
    ${product_name}      Set Variable    Hàng hóa test
    ${format_data}    Format String    "Id":0,"ProductType":2,"CategoryId":{0},"CategoryName":"","isActive":false,"VariantCount":0,"AllowsSale":true,"isDeleted":false,"Code":"{1}","BasePrice":{2},"Cost":38000,"LatestPurchasePrice":0,"OnHand":40,"OnHandCompareMin":0,"OnHandCompareMax":0,"CompareOnHand":0,"CompareCost":0,"CompareBasePrice":0,"CompareCode":"","CompareUnit":"","Reserved":0,"MinQuantity":0,"MaxQuantity":999999999,"CustomId":0,"CustomValue":0,"MasterProductId":0,"Unit":"","ConversionValue":1,"OrderTemplate":"","IsLotSerialControl":false,"IsRewardPoint":false,"ProductFormulas":[],"Name":"{3}","ListPriceBookDetail":[],"ProductImages":[]    ${cat_id}    ${product_code}    ${baseprice}    ${product_name}
    log    ${format_data}
    ${data}    Evaluate    (None, '[{${format_data}}]')
    ${payload}    Create Dictionary    ListProducts=${data}
    Log    ${payload}
    Post request data form thr API    ${endpoint_addproduct}    ${payload}
    Return From Keyword    ${product_code}

Create imei product thr API
     ${product_code}    Create basic product thr API
     ${get_user_id}    Get User ID
     ${get_product_id}      Get Product Id
     ${list_imei}     Import multi imei for product    ${product_code}    2
     Return From Keyword    ${product_code}     ${list_imei}

Generate list of products and quantities automatically
    [Arguments]       ${product_quantity}
    ${list_product_code}       Create list
    ${list_product_quantity}       Create list
    : FOR    ${item}    IN RANGE     ${product_quantity}
    \    ${product_code}     Create basic product thr API
    \    ${quantity}      Set Variable    2
    \    Append to List       ${list_product_code}       ${product_code}
    \    Append to List       ${list_product_quantity}       ${quantity}
    Return From Keyword    ${list_product_code}       ${list_product_quantity}

Get list product type and imei status frm API
    [Arguments]    ${list_sp}
    [Timeout]    5 minute
    ${list_product_type}    Create List
    ${list_imei_status}     Create List
    ${endpoint_hh}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${get_resp}    Get Request and return body    ${endpoint_hh}
    : FOR    ${item_ma_hh}    IN      @{list_sp}
    \    ${jsonpath_productype}    Format String    $..Data[?(@.Code == '{0}')].ProductType    ${item_ma_hh}
    \    ${get_product_type}    Get data from response json    ${get_resp}    ${jsonpath_productype}
    \    ${jsonpath_imei_status}    Format String    $..Data[?(@.Code=="{0}")].IsLotSerialControl    ${item_ma_hh}
    \    ${get_imei_status}    Get data from response json    ${get_resp}    ${jsonpath_imei_status}
    \    Append To List    ${list_imei_status}    ${get_imei_status}
    \    Append To List    ${list_product_type}    ${get_product_type}
    Return From Keyword    ${list_product_type}     ${list_imei_status}

Get list product reward point frm API
    [Arguments]    ${list_sp}
    [Timeout]    5 minute
    ${list_pr_point}    Create List
    ${endpoint_hh}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${get_resp}    Get Request and return body    ${endpoint_hh}
    : FOR    ${item_ma_hh}    IN      @{list_sp}
    \    ${jsonpath_pr_point}    Format String    $..Data[?(@.Code == '{0}')].RewardPoint    ${item_ma_hh}
    \    ${jsonpath_pr_point_status}    Format String    $..Data[?(@.Code == '{0}')].IsRewardPoint      ${item_ma_hh}
    \    ${get_product_point}    Get data from response json    ${get_resp}    ${jsonpath_pr_point}
    \    ${get_product_point_status}    Get data from response json    ${get_resp}    ${jsonpath_pr_point_status}
    \    ${result_point}      Set Variable If    '${get_product_point_status}'=='True'      ${get_product_point}    0
    \    Append To List    ${list_pr_point}    ${result_point}
    Return From Keyword    ${list_pr_point}

Get list product status point frm API
    [Arguments]    ${list_sp}
    [Timeout]    5 minute
    ${list_pr_point_status}    Create List
    ${endpoint_hh}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${get_resp}    Get Request and return body    ${endpoint_hh}
    : FOR    ${item_ma_hh}    IN      @{list_sp}
    \    ${jsonpath_pr_point_status}    Format String    $..Data[?(@.Code == '{0}')].IsRewardPoint      ${item_ma_hh}
    \    ${get_product_point_status}    Get data from response json and return false value      ${get_resp}    ${jsonpath_pr_point_status}
    \    Append To List    ${list_pr_point_status}    ${get_product_point_status}
    Return From Keyword    ${list_pr_point_status}

Delete product by product id thr API
    [Arguments]    ${product_id}
    [Timeout]    3 minutes
    ${endpoint_delete_prd}    Format String    ${endpoint_delete_product}    ${product_id}
    Delete request thr API    ${endpoint_delete_prd}

Delete product if product is visible thr API
    [Arguments]    ${input_prd_code}
    [Timeout]    3 minutes
    ${get_pr_id}    Get product ID    ${input_prd_code}
    Run Keyword If    '${get_pr_id}'=='0'    Log    Ignore pr    ELSE       Delete product by product id thr API    ${get_pr_id}

Delete category if category is exist thr API
    [Arguments]     ${nhom_hang}
    ${get_id_nh}    Get category ID      ${nhom_hang}
    Run Keyword If    '${get_id_nh}'=='0'    Log    Ignore cat    ELSE       Delete category thr API    ${nhom_hang}

Delete list product if list product is visible thr API
    [Arguments]    ${list_product}
    [Timeout]    3 minutes
    ${get_list_pr_id}    Get list product id thr API      ${list_product}
    :FOR      ${item_pr_id}      IN ZIP    ${get_list_pr_id}
    \     Run Keyword If    '${item_pr_id}'=='0'    Log    Ignore pr    ELSE      Delete product by product id thr API    ${item_pr_id}

Add manufacture product thr API
    [Arguments]    ${ui_product_code}    ${ui_product_name}    ${tennhom}    ${giavon}    ${giaban}    ${ma_hang_thanh_phan}    ${soluong}
    ${cat_id}    Get category ID    ${tennhom}
    Log    ${cat_id}
    ${pro_id}    Get product id thr API    ${ma_hang_thanh_phan}
    ${object}    Generate Random String     4    [NUMBERS]
    ${format_data}    Format String    "Id":0,"ProductType":2,"CategoryId":{0},"CategoryName":"","isActive":false,"VariantCount":0,"AllowsSale":true,"isDeleted":false,"Code":"{1}","BasePrice":{2},"Cost":{3},"LatestPurchasePrice":0,"OnHand":0,"OnOrder":0,"OnHandCompareMin":0,"OnHandCompareMax":0,"CompareOnHand":0,"CompareCost":0,"CompareBasePrice":0,"CompareCode":"","CompareBarcode":"","CompareUnit":"","Reserved":0,"ActualReserved":0,"MinQuantity":0,"MaxQuantity":999999999,"CustomId":0,"CustomValue":0,"MasterProductId":0,"Unit":"","ConversionValue":1,"OrderTemplate":"","IsLotSerialControl":false,"IsRewardPoint":false,"ProductFormulas":[{{"MaterialId":{5},"MaterialName":"Ấm đun KBO2001","MaterialCode":"{6}","Quantity":{7},"Cost":1050000,"BasePrice":1650000,"$$hashKey":"object:{8}"}}],"Name":"{4}","ListPriceBookDetail":[],"ProductFormulasOld":[],"ProductImages":[],"IsWarranty":0
    ...    ${cat_id}    ${ui_product_code}    ${giavon}    ${giaban}    ${ui_product_name}    ${pro_id}    ${ma_hang_thanh_phan}    ${soluong}    ${object}
    Log    ${format_data}
    ${data}    Evaluate    (None,'[{${format_data}}]')
    ${branch_pr_cost}   Set Variable    "Id":${BRANCH_ID},"Name":"Chi nhánh trung tâm"
    ${branch_pr_cost}     Evaluate    (None, '[{${branch_pr_cost}}]')
    ${payload}    Create Dictionary    ListProducts=${data}     BranchForProductCosts=${branch_pr_cost}
    Log    ${payload}
    Post request data form thr API    /products/addmany    ${payload}
    ${endpoint_pr}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${jsonpath_product_id}    Format String    $..Data[?(@.Code=="{0}")].Id    ${ui_product_code}
    ${get_product_id}    Get data from API    ${endpoint_pr}    ${jsonpath_product_id}
    Return From Keyword    ${get_product_id}

Add product by product type thr API
    [Arguments]      ${loai_hh}   ${ma_hh}    ${ten_sp}   ${nhom_hang}   ${gia_ban}  ${gia_von}  ${ton}     ${sp_1}   ${sl_1}   ${sp_2}   ${sl_2}
    Run Keyword If   '${loai_hh}'=='pro'    Add product thr API   ${ma_hh}    ${ten_sp}    ${nhom_hang}   ${gia_ban}    ${gia_von}     ${ton}     ELSE IF   '${loai_hh}'=='imei'      Add imei product thr API    ${ma_hh}    ${ten_sp}    ${nhom_hang}   ${gia_ban}
    ...     ELSE IF     '${loai_hh}'=='lodate'     Add lodate product thr API    ${ma_hh}    ${ten_sp}   ${nhom_hang}   ${gia_ban}     ELSE IF     '${loai_hh}'=='service'      Add service   ${ma_hh}    ${ten_sp}   ${nhom_hang}   ${gia_ban}   ${gia_von}
    ...     ELSE IF     '${loai_hh}'=='combo'     Add combo and wait    ${ma_hh}    ${ten_sp}   ${nhom_hang}   ${gia_ban}     ${sp_1}   ${sl_1}   ${sp_2}   ${sl_2}     ELSE IF     '${loai_hh}'=='unit'      Add product incl 1 unit thrAPI    ${ma_hh}    ${ten_sp}    ${nhom_hang}    ${gia_ban}    ${gia_von}    ${ton}
    ...    cái    hộp    ${sl_1}    ${gia_ban}    ${sp_1}     ELSE    Add product manufacturing    ${ma_hh}    ${ten_sp}   ${nhom_hang}      ${gia_ban}   ${ton}    ${sp_1}   ${sl_1}     ${sp_2}   ${sl_2}

Get list product infor thr API
    [Arguments]    ${input_mahang}
    [Timeout]    3 minutes
    ${endpoint_danhmuc_hh_co_dvt}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${get_resp_danhmuc_hh}    Get Request and return body    ${endpoint_danhmuc_hh_co_dvt}
    #${jsonpath_productname}    Format String    $..Data[?(@.Code=="{0}")].FullName    ${input_mahang}
    #${jsonpath_baseprice}    Format String    $..Data[?(@.Code=="{0}")].BasePrice    ${input_mahang}
    #${productname}    Get data from response json    ${get_resp_danhmuc_hh}    ${jsonpath_productname}
    #${baseprice}    Get data from response json    ${get_resp_danhmuc_hh}    ${jsonpath_baseprice}
    ${list_product_infor}     Get value from json     ${get_resp_danhmuc_hh}       $..Data[?(@.Code=="${input_mahang}")].Id,FullName,CategoryId,BasePrice,Cost,OnHand
    ${list_product_infor}     Convert list to be inputed data     ${list_product_infor}
    Return From Keyword    ${list_product_infor}

Update product thr API
    [Arguments]     ${loai_hh}   ${ma_hh}  ${ma_hh_up}   ${gia_ban}      ${ton_kho}
    ${list_product_infor}     Get list product infor thr API      ${ma_hh}
    ${ma_hh_up}     Set Variable If    '${ma_hh_up}'=='none'    ${ma_hh}      ${ma_hh_up}
    ${gia_ban}     Set Variable If    '${gia_ban}'=='none'     ${list_product_infor[3]}     ${gia_ban}
    ${ton_kho}     Set Variable If    '${ton_kho}'=='none'     ${list_product_infor[5]}     ${ton_kho}
    ${pro_type}     Run Keyword If  '${loai_hh}'=='service'     Set Variable    3   ELSE IF   '${loai_hh}'=='combo'     Set Variable    1   ELSE    Set Variable    2
    ${is_serial}    Set Variable If    '${loai_hh}'=='imei'    true       false
    ${is_lodate}    Set Variable If    '${loai_hh}'=='lodate'    true       false
    ${format_data}    Set Variable      "Id":${list_product_infor[0]},"ProductType":2,"CategoryId":${list_product_infor[2]},"CategoryName":"","isActive":true,"HasVariants":false,"VariantCount":0,"AllowsSale":true,"isDeleted":false,"Name":"${list_product_infor[1]}","FullName":"${list_product_infor[1]}","Code":"${ma_hh_up}","Description":"","BasePrice":${gia_ban},"Cost":${list_product_infor[4]},"LatestPurchasePrice":0,"OnHand":${ton_kho},"OnOrder":0,"OnHandCompareMin":0,"OnHandCompareMax":0,"CompareOnHand":${list_product_infor[5]},"CompareCost":${list_product_infor[4]},"CompareBasePrice":${list_product_infor[3]},"CompareCode":"${ma_hh}","CompareName":"${list_product_infor[1]}","CompareUnit":"","CompareProductShelves":[],"Reserved":0,"ActualReserved":0,"MinQuantity":0,"MaxQuantity":999999999,"CustomId":0,"CustomValue":0,"Unit":"","ConversionValue":1,"OrderTemplate":"","ProductAttributes":[],"ProductShelves":[],"ProductUnits":[],"IsLotSerialControl":${is_serial},"IsRewardPoint":false,"IsBatchExpireControl":${is_lodate},"FormulaCount":0,"TradeMarkName":"","MasterCode":"","GenuineGuarantees":[],"StoreGuarantees":[],"RepeatGuarantee":{"Uuid":-1,"TimeType":2,"ProductId":${list_product_infor[0]},"RetailerId":20201,"Description":"Toàn bộ sản phẩm"},"GuaranteesToDelete":[],"ProductFormulas":[],"ProductFormulasOld":[],"ProductImages":[],"ListPriceBookDetail":[]
    log    ${format_data}
    ${data}    Evaluate    (None, '{${format_data}}')
    ${data1}    Evaluate    (None, '[]')
    ${payload}    Create Dictionary    Product=${data}    ListUnitPriceBookDetail=${data1}
    Log    ${payload}
    Post request data form thr API    /products/photo?kvuniqueparam=2020     ${payload}

Computation list result order summary af excute
    [Arguments]    ${list_product}    ${list_num}
    [Timeout]    5 minutes
    ${list_order_summary}    Get list order summary frm product API    ${list_product}
    ${list_result_order_summary}    Create List
    :FOR    ${item_order_summary}     ${item_num}   IN ZIP      ${list_order_summary}   ${list_num}
    \     ${result_tongso_dh}    Sum and round 2    ${item_order_summary}    ${item_num}
    \     Append To List    ${list_result_order_summary}    ${result_tongso_dh}
    Return From Keyword        ${list_result_order_summary}

Get material by product code
    [Timeout]    5 minutes
    [Arguments]     ${input_product}
    ${get_pr_id}      Get product id thr API    ${input_product}
    ${endpoint_tab_thanhphan}     Format String     ${endpoint_tab_thanhphan}     ${get_pr_id}
    ${resp}  Get Request and return body       ${endpoint_tab_thanhphan}
    ${get_list_code}      Get raw data from response json    ${resp}       $.Data..Code
    ${get_list_quantity}      Get raw data from response json    ${resp}       $.Data..Quantity
    Return From Keyword    ${get_list_code}     ${get_list_quantity}

Get list included products by product code
    [Timeout]    5 minutes
    [Arguments]     ${input_product}    ${input_num}
    ${get_list_code}     ${get_list_quantity}   Get material by product code    ${input_product}
    ${get_pr_id}      Get list product id thr API    ${get_list_code}
    ${list_included_code}    Create List
    ${list_included_quantity}    Create List
    :FOR    ${item_pr}      ${item_pr_id}     IN ZIP     ${get_list_code}     ${get_pr_id}
    \     ${endpoint_thanhphan}     Format String     ${endpoint_tab_thanhphan}     ${item_pr_id}
    \     ${resp}  Get Request and return body       ${endpoint_thanhphan}
    \     ${get_list_code}      Get raw data from response json    ${resp}       $.Data..Code
    \     ${get_list_quantity_tp}      Get raw data from response json    ${resp}       $.Data..Quantity
    \     Append To List    ${list_included_code}    ${get_list_code}
    \     Append To List    ${list_included_quantity}    ${get_list_quantity_tp}
    Log    ${list_included_code}
    Log    ${list_included_quantity}
    ${list_quantity_mamu_included_pr}   Create List
    :FOR    ${item_list_included_code}    ${item_list_included_quantity}    ${item_get_list_quantity}       IN ZIP       ${list_included_code}    ${list_included_quantity}     ${get_list_quantity}
    \      ${item_quantity_mamu_included_pr}     Multiplication x 3 list numbers with number    ${item_list_included_quantity}   ${item_get_list_quantity}    ${input_num}
    \      Append To List   ${list_quantity_mamu_included_pr}     ${item_quantity_mamu_included_pr}
    Log    ${list_quantity_mamu_included_pr}
    Return From Keyword    ${list_included_code}     ${list_quantity_mamu_included_pr}

Get list onhand by list included products af manufacture
    [Arguments]     ${list_product}     ${input_num}
    ${list_included_code}     ${list_quantity_mamu_included_pr}    Get list included products by product code    ${list_product}    ${input_num}
    ${list_included_onhamd}     Get list onhand by list product    ${list_included_code}
    ${list_included_onhand_af}      Create List
    :FOR    ${item_list_included_code}    ${item_list_quantity_mamu_included_pr}      ${item_list_included_onhamd}      IN ZIP      ${list_included_code}     ${list_quantity_mamu_included_pr}    ${list_included_onhamd}
    \     ${item_list_list_included_onhand_af}    Minus list numbers    ${item_list_included_onhamd}    ${item_list_quantity_mamu_included_pr}
    \     Append To List    ${list_included_onhand_af}    ${item_list_list_included_onhand_af}
    Return From Keyword    ${list_included_code}    ${list_included_onhand_af}

Get list onhand by list product
    [Arguments]   ${list_product}
    ${list_onhand}    Create List
    :FOR    ${item_list_pr}      IN ZIP    ${list_product}
    \    ${item_list_pr}    Convert To List     ${item_list_pr}
    \    ${item_list_onhand}    Get list onhand frm API       ${item_list_pr}
    \    Append To List   ${list_onhand}    ${item_list_onhand}
    Return From Keyword    ${list_onhand}

Computation list quantity of material when manufacturing
    [Timeout]    5 minutes
    [Arguments]     ${input_product}      ${input_num}
    ${get_list_code}     ${get_list_quantity}     Get material by product code     ${input_product}
    ${list_quantity_manu}     Create List
    :FOR    ${item_quality}   IN ZIP    ${get_list_quantity}
    \     ${item_quality_manu}      Multiplication    ${item_quality}    ${input_num}
    \     Append To List    ${list_quantity_manu}     ${item_quality_manu}
    Log    ${list_quantity_manu}
    Return From Keyword    ${get_list_code}   ${list_quantity_manu}

Computation list onhand of material after manufacture
    [Timeout]    5 minutes
    [Arguments]     ${input_product}      ${input_num}
    ${get_list_code}   ${list_quantity_manu}    Computation list quantity of material when manufacturing      ${input_product}      ${input_num}
    ${list_result_onhand}   Get list of result onhand incase changing product price    ${get_list_code}     ${list_quantity_manu}
    Return From Keyword    ${get_list_code}     ${list_result_onhand}

Get product onhand af manufacture
    [Arguments]    ${input_product}    ${input_num}
    [Timeout]    5 minutes
    ${get_onhand_bf}    Get onhand frm API    ${input_product}
    ${get_onhand_af}    Sum    ${get_onhand_bf}     ${input_num}
    Return From Keyword     ${get_onhand_af}

Assert list onhand of material after manufacture
      [Arguments]     ${list_product}     ${list_onhand}
      ${list_onhand_result}     Get list onhand frm API    ${list_product}
      :FOR    ${item_pr}      ${item_onhand}      ${item_onhand_result}     IN ZIP     ${list_product}     ${list_onhand}   ${list_onhand_result}
      \     Should Be Equal As Numbers     ${item_onhand}      ${item_onhand_result}

Assert list onhand of included products after manufacture
      [Arguments]     ${list_product}     ${list_onhand}
      ${list_onhand_result}   Get list onhand by list product    ${list_product}
      Should Be Equal As Strings    ${list_onhand_result}    ${list_onhand}

Computation list cost, price, onhand of product incl 2 unit
      [Arguments]     ${ten_hanghoa}   ${dvcb}    ${giavon}   ${giaban}   ${tonkho}   ${gtqd1}    ${gtqd2}
      ${result_tenhh}    Catenate    ${ten_hanghoa}    (${dvcb})
      ${result_cost_qd_1}    Multiplication with price round 2    ${giavon}    ${gtqd1}
      ${result_price_qd_1}    Multiplication with price round 2    ${giaban}    ${gtqd1}
      ${tonkho_qd1}    Devision    ${tonkho}    ${gtqd1}
      ${tonkho_qd1}    Evaluate    round(${tonkho_qd1}, 3)
      ${result_cost_qd_2}    Multiplication with price round 2    ${giavon}    ${gtqd2}
      ${result_price_qd_2}    Multiplication with price round 2    ${giaban}    ${gtqd2}
      ${tonkho_qd2}    Devision    ${tonkho}    ${gtqd2}
      ${tonkho_qd2}    Evaluate    round(${tonkho_qd2}, 3)
      Return From Keyword    ${result_tenhh}    ${result_cost_qd_1}   ${result_price_qd_1}    ${tonkho_qd1}   ${result_cost_qd_2}   ${result_price_qd_2}    ${tonkho_qd2}

Computation list cost, price, onhand of product incl 1 unit
      [Arguments]     ${ten_hanghoa}   ${dvcb}    ${giavon}   ${giaban}   ${tonkho}   ${gtqd1}
      ${result_tenhh}    Catenate    ${ten_hanghoa}    (${dvcb})
      ${result_cost_qd_1}    Multiplication with price round 2    ${giavon}    ${gtqd1}
      ${result_price_qd_1}    Multiplication with price round 2    ${giaban}    ${gtqd1}
      ${tonkho_qd1}    Devision    ${tonkho}    ${gtqd1}
      ${tonkho_qd1}    Evaluate    round(${tonkho_qd1}, 3)
      Return From Keyword    ${result_tenhh}    ${result_cost_qd_1}   ${result_price_qd_1}    ${tonkho_qd1}

Assert data in case create list attribute product
      [Arguments]   ${list_product}    ${ten_hanghoa}    ${nhom_hang}    ${tonkho}    ${giavon}    ${giaban}
      : FOR    ${item_hh}    IN ZIP    ${list_product}
      \    Wait Until Keyword Succeeds    3 times    3s    Assert data in case create product    ${item_hh}    ${ten_hanghoa}
      \    ...    ${nhom_hang}    ${tonkho}    ${giavon}    ${giaban}

Assert list data in case create product have trade mark name
      [Arguments]   ${list_hh}    ${input_mavach}    ${ten_hanghoa}    ${nhom_hang}   ${tonkho}    ${giavon}    ${giaban}    ${ten_thuong_hieu}
      : FOR    ${item_hh}    IN ZIP    ${list_hh}
      \    Wait Until Keyword Succeeds    3 times    3s   Assert data in case create product have trade mark name   ${item_hh}   ${input_mavach}    ${ten_hanghoa}    ${nhom_hang}
      \   ...    ${tonkho}    ${giavon}    ${giaban}    ${ten_thuong_hieu}

Assert count of attribute product and return list attribute product
    [Arguments]   ${ma_hh}      ${list_attr}
    ${get_list_hh_thuoc_tinh}    Get product code from MasterProductId    ${ma_hh}
    ${indext_to_count_input}    Get Length    ${list_attr}
    ${indext_to_count_result}   Get Length    ${get_list_hh_thuoc_tinh}
    ${indext_to_count_result}    Evaluate    ${indext_to_count_result} + 1
    Should Be Equal As Numbers    ${indext_to_count_input}    ${indext_to_count_result}
    ${list_hang_thuoc_tinh_actual}    Create List
    : FOR    ${item_hh}    IN ZIP    ${get_list_hh_thuoc_tinh}
    \    ${item_hh}    Replace sq blackets    ${item_hh}
    \    Append To List    ${list_hang_thuoc_tinh_actual}    ${item_hh}
    Log    ${list_hang_thuoc_tinh_actual}
    Return From Keyword    ${list_hang_thuoc_tinh_actual}

Assert active product by branch
    [Arguments]    ${input_branch}    ${ma_hh}     ${is_active}
    ${get_branch_id}      Get BranchID by BranchName    ${input_branch}
    ${endpoint_pr}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${get_branch_id}
    ${get_resp}    Get Request and return body    ${endpoint_pr}
    ${jsonpath_ngungkd}    Format String    $..Data[?(@.Code=="{0}")].isActive    ${ma_hh}
    ${get_tt_ngungkd}    Get data from response json and return false value    ${get_resp}    ${jsonpath_ngungkd}
    Should Be Equal As Strings    ${get_tt_ngungkd}    ${is_active}

Computation list on order after Da xac nhan NCC
    [Arguments]    ${list_prs}    ${list_num}
    ${get_list_on_order_bf}    Get list on order frm API    ${list_prs}
    ${result_list_on_order_af}    Create List
    : FOR    ${item_on_order}    ${item_num}    IN ZIP    ${get_list_on_order_bf}    ${list_num}
    \    ${on_order_af}    Sum    ${item_on_order}    ${item_num}
    \    Append To List    ${result_list_on_order_af}    ${on_order_af}
    Return From Keyword    ${result_list_on_order_af}

Computation list on order after purchase receipt frm draft
    [Arguments]    ${list_prs}    ${list_num_order}    ${list_num}
    ${get_list_on_order_bf}    Get list on order frm API    ${list_prs}
    ${result_list_on_order_af}    Create List
    : FOR    ${item_on_order}    ${item_num_order}    ${item_num}    IN ZIP    ${get_list_on_order_bf}    ${list_num_order}
    ...    ${list_num}
    \    ${on_order_af}    Minus    ${item_num_order}    ${item_num}
    \    ${on_order_af}    Sum    ${item_on_order}    ${on_order_af}
    \    Append To List    ${result_list_on_order_af}    ${on_order_af}
    Return From Keyword    ${result_list_on_order_af}

Computation list on order after purchase receipt frm processing
    [Arguments]    ${list_prs}    ${list_num}
    ${get_list_on_order_bf}    Get list on order frm API    ${list_prs}
    ${result_list_on_order_af}    Create List
    : FOR    ${item_on_order}    ${item_num}    IN ZIP    ${get_list_on_order_bf}    ${list_num}
    \    ${on_order_af}    Minus    ${item_on_order}    ${item_num}
    \    Append To List    ${result_list_on_order_af}    ${on_order_af}
    Return From Keyword    ${result_list_on_order_af}

 Computation list on order after purchase order
    [Arguments]   ${list_prs}    ${list_nums}   ${input_trangthai}
    ${get_list_on_order_af}    Run Keyword If    '${input_trangthai}'=='Phiếu tạm'   Get list on order frm API    ${list_prs}   ELSE    Computation list on order after Da xac nhan NCC    ${list_prs}    ${list_nums}
    Return From Keyword    ${get_list_on_order_af}

Comptation list on order after create purchase receipt
    [Arguments]   ${list_prs}   ${list_nums}    ${list_nums_edit}   ${input_status}
    ${get_list_on_order_af}   Run Keyword If    '${input_status}'=='Đã xác nhận NCC'      Computation list on order after purchase receipt frm processing    ${list_prs}    ${list_nums_edit}
    ...     ELSE    Computation list on order after purchase receipt frm draft     ${list_prs}    ${list_nums}    ${list_nums_edit}
    Return From Keyword    ${get_list_on_order_af}

Get list lodate status thr API
    [Arguments]    ${list_prs}
    [Timeout]    20 minutes
    ${endpoint_hh}    Format String    ${endpoint_danhmuc_hh_co_dvt}    ${BRANCH_ID}
    ${resp}    Get Request and return body    ${endpoint_hh}
    ${list_lodate_status}    Create List
    : FOR    ${item_pr}    IN ZIP    ${list_prs}
    \    ${jsonpath_lodate_status}    Format String    $..Data[?(@.Code=="{0}")].IsBatchExpireControl    ${item_pr}
    \    ${get_lodate_status}    Get data from response json    ${resp}    ${jsonpath_lodate_status}
    \    Append To List    ${list_lodate_status}    ${get_lodate_status}
    Return From Keyword    ${list_lodate_status}
