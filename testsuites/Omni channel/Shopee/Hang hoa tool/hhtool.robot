*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    ${headless_browser}
Test Setup        Before Test Quan ly
Test Teardown     After Test
Library           SeleniumLibrary
Resource          ../../../../core/Thiet_lap/thiet_lap_nav.robot
Resource          ../../../../core/Thiet_lap/thiet_lap_cuahang_list_action.robot
Resource          ../../../../core/API/api_thietlap.robot
Resource          ../../../../core/API/api_shopee.robot
Resource          ../../../../core/API/api_mhbh.robot
Resource          ../../../../core/API/api_phieu_nhap_hang.robot
Resource          ../../../../share/constants.robot
Resource          ../../../../prepare/Hang_hoa/Sources/hanghoa.robot
Resource          ../../../../core/hang_hoa/hang_hoa_add_action.robot
Resource          ../../../../core/hang_hoa/hang_hoa_add_page.robot
Resource          ../../../../core/hang_hoa/danh_muc_list_action.robot
Resource          ../../../../core/Shopee_UAT/shopee_banhang_action.robot

*** Variables ***
&{dict_sp}    TPC005=1

*** Test Cases ***      Tên shop Shopee     Mật khẩu        Mã hh         Tên sp           Nhóm hàng    Giá vốn    Mã hh Shopee
Map product             [Tags]
                        [Template]    toolsp1
                        [Timeout]     8 minutes
                        thanhptk            Shopee123       ShopeeMAP       Test map Shopee     Mỹ phẩm     70000      20007508


*** Keywords ***
toolsp1
    [Arguments]     ${shop_shopee}    ${mk_shopee}    ${ma_hh}    ${ten_sp}    ${ten_nhom}     ${gia_von}    ${ma_hh_shopee}
    Delete product if product is visible thr API    ${ma_hh}
    ${get_cur_date}     Get Current Date    result_format=%Y-%m-%d %H:%M:%S
    ${giaban_random}    Generate Random String      2     [NUMBERS]
    ${ton}    Generate Random String      2     [NUMBERS]
    ${gia_ban}    Set Variable    1${giaban_random}000
    Add product thr API    ${ma_hh}    ${ten_sp}    ${ten_nhom}    ${gia_ban}    ${gia_von}    ${ton}
    Go to Shopee integration
    Open popup Lien ket hang hoa Shopee
    Mapping product with Shopee    ${ma_hh}    ${ma_hh_shopee}
    Wait Until Page Contains Element    ${toast_message}      1 min
    Element Should Contain    ${toast_message}    Liên kết hàng thành công
    ${get_lstt_thoigian_lk}   ${get_lstt_thaotac_lk}    ${get_lstt_noidung_lk}    ${get_id_lstt_lk}    Get audit trail info thr API     ${ma_hh}    Liên kết kênh bán
    Should Be Equal As Strings    ${get_lstt_thaotac_lk[0]}    Thêm mới
    Should Be Equal As Strings    ${get_lstt_noidung_lk[0]}    Thêm mới liên kết hàng hóa: Shopee shop: ${shop_shopee} - ${ma_hh}
    ${get_lstt_thoigian}   ${get_lstt_thaotac}    ${get_lstt_noidung}    ${get_id_lstt}    Wait Until Keyword Succeeds    10 times    20s     Get two audit trail succeed     ${get_cur_date}    ${ma_hh}    Đồng bộ Shopee
    ${list_lstt_noidung}  Create List
    :FOR    ${item}     IN RANGE    2
    \     Append To List      ${list_lstt_noidung}      ${get_lstt_noidung[${item}]}
    Log    ${list_lstt_noidung}
    ${gia_ban_conv}    Convert from number to vnd discount text    ${gia_ban}    000    ,000
    List Should Contain Value   ${list_lstt_noidung}    Đồng bộ thông tin giá bán hàng hóa: Shopee shop: ${shop_shopee}, Bảng giá bán: Bảng giá chung- ${ma_hh} thành công: Giá bán: ${gia_ban_conv}${SPACE}
    List Should Contain Value   ${list_lstt_noidung}    Đồng bộ thông tin số lượng hàng hóa sẵn bán: Shopee shop: ${shop_shopee}, Số lượng sẵn bán: = Tồn kho - ${ma_hh} thành công: SL sẵn bán: ${ton}${SPACE}
    Should Be Equal As Strings    ${get_lstt_thaotac[0]}    Đồng bộ hàng hóa
    Should Be Equal As Strings    ${get_lstt_thaotac[1]}    Đồng bộ hàng hóa
    Go To    https://banhang.uat.shopee.vn/
    Login Shopee Ban Hang UAT    ${shop_shopee}    ${mk_shopee}
    Go To    https://banhang.uat.shopee.vn/portal/product/list/all?page=1&search=sku&keyword=${ma_hh_shopee}
    Wait Until Keyword Succeeds    5x    1 min    Assert gia in Shopee    ${gia_ban}
    Wait Until Keyword Succeeds    5x    1 min    Assert kho hang in Shopee      ${ton}
    Delete product thr API    ${ma_hh}
