*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}      ${headless_browser}
Test Setup        Before Test Kiem Kho
Test Teardown     After Test
Library           String
Resource          ../../core/Hang_Hoa/kiemkho_list_action.robot
Resource          ../../core/hang_hoa/danh_muc_list_action.robot
Resource          ../../config/env_product/envi.robot
Resource          ../../core/share/toast_message.robot
Resource          ../../core/API/api_danhmuc_hanghoa.robot
Resource          ../../core/API/api_kiemkho.robot
Resource          ../../core/share/imei.robot
Resource          ../../core/share/list_dictionary.robot

*** Variables ***
&{dict_current_quan}        PIB02=1201       IM22=3        DVT0108=597       QDK026=195
&{dict_product_type}        PIB02=nor       IM22=imei        DVT0108=nor       QDK026=nor

*** Test Cases ***
Kiem hang hoa_Luutam
                      [Tags]        EKG           EK
                      [Template]         ekg_draft
                      Kiểm kho Nhóm          ${dict_current_quan}       ${dict_product_type}

Kiem hang hoa_Hoanthanh
                      [Tags]        EKG          EK
                      [Template]         ekg_finished
                      Kiểm kho Nhóm          ${dict_current_quan}       ${dict_product_type}

*** Keyword ***
ekg_draft
    [Arguments]        ${group_name}        ${dict_current_quan}       ${dict_product_type}
    Set Selenium Speed    1s
    Wait Until Keyword Succeeds    3 times    10 s    Go to Inventory form
    Go to select group pop up
    Select Group for counting products    ${group_name}
    ${list_current_quan}       Get Dictionary Values    ${dict_current_quan}
    ${list_products}       Get lists of product code in group    ${group_name}
    ${list_displayed_products}       Get Dictionary Keys    ${dict_current_quan}
    ${list_onhand}    ${list_cost}       Get list of Onhands and Costs frm API       ${list_displayed_products}
    ${list_displayed_product_types}       Get Dictionary Values      ${dict_product_type}
    ${ma_phieukiem}    Generate code automatically    PKK
    # Create lists
    ${list_result_diff_quantities}         Create List
    ${list_result_diff_values}        Create List
    ${list_all_imei_bf_count}        Create List
    ${list_all_current_imeis}      Create List
    Log        Input data
    ${lastest_num}    Set Variable    0
    : FOR       ${item_product}     ${item_product_type}        ${item_onhand}       ${item_cost}      ${item_current_quan}      IN ZIP          ${list_displayed_products}       ${list_displayed_product_types}      ${list_onhand}    ${list_cost}         ${list_current_quan}
    \       ${result_diff_quan_imei}     ${result_diff_value_imei}      ${list_current_imeis}       ${list_imei_bf_count}       ${lastest_num}     Run Keyword If    '${item_product_type}'=='imei'     Input current imeis in Inventory form then assert values      ${item_product}     ${item_onhand}       ${item_cost}    ${item_current_quan}       ${lastest_num}         ELSE       Set Variable     ${EMPTY}      ${EMPTY}    ${EMPTY}     ${EMPTY}     ${lastest_num}
    \       ${result_diff_quan}    ${result_diff_value}          ${lastest_num}      Run Keyword If    '${item_product_type}'!='imei'       Input current quantity for normal product to Inventory form then assert values     ${item_product}     ${item_onhand}       ${item_cost}    ${item_current_quan}      ${lastest_num}         ELSE       Set Variable     ${EMPTY}      ${EMPTY}    ${lastest_num}
    \       Run Keyword If    '${item_product_type}'=='imei'      Append to List     ${list_result_diff_quantities}     ${result_diff_quan_imei}       ELSE      Append to List     ${list_result_diff_quantities}     ${result_diff_quan}
    \       Run Keyword If    '${item_product_type}'=='imei'      Append to List     ${list_result_diff_values}     ${result_diff_value_imei}         ELSE      Append to List     ${list_result_diff_values}     ${result_diff_value}
    \       Run Keyword If    '${item_product_type}'=='imei'      Append to List     ${list_all_imei_bf_count}     ${list_imei_bf_count}       ELSE        Append to List     ${list_all_imei_bf_count}     ${EMPTY}
    \       Run Keyword If    '${item_product_type}'=='imei'      Append to List     ${list_all_current_imeis}     ${list_current_imeis}       ELSE        Append to List     ${list_all_imei_bf_count}     ${EMPTY}
    \       Log       ${list_result_diff_quantities}
    \       Log       ${list_result_diff_values}
    \       Log       ${list_all_imei_bf_count}
    Input inventory counting code    ${ma_phieukiem}
    ## get and assert data on UI
    ${soluong_thucte}    Set Variable    0
    ${index_actualnums}    Set Variable    -1
    : FOR    ${num}    IN    @{list_current_quan}
    \    ${index_actualnums}    Evaluate    ${index_actualnums} + 1
    \    ${num_item}    Get From List    ${list_current_quan}    ${index_actualnums}
    \    ${soluong_thucte}    Sum    ${soluong_thucte}    ${num_item}
    ${get_total_onhand}    Get Total OnHand and convert to number
    Should Be Equal    ${get_total_onhand}    ${soluong_thucte}
    ## click submit
    Click Element    ${button_luutam_kk}
    Update data success validation
    Get and assert info in Inventory    ${ma_phieukiem}    ${list_displayed_products}    ${list_onhand}       ${list_current_quan}    ${value_status_inventorycode_draft}
    Delete Inventory code in Inventory Counting List    ${ma_phieukiem}

ekg_finished
    [Arguments]        ${group_name}        ${dict_current_quan}       ${dict_product_type}
    Wait Until Keyword Succeeds    3 times    10 s    Go to Inventory form
    Go to select group pop up
    Select Group for counting products    ${group_name}
    ${list_current_quan}       Get Dictionary Values    ${dict_current_quan}
    ${list_products}       Get lists of product code in group    ${group_name}
    ${list_displayed_products}       Get Dictionary Keys    ${dict_current_quan}
    ${list_onhand}    ${list_cost}       Get list of Onhands and Costs frm API       ${list_displayed_products}
    ${list_displayed_product_types}       Get Dictionary Values      ${dict_product_type}
    ${ma_phieukiem}    Generate code automatically    PKK
    # Create lists
    ${list_result_diff_quantities}         Create List
    ${list_result_diff_values}        Create List
    ${list_all_imei_bf_count}        Create List
    ${list_all_current_imeis}      Create List
    Log        Input data
    ${lastest_num}    Set Variable    0
    : FOR       ${item_product}     ${item_product_type}        ${item_onhand}       ${item_cost}      ${item_current_quan}      IN ZIP          ${list_displayed_products}       ${list_displayed_product_types}      ${list_onhand}    ${list_cost}         ${list_current_quan}
    \       ${result_diff_quan_imei}     ${result_diff_value_imei}      ${list_current_imeis}       ${list_imei_bf_count}       ${lastest_num}     Run Keyword If    '${item_product_type}'=='imei'     Input current imeis in Inventory form then assert values      ${item_product}     ${item_onhand}       ${item_cost}    ${item_current_quan}       ${lastest_num}         ELSE       Set Variable     ${EMPTY}      ${EMPTY}    ${EMPTY}     ${EMPTY}     ${lastest_num}
    \       ${result_diff_quan}    ${result_diff_value}          ${lastest_num}      Run Keyword If    '${item_product_type}'!='imei'       Input current quantity for normal product to Inventory form then assert values     ${item_product}     ${item_onhand}       ${item_cost}    ${item_current_quan}      ${lastest_num}         ELSE       Set Variable     ${EMPTY}      ${EMPTY}    ${lastest_num}
    \       Run Keyword If    '${item_product_type}'=='imei'      Append to List     ${list_result_diff_quantities}     ${result_diff_quan_imei}       ELSE      Append to List     ${list_result_diff_quantities}     ${result_diff_quan}
    \       Run Keyword If    '${item_product_type}'=='imei'      Append to List     ${list_result_diff_values}     ${result_diff_value_imei}         ELSE      Append to List     ${list_result_diff_values}     ${result_diff_value}
    \       Run Keyword If    '${item_product_type}'=='imei'      Append to List     ${list_all_imei_bf_count}     ${list_imei_bf_count}       ELSE        Append to List     ${list_all_imei_bf_count}     ${EMPTY}
    \       Run Keyword If    '${item_product_type}'=='imei'      Append to List     ${list_all_current_imeis}     ${list_current_imeis}       ELSE        Append to List     ${list_all_imei_bf_count}     ${EMPTY}
    \       Log       ${list_result_diff_quantities}
    \       Log       ${list_result_diff_values}
    \       Log       ${list_all_imei_bf_count}
    Input inventory counting code    ${ma_phieukiem}
    ## get and assert data on UI
    ${soluong_thucte}    Set Variable    0
    ${index_actualnums}    Set Variable    -1
    : FOR    ${num}    IN    @{list_current_quan}
    \    ${index_actualnums}    Evaluate    ${index_actualnums} + 1
    \    ${num_item}    Get From List    ${list_current_quan}    ${index_actualnums}
    \    ${soluong_thucte}    Sum    ${soluong_thucte}    ${num_item}
    ${get_total_onhand}    Get Total OnHand and convert to number
    Should Be Equal    ${get_total_onhand}    ${soluong_thucte}
    ## click submit
    #Click Element    ${button_hoanthanh_kk}
    Press Key      //body     ${F9_KEY}
    Click Agree button on inventory balancing popup
    Update data success validation
    Update data success validation
    Get and assert info in Inventory    ${ma_phieukiem}    ${list_displayed_products}    ${list_onhand}       ${list_current_quan}    ${value_status_inventorycode_finished}
    Delete Inventory code in Inventory Counting List    ${ma_phieukiem}
