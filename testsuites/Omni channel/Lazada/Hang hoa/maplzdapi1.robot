*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    ${headless_browser}
Library           SeleniumLibrary
Resource          ../../../../core/Thiet_lap/thiet_lap_nav.robot
Resource          ../../../../core/Thiet_lap/thiet_lap_cuahang_list_action.robot
Resource          ../../../../core/API/api_thietlap.robot
Resource          ../../../../core/API/api_lazada.robot
Resource          ../../../../core/API/api_hanghoa.robot
Resource          ../../../../prepare/Hang_hoa/Sources/hanghoa.robot
Resource          ../../../../core/hang_hoa/hang_hoa_add_action.robot
Resource          ../../../../core/hang_hoa/hang_hoa_add_page.robot
Resource          ../../../../core/hang_hoa/danh_muc_list_action.robot

*** Variables ***

*** Test Cases ***      Tên shop lazada   Loại hàng  Mã hh       Tên sp    Nhóm hàng   Giá bán   Tồn    Mã hh lazada
Lien ket hang hoa
                        [Tags]         LZDH
                        [Template]    mapapilzd1
                        [Timeout]     15 minutes
                        KiotViet        imei      lazada1        imei     Mỹ phẩm       75000.52       none    none    none    none    none      410E
                        KiotViet        lodate    lazada2        lodate     Mỹ phẩm       123000.96      none    none    none    none    none    410F
                        KiotViet        combo     lazada3        combo     Mỹ phẩm       36000       43.36    TPD025     2    TPD026    1       SP000110
                        KiotViet        unit      lazada4        dvt     Mỹ phẩm       96000       33.98    lazada4-1    4    none    none    Otek M437RB
                        KiotViet        manu      lazada5        sx     Mỹ phẩm       132000.11       22.2    TPD025     2     TPD026    1    Otek M437RC
                        KiotViet        service   lazada6        dich vu     Mỹ phẩm       123000      none    none    none    none    none   Otek M437RD

Tu dong lien ket hang hoa trung sku chua co lien ket va thay doi gia - sl
                        [Tags]        LZDH
                        [Template]    mapapilzd3
                        [Timeout]     15 minutes
                        KiotViet        imei      1   imei     Mỹ phẩm       75000       none    none    none    none    none        85000     none
                        KiotViet        lodate    SP000124   lodate     Mỹ phẩm       123000      none    none    none    none    none      133000     none
                        KiotViet        combo     LPQ80   combo     Mỹ phẩm       36000       43.36    TPD025     2    TPD026    1      40000     none
                        KiotViet        unit      SP000136   dvt     Mỹ phẩm       96000       33.98    SD0000001-1    4    none    none     100000      35.96
                        KiotViet        manu      XL-2002   sx     Mỹ phẩm       132000       22.8    TPD025     2     TPD026    1        140000        30

*** Keywords ***
mapapilzd1
    [Arguments]   ${shop_lazada}   ${loai_hh}    ${ma_hh}    ${ten_sp}   ${nhom_hang}   ${gia_ban}    ${ton}    ${sp_1}   ${sl_1}   ${sp_2}   ${sl_2}    ${ma_hh_lazada}
    Delete product if product is visible thr API    ${ma_hh}
    Sleep    3s
    Add product by product type thr API   ${loai_hh}     ${ma_hh}    ${ten_sp}   ${nhom_hang}   ${gia_ban}    45000    ${ton}     ${sp_1}   ${sl_1}   ${sp_2}   ${sl_2}
    Sleep    5s
    ${get_cur_date}     Get Current Date    result_format=%Y-%m-%d %H:%M:%S
    Wait Until Keyword Succeeds    3x    1s    Mapping product with lazada thr API     ${shop_lazada}   ${ma_hh_lazada}     ${ma_hh}
    #
    Log    validate lstt
    ${list_audit_lk}   Create list audit trail for map product lazada    ${shop_lazada}  ${ma_hh}    ${ma_hh_lazada}
    Wait Until Keyword Succeeds    10x     1s    Assert audit trail by time succeed    ${get_cur_date}   ${ma_hh}    Liên kết kênh bán    ${list_audit_lk}
    ${ton}    Set Variable If    '${ton}'=='none' or '${loai_hh}'=='imei' or '${loai_hh}'=='lodate'     0      ${ton}
    ${ton}    Set Variable If    '${loai_hh}'=='service' or '${loai_hh}'=='combo'   none    ${ton}
    ${list_audit_db}     Create list audit trail for sync product       ${ma_hh}   ${gia_ban}     ${ton}
    Assert audit trail by time succeed   ${get_cur_date}    ${ma_hh}    Đồng bộ Lazada    ${list_audit_db}
    Delete product thr API    ${ma_hh}

mapapilzd2
    [Arguments]   ${shop_lazada}   ${loai_hh}    ${ma_hh}    ${ten_sp}   ${nhom_hang}   ${gia_ban}    ${ton}    ${sp_1}   ${sl_1}   ${sp_2}   ${sl_2}
    Delete product if product is visible thr API    ${ma_hh}
    ${get_cur_date}     Get Current Date    result_format=%Y-%m-%d %H:%M:%S
    Add product by product type thr API   ${loai_hh}     ${ma_hh}    ${ten_sp}   ${nhom_hang}   ${gia_ban}    45000    ${ton}     ${sp_1}   ${sl_1}   ${sp_2}   ${sl_2}
    Log    validate lstt
    ${list_audit_lk}   Create list audit trail for map product lazada    ${shop_lazada}  ${ma_hh}    ${ma_hh}
    Wait Until Keyword Succeeds    10x     1s    Assert audit trail by time succeed    ${get_cur_date}   ${ma_hh}    Liên kết kênh bán    ${list_audit_lk}
    ${ton}    Set Variable If    '${ton}'=='none'or '${loai_hh}'=='imei' or '${loai_hh}'=='lodate'     0      ${ton}
    ${ton}    Set Variable If    '${loai_hh}'=='service' or '${loai_hh}'=='combo'   none    ${ton}
    ${list_audit_db}     Create list audit trail for sync product       ${ma_hh}   ${gia_ban}     ${ton}
    Assert audit trail by time succeed   ${get_cur_date}    ${ma_hh}    Đồng bộ Lazada    ${list_audit_db}
    Delete product thr API    ${ma_hh}

mapapilzd3
    [Arguments]   ${shop_lazada}   ${loai_hh}    ${ma_hh}    ${ten_sp}   ${nhom_hang}   ${gia_ban}    ${ton}    ${sp_1}   ${sl_1}   ${sp_2}   ${sl_2}     ${gia_ban_up}     ${ton_up}
    Delete product if product is visible thr API    ${ma_hh}
    ${get_cur_date}     Get Current Date    result_format=%Y-%m-%d %H:%M:%S
    Add product by product type thr API   ${loai_hh}     ${ma_hh}    ${ten_sp}   ${nhom_hang}   ${gia_ban}    45000    ${ton}     ${sp_1}   ${sl_1}   ${sp_2}   ${sl_2}
    Log    validate lstt
    ${list_audit_lk}   Create list audit trail for map product lazada    ${shop_lazada}  ${ma_hh}    ${ma_hh}
    Wait Until Keyword Succeeds    10x     1s    Assert audit trail by time succeed    ${get_cur_date}   ${ma_hh}    Liên kết kênh bán    ${list_audit_lk}
    ${ton}    Set Variable If    '${ton}'=='none'or '${loai_hh}'=='imei' or '${loai_hh}'=='lodate'     0      ${ton}
    ${ton}    Set Variable If    '${loai_hh}'=='service' or '${loai_hh}'=='combo'   none    ${ton}
    ${list_audit_db}     Create list audit trail for sync product        ${ma_hh}   ${gia_ban}     ${ton}
    Assert audit trail by time succeed   ${get_cur_date}    ${ma_hh}    Đồng bộ Lazada    ${list_audit_db}
    #
    Log    Cập nhật giá bán, tồn kho
    Wait Until Keyword Succeeds    3x    2x    Update product thr API   ${loai_hh}    ${ma_hh}    none    ${gia_ban_up}     ${ton_up}
    ${get_cur_date_up}     Get Current Date    result_format=%Y-%m-%d %H:%M:%S
    ${ton_up}    Set Variable If    '${ton_up}'=='none' or '${loai_hh}'=='imei' or '${loai_hh}'=='lodate'     0      ${ton_up}
    ${ton_up}    Set Variable If    '${loai_hh}'=='service' or '${loai_hh}'=='combo' or '${loai_hh}'=='imei' or '${loai_hh}'=='lodate'   none    ${ton_up}
    ${list_audit_db}     Create list audit trail for sync product        ${ma_hh}   ${gia_ban_up}     ${ton_up}
    Wait Until Keyword Succeeds    10x    2x    Assert audit trail by time succeed   ${get_cur_date_up}    ${ma_hh}    Đồng bộ Lazada    ${list_audit_db}
    Delete product thr API    ${ma_hh}
