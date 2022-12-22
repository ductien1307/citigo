*** Settings ***
Library           SeleniumLibrary
Resource          danh_muc_list_page.robot
Resource          ../share/javascript.robot
Resource          ../share/constants.robot
Resource          hang_hoa_add_page.robot
Resource          thiet_lap_gia_list_page.robot

*** Variables ***
${menu_hh}       //header[contains(@class, 'mainHeader')]//li[2]//a[text()='Hàng hóa']
${domain_danhmuc_hh}    //ul[contains(@class, 'sub')]//li/a[contains(text(), 'Danh mục')]    # danh mục _hh
${domain_sanxuat}    //header[contains(@class, 'mainHeader')]//li[a[text()='Hàng hóa']]//ul[contains(@class, 'sub')]//li/a[text()='Sản xuất']
${domain_phieu_baohanh}     //a[@ng-href="/#/Warranty/"]
${button_them_moi}    //a[@ng-show="_p.has('Product_Create')"]
${button_import_hh}   //a[@ng-click="importProduct()"]
${button_xuatfile_hh}     //a[@ng-click="exportProduct()"]
${nav_themmoi}    //article[contains(@class, 'headerContent')]//div[@class='addProductBtn']//ul
${button_them_hh}    //article[contains(@class, 'headerContent')]//ul//a[text()= ' Thêm hàng hóa']
${button_them_combo}    //article[contains(@class, 'headerContent')]//ul//a[text()=' Thêm Combo - đóng gói']
${button_tao_phieu_sx}     //a[i[@class='far fa-plus']]
${domain_thietlapgia}    //a[contains(text(),'Thiết lập giá')]
${domain_kiemkho}    //header[contains(@class, 'mainHeader')]//li[a[text()='Hàng hóa']]//ul[contains(@class, 'sub')]//li/a[text()='Kiểm kho']
${button_them_dv}    //a[contains(text(),'Thêm dịch vụ')]
${button_them_thuoc}      //article[contains(@class, 'headerContent')]//ul//a[text()= ' Thêm thuốc']

*** Keywords ***
Go To Danh Muc Hang Hoa
    [Timeout]    5 mins
    Wait Until Page Contains Element    ${menu_hh}    2 mins
    Wait Until Keyword Succeeds    3x    3s   Click Element JS    ${menu_hh}
    Wait Until Page Contains Element       ${domain_danhmuc_hh}   30s

Go To San Xuat
    [Timeout]    2 mins
    Wait Until Page Contains Element    ${menu_hh}    2 mins
    Click Element    ${menu_hh}
    KV Click Element    ${domain_sanxuat}
    Wait Until Element Is Visible    //input[@ng-model="filterQuickSearch"]

Go to Them moi Hang Hoa
    [Timeout]   2 mins
    Wait Until Page Contains Element    ${button_them_moi}    1 mins
    Wait Until Keyword Succeeds    3x    3s   Click Element    ${button_them_moi}
    KV Click Element    ${button_them_hh}
    Wait Until Page Contains Element    ${textbox_ma_hh}    1 min

Go to Them moi Combo
    [Timeout]
    Wait Until Page Contains Element    ${button_them_moi}    2 mins
    Wait Until Keyword Succeeds    3x    3s   Click Element    ${button_them_moi}
    KV Click Element    ${button_them_combo}

Go to Thiet lap gia
    Wait Until Page Contains Element    ${menu_hh}    2 mins
    Click Element    ${menu_hh}
    KV Click Element    ${domain_thietlapgia}
    Wait Until Page Contains Element    ${textbox_tlg_timkiem_nhomhang}    1 min

Go to Kiem kho
    [Timeout]
    Wait Until Page Contains Element    ${menu_hh}    2 mins
    Click Element At Coordinates    ${menu_hh}    2    2
    Sleep    2s
    Wait Until Page Contains Element    ${domain_kiemkho}    2 mins
    Click Element JS    ${domain_kiemkho}
    Wait Until Page Contains Element    ${button_kiemkho}    2 mins

Go to Them moi Dich vu
    Wait Until Page Contains Element    ${button_them_moi}    2 mins
    Wait Until Keyword Succeeds    3x    3s      Click Element    ${button_them_moi}
    KV Click Element    ${button_them_dv}

Click DMHH
    Click Element JS    ${domain_danhmuc_hh}
    Wait Until Element Is Visible    ${textbox_search_maten}

Go to Them Thuoc
    [Timeout]
    Wait Until Page Contains Element    ${button_them_moi}    2 mins
    Wait Until Keyword Succeeds    3x    3s      Click Element    ${button_them_moi}
    KV Click Element    ${button_them_thuoc}
    Wait Until Page Contains Element    ${textbox_ma_hh}    1 min

Go To PHieu bao hanh
    [Timeout]    2 mins
    Wait Until Page Contains Element    ${menu_hh}    2 mins
    Click Element JS    ${menu_hh}
    Sleep    2s
    Wait Until Page Contains Element    ${domain_phieu_baohanh}    2 mins
    Click Element     ${domain_phieu_baohanh}
