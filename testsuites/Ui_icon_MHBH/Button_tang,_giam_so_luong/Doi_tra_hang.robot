*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    ${headless_browser}
Test Setup        Before Test Ban Hang
Test Teardown     After Test
Library           SeleniumLibrary
Library           StringFormat
Resource          ../../../core/Ban_Hang/banhang_action.robot

*** Variables ***
&{pr_num_th}      GHQD0004=4    HH0043=5
&{pr_num_th1}     HH0044=7    HH0045=8
@{list_qty_down_th}    3    4
&{pr_num_dh}      NHP001=3    NHP002=2
&{pr_num_dh1}     NHP003=7    NHP004=8
@{list_qty_down_dh}    3    4

*** Test Cases ***    Dict th         sp - sl tang     Dict th sp - sl giamL input    List th         sl giam          Dict dh sp - sl tang    Dict dh sp - sl giamL input    List dh sl giam
Hoa don               [Tags]          CUI
                      [Template]      tgdt
                      ${pr_num_th}    ${pr_num_th1}    ${list_qty_down_th}            ${pr_num_dh}    ${pr_num_dh1}    ${list_qty_down_dh}

*** Keywords ***
tgdt
    [Arguments]    ${dict_th_product_num_up}    ${dict_th_product_num_down}    ${list_th_num}    ${dict_dh_product_num_up}    ${dict_dh_product_num_down}    ${list_dh_num}
    Select Return without Invoice from BH page
    ${list_th_products_up}    Get Dictionary Keys    ${dict_th_product_num_up}
    ${list_th_nums_up}    Get Dictionary Values    ${dict_th_product_num_up}
    ${list_th_products_down}    Get Dictionary Keys    ${dict_th_product_num_down}
    ${list_th_nums_down}    Get Dictionary Values    ${dict_th_product_num_down}
    ${list_dh_products_up}    Get Dictionary Keys    ${dict_dh_product_num_up}
    ${list_dh_nums_up}    Get Dictionary Values    ${dict_dh_product_num_up}
    ${list_dh_products_down}    Get Dictionary Keys    ${dict_dh_product_num_down}
    ${list_dh_nums_down}    Get Dictionary Values    ${dict_dh_product_num_down}
    # form tra hang
    ${start_num_th}    Set Variable    1
    ${lastest_num_th}    Set Variable    0
    : FOR    ${item_product}    ${item_num}    IN ZIP    ${list_th_products_up}    ${list_th_nums_up}
    \    ${lastest_num_th}    Sum    ${lastest_num_th}    ${item_num}
    \    ${lastest_num_th}    Input product and click button up quantity in MHBH    ${item_product}    ${lastest_num_th}    ${start_num_th}    ${cell_laster_numbers_return}
    \    ${start_num_th}    Sum    ${lastest_num_th}    1
    Log    ${lastest_num_th}
    : FOR    ${item_product}    ${item_num}    ${item_num_down}    IN ZIP    ${list_th_products_down}    ${list_th_nums_down}
    ...    ${list_th_num}
    \    ${lastest_num_th}    Input product - num and click button down quantity in MHBH    ${item_product}    ${item_num}    ${item_num_down}    ${lastest_num_th}
    \    ...    ${cell_laster_numbers_return}
    Log    ${lastest_num_th}
    # form đổi hàng
    ${start_num_dh}    Set Variable    1
    ${lastest_num_dh}    Set Variable    0
    : FOR    ${item_product}    ${item_num}    IN ZIP    ${list_dh_products_up}    ${list_dh_nums_up}
    \    ${lastest_num_dh}    Sum    ${lastest_num_dh}    ${item_num}
    \    ${lastest_num_dh}    Input product and click button up quantity in Doi tra hang form    ${item_product}    ${lastest_num_dh}    ${start_num_dh}    ${cell_tongsoluong_hangdoi}
    \    ${start_num_dh}    Sum    ${lastest_num_dh}    1
    Log    ${lastest_num_dh}
    : FOR    ${item_product}    ${item_num}    ${item_num_down}    IN ZIP    ${list_dh_products_down}    ${list_dh_nums_down}
    ...    ${list_dh_num}
    \    ${lastest_num}    Input product - num and click button down quantity in Doi tra hang form    ${item_product}    ${item_num}    ${item_num_down}    ${lastest_num_dh}
    \    ...    ${cell_tongsoluong_hangdoi}
    Log    ${lastest_num}
