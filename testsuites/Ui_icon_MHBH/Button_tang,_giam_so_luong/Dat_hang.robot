*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    ${headless_browser}
Test Setup        Before Test Ban Hang
Test Teardown     After Test
Library           SeleniumLibrary
Library           StringFormat
Resource          ../../../core/Ban_Hang/banhang_action.robot

*** Variables ***
&{pr_num}         GHU0002=5    HH0042=3
&{pr_num1}        GHU0003=8    HH0044=7
@{list_qty_down}    4    3

*** Test Cases ***    Dict sp - sl tang    Dict sp - sl giamL input    List sl giam
Hoa don               [Tags]               CUI
                      [Template]           tgdh
                      ${pr_num}            ${pr_num1}                  ${list_qty_down}

*** Keywords ***
tgdh
    [Arguments]    ${dict_product_num_up}    ${dict_product_num_down}    ${list_num}
    Wait Until Keyword Succeeds    3 times    5 s    Click Element JS    ${tab_dathang}
    ${list_products_up}    Get Dictionary Keys    ${dict_product_num_up}
    ${list_nums_up}    Get Dictionary Values    ${dict_product_num_up}
    ${list_products_down}    Get Dictionary Keys    ${dict_product_num_down}
    ${list_nums_down}    Get Dictionary Values    ${dict_product_num_down}
    ${start_num}    Set Variable    1
    ${lastest_num}    Set Variable    0
    : FOR    ${item_product}    ${item_num}    IN ZIP    ${list_products_up}    ${list_nums_up}
    \    ${lastest_num}    Sum    ${lastest_num}    ${item_num}
    \    ${lastest_num}    Input product and click button up quantity in MHBH    ${item_product}    ${lastest_num}    ${start_num}    ${cell_tongsoluong_dh}
    \    ${start_num}    Sum    ${lastest_num}    1
    Log    ${lastest_num}
    : FOR    ${item_product}    ${item_num}    ${item_num_down}    IN ZIP    ${list_products_down}    ${list_nums_down}
    ...    ${list_num}
    \    ${lastest_num}    Input product - num and click button down quantity in MHBH    ${item_product}    ${item_num}    ${item_num_down}    ${lastest_num}
    \    ...    ${cell_tongsoluong_dh}
    Log    ${lastest_num}
