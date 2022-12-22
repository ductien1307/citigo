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
&{dict_product_u2}    HH0045=3    SI028=1    DVT48=3.5    DV052=1    Combo29=2
@{discount}    15    20000    0    80000
@{discount_type}   dis     disvnd    none    changeup
@{list_product_delete}    SI028

*** Test Cases ***    Mã KH        Khách thanh toán    Ghi chú ĐH         GGDH     List product               List GGSP     List discount type        List product to create    Khách thanh toán to create
Delete product        [Tags]             EDU
                      [Template]         uetedh_ud2
                      CTKH088      500000                 Đã thanh toán      0         ${list_product_delete}    ${discount}    ${discount_type}         ${dict_product_u2}    0
*** Keywords ***
uetedh_ud2
    [Arguments]    ${input_ma_kh}    ${input_khtt}    ${input_ghichu}    ${input_ggdh}    ${list_product}    ${list_discount}    ${list_discount_type}
    ...    ${dict_product_nums}    ${input_khtt_create_order}
    #get info to validate
    ${order_code}    Add new order with multi products    ${input_ma_kh}    ${dict_product_nums}    ${input_khtt_create_order}
    ${get_khachdatra_in_dh_bf_execute}    ${get_tongtienhang_in_dh_bf_execute}    Get paid value frm API    ${order_code}
    ${get_list_hh_in_dh_bf_execute}    Get list product frm API    ${order_code}
    ${list_result_tongdh_delete}    Get list order summary incase delete product    ${order_code}    ${list_product}
    #get order summary and sub total of products
    : FOR    ${ma_hh}    IN    @{list_product}
    \    Remove Values From List    ${get_list_hh_in_dh_bf_execute}    ${ma_hh}
    Log    ${get_list_hh_in_dh_bf_execute}
    ${list_soluong_in_dh}    ${list_tong_dh}    Get list quantity - order summary frm API    ${order_code}    ${get_list_hh_in_dh_bf_execute}
    ${list_result_thanhtien}    ${list_result_newprice}    Get list total sale and newprice incase discount    ${get_list_hh_in_dh_bf_execute}    ${list_soluong_in_dh}   ${list_discount}
    ...   ${list_discount_type}
    #compute
    ${result_tongtienhang}    Sum values in list and round    ${list_result_thanhtien}
    ${result_ggdh}    Run Keyword If    0 < ${input_ggdh} < 100    Convert % discount to VND and round    ${result_tongtienhang}    ${input_ggdh}
    ...    ELSE    Set Variable    ${input_ggdh}
    ${result_tongcong_in_dh}    Run Keyword If    0 < ${input_ggdh} < 100    Price after % discount invoice    ${result_tongtienhang}    ${input_ggdh}
    ...    ELSE    Minus and replace floating point    ${result_tongtienhang}    ${input_ggdh}
    ${result_khachcantra}    Minus and replace floating point    ${result_tongcong_in_dh}    ${get_khachdatra_in_dh_bf_execute}
    ${actual_khtt_all}    Set Variable If    '${input_khtt}' == 'all'    ${result_khachcantra}    ${input_khtt}
    ${actual_khtt}    Set Variable If    '${input_khtt}' == '0'    0    ${actual_khtt_all}
    ${actual_khtt_paymented}    Sum and replace floating point    ${actual_khtt}    ${get_khachdatra_in_dh_bf_execute}
    #delete product into BH form
    Wait Until Keyword Succeeds    3 times    3s    Before Test Ban Hang
    Go to xu ly dat hang    ${order_code}
    Delete list product into BH form    ${list_product}
    : FOR    ${item_product}    ${item_ggsp}    ${item_result_newprice}   ${item_discount_type}    IN ZIP    ${get_list_hh_in_dh_bf_execute}    ${list_discount}
    ...    ${list_result_newprice}    ${list_discount_type}
    \    Run keyword if    '${item_discount_type}' == 'dis'     Wait Until Keyword Succeeds    3 times    5 s    Input % discount for multi product    ${item_product}    ${item_ggsp}
    \    ...    ${item_result_newprice}    ELSE IF    '${item_discount_type}' == 'disvnd'    Input VND discount for multi product    ${item_product}    ${item_ggsp}    ${item_result_newprice}
    \    ...     ELSE IF  '${item_discount_type}' == 'changeup' or '${item_discount_type}' == 'changedown'    Wait Until Keyword Succeeds    3 times    5 s    Input newprice for multi product    ${item_product}    ${item_ggsp}
    \    ...    ELSE    Log    Ignore input
    Run Keyword If    0 < ${input_ggdh} < 100    Input % discount order    ${input_ggdh}    ${result_ggdh}    ELSE    Input VND discount order    ${input_ggdh}
    Run Keyword If    ${input_khtt}!=0    Input order payment into BH    ${actual_khtt}    ${result_khachcantra}
    Input text to Ghi chu field    ${input_ghichu}
    Click Element JS    ${button_luu_order}
    Wait Until Keyword Succeeds    3 times    3s    Order message success validation
    ${get_ma_dh}    Get saved code after execute
    #assert value product
    Assert list of order summarry after execute    ${get_list_hh_in_dh_bf_execute}    ${list_tong_dh}
    #assert value product delete
    Assert list of order summarry after execute    ${list_product}    ${list_result_tongdh_delete}
    #assert value order
    Assert order info after execute    ${input_ma_kh}    1    ${result_tongtienhang}    ${actual_khtt_paymented}    ${result_ggdh}    ${result_tongcong_in_dh}
    ...    ${input_ghichu}    ${order_code}
    Delete order frm Order code    ${get_ma_dh}
