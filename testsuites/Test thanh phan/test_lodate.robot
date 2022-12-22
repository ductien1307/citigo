*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    ${headless_browser}
Test Teardown     Run Keyword If Test Failed    Fail    Hãy check lại Lodate
Resource          ../../core/Facebook/fbpos_list_action.robot
Resource          ../../core/API/api_thietlap.robot
Resource          ../../config/env_product/envi.robot
Resource          ../../core/API/api_public.robot
Resource          ../../core/API/api_dathang.robot
Resource          ../../core/API/api_mhbh_dathang.robot
Resource          ../../core/API/api_danhmuc_hanghoa.robot
Resource          ../../prepare/Hang_hoa/Sources/hanghoa.robot
Resource          ../../core/share/toast_message.robot

*** Test Cases ***
Facebook POS          [Tags]              CTP
                      [Template]          ld1
                      [Timeout]           10 minutes
                      [Documentation]     MHQL - THÊM MỚI HÀNG HÓA LODATE VÀ NHẬP HÀNG QUA API
                      TESTLODATE   Test hh lodate   Mỹ phẩm   40000   3

*** Keywords ***
ld1
    [Arguments]     ${ma_hh}    ${ten_hanghoa}   ${nhom_hang}   ${gia_ban}   ${input_ton}
    Delete product if product is visible thr API       ${ma_hh}
    Add lodate product thr API      ${ma_hh}    ${ten_hanghoa}   ${nhom_hang}   ${gia_ban}
    ${tenlo_by_product}    Get lot name list and import lot for product    ${ma_hh}    ${input_ton}
    Wait Until Keyword Succeeds    3x   3s    Assert data in case create product    ${ma_hh}    ${ten_hanghoa}    ${nhom_hang}    ${input_ton}    0    ${giaban}
    Delete product thr API    ${ma_hh}
