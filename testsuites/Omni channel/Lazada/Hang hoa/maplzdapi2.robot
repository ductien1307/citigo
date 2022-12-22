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
&{dict_sp}    TPG05=1

*** Test Cases ***      Tên shop lazada   Loại hh    Mã hh      Tên sp   Nhóm hàng   Giá bán    Tồn    Mã hh lazada
Tao moi hang hoa trung sku voi hang da co lien ket
                        [Tags]      LZD   LZDH
                        [Template]    mapapilzd4
                        [Timeout]     10 minutes
                        KiotViet        imei      V9     abc     Mỹ phẩm       75000       none    none    none    none    none
                        KiotViet        lodate    V9     abc     Mỹ phẩm       123000       none    none    none    none    none
                        KiotViet        combo     V9    abc     Mỹ phẩm       36000       43.36    TPD025     2    TPD026    1
                        KiotViet        unit      V9   abc     Mỹ phẩm       96000       33.98    V9-1    4    none    none
                        KiotViet        manu      V9      abc     Mỹ phẩm       132000       22.2    TPD025     2     TPD026    1

Cap nhat hang hoa trung sku voi hang chua lien ket
                        [Tags]      LZD   LZDH
                        [Template]    mapapilzd5
                        [Timeout]     10 minutes
                        KiotViet        imei      ulazada13        imei     Mỹ phẩm       75000       none    none    none    none    none     HH360
                        KiotViet        lodate    ulazada14        lodate     Mỹ phẩm       123000      none    none    none    none    none    SP000095
                        KiotViet        combo     ulazada15        combo     Mỹ phẩm       36000       43.36    TPD025     2    TPD026    1     XL – 5500A
                        KiotViet        unit      ulazada16        dvt     Mỹ phẩm       96000       33.98    lazada16-1    4    none    none    L-50C
                        KiotViet         manu     ulazada17        sx     Mỹ phẩm       132000       22.2    TPD025     2     TPD026    1    OPR-2001
                        KiotViet        service   ulazada18        dich vu     Mỹ phẩm       123000      none    none    none    none    none   OPR-3201Z

Cap nhat hang hoa trung sku voi hang da co lien ket
                        [Tags]     LZD   LZDH
                        [Template]    mapapilzd6
                        [Timeout]     10 minutes
                        KiotViet        imei      ulazada7        imei     Mỹ phẩm       75000       none    none    none    none    none     V9
                        KiotViet        lodate    ulazada8        lodate     Mỹ phẩm       123000      none    none    none    none    none    V9
                        KiotViet        combo     ulazada9        combo     Mỹ phẩm       36000       43.36    TPD025     2    TPD026    1     V9
                        KiotViet        unit      ulazada10        dvt     Mỹ phẩm       96000       33.98    lazada10-1    4    none    none    V9
                        KiotViet         manu     ulazada11        sx     Mỹ phẩm       132000       22.2    TPD025     2     TPD026    1    V9
                        KiotViet        service   ulazada12        dich vu     Mỹ phẩm       123000      none    none    none    none    none   V9

*** Keywords ***
mapapilzd4
    [Arguments]   ${shop_lazada}   ${loai_hh}    ${ma_hh}    ${ten_sp}   ${nhom_hang}   ${gia_ban}    ${ton}    ${sp_1}   ${sl_1}   ${sp_2}   ${sl_2}
    Delete product if product is visible thr API    ${ma_hh}
    ${get_cur_date}     Get Current Date    result_format=%Y-%m-%d %H:%M:%S
    Add product by product type thr API   ${loai_hh}     ${ma_hh}    ${ten_sp}   ${nhom_hang}   ${gia_ban}    45000    ${ton}     ${sp_1}   ${sl_1}   ${sp_2}   ${sl_2}
    Sleep    5s
    ${get_sku}    Get item sku lazada by kv product sku     ${shop_lazada}     ${ma_hh}
    Should Be Equal As Strings    ${get_sku}    0
    Delete product thr API       ${ma_hh}

mapapilzd5
    [Arguments]   ${shop_lazada}   ${loai_hh}    ${ma_hh}    ${ten_sp}   ${nhom_hang}   ${gia_ban}    ${ton}    ${sp_1}   ${sl_1}   ${sp_2}   ${sl_2}     ${ma_hh_up}
    ${list_product}   Create List    ${ma_hh}     ${ma_hh_up}
    Delete list product if list product is visible thr API     ${list_product}
    ${get_cur_date}     Get Current Date    result_format=%Y-%m-%d %H:%M:%S
    Add product by product type thr API   ${loai_hh}     ${ma_hh}    ${ten_sp}   ${nhom_hang}   ${gia_ban}    45000    ${ton}     ${sp_1}   ${sl_1}   ${sp_2}   ${sl_2}
    Wait Until Keyword Succeeds    3x    2x    Update product thr API   ${loai_hh}    ${ma_hh}    ${ma_hh_up}    none    none
    #
    Log    validate lstt
    ${list_audit_lk}   Create list audit trail for map product lazada    ${shop_lazada}  ${ma_hh_up}    ${ma_hh_up}
    Wait Until Keyword Succeeds    10x     1s    Assert audit trail by time succeed    ${get_cur_date}   ${ma_hh_up}    Liên kết kênh bán    ${list_audit_lk}
    ${ton}    Set Variable If    '${ton}'=='none' or '${loai_hh}'=='imei' or '${loai_hh}'=='lodate'     0      ${ton}
    ${ton}    Set Variable If    '${loai_hh}'=='service' or '${loai_hh}'=='combo'   none    ${ton}
    ${list_audit_db}     Create list audit trail for sync product        ${ma_hh_up}   ${gia_ban}     ${ton}
    Assert audit trail by time succeed   ${get_cur_date}    ${ma_hh_up}    Đồng bộ Lazada    ${list_audit_db}
    Delete product thr API    ${ma_hh_up}

mapapilzd6
    [Arguments]   ${shop_lazada}   ${loai_hh}    ${ma_hh}    ${ten_sp}   ${nhom_hang}   ${gia_ban}    ${ton}    ${sp_1}   ${sl_1}   ${sp_2}   ${sl_2}     ${ma_hh_up}
    ${list_product}   Create List    ${ma_hh}     ${ma_hh_up}
    Delete list product if list product is visible thr API     ${list_product}
    ${get_cur_date}     Get Current Date    result_format=%Y-%m-%d %H:%M:%S
    Add product by product type thr API   ${loai_hh}     ${ma_hh}    ${ten_sp}   ${nhom_hang}   ${gia_ban}    45000    ${ton}     ${sp_1}   ${sl_1}   ${sp_2}   ${sl_2}
    Wait Until Keyword Succeeds    3x    2x    Update product thr API   ${loai_hh}    ${ma_hh}    ${ma_hh_up}    none    none
    Sleep    5s
    ${get_sku}    Get item sku lazada by kv product sku     ${shop_lazada}     ${ma_hh}
    Should Be Equal As Strings    ${get_sku}    0
    Delete product thr API    ${ma_hh_up}
