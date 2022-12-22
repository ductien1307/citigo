*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    ${headless_browser}
Test Setup        Before Test Quan ly
Test Teardown     After Test
Library           SeleniumLibrary
Resource          ../../../../core/Thiet_lap/thiet_lap_nav.robot
Resource          ../../../../core/Thiet_lap/thiet_lap_cuahang_list_action.robot
Resource          ../../../../core/API/api_thietlap.robot
Resource          ../../../../core/API/api_lazada.robot
Resource          ../../../../share/constants.robot
Resource          ../../../../prepare/Hang_hoa/Sources/hanghoa.robot
Resource          ../../../../core/hang_hoa/hang_hoa_add_action.robot
Resource          ../../../../core/hang_hoa/hang_hoa_add_page.robot
Resource          ../../../../core/hang_hoa/danh_muc_list_action.robot

*** Variables ***
&{dict_sp}    TPG05=1

*** Test Cases ***      Tên shop lazada   Mã hh   Tên sp   Nhóm hàng   Giá bán   Giá vốn   Tồn   Mã hh lazada
Lien ket hh o Thiet lap
                        [Tags]              LZDH   CTP
                        [Template]          maplzd1
                        [Timeout]           4 minutes
                        [Documentation]     MHQL - LIÊN KẾT HÀNG HÓA KV VỚI HÀNG HÓA LAZADA Ở THIẾT LẬP
                        KiotViet   LZDMAP   Test map lazada   Mỹ phẩm   122000   70000   30   XP-350B

Xoa lien ket            [Tags]         LZDH
                        [Template]    maplzd2
                        [Timeout]     3 minutes
                        KiotViet              LZDMAP       Test map lazada     Mỹ phẩm     125000      70000     40     XP-350B

Tu dong lien kiet       [Tags]         LZDH
                        [Template]    maplzd3
                        [Timeout]     3 minutes
                        KiotViet                 SP000134       Test lazada       Mỹ phẩm     95000      35

Thay doi gia - sl       [Tags]         LZDH
                        [Template]    maplzd4
                        [Timeout]     3 minutes
                        KiotViet              XP-350B       LZDMAP       Test lazada       Mỹ phẩm     75000      70000     75      99000     110

Tao gd ban hang         [Tags]         LZDH
                        [Template]    maplzd5
                        [Timeout]     3 minutes
                        KiotViet       ${dict_sp}    1000

Tao gd nhap hang        [Tags]         LZDH
                        [Template]    maplzd6
                        [Timeout]     3 minutes
                        KiotViet     ${dict_sp}

*** Keywords ***
maplzd1
    [Arguments]     ${shop_lazada}    ${ma_hh}    ${ten_sp}    ${ten_nhom}    ${gia_ban}    ${gia_von}    ${ton}    ${ma_hh_lazada}
    Set Selenium Speed    0.1
    ${get_cur_date}     Get Current Date    result_format=%Y-%m-%d %H:%M:%S
    ${get_pr_id}    Get product ID    ${ma_hh}
    Run Keyword If    '${get_pr_id}'=='0'    Log    Ignore pr    ELSE       Delete product thr API    ${ma_hh}
    Add product thr API    ${ma_hh}    ${ten_sp}    ${ten_nhom}    ${gia_ban}    ${gia_von}    ${ton}
    Wait Until Keyword Succeeds    3x    1s     Go to lazada integration
    Open popup Lien ket hang hoa Lazada    ${shop_lazada}
    Mapping product with Shopee      ${ma_hh}    ${ma_hh_lazada}
    Message mapping product success validation
    Log    validate lstt
    ${list_audit_lk}   Create list audit trail for map product Lazada    ${shop_lazada}  ${ma_hh}    ${ma_hh_lazada}
    Assert audit trail by time succeed    ${get_cur_date}   ${ma_hh}    Liên kết kênh bán    ${list_audit_lk}
    ${list_audit_db}     Create list audit trail for sync product      ${ma_hh}   ${gia_ban}     ${ton}
    Assert audit trail by time succeed   ${get_cur_date}    ${ma_hh}    Đồng bộ Lazada    ${list_audit_db}
    Delete product mapping Lazada thr API    ${shop_lazada}    ${ma_hh}
    [Teardown]    Delete product thr API    ${ma_hh}

maplzd2
    [Arguments]     ${shop_lazada}    ${ma_hh}    ${ten_sp}    ${ten_nhom}    ${gia_ban}    ${gia_von}    ${ton}    ${ma_hh_lazada}
    Set Selenium Speed    0.1
    ${get_cur_date}     Get Current Date    result_format=%Y-%m-%d %H:%M:%S
    ${get_pr_id}    Get product ID    ${ma_hh}
    Run Keyword If    '${get_pr_id}'=='0'    Log    Ignore pr    ELSE       Delete product thr API    ${ma_hh}
    Add product thr API    ${ma_hh}    ${ten_sp}    ${ten_nhom}    ${gia_ban}    ${gia_von}    ${ton}
    Mapping product with lazada thr API    ${shop_lazada}     ${ma_hh_lazada}    ${ma_hh}
    Wait Until Keyword Succeeds    3x    1s    Go to lazada integration
    Open popup Lien ket hang hoa Lazada    ${shop_lazada}
    Delete mapping product with Shopee or Lazada      ${ma_hh_lazada}
    Sleep    2s
    Get audit trail no payment info and validate    ${ma_hh}    Liên kết kênh bán       Hủy
    Delete product thr API    ${ma_hh}

maplzd3
    [Arguments]     ${shop_lazada}    ${ma_hh}    ${ten_sp}    ${ten_nhom}    ${gia_ban}      ${ton}
    Set Selenium Speed    0.1
    ${get_pr_id}    Get product ID    ${ma_hh}
    Run Keyword If    '${get_pr_id}'=='0'    Log    Ignore pr    ELSE       Delete product thr API    ${ma_hh}
    Wait Until Keyword Succeeds    3 times    5s    Go To Danh Muc Hang Hoa
    Wait Until Keyword Succeeds    3 times    5s    Click DMHH
    Go to Them moi Hang Hoa
    Input data in Them hang hoa form    ${ma_hh}    ${ten_sp}    ${ten_nhom}    ${gia_ban}    none    ${ton}
    ${get_cur_date}     Get Current Date    result_format=%Y-%m-%d %H:%M:%S
    Click Element    ${button_luu}
    Product create success validation
    Log    validate lstt
    ${list_audit_lk}   Create list audit trail for map product Lazada    ${shop_lazada}  ${ma_hh}    ${ma_hh}
    Assert audit trail by time succeed    ${get_cur_date}   ${ma_hh}    Liên kết kênh bán    ${list_audit_lk}
    ${list_audit_db}     Create list audit trail for sync product         ${ma_hh}   ${gia_ban}     ${ton}
    Assert audit trail by time succeed   ${get_cur_date}    ${ma_hh}    Đồng bộ Lazada    ${list_audit_db}
    Delete product thr API    ${ma_hh}

maplzd4
    [Arguments]     ${shop_lazada}    ${ma_hh_lazada}    ${ma_hh}    ${ten_sp}    ${ten_nhom}    ${gia_ban}    ${gia_von}    ${ton}    ${gia_ban_up}    ${ton_up}
    Set Selenium Speed    0.1
    ${get_pr_id}    Get product ID    ${ma_hh}
    Run Keyword If    '${get_pr_id}'=='0'    Log    Ignore pr    ELSE       Delete product thr API    ${ma_hh}
    Add product thr API    ${ma_hh}    ${ten_sp}    ${ten_nhom}    ${gia_ban}    ${gia_von}    ${ton}
    Mapping product with Lazada thr API    ${shop_lazada}     ${ma_hh_lazada}    ${ma_hh}
    Wait Until Keyword Succeeds    10 times    1s    Go To Danh Muc Hang Hoa
    Wait Until Keyword Succeeds    10 times    1s    Click DMHH
    Search product code and click update product    ${ma_hh}
    Wait Until Page Contains Element    ${textbox_tonkho}      30s
    Input Text    ${textbox_hh_giaban}    ${gia_ban_up}
    Input Text    ${textbox_tonkho}    ${ton_up}
    ${get_cur_date}     Get Current Date    result_format=%Y-%m-%d %H:%M:%S
    Wait Until Keyword Succeeds    3x    2s    Click Element     ${button_luu}
    Update data success validation
    ${list_audit_db}     Create list audit trail for sync product       ${ma_hh}   ${gia_ban_up}     ${ton_up}
    Assert audit trail by time succeed   ${get_cur_date}    ${ma_hh}    Đồng bộ Lazada    ${list_audit_db}
    Delete product thr API    ${ma_hh}

maplzd5
    [Arguments]     ${shop_lazada}    ${dict_product}   ${input_khtt}
    Set Selenium Speed    0.1
    ${list_product}     Get Dictionary Keys   ${dict_product}
    ${get_cur_date}     Get Current Date    result_format=%Y-%m-%d %H:%M:%S
    ${invoice_code}   Add new invoice without customer thr API    ${dict_product}   ${input_khtt}
    Sleep    3s
    ${get_onhand_af_ex}     Get onhand frm API    ${list_product[0]}
    ${get_onhand_af_ex}    Replace floating point    ${get_onhand_af_ex}
    ${list_audit_db}     Create list audit trail for sync product       ${list_product[0]}   none     ${get_onhand_af_ex}
    Assert audit trail by time succeed   ${get_cur_date}    ${list_product[0]}     Đồng bộ Lazada    ${list_audit_db}
    Delete invoice by invoice code    ${invoice_code}

maplzd6
    [Arguments]     ${shop_lazada}    ${dict_product}
    Set Selenium Speed    0.1
    ${list_product}     Get Dictionary Keys   ${dict_product}
    ${get_cur_date}     Get Current Date    result_format=%Y-%m-%d %H:%M:%S
    ${purchase_receipt_code}   Add new purchase receipt without supplier    ${dict_product}
    Sleep    3s
    ${get_onhand_af_ex}     Get onhand frm API    ${list_product[0]}
    ${get_onhand_af_ex}    Replace floating point    ${get_onhand_af_ex}
    ${list_audit_db}     Create list audit trail for sync product        ${list_product[0]}   none     ${get_onhand_af_ex}
    Assert audit trail by time succeed   ${get_cur_date}    ${list_product[0]}     Đồng bộ Lazada    ${list_audit_db}
    Delete purchase receipt code    ${purchase_receipt_code}
