*** Settings ***
Library           SeleniumLibrary
Library           StringFormat
Resource          khuyenmai_list_page.robot
Resource          ../share/constants.robot
Resource          ../share/discount.robot

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

Go to update promotion form
    [Arguments]    ${input_ma_promo}
    Wait Until Element Is Visible    ${textbox_search_promo}
    Input data    ${textbox_search_promo}    ${input_ma_promo}
    Wait Until Element Is Visible    ${checkbox_filter_trangthai_tatca}
    Click Element    ${checkbox_filter_trangthai_tatca}
    Sleep    1s
    Wait Until Element Is Visible    ${button_capnhat_promo}
    Click Element    ${button_capnhat_promo}
