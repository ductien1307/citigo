*** Settings ***
Suite Setup       Setup Test Suite    Before Test Quan ly
Suite Teardown    After Test
Test Teardown     Run Keyword If Test Failed    Fail    Hãy check lại Internal API
Resource          ../../core/Thiet_lap/thiet_lap_nav.robot
Resource          ../../core/Thiet_lap/thiet_lap_cuahang_list_action.robot
Resource          ../../core/MyKiot/mykiot_list_action.robot
Resource          ../../core/API/api_thietlap.robot
Resource          ../../config/env_product/envi.robot
Resource          ../../core/API/api_public.robot
Resource          ../../core/API/api_dathang.robot
Resource          ../../core/API/api_mhbh_dathang.robot
Resource          ../../core/API/api_danhmuc_hanghoa.robot
Resource          ../../prepare/Hang_hoa/Sources/hanghoa.robot
Library           SeleniumLibrary
Resource          ../../core/share/global.robot

*** Test Cases ***    Tên hh   Tên nhóm   Giá bán   Giá vốn   Tồn kho   Người nhận   Số điện thoại
Internal              [Tags]            CTP
                      [Template]        inter1
                      [Documentation]   TẠO HÀNG HÓA TRÊN KV - CHECK ĐỒNG BỘ LÊN MYKIOT - TẠO ĐƠN ĐẶT HÀNG TRÊN MYKIOT - CHECK ĐỒNG BỘ VỀ KV
                      [Timeout]         20 minutes
                      Test internal API   Mỹ phẩm   50000   40000   30   Test internal   0123456789

*** Keywords ***
inter1
    [Arguments]       ${input_ten_hh}    ${input_ten_nhom}   ${input_giaban}    ${input_giavon}   ${input_tonkho}    ${input_nguoinhan}    ${input_sdt}
    ${input_ma_hh}      Generate Random String    6    [UPPER][NUMBERS]
    Add product thr API   ${input_ma_hh}    ${input_ten_hh}    ${input_ten_nhom}   ${input_giaban}    ${input_giavon}   ${input_tonkho}
    Go to Web ban hang
    Wait Until Keyword Succeeds    3x    4s    Select Window     url = https://admin.mykiot.vn/
    Reload Page
    KV Click Element    ${button_mykiot_dongbo_thucong}
    Wait Loading Icon Mykiot Invisible
    Wait Until Keyword Succeeds    3x    1s    Go to Hang hoa MyKiot
    Wait Until Keyword Succeeds    10x    10s    Search product in MyKiot    ${input_ma_hh}
    Assert Ton kho, gia ban in MyKiot    ${input_ma_hh}    ${input_tonkho}    ${input_giaban}
    KV Click Element By Code    ${button_mykiot_xemngay}    ${input_ma_hh}
    Wait Until Keyword Succeeds    3x    3s    Select Window     title =${input_ten_hh}
    Add product to cart and pay    ${input_nguoinhan}    ${input_sdt}
    Go To     https://admin.mykiot.vn/order
    Reload Page
    ${get_ma_dh}    Get Text Global    ${text_mykiot_ma_dathang_first}
    Wait Until Keyword Succeeds    5x    10s    Assert order exist succeed    ${get_ma_dh}
    Delete order frm Order code    ${get_ma_dh}
    [Teardown]    Delete product thr API    ${input_ma_hh}
