*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    F
Suite Teardown    After Test
Resource          ../../core/hang_hoa/danh_muc_list_page.robot
Resource          ../../core/hang_hoa/danh_muc_list_action.robot
Resource          ../../core/Hang_Hoa/hang_hoa_navigation.robot
Resource          ../../core/Hang_Hoa/hang_hoa_add_action.robot
Resource          ../../core/share/toast_message.robot
Resource          ../../core/share/global.robot
Resource          ../../config/env_product/envi.robot
Resource          ../../core/API/api_danhmuc_hanghoa.robot
Resource          ../../core/Ban_Hang/banhang_manager_navigation.robot
Resource          ../../prepare/Hang_hoa/Sources/hanghoa.robot
Resource          ../../core/share/discount.robot
Resource          ../../core/Giao_dich/giaodich_nav.robot
Resource          ../../core/share/excel.robot
Library           ExcelRobot
Library           ExcelLibrary
Library           SeleniumLibrary

*** Variables ***
${excel_file}           ${EXECDIR}${/}testsuites${/}Export${/}Import_file${/}Products.xlsx
${path_excel_file}      C:\\auto_download\\${env}\\{0}

*** Test Cases ***    Excel file   Product code   Proname   Category   Price   Cost   Onhand   Excel name
Import product        [Tags]            GOLIVE2   IMP   CTP
                      [Template]        import
                      [Documentation]   IMPORT - MHQL - HÀNG HÓA
                      ${excel_file}     IPHH0026   Hàng import   Dịch vụ KM   100000   0   5   Products

Export product        [Tags]               GOLIVE2   IMP   CTP
                      [Template]           export
                      [Documentation]      EXPORT - MHQL - HÀNG HÓA
                      ${path_excel_file}   IPHH0026   Hàng import   Dịch vụ KM   100000   0   5

*** Keywords ***
import
    [Arguments]    ${input_excel_file}    ${input_product}    ${input_productname}    ${input_category}    ${input_price}    ${input_cost}    ${input_onhand}    ${input_excel_name}
    Before Test and set up folder download default
    ${get_list_product}   Get product id thr API    ${input_product}
    Run Keyword If    '${get_list_product}' == '0'    Log     Ignore del     ELSE     Delete product thr API    ${input_product}
    Go To Danh Muc Hang Hoa
    Click DMHH
    Wait To Loading Icon Invisible
    Click Element Global    ${button_import}
    Wait Until Keyword Succeeds    3 times    1s    Choose File    ${button_chonfile}    ${input_excel_file}
    Click Element Global    ${button_uploadfile}
    Wait Until Keyword Succeeds    5 times    1s    Open Excel    ${input_excel_file}
    ${cell_product}   Read Cell Data By Name    ${input_excel_name}    C2
    Wait Noti Import Product Successful
    Wait Until Keyword Succeeds    3x    1 minutes    Verify Import   ${cell_product}
    Delete product thr API    ${cell_product}
    # check text

export
    [Arguments]    ${input_path_excel}    ${input_product}    ${input_productname}    ${input_category}    ${input_price}    ${input_cost}    ${input_onhand}
    ${get_product_id}   Get product id thr API    ${input_product}
    Run Keyword If    '${get_product_id}' == '0'    Log     Ignore del     ELSE     Delete product thr API    ${input_product}
    Add product thr API    ${input_product}    ${input_productname}    ${input_category}    ${input_price}    ${input_cost}    ${input_onhand}
    Go To Danh Muc Hang Hoa
    Click DMHH
    Wait To Loading Icon Invisible
    Search product code    ${input_product}
    Click Element Global   ${button_export}
    ${get_name_export_file}   Wait Until Keyword Succeeds   10x   5s   Get Text Global   ${cell_name_export_file}
    ${path}   Format String   ${input_path_excel}   ${get_name_export_file}
    ${get_name_export}   Replace String    ${get_name_export_file}   .xlsx     ${EMPTY}
    ${get_name_export}   Get Substring    ${get_name_export}    0     31
    Wait Nhấn Vào Đây Để Tải Xuống Visible
    Wait Until Keyword Succeeds   10x   10s   File Should Exist   ${path}
    Wait Until Keyword Succeeds   10x   1s   Open Excel    ${path}
    ${cell_name}   Read Cell Data    ${get_name_export}    2    1
    Should Be Equal As Strings    ${cell_name}    ${input_product}
    Delete product thr API    ${input_product}

Verify Import
    [Arguments]   ${cell_product}
    Search product code    ${cell_product}
    Page should Contain    ${cell_product}
