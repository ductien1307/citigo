*** Settings ***
Suite Setup       Setup Test Suite    Before Test Hang Hoa
Suite Teardown    After Test
Resource          ../../../core/hang_hoa/hang_hoa_add_action.robot
Resource          ../../../core/hang_hoa/hang_hoa_add_page.robot
Resource          ../../../core/share/toast_message.robot
Resource          ../../../config/env_product/envi.robot
Resource          ../../../prepare/Hang_hoa/Sources/hanghoa.robot
Resource          ../../../core/hang_hoa/danh_muc_list_action.robot
Resource          ../../../core/api/api_hanghoa.robot

*** Variables ***

*** Test Cases ***
Loại hàng             [Tags]     EP1
                      [Template]    epf1
                      [Documentation]   Filter theo loại hàng hóa
                      Hàng hóa
                      #Hàng hóa - Serial/IMEI
                      Hàng hóa - sản xuất
                      Dịch vụ
                      Combo - Đóng gói

Nhóm hàng             [Tags]      EP1
                      [Template]    epf2
                      [Documentation]   Filter theo nhóm hàng
                      Đồ ăn vặt

Tồn kho               [Tags]      EP1
                      [Template]    epf1
                      [Documentation]   Filter theo loại tồn kho
                      Dưới định mức tồn
                      Vượt định mức tồn
                      Còn hàng trong kho
                      Hết hàng trong kho

Tích điểm             [Tags]      EP1
                      [Template]    epf1
                      [Documentation]   Filter theo tích điểm
                      Tích điểm
                      Không tích điểm

Bán trực tiếp         [Tags]      EP1
                      [Template]    epf1
                      [Documentation]   Filter theo Bán trực tiếp
                      Được bán trực tiếp
                      Không được bán trực tiếp

Bảo hành bảo trì      [Tags]      EP1
                      [Template]    epf1
                      [Documentation]   Filter theo bảo hành bảo trì
                      Có bảo hành, bảo trì
                      Không bảo hành, bảo trì

Lựa chọn hiển thị     [Tags]      EP1
                      [Template]    epf1
                      [Documentation]   Filter theo Lựa chọn hiển thị
                      Hàng ngừng kinh doanh

*** Keywords ***
epf1
    [Arguments]     ${loai_hang}
    Reload Page
    ${get_text_bf}      KV Get Text      ${label_page_hh_infor}
    KV Click Element By Code   ${checkbox_filter_hang_hoa}   ${loai_hang}
    Wait Until Keyword Succeeds    3x    3s    Get text UI and validate    ${label_page_hh_infor}   ${get_text_bf}

epf2
    [Arguments]     ${nhom_hang}
    Reload Page
    ${get_text_bf}      KV Get Text      ${label_page_hh_infor}
    KV Click Element By Code    ${cell_filter_nhom_hang}    ${nhom_hang}
    Wait Until Keyword Succeeds    3x    3s    Get text UI and validate    ${label_page_hh_infor}   ${get_text_bf}
