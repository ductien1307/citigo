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
&{dict_product_u1}    SI027=1    QD103=2.4    DV052=2    Combo28=3
&{dict_productadd}   HH0044=3.6
@{discount}    15    20000    0    250000.55
@{discount_type}   dis     disvnd    none    changedown

*** Test Cases ***    Mã khách hàng    List product&nums     List GGSP        List discount type       GGDH       Khách thanh toán    Product add         Payment create    Ghi chú
Add new product            [Tags]           EDU      GOLIVE1_A
                      [Template]       uetedh_ud1
                      CTKH087          ${dict_product_u1}    ${discount}       ${discount_type}         15         all                ${dict_productadd}    0               Thanh toán khi nhận hàng
*** Keywords ***
uetedh_ud1
    [Arguments]    ${input_ma_kh}    ${dict_product_nums}    ${list_ggsp}   ${list_discount_type}    ${input_ggdh}    ${input_khtt}    ${dict_product_add}
    ...    ${input_khtt_create_order}    ${input_ghichu}
    #get info product, customer
    ${order_code}    Add new order with multi products    ${input_ma_kh}    ${dict_product_add}    ${input_khtt_create_order}
    ${list_product}    Get Dictionary Keys    ${dict_product_nums}
    ${list_nums}    Get Dictionary Values    ${dict_product_nums}
    ${list_product_add}    Get Dictionary Keys    ${dict_product_add}
    ${list_nums_add}    Get Dictionary Values    ${dict_product_add}
    ${get_khachdatra_in_dh_bf_execute}    ${get_tongtienhang_in_dh_bf_execute}    Get paid value frm API    ${order_code}
    ${get_tongso_dh_bf_execute}    Get order summary by order code    ${order_code}
    ${get_no_bf_execute}    ${get_tongban_bf_execute}    ${get_tongban_tru_trahang_bf_execute}    Get Customer Debt from API    ${input_ma_kh}
    #get value to Validate
    ${list_result_thanhtien_add}    ${list_result_order_summary_add}    Get list total sale and order summary frm api    ${list_product_add}    ${list_nums_add}
    ${list_result_thanhtien}    ${list_result_order_summary}    ${list_result_giamoi}    Get list total sale and order summary incase discount and newprice    ${list_product}
    ...    ${list_nums}    ${list_ggsp}   ${list_discount_type}
    #compute
    ${result_tongthanhtien}    Sum values in list and round    ${list_result_thanhtien}
    ${result_tongtienhang_add}    Sum values in list    ${list_result_thanhtien_add}
    ${result_tongtienhang}    Sum and replace floating point    ${result_tongthanhtien}    ${result_tongtienhang_add}
    ${result_ggdh}    Run Keyword If    0 < ${input_ggdh} < 100    Convert % discount to VND and round    ${result_tongtienhang}    ${input_ggdh}
    ...    ELSE    Set Variable    ${input_ggdh}
    ${result_tongcong_in_dh}    Run Keyword If    0 < ${input_ggdh} < 100    Price after % discount invoice    ${result_tongtienhang}    ${input_ggdh}
    ...    ELSE    Minus and replace floating point    ${result_tongtienhang}    ${input_ggdh}
    ${result_khachcantra}    Minus and replace floating point    ${result_tongcong_in_dh}    ${get_khachdatra_in_dh_bf_execute}
    ${actual_khtt_all}    Set Variable If    '${input_khtt}' == 'all'    ${result_khachcantra}    ${input_khtt}
    ${actual_khtt}    Set Variable If    '${input_khtt}' == '0'    0    ${actual_khtt_all}
    ${actual_khtt_paymented}    Sum and replace floating point    ${actual_khtt}    ${get_khachdatra_in_dh_bf_execute}
    ${result_no_hientai_kh}    Minus and replace floating point    ${get_no_bf_execute}    ${actual_khtt}    #Do đơn đặt hàng không được ghi nhận vào công nợ mà chỉ ghi nhận phiếu thanh toán của đơn đặt hàng nên sẽ thành công thức trừ
    #input data into DH form
    Wait Until Keyword Succeeds    3 times    3s    Before Test Ban Hang
    Wait Until Keyword Succeeds    3 times    3s    Go to xu ly dat hang    ${order_code}
    ${lastest_nums}    Set Variable    0
    : FOR    ${item_product}    ${item_nums}    ${item_ggsp}    ${item_price}   ${item_discount_type}    IN ZIP    ${list_product}
    ...    ${list_nums}    ${list_ggsp}    ${list_result_giamoi}    ${list_discount_type}
    \    ${lastest_nums}    Wait Until Keyword Succeeds    3 times    5 s    Input product-num in sale form    ${item_product}    ${item_nums}
    \    ...    ${lastest_nums}    ${cell_tongsoluong_dh}
    \    Run keyword if    '${item_discount_type}' == 'dis'     Wait Until Keyword Succeeds    3 times    5 s    Input % discount for multi product    ${item_product}    ${item_ggsp}
    \    ...    ${item_price}    ELSE IF    '${item_discount_type}' == 'disvnd'    Input VND discount for multi product    ${item_product}    ${item_ggsp}    ${item_price}
    \    ...     ELSE IF  '${item_discount_type}' == 'changeup' or '${item_discount_type}' == 'changedown'    Wait Until Keyword Succeeds    3 times    5 s    Input newprice for multi product    ${item_product}    ${item_ggsp}
    \    ...    ELSE    Log    Ignore input
    Run Keyword If    0 < ${input_ggdh} < 100    Wait Until Keyword Succeeds    3 times    5 s    Input % discount order    ${input_ggdh}    ${result_ggdh}
    ...    ELSE    Wait Until Keyword Succeeds    3 times    5 s    Input VND discount order    ${input_ggdh}
    Run Keyword If    ${input_khtt}!=0    Wait Until Keyword Succeeds    3 times    5 s    Input order payment into BH    ${actual_khtt}    ${result_khachcantra}
    Input text to Ghi chu field    ${input_ghichu}
    Click Element JS    ${button_luu_order}
    Order message success validation
    ${get_ma_dh}    Get saved code after execute
    #assert value product
    Assert list of order summarry after execute    ${list_product}    ${list_result_order_summary}
    #assert value product add
    Assert list of order summarry after execute    ${list_product_add}    ${list_result_order_summary_add}
    #assert value order
    Assert order info after execute    ${input_ma_kh}    1    ${result_tongtienhang}    ${actual_khtt_paymented}    ${result_ggdh}    ${result_tongcong_in_dh}    ${input_ghichu}    ${order_code}
    #assert value khach hang and so quy
    Assert customer debit amount and general ledger after execute    ${input_ma_kh}    ${order_code}    ${input_khtt}    ${actual_khtt}
    ...    ${result_no_hientai_kh}    ${get_tongban_bf_execute}    ${get_tongban_tru_trahang_bf_execute}
    Delete order frm Order code    ${get_ma_dh}
