*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    F
Test Setup        Before Test and set up folder download default
Test Teardown     After Test
Resource          ../../core/share/excel.robot
Resource          ../../config/env_product/envi.robot
Resource          ../../core/Doi_Tac/doitac_navigation.robot
Resource          ../../core/Doi_Tac/ncc_list_action.robot
Resource          ../../core/Doi_Tac/ncc_list_page.robot
Resource          ../../core/API/api_nha_cung_cap.robot
Resource          ../../core/Doi_Tac/danh_muc_list_page.robot
Resource          ../../prepare/Hang_hoa/Sources/doitac.robot
Resource          ../../core/Giao_dich/giaodich_nav.robot
Resource          ../../core/Ban_Hang/banhang_manager_navigation.robot

*** Variables ***
${excel_file}      ${EXECDIR}${/}testsuites${/}Export${/}Import_file${/}Supplier.xlsx
${path_excel_file}      C:\\auto_download\\${env}\\{0}

*** Test Cases ***    Tên
Import supplier        [Tags]              IMP
                      [Template]    import_sup
                      ${excel_file}     NCC000001      Nhà cung cấp import       19004545     Supplier

Export supplier        [Tags]            IMP
                      [Template]    export_sup
                      ${path_excel_file}     IMNCC001      Nhà cung cấp import       19004545

*** Keywords ***
import_sup
    [Arguments]    ${input_excel_file}    ${input_supplier}    ${input_supname}    ${input_supphone}    ${input_excel_name}
    Set Selenium Speed      3s
    ${get_supplier_id}   Get Supplier Id    ${input_supplier}
    Run Keyword If    '${get_supplier_id}' == '0'    Log     Ignore del     ELSE    Delete supplier    ${get_supplier_id}
    #Add supplier    ${input_supplier}    ${input_supname}    ${input_supphone}
    Wait Until Keyword Succeeds    3 times    3s    Go to Nha cung cap
    Wait Until Keyword Succeeds    3 times    3s    KV Click Element JS      ${button_import}
    Wait Until Keyword Succeeds    3 times    3s    Choose File    ${button_chonfile}    ${input_excel_file}
    Wait Until Keyword Succeeds    3 times    3s    KV Click Element      ${button_uploadfile}
    Wait Until Keyword Succeeds    3 times    3s    Open Excel    ${input_excel_file}
    ${cell_supplier}   Read Cell Data By Name    ${input_excel_name}    A2
    Wait Until Keyword Succeeds    3 times    3s    Search supplier    ${cell_supplier}
    Wait Until Keyword Succeeds    3 times    3s    Page Should Contain    ${cell_supplier}
    ${get_supplier_id}   Get Supplier Id    ${input_supplier}
    Delete supplier     ${get_supplier_id}

export_sup
    [Arguments]     ${input_path_excel}    ${input_supplier}    ${input_supname}    ${input_supphone}
    Set Selenium Speed      3s
    ${get_supplier_id}   Get Supplier Id    ${input_supplier}
    Run Keyword If    '${get_supplier_id}' == '0'    Log     Ignore del     ELSE    Delete supplier    ${get_supplier_id}
    Add supplier    ${input_supplier}    ${input_supname}    ${input_supphone}
    Wait Until Keyword Succeeds    3 times    3s    Go to Nha cung cap
    Wait Until Keyword Succeeds    3 times    3s    Search supplier    ${input_supplier}
    Wait Until Keyword Succeeds    3 times    3s    KV Click Element JS      ${button_export}
    Sleep    5s
    :FOR    ${time}     IN RANGE    20
    \     ${get_name_export_file}   KV Get text    ${cell_name_export_file}
    \     Exit For Loop If    '${get_name_export_file}'!='0'
    ${path}   Format String     ${input_path_excel}    ${get_name_export_file}
    ${get_name_export}   Replace String    ${get_name_export_file}   .xlsx     ${EMPTY}
    ${get_name_export}   Get Substring    ${get_name_export}    0     31
    Wait Until Keyword Succeeds    3 times    2s    File Should Exist   ${path}
    Wait Until Keyword Succeeds    3 times    3s    Open Excel    ${path}
    ${cell_supplier}   Read Cell Data By Name    ${get_name_export}    A2
    Should Be Equal As Strings    ${cell_supplier}    ${input_supplier}
    ${get_supplier_id}   Get Supplier Id    ${input_supplier}
    Delete supplier    ${get_supplier_id}
