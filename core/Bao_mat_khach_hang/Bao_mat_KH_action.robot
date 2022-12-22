*** Settings ***
Library           SeleniumLibrary
Resource          dangkymoi_page.robot
Resource          ../share/constants.robot
Resource          ../share/javascript.robot
Resource          ../share/computation.robot
Resource          ../share/discount.robot
Resource          Bao_mat_KH_page.robot
Library           Dialogs
Library           String

*** Keywords ***
Set row and column in excel
    [Documentation]    vị trí các cột cần check thông tin trong file excel
    [Arguments]    ${number_in_detail}    ${index}     ${cell_inv}    ${cell_name}    ${cell_email}    ${cell_phone}    ${cell_address}
    ${result}    Minus    ${number_in_detail}    ${index}
    ${result1}    Convert To String    ${result}
    ${resp}    Replace String    ${result1}    .0    ${EMPTY}
    ${excel_inv}    Format String     ${cell_inv}    ${resp}
    ${excel_name}    Format String     ${cell_name}    ${resp}
    ${excel_email}    Format String     ${cell_email}    ${resp}
    ${excel_phone}    Format String     ${cell_phone}    ${resp}
    ${excel_address}    Format String     ${cell_address}    ${resp}
    Return From Keyword     ${excel_inv}    ${excel_name}    ${excel_email}     ${excel_phone}    ${excel_address}
