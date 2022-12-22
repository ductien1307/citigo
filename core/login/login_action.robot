*** Settings ***
Library           SeleniumLibrary
Resource          login_page.robot
Resource          ../Ban_Hang/banhang_page.robot
Resource          ../Tong_Quan/Tongquan_navigation.robot
Resource          ../share/javascript.robot
Resource          ../../config/env_product/envi.robot
Resource          ../share/discount.robot
Resource          ../share/global.robot

*** Keywords ***
Login
    [Arguments]    ${username}    ${password}
    [Timeout]
    Wait Until Page Contains Element    ${button_quanly}    1 min
    Input Text    ${textbox_login_username}    ${username}
    Input Text    ${textbox_login_password}    ${password}
    Click Element    ${button_quanly}
    Wait Until Keyword Succeeds    3 times    2s    Access page    ${menu_tongquan}    Tổng quan
    #Wait Until Keyword Succeeds    3 times    2s    Close popups if visible    ${button_dong_popup}
    #Wait Until Keyword Succeeds    3 times    2s    Close popups if visible    ${button_close_popup2}    ${checkbox_ko_hien_thi_lan_sau_2}
    #Wait Until Keyword Succeeds    3 times    2s    Close popups if visible    ${button_close_popup5}

Assert failure text
    [Arguments]    ${error_msg}
    Wait Until Element Contains    ${text_failvalidation}    ${error_msg}

Logout MHBH
    Focus    ${button_menu_bhpage}
    Click Element JS    ${button_menu_bhpage}
    Wait Until Page Contains Element    ${button_mhbh_dangxuat}
    Click Element JS    ${button_mhbh_dangxuat}
    Wait Until Page Contains Element       ${textbox_login_username}       30s

Login MHBH
    [Arguments]    ${username}    ${password}
    Input Text Global    ${textbox_login_username}    ${username}
    Input Text Global    ${textbox_login_password}    ${password}
    Click Element Global    ${button_banhang_login}
    Wait Until Element Is Visible    ${icon_kenh_ban_truc_tiep}   2mins

Login MHQL
    [Arguments]    ${username}    ${password}
    Input Text Global    ${textbox_login_username}    ${username}
    Input Text Global    ${textbox_login_password}    ${password}
    Click Element Global    ${button_quanly_login}
    Wait To Loading Icon Invisible    

Login MHBH by sale url
    [Arguments]    ${username}    ${password}
    [Timeout]
    Input Text    ${textbox_username}    ${username}
    Input Text    ${textbox_password}    ${password}
    Wait Until Element Is Visible    ${button_banhang_sale}    3s
    Click Element JS    ${button_banhang_sale}
    Wait Until Element Is Visible    ${textbox_bh_search_ma_sp}

Login MHBH frm Quanly
    [Arguments]    ${username}    ${password}
    Input Text    ${textbox_username}    ${username}
    Input Text    ${textbox_password}    ${password}
    Click Element    ${button_quanly}

Close popups if visible
    [Arguments]    ${popup}
    Reload page if popup is not visible   ${popup}
    #Wait Until Element Is Enabled    ${popup}        2s
    ${count}    Get Matching Xpath Count    ${popup}
    ${count1}   Get Matching Xpath Count    ${checkbox_ko_hien_thi_lan_sau}
    Run Keyword If    ${count1}>0      Click Element JS        ${checkbox_ko_hien_thi_lan_sau}
    Run Keyword If    ${count}>0       Click Element JS        ${popup}
    #Wait Until Page Does Not Contain Element      ${popup}       1 s

Reload page if popup is not visible
    [Arguments]    ${popup}
    : FOR    ${checkstatus}    IN RANGE    2
    \    ${status}    Run Keyword And Return Status    Wait Until Page Contains Element      ${popup}      15s
    \    Run Keyword If    '${status}' == 'False'    Reload Page
    \    ...    ELSE    Exit For Loop

Go to Access KV Account
    Wait Until Element Is Visible    ${button_login_kvpage}     1 min
    Click Element    ${button_login_kvpage}
    Wait Until Element Is Visible    ${textbox_urladdress_accesspopup_kvpage}       30 s

Access KV Account by typing KV Name
   [Arguments]      ${kv_name}
   Input Text    ${textbox_urladdress_accesspopup_kvpage}    ${kv_name}
   Click Element    ${btn_accessurl_accesspopup_kvpage}
   Sleep    10 s

Login Fnb
   [Arguments]    ${ten_gian_hang}    ${username}    ${password}
   [Timeout]
   Input Text    ${textbox_login_tengianhang}    ${ten_gian_hang}
   Input Text    ${textbox_login_username}    ${username}
   Input Text    ${textbox_login_password}    ${password}
   Wait Until Page Contains Element    ${button_quanly}    1 min
   Click Element    ${button_quanly}
   Wait Until Keyword Succeeds    3 times    30 s    Access page    ${menu_tongquan}    Tổng quan
   Wait Until Keyword Succeeds    3 times    2s    Close popups if visible    ${button_dong_popup}

Log out ban hang
    Wait Until Page Contains Element    ${button_menubar}    2 mins
    Click Element JS    ${button_menubar}
    Wait Until Page Contains Element    ${cell_dangxuat}    2 mins
    Click Element JS    ${cell_dangxuat}
