*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    ${headless_browser}
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

*** Variables ***
&{dict_product_u4}    HH0047=2    SI030=1    DVT50=1.75    DV054=2.7    Combo31=1

*** Test Cases ***    Mã KH         Tên Bảng giá         Khách thanh toán    Ghi chú
updateDH_changeBG     [Tags]        EDU     ED
                      [Template]    uetedh_ud4
                      CTKH090       Bảng giá đặt hàng    0                   Thanh toán khi nhận hàng    ${dict_product_u4}
*** Keywords ***
uetedh_ud4
    [Arguments]    ${input_ma_kh}    ${input_ten_bangia}    ${input_khtt}    ${input_ghichu}    ${dic_product_nums}
    #get info product, customer
    ${order_code}    Add new order with multi product and no payment - get order code    ${input_ma_kh}    ${dic_product_nums}
    ${get_khachdatra_in_dh_bf_execute}    ${get_tongtienhang_in_dh_bf_execute}    Get paid value frm API    ${order_code}
    ${get_list_hh_in_dh_bf_execute}    Get list product frm API    ${order_code}
    ${list_tongdh_bf_execute}    Get list order summary frm product API    ${get_list_hh_in_dh_bf_execute}
    #get order summary and sub total of products
    ${get_id_banggia}    ${list_giaban_new}    Get list gia ban from PriceBook api    ${input_ten_bangia}    ${get_list_hh_in_dh_bf_execute}
    #compute
    ${list_result_thanhtien}    Create List
    : FOR    ${ma_hh}    ${giaban}    IN ZIP    ${get_list_hh_in_dh_bf_execute}    ${list_giaban_new}
    \    ${list_result_thanhtien}    Get TTH with change pricebook    ${order_code}    ${ma_hh}    ${giaban}    ${list_result_thanhtien}
    ${result_tongtienhang}    Sum values in list and round    ${list_result_thanhtien}
    ${result_khachcantra}    Minus and replace floating point    ${result_tongtienhang}    ${get_khachdatra_in_dh_bf_execute}
    ${actual_khtt_all}    Set Variable If    '${input_khtt}' == 'all'    ${result_khachcantra}    ${input_khtt}
    ${actual_khtt}    Set Variable If    '${input_khtt}' == '0'    0    ${actual_khtt_all}
    ${actual_khtt_paymented}    Sum and replace floating point    ${actual_khtt}    ${get_khachdatra_in_dh_bf_execute}
    ${result_actual_khtt}    Set Variable If    '${input_khtt}' == 'all'    ${actual_khtt}    ${actual_khtt_paymented}
    #update BG into DH form
    Wait Until Keyword Succeeds    3 times    3s    Before Test Ban Hang
    Go to xu ly dat hang    ${order_code}
    Select Bang gia    ${input_ten_bangia}
    Run Keyword If    ${input_khtt}!=0    Input order payment into BH    ${actual_khtt}    ${result_khachcantra}
    Input text to Ghi chu field    ${input_ghichu}
    Wait Until Page Contains Element    ${button_luu_order}    2 mins
    Click Element JS    ${button_luu_order}
    ${get_ma_dh}     Get saved code until success
    #assert value product
    ${get_list_hh_in_dh_af_execute}    Get list product frm API    ${get_ma_dh}
    Assert list of order summarry after execute    ${get_list_hh_in_dh_af_execute}    ${list_tongdh_bf_execute}
    #validate product
    : FOR    ${ma_hh}    ${giaban_new}    IN ZIP    ${get_list_hh_in_dh_af_execute}    ${list_giaban_new}
    \    Validate price when change pricebook    ${ma_hh}    ${get_ma_dh}    ${giaban_new}
    #assert value order
    Assert order info after execute    ${input_ma_kh}    1    ${result_tongtienhang}    ${actual_khtt_paymented}    0    ${result_tongtienhang}
    ...    ${input_ghichu}    ${get_ma_dh}
    Delete order frm Order code    ${get_ma_dh}
    After Test
