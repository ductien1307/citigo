*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}      ${headless_browser}
Test Setup        Before Test BC Hang Hoa
Test Teardown     After Test
Library           SeleniumLibrary
Library           Collections
Resource          ../../../config/env_product/envi.robot
Resource          ../../../core/API/api_hoadon_banhang.robot
Resource          ../../../core/Bao_cao/bc_list_page.robot
Resource          ../../../core/API/api_mhbh.robot
Resource          ../../../core/Bao_cao/bc_hang_hoa_list_action.robot
Resource          ../../../core/API/api_danhmuc_hanghoa.robot

*** Variables ***
&{list_prs_num}    RPT0008=3
&{list_prs_num1}    RPT0009=7.5

*** Test Cases ***    Mã KH         List products and nums    List giá mới           GGHD               Mã Combo    Khách thanh toán
Hoa don               [Tags]        CRP
                      [Template]    ehh01
                      ${list_prs_num}     50000

Trả hàng              [Tags]        CRP
                      [Template]    ehh02
                      ${list_prs_num1}    50000

*** Keywords ***
ehh01
    [Arguments]       ${dict_product_nums}      ${input_khtt}
    ${get_ma_hd}    Add new invoice without customer thr API    ${dict_product_nums}   ${input_khtt}
    Sleep    5s
    Reload Page
    Sleep    5s
    Click Element    ${checkbox_bao_cao}
    Sleep    5s
    Click Element    ${checkbox_bchh_loinhuan}
    Sleep    15s
    ${list_pr}    Get Dictionary Keys    ${dict_product_nums}
    ${list_dvqd}    Create List
    : FOR    ${item_pr}    IN ZIP    ${list_pr}
    \    ${item_dvqd}    Get DVQD by product code frm API    ${item_pr}
    \    Append To List    ${list_dvqd}    ${item_dvqd}
    Log    ${list_dvqd}
    Click Element JS    ${button_bchh_show_hanghoa}
    : FOR    ${item_pr}    ${item_dvqd}    IN ZIP    ${list_pr}    ${list_dvqd}
    \    Search product in BC hang hoa    ${item_pr}
    \    ${get_pr_cb}    Run Keyword If    ${item_dvqd}>1    Get basic product frm unit product    ${item_pr}
    \    ...    ELSE    Set Variable    ${item_pr}
    \    Wait Until Keyword Succeeds    3 times    10s    Element Should Contain    ${cell_du_lieu_bc}    ${get_pr_cb}
    Delete invoice by invoice code    ${get_ma_hd}

ehh02
    [Arguments]     ${dict_product_nums}      ${input_khtt}
    ${get_ma_th}    Add new return without customer and imei frm API    ${dict_product_nums}   ${input_khtt}
    Sleep    5s
    Reload Page
    Sleep    5s
    Click Element    ${checkbox_bao_cao}
    Sleep    5s
    Click Element    ${checkbox_bchh_loinhuan}
    Sleep    15s
    ${list_pr}    Get Dictionary Keys    ${dict_product_nums}
    ${list_dvqd}    Create List
    : FOR    ${item_pr}    IN ZIP    ${list_pr}
    \    ${item_dvqd}    Get DVQD by product code frm API    ${item_pr}
    \    Append To List    ${list_dvqd}    ${item_dvqd}
    Log    ${list_dvqd}
    Click Element JS    ${button_bchh_show_hanghoa}
    : FOR    ${item_pr}    ${item_dvqd}    IN ZIP    ${list_pr}    ${list_dvqd}
    \    Search product in BC hang hoa    ${item_pr}
    \    ${get_pr_cb}    Run Keyword If    ${item_dvqd}>1    Get basic product frm unit product    ${item_pr}
    \    ...    ELSE    Set Variable    ${item_pr}
    \    Wait Until Keyword Succeeds    3 times    10s    Element Should Contain    ${cell_du_lieu_bc}    ${get_pr_cb}
    Delete return thr API    ${get_ma_th}
