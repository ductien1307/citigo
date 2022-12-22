*** Settings ***
Library           SeleniumLibrary
Resource          ../share/print_preview.robot
Resource          ../Nhan_vien/nhanvien_list_page.robot

*** Variables ***
${menu_nhanvien}   //li[a[contains(text(),'Nhân viên')][@ng-click]]
${subdomain_nhanvien}    //li[a[contains(text(),'Nhân viên')][@ng-click]]//a[contains(@ng-href,"/#/Employee/")]
${subdomain_chamcong}   //li[a[contains(text(),'Nhân viên')][@ng-click]]//a[contains(@ng-href,"/#/TimeSheet/")]
${subdomain_bangtinhluong}    //li[a[contains(text(),'Nhân viên')][@ng-click]]//a[contains(@ng-href,"/#/Paysheet/")]
${domain_thietlaphoahong}    //li[a[contains(text(),'Nhân viên')][@ng-click]]//a[contains(@ng-href,"/#/Commission/")]

*** Keywords ***
Go to Nhan vien
    Wait Until Page Contains Element    ${menu_nhanvien}    1 min
    Click Element    ${menu_nhanvien}
    Wait Until Page Contains Element    ${subdomain_nhanvien}     30s
    Click Element     ${subdomain_nhanvien}
    Wait Until Page Contains Element    ${textbox_search_nv}    1 min

Go to Cham cong
    Wait Until Page Contains Element    ${menu_nhanvien}    1 min
    Click Element    ${menu_nhanvien}
    Wait Until Page Contains Element    ${subdomain_chamcong}     30s
    Click Element    ${subdomain_chamcong}

Go to Bang tinh luong
    Wait Until Page Contains Element    ${menu_nhanvien}    1 min
    Click Element    ${menu_nhanvien}
    Wait Until Page Contains Element    ${subdomain_bangtinhluong}     30s
    Click Element    ${subdomain_bangtinhluong}

Go to Thiet lap hoa hong
    Wait Until Page Contains Element    ${menu_nhanvien}    1 min
    Click Element    ${menu_nhanvien}
    Wait Until Page Contains Element    ${domain_thietlaphoahong}     30s
    Click Element    ${domain_thietlaphoahong}
