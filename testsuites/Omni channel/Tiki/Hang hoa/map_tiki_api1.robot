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

*** Test Cases ***      Tên shop tiki   Loại hàng  Mã hh       Tên sp    Nhóm hàng   Giá bán   Tồn    Mã hh tiki
Lien ket hang hoa
                        [Tags]            TIKIH
                        [Template]    mapapitk1
                        [Timeout]     15 minutes
                        KiotViet        imei      tiki1        imei     Mỹ phẩm       75000       none    none    none    none    none     12324564991
                        KiotViet        lodate    tiki2        lodate     Mỹ phẩm       123000      none    none    none    none    none    111111111111
                        KiotViet        combo     tiki3        cpmbo     Mỹ phẩm       36000       43.36    TPD025     2    TPD026    1     38812883MMN
                        KiotViet        unit      tiki4        dvt     Mỹ phẩm       96000       33.98    tiki4-1    4    none    none    444551
                        KiotViet        manu      tiki5        sx     Mỹ phẩm       132000       22.2    TPD025     2     TPD026    1    77327373
                        KiotViet        service   tiki6        dich vu     Mỹ phẩm       123000      none    none    none    none    none   243235356

Tu dong lien ket hang hoa trung sku chua co lien ket va thay doi gia - sl
                        [Tags]            TIKIH
                        [Template]    mapapitk3
                        [Timeout]     15 minutes
                        KiotViet        imei      54354554   imei     Mỹ phẩm       75000       none    none    none    none    none        85000     none
                        KiotViet        lodate    49394JJJ   lodate     Mỹ phẩm       123000      none    none    none    none    none      133000     none
                        KiotViet        combo     544433213   combo     Mỹ phẩm       36000       43.36    TPD025     2    TPD026    1      40000     none
                        KiotViet        unit      73427488356HSDSD   dvt     Mỹ phẩm       96000       33.98    73427488356HSDSD-1    4    none    none     100000      35.96
                        KiotViet        manu      3523627   sx     Mỹ phẩm       132000       22.8    TPD025     2     TPD026    1        140000        30

*** Keywords ***
mapapitk1
    [Arguments]   ${shop_tiki}   ${loai_hh}    ${ma_hh}    ${ten_sp}   ${nhom_hang}   ${gia_ban}    ${ton}    ${sp_1}   ${sl_1}   ${sp_2}   ${sl_2}    ${ma_hh_tiki}
    Delete product if product is visible thr API    ${ma_hh}
    Add product by product type thr API   ${loai_hh}     ${ma_hh}    ${ten_sp}   ${nhom_hang}   ${gia_ban}    45000    ${ton}     ${sp_1}   ${sl_1}   ${sp_2}   ${sl_2}
    Sleep    5s
    ${get_cur_date}     Get Current Date    result_format=%Y-%m-%d %H:%M:%S
    Wait Until Keyword Succeeds    3x    1s    Mapping product with tiki thr API     ${shop_tiki}   ${ma_hh_tiki}     ${ma_hh}
    #
    Log    validate lstt
    ${list_audit_lk}   Create list audit trail for map product Tiki    ${shop_tiki}  ${ma_hh}    ${ma_hh_tiki}
    Wait Until Keyword Succeeds    5x     2s    Assert audit trail by time succeed    ${get_cur_date}   ${ma_hh}    Liên kết kênh bán    ${list_audit_lk}
    ${ton}    Set Variable If    '${ton}'=='none' or '${loai_hh}'=='imei' or '${loai_hh}'=='lodate'     0      ${ton}
    ${ton}    Set Variable If    '${loai_hh}'=='service' or '${loai_hh}'=='combo'   none    ${ton}
    ${list_audit_db}     Create list audit trail for sync product       ${ma_hh}   ${gia_ban}     ${ton}
    Assert audit trail by time succeed   ${get_cur_date}    ${ma_hh}    Đồng bộ Tiki    ${list_audit_db}
    Delete product thr API    ${ma_hh}

mapapitk2
    [Arguments]   ${shop_tiki}   ${loai_hh}    ${ma_hh}    ${ten_sp}   ${nhom_hang}   ${gia_ban}    ${ton}    ${sp_1}   ${sl_1}   ${sp_2}   ${sl_2}
    Delete product if product is visible thr API    ${ma_hh}
    ${get_cur_date}     Get Current Date    result_format=%Y-%m-%d %H:%M:%S
    Add product by product type thr API   ${loai_hh}     ${ma_hh}    ${ten_sp}   ${nhom_hang}   ${gia_ban}    45000    ${ton}     ${sp_1}   ${sl_1}   ${sp_2}   ${sl_2}
    Log    validate lstt
    ${list_audit_lk}   Create list audit trail for map product Tiki    ${shop_tiki}  ${ma_hh}    ${ma_hh}
    Wait Until Keyword Succeeds    5x     2s    Assert audit trail by time succeed    ${get_cur_date}   ${ma_hh}    Liên kết kênh bán    ${list_audit_lk}
    ${ton}    Set Variable If    '${ton}'=='none'or '${loai_hh}'=='imei' or '${loai_hh}'=='lodate'     0      ${ton}
    ${ton}    Set Variable If    '${loai_hh}'=='service' or '${loai_hh}'=='combo'   none    ${ton}
    ${list_audit_db}     Create list audit trail for sync product       ${ma_hh}   ${gia_ban}     ${ton}
    Assert audit trail by time succeed   ${get_cur_date}    ${ma_hh}    Đồng bộ Tiki    ${list_audit_db}
    Delete product thr API    ${ma_hh}

mapapitk3
    [Arguments]   ${shop_tiki}   ${loai_hh}    ${ma_hh}    ${ten_sp}   ${nhom_hang}   ${gia_ban}    ${ton}    ${sp_1}   ${sl_1}   ${sp_2}   ${sl_2}     ${gia_ban_up}     ${ton_up}
    Delete product if product is visible thr API    ${ma_hh}
    ${get_cur_date}     Get Current Date    result_format=%Y-%m-%d %H:%M:%S
    Add product by product type thr API   ${loai_hh}     ${ma_hh}    ${ten_sp}   ${nhom_hang}   ${gia_ban}    45000    ${ton}     ${sp_1}   ${sl_1}   ${sp_2}   ${sl_2}
    Log    validate lstt
    ${list_audit_lk}   Create list audit trail for map product Tiki    ${shop_tiki}  ${ma_hh}    ${ma_hh}
    Wait Until Keyword Succeeds    5x     2s    Assert audit trail by time succeed    ${get_cur_date}   ${ma_hh}    Liên kết kênh bán    ${list_audit_lk}
    ${ton}    Set Variable If    '${ton}'=='none'or '${loai_hh}'=='imei' or '${loai_hh}'=='lodate'     0      ${ton}
    ${ton}    Set Variable If    '${loai_hh}'=='service' or '${loai_hh}'=='combo'   none    ${ton}
    ${list_audit_db}     Create list audit trail for sync product        ${ma_hh}   ${gia_ban}     ${ton}
    Assert audit trail by time succeed   ${get_cur_date}    ${ma_hh}    Đồng bộ Tiki    ${list_audit_db}
    #
    Log    Cập nhật giá bán, tồn kho
    Wait Until Keyword Succeeds    3x    2x    Update product thr API   ${loai_hh}    ${ma_hh}    none    ${gia_ban_up}     ${ton_up}
    ${get_cur_date_up}     Get Current Date    result_format=%Y-%m-%d %H:%M:%S
    ${ton_up}    Set Variable If    '${ton_up}'=='none' or '${loai_hh}'=='imei' or '${loai_hh}'=='lodate'     0      ${ton_up}
    ${ton_up}    Set Variable If    '${loai_hh}'=='service' or '${loai_hh}'=='combo'   none    ${ton_up}
    ${list_audit_db}     Create list audit trail for sync product        ${ma_hh}   ${gia_ban_up}     ${ton_up}
    Assert audit trail by time succeed   ${get_cur_date_up}    ${ma_hh}    Đồng bộ Tiki    ${list_audit_db}
    Delete product thr API    ${ma_hh}
