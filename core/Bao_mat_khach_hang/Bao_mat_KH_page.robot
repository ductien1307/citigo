*** Variables ***
${textbox_tennguoidung}    //input[@id='GivenName']
${textbox_tendangnhap}    //div[label[text()='Tên đăng nhập']]//input
${textbox_dienthoai}    //div[@id='userForm']//div[label[text()='Điện thoại']]//input
${textbox_ngaysinh}   //input[@id='datepickerDOB']
${textbox_email}    //div[contains(@class,'col-md-6')][1]//div[label[text()='Email']]//input
${textbox_diachi}    //div[label[text()='Địa chỉ']]//input
${textbox_khuvuc}    //div[@id='userForm']//input[@id='wardSearchInput']
${label_device_info}    //table[@id='dtUserDevice']//tr[1]//a[text()='Đang hoạt động']/..//strong
${button_delete_device}   //table[@id='dtUserDevice']//tr[1]//button[@ng-click='deleteDevice(item)']
${button_confirm_popup_ngungtruycap}  //button[@ng-enter='onConfirm()']
${button_luu_bmkh}   //div[contains(@class,'kv-window-footer')]//a[text()='Lưu (F9)']
${button_boqua}   //div[@id='userForm']//a[text()='Bỏ qua']
##change pass
${button_chinhsua}    //div[contains(@class,'setting-row')]//div[b[text()='Đổi mật khẩu']]//button[contains(@class,'btn-change')]
${textbox_current_pass}   //input[@id='CurrentPassword']
${textbox_new_pass}   //input[@placeholder='Nhập mật khẩu mới']
${textbox_new_pass_again}   //input[@placeholder='Gõ lại mật khẩu mới']
${button_save_change_pass}    //div[contains(@class,'form-submit')]//button[contains(@class,'btn-save')]
${button_close_change_pass}   //h3[contains(@class,'show-change')]//button
###import hoa don cho kyc4
${button_accept_import}    //div[contains(@style,'display: block')]//button[@class='btn-confirm btn btn-success']
${label_imp_success}     //span[@class='ng-binding txtBlue'][.='Import thành công. Nhấn phím F5 để thấy dữ liệu mới nhất.']
${cell_imp_inv_code}    (//span[starts-with(text(),'HDIP0.')])[1]
