*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}   F
Test Setup        Before Test and set up folder download default
Test Teardown     After Test
Import Library    ExcelLibrary
Resource          ../../../config/env_product/envi.robot
Resource          ../../../core/Doi_Tac/doitac_navigation.robot
Resource          ../../../core/Doi_Tac/khachhang_list_action.robot
Resource          ../../../core/Doi_Tac/khachhang_list_page.robot
Resource          ../../../core/Doi_Tac/danh_muc_list_page.robot
Resource          ../../../core/API/api_khachhang.robot
Resource          ../../../prepare/Hang_hoa/Sources/doitac.robot
Resource          ../../../core/Ban_Hang/banhang_manager_navigation.robot
Resource          ../../../core/share/discount.robot
Resource          ../../../core/Giao_dich/giaodich_nav.robot
Resource          ../../../core/Bao_mat_khach_hang/Bao_mat_KH_action.robot
Resource          ../../../core/share/excel.robot

*** Variables ***
${excel_file}      ${EXECDIR}${/}testsuites${/}Export${/}Import_file${/}IMPInvoice.xlsx
${excel_file1}      ${EXECDIR}${/}testsuites${/}Export${/}Import_file${/}CustomerKyc.xlsx
${excel_file2}      ${EXECDIR}${/}testsuites${/}Export${/}Import_file${/}CustomersKyc4.xlsx
${path_excel_file}      C:\\auto_download\\${env}\\{0}
*** Test Cases ***    Tên
Import new customer frome invoice
                      [Tags]       KYC4
                      [Template]    import_inv
                      ${excel_file}    IMPInvoice

Import new customer        [Tags]       KYC4
                      [Template]    import_new_customer
                      KYC00004    ${excel_file1}    Customers
Import ex customer        [Tags]       KYC4
                      [Template]    Imp_ex_customer
                      ${excel_file2}    Customers    KYC4    Nguyễn Hoàng Mai    0625351123    MlemHmu
*** Keywords ***
import_inv
    [Arguments]    ${input_excel_file}    ${input_excel_name}
    Set Selenium Speed      1s
    Wait Until Keyword Succeeds    3 times    3s    Go to Hoa don
    ${invoice_code}    Generate code automatically        HDIP
    Log    ${input_excel_file}
    ${doc_id}     Generate Random String    5    [UPPER][NUMBERS]
    Open Excel Document      ${input_excel_file}     doc_id=${doc_id}
    ${get_col_num}      Update code in file excel      Mã hóa đơn     ${invoice_code}
    Save Excel Document    ${input_excel_file}
    Reload Page
    Wait Until Keyword Succeeds    3 times    3s    Go to select import or export    ${item_button_import}
    Wait Until Keyword Succeeds    3 times    3s    Choose File    ${button_chonfile}    ${input_excel_file}
    Wait Until Keyword Succeeds    3 times    3s    KV Click Element    ${button_uploadfile}
    #button click xac nhan thay doi thoi gian hoa don
    #Wait Until Keyword Succeeds    3 times    3s    KV Click Element    ${button_accept_import}
    Wait Until Element Is Visible    ${label_imp_success}    2mins
    Wait Until Keyword Succeeds    3 times    3s    Open Excel    ${input_excel_file}
    #${get_name_export}   Get Substring    ${input_excel_file}    53     61
    ${cell_invoice_code}   Read Cell Data By Name    ${input_excel_name}    A3
    ${cell_customer_code}   Read Cell Data By Name    ${input_excel_name}    E3
    ${cell_customer_name}   Read Cell Data By Name    ${input_excel_name}    F3
    ${cell_customer_phone}   Read Cell Data By Name    ${input_excel_name}    G3
    ${cell_customer_email}   Read Cell Data By Name    ${input_excel_name}    H3
    ${cell_customer_address}   Read Cell Data By Name    ${input_excel_name}    I3
    Wait Until Keyword Succeeds    3 times    5s    Search code frm manager    ${cell_invoice_code}
    Log      ${cell_customer_code}
    ${get_ten_kh}    ${get_dienthoai_kh}    ${get_diachi_kh}    ${get_khuvuc_kh}    ${get_phuongxa_kh}    Get info customer frm API    ${cell_customer_code}
    Should Be Equal    ${cell_customer_name}    ${get_ten_kh}
    Should Be Equal    ${cell_customer_phone}    ${get_dienthoai_kh}
    Should Be Equal    ${cell_customer_email}    ${Email_customer}
    Should Be Equal    ${cell_customer_address}    ${get_diachi_kh}
    Delete customer if it exists    ${cell_customer_code}

import_new_customer
    [Arguments]    ${input_customer}    ${input_excel_file}    ${input_excel_name}
    Set Selenium Speed      1s
    ${get_customer_id}   Get customer id thr API    ${input_customer}
    Run Keyword If    '${get_customer_id}' == '0'    Log     Ignore del     ELSE    Delete customer    ${get_customer_id}
    Wait Until Keyword Succeeds    3 times    3s    Go to Khach Hang
    Wait Until Keyword Succeeds    3 times    3s    Go to select import or export    ${item_button_import}
    Wait Until Keyword Succeeds    3 times    3s    Choose File    ${button_chonfile}    ${input_excel_file}
    Wait Until Keyword Succeeds    3 times    3s    KV Click Element    ${button_uploadfile}
    Wait Until Keyword Succeeds    3 times    3s    Open Excel    ${input_excel_file}
    #${get_name_export}   Get Substring    ${input_excel_file}    53     61
    ${cell_customer_code}   Read Cell Data By Name    ${input_excel_name}    B2
    ${cell_customer_name}   Read Cell Data By Name    ${input_excel_name}    C2
    ${cell_customer_phone}   Read Cell Data By Name    ${input_excel_name}    D2
    ${cell_customer_email}   Read Cell Data By Name    ${input_excel_name}    L2
    ${cell_customer_address}   Read Cell Data By Name    ${input_excel_name}    E2
    Wait Until Element Is Visible    ${label_imp_success}    1mins
    Wait Until Keyword Succeeds    3 times    3s    Search customer    ${cell_customer_code}
    ${get_ten_kh}    ${get_dienthoai_kh}    ${get_diachi_kh}    ${get_khuvuc_kh}    ${get_phuongxa_kh}    Get info customer frm API    ${cell_customer_code}
    Should Be Equal    ${cell_customer_name}    ${get_ten_kh}
    Should Be Equal    ${cell_customer_phone}    ${get_dienthoai_kh}
    Should Be Equal    ${cell_customer_email}    ${Email_customer}
    Should Be Equal    ${cell_customer_address}    ${get_diachi_kh}
    Delete customer if it exists    ${cell_customer_code}

Imp_ex_customer
    [Arguments]    ${input_excel_file}    ${input_excel_name}    ${input_customer}    ${input_name}    ${input_phone}    ${input_address}
    Set Selenium Speed      1s
    ${get_customer_id}   Get customer id thr API    ${input_customer}
    Run Keyword If    '${get_customer_id}' == '0'    Log     Ignore del     ELSE    Delete customer    ${get_customer_id}
    Add customers    ${input_customer}   ${input_name}     ${input_phone}    ${input_address}
    Wait Until Keyword Succeeds    3 times    3s    Go to Khach Hang
    Wait Until Keyword Succeeds    3 times    3s    Go to select import or export    ${item_button_import}
    Wait Until Keyword Succeeds    3 times    3s    Choose File    ${button_chonfile}    ${input_excel_file}
    Wait Until Keyword Succeeds    3 times    3s    KV Click Element    ${button_uploadfile}
    Wait Until Keyword Succeeds    3 times    3s    Open Excel    ${input_excel_file}
    #${get_name_export}   Get Substring    ${input_excel_file}    53     61
    ${cell_customer_code}   Read Cell Data By Name    ${input_excel_name}    B2
    ${cell_customer_name}   Read Cell Data By Name    ${input_excel_name}    C2
    ${cell_customer_phone}   Read Cell Data By Name    ${input_excel_name}    D2
    ${cell_customer_email}   Read Cell Data By Name    ${input_excel_name}    L2
    ${cell_customer_address}   Read Cell Data By Name    ${input_excel_name}    E2
    Wait Until Element Is Visible    ${label_imp_success}    1mins
    Wait Until Keyword Succeeds    3 times    3s    Search customer    ${cell_customer_code}
    ${get_ten_kh}    ${get_dienthoai_kh}    ${get_diachi_kh}    ${get_khuvuc_kh}    ${get_phuongxa_kh}    Get info customer frm API    ${cell_customer_code}
    Should Be Equal    ${cell_customer_name}    ${get_ten_kh}
    Should Be Equal    ${cell_customer_phone}    ${get_dienthoai_kh}
    Should Be Equal    ${cell_customer_email}    ${Email_customer}
    Should Be Equal    ${cell_customer_address}    ${get_diachi_kh}
    Delete customer if it exists    ${cell_customer_code}
