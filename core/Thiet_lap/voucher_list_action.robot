*** Settings ***
Library           SeleniumLibrary
Library           StringFormat
Resource          voucher_list_page.robot
Resource          ../share/constants.robot

*** Keywords ***
Select category from Chon nhom hang popup
    [Arguments]    ${xpath_button}    ${input_nhomhang}
    ${checkbox_item_nhomhang_inpopup}    Format String    ${checkbox_item_nhomhang_inpopup}    ${input_nhomhang}
    Wait Until Element Is Visible    ${xpath_button}
    Click Element    ${xpath_button}
    Wait Until Element Is Visible    ${checkbox_item_nhomhang_inpopup}
    Click Element    ${checkbox_item_nhomhang_inpopup}
    Wait Until Element Is Visible    ${button_xong_in_popup}
    Click Element    ${button_xong_in_popup}

Go to update voucher form
    [Arguments]    ${input_ma_voucher}
    Go to search voucher form    ${input_ma_voucher}
    Wait Until Element Is Visible    ${checkbox_filter_trangthai_tatca}
    Click Element    ${checkbox_filter_trangthai_tatca}
    Sleep    1s
    Wait Until Element Is Visible    ${button_capnhat_voucher}
    Click Element    ${button_capnhat_voucher}

Go to search voucher form
    [Arguments]    ${input_ma_voucher}
    Wait Until Element Is Visible    ${button_search_dropdown}
    Click Element    ${button_search_dropdown}
    Wait Until Element Is Visible    ${textbox_search_voucher}
    Click Element    ${textbox_search_voucher}
    Input Text    ${textbox_search_voucher}    ${input_ma_voucher}
    Click Element    ${button_timkiem}

Go to publish voucher
    [Arguments]    ${input_ma_voucher}    ${voucher_code}    ${giaban}
    Go to update voucher form    ${input_ma_voucher}
    Wait Until Element Is Visible    ${tab_phathanh}
    Click Element    ${tab_phathanh}
    Wait Until Element Is Visible    ${textbox_search_voucher_code}
    Click Element    ${textbox_search_voucher_code}
    Input Text    ${textbox_search_voucher_code}    ${voucher_code}
    Wait Until Element Is Visible    ${checkbox_vouchercode}
    Click Element    ${checkbox_vouchercode}
    Wait Until Element Is Visible    ${dropdown_thaotac}
    Click Element    ${dropdown_thaotac}
    Wait Until Element Is Visible    ${item_phathanh}
    Click Element    ${item_phathanh}
    Wait Until Element Is Visible    ${radio_tang}
    Click Element    ${radio_tang}
    Wait Until Element Is Visible    ${button_phathanh_luu}
    Click Element    ${button_phathanh_luu}
