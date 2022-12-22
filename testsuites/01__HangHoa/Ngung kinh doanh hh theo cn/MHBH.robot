*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}      ${headless_browser}
Test Setup        Before Test Ban Hang
Test Teardown     After Test
Resource          ../../../core/hang_hoa/hang_hoa_add_action.robot
Resource          ../../../core/hang_hoa/hang_hoa_add_page.robot
Resource          ../../../core/share/toast_message.robot
Resource          ../../../config/env_product/envi.robot
Resource          ../../../core/hang_hoa/danh_muc_list_action.robot
Resource          ../../../prepare/Hang_hoa/Sources/hanghoa.robot
Resource          ../../../core/Dat_Hang/dat_hang_action.robot
Resource          ../../../core/Dat_Hang/dat_hang_navigation.robot
Resource          ../../../core/Dat_Hang/dat_hang_page.robot
Resource          ../../../core/API/api_dathang.robot
Resource          ../../../core/API/api_mhbh_dathang.robot

*** Variables ***

*** Test Cases ***    Mã hh            Tên           Nhóm
Search hàng ngừng kd       [Tags]       EP1
                      [Template]       enkd4
                      HTKDAT0004         ABC       Dịch vụ

BH - DH ngừng kd           [Tags]
                      [Template]       enkd5
                      HTKDAT0005         CDE       Dịch vụ

Lưu DH --Xử lý DH          [Tags]
                      [Template]       enkd6
                      HTKDAT0006         CDE       Dịch vụ        KH042

Doi tra hang               [Tags]       EP1
                      [Template]       enkd7
                      HTKDAT0007         CDE       Dịch vụ


*** Keywords ***
enkd4
    [Arguments]    ${ma_hh}     ${ten_sp}    ${ten_nhom}
    Delete product if product is visible thr API    ${ma_hh}
    Add product thr API    ${ma_hh}    ${ten_sp}    ${ten_nhom}    500000     30000       5
    Set inactive for poduct thr API     ${ma_hh}
    Reload Page
    Sleep    5s
    Wait Until Page Contains Element    ${textbox_bh_search_ma_sp}    1 min
    Input text    ${textbox_bh_search_ma_sp}    ${ma_hh}
    Press Key    ${textbox_bh_search_ma_sp}    ${ENTER_KEY}
    Element Should Contain    ${toast_message}    Không tìm thấy sản phẩm
    Delete product thr API    ${ma_hh}

enkd5
    [Arguments]    ${ma_hh}     ${ten_sp}    ${ten_nhom}
    Delete product if product is visible thr API       ${ma_hh}
    Add product thr API    ${ma_hh}    ${ten_sp}    ${ten_nhom}    500000     30000       5
    Reload Page
    Wait Until Keyword Succeeds    3 times    3s    Input data in textbox and wait until it is visible    ${textbox_bh_search_ma_sp}    ${ma_hh}    ${cell_sanpham}
    ...    ${cell_bh_ma_sp}
    Set inactive for poduct thr API     ${ma_hh}
    Sleep    2s
    Click Element JS    ${button_bh_thanhtoan}
    Wait Until Page Contains Element    ${toast_message}    1 min
    Wait Until Element Contains    ${toast_message}    không được phép bán
    Sleep    3s
    Wait Until Keyword Succeeds    3 times    5 s    Click Element JS    ${tab_dathang}
    Wait Until Keyword Succeeds    3 times    5 s    Click Element JS    ${button_bh_dathang}
    Wait Until Keyword Succeeds    3 times    5 s    Click Element JS    ${button_dongy_popup_nocustomer}
    Wait Until Page Contains Element    ${toast_message}    1 min
    Wait Until Element Contains    ${toast_message}    không được phép bán
    Delete product thr API    ${ma_hh}

enkd6
    [Arguments]    ${ma_hh}     ${ten_sp}    ${ten_nhom}    ${ma_kh}
    ${get_pr_id}    Get product ID    ${ma_hh}
    Run Keyword If    '${get_pr_id}'=='0'    Log    Ignore pr    ELSE       Delete product thr API    ${ma_hh}
    Add product thr API    ${ma_hh}    ${ten_sp}    ${ten_nhom}    500000     30000       5
    ${order_code}     Add new order frm API    ${ma_kh}    ${ma_hh}    2    30000
    Set inactive for poduct thr API     ${ma_hh}
    Reload Page
    Go to xu ly dat hang    ${order_code}
    Wait Until Page Contains Element    ${button_luu_order}    1 min
    Click Element JS    ${button_luu_order}
    Wait Until Page Contains Element    ${toast_message}    1 min
    Element Should Contain      ${toast_message}    không được phép bán
    Sleep    3s
    Go to BH frm process order    ${order_code}
    Click Element JS    ${button_bh_thanhtoan}
    Wait Until Page Contains Element    ${toast_message}    1 min
    Element Should Contain      ${toast_message}    không được phép bán
    Delete product thr API    ${ma_hh}

enkd7
    [Arguments]    ${ma_hh}     ${ten_sp}    ${ten_nhom}
    Delete product if product is visible thr API     ${ma_hh}
    Add product thr API    ${ma_hh}    ${ten_sp}    ${ten_nhom}    500000     30000       5
    Set inactive for poduct thr API     ${ma_hh}
    Reload Page
    Select Return without Invoice from BH page
    Wait Until Keyword Succeeds    3x    8s    Input product in textbox and click   ${ma_hh}
    KV Click Element JS    ${button_dongy_trahang_ngungkd}
    Input text       ${textbox_th_search_hangdoi}     ${ma_hh}
    Press Key    ${textbox_th_search_hangdoi}    ${ENTER_KEY}
    Element Should Contain    ${toast_message}    Không tìm thấy sản phẩm
    Delete product thr API    ${ma_hh}
