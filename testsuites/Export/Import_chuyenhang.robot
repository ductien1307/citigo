*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    F
Test Setup        Before Test and set up folder download default
Test Teardown     After Test
Resource          ../../core/Giao_dich/chuyenhang_form_page.robot
Resource          ../../core/Giao_dich/chuyenhang_page_action.robot
Resource          ../../core/Giao_dich/chuyenhang_page_list.robot
Resource          ../../core/API/api_danhmuc_hanghoa.robot
Resource          ../../core/API/api_chuyenhang.robot
Resource          ../../core/API/api_access.robot
Resource          ../../core/share/list_dictionary.robot
Resource          ../../core/share/javascript.robot
Resource          ../../core/share/excel.robot
Resource          ../../config/env_product/envi.robot
Resource          ../../core/Giao_dich/giaodich_nav.robot
Resource          ../../core/Ban_Hang/banhang_manager_navigation.robot
Resource          ../../core/Hang_hoa/danh_muc_list_page.robot
Resource          ../../core/share/discount.robot

*** Variables ***
&{dict_product_num}       PIB04=10
${excel_file}      ${EXECDIR}${/}testsuites${/}Export${/}Import_file${/}Transform.xlsx
${path_excel_file}      C:\\auto_download\\${env}\\{0}
*** Test Cases ***    URL file            Branch transfer         Branch received    List product
Import transform        [Tags]      IM
                      [Template]    import_trans
                      ${excel_file}     Transform

Export transform        [Tags]            IMP
                      [Template]    export_trans
                      ${path_excel_file}    Chi nhánh trung tâm     Nhánh A           ${dict_product_num}       null
                      #${path_excel_file}    Chi nhánh trung tâm     Nhánh A           ${dict_product_num}       detail

*** Keywords ***
import_trans
    [Arguments]    ${input_excel_file}    ${input_excel_name}
    Set Selenium Speed      1s
    Wait Until Keyword Succeeds    3 times    3s    Click Element JS      ${button_import}
    Wait Until Keyword Succeeds    3 times    3s    Choose File    ${button_chonfile}    ${input_excel_file}
    Wait Until Keyword Succeeds    3 times    3s    KV Click Element      ${button_uploadfile}
    Wait Until Keyword Succeeds    3 times    3s    Open Excel    ${input_excel_file}
    ${cell_product}   Read Cell Data By Name    ${input_excel_name}    D2
    ${get_product_id}   Get product id thr API    ${cell_product}
    ${endpoint_thekho}    Format String     ${endpoint_thekho}    ${get_product_id}     ${BRANCH_ID}
    ${transform_code}   Get data from API    ${endpoint_thekho}     $.Data[0]..DocumentCode
    Wait Until Keyword Succeeds    3 times    3s    KV Input data    ${textbox_search_ma_chuyenhang}    ${transform_code}
    Wait Until Keyword Succeeds    3 times    3s    Page should Contain    ${transform_code}
    Delete Transform code    ${transform_code}

export_trans
    [Arguments]      ${input_path_excel}    ${input_branch_chuyen}    ${input_branch_nhan}    ${dict_product}    ${input_status}
    Set Selenium Speed      1s
    ${transform_code}    ${list_result_transferring_onhand}    ${list_result_received_onhand}   Add new transform frm API    ${input_branch_chuyen}    ${input_branch_nhan}    ${dict_product}
    Wait Until Keyword Succeeds    3 times    3s    Go To Inventory Transfer
    Wait Until Keyword Succeeds    3 times    3s     KV Input data    ${textbox_search_ma_chuyenhang}    ${transform_code}
    Wait Until Keyword Succeeds    3 times    3s    Run Keyword If    '${input_status}'=='null'     Go to select export file    ${cell_item_export_tongquan}    ${transform_code}   ELSE         Go to select export file    ${cell_item_export_chitiet}    ${transform_code}
    Sleep    5s
    :FOR    ${time}     IN RANGE    20
    \     ${get_name_export_file}   KV Get text    ${cell_name_export_file}
    \     Exit For Loop If    '${get_name_export_file}'!='0'
    ${path}   Format String     ${input_path_excel}    ${get_name_export_file}
    ${get_name_export}   Replace String    ${get_name_export_file}   .xlsx     ${EMPTY}
    ${get_name_export}   Get Substring    ${get_name_export}    0     31
    Wait Until Keyword Succeeds    3 times    2s    File Should Exist   ${path}
    Wait Until Keyword Succeeds    3 times    3s     Open Excel    ${path}
    ${cell_transform}    Run Keyword If    '${input_status}'=='null'   Read Cell Data By Name    ${get_name_export}    A3     ELSE   Read Cell Data By Name    ${get_name_export}    A2
    Should Be Equal As Strings    ${cell_transform}    ${transform_code}
    Delete Transform code    ${transform_code}
