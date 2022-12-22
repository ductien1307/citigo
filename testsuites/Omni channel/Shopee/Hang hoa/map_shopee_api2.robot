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

*** Test Cases ***      Tên shop shopee   Loại hh    Mã hh      Tên sp   Nhóm hàng   Giá bán    Tồn    Mã hh shopee
Tao moi hang hoa trung sku voi hang da co lien ket
                        [Tags]           SPEH
                        [Template]    mapapispe4
                        [Timeout]     15 minutes
                        thanhptk        imei      HK000004      abc     Mỹ phẩm       75000       none    none    none    none    none
                        thanhptk        lodate    HK000004      abc     Mỹ phẩm       123000       none    none    none    none    none
                        thanhptk        combo     HK000004      abc     Mỹ phẩm       36000       43.36    TPD025     2    TPD026    1
                        thanhptk        unit      HK000004      abc     Mỹ phẩm       96000       33.98    HK000004-1    4    none    none
                        thanhptk        manu      HK000004      abc     Mỹ phẩm       132000       22.2    TPD025     2     TPD026    1

Cap nhat hang hoa trung sku voi hang chua lien ket
                        [Tags]           SPEH
                        [Template]    mapapispe5
                        [Timeout]     15 minutes
                        thanhptk        imei      uspe13        imei     Mỹ phẩm       75000       none    none    none    none    none     SP000030
                        thanhptk        lodate    uspe14        lodate     Mỹ phẩm       123000      none    none    none    none    none    SP000039
                        thanhptk        combo     uspe15        combo     Mỹ phẩm       36000       43.36    TPD025     2    TPD026    1     SP000042
                        thanhptk        unit      uspe16        dvt     Mỹ phẩm       96000       33.98    uspe16-1    4    none    none    SP000044
                        thanhptk         manu     uspe17        sx     Mỹ phẩm       132000       22.2    TPD025     2     TPD026    1      SP000048
                        thanhptk        service   uspe18        dich vu     Mỹ phẩm       123000      none    none    none    none    none   SP000049

Cap nhat hang hoa trung sku voi hang da co lien ket
                        [Tags]           SPEH
                        [Template]    mapapispe6
                        [Timeout]     15 minutes
                        thanhptk        imei      uspe7        imei     Mỹ phẩm       75000       none    none    none    none    none     HK000004
                        thanhptk        lodate    uspe8        lodate     Mỹ phẩm       123000      none    none    none    none    none    HK000004
                        thanhptk        combo     uspe9        combo     Mỹ phẩm       36000       43.36    TPD025     2    TPD026    1     HK000004
                        thanhptk        unit      uspe10        dvt     Mỹ phẩm       96000       33.98    shopee10-1    4    none    none    HK000004
                        thanhptk         manu     uspe11        sx     Mỹ phẩm       132000       22.2    TPD025     2     TPD026    1    HK000004
                        thanhptk        service   uspe12        dich vu     Mỹ phẩm       123000      none    none    none    none    none   HK000004

*** Keywords ***
mapapispe4
    [Arguments]   ${shop_shopee}   ${loai_hh}    ${ma_hh}    ${ten_sp}   ${nhom_hang}   ${gia_ban}    ${ton}    ${sp_1}   ${sl_1}   ${sp_2}   ${sl_2}
    Delete product if product is visible thr API    ${ma_hh}
    ${get_cur_date}     Get Current Date    result_format=%Y-%m-%d %H:%M:%S
    Add product by product type thr API   ${loai_hh}     ${ma_hh}    ${ten_sp}   ${nhom_hang}   ${gia_ban}    45000    ${ton}     ${sp_1}   ${sl_1}   ${sp_2}   ${sl_2}
    Sleep    5s
    ${get_sku}    Get item sku shopee by kv product sku     ${shop_shopee}     ${ma_hh}
    Should Be Equal As Strings    ${get_sku}    0
    Delete product thr API       ${ma_hh}

mapapispe5
    [Arguments]   ${shop_shopee}   ${loai_hh}    ${ma_hh}    ${ten_sp}   ${nhom_hang}   ${gia_ban}    ${ton}    ${sp_1}   ${sl_1}   ${sp_2}   ${sl_2}     ${ma_hh_up}
    ${list_product}   Create List    ${ma_hh}     ${ma_hh_up}
    Delete list product if list product is visible thr API     ${list_product}
    ${get_cur_date}     Get Current Date    result_format=%Y-%m-%d %H:%M:%S
    Add product by product type thr API   ${loai_hh}     ${ma_hh}    ${ten_sp}   ${nhom_hang}   ${gia_ban}    45000    ${ton}     ${sp_1}   ${sl_1}   ${sp_2}   ${sl_2}
    Wait Until Keyword Succeeds    3x    2x    Update product thr API   ${loai_hh}    ${ma_hh}    ${ma_hh_up}    none    none
    #
    Log    validate lstt
    ${list_audit_lk}   Create list audit trail for map product shopee    ${shop_shopee}  ${ma_hh_up}    ${ma_hh_up}
    Wait Until Keyword Succeeds    10x     1s    Assert audit trail by time succeed    ${get_cur_date}   ${ma_hh_up}    Liên kết kênh bán    ${list_audit_lk}
    ${ton}    Set Variable If    '${ton}'=='none' or '${loai_hh}'=='imei' or '${loai_hh}'=='lodate'     0      ${ton}
    ${ton}    Set Variable If    '${loai_hh}'=='service' or '${loai_hh}'=='combo'   none    ${ton}
    ${list_audit_db}     Create list audit trail for sync product        ${ma_hh_up}   ${gia_ban}     ${ton}
    Assert audit trail by time succeed   ${get_cur_date}    ${ma_hh_up}    Đồng bộ Shopee    ${list_audit_db}
    Delete product thr API    ${ma_hh_up}

mapapispe6
    [Arguments]   ${shop_shopee}   ${loai_hh}    ${ma_hh}    ${ten_sp}   ${nhom_hang}   ${gia_ban}    ${ton}    ${sp_1}   ${sl_1}   ${sp_2}   ${sl_2}     ${ma_hh_up}
    ${list_product}   Create List    ${ma_hh}     ${ma_hh_up}
    Delete list product if list product is visible thr API     ${list_product}
    ${get_cur_date}     Get Current Date    result_format=%Y-%m-%d %H:%M:%S
    Add product by product type thr API   ${loai_hh}     ${ma_hh}    ${ten_sp}   ${nhom_hang}   ${gia_ban}    45000    ${ton}     ${sp_1}   ${sl_1}   ${sp_2}   ${sl_2}
    Wait Until Keyword Succeeds    3x    2x    Update product thr API   ${loai_hh}    ${ma_hh}    ${ma_hh_up}    none    none
    Sleep    5s
    ${get_sku}    Get item sku shopee by kv product sku     ${shop_shopee}     ${ma_hh}
    Should Be Equal As Strings    ${get_sku}    0
    Delete product thr API    ${ma_hh_up}
