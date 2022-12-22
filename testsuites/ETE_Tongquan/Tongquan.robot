*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    ${headless_browser}
Library           String
Library           DateTime
Library           Collections
Resource          ../../core/API/api_hoadon_banhang.robot
Resource          ../../core/API/api_trahang.robot
Resource          ../../config/env_product/envi.robot
Resource          ../../core/API/api_tongquan.robot
Resource          ../../core/API/api_khachhang.robot
Resource          ../../core/API/api_mhbh.robot
Resource          ../../core/Bao_cao/bc_list_page.robot
Resource          ../../core/Bao_cao/bc_hang_hoa_list_action.robot
Resource          ../../prepare/Hang_hoa/Sources/doitac.robot
Resource          ../../core/API/api_danhmuc_hanghoa.robot

*** Variables ***
&{dict_product_num}       HHTK01=5

*** Test Cases ***    List product          Payment
Result sale           [Tags]      TQ
                      [Template]    result_sale
                      ${dict_product_num}    100000

Top 10 product best sale           [Tags]      TQ
                [Template]    top10
                1

Birthday          [Tags]      TQ
                [Template]    birthday
                CTKHTQ01      Hoàng Phi Hồng

Recent active           [Tags]      TQ
                      [Template]    result_sale
                      ${dict_product_num}    10000

*** Keywords ***
result_sale
    [Arguments]    ${dic_product_nums}    ${input_khtt}
    ${invoice_code}   Add new invoice without customer thr API    ${dic_product_nums}    ${input_khtt}
    ${return_code}   Add new return without customer    ${dic_product_nums}    ${input_khtt}
    Sleep    5s
    ${get_list_invoice}    ${get_summary_invoice}   Get list invoice by current date
    ${get_list_return}    ${get_summary_retunr}   Get list return by current date
    ${get_result_invoice_dashboard_bf_ex}    ${get_result_inv_nums_dashboard_bf_ex}     Get result sale dashboard    ${endpoint_result_sale_dashboard}
    ${get_result_return_dashboard_bf_ex}    ${get_result_return_nums_dashboard_bf_ex}     Get result sale dashboard    ${endpoint_result_return_dashboard}
    ${get_nums_invoice}   Get Length    ${get_list_invoice}
    ${get_nums_return}   Get Length    ${get_list_return}
    Should Be Equal As Numbers    ${get_result_invoice_dashboard_bf_ex}    ${get_summary_invoice}
    Should Be Equal As Numbers    ${get_result_return_dashboard_bf_ex}    ${get_summary_retunr}
    Should Be Equal As Numbers    ${get_result_inv_nums_dashboard_bf_ex}    ${get_nums_invoice}
    Should Be Equal As Numbers    ${get_result_return_nums_dashboard_bf_ex}    ${get_nums_return}
    Delete invoice by invoice code    ${invoice_code}
    Delete return thr API    ${return_code}

top10
    [Arguments]    ${item}
    Before Test BC Hang Hoa
    Wait Until Element Is Visible    ${checkbox_bao_cao}    2 min
    Click Element      ${checkbox_bao_cao}
    Go to product report filter month
    ${get_nums_hh_in_bc}    Get Text    ${label_soluong_mathang}
    ${get_nums_hh_in_bc}    Convert To String    ${get_nums_hh_in_bc}
    ${get_nums_hh_in_bc}    Replace String    ${get_nums_hh_in_bc}    SL mặt hàng:     ${EMPTY}
    ${get_nums}   Set Variable If    ${get_nums_hh_in_bc} > 10    10    ${get_nums_hh_in_bc}
    ${list_product}   Create List
    ${index}    Set Variable    0
    : FOR    ${item}    IN RANGE    ${get_nums}
    \    ${index}    Evaluate    ${index} + 1
    \    ${cell_code_product}   Format String     ${cell_product_in_table_report}    ${index}
    \    ${product_code}    Get Text    ${cell_code_product}
    \    Append To List    ${list_product}    ${product_code}
    Log    ${list_product}
    ${get_list_product_top10}   Get top 10 product in dashboard
    :FOR    ${item_product}    ${item_product_top}    IN ZIP    ${list_product}    ${get_list_product_top10}
    \       Should Be Equal As Strings    ${item_product}    ${item_product_top}
    After Test

birthday
    [Arguments]    ${input_ma_kh}    ${input_ten_kh}
    ${date_current}   Get Current Date      result_format=%Y-%m-%d
    ${get_customer_id}    Get customer id thr API    ${input_ma_kh}
    Run Keyword If    '${get_customer_id}' == '0'    Log    Ignore delete     ELSE      Delete customer    ${get_customer_id}
    Add customer with birthday     ${input_ma_kh}    ${input_ten_kh}    ${date_current}
    Sleep    5s
    ${get_list_customer_frm_dashboard}    Get list customer from birthday dashboard
    List Should Contain Value    ${get_list_customer_frm_dashboard}    ${input_ma_kh}
    ${get_customer_id}    Get Customer ID    ${input_ma_kh}
    Delete customer    ${get_customer_id}

recent_active
    [Arguments]    ${dic_product_nums}    ${input_khtt}
    ${list_product}   Get Dictionary Keys    ${dic_product_nums}
    ${list_nums}   Get Dictionary Values    ${dic_product_nums}
    ${invoice_code}   Add new invoice without customer thr API    ${dic_product_nums}    ${input_khtt}
    ${get_list_baseprice}   Get list of Baseprice by Product Code    ${list_product}
    ${list_thanhtien}     Create List
    :FOR      ${cost}     ${nums}      IN ZIP    ${get_list_baseprice}     ${list_nums}
    \       ${result_thanhtien}   Multiplication with price round 2    ${cost}     ${nums}
    \       Append To List    ${list_thanhtien}    ${result_thanhtien}
    ${tongtienhang}     Sum values in list    ${list_thanhtien}
    ${tongtienhang}     Replace floating point    ${tongtienhang}
    Before Test Quan ly
    ## validate tong quan
    ${get_name}   Get name of user    ${USER_NAME}
    ${text_giatri}     Format String      với giá trị {0}    ${tongtienhang}
    ${cell_text_username}     Format String      ${cell_text_username}    Invoices    ${invoice_code}
    ${cell_text_active}     Format String      ${cell_text_active}    Invoices
    ${cell_text_huy}     Format String      ${cell_text_huy_giaodich}    Invoices   ${invoice_code}
    ${cell_text_giatri}     Format String      ${cell_text_giatri}    Invoices    ${invoice_code}
    Delete invoice by invoice code    ${invoice_code}
    After Test
