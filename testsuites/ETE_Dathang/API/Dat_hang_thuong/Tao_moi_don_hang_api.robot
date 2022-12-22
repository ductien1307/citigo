*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}      ${headless_browser}
Resource          ../../../../core/API/api_danhmuc_hanghoa.robot
Resource          ../../../../core/API/api_dathang.robot
Resource          ../../../../core/API/api_khachhang.robot
Resource          ../../../../core/API/api_mhbh.robot
Resource          ../../../../core/Dat_Hang/dat_hang_action.robot
Resource          ../../../../core/Dat_Hang/dat_hang_navigation.robot
Resource          ../../../../core/Dat_Hang/dat_hang_page.robot
Resource          ../../../../core/share/toast_message.robot
Resource          ../../../../core/API/api_soquy.robot
Resource          ../../../../core/share/javascript.robot
Resource          ../../../../core/API/api_mhbh_dathang.robot

*** Variables ***
&{list_product1}    HH0040=4    SI024=2    DVT44=1.5    DV049=5    Combo25=2.4     QDBTT06=3
&{list_product2}    HH0042=1    SI025=2    DVT45=3    DV050=1.5    Combo26=2.5
&{list_product3}    HH0043=1    SI026=2    QD101=4    DV051=1.5    Combo27=1.8
@{discount}    5    2000    0    200000.55    70000    0
@{discount_type}   dis     disvnd    none    changedown    changeup     none

*** Test Cases ***    Mã KH         List product&nums     GGSP            List discount type      GGDH       Khách TT
Create order_GOLIVE       [Tags]        AEDA                  ED                     
                      [Template]    uetedh1
                      CTKH084       ${list_product1}     ${discount}      ${discount_type}        0          all

Create order             [Tags]        AEDA                  ED
                      [Template]    uetedh1
                      CTKH085       ${list_product2}     ${discount}      ${discount_type}       50000       0
                      CTKH086       ${list_product3}     ${discount}      ${discount_type}       7          200000

*** Keywords ***
uetedh1
    [Arguments]    ${input_ma_kh}    ${dict_product_nums}    ${list_ggsp}   ${list_discount_type}    ${input_ggdh}    ${input_khtt}
    #get info product, customer
    Set Selenium Speed    0.5s
    ${list_product}    Get Dictionary Keys    ${dict_product_nums}
    ${list_nums}    Get Dictionary Values    ${dict_product_nums}
    ${get_no_bf_execute}    ${get_tongban_bf_execute}    ${get_tongban_tru_trahang_bf_execute}    Get Customer Debt from API    ${input_ma_kh}
    ${list_result_thanhtien}    ${list_result_order_summary}    ${list_result_giamoi}    Get list total sale and order summary incase discount and newprice    ${list_product}
    ...    ${list_nums}    ${list_ggsp}    ${list_discount_type}
    #compute
    ${result_tongtienhang}    Sum values in list    ${list_result_thanhtien}
    ${result_tongtienhang}    Replace floating point    ${result_tongtienhang}
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
    ${order_code}   Add new order incase discount - payment    ${input_ma_kh}    ${input_ggdh}    ${dict_product_nums}    ${list_ggsp}   ${list_discount_type}    ${input_khtt}
    #get values
    Sleep    20 s    wait for response to API
    #assert value product
    ${list_order_summary_af_execute}    Get list order summary frm product API    ${list_product}
    : FOR    ${result_tong_dh}    ${order_summary_af_execute}    IN ZIP    ${list_result_order_summary}    ${list_order_summary_af_execute}
    \    Should Be Equal As Numbers    ${order_summary_af_execute}    ${result_tong_dh}
    #assert value order
    ${get_ma_kh_in_dh_af_execute}    ${get_TTDH_in_dh_af_execute}    ${get_tongtienhang_in_dh_af_exxecute}    ${get_khachdatra_in_dh_af_execute}    ${get_giamgia_in_dh_af_execute}    ${get_tongcong_in_dh_af_execute}    ${get_ghichu_in_dh_af_execute}
    ...    Get order info incase discount by order code    ${order_code}
    Should Be Equal As Strings    ${get_ma_kh_in_dh_af_execute}    ${input_ma_kh}
    Should Be Equal As Numbers    ${get_TTDH_in_dh_af_execute}    1    #1 : phiếu tạm
    Run Keyword If    ${input_ggdh} == 0    Should Be Equal As Numbers    ${get_tongcong_in_dh_af_execute}    ${result_tongtienhang}
    ...    ELSE    Should Be Equal As Numbers    ${get_tongtienhang_in_dh_af_exxecute}    ${result_tongtienhang}
    Run Keyword If    ${input_ggdh} == 0    Log    Ignore validate
    ...    ELSE    Should Be Equal As Numbers    ${get_tongtienhang_in_dh_af_exxecute}    ${result_tongtienhang}
    Should Be Equal As Numbers    ${get_khachdatra_in_dh_af_execute}    ${actual_khtt}
    Should Be Equal As Numbers    ${get_giamgia_in_dh_af_execute}    ${result_ggdh}
    Should Be Equal As Numbers    ${get_tongcong_in_dh_af_execute}    ${result_tongcong}
    #assert value khach hang and so quy
    ${get_no_af_execute}    ${get_tongban_af_execute}    ${get_tongban_tru_trahang_af_execute}    Get Customer Debt from API    ${input_ma_kh}
    ${get_ma_phieutt_in_dh}    Get ma phieu thanh toan dat hang frm API    ${order_code}
    Should Be Equal As Numbers    ${get_no_af_execute}    ${result_no_hientai_kh}
    Should Be Equal As Numbers    ${get_tongban_af_execute}    ${get_tongban_bf_execute}
    Should Be Equal As Numbers    ${get_tongban_tru_trahang_af_execute}    ${get_tongban_tru_trahang_bf_execute}
    Run Keyword If    '${input_khtt}' == '0'    Validate history in customer if order is not paid    ${input_ma_kh}    ${order_code}
    ...    ELSE    Validate history and debt in customer if order is paid    ${input_ma_kh}    ${order_code}    ${actual_khtt}    ${result_no_hientai_kh}
    Run Keyword If    '${input_khtt}' == '0'    Validate So quy info if Order is not paid    ${order_code}
    ...    ELSE    Validate So quy info if Order is paid    ${get_ma_phieutt_in_dh}    ${actual_khtt}
    Delete order frm Order code    ${order_code}
