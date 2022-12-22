*** Variables ***
${item_banggia_indropdown}    //div[@id='multiselectPriceBooks-list']//span[contains(text(),'{0}')]
${select_hanghoa_in_bangia}    //div[@id='idProductCatTreeAll']//i[@class='fa fa-long-arrow-right']
${textbox_giamgia_in_banggia}    //kv-popup[@id='calcPriceItem']//input[@type ='text']
${checkbox_giamgia}    //kv-popup[@id='calcPriceItem']//div[contains(@class, 'prettycheckbox')]//a
${checkbox_apdung_banggia}    //a[@class="checked"]
${textbox_nhap_ten_banggia}    //input[@ng-model="pricebook.Name"]
${textbox_tlg_timkiem_nhomhang}    //input[@placeholder='Tìm kiếm nhóm hàng']
${button_them_nhomhang_vao_banggia}    //span[contains(text(),'{0}')]/..//a//i    # 0: tên nhóm hàng
${button_them_tatca_nhom}    //div[contains(text(),'Tất cả')]//a//i
${cell_tlg_tennhom}    //span[contains(text(),'{0}')]    # 0: ten nhom
${cell_tlg_tatca_nhomhang}    //div[contains(text(),'Tất cả')]
${textbox_themhh_vao_banggia}    //input[@placeholder="Thêm hàng hóa vào bảng giá"]
${item_hh_in_dropdown}    //aside[contains(@ng-show,"SelectedPriceBookId!")]//li[1]
${cell_bg_mahh}    //span[contains(text(),'{0}')]
${cell_bg_giavon}    //td[span[contains(text(),'{0}')]]//..//td[@class='cell-total ng-binding' and not(@style="display:none")]    # 0: ma hh
${cell_bg_giachung}    //td[span[contains(text(),'{0}')]]//..//td//span[contains(@ng-bind,"dataItem.BasePrice|formatProductPrice")]    # 0: mahh
${cell_bg_dongia_nhapcuoi}    //td[span[contains(text(),'{0}')]]//..//td[contains(@class,"cell-total cell-total--input ng-binding")]    # 0: mahh
${cell_bg_giia_ss}    //li[contains(text(),'{0}')]
${button_bg_tru}    //a[contains(text(),'-')]
${button_bg_giamgia_%}    //a[contains(text(),'%')]
${textbox_bg_giamoi}    //td[span[contains(text(),'{0}')]]//..//td//input[@ng-show="dataItem.Pb1 >= 0"]
${button_bg_giamgia_VND}    //a[contains(text(),'VND')]
${textbox_bg_nhap_gg}    //div[@ng-controller="CalcPriceCtrl"]//input[@type='text']
${checkbox_bg_apdungallsp}    //div[contains(@class,'priceBookPop')]//div[contains(@class,'prettycheckbox')]//a
${textbox_bg_search_hh}    //input[@placeholder="Theo mã, tên hàng (F3)"]
${button_xoa_sp_khoi_banggia}    //td[span[contains(text(),'{0}')]]//..//td//a
${button_dongy_xoa_hh_khoi_bg}    //button[text()='Đồng ý']
${dropdownlist_chon_bang_gia}    //span[contains(text(),'---Chọn bảng giá---')]
${button_dongy_giamoi}    //a[contains(@ng-click,'applyPrice()')]
${textbox_nhap_bang_gia}    //div[@id='comboPriceBookPerItem-list']//input
${button_dongy_thietlap_gia}    //button[contains(@class,'btn-confirm')]
${button_boqua_thietlapgia}    //button[contains(@class,'btn-cancel')]
${cell_banggia_duoc_chon}    //span[@aria-owns="comboPriceBookPerItem_listbox"]//span[contains(@class,'k-input')]
${button_xoa_banggiachung}    //span[contains(text(),'delete')]
${textbox_chon_bang_gia}    //input[contains(@aria-owns,'multiselectPriceBooks')]
${cell_chon_bang_gia}    //ul[@id='multiselectPriceBooks_taglist']
${textbox_tlg_tim_ma_hang}      //input[@placeholder='Tìm mã hàng']
${cell_tlg_ma_sp}     //td[@class='cell-code']
