*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    ${headless_browser}
Test Setup        Before Test BC Ban Hang
Test Teardown     After Test
Library           String
Library           DateTime
Library           Collections
Resource          ../../core/API/api_hoadon_banhang.robot
Resource          ../../core/API/api_trahang.robot
Resource          ../../config/env_product/envi.robot
Resource          ../../core/API/api_tongquan.robot
Resource          ../../core/API/api_khachhang.robot
Resource          ../../core/API/api_mhbh.robot
Resource          ../../core/Bao_cao/bc_list_page.robot
Resource          ../../core/Bao_cao/bc_hang_hoa_list_action.robot
Resource          ../../core/Bao_cao/bc_hang_hoa_list_page.robot
Resource          ../../core/Bao_cao/bc_ban_hang_list_action.robot
Resource          ../../prepare/Hang_hoa/Sources/doitac.robot
Resource          ../../core/API/api_danhmuc_hanghoa.robot

*** Variables ***

*** Test Cases ***
Theo thang            [Tags]    TQ1
                      [Template]    dtkg1
                      1

Theo ngay             [Tags]     TQ1
                      [Template]    dtkg2
                      1

Theo gio              [Tags]     TQ1
                      [Template]    dtkg3
                      1

Theo thu              [Tags]     TQ1
                      [Template]    dtkg4
                      1

*** Keywords ***
dtkg1
      [Arguments]    ${item}
      Wait Until Element Is Visible    ${checkbox_bao_cao}    2 min
      Click Element      ${checkbox_bao_cao}
      Wait Until Element Is Visible    ${label_filter_thoigian}   2 mins
      Click Element    ${label_filter_thoigian}
      Wait Until Element Is Visible    ${link_filter_thangnay}   2 mins
      Click Element    ${link_filter_thangnay}
      Sleep    5s
      ${get_dt_thuan_dashboard}    Get Text    ${label_doanhthu_thuan}
      ${get_dt_thuan_dashboard}     Replace String    ${get_dt_thuan_dashboard}    ,    ${EMPTY}
      ${get_dt_thuan_bc}    Get net revenue this month in dashboard
      Should Be Equal As Numbers        ${get_dt_thuan_dashboard}    ${get_dt_thuan_bc}

dtkg2
      [Arguments]    ${item}
      Wait Until Element Is Visible    ${checkbox_bao_cao}    1 min
      Click Element      ${checkbox_bao_cao}
      Wait Until Page Contains Element    ${label_doanhthu_thuan_theo_thoigian}   1 min
      ${get_dt_thuan_dashboard}    Get Text    ${label_doanhthu_thuan_theo_thoigian}
      ${get_dt_thuan_dashboard}     Replace String    ${get_dt_thuan_dashboard}    ,    ${EMPTY}
      ${get_dt_thuan_bc}    Get net revenue current date in dashboard
      Should Be Equal As Strings    ${get_dt_thuan_dashboard}    ${get_dt_thuan_bc}

dtkg3
      [Arguments]    ${item}
      Wait Until Element Is Visible    ${checkbox_bao_cao}    1 min
      Click Element     ${checkbox_luachonkhac}
      Click Element      ${checkbox_bao_cao}
      Wait Until Page Contains Element    ${label_doanhthu_thuan_theo_thoigian}   1 min
      ${get_dt_thuan_dashboard}    Get Text    ${label_doanhthu_thuan_theo_thoigian}
      ${get_dt_thuan_dashboard}     Replace String    ${get_dt_thuan_dashboard}    ,    ${EMPTY}
      ${get_gio}      Get Text    ${label_gio}
      ${get_dt_thuan_bc}    Get net revenue current hour in dashboard     ${get_gio}
      Should Be Equal As Strings    ${get_dt_thuan_dashboard}    ${get_dt_thuan_bc}

dtkg4
      [Arguments]    ${item}
      Wait Until Element Is Visible    ${checkbox_bao_cao}    1 min
      Click Element      ${checkbox_bao_cao}
      Wait Until Page Contains Element    ${label_doanhthu_thuan_theo_thoigian}   1 min
      ${get_dt_thuan_dashboard}    Get Text    ${label_doanhthu_thuan_theo_thoigian}
      ${get_dt_thuan_dashboard}     Replace String    ${get_dt_thuan_dashboard}    ,    ${EMPTY}
      ${get_dt_thuan_bc}    Get net revenue current day in dashboard
      Should Be Equal As Strings    ${get_dt_thuan_dashboard}    ${get_dt_thuan_bc}
