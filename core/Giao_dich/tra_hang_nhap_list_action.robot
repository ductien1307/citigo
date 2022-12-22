*** Settings ***
Library           SeleniumLibrary
Library           Collections
Library           StringFormat
Resource          tra_hang_nhap_list_page.robot
Resource          nhap_hang_list_page.robot
Resource          ../share/computation.robot
Resource          ../share/constants.robot
Resource          ../share/javascript.robot
Resource          ../share/discount.robot
Resource          ../API/api_danhmuc_hanghoa.robot
Resource          ../share/lodate.robot

*** Keywords ***
Add new Tra Hang Nhap
    Click Element    ${button_tra_hang_nhap}
    Wait Until Element Is Enabled    ${textbox_search_trahangnhap}        1 min

Click Purchase Return button from Import Product Form
    [Arguments]        ${purchase_code}
    ${cell_purchase_code_by}       Format String       ${cell_purchase_code}       ${purchase_code}
    Wait Until Page Contains Element    ${cell_purchase_code_by}
    Click Element    ${cell_purchase_code_by}
    Wait Until Element Is Enabled    ${button_trahangnhap_in_importform}
    Click Element JS     ${button_trahangnhap_in_importform}

Click Purchase Return button from Import Product Form until succeed
    [Arguments]        ${purchase_code}
    Wait Until Keyword Succeeds    5x    5s   Click Purchase Return button from Import Product Form    ${purchase_code}

Input products and nums to Tra Hang Nhap
    [Arguments]    ${product_code}    ${num}       ${lastest_number}
    [Documentation]    Nhập mã sản phẩm, số lượng
    Wait Until Page Contains Element    ${textbox_search_trahangnhap}    2 mins
    ${target_display_by_product_code}      Format String        ${cell_product_code_display_thn}         ${product_code}
    Wait Until Keyword Succeeds    3 times    8 s    Input data in textbox and wait until it is visible    ${textbox_search_trahangnhap}    ${product_code}    ${dropdown_product_code_display}
    ...    ${target_display_by_product_code}
    ${textbox_quantity_thn}       Format String       ${textbox_quantity_thn}       ${product_code}
    Wait Until Page Contains Element    ${textbox_quantity_thn}    2 mins
    ${lastest_num}    Input number and validate data    ${textbox_quantity_thn}    ${num}    ${lastest_number}    ${cell_lastest_number_thn}
    Return From Keyword    ${lastest_num}

Input products - IMEIs and validate lastest number in Tra Hang Nhap form
    [Arguments]    ${input_product}    ${input_imei_quantity}     ${input_list_imei}      ${lastest_num}
    ${target_display_by_product_code}      Format String        ${cell_product_code_display_thn}         ${input_product}
    ${lastest_num}      Input product and its imei to any form and return lastest number    ${textbox_search_trahangnhap}    ${input_product}     ${input_imei_quantity}       ${dropdown_product_code_display}    ${textbox_input_serial_num_thn}    ${dropdown_item_imei_display_thn}    ${target_display_by_product_code}
        ...    ${tag_imei_thn}    ${lastest_num}     @{input_list_imei}
    Return From Keyword    ${lastest_num}

Input VND discount for return purchase product
        [Arguments]    ${input_giamgia_vnd}    ${result_new_price}
        [Timeout]    5 minutes
        Click Element JS    ${button_changeprice_thn}
        Wait Until Element Is Visible     ${textbox_discount_thn}    3s
        Wait Until Keyword Succeeds    3 times    0.5 s    Input data     ${textbox_discount_thn}    ${input_giamgia_vnd}
        #Press Key    ${textbox_discount_percentage_thn}    ${ESC_KEY}
        ${newprice_ui}    Get New price from UI    ${button_changeprice_thn}
        Should Be Equal As Numbers    ${newprice_ui}    ${result_new_price}

Input VND discount by product code for return purchase product
        [Arguments]    ${input_product_code}     ${input_giamgia_vnd}    ${result_new_price}
        [Timeout]    5 minutes
        ${button_changeprice_by_productcode_thn}       Format String       ${button_changeprice_by_productcode_thn}      ${input_product_code}
        Click Element JS    ${button_changeprice_by_productcode_thn}
        Wait Until Element Is Visible     ${textbox_discount_thn}    3s
        Wait Until Keyword Succeeds    3 times    0.5 s    Input data     ${textbox_discount_thn}    ${input_giamgia_vnd}
        ${button_changeprice_by_productcode_thn}       Format String       ${button_changeprice_by_productcode_thn}        ${input_product_code}
        ${newprice_ui}    Get New price from UI    ${button_changeprice_by_productcode_thn}
        Should Be Equal As Numbers    ${newprice_ui}    ${result_new_price}

Input % discount for return purchase product
        [Arguments]    ${input_discount_percentage}    ${input_result_newprice_by_vnd}
        [Timeout]    5 minutes
        Click Element JS    ${button_changeprice_thn}
        Wait Until Page Contains Element    ${button_discount_percentage_thn}
        Click Element JS    ${button_discount_percentage_thn}
        Wait Until Page Contains Element    ${textbox_discount_percentage_thn}    3s
        Wait Until Keyword Succeeds    3 times    0.5 s    Input data    ${textbox_discount_percentage_thn}    ${input_discount_percentage}
        #Press Key    ${textbox_discount_percentage_thn}    ${ESC_KEY}
        ${newprice_ui}    Get New price from UI    ${button_changeprice_thn}
        Should Be Equal As Numbers    ${newprice_ui}    ${input_result_newprice_by_vnd}

Input % discount by product code for return purchase product
        [Arguments]    ${input_product_code}       ${input_discount_percentage}    ${input_result_newprice_by_vnd}
        [Timeout]    5 minutes
        ${button_changeprice_by_productcode_thn}       Format String       ${button_changeprice_by_productcode_thn}      ${input_product_code}
        Click Element JS    ${button_changeprice_by_productcode_thn}
        Wait Until Page Contains Element    ${button_discount_percentage_thn}
        Click Element JS    ${button_discount_percentage_thn}
        Wait Until Page Contains Element    ${textbox_discount_percentage_thn}    3s
        Wait Until Keyword Succeeds    3 times    0.5 s    Input data    ${textbox_discount_percentage_thn}    ${input_discount_percentage}
        #Press Key    ${textbox_discount_percentage_thn}    ${ESC_KEY}
        ${button_changeprice_by_productcode_thn}       Format String       ${button_changeprice_by_productcode_thn}        ${input_product_code}
        ${newprice_ui}    Get New price from UI    ${button_changeprice_by_productcode_thn}
        Should Be Equal As Numbers    ${newprice_ui}    ${input_result_newprice_by_vnd}

Input new price of return purchase product
        [Arguments]    ${input_giamoi}
        [Timeout]    5 minutes
        Click Element JS    ${button_changeprice_thn}
        Wait Until Page Contains Element    ${textbox_newprice_thn}    3s
        Wait Until Keyword Succeeds    3 times    0.5 s    Input data    ${textbox_newprice_thn}    ${input_giamoi}
        #Press Key    ${textbox_discount_percentage_thn}    ${ESC_KEY}
        ${newprice_ui}    Get New price from UI    ${button_changeprice_thn}
        Should Be Equal As Numbers    ${newprice_ui}    ${input_giamoi}

Input new price by product code of return purchase product
        [Arguments]    ${input_product_code}      ${input_giamoi}
        [Timeout]    5 minutes
        ${button_changeprice_by_productcode_thn}       Format String       ${button_changeprice_by_productcode_thn}      ${input_product_code}
        Click Element JS    ${button_changeprice_by_productcode_thn}
        Wait Until Page Contains Element    ${textbox_newprice_thn}    3s
        Wait Until Keyword Succeeds    3 times    0.5 s    Input data    ${textbox_newprice_thn}    ${input_giamoi}
        ${button_changeprice_by_productcode_thn}       Format String       ${button_changeprice_by_productcode_thn}        ${input_product_code}
        ${newprice_ui}    Get New price from UI    ${button_changeprice_by_productcode_thn}
        Should Be Equal As Numbers    ${newprice_ui}    ${input_giamoi}

Input VND Purchase Return Discount
    [Arguments]    ${input_purchase_return_discount}
    [Timeout]    5 minutes
    Wait Until Page Contains Element    ${button_purchase_return_discount}    3s
    Click Element JS    ${button_purchase_return_discount}
    Wait Until Keyword Succeeds    3 times    0.5 s    Press Key    ${textbox_purchase_return_discount}    ${input_purchase_return_discount}
    ${discount_ui}    Get New price from UI    ${button_purchase_return_discount}
    Should Be Equal As Numbers    ${discount_ui}    ${input_purchase_return_discount}

Input % Purchase Return Discount
     [Arguments]    ${input_purchase_return_discount}    ${result_discount_by_vnd}
     [Timeout]    5 minutes
     Wait Until Page Contains Element    ${button_purchase_return_discount}    3s
     Click Element JS    ${button_purchase_return_discount}
     Wait Until Page Contains Element    ${button_purchase_return_discount_ratio}    10s
     Click Element    ${button_purchase_return_discount_ratio}
     Wait Until Page Contains Element    ${textbox_purchase_return_ratio_discount}    10s
     Wait Until Keyword Succeeds    3 times    0.5s    Input text     ${textbox_purchase_return_ratio_discount}    ${input_purchase_return_discount}
     ${discount_ui}    Get New price from UI    ${button_purchase_return_discount}
     Should Be Equal As Numbers    ${discount_ui}    ${result_discount_by_vnd}

Input purchase return discount
    [Arguments]   ${return_discount}    ${result_discount_invoice}
    Run Keyword If    0 < ${return_discount} < 100    Input % Purchase Return Discount    ${return_discount}    ${result_discount_invoice}
    ...    ELSE IF    ${return_discount} > 100    Input VND Purchase Return Discount    ${return_discount}
    ...    ELSE    Log    Ignore discount

Input Supplier in THN form
    [Arguments]    ${input_supplier}
    KV Input Text    ${textbox_input_supplier}    ${input_supplier}
    KV Click Element    ${cell_nhacungcap_thn}

Input Suppplier code and paid for supplier
    [Arguments]    ${input_supplier}    ${input_paid_for_supplier}      ${result_must_paid}
    Input Supplier in THN form      ${input_supplier}
    Wait Until Keyword Succeeds    3 times    1s    Input paid for supplier and validate   ${input_paid_for_supplier}    ${result_must_paid}

Input paid for supplier and validate
    [Arguments]    ${input_paid_for_supplier}    ${result_must_paid}
    Wait Until Keyword Succeeds    3 times    0.5 s    Input data    ${textbox_paid_for_supplier}    ${input_paid_for_supplier}
    ${cell_change_to_customer}    Get Change to customer from UI    ${cell_add_to_debt}
    ${result_add_to_debt}    Minus    ${result_must_paid}    ${input_paid_for_supplier}
    Should Be Equal As Numbers    ${result_add_to_debt}    ${cell_change_to_customer}

Input purchase return infor
    [Arguments]     ${supplier_code}    ${actual_supplier_payment}    ${result_must_paid}
    Run Keyword If    ${actual_supplier_payment} == 0    Input Supplier in THN form    ${supplier_code}
    ...    ELSE    Input Suppplier code and paid for supplier    ${supplier_code}    ${actual_supplier_payment}    ${result_must_paid}

Input purchase return Code
    [Arguments]        ${input_purchase_return_code}
    Input text      ${textbox_purchase_return_code}           ${input_purchase_return_code}

Input quantity in Purchase Return Form
     [Arguments]       ${input_product_code}      ${input_quantity}       ${lastest_num}
     ${textbox_quantity_thn}       Format String       ${textbox_quantity_thn}       ${input_product_code}
     Wait Until Page Contains Element    ${textbox_quantity_thn}    2 mins
     ${lastest_num}    Input number and validate data    ${textbox_quantity_thn}    ${input_quantity}    ${lastest_num}    ${cell_lastest_number_thn}
     Return From Keyword    ${lastest_num}

Input imeis to Purchase Return form and return lastest number
      [Arguments]    ${input_ma_sp}     ${input_number_imei}     ${lastest_num}     @{list_imei}
      ${textbox_imei_by_productcode}       Format String      ${textbox_input_imei_by_productcode}       ${input_ma_sp}
      ${list_imei}       Convert String to List      @{list_imei}
      ${index_imei}    Set Variable    -1
      : FOR    ${imei}    IN    @{list_imei}
      \    ${index_imei}    Evaluate    ${index_imei} + 1
      \    ${item_imei}    Get From List    ${list_imei}    ${index_imei}
      \    Wait Until Keyword Succeeds    3 times    3 s      Input every single imei and validate data    ${textbox_imei_by_productcode}    ${item_imei}     ${dropdown_item_imei_display_thn}       ${tag_imei_thn}
      ${result_lastest_number}    sum    ${input_number_imei}    ${lastest_num}
      Return From Keyword    ${result_lastest_number}

Input VND Discount for Purchase Return and validate value from Purchase form
      [Arguments]    ${input_purchase_return_discount}
      [Timeout]    5 minutes
      Wait Until Page Contains Element    ${button_purchase_return_discount}    3s
      Click Element JS    ${button_purchase_return_discount}
      Wait Until Keyword Succeeds    3 times    0.5 s    Input data    ${textbox_purchase_return_discount_from_purchase_form}    ${input_purchase_return_discount}
      ${discount_ui}    Get New price from UI    ${textbox_purchase_return_discount_from_purchase_form}
      Should Be Equal As Numbers    ${discount_ui}    ${input_purchase_return_discount}

Open popup Chi phi nhap hoan lai and select returned expenses
      [Arguments]     ${list_cpnh}    ${list_value}      ${total_returned_expense}
      [Timeout]   5 minutes
      KV Click Element    ${button_chiphi_nhap_hoanlai}
      :FOR    ${item_cpnh}      ${item_value}     IN ZIP      ${list_cpnh}    ${list_value}
      \     KV Click Element By Code    ${checkbox_ma_chihphi_hoanlai}    ${item_cpnh}
      \     Run Keyword If    '${item_value}'!='none'    Input value in textbox Chi phi nhap tra nha cung cap    ${item_cpnh}      ${item_value}
      Sleep    1s
      ${total_expense_ui}   Get New price from UI    ${cell_chiphi_nhap_hoanlai}
      Should Be Equal As Numbers    ${total_returned_expense}    ${total_expense_ui}
      Click Element    ${button_close_popup_chiphi_nhap_hoanlai}

Input value in textbox Chi phi nhap tra nha cung cap
    [Arguments]     ${ma_cpnh}      ${gia_tri}
    KV Click Element By Code    ${cell_chiphi_nhap_hoanlai_theo_ma}    ${ma_cpnh}
    Run Keyword If    ${gia_tri}<=100    KV Click Element       ${toggle_chi_phi_thn_%}    ELSE     KV Click Element       ${toggle_chi_phi_thn_VND}
    KV Input Text    ${textbox_thn_muc_chi_moi}    ${gia_tri}

Input new purchase return discount
      [Arguments]    ${input_purchase_return_discount}
      [Timeout]    5 minutes
      Wait Until Page Contains Element    ${button_purchase_return_discount}    3s
      Click Element JS    ${button_purchase_return_discount}
      Wait Until Keyword Succeeds    3 times    0.5s   Input data       ${textbox_thn_giamgia_moi}    ${input_purchase_return_discount}
      ${discount_ui}    Get New price from UI    ${button_purchase_return_discount}
      Should Be Equal As Numbers    ${discount_ui}    ${input_purchase_return_discount}

Input new price for multi row product in THN form
      [Arguments]    ${location_giatralai}      ${input_giamoi}
      [Timeout]    5 minutes
      Click Element    ${location_giatralai}
      Wait Until Page Contains Element    ${textbox_newprice_thn}    3s
      Wait Until Keyword Succeeds    3 times    0.5s    Input Text    ${textbox_newprice_thn}    ${input_giamoi}
      ${newprice_ui}    Get New price from UI    ${location_giatralai}
      Should Be Equal As Numbers    ${newprice_ui}    ${input_giamoi}

Input % discount for multi row product in THN form
    [Arguments]     ${location_giatralai}     ${input_discount_percentage}    ${input_result_newprice_by_vnd}
    [Timeout]    5 minutes
    Click Element    ${location_giatralai}
    Wait Until Page Contains Element    ${button_discount_percentage_thn}
    Click Element JS    ${button_discount_percentage_thn}
    Wait Until Page Contains Element    ${textbox_discount_percentage_thn}    3s
    Wait Until Keyword Succeeds    3 times    0.5 s    Input data    ${textbox_discount_percentage_thn}    ${input_discount_percentage}
    ${newprice_ui}    Get New price from UI    ${location_giatralai}
    Should Be Equal As Numbers    ${newprice_ui}    ${input_result_newprice_by_vnd}

Input VND discount for multi row product in THN form
    [Arguments]      ${location_giatralai}   ${input_giamgia_vnd}    ${result_new_price}
    [Timeout]    5 minutes
    Click Element    ${location_giatralai}
    Wait Until Page Contains Element    ${button_discount_vnd_thn}
    Click Element JS    ${button_discount_vnd_thn}
    Wait Until Element Is Visible     ${textbox_discount_thn}    3s
    Wait Until Keyword Succeeds    3 times    0.5 s    Input data     ${textbox_discount_thn}    ${input_giamgia_vnd}
    ${newprice_ui}    Get New price from UI    ${location_giatralai}
    Should Be Equal As Numbers    ${newprice_ui}    ${result_new_price}

Add row and input data for proudct in THN form
    [Arguments]     ${input_product}     ${input_product_id}     ${list_num}      ${list_change}      ${list_change_type}     ${list_newprice}    ${lastest_num}
    Wait Until Page Contains Element    ${textbox_nh_search_hh}    2 mins
    ${target_display_by_product_code}      Format String        ${cell_product_code_display_thn}         ${input_product}
    Wait Until Keyword Succeeds    3 times    8 s    Input data in textbox and wait until it is visible    ${textbox_search_trahangnhap}    ${input_product}    ${dropdown_product_code_display}
    ...    ${target_display_by_product_code}
    ${list_num}     Convert string to list      ${list_num}
    ${list_change}      Convert string to list      ${list_change}
    ${list_change_type}      Convert string to list      ${list_change_type}
    ${index}      Set Variable    -1
    :FOR        ${item_change}    ${item_num}      ${item_change_type}    ${item_newprice}        IN ZIP       ${list_change}     ${list_num}      ${list_change_type}    ${list_newprice}
    \     ${index}      Sum    ${index}    1
    \     ${index}      Set Variable If    ${index}>0    1      0
    \     ${index}      Replace floating point    ${index}
    \     ${button_thn_them_dong}     Format String    ${button_thn_them_dong}    ${input_product_id}
    \     ${textbox_soluong_row}     Format String    ${textbox_thn_soluong_in_row}      ${input_product_id}    ${index}
    \     ${button_giatralai}    Format String    ${button_thn_giatralai_in_row}     ${input_product_id}     ${index}
    \     Run Keyword If    ${index}==0     Log    Ingore add row       ELSE      Click Element     ${button_thn_them_dong}
    \     Wait Until Page Contains Element    ${textbox_soluong_row}    2 mins
    \     ${lastest_num}    Input number and validate data    ${textbox_soluong_row}    ${item_num}    ${lastest_num}    ${cell_lastest_number_thn}
    \     Run keyword if    0<${item_change}<100 and '${item_change_type}'=='dis'    Wait Until Keyword Succeeds    3 times    0.5s    Input % discount for multi row product in THN form
    \     ...      ${button_giatralai}   ${item_change}    ${item_newprice}    ELSE IF    ${item_change}>100 and '${item_change_type}'=='dis'    Wait Until Keyword Succeeds    3 times    0.5s
    \     ...    Input VND discount for multi row product in THN form       ${button_giatralai}    ${item_change}    ${item_newprice}    ELSE IF     '${item_change_type}'=='change'    Wait Until Keyword Succeeds    3 times    0.5s      Input new price for multi row product in THN form    ${button_giatralai}   ${item_change}     ELSE      Log    ignore
    Return From Keyword    ${lastest_num}

Add row and input data for imei proudct in THN form
    [Arguments]     ${input_product}     ${input_product_id}    ${list_imei}     ${list_num}      ${list_change}      ${list_change_type}     ${list_newprice}    ${lastest_num}
    Wait Until Page Contains Element    ${textbox_nh_search_hh}    2 mins
    ${target_display_by_product_code}      Format String        ${cell_product_code_display_thn}         ${input_product}
    Wait Until Keyword Succeeds    3 times    7s    Input data in textbox and wait until it is visible    ${textbox_search_trahangnhap}    ${input_product}    ${dropdown_product_code_display}
    ...    ${target_display_by_product_code}
    ${list_num}     Convert string to list      ${list_num}
    ${list_change}      Convert string to list      ${list_change}
    ${list_change_type}      Convert string to list      ${list_change_type}
    ${index}      Set Variable    -1
    :FOR        ${item_change}    ${item_num}      ${item_change_type}    ${item_newprice}      ${item_imei}    IN ZIP       ${list_change}     ${list_num}      ${list_change_type}    ${list_newprice}    ${list_imei}
    \     ${index}      Sum    ${index}    1
    \     ${index}      Set Variable If    ${index}>0    1      0
    \     ${index}      Replace floating point    ${index}
    \     ${lastest_num}    Sum    ${lastest_num}    ${item_num}
    \     ${button_thn_them_dong}     Format String    ${button_thn_them_dong}    ${input_product_id}
    \     ${textbox_soluong_row}     Format String    ${textbox_thn_soluong_in_row}      ${input_product_id}    ${index}
    \     ${textbox_imei}     Format String    ${textbox_thn_imei_in_row}    ${input_product_id}      ${index}
    \     ${textbox_imei}     Set Variable If    ${index}==0      ${textbox_input_serial_num_thn}     ${textbox_imei}
    \     ${button_giatralai}    Format String    ${button_thn_giatralai_in_row}     ${input_product_id}     ${index}
    \     Run Keyword If    ${index}==0     Log    Ingore add row       ELSE      Click Element     ${button_thn_them_dong}
    \     Wait Until Keyword Succeeds    3 times    3 s    Input imei incase multi row to THN form   ${input_product_id}    ${textbox_imei}
    \     ...    //em[contains(text(),'{0}')]      ${item_imei}
    \     Run keyword if    0<${item_change}<100 and '${item_change_type}'=='dis'    Wait Until Keyword Succeeds    3 times    0.5s    Input % discount for multi row product in THN form
    \     ...      ${button_giatralai}   ${item_change}    ${item_newprice}    ELSE IF    ${item_change}>100 and '${item_change_type}'=='dis'    Wait Until Keyword Succeeds    3 times    0.5s
    \     ...    Input VND discount for multi row product in THN form       ${button_giatralai}    ${item_change}    ${item_newprice}    ELSE IF     '${item_change_type}'=='change'    Wait Until Keyword Succeeds    3 times    0.5s      Input new price for multi row product in THN form    ${button_giatralai}   ${item_change}     ELSE      Log    ignore
    Return From Keyword    ${lastest_num}

Input imei incase multi row to THN form
    [Arguments]    ${input_pr_id}    ${textbox_input_imei}    ${item_imei_indropdown}     ${list_imei}
    ${index_imei}    Set Variable    -1
    : FOR    ${imei}    IN    @{list_imei}
    \    ${textbox_input_imei}    Format String    ${textbox_input_imei}    ${input_pr_id}
    \    ${index_imei}    Evaluate    ${index_imei} + 1
    \    ${item_imei}    Get From List    ${list_imei}    ${index_imei}
    \    Wait Until Keyword Succeeds    3 times    2s    Input data in textbox and click item in dropdown      ${textbox_input_imei}    ${item_imei}
    \    ...    ${item_imei_indropdown}

Input num for multi row product in THN form
    [Arguments]     ${input_product_id}     ${list_num}     ${index}
    ${list_num}     Convert string to list      ${list_num}
    :FOR        ${item_num}         IN ZIP         ${list_num}
    \     ${index}      Sum    ${index}    1
    \     ${index}      Replace floating point    ${index}
    \     ${textbox_soluong_row}     Format String    ${textbox_thn_soluong_in_row}      ${input_product_id}    ${index}
    \     Input data    ${textbox_soluong_row}    ${item_num}
    Return From Keyword    ${index}

Input líst imeis for multi row product in THN form
    [Arguments]     ${input_product_id}    ${list_imei}     ${index}
    ${index1}     Set Variable    -1
    :FOR        ${item_imei}    IN ZIP      ${list_imei}
    \     ${index}      Sum    ${index}    1
    \     ${index1}      Sum    ${index1}    1
    \     ${index}      Replace floating point    ${index}
    \     ${index1}      Replace floating point    ${index1}
    \     ${textbox_imei}     Format String    ${textbox_thn_imei_in_row}    ${input_product_id}      ${index}
    \     ${textbox_imei}     Set Variable If    ${index1}==0      ${textbox_input_serial_num_thn}     ${textbox_imei}
    \     Wait Until Keyword Succeeds    3 times    2s    Input imei incase multi row to THN form   ${input_product_id}    ${textbox_imei}
    \     ...    //em[contains(text(),'{0}')]      ${item_imei}
    Return From Keyword    ${index}

 Add product multi row and input value incase purchase return
    [Arguments]     ${list_product}     ${list_num}    ${list_change}    ${list_change_type}   ${list_result_newprice_af}    ${get_list_imei_status}   ${list_imei}
    ${get_list_pr_id}     Get list product id thr API    ${list_product}
    ${lastest_num}    Set Variable    0
    #input hh
    : FOR    ${item_product}    ${item_pr_id}    ${item_num}    ${item_change}    ${item_change_type}      ${item_status}     ${item_imei}      ${item_newprice}
    ...    IN ZIP    ${list_product}    ${get_list_pr_id}    ${list_num}    ${list_change}    ${list_change_type}      ${get_list_imei_status}      ${list_imei}       ${list_result_newprice_af}
    \      ${lastest_num}      Run Keyword If    '${item_status}'=='0'      Add row and input data for proudct in THN form    ${item_product}    ${item_pr_id}    ${item_num}    ${item_change}    ${item_change_type}    ${item_newprice}    ${lastest_num}      ELSE      Add row and input data for imei proudct in THN form    ${item_product}    ${item_pr_id}     ${item_imei}    ${item_num}    ${item_change}    ${item_change_type}    ${item_newprice}    ${lastest_num}
    Return From Keyword      ${lastest_num}

Fill product nmbers incase multi rows THN
    [Arguments]   ${list_products}    ${list_nums_return}      ${list_imei_all}
    ${get_list_pr_id}    Get list product id thr API    ${list_products}
    ${get_list_imei_status}    Get list imei status thr API    ${list_products}
    #
    ${list_imei_return}    Create List
    : FOR    ${item_num_return}    ${item_list_imei}    ${item_status}    IN ZIP    ${list_nums_return}    ${list_imei_all}
    ...    ${get_list_imei_status}
    \    ${item_num_return}     Split string      ${item_num_return}    ,
    \    ${item_list_imei_return}    Run Keyword If    '${item_status}'=='True'    Get list imei by list num    ${item_num_return}    ${item_list_imei}
    \    ...    ELSE    Set Variable    ${EMPTY}
    \    Append To List    ${list_imei_return}    ${item_list_imei_return}
    Log    ${list_imei_return}
    #
    ${index}    Set Variable    -1
    : FOR    ${item_pr_id}    ${item_product}    ${item_status}    ${item_num}    ${item_list_imei}    IN ZIP
    ...    ${get_list_pr_id}    ${list_products}    ${get_list_imei_status}    ${list_nums_return}    ${list_imei_return}
    \    ${index}     Run Keyword If    '${item_status}'=='0'    Input num for multi row product in THN form    ${item_pr_id}    ${item_num}    ${index}
    \    ...    ELSE    Input líst imeis for multi row product in THN form    ${item_pr_id}    ${item_list_imei}      ${index}

Validate discount THN from UI
    [Arguments]   ${input_discount}
    ${discount_ui}    Get New price from UI    ${button_purchase_return_discount}
    Should Be Equal As Numbers    ${discount_ui}    ${input_discount}

Add product and input value incase purchase return
    [Arguments]   ${list_products}    ${list_nums}    ${list_product_discount}    ${list_product_discount_type}    ${list_result_newprice}   ${list_all_imeis}     ${get_list_imei_status}
    ${lastest_num}    Set Variable    0
    : FOR    ${item_product}    ${item_num}    ${item_list_imei}    ${item_discount}    ${item_discount_type}    ${item_newprice}
    ...    ${item_status}    IN ZIP    ${list_products}    ${list_nums}    ${list_all_imeis}    ${list_product_discount}
    ...    ${list_product_discount_type}    ${list_result_newprice}    ${get_list_imei_status}
    \    ${list_imei_to_input}    Run Keyword If    '${item_status}'=='True'    Convert String to List    ${item_list_imei}
    \    ...    ELSE    Set Variable    ${EMPTY}
    \    ${lastest_num}=    Run Keyword If    '${item_status}'=='True'    Input products - IMEIs and validate lastest number in Tra Hang Nhap form    ${item_product}    ${item_num}
    \    ...    ${list_imei_to_input}    ${lastest_num}
    \    ...    ELSE    Input products and nums to Tra Hang Nhap    ${item_product}    ${item_num}    ${lastest_num}
    \    Run keyword if    '${item_discount_type}' == 'dis' and 0<${item_discount}<100    Wait Until Keyword Succeeds    3 times    0.5s    Input % discount for return purchase product
    \    ...    ${item_discount}    ${item_newprice}
    \    ...    ELSE IF    '${item_discount_type}' == 'dis' and ${item_discount}>100    Wait Until Keyword Succeeds    3 times    0.5s
    \    ...    Input VND discount for return purchase product    ${item_discount}    ${item_newprice}
    \    ...    ELSE IF    '${item_discount_type}' == 'change'    Wait Until Keyword Succeeds    3 times    0.5s
    \    ...    Input new price of return purchase product    ${item_discount}
    \    ...    ELSE    Log    ignore

Input product values in THN form
    [Arguments]      ${list_products}     ${list_nums_return}   ${get_list_imei_status}    ${list_imei_return}    ${list_product_discount}    ${list_product_discount_type}    ${list_result_newprice}
    ${lastest_num}    Set Variable    0
    : FOR    ${item_product}    ${item_status}    ${item_num}    ${item_list_imei}    ${item_discount}    ${item_discount_type}
    ...    ${item_newprice}    IN ZIP    ${list_products}    ${get_list_imei_status}    ${list_nums_return}    ${list_imei_return}
    ...    ${list_product_discount}    ${list_product_discount_type}    ${list_result_newprice}
    \    ${list_imei_to_input}    Convert String to List    ${item_list_imei}
    \    ${lastest_num}    Run Keyword If    '${item_status}' == 'True'    Input imeis to Purchase Return form and return lastest number    ${item_product}    ${item_num}
    \    ...    ${lastest_num}    ${list_imei_to_input}
    \    ...    ELSE    Input quantity in Purchase Return Form    ${item_product}    ${item_num}    ${lastest_num}
    \    Run keyword if    '${item_discount_type}' == 'dis' and 0<${item_discount}<100    Wait Until Keyword Succeeds    3 times   0.5s    Input % discount by product code for return purchase product
    \    ...    ${item_product}    ${item_discount}    ${item_newprice}
    \    ...    ELSE IF    '${item_discount_type}' == 'dis' and ${item_discount}>100    Wait Until Keyword Succeeds    3 times    0.5s
    \    ...    Input VND discount by product code for return purchase product    ${item_product}    ${item_discount}    ${item_newprice}
    \    ...    ELSE IF    '${item_discount_type}' == 'change'    Wait Until Keyword Succeeds    3 times    0.5s
    \    ...    Input new price by product code of return purchase product    ${item_product}    ${item_discount}
    \    ...    ELSE    Log    ignore

Input product numbers in THN form
    [Arguments]      ${list_products}     ${list_nums_return}   ${get_list_imei_status}    ${list_imei_return}
    ${lastest_num}    Set Variable    0
    : FOR    ${item_product}    ${item_status}    ${item_num}    ${item_list_imei}     IN ZIP    ${list_products}    ${get_list_imei_status}    ${list_nums_return}    ${list_imei_return}
    \    ${list_imei_to_input}    Convert String to List    ${item_list_imei}
    \    ${lastest_num}    Run Keyword If    '${item_status}' == 'True'    Input imeis to Purchase Return form and return lastest number    ${item_product}    ${item_num}
    \    ...    ${lastest_num}    ${list_imei_to_input}
    \    ...    ELSE    Input quantity in Purchase Return Form    ${item_product}    ${item_num}    ${lastest_num}

Input products - lodate and validate lastest number in Tra Hang Nhap form
    [Documentation]    input hàng hóa vào form trả hàng nhập
    [Arguments]    ${input_product}    ${input_lot_quantity}     ${item_lot_to_input}      ${lastest_num}
    #element ${tag_imei_thn} vẫn đúng cho trường hợp nhập lô
    ${target_display_by_product_code}      Format String        ${cell_product_code_display_thn}         ${input_product}
    ${lastest_num}      Input product and its lots to any form and return lastest number    ${textbox_search_trahangnhap}    ${input_product}     ${dropdown_product_code_display}    ${target_display_by_product_code}    ${textbox_input_lot}     ${item_lot_to_input}    ${dropdown_lot_display_thn}     ${input_lot_quantity}
        ...    ${textbox_sl_lo_thn}    ${lastest_num}
    Return From Keyword    ${lastest_num}

Input num and validate lastest number in Tra Hang Nhap form
    [Documentation]     nhập số lượng và tính lastest num ở form trả hàng nhập
    [Arguments]     ${item_lot_to_input}    ${input_lot_quantity}      ${lastest_num}
    #element ${tag_imei_thn} vẫn đúng cho trường hợp nhập lô
    Click lot and enter number in popup for lot     ${item_lot_to_input}    ${tag_imei_thn}    ${input_lot_quantity}
    ${result_lastest_number}    sum    ${input_lot_quantity}    ${lastest_num}
    Return From Keyword    ${result_lastest_number}

Input product and its lots to any form and return lastest number
    [Documentation]    input hàng hóa > lô > sl lô vào form
    [Arguments]    ${textbox_search_ma_sp}    ${input_ma_sp}    ${item_product_indropdown}    ${cell_product_target}    ${textbox_input_lot}    ${item_lot_to_input}    ${dropdown_lot_display_thn}
    ...    ${input_lot_quantity}    ${textbox_sl_lo_thn}    ${lastest_num}
    Wait Until Keyword Succeeds    3 times    2s    Input data in textbox and wait until it is visible    ${textbox_search_ma_sp}    ${input_ma_sp}    ${item_product_indropdown}
    ...    ${cell_product_target}
    #Input lot in textbox and wait until it is visible    ${textbox_input_lot}    ${item_lot_to_input}    ${item_dropdownlist}    ${textbox_sl_lo_thn}    ${input_lot_quantity}
    Input Text    ${textbox_input_lot}    ${item_lot_to_input}
    Wait Until Page Contains Element       ${dropdown_lot_display_thn}    30s
    Press Key    ${textbox_input_lot}    ${ENTER_KEY}
    Wait Until Page Contains Element       ${textbox_sl_lo_thn}   20s
    Input Text    ${textbox_sl_lo_thn}    ${input_lot_quantity}
    Wait Until Keyword Succeeds    3 times    3 s    Click Element JS    ${button_save_lot_popup}
    ${result_lastest_number}    sum    ${input_lot_quantity}    ${lastest_num}
    Return From Keyword    ${result_lastest_number}

Add product and input value incase THN nhanh lodate
    [Documentation]    nhập sp, sl lô, đơn giá mới , giảm giá vào form trả hàng nhanh
    [Arguments]    ${list_products}    ${list_nums}    ${list_product_discount}    ${list_product_discount_type}    ${list_result_newprice}   ${list_all_lo}    ${list_product_types}
    ${lastest_num}    Set Variable    0
    : FOR    ${item_product}     ${item_product_type}       ${item_num}        ${item_lo}    ${item_discount}      ${item_discount_type}     ${item_newprice}    IN ZIP    ${list_products}       ${list_product_types}
    ...    ${list_nums}    ${list_all_lo}       ${list_product_discount}    ${list_product_discount_type}      ${list_result_newprice}
    \    ${item_lot_to_input}        Replace sq blackets        ${item_lo}
    \    ${lastest_num}=        Input products - lodate and validate lastest number in Tra Hang Nhap form    ${item_product}    ${item_num}    ${item_lot_to_input}    ${lastest_num}
    \    Run keyword if    '${item_discount_type}' == 'dis'    Wait Until Keyword Succeeds    3 times    5 s    Input % discount for return purchase product    ${item_discount}    ${item_newprice}
    \    ...    ELSE IF    '${item_discount_type}' == 'disvnd'    Wait Until Keyword Succeeds    3 times    5 s    Input VND discount for return purchase product    ${item_discount}    ${item_newprice}
    \    ...    ELSE IF     '${item_discount_type}' == 'changeup' or '${item_discount_type}' == 'changedown'   Wait Until Keyword Succeeds    3 times    5 s    Input new price of return purchase product    ${item_discount}        ELSE       Log        ignore

Add product and input value incase THN with PN lodate
    [Documentation]    nhập sp, sl lô, đơn giá mới , giảm giá vào form trả hàng theo phiếu nhập
    [Arguments]    ${list_products}    ${list_nums_return}    ${list_product_discount}    ${list_product_discount_type}    ${list_result_newprice}   ${list_all_lo}    ${list_product_types}
    ${lastest_num}    Set Variable    0
    : FOR    ${item_product}    ${item_num}    ${item_lot}    ${item_discount}    ${item_discount_type}
    ...    ${item_newprice}    IN ZIP    ${list_products}    ${list_nums_return}    ${list_all_lo}
    ...    ${list_product_discount}    ${list_product_discount_type}    ${list_result_newprice}
    \    ${item_lot_to_input}    Replace sq blackets     ${item_lot}
    \    ${lastest_num}     Input num and validate lastest number in Tra Hang Nhap form    ${item_lot_to_input}    ${item_num}    ${lastest_num}
    \    Run keyword if    '${item_discount_type}' == 'dis'   Wait Until Keyword Succeeds    3 times   0.5s    Input % discount by product code for return purchase product
    \    ...    ${item_product}    ${item_discount}    ${item_newprice}
    \    ...    ELSE IF    '${item_discount_type}' == 'disvnd'    Wait Until Keyword Succeeds    3 times    0.5s
    \    ...    Input VND discount by product code for return purchase product    ${item_product}    ${item_discount}    ${item_newprice}
    \    ...    ELSE IF    '${item_discount_type}' == 'changeup' or '${item_discount_type}' == 'changedown'    Wait Until Keyword Succeeds    3 times    0.5s
    \    ...    Input new price by product code of return purchase product    ${item_product}    ${item_discount}
    \    ...    ELSE    Log    ignore
