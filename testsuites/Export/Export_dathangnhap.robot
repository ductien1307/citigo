*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    F
Test Setup        Before Test and set up folder download default
Test Teardown     After Test
Resource          ../../core/API/api_danhmuc_hanghoa.robot
Resource          ../../core/Doi_Tac/doitac_navigation.robot
Resource          ../../core/Ban_Hang/banhang_manager_navigation.robot
Resource          ../../core/Giao_dich/dat_hang_nhap_list_page.robot
Resource          ../../core/API/api_dathangnhap.robot
Resource          ../../config/env_product/envi.robot
Resource          ../../core/Giao_dich/giaodich_nav.robot
Resource          ../../core/share/excel.robot

*** Variables ***
&{dict_product_num}       IM26=3
${path_excel_file}      C:\\auto_download\\${env}\\{0}
*** Test Cases ***    URL file                List product          Status
Export purchase        [Tags]            IM
                      [Template]    export_purchase
                      ${path_excel_file}    ${dict_product_num}     null
                      ${path_excel_file}    ${dict_product_num}     detail

*** Keywords ***
export_purchase
    [Arguments]      ${input_path_excel}    ${dict_product}   ${input_status}
    Set Selenium Speed      1s
    ${purchase_code}   Add new purchase order no payment without supplier    ${dict_product}
    Wait Until Keyword Succeeds    3 times    3s    Go to Dat Hang Nhap
    Wait Until Keyword Succeeds    3 times    3s    Search code frm manager    ${purchase_code}
    Wait Until Keyword Succeeds    3 times    3s    Run Keyword If    '${input_status}'=='null'     Go to select export file other form    ${cell_item_export_tongquan}    ${purchase_code}   ELSE    Go to select export file other form    ${cell_item_export_chitiet}    ${purchase_code}
    Sleep    5s
    :FOR    ${time}     IN RANGE    20
    \     ${get_name_export_file}   KV Get text    ${cell_name_export_file}
    \     Exit For Loop If    '${get_name_export_file}'!='0'
    ${path}   Format String     ${input_path_excel}    ${get_name_export_file}
    ${get_name_export}   Replace String    ${get_name_export_file}   .xlsx     ${EMPTY}
    ${get_name_export}   Get Substring    ${get_name_export}    0     31
    Wait Until Keyword Succeeds    3 times    2s    File Should Exist   ${path}
    Wait Until Keyword Succeeds    3 times    3s    Open Excel    ${path}
    ${cell_purchase}    Run Keyword If    '${input_status}'=='null'   Read Cell Data By Name    ${get_name_export}    A3    ELSE    Read Cell Data By Name    ${get_name_export}    B2
    Should Be Equal As Strings    ${cell_purchase}    ${purchase_code}
    Delete purchase order code    ${purchase_code}
