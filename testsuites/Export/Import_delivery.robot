*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    F
Test Setup        Before Test and set up folder download default
Test Teardown     After Test
Resource          ../../config/env_product/envi.robot
Resource          ../../core/Doi_Tac/doitac_navigation.robot
Resource          ../../core/Doi_Tac/giaohang_list_action.robot
Resource          ../../core/Doi_Tac/giaohang_list_page.robot
Resource          ../../core/API/api_doi_tac_giaohang.robot
Resource          ../../core/Doi_Tac/danh_muc_list_page.robot
Resource          ../../prepare/Hang_hoa/Sources/doitac.robot
Resource          ../../core/Ban_Hang/banhang_manager_navigation.robot
Resource          ../../core/share/discount.robot
Resource          ../../core/Giao_dich/giaodich_nav.robot
Resource          ../../core/share/excel.robot

*** Variables ***
${excel_file}      ${EXECDIR}${/}testsuites${/}Export${/}Import_file${/}Delivery.xlsx
${path_excel_file}      C:\\auto_download\\${env}\\{0}

*** Test Cases ***    Tên
Import delivery        [Tags]              IMP
                      [Template]    import_deli
                      ${excel_file}     DTGHN001   Giao hàng tiết kiệm      19008198      Delivery

Export delivery        [Tags]            IMP
                      [Template]    export_deli
                      DTGHN001   Giao hàng tiết kiệm      19008198      ${path_excel_file}

*** Keywords ***
import_deli
    [Arguments]    ${input_excel_file}    ${input_delivery}   ${input_ten_dtgh}    ${input_sdt}    ${input_excel_name}
    Set Selenium Speed      1s
    Delete delivery exist frm api    ${input_delivery}
    #Add partner delivery    ${input_delivery}   ${input_ten_dtgh}    ${input_sdt}
    Wait Until Keyword Succeeds    3 times    3s    Go to Doi Tac Giao hang
    Wait Until Keyword Succeeds    3 times    3s    KV Click Element JS      ${button_import}
    Wait Until Keyword Succeeds    3 times    3s    Choose File    ${button_chonfile}    ${input_excel_file}
    Wait Until Keyword Succeeds    3 times    3s    KV Click Element      ${button_uploadfile}
    Wait Until Keyword Succeeds    3 times    3s    Open Excel    ${input_excel_file}
    ${cell_deli}   Read Cell Data By Name    ${input_excel_name}    A2
    Wait Until Keyword Succeeds    3 times    3s    Search delivery partner    ${cell_deli}
    Wait Until Keyword Succeeds    3 times    3s    Page should Contain    ${cell_deli}
    Delete partner delivery    ${cell_deli}

export_deli
    [Arguments]         ${input_delivery}   ${input_ten_dtgh}    ${input_sdt}   ${input_path_excel}
    Set Selenium Speed      1s
    Delete delivery exist frm api    ${input_delivery}
    Add partner delivery    ${input_delivery}   ${input_ten_dtgh}    ${input_sdt}
    Wait Until Keyword Succeeds    3 times    3s    Go to Doi Tac Giao hang
    Wait Until Keyword Succeeds    3 times    3s    Search delivery partner    ${input_delivery}
    Wait Until Keyword Succeeds    3 times    3s    KV Click Element      ${button_export}
    Sleep    5s
    :FOR    ${time}     IN RANGE    20
    \     ${get_name_export_file}   KV Get text    ${cell_name_export_file}
    \     Exit For Loop If    '${get_name_export_file}'!='0'
    ${path}   Format String     ${input_path_excel}    ${get_name_export_file}
    ${get_name_export}   Replace String    ${get_name_export_file}   .xlsx     ${EMPTY}
    ${get_name_export}   Get Substring    ${get_name_export}    0     31
    Wait Until Keyword Succeeds    3 times    2s    File Should Exist   ${path}
    Wait Until Keyword Succeeds    3 times    3s    Open Excel    ${path}
    ${cell_deli}   Read Cell Data By Name    ${get_name_export}    A2
    Should Be Equal As Strings    ${cell_deli}    ${input_delivery}
    Delete partner delivery    ${cell_deli}
