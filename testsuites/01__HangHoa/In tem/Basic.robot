*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}      ${headless_browser}
Test Setup        Before Test Hang Hoa and set up folder download default
Test Teardown     After Test
Resource          ../../../core/hang_hoa/hang_hoa_add_action.robot
Resource          ../../../core/hang_hoa/hang_hoa_add_page.robot
Resource          ../../../core/share/toast_message.robot
Resource          ../../../config/env_product/envi.robot
Resource          ../../../core/hang_hoa/danh_muc_list_action.robot
Resource          ../../../prepare/Hang_hoa/Sources/hanghoa.robot
Library           ExcelRobot
Library           ExcelLibrary

*** Variables ***
${path_excel_file}       D:\\auto_download\\${env}\\{0}

*** Test Cases ***    Mã hh          Tên khổ giấy          Đường dẫn
In tem GOLIVE       [Tags]             GOLIVE2A    EP1
                    [Template]       intem1
                    NHP033         cuộn 3 nhãn      ${path_excel_file}

In tem               [Tags]
                    [Template]       intem1
                    NHP033         cuộn 3 nhãn      ${path_excel_file}
                    NHP033         cuộn 2 nhãn (Khổ giấy in nhãn 72x22mm)      ${path_excel_file}
                    NHP033         cuộn 2 nhãn (Khổ giấy in nhãn 74x22mm)      ${path_excel_file}
                    NHP033         giấy 12 nhãn     ${path_excel_file}
                    NHP033         giấy 65 nhãn      ${path_excel_file}
                    NHP033         giấy 65 nhãn     ${path_excel_file}

*** Keywords ***
intem1
    [Arguments]     ${ma_hh}    ${kho_giay}   ${input_path_excel}
    Set Selenium Speed    0.1
    Reload Page
    Search product code    ${ma_hh}
    Wait Until Keyword Succeeds    3 times    3s    Click button xem ban in    ${kho_giay}
    ${text_ma_sp}       Format String      ${text_ma_sp}    ${ma_hh}
    Wait Until Page Contains Element    ${text_ma_sp}     30s
    ${get_text_masp}    Get Text    ${text_ma_sp}
    ${get_text_giasp}    Get Text    ${text_gia_sp}
    ${get_onhand}     ${get_price}      Get Onhand and Baseprice frm API    ${ma_hh}
    ${get_text_giasp_validate}     Remove String    ${get_text_giasp}    .
    ${get_text_giasp_validate}     Remove String    ${get_text_giasp_validate}    VNĐ
    Should Be Equal As Strings    ${get_text_masp}    ${ma_hh}
    Should Be Equal As Numbers    ${get_text_giasp_validate}    ${get_price}
    Click Element     ${button_export_tem}
    Wait Until Page Contains Element    ${button_export_excel_tem}     10s
    Click Element    ${button_export_excel_tem}
    ${path}   Format String     ${input_path_excel}    MaVach.xls
    Wait Until Keyword Succeeds    3 times    2s    File Should Exist   ${path}
    Open Excel      ${path}
    ${get_gia_sp_excel}   Read Cell Data By Name    MaVach    B3
    Should Be Equal As Strings    ${get_text_giasp}    ${get_gia_sp_excel}
