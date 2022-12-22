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
Resource          ../../../core/share/discount.robot
Resource          ../../../core/Tra_hang/tra_hang_action.robot
Resource          ../../../core/API/api_trahang.robot
Resource          ../../../core/Tra_hang/tra_hang_page.robot
Resource          ../../../core/Tra_hang/tra_hang_popup_page.robot
Resource          ../../../core/Ban_Hang/banhang_action.robot
Resource          ../../../core/Ban_Hang/banhang_page.robot
Resource          ../../../core/Ban_Hang/banhang_page.robot
Resource          ../../../core/API/api_dathangnhap.robot
Resource          ../../../core/Giao_dich/nhap_hang_add_page.robot
Resource          ../../../core/share/lodate.robot

*** Variables ***
&{list_product1}    LDQD02=2      TRLD01=5.6
&{list_product2}    LDQD04=2.5    TRLD03=3.5
&{list_product3}    LDQD06=4.3    TRLD05=4.8
@{list_discount}    20    10000.33
@{discount_type}    dis     disvnd

*** Test Cases ***
Tao DL mau
    [Tags]        LTHN               LTH            ULODA
    [Template]    Add du lieu
    lodate_unit    TRLD01      DHC ADLAY EXTRA     trackingld    75000    5000    none    none    none    none    none    Cai     LDQD01    140000    Hop    2
    lodate_unit    TRLD02    son BBIA màu 01    trackingld    75000    5000    none    none    none    none    none    Cai     LDQD02    140000    Hop    2
    lodate_unit    TRLD03      Mứt xoài sấy      trackingld    75000    5000    none    none    none    none    none    Cai     LDQD03    140000    Hop    2
    lodate_unit    TRLD04    son BBIA màu 02    trackingld    75000    5000    none    none    none    none    none    Cai     LDQD04    140000    Hop    2
    lodate_unit    TRLD05      Mứt dâu tây sấy     trackingld    70000    5000    none    none    none    none    none    Cai     LDQD05    140000    Hop    2
    lodate_unit    TRLD06    son BBIA màu 03    trackingld    75000    5000    none    none    none    none    none    Cai     LDQD06    140000    Hop    2

Tra_hang_nhanh
    [Tags]    LTHN                   LTH            ULODA
    [Template]     Tra hang nhanh lodate
    CTKH008      ${list_product2}    ${list_discount}    ${discount_type}         0        10              0

Tra_hang_lodate_co_gg
    [Tags]    LTHN                   LTH            ULODA
    [Template]     Tra hang nhanh lodate
    CTKH008      ${list_product1}    ${list_discount}    ${discount_type}         10000        20000           all
    CTKH008      ${list_product3}    ${list_discount}    ${discount_type}         15          0               200000

*** Keywords ***
Add du lieu
    [Documentation]    tao DL
    [Arguments]    ${loai_hh}    ${ma_hh}    ${ten_sp}    ${nhom_hang}    ${gia_ban}    ${gia_von}    ${ton}     ${sp_1}   ${sl_1}   ${sp_2}   ${sl_2}    ${dvcb}    ${ma_hh_qd}    ${giaban2}    ${dvqd}    ${giatriqd}
    Wait Until Keyword Succeeds    3x    15s    Delete product if product is visible thr API    ${ma_hh}
    Wait Until Keyword Succeeds    3x    15s    Add product for tracking by product type thr API    ${loai_hh}    ${ma_hh}    ${ten_sp}    ${nhom_hang}    ${gia_ban}    ${gia_von}    ${ton}     ${sp_1}   ${sl_1}   ${sp_2}   ${sl_2}    ${dvcb}    ${ma_hh_qd}    ${giaban2}    ${dvqd}    ${giatriqd}

Tra hang nhanh lodate
    [Arguments]    ${input_ma_kh}    ${dict_product_nums}    ${list_ggsp}    ${list_discount_type}    ${input_ggth}    ${input_phi_th}    ${input_khtt}
    Set Selenium Speed    0.5s
    ${get_id_kh}    ${get_ten_kh}    ${get_dienthoai_kh}    ${get_diachi_kh}    Create new customer and get info    ${input_ma_kh}
    #get info tra hang
    ${list_products}    Get Dictionary Keys    ${dict_product_nums}
    ${list_nums}    Get Dictionary Values    ${dict_product_nums}
    ${list_tenlo}    Create List
    : FOR    ${item_pr}    ${item_list_num}    IN ZIP    ${list_products}    ${list_nums}
    \    ${item_list_num}    Convert string to list    ${item_list_num}
    \    ${list_tenlo_by_pr}    Import multi lot for product and get list lots    ${item_pr}    ${item_list_num}
    \    Append To List    ${list_tenlo}    ${list_tenlo_by_pr}
    Log    ${list_tenlo}
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
    : FOR    ${item_product}    ${item_list_lo}    ${item_num}    ${item_discount}    ${item_discount_type}    ${item_newprice}    IN ZIP
    ...    ${list_products}    ${list_tenlo}    ${list_nums}    ${list_ggsp}    ${list_discount_type}    ${list_result_newprice}
    \    Wait Until Keyword Succeeds    3 times    8s    Input data in textbox and wait until it is visible    ${textbox_nh_search_hh}    ${item_product}    ${item_search_product_indropdow}    ${cell_bh_ma_sp}
    \    Input list lot name and list num of product to tra hang nhanh form    ${item_product}    ${item_list_lo}    ${item_num}
    \    Run Keyword If    0 < ${item_discount} <100    Wait Until Keyword Succeeds    3 times    3 s    Input % discount for product
    \    ...    ${item_discount}    ${item_newprice}
    \    ...    ELSE IF    ${item_discount} > 100    Wait Until Keyword Succeeds    3 times    3 s
    \    ...    Input VND discount for product    ${item_discount}    ${item_newprice}
    \    ...    ELSE    Log    Ignore discount input
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
