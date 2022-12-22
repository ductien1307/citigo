*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    ${headless_browser}
Test Setup        Before Test Quan ly
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
&{dict_sp}    TP022=1

*** Test Cases ***      Tên shop sendo      Mã hh         Tên sp          Nhóm hàng   Giá bán     Giá vốn   Tồn    Mã hh sendo
Lien ket hh o Thiet Lap
                        [Tags]      SDOH
                        [Template]    mapsdo1
                        [Timeout]     3 minutes
                        KiotViet           sdomap1       Test map sendo     Mỹ phẩm     115000      70000     30    bookvalue1HK431

Xoa lien ket            [Tags]      SDOH
                        [Template]    mapsdo2
                        [Timeout]     3 minutes
                        KiotViet           sdomap1       Test map sendo     Mỹ phẩm     125000      70000     40    bookvalue1HK431

Tu dong lien kiet       [Tags]      SDOH
                        [Template]    mapsdo3
                        [Timeout]     3 minutes
                        KiotViet           SD000002       Test sendo       Mỹ phẩm     95000         35

Thay doi gia - sl       [Tags]      SDOH
                        [Template]    mapsdo4
                        [Timeout]     3 minutes
                        KiotViet           025054       sdomap3       Test sendo       Mỹ phẩm     75000      70000     75      99000     110

Tao gd ban hang         [Tags]      SDOH
                        [Template]    mapsdo5
                        [Timeout]     3 minutes
                        KiotViet     ${dict_sp}    1000

Tao gd nhap hang        [Tags]      SDOH
                        [Template]    mapsdo6
                        [Timeout]     3 minutes
                        KiotViet     ${dict_sp}
*** Keywords ***
mapsdo1
    [Arguments]     ${shop_sendo}    ${ma_hh}    ${ten_sp}    ${ten_nhom}    ${gia_ban}    ${gia_von}    ${ton}    ${ma_hh_sendo}
    Set Selenium Speed    0.1
    Delete product if product is visible thr API    ${ma_hh}
    Add product thr API    ${ma_hh}    ${ten_sp}    ${ten_nhom}    ${gia_ban}    ${gia_von}    ${ton}
    Go to Sendo integration
    Open popup Lien ket hang hoa Sendo
    ${get_cur_date}     Get Current Date    result_format=%Y-%m-%d %H:%M:%S
    Wait Until Keyword Succeeds    3x    1s   Mapping product with Shopee      ${ma_hh}    ${ma_hh_sendo}
    Message mapping product success validation
    #
    Log    validate lstt
    ${list_audit_lk}   Create list audit trail for map product Sendo    ${shop_sendo}  ${ma_hh}    ${ma_hh_sendo}
    Assert audit trail by time succeed    ${get_cur_date}   ${ma_hh}    Liên kết kênh bán    ${list_audit_lk}
    ${list_audit_db}     Create list audit trail for sync product       ${ma_hh}   ${gia_ban}     ${ton}
    Assert audit trail by time succeed   ${get_cur_date}    ${ma_hh}    Đồng bộ Sendo    ${list_audit_db}
    Delete product thr API    ${ma_hh}

mapsdo2
    [Arguments]     ${shop_sendo}    ${ma_hh}    ${ten_sp}    ${ten_nhom}    ${gia_ban}    ${gia_von}    ${ton}    ${ma_hh_sendo}
    Set Selenium Speed    0.1
    ${get_cur_date}     Get Current Date    result_format=%Y-%m-%d %H:%M:%S
    Delete product if product is visible thr API    ${ma_hh}
    Add product thr API    ${ma_hh}    ${ten_sp}    ${ten_nhom}    ${gia_ban}    ${gia_von}    ${ton}
    Mapping product with Sendo thr API    ${shop_sendo}     ${ma_hh_sendo}    ${ma_hh}
    Go to Sendo integration
    Open popup Lien ket hang hoa Sendo
    Delete mapping product with Shopee or Lazada      ${ma_hh_sendo}
    Wait Until Keyword Succeeds    10 times   1s    Get audit trail no payment info and validate    ${ma_hh}    Liên kết kênh bán       Hủy
    Delete product thr API    ${ma_hh}

mapsdo3
    [Arguments]     ${shop_sendo}    ${ma_hh}    ${ten_sp}    ${ten_nhom}    ${gia_ban}      ${ton}
    Set Selenium Speed    0.1
    Delete product if product is visible thr API    ${ma_hh}
    Wait Until Keyword Succeeds    10 times    1s    Go To Danh Muc Hang Hoa
    Wait Until Keyword Succeeds    10 times    1s    Click DMHH
    Go to Them moi Hang Hoa
    Input data in Them hang hoa form    ${ma_hh}    ${ten_sp}    ${ten_nhom}    ${gia_ban}    none    ${ton}
    ${get_cur_date}     Get Current Date    result_format=%Y-%m-%d %H:%M:%S
    Click Element    ${button_luu}
    Product create success validation
    Log    validate lstt
    ${list_audit_lk}   Create list audit trail for map product sendo    ${shop_sendo}  ${ma_hh}    ${ma_hh}
    Assert audit trail by time succeed    ${get_cur_date}   ${ma_hh}    Liên kết kênh bán    ${list_audit_lk}
    ${list_audit_db}     Create list audit trail for sync product         ${ma_hh}   ${gia_ban}     ${ton}
    Assert audit trail by time succeed   ${get_cur_date}    ${ma_hh}    Đồng bộ Sendo    ${list_audit_db}
    Delete product thr API    ${ma_hh}

mapsdo4
    [Arguments]     ${shop_sendo}    ${ma_hh_sendo}    ${ma_hh}    ${ten_sp}    ${ten_nhom}    ${gia_ban}    ${gia_von}    ${ton}    ${gia_ban_up}    ${ton_up}
    Set Selenium Speed    0.1
    Delete product if product is visible thr API    ${ma_hh}
    Add product thr API    ${ma_hh}    ${ten_sp}    ${ten_nhom}    ${gia_ban}    ${gia_von}    ${ton}
    Mapping product with sendo thr API    ${shop_sendo}     ${ma_hh_sendo}    ${ma_hh}
    Wait Until Keyword Succeeds    10 times    1s    Go To Danh Muc Hang Hoa
    Wait Until Keyword Succeeds    10 times    1s    Click DMHH
    Search product code and click update product    ${ma_hh}
    Wait Until Page Contains Element    ${textbox_tonkho}      30s
    Input Text    ${textbox_hh_giaban}    ${gia_ban_up}
    Wait Until Keyword Succeeds    10x    1s    Input Text    ${textbox_tonkho}    ${ton_up}
    ${get_cur_date}     Get Current Date    result_format=%Y-%m-%d %H:%M:%S
    Wait Until Keyword Succeeds    3x    1s    Click Element     ${button_luu}
    Update data success validation
    Log    validate lstt
    ${list_audit_db}     Create list audit trail for sync product        ${ma_hh}   ${gia_ban_up}     ${ton_up}
    Assert audit trail by time succeed   ${get_cur_date}    ${ma_hh}    Đồng bộ Sendo    ${list_audit_db}
    Delete product thr API    ${ma_hh}

mapsdo5
    [Arguments]     ${shop_sendo}    ${dict_product}   ${input_khtt}
    ${list_product}     Get Dictionary Keys   ${dict_product}
    ${get_cur_date}     Get Current Date    result_format=%Y-%m-%d %H:%M:%S
    ${invoice_code}   Add new invoice without customer thr API    ${dict_product}   ${input_khtt}
    Sleep    3s
    ${get_onhand_af_ex}     Get onhand frm API    ${list_product[0]}
    ${get_onhand_af_ex}    Replace floating point    ${get_onhand_af_ex}
    ${list_audit_db}     Create list audit trail for sync product       ${list_product[0]}   none     ${get_onhand_af_ex}
    Assert audit trail by time succeed   ${get_cur_date}    ${list_product[0]}   Đồng bộ Sendo    ${list_audit_db}
    Delete invoice by invoice code    ${invoice_code}

mapsdo6
    [Arguments]     ${shop_sendo}    ${dict_product}
    ${list_product}     Get Dictionary Keys   ${dict_product}
    ${get_cur_date}     Get Current Date    result_format=%Y-%m-%d %H:%M:%S
    ${purchase_receipt_code}   Add new purchase receipt without supplier    ${dict_product}
    Sleep    3s
    ${get_onhand_af_ex}     Get onhand frm API    ${list_product[0]}
    ${get_onhand_af_ex}    Replace floating point    ${get_onhand_af_ex}
    ${list_audit_db}     Create list audit trail for sync product         ${list_product[0]}   none     ${get_onhand_af_ex}
    Assert audit trail by time succeed   ${get_cur_date}    ${list_product[0]}    Đồng bộ Sendo    ${list_audit_db}
    Delete purchase receipt code    ${purchase_receipt_code}
