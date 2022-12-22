*** Variables ***
#quanly
${button_mykiot_dongbo_thucong}    //i[@class='fas fa-sync']
${button_mykiot_hanghoa}   //span[normalize-space()='Hàng hóa']
${button_mykiot_xem_hanghoa}    //td[span[normalize-space()='{0}']]//..//td//a[@title="Xem hàng hóa"]
${textbox_mykiot_nhap_mahang}    //input[contains(@placeholder,'Nhập tên hàng hóa cần tìm...')]
${cell_mykiot_ma_hanghoa}   //span[normalize-space()='{0}']
${cell_mykiot_tonkho}   //td[span[normalize-space()='{0}']]//..//td[5]
${cell_mykiot_giaban}   //td[span[normalize-space()='{0}']]//..//td[7]
${button_mykiot_xemngay}    //td[span[normalize-space()='{0}']]//..//td//a[@title="Xem hàng hóa"]
${text_mykiot_ma_dathang_first}   //tbody/tr[1]//td[1]

#Banhang
${button_mykiot_muangay}    //button[@class='btn btn-secondary']
${checkbox_mykiot_diachi_nhanhang_first}    //div[p[contains(text(),'Quý khách vui lòng lựa chọn chi nhánh đến nhận hàn')]]/div[1]//label
${textbox_mykiot_ten_nguoinhan}   //div[@class='order-info-address']//input[@class='mk-form-control'][not(@onkeypress)]
${textbox_mykiot_sdt}   //div[@class='order-info-address']//input[@onkeypress]
${button_mykiot_dathang}    //div[@class='card-checkout-item card-checkout-action']//button
${button_mykiot_tieptuc_muahang}   //a[contains(@class,'btn-continue')]

#Loading
${icon_loading}   //div[@class='loader']
