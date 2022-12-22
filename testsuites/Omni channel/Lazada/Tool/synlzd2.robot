*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    ${headless_browser}
Test Setup        Before Test QL Hoa Don
Test Teardown     After Test
Resource          ../../../../core/Thiet_lap/thiet_lap_nav.robot
Resource          ../../../../core/Thiet_lap/thiet_lap_cuahang_list_action.robot
Resource          ../../../../core/API/api_thietlap.robot
Resource          ../../../../core/API/api_lazada.robot
Resource          ../../../../core/API/api_mhbh_dathang.robot
Resource          ../../../../core/API/api_hoadon_banhang.robot
Resource          ../../../../core/API/api_dathang.robot
Resource          ../../../../core/API/api_hanghoa.robot
Resource          ../../../../core/API/api_trahang.robot
Resource          ../../../../share/constants.robot
Resource          ../../../../prepare/Hang_hoa/Sources/hanghoa.robot
Resource          ../../../../core/hang_hoa/hang_hoa_add_action.robot
Resource          ../../../../core/hang_hoa/hang_hoa_add_page.robot
Resource          ../../../../core/hang_hoa/danh_muc_list_action.robot
Resource          ../../../../core/Giao_dich/hoa_don_list_action.robot

*** Variables ***
&{dict_sp}    GHDI005=80000      GHDI006=65000
@{list_lzd2}     ready_to_ship   shipped   failed
@{list_lzd1}     ready_to_ship   shipped

*** Test Cases ***      Tên shop lazada      SP - GB         Tên KH      SDT          Địa chỉ        Khu vực         Phường xã    Trạng thái
Sync imei               [Tags]           LZDO
                        [Template]    synlzd5
                        [Timeout]     20 minutes
                        TEST SELLER 3             ${dict_sp}         Mai      0986367896    Hà Nội        Đống Đa           Xã Đàn    ${list_lzd1}
                        TEST SELLER 3             ${dict_sp}         Hoa      0986547865    Hà Nội        Đống Đa           Xã Đàn     ${list_lzd2}

*** Keywords ***
synlzd5
    [Arguments]    ${input_shop_lzd}     ${list_product_price}   ${ten_kh}   ${dien_thoai}    ${dia_chi}   ${khu_vuc}    ${phuong_xa}   ${list_trangthai_lzd}
    Log    xóa kh cũ
    Delete customer by phone number thr API      ${dien_thoai}
    #
    Log   check trạng thái đơn hàng, vận đơn
    ${result_trangthai_hoadon}       ${result_trangthai_vandon}      ${result_status_vandon}    Check status order and status delivery Lazada    ${list_trangthai_lzd}
    #
    Log    tính tổng tiền hàng
    ${list_product}   Get Dictionary Keys     ${list_product_price}
    ${list_price}   Get Dictionary Values     ${list_product_price}
    ${list_nums}    Create List
    #${list_onhand_bf_ex}    Get list of Onhand by Product Code     ${list_product}
    ${list_result_onhand_af_ex}   Get list of Onhand by Product Code     ${list_product}
    :FOR    ${item_pr}   IN ZIP      ${list_product}
    \     Append To List      ${list_nums}   1
    #${list_result_onhand_af_ex}     Create List
    #:FOR    ${item_pr}     ${item_onhand}    IN ZIP      ${list_product}      ${list_onhand_bf_ex}
    #\     ${result_onhand}      Sum     ${item_onhand}      1
    #\     Append To List      ${list_nums}      1
    #\     Append To List      ${list_result_onhand_af_ex}     ${result_onhand}
    #Log     ${list_result_onhand_af_ex}
    Create list imei and other product    ${list_product}     ${list_nums}
    Sleep    25s
    ${result_tongtienhang}      Sum values in list      ${list_price}
    ${list_order_summary}    Get list order summary frm product API    ${list_product}
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
    #Get audit trail no payment info and validate    ${ma_hd_kv}    Đồng bộ Lazada    Đồng bộ hóa đơn
    #
    Log    chọn imei
    Reload Page
    Open popup Sync Tiki, Lazada, Shopee and search invoice code    ${ma_hd_kv}
    Choose imei in popup Sync Tiki, Lazada, Shopee    ${list_product}    ${imei_inlist}
    Click Element    ${button_omni_dongbo_tungdon}
    Wait Until Keyword Succeeds    6x    20s    Assert invoice exist succeed   ${ma_hd_kv}
    #
    Log    validate af ex
    Assert values by order code until succeed    ${ma_dh_kv}    ${ma_kh}    3     ${result_tongtienhang}    0    0
    Assert values by invoice code until succeed    ${ma_hd_kv}    ${result_tongtienhang}    ${result_tongtienhang}    ${ma_kh}    0    0    ${result_trangthai_hoadon}
    Assert delivery info by invoice code until succeed     ${ma_hd_kv}    LAZADA    ${ten_kh}${SPACE}    0    ${dia_chi}    ${khu_vuc}    ${phuong_xa}    ${result_status_vandon}    1
    Assert Cong no khach hang until succeed   ${ma_kh}     ${result_tongtienhang}    ${result_tongtienhang}    ${result_tongtienhang}
    Assert list of Onhand after execute until succeed      ${list_product}    ${list_result_onhand_af_ex}
    #
    Log    assert LSTT
    ${ton}    Replace floating point    ${list_result_onhand_af_ex[0]}
    ${list_audit_db}     Create list audit trail for sync product         ${list_product[0]}   none     ${ton}
    #Assert audit trail by time succeed   ${get_cur_date}    ${list_product[0]}    Đồng bộ hàng hóa    ${list_audit_db}
    #
    Delete invoice by invoice code    ${ma_hd_kv}
    Delete order frm Order code    ${ma_dh_kv}
    ${get_id_kh}   ${get_ma_kh}    Get customer id and code by number phone thr API   ${dien_thoai}
    Delete customer   ${get_id_kh}
