*** Settings ***
Suite Setup       Init Test Environment    ${env}    ${remote}    ${account}    ${headless_browser}
Test Setup        Before Test Quan ly
Test Teardown     After Test
Library           SeleniumLibrary
Resource         ../../../core/Thiet_lap/thiet_lap_nav.robot
Resource         ../../../core/Thiet_lap/thiet_lap_cuahang_list_action.robot
Resource         ../../../core/API/api_thietlap.robot
Resource         ../../../core/API/api_tiki.robot
Resource         ../../../share/constants.robot
Resource         ../../../prepare/Hang_hoa/Sources/hanghoa.robot
Resource         ../../../core/hang_hoa/hang_hoa_add_action.robot
Resource         ../../../core/hang_hoa/hang_hoa_add_page.robot
Resource         ../../../core/hang_hoa/danh_muc_list_action.robot

*** Variables ***

*** Test Cases ***      Retailer           Tài khoản Tiki            Mật khẩu         Tên shop tiki
Kết nối tiki            [Tags]      LKKB    
                        [Template]    lktk
                        autotmdt${env}    anh.pq@citigo.com.vn     K6_g56Y6Z^gdtv        KiotViet

*** Keywords ***
lktk
    [Arguments]       ${input_retailer}      ${taikhoan}     ${matkhau}     ${shop_tiki}
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
    ${get_channel_id}       Get tiki channel id thr API        ${shop_tiki}
    Run Keyword If    ${get_channel_id}!=0    Delete tiki integration thr API    ${shop_tiki}
    #
    Set Selenium Speed    0.1
    Before Test Quan Ly
    Go to Tiki integration
    Wait Until Page Contains Element    ${button_lienket_tiki}    30s
    Click Element    ${button_lienket_tiki}
    Wait Until Page Contains Element    ${button_chon_tk_tiki_ketnoi}    30s
    Click Element    ${button_chon_tk_tiki_ketnoi}
    Wait Until Keyword Succeeds    3x    2s    Select Window    title=Đăng nhập Tiki Seller Center
    Maximize Browser Window
    Wait Until Page Contains Element    ${textbox_acc_seller_tiki}    30s
    Input Text    ${textbox_acc_seller_tiki}    ${taikhoan}
    Input Text    ${textbox_password_seller_tiki}    ${matkhau}
    Click Element    ${button_login_seller_tiki}
    Wait Until Page Contains Element    ${button_chopphep_truycap}   40s
    Click Element    ${button_chopphep_truycap}
    Select Window       url=${URL}/#/PosParameter#tab-tiki
    Wait Until Keyword Succeeds    5x    2s    Element Should Contain    ${label_shopee_shop}    ${shop_tiki}
    Click Element    ${button_luu_ketnoi_tiki}
    Wait Until Page Contains Element    ${button_dongy_dongbo_donhang}   40s
    Click Element    ${button_dongy_dongbo_donhang}
    Wait Until Page Contains Element    ${toast_message}    30s
    Element Should Contain    ${toast_message}    Thông tin kết nối được cập nhật thành công!
    Delete tiki integration thr API    ${shop_tiki}
