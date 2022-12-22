*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    ${headless_browser}
Test Teardown     After Test
Library           SeleniumLibrary
Resource          ../../../../core/Thiet_lap/thiet_lap_nav.robot
Resource          ../../../../core/Thiet_lap/thiet_lap_cuahang_list_action.robot
Resource          ../../../../core/API/api_thietlap.robot
Resource          ../../../../core/API/api_tiki.robot
Resource          ../../../../core/API/api_hanghoa.robot
Resource          ../../../../prepare/Hang_hoa/Sources/hanghoa.robot
Resource          ../../../../core/hang_hoa/hang_hoa_add_action.robot
Resource          ../../../../core/hang_hoa/hang_hoa_add_page.robot
Resource          ../../../../core/hang_hoa/danh_muc_list_action.robot

*** Variables ***
&{dict_sp}    TPG03=1

*** Test Cases ***      Tên shop tiki   Loại hh    Mã hh      Tên sp   Nhóm hàng   Giá bán    Tồn    Mã hh tiki
Tao moi hang hoa trung sku voi hang da co lien ket
                        [Tags]            TIKIH
                        [Template]    mapapitk4
                        [Timeout]     10 minutes
                        KiotViet        imei      4533256     abc     Mỹ phẩm       75000       none    none    none    none    none
                        KiotViet        lodate    4533256     abc     Mỹ phẩm       123000       none    none    none    none    none
                        KiotViet        combo     4533256    abc     Mỹ phẩm       36000       43.36    TPD025     2    TPD026    1
                        KiotViet        unit      4533256   abc     Mỹ phẩm       96000       33.98    4533256-1    4    none    none
                        KiotViet        manu      4533256      abc     Mỹ phẩm       132000       22.2    TPD025     2     TPD026    1

Cap nhat hang hoa trung sku voi hang chua lien ket
                        [Tags]            TIKIH
                        [Template]    mapapitk5
                        [Timeout]     10 minutes
                        KiotViet        imei      utiki13        imei     Mỹ phẩm       75000       none    none    none    none    none     09004092356788
                        KiotViet        lodate    utiki14        lodate     Mỹ phẩm       123000      none    none    none    none    none    34252222
                        KiotViet        combo     utiki15        combo     Mỹ phẩm       36000       43.36    TPD025     2    TPD026    1     7888
                        KiotViet        unit      utiki16        dvt     Mỹ phẩm       96000       33.98    tiki16-1    4    none    none    16111852
                        KiotViet         manu     utiki17        sx     Mỹ phẩm       132000       22.2    TPD025     2     TPD026    1    8900
                        KiotViet        service   utiki18        dich vu     Mỹ phẩm       123000      none    none    none    none    none   45442663

Cap nhat hang hoa trung sku voi hang da co lien ket
                        [Tags]           TIKIH
                        [Template]    mapapitk6
                        [Timeout]     10 minutes
                        KiotViet        imei      utiki7        imei     Mỹ phẩm       75000       none    none    none    none    none     4533256
                        KiotViet        lodate    utiki8        lodate     Mỹ phẩm       123000      none    none    none    none    none    4533256
                        KiotViet        combo     utiki9        combo     Mỹ phẩm       36000       43.36    TPD025     2    TPD026    1     4533256
                        KiotViet        unit      utiki10        dvt     Mỹ phẩm       96000       33.98    tiki10-1    4    none    none    4533256
                        KiotViet         manu     utiki11        sx     Mỹ phẩm       132000       22.2    TPD025     2     TPD026    1    4533256
                        KiotViet        service   utiki12        dich vu     Mỹ phẩm       123000      none    none    none    none    none   4533256

*** Keywords ***
mapapitk4
    [Arguments]   ${shop_tiki}   ${loai_hh}    ${ma_hh}    ${ten_sp}   ${nhom_hang}   ${gia_ban}    ${ton}    ${sp_1}   ${sl_1}   ${sp_2}   ${sl_2}
    Delete product if product is visible thr API    ${ma_hh}
    ${get_cur_date}     Get Current Date    result_format=%Y-%m-%d %H:%M:%S
    Add product by product type thr API   ${loai_hh}     ${ma_hh}    ${ten_sp}   ${nhom_hang}   ${gia_ban}    45000    ${ton}     ${sp_1}   ${sl_1}   ${sp_2}   ${sl_2}
    Sleep    5s
    ${get_sku}    Get item sku tiki by kv product sku     ${shop_tiki}     ${ma_hh}
    Should Be Equal As Strings    ${get_sku}    0
    Delete product thr API       ${ma_hh}

mapapitk5
    [Arguments]   ${shop_tiki}   ${loai_hh}    ${ma_hh}    ${ten_sp}   ${nhom_hang}   ${gia_ban}    ${ton}    ${sp_1}   ${sl_1}   ${sp_2}   ${sl_2}     ${ma_hh_up}
    ${list_product}   Create List    ${ma_hh}     ${ma_hh_up}
    Delete list product if list product is visible thr API     ${list_product}
    ${get_cur_date}     Get Current Date    result_format=%Y-%m-%d %H:%M:%S
    Add product by product type thr API   ${loai_hh}     ${ma_hh}    ${ten_sp}   ${nhom_hang}   ${gia_ban}    45000    ${ton}     ${sp_1}   ${sl_1}   ${sp_2}   ${sl_2}
    Wait Until Keyword Succeeds    3x    2x    Update product thr API   ${loai_hh}    ${ma_hh}    ${ma_hh_up}    none    none
    #
    Log    validate lstt
    ${list_audit_lk}   Create list audit trail for map product Tiki    ${shop_tiki}  ${ma_hh_up}    ${ma_hh_up}
    Wait Until Keyword Succeeds    5x     2s    Assert audit trail by time succeed    ${get_cur_date}   ${ma_hh_up}    Liên kết kênh bán    ${list_audit_lk}
    ${ton}    Set Variable If    '${ton}'=='none' or '${loai_hh}'=='imei' or '${loai_hh}'=='lodate'     0      ${ton}
    ${ton}    Set Variable If    '${loai_hh}'=='service' or '${loai_hh}'=='combo'   none    ${ton}
    ${list_audit_db}     Create list audit trail for sync product        ${ma_hh_up}   ${gia_ban}     ${ton}
    Assert audit trail by time succeed   ${get_cur_date}    ${ma_hh_up}    Đồng bộ Tiki    ${list_audit_db}
    Delete product thr API    ${ma_hh_up}

mapapitk6
    [Arguments]   ${shop_tiki}   ${loai_hh}    ${ma_hh}    ${ten_sp}   ${nhom_hang}   ${gia_ban}    ${ton}    ${sp_1}   ${sl_1}   ${sp_2}   ${sl_2}     ${ma_hh_up}
    ${list_product}   Create List    ${ma_hh}     ${ma_hh_up}
    Delete list product if list product is visible thr API     ${list_product}
    ${get_cur_date}     Get Current Date    result_format=%Y-%m-%d %H:%M:%S
    Add product by product type thr API   ${loai_hh}     ${ma_hh}    ${ten_sp}   ${nhom_hang}   ${gia_ban}    45000    ${ton}     ${sp_1}   ${sl_1}   ${sp_2}   ${sl_2}
    Wait Until Keyword Succeeds    3x    2x    Update product thr API   ${loai_hh}    ${ma_hh}    ${ma_hh_up}    none    none
    Sleep    5s
    ${get_sku}    Get item sku tiki by kv product sku     ${shop_tiki}     ${ma_hh}
    Should Be Equal As Strings    ${get_sku}    0
    Delete product thr API    ${ma_hh_up}
