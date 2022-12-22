*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    ${headless_browser}
Library           SeleniumLibrary
Resource         ../../../../core/Thiet_lap/thiet_lap_nav.robot
Resource         ../../../../core/Thiet_lap/thiet_lap_cuahang_list_action.robot
Resource         ../../../../core/API/api_thietlap.robot
Resource         ../../../../core/API/api_shopee.robot
Resource         ../../../../core/API/api_mhbh_dathang.robot
Resource         ../../../../core/API/api_hoadon_banhang.robot
Resource         ../../../../core/API/api_dathang.robot
Resource         ../../../../core/API/api_trahang.robot
Resource         ../../../../core/API/api_hanghoa.robot
Resource         ../../../../core/API/api_danhmuc_hanghoa.robot
Resource         ../../../../share/constants.robot
Resource         ../../../../prepare/Hang_hoa/Sources/hanghoa.robot

*** Variables ***
&{list_prs_num}        TPC001=3
&{list_prs_num1}        TPC002=2
&{list_prs_num2}        KLDV004=2
&{list_prs_num3}        KLCB004=2
&{list_prs_num4}        KLQD004=2
@{list_shopee}     SHIPPED   TO_CONFIRM_RECEIVE     CANCELLED
@{list_shopee1}    SHIPPED   TO_CONFIRM_RECEIVE     COMPLETED
@{list_shopee2}    SHIPPED   TO_CONFIRM_RECEIVE

*** Test Cases ***      Tên shop      SP-SL             Giá bán       Giảm giá      Khách hàng            Khu vực                    Địa chỉ                   SDT               Trạng thái đơn shopee
Sync order                 [Tags]          SPEO
                        [Template]    sync_shopee1
                        [Timeout]     15 minutes
                        thanhptk     ${list_prs_num}       80000          0         Test kh shopee       Quận Hoàn Kiếm              Nguyễn Du                  098745214         True
                        thanhptk     ${list_prs_num2}       75000        2000         test               Quận Hoàn Kiếm             Nguyễn Du                  0987545632        False

Create invoice             [Tags]         SPEO
                        [Template]    sync_shopee3
                        [Timeout]     15 minutes
                        thanhptk     ${list_prs_num3}       125000        3000        test               Quận Hoàn Kiếm              Nguyễn Du                  098756325         ${list_shopee1}
                        thanhptk     ${list_prs_num4}       45000         2000        test               Quận Hoàn Kiếm             Nguyễn Du                  098965896         ${list_shopee2}
                        thanhptk     ${list_prs_num}       95000          2000         test              Quận Hoàn Kiếm             Nguyễn Du                  0832698745        ${list_shopee}

*** Keywords ***
sync_shopee1
    [Arguments]    ${input_shop_shopee}     ${list_product_num}       ${input_price}    ${giam_gia_dh}    ${ten_kh}     ${dia_chi}   ${phuong_xa}   ${dien_thoai}     ${gen_kh}
    Log    tính tổng tiền hàng, số lượng đặt
    ${list_product}   Get Dictionary Keys     ${list_product_num}
    ${list_nums}   Get Dictionary Values     ${list_product_num}
    ${list_tongso_dh}    Computation list result order summary af excute    ${list_product}   ${list_nums}
    ${result_tongtienhang}    Multiplication and round    ${input_price}     ${list_nums[0]}
    ${result_khachcantra}      Minus   ${result_tongtienhang}      ${giam_gia_dh}
    #
    Log    tinh cong no kh
    Log    ${gen_kh}=True : Xóa kh cũ
    ${get_id_kh}   ${get_ma_kh}    Get customer id and code by number phone thr API   ${dien_thoai}
    Run Keyword If    ${get_id_kh}!=0 and '${gen_kh}'=='True'    Delete customer   ${get_id_kh}
    ${get_no_bf_execute}    ${get_tongban_bf_execute}    ${get_tongban_tru_trahang_bf_execute}    Run Keyword If    ${get_id_kh}!=0 and ${gen_kh}!=True    Get Customer Debt from API    ${get_ma_kh}
    #
    Log    tạo đơn đặt hàng shopee
    ${get_ma_dh_shopee}    Create order Shopee thr API      ${input_shop_shopee}  ${list_product_num}    ${input_price}     ${giam_gia_dh}    ${ten_kh}     ${dia_chi}   ${phuong_xa}   ${dien_thoai}
    ${ma_dh_kv}   Set Variable    DHSPE_${get_ma_dh_shopee}
    ${ma_kh}      Set Variable    KHSPE${get_ma_dh_shopee}
    ${result_ma_kh}   Set Variable If    '${gen_kh}'!='True' and ${get_id_kh}!=0   ${get_ma_kh}    ${ma_kh}
    Wait Until Keyword Succeeds    10x    30s    Assert order exist succeed    ${ma_dh_kv}
    #Get audit trail no payment info and validate    ${ma_dh_kv}    Đồng bộ Shopee    Đồng bộ đặt hàng
    #assert value order
    Log    validate af ex
    Assert values by order code until succeed    ${ma_dh_kv}    ${result_ma_kh}    1    ${result_khachcantra}    0    ${giam_gia_dh}
    Assert delivery info by order code until succeed    ${ma_dh_kv}    SHOPEE    ${ten_kh}    0    ${dia_chi}    ${phuong_xa}
    Assert list of order summarry after execute    ${list_product}    ${list_tongso_dh}
    #
    ${get_no_af_execute}    ${get_tongban_af_execute}    ${get_tongban_tru_trahang_af_execute}    Get Customer Debt from API    ${result_ma_kh}
    Run Keyword If    '${gen_kh}'=='True' or ${get_id_kh}==0    Should Be Equal As Numbers    ${get_no_af_execute}    0    ELSE    Should Be Equal As Numbers    ${get_no_af_execute}    ${get_no_bf_execute}
    Run Keyword If    '${gen_kh}'=='True' or ${get_id_kh}==0    Should Be Equal As Numbers    ${get_tongban_af_execute}    0     ELSE    Should Be Equal As Numbers    ${get_tongban_af_execute}    ${get_tongban_bf_execute}
    Run Keyword If    '${gen_kh}'=='True' or ${get_id_kh}==0    Should Be Equal As Numbers    ${get_tongban_tru_trahang_af_execute}    0     ELSE    Should Be Equal As Numbers    ${get_tongban_tru_trahang_af_execute}     ${get_tongban_tru_trahang_bf_execute}
    Validate history in customer if order is not paid    ${result_ma_kh}    ${ma_dh_kv}
    #
    Delete order frm Order code    ${ma_dh_kv}
    Run Keyword If    '${gen_kh}'=='True'    Delete customer by Customer Code    ${result_ma_kh}

sync_shopee3
    [Arguments]    ${input_shop_shopee}     ${list_product_num}       ${input_price}    ${giam_gia_dh}    ${ten_kh}     ${dia_chi}   ${phuong_xa}   ${dien_thoai}     ${list_trangthai_shopee}
    ${get_id_kh}   ${get_ma_kh}    Get customer id and code by number phone thr API   ${dien_thoai}
    Run Keyword If    ${get_id_kh}!=0     Delete customer   ${get_id_kh}
    Log   check trạng thái đơn hàng, vận đơn
    ${result_trangthai_hoadon}       ${result_trangthai_vandon}      ${result_status_vandon}    Check status order and status delivery Shopee    ${list_trangthai_shopee}
    #
    Log    tính tổng tiền hàng, tồn kho
    ${list_product}   Get Dictionary Keys     ${list_product_num}
    ${list_nums}   Get Dictionary Values     ${list_product_num}
    ${result_tongtienhang}    Multiplication and round    ${input_price}     ${list_nums[0]}
    ${result_khachcantra}      Minus   ${result_tongtienhang}      ${giam_gia_dh}
    ${get_list_product_type}    ${get_list_imei_status}      Get list product type and imei status frm API   ${list_product}
    ${result_onhand}   Get onhand frm API       ${list_product[0]}
    ${result_onhand}      Minus    ${result_onhand}    ${list_nums[0]}
    ${result_onhand_af_ex}      Run Keyword If    ${get_list_product_type[0]}==1 or ${get_list_product_type[0]}==3     Set Variable      0     ELSE    Set Variable      ${result_onhand}
    ${list_result_onhand_af_ex}   Create List    ${result_onhand_af_ex}
    #
    Log    tạo đơn shopee và chuyển trạng thái
    ${get_ma_dh_shopee}    Create order Shopee thr API      ${input_shop_shopee}  ${list_product_num}    ${input_price}     ${giam_gia_dh}    ${ten_kh}     ${dia_chi}   ${phuong_xa}   ${dien_thoai}
    Update order status Shopee thr API    ${input_shop_shopee}   ${get_ma_dh_shopee}   READY_TO_SHIP     LOGISTICS_READY
    ${ma_dh_kv}   Set Variable    DHSPE_${get_ma_dh_shopee}
    ${ma_hd_kv}   Set Variable    HDSPE_${get_ma_dh_shopee}
    ${ma_kh}      Set Variable    KHSPE${get_ma_dh_shopee}
    Wait Until Keyword Succeeds    10x    30s    Assert order exist succeed    ${ma_dh_kv}
    Wait Until Keyword Succeeds    10x    30s    Assert invoice exist succeed    ${ma_hd_kv}
    :FOR      ${item_trangthai_shopee}   IN ZIP     ${list_trangthai_shopee}
    \     Run Keyword If     '${item_trangthai_shopee}'=='READY_TO_SHIP'    Update order status Shopee thr API    ${input_shop_shopee}   ${get_ma_dh_shopee}    ${item_trangthai_shopee}     LOGISTICS_READY
    \     ...   ELSE IF     '${item_trangthai_shopee}'=='TO_CONFIRM_RECEIVE'      Update order status Shopee thr API    ${input_shop_shopee}   ${get_ma_dh_shopee}    ${item_trangthai_shopee}    none    ELSE IF     '${item_trangthai_shopee}'=='CANCELLED'     Update logistics status Shopee thr API      ${get_ma_dh_shopee}      ${item_trangthai_shopee}    LOGISTICS_DELIVERY_FAILED
    \     ...   ELSE IF     '${item_trangthai_shopee}'=='COMPLETED'     Update logistics status Shopee thr API     ${get_ma_dh_shopee}      ${item_trangthai_shopee}    	LOGISTICS_DELIVERY_DONE
    #Get audit trail no payment info and validate    ${ma_hd_kv}    Đồng bộ Shopee    Đồng bộ hóa đơn
    #
    Log    validate af ex
    Assert values by order code until succeed    ${ma_dh_kv}    ${ma_kh}    3    ${result_khachcantra}    0    ${giam_gia_dh}
    Assert values by invoice code until succeed    ${ma_hd_kv}     ${result_khachcantra}    ${result_tongtienhang}    ${ma_kh}    0    ${giam_gia_dh}    ${result_trangthai_hoadon}
    Assert delivery info by invoice code until succeed    ${ma_hd_kv}    SHOPEE    ${ten_kh}    ${dien_thoai}    0    ${dia_chi}    ${phuong_xa}    ${result_status_vandon}    1
    Assert Cong no khach hang until succeed   ${ma_kh}   ${result_khachcantra}   ${result_khachcantra}   ${result_khachcantra}
    Assert list of Onhand after execute      ${list_product}    ${list_result_onhand_af_ex}
    #
    #Log    assert LSTT
    #${ton}    Replace floating point    ${list_result_onhand_af_ex[0]}
    #${list_audit_db}     Create list audit trail for sync product       ${list_product[0]}   none     ${ton}
    #Assert audit trail by action name       ${list_product[0]}    Đồng bộ hàng hóa    ${list_audit_db[0]}
    Delete invoice by invoice code    ${ma_hd_kv}
    Delete order frm Order code    ${ma_dh_kv}
    Delete customer by Customer Code    ${ma_kh}
