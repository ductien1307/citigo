*** Settings ***
Library           SeleniumLibrary
Library           StringFormat
Resource          ../share/javascript.robot
Resource          nhap_hang_list_page.robot
Resource          xuat_huy_list_page.robot
Resource          dat_hang_nhap_list_page.robot
Resource          tra_hang_nhap_list_page.robot
Resource          yeu_cau_sua_chua_list_page.robot
Resource          vandon_list_page.robot


*** Variables ***
${menu_giaodich}    //li[a[text()='Giao dịch']]
${domain_tra_hang}    //li[a[text()='Giao dịch']]//ul[contains(@class, 'sub')]//li/a[text()='Trả hàng']
${domain_dat_hang}    //li[a[text()='Giao dịch']]//ul[contains(@class, 'sub')]//li/a[text()='Đặt hàng']
${domain_hoadon}    //li[a[text()='Giao dịch']]//ul[contains(@class, 'sub')]//li/a[text()='Hóa đơn']
${domain_nhaphang}    //li[a[text()='Giao dịch']]//ul[contains(@class, 'sub')]//li/a[text()='Nhập hàng']
${domain_tra_hang_nhap}    //li[a[text()='Giao dịch']]//ul[contains(@class, 'sub')]//li/a[text()='Trả hàng nhập']
${domain_chuyen_hang}    //li[a[text()='Giao dịch']]//ul[contains(@class, 'sub')]//li/a[text()='Chuyển hàng']
${domain_xuat_huy}    //li[a[text()='Giao dịch']]//ul[contains(@class, 'sub')]//li/a[text()='Xuất hủy']
${domain_dat_hang_nhap}    //li[a[text()='Giao dịch']]//ul[contains(@class, 'sub')]//li/a[text()='Đặt hàng nhập']
${domain_yeucau_suachua}      //li[a[text()='Giao dịch']]//ul[contains(@class, 'sub')]//li/a[text()='Yêu cầu sửa chữa']
${domain_shipping}    //li[a[text()='Giao dịch']]//ul[contains(@class, 'sub')]//li/a[text()='Vận đơn']

*** Keywords ***
Go to Dat hang
    Wait Until Page Contains Element     ${menu_giaodich}   1 min
    Click Element    ${menu_giaodich}
    Wait Until Page Contains Element      ${domain_dat_hang}    1 min
    Click Element    ${domain_dat_hang}

Go to Hoa don
    Wait Until Page Contains Element     ${menu_giaodich}   1 min
    Click Element    ${menu_giaodich}
    Wait Until Page Contains Element      ${domain_hoadon}    1 min
    Click Element    ${domain_hoadon}

Go to Tra hang
    Wait Until Page Contains Element     ${menu_giaodich}   1 min
    Click Element    ${menu_giaodich}
    Wait Until Page Contains Element      ${domain_tra_hang}    1 min
    Click Element    ${domain_tra_hang}

Go To Nhap Hang
    Wait Until Element Is Visible    ${menu_giaodich}
    Click Element At Coordinates    ${menu_giaodich}    2    2
    Click Element    ${domain_nhaphang}
    Wait Until Page Contains Element    ${button_nhap_hang}    15s

Go To Inventory Transfer
    Wait Until Page Contains Element    ${menu_giaodich}    1 min
    Click Element    ${menu_giaodich}
    Wait Until Page Contains Element    ${domain_chuyen_hang}    1 min
    Click Element    ${domain_chuyen_hang}

Go To Tra Hang Nhap
    Wait Until Element Is Visible    ${menu_giaodich}
    Click Element    ${menu_giaodich}
    Wait Until Element Is Enabled    ${domain_tra_hang_nhap}
    Click Element At Coordinates    ${domain_tra_hang_nhap}    2    2
    Wait Until Page Contains Element    ${textbox_thn_search_ma_phieu}

Go To Tao phieu Xuat Huy
    Wait Until Page Contains Element    ${menu_giaodich}    1 min
    Click Element    ${menu_giaodich}
    Wait Until Page Contains Element    ${domain_xuat_huy}    1 min
    Click Element    ${domain_xuat_huy}
    Wait Until Page Contains Element    ${button_taophieu_xh}    1 min
    Click Element    ${button_taophieu_xh}

Go to Xuat Huy
    Wait Until Page Contains Element    ${menu_giaodich}    1 min
    Click Element    ${menu_giaodich}
    Wait Until Page Contains Element    ${domain_xuat_huy}    1 min
    Click Element    ${domain_xuat_huy}
    Wait Until Page Contains Element    ${textbox_search_ma_xh}    1 min

Go to Dat Hang Nhap
    Wait Until Page Contains Element    ${menu_giaodich}    1 min
    Click Element    ${menu_giaodich}
    Wait Until Page Contains Element    ${domain_dat_hang_nhap}    1 min
    Click Element    ${domain_dat_hang_nhap}
    Wait Until Page Contains Element    ${textbox_dhn_search_ma_phieu}    1 min

Go to Yeu Cau Sua Chua
    Wait Until Page Contains Element    ${menu_giaodich}    1 min
    Click Element    ${menu_giaodich}
    Wait Until Page Contains Element    ${domain_yeucau_suachua}    1 min
    Click Element    ${domain_yeucau_suachua}
    Wait Until Page Contains Element    ${textbox_search_ma_yeu_cau}    1 min

Go to Shipping
    Wait Until Page Contains Element    ${menu_giaodich}    1 min
    Click Element    ${menu_giaodich}
    Wait Until Page Contains Element    ${domain_shipping}    1 min
    Click Element    ${domain_shipping}
    Wait Until Page Contains Element    ${textbox_search_ma_van_don}    1 min
