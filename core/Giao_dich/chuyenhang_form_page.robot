*** Variables ***
${textbox_chuyenhang_search_product}    //input[@id='productSearchInput']
${textbox_ma_phieu_chuyen}    //input[@placeholder='Mã phiếu tự động']
${cell_chon_chi_nhanh}    //span[contains(text(),'---Chọn chi nhánh---')]
${item_indropdown_chinhanh}    //span[contains(text(),'{0}')]
####
${item_ch_first_product_dropdownlist_search}    //div[contains(@class, 'output-complete')]//ul//li//p[contains(text(), '{0}')]    # 0 is product code
${textbox_ch_nums}    //div[@class='qtyBox']//div[@ng-show='isSent']//input[@type='text']
${textbox_ch_num_by_pr}   //td[span[text()='{0}']]//..//td[@class="cell-qty-numb"]//input
${cell_transferring_onhand}    //td[contains(@class, 'cell-quantity txtR')]
${cell_received_onhand}    //td[contains(@class, 'cell-change-price txtR ng-binding')]
${textbox_change_received_num_in_receive_screen}    //tbody[contains(@role,'rowgroup')]//tr[contains(@class, 'k-master-row')][{0}]//td[@class='cell-qty-numb']/div/input[contains(@class, 'iptQty')]    # 0 is row
${textbox_note_in_received_screen}    //div[contains(@class,'kv2Box pd0 transferSend')]//textarea[contains(@placeholder,'Ghi chú')]
${item_ch_imei_indropdown}    //ul[@class='suggestion-list']//li//span//em[text()='{0}']
${cell_first_product_code}   //span[@ng-bind='dataItem.ProductCode' or @ng-bind='dataItem.Product.Code']
${cell_item_imei}    //div[contains(@class, 'tags')]
${cell_lastest_num}    //div[@class='form-wrapper form-labels-140']//label[@class='form-label control-label ng-binding'][contains(text(),'Tổng số lượng')]//..//div
${button_dong_imei}     //span[text()='{0}']//..//a
###
${button_ch_hoanthanh}    //div[@class='wrap-button']//a[text()='Hoàn thành']
${button_ch_luutam}    //div[@class='wrap-button']//a[text()='Lưu tạm']
${textbox_ch_serial}    //input[contains(@id,'tagRow')]
${button_delete_imei_ch}    //ti-tag-item[ng-include[span[contains(text(),'{0}')]]]//a    # 0: imei number
${textbox_ch_nhaplo}    //input[@placeholder="Nhập lô, hạn sử dụng"]
${cell_ch_lo_indropdown}    //em[contains(text(),'{0}')]
${cell_ch_item_lo}    //tags-input[@placeholder='Nhập lô, hạn sử dụng']
##
${button_select_group_for_transfer}        //a[@class='btn-icon']
${checkbox_group_selectgrouppopup}         //li[div[contains(@class, 'k-mid')]//span[text()= '{0}']]//label             #text tên nhóm
${button_xong_selectgrouppopup}         //kv-category-selector//a[contains(text(),'Xong')]
${textbox_search_group_selectgrouppopup}        //input[@placeholder='Tìm kiếm nhóm hàng']
${textbox_quantity_by_product_code}        //tr[td[span[text()='{0}']]]//td[contains(@class, 'cell-qty-numb')]//div[@ng-show='isSent']//input[@type='text']         #product code
${cell_source_onhand_by_product_code}      //tr[td[span[text()='{0}']]]//td[contains(@class, 'cell-quantity txtR')]           #product code
${cell_target_onhand_by_product_code}      //tr[td[span[text()='{0}']]]//td[contains(@class, 'cell-change-price txtR ng-binding')]            #product code
${textbox_input_imei_by_product_id}       //tags-input[@ng-model='serials{0}']//input          #product id
${item_imei_indropdown_by_productcode}       //tags-input[@ng-model='serials{0}']//ul[@class='suggestion-list']//li//span[em[text()='{1}']]         #product id - imei
${textbox_quantity_receive_by_product_code}       //tr[td[span[text()='{0}']]]//td[contains(@class, 'cell-qty-numb')]//div[@class='qtyBox']/input[@type='text']
###
${button_select_display_options}      //div[contains(@class,'form-header')][2]//a[@id='toogleActionButton']
${toggle_default_receided}    //div[contains(@class,'form-header')][2]//span[@id='toggleDefaultFullReceive']
${button_dongy_in_popup_received}   //div[@id='filterMultiInvoices']//button[text()='Đồng ý']
###
${cell_text_lodate_firstrow}   //table//tr[2]//li[contains(@class,'tag-item')]//span
${tab_khop_in_transfer}    //li[@id='match']
${tab_lech_in_transfer}    //li[@id='notMatch']
${tab_chuanhan_in_transfer}    //li[@id='notReceive']
