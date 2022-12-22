*** Settings ***
Library           SeleniumLibrary
Resource          giao_hang_popup_page.robot
Resource          ../share/computation.robot
Resource          giaovan_price.robot
Resource          ../share/constants.robot
Resource          ../share/javascript.robot
Resource          ../share/discount.robot
Resource          giao_hang_nav.robot

*** Keywords ***
Input mandatory fields incl Delivery Partner in Giao Hang form
    [Arguments]    ${input_ten}    ${input_sdt}    ${input_diachi}    ${input_khuvuc}    ${input_phuongxa}    ${input_trongluong}
    Input Text    ${textbox_tennguoinhan}    ${input_ten}
    Input Text    ${textbox_sodienthoai}    ${input_sdt}
    Input Text    ${textbox_diachinhan}    ${input_diachi}
    Input Text    ${textbox_khuvuc}    ${input_khuvuc}
    Input Text    ${textbox_phuongxa}    ${input_phuongxa}
    Input Text    ${textbox_trongluong}    ${input_trongluong}
    Click Element    ${checkbox_giaohangnhanh}
    sleep    10s

Get tong phi Dich vu chuan
    ${get_tongphi_chuan}    Get Text    ${cell_value_chuan_tongphi}
    Return From Keyword    ${get_tongphi_chuan}

Input data incl kich thuoc n Delivery Partner
    [Arguments]    ${input_ten}    ${input_sdt}    ${input_diachi}    ${input_khuvuc}    ${input_phuongxa}    ${input_trongluong}
    ...    ${input_length}    ${input_w}    ${input_h}
    Input Text    ${textbox_tennguoinhan}    ${input_ten}
    Input Text    ${textbox_sodienthoai}    ${input_sdt}
    Input Text    ${textbox_diachinhan}    ${input_diachi}
    Input Text    ${textbox_khuvuc}    ${input_khuvuc}
    Input Text    ${textbox_phuongxa}    ${input_phuongxa}
    Input Text    ${textbox_trongluong}    ${input_trongluong}
    Input Text    ${textbox_l}    ${input_length}
    Input Text    ${textbox_w}    ${input_w}
    Input Text    ${textbox_h}    ${input_h}
    Click Element    ${checkbox_giaohangnhanh}
    sleep    10s

Assert cost if weight is greater than converted weight
    [Arguments]    ${klqd}    ${input_trongluong}    ${get_tongphi_chuan}
    ${trongluong_tinhphi}    Minus    ${klqd}    3
    ${phi_theo_trongluong}    Tinh khoi luong quy doi    ${trongluong_tinhphi}
    ${sum_price}    Sum x 3    ${phi_theo_trongluong}    0    ${tuyen_noitinh_noithanh}
    ${price_after_vat}    Price after VAT    ${sum_price}
    log    ${price_after_vat}
    Sleep    30s
    Should Be Equal As Numbers    ${price_after_vat}    ${get_tongphi_chuan}

Assert cost if weight is lower than converted weight
    [Arguments]    ${klqd_theo_trong_luong}    ${get_tongphi_chuan}
    log    ${klqd_theo_trong_luong}
    ${trongluong_tinhphi}    Minus    ${klqd_theo_trong_luong}    3
    ${phi_theo_trongluong}    Tinh khoi luong quy doi    ${trongluong_tinhphi}
    ${sum}    Sum x 3    ${phi_theo_trongluong}    0    ${tuyen_noitinh_noithanh}
    ${price_after_vat}    Price after VAT    ${sum}
    log    ${price_after_vat}
    Sleep    30s
    Should Be Equal As Numbers    ${price_after_vat}    ${get_tongphi_chuan}

Select trang thai giao hang frm sale
    [Arguments]    ${input_trangthai_gh}
    Set Selenium Speed    0.5s
    Wait Until Page Contains Element    ${dropdowlist_trangthai_gh}    2 mins
    Wait Until Keyword Succeeds    3 times    20 s    Click Element JS    ${dropdowlist_trangthai_gh}
    ${trangthai_gh}    Format String    ${item_trangthai_gh}    ${input_trangthai_gh}
    Wait Until Keyword Succeeds    3 times    20 s    Click Element JS    ${trangthai_gh}

Input mandatory fields in Giao Hang form
    [Arguments]    ${input_tennguoinhan}    ${input_sdt}    ${input_diachi}    ${input_khuvuc}    ${input_phuongxa}
    Set Selenium Speed    2s
    Wait Until Keyword Succeeds    3 times    20 s    Input text    ${textbox_tennguoinhan}    ${input_tennguoinhan}
    Wait Until Keyword Succeeds    3 times    20 s    Input text    ${textbox_sodienthoai}    ${input_sdt}
    Wait Until Keyword Succeeds    3 times    20 s    Input text    ${textbox_diachinhan}    ${input_diachi}
    Wait Until Keyword Succeeds    3 times    20 s    Input text    ${textbox_khuvuc}    ${input_khuvuc}
    Wait Until Keyword Succeeds    3 times    20 s    Input text    ${textbox_phuongxa}    ${input_phuongxa}

Select delivery time frm BH
    [Arguments]    ${input_ngay_gh}
    Set Selenium Speed    0.5s
    Wait Until Page Contains Element    ${icon_calendarmini}    2 mins
    Wait Until Keyword Succeeds    3 times    20 s    Click Element JS    ${icon_calendarmini}
    ${item_ngay_gh}    Format String    ${cell_item_calendar}    ${input_ngay_gh}
    Wait Until Keyword Succeeds    3 times    20 s    Click Element JS    ${item_ngay_gh}

Input DTGH in Giao hang popup
    [Arguments]    ${input_bh_dtgh}
    Wait Until Page Contains Element    ${textbox_dtgh}    1 min
    Input text    ${textbox_dtgh}    ${input_bh_dtgh}
    Wait Until Page Contains Element    ${cell_dtgh_in_dropdown}   1min
    Click Element JS    ${cell_dtgh_in_dropdown}

Input data in DTGH popup
    [Arguments]    ${input_ma_dtgh}    ${input_phi_gh}    ${trangthaigh}    ${result_khachcantra}
    Open Giao Hang popup
    Input DTGH in Giao hang popup    ${input_ma_dtgh}
    Wait Until Keyword Succeeds    3 times    10s    Input data    ${textbox_phi_gh}    ${input_phi_gh}
    Select trang thai giao hang frm sale    ${trangthaigh}
    Click Element JS    ${button_xong}
    Sleep    3s
    Run Keyword If    ${result_khachcantra}>1000000    Click Element JS    ${button_luuy_close}
    Run Keyword If    ${result_khachcantra}>1000000     Click Element JS    ${button_xong}

Input data to textbox khai gia
    [Arguments]    ${input_khaigia}
    Wait Until Page Contains Element    ${checkbox_khaigia}   1min
    Click Element JS    ${checkbox_khaigia}
    Wait Until Page Contains Element    ${textbox_khaigia}   1min
    Input data    ${textbox_khaigia}    ${input_khaigia}

Input delivery info to DTGH popup
    [Arguments]    ${input_ma_dtgh}    ${input_khaigia}    ${nguoitraphi}
    Open Giao Hang popup
    Input DTGH in Giao hang popup    ${input_ma_dtgh}
    Run Keyword If    '${input_khaigia}' == '0'    Log    Ignore click      ELSE    Input data to textbox khai gia    ${input_khaigia}
    Run Keyword If    '${nguoitraphi}' == 'True'    Log    Ignore click   ELSE    Click Element JS    ${radiobutton_nguoinhantraphi}
    Click Element JS    ${button_xong}

Input location and ward to shipping popup
    [Arguments]    ${locator}     ${input_text}    ${input_cell} 
    Wait Until Page Contains Element    ${locator}     2mins
    Input Text    ${locator}     ${input_text}
    Wait Until Page Contains Element    ${input_cell}     2mins
    Click Element JS    ${input_cell}
