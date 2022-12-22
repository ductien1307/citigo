*** Settings ***
Library           SeleniumLibrary
Resource          ../share/print_preview.robot
Resource          ../share/global.robot

*** Variables ***
${menu_doitac}     //a[text()='Đối tác']
${subdomain_doitac}    //li[a[text()='Đối tác']]//ul[contains(@class, 'sub')]//li//a[text()='Nhà cung cấp']
${subdomain_khachhang}    //a[text()='Đối tác']/parent::li//a[text()='Khách hàng']
${subdomain_dt_giaohang}    //li[a[text()='Đối tác']]//ul[contains(@class, 'sub')]//li//a[text()='Đối tác giao hàng']
${domain_khachhang}    //li[a[text()='Đối tác']]//ul[contains(@class, 'sub')]//li//a[text()='Khách hàng']

*** Keywords ***
Go to Nha cung cap
    Go to Doi Tac
    Wait Until Element Is Enabled    ${subdomain_doitac}      2 mins
    Click Element    ${subdomain_doitac}

Go to Khach Hang
    Wait To Loading Icon Invisible
    Hover Mouse To Element    ${menu_doitac}
    Click Element Global     ${subdomain_khachhang}

Go to Doi Tac Giao hang
    Go to Doi Tac
    Wait Until Element Is Enabled    ${subdomain_dt_giaohang}       2 mins
    Click Element    ${subdomain_dt_giaohang}
    Sleep    5s
    Wait Until Element Is Enabled    ${tab_khac}       1 min
    Wait Until Keyword Succeeds    5x    5x    Click Element    ${tab_khac}

Go to Doi Tac
    Wait Until Page Contains Element    ${menu_doitac}    2 mins
    Click Element    ${menu_doitac}
