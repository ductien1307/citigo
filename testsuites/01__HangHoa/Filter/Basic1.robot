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
Thương hiệu           [Tags]      EP1
                      [Template]    epf3
                      [Documentation]   Filter theo Thương hiệu
                      Hảo hảo

Thuộc tính            [Tags]      EP1
                      [Template]    epf4
                      [Documentation]   Filter theo Thuộc tính
                      MÀU     đỏ

Vị trí                [Tags]     EP1
                      [Template]    epf5
                      [Documentation]   Filter theo Vị trí
                      Vị trí 1

Số bản ghi            [Tags]     EP1      xcc
                      [Template]    epf6
                      [Documentation]   Filter theo Số bản ghi
                      20

*** Keywords ***
epf3
    [Arguments]     ${thuong_hieu}
    Reload Page
    ${get_text_bf}      KV Get Text      ${label_page_hh_infor}
    Click Element    ${cell_filter_chon_thuong_hieu}
    KV Click Element By Code     ${item_thuonghieu_in_dropdow}    ${thuong_hieu}
    Wait Until Keyword Succeeds    3x    3s    Get text UI and validate    ${label_page_hh_infor}   ${get_text_bf}

epf4
    [Arguments]     ${thuoc_tinh}       ${gia_tri}
    Reload Page
    ${get_text_bf}      KV Get Text      ${label_page_hh_infor}
    KV Click Element By Code     ${cell_filter_thuoc_tinh}    ${thuoc_tinh}
    KV Click Element By Code     ${item_thuonghieu_in_dropdow}    ${gia_tri}
    Wait Until Keyword Succeeds    3x    3s    Get text UI and validate    ${label_page_hh_infor}   ${get_text_bf}

epf5
    [Arguments]     ${vi_tri}
    Reload Page
    ${get_text_bf}      KV Get Text      ${label_page_hh_infor}
    Click Element    ${cell_filter_chon_vi_tri}
    KV Click Element By Code     ${item_thuonghieu_in_dropdow}    ${vi_tri}
    Wait Until Keyword Succeeds    3x    3s    Get text UI and validate    ${label_page_hh_infor}   ${get_text_bf}

epf6
    [Arguments]     ${so_ban_ghi}
    Reload Page
    ${get_text_bf}      KV Get Text      ${label_page_hh_infor}
    Click Element    ${dropdown_sobanghi}
    KV Click Element By Code    ${item_sobanghi_in_dropdown}    ${so_ban_ghi}
    Wait Until Keyword Succeeds    3x    3s    Get text UI and validate    ${label_page_hh_infor}   ${get_text_bf}
