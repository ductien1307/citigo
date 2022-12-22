*** Settings ***
Library           SeleniumLibrary
Resource          constants.robot
Resource          javascript.robot
Library           String
Resource          computation.robot
Resource          ../Ban_Hang/banhang_page.robot
Resource          ../Tra_hang/tra_hang_page.robot

*** Variables ***
${button_giamgia_hd}    //div[contains(@class, 'payment-component')]//div[contains(@class, 'form-group') and ./label[contains(text(), 'Giảm giá')]]//button[contains(@uib-popover-template, 'discountInvoice')]
${textbox_giamgia_hd_vnd}    //input[@id='popover-discountValue']
${button_giamgia_hd_%}    //div[contains(@class, 'popover-content')]//kv-toggle/a[contains(@class, 'toggle-btn') and text()='%']
${textbox_giamgia_hd_%}    //div[@class='form-output kv-toggle']//input[@type='text']
${button_giamoi}    //div[contains(@class, 'row-product')]//div[contains(@class, 'cell-change-price')]//button[contains(@class, 'form-control')]
${textbox_giaban}    //label[span[text()='Giá bán']]//..//input
${textbox_dongia}    //input[@id='newPriceIpt']
${textbox_giamgia_sp}    //input[@id='priceInput']
${button_giamgia_sp%}    //a[@class='toggle-btn' and text()='%']
${button_giamgia_dh}    //div[contains(@class, 'payment-component')]//label[contains(text(), 'Giảm giá ')]/..//button[contains(@uib-popover-template, 'discountOrderCart' )]
##xpath for multi product
${button_multi_giamoi}    //div[contains(@class, 'row-list')]//div[contains(@class, 'row-product')]//div[text()='{0}']//..//..//..//div[contains(@class, 'cell-change-price')]//button    #ma san pham
${text_result_invoice_discount}    //payment-invoice-component//div[@class='payment-component-child']//div[label[contains(text(), 'Giảm giá')]]/label
${cell_tinhvaocongno_order}    //payment-order-component//div[@class='payment-refun payment-component-child']//div[@class='form-group']//div[@class='radio form-label control-label ng-hide'][label[span[span[contains(text(),'Tiền thừa trả khách')]]]]/following-sibling::div[1]
${cell_tinhvaocongno_invoice}    //payment-invoice-component//div[@class='payment-refun payment-component-child']//div[@class='form-group']//div[@class='radio form-label control-label ng-hide'][label[span[span[contains(text(),'Tiền thừa trả khách')]]]]/following-sibling::div[1]
${cell_update_payment}    //payment-order-component//div[@class='payment-refun payment-component-child']//div[@class='form-group']//div[contains(@class, 'radio')][label[span[span[contains(text(), 'Tiền thừa trả khách')]]]]/following-sibling::div[1]
${target_giamgia_dh}    //payment-order-component//div[contains(@class, 'payment-component')]//div[contains(@class,'form-group')][2]//button[contains(@uib-popover-template, 'discountOrderCart' )]
## pop up discount nhieu dong
${button_giaban_multirow}    //cart-item-duplication-component//div[contains(@class,'popup-anchor')]//button[contains(@class,'cart-item-{0}')]    #số thứ tự dòng bắt đầu từ 0
${button_giaban_multi_productrow}    //div[contains(@class,'row-list')]//input[@id='extraInput_{0}_0']//..//..//div[contains(@class,'cell-change-price')]//button    #id product
${textbox_giamgia_multirow}    //input[@id='priceInput']
${textbox_giamoi_multirow}    //input[@id='adjustPriceIpt']
${button_changeprice_by_line}    //div[div[input[@id='extraInput_{0}_{1}']]]//button[@kv-popup-anchor='productPrice']

*** Keyword ***
Input VND discount invoice
    [Arguments]    ${input_giamgia_hd_vnd}
    [Timeout]    5 minutes
    Wait Until Page Contains Element    ${button_giamgia_hd}    3s
    Click Element JS    ${button_giamgia_hd}
    Wait Until Keyword Succeeds    3 times    3s    Input data    ${textbox_giamgia_hd_vnd}    ${input_giamgia_hd_vnd}
    ${newprice_invoice}    Get New price from UI    ${button_giamgia_hd}
    Should Be Equal As Numbers    ${newprice_invoice}    ${input_giamgia_hd_vnd}

Input VND discount invoice incase promotion discount
    [Arguments]    ${input_giamgia_hd_vnd}    ${result_total_invoice_discount}
    [Timeout]    5 minutes
    Wait Until Page Contains Element    ${button_giamgia_hd}    3s
    Click Element JS    ${button_giamgia_hd}
    Wait Until Keyword Succeeds    3 times    3s    Input data    ${textbox_giamgia_hd_vnd}    ${input_giamgia_hd_vnd}
    ${newprice_invoice}    Get New price from UI    ${button_giamgia_hd}
    Should Be Equal As Numbers    ${newprice_invoice}    ${result_total_invoice_discount}

Input % discount invoice
    [Arguments]    ${input_giamgia_hd_%}    ${result_discount_by_vnd}
    [Timeout]    5 minutes
    Wait Until Page Contains Element    ${button_giamgia_hd}    3s
    Click Element JS    ${button_giamgia_hd}
    Wait Until Page Contains Element    ${button_giamgia_hd_%}    3s
    Click Element JS    ${button_giamgia_hd_%}
    Wait Until Keyword Succeeds    3 times    3s    Input data    ${textbox_giamgia_hd_%}    ${input_giamgia_hd_%}
    ${discount_by_vnd}    Get New price from UI    ${button_giamgia_hd}
    Should Be Equal As Numbers    ${discount_by_vnd}    ${result_discount_by_vnd}

Input VND discount for product
    [Arguments]    ${input_giamgia_vnd}    ${new_price}
    [Timeout]    5 minutes
    Click Element JS    ${button_giamoi}
    Wait Until Page Contains Element    ${textbox_giamgia_sp}    3s
    Wait Until Keyword Succeeds    3 times    3 s    Input data    ${textbox_giamgia_sp}    ${input_giamgia_vnd}
    ${discount_product}    Get New price from UI    ${button_giamoi}
    Should Be Equal As Numbers    ${discount_product}    ${new_price}

Input VND product discount incase muli-row for any form
    [Arguments]    ${index_row}    ${product_id}    ${button_changeprice}    ${textbox_input_discount}    ${discount}    ${new_price}
    [Timeout]    5 minutes
    ${button_changeprice_by_line_formatted}    Format String    ${button_changeprice}    ${product_id}    ${index_row}
    Click Element JS    ${button_changeprice_by_line_formatted}
    Wait Until Page Contains Element    ${textbox_input_discount}    3s
    Wait Until Keyword Succeeds    3 times    3 s    Input data    ${textbox_input_discount}    ${discount}
    ${discount_product}    Get New price from UI    ${button_changeprice}
    Should Be Equal As Numbers    ${discount_product}    ${new_price}

Input % discount for product
    [Arguments]    ${input_giamgia_%}    ${input_result_newprice_by_vnd}
    [Timeout]    5 minutes
    Click Element JS    ${button_giamoi}
    Wait Until Page Contains Element    ${button_giamgia_sp%}
    Click Element JS    ${button_giamgia_sp%}
    Wait Until Page Contains Element    ${textbox_giamgia_sp}    3s
    Wait Until Keyword Succeeds    3 times    3 s    Input data    ${textbox_giamgia_sp}    ${input_giamgia_%}
    Sleep  1s
    ${discount_price}    Get New price from UI    ${button_giamoi}
    Should Be Equal As Numbers    ${discount_price}    ${input_result_newprice_by_vnd}

Input % product discount multi-row for any form
    [Arguments]    ${index_row}    ${product_id}    ${button_changeprice}    ${button_toggle_discount_ratio}    ${textbox_input_discount}    ${discount}
    ...    ${result_newprice_by_vnd}
    [Timeout]    5 minutes
    ${button_changeprice_by_line}    Format String    ${button_changeprice}    ${product_id}    ${index_row}
    Click Element JS    ${button_changeprice_by_line}
    Wait Until Page Contains Element    ${button_toggle_discount_ratio}
    Click Element JS    ${button_toggle_discount_ratio}
    Wait Until Page Contains Element    ${textbox_input_discount}    3s
    Wait Until Keyword Succeeds    3 times    3 s    Input data    ${textbox_input_discount}    ${discount}
    ${discount_price}    Get New price from UI    ${button_changeprice_by_line}
    Should Be Equal As Numbers    ${discount_price}    ${result_newprice_by_vnd}

Input Product New Price multi-row for any form
    [Arguments]    ${index_row}    ${product_id}    ${button_changeprice}    ${textbox_newprice}    ${newprice}
    [Timeout]    5 minutes
    ${button_changeprice_by_line}    Format String    ${button_changeprice}    ${product_id}    ${index_row}
    Click Element JS    ${button_changeprice_by_line}
    Wait Until Page Contains Element    ${textbox_newprice}    3s
    Wait Until Keyword Succeeds    3 times    3 s    Input data    ${textbox_newprice}    ${newprice}
    ${ui_newprice}    Get New price from UI    ${button_changeprice_by_line}
    Should Be Equal As Numbers    ${ui_newprice}    ${newprice}

Input new price of product
    [Arguments]    ${input_giamoi}
    [Timeout]    5 minutes
    Click Element JS    ${button_giamoi}
    Wait Until Page Contains Element    ${textbox_giaban}    3s
    Wait Until Keyword Succeeds    3 times    3 s    Input data    ${textbox_giaban}    ${input_giamoi}
    ${newprice}    Get New price from UI    ${button_giamoi}
    Should Be Equal As Numbers    ${newprice}    ${input_giamoi}

Input data
    [Arguments]    ${textbox_location}    ${input_text}
    [Timeout]    3 mins
    Set Selenium Speed    0.1 s
    Wait Until Element Is Enabled    ${textbox_location}    10 s
    Clear Element Text    ${textbox_location}
    Set Focus To Element    ${textbox_location}
    sleep    1 s
    Input Type Flex    ${textbox_location}    ${input_text}
    Press Key    ${textbox_location}    ${ENTER_KEY}

Input VND discount order
    [Arguments]    ${input_giamgia_vnd}
    Click Element JS    ${button_giamgia_dh}
    Wait Until Page Contains Element    ${textbox_giamgia_hd_vnd}    1 min
    Wait Until Keyword Succeeds    3 times    2s    Input data    ${textbox_giamgia_hd_vnd}    ${input_giamgia_vnd}
    Press Key    ${textbox_giamgia_hd_vnd}    ${ESC_KEY}
    ${newprice_invoice}    Get New price from UI    ${target_giamgia_dh}
    Should Be Equal As Numbers    ${newprice_invoice}    ${input_giamgia_vnd}

Input % discount order
    [Arguments]    ${input_giamgia_invoice%}    ${result_discount_by_vnd}
    [Timeout]    5 mins
    Click Element JS    ${button_giamgia_dh}
    Wait Until Page Contains Element    ${button_giamgia_hd_%}    1 min
    Click Element JS    ${button_giamgia_hd_%}
    Wait Until Keyword Succeeds    3 times    3s    Input data    ${textbox_giamgia_hd_%}    ${input_giamgia_invoice%}
    Press Key    ${textbox_giamgia_hd_%}    ${ESC_KEY}
    ${discount_by_vnd}    Get New price from UI    ${target_giamgia_dh}
    Should Be Equal As Numbers    ${discount_by_vnd}    ${result_discount_by_vnd}

Input data in textbox and wait until it is visible
    [Arguments]    ${textbox_location}    ${input_text}    ${xpath_item_dropdown}    ${target_locator}
    [Timeout]
    Wait Until Page Contains Element    ${textbox_location}    1 min
    Input text    ${textbox_location}    ${input_text}
    KV Click Element JS By Code   ${xpath_item_dropdown}    ${input_text}
    Wait Until Keyword Succeeds    3x    3s    Element Should Contain    ${target_locator}    ${input_text}

Input data in textbox and click
    [Arguments]    ${textbox_location}    ${input_text}    ${xpath_item_dropdown}    ${target_locator}
    [Timeout]
    Wait Until Page Contains Element    ${textbox_location}    1 min
    Input text    ${textbox_location}    ${input_text}
    Sleep    3 s
    ${item_dropdownlist}    Format String    ${xpath_item_dropdown}    ${input_text}
    Wait Until Element Is Visible    ${item_dropdownlist}    30 s
    Click Element JS    ${item_dropdownlist}
    Sleep    5s
    Element Should Contain    ${target_locator}    ${input_text}

Input data in textbox and click item in dropdown
    [Arguments]    ${textbox_location}    ${input_text}    ${xpath_item_dropdown}
    [Timeout]
    Wait Until Page Contains Element    ${textbox_location}    1 min
    Input text    ${textbox_location}    ${input_text}
    Sleep    3 s
    ${item_dropdownlist}    Format String    ${xpath_item_dropdown}    ${input_text}
    Wait Until Element Is Visible    ${item_dropdownlist}    30 s
    Click Element JS    ${item_dropdownlist}
    Sleep   2s

Input data and click item in dropdownlist
    [Arguments]    ${textbox_location}    ${input_text}    ${xpath_item_dropdown}
    [Timeout]
    Wait Until Page Contains Element    ${textbox_location}    1 min
    Input text    ${textbox_location}    ${input_text}
    Sleep    1 s
    ${item_dropdownlist}    Format String    ${xpath_item_dropdown}    ${input_text}
    Wait Until Element Is Visible    ${item_dropdownlist}    30 s
    Click Element JS    ${item_dropdownlist}

Input product in textbox and click
    [Arguments]     ${ma_hh}
    KV Input Text    ${textbox_bh_search_ma_sp}    ${ma_hh}
    KV Click Element JS By Code    ${cell_sanpham}    ${ma_hh}

Input item in dropdownlist
    [Arguments]    ${cell_click_to_select}    ${input_text}    ${item_to_select}
    Click Element    ${cell_click_to_select}
    ${tem_by_input}    Format String    ${item_to_select}    ${input_text}
    Wait Until Page Contains Element    ${tem_by_input}    1 min
    Click Element    ${tem_by_input}

Input gia moi with multi product
    [Arguments]    ${input_ma_hh}    ${input_giamoi}
    ${button_multi_giamoi}    Format String    ${button_multi_giamoi}    ${input_ma_hh}
    Click Element JS    ${button_multi_giamoi}
    Wait Until Page Contains Element    ${textbox_giaban}    2 mins
    Wait Until Keyword Succeeds    3 times    3s    Input data    ${textbox_giaban}    ${input_giamoi}

Input VND discount for multi product
    [Arguments]    ${input_ma_sp}    ${input_giamgia_vnd}    ${new_price}
    ${button_multi_giamoi}    Format String    ${button_multi_giamoi}    ${input_ma_sp}
    Click Element JS    ${button_multi_giamoi}
    Wait Until Page Contains Element    ${textbox_giamgia_sp}    3s
    Wait Until Keyword Succeeds    3 times    2s    Input data    ${textbox_giamgia_sp}    ${input_giamgia_vnd}
    Wait Until Keyword Succeeds    3 times    2s    Validate discount product    ${input_ma_sp}    ${new_price}

Validate discount product
    [Arguments]    ${input_ma_sp}    ${new_price}
    ${discount_product}    Get New price by xpath    ${input_ma_sp}
    Should Be Equal As Numbers    ${discount_product}    ${new_price}

Input % discount for multi product
    [Arguments]    ${input_ma_sp}    ${input_giamgia_%}    ${input_result_newprice_by_vnd}
    ${button_multi_giamoi}    Format String    ${button_multi_giamoi}    ${input_ma_sp}
    Click Element JS    ${button_multi_giamoi}
    Wait Until Page Contains Element    ${button_giamgia_sp%}
    Click Element JS    ${button_giamgia_sp%}
    Wait Until Page Contains Element    ${textbox_giamgia_sp}    3s
    Wait Until Keyword Succeeds    3 times    2s    Input data    ${textbox_giamgia_sp}    ${input_giamgia_%}
    Wait Until Keyword Succeeds    3 times    2s    Validate discount product    ${input_ma_sp}    ${input_result_newprice_by_vnd}

Input Type Flex
    [Arguments]    ${locator}    ${text}
    [Documentation]    write text letter by letter
    Wait Until Element Is Visible    ${locator}
    Clear Element Text    ${locator}
    ${items}    Get Length    ${text}
    : FOR    ${item}    IN RANGE    0    ${items}
    \    Log    ${text[${item}]}
    \    Press Key    ${locator}    ${text[${item}]}

Get New price from UI
    [Arguments]    ${locator}
    [Documentation]    write text letter by letter
    Wait Until Page Contains Element    ${locator}    2 mins
    ${get_text_newprice}    Get text    ${locator}
    ${get_text_newprice}    Replace String    ${get_text_newprice}    ,    ${EMPTY}
    ${newprice}    Convert To Number    ${get_text_newprice}
    Return From Keyword    ${newprice}

Get New price of Invoice from UI
    [Arguments]    ${locator}
    [Documentation]    write text letter by letter
    ${get_text_newprice}    Get text    ${text_result_invoice_discount}
    ${get_text_newprice}    Replace String    ${get_text_newprice}    ,    ${EMPTY}
    ${newprice}    Convert To Number    ${get_text_newprice}
    Return From Keyword    ${newprice}

Input customer payment and validate
    [Arguments]    ${textbox_khachtt}    ${input_bh_khachtt}    ${input_khachcantra}
    Wait Until Keyword Succeeds    3 times    3s    Input data    ${textbox_khachtt}    ${input_bh_khachtt}
    ${cell_change_to_customer}    Get Change to customer from UI    ${cell_tienthua_trakhach}
    ${result_change_to_customer}    Minus    ${input_khachcantra}    ${input_bh_khachtt}
    Should Be Equal As Numbers    ${result_change_to_customer}    ${cell_change_to_customer}

Input customer surplus payment and validate
    [Arguments]    ${textbox_khachtt}    ${input_bh_khachtt}    ${input_tinhcongnokh}
    Wait Until Keyword Succeeds    3 times    3s    Input data    ${textbox_khachtt}    ${input_bh_khachtt}
    ${cell_change_to_customer}    Get Change to customer from UI    ${cell_tienthua_trakhach}
    Should Be Equal As Numbers    ${input_tinhcongnokh}    ${cell_change_to_customer}

Get Change to customer from UI
    [Arguments]    ${locator}
    [Documentation]    write text letter by letter
    ${get_text_newprice}    Get text    ${locator}
    ${get_text_newprice}    Replace String    ${get_text_newprice}    -    ${EMPTY}
    ${get_text_newprice}    Replace String    ${get_text_newprice}    ,    ${EMPTY}
    ${newprice}    Convert To Number    ${get_text_newprice}
    Return From Keyword    ${newprice}

Get New price by xpath
    [Arguments]    ${input_ma_sp}
    ${button_multi_giamoi}    Format String    ${button_multi_giamoi}    ${input_ma_sp}
    ${newprice}    Get New price from UI    ${button_multi_giamoi}
    Return From Keyword    ${newprice}

Input payment from customer
    [Arguments]    ${textbox_locator_payment}    ${input_value_payment}    ${result_khachcantra}    ${cell_tinhvaocongno}
    ${result_khtt}    Minus and round    ${input_value_payment}    ${result_khachcantra}
    Wait Until Page Contains Element    ${textbox_locator_payment}    1 min
    Wait Until Keyword Succeeds    3 times    3s    Input data    ${textbox_locator_payment}    ${input_value_payment}
    Validate customer payment    ${result_khtt}    ${cell_tinhvaocongno}

Validate customer payment
    [Arguments]    ${result_khtt}    ${cell_tinhvaocongno}
    Wait Until Page Contains Element    ${cell_tinhvaocongno}    1 min
    ${get_value_congno}    Wait Until Keyword Succeeds    3 times    3s    Get Text    ${cell_tinhvaocongno}
    ${get_value_congno}    Replace String    ${get_value_congno}    ,    ${EMPTY}
    Should Be Equal As Numbers    ${result_khtt}    ${get_value_congno}

Update payment from customer
    [Arguments]    ${textbox_locator_payment}    ${input_value_payment}    ${result_khachcantra}
    Wait Until Page Contains Element    ${textbox_locator_payment}    1 min
    Wait Until Keyword Succeeds    3 times    3s    Input data    ${textbox_locator_payment}    ${input_value_payment}
    Wait Until Page Contains Element    ${cell_update_payment}    2 mins
    ${get_value_congno}    Get Text    ${cell_update_payment}
    ${result_khtt_nho}    Minus and replace floating point    ${result_khachcantra}    ${get_value_congno}
    ${result_khtt_lon}    Minus and replace floating point    ${get_value_congno}    ${result_khachcantra}
    ${result_khtt}    Set Variable If    ${result_khachcantra}>${input_value_payment}    ${result_khtt_nho}    ${result_khtt_lon}
    Should Be Equal As Numbers    ${result_khtt}    ${input_value_payment}

Convert newprice to discount lists
    [Arguments]    ${list_baseprice}    ${list_newprice}    ${list_discount_by_newprice}
    : FOR    ${item_baseprice}    ${item_newprice}    IN ZIP    ${list_baseprice}    ${list_newprice}
    \    ${discount_if_increaseprice}    Minus    ${item_baseprice}    ${item_newprice}
    \    #\    ${discount_if_decreaseprice}    Minus    ${item_baseprice}    ${item_newprice}
    \    #\    ${actual_discount}    Set Variable If    '${item_baseprice}' < '${item_newprice}'    ${discount_if_increaseprice}    ${discount_if_decreaseprice}
    \    #\    Log    ${actual_discount}
    \    Append to list    ${list_discount_by_newprice}    ${discount_if_increaseprice}
    Return From Keyword    ${list_discount_by_newprice}

Input number and validate data
    [Arguments]    ${textbox_location}    ${input_num}    ${lastest_num}    ${value_validation_locator}
    [Timeout]
    : FOR    ${time}    IN RANGE    3
    \    Input data    ${textbox_location}    ${input_num}
    \    Click Element JS    ${value_validation_locator}
    \    ${result_lastest_number}    sum    ${input_num}    ${lastest_num}
    \    Sleep    1s
    \    ${value_lastest_number}    Get text    ${value_validation_locator}
    \    ${value_lastest_number}    Replace String    ${value_lastest_number}    ,    ${EMPTY}
    \    ${value_lastest_number}    Convert To Number    ${value_lastest_number}
    \    Exit for loop if    '${result_lastest_number}' == '${value_lastest_number}'
    Return From Keyword    ${result_lastest_number}

Input every single imei and validate data
    [Arguments]    ${textbox_input_imei}    ${imei}    ${item_imei_indropdown}    ${cell_item_imei}
    [Timeout]
    ${tag_imei}    Format String    ${cell_item_imei}    ${imei}
    Input data in textbox and wait until it is visible    ${textbox_input_imei}    ${imei}    ${item_imei_indropdown}    ${tag_imei}

Input every single imei mul-lines and validate data
    [Arguments]    ${textbox_input_imei_by_row}    ${list_imei_by_row}    ${item_imei_indropdown}    ${cell_item_imei}
    [Timeout]
    : FOR    ${time}    IN RANGE    3
    \    Input data    ${textbox_location}    ${input_text}
    \    ${result_lastest_number}    sum    ${input_text}    ${lastest_num}
    \    Sleep    5s
    \    ${value_lastest_number}    Get text    ${value_validation_locator}
    \    ${tag_imei}    Format String    ${cell_item_imei}    ${item_imei}
    \    Input data in textbox and wait until it is visible    ${textbox_input_imei_by_row}    ${item_imei}    ${item_imei_indropdown}    ${tag_imei}

Select one surcharge by pressing Enter
    [Arguments]    ${surcharge_code}    ${surcharge_value}    ${surcharge_location}
    ${xpath_surchargecode_checkbox}    Format String    ${checkbox_surcharge_by_surchargecode}    ${surcharge_code}
    Wait Until Element Is Enabled    ${surcharge_location}
    Press Key    ${surcharge_location}    ${ENTER_KEY}
    Wait Until Element Is Enabled    ${xpath_surchargecode_checkbox}
    Click Element JS    ${xpath_surchargecode_checkbox}
    Press Key    ${xpath_surchargecode_checkbox}    ${ESC_KEY}
    ${get_surcharge_value}    Get text and convert to number    ${surcharge_location}
    Should Be Equal As Numbers    ${get_surcharge_value}    ${surcharge_value}

Select two surcharge by pressing Enter
    [Arguments]    ${surcharge_code1}    ${surcharge_code2}    ${surcharge_value}    ${surcharge_location}
    ${xpath_surchargecode1_checkbox}    Format String    ${checkbox_surcharge_by_surchargecode}    ${surcharge_code1}
    ${xpath_surchargecode2_checkbox}    Format String    ${checkbox_surcharge_by_surchargecode}    ${surcharge_code2}
    Wait Until Element Is Enabled    ${surcharge_location}
    Press Key    ${surcharge_location}    ${ENTER_KEY}
    Wait Until Element Is Enabled    ${xpath_surchargecode1_checkbox}
    Wait Until Element Is Enabled    ${xpath_surchargecode2_checkbox}
    Click Element JS    ${xpath_surchargecode1_checkbox}
    Click Element JS    ${xpath_surchargecode2_checkbox}
    Press Key    ${xpath_surchargecode2_checkbox}    ${ESC_KEY}
    ${get_surcharge_value}    Get text and convert to number    ${surcharge_location}
    Should Be Equal As Numbers    ${get_surcharge_value}    ${surcharge_value}

Select one surcharge
    [Arguments]    ${surcharge_code}    ${surcharge_value}    ${surcharge_location}
    ${xpath_surchargecode_checkbox}    Format String    ${checkbox_surcharge_by_surchargecode}    ${surcharge_code}
    Wait Until Element Is Enabled    ${surcharge_location}
    Click Element JS    ${surcharge_location}
    Wait Until Element Is Enabled    ${xpath_surchargecode_checkbox}
    Wait Until Keyword Succeeds    3 times    5 s     Click Element JS    ${xpath_surchargecode_checkbox}
    Press Key    ${xpath_surchargecode_checkbox}    ${ESC_KEY}
    Sleep    5s
    ${get_surcharge_value}    Get text and convert to number    ${surcharge_location}
    Should Be Equal As Numbers    ${get_surcharge_value}    ${surcharge_value}

Select two surcharge
    [Arguments]    ${surcharge_code1}    ${surcharge_code2}    ${surcharge_value}    ${surcharge_location}
    ${xpath_surchargecode1_checkbox}    Format String    ${checkbox_surcharge_by_surchargecode}    ${surcharge_code1}
    ${xpath_surchargecode2_checkbox}    Format String    ${checkbox_surcharge_by_surchargecode}    ${surcharge_code2}
    Wait Until Element Is Enabled    ${surcharge_location}
    Wait Until Keyword Succeeds    3 times    5 s    Click Element JS    ${surcharge_location}
    Wait Until Element Is Enabled    ${xpath_surchargecode1_checkbox}
    Wait Until Element Is Enabled    ${xpath_surchargecode2_checkbox}
    Click Element JS    ${xpath_surchargecode1_checkbox}
    Click Element JS    ${xpath_surchargecode2_checkbox}
    Press Key    ${xpath_surchargecode2_checkbox}    ${ESC_KEY}
    ${get_surcharge_value}    Get text and convert to number    ${surcharge_location}
    Should Be Equal As Numbers    ${get_surcharge_value}    ${surcharge_value}

Input newprice for multi product
    [Arguments]    ${input_ma_hh}    ${input_giamoi}
    ${button_multi_giamoi}    Format String    ${button_multi_giamoi}    ${input_ma_hh}
    Click Element JS    ${button_multi_giamoi}
    Wait Until Keyword Succeeds    3 times    3s    Input data    ${textbox_giaban}    ${input_giamoi}
    ${newprice}    Get New price from UI    ${button_multi_giamoi}
    Should Be Equal As Numbers    ${newprice}    ${input_giamoi}

Select one surcharge and get value frm xpath invoice
    [Arguments]    ${surcharge_code}    ${surcharge_value}    ${surcharge_location1}    ${surcharge_location2}
    ${xpath_surchargecode_checkbox}    Format String    ${checkbox_surcharge_by_surchargecode}    ${surcharge_code}
    Wait Until Element Is Enabled    ${surcharge_location1}
    Click Element JS    ${surcharge_location1}
    Wait Until Element Is Enabled    ${xpath_surchargecode_checkbox}
    Click Element JS    ${xpath_surchargecode_checkbox}
    Press Key    ${xpath_surchargecode_checkbox}    ${ESC_KEY}
    ${get_surcharge_value}    Get text and convert to number    ${surcharge_location2}
    Should Be Equal As Numbers    ${get_surcharge_value}    ${surcharge_value}

Select two surcharege and get value frm xpath invoice
    [Arguments]    ${surcharge_code1}    ${surcharge_code2}    ${surcharge_value}    ${surcharge_location1}    ${surcharge_location2}
    ${xpath_surchargecode1_checkbox}    Format String    ${checkbox_surcharge_by_surchargecode}    ${surcharge_code1}
    ${xpath_surchargecode2_checkbox}    Format String    ${checkbox_surcharge_by_surchargecode}    ${surcharge_code2}
    Wait Until Element Is Enabled    ${surcharge_location1}
    Click Element JS    ${surcharge_location1}
    Wait Until Element Is Enabled    ${xpath_surchargecode1_checkbox}
    Wait Until Element Is Enabled    ${xpath_surchargecode2_checkbox}
    Click Element JS    ${xpath_surchargecode1_checkbox}
    Click Element JS    ${xpath_surchargecode2_checkbox}
    Press Key    ${xpath_surchargecode2_checkbox}    ${ESC_KEY}
    ${get_surcharge_value}    Get text and convert to number    ${surcharge_location2}
    Should Be Equal As Numbers    ${get_surcharge_value}    ${surcharge_value}

Input VND discount return
    [Arguments]    ${input_giamgia_vnd}
    Wait Until Page Contains Element    ${button_giamgia_th}    3s
    Click Element JS    ${button_giamgia_th}
    Wait Until Keyword Succeeds    3 times    3s    Input data    ${textbox_th_giamgia}    ${input_giamgia_vnd}
    ${newprice_return}    Get New price from UI    ${button_giamgia_th}
    Should Be Equal As Numbers    ${newprice_return}    ${input_giamgia_vnd}

Input % discount return
    [Arguments]    ${input_giamgia_th_%}    ${result_discount_by_vnd}
    [Timeout]    5 minutes
    Wait Until Page Contains Element    ${button_giamgia_th}    3s
    Click Element JS    ${button_giamgia_th}
    Wait Until Page Contains Element    ${button_th_giamgia%}    3s
    Click Element JS    ${button_th_giamgia%}
    Wait Until Keyword Succeeds    3 times    5s    Input data    ${textbox_giamgia_hd_%}    ${input_giamgia_th_%}
    ${discount_by_vnd}    Get New price from UI    ${button_giamgia_th}
    Should Be Equal As Numbers    ${discount_by_vnd}    ${result_discount_by_vnd}

Input VND discount additional invoice
    [Arguments]    ${input_giamgia_hd_vnd}
    [Timeout]    5 minutes
    Wait Until Page Contains Element    ${button_giamgia_dth}    3s
    Click Element JS    ${button_giamgia_dth}
    Wait Until Keyword Succeeds    3 times    5s    Input data    ${textbox_th_giamgia}    ${input_giamgia_hd_vnd}
    ${newprice_invoice}    Get New price from UI    ${button_giamgia_dth}
    Should Be Equal As Numbers    ${newprice_invoice}    ${input_giamgia_hd_vnd}

Input % discount additional invoice
    [Arguments]    ${input_giamgia_hd_%}    ${result_discount_by_vnd}
    [Timeout]    5 minutes
    Wait Until Page Contains Element    ${button_giamgia_dth}    3s
    Click Element JS    ${button_giamgia_dth}
    Wait Until Page Contains Element    ${button_th_giamgia%}    3s
    Click Element JS    ${button_th_giamgia%}
    Wait Until Keyword Succeeds    3 times    5s    Input data    ${textbox_giamgia_hd_%}    ${input_giamgia_hd_%}
    ${discount_by_vnd}    Get New price from UI    ${button_giamgia_dth}
    Should Be Equal As Numbers    ${discount_by_vnd}    ${result_discount_by_vnd}

Input VND discount for anyform
    [Arguments]    ${button_giamgia}    ${textbox_giamgia_vnd}    ${input_giamgia_vnd}    ${new_price}
    [Timeout]    5 minutes
    Wait Until Page Contains Element    ${button_giamgia}    3s
    Click Element JS    ${button_giamgia}
    Wait Until Keyword Succeeds    3 times    5s    Input data    ${textbox_giamgia_vnd}    ${input_giamgia_vnd}
    ${newprice_invoice}    Get New price from UI    ${button_giamgia}
    Should Be Equal As Numbers    ${newprice_invoice}    ${new_price}

Input % discount for anyform
    [Arguments]    ${button_giamgia}    ${button_giamgia%}    ${input_giamgia%}    ${result_discount_by_vnd}
    [Timeout]    5 minutes
    Wait Until Page Contains Element    ${button_giamgia}    3s
    Click Element JS    ${button_giamgia}
    Wait Until Page Contains Element    ${button_giamgia%}    3s
    Click Element JS    ${button_giamgia%}
    Wait Until Keyword Succeeds    3 times    5s    Input data    ${textbox_giamgia_hd_%}    ${input_giamgia%}
    ${discount_by_vnd}    Wait Until Keyword Succeeds    3 times    5s    Get New price from UI    ${button_giamgia}
    Should Be Equal As Numbers    ${discount_by_vnd}    ${result_discount_by_vnd}

Input newprice for anyform
    [Arguments]    ${button_giaban}    ${textbox_giaban}    ${input_value}    ${input_giamoi}
    ${button_giamoi}    Format String    ${button_giaban}    ${input_value}
    Click Element JS    ${button_giamoi}
    Wait Until Page Contains Element    ${textbox_giaban}    3s
    Wait Until Keyword Succeeds    3 times    3s    Input data    ${textbox_giaban}    ${input_giamoi}
    ${newprice}    Get New price from UI    ${button_giamoi}
    Should Be Equal As Numbers    ${newprice}    ${input_giamoi}

Input data in textbox and click element
    [Arguments]    ${textbox_location}    ${input_text}    ${xpath_item_dropdown}    ${target_locator}
    [Timeout]
    Wait Until Page Contains Element    ${textbox_location}    1 min
    Input text    ${textbox_location}    ${input_text}
    Sleep    3 s
    ${item_dropdownlist}    Format String    ${xpath_item_dropdown}    ${input_text}
    Wait Until Element Is Visible    ${item_dropdownlist}    30 s
    Click Element    ${item_dropdownlist}
    Sleep    2s
    Element Should Contain    ${target_locator}    ${input_text}

Click button up quantity and validate data
    [Arguments]    ${ma_sp}    ${xp_button_up}    ${lastest_num}    ${value_validation_locator}
    ${xp_button_up}    Format String    ${xp_button_up}    ${ma_sp}
    Wait Until Keyword Succeeds    3 times    5s    Access button down up visible    ${ma_sp}    ${xp_button_up}
    Click Element    ${xp_button_up}
    ${result_lastest_number}    Sum    ${lastest_num}    1
    ${value_lastest_number}    Get text    ${value_validation_locator}
    ${value_lastest_number}    Replace String    ${value_lastest_number}    ,    ${EMPTY}
    ${value_lastest_number}    Convert To Number    ${value_lastest_number}
    Return From Keyword    ${result_lastest_number}

Click button down quantity and validate data
    [Arguments]    ${ma_sp}    ${xp_button_down}    ${lastest_num}    ${value_validation_locator}
    ${xp_button_down}    Format String    ${xp_button_down}    ${ma_sp}
    Wait Until Keyword Succeeds    3 times    5s    Access button down up visible    ${ma_sp}    ${xp_button_down}
    Click Element    ${xp_button_down}
    ${result_lastest_number}    Minus    ${lastest_num}    1
    ${value_lastest_number}    Get text    ${value_validation_locator}
    ${value_lastest_number}    Replace String    ${value_lastest_number}    ,    ${EMPTY}
    ${value_lastest_number}    Convert To Number    ${value_lastest_number}
    Return From Keyword    ${result_lastest_number}

Click button up quantity in MHBH
    [Arguments]    ${ma_sp}    ${button_tang_locator}    ${num}    ${lastest_num}    ${value_validation_locator}
    : FOR    ${time}    IN RANGE    10
    \    ${lastest_num}    Click button up quantity and validate data    ${ma_sp}    ${button_tang_locator}    ${lastest_num}    ${value_validation_locator}
    \    Log    ${num}
    \    Exit For Loop If    ${lastest_num}==${num}

Click button down quantity in MHBH
    [Arguments]    ${ma_sp}    ${button_giam_locator}    ${num}    ${lastest_num}    ${value_validation_locator}
    : FOR    ${time}    IN RANGE    10
    \    ${lastest_num}    Click button down quantity and validate data    ${ma_sp}    ${button_giam_locator}    ${lastest_num}    ${value_validation_locator}
    \    Exit For Loop If    ${lastest_num}==${num}

Access button down up visible
    [Arguments]    ${ma_sp}    ${button_tanggiam_locator}
    ${textbox_sl}    Format String    ${textbox_multi_soluong}    ${ma_sp}
    Click Element    ${textbox_sl}
    Wait Until Element Is Visible    ${button_tanggiam_locator}

Input VND discount for multi row product
    [Arguments]    ${input_pr_id}    ${input_giamgia_vnd}    ${new_price}
    ${button_nd_giamoi}    Format String    ${button_changeprice_by_line}    ${input_pr_id}    0
    Wait Until Page Contains Element    ${button_nd_giamoi}     20s
    Wait Until Keyword Succeeds    3 times    5s    Click Element JS       ${button_nd_giamoi}
    Wait Until Page Contains Element    ${textbox_giamgia_sp}    7s
    Wait Until Keyword Succeeds    3 times    3s    Input data    ${textbox_giamgia_sp}    ${input_giamgia_vnd}
    Sleep    5s
    ${get_newprice}    Wait Until Keyword Succeeds    3 times    3s    Get New price from UI    ${button_nd_giamoi}
    Should Be Equal As Numbers    ${get_newprice}    ${new_price}

Input newprice for multi row product
    [Arguments]    ${input_pr_id}    ${input_giamoi}
    ${button_nd_giamoi}    Format String    ${button_changeprice_by_line}    ${input_pr_id}    0
    Wait Until Page Contains Element    ${button_nd_giamoi}    20s
    Wait Until Keyword Succeeds    3 times    5s    Click Element JS        ${button_nd_giamoi}
    Wait Until Page Contains Element    ${textbox_giaban_otherpaymentmethod_popup}    7s
    Wait Until Keyword Succeeds    3 times    3s    Input data    ${textbox_giaban_otherpaymentmethod_popup}    ${input_giamoi}
    Sleep    2s
    ${newprice}    Wait Until Keyword Succeeds    3 times    3s    Get New price from UI    ${button_nd_giamoi}
    Should Be Equal As Numbers    ${newprice}    ${input_giamoi}

Input % discount for multi row product
    [Arguments]    ${input_pr_id}    ${input_giamgia_%}    ${input_result_newprice_by_vnd}
    ${button_nd_giamoi}    Format String    ${button_changeprice_by_line}    ${input_pr_id}    0
    Wait Until Page Contains Element    ${button_nd_giamoi}     20s
    Wait Until Keyword Succeeds    3 times    5s    Click Element JS    ${button_nd_giamoi}
    Wait Until Page Contains Element    ${button_giamgia_sp%}
    Click Element JS    ${button_giamgia_sp%}
    Wait Until Page Contains Element    ${textbox_giamgia_sp}    7s
    Wait Until Keyword Succeeds    3 times    3s    Input data    ${textbox_giamgia_sp}    ${input_giamgia_%}
    Sleep    5s
    ${newprice}    Wait Until Keyword Succeeds    3 times    3s    Get New price from UI    ${button_nd_giamoi}
    Should Be Equal As Numbers    ${newprice}    ${input_result_newprice_by_vnd}

Input discount or change price for product in case apply multi-rows
    [Arguments]    ${product_id}    ${line_quantity}    ${list_row_quantity}    ${list_discount_type}    ${list_discount}    ${list_result_newprice}
    ${item_discount_firstrow}    Get From List    ${list_discount}    0
    ${item_result_newprice_firstrow}    Get From List    ${list_result_newprice}    0
    ${item_discount_type_firstrow}    Get From List    ${list_discount_type}    0
    Run Keyword If    '${item_discount_type_firstrow}'=='dis'    Wait Until Keyword Succeeds    3 times    3 s    Input % discount for product    ${item_discount_firstrow}
    ...    ${item_result_newprice_firstrow}
    ...    ELSE IF    '${item_discount_type_firstrow}'=='disvnd'    Wait Until Keyword Succeeds    3 times    3 s    Input VND discount for product
    ...    ${item_discount_firstrow}    ${item_result_newprice_firstrow}
    ...    ELSE IF    '${item_discount_type_firstrow}'=='changeup' or '${item_discount_type_firstrow}'=='changedown'    Wait Until Keyword Succeeds    3 times    3 s    Input new price of product
    ...    ${item_discount_firstrow}
    ...    ELSE    Log    Ignore input
    ${list_remain_discount}    Copy List    ${list_discount}
    ${list_remain_discount_type}    Copy List    ${list_discount_type}
    ${list_remain_result_newprice}    Copy List    ${list_result_newprice}
    Remove From List    ${list_remain_discount}    0
    Remove From List    ${list_remain_discount_type}    0
    Remove From List    ${list_remain_result_newprice}    0
    : FOR    ${item_discount_type}    ${item_discount}    ${item_newprice}    IN ZIP    ${list_remain_discount_type}    ${list_remain_discount}
    ...    ${list_remain_result_newprice}
    \    Run keyword if    '${item_discount_type}'=='dis' and '${line_quantity}'=='1'    Wait Until Keyword Succeeds    3 times    3 s    Input % discount for product
    \    ...    ${item_discount}    ${item_newprice}
    \    ...    ELSE IF    '${item_discount_type}'=='disvnd' and '${line_quantity}'=='1'    Wait Until Keyword Succeeds    3 times    3 s
    \    ...    Input vnd discount for product    ${item_discount}    ${item_newprice}
    \    ...    ELSE IF    '${item_discount_type}'=='changeup' or '${item_discount_type}'=='changedown' and '${line_quantity}'=='1'    Wait Until Keyword Succeeds    3 times    3 s
    \    ...    Input new price of product    ${item_newprice}
    \    ...    ELSE IF    ${line_quantity}>1    Change product price in case multi-lines    ${product_id}    ${list_remain_discount_type}
    \    ...    ${list_remain_discount}    ${list_remain_result_newprice}

Change product price in case multi-lines
    [Arguments]    ${product_id}    ${list_discount_type}    ${list_discount}    ${list_result_newprice}
    [Timeout]    5 minutes
    ${index_row_discount}    Set Variable    -1
    : FOR    ${item_discount_type}    ${item_discount}    ${item_result_newprice}    IN ZIP    ${list_discount_type}    ${list_discount}
    ...    ${list_result_newprice}
    \    ${index_row_discount}    Evaluate    ${index_row_discount} + 1
    \    ${button_changeprice_by_line}    Format String    ${button_changeprice_by_line}    ${productid}    ${index_row_discount}
    \    Run Keyword If    '${item_discount_type}'=='disvnd'    Wait Until Keyword Succeeds    3 times    3 s    Input VND product discount incase muli-row for any form
    \    ...    ${index_row_discount}    ${product_id}    ${button_changeprice_by_line}    ${textbox_giamgia_sp}    ${item_discount}
    \    ...    ${item_result_newprice}
    \    ...    ELSE IF    '${item_discount_type}'=='dis'    Wait Until Keyword Succeeds    3 times    3 s
    \    ...    Input % product discount multi-row for any form    ${index_row_discount}    ${product_id}    ${button_changeprice_by_line}    ${button_giamgia_sp%}
    \    ...    ${textbox_giamgia_sp}    ${item_discount}    ${item_result_newprice}
    \    ...    ELSE IF    '${item_discount_type}' == 'changeup' or '${item_discount_type}' == 'changedown'    Wait Until Keyword Succeeds    3 times    3 s
    \    ...    Input Product New Price multi-row for any form    ${index_row_discount}    ${product_id}    ${button_changeprice_by_line}    ${textbox_giaban}
    \    ...    ${item_discount}
    \    ...    ELSE    Log    ignore

Input data in textbox and get price in suggestion bar
    [Arguments]    ${textbox_location}    ${input_text}    ${xpath_item_dropdown}    ${target_locator}    ${xpath_price_dropdown}    ${input_price}
    [Timeout]    3 minutes
    Wait Until Page Contains Element    ${textbox_location}    1 min
    Input Text    ${textbox_location}    ${input_text}
    Sleep    3s
    ${item_dropdownlist}    Format String    ${xpath_item_dropdown}    ${input_text}
    ${item_price_dropdownlist}    Format String    ${xpath_price_dropdown}    ${input_text}
    Wait Until Element Is Visible    ${item_dropdownlist}    30s
    ${get_price}    Get New price from UI    ${item_price_dropdownlist}
    Should Be Equal As Numbers    ${get_price}    ${input_price}
    Click Element JS    ${item_dropdownlist}

Select list surcharge by pressing Enter
    [Arguments]    ${list_surcharge_code}    ${surcharge_value}    ${surcharge_location}
    Wait Until Element Is Enabled    ${surcharge_location}
    Press Key    ${surcharge_location}    ${ENTER_KEY}
    : FOR    ${item_surcharge}    IN ZIP    ${list_surcharge_code}
    \    ${xpath_surchargecode_checkbox}    Format String    ${checkbox_surcharge_by_surchargecode}    ${item_surcharge}
    \    Wait Until Element Is Enabled    ${xpath_surchargecode_checkbox}
    \    Click Element JS    ${xpath_surchargecode_checkbox}
    Click Element JS    //span[contains(@class,'k-i-close')]
    ${get_surcharge_value}    Get text and convert to number    ${surcharge_location}
    Should Be Equal As Numbers    ${get_surcharge_value}    ${surcharge_value}

Input value for any product
    [Arguments]       ${input_product}    ${input_value}      ${xpath_value}
    ${xpath_value}      Format String    ${xpath_value}    ${input_product}
    Wait Until Element Is Visible    ${xpath_value}       15s
    Input data    ${xpath_value}    ${input_value}

KV Click Element
    [Arguments]     ${element}
    Wait Until Page Contains Element    ${element}    30s
    Click Element    ${element}

KV Click Element By Code
    [Arguments]     ${element}      ${code}
    ${xpath}      Format String    ${element}      ${code}
    KV Click Element      ${xpath}

KV Click Element JS
    [Arguments]     ${element}
    Wait Until Page Contains Element    ${element}    30s
    Wait Until Keyword Succeeds    3 times    2s  Click Element JS    ${element}

KV Click Element JS By Code
    [Arguments]     ${element}      ${code}
    ${xpath}      Format String    ${element}      ${code}
    KV Click Element JS      ${xpath}

KV Get text
    [Arguments]     ${locator}
    Wait Until Page Contains Element    ${locator}    30s
    ${get_text}      Get Text      ${locator}
    Return From Keyword    ${get_text}

KV Input Text
    [Arguments]     ${locator}    ${input_text}
    Wait Until Page Contains Element    ${locator}    30s
    Input Text     ${locator}    ${input_text}

KV Input Text By Code
    [Arguments]     ${locator}    ${code}   ${input_text}
    ${xpath}      Format String    ${locator}      ${code}
    Wait Until Page Contains Element    ${xpath}    30s
    Input Text     ${xpath}    ${input_text}

KV Input data
    [Arguments]     ${locator}    ${input_text}
    Wait Until Page Contains Element    ${locator}    30s
    Input data     ${locator}    ${input_text}
