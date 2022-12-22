*** Settings ***
Library           SeleniumLibrary
Resource          banhang_page.robot
Resource          ../share/print_preview.robot
Resource          ../share/popup.robot
Resource          ../share/discount.robot

*** Variables ***
${button_banhang}    //nav[contains(@class, 'mainNav')]/section/ul/li/a[text()='Bán hàng']

*** Keywords ***
Go to Ban Hang from Menu page
    [Timeout]    30 seconds
    Wait Until Element Is Enabled    ${button_banhang}
    Click Element    ${button_banhang}
    #${has_popup}==    Element Should Be Visible    ${button_close_popup}
    #Run Keyword If    '${has_popup}' == 'None'    Click Element    ${button_close_popup}
    ...    # ELSE    Wait Until Element Is Enabled    ${textbox_bh_search_ma_sp}
    Deactivate print preview page

Go to tuy chon hien thi
    [Arguments]   ${xpath_icon_tuychonhienthi}
    [Timeout]    5 mins
    Set Selenium Speed    0.5s
    Wait Until Page Contains Element    ${button_menubar}    1 mins
    Click Element JS    ${button_menubar}
    Wait Until Page Contains Element    ${cell_tuychon_hienthi}    30s
    Click Element JS    ${cell_tuychon_hienthi}
    Wait Until Page Contains Element    ${xpath_icon_tuychonhienthi}    30s
    Click Element JS    ${xpath_icon_tuychonhienthi}
    Click Element JS    ${button_close}

Go to Lap phieu thu
    Set Selenium Speed    2s
    Wait Until Page Contains Element    ${button_menubar}    2 mins
    Click Element JS    ${button_menubar}
    Wait Until Page Contains Element    ${cell_lapphieuthu}    2 mins
    Click Element JS    ${cell_lapphieuthu}
