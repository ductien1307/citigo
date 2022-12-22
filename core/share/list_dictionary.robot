*** Settings ***
Library           SeleniumLibrary
Library           StringFormat
Library           Collections
Resource          computation.robot

*** Keywords ***
Get value frm list variable
    [Arguments]    @{list_variable}
    ${value1}    Set Variable    @{list_variable}[0]
    ${value2}    Set Variable    @{list_variable}[1]
    ${value3}    Set Variable    @{list_variable}[2]
    ${value4}    Set Variable    @{list_variable}[3]
    ${value5}    Set Variable    @{list_variable}[4]
    Return From Keyword    ${value1}    ${value2}    ${value3}    ${value4}    ${value5}

Get value x 4 frm list variable
    [Arguments]    @{list_variable}
    ${value1}    Set Variable    @{list_variable}[0]
    ${value2}    Set Variable    @{list_variable}[1]
    ${value3}    Set Variable    @{list_variable}[2]
    ${value4}    Set Variable    @{list_variable}[3]
    Return From Keyword    ${value1}    ${value2}    ${value3}    ${value4}

Get individual value frm list variable with 3
    [Arguments]    @{list_variable}
    ${value1}    Set Variable    @{list_variable}[0]
    ${value2}    Set Variable    @{list_variable}[1]
    ${value3}    Set Variable    @{list_variable}[2]
    Return From Keyword    ${value1}    ${value2}    ${value3}

Reverse five lists
    [Arguments]    ${list_one}    ${list_two}    ${list_three}    ${list_four}    ${list_five}
    ${copied_list_one}    Copy List    ${list_one}
    ${copied_list_two}    Copy List    ${list_two}
    ${copied_list_three}    Copy List    ${list_three}
    ${copied_list_four}    Copy List    ${list_four}
    ${copied_list_five}    Copy List    ${list_five}
    ${reversed_list_one}    Evaluate    ${copied_list_one}[::-1]
    ${reversed_list_two}    Evaluate    ${copied_list_two}[::-1]
    ${reversed_list_three}    Evaluate    ${copied_list_three}[::-1]
    ${reversed_list_four}    Evaluate    ${copied_list_four}[::-1]
    ${reversed_list_five}    Evaluate    ${copied_list_five}[::-1]
    Return From Keyword    ${reversed_list_one}    ${reversed_list_two}    ${reversed_list_three}    ${reversed_list_four}    ${reversed_list_five}

Get key item from dictionary
    [Arguments]    ${dict}
    ${item_key}    Get Dictionary keys    ${dict}
    ${item_key}    Convert To String    ${item_key}
    ${item_key}    Replace sq blackets    ${item_key}
    Return From Keyword    ${item_key}

Convert String to List
    [Arguments]    ${string}
    ${list_values}    Convert To String    ${string}
    ${list_values}    Replace sq blackets    ${list_values}
    @{list_values}    Split String    ${list_values}    ,
    log list    ${list_values}
    log many    @{list_values}
    Return From Keyword    ${list_values}

Get list of keys from dictionary by value
    [Arguments]    ${dict}      ${value_to_find}
    ${list_key_by_value}       Create List
    ${list_value}       Get Dictionary Values    ${dict}
    ${list_key}       Get Dictionary Keys    ${dict}
    : FOR       ${item_key}        ${item_value}       IN ZIP       ${list_key}       ${list_value}
    \     Run Keyword If    '${item_value}' == '${value_to_find}'     Append To List    ${list_key_by_value}    ${item_key}        ELSE       Log       ignore it
    Log      ${list_key_by_value}
    Return From Keyword    ${list_key_by_value}

Get list of values from dictionary by list of keys
    [Arguments]    ${dict}      ${list_keys_to_find_values}
    ${list_values_by_list_key}       Create List
    ${list_value}       Get Dictionary Values    ${dict}
    ${list_key}       Get Dictionary Keys    ${dict}
    : FOR       ${item_key}        ${item_value}       IN ZIP       ${list_key}       ${list_value}
    \     ${count}=      Get Match Count        ${list_keys_to_find_values}     ${item_key}
    \     Run Keyword If    ${count} == 1     Append To List    ${list_values_by_list_key}    ${item_value}        ELSE       Log       ignore it
    Log      ${list_values_by_list_key}
    Return From Keyword    ${list_values_by_list_key}

Reverse six lists
    [Arguments]    ${list_one}    ${list_two}    ${list_three}    ${list_four}    ${list_five}    ${list_six}
    ${copied_list_one}    Copy List    ${list_one}
    ${copied_list_two}    Copy List    ${list_two}
    ${copied_list_three}    Copy List    ${list_three}
    ${copied_list_four}    Copy List    ${list_four}
    ${copied_list_five}    Copy List    ${list_five}
    ${copied_list_six}    Copy List    ${list_six}
    ${reversed_list_one}    Evaluate    ${copied_list_one}[::-1]
    ${reversed_list_two}    Evaluate    ${copied_list_two}[::-1]
    ${reversed_list_three}    Evaluate    ${copied_list_three}[::-1]
    ${reversed_list_four}    Evaluate    ${copied_list_four}[::-1]
    ${reversed_list_five}    Evaluate    ${copied_list_five}[::-1]
    ${reversed_list_six}    Evaluate    ${copied_list_six}[::-1]
    Return From Keyword    ${reversed_list_one}    ${reversed_list_two}    ${reversed_list_three}    ${reversed_list_four}    ${reversed_list_five}    ${reversed_list_six}

Reverse seven lists
    [Arguments]    ${list_one}    ${list_two}    ${list_three}    ${list_four}    ${list_five}    ${list_six}
    ...    ${list_seven}
    ${copied_list_one}    Copy List    ${list_one}
    ${copied_list_two}    Copy List    ${list_two}
    ${copied_list_three}    Copy List    ${list_three}
    ${copied_list_four}    Copy List    ${list_four}
    ${copied_list_five}    Copy List    ${list_five}
    ${copied_list_six}    Copy List    ${list_six}
    ${copied_list_six}    Copy List    ${list_seven}
    ${reversed_list_one}    Evaluate    ${copied_list_one}[::-1]
    ${reversed_list_two}    Evaluate    ${copied_list_two}[::-1]
    ${reversed_list_three}    Evaluate    ${copied_list_three}[::-1]
    ${reversed_list_four}    Evaluate    ${copied_list_four}[::-1]
    ${reversed_list_five}    Evaluate    ${copied_list_five}[::-1]
    ${reversed_list_six}    Evaluate    ${copied_list_six}[::-1]
    ${reversed_list_seven}    Evaluate    ${copied_list_six}[::-1]
    Return From Keyword    ${reversed_list_one}    ${reversed_list_two}    ${reversed_list_three}    ${reversed_list_four}    ${reversed_list_five}    ${reversed_list_six}
    ...    ${reversed_list_seven}

Replace list from list
    [Arguments]    ${big_list}    ${small_list}
    log list    ${big_list}
    : FOR    ${item_in_small_list}    IN    @{small_list}
    \    Remove Values From List    ${big_list}    ${item_in_small_list}
    \    log list    ${big_list}
    Return From Keyword    ${big_list}

Reverse List one
    [Arguments]    ${list_one}
    ${copied_list_one}    Copy List    ${list_one}
    ${reversed_list_one}    Evaluate    ${copied_list_one}[::-1]
    Return From Keyword    ${reversed_list_one}

Change negative number to positive number and vice versa in List
    [Arguments]    ${list_nums}
    ${list_result_num}    create list    ${EMPTY}
    ${index_in_list_num}    Set Variable    -1
    : FOR    ${item_num}    IN    @{list_nums}
    \    ${index_in_list_num}=    Evaluate    ${index_in_list_num} + 1
    \    ${item_num}    Get From List    ${list_nums}    ${index_in_list_num}
    \    ${item_num}    Minus    0    ${item_num}
    \    Append To List    ${list_result_num}    ${item_num}
    Remove From List    ${list_result_num}    0
    Log    ${list_result_num}
    Return From Keyword    ${list_result_num}

Get list item by index list
    [Arguments]    ${list}    ${list_index}    ${list_items}
    ${list_del_item_by_product}    Create List
    : FOR    ${item_index}    IN    @{list_index}
    \    ${del_item}    Get from list    ${list}    ${item_index}
    \    Append To List    ${list_del_item_by_product}    ${del_item}
    Return From Keyword    ${list_del_item_by_product}

Convert List to String
    [Arguments]    ${list}
    ${string}    Evaluate    ",".join($list)
    Return From Keyword    ${string}

Convert list of integers to String
    [Arguments]    ${list}
    ${string}    Evaluate    ''.join(str(e) for e in $list)
    Return From Keyword    ${string}

Convert string list to composite list
    [Arguments]    ${list}
    ${list_of_list}   Create List
    :FOR    ${item}    IN    @{list}
    \     ${item}    Convert String to List   ${item}
    \     Append to List    ${list_of_list}    ${item}
    Return From Keyword    ${list_of_list}

Convert three string list to composite list
    [Arguments]    ${list1}    ${list2}    ${list3}
    ${list_of_list1}   Create List
    ${list_of_list2}   Create List
    ${list_of_list3}   Create List
    :FOR    ${item1}   ${item2}   ${item3}    IN ZIP     ${list1}    ${list2}    ${list3}
    \     ${item1}    Convert String to List   ${item1}
    \     ${item2}    Convert String to List   ${item2}
    \     ${item3}    Convert String to List   ${item3}
    \     Append to List    ${list_of_list1}    ${item1}
    \     Append to List    ${list_of_list2}    ${item2}
    \     Append to List    ${list_of_list3}    ${item3}
    Return From Keyword    ${list_of_list1}    ${list_of_list2}    ${list_of_list3}

Add value into composite list
    [Arguments]    ${list_value}    ${list_composite}
    ${list}     Create List
    :FOR      ${composite_list}   ${item_value}     IN ZIP      ${list_composite}    ${list_value}
    \      Append To List    ${composite_list}      ${item_value}
    \      Append To List    ${list}      ${composite_list}
    Return From Keyword     ${list}

Add value into composite list with imei products
    [Arguments]    ${list_imei_value}    ${list_composite}    ${list_status_product}
    ${list}     Create List
    Log    ${list_imei_value}
    Log    ${list_composite}
    :FOR      ${composite_list}   ${item_imei_value}    ${item_status}     IN ZIP      ${list_composite}    ${list_imei_value}    ${list_status_product}
    \      Run Keyword If    '${item_status}' == 'True'     Append To List    ${composite_list}      ${item_imei_value}      ELSE    Log      Ignore add
    \      Append To List    ${list}      ${composite_list}
    Return From Keyword     ${list}

Add value into three composite list
    [Arguments]    ${list_composite1}    ${list_composite2}    ${list_composite3}    ${list_value1}    ${list_value2}    ${list_value3}
    ${list1}     Create List
    ${list2}     Create List
    ${list3}     Create List
    :FOR    ${composite_list1}   ${composite_list2}   ${composite_list3}   ${item_value1}   ${item_value2}   ${item_value3}     IN ZIP      ${list_composite1}
    ...      ${list_composite2}      ${list_composite3}      ${list_value1}      ${list_value2}    ${list_value3}
    \      Append To List    ${composite_list1}      ${item_value1}
    \      Append To List    ${composite_list2}      ${item_value2}
    \      Append To List    ${composite_list3}      ${item_value3}
    \      Log    ${composite_list1}
    \      ${composite_list1}   Reverse List one    ${composite_list1}
    \      ${composite_list2}  Reverse List one    ${composite_list2}
    \      ${composite_list3}  Reverse List one    ${composite_list3}
    \      Append To List    ${list1}      ${composite_list1}
    \      Append To List    ${list2}      ${composite_list2}
    \      Append To List    ${list3}      ${composite_list3}
    Return From Keyword     ${list1}    ${list2}    ${list3}

Delete value into three composite list
    [Arguments]    ${list_composite1}    ${list_composite2}    ${list_composite3}    ${list_value1}    ${list_value2}    ${list_value3}
    ${list1}     Create List
    ${list2}     Create List
    ${list3}     Create List
    :FOR    ${composite_list1}   ${composite_list2}   ${composite_list3}   ${item_value1}   ${item_value2}   ${item_value3}     IN ZIP      ${list_composite1}
    ...      ${list_composite2}      ${list_composite3}      ${list_value1}      ${list_value2}    ${list_value3}
    \      Remove Values From List    ${composite_list1}      ${item_value1}
    \      Remove Values From List    ${composite_list2}      ${item_value2}
    \      Remove Values From List    ${composite_list3}      ${item_value3}
    \      Append To List    ${list1}      ${composite_list1}
    \      Append To List    ${list2}      ${composite_list2}
    \      Append To List    ${list3}      ${composite_list3}
    Return From Keyword     ${list1}    ${list2}    ${list3}

Reverse two lists
    [Arguments]    ${list_one}    ${list_two}
    ${copied_list_one}    Copy List    ${list_one}
    ${copied_list_two}    Copy List    ${list_two}
    ${reversed_list_one}    Evaluate    ${copied_list_one}[::-1]
    ${reversed_list_two}    Evaluate    ${copied_list_two}[::-1]
    Return From Keyword    ${reversed_list_one}    ${reversed_list_two}

Reverse three lists
    [Arguments]    ${list_one}    ${list_two}    ${list_three}
    ${copied_list_one}    Copy List    ${list_one}
    ${copied_list_two}    Copy List    ${list_two}
    ${copied_list_three}    Copy List    ${list_three}
    ${reversed_list_one}    Evaluate    ${copied_list_one}[::-1]
    ${reversed_list_two}    Evaluate    ${copied_list_two}[::-1]
    ${reversed_list_three}    Evaluate    ${copied_list_three}[::-1]
    Return From Keyword    ${reversed_list_one}    ${reversed_list_two}    ${reversed_list_three}

Get item in list to append to another list
    [Arguments]    ${list_to_extract}    ${list_to_append}
    ${item_inlist}    Get Length    ${list_to_extract}
    ${index}    Set Variable    0
    : FOR    ${index}    IN RANGE    ${item_inlist}
    \    ${item_single}    Get From List    ${list_to_extract}    ${index}
    \    Append To List    ${list_to_append}    ${item_single}

Convert list to string and return
    [Arguments]    ${string}
    ${list_values}    Convert To String    ${string}
    ${list_values}    Replace sq blackets    ${list_values}
    Return From Keyword    ${list_values}

Convert two list to string and return
    [Arguments]    ${string1}    ${string2}
    ${list_values1}    Convert To String    ${string1}
    ${list_values2}    Convert To String    ${string2}
    ${list_values1}    Replace sq blackets    ${list_values1}
    ${list_values2}    Replace sq blackets    ${list_values2}
    Return From Keyword    ${list_values1}    ${list_values2}

Remove value and append others to list
     [Arguments]    ${list_to_append}    ${value_to_remove}      ${value_to_append}     ${times}
     ${index}    Set Variable    0
     Remove Values From List    ${list_to_append}    ${value_to_remove}
     : FOR    ${index}    IN RANGE    ${times}
     \    Append To List    ${list_to_append}    ${value_to_append}

Remove combo and unit from validation lists
     [Arguments]      ${list_products}    ${list_actual_quan}      ${list_product_types}
     ${list_product_for_validation}     Copy List     ${list_products}
     ${list_product_quan_for_validation}     Copy List     ${list_actual_quan}
     ${list_product_type_for_validation}     Copy List     ${list_product_types}
     : FOR    ${item_product}     ${item_num}    ${item_product_type}    IN ZIP    ${list_products}    ${list_actual_quan}      ${list_product_types}
     \     Run Keyword If    '${item_product_type}' == 'com' or '${item_product_type}' == 'unit'   Remove values from list      ${list_product_for_validation}       ${item_product}       ELSE      Log      Ignore
     \     Run Keyword If    '${item_product_type}' == 'com' or '${item_product_type}' == 'unit'   Remove values from list     ${list_product_quan_for_validation}       ${item_num}        ELSE      Log      Ignore
     \     Run Keyword If    '${item_product_type}' == 'com' or '${item_product_type}' == 'unit'   Remove values from list     ${list_product_type_for_validation}       ${item_product_type}        ELSE      Log      Ignore
     Return From Keyword     ${list_product_for_validation}       ${list_product_quan_for_validation}     ${list_product_type_for_validation}

Extract combo and unit products for validation lists
     [Arguments]      ${list_products}    ${list_actual_quan}      ${list_product_types}      ${list_product_for_validation}       ${list_product_quan_for_validation}     ${list_product_type_for_validation}
     : FOR    ${item_product}    ${item_product_type}      ${item_num}      IN ZIP    ${list_products}    ${list_product_types}      ${list_actual_quan}
     \    ${list_material_product_code_by_combo}    ${list_material_quantity_by_combo}        Run Keyword If    '${item_product_type}' == 'com'    Get list of Combo material product codes and actual sale quantity    ${item_product}      ${item_num}     ELSE     Set Variable    ${EMPTY}       ${EMPTY}
     \    Get item in list to append to another list    ${list_material_product_code_by_combo}        ${list_product_for_validation}
     \    Get item in list to append to another list    ${list_material_quantity_by_combo}       ${list_product_quan_for_validation}
     \    ${get_number_product_of_combo}        Get length      ${list_material_product_code_by_combo}
     \    ${master_product}        ${master_product_quan}      Run Keyword If    '${item_product_type}' == 'unit'     Get list master product and its quantity from unit product    ${item_product}      ${item_num}       ELSE     Set Variable    ${EMPTY}       ${EMPTY}
     \    Run Keyword If    '${master_product}' != '${EMPTY}'    Append to List    ${list_product_for_validation}       ${master_product}       ELSE       Log      ignore append list
     \    Run Keyword If    '${master_product}' != '${EMPTY}'    Append to List    ${list_product_quan_for_validation}       ${master_product_quan}       ELSE       Log      ignore append list
     \    Run Keyword If    '${item_product_type}' == 'com'        Remove value and append others to list    ${list_product_type_for_validation}      com      pro    ${get_number_product_of_combo}      ELSE       Log       Ignore
     Return From Keyword     ${list_product_for_validation}       ${list_product_quan_for_validation}     ${list_product_type_for_validation}

Create list by list Quantity
     [Arguments]       ${list_quantity}
     ${list_non}      Create list
     : FOR    ${item_quan}    IN ZIP    ${list_quantity}
     \    ${item_added_non}      Set Variable      nonimei
     \    Append to List         ${list_non}        ${item_added_non}
     Return From Keyword    ${list_non}

Remove from list by quantity
     [Arguments]       ${list_need_del}      ${quantity}
     : FOR    ${item_quan}    IN RANGE    ${quantity}
     \    Remove from list      ${list_need_del}     0
    Return From Keyword    ${list_need_del}

Get list from composite list by index
     [Arguments]       ${composite_list}     ${index}
     ${list_toget}        Create list
     : FOR    ${item_list}    IN ZIP    ${composite_list}
     \    ${value_toget}      Get From List    ${item_list}     0
     \    Append To List    ${list_toget}    ${value_toget}
    Return From Keyword    ${list_toget}

Convert list to be inputed data
     [Arguments]     ${list}
     ${list_result}      Create List
     : FOR    ${item_key}    IN ZIP    ${list}
     \    ${type} =    Evaluate    type($item_key).__name__
     \    ${item_key}      Run Keyword If    ${type}==float    Convert to Number    ${item_key}    ELSE IF    ${type}==int     Convert to String    ${item_key}     ELSE     Set Variable    ${item_key}
     \    Append To List    ${list_result}    ${item_key}
     Return From Keyword    ${list_result}

Change the position of lots in validation list
   [Documentation]    thay đổi vị trí lô trong list lô validate theo list hàng hóa do trong list hàng hóa lôdate có chứa hàng unit
   [Arguments]    ${list_products}    ${list_nums}      ${list_product_types}     ${list_all_lo}
   ${list_lot_for_validation}    Copy List     ${list_all_lo}
   : FOR    ${item_product}     ${item_num}    ${item_product_type}     ${item_lot}    IN ZIP    ${list_products}    ${list_nums}      ${list_product_types}    ${list_lot_for_validation}
   \     Run Keyword If    '${item_product_type}' == 'unit'    Remove values from list       ${list_lot_for_validation}       ${item_lot}    ELSE      Log      Ignore
   \    ${master_product}        ${master_product_quan}      Run Keyword If    '${item_product_type}' == 'unit'     Get list master product and its quantity from unit product    ${item_product}      ${item_num}       ELSE     Set Variable    ${EMPTY}       ${EMPTY}
   \    Run Keyword If    '${master_product}' != '${EMPTY}'    Append to List      ${list_lot_for_validation}      ${item_lot}    ELSE       Log      ignore append list
   Return From Keyword      ${list_lot_for_validation}

Get list from dictionary
    [Arguments]   ${dict}
    ${list_keys}    Get Dictionary Keys    ${dict}
    ${list_values}    Get Dictionary Values    ${dict}
    Return From Keyword    ${list_keys}   ${list_values}
