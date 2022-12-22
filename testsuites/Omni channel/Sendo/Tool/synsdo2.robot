*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    ${headless_browser}
Library           SeleniumLibrary
Resource          ../../../../core/Thiet_lap/thiet_lap_nav.robot
Resource          ../../../../core/Thiet_lap/thiet_lap_cuahang_list_action.robot
Resource          ../../../../core/API/api_thietlap.robot
Resource          ../../../../core/API/api_sendo.robot
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

*** Variables ***
&{list_prs_num}        KLCB005=2     KLDV005=4     KLQD005=3   KLT0005=1
@{list_giaban}        25000     76000      105000       82000
@{list_sendo1}    6     21    22

*** Test Cases ***       Tên shop sendo        SP - SL               Giá bán             Giảm gía       Tên KH        Địa chỉ              Phường xã         Điện thoại    Trạng thái
Update canceled         [Tags]        SDO
                        [Template]    sync_sdo3
                        [Timeout]     10 minutes
                        KiotViet            ${list_prs_num}       ${list_giaban}         45000        kh sendo      1B Yết Kiêu     Phường Trần Hưng Đạo        09865

Update return           [Tags]        SDO
                        [Template]    sync_sdo4
                        [Timeout]     10 minutes
                        KiotViet            ${list_prs_num}       ${list_giaban}         15000        kh sendo      1B Yết Kiêu     Phường Trần Hưng Đạo        09875      ${list_sendo1}

*** Keywords ***
sync_sdo3
    [Arguments]     ${input_sendo}     ${list_product_num}       ${list_price}    ${discount}   ${ten_kh}     ${dia_chi}    ${phuong_xa}    ${dien_thoai}
    Log    xóa kh cũ
    Delete customer by phone number thr API      ${dien_thoai}
    #
    Log    tính tổng tiền hàng, số lượng đặt
    ${list_product}   Get Dictionary Keys     ${list_product_num}
    ${list_nums}   Get Dictionary Values     ${list_product_num}
    ${list_result_thanhtien}    Get list of total sale in case of changing product price    ${list_product}   ${list_nums}    ${list_price}
    ${result_tongtienhang}    Sum values in list    ${list_result_thanhtien}
    ${result_tongcong}    Minus   ${result_tongtienhang}    ${discount}
    #
    Log    tạo đơn đặt hàng và chuyển trạng thái canceled
    ${get_ma_dh_sendo}    Create order Sendo    ${input_sendo}     ${list_product_num}       ${list_price}     ${discount}    ${ten_kh}     ${dia_chi}    ${phuong_xa}    ${dien_thoai}
    Update status Sendo    ${get_ma_dh_sendo}    13
    ${ma_dh_kv}   Set Variable    DHSDO_${get_ma_dh_sendo}
    ${ma_kh}      Set Variable    KHSDO${get_ma_dh_sendo}
    Wait Until Keyword Succeeds    10x    30s    Assert order exist succeed    ${ma_dh_kv}
    #
    Log    validate af ex
    Assert values by order code until succeed    ${ma_dh_kv}    ${ma_kh}    4    ${result_tongcong}    0    ${discount}
    Assert Cong no khach hang until succeed    ${ma_kh}    0     0     0
    #
    Delete customer by Customer Code    ${ma_kh}

sync_sdo4
    [Arguments]     ${input_sendo}     ${list_product_num}       ${list_price}    ${discount}   ${ten_kh}     ${dia_chi}    ${phuong_xa}    ${dien_thoai}      ${list_trangthai_sendo}
    Log    xóa kh cũ
    Delete customer by phone number thr API      ${dien_thoai}
    #
    Log    tính tổng tiền hàng, số lượng đặt
    ${list_product}   Get Dictionary Keys     ${list_product_num}
    ${list_nums}   Get Dictionary Values     ${list_product_num}
    ${list_result_thanhtien}    Get list of total sale in case of changing product price    ${list_product}   ${list_nums}    ${list_price}
    ${result_tongtienhang}    Sum values in list    ${list_result_thanhtien}
    ${result_tongcong}    Minus   ${result_tongtienhang}    ${discount}
    #
    Log    tinh ton kho af ex
    ${list_onhand_af_ex}    Get list of Onhand by Product Code     ${list_product}
    ${get_list_product_type}    ${get_list_imei_status}      Get list product type and imei status frm API   ${list_product}
    ${list_result_onhand_af_ex}     Create List
    :FOR    ${item_pr_type}     ${item_imei_status}     ${item_ohand}     IN ZIP       ${get_list_product_type}   ${get_list_imei_status}    ${list_onhand_af_ex}
    \       Run Keyword If    ${item_pr_type}==1 or ${item_pr_type}==3     Append To List    ${list_result_onhand_af_ex}    0       ELSE    Append To List   ${list_result_onhand_af_ex}    ${item_ohand}
    Log     ${list_result_onhand_af_ex}
    #
    Log    tạo đơn sendo và chuyển trạng thái
    ${get_ma_dh_sendo}    Create order Sendo     ${input_sendo}  ${list_product_num}    ${list_price}     ${discount}    ${ten_kh}   ${dia_chi}     ${phuong_xa}   ${dien_thoai}
    ${ma_dh_kv}   Set Variable    DHSDO_${get_ma_dh_sendo}
    ${ma_hd_kv}   Set Variable    HDSDO_${get_ma_dh_sendo}
    ${ma_th_kv}   Set Variable    CHHDSDO_${get_ma_dh_sendo}
    ${ma_kh}      Set Variable    KHSDO${get_ma_dh_sendo}
    Wait Until Keyword Succeeds    10x    30s    Assert order exist succeed    ${ma_dh_kv}
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
