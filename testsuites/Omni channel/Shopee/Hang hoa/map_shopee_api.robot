*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    ${headless_browser}
Test Teardown     After Test
Library           SeleniumLibrary
Resource          ../../../../core/Thiet_lap/thiet_lap_nav.robot
Resource          ../../../../core/Thiet_lap/thiet_lap_cuahang_list_action.robot
Resource          ../../../../core/API/api_thietlap.robot
Resource          ../../../../core/API/api_shopee.robot
Resource          ../../../../core/API/api_hanghoa.robot
Resource          ../../../../prepare/Hang_hoa/Sources/hanghoa.robot
Resource          ../../../../core/hang_hoa/hang_hoa_add_action.robot
Resource          ../../../../core/hang_hoa/hang_hoa_add_page.robot
Resource          ../../../../core/hang_hoa/danh_muc_list_action.robot

*** Variables ***
&{dict_sp}    TPG03=1

*** Test Cases ***      Tên shopee     Loại hàng  Mã hh       Tên sp    Nhóm hàng   Giá bán   Tồn    Mã hh shopee
Lien ket hang hoa
                        [Tags]               SPEH
                        [Template]    mapapispe1
                        [Timeout]     15 minutes
                        thanhptk        imei      spe1        imei     Mỹ phẩm       75000       none    none    none    none    none     SP000003
                        thanhptk        lodate    spe2        lodate     Mỹ phẩm       123000      none    none    none    none    none    SP000004
                        thanhptk        combo     spe3        cpmbo     Mỹ phẩm       36000       43.36    TPD025     2    TPD026    1     SP000007
                        thanhptk        unit      spe4        dvt     Mỹ phẩm       96000       33.98    spe4-1    4    none    none    SP000008
                        thanhptk        manu      spe5        sx     Mỹ phẩm       132000       22    TPD025     2     TPD026    1    SP000011
                        thanhptk        service   spe6        dich vu     Mỹ phẩm       123000      none    none    none    none    none   SP000022

Tu dong lien ket hang hoa trung sku chua co lien ket va thay doi gia - sl
                        [Tags]                SPEH
                        [Template]    mapapispe3
                        [Timeout]     15 minutes
                        thanhptk        imei      SP000022   imei     Mỹ phẩm       75000       none    none    none    none    none        85000     none
                        thanhptk        lodate    SP000023   lodate     Mỹ phẩm       123000      none    none    none    none    none      133000     none
                        thanhptk        combo     SP000024   combo     Mỹ phẩm       36000       43.36    TPD025     2    TPD026    1      40000     none
                        thanhptk        unit      SP000026   dvt     Mỹ phẩm       96000       33.98    SP000026-1    4    none    none     100000      35.96
                        thanhptk        manu      SP000029   sx     Mỹ phẩm       132000       22.8    TPD025     2     TPD026    1        140000        30

*** Keywords ***
mapapispe1
    [Arguments]   ${shop_shopee}   ${loai_hh}    ${ma_hh}    ${ten_sp}   ${nhom_hang}   ${gia_ban}    ${ton}    ${sp_1}   ${sl_1}   ${sp_2}   ${sl_2}    ${ma_hh_shopee}
    Delete product if product is visible thr API    ${ma_hh}
    Add product by product type thr API   ${loai_hh}     ${ma_hh}    ${ten_sp}   ${nhom_hang}   ${gia_ban}    45000    ${ton}     ${sp_1}   ${sl_1}   ${sp_2}   ${sl_2}
    Sleep    5s
    ${get_cur_date}     Get Current Date    result_format=%Y-%m-%d %H:%M:%S
    Wait Until Keyword Succeeds    3x    1s    Mapping product with shopee thr API     ${shop_shopee}   ${ma_hh_shopee}     ${ma_hh}
    #
    Log    validate lstt
    ${list_audit_lk}   Create list audit trail for map product Shopee    ${shop_shopee}  ${ma_hh}    ${ma_hh_shopee}
    Wait Until Keyword Succeeds    10x     1s    Assert audit trail by time succeed    ${get_cur_date}   ${ma_hh}    Liên kết kênh bán    ${list_audit_lk}
    ${ton}    Set Variable If    '${ton}'=='none' or '${loai_hh}'=='imei' or '${loai_hh}'=='lodate'     0      ${ton}
    ${ton}    Set Variable If    '${loai_hh}'=='service' or '${loai_hh}'=='combo'   none    ${ton}
    ${list_audit_db}     Create list audit trail for sync product       ${ma_hh}   ${gia_ban}     ${ton}
    Assert audit trail by time succeed   ${get_cur_date}    ${ma_hh}    Đồng bộ Shopee    ${list_audit_db}
    Delete product thr API    ${ma_hh}

mapapispe3
    [Arguments]   ${shop_shopee}   ${loai_hh}    ${ma_hh}    ${ten_sp}   ${nhom_hang}   ${gia_ban}    ${ton}    ${sp_1}   ${sl_1}   ${sp_2}   ${sl_2}     ${gia_ban_up}     ${ton_up}
    Delete product if product is visible thr API    ${ma_hh}
    ${get_cur_date}     Get Current Date    result_format=%Y-%m-%d %H:%M:%S
    Add product by product type thr API   ${loai_hh}     ${ma_hh}    ${ten_sp}   ${nhom_hang}   ${gia_ban}    45000    ${ton}     ${sp_1}   ${sl_1}   ${sp_2}   ${sl_2}
    Log    validate lstt
    ${list_audit_lk}   Create list audit trail for map product Shopee    ${shop_shopee}  ${ma_hh}    ${ma_hh}
    Wait Until Keyword Succeeds    10x     1s    Assert audit trail by time succeed    ${get_cur_date}   ${ma_hh}    Liên kết kênh bán    ${list_audit_lk}
    ${ton}    Set Variable If    '${ton}'=='none'or '${loai_hh}'=='imei' or '${loai_hh}'=='lodate'     0      ${ton}
    ${ton}    Set Variable If    '${loai_hh}'=='service' or '${loai_hh}'=='combo'   none    ${ton}
    ${list_audit_db}     Create list audit trail for sync product        ${ma_hh}   ${gia_ban}     ${ton}
    Assert audit trail by time succeed   ${get_cur_date}    ${ma_hh}    Đồng bộ Shopee    ${list_audit_db}
    #
    Log    Cập nhật giá bán, tồn kho
    Wait Until Keyword Succeeds    3x    2x    Update product thr API   ${loai_hh}    ${ma_hh}    none    ${gia_ban_up}     ${ton_up}
    ${get_cur_date_up}     Get Current Date    result_format=%Y-%m-%d %H:%M:%S
    ${ton_up}    Set Variable If    '${ton_up}'=='none' or '${loai_hh}'=='imei' or '${loai_hh}'=='lodate'     0      ${ton_up}
    ${ton_up}    Set Variable If    '${loai_hh}'=='service' or '${loai_hh}'=='combo'   none    ${ton_up}
    ${list_audit_db}     Create list audit trail for sync product        ${ma_hh}   ${gia_ban_up}     ${ton_up}
    Assert audit trail by time succeed   ${get_cur_date_up}    ${ma_hh}    Đồng bộ Shopee    ${list_audit_db}
    Delete product thr API    ${ma_hh}
