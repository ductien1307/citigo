*** Settings ***
Suite Setup       Setup Test Suite    Before Test Thiet lap gia
Suite Teardown     After Test
Resource          ../../../core/API/api_thietlapgia.robot
Resource          ../../../core/Hang_Hoa/thiet_lap_gia_list_action.robot
Resource          ../../../core/Hang_Hoa/thiet_lap_gia_list_page.robot
Resource          ../../../core/API/api_danhmuc_hanghoa.robot
Library           SeleniumLibrary

*** Variables ***
@{list_cat}       Chuyển 1    Kho1
@{prd}            NHP029    NHP030
&{dict_hh_giamoi}    NHP022=230000    NHP023=15000.23
&{dict_hh_gg}     NHP024=5000    NHP028=20
@{list_bg1}       Giá vốn    Giá chung
&{dict_hh_tg}     NHP029=5000    NHP030=20
@{list_bg2}       Giá nhập lần cuối    Giá hiện tại

*** Test Cases ***    Tên BG      Nhóm hàng      SP nhập giiá mới    SP giảm giá          Bảng giá    SP tăng giá    Bảng giá
Thêm và thay đổi giá tất cả sp
                      [Tags]         TLG
                      [Template]     tlbg4
                      [Documentation]     Thêm bảng giá mới > thay đổi giá của sản phẩm trong bảng giá và chọn áp dụng cho tất cả sản phẩm trong bảng giá
                      BCBBB1      ${list_cat}    ${prd}              Giá vốn              giảm        20             yes
                      BCBBB2      ${list_cat}    ${prd}              Giá chung            giảm        20000          no
                      BCBBB3      ${list_cat}    ${prd}              Bảng giá test TLG    tăng        20000          yes
                      BCBBB4      ${list_cat}    ${prd}              Giá hiện tại         tăng        50             no

Thêm và thay đổi giá sp trong bảng giá
                      [Tags]         TLG
                      [Template]     tlbg5
                      [Documentation]     Thêm bảng giá mới > thay đổi giá của sản phẩm trong bảng giá
                      BGAAA      ${list_cat}    ${dict_hh_giamoi}    ${dict_hh_gg}    ${list_bg1}    ${dict_hh_tg}    ${list_bg2}
                      BGAAB      ${list_cat}    ${dict_hh_giamoi}    ${dict_hh_gg}    ${list_bg2}    ${dict_hh_tg}    ${list_bg1}

Thêm và thay đổi giá tất cả sp
                      [Tags]         GOLIVE2
                      [Template]     tlbg4
                      [Documentation]     Thêm bảng giá mới > thay đổi giá của sản phẩm trong bảng giá và chọn áp dụng cho tất cả sản phẩm trong bảng giá
                      BCBBB1      ${list_cat}    ${prd}              Giá chung            giảm        20000          yes

*** Keywords ***
tlbg4
    [Arguments]       ${ten_bang_gia}    ${list_ten_nhom}    ${list_prd}    ${gia_ss}    ${tanggiam}    ${value}    ${confirm}
    Log    tính toán giá sản phẩm af ex
    Delete price book if it exists    ${ten_bang_gia}
    ${list_new_price}   Get and compute list new price by general infor in price book    ${list_prd}    ${value}    ${tanggiam}    ${gia_ss}
    Log    step UI
    Go To    ${URL}/#/PriceBook
    Add new price book    ${ten_bang_gia}
    Add list category into price book and validate data    ${ten_bang_gia}     ${list_ten_nhom}
    Add list product into price book and validate data     ${list_prd}
    Change price for all product in price book    ${list_prd[0]}    ${gia_ss}    ${value}    ${tanggiam}    ${confirm}
    Click Element    ${button_banhang_on_quanly}
    Sleep    10s
    Log    validate giá qua API và MHBH
    Wait Until Keyword Succeeds    3x    1s   Assert price in price book vs price in MHBH    ${ten_bang_gia}    ${list_prd}    ${list_new_price}
    Assert list price in price book thr API    ${ten_bang_gia}    ${list_prd}    ${list_new_price}
    Run Keyword If    '${gia_ss}'!='Giá hiện tại' and '${confirm}'=='yes'     Assert price and value in tab Advanced settings    ${ten_bang_gia}
    ...    ${gia_ss}   ${tanggiam}     ${value}
    Delete price book thr API    ${ten_bang_gia}

tlbg5
    [Arguments]     ${ten_bang_gia}     ${list_ten_nhom}    ${dict_pr_nhap}    ${dict_pr_gg}    ${list_bg_gg}    ${dict_pr_tg}    ${list_bg_tg}
    ${list_pr_nhap}    Get Dictionary Keys    ${dict_pr_nhap}
    ${list_nhap_gia}    Get Dictionary Values    ${dict_pr_nhap}
    ${list_pr_giam}    Get Dictionary Keys    ${dict_pr_gg}
    ${list_gg}    Get Dictionary Values    ${dict_pr_gg}
    ${list_pr_tang}    Get Dictionary Keys    ${dict_pr_tg}
    ${list_tg}    Get Dictionary Values    ${dict_pr_tg}
    Delete price book if it exists    ${ten_bang_gia}
    ${list_gia_sau_giam}   Get and compute list new price in price book    ${list_pr_giam}    ${list_gg}    giảm     ${list_bg_gg}
    ${list_gia_sau_tang}   Get and compute list new price in price book    ${list_pr_tang}    ${list_tg}    tăng    ${list_bg_tg}
    Log    step UI
    Go To    ${URL}#/PriceBook
    Add new price book    ${ten_bang_gia}
    Add list category into price book and validate data    ${ten_bang_gia}     ${list_ten_nhom}
    Add list product into price book and input new price   ${list_pr_nhap}    ${list_nhap_gia}
    Add list product into price book and discount price    ${list_pr_giam}    ${list_gg}   ${list_bg_gg}
    Add list product into price book and increase price    ${list_pr_tang}    ${list_tg}   ${list_bg_tg}
    Log    valdate giá qua API va MHBH
    Click Element    ${button_banhang_on_quanly}
    Sleep    10s
    Wait Until Keyword Succeeds    3x    1s   Assert price in price book vs price in MHBH    ${ten_bang_gia}    ${list_pr_nhap}    ${list_nhap_gia}
    Assert price in price book vs price in MHBH    ${ten_bang_gia}    ${list_pr_giam}    ${list_gia_sau_giam}
    Assert price in price book vs price in MHBH    ${ten_bang_gia}    ${list_pr_tang}    ${list_gia_sau_tang}
    Assert list price in price book thr API     ${ten_bang_gia}     ${list_pr_nhap}    ${list_nhap_gia}
    Assert list price in price book thr API     ${ten_bang_gia}     ${list_pr_giam}    ${list_gia_sau_giam}
    Assert list price in price book thr API     ${ten_bang_gia}      ${list_pr_tang}    ${list_gia_sau_tang}
    Delete price book thr API    ${ten_bang_gia}
