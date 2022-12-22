*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    ${headless_browser}
Test Setup        Before Test Ban Hang
Test Teardown     After Test
Library           SeleniumLibrary
Library           StringFormat
Resource          ../../../../core/Ban_Hang/banhang_action.robot
Resource          ../../../../core/API/api_thietlap.robot
Resource          ../../../../core/API/api_danhmuc_hanghoa.robot
Resource          ../../../../core/share/computation.robot
Resource          ../../../../core/API/api_mhbh_dathang.robot

*** Variables ***
&{dict_pr_num1}    DNT011=3
&{dict_pr_num2}    DNQD106=6

*** Test Cases ***     Dict sp - sl      Khach tt
Hoa don               [Tags]        CUI1
                      [Template]    cnso1
                      ${dict_pr_num1}       50000

Dat hang              [Tags]        CUI1
                      [Template]    cnso2
                      ${dict_pr_num2}    50000

Doi tra hang          [Tags]        CUI1
                      [Template]    cnso3
                      ${dict_pr_num1}    50000

*** Keywords ***
cnso1
    [Arguments]    ${dict_pr_num}      ${input_khtt}
    Turn on - off allow sell when out stock in shop config thr API    false
    Sleep    5s
    ${list_prs}    Get Dictionary Keys    ${dict_pr_num}
    ${list_nums}    Get Dictionary Values    ${dict_pr_num}
    ${list_result_ton_af_ex}   Get list result onhand af excute   ${list_prs}    ${list_nums}
    ${list_result_order_summary_af_ex}      Get list result order summary frm product API    ${list_prs}    ${list_nums}
    #
    ${list_order_summary_actual_af_ex}    Create List
    ${list_result_ton_actual_af_ex}    Create List
    : FOR    ${item_order_summary}    ${item_onhand}    IN ZIP    ${list_result_order_summary_af_ex}    ${list_result_ton_af_ex}
    \    ${item_order_summary}    Replace floating point    ${item_order_summary}
    \    ${item_onhand}    Replace floating point    ${item_onhand}
    \    Append To List    ${list_order_summary_actual_af_ex}    ${item_order_summary}
    \    Append To List    ${list_result_ton_actual_af_ex}    ${item_onhand}
    Log    ${list_order_summary_actual_af_ex}
    Log    ${list_result_ton_actual_af_ex}
    #
    ${list_num_input}    Create List
    : FOR    ${item_onhand}       IN ZIP    ${list_result_ton_af_ex}
    \    ${item_num_input}    Sum    ${item_onhand}    1
    \    ${item_num_input}    Replace floating point    ${item_num_input}
    \    ${item_num_input}    Set Variable If    ${item_num_input}<0    1    ${item_num_input}
    \    Append To List    ${list_num_input}    ${item_num_input}
    Log    ${list_num_input}
    #tao hoa don va don dat hang qua API
    ${invoice_code}   Add new invoice without customer thr API    ${dict_pr_num}   ${input_khtt}
    ${order_code}   Add new order with multi products no customer    ${dict_pr_num}   ${input_khtt}
    Sleep    10s
    Reload Page
    #input sp MHBH
    ${lastest_num}    Set Variable    0
    : FOR    ${item_pr}    ${item_num}    ${item_onhand}    ${item_order_summary}    IN ZIP    ${list_prs}
    ...    ${list_num_input}    ${list_result_ton_actual_af_ex}    ${list_order_summary_actual_af_ex}
    \    ${lastest_num}    Input product-num in BH form    ${item_pr}    ${item_num}    ${lastest_num}
    \    ${xp_icon}    Format String    ${icon_warning}    ${item_pr}
    \    Run Keyword If    ${item_num}<=${item_onhand}    Element Should Not Be Visible    ${xp_icon}
    \    ...    ELSE    Element Should Be Visible    ${xp_icon}
    \    ${get_value}    Run Keyword If    ${item_num}<=${item_onhand}    Log    Ignore icon
    \    ...    ELSE    Get value in icon warning    ${item_pr}
    \    ${value_result}    Format String    Tồn: {0} - Đặt: {1}    ${item_onhand}    ${item_order_summary}
    \    Run Keyword If    ${item_num}<=${item_onhand}    Log    Ingnore
    \    ...    ELSE    Should Be Equal As Strings    ${get_value}    ${value_result}
    Turn on - off allow sell when out stock in shop config thr API    true

cnso2
    [Arguments]    ${dict_pr_num}    ${input_khtt}
    Turn on - off allow sell when out stock in shop config thr API    false
    Sleep    5s
    ${list_prs}    Get Dictionary Keys    ${dict_pr_num}
    ${list_nums}    Get Dictionary Values    ${dict_pr_num}
    ${list_result_ton_af_ex}   Get list result onhand af excute   ${list_prs}    ${list_nums}
    ${list_result_order_summary_af_ex}      Get list result order summary frm product API    ${list_prs}    ${list_nums}
    #
    ${list_order_summary_actual_af_ex}    Create List
    ${list_result_ton_actual_af_ex}    Create List
    : FOR    ${item_order_summary}    ${item_onhand}    IN ZIP    ${list_result_order_summary_af_ex}    ${list_result_ton_af_ex}
    \    ${item_order_summary}    Replace floating point    ${item_order_summary}
    \    ${item_onhand}    Replace floating point    ${item_onhand}
    \    Append To List    ${list_order_summary_actual_af_ex}    ${item_order_summary}
    \    Append To List    ${list_result_ton_actual_af_ex}    ${item_onhand}
    Log    ${list_order_summary_actual_af_ex}
    Log    ${list_result_ton_actual_af_ex}
    #
    ${list_num_input}    Create List
    : FOR    ${item_onhand}     IN ZIP    ${list_result_ton_af_ex}
    \    ${item_num_input}    Sum    ${item_onhand}    1
    \    ${item_num_input}    Replace floating point    ${item_num_input}
    \    ${item_num_input}    Set Variable If    ${item_num_input}<0    1    ${item_num_input}
    \    Append To List    ${list_num_input}    ${item_num_input}
    Log    ${list_num_input}
    #tao hoa don va don dat hang qua API
    ${invoice_code}   Add new invoice without customer thr API    ${dict_pr_num}   ${input_khtt}
    ${order_code}   Add new order with multi products no customer    ${dict_pr_num}   ${input_khtt}
    Sleep    10s
    Reload Page
    Wait Until Keyword Succeeds    3 times    5 s    Click Element JS    ${tab_dathang}
    #input sp MHBH
    ${lastest_num}    Set Variable    0
    : FOR    ${item_pr}    ${item_num}    ${item_onhand}    ${item_order_summary}    IN ZIP    ${list_prs}
    ...    ${list_num_input}    ${list_result_ton_actual_af_ex}    ${list_order_summary_actual_af_ex}
    \    ${lastest_num}    Input product-num in sale form    ${item_pr}    ${item_num}    ${lastest_num}    ${cell_tongsoluong_dh}
    \    ${xp_icon}    Format String    ${icon_warning}    ${item_pr}
    \    Run Keyword If    ${item_num}<=${item_onhand}    Element Should Not Be Visible    ${xp_icon}
    \    ...    ELSE    Element Should Be Visible    ${xp_icon}
    \    ${get_value}    Run Keyword If    ${item_num}<=${item_onhand}    Log    Ignore icon
    \    ...    ELSE    Get value in icon warning    ${item_pr}
    \    ${value_result}    Format String    Tồn: {0} - Đặt: {1}    ${item_onhand}    ${item_order_summary}
    \    Run Keyword If    ${item_num}<=${item_onhand}    Log    Ingnore
    \    ...    ELSE    Should Be Equal As Strings    ${get_value}    ${value_result}
    Turn on - off allow sell when out stock in shop config thr API    true

cnso3
    [Arguments]    ${dict_pr_num}       ${input_khtt}
    Turn on - off allow sell when out stock in shop config thr API        false
    Sleep    5s
    ${list_prs}    Get Dictionary Keys    ${dict_pr_num}
    ${list_nums}    Get Dictionary Values    ${dict_pr_num}
    ${list_result_ton_af_ex}   Get list result onhand af excute   ${list_prs}    ${list_nums}
    ${list_result_order_summary_af_ex}      Get list result order summary frm product API    ${list_prs}    ${list_nums}
    #
    ${list_order_summary_actual_af_ex}    Create List
    ${list_result_ton_actual_af_ex}    Create List
    : FOR    ${item_order_summary}    ${item_onhand}    IN ZIP    ${list_result_order_summary_af_ex}    ${list_result_ton_af_ex}
    \    ${item_order_summary}    Replace floating point    ${item_order_summary}
    \    ${item_onhand}    Replace floating point    ${item_onhand}
    \    Append To List    ${list_order_summary_actual_af_ex}    ${item_order_summary}
    \    Append To List    ${list_result_ton_actual_af_ex}    ${item_onhand}
    Log    ${list_order_summary_actual_af_ex}
    Log    ${list_result_ton_actual_af_ex}
    #
    ${list_num_input}    Create List
    : FOR    ${item_onhand}    IN ZIP    ${list_result_ton_af_ex}
    \    ${item_num_input}    Sum    ${item_onhand}    1
    \    ${item_num_input}    Replace floating point    ${item_num_input}
    \    ${item_num_input}    Set Variable If    ${item_num_input}<0    1    ${item_num_input}
    \    Append To List    ${list_num_input}    ${item_num_input}
    Log    ${list_num_input}
    #tao hoa don va don dat hang qua API
    ${invoice_code}   Add new invoice without customer thr API    ${dict_pr_num}   ${input_khtt}
    ${order_code}   Add new order with multi products no customer    ${dict_pr_num}   ${input_khtt}
    Sleep    10s
    Reload Page
    Select Return without Invoice from BH page
    #input sp in form Doi tra hang
    ${lastest_num}    Set Variable    0
    : FOR    ${item_pr}    ${item_num}    ${item_onhand}    ${item_order_summary}    IN ZIP    ${list_prs}
    ...    ${list_num_input}    ${list_result_ton_actual_af_ex}    ${list_order_summary_actual_af_ex}
    \    ${lastest_num}    Input product and nums into Doi tra hang form    ${item_pr}    ${item_num}    ${lastest_num}
    \    ${xp_icon}    Format String    ${icon_warning}    ${item_pr}
    \    Run Keyword If    ${item_num}<=${item_onhand}    Element Should Not Be Visible    ${xp_icon}
    \    ...    ELSE    Element Should Be Visible    ${xp_icon}
    \    ${get_value}    Run Keyword If    ${item_num}<=${item_onhand}    Log    Ignore icon
    \    ...    ELSE    Get value in icon warning    ${item_pr}
    \    ${value_result}    Format String    Tồn: {0} - Đặt: {1}    ${item_onhand}    ${item_order_summary}
    \    Run Keyword If    ${item_num}<=${item_onhand}    Log    Ingnore
    \    ...    ELSE    Should Be Equal As Strings    ${get_value}    ${value_result}
    Turn on - off allow sell when out stock in shop config thr API      true
