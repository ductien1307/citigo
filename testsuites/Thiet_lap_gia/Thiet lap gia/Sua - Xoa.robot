*** Settings ***
Suite Setup       Setup Test Suite    Before Test Thiet lap gia
Suite Teardown     After Test
Resource          ../../../core/API/api_thietlapgia.robot
Resource          ../../../core/Hang_Hoa/thiet_lap_gia_list_action.robot
Resource          ../../../core/Hang_Hoa/thiet_lap_gia_list_page.robot
Resource          ../../../prepare/Hang_hoa/Sources/hanghoa.robot

*** Variables ***
@{list_prd}       NHP028    NHP030

*** Test Cases ***    Tên BG             Bảng giá                Tăng giảm    Giá trị    Có hạch toán    SP
Cập nhật bảng giá     [Tags]               TLG
                      [Template]          tlbg1
                      [Documentation]     Cập nhật bảng giá > thay đổi giá bán ở tab Thiết lập nâng cao
                      BGTest             Giá vốn                 tăng         30         yes             ${list_prd}
                      BGTest1            Giá nhập lần cuối       giảm         20         yes             ${list_prd}
                      BGTest2            Giá chung               tăng         20000      no              ${list_prd}
                      BGTest3            Bảng giá test TLG       giảm         25000      no              ${list_prd}

Xóa bảng giá ko có sp
                      [Tags]    TLG
                      [Template]    tlbg2
                      [Documentation]     Xóa bảng giá không có sản phẩm
                      BGX1

Xóa bảng giá có sp
                      [Tags]    TLG
                      [Template]    tlbg3
                      [Documentation]     Xóa bảng giá có sản phẩm
                      BGX2

*** Keywords ***
tlbg1
    [Arguments]      ${ten_bang_gia}    ${gia_ss}    ${tanggiam}    ${value}    ${confirm}    ${list_pr}
    Delete price book if it exists    ${ten_bang_gia}
    Add new price book and add all category - discount %    ${ten_bang_gia}    15
    ${list_giaban_bf}   Get list price of list product in price book thr API    ${ten_bang_gia}    ${list_pr}
    ${list_new_price}   Get and compute list new price by general infor in price book    ${list_pr}    ${value}    ${tanggiam}    ${gia_ss}
    ${list_result_price}    Set Variable If    '${confirm}'=='yes'     ${list_new_price}       ${list_giaban_bf}
    Log    step UI
    Go To    ${URL}#/PriceBook
    Select Bang gia for Bang gia    ${ten_bang_gia}
    Edit infor in tab Thiet lap nang cao    ${gia_ss}    ${tanggiam}    ${value}    ${confirm}
    Click Element    ${button_banhang_on_quanly}
    Sleep    10s
    Log    validate gia tren mhbh va api
    Assert price in price book vs price in MHBH    ${ten_bang_gia}    ${list_pr}    ${list_result_price}
    Assert list price in price book thr API    ${ten_bang_gia}    ${list_pr}    ${list_result_price}
    Assert price and value in tab Advanced settings    ${ten_bang_gia}   ${gia_ss}    ${tanggiam}     ${value}
    Delete price book thr API    ${ten_bang_gia}

tlbg2
    [Arguments]    ${ten_bang_gia}
    Delete price book if it exists    ${ten_bang_gia}
    Add new price book and add all category - discount %    ${ten_bang_gia}    10
    Go To    ${URL}#/PriceBook
    Select Bang gia for Bang gia    ${ten_bang_gia}
    Delete price book thr UI    ${ten_bang_gia}
    Assert price book is not avaiable thr API    ${ten_bang_gia}

tlbg3
    [Arguments]    ${ten_bang_gia}
    Delete price book if it exists    ${ten_bang_gia}
    Add new bang gia    ${ten_bang_gia}
    Go To    ${URL}#/PriceBook
    Select Bang gia for Bang gia    ${ten_bang_gia}
    Delete price book thr UI    ${ten_bang_gia}
    Assert price book is not avaiable thr API    ${ten_bang_gia}
