*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}   F
Test Setup        Before Test and set up folder download default
Test Teardown     After Test
Resource          ../../config/env_product/envi.robot
Resource          ../../core/Doi_Tac/doitac_navigation.robot
Resource          ../../core/Doi_Tac/khachhang_list_action.robot
Resource          ../../core/Doi_Tac/khachhang_list_page.robot
Resource          ../../core/Doi_Tac/danh_muc_list_page.robot
Resource          ../../core/API/api_khachhang.robot
Resource          ../../prepare/Hang_hoa/Sources/doitac.robot
Resource          ../../core/Ban_Hang/banhang_manager_navigation.robot
Resource          ../../core/share/discount.robot
Resource          ../../core/Giao_dich/giaodich_nav.robot
Resource          ../../core/share/excel.robot

*** Variables ***
${excel_file}      ${EXECDIR}${/}testsuites${/}Export${/}Import_file${/}Customers.xlsx
${path_excel_file}      C:\\auto_download\\${env}\\{0}
*** Test Cases ***    Tên
Import customer        [Tags]              IMP
                      [Template]    import_cus
                      ${excel_file}     IMKH001     Hoàng     0123498700    5A Lý Đạo Thành     Customers

Export customer        [Tags]            IMP
                      [Template]    export_cus
                      IMKH002     Hoàng     0123555700    5C Lý Đạo Thành     ${path_excel_file}

*** Keywords ***
import_cus
    [Arguments]    ${input_excel_file}    ${input_customer}   ${input_name}     ${input_phone}    ${input_address}    ${input_excel_name}
    Set Selenium Speed      1s
    ${get_customer_id}   Get customer id thr API    ${input_customer}
    Run Keyword If    '${get_customer_id}' == '0'    Log     Ignore del     ELSE    Delete customer    ${get_customer_id}
    #Add customers    ${input_customer}   ${input_name}     ${input_phone}    ${input_address}
    Wait Until Keyword Succeeds    3 times    3s    Go to Khach Hang
    Wait Until Keyword Succeeds    3 times    3s    Go to select import or export    ${item_button_import}
    Wait Until Keyword Succeeds    3 times    3s    Choose File    ${button_chonfile}    ${input_excel_file}
    Wait Until Keyword Succeeds    3 times    3s    KV Click Element    ${button_uploadfile}
    Wait Until Keyword Succeeds    3 times    3s    Open Excel    ${input_excel_file}
    #${get_name_export}   Get Substring    ${input_excel_file}    53     61
    ${cell_cus}   Read Cell Data By Name    ${input_excel_name}    B2
    Wait Until Keyword Succeeds    3 times    3s    Search customer    ${cell_cus}
    Wait Until Keyword Succeeds    3 times    3s    Page Should Contain    ${cell_cus}
    Delete customer by Customer Code    ${input_customer}

export_cus
    [Arguments]     ${input_customer}   ${input_name}     ${input_phone}    ${input_address}   ${input_path_excel}
    Set Selenium Speed      1s
    ${get_customer_id}   Get customer id thr API    ${input_customer}
    Run Keyword If    '${get_customer_id}' == '0'    Log     Ignore del     ELSE    Delete customer    ${get_customer_id}
    Add customers    ${input_customer}   ${input_name}     ${input_phone}    ${input_address}
    Wait Until Keyword Succeeds    3 times    3s    Go to Khach Hang
    Wait Until Keyword Succeeds    3 times    3s    Search customer    ${input_customer}
    Wait Until Keyword Succeeds    3 times    3s    Go to select import or export    ${item_button_export}
    Sleep    5s
    :FOR    ${time}     IN RANGE    20
    \     ${get_name_export_file}   KV Get text    ${cell_name_export_file}
    \     Exit For Loop If    '${get_name_export_file}'!='0'
    ${path}   Format String     ${input_path_excel}    ${get_name_export_file}
    ${get_name_export}   Replace String    ${get_name_export_file}   .xlsx     ${EMPTY}
    ${get_name_export}   Get Substring    ${get_name_export}    0     31
    Wait Until Keyword Succeeds    3 times    2s    File Should Exist   ${path}
    Wait Until Keyword Succeeds    3 times    3s     Open Excel    ${path}
    ${cell_name}   Read Cell Data    ${get_name_export}    2    1
    Should Be Equal As Strings    ${cell_name}    ${input_customer}
    Delete customer by Customer Code    ${input_customer}
