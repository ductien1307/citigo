*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    ${headless_browser}
Test Teardown     After Test
Library           SeleniumLibrary
Resource          ../../../../core/Thiet_lap/thiet_lap_nav.robot
Resource          ../../../../core/Thiet_lap/thiet_lap_cuahang_list_action.robot
Resource          ../../../../core/API/api_thietlap.robot
Resource          ../../../../core/API/api_sendo.robot
Resource          ../../../../core/API/api_hanghoa.robot
Resource          ../../../../prepare/Hang_hoa/Sources/hanghoa.robot
Resource          ../../../../core/hang_hoa/hang_hoa_add_action.robot
Resource          ../../../../core/hang_hoa/hang_hoa_add_page.robot
Resource          ../../../../core/hang_hoa/danh_muc_list_action.robot

*** Variables ***
&{dict_sp}    TPG03=1

*** Test Cases ***      Tên shop sendo   Loại hàng  Mã hh       Tên sp    Nhóm hàng   Giá bán   Tồn    Mã hh sendo
Lien ket hang hoa
                        [Tags]      SDOH
                        [Template]    mapapisdo1
                        [Timeout]     15 minutes
                        KiotViet        imei      sendo1        imei     Mỹ phẩm       75000.52       none    none    none    none    none     L_Hồng phấn
                        KiotViet        lodate    sendo2        lodate     Mỹ phẩm       123000.96      none    none    none    none    none    SD0191102
                        KiotViet        combo     sendo3        combo     Mỹ phẩm       36000       43.36    TPD025     2    TPD026    1     SD0191104
                        KiotViet        unit      sendo4        dvt     Mỹ phẩm       96000       33.98    sendo4-1    4    none    none    SD0191102
                        KiotViet        manu      sendo5        sx     Mỹ phẩm       132000.11       22.2    TPD025     2     TPD026    1    SD0191105
                        KiotViet        service   sendo6        dich vu     Mỹ phẩm       123000      none    none    none    none    none   SP000009

Tu dong lien ket hang hoa trung sku chua co lien ket va thay doi gia - sl
                        [Tags]      SDOH
                        [Template]    mapapisdo3
                        [Timeout]     15 minutes
                        KiotViet        imei      SP003528   imei     Mỹ phẩm       75000       none    none    none    none    none        85000     none
                        KiotViet        lodate    SD000011   lodate     Mỹ phẩm       123000      none    none    none    none    none      133000     none
                        KiotViet        combo     SD000013   combo     Mỹ phẩm       36000       43.36    TPD025     2    TPD026    1      40000     none
                        KiotViet        unit      SD0000001   dvt     Mỹ phẩm       96000       33.98    SD0000001-1    4    none    none     100000      35.96
                        KiotViet        manu      22327085875   sx     Mỹ phẩm       132000       22.8    TPD025     2     TPD026    1        140000        30

*** Keywords ***
mapapisdo1
    [Arguments]   ${shop_sendo}   ${loai_hh}    ${ma_hh}    ${ten_sp}   ${nhom_hang}   ${gia_ban}    ${ton}    ${sp_1}   ${sl_1}   ${sp_2}   ${sl_2}    ${ma_hh_sendo}
    Delete product if product is visible thr API    ${ma_hh}
    Add product by product type thr API   ${loai_hh}     ${ma_hh}    ${ten_sp}   ${nhom_hang}   ${gia_ban}    45000    ${ton}     ${sp_1}   ${sl_1}   ${sp_2}   ${sl_2}
    Sleep    5s
    ${get_cur_date}     Get Current Date    result_format=%Y-%m-%d %H:%M:%S
    Wait Until Keyword Succeeds    3x    1s    Mapping product with Sendo thr API     ${shop_sendo}   ${ma_hh_sendo}     ${ma_hh}
    #
    Log    validate lstt
    ${list_audit_lk}   Create list audit trail for map product Sendo    ${shop_sendo}  ${ma_hh}    ${ma_hh_sendo}
    Wait Until Keyword Succeeds    10x     1s    Assert audit trail by time succeed    ${get_cur_date}   ${ma_hh}    Liên kết kênh bán    ${list_audit_lk}
    ${ton}    Set Variable If    '${ton}'=='none'     0      ${ton}
    ${ton}    Set Variable If    '${loai_hh}'=='service' or '${loai_hh}'=='combo'   none    ${ton}
    ${list_audit_db}     Create list audit trail for sync product       ${ma_hh}   ${gia_ban}     ${ton}
    Assert audit trail by time succeed   ${get_cur_date}    ${ma_hh}    Đồng bộ Sendo    ${list_audit_db}
    Delete product thr API    ${ma_hh}

mapapisdo2
    [Arguments]   ${shop_sendo}   ${loai_hh}    ${ma_hh}    ${ten_sp}   ${nhom_hang}   ${gia_ban}    ${ton}    ${sp_1}   ${sl_1}   ${sp_2}   ${sl_2}
    Delete product if product is visible thr API    ${ma_hh}
    ${get_cur_date}     Get Current Date    result_format=%Y-%m-%d %H:%M:%S
    Add product by product type thr API   ${loai_hh}     ${ma_hh}    ${ten_sp}   ${nhom_hang}   ${gia_ban}    45000    ${ton}     ${sp_1}   ${sl_1}   ${sp_2}   ${sl_2}
    Log    validate lstt
    ${list_audit_lk}   Create list audit trail for map product Sendo    ${shop_sendo}  ${ma_hh}    ${ma_hh}
    Wait Until Keyword Succeeds    10x     1s    Assert audit trail by time succeed    ${get_cur_date}   ${ma_hh}    Liên kết kênh bán    ${list_audit_lk}
    ${ton}    Set Variable If    '${ton}'=='none'    0      ${ton}
    ${ton}    Set Variable If    '${loai_hh}'=='service' or '${loai_hh}'=='combo'   none    ${ton}
    ${list_audit_db}     Create list audit trail for sync product       ${ma_hh}   ${gia_ban}     ${ton}
    Assert audit trail by time succeed   ${get_cur_date}    ${ma_hh}    Đồng bộ Sendo    ${list_audit_db}
    Delete product thr API    ${ma_hh}

mapapisdo3
    [Arguments]   ${shop_sendo}   ${loai_hh}    ${ma_hh}    ${ten_sp}   ${nhom_hang}   ${gia_ban}    ${ton}    ${sp_1}   ${sl_1}   ${sp_2}   ${sl_2}     ${gia_ban_up}     ${ton_up}
    Delete product if product is visible thr API    ${ma_hh}
    ${get_cur_date}     Get Current Date    result_format=%Y-%m-%d %H:%M:%S
    Add product by product type thr API   ${loai_hh}     ${ma_hh}    ${ten_sp}   ${nhom_hang}   ${gia_ban}    45000    ${ton}     ${sp_1}   ${sl_1}   ${sp_2}   ${sl_2}
    Log    validate lstt
    ${list_audit_lk}   Create list audit trail for map product sendo    ${shop_sendo}  ${ma_hh}    ${ma_hh}
    Wait Until Keyword Succeeds    10x     1s    Assert audit trail by time succeed    ${get_cur_date}   ${ma_hh}    Liên kết kênh bán    ${list_audit_lk}
    ${ton}    Set Variable If    '${ton}'=='none'     0      ${ton}
    ${ton}    Set Variable If    '${loai_hh}'=='service' or '${loai_hh}'=='combo'   none    ${ton}
    ${list_audit_db}     Create list audit trail for sync product        ${ma_hh}   ${gia_ban}     ${ton}
    Assert audit trail by time succeed   ${get_cur_date}    ${ma_hh}    Đồng bộ Sendo    ${list_audit_db}
    #
    Log    Cập nhật giá bán, tồn kho
    Wait Until Keyword Succeeds    3x    2x    Update product thr API   ${loai_hh}    ${ma_hh}    none    ${gia_ban_up}     ${ton_up}
    ${get_cur_date_up}     Get Current Date    result_format=%Y-%m-%d %H:%M:%S
    ${ton_up}    Set Variable If    '${ton_up}'=='none'     0      ${ton_up}
    ${ton_up}    Set Variable If    '${loai_hh}'=='service' or '${loai_hh}'=='combo'  none    ${ton_up}
    ${list_audit_db}     Create list audit trail for sync product        ${ma_hh}   ${gia_ban_up}     ${ton_up}
    Assert audit trail by time succeed   ${get_cur_date_up}    ${ma_hh}    Đồng bộ Sendo    ${list_audit_db}
    Delete product thr API    ${ma_hh}

mapapisdo33
    [Arguments]     ${shop_sendo}     ${loai_hh}      ${input_ten_sp}   ${nhom_hang}      ${gia_ban}
