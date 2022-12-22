*** Settings ***
Library           SeleniumLibrary
Library           StringFormat
Library           String
Resource          ../share/computation.robot
Resource          ../share/javascript.robot
Resource          dat_hang_nhap_add_page.robot
Resource          dat_hang_nhap_list_page.robot
Resource          ../share/discount.robot
Resource          nhap_hang_add_page.robot

*** Keywords ***
Go to tao phieu DHN
    Wait Until Page Contains Element    ${button_tao_phieu_dhn}    1 min
    Click Element JS   ${button_tao_phieu_dhn}
    Wait Until Page Contains Element    ${textbox_dhn_tim_kiem_sp}    1 min

Search purchase order code and click open
    [Arguments]    ${ma_phieu}
    Search purchase order cođe    ${ma_phieu}
    Wait Until Element Is Visible    ${button_dhn_mo_phieu}   10s
    Sleep     1s
    Click Element    ${button_dhn_mo_phieu}

Search purchase order cođe
    [Arguments]    ${ma_phieu}
    Wait Until Page Contains Element    ${textbox_dhn_search_ma_phieu}    1 min
    Input data    ${textbox_dhn_search_ma_phieu}    ${ma_phieu}
    Sleep    1s

Search purchase order code and cllick PO Receipt
    [Arguments]    ${ma_phieu}
    Search purchase order cođe    ${ma_phieu}
    Wait Until Page Contains Element    ${button_dhn_tao_phieu_nhap}    1 min
    Click Element JS    ${button_dhn_tao_phieu_nhap}
    Wait Until Page Contains Element    ${textbox_nh_ma_phieunhap}    1 min
