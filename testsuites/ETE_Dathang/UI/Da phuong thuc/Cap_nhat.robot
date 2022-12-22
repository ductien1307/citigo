*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    ${headless_browser}
Test Teardown     After Test
Resource          ../../../../core/API/api_danhmuc_hanghoa.robot
Resource          ../../../../core/API/api_dathang.robot
Resource          ../../../../core/API/api_khachhang.robot
Resource          ../../../../core/API/api_mhbh.robot
Resource          ../../../../core/API/api_mhbh_dathang.robot
Resource          ../../../../core/Dat_Hang/dat_hang_action.robot
Resource          ../../../../core/Dat_Hang/dat_hang_navigation.robot
Resource          ../../../../core/Dat_Hang/dat_hang_page.robot
Resource          ../../../../core/share/toast_message.robot
Resource          ../../../../core/API/api_soquy.robot
Resource          ../../../../config/env_product/envi.robot
Library           Collections

*** Variables ***
&{list_product}     KLCB017=7    KLT0017=3.7    KLQD017=5    KLDV017=3    KLSI0017=3
@{list_discount}    10    2000.5    15    4000    20    85000

*** Test Cases ***    Mã khách hàng    List product&nums     List GGSP           GGDH     Khách thanh toán    PHương thức 1    Số tài khoản 1    Khách thanh toán 2    Phương thức 2    Số tài khoản 2    Ghi chú
Basic                 [Tags]           DHDPT
                      [Template]       edhpt02
                      DHDPT002          ${list_product}    ${list_discount}      15000     500000              Thẻ              1234              30000                 Chuyển khoản     2134              Đã đặt cọc

*** Keywords ***
edhpt02
    [Arguments]    ${input_ma_kh}    ${dict_product_nums}    ${list_ggsp}    ${input_ggdh}    ${input_khtt}    ${phuong_thuc}
    ...    ${so_tai_khoan}    ${input_khtt2}    ${phuong_thuc2}    ${so_tai_khoan2}    ${input_ghichu}
    #get info product, customer
    ${order_code}    Add new order incase discount - method payment and return order code    ${input_ma_kh}    ${input_ggdh}    ${dict_product_nums}    ${list_ggsp}    ${input_khtt}
    ...    ${phuong_thuc}    ${so_tai_khoan}
    ${list_product}    Get Dictionary Keys    ${dict_product_nums}
    ${list_nums}    Get Dictionary Values    ${dict_product_nums}
    ${get_khachdatra_in_dh_bf_execute}    ${get_tongtienhang_in_dh_bf_execute}    Get paid value frm API    ${order_code}
    ${get_no_bf_execute}    ${get_tongban_bf_execute}    ${get_tongban_tru_trahang_bf_execute}    Get Customer Debt from API    ${input_ma_kh}
    #get value to Validate
    ${list_result_thanhtien}    ${list_result_order_summary}    ${list_newprice}    Get list total sale - order summary - newprice incase discount    ${list_product}    ${list_nums}    ${list_ggsp}
    #compute
    ${result_tongtienhang}    Sum values in list and round    ${list_result_thanhtien}
    ${result_ggdh}    Run Keyword If    0 < ${input_ggdh} < 100    Convert % discount to VND and round    ${result_tongtienhang}    ${input_ggdh}
    ...    ELSE    Set Variable    ${input_ggdh}
    ${result_tongcong_in_dh}    Run Keyword If    0 < ${input_ggdh} < 100    Price after % discount invoice    ${result_tongtienhang}    ${input_ggdh}
    ...    ELSE    Minus and replace floating point    ${result_tongtienhang}    ${input_ggdh}
    ${result_khachcantra}    Minus and replace floating point    ${result_tongcong_in_dh}    ${get_khachdatra_in_dh_bf_execute}
    ${actual_khtt_all}    Set Variable If    '${input_khtt2}' == 'all'    ${result_khachcantra}    ${input_khtt2}
    ${actual_khtt}    Set Variable If    '${input_khtt2}' == '0'    0    ${actual_khtt_all}
    ${actual_khtt_paymented}    Sum and replace floating point    ${actual_khtt}    ${get_khachdatra_in_dh_bf_execute}
    ${result_no_hientai_kh}    Minus and replace floating point    ${get_no_bf_execute}    ${actual_khtt}    #Do đơn đặt hàng không được ghi nhận vào công nợ mà chỉ ghi nhận phiếu thanh toán của đơn đặt hàng nên sẽ thành công thức trừ
    #input data into DH form
    Wait Until Keyword Succeeds    3 times    20 s    Before Test Ban Hang
    Go to xu ly dat hang    ${order_code}
    Sleep    15s
    Wait Until Keyword Succeeds    3 times    4s    Input payment method for customer    ${actual_khtt}    ${phuong_thuc}    ${so_tai_khoan}    ${result_khachcantra}    ${cell_tinhvaocongno_order}
    Input text to Ghi chu field    ${input_ghichu}
    Click Element JS    ${button_luu_order}
    Sleep    0.5s
    Order message success validation
    ${get_ma_dh}    Get saved code after execute
    #get values
    Sleep    20 s    wait for response to API
    #assert value product
    ${get_ma_kh_in_dh_af_execute}    ${get_TTDH_in_dh_af_execute}    ${get_tongtienhang_in_dh_af_exxecute}    ${get_khachdatra_in_dh_af_execute}    ${get_giamgia_in_dh_af_execute}    ${get_tongcong_in_dh_af_execute}    ${get_ghichu_in_dh_af_execute}
    ...    Get order info incase discount by order code    ${order_code}
    Should Be Equal As Strings    ${get_ma_kh_in_dh_af_execute}    ${input_ma_kh}
    Should Be Equal As Numbers    ${get_TTDH_in_dh_af_execute}    1    #1 : phiếu tạm
    Should Be Equal As Numbers    ${get_tongtienhang_in_dh_af_exxecute}    ${result_tongtienhang}
    Should Be Equal As Numbers    ${get_khachdatra_in_dh_af_execute}    ${actual_khtt_paymented}
    Should Be Equal As Numbers    ${get_giamgia_in_dh_af_execute}    ${result_ggdh}
    Should Be Equal As Numbers    ${get_tongcong_in_dh_af_execute}    ${result_tongcong_in_dh}
    Should Be Equal As Strings    ${get_ghichu_in_dh_af_execute}    ${input_ghichu}
    #assert value khach hang and so quy
    ${get_no_af_execute}    ${get_tongban_af_execute}    ${get_tongban_tru_trahang_af_execute}    Get Customer Debt from API    ${input_ma_kh}
    ${get_ma_phieutt_in_dh}    Get ma phieu thanh toan dat hang frm API    ${get_ma_dh}
    Should Be Equal As Numbers    ${get_no_af_execute}    ${result_no_hientai_kh}
    Should Be Equal As Numbers    ${get_tongban_af_execute}    ${get_tongban_bf_execute}
    Should Be Equal As Numbers    ${get_tongban_tru_trahang_af_execute}    ${get_tongban_tru_trahang_bf_execute}
    Run Keyword If    '${input_khtt}' == '0'    Validate history in customer if order is not paid    ${input_ma_kh}    ${get_ma_dh}
    ...    ELSE    Validate history and debt in customer if order is paid    ${input_ma_kh}    ${get_ma_dh}    ${actual_khtt}    ${result_no_hientai_kh}
    Run Keyword If    '${input_khtt}' == '0'    Validate So quy info if Order is not paid    ${get_ma_dh}
    ...    ELSE    Validate So quy info if Order is paid    ${get_ma_phieutt_in_dh}    ${actual_khtt}
    Delete order frm Order code    ${get_ma_dh}
