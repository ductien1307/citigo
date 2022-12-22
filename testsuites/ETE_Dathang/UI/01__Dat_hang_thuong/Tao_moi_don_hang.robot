*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    ${headless_browser}
Test Setup        Before Test Ban Hang
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
Resource          ../../../../core/share/javascript.robot
Resource          ../../../../core/share/imei.robot
Resource          ../../../../core/share/list_dictionary.robot

*** Variables ***
&{dict_product1}    HH0040=4    SI024=2    DVT44=1.5    DV049=5    Combo25=2.4    QDBTT06=3
&{dict_product2}    HH0042=1    SI025=2    DVT45=3    DV050=1.5    Combo26=2.5
&{dict_product3}    HH0043=1    SI026=2    QD101=4    DV051=1.5    Combo27=1.8
@{discount}    5    2000    0    200000.55    70000    0
@{discount_type}   dis     disvnd    none    changedown    changeup     none

*** Test Cases ***    Mã KH         List product&nums     GGSP            List discount type      GGDH       Khách TT
Create order_GOLIVE       [Tags]        EDA                  ED                     GOLIVE1
                      [Template]    uetedh1
                      CTKH084       ${dict_product1}     ${discount}      ${discount_type}        0          all

Create order              [Tags]        EDA                  ED
                      [Template]    uetedh1
                      CTKH085       ${dict_product2}     ${discount}      ${discount_type}       50000       0
                      CTKH086       ${dict_product3}     ${discount}      ${discount_type}       7          200000

*** Keywords ***
uetedh1
    [Arguments]    ${input_ma_kh}    ${dict_product_nums}    ${list_ggsp}   ${list_discount_type}    ${input_ggdh}    ${input_khtt}
    #get info product, customer
    Set Selenium Speed    0.5s
    # lấy dữ liệu trc khi thực hiện giao dịch
    ${list_product}    ${list_nums}    Get list from dictionary    ${dict_product_nums}
    ${get_no_bf_execute}    ${get_tongban_bf_execute}    ${get_tongban_tru_trahang_bf_execute}    Get Customer Debt from API    ${input_ma_kh}
    ${list_result_thanhtien}    ${list_result_order_summary}    ${list_result_giamoi}    Get list total sale and order summary incase discount and newprice    ${list_product}
    ...    ${list_nums}    ${list_ggsp}    ${list_discount_type}
    #compute
    ${result_tongtienhang}    Sum values in list    ${list_result_thanhtien}
    ${result_tongcong}    Run Keyword If    0 < ${input_ggdh} < 100    Price after % discount invoice    ${result_tongtienhang}    ${input_ggdh}
    ...    ELSE IF    ${input_ggdh} > 100    Minus and replace floating point    ${result_tongtienhang}    ${input_ggdh}
    ...    ELSE    Set Variable    ${result_tongtienhang}
    ${result_ggdh}    Run Keyword If    0 < ${input_ggdh} < 100    Convert % discount to VND and round    ${result_tongtienhang}    ${input_ggdh}
    ...    ELSE    Set Variable    ${input_ggdh}
    ${result_tongcong}    Replace floating point    ${result_tongcong}
    ${actual_khtt_all}    Set Variable If    '${input_khtt}' == 'all'    ${result_tongcong}    ${input_khtt}
    ${actual_khtt}    Set Variable If    '${input_khtt}' == '0'    0    ${actual_khtt_all}
    ${result_no_hientai_kh}    Minus    ${get_no_bf_execute}    ${actual_khtt}    #Do đặt hàng không ghi nhận phiếu đặt, mà phiếu thanh toán ghi nhận là số âm nên khi tính công nợ sẽ là trừ
    #input data into DH form
    Wait Until Keyword Succeeds    3 times    5 s    Click Element JS    ${tab_dathang}
    ${laster_nums}    Set Variable    0
    : FOR    ${item_product}    ${item_nums}    ${item_ggsp}    ${item_price}   ${item_discount_type}    IN ZIP    ${list_product}
    ...    ${list_nums}    ${list_ggsp}    ${list_result_giamoi}    ${list_discount_type}
    \    ${laster_nums}    Wait Until Keyword Succeeds    3 times    5 s    Input product-num in sale form    ${item_product}    ${item_nums}
    \    ...    ${laster_nums}    ${cell_tongsoluong_dh}
    \    Run keyword if    '${item_discount_type}' == 'dis'     Wait Until Keyword Succeeds    3 times    5 s    Input % discount for multi product    ${item_product}    ${item_ggsp}
    \    ...    ${item_price}    ELSE IF    '${item_discount_type}' == 'disvnd'    Input VND discount for multi product    ${item_product}    ${item_ggsp}    ${item_price}
    \    ...     ELSE IF  '${item_discount_type}' == 'changeup' or '${item_discount_type}' == 'changedown'    Wait Until Keyword Succeeds    3 times    5 s    Input newprice for multi product    ${item_product}    ${item_ggsp}
    \    ...    ELSE    Log    Ignore input
    Wait Until Keyword Succeeds    3 times    5 s    Run keyword if    0 < ${input_ggdh} < 100    Input % discount order    ${input_ggdh}
    ...    ${result_ggdh}   ELSE    Input VND discount order    ${input_ggdh}
    Wait Until Keyword Succeeds    3 times    5 s    Run Keyword If    '${input_khtt}' == '0'    Input Khach Hang    ${input_ma_kh}
    ...    ELSE    Input Order info    ${input_ma_kh}    ${actual_khtt}    ${result_tongcong}
    Wait Until Keyword Succeeds    3 times    5 s    Click Element JS    ${button_bh_dathang}
    Order message success validation
    ${get_ma_dh}    Get saved code after execute
    #assert value product
    Assert list of order summarry after execute    ${list_product}    ${list_result_order_summary}
    #assert value order
    Assert order info after execute    ${input_ma_kh}    1    ${result_tongtienhang}    ${actual_khtt}    ${result_ggdh}    ${result_tongcong}    0    ${get_ma_dh}
    Assert order summary values until succeed    ${get_ma_dh}    ${input_ma_kh}    ${result_tongcong}    ${actual_khtt}    Phiếu tạm
    #assert value khach hang and so quy
    Assert customer debit amount and general ledger after execute    ${input_ma_kh}    ${get_ma_dh}    ${input_khtt}    ${actual_khtt}    ${result_no_hientai_kh}    ${get_tongban_bf_execute}    ${get_tongban_tru_trahang_bf_execute}
    Delete order frm Order code    ${get_ma_dh}
