*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    ${headless_browser}
Test Setup        Before Test Banhang By Sale URL
Test Teardown     After Test
Library           SeleniumLibrary
Resource         ../../../core/Thiet_lap/thiet_lap_nav.robot
Resource         ../../../core/Thiet_lap/nguoidung_list_page.robot
Resource         ../../../core/Thiet_lap/nguoidung_list_action.robot
Resource         ../../../core/API/api_thietlap.robot
Resource         ../../../core/share/toast_message.robot
Resource         ../../../prepare/Hang_hoa/Sources/thietlap.robot
Resource         ../../../core/Thiet_lap/khuyenmai_list_page.robot

*** Variables ***
&{invoice_1}      TPD026=7

*** Test Cases ***      SP-SL           Discount         Discount type         GGHD        Khách tt
DN - DX tu BH           [Tags]      OPT1      
                      [Template]      opdndx2
                      ${invoice_1}

*** Keywords ***
opdndx2
      [Arguments]     ${dict_product_num}
      ## Get info ton cuoi, cong no khach hang
      ${list_product}    Get Dictionary Keys    ${dict_product_num}
      ${list_nums}    Get Dictionary Values    ${dict_product_num}
      # Input data into BH form
      ${lastest_num}    Set Variable    0
      : FOR    ${item_product}    ${item_num}     IN ZIP      ${list_product}    ${list_nums}
      \    Input product-num in BH form    ${item_product}    ${item_num}    ${lastest_num}
      Click Element JS    ${button_bh_thanhtoan}
      Invoice message success validation
      ${invoice_code}    Get saved code after execute
      #get values
      Logout MHBH
      Login MHBH     ${USER_NAME}    ${PASSWORD}
