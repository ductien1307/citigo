*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}      ${headless_browser}
Test Setup        Before Test Inventory Transfer
Test Teardown     After Test
Resource          ../../../core/Giao_dich/chuyenhang_form_page.robot
Resource          ../../../core/Giao_dich/chuyenhang_page_action.robot
Resource          ../../../config/env_product/envi.robot
Resource          ../../../core/share/toast_message.robot
Resource          ../../../core/Giao_dich/giaodich_nav.robot
Resource          ../../../core/Thiet_lap/branch_list_action.robot
Library           Collections
Resource          ../../../core/share/list_dictionary.robot
Resource          ../../../core/API/api_chuyenhang.robot
Resource          ../../../core/API/api_danhmuc_hanghoa.robot

*** Variables ***
&{ch_dict1}       HHCH01=50    DVTCH01=55.5    IM24=2
&{ch_dict1_change_receive}    HHCH01=20    DVTCH01=40    IM24=2

*** Test Cases ***    Dict SP&SL     Ma CH              CN Nhan                       Thay doi SL nhan    Ghi chú
Received as default
                      [Tags]         NCCH
                      [Template]     default
                      ${ch_dict1}    Nhánh A

Received as undefault           [Tags]         NCCH
                      [Template]     undefault
                      ${ch_dict1}    Nhánh A            ${ch_dict1_change_receive}    Thay đổi số lượng chuyển hàng
                      ${ch_dict1}    Nhánh A            ${ch_dict1}    Số lượng nhận hàng bằng 0

*** Keyword ***
default
    [Arguments]    ${list_dict}    ${input_branchname}
    [Documentation]    Chuyển hàng với hàng hóa khi CN nhận, nhận hết hàng, mặc định nhận đủ
    ...    - Validate UI tồn kho của CN nhận và CN chuyển
    ...    - Validate thẻ kho của CN nhận và CN chuyển
    [Timeout]    10 minutes
    Set Selenium Speed    1s
    ${get_current_branch_name}    Get current branch name
    ${list_prs}   ${list_nums}    Get list from dictionary    ${list_dict}
    ${ma_phieuchuyen}    ${list_result_transferring_onhand}    ${list_result_received_onhand}   Add new transform frm API    ${get_current_branch_name}    ${input_branchname}    ${list_dict}
    Wait Until Keyword Succeeds    3x    0.5 s    Switch Branch    ${get_current_branch_name}    ${input_branchname}
    Accept transferring proccess    ${ma_phieuchuyen}
    ## validate onstock card
    ${list_result_num_in_instock_trans_branch}    Change negative number to positive number and vice versa in List    ${list_nums}
    : FOR    ${item_pr}    ${item_num_instockcard}    ${item_list_result_transferring_onhand_bf_trans}    IN ZIP    ${list_prs}    ${list_result_num_in_instock_trans_branch}
    ...    ${list_result_transferring_onhand}
    \    Assert values in Stock Card    ${ma_phieuchuyen}    ${item_pr}    ${item_list_result_transferring_onhand_bf_trans}    ${item_num_instockcard}
    : FOR    ${list_pr}    ${list_num}    ${item_list_result_received_onhand_bf_trans}    IN ZIP    ${list_prs}    ${list_nums}
    ...    ${list_result_received_onhand}
    \    Assert values in Stock Card by Branch    ${ma_phieuchuyen}    ${list_pr}    ${item_list_result_received_onhand_bf_trans}    ${list_num}    ${input_branchname}
    Wait Until Keyword Succeeds    3x    0.5 s    Switch Branch    ${input_branchname}    ${get_current_branch_name}
    Delete Transform code    ${ma_phieuchuyen}

undefault
    [Arguments]    ${list_dict}    ${input_branchname}    ${list_changed_num}    ${input_note}
    [Documentation]    Chuyển hàng với hàng hóa khi CN nhận, nhận hàng 1 phần
    ...
    ...    - Validate UI tồn kho của CN nhận và CN chuyển
    ...    - Validate thẻ kho của CN nhận và CN chuyển
    [Timeout]    10 minutes
    ${get_current_branch_name}    Get current branch name
    ${list_prs}   ${list_nums}    Get list from dictionary    ${list_dict}
    ${ma_phieuchuyen}    ${list_result_transferring_onhand_bf_change}    ${list_result_received_onhand_bf_change}   Add new transform frm API    ${get_current_branch_name}    ${input_branchname}    ${list_dict}
    ${list_num_changes}    Get Dictionary Values    ${list_changed_num}
    ${nums_imei}   Get From Dictionary    ${list_dict}    IM24
    ${list_result_transferring_onhand}    Create List
    ${list_result_received_onhand}    Create List
    :FOR    ${item_nums_change}   ${item_nums}    ${transferring_onhand_bf_trans}    ${received_onhand_bf_trans}    IN ZIP     ${list_num_changes}    ${list_nums}
    ...    ${list_result_transferring_onhand_bf_change}    ${list_result_received_onhand_bf_change}
    \    ${result_soluong_giam}   Minus   ${item_nums}    ${item_nums_change}
    \    ${result_soluong_tang}   Minus   ${item_nums_change}    ${item_nums}
    \    ${item_soluong}    Set Variable If    ${item_nums}>${item_nums_change}    ${result_soluong_giam}    ${result_soluong_tang}
    \    ${item_quantity}    Set Variable If    '${item_nums}' == '${item_nums_change}'    0    ${item_soluong}
    \    ${transferring_onhand_trans}   Run Keyword If    ${item_nums}>${item_nums_change}    Sum    ${transferring_onhand_bf_trans}   ${item_soluong}
    \    ...    ELSE    Minus    ${transferring_onhand_bf_trans}   ${item_soluong}
    \    ${received_onhand_trans}   Run Keyword If    ${item_nums}>${item_nums_change}    Minus    ${received_onhand_bf_trans}    ${item_soluong}
    \    ...    ELSE    Sum    ${received_onhand_bf_trans}    ${item_soluong}
    \    Append To List    ${list_result_transferring_onhand}    ${transferring_onhand_trans}
    \    Append To List    ${list_result_received_onhand}    ${received_onhand_trans}
    #Toast flex message validation    Cập nhật phiếu chuyển hàng thành công
    Wait Until Keyword Succeeds    3x    0.5 s    Switch Branch    ${get_current_branch_name}    ${input_branchname}
    Wait Until Keyword Succeeds    3 times    1 s    Click record contains Transfer code    ${ma_phieuchuyen}
    Wait Until Keyword Succeeds    3 times    1 s    Open Transfer Form in Target Branch    ${ma_phieuchuyen}
    Wait Until Keyword Succeeds    3 times    1 s    Turn off received default frm transfer
    ${index_row}    Set Variable    0
    ${index_in_list_change}    Set Variable    -1
    : FOR    ${item_in_list_num_changed}    ${item_nums}    IN ZIP     ${list_num_changes}    ${list_nums}
    \    ${index_row}    Evaluate    ${index_row} + 1
    \    ${index_in_list_change}    Evaluate    ${index_in_list_change} + 1
    \    ${cell_trans_code_in_received_trans_form}    Format String    ${cell_trans_code_in_received_trans_form}    ${index_row}
    \    Wait Until Page Contains Element    ${cell_trans_code_in_received_trans_form}
    \    ${item_in_list_num_changed}    Get From List    ${list_num_changes}    ${index_in_list_change}
    \    Run Keyword If    '${item_in_list_num_changed}' == '${item_nums}'    Log    Ignore change   ELSE      Change receiving num in Transfer form    ${index_row}    ${item_in_list_num_changed}
    Wait Until Keyword Succeeds    3 times    1 s    Turn on received default frm transfer
    Input data    ${textbox_note_in_received_screen}    ${input_note}
    Wait Until Element Is Enabled    ${button_complete}    1 min
    Click Element    ${button_complete}
    ## validate onstock card
    ${list_result_num_in_instock_trans_branch}    Change negative number to positive number and vice versa in List    ${list_num_changes}
    ##
    : FOR    ${item_pr}    ${item_num_instockcard}    ${item_list_result_transferring_onhand_bf_trans}    IN ZIP    ${list_prs}    ${list_result_num_in_instock_trans_branch}
    ...    ${list_result_transferring_onhand}
    \    Assert values in Stock Card    ${ma_phieuchuyen}    ${item_pr}    ${item_list_result_transferring_onhand_bf_trans}    ${item_num_instockcard}
    : FOR    ${list_pr}    ${list_num}    ${item_list_result_received_onhand_bf_trans}    IN ZIP    ${list_prs}    ${list_num_changes}
    ...    ${list_result_received_onhand}
    \    Assert values in Stock Card by Branch    ${ma_phieuchuyen}    ${list_pr}    ${item_list_result_received_onhand_bf_trans}    ${list_num}    ${input_branchname}
    Wait Until Keyword Succeeds    3x    2 s    Switch Branch and Go to Inventory form    ${input_branchname}    ${get_current_branch_name}
    Delete Transform code    ${ma_phieuchuyen}
