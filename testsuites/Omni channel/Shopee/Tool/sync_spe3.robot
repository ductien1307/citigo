*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    ${headless_browser}
Test Setup        Before Test QL Hoa Don
Test Teardown     After Test
Library           SeleniumLibrary
Resource          ../../../../core/Thiet_lap/thiet_lap_nav.robot
Resource          ../../../../core/Thiet_lap/thiet_lap_cuahang_list_action.robot
Resource          ../../../../core/API/api_thietlap.robot
Resource          ../../../../core/API/api_shopee.robot
Resource          ../../../../core/API/api_mhbh_dathang.robot
Resource          ../../../../core/API/api_hoadon_banhang.robot
Resource          ../../../../core/API/api_dathang.robot
Resource          ../../../../core/API/api_trahang.robot
Resource          ../../../../core/API/api_hanghoa.robot
Resource          ../../../../share/constants.robot
Resource          ../../../../prepare/Hang_hoa/Sources/hanghoa.robot
Resource          ../../../../core/Giao_dich/hoa_don_list_action.robot

*** Variables ***
@{list_shopee}    SHIPPED   TO_CONFIRM_RECEIVE     CANCELLED
@{list_shopee1}    SHIPPED   TO_CONFIRM_RECEIVE     COMPLETED
@{list_shopee2}    SHIPPED   TO_CONFIRM_RECEIVE

*** Test Cases ***      Tên shop shopee       SP     SP shopee      SL         Giá bán       Giảm giá      Khách hàng      Khu vực         Địa chỉ                SDT        Trạng thái
Sync lodate             [Tags]           SPEO
                        [Template]    sync_shopee6
                        [Timeout]     15 minutes
                        thanhptk         LDSP01     SPETH215         3         65000        3000         kh shopee      Quận Hoàn Kiếm       Nguyễn Du         032563214     ${list_shopee}
                        thanhptk         LDSP02     SPETH213         4         75000        5000         kh shopee      Quận Hoàn Kiếm       Nguyễn Du         036363234     ${list_shopee1}

*** Keywords ***
sync_shopee6
    [Arguments]     ${input_shop_shopee}      ${ma_hh}    ${ma_hh_shopee}   ${num}    ${input_price}    ${giam_gia_dh}    ${ten_kh}     ${dia_chi}   ${phuong_xa}   ${dien_thoai}     ${list_trangthai_shopee}
    #
    Delete product if product is visible thr API    ${ma_hh}
    Add lodate product thr API    ${ma_hh}    test sync lodate   Mỹ phẩm     55000
    Mapping product with Shopee thr API    ${input_shop_shopee}    ${ma_hh_shopee}    ${ma_hh}
    Delete customer by phone number thr API      ${dien_thoai}
    ${list_product_num}     Create Dictionary    ${ma_hh}=${num}
    ${list_product}   Get Dictionary Keys     ${list_product_num}
    ${list_nums}   Get Dictionary Values     ${list_product_num}
    ${tenlo_by_product}    Get lot name list and import lot for product    ${ma_hh}    ${num}
    Sleep    20s
    Log   check trạng thái vận đơn
    ${get_length}   Get Length    ${list_trangthai_shopee}
    ${end_status}     Minus     ${get_length}   1
    ${end_status}   Replace floating point    ${end_status}
    ${result_trangthai_vandon}      Run Keyword If      '${list_trangthai_shopee[${end_status}]}'=='READY_TO_SHIP'    Set Variable   Chưa giao hàng    ELSE IF      '${list_trangthai_shopee[${end_status}]}'=='CANCELLED'     Set Variable    Đang chuyển hoàn    ELSE IF     '${list_trangthai_shopee[${end_status}]}'=='SHIPPED' or '${list_trangthai_shopee[${end_status}]}'=='TO_CONFIRM_RECEIVE'    Set Variable   Đang giao hàng    ELSE IF   '${list_trangthai_shopee[${end_status}]}'=='COMPLETED'      Set Variable   Giao thành công
    ${result_status_vandon}      Run Keyword If      '${result_trangthai_vandon}'=='Đang lấy hàng'    Set Variable    7   ELSE IF      '${result_trangthai_vandon}'=='Đã lấy hàng'    Set Variable   9   ELSE IF     '${result_trangthai_vandon}'=='Đang giao hàng'    Set Variable   2    ELSE IF   '${result_trangthai_vandon}'=='Giao thành công'     Set Variable   3      ELSE    Set Variable    4
    #
    Log    tính tổng tiền hàng, tồn kho
    ${result_tongtienhang}    Multiplication and round    ${input_price}     ${list_nums[0]}
    ${result_khachcantra}      Minus   ${result_tongtienhang}      ${giam_gia_dh}
    ${list_result_onhand_af_ex}   Get list of result onhand incase changing product price     ${list_product}      ${list_nums}
    #
    Log    tạo đơn shopee và chuyển trạng thái
    ${get_ma_dh_shopee}    Create order Shopee thr API      ${input_shop_shopee}  ${list_product_num}    ${input_price}     ${giam_gia_dh}    ${ten_kh}     ${dia_chi}   ${phuong_xa}   ${dien_thoai}
    Update order status Shopee thr API    ${input_shop_shopee}   ${get_ma_dh_shopee}    READY_TO_SHIP     LOGISTICS_READY
    ${ma_dh_kv}   Set Variable    DHSPE_${get_ma_dh_shopee}
    ${ma_hd_kv}   Set Variable    HDSPE_${get_ma_dh_shopee}
    ${ma_kh}      Set Variable    KHSPE${get_ma_dh_shopee}
    #Wait Until Keyword Succeeds    10x    30s    Assert order exist succeed    ${ma_dh_kv}
    Wait Until Keyword Succeeds    10x    30s    Assert invoice omni succeed   ${ma_hd_kv}
    #
    Log    chọn lô
    Reload Page
    Open popup Sync Tiki, Lazada, Shopee and search invoice code    ${ma_hd_kv}
    Choose lo in popup Sync Tiki, Lazada, Shopee    ${tenlo_by_product[0]}
    ${get_cur_date}     Get Current Date    result_format=%Y-%m-%d %H:%M:%S
    Click Element    ${button_omni_dongbo_tungdon}
    Wait Until Keyword Succeeds    6x    30s    Assert invoice exist succeed   ${ma_hd_kv}
    #
    Log    chuyển trạng thái hóa đơn
    :FOR      ${item_trangthai_shopee}   IN ZIP     ${list_trangthai_shopee}
    \     Run Keyword If    '${item_trangthai_shopee}'=='TO_CONFIRM_RECEIVE'      Update order status Shopee thr API    ${input_shop_shopee}   ${get_ma_dh_shopee}    ${item_trangthai_shopee}    none    ELSE IF     '${item_trangthai_shopee}'=='CANCELLED'     Update logistics status Shopee thr API      ${get_ma_dh_shopee}      ${item_trangthai_shopee}    LOGISTICS_DELIVERY_FAILED
    \     ...   ELSE IF     '${item_trangthai_shopee}'=='COMPLETED'     Update logistics status Shopee thr API     ${get_ma_dh_shopee}      ${item_trangthai_shopee}    	LOGISTICS_DELIVERY_DONE
    #
    Log    validate af ex
    Assert values by order code until succeed    ${ma_dh_kv}     ${ma_kh}    3    ${result_khachcantra}    0    ${giam_gia_dh}
    Assert values by invoice code until succeed    ${ma_hd_kv}     ${result_khachcantra}      ${result_tongtienhang}       ${ma_kh}    0    ${giam_gia_dh}    Đang xử lý
    Assert delivery info by invoice code until succeed    ${ma_hd_kv}    SHOPEE    ${ten_kh}    ${dien_thoai}    0    ${dia_chi}     ${phuong_xa}     ${result_status_vandon}    1
    Assert Cong no khach hang until succeed     ${ma_kh}    ${result_khachcantra}      ${result_khachcantra}    ${result_khachcantra}
    Assert list of Onhand after execute      ${list_product}    ${list_result_onhand_af_ex}
    #
    Delete invoice by invoice code    ${ma_hd_kv}
    Delete order frm Order code    ${ma_dh_kv}
    Delete customer by Customer Code    ${ma_kh}
    Delete product thr API    ${ma_hh}
