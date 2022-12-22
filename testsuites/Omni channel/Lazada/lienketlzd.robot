*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    ${headless_browser}
Test Setup
Test Teardown     After Test
Library           SeleniumLibrary
Resource         ../../../core/Thiet_lap/thiet_lap_nav.robot
Resource         ../../../core/Thiet_lap/thiet_lap_cuahang_list_action.robot
Resource         ../../../core/API/api_thietlap.robot
Resource         ../../../core/API/api_lazada.robot
Resource         ../../../share/constants.robot
Resource         ../../../prepare/Hang_hoa/Sources/hanghoa.robot
Resource         ../../../core/hang_hoa/danh_muc_list_action.robot
Resource         ../../../core/Shopee_UAT/shopee_banhang_action.robot

*** Variables ***

*** Test Cases ***      Retailer               Tài khoản LZD                     Mật khẩu      Tên shop LZD
Liên kết lazada             [Tags]      LKKB
                        [Template]    lklzd
                        autotmdt${env}        linh.hd@citigovietnam.com         Acd123456      TEST SELLER 3

*** Keywords ***
lklzd
    [Arguments]       ${input_retailer}      ${taikhoan}     ${matkhau}     ${input_shop_lazada}
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
    ${get_channel_id}       Get lazada channel id thr API           ${input_shop_lazada}
    Run Keyword If    ${get_channel_id}!=0    Delete lazada integration thr API    ${input_shop_lazada}
    #
    Set Selenium Speed    0.1
    Before Test Quan Ly
    Go to Lazada integration
    Wait Until Page Contains Element    ${button_lienket_lazada}    30s
    Wait Until Keyword Succeeds    5x    1s     Click Element    ${button_lienket_lazada}
    Wait Until Page Contains Element    ${button_chon_tk_lazada_ketnoi}    30s
    Wait Until Keyword Succeeds    5x    1s     Click Element    ${button_chon_tk_lazada_ketnoi}
    Wait Until Keyword Succeeds    3x    2s    Select Window    title=Authorize - Lazada Open Platform
    Maximize Browser Window
    Wait Until Page Contains Element    ${textbox_acc_seller_lazada}    30s
    Click Element    ${box_country}
    Click Element    ${item_lzd_quocgia_vietnam}
    Input Text    ${textbox_acc_seller_lazada}    ${taikhoan}
    Input Text    ${textbox_password_seller_lazada}    ${matkhau}
    Click Element    ${button_submit}
    Select Window       url=${URL}/#/PosParameter#tab-lazada
    Wait Until Keyword Succeeds    5x    2s    Element Should Contain    ${label_lazada_shop}    ${input_shop_lazada}
    Click Element    ${button_luu_ketnoi_lazada}
    Wait Until Page Contains Element    ${button_dongy_dongbo_donhang}   40s
    Click Element    ${button_dongy_dongbo_donhang}
    Wait Until Page Contains Element    ${toast_message}    30s
    Element Should Contain    ${toast_message}    Thông tin kết nối được cập nhật thành công!
    Delete lazada integration thr API    ${input_shop_lazada}
