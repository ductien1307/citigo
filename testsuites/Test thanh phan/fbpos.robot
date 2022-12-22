*** Settings ***
Suite Setup       Setup Test Suite    Before Test Facebook POS
Suite Teardown    After Test
Test Teardown     Run Keyword If Test Failed    Fail    Hãy check lại fbPos
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
Facebook POS          [Tags]          CTP1
                      [Template]      fb1
                      [Documentation]   Tạo đơn đặt hàng thành công trên fbPos
                      [Timeout]     10 minutes
                      TP019

*** Keywords ***
fb1
    [Arguments]     ${ma_hh}
    Close popup printer
    KV Click Element    ${cell_fb_frirt_conversation}
    KV Click Element JS    ${button_fb_donmoi}
    Search product in FBPos    ${ma_hh}
    KV Click Element JS    ${button_fb_dathang}
    Invoice fnb message success validation
