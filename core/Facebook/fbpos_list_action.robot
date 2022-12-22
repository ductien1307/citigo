*** Settings ***
Library           SeleniumLibrary
Resource          fbpos_list_page.robot
Resource          ../share/constants.robot
Resource          ../share/discount.robot

*** Keywords ***
Login Facebook
    [Arguments]   ${taikhoan}   ${matkhau}
    Wait Until Keyword Succeeds    3x    5s    Select Window     title=KiotViet-Facebook
    KV Click Element    ${button_fb_dangnhap_facebook}
    Wait Until Keyword Succeeds    3x    5s    Select Window     title=Facebook
    KV Input Text    ${textbox_fb_email}    ${taikhoan}
    KV Input Text    ${textbox_fb_matkhau}    ${matkhau}
    Click Element    ${button_fb_dangnhap}
    Wait Until Keyword Succeeds    3x    5s    Select Window     url=${URL}/saleonline/#/

Close popup printer
    KV Click Element    ${button_fb_in}
    KV Click Element    ${toggle_fb_tat_tudong_in}

Search product in FBPos
    [Arguments]   ${input_mahh}
    KV Input Text    ${textbox_fb_tim_mat_hang}    ${input_mahh}
    KV Click Element JS By Code    ${item_fb_hanghoa_in_dropdowlist}    ${input_mahh}
