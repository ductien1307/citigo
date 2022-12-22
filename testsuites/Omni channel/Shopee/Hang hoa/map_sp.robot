*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    ${headless_browser}
Test Setup        Before Test Quan ly
Test Teardown     After Test
Library           SeleniumLibrary
Resource          ../../../../core/Thiet_lap/thiet_lap_nav.robot
Resource          ../../../../core/Thiet_lap/thiet_lap_cuahang_list_action.robot
Resource          ../../../../core/API/api_thietlap.robot
Resource          ../../../../core/API/api_shopee.robot
Resource          ../../../../core/API/api_mhbh.robot
Resource          ../../../../core/API/api_hanghoa.robot
Resource          ../../../../core/API/api_phieu_nhap_hang.robot
Resource          ../../../../share/constants.robot
Resource          ../../../../prepare/Hang_hoa/Sources/hanghoa.robot
Resource          ../../../../core/hang_hoa/hang_hoa_add_action.robot
Resource          ../../../../core/hang_hoa/hang_hoa_add_page.robot
Resource          ../../../../core/hang_hoa/danh_muc_list_action.robot
Resource          ../../../../core/Shopee_UAT/shopee_banhang_action.robot

*** Variables ***
&{dict_sp}    TPC005=1

*** Test Cases ***      Tên shop Shopee     Mật khẩu        Mã hh         Tên sp           Nhóm hàng    Giá bán    Mã hh Shopee
Lien ket hh o Thiet lap
                        [Tags]           SPEH
                        [Template]    mapsp1
                        [Timeout]     3 minutes
                        thanhptk            Shopee123       ShopeeMAP       Test map Shopee     Mỹ phẩm     70000      20007508

Xoa lien ket            [Tags]            SPEH
                        [Template]    mapsp2
                        [Timeout]     3 minutes
                        thanhptk         SPEMAP1       Shopee     Mỹ phẩm     125000      96000     40    AT00003

Tu dong lien kiet       [Tags]             SPEH
                        [Template]    mapsp3
                        [Timeout]     3 minutes
                        thanhptk         ABCDF001       Test Shopee       Mỹ phẩm     95000        35

Thay doi gia - sl       [Tags]             SPEH
                        [Template]    mapsp4
                        [Timeout]     3 minutes
                        thanhptk         AT00003         SPEMAP2       Test Shopee       Mỹ phẩm     95000      45000     75.54      99000     110

Tao gd ban hang         [Tags]             SPEH
                        [Template]    mapsp5
                        [Timeout]     3 minutes
                        thanhptk         ${dict_sp}    1000

Tao gd nhap hang        [Tags]             SPEH
                        [Template]    mapsp6
                        [Timeout]     3 minutes
                        thanhptk         ${dict_sp}

*** Keywords ***
mapsp1
    [Arguments]     ${shop_shopee}    ${mk_shopee}    ${ma_hh}    ${ten_sp}    ${ten_nhom}     ${gia_von}    ${ma_hh_shopee}
    Delete product if product is visible thr API    ${ma_hh}
    ${get_cur_date}     Get Current Date    result_format=%Y-%m-%d %H:%M:%S
    ${giaban_random}    Generate Random String      2     123456789
    ${ton}    Generate Random String      2     123456789
    ${gia_ban}    Set Variable    1${giaban_random}000
    Add product thr API    ${ma_hh}    ${ten_sp}    ${ten_nhom}    ${gia_ban}    ${gia_von}    ${ton}
    Go to Shopee integration
    Open popup Lien ket hang hoa Shopee
    Mapping product with Shopee    ${ma_hh}    ${ma_hh_shopee}
    Wait Until Page Contains Element    ${toast_message}      1 min
    Element Should Contain    ${toast_message}    Liên kết hàng thành công
    #
    Log    validate lstt
    ${list_audit_lk}   Create list audit trail for map product Shopee    ${shop_shopee}  ${ma_hh}    ${ma_hh_shopee}
    Assert audit trail by time succeed    ${get_cur_date}   ${ma_hh}    Liên kết kênh bán    ${list_audit_lk}
    ${list_audit_db}     Create list audit trail for sync product      ${ma_hh}   ${gia_ban}     ${ton}
    Assert audit trail by time succeed   ${get_cur_date}    ${ma_hh}    Đồng bộ Shopee    ${list_audit_db}
    #
    Log    assert UI shopee UAT
    Assert Gia ban, kho hang in Shopee UAT     ${shop_shopee}    ${mk_shopee}    ${ma_hh_shopee}     ${gia_ban}    ${ton}
    #
    Delete product thr API    ${ma_hh}

mapsp2
    [Arguments]     ${shop_shopee}    ${ma_hh}    ${ten_sp}    ${ten_nhom}    ${gia_ban}    ${gia_von}    ${ton}    ${ma_hh_shopee}
    Set Selenium Speed    0.1
    ${get_cur_date}     Get Current Date    result_format=%Y-%m-%d %H:%M:%S
    Delete product if product is visible thr API    ${ma_hh}
    Add product thr API    ${ma_hh}    ${ten_sp}    ${ten_nhom}    ${gia_ban}    ${gia_von}    ${ton}
    Mapping product with Shopee thr API    ${shop_shopee}     ${ma_hh_shopee}    ${ma_hh}
    Go to Shopee integration
    Open popup Lien ket hang hoa Shopee
    Delete mapping product with Shopee or Lazada       ${ma_hh_shopee}
    Wait Until Keyword Succeeds    10x    1s     Get audit trail no payment info and validate    ${ma_hh}    Liên kết kênh bán       Hủy
    Delete product thr API    ${ma_hh}

mapsp3
    [Arguments]     ${shop_shopee}    ${ma_hh}    ${ten_sp}    ${ten_nhom}    ${gia_ban}    ${ton}
    Set Selenium Speed    0.1
    Delete product if product is visible thr API    ${ma_hh}
    Wait Until Keyword Succeeds    3 times    5s    Go To Danh Muc Hang Hoa
    Wait Until Keyword Succeeds    3 times    5s    Click DMHH
    Go to Them moi Hang Hoa
    Input data in Them hang hoa form    ${ma_hh}    ${ten_sp}    ${ten_nhom}    ${gia_ban}    none    ${ton}
    ${get_cur_date}     Get Current Date    result_format=%Y-%m-%d %H:%M:%S
    Click Element    ${button_luu}
    Product create success validation
    #
    Log    validate lstt
    ${list_audit_lk}   Create list audit trail for map product Shopee    ${shop_shopee}  ${ma_hh}    ${ma_hh}
    Assert audit trail by time succeed    ${get_cur_date}   ${ma_hh}    Liên kết kênh bán    ${list_audit_lk}
    ${list_audit_db}     Create list audit trail for sync product      ${ma_hh}   ${gia_ban}     ${ton}
    Assert audit trail by time succeed   ${get_cur_date}    ${ma_hh}    Đồng bộ Shopee    ${list_audit_db}
    Delete product thr API    ${ma_hh}

mapsp4
    [Arguments]     ${shop_shopee}    ${ma_hh_shopee}    ${ma_hh}    ${ten_sp}    ${ten_nhom}    ${gia_ban}    ${gia_von}    ${ton}    ${gia_ban_up}    ${ton_up}
    Set Selenium Speed    0.1
    Delete product if product is visible thr API         ${ma_hh}
    Add product thr API    ${ma_hh}    ${ten_sp}    ${ten_nhom}    ${gia_ban}    ${gia_von}    ${ton}
    Mapping product with Shopee thr API    ${shop_shopee}     ${ma_hh_shopee}    ${ma_hh}
    Wait Until Keyword Succeeds    3 times    5s    Go To Danh Muc Hang Hoa
    Wait Until Keyword Succeeds    3 times    5s    Click DMHH
    Search product code and click update product    ${ma_hh}
    Wait Until Page Contains Element    ${textbox_tonkho}      30s
    Input Text    ${textbox_hh_giaban}    ${gia_ban_up}
    Wait Until Keyword Succeeds    4x    2s     Input Text    ${textbox_tonkho}    ${ton_up}
    ${get_cur_date}     Get Current Date    result_format=%Y-%m-%d %H:%M:%S
    Wait Until Keyword Succeeds    3x    2s    Click Element     ${button_luu}
    Update data success validation
    #
    Log    validate lstt
    ${list_audit_db}     Create list audit trail for sync product      ${ma_hh}   ${gia_ban_up}     ${ton_up}
    Assert audit trail by time succeed   ${get_cur_date}    ${ma_hh}    Đồng bộ Shopee    ${list_audit_db}
    Delete product thr API    ${ma_hh}

mapsp5
    [Arguments]     ${shop_shopee}    ${dict_product}   ${input_khtt}
    ${list_product}     Get Dictionary Keys   ${dict_product}
    ${get_cur_date}     Get Current Date    result_format=%Y-%m-%d %H:%M:%S
    ${invoice_code}   Add new invoice without customer thr API    ${dict_product}   ${input_khtt}
    Sleep    5s
    ${get_onhand_af_ex}     Get onhand frm API    ${list_product[0]}
    ${get_onhand_af_ex}    Replace floating point    ${get_onhand_af_ex}
    #
    Log    validate lstt
    ${list_audit_db}     Create list audit trail for sync product      ${list_product[0]}   none     ${get_onhand_af_ex}
    Assert audit trail by time succeed   ${get_cur_date}    ${list_product[0]}    Đồng bộ Shopee    ${list_audit_db}
    Delete invoice by invoice code    ${invoice_code}

mapsp6
    [Arguments]     ${shop_shopee}    ${dict_product}
    Set Selenium Speed    0.1
    ${list_product}     Get Dictionary Keys   ${dict_product}
    ${purchase_receipt_code}   Add new purchase receipt without supplier    ${dict_product}
    ${get_cur_date}     Get Current Date    result_format=%Y-%m-%d %H:%M:%S
    Sleep    5s
    ${get_onhand_af_ex}     Get onhand frm API    ${list_product[0]}
    ${get_onhand_af_ex}    Replace floating point    ${get_onhand_af_ex}
    #
    Log    validate lstt
    ${list_audit_db}     Create list audit trail for sync product      ${list_product[0]}  none     ${get_onhand_af_ex}
    Assert audit trail by time succeed   ${get_cur_date}   ${list_product[0]}    Đồng bộ Shopee    ${list_audit_db}
    Delete purchase receipt code    ${purchase_receipt_code}
