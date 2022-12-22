*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    ${headless_browser}
Test Teardown     After Test
Library           SeleniumLibrary
Resource          ../../../../core/Thiet_lap/thiet_lap_nav.robot
Resource          ../../../../core/Thiet_lap/thiet_lap_cuahang_list_action.robot
Resource          ../../../../core/API/api_thietlap.robot
Resource          ../../../../core/API/api_thietlapgia.robot
Resource          ../../../../core/API/api_sendo.robot
Resource          ../../../../core/API/api_hanghoa.robot
Resource          ../../../../prepare/Hang_hoa/Sources/hanghoa.robot
Resource          ../../../../core/hang_hoa/hang_hoa_add_action.robot
Resource          ../../../../core/hang_hoa/hang_hoa_add_page.robot
Resource          ../../../../core/hang_hoa/danh_muc_list_action.robot

*** Variables ***

*** Test Cases ***      Tên shop Sendo  Tên bảng giá      Mã hh
Liên kết hh trong bảng giá chọn
                        [Tags]     SDOH
                        [Template]    mapapisdo7
                        [Timeout]     3 minutes
                        KiotViet       Bảng giá Sendo     HKM009      SD000009

Update công thức bảng giá
                        [Tags]      SDOH
                        [Template]    mapapisdo8
                        [Timeout]     3 minutes
                        KiotViet       Bảng giá Sendo     HKM006      20

Update giá của bảng giá phụ thuộc
                        [Tags]      SDOH
                        [Template]    mapapisdo9
                        [Timeout]     3 minutes
                        KiotViet      Bảng giá Sendo   HKM006      10000

Thêm hh vào bảng giá
                        [Tags]      SDOH
                        [Template]    mapapisdo10
                        [Timeout]     3 minutes
                        KiotViet      Bảng giá Sendo   TP015       10000

Xóa hh khỏi bảng giá
                        [Tags]      SDOH
                        [Template]    mapapisdo11
                        [Timeout]     3 minutes
                        KiotViet      Bảng giá Sendo   TP015       10000

Bảng giá chưa áp dụng
                        [Tags]      #SDOH
                        [Template]    mapapisdo12
                        [Timeout]     3 minutes
                        KiotViet      Bảng giá Sendo   HKM006

*** Keywords ***
mapapisdo7
    [Arguments]   ${shop_sendo}   ${input_banggia}   ${ma_hh}     ${input_ma_hh_sendo}
    Delete product mapping Sendo if mapping is visible thr API    ${shop_sendo}   ${ma_hh}
    ${gia_ban}    Get price of product in price book thr API    ${input_banggia}    ${ma_hh}
    ${gia_ban}    Replace floating point      ${gia_ban}
    ${get_cur_date}     Get Current Date    result_format=%Y-%m-%d %H:%M:%S
    Mapping product with Sendo thr API     ${shop_sendo}   ${input_ma_hh_sendo}    ${ma_hh}
    Log    validate lstt
    ${list_audit_db}     Create list audit trail for sync product       ${ma_hh}   ${gia_ban}   none
    Assert audit trail by time succeed   ${get_cur_date}    ${ma_hh}    Đồng bộ Sendo    ${list_audit_db}
    Delete product mapping sendo thr API    ${shop_sendo}    ${ma_hh}

mapapisdo8
    [Arguments]   ${shop_sendo}   ${input_banggia}   ${ma_hh}     ${input_percent}
    Update price formula increase percent thr API    ${input_banggia}    ${input_percent}   true
    ${get_cur_date}     Get Current Date    result_format=%Y-%m-%d %H:%M:%S
    Sleep    5s
    ${gia_ban}    Get price of product in price book thr API    ${input_banggia}    ${ma_hh}
    ${gia_ban}    Replace floating point      ${gia_ban}
    Log    validate lstt
    ${list_audit_db}     Create list audit trail for sync product       ${ma_hh}   ${gia_ban}   none
    Assert audit trail by time succeed   ${get_cur_date}    ${ma_hh}    Đồng bộ Sendo    ${list_audit_db}
    [Teardown]     Update price formula increase percent thr API    ${input_banggia}    10    true

mapapisdo9
    [Arguments]   ${shop_sendo}   ${input_banggia}   ${ma_hh}     ${input_vnd}
    Update price formula increase percent thr API    ${input_banggia}    10       true
    ${ton}      ${gia_ban_chung}    Get Onhand and Baseprice frm API      ${ma_hh}
    ${gia_chung_moi}      Sum    ${gia_ban_chung}     ${input_vnd}
    ${gia_omni_moi}     Price after % increase product      ${gia_chung_moi}      10
    Update product thr API   pro    ${ma_hh}   none    ${gia_chung_moi}    none
    ${get_cur_date}     Get Current Date    result_format=%Y-%m-%d %H:%M:%S
    ${gia_omni_moi}    Replace floating point      ${gia_omni_moi}
    Log    validate lstt
    ${list_audit_db}     Create list audit trail for sync product       ${ma_hh}   ${gia_omni_moi}   none
    Wait Until Keyword Succeeds    90x    1s   Assert audit trail by time succeed   ${get_cur_date}    ${ma_hh}    Đồng bộ Sendo    ${list_audit_db}
    [Teardown]     Update product thr API   pro    ${ma_hh}   none    ${gia_ban_chung}    none

mapapisdo10
    [Arguments]   ${shop_sendo}   ${input_banggia}   ${ma_hh}     ${input_ma_hh_sendo}
    Run Keyword And Ignore Error    Remove product from pricebook thr API   ${input_banggia}   ${ma_hh}
    Sleep    3s
    Add product into pricebook thr API    ${input_banggia}   ${ma_hh}
    ${get_cur_date}     Get Current Date    result_format=%Y-%m-%d %H:%M:%S
    Sleep    3s
    ${gia_ban}    Get price of product in price book thr API    ${input_banggia}    ${ma_hh}
    ${gia_ban}    Replace floating point      ${gia_ban}
    Log    validate lstt
    ${list_audit_db}     Create list audit trail for sync product       ${ma_hh}   ${gia_ban}   none
    Assert audit trail by time succeed   ${get_cur_date}    ${ma_hh}    Đồng bộ Sendo    ${list_audit_db}
    Remove product from pricebook thr API   ${input_banggia}   ${ma_hh}

mapapisdo11
    [Arguments]   ${shop_sendo}   ${input_banggia}   ${ma_hh}     ${input_ma_hh_sendo}
    Run Keyword And Ignore Error      Add product into pricebook thr API    ${input_banggia}   ${ma_hh}
    Sleep    3s
    Remove product from pricebook thr API   ${input_banggia}   ${ma_hh}
    ${get_cur_date}     Get Current Date    result_format=%Y-%m-%d %H:%M:%S
    Sleep    3s
    ${ton}    ${gia_ban}   Get Onhand and Baseprice frm API      ${ma_hh}
    ${gia_ban}    Replace floating point      ${gia_ban}
    Log    validate lstt
    ${list_audit_db}     Create list audit trail for sync product       ${ma_hh}   ${gia_ban}   none
    Assert audit trail by time succeed   ${get_cur_date}    ${ma_hh}    Đồng bộ Sendo    ${list_audit_db}

mapapisdo12
    [Arguments]   ${shop_sendo}   ${input_banggia}   ${ma_hh}
    Update price formula increase percent thr API    ${input_banggia}    10     false
    ${get_cur_date}     Get Current Date    result_format=%Y-%m-%d %H:%M:%S
    Sleep    3s
    ${ton}    ${gia_ban}   Get Onhand and Baseprice frm API      ${ma_hh}
    ${gia_ban}    Replace floating point      ${gia_ban}
    Log    validate lstt
    ${list_audit_db}     Create list audit trail for sync product       ${ma_hh}   ${gia_ban}   none
    Assert audit trail by time succeed   ${get_cur_date}    ${ma_hh}    Đồng bộ Sendo    ${list_audit_db}
    [Teardown]     Update price formula increase percent thr API    ${input_banggia}    10      true
