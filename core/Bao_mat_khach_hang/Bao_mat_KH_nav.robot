*** Settings ***
Library           SeleniumLibrary
Resource          ../share/print_preview.robot
Resource          dat_hang_page.robot
Resource          ../share/javascript.robot

*** Variables ***
${menu_user}    //section[contains(@class,'user')]//span[text()='{0}']   #ten user
${domain_taikhoan}    //section[contains(@class,'user')]//ul//li[a[text()=' Tài khoản']]
${domain_dangxuat}    //section[contains(@class,'user')]//ul//li[a[text()=' Đăng xuất']]
${select_column}    //span[@class='k-link']//span[@class='k-icon k-i-arrow-s']
${checkbox_email}    //label[normalize-space()='Email']
${checkbox_phone}    //label[contains(text(),'Điện thoại')]
${checkbox_address}    //label[contains(text(),'Địa chỉ')]
*** Keywords ***
Go to Tai khoan popup
    [Arguments]     ${input_ten_user}
    ${menu}   Format String     ${menu_user}     ${input_ten_user}
    Click Element    ${menu}
    Wait Until Element Is Visible    ${domain_taikhoan}
    Click Element    ${domain_taikhoan}

Delete device
    Wait Until Element Is Visible    ${button_delete_device}    1 min
    Click Element JS    ${button_delete_device}
    Wait Until Element Is Visible    ${button_confirm_popup_ngungtruycap}    1 min
    Click Element JS    ${button_confirm_popup_ngungtruycap}

Add column email phone and address to export file
    Wait Until Element Is Visible    ${select_column}    1 min
    Click Element JS    ${select_column}
    Wait Until Element Is Visible    ${checkbox_email}    1 min
    Click Element JS    ${checkbox_email}
    Click Element JS    ${checkbox_phone}
    Click Element JS    ${checkbox_address}
