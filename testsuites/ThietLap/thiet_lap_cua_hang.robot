*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    ${headless_browser}
Test Setup        Before Test Quan ly
Test Teardown     After Test
Library           SeleniumLibrary
Resource         ../../core/Thiet_lap/thiet_lap_nav.robot
Resource         ../../core/Thiet_lap/thiet_lap_cuahang_list_action.robot
Resource         ../../core/API/api_thietlap.robot
Resource         ../../share/constants.robot

*** Test Cases ***      Electric
Config                 [Tags]         TL
                        [Template]    config01
                        True

Connect Zalo             [Tags]        ZL
                        [Template]    ezl1
                        562408683       abc123

*** Keywords ***
config01
      [Arguments]     ${input_electric}
      Set Selenium Speed    0.5s
      Turn off value in shop config by api    ${input_electric}
      Go to any thiet lap    ${button_thieplap_cuahang}
      Sleep    4s
      Wait Until Page Contains Element    ${domain_giaodich}   2 mins
      Click Element JS    ${domain_giaodich}
      Wait Until Page Contains Element    ${button_config_electric}   2 mins
      Double Click Element    ${button_config_electric}
      Wait Until Page Contains Element    ${button_config_luu}   2 mins
      Click Element JS    ${button_config_luu}
      :FOR    ${time}   IN RANGE    10
      \   ${get_cofig_electronic}    Get data from API   ${endpoint_shop_config_list}    $.UseElectronicScales
      \   Run Keyword If    '${get_cofig_electronic}' != '0'    Get shop config info and validate    ${input_electric}    ELSE     Log    Ignore validate
      \   Exit For Loop If    '${get_cofig_electronic}' != '0'
      Turn off value in shop config by api    ${input_electric}

ezl1
      [Arguments]       ${zalo_acc}   ${zalo_pass}
      Set Selenium Speed    0.2
      ${zalo_status}      Get Zalo connection status
      Run Keyword If    '${zalo_status}'=='True'    Delete Zalo connection      ELSE      Log      ignore
      Go to any thiet lap    ${button_thieplap_cuahang}
      Go to tab Tin nhan Zalo
      Click Element    ${button_them_ket_noi_zalo}
      Select Window    title=Đăng nhập bằng tài khoản Zalo
      Input data in popup ZOA offcial    ${zalo_acc}   ${zalo_pass}
      Select Window     url=${URL}/#/PosParameter#tab-customer
      Wait Until Page Contains Element    ${button_luu_zalo_setting}      15s
      Click Element    ${button_luu_zalo_setting}
      Delete Zalo connection
