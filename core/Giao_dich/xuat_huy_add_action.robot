*** Settings ***
Library           SeleniumLibrary
Library           StringFormat
Library           String
Resource          ../share/computation.robot
Resource          ../share/javascript.robot
Resource          ../Hang_Hoa/sanxuat_list_action.robot
Resource          ../API/api_xuathuy.robot
Resource          xuat_huy_add_page.robot
Resource          ../share/discount.robot

*** Keywords ***
Input product - num in XH form
    [Arguments]    ${input_ma_cp}    ${input_soluong}
    Set Selenium Speed    0.5
    Wait Until Page Contains Element    ${textbox_xh_search_sp}    30s
    Wait Until Keyword Succeeds    3 times    3s    Input data in textbox and wait until it is visible    ${textbox_xh_search_sp}    ${input_ma_cp}    ${xh_item_indropdown_search}
    ...    ${xh_cell_first_product_code}
    KV Input Text    ${textbox_xh_nhap_soluong}    ${input_soluong}

Select unit to XH form
    [Arguments]    ${item_unit}
    KV Click Element     ${cell_xh_unit}
    KV Click Element By Code     ${item_unit_xh_inlist}    ${item_unit}
    Sleep    1s

Get list of damage value - result onhand - result cost after excute
    [Arguments]    ${list_pr}    ${list_num}
    ${list_result_total}    Create List
    ${list_result_onhand}    Create List
    ${list_result_cost}    Create List
    ${get_list_onhand_bf_ex}    ${get_lastprice_bf}    ${get_list_cost_bf_ex}    Get list of Onhand, LatestPurchasePrice and Cost frm API    ${list_pr}
    : FOR    ${item_cost}    ${item_onhand}    ${item_num}    IN ZIP    ${get_list_cost_bf_ex}    ${get_list_onhand_bf_ex}
    ...    ${list_num}
    \    ${result_total}    Multiplication and round    ${item_cost}    ${item_num}
    \    ${result_onhand}    Minus and round 2    ${item_onhand}    ${item_num}
    \    ${result_cost}    Set Variable    ${item_cost}
    \    Append To List    ${list_result_total}    ${result_total}
    \    Append To List    ${list_result_onhand}    ${result_onhand}
    \    Append To List    ${list_result_cost}    ${result_cost}
    Return From Keyword    ${list_result_total}    ${list_result_onhand}    ${list_result_cost}

Assert cost and damage value from UI
    [Arguments]    ${input_giavon}    ${num}
    ${giavon_ui}    Get New price from UI    ${xh_cell_first_gia_von}
    Should Be Equal As Numbers    ${input_giavon}    ${giavon_ui}
    ${result_total}    Multiplication and round    ${input_giavon}    ${num}
    ${total_ui}    Get New price from UI    ${xh_cell_first_giatri_huy}
    Should Be Equal As Numbers    ${total_ui}    ${result_total}

Input products and IMEIs to XH form
    [Arguments]    ${input_product}    ${input_list_imei}
    Input product and its imei to any form    ${textbox_xh_search_sp}    ${input_product}    ${xh_item_indropdown_search}    ${textbox_nhap_serial}    ${item_serial_in_dropdown}    ${xh_cell_first_product_code}
    ...    ${cell_item_input_imei}    @{input_list_imei}

Input products and lot name to XH form
    [Arguments]    ${input_ma_cp}    ${input_tenlo}   ${input_num}
    Wait Until Keyword Succeeds    3 times    3s    Input data in textbox and wait until it is visible    ${textbox_xh_search_sp}    ${input_ma_cp}    ${xh_item_indropdown_search}
    ...    ${xh_cell_first_product_code}
    ${input_tenlo}    Convert To String    ${input_tenlo}
    ${input_tenlo}    Replace sq blackets    ${input_tenlo}
    Wait Until Keyword Succeeds    3 times    1s    Input data in textbox and wait until it is visible    ${textbox_xh_nhaplo}    ${input_tenlo}    ${xh_cell_first_lo}
    ...    ${xh_cell_ten_lo}
    KV Input Text    ${textbox_xh_nhap_soluong}    ${input_num}

Input unit - num in XH form
    [Arguments]    ${input_unit}    ${input_number}    ${lastest_num}
    Wait Until Keyword Succeeds    3 times    3s    Select unit to XH form    ${input_unit}
    Wait Until Page Contains Element    ${textbox_xh_nhap_soluong}    30s
    ${lastest_num}    Input number and validate data    ${textbox_xh_nhap_soluong}    ${input_number}    ${lastest_num}    ${cell_xh_lastest_num}
    Return From Keyword    ${lastest_num}

Remove product from damage doc
    [Arguments]    ${ma_sp}
    KV Click Element By Code   ${button_xh_xoa_sp}    ${ma_sp}

Input num by product code to XH form
    [Arguments]    ${ma_sp}    ${input_soluong}
    ${textbox_xh_nhap_soluong_theo_sp}    Format String    ${textbox_xh_nhap_soluong_theo_sp}    ${ma_sp}
    KV Input Text       ${textbox_xh_nhap_soluong_theo_sp}    ${input_soluong}

Input list product - num in XH form
    [Arguments]   ${list_pr}    ${list_num}      ${list_imei_status}      ${list_imei_all}
    : FOR    ${item_pr}    ${item_num}       ${item_list_imei}    ${item_imei_status}     IN ZIP    ${list_pr}    ${list_num}    ${list_imei_all}     ${list_imei_status}
    \    Run Keyword If    '${item_imei_status}'!='True'    Input product - num in XH form    ${item_pr}    ${item_num}        ELSE     Input products and IMEIs to XH form    ${item_pr}    ${item_list_imei}

Validate Tong gia tri huy in XH form
    [Arguments]    ${input_tong_gt_huy}
    ${actual_tong_gt_huy}    Get New price from UI    ${cell_xh_tong_gt_huy}
    Should Be Equal As Numbers    ${input_tong_gt_huy}    ${actual_tong_gt_huy}

Edit product detail in XH form
    [Arguments]   ${list_pr}    ${list_pr_edit}   ${list_num_edit}    ${list_imei_status}   ${list_imei}
    : FOR    ${item_pr}    ${item_num}       ${item_imei_status}    ${item_imei}     IN ZIP    ${list_pr_edit}    ${list_num_edit}    ${list_imei_status}   ${list_imei}
    \    ${status_add}      Run Keyword And Return Status    List Should Contain Value    ${list_pr}    ${item_pr}
    \    Run Keyword If    '${status_add}'=='False' and '${item_imei_status}'!='True' and ${item_num}!=0    Input product - num in XH form    ${item_pr}    ${item_num}    ELSE IF    '${status_add}'=='False' and '${item_imei_status}'=='True'    Input products and IMEIs to XH form    ${item_pr}    ${item_imei}    ELSE IF   '${status_add}'!='False' and ${item_num}!=0    Input num by product code to XH form    ${item_pr}    ${item_num}      ELSE IF    ${item_num}==0    Remove product from damage doc    ${item_pr}

Input list product and lot name to XH form
    [Arguments]   ${list_pr}    ${list_num}    ${list_tenlo}
    : FOR    ${item_pr}    ${item_num}       ${item_tenlo}    IN ZIP    ${list_pr}   ${list_num}      ${list_tenlo}
    \    Input products and lot name to XH form    ${item_pr}    ${item_tenlo}   ${item_num}

Edit lodate product detail in XH form
    [Arguments]   ${list_pr}    ${list_pr_edit}   ${list_num_edit}   ${list_lodate_status}   ${list_tenlo}
    : FOR    ${item_pr}    ${item_num}    ${item_lodate_status}    ${item_tenlo}     IN ZIP    ${list_pr_edit}    ${list_num_edit}   ${list_lodate_status}    ${list_tenlo}
    \    ${status_add}      Run Keyword And Return Status    List Should Contain Value    ${list_pr}    ${item_pr}
    \    Run Keyword If    '${status_add}'=='False' and '${item_lodate_status}'!='True' and ${item_num}!=0    Input product - num in XH form    ${item_pr}    ${item_num}    ELSE IF    '${status_add}'=='False' and '${item_lodate_status}'=='True'    Input products and lot name to XH form    ${item_pr}   ${item_tenlo}     ${item_num}    ELSE IF   '${status_add}'!='False' and ${item_num}!=0    Input num by product code to XH form    ${item_pr}    ${item_num}      ELSE IF    ${item_num}==0    Remove product from damage doc    ${item_pr}
