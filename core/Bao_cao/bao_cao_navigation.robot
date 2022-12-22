*** Settings ***
Library           SeleniumLibrary

*** Variables ***
${domain_baocao}    //a[contains(text(),'Báo cáo')]
${domain_bc_cuoingay}    //a[contains(text(),'Cuối ngày')]
${domain_bc_banhang}    //a[contains(text(),'Bán hàng')][contains(@ng-href,"/#/SaleReport/")]
${domain_bc_dathang}    //a[contains(text(),'Đặt hàng')][contains(@ng-href,"/#/OrderReport/")]
${domain_bc_hanghoa}    //a[contains(text(),'Hàng hóa')][contains(@ng-href,"/#/ProductReport/")]
${domain_bc_khachhang}    //a[contains(text(),'Khách hàng')][contains(@ng-href,"/#/CustomerReport/")]
${domain_bc_nhacungcap}    //a[contains(text(),'Nhà cung cấp')][contains(@ng-href,"/#/SupplierReport/")]
${domain_bc_nhanvien}   //a[contains(@href,'/#/SaleReport/')]
${domain_bc_kenhbanhang}    //a[contains(text(),'Kênh bán hàng')]
${domain_bc_taichinh}    //a[contains(text(),'Tài chính')]

*** Keywords ***
Go to Bao cao
    Wait Until Page Contains Element    ${domain_baocao}    2 mins
    Click Element    ${domain_baocao}

Go to BC cuoi ngay
    Go to Bao cao
    Wait Until Page Contains Element    ${domain_bc_cuoingay}    1 min
    Click Element    ${domain_bc_cuoingay}

Go to BC ban hang
    Go to Bao cao
    Wait Until Page Contains Element    ${domain_bc_banhang}    1 min
    Click Element    ${domain_bc_banhang}

Go to BC dat hang
    Go to Bao cao
    Wait Until Page Contains Element    ${domain_bc_dathang}    1 min
    Click Element    ${domain_bc_dathang}

Go to BC hang hoa
    Go to Bao cao
    Wait Until Page Contains Element    ${domain_bc_hanghoa}    1 min
    Click Element    ${domain_bc_hanghoa}

Go to BC khach hang
    Go to Bao cao
    Wait Until Page Contains Element    ${domain_bc_khachhang}    1 min
    Click Element    ${domain_bc_khachhang}

Go to BC nha cung cap
    Go to Bao cao
    Wait Until Page Contains Element    ${domain_bc_nhacungcap}    1 min
    Click Element    ${domain_bc_nhacungcap}

Go to BC nhan vien
    Go to Bao cao
    Wait Until Page Contains Element    ${domain_bc_nhanvien}    1 min
    Click Element    ${domain_bc_nhanvien}

Go to BC kenh ban hang
    Go to Bao cao
    Wait Until Page Contains Element    ${domain_bc_kenhbanhang}    1 min
    Click Element    ${domain_bc_kenhbanhang}

Go to BC tai chinh
    Go to Bao cao
    Wait Until Page Contains Element    ${domain_bc_taichinh}    1 min
    Click Element    ${domain_bc_taichinh}
