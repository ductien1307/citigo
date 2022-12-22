*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}      ${headless_browser}
Test Setup        Before Test Inventory Transfer
Test Teardown     After Test
Resource          ../../core/Giao_dich/chuyenhang_form_page.robot
Resource          ../../core/Giao_dich/chuyenhang_page_action.robot
Resource          ../../config/env_product/envi.robot
Resource          ../../core/share/toast_message.robot
Resource          ../../core/Giao_dich/giaodich_nav.robot
Resource          ../../core/Thiet_lap/branch_list_action.robot
Library           Collections
Resource          ../../core/share/list_dictionary.robot
Resource          ../../core/API/api_chuyenhang.robot

*** Variables ***
&{ch_dict1}       PIB03=60    DVT0109=70    QDCG027=60.5    IM23=3
&{ch_dict1_dvqd}       DVT0109=70    QDCG027=60.5
&{ch_dict1_product_type}       PIB03=pro    DVT0109=pro    QDCG027=unit    IM23=imei
&{ch_dict2_change_receive}        PIB03=50    DVT0109=53    QDCG027=21    IM23=1

*** Test Cases ***    Product Group            Dict SP&SL       CN Nhan        Thay doi SL nhan    Ghi chú
ChuyenHang_Hoanthanh
                      [Tags]         ECG                F    
                      [Template]     etechg_finished
                      Chuyển Nhóm       ${ch_dict1}      ${ch_dict1_product_type}     Nhánh A

Nhan 1 phan           [Tags]         ECG         APART
                      [Template]     etechg_apart
                      Chuyển Nhóm       ${ch_dict1}      ${ch_dict1_product_type}     ${ch_dict2_change_receive}    Nhánh A       chỉ nhận 1 phần

Chua nhan             [Tags]         ECG         NF
                      [Template]     etechg_notfinish
                      Chuyển Nhóm       ${ch_dict1}      ${ch_dict1_product_type}     Nhánh A

Khong nhan hang       [Tags]            ECG        C
                      [Template]     etechg_cancel
                      Chuyển Nhóm       ${ch_dict1}      ${ch_dict1_product_type}     Nhánh A

*** Keyword ***
etechg_finished
    [Arguments]       ${group_name}      ${dict_product_trans_quan}    ${dict_product_types}      ${input_branchname}
    [Timeout]    10 minutes
    ${inventory_code}    Generate code automatically    PCH
    ${get_current_branch_name}    Get current branch name
    Wait Until Keyword Succeeds    3 times    10 s    Go To Inventory Transfer form
    ${list_prs}    Get Dictionary Keys    ${dict_product_trans_quan}
    ${list_quantities}    Get Dictionary Values    ${dict_product_trans_quan}
    ${list_product_type}       Get Dictionary Values    ${dict_product_types}
    Log      Create list imei for imei products
    ${list_imei_all}    create list
    : FOR    ${item_product}     ${item_num}    ${item_product_type}    IN ZIP    ${list_prs}    ${list_quantities}      ${list_product_type}
    \    ${list_imei_by_single_product}=      Run Keyword If    '${item_product_type}' == 'imei'      Import multi imei for product    ${item_product}    ${item_num}      ELSE      Set Variable    nonimei
    \    Append to List       ${list_imei_all}        ${list_imei_by_single_product}
    Log       ${list_imei_all}
    Reload Page
    Go to select group pop up for transfer
    Select Group for transfer products    ${group_name}
    Select Branch on Inventory Transfer form    ${input_branchname}
    ${list_source_onhand_bf_trans}       ${list_target_onhand_bf_trans}     ${list_result_source_onhand_af_trans}    ${list_result_target_onhand_af_trans}      Get lists of recent source - target onhands and result source - result target onhands after transfer         ${list_prs}    ${list_quantities}      ${input_branchname}
    ${lastest_num}    Set Variable    3
    : FOR    ${item_product_code}    ${item_product_type}     ${item_trans_quan}    ${item_source_onhand_bf_trans}     ${item_target_onhand_bf_trans}       ${item_list_imei}      IN ZIP    ${list_prs}    ${list_product_type}     ${list_quantities}      ${list_source_onhand_bf_trans}       ${list_target_onhand_bf_trans}       ${list_imei_all}
    \    ${lastest_num}    Run Keyword If    '${item_product_type}'=='imei'    Input IMEI to Inventory transfer form    ${item_product_code}    ${item_trans_quan}    ${item_source_onhand_bf_trans}     ${item_target_onhand_bf_trans}      ${item_list_imei}     ${lastest_num}    ELSE      Input quantity to Inventory transfer form    ${item_product_code}    ${item_trans_quan}    ${item_source_onhand_bf_trans}     ${item_target_onhand_bf_trans}      ${lastest_num}
    Input inventory transfer code    ${inventory_code}
    Click Element    ${button_ch_hoanthanh}
    Transfer message success validation
    Wait Until Keyword Succeeds    3x    0.5 s    Switch Branch    ${get_current_branch_name}    ${input_branchname}
    Accept transferring proccess    ${inventory_code}
    Transfer message success validation
    Delete Transform code    ${inventory_code}

etechg_apart
    [Arguments]    ${group_name}      ${dict_product_trans_quan}    ${dict_product_types}      ${dict_changed_num}    ${input_branchname}      ${input_note}
    [Timeout]    10 minutes
    ${inventory_code}    Generate code automatically    PCH
    ${get_current_branch_name}    Get current branch name
    Wait Until Keyword Succeeds    3 times    1 s    Go To Inventory Transfer form
    ${list_prs}    Get Dictionary Keys    ${dict_product_trans_quan}
    ${list_quantities}    Get Dictionary Values    ${dict_product_trans_quan}
    ${list_product_type}       Get Dictionary Values    ${dict_product_types}
    ${list_num_changes}       Get Dictionary Values     ${dict_changed_num}
    Log      Create list imei for imei products
    ${list_imei_all}    create list
    : FOR    ${item_product}     ${item_num}    ${item_product_type}    IN ZIP    ${list_prs}    ${list_quantities}      ${list_product_type}
    \    ${list_imei_by_single_product}=      Run Keyword If    '${item_product_type}' == 'imei'      Import multi imei for product    ${item_product}    ${item_num}      ELSE      Set Variable    nonimei
    \    Append to List       ${list_imei_all}        ${list_imei_by_single_product}
    Log       ${list_imei_all}
    Reload Page
    Go to select group pop up for transfer
    Select Group for transfer products    ${group_name}
    Select Branch on Inventory Transfer form    ${input_branchname}
    ${list_source_onhand_bf_trans}       ${list_target_onhand_bf_trans}     ${list_result_source_onhand_af_trans}    ${list_result_target_onhand_af_trans}      Get lists of recent source - target onhands and result source - result target onhands after transfer         ${list_prs}    ${list_quantities}      ${input_branchname}
    ${lastest_num}    Set Variable    3
    : FOR    ${item_product_code}    ${item_product_type}     ${item_trans_quan}    ${item_source_onhand_bf_trans}     ${item_target_onhand_bf_trans}       ${item_list_imei}      IN ZIP    ${list_prs}    ${list_product_type}     ${list_quantities}      ${list_source_onhand_bf_trans}       ${list_target_onhand_bf_trans}       ${list_imei_all}
    \    ${lastest_num}    Run Keyword If    '${item_product_type}'=='imei'    Input IMEI to Inventory transfer form    ${item_product_code}    ${item_trans_quan}    ${item_source_onhand_bf_trans}     ${item_target_onhand_bf_trans}      ${item_list_imei}     ${lastest_num}    ELSE      Input quantity to Inventory transfer form    ${item_product_code}    ${item_trans_quan}    ${item_source_onhand_bf_trans}     ${item_target_onhand_bf_trans}      ${lastest_num}
    Input inventory transfer code    ${inventory_code}
    Click Element    ${button_ch_hoanthanh}
    Transfer message success validation
    Wait Until Keyword Succeeds    3x    0.5 s    Switch Branch    ${get_current_branch_name}    ${input_branchname}
    #${reverse_list_num_changes}    Reverse List one    ${list_num_changes}
    Wait Until Keyword Succeeds    3 times    1 s    Click record contains Transfer code    ${inventory_code}
    Wait Until Keyword Succeeds    3 times    1 s    Open Transfer Form in Target Branch    ${inventory_code}
    : FOR    ${item_product_code}    ${item_product_type}     ${item_trans_quan}    ${item_list_imei}     IN ZIP    ${list_prs}    ${list_product_type}     ${list_num_changes}      ${list_imei_all}
    \    ${list_del_imei}       Run Keyword If    '${item_product_type}'=='imei'    Remove from list by quantity      ${item_list_imei}     2
    \    Run Keyword If    '${item_product_type}'=='imei'    Delete imeis in Transfer form    @{list_del_imei}    ELSE     Change receiving quantity by product code in Transfer form    ${item_product_code}    ${item_trans_quan}
    Input data    ${textbox_note_in_received_screen}    ${input_note}
    Wait Until Element Is Enabled    ${button_complete}    1 min
    Click Element    ${button_complete}
    Delete Transform code    ${inventory_code}

etechg_notfinish
    [Arguments]       ${group_name}      ${dict_product_trans_quan}    ${dict_product_types}      ${input_branchname}
    ${inventory_code}    Generate code automatically    PCH
    ${get_current_branch_name}    Get current branch name
    Wait Until Keyword Succeeds    3 times    1 s    Go To Inventory Transfer form
    ${list_prs}    Get Dictionary Keys    ${dict_product_trans_quan}
    ${list_quantities}    Get Dictionary Values    ${dict_product_trans_quan}
    ${list_product_type}       Get Dictionary Values    ${dict_product_types}
    Log      Create list imei for imei products
    ${list_imei_all}    create list
    : FOR    ${item_product}     ${item_num}    ${item_product_type}    IN ZIP    ${list_prs}    ${list_quantities}      ${list_product_type}
    \    ${list_imei_by_single_product}=      Run Keyword If    '${item_product_type}' == 'imei'      Import multi imei for product    ${item_product}    ${item_num}      ELSE      Set Variable    nonimei
    \    Append to List       ${list_imei_all}        ${list_imei_by_single_product}
    Log       ${list_imei_all}
    Reload Page
    Go to select group pop up for transfer
    Select Group for transfer products    ${group_name}
    Select Branch on Inventory Transfer form    ${input_branchname}
    ${list_source_onhand_bf_trans}       ${list_target_onhand_bf_trans}     ${list_result_source_onhand_af_trans}    ${list_result_target_onhand_af_trans}      Get lists of recent source - target onhands and result source - result target onhands after transfer         ${list_prs}    ${list_quantities}      ${input_branchname}
    ${lastest_num}    Set Variable    3
    : FOR    ${item_product_code}    ${item_product_type}     ${item_trans_quan}    ${item_source_onhand_bf_trans}     ${item_target_onhand_bf_trans}       ${item_list_imei}      IN ZIP    ${list_prs}    ${list_product_type}     ${list_quantities}      ${list_source_onhand_bf_trans}       ${list_target_onhand_bf_trans}       ${list_imei_all}
    \    ${lastest_num}    Run Keyword If    '${item_product_type}'=='imei'    Input IMEI to Inventory transfer form    ${item_product_code}    ${item_trans_quan}    ${item_source_onhand_bf_trans}     ${item_target_onhand_bf_trans}      ${item_list_imei}     ${lastest_num}    ELSE      Input quantity to Inventory transfer form    ${item_product_code}    ${item_trans_quan}    ${item_source_onhand_bf_trans}     ${item_target_onhand_bf_trans}      ${lastest_num}
    Input inventory transfer code    ${inventory_code}
    Click Element    ${button_ch_hoanthanh}
    Transfer message success validation
    sleep    2 s
    Wait Until Keyword Succeeds    3x    0.5 s    Switch Branch    ${get_current_branch_name}    ${input_branchname}
    Assert values Transfer form in Target branch    ${inventory_code}    Đang chuyển    ${get_current_branch_name}    ${input_branchname}
    ## validate onstock card
    Delete Transform code    ${inventory_code}

etechg_cancel
    [Arguments]       ${group_name}      ${dict_product_trans_quan}    ${dict_product_types}      ${input_branchname}
    ${inventory_code}    Generate code automatically    PCH
    ${get_current_branch_name}    Get current branch name
    Wait Until Keyword Succeeds    3 times    1 s    Go To Inventory Transfer form
    ${list_prs}    Get Dictionary Keys    ${dict_product_trans_quan}
    ${list_quantities}    Get Dictionary Values    ${dict_product_trans_quan}
    ${list_product_type}       Get Dictionary Values    ${dict_product_types}
    Log      Create list imei for imei products
    ${list_imei_all}    create list
    : FOR    ${item_product}     ${item_num}    ${item_product_type}    IN ZIP    ${list_prs}    ${list_quantities}      ${list_product_type}
    \    ${list_imei_by_single_product}=      Run Keyword If    '${item_product_type}' == 'imei'      Import multi imei for product    ${item_product}    ${item_num}      ELSE      Set Variable    nonimei
    \    Append to List       ${list_imei_all}        ${list_imei_by_single_product}
    Log       ${list_imei_all}
    Reload Page
    Go to select group pop up for transfer
    Select Group for transfer products    ${group_name}
    Select Branch on Inventory Transfer form    ${input_branchname}
    ${list_source_onhand_bf_trans}       ${list_target_onhand_bf_trans}     ${list_result_source_onhand_af_trans}    ${list_result_target_onhand_af_trans}      Get lists of recent source - target onhands and result source - result target onhands after transfer         ${list_prs}    ${list_quantities}      ${input_branchname}
    ${lastest_num}    Set Variable    3
    : FOR    ${item_product_code}    ${item_product_type}     ${item_trans_quan}    ${item_source_onhand_bf_trans}     ${item_target_onhand_bf_trans}       ${item_list_imei}      IN ZIP    ${list_prs}    ${list_product_type}     ${list_quantities}      ${list_source_onhand_bf_trans}       ${list_target_onhand_bf_trans}       ${list_imei_all}
    \    ${lastest_num}    Run Keyword If    '${item_product_type}'=='imei'    Input IMEI to Inventory transfer form    ${item_product_code}    ${item_trans_quan}    ${item_source_onhand_bf_trans}     ${item_target_onhand_bf_trans}      ${item_list_imei}     ${lastest_num}    ELSE      Input quantity to Inventory transfer form    ${item_product_code}    ${item_trans_quan}    ${item_source_onhand_bf_trans}     ${item_target_onhand_bf_trans}      ${lastest_num}
    Input inventory transfer code    ${inventory_code}
    Click Element    ${button_ch_hoanthanh}
    Transfer message success validation
    Wait Until Keyword Succeeds    3x    0.5 s    Switch Branch    ${get_current_branch_name}    ${input_branchname}
    Assert values Transfer form in Target branch    ${inventory_code}    Đang chuyển    ${get_current_branch_name}    ${input_branchname}
    ## click cancel
    Cancel transferring proccess    ${inventory_code}
