*** Settings ***
Library           SeleniumLibrary
Resource          lazada_list_page.robot
Resource          ../share/constants.robot
Resource          ../share/computation.robot

*** Keywords ***
Login to Lazada
    [Arguments]     ${input_taikhoan}     ${input_matkhau}
    Wait Until Page Contains Element    ${button_google}    20s
    Click Element     ${button_google}
    Wait Until Keyword Succeeds    3x    2s    Select Window    title=Đăng nhập - Tài khoản Google
    Wait Until Page Contains Element    ${textbox_lzd_email}    20s
    Input Text    ${textbox_lzd_email}    ${input_taikhoan}
    Click Element    ${button_lzd_tieptheo}
    Wait Until Page Contains Element    ${textbox_lzd_matkhau}    20s
    Input Text    ${textbox_lzd_matkhau}    ${input_matkhau}
    Click Element    ${button_lzd_tieptheo}
