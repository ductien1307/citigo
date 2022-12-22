*** Variables ***
${textbox_tennguoinhan}    //input[@id='receiver']
${textbox_sodienthoai}    //input[@id='contact-number']
${textbox_diachinhan}    //input[@id='address']
${textbox_khuvuc}    //input[@id='locationDeliery']
${textbox_phuongxa}    //input[@id='wardDelivery']
${textbox_trongluong}    //div[label[span[contains(text(),'Trọng lượng')]]]//../div[contains(@class, 'row')]//div[contains(@class, 'col-md')]//input[@type='text']
${textbox_l}      //input[@placeholder='Dài']
${textbox_w}      //input[@placeholder='Rộng']
${textbox_h}      //input[@placeholder='Cao']
${checkbox_giaohangnhanh}    //img[@title='Giao hàng nhanh']
${cell_value_chuan_tongphi}    //div[@class='kv-body']//div[@class='cell-totalfee']
${textbox_dtgh}    //input[@id='deliveryPartnerSearchInput']
${textbox_phi_gh}    //input[@id='fee']
${textbox_time_gh}    //div[contains(@class, 'form-group')]//label[span[text()= 'Thời gian giao hàng']]/..//span[contains(@class, 'picker-wrap')]//input[@type='text']
${dropdowlist_trangthai_gh}    //div[contains(@class, 'form-group')]//label[span[text()= 'Trạng thái giao hàng']]/..//span[contains(@class, 'form-control')]//span[span[text()='Chờ xử lý']]
${item_trangthai_gh}    //div[contains(@class, 'animation-container')]//div[contains(@class, 'list-scroller')]//li[text()='{0}']
${item_DTGH}      //div[contains(@class, 'output-complete')]//li[span[text()='{0}']]
${icon_calendarmini}    //div[contains(@class, 'form-group')]//label[span[text()= 'Thời gian giao hàng']]/..//span[contains(@class, 'picker-wrap')]//span[contains(@class, 'calendar')]
${cell_item_calendar}    //div[contains(@class, 'animation-container')]//div[contains(@data-role, 'calendar')]//table//tbody//tr//td[@role='gridcell']//a[@data-value='{0}']    # năm tháng ngày giao hàng
${button_luuy_close}    //div[div[div[delivery-warning-component]]]//..//div//span[contains(text(),'Close')]
${textbox_thu_tien_ho}    //span[contains(text(),'Tổng cần thu')]
${cell_dtgh_in_dropdown}    //div[@class='output-complete']//span[1]
${textbox_ghichu}     //div[contains(@class,'deliveryForm-left')]//textarea[@placeholder='Ghi chú']
${button_xong}    //div[contains(@class, 'formBox')]//div[contains(@class, 'k-footer')]//button[contains(@class, 'btn-success')]
${button_bo_qua}    //div[contains(@class, 'formBox')]//div[contains(@class, 'k-footer')]//button[contains(@class, 'btn-default')]

## giao vận
${checkbox_khaigia}   //div[contains(@class,'delivery-group')]//div[contains(@class,'wedget-delivery--list')]//span[text()=' Khai giá ']
${textbox_khaigia}    //div[contains(@class,'delivery-group')]//div[contains(@class,'wedget-delivery--list')]//span[text()=' Khai giá ']/..//input[@type='text']
${radiobutton_nguoinhantraphi}   //div[contains(@class,'delivery-group')]//span[text()='Người nhận trả phí']

${item_HVC}           //td[@class='tdTotal']
${ma_HVC}    (//tr[@style='']//td[@class='tdHVC']//div[@class='delivery-hvc--type']//span)[2]
${checkbox_HVC}    //div[span[contains(text(),'{0}')]]/..//div[@class='delivery-hvc--radio']//input
${text_nguoi_gui_tra_phi}    //div[@class="k-footer"]//span[contains(text(),'Người gửi trả phí: ')]//span
${cell_khuvuc}    //ul[@id='locationDeliery_listbox']//li[1]
${cell_phuongxa}    //ul[@id='wardDelivery_listbox']//li[1]
${hienthi}    //p[contains(text(),'Vui lòng cung cấp đầy đủ và chính xác khu vực nhận')]
