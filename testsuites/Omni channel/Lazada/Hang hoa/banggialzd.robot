*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    ${headless_browser}
Library           SeleniumLibrary
Resource          ../../../../core/Thiet_lap/thiet_lap_nav.robot
Resource          ../../../../core/Thiet_lap/thiet_lap_cuahang_list_action.robot
Resource          ../../../../core/API/api_thietlap.robot
Resource          ../../../../core/API/api_thietlapgia.robot
Resource          ../../../../core/API/api_lazada.robot
Resource          ../../../../core/API/api_hanghoa.robot
Resource          ../../../../prepare/Hang_hoa/Sources/hanghoa.robot
Resource          ../../../../core/hang_hoa/hang_hoa_add_action.robot
Resource          ../../../../core/hang_hoa/hang_hoa_add_page.robot
Resource          ../../../../core/hang_hoa/danh_muc_list_action.robot

*** Variables ***

*** Test Cases ***      Tên shop lazada  Tên bảng giá      Mã hh
Liên kết hh trong bảng giá chọn
                        [Tags]          LZDH
                        [Template]    mapapilzd7
                        [Timeout]     3 minutes
                        KiotViet       Bảng giá Lazada     HTKM02       TE200

Update công thức bảng giá
                        [Tags]          LZDH
                        [Template]    mapapilzd8
                        [Timeout]     3 minutes
                        KiotViet       Bảng giá Lazada     HTKM01      20

Update giá của bảng giá phụ thuộc
                        [Tags]          LZDH
                        [Template]    mapapilzd9
                        [Timeout]     3 minutes
                        KiotViet      Bảng giá Lazada     HTKM01      10000

Thêm hh vào bảng giá
                        [Tags]          LZDH
                        [Template]    mapapilzd10
                        [Timeout]     3 minutes
                        KiotViet      Bảng giá Lazada   TP232      10000

Xóa hh khỏi bảng giá
                        [Tags]          LZDH
                        [Template]    mapapilzd11
                        [Timeout]     3 minutes
                        KiotViet      Bảng giá Lazada   TP232      10000

*** Keywords ***
mapapilzd7
    [Arguments]   ${shop_lazada}   ${input_banggia}   ${ma_hh}     ${input_ma_hh_lazada}
    Delete product mapping lazada if mapping is visible thr API    ${shop_lazada}   ${ma_hh}
    ${gia_ban}    Get price of product in price book thr API    ${input_banggia}    ${ma_hh}
    ${gia_ban}    Replace floating point      ${gia_ban}
    ${get_cur_date}     Get Current Date    result_format=%Y-%m-%d %H:%M:%S
    Mapping product with Lazada thr API     ${shop_lazada}   ${input_ma_hh_lazada}    ${ma_hh}
    Log    validate lstt
    ${list_audit_db}     Create list audit trail for sync product       ${ma_hh}   ${gia_ban}   none
    Wait Until Keyword Succeeds    10x    1s   Assert audit trail by time succeed   ${get_cur_date}    ${ma_hh}    Đồng bộ Lazada    ${list_audit_db}
    Delete product mapping lazada thr API    ${shop_lazada}    ${ma_hh}

mapapilzd8
    [Arguments]   ${shop_lazada}   ${input_banggia}   ${ma_hh}     ${input_percent}
    Update price formula increase percent thr API    ${input_banggia}    ${input_percent}   true
    ${get_cur_date}     Get Current Date    result_format=%Y-%m-%d %H:%M:%S
    Sleep    5s
    ${gia_ban}    Get price of product in price book thr API    ${input_banggia}    ${ma_hh}
    ${gia_ban}    Replace floating point      ${gia_ban}
    Log    validate lstt
    ${list_audit_db}     Create list audit trail for sync product       ${ma_hh}   ${gia_ban}   none
    Wait Until Keyword Succeeds    10x    1s   Assert audit trail by time succeed   ${get_cur_date}    ${ma_hh}    Đồng bộ Lazada    ${list_audit_db}
    [Teardown]     Update price formula increase percent thr API    ${input_banggia}    10    true

mapapilzd9
    [Arguments]   ${shop_lazada}   ${input_banggia}   ${ma_hh}     ${input_vnd}
    Update price formula increase percent thr API    ${input_banggia}    10     true
    ${ton}      ${gia_ban_chung}    Get Onhand and Baseprice frm API      ${ma_hh}
    ${gia_chung_moi}      Sum    ${gia_ban_chung}     ${input_vnd}
    ${gia_omni_moi}     Price after % increase product      ${gia_chung_moi}      10
    Update product thr API   pro    ${ma_hh}   none    ${gia_chung_moi}    none
    ${get_cur_date}     Get Current Date    result_format=%Y-%m-%d %H:%M:%S
    ${gia_omni_moi}    Replace floating point      ${gia_omni_moi}
    Log    validate lstt
    ${list_audit_db}     Create list audit trail for sync product       ${ma_hh}   ${gia_omni_moi}   none
    Wait Until Keyword Succeeds    90x    1s   Assert audit trail by time succeed   ${get_cur_date}    ${ma_hh}    Đồng bộ Lazada    ${list_audit_db}
    [Teardown]     Update product thr API   pro    ${ma_hh}   none    ${gia_ban_chung}    none

mapapilzd10
    [Arguments]   ${shop_lazada}   ${input_banggia}   ${ma_hh}     ${input_ma_hh_lazada}
    Run Keyword And Ignore Error    Remove product from pricebook thr API   ${input_banggia}   ${ma_hh}
    Sleep    3s
    Add product into pricebook thr API    ${input_banggia}   ${ma_hh}
    ${get_cur_date}     Get Current Date    result_format=%Y-%m-%d %H:%M:%S
    Sleep    3s
    ${gia_ban}    Get price of product in price book thr API    ${input_banggia}    ${ma_hh}
    ${gia_ban}    Replace floating point      ${gia_ban}
    Log    validate lstt
    ${list_audit_db}     Create list audit trail for sync product       ${ma_hh}   ${gia_ban}   none
    Wait Until Keyword Succeeds    10x    1s   Assert audit trail by time succeed   ${get_cur_date}    ${ma_hh}    Đồng bộ Lazada    ${list_audit_db}
    Remove product from pricebook thr API   ${input_banggia}   ${ma_hh}

mapapilzd11
    [Arguments]   ${shop_lazada}   ${input_banggia}   ${ma_hh}     ${input_ma_hh_lazada}
    Run Keyword And Ignore Error      Add product into pricebook thr API    ${input_banggia}   ${ma_hh}
    Sleep    3s
    Remove product from pricebook thr API   ${input_banggia}   ${ma_hh}
    ${get_cur_date}     Get Current Date    result_format=%Y-%m-%d %H:%M:%S
    Sleep    3s
    ${ton}    ${gia_ban}   Get Onhand and Baseprice frm API      ${ma_hh}
    ${gia_ban}    Replace floating point      ${gia_ban}
    Log    validate lstt
    ${list_audit_db}     Create list audit trail for sync product       ${ma_hh}   ${gia_ban}   none
    Wait Until Keyword Succeeds    10x    1s   Assert audit trail by time succeed   ${get_cur_date}    ${ma_hh}    Đồng bộ Lazada    ${list_audit_db}
