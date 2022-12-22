*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    ${headless_browser}
Test Setup
Test Teardown     After Test
Library           SeleniumLibrary
Resource         ../../../core/Thiet_lap/thiet_lap_nav.robot
Resource         ../../../core/Thiet_lap/thiet_lap_cuahang_list_action.robot
Resource         ../../../core/API/api_thietlap.robot
Resource         ../../../core/API/api_shopee.robot
Resource         ../../../share/constants.robot
Resource         ../../../prepare/Hang_hoa/Sources/hanghoa.robot
Resource         ../../../core/hang_hoa/danh_muc_list_action.robot
Resource         ../../../core/Shopee_UAT/shopee_banhang_action.robot
Resource         ../../../core/Shopee_UAT/shopee_list_action.robot

*** Variables ***

*** Test Cases ***      Retailer             Tên shop Shopee     Mật khẩu
Kết nối Shopee          [Tags]     LKKB     
                        [Template]    lksp
                        autotmdt${env}           thanhptk            Shopee123

*** Keywords ***
lksp
    [Arguments]       ${input_retailer}      ${taikhoan}     ${matkhau}
    #Set biến global
    ${URL}    Set Variable     https://${input_retailer}.kvpos.com:${env}
    ${API_URL}   Set Variable     https://${input_retailer}.kvpos.com:${env}/api
    ${bearertoken}    ${resp.cookies}   ${branchid}    Get BearerToken by URL and account from API    ${input_retailer}    ${URL}    ${USER_ADMIN}    ${PASSWORD}
    Set Global Variable    \${API_URL}    ${API_URL}
    Set Global Variable    \${URL}    ${URL}
    Set Global Variable    \${bearertoken}    ${bearertoken}
    Set Global Variable    \${resp.cookies}    ${resp.cookies}
    Set Global Variable    \${RETAILER_NAME}    ${input_retailer}
    Set Global Variable    \${BRANCH_ID}    ${branchid}
    #
    ${get_user_id}    Get User ID by UserName    ${USER_ADMIN}
    ${get_retailer_id}    Get RetailerID
    ${result_lastestbranch}    Format String    LatestBranch_{0}_{1}    ${get_retailer_id}    ${get_user_id}
    #
    Set Global Variable    \${LATESTBRANCH}    ${result_lastestbranch}
    ${get_shopee_channel_id}     ${get_identitykey_id}      Get shopee channel id and identitykey id thr API      ${taikhoan}
    Run Keyword If    ${get_shopee_channel_id}!=0    Delete shoppee integration thr API    ${taikhoan}
    #
    Set Selenium Speed    0.1
    Before Test Quan Ly
    Go to Shopee integration
    Wait Until Page Contains Element    ${button_lienket_shopee}    30s
    Click Element    ${button_lienket_shopee}
    Wait Until Page Contains Element    ${button_chon_tk_shopee_ketnoi}    30s
    Click Element    ${button_chon_tk_shopee_ketnoi}
    Wait Until Keyword Succeeds    3x    2s    Select Window    title=Login to Shopee
    Maximize Browser Window
    ${status}   Run Keyword And Return Status    Login to Authorize Shopee Openplatform    ${taikhoan}     ${matkhau}
    Run Keyword If    '${status}'=='False'    Login to Authorize Shopee Openplatform APP    ${taikhoan}     ${matkhau}
    Wait Until Page Contains Element    ${button_comfirm_authorization}   40s
    Click Element    ${button_comfirm_authorization}
    Select Window       url=${URL}/#/PosParameter#tab-shopee
    Wait Until Keyword Succeeds    5x    2s    Element Should Contain    ${label_shopee_shop}    ${taikhoan}
    Click Element    ${button_luu_ketnoi_shopee}
    Wait Until Page Contains Element    ${button_dongy_dongbo_donhang}   40s
    Click Element    ${button_dongy_dongbo_donhang}
    Wait Until Page Contains Element    ${toast_message}    30s
    Element Should Contain    ${toast_message}    Thông tin kết nối được cập nhật thành công!
    Delete shoppee integration thr API    ${taikhoan}
