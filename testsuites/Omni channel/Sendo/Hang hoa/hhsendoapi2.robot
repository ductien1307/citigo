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

*** Test Cases ***      Tên shop sendo   Loại hh    Mã hh      Tên sp   Nhóm hàng   Giá bán    Tồn    Mã hh sendo
Tao moi hang hoa trung sku voi hang da co lien ket
                        [Tags]      SDOH
                        [Template]    mapapisdo4
                        [Timeout]     10 minutes
                        KiotViet        imei      SD0508005      abc     Mỹ phẩm       75000.95       none    none    none    none    none
                        KiotViet        lodate    SD0508005      abc     Mỹ phẩm       123000       none    none    none    none    none
                        KiotViet        combo     SD0508005      abc     Mỹ phẩm       36000.11       43.36    TPD025     2    TPD026    1
                        KiotViet        unit      SD0508005      abc     Mỹ phẩm       96000       33.98    SD0508005-1    4    none    none
                        KiotViet        manu      SD0508005      abc     Mỹ phẩm       132000       22.2    TPD025     2     TPD026    1

Cap nhat hang hoa trung sku voi hang chua lien ket
                        [Tags]      SDOH
                        [Template]    mapapisdo5
                        [Timeout]     10 minutes
                        KiotViet        imei      usdo13        imei     Mỹ phẩm       75000       none    none    none    none    none     LỢN HỒNG 70CM
                        KiotViet        lodate    usdo14        lodate     Mỹ phẩm       123000.25      none    none    none    none    none    SD000012
                        KiotViet        combo     usdo15        combo     Mỹ phẩm       36000       43.36    TPD025     2    TPD026    1     SKU00002
                        KiotViet        unit      usdo16        dvt     Mỹ phẩm       96000       33.98    usdo16-1    4    none    none    SKU00004
                        KiotViet         manu     usdo17        sx     Mỹ phẩm       132000.96       22.2    TPD025     2     TPD026    1      SKU00001
                        KiotViet        service   usdo18        dich vu     Mỹ phẩm       123000      none    none    none    none    none   SKU00005

Cap nhat hang hoa trung sku voi hang da co lien ket
                        [Tags]      SDOH
                        [Template]    mapapisdo6
                        [Timeout]     10 minutes
                        KiotViet        imei      usdo7        imei     Mỹ phẩm       75000       none    none    none    none    none     SD0508005
                        KiotViet        lodate    usdo8        lodate     Mỹ phẩm       123000.12      none    none    none    none    none    SD0508005
                        KiotViet        combo     usdo9        combo     Mỹ phẩm       36000       43.36    TPD025     2    TPD026    1     SD0508005
                        KiotViet        unit      usdo10        dvt     Mỹ phẩm       96000       33.98    sendo10-1    4    none    none    SD0508005
                        KiotViet         manu     usdo11        sx     Mỹ phẩm       132000       22.2    TPD025     2     TPD026    1    SD0508005
                        KiotViet        service   usdo12        dich vu     Mỹ phẩm       123000.52      none    none    none    none    none   SD0508005

*** Keywords ***
mapapisdo4
    [Arguments]   ${shop_sendo}   ${loai_hh}    ${ma_hh}    ${ten_sp}   ${nhom_hang}   ${gia_ban}    ${ton}    ${sp_1}   ${sl_1}   ${sp_2}   ${sl_2}
    Delete product if product is visible thr API    ${ma_hh}
    ${get_cur_date}     Get Current Date    result_format=%Y-%m-%d %H:%M:%S
    Add product by product type thr API   ${loai_hh}     ${ma_hh}    ${ten_sp}   ${nhom_hang}   ${gia_ban}    45000    ${ton}     ${sp_1}   ${sl_1}   ${sp_2}   ${sl_2}
    Sleep    5s
    ${get_sku}    Get item sku Sendo by kv product sku     ${shop_sendo}     ${ma_hh}
    Should Be Equal As Strings    ${get_sku}    0
    Delete product thr API       ${ma_hh}

mapapisdo5
    [Arguments]   ${shop_sendo}   ${loai_hh}    ${ma_hh}    ${ten_sp}   ${nhom_hang}   ${gia_ban}    ${ton}    ${sp_1}   ${sl_1}   ${sp_2}   ${sl_2}     ${ma_hh_up}
    ${list_product}   Create List    ${ma_hh}     ${ma_hh_up}
    Delete list product if list product is visible thr API     ${list_product}
    ${get_cur_date}     Get Current Date    result_format=%Y-%m-%d %H:%M:%S
    Add product by product type thr API   ${loai_hh}     ${ma_hh}    ${ten_sp}   ${nhom_hang}   ${gia_ban}    45000    ${ton}     ${sp_1}   ${sl_1}   ${sp_2}   ${sl_2}
    Wait Until Keyword Succeeds    3x    2x    Update product thr API   ${loai_hh}    ${ma_hh}    ${ma_hh_up}    none    none
    #
    Log    validate lstt
    ${list_audit_lk}   Create list audit trail for map product Sendo    ${shop_sendo}  ${ma_hh_up}    ${ma_hh_up}
    Wait Until Keyword Succeeds    10x     1s    Assert audit trail by time succeed    ${get_cur_date}   ${ma_hh_up}    Liên kết kênh bán    ${list_audit_lk}
    ${ton}    Set Variable If    '${ton}'=='none'      0      ${ton}
    ${ton}    Set Variable If    '${loai_hh}'=='service' or '${loai_hh}'=='combo'   none    ${ton}
    ${list_audit_db}     Create list audit trail for sync product        ${ma_hh_up}   ${gia_ban}     ${ton}
    Assert audit trail by time succeed   ${get_cur_date}    ${ma_hh_up}    Đồng bộ Sendo    ${list_audit_db}
    Delete product thr API    ${ma_hh_up}

mapapisdo6
    [Arguments]   ${shop_sendo}   ${loai_hh}    ${ma_hh}    ${ten_sp}   ${nhom_hang}   ${gia_ban}    ${ton}    ${sp_1}   ${sl_1}   ${sp_2}   ${sl_2}     ${ma_hh_up}
    ${list_product}   Create List    ${ma_hh}     ${ma_hh_up}
    Delete list product if list product is visible thr API     ${list_product}
    ${get_cur_date}     Get Current Date    result_format=%Y-%m-%d %H:%M:%S
    Add product by product type thr API   ${loai_hh}     ${ma_hh}    ${ten_sp}   ${nhom_hang}   ${gia_ban}    45000    ${ton}     ${sp_1}   ${sl_1}   ${sp_2}   ${sl_2}
    Wait Until Keyword Succeeds    3x    2x    Update product thr API   ${loai_hh}    ${ma_hh}    ${ma_hh_up}    none    none
    Sleep    5s
    ${get_sku}    Get item sku Sendo by kv product sku     ${shop_sendo}     ${ma_hh}
    Should Be Equal As Strings    ${get_sku}    0
    Delete product thr API    ${ma_hh_up}
