*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    ${headless_browser}
Test Setup        Before Test Hang Hoa
Test Teardown     After Test
Library           SeleniumLibrary
Resource          ../../../../core/Thiet_lap/thiet_lap_nav.robot
Resource          ../../../../core/Thiet_lap/thiet_lap_cuahang_list_action.robot
Resource          ../../../../core/API/api_thietlap.robot
Resource          ../../../../core/API/api_sendo.robot
Resource          ../../../../core/API/api_mhbh.robot
Resource          ../../../../core/API/api_phieu_nhap_hang.robot
Resource          ../../../../core/API/api_hanghoa.robot
Resource          ../../../../share/constants.robot
Resource          ../../../../prepare/Hang_hoa/Sources/hanghoa.robot
Resource          ../../../../core/hang_hoa/hang_hoa_add_action.robot
Resource          ../../../../core/hang_hoa/hang_hoa_add_page.robot
Resource          ../../../../core/hang_hoa/danh_muc_list_action.robot
Resource          ../../../../core/sendo_UAT/sendo_banhang_action.robot

*** Variables ***

*** Test Cases ***      Tên shop sendo      Mã hh         Tên sp           Nhóm hàng    Giá bán    Mã hh sendo
Map product o DMHHH > tab Lien ket kenh ban
                        [Tags]        SDOH1
                        [Template]    mapsdo7
                        [Timeout]     3 minutes
                        KiotViet             Testsd1       Test sendo     Mỹ phẩm     70000      444

Map product o DMHHH > Thao tac Lien ket kenh ban
                        [Tags]        SDOH
                        [Template]    mapsdo8
                        [Timeout]     3 minutes
                        KiotViet             Testsd2       Test sendo     Mỹ phẩm     55000      SP35345930

Cap nhat hh trung SKU chua co lien ket voi hang dvt
                        [Tags]        SDOH
                        [Template]    mapsdo9
                        [Timeout]     3 minutes
                        KiotViet              TESTQDSD      TESTQDSD1           SD0191105       4

Cap nhat hh trung SKU voi hang co lien ket
                        [Tags]         SDOH
                        [Template]    mapsdo10
                        [Timeout]     3 minutes
                        KiotViet         Testsd3        abcd   Mỹ phẩm     SP3534595     SD0508003

*** Keywords ***
mapsdo7
    [Arguments]     ${shop_sendo}      ${ma_hh}    ${ten_sp}    ${ten_nhom}     ${gia_ban}    ${ma_hh_sendo}
    Delete product if product is visible thr API    ${ma_hh}
    ${get_channel_id}  Get Sendo channel id thr API    ${shop_sendo}
    ${get_cur_date}     Get Current Date    result_format=%Y-%m-%d %H:%M:%S
    ${ton}    Generate Random String      2    123456789
    Add product thr API    ${ma_hh}    ${ten_sp}    ${ten_nhom}    ${gia_ban}    30000    ${ton}
    #
    Log    step ui
    Search product code    ${ma_hh}
    Go to tab Lien ket kenh ban and click update
    Select channel Sendo    ${shop_sendo}
    Choose the associated product    ${get_channel_id}    ${ma_hh}    ${ma_hh_sendo}
    Message mapping product success validation
    #
    Log    validate lstt
    ${list_audit_lk}   Create list audit trail for map product sendo    ${shop_sendo}  ${ma_hh}    ${ma_hh_sendo}
    Assert audit trail by time succeed    ${get_cur_date}   ${ma_hh}    Liên kết kênh bán    ${list_audit_lk}
    ${list_audit_db}     Create list audit trail for sync product      ${ma_hh}   ${gia_ban}     ${ton}
    Assert audit trail by time succeed   ${get_cur_date}    ${ma_hh}    Đồng bộ Sendo    ${list_audit_db}
    Delete product if product is visible thr API    ${ma_hh}

mapsdo8
    [Arguments]     ${shop_sendo}     ${ma_hh}    ${ten_sp}    ${ten_nhom}     ${gia_von}    ${ma_hh_sendo}
    Delete product if product is visible thr API    ${ma_hh}
    ${get_channel_id}  Get Sendo channel id thr API    ${shop_sendo}
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
    Select channel Sendo    ${shop_sendo}
    Choose the associated product    ${get_channel_id}    ${ma_hh}    ${ma_hh_sendo}
    Message mapping product success validation
    #
    Log    validate lstt
    ${list_audit_lk}   Create list audit trail for map product sendo    ${shop_sendo}  ${ma_hh}    ${ma_hh_sendo}
    Assert audit trail by time succeed    ${get_cur_date}   ${ma_hh}    Liên kết kênh bán    ${list_audit_lk}
    ${list_audit_db}     Create list audit trail for sync product      ${ma_hh}   ${gia_ban}     none
    Assert audit trail by time succeed   ${get_cur_date}    ${ma_hh}    Đồng bộ Sendo    ${list_audit_db}
    Delete product if product is visible thr API    ${ma_hh}

mapsdo9
    [Arguments]     ${shop_sendo}    ${ma_hh}   ${ma_qd}  ${ma_hh_up}    ${gtqd}
    ${list_pr}      Create List    ${ma_hh}     ${ma_hh_up}
    Delete list product if list product is visible thr API    ${list_pr}
    ${get_channel_id}  Get Sendo channel id thr API    ${shop_sendo}
    ${get_cur_date}     Get Current Date    result_format=%Y-%m-%d %H:%M:%S
    ${giaban_random}    Generate Random String      2     [NUMBERS]
    ${giaban1_random}    Generate Random String      2     [NUMBERS]
    ${ton}    Generate Random String      2     123456789
    ${ton_qd}    Devision and round    ${ton}      ${gtqd}
    ${gia_ban}    Set Variable    1${giaban_random}000
    ${gia_ban1}    Set Variable    1${giaban1_random}000
    Add product incl 1 unit thrAPI    ${ma_hh}    abc    Mỹ phẩm     ${gia_ban}   40000     ${ton}    cái    hộp    ${gtqd}    ${gia_ban1}    ${ma_qd}
    #
    Log    step ui
    Search product code and click update product    ${ma_hh}
    Wait Until Page Contains Element    ${textbox_ma_hh}      30s
    Input Text    ${textbox_ma_hh}    ${ma_hh_up}
    Click Element    ${button_luu}
    Wait Until Keyword Succeeds    3 times    1s    Update data success validation
    #
    Log    validate lstt
    ${list_audit_lk}   Create list audit trail for map product sendo    ${shop_sendo}  ${ma_hh_up}    ${ma_hh_up}
    Assert audit trail by time succeed    ${get_cur_date}   ${ma_hh_up}    Liên kết kênh bán    ${list_audit_lk}
    ${list_audit_db}     Create list audit trail for sync product      ${ma_hh}   ${gia_ban}     ${ton}
    Assert audit trail by time succeed   ${get_cur_date}    ${ma_hh_up}    Đồng bộ Sendo    ${list_audit_db}
    Delete list product if list product is visible thr API    ${list_pr}

mapsdo10
    [Arguments]     ${shop_sendo}     ${ma_hh}    ${ten_sp}    ${ten_nhom}     ${ma_hh_sendo}    ${ma_hh_up}
    ${list_pr}      Create List    ${ma_hh}     ${ma_hh_up}
    Delete list product if list product is visible thr API    ${list_pr}
    ${get_channel_id}  ${get_identitykey_id}     Get sendo channel id and identitykey id thr API    ${shop_sendo}
    ${get_cur_date}     Get Current Date    result_format=%Y-%m-%d %H:%M:%S
    ${giaban_random}    Generate Random String      2     [NUMBERS]
    ${ton}    Generate Random String      2     [NUMBERS]
    ${gia_ban}    Set Variable    1${giaban_random}000
    Add imei product thr API     ${ma_hh}    ${ten_sp}    ${ten_nhom}    ${gia_ban}
    Mapping product with sendo thr API     ${shop_sendo}      ${ma_hh_sendo}    ${ma_hh}
    #
    Log    step ui
    Search product code and click update product    ${ma_hh}
    Wait Until Page Contains Element    ${textbox_ma_hh}      30s
    Input Text    ${textbox_ma_hh}    ${ma_hh_up}
    Click Element    ${button_luu}
    Update data success validation
    Sleep    5s
    ${get_sku}    Get item sku sendo by kv product sku     ${shop_sendo}     ${ma_hh_up}
    Should Be Equal As Strings    ${get_sku}    ${ma_hh_sendo}
    Delete product if product is visible thr API    ${ma_hh}
