*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}      ${headless_browser}
Test Setup
Test Teardown     After Test
Resource          ../../../../../core/API/api_danhmuc_hanghoa.robot
Resource          ../../../../../core/API/api_dathang.robot
Resource          ../../../../../core/API/api_khachhang.robot
Resource          ../../../../../core/API/api_mhbh.robot
Resource          ../../../../../core/API/api_mhbh_dathang.robot
Resource          ../../../../../core/Dat_Hang/dat_hang_action.robot
Resource          ../../../../../core/Dat_Hang/dat_hang_navigation.robot
Resource          ../../../../../core/Dat_Hang/dat_hang_page.robot
Resource          ../../../../../core/share/toast_message.robot
Resource          ../../../../../core/API/api_soquy.robot
Resource          ../../../../../config/env_product/envi.robot
Library           Collections
Library           BuiltIn

*** Variables ***
&{dict_product_u5}    HH0048=3.5    SI031=2    QD110=1.75    DV055=3    Combo32=1

*** Test Cases ***    Mã KH         Mã KH update    Khách thanh toán    Ghi chú         Dict product
Update_customer
                      [Tags]        EDU     ED
                      [Template]    uetedh_ud5
                      CTKH091      CTKH092         1000000             Đã đặt cọc        ${dict_product_u5}
*** Keywords ***
uetedh_ud5
    [Arguments]    ${input_ma_kh}    ${input_ma_kh_update}    ${input_khtt}    ${input_ghichu}    ${dic_product_nums}
    #get info product, customer
    ${order_code}    Add new order with multi product and no payment - get order code    ${input_ma_kh}    ${dic_product_nums}
    ${get_khachdatra_in_dh_bf_execute}    ${get_tongtienhang_in_dh_bf_execute}    Get paid value frm API    ${order_code}
    ${get_no_bf_execute}    ${get_tongban_bf_execute}    ${get_tongban_tru_trahang_bf_execute}    Get Customer Debt from API    ${input_ma_kh}
    ${get_no_kh_update_bf_execute}    ${get_tongban_kh_update_bf_execute}    ${get_tongban_tru_trahang_kh_update_bf_execute}    Get Customer Debt from API    ${input_ma_kh_update}
    ${get_list_hh_in_dh_bf_execute}    Get list product frm API    ${order_code}
    ${list_tongdh_bf_execute}    Get list order summary frm product API    ${get_list_hh_in_dh_bf_execute}
    #compute
    ${get_tongtienhang_in_dh_bf_execute}    Replace floating point    ${get_tongtienhang_in_dh_bf_execute}
    ${actual_khtt_all}    Set Variable If    '${input_khtt}' == 'all'    ${get_tongtienhang_in_dh_bf_execute}    ${input_khtt}
    ${actual_khtt}    Set Variable If    '${input_khtt}' == '0'    0    ${actual_khtt_all}
    ${actual_khtt_paymented}    Sum and replace floating point    ${actual_khtt}    ${get_khachdatra_in_dh_bf_execute}
    ${result_actual_khtt}    Set Variable If    ${get_khachdatra_in_dh_bf_execute} > 0 and '${input_khtt}' == 'all'    ${actual_khtt}    ${actual_khtt_paymented}    #tính lại tổng cộng với đơn hàng đã đặt cọc khi thay đổi khách hàng
    ${result_no_hientai_kh}    Minus and replace floating point    ${get_no_bf_execute}    ${get_khachdatra_in_dh_bf_execute}
    ${result_tongban_kh}    Minus and replace floating point    ${get_tongban_bf_execute}    ${get_khachdatra_in_dh_bf_execute}
    ${result_no_hientai_kh_update}    Minus and replace floating point    ${get_no_kh_update_bf_execute}    ${actual_khtt}
    #update data into order form
    Wait Until Keyword Succeeds    3 times    3s    Before Test Ban Hang
    Go to xu ly dat hang    ${order_code}
    Update customer into BH form    ${input_ma_kh_update}
    Run Keyword If    ${input_khtt}!=0    Input order payment into BH    ${actual_khtt}    ${get_tongtienhang_in_dh_bf_execute}
    Input text to Ghi chu field    ${input_ghichu}
    Click Element JS    ${button_luu_order}
    ${get_ma_dh}     Get saved code until success
    #assert value product\
    ${get_list_hh_in_dh_af_execute}    Get list product frm API    ${get_ma_dh}
    Assert list of order summarry after execute    ${get_list_hh_in_dh_af_execute}    ${list_tongdh_bf_execute}
    #assert value order
    Assert order info after execute    ${input_ma_kh_update}    1    ${get_tongtienhang_in_dh_bf_execute}    ${actual_khtt_paymented}    0    ${get_tongtienhang_in_dh_bf_execute}
    ...    ${input_ghichu}    ${get_ma_dh}
    #assert value khach hang after delete
    ${get_no_af_execute}    ${get_tongban_af_execute}    ${get_tongban_tru_trahang_af_execute}    Get Customer Debt from API    ${input_ma_kh}
    Should Be Equal As Numbers    ${get_no_af_execute}    ${result_no_hientai_kh}
    Should Be Equal As Numbers    ${get_tongban_af_execute}    ${result_tongban_kh}
    #assert value khach hang after change customer
    ${get_no_af_execute_update}    ${get_tongban_af_execute_update}    ${get_tongban_tru_trahang_af_execute_update}    Get Customer Debt from API    ${input_ma_kh_update}
    Should Be Equal As Numbers    ${get_no_af_execute_update}    ${result_no_hientai_kh_update}
    Delete order frm Order code    ${get_ma_dh}
