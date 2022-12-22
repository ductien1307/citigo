*** Settings ***
Library           SeleniumLibrary
Library           StringFormat
Library           String
Resource          ../share/javascript.robot
Resource          nhap_hang_add_action.robot
Resource          ../share/discount.robot

*** Variables ***
${button_chuyenhang}    //a[@ng-show="canCreate"]
${textbox_search_ma_chuyenhang}   //article[contains(@class,'header-filter headerContent')]//input[@ng-enter='quickSearch(true)']
${icon_multi_search}    //div[contains(@class,'input-group')]//button[contains(@class,'dropdown-toggle')]//i
${textbox_search_hh_in_transform}    //div[contains(@class,'dropdown-menu')]//input[@placeholder='Theo mã hàng']
${button_search}    //div[contains(@class,'kv-window-footer')]//button
${cell_transfer_code}    //span[contains(text(),'{0}')]
${button_open_trans_form}    //div[@class='k-content k-state-active'][article[div[div[div[div[strong[contains(text(), '{0}')]]]]]]]//article[@class='kv-group-btn']//a[contains(text(), 'Mở phiếu')]    #0 mã phiếu
${button_cancel_transferring}    //article[@class='kv-group-btn']//a[contains(@class, 'btn btn-danger')]
${cell_trans_code_in_received_trans_form}    //div[contains(text(),'{0}')]
${button_complete}    //div[@class='wrap-button']//a[contains(text(), 'Nhận hàng')]    # Nhận hàng
${button_draft}    //div[@class='wrap-button']//a[contains(text(), 'Lưu tạm')]    # lưu tạm
${button_copy_trans}        //a[i[@class='far fa-clone']]
${button_save_trans}      //a[contains(@class,'btn btn-success')][1]//i[@class='fas fa-save']
##
${status_in_receive_screen}    //div[label[contains(text(),'Trạng thái:')]]//div
${from_branch_in_receive_screen}    //div[label[contains(text(),'Từ chi nhánh:')]]//div
${to_branch_in_receive_screen}    //div[label[contains(text(),'Tới chi nhánh:')]]//div
${button_dongy_cancel_transferring}        //div[@id='filterMultiInvoices']//button[@class='btn-confirm btn btn-success']

*** Keywords ***
Search product in transform form
      [Arguments]    ${input_product}
      Wait Until Page Contains Element    ${icon_multi_search}    2 min
      Click Element JS    ${icon_multi_search}
      Wait Until Page Contains Element    ${textbox_search_hh_in_transform}    2 min
      Input data    ${textbox_search_hh_in_transform}    ${input_product}
      Wait Until Page Contains Element    ${button_search}    2 min
      Click Element JS    ${button_search}

Search transform code code
      [Arguments]       ${transform_code}
      Wait Until Page Contains Element    ${textbox_search_ma_chuyenhang}    1 mins
      Input data    ${textbox_search_ma_chuyenhang}    ${transform_code}
