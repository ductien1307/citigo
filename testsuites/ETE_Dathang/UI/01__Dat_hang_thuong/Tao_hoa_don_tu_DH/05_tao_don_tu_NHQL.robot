*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    ${headless_browser}
Test Setup        Before Test QL Dat Hang
Test Teardown     After Test
Resource          ../../../../../config/env_product/envi.robot
Resource          ../../../../../core/API/api_mhbh_dathang.robot
Resource          ../../../../../core/API/api_danhmuc_hanghoa.robot
Resource          ../../../../../core/API/api_dathang.robot
Resource          ../../../../../core/API/api_khachhang.robot
Resource          ../../../../../core/API/api_mhbh.robot
Resource          ../../../../../core/Dat_Hang/dat_hang_action.robot
Resource          ../../../../../core/Dat_Hang/dat_hang_navigation.robot
Resource          ../../../../../core/Dat_Hang/dat_hang_page.robot
Resource          ../../../../../core/share/toast_message.robot
Resource          ../../../../../core/API/api_soquy.robot
Resource          ../../../../../config/env_product/envi.robot
Resource          ../../../../../core/Giao_dich/dathang_list_action.robot

*** Variables ***
&{dict_product_nums01}    GHT0003=4.5   GHC0003=3     GHU0003=3.5  GHDV003=4    GHIM03=2
@{discount}    450000     5000.5   0     10   95000
@{discount_type}    changedown     disvnd    none    dis   changeup

*** Test Cases ***    Mã KH        GGDH           List product            List discount    List discount type     Khách thanh toán
Xu ly DH tu MHQL             [Tags]      EDX1      GOLIVE1  
                      [Template]    edhql1
                      DHDPT008       10            ${dict_product_nums01}    ${discount}    ${discount_type}        all
*** Keywords ***
edhql1
    [Arguments]    ${input_ma_kh}    ${input_ggdh_tocreate}   ${dict_product_nums}    ${list_discount}    ${list_discount_type}   ${input_khtt_tocreate}
    Set Selenium Speed    0.5s
    #get info product, customer
    ${order_code}   Add new order incase discount - payment    ${input_ma_kh}    ${input_ggdh_tocreate}    ${dict_product_nums}    ${list_discount}
    ...   ${list_discount_type}   ${input_khtt_tocreate}
    ${list_product}    Get Dictionary Keys    ${dict_product_nums}
    ${list_num}    Get Dictionary Values    ${dict_product_nums}
    Create list imei and other product    ${list_product}    ${list_num}
    ${order_code}    ${get_khachdatra_in_dh_bf_execute}    ${get_ggdh_in_dh_bf_execute}    ${get_tongtienhang_in_dh_bf_execute}    ${get_tongcong_in_dh_bf_execute}    Get order code - paid - discount value frm API    ${input_ma_kh}
    ${get_list_status_imei}   Get list imei status thr API    ${list_product}
    ${list_result_tongdh}    ${result_list_toncuoi}    ${result_list_thanhtien}    Get list order summary - total sale - ending stocks frm API    ${order_code}    ${list_product}
    #compute
    ${result_tongtienhang}    Sum values in list    ${result_list_thanhtien}
    ${result_TTH_tru_ggdh}    Run Keyword If    0 < ${get_ggdh_in_dh_bf_execute} < 100    Price after % discount invoice    ${result_tongtienhang}    ${get_ggdh_in_dh_bf_execute}
    ...    ELSE IF    ${get_ggdh_in_dh_bf_execute} > 100    Minus and replace floating point    ${result_tongtienhang}    ${get_ggdh_in_dh_bf_execute}
    ...    ELSE    Set Variable    ${result_tongtienhang}
    ${result_gghd}    Run Keyword If    0 < ${get_ggdh_in_dh_bf_execute} < 100    Convert % discount to VND and round    ${result_tongtienhang}    ${get_ggdh_in_dh_bf_execute}
    ...    ELSE    Set Variable    ${get_ggdh_in_dh_bf_execute}
    #create invoice from order
    Reload Page
    Search order code    ${order_code}
    Wait Until Page Contains Element    ${button_dh_xu_ly_dh}     30s
    Wait Until Keyword Succeeds    5 times    1s      Click Element     ${button_dh_xu_ly_dh}
    Wait Until Keyword Succeeds    30 times    3s    Select Window   url=${URL}/sale/#/
    Wait Until Keyword Succeeds    5 times    1s    Deactivate print preview page
    Wait Until Page Contains Element    ${button_taohoadon}     30s
    Go to BH frm process order    ${order_code}
    : FOR    ${item_product}    ${status_imei}    ${item_imei}    IN ZIP    ${list_product}    ${get_list_status_imei}    ${imei_inlist}
    \    Run Keyword If    '${status_imei}' == 'True'    Wait Until Keyword Succeeds    3 times    8 s    Input imei incase multi product to any form    ${item_product}    ${texbox_imei_search_multi_product}
    \    ...    ${item_serial_in_dropdown}    ${cell_imei_multi_product}    @{item_imei}    ELSE      Log     Ignore input
    Wait Until Keyword Succeeds    3 times    2s    Click Element JS    ${button_bh_thanhtoan}
    Invoice message success validation
    ${invoice_code}        Get saved code after execute
    #get value
    #Assert list of order summarry after execute    ${list_product}    ${list_result_tongdh}
    #assert value onhand
    #Assert list of onhand after order process    ${invoice_code}    ${list_product}    ${list_num}    ${result_list_toncuoi}
    #assert value order
    Assert order summary values until succeed    ${order_code}    ${input_ma_kh}    ${result_TTH_tru_ggdh}    ${result_TTH_tru_ggdh}    Hoàn thành
    Assert invoice summary values until succeed    ${invoice_code}    ${input_ma_kh}     ${result_tongtienhang}     ${result_gghd}    ${result_TTH_tru_ggdh}      ${result_TTH_tru_ggdh}    Hoàn thành
    #assert Customer
    Assert order info after execute    ${input_ma_kh}    3    ${get_tongtienhang_in_dh_bf_execute}    ${result_TTH_tru_ggdh}    ${result_gghd}
    ...    ${get_tongcong_in_dh_bf_execute}   0    ${order_code}
    Assert invoice info after execute    ${invoice_code}    ${input_ma_kh}    ${result_tongtienhang}    ${result_TTH_tru_ggdh}    ${result_TTH_tru_ggdh}
    ...    ${result_gghd}
    Delete invoice by invoice code    ${invoice_code}
    Delete order frm Order code    ${order_code}
