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
@{list_tt_1}      xanh    đỏ

*** Test Cases ***    Mã hh          Tên           Nhóm       Giá vốn    Giá bán    Tồn kho         Thuộc tính   Tên tt              Thương hiệu
Them                  [Tags]            EP1
                      [Template]    epth5
                      [Documentation]   Thêm mới hàng thuộc tính có mã vạch
                      H2MTT0001     GreenCross    Dịch vụ    80000      60000      2               MÀU           ${list_tt_1}       Mac

*** Keywords ***
epth5
    [Arguments]   ${ma_hh}   ${ten_hanghoa}    ${nhom_hang}    ${giavon}    ${giaban}    ${tonkho}    ${attr}
    ...    ${list_attr}     ${ten_thuong_hieu}
    ${list_pr_del}      Create List    ${ma_hh}   ${ma_hh}-1    ${ma_hh}-2
    Delete list product if list product is visible thr API       ${list_pr_del}
    Reload Page
    Go to Them moi Hang Hoa
    ${ma_vach}    Generate code automatically    MVAT
    Input data in Them hang hoa form    ${ma_hh}    ${ten_hanghoa}    ${nhom_hang}    ${giaban}    ${giavon}    ${tonkho}
    input data      ${textbox_mavach}     ${ma_vach}
    Select thuong hieu    ${ten_thuong_hieu}
    Input attributes in Them hang hoa form    ${attr}    ${list_attr}
    Click Element    ${button_luu}
    KV Click Element   ${button_dongy_apdung_giavon}
    Product create success validation
    Wait Until Keyword Succeeds    3 times    3s   Assert data in case create product have trade mark name   ${ma_hh}    ${ma_vach}    ${ten_hanghoa} - ${list_attr[0]}    ${nhom_hang}
    ...    ${tonkho}    ${giavon}    ${giaban}    ${ten_thuong_hieu}
    ${list_hang_thuoc_tinh_actual}   Assert count of attribute product and return list attribute product     ${ma_hh}    ${list_attr}
    Assert list data in case create product have trade mark name    ${list_hang_thuoc_tinh_actual}    0    ${ten_hanghoa}    ${nhom_hang}
    ...    ${tonkho}    ${giavon}    ${giaban}    ${ten_thuong_hieu}
    Delete list product if list product is visible thr API    ${list_hang_thuoc_tinh_actual}
