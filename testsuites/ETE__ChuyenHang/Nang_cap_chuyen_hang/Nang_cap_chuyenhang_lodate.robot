*** Settings ***
Suite Setup       Init Test Environment    LD    http://localhost:9999/wd/hub     ${account}    ${headless_browser}
Suite Teardown    After Test
Test Teardown
Resource          ../../../core/Giao_dich/chuyenhang_form_page.robot
Resource          ../../../core/Giao_dich/chuyenhang_page_action.robot
Resource          ../../../config/env_product/envi.robot
Resource          ../../../core/share/toast_message.robot
Resource          ../../../core/Giao_dich/giaodich_nav.robot
Resource          ../../../core/share/list_dictionary.robot
Resource          ../../../core/Thiet_lap/branch_list_action.robot
Library           Collections
Resource          ../../../core/share/list_dictionary.robot
Resource          ../../../core/API/api_chuyenhang.robot

*** Variables ***
&{dict_prs}       LD10=5
@{list_num}       2
@{list_num_change}       1

*** Test Cases ***
Received as default
        [Tags]           NCCHL
        [Template]    default
        ${dict_prs}    ${list_num}    Nhánh A

Match tab
        [Tags]           NCCHL
        [Template]    match
        ${dict_prs}    ${list_num}    Nhánh A     Số lượng nhận bằng số lượng chuyển

Not active tab
        [Tags]           NCCHL
        [Template]    notactive
        ${dict_prs}    ${list_num}    Nhánh A     Số lượng nhận bằng 0

Not match
        [Tags]           NCCHL
        [Template]    notmatch
        ${dict_prs}    ${list_num}    ${list_num_change}    Nhánh A   số lượng nhận nhỏ hơn số lượng chuyển

*** Keywords ***
default
    [Arguments]    ${dict}    ${list_nums_trans}    ${input_branchname}
    Set Selenium Speed    1s
    ${get_current_branch_name}    Get current branch name
    ${ma_phieuchuyen}    ${list_tenlo_all}    ${list_result_source_onhand_af_trans}    ${list_result_target_onhand_af_trans}    ${list_result_source_onhand_lot_af_trans}    ${list_result_target_onhand_lot_af_trans}    Add new transform frm lodate API    ${get_current_branch_name}
    ...    ${input_branchname}    ${dict}    ${list_nums_trans}
    ${list_prs}    Get Dictionary Keys    ${dict}
    ${list_num}    Get Dictionary Values    ${dict}
    #Toast flex message validation    Cập nhật phiếu chuyển hàng thành công
    Sleep    2s
    Before Test Inventory Transfer
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

match
    [Arguments]    ${dict}    ${list_nums_trans}    ${input_branchname}    ${input_note}
    Set Selenium Speed    1s
    ${get_current_branch_name}    Get current branch name
    ${ma_phieuchuyen}    ${list_tenlo_all}    ${list_result_source_onhand_af_trans}    ${list_result_target_onhand_af_trans}    ${list_result_source_onhand_lot_af_trans}    ${list_result_target_onhand_lot_af_trans}    Add new transform frm lodate API    ${get_current_branch_name}
    ...    ${input_branchname}    ${dict}    ${list_nums_trans}
    ${list_prs}    Get Dictionary Keys    ${dict}
    ${list_num}    Get Dictionary Values    ${dict}
    #Toast flex message validation    Cập nhật phiếu chuyển hàng thành công
    Sleep    2s
    Before Test Inventory Transfer
    Wait Until Keyword Succeeds    3 times    20s    Switch Branch    ${get_current_branch_name}    ${input_branchname}
    Wait Until Keyword Succeeds    3 times    10 s    Click record contains Transfer code    ${ma_phieuchuyen}
    Wait Until Keyword Succeeds    3 times    10 s    Open Transfer Form in Target Branch    ${ma_phieuchuyen}
    ###
    ${get_text_lodate_in}     Get Text      ${cell_text_lodate_firstrow}
    Wait Until Page Contains Element    ${tab_khop_in_transfer}    1 min
    Click Element JS    ${tab_khop_in_transfer}
    ${get_text_lodate_in_tab_khop}     Get Text      ${cell_text_lodate_firstrow}
    Should Be Equal As Strings    ${get_text_lodate_in}    ${get_text_lodate_in_tab_khop}
    Input data    ${textbox_note_in_received_screen}    ${input_note}
    Wait Until Element Is Enabled    ${button_complete}    1 min
    Click Element    ${button_complete}
    Sleep    1s
    Toast flex message validation    Cập nhật phiếu chuyển hàng thành công
    Delete Transform code    ${ma_phieuchuyen}

notactive
    [Arguments]    ${dict}    ${list_nums_trans}    ${input_branchname}    ${input_note}
    Set Selenium Speed    1s
    ${get_current_branch_name}    Get current branch name
    ${ma_phieuchuyen}    ${list_tenlo_all}    ${list_result_source_onhand_af_trans}    ${list_result_target_onhand_af_trans}    ${list_result_source_onhand_lot_af_trans}    ${list_result_target_onhand_lot_af_trans}    Add new transform frm lodate API    ${get_current_branch_name}
    ...    ${input_branchname}    ${dict}    ${list_nums_trans}
    ${list_prs}    Get Dictionary Keys    ${dict}
    ${list_num}    Get Dictionary Values    ${dict}
    #Toast flex message validation    Cập nhật phiếu chuyển hàng thành công
    Sleep    2s
    Before Test Inventory Transfer
    Wait Until Keyword Succeeds    3 times    20s    Switch Branch    ${get_current_branch_name}    ${input_branchname}
    Wait Until Keyword Succeeds    3 times    10 s    Click record contains Transfer code    ${ma_phieuchuyen}
    Wait Until Keyword Succeeds    3 times    10 s    Open Transfer Form in Target Branch    ${ma_phieuchuyen}
    Wait Until Keyword Succeeds    3 times    10 s    Turn off received default frm transfer
    ${get_text_lodate_in}     Get Text      ${cell_text_lodate_firstrow}
    Wait Until Page Contains Element    ${tab_chuanhan_in_transfer}    1 min
    Click Element JS    ${tab_chuanhan_in_transfer}
    ${get_text_lodate_in_tab_chuanhan}     Get Text      ${cell_text_lodate_firstrow}
    Should Be Equal As Strings    ${get_text_lodate_in}    ${get_text_lodate_in_tab_chuanhan}
    Input data    ${textbox_note_in_received_screen}    ${input_note}
    Wait Until Element Is Enabled    ${button_complete}    1 min
    Click Element    ${button_complete}
    Sleep    1s
    Toast flex message validation    Cập nhật phiếu chuyển hàng thành công
    Delete Transform code    ${ma_phieuchuyen}

notmatch
    [Arguments]    ${dict}    ${list_nums_trans}   ${list_nums_change}    ${input_branchname}    ${input_note}
    Set Selenium Speed    1s
    ${get_current_branch_name}    Get current branch name
    ${ma_phieuchuyen}    ${list_tenlo_all}    ${list_result_source_onhand_af_trans}    ${list_result_target_onhand_af_trans}    ${list_result_source_onhand_lot_af_trans}    ${list_result_target_onhand_lot_af_trans}    Add new transform frm lodate API    ${get_current_branch_name}
    ...    ${input_branchname}    ${dict}    ${list_nums_trans}
    ${list_prs}    Get Dictionary Keys    ${dict}
    ${list_num}    Get Dictionary Values    ${dict}
    #Toast flex message validation    Cập nhật phiếu chuyển hàng thành công
    Sleep    2s
    Before Test Inventory Transfer
    Wait Until Keyword Succeeds    3 times    20s    Switch Branch    ${get_current_branch_name}    ${input_branchname}
    Wait Until Keyword Succeeds    3 times    10 s    Click record contains Transfer code    ${ma_phieuchuyen}
    Wait Until Keyword Succeeds    3 times    10 s    Open Transfer Form in Target Branch    ${ma_phieuchuyen}
    Wait Until Keyword Succeeds    3 times    10 s    Turn off received default frm transfer
    ${reverse_list_num_changes}    Reverse List one    ${list_nums_change}
    ${index_row}    Set Variable    0
    ${index_in_list_change}    Set Variable    -1
    : FOR    ${item_in_list_num_changed}    IN    @{reverse_list_num_changes}
    \    ${index_row}    Evaluate    ${index_row} + 1
    \    ${index_in_list_change}    Evaluate    ${index_in_list_change} + 1
    \    ${cell_trans_code_in_received_trans_form}    Format String    ${cell_trans_code_in_received_trans_form}    ${index_row}
    \    Wait Until Page Contains Element    ${cell_trans_code_in_received_trans_form}
    \    ${item_in_list_num_changed}    Get From List    ${list_num_change}    ${index_in_list_change}
    \    Change receiving num in Transfer form    ${index_row}    ${item_in_list_num_changed}
    ###
    ${get_text_lodate_in}     Get Text      ${cell_text_lodate_firstrow}
    Wait Until Page Contains Element    ${tab_lech_in_transfer}    1 min
    Click Element JS    ${tab_lech_in_transfer}
    ${get_text_lodate_in_tab_chuanhan}     Get Text      ${cell_text_lodate_firstrow}
    Should Be Equal As Strings    ${get_text_lodate_in}    ${get_text_lodate_in_tab_chuanhan}
    Input data    ${textbox_note_in_received_screen}    ${input_note}
    Wait Until Element Is Enabled    ${button_complete}    1 min
    Click Element    ${button_complete}
    Sleep    1s
    Toast flex message validation    Cập nhật phiếu chuyển hàng thành công
    Delete Transform code    ${ma_phieuchuyen}
