*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    ${headless_browser}
Test Setup        Before Test QL Hoa Don
Test Teardown     After Test
Library           SeleniumLibrary
Resource          ../../../../core/Thiet_lap/thiet_lap_nav.robot
Resource          ../../../../core/Thiet_lap/thiet_lap_cuahang_list_action.robot
Resource          ../../../../core/API/api_thietlap.robot
Resource          ../../../../core/API/api_lazada.robot
Resource          ../../../../core/API/api_mhbh_dathang.robot
Resource          ../../../../core/API/api_danhmuc_hanghoa.robot
Resource          ../../../../core/API/api_hoadon_banhang.robot
Resource          ../../../../core/API/api_dathang.robot
Resource          ../../../../core/API/api_trahang.robot
Resource          ../../../../core/API/api_hanghoa.robot
Resource          ../../../../share/constants.robot
Resource          ../../../../prepare/Hang_hoa/Sources/hanghoa.robot
Resource          ../../../../core/Giao_dich/hoa_don_list_action.robot

*** Variables ***
@{list_lzd2}     ready_to_ship   shipped   failed
@{list_lzd1}     ready_to_ship   shipped

*** Test Cases ***      Tên shop lazada       SP          Giá bán       Tên KH      SDT          Địa chỉ        Khu vực         Phường xã    Trạng thái
Sync order lodate         [Tags]           LZDO
                        [Template]    sync_lazada7
                        [Timeout]     20 minutes
                        TEST SELLER 3         LDLZD01        SP1488216 AT3T        75000         Mai       0986344896      Hà Nội        Đống Đa        Xã Đàn    ${list_lzd1}
                        TEST SELLER 3         LDLZD02        GDGSMAR25-70     75000        Mai      0986367852       Hà Nội        Đống Đa          Xã Đàn    ${list_lzd2}


*** Keywords ***
sync_lazada7
    [Arguments]        ${input_shop_lzd}      ${ma_hh}     ${ma_hh_lzd}      ${gia_ban}   ${ten_kh}   ${dien_thoai}    ${dia_chi}   ${khu_vuc}    ${phuong_xa}   ${list_trangthai_lzd}
    Log   check trạng thái đơn hàng, vận đơn
    ${result_trangthai_hoadon}       ${result_trangthai_vandon}      ${result_status_vandon}    Check status order and status delivery Lazada    ${list_trangthai_lzd}
    #
    Delete product if product is visible thr API    ${ma_hh}
    Add lodate product thr API    ${ma_hh}    test sync lodate   Mỹ phẩm     55000
    Mapping product with lazada thr API    ${input_shop_lzd}     ${ma_hh_lzd}    ${ma_hh}
    Delete customer by phone number thr API      ${dien_thoai}
    ${list_product_price}     Create Dictionary    ${ma_hh}=${gia_ban}
    ${list_product}   Get Dictionary Keys     ${list_product_price}
    ${list_price}   Get Dictionary Values     ${list_product_price}
    ${list_result_onhand_af_ex}   Get list onhand frm API     ${list_product}
    ${tenlo_by_product}    Get lot name list and import lot for product    ${ma_hh}    1
    Sleep    20s
    #
    Log    tính tổng tiền hàng
    ${result_tongtienhang}      Set Variable    ${gia_ban}
    #
    Log    tạo đơn lazada và chuyển trạng thái
    ${list_sku}    Change price sku in lazada client thr API     ${input_shop_lzd}     ${list_product}     ${list_price}
    ${order_number}     Create order Lazada     ${list_sku}   ${ten_kh}   ${dien_thoai}    ${dia_chi}   ${khu_vuc}    ${phuong_xa}
    ${get_oder_id}    Get order id by order number thr API    ${order_number}
    ${ma_dh_kv}   Set Variable    DHLZD_${get_oder_id}
    ${ma_hd_kv}   Set Variable    HDLZD_${get_oder_id}.1
    ${ma_kh}      Set Variable    KHLZD${get_oder_id}
    Wait Until Keyword Succeeds    10x    30s    Assert order exist succeed    ${ma_dh_kv}
    :FOR      ${item_trangthai_lzd}   IN ZIP     ${list_trangthai_lzd}
    \     Update status order Lazada    ${order_number}    ${list_sku}    ${list_price}     ${ten_kh}   ${dien_thoai}    ${dia_chi}   ${khu_vuc}    ${phuong_xa}    ${item_trangthai_lzd}
    Wait Until Keyword Succeeds    15x    20s    Assert invoice omni succeed   ${ma_hd_kv}
    #
    Log    chọn lo
    Reload Page
    Open popup Sync Tiki, Lazada, Shopee and search invoice code      ${ma_hd_kv}
    Choose lo in popup Sync Tiki, Lazada, Shopee     ${tenlo_by_product[0]}
    ${get_cur_date}     Get Current Date    result_format=%Y-%m-%d %H:%M:%S
    Click Element    ${button_omni_dongbo_tungdon}
    Wait Until Keyword Succeeds    6x    20s    Assert invoice exist succeed   ${ma_hd_kv}
    #
    Log   validate af ex
    Assert values by order code until succeed    ${ma_dh_kv}    ${ma_kh}    3     ${result_tongtienhang}    0    0
    Assert values by invoice code until succeed    ${ma_hd_kv}    ${result_tongtienhang}    ${result_tongtienhang}    ${ma_kh}    0    0    ${result_trangthai_hoadon}
    Assert delivery info by invoice code until succeed     ${ma_hd_kv}    LAZADA    ${ten_kh}${SPACE}    0    ${dia_chi}    ${khu_vuc}    ${phuong_xa}    ${result_status_vandon}    1
    Assert Cong no khach hang until succeed   ${ma_kh}     ${result_tongtienhang}    ${result_tongtienhang}    ${result_tongtienhang}
    Assert list of Onhand after execute until succeed      ${list_product}    ${list_result_onhand_af_ex}
    #
    Delete invoice by invoice code    ${ma_hd_kv}
    Delete order frm Order code    ${ma_dh_kv}
    Delete customer by Customer Code    ${ma_kh}

sync_lazada8
    [Arguments]    ${input_shop_lzd}      ${ma_hh}     ${ma_hh_lzd}        ${gia_ban}   ${ten_kh}   ${dien_thoai}    ${dia_chi}   ${khu_vuc}    ${phuong_xa}   ${list_trangthai_lzd}
    #
    Delete product if product is visible thr API    ${ma_hh}
    Add lodate product thr API    ${ma_hh}    test sync lodate   Mỹ phẩm     55000
    Mapping product with lazada thr API    ${input_shop_lzd}     ${ma_hh_lzd}    ${ma_hh}
    Delete customer by phone number thr API      ${dien_thoai}
    ${list_product_price}     Create Dictionary    ${ma_hh}=${gia_ban}
    ${list_product}   Get Dictionary Keys     ${list_product_price}
    ${list_price}   Get Dictionary Values     ${list_product_price}
    ${list_result_onhand_af_ex}   Create List    1
    ${tenlo_by_product}    Get lot name list and import lot for product    ${ma_hh}    1
    Sleep    20s
    ${result_tongtienhang}      Sum values in list      ${list_price}
    #
    Log    tạo đơn lazada và chuyển trạng thái
    ${list_sku}    Change price sku in lazada client thr API     ${input_shop_lzd}     ${list_product}     ${list_price}
    ${order_number}     Create order Lazada     ${list_sku}   ${ten_kh}   ${dien_thoai}    ${dia_chi}   ${khu_vuc}    ${phuong_xa}
    Update status order Lazada    ${order_number}    ${list_sku}    ${list_price}     ${ten_kh}   ${dien_thoai}    ${dia_chi}   ${khu_vuc}    ${phuong_xa}    ready_to_ship
    ${get_oder_id}    Get order id by order number thr API    ${order_number}
    ${ma_dh_kv}   Set Variable    DHLZD_${get_oder_id}
    ${ma_hd_kv}   Set Variable    HDLZD_${get_oder_id}.1
    ${ma_kh}      Set Variable    KHLZD${get_oder_id}
    ${ma_th_kv}   Set Variable    CHHDLZD_${get_oder_id}.1
    Wait Until Keyword Succeeds    10x    30s    Assert order exist succeed    ${ma_dh_kv}
    Wait Until Keyword Succeeds    15x    20s    Assert invoice omni succeed   ${ma_hd_kv}
    #Get audit trail no payment info and validate    ${ma_hd_kv}    Đồng bộ Lazada    Đồng bộ hóa đơn
    #
    Log    chọn lô
    Reload Page
    Open popup Sync Tiki, Lazada, Shopee and search invoice code      ${ma_hd_kv}
    Choose lo in popup Sync Tiki, Lazada, Shopee     ${tenlo_by_product[0]}
    Click Element    ${button_omni_dongbo_tungdon}
    Wait Until Keyword Succeeds    6x    30s    Assert invoice exist succeed   ${ma_hd_kv}
    #
    Log    chuyển trạng thái
    :FOR      ${item_trangthai_lzd}   IN ZIP     ${list_trangthai_lzd}
    \     Update status order Lazada    ${order_number}    ${list_sku}    ${list_price}     ${ten_kh}   ${dien_thoai}    ${dia_chi}   ${khu_vuc}    ${phuong_xa}    ${item_trangthai_lzd}
    Wait Until Keyword Succeeds    10x    30s    Assert return exist succeed    ${ma_th_kv}
    #
    Log    validate af ex
    Assert values by order code until succeed    ${ma_dh_kv}     ${ma_kh}    3    ${result_tongtienhang}    0    0
    Assert values by invoice code until succeed    ${ma_hd_kv}    ${result_tongtienhang}    ${result_tongtienhang}    ${ma_kh}    0    0    Hoàn thành
    Assert delivery info by invoice code until succeed    ${ma_hd_kv}    LAZADA    ${ten_kh}${SPACE}    0    ${dia_chi}    ${khu_vuc}    ${phuong_xa}    5    1
    Assert values by return code until succeed    ${ma_th_kv}    ${result_tongtienhang}    0    0    ${result_tongtienhang}    0
    Assert Cong no khach hang until succeed     ${ma_kh}      0        ${result_tongtienhang}     0
    Assert list of Onhand after execute      ${list_product}    ${list_result_onhand_af_ex}
    #
    Log    assert LSTT
    ${ton}    Replace floating point    ${list_result_onhand_af_ex[0]}
    ${list_audit_db}     Create list audit trail for sync product       ${list_product[0]}   none     ${ton}
    #Assert audit trail by action name     ${list_product[0]}    Đồng bộ hàng hóa   ${list_audit_db[0]}
    #
    Delete invoice by invoice code    ${ma_hd_kv}
    Delete order frm Order code    ${ma_dh_kv}
    Delete customer by Customer Code    ${ma_kh}
    Delete product thr API    ${ma_hh}
