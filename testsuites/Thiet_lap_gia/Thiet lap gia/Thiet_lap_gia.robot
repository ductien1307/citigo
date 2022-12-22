*** Settings ***
Suite Setup       Setup Test Suite    Before Test Thiet lap gia
Suite Teardown     After Test
Resource          ../../../core/API/api_thietlapgia.robot
Resource          ../../../core/Hang_Hoa/thiet_lap_gia_list_action.robot
Resource          ../../../core/Hang_Hoa/thiet_lap_gia_list_page.robot
Resource          ../../../core/API/api_danhmuc_hanghoa.robot
Library           SeleniumLibrary

*** Variables ***
@{prd}            NHP029    NHP030

*** Test Cases ***    Tên BG   Nhóm hàng   SP nhập giiá mới   SP giảm giá   Bảng giá   SP tăng giá   Bảng giá
Thiết lập giá         [Tags]            TLG
                      [Template]        tlbg6
                      [Documentation]   MHQL - THÊM MỚI BẢNG GIÁ VÀ SETUP BÁN HÀNG TRONG TAB THIẾT LẬP NÂNG CAO
                      BGH1             Giá vốn              tăng                20             ${prd}
                      BGH2             Giá nhập lần cuối    tăng                15000          ${prd}
                      BGH3             Giá chung            giảm                10             ${prd}
                      BGH4             Bảng giá test TLG    giảm                2000           ${prd}

Thiết lập giá         [Tags]            CTP
                      [Template]        tlbg6
                      [Documentation]   MHQL - THÊM MỚI BẢNG GIÁ VÀ SETUP BÁN HÀNG TRONG TAB THIẾT LẬP NÂNG CAO
                      BGH3             Giá chung            giảm                10             ${prd}

*** Keywords ***
tlbg6
    [Arguments]    ${ten_bang_gia}      ${gia_ss}    ${tanggiam}    ${value}    ${list_pr}
    Log    tính toán giá sản phẩm af ex
    Delete price book if it exists    ${ten_bang_gia}
    ${list_gia_sau_thiet_lap}   Get and compute list new price by general infor in price book    ${list_pr}    ${value}    ${tanggiam}    ${gia_ss}
    Log    step UI
    Go To    ${URL}#/PriceBook
    Add new price book have pricebook and value in tab Thiet lap nang cao    ${ten_bang_gia}    ${gia_ss}    ${tanggiam}    ${value}
    Add list product into price book and validate data    ${list_pr}
    Click Element    ${button_banhang_on_quanly}
    Sleep    10s
    Log    validate giá qua API và MHBH
    Wait Until Keyword Succeeds    3x    1s   Assert price in price book vs price in MHBH    ${ten_bang_gia}    ${list_pr}    ${list_gia_sau_thiet_lap}
    Assert list price in price book thr API    ${ten_bang_gia}    ${list_pr}    ${list_gia_sau_thiet_lap}
    Assert price and value in tab Advanced settings  ${ten_bang_gia}    ${gia_ss}    ${tanggiam}    ${value}
    Delete price book thr API    ${ten_bang_gia}
