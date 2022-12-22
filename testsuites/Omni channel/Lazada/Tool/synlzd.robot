*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    ${headless_browser}
Library           SeleniumLibrary
Resource          ../../../../core/Thiet_lap/thiet_lap_nav.robot
Resource          ../../../../core/Thiet_lap/thiet_lap_cuahang_list_action.robot
Resource          ../../../../core/API/api_thietlap.robot
Resource          ../../../../core/API/api_lazada.robot
Resource          ../../../../core/API/api_mhbh_dathang.robot
Resource          ../../../../core/API/api_hoadon_banhang.robot
Resource          ../../../../core/API/api_dathang.robot
Resource          ../../../../core/API/api_hanghoa.robot
Resource          ../../../../share/constants.robot
Resource          ../../../../prepare/Hang_hoa/Sources/hanghoa.robot
Resource          ../../../../core/hang_hoa/hang_hoa_add_action.robot
Resource          ../../../../core/hang_hoa/hang_hoa_add_page.robot
Resource          ../../../../core/hang_hoa/danh_muc_list_action.robot

*** Variables ***
&{dict_sp}     GHDCB003=85000     GHDDV003=90000     GHDT001=112000   GHDU004=65000
@{list_lzd1}     ready_to_ship
@{list_lzd2}     ready_to_ship   shipped
@{list_lzd3}     ready_to_ship   shipped    delivered
@{list_lzd4}     ready_to_ship   shipped    failed
@{list_lzd5}     ready_to_ship   shipped    INFO_ST_DOMESTIC_RETURN_WITH_LAST_MILE_3PL
@{list_lzd6}     ready_to_ship   shipped    INFO_ST_DOMESTIC_BACK_TO_SHIPPER

*** Test Cases ***      Tên shop lazada      SP - GB         Tên KH      SDT          Địa chỉ        Khu vực         Phường xã    Xóa KH
Update order            [Tags]         LZDO
                        [Template]    synlzd1
                        [Timeout]     30 minutes
                        TEST SELLER 3             ${dict_sp}         Hoa      098756    Hà Nội        Đống Đa         Yết Kiêu     ${list_lzd2}
                        TEST SELLER 3             ${dict_sp}         Hoa      098745    Hà Nội        Đống Đa         Yết Kiêu     ${list_lzd3}
                        TEST SELLER 3             ${dict_sp}         Hoa      065634    Hà Nội        Đống Đa         Yết Kiêu     ${list_lzd4}
                        TEST SELLER 3             ${dict_sp}         Hoa      098345    Hà Nội        Đống Đa         Yết Kiêu     ${list_lzd5}
                        TEST SELLER 3             ${dict_sp}         Hoa      098754    Hà Nội        Đống Đa         Yết Kiêu     ${list_lzd6}

*** Keywords ***
synlzd1
    [Arguments]     ${input_shop_lzd}     ${list_product_price}   ${ten_kh}   ${dien_thoai}    ${dia_chi}   ${khu_vuc}    ${phuong_xa}     ${list_trangthai_lzd}
    Log    xóa kh cũ
    Delete customer by phone number thr API      ${dien_thoai}
    #
    Log   check trạng thái đơn hàng, vận đơn
    ${result_trangthai_hoadon}       ${result_trangthai_vandon}      ${result_status_vandon}    Check status order and status delivery Lazada    ${list_trangthai_lzd}
    #
    Log    tính tồn kho af ex
    ${list_product}   Get Dictionary Keys     ${list_product_price}
    ${list_price}   Get Dictionary Values     ${list_product_price}
    ${list_onhand_af_ex}   Get list onhand frm API   ${list_product}
    ${get_list_product_type}    ${get_list_imei_status}      Get list product type and imei status frm API   ${list_product}
    ${list_result_onhand_af_ex}     Create List
    :FOR    ${item_pr_type}     ${item_imei_status}     ${item_ohand}     IN ZIP       ${get_list_product_type}   ${get_list_imei_status}    ${list_onhand_af_ex}
    \       ${result_onhand}      Minus    ${item_ohand}   1
    \       Run Keyword If    ${item_pr_type}==1 or ${item_pr_type}==3     Append To List    ${list_result_onhand_af_ex}    0     ELSE IF      '${item_imei_status}'=='True'      Append To List   ${list_result_onhand_af_ex}    ${item_ohand}      ELSE    Append To List   ${list_result_onhand_af_ex}    ${result_onhand}
    Log     ${list_result_onhand_af_ex}
    #
    Log    tính tổng tiền hàng
    ${result_tongtienhang}    Sum values in list    ${list_price}
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
    Wait Until Keyword Succeeds    10x    30s    Assert invoice exist succeed    ${ma_hd_kv}
    #
    Log    validate af ex
    Assert values by order code until succeed    ${ma_dh_kv}     ${ma_kh}    3   ${result_tongtienhang}    0    0
    Assert values by invoice code until succeed    ${ma_hd_kv}    ${result_tongtienhang}    ${result_tongtienhang}    ${ma_kh}    0    0    ${result_trangthai_hoadon}
    Assert delivery info by invoice code until succeed    ${ma_hd_kv}     LAZADA     ${ten_kh}${SPACE}    0    ${dia_chi}    ${khu_vuc}    ${phuong_xa}   ${result_status_vandon}   1
    Assert cong no khach hang until succeed   ${ma_kh}    ${result_tongtienhang}    ${result_tongtienhang}    ${result_tongtienhang}
    Assert list of Onhand after execute      ${list_product}    ${list_result_onhand_af_ex}
    #
    Delete invoice by invoice code    ${ma_hd_kv}
    Delete order frm Order code    ${ma_dh_kv}
    ${get_id_kh}   ${get_ma_kh}    Get customer id and code by number phone thr API   ${dien_thoai}
    Delete customer   ${get_id_kh}
