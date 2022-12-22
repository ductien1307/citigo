*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    ${headless_browser}
Test Teardown     After Test
Library           SeleniumLibrary
Resource         ../../../core/Thiet_lap/thiet_lap_nav.robot
Resource         ../../../core/Thiet_lap/thiet_lap_cuahang_list_action.robot
Resource         ../../../core/API/api_thietlap.robot
Resource         ../../../core/API/api_sendo.robot
Resource         ../../../share/constants.robot
Resource         ../../../prepare/Hang_hoa/Sources/hanghoa.robot
Resource         ../../../core/hang_hoa/hang_hoa_add_action.robot
Resource         ../../../core/hang_hoa/hang_hoa_add_page.robot
Resource         ../../../core/hang_hoa/danh_muc_list_action.robot

*** Variables ***

*** Test Cases ***      Retailer           Tài khoản Sendo        Mật khẩu      Tên shop Sendo
Kết nối Sendo           [Tags]      LKKB
                        [Template]    lksd
                        autotmdt${env}      0934617946            pqa123456        KiotViet

*** Keywords ***
lksd
    [Arguments]       ${input_retailer}      ${taikhoan}     ${matkhau}     ${shop_sendo}
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
    ${get_channel_id}       Get Sendo channel id thr API        ${shop_sendo}
    Run Keyword If    ${get_channel_id}!=0    Delete Sendo integration thr API      ${shop_sendo}
    #
    Set Selenium Speed    0.1
    Before Test Quan Ly
    Go to Sendo integration
    Wait Until Page Contains Element    ${button_lienket_sendo}    30s
    Click Element    ${button_lienket_sendo}
    Wait Until Page Contains Element    ${button_chon_tk_sendo_ketnoi}    30s
    Click Element    ${button_chon_tk_sendo_ketnoi}
    ${get_secret_key}    ${get_shop_key}     Get secret key and shop key Sendo thr API    ${taikhoan}     ${matkhau}
    Wait Until Page Contains Element    ${textbox_ten_shop_sendo}   20s
    Input Text    ${textbox_ten_shop_sendo}    ${shop_sendo}
    Input Text    ${textbox_ma_shop_sendo}    ${get_shop_key}
    Input Text    ${textbox_ma_bao_mat_sendo}    ${get_secret_key}
    Click Element    ${button_luu_taikhoan_sendo}
    Wait Until Keyword Succeeds    5x    2s    Element Should Contain    ${label_sendo_shop}    ${shop_sendo}
    Click Element    ${button_luu_ketnoi_sendo}
    Wait Until Page Contains Element    ${button_dongy_dongbo_donhang}   40s
    Wait Until Keyword Succeeds    5x    1s    Click Element    ${button_dongy_dongbo_donhang}
    Wait Until Page Contains Element    ${toast_message}    30s
    Element Should Contain    ${toast_message}    Thông tin kết nối được cập nhật thành công!
    Delete Sendo integration thr API      ${shop_sendo}
