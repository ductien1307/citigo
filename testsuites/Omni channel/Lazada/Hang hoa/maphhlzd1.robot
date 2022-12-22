*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    ${headless_browser}
Test Setup        Before Test Hang Hoa
Test Teardown     After Test
Library           SeleniumLibrary
Resource          ../../../../core/Thiet_lap/thiet_lap_nav.robot
Resource          ../../../../core/Thiet_lap/thiet_lap_cuahang_list_action.robot
Resource          ../../../../core/API/api_thietlap.robot
Resource          ../../../../core/API/api_lazada.robot
Resource          ../../../../core/API/api_mhbh.robot
Resource          ../../../../core/API/api_phieu_nhap_hang.robot
Resource          ../../../../core/API/api_hanghoa.robot
Resource          ../../../../share/constants.robot
Resource          ../../../../prepare/Hang_hoa/Sources/hanghoa.robot
Resource          ../../../../core/hang_hoa/hang_hoa_add_action.robot
Resource          ../../../../core/hang_hoa/hang_hoa_add_page.robot
Resource          ../../../../core/hang_hoa/danh_muc_list_action.robot

*** Variables ***

*** Test Cases ***      Tên shop Lazada        Mã hh         Tên sp           Nhóm hàng    Giá vốn    Mã hh Lazada
Map product o DMHH > tab Lien ket kenh ban
                        [Tags]           LZDH
                        [Template]    maplzd7
                        [Timeout]     3 minutes
                        KiotViet             Tetsplz1       Test Lazada     Mỹ phẩm     70000      SP0000002

Map product o DMHH > Thao tac Lien ket kenh ban
                        [Tags]           LZDH
                        [Template]    maplzd8
                        [Timeout]     3 minutes
                        KiotViet              Tetsplz1       Test Lazada     Mỹ phẩm     55000      SP0000002

Cap nhat hh trung SKU chua co lien ket voi hang dvt
                        [Tags]           LZDH
                        [Template]    maplzd9
                        [Timeout]     3 minutes
                        KiotViet             LZDQD      LZDQD1           5900        4

Cap nhat hh trung SKU voi hang co lien ket
                        [Tags]           LZDH
                        [Template]    maplzd10
                        [Timeout]     3 minutes
                        KiotViet            Tetsplz2        abcd   Mỹ phẩm     SP000094     SP000126

*** Keywords ***
maplzd7
    [Arguments]     ${shop_lazada}     ${ma_hh}    ${ten_sp}    ${ten_nhom}     ${gia_von}    ${ma_hh_Lazada}
    Delete product if product is visible thr API    ${ma_hh}
    ${get_channel_id}     Get lazada channel id thr API   ${shop_lazada}
    ${get_cur_date}     Get Current Date    result_format=%Y-%m-%d %H:%M:%S
    ${giaban_random}    Generate Random String      2     [NUMBERS]
    ${ton}    Generate Random String      2     [NUMBERS]
    ${gia_ban}    Set Variable    1${giaban_random}000
    Add product thr API    ${ma_hh}    ${ten_sp}    ${ten_nhom}    ${gia_ban}    ${gia_von}    ${ton}
    #
    Log    step ui
    Search product code    ${ma_hh}
    Go to tab Lien ket kenh ban and click update
    Select channel Lazada    ${shop_lazada}
    Choose the associated product    ${get_channel_id}    ${ma_hh}    ${ma_hh_Lazada}
    Message mapping product success validation
    #
    Log    validate LSTT
    ${list_audit_lk}   Create list audit trail for map product Lazada    ${shop_lazada}  ${ma_hh}    ${ma_hh_lazada}
    Assert audit trail by time succeed    ${get_cur_date}   ${ma_hh}    Liên kết kênh bán    ${list_audit_lk}
    ${list_audit_db}     Create list audit trail for sync product        ${ma_hh}   ${gia_ban}     ${ton}
    Assert audit trail by time succeed   ${get_cur_date}    ${ma_hh}    Đồng bộ Lazada    ${list_audit_db}
    Delete product if product is visible thr API    ${ma_hh}

maplzd8
    [Arguments]     ${shop_lazada}     ${ma_hh}    ${ten_sp}    ${ten_nhom}     ${gia_von}    ${ma_hh_Lazada}
    Delete product if product is visible thr API    ${ma_hh}
    ${get_channel_id}     Get lazada channel id thr API   ${shop_lazada}
    ${get_cur_date}     Get Current Date    result_format=%Y-%m-%d %H:%M:%S
    ${giaban_random}    Generate Random String      2     [NUMBERS]
    ${gia_ban}    Set Variable    1${giaban_random}000
    Add service    ${ma_hh}    ${ten_sp}    ${ten_nhom}    ${gia_ban}    ${gia_von}
    #
    Log    step ui
    Search product code    ${ma_hh}
    Search and select product    ${ma_hh}
    Click Element    ${button_thaotac}
    Wait Until Keyword Succeeds    3x    1s      Click Element    ${button_lienket_kenhban}
    Select channel Lazada    ${shop_lazada}
    Choose the associated product    ${get_channel_id}    ${ma_hh}    ${ma_hh_Lazada}
    Message mapping product success validation
    #
    Log    validate LSTT
    ${list_audit_lk}   Create list audit trail for map product Lazada    ${shop_lazada}  ${ma_hh}    ${ma_hh_lazada}
    Assert audit trail by time succeed    ${get_cur_date}   ${ma_hh}    Liên kết kênh bán    ${list_audit_lk}
    ${list_audit_db}     Create list audit trail for sync product        ${ma_hh}   ${gia_ban}     none
    Assert audit trail by time succeed   ${get_cur_date}    ${ma_hh}    Đồng bộ Lazada    ${list_audit_db}
    Delete product if product is visible thr API    ${ma_hh}

maplzd9
    [Arguments]     ${shop_lazada}    ${ma_hh}   ${ma_qd}  ${ma_hh_up}    ${gtqd}
    ${list_pr}      Create List    ${ma_hh}     ${ma_hh_up}
    Delete list product if list product is visible thr API    ${list_pr}
    ${get_channel_id}       Get lazada channel id thr API       ${shop_lazada}
    ${get_cur_date}     Get Current Date    result_format=%Y-%m-%d %H:%M:%S
    ${giaban_random}    Generate Random String      2     [NUMBERS]
    ${giaban1_random}    Generate Random String      2     [NUMBERS]
    ${ton}    Generate Random String      2     123456789
    ${gia_ban}    Set Variable    1${giaban_random}000
    ${gia_ban1}    Set Variable    1${giaban1_random}000
    Add product incl 1 unit thrAPI    ${ma_hh}    abc    Mỹ phẩm     ${gia_ban}   40000     ${ton}    cái    hộp    ${gtqd}    ${gia_ban1}    ${ma_qd}
    #
    Log    step ui
    Search product code and click update product    ${ma_hh}
    Wait Until Page Contains Element    ${textbox_ma_hh}      30s
    Input Text    ${textbox_ma_hh}    ${ma_hh_up}
    Click Element    ${button_luu}
    Update data success validation
    #
    Log    Assert LSTT
    ${list_audit_lk}   Create list audit trail for map product Lazada    ${shop_lazada}  ${ma_hh_up}    ${ma_hh_up}
    Assert audit trail by time succeed    ${get_cur_date}   ${ma_hh_up}    Liên kết kênh bán    ${list_audit_lk}
    ${list_audit_db}     Create list audit trail for sync product        ${ma_hh_up}   ${gia_ban}     ${ton}
    Assert audit trail by time succeed   ${get_cur_date}    ${ma_hh_up}    Đồng bộ Lazada    ${list_audit_db}
    #
    Delete list product if list product is visible thr API    ${list_pr}

maplzd10
    [Arguments]     ${shop_lazada}     ${ma_hh}    ${ten_sp}    ${ten_nhom}     ${ma_hh_Lazada}    ${ma_hh_up}
    ${list_pr}      Create List    ${ma_hh}     ${ma_hh_up}
    Delete list product if list product is visible thr API    ${list_pr}
    ${get_channel_id}   Get lazada channel id thr API        ${shop_lazada}
    ${get_cur_date}     Get Current Date    result_format=%Y-%m-%d %H:%M:%S
    ${giaban_random}    Generate Random String      2     [NUMBERS]
    ${ton}    Generate Random String      2     [NUMBERS]
    ${gia_ban}    Set Variable    1${giaban_random}000
    Add imei product thr API     ${ma_hh}    ${ten_sp}    ${ten_nhom}    ${gia_ban}
    Mapping product with Lazada thr API     ${shop_lazada}      ${ma_hh_Lazada}    ${ma_hh}
    #
    Log    step ui
    Search product code and click update product    ${ma_hh}
    Wait Until Page Contains Element    ${textbox_ma_hh}      30s
    Input Text    ${textbox_ma_hh}    ${ma_hh_up}
    Click Element    ${button_luu}
    Wait Until Keyword Succeeds    3 times    1s    Update data success validation
    Sleep    5s
    ${get_sku}    Get item sku lazada by kv product sku      ${shop_lazada}     ${ma_hh_up}
    Should Be Equal As Strings    ${get_sku}    ${ma_hh_Lazada}
    Delete product if product is visible thr API    ${ma_hh_up}
