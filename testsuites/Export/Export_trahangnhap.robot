*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    F
Test Setup        Before Test and set up folder download default
Test Teardown     After Test
Library           String
Resource          ../../core/Ban_Hang/banhang_manager_navigation.robot
Resource          ../../core/Giao_dich/tra_hang_nhap_list_page.robot
Resource          ../../core/Giao_dich/tra_hang_nhap_list_action.robot
Resource          ../../core/API/api_danhmuc_hanghoa.robot
Resource          ../../core/API/api_tra_hang_nhap.robot
Resource          ../../core/share/toast_message.robot
Resource          ../../core/share/list_dictionary.robot
Resource          ../../core/share/javascript.robot
Resource          ../../config/env_product/envi.robot
Resource          ../../core/Hang_hoa/danh_muc_list_page.robot
Resource          ../../core/Giao_dich/giaodich_nav.robot
Resource          ../../core/share/excel.robot

*** Variables ***
&{dict_product_num}       QDI002=4
${path_excel_file}      C:\\auto_download\\${env}\\{0}
*** Test Cases ***    URL file                 List product
Export purchase return        [Tags]            EXP
                      [Template]    export_trans
                      ${path_excel_file}      ${dict_product_num}       null
                      ${path_excel_file}    ${dict_product_num}         detail

*** Keywords ***
export_trans
    [Arguments]      ${input_path_excel}    ${dict_product}   ${input_status}
    Set Selenium Speed      1s
    ${pur_return_code}    Add new purchase return no payment without supplier    ${dict_product}
    Wait Until Keyword Succeeds    3 times    3s    Go To Tra Hang Nhap
    Wait Until Keyword Succeeds    3 times    3s     Search code frm manager    ${pur_return_code}
    Wait Until Keyword Succeeds    3 times    3s    Run Keyword If    '${input_status}'=='null'     Go to select export file    ${cell_item_export_tongquan}   ${pur_return_code}   ELSE    Go to select export file    ${cell_item_export_chitiet}    ${pur_return_code}
    Sleep    5s
    :FOR    ${time}     IN RANGE    20
    \     ${get_name_export_file}   KV Get text    ${cell_name_export_file}
    \     Exit For Loop If    '${get_name_export_file}'!='0'
    ${path}   Format String     ${input_path_excel}    ${get_name_export_file}
    ${get_name_export}   Replace String    ${get_name_export_file}   .xlsx     ${EMPTY}
    ${get_name_export}   Get Substring    ${get_name_export}    0     31
    Wait Until Keyword Succeeds    3 times    2s    File Should Exist   ${path}
    Wait Until Keyword Succeeds    3 times    3s    Open Excel    ${path}
    ${cell_pur_return}    Run Keyword If    '${input_status}'=='null'   Read Cell Data By Name    ${get_name_export}    A2    ELSE   Read Cell Data By Name    ${get_name_export}    B2
    Should Be Equal As Strings    ${cell_pur_return}    ${pur_return_code}
    Delete purchase return code    ${pur_return_code}
