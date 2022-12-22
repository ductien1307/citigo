*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}      ${headless_browser}
Test Setup        Before Test and set up folder download default
Test Teardown     After Test
Resource          ../../../core/Giao_dich/giaodich_nav.robot
Resource          ../../../config/env_product/envi.robot
Resource          ../../../core/Ban_Hang/banhang_action.robot
Resource          ../../../core/Ban_Hang/banhang_getandcompute.robot
Resource          ../../../core/Ban_Hang/banhang_manager_navigation.robot
Resource          ../../../core/Bao_mat_khach_hang/Bao_mat_KH_nav.robot
Resource          ../../../core/Bao_mat_khach_hang/Bao_mat_KH_action.robot
Resource          ../../../core/API/api_danhmuc_hanghoa.robot
Resource          ../../../core/API/api_hoadon_banhang.robot
Resource          ../../../core/API/api_khachhang.robot
Resource          ../../../core/API/api_mhbh.robot
Resource          ../../../core/Giao_dich/hoa_don_list_action.robot
Resource          ../../../core/share/excel.robot
Library           Collections

*** Variables ***
${path_excel_file}       C:\\auto_download\\${env}\\{0}
&{dict_product_num}       NHMT002=1
&{dict_customer}     KHA001=1     KHB002=2    KHC003=3     KHD004=4
*** Test Cases ***    Mã kh             Đường dẫn
Export all invoice
                    [Tags]         KYC4
                    [Documentation]    null la export tong quan, detail la export chi tiet hoa don
                    [Template]     export hoa don
                    ${dict_customer}        ${path_excel_file}    ${dict_product_num}     100000      null
                    ${dict_customer}        ${path_excel_file}    ${dict_product_num}     200000      detail

Choose and export invoice
                    [Tags]         KYC4
                    [Documentation]    chon invoice de export. null la export tong quan, detail la export chi tiet hoa don
                    [Template]     export hoa don 2
                    ${dict_customer}        ${path_excel_file}    ${dict_product_num}     100000      null
                    ${dict_customer}        ${path_excel_file}    ${dict_product_num}     200000      detail

Choose and export invoice
                    [Tags]         KYC4
                    [Documentation]      export khách hàng, null là không chọn, detail là có chọn khách hàng để export
                    [Template]     export customer
                    ${dict_customer}        ${path_excel_file}    null
                    ${dict_customer}        ${path_excel_file}    detail

*** Keywords ***
export hoa don
    [Arguments]      ${dict_customer}    ${input_path_excel}    ${dict_product}   ${input_khtt}   ${input_status}
    Set Selenium Speed    0.1
    Go to Hoa don
    ${list_customer_code}    Get Dictionary Keys    ${dict_customer}
    ${list_invoice_code}    Create List
    ${list_customer_name}    Create List
    ${list_customer_email}    Create List
    ${list_customer_phone}    Create List
    ${list_customer_address}    Create List
    :FOR    ${customer_code}     IN ZIP    ${list_customer_code}
    \    ${get_id_kh}    ${get_ten_kh}    ${get_dienthoai_kh}    ${get_diachi_kh}    Create new customer and get info    ${customer_code}
    \    ${invoice_code}   Add new invoice frm API    ${customer_code}    ${dict_product}   ${input_khtt}
    \    Append To List    ${list_invoice_code}    ${invoice_code}
    \    Append To List    ${list_customer_name}    ${get_ten_kh}
    \    Append To List    ${list_customer_email}    ${Email_customer}
    \    Append To List    ${list_customer_phone}    ${get_dienthoai_kh}
    \    Append To List    ${list_customer_address}    ${get_diachi_kh}
    Log    ${list_invoice_code}
    Log    ${list_customer_code}
    :FOR     ${invoice_code}    IN ZIP     ${list_invoice_code}
    \    Wait Until Keyword Succeeds    3 times    3s    Search code frm manager    ${invoice_code}
    #action thêm cột thông tin trước khi export
    Run Keyword If    '${input_status}'=='null'    Add column email phone and address to export file
    #get thong tin kkhách hàng
    Reload Page
    Wait Until Keyword Succeeds    3 times    4s    Run Keyword If    '${input_status}'=='null'     Go to select export file    ${item_button_export_invoice}   ${invoice_code}   ELSE    Go to select export file    ${item_button_export_detail_inv}    ${invoice_code}
    Sleep    5s
    :FOR    ${time}     IN RANGE    20
    \     ${get_name_export_file}   KV Get text    ${cell_name_export_file}
    \     Exit For Loop If    '${get_name_export_file}'!='0'
    ${path}   Format String     ${input_path_excel}    ${get_name_export_file}
    ${get_name_export}   Replace String    ${get_name_export_file}   .xlsx     ${EMPTY}
    ${get_name_export}   Get Substring    ${get_name_export}    0     31
    Wait Until Keyword Succeeds    3 times    2s    File Should Exist   ${path}
    Wait Until Keyword Succeeds    3 times    3s    Open Excel    ${path}
    ${cell_inv}    Run Keyword If    '${input_status}'=='null'    Set Variable    A{0}    ELSE    Set Variable    B{0}
    ${cell_name}    Run Keyword If    '${input_status}'=='null'    Set Variable    D{0}    ELSE    Set Variable    N{0}
    ${cell_email}    Run Keyword If    '${input_status}'=='null'    Set Variable    E{0}    ELSE    Set Variable    O{0}
    ${cell_phone}    Run Keyword If    '${input_status}'=='null'    Set Variable    F{0}    ELSE    Set Variable    P{0}
    ${cell_address}    Run Keyword If    '${input_status}'=='null'    Set Variable    G{0}    ELSE    Set Variable    Q{0}
    ${number_in_detail}    Set Variable    5
    :FOR    ${invoice_code}    ${get_ten_kh}    ${email_kh}     ${get_dienthoai_kh}    ${get_diachi_kh}    IN ZIP
    ...    ${list_invoice_code}    ${list_customer_name}     ${list_customer_email}    ${list_customer_phone}    ${list_customer_address}
    \    ${index}    Get Index From List    ${list_invoice_code}    ${invoice_code}
    \    ${excel_inv}    ${excel_name}    ${excel_email}     ${excel_phone}    ${excel_address}    Set row and column in excel    ${number_in_detail}    ${index}     ${cell_inv}    ${cell_name}    ${cell_email}    ${cell_phone}    ${cell_address}
    \    ${cell_invoice}              Read Cell Data By Name    ${get_name_export}    ${excel_inv}
    \    ${cell_customer_name}        Read Cell Data By Name    ${get_name_export}    ${excel_name}
    \    ${cell_customer_email}       Read Cell Data By Name    ${get_name_export}    ${excel_email}
    \    ${cell_customer_phone}       Read Cell Data By Name    ${get_name_export}    ${excel_phone}
    \    ${cell_customer_address}     Read Cell Data By Name    ${get_name_export}    ${excel_address}
    \    Should Be Equal As Strings    ${cell_invoice}             ${invoice_code}
    \    Should Be Equal As Strings    ${cell_customer_name}       ${get_ten_kh}
    \    Should Be Equal As Strings    ${cell_customer_email}      ${email_kh}
    \    Should Be Equal As Strings    ${cell_customer_phone}      ${get_dienthoai_kh}
    \    Should Be Equal As Strings    ${cell_customer_address}    ${get_diachi_kh}
    \    Delete invoice by invoice code    ${invoice_code}
    :FOR    ${customer_code}     IN ZIP    ${list_customer_code}
    \    Wait Until Keyword Succeeds    3 times    3s    Delete customer if it exists    ${customer_code}

export hoa don 2
    [Arguments]      ${dict_customer}    ${input_path_excel}    ${dict_product}   ${input_khtt}   ${input_status}
    Set Selenium Speed    0.1
    Go to Hoa don
    ${list_customer_code}    Get Dictionary Keys    ${dict_customer}
    ${list_invoice_code}    Create List
    ${list_customer_name}    Create List
    ${list_customer_email}    Create List
    ${list_customer_phone}    Create List
    ${list_customer_address}    Create List
    :FOR    ${customer_code}     IN ZIP    ${list_customer_code}
    \    ${get_id_kh}    ${get_ten_kh}    ${get_dienthoai_kh}    ${get_diachi_kh}    Create new customer and get info    ${customer_code}
    \    ${invoice_code}   Add new invoice frm API    ${customer_code}    ${dict_product}   ${input_khtt}
    \    Append To List    ${list_invoice_code}    ${invoice_code}
    \    Append To List    ${list_customer_name}    ${get_ten_kh}
    \    Append To List    ${list_customer_email}    ${Email_customer}
    \    Append To List    ${list_customer_phone}    ${get_dienthoai_kh}
    \    Append To List    ${list_customer_address}    ${get_diachi_kh}
    Log    ${list_invoice_code}
    Log    ${list_customer_code}
    #action thêm cột thông tin trước khi export
    Run Keyword If    '${input_status}'=='null'    Add column email phone and address to export file
    #get thong tin kkhách hàng
    Reload Page
    :FOR     ${invoice_code}    IN ZIP     ${list_invoice_code}
    \    Wait Until Keyword Succeeds    3 times    3s    Search invoice code and select invoice    ${invoice_code}
    Wait Until Keyword Succeeds    3 times    4s    Run Keyword If    '${input_status}'=='null'     Go to select export multiple   ELSE    Go to select export detail multiple
    Sleep    5s
    :FOR    ${time}     IN RANGE    20
    \     ${get_name_export_file}   KV Get text    ${cell_name_export_file}
    \     Exit For Loop If    '${get_name_export_file}'!='0'
    ${path}   Format String     ${input_path_excel}    ${get_name_export_file}
    ${get_name_export}   Replace String    ${get_name_export_file}   .xlsx     ${EMPTY}
    ${get_name_export}   Get Substring    ${get_name_export}    0     31
    Wait Until Keyword Succeeds    3 times    2s    File Should Exist   ${path}
    Wait Until Keyword Succeeds    3 times    3s    Open Excel    ${path}
    ${cell_inv}    Run Keyword If    '${input_status}'=='null'    Set Variable    A{0}    ELSE    Set Variable    B{0}
    ${cell_name}    Run Keyword If    '${input_status}'=='null'    Set Variable    D{0}    ELSE    Set Variable    N{0}
    ${cell_email}    Run Keyword If    '${input_status}'=='null'    Set Variable    E{0}    ELSE    Set Variable    O{0}
    ${cell_phone}    Run Keyword If    '${input_status}'=='null'    Set Variable    F{0}    ELSE    Set Variable    P{0}
    ${cell_address}    Run Keyword If    '${input_status}'=='null'    Set Variable    G{0}    ELSE    Set Variable    Q{0}
    ${number_in_detail}    Set Variable    5
    :FOR    ${invoice_code}    ${get_ten_kh}    ${email_kh}     ${get_dienthoai_kh}    ${get_diachi_kh}    IN ZIP
    ...    ${list_invoice_code}    ${list_customer_name}     ${list_customer_email}    ${list_customer_phone}    ${list_customer_address}
    \    ${index}    Get Index From List    ${list_invoice_code}    ${invoice_code}
    \    ${excel_inv}    ${excel_name}    ${excel_email}     ${excel_phone}    ${excel_address}    Set row and column in excel    ${number_in_detail}    ${index}     ${cell_inv}    ${cell_name}    ${cell_email}    ${cell_phone}    ${cell_address}
    \    ${cell_invoice}              Read Cell Data By Name    ${get_name_export}    ${excel_inv}
    \    ${cell_customer_name}        Read Cell Data By Name    ${get_name_export}    ${excel_name}
    \    ${cell_customer_email}       Read Cell Data By Name    ${get_name_export}    ${excel_email}
    \    ${cell_customer_phone}       Read Cell Data By Name    ${get_name_export}    ${excel_phone}
    \    ${cell_customer_address}     Read Cell Data By Name    ${get_name_export}    ${excel_address}
    \    Should Be Equal As Strings    ${cell_invoice}             ${invoice_code}
    \    Should Be Equal As Strings    ${cell_customer_name}       ${get_ten_kh}
    \    Should Be Equal As Strings    ${cell_customer_email}      ${email_kh}
    \    Should Be Equal As Strings    ${cell_customer_phone}      ${get_dienthoai_kh}
    \    Should Be Equal As Strings    ${cell_customer_address}    ${get_diachi_kh}
    \    Delete invoice by invoice code    ${invoice_code}
    :FOR    ${customer_code}     IN ZIP    ${list_customer_code}
    \    Wait Until Keyword Succeeds    3 times    3s    Delete customer if it exists    ${customer_code}


export customer
    [Arguments]     ${dict_customer}    ${input_path_excel}    ${input_status}
    Set Selenium Speed      1s
    ${list_customer_code}    Get Dictionary Keys    ${dict_customer}
    ${list_customer_name}    Create List
    ${list_customer_email}    Create List
    ${list_customer_phone}    Create List
    ${list_customer_address}    Create List
    :FOR    ${customer_code}     IN ZIP    ${list_customer_code}
    \    ${get_id_kh}    ${get_ten_kh}    ${get_dienthoai_kh}    ${get_diachi_kh}    Create new customer and get info    ${customer_code}
    \    Append To List    ${list_customer_name}    ${get_ten_kh}
    \    Append To List    ${list_customer_email}    ${Email_customer}
    \    Append To List    ${list_customer_phone}    ${get_dienthoai_kh}
    \    Append To List    ${list_customer_address}    ${get_diachi_kh}
    Log    ${list_customer_code}
    Wait Until Keyword Succeeds    3 times    3s    Go to Khach Hang
    #Wait Until Keyword Succeeds    3 times    3s    Search customer    ${input_customer}
    :FOR     ${customer_code}    IN ZIP     ${list_customer_code}
    #\    Wait Until Keyword Succeeds    3 times    3s    Search customer    ${customer_code}
    \    Exit For Loop If    '${input_status}'=='null'
    \    Wait Until Keyword Succeeds    3 times    3s    Search customer code and select customer    ${customer_code}
    Run Keyword If    '${input_status}'=='null'    Wait Until Keyword Succeeds    3 times    3s    Go to select import or export    ${item_button_export}    ELSE    Wait Until Keyword Succeeds    3 times    3s    Go to select export customer
    Sleep    5s
    :FOR    ${time}     IN RANGE    20
    \     ${get_name_export_file}   KV Get text    ${cell_name_export_file}
    \     Exit For Loop If    '${get_name_export_file}'!='0'
    ${path}   Format String     ${input_path_excel}    ${get_name_export_file}
    ${get_name_export}   Replace String    ${get_name_export_file}   .xlsx     ${EMPTY}
    ${get_name_export}   Get Substring    ${get_name_export}    0     31
    Wait Until Keyword Succeeds    3 times    2s    File Should Exist   ${path}
    Wait Until Keyword Succeeds    3 times    3s     Open Excel    ${path}
    ${cell_code}    Set Variable    C{0}
    ${cell_name}    Set Variable    D{0}
    ${cell_email}    Set Variable    M{0}
    ${cell_phone}    Set Variable    E{0}
    ${cell_address}    Set Variable    F{0}
    #t
    ${number_in_detail}    Set Variable    5
    :FOR    ${get_ma_kh}    ${get_ten_kh}    ${email_kh}     ${get_dienthoai_kh}    ${get_diachi_kh}    IN ZIP
    ...    ${list_customer_code}    ${list_customer_name}     ${list_customer_email}    ${list_customer_phone}    ${list_customer_address}
    \    ${index}    Get Index From List    ${list_customer_code}    ${get_ma_kh}
    #\    ${index1}    Run Keyword If    ${index}==0    Set Variable    3     ELSE    Run Keyword If    ${index}==1    Set Variable    0     ELSE    Run Keyword If    ${index}==2    Set Variable    1     ELSE    Set Variable    2
    \    ${excel_code}     ${excel_name}    ${excel_email}     ${excel_phone}    ${excel_address}    Set row and column in excel    ${number_in_detail}    ${index}    ${cell_code}    ${cell_name}    ${cell_email}    ${cell_phone}    ${cell_address}
    \    ${cell_customer_code}        Read Cell Data By Name    ${get_name_export}    ${excel_code}
    \    ${cell_customer_name}        Read Cell Data By Name    ${get_name_export}    ${excel_name}
    \    ${cell_customer_email}       Read Cell Data By Name    ${get_name_export}    ${excel_email}
    \    ${cell_customer_phone}       Read Cell Data By Name    ${get_name_export}    ${excel_phone}
    \    ${cell_customer_address}     Read Cell Data By Name    ${get_name_export}    ${excel_address}
    \    Should Be Equal As Strings    ${cell_customer_code}       ${get_ma_kh}
    \    Should Be Equal As Strings    ${cell_customer_name}       ${get_ten_kh}
    \    Should Be Equal As Strings    ${cell_customer_email}      ${email_kh}
    \    Should Be Equal As Strings    ${cell_customer_phone}      ${get_dienthoai_kh}
    \    Should Be Equal As Strings    ${cell_customer_address}    ${get_diachi_kh}
    \    Wait Until Keyword Succeeds    3 times    3s    Delete customer if it exists    ${customer_code}
