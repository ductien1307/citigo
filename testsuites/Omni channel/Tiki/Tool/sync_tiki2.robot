*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    ${headless_browser}
Test Teardown     After Test
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
Resource          ../../../../prepare/Hang_hoa/Sources/hanghoa.robot
Resource          ../../../../core/Giao_dich/hoa_don_list_action.robot

*** Variables ***
&{list_prs_num1}       TPG01=2    TPG02=1
@{list_giaban1}      45000       55000
@{list_gg1}          8000        5000
@{list_point}          2000       0
@{list_tiki1}    picking     packaging    finished_packing      ready_to_ship      shipping    returned
@{list_tiki2}    picking     packaging    finished_packing      ready_to_ship      handover_to_partner    returned


*** Test Cases ***      Tên shop tiki       SP - SL               Giá bán             Giảm gíá          Point             Tên KH          Địa chỉ        Thành phố     Khu vực         Phường xã             Điện thoại    Trạng thái
Sync order              [Tags]            TIKIO
                        [Template]    sync_tiki1
                        [Timeout]     15 minutes
                        KiotViet            ${list_prs_num1}       ${list_giaban1}     ${list_gg1}    ${list_point}     Test kh tiki      1B Yết Kiêu     Hà Nội     Quận Hoàn Kiếm    Phường Trần Hưng Đạo     none            True
                        KiotViet            ${list_prs_num1}       ${list_giaban1}     ${list_gg1}    ${list_point}     Test kh tiki      1B Yết Kiêu     Hà Nội     Quận Hoàn Kiếm    Phường Trần Hưng Đạo     0985214563      False

Update order cancel     [Tags]          TIKIO
                        [Template]    sync_tiki3
                        [Timeout]     10 minutes
                        KiotViet           ${list_prs_num1}       ${list_giaban1}     ${list_gg1}     ${list_point}       Test kh tiki      1B Yết Kiêu     Hà Nội     Quận Hoàn Kiếm    Phường Trần Hưng Đạo     none    canceled

*** Keywords ***
sync_tiki1
    [Arguments]    ${input_shop_tiki}     ${list_product_num}       ${list_price}     ${list_discount}       ${list_discount_point}      ${ten_kh}     ${dia_chi}    ${thanh_pho}      ${khu_vuc}      ${phuong_xa}    ${dien_thoai}   ${gen_kh}
    Log    tính tổng tiền hàng, số lượng đặt
    ${list_product}   Get Dictionary Keys     ${list_product_num}
    ${list_nums}   Get Dictionary Values     ${list_product_num}
    ${result_tongtienhang}    Computaton total order Tiki    ${list_nums}     ${list_price}   ${list_discount}   ${list_discount_point}
    ${list_result_order_summary}    Computation list result order summary af excute    ${list_product}   ${list_nums}
    #
    Log    tinh cong no kh
    Log    ${gen_kh}=True : Xóa kh cũ
    ${get_id_kh}   ${get_ma_kh}    Get customer id and code by number phone thr API   ${dien_thoai}
    Run Keyword If    ${get_id_kh}!=0 and '${gen_kh}'=='True'    Delete customer   ${get_id_kh}
    ${get_no_bf_execute}    ${get_tongban_bf_execute}    ${get_tongban_tru_trahang_bf_execute}    Run Keyword If    ${get_id_kh}!=0 and ${gen_kh}!=True    Get Customer Debt from API    ${get_ma_kh}
    #
    Log    tạo đơn đặt hàng tiki
    ${get_ma_dh_tiki}    Create order Tiki thr API     ${input_shop_tiki}  ${list_product_num}    ${list_price}     ${list_discount}     ${list_discount_point}  ${ten_kh}     ${dia_chi}   ${thanh_pho}    ${khu_vuc}      ${phuong_xa}   ${dien_thoai}
    ${ma_dh_kv}   Set Variable    DHTIKI_${get_ma_dh_tiki}
    ${ma_kh}      Set Variable    KHTIKI${get_ma_dh_tiki}
    ${result_ma_kh}   Set Variable If    '${gen_kh}'!='True' and ${get_id_kh}!=0   ${get_ma_kh}    ${ma_kh}
    Wait Until Keyword Succeeds    10x    30s    Assert order exist succeed    ${ma_dh_kv}
    #assert value order
    Log    validate af ex
    Assert values by order code until succeed    ${ma_dh_kv}    ${result_ma_kh}    1    ${result_tongtienhang}    0    0
    Assert delivery info by order code until succeed    ${ma_dh_kv}    TIKI    ${ten_kh}    ${dia_chi}   ${thanh_pho} - ${khu_vuc}    ${phuong_xa}
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

sync_tiki3
    [Arguments]    ${input_shop_tiki}     ${list_product_num}       ${list_price}     ${list_discount}       ${list_discount_point}     ${ten_kh}     ${dia_chi}    ${thanh_pho}      ${khu_vuc}      ${phuong_xa}    ${dien_thoai}     ${input_trangthai_tiki}
    Log    tính tổng tiền hàng
    ${list_product}   Get Dictionary Keys     ${list_product_num}
    ${list_nums}   Get Dictionary Values     ${list_product_num}
    ${result_tongtienhang}    Computaton total order Tiki    ${list_nums}     ${list_price}   ${list_discount}   ${list_discount_point}
    #
    Log    tạo đơn tiki và chuyển trạng thái
    ${get_ma_dh_tiki}    Create order Tiki thr API     ${input_shop_tiki}  ${list_product_num}    ${list_price}     ${list_discount}     ${list_discount_point}     ${ten_kh}     ${dia_chi}   ${thanh_pho}    ${khu_vuc}      ${phuong_xa}   ${dien_thoai}
    Update status delivery in Tiki order        ${get_ma_dh_tiki}    ${input_trangthai_tiki}
    ${ma_dh_kv}   Set Variable    DHTIKI_${get_ma_dh_tiki}
    ${ma_kh}      Set Variable    KHTIKI${get_ma_dh_tiki}
    Wait Until Keyword Succeeds    10x    30s    Assert order exist succeed    ${ma_dh_kv}
    #
    Log    validate af ex
    Assert values by order code until succeed    ${ma_dh_kv}    ${ma_kh}    4     ${result_tongtienhang}    0    0
    Assert Cong no khach hang until succeed    ${ma_kh}    0    0    0
    #
    Delete customer by Customer Code    ${ma_kh}
