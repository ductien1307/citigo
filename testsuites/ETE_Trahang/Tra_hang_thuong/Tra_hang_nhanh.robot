*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    ${headless_browser}
Test Setup
Test Teardown     After Test
Resource          ../../../core/API/api_danhmuc_hanghoa.robot
Resource          ../../../core/API/api_khachhang.robot
Resource          ../../../core/API/api_mhbh.robot
Resource          ../../../core/share/toast_message.robot
Resource          ../../../core/API/api_soquy.robot
Resource          ../../../core/share/javascript.robot
Resource          ../../../core/share/imei.robot
Resource          ../../../core/share/discount.robot
Resource          ../../../core/Tra_hang/tra_hang_action.robot
Resource          ../../../core/API/api_trahang.robot
Resource          ../../../core/Tra_hang/tra_hang_page.robot
Resource          ../../../core/Tra_hang/tra_hang_popup_page.robot
Resource          ../../../core/Ban_Hang/banhang_action.robot
Resource          ../../../core/Ban_Hang/banhang_page.robot

*** Variables ***
&{list_product1}    HH0078=5.6    SI060=1    DVT79=3.5    DV084=2    Combo63=1
&{list_product2}    HH0079=5.6    SI061=2    DVT80=3.5    DV085=2    Combo64=1
&{list_product3}    HH0080=5.6    SI062=1    DVT81=3.5    DV086=2    Combo65=1
@{list_discount}    20    10000.33    0    200000.05    28000
@{discount_type}    dis     disvnd    none    changeup    changedown

*** Test Cases ***    Mã KH         List products       List GGSP          Discount type           GGTH     Phí trả hàng    Khách thanh toán
Giam_gia_golive              [Tags]        ETHN                      ET1          GOLIVE1
                      [Template]    eth01
                      CTKH123      ${list_product2}    ${list_discount}    ${discount_type}         0        10              0

Giam_gia              [Tags]        ETHN                      ET
                      [Template]    eth01
                      CTKH124      ${list_product1}    ${list_discount}    ${discount_type}         10000        20000           all
                      CTKH125      ${list_product3}    ${list_discount}    ${discount_type}         15       0               200000

*** Keywords ***
eth01
    [Arguments]    ${input_ma_kh}    ${dict_product_nums}    ${list_ggsp}    ${list_discount_type}    ${input_ggth}    ${input_phi_th}    ${input_khtt}
    Set Selenium Speed    0.5s
    #get info tra hang
    ${list_products}    Get Dictionary Keys    ${dict_product_nums}
    ${list_nums}    Get Dictionary Values    ${dict_product_nums}
    ${get_list_status_product}    Get list imei status thr API    ${list_products}
    Create invoice with imei product    ${input_ma_kh}    ${dict_product_nums}    ${get_list_status_product}
    #get data to validate
    ${get_list_baseprice}    Get list of Baseprice by Product Code    ${list_products}
    ${list_result_thanhtien}    ${list_giavon}    ${list_result_toncuoi}    ${list_result_newprice}    Get list total sale - endingstock - cost - newprice incase discount frm api    ${list_products}
    ...    ${list_nums}    ${list_ggsp}    ${list_discount_type}
    #compute
    ${result_tongtienhangtra}    Sum values in list and round    ${list_result_thanhtien}
    ${result_ggth}    Run Keyword If    0 < ${input_ggth} < 100    Convert % discount to VND and round    ${result_tongtienhangtra}    ${input_ggth}
    ...    ELSE    Set Variable    ${input_ggth}
    ${result_phi_th}    Run Keyword If    0 < ${input_phi_th} < 100    Convert % discount to VND and round    ${result_tongtienhangtra}    ${input_phi_th}
    ...    ELSE    Set Variable    ${input_phi_th}
    ${result_cantrakhach}    Minusx3 and replace foating point    ${result_tongtienhangtra}    ${result_ggth}    ${result_phi_th}
    ${result_khtt}    Set Variable If    "${input_khtt}" == "all"    ${result_cantrakhach}    ${input_khtt}
    ${actual_khtt}    Set Variable If    "${input_khtt}" == "0"    0    ${result_khtt}
    #create return in BH
    Wait Until Keyword Succeeds    3 times    8 s    Before Test Ban Hang deactivate print warranty
    Select Return without Invoice from BH page
    ${lastest_num}    Set Variable    0
    : FOR    ${item_product}     ${item_product_type}       ${item_num}        ${item_list_imei}    ${item_discount}      ${item_discount_type}     ${item_newprice}    IN ZIP    ${list_products}       ${get_list_status_product}
    ...    ${list_nums}    ${imei_inlist}       ${list_ggsp}    ${list_discount_type}      ${list_result_newprice}
    \    ${lastest_num}=        Run Keyword If    '${item_product_type}' == 'True'    Input product and its imei to any form and return lastest number    ${textbox_bh_search_ma_sp}    ${item_product}    ${item_num}    ${item_search_product_indropdow}    ${textbox_nhap_serial}
    \    ...    ${item_serial_in_dropdown}    ${cell_bh_ma_sp}    ${cell_item_input_imei}    ${lastest_num}    @{item_list_imei}       ELSE      Input product-num in sale form    ${item_product}
    \    ...    ${item_num}    ${lastest_num}    ${cell_laster_numbers_return}
    \    Run keyword if    '${item_discount_type}' == 'dis'    Wait Until Keyword Succeeds    3 times    5 s    Input % discount for multi product    ${item_product}    ${item_discount}    ${item_newprice}
    \    ...    ELSE IF    '${item_discount_type}' == 'disvnd'    Wait Until Keyword Succeeds    3 times    5 s    Input VND discount for multi product    ${item_product}    ${item_discount}    ${item_newprice}
    \    ...    ELSE IF     '${item_discount_type}' == 'changeup' or '${item_discount_type}' == 'changedown'  Wait Until Keyword Succeeds    3 times    5 s    Input newprice for multi product    ${item_product}    ${item_discount}        ELSE       Log        ignore
    Wait Until Keyword Succeeds    3 times    5 s    Input Khach Hang    ${input_ma_kh}
    Wait Until Keyword Succeeds    3 times    5 s    Run keyword if    0 < ${input_ggth} < 100    Input % discount return    ${input_ggth}
    ...    ${result_ggth}
    ...    ELSE    Input VND discount return    ${input_ggth}
    Wait Until Keyword Succeeds    3 times    5 s    Run keyword if    0 < ${input_phi_th} < 100    Input % return free value    ${input_phi_th}
    ...    ${result_phi_th}    ELSE    Input VND return free value    ${input_phi_th}
    Wait Until Keyword Succeeds    3 times    5 s    Run Keyword If    "${input_khtt}" == "all"    Click Element JS    ${button_th}
    ...    ELSE    Input payment into any form    ${textbox_th_khachttTraHang}    ${input_khtt}    ${button_th}
    Sleep    1s
    Return message success validation
    ${return_code}    Get saved code after execute
    #assert value product in invoice
    Assert list of onhand after order process    ${return_code}    ${list_products}    ${list_nums}    ${list_result_toncuoi}
    #assert value in return
    Assert values by return code until succeed    ${return_code}    ${result_tongtienhangtra}    ${result_ggth}    ${result_phi_th}    ${result_cantrakhach}    ${actual_khtt}
    Assert return summary values until succeed    ${return_code}    ${input_ma_kh}     ${actual_khtt}    1
    Delete return thr API        ${return_code}
