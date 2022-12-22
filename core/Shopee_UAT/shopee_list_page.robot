*** Variables ***
#form dang nhap
${button_dangnhap_shopee}    //a[contains(text(),'Đăng nhập')]
${textbox_input_taikhoan_shopee}   //input[@placeholder="Email/Số điện thoại/Tên đăng nhập"]
${textbox_input_matkhau_shopee}     //input[@placeholder="Mật khẩu"]
${button_login_shopee}    //button[contains(text(),'Đăng nhập')]
${button_close_popup_shopee}      //div[@class="shopee-popup__close-btn"]
#
${tab_tatca_sanpham}    //span[contains(text(),'TẤT CẢ SẢN PHẨM')]
${textbox_search_timtrongshopnay}   //input[@class="shopee-searchbar-input__input"]
${item_sanpham_shopee}      //div[contains(text(),'{0}')]
${label_giaban_sanpham}     //div[@data-cy="Item_price_after_promotion_pdp"]
${button_add_themvao_giohang}   //span[contains(text(),'thêm vào giỏ hàng')]
${textbox_input_soluong_trang_sp}      //input[@data-cy="Item_quantity_value_pdp"]
${label_add_sp_thanhcong}     //div[contains(text(),'Sản phẩm đã được thêm vào Giỏ hàng')]
${checkbok_chon_hanghoa}      //a[@title="{0}"][@class="cart-item-overview__name"]/../../..//..//div[@class="cart-item__cell-checkbox"]//div[@class="stardust-checkbox__box"]
${textbox_input_soluong}    //a[@title="{0}"][@class="cart-item-overview__name"]/../../..//..//div[@class="cart-item__cell-quantity"]//input
${button_checkout_muahang}   //span[contains(text(),'Mua hàng')]
${button_dathang_shopee}   //button[contains(text(),'Đặt hàng')]
${tab_choxacnhan}     //span[contains(text(),'Chờ xác nhận')]
#
${textbox_acc_seller_shopee}    //input[@placeholder="Email / Phone / User"]
${textbox_password_seller_shopee}     //input[@placeholder='Password']
${button_login_seller_shopee}     //button[contains(@class,'shopee-button login-btn')]
${box_quocgia}    //div[@class="shopee-select"]//div[contains(@class,'shopee-input__inner')]
${item_quocgia_vietnam}     //div[contains(text(),'Vietnam')]
${button_comfirm_authorization}     //span[contains(text(),'Confirm Authorization')]
${box_app_quocgia}    //p[@class='region-name']
${textbox_app_tk_shopee}      //div[@class='login-form-mobile']//div[@class='username-item form-item']//input
${textbox_app_mk_shopee}      //div[@class='login-form-mobile']//input[@placeholder='Password']
${item_app_quocgia_vietnam}   //p[normalize-space()='Vietnam']
${button_app_login_shopee}      //div[@class='login-form-mobile']//button[2]
