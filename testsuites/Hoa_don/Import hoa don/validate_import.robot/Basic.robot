*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    ${headless_browser}
Test Setup        Before Test QL Hoa don
Test Teardown     After Test
Library           Collections
Resource          ../../../../config/env_product/envi.robot
Resource          ../../../../core/hang_hoa/hang_hoa_add_action.robot
Resource          ../../../../core/hang_hoa/danh_muc_list_action.robot
Resource          ../../../../core/Share/discount.robot
Resource          ../../../../core/Share/excel.robot
Resource          ../../../../core/Tra hang/tra_hang_action.robot
Resource          ../../../../core/Dat hang/dat_hang_action.robot
Resource          ../../../../core/Share/computation.robot
Resource          ../../../../core/API/api_danhmuc_hanghoa.robot
Resource          ../../../../core/API/api_hoadon_banhang.robot
Resource          ../../../../core/API/api_soquy.robot
Resource          ../../../../core/API/api_khachhang.robot
Resource          ../../../../core/Ban_Hang/banhang_manager_navigation.robot

*** Variables ***
${file_imp_hd3}    ${EXECDIR}${/}testsuites${/}Hoa_don${/}File_import${/}fileimei.xlsx
${file_imp_hd4}    ${EXECDIR}${/}testsuites${/}Hoa_don${/}File_import${/}filetrong.xlsx
${file_imp_hd5}    ${EXECDIR}${/}testsuites${/}Hoa_don${/}File_import${/}filethieucot.xlsx


*** Test Cases ***
Import imei
    [Tags]      IMH
    [Template]    etimhd3
    ${file_imp_hd3}

Import file rong
    [Tags]      IMH
    [Template]    etimhd4
    ${file_imp_hd4}

Import trung ma hd
    [Tags]       IMH
    [Template]    etimhd7
    ${file_imp_hd5}

*** Keywords ***
etimhd3
    [Arguments]    ${input_excel_file}
    Set Selenium Speed    0.1
    ${hex}    Generate Random String    5    [UPPER][NUMBERS]
    ${invoice_code}    Catenate    SEPARATOR=    HDIP    ${hex}
    Log     ${input_excel_file}
    ${doc_id}     Generate Random String    5    [UPPER][NUMBERS]
    Open Excel Document      ${input_excel_file}     doc_id=${doc_id}
    #
    ${get_col_num}      Update code in file excel       Mã hóa đơn     ${invoice_code}
    #
    ${list_ma_hang}     Get list value by column name in Excel       Mã hàng    ${get_col_num}
    #
    #${list_imei}    Create List
    #: FOR    ${item_product}    ${item_num}      IN ZIP    ${list_ma_hang}    ${input_list_num}
    #\    ${item_num}    Split String    ${item_num}    ,
    #\    ${imei_by_product}      Create list imei for multi row    ${item_product}    ${item_num}
    #\    Append To List    ${list_imei}    ${imei_by_product}
    #Log    ${list_imei}
    #
    #Update list value in file excel      IMEI     ${list_imei}
    Save Excel Document    ${input_excel_file}
    #
    Wait Until Keyword Succeeds    3 times    1s       Go to select import invoice
    Choose File    ${button_chonfile}    ${input_excel_file}
    Wait Until Element Is Visible    ${button_uploadfile}
    Wait Until Keyword Succeeds    3 times    3s    Click Element      ${button_uploadfile}
    Wait Until Keyword Succeeds    3 times    4s    Wait Until Element Contains    ${toast_message_import}    Hàng hóa @{list_ma_hang}[0] được quản lý theo Serial/IMEI nên cần bật thiết lập quản lý tồn kho theo Serial/IMEI và tải lại file mẫu    2 mins

etimhd4
    [Arguments]    ${input_excel_file}
    Set Selenium Speed    0.1
    Log     ${input_excel_file}
    #
    Wait Until Keyword Succeeds    3 times    1s       Go to select import invoice
    Choose File    ${button_chonfile}    ${input_excel_file}
    Wait Until Element Is Visible    ${button_uploadfile}
    Wait Until Keyword Succeeds    3 times    3s    Click Element      ${button_uploadfile}
    Wait Until Keyword Succeeds    3 times    4s     Wait Until Element Contains    ${toast_message_import}    Import file lỗi: File import không có dữ liệu     2 mins

etimhd7
    [Arguments]    ${input_excel_file}
    Set Selenium Speed    0.1
    ${invoice_code}    Generate code automatically        HDIP
    Log    ${input_excel_file}
    ${doc_id}     Generate Random String    5    [UPPER][NUMBERS]
    Open Excel Document      ${input_excel_file}     doc_id=${doc_id}
    ${get_col_num}      Update code in file excel      Mã hóa đơn     ${invoice_code}
    Save Excel Document    ${input_excel_file}
    #
    Wait Until Keyword Succeeds    3 times    1s       Go to select import invoice
    Choose File    ${button_chonfile}    ${input_excel_file}
    Wait Until Element Is Visible    ${button_uploadfile}
    Wait Until Keyword Succeeds    3 times    3s    Click Element      ${button_uploadfile}
    Wait Until Keyword Succeeds    3 times    4s   Wait Until Element Contains    ${toast_message_import}    Import thành công. Nhấn phím F5 để thấy dữ liệu mới nhất.    2 mins
    #
    Wait Until Keyword Succeeds    3 times    1s       Go to select import invoice
    Choose File    ${button_chonfile}    ${input_excel_file}
    Wait Until Element Is Visible    ${button_uploadfile}
    Wait Until Keyword Succeeds    3 times    3s    Click Element      ${button_uploadfile}
    Wait Until Keyword Succeeds    3 times    4s    Wait Until Element Contains    ${toast_message_import}    Mã hóa đơn ${invoice_code} đã tồn tại trên hệ thống     2 mins
    Delete invoice by invoice code    ${invoice_code}
