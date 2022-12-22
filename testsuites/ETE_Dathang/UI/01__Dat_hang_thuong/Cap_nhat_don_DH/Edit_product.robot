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
&{dict_product_u3}    HH0046=1    SI029=2    QD107=3    DV053=1.5    Combo30=2.75
@{list_soluong}    2    3    2.8    1    5.1
@{discount}    0      9    2000    800000    50000
@{discount_type}    none   dis     disvnd    changeup     changedown

*** Test Cases ***    Mã KH              List số lượng      List GGSP      List discount type    GGDH     Khách thanh toán    Ghi chú          List prouct and nums to create    Khách thanh toán to create
Edit product          [Tags]        EDU
                      [Template]         uetedh_ud3
                      CTKH089            ${list_soluong}    ${discount}      ${discount_type}    10000    500000              Đã đặt cọc        ${dict_product_u3}                  400000

*** Keywords ***
uetedh_ud3
    [Arguments]    ${input_ma_kh}    ${list_nums}    ${list_ggsp}    ${list_discount_type}    ${input_ggdh}    ${input_khtt}    ${input_ghichu}
    ...    ${dic_product_nums}    ${input_khtt_create_order}
    #get info product, customer
    ${order_code}    Add new order with multi products    ${input_ma_kh}    ${dic_product_nums}    ${input_khtt_create_order}
    ${get_khachdatra_in_dh_bf_execute}    ${get_tongtienhang_in_dh_bf_execute}    Get paid value frm API    ${order_code}
    ${get_no_bf_execute}    ${get_tongban_bf_execute}    ${get_tongban_tru_trahang_bf_execute}    Get Customer Debt from API    ${input_ma_kh}
    ${get_list_hh_in_dh_bf_execute}    Get list product frm API    ${order_code}
    Sleep    5s
    ${list_result_thanhtien}    ${list_result_order_summary}    ${list_newprice}    Get list total sale - order summary - newprice incase discount and update quantity    ${order_code}    ${get_list_hh_in_dh_bf_execute}    ${list_nums}
    ...    ${list_ggsp}   ${list_discount_type}
    #compute
    ${result_tongtienhang}    Sum values in list and round 2     ${list_result_thanhtien}
    ${result_tongcong}    Run Keyword If    0 < ${input_ggdh} < 100    Price after % discount invoice    ${result_tongtienhang}    ${input_ggdh}
    ...    ELSE    Minus and replace floating point    ${result_tongtienhang}    ${input_ggdh}
    ${result_ggdh}    Run Keyword If    0 < ${input_ggdh} < 100    Convert % discount to VND and round    ${result_tongtienhang}    ${input_ggdh}
    ...    ELSE    Set Variable    ${input_ggdh}
    ${result_khachcantra}    Minus and replace floating point    ${result_tongcong}    ${get_khachdatra_in_dh_bf_execute}
    ${actual_khtt_all}    Set Variable If    '${input_khtt}' == 'all'    ${result_khachcantra}    ${input_khtt}
    ${actual_khtt}    Set Variable If    '${input_khtt}' == '0'    0    ${actual_khtt_all}
    ${actual_khtt_paymented}    Sum and replace floating point    ${actual_khtt}    ${get_khachdatra_in_dh_bf_execute}
    ${result_no_hientai_kh}    Minus and replace floating point    ${get_no_bf_execute}    ${actual_khtt}    #Do đặt hàng không ghi nhận phiếu đặt, mà phiếu thanh toán ghi nhận là số âm nên khi tính công nợ sẽ là trừ
    #edit product in order and get total sale, order summary
    Wait Until Keyword Succeeds    3 times    3s    Before Test Ban Hang
    Go to xu ly dat hang    ${order_code}
    ${lastest_num}    Set Variable    0
    : FOR    ${item_ma_hh}    ${item_soluong}    ${item_ggsp}    ${newprice}    ${item_discount_type}    IN ZIP    ${get_list_hh_in_dh_bf_execute}
    ...    ${list_nums}    ${list_ggsp}    ${list_newprice}   ${list_discount_type}
    \    ${lastest_num}    Update quantity into DH form    ${item_ma_hh}    ${item_soluong}    ${lastest_num}
    \    Run keyword if    '${item_discount_type}' == 'dis'     Wait Until Keyword Succeeds    3 times    5 s    Input % discount for multi product    ${item_ma_hh}    ${item_ggsp}
    \    ...    ${newprice}    ELSE IF    '${item_discount_type}' == 'disvnd'    Input VND discount for multi product    ${item_ma_hh}    ${item_ggsp}    ${newprice}
    \    ...     ELSE IF  '${item_discount_type}' == 'changeup' or '${item_discount_type}' == 'changedown'    Wait Until Keyword Succeeds    3 times    5 s    Input newprice for multi product    ${item_ma_hh}    ${item_ggsp}
    \    ...    ELSE    Log    Ignore input
    Wait Until Keyword Succeeds    3 times    3s     Run Keyword If    0 < ${input_ggdh} < 100    Input % discount order    ${input_ggdh}    ${result_ggdh}
    ...    ELSE    Input VND discount order    ${input_ggdh}
    Wait Until Keyword Succeeds    3 times    3s     Run Keyword If    ${result_khachcantra}>0    Input order payment into BH    ${actual_khtt}    ${result_khachcantra}
    Wait Until Keyword Succeeds    3 times    3s    Input text to Ghi chu field    ${input_ghichu}
    Click Element JS    ${button_luu_order}
    Wait Until Keyword Succeeds    3 times    3s    Order message success validation
    ${get_ma_dh}     Get saved code until success
    #assert value product
    ${get_list_hh_in_dh_af_execute}    Get list product frm API    ${get_ma_dh}
    Assert list of order summarry after execute    ${get_list_hh_in_dh_af_execute}    ${list_result_order_summary}
    #assert value order
    Assert order info after execute    ${input_ma_kh}    1    ${result_tongtienhang}    ${actual_khtt_paymented}    ${result_ggdh}    ${result_tongcong}
    ...    ${input_ghichu}    ${get_ma_dh}
    #assert value khach hang and so quy
    ${get_no_af_execute}    ${get_tongban_af_execute}    ${get_tongban_tru_trahang_af_execute}    Get Customer Debt from API    ${input_ma_kh}
    Should Be Equal As Numbers    ${get_no_af_execute}    ${result_no_hientai_kh}
    Delete order frm Order code    ${get_ma_dh}
    After Test
