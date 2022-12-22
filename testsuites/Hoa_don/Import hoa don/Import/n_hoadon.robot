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
${file_imp_hd}    ${EXECDIR}${/}testsuites${/}Hoa_don${/}File_import${/}filemulti.xlsx

*** Test Cases ***
Import n hd thuong
    [Tags]      IMH
    [Template]    etimhd5
    ${file_imp_hd}

Import n hd giao hang
    [Tags]      IMH
    [Template]    etimhd6
    ${file_imp_hd}

*** Keywords ***
etimhd5
    [Document]    Import hóa đơn với kh có sẵn
    [Arguments]    ${input_excel_file}
    Set Selenium Speed    0.1
    Log    ${input_excel_file}
    ${doc_id}     Generate Random String    5    [UPPER][NUMBERS]
    Open Excel Document      ${input_excel_file}     doc_id=${doc_id}
    ${get_list_invoice}      Update multi code in file excel       Mã hóa đơn
    Save Excel Document    ${input_excel_file}
    #
    Wait Until Keyword Succeeds    3 times    1s       Go to select import invoice
    Choose File    ${button_chonfile}    ${input_excel_file}
    Wait Until Element Is Visible    ${button_uploadfile}
    Wait Until Keyword Succeeds    3 times    3s    Click Element      ${button_uploadfile}
    Wait Until Keyword Succeeds    3 times    4s        Wait Until Element Contains    ${toast_message_import}    Import thành công. Nhấn phím F5 để thấy dữ liệu mới nhất.    2 mins

etimhd6
    [Document]    Import hóa đơn với kh có sẵn
    [Arguments]    ${input_excel_file}
    Set Selenium Speed    0.1
    Log    ${input_excel_file}
    ${doc_id}     Generate Random String    5    [UPPER][NUMBERS]
    Open Excel Document      ${input_excel_file}     doc_id=${doc_id}
    ${get_list_invoice}      Update multi code in file excel       Mã hóa đơn
    Save Excel Document    ${input_excel_file}
    #
    Wait Until Keyword Succeeds    3 times    1s       Go to select import invoice
    Choose File    ${button_chonfile}    ${input_excel_file}
    Click element     //div[@id='importinvoiceform']//input[@data-label="Giao hàng"]//..//a
    Wait Until Element Is Visible    ${button_uploadfile}
    Wait Until Keyword Succeeds    3 times    3s    Click Element      ${button_uploadfile}
    Wait Until Keyword Succeeds    3 times    4s        Wait Until Element Contains    ${toast_message_import}    Import thành công. Nhấn phím F5 để thấy dữ liệu mới nhất.    2 mins
