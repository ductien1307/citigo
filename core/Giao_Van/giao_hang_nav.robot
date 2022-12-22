*** Settings ***
Library           SeleniumLibrary
Resource          ../share/javascript.robot

*** Variables ***
${button_giaohang_in_bhscr}    //label[@id='deliveryCheckbox']//..//a//span

*** Keywords ***
Open Giao Hang popup
    Click Element JS    ${button_giaohang_in_bhscr}
