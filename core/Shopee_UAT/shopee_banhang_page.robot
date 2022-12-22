*** Variables ***
#form login
${textbox_shopee_taikhoan_bh}    //input[@placeholder="Email/Số điện thoại/Tên đăng nhập"]
${textbox_shopee_matkhau_bh}     //input[@placeholder='Mật khẩu']
${button_shopee_dangnhap}   //button[@type='button']
${button_quanly_donhang}      //div[@class='sidebar sidebar-fixed']//span[@class='sidebar-menu-item-text'][contains(text(),'Quản Lý Đơn Hàng')]
#form san pham
${cell_shopee_gia}      //div[contains(@class,'price-campaign-main')]
${cell_shopee_khohang}    //div[@class='product-list-item__td product-variation__stock']/div
