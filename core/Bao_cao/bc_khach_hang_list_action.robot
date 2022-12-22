*** Settings ***
Resource          bc_khach_hang_list_page.robot
Library           SeleniumLibrary
Resource          ../share/discount.robot
Library           String Format
Library           BuiltIn

*** Keywords ***
Search customer in BC khach hang
    [Arguments]    ${ma_kh}
    Wait Until Page Contains Element    ${textbox_bckh_tk_khachhang}    2 min
    Input Text    ${textbox_bckh_tk_khachhang}    ${ma_kh}
    Press Key    ${textbox_bckh_tk_khachhang}    ${ENTER_KEY}
    Sleep    7s
