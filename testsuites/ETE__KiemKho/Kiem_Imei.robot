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
&{dict_imei_1}    KKIM002=ALL001,ALL002,ALL003    KKIM003=MKM001,MKM002    KKIM004=KKK001,KKK002,KKK003,KKK004    KKIM005=AAA001,AAA002,AAA003,AAA004
&{dict_imei_2}    KKIM002=ALL001,ALL002,ALL003    KKIM003=MKM001,MKM002
&{dict_imei_3}    KKIM001=CQH001,CQH002,CQH003,CQH004,CQH021,CQH022
&{dict_imei_4}    KKIM001=CQH023,CQH024,CQH025

*** Test Cases ***    dictionary
Kiem hang hoa_Luutam
                      [Tags]             D                              EK                                                                        EKS
                      [Template]         etekks_draft
                      ${dict_imei_1}

Kiem hang hoa_Hoanthanh
                      [Documentation]    tc1:Kiểm kho với imei tồn tại trong hệ thống, tc2: Kiểm kho với imei không tồn tại trong hệ thống
                      [Tags]             F                                                       EK                                             EKS
                      [Template]         etekks_finished
                      ${dict_imei_2}     #Kiểm kho với imei tồn tại trong hệ thống
                      ${dict_imei_3}     #Kiểm kho với imei không tồn tại trong HT

*** Keyword ***
etekks_draft
    [Arguments]    ${dict}
    [Documentation]    Kiểm hàng với 1 sản phẩm_ click lưu tạm
    ...
    ...    - Validate UI
    ...    - Validate phiếu kiểm
    ...    - Validate thẻ kho không tồn tại Chứng từ Mã kiểm kho
    [Timeout]
    ${ma_phieukiem}    Generate code automatically    PKK
    ${list_pr}    Get Dictionary Keys    ${dict}
    ## get data
    Wait Until Keyword Succeeds    3 times    10 s    Go to Inventory form
    ${list_result_giavon_bf_count}    ${list_result_ton_bf_count}    ${list_result_soluong_lech}    ${list_result_giatri_lech}    ${list_counted_imei_by_product_onrow}    ${list_system_imei_by_product_bf_counted}    ${list_actual_nums}
    ...    Input products and imeis in Inventory form then assert values      ${dict}    @{list_pr}
    ###
    Input inventory counting code    ${ma_phieukiem}
    ## get and assert data on UI
    ${soluong_thucte}    Set Variable    0
    ${index_actualnums}    Set Variable    -1
    : FOR    ${num}    IN    @{list_actual_nums}
    \    ${index_actualnums}    Evaluate    ${index_actualnums} + 1
    \    ${num_item}    Get From List    ${list_actual_nums}    ${index_actualnums}
    \    ${soluong_thucte}    Sum    ${soluong_thucte}    ${num_item}
    ${get_total_onhand}    Get Total OnHand and convert to number
    Should Be Equal    ${get_total_onhand}    ${soluong_thucte}
    ## click submit
    Click Element    ${button_luutam_kk}
    Update data success validation
    ### assert values thr API
    ${list_reversed_pro_af_count}    ${list_reversed_ton_af_count}    ${list_reversed_soluong_lech}    ${list_reversed_giatri_lech}    ${list_reversed_imei_by_product_onrow}    ${list_reversed_actual_nums}    Reverse six lists
    ...    ${list_pr}    ${list_result_ton_bf_count}    ${list_result_soluong_lech}    ${list_result_giatri_lech}    ${list_counted_imei_by_product_onrow}    ${list_actual_nums}
    ${index_in_list}    Set Variable    -1
    : FOR    ${item_product}    ${item_ton_af_count}    ${item_actual_num}    ${item_soluong_lech}    ${item_giatri_lech}    ${item_reversed_imei_by_product_onrow}
    ...    IN ZIP    ${list_reversed_pro_af_count}    ${list_reversed_ton_af_count}    ${list_reversed_actual_nums}    ${list_reversed_soluong_lech}    ${list_reversed_giatri_lech}
    ...    ${list_reversed_imei_by_product_onrow}
    \    ${index_in_list}    Evaluate    ${index_in_list} + 1
    \    Get and assert info of imeis in Inventory    ${ma_phieukiem}    ${item_product}    ${item_ton_af_count}    ${item_actual_num}    ${item_soluong_lech}
    \    ...    ${item_giatri_lech}    ${index_in_list}    ${value_status_inventorycode_draft}    ${item_reversed_imei_by_product_onrow}
    ###
    : FOR    ${item_product}    IN    @{list_pr}
    \    Assert values not avaiable in Stock Card    ${ma_phieukiem}    ${item_product}
    ${index_list_imei}    Set Variable    -1
    : FOR    ${item_product}    ${list_imei_bf_counted}    IN ZIP    ${list_pr}    ${list_system_imei_by_product_bf_counted}
    \    ${index_list_imei}    Evaluate    ${index_list_imei} + 1
    \    ${list_imei_bf_counted}    Set Variable    @{list_system_imei_by_product_bf_counted}[${index_list_imei}]
    \    Assert imei avaiable in SerialImei tab    ${item_product}    ${list_imei_bf_counted}
    Delete Inventory code in Inventory Counting List    ${ma_phieukiem}

etekks_finished
    [Arguments]    ${dict}
    [Documentation]    Kiểm hàng với 1 sản phẩm_click hoàn thành
    ...
    ...    - Validate UI
    ...    - Validate phiếu kiểm
    ...    - Validate thẻ kho không tồn tại Chứng từ Mã kiểm kho, validate tồn kho imei
    [Timeout]
    ${ma_phieukiem}    Generate code automatically    PKK
    ${list_pr}    Get Dictionary Keys    ${dict}
    ## get data
    Wait Until Keyword Succeeds    3 times    10 s    Go to Inventory form
    ${list_result_giavon_bf_count}    ${list_result_ton_bf_count}    ${list_result_soluong_lech}    ${list_result_giatri_lech}    ${list_counted_imei_by_product_onrow}    ${list_system_imei_by_product_bf_counted}    ${list_actual_nums}
    ...    Input products and imeis in Inventory form then assert values     ${dict}    @{list_pr}
    ###
    Input inventory counting code    ${ma_phieukiem}
    ## get and assert data on UI
    ${soluong_thucte}    Set Variable    0
    ${index_actualnums}    Set Variable    -1
    : FOR    ${num}    IN    @{list_actual_nums}
    \    ${index_actualnums}    Evaluate    ${index_actualnums} + 1
    \    ${num_item}    Get From List    ${list_actual_nums}    ${index_actualnums}
    \    ${soluong_thucte}    Sum    ${soluong_thucte}    ${num_item}
    ${get_total_onhand}    Get Total OnHand and convert to number
    Should Be Equal    ${get_total_onhand}    ${soluong_thucte}
    ## click submit
    #Click Element    ${button_hoanthanh_kk}
    Press Key      //body     ${F9_KEY}
    Click Agree button on inventory balancing popup
    Update data success validation
    ### assert values thr API
    ${list_reversed_pro_af_count}    ${list_reversed_ton_af_count}    ${list_reversed_soluong_lech}    ${list_reversed_giatri_lech}    ${list_reversed_imei_by_product_onrow}    ${list_reversed_actual_nums}    Reverse six lists
    ...    ${list_pr}    ${list_result_ton_bf_count}    ${list_result_soluong_lech}    ${list_result_giatri_lech}    ${list_counted_imei_by_product_onrow}    ${list_actual_nums}
    ${index_in_list}    Set Variable    -1
    : FOR    ${item_product}    ${item_ton_af_count}    ${item_actual_num}    ${item_soluong_lech}    ${item_giatri_lech}    ${item_reversed_imei_by_product_onrow}
    ...    IN ZIP    ${list_reversed_pro_af_count}    ${list_reversed_ton_af_count}    ${list_reversed_actual_nums}    ${list_reversed_soluong_lech}    ${list_reversed_giatri_lech}
    ...    ${list_reversed_imei_by_product_onrow}
    \    ${index_in_list}    Evaluate    ${index_in_list} + 1
    \    Get and assert info of imeis in Inventory    ${ma_phieukiem}    ${item_product}    ${item_ton_af_count}    ${item_actual_num}    ${item_soluong_lech}
    \    ...    ${item_giatri_lech}    ${index_in_list}    ${value_status_inventorycode_finished}    ${item_reversed_imei_by_product_onrow}
    ###
    : FOR    ${item_product}    ${item_actual_num}    ${item_soluong_lech}    IN ZIP    ${list_pr}    ${list_actual_nums}
    ...    ${list_result_soluong_lech}
    \    Assert values in Stock Card    ${ma_phieukiem}    ${item_product}    ${item_actual_num}    ${item_soluong_lech}
    Log To Console    Assert all remained imeis that not counted are not available in Stock card
    ### assert imei in imei tab
    : FOR    ${item_product}    ${items_counted_imei_by_product}    IN ZIP    ${list_pr}    ${list_counted_imei_by_product_onrow}
    \    ${items_counted_imei_by_product}    Convert String to List    ${items_counted_imei_by_product}
    \    Assert imei avaiable in SerialImei tab    ${item_product}    ${items_counted_imei_by_product}
    Delete Inventory code in Inventory Counting List    ${ma_phieukiem}
