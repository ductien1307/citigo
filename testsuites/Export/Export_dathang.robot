*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    F
Test Setup        Before Test and set up folder download default
Test Teardown     After Test
Resource          ../../config/env_product/envi.robot
Resource          ../../core/API/api_danhmuc_hanghoa.robot
Resource          ../../core/Giao_dich/giaodich_nav.robot
Resource          ../../core/Dat_Hang/dat_hang_action.robot
Resource          ../../core/Dat_Hang/dat_hang_navigation.robot
Resource          ../../core/Ban_Hang/banhang_manager_navigation.robot
Resource          ../../core/Dat_Hang/dat_hang_page.robot
Resource          ../../core/share/javascript.robot
Resource          ../../core/API/api_mhbh_dathang.robot
Resource          ../../core/share/excel.robot

*** Variables ***
&{dict_product_num}       IPCom02=1
${path_excel_file}      C:\\auto_download\\${env}\\{0}
*** Test Cases ***    URL file                List product          Payment     Status
Export order        [Tags]            IM
                      [Template]    export_order
                      ${path_excel_file}    ${dict_product_num}     100000       null
                      ${path_excel_file}    ${dict_product_num}     200000       detail

*** Keywords ***
export_order
    [Arguments]      ${input_path_excel}    ${dict_product}   ${input_khtt}   ${input_status}
    Set Selenium Speed      1s
    ${order_code}   Add new order with multi products no customer    ${dict_product}   ${input_khtt}
    Wait Until Keyword Succeeds    3 times    3s    Go to Dat hang
    Wait Until Keyword Succeeds    3 times    3s    Search code frm manager    ${order_code}
    Wait Until Keyword Succeeds    3 times    3s    Run Keyword If    '${input_status}'=='null'     Go to select export file    ${item_button_export_invoice}   ${order_code}   ELSE    Go to select export file    ${item_button_export_detail_inv}    ${order_code}
    Sleep    5s
    :FOR    ${time}     IN RANGE    20
    \     ${get_name_export_file}   KV Get text    ${cell_name_export_file}
    \     Exit For Loop If    '${get_name_export_file}'!='0'
    ${path}   Format String     ${input_path_excel}    ${get_name_export_file}
    ${get_name_export}   Replace String    ${get_name_export_file}   .xlsx     ${EMPTY}
    ${get_name_export}   Get Substring    ${get_name_export}    0     31
    Wait Until Keyword Succeeds    3 times    2s    File Should Exist   ${path}
    Wait Until Keyword Succeeds    3 times    3s    Open Excel    ${path}
    ${cell_order}    Run Keyword If    '${input_status}'=='null'   Read Cell Data By Name    ${get_name_export}    A2    ELSE  Read Cell Data By Name    ${get_name_export}    B2
    Should Be Equal As Strings    ${cell_order}    ${order_code}
    Delete order frm Order code    ${order_code}
