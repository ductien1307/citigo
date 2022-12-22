*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    F
Test Setup        Before Test and set up folder download default
Test Teardown     After Test
Resource          ../../core/Hang_Hoa/kiemkho_list_action.robot
Resource          ../../core/hang_hoa/danh_muc_list_action.robot
Resource          ../../config/env_product/envi.robot
Resource          ../../core/share/toast_message.robot
Resource          ../../core/API/api_danhmuc_hanghoa.robot
Resource          ../../core/API/api_kiemkho.robot
Resource          ../../core/share/imei.robot
Resource          ../../core/share/list_dictionary.robot
Resource          ../../core/Ban_Hang/banhang_manager_navigation.robot
Resource          ../../core/Giao_dich/xuat_huy_list_page.robot
Resource          ../../core/Hang_hoa/hang_hoa_navigation.robot
Resource          ../../core/share/excel.robot

*** Variables ***
&{dict_product_num}       PIB05=1600
${path_excel_file}      C:\\auto_download\\${env}\\{0}
*** Test Cases ***    URL file                List product
Export inventory        [Tags]            IM
                      [Template]    export_inventory
                      ${path_excel_file}    ${dict_product_num}     null
                      ${path_excel_file}    ${dict_product_num}     detail

*** Keywords ***
export_inventory
    [Arguments]      ${input_path_excel}    ${dict_product}   ${input_status}
    Set Selenium Speed      1s
    ${inventory_code}   Add new inventory frm api    ${dict_product}
    Wait Until Keyword Succeeds    3 times    3s    Go to Kiem kho
    Wait Until Keyword Succeeds    3 times    3s     Search code frm manager    ${inventory_code}
    Wait Until Keyword Succeeds    3 times    3s    Run Keyword If    '${input_status}'=='null'     Go to select export file    ${cell_item_export_tongquan}   ${inventory_code}   ELSE    Go to select export file    ${cell_item_export_chitiet}    ${inventory_code}
    Sleep    5s
    :FOR    ${time}     IN RANGE    20
    \     ${get_name_export_file}   KV Get text    ${cell_name_export_file}
    \     Exit For Loop If    '${get_name_export_file}'!='0'
    ${path}   Format String     ${input_path_excel}    ${get_name_export_file}
    ${get_name_export}   Replace String    ${get_name_export_file}   .xlsx     ${EMPTY}
    ${get_name_export}   Get Substring    ${get_name_export}    0     31
    Wait Until Keyword Succeeds    3 times    2s    File Should Exist   ${path}
    Wait Until Keyword Succeeds    3 times    3s    Open Excel    ${path}
    ${cell_inventory}    Read Cell Data By Name    ${get_name_export}    A2
    Should Be Equal As Strings    ${cell_inventory}    ${inventory_code}
    Delete Inventory code in Inventory Counting List    ${inventory_code}
