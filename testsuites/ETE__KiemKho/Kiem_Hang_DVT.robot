*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}      ${headless_browser}
Test Setup        Before Test Kiem Kho
Test Teardown     After Test
Resource          ../../core/Hang_Hoa/kiemkho_list_action.robot
Resource          ../../core/hang_hoa/danh_muc_list_action.robot
Resource          ../../config/env_product/envi.robot
Resource          ../../core/share/toast_message.robot
Resource          ../../core/API/api_danhmuc_hanghoa.robot
Resource          ../../core/API/api_kiemkho.robot
Resource          ../../core/share/list_dictionary.robot

*** Variables ***
&{dict_1_kk}      DVTK01A=5201.5    QDK007=2000    QDK008=0
&{dict_2_kk}      DVTK02A=1100    QDK009=600    QDK010=80.4

*** Test Cases ***    Dict Product and Num
Kiem n san pham_Hoanthanh
                      [Documentation]         1 Hàng DVT với 2 hh thành phần. Input: HH cơ bản: kiểm lớn hơn, HH quy đổi 1: lớn hơn, HH quy đổi 2: bằng 0
                      [Tags]                  EKU         EK                                                                                                       F    GOLIVE2
                      [Template]              etekku_finished
                      ${dict_1_kk}

Kiem n san pham_Luutam
                      [Documentation]         1 Hàng DVT với 2 hh thành phần. Input: HH cơ bản có tồn =0: , HH quy đổi 1: lớn hơn 0, HH quy đổi 2: lớn hơn 0
                      [Tags]                  EKU                EK                                                                                                D
                      [Template]              etekku_draft
                      ${dict_2_kk}

*** Keyword ***
etekku_finished
    [Arguments]    ${dict_kk}
    [Documentation]    Kiểm 3 hàng hóa DVT trong đó 1 cơ bản và 2 quy đổi.
    ...    - Validate số lượng lệch, giá trị lệch của HH cơ bản và HH quy đổi trên màn hình UI
    ...    - Validate lịch sử nhập dữ liệu trên UI
    ...    - Validate các sản phẩm kiểm trong phiếu kiểm
    ...    - Validate thẻ kho: tồn cuối và số lượng trong của thẻ kho.
    [Timeout]    5 minutes
    ${ma_phieukiem}    Generate code automatically    PKK
    Wait Until Keyword Succeeds    3 times    10 s    Go to Inventory form
    ${list_prs}    Get Dictionary Keys    ${dict_kk}
    ${list_nums}    Get Dictionary Values    ${dict_kk}
    ${primary_product_code}    Get From List    ${list_prs}    0
    ${primary_product_num}    Get From List    ${list_nums}    0
    ${list_qd_product_num}    Copy List    ${list_nums}
    Remove From List    ${list_qd_product_num}    0
    ${list_qd_product}    Get list DVQD by product code    ${primary_product_code}
    ${list_result_giavon_bf_count}    Create List
    ${list_result_ton_bf_count}    Create List
    ${list_result_soluong_lech}    Create List
    ${list_result_giatri_lech}    Create List
    ${list_num_actual_cb_by_qd}    Create List
    ##
    ${list_dvqd}    Create List
    ${index_list_pr}    Set Variable    0
    : FOR    ${item_pr}    IN    @{list_qd_product}
    \    ${index_list_pr}    Evaluate    ${index_list_pr} + 1
    \    ${dvqd}    Get DVQD by product code frm API    ${item_pr}
    \    Append To List    ${list_dvqd}    ${dvqd}
    \    Log Many    ${list_dvqd}
    log many    ${list_dvqd}
    ## get primary product
    ${source_primary_product_onhand_bf_trans}    ${source_primary_baseprice_bf_trans}    Get Cost and OnHand of Unit frm API    ${primary_product_code}
    ${result_diff_num_primary}    Minus    ${primary_product_num}    ${source_primary_product_onhand_bf_trans}
    ${result_diff_value_primary}    Multiplication and round    ${source_primary_baseprice_bf_trans}    ${result_diff_num_primary}
    ## input data
    ${list_result_soluong_lech}    ${list_result_giatri_lech}    ${list_result_ton_bf_count}    ${list_num_actual_cb_by_qd}    Get lists of Primary and Unit products    ${source_primary_baseprice_bf_trans}    ${primary_product_code}
    ...    ${list_qd_product}    ${list_dvqd}    ${list_qd_product_num}    ${list_result_soluong_lech}    ${list_result_giatri_lech}    ${list_result_ton_bf_count}
    ...    ${list_num_actual_cb_by_qd}
    Insert Into List    ${list_result_soluong_lech}    0    ${result_diff_num_primary}
    Insert Into List    ${list_result_giatri_lech}    0    ${result_diff_value_primary}
    Insert Into List    ${list_result_ton_bf_count}    0    ${source_primary_product_onhand_bf_trans}
    ${list_num_actual_cb}    Copy List    ${list_num_actual_cb_by_qd}
    Insert Into List    ${list_num_actual_cb}    0    ${result_diff_num_primary}
    Log Many    ${list_num_actual_cb}
    ${lastest_num}    Set Variable    0
    : FOR    ${item_pr}    ${item_num}    ${item_result_soluong_lech}    ${item_result_giatri_lech}    IN ZIP    ${list_prs}
    ...    ${list_nums}    ${list_result_soluong_lech}    ${list_result_giatri_lech}
    \    ${lastest_num}    Input Unit products and nums to Inventory form then assert values    ${item_pr}    ${item_num}    ${item_result_soluong_lech}    ${item_result_giatri_lech}
    \    ...    ${lastest_num}
    Log To Console    Cal actual num of primary product code and Its onhand
    ${actual_num_pr}    Sum values in list    ${list_num_actual_cb}
    ${onhand_af_ex_primary_product}    SUM    ${source_primary_product_onhand_bf_trans}    ${actual_num_pr}
    Input inventory counting code    ${ma_phieukiem}
    Sleep    2s    Wait for loading data
    ## get and assert data on UI
    ## click submit
    #Click Element    ${button_hoanthanh_kk}
    Press Key      //body     ${F9_KEY}
    Click Agree button on inventory balancing popup
    Update data success validation
    Sleep    5s    Wait for loading data
    ### assert values thr API
    Log To Console    Assert giá trị trong mã phiếu kiểm
    ${reversed_list_prs}    ${reversed_list_result_ton_af_count}    ${reversed_list_nums}    ${reversed_list_result_soluong_lech}    ${reversed_list_result_giatri_lech}    Reverse five lists    ${list_prs}
    ...    ${list_result_ton_bf_count}    ${list_nums}    ${list_result_soluong_lech}    ${list_result_giatri_lech}
    ${index}    Set Variable    -1
    : FOR    ${item_list_prs}    ${item_list_result_ton_af_count}    ${item_list_nums}    ${item_list_result_soluong_lech}    ${item_list_result_giatri_lech}    IN ZIP
    ...    ${reversed_list_prs}    ${reversed_list_result_ton_af_count}    ${reversed_list_nums}    ${reversed_list_result_soluong_lech}    ${reversed_list_result_giatri_lech}
    \    ${index}=    Evaluate    ${index} + 1
    \    Get and assert info of products in inventory code    ${ma_phieukiem}    ${item_list_prs}    ${item_list_result_ton_af_count}    ${item_list_nums}    ${item_list_result_soluong_lech}
    \    ...    ${item_list_result_giatri_lech}    ${index}    ${value_status_inventorycode_finished}
    # assert giá trị trong thẻ kho của hàng hóa
    Assert values in Stock Card    ${ma_phieukiem}    ${primary_product_code}    ${onhand_af_ex_primary_product}    ${actual_num_pr}
    Delete Inventory code in Inventory Counting List    ${ma_phieukiem}

etekku_draft
    [Arguments]    ${dict_kk}
    [Documentation]    Kiểm hàng với n sản phẩm_ click Hoàn thành
    ...
    ...    - Validate UI
    ...    - Validate phiếu kiểm
    ...    - Validate thẻ kho
    [Timeout]    5 minutes
    ${ma_phieukiem}    Generate code automatically    PKK
    Wait Until Keyword Succeeds    3 times    10 s    Go to Inventory form
    ${list_prs}    Get Dictionary Keys    ${dict_kk}
    ${list_nums}    Get Dictionary Values    ${dict_kk}
    ${primary_product_code}    Get From List    ${list_prs}    0
    ${primary_product_num}    Get From List    ${list_nums}    0
    ${list_qd_product_num}    Copy List    ${list_nums}
    Remove From List    ${list_qd_product_num}    0
    ${list_qd_product}    Get list DVQD by product code    ${primary_product_code}
    ${list_result_giavon_bf_count}    Create List
    ${list_result_ton_bf_count}    Create List
    ${list_result_soluong_lech}    Create List
    ${list_result_giatri_lech}    Create List
    ${list_num_actual_cb_by_qd}    Create List
    ##
    ${list_dvqd}    Create List    ${EMPTY}
    ${index_list_pr}    Set Variable    0
    : FOR    ${item_pr}    IN    @{list_qd_product}
    \    ${index_list_pr}    Evaluate    ${index_list_pr} + 1
    \    ${dvqd}    Get DVQD by product code frm API    ${item_pr}
    \    Append To List    ${list_dvqd}    ${dvqd}
    \    Log Many    ${list_dvqd}
    Remove From List    ${list_dvqd}    0
    log many    ${list_dvqd}
    ## get primary product
    ${source_primary_product_onhand_bf_trans}    ${source_primary_baseprice_bf_trans}    Get Cost and OnHand of Unit frm API    ${primary_product_code}
    ${result_diff_num_primary}    Minus    ${primary_product_num}    ${source_primary_product_onhand_bf_trans}
    ${result_diff_value_primary}    Multiplication and round    ${source_primary_baseprice_bf_trans}    ${result_diff_num_primary}
    ## input data
    ${list_result_soluong_lech}    ${list_result_giatri_lech}    ${list_result_ton_bf_count}    ${list_num_actual_cb_by_qd}    Get lists of Primary and Unit products    ${source_primary_baseprice_bf_trans}    ${primary_product_code}
    ...    ${list_qd_product}    ${list_dvqd}    ${list_qd_product_num}    ${list_result_soluong_lech}    ${list_result_giatri_lech}    ${list_result_ton_bf_count}
    ...    ${list_num_actual_cb_by_qd}
    Insert Into List    ${list_result_soluong_lech}    0    ${result_diff_num_primary}
    Insert Into List    ${list_result_giatri_lech}    0    ${result_diff_value_primary}
    Insert Into List    ${list_result_ton_bf_count}    0    ${source_primary_product_onhand_bf_trans}
    ${list_num_actual_cb}    Copy List    ${list_num_actual_cb_by_qd}
    Insert Into List    ${list_num_actual_cb}    0    ${result_diff_num_primary}
    Log Many    ${list_num_actual_cb}
    ${lastest_num}    Set Variable    0
    : FOR    ${item_pr}    ${item_num}    ${item_result_soluong_lech}    ${item_result_giatri_lech}    IN ZIP    ${list_prs}
    ...    ${list_nums}    ${list_result_soluong_lech}    ${list_result_giatri_lech}
    \    ${lastest_num}    Input Unit products and nums to Inventory form then assert values    ${item_pr}    ${item_num}    ${item_result_soluong_lech}    ${item_result_giatri_lech}
    \    ...    ${lastest_num}
    Log To Console    Cal actual num of primary product code and Its onhand
    ${actual_num_pr}    Sum values in list    ${list_num_actual_cb}
    ${onhand_af_ex_primary_product}    Minus    ${source_primary_product_onhand_bf_trans}    ${actual_num_pr}
    Input inventory counting code    ${ma_phieukiem}
    Sleep    2s    Wait for loading data
    ## get and assert data on UI
    ## click submit
    Click Element    ${button_luutam_kk}
    Update data success validation
    Sleep    5s    Wait for loading data
    ### assert values thr API
    Log To Console    Assert giá trị trong mã phiếu kiểm
    ${reversed_list_prs}    ${reversed_list_result_ton_af_count}    ${reversed_list_nums}    ${reversed_list_result_soluong_lech}    ${reversed_list_result_giatri_lech}    Reverse five lists    ${list_prs}
    ...    ${list_result_ton_bf_count}    ${list_nums}    ${list_result_soluong_lech}    ${list_result_giatri_lech}
    ${index}    Set Variable    -1
    : FOR    ${item_list_prs}    ${item_list_result_ton_af_count}    ${item_list_nums}    ${item_list_result_soluong_lech}    ${item_list_result_giatri_lech}    IN ZIP
    ...    ${reversed_list_prs}    ${reversed_list_result_ton_af_count}    ${reversed_list_nums}    ${reversed_list_result_soluong_lech}    ${reversed_list_result_giatri_lech}
    \    ${index}=    Evaluate    ${index} + 1
    \    Get and assert info of products in inventory code    ${ma_phieukiem}    ${item_list_prs}    ${item_list_result_ton_af_count}    ${item_list_nums}    ${item_list_result_soluong_lech}
    \    ...    ${item_list_result_giatri_lech}    ${index}    ${value_status_inventorycode_draft}
    # assert giá trị trong thẻ kho của hàng hóa
    Assert values not avaiable in Stock Card    ${ma_phieukiem}    ${primary_product_code}
    Delete Inventory code in Inventory Counting List    ${ma_phieukiem}
