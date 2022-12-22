*** Settings ***
Library           SeleniumLibrary
Library           OperatingSystem
Resource          ../../core/login/login_action.robot
Resource          ../../core/share/popup.robot
Resource          popup.robot
Resource          print_preview.robot
Resource          ../Ban_Hang/banhang_navigation.robot

*** Variables ***
${button_select_branch}    //div[@class='header']//li[@class='switch-branch']//span[contains(text(),'select')]
${element_chinhanh_hanoi}    //span[contains(text(),'000003')]
${button_giaohang}    //span[contains(text(),'Giao hàng')]
${checkbox_giaohang}    //label[@id='deliveryCheckbox']//span
*** Keywords ***
Go to Giao Van from Hanoi
    [Timeout]    2 minutes
    Click Element    ${button_select_branch}
    Wait Until Element Is Visible    ${element_chinhanh_hanoi}
    Click Element    ${element_chinhanh_hanoi}
    Sleep    3s
    Wait Until Element Is Visible    ${button_giaohang}
    Click Element    ${button_giaohang}

Before Test Giao Van
    [Timeout]    2 minutes
    Init Test Environment
    Open Browser    ${URL}    ${BROWSER}
    Maximize Browser Window
    Login MHBH by sale url    ${USER_NAME}    ${PASSWORD}
    Go to Giao Van from Hanoi
