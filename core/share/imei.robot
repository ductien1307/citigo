*** Settings ***
Library           SeleniumLibrary
Resource          ../share/constants.robot
Resource          ../share/javascript.robot
Resource          ../share/computation.robot
Resource          ../share/discount.robot
Library           Collections
Resource          ../API/api_phieu_nhap_hang.robot
Resource          ../API/api_access.robot
Resource          ../Ban_Hang/banhang_page.robot
Resource          ../API/api_danhmuc_hanghoa.robot

*** Keywords ***
Input product and its imei to any form
    [Arguments]    ${textbox_search_ma_sp}    ${input_ma_sp}    ${item_product_indropdown}    ${textbox_input_imei}    ${item_imei_indropdown}    ${cell_product_target}
    ...    ${cell_item_imei}    @{list_imei}
    Wait Until Keyword Succeeds    3 times    8 s    Input data in textbox and wait until it is visible    ${textbox_search_ma_sp}    ${input_ma_sp}    ${item_product_indropdown}
    ...    ${cell_product_target}
    ${index_imei}    Set Variable    -1
    : FOR    ${imei}    IN    @{list_imei}
    \    ${index_imei}    Evaluate    ${index_imei} + 1
    \    ${item_imei}    Get From List    ${list_imei}    ${index_imei}
    \    Wait Until Keyword Succeeds    3 times    3 s    Input data in textbox and wait until it is visible    ${textbox_input_imei}    ${item_imei}
    \    ...    ${item_imei_indropdown}    ${cell_item_imei}

Input product and its imei to any form and return lastest number
    [Arguments]    ${textbox_search_ma_sp}    ${input_ma_sp}    ${input_number_imei}    ${item_product_indropdown}    ${textbox_input_imei}    ${item_imei_indropdown}
    ...    ${cell_product_target}    ${cell_item_imei}    ${lastest_num}    @{list_imei}
    Wait Until Keyword Succeeds    3 times    8 s    Input data in textbox and wait until it is visible    ${textbox_search_ma_sp}    ${input_ma_sp}    ${item_product_indropdown}
    ...    ${cell_product_target}
    ${index_imei}    Set Variable    -1
    : FOR    ${imei}    IN    @{list_imei}
    \    ${cell_item_imei}    Format String    ${cell_each_imei}    ${imei}
    \    ${index_imei}    Evaluate    ${index_imei} + 1
    \    ${item_imei}    Get From List    ${list_imei}    ${index_imei}
    \    Wait Until Keyword Succeeds    3 times    3 s    Input data in textbox and wait until it is visible    ${textbox_input_imei}    ${item_imei}
    \    ...    ${item_imei_indropdown}    ${cell_item_imei}
    ${result_lastest_number}    sum    ${input_number_imei}    ${lastest_num}
    Return From Keyword    ${result_lastest_number}

Input imei and return lastest number
    [Arguments]    ${item_product}    ${textbox_input_imei}    ${item_imei_indropdown}    ${cell_item_imei}    ${input_number_imei}    ${lastest_num}    @{list_imei}
    ${index_imei}    Set Variable    -1
    : FOR    ${imei}    IN    @{list_imei}
    \    ${textbox_input_imei}    Format String    ${textbox_input_imei}    ${item_product}
    \    ${cell_item_imei}    Format String    ${cell_each_imei}    ${imei}
    \    ${index_imei}    Evaluate    ${index_imei} + 1
    \    ${item_imei}    Get From List    ${list_imei}    ${index_imei}
    \    Wait Until Keyword Succeeds    3 times    8 s    Input data in textbox and wait until it is visible    ${textbox_input_imei}    ${item_imei}
    \    ...    ${item_imei_indropdown}    ${cell_item_imei}
    ${result_lastest_number}    sum    ${input_number_imei}    ${lastest_num}
    Return From Keyword    ${result_lastest_number}

Input product and its imei mul-lines to any form and return lastest number
    [Arguments]    ${line_quan}    ${textbox_search_ma_sp}    ${input_ma_sp}    ${item_product_indropdown}    ${cell_product_target}    ${button_add_line}
    ...    ${textbox_input_imei}    ${textbox_input_imei_by_line}    ${item_imei_indropdown}    ${cell_item_imei}    ${cell_item_imei_by_line}    ${lastest_num}
    ...    ${input_list_quan_imei}    ${list_all_imeis_by_line}
    Wait Until Keyword Succeeds    3 times    8 s    Input data in textbox and wait until it is visible    ${textbox_search_ma_sp}    ${input_ma_sp}    ${item_product_indropdown}
    ...    ${cell_product_target}
    : FOR    ${quan_imei}    ${list_imei_by_line}    IN ZIP    ${input_list_quan_imei}    ${list_all_imeis_by_line}
    \    Input imei and return lastest number by each line    ${button_add_line}    ${quan_imei}    ${textbox_input_imei_by_line}    ${list_imei_by_line}    ${cell_item_imei}
    \    ...    ELSE    Wait Until Keyword Succeeds    3 times    3 s    Input every single imei and validate data
    \    ...    ${textbox_input_imei}    ${item_imei}    ${item_imei_indropdown}    ${cell_item_imei}
    ${result_lastest_number}    sum    ${input_quan_imei}    ${lastest_num}
    Return From Keyword    ${result_lastest_number}

Input list imei and return lastest number
    [Arguments]    ${textbox_input_imei}    ${item_imei_indropdown}    ${cell_item_imei}    ${imei_quantity}    ${list_imei}    ${lastest_num}
    #${index_imei}    Set Variable    -1
    : FOR    ${imei}    IN    @{list_imei}
    \    #\    ${index_imei}    Evaluate    ${index_imei} + 1
    \    #\    ${item_imei}    Get From List    ${list_imei}    ${index_imei}
    \    Wait Until Keyword Succeeds    3 times    3 s    Input every single imei and validate data    ${textbox_input_imei}    ${imei}
    \    ...    ${item_imei_indropdown}    ${cell_item_imei}
    ${result_lastest_number}    sum    ${imei_quantity}    ${lastest_num}
    Return From Keyword    ${result_lastest_number}

Input data by clicking dropdown element
    [Arguments]    ${textbox_nhap_serial}    ${input_serial_num}    ${cell_serial_imei}
    Wait Until Page Contains Element    ${textbox_nhap_serial}    30s
    Input text    ${textbox_nhap_serial}    ${input_serial_num}
    #Wait Until Page Contains Element    ${cell_serial_imei}    30s
    Click Element JS    ${cell_serial_imei}
    #Press Key    ${textbox_nhap_serial}    ${ENTER_KEY}

Input product and its imei with enter key
    [Arguments]    ${textbox_search_ma_sp}    ${input_ma_sp}    ${item_product_indropdown}    ${textbox_input_imei}    ${target_cell}    @{list_imei}
    Wait Until Keyword Succeeds    3 times    8 s    Input data in textbox and wait until it is visible    ${textbox_search_ma_sp}    ${input_ma_sp}    ${item_product_indropdown}
    ...    ${target_cell}
    ${index_imei}    Set Variable    -1
    : FOR    ${imei}    IN    @{list_imei}
    \    ${index_imei}    Evaluate    ${index_imei} + 1
    \    ${item_imei}    Get From List    ${list_imei}    ${index_imei}
    \    Wait Until Keyword Succeeds    3 times    8 s    input data    ${textbox_input_imei}    ${item_imei}

Create list imei
    [Arguments]    ${list_prs}    ${list_nums}
    [Timeout]
    ${imei_by_product_inlist}    create list
    : FOR    ${item_product}    ${item_num}    IN ZIP    ${list_prs}    ${list_nums}
    \    ${imei_by_product}    Import multi imei for product    ${item_product}    ${item_num}
    \    Append To List    ${imei_by_product_inlist}    ${imei_by_product}
    Log many    ${imei_by_product_inlist}
    Set Test Variable    \${imei_inlist}    ${imei_by_product_inlist}
    Set Test Variable    \${list_prs}    ${list_prs}
    Set Test Variable    \${list_num}    ${list_nums}

Create list imei and other product
    [Arguments]    ${list_prs}    ${list_nums}
    [Timeout]
    ${imei_by_product_inlist}    create list
    ${get_list_status}    Get list imei status thr API    ${list_prs}
    : FOR    ${item_product}    ${item_num}    ${item_status}    IN ZIP    ${list_prs}    ${list_nums}
    ...    ${get_list_status}
    \    ${imei_by_product}    Run Keyword If    '${item_status}' == '0'    Set Variable    ${EMPTY}
    \    ...    ELSE    Import multi imei for product    ${item_product}    ${item_num}
    \    Append To List    ${imei_by_product_inlist}    ${imei_by_product}
    Log many    ${imei_by_product_inlist}
    Set Test Variable    \${imei_inlist}    ${imei_by_product_inlist}
    Set Test Variable    \${list_prs}    ${list_prs}
    Set Test Variable    \${list_num}    ${list_nums}

Input imei incase multi product to any form
    [Arguments]    ${item_product}    ${textbox_input_imei}    ${item_imei_indropdown}    ${cell_item_imei}    @{list_imei}
    ${index_imei}    Set Variable    -1
    : FOR    ${imei}    IN    @{list_imei}
    \    ${textbox_input_imei}    Format String    ${textbox_input_imei}    ${item_product}
    \    ${cell_item_imei}    Format String    ${cell_each_imei}    ${imei}
    \    ${index_imei}    Evaluate    ${index_imei} + 1
    \    ${item_imei}    Get From List    ${list_imei}    ${index_imei}
    \    Wait Until Keyword Succeeds    3 times    8 s    Input data in textbox and wait until it is visible    ${textbox_input_imei}    ${item_imei}
    \    ...    ${item_imei_indropdown}    ${cell_item_imei}

Input imei incase multi product to any form - return lastest
    [Arguments]    ${item_product}    ${input_nums}    ${textbox_input_imei}    ${item_imei_indropdown}    ${cell_item_imei}   ${lastest_num}    @{list_imei}
    ${index_imei}    Set Variable    -1
    : FOR    ${imei}    IN    @{list_imei}
    \    ${textbox_input_imei}    Format String    ${textbox_input_imei}    ${item_product}
    \    ${cell_item_imei}    Format String    ${cell_each_imei}    ${imei}
    \    ${index_imei}    Evaluate    ${index_imei} + 1
    \    ${item_imei}    Get From List    ${list_imei}    ${index_imei}
    \    Wait Until Keyword Succeeds    3 times    8 s    Input data in textbox and wait until it is visible    ${textbox_input_imei}    ${item_imei}
    \    ...    ${item_imei_indropdown}    ${cell_item_imei}
    ${lastest_num}    Sum    ${input_nums}   ${lastest_num}
    Return From Keyword    ${lastest_num}

Input product and imei incase multi product to any form
    [Arguments]    ${textbox_search_ma_sp}    ${input_ma_sp}    ${item_product_indropdown}    ${textbox_input_imei}    ${item_imei_indropdown}    ${cell_product_target}
    ...    ${cell_item_imei}    @{list_imei}
    Wait Until Keyword Succeeds    3 times    8 s    Input data in textbox and wait until it is visible    ${textbox_search_ma_sp}    ${input_ma_sp}    ${item_product_indropdown}
    ...    ${cell_product_target}
    ${index_imei}    Set Variable    -1
    : FOR    ${imei}    IN    @{list_imei}
    \    ${textbox_input_imei}    Format String    ${textbox_input_imei}    ${input_ma_sp}
    \    ${cell_item_imei}    Format String    ${cell_item_imei}    ${input_ma_sp}
    \    ${index_imei}    Evaluate    ${index_imei} + 1
    \    ${item_imei}    Get From List    ${list_imei}    ${index_imei}
    \    Wait Until Keyword Succeeds    3 times    8 s    Input data in textbox and wait until it is visible    ${textbox_input_imei}    ${item_imei}
    \    ...    ${item_imei_indropdown}    ${cell_item_imei}

Create list imei by generating random
    [Arguments]    ${input_soluong}
    ${list_imei}    Create List
    : FOR    ${item}    IN RANGE    ${input_soluong}
    \    ${list_imei}    Create imei list by generating random imei code    ${list_imei}
    Return From Keyword    ${list_imei}

Generate and return list imei randomly by string
    [Arguments]    ${quantity}
    ${list_imei}    Create List
    : FOR    ${item}    IN RANGE    ${quantity}
    \    ${list_imei}    Create imei list by generating random imei code    ${list_imei}
    ${string_imei}    Convert list to string    ${list_imei}
    Return From Keyword    ${string_imei}

Create list imei for multi row
    [Arguments]    ${prs}    ${list_nums}
    ${imei_by_product_inlist}    create list
    : FOR    ${item_num}    IN ZIP    ${list_nums}
    \    ${imei_by_product}    Import multi imei for product    ${prs}    ${item_num}
    \    Append To List    ${imei_by_product_inlist}    ${imei_by_product}
    Return From Keyword    ${imei_by_product_inlist}

Generate list imei by receipt multi row
    [Arguments]     ${list_nums}
    ${list_imei_multi_row}    create list
    : FOR    ${item_num}    IN ZIP    ${list_nums}
    \    ${imei_by_row}   Create list imei by generating random    ${item_num}
    \    Append To List    ${list_imei_multi_row}    ${imei_by_row}
    Return From Keyword    ${list_imei_multi_row}

Input imei incase multi row to any form
    [Arguments]    ${input_pr_id}    ${textbox_input_imei}    ${item_imei_indropdown}    ${cell_item_imei}    ${list_imei}
    ${cell_item_imei}    Format String    ${cell_item_imei}    ${input_pr_id}
    ${index_imei}    Set Variable    -1
    : FOR    ${imei}    IN    @{list_imei}
    \    ${textbox_input_imei}    Format String    ${textbox_input_imei}    ${input_pr_id}
    \    ${index_imei}    Evaluate    ${index_imei} + 1
    \    ${item_imei}    Get From List    ${list_imei}    ${index_imei}
    \    Wait Until Keyword Succeeds    3 times    2s    Input data in textbox and click      ${textbox_input_imei}    ${item_imei}
    \    ...    ${item_imei_indropdown}    ${cell_item_imei}

Get list imei from list multi row imei
    [Arguments]    ${list_num}    ${list_imei_all}
    ${list_imei}    Create List
    :FOR    ${item_num}    ${item_list_imei}    IN ZIP    ${list_num}    ${list_imei_all}
    \    ${item_list_imei_actual}    Get list imei by num    ${item_num}    ${item_list_imei}
    \    Append To List    ${list_imei}    ${item_list_imei_actual}
    Return From Keyword    ${list_imei}

Get list imei by num
    [Arguments]    ${num}    ${list_imei_all}
    ${index}    Set Variable    -1
    ${list_imei}    Create List
    :FOR    ${x}    IN RANGE    ${num}
    \    ${index}    Sum    ${index}    1
    \    ${index}    Replace floating point    ${index}
    \    ${imei}    Get From List    ${list_imei_all}    ${index}
    \    Append To List    ${list_imei}    ${imei}
    Return From Keyword    ${list_imei}

Get list imei by list num
    [Arguments]    ${list_num}    ${list_imei_all}
    ${index}    Set Variable    -1
    ${list_imei}    Create List
    :FOR    ${item_num}     ${item_list_imei_all}     IN ZIP        ${list_num}    ${list_imei_all}
    \     ${item_list_imei}     Get list imei by num    ${item_num}     ${item_list_imei_all}
    \     Append To List    ${list_imei}    ${item_list_imei}
    Return From Keyword     ${list_imei}

Import list mutil row imei
    [Arguments]   ${list_product}    ${list_num}   ${get_list_imei_status}
    ${list_imei}    create list
    : FOR    ${item_product}    ${item_num}    ${item_status}    IN ZIP    ${list_product}    ${list_num}    ${get_list_imei_status}
    \    ${item_num}    Split String    ${item_num}    ,
    \    ${imei_by_product}    Run Keyword If    '${item_status}'=='True'    Create list imei for multi row    ${item_product}    ${item_num}
    \    ...    ELSE    Set Variable    ${EMPTY}
    \    Append To List    ${list_imei}    ${imei_by_product}
    Return From Keyword       ${list_imei}

Import list imei for list product
    [Arguments]   ${list_products}    ${list_nums}    ${get_list_imei_status}
    ${list_all_imeis}    Create List
    : FOR    ${item_product}    ${item_num}    ${item_status}    IN ZIP    ${list_products}    ${list_nums}
    ...    ${get_list_imei_status}
    \    ${imei_by_product}    Run Keyword If    '${item_status}'=='True'    Import multi imei for product    ${item_product}    ${item_num}
    \    ...    ELSE    Set Variable    ${EMPTY}
    \    Append To List    ${list_all_imeis}    ${imei_by_product}
    Return From Keyword       ${list_all_imeis}

Get list imei to purchase return
    [Arguments]     ${list_nums_return}    ${list_imei_all}    ${get_list_imei_status}
    ${list_imei_return}    Create List
    : FOR    ${item_num_return}    ${item_list_imei}    ${item_status}    IN ZIP    ${list_nums_return}    ${list_imei_all}
    ...    ${get_list_imei_status}
    \    ${item_list_imei_return}    Run Keyword If    '${item_status}'=='True'    Convert string to List    ${item_list_imei}
    \    ...    ELSE    Set Variable    ${EMPTY}
    \    ${item_list_imei_return}    Run Keyword If    '${item_status}'=='True'    Get list imei by num    ${item_num_return}    ${item_list_imei_return}
    \    ...    ELSE    Set Variable    ${EMPTY}
    \    Append To List    ${list_imei_return}    ${item_list_imei_return}
    Return From Keyword        ${list_imei_return}

Compare Serial-imei
    [Arguments]    ${value}    @{list_serial_number}
    ${im1}    Set Variable    @{list_serial_number}[0]
    ${im2}    Set Variable    @{list_serial_number}[1]
    Log    ${im1}
    Log    ${im2}
    Should Contain Any    ${value}    ${im1}
    Should Contain Any    ${value}    ${im2}
