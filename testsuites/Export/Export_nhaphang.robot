*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    F
Test Setup         Before Test and set up folder download default
Test Teardown     After Test
\Resource         ../../core/Giao_dich/nhap_hang_add_action.robot
Resource          ../../core/Giao_dich/nhap_hang_add_page.robot
Resource          ../../core/Giao_dich/nhap_hang_list_action.robot
Resource          ../../core/Ban_Hang/banhang_manager_navigation.robot
Resource          ../../core/API/api_phieu_nhap_hang.robot
Resource          ../../config/env_product/envi.robot
Resource          ../../core/Giao_dich/giaodich_nav.robot
Resource          ../../core/share/excel.robot

*** Variables ***
&{dict_product_num}       IM27=5
${path_excel_file}      C:\\auto_download\\${env}\\{0}
*** Test Cases ***    URL file                List product          Status
Export purchase receipt        [Tags]            EXP
                      [Template]    export_purre
                      ${path_excel_file}    ${dict_product_num}     null
                      ${path_excel_file}    ${dict_product_num}     detail

*** Keywords ***
export_purre
    [Arguments]      ${input_path_excel}    ${dict_product}   ${input_status}
    Set Selenium Speed      1s
    ${purchase_receipt_code}   Add new purchase receipt without supplier    ${dict_product}
    Wait Until Keyword Succeeds    3 times    3s    Go To Nhap Hang
    Wait Until Keyword Succeeds    3 times    3s     Search code frm manager    ${purchase_receipt_code}
    Wait Until Keyword Succeeds    3 times    3s    Run Keyword If    '${input_status}'=='null'    Go to select export file other form    ${cell_item_export_tongquan}    ${purchase_receipt_code}   ELSE    Go to select export file other form    ${cell_item_export_chitiet}    ${purchase_receipt_code}
    Sleep    5s
    :FOR    ${time}     IN RANGE    20
    \     ${get_name_export_file}   KV Get text    ${cell_name_export_file}
    \     Exit For Loop If    '${get_name_export_file}'!='0'
    ${path}   Format String     ${input_path_excel}    ${get_name_export_file}
    ${get_name_export}   Replace String    ${get_name_export_file}   .xlsx     ${EMPTY}
    ${get_name_export}   Get Substring    ${get_name_export}    0     31
    Wait Until Keyword Succeeds    3 times    2s    File Should Exist   ${path}
    Wait Until Keyword Succeeds    3 times    3s    Open Excel    ${path}
    ${cell_purchase_receipt}    Run Keyword If    '${input_status}'=='null'   Read Cell Data By Name    ${get_name_export}    A2    ELSE   Read Cell Data By Name    ${get_name_export}    B2
    Should Be Equal As Strings    ${cell_purchase_receipt}    ${purchase_receipt_code}
    Delete purchase receipt code    ${purchase_receipt_code}
