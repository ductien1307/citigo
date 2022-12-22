*** Settings ***
Library           SeleniumLibrary
Resource          share/javascript.robot
Resource          hang_hoa/hang_hoa_navigation.robot

*** Variables ***
${button_menu_bhpage}    //div[contains(@class, 'header')]//li[contains(@class, 'menu-bar')]//a[i[contains(@class, 'fa fa-bars')]]
${button_nhaphangtra_menu_bhpage}    //div[contains(@class, 'header')]//li[contains(@class, 'menu-bar')]//ul//li//a//span[contains(text(), 'Nhập hàng trả')]
${button_quanly_menu_bhpage}    //div[contains(@class, 'header')]//li[contains(@class, 'menu-bar')]//ul//li//a//span[contains(text(), 'Quản lý')]
${button_banhang_on_quanly}    //nav[contains(@class, 'mainNav')]//li[contains(@class,'shortcut')]/a[text()='Bán hàng']
${button_mhbh_dangxuat}       //div[contains(@class, 'header')]//li[contains(@class, 'menu-bar')]//ul//li//a//span[contains(text(), 'Đăng xuất')]


*** Keywords ***
Go to Nhap hang tra from Ban hang menu
    Wait Until Element Is Enabled    ${button_menu_bhpage}
    Click Element JS    ${button_menu_bhpage}
    Click Element JS    ${button_nhaphangtra_menu_bhpage}

Go to Quan ly from Ban hang menu
    Focus    ${button_menu_bhpage}
    Click Element JS    ${button_menu_bhpage}
    Wait Until Page Contains Element    ${button_quanly_menu_bhpage}
    Click Element JS    ${button_quanly_menu_bhpage}
    #Wait Until Element Is Enabled    //a[@class='closepop']
    #Click Element JS    //a[@class='closepop']
