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
Resource          ../../../../core/API/api_trahang.robot
Resource          ../../../../share/constants.robot
Resource          ../../../../prepare/Hang_hoa/Sources/hanghoa.robot
Resource          ../../../../core/hang_hoa/hang_hoa_add_action.robot
Resource          ../../../../core/hang_hoa/hang_hoa_add_page.robot
Resource          ../../../../core/hang_hoa/danh_muc_list_action.robot

*** Variables ***
&{dict_sp}     GHDCB004=75000     GHDDV004=110000     GHDT002=50000   GHDU005=65000

*** Test Cases ***      Tên shop lazada      SP - GB         Tên KH      SDT          Địa chỉ        Khu vực         Phường xã        Trạng thái
Create order            [Tags]        LZDO
                        [Template]    synlzd2
                        [Timeout]     20 minutes
                        TEST SELLER 3             ${dict_sp}         Hoa      0987456921    Hà Nội        Đống Đa         Yết Kiêu     True
                        TEST SELLER 3             ${dict_sp}         Hoa      0987565456    Hà Nội        Đống Đa         Yết Kiêu      False


Update cancel           [Tags]           LZDO
                        [Template]    synlzd3
                        [Timeout]     10 minutes
                        TEST SELLER 3             ${dict_sp}         Lan      098721    Hà Nội        Đống Đa       Yết Kiêu

*** Keywords ***
synlzd2
    [Arguments]     ${input_shop_lzd}     ${list_product_price}   ${ten_kh}   ${dien_thoai}    ${dia_chi}   ${khu_vuc}    ${phuong_xa}   ${gen_kh}
    Log    tính tổng tiền hàng, số lượng đặt
    ${list_product}   Get Dictionary Keys     ${list_product_price}
    ${list_price}   Get Dictionary Values     ${list_product_price}
    ${result_tongtienhang}      Sum values in list      ${list_price}
    ${list_order_summary}    Get list order summary frm product API    ${list_product}
    ${list_result_order_summary}    Create List
    :FOR    ${item_order_summary}   IN ZIP      ${list_order_summary}
    \     ${result_tongso_dh}    Sum and round 2    ${item_order_summary}    1
    \     Append To List    ${list_result_order_summary}    ${result_tongso_dh}
    Log    ${list_result_order_summary}
    #
    Log    tinh cong no kh
    Log    ${gen_kh}=True : Xóa kh cũ
    ${get_id_kh}   ${get_ma_kh}    Get customer id and code by number phone thr API   ${dien_thoai}
    Run Keyword If    ${get_id_kh}!=0 and '${gen_kh}'=='True'    Delete customer   ${get_id_kh}
    ${get_no_bf_execute}    ${get_tongban_bf_execute}    ${get_tongban_tru_trahang_bf_execute}    Run Keyword If    ${get_id_kh}!=0 and ${gen_kh}!=True    Get Customer Debt from API    ${get_ma_kh}
    #
    Log    tạo đơn đặt hàng
    ${list_sku}    Change price sku in lazada client thr API     ${input_shop_lzd}     ${list_product}     ${list_price}
    ${order_number}     Create order Lazada     ${list_sku}   ${ten_kh}   ${dien_thoai}    ${dia_chi}   ${khu_vuc}    ${phuong_xa}
    ${get_oder_id}    Get order id by order number thr API    ${order_number}
    ${ma_dh_kv}   Set Variable    DHLZD_${get_oder_id}
    ${ma_kh}      Set Variable    KHLZD${get_oder_id}
    ${result_ma_kh}   Set Variable If    '${gen_kh}'!='True' and ${get_id_kh}!=0   ${get_ma_kh}    ${ma_kh}
    Wait Until Keyword Succeeds    10x    30s    Assert order exist succeed    ${ma_dh_kv}
    #Get audit trail no payment info and validate    ${ma_dh_kv}    Đồng bộ Lazada    Đồng bộ đặt hàng
    #assert value order
    Log    vaidate af ex
    Assert values by order code until succeed    ${ma_dh_kv}     ${result_ma_kh}    1    ${result_tongtienhang}    0    0
    Assert delivery info by order code until succeed    ${ma_dh_kv}    LAZADA    ${ten_kh}${SPACE}    ${dia_chi}    ${khu_vuc}    ${phuong_xa}
    Wait Until Keyword Succeeds    3x   5s    Assert list of order summarry after execute    ${list_product}    ${list_result_order_summary}
    #
    ${get_no_af_execute}    ${get_tongban_af_execute}    ${get_tongban_tru_trahang_af_execute}    Get Customer Debt from API    ${result_ma_kh}
    Run Keyword If    '${gen_kh}'=='True' or ${get_id_kh}==0    Should Be Equal As Numbers    ${get_no_af_execute}    0    ELSE    Should Be Equal As Numbers    ${get_no_af_execute}    ${get_no_bf_execute}
    Run Keyword If    '${gen_kh}'=='True' or ${get_id_kh}==0    Should Be Equal As Numbers    ${get_tongban_af_execute}    0     ELSE    Should Be Equal As Numbers    ${get_tongban_af_execute}    ${get_tongban_bf_execute}
    Run Keyword If    '${gen_kh}'=='True' or ${get_id_kh}==0    Should Be Equal As Numbers    ${get_tongban_tru_trahang_af_execute}    0     ELSE    Should Be Equal As Numbers    ${get_tongban_tru_trahang_af_execute}     ${get_tongban_tru_trahang_bf_execute}
    Validate history in customer if order is not paid    ${result_ma_kh}    ${ma_dh_kv}
    #
    Delete order frm Order code    ${ma_dh_kv}
    Run Keyword If    '${gen_kh}'=='True'    Delete customer by Customer Code    ${result_ma_kh}

synlzd3
    [Arguments]    ${input_shop_lzd}     ${list_product_price}   ${ten_kh}   ${dien_thoai}    ${dia_chi}   ${khu_vuc}    ${phuong_xa}
    Log    xóa kh cũ
    Delete customer by phone number thr API      ${dien_thoai}
    #
    Log    tính tổng tiền hàng
    ${list_product}   Get Dictionary Keys     ${list_product_price}
    ${list_price}   Get Dictionary Values     ${list_product_price}
    ${result_tongtienhang}      Sum values in list      ${list_price}
    #
    Log    tạo đơn đặt hàng và chuyển trạng thái canceled
    ${list_sku}    Change price sku in lazada client thr API     ${input_shop_lzd}     ${list_product}     ${list_price}
    ${order_number}     Create order Lazada     ${list_sku}   ${ten_kh}   ${dien_thoai}    ${dia_chi}   ${khu_vuc}    ${phuong_xa}
    Update status order Lazada    ${order_number}    ${list_sku}    ${list_price}     ${ten_kh}   ${dien_thoai}    ${dia_chi}   ${khu_vuc}    ${phuong_xa}    canceled
    ${get_oder_id}    Get order id by order number thr API    ${order_number}
    ${ma_dh_kv}   Set Variable    DHLZD_${get_oder_id}
    ${ma_kh}      Set Variable    KHLZD${get_oder_id}
    Wait Until Keyword Succeeds    10x    30s    Assert order exist succeed    ${ma_dh_kv}
    #
    Log    validate af ex
    Assert values by order code until succeed    ${ma_dh_kv}    ${ma_kh}    4    ${result_tongtienhang}    0    0
    Assert Cong no khach hang until succeed    ${ma_kh}    0     0     0
    #
    Delete customer by Customer Code    ${ma_kh}
