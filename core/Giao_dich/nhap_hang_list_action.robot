*** Settings ***
Library           SeleniumLibrary
Library           StringFormat
Library           String
Resource          nhap_hang_list_page.robot
Resource          ../share/computation.robot
Resource          ../share/javascript.robot
Resource          nhap_hang_add_page.robot
Resource          ../share/discount.robot

*** Keywords ***
Assert Record By NCC
    [Arguments]    ${row}    ${input_ncc}    ${input_trangthai}    ${input_tongtienhang}
    Sleep    1s
    ${cell_ncc}    Format String    ${cell_ncc}    ${row}
    ${get_ncc}    Get Text    ${cell_ncc}
    ${cell_cantra_ncc}    Format String    ${cell_cantra_ncc}    ${row}
    ${get_cantrancc}    Get Text    ${cell_cantra_ncc}
    ${get_cantrancc}    Convert Any To Number    ${get_cantrancc}
    ${cell_trang_thai}    Format String    ${cell_trang_thai}    ${row}
    ${get_trangthai}    Get Text    ${cell_trang_thai}
    Should Be Equal As Strings    ${get_cantrancc}    ${input_tongtienhang}
    Should Be Equal As Strings    ${get_ncc}    ${input_ncc}
    Should Be Equal As Strings    ${get_trangthai}    ${input_trangthai}

Search PNH and assert Record By NCC
    [Arguments]    ${ma_pn}    ${input_ncc}    ${input_trangthai}    ${input_tongtienhang}
    input text    ${textbox_searh_ma_pn}    ${ma_pn}
    ${get_ncc}    Get Text    ${cell_ncc}
    ${get_cantrancc}    Get Text    ${cell_cantra_ncc}
    ${get_cantrancc}    Convert Any To Number    ${get_cantrancc}
    ${get_trangthai}    Get Text    ${cell_trang_thai}
    Should Be Equal As Strings    ${get_cantrancc}    ${input_tongtienhang}
    Should Be Equal As Strings    ${get_ncc}    ${input_ncc}
    Should Be Equal As Strings    ${get_trangthai}    ${input_trangthai}

Go to PNH
    Wait Until Page Contains Element    ${button_nhap_hang}    2 mins
    Click Element    ${button_nhap_hang}
    Wait Until Page Contains Element    ${textbox_nh_search_hh}    2 mins
    sleep    1s
    #Click Element    //span[@class='k-icon k-i-arrow-n']
    #sleep    1 s
    #Click Element    //a[@class='k-link']//span[@class='k-icon k-i-arrow-s']

Get purchase order info frm UI
    Click Element JS    ${cell_ma_phieunhap}
    ${get_nguoinhap}    Get Text    ${cell_nguoinhap}
    ${get_tongso_mathang}    Get Text    ${cell_tongso_mathang}
    Return From Keyword    ${get_nguoinhap}    ${get_tongso_mathang}

Toggle Adding Row option
    KV Click Element    ${button_nh_optional_display}
    KV Click Element       ${toggle_nh_add_row}
    Click Element    ${button_nh_optional_display}

Search purchase receipt code and click open
    [Arguments]     ${ma_phieu_nhap}
    Wait Until Page Contains Element    ${textbox_searh_ma_pn}    20s
    Input data    ${textbox_searh_ma_pn}    ${ma_phieu_nhap}
    KV Click Element    ${button_mo_phieu_nhap}
