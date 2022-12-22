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
Resource          ../../../../core/API/api_trahang.robot
Resource          ../../../../core/API/api_hanghoa.robot
Resource          ../../../../share/constants.robot
Resource          ../../../prepare/Hang_hoa/Sources/hanghoa.robot

*** Variables ***
&{list_prs_num}        KLCB004=3     KLDV004=2     KLQD004=1   KLT0004=2
@{list_giaban}        75000     112000      55000       90000
@{list_sendo1}    6     7       8
@{list_sendo2}    6     21


*** Test Cases ***      Tên shop sendo        SP - SL               Giá bán             Giảm gía         Tên KH        Địa chỉ              Phường xã            Điện thoại    Trạng thái
Sync order              [Tags]      SDO
                        [Template]    sync_sdo1
                        [Timeout]     15 minutes
                        KiotViet            ${list_prs_num}       ${list_giaban}         30000        Test kh sendo      1B Yết Kiêu     Phường Trần Hưng Đạo     0856936         True
                        KiotViet            ${list_prs_num}       ${list_giaban}         25000        Test kh sendo      1B Yết Kiêu     Phường Trần Hưng Đạo     0912754758      False

Update order            [Tags]      SDO
                        [Template]    sync_sdo2
                        [Timeout]     15 minutes
                        KiotViet            ${list_prs_num}       ${list_giaban}          25000       Test kh sendo      1B Yết Kiêu     Phường Trần Hưng Đạo     02582       ${list_sendo1}
                        KiotViet            ${list_prs_num}       ${list_giaban}          25000       Test kh sendo      1B Yết Kiêu     Phường Trần Hưng Đạo     02428       ${list_sendo2}

*** Keywords ***
sync_sdo1
    [Arguments]    ${input_sendo}     ${list_product_num}       ${list_price}    ${discount}   ${ten_kh}     ${dia_chi}    ${phuong_xa}    ${dien_thoai}   ${gen_kh}
    Log    tính tổng tiền hàng, số lượng đặt
    ${list_product}   Get Dictionary Keys     ${list_product_num}
    ${list_nums}   Get Dictionary Values     ${list_product_num}
    ${list_result_thanhtien}    Get list of total sale in case of changing product price    ${list_product}   ${list_nums}    ${list_price}
    ${result_tongtienhang}    Sum values in list    ${list_result_thanhtien}
    ${result_tongcong}    Minus   ${result_tongtienhang}    ${discount}
    ${list_result_order_summary}    Computation list result order summary af excute    ${list_product}   ${list_nums}
    #
    Log    tinh cong no kh
    Log    ${gen_kh}=True : Xóa kh cũ
    ${get_id_kh}   ${get_ma_kh}    Get customer id and code by number phone thr API   ${dien_thoai}
    Run Keyword If    ${get_id_kh}!=0 and '${gen_kh}'=='True'    Delete customer   ${get_id_kh}
    ${get_no_bf_execute}    ${get_tongban_bf_execute}    ${get_tongban_tru_trahang_bf_execute}    Run Keyword If    ${get_id_kh}!=0 and ${gen_kh}!=True    Get Customer Debt from API    ${get_ma_kh}
    #
    Log    tạo đơn đặt hàng sendo
    ${get_ma_dh_sendo}    Create order Sendo    ${input_sendo}     ${list_product_num}       ${list_price}     ${discount}    ${ten_kh}     ${dia_chi}    ${phuong_xa}    ${dien_thoai}
    ${ma_dh_kv}   Set Variable    DHSDO_${get_ma_dh_sendo}
    ${ma_kh}      Set Variable    KHSDO${get_ma_dh_sendo}
    ${result_ma_kh}   Set Variable If    '${gen_kh}'!='True' and ${get_id_kh}!=0   ${get_ma_kh}    ${ma_kh}
    Wait Until Keyword Succeeds    10x    30s    Assert order exist succeed    ${ma_dh_kv}
    #assert value order
    Log    validate af ex
    Assert values by order code until succeed    ${ma_dh_kv}    ${result_ma_kh}    1    ${result_tongcong}    0    ${discount}
    Assert delivery info by order code until succeed    ${ma_dh_kv}    SENDO    ${ten_kh}    ${dia_chi}   Hồ Chí Minh - Quận 7    ${phuong_xa}
    Assert list of order summarry after execute    ${list_product}    ${list_result_order_summary}
    #
    ${get_no_af_execute}    ${get_tongban_af_execute}    ${get_tongban_tru_trahang_af_execute}    Get Customer Debt from API    ${result_ma_kh}
    Run Keyword If    '${gen_kh}'=='True' or ${get_id_kh}==0    Should Be Equal As Numbers    ${get_no_af_execute}    0    ELSE    Should Be Equal As Numbers    ${get_no_af_execute}    ${get_no_bf_execute}
    Run Keyword If    '${gen_kh}'=='True' or ${get_id_kh}==0    Should Be Equal As Numbers    ${get_tongban_af_execute}    0     ELSE    Should Be Equal As Numbers    ${get_tongban_af_execute}    ${get_tongban_bf_execute}
    Run Keyword If    '${gen_kh}'=='True' or ${get_id_kh}==0    Should Be Equal As Numbers    ${get_tongban_tru_trahang_af_execute}    0     ELSE    Should Be Equal As Numbers    ${get_tongban_tru_trahang_af_execute}     ${get_tongban_tru_trahang_bf_execute}
    Validate history in customer if order is not paid    ${result_ma_kh}    ${ma_dh_kv}
    #
    Delete order frm Order code    ${ma_dh_kv}
    Run Keyword If    '${gen_kh}'=='True'    Delete customer by Customer Code    ${result_ma_kh}

sync_sdo2
    [Arguments]    ${input_sendo}     ${list_product_num}       ${list_price}    ${discount}   ${ten_kh}     ${dia_chi}    ${phuong_xa}    ${dien_thoai}      ${list_trangthai_sendo}
    Delete customer by phone number thr API      ${dien_thoai}
    Log   check trạng thái đơn hàng, vận đơn
    ${result_trangthai_hoadon}       ${result_trangthai_vandon}      ${result_status_vandon}    Check status order and status delivery Sendo    ${list_trangthai_sendo}
    #
    Log    tinh ton kho af ex
    ${list_product}   Get Dictionary Keys     ${list_product_num}
    ${list_nums}   Get Dictionary Values     ${list_product_num}
    ${list_result_onhand_af_ex}   Get list of result onhand incase changing product price     ${list_product}      ${list_nums}
    #
    Log    tính tổng tiền hàng
    ${list_result_thanhtien}    Get list of total sale in case of changing product price    ${list_product}   ${list_nums}    ${list_price}
    ${result_tongtienhang}    Sum values in list    ${list_result_thanhtien}
    ${result_tongcong}    Minus   ${result_tongtienhang}    ${discount}
    #
    Log    tạo đơn sendo và chuyển trạng thái
    ${get_ma_dh_sendo}    Create order Sendo     ${input_sendo}  ${list_product_num}    ${list_price}     ${discount}    ${ten_kh}   ${dia_chi}     ${phuong_xa}   ${dien_thoai}
    ${ma_dh_kv}   Set Variable    DHSDO_${get_ma_dh_sendo}
    ${ma_hd_kv}   Set Variable    HDSDO_${get_ma_dh_sendo}
    ${ma_kh}      Set Variable    KHSDO${get_ma_dh_sendo}
    Wait Until Keyword Succeeds    10x    30s    Assert order exist succeed    ${ma_dh_kv}
    :FOR      ${item_trangthai_sendo}   IN ZIP     ${list_trangthai_sendo}
    \     Update status Sendo     ${get_ma_dh_sendo}    ${item_trangthai_sendo}
    Wait Until Keyword Succeeds    10x    30s    Assert invoice exist succeed    ${ma_hd_kv}
    #
    Log    validate af ax
    Assert values by order code until succeed    ${ma_dh_kv}    ${ma_kh}    3    ${result_tongcong}    0    ${discount}
    Assert values by invoice code until succeed    ${ma_hd_kv}    ${result_tongcong}    ${result_tongtienhang}    ${ma_kh}    0    ${discount}    ${result_trangthai_hoadon}
    Assert delivery info by invoice code until succeed    ${ma_hd_kv}    SENDO    ${ten_kh}    ${dien_thoai}    ${dia_chi}     Hồ Chí Minh - Quận 7   ${phuong_xa}    ${result_status_vandon}    1
    Assert Cong no khach hang until succeed     ${ma_kh}    ${result_tongcong}    ${result_tongcong}    ${result_tongcong}
    Assert list of Onhand after execute      ${list_product}    ${list_result_onhand_af_ex}
    #
    Delete invoice by invoice code    ${ma_hd_kv}
    Delete order frm Order code    ${ma_dh_kv}
    Delete customer by Customer Code    ${ma_kh}
