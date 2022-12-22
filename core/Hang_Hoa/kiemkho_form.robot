*** Variables ***
${textbox_search_ma_hh}    //input[@id='productSearchInput']
${textbox_ma_kiemkho}    //input[@placeholder='Mã phiếu tự động']
${button_hoanthanh_kk}    //article[@class='wrap-button']//a[text()='Hoàn thành']
${button_luutam_kk}    //article[@class='wrap-button']//a[@ng-click='save()']
${textbox_ghichu}    //textarea[@placeholder='Ghi chú']
${cell_first_product_code}  //span[@ng-bind='dataItem.ProductCode']
${cell_item_imei}   //tags-input[@id='tagRow tabindexbatch =']
${item_first_product_dropdownlist}    //div[contains(@class, 'output-complete')]//ul//li//p[contains(text(), '{0}')]    # 0 is product code
${item_imei_dropdownlist}    //ul[@class='suggestion-list']//li//span//em[text()='{0}']
${textbox_soluong_thucte}    //input[contains(@id, 'idActualCount')]
${cell_soluong_lech}    //td[contains(@class, 'cell-quantity')][2]
${cell_diff_quan_by_product_code}    //tr[td[span[text()='{0}']]]//td[contains(@class, 'cell-quantity')][2]        # product code
${cell_giatri_lech}    //td[contains(@class, 'cell-total txtR')]
${cell_diff_value_by_product_code}    //tr[td[span[text()='{0}']]]//td[contains(@class, 'cell-total txtR')]       # product code
${cell_tong_soluong_thucte}    //div[@class= 'form-group'][4]//label[text()='Tổng SL thực tế']//../div[contains(@class, 'form-wrap form-control-static')]
${cell_ten_kiem_ganday}    //div[contains(@class,'stock-history uln')]//div//ul//li[1]
${cell_soluong_kiem_ganday}    //div[contains(@class,'stock-history uln')]//div//ul//li[1]//span
${button_dong_y_canbangkho_popup}    //div[contains(@class, 'k-window-poup') and contains(concat(' ',normalize-space(@style),' '),' display: block; ')]//div[contains(@class, 'kv-window-footer')]//button[text()='Đồng ý']    # //div[@class= 'k-widget k-window k-window-poup k-window-masstel k-window-alert kv-window kv-close-popup']//span[text()='Cân bằng kho']//..//..//button[text()='Đồng ý']
${popup_frame}    //div[contains(@class, 'k-window-poup') and contains(concat(' ',normalize-space(@style),' '),' display: block; ')]
${tab_match}      //li[@id='match']
${tab_not_match}    //li[@id='notMatch']
${tab_not_control}    //li[@id='notControl']
${textbox_imei_num}    //input[contains(@id, 'tagRow')]
${button_select_pro_group}        //a[@class='btn-icon']
${textbox_search_group_selectgrouppopup}        //input[@placeholder='Tìm kiếm nhóm hàng']
${checkbox_group_selectgrouppopup}         //li[div[contains(@class, 'k-mid')]//span[text()= '{0}']]//label             #text tên nhóm
${button_xong_selectgrouppopup}         //kv-category-selector//a[contains(text(),'Xong')]
${textbox_current_quan_by_product_code}          //tr[td[span[text()='{0}']]]//td[contains(@class, 'cell-qty-numb')]//input          #product code
${textbox_input_imei_by_product_id}      //input[@id='tagRow{0}']         #productid
