*** Settings ***
Library           OperatingSystem
Library           ExcelRobot
Library           ExcelLibrary
Resource          computation.robot
Library           ../../lib/customlib.py

*** Keywords ***
Change excel format
    Move File    H:${/}Exported Files${/}Products.xlsx    H:${/}Exported Files${/}Products.xls
    Wait Until Created    H:${/}Exported Files${/}Products.xls    30s

Update code in file excel
    [Arguments]    ${input_col_name}   ${input_code}
    ${list_col_name}      Create List
    ${item_col}     Set Variable    0
    ${list_col_value}     Create List
    :FOR    ${index}     IN RANGE      100
    \       ${item_col}     Sum    ${item_col}    1
    \       ${get_name_col}     Read Excel Cell    2    ${item_col}
    \       Run Keyword If    '${get_name_col}'!='None'   Append To List    ${list_col_name}    ${get_name_col}    ELSE      Exit For Loop
    Log    ${list_col_name}
    ${get_col_num}     Get Index From List    ${list_col_name}    ${input_col_name}
    ${get_col_num}      Sum    ${get_col_num}    1
    ${row_num}      Set Variable    2
    :FOR      ${item_col}     IN RANGE      100
    \     ${row_num}     Sum    ${row_num}    1
    \     ${get_value}     Read Excel Cell    ${row_num}     ${get_col_num}
    \     Run Keyword If    '${get_value}'!='None'     Write Excel Cell    ${row_num}    ${get_col_num}      ${input_code}      ELSE      Exit For Loop
    Return From Keyword     ${row_num}

Get list value by column name in Excel
    [Arguments]         ${input_col_name}       ${input_row_num}
    ${list_col_name}      Create List
    ${item_col}     Set Variable    0
    ${list_col_value}     Create List
    :FOR    ${index}     IN RANGE      100
    \       ${item_col}     Sum    ${item_col}    1
    \       ${get_name_col}     Read Excel Cell    2    ${item_col}
    \       Run Keyword If    '${get_name_col}'!='None'   Append To List    ${list_col_name}    ${get_name_col}    ELSE      Exit For Loop
    Log    ${list_col_name}
    ${list_value}     Create List
    ${get_col_num}     Get Index From List    ${list_col_name}    ${input_col_name}
    ${get_col_num}      Sum    ${get_col_num}    1
    ${row_num}      Set Variable    2
    :FOR      ${item_row}     IN RANGE      100
    \     ${row_num}     Sum    ${row_num}    1
    \     ${get_value}     Read Excel Cell    ${row_num}     ${get_col_num}
    \     ${get_value}      Set Variable If    '${get_value}'=='None'     0    ${get_value}
    \     Exit For Loop If    ${row_num}==${input_row_num}
    \     Append To List    ${list_value}    ${get_value}
    Log    ${list_value}
    Return From Keyword     ${list_value}

Update list value in file excel
    [Arguments]    ${input_col_name}   ${list_value}
    ${list_col_name}      Create List
    ${item_col}     Set Variable    0
    ${list_col_value}     Create List
    :FOR    ${index}     IN RANGE      100
    \       ${item_col}     Sum    ${item_col}    1
    \       ${get_name_col}     Read Excel Cell    2    ${item_col}
    \       Run Keyword If    '${get_name_col}'!='None'   Append To List    ${list_col_name}    ${get_name_col}    ELSE      Exit For Loop
    Log    ${list_col_name}
    ${get_col_num}     Get Index From List    ${list_col_name}    ${input_col_name}
    ${get_col_num}      Sum    ${get_col_num}    1
    ${row_num}      Set Variable    2
    :FOR      ${item_value}     IN ZIP      ${list_value}
    \     ${row_num}     Sum    ${row_num}    1
    \     ${get_value}     Read Excel Cell    ${row_num}     ${get_col_num}
    \     ${item_value}     Replace sq blackets    ${item_value}
    \     Run Keyword If    '${get_value}'!='None'     Write Excel Cell    ${row_num}    ${get_col_num}      ${item_value}

Update multi code in file excel
    [Arguments]    ${input_col_name}
    ${list_col_name}      Create List
    ${item_col}     Set Variable    0
    ${list_col_value}     Create List
    :FOR    ${index}     IN RANGE      100
    \       ${item_col}     Sum    ${item_col}    1
    \       ${get_name_col}     Read Excel Cell    2    ${item_col}
    \       Run Keyword If    '${get_name_col}'!='None'   Append To List    ${list_col_name}    ${get_name_col}    ELSE      Exit For Loop
    Log    ${list_col_name}
    ${get_col_num}     Get Index From List    ${list_col_name}    ${input_col_name}
    ${get_col_num}      Sum    ${get_col_num}    1
    ${row_num}      Set Variable    2
    ${list_invoice_code}      Create LIst
    :FOR      ${item_col}     IN RANGE      100
    \     ${row_num}     Sum    ${row_num}    1
    \     ${get_value}     Read Excel Cell    ${row_num}     ${get_col_num}
    \     ${invoice_code}     Generate code automatically     HDIP
    \     Run Keyword If    '${get_value}'!='None'    Append To List    ${list_invoice_code}    ${invoice_code}
    \     Run Keyword If    '${get_value}'!='None'     Write Excel Cell    ${row_num}    ${get_col_num}      ${invoice_code}      ELSE      Exit For Loop
    Log    ${list_invoice_code}
    Return From Keyword     ${list_invoice_code}

Open Excel By Python
    [Arguments]    ${path_folder_to_excelName}
    ${excelOpened}   openExcelPython   ${path_folder_to_excelName}
    Return From Keyword   ${excelOpened}

Get All Row Value By Python
    [Arguments]    ${excelOpened}   ${rowNumber}
    @{listValue}   getAllRowValuePython  ${excelOpened}   ${rowNumber}
    Return From Keyword   @{listValue}

Get All Column Value By Python
    [Arguments]    ${excelOpened}   ${columnNumber}
    @{listValue}   getAllRowValuePython  ${excelOpened}   ${columnNumber}
    Return From Keyword   @{listValue}

Get Cell Value By Python
    [Arguments]    ${excelOpened}   ${rowNumber}   ${columnNumber}
    ${value}   getCellValuePython  ${excelOpened}   ${rowNumber}   ${columnNumber}
    Return From Keyword   ${value}

Get All Column Value From Speacial Row By Python
    [Arguments]    ${excelOpened}   ${columnNumber}   ${rowNumber}
    @{listValue}   getAllColumnValueFromSpecialRowPython    ${excelOpened}    ${columnNumber}    ${rowNumber}
    Return From Keyword   @{listValue}
