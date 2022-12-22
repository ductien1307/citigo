*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    ${headless_browser}
Test Setup        Before Test Quan ly
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

*** Test Cases ***      Tên shop tiki             Mã hh         Tên sp          Nhóm hàng   Giá bán     Giá vốn   Tồn    Mã hh tiki
Lien ket hh o Thiet Lap
                        [Tags]            TIKIH
                        [Template]    maphh1
                        [Timeout]     3 minutes
                        KiotViet     TIKIMAP       Test map tiki     Mỹ phẩm     115000      70000     30    MM1111

Xoa lien ket            [Tags]            TIKIH
                        [Template]    maphh2
                        [Timeout]     3 minutes
                        KiotViet     TIKIMAP1       Test map tiki     Mỹ phẩm     125000      70000     40    MM1111

Tu dong lien kiet       [Tags]            #TIKIH
                        [Template]    maphh3
                        [Timeout]     3 minutes
                        KiotViet     54654747MM       Test tiki       Mỹ phẩm     95000      70000     35

Thay doi gia - sl       [Tags]            TIKIH
                        [Template]    maphh4
                        [Timeout]     3 minutes
                        KiotViet     SKU01   TIKIMAP3       Test tiki       Mỹ phẩm     75000      70000     75      99000     110

Tao gd ban hang         [Tags]            TIKIH
                        [Template]    maphh5
                        [Timeout]     3 minutes
                        KiotViet     ${dict_sp}    1000

Tao gd nhap hang        [Tags]            TIKIH
                        [Template]    maphh6
                        [Timeout]     3 minutes
                        KiotViet     ${dict_sp}
*** Keywords ***
maphh1
    [Arguments]     ${shop_tiki}    ${ma_hh}    ${ten_sp}    ${ten_nhom}    ${gia_ban}    ${gia_von}    ${ton}    ${ma_hh_tiki}
    Set Selenium Speed    0.1
    Delete product if product is visible thr API    ${ma_hh}
    Add product thr API    ${ma_hh}    ${ten_sp}    ${ten_nhom}    ${gia_ban}    ${gia_von}    ${ton}
    Go to Tiki integration
    Open popup Lien ket hang hoa Tiki
    ${get_cur_date}     Get Current Date    result_format=%Y-%m-%d %H:%M:%S
    Wait Until Keyword Succeeds    3x    1s   Mapping product with Tiki    ${ma_hh}    ${ma_hh_tiki}
    Message mapping product success validation
    #
    Log    validate lstt
    ${list_audit_lk}   Create list audit trail for map product Tiki    ${shop_tiki}  ${ma_hh}    ${ma_hh_tiki}
    Assert audit trail by time succeed    ${get_cur_date}   ${ma_hh}    Liên kết kênh bán    ${list_audit_lk}
    ${list_audit_db}     Create list audit trail for sync product       ${ma_hh}   ${gia_ban}     ${ton}
    Assert audit trail by time succeed   ${get_cur_date}    ${ma_hh}    Đồng bộ Tiki    ${list_audit_db}
    Delete product thr API    ${ma_hh}

maphh2
    [Arguments]     ${shop_tiki}    ${ma_hh}    ${ten_sp}    ${ten_nhom}    ${gia_ban}    ${gia_von}    ${ton}    ${ma_hh_tiki}
    Set Selenium Speed    0.1
    ${get_cur_date}     Get Current Date    result_format=%Y-%m-%d %H:%M:%S
    Delete product if product is visible thr API    ${ma_hh}
    Add product thr API    ${ma_hh}    ${ten_sp}    ${ten_nhom}    ${gia_ban}    ${gia_von}    ${ton}
    Mapping product with tiki thr API    ${shop_tiki}     ${ma_hh_tiki}    ${ma_hh}
    Go to Tiki integration
    Open popup Lien ket hang hoa Tiki
    Delete mapping product with Tiki    ${ma_hh_tiki}
    Wait Until Keyword Succeeds    10 times   1s    Get audit trail no payment info and validate    ${ma_hh}    Liên kết kênh bán       Hủy
    Delete product thr API    ${ma_hh}

maphh3
    [Arguments]     ${shop_tiki}    ${ma_hh}    ${ten_sp}    ${ten_nhom}    ${gia_ban}    ${gia_von}    ${ton}
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
    ${list_audit_lk}   Create list audit trail for map product Tiki    ${shop_tiki}  ${ma_hh}    ${ma_hh}
    Assert audit trail by time succeed    ${get_cur_date}   ${ma_hh}    Liên kết kênh bán    ${list_audit_lk}
    ${list_audit_db}     Create list audit trail for sync product         ${ma_hh}   ${gia_ban}     ${ton}
    Assert audit trail by time succeed   ${get_cur_date}    ${ma_hh}    Đồng bộ Tiki    ${list_audit_db}
    Delete product thr API    ${ma_hh}

maphh4
    [Arguments]     ${shop_tiki}    ${ma_hh_tiki}    ${ma_hh}    ${ten_sp}    ${ten_nhom}    ${gia_ban}    ${gia_von}    ${ton}    ${gia_ban_up}    ${ton_up}
    Set Selenium Speed    0.1
    Delete product if product is visible thr API    ${ma_hh}
    Add product thr API    ${ma_hh}    ${ten_sp}    ${ten_nhom}    ${gia_ban}    ${gia_von}    ${ton}
    Mapping product with tiki thr API    ${shop_tiki}     ${ma_hh_tiki}    ${ma_hh}
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
    Assert audit trail by time succeed   ${get_cur_date}    ${ma_hh}    Đồng bộ Tiki    ${list_audit_db}
    Delete product thr API    ${ma_hh}

maphh5
    [Arguments]     ${shop_tiki}    ${dict_product}   ${input_khtt}
    ${list_product}     Get Dictionary Keys   ${dict_product}
    ${get_cur_date}     Get Current Date    result_format=%Y-%m-%d %H:%M:%S
    ${invoice_code}   Add new invoice without customer thr API    ${dict_product}   ${input_khtt}
    Sleep    3s
    ${get_onhand_af_ex}     Get onhand frm API    ${list_product[0]}
    ${get_onhand_af_ex}    Replace floating point    ${get_onhand_af_ex}
    ${list_audit_db}     Create list audit trail for sync product       ${list_product[0]}   none     ${get_onhand_af_ex}
    Assert audit trail by time succeed   ${get_cur_date}    ${list_product[0]}   Đồng bộ Tiki    ${list_audit_db}
    Delete invoice by invoice code    ${invoice_code}

maphh6
    [Arguments]     ${shop_tiki}    ${dict_product}
    ${list_product}     Get Dictionary Keys   ${dict_product}
    ${get_cur_date}     Get Current Date    result_format=%Y-%m-%d %H:%M:%S
    ${purchase_receipt_code}   Add new purchase receipt without supplier    ${dict_product}
    Sleep    3s
    ${get_onhand_af_ex}     Get onhand frm API    ${list_product[0]}
    ${get_onhand_af_ex}    Replace floating point    ${get_onhand_af_ex}
    ${list_audit_db}     Create list audit trail for sync product         ${list_product[0]}   none     ${get_onhand_af_ex}
    Assert audit trail by time succeed   ${get_cur_date}    ${list_product[0]}    Đồng bộ Tiki    ${list_audit_db}
    Delete purchase receipt code    ${purchase_receipt_code}
