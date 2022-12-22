*** Settings ***
Library           String
Library           StringFormat
Library           DateTime
Library           Collections
Library           SeleniumLibrary
Library           number

*** Keywords ***
Multiplication
    [Arguments]    ${num1}    ${num2}
    [Timeout]    15 seconds
    ${num1}    Convert To Number    ${num1}    #sl
    ${num2}    Convert To Number    ${num2}    #gia
    ${result_ns}    Create Dictionary    x=${num1}    y=${num2}
    ${result}    Evaluate    x*y    namespace=${result_ns}
    Return From Keyword    ${result}

Multiplication x 3
    [Arguments]    ${num1}    ${num2}     ${num3}
    [Timeout]    15 seconds
    ${num1}    Convert To Number    ${num1}
    ${num2}    Convert To Number    ${num2}
    ${num3}    Convert To Number    ${num3}
    ${result_ns}    Create Dictionary    x=${num1}    y=${num2}   z=${num3}
    ${result}    Evaluate    x*y*z    namespace=${result_ns}
    Return From Keyword    ${result}

Average Cost Of Capital
    [Arguments]    ${price}    ${quantity}    ${prev_average_price}    ${prev_quantity}    ${percision}=0
    ${price}    Convert To Number    ${price}
    ${quantity}    Convert To Number    ${quantity}
    ${prev_average_price}    Convert To Number    ${prev_average_price}
    ${prev_quantity}    Convert To Number    ${prev_quantity}
    ${result_ns}    Create Dictionary    a=${price}    b=${quantity}    c=${prev_average_price}    d=${prev_quantity}
    ${result}    Evaluate    (a*b+c*d)/(b+d)    namespace=${result_ns}
    Run Keyword And Return    Convert To Number    ${result}    ${percision}

Average Cost Of Capital Minus
    [Arguments]    ${price}    ${quantity}    ${prev_average_price}    ${prev_quantity}    ${percision}=0
    ${price}    Convert To Number    ${price}
    ${quantity}    Convert To Number    ${quantity}
    ${prev_average_price}    Convert To Number    ${prev_average_price}
    ${prev_quantity}    Convert To Number    ${prev_quantity}
    ${result_ns}    Create Dictionary    a=${price}    b=${quantity}    c=${prev_average_price}    d=${prev_quantity}
    ${result}    Evaluate    (a*b-c*d)/(b-d)    namespace=${result_ns}
    Run Keyword And Return    Convert To Number    ${result}    ${percision}

Assert Equals Number
    [Arguments]    ${num1}    ${num2}
    [Timeout]    15 seconds
    ${num1}    Convert Any To Number    ${num1}
    ${num2}    Convert Any To Number    ${num2}
    Should Be Equal As Numbers    ${num1}    ${num2}

Sum
    [Arguments]    ${num1}    ${num2}
    ${num1}    Convert To Number    ${num1}
    ${num2}    Convert To Number    ${num2}
    ${result_ns}    Create Dictionary    x=${num1}    y=${num2}
    ${result}    Evaluate    x+y    namespace=${result_ns}
    Return From Keyword    ${result}

Convert Any To Number
    [Arguments]    ${param}
    ${param_type}    Evaluate    type($param).__name__
    ${param}=    Run Keyword If    '${param_type}' == 'unicode'    Convert To String    ${param}
    ${value}=    Run Keyword If    '${param_type}' == 'str' or '${param_type}' == 'unicode'    Replace String    ${param}    ,    ${EMPTY}
    ...    ELSE    Set Variable    ${param}
    ${value}    Convert To Number    ${value}
    Return From Keyword    ${value}

Minus
    [Arguments]    ${num1}    ${num2}
    ${num1}    Convert To Number    ${num1}
    ${num2}    Convert To Number    ${num2}
    ${result_ns}    Create Dictionary    x=${num1}    y=${num2}
    ${result}    Evaluate    x-y    namespace=${result_ns}
    Return From Keyword    ${result}

Price after % discount
    [Arguments]    ${num1}    ${num2}
    ${num1}    Convert Any To Number    ${num1}
    ${num2}    Convert Any To Number    ${num2}
    ${result_ns}    Create Dictionary    x=${num1}    y=${num2}
    ${result}    Evaluate    x-((x*y)/100)    namespace=${result_ns}
    Return From Keyword    ${result}

Average Cost Of Capital if discounting VND invoice
    [Arguments]    ${price}    ${quantity}    ${prev_average_price}    ${prev_quantity}    ${discount_vnd}    ${percision}=0
    ${price}    Convert Any To Number    ${price}
    ${quantity}    Convert Any To Number    ${quantity}
    ${prev_average_price}    Convert Any To Number    ${prev_average_price}
    ${prev_quantity}    Convert Any To Number    ${prev_quantity}
    ${discount_vnd}    Convert Any To Number    ${discount_vnd}
    ${result_ns}    Create Dictionary    a=${price}    b=${quantity}    c=${prev_average_price}    d=${prev_quantity}    e=${discount_vnd}
    ${result}    Evaluate    (((a*b)-e)+(c*d))/(b+d)    namespace=${result_ns}
    Run Keyword And Return    Convert To Number    ${result}    ${percision}

Average Cost Of Capital when % discounting invoice
    [Arguments]    ${sum_afterdiscount}    ${quantity}    ${prev_average_price}    ${prev_quantity}    ${percision}=0
    ${sum_afterdiscount}    Convert Any To Number    ${sum_afterdiscount}
    ${quantity}    Convert Any To Number    ${quantity}
    ${prev_average_price}    Convert Any To Number    ${prev_average_price}
    ${prev_quantity}    Convert Any To Number    ${prev_quantity}
    ${result_ns}    Create Dictionary    a=${sum_afterdiscount}    b=${quantity}    c=${prev_average_price}    d=${prev_quantity}
    ${result}    Evaluate    (a+(c*d))/(b+d)    namespace=${result_ns}
    Run Keyword And Return    Convert To Number    ${result}    ${percision}

Replace sq blackets
    [Arguments]    ${array}
    ${array}    Convert To String    ${array}
    ${array}    Replace String    ${array}    [u'    ${EMPTY}
    ${array}    Replace String    ${array}    u'    ${EMPTY}
    ${array}    Replace String    ${array}    '    ${EMPTY}
    ${array}    Replace String    ${array}    ]    ${EMPTY}
    ${array}    Replace String    ${array}    [    ${EMPTY}
    ${array}    Replace String    ${array}    ${SPACE}    ${EMPTY}
    Return From Keyword    ${array}

Replace sq blackets and double quotations
    [Arguments]    ${raw_str}
    ${str_first}    Replace String    ${raw_str}    ["    ${EMPTY}
    ${str_com}    Replace String    ${str_first}    "]    ${EMPTY}
    Return From Keyword    ${str_com}

Get Ma Phieu Thu in So quy
    [Arguments]    ${code}
    ${get_ma_phieu}    Catenate    SEPARATOR=    TT    ${code}
    Return From Keyword    ${get_ma_phieu}

Get Ma Phieu Chi in So quy
    [Arguments]    ${code}
    ${get_ma_phieu}    Catenate    SEPARATOR=    PC    ${code}
    Return From Keyword    ${get_ma_phieu}

Multiplication and round
    [Arguments]    ${num1}    ${num2}
    [Timeout]    15 seconds
    ${num1}    Convert To Number    ${num1}    #sl
    ${num2}    Convert To Number    ${num2}    #gia
    ${result_ns}    Create Dictionary    x=${num1}    y=${num2}
    ${result_bf_replace}    Evaluate    x*y    namespace=${result_ns}
    ${result}    Convert To Number    ${result_bf_replace}    0
    Return From Keyword    ${result}

Multiplication with price round 2
    [Arguments]    ${num1}    ${num2}
    [Timeout]    15 seconds
    ${num1}    Convert To Number    ${num1}    #sl
    ${num2}    Convert To Number    ${num2}    #gia
    ${result_ns}    Create Dictionary    x=${num1}    y=${num2}
    ${result_bf_replace}    Evaluate    x*y    namespace=${result_ns}
    ${result}=    Evaluate    round(${result_bf_replace}, 2)
    Return From Keyword    ${result}

Multiplication and round any number
    [Arguments]    ${num1}    ${num2}   ${round}
    [Timeout]    15 seconds
    ${num1}    Convert To Number    ${num1}    #sl
    ${num2}    Convert To Number    ${num2}    #gia
    ${result_ns}    Create Dictionary    x=${num1}    y=${num2}
    ${result_bf_replace}    Evaluate    x*y    namespace=${result_ns}
    ${result}=    Evaluate    round(${result_bf_replace}, ${round})
    Return From Keyword    ${result}

Price after % discount with data frm API
    [Arguments]    ${num1}    ${num2}    ${percision}=0
    ${num1}    Convert To Number    ${num1}
    ${num2}    Convert To Number    ${num2}
    ${result_ns}    Create Dictionary    x=${num1}    y=${num2}
    ${result}    Evaluate    x-((x*y)/100)    namespace=${result_ns}
    Run Keyword And Return    Convert To Number    ${result}    ${percision}

Convert to vietnamese
    [Arguments]    ${content}
    ${byte_string}=    Encode String To Bytes    ${content}    UTF-8
    log    ${byte_string}
    ${_string} =    Decode Bytes To String    ${byte_string}    UTF-8
    log    ${_string}
    Return From Keyword    ${_string}

Convert % discount to VND
    [Arguments]    ${num1}    ${num2}
    ${num1}    Convert To Number    ${num1}
    ${num2}    Convert To Number    ${num2}
    ${result_ns}    Create Dictionary    x=${num1}    y=${num2}
    ${result}    Evaluate    (x*y)/100    namespace=${result_ns}
    Return From Keyword    ${result}

Tinh phi theo trong luong
    [Arguments]    ${num1}    ${num2}    ${num3}
    [Timeout]    15 seconds
    ${num1}    Convert To Number    ${num1}
    ${num2}    Convert To Number    ${num2}
    ${num3}    Convert To Number    ${num3}
    ${result_ns}    Create Dictionary    x=${num1}    y=${num2}    z=${num3}
    ${result}    Evaluate    (x*y*z)/5000    namespace=${result_ns}
    Return From Keyword    ${result}

Tinh khoi luong quy doi
    [Arguments]    ${num1}
    [Timeout]    15 seconds
    ${num1}    Convert To Number    ${num1}
    ${result_ns}    Create Dictionary    x=${num1}
    ${result}    Evaluate    (x/0.5)*3000    namespace=${result_ns}
    Return From Keyword    ${result}

Sum x 3
    [Arguments]    ${num1}    ${num2}    ${num3}
    ${num1}    Convert To Number    ${num1}
    ${num2}    Convert To Number    ${num2}
    ${num3}    Convert To Number    ${num3}
    ${result_ns}    Create Dictionary    x=${num1}    y=${num2}    z=${num3}
    ${result}    Evaluate    x+y+z    namespace=${result_ns}
    Return From Keyword    ${result}

Price after VAT
    [Arguments]    ${num1}    ${num2}=0.1
    ${num1}    Convert To Number    ${num1}
    ${num2}    Convert To Number    ${num2}
    ${result_ns}    Create Dictionary    x=${num1}    y=${num2}
    ${result}    Evaluate    (x+(x*y))    namespace=${result_ns}

Price after VND discount
    [Arguments]    ${num1}    ${num2}    ${num3}
    ${num1}    Convert To Number    ${num1}
    ${num2}    Convert To Number    ${num2}
    ${num3}    Convert To Number    ${num3}
    ${result_ns}    Create Dictionary    x=${num1}    y=${num2}    z=${num3}
    ${result}    Evaluate    (x-y)*z    namespace=${result_ns}
    Return From Keyword    ${result}

Divide OnHand
    [Arguments]    ${num1}    ${num2}
    ${num1}    Convert To Number    ${num1}
    ${num2}    Convert To Number    ${num2}
    ${result_ns}    Create Dictionary    x=${num1}    y=${num2}
    ${result}    Evaluate    x/y    namespace=${result_ns}
    ${result}=    Evaluate    round(${result}, 3)
    Return From Keyword    ${result}

Convert Date time
    [Arguments]    ${input_time}
    ${time_cut}    Replace String    ${input_time}    .0000000    ${EMPTY}
    ${result_time}    Convert Date    ${time_cut}    exclude_millis=yes    result_format=%d/%m/%Y %H:%M
    Return From Keyword    ${result_time}

Multiplication for onhand
    [Arguments]    ${num1}    ${num2}
    [Timeout]    15 seconds
    ${num1}    Convert To Number    ${num1}
    ${num2}    Convert To Number    ${num2}
    ${result_ns}    Create Dictionary    x=${num1}    y=${num2}
    ${result}    Evaluate    x*y    namespace=${result_ns}
    ${result}=    Convert To Number    ${result}
    ${result}=    Evaluate    round(${result}, 3)
    Return From Keyword    ${result}

Price after % discount product
    [Arguments]    ${num1}    ${num2}    ${percision}=0
    ${num1}    Convert To Number    ${num1}    #gia
    ${num2}    Convert To Number    ${num2}    # phan tram giam gia
    ${result_ns}    Create Dictionary    x=${num1}    y=${num2}
    ${vnd_discount}    Evaluate    x*(y/100)    namespace=${result_ns}
    ${vnd_discount}    Convert To String    ${vnd_discount}
    ${vnd_discount}=    Round up    ${vnd_discount}    2
    ${result}    Evaluate    ${num1}-${vnd_discount}
    ${result_string}    Convert To String    ${result}
    ${result_dec}=    Round Up    ${result_string}    2
    ${result_final}    Convert To Number    ${result_dec}
    Return From Keyword    ${result_final}

Price after % discount invoice
    [Arguments]    ${num1}    ${num2}    ${percision}=0
    ${num1}    Convert To Number    ${num1}
    ${num2}    Convert To Number    ${num2}
    ${result_ns}    Create Dictionary    x=${num1}    y=${num2}
    ${result_discount_%}    Evaluate    (x*y)/100    namespace=${result_ns}
    ${result_discount_%}    Evaluate    round(${result_discount_%}, 2)
    ${result_discount_%}    Convert To Number    ${result_discount_%}    0
    ${result_after_discount_%}=    Minus    ${num1}    ${result_discount_%}
    Return From Keyword    ${result_after_discount_%}

Replace floating point
    [Arguments]    ${dec}
    ${dec}    Convert To String    ${dec}
    ${dec}    Replace String    ${dec}    .0    ${EMPTY}
    Return From Keyword    ${dec}

Multiplication and replace floating point
    [Arguments]    ${num1}    ${num2}
    ${num1}    Convert To Number    ${num1}    #sl
    ${num2}    Convert To Number    ${num2}    #gia
    ${result_ns}    Create Dictionary    x=${num1}    y=${num2}
    ${result}    Evaluate    x*y    namespace=${result_ns}
    ${result}    Replace floating point    ${result}
    Return From Keyword    ${result}

Minus and replace floating point
    [Arguments]    ${num1}    ${num2}
    ${num1}    Convert To Number    ${num1}
    ${num2}    Convert To Number    ${num2}
    ${result_ns}    Create Dictionary    x=${num1}    y=${num2}
    ${result}    Evaluate    x-y    namespace=${result_ns}
    ${result}    Replace floating point    ${result}
    Return From Keyword    ${result}

Minus and round
    [Arguments]    ${num1}    ${num2}
    ${num1}    Convert To Number    ${num1}
    ${num2}    Convert To Number    ${num2}
    ${result_ns}    Create Dictionary    x=${num1}    y=${num2}
    ${result}    Evaluate    x-y    namespace=${result_ns}
    ${result}    Convert To Number    ${result}    0
    Return From Keyword    ${result}

Minus and round 2
    [Arguments]    ${num1}    ${num2}
    ${num1}    Convert To Number    ${num1}
    ${num2}    Convert To Number    ${num2}
    ${result_ns}    Create Dictionary    x=${num1}    y=${num2}
    ${result}    Evaluate    x-y    namespace=${result_ns}
    ${result}    Evaluate    round(${result}, 2)
    Return From Keyword    ${result}

Minus and round 3
    [Arguments]    ${num1}    ${num2}
    ${num1}    Convert To Number    ${num1}
    ${num2}    Convert To Number    ${num2}
    ${result_ns}    Create Dictionary    x=${num1}    y=${num2}
    ${result}    Evaluate    x-y    namespace=${result_ns}
    ${result}    Evaluate    round(${result}, 4)
    Return From Keyword    ${result}

Convert % discount to VND and round
    [Arguments]    ${num1}    ${num2}
    ${num1}    Convert To Number    ${num1}
    ${num2}    Convert To Number    ${num2}
    ${result_ns}    Create Dictionary    x=${num1}    y=${num2}
    ${result}    Evaluate    (x*y)/100    namespace=${result_ns}
    ${result}    Evaluate    round(${result}, 2)
    ${result}    Convert To Number    ${result}    0
    Return From Keyword    ${result}

Sum x 5
    [Arguments]    ${num1}    ${num2}    ${num3}    ${num4}    ${num5}
    ${num1}    Convert To Number    ${num1}
    ${num2}    Convert To Number    ${num2}
    ${num3}    Convert To Number    ${num3}
    ${num4}    Convert To Number    ${num4}
    ${num5}    Convert To Number    ${num5}
    ${result_ns}    Create Dictionary    a=${num1}    b=${num2}    c=${num3}    d=${num4}    e=${num5}
    ${result}    Evaluate    a+b+c+d+e    namespace=${result_ns}
    ${result}    Replace floating point    ${result}
    Return From Keyword    ${result}

Total after % discount
    [Arguments]    ${num1}    ${num2}    ${num3}
    ${num1}    Convert To Number    ${num1}
    ${num2}    Convert To Number    ${num2}
    ${num3}    Convert To Number    ${num3}
    ${result_ns}    Create Dictionary    x=${num1}    y=${num2}    z=${num3}    #x : giá bán, y : % discount, z : số lượng
    ${result}    Evaluate    (x-((x*y)/100))*z    namespace=${result_ns}
    Run Keyword And Return    Convert To Number    ${result}    0

Sum values in list
    [Arguments]    ${list_values}
    ${indext_to_sum}    Set Variable    -1
    ${result_sum}    Set Variable    0
    : FOR    ${item}    IN    @{list_values}
    \    ${indext_to_sum}    Evaluate    ${indext_to_sum} + 1
    \    ${item}    Get From List    ${list_values}    ${indext_to_sum}
    \    ${result_sum}    Sum    ${result_sum}    ${item}
    #\    ${result_sum}    Convert To Number    ${result_sum}    0
    Return From Keyword    ${result_sum}

Sum values in list and round
    [Arguments]    ${list_values}
    ${indext_to_sum}    Set Variable    -1
    ${result_sum}    Set Variable    0
    : FOR    ${item}    IN    @{list_values}
    \    ${indext_to_sum}    Evaluate    ${indext_to_sum} + 1
    \    ${item}    Get From List    ${list_values}    ${indext_to_sum}
    \    ${result_sum}    Sum    ${result_sum}    ${item}
    ${result_sum}=    Evaluate    round(${result_sum}, 0)
    Return From Keyword    ${result_sum}

Sum values in list and round 2
    [Arguments]    ${list_values}
    ${indext_to_sum}    Set Variable    -1
    ${result_sum}    Set Variable    0
    : FOR    ${item}    IN    @{list_values}
    \    ${indext_to_sum}    Evaluate    ${indext_to_sum} + 1
    \    ${item}    Get From List    ${list_values}    ${indext_to_sum}
    \    ${result_sum}    Sum    ${result_sum}    ${item}
    \    ${result_sum}=    Evaluate    round(${result_sum}, 2)
    Return From Keyword    ${result_sum}

Sum and replace floating point
    [Arguments]    ${num1}    ${num2}
    ${num1}    Convert To Number    ${num1}
    ${num2}    Convert To Number    ${num2}
    ${num1}    Evaluate    round(${num1},0)
    ${num2}    Evaluate    round(${num2},0)
    ${result_ns}    Create Dictionary    x=${num1}    y=${num2}
    ${result}    Evaluate    x+y    namespace=${result_ns}
    ${result}    Replace floating point    ${result}
    Return From Keyword    ${result}

Sum and round 2
    [Arguments]    ${num1}    ${num2}
    ${num1}    Convert To Number    ${num1}
    ${num2}    Convert To Number    ${num2}
    ${result_ns}    Create Dictionary    x=${num1}    y=${num2}
    ${result}    Evaluate    x+y    namespace=${result_ns}
    ${result}    Evaluate    round(${result}, 2)
    Return From Keyword    ${result}

Sum and round
    [Arguments]    ${num1}    ${num2}
    ${num1}    Convert To Number    ${num1}
    ${num2}    Convert To Number    ${num2}
    ${result_ns}    Create Dictionary    x=${num1}    y=${num2}
    ${result}    Evaluate    x+y    namespace=${result_ns}
    ${result}    Convert To Number    ${result}    0
    Return From Keyword    ${result}

Generate code automatically
    [Arguments]    ${prefix_code}
    ${hex} =    Generate Random String    6    [NUMBERS]abcdef
    ${code}    Catenate    SEPARATOR=    ${prefix_code}    ${hex}
    Return From Keyword    ${code}

Convert native number
    ${list_result_num_in_instock_trans_branch}    create list    ${EMPTY}
    ${index_in_list_num}    Set Variable    -1
    : FOR    ${item_num}    IN    @{list_nums}
    \    ${index_in_list_num}=    Evaluate    ${index_in_list_num} + 1
    \    ${item_num}    Get From List    ${list_nums}    ${index_in_list_num}
    \    ${item_num}    Minus    0    ${item_num}
    \    Append To List    ${list_result_num_in_instock_trans_branch}    ${item_num}
    Remove From List    ${list_result_num_in_instock_trans_branch}    0
    Log    ${list_result_num_in_instock_trans_branch}

Generate Imei code automatically
    ${imei}    Generate Random String    5    [UPPER][NUMBERS]
    Return From Keyword    ${imei}

Generate Voucher code automatically in list
    [Arguments]    ${number}
    ${list_voucher_code}    Create List
    : FOR    ${item_num}    IN RANGE    ${number}
    \    ${vo_code}    Generate Random String    8    [UPPER][NUMBERS]
    \    Append To List    ${list_voucher_code}    ${vo_code}
    Return From Keyword    ${list_voucher_code}

Minusx3 and replace foating point
    [Arguments]    ${num1}    ${num2}    ${num3}
    ${num1}    Convert To Number    ${num1}
    ${num2}    Convert To Number    ${num2}
    ${num3}    Convert To Number    ${num3}
    ${result_ns}    Create Dictionary    x=${num1}    y=${num2}    z=${num3}
    ${result}    Evaluate    x-y-z    namespace=${result_ns}
    ${result}    Replace floating point    ${result}
    Return From Keyword    ${result}

VND and Percentage Surcharges sum
    [Arguments]    ${price}    ${sur_percentage}    ${sur2}
    ${surcharge_convert_to_vnd}    Convert % discount to VND and round    ${price}    ${sur_percentage}
    ${total_surcharge}    Sum    ${surcharge_convert_to_vnd}    ${sur2}
    Return From Keyword    ${total_surcharge}

Percentage and Percentage Surcharges sum
    [Arguments]    ${num}    ${percentage1}    ${percentage2}
    ${surcharge1_convert_to_vnd}    Convert % discount to VND and round    ${num}    ${percentage1}
    ${surcharge2_convert_to_vnd}    Convert % discount to VND and round    ${num}    ${percentage2}
    ${total_surcharge}    Sum    ${surcharge1_convert_to_vnd}    ${surcharge2_convert_to_vnd}
    Return From Keyword    ${total_surcharge}

Get text and convert to number
    [Arguments]    ${location}
    ${get_text}    Get text    ${location}
    ${get_text}    Replace String    ${get_text}    ,    ${EMPTY}
    ${number}    Convert To Number    ${get_text}
    Return From Keyword    ${number}

Price after apllocate discount
    [Arguments]    ${num1}    ${num2}    ${num3}
    ${num1}    Convert To Number    ${num1}
    ${num2}    Convert To Number    ${num2}
    ${num3}    Convert To Number    ${num3}
    ${result_ns}    Create Dictionary    x=${num1}    y=${num2}    z=${num3}    #x : giam gia hoa don, y :tong tien hang tra, z : thành tiền của sản phẩm
    ${result}    Evaluate    (x/y)*z    namespace=${result_ns}
    #${result}    Evaluate    round(${result}, 2)
    Return From Keyword    ${result}

Price after apllocate discount and round
    [Arguments]    ${num1}    ${num2}    ${num3}
    ${result}   Price after apllocate discount    ${num1}    ${num2}    ${num3}
    ${result}   Evaluate    round(${result},0)
    Return From Keyword    ${result}

Devision
    [Arguments]    ${num1}    ${num2}
    ${num1}    Convert To Number    ${num1}
    ${num2}    Convert To Number    ${num2}
    ${result_ns}    Create Dictionary    x=${num1}    y=${num2}
    ${result}    Evaluate    x/y    namespace=${result_ns}
    Return From Keyword    ${result}

Devision and round
    [Arguments]    ${num1}    ${num2}
    ${num1}    Convert To Number    ${num1}
    ${num2}    Convert To Number    ${num2}
    ${result_ns}    Create Dictionary    x=${num1}    y=${num2}
    ${result}    Evaluate    x/y    namespace=${result_ns}
    ${result}     Evaluate    round(${result},0)
    ${result}   Replace floating point    ${result}
    Return From Keyword    ${result}

Devision and round down
    [Arguments]    ${num1}    ${num2}
    ${num1}    Convert To Number    ${num1}
    ${num2}    Convert To Number    ${num2}
    ${result_ns}    Create Dictionary    x=${num1}    y=${num2}
    ${result}    Evaluate    x/y    namespace=${result_ns}
    ${result}   Convert from number to interger    ${result}
    Return From Keyword    ${result}

Devision and round any number
    [Arguments]    ${num1}    ${num2}   ${round}
    ${num1}    Convert To Number    ${num1}
    ${num2}    Convert To Number    ${num2}
    ${result_ns}    Create Dictionary    x=${num1}    y=${num2}
    ${result}    Evaluate    x/y    namespace=${result_ns}
    ${result}     Evaluate    round(${result},${round})
    Return From Keyword    ${result}

Average cost of capital af purchase order have discount
    [Arguments]    ${price}    ${soluong}    ${giavon_prev}    ${soluong_prev}    ${discount}    ${total}
    ${price}    Convert To Number    ${price}
    ${discount}    Convert To Number    ${discount}
    ${total}    Convert To Number    ${total}
    ${result_ns}    Create Dictionary    a=${price}    b=${discount}    c=${total}
    ${giavon_ngam}    Evaluate    a+(a*(0-b))/c    namespace=${result_ns}
    ${cost}    Average Cost Of Capital    ${giavon_ngam}    ${soluong}    ${giavon_prev}    ${soluong_prev}    2
    Return From Keyword    ${cost}

Average cost of capital af purchase order have discount and expenses
    [Arguments]    ${price}    ${soluong}    ${giavon_prev}    ${soluong_prev}    ${discount}    ${total}
    ...    ${expense_value}
    ${price}    Convert To Number    ${price}
    ${discount}    Convert To Number    ${discount}
    ${total}    Convert To Number    ${total}
    ${expense_value}    Convert To Number    ${expense_value}
    ${result_ns}    Create Dictionary    a=${price}    b=${discount}    c=${total}    d=${expense_value}
    ${giavon_ngam}    Evaluate    a+(a*(d-b))/c    namespace=${result_ns}
    ${cost}    Average Cost Of Capital    ${giavon_ngam}    ${soluong}    ${giavon_prev}    ${soluong_prev}    2
    Return From Keyword    ${cost}

Average cost of capital allocated after purchase receipt
    [Arguments]    ${price}    ${expense_value}    ${discount}    ${total}
    ${price}    Convert To Number    ${price}
    ${discount}    Convert To Number    ${discount}
    ${total}    Convert To Number    ${total}
    ${expense_value}    Convert To Number    ${expense_value}
    ${result_ns}    Create Dictionary    a=${price}    b=${discount}    c=${total}    d=${expense_value}
    ${giavon_ngam}    Evaluate    a+(a*(d-b))/c    namespace=${result_ns}
    Return From Keyword    ${giavon_ngam}

Average cost of capital af purchase return
    [Arguments]    ${price}    ${soluong}    ${giavon_prev}    ${soluong_prev}    ${discount}    ${total}
    ...    ${expense_value}
    ${price}    Convert To Number    ${price}
    ${discount}    Convert To Number    ${discount}
    ${total}    Convert To Number    ${total}
    ${expense_value}    Convert To Number    ${expense_value}
    ${result_ns}    Create Dictionary    a=${price}    b=${discount}    c=${total}    d=${expense_value}
    ${giavon_ngam}    Evaluate    a+(a*(d-b))/c    namespace=${result_ns}
    ${cost}    Average Cost Of Capital Minus    ${giavon_ngam}    ${soluong}    ${giavon_prev}    ${soluong_prev}    2
    ${cost}     Evaluate    round(${cost},2)
    Return From Keyword    ${cost}

Price after % increase product
    [Arguments]    ${num1}    ${num2}    ${percision}=0
    ${num1}    Convert To Number    ${num1}
    ${num2}    Convert To Number    ${num2}
    ${result_ns}    Create Dictionary    x=${num1}    y=${num2}
    ${result}    Evaluate    x+((x*y)/100)    namespace=${result_ns}
    ${result}    Evaluate    round(${result}, 2)
    Return From Keyword    ${result}

Sum values in list and not round
    [Arguments]    ${list_values}
    ${indext_to_sum}    Set Variable    -1
    ${result_sum}    Set Variable    0
    : FOR    ${item}    IN    @{list_values}
    \    ${indext_to_sum}    Evaluate    ${indext_to_sum} + 1
    \    ${item}    Get From List    ${list_values}    ${indext_to_sum}
    \    ${result_sum}    Sum    ${result_sum}    ${item}
    \    ${result_sum}    Convert To Number    ${result_sum}
    Return From Keyword    ${result_sum}

Sum and round 3
    [Arguments]    ${num1}    ${num2}
    ${num1}    Convert To Number    ${num1}
    ${num2}    Convert To Number    ${num2}
    ${result_ns}    Create Dictionary    x=${num1}    y=${num2}
    ${result}    Evaluate    x+y    namespace=${result_ns}
    ${result}    Evaluate    round(${result}, 3)
    Return From Keyword    ${result}

Convert from number to vnd discount text
    [Arguments]    ${number}    ${string_to_remove}    ${string_zero_added}
    ${converted_text}    Convert To String    ${number}
    ${converted_text}    Remove String    ${converted_text}    ${string_to_remove}
    ${converted_text}    Catenate    SEPARATOR=    ${converted_text}    ${string_zero_added}
    Return From Keyword    ${converted_text}

Convert from number to ratio discount text
    [Arguments]    ${number}
    ${converted_text}    Convert To String    ${number}
    ${converted_text}    Catenate    SEPARATOR=    ${converted_text}    %
    Return From Keyword    ${converted_text}

Generate Mobile number
    ${hex} =    Generate Random String    7    [NUMBERS]
    ${code}    Catenate    SEPARATOR=    098    ${hex}
    Return From Keyword    ${code}

Convert from number to interger
    [Arguments]   ${number}
    ${number}    Convert To Number       ${number}
    ${number}    Convert To Integer      ${number}
    Return From Keyword    ${number}

Add thousands separator in a number string
    [Arguments]     ${number}
    ${string var}=      Evaluate     '{0:,}'.format(${number})
    Return From Keyword    ${string var}

Minus list numbers
    [Arguments]     ${list_num1}      ${list_num2}
    ${list_result}     Create List
    :FOR      ${item_num1}      ${item_num2}      IN ZIP      ${list_num1}      ${list_num2}
    \     ${result}      Minus    ${item_num1}      ${item_num2}
    \     Append To List    ${list_result}    ${result}
    Return From Keyword    ${list_result}

Multiplication x 3 list numbers with number
    [Arguments]     ${list_num1}    ${num2}   ${num3}
    ${list_result}     Create List
    :FOR      ${item_num1}      IN ZIP      ${list_num1}
    \     ${result}      Multiplication x 3      ${item_num1}    ${num2}      ${num3}
    \     Append To List    ${list_result}    ${result}
    Return From Keyword    ${list_result}
