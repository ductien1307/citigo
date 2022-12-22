*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    ${headless_browser}
Library           SeleniumLibrary
Resource          ../../../../core/Thiet_lap/thiet_lap_nav.robot
Resource          ../../../../core/Thiet_lap/thiet_lap_cuahang_list_action.robot
Resource          ../../../../core/API/api_thietlap.robot
Resource          ../../../../core/API/api_tiki.robot
Resource          ../../../../core/API/api_mhbh_dathang.robot
Resource          ../../../../core/API/api_hoadon_banhang.robot
Resource          ../../../../core/API/api_dathang.robot
Resource          ../../../../core/API/api_trahang.robot
Resource          ../../../../core/API/api_hanghoa.robot
Resource          ../../../../share/constants.robot
Resource          ../../../prepare/Hang_hoa/Sources/hanghoa.robot

*** Variables ***
&{list_prs_num}        GHDCB001=3     GHDDV001=2     GHDT011=1   GHDU001=2
@{list_giaban}        75000     112000      55000       90000
@{list_gg}          14000       16000         0        10000
@{list_point}          2000       4000         0        10000
@{list_tiki1}    picking     packaging
@{list_tiki2}    picking     packaging    finished_packing
@{list_tiki3}    picking     packaging    finished_packing      ready_to_ship
@{list_tiki4}    picking     packaging    finished_packing      ready_to_ship     shipping
@{list_tiki5}    picking     packaging    finished_packing      ready_to_ship      handover_to_partner
@{list_tiki6}    picking     packaging    finished_packing      ready_to_ship     successful_delivery
@{list_tiki7}    picking     packaging    finished_packing      ready_to_ship     successful_delivery   complete
@{list_tiki8}    picking     packaging    finished_packing      ready_to_ship      shipping    returned
@{list_tiki9}    picking     packaging    finished_packing      ready_to_ship      handover_to_partner    returned

*** Test Cases ***       Tên shop tiki        SP - SL               Giá bán             Giảm gía       Point             Tên KH        Địa chỉ           Thành phố     Khu vực         Phường xã             Điện thoại    Trạng thái
Update order            [Tags]            TIKIO
                        [Template]    sync_tiki2
                        [Timeout]     40 minutes
                        #KiotViet            ${list_prs_num}       ${list_giaban}     ${list_gg}         ${list_point}     Test kh tiki      1B Yết Kiêu     Hà Nội     Quận Hoàn Kiếm    Phường Trần Hưng Đạo     none    ${list_tiki1}
                        #KiotViet            ${list_prs_num}       ${list_giaban}     ${list_gg}         ${list_point}     Test kh tiki      1B Yết Kiêu     Hà Nội     Quận Hoàn Kiếm    Phường Trần Hưng Đạo     none    ${list_tiki2}
                        #KiotViet            ${list_prs_num}       ${list_giaban}     ${list_gg}         ${list_point}     Test kh tiki      1B Yết Kiêu     Hà Nội     Quận Hoàn Kiếm    Phường Trần Hưng Đạo     none    ${list_tiki3}
                        KiotViet            ${list_prs_num}       ${list_giaban}     ${list_gg}         ${list_point}     Test kh tiki      1B Yết Kiêu     Hà Nội     Quận Hoàn Kiếm    Phường Trần Hưng Đạo     none    ${list_tiki4}
                        KiotViet            ${list_prs_num}       ${list_giaban}     ${list_gg}         ${list_point}     Test kh tiki      1B Yết Kiêu     Hà Nội     Quận Hoàn Kiếm    Phường Trần Hưng Đạo     none    ${list_tiki5}
                        KiotViet            ${list_prs_num}       ${list_giaban}     ${list_gg}         ${list_point}     Test kh tiki      1B Yết Kiêu     Hà Nội     Quận Hoàn Kiếm    Phường Trần Hưng Đạo     none    ${list_tiki6}
                        KiotViet            ${list_prs_num}       ${list_giaban}     ${list_gg}         ${list_point}     Test kh tiki      1B Yết Kiêu     Hà Nội     Quận Hoàn Kiếm    Phường Trần Hưng Đạo     none    ${list_tiki7}
                        KiotViet            ${list_prs_num}       ${list_giaban}     ${list_gg}         ${list_point}     Test kh tiki      1B Yết Kiêu     Hà Nội     Quận Hoàn Kiếm    Phường Trần Hưng Đạo     none    ${list_tiki8}
                        KiotViet            ${list_prs_num}       ${list_giaban}     ${list_gg}         ${list_point}     Test kh tiki      1B Yết Kiêu     Hà Nội     Quận Hoàn Kiếm    Phường Trần Hưng Đạo     none    ${list_tiki9}


*** Keywords ***
sync_tiki2
    [Arguments]    ${input_shop_tiki}     ${list_product_num}       ${list_price}     ${list_discount}      ${list_discount_point}   ${ten_kh}     ${dia_chi}    ${thanh_pho}      ${khu_vuc}      ${phuong_xa}    ${dien_thoai}     ${list_trangthai_tiki}
    Log   check trạng thái đơn hàng, vận đơn
    ${result_trangthai_hoadon}       ${result_trangthai_vandon}      ${result_status_vandon}    Check status order and status delivery Tiki    ${list_trangthai_tiki}
    #
    Log    tinh ton kho af ex
    ${list_product}   Get Dictionary Keys     ${list_product_num}
    ${list_nums}   Get Dictionary Values     ${list_product_num}
    ${list_result_onhand_af_ex}   Get list of result onhand incase changing product price     ${list_product}      ${list_nums}
    #
    Log    tính tổng tiền hàng
    ${result_tongtienhang}    Computaton total order Tiki    ${list_nums}     ${list_price}   ${list_discount}   ${list_discount_point}
    #
    Log    tạo đơn tiki và chuyển trạng thái
    ${get_ma_dh_tiki}    Create order Tiki thr API     ${input_shop_tiki}  ${list_product_num}    ${list_price}     ${list_discount}      ${list_discount_point}    ${ten_kh}     ${dia_chi}   ${thanh_pho}    ${khu_vuc}      ${phuong_xa}   ${dien_thoai}
    ${ma_dh_kv}   Set Variable    DHTIKI_${get_ma_dh_tiki}
    ${ma_hd_kv}   Set Variable    HDTIKI_${get_ma_dh_tiki}
    ${ma_kh}      Set Variable    KHTIKI${get_ma_dh_tiki}
    Wait Until Keyword Succeeds    10x    30s    Assert order exist succeed    ${ma_dh_kv}
    :FOR      ${item_trangthai_tiki}   IN ZIP     ${list_trangthai_tiki}
    \     Update status delivery in Tiki order        ${get_ma_dh_tiki}    ${item_trangthai_tiki}
    Wait Until Keyword Succeeds    10x    30s    Assert invoice exist succeed    ${ma_hd_kv}
    #
    Log    validate af ax
    Assert values by order code until succeed    ${ma_dh_kv}    ${ma_kh}    3    ${result_tongtienhang}    0    0
    Assert values by invoice code until succeed    ${ma_hd_kv}    ${result_tongtienhang}    ${result_tongtienhang}    ${ma_kh}    0    0    ${result_trangthai_hoadon}
    Assert delivery info by invoice code until succeed    ${ma_hd_kv}    TIKI    ${ten_kh}    ${dien_thoai}    ${dia_chi}     ${thanh_pho} - ${khu_vuc}    ${phuong_xa}    ${result_status_vandon}    1
    Assert Cong no khach hang until succeed     ${ma_kh}    ${result_tongtienhang}    ${result_tongtienhang}    ${result_tongtienhang}
    Assert list of Onhand after execute      ${list_product}    ${list_result_onhand_af_ex}
    #
    Delete invoice by invoice code    ${ma_hd_kv}
    Delete order frm Order code    ${ma_dh_kv}
    Delete customer by Customer Code    ${ma_kh}
