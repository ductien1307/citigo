*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    ${headless_browser}
Test Setup        Before Test Hang Hoa
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

*** Test Cases ***      Tên shop tiki        Mã hh         Tên sp       Nhóm hàng   Giá bán   Tồn    Mã hh tiki
Lien ket hh o DMHH tab cap nhat
                        [Tags]            TIKIH
                        [Template]    maphh7
                        [Timeout]     3 minutes
                        KiotViet              testtiki1       Test tiki     Mỹ phẩm     70000      25.56   TIKI01123

Lien ket hh o DMHH popup thao tac
                        [Tags]            TIKIH
                        [Template]    maphh8
                        [Timeout]     3 minutes
                        KiotViet              testtiki1       Test tiki     Mỹ phẩm     55000         TIKI01123

Cap nhat hh trung SKU chua co lien ket voi hang dvt
                        [Tags]            #TIKIH
                        [Template]    maphh9
                        [Timeout]     3 minutes
                        KiotViet      testqdtk      75000       10.2     testqdtk1        135000      410E123       4

Cap nhat hh trung SKU voi hang co lien ket
                        [Tags]            #TIKIH
                        [Template]    maphh10
                        [Timeout]     3 minutes
                        KiotViet           Testsp3        abcd   Mỹ phẩm     568888     59000     15     83284923959

*** Keywords ***
maphh7
    [Arguments]     ${shop_tiki}     ${ma_hh}    ${ten_sp}    ${ten_nhom}     ${gia_ban}    ${ton}    ${ma_hh_tiki}
    Delete product if product is visible thr API    ${ma_hh}
    ${get_channel_id}     Get Tiki channel id thr API   ${shop_tiki}
    ${get_cur_date}     Get Current Date    result_format=%Y-%m-%d %H:%M:%S
    Add product thr API    ${ma_hh}    ${ten_sp}    ${ten_nhom}    ${gia_ban}    30000    ${ton}
    #
    Log    step ui
    Search product code    ${ma_hh}
    Go to tab Lien ket kenh ban and click update
    Select channel Tiki        ${shop_tiki}
    Choose the associated product    ${get_channel_id}    ${ma_hh}    ${ma_hh_tiki}
    Message mapping product success validation
    #
    Log    validate lstt
    ${list_audit_lk}   Create list audit trail for map product Tiki    ${shop_tiki}  ${ma_hh}    ${ma_hh_tiki}
    Assert audit trail by time succeed    ${get_cur_date}   ${ma_hh}    Liên kết kênh bán    ${list_audit_lk}
    ${list_audit_db}     Create list audit trail for sync product       ${ma_hh}   ${gia_ban}     ${ton}
    Assert audit trail by time succeed   ${get_cur_date}    ${ma_hh}    Đồng bộ Tiki    ${list_audit_db}
    Delete product if product is visible thr API    ${ma_hh}

maphh8
    [Arguments]     ${shop_tiki}     ${ma_hh}    ${ten_sp}    ${ten_nhom}    ${gia_ban}    ${ma_hh_tiki}
    Delete product if product is visible thr API    ${ma_hh}
    ${get_channel_id}     Get tiki channel id thr API   ${shop_tiki}
    ${get_cur_date}     Get Current Date    result_format=%Y-%m-%d %H:%M:%S
    Add service    ${ma_hh}    ${ten_sp}    ${ten_nhom}    ${gia_ban}    30000
    #
    Log    step ui
    Search product code    ${ma_hh}
    Search and select product    ${ma_hh}
    Click Element    ${button_thaotac}
    Wait Until Keyword Succeeds    3x    1s      Click Element    ${button_lienket_kenhban}
    Select channel tiki    ${shop_tiki}
    Choose the associated product    ${get_channel_id}    ${ma_hh}    ${ma_hh_tiki}
    Message mapping product success validation
    #
    Log    validate lstt
    ${list_audit_lk}   Create list audit trail for map product Tiki    ${shop_tiki}  ${ma_hh}    ${ma_hh_tiki}
    Assert audit trail by time succeed    ${get_cur_date}   ${ma_hh}    Liên kết kênh bán    ${list_audit_lk}
    ${list_audit_db}     Create list audit trail for sync product      ${ma_hh}   ${gia_ban}     none
    Assert audit trail by time succeed   ${get_cur_date}    ${ma_hh}    Đồng bộ Tiki    ${list_audit_db}
    Delete product if product is visible thr API    ${ma_hh}

maphh9
    [Arguments]     ${shop_tiki}    ${ma_hh}   ${gia_ban}  ${ton}  ${ma_qd}    ${gia_ban1}  ${ma_hh_up}  ${gtqd}
    ${list_pr}      Create List    ${ma_hh}     ${ma_hh_up}
    Delete list product if list product is visible thr API    ${list_pr}
    ${get_channel_id}     Get Tiki channel id thr API    ${shop_tiki}
    ${get_cur_date}     Get Current Date    result_format=%Y-%m-%d %H:%M:%S
    ${ton_qd}    Devision and round    ${ton}      ${gtqd}
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
    ${list_audit_lk}   Create list audit trail for map product Tiki    ${shop_tiki}  ${ma_hh_up}    ${ma_hh_up}
    Assert audit trail by time succeed    ${get_cur_date}   ${ma_hh_up}    Liên kết kênh bán    ${list_audit_lk}
    ${list_audit_db}     Create list audit trail for sync product       ${ma_hh_up}   ${gia_ban}     ${ton}
    Assert audit trail by time succeed   ${get_cur_date}    ${ma_hh_up}    Đồng bộ Tiki    ${list_audit_db}
    Delete list product if list product is visible thr API    ${list_pr}

maphh10
    [Arguments]     ${shop_tiki}     ${ma_hh}    ${ten_sp}    ${ten_nhom}     ${ma_hh_Tiki}   ${gia_ban}      ${ton}   ${ma_hh_up}
    ${list_pr}      Create List    ${ma_hh}     ${ma_hh_up}
    Delete list product if list product is visible thr API    ${list_pr}
    ${get_channel_id}      Get Tiki channel id thr API    ${shop_tiki}
    ${get_cur_date}     Get Current Date    result_format=%Y-%m-%d %H:%M:%S
    Add imei product thr API     ${ma_hh}    ${ten_sp}    ${ten_nhom}    ${gia_ban}
    Mapping product with Tiki thr API     ${shop_tiki}      ${ma_hh_Tiki}    ${ma_hh}
    #
    Log    step ui
    Search product code and click update product    ${ma_hh}
    Wait Until Page Contains Element    ${textbox_ma_hh}      30s
    Input Text    ${textbox_ma_hh}    ${ma_hh_up}
    Click Element    ${button_luu}
    Wait Until Keyword Succeeds    3 times    1s    Update data success validation
    Sleep    5s
    ${get_sku}    Get item sku tiki by kv product sku     ${shop_tiki}     ${ma_hh_up}
    Should Be Equal As Strings    ${get_sku}    ${ma_hh_Tiki}
    Delete product if product is visible thr API    ${ma_hh}
