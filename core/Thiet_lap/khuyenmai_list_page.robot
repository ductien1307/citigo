*** Variables ***
${textbox_promotion_code}      //input[@placeholder='Mã tự động']
${textbox_promotion_name}      //input[@placeholder='Tên chương trình khuyến mại']
${checkbox_promotion_kichhoat}      //div[contains(@kendo-window, 'myKendoWindow')]//div[contains(@class, 'form-group') and ./label[text()='Trạng thái']]//aside//label[text()='Kích hoạt']
${checkbox_promotion_chuaapdung}      //div[contains(@kendo-window, 'myKendoWindow')]//div[contains(@class, 'form-group') and ./label[text()='Trạng thái']]//aside//label[text()='Chưa áp dụng']
${tab_hinhthuc_khuyenmai}     //kv-tabs[@id='pro_tabs']//div[contains(@class,'kvTabs')]//a[text()='Hình thức khuyến mại']
${tab_thoigian_apdung}     //kv-tabs[@id='pro_tabs']//div[contains(@class,'kvTabs')]//a[text()='Thời gian áp dụng']
${tab_phamvi_apdung}     //kv-tabs[@id='pro_tabs']//div[contains(@class,'kvTabs')]//a[text()='Phạm vi áp dụng']
${button_promotion_save}    //div[contains(@class,'kv-window-promotion')]//div[@kendo-window ='myKendoWindow']//a[@ng-click='vm.onSave()']
${button_promotion_cancel}    //div[contains(@class,'kv-window-promotion')]//div[@kendo-window ='myKendoWindow']//a[text()='Bỏ qua']
${textbox_search_promo}   //input[@placeholder='Theo mã, tên chương trình']
${checkbox_filter_trangthai_tatca}    //article[contains(@class,'leftStatus') and ./h3[contains(text(), 'Trạng thái ')]]//label[text()='Tất cả']
${button_capnhat_promo}   //article[contains(@class,'kv-group-btn')]//a[text()=' Cập nhật']
${button_delete_promo}   //article[contains(@class,'kv-group-btn')]//a[text()=' Xóa']
#tab hinh thuc khuyen mai
${dropdown_khuyenmaitheo}   //kv-tab-pane[1]//div[contains(@class,'form-group') and ./label[strong[text()='Khuyến mại theo']]]//span[contains(@class,'k-widget')]
${dropdown_hinhthuc}   //kv-tab-pane[1]//div[contains(@class,'form-group') and ./label[strong[text()='Hình thức']]]//span[contains(@class,'k-widget')]
${cell_item_dropdown}  //div[contains(@class,'k-animation-container')]//li[text()='{0}']   #value khuyen mai and value hinh thuc
##xpath dung chung
${textbox_tongtienhang}   //div[contains(@class,'promotion-conditions')]//div[contains(@class,'wrap-label')]//input[@type='text']
${textbox_giatriKM}   //div[contains(@class,'promotion-conditions')]//div[contains(@class,'input-group')]//input[@type='text']
${button_giamgia_%}   //div[contains(@class,'promotion-conditions')]//div[contains(@class,'window-wrap-table')]//a[text()='%']
${button_giamgia_vnd}   //div[contains(@class,'promotion-conditions')]//div[contains(@class,'window-wrap-table')]//a[text()='VND']
${icon_delete}    //div[contains(@class,'promotion-conditions')]//td[contains(@class,'action')]//a//i
${button_themdieukien}   //div[contains(@class,'promotion-conditions')]//div[contains(@class,'form-group')]//button
${textbox_soluong_hh}   //div[contains(@class,'promotion-conditions')]//td[contains(@class,'hang-nhom')]//input[@type='text']
${textbox_chonhang}   //div[contains(@class,'promotion-conditions')]//span[1]//input[@role='listbox']
${button_menu_hangtang}   //div[contains(@class,'promotion-conditions')]//td[contains(@class,'hang-nhom')]//button[@type='button']
${checkbox_item_nhomhang_inpopup}  //div[contains(@class,'scroll-content')]//span[text()='{0}']     #nhom hang
${button_xong_in_popup}     //div[contains(@class,'kv-window-footer')]//a[text()='Xong']
${button_cancel_in_popup}     //a[@ng-click='vm.cancel()']
${button_xoatatca_in_popup}     //div[contains(@class,'select-group-product__removeAll')]//a[text()='Xóa chọn tất cả']
${icon_clear_category}    //div[contains(@class,'promotion-conditions')]//span[text()="delete"]
##table hàng hóa - mua hàng tặng hàng
${checkbox_khongnhantheosl}   //kv-tab-pane[1]//div[contains(@class,'form-inline')]//text[text()='Hàng giảm giá không nhân theo SL mua.']
${textbox_hang_mua}   //div[contains(@class,'promotion-conditions')]//input[@ng-model='condition.PrereqQuantity']
${textbox_chonhangmuatang}   //div[contains(@class,'promotion-conditions')]//kv-promotion-rule-entity[@kv-rule-entity='PrereqRuleEntity']//span[1]//input[contains(@class,'k-input k-readonly')]
${button_menu_mua_hangtang}   //div[contains(@class,'promotion-conditions')]//kv-promotion-rule-entity[@kv-rule-entity='PrereqRuleEntity']//button[@type='button']
${textbox_hang_giamgia}   //div[contains(@class,'promotion-conditions')]//input[@ng-model='condition.ReceivedQuantity']
${textbox_chonhangtang_gg}   //div[contains(@class,'promotion-conditions')]//kv-promotion-rule-entity[@kv-rule-entity='PrereqRuleEntity']//span[1]//input[contains(@class,'k-input k-readonly')]
${button_menu_hangtang_gg}   //div[contains(@class,'promotion-conditions')]//kv-promotion-rule-entity[@kv-rule-entity='ReceivedRuleEntity']//button[@type='button']
##table hàng hóa - gia ban theo so luong mua
${textbox_soluongtu}   //kv-tab-pane[1]//div[contains(@class,'form-group') and ./label[strong[text()='Số lượng từ']]]//input[@type='text']
${dropdown_giaban}   //div[contains(@class,'promotion-conditions')]//td[contains(@class,'hang-nhom-larg')]//span//span[text()='Giá bán']
${textbox_soluongtu}   //div[contains(@class,'promotion-conditions')]//td[contains(@class,'hang-nhom-larg')]//input[@ng-model='item.DiscountPrice']
${link_themdong}   //div[contains(@class,'promotion-conditions')]//td[contains(@class,'hang-nhom-larg')]//a[text()=' Thêm dòng']
##pop up confirm delete promo
${button_dongy_del_promo}   //button[@ng-enter='onConfirm()']
