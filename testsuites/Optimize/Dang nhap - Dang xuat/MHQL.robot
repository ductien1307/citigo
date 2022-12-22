*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    ${headless_browser}
Test Setup        Before Test Ban Hang
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
&{invoice_1}      PIB10028=1    PIB10035=2
@{discount_type_1}    dis    changedown
@{discount_1}     10    150000

*** Test Cases ***      SP-SL           Discount         Discount type         GGHD         Khách tt
DN - DX tu QL           [Tags]      OPT1
                      [Template]      opdndx1
                      ${invoice_1}    ${discount_1}    ${discount_type_1}       10           all

*** Keywords ***
opdndx1
      [Arguments]     ${dict_product_num}    ${list_discount_product}    ${list_discount_type}    ${input_invoice_discount}
      ...    ${input_bh_khachtt}
      ## Get info ton cuoi, cong no khach hang
      ${list_product}    Get Dictionary Keys    ${dict_product_num}
      ${list_nums}    Get Dictionary Values    ${dict_product_num}
      # Input data into BH form
      ${list_result_ton_af_ex}    Get list of result onhand incase changing product price    ${list_product}    ${list_nums}
      ${list_result_thanhtien}    ${list_result_newprice}    Get list of total sale - result new price incase changing product price    ${list_product}    ${list_nums}    ${list_discount_product}    ${list_discount_type}
      ${lastest_num}    Set Variable    0
      : FOR    ${item_product}    ${item_num}    ${item_discount}    ${item_discount_type}    ${item_newprice}    IN ZIP
      ...    ${list_product}    ${list_nums}    ${list_discount_product}    ${list_discount_type}    ${list_result_newprice}
      \    Input product-num in BH form    ${item_product}    ${item_num}    ${lastest_num}
      \    Run keyword if    '${item_discount_type}' == 'dis'    Wait Until Keyword Succeeds    3 times    5 s    Input % discount for product
      \    ...    ${item_discount}    ${item_newprice}
      \    ...    ELSE IF    '${item_discount_type}' == 'disvnd'    Wait Until Keyword Succeeds    3 times    5 s
      \    ...    Input vnd discount for product    ${item_discount}    ${item_newprice}
      \    ...    ELSE IF    '${item_discount_type}' == 'changeup' or '${item_discount_type}' == 'changedown'    Wait Until Keyword Succeeds    3 times    5 s
      \    ...    Input new price of product    ${item_discount}
      \    ...    ELSE    Log    ignore
      ${result_tongtienhang}    Sum values in list    ${list_result_thanhtien}
      ${result_khachcantra}=    Run Keyword If    0 < ${input_invoice_discount} < 100    Price after % discount invoice    ${result_tongtienhang}    ${input_invoice_discount}
      ...    ELSE IF    ${input_invoice_discount} > 100    Minus    ${result_tongtienhang}    ${input_invoice_discount}
      ...    ELSE    Set Variable    ${result_tongtienhang}
      ${result_discount_invoice}    Run Keyword If    0 < ${input_invoice_discount} < 100    Convert % discount to VND and round    ${result_tongtienhang}    ${input_invoice_discount}
      ...    ELSE    Set Variable    ${input_invoice_discount}
      ${actual_khachtt}    Set Variable If    '${input_bh_khachtt}' == 'all'    ${result_khachcantra}    ${input_bh_khachtt}
      Run Keyword If    0 < ${input_invoice_discount} < 100    Wait Until Keyword Succeeds    3 times    8 s    Input % discount invoice    ${input_invoice_discount}
      ...    ${result_discount_invoice}
      ...    ELSE IF    ${input_invoice_discount} > 100    Input VND discount invoice    ${input_invoice_discount}
      ...    ELSE    Log    Ignore invoice discount
      Run Keyword If    '${input_bh_khachtt}' == 'all'    Log    Ignore
      ...    ELSE        Wait Until Keyword Succeeds    3 times    20 s    Input customer payment and validate    ${textbox_bh_khachtt}    ${input_bh_khachtt}    ${result_khachcantra}
      Click Element JS    ${button_bh_thanhtoan}
      Invoice message success validation
      ${invoice_code}    Get saved code after execute
      #get values
      Sleep    20s    wait for response to API
      #assert values in Hoa don
      ${get_ma_kh_by_hd}    ${get_tong_tien_hang}    ${get_khach_tt}    ${get_giamgia_hd}    ${get_khachcantra}    ${get_trangthai}    Get invoice info incase discount by invoice code
      ...    ${invoice_code}
      Run Keyword If    ${input_invoice_discount} == 0    Should Be Equal As Numbers    ${get_khachcantra}    ${result_tongtienhang}
      ...    ELSE    Should Be Equal As Numbers    ${get_tong_tien_hang}    ${result_tongtienhang}
      Run Keyword If    ${input_invoice_discount} == 0    Log    Ignore validate
      ...    ELSE    Should Be Equal As Numbers    ${get_tong_tien_hang}    ${result_tongtienhang}
      Should Be Equal As Numbers    ${get_khachcantra}    ${result_khachcantra}
      Should Be Equal As Numbers    ${get_khach_tt}    ${actual_khachtt}
      Should Be Equal As Numbers    ${get_giamgia_hd}    ${result_discount_invoice}
      Should Be Equal As Strings    ${get_trangthai}    Hoàn thành
      Delete invoice by invoice code    ${invoice_code}
      Logout MHBH
      Login MHBH       ${USER_NAME}    ${PASSWORD}
