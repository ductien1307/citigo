*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    ${headless_browser}
Test Setup        Before Test Ban Hang
Test Teardown     After Test
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
Resource          ../../../../core/share/imei.robot
Resource          ../../../../core/share/list_dictionary.robot
Resource          ../../../../core/API/api_mhbh_dathang.robot

*** Variables ***
@{list_product_order}    HH0040    SI024    DVT44
@{list_nums}  4   2   1.4
@{discount}    5    2000    0
@{discount_type}   dis     disvnd    none

*** Test Cases ***    Mã KH         List product            List nums     GGSP            List discount type      GGDH       Khách TT
Create order_GOLIVE       [Tags]         TCG
                      [Template]    gherkin
                      CTKH084       ${list_product_order}       ${list_nums}     ${discount}      ${discount_type}        0          all

*** Keywords ***
gherkin
    [Arguments]    ${input_ma_kh}    ${list_product}    ${list_nums}    ${list_ggsp}   ${list_discount_type}    ${input_ggdh}    ${input_khtt}
    Set Selenium Speed    0.5s
    Given Go to create order screen
    When Input order info into sale screen include customer code ${input_ma_kh} and list product ${list_product} and numbers ${list_nums} and discount product ${list_ggsp} and type product ${list_discount_type} and discount order ${input_ggdh} and payment ${input_khtt}
    Then Compute and validate info after create order include customer code ${input_ma_kh} and list product ${list_product} and numbers ${list_nums} and discount product ${list_ggsp} and type product ${list_discount_type} and discount order ${input_ggdh} and payment ${input_khtt}

Go to create order screen
    Wait Until Keyword Succeeds    3 times    5 s    Click Element JS    ${tab_dathang}

Input order info into sale screen include customer code ${input_ma_kh} and list product ${list_product} and numbers ${list_nums} and discount product ${list_ggsp} and type product ${list_discount_type} and discount order ${input_ggdh} and payment ${input_khtt}
    ${list_result_newprice}   ${result_tongcong}    ${result_discount_order}    ${actual_khtt}    Get list result newprice and total payment frm order api    ${list_product}    ${list_nums}    ${list_ggsp}   ${list_discount_type}    ${input_ggdh}   ${input_khtt}
    Wait Until Keyword Succeeds    3 times    3s    Input product - nums - discount into DH form    ${list_product}    ${list_nums}    ${list_ggsp}   ${list_discount_type}    ${list_result_newprice}
    Wait Until Keyword Succeeds    3 times    3s    Input discount order into DH form    ${input_ggdh}    ${result_discount_order}
    Wait Until Keyword Succeeds    3 times    3s    Input customer payment into DH form    ${input_khtt}    ${input_ma_kh}    ${result_tongcong}    ${actual_khtt}

Compute and validate info after create order include customer code ${input_ma_kh} and list product ${list_product} and numbers ${list_nums} and discount product ${list_ggsp} and type product ${list_discount_type} and discount order ${input_ggdh} and payment ${input_khtt}
    ${result_tongtienhang}    ${result_tongcong}    ${result_ggdh}    ${actual_khtt}    ${list_result_order_summary}    ${result_no_hientai_kh}    ${get_tongban_bf_execute}    ${get_tongban_tru_trahang_bf_execute}     Get list result info product - payment - debt frm order apí    ${input_ma_kh}    ${list_product}    ${list_nums}    ${list_ggsp}   ${list_discount_type}    ${input_ggdh}     ${input_khtt}
    Wait Until Keyword Succeeds    3 times    3s    Click Element JS    ${button_bh_dathang}
    Wait Until Keyword Succeeds    3 times    3s    Order message success validation
    ${get_ma_dh}    Get saved code after execute
    #assert value product
    Assert list of order summarry after execute    ${list_product}    ${list_result_order_summary}
    #assert value order
    Assert order info after execute    ${input_ma_kh}    1    ${result_tongtienhang}    ${actual_khtt}    ${result_ggdh}    ${result_tongcong}    0    ${get_ma_dh}
    Assert order summary values until succeed    ${get_ma_dh}    ${input_ma_kh}    ${result_tongcong}    ${actual_khtt}    Phiếu tạm
    #assert value khach hang and so quy
    Assert customer debit amount and general ledger after execute    ${input_ma_kh}    ${get_ma_dh}    ${input_khtt}    ${actual_khtt}    ${result_no_hientai_kh}    ${get_tongban_bf_execute}    ${get_tongban_tru_trahang_bf_execute}
    Delete order frm Order code    ${get_ma_dh}
