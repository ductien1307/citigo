*** Settings ***
Suite Setup       Init Test Environment    zone17    http://localhost:9999/wd/hub     ${account}     ${headless_browser}
Suite Teardown    After Test
Test Teardown
Resource          ../../core/Giao_dich/chuyenhang_form_page.robot
Resource          ../../core/Giao_dich/chuyenhang_page_action.robot
Resource          ../../config/env_product/envi.robot
Resource          ../../core/share/toast_message.robot
Resource          ../../core/Giao_dich/giaodich_nav.robot
Resource          ../../core/share/list_dictionary.robot
Resource          ../../core/Thiet_lap/branch_list_action.robot
Library           Collections
Resource          ../../core/share/list_dictionary.robot
Resource          ../../core/API/api_chuyenhang.robot

*** Variables ***
&{dict_prs}       LD01=30    LD02=30
@{list_num}       9    12
@{list_num_change}    5    3
&{dict_prs1}      LD03=30    LD04=30
@{list_num1}      14    8
&{dict_prs2}      LD05=30    LD06=30
@{list_num2}      20    12
&{dict_prs3}      LD07=30    LD08=30
@{list_num3}      9    16

*** Test Cases ***
Chuyenhang_Hoanthanh
    [Tags]           ECL
    [Setup]
    [Template]    etechl_finished
    ${dict_prs}    ${list_num}    Nhánh A

Nhan 1 phan
    [Tags]            ECL
    [Template]    etechl_apart
    ${dict_prs1}    ${list_num1}    ${list_num_change}    Nhánh A    nhận 1 phần

Chua nhan
    [Tags]           ECL
    [Template]    etechl_notfinish
    ${dict_prs2}    ${list_num2}    Nhánh A

Khong nhan hang
    [Tags]           ECL
    [Template]    etechl_cancel
    ${dict_prs3}    ${list_num3}    Nhánh A

*** Keywords ***
etechl_finished
    [Arguments]    ${dict}    ${list_nums_trans}    ${input_branchname}
    ${list_prs}    Get Dictionary Keys    ${dict}
    ${list_num}    Get Dictionary Values    ${dict}
    ${list_tenlo_all}    Import lot name for products by generating randomly    ${list_prs}    ${list_num}
    Log Many    ${list_tenlo_all}
    Before Test Inventory Transfer
    ${ma_phieuchuyen}    Generate code automatically    PCH
    ${get_current_branch_name}    Get current branch name
    Wait Until Keyword Succeeds    3 times    10 s    Go To Inventory Transfer form
    Select Branch on Inventory Transfer form    ${input_branchname}
    ${list_result_source_onhand_af_trans}    Create List
    ${list_result_target_onhand_af_trans}    Create List
    ${list_result_source_onhand_lot_af_trans}    Create List
    ${list_result_target_onhand_lot_af_trans}    Create List
    ${lastest_num}    Set Variable    0
    : FOR    ${item_product}    ${item_lotname}    ${item_num}    IN ZIP    ${list_prs}    ${list_tenlo_all}
    ...    ${list_nums_trans}
    \    ${list_result_source_onhand_af_trans}    ${list_result_target_onhand_af_trans}    ${list_result_source_onhand_lot_af_trans}    ${list_result_target_onhand_lot_af_trans}    ${lastest_num}    Input products - lot name - nums to Inventory transfer form
    \    ...    ${list_result_source_onhand_af_trans}    ${list_result_target_onhand_af_trans}    ${list_result_source_onhand_lot_af_trans}    ${list_result_target_onhand_lot_af_trans}    ${input_branchname}
    \    ...    ${item_product}    ${item_lotname}    ${item_num}    ${lastest_num}
    Input inventory transfer code    ${ma_phieuchuyen}
    Click Element    ${button_ch_hoanthanh}
    #Toast flex message validation    Cập nhật phiếu chuyển hàng thành công
    Sleep    2s
    Wait Until Keyword Succeeds    3 times    20s    Switch Branch    ${get_current_branch_name}    ${input_branchname}
    Accept transferring proccess    ${ma_phieuchuyen}
    #Toast flex message validation    Cập nhật phiếu chuyển hàng thành công
    ## validate onstock card
    ${list_result_num_in_instock_source_branch}    Change negative number to positive number and vice versa in List    ${list_nums_trans}
    ## assert stock card in source branch
    : FOR    ${item_pr}    ${item_num_íntockcard}    ${item_list_result_transferring_onhand_bf_trans}    ${item_list_result_source_onhand_lot_af_trans}    ${item_tenlo}    IN ZIP
    ...    ${list_prs}    ${list_result_num_in_instock_source_branch}    ${list_result_source_onhand_af_trans}    ${list_result_source_onhand_lot_af_trans}    ${list_tenlo_all}
    \    Assert values in Stock Card    ${ma_phieuchuyen}    ${item_pr}    ${item_list_result_transferring_onhand_bf_trans}    ${item_num_íntockcard}
    \    Assert values in Stock Card in tab Lo - HSD    ${ma_phieuchuyen}    ${item_pr}    ${item_pr}    ${item_list_result_source_onhand_lot_af_trans}    ${item_num_íntockcard}
    \    ...    ${item_tenlo}
    ## assert stock card in target branch
    : FOR    ${item_pr}    ${item_num_íntockcard}    ${item_list_result_received_onhand_bf_trans}    ${item_list_result_target_onhand_lot_af_trans}    ${item_tenlo}    IN ZIP
    ...    ${list_prs}    ${list_nums_trans}    ${list_result_target_onhand_af_trans}    ${list_result_target_onhand_lot_af_trans}    ${list_tenlo_all}
    \    Assert values in Stock Card by Branch    ${ma_phieuchuyen}    ${item_pr}    ${item_list_result_received_onhand_bf_trans}    ${item_num_íntockcard}    ${input_branchname}
    \    Assert values in Stock Card in tab Lo - HSD by Branch Name    ${input_branchname}    ${ma_phieuchuyen}    ${item_pr}    ${item_pr}    ${item_list_result_target_onhand_lot_af_trans}
    \    ...    ${item_num_íntockcard}    ${item_tenlo}
    Wait Until Keyword Succeeds    3x    20 s    Switch Branch    ${input_branchname}    ${get_current_branch_name}
    Delete Transform code    ${ma_phieuchuyen}

etechl_apart
    [Arguments]    ${dict}    ${list_nums_trans}    ${list_nums_change}    ${input_branchname}    ${input_note}
    ${list_prs}    Get Dictionary Keys    ${dict}
    ${list_num}    Get Dictionary Values    ${dict}
    ${list_tenlo_all}    Import lot name for products by generating randomly    ${list_prs}    ${list_num}
    Log Many    ${list_tenlo_all}
    Before Test Inventory Transfer
    ${ma_phieuchuyen}    Generate code automatically    PCH
    ${get_current_branch_name}    Get current branch name
    Wait Until Keyword Succeeds    3 times    10 s    Go To Inventory Transfer form
    Select Branch on Inventory Transfer form    ${input_branchname}
    ${list_result_source_onhand_af_trans}    Create List
    ${list_result_target_onhand_af_trans}    Create List
    ${list_result_source_onhand_lot_af_trans}    Create List
    ${list_result_target_onhand_lot_af_trans}    Create List
    ${lastest_num}    Set Variable    0
    : FOR    ${item_product}    ${item_lotname}    ${item_num}    ${item_num_change}    IN ZIP    ${list_prs}
    ...    ${list_tenlo_all}    ${list_nums_trans}    ${list_nums_change}
    \    ${list_result_source_onhand_af_trans}    ${list_result_target_onhand_af_trans}    ${list_result_source_onhand_lot_af_trans}    ${list_result_target_onhand_lot_af_trans}    ${lastest_num}    Input products - lot name - nums to Inventory transfer form in case receiving a part
    \    ...    ${list_result_source_onhand_af_trans}    ${list_result_target_onhand_af_trans}    ${list_result_source_onhand_lot_af_trans}    ${list_result_target_onhand_lot_af_trans}    ${input_branchname}
    \    ...    ${item_product}    ${item_lotname}    ${item_num}    ${item_num_change}    ${lastest_num}
    Input inventory transfer code    ${ma_phieuchuyen}
    #Click Element    ${button_ch_hoanthanh}
    Press Key      //body     ${F9_KEY}
    #Toast flex message validation    Cập nhật phiếu chuyển hàng thành công
    Sleep    2s
    Wait Until Keyword Succeeds    3 times    20s    Switch Branch    ${get_current_branch_name}    ${input_branchname}
    ${reverse_list_num_changes}    Reverse List one    ${list_nums_change}
    Wait Until Keyword Succeeds    3 times    20s    Accept transferring proccess with A part and adding note    ${ma_phieuchuyen}    ${reverse_list_num_changes}    ${input_note}
    #Toast flex message validation    Cập nhật phiếu chuyển hàng thành công
    ## validate onstock card
    ${list_result_num_in_instock_source_branch}    Change negative number to positive number and vice versa in List    ${list_nums_change}
    ## assert stock card in source branch
    : FOR    ${item_pr}    ${item_num_íntockcard}    ${item_list_result_transferring_onhand_bf_trans}    ${item_list_result_source_onhand_lot_af_trans}    ${item_tenlo}    IN ZIP
    ...    ${list_prs}    ${list_result_num_in_instock_source_branch}    ${list_result_source_onhand_af_trans}    ${list_result_source_onhand_lot_af_trans}    ${list_tenlo_all}
    \    Assert values in Stock Card    ${ma_phieuchuyen}    ${item_pr}    ${item_list_result_transferring_onhand_bf_trans}    ${item_num_íntockcard}
    \    Assert values in Stock Card in tab Lo - HSD    ${ma_phieuchuyen}    ${item_pr}    ${item_pr}    ${item_list_result_source_onhand_lot_af_trans}    ${item_num_íntockcard}
    \    ...    ${item_tenlo}
    ## assert stock card in target branch
    : FOR    ${item_pr}    ${item_num_íntockcard}    ${item_list_result_received_onhand_bf_trans}    ${item_list_result_target_onhand_lot_af_trans}    ${item_tenlo}    IN ZIP
    ...    ${list_prs}    ${list_nums_change}    ${list_result_target_onhand_af_trans}    ${list_result_target_onhand_lot_af_trans}    ${list_tenlo_all}
    \    Assert values in Stock Card by Branch    ${ma_phieuchuyen}    ${item_pr}    ${item_list_result_received_onhand_bf_trans}    ${item_num_íntockcard}    ${input_branchname}
    \    Assert values in Stock Card in tab Lo - HSD by Branch Name    ${input_branchname}    ${ma_phieuchuyen}    ${item_pr}    ${item_pr}    ${item_list_result_target_onhand_lot_af_trans}
    \    ...    ${item_num_íntockcard}    ${item_tenlo}
    Wait Until Keyword Succeeds    3x    20 s    Switch Branch    ${input_branchname}    ${get_current_branch_name}
    Delete Transform code    ${ma_phieuchuyen}

etechl_notfinish
    [Arguments]    ${dict}    ${list_nums_trans}    ${input_branchname}
    ${list_prs}    Get Dictionary Keys    ${dict}
    ${list_num}    Get Dictionary Values    ${dict}
    ${list_tenlo_all}    Import lot name for products by generating randomly    ${list_prs}    ${list_num}
    Log Many    ${list_tenlo_all}
    Before Test Inventory Transfer
    ${ma_phieuchuyen}    Generate code automatically    PCH
    ${get_current_branch_name}    Get current branch name
    Wait Until Keyword Succeeds    3 times    10 s    Go To Inventory Transfer form
    Select Branch on Inventory Transfer form    ${input_branchname}
    ${list_result_source_onhand_af_trans}    Create List
    ${list_result_target_onhand_af_trans}    Create List
    ${list_result_source_onhand_lot_af_trans}    Create List
    ${list_result_target_onhand_lot_af_trans}    Create List
    ${lastest_num}    Set Variable    0
    : FOR    ${item_product}    ${item_lotname}    ${item_num}    IN ZIP    ${list_prs}    ${list_tenlo_all}
    ...    ${list_nums_trans}
    \    ${list_result_source_onhand_af_trans}    ${list_result_target_onhand_af_trans}    ${list_result_source_onhand_lot_af_trans}    ${list_result_target_onhand_lot_af_trans}    ${lastest_number}    Input products - lot name - nums to Inventory transfer form in case not finish
    \    ...    ${list_result_source_onhand_af_trans}    ${list_result_target_onhand_af_trans}    ${list_result_source_onhand_lot_af_trans}    ${list_result_target_onhand_lot_af_trans}    ${input_branchname}
    \    ...    ${item_product}    ${item_lotname}    ${item_num}    ${lastest_num}
    Input inventory transfer code    ${ma_phieuchuyen}
    #Click Element    ${button_ch_hoanthanh}
    Press Key      //body     ${F9_KEY}
    #Toast flex message validation    Cập nhật phiếu chuyển hàng thành công
    Sleep    2s
    Wait Until Keyword Succeeds    3 times    20s    Switch Branch    ${get_current_branch_name}    ${input_branchname}
    Assert values Transfer form in Target branch    ${ma_phieuchuyen}    Đang chuyển    ${get_current_branch_name}    ${input_branchname}
    ## validate onstock card
    ${list_result_num_in_instock_source_branch}    Change negative number to positive number and vice versa in List    ${list_nums_trans}
    ## assert stock card in source branch
    : FOR    ${item_pr}    ${item_num_íntockcard}    ${item_list_result_transferring_onhand_bf_trans}    ${item_list_result_source_onhand_lot_af_trans}    ${item_tenlo}    IN ZIP
    ...    ${list_prs}    ${list_result_num_in_instock_source_branch}    ${list_result_source_onhand_af_trans}    ${list_result_source_onhand_lot_af_trans}    ${list_tenlo_all}
    \    Assert values in Stock Card    ${ma_phieuchuyen}    ${item_pr}    ${item_list_result_transferring_onhand_bf_trans}    ${item_num_íntockcard}
    \    ${onhand_af_ex}    ${cost_af_ex}    Get Cost and OnHand frm API    ${item_pr}
    \    Should Be Equal As Numbers    ${onhand_af_ex}    ${item_list_result_transferring_onhand_bf_trans}
    \    Assert values in Stock Card in tab Lo - HSD    ${ma_phieuchuyen}    ${item_pr}    ${item_pr}    ${item_list_result_source_onhand_lot_af_trans}    ${item_num_íntockcard}
    \    ...    ${item_tenlo}
    ## assert stock card in target branch
    : FOR    ${item_pr}    ${item_list_result_received_onhand_bf_trans}    ${item_list_result_target_onhand_lot_af_trans}    ${item_tenlo}    IN ZIP    ${list_prs}
    ...    ${list_result_target_onhand_af_trans}    ${list_result_target_onhand_lot_af_trans}    ${list_tenlo_all}
    \    Assert values not avaiable in Stock Card by Branch Name    ${input_branchname}    ${ma_phieuchuyen}    ${item_pr}
    \    Assert values in Stock Card in tab Lo - HSD by Branch Name    ${input_branchname}    ${ma_phieuchuyen}    ${item_pr}    ${item_pr}    ${item_list_result_target_onhand_lot_af_trans}
    \    ...    0    ${item_tenlo}
    \    ${onhand_target_af_ex}    ${cost_target_af_ex}    Get Cost and Onhand frm API by Branch    ${item_pr}    ${input_branchname}
    \    Should Be Equal As Numbers    ${onhand_target_af_ex}    ${item_list_result_received_onhand_bf_trans}
    Wait Until Keyword Succeeds    3x    20 s    Switch Branch and Go to Inventory form    ${input_branchname}    ${get_current_branch_name}
    Delete Transform code    ${ma_phieuchuyen}

etechl_cancel
    [Arguments]    ${dict}    ${list_nums_trans}    ${input_branchname}
    ${list_prs}    Get Dictionary Keys    ${dict}
    ${list_num}    Get Dictionary Values    ${dict}
    ${list_tenlo_all}    Import lot name for products by generating randomly    ${list_prs}    ${list_num}
    Log Many    ${list_tenlo_all}
    Before Test Inventory Transfer
    ${ma_phieuchuyen}    Generate code automatically    PCH
    ${get_current_branch_name}    Get current branch name
    Wait Until Keyword Succeeds    3 times    10 s    Go To Inventory Transfer form
    Select Branch on Inventory Transfer form    ${input_branchname}
    ${list_result_source_onhand_af_trans}    Create List
    ${list_result_target_onhand_af_trans}    Create List
    ${list_result_source_onhand_lot_af_trans}    Create List
    ${list_result_target_onhand_lot_af_trans}    Create List
    ${lastest_num}    Set Variable    0
    : FOR    ${item_product}    ${item_lotname}    ${item_num}    IN ZIP    ${list_prs}    ${list_tenlo_all}
    ...    ${list_nums_trans}
    \    ${list_result_source_onhand_af_trans}    ${list_result_target_onhand_af_trans}    ${list_result_source_onhand_lot_af_trans}    ${list_result_target_onhand_lot_af_trans}    ${lastest_num}    Input products - lot name - nums to Inventory transfer form in case cancel
    \    ...    ${list_result_source_onhand_af_trans}    ${list_result_target_onhand_af_trans}    ${list_result_source_onhand_lot_af_trans}    ${list_result_target_onhand_lot_af_trans}    ${input_branchname}
    \    ...    ${item_product}    ${item_lotname}    ${item_num}    ${lastest_num}
    Input inventory transfer code    ${ma_phieuchuyen}
    #Click Element    ${button_ch_hoanthanh}
    Press Key      //body     ${F9_KEY}
    #Toast flex message validation    Cập nhật phiếu chuyển hàng thành công
    Sleep    2s
    Wait Until Keyword Succeeds    3 times    20s    Switch Branch    ${get_current_branch_name}    ${input_branchname}
    Assert values Transfer form in Target branch    ${ma_phieuchuyen}    Đang chuyển    ${get_current_branch_name}    ${input_branchname}
    ## click cancel
    Cancel transferring proccess    ${ma_phieuchuyen}
    ## validate onstock card
    ${list_result_num_in_instock_source_branch}    Change negative number to positive number and vice versa in List    ${list_nums_trans}
    ## assert stock card in source branch
    : FOR    ${item_pr}    ${item_num_íntockcard}    ${item_list_result_transferring_onhand_bf_trans}    ${item_list_result_source_onhand_lot_af_trans}    ${item_tenlo}    IN ZIP
    ...    ${list_prs}    ${list_result_num_in_instock_source_branch}    ${list_result_source_onhand_af_trans}    ${list_result_source_onhand_lot_af_trans}    ${list_tenlo_all}
    \    Assert values not avaiable in Stock Card    ${ma_phieuchuyen}    ${item_pr}
    \    ${onhand_af_ex}    ${cost_af_ex}    Get Cost and OnHand frm API    ${item_pr}
    \    Should Be Equal As Numbers    ${onhand_af_ex}    ${item_list_result_transferring_onhand_bf_trans}
    \    ${source_onhand_lot}    Get Onhand Lot in tab Lo - HSD frm API    ${item_pr}    ${item_tenlo}
    \    Should Be Equal As Numbers    ${source_onhand_lot}    ${item_list_result_source_onhand_lot_af_trans}
    ## assert stock card in target branch
    : FOR    ${item_pr}    ${item_num_íntockcard}    ${item_list_result_received_onhand_bf_trans}    ${item_list_result_target_onhand_lot_af_trans}    ${item_tenlo}    IN ZIP
    ...    ${list_prs}    ${list_nums_trans}    ${list_result_target_onhand_af_trans}    ${list_result_target_onhand_lot_af_trans}    ${list_tenlo_all}
    \    ${onhand_target_af_ex}    ${cost_target_af_ex}    Get Cost and Onhand frm API by Branch    ${item_pr}    ${input_branchname}
    \    Assert values not avaiable in Stock Card by Branch Name    ${input_branchname}    ${ma_phieuchuyen}    ${item_pr}
    \    Should Be Equal As Numbers    ${onhand_target_af_ex}    ${item_list_result_received_onhand_bf_trans}
    \    ${target_onhand_lot}    Get lot onhand frm API by Branch Name    ${input_branchname}    ${item_pr}    ${item_tenlo}
    \    Should Be Equal As Numbers    ${target_onhand_lot}    ${item_list_result_target_onhand_lot_af_trans}
    Wait Until Keyword Succeeds    3x    20 s    Switch Branch    ${input_branchname}    ${get_current_branch_name}
