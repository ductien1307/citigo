*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    ${headless_browser}
Test Setup        Before Test QL Hoa Don
Test Teardown     After Test
Library           SeleniumLibrary
Resource          ../../../../core/Thiet_lap/thiet_lap_nav.robot
Resource          ../../../../core/Thiet_lap/thiet_lap_cuahang_list_action.robot
Resource          ../../../../core/API/api_thietlap.robot
Resource          ../../../../core/API/api_sendo.robot
Resource          ../../../../core/API/api_mhbh_dathang.robot
Resource          ../../../../core/API/api_hoadon_banhang.robot
Resource          ../../../../core/API/api_dathang.robot
Resource          ../../../../core/API/api_trahang.robot
Resource          ../../../../core/API/api_hanghoa.robot
Resource          ../../../../core/API/api_danhmuc_hanghoa.robot
Resource          ../../../../share/constants.robot
Resource          ../../../../prepare/Hang_hoa/Sources/hanghoa.robot
Resource          ../../../../core/Giao_dich/hoa_don_list_action.robot

*** Variables ***
&{list_prs_num}        KLSI0004=3     KLSI0005=2
@{list_giaban}        75000     112000
@{list_sendo1}    6     7       8
@{list_sendo2}    6     21
@{list_sendo3}    21    22


*** Test Cases ***      Tên shop sendo        SP - SL               Giá bán             Giảm gía         Tên KH        Địa chỉ              Phường xã            Điện thoại    Trạng thái
Order imei              [Tags]      SDO
                        [Template]    sync_sdo5
                        [Timeout]     20 minutes
                        KiotViet            ${list_prs_num}       ${list_giaban}          25000       Test kh sendo      1B Yết Kiêu     Phường Trần Hưng Đạo     087965      ${list_sendo1}
                        KiotViet            ${list_prs_num}       ${list_giaban}          25000       Test kh sendo      1B Yết Kiêu     Phường Trần Hưng Đạo     098756      ${list_sendo2}

Return imei             [Tags]       SDO
                        [Template]    sync_sdo6
                        [Timeout]     10 minutes
                        KiotViet            ${list_prs_num}       ${list_giaban}          25000       Test kh sendo      1B Yết Kiêu     Phường Trần Hưng Đạo     032569      ${list_sendo3}


*** Keywords ***
sync_sdo5
    [Arguments]    ${input_sendo}     ${list_product_num}       ${list_price}     ${discount}    ${ten_kh}     ${dia_chi}     ${phuong_xa}    ${dien_thoai}     ${list_trangthai_sendo}
    Delete customer by phone number thr API      ${dien_thoai}
    #
    Log    tinh ton kho af ex
    ${list_product}   Get Dictionary Keys     ${list_product_num}
    ${list_nums}   Get Dictionary Values     ${list_product_num}
    ${list_result_onhand_af_ex}     Get list onhand frm API    ${list_product}
    #
    Log    nhập imei
    Create list imei and other product    ${list_product}     ${list_nums}
    Sleep    25s
    #
    Log   check trạng thái đơn hàng, vận đơn
    ${result_trangthai_hoadon}       ${result_trangthai_vandon}      ${result_status_vandon}    Check status order and status delivery Sendo    ${list_trangthai_sendo}
    #
    Log    tính tổng tiền hàng
    ${list_result_thanhtien}    Get list of total sale in case of changing product price    ${list_product}   ${list_nums}    ${list_price}
    ${result_tongtienhang}    Sum values in list    ${list_result_thanhtien}
    ${result_tongcong}    Minus   ${result_tongtienhang}    ${discount}
    #
    Log    tạo đơn Sendo và chuyển trạng thái
    ${get_ma_dh_sendo}    Create order Sendo     ${input_sendo}  ${list_product_num}    ${list_price}     ${discount}    ${ten_kh}   ${dia_chi}     ${phuong_xa}   ${dien_thoai}
    ${ma_dh_kv}   Set Variable    DHSDO_${get_ma_dh_sendo}
    ${ma_hd_kv}   Set Variable    HDSDO_${get_ma_dh_sendo}
    ${ma_kh}      Set Variable    KHSDO${get_ma_dh_sendo}
    Wait Until Keyword Succeeds    10x    30s    Assert order exist succeed    ${ma_dh_kv}
    :FOR      ${item_trangthai_sendo}   IN ZIP     ${list_trangthai_sendo}
    \     Update status Sendo     ${get_ma_dh_sendo}    ${item_trangthai_sendo}
    Wait Until Keyword Succeeds    10x    30s    Assert invoice omni succeed     ${ma_hd_kv}
    #
    Log    chọn imei
    Reload Page
    Open popup Sync Tiki, Lazada, Shopee and search invoice code      ${ma_hd_kv}
    Choose imei in popup Sync Tiki, Lazada, Shopee       ${list_product}    ${imei_inlist}
    Click Element    ${button_omni_dongbo_tungdon}
    Wait Until Keyword Succeeds    6x    20s    Assert invoice exist succeed   ${ma_hd_kv}
    #
    Log   validate af ex
    Assert values by order code until succeed    ${ma_dh_kv}    ${ma_kh}    3    ${result_tongcong}    0    ${discount}
    Assert values by invoice code until succeed     ${ma_hd_kv}     ${result_tongcong}     ${result_tongtienhang}    ${ma_kh}    0    ${discount}    ${result_trangthai_hoadon}
    Assert delivery info by invoice code until succeed    ${ma_hd_kv}    SENDO    ${ten_kh}    ${dien_thoai}   ${dia_chi}    Hồ Chí Minh - Quận 7    ${phuong_xa}    ${result_status_vandon}    1
    Assert Cong no khach hang until succeed   ${ma_kh}    ${result_tongcong}    ${result_tongcong}    ${result_tongcong}
    Assert list of Onhand after execute      ${list_product}    ${list_result_onhand_af_ex}
    #
    Delete invoice by invoice code    ${ma_hd_kv}
    Delete order frm Order code    ${ma_dh_kv}
    Delete customer by Customer Code    ${ma_kh}

sync_sdo6
    [Arguments]    ${input_sendo}     ${list_product_num}       ${list_price}     ${discount}    ${ten_kh}     ${dia_chi}     ${phuong_xa}    ${dien_thoai}     ${list_trangthai_sendo}
    #
    Delete customer by phone number thr API      ${dien_thoai}
    ${list_product}   Get Dictionary Keys     ${list_product_num}
    ${list_nums}   Get Dictionary Values     ${list_product_num}
    #
    Log    tinh ton kho af ex
    ${list_onhand_bf_ex}    Get list of Onhand by Product Code     ${list_product}
    ${list_result_onhand_af_ex}     Create List
    :FOR       ${item_onhand}    ${item_num}     IN ZIP    ${list_onhand_bf_ex}   ${list_nums}
    \       ${result_onhand}      Sum       ${item_onhand}      ${item_num}
    \       Append To List    ${list_result_onhand_af_ex}    ${result_onhand}
    Log     ${list_result_onhand_af_ex}
    #
    Create list imei and other product    ${list_product}     ${list_nums}
    Sleep    20s
    Log   check trạng thái đơn hàng, vận đơn
    ${result_trangthai_vandon}       Set Variable     Đã chuyển hoán
    ${result_status_vandon}         Set Variable    4
    #
    Log    tính tổng tiền hàng
    ${list_result_thanhtien}    Get list of total sale in case of changing product price    ${list_product}   ${list_nums}    ${list_price}
    ${result_tongtienhang}    Sum values in list    ${list_result_thanhtien}
    ${result_tongcong}    Minus     ${result_tongtienhang}      ${discount}
    #
    Log    tạo đơn sendo và chuyển trạng thái
    ${get_ma_dh_sendo}    Create order Sendo     ${input_sendo}  ${list_product_num}    ${list_price}     ${discount}    ${ten_kh}   ${dia_chi}     ${phuong_xa}   ${dien_thoai}
    Update status Sendo     ${get_ma_dh_sendo}    6
    ${ma_dh_kv}   Set Variable    DHSDO_${get_ma_dh_sendo}
    ${ma_hd_kv}   Set Variable    HDSDO_${get_ma_dh_sendo}
    ${ma_th_kv}   Set Variable    CHHDSDO_${get_ma_dh_sendo}
    ${ma_kh}      Set Variable    KHSDO${get_ma_dh_sendo}
    Wait Until Keyword Succeeds    10x    30s    Assert invoice omni succeed     ${ma_hd_kv}
    #
    Log    chọn imei
    Reload Page
    Open popup Sync Tiki, Lazada, Shopee and search invoice code       ${ma_hd_kv}
    Choose imei in popup Sync Tiki, Lazada, Shopee       ${list_product}    ${imei_inlist}
    Click Element    ${button_omni_dongbo_tungdon}
    Wait Until Keyword Succeeds    6x    30s    Assert invoice exist succeed   ${ma_hd_kv}
    #
    Log    chuyển trạng thái trả hàng
    :FOR      ${item_trangthai_sendo}   IN ZIP     ${list_trangthai_sendo}
    \     Update status Sendo     ${get_ma_dh_sendo}    ${item_trangthai_sendo}
    Wait Until Keyword Succeeds    10x    30s    Assert return exist succeed    ${ma_th_kv}
    #
    Log    validate af ex
    Assert values by order code until succeed    ${ma_dh_kv}    ${ma_kh}    3    ${result_tongcong}    0    ${discount}
    Assert values by invoice code until succeed    ${ma_hd_kv}    ${result_tongcong}    ${result_tongtienhang}    ${ma_kh}    0    ${discount}    Hoàn thành
    Assert delivery info by invoice code until succeed    ${ma_hd_kv}    SENDO    ${ten_kh}    ${dien_thoai}    ${dia_chi}    Hồ Chí Minh - Quận 7     ${phuong_xa}    5    1
    Assert values by return code until succeed    ${ma_th_kv}    ${result_tongtienhang}    ${discount}    0    ${result_tongcong}    0
    Assert Cong no khach hang until succeed    ${ma_kh}    0     ${result_tongcong}     0
    Assert list of Onhand after execute      ${list_product}    ${list_result_onhand_af_ex}
    #
    Delete invoice by invoice code    ${ma_hd_kv}
    Delete order frm Order code    ${ma_dh_kv}
    Delete customer by phone number thr API      ${dien_thoai}
