*** Settings ***
Library           SeleniumLibrary

*** Variables ***
${button_close_hoadon1}    //div[contains(@class, 'content-tab')]//kv-scroll-tab-pane/li/a[span[contains(text(), 'Hóa đơn 1')]]//../span[@title='Đóng']
${tab_hoadon1}    //div[contains(@class, 'content-tab')]//kv-scroll-tab-pane/li/a[span[contains(text(), 'Hóa đơn 1')]]
${textbox_dh_search_ma_sp}    //*[@id='productSearchInput']
${textbox_dh_soluong}    //div[contains(@class, 'row-product')]//input[contains(@class, 'form-control')]
${button_dh_giamoi}    //div[contains(@class, 'row-product')]//div[contains(@class, 'cell-change-price')]//button[contains(@class, 'form-control')]
${textbox_dh_giamoi}    //div[contains(@class, 'popover-inner')]//div[contains(@class, 'form-group') and ./label[span[text()='Giá mới']]]//input[@type='text']
${textbox_dh_giamgia_sp}    //div[contains(@class, 'popover-inner')]//div[contains(@class, 'form-group') and ./label[span[text()='Giảm giá']]]//input[@type='text']
${cell_dh_thanhtien}    //div[contains(@class, 'row-list')][{0}]//div[contains(@class, 'cell-price')]
${button_dh_giamgia_sp%}    //div[contains(@class, 'popover-inner')]//div[contains(@class, 'form-output kv-toggle')]//kv-toggle/a[contains(@class, 'toggle-btn') and text()='%']
${tab_dathang}    //div[contains(@class,'kv-tabs')]//ul//li//a[text()='Đặt hàng']
${button_bh_dathang}    //div[contains(@class, 'wrap-button')]//button[text()='Đặt hàng (F9)']
##
${textbox_dh_search_khachhang}    //*[@id='customerSearchInput']
${cell_dh_tongtienhang}    //payment-order-component//div[contains(@class, 'payment-component')]//div[contains(@class, 'form-group') and ./label[span[contains(text(), 'Tổng tiền hàng')]]]//div[contains(@class, 'form-output')]
${textbox_dh_khachtt}    //*[@id='payingAmtOrder']
${cell_surcharge_order}    //a[@id='btnSurchargeOrder']
${button_dh}      //button[@id='saveOrder' and contains(@class, 'success')]
${cell_dh_ma_sp}    //div[contains(@class, 'product-cart-list')]//div[contains(@class, 'row-list')][1]//div[contains(@class, 'cell-code')]
${button_luu_order}    //button[@id='updateOrder']
${cell_tongtienhang}    //div[contains(@class, 'payment-component')]//div[text()='Tổng tiền hàng']/..//div[contains(@class, 'control-static')]
${text_ghichu}    //textarea[@id='note']
${cell_order_code_in_BH_form}   //div[contains(@class, 'col-right ')]//div[text()='{0}']    #ma dat hang
# xpath for multi product
${button_taohoadon}    //div[contains(@class, 'no-print-button')]//button[text()='Tạo hóa đơn']
${button_confirm}    //div[contains(@class, 'window-danger')]//div//span[text()='Kết thúc đơn đặt hàng']/..//..//div[contains(@class, 'footer')]//button[contains(@class, 'btn-confirm')]    # popup kết thúc đơn hàng
${button_cancel}    //div[contains(@class, 'window-danger')]//div//span[text()='Kết thúc đơn đặt hàng']/..//..//div[contains(@class, 'footer')]//button[contains(@class, 'btn-cancel')]    # popup kết thúc đặt hàng
${cell_thanhtien}    //div[contains(@class, 'row-list')]//div[contains(@class, 'row-product')]//div[contains(@class, 'cell-price')]
${cell_tongsoluong_dh}    //payment-order-component//span[@class='badge']
#khuyen mai
${button_promo_order}    //payment-order-component//div[contains(text(),'Tổng tiền hàng')]//cart-promotions-component//button
${icon_promo_sale_order}    //payment-order-component//div[contains(@class, 'payment-component')]//div[contains(@class, 'form-group') and ./label[contains(text(), 'Giảm giá')]]//span[@class='badge km']
${icon_dongy_reset_promo}   //a[@id ='getAvaiablePromotionLinkLabel']
${button_multi_promo_order_payment}    //payment-order-component//i[@class='fa fa-gift']
## khach le
${button_dongy_popup_nocustomer}    //div[contains(@class,'window-danger')]//button[text()='Đồng ý']
# phuong thuc
${button_dh_khachtt}   //payment-order-component//i[@class='fa fa-credit-card']
${button_dh_phuongthuc_tt}    //button[@class='btn btn-border']//span[contains(text(),'{0}')]    #0: Tiền mặt, Thẻ, Chuyển khoản
${textbox_dh_sotien_khachtt}    //input[@id='txtCurrentAmount']
${button_dh_khachthanhtoan}   //payment-order-component//button[@ng-click="vm.openMultiPaymentsForm()"]
${button_dh_phuongthuc_tt}    //input[@id='txtCurrentAmount']
${cell_dh_tk_nhan}    //span[contains(text(),'Tài khoản nhận')]
${item_dh_tk_nhan_in_dropdowlist}   //b[text()='{0}']     #0: so tai khoan
${button_dh_pttt_xong}    //button[contains(text(),'Xong')]
