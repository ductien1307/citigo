*** Variables ***
${texbox_search_sx_mathang}    //input[@id='productSearchInput']
${button_hoanthanh}    //div[contains(@class, 'k-window-poup') and contains(concat(' ',normalize-space(@style),' '),' display: block; ')]//div[contains(@class, 'kv-window-footer')]//a[contains(text(), 'Hoàn thành')]
${item_hang_sx_in_dropdownlist}     //li[@ng-repeat="suggestion in suggestions track by $index"]//p
${textbox_ma_phieu_sx}      //input[@placeholder='Mã phiếu tự động']
${textbox_soluong_sx}     //input[@ng-model="manufacturing.Quantity"]
${textbox_ghi_chu_sx}     //textarea[@placeholder='Ghi chú...']
${checkbox_tudong_tru_tp}   //input[@ng-model="manufacturing.ReduceSecondaryComponent"]//..//a
