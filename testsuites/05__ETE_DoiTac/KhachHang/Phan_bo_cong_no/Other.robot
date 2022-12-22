*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}      ${headless_browser}
Test Teardown     After Test
Resource          ../../../../config/env_product/envi.robot
Resource          ../../../../core/Doi_Tac/doitac_navigation.robot
Resource          ../../../../core/Doi_Tac/khachhang_list_action.robot
Resource          ../../../../core/Doi_Tac/khachhang_list_page.robot
Resource          ../../../../core/API/api_khachhang.robot
Resource          ../../../../core/share/toast_message.robot
Resource          ../../../../core/API/api_trahang.robot
Resource          ../../../../core/API/api_danhmuc_hanghoa.robot
Resource          ../../../../core/API/api_mhbh.robot
Resource          ../../../../core/API/api_soquy.robot
Resource          ../../../../core/Ban_Hang/banhang_navigation.robot
Resource          ../../../../core/Ban_Hang/banhang_page.robot
Resource          ../../../../prepare/Hang_hoa/Sources/doitac.robot

*** Variables ***
&{list_prs_num1}    CNKHS02=1
&{list_prs_num2}    CNKHDV02=2

*** Test Cases ***    Mã KH        Tên KH         List products invoice      Payment to invoice    Payment to invoice 1     Payment
Phieu thu_MHBH         [Tags]      UPBKH
                      [Template]    uiphanbo3
                      KHPBCN3     Khách công nợ 3      ${list_prs_num1}         850000                500000                  200000

Phieu thu_Soquy         [Tags]      UPBKH
                      [Template]    uiphanbo4
                      KHPBCN4     Khách công nợ 4      ${list_prs_num2}     Thu 2         400000                  90000

Phieu thu_khachang         [Tags]      UPBKH
                      [Template]    uiphanbo5
                      KHPBCN5     Khách công nợ 5      ${list_prs_num1}     800000                  230000

*** Keywords ***
uiphanbo3
    [Arguments]    ${input_ma_kh}    ${input_ten_kh}    ${list_product_invoice}   ${input_khtt_tocreate_invoice}   ${input_khtt_tocreate_invoice1}   ${input_thanhtoan}
    Set Selenium Speed      0.5s
    ##delete customer
    ${get_customer_id}    Get customer id thr API    ${input_ma_kh}
    Run Keyword If    '${get_customer_id}' == '0'    Log    Ignore delete     ELSE      Delete customer    ${get_customer_id}
    Sleep    1s
    ## create customer
    ${date_current}   Get Current Date      result_format=%Y-%m-%d
    Add customer with birthday    ${input_ma_kh}    ${input_ten_kh}    ${date_current}
    Sleep    2s
    ${ma_hd}    Add new invoice - payment allocation frm API    ${input_ma_kh}    ${list_product_invoice}    ${input_khtt_tocreate_invoice}
    ${ma_hd1}    Add new invoice - payment allocation frm API    ${input_ma_kh}    ${list_product_invoice}    ${input_khtt_tocreate_invoice1}
    ${get_khachcantra}    ${get_khachthanhtoan}   Get paid value from invoice api    ${ma_hd}
    ${get_khachcantra1}    ${get_khachthanhtoan1}   Get paid value from invoice api    ${ma_hd1}
    ${get_no_bf_execute}    ${get_tongban_bf_execute}    ${get_tongban_tru_trahang_bf_execute}    ${get_customer_name}    Get Customer Info from API    ${input_ma_kh}
    ##compute cong no khac hang
    ${result_khachno}    Minus and replace floating point    ${get_khachcantra}    ${get_khachthanhtoan}
    ${result_khachno1}    Minus and replace floating point    ${get_khachcantra1}    ${get_khachthanhtoan1}
    ${result_phanbo_hoadon}  Run Keyword If    ${result_khachno} < ${input_thanhtoan}    Set Variable    ${result_khachno}    ELSE     Minus and replace floating point    ${input_thanhtoan}       ${result_khachno}
    ${result_phanbo_hoadon1}   Minus and replace floating point    ${input_thanhtoan}       ${result_phanbo_hoadon}
    ${result_khtt}    Minus and replace floating point    ${input_thanhtoan}    ${result_phanbo_hoadon}
    ${result_khachdatra}    Sum    ${result_phanbo_hoadon}     ${input_khtt_tocreate_invoice}
    ${result_khachdatra1}    Sum    ${result_phanbo_hoadon1}     ${input_khtt_tocreate_invoice1}
    ##du no khach hang
    ${result_du_no_hd_KH}    Minus    ${get_no_bf_execute}    ${input_thanhtoan}
    #create invoice frm Order API
    Wait Until Keyword Succeeds    3 times    8 s    Before Test Ban Hang
    Go to Lap phieu thu
    Wait Until Keyword Succeeds    3 times    8 s    Input data    ${textbox_searchcustomer_phieuthu_mhbh}       ${input_ma_kh}
    Wait Until Keyword Succeeds    3 times    8 s    Input data    ${textbox_thutukhach}       ${input_thanhtoan}
    Wait Until Page Contains Element    ${button_taophieuthu}    1 min
    Click Element JS    ${button_taophieuthu}
    Sleep    20 s    wait for response to API
    ##validate invoice allocate
    ${payment_code}   Get payment code in customer debt    ${input_ma_kh}
    ${get_khachtt_af_allocate}    ${get_ptt_af_allocate}    Get invoice info after allocate     ${ma_hd}    ${payment_code}
    Should Be Equal As Numbers    ${get_khachtt_af_allocate}    ${result_khachdatra}
    Should Be Equal As Numbers    ${get_ptt_af_allocate}    ${result_phanbo_hoadon}
    ##validate invoice allocate
    ${get_khachtt_af_allocate1}    ${get_ptt_af_allocate1}    Get invoice info after allocate     ${ma_hd1}    ${payment_code}
    Should Be Equal As Numbers    ${get_khachtt_af_allocate1}    ${result_khachdatra1}
    Should Be Equal As Numbers    ${get_ptt_af_allocate1}    ${result_phanbo_hoadon1}
    #assert customer and so quy
    ${get_no_af_execute_kh}    ${get_tongban_af_execute_kh}    ${get_tongban_tru_trahang_af_execute_kh}    Get Customer Debt from API    ${input_ma_kh}
    Should Be Equal As Numbers    ${get_no_af_execute_kh}    ${result_du_no_hd_KH}
    Should Be Equal As Numbers    ${get_tongban_af_execute_kh}    ${get_tongban_bf_execute}
    Delete invoice by invoice code    ${ma_hd}
    Delete invoice by invoice code    ${ma_hd1}
    ${get_customer_id}    Get Customer ID    ${input_ma_kh}
    Delete customer    ${get_customer_id}

uiphanbo4
    [Arguments]    ${input_ma_kh}    ${input_ten_kh}    ${list_product_invoice}    ${input_loai_thuchi}   ${input_khtt_tocreate_invoice}   ${input_thanhtoan}
    Set Selenium Speed      0.5s
    ##delete customer
    ${get_customer_id}    Get customer id thr API    ${input_ma_kh}
    Run Keyword If    '${get_customer_id}' == '0'    Log    Ignore delete     ELSE      Delete customer    ${get_customer_id}
    Sleep    1s
    ## create customer
    ${date_current}   Get Current Date      result_format=%Y-%m-%d
    Add customer with birthday    ${input_ma_kh}    ${input_ten_kh}    ${date_current}
    Sleep    2s
    ${ma_hd}    Add new invoice - payment allocation frm API    ${input_ma_kh}    ${list_product_invoice}    ${input_khtt_tocreate_invoice}
    ${get_khachcantra}    ${get_khachthanhtoan}   Get paid value from invoice api    ${ma_hd}
    ${get_no_bf_execute}    ${get_tongban_bf_execute}    ${get_tongban_tru_trahang_bf_execute}    ${get_customer_name}    Get Customer Info from API    ${input_ma_kh}
    ##compute cong no khac hang
    ${result_khachno}    Minus and replace floating point    ${get_khachcantra}    ${get_khachthanhtoan}
    ${result_khachdatra}    Sum    ${input_thanhtoan}     ${input_khtt_tocreate_invoice}
    ##du no khach hang
    ${result_du_no_hd_KH}    Minus    ${get_no_bf_execute}    ${input_thanhtoan}
    #create invoice frm Order API
    ${payment_code}    Generate code automatically    TTM
    Wait Until Keyword Succeeds    3 times    8 s    Before Test So Quy
    Click Element     ${button_lap_phieu_thu}
    Input data in form Lap phieu thu chi (Tien mat)    ${payment_code}    Khách hàng    ${input_ma_kh}    ${input_loai_thuchi}    ${input_thanhtoan}    0
    Click Element    ${button_sq_luu}
    Sleep    20 s    wait for response to API
    ##validate invoice allocate
    ${get_khachtt_af_allocate}    ${get_ptt_af_allocate}    Get invoice info after allocate     ${ma_hd}    ${payment_code}
    Should Be Equal As Numbers    ${get_khachtt_af_allocate}    ${result_khachdatra}
    Should Be Equal As Numbers    ${get_ptt_af_allocate}    ${input_thanhtoan}
    #assert customer and so quy
    ${get_no_af_execute_kh}    ${get_tongban_af_execute_kh}    ${get_tongban_tru_trahang_af_execute_kh}    Get Customer Debt from API    ${input_ma_kh}
    Should Be Equal As Numbers    ${get_no_af_execute_kh}    ${result_du_no_hd_KH}
    Should Be Equal As Numbers    ${get_tongban_af_execute_kh}    ${get_tongban_bf_execute}
    Delete invoice by invoice code    ${ma_hd}
    ${get_customer_id}    Get Customer ID    ${input_ma_kh}
    Delete customer    ${get_customer_id}

uiphanbo5
    [Arguments]    ${input_ma_kh}    ${input_ten_kh}    ${list_product_invoice}   ${input_khtt_tocreate_invoice}   ${input_thanhtoan}
    Set Selenium Speed      0.5s
    ##delete customer
    ${get_customer_id}    Get customer id thr API    ${input_ma_kh}
    Run Keyword If    '${get_customer_id}' == '0'    Log    Ignore delete     ELSE      Delete customer    ${get_customer_id}
    Sleep    1s
    ## create customer
    ${date_current}   Get Current Date      result_format=%Y-%m-%d
    Add customer with birthday    ${input_ma_kh}    ${input_ten_kh}    ${date_current}
    Sleep    2s
    ${ma_hd}    Add new invoice - payment allocation frm API    ${input_ma_kh}    ${list_product_invoice}    ${input_khtt_tocreate_invoice}
    ${get_khachcantra}    ${get_khachthanhtoan}   Get paid value from invoice api    ${ma_hd}
    ${get_no_bf_execute}    ${get_tongban_bf_execute}    ${get_tongban_tru_trahang_bf_execute}    ${get_customer_name}    Get Customer Info from API    ${input_ma_kh}
    ##compute cong no khac hang
    ${result_khachno}    Minus and replace floating point    ${get_khachcantra}    ${get_khachthanhtoan}
    ${result_khachdatra}    Sum    ${result_khachno}     ${input_khtt_tocreate_invoice}
    ##du no khach hang
    ${result_du_no_hd_KH}    Minus    ${get_no_bf_execute}    ${input_thanhtoan}
    #create invoice frm Order API
    Wait Until Keyword Succeeds    3 times    8 s    Before Test Doi Tac Khach Hang
    Search customer and go to tab No can thu tu khach    ${input_ma_kh}
    Wait Until Page Contains Element    ${button_thanhtoan_congno}
    Click Element JS    ${button_thanhtoan_congno}
    Wait Until Element Is Visible    ${textbox_thu_tu_khach_in_customer}    10s
    Input data      ${textbox_thu_tu_khach_in_customer}    ${input_thanhtoan}
    Click Element     ${button_tao_phieu_thu_in_customer}
    Sleep    20 s    wait for response to API
    ##validate invoice allocate
    ${payment_code}   Get payment code in customer debt    ${input_ma_kh}
    ${get_khachtt_af_allocate}    ${get_ptt_af_allocate}    Get invoice info after allocate     ${ma_hd}    ${payment_code}
    Should Be Equal As Numbers    ${get_khachtt_af_allocate}    ${result_khachdatra}
    Should Be Equal As Numbers    ${get_ptt_af_allocate}    ${result_khachno}
    #assert customer and so quy
    ${get_no_af_execute_kh}    ${get_tongban_af_execute_kh}    ${get_tongban_tru_trahang_af_execute_kh}    Get Customer Debt from API    ${input_ma_kh}
    Should Be Equal As Numbers    ${get_no_af_execute_kh}    ${result_du_no_hd_KH}
    Should Be Equal As Numbers    ${get_tongban_af_execute_kh}    ${get_tongban_bf_execute}
    Delete invoice by invoice code    ${ma_hd}
    Delete payment created customer debt    ${payment_code}
    ${get_customer_id}    Get Customer ID    ${input_ma_kh}
    Delete customer    ${get_customer_id}
