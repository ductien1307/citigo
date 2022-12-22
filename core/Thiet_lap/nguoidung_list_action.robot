*** Settings ***
Library           SeleniumLibrary
Resource          nguoidung_list_page.robot
Resource          ../share/constants.robot
Resource          khuyenmai_list_page.robot

*** Keywords ***
Check display of Thoi gian truy cap
    [Arguments]    ${input_ten}
    Input Text    ${textbox_search_ten}    ${input_ten}
    Press Key    ${textbox_search_ten}    ${ENTER_KEY}
    sleep    3s
    Wait Until Element Is Visible    ${tab_thoigian_truycap}
    Click Element    ${tab_thoigian_truycap}
    sleep    3s
    Checkbox Should Not Be Selected    ${checkbox_khunggio}
    Element Should Be Disabled    ${checkbox_thuhai}

Go to update user form
      [Arguments]     ${input_user}
      Wait Until Element Is Visible    ${textbox_search_user}
      Input data    ${textbox_search_user}    ${input_user}
      Wait Until Element Is Visible    ${checkbox_filter_trangthai_tatca}
      Click Element    ${checkbox_filter_trangthai_tatca}
      Sleep   1s
      Wait Until Element Is Visible    ${button_capnhat_user}
      Click Element    ${button_capnhat_user}

Input data in popup Them moi nguoi dung
    [Arguments]      ${input_name}   ${input_username}    ${input_pass}   ${permission}    ${branch}    ${input_phone}    ${input_email}     ${input_note}
    Input text    ${textbox_user_name}   ${input_name}
    Input text    ${textbox_user_username}   ${input_username}
    Input text    ${textbox_user_password}   ${input_pass}
    Input text    ${textbox_user_again_password}   ${input_pass}
    Select combobox any form    ${combobox_user_permission}   ${cell_user_item_permission}   ${permission}
    Select dropdown anyform    ${textbox_user_branch}    ${cell_user_item_branch}    ${branch}
    Run Keyword If    '${input_phone}' == 'none'    Log     Ignore input      ELSE       Input text     ${textbox_user_phone}   ${input_phone}
    Run Keyword If    '${input_email}' == 'none'    Log     Ignore input      ELSE       Input text     ${textbox_user_email}   ${input_email}
    Click Element        ${button_save_add_user}
