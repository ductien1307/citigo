*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}      ${headless_browser}
Test Teardown     After Test
Resource          ../core/Ban_Hang/banhang_action.robot
Resource          ../core/Ban_Hang/banhang_getandcompute.robot
Resource          ../core/share/toast_message.robot
Resource          ../core/share/imei.robot
Resource          ../core/Ban_Hang/banhang_navigation.robot
Resource          ../core/API/api_danhmuc_hanghoa.robot
Resource          ../core/API/api_khachhang.robot
Resource          ../core/API/api_hoadon_banhang.robot
Resource          ../core/API/api_access.robot
Resource          ../core/API/api_thietlap.robot
Resource          ../core/So_Quy/so_quy_list_action.robot
Resource          ../config/env_product/envi.robot
Resource          ../core/share/list_dictionary.robot
Library           NetworkConditions.py
Library           BuiltIn
Library           SeleniumLibrary

*** Variables ***
@{list_branch}    0912432119    0917588789    0912456349   0917776789   0912456789    0917534679
*** Test Cases ***
UI_All                [Tags]        kkk1
                      [Template]     testoff
                      ${list_branch}

*** Keywords ***
testoff
      [Arguments]     ${time}
      ${get_list_id_branh}    Create List
      ${get_res}    Get Request and return body    ${endpoint_branch_list}
      :FOR  ${item1}   IN      @{time}
      \   ${jsonpath_del}   Format String     $..Data[?(@.ContactNumber=="{0}")].Id     ${item1}
      \   ${get_id_branh}   Get data from response json    ${get_res}    ${jsonpath_del}
      \   Append to List    ${get_list_id_branh}   ${get_id_branh}
      :FOR      ${item}     IN      @{get_list_id_branh}
      \     Run Keyword If    '${item}'=='0'    Log     Ignore     ELSE      Delete Branch    ${item}
