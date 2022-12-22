*** Settings ***
Library           SeleniumLibrary
Library           String
Resource          banhang_page.robot
Resource          ../share/print_preview.robot
Resource          ../share/popup.robot
Resource          ../share/discount.robot
Resource          ../share/javascript.robot
Resource          ../API/api_danhmuc_hanghoa.robot
Resource          ../Hang_Hoa/danh_muc_list_page.robot
Resource          ../Dat_Hang/dat_hang_page.robot

*** Variables ***
${button_export_invoice}    //div[contains(@class,'addProductBtn')]//a[contains(@class,'kv2BtnExport')]
${item_button_export_invoice}   //div[contains(@class,'addProductBtn')]//ul//a[text()=' Xuất file danh sách tổng quan']
${item_button_export_detail_inv}   //div[contains(@class,'addProductBtn')]//ul//a[text()=' Xuất file danh sách chi tiết']
${button_import_invoice}      //a[i[@class='far fa-sign-in']]
${textbox_search_manager_all}   //article[contains(@class, 'columnViewTwo')]//input[@ng-enter='quickSearch(true)']
${button_trahang_in_invoice}    //div[contains(@class,'kv-group-btn')]//a[@ng-click='update()']
${noti_export}       //a[@class='noti_link ng-binding']
${cell_item_export_tongquan}   //div[contains(@class,'addProductBtn')]//ul//a[text()=' File tổng quan']
${cell_item_export_chitiet}   //div[contains(@class,'addProductBtn')]//ul//a[text()=' File chi tiết']
${label_trans_code_in_QL}   //table[@role='treegrid']//td[contains(@class,'cell-code')]//span[text()='{0}']   #code trans
${cell_trans_code_in_other_form}    //table[@role='treegrid']//td[contains(@class,'cell-code')]//span[text()='{0} ']   #code trans
${button_thao_tac}    //span[normalize-space()='Thao tác']
${cell_item_export_multi}    //a[@ng-click='exportMulti()']
${cell_item_export_detail_multi}    //a[@ng-click='exportDetailMulti()']

*** Keywords ***
Search code frm manager
    [Arguments]   ${input_code}
    Wait Until Page Contains Element    ${textbox_search_manager_all}    1 mins
    Input data    ${textbox_search_manager_all}    ${input_code}

Go to select export file
    [Arguments]   ${button_export}   ${input_code}
    ${label_code_in_QL}   Format String     ${label_trans_code_in_QL}   ${input_code}
    Wait Until Page Contains Element    ${label_code_in_QL}    1 mins
    ${get_trans_code_UI}    Get Text    ${label_code_in_QL}
    ${get_trans_code_UI}    Replace String    ${get_trans_code_UI}    ${SPACE}    ${EMPTY}
    Should Be Equal As Strings    ${get_trans_code_UI}    ${input_code}
    Wait Until Page Contains Element    ${button_export_invoice}    1 mins
    Click Element JS    ${button_export_invoice}
    Sleep    1s
    Wait Until Page Contains Element    ${button_export}    1 mins
    Click Element JS    ${button_export}

Go to select export file other form
    [Arguments]   ${button_export}   ${input_code}
    ${label_code_in_QL}   Format String     ${cell_trans_code_in_other_form}   ${input_code}
    Wait Until Page Contains Element    ${label_code_in_QL}    1 mins
    ${get_trans_code_UI}    Get Text    ${label_code_in_QL}
    ${get_trans_code_UI}    Replace String    ${get_trans_code_UI}    ${SPACE}    ${EMPTY}
    Should Be Equal As Strings    ${get_trans_code_UI}    ${input_code}
    Wait Until Page Contains Element    ${button_export_invoice}    1 mins
    Click Element JS    ${button_export_invoice}
    Sleep    1s
    Wait Until Page Contains Element    ${button_export}    1 mins
    Click Element JS    ${button_export}

Go to select import invoice
    Wait Until Page Contains Element    ${button_export_invoice}    1 mins
    Click Element JS    ${button_export_invoice}
    Sleep    1s
    Wait Until Page Contains Element    ${button_import_invoice}    1 mins
    Click Element JS    ${button_import_invoice}

Go to select export multiple
    Wait Until Page Contains Element    ${button_thao_tac}    1 mins
    Click Element JS    ${button_export_invoice}
    Sleep    1s
    Wait Until Page Contains Element    ${cell_item_export_multi}    1 mins
    Click Element JS    ${cell_item_export_multi}

Go to select export detail multiple
    Wait Until Page Contains Element    ${button_thao_tac}    1 mins
    Click Element JS    ${button_export_invoice}
    Sleep    1s
    Wait Until Page Contains Element    ${cell_item_export_detail_multi}    1 mins
    Click Element JS    ${cell_item_export_detail_multi}
