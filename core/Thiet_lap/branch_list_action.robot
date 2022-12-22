*** Settings ***
Library           SeleniumLibrary
Library           StringFormat
Resource          ../share/toast_message.robot
Resource          ../Giao_dich/chuyenhang_page_action.robot
Resource          branch_list_page.robot
Resource          khuyenmai_list_page.robot

*** Variables ***
${cell_recent_branch}    //span[@class='k-input ng-scope'][contains(text(),'{0}')]
${item_indropdown_branch_list}    //ul[@id='cbSelectBranch_listbox']//li[@class='k-item ng-scope'][contains(text(),'{0}')]
${cell_after_switch_br}    //span[@class='k-input ng-scope'][contains(text(),'{0}')]

*** Keywords ***
Switch Branch
    [Arguments]    ${source_branch_name}    ${target_branch_name}
    ${target_branch_by_name}    Format string    ${item_indropdown_branch_list}    ${target_branch_name}
    ${source_recent_branch}    Format string    ${cell_recent_branch}    ${source_branch_name}
    Wait Until Page Contains Element    ${source_recent_branch}    1 min
    Click Element    ${source_recent_branch}
    Wait Until Page Contains Element    ${target_branch_by_name}    1 min
    Click Element    ${target_branch_by_name}
    #${text_msg_chuyen}    Format string    Bạn vừa chuyển sang chi nhánh: {0}, màn hình bán hàng sẽ được tải lại theo chi nhánh mới.    ${target_branch_name}
    #Toast flex message validation    ${text_msg_chuyen}
    ${cell_new_branch_appear}    Format String    ${cell_after_switch_br}    ${target_branch_name}
    Wait Until Page Contains Element    ${cell_new_branch_appear}    1 min
    Wait Until Page Does Not Contain Element    ${toast_message}    1 min

Switch Branch and Go to Inventory form
    [Arguments]    ${source_branch_name}    ${target_branch_name}
    Switch Branch    ${source_branch_name}    ${target_branch_name}
    Go to Inventory Transfer form

Go to update branch form
      [Arguments]     ${input_tenchinhanh}
      Wait Until Element Is Visible    ${textbox_search_branch}
      Input data    ${textbox_search_branch}    ${input_tenchinhanh}
      Wait Until Element Is Visible    ${checkbox_filter_trangthai_tatca}
      Click Element    ${checkbox_filter_trangthai_tatca}
      Sleep   1s
      Wait Until Page Contains Element       ${button_capnhat_branch}   20s
      Click Element    ${button_capnhat_branch}
