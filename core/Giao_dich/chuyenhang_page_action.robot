*** Settings ***
Library           SeleniumLibrary
Resource          chuyenhang_form_page.robot
Resource          ../share/discount.robot
Resource          chuyenhang_page_list.robot
Resource          ../API/api_danhmuc_hanghoa.robot
Resource          ../share/popup.robot
Resource          ../share/imei.robot
Resource          ../share/list_dictionary.robot
Resource          ../share/lodate.robot

*** Keywords ***
Select Branch on Inventory Transfer form
    [Arguments]    ${input_branch}
    Wait Until Keyword Succeeds    3 times    1s    Input item in dropdownlist    ${cell_chon_chi_nhanh}    ${input_branch}    ${item_indropdown_chinhanh}

Input list products and nums to Inventory transfer form
    [Arguments]    ${input_product_code}    ${input_trans_num}    ${input_branch_name}    ${list_result_source_onhand_bf_trans}    ${list_result_target_onhand_bf_trans}    ${list_imei_status}   ${list_imei_all}
    ${lastest_num}    Set Variable    0
    :FOR    ${item_product}   ${item_num}   ${item_source_onhand_bf_trans}      ${item_target_onhand_bf_trans}    ${item_imei_status}    ${item_imei}        IN ZIP    ${input_product_code}    ${input_trans_num}   ${list_result_source_onhand_bf_trans}    ${list_result_target_onhand_bf_trans}    ${list_imei_status}   ${list_imei_all}
    \     ${lastest_num}    Run Keyword If    '${item_imei_status}'!='True'   Input products and nums to Inventory transfer form    ${item_product}   ${item_num}    ${input_branch_name}    ${item_source_onhand_bf_trans}      ${item_target_onhand_bf_trans}    ${lastest_num}    ELSE    Input products and IMEI to Inventory transfer form    ${item_source_onhand_bf_trans}      ${item_target_onhand_bf_trans}   ${input_branch_name}    ${item_product}       ${item_imei}      ${item_num}    ${lastest_num}
    Return From Keyword    ${lastest_num}

Input products and nums to Inventory transfer form
    [Arguments]    ${input_product_code}    ${input_trans_num}    ${input_branch_name}    ${source_onhand_bf_trans}    ${target_onhand_bf_trans}    ${lastest_num}
    Wait Until Keyword Succeeds    3 times    8 s    Input data in textbox and wait until it is visible    ${textbox_chuyenhang_search_product}    ${input_product_code}    ${item_ch_first_product_dropdownlist_search}
    ...    ${cell_first_product_code}
    Wait Until Page Contains Element    ${textbox_ch_nums}    2 min
    ${result_lastest_number}    Input number and validate data    ${textbox_ch_nums}    ${input_trans_num}    ${lastest_num}    ${cell_lastest_num}
    ${get_transferring_onhand}    ${get_received_onhand}    Get transferring Onhand and received Onhand on UI
    ### Assert values UI Onhand on both Branchs
    Should Be Equal As Numbers    ${get_transferring_onhand}    ${source_onhand_bf_trans}
    Should Be Equal As Numbers    ${get_received_onhand}    ${target_onhand_bf_trans}
    Return From Keyword      ${result_lastest_number}

Input quantity to Inventory transfer form
        [Arguments]    ${product_code}    ${trans_quan}    ${source_onhand_bf_trans}    ${target_onhand_bf_trans}    ${lastest_num}
        Wait Until Page Contains Element    ${textbox_chuyenhang_search_product}    2 min
        ${textbox_quantity_by_product_code}        Format String       ${textbox_quantity_by_product_code}       ${product_code}
        Wait Until Page Contains Element    ${textbox_ch_nums}    2 min
        ${ignore_lastest_num}    Input number and validate data    ${textbox_quantity_by_product_code}    ${trans_quan}    ${lastest_num}    ${cell_lastest_num}
        Focus    ${textbox_ma_phieu_chuyen}
        ${tem_lastest_num}      Minus      ${lastest_num}        1
        ${result_lastest_number}    Sum       ${tem_lastest_num}      ${trans_quan}
        ${get_transferring_onhand}    ${get_received_onhand}    Get source - received Onhands by Product Code on UI       ${product_code}
        ### Assert values UI Onhand on both Branchs
        Should Be Equal As Numbers    ${get_transferring_onhand}    ${source_onhand_bf_trans}
        Should Be Equal As Numbers    ${get_received_onhand}    ${target_onhand_bf_trans}
        ## Compute and append to list
        Return From Keyword    ${result_lastest_number}

Get lists of recent source - target onhands and result source - result target onhands after transfer
    [Arguments]    ${list_product_codes}    ${list_trans_quans}    ${branch_name}
    ${list_result_source_onhand_af_trans}       Create List
    ${list_result_target_onhand_af_trans}      Create List
    ${list_source_onhand_bf_trans}    ${list_source_baseprice_bf_trans}        Get list of Onhand and Baseprice frm API    ${list_product_codes}
    ${list_target_onhand_bf_trans}    ${list_target_baseprice_bf_trans}        Get list of Onhand and Baseprice frm API by Branch Name    ${list_product_codes}       ${branch_name}
    : FOR    ${item_product}    ${item_trans_quan}      ${item_source_onhand_bf_trans}     ${item_target_onhand_bf_trans}     IN ZIP    ${list_product_codes}      ${list_trans_quans}    ${list_source_onhand_bf_trans}       ${list_target_onhand_bf_trans}
    \      ${source_onhand_af_trans}    Minus    ${item_source_onhand_bf_trans}    ${item_trans_quan}
    \      ${target_onhand_af_trans}    Sum    ${item_target_onhand_bf_trans}    ${item_trans_quan}
    \      Append To List    ${list_result_source_onhand_af_trans}    ${source_onhand_af_trans}
    \      Append To List    ${list_result_target_onhand_af_trans}    ${target_onhand_af_trans}
    Return From Keyword      ${list_source_onhand_bf_trans}       ${list_target_onhand_bf_trans}     ${list_result_source_onhand_af_trans}    ${list_result_target_onhand_af_trans}

Go to Inventory Transfer form
    Wait Until Page Contains Element    ${button_chuyenhang}    2 mins
    Click Element    ${button_chuyenhang}
    Wait Until Page Contains Element    ${textbox_chuyenhang_search_product}    1 mins
    #Click Element    //span[@class='k-icon k-i-arrow-n']
    #sleep    1 s
    #Click Element    //a[@class='k-link']//span[@class='k-icon k-i-arrow-s']

Input inventory transfer code
    [Arguments]    ${input_ma_phieuchuyen}
    Wait Until Keyword Succeeds    3 times    0.5 s    Input data    ${textbox_ma_phieu_chuyen}    ${input_ma_phieuchuyen}

Get transferring Onhand and received Onhand on UI
    ${get_transferring_onhand}    Get Text    ${cell_transferring_onhand}
    ${get_received_onhand}    Get text    ${cell_received_onhand}
    ${get_transferring_onhand}    Run Keyword If    '${get_transferring_onhand}' != '${EMPTY}'    Replace string    ${get_transferring_onhand}    ,    ${EMPTY}       ELSE       Set Variable    0
    ${get_received_onhand}    Run Keyword If    '${get_received_onhand}' != '${EMPTY}'       Replace string    ${get_received_onhand}    ,    ${EMPTY}      ELSE       Set Variable    0
    ${get_transferring_onhand}    Convert To Number    ${get_transferring_onhand}
    ${get_received_onhand}    Convert To Number    ${get_received_onhand}
    Return From Keyword    ${get_transferring_onhand}    ${get_received_onhand}

Get source - received Onhands by Product Code on UI
    [Arguments]        ${product_code}
    ${cell_source_onhand_by_product_code}      Format String       ${cell_source_onhand_by_product_code}      ${product_code}
    ${cell_target_onhand_by_product_code}      Format String       ${cell_target_onhand_by_product_code}      ${product_code}
    ${get_transferring_onhand}    Get Text    ${cell_source_onhand_by_product_code}
    ${get_received_onhand}    Get text    ${cell_target_onhand_by_product_code}
    ${get_transferring_onhand}    Run Keyword If    '${get_transferring_onhand}' != '${EMPTY}'    Replace string    ${get_transferring_onhand}    ,    ${EMPTY}       ELSE       Set Variable    0
    ${get_received_onhand}    Run Keyword If    '${get_received_onhand}' != '${EMPTY}'       Replace string    ${get_received_onhand}    ,    ${EMPTY}      ELSE       Set Variable    0
    ${get_transferring_onhand}    Convert To Number    ${get_transferring_onhand}
    ${get_received_onhand}    Convert To Number    ${get_received_onhand}
    Return From Keyword    ${get_transferring_onhand}    ${get_received_onhand}

Accept transferring proccess
    [Arguments]    ${input_trans_code}
    Wait Until Keyword Succeeds    3 times    1 s    Click record contains Transfer code    ${input_trans_code}
    Wait Until Keyword Succeeds    3 times    1 s    Open Transfer Form in Target Branch    ${input_trans_code}
    Wait Until Page Contains Element    ${button_complete}    2 min
    Click Element JS    ${button_complete}

Accept transferring proccess with A part and adding note
    [Arguments]    ${input_trans_code}    ${list_product}    ${list_num_change}    ${list_del_imei}    ${get_list_imei_status}  ${text_note}
    Wait Until Keyword Succeeds    3 times    1 s    Click record contains Transfer code    ${input_trans_code}
    Wait Until Keyword Succeeds    3 times    1 s    Open Transfer Form in Target Branch    ${input_trans_code}
    :FOR    ${item_pr}    ${item_num}    ${item_list_del}   ${item_status}  IN ZIP    ${list_product}    ${list_num_change}    ${list_del_imei}    ${get_list_imei_status}
    \     Run Keyword If    '${item_status}'!='True'    KV Input Text By Code    ${textbox_ch_num_by_pr}     ${item_pr}    ${item_num}
    \     Run Keyword If    '${item_status}'=='True'    Remove list imei for product    ${item_list_del}
    Input data    ${textbox_note_in_received_screen}    ${text_note}
    Click Element    ${button_complete}

Remove list imei for product
    [Arguments]   ${list_imei}
    :FOR    ${item_imei}    IN ZIP    ${list_imei}
    \     KV Click Element JS By Code    ${button_dong_imei}    ${item_imei}

Accept transferring proccess with A part
    [Arguments]    ${input_trans_code}    ${list_num_change}
    Wait Until Keyword Succeeds    3 times    1 s    Click record contains Transfer code    ${input_trans_code}
    Wait Until Keyword Succeeds    3 times    1 s    Open Transfer Form in Target Branch    ${input_trans_code}
    ${index_row}    Set Variable    0
    ${index_in_list_change}    Set Variable    -1
    : FOR    ${item_in_list_num_changed}    IN    @{list_num_change}
    \    ${index_row}    Evaluate    ${index_row} + 1
    \    ${index_in_list_change}    Evaluate    ${index_in_list_change} + 1
    \    ${cell_trans_code_in_received_trans_form}    Format String    ${cell_trans_code_in_received_trans_form}    ${index_row}
    \    Wait Until Page Contains Element    ${cell_trans_code_in_received_trans_form}
    \    ${item_in_list_num_changed}    Get From List    ${list_num_change}    ${index_in_list_change}
    \    Change receiving num in Transfer form    ${index_row}    ${item_in_list_num_changed}

Change receiving num in Transfer form
    [Arguments]    ${row}    ${number_change}
    ${textbox_changed_num_by_row}    Format String    ${textbox_change_received_num_in_receive_screen}    ${row}
    Input data    ${textbox_changed_num_by_row}    ${number_change}

Change receiving quantity by product code in Transfer form
    [Arguments]    ${product_code}    ${number_change}
    ${textbox_changed_num_by_product_code}    Format String    ${textbox_quantity_receive_by_product_code}    ${product_code}
    Input data    ${textbox_changed_num_by_product_code}    ${number_change}

Input products and nums to Inventory transfer form in case receiving a part
    [Arguments]    ${input_product_code}    ${input_trans_num}    ${input_branch_name}    ${list_result_transferring_onhand_bf_trans}    ${list_result_received_onhand_bf_trans}    ${input_num_change}
    ...    ${lastest_num}
    ${transferring_onhand_af_trans}    ${transferring_cost_af_trans}    Get Cost and OnHand frm API    ${input_product_code}
    ${received_onhand_af_trans}    ${received_cost_af_trans}    Get Cost and Onhand frm API by Branch    ${input_product_code}    ${input_branch_name}
    Wait Until Page Contains Element    ${textbox_chuyenhang_search_product}    2 min
    Wait Until Keyword Succeeds    3 times    10 s    Input data in textbox and wait until it is visible    ${textbox_chuyenhang_search_product}    ${input_product_code}    ${item_ch_first_product_dropdownlist_search}
    ...    ${cell_first_product_code}
    sleep    2 s
    Wait Until Page Contains Element    ${textbox_ch_nums}    2 min
    ${result_lastest_number}    Input number and validate data    ${textbox_ch_nums}    ${input_trans_num}    ${lastest_num}    ${cell_lastest_num}
    ${get_transferring_onhand}    ${get_received_onhand}    Get transferring Onhand and received Onhand on UI
    ### Assert values UI Onhand on both Branchs
    Should Be Equal As Numbers    ${get_transferring_onhand}    ${transferring_onhand_af_trans}
    Should Be Equal As Numbers    ${get_received_onhand}    ${received_onhand_af_trans}
    ## Compute and append to list
    ${transferring_onhand_bf_trans}    Minus    ${transferring_onhand_af_trans}    ${input_num_change}
    ${received_onhand_bf_trans}    Sum    ${received_onhand_af_trans}    ${input_num_change}
    Append To List    ${list_result_transferring_onhand_bf_trans}    ${transferring_onhand_bf_trans}
    Append To List    ${list_result_received_onhand_bf_trans}    ${received_onhand_bf_trans}
    Return From Keyword    ${list_result_transferring_onhand_bf_trans}    ${list_result_received_onhand_bf_trans}    ${result_lastest_number}

Input products and nums to Inventory transfer form in case not finish
    [Arguments]    ${input_product_code}    ${input_trans_num}    ${input_branch_name}    ${list_source_onhand_af_trans}    ${list_target_onhand_af_trans}    ${lastest_num}
    ${source_onhand_bf_trans}    ${source_baseprice_af_trans}    Get Cost and OnHand frm API    ${input_product_code}
    ${target_onhand_af_trans}    ${target_baseprice_af_trans}    Get Cost and Onhand frm API by Branch    ${input_product_code}    ${input_branch_name}
    Wait Until Page Contains Element    ${textbox_chuyenhang_search_product}    2 min
    Wait Until Keyword Succeeds    3 times    10 s    Input data in textbox and wait until it is visible    ${textbox_chuyenhang_search_product}    ${input_product_code}    ${item_ch_first_product_dropdownlist_search}
    ...    ${cell_first_product_code}
    sleep    2 s
    Wait Until Page Contains Element    ${textbox_ch_nums}    2 min
    ${result_lastest_number}    Input number and validate data    ${textbox_ch_nums}    ${input_trans_num}    ${lastest_num}    ${cell_lastest_num}
    ${get_source_onhand}    ${get_target_onhand}    Get transferring Onhand and received Onhand on UI
    ### Assert values UI Onhand on both Branchs
    Should Be Equal As Numbers    ${get_source_onhand}    ${source_onhand_bf_trans}
    Should Be Equal As Numbers    ${get_target_onhand}    ${target_onhand_af_trans}
    ## Compute and append to list
    ${source_onhand_bf_trans}    Minus    ${source_onhand_bf_trans}    ${input_trans_num}
    Append To List    ${list_source_onhand_af_trans}    ${source_onhand_bf_trans}
    Append To List    ${list_target_onhand_af_trans}    ${target_onhand_af_trans}
    Return From Keyword    ${list_source_onhand_af_trans}    ${list_target_onhand_af_trans}    ${result_lastest_number}

Assert values Transfer form in Target branch
    [Arguments]    ${input_trans_code}    ${text_status}    ${source_branch}    ${target_branch}
    Wait Until Keyword Succeeds    3 times    1s    Click record contains Transfer code    ${input_trans_code}
    Wait Until Page Contains Element    ${status_in_receive_screen}
    Element Should Contain    ${status_in_receive_screen}    ${text_status}
    Element Should Contain    ${from_branch_in_receive_screen}    ${source_branch}
    Element Should Contain    ${to_branch_in_receive_screen}    ${target_branch}

Input products and nums to Inventory transfer form in case cancel
    [Arguments]    ${input_product_code}    ${input_trans_num}    ${input_branch_name}    ${list_transferring_onhand_bf_trans}    ${list_received_onhand_bf_trans}    ${lastest_num}
    ${transferring_onhand_af_trans}    ${transferring_baseprice_af_trans}    Get Cost and OnHand frm API    ${input_product_code}
    ${received_onhand_af_trans}    ${received_baseprice_af_trans}    Get Cost and Onhand frm API by Branch    ${input_product_code}    ${input_branch_name}
    Wait Until Page Contains Element    ${textbox_chuyenhang_search_product}    2 min
    Wait Until Keyword Succeeds    3 times    8 s    Input data in textbox and wait until it is visible    ${textbox_chuyenhang_search_product}    ${input_product_code}    ${item_ch_first_product_dropdownlist_search}
    ...    ${cell_first_product_code}
    sleep    2 s
    Wait Until Page Contains Element    ${textbox_ch_nums}    2 min
    ${result_lastest_number}    Input number and validate data    ${textbox_ch_nums}    ${input_trans_num}    ${lastest_num}    ${cell_lastest_num}
    ${get_transferring_onhand}    ${get_received_onhand}    Get transferring Onhand and received Onhand on UI
    ### Assert values UI Onhand on both Branchs
    Should Be Equal As Numbers    ${get_transferring_onhand}    ${transferring_onhand_af_trans}
    Should Be Equal As Numbers    ${get_received_onhand}    ${received_onhand_af_trans}
    ## Compute and append to list
    Append To List    ${list_transferring_onhand_bf_trans}    ${transferring_onhand_af_trans}
    Append To List    ${list_received_onhand_bf_trans}    ${received_onhand_af_trans}
    Return From Keyword    ${list_transferring_onhand_bf_trans}    ${list_received_onhand_bf_trans}    ${result_lastest_number}

Cancel transferring proccess
    [Arguments]    ${input_trans_code}
    Wait Until Keyword Succeeds    3 times    1 s    Click record contains Transfer code    ${input_trans_code}
    Wait Until Keyword Succeeds    3 times    1 s    Click button cancel transferring
    Wait Until Keyword Succeeds    3 times    1 s    Confirm Action Cancel

Confirm Action Cancel
    Wait Until Page Contains Element    ${button_dongy_cancel_transferring}    2 min
    Click Element JS   ${button_dongy_cancel_transferring}
    #Page Should Contain    ${input_trans_code}

Click button cancel transferring
    Wait Until Page Contains Element    ${button_cancel_transferring}    2 min
    Click Element JS   ${button_cancel_transferring}

Input products and IMEI to Inventory transfer form
    [Arguments]    ${source_branch_onhand_bf_trans}    ${target_branch_onhand_bf_trans}    ${branch_name}    ${input_product}    ${input_imei}    ${input_num}    ${lastest_num}
    Input product and its imei to any form    ${textbox_chuyenhang_search_product}    ${input_product}    ${item_ch_first_product_dropdownlist_search}    ${textbox_ch_serial}    ${item_ch_imei_indropdown}
    ...    ${cell_first_product_code}    ${cell_item_imei}    @{input_imei}
    ${lastest_num}    Sum     ${lastest_num}    ${input_num}
    ${get_source_onhand}    ${get_target_onhand}    Get transferring Onhand and received Onhand on UI
    ### Assert values UI Onhand on both Branchs
    Should Be Equal As Numbers    ${get_source_onhand}    ${source_branch_onhand_bf_trans}
    Should Be Equal As Numbers    ${get_target_onhand}    ${target_branch_onhand_bf_trans}
    Return From Keyword    ${lastest_num}

Input IMEI to Inventory transfer form
        [Arguments]    ${product_code}    ${trans_quan}    ${source_onhand_bf_trans}    ${target_onhand_bf_trans}    ${list_imei}     ${lastest_num}
        ${product_id}        Get product id thr API    ${product_code}
        ${textbox_input_imei_by_product_id}        Format String      ${textbox_input_imei_by_product_id}       ${product_id}
        : FOR    ${item_imei}    IN ZIP    ${list_imei}
        \    ${item_imei_indropdown_by_productcode1}        Format String      ${item_imei_indropdown_by_productcode}       ${product_id}      ${item_imei}
        \    Wait Until Keyword Succeeds    3 times    3 s    Input data in textbox and wait until it is visible    ${textbox_input_imei_by_product_id}    ${item_imei}
        \    ...    ${item_imei_indropdown_by_productcode1}    ${cell_item_imei}
        ${result_lastest_number}      Sum      ${lastest_num}    ${trans_quan}
        ${get_source_onhand}    ${get_target_onhand}    Get source - received Onhands by Product Code on UI    ${product_code}
        Should Be Equal As Numbers    ${get_source_onhand}    ${source_onhand_bf_trans}
        Should Be Equal As Numbers    ${get_target_onhand}    ${target_onhand_bf_trans}
        Return From Keyword    ${result_lastest_number}

Input products and IMEI to Inventory transfer form in case receiving a part
    [Arguments]    ${branch_name}    ${input_list_product}    ${input_list_imei}
    : FOR    ${item_product}    ${item_imei_inlist}    IN ZIP    ${input_list_product}    ${input_list_imei}
    \    Input product and its imei to any form    ${textbox_chuyenhang_search_product}    ${item_product}    ${item_ch_first_product_dropdownlist_search}    ${textbox_ch_serial}    ${item_ch_imei_indropdown}
    \    ...    ${cell_first_product_code}    ${cell_item_imei}    @{item_imei_inlist}
    \    ${source_branch_cost_bf_trans}    ${source_branch_onhand_bf_trans}    ${source_branch_imei_by_pr_bf_ex}    Get Cost and Imei OnHand frm API    ${item_product}
    \    ${target_branch_cost_bf_trans}    ${target_branch_onhand_bf_trans}    ${target_branch_imei_by_pr_bf_ex}    Get Cost and Imei OnHand frm API by Branch Name    ${branch_name}    ${item_product}
    \    ${get_source_onhand}    ${get_target_onhand}    Get transferring Onhand and received Onhand on UI
    \    ### Assert values UI Onhand on both Branchs
    \    Should Be Equal As Numbers    ${get_source_onhand}    ${source_branch_onhand_bf_trans}
    \    Should Be Equal As Numbers    ${get_target_onhand}    ${target_branch_onhand_bf_trans}

Accept transferring proccess and delete some IMEIs and adding note
    [Arguments]    ${input_trans_code}    ${list_imei_del}    ${text_note}
    Wait Until Keyword Succeeds    3 times    1 s    Click record contains Transfer code    ${input_trans_code}
    Wait Until Keyword Succeeds    3 times    1 s    Open Transfer Form in Target Branch    ${input_trans_code}
    ${index_in_list_change}    Set Variable    -1
    : FOR    ${item_in_list_imei_del}    IN    @{list_imei_del}
    \    ${index_in_list_change}    Evaluate    ${index_in_list_change} + 1
    \    ${item_in_list_imei_del}    Convert String to List    ${item_in_list_imei_del}
    \    Delete imeis in Transfer form    @{item_in_list_imei_del}
    Input data    ${textbox_note_in_received_screen}    ${text_note}
    Wait Until Element Is Enabled    ${button_complete}    1 min
    #Click Element    ${button_complete}
    Press Key      //body     ${F9_KEY}

Delete imeis in Transfer form
    [Arguments]    @{list_imei_by_pr}
    ${index_imei}    Set Variable    -1
    : FOR    ${item_in_imei_list_by_pro}    IN    @{list_imei_by_pr}
    \    ${index_imei}    Evaluate    ${index_imei} + 1
    \    ${item_in_list_num_changed}    Get From List    ${list_imei_by_pr}    ${index_imei}
    \    ${item_imei_del}    Format String    ${button_delete_imei_ch}    ${item_in_list_num_changed}
    \    Wait Until Page Contains Element    ${item_imei_del}    1 min
    \    Click Element JS    ${item_imei_del}

Get list of onhands-remain imei
    [Arguments]    ${list_result_source_onhand_af_trans}    ${list_result_target_onhand_af_trans}    ${list_result_trans_actual_num}    ${list_remain_imei}    ${branch_name}    ${input_list_product}
    ...    ${input_list_imei}    ${input_list_imei_del}
    : FOR    ${product}    ${item_imei_input_inlist}    ${item_imei_del_inlist}    IN ZIP    ${input_list_product}    ${input_list_imei}
    ...    ${input_list_imei_del}
    \    ${imei_remain_by_product}    Replace list from list    ${item_imei_input_inlist}    ${item_imei_del_inlist}
    \    Append to List    ${list_remain_imei}    ${imei_remain_by_product}
    \    ${get_actual_nums}    Get Length    ${imei_remain_by_product}
    \    ${source_branch_cost_bf_trans}    ${source_branch_onhand_bf_trans}    ${source_branch_imei_by_pr_bf_ex}    Get Cost and Imei OnHand frm API    ${product}
    \    ${target_branch_cost_bf_trans}    ${target_branch_onhand_bf_trans}    ${target_branch_imei_by_pr_bf_ex}    Get Cost and Imei OnHand frm API by Branch Name    ${branch_name}    ${product}
    \    ## Compute and append to list
    \    ${source_onhand_af_ex}    Minus    ${source_branch_onhand_bf_trans}    ${get_actual_nums}
    \    ${target_onhand_af_trans}    Sum    ${target_branch_onhand_bf_trans}    ${get_actual_nums}
    \    Append To List    ${list_result_source_onhand_af_trans}    ${source_onhand_af_ex}
    \    Append To List    ${list_result_target_onhand_af_trans}    ${target_onhand_af_trans}
    \    Append to List    ${list_result_trans_actual_num}    ${get_actual_nums}
    Return From Keyword    ${list_result_source_onhand_af_trans}    ${list_result_target_onhand_af_trans}    ${list_result_trans_actual_num}    ${list_remain_imei}

Input products and imeis to Inventory Transfer form in case not finish
    [Arguments]    ${list_result_source_onhand_af_trans}    ${list_result_target_onhand_af_trans}    ${input_list_product}    ${input_list_imei}    ${input_list_num}    ${branch_name}
    : FOR    ${item_product}    ${item_imei_inlist}    ${item_num}    IN ZIP    ${input_list_product}    ${input_list_imei}
    ...    ${input_list_num}
    \    Input product and its imei to any form    ${textbox_chuyenhang_search_product}    ${item_product}    ${item_ch_first_product_dropdownlist_search}    ${textbox_ch_serial}    ${item_ch_imei_indropdown}
    \    ...    ${cell_first_product_code}    ${cell_item_imei}    @{item_imei_inlist}
    \    ${source_branch_cost_bf_trans}    ${source_branch_onhand_bf_trans}    ${source_branch_imei_by_pr_bf_ex}    Get Cost and Imei OnHand frm API    ${item_product}
    \    ${target_branch_cost_bf_trans}    ${target_branch_onhand_bf_trans}    ${target_branch_imei_by_pr_bf_ex}    Get Cost and Imei OnHand frm API by Branch Name    ${branch_name}    ${item_product}
    \    ${get_source_onhand}    ${get_target_onhand}    Get transferring Onhand and received Onhand on UI
    \    ## Compute and append to list
    \    ${source_onhand_af_ex}    Minus    ${source_branch_onhand_bf_trans}    ${item_num}
    \    ${target_onhand_af_trans}    Sum    ${target_branch_onhand_bf_trans}    0
    \    ### Assert values UI Onhand on both Branchs
    \    Should Be Equal As Numbers    ${get_source_onhand}    ${source_branch_onhand_bf_trans}
    \    Should Be Equal As Numbers    ${get_target_onhand}    ${target_branch_onhand_bf_trans}
    \    Append To List    ${list_result_source_onhand_af_trans}    ${source_onhand_af_ex}
    \    Append To List    ${list_result_target_onhand_af_trans}    ${target_onhand_af_trans}
    Return From Keyword    ${list_result_source_onhand_af_trans}    ${list_result_target_onhand_af_trans}

Input products and imeis to Inventory Transfer form in case cancel
    [Arguments]    ${list_result_source_onhand_af_trans}    ${list_result_target_onhand_af_trans}    ${input_list_product}    ${input_list_imei}    ${branch_name}
    : FOR    ${item_product}    ${item_imei_inlist}    IN ZIP    ${input_list_product}    ${input_list_imei}
    \    Input product and its imei to any form    ${textbox_chuyenhang_search_product}    ${item_product}    ${item_ch_first_product_dropdownlist_search}    ${textbox_ch_serial}    ${item_ch_imei_indropdown}
    \    ...    ${cell_first_product_code}    ${cell_item_imei}    @{item_imei_inlist}
    \    ${source_branch_cost_bf_trans}    ${source_branch_onhand_bf_trans}    ${source_branch_imei_by_pr_bf_ex}    Get Cost and Imei OnHand frm API    ${item_product}
    \    ${target_branch_cost_bf_trans}    ${target_branch_onhand_bf_trans}    ${target_branch_imei_by_pr_bf_ex}    Get Cost and Imei OnHand frm API by Branch Name    ${branch_name}    ${item_product}
    \    ${get_source_onhand}    ${get_target_onhand}    Get transferring Onhand and received Onhand on UI
    \    ### Assert values UI Onhand on both Branchs
    \    Should Be Equal As Numbers    ${get_source_onhand}    ${source_branch_onhand_bf_trans}
    \    Should Be Equal As Numbers    ${get_target_onhand}    ${target_branch_onhand_bf_trans}
    \    Append To List    ${list_result_source_onhand_af_trans}    ${source_branch_onhand_bf_trans}
    \    Append To List    ${list_result_target_onhand_af_trans}    ${target_branch_onhand_bf_trans}
    Return From Keyword    ${list_result_source_onhand_af_trans}    ${list_result_target_onhand_af_trans}

Input Unit products and nums to Inventory transfer form
    [Arguments]    ${input_product_code}    ${input_trans_num}    ${input_branch_name}    ${lastest_num}
    ${source_onhand_bf_trans}    ${source_baseprice_bf_trans}    Get Cost and OnHand of Unit frm API    ${input_product_code}
    ${target_onhand_bf_trans}    ${target_baseprice_bf_trans}    Get Cost and Onhand of Unit frm API by Branch    ${input_product_code}    ${input_branch_name}
    Wait Until Page Contains Element    ${textbox_chuyenhang_search_product}    2 min
    Wait Until Keyword Succeeds    3 times    10 s    Input data in textbox and wait until it is visible    ${textbox_chuyenhang_search_product}    ${input_product_code}    ${item_ch_first_product_dropdownlist_search}
    ...    ${cell_first_product_code}
    sleep    2 s
    Wait Until Page Contains Element    ${textbox_ch_nums}    2 min
    ${result_lastest_number}    Input number and validate data    ${textbox_ch_nums}    ${input_trans_num}    ${lastest_num}    ${cell_lastest_num}
    ${get_transferring_onhand}    ${get_received_onhand}    Get transferring Onhand and received Onhand on UI
    ### Assert values UI Onhand on both Branchs
    Should Be Equal As Numbers    ${get_transferring_onhand}    ${source_onhand_bf_trans}
    Should Be Equal As Numbers    ${get_received_onhand}    ${target_onhand_bf_trans}
    Return From Keyword    ${result_lastest_number}

Open Transfer Form in Target Branch
    [Arguments]    ${input_trans_code}
    ${button_open_transform_by_code}    Format String    ${button_open_trans_form}    ${input_trans_code}
    Wait Until Page Contains Element    ${button_open_transform_by_code}    10 s
    Click Element    ${button_open_transform_by_code}
    sleep    3 s
    ${cell_trans_code_by_input_in_trans_form}    Format String    ${cell_trans_code_in_received_trans_form}    ${input_trans_code}    # cell mã phiếu trong form nhận hàng
    Wait Until Page Contains Element    ${cell_trans_code_by_input_in_trans_form}    10 s

Click record contains Transfer code
    [Arguments]    ${input_trans_code}
    ${cell_trans_code_by_input}    Format String    ${cell_transfer_code}    ${input_trans_code}    # record chứa mã phiếu chuyển
    Wait Until Page Contains Element    ${cell_trans_code_by_input}    10 s
    Click Element    ${cell_trans_code_by_input}
    ${button_open_transform_by_code}    Format String    ${button_open_trans_form}    ${input_trans_code}
    Wait Until Element Is Visible    ${button_open_transform_by_code}    10 s

Input products - lot name - nums to Inventory transfer form in case receiving a part
    [Arguments]    ${list_result_source_onhand_af_trans}    ${list_result_target_onhand_af_trans}    ${list_result_source_onhand_lot_af_trans}    ${list_result_target_onhand_lot_af_trans}    ${branch_name}    ${input_product}
    ...    ${input_tenlo}    ${input_num}    ${input_num_change}    ${lastest_num}
    Set Selenium Speed    1s
    Input products and lot name to any form auto fill lot    ${textbox_chuyenhang_search_product}    ${input_product}    ${item_ch_first_product_dropdownlist_search}    ${textbox_ch_nhaplo}    ${cell_ch_lo_indropdown}    ${cell_first_product_code}
    ...    ${cell_ch_item_lo}    ${input_tenlo}
    ${source_onhand_bf_trans}    ${source_baseprice_bf_trans}    Get Cost and OnHand frm API    ${input_product}
    ${target_onhand_bf_trans}    ${target_baseprice_bf_trans}    Get Cost and Onhand frm API by Branch    ${input_product}    ${branch_name}
    ${source_onhand_lo_bf_trans}    Get Onhand Lot in tab Lo - HSD frm API    ${input_product}    ${input_tenlo}
    ${target_onhand_lo_bf_trans}    Get lot onhand frm API by Branch Name    ${branch_name}    ${input_product}    ${input_tenlo}
    ${get_source_onhand}    ${get_target_onhand}    Get transferring Onhand and received Onhand on UI
    #
    Wait Until Page Contains Element    ${textbox_ch_nums}    2 min
    ${lastest_num}    Input number and validate data    ${textbox_ch_nums}    ${input_num}    ${lastest_num}    ${cell_lastest_num}
    ### Assert values UI Onhand on both Branchs
    Should Be Equal As Numbers    ${get_source_onhand}    ${source_onhand_lo_bf_trans}
    Should Be Equal As Numbers    ${get_target_onhand}    ${target_onhand_lo_bf_trans}
    ## Compute and append to list
    ${source_onhand_af_ex}    Minus    ${source_onhand_bf_trans}    ${input_num_change}
    ${target_onhand_af_trans}    Sum    ${target_onhand_bf_trans}    ${input_num_change}
    ${source_lot_onhand_af_ex}    Minus    ${source_onhand_lo_bf_trans}    ${input_num_change}
    ${target_onhand_lot_af_trans}    Sum    ${target_onhand_lo_bf_trans}    ${input_num_change}
    Append To List    ${list_result_source_onhand_af_trans}    ${source_onhand_af_ex}
    Append To List    ${list_result_target_onhand_af_trans}    ${target_onhand_af_trans}
    Append To List    ${list_result_source_onhand_lot_af_trans}    ${source_lot_onhand_af_ex}
    Append To List    ${list_result_target_onhand_lot_af_trans}    ${target_onhand_lot_af_trans}
    Return From Keyword    ${list_result_source_onhand_af_trans}    ${list_result_target_onhand_af_trans}    ${list_result_source_onhand_lot_af_trans}    ${list_result_target_onhand_lot_af_trans}    ${lastest_num}

Input products - lot name - nums to Inventory transfer form
    [Arguments]    ${list_result_source_onhand_af_trans}    ${list_result_target_onhand_af_trans}    ${list_result_source_onhand_lot_af_trans}    ${list_result_target_onhand_lot_af_trans}    ${branch_name}    ${input_product}
    ...    ${input_tenlo}    ${input_num}    ${lastest_num}
    Set Selenium Speed    1s
    Input products and lot name to any form auto fill lot    ${textbox_chuyenhang_search_product}    ${input_product}    ${item_ch_first_product_dropdownlist_search}    ${textbox_ch_nhaplo}    ${cell_ch_lo_indropdown}    ${cell_first_product_code}
    ...    ${cell_ch_item_lo}    ${input_tenlo}
    ${source_onhand_bf_trans}    ${source_baseprice_bf_trans}    Get Cost and OnHand frm API    ${input_product}
    ${target_onhand_bf_trans}    ${target_baseprice_bf_trans}    Get Cost and Onhand frm API by Branch    ${input_product}    ${branch_name}
    ${source_onhand_lo_bf_trans}    Get Onhand Lot in tab Lo - HSD frm API    ${input_product}    ${input_tenlo}
    ${target_onhand_lo_bf_trans}    Get lot onhand frm API by Branch Name    ${branch_name}    ${input_product}    ${input_tenlo}
    ${get_source_onhand}    ${get_target_onhand}    Get transferring Onhand and received Onhand on UI
    #
    Wait Until Page Contains Element    ${textbox_ch_nums}    2 min
    ${lastest_num}    Input number and validate data    ${textbox_ch_nums}    ${input_num}    ${lastest_num}    ${cell_lastest_num}
    ### Assert values UI Onhand on both Branchs
    Should Be Equal As Numbers    ${get_source_onhand}    ${source_onhand_lo_bf_trans}
    Should Be Equal As Numbers    ${get_target_onhand}    ${target_onhand_lo_bf_trans}
    ## Compute and append to list
    ${source_onhand_af_ex}    Minus    ${source_onhand_bf_trans}    ${input_num}
    ${target_onhand_af_trans}    Sum    ${target_onhand_bf_trans}    ${input_num}
    ${source_lot_onhand_af_ex}    Minus    ${source_onhand_lo_bf_trans}    ${input_num}
    ${target_onhand_lot_af_trans}    Sum    ${target_onhand_lo_bf_trans}    ${input_num}
    Append To List    ${list_result_source_onhand_af_trans}    ${source_onhand_af_ex}
    Append To List    ${list_result_target_onhand_af_trans}    ${target_onhand_af_trans}
    Append To List    ${list_result_source_onhand_lot_af_trans}    ${source_lot_onhand_af_ex}
    Append To List    ${list_result_target_onhand_lot_af_trans}    ${target_onhand_lot_af_trans}
    Return From Keyword    ${list_result_source_onhand_af_trans}    ${list_result_target_onhand_af_trans}    ${list_result_source_onhand_lot_af_trans}    ${list_result_target_onhand_lot_af_trans}    ${lastest_num}

Input products - lot name - nums to Inventory transfer form in case not finish
    [Arguments]    ${list_result_source_onhand_af_trans}    ${list_result_target_onhand_af_trans}    ${list_result_source_onhand_lot_af_trans}    ${list_result_target_onhand_lot_af_trans}    ${branch_name}    ${input_product}
    ...    ${input_tenlo}    ${input_num}    ${lastest_num}
    Set Selenium Speed    1s
    Input products and lot name to any form auto fill lot    ${textbox_chuyenhang_search_product}    ${input_product}    ${item_ch_first_product_dropdownlist_search}    ${textbox_ch_nhaplo}    ${cell_ch_lo_indropdown}    ${cell_first_product_code}
    ...    ${cell_ch_item_lo}    ${input_tenlo}
    ${source_onhand_bf_trans}    ${source_baseprice_bf_trans}    Get Cost and OnHand frm API    ${input_product}
    ${target_onhand_bf_trans}    ${target_baseprice_bf_trans}    Get Cost and Onhand frm API by Branch    ${input_product}    ${branch_name}
    ${source_onhand_lo_bf_trans}    Get Onhand Lot in tab Lo - HSD frm API    ${input_product}    ${input_tenlo}
    ${target_onhand_lo_bf_trans}    Get lot onhand frm API by Branch Name    ${branch_name}    ${input_product}    ${input_tenlo}
    ${get_source_onhand}    ${get_target_onhand}    Get transferring Onhand and received Onhand on UI
    #
    Wait Until Page Contains Element    ${textbox_ch_nums}    2 min
    ${lastest_num}    Input number and validate data    ${textbox_ch_nums}    ${input_num}    ${lastest_num}    ${cell_lastest_num}
    ### Assert values UI Onhand on both Branchs
    Should Be Equal As Numbers    ${get_source_onhand}    ${source_onhand_lo_bf_trans}
    Should Be Equal As Numbers    ${get_target_onhand}    ${target_onhand_lo_bf_trans}
    ## Compute and append to list
    ${source_onhand_af_ex}    Minus    ${source_onhand_bf_trans}    ${input_num}
    ${source_lot_onhand_af_ex}    Minus    ${source_onhand_lo_bf_trans}    ${input_num}
    ${target_onhand_lot_af_trans}    Sum    ${target_onhand_lo_bf_trans}    ${input_num}
    Append To List    ${list_result_source_onhand_af_trans}    ${source_onhand_af_ex}
    Append To List    ${list_result_target_onhand_af_trans}    ${target_onhand_bf_trans}
    Append To List    ${list_result_source_onhand_lot_af_trans}    ${source_lot_onhand_af_ex}
    Append To List    ${list_result_target_onhand_lot_af_trans}    ${target_onhand_lo_bf_trans}
    Return From Keyword    ${list_result_source_onhand_af_trans}    ${list_result_target_onhand_af_trans}    ${list_result_source_onhand_lot_af_trans}    ${list_result_target_onhand_lot_af_trans}    ${lastest_num}

Input products - lot name - nums to Inventory transfer form in case cancel
    [Arguments]    ${list_result_source_onhand_af_trans}    ${list_result_target_onhand_af_trans}    ${list_result_source_onhand_lot_af_trans}    ${list_result_target_onhand_lot_af_trans}    ${branch_name}    ${input_product}
    ...    ${input_tenlo}    ${input_num}    ${lastest_num}
    Set Selenium Speed    1s
    Input products and lot name to any form auto fill lot    ${textbox_chuyenhang_search_product}    ${input_product}    ${item_ch_first_product_dropdownlist_search}    ${textbox_ch_nhaplo}    ${cell_ch_lo_indropdown}    ${cell_first_product_code}
    ...    ${cell_ch_item_lo}    ${input_tenlo}
    ${source_onhand_bf_trans}    ${source_baseprice_bf_trans}    Get Cost and OnHand frm API    ${input_product}
    ${target_onhand_bf_trans}    ${target_baseprice_bf_trans}    Get Cost and Onhand frm API by Branch    ${input_product}    ${branch_name}
    ${source_onhand_lo_bf_trans}    Get Onhand Lot in tab Lo - HSD frm API    ${input_product}    ${input_tenlo}
    ${target_onhand_lo_bf_trans}    Get lot onhand frm API by Branch Name    ${branch_name}    ${input_product}    ${input_tenlo}
    ${get_source_onhand}    ${get_target_onhand}    Get transferring Onhand and received Onhand on UI
    #
    Wait Until Page Contains Element    ${textbox_ch_nums}    2 min
    ${lastest_num}    Input number and validate data    ${textbox_ch_nums}    ${input_num}    ${lastest_num}    ${cell_lastest_num}
    ### Assert values UI Onhand on both Branchs
    Should Be Equal As Numbers    ${get_source_onhand}    ${source_onhand_lo_bf_trans}
    Should Be Equal As Numbers    ${get_target_onhand}    ${target_onhand_lo_bf_trans}
    Append To List    ${list_result_source_onhand_af_trans}    ${source_onhand_bf_trans}
    Append To List    ${list_result_target_onhand_af_trans}    ${target_onhand_bf_trans}
    Append To List    ${list_result_source_onhand_lot_af_trans}    ${source_onhand_lo_bf_trans}
    Append To List    ${list_result_target_onhand_lot_af_trans}    ${target_onhand_lo_bf_trans}
    Return From Keyword    ${list_result_source_onhand_af_trans}    ${list_result_target_onhand_af_trans}    ${list_result_source_onhand_lot_af_trans}    ${list_result_target_onhand_lot_af_trans}    ${lastest_num}

Go to select group pop up for transfer
    Wait Until Element Is Enabled    ${button_select_group_for_transfer}        10 s
    Click Element    ${button_select_group_for_transfer}
    Wait Until Element Is Enabled    ${textbox_search_group_selectgrouppopup}      10 s

Select Group for transfer products
    [Arguments]         ${group_name}
    ${xpath_groupname}       Format String        ${checkbox_group_selectgrouppopup}        ${group_name}
    Wait Until Element Is Enabled    ${xpath_groupname}
    Click Element JS         ${xpath_groupname}
    Click Element    ${button_xong_selectgrouppopup}
    #Wait Until Page Does Not Contain    Chọn nhóm hàng

Turn off received default frm transfer
    Wait Until Element Is Visible    ${button_select_display_options}        1 min
    Wait Until Keyword Succeeds    3 times    1 s    Click Element JS    ${button_select_display_options}
    Wait Until Element Is Visible    ${toggle_default_receided}        1 min
    Wait Until Keyword Succeeds    3 times    1 s    Click Element JS    ${toggle_default_receided}
    Wait Until Element Is Visible    ${button_dongy_in_popup_received}        1 min
    Wait Until Keyword Succeeds    3 times    1 s    Click Element JS    ${button_dongy_in_popup_received}

Turn on received default frm transfer
    Wait Until Element Is Visible    ${button_select_display_options}        1 min
    Wait Until Keyword Succeeds    3 times    1 s    Click Element JS    ${button_select_display_options}
    Wait Until Element Is Visible    ${toggle_default_receided}        1 min
    Wait Until Keyword Succeeds    3 times    1 s    Click Element JS    ${toggle_default_receided}
