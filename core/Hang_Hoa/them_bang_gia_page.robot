*** Variables ***
${textbox_tenbanggia}    //div[contains(@class, 'k-window-priceBook')][1]//kv-tab-pane//label[text()='Tên bảng giá']/..//input
${button_them_banggia}    //a[contains(@title,"Thêm bảng giá")]//i
${button_luu_banggia}    //a[@ng-click="savePriceBook()"]
${button_chinhsua_banggia}    //a[@title="Sửa bảng giá"]//i
${button_dongy_xoa_bianggia}   //button[@ng-enter="onConfirm()"]
${button_xoa_bang_gia}    //div[@class="kv-window-footer"]//a[contains(text(),'Xóa')]
${dropdownlist_popup_chon_bang_gia}    //span[contains(text(),'---Chọn bảng giá---')]
${textbox_popup_bang_gia}    //div[@class='k-animation-container']//input[@class='k-textbox']
${item_bang_gia_indropdown_popup}    //div[@class='k-animation-container']//ul[@id='ParrentPriceBook_listbox']//li[contains(text(),'{0}')]
${cell_popup_bang_gia}    //span[@aria-owns="ParrentPriceBook_listbox"]
${button_tab_tihet_lap_nang_cao}    //a[contains(text(),'Thiết lập nâng cao')]
${button_popup_tru}    //a[@class='btn-toggle'][contains(text(),'-')]
${button_popup_cong}    //a[@class='btn-toggle active'][contains(text(),'+')]
${button_popup_giamgia_vnd}    //a[@class='btn-toggle'][contains(text(),'VND')]
${button_popup_giamgia_%}    //a[@class='btn-toggle active'][contains(text(),'%')]
${textbox_popup_nhap_gia_tri}    //input[@ng-model="pricebook.CalcValue"]
${button_popup_dongy_apdung}    //button[contains(@class,'btn-confirm')]
${button_popup_boqua_apdung}    //button[contains(@class,'btn-cancel')]
${button_dongy_xoa_banggia_all_cn}        //div[div[p[strong[contains(text(),'xóa hoàn toàn')]]]]//..//div//i[@class="fa fa-check"]
