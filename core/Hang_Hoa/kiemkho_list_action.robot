*** Settings ***
Library           SeleniumLibrary
Library           StringFormat
Resource          kiemkho_list_page.robot
Resource          ../share/discount.robot
Resource          kiemkho_form.robot
Library           String
Resource          ../share/computation.robot
Resource          ../API/api_danhmuc_hanghoa.robot
Resource          ../API/api_kiemkho.robot
Resource          ../share/imei.robot
Resource          ../share/lodate.robot
Resource          ../share/javascript.robot
Resource          ../share/global.robot

*** Keywords ***
Go to Inventory form
    Wait Until Page Contains Element    ${button_kiemkho}    2 mins
    Click Element    ${button_kiemkho}
    Wait Until Page Contains Element    ${textbox_search_ma_hh}    2 mins
    #${url_re} =  Execute Javascript        return window.location.href;

Input product and nums to Inventory form then assert values
    [Arguments]    ${input_ma_sp}    ${input_soluong_thucte}    ${gia_von_af_kiem}    ${ton_af_kiem}    ${lastest_num}
    [Documentation]    input dữ liệu, assert số lượng lệch và giá trị lệch
    ##
    Set Selenium Speed    0.3s
    Wait Until Page Contains Element    ${textbox_search_ma_hh}    2 min
    Wait Until Keyword Succeeds    3 times    10 s    Input data in textbox and wait until it is visible    ${textbox_search_ma_hh}    ${input_ma_sp}    ${item_first_product_dropdownlist}
    ...    ${cell_first_product_code}
    Wait Until Page Contains Element    ${textbox_soluong_thucte}    2 min
    ${result_lastest_number}    Input number and validate data    ${textbox_soluong_thucte}    ${input_soluong_thucte}    ${lastest_num}    ${cell_tong_soluong_thucte}
    Sleep    2s    Wait for loading data
    Get and assert value in recent activites    ${input_soluong_thucte}
    ${gettext_soluong_lech}    ${gettext_giatri_lech}    Get counted nums and diff quantity
    ${result_soluong_lech}    Minus    ${input_soluong_thucte}    ${ton_af_kiem}
    ${result_giatri_lech}    Multiplication and round    ${result_soluong_lech}    ${gia_von_af_kiem}
    Should Be Equal As Numbers    ${gettext_soluong_lech}    ${result_soluong_lech}
    Should Be Equal As Numbers    ${gettext_giatri_lech}    ${result_giatri_lech}
    Return From Keyword    ${result_soluong_lech}    ${result_giatri_lech}    ${result_lastest_number}

Input inventory counting code
    [Arguments]    ${input_ma_kiemkho}
    Wait Until Keyword Succeeds    3 times    10 s    Input data    ${textbox_ma_kiemkho}    ${input_ma_kiemkho}

Get counted nums and diff quantity
    ${gettext_soluong_lech}    Get Text    ${cell_soluong_lech}
    ${gettext_giatri_lech}    Get Text    ${cell_giatri_lech}
    ${gettext_soluong_lech}    Replace String    ${gettext_soluong_lech}    ,    ${EMPTY}
    ${gettext_giatri_lech}    Replace String    ${gettext_giatri_lech}    ,    ${EMPTY}
    ${gettext_soluong_lech}    Convert To Number    ${gettext_soluong_lech}
    ${gettext_giatri_lech}    Convert To Number    ${gettext_giatri_lech}
    Return From Keyword    ${gettext_soluong_lech}    ${gettext_giatri_lech}

Get counted nums and diff quantity by product code
    [Arguments]        ${product_code}
    ${cell_diff_quan_by_product_code}      Format String         ${cell_diff_quan_by_product_code}     ${product_code}
    ${cell_diff_value_by_product_code}      Format String         ${cell_diff_value_by_product_code}     ${product_code}
    ${gettext_soluong_lech}    Get Text    ${cell_diff_quan_by_product_code}
    ${gettext_giatri_lech}    Get Text    ${cell_diff_value_by_product_code}
    ${gettext_soluong_lech}    Replace String    ${gettext_soluong_lech}    ,    ${EMPTY}
    ${gettext_giatri_lech}    Replace String    ${gettext_giatri_lech}    ,    ${EMPTY}
    ${gettext_soluong_lech}    Convert To Number    ${gettext_soluong_lech}
    ${gettext_giatri_lech}    Convert To Number    ${gettext_giatri_lech}
    Return From Keyword    ${gettext_soluong_lech}    ${gettext_giatri_lech}

Get and assert value in recent activites
    [Arguments]    ${input_sl_thucte}
    ${gettext_ten_sp_kiem}    Get Text    ${cell_ten_kiem_ganday}
    ${gettext_soluong_kiem}    Get Text    ${cell_soluong_kiem_ganday}
    ${gettext_soluong_kiem}    Replace String    ${gettext_soluong_kiem}    (    ${EMPTY}
    ${gettext_soluong_kiem}    Replace String    ${gettext_soluong_kiem}    )    ${EMPTY}
    ${gettext_soluong_kiem}    Convert To Number    ${gettext_soluong_kiem}
    ${input_sl_thucte}    Convert To Number    ${input_sl_thucte}
    Should Be Equal    ${gettext_soluong_kiem}    ${input_sl_thucte}

Click Agree button on inventory balancing popup
    [Documentation]    Click "Đồng ý" trên pop-up thông báo xác nhận cân bằng kho
    Wait Until Page Contains Element    ${button_dong_y_canbangkho_popup}    2 min
    Click Element JS    ${button_dong_y_canbangkho_popup}

Get and assert data from Match Tab
    [Arguments]    ${input_num_of_counted_product}
    ${gettext_match_tab}    Get Text    ${tab_match}
    ${text_in_match_tab}    Format String    Khớp ({0})    ${input_num_of_counted_product}
    Should Be Equal    ${gettext_match_tab}    ${text_in_match_tab}

Get and assert data from NotMatch Tab
    [Arguments]    ${input_num_of_counted_product}
    ${gettext_notmatch_tab}    Get Text    ${tab_not_match}
    ${text_in_notmatch_tab}    Format String    Lệch ({0})    ${input_num_of_counted_product}
    Should Be Equal    ${gettext_notmatch_tab}    ${text_in_notmatch_tab}

Get and assert data from Not Control Tab
    [Arguments]    ${input_num_of_counted_product}
    ${gettext_notcontrol_tab}    Get Text    ${tab_not_match}
    ${text_in_notcontrol_tab}    Format String    Chưa kiểm (0)    ${input_num_of_counted_product}
    Should Be Equal    ${gettext_notcontrol_tab}    ${text_in_notcontrol_tab}

Get Total OnHand
    ${gettext_total_onhand}    Get Text    ${cell_tong_soluong_thucte}
    ${gettext_total_onhand}    Replace String    ${gettext_total_onhand}    ,    ${EMPTY}
    Return From Keyword    ${gettext_total_onhand}

Input products and nums to Inventory form then assert values
    [Arguments]    ${input_ma_sp}    ${input_soluong_thucte}      ${lastest_num}
    [Documentation]    input dữ liệu, assert số lượng lệch và giá trị lệch
    ##
    ${list_result_giavon_bf_count}    Create List
    ${list_result_ton_bf_count}    Create List
    ${list_result_soluong_lech}    Create List
    ${list_result_giatri_lech}    Create List
    ${ton_bf_kiem}    ${gia_von_bf_kiem}    Get Cost and OnHand frm API    ${input_ma_sp}
    Set Selenium Speed    0.3s
    Wait Until Page Contains Element    ${textbox_search_ma_hh}    2 min
    Wait Until Keyword Succeeds    3 times    10 s    Input data in textbox and wait until it is visible    ${textbox_search_ma_hh}    ${input_ma_sp}    ${item_first_product_dropdownlist}
    ...    ${cell_first_product_code}
    Wait Until Page Contains Element    ${textbox_soluong_thucte}    2 min
    ${result_lastest_number}    Input number and validate data    ${textbox_soluong_thucte}    ${input_soluong_thucte}    ${lastest_num}    ${cell_tong_soluong_thucte}
    Sleep    2s    Wait for loading data
    Get and assert value in recent activites    ${input_soluong_thucte}
    ${gettext_soluong_lech}    ${gettext_giatri_lech}    Get counted nums and diff quantity
    ${result_soluong_lech}    Minus    ${input_soluong_thucte}    ${ton_bf_kiem}
    ${result_giatri_lech}    Multiplication and round    ${result_soluong_lech}    ${gia_von_bf_kiem}
    Should Be Equal As Numbers    ${gettext_soluong_lech}    ${result_soluong_lech}
    Should Be Equal As Numbers    ${gettext_giatri_lech}    ${result_giatri_lech}
    Append To List    ${list_result_giavon_bf_count}    ${gia_von_bf_kiem}
    Append To List    ${list_result_ton_bf_count}    ${ton_bf_kiem}
    Append To List    ${list_result_soluong_lech}    ${result_soluong_lech}
    Append To List    ${list_result_giatri_lech}    ${result_giatri_lech}
    Return From Keyword    ${list_result_giavon_bf_count}    ${list_result_ton_bf_count}    ${list_result_soluong_lech}    ${list_result_giatri_lech}    ${result_lastest_number}

Input current quantity for normal product to Inventory form then assert values
    [Arguments]    ${product_code}      ${onhand}     ${cost}     ${current_quantity}      ${lastest_num}
    [Documentation]    input dữ liệu, assert số lượng lệch và giá trị lệch
    ${textbox_current_quan_by_product_code}         Format String        ${textbox_current_quan_by_product_code}       ${product_code}
    Wait Until Page Contains Element    ${textbox_current_quan_by_product_code}    20 s
    ${result_lastest_number}    Input number and validate data    ${textbox_current_quan_by_product_code}    ${current_quantity}    ${lastest_num}    ${cell_tong_soluong_thucte}
    Focus    ${textbox_ma_kiemkho}
    Sleep    2s    Wait for loading data
    Get and assert value in recent activites    ${current_quantity}
    ${gettext_diff_quan}    ${gettext_diff_value}    Get counted nums and diff quantity by product code      ${product_code}
    ${result_diff_quan}    Minus    ${current_quantity}    ${onhand}
    ${result_diff_value}    Multiplication and round    ${result_diff_quan}    ${cost}
    Should Be Equal As Numbers    ${gettext_diff_quan}    ${result_diff_quan}
    Should Be Equal As Numbers    ${gettext_diff_value}    ${result_diff_value}
    Return From Keyword    ${result_diff_quan}    ${result_diff_value}      ${result_lastest_number}

Get Total OnHand and convert to number
    ${gettext_total_onhand}    Get Text    ${cell_tong_soluong_thucte}
    ${gettext_total_onhand}    Replace String    ${gettext_total_onhand}    ,    ${EMPTY}
    ${gettext_total_onhand}    Convert To Number    ${gettext_total_onhand}
    Return From Keyword    ${gettext_total_onhand}

Input product and imeis in Inventory form then assert values
    [Arguments]    ${input_ma_sp}    ${gia_von_af_kiem}    ${ton_af_kiem}    @{list_item_imei}
    [Documentation]    input dữ liệu, assert số lượng lệch và giá trị lệch
    ##
    Input product and its imei to any form    ${textbox_search_ma_hh}    ${input_ma_sp}    ${item_first_product_dropdownlist}    ${textbox_imei_num}    ${item_imei_dropdownlist}    @{list_item_imei}
    Click Element    ${textbox_ma_kiemkho}
    ${get_actual_nums}    Get Length    ${list_item_imei}
    Get and assert value in recent activites    ${get_actual_nums}
    ${gettext_soluong_lech}    ${gettext_giatri_lech}    Get counted nums and diff quantity
    ${result_soluong_lech}    Minus    ${get_actual_nums}    ${ton_af_kiem}
    ${result_giatri_lech}    Multiplication and round    ${result_soluong_lech}    ${gia_von_af_kiem}
    Should Be Equal As Numbers    ${gettext_soluong_lech}    ${result_soluong_lech}
    Should Be Equal As Numbers    ${gettext_giatri_lech}    ${result_giatri_lech}
    Return From Keyword    ${result_soluong_lech}    ${result_giatri_lech}    ${get_actual_nums}

Get and assert values Total Onhand
    [Arguments]    ${input_total_nums}
    ${get_total_onhand}    Get Total OnHand
    ${get_total_onhand}    Convert To Number    ${get_total_onhand}
    ${input_total_nums}    Convert To Number    ${input_total_nums}
    Should Be Equal    ${get_total_onhand}    ${input_total_nums}

Input products and imeis in Inventory form then assert values
    [Arguments]       ${dict}    @{list_product}
    [Documentation]    input dữ liệu, assert số lượng lệch và giá trị lệch
    ##
    ${list_result_giavon_af_count}    Create List
    ${list_result_ton_af_count}    Create List
    ${list_result_soluong_lech}    Create List
    ${list_result_giatri_lech}    Create List
    ${list_counted_imei_by_product_onrow}    Create List
    ${list_system_imei_by_product_bf_counted}    Create List
    ${list_actual_nums}    Create List
    ${index_product}    Set Variable    -1
    : FOR    ${product}    IN    @{list_product}
    \    ${index_product}    Evaluate    ${index_product} + 1
    \    ${product}    Get From List    ${list_product}    ${index_product}
    \    ${imei_by_product}    Get From Dictionary    ${dict}    ${product}
    \    ${imei_by_product_inlist}    Convert String to List    ${imei_by_product}
    \    Input product and its imei with enter key    ${textbox_search_ma_hh}    ${product}    ${item_first_product_dropdownlist}    ${textbox_imei_num}    ${cell_first_product_code}
    \    ...    @{imei_by_product_inlist}
    \    Click Element    ${textbox_ma_kiemkho}
    \    ${get_actual_nums}    Get Length    ${imei_by_product_inlist}
    \    Get and assert value in recent activites    ${get_actual_nums}
    \    ${gettext_soluong_lech}    ${gettext_giatri_lech}    Get counted nums and diff quantity
    \    ${gia_von_bf_kiem}    ${ton_bf_kiem}    ${list_imei_bf_kiem}    Get Cost and string-Imei OnHand frm API    ${product}
    \    ${result_soluong_lech}    Minus    ${get_actual_nums}    ${ton_bf_kiem}
    \    ${result_giatri_lech}    Multiplication and round    ${result_soluong_lech}    ${gia_von_bf_kiem}
    \    Should Be Equal As Numbers    ${gettext_soluong_lech}    ${result_soluong_lech}
    \    Should Be Equal As Numbers    ${gettext_giatri_lech}    ${result_giatri_lech}
    \    Append To List    ${list_result_giavon_af_count}    ${gia_von_bf_kiem}
    \    Append To List    ${list_result_ton_af_count}    ${ton_bf_kiem}
    \    Append To List    ${list_result_soluong_lech}    ${result_soluong_lech}
    \    Append To List    ${list_result_giatri_lech}    ${result_giatri_lech}
    \    Append To List    ${list_counted_imei_by_product_onrow}    ${imei_by_product}
    \    Append To List    ${list_system_imei_by_product_bf_counted}    ${list_imei_bf_kiem}
    \    Append To List    ${list_actual_nums}    ${get_actual_nums}
    \    Log Many    ${list_result_giavon_af_count}
    \    Log Many    ${list_result_ton_af_count}
    \    Log Many    ${list_result_soluong_lech}
    \    Log Many    ${list_result_giatri_lech}
    \    Log Many    ${list_counted_imei_by_product_onrow}
    \    Log Many    ${list_system_imei_by_product_bf_counted}
    \    Log Many    ${list_actual_nums}
    Return From Keyword    ${list_result_giavon_af_count}    ${list_result_ton_af_count}    ${list_result_soluong_lech}    ${list_result_giatri_lech}    ${list_counted_imei_by_product_onrow}    ${list_system_imei_by_product_bf_counted}
    ...    ${list_actual_nums}

Input current imeis in Inventory form then assert values
        [Arguments]       ${product_code}      ${onhand}     ${cost}     ${current_quantity}      ${lastest_num}
        [Documentation]    input dữ liệu, assert số lượng lệch và giá trị lệch
        ${list_current_imeis}        Create list imei by generating random    ${current_quantity}
        ${product_id}        Get product id thr API    ${product_code}
        ${textbox_input_imei_by_product_id}        Format String      ${textbox_input_imei_by_product_id}       ${product_id}
        ${index_imei}    Set Variable    -1
        : FOR    ${imei}    IN    @{list_current_imeis}
        \    ${index_imei}    Evaluate    ${index_imei} + 1
        \    ${item_imei}    Get From List    ${list_current_imeis}    ${index_imei}
        \    Wait Until Keyword Succeeds    3 times    8 s    input data    ${textbox_input_imei_by_product_id}    ${item_imei}
        Click Element    ${textbox_ma_kiemkho}
        Get and assert value in recent activites    ${current_quantity}
        ${gettext_diff_quan}    ${gettext_diff_value}    Get counted nums and diff quantity by product code    ${product_code}
        ${list_imei_bf_count}    Get String-Imei OnHand by Product Id frm API     ${product_id}
        ${result_diff_quan}    Minus    ${current_quantity}    ${onhand}
        ${result_diff_value}    Multiplication and round    ${result_diff_quan}    ${cost}
        ${lastest_num}       Sum      ${lastest_num}     ${current_quantity}
        Should Be Equal As Numbers    ${gettext_diff_quan}    ${result_diff_quan}
        Should Be Equal As Numbers    ${gettext_diff_value}    ${result_diff_value}
        Return From Keyword         ${result_diff_quan}         ${result_diff_value}      ${list_current_imeis}       ${list_imei_bf_count}       ${lastest_num}


Input Unit products and nums to Inventory form then assert values
    [Arguments]    ${input_ma_sp}    ${input_soluong_thucte}    ${item_result_soluong_lech}    ${item_result_giatri_lech}    ${lastest_num}
    [Documentation]    input dữ liệu, assert số lượng lệch và giá trị lệch
    ##
    Set Selenium Speed    0.3s
    Wait Until Page Contains Element    ${textbox_search_ma_hh}    2 min
    Wait Until Keyword Succeeds    3 times    10 s    Input data in textbox and wait until it is visible    ${textbox_search_ma_hh}    ${input_ma_sp}    ${item_first_product_dropdownlist}
    ...    ${cell_first_product_code}
    Wait Until Page Contains Element    ${textbox_soluong_thucte}    2 min
    ${result_lastest_number}    Input number and validate data    ${textbox_soluong_thucte}    ${input_soluong_thucte}    ${lastest_num}    ${cell_tong_soluong_thucte}
    Sleep    2s    Wait for loading data
    Get and assert value in recent activites    ${input_soluong_thucte}
    ${gettext_soluong_lech}    ${gettext_giatri_lech}    Get counted nums and diff quantity
    Should Be Equal As Numbers    ${gettext_soluong_lech}    ${item_result_soluong_lech}
    Should Be Equal As Numbers    ${gettext_giatri_lech}    ${item_result_giatri_lech}
    Return From Keyword    ${result_lastest_number}


Get lists of Primary and Unit products
    [Arguments]    ${gia_von_bf_kiem_primary_pr}    ${input_primary_product}    ${list_qd_product}    ${list_dvqd}    ${list_qd_num}    ${list_result_soluong_lech}
    ...    ${list_result_giatri_lech}    ${list_result_ton_bf_count}    ${list_num_actual_cb}
    [Documentation]    Lấy các list giá trị:
    ...    - Số lượng lệch HH quy đổi
    ...    - Giá trị lệch HH cơ bản
    ...    - Giá trị lệch HH quy đổi
    ...    - Tồn HH quy đổi
    ##
    : FOR    ${item_pr_qd}    ${item_dvqd}    ${item_qd_num}    IN ZIP    ${list_qd_product}    ${list_dvqd}
    ...    ${list_qd_num}
    \    ${ton_bf_kiem}    ${gia_von_bf_kiem}    Get Cost and OnHand frm API    ${item_pr_qd}
    \    ${result_diff_num_unit}    Minus    ${item_qd_num}    ${ton_bf_kiem}
    \    ${result_diff_num_primary_product}    Multiplication with price round 2    ${result_diff_num_unit}    ${item_dvqd}
    \    ${result_diff_value_primary_product}    Multiplication with price round 2    ${result_diff_num_primary_product}    ${gia_von_bf_kiem_primary_pr}
    \    ${result_num_actual_primary_product}    Multiplication with price round 2    ${item_qd_num}    ${item_dvqd}
    \    Append To List    ${list_result_soluong_lech}    ${result_diff_num_unit}
    \    Append To List    ${list_result_giatri_lech}    ${result_diff_value_primary_product}
    \    Append To List    ${list_result_ton_bf_count}    ${ton_bf_kiem}
    \    Append To List    ${list_num_actual_cb}    ${result_num_actual_primary_product}
    Return From Keyword    ${list_result_soluong_lech}    ${list_result_giatri_lech}    ${list_result_ton_bf_count}    ${list_num_actual_cb}

Go to select group pop up
    Wait Until Element Is Enabled    ${button_select_pro_group}        10 s
    Click Element    ${button_select_pro_group}
    Wait Until Element Is Enabled    ${textbox_search_group_selectgrouppopup}      10 s

Select Group for counting products
    [Arguments]         ${group_name}
    ${xpath_groupname}       Format String        ${checkbox_group_selectgrouppopup}        ${group_name}
    Wait Until Element Is Enabled    ${xpath_groupname}
    Click Element JS         ${xpath_groupname}
    Click Element    ${button_xong_selectgrouppopup}
    Wait Until Page Does Not Contain    Chọn nhóm hàng

Get displayed product list in Inventory Form incase counting by Group
    [Documentation]         Lấy ra list sản phẩm hàng hóa khi kiểm kho theo nhóm có hàng đơn vị tính
    [Arguments]      ${list_products}      ${list_product_types}
    ${list_displayed_products}         Copy List        ${list_products}
    : FOR    ${item_product}    ${item_product_type}      IN ZIP    ${list_products}    ${list_product_types}
    \    Run Keyword If    '${item_product_type}' == 'master'       Remove values from list          ${list_displayed_products}     ${item_product}       ELSE        Log           Ignore
    \    ${list_added_products}     Run Keyword If    '${item_product_type}' == 'master'     Get list of unit codes frm API     ${item_product}      ELSE     Set Variable    ${EMPTY}
    \    ${list_displayed_products}       Run Keyword If    '${item_product_type}' == 'master'      Combine Lists      ${list_displayed_products}       ${list_added_products}       ELSE       Set Variable       ${list_displayed_products}
    Return From Keyword     ${list_displayed_products}

Select item search
    [Arguments]      ${xpath_item_search}
    Wait Until Element Is Visible    ${xpath_item_search}
    Click Element JS    ${xpath_item_search}

Input products and lots in Inventory form then assert values
    [Arguments]       ${dict}    @{list_product}
    [Documentation]    input dữ liệu, assert số lượng lệch và giá trị lệch
    ${list_prs}    Get Dictionary Keys    ${dict}
    ${list_nums}    Get Dictionary Values    ${dict}
    ##
    ${list_result_giavon_af_count}    Create List
    ${list_result_ton_af_count}    Create List
    ${list_result_soluong_lech}    Create List
    ${list_result_giatri_lech}    Create List
    ##
    ${list_counted_lot_by_product_onrow}    Create List
    ${list_system_lot_by_product_bf_counted}    Create List
    ${list_actual_nums}    Create List
    #tạo nhiều lô cho hàng hóa
    ${list_tenlo}    Create List
    : FOR    ${item_pr}    ${item_list_num}    IN ZIP    ${list_prs}    ${list_nums}
    \    ${item_list_num}    Convert string to list    ${item_list_num}
    \    ${list_tenlo_by_pr}    Import multi lot for product and get list lots    ${item_pr}    ${item_list_num}
    \    Append To List    ${list_tenlo}    ${list_tenlo_by_pr}
    Log    ${list_tenlo}
    #tính tổng số lượng của các lô của từng hàng hóa
    ${list_result_num}    Create List
    : FOR    ${item_list_num}    IN ZIP    ${list_nums}
    \    ${item_list_num}    Convert string to list    ${item_list_num}
    \    ${result_num}    Sum values in list    ${item_list_num}
    \    Append To List    ${list_result_num}    ${result_num}
    Log    ${list_result_num}
    : FOR    ${product}    ${item_list_num}    ${item_list_lo}    ${item_num}    IN ZIP    ${list_prs}     ${list_nums}    ${list_tenlo}     ${list_result_num}
    \    Wait Until Keyword Succeeds    3 times    3s    Input data in textbox and wait until it is visible    ${textbox_nh_search_hh}    ${product}
    \    ...    ${nh_item_indropdown_search}    ${nh_cell_first_product_code}
    \    Input list lot name and list num of product to KK form    ${product}    ${item_list_lo}    ${item_list_num}
    #list số lượng thực tế so sánh với số lượng kiểm gần đây
    \    Get and assert value in recent activites    ${item_num}
    #get số lượng lệch và giá trị lệch
    \    ${gettext_soluong_lech}    ${gettext_giatri_lech}    Get counted nums and diff quantity
    #get giá vốn, tồn, list imei trc khi kiểm
    \    ${gia_von_bf_kiem}    ${ton_bf_kiem}    ${list_lot_bf_kiem}    Get Cost and string-lot OnHand frm API    ${product}
    # số lượng lệch = số lượng input - tồn
    \    ${result_soluong_lech}    Minus    ${item_num}    ${ton_bf_kiem}
    #tính giá trị lệch = số lượng lệch * giá vốn
    \    ${result_giatri_lech}    Multiplication and round    ${result_soluong_lech}    ${gia_von_bf_kiem}
    \    Should Be Equal As Numbers    ${gettext_soluong_lech}    ${result_soluong_lech}
    \    Should Be Equal As Numbers    ${gettext_giatri_lech}    ${result_giatri_lech}
    \    Append To List    ${list_result_giavon_af_count}    ${gia_von_bf_kiem}
    \    Append To List    ${list_result_ton_af_count}    ${ton_bf_kiem}
    \    Append To List    ${list_result_soluong_lech}    ${result_soluong_lech}
    \    Append To List    ${list_result_giatri_lech}    ${result_giatri_lech}
    \    Append To List    ${list_counted_lot_by_product_onrow}    ${item_list_lo}
    \    Append To List    ${list_system_lot_by_product_bf_counted}    ${list_lot_bf_kiem}
    \    Append To List    ${list_actual_nums}    ${item_num}
    \    Log Many    ${list_result_giavon_af_count}
    \    Log Many    ${list_result_ton_af_count}
    \    Log Many    ${list_result_soluong_lech}
    \    Log Many    ${list_result_giatri_lech}
    \    Log Many    ${list_counted_lot_by_product_onrow}
    \    Log Many    ${list_system_lot_by_product_bf_counted}
    \    Log Many    ${list_actual_nums}
    Return From Keyword    ${list_result_giavon_af_count}    ${list_result_ton_af_count}    ${list_result_soluong_lech}    ${list_result_giatri_lech}    ${list_counted_lot_by_product_onrow}    ${list_system_lot_by_product_bf_counted}
    ...    ${list_actual_nums}

Input list lot name and list num of product to KK form
    [Arguments]    ${input_ma_sp}    ${list_lo}    ${list_nums}
    ${list_result_lo}    Convert string to list    ${list_lo}
    ${list_result_nums}    Convert string to list    ${list_nums}
    : FOR    ${item_lo}    ${item_num}    IN ZIP    ${list_result_lo}    ${list_result_nums}
    \    Input Text    ${textbox_input_lots}   ${item_lo}
    \    ${item_dropdownlist}    Format String    ${item_nh_lo_in_dropdown}    ${item_lo}
    \    Wait Until Element Is Visible    ${item_dropdownlist}    30 s
    \    Press Key    ${textbox_input_lots}    ${ENTER_KEY}
    \    Wait Until Page Contains Element    ${textbox_sl_lo_thuc_te}    20s
    \    Input data    ${textbox_sl_lo_thuc_te}    ${item_num}
    \    Wait Until Keyword Succeeds    3x    1s    Click Element    ${button_save_lo}

Get and assert data on UI Inventory
    [Arguments]    ${list_actual_nums}
    ${soluong_thucte}    Set Variable    0
    ${index_actualnums}    Set Variable    -1
    : FOR    ${num}    IN    @{list_actual_nums}
    \    ${index_actualnums}    Evaluate    ${index_actualnums} + 1
    \    ${num_item}    Get From List    ${list_actual_nums}    ${index_actualnums}
    \    ${soluong_thucte}    Sum    ${soluong_thucte}    ${num_item}
    ${get_total_onhand}    Get Total OnHand and convert to number
    Should Be Equal    ${get_total_onhand}    ${soluong_thucte}

Click To Kiểm Kho Button
    Click Element Global    ${button_kiemkho}
    Wait To Loading Icon Invisible
